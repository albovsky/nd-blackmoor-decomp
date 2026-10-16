# FUN_00528f18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528f18
# extent:       0x00528f18-0x00528f23 (11 code bytes)
# span:         0x00528f18-0x00528f23 (code 11, tables 0, padding 0)
# sha256:       d29423b82cebf94f8ad0054784b70b754b9d88299dcd10798a6a1baa213fbe3c
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528f18
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051a2ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051a2ed, .text + (0x0051a2ed - 0x401000)

.org 0x00528f18 - 0x401000
.globl FUN_00528f18
FUN_00528f18:
    # block 0x00528f18: entry, 3 instruction(s), ends with backward jump to 0x0051a2ed
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528f18
    add ecx, 0x6c                                # 00528f1b
    jmp.d32 FUN_0051a2ed                         # 00528f1e

