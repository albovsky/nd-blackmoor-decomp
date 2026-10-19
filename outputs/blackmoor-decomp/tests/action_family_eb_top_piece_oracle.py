#!/usr/bin/env python3
"""FL-15: the original x86 top-piece helpers 0x47e9d3 (list 1) and 0x47e8fe (list 2) called directly on forced lists.

The empty list cannot be reached through a click: the native raw-0xeb kernel refuses the pick it leads to (K3, see
click_refusal in action_family_eb_runtime_original_oracle.py), so the full oracle never runs the helpers' empty-list
path. Here the unmodified GAME.EXE image is mapped under Unicorn by the RT-56 oracle's machine, object bytes are forced on
both sides for lists of 0, 1, 2, 3 and 4 pieces (ascending, descending, equal and negative layers, signed order), and the originals'
return values are compared with the oracle's own list_top (the same rule the native top_piece_of_list implements).
The native result for the same inputs comes from tests/fl13_eb_direct_test.c.
"""
import importlib.util
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
_spec = importlib.util.spec_from_file_location('eb_oracle', HERE / 'action_family_eb_runtime_original_oracle.py')
eb = importlib.util.module_from_spec(_spec)
sys.modules['eb_oracle'] = eb
_spec.loader.exec_module(eb)

CASES = [(0, [7, 8], {}), (1, [4], {4: 9}), (3, [0, 1, 2], {0: 1, 1: 2, 2: 3}), (3, [2, 1, 0], {0: 3, 1: 2, 2: 1}),
         (3, [0, 1, 2], {0: 2, 1: 2, 2: 2}), (4, [3, 1, 0, 2], {0: 4, 1: 1, 2: 1, 3: 4}), (2, [5, 6], {5: -3, 6: -4}), (2, [5, 6], {5: -1, 6: 5})]


def do_topcalls(ctx, where):
    for k, (n, lst, zs) in enumerate(CASES):
        for address, list_off, count_off in ((0x47e9d3, eb.O_LIST1, eb.O_COUNT1), (0x47e8fe, eb.O_LIST2, eb.O_COUNT2)):
            pokes = {count_off: eb.struct.pack('<h', n)}
            for j, piece in enumerate(lst):
                pokes[list_off + 2 * j] = eb.struct.pack('<h', piece)
            for piece, z in zs.items():
                pokes[eb.O_PIECES + eb.PIECE * piece] = eb.struct.pack('<h', z)
            eb.do_poke(ctx, '%s case %d' % (where, k), pokes)
            want = eb.list_top(ctx, list_off, count_off)
            got = ctx.x.run_op(address, [], eb.OBJ)
            if (got & 0xffff) != (want & 0xffff):
                raise eb.Mismatch('%s case %d: original %#x returned %#x, expected %#x' % (where, k, address, got & 0xffff, want & 0xffff))
            ctx.stats['top_calls'] += 1


def main():
    eb.PRIVATE.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='FL-15.top-', dir=eb.PRIVATE) as work:
        lib = eb.open_lib(eb.build_driver(eb.PROJECT / 'src', Path(work) / 'libdriver_eb.so'))
        x = eb.X86()
        # the standard runner sets the scene up; its known-case action k6 is pointed at the direct calls
        eb.act_known = lambda ctx, where, kind, args=(): do_topcalls(ctx, where)
        sc = eb.S([], 'top:direct', [eb.R(eb.good_body(eb.random.Random(57), n=5))], [('tick', eb.CLK), ('k6',)], 'known', seed=15)
        stats = eb.new_stats()
        bad = eb.run_list(x, lib, [sc], stats)
    if bad:
        print('MISMATCH', bad[0][0], bad[0][1][:400])
        return 1
    print('top_calls', stats['top_calls'])
    return 0


if __name__ == '__main__':
    sys.exit(main())
