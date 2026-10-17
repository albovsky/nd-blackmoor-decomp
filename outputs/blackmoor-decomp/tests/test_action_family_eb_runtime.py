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
change observable behaviour.
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
EXPECTED_UNIT_TESTS = 36
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


EQUIVALENT_RULES = [
    # (filled from the sweep below)
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
        self.assertEqual(app.count('SceneSessionActionBinding bindings[55]{};'), 1)
        self.assertEqual(app.count('config.action_binding_count = 55u;'), 1)

    def test_every_generic_entry_allocator_excludes_the_multibuild_puzzle(self):
        """The allocators of the shared z entry range 0x18..0x3f all skip the Multibuild puzzle's slots, and its own skips theirs."""
        app = (SRC / 'blackmoor_app.mm').read_text()
        puzzle = {'ad9', 'ad1', 'aea', 'af6', 'ad0', 'aaa', 'ae0', 'ad3', 'ae4'}
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
