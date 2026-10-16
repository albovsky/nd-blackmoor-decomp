# FUN_00520dc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520dc9
# extent:       0x00520dc9-0x00520e21 (88 code bytes)
# span:         0x00520dc9-0x00520e21 (code 88, tables 0, padding 0)
# sha256:       56b281007de8307655e01a0c7c7ab32b1a747188571ce1ff13b879410938539a
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520dc9
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [esi + n] field_4, field_8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x00520dc9 - 0x401000
.globl FUN_00520dc9
FUN_00520dc9:
    # block 0x00520dc9: entry, 11 instruction(s), ends with je to 0x00520df3 (forward)
    push ebp                                     # 00520dc9
    {load} mov ebp, esp                          # 00520dca
    push ecx                                     # 00520dcc
    push ecx                                     # 00520dcd
    push esi                                     # 00520dce
    {load} mov esi, ecx                          # 00520dcf
    push edi                                     # 00520dd1
    mov edi, dword ptr [0x52a084]                # 00520dd2
    mov eax, dword ptr [esi + field_4]           # 00520dd8
    cmp eax, dword ptr [esi + field_8]           # 00520ddb
    je.d8 L_00520df3                             # 00520dde
    # block 0x00520de0: entered by fall-through of je at 0x00520dde, 8 instruction(s), calls indirect edi, falls into the block at 0x00520df3
    lea ecx, [ebp - local_8]                     # 00520de0
    push ecx                                     # 00520de3
    push dword ptr [ebp + arg_18]                # 00520de4
    push dword ptr [ebp + arg_14]                # 00520de7
    push dword ptr [ebp + arg_10]                # 00520dea
    push dword ptr [ebp + arg_c]                 # 00520ded
    push eax                                     # 00520df0
    call edi                                     # 00520df1
L_00520df3:
    # block 0x00520df3: entered by je at 0x00520dde, 3 instruction(s), ends with je to 0x00520e0d (forward)
    mov esi, dword ptr [esi + field_8]           # 00520df3
    test esi, esi                                # 00520df6
    je.d8 L_00520e0d                             # 00520df8
    # block 0x00520dfa: entered by fall-through of je at 0x00520df8, 8 instruction(s), calls indirect edi, falls into the block at 0x00520e0d
    lea eax, [ebp - local_8]                     # 00520dfa
    push eax                                     # 00520dfd
    push dword ptr [ebp + arg_18]                # 00520dfe
    push dword ptr [ebp + arg_14]                # 00520e01
    push dword ptr [ebp + arg_10]                # 00520e04
    push dword ptr [ebp + arg_c]                 # 00520e07
    push esi                                     # 00520e0a
    call edi                                     # 00520e0b
L_00520e0d:
    # block 0x00520e0d: entered by je at 0x00520df8, 9 instruction(s), ends with ret 0x14
    mov eax, dword ptr [ebp + arg_8]             # 00520e0d
    mov ecx, dword ptr [ebp - local_8]           # 00520e10
    pop edi                                      # 00520e13
    pop esi                                      # 00520e14
    mov dword ptr [eax], ecx                     # 00520e15
    mov ecx, dword ptr [ebp - local_4]           # 00520e17
    mov dword ptr [eax + field_4], ecx           # 00520e1a
    leave                                        # 00520e1d
    ret 0x14                                     # 00520e1e

