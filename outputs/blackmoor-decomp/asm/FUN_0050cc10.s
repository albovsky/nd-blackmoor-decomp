# FUN_0050cc10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cc10
# extent:       0x0050cc10-0x0050cc28 (24 code bytes)
# span:         0x0050cc10-0x0050cc28 (code 24, tables 0, padding 0)
# sha256:       2c7fc6efbbb1db82eb61aeff1e738b410fed12f9b658526a8357e8fde26cce90
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cc10
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_minus_1c
# callees:      calls FUN_0050cc28
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cc28, .text + (0x0050cc28 - 0x401000)

.org 0x0050cc10 - 0x401000
.globl FUN_0050cc10
FUN_0050cc10:
    # block 0x0050cc10: entry, 2 instruction(s), ends with jne to 0x0050cc27 (forward)
    cmp dword ptr [ebp - field_minus_1c], 0x0    # 0050cc10
    jne.d8 L_0050cc27                            # 0050cc14
    # block 0x0050cc16: entered by fall-through of jne at 0x0050cc14, 5 instruction(s), calls FUN_0050cc28, falls into the block at 0x0050cc27
    push dword ptr [ebp + field_14]              # 0050cc16
    push dword ptr [ebp + field_10]              # 0050cc19
    push dword ptr [ebp + field_c]               # 0050cc1c
    push dword ptr [ebp + field_8]               # 0050cc1f
    call FUN_0050cc28                            # 0050cc22
L_0050cc27:
    # block 0x0050cc27: entered by jne at 0x0050cc14, 1 instruction(s), ends with ret
    ret                                          # 0050cc27

