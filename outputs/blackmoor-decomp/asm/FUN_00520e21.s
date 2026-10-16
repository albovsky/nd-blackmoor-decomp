# FUN_00520e21
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520e21
# extent:       0x00520e21-0x00520e6d (76 code bytes)
# span:         0x00520e21-0x00520e6d (code 76, tables 0, padding 0)
# sha256:       b7eaa4463602eae839cbb44d214ac50b4ce8838dd074a479c62c41500d737c2f
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520e21
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

.org 0x00520e21 - 0x401000
.globl FUN_00520e21
FUN_00520e21:
    # block 0x00520e21: entry, 11 instruction(s), ends with je to 0x00520e45 (forward)
    push ebp                                     # 00520e21
    {load} mov ebp, esp                          # 00520e22
    push ecx                                     # 00520e24
    push ecx                                     # 00520e25
    push esi                                     # 00520e26
    {load} mov esi, ecx                          # 00520e27
    push edi                                     # 00520e29
    mov edi, dword ptr [0x52a088]                # 00520e2a
    mov eax, dword ptr [esi + field_4]           # 00520e30
    cmp eax, dword ptr [esi + field_8]           # 00520e33
    je.d8 L_00520e45                             # 00520e36
    # block 0x00520e38: entered by fall-through of je at 0x00520e36, 6 instruction(s), calls indirect edi, falls into the block at 0x00520e45
    lea ecx, [ebp - local_8]                     # 00520e38
    push ecx                                     # 00520e3b
    push dword ptr [ebp + arg_10]                # 00520e3c
    push dword ptr [ebp + arg_c]                 # 00520e3f
    push eax                                     # 00520e42
    call edi                                     # 00520e43
L_00520e45:
    # block 0x00520e45: entered by je at 0x00520e36, 3 instruction(s), ends with je to 0x00520e59 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520e45
    test esi, esi                                # 00520e48
    je.d8 L_00520e59                             # 00520e4a
    # block 0x00520e4c: entered by fall-through of je at 0x00520e4a, 6 instruction(s), calls indirect edi, falls into the block at 0x00520e59
    lea eax, [ebp - local_8]                     # 00520e4c
    push eax                                     # 00520e4f
    push dword ptr [ebp + arg_10]                # 00520e50
    push dword ptr [ebp + arg_c]                 # 00520e53
    push esi                                     # 00520e56
    call edi                                     # 00520e57
L_00520e59:
    # block 0x00520e59: entered by je at 0x00520e4a, 9 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp + arg_8]             # 00520e59
    mov ecx, dword ptr [ebp - local_8]           # 00520e5c
    pop edi                                      # 00520e5f
    pop esi                                      # 00520e60
    mov dword ptr [eax], ecx                     # 00520e61
    mov ecx, dword ptr [ebp - local_4]           # 00520e63
    mov dword ptr [eax + field_4], ecx           # 00520e66
    leave                                        # 00520e69
    ret 0xc                                      # 00520e6a

