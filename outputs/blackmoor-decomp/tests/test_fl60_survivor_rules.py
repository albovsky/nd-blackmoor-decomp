"""FL-60: the survivor rules see a call that follows an inline comment.

A call to an import is written `esp -= 4u; WR32(esp, ret);  /* call [DLL!name] */ FL41_CALL(...); ...  /* 0x...: call ... */`. The helper `stmt` used to cut a line at its FIRST `/*`, which hid the
FL41_CALL from the barrier test, so the rule `same value` excused dropping a reload of a frame slot across a call (0x4db147 line 14: a corpus seed kills that mutant). Needs capstone, no private files.
"""
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl40_survivors as S40
import fl41_survivors as S41
import fl46_rules as R46

IMPORT_CALL = 'esp -= 4u; WR32(esp, 0x4db15fu);  /* call [USER32.dll!ClientToScreen] */ FL41_CALL(0x52a478u); esp += 8u; esp += 4u;  /* 0x4db159: call dword ptr [0x52a478] */'
ROW = [
    'eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4db14e: mov eax, dword ptr [ebp + 0xc] */',
    'esp -= 4u; WR32(esp, eax);  /* 0x4db151: push eax */',
    IMPORT_CALL,
    'eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4db15f: mov eax, dword ptr [ebp + 0xc] */',
]


class SurvivorRuleCallVisibility(unittest.TestCase):
    def test_stmt_keeps_a_call_after_an_inline_comment(self):
        for stmt in (S41.stmt, S41.stmt_full, R46.stmt):
            self.assertIn('FL41_CALL', stmt(IMPORT_CALL))
            self.assertNotIn('/*', stmt(IMPORT_CALL))
        self.assertIn('FL40_CALL', S40.stmt(IMPORT_CALL.replace('FL41_', 'FL40_')))

    def test_same_value_does_not_reach_across_a_call(self):
        self.assertFalse(S41.same_value(ROW, 3))
        self.assertFalse(S40.same_value([l.replace('FL41_', 'FL40_') for l in ROW], 3))

    def test_same_value_still_holds_on_straight_line_code(self):
        rows = [ROW[0], ROW[1], 'ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4db152: mov ecx, dword ptr [ebp + 8] */', ROW[3]]
        self.assertTrue(S41.same_value(rows, 3))


if __name__ == '__main__':
    unittest.main()
