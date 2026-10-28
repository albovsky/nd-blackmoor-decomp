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
import sys
import unittest

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
            got = Wn.prove_target(an, dom, T, ('dir', 'taken'))[0]
            self.assertEqual(got == 'unsat', verdict == 'unsat', (atoms, got))

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
FRAME_EARLIER = bytes.fromhex('5589e583ec08c745fc000000008d4dfc8b4508c70007000000837dfc00750689c889ec5dc3b80900000089ec5dc3')
FRAME_LATER = bytes.fromhex('5589e583ec08c745fc000000008b4508c70007000000837dfc0075098d4dfc89c889ec5dc3b80900000089ec5dc3')
# call C; cmp eax,0x8000; jae never; ret; never: mov eax,9; ret; body_end: C: mov eax,[esp+4]; and eax,MASK; ret
RETBOUND = {m: bytes.fromhex('e80e0000003d008000007301c3b809000000c38b440424' + m + 'c3') for m in ('25ff7f0000', '25ffff0000', '2500000080')}
# push ebp; mov ebp,esp; sub esp,16; mov [ebp-12],0; mov [ebp-8],0; lea eax,[ebp-8]; push eax; call C; cmp [ebp-12],0; jne never; cmp [ebp-8],0; jne maybe; ... (body 0x44 bytes), then C
FP_CALLER = '5589e583ec10c745f400000000c745f8000000008d45f850e827000000837df400750f837df8007512b80100000089ec5dc3b80900000089ec5dc3b80200000089ec5dc3'
FP_CALLEES = {
    'good': '5589e58b5508c70205000000c74204060000005dc20400',          # mov edx,[ebp+8]; mov [edx],5; mov [edx+4],6; pop ebp; ret 4
    'leak': '5589e58b55088915000060005dc20400',                         # mov edx,[ebp+8]; mov [0x600000],edx
    'pass': '5589e5ff7508e8b10f000083c4045dc20400',                     # push dword [ebp+8]; call ...
    'arith': '5589e58b550883c264c702050000005dc20400',                  # add edx,100 before the store
}


# push ebp; mov ebp,esp; sub esp,4; mov [ebp-4],0; mov eax,[ebp+8]; cmp eax,5; jne bad; mov eax,1; jmp done; bad: mov eax,100; cdq; idiv dword [ebp-4]; done: mov esp,ebp; pop ebp; ret
FAULT_LATER = bytes.fromhex('5589e583ec04c745fc000000008b450883f8057507b801000000eb09b86400000099f77dfc89ec5dc3')


# FAULT_LATER with a second exit on the path `bad`: cmp eax,6; jne tail; ... tail: mov esp,ebp; pop ebp; jmp 0x500000 (a tail call outside the body, which does not fault)
FAULT_OR_TAIL = bytes.fromhex('5589e583ec04c745fc000000008b450883f8057507b801000000eb0983f806750899f77dfc89ec5dc389ec5de9cfef0f00')
# push ebp; mov ebp,esp; sub esp,16; [ebp-12]=0; [ebp-8]=0; lea eax,[ebp-8]; push eax; call C; mov [eax],7; cmp [ebp-8],0; jne other; ...; C: push ebp; mov ebp,esp; mov eax,[ebp+8]; pop ebp; ret 4
RET_PTR = bytes.fromhex('5589e583ec10c745f400000000c745f8000000008d45f850e81e000000c70007000000837df8007509b80100000089ec5dc3b80200000089ec5dc35589e58b45085dc20400')


# push ebp; mov ebp,esp; mov eax,[ebp+8]; test eax,eax; jne tail; leave; jmp L; tail: mov eax,3; leave; jmp L; L: cmp esp,ebp; je yes; mov eax,1; ret; yes: mov eax,2; ret
LEAVE_JOIN = bytes.fromhex('5589e58b450885c07503c9eb08b803000000c9eb0039ec7406b801000000c3b802000000c3')
# callee that stores through the register that still holds the caller's pointer: push ebp; mov ebp,esp; mov dword [eax],7; pop ebp; ret 4
ENTRY_ALIAS = bytes.fromhex('5589e5c700070000005dc20400')

# the same caller, but it overwrites eax (xor eax,eax; nops) instead of storing through it
RET_PTR_DEAD = RET_PTR.replace(bytes.fromhex('c70007000000'), bytes.fromhex('31c090909090'))
# callees that must get no footprint: a write above the callee's frame, and a partial overwrite of the pointer register
CALLEE_BAD = {
    'high_write': '5589e5c7451007000000 5dc20400'.replace(' ', ''),                  # mov dword [ebp+16], 7
    'partial': '5589e58b5508b200c70207000000 5dc20400'.replace(' ', ''),            # mov edx,[ebp+8]; mov dl,0; mov dword [edx],7
}


def image_of(code, tail=b''):
    return bytes(BASE - P.IMAGE_BASE) + code + tail + bytes(64)


@unittest.skipUnless(HAVE_Z3, 'needs z3-solver, capstone')
class Fl75(unittest.TestCase):
    """FL-75: jump tables cut at their range check, the frame assumption per window, callee return bounds and callee write footprints."""

    def two_tables(self, code=TWO_TABLES, tight=True):
        body = 0x23
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
                self.assertTrue(v == 'gen' or v in P.UNROLL, (va, h, v))
        self.assertEqual(P.load_plan_hints(0x401000), {})

    def test_a_path_that_may_leave_by_a_tail_jump_is_not_one_that_faults_later(self):
        import fl71_window as Wn
        code = FAULT_OR_TAIL
        an = P.Analysis({'va': BASE, 'body': len(code), 'callees': {}, 'imports': {}, 'sites': None}, image_of(code), 20000)
        an, dom = Wn.from_analysis(an)
        jne = [i for i in an.insns if i.mnemonic == 'jne'][0].address
        self.assertNotEqual(Wn.prove_faults(an, dom, ('dir', jne, 'taken'))[0], 'unsat')        # eax == 5 is excluded, eax == 6 divides by zero, any other value jumps out of the function

    def ret_ptr(self, code):
        image = image_of(code)
        an = P.Analysis({'va': BASE, 'body': 0x3b, 'callees': {BASE + 0x3b: 4}, 'imports': {}, 'sites': None}, image, 20000)
        return an, image

    def test_a_callee_that_returns_its_pointer_is_not_usable_when_the_caller_reads_the_register_again(self):
        import fl75_footprint as FP
        an, image = self.ret_ptr(RET_PTR)
        self.assertEqual(FP.callee_summary(image, BASE + 0x3b, frozenset({'eax'})), (0, 0, frozenset({'eax'})))
        self.assertFalse(an.M.split)                                    # `mov [eax], 7` after the call would store through the frame address: no frame assumption
        self.assertEqual(an.M.footprints, {})
        an.run()
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        self.assertEqual(an.direction(jne, 'taken')[0], 'sat')

    def test_a_callee_that_returns_its_pointer_is_usable_when_the_caller_overwrites_the_register(self):
        an, image = self.ret_ptr(RET_PTR_DEAD)
        self.assertTrue(an.M.split)
        an.run()
        jne = [i.address for i in an.insns if i.mnemonic == 'jne'][0]
        self.assertEqual(an.direction(jne, 'taken')[0], 'unsat')        # nothing writes [ebp-8]

    def test_a_callee_with_a_write_above_its_frame_or_a_partly_overwritten_pointer_gets_no_footprint(self):
        import fl75_footprint as FP
        caller = bytes.fromhex(FP_CALLER)
        for kind, hexa in CALLEE_BAD.items():
            image = image_of(caller, bytes.fromhex(hexa))
            self.assertIsNone(FP.callee_footprint(image, BASE + 0x44), kind)

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

    def fp(self, kind):
        caller = bytes.fromhex(FP_CALLER)
        callee = bytes.fromhex(FP_CALLEES[kind])
        self.assertEqual(len(caller), 0x44)
        image = image_of(caller, callee)
        an = P.Analysis({'va': BASE, 'body': len(caller), 'callees': {BASE + 0x44: 4}, 'imports': {}, 'sites': None}, image, 20000)
        return an, image

    def test_a_callee_that_writes_only_through_its_pointer_leaves_the_frame_assumption_on(self):
        import fl75_footprint as FP
        an, image = self.fp('good')
        self.assertEqual(FP.callee_footprint(image, BASE + 0x44), (0, 8))
        self.assertTrue(an.M.split)
        an.run()
        jne_never, jne_maybe = [i.address for i in an.insns if i.mnemonic == 'jne']
        self.assertEqual(an.direction(jne_never, 'taken')[0], 'unsat')       # [ebp-12] is outside the 8 bytes the callee may write
        self.assertEqual(an.direction(jne_maybe, 'taken')[0], 'sat')         # [ebp-8] is inside

    def test_a_callee_that_keeps_or_passes_its_pointer_or_computes_with_it_gets_no_footprint(self):
        import fl75_footprint as FP
        for kind in ('leak', 'pass', 'arith'):
            an, image = self.fp(kind)
            self.assertIsNone(FP.callee_footprint(image, BASE + 0x44), kind)
            self.assertFalse(an.M.split, kind)


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


if __name__ == '__main__':
    unittest.main()
