"""Leak checking for the sanitizer harnesses, probed per compiler; ASan and UBSan stay on on every host.

Two leak checkers exist and each is probed with a program that leaks and one that does not:
  * LeakSanitizer (`ASAN_OPTIONS=detect_leaks=1` on an ASan build) where the runtime supports it (Linux);
  * the system `leaks --atExit` tool on an unsanitized build (macOS, whose ASan aborts with "detect_leaks is not supported on
    this platform").
Only that one documented macOS refusal downgrades to `detect_leaks=0`; any other LeakSanitizer failure (for example Linux under
ptrace, or a leaking probe that is not reported) raises LeakCheckerError instead of silently dropping the check.
"""
from functools import lru_cache
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import threading

SANITIZE_FLAGS = ('-fsanitize=address,undefined', '-fno-sanitize-recover=undefined')
UNSUPPORTED_TEXT = 'detect_leaks is not supported on this platform'
LEAKY = '#include <stdlib.h>\nint main(void) { volatile char *p = malloc(7); p[0] = 1; p = 0; return 0; }\n'
CLEAN = '#include <stdlib.h>\nint main(void) { char *p = malloc(7); p[0] = 1; free(p); return 0; }\n'
_LEAK_SCAN_LOCK = threading.Lock()
_LEAK_SUMMARY = re.compile(r'^Process \d+: ([\d,]+) leaks? for [\d,]+ total leaked bytes\.$', re.M)


class LeakCheckerError(RuntimeError):
    """A leak checker that should work here does not, or no leak checker works for leak-only mutants."""


def default_candidates():
    return tuple(dict.fromkeys(c for c in (os.environ.get('CC'), shutil.which('clang'), shutil.which('gcc'), shutil.which('cc')) if c))


def _build_and_run(cc, tmp, name, body, flags, command=(), env=None):
    source = Path(tmp) / f'{name}.c'
    binary = Path(tmp) / name
    source.write_text(body)
    built = subprocess.run([cc, '-g', '-O0', *flags, str(source), '-o', str(binary)], capture_output=True, text=True)
    if built.returncode:
        return None
    return subprocess.run([*command, str(binary)], capture_output=True, text=True, errors='replace', env=env)


@lru_cache(maxsize=None)
def sanitizer_leak_status(cc):
    """'absent' (cc cannot build an ASan/UBSan program), 'unsupported' (ASan builds but refuses leak detection on this platform)
    or 'lsan' (a leaking program is reported and a clean one passes). Anything else raises LeakCheckerError."""
    with tempfile.TemporaryDirectory(prefix='blackmoor-lsan-probe-') as scratch:
        env = dict(os.environ, ASAN_OPTIONS='detect_leaks=1')
        leaky = _build_and_run(cc, scratch, 'leaky', LEAKY, SANITIZE_FLAGS, env=env)
        if leaky is None:
            return 'absent'
        if UNSUPPORTED_TEXT in leaky.stderr and leaky.returncode != 0:
            return 'unsupported'
        if leaky.returncode == 0 or 'ERROR: LeakSanitizer: detected memory leaks' not in leaky.stderr:
            raise LeakCheckerError(f'{cc}: LeakSanitizer did not report a leaking probe (exit {leaky.returncode}): '
                                   f'{leaky.stderr.strip()[-300:]}')
        clean = _build_and_run(cc, scratch, 'clean', CLEAN, SANITIZE_FLAGS, env=env)
        if clean is None or clean.returncode != 0:
            raise LeakCheckerError(f'{cc}: LeakSanitizer rejected a clean probe: {(clean.stderr if clean else "build failed").strip()[-300:]}')
        return 'lsan'


@lru_cache(maxsize=None)
def leaks_tool_works(cc):
    """The system `leaks --atExit` tool on an unsanitized build of cc: it fails a leaking program and passes a clean one."""
    if shutil.which('leaks') is None:
        return False
    with tempfile.TemporaryDirectory(prefix='blackmoor-leaks-probe-') as scratch:
        verdicts = []
        for name, body in (('leaky', LEAKY), ('clean', CLEAN)):
            done = _build_and_run(cc, scratch, name, body, (), command=('leaks', '--atExit', '--'))
            if done is None:
                return False
            try:
                verdicts.append(_leaks_result(done) == ('killed' if name == 'leaky' else 'survived'))
            except LeakCheckerError:
                return False
        return all(verdicts)


def leak_sanitizer_available(cc=None):
    """Whether LeakSanitizer works with cc, or with the first ASan-capable default compiler when cc is None."""
    for candidate in ((cc,) if cc else default_candidates()):
        status = sanitizer_leak_status(candidate)
        if status != 'absent':
            return status == 'lsan'
    return False


def sanitizer_environment(cc=None):
    return dict(os.environ, ASAN_OPTIONS='detect_leaks=1' if leak_sanitizer_available(cc) else 'detect_leaks=0')


def leak_checker(sanitizer_cc, plain_cc):
    """'lsan' when the sanitizer build can check leaks itself, 'leaks' when only the system tool on an unsanitized build can,
    else None."""
    if sanitizer_cc and leak_sanitizer_available(sanitizer_cc):
        return 'lsan'
    if plain_cc and leaks_tool_works(plain_cc):
        return 'leaks'
    return None


def require_leak_checker(sanitizer_cc, plain_cc):
    kind = leak_checker(sanitizer_cc, plain_cc)
    if kind is None:
        raise LeakCheckerError('neither LeakSanitizer nor `leaks --atExit` works here, so leak-only mutants cannot be judged')
    return kind


def _leaks_result(done):
    counts = _LEAK_SUMMARY.findall(done.stdout)
    if len(counts) == 1:
        count = int(counts[0].replace(',', ''))
        if done.returncode == 0 and count == 0:
            return 'survived'
        if done.returncode == 1 and count > 0:
            return 'killed'
    raise LeakCheckerError(f'leaks did not produce a valid verdict (exit {done.returncode}): {done.stderr[-300:]}')


def leaks_verdict(binary, timeout=120, env=None):
    """Judge an actual leak report. Tool errors and timeouts cannot kill a mutant.

    Serialize scans to avoid contention, retry a failed scan once, then fail the
    test visibly. This helper judges the leak report rather than program status.
    """
    problem = None
    for _attempt in range(2):
        with _LEAK_SCAN_LOCK:
            try:
                done = subprocess.run(['leaks', '--atExit', '--', str(binary)], capture_output=True, text=True,
                                      errors='replace', timeout=timeout, env=env)
                return _leaks_result(done)
            except subprocess.TimeoutExpired:
                problem = f'leaks timed out after {timeout} seconds'
            except LeakCheckerError as error:
                problem = str(error)
    raise LeakCheckerError(f'{problem}; mutation was not judged')
