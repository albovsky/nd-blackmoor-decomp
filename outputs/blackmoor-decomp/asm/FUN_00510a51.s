# FUN_00510a51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510a51
# extent:       0x00510a51-0x00510a9f (78 code bytes)
# span:         0x00510a51-0x00510a9f (code 78, tables 0, padding 0)
# sha256:       ac1d2a51c209b11a33b020335e9af63d8c8591aa77431ae7b3755f9a31e7877d
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510a51
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_6c, field_70; [ebp + n] field_minus_1c, field_minus_20, field_minus_24, field_minus_28, field_minus_2c; [edi + n] field_10, field_14; [esi + n] field_minus_4
# callees:      calls FUN_00510dd3, FUN_0050c9fa, FUN_00510c8d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510a9f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28
.equ field_minus_2c, 0x2c  # offset -0x2c
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0050c9fa, .text + (0x0050c9fa - 0x401000)
.set FUN_00510c8d, .text + (0x00510c8d - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x00510a51 - 0x401000
.globl FUN_00510a51
FUN_00510a51:
    # block 0x00510a51: entry, 10 instruction(s), calls FUN_00510dd3, ends with jne to 0x00510a9e (forward)
    mov eax, dword ptr [ebp - field_minus_28]    # 00510a51
    mov dword ptr [esi - field_minus_4], eax     # 00510a54
    call FUN_00510dd3                            # 00510a57
    mov ecx, dword ptr [ebp - field_minus_1c]    # 00510a5c
    mov dword ptr [eax + field_6c], ecx          # 00510a5f
    call FUN_00510dd3                            # 00510a62
    mov ecx, dword ptr [ebp - field_minus_20]    # 00510a67
    mov dword ptr [eax + field_70], ecx          # 00510a6a
    cmp dword ptr [edi], 0xe06d7363              # 00510a6d
    jne.d8 L_00510a9e                            # 00510a73
    # block 0x00510a75: entered by fall-through of jne at 0x00510a73, 2 instruction(s), ends with jne to 0x00510a9e (forward)
    cmp dword ptr [edi + field_10], 0x3          # 00510a75
    jne.d8 L_00510a9e                            # 00510a79
    # block 0x00510a7b: entered by fall-through of jne at 0x00510a79, 2 instruction(s), ends with jne to 0x00510a9e (forward)
    cmp dword ptr [edi + field_14], 0x19930520   # 00510a7b
    jne.d8 L_00510a9e                            # 00510a82
    # block 0x00510a84: entered by fall-through of jne at 0x00510a82, 2 instruction(s), ends with jne to 0x00510a9e (forward)
    cmp dword ptr [ebp - field_minus_24], 0x0    # 00510a84
    jne.d8 L_00510a9e                            # 00510a88
    # block 0x00510a8a: entered by fall-through of jne at 0x00510a88, 2 instruction(s), ends with je to 0x00510a9e (forward)
    cmp dword ptr [ebp - field_minus_2c], 0x0    # 00510a8a
    je.d8 L_00510a9e                             # 00510a8e
    # block 0x00510a90: entered by fall-through of je at 0x00510a8e, 6 instruction(s), calls FUN_0050c9fa, FUN_00510c8d, falls into the block at 0x00510a9e
    call FUN_0050c9fa                            # 00510a90
    push eax                                     # 00510a95
    push edi                                     # 00510a96
    call FUN_00510c8d                            # 00510a97
    pop ecx                                      # 00510a9c
    pop ecx                                      # 00510a9d
L_00510a9e:
    # block 0x00510a9e: entered by jne at 0x00510a73; jne at 0x00510a79; jne at 0x00510a82; jne at 0x00510a88; more, 1 instruction(s), ends with ret
    ret                                          # 00510a9e

