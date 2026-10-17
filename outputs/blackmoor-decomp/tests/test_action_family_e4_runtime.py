"""RT-54: raw 0xe4 Match Puzzle runtime (src/action_family_e4_runtime.c) and its session binding (src/session_bindings_ae4.c).

Facts under test (original GAME.EXE, read from the disassembly of 0x476a25, 0x475a1e, 0x475bef, 0x4763b3, 0x475da4, 0x475fb1,
0x47608e, 0x4778df, 0x4758e8, 0x475885, 0x4757da, 0x47591f and 0x42ba3a):
 * phase 0 fills the board (kinds 0..kinds-2, no two equal neighbours), acquires the generic z entry and the surfaces, prepares the
   three sounds and starts the countdown;
 * phase 1 is a seven-state machine on obj+0x2c: play (the pending checks, the unsigned countdown, the win test), the end sound, the
   refill of matched pieces, the shuffle, the end-sound wait, the delay before it and the high score screen;
 * CheckForMatch marks runs of three or more in the column and the row, scores them and adds the time and score bonuses (the
   column's three-run time bonus tests the ROW's run length);
 * phase 2 stops the sounds, applies the exit or win scene block, releases the font, calls the generic completion and cleans up;
 * the pointer hit-tests pieces (3 pixel inset), the shuffle button and the exit button; the click selects, swaps, shuffles or exits;
   the render callback blits pieces, panels and the score screen.
The unit cases live in tests/action_family_e4_runtime_test.c (synthetic bodies, no original bytes). The corpus run feeds the two real
rows (resources 2295 and 2296, local evidence in work/) through the production parser, the binding and the kernel. The original-x86
oracle is a separate script (tests/test_action_family_e4_runtime_oracle.py; it needs the private work/ evidence and Unicorn).

The mutation sweep is generated from the current source: every comparison, logical, arithmetic and bitwise operator, every integer
literal, every `if` condition (forced true and forced false) and every simple statement of the kernel and the binding is mutated
once, and the unit cases must fail on each. A mutant that survives must be listed in EQUIVALENT with the reason it cannot change
observable behaviour.
"""
import concurrent.futures
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
TEST_C = PROJECT / 'tests/action_family_e4_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_e4_runtime_corpus.c'
KERNEL = 'action_family_e4_runtime.c'
BINDING = 'session_bindings_ae4.c'
SOURCES = [KERNEL, BINDING, 'scene_resource.c', 'hiff.c']
MUTATED_FILES = [KERNEL, BINDING]
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
STATEMENT = re.compile(r'^\s*(?:(?:ob16|ob32|fx|set_text|set_text_bytes|set_number_text|memcpy|memset|HOST|OP|cell_rect|check_match|'
                       r'start_refill|new_op|add_blit|add_text)\(.*\)|[A-Za-z_][\w\->.\[\]() +*]* (?:=|\+=|-=) .*);\s*$')
NO_STATEMENT = ('return', 'const', 'int', 'uint', 'char', 'static', 'goto', 'break', 'continue', 'case', 'default', 'E4r', 'size_t',
                'for', 'while', 'if', 'else', 'typedef', 'struct', 'enum', 'SceneAction', 'Ae4Row', 'SessionAe4', 'void')


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


EQUIVALENT_RULES = [
    # array sizes
    (r'^[^|]*\|(static |const )?[^|]*\(?[^|]*\b\w+\[4\][^|]*\|#\d+\|lit 4->[35]\|\d+$',
     'a C array parameter or an unused larger local array: the size is ignored (parameter) or still holds four elements (4->5); '
     'the shrinking 4->3 form of a local array is caught by ASan and not listed'),
    (r'^action_family_e4_runtime.c\|(char buf\[16\]|char buf\[24\]|uint8_t text\[16\]);\|#0\|lit \d+->\d+\|0$',
     'a scratch buffer for a decimal number of at most 10 digits or the 8 character time text: every size from 15 to 25 holds it'),
    (r'^action_family_e4_runtime.c\|static const uint8_t k\[9\]', 'one more zero byte of the constant "NO SOUND" and its terminator is compared as zero padding of the name'),
    # always-assigned initialisers
    (r'\|(int16_t kind = 0;|int32_t value = 0;|int32_t b = 0;|int32_t b1 = 0, b2 = 0, b3 = 0;|uint32_t surface = 0;|surface = 0;|'
     r'int16_t height = 0, step;)\|#\d+\|(lit 0->1|statement removed)\|\d+$',
     'a local that the host call or the following statement assigns before any read (a failed host call returns before the read)'),
    (r'\|(int retry = 1, guard = 0;|retry = 1;|have_view = 1;|return 1;)\|#\d+\|lit 1->2\|0$',
     'a flag only tested against zero (the value 1 and 2 behave the same)'),
    (r'\|rc = fill\(o, body, 1, 0, 0, host\);\|#\d+\|lit [01]->[12]\|\d+$',
     'the whole-board fill ignores its row and column (all != 0) and tests all only against zero'),
    (r'CELL_PRESENT\] = 1;\|#0\|op \+ -> - \|0$|\[cell \+ CELL_PRESENT\]', 'CELL_PRESENT is 0, so cell + 0 equals cell - 0'),
    # render ops
    (r'\|(rect\[2\] = wrap_add\(rect\[0\], 100\);|high_rect\[2\] = wrap_add\(high_rect\[0\], 0x50\);|high_rect\[1\] = high_rect\[3\];)\|',
     'the right edge and top of the score-screen text rectangle are not part of an op (the native text op keeps left and bottom only); they '
     'mirror the original DrawText rectangle'),
    (r'\|if \(op == NULL\) return E4R_ERR_BOUNDS;\||\|if \(out->count >= E4R_MAX_OPS\) return NULL;\|',
     'E4R_MAX_OPS is 160 and the largest board needs 100 pieces plus 16 other ops, so the overflow guard is unreachable'),
    (r'\|(memcpy\(op->text, text, strlen\(\(const char \*\)text\) \+ 1u\);|memcpy\(o->b \+ off, s, strlen\(\(const char \*\)s\) \+ 1u\);)\|#0\|lit 1->[02]\|0$',
     'the terminator copy: the destination is zero-filled before (op) or the byte after a zero-padded body name is zero (object text)'),
    (r'\|if \(body\[B_TITLE\] != 0\) \{\||\|if \(o->b\[E4R_O_TARGET_TEXT\] != 0\) \{\|',
     'add_text draws nothing for an empty text, so the guard in front of it changes no result'),
    (r'\|if \(\(uint32_t\)state > 6u\) return E4R_OK;\|', 'the switch that follows has no case above state 6 and does nothing for them'),
    # loops over one extra cell
    (r'\|for \(r = 0; r < rows; \+\+r\)\|#1\|op <-><=\|0$|\|for \(c = 0; c < cols; \+\+c\)\|#0\|op <-><=\|0$',
     'the refill loop over one more row or column asks fill() for a cell outside the board, which matches no cell'),
    (r'\|for \(r = 0; r < rows; \+\+r\)\|#2\|op <-><=\|0$|\|for \(c = 0; c < cols; \+\+c\) \{\|#3\|op <-><=\|0$',
     'the bounds check of the render callback reading one more row or column only reads empty (absent) cells or the next row\'s first cell '
     '(already checked); for a ten row board that cell is past the array, undefined behaviour no test may rely on'),
    (r'^action_family_e4_runtime.c\|if \(rc != E4R_OK\) return rc;\|#(4|5)\|cond forced 0\|0$',
     'start_refill makes no host call that can fail (it only reads the tick), so its result is always E4R_OK'),
    (r'^action_family_e4_runtime.c\|if \(rc != E4R_OK\) return rc;\|#11\|cond forced 1\|0$',
     'the check after the match-sound play is the last statement of the case and nothing follows the switch, so an early return of E4R_OK changes nothing'),
    (r'^action_family_e4_runtime.c\|result->phase_after = after;\|#1\|statement removed\|0$',
     'on the host-failure path the phase never differs from the one the result was initialised with: phase 1 raises it to 2 only in the '
     'last statements of a visit, after which no host call is made'),
    # binding
    (r'^session_bindings_ae4.c\|(binding = \(SessionAe4Binding \*\)calloc\(1u|rows\[i\].present = 1u;)', 'a count of two or a flag value 2: allocation size or a flag tested only against zero'),
    (r'^session_bindings_ae4.c\|(binding->failure = "0xe4-(body-length|row-allocation|scene-row)";|if \(count != 0u && rows == NULL\) \{)\|',
     'allocation failure and a scene row that cannot be read after the count was read are not reachable without a failing allocator or parser'),
    (r'^session_bindings_ae4.c\|if \(info.typed_body_length', 'the scene parser types only 0xe4 rows of exactly 2034 bytes (a shorter one stays opaque), so the check cannot fire'),
    (r'^session_bindings_ae4.c\|(if \(row < 0 \|\| |if \(row == NULL\))', 'begin_scene cleans the object up before it swaps the rows, so an active object always has its row bound'),
    (r'^session_bindings_ae4.c\|binding->rows\[index\].present == 0u', 'an index above 32767 needs a scene of 32768 rows; the other operand pairs are covered by the foreign-index cases'),
    (r'^session_bindings_ae4.c\|if \(binding != NULL\) \{', 'a failed calloc of one small struct'),
]
EQUIVALENT_MARK = '(rule)'


def equivalent_reason(key):
    for pattern, reason in EQUIVALENT_RULES:
        if re.search(pattern, key):
            return reason
    return None


EQUIVALENT = {}  # exact keys, when a rule would be too broad

# Extra mutants the line generator cannot reach (preprocessor lines).
DEFINE_MUTANTS = [
    ('fill retry limit lower', KERNEL, '#define FILL_RETRY_LIMIT 1000000', '#define FILL_RETRY_LIMIT 999999'),
    ('fill retry limit higher', KERNEL, '#define FILL_RETRY_LIMIT 1000000', '#define FILL_RETRY_LIMIT 1000001'),
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
        cls.binary = Path(cls.tmp.name) / 'e4_test'
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
            out = Path(self.tmp.name) / 'e4_test_san'
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

    def test_define_anchors(self):
        for name, filename, old, new in DEFINE_MUTANTS:
            with self.subTest(name):
                self.assertEqual((SRC / filename).read_text().count(old), 1)

    def test_mutations_are_detected(self):
        """The unit cases must fail when any operator, literal, condition or statement of the kernel or binding is broken."""
        results = run_sweep()
        survivors = sorted(key for key, verdict in results.items() if verdict == 'survived' and key not in EQUIVALENT and equivalent_reason(key) is None)
        killed = sum(1 for verdict in results.values() if verdict == 'killed')
        invalid = sum(1 for verdict in results.values() if verdict == 'invalid')
        excused = sum(1 for key, verdict in results.items() if verdict == 'survived' and (key in EQUIVALENT or equivalent_reason(key)))
        print(f'mutants: {len(results)} generated, {killed} killed, {excused} survive as recorded equivalents, {invalid} do not compile')
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
                done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=60, env=env)
                verdict = 'killed' if done.returncode != 0 else 'survived'
            except subprocess.TimeoutExpired:
                verdict = 'killed'  # a hang is a detected difference
            shutil.rmtree(work, ignore_errors=True)
            return key, verdict

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            return dict(pool.map(one, enumerate(jobs)))


class Corpus(unittest.TestCase):
    def test_real_rows_validate_and_play_through_the_binding(self):
        """The two real raw 0xe4 rows (resources 2295 and 2296, one row each) pass the native body validation; pass 0 fills the
        board, shuffles, scores a swap, shows the matched pieces until the deadline and refills, runs the countdown to TIME!, the end
        sound, the high score screen and the restart, then wins through the target score and finishes with the win scene block;
        pass 1 leaves through the exit button (derived counts only; the decoded resources stay in work/)."""
        if not RESOURCES.exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'e4_corpus'
            built = compile_c(binary, CORPUS_C, SOURCES, extra=('-Wno-error=type-limits',))
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-600:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        self.assertEqual((summary['scenes'], summary['rows'], summary['validated'], summary['won'], summary['timed_out'],
                          summary['exited'], summary['error']), (2, 2, 2, 2, 2, 2, 0))
        self.assertEqual(summary['loads'], summary['releases'])
        self.assertEqual(summary['slots'], summary['slot_releases'])
        self.assertGreaterEqual(summary['matches'], 2)
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
        self.assertIn(' action_family_e4_runtime session_bindings_ae4', build)

    def test_app_glue_uses_slot_51_and_numeric_literals(self):
        app = (SRC / 'blackmoor_app.mm').read_text()
        for line in ('bindings[51].type = SESSION_AE4_TYPE;', 'bindings[51].callback = native_ae4_handler;',
                     'bindings[51].context = app;', 'SceneSessionActionBinding bindings[52]{};', 'config.action_binding_count = 52u;'):
            self.assertEqual(app.count(line), 1, line)

    def test_every_generic_entry_allocator_excludes_the_match_puzzle(self):
        """The allocators of the shared z entry range 0x18..0x3f all skip the Match Puzzle's slots, and its own skips theirs."""
        app = (SRC / 'blackmoor_app.mm').read_text()
        puzzle = {'ad9', 'ad1', 'aea', 'af6', 'ad0', 'aaa', 'ae0', 'ae4'}
        bodies = {}
        for name in puzzle:
            start = app.index(f'static int native_{name}_alloc_slot(')
            bodies[name] = app[start:app.index('\n}\n', start)]
        for name in puzzle - {'ae4'}:
            self.assertIn('ae4_slot_used', bodies[name], f'{name} allocator ignores the Match Puzzle')
        for other in puzzle - {'ae4'}:
            self.assertIn(f'{other}_slot_used', bodies['ae4'], f'the Match Puzzle allocator ignores {other}')
        # Observed in the existing code, not changed here: the ad9 allocator does not list ad1's slots.

    def test_glue_gates_the_click_on_the_three_match_puzzle_candidates(self):
        app = (SRC / 'blackmoor_app.mm').read_text()
        self.assertIn('app->input_state.candidate >= E4R_CANDIDATE_PIECE && app->input_state.candidate <= E4R_CANDIDATE_SHUFFLE', app)
        self.assertEqual((0x27d5, 0x27d6, 0x27d7), (10197, 10198, 10199))
        header = (SRC / 'action_family_e4_runtime.h').read_text()
        for name, value in (('E4R_CANDIDATE_PIECE', '0x27d5'), ('E4R_CANDIDATE_EXIT', '0x27d6'), ('E4R_CANDIDATE_SHUFFLE', '0x27d7')):
            self.assertRegex(header, rf'#define {name}\s+{value}')


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--survivors':
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
