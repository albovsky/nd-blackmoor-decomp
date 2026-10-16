# FUN_0050cb90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cb90
# extent:       0x0050cb90-0x0050cba8 (24 code bytes)
# span:         0x0050cb90-0x0050cba8 (code 24, tables 0, padding 0)
# sha256:       3f6add3a0b9e7cae0d44ae4404274273921e43355dbfca561cc807194b6fba45
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cb90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_18, field_minus_1c, field_minus_20
# callees:      calls FUN_0050cc28
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050cc28, .text + (0x0050cc28 - 0x401000)

.org 0x0050cb90 - 0x401000
.globl FUN_0050cb90
FUN_0050cb90:
    # block 0x0050cb90: entry, 2 instruction(s), ends with jne to 0x0050cba7 (forward)
    cmp dword ptr [ebp - field_minus_20], 0x0    # 0050cb90
    jne.d8 L_0050cba7                            # 0050cb94
    # block 0x0050cb96: entered by fall-through of jne at 0x0050cb94, 5 instruction(s), calls FUN_0050cc28, falls into the block at 0x0050cba7
    push dword ptr [ebp + field_18]              # 0050cb96
    push dword ptr [ebp - field_minus_1c]        # 0050cb99
    push dword ptr [ebp + field_c]               # 0050cb9c
    push dword ptr [ebp + field_8]               # 0050cb9f
    call FUN_0050cc28                            # 0050cba2
L_0050cba7:
    # block 0x0050cba7: entered by jne at 0x0050cb94, 1 instruction(s), ends with ret
    ret                                          # 0050cba7

