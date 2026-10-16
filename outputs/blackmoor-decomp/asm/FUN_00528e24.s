# FUN_00528e24
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528e24
# extent:       0x00528e24-0x00528e2f (11 code bytes)
# span:         0x00528e24-0x00528e2f (code 11, tables 0, padding 0)
# sha256:       3f27ef8df5597936b66dea248322ea3edad0e372c4a2cc1e350d0fee7747ec49
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528e24
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_b0
# callees:      calls tail jump FUN_005267ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528e2f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_b0, 0xb0  # offset -0xb0

# --- external targets -----------------------------------------------
.set FUN_005267ed, .text + (0x005267ed - 0x401000)

.org 0x00528e24 - 0x401000
.globl FUN_00528e24
FUN_00528e24:
    # block 0x00528e24: entry, 2 instruction(s), ends with backward jump to 0x005267ed
    lea ecx, [ebp - field_minus_b0]              # 00528e24
    jmp.d32 FUN_005267ed                         # 00528e2a

