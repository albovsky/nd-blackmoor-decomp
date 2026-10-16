# FUN_00521a86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521a86
# extent:       0x00521a86-0x00521b0d (135 code bytes)
# span:         0x00521a86-0x00521b0d (code 135, tables 0, padding 0)
# sha256:       e60caf09942f583bd2fead0684cd8e4052f7330b3c9d1f0b10d97e11051a9a8e
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521a86
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1038; [edi + n] field_44; [esi + n] field_4, field_8, field_c
# callees:      calls KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, KERNEL32.dll!LockResource, FUN_00525371, FUN_00521a56, FUN_00521972, KERNEL32.dll!GlobalFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00521b0d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_44, 0x44  # offset +0x44
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_00521972, .text + (0x00521972 - 0x401000)
.set FUN_00521a56, .text + (0x00521a56 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00521a86 - 0x401000
.globl FUN_00521a86
FUN_00521a86:
    # block 0x00521a86: entry, 9 instruction(s), ends with je to 0x00521a9c (forward)
    push ebp                                     # 00521a86
    {load} mov ebp, esp                          # 00521a87
    push ebx                                     # 00521a89
    push esi                                     # 00521a8a
    mov esi, dword ptr [ebp + arg_8]             # 00521a8b
    push edi                                     # 00521a8e
    {load} mov edi, ecx                          # 00521a8f
    test byte ptr [esi + field_4], 0x1           # 00521a91
    je.d8 L_00521a9c                             # 00521a95
    # block 0x00521a97: entered by fall-through of je at 0x00521a95, 2 instruction(s), ends with forward jump to 0x00521abd
    mov ebx, dword ptr [esi + field_c]           # 00521a97
    jmp.d8 L_00521abd                            # 00521a9a
L_00521a9c:
    # block 0x00521a9c: entered by je at 0x00521a95, 10 instruction(s), calls KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, KERNEL32.dll!LockResource, falls into the block at 0x00521abd
    push 0x5                                     # 00521a9c
    push dword ptr [esi + field_c]               # 00521a9e
    push dword ptr [esi + field_8]               # 00521aa1
    call dword ptr [0x52a218]                    # 00521aa4
    push eax                                     # 00521aaa
    push dword ptr [esi + field_8]               # 00521aab
    call dword ptr [0x52a21c]                    # 00521aae
    push eax                                     # 00521ab4
    call dword ptr [0x52a220]                    # 00521ab5
    {load} mov ebx, eax                          # 00521abb
L_00521abd:
    # block 0x00521abd: entered by jmp at 0x00521a9a, 3 instruction(s), calls FUN_00525371, ends with je to 0x00521ad5 (forward)
    call FUN_00525371                            # 00521abd
    cmp dword ptr [eax + field_1038], 0x0        # 00521ac2
    je.d8 L_00521ad5                             # 00521ac9
    # block 0x00521acb: entered by fall-through of je at 0x00521ac9, 4 instruction(s), calls FUN_00521a56, falls into the block at 0x00521ad5
    push ebx                                     # 00521acb
    {load} mov ecx, edi                          # 00521acc
    call FUN_00521a56                            # 00521ace
    {load} mov ebx, eax                          # 00521ad3
L_00521ad5:
    # block 0x00521ad5: entered by je at 0x00521ac9, 7 instruction(s), calls FUN_00521972, ends with je to 0x00521af3 (forward)
    push dword ptr [ebp + arg_c]                 # 00521ad5
    push ebx                                     # 00521ad8
    call FUN_00521972                            # 00521ad9
    mov dword ptr [ebp + arg_8], eax             # 00521ade
    mov eax, dword ptr [edi + field_44]          # 00521ae1
    test eax, eax                                # 00521ae4
    je.d8 L_00521af3                             # 00521ae6
    # block 0x00521ae8: entered by fall-through of je at 0x00521ae6, 3 instruction(s), calls KERNEL32.dll!GlobalFree, falls into the block at 0x00521af3
    push eax                                     # 00521ae8
    call dword ptr [0x52a20c]                    # 00521ae9
    and dword ptr [edi + field_44], 0x0          # 00521aef
L_00521af3:
    # block 0x00521af3: entered by je at 0x00521ae6, 3 instruction(s), ends with je to 0x00521aff (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00521af3
    test eax, eax                                # 00521af6
    je.d8 L_00521aff                             # 00521af8
    # block 0x00521afa: entered by fall-through of je at 0x00521af8, 2 instruction(s), falls into the block at 0x00521aff
    {load} mov ebx, eax                          # 00521afa
    mov dword ptr [edi + field_44], eax          # 00521afc
L_00521aff:
    # block 0x00521aff: entered by je at 0x00521af8, 7 instruction(s), ends with ret 0x8
    or dword ptr [esi + field_4], 0x1            # 00521aff
    mov dword ptr [esi + field_c], ebx           # 00521b03
    pop edi                                      # 00521b06
    pop esi                                      # 00521b07
    pop ebx                                      # 00521b08
    pop ebp                                      # 00521b09
    ret 0x8                                      # 00521b0a

