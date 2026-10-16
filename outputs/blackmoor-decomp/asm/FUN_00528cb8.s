# FUN_00528cb8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528cb8
# extent:       0x00528cb8-0x00528cc0 (8 code bytes)
# span:         0x00528cb8-0x00528cc0 (code 8, tables 0, padding 0)
# sha256:       5ed5145e085e59424659f1a7db6f4c8abe0927e50b2f2a03a2988fba68b76bd8
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528cb8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_24
# callees:      calls tail jump FUN_0051fc5c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528cc0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_24, 0x24  # offset -0x24

# --- external targets -----------------------------------------------
.set FUN_0051fc5c, .text + (0x0051fc5c - 0x401000)

.org 0x00528cb8 - 0x401000
.globl FUN_00528cb8
FUN_00528cb8:
    # block 0x00528cb8: entry, 2 instruction(s), ends with backward jump to 0x0051fc5c
    lea ecx, [ebp - field_minus_24]              # 00528cb8
    jmp.d32 FUN_0051fc5c                         # 00528cbb

