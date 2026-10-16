# FUN_00520d7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520d7d
# extent:       0x00520d7d-0x00520dc9 (76 code bytes)
# span:         0x00520d7d-0x00520dc9 (code 76, tables 0, padding 0)
# sha256:       7e868c1f7ba965be0a484e4363b850782b7604edad98ca9f856259e6c168e0c8
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520d7d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [esi + n] field_4, field_8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x00520d7d - 0x401000
.globl FUN_00520d7d
FUN_00520d7d:
    # block 0x00520d7d: entry, 11 instruction(s), ends with je to 0x00520da1 (forward)
    push ebp                                     # 00520d7d
    {load} mov ebp, esp                          # 00520d7e
    push ecx                                     # 00520d80
    push ecx                                     # 00520d81
    push esi                                     # 00520d82
    {load} mov esi, ecx                          # 00520d83
    push edi                                     # 00520d85
    mov edi, dword ptr [0x52a080]                # 00520d86
    mov eax, dword ptr [esi + field_4]           # 00520d8c
    cmp eax, dword ptr [esi + field_8]           # 00520d8f
    je.d8 L_00520da1                             # 00520d92
    # block 0x00520d94: entered by fall-through of je at 0x00520d92, 6 instruction(s), calls indirect edi, falls into the block at 0x00520da1
    lea ecx, [ebp - local_8]                     # 00520d94
    push ecx                                     # 00520d97
    push dword ptr [ebp + arg_10]                # 00520d98
    push dword ptr [ebp + arg_c]                 # 00520d9b
    push eax                                     # 00520d9e
    call edi                                     # 00520d9f
L_00520da1:
    # block 0x00520da1: entered by je at 0x00520d92, 3 instruction(s), ends with je to 0x00520db5 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520da1
    test esi, esi                                # 00520da4
    je.d8 L_00520db5                             # 00520da6
    # block 0x00520da8: entered by fall-through of je at 0x00520da6, 6 instruction(s), calls indirect edi, falls into the block at 0x00520db5
    lea eax, [ebp - local_8]                     # 00520da8
    push eax                                     # 00520dab
    push dword ptr [ebp + arg_10]                # 00520dac
    push dword ptr [ebp + arg_c]                 # 00520daf
    push esi                                     # 00520db2
    call edi                                     # 00520db3
L_00520db5:
    # block 0x00520db5: entered by je at 0x00520da6, 9 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp + arg_8]             # 00520db5
    mov ecx, dword ptr [ebp - local_8]           # 00520db8
    pop edi                                      # 00520dbb
    pop esi                                      # 00520dbc
    mov dword ptr [eax], ecx                     # 00520dbd
    mov ecx, dword ptr [ebp - local_4]           # 00520dbf
    mov dword ptr [eax + field_4], ecx           # 00520dc2
    leave                                        # 00520dc5
    ret 0xc                                      # 00520dc6

