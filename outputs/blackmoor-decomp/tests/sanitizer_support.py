"""Probe LeakSanitizer separately; keep address/undefined checks on every host."""
from functools import lru_cache
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


@lru_cache(maxsize=1)
def leak_sanitizer_available():
    candidates = (os.environ.get('CC'), shutil.which('clang'), shutil.which('gcc'), shutil.which('cc'))
    with tempfile.TemporaryDirectory(prefix='blackmoor-lsan-probe-') as scratch:
        source = Path(scratch) / 'leak.c'
        binary = Path(scratch) / 'leak'
        source.write_text('#include <stdlib.h>\nint main(void) { volatile char *p = malloc(7); p[0] = 1; p = 0; return 0; }\n')
        for cc in dict.fromkeys(c for c in candidates if c):
            built = subprocess.run([cc, '-O0', '-fsanitize=address,undefined', str(source), '-o', str(binary)],
                                   capture_output=True, text=True)
            if built.returncode:
                continue
            result = subprocess.run([str(binary)], capture_output=True, text=True,
                                    env=dict(os.environ, ASAN_OPTIONS='detect_leaks=1'))
            return result.returncode != 0 and 'ERROR: LeakSanitizer: detected memory leaks' in result.stderr
    return False


def sanitizer_environment():
    return dict(os.environ, ASAN_OPTIONS='detect_leaks=1' if leak_sanitizer_available() else 'detect_leaks=0')
