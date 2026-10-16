# FUN_00520ce5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ce5
# extent:       0x00520ce5-0x00520d31 (76 code bytes)
# span:         0x00520ce5-0x00520d31 (code 76, tables 0, padding 0)
# sha256:       ec179be7b0f9859d402e03af2b3f5ba5660d476d83d1e7ae1a33f0782c2ab431
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ce5
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

.org 0x00520ce5 - 0x401000
.globl FUN_00520ce5
FUN_00520ce5:
    # block 0x00520ce5: entry, 11 instruction(s), ends with je to 0x00520d09 (forward)
    push ebp                                     # 00520ce5
    {load} mov ebp, esp                          # 00520ce6
    push ecx                                     # 00520ce8
    push ecx                                     # 00520ce9
    push esi                                     # 00520cea
    {load} mov esi, ecx                          # 00520ceb
    push edi                                     # 00520ced
    mov edi, dword ptr [0x52a078]                # 00520cee
    mov eax, dword ptr [esi + field_4]           # 00520cf4
    cmp eax, dword ptr [esi + field_8]           # 00520cf7
    je.d8 L_00520d09                             # 00520cfa
    # block 0x00520cfc: entered by fall-through of je at 0x00520cfa, 6 instruction(s), calls indirect edi, falls into the block at 0x00520d09
    lea ecx, [ebp - local_8]                     # 00520cfc
    push ecx                                     # 00520cff
    push dword ptr [ebp + arg_10]                # 00520d00
    push dword ptr [ebp + arg_c]                 # 00520d03
    push eax                                     # 00520d06
    call edi                                     # 00520d07
L_00520d09:
    # block 0x00520d09: entered by je at 0x00520cfa, 3 instruction(s), ends with je to 0x00520d1d (forward)
    mov esi, dword ptr [esi + field_8]           # 00520d09
    test esi, esi                                # 00520d0c
    je.d8 L_00520d1d                             # 00520d0e
    # block 0x00520d10: entered by fall-through of je at 0x00520d0e, 6 instruction(s), calls indirect edi, falls into the block at 0x00520d1d
    lea eax, [ebp - local_8]                     # 00520d10
    push eax                                     # 00520d13
    push dword ptr [ebp + arg_10]                # 00520d14
    push dword ptr [ebp + arg_c]                 # 00520d17
    push esi                                     # 00520d1a
    call edi                                     # 00520d1b
L_00520d1d:
    # block 0x00520d1d: entered by je at 0x00520d0e, 9 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp + arg_8]             # 00520d1d
    mov ecx, dword ptr [ebp - local_8]           # 00520d20
    pop edi                                      # 00520d23
    pop esi                                      # 00520d24
    mov dword ptr [eax], ecx                     # 00520d25
    mov ecx, dword ptr [ebp - local_4]           # 00520d27
    mov dword ptr [eax + field_4], ecx           # 00520d2a
    leave                                        # 00520d2d
    ret 0xc                                      # 00520d2e

