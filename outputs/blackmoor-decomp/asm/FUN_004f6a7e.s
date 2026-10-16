# FUN_004f6a7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6a7e
# extent:       0x004f6a7e-0x004f6b74 (246 code bytes)
# span:         0x004f6a7e-0x004f6b74 (code 246, tables 0, padding 0)
# sha256:       698ec0c10daf3f60520e66175614f188fa220555570e8bce19de9524796c3326
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f6a7e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_28f, field_3be, field_3c2, field_3ca, field_3ce; [ecx + n] field_20, field_28f, field_3be, field_3c2, field_3ca; [edx + n] field_162, field_28f, field_3be, field_3c2, field_3ca
# callees:      calls FUN_004f709c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_20, 0x20  # offset +0x20
.equ field_162, 0x162  # offset +0x162
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f6a7e - 0x401000
.globl FUN_004f6a7e
FUN_004f6a7e:
    # block 0x004f6a7e: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f6aec (forward)
    push ebp                                     # 004f6a7e
    {load} mov ebp, esp                          # 004f6a7f
    sub esp, 0xc                                 # 004f6a81
    mov dword ptr [ebp - local_c], ecx           # 004f6a84
    mov eax, dword ptr [ebp - local_c]           # 004f6a87
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6a8a
    mov ecx, dword ptr [ebp - local_c]           # 004f6a94
    mov dword ptr [ecx + field_3ca], 0x0         # 004f6a97
    mov edx, dword ptr [ebp + arg_8]             # 004f6aa1
    imul edx, edx, 0x5bb                         # 004f6aa4
    mov eax, dword ptr [ebp - local_c]           # 004f6aaa
    mov ecx, dword ptr [eax + field_3ce]         # 004f6aad
    {load} add ecx, edx                          # 004f6ab3
    mov dword ptr [ebp - local_8], ecx           # 004f6ab5
    mov ecx, dword ptr [ebp - local_c]           # 004f6ab8
    call FUN_004f709c                            # 004f6abb
    test eax, eax                                # 004f6ac0
    jne.d8 L_004f6aec                            # 004f6ac2
    # block 0x004f6ac4: entered by fall-through of jne at 0x004f6ac2, 7 instruction(s), ends with forward jump to 0x004f6b6e
    mov edx, dword ptr [ebp - local_c]           # 004f6ac4
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f6ac7
    mov eax, dword ptr [ebp - local_c]           # 004f6ad1
    mov dword ptr [eax + field_3be], 0x0         # 004f6ad4
    mov ecx, dword ptr [ebp - local_c]           # 004f6ade
    mov eax, dword ptr [ecx + field_3be]         # 004f6ae1
    jmp.d32 L_004f6b6e                           # 004f6ae7
L_004f6aec:
    # block 0x004f6aec: entered by jne at 0x004f6ac2, 3 instruction(s), ends with je to 0x004f6b04 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f6aec
    cmp dword ptr [edx + field_162], 0x0         # 004f6aef
    je.d8 L_004f6b04                             # 004f6af6
    # block 0x004f6af8: entered by fall-through of je at 0x004f6af6, 3 instruction(s), ends with jne to 0x004f6b29 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f6af8
    cmp dword ptr [eax + field_28f], 0x0         # 004f6afb
    jne.d8 L_004f6b29                            # 004f6b02
L_004f6b04:
    # block 0x004f6b04: entered by je at 0x004f6af6; fall-through of jne at 0x004f6b02, 7 instruction(s), ends with forward jump to 0x004f6b6e
    mov ecx, dword ptr [ebp - local_c]           # 004f6b04
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f6b07
    mov edx, dword ptr [ebp - local_c]           # 004f6b11
    mov dword ptr [edx + field_3be], 0x0         # 004f6b14
    mov eax, dword ptr [ebp - local_c]           # 004f6b1e
    mov eax, dword ptr [eax + field_3be]         # 004f6b21
    jmp.d8 L_004f6b6e                            # 004f6b27
L_004f6b29:
    # block 0x004f6b29: entered by jne at 0x004f6b02, 14 instruction(s), calls indirect dword ptr [ecx + 0x20], ends with jne to 0x004f6b5f (forward)
    lea ecx, [ebp - local_4]                     # 004f6b29
    push ecx                                     # 004f6b2c
    mov edx, dword ptr [ebp - local_8]           # 004f6b2d
    mov eax, dword ptr [edx + field_28f]         # 004f6b30
    mov ecx, dword ptr [ebp - local_8]           # 004f6b36
    mov edx, dword ptr [ecx + field_28f]         # 004f6b39
    mov ecx, dword ptr [edx]                     # 004f6b3f
    push eax                                     # 004f6b41
    call dword ptr [ecx + field_20]              # 004f6b42
    mov edx, dword ptr [ebp - local_c]           # 004f6b45
    mov dword ptr [edx + field_3ca], eax         # 004f6b48
    mov eax, dword ptr [ebp - local_c]           # 004f6b4e
    cmp dword ptr [eax + field_3ca], 0x0         # 004f6b51
    jne.d8 L_004f6b5f                            # 004f6b58
    # block 0x004f6b5a: entered by fall-through of jne at 0x004f6b58, 2 instruction(s), ends with forward jump to 0x004f6b6e
    mov eax, dword ptr [ebp - local_4]           # 004f6b5a
    jmp.d8 L_004f6b6e                            # 004f6b5d
L_004f6b5f:
    # block 0x004f6b5f: entered by jne at 0x004f6b58, 3 instruction(s), falls into the block at 0x004f6b6e
    mov ecx, dword ptr [ebp - local_c]           # 004f6b5f
    mov dword ptr [ecx + field_3c2], 0x40e       # 004f6b62
    {load} xor eax, eax                          # 004f6b6c
L_004f6b6e:
    # block 0x004f6b6e: entered by jmp at 0x004f6ae7; jmp at 0x004f6b27; jmp at 0x004f6b5d, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f6b6e
    pop ebp                                      # 004f6b70
    ret 0x4                                      # 004f6b71

