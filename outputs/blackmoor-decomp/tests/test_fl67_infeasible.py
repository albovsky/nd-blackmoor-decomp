"""FL-67: the infeasibility prover (scripts/fl67_infeasible.py) and the proved rows of the tested-equivalent tier (tasks/fl67-infeasible.json).

Part 1 runs the prover on small hand-assembled functions: what it must prove impossible, and (as important) what it must NOT prove, including the cases where a modelling
assumption is switched off (a function that forms the address of its own frame gets no frame assumption) and where a null read does not fault.
Part 2 checks the manifest of proved rows against the ledger and the committed translations.
Part 3 (needs z3, Unicorn and the pinned private GAME.EXE) replays the kept scenarios of a sample of proved rows and re-proves every missing item, and runs the soundness oracle:
the prover must never call an instruction or a jump direction of a fully covered (tested-equivalent) row impossible.
"""
import json
import os
from pathlib import Path
import struct
import sys
import unittest
from unittest import mock

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(PROJECT / 'scripts'))

try:
    import z3  # noqa: F401
    import fl67_infeasible as P
    HAVE_Z3 = True
except ImportError:
    HAVE_Z3 = False

BASE = 0x401000


def _oracle_verdicts(k):
    """The verdicts the prover gives on every instruction and jump direction of a fully covered row. Run in its own process: z3's memory cap is per process and a query that
    reaches it leaves the rest of that process without memory."""
    try:
        out = P.prove_row(k, P.all_targets(P.row_of(k)), timeout_ms=5000)
    except z3.Z3Exception as ex:
        if 'out of memory' not in str(ex):
            raise
        return ['out of memory']                      # no verdict at all, so nothing is ruled out
    return [v[0] for v in list(out['instructions'].values()) + list(out['directions'].values())]


PROGRAMS = {
    # xor eax,eax; test eax,eax; je done; mov eax,1; done: ret
    'const_branch': '31c085c07405b801000000c3',
    # test ecx,ecx; je done; mov eax,1; done: ret
    'free_branch': '85c97405b801000000c3',
    # for (i = 0; i < 2; i++) { if (i == 0) ...; else if (i != 1) <never> }, i in a frame slot
    'frame_loop': '5589e551c745fc00000000837dfc027d28837dfc007507b805000000eb10837dfc017505b806000000b8070000008b4dfc83c101894dfcebd289ec5dc3',
    # the same loop with a store through the argument pointer: the frame assumption keeps the counter out of its reach
    'alias_loop': '5589e551c745fc00000000837dfc027d33837dfc007507b805000000eb12837dfc017507b806000000eb05b8070000008b5508c702630000008b4dfc83c101894dfcebc789ec5dc3',
    # the same with `lea eax, [ebp-4]` in front: the function forms a frame address, so the argument pointer may alias the counter
    'alias_loop_escape': '5589e551c745fc000000008d45fc837dfc027d33837dfc007507b805000000eb12837dfc017507b806000000eb05b8070000008b5508c702630000008b4dfc83c101894dfcebc789ec5dc3',
    # do { ecx-- } while (ecx != 0): a loop that cannot be unrolled
    'wrap_loop': '5589e58b4d084975fd89ec5dc3',
    # mov eax,[esp+4]; cmp eax,5; jb low; cmp eax,5; jb never; ret; low: ret; never: mov eax,9; ret
    'unsigned_pair': '8b44240483f805720683f8057202c3c3b809000000c3',
    # mov ecx,[esp+4]; mov eax,[ecx]; test ecx,ecx; je null; ret; null: mov eax,0; ret   (a read at address 0 does not fault in the world)
    'null_deref': '8b4c24048b0185c97401c3b800000000c3',
    # push ebp; mov ebp,esp; sub esp,8; L: mov [ebp-8],0; push eax; pop edx; mov [esp],1; dec ebx; jnz L; cmp [ebp-8],0; jne T; ret; T: ret
    # the loop changes esp, and [esp] is [ebp-8] in the loop: the jne is taken
    'gen_loop_moves_esp': '5589e583ec08c745f80000000050 5ac7042401000000 4b75ed 837df800 7501 c3c3'.replace(' ', ''),
    # push eax; mov [ebp],5; pop ecx; cmp ecx,eax; jne T; ret; T: ret   (a frame row starts with ebp = the entry frame address)
    'frame_row': '50c745000500000059 39c1 7501 c3c3'.replace(' ', ''),
    # cmp [esp+4],0; jne <outside the body>; ret
    'jcc_leaves_body': '837c24040075 39c3'.replace(' ', ''),
    # FL-73: i = 0 (a word in the frame); found = -1; while (i < (short)arg1) { if (arg2) { found = i; break; } i++; }
    # if (found == -1) return 2; if (i == -1) return 9 (never: i is not negative); return 1.   The loop header is at BASE + 0x20, `je never` at BASE + 0x4a.
    'word_counter': '5589e583ec0866c745fc000066c745faffffeb0c668b45fc6683c001668945fc0fbf45fc0fbf4d0839c87d0e807d0c0074e2668b45fc668945fa0fbf45fa83f8ff74100fbf4dfc83f9ff740eb801000000c9c3b802000000c9c3b809000000c9c3',
}


def analysis(name, **extra):
    code = bytes.fromhex(PROGRAMS[name])
    image = bytes(BASE - P.IMAGE_BASE) + code + bytes(64)
    an = P.Analysis(dict({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, **extra), image, 20000)
    an.run()
    return an, code


def verdicts(name, **extra):
    an, code = analysis(name, **extra)
    out = {}
    for ins in an.insns:
        out[('i', ins.address)] = an.instruction(ins.address)[0]
        if ins.mnemonic.startswith('j') and ins.mnemonic != 'jmp':
            out[('t', ins.address)] = an.direction(ins.address, 'taken')[0]
            out[('f', ins.address)] = an.direction(ins.address, 'fall-through')[0]
    return an, out


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Synthetic(unittest.TestCase):
    def test_a_constant_test_makes_one_direction_impossible(self):
        an, v = verdicts('const_branch')
        je = BASE + 4
        self.assertEqual(v[('f', je)], 'unsat')
        self.assertEqual(v[('t', je)], 'sat')
        self.assertEqual(v[('i', BASE + 6)], 'unsat')           # the instruction behind the impossible direction
        self.assertEqual(v[('i', BASE + 11)], 'sat')

    def test_a_free_register_leaves_both_directions_possible(self):
        an, v = verdicts('free_branch')
        self.assertEqual({v[('t', BASE + 2)], v[('f', BASE + 2)]}, {'sat'})

    def test_the_same_compare_twice(self):
        an, v = verdicts('unsigned_pair')
        second = [a for k, a in v.items() if k[0] == 't'][1:]
        jbs = sorted(k[1] for k in v if k[0] == 't')
        self.assertEqual(v[('t', jbs[1])], 'unsat')              # jb after the identical cmp and the not-taken first jb
        self.assertEqual(v[('f', jbs[1])], 'sat')

    def test_a_loop_unrolled_exactly(self):
        an, v = verdicts('frame_loop')
        self.assertNotIn('gen', an.plan.values())
        never = [k for k, x in v.items() if k[0] == 't' and x == 'unsat']
        self.assertTrue(never)                                   # jne never is impossible: the counter is 0 or 1 on a pass that gets there

    def test_the_frame_assumption_is_what_keeps_the_counter_out_of_reach(self):
        an, v = verdicts('alias_loop')
        self.assertTrue(an.M.split)
        self.assertTrue([k for k, x in v.items() if k[0] == 't' and x == 'unsat'])
        an, v = verdicts('alias_loop_escape')
        self.assertFalse(an.M.split)                             # lea of a frame slot: no frame assumption
        self.assertFalse([k for k, x in v.items() if k[0] == 't' and x == 'unsat' and k[1] > BASE + 20])

    def test_a_loop_with_an_unknown_trip_count_is_generalised_not_unrolled(self):
        an, v = verdicts('wrap_loop')
        self.assertIn('gen', an.plan.values())
        self.assertEqual({x for k, x in v.items() if k[0] in 'tf'}, {'sat'})

    def test_a_null_read_does_not_fault_so_the_null_test_stays_possible(self):
        an, v = verdicts('null_deref')
        self.assertEqual(v[('t', BASE + 8)], 'sat')

    def test_a_loop_that_moves_esp_keeps_its_frame_cells_together(self):
        an, v = verdicts('gen_loop_moves_esp')
        jne = BASE + len(bytes.fromhex(PROGRAMS['gen_loop_moves_esp'])) - 4
        self.assertEqual(v[('t', jne)], 'sat')

    def test_a_frame_row_gets_no_frame_assumption(self):
        an, v = verdicts('frame_row', frame=True)
        self.assertFalse(an.M.split)
        jne = BASE + len(bytes.fromhex(PROGRAMS['frame_row'])) - 4
        self.assertEqual(v[('t', jne)], 'sat')

    def test_a_jump_that_leaves_the_body_gives_no_verdict(self):
        code = bytes.fromhex(PROGRAMS['jcc_leaves_body'])
        image = bytes(BASE - P.IMAGE_BASE) + code + bytes(64)
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image, 5000)
        with self.assertRaises(P.Unsupported):
            an.run()

    def test_unsupported_instruction_gives_no_verdict(self):
        code = bytes.fromhex('d7c3')                             # xlat; ret
        image = bytes(BASE - P.IMAGE_BASE) + code + bytes(64)
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image, 5000)
        with self.assertRaises(P.Unsupported):
            an.run()


COUNTER_HEADER, COUNTER_NEVER = BASE + 0x20, BASE + 0x4a
COUNTER_SLOT = ['ebp', -4, 2]


def counter_analysis(atoms=None):
    """the word_counter program with the invariants `atoms` (a list) declared at its loop header, not yet run"""
    code = bytes.fromhex(PROGRAMS['word_counter'])
    image = bytes(BASE - P.IMAGE_BASE) + code + bytes(64)
    an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image, 20000)
    an.inv = {COUNTER_HEADER: atoms} if atoms else {}
    return an


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Invariants(unittest.TestCase):
    """FL-73: a loop invariant declared for a generalised header is assumed there only after the prover has shown it is inductive."""

    def test_without_an_invariant_the_counter_may_be_minus_one(self):
        an = counter_analysis()
        an.run()
        self.assertIn('gen', an.plan.values())
        self.assertEqual(an.direction(COUNTER_NEVER, 'taken')[0], 'sat')

    def test_an_inductive_invariant_rules_the_impossible_jump_out(self):
        an = counter_analysis([{'mem': COUNTER_SLOT, 'op': 'sge', 'val': 0}])
        an.run()
        self.assertEqual(an.direction(COUNTER_NEVER, 'taken')[0], 'unsat')
        self.assertEqual(an.direction(COUNTER_NEVER, 'fall-through')[0], 'sat')          # what can happen still can
        self.assertEqual(an.instruction(BASE + 0x4c)[0], 'sat')                           # mov eax, 1

    def test_an_invariant_that_a_back_edge_breaks_is_refused(self):
        an = counter_analysis([{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 0}])            # i is 0 on entry but the loop increments it
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('back edge', str(ctx.exception))

    def test_an_invariant_that_is_false_on_entry_is_refused(self):
        an = counter_analysis([{'mem': COUNTER_SLOT, 'op': 'sgt', 'val': 0}])           # i starts at 0
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('entry edge', str(ctx.exception))

    def test_a_contradictory_invariant_is_refused(self):
        an = counter_analysis([{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 0}, {'mem': COUNTER_SLOT, 'op': 'eq', 'val': 1}])
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('satisfiable', str(ctx.exception))

    def test_a_slot_compared_with_a_slot(self):
        an = counter_analysis([{'mem': COUNTER_SLOT, 'op': 'sge', 'val': 0}, {'mem': COUNTER_SLOT, 'op': 'sle', 'mem2': COUNTER_SLOT}])
        an.run()
        self.assertEqual(an.direction(COUNTER_NEVER, 'taken')[0], 'unsat')

    def test_an_or_atom_holds_when_one_alternative_does(self):
        """FL-75: {"or": [...]} atoms, proved like any atom: i >= 0 is inductive, so (i == 5 or i >= 0) is too, and it rules the same jump out"""
        an = counter_analysis([{'or': [{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 5}, {'mem': COUNTER_SLOT, 'op': 'sge', 'val': 0}]}])
        an.run()
        self.assertEqual(an.direction(COUNTER_NEVER, 'taken')[0], 'unsat')

    def test_an_or_atom_that_a_back_edge_breaks_is_refused(self):
        an = counter_analysis([{'or': [{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 0}, {'mem': COUNTER_SLOT, 'op': 'eq', 'val': 1}]}])      # i reaches 2
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('back edge', str(ctx.exception))

    def test_an_or_atom_that_is_false_on_entry_is_refused(self):
        an = counter_analysis([{'or': [{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 7}, {'mem': COUNTER_SLOT, 'op': 'eq', 'val': 8}]}])
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('entry edge', str(ctx.exception))

    def test_the_window_proof_uses_the_invariant_the_same_way(self):
        import fl71_window as Wn
        for atoms, verdict in (([], 'sat'), ([{'mem': COUNTER_SLOT, 'op': 'sge', 'val': 0}], 'unsat')):
            an, dom = Wn.from_analysis(counter_analysis(atoms))
            T = Wn.block_of(an, COUNTER_NEVER, True)
            with mock.patch.object(P.Analysis, 'loop_frame_writes', return_value=None):          # (a header that forgets the whole frame, as before round 9; with the bytes the loop does not write kept, [ebp-6] settles this jump without the invariant)
                got = Wn.prove_target(an, dom, T, ('dir', 'taken'))[0]
            self.assertEqual(got == 'unsat', verdict == 'unsat', (atoms, got))
        an, dom = Wn.from_analysis(counter_analysis([]))
        self.assertEqual(Wn.prove_target(an, dom, Wn.block_of(an, COUNTER_NEVER, True), ('dir', 'taken'))[0], 'unsat')

    def test_the_window_proof_refuses_a_broken_invariant(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(counter_analysis([{'mem': COUNTER_SLOT, 'op': 'eq', 'val': 0}]))
        T = Wn.block_of(an, COUNTER_NEVER, True)
        self.assertNotEqual(Wn.prove_target(an, dom, T, ('dir', 'taken'))[0], 'unsat')

    def test_the_committed_invariants_belong_to_a_known_function(self):
        data = json.loads(P.INVARIANTS.read_text())
        for va, headers in data.items():
            self.assertTrue(va.startswith('0x'))
            for header, atoms in headers.items():
                self.assertTrue(header.startswith('0x'))
                for at in atoms:
                    for a in at.get('or', [at]):
                        self.assertIn(a['op'], P._INV_OPS)
                        self.assertTrue(('val' in a) != ('mem2' in a))


# FL-75 programs (assembled with nasm, org 0x401000; the asm is in the comment). `tbl` and the callees sit behind the body, in the image.
TWO_TABLES = bytes.fromhex('8b44240483f8017713ff248523104000b901000000c3b902000000c3c3b909000000c310104000161040001d1040001d104000')
BAD_GUARD = bytes.fromhex('83fb0177178b442404ff248523104000b901000000c3b902000000c3c3b909000000c310104000161040001d1040001d104000')
# push ebp; mov ebp,esp; sub esp,8; mov [ebp-4],0; [lea ecx,[ebp-4];] mov eax,[ebp+8]; mov [eax],7; cmp [ebp-4],0; jne never; [lea ecx,[ebp-4];] mov eax,ecx; ...; never: mov eax,9; ...
# mov eax,[esp+4]; mov edx,[0x401000]; cmp eax,1; ja d; jmp [eax*4+tbl]; c1: mov ecx,1; ret; c2: mov ecx,2; ret; d: mov ecx,9; ret; tbl: dd c1, c2, c2, c1
CONST_LOAD = bytes.fromhex('8b4424048b150010400083f8017713ff248528104000b901000000c3b902000000c3b909000000c3161040001c1040001c10400016104000')
FRAME_EARLIER = bytes.fromhex('5589e583ec08c745fc000000008d4dfc8b4508c70007000000837dfc00750689c889ec5dc3b80900000089ec5dc3')
FRAME_LATER = bytes.fromhex('5589e583ec08c745fc000000008b4508c70007000000837dfc0075098d4dfc89c889ec5dc3b80900000089ec5dc3')
# call C; cmp eax,0x8000; jae never; ret; never: mov eax,9; ret; body_end: C: mov eax,[esp+4]; and eax,MASK; ret
RETBOUND = {m: bytes.fromhex('e80e0000003d008000007301c3b809000000c38b440424' + m + 'c3') for m in ('25ff7f0000', '25ffff0000', '2500000080')}
# push ebp; mov ebp,esp; sub esp,4; mov [ebp-4],0; mov eax,[ebp+8]; cmp eax,5; jne bad; mov eax,1; jmp done; bad: mov eax,100; cdq; idiv dword [ebp-4]; done: mov esp,ebp; pop ebp; ret
FAULT_LATER = bytes.fromhex('5589e583ec04c745fc000000008b450883f8057507b801000000eb09b86400000099f77dfc89ec5dc3')


# FAULT_LATER with a second exit on the path `bad`: cmp eax,6; jne tail; ... tail: mov esp,ebp; pop ebp; jmp 0x500000 (a tail call outside the body, which does not fault)
FAULT_OR_TAIL = bytes.fromhex('5589e583ec04c745fc000000008b450883f8057507b801000000eb0983f806750899f77dfc89ec5dc389ec5de9cfef0f00')
# push ebp; mov ebp,esp; mov eax,[ebp+8]; test eax,eax; jne tail; leave; jmp L; tail: mov eax,3; leave; jmp L; L: cmp esp,ebp; je yes; mov eax,1; ret; yes: mov eax,2; ret
LEAVE_JOIN = bytes.fromhex('5589e58b450885c07503c9eb08b803000000c9eb0039ec7406b801000000c3b802000000c3')

# push ebp; mov ebp,esp; sub esp,8; mov eax,fs:[0]; push eax; mov fs:[0],esp; [mov edx,fs:[0];] mov [ebp-4],0; mov eax,[ebp+8]; mov [eax],7; cmp [ebp-4],0; jne never; pop ecx; mov fs:[0],ecx; ...; never: ...
SEH = bytes.fromhex('5589e583ec0864a1000000005064892500000000c745fc000000008b4508c70007000000837dfc00750c5964890d0000000089ec5dc3b80900000089ec5dc3')
# push ebp; mov ebp,esp; jmp store; rd: mov eax,fs:[0]; mov [eax],ecx; ret; store: mov fs:[0],esp; jmp rd  (the read runs after the registration)
SEH_LOOP = bytes.fromhex('5589e5eb0964a1000000008908c364892500000000ebee')
SEH_REREAD = bytes.fromhex('5589e583ec0864a1000000005064892500000000648b1500000000c745fc000000008b4508c70007000000837dfc00750c5964890d0000000089ec5dc3b80900000089ec5dc3')

# push ebp; mov ebp,esp; sub esp,8; mov eax,[ebp+8]; mov [ebp-4],0; jmp hdr; inc: i++; hdr (0x1b): cmp [ebp-4],5; jge done; push 1; mov edx,[ebp-4]; cmp edx,4; ja never (0x29); mov [eax],7; pop ecx; jmp inc; never: pop ecx; ...
LOOP_INV = bytes.fromhex('5589e583ec088b4508c745fc00000000eb098b4dfc83c101894dfc837dfc057d196a018b55fc83fa047709c7000700000059ebde59b80900000089ec5dc3')


def image_of(code, tail=b''):
    return bytes(BASE - P.IMAGE_BASE) + code + tail + bytes(64)


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl75(unittest.TestCase):
    """FL-75: jump tables cut at their range check, the frame assumption per window, callee return bounds."""

    def two_tables(self, code=TWO_TABLES, tight=True, body=0x23):
        an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an.tight_tables = tight
        return an

    def test_a_table_is_cut_at_its_range_check_and_the_cut_is_proved(self):
        an = self.two_tables()
        an.run()
        self.assertEqual([len(t) for t in an.table.values()], [2])      # the next switch's two cells are no longer successors
        self.assertEqual(an.instruction(BASE + 0x1d)[0], 'unsat')       # c2: reachable only through those cells
        self.assertEqual(an.instruction(BASE + 0x16)[0], 'sat')

    def test_without_the_cut_the_table_runs_into_the_next_one(self):
        an = self.two_tables(tight=False)
        an.run()
        self.assertEqual([len(t) for t in an.table.values()], [4])
        self.assertEqual(an.instruction(BASE + 0x1d)[0], 'unsat')       # the range check still rules the cells out, the graph just has the extra edges

    def test_a_cut_that_the_prover_cannot_justify_is_refused(self):
        an = self.two_tables(BAD_GUARD)                                # the range check is on ebx, the index is eax
        with self.assertRaises(P.Unsupported) as ctx:
            an.run()
        self.assertIn('table escape', str(ctx.exception))

    def test_a_window_keeps_a_cut_that_is_proved_and_drops_one_that_is_not(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(self.two_tables())
        self.assertEqual([len(t) for t in an.table.values()], [2])           # the guard is on the index: the table stays cut
        an, dom = Wn.from_analysis(self.two_tables(BAD_GUARD))
        self.assertEqual([len(t) for t in an.table.values()], [4])           # the guard is on ebx: the whole table

    def test_a_window_does_not_use_a_cut_nobody_has_proved(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(self.two_tables(BAD_GUARD))
        c2 = BASE + 0x1d                                                # reachable with eax == 2, ebx <= 1: the range check is on ebx, so the cut to two cells is wrong
        self.assertIn(Wn.block_of(an, c2), an.reach)
        self.assertNotEqual(Wn.prove_faults(an, dom, ('ins', c2))[0], 'unsat')

    def test_a_cut_table_that_no_run_reaches_does_not_stop_the_window_build(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(self.two_tables(b'\xc3\x90\x90\x90' + TWO_TABLES[4:]))     # ret first: the switch is unreachable
        self.assertEqual([len(t) for t in an.table.values()], [2])           # nothing can run it, the cut stays

    def test_the_constant_memory_cache_matches_the_facts_after_cut_validation(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(self.two_tables(CONST_LOAD, body=0x28))     # the switch block reads image bytes before the jump
        self.assertTrue(an.cut)
        self.assertTrue(an.M.fact_keys)
        self.assertEqual(len(an.M.fact_keys), len(an.M.facts))           # a key without its fact would never be added again

    def seh_row(self, code):
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an.run()
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        return an, an.direction(jne, 'taken')[0]

    def test_the_exception_chain_registration_of_a_prologue_keeps_the_frame_assumption(self):
        an, verdict = self.seh_row(SEH)
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        self.assertEqual(verdict, 'unsat')                              # [ebp-4] = 0; a store through the argument pointer; [ebp-4] != 0 ?

    def test_a_read_of_the_exception_chain_that_a_jump_can_run_after_the_registration_keeps_no_frame_assumption(self):
        an = P.Analysis({'va': BASE, 'body': len(SEH_LOOP), 'callees': {}, 'imports': {}, 'sites': None}, image_of(SEH_LOOP), 20000)
        self.assertEqual(len(an.esc_addrs), 1)                           # the read sits in front of the registration by address only

    def test_a_function_that_reads_the_exception_chain_after_registering_it_keeps_no_frame_assumption(self):
        an, verdict = self.seh_row(SEH_REREAD)
        self.assertEqual(len(an.esc_addrs), 1)
        self.assertFalse(an.M.split)
        self.assertEqual(verdict, 'sat')

    def loop_window(self, atoms):
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(LOOP_INV), 'callees': {}, 'imports': {}, 'sites': None}, image_of(LOOP_INV), 20000)
        an.inv = {BASE + 0x1b: atoms} if atoms else {}
        an, dom = Wn.from_analysis(an)
        return Wn.prove_target(an, dom, Wn.block_of(an, BASE + 0x29, True), ('dir', 'taken'))[0]

    def test_a_window_before_a_loop_proves_an_invariant_for_a_target_inside_the_loop_and_keeps_the_stack_tie(self):
        self.assertEqual(self.loop_window([{'mem': ['ebp', -4, 4], 'op': 'sge', 'val': 0}]), 'unsat')      # 0 <= i < 5, so the unsigned compare with 4 never jumps; the push in the body balances the pop

    def test_without_the_invariant_the_loop_counter_may_be_negative(self):
        self.assertNotEqual(self.loop_window(None), 'unsat')

    def test_an_invariant_the_body_breaks_is_refused_in_a_window(self):
        self.assertNotEqual(self.loop_window([{'mem': ['ebp', -4, 4], 'op': 'eq', 'val': 0}]), 'unsat')

    def jne_window(self, code):
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        self.assertFalse(an.M.split)                                   # the lea: no whole-function frame assumption
        an, dom = Wn.from_analysis(an)
        jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
        return Wn.prove_target(an, dom, Wn.block_of(an, jne, True), ('dir', 'taken'))[0]

    def test_a_target_in_front_of_the_first_frame_address_gets_the_frame_assumption_in_a_window(self):
        self.assertEqual(self.jne_window(FRAME_LATER), 'unsat')        # [ebp-4] = 0; a store through the argument pointer; [ebp-4] != 0 ?  (the lea comes after)

    def test_a_target_behind_a_frame_address_gets_no_frame_assumption(self):
        self.assertNotEqual(self.jne_window(FRAME_EARLIER), 'unsat')   # the same code with the lea in front: the pointer may alias the slot

    def fault_window(self, mark):
        import fl71_window as Wn
        code = FAULT_LATER
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an, dom = Wn.from_analysis(an)
        jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
        return an, Wn, dom, jne

    def test_the_stack_pointer_is_related_to_the_frame_pointer_in_every_block(self):
        an, Wn, dom, jne = self.fault_window(None)
        delta = Wn.stack_delta(an)
        self.assertEqual(delta[BASE + 0x15], -4)                        # after `sub esp, 4`, esp is four below ebp on both branches
        self.assertEqual(delta[BASE + 0x1c], -4)
        self.assertNotIn(BASE, delta)                                   # the entry block starts before the prologue

    def test_the_stack_pointer_tie_is_dropped_behind_a_16_bit_push(self):
        import fl71_window as Wn
        code = bytes.fromhex('5589e5665085c0740290 90c3'.replace(' ', ''))   # push ebp; mov ebp,esp; push ax; test eax,eax; je L; nop; nop; L: ret
        self.assertEqual(len(code), 12)
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an, dom = Wn.from_analysis(an)
        self.assertNotIn(BASE + 9, Wn.stack_delta(an))                  # esp moved by 2, not 4

    def test_a_path_whose_every_run_faults_later_is_proved_unreachable_by_the_forward_window(self):
        an, Wn, dom, jne = self.fault_window(None)
        self.assertEqual(Wn.prove_faults(an, dom, ('dir', jne, 'taken'))[0], 'unsat')   # [ebp-4] = 0 reaches the idiv on every run through `bad`
        self.assertNotEqual(Wn.prove_faults(an, dom, ('dir', jne, 'fall'))[0], 'unsat')  # the other direction returns without a fault

    def test_the_committed_plan_hints_name_known_bounds(self):
        hints = P.load_plan_hints(0x44b641)
        self.assertEqual(hints[0x44b9c0], 9)
        self.assertEqual(hints[0x44b75e], 'gen')
        data = json.loads(P.PLANS.read_text())
        for va, plan in data.items():
            for h, v in plan.items():
                self.assertTrue(v == 'gen' or v in P.UNROLL or v == P.HINT_ONLY, (va, h, v))
        self.assertEqual(P.load_plan_hints(0x401000), {})

    def test_a_path_that_may_leave_by_a_tail_jump_is_not_one_that_faults_later(self):
        import fl71_window as Wn
        code = FAULT_OR_TAIL
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an, dom = Wn.from_analysis(an)
        jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
        self.assertNotEqual(Wn.prove_faults(an, dom, ('dir', jne, 'taken'))[0], 'unsat')        # eax == 5 is excluded, eax == 6 divides by zero, any other value jumps out of the function

    def retbound(self, key):
        code = RETBOUND[key]
        an = P.Analysis({'va': BASE, 'body': 0x13, 'callees': {BASE + 0x13: 0}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an.run()
        return an

    def test_a_callee_that_masks_eax_bounds_what_it_returns(self):
        an = self.retbound('25ff7f0000')
        self.assertEqual(an.M.ret_bound(BASE + 0x13), 0x7fff)
        self.assertEqual(an.direction(BASE + 0xa, 'taken')[0], 'unsat')       # cmp eax,0x8000; jae never
        an = self.retbound('25ffff0000')
        self.assertEqual(an.M.ret_bound(BASE + 0x13), 0xffff)
        self.assertEqual(an.direction(BASE + 0xa, 'taken')[0], 'sat')

    def test_a_callee_whose_mask_can_be_negative_has_no_bound(self):
        an = self.retbound('2500000080')
        self.assertIsNone(an.M.ret_bound(BASE + 0x13))

    def test_a_callee_with_a_jump_has_no_bound(self):
        code = bytes.fromhex('e80e0000003d008000007301c3b809000000c3') + bytes.fromhex('8b4424048b0085c07401c3 25ff7f0000c3'.replace(' ', ''))
        an = P.Analysis({'va': BASE, 'body': 0x13, 'callees': {BASE + 0x13: 0}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        self.assertIsNone(an.M.ret_bound(BASE + 0x13))

# FL-78 programs (nasm, org 0x401000, the listed library function `lib` is a bare `ret` behind the body):
#   push ebp; mov ebp,esp; sub esp,8; mov [ebp-4],0; <the lea / pushes / call below>; add esp,12; mov eax,[ebp+8]; mov [eax],7; cmp [ebp-4],0; jne never; mov eax,1; leave; ret; never: mov eax,9; leave; ret; lib: ret
#   (a store through the argument pointer between the call and the compare: the frame assumption keeps [ebp-4] out of its reach)
LIB78 = {
    'ok_source': (64, '5589e583ec08c745fc000000008d55f85268002040006800304000e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),     # lea edx,[ebp-8]; push edx; push 0x402000; push 0x403000; call lib
    'dest_arg': (64, '5589e583ec08c745fc000000008d55f86800204000680030400052e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),      # push edx last: the destination position
    'read_after': (66, '5589e583ec08c745fc000000008d55f85268002040006800304000e82200000083c40c89d68b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # mov esi,edx after the add esp
    'no_add': (62, '5589e583ec08c745fc000000008d55f85268002040006800304000e81e000000908b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),          # a nop where the add esp should be
    'ecx_then_call': (69, '5589e583ec08c745fc000000008d4df85168002040006800304000e82500000083c40ce81e0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c38b01c3'),   # lea ecx: a second call whose callee reads ecx (mov eax,[ecx]; ret)
    'ecx_then_call_free': (69, '5589e583ec08c745fc000000008d4df85168002040006800304000e82500000083c40ce81e0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3b900000000c3'),   # the same, the second callee overwrites ecx (mov ecx,0; ret) before anything reads it
    'ecx_call_keeps': (69, '5589e583ec08c745fc000000008d4df85168002040006800304000e82500000083c40ce81e0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3c3'),   # the second callee is a bare ret: it neither reads nor overwrites ecx, which keeps the frame address
    'ecx_import': (70, '5589e583ec08c745fc000000008d4df85168002040006800304000e82600000083c40cff15000140008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # the second call is call [0x400100]: a Win32 import when the row lists the slot
    'fmt_reg': (60, '5589e583ec08c745fc000000008d55f852566800304000e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # the format is whatever is in esi
    'fmt_is_frame': (59, '5589e583ec08c745fc000000008d55f8526800304000e82000000083c4088b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # the frame address is argument 1, the format
    'push_ebp': (65, '5589e583ec08c745fc000000008d55f8525568002040006800304000e82000000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # push ebp (the frame base) as a further argument
    'call_keeps_edx': (69, '5589e583ec08c745fc000000008d55f85268002040006800304000e82500000083c40ce81e0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3c3'),   # call g after the call; g is a bare ret and keeps edx
    'call_kills_edx': (69, '5589e583ec08c745fc000000008d55f85268002040006800304000e82500000083c40ce81e0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3ba01000000c3'),   # the same, g is mov edx,1; ret
    'call_keeps_edx_read': (75, '5589e583ec08c745fc000000008d55f85268002040006800304000e82b00000083c40ce824000000c702050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3c3'),   # call g (a bare ret: edx keeps the frame address); mov [edx],5
    'ecx_call_keeps_read': (75, '5589e583ec08c745fc000000008d4df85168002040006800304000e82b00000083c40ce824000000c701050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3c3'),   # the same with ecx
    'call_writes_ax': (77, '5589e583ec08c745fc000000008d45f85068002040006800304000e82d00000083c40ce8260000000fbfc8b8050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c36631c0c3'),   # lea eax; call g (xor ax,ax; ret); movsx ecx,ax; mov eax,5: only ax is read, and the callee wrote it
    'call_writes_ax_read_eax': (76, '5589e583ec08c745fc000000008d45f85068002040006800304000e82c00000083c40ce82500000089c1b8050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c36631c0c3'),   # the same, but mov ecx,eax reads the upper half that still holds the address
    'cmov_after': (73, '5589e583ec08c745fc000000008d55f85268002040006800304000e82900000083c40c0f44d0c702050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # cmovz edx,eax; mov [edx],5 after the call: the cmov may keep the frame address
    'branch_between': (68, '5589e583ec08c745fc000000008d55f885c074005268002040006800304000e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # test eax,eax; je skip; skip: between lea and push
    'copy_kept': (66, '5589e583ec08c745fc000000008d55f85289d668002040006800304000e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),      # mov esi,edx between the pushes
    'killed_by_write': (69, '5589e583ec08c745fc000000008d55f85268002040006800304000e82500000083c40cba050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),    # mov edx,5 after the add esp
    'stored_elsewhere': (67, '5589e583ec08c745fc000000008d55f8528955fc68002040006800304000e82000000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3c3'),   # mov [ebp-4],edx between the pushes
}


def lib78_image(code, fmt=b'hi\0', extra=b''):
    """the image of a LIB78 program with a format string at 0x402000 and a buffer behind 0x403000"""
    img = bytearray(image_of(code))
    img.extend(bytes(0x403100 - P.IMAGE_BASE - len(img)))
    off = 0x402000 - P.IMAGE_BASE
    img[off:off + len(fmt)] = fmt
    img[0x1800:0x1800 + len(extra)] = extra                                  # other code of the image, at BASE + 0x800
    return bytes(img)


def lib78(name, listed=True, tight=True, fmt=b'hi\0', imports=None, extra=b''):
    """(analysis, the address of the library function) for a LIB78 program; `listed` puts the function on LIBRARY_WRITERS for the analysis"""
    from unittest import mock
    body, hexcode = LIB78[name]
    code = bytes.fromhex(hexcode)
    lib = BASE + body
    ctx = mock.patch.dict(P.LIBRARY_WRITERS, {lib: ('sprintf', (0,))} if listed else {}, clear=True)
    ctx.start()
    try:
        callees = {lib: 0, lib + 1: 0} if name.startswith(('ecx_', 'call_')) else {lib: 0}             # the second call of those programs is `g`, right behind the one-byte library function
        an = P.Analysis({'va': BASE, 'body': body, 'callees': callees, 'imports': imports or {}, 'sites': None}, lib78_image(code, fmt, extra), 20000)
        if tight:
            an.run()
    finally:
        ctx.stop()
    return an, lib


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78(unittest.TestCase):
    """FL-78: a frame address that is a source argument of a listed library call keeps the frame assumption (decision taken as the recommended default under the 2-hour rule)."""

    def jne_never(self, an):
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        return an.direction(jne, 'taken')[0]

    def test_a_source_argument_of_a_listed_call_keeps_the_frame_assumption(self):
        an, lib = lib78('ok_source')
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        self.assertEqual(self.jne_never(an), 'unsat')                    # [ebp-4] = 0; a store through the argument pointer; [ebp-4] != 0 ?

    def test_the_same_call_not_on_the_list_still_switches_the_assumption_off(self):
        an, lib = lib78('ok_source', listed=False)
        self.assertEqual(len(an.esc_addrs), 1)
        self.assertFalse(an.M.split)
        self.assertEqual(self.jne_never(an), 'sat')

    def test_without_the_rule_the_listed_call_would_not_help(self):
        from unittest import mock
        with mock.patch.object(P, 'library_arg_lea', return_value=False):
            an, lib = lib78('ok_source')
        self.assertFalse(an.M.split)
        self.assertEqual(self.jne_never(an), 'sat')

    def test_an_address_that_goes_anywhere_else_switches_it_off(self):
        for name in ('dest_arg', 'read_after', 'no_add', 'ecx_then_call', 'branch_between', 'copy_kept', 'stored_elsewhere', 'fmt_reg', 'fmt_is_frame', 'push_ebp', 'call_keeps_edx_read', 'ecx_call_keeps_read', 'call_writes_ax_read_eax'):
            an, lib = lib78(name)
            self.assertEqual(len(an.esc_addrs), 2 if name == 'push_ebp' else 1, name)          # (round 8 review: the pushed frame base is an escape of its own)
            self.assertFalse(an.M.split, name)
            self.assertEqual(self.jne_never(an), 'sat', name)

    def test_ecx_is_dead_across_a_call_whose_callee_overwrites_it_first(self):
        an, lib = lib78('ecx_then_call_free')
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(self.jne_never(an), 'unsat')

    def test_a_callee_that_keeps_a_register_leaves_the_address_in_it_for_the_code_behind(self):      # FL-78 review (major 3): a call does not end the life of eax / ecx / edx by itself
        for name in ('call_kills_edx', 'call_keeps_edx', 'ecx_call_keeps', 'call_writes_ax'):           # nothing reads the register behind the call, or the callee overwrites it, or only the part the callee wrote is read
            an, lib = lib78(name)
            self.assertEqual(an.esc_addrs, [], name)
        for name in ('call_keeps_edx_read', 'ecx_call_keeps_read', 'call_writes_ax_read_eax'):          # the code behind the call reads what the callee kept
            an, lib = lib78(name)
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_an_import_kills_a_register_only_when_it_is_in_the_import_table(self):                  # FL-78 review: any absolute call into the image used to count
        an, lib = lib78('ecx_import', imports={0x400100: 0})
        self.assertEqual(an.esc_addrs, [])
        an, lib = lib78('ecx_import')
        self.assertEqual(len(an.esc_addrs), 1)

    def test_a_conditional_move_does_not_kill_its_destination(self):                                # FL-78 review (minor a)
        from unittest import mock
        an, lib = lib78('cmov_after', tight=False)                                                  # (the semantics have no cmov: only the frame-address analysis of __init__ is looked at)
        self.assertEqual(len(an.esc_addrs), 1)

        def old_rw(i):                                                                              # the register accesses as they were before: the destination of a cmov counted as written only
            rd, wr = i.regs_access()
            return {i.reg_name(r) for r in rd}, {i.reg_name(r) for r in wr}
        with mock.patch.object(P, '_rw_raw', old_rw):
            an, lib = lib78('cmov_after', tight=False)
        self.assertEqual(an.esc_addrs, [])                                                          # without the change the program was accepted

    def test_the_format_must_be_a_constant_without_percent_n(self):                               # FL-78 review (minor b)
        an, lib = lib78('ok_source', fmt=b'%n\0')
        self.assertEqual(len(an.esc_addrs), 1)
        an, lib = lib78('ok_source', fmt=b'a%d%n\0')
        self.assertEqual(len(an.esc_addrs), 1)
        an, lib = lib78('ok_source', fmt=b'a%d\0')
        self.assertEqual(an.esc_addrs, [])

    def test_a_format_that_only_reads_its_arguments_is_accepted(self):                            # FL-78 second review: the allow list of conversions
        for fmt in (b'x=%s, chan %d, pos %4.2f %-8.3f %+5d %#x %hd %ld %Lf %I64d %% %c %u %o %e %E %g %G %X %i\0', b'plain\0'):
            an, lib = lib78('ok_source', fmt=fmt)
            self.assertEqual(an.esc_addrs, [], fmt)

    def test_every_form_of_n_and_every_unknown_conversion_is_refused(self):                       # FL-78 second review (major): %hn %ln %5n %1$n
        for fmt in (b'%hn\0', b'%ln\0', b'%5n\0', b'%1$n\0', b'%hhn\0', b'%I64n\0', b'%.2n\0', b'%*d\0', b'%.*s\0', b'%p\0', b'%S\0', b'%a\0', b'%\0', b'a%\0', b'%d%5n\0', b'%1$s\0'):
            an, lib = lib78('ok_source', fmt=fmt)
            self.assertEqual(len(an.esc_addrs), 1, fmt)

    def test_an_empty_or_unprintable_format_is_refused(self):                                      # FL-78 second review: an empty string (a zero-initialised buffer built at run time) and non-text
        for fmt in (b'\0', b'a\x01b\0', b'a\xffb\0', b'a' * 300 + b'\0'):
            an, lib = lib78('ok_source', fmt=fmt)
            self.assertEqual(len(an.esc_addrs), 1, fmt)

    def test_a_format_that_the_image_writes_or_hands_on_is_refused(self):                          # FL-78 second review: references to the string elsewhere in the image
        rel = lambda at: struct.pack('<i', (BASE + 64) - (at + 5))
        at = BASE + 0x800
        fine = bytes.fromhex('6800204000') + bytes.fromhex('6800304000') + b'\xe8' + rel(at + 10)                  # push fmt; push dest; call sprintf: another sprintf with the same literal
        an, lib = lib78('ok_source', extra=fine)
        self.assertEqual(an.esc_addrs, [])
        cases = {
            'absolute byte write': bytes.fromhex('c6050120400000'),                                         # mov byte [0x402001], 0
            'absolute store of eax': bytes.fromhex('a300204000'),                                           # mov [0x402000], eax
            'address in a register': bytes.fromhex('b800204000'),                                           # mov eax, 0x402000 (a pointer that may go anywhere)
            'pointer to the middle': bytes.fromhex('6801204000'),                                           # push 0x402001
            'format as destination': bytes.fromhex('6800204000') + b'\xe8' + rel(at + 5),                    # push fmt; call sprintf: the string is argument 0
            'handed to another call': bytes.fromhex('6800204000') + bytes.fromhex('6800304000') + b'\xe8' + struct.pack('<i', 0x1000),     # push fmt; push x; call elsewhere
            'in a table of pointers': bytes.fromhex('00204000'),                                            # the address as data
        }
        for name, extra in cases.items():
            an, lib = lib78('ok_source', extra=extra)
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_the_format_that_is_not_a_literal_switches_it_off(self):
        for name in ('fmt_reg', 'fmt_is_frame'):
            an, lib = lib78(name)
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_pushing_the_frame_base_between_switches_it_off(self):                                 # FL-78 review (minor c)
        an, lib = lib78('push_ebp')
        self.assertEqual(len(an.esc_addrs), 2)                                                      # the lea, and (round 8 review) the push of the frame base itself

    def test_a_register_that_is_overwritten_after_the_call_is_dead(self):
        an, lib = lib78('killed_by_write')
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(self.jne_never(an), 'unsat')

    def test_a_window_after_the_call_gets_the_frame_assumption(self):
        import fl71_window as Wn
        for listed, want in ((True, 'unsat'), (False, 'sat')):
            an, lib = lib78('ok_source', listed=listed, tight=False)
            an, dom = Wn.from_analysis(an)
            jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
            got = Wn.prove_target(an, dom, Wn.block_of(an, jne, True), ('dir', 'taken'))[0]
            self.assertEqual(got == 'unsat', want == 'unsat', (listed, got))

    def test_the_committed_list_names_the_crt_sprintf(self):
        self.assertEqual(P.LIBRARY_WRITERS[0x50ca3e], ('sprintf', (0,)))


# FL-78 programs for the library functions of the third review round (nasm, org 0x401000): PRO (frame 0x20, [ebp-4] = 0), a setup, the common tail (a store through the argument pointer, then cmp [ebp-4],0; jne never), and behind the body the helper functions
# at BASE + 0x100 (lib: a bare ret), + 0x140 (cal) and + 0x180 (rec). cmps_* have an own prologue that saves esi and edi.
LIB2 = {
    'fopen_src': (59, '5589e583ec20c745fc000000008d55e4680020400052e8e500000083c4088b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_short': (63, '5589e583ec20c745fc000000008d55e468003040006a056a0452e8e100000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_long': (63, '5589e583ec20c745fc000000008d55e468003040006a076a0452e8e100000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_reg_count': (67, '5589e583ec20c745fc000000008d55e4b9050000006800304000516a0452e8dd00000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c3909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_stream': (63, '5589e583ec20c745fc000000008d55e4526a056a046800304000e8e100000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_before': (63, '5589e583ec20c745fc0000000068003040006a056a048d55e452e8e100000083c4108b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'dest_any': (59, '5589e583ec20c745fc000000008d55e4680020400052e8e500000083c4088b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'regsetup_ok': (68, '5589e583ec20c745fc000000008d55e45268002040008b4508051f03000050e8dc00000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'regsetup_ebp': (62, '5589e583ec20c745fc000000008d55e452680020400089e850e8e200000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'regsetup_lea': (63, '5589e583ec20c745fc000000008d55e45268002040008d45f050e8e100000083c40c8b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'ro_ok': (51, '5589e583ec20c745fc000000008d45e450e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c40431c05dc20400'),
    'ro_store': (51, '5589e583ec20c745fc000000008d45e450e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b4508c7000100000050e8aeffffff83c40431c05dc20400'),
    'ro_keep': (51, '5589e583ec20c745fc000000008d45e450e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c4045dc20400'),
    'ro_other': (51, '5589e583ec20c745fc000000008d45e450e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e83400000083c40431c05dc2040090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'ro_twice': (51, '5589e583ec20c745fc000000008d45e450e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c4048b4d08c7010100000031c05dc20400'),
    'ro_edx_ok': (51, '5589e583ec20c745fc000000008d55e452e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c40431c05dc20400'),
    'ro_edx_read_after': (57, '5589e583ec20c745fc000000008d55e452e82a010000c702050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c40431c05dc20400'),
    'ro_edx_kept': (51, '5589e583ec20c745fc000000008d55e452e82a0100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b550852e8b4ffffff83c40431c05dc20400'),
    'ret_used': (65, '5589e583ec20c745fc000000008d45e45068002040008b4d0851e8e100000083c40c89c18b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3'),
    'ro_member': (54, '5589e583ec20c745fc000000008d55e4528b4d08e8270100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b450850e8b4ffffff83c40431c05dc20400'),
    'cmps_ok': (63, '5589e583ec205657c745fc000000008d75e4bf00204000b905000000f3a68b4508c70007000000837dfc007509b8010000005f5ec9c3b8090000005f5ec9c390'),
    'cmps_read_after': (69, '5589e583ec205657c745fc000000008d75e4bf00204000b905000000f3a6c706050000008b4508c70007000000837dfc007509b8010000005f5ec9c3b8090000005f5ec9c390'),
    'cmps_movs': (63, '5589e583ec205657c745fc000000008d75e4bf00204000b905000000f3a48b4508c70007000000837dfc007509b8010000005f5ec9c3b8090000005f5ec9c390'),
    'cmps_first_read': (65, '5589e583ec205657c745fc000000008d75e489f0bf00204000b905000000f3a68b4508c70007000000837dfc007509b8010000005f5ec9c3b8090000005f5ec9c390'),
    'rec_kills': (68, '5589e583ec20c745fc000000008d4de45168002040008b450850e8e100000083c40ce8590100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090803d00304000007405e8f2ffffffb900000000c3'),
    'rec_reads': (68, '5589e583ec20c745fc000000008d4de45168002040008b450850e8e100000083c40ce8590100008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909089c8803d00304000007405e8f0ffffffb900000000c3'),
    'rec_keeps': (74, '5589e583ec20c745fc000000008d4de45168002040008b450850e8e100000083c40ce859010000c701050000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c39090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090803d00304000007405e8f2ffffffc3'),
    'pure_ok': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e583c4f48945fcd97df8df7df48b45f48b55f8c9c3'),
    'pure_esp': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b442408c7401001000000c9c3'),
    'pure_pos': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e5c7450401000000c9c3'),
    'pure_reg': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e58b4508c7401001000000c9c3'),
    'pure_x87': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e5df7d08c9c3'),
    'pure_jmp': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e585c0740190c9c3'),
    'pure_call': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e5e800000000c9c3'),
    'pure_stos': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e589c7abc9c3'),
    'pure_ebp': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e589c5c745fc01000000c9c3'),
    'pure_seg': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e564c745fc01000000c9c3'),
    'pure_idx': (51, '5589e583ec20c745fc000000008b4508c7401005000000e8240100008b4508837810057507b801000000c9c3b809000000c9c390909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090905589e5c74405fc01000000c9c3'),
}


def lib2(name, writers, callees=None, tight=True, returns=None):
    """(analysis, address of lib) for a LIB2 program; `writers` is the LIBRARY_WRITERS entry given to lib (None: not listed), `returns` replaces LIBRARY_RETURNS"""
    from unittest import mock
    body, hexcode = LIB2[name]
    lib = BASE + 0x100
    table = {} if writers is None else {lib: writers}
    ctx = mock.patch.dict(P.LIBRARY_WRITERS, table, clear=True)
    ctx2 = mock.patch.object(P, 'LIBRARY_RETURNS', set(returns or ()))
    ctx.start()
    ctx2.start()
    try:
        an = P.Analysis({'va': BASE, 'body': body, 'callees': callees if callees is not None else {lib: 0, BASE + 0x140: 4, BASE + 0x180: 0}, 'imports': {}, 'sites': None}, lib78_image(bytes.fromhex(hexcode), b'hi\0'), 20000)
        if tight:
            an.run()
    finally:
        ctx2.stop()
        ctx.stop()
    return an, lib


FREAD = ('fread', (0,), ('mul', 1, 2), (0,))                                                   # the shape of the committed entry of the CRT fread
FOPEN = ('fopen', ())


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Lib2(unittest.TestCase):
    """FL-78 third review round (0x418e52): fopen as a source, fread / _makepath as destinations with a write model, register arithmetic between the pushes, a member function that only passes the pointer on, a string comparison, recursion in the liveness scan."""

    def jne_never(self, an):
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        return an.direction(jne, 'taken')[0]

    def test_a_source_only_function_without_destination_positions(self):
        an, lib = lib2('fopen_src', FOPEN)
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        self.assertEqual(self.jne_never(an), 'unsat')
        an, lib = lib2('fopen_src', None)                                                        # not listed: the old behaviour
        self.assertEqual(len(an.esc_addrs), 1)
        self.assertEqual(self.jne_never(an), 'sat')

    def test_a_destination_with_an_immediate_extent_is_a_bounded_write(self):
        an, lib = lib2('dest_short', FREAD)                                                      # 4 * 5 = 20 bytes at [ebp-0x1c, ebp-8): the cell [ebp-4] is not reached
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(0, 20)]])
        self.assertEqual(self.jne_never(an), 'unsat')
        an, lib = lib2('dest_long', FREAD)                                                       # 4 * 7 = 28 bytes reach the cell: the model must let the call change it
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(0, 28)]])
        self.assertEqual(self.jne_never(an), 'sat')
        an, lib = lib2('dest_short', None)
        self.assertEqual(len(an.esc_addrs), 1)

    def test_size_and_count_pushed_before_the_address_are_found(self):
        an, lib = lib2('dest_before', FREAD)
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(0, 20)]])

    def test_a_destination_without_a_known_extent_is_refused_or_havocs_the_frame(self):
        an, lib = lib2('dest_reg_count', FREAD)                                                  # the count is a register push: no extent
        self.assertEqual(len(an.esc_addrs), 1)
        an, lib = lib2('dest_any', ('_makepath', (0,), None))                                    # no extent model: any byte of the frame
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(0, None)]])
        self.assertEqual(self.jne_never(an), 'sat')
        an, lib = lib2('dest_any', ('sprintf', (0,)))                                            # a destination position of a function with no write model
        self.assertEqual(len(an.esc_addrs), 1)

    def test_a_frame_address_is_accepted_only_where_the_entry_says(self):
        an, lib = lib2('dest_stream', FREAD)                                                     # fread also writes through its stream argument
        self.assertEqual(len(an.esc_addrs), 1)
        an, lib = lib2('dest_stream', ('fread', (0,), ('mul', 1, 2)))                            # (an entry without the position list would take it)
        self.assertEqual(an.esc_addrs, [])

    def test_arithmetic_between_the_pushes_is_followed(self):
        from unittest import mock
        an, lib = lib2('regsetup_ok', ('sprintf', (0,)))
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(self.jne_never(an), 'unsat')
        real = P._reg_setup
        with mock.patch.object(P, '_reg_setup', lambda i: i.mnemonic == 'mov' and real(i)):    # only `mov` set-ups, as before
            an, lib = lib2('regsetup_ok', ('sprintf', (0,)))
        self.assertEqual(len(an.esc_addrs), 1)

    def test_a_set_up_from_the_frame_base_is_refused(self):
        for name in ('regsetup_ebp', 'regsetup_lea'):
            an, lib = lib2(name, ('sprintf', (0,)))
            first = [i.address for i in an.insns if i.mnemonic == 'lea'][0]
            self.assertIn(first, an.esc_addrs, name)

    def test_a_member_function_that_only_passes_the_pointer_to_a_listed_function(self):
        from unittest import mock
        for name in ('ro_ok', 'ro_member', 'ro_edx_ok'):
            an, lib = lib2(name, FOPEN)
            self.assertEqual(an.esc_addrs, [], name)
            self.assertEqual(self.jne_never(an), 'unsat', name)
            an, lib = lib2(name, None)                                                           # the callee passes it to an unlisted function
            self.assertEqual(len(an.esc_addrs), 1, name)
        with mock.patch.object(P, 'readonly_param', return_value=False):
            an, lib = lib2('ro_ok', FOPEN)
        self.assertEqual(len(an.esc_addrs), 1)

    def test_a_callee_that_does_more_than_pass_it_on_is_refused(self):
        for name in ('ro_store', 'ro_keep', 'ro_other', 'ro_twice', 'ro_edx_kept', 'ro_edx_read_after'):
            an, lib = lib2(name, FOPEN)
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_the_comparison_of_strings_reads_through_esi(self):
        an, lib = lib2('cmps_ok', None)
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        self.assertEqual(self.jne_never(an), 'unsat')
        from unittest import mock
        with mock.patch.object(P, 'library_arg_lea', return_value=False):
            an, lib = lib2('cmps_ok', None)
        self.assertFalse(an.M.split)
        self.assertEqual(self.jne_never(an), 'sat')
        for name in ('cmps_read_after', 'cmps_movs', 'cmps_first_read'):
            an, lib = lib2(name, None)
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_a_recursive_callee_is_followed(self):
        an, lib = lib2('rec_kills', ('sprintf', (0,)))                                           # rec calls itself and overwrites ecx on every path
        self.assertEqual(an.esc_addrs, [])
        for name in ('rec_reads', 'rec_keeps'):                                                  # it reads ecx / keeps the frame address in it
            an, lib = lib2(name, ('sprintf', (0,)))
            self.assertEqual(len(an.esc_addrs), 1, name)

    def test_the_result_of_a_listed_function_overwrites_eax(self):
        an, lib = lib2('ret_used', ('sprintf', (0,)), returns={BASE + 0x100})
        self.assertEqual(an.esc_addrs, [])
        an, lib = lib2('ret_used', ('sprintf', (0,)))                                            # not known to return a value: eax still holds the address
        self.assertEqual(len(an.esc_addrs), 1)

    def test_a_callee_that_writes_only_its_own_locals_leaves_memory_alone(self):                  # FL-78 (0x4ba56a): the CRT _ftol; a call of any other function havocs the memory
        from unittest import mock
        cal = {BASE + 0x140: 0}
        an, lib = lib2('pure_ok', None, callees=cal)
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        self.assertEqual(an.direction(jne, 'taken')[0], 'unsat')
        with mock.patch.object(P, 'pure_callee', return_value=False):
            an, lib = lib2('pure_ok', None, callees=cal)
        self.assertEqual(an.direction(jne, 'taken')[0], 'sat')

    def test_a_callee_that_may_write_elsewhere_is_not_pure(self):
        for name in ('pure_esp', 'pure_pos', 'pure_reg', 'pure_x87', 'pure_jmp', 'pure_call', 'pure_stos', 'pure_ebp', 'pure_seg', 'pure_idx'):
            body, hexcode = LIB2[name]
            img = lib78_image(bytes.fromhex(hexcode), b'hi\0')
            self.assertFalse(P.pure_callee(img, BASE + 0x140), name)
        body, hexcode = LIB2['pure_ok']
        self.assertTrue(P.pure_callee(lib78_image(bytes.fromhex(hexcode), b'hi\0'), BASE + 0x140))

    def test_the_committed_ftol_is_pure(self):
        self.assertTrue(P.pure_callee(P.load_image(), 0x50ce04))
        self.assertFalse(P.pure_callee(P.load_image(), 0x50ca3e))

    def test_the_committed_table(self):
        self.assertEqual(P.LIBRARY_WRITERS[0x50d0a9], ('fopen', ()))
        self.assertEqual(P.LIBRARY_WRITERS[0x50cf61], ('fread', (0,), ('mul', 1, 2), (0,)))
        self.assertEqual(P.LIBRARY_WRITERS[0x50cd72], ('_makepath', (0,), None))
        self.assertEqual(P.LIBRARY_RETURNS, {0x50ca3e, 0x50d0a9, 0x50cf61})



# FL-78 fourth review round: programs of the reviewer's reproductions (nasm, org 0x401000): name -> (length of the body, code, label offsets from BASE)
LIB4 = {
    'rec_read': (71, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000b901000000e8210000008b4508c70007000000837dfc007509b8010000005e5fc9c3b8090000005e5fc9c385c9740d49e8f6ffffffc7421801000000c3', {'never': 62, 'f': 71, 'base': 88}),
    'rec_kill': (78, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000b901000000e828000000c74218010000008b4508c70007000000837dfc007509b8010000005e5fc9c3b8090000005e5fc9c385c9740649e8f6ffffff31d2c3', {'never': 69, 'f': 78, 'base': 88}),
    'rec_keep': (71, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000b901000000e8210000008b4508c70007000000837dfc007509b8010000005e5fc9c3b8090000005e5fc9c385c9740649e8f6ffffffc3', {'never': 62, 'f': 71, 'base': 81}),
    'rec_keep_read': (78, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000b901000000e828000000c74218010000008b4508c70007000000837dfc007509b8010000005e5fc9c3b8090000005e5fc9c385c9740649e8f6ffffffc3', {'never': 69, 'f': 78, 'base': 88}),
    'ro_fread': (54, '5589e583ec20c745fc000000008d55ec52e82000000083c4048b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b4508506a016a016800304000e80700000083c41031c05dc3c3', {'never': 47, 'ro': 54, 'lib': 82}),
    'ro_plain': (54, '5589e583ec20c745fc000000008d55ec52e82000000083c4048b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450850e80700000083c40431c05dc3c3', {'never': 47, 'ro': 54, 'lib': 73}),
    'ro_pushebp': (54, '5589e583ec20c745fc000000008d55ec52e82000000083c4048b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450850e81000000083c40455e80700000083c40431c05dc3c3', {'never': 47, 'ro': 54, 'lib': 82}),
    'out_pushebp': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd580455e80500000083c4045dc38b4c24048b410cc7401001000000c3', {'never': 40, 'cal': 47, 'g': 74}),
    'out_plain': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58045dc3', {'never': 40, 'cal': 47}),
    'pure_shrink': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e583c43cb80100000050c9c3', {'never': 40, 'pc': 47}),
    'pure_grow': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e583c4c4b80100000050c745f801000000c9c3', {'never': 40, 'pc': 47}),
    'pure_pushebp': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e583c4c455c9c3', {'never': 40, 'pc': 47}),
    'pure_movesp': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e589c4c9c3', {'never': 40, 'pc': 47}),
    'pure_pushf': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e583c43c9cc9c3', {'never': 40, 'pc': 47}),
    'loop_reg_abs': (20, '5589e5b90000540083390074f6b8010000005dc390', {'hdr': 3}),
    'loop_index_abs': (25, '5589e5ba00000000833c95000054000074f6b8010000005dc390', {'hdr': 8}),
    'loop_abs': (19, '5589e5833d000054000074f7b8010000005dc390', {'hdr': 3}),
    'loop_ptr_shared': (19, '5589e58b4d088379040074fab8010000005dc390', {'hdr': 6}),
    'loop_frame': (26, '5589e583ec08c745fc00000000837dfc0074fab801000000c9c390', {'hdr': 13}),
    'pure_sp': (47, '5589e583ec60c745d0000000008d4df8894dc0e8170000008b4508837dd0007507b801000000c9c3b809000000c9c35589e56683c43cb80100000050c9c3', {'never': 40, 'pc': 47}),
    'out_bp': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58046683c540c745e4010000006683ed405dc3', {'never': 40, 'cal': 47}),
    'caller_sp': (41, '5589e583ec20c745fc000000006683c4046683ec04837dfc007507b801000000c9c3b809000000c9c390', {'never': 34}),
    'caller_esp': (39, '5589e583ec20c745fc0000000083c40483ec04837dfc007507b801000000c9c3b809000000c9c390', {'never': 32}),
    'fp_loop': (46, '5589e5f6450f807517d9eeb902000000dc5508dfe09e770fddd8dd45104975f0b8010000005dc3b8020000005dc390', {'hdr': 16, 'exit': 32, 'target': 39}),
    'fp_inside': (49, '5589e5b902000000dd4508dc5d10dfe09e741a8b45083345108b550c33551409d07507b8010000005dc34975db31c05dc390', {'hdr': 8, 'fine': 42, 'same': 45}),
    'rcr_one': (49, '5589e5b80300000083f805d1d8731b3d0100008075148b4508d1e8d1d0720431c05dc3b8020000005dc3b8010000005dc390', {'odd': 35, 'never': 42}),
    'rcr_two': (13, '5589e5b803000000c1d8025dc390', {}),
    'reg_inv': (47, '5589e5568b750885f674178b4d0cba0400000049740883ce0183c204ebf585f6740531c05e5dc3b8010000005e5dc390', {'hdr': 19, 'after': 30, 'out': 34, 'dead': 39}),
    'sahf_z': (24, '5589e531c0b4409e7407b8010000005dc3b8020000005dc390', {'l1': 17}),
    'sahf_c': (24, '5589e531c0b4019e7207b8010000005dc3b8020000005dc390', {'l1': 17}),
    'sahf_nz': (24, '5589e531c0b4809e7407b8010000005dc3b8020000005dc390', {'l1': 17}),
    'sahf_p': (24, '5589e531c0b4049e7a07b8010000005dc3b8020000005dc390', {'l1': 17}),
    'x87_eq': (48, '5589e5dd4508dc5d10dfe09e741e8b45083345108b550c33551409d07507b8010000005dc3b8020000005dc331c05dc390', {'fine': 37, 'same': 44}),
    'x87_chs': (52, '5589e5dd4508d9e0d9e0dc5d10dfe09e741e8b45083345108b550c33551409d07507b8010000005dc3b8020000005dc331c05dc390', {'fine': 41, 'same': 48}),
    'x87_wait': (49, '5589e5dd45089bdc5d10dfe09e741e8b45083345108b550c33551409d07507b8010000005dc3b8020000005dc331c05dc390', {'fine': 38, 'same': 45}),
    'out_popad': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd580461c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_popaw': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58046661c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_leavew': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd580466c9c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_enter': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd5804c8000000c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_xchg': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd580495c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_leaesp': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58048d20c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_bswap': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58040fcdc745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_pushfd': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58049cc745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_pushw': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58046650c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'out_wl': (47, '5589e583ec20c745fc000000008d55ec526a05e81700000083c408837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd58045159ff75088f45dc6a0383c40483ec0483c404c745e4010000005dc3', {'never': 40, 'cal': 47}),
    'caller_popad': (34, '5589e583ec20c745fc0000000061837dfc007507b801000000c9c3b809000000c9c390', {'never': 27}),
    'caller_wl': (47, '5589e583ec20c745fc000000005159ff75fc8f45f883c40483ec04837dfc007507b801000000c9c3b809000000c9c390', {'never': 40}),
    'sd_reread': (62, '5589e583ec208d45f08b4d088901837d100074248b4d0c8b41046a058b510483c40439c27509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 47, 'out': 56}),
    'sd_esp': (62, '5589e583ec208d04248b4d088901837d100074248b4d0c8b41046a058b510483c40439c27509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 47, 'out': 56}),
    'sd_below': (62, '5589e583ec208d45d08b4d088901837d100074248b4d0c8b41046a058b510483c40439c27509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 47, 'out': 56}),
    'sd_index': (63, '5589e583ec208d4415f08b4d088901837d100074248b4d0c8b41046a058b510483c40439c27509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 48, 'out': 57}),
    'sd_movesp': (61, '5589e583ec2089e08b4d088901837d100074248b4d0c8b41046a058b510483c40439c27509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 46, 'out': 55}),
    'sd_local': (66, '5589e583ec208d45f08945ec837d1000742ac745f0010000008b45ecc700020000008b55f083fa017509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 51, 'out': 60}),
    'pe_mid': (44, '5589e583ec10c745fc000000006a0555e81700000083c4045983f9057507b801000000c9c3b802000000c9c38b442404c740ec07000000c3', {'target': 37, 'f': 44}),
    'pe_ok': (43, '5589e583ec10c745fc070000006a05e81700000083c404837dfc077507b801000000c9c3b802000000c9c38b442404c3', {'target': 36, 'f': 43}),
    'sd_string': (63, '5589e583ec208d45f08b4d088901837d100074258d7df8c745f80100000031c0ab837df8017509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 48, 'out': 57}),
    'sd_bound': (70, '5589e583ec208d45e08b4d088901837d1000742c8b4d088b01c745e001000000c700020000008b55e083fa017509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc390', {'target': 55, 'out': 64}),
    'sd_call': (67, '5589e583ec208d45f08b4d088901837d10007429c745f0010000006a00e82100000083c404837df0017509b80100000089ec5dc3b80200000089ec5dc331c089ec5dc38b4424048908c3', {'target': 52, 'out': 61, 'g': 67}),
    'pe_loop': (59, '5589e583ec10837d0800751f6a05b801000000ff7500e82000000083c4045983f9057510b801000000c9c3c7450800000000ebccb802000000c9c38b442404c740d807000000c3', {'start': 0, 'again': 6, 'second': 43, 'bad': 52, 'f': 59}),
    'pe_loop_ok': (59, '5589e583ec10837d0800751f6a05b801000000ff7500e82000000083c4045983f9057510b801000000c9c3c7450800000000ebd2b802000000c9c38b442404c740d807000000c3', {'start': 0, 'again': 6, 'second': 43, 'bad': 52, 'f': 59}),
    'pc_ok': (55, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 48, 'f': 55, 'g': 56, 'cal': 65}),
    'pc_add': (58, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008345f001e8180000008b45f08a1080fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 51, 'f': 58, 'g': 59, 'cal': 68}),
    'pc_push': (61, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000ff75f0e81d00000083c4048b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 54, 'f': 61, 'g': 62, 'cal': 71}),
    'pc_copy': (57, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000e81b0000008b45f089c18a510180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 50, 'f': 57, 'g': 58, 'cal': 67}),
    'pc_stash': (68, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008b55088b45f089420452e81d00000083c4048b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b4424048b4004c6400107c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 61, 'f': 68, 'h': 69, 'g': 81, 'cal': 90}),
    'pc_call': (58, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008b45f0e8230000008b45f08a55fd80fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 51, 'f': 58, 'g': 59, 'cal': 68}),
    'pc_lea': (57, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000e81b0000008b45f08d70018a1680fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 50, 'f': 57, 'g': 58, 'cal': 67}),
    'pc_store': (74, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000e82c000000c745f0000000008b45088945f08d45fc8945f08b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 67, 'f': 74, 'g': 75, 'cal': 84}),
    'pc_byte': (59, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000c645f001e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 52, 'f': 59, 'g': 60, 'cal': 69}),
    'pc_sub': (59, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000836df001e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 52, 'f': 59, 'g': 60, 'cal': 69}),
    'pc_index': (62, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008b5d08894c9dd0e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 55, 'f': 62, 'g': 63, 'cal': 72}),
    'pc_second': (62, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008d55e052e81d00000083c4048b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 55, 'f': 62, 'g': 63, 'cal': 72}),
    'pc_esp': (58, '5589e583ec40c645fd008d45fc8945f08b4d08c701050000008b1424e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 51, 'f': 58, 'g': 59, 'cal': 68}),
    'pc_live': (59, '5589e583ec40c645fd008d45fc8945f08b4d08c7010500000050e81d00000083c4048b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'bad': 52, 'f': 59, 'g': 60, 'cal': 69}),
    'pc_later': (61, '5589e583ec40c645fd008d45fc8945f08b4d08c70105000000837d0c007405e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'later': 36, 'bad': 54, 'f': 61, 'g': 62, 'cal': 71}),
    'pc_cond': (61, '5589e583ec40c645fd00837d0c0074068d45fc8945f08b4d08c70105000000e8190000008b45f08a500180fa007507b801000000c9c3b802000000c9c3c38b442404c6400107c3c6400107c3', {'start': 0, 'skip': 22, 'bad': 54, 'f': 61, 'g': 62, 'cal': 71}),
    'pl_ok': (52, '5589e583ec40c645fd00c745ec000000008b4d08c60105ff45ec837dec057cf1807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 45, 'f': 52}),
    'pl_wr': (50, '5589e583ec40c645fd00c745ec00000000c645fd01ff45ec837dec057cf3807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 43, 'f': 50}),
    'pl_cellw': (65, '5589e583ec40c645fd00c745ec000000008d45fc8945f0807dfd00751d8b45f0c6400107ff45ec837dec057cea807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 23, 'bad': 58, 'f': 65}),
    'pl_idx': (53, '5589e583ec40c645fd00c745ec000000008b5d08894c9dd0ff45ec837dec057cf3807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 20, 'bad': 46, 'f': 53}),
    'pl_call': (51, '5589e583ec40c645fd00c745ec00000000e81d000000ff45ec837dec057cf2807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 44, 'f': 51}),
    'pl_first': (28, '5589e583ec40c645fd00e80d000000807dfd0075f5b801000000c9c3c3', {'start': 0, 'top': 10, 'f': 28}),
    'pl_first2': (40, '5589e583ec40c645fd00e819000000807dfd0075f5837d08007406c645fd01ebe9b801000000c9c3c3', {'start': 0, 'top': 10, 'out': 33, 'f': 40}),
    'pc_win': (55, '5589e583ec208d45f08945fc8b4dfc837d0800740142c745f005000000c70107000000837df0057407b802000000c9c3b801000000c9c390', {'start': 0, 'J': 22, 'ok': 48}),
    'ss_test': (62, '5589e583ec40c745e0414141418d55e0680010400052e82300000083c40885c074058a08803800817de0414141417507b801000000c9c3b802000000c9c38b442404c3', {'start': 0, 'none': 39, 'bad': 55, 'lib': 62}),
    'ss_store': (56, '5589e583ec40c745e0414141418d55e0680010400052e81d00000083c408c60042817de0414141417507b801000000c9c3b802000000c9c38b442404c3', {'start': 0, 'bad': 49, 'lib': 56}),
    'ss_rmw': (59, '5589e583ec40c745e0414141418d55e0680010400052e82000000083c40885c07402fe00817de0414141417507b801000000c9c3b802000000c9c38b442404c3', {'start': 0, 'none': 36, 'bad': 52, 'lib': 59}),
    'ss_copy': (58, '5589e583ec40c745e0414141418d55e0680010400052e81f00000083c40889c1c60142817de0414141417507b801000000c9c3b802000000c9c38b442404c3', {'start': 0, 'bad': 51, 'lib': 58}),
    'ss_push': (58, '5589e583ec40c745e0414141418d55e0680010400052e81f00000083c4085059c60142817de0414141417507b801000000c9c3b802000000c9c38b442404c3', {'start': 0, 'bad': 51, 'lib': 58}),
    'pl_ebp': (50, '5589e583ec40c645fd00c745ec0000000089eb89ddff45ec837dec057cf3807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 43, 'f': 50}),
    'pl_bts': (51, '5589e583ec40c645fd00c745ec000000000fba75f818ff45ec837dec057cf2807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 44, 'f': 51}),
    'pl_bt': (51, '5589e583ec40c645fd00c745ec000000000fba65f818ff45ec837dec057cf2807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 44, 'f': 51}),
    'pl_cx8': (50, '5589e583ec40c645fd00c745ec000000000fc74dd0ff45ec837dec057cf3807dfd007507b801000000c9c3b802000000c9c3c3', {'start': 0, 'top': 17, 'bad': 43, 'f': 50}),
}


def an4(name, writers=None, run=True):
    """analysis of a LIB4 program; `writers` maps a label ('lib') to its LIBRARY_WRITERS entry; every label that is a function (f, ro, lib, cal, g, pc) is a callee that pops nothing"""
    from unittest import mock
    body, hexcode, labels = LIB4[name]
    table = {BASE + labels[k]: v for k, v in (writers or {}).items()}
    callees = {BASE + v: 0 for k, v in labels.items() if k in ('f', 'ro', 'lib', 'cal', 'g', 'pc')}
    img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
    with mock.patch.dict(P.LIBRARY_WRITERS, table, clear=True):
        an = P.Analysis({'va': BASE, 'body': body, 'callees': callees, 'imports': {}, 'sites': None}, img, 20000)
        if run:
            an.run()
    return an, img, labels


def win4(name, jcc='jne', kind='taken', nth=0):
    """(window verdict, whole-function verdict, analysis) for the first `jcc` of a LIB4 program whose function labels (f, g, ...) are callees that pop nothing"""
    import fl71_window as Wn
    body, hexcode, labels = LIB4[name]
    img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
    callees = {BASE + v: 0 for k, v in labels.items() if k in ('f', 'ro', 'lib', 'cal', 'g', 'pc')}
    row = {'va': BASE, 'body': body, 'callees': callees, 'imports': {}, 'sites': None}
    whole = P.Analysis(row, img, 20000)
    whole.run()
    an, dom = Wn.from_analysis(P.Analysis(row, img, 20000))
    j = [i for i in an.insns if i.mnemonic == jcc][nth].address
    T = Wn.block_of(an, j, True)
    return Wn.prove_target(an, dom, T, ('dir', kind))[0], whole.direction(j, kind)[0], an


def win_only(name, jcc='jne', kind='taken', nth=0):
    """(window verdict, analysis) for the `nth` `jcc` of a LIB4 program (no whole-function run: some programs make it give up)"""
    import fl71_window as Wn
    body, hexcode, labels = LIB4[name]
    img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
    callees = {BASE + v: 0 for k, v in labels.items() if k in ('f', 'ro', 'lib', 'cal', 'g', 'pc', 'h')}
    an, dom = Wn.from_analysis(P.Analysis({'va': BASE, 'body': body, 'callees': callees, 'imports': {}, 'sites': None}, img, 20000))
    j = [i for i in an.insns if i.mnemonic == jcc][nth].address
    return Wn.prove_target(an, dom, Wn.block_of(an, j, True), ('dir', kind))[0], an


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Review4(unittest.TestCase):
    """FL-78 fourth review round: a recursive callee that keeps what it is passed, fread's stream argument in a read-only callee, a push of the frame base in a callee, a pure callee that moves esp up, bsf / bsr, the closed-loop lint, the cache key."""

    def test_a_recursive_callee_that_reads_what_it_keeps_is_followed_to_a_fixed_point(self):         # MAJOR 1
        from unittest import mock
        an, img, L = an4('rec_read', run=False)
        self.assertEqual(len(an.esc_addrs), 1)                           # the write through edx after the recursive call reads the address the callee kept
        an, img, L = an4('rec_keep_read', run=False)
        self.assertEqual(len(an.esc_addrs), 1)
        for name in ('rec_kill', 'rec_keep'):                            # the callee overwrites edx on every path / nothing reads edx behind it
            an, img, L = an4(name, run=False)
            self.assertEqual(an.esc_addrs, [], name)

        class Empty(dict):                                               # the earlier rule: a recursive call keeps nothing
            def __setitem__(self, k, v):
                pass

            def __getitem__(self, k):
                return frozenset()
        with mock.patch.object(P, '_ASSUME', Empty()):
            an, img, L = an4('rec_read', run=False)
        self.assertEqual(an.esc_addrs, [])                               # accepted with the earlier rule: the test depends on the change

    def test_the_call_effect_of_a_recursive_callee(self):
        an, img, L = an4('rec_read', run=False)
        call = [i for i in an.insns if i.mnemonic == 'call'][0]
        reads, keeps = P.call_effect(img, call, 'edx', 0, set(), {})
        self.assertTrue(reads)
        an, img, L = an4('rec_keep', run=False)
        call = [i for i in an.insns if i.mnemonic == 'call'][0]
        self.assertEqual(P.call_effect(img, call, 'edx', 0, set(), {}), (False, frozenset('lhu')))
        an, img, L = an4('rec_kill', run=False)
        call = [i for i in an.insns if i.mnemonic == 'call'][0]
        self.assertEqual(P.call_effect(img, call, 'edx', 0, set(), {}), (False, frozenset()))

    def test_a_read_only_callee_may_pass_the_pointer_only_where_the_entry_allows(self):               # MAJOR 2
        fread = ('fread', (0,), ('mul', 1, 2), (0,))
        an, img, L = an4('ro_fread', {'lib': fread}, run=False)           # pushed as fread's stream (position 3)
        self.assertEqual(len(an.esc_addrs), 1)
        an, img, L = an4('ro_fread', {'lib': ('fopen', ())}, run=False)  # the same bytes with a function that has no destination and no position list
        self.assertEqual(an.esc_addrs, [])
        an, img, L = an4('ro_plain', {'lib': ('fopen', ())}, run=False)
        self.assertEqual(an.esc_addrs, [])
        self.assertFalse(P.readonly_param(img, BASE + L['ro'], 8, {BASE + L['lib']: fread}, set()))
        self.assertTrue(P.readonly_param(img, BASE + L['ro'], 8, {BASE + L['lib']: ('fopen', ())}, set()))              # (the same callee is accepted when the function has no position list)

    def test_a_callee_that_pushes_its_frame_base_is_refused(self):                                       # MAJOR 3
        from unittest import mock
        an, img, L = an4('out_pushebp', run=False)
        self.assertEqual(len(an.esc_addrs), 1)
        an, img, L = an4('out_plain', run=False)
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(4, 12)]])
        with mock.patch.object(P, 'callee_leaks', return_value=False), mock.patch.object(P, 'frame_escapes', return_value=False):          # (the round 8 review whitelist refuses the pushed ebp as well)
            an, img, L = an4('out_pushebp', run=False)
        self.assertEqual(an.esc_addrs, [])                               # accepted without the check
        an, img, L = an4('ro_pushebp', {'lib': ('fopen', ())}, run=False)
        self.assertEqual(len(an.esc_addrs), 1)
        an, img, L = an4('ro_plain', {'lib': ('fopen', ())}, run=False)
        self.assertEqual(an.esc_addrs, [])
        with mock.patch.object(P, 'callee_leaks', return_value=False), mock.patch.object(P, 'frame_escapes', return_value=False):
            an, img, L = an4('ro_pushebp', {'lib': ('fopen', ())}, run=False)
        self.assertEqual(an.esc_addrs, [])

    def test_pure_callee_follows_the_stack_depth(self):                                                  # MAJOR 3 and 4
        for name, want in (('pure_grow', True), ('pure_shrink', False), ('pure_pushebp', False), ('pure_movesp', False), ('pure_pushf', False)):
            an, img, L = an4(name, run=False)
            self.assertEqual(P.pure_callee(img, BASE + L['pc']), want, name)

    def test_a_pure_callee_that_moves_esp_up_and_pushes_is_not_pure(self):
        with mock.patch.object(P, 'pointer_cell', return_value=None):          # (the stored `lea` is a pointer cell with no load since round 9: the frame assumption would then keep [ebp-0x30] across the call whether or not the callee is pure)
            an, img, L = an4('pure_shrink')
            jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
            self.assertEqual(an.direction(jne, 'taken')[0], 'sat')

    def test_bsf_and_bsr_read_their_destination(self):                                                  # MINOR c
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        for raw in (b'\x0f\xbc\xc1', b'\x0f\xbd\xc1'):                                              # bsf eax, ecx / bsr eax, ecx
            i = next(md.disasm(raw, BASE))
            rd, wr = P._rw_raw(i)
            self.assertIn('eax', rd)
            self.assertIn('eax', wr)
        i = next(md.disasm(b'\x89\xc8', BASE))                                                         # mov eax, ecx
        self.assertNotIn('eax', P._rw_raw(i)[0])

    def test_the_call_effect_cache_is_keyed_on_the_import_set(self):                                    # MINOR d
        import capstone
        code = bytes.fromhex('e80b000000') + bytes(11) + bytes.fromhex('ff1500014000c3')               # call f; f: call [0x400100]; ret
        img = bytes(image_of(code)) + bytes(64)
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        call = next(md.disasm(code[:5], BASE))
        self.assertEqual(P.call_effect(img, call, 'ecx', 0, {0x400100}, {}), (False, frozenset()))      # an import: ecx is clobbered
        self.assertEqual(P.call_effect(img, call, 'ecx', 0, {0x400200}, {}), (True, frozenset('lhu')))  # another slot of the same size: an unknown indirect call

    def test_the_closed_loop_absolute_address_check_is_only_a_lint(self):                                # MINOR a
        import fl71_window as Wn
        want = {'loop_reg_abs': 'unsat', 'loop_index_abs': 'unsat', 'loop_ptr_shared': 'unsat', 'loop_frame': 'unsat', 'loop_abs': 'unsupported'}
        for name, verdict in want.items():
            body, hexcode, L = LIB4[name]
            img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
            an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000)
            an, dom = Wn.from_analysis(an)
            j = [i for i in an.insns if i.mnemonic == 'je'][0].address
            self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', j, 'taken'))[0], verdict, name)

    def test_a_write_to_a_part_of_esp_or_ebp_is_a_use_of_the_frame_base(self):                         # round 5
        from unittest import mock
        an, img, L = an4('pure_sp', run=False)                           # add sp, 0x3c moves the stack pointer up inside a "pure" callee
        self.assertFalse(P.pure_callee(img, BASE + L['pc']))
        an, img, L = an4('out_bp', run=False)                            # add bp, 0x40 ... sub bp, 0x40 inside an out-parameter callee
        self.assertEqual(len(an.esc_addrs), 1)
        an, img, L = an4('out_plain', run=False)
        self.assertEqual(an.esc_addrs, [])
        an, img, L = an4('caller_sp', run=False)                         # the function itself writes sp: a frame escape
        self.assertEqual(len(an.esc_addrs), 2)
        self.assertFalse(an.M.split)
        an, img, L = an4('caller_esp', run=False)
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        with mock.patch.object(P, 'frame_ok', return_value=True):
            an, img, L = an4('pure_sp', run=False)
            self.assertTrue(P.pure_callee(img, BASE + L['pc']))          # accepted without the check
            an, img, L = an4('out_bp', run=False)
            self.assertEqual(an.esc_addrs, [])
            an, img, L = an4('caller_sp', run=False)
            self.assertEqual(an.esc_addrs, [])

    def test_an_implicit_write_to_esp_or_ebp_is_refused(self):                                          # round 6: a whitelist on what may touch the frame base
        from unittest import mock

        def jne_taken(an):
            j = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
            return an.direction(j, 'taken')[0]
        for name in ('out_popad', 'out_popaw', 'out_leavew', 'out_enter', 'out_xchg', 'out_leaesp', 'out_bswap', 'out_pushfd', 'out_pushw'):
            an, img, L = an4(name, run=False)                                     # the out-parameter callee changes the frame base without naming esp or ebp: not an out-parameter callee
            self.assertEqual(len(an.esc_addrs), 1, name)
            self.assertFalse(an.M.split, name)
        for name in ('out_popad', 'out_popaw'):
            an, img, L = an4(name)
            self.assertEqual(jne_taken(an), 'sat', name)                          # the store below the frame can reach [ebp-4]: the direction is feasible
        an, img, L = an4('out_wl')                                                # still accepted: push / pop of registers, immediates and memory, add / sub esp, immediate
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(list(an.M.out_writes.values()), [[(4, 12)]])
        self.assertEqual(jne_taken(an), 'unsat')
        an, img, L = an4('caller_popad', run=False)                               # the function itself pops all registers: a frame escape
        self.assertEqual(len(an.esc_addrs), 1)
        self.assertFalse(an.M.split)
        an, img, L = an4('caller_wl', run=False)
        self.assertEqual(an.esc_addrs, [])
        self.assertTrue(an.M.split)
        with mock.patch.object(P, 'frame_ok', return_value=True):                 # without the whitelist the reviewer's repro is accepted and proves the jne unsat
            for name in ('out_popad', 'out_popaw', 'out_leavew', 'out_bswap', 'out_pushfd', 'caller_popad'):
                an, img, L = an4(name, run=False)
                self.assertEqual(an.esc_addrs, [], name)
            an, img, L = an4('out_popad')
            self.assertEqual(jne_taken(an), 'unsat')

    def test_the_condition_of_an_if_does_not_make_a_pointer_a_frame_address(self):                    # round 7
        from unittest import mock
        import z3
        esp, x = z3.BitVec('s_esp', 32), z3.BitVec('s_x', 32)
        cond = z3.ULE(esp + 8, 100)                                         # the path condition of a merged state mentions s_esp
        self.assertFalse(P.has_frame_term(z3.If(cond, x, x + 12)))          # a merged pointer whose branches are not frame addresses: not a frame address
        self.assertTrue(P.has_frame_term(z3.If(cond, esp + 8, x)))          # a branch that is a frame address still makes it one
        self.assertTrue(P.has_frame_term(z3.If(z3.ULE(x, 5), x, esp - 4)))
        self.assertTrue(P.has_frame_term(esp + 8))

        def old(e):                                                         # the rule before round 7: every child, the condition too
            todo, seen, found = [e], set(), False
            while todo and not found:
                y = todo.pop()
                if y.get_id() in seen:
                    continue
                seen.add(y.get_id())
                if z3.is_const(y) and y.decl().kind() == z3.Z3_OP_UNINTERPRETED:
                    found = y.decl().name() in ('s_esp', 's_ebp')
                elif y.decl().kind() not in (z3.Z3_OP_SELECT, z3.Z3_OP_STORE):
                    todo.extend(y.children())
            return found
        self.assertTrue(old(z3.If(cond, x, x + 12)))
        targets = {'missing': [], 'untaken': [['0x5148c6', 'fall-through']]}            # a search loop over 12 byte records: its exits are merged, and the merged pointer was read from the frame memory
        self.assertEqual(P.prove_row('0x514893', targets, timeout_ms=20000)['status'], 'proved')
        targets = {'missing': [], 'untaken': [['0x518bce', 'fall-through']]}
        self.assertEqual(P.prove_row('0x518b98', targets, timeout_ms=20000)['status'], 'proved')
        with mock.patch.object(P, 'has_frame_term', old):
            self.assertNotEqual(P.prove_row('0x514893', {'missing': [], 'untaken': [['0x5148c6', 'fall-through']]}, timeout_ms=20000)['status'], 'proved')

    def test_sahf_loads_the_flags_from_ah(self):                                                        # round 7
        for name, jcc, taken in (('sahf_z', 'je', 'unsat'), ('sahf_c', 'jb', 'unsat'), ('sahf_nz', 'je', 'sat'), ('sahf_p', 'jp', 'unsat')):
            an, img, L = an4(name)
            j = [i for i in an.insns if i.mnemonic == jcc][0].address
            fall = an.direction(j, 'fall')[0]                                    # ah = 0x40 sets ZF, 0x01 CF, 0x04 PF: the jump is always taken; ah = 0x80 leaves ZF clear: the jump is never taken
            self.assertEqual(fall, 'unsat' if taken == 'unsat' else 'sat', name)
            self.assertEqual(an.direction(j, 'taken')[0], 'sat' if taken == 'unsat' else 'unsat', name)

    def test_an_x87_compare_of_two_known_values_is_exact(self):                                       # round 7
        def verdicts(name):
            an, img, L = an4(name)
            jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
            je = [i for i in an.insns if i.mnemonic == 'je'][0].address
            return an.direction(jne, 'fall')[0], an.direction(jne, 'taken')[0], an.direction(je, 'taken')[0], an
        fall, taken, same, an = verdicts('x87_eq')                               # fld / fcomp / fnstsw / sahf: x != y (ordered) cannot have the same 64 bits
        self.assertEqual((fall, taken, same), ('unsat', 'sat', 'sat'))            # the equal and unordered runs and the runs with different bits are still feasible
        self.assertIn('x87-compare-model', an.assumptions())
        for name in ('x87_chs', 'x87_wait'):                                     # any other x87 instruction between forgets what is known: the same query is feasible again
            self.assertEqual(verdicts(name)[0], 'sat', name)
        from unittest import mock
        with mock.patch.object(P.Machine, 'x87_compare', return_value=False):    # without the model fnstsw ax is unconstrained
            self.assertEqual(verdicts('x87_eq')[0], 'sat')
        out = P.prove_row('0x5145fe', {'missing': [], 'untaken': [['0x514634', 'taken']]}, timeout_ms=20000)       # x == +0 or -0 was compared with 0.0 a few instructions before
        self.assertEqual(out['status'], 'proved')
        self.assertIn('x87-compare-model', out['assumptions_used'])

    def test_a_register_atom_is_a_checked_loop_invariant(self):                                         # round 7
        from unittest import mock
        body, hexcode, labels = LIB4['reg_inv']
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        row = {'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}

        def dead(invariants):
            with mock.patch.object(P, 'load_invariants', return_value=invariants):
                an = P.Analysis(row, img, 20000)
                an.run()
                j = [i for i in an.insns if i.mnemonic == 'je'][2].address                  # the `je dead` after the loop
                return an.direction(j, 'taken')[0]
        hdr = BASE + labels['hdr']
        self.assertEqual(dead({}), 'sat')                                                            # the loop havocs esi: nothing is known after it
        self.assertEqual(dead({hdr: [{'reg': 'esi', 'op': 'ne', 'val': 0}]}), 'unsat')              # esi != 0 on entry (the `je out` before) and kept by `or esi, 1`
        with self.assertRaises(P.Unsupported):                                                       # a register fact that is false on the entry edge is refused, not trusted
            dead({hdr: [{'reg': 'esi', 'op': 'eq', 'val': 1}]})
        with self.assertRaises(P.Unsupported):                                                       # one that the entry edge gives (edx = 4) but the loop body breaks (edx + 4 may wrap to 0)
            dead({hdr: [{'reg': 'edx', 'op': 'ne', 'val': 0}]})
        out = P.prove_row('0x50ebca', {'missing': ['0x50ec6d', '0x50ec6f', '0x50ecbf', '0x50ecc1'], 'untaken': [['0x50ec67', 'fall-through'], ['0x50ec6b', 'fall-through'], ['0x50ecbd', 'fall-through']]}, timeout_ms=40000)
        self.assertEqual(out['status'], 'proved')
        for name in ('register-loop-invariant-checked', 'callee-saved-registers-unread-and-kept-by-callees', 'import-reads-no-register-and-clobbers-eax-ecx-edx'):         # esi survives the calls and imports of the loop
            self.assertIn(name, out['assumptions_used'])
        with mock.patch.object(P, 'load_invariants', return_value={}):
            out = P.prove_row('0x50ebca', {'missing': ['0x50ec6d', '0x50ec6f', '0x50ecbf', '0x50ecc1'], 'untaken': [['0x50ec67', 'fall-through'], ['0x50ec6b', 'fall-through'], ['0x50ecbd', 'fall-through']]}, timeout_ms=40000)
            self.assertNotEqual(out['status'], 'proved')

    def test_rcr_and_rcl_by_one_rotate_through_the_carry(self):                                          # round 7
        an, img, L = an4('rcr_one')
        jnb = [i for i in an.insns if i.mnemonic == 'jae'][0].address
        jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
        jb = [i for i in an.insns if i.mnemonic == 'jb'][0].address
        self.assertEqual(an.direction(jnb, 'taken')[0], 'unsat')               # cmp 3, 5 sets cf; rcr 3 -> 0x80000001 with cf = 1 (the bit that left)
        self.assertEqual(an.direction(jne, 'taken')[0], 'unsat')
        self.assertEqual(an.direction(jb, 'taken')[0], 'unsat')                # shr x leaves bit 31 clear and rcl shifts it out: cf = 0
        self.assertEqual(an.direction(jb, 'fall')[0], 'sat')
        with self.assertRaises(P.Unsupported):                                  # only the count 1 is modelled
            an4('rcr_two')

    def test_the_aulldiv_carry_needs_the_exact_shift_loop(self):                                         # round 7
        from unittest import mock
        targets = {'missing': [], 'untaken': [['0x50eba5', 'taken']]}
        self.assertEqual(P.HINT_ONLY, 33)
        self.assertNotIn(33, P.UNROLL)                                           # the search never tries it
        out = P.prove_row('0x50eb20', targets, timeout_ms=120000)                # the 64 bit shift loop runs at most 32 times: unrolled exactly, the estimate times the divisor stays below 2^64
        self.assertEqual(out['status'], 'proved')
        self.assertEqual(out['plan'], {'0x50eb87': 33})
        with mock.patch.object(P, 'load_plan_hints', return_value={}):           # without the hint the loop is generalised and the carry is feasible
            self.assertNotEqual(P.prove_row('0x50eb20', targets, timeout_ms=20000)['status'], 'proved')

    def test_a_window_forgets_the_x87_state_at_a_generalised_loop_header(self):                         # round 7 review
        import fl71_window as Wn

        def window(name, jcc, kind):
            body, hexcode, labels = LIB4[name]
            img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
            an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000)
            an, dom = Wn.from_analysis(an)
            j = [i for i in an.insns if i.mnemonic == jcc][0].address
            T = Wn.block_of(an, j, True)
            whole = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000)
            whole.run()
            return Wn.prove_target(an, dom, T, ('dir', kind))[0], whole.direction(j, kind)[0]
        # fldz before the loop; each round compares st(0) with [ebp+8], then replaces st(0) by [ebp+0x10]: after the first round st(0) is not the fldz value
        win, whole = window('fp_loop', 'ja', 'taken')
        self.assertEqual((win, whole), ('sat', 'sat'))                           # (before the fix the window said unsat, the whole function sat)
        # the compare is entirely inside one round: still exact in the window and in the whole function
        win, whole = window('fp_inside', 'jne', 'fall')
        self.assertEqual((win, whole), ('unsat', 'unsat'))

    def test_the_stack_discipline_assumption_keeps_only_call_temporaries_apart(self):                  # round 8
        import fl71_window as Wn
        from unittest import mock

        def window(name, jcc, kind):
            body, hexcode, labels = LIB4[name]
            img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
            an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000)
            an, dom = Wn.from_analysis(an)
            j = [i for i in an.insns if i.mnemonic == jcc][0].address
            T = Wn.block_of(an, j, True)
            return Wn.prove_target(an, dom, T, ('dir', kind))[0], an
        # a pointer to a local goes to the caller's object, so no frame assumption; then a value is read through another pointer, a temporary is pushed, the value is read again: the pushed slot is not where
        # any pointer formed from a local points, so the two reads agree (pushes in a window are not stores to what a mem pointer reads)
        verdict, an = window('sd_reread', 'jne', 'taken')
        self.assertEqual(verdict, 'unsat')
        self.assertTrue(an.stack_discipline_used)
        self.assertEqual(an.temps_info(), 0x20)
        # without the assumption (the function does not qualify) a pointer in the second argument may point at the slot that is pushed
        with mock.patch.object(P.Analysis, 'temps_info', return_value=None):
            self.assertNotEqual(window('sd_reread', 'jne', 'taken')[0], 'unsat')
        # refused: an address of a call temporary (esp based), of a slot below the locals, an indexed one, a copy of esp: each can reach a pushed slot
        for name in ('sd_esp', 'sd_below', 'sd_index', 'sd_movesp'):
            verdict, an = window(name, 'jne', 'taken')
            self.assertIsNone(an.temps_info(), name)
            self.assertNotEqual(verdict, 'unsat', name)
        # the locals themselves are ordinary memory: a store through the pointer to a local changes what a read of the local gives
        verdict, an = window('sd_local', 'jne', 'taken')
        self.assertEqual(an.temps_info(), 0x20)
        self.assertEqual(verdict, 'sat')

    def test_a_push_of_the_frame_base_after_the_prologue_refuses_the_frame_assumption(self):          # round 8 review, MAJOR
        # `push ebp` in the body hands the frame base to a callee, which writes [arg - 0x14] = [ebp - 0x14]: the local is not out of reach
        win, whole, an = win4('pe_mid')
        self.assertNotEqual(whole, 'unsat')
        self.assertNotEqual(win, 'unsat')
        self.assertFalse(an.M.split)
        self.assertIsNone(an.temps_info())
        # the prologue's own `push ebp` (the first instruction) is still accepted: the local survives the call
        win, whole, an = win4('pe_ok')
        self.assertEqual((win, whole), ('unsat', 'unsat'))
        self.assertTrue(an.M.split)
        # (the whitelist itself)
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        push = next(md.disasm(b'\x55', BASE))
        self.assertTrue(P.frame_ok(push, True))
        self.assertFalse(P.frame_ok(push))
        nop = next(md.disasm(b'\x90', BASE - 1))
        self.assertTrue(P.frame_escapes([push], nop))                                                  # not the first instruction of the function
        self.assertFalse(P.frame_escapes([push], push))

    def test_a_jump_back_to_the_entry_runs_the_prologue_push_again(self):                           # round 8 review, latent major
        # `second: ... jmp start` pushes the frame base a second time, and the callee writes through it: the second `jne` (the pushed value changed) is feasible
        win, whole, an = win4('pe_loop', nth=1)
        self.assertNotEqual(whole, 'unsat')
        self.assertNotEqual(win, 'unsat')
        self.assertFalse(an.split_ok)
        self.assertIsNone(an.temps_info())
        # the same function that jumps back to after the prologue pushes it once: the local survives, still proved
        win, whole, an = win4('pe_loop_ok', nth=1)
        self.assertEqual((win, whole), ('unsat', 'unsat'))
        self.assertTrue(an.split_ok)
        # a callee whose body jumps back to its entry is not accepted by callee_leaks either
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        loop = list(md.disasm(bytes.fromhex('5589e5ebfb'), BASE))                                     # push ebp; mov ebp, esp; jmp BASE
        self.assertEqual([i.mnemonic for i in loop], ['push', 'mov', 'jmp'])
        self.assertTrue(P.callee_leaks(loop))
        self.assertFalse(P.callee_leaks(loop[:2]))

    def test_the_stack_discipline_boundaries(self):                                                   # round 8 review, minors 1 to 3
        from unittest import mock
        # a string instruction on a frame address is not modelled (the store would land in the temporaries' array, the read of the local in ordinary memory)
        win, whole, an = win4('sd_string')
        self.assertEqual(an.temps_info(), 0x20)
        self.assertNotEqual(win, 'unsat')
        # the lowest local ebp - L is ordinary memory: a store through the escaped pointer to it is seen by a read of it
        win, whole, an = win4('sd_bound')
        self.assertEqual(an.temps_info(), 0x20)
        self.assertEqual(win, 'sat')
        # a call may change the locals (an escaped pointer): nothing is known of a local across it
        win, whole, an = win4('sd_call')
        self.assertEqual(an.temps_info(), 0x20)
        self.assertEqual(win, 'sat')
        # a window that starts with esp inside the locals is not used
        import fl71_window as Wn
        self.assertIsNone(Wn.temps_of(an, min(an.blocks)))
        with mock.patch.object(Wn, 'stack_delta', return_value={0x401000: -0x10}), mock.patch.object(P.Analysis, 'temps_info', return_value=0x20):
            self.assertIsNone(Wn.temps_of(an, 0x401000))
        with mock.patch.object(Wn, 'stack_delta', return_value={0x401000: -0x20}), mock.patch.object(P.Analysis, 'temps_info', return_value=0x20):
            self.assertEqual(Wn.temps_of(an, 0x401000), (0x20, -0x20))
        # an access that straddles ebp - L, and the address of a call temporary stored or pushed, are not modelled
        M = an.M
        s_ebp = z3.BitVec('s_ebp', 32)
        M.temps = (0x20, -0x20)
        M.split = True
        try:
            self.assertTrue(M.is_temp(s_ebp - 0x24, 4))
            self.assertFalse(M.is_temp(s_ebp - 0x20, 4))
            with self.assertRaises(P.Unsupported):
                M.is_temp(s_ebp - 0x22, 4)
            with self.assertRaises(P.Unsupported):
                M.temp_value(s_ebp - 0x30)
            M.temp_value(s_ebp - 0x10)                                                                   # a pointer to a local may be stored
        finally:
            M.temps, M.split = None, False

    def test_the_proof_record_names_the_assumptions(self):                                              # MINOR e
        img = P.load_image()
        got = P.Analysis(P.row_of('0x418e52'), img, 1000).assumptions()
        for name in ('frame-assumption', 'library-source:fopen', 'library-destination:fread', 'library-destination:_makepath', 'ro-rule', 'cmps-rule', 'recursive-call-least-fixed-point'):
            self.assertIn(name, got)
        out = P.prove_row('0x425b8b', {'missing': [], 'untaken': [['0x425cf0', 'taken']]})
        self.assertEqual(out['status'], 'proved')
        self.assertIn('closed-loop-wait-semantics', out['assumptions_used'])
        self.assertEqual(sorted(out['plan']), ['closed-loop:0x425cf0:taken'])
        got = P.Analysis(P.row_of('0x4f7207'), img, 1000).assumptions()
        for name in ('copy-rule', 'frame-assumption', 'library-source:sprintf', 'out-rule', 'listed-library-function-reads-no-register', 'callee-saved-registers-unread-and-kept-by-callees', 'import-reads-no-register-and-clobbers-eax-ecx-edx'):
            self.assertIn(name, got)
        for name in ('listed-library-function-reads-no-register', 'callee-saved-registers-unread-and-kept-by-callees', 'import-reads-no-register-and-clobbers-eax-ecx-edx'):         # the ABI assumptions are named for 0x418e52 too
            self.assertIn(name, P.Analysis(P.row_of('0x418e52'), img, 1000).assumptions())
        from unittest import mock
        body, hexcode, L = LIB4['pure_grow']
        pimg = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, pimg, 20000)       # the pure callee is not in row['callees']
        self.assertIn('pure-callee:0x%x' % (BASE + L['pc']), an.assumptions())
        with mock.patch.object(P, 'pure_callee', return_value=False):
            an = P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, pimg, 20000)
            self.assertNotIn('pure-callee:0x%x' % (BASE + L['pc']), an.assumptions())

    def test_four_callees_of_the_image_are_pure(self):
        img = P.load_image()
        self.assertEqual([a for a in (0x50ce04, 0x514569, 0x51457b, 0x515a7f) if P.pure_callee(img, a)], [0x50ce04, 0x514569, 0x51457b, 0x515a7f])

# FL-78 programs for the two other cases of library_arg_lea (nasm, org 0x401000). Common tail: mov eax,[ebp+8]; mov [eax],7; cmp [ebp-CELL],0; jne never; ... (a store through the argument pointer between the setup and the compare).
#   copy_*: push ebp; mov ebp,esp; sub esp,0x20; push edi; push esi; lea edx,[ebp-0x1c]; mov esi,[ebp+0xc]; mov ecx,[ebp+0x10]; mov edi,edx; rep movsb  (an inline copy into a local buffer); epilogue pop esi; pop edi; leave; ret
#   out_*:  the call is `lea edx,[ebp-0x14]; push edx; push 5; call cal`, cal sits behind the body and pops 8
P78 = {
    'copy_ok': (59, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc000000008b4508c70007000000837dfc007507b801000000eb05b8090000005e5fc9c3'),    # lea edx,[ebp-0x1c]; mov edi,edx; rep movsb; then [ebp-4] = 0 (set after the copy)
    'copy_cell_lost': (59, '5589e583ec205756c745fc000000008d55e48b750c8b4d1089d7f3a48b4508c70007000000837dfc007507b801000000eb05b8090000005e5fc9c3'),    # [ebp-4] = 0 is set BEFORE the copy: the copy may write any byte of the frame
    'copy_edx_used': (65, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000c702050000008b4508c70007000000837dfc007507b801000000eb05b8090000005e5fc9c3'),    # mov [edx],5 after the copy: the frame address is used again
    'copy_edi_used': (65, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000c707050000008b4508c70007000000837dfc007507b801000000eb05b8090000005e5fc9c3'),    # mov [edi],5 after the copy
    'copy_no_restore': (58, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc000000008b4508c70007000000837dfc007507b801000000eb05b8090000005ec9c3'),    # no pop edi: edi (a frame address after the copy) goes back to the caller
    'out_ok': (53, '5589e583ec20c745fc000000008d55ec526a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eed958085dc20800'),    # lea edx,[ebp-0x14]; push edx; push 5; call cal (stdcall, ret 8; cal: mov eax,[ebp+0xc]; fld [ebp+8]; fstp [eax]; fldz; fstp [eax+8]): 12 bytes at ebp-0x14..ebp-9; [ebp-4] = 0 before
    'out_cell_inside': (53, '5589e583ec20c745f0000000008d55ec526a05e81d0000008b4508c70007000000837df0007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eed958085dc20800'),    # [ebp-0x10] = 0 before the call, compared after: inside the 12 bytes
    'out_cell_above': (53, '5589e583ec20c745f8000000008d55ec526a05e81d0000008b4508c70007000000837df8007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eed958085dc20800'),    # [ebp-8] = 0 before the call, compared after: the first byte behind the 12 bytes
    'out_ptr_stored': (53, '5589e583ec20c745fc000000008d55ec526a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450ca3003140005dc20800'),    # cal stores the pointer to a global
    'out_ptr_pushed': (53, '5589e583ec20c745fc000000008d55ec526a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450c50585dc20800'),    # cal pushes the pointer
    'out_ptr_loaded_twice': (53, '5589e583ec20c745fc000000008d55ec526a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450c8b4d0cd91883c1045dc20800'),    # cal loads the slot twice and adds to the second copy
    'out_eax_used_after': (55, '5589e583ec20c745fc000000008d55ec526a05e81f00000089c68b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eed958085dc20800'),    # mov esi,eax after the call
    'out_wrong_slot': (55, '5589e583ec20c745fc000000008d55ec526a056a06e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eed958085dc20800'),    # the pointer is pushed first of three: the callee writes through the second argument
    'out_reg_used': (53, '5589e583ec20c745fc000000008d4dec516a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450cd94508d918d9eedd5804c74110010000005dc20800'),    # FL-78 review: lea ecx; the callee stores through ecx (mov dword [ecx+0x10],1) as well: the register still holds the frame address at the call
    'copy_call_reads_edx': (66, '5589e583ec2057568d55e48b750c8b4d1089d7f3a4c745fc00000000e8210000008b4508c70007000000837dfc007509b8010000005e5fc9c3b8090000005e5fc9c3c7421801000000c3'),    # FL-78 review: after the copy a call whose callee stores through edx (mov dword [edx+0x18],1)
    'out_dest_form': (53, '5589e583ec20c745fc000000008d55ec526a05e81d0000008b4508c70007000000837dfc007507b801000000c9c3b809000000c9c35589e58b450cc70001000000d945085dc20800'),    # cal stores an integer through the pointer
}


def prog78(name):
    """analysis of a P78 program; the callee `cal` (behind the body of the out_* programs) pops 8"""
    body, hexcode = P78[name]
    code = bytes.fromhex(hexcode)
    callees = {BASE + body: 8} if name.startswith('out_') else {BASE + body: 0} if name == 'copy_call_reads_edx' else {}
    return P.Analysis({'va': BASE, 'body': body, 'callees': callees, 'imports': {}, 'sites': None}, image_of(code), 20000)


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Copy(unittest.TestCase):
    """FL-78 (decision taken as the recommended default under the 2-hour rule): an inline `rep movs/stos` copy into a frame buffer formed by lea keeps the frame assumption; the model lets the copy write any byte of the frame."""

    def verdict(self, name):
        an = prog78(name)
        had = list(an.esc_addrs)
        an.run()
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        return had, an.direction(jne, 'taken')[0], an

    def test_a_copy_into_a_local_buffer_keeps_the_assumption(self):
        had, v, an = self.verdict('copy_ok')
        self.assertEqual(had, [])
        self.assertTrue(an.M.split)
        self.assertEqual(v, 'unsat')                                   # [ebp-4] = 0 after the copy; a store through the argument pointer; [ebp-4] != 0 ?

    def test_without_the_rule_the_copy_would_not_help(self):
        from unittest import mock
        with mock.patch.object(P, 'library_arg_lea', return_value=None):
            had, v, an = self.verdict('copy_ok')
        self.assertEqual(len(had), 1)
        self.assertFalse(an.M.split)
        self.assertEqual(v, 'sat')

    def test_the_copy_may_write_any_byte_of_the_frame(self):
        had, v, an = self.verdict('copy_cell_lost')
        self.assertEqual(had, [])
        self.assertEqual(v, 'sat')                                     # a cell set before the copy is unknown after it

    def test_a_frame_address_that_is_used_again_switches_the_assumption_off(self):
        for name in ('copy_edx_used', 'copy_edi_used', 'copy_no_restore', 'copy_call_reads_edx'):
            had, v, an = self.verdict(name)
            self.assertEqual(len(had), 1, name)
            self.assertFalse(an.M.split, name)
            self.assertEqual(v, 'sat', name)


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Out(unittest.TestCase):
    """FL-78 (decision taken as the recommended default under the 2-hour rule): a frame pointer passed to a function whose bytes show that it only stores floats through it keeps the frame assumption; the call writes exactly those bytes."""

    def verdict(self, name):
        an = prog78(name)
        had = list(an.esc_addrs)
        an.run()
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        return had, an.direction(jne, 'taken')[0], an

    def test_the_extent_is_read_from_the_callee(self):
        body, hexcode = P78['out_ok']
        image = image_of(bytes.fromhex(hexcode))
        self.assertEqual(P.out_param_extent(image, BASE + body, 0xc), 12)
        self.assertEqual(P.out_param_extent(image, BASE + body, 0x10), 0)          # that slot is never read: no store through it
        self.assertIsNone(P.out_param_extent(image, BASE + body, 0x8))             # the slot is the number, loaded by fld, not by mov

    def test_a_callee_that_only_stores_through_the_pointer_keeps_the_assumption(self):
        had, v, an = self.verdict('out_ok')
        self.assertEqual(had, [])
        self.assertTrue(an.M.split)
        self.assertEqual(list(an.M.out_writes.values()), [[(4, 12)]])
        self.assertEqual(v, 'unsat')

    def test_without_the_rule_the_call_would_not_help(self):
        from unittest import mock
        with mock.patch.object(P, 'library_arg_lea', return_value=None):
            had, v, an = self.verdict('out_ok')
        self.assertEqual(len(had), 1)
        self.assertFalse(an.M.split)
        self.assertEqual(v, 'sat')

    def test_the_call_writes_exactly_the_bytes_the_callee_writes(self):
        self.assertEqual(self.verdict('out_cell_inside')[1], 'sat')          # inside the 12 bytes: unknown after the call
        self.assertEqual(self.verdict('out_cell_above')[1], 'unsat')         # the first byte behind them is untouched

    def test_a_callee_that_does_anything_else_with_the_pointer_switches_the_assumption_off(self):
        for name in ('out_ptr_stored', 'out_ptr_pushed', 'out_ptr_loaded_twice', 'out_dest_form', 'out_wrong_slot', 'out_eax_used_after', 'out_reg_used'):
            had, v, an = self.verdict(name)
            self.assertEqual(len(had), 1, name)
            self.assertFalse(an.M.split, name)
            self.assertEqual(v, 'sat', name)

    def test_the_member_call_of_the_game_function_is_read_from_its_bytes(self):
        import original_differential as od
        if not od.available():
            self.skipTest('needs the pinned private work/original/GAME.EXE')
        self.assertEqual(P.out_param_extent(P.load_image(), 0x4fa127, 0xc), 12)       # three floats through [ebp+0xc]
        an = P.Analysis(P.row_of('0x4f7207'), P.load_image())
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual(an.M.out_writes, {0x4f757d: [(4, 12)]})


# FL-78: forward-window loop invariants. push ebp; mov ebp,esp; sub esp,8; mov [ebp-4],0; mov eax,[ebp+8]; cmp eax,5; jne bad (BASE+0x13); mov eax,1; leave; ret;
# bad: mov [ebp-8],0; hdr (BASE+0x23): cmp [ebp-8],3; jge done; mov eax,[ebp+12]; mov [eax],7; mov ecx,[ebp-8]; add ecx,1; mov [ebp-8],ecx; jmp hdr; done: mov eax,100; cdq; idiv dword [ebp-4]; leave; ret
# every run that takes the jne divides by [ebp-4] == 0 behind a loop whose generalised header loses the frame cell unless an invariant keeps it.
FWD_LOOP = bytes.fromhex('5589e583ec08c745fc000000008b450883f8057507b801000000c9c3c745f800000000837df8037d148b450cc700070000008b4df883c101894df8ebe6b86400000099f77dfcc9c3')
FWD_JNE, FWD_HDR = BASE + 0x13, BASE + 0x23
KEEP_ZERO = {'mem': ['ebp', -4, 4], 'op': 'eq', 'val': 0}
# FL-78 review: push ebp; mov ebp,esp; sub esp,8; mov edx,[ebp+12]; mov [ebp-4],edx; mov eax,[ebp+8]; cmp eax,5; jne bad (BASE+0x12); mov eax,1; leave; ret; bad: mov ecx,0; hdr (BASE+0x20): cmp ecx,3; jge done; add ecx,1; jmp hdr;
# done: mov eax,100; cdq; idiv dword [ebp-4]; leave; ret.   [ebp-4] is the second argument, so "every run that takes the jne faults" is false; the loop writes no memory
CIRC = bytes.fromhex('5589e583ec088b550c8955fc8b450883f8057507b801000000c9c3b90000000083f9037d0583c101ebf6b86400000099f77dfcc9c3')
CIRC_JNE, CIRC_HDR = BASE + 0x12, BASE + 0x20


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Forward(unittest.TestCase):
    """FL-78: loop invariants for the generalised headers of a forward (\"every run that takes it faults later\") window, per target, proved by the prover before they are used."""

    def faults(self, invariants):
        from unittest import mock
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(FWD_LOOP), 'callees': {}, 'imports': {}, 'sites': None}, image_of(FWD_LOOP), 20000)
        an, dom = Wn.from_analysis(an)
        before = len(an.M.facts)
        with mock.patch.object(Wn, 'load_forward_invariants', return_value=invariants):
            verdict = Wn.prove_faults(an, dom, ('dir', FWD_JNE, 'taken'))[0]
        return verdict, an, before

    def test_without_an_invariant_the_loop_loses_the_zero(self):
        self.assertNotEqual(self.faults({})[0], 'unsat')

    def test_an_inductive_invariant_keeps_the_zero_through_the_loop(self):
        self.assertEqual(self.faults({FWD_HDR: [KEEP_ZERO]})[0], 'unsat')

    def test_the_other_direction_still_returns_without_a_fault(self):
        from unittest import mock
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(FWD_LOOP), 'callees': {}, 'imports': {}, 'sites': None}, image_of(FWD_LOOP), 20000)
        an, dom = Wn.from_analysis(an)
        with mock.patch.object(Wn, 'load_forward_invariants', return_value={FWD_HDR: [KEEP_ZERO]}):
            self.assertNotEqual(Wn.prove_faults(an, dom, ('dir', FWD_JNE, 'fall'))[0], 'unsat')

    def test_an_invariant_that_is_false_on_entry_is_refused_and_leaves_no_fact_behind(self):
        verdict, an, before = self.faults({FWD_HDR: [{'mem': ['ebp', -4, 4], 'op': 'eq', 'val': 1}]})
        self.assertNotEqual(verdict, 'unsat')
        self.assertEqual(len(an.M.facts), before)

    def test_an_invariant_that_the_body_breaks_is_refused(self):
        verdict, an, before = self.faults({FWD_HDR: [KEEP_ZERO, {'mem': ['ebp', -8, 4], 'op': 'eq', 'val': 0}]})        # i is 0 on entry, the body adds one
        self.assertNotEqual(verdict, 'unsat')
        self.assertEqual(len(an.M.facts), before)

    def test_an_invariant_at_a_block_that_is_no_loop_header_is_refused(self):
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(FWD_LOOP), 'callees': {}, 'imports': {}, 'sites': None}, image_of(FWD_LOOP), 20000)
        an, dom = Wn.from_analysis(an)
        T = Wn.block_of(an, FWD_JNE, True)
        order = Wn.forward_region(an, T)
        with self.assertRaisesRegex(P.Unsupported, 'not a generalised loop header'):               # FL-78 review (minor e): the specific refusal, not just "not proved"
            Wn.run_forward(an, order, T, ('dir', FWD_JNE, 'taken'), inv={BASE + 0x29: [KEEP_ZERO]})
        self.assertNotEqual(self.faults({BASE + 0x29: [KEEP_ZERO]})[0], 'unsat')

    def circular(self, invariants):
        from unittest import mock
        import fl71_window as Wn
        an = P.Analysis({'va': BASE, 'body': len(CIRC), 'callees': {}, 'imports': {}, 'sites': None}, image_of(CIRC), 20000)
        an, dom = Wn.from_analysis(an)
        with mock.patch.object(Wn, 'load_forward_invariants', return_value=invariants):
            return Wn.prove_faults(an, dom, ('dir', CIRC_JNE, 'taken'))[0], an

    def test_a_false_atom_on_a_cell_a_memory_free_loop_never_writes_is_refused(self):               # FL-78 review (blocker 1)
        # [ebp-4] is the second argument (unknown), the loop at CIRC_HDR touches only ecx: its generalised header shares the entry state, so "holds on entry" used to be proved from the assumption itself
        self.assertNotEqual(self.circular({})[0], 'unsat')
        verdict, an = self.circular({CIRC_HDR: [KEEP_ZERO]})
        self.assertNotEqual(verdict, 'unsat')
        self.assertEqual(an.M.inv_facts, [])                                                            # nothing of a window stays behind

    def test_the_old_check_with_the_own_fact_in_the_facts_would_have_proved_it(self):               # the regression is real: with the fact conjoined to the initiation check the false atom passes
        from unittest import mock
        import fl71_window as Wn
        real = P.Analysis.check
        def leaky(self_, formula, timeout_ms=None, only=None):
            return real(self_, formula, timeout_ms, None)                                           # every invariant fact, the header's own included
        with mock.patch.object(P.Analysis, 'check', leaky):
            verdict, an = self.circular({CIRC_HDR: [KEEP_ZERO]})
        self.assertEqual(verdict, 'unsat')

    def test_the_target_names(self):
        import fl71_window as Wn
        self.assertEqual(Wn.forward_key(('dir', 0x49da7c, 'fall'), 0x49da75), '0x49da7c:fall')
        self.assertEqual(Wn.forward_key(('ins', 0x49da82), 0x49da7e), '0x49da7e:ins')

    def test_the_committed_forward_invariants_are_well_formed(self):
        import fl71_window as Wn
        data = json.loads(Wn.FWD_INVARIANTS.read_text())
        for va, targets in data.items():
            self.assertTrue(va.startswith('0x'))
            for name, headers in targets.items():
                self.assertRegex(name, r'^0x[0-9a-f]+:(taken|fall|ins)$')
                for header, atoms in headers.items():
                    self.assertTrue(header.startswith('0x'))
                    for at in atoms:
                        for a in at.get('or', [at]):
                            self.assertIn(a['op'], P._INV_OPS)
                            self.assertTrue(('val' in a) != ('mem2' in a))


def manifest():
    path = PROJECT / 'tasks/fl67-infeasible.json'
    return json.loads(path.read_text()) if path.exists() else None


MAN = manifest()


@unittest.skipUnless(MAN and MAN['rows'], 'no proved rows committed yet')
class Tier(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ledger = json.loads((PROJECT / 'function-ledger.json').read_text())
        cls.entries = {e['va']: e for e in cls.ledger['entries']}
        cls.scen = json.loads((PROJECT / 'tests/fl67_scenarios.json').read_text())

    def test_manifest_scenarios_and_ledger_agree(self):
        rows = MAN['rows']
        self.assertEqual(MAN['rule']['id'], 'T-EQ-INFEASIBLE')
        self.assertEqual(set(rows), set(self.scen))
        te = self.ledger['tested_equivalent']
        self.assertEqual(te['proved']['vas'], sorted(rows, key=lambda k: int(k, 16)))
        self.assertTrue(set(te['proved']['vas']) <= set(te['vas']))
        self.assertEqual(te['count'], len(te['vas']))

    def test_proved_rows_are_pending_never_ported(self):
        for k in MAN['rows']:
            self.assertEqual(self.entries[k]['status'], 'pending', k)

    def test_one_proof_per_missing_item(self):
        for k, r in MAN['rows'].items():
            self.assertEqual(len(r['proofs']['instructions']), r['instructions'][1] - r['instructions'][0], k)
            self.assertEqual(len(r['proofs']['directions']), r['directions'][1] - r['directions'][0], k)
            self.assertGreaterEqual(len(r['proofs']['instructions']) + len(r['proofs']['directions']), 1, k)

    def test_every_row_names_the_committed_translation(self):
        import fl66_tested as T
        texts = {}
        for k, r in MAN['rows'].items():
            text = texts.setdefault(r['source'], (PROJECT / r['source']).read_text())
            self.assertEqual(T.translation_sha_of(text, k), r['translation_sha256'], k)


@unittest.skipUnless(HAVE_Z3 and MAN and MAN['rows'], 'needs z3 and proved rows')
class Replay(unittest.TestCase):
    def test_sample_replays_and_reproves(self):
        import fl66_tested as T
        import original_differential as od
        if not od.available():
            self.skipTest('needs Unicorn and the pinned private work/original/GAME.EXE')
        scen = json.loads((PROJECT / 'tests/fl67_scenarios.json').read_text())
        keys = sorted(MAN['rows'], key=lambda k: int(k, 16))
        step = 1 if os.environ.get('FL67_FULL') else max(1, len(keys) // 8)
        for k in keys[::step]:
            r = T.check_row(k, scenarios=[T.norm(s) for s in scen[k]])
            row = MAN['rows'][k]
            self.assertEqual(r['status'], 'partial', k)                       # the kept scenarios alone leave exactly the proved items
            self.assertEqual(r['instructions'], row['instructions'], k)
            self.assertEqual(r['directions'], row['directions'], k)
            out = P.prove_row(k, {'missing': r['missing'], 'untaken': r['untaken']}, timeout_ms=60000)
            self.assertEqual(out['status'], 'proved', (k, out))
            self.assertEqual(sorted(out['instructions']), sorted(row['proofs']['instructions']), k)
            self.assertEqual(sorted(out['directions']), sorted(row['proofs']['directions']), k)

    def test_oracle_the_prover_never_rules_out_a_covered_item(self):
        import fl66_tested as T
        import original_differential as od
        if not od.available():
            self.skipTest('needs Unicorn and the pinned private work/original/GAME.EXE')
        covered = json.loads(T.MANIFEST.read_text())['rows']
        keys = sorted((k for k in covered if covered[k]['body'] <= 150), key=lambda k: (covered[k]['body'], k))      # a bigger row is up to 5 s a target and, at the extreme, more memory than the prover is allowed
        import multiprocessing
        checked = 0
        with multiprocessing.get_context('spawn').Pool(1, maxtasksperchild=1) as pool:
            for k in keys[::max(1, len(keys) // 20)][:20]:
                verdicts = pool.apply_async(_oracle_verdicts, (k,)).get(600)
                self.assertNotIn('unsat', verdicts, k)
                checked += verdicts != ['out of memory']
        self.assertGreaterEqual(checked, 10)                                    # the sample must really have been proved, not all swallowed


# FL-78: a direction after which every run goes round a loop for ever (prove_closed_loop). Programs (nasm, org 0x401000, [ebp-4] = 0 flag, [ebp-8] = the node pointer): hdr: cmp [ebp-4],0; jne out; eax = node; cmp [eax],2; jne next; flag = 1; jmp back;
# next: cmp [eax],1; jne back (the target, offset 0x2d); flag = 1; back: <the variants add instructions here>; jmp hdr; out: ret. A node that is neither 2 nor 1 never leaves the loop.
CLOSED = {
    'ok': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc00751f8b45f88338027509c745fc01000000eb0c8338017507c745fc01000000ebdbb801000000c9c3'),
    'flips': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075258b45f88338027509c745fc01000000eb0c8338017507c745fc01000000c70001000000ebd5b801000000c9c3'),       # back: mov [eax],1: the second round sees a 1 and leaves
    'counter': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075238b45f88338027509c745fc01000000eb0c8338017507c745fc01000000836dfc01ebd7b801000000c9c3'),        # back: sub [ebp-4],1: the flag is -1 in the second round and the loop leaves
    'call': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075248b45f88338027509c745fc01000000eb0c8338017507c745fc01000000e809000000ebd6b801000000c9c3c3'),     # back: call g
    'inner': (0x35, '5589e583ec08c745fc000000008b45088945f8837dfc007527b9030000004975fd8b45f88338027509c745fc01000000eb0c8338017507c745fc01000000ebd3b801000000c9c3'),   # a loop inside the window (mov ecx,3; l: dec ecx; jnz l)
    'spin': (0x0a, '5589e5833d000054000074f7b8010000005dc3'),                                                                                                         # hdr: cmp [0x540000],0; je hdr: waits for a flag that only another thread could set
    'ret': (0x0c, '5589e583ec088b45088338017505b802000000c9c3'),
    'chain_cond': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075258b45f88338027509c745fc01000000eb0c8338017507c745fc01000000837dfc077402ebd5b801000000c9c3'),   # back: cmp [ebp-4],7; je out; jmp hdr: a jump in the chain
    'chain_long': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075338b45f88338027509c745fc01000000eb0c8338017507c745fc01000000eb00eb00eb00eb00eb00eb00eb00eb00eb00eb00ebc7b801000000c9c3'),   # back: ten blocks of jmp to the next, then jmp hdr
    'chain_short': (0x2d, '5589e583ec08c745fc000000008b45088945f8837dfc0075258b45f88338027509c745fc01000000eb0c8338017507c745fc01000000eb00eb00eb00ebd5b801000000c9c3'),   # the same with three blocks of jmp
    'self': (0x12, '5589e583ec088b45088945fc8b45fc83380175f8b802000000c9c3'),                      # hdr: eax = [ebp-4]; cmp [eax],1; jne hdr (the jump is its own loop header)
    'self_count': (0x14, '5589e583ec088b45088945fc836dfc01837dfc0075f6b802000000c9c3'),            # hdr: sub [ebp-4],1; cmp [ebp-4],0; jne hdr: the counter reaches 0
    'ptr_spin': (0x12, '5589e583ec088b45088945fc8b45fc83380074f8b802000000c9c3'),                  # hdr: eax = [ebp-4]; cmp [eax],0; je hdr: waits on memory behind a pointer                                                                                                      # the direction leads to the return
}


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Loop(unittest.TestCase):
    """FL-78 (recommended default, to be reviewed): a direction after which every run goes round a loop for ever is never taken by a run that returns (the scenarios), so it is proved unreachable; the rule is the closed-loop check of fl71_window.prove_closed_loop."""

    def setup(self, name):
        import fl71_window as Wn
        jcc, hexcode = CLOSED[name]
        code = bytes.fromhex(hexcode)
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an, dom = Wn.from_analysis(an)
        return Wn, an, dom, BASE + jcc

    def test_a_direction_that_loops_for_ever_is_proved_unreachable(self):
        Wn, an, dom, jcc = self.setup('ok')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')

    def test_the_other_windows_do_not_prove_it_without_the_rule(self):
        Wn, an, dom, jcc = self.setup('ok')
        self.assertNotEqual(Wn.prove_target(an, dom, Wn.block_of(an, jcc, True), ('dir', 'taken'))[0], 'unsat')          # it is the closed-loop rule that proves it
        self.assertNotEqual(Wn.prove_faults(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')

    def test_the_direction_that_leaves_the_loop_is_not_proved(self):
        Wn, an, dom, jcc = self.setup('ok')
        self.assertNotEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'fall'))[0], 'unsat')

    def test_a_round_that_changes_what_the_next_round_reads_is_not_proved(self):
        for name in ('flips', 'counter'):
            Wn, an, dom, jcc = self.setup(name)
            self.assertNotEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat', name)

    def test_a_call_or_an_inner_loop_or_a_return_is_not_handled(self):
        for name in ('call', 'inner', 'ret', 'chain_cond', 'chain_long'):
            Wn, an, dom, jcc = self.setup(name)
            self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsupported', name)

    def test_a_chain_up_to_the_limit_is_followed_and_a_longer_one_is_not(self):
        Wn, an, dom, jcc = self.setup('chain_short')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')
        Wn, an, dom, jcc = self.setup('chain_long')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsupported')

    def test_a_wait_on_a_global_is_not_handled(self):                                              # review: no absolute address in the cycle
        Wn, an, dom, jcc = self.setup('spin')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsupported')

    def test_a_wait_on_memory_behind_a_pointer_is_accepted_by_the_stated_assumption(self):
        Wn, an, dom, jcc = self.setup('ptr_spin')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')          # RULE_TEXT2: that memory changes only through the cycle (the wait semantics)

    def test_a_jump_that_is_its_own_loop_header_is_handled(self):
        Wn, an, dom, jcc = self.setup('self')
        self.assertEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')
        self.assertNotEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'fall'))[0], 'unsat')
        Wn, an, dom, jcc = self.setup('self_count')
        self.assertNotEqual(Wn.prove_closed_loop(an, dom, ('dir', jcc, 'taken'))[0], 'unsat')        # the counter reaches 0 and the loop leaves

    def test_the_row_that_needs_it(self):
        import original_differential as od
        if not od.available():
            self.skipTest('needs the pinned private work/original/GAME.EXE')
        out = P.prove_row('0x425b8b', {'missing': [], 'untaken': [['0x425cf0', 'taken']]}, timeout_ms=40000)
        self.assertEqual(out['status'], 'proved')
        self.assertEqual(out['directions']['0x425cf0:taken'][0], 'unsat')
        self.assertIn('closed-loop:0x425cf0:taken', out['plan'])                                    # the record tells that it is closed-loop-proved


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Circular(unittest.TestCase):
    """FL-78 review (blocker 1): the proof of an invariant at a generalised header must not rest on the assumption of that same invariant. A loop that writes no memory keeps the entry state at its generalised header, so the assumed fact
    would make "it holds on entry" trivially true; the checks leave out the fact of the header they prove (Analysis.check `only`). Two older paths with the same shape: the whole-function analysis and the backward window."""

    def analysis(self, atoms):
        an = P.Analysis({'va': BASE, 'body': len(CIRC), 'callees': {}, 'imports': {}, 'sites': None}, image_of(CIRC), 20000)
        an.inv = {CIRC_HDR: atoms}
        return an

    def leaky(self):
        from unittest import mock
        real = P.Analysis.check
        return mock.patch.object(P.Analysis, 'check', lambda self_, formula, timeout_ms=None, only=None: real(self_, formula, timeout_ms, None))      # every invariant fact in every check, the header's own included

    def test_the_whole_function_analysis_refuses_a_false_atom(self):
        from unittest import mock
        an = self.analysis([KEEP_ZERO])
        with mock.patch.object(P, 'load_plan_hints', return_value={CIRC_HDR: 'gen'}):
            with self.assertRaisesRegex(P.Unsupported, 'entry edge'):
                an.run()

    def test_the_whole_function_analysis_used_to_accept_it(self):
        from unittest import mock
        an = self.analysis([KEEP_ZERO])
        with mock.patch.object(P, 'load_plan_hints', return_value={CIRC_HDR: 'gen'}), self.leaky():
            an.run()                                                                                  # accepted: the regression is real

    def test_the_backward_window_refuses_a_false_atom(self):
        import fl71_window as Wn
        an, dom = Wn.from_analysis(self.analysis([KEEP_ZERO]))
        T = Wn.block_of(an, BASE + 0x2a)
        with self.assertRaisesRegex(P.Unsupported, 'entry edge'):
            Wn.run_window(an, Wn.window(an, dom, BASE, T), BASE, T, ('ins', None), False)
        an, dom = Wn.from_analysis(self.analysis([KEEP_ZERO]))
        with self.leaky():
            Wn.run_window(an, Wn.window(an, dom, BASE, T), BASE, T, ('ins', None), False)            # accepted without the change

@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Review5(unittest.TestCase):
    """FL-78 round 9 (0x48f181): the pointer cell, the library function strstr, the loop header that forgets only the frame bytes the loop writes, the first visit of the only back edge."""

    REFUSED = ('pc_push', 'pc_copy', 'pc_stash', 'pc_call', 'pc_lea', 'pc_store', 'pc_byte', 'pc_sub', 'pc_index', 'pc_second', 'pc_esp', 'pc_live')

    def test_a_frame_address_that_only_goes_into_a_pointer_cell_keeps_the_frame_assumption(self):
        # [ebp-3] is zeroed, a pointer to [ebp-4] is kept in the local [ebp-0x10], a store through an ordinary pointer and a call come, the byte is read through the pointer
        for name in ('pc_ok', 'pc_add'):
            win, whole, an = win4(name)
            self.assertEqual((win, whole), ('unsat', 'unsat'), name)
            self.assertTrue(an.M.split, name)
            self.assertEqual(an.esc_addrs, [], name)
            self.assertIn('pointer-cell-frame-address', an.assumptions(), name)
            self.assertTrue(an.M.cell_ops, name)
        # without the rule the lea is an escape, the frame assumption is off and the call or the store may change [ebp-3]
        with mock.patch.object(P, 'pointer_cell', return_value=None):
            win, whole, an = win4('pc_ok')
            self.assertNotEqual((win, whole), ('unsat', 'unsat'))
            self.assertFalse(an.M.split)

    def test_every_other_use_of_the_cell_refuses_it(self):
        # the cell pushed to a callee that writes through it, copied to another register, stored in the heap and written through there, held in a register across a call that writes through it, computed with (`lea`),
        # written a second time, written as a byte, decremented, an indexed frame operand, a second frame address passed to a callee, an esp based operand: each leaves the lea an escape
        for name in self.REFUSED:
            win, an = win_only(name)
            self.assertFalse(an.M.split, name)
            self.assertEqual(an.M.cell_ops, set(), name)
            self.assertNotEqual(win, 'unsat', name)
            self.assertNotIn('pointer-cell-frame-address', an.assumptions(), name)

    def test_a_cell_that_is_not_set_on_every_path_gives_up(self):
        # the lea and the store are in a branch: on the other path the cell holds whatever the frame held, which is not a frame address
        with self.assertRaisesRegex(P.Unsupported, 'pointer cell'):
            win4('pc_cond')
        import z3
        s_esp, junk = z3.BitVec('s_esp', 32), z3.BitVec('h1', 32)
        arr = z3.Array('s_frm', z3.BitVecSort(32), z3.BitVecSort(8))
        self.assertTrue(P.pure_frame_term(s_esp - 4 + 2))
        self.assertTrue(P.pure_frame_term(z3.If(z3.Bool('c'), s_esp, s_esp - 8)))
        self.assertFalse(P.pure_frame_term(z3.If(z3.Bool('c'), s_esp, junk)))
        self.assertFalse(P.pure_frame_term(z3.Concat(*[z3.Select(arr, s_esp + k) for k in reversed(range(4))])))
        self.assertFalse(P.pure_frame_term(s_esp + junk))

    def test_a_register_loaded_from_the_cell_is_only_an_address(self):
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        ins = lambda hexcode: next(md.disasm(bytes.fromhex(hexcode), BASE))
        self.assertTrue(P._addr_only(ins('8a5001'), 'eax'))              # mov dl, [eax+1]
        self.assertTrue(P._addr_only(ins('c60005'), 'eax'))              # mov byte [eax], 5
        self.assertTrue(P._addr_only(ins('3a10'), 'eax'))                # cmp dl, [eax]
        self.assertFalse(P._addr_only(ins('8d7001'), 'eax'))             # lea esi, [eax+1]
        self.assertTrue(P._addr_only(ins('8908'), 'eax'))                # mov [eax], ecx
        self.assertFalse(P._addr_only(ins('8900'), 'eax'))               # mov [eax], eax stores the pointer
        self.assertFalse(P._addr_only(ins('89c1'), 'eax'))               # mov ecx, eax
        self.assertFalse(P._addr_only(ins('50'), 'eax'))                 # push eax
        self.assertFalse(P._addr_only(ins('83f801'), 'eax'))             # cmp eax, 1
        self.assertFalse(P._addr_only(ins('f3a4'), 'esi'))               # rep movsb reads esi implicitly
        self.assertFalse(P._addr_only(ins('f7e1'), 'eax'))               # mul ecx reads eax

    def test_strstr_is_a_listed_read_only_library_function(self):
        self.assertEqual(P.LIBRARY_WRITERS[0x50d8e0], ('strstr', ()))
        image = P.load_image()
        if image is None:
            self.skipTest('needs the pinned image')
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        body = list(md.disasm(bytes(image[0x50d8e0 - P.IMAGE_BASE:0x50d960 - P.IMAGE_BASE]), 0x50d8e0))
        self.assertTrue(any(i.mnemonic == 'ret' for i in body))
        self.assertFalse(any(o.access & capstone.CS_AC_WRITE for i in body for o in i.operands if o.type == P.X.X86_OP_MEM))        # (it writes no memory)
        self.assertFalse(any(i.mnemonic in ('push', 'call') and i.operands[0].type == P.X.X86_OP_MEM for i in body))
        an = P.Analysis(P.row_of('0x48f181'), image, 1000)
        self.assertTrue(an.M.split)
        self.assertEqual(an.esc_addrs, [])
        self.assertEqual({a for a in an.used if a.startswith('library-source')}, {'library-source:strstr'})

    def test_a_loop_header_forgets_only_the_frame_bytes_the_loop_writes(self):
        # the loop stores through an ordinary pointer and counts in [ebp-0x14]: [ebp-3] survives it
        win, an = win_only('pl_ok')
        self.assertEqual(win, 'unsat')
        h = next(h for h in an.loops)
        self.assertEqual(an.loop_frame_writes(h), [(-0x14, 4)])
        # the loop writes [ebp-3] itself / through an indexed operand / through a register holding the cell / calls something: the byte is not known after it (or the window gives up)
        self.assertEqual(win_only('pl_wr')[0], 'sat')
        self.assertIsNone(win_only('pl_idx')[1].loop_frame_writes(next(iter(win_only('pl_idx')[1].loops))))
        self.assertNotEqual(win_only('pl_idx')[0], 'unsat')
        win, an = win_only('pl_cellw')
        self.assertNotEqual(win, 'unsat')
        self.assertIsNone(an.loop_frame_writes(next(iter(an.loops))))
        self.assertTrue(an.cell_users)
        self.assertNotEqual(win_only('pl_call')[0], 'unsat')
        self.assertIsNone(win_only('pl_call')[1].loop_frame_writes(next(iter(win_only('pl_call')[1].loops))))
        # without the selective header the whole frame is forgotten, as before
        with mock.patch.object(P.Analysis, 'loop_frame_writes', return_value=None):
            self.assertEqual(win_only('pl_ok')[0], 'sat')
        # a store through the cell register that the rule did not see would be missed
        with mock.patch.object(P.Analysis, 'loop_frame_writes', lambda self_, h: [(-0x14, 4)]):
            self.assertEqual(win_only('pl_cellw')[0], 'unsat')                                       # (the regression the cell_users check prevents: [ebp-3] is written through the pointer)

    def test_the_only_back_edge_asked_for_is_taken_for_the_first_time_with_the_header_entered_from_outside(self):
        win, an = win_only('pl_first')                                    # `jne top` after a call: [ebp-3] is still zero the first time round
        self.assertEqual(win, 'unsat')
        # a second back edge that sets the byte makes a later round possible: the exemption does not apply
        win, an = win_only('pl_first2')
        self.assertEqual(win, 'sat')
        # and it is only for the direction of that edge: the other direction of the same jump is a plain window
        self.assertEqual(win_only('pl_first', kind='fall')[0], 'sat')



@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Review6(unittest.TestCase):
    """FL-78 round 9 review: a window after the lea of a pointer cell, the result of strstr, a loop that writes ebp or sets a bit in memory, the cell register as a scaled or added index."""

    STR = {'lib': ('strstr', ())}

    def window_of(self, name, jcc, kind, nth, formers=None):
        import fl71_window as Wn
        body, hexcode, labels = LIB4[name]
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        an, dom = Wn.from_analysis(P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000))
        if formers is not None:
            an.frame_formers = formers
        j = [i for i in an.insns if i.mnemonic == jcc][nth].address
        return Wn.prove_target(an, dom, Wn.block_of(an, j, True), ('dir', kind))[0], an

    def test_a_window_that_starts_after_the_lea_of_a_pointer_cell_has_no_frame_assumption(self):          # MAJOR 1
        # `mov ecx, [cell]` is in front of the branch, the store through ecx is after it: [ebp-0x10] is 7 whenever the window starts there
        win, whole, an = win4('pc_win', jcc='je', kind='fall', nth=1)
        self.assertEqual((win, whole), ('sat', 'sat'))
        self.assertEqual(an.esc_addrs, [])                                    # (the cell rule applies: the whole function keeps the frame assumption)
        self.assertEqual(len(an.frame_formers), 1)
        # the frame pass of a window is for windows that no lea can have run in front of: without the lea in frame_formers the window wrongly rules the direction out
        self.assertEqual(self.window_of('pc_win', 'je', 'fall', 1, formers=[])[0], 'unsat')
        # a window in front of the lea still has it (pc_ok: the window starts at the entry)
        win, whole, an = win4('pc_ok')
        self.assertEqual((win, whole), ('unsat', 'unsat'))

    def test_the_result_of_strstr_is_a_pointer_into_the_buffer(self):          # MAJOR 2
        an, img, L = an4('ss_test', writers=self.STR)                          # eax is tested, read through and compared: the buffer is only read
        self.assertTrue(an.M.split)
        self.assertEqual(an.esc_addrs, [])
        self.assertIn('library-source:strstr', an.assumptions())
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        self.assertEqual(an.direction(jne, 'taken')[0], 'unsat')
        for name in ('ss_store', 'ss_rmw', 'ss_push', 'ss_copy'):              # a store through it, a read-modify-write, a push, a copy: the lea is an escape and the buffer may change
            an, img, L = an4(name, writers=self.STR)
            self.assertFalse(an.M.split, name)
            self.assertEqual(len(an.esc_addrs), 1, name)
            jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
            self.assertEqual(an.direction(jne, 'taken')[0], 'sat', name)
        # without the rule the store goes to ordinary memory and the direction is wrongly ruled out
        with mock.patch.object(P, 'LIBRARY_POINTS_INTO_ARGUMENT', frozenset()):
            an, img, L = an4('ss_store', writers=self.STR)
            self.assertTrue(an.M.split)
            jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
            self.assertEqual(an.direction(jne, 'taken')[0], 'unsat')
        # a read-only callee that passes the pointer on to strstr could return the result: not accepted
        self.assertIn('strstr', P.LIBRARY_POINTS_INTO_ARGUMENT)

    def loop_writes(self, name):
        import fl71_window as Wn
        body, hexcode, labels = LIB4[name]
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        an, dom = Wn.from_analysis(P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000))
        return an.loop_frame_writes(next(iter(an.loops)))

    def test_a_loop_that_writes_ebp_or_sets_a_bit_in_memory_forgets_the_whole_frame(self):          # MINOR 1, 2
        self.assertEqual(self.loop_writes('pl_bt'), [(-0x14, 4)])                # (bt only reads: still accepted)
        self.assertIsNone(self.loop_writes('pl_ebp'))                            # mov ebp, ebx
        self.assertIsNone(self.loop_writes('pl_bts'))                            # btr dword [ebp-8], 24
        self.assertIsNone(self.loop_writes('pl_cx8'))                            # cmpxchg8b [ebp-0x30]

    def test_the_cell_register_is_not_a_scaled_index_or_added_to_a_base(self):          # MINOR 3
        import capstone
        md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        md.detail = True
        ins = lambda hexcode: next(md.disasm(bytes.fromhex(hexcode), BASE))
        self.assertFalse(P._addr_only(ins('8a144500000000'), 'eax'))            # mov dl, [eax*2]
        self.assertTrue(P._addr_only(ins('8a140500000000'), 'eax'))             # mov dl, [eax*1]: the address it holds
        self.assertTrue(P._addr_only(ins('8a5010'), 'eax'))                     # mov dl, [eax+0x10]
        self.assertFalse(P._addr_only(ins('8a1408'), 'ecx'))                    # mov dl, [eax+ecx]: ecx added to another base
        self.assertTrue(P._addr_only(ins('8a1408'), 'eax'))                     # (eax as the base, ecx an ordinary index)
        self.assertFalse(P._addr_only(ins('8a1441'), 'eax'))                    # mov dl, [ecx+eax*2]
        self.assertTrue(P._addr_only(ins('8a1441'), 'ecx'))
        self.assertTrue(P._addr_only(ins('8a1488'), 'eax'))                     # mov dl, [eax+ecx*4]


# FL-78 (round 10): a direction after which every run is caught in a loop that it never leaves (prove_trap_loop). Programs (nasm, org 0x401000): the three words at [ebx] are zeroed, a count at [ebp+0xc]: `jbe L` is taken for a count of 0 and enters the loop L
# (cmp [ebx+8],edx; jne out; the words are shifted by 16 and the frame counter [ebp-4] is changed), which never leaves when the words are zero.
TRAP = {
    'tl_ok': (74, '5589e583ec10538b5d0831d289138953048953088b4d0c39d17608b8010000005bc9c3395308751a8b4b048b03c1e010c1e9108145fcf0ff0000894b08894304ebe1b8020000005bc9c390', {'start': 0, 'L': 35, 'out': 66}),
    'tl_unzero': (71, '5589e583ec10538b5d0831d289138953088b4d0c39d17608b8010000005bc9c3395308751a8b4b048b03c1e010c1e9108145fcf0ff0000894b08894304ebe1b8020000005bc9c390', {'start': 0, 'L': 32, 'out': 63}),
    'tl_wild': (76, '5589e583ec10538b5d0831d289138953048953088b4d0c8b751039d17608b8010000005bc9c339530875198b4b048b03c1e010c1e910c70605000000894b08894304ebe2b8020000005bc9c390', {'start': 0, 'L': 38, 'out': 68}),
    'tl_escape': (80, '5589e583ec10538b5d0831d289138953048953088b4d0c8d75f889751439d17608b8010000005bc9c3395308751a8b4b048b03c1e010c1e9108145fcf0ff0000894b08894304ebe1b8020000005bc9c390', {'start': 0, 'L': 41, 'out': 72}),
    'tl_call': (72, '5589e583ec10538b5d0831d289138953048953088b4d0c39d17608b8010000005bc9c339530875188b4b048b03c1e010c1e910e808000000894b08894304ebe3b8020000005bc9c390', {'start': 0, 'L': 35, 'out': 64}),
    'tl_abs': (72, '5589e583ec10538b5d0831d289138953048953088b4d0c39d17608b8010000005bc9c339530875188b4b048b03c1e010c1e910a300005400894b08894304ebe3b8020000005bc9c390', {'start': 0, 'L': 35, 'out': 64}),
    # FL-78 (round 10 review): programs whose trap-direction is feasible (a run takes the jump and leaves the loop); tl_cell: a frame address in a cell [ebp-4] reaches ecx, the store through ecx writes the word the loop tests; tl_flag: the loop exit is a jne on the flags of the cmp in front of the jump; tl_fp: it is a jne after fcom / fnstsw / sahf; tl_push: the loop pushes and pops a word it reads from the arguments
    'tl_cell': (56, '5589e583ec208d45f08945fcc745f0050000008b4dfc837d08007507b801000000c9c3837df0057508c70107000000ebf2b803000000c9c3', {}),
    'tl_flag': (32, '5589e5837d08007507b8010000005dc37507b901000000ebf7b8030000005dc3', {}),
    'tl_fp': (33, '5589e5837d0c007507b8010000005dc3dc5508dfe09e7502ebf6b8030000005dc3', {}),
    'tl_push': (36, '5589e56a05837d08007507b801000000c9c3ff750c5983f9057502ebf5b803000000c9c3', {}),
    'tl_count': (88, '5589e583ec10538b5d0831d28913895304895308c745fc030000008b4d0c39d17608b8010000005bc9c339530875218b4b048b03c1e010c1e910ff4dfc837dfc007505b901000000894b08894304ebdab8020000005bc9c390', {'start': 0, 'L': 42, 'cont': 72, 'out': 80}),
}


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl78Trap(unittest.TestCase):
    """FL-78 round 10 (0x518caf): the loop that a run enters at a jump and never leaves is proved by an inductive invariant found from the state at the jump (prove_trap_loop)."""

    def setup(self, name, jcc='jbe'):
        import fl71_window as Wn
        body, hexcode, labels = TRAP[name]
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        an, dom = Wn.from_analysis(P.Analysis({'va': BASE, 'body': body, 'callees': {BASE + labels['out']: 0}, 'imports': {}, 'sites': None}, img, 20000))
        return Wn, an, dom, [i for i in an.insns if i.mnemonic == jcc][0].address

    def setup_free(self, name):
        import fl71_window as Wn
        body, hexcode, labels = TRAP[name]
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        an, dom = Wn.from_analysis(P.Analysis({'va': BASE, 'body': body, 'callees': {}, 'imports': {}, 'sites': None}, img, 20000))
        return Wn, an, dom, [i for i in an.insns if i.mnemonic == 'jne'][0].address

    def test_a_pointer_cell_register_that_the_loop_stores_through_is_not_a_frame_term(self):
        """Review of round 10: `lea eax,[ebp-0x10]; mov [ebp-4],eax; ...; mov ecx,[ebp-4]` then `jne trap` to a loop `cmp [ebp-0x10],5; jne out; mov [ecx],7; jmp lp`: round 1 writes 7 through ecx over the word, round 2 leaves. The frame pass takes the arbitrary round for fresh registers, so the store through ecx was classed as memory and the word looked unchanged."""
        Wn, an, dom, j = self.setup_free('tl_cell')
        self.assertTrue(an.M.cell_ops)
        self.assertNotEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat')
        self.assertFalse(getattr(an, 'trap_loop_frame', False))
        Wn, an, dom, j = self.setup_free('tl_cell')                             # without the cell guard the proof is wrongly found
        an.M.cell_ops, an.cell_users, an.frame_formers = set(), set(), []
        self.assertEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat')

    def test_a_loop_whose_exit_the_state_before_the_jump_decides_is_not_proved(self):
        for name in ('tl_flag', 'tl_fp', 'tl_push'):       # the exit tests flags set in front of the jump, the x87 status of an unknown st(0), a word read from the arguments through the stack
            Wn, an, dom, j = self.setup_free(name)
            self.assertNotEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat', name)

    def test_a_loop_that_never_leaves_is_proved(self):
        Wn, an, dom, j = self.setup('tl_ok')
        self.assertEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat')
        self.assertTrue(an.trap_loop_frame)                                     # (the store to [ebp-4] must not reach the words: the frame assumption)
        # the other windows and the closed-loop rule do not prove it, nor does the other direction
        self.assertNotEqual(Wn.prove_target(an, dom, Wn.block_of(an, j, True), ('dir', 'taken'))[0], 'unsat')
        self.assertNotEqual(Wn.prove_closed_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat')
        self.assertEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'fall'))[0], 'unsupported')

    def test_a_loop_that_a_run_can_leave_is_not_proved(self):
        for name in ('tl_unzero', 'tl_wild', 'tl_count'):          # a word that is not zeroed, a store through an unknown pointer, a counter that sets the word
            Wn, an, dom, j = self.setup(name)
            self.assertNotEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat', name)

    def test_the_frame_assumption_is_needed_and_is_not_made_after_a_frame_address(self):
        Wn, an, dom, j = self.setup('tl_ok')
        with mock.patch.object(P.Analysis, 'frame_safe', return_value=False):
            self.assertEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'sat')
        Wn, an, dom, j = self.setup('tl_escape')                                # a frame address is formed in front of the jump: the store to [ebp-4] may reach the words
        self.assertNotEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsat')
        self.assertFalse(getattr(an, 'trap_loop_frame', False))

    def test_a_loop_with_a_call_or_an_absolute_address_is_not_handled(self):
        for name in ('tl_call', 'tl_abs'):
            Wn, an, dom, j = self.setup(name)
            self.assertEqual(Wn.prove_trap_loop(an, dom, ('dir', j, 'taken'))[0], 'unsupported', name)

    def test_prove_row_records_the_assumptions(self):
        import fl71_window as Wn
        body, hexcode, labels = TRAP['tl_ok']
        img = bytes(image_of(bytes.fromhex(hexcode))) + bytes(64)
        j = [i for i in P.disassemble(img, BASE, body)[1] if i.mnemonic == 'jbe'][0].address
        with mock.patch.object(P, 'row_of', return_value={'va': BASE, 'body': body, 'callees': {BASE + labels['out']: 0}, 'imports': {}, 'sites': None}):
            out = P.prove_row('tl_ok', {'missing': [], 'untaken': [[j, 'taken']]}, image=img, timeout_ms=20000)
        self.assertEqual(out['status'], 'proved')
        self.assertIn('closed-loop-wait-semantics', out['assumptions_used'])
        self.assertIn('frame-assumption', out['assumptions_used'])


if __name__ == '__main__':
    unittest.main()
