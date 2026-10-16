# FUN_00520e6d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520e6d
# extent:       0x00520e6d-0x00520ec5 (88 code bytes)
# span:         0x00520e6d-0x00520ec5 (code 88, tables 0, padding 0)
# sha256:       1bce6707d588d4d2b096d8996d0ea4136b7720665556a99df6db541256ae17ff
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520e6d
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [esi + n] field_4, field_8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00520ec5
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

.org 0x00520e6d - 0x401000
.globl FUN_00520e6d
FUN_00520e6d:
    # block 0x00520e6d: entry, 11 instruction(s), ends with je to 0x00520e97 (forward)
    push ebp                                     # 00520e6d
    {load} mov ebp, esp                          # 00520e6e
    push ecx                                     # 00520e70
    push ecx                                     # 00520e71
    push esi                                     # 00520e72
    {load} mov esi, ecx                          # 00520e73
    push edi                                     # 00520e75
    mov edi, dword ptr [0x52a08c]                # 00520e76
    mov eax, dword ptr [esi + field_4]           # 00520e7c
    cmp eax, dword ptr [esi + field_8]           # 00520e7f
    je.d8 L_00520e97                             # 00520e82
    # block 0x00520e84: entered by fall-through of je at 0x00520e82, 8 instruction(s), calls indirect edi, falls into the block at 0x00520e97
    lea ecx, [ebp - local_8]                     # 00520e84
    push ecx                                     # 00520e87
    push dword ptr [ebp + arg_18]                # 00520e88
    push dword ptr [ebp + arg_14]                # 00520e8b
    push dword ptr [ebp + arg_10]                # 00520e8e
    push dword ptr [ebp + arg_c]                 # 00520e91
    push eax                                     # 00520e94
    call edi                                     # 00520e95
L_00520e97:
    # block 0x00520e97: entered by je at 0x00520e82, 3 instruction(s), ends with je to 0x00520eb1 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520e97
    test esi, esi                                # 00520e9a
    je.d8 L_00520eb1                             # 00520e9c
    # block 0x00520e9e: entered by fall-through of je at 0x00520e9c, 8 instruction(s), calls indirect edi, falls into the block at 0x00520eb1
    lea eax, [ebp - local_8]                     # 00520e9e
    push eax                                     # 00520ea1
    push dword ptr [ebp + arg_18]                # 00520ea2
    push dword ptr [ebp + arg_14]                # 00520ea5
    push dword ptr [ebp + arg_10]                # 00520ea8
    push dword ptr [ebp + arg_c]                 # 00520eab
    push esi                                     # 00520eae
    call edi                                     # 00520eaf
L_00520eb1:
    # block 0x00520eb1: entered by je at 0x00520e9c, 9 instruction(s), ends with ret 0x14
    mov eax, dword ptr [ebp + arg_8]             # 00520eb1
    mov ecx, dword ptr [ebp - local_8]           # 00520eb4
    pop edi                                      # 00520eb7
    pop esi                                      # 00520eb8
    mov dword ptr [eax], ecx                     # 00520eb9
    mov ecx, dword ptr [ebp - local_4]           # 00520ebb
    mov dword ptr [eax + field_4], ecx           # 00520ebe
    leave                                        # 00520ec1
    ret 0x14                                     # 00520ec2

