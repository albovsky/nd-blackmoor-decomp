# FUN_004ccef1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccef1
# extent:       0x004ccef1-0x004ccfbd (204 code bytes)
# span:         0x004ccef1-0x004ccfbd (code 204, tables 0, padding 0)
# sha256:       de58e87a8abad8aaadf9480d8e594a0b88fdf356732b5c869f022986f9aece38
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccef1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1d6; [ecx + n] field_1d6; [edx + n] field_4
# callees:      calls FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_00415011, FUN_0041632b, FUN_004bedfa; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_restart (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 59 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_1d6, 0x1d6  # offset +0x1d6

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0041632b, .text + (0x0041632b - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)

.org 0x004ccef1 - 0x401000
.globl FUN_004ccef1
FUN_004ccef1:
    # block 0x004ccef1: entry, 7 instruction(s), ends with je to 0x004ccf83 (forward)
    push ebp                                     # 004ccef1
    {load} mov ebp, esp                          # 004ccef2
    sub esp, 0x10                                # 004ccef4
    mov dword ptr [ebp - local_c], ecx           # 004ccef7
    mov eax, dword ptr [ebp - local_c]           # 004ccefa
    cmp dword ptr [eax + field_1d6], 0x0         # 004ccefd
    je.d8 L_004ccf83                             # 004ccf04
    # block 0x004ccf06: entered by fall-through of je at 0x004ccf04, 17 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x004ccf56 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004ccf06
    add ecx, 0x4                                 # 004ccf09
    push ecx                                     # 004ccf0c
    call FUN_0044c479                            # 004ccf0d
    add esp, 0x4                                 # 004ccf12
    mov edx, dword ptr [ebp - local_c]           # 004ccf15
    mov dword ptr [edx + field_4], 0x2           # 004ccf18
    mov eax, dword ptr [ebp - local_c]           # 004ccf1f
    mov ecx, dword ptr [eax + field_1d6]         # 004ccf22
    call FUN_00449a94                            # 004ccf28
    mov ecx, dword ptr [ebp - local_c]           # 004ccf2d
    mov edx, dword ptr [ecx + field_1d6]         # 004ccf30
    mov dword ptr [ebp - local_8], edx           # 004ccf36
    mov eax, dword ptr [ebp - local_8]           # 004ccf39
    mov dword ptr [ebp - local_4], eax           # 004ccf3c
    cmp dword ptr [ebp - local_4], 0x0           # 004ccf3f
    je.d8 L_004ccf56                             # 004ccf43
    # block 0x004ccf45: entered by fall-through of je at 0x004ccf43, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x004ccf5d
    push 0x1                                     # 004ccf45
    mov ecx, dword ptr [ebp - local_4]           # 004ccf47
    mov edx, dword ptr [ecx]                     # 004ccf4a
    mov ecx, dword ptr [ebp - local_4]           # 004ccf4c
    call dword ptr [edx]                         # 004ccf4f
    mov dword ptr [ebp - local_10], eax          # 004ccf51
    jmp.d8 L_004ccf5d                            # 004ccf54
L_004ccf56:
    # block 0x004ccf56: entered by je at 0x004ccf43, 1 instruction(s), falls into the block at 0x004ccf5d
    mov dword ptr [ebp - local_10], 0x0          # 004ccf56
L_004ccf5d:
    # block 0x004ccf5d: entered by jmp at 0x004ccf54, 9 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004ccf83
    mov eax, dword ptr [ebp - local_c]           # 004ccf5d
    mov dword ptr [eax + field_1d6], 0x0         # 004ccf60
    mov ecx, dword ptr [ebp - local_c]           # 004ccf6a
    add ecx, 0x4                                 # 004ccf6d
    push ecx                                     # 004ccf70
    call FUN_0044c4ab                            # 004ccf71
    add esp, 0x4                                 # 004ccf76
    mov edx, dword ptr [ebp - local_c]           # 004ccf79
    mov dword ptr [edx + field_4], 0x0           # 004ccf7c
L_004ccf83:
    # block 0x004ccf83: entered by je at 0x004ccf04, 18 instruction(s), calls FUN_00415011, FUN_0041632b, FUN_004bedfa, ends with ret
    mov eax, dword ptr [ebp - local_c]           # 004ccf83
    add eax, 0x8                                 # 004ccf86
    push eax                                     # 004ccf89
    mov ecx, 0x5e2dbe                            # 004ccf8a
    call FUN_00415011                            # 004ccf8f
    mov ecx, dword ptr [ebp - local_c]           # 004ccf94
    add ecx, 0x8                                 # 004ccf97
    push ecx                                     # 004ccf9a
    mov ecx, 0x5e2dbe                            # 004ccf9b
    call FUN_0041632b                            # 004ccfa0
    mov edx, dword ptr [ebp - local_c]           # 004ccfa5
    add edx, 0x18e                               # 004ccfa8
    push edx                                     # 004ccfae
    mov ecx, 0x6201f9                            # 004ccfaf
    call FUN_004bedfa                            # 004ccfb4
    {load} mov esp, ebp                          # 004ccfb9
    pop ebp                                      # 004ccfbb
    ret                                          # 004ccfbc

