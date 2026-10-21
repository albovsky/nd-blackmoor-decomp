#!/usr/bin/env python3
"""FL-34 (batch b): hand-written mutants (shapes the mechanical tests/fl34b_mutation_check.py does not model: a changed word constant k, a byte or unsigned or ordered compare of
the word, a wrong stored word, a flag compare masked or loosened, a store to a neighbouring flag, a swapped order of two effects, a wrong argument). Each is applied to a scratch copy of src/original_methods_fl34b.c; the direct test and then the Unicorn
differential test of the function must fail. Prints where each was caught; exits 1 if any survives. (The order of the two stores of a flag toggle is not a mutant: both are made before the one call and the two are different globals.)

Run from outputs/blackmoor-decomp:  python3 tests/fl34b_hand_mutants.py
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import test_fl34b_direct as direct
import fl34b_mutation_check as mc

SRC = HERE.parent / 'src'
HAND = [
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0x7fff;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x1) world->word_5e335e = 0xffff;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x0) world->word_5e335e = 0xffff;'),
    ('4067a5', 'if (world->dword_5e350a == 1) {', 'if ((world->dword_5e350a & 0xffff) == 1) {'),
    ('4067a5', 'if (world->dword_5e350a == 1) {', 'if (world->dword_5e350a != 0) {'),
    ('4067a5', 'if (world->dword_5e350a == 1) {', 'if ((world->dword_5e350a & 1) != 0) {'),
    ('4067a5', 'world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;'),
    ('4067a5', 'world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;', 'world->dword_5e350a = 2;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;'),
    ('4067a5', '        world->dword_5e350a = 0;\n    } else {', '        world->dword_5e350a = 0;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;\n    } else {'),
    ('4067a5', '        world->dword_5e350a = 0;\n    } else {', '        world->dword_5e350a = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('4067a5', '        world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('4067a5', '        world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('4067a5', '    if (world->dword_5e350a == 1) {\n        world->dword_5e350a = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e350a == 1) {\n        world->dword_5e350a = 0;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0x7fff;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x4) world->word_5e335e = 0xffff;'),
    ('4068c0', 'if (world->dword_5e351a == 1) {', 'if ((world->dword_5e351a & 0xffff) == 1) {'),
    ('4068c0', 'if (world->dword_5e351a == 1) {', 'if (world->dword_5e351a != 0) {'),
    ('4068c0', 'if (world->dword_5e351a == 1) {', 'if ((world->dword_5e351a & 1) != 0) {'),
    ('4068c0', 'world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;'),
    ('4068c0', 'world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;', 'world->dword_5e351a = 2;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;'),
    ('4068c0', '        world->dword_5e351a = 0;\n    } else {', '        world->dword_5e351a = 0;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;\n    } else {'),
    ('4068c0', '        world->dword_5e351a = 0;\n    } else {', '        world->dword_5e351a = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('4068c0', '        world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('4068c0', '        world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e351a = 1;\n        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('4068c0', '    if (world->dword_5e351a == 1) {\n        world->dword_5e351a = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e351a == 1) {\n        world->dword_5e351a = 0;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0x7fff;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;'),
    ('406907', 'if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x5) world->word_5e335e = 0xffff;'),
    ('406907', 'if (world->dword_5e351e == 1) {', 'if ((world->dword_5e351e & 0xffff) == 1) {'),
    ('406907', 'if (world->dword_5e351e == 1) {', 'if (world->dword_5e351e != 0) {'),
    ('406907', 'if (world->dword_5e351e == 1) {', 'if ((world->dword_5e351e & 1) != 0) {'),
    ('406907', 'world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;'),
    ('406907', 'world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;', 'world->dword_5e351e = 2;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;'),
    ('406907', '        world->dword_5e351e = 0;\n    } else {', '        world->dword_5e351e = 0;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;\n    } else {'),
    ('406907', '        world->dword_5e351e = 0;\n    } else {', '        world->dword_5e351e = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406907', '        world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406907', '        world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e351e = 1;\n        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406907', '    if (world->dword_5e351e == 1) {\n        world->dword_5e351e = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e351e == 1) {\n        world->dword_5e351e = 0;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0x7fff;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;'),
    ('40694e', 'if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x6) world->word_5e335e = 0xffff;'),
    ('40694e', 'if (world->dword_5e3522 == 1) {', 'if ((world->dword_5e3522 & 0xffff) == 1) {'),
    ('40694e', 'if (world->dword_5e3522 == 1) {', 'if (world->dword_5e3522 != 0) {'),
    ('40694e', 'if (world->dword_5e3522 == 1) {', 'if ((world->dword_5e3522 & 1) != 0) {'),
    ('40694e', 'world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;'),
    ('40694e', 'world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;', 'world->dword_5e3522 = 2;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;'),
    ('40694e', '        world->dword_5e3522 = 0;\n    } else {', '        world->dword_5e3522 = 0;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;\n    } else {'),
    ('40694e', '        world->dword_5e3522 = 0;\n    } else {', '        world->dword_5e3522 = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('40694e', '        world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('40694e', '        world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3522 = 1;\n        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('40694e', '    if (world->dword_5e3522 == 1) {\n        world->dword_5e3522 = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e3522 == 1) {\n        world->dword_5e3522 = 0;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0x7fff;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;'),
    ('406995', 'if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x7) world->word_5e335e = 0xffff;'),
    ('406995', 'if (world->dword_5e3526 == 1) {', 'if ((world->dword_5e3526 & 0xffff) == 1) {'),
    ('406995', 'if (world->dword_5e3526 == 1) {', 'if (world->dword_5e3526 != 0) {'),
    ('406995', 'if (world->dword_5e3526 == 1) {', 'if ((world->dword_5e3526 & 1) != 0) {'),
    ('406995', 'world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;'),
    ('406995', 'world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;', 'world->dword_5e3526 = 2;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;'),
    ('406995', '        world->dword_5e3526 = 0;\n    } else {', '        world->dword_5e3526 = 0;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;\n    } else {'),
    ('406995', '        world->dword_5e3526 = 0;\n    } else {', '        world->dword_5e3526 = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406995', '        world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406995', '        world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3526 = 1;\n        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406995', '    if (world->dword_5e3526 == 1) {\n        world->dword_5e3526 = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e3526 == 1) {\n        world->dword_5e3526 = 0;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0x7fff;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;'),
    ('4069dc', 'if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x8) world->word_5e335e = 0xffff;'),
    ('4069dc', 'if (world->dword_5e352a == 1) {', 'if ((world->dword_5e352a & 0xffff) == 1) {'),
    ('4069dc', 'if (world->dword_5e352a == 1) {', 'if (world->dword_5e352a != 0) {'),
    ('4069dc', 'if (world->dword_5e352a == 1) {', 'if ((world->dword_5e352a & 1) != 0) {'),
    ('4069dc', 'world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;'),
    ('4069dc', 'world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;', 'world->dword_5e352a = 2;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;'),
    ('4069dc', '        world->dword_5e352a = 0;\n    } else {', '        world->dword_5e352a = 0;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;\n    } else {'),
    ('4069dc', '        world->dword_5e352a = 0;\n    } else {', '        world->dword_5e352a = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('4069dc', '        world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('4069dc', '        world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e352a = 1;\n        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('4069dc', '    if (world->dword_5e352a == 1) {\n        world->dword_5e352a = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e352a == 1) {\n        world->dword_5e352a = 0;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0x7fff;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;'),
    ('406a23', 'if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0x9) world->word_5e335e = 0xffff;'),
    ('406a23', 'if (world->dword_5e352e == 1) {', 'if ((world->dword_5e352e & 0xffff) == 1) {'),
    ('406a23', 'if (world->dword_5e352e == 1) {', 'if (world->dword_5e352e != 0) {'),
    ('406a23', 'if (world->dword_5e352e == 1) {', 'if ((world->dword_5e352e & 1) != 0) {'),
    ('406a23', 'world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;'),
    ('406a23', 'world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;', 'world->dword_5e352e = 2;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;'),
    ('406a23', '        world->dword_5e352e = 0;\n    } else {', '        world->dword_5e352e = 0;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;\n    } else {'),
    ('406a23', '        world->dword_5e352e = 0;\n    } else {', '        world->dword_5e352e = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406a23', '        world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406a23', '        world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e352e = 1;\n        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406a23', '    if (world->dword_5e352e == 1) {\n        world->dword_5e352e = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e352e == 1) {\n        world->dword_5e352e = 0;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0x7fff;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;'),
    ('406a6a', 'if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0xa) world->word_5e335e = 0xffff;'),
    ('406a6a', 'if (world->dword_5e3532 == 1) {', 'if ((world->dword_5e3532 & 0xffff) == 1) {'),
    ('406a6a', 'if (world->dword_5e3532 == 1) {', 'if (world->dword_5e3532 != 0) {'),
    ('406a6a', 'if (world->dword_5e3532 == 1) {', 'if ((world->dword_5e3532 & 1) != 0) {'),
    ('406a6a', 'world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;'),
    ('406a6a', 'world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;', 'world->dword_5e3532 = 2;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;'),
    ('406a6a', '        world->dword_5e3532 = 0;\n    } else {', '        world->dword_5e3532 = 0;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;\n    } else {'),
    ('406a6a', '        world->dword_5e3532 = 0;\n    } else {', '        world->dword_5e3532 = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406a6a', '        world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406a6a', '        world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3532 = 1;\n        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406a6a', '    if (world->dword_5e3532 == 1) {\n        world->dword_5e3532 = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e3532 == 1) {\n        world->dword_5e3532 = 0;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0x7fff;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;'),
    ('406ab1', 'if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0xb) world->word_5e335e = 0xffff;'),
    ('406ab1', 'if (world->dword_5e3536 == 1) {', 'if ((world->dword_5e3536 & 0xffff) == 1) {'),
    ('406ab1', 'if (world->dword_5e3536 == 1) {', 'if (world->dword_5e3536 != 0) {'),
    ('406ab1', 'if (world->dword_5e3536 == 1) {', 'if ((world->dword_5e3536 & 1) != 0) {'),
    ('406ab1', 'world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;'),
    ('406ab1', 'world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;', 'world->dword_5e3536 = 2;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;'),
    ('406ab1', '        world->dword_5e3536 = 0;\n    } else {', '        world->dword_5e3536 = 0;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;\n    } else {'),
    ('406ab1', '        world->dword_5e3536 = 0;\n    } else {', '        world->dword_5e3536 = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406ab1', '        world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406ab1', '        world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e3536 = 1;\n        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406ab1', '    if (world->dword_5e3536 == 1) {\n        world->dword_5e3536 = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e3536 == 1) {\n        world->dword_5e3536 = 0;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((uint8_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0x7fff;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0xd) world->word_5e335e = 0xffff;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'if ((int16_t)world->word_5e335e != 0xc) world->word_5e335e = 0xffff;'),
    ('406af8', 'if (world->dword_5e353a == 1) {', 'if ((world->dword_5e353a & 0xffff) == 1) {'),
    ('406af8', 'if (world->dword_5e353a == 1) {', 'if (world->dword_5e353a != 0) {'),
    ('406af8', 'if (world->dword_5e353a == 1) {', 'if ((world->dword_5e353a & 1) != 0) {'),
    ('406af8', 'world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'world->dword_5e350a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;'),
    ('406af8', 'world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;', 'world->dword_5e353a = 2;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;'),
    ('406af8', '        world->dword_5e353a = 0;\n    } else {', '        world->dword_5e353a = 0;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;\n    } else {'),
    ('406af8', '        world->dword_5e353a = 0;\n    } else {', '        world->dword_5e353a = 0;\n        world->word_5e335e = 0xffff;\n    } else {'),
    ('406af8', '        world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)(self + 1));'),
    ('406af8', '        world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self);', '        world->dword_5e353a = 1;\n        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;\n    }\n    call0(host, 0x404be1, (uintptr_t)self * 0u);'),
    ('406af8', '    if (world->dword_5e353a == 1) {\n        world->dword_5e353a = 0;', '    call0(host, 0x404be1, (uintptr_t)self);\n    if (world->dword_5e353a == 1) {\n        world->dword_5e353a = 0;'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0)', 'if ((uint8_t)world->word_5e335e == 0x0)'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0)', 'if ((int16_t)world->word_5e335e <= 0x0)'),
    ('4067a5', 'if ((int16_t)world->word_5e335e == 0x0)', 'if ((int16_t)world->word_5e335e)'),
    ('4068c0', 'if ((int16_t)world->word_5e335e == 0x4)', 'if ((int16_t)world->word_5e335e >= 0x4)'),
    ('406af8', 'if ((int16_t)world->word_5e335e == 0xc)', 'if ((int16_t)world->word_5e335e <= 0xc)'),
]


def main():
    text = (SRC / 'original_methods_fl34b.c').read_text()
    survived = 0
    for key, old, new in HAND:
        if text.count(old) < 1:
            raise SystemExit('stale hand mutant: %r' % old)
        mutated = text.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            (tmp / 'original_methods_fl34b.c').write_text(mutated)
            for f in SRC.glob('original_methods_fl*.h'):
                shutil.copy(f, tmp / f.name)
            binary = tmp / 'direct'
            built = direct.build(binary, direct.TEST_C, tmp)
            where = None
            if built.returncode != 0:
                where = 'build'
            else:
                try:
                    done = subprocess.run([str(binary)], capture_output=True, text=True, timeout=20)
                    if done.returncode != 0:
                        where = 'direct'
                except subprocess.TimeoutExpired:
                    where = 'direct (timeout)'
            if where is None:
                child = subprocess.run([sys.executable, '-c', mc.DIFFERENTIAL_CHILD, str(tmp), mc.FUNCS[key]], capture_output=True, text=True, timeout=600, cwd=str(HERE.parent))
                where = 'differential' if child.returncode != 0 else 'SURVIVED'
        survived += where == 'SURVIVED'
        print('0x%s %-12s | %s' % (key, where, old[:60].replace('\n', ' ')))
    print('hand mutants %d, survivors %d' % (len(HAND), survived))
    return 1 if survived else 0


if __name__ == '__main__':
    sys.exit(main())
