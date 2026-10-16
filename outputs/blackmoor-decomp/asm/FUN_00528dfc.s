# FUN_00528dfc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528dfc
# extent:       0x00528dfc-0x00528e07 (11 code bytes)
# span:         0x00528dfc-0x00528e07 (code 11, tables 0, padding 0)
# sha256:       9f83610e9fb82b59c3b8d9644b7662998dd621af127bed52093dc774f3d1caea
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528dfc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_bc
# callees:      calls tail jump FUN_005267ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_bc, 0xbc  # offset -0xbc

# --- external targets -----------------------------------------------
.set FUN_005267ed, .text + (0x005267ed - 0x401000)

.org 0x00528dfc - 0x401000
.globl FUN_00528dfc
FUN_00528dfc:
    # block 0x00528dfc: entry, 2 instruction(s), ends with backward jump to 0x005267ed
    lea ecx, [ebp - field_minus_bc]              # 00528dfc
    jmp.d32 FUN_005267ed                         # 00528e02

