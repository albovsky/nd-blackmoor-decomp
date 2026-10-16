# FUN_005290af
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005290af
# extent:       0x005290af-0x005290ba (11 code bytes)
# span:         0x005290af-0x005290ba (code 11, tables 0, padding 0)
# sha256:       c3d2661e90bbb30582c3a388c68ab82969d4b36363e2e6878f78f0e4741044a6
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005290af
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051a4bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x005290ba
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051a4bd, .text + (0x0051a4bd - 0x401000)

.org 0x005290af - 0x401000
.globl FUN_005290af
FUN_005290af:
    # block 0x005290af: entry, 3 instruction(s), ends with backward jump to 0x0051a4bd
    mov ecx, dword ptr [ebp - field_minus_10]    # 005290af
    add ecx, 0x20                                # 005290b2
    jmp.d32 FUN_0051a4bd                         # 005290b5

