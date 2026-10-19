"""FL-22 (batch a) mutation check: deliberately breaks one rule of src/original_methods_fl22a.c at a time and requires that the direct suite and
the original-x86 differential suite each fail (the source is restored after every mutation).

    python3 tests/fl22a_mutation_check.py [out.json] [label substrings...]
"""
import json
from pathlib import Path
import subprocess
import sys

PROJECT = Path(__file__).resolve().parents[1]
SOURCE = PROJECT / 'src/original_methods_fl22a.c'

MUTATIONS = [
    ('463392 deadline compare >= becomes >', 'if (tick_now(host) >= rd32(self, 0x4b))', 'if (tick_now(host) > rd32(self, 0x4b))'),
    ('463392 state 0 stores 2 into [self+0x3f]', 'wr32(self, 0x3f, 1);', 'wr32(self, 0x3f, 2);'),
    ('463392 v = 2 compares the wrong nine-byte pattern', '(0x54b1d4 - 0x54b164)', '(0x54b1bc - 0x54b164)'),
    ('463392 state 2 does not set 0x5bb1ca first', '        world->value_5bb1ca = 1;\n        if (!same9(rec + 0x24f, data + (0x54b1ec - 0x54b164)))',
     '        if (!same9(rec + 0x24f, data + (0x54b1ec - 0x54b164)))'),
    ('463392 jump table arms 1 and 2 swapped', '} else if (v == 1) {\n            wr32(self, 0x4b,', '} else if (v == 5) {\n            wr32(self, 0x4b,'),
    ('461d82 arm sign swapped', 'plus ? rd32(cell, field_a) + (uint32_t)quotient : rd32(cell, field_a) - (uint32_t)quotient',
     'plus ? rd32(cell, field_a) - (uint32_t)quotient : rd32(cell, field_a) + (uint32_t)quotient'),
    ('461d82 arm 2 moves the row the wrong way', 'return step_arm(self, world, rec, host, 0x18, 0x53, 1, 0x20, 0x5b, 1);',
     'return step_arm(self, world, rec, host, 0x18, 0x53, 1, 0x20, 0x5b, -1);'),
    ('461d82 the cell dword +0 test is inverted', 'if (rds16(cell, 0x24) == 0) {', 'if (rds16(cell, 0x24) != 0) {'),
    ('461d82 the counter is not cleared on completion', '        wr16(self, 0x59, 0);\n        wr32(self, 0x3b, 1);', '        wr16(self, 0x59, 1);\n        wr32(self, 0x3b, 1);'),
    ('4778df the byte 0x6237a5 is not cleared', 'world->byte_6237a5 = 0;', '(void)0;'),
    ('4778df the caption rows do not advance', 'rect[1] = rect[3];', 'rect[1] = rect[1];'),
    ('4778df the grid call passes the wrong record offset', 'rec_va + 0x646u', 'rec_va + 0x648u'),
    ('45d2c6 the 0x6247ee test for 2 becomes 1', 'world->word_6247ee == 0 || world->word_6247ee == 2', 'world->word_6247ee == 0 || world->word_6247ee == 1'),
    ('45d2c6 the dword 0x62475c is not cleared', 'world->value_62475c = 0;', '(void)0;'),
    ('45d2c6 the second kind test (== 1) becomes (== 0)', 'world->value_624758 != 6 || world->word_624890 == 1', 'world->value_624758 != 6 || world->word_624890 == 0'),
    ('45d2c6 loop 3 limit loses the - 1', 'rds16(rec, 0x23) - world->word_6247ec - 1', 'rds16(rec, 0x23) - world->word_6247ec'),
]


def run(module):
    done = subprocess.run([sys.executable, '-m', 'unittest', module], cwd=PROJECT, capture_output=True, text=True, timeout=900)
    return done.returncode != 0


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else None
    wanted = sys.argv[2:]
    original = SOURCE.read_text()
    results = []
    # the unmutated source must pass both suites, otherwise 'detected' proves nothing
    for module in ('tests.test_fl22a_direct', 'tests.test_fl22a_differential'):
        if run(module):
            raise SystemExit(f'baseline {module} fails on the unmutated source')
    try:
        for label, old, new in MUTATIONS:
            if wanted and not any(w in label for w in wanted):
                continue
            if original.count(old) < 1:
                results.append({'mutation': label, 'error': 'pattern not found'})
                continue
            SOURCE.write_text(original.replace(old, new, 1))
            direct = run('tests.test_fl22a_direct')
            differential = run('tests.test_fl22a_differential')
            results.append({'mutation': label, 'direct_detects': direct, 'differential_detects': differential})
            print(results[-1], flush=True)
    finally:
        SOURCE.write_text(original)
    summary = {'mutations': len(results), 'differential_detected': sum(1 for r in results if r.get('differential_detects')),
               'direct_detected': sum(1 for r in results if r.get('direct_detects')), 'results': results}
    print({k: v for k, v in summary.items() if k != 'results'})
    if out:
        Path(out).write_text(json.dumps(summary, indent=1))
    return 0 if summary['differential_detected'] == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
