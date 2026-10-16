# FUN_00529248
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529248
# extent:       0x00529248-0x00529250 (8 code bytes)
# span:         0x00529248-0x00529250 (code 8, tables 0, padding 0)
# sha256:       bd3e516b649163540cfc34dc9c28faf0e64c7c5e6e64d279ffd551002e09878b
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529248
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00529250
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00529248 - 0x401000
.globl FUN_00529248
FUN_00529248:
    # block 0x00529248: entry, 2 instruction(s), ends with backward jump to 0x0051e7ba
    lea ecx, [ebp + field_8]                     # 00529248
    jmp.d32 FUN_0051e7ba                         # 0052924b

