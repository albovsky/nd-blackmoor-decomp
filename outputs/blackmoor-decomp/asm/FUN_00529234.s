# FUN_00529234
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529234
# extent:       0x00529234-0x0052923c (8 code bytes)
# span:         0x00529234-0x0052923c (code 8, tables 0, padding 0)
# sha256:       a65a7c4599dfe32572d72be5c3623add7befd2b45e8ce597b47637b1b0d15fd3
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00529234
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_004caec0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052923c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004caec0, .text + (0x004caec0 - 0x401000)

.org 0x00529234 - 0x401000
.globl FUN_00529234
FUN_00529234:
    # block 0x00529234: entry, 2 instruction(s), ends with backward jump to 0x004caec0
    mov ecx, dword ptr [ebp - field_minus_10]    # 00529234
    jmp.d32 FUN_004caec0                         # 00529237

