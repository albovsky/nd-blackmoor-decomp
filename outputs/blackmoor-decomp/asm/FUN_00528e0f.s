# FUN_00528e0f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528e0f
# extent:       0x00528e0f-0x00528e1a (11 code bytes)
# span:         0x00528e0f-0x00528e1a (code 11, tables 0, padding 0)
# sha256:       a3cf8b8edb90ab6ba3d2131ad16c71db49dab7806a9b17b159e6af294934dbb9
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528e0f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_160
# callees:      calls tail jump FUN_005267ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528e1a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_160, 0x160  # offset -0x160

# --- external targets -----------------------------------------------
.set FUN_005267ed, .text + (0x005267ed - 0x401000)

.org 0x00528e0f - 0x401000
.globl FUN_00528e0f
FUN_00528e0f:
    # block 0x00528e0f: entry, 2 instruction(s), ends with backward jump to 0x005267ed
    lea ecx, [ebp - field_minus_160]             # 00528e0f
    jmp.d32 FUN_005267ed                         # 00528e15

