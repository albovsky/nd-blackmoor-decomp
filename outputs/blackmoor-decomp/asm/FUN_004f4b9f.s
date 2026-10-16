# FUN_004f4b9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f4b9f
# extent:       0x004f4b9f-0x004f52a9 (1802 code bytes)
# span:         0x004f4b9f-0x004f52a9 (code 1802, tables 0, padding 0)
# sha256:       62b696c4ffbecc28d4a03f07df7b903607bd2933382e65940a73fb249f334f3f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f4b9f
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_15e, field_28f, field_293, field_297, field_29b, field_2a7, field_2b7, field_2d7 and 2 more; [ecx + n] field_4, field_8, field_c, field_126, field_144, field_156, field_15e, field_28f, field_293, field_297, field_29b, field_2a3 and 8 more; [edx + n] field_4, field_8, field_c, field_10, field_116, field_122, field_28f, field_297, field_29f, field_2ab, field_2af, field_3be and 2 more
# callees:      calls FUN_004f5f69, FUN_004f356e, FUN_0050ca3e, FUN_0044a2b7, FUN_004f95a4, FUN_0051dc43, FUN_004fdb90, FUN_0052139c, FUN_004f594d, FUN_004f684a; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 459 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_116, 0x116  # offset +0x116
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_144, 0x144  # offset +0x144
.equ field_156, 0x156  # offset +0x156
.equ field_15e, 0x15e  # offset +0x15e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_29b, 0x29b  # offset +0x29b
.equ field_29f, 0x29f  # offset +0x29f
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2b3, 0x2b3  # offset +0x2b3
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_2be, 0x2be  # offset +0x2be
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2db, 0x2db  # offset +0x2db
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f594d, .text + (0x004f594d - 0x401000)
.set FUN_004f5f69, .text + (0x004f5f69 - 0x401000)
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_004f95a4, .text + (0x004f95a4 - 0x401000)
.set FUN_004fdb90, .text + (0x004fdb90 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f4b9f - 0x401000
.globl FUN_004f4b9f
FUN_004f4b9f:
    # block 0x004f4b9f: entry, 42 instruction(s), ends with je to 0x004f4c7f (forward)
    push ebp                                     # 004f4b9f
    {load} mov ebp, esp                          # 004f4ba0
    sub esp, 0x10                                # 004f4ba2
    push edi                                     # 004f4ba5
    mov dword ptr [ebp - local_10], ecx          # 004f4ba6
    mov eax, dword ptr [ebp - local_10]          # 004f4ba9
    mov dword ptr [eax + field_3be], 0x1         # 004f4bac
    mov ecx, dword ptr [ebp - local_10]          # 004f4bb6
    mov dword ptr [ecx + field_3c2], 0x3e8       # 004f4bb9
    mov edx, dword ptr [ebp - local_10]          # 004f4bc3
    mov dword ptr [edx + field_3ca], 0x0         # 004f4bc6
    mov eax, dword ptr [ebp + arg_8]             # 004f4bd0
    and eax, 0xffff                              # 004f4bd3
    imul eax, eax, 0x5bb                         # 004f4bd8
    mov ecx, dword ptr [ebp - local_10]          # 004f4bde
    mov edx, dword ptr [ecx + field_3ce]         # 004f4be1
    {load} add edx, eax                          # 004f4be7
    mov dword ptr [ebp - local_8], edx           # 004f4be9
    mov eax, dword ptr [ebp - local_8]           # 004f4bec
    add eax, 0x18a                               # 004f4bef
    mov dword ptr [ebp - local_4], eax           # 004f4bf4
    mov ecx, dword ptr [ebp - local_8]           # 004f4bf7
    mov edx, dword ptr [ebp - local_8]           # 004f4bfa
    mov ax, word ptr [edx + field_116]           # 004f4bfd
    mov word ptr [ecx + field_144], ax           # 004f4c04
    mov ecx, dword ptr [ebp - local_4]           # 004f4c0b
    mov dword ptr [ecx], 0x0                     # 004f4c0e
    mov edx, dword ptr [ebp - local_4]           # 004f4c14
    mov dword ptr [edx + field_4], 0x0           # 004f4c17
    mov eax, dword ptr [ebp - local_4]           # 004f4c1e
    mov dword ptr [eax + field_8], 0x0           # 004f4c21
    mov ecx, dword ptr [ebp - local_8]           # 004f4c28
    mov edx, dword ptr [ebp - local_8]           # 004f4c2b
    mov eax, dword ptr [edx + field_122]         # 004f4c2e
    mov dword ptr [ecx + field_15e], eax         # 004f4c34
    mov ecx, dword ptr [ebp - local_4]           # 004f4c3a
    mov dword ptr [ecx + field_c], 0x0           # 004f4c3d
    mov edx, dword ptr [ebp - local_4]           # 004f4c44
    mov dword ptr [edx + field_10], 0xffffffff   # 004f4c47
    mov eax, dword ptr [ebp - local_8]           # 004f4c4e
    cmp dword ptr [eax + field_293], 0x0         # 004f4c51
    je.d8 L_004f4c7f                             # 004f4c58
    # block 0x004f4c5a: entered by fall-through of je at 0x004f4c58, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f4c7f
    mov ecx, dword ptr [ebp - local_8]           # 004f4c5a
    mov edx, dword ptr [ecx + field_293]         # 004f4c5d
    mov eax, dword ptr [ebp - local_8]           # 004f4c63
    mov ecx, dword ptr [eax + field_293]         # 004f4c66
    mov eax, dword ptr [ecx]                     # 004f4c6c
    push edx                                     # 004f4c6e
    call dword ptr [eax + field_8]               # 004f4c6f
    mov ecx, dword ptr [ebp - local_8]           # 004f4c72
    mov dword ptr [ecx + field_293], 0x0         # 004f4c75
L_004f4c7f:
    # block 0x004f4c7f: entered by je at 0x004f4c58, 48 instruction(s), calls FUN_004f5f69, ends with jne to 0x004f4d63 (forward)
    {load} xor edx, edx                          # 004f4c7f
    mov eax, dword ptr [ebp - local_10]          # 004f4c81
    add eax, 0x288                               # 004f4c84
    mov dword ptr [eax], edx                     # 004f4c89
    mov dword ptr [eax + field_4], edx           # 004f4c8b
    mov dword ptr [eax + field_8], edx           # 004f4c8e
    mov dword ptr [eax + field_c], edx           # 004f4c91
    mov word ptr [eax + field_10], dx            # 004f4c94
    mov ecx, dword ptr [ebp - local_8]           # 004f4c98
    add ecx, 0x112                               # 004f4c9b
    mov edx, dword ptr [ebp - local_10]          # 004f4ca1
    add edx, 0x288                               # 004f4ca4
    mov eax, dword ptr [ecx]                     # 004f4caa
    mov dword ptr [edx], eax                     # 004f4cac
    mov eax, dword ptr [ecx + field_4]           # 004f4cae
    mov dword ptr [edx + field_4], eax           # 004f4cb1
    mov eax, dword ptr [ecx + field_8]           # 004f4cb4
    mov dword ptr [edx + field_8], eax           # 004f4cb7
    mov ecx, dword ptr [ecx + field_c]           # 004f4cba
    mov dword ptr [edx + field_c], ecx           # 004f4cbd
    mov edx, dword ptr [ebp - local_10]          # 004f4cc0
    add edx, 0x288                               # 004f4cc3
    mov eax, dword ptr [ebp - local_8]           # 004f4cc9
    add eax, 0x2df                               # 004f4ccc
    mov ecx, dword ptr [edx]                     # 004f4cd1
    mov dword ptr [eax], ecx                     # 004f4cd3
    mov ecx, dword ptr [edx + field_4]           # 004f4cd5
    mov dword ptr [eax + field_4], ecx           # 004f4cd8
    mov ecx, dword ptr [edx + field_8]           # 004f4cdb
    mov dword ptr [eax + field_8], ecx           # 004f4cde
    mov ecx, dword ptr [edx + field_c]           # 004f4ce1
    mov dword ptr [eax + field_c], ecx           # 004f4ce4
    mov dx, word ptr [edx + field_10]            # 004f4ce7
    mov word ptr [eax + field_10], dx            # 004f4ceb
    mov eax, dword ptr [ebp - local_10]          # 004f4cef
    add eax, 0x288                               # 004f4cf2
    push eax                                     # 004f4cf7
    push 0x301b8                                 # 004f4cf8
    mov ecx, dword ptr [ebp - local_8]           # 004f4cfd
    mov edx, dword ptr [ecx + field_15e]         # 004f4d00
    push edx                                     # 004f4d06
    mov eax, dword ptr [ebp - local_8]           # 004f4d07
    add eax, 0x28f                               # 004f4d0a
    push eax                                     # 004f4d0f
    mov ecx, dword ptr [ebp - local_10]          # 004f4d10
    call FUN_004f5f69                            # 004f4d13
    test eax, eax                                # 004f4d18
    jne.d8 L_004f4d63                            # 004f4d1a
    # block 0x004f4d1c: entered by fall-through of jne at 0x004f4d1a, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov ecx, dword ptr [ebp - local_8]           # 004f4d1c
    mov dword ptr [ecx + field_28f], 0x0         # 004f4d1f
    mov edx, dword ptr [ebp + arg_8]             # 004f4d29
    and edx, 0xffff                              # 004f4d2c
    push edx                                     # 004f4d32
    mov ecx, dword ptr [ebp - local_10]          # 004f4d33
    call FUN_004f356e                            # 004f4d36
    mov eax, dword ptr [ebp - local_10]          # 004f4d3b
    mov dword ptr [eax + field_3c2], 0x404       # 004f4d3e
    mov ecx, dword ptr [ebp - local_10]          # 004f4d48
    mov dword ptr [ecx + field_3be], 0x0         # 004f4d4b
    mov edx, dword ptr [ebp - local_10]          # 004f4d55
    mov eax, dword ptr [edx + field_3be]         # 004f4d58
    jmp.d32 L_004f52a2                           # 004f4d5e
L_004f4d63:
    # block 0x004f4d63: entered by jne at 0x004f4d1a, 3 instruction(s), ends with je to 0x004f4da8 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f4d63
    test eax, eax                                # 004f4d6a
    je.d8 L_004f4da8                             # 004f4d6c
    # block 0x004f4d6e: entered by fall-through of je at 0x004f4d6c, 16 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4da8
    mov ecx, dword ptr [ebp - local_8]           # 004f4d6e
    add ecx, 0x4                                 # 004f4d71
    push ecx                                     # 004f4d74
    mov edx, dword ptr [ebp + arg_8]             # 004f4d75
    and edx, 0xffff                              # 004f4d78
    push edx                                     # 004f4d7e
    mov eax, dword ptr [ebp - local_8]           # 004f4d7f
    mov ecx, dword ptr [eax + field_15e]         # 004f4d82
    push ecx                                     # 004f4d88
    push 0x55e138                                # 004f4d89
    push 0x63888b                                # 004f4d8e
    call FUN_0050ca3e                            # 004f4d93
    add esp, 0x14                                # 004f4d98
    push 0x63888b                                # 004f4d9b
    call FUN_0044a2b7                            # 004f4da0
    add esp, 0x4                                 # 004f4da5
L_004f4da8:
    # block 0x004f4da8: entered by je at 0x004f4d6c, 16 instruction(s), calls indirect dword ptr [edx], ends with je to 0x004f4e2a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f4da8
    add edx, 0x29b                               # 004f4dab
    push edx                                     # 004f4db1
    push 0x52e53c                                # 004f4db2
    mov eax, dword ptr [ebp - local_8]           # 004f4db7
    mov ecx, dword ptr [eax + field_28f]         # 004f4dba
    mov edx, dword ptr [ebp - local_8]           # 004f4dc0
    mov eax, dword ptr [edx + field_28f]         # 004f4dc3
    mov edx, dword ptr [eax]                     # 004f4dc9
    push ecx                                     # 004f4dcb
    call dword ptr [edx]                         # 004f4dcc
    mov ecx, dword ptr [ebp - local_10]          # 004f4dce
    mov dword ptr [ecx + field_3ca], eax         # 004f4dd1
    mov edx, dword ptr [ebp - local_10]          # 004f4dd7
    cmp dword ptr [edx + field_3ca], 0x0         # 004f4dda
    je.d8 L_004f4e2a                             # 004f4de1
    # block 0x004f4de3: entered by fall-through of je at 0x004f4de1, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov eax, dword ptr [ebp - local_8]           # 004f4de3
    mov dword ptr [eax + field_29b], 0x0         # 004f4de6
    mov ecx, dword ptr [ebp + arg_8]             # 004f4df0
    and ecx, 0xffff                              # 004f4df3
    push ecx                                     # 004f4df9
    mov ecx, dword ptr [ebp - local_10]          # 004f4dfa
    call FUN_004f356e                            # 004f4dfd
    mov edx, dword ptr [ebp - local_10]          # 004f4e02
    mov dword ptr [edx + field_3c2], 0x417       # 004f4e05
    mov eax, dword ptr [ebp - local_10]          # 004f4e0f
    mov dword ptr [eax + field_3be], 0x0         # 004f4e12
    mov ecx, dword ptr [ebp - local_10]          # 004f4e1c
    mov eax, dword ptr [ecx + field_3be]         # 004f4e1f
    jmp.d32 L_004f52a2                           # 004f4e25
L_004f4e2a:
    # block 0x004f4e2a: entered by je at 0x004f4de1, 3 instruction(s), ends with je to 0x004f4e65 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f4e2a
    test edx, edx                                # 004f4e31
    je.d8 L_004f4e65                             # 004f4e33
    # block 0x004f4e35: entered by fall-through of je at 0x004f4e33, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4e65
    mov eax, dword ptr [ebp - local_8]           # 004f4e35
    add eax, 0x4                                 # 004f4e38
    push eax                                     # 004f4e3b
    mov ecx, dword ptr [ebp + arg_8]             # 004f4e3c
    and ecx, 0xffff                              # 004f4e3f
    push ecx                                     # 004f4e45
    push 0x55e190                                # 004f4e46
    push 0x63888b                                # 004f4e4b
    call FUN_0050ca3e                            # 004f4e50
    add esp, 0x10                                # 004f4e55
    push 0x63888b                                # 004f4e58
    call FUN_0044a2b7                            # 004f4e5d
    add esp, 0x4                                 # 004f4e62
L_004f4e65:
    # block 0x004f4e65: entered by je at 0x004f4e33, 22 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f4ee2 (forward)
    mov ecx, 0x10                                # 004f4e65
    {load} xor eax, eax                          # 004f4e6a
    mov edi, dword ptr [ebp - local_8]           # 004f4e6c
    add edi, 0x29f                               # 004f4e6f
    rep stosd dword ptr es:[edi], eax            # 004f4e75
    mov edx, dword ptr [ebp - local_8]           # 004f4e77
    mov dword ptr [edx + field_29f], 0x40        # 004f4e7a
    mov eax, dword ptr [ebp - local_8]           # 004f4e84
    add eax, 0x29f                               # 004f4e87
    push eax                                     # 004f4e8c
    mov ecx, dword ptr [ebp - local_8]           # 004f4e8d
    mov edx, dword ptr [ecx + field_29b]         # 004f4e90
    mov eax, dword ptr [ebp - local_8]           # 004f4e96
    mov ecx, dword ptr [eax + field_29b]         # 004f4e99
    mov eax, dword ptr [ecx]                     # 004f4e9f
    push edx                                     # 004f4ea1
    call dword ptr [eax + field_c]               # 004f4ea2
    mov ecx, dword ptr [ebp - local_10]          # 004f4ea5
    mov dword ptr [ecx + field_3ca], eax         # 004f4ea8
    mov edx, dword ptr [ebp - local_10]          # 004f4eae
    cmp dword ptr [edx + field_3ca], 0x0         # 004f4eb1
    je.d8 L_004f4ee2                             # 004f4eb8
    # block 0x004f4eba: entered by fall-through of je at 0x004f4eb8, 7 instruction(s), ends with forward jump to 0x004f52a2
    mov eax, dword ptr [ebp - local_10]          # 004f4eba
    mov dword ptr [eax + field_3c2], 0x418       # 004f4ebd
    mov ecx, dword ptr [ebp - local_10]          # 004f4ec7
    mov dword ptr [ecx + field_3be], 0x0         # 004f4eca
    mov edx, dword ptr [ebp - local_10]          # 004f4ed4
    mov eax, dword ptr [edx + field_3be]         # 004f4ed7
    jmp.d32 L_004f52a2                           # 004f4edd
L_004f4ee2:
    # block 0x004f4ee2: entered by je at 0x004f4eb8, 8 instruction(s), calls FUN_004f95a4, ends with je to 0x004f4ffe (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f4ee2
    and eax, 0xffff                              # 004f4ee5
    push eax                                     # 004f4eea
    mov ecx, dword ptr [ebp - local_10]          # 004f4eeb
    call FUN_004f95a4                            # 004f4eee
    movsx ecx, word ptr [0x63a4cd]               # 004f4ef3
    test ecx, ecx                                # 004f4efa
    je.d32 L_004f4ffe                            # 004f4efc
    # block 0x004f4f02: entered by fall-through of je at 0x004f4efc, 65 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4ffe
    mov edx, dword ptr [ebp - local_8]           # 004f4f02
    fld dword ptr [edx + field_2ab]              # 004f4f05
    sub esp, 0x8                                 # 004f4f0b
    fstp qword ptr [esp]                         # 004f4f0e
    mov eax, dword ptr [ebp - local_8]           # 004f4f11
    fld dword ptr [eax + field_2a7]              # 004f4f14
    sub esp, 0x8                                 # 004f4f1a
    fstp qword ptr [esp]                         # 004f4f1d
    mov ecx, dword ptr [ebp - local_8]           # 004f4f20
    fld dword ptr [ecx + field_2a3]              # 004f4f23
    sub esp, 0x8                                 # 004f4f29
    fstp qword ptr [esp]                         # 004f4f2c
    mov edx, dword ptr [ebp + arg_8]             # 004f4f2f
    and edx, 0xffff                              # 004f4f32
    push edx                                     # 004f4f38
    push 0x55e1e0                                # 004f4f39
    push 0x63888b                                # 004f4f3e
    call FUN_0050ca3e                            # 004f4f43
    add esp, 0x24                                # 004f4f48
    push 0x63888b                                # 004f4f4b
    call FUN_0044a2b7                            # 004f4f50
    add esp, 0x4                                 # 004f4f55
    mov eax, dword ptr [ebp - local_8]           # 004f4f58
    fld dword ptr [eax + field_2b7]              # 004f4f5b
    sub esp, 0x8                                 # 004f4f61
    fstp qword ptr [esp]                         # 004f4f64
    mov ecx, dword ptr [ebp - local_8]           # 004f4f67
    fld dword ptr [ecx + field_2b3]              # 004f4f6a
    sub esp, 0x8                                 # 004f4f70
    fstp qword ptr [esp]                         # 004f4f73
    mov edx, dword ptr [ebp - local_8]           # 004f4f76
    fld dword ptr [edx + field_2af]              # 004f4f79
    sub esp, 0x8                                 # 004f4f7f
    fstp qword ptr [esp]                         # 004f4f82
    mov eax, dword ptr [ebp + arg_8]             # 004f4f85
    and eax, 0xffff                              # 004f4f88
    push eax                                     # 004f4f8d
    push 0x55e24c                                # 004f4f8e
    push 0x63888b                                # 004f4f93
    call FUN_0050ca3e                            # 004f4f98
    add esp, 0x24                                # 004f4f9d
    push 0x63888b                                # 004f4fa0
    call FUN_0044a2b7                            # 004f4fa5
    add esp, 0x4                                 # 004f4faa
    mov ecx, dword ptr [ebp - local_8]           # 004f4fad
    mov edx, dword ptr [ecx + field_2db]         # 004f4fb0
    push edx                                     # 004f4fb6
    mov eax, dword ptr [ebp - local_8]           # 004f4fb7
    fld dword ptr [eax + field_2d7]              # 004f4fba
    sub esp, 0x8                                 # 004f4fc0
    fstp qword ptr [esp]                         # 004f4fc3
    mov ecx, dword ptr [ebp - local_8]           # 004f4fc6
    fld dword ptr [ecx + field_2d3]              # 004f4fc9
    sub esp, 0x8                                 # 004f4fcf
    fstp qword ptr [esp]                         # 004f4fd2
    mov edx, dword ptr [ebp + arg_8]             # 004f4fd5
    and edx, 0xffff                              # 004f4fd8
    push edx                                     # 004f4fde
    push 0x55e2b8                                # 004f4fdf
    push 0x63888b                                # 004f4fe4
    call FUN_0050ca3e                            # 004f4fe9
    add esp, 0x20                                # 004f4fee
    push 0x63888b                                # 004f4ff1
    call FUN_0044a2b7                            # 004f4ff6
    add esp, 0x4                                 # 004f4ffb
L_004f4ffe:
    # block 0x004f4ffe: entered by je at 0x004f4efc, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004f5063 (forward)
    push 0x8                                     # 004f4ffe
    call FUN_0051dc43                            # 004f5000
    add esp, 0x4                                 # 004f5005
    mov dword ptr [ebp - local_c], eax           # 004f5008
    mov eax, dword ptr [ebp - local_8]           # 004f500b
    mov ecx, dword ptr [ebp - local_c]           # 004f500e
    mov dword ptr [eax + field_297], ecx         # 004f5011
    cmp dword ptr [ebp - local_c], 0x0           # 004f5017
    jne.d8 L_004f5063                            # 004f501b
    # block 0x004f501d: entered by fall-through of jne at 0x004f501b, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov edx, dword ptr [ebp - local_8]           # 004f501d
    mov dword ptr [edx + field_297], 0x0         # 004f5020
    mov eax, dword ptr [ebp + arg_8]             # 004f502a
    and eax, 0xffff                              # 004f502d
    push eax                                     # 004f5032
    mov ecx, dword ptr [ebp - local_10]          # 004f5033
    call FUN_004f356e                            # 004f5036
    mov ecx, dword ptr [ebp - local_10]          # 004f503b
    mov dword ptr [ecx + field_3c2], 0x3ee       # 004f503e
    mov edx, dword ptr [ebp - local_10]          # 004f5048
    mov dword ptr [edx + field_3be], 0x0         # 004f504b
    mov eax, dword ptr [ebp - local_10]          # 004f5055
    mov eax, dword ptr [eax + field_3be]         # 004f5058
    jmp.d32 L_004f52a2                           # 004f505e
L_004f5063:
    # block 0x004f5063: entered by jne at 0x004f501b, 14 instruction(s), ends with je to 0x004f50aa (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f5063
    mov edx, dword ptr [ecx + field_297]         # 004f5066
    mov dword ptr [edx], 0xffffffff              # 004f506c
    mov eax, dword ptr [ebp + arg_8]             # 004f5072
    and eax, 0xffff                              # 004f5075
    shl eax                                      # 004f507a
    mov ecx, dword ptr [ebp - local_8]           # 004f507c
    mov edx, dword ptr [ecx + field_297]         # 004f507f
    mov ecx, dword ptr [ebp - local_10]          # 004f5085
    mov eax, dword ptr [ecx + 4*eax + field_2be] # 004f5088
    mov dword ptr [edx + field_4], eax           # 004f508f
    movsx ecx, word ptr [0x63a4cd]               # 004f5092
    test ecx, ecx                                # 004f5099
    je.d8 L_004f50aa                             # 004f509b
    # block 0x004f509d: entered by fall-through of je at 0x004f509b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f50aa
    push 0x55e330                                # 004f509d
    call FUN_0044a2b7                            # 004f50a2
    add esp, 0x4                                 # 004f50a7
L_004f50aa:
    # block 0x004f50aa: entered by je at 0x004f509b, 16 instruction(s), calls indirect dword ptr [edx], ends with je to 0x004f512c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f50aa
    add edx, 0x293                               # 004f50ad
    push edx                                     # 004f50b3
    push 0x52e52c                                # 004f50b4
    mov eax, dword ptr [ebp - local_8]           # 004f50b9
    mov ecx, dword ptr [eax + field_28f]         # 004f50bc
    mov edx, dword ptr [ebp - local_8]           # 004f50c2
    mov eax, dword ptr [edx + field_28f]         # 004f50c5
    mov edx, dword ptr [eax]                     # 004f50cb
    push ecx                                     # 004f50cd
    call dword ptr [edx]                         # 004f50ce
    mov ecx, dword ptr [ebp - local_10]          # 004f50d0
    mov dword ptr [ecx + field_3ca], eax         # 004f50d3
    mov edx, dword ptr [ebp - local_10]          # 004f50d9
    cmp dword ptr [edx + field_3ca], 0x0         # 004f50dc
    je.d8 L_004f512c                             # 004f50e3
    # block 0x004f50e5: entered by fall-through of je at 0x004f50e3, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov eax, dword ptr [ebp - local_8]           # 004f50e5
    mov dword ptr [eax + field_293], 0x0         # 004f50e8
    mov ecx, dword ptr [ebp + arg_8]             # 004f50f2
    and ecx, 0xffff                              # 004f50f5
    push ecx                                     # 004f50fb
    mov ecx, dword ptr [ebp - local_10]          # 004f50fc
    call FUN_004f356e                            # 004f50ff
    mov edx, dword ptr [ebp - local_10]          # 004f5104
    mov dword ptr [edx + field_3c2], 0x412       # 004f5107
    mov eax, dword ptr [ebp - local_10]          # 004f5111
    mov dword ptr [eax + field_3be], 0x0         # 004f5114
    mov ecx, dword ptr [ebp - local_10]          # 004f511e
    mov eax, dword ptr [ecx + field_3be]         # 004f5121
    jmp.d32 L_004f52a2                           # 004f5127
L_004f512c:
    # block 0x004f512c: entered by je at 0x004f50e3, 16 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f519e (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f512c
    mov eax, dword ptr [edx + field_297]         # 004f512f
    push eax                                     # 004f5135
    push 0x1                                     # 004f5136
    mov ecx, dword ptr [ebp - local_8]           # 004f5138
    mov edx, dword ptr [ecx + field_293]         # 004f513b
    mov eax, dword ptr [ebp - local_8]           # 004f5141
    mov ecx, dword ptr [eax + field_293]         # 004f5144
    mov eax, dword ptr [ecx]                     # 004f514a
    push edx                                     # 004f514c
    call dword ptr [eax + field_c]               # 004f514d
    mov ecx, dword ptr [ebp - local_10]          # 004f5150
    mov dword ptr [ecx + field_3ca], eax         # 004f5153
    mov edx, dword ptr [ebp - local_10]          # 004f5159
    cmp dword ptr [edx + field_3ca], 0x0         # 004f515c
    je.d8 L_004f519e                             # 004f5163
    # block 0x004f5165: entered by fall-through of je at 0x004f5163, 12 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov eax, dword ptr [ebp + arg_8]             # 004f5165
    and eax, 0xffff                              # 004f5168
    push eax                                     # 004f516d
    mov ecx, dword ptr [ebp - local_10]          # 004f516e
    call FUN_004f356e                            # 004f5171
    mov ecx, dword ptr [ebp - local_10]          # 004f5176
    mov dword ptr [ecx + field_3c2], 0x414       # 004f5179
    mov edx, dword ptr [ebp - local_10]          # 004f5183
    mov dword ptr [edx + field_3be], 0x0         # 004f5186
    mov eax, dword ptr [ebp - local_10]          # 004f5190
    mov eax, dword ptr [eax + field_3be]         # 004f5193
    jmp.d32 L_004f52a2                           # 004f5199
L_004f519e:
    # block 0x004f519e: entered by je at 0x004f5163, 3 instruction(s), ends with je to 0x004f51d8 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f519e
    test ecx, ecx                                # 004f51a5
    je.d8 L_004f51d8                             # 004f51a7
    # block 0x004f51a9: entered by fall-through of je at 0x004f51a7, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f51d8
    mov edx, dword ptr [ebp - local_8]           # 004f51a9
    add edx, 0x4                                 # 004f51ac
    push edx                                     # 004f51af
    mov eax, dword ptr [ebp + arg_8]             # 004f51b0
    and eax, 0xffff                              # 004f51b3
    push eax                                     # 004f51b8
    push 0x55e388                                # 004f51b9
    push 0x63888b                                # 004f51be
    call FUN_0050ca3e                            # 004f51c3
    add esp, 0x10                                # 004f51c8
    push 0x63888b                                # 004f51cb
    call FUN_0044a2b7                            # 004f51d0
    add esp, 0x4                                 # 004f51d5
L_004f51d8:
    # block 0x004f51d8: entered by je at 0x004f51a7, 4 instruction(s), ends with jne to 0x004f5251 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f51d8
    movsx edx, word ptr [ecx + field_126]        # 004f51db
    cmp edx, 0x2                                 # 004f51e2
    jne.d8 L_004f5251                            # 004f51e5
    # block 0x004f51e7: entered by fall-through of jne at 0x004f51e5, 12 instruction(s), calls FUN_004fdb90, ends with jge to 0x004f5251 (forward)
    push 0x0                                     # 004f51e7
    push 0x0                                     # 004f51e9
    mov eax, dword ptr [ebp - local_8]           # 004f51eb
    add eax, 0x2f1                               # 004f51ee
    push eax                                     # 004f51f3
    mov ecx, dword ptr [ebp - local_8]           # 004f51f4
    mov edx, dword ptr [ecx + field_156]         # 004f51f7
    push edx                                     # 004f51fd
    call FUN_004fdb90                            # 004f51fe
    add esp, 0x10                                # 004f5203
    test eax, eax                                # 004f5206
    jge.d8 L_004f5251                            # 004f5208
    # block 0x004f520a: entered by fall-through of jge at 0x004f5208, 8 instruction(s), calls FUN_004f356e, ends with je to 0x004f524d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f520a
    and eax, 0xffff                              # 004f520d
    push eax                                     # 004f5212
    mov ecx, dword ptr [ebp - local_10]          # 004f5213
    call FUN_004f356e                            # 004f5216
    movsx ecx, word ptr [0x63a4cd]               # 004f521b
    test ecx, ecx                                # 004f5222
    je.d8 L_004f524d                             # 004f5224
    # block 0x004f5226: entered by fall-through of je at 0x004f5224, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x004f524d
    mov edx, dword ptr [ebp - local_8]           # 004f5226
    add edx, 0x4                                 # 004f5229
    push edx                                     # 004f522c
    push 0x55e3e8                                # 004f522d
    push 0x63888b                                # 004f5232
    call FUN_0050ca3e                            # 004f5237
    add esp, 0xc                                 # 004f523c
    push 0x0                                     # 004f523f
    push 0x0                                     # 004f5241
    push 0x63888b                                # 004f5243
    call FUN_0052139c                            # 004f5248
L_004f524d:
    # block 0x004f524d: entered by je at 0x004f5224, 2 instruction(s), ends with forward jump to 0x004f52a2
    {load} xor eax, eax                          # 004f524d
    jmp.d8 L_004f52a2                            # 004f524f
L_004f5251:
    # block 0x004f5251: entered by jne at 0x004f51e5; jge at 0x004f5208, 9 instruction(s), calls FUN_004f594d, ends with jne to 0x004f5283 (forward)
    push 0x5622                                  # 004f5251
    push 0x0                                     # 004f5256
    mov eax, dword ptr [ebp + arg_8]             # 004f5258
    and eax, 0xffff                              # 004f525b
    push eax                                     # 004f5260
    mov ecx, dword ptr [ebp - local_10]          # 004f5261
    call FUN_004f594d                            # 004f5264
    test eax, eax                                # 004f5269
    jne.d8 L_004f5283                            # 004f526b
    # block 0x004f526d: entered by fall-through of jne at 0x004f526b, 7 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f52a2
    mov ecx, dword ptr [ebp + arg_8]             # 004f526d
    and ecx, 0xffff                              # 004f5270
    push ecx                                     # 004f5276
    mov ecx, dword ptr [ebp - local_10]          # 004f5277
    call FUN_004f356e                            # 004f527a
    {load} xor eax, eax                          # 004f527f
    jmp.d8 L_004f52a2                            # 004f5281
L_004f5283:
    # block 0x004f5283: entered by jne at 0x004f526b, 8 instruction(s), calls FUN_004f684a, falls into the block at 0x004f52a2
    mov edx, dword ptr [ebp - local_4]           # 004f5283
    mov dword ptr [edx], 0x5622                  # 004f5286
    mov eax, dword ptr [ebp + arg_8]             # 004f528c
    and eax, 0xffff                              # 004f528f
    push eax                                     # 004f5294
    mov ecx, dword ptr [ebp - local_10]          # 004f5295
    call FUN_004f684a                            # 004f5298
    mov eax, 0x1                                 # 004f529d
L_004f52a2:
    # block 0x004f52a2: entered by jmp at 0x004f4d5e; jmp at 0x004f4e25; jmp at 0x004f4edd; jmp at 0x004f505e; more, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004f52a2
    {load} mov esp, ebp                          # 004f52a3
    pop ebp                                      # 004f52a5
    ret 0x4                                      # 004f52a6

