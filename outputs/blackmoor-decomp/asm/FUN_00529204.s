# FUN_00529204
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529204
# extent:       0x00529204-0x0052920c (8 code bytes)
# span:         0x00529204-0x0052920c (code 8, tables 0, padding 0)
# sha256:       8a858ad04976522cdbb153100f079438f16d2f009ba52e3d9d4340e29d83a009
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529204
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00529204 - 0x401000
.globl FUN_00529204
FUN_00529204:
    # block 0x00529204: entry, 2 instruction(s), ends with backward jump to 0x0051e7ba
    lea ecx, [ebp - field_minus_10]              # 00529204
    jmp.d32 FUN_0051e7ba                         # 00529207

