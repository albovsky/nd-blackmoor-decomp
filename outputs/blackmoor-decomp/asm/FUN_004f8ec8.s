# FUN_004f8ec8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8ec8
# extent:       0x004f8ec8-0x004f8f94 (204 code bytes)
# span:         0x004f8ec8-0x004f8f94 (code 204, tables 0, padding 0)
# sha256:       e4e031a26039d5d016ac34983539c98ce6e912ea14f8c63ab7761c50cd08019e
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8ec8
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_29b, field_2ab, field_3ca, field_3d2; [ecx + n] field_4, field_8, field_29b, field_2a3, field_3ca, field_3ce; [edx + n] field_4, field_8, field_4c, field_29b, field_2a7, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_4c, 0x4c  # offset +0x4c
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------

.org 0x004f8ec8 - 0x401000
.globl FUN_004f8ec8
FUN_004f8ec8:
    # block 0x004f8ec8: entry, 15 instruction(s), ends with je to 0x004f8f8c (forward)
    push ebp                                     # 004f8ec8
    {load} mov ebp, esp                          # 004f8ec9
    sub esp, 0x8                                 # 004f8ecb
    mov dword ptr [ebp - local_8], ecx           # 004f8ece
    mov eax, dword ptr [ebp + arg_8]             # 004f8ed1
    imul eax, eax, 0x5bb                         # 004f8ed4
    mov ecx, dword ptr [ebp - local_8]           # 004f8eda
    mov edx, dword ptr [ecx + field_3ce]         # 004f8edd
    {load} add edx, eax                          # 004f8ee3
    mov dword ptr [ebp - local_4], edx           # 004f8ee5
    mov eax, dword ptr [ebp - local_8]           # 004f8ee8
    mov dword ptr [eax + field_3ca], 0x0         # 004f8eeb
    mov ecx, dword ptr [ebp - local_4]           # 004f8ef5
    cmp dword ptr [ecx + field_29b], 0x0         # 004f8ef8
    je.d32 L_004f8f8c                            # 004f8eff
    # block 0x004f8f05: entered by fall-through of je at 0x004f8eff, 3 instruction(s), ends with je to 0x004f8f18 (forward)
    {load} xor edx, edx                          # 004f8f05
    test edx, edx                                # 004f8f07
    je.d8 L_004f8f18                             # 004f8f09
    # block 0x004f8f0b: entered by fall-through of je at 0x004f8f09, 2 instruction(s), falls into the block at 0x004f8f18
    mov eax, dword ptr [ebp - local_8]           # 004f8f0b
    mov dword ptr [eax + field_3d2], 0x1         # 004f8f0e
L_004f8f18:
    # block 0x004f8f18: entered by je at 0x004f8f09, 31 instruction(s), calls indirect dword ptr [edx + 0x4c], ends with jne to 0x004f8f88 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8f18
    add ecx, 0x2a3                               # 004f8f1b
    mov edx, dword ptr [ebp + arg_c]             # 004f8f21
    mov eax, dword ptr [edx]                     # 004f8f24
    mov dword ptr [ecx], eax                     # 004f8f26
    mov eax, dword ptr [edx + field_4]           # 004f8f28
    mov dword ptr [ecx + field_4], eax           # 004f8f2b
    mov edx, dword ptr [edx + field_8]           # 004f8f2e
    mov dword ptr [ecx + field_8], edx           # 004f8f31
    push 0x0                                     # 004f8f34
    mov eax, dword ptr [ebp - local_4]           # 004f8f36
    mov ecx, dword ptr [eax + field_2ab]         # 004f8f39
    push ecx                                     # 004f8f3f
    mov edx, dword ptr [ebp - local_4]           # 004f8f40
    mov eax, dword ptr [edx + field_2a7]         # 004f8f43
    push eax                                     # 004f8f49
    mov ecx, dword ptr [ebp - local_4]           # 004f8f4a
    mov edx, dword ptr [ecx + field_2a3]         # 004f8f4d
    push edx                                     # 004f8f53
    mov eax, dword ptr [ebp - local_4]           # 004f8f54
    mov ecx, dword ptr [eax + field_29b]         # 004f8f57
    mov edx, dword ptr [ebp - local_4]           # 004f8f5d
    mov eax, dword ptr [edx + field_29b]         # 004f8f60
    mov edx, dword ptr [eax]                     # 004f8f66
    push ecx                                     # 004f8f68
    call dword ptr [edx + field_4c]              # 004f8f69
    mov ecx, dword ptr [ebp - local_8]           # 004f8f6c
    mov dword ptr [ecx + field_3ca], eax         # 004f8f6f
    mov edx, dword ptr [ebp - local_8]           # 004f8f75
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8f78
    jne.d8 L_004f8f88                            # 004f8f7f
    # block 0x004f8f81: entered by fall-through of jne at 0x004f8f7f, 2 instruction(s), ends with forward jump to 0x004f8f8e
    mov eax, 0x1                                 # 004f8f81
    jmp.d8 L_004f8f8e                            # 004f8f86
L_004f8f88:
    # block 0x004f8f88: entered by jne at 0x004f8f7f, 2 instruction(s), ends with forward jump to 0x004f8f8e
    {load} xor eax, eax                          # 004f8f88
    jmp.d8 L_004f8f8e                            # 004f8f8a
L_004f8f8c:
    # block 0x004f8f8c: entered by je at 0x004f8eff, 1 instruction(s), falls into the block at 0x004f8f8e
    {load} xor eax, eax                          # 004f8f8c
L_004f8f8e:
    # block 0x004f8f8e: entered by jmp at 0x004f8f86; jmp at 0x004f8f8a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f8f8e
    pop ebp                                      # 004f8f90
    ret 0x8                                      # 004f8f91

