# FUN_00529148
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529148
# extent:       0x00529148-0x00529150 (8 code bytes)
# span:         0x00529148-0x00529150 (code 8, tables 0, padding 0)
# sha256:       9caf7835ad789343a1056b3f9d08fe46607db23631b54a3ad4ae41cbeb0ae6a6
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529148
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_004caec0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00529150
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004caec0, .text + (0x004caec0 - 0x401000)

.org 0x00529148 - 0x401000
.globl FUN_00529148
FUN_00529148:
    # block 0x00529148: entry, 2 instruction(s), ends with backward jump to 0x004caec0
    mov ecx, dword ptr [ebp - field_minus_10]    # 00529148
    jmp.d32 FUN_004caec0                         # 0052914b

