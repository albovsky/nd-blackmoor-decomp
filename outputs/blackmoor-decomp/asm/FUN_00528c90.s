# FUN_00528c90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528c90
# extent:       0x00528c90-0x00528c9e (14 code bytes)
# span:         0x00528c90-0x00528c9e (code 14, tables 0, padding 0)
# sha256:       d1748e3a94581a75f692602f33347d27e6f285fa345c90f6f5679cbd54d8d061
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528c90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528c9e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528c90 - 0x401000
.globl FUN_00528c90
FUN_00528c90:
    # block 0x00528c90: entry, 3 instruction(s), ends with backward jump to 0x0051e7ba
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528c90
    add ecx, 0x84                                # 00528c93
    jmp.d32 FUN_0051e7ba                         # 00528c99

