# FUN_00529220
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529220
# extent:       0x00529220-0x00529228 (8 code bytes)
# span:         0x00529220-0x00529228 (code 8, tables 0, padding 0)
# sha256:       df22374b0b38e07ed826c42ca8d77ffab9967fea3ae4ef2bc25cf47f642ffe8f
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529220
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00529228
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00529220 - 0x401000
.globl FUN_00529220
FUN_00529220:
    # block 0x00529220: entry, 2 instruction(s), ends with backward jump to 0x0051e7ba
    lea ecx, [ebp - field_minus_18]              # 00529220
    jmp.d32 FUN_0051e7ba                         # 00529223

