#!/usr/bin/env python3
"""Adapt the allocation oracle's GNU wrapper flags to its macOS test driver."""
import os
import shutil
import sys


def main():
    compiler = os.environ.get('BLACKMOOR_A1C_REAL_CC') or shutil.which('clang') or shutil.which('cc')
    if not compiler:
        raise SystemExit('allocation oracle: no C compiler')
    arguments = sys.argv[1:]
    wrappers = {f'-Wl,--wrap={name}' for name in ('calloc', 'malloc', 'free')}
    present = wrappers.intersection(arguments)
    if present:
        if present != wrappers:
            raise SystemExit('allocation oracle: all three allocator wrappers are required')
        arguments = [argument for argument in arguments if argument not in wrappers]
        arguments[:0] = [f'-D{name}=__wrap_{name}' for name in ('calloc', 'malloc', 'free')]
    os.execvp(compiler, [compiler, *arguments])


if __name__ == '__main__':
    main()
