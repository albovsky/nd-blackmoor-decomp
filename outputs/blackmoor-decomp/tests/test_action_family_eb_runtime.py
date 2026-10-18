"""RT-56: raw 0xeb Multibuild puzzle runtime (src/action_family_eb_runtime.c) and its session binding (src/session_bindings_aeb.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x480e02, 0x47e582, 0x47f421, 0x47fd65, 0x47ff0e, 0x47ef0f,
0x480b34, 0x481cb9 and 0x42ba3a; the byte-level comparison against the original code is the separate oracle):
 * phase 0 builds the piece instances of every type (the type's surface entries are made when the instance index equals the
   type), restores the saved puzzle state when the persist byte, the saved flag and the scene allow it, and acquires the generic z
   entry; phase 1 is an inner state machine on obj+0x13ca (wait, win wait, animation, animation delay, win sound); phase 2 stops
   the sounds, applies the exit or win scene block, calls the generic completion and cleans up;
 * the pointer hit-tests the pieces (pick candidates, rotate zones), moves a dragged piece (clamped, translated, overlap checked
   against the previous rectangle) and reports the exit buttons; the release picks, spawns copies of Multi_Piece types, drops
   (good, bad, mode 2), rotates and saves the state; the second button rotates; the render callback blits the pieces;
 * the binding owns the singleton, the saved puzzle state and one copy of every row body of the loaded scene.
The unit cases live in tests/action_family_eb_runtime_test.c (synthetic bodies, no original bytes). The corpus run feeds the two real
rows (resources 1600 and 2305, local evidence in work/) through the production parser, the binding and the kernel. The original-x86
oracle is a separate script (tests/test_action_family_eb_runtime_oracle.py; it needs the private work/ evidence and Unicorn).

The mutation sweep is generated from the current source: every comparison, logical, arithmetic and bitwise operator, every integer
literal, every `if`/`while` condition (forced true and forced false) and every simple statement of the kernel and the binding is
mutated once, and the unit cases must fail on each. A mutant that survives must be listed in EQUIVALENT_RULES with the reason it cannot
change observable behaviour, or in ORACLE_KILLED when the original-x86 oracle (tests/action_family_eb_runtime_original_oracle.py)
reports a mismatch for it (the oracle is a separate, slower check: a mutated copy of the kernel is rebuilt into the driver library and
compared with the unmodified GAME.EXE image over all scenarios).
"""
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_eb_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_eb_runtime_corpus.c'
KERNEL = 'action_family_eb_runtime.c'
BINDING = 'session_bindings_aeb.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
MUTATED_FILES = [KERNEL, BINDING]
ORACLE = PROJECT / 'tests/action_family_eb_runtime_original_oracle.py'
EXPECTED_UNIT_TESTS = 39
RESOURCES = PROJECT.parents[1] / 'work/analysis/hiff-resources'
SANITIZE = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined']


def compiler():
    # The repo scripts call `xcrun clang` for macOS; where xcrun is absent (cloud container) use clang, cc or gcc.
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc') or shutil.which('gcc')


def compile_c(output, main_c, sources, src_dir=SRC, extra=(), optimize='-O1', cc=None):
    cmd = [cc or compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', optimize, '-g', f'-I{src_dir}', *extra, str(main_c),
           *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary, env=None):
    done = subprocess.run([str(binary)], capture_output=True, text=True, env=env)
    results = {}
    for line in done.stdout.splitlines():
        status, _, rest = line.partition(' ')
        if status in ('PASS', 'FAIL'):
            name, _, message = rest.partition(': ')
            results[name] = (status, message)
    return done.returncode, results


# --- the mutation generator ------------------------------------------------------------------------------------------------------
STRING = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'')
TOKEN = re.compile(r'==|!=|<=|>=|<<|>>|->|&&|\|\||<|>')
RELATIONAL = {'==': ['!='], '!=': ['=='], '<': ['<=', '>='], '<=': ['<', '>'], '>': ['>=', '<='], '>=': ['>', '<'],
              '&&': ['||'], '||': ['&&']}
BINARY = {' + ': [' - '], ' - ': [' + '], ' * ': [' + '], ' / ': [' * '], ' % ': [' / '], ' & ': [' | '], ' | ': [' & '],
          ' << ': [' >> '], ' >> ': [' << '], ' += ': [' -= ']}
LITERAL = re.compile(r'(?<![\w.])(0x[0-9a-fA-F]+|\d+)(u?)(?![\w.])')
STATEMENT = re.compile(r'^\s*(?:(?:wr_16|wr_32|HOST|CHECK|memcpy|memset|copy_rect|hand_size|write_candidate|set_layer|plan_blit|'
                       r'sync_scene|free|translate|clamp_rect)\(.*\)|[A-Za-z_][\w\->.\[\]() +*]* (?:=|\+=|-=) .*);\s*$')
NO_STATEMENT = ('return', 'const', 'int', 'uint', 'char', 'static', 'goto', 'break', 'continue', 'case', 'default', 'Eb', 'size_t',
                'for', 'while', 'if', 'else', 'typedef', 'struct', 'enum', 'SceneAction', 'Aeb', 'SessionAeb', 'void')


def code_lines(text):
    """(line number, line) of the lines that hold executable code: not comments, preprocessor lines, enum or struct bodies."""
    skipping = False
    in_comment = False
    for number, line in enumerate(text.split('\n'), 1):
        stripped = line.strip()
        if in_comment:
            in_comment = '*/' not in stripped
            continue
        if stripped.startswith('/*'):
            in_comment = '*/' not in stripped
            continue
        if skipping:
            skipping = not stripped.startswith('}')
            continue
        if re.match(r'^(typedef\s+)?(enum|struct)\b.*\{\s*$', stripped) or re.match(r'^typedef\b.*\{\s*$', stripped):
            skipping = True
            continue
        if re.match(r'^enum\s*\{.*\};\s*$', stripped):
            continue
        if not stripped or stripped.startswith(('#', '//', '*')):
            continue
        yield number, line


def split_comment(line):
    masked = STRING.sub(lambda m: 'X' * len(m.group(0)), line)
    cut = len(line)
    for marker in ('/*', '//'):
        at = masked.find(marker)
        if at != -1:
            cut = min(cut, at)
    return line[:cut], masked[:cut], line[cut:]


def matching_paren(masked, open_at):
    depth = 0
    for i in range(open_at, len(masked)):
        if masked[i] == '(':
            depth += 1
        elif masked[i] == ')':
            depth -= 1
            if depth == 0:
                return i
    return -1


def line_mutants(line):
    """(operator, occurrence, mutated line) for one source line."""
    code, masked, comment = split_comment(line)
    out = []

    def emit(op, occ, new_code):
        if new_code != code:
            out.append((op, occ, new_code + comment))

    for occ, m in enumerate(TOKEN.finditer(masked)):
        for new in RELATIONAL.get(m.group(0), ()):
            emit(f'op {m.group(0)}->{new}', occ, code[:m.start()] + new + code[m.end():])
    for symbol, replacements in BINARY.items():
        start = 0
        occ = 0
        while True:
            at = masked.find(symbol, start)
            if at == -1:
                break
            for new in replacements:
                emit(f'op{symbol}->{new}', occ, code[:at] + new + code[at + len(symbol):])
            start = at + 1
            occ += 1
    for occ, m in enumerate(LITERAL.finditer(masked)):
        text = m.group(1)
        value = int(text, 16) if text.startswith('0x') else int(text)
        fmt = (lambda v: f'0x{v:x}') if text.startswith('0x') else str
        targets = {value + 1}
        if value >= 1:
            targets.add(value - 1)
        for t in sorted(targets):
            emit(f'lit {text}->{fmt(t)}', occ, code[:m.start(1)] + fmt(t) + code[m.end(1):])
    for occ, m in enumerate(re.finditer(r'\b(?:if|while)\s*\(', masked)):
        open_at = m.end() - 1
        close_at = matching_paren(masked, open_at)
        if close_at == -1:
            continue
        for forced in ('1', '0'):
            emit(f'cond forced {forced}', occ, code[:open_at + 1] + forced + code[close_at:])
    stripped = code.strip()
    if STATEMENT.match(code) and not stripped.startswith(NO_STATEMENT):
        emit('statement removed', 0, code[:len(code) - len(code.lstrip())] + '(void)0;')
    return out


def generate(filename, text=None):
    text = (SRC / filename).read_text() if text is None else text
    lines = text.split('\n')
    seen = {}
    mutants = []
    for number, line in code_lines(text):
        ordinal = seen.get(line.strip(), 0)
        seen[line.strip()] = ordinal + 1
        for op, occ, new_line in line_mutants(line):
            key = f'{filename}|{line.strip()}|#{ordinal}|{op}|{occ}'
            mutants.append((key, filename, number, new_line))
    return mutants, lines


def all_mutants():
    jobs = []
    for filename in MUTATED_FILES:
        mutants, _ = generate(filename)
        jobs.extend(mutants)
    return jobs


# Mutants no observable behaviour can distinguish. Each rule is (regular expression over the mutant key, reason); a key is
# "file|source line|#ordinal of identical lines|operator|occurrence". The rules are deliberately narrow: they name the line.
def _lit(line):
    return re.escape(line)


def _k(line, op=r'[^|]+', occ=r'\d+', ordinal=r'\d+', filename=KERNEL):
    """A regular expression for the keys of one source line (any operator, occurrence and ordinal unless given)."""
    return rf'^{re.escape(filename)}\|{re.escape(line)}\|#{ordinal}\|{op}\|{occ}$'


def _any(*patterns):
    return '(?:' + '|'.join(patterns) + ')'


MINUS = r'op \+ -> - '
LIT = r'lit \d+->\d+'
ARRAY_PARAMETER = ('a C array parameter is a pointer: the size in the declarator is ignored')
LOCAL_ARRAY = ('the declared size is larger than the four (three, eight) elements the function indexes: a bigger local array holds them all')
HOST_OUT = ('the initial value of an out-parameter that the host call assigns whenever it returns 0; a failing host call returns before the '
            'value is read')
EQUAL_VALUES = ('when the two compared values are equal the conditional expression yields the same value from either side')
PIECE_ENTRY = ('the entry rectangle is written (left and top 0, right and bottom size - 1) from the zeroes just stored, so a misaligned '
               'read of the top word still reads the zero written one statement before')

EQUIVALENT_RULES = [
    # --- offsets that are zero: `x + CONST` and `x - CONST` are the same address
    (_any(_k('if (rd_s16(obj, P + P_Z) == layer) {', MINUS),
          _k('if (rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)) best = cand;', MINUS),
          _k('int16_t z = rd_s16(obj, piece_off(i) + P_Z);', MINUS),
          _k('const int16_t zj = rd_s16(obj, piece_off(found[k]) + P_Z);', MINUS),
          _k('wr_16(obj, P + P_Z, 0);', MINUS),
          _k('wr_16(obj, piece_off(i) + P_Z, z);', MINUS),
          _k('wr_16(obj, piece_off(i) + P_Z, (int16_t)(rd_s16(obj, piece_off(i) + P_Z) + 1));', MINUS, occ='[01]')),
     'P_Z (the z word of a piece instance) is offset 0, so `P + P_Z` and `P - P_Z` are the same address'),
    (_any(_k('wr_32(obj, E0 + ENT_SURF, (int32_t)surf);', MINUS),
          _k('wr_32(obj, ent + ENT_SURF, (int32_t)s2);', MINUS),
          _k('if (rd_s32(obj, e + ENT_SURF) != 0) {', MINUS),
          _k('wr_32(obj, e + ENT_SURF, 0);', MINUS),
          _k('HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, e + ENT_SURF)));', MINUS),
          _k('HOST(host->copy_surface(host->context, s2, (uint32_t)rd_s32(obj, prev + ENT_SURF)));', MINUS),
          _k('plan_blit(plan, 1, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);', MINUS),
          _k('for (unsigned k = 0; k < 4; ++k) wr_32(obj, entry_off(t, k) + ENT_SURF, 0);', MINUS)),
     'ENT_SURF (the surface handle of an entry) is offset 0, so `entry + ENT_SURF` and `entry - ENT_SURF` are the same address'),
    (_any(_k('rect_at(body, T + BT_A, src);', MINUS),
          _k('if (rect_valid(body, T + BT_A)) {', MINUS),
          _k('for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, T + BT_A + (size_t)k * 4u);', MINUS, occ='0')),
     'BT_A (the source rectangle of a type) is offset 0, so `T + BT_A` and `T - BT_A` are the same address'),
    (_k('HOST(host->load_surface(host->context, (const char *)body + B_NAME, TAG_PIECE_SRC, &s));', MINUS),
     'B_NAME (the source image name) is offset 0 of the body'),
    # --- array declarators
    (_any(_k('const int32_t dst[4])', LIT), _k('const int32_t rect[4], const EbHost *host, EbPointerResult *out)', LIT),
          _k('static void plan_blit(EbRenderPlan *plan, uint8_t kind, uint8_t src_kind, uint32_t surface, const int32_t src[4],', LIT),
          _k('static void rect_at(const uint8_t *b, size_t off, int32_t out[4])', LIT),
          _k('static void xlate(const EbView *v, const int32_t in[4], int32_t out[4])', LIT),
          _k('int session_aeb_pointer_move(SessionAebBinding *binding, int16_t x, int16_t y, const int32_t rect[4], EbPointerResult *out)',
             LIT, filename=BINDING)),
     ARRAY_PARAMETER),
    (_any(_k('int32_t src[4], dst[4], moved[4];', 'lit 4->5'), _k('int32_t src[4];', 'lit 4->5'),
          _k('int32_t src_rect[4], dst_rect[4];', 'lit 4->5'), _k('char buf[208];', 'lit 208->209'),
          _k('static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_BAD, B_SND_ROT};', 'lit 4->5'),
          _k('static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_ROT, B_SND_BAD};', 'lit 4->5'),
          _k('static const size_t surfaces[3] = {O_SRC, O_MULTI, O_ANIM};', 'lit 3->4')),
     LOCAL_ARRAY + ' (the caption buffer needs at most 208 bytes: show_caption refuses text that does not fit its local_bytes <= 208)'),
    # --- initial values and flag values
    (_any(_k('uint32_t s = 0;', 'lit 0->1'), _k('uint32_t s2 = 0;', 'lit 0->1'), _k('uint32_t surf = 0;', 'lit 0->1'),
          _k('int16_t rw = 0, rh = 0;', 'lit 0->1'), _k('int32_t busy = 0;', 'lit 0->1'), _k('int32_t enabled = 0;', 'lit 0->1')),
     HOST_OUT),
    (_any(_k('int at_home = 1;', 'lit 1->2'), _k('x_hit = 1;', 'lit 1->2'), _k('y_hit = 1;', 'lit 1->2'), _k('return 1;', 'lit 1->2'),
          _k('CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 1, host));', 'lit 1->2')),
     'a flag only tested against zero (the boolean results of instances_sane and near_unplaced, the hit flags, the forced argument): 1 and 2 behave the same'),
    # --- equal operands
    (_any(_k('bo = bb < ab ? bb : ab;', 'op <-><='), _k('r = br < ar ? br : ar;', 'op <-><='), _k('z = zj < z ? z : zj;', 'op <-><=')), EQUAL_VALUES),
    # --- stores that are overwritten or repeated
    (_any(_k('wr_16(obj, O_TOTAL, 0);', _any('lit 0->1', 'statement removed'))),
     'dead store: save_and_check overwrites O_TOTAL with the computed total before it can return or be read'),
    (_any(_k('wr_32(obj, O_DRAG, 0);', _any('lit 0->1', 'statement removed'), ordinal='2'),
          _k('wr_32(obj, O_DRAG, 0);', 'statement removed', ordinal='3')),
     'phase 0 stores O_DRAG = 0 twice with only the O_HAND store between them: either store alone gives the same state (the first with 1 is overwritten by the second)'),
    (_k('out->cursor_flag = 0;', 'statement removed'),
     'write_candidate is only called after eb_pointer_move cleared the whole result, so the flag is already 0'),
    (_k('memset(obj + O_COUNTS, 0, 20);', 'lit 20->21'),
     'the 21st byte is the first byte of the instance array, which the memset on the line before already cleared'),
    (_k('j = rd_s16(obj, O_COUNT);', 'statement removed'),
     'the early exit of the overlap scan: after the first overlapping piece O_HIT is 0 and the remaining iterations can only store 0 again'),
    (_k('for (size_t k = 0; k < 40u; k += 4u) wr_32(obj, O_LIST1 + k, 0);', 'lit 40->39'), 'k takes the values 0..36 for both limits'),
    (_k('for (size_t k = 0; k < sizeof fields / sizeof fields[0] && why == NULL; ++k)', 'lit 0->1', occ='1'),
     'sizeof of the element: fields[1] has the same size as fields[0]'),
    (_k('for (size_t off = O_PREV; off < O_PREV + 0x40u; off += 4u) wr_32(obj, off, 0);', 'lit 0x40->0x3f'), 'off takes the values 0..0x3c for both limits'),
    (_any(_k('for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);', 'lit 16->15'),
          _k('for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);', 'lit 16->17'),
          _k('for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);', 'lit 4->3', occ='1'),
          _k('for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);', 'op <-><=')),
     'the pointer rectangle is 16 bytes; the extra store (limit 17, <=, or a 3 byte step) only reaches the O_HIT word, which phase 0 cleared at its start'),
    (_any(_k('for (int16_t t = 0; t < EB_MAX_TYPES; ++t)', 'op <-><=', ordinal='1'),
          _k('for (unsigned k = 0; k < 4; ++k) wr_32(obj, entry_off(t, k) + ENT_SURF, 0);', _any('lit 4->5', 'op <-><=')),),
     'one more entry row or column only clears the handle of the next entry or of the word at O_COUNTS; phase 0 clears or restores the counters and instances right after'),
    (_any(_k('wr_32(obj, E0 + ENT_RECT + 12, add32(sub32(rd_s32(obj, E0 + ENT_RECT + 4), 1), h));', 'lit 4->3', occ='1'),
          _k('wr_32(obj, ent + ENT_RECT + 12, add32(sub32(rd_s32(obj, ent + ENT_RECT + 4), 1), rh));', 'lit 4->3', occ='1')), PIECE_ENTRY),
    (_k('for (int32_t k = 1; k < n; ++k) {', 'lit 1->0'), 'comparing the first list entry with itself never replaces the best piece (strict <)'),
    (_any(_k('if (count < 0 || count >= EB_MAX_INSTANCES) return EB_ERR_BOUNDS;', 'lit 0->1'),
          _k('if (count < 0 || count >= EB_MAX_INSTANCES) return EB_ERR_BOUNDS;', 'op <-><=')),
     'count is O_COUNT and the hand was validated by instance_valid just before (hand < O_COUNT), so count >= 1 and neither `count < 1` nor `count <= 0` can be true'),
    (_k('if (drawn == want) break;', 'cond forced 0'),
     'every piece of the plan but the hand is drawn exactly once, so drawn reaches want only after the last piece: nothing is left to scan in this layer and the outer test ends the loop'),
    (_k('if (plan->count >= EB_MAX_BLITS - 4) return EB_ERR_BOUNDS;'),
     'a plan has at most 2 restore blits + 80 pieces + the hand + the animation = 84 blits, below the 96 of the guard (EB_MAX_BLITS is 100): the guard is unreachable'),
    # --- the session binding (src/session_bindings_aeb.c)
    (_k('binding = (SessionAebBinding *)calloc(1u, sizeof(*binding));', 'lit 1->2', filename=BINDING), 'a count of two allocates twice the struct'),
    (_any(_k('binding->failure = "0xeb-row-allocation";', 'statement removed', filename=BINDING),
          _k('if (count != 0u && rows == NULL) {', 'cond forced 0', filename=BINDING),
          _k('if (binding != NULL) {', 'cond forced 1', filename=BINDING)),
     'allocation failure of calloc is not reachable without a failing allocator'),
    (_any(_k('binding->failure = "0xeb-scene-row";', 'statement removed', filename=BINDING),
          _k('free(rows);', 'statement removed', ordinal='0', filename=BINDING)),
     'scene_resource_action_at cannot fail for an index below scene_resource_action_count, so the branch is not reachable'),
    (_k('binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {', 'op >->>=', filename=BINDING),
     'index 32767 needs a scene of 32768 rows (the row number is a 16 bit word); the other operands are covered by the foreign-index cases'),
    (_k('rows[i].present = 1u;', 'lit 1->2', filename=BINDING), 'a flag only tested against zero'),
]
EQUIVALENT_MARK = '(rule)'


def equivalent_reason(key):
    for pattern, reason in EQUIVALENT_RULES:
        if re.search(pattern, key):
            return reason
    return None


EQUIVALENT = {}  # exact keys, when a rule would be too broad

# Mutants the original-x86 oracle kills. tests/action_family_eb_runtime_original_oracle.py rebuilds the driver library from a mutated copy
# of the kernel (--src) and compares it, scenario by scenario, with the unmodified GAME.EXE image; these mutants make it report a
# mismatch, so the unit cases do not need to repeat them. The list is produced by `python3 tests/test_action_family_eb_runtime.py
# --oracle-classify KEYS_FILE OUT.json` (all surviving kernel mutants, quick stage then the full 565 scenarios), one key per line
# without the file name (the kernel, as in the sweep). ORACLE_RUN records what the list was produced from; test_oracle_run_is_current
# fails if the oracle script changed since, because the claim then needs a new run.
ORACLE_RUN = {
    'oracle_script_sha256': 'e37077c6a4169002e72937e0fcdba759fb44f9def6a92f65c9c791a2a568cea6',
    'kernel_sha256': 'b7c4a7cc2b71c3f1511513745d9d4ab50f255ea51e243fe03e3062825dc21668',
    'scenarios': 565,
}
ORACLE_KILLED_KEYS = """
(uint8_t)(obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] - 1);|#0|op + -> - |0
(uint8_t)(obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] - 1);|#0|op + -> - |1
CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 1, host));|#0|lit 1->0|0
CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 1, host));|#0|op + -> - |0
T = type_off(obj[P + P_TYPE]);|#1|op + -> - |0
T = type_off(obj[piece_off(piece) + P_TYPE]);|#0|op + -> - |0
b[off + 3] = (uint8_t)((u >> 24) & 0xff);|#0|lit 24->23|1
const int16_t type = obj[P + P_TYPE];|#0|op + -> - |0
const int16_t type = obj[P + P_TYPE];|#1|op + -> - |0
const int32_t dl = rd_s32(body, T + BT_D), dt = rd_s32(body, T + BT_D + 4);|#0|lit 4->3|0
const int32_t dl = rd_s32(body, T + BT_D), dt = rd_s32(body, T + BT_D + 4);|#0|op + -> - |0
const int32_t dl = rd_s32(body, T + BT_D), dt = rd_s32(body, T + BT_D + 4);|#0|op + -> - |1
const int32_t dl = rd_s32(body, T + BT_D), dt = rd_s32(body, T + BT_D + 4);|#0|op + -> - |2
const size_t T = type_off(obj[P + P_TYPE]);|#0|op + -> - |0
const size_t ent = entry_off(obj[P + P_TYPE], obj[P + P_ORIENT] & 3u);|#0|lit 3->2|0
const size_t ent = entry_off(obj[P + P_TYPE], obj[P + P_ORIENT] & 3u);|#0|lit 3->4|0
for (int k = 0; k < 4; ++k) dst_rect[k] = rd_s32(obj, E0 + ENT_RECT + (size_t)k * 4u);|#0|lit 0->1|0
for (int16_t j = 0; j < count && j < EB_MAX_INSTANCES; ++j)|#0|lit 0->1|0
for (int16_t j = 0; j < n; ++j)|#0|lit 0->1|0
for (int16_t j = 0; j < ntypes; ++j) {|#0|op <-><=|0
for (int16_t j = 0; j < rd_s16(obj, O_COUNT); ++j) {|#1|lit 0->1|0
for (int16_t t = 0; t < n && why == NULL; ++t) {|#0|op <-><=|0
for (unsigned k = 0; k < 4; ++k) {|#0|lit 4->5|1
for (unsigned k = 0; k < 4; ++k) {|#0|op <-><=|0
if (index == type) {|#0|cond forced 1|0
if (obj[O_COUNTS + obj[P + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)|#0|op + -> - |0
if (obj[O_COUNTS + obj[P + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)|#0|op + -> - |1
if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)|#0|lit 0->1|0
if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)|#0|op + -> - |0
if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)|#0|op + -> - |1
if (pl < rd_s32(obj, P + 2))|#0|op <-><=|0
if (rd_s32(obj, off) < v.clip[0]) {|#0|lit 0->1|0
if (x_hit && pt < rd_s32(obj, P + 6))|#0|op <-><=|1
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#0|op + -> - |0
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#0|op + -> - |1
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#0|op + -> - |2
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#0|op + -> - |3
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#1|op + -> - |0
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#1|op + -> - |1
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#1|op + -> - |2
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);|#1|op + -> - |3
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);|#0|op + -> - |0
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);|#0|op + -> - |1
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);|#0|op + -> - |2
obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);|#0|op + -> - |3
obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] =|#0|op + -> - |0
obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] =|#0|op + -> - |1
piece = rd_s16(obj, O_HAND);|#0|statement removed|0
static const uint8_t k[8] = {'N', 'O', '_', 'F', 'I', 'L', 'E', 0};|#0|lit 8->9|0
static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};|#0|lit 9->10|0
wr_32(obj, O_PREV_T + 12, rd_s32(obj, O_MOVE_T + 12));|#0|op + -> - |0
wr_32(obj, O_PREV_T + 12, rd_s32(obj, O_MOVE_T + 12));|#0|statement removed|0
wr_32(obj, O_PREV_T + 4, rd_s32(obj, O_MOVE_T + 4));|#0|op + -> - |0
wr_32(obj, O_PREV_T + 4, rd_s32(obj, O_MOVE_T + 4));|#0|statement removed|0
wr_32(obj, O_PREV_T + 8, rd_s32(obj, O_MOVE_T + 8));|#0|op + -> - |0
wr_32(obj, O_PREV_T + 8, rd_s32(obj, O_MOVE_T + 8));|#0|op + -> - |1
wr_32(obj, O_PREV_T + 8, rd_s32(obj, O_MOVE_T + 8));|#0|statement removed|0
wr_32(obj, O_PREV_T, rd_s32(obj, O_MOVE_T));|#0|statement removed|0
"""
ORACLE_KILLED = frozenset(f'{KERNEL}|{line}' for line in ORACLE_KILLED_KEYS.strip().split('\n'))


# Extra mutants the line generator cannot reach (preprocessor lines).
DEFINE_MUTANTS = [
    ('no-candidate value zero', KERNEL, '#define CANDIDATE_NONE (-1)', '#define CANDIDATE_NONE (0)'),
    ('no-candidate value minus two', KERNEL, '#define CANDIDATE_NONE (-1)', '#define CANDIDATE_NONE (-2)'),
]


def sanitizer_compiler(tmp):
    """The first compiler that builds the unit cases with ASan + UBSan, or None. Memory-unsafe mutants (an unchecked index, a
    loop one past an array) are only visible to a sanitizer build."""
    for cc in (compiler(), shutil.which('gcc')):
        if cc is not None and compile_c(Path(tmp) / 'probe_san', TEST_C, SOURCES, extra=SANITIZE, cc=cc).returncode == 0:
            return cc
    return None


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'eb_test'
        built = compile_c(cls.binary, TEST_C, SOURCES, extra=('-Werror', '-Wno-error=type-limits'))
        assert built.returncode == 0, built.stderr

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_unit_cases_pass(self):
        code, results = run_unit(self.binary)
        self.assertGreaterEqual(len(results), EXPECTED_UNIT_TESTS)
        for name, (status, message) in sorted(results.items()):
            with self.subTest(name):
                self.assertEqual(status, 'PASS', message)
        self.assertEqual(code, 0)

    def test_kernel_builds_clean_with_conversion_warnings(self):
        for source in (KERNEL, BINDING):
            built = subprocess.run([compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Wconversion', '-Werror', '-O2', '-c',
                                    f'-I{SRC}', str(SRC / source), '-o', os.devnull], capture_output=True, text=True)
            self.assertEqual(built.returncode, 0, built.stderr)

    def test_sanitizers_on_the_unit_cases(self):
        """ASan + UBSan (and leak checking) over the same cases: refusals, failed host calls, re-init, scene changes."""
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'eb_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', *SANITIZE, f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')


class Mutation(unittest.TestCase):
    def test_equivalent_entries_name_real_mutants(self):
        keys = {key for key, _, _, _ in all_mutants()}
        for key in EQUIVALENT:
            with self.subTest(key):
                self.assertIn(key, keys, 'stale EQUIVALENT entry (the source line changed)')
                self.assertTrue(EQUIVALENT[key].strip())

    def test_oracle_killed_entries_name_real_mutants(self):
        keys = {key for key, _, _, _ in all_mutants()}
        stale = sorted(key for key in ORACLE_KILLED if key not in keys)
        self.assertEqual(stale, [], 'stale ORACLE_KILLED entries (the source line changed): regenerate with --oracle-classify')
        for key in ORACLE_KILLED:
            self.assertFalse(equivalent_reason(key) and key in EQUIVALENT, key)

    def test_oracle_run_is_current(self):
        """The recorded oracle verdicts hold for this oracle script and this kernel; a changed script or kernel needs a new run."""
        self.assertEqual(hashlib.sha256(ORACLE.read_bytes()).hexdigest(), ORACLE_RUN['oracle_script_sha256'],
                         'the oracle script changed: rerun --oracle-classify and refresh ORACLE_KILLED and ORACLE_RUN')
        self.assertEqual(hashlib.sha256((SRC / KERNEL).read_bytes()).hexdigest(), ORACLE_RUN['kernel_sha256'],
                         'the kernel changed: rerun --oracle-classify and refresh ORACLE_KILLED and ORACLE_RUN')

    def test_define_anchors(self):
        for name, filename, old, new in DEFINE_MUTANTS:
            with self.subTest(name):
                self.assertEqual((SRC / filename).read_text().count(old), 1)

    def test_mutations_are_detected(self):
        """The unit cases must fail when any operator, literal, condition or statement of the kernel or binding is broken."""
        results = run_sweep()
        survivors = sorted(key for key, verdict in results.items() if verdict == 'survived' and key not in EQUIVALENT
                           and key not in ORACLE_KILLED and equivalent_reason(key) is None)
        killed = sum(1 for verdict in results.values() if verdict == 'killed')
        invalid = sum(1 for verdict in results.values() if verdict == 'invalid')
        by_oracle = sum(1 for key, verdict in results.items() if verdict == 'survived' and key in ORACLE_KILLED)
        excused = sum(1 for key, verdict in results.items() if verdict == 'survived' and key not in ORACLE_KILLED
                      and (key in EQUIVALENT or equivalent_reason(key)))
        print(f'mutants: {len(results)} generated, {killed} killed by the unit cases, {by_oracle} killed by the original-x86 oracle, '
              f'{excused} survive as recorded equivalents, {invalid} do not compile')
        self.assertEqual(survivors, [], f'{len(survivors)} surviving mutants')


def build_objects(tmp, cc, flags):
    objs = {}
    for name, source in (('test', TEST_C), ('scene', SRC / 'scene_resource.c'), ('hiff', SRC / 'hiff.c'),
                         (KERNEL, SRC / KERNEL), (BINDING, SRC / BINDING)):
        obj = Path(tmp) / f'{name}.o'
        built = subprocess.run([cc, '-std=c11', '-O0', '-g', *flags, f'-I{SRC}', '-c', str(source), '-o', str(obj)],
                               capture_output=True, text=True)
        if built.returncode != 0:
            raise AssertionError(built.stderr)
        objs[name] = obj
    return objs


def run_sweep(limit=None, only=None):
    with tempfile.TemporaryDirectory() as tmp:
        cc = sanitizer_compiler(tmp)
        flags = SANITIZE if cc else []
        cc = cc or compiler()
        objs = build_objects(tmp, cc, flags)
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
        texts = {name: (SRC / name).read_text() for name in MUTATED_FILES}
        jobs = []
        for key, filename, number, new_line in all_mutants():
            lines = texts[filename].split('\n')
            lines[number - 1] = new_line
            jobs.append((key, filename, '\n'.join(lines)))
        for name, filename, old, new in DEFINE_MUTANTS:
            jobs.append((f'define|{name}', filename, texts[filename].replace(old, new, 1)))
        if only is not None:
            jobs = [j for j in jobs if j[0] in only]
        if limit:
            jobs = jobs[:limit]

        def one(item):
            index, (key, filename, text) = item
            work = Path(tmp) / f'm{index}'
            work.mkdir()
            source = work / filename
            source.write_text(text)
            obj = work / 'mut.o'
            built = subprocess.run([cc, '-std=c11', '-O0', '-g', *flags, f'-I{SRC}', '-c', str(source), '-o', str(obj)],
                                   capture_output=True, text=True)
            if built.returncode != 0:
                shutil.rmtree(work, ignore_errors=True)
                return key, 'invalid'
            parts = [str(obj if name == filename else objs[name]) for name in (KERNEL, BINDING)]
            binary = work / 'mut_test'
            linked = subprocess.run([cc, *flags, str(objs['test']), *parts, str(objs['scene']), str(objs['hiff']), '-lm', '-o',
                                     str(binary)], capture_output=True, text=True)
            if linked.returncode != 0:
                shutil.rmtree(work, ignore_errors=True)
                return key, 'invalid'
            try:
                done = subprocess.run([str(binary)], capture_output=True, text=True, errors='replace', timeout=60, env=env)  # a broken mutant may print raw bytes
                verdict = 'killed' if done.returncode != 0 else 'survived'
            except subprocess.TimeoutExpired:
                verdict = 'killed'  # a hang is a detected difference
            shutil.rmtree(work, ignore_errors=True)
            return key, verdict

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            return dict(pool.map(one, enumerate(jobs)))


class Corpus(unittest.TestCase):
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The two real raw 0xeb rows (resources 1600 and 2305, one row each) pass the native body validation. Pass 0 plays each row:
        pieces are picked (twice for the Multi_Piece row, which spawns a copy), the full turn of the second button, drops inside the
        area where the kernel reports a hit, a forbidden type sent outside, then the exit button; the finish applies the win or exit
        block and the generic completion. Pass 1 places one piece, leaves, checks the saved state and enters the row again; pass 2 is the
        exit button right after phase 0 (derived counts only; the decoded resources stay in work/)."""
        files = [RESOURCES / '1600.bin', RESOURCES / '2305.bin']
        if not all(path.exists() for path in files):
            self.skipTest('local corpus evidence (work/) is not present')
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'eb_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Werror', '-Wconversion', '-Wno-error=type-limits'))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['validated'], summary['exited'], summary['reentered'],
                          summary['error']), (2, 2, 2, 4, 2, 0))
        # Each row is played to its end by the exit button and completes once per pass; a win needs the target total, which the
        # script reaches for the Multi_Piece row (a copy is enough) and not for the jigsaw row (it needs an exact packing).
        self.assertEqual(summary['completes'], 6)
        self.assertGreaterEqual(summary['won'], 1)
        self.assertGreaterEqual(summary['picks'], 10)
        self.assertGreaterEqual(summary['good_drops'], 5)
        self.assertGreaterEqual(summary['spawns'], 1)
        self.assertEqual(summary['rotations'], 4)
        self.assertGreaterEqual(summary['forbidden_dropped'], 1)
        self.assertEqual(summary['releases'], summary['loads'] + summary['creates'])  # every surface is released by the cleanup
        self.assertEqual(done.stdout.count('SCENE_FAIL') + done.stdout.count('ROW_FAIL'), 0)


class BuildScript(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_e4_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())


class Registration(unittest.TestCase):
    def test_module_is_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        self.assertIn(' action_family_eb_runtime session_bindings_aeb', build)

    def test_app_glue_uses_slot_54_and_numeric_literals(self):
        app = (SRC / 'blackmoor_app.mm').read_text()
        for line in ('bindings[54].type = SESSION_AEB_TYPE;', 'bindings[54].callback = native_aeb_handler;',
                     'bindings[54].context = app;', 'bindings[54].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;'):
            self.assertEqual(app.count(line), 1, line)
        # later slices raise the array and the declared count (gap-free slots); the shape is checked here, the exact number by
        # test_native_app.NativeAppBindingRegistrationTests
        count = int(re.search(r'config\.action_binding_count = (\d+)u;', app).group(1))
        self.assertGreaterEqual(count, 55)
        self.assertEqual(app.count('SceneSessionActionBinding bindings[%d]{};' % count), 1)

    def test_every_generic_entry_allocator_excludes_the_multibuild_puzzle(self):
        """The allocators of the shared z entry range 0x18..0x3f all skip the Multibuild puzzle's slots, and its own skips theirs."""
        app = (SRC / 'blackmoor_app.mm').read_text()
        puzzle = {'ad9', 'ad1', 'aea', 'af6', 'ad0', 'aaa', 'ae0', 'ad3', 'ae4', 'af5'}
        bodies = {}
        for name in puzzle | {'aeb'}:
            start = app.index(f'static int native_{name}_alloc_slot(')
            bodies[name] = app[start:app.index('\n}\n', start)]
        for name in puzzle:
            self.assertIn('aeb_slot_used', bodies[name], f'{name} allocator ignores the Multibuild puzzle')
        for other in puzzle:
            self.assertIn(f'{other}_slot_used', bodies['aeb'], f'the Multibuild puzzle allocator ignores {other}')

    def test_candidates_are_the_five_multibuild_values(self):
        header = (SRC / 'action_family_eb_runtime.h').read_text()
        for name, value in (('PICK', '0x278d'), ('ROTATE', '0x278e'), ('EXIT_A', '0x278f'), ('EXIT_B', '0x2790'), ('DROP', '0x2791')):
            self.assertRegex(header, rf'#define EB_CANDIDATE_{name}\s+{value}')


def oracle_classify(keys_file, out_file, jobs=4):
    """Run the kernel mutants listed in keys_file (one key per line, first line ignored as in --survivors output) through the
    original-x86 oracle: a quick pass (--quick-only), then the full scenario set for those that survive it. Writes {key: verdict}."""
    keys = [line.rstrip('\n') for line in Path(keys_file).read_text().splitlines()[1:] if line.strip()]
    mutants = {key: (number, new_line) for key, filename, number, new_line in all_mutants() if filename == KERNEL}
    text = (SRC / KERNEL).read_text().split('\n')
    work = Path(tempfile.mkdtemp(prefix='eb_oracle_'))
    results = {}

    def run(directory, quick):
        cmd = [sys.executable, str(ORACLE), '--src', str(directory), '--workers', '1', '--result', str(directory / 'r.json'), '--fail-fast',
               '--lenient-build', '--mutation-run'] + (['--quick-only'] if quick else [])
        done = subprocess.run(cmd, capture_output=True, text=True, cwd=str(ORACLE.parent), timeout=3000)
        if 'driver build failed' in done.stderr + done.stdout:
            return 'INVALID'
        if done.returncode == 0:
            return 'SURVIVED'
        return 'KILLED' if any(line.startswith('FIRST') for line in done.stdout.splitlines()) else 'ERROR'

    def one(item):
        index, key = item
        number, new_line = mutants[key]
        directory = work / f'm{index}'
        directory.mkdir()
        for header in SRC.glob('action_family_eb_runtime*.h'):
            shutil.copy(header, directory / header.name)
        lines = list(text)
        lines[number - 1] = new_line
        (directory / KERNEL).write_text('\n'.join(lines))
        verdict = run(directory, True)
        if verdict == 'SURVIVED':
            verdict = run(directory, False)
        shutil.rmtree(directory, ignore_errors=True)
        return key, verdict

    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as pool:
        for key, verdict in pool.map(one, enumerate(keys)):
            results[key] = verdict
            Path(out_file).write_text(json.dumps(results, indent=0, sort_keys=True))
    shutil.rmtree(work, ignore_errors=True)
    print('oracle:', {v: list(results.values()).count(v) for v in sorted(set(results.values()))})


if __name__ == '__main__':
    if len(sys.argv) > 3 and sys.argv[1] == '--oracle-classify':
        oracle_classify(sys.argv[2], sys.argv[3])
    elif len(sys.argv) > 1 and sys.argv[1] == '--survivors':
        keys = None
        if len(sys.argv) > 2:  # re-run only the mutants listed (one key per line) in the file given
            keys = {line.rstrip('\n') for line in Path(sys.argv[2]).read_text().splitlines()[1:] if line}
        res = run_sweep(only=keys)
        survivors = sorted(k for k, v in res.items() if v == 'survived')
        print('total', len(res), 'killed', sum(v == 'killed' for v in res.values()), 'invalid', sum(v == 'invalid' for v in res.values()),
              'survived', len(survivors))
        for key in survivors:
            print(key)
    else:
        unittest.main()
