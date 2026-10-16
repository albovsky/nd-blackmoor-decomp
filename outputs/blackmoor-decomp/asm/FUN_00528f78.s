# FUN_00528f78
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528f78
# extent:       0x00528f78-0x00528f80 (8 code bytes)
# span:         0x00528f78-0x00528f80 (code 8, tables 0, padding 0)
# sha256:       f5b1445f4ccd20421b5adc5fd47cd6390ec7a5c232df43bd89aa1d3abaa19d4f
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528f78
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_28
# callees:      calls tail jump FUN_0051a2ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528f80
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_28, 0x28  # offset -0x28

# --- external targets -----------------------------------------------
.set FUN_0051a2ed, .text + (0x0051a2ed - 0x401000)

.org 0x00528f78 - 0x401000
.globl FUN_00528f78
FUN_00528f78:
    # block 0x00528f78: entry, 2 instruction(s), ends with backward jump to 0x0051a2ed
    lea ecx, [ebp - field_minus_28]              # 00528f78
    jmp.d32 FUN_0051a2ed                         # 00528f7b

