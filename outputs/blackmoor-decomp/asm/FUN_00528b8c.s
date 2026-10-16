# FUN_00528b8c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528b8c
# extent:       0x00528b8c-0x00528b94 (8 code bytes)
# span:         0x00528b8c-0x00528b94 (code 8, tables 0, padding 0)
# sha256:       67f98c0eac6122f64a46e8f89c6092598be4b70fe81c26a7da1cf56bf3d50b40
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528b8c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_8
# callees:      calls tail jump FUN_0050c1a7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528b94
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0050c1a7, .text + (0x0050c1a7 - 0x401000)

.org 0x00528b8c - 0x401000
.globl FUN_00528b8c
FUN_00528b8c:
    # block 0x00528b8c: entry, 2 instruction(s), ends with backward jump to 0x0050c1a7
    lea ecx, [ebp - field_minus_8]               # 00528b8c
    jmp.d32 FUN_0050c1a7                         # 00528b8f

