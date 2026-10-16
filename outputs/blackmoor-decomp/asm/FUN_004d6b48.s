# FUN_004d6b48
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d6b48
# extent:       0x004d6b48-0x004d712f (1511 code bytes)
# span:         0x004d6b48-0x004d7162 (code 1511, tables 51, padding 0)
# sha256:       4b08b2fc163baab1b657100688f11e69c60079d22433b510bd5bfa59592259e5
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d6b48
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_30, local_34, local_38
# fields:       [eax + n] field_35, field_2b6, field_459, field_461, field_469, field_46d, field_472, field_9506, field_9546, field_97f4, field_97f8, field_9800 and 1 more; [ecx + n] field_35, field_41, field_2b6, field_2b8, field_455, field_461, field_465, field_469, field_46d, field_46e, field_472, field_9506 and 5 more; [edx + n] field_2b6, field_2b8, field_2ba, field_2cc, field_461, field_465, field_469, field_46e, field_9506, field_9512, field_9546, field_955e and 6 more
# callees:      calls KERNEL32.dll!GetTickCount, FUN_00449dc7, FUN_00449ef8, FUN_004d3836, FUN_004c4b12, FUN_004d270b, FUN_004c5b3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 405 instruction(s), 18 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ field_35, 0x35  # offset +0x35
.equ field_41, 0x41  # offset +0x41
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2cc, 0x2cc  # offset +0x2cc
.equ field_455, 0x455  # offset +0x455
.equ field_459, 0x459  # offset +0x459
.equ field_461, 0x461  # offset +0x461
.equ field_465, 0x465  # offset +0x465
.equ field_469, 0x469  # offset +0x469
.equ field_46d, 0x46d  # offset +0x46d
.equ field_46e, 0x46e  # offset +0x46e
.equ field_472, 0x472  # offset +0x472
.equ field_9506, 0x9506  # offset +0x9506
.equ field_9512, 0x9512  # offset +0x9512
.equ field_9522, 0x9522  # offset +0x9522
.equ field_9546, 0x9546  # offset +0x9546
.equ field_954a, 0x954a  # offset +0x954a
.equ field_955e, 0x955e  # offset +0x955e
.equ field_956e, 0x956e  # offset +0x956e
.equ field_97f4, 0x97f4  # offset +0x97f4
.equ field_97f8, 0x97f8  # offset +0x97f8
.equ field_97fc, 0x97fc  # offset +0x97fc
.equ field_9800, 0x9800  # offset +0x9800
.equ field_3390b, 0x3390b  # offset +0x3390b

# --- external targets -----------------------------------------------
.set FUN_00449dc7, .text + (0x00449dc7 - 0x401000)
.set FUN_00449ef8, .text + (0x00449ef8 - 0x401000)
.set FUN_004c4b12, .text + (0x004c4b12 - 0x401000)
.set FUN_004c5b3a, .text + (0x004c5b3a - 0x401000)
.set FUN_004d270b, .text + (0x004d270b - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)

.org 0x004d6b48 - 0x401000
.globl FUN_004d6b48
FUN_004d6b48:
    # block 0x004d6b48: entry, 13 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d6bb2 (forward)
    push ebp                                     # 004d6b48
    {load} mov ebp, esp                          # 004d6b49
    sub esp, 0x38                                # 004d6b4b
    push esi                                     # 004d6b4e
    push edi                                     # 004d6b4f
    mov dword ptr [ebp - local_34], ecx          # 004d6b50
    mov eax, dword ptr [ebp - local_34]          # 004d6b53
    add eax, 0x96d3                              # 004d6b56
    mov dword ptr [ebp - local_c], eax           # 004d6b5b
    call dword ptr [0x52a23c]                    # 004d6b5e
    mov ecx, dword ptr [ebp - local_34]          # 004d6b64
    cmp eax, dword ptr [ecx + field_465]         # 004d6b67
    jbe.d8 L_004d6bb2                            # 004d6b6d
    # block 0x004d6b6f: entered by fall-through of jbe at 0x004d6b6d, 3 instruction(s), ends with jne to 0x004d6b8a (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d6b6f
    cmp dword ptr [edx + field_461], 0x0         # 004d6b72
    jne.d8 L_004d6b8a                            # 004d6b79
    # block 0x004d6b7b: entered by fall-through of jne at 0x004d6b79, 3 instruction(s), ends with forward jump to 0x004d6b97
    mov eax, dword ptr [ebp - local_34]          # 004d6b7b
    mov dword ptr [eax + field_461], 0x1         # 004d6b7e
    jmp.d8 L_004d6b97                            # 004d6b88
L_004d6b8a:
    # block 0x004d6b8a: entered by jne at 0x004d6b79, 2 instruction(s), falls into the block at 0x004d6b97
    mov ecx, dword ptr [ebp - local_34]          # 004d6b8a
    mov dword ptr [ecx + field_461], 0x0         # 004d6b8d
L_004d6b97:
    # block 0x004d6b97: entered by jmp at 0x004d6b88, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004d6bb2
    call dword ptr [0x52a23c]                    # 004d6b97
    mov edx, dword ptr [ebp - local_34]          # 004d6b9d
    movsx ecx, word ptr [edx + field_2cc]        # 004d6ba0
    {load} add eax, ecx                          # 004d6ba7
    mov edx, dword ptr [ebp - local_34]          # 004d6ba9
    mov dword ptr [edx + field_465], eax         # 004d6bac
L_004d6bb2:
    # block 0x004d6bb2: entered by jbe at 0x004d6b6d, 3 instruction(s), ends with je to 0x004d6ceb (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d6bb2
    cmp dword ptr [eax + field_472], 0x0         # 004d6bb5
    je.d32 L_004d6ceb                            # 004d6bbc
    # block 0x004d6bc2: entered by fall-through of je at 0x004d6bbc, 8 instruction(s), ends with ja to 0x004d6cd9 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004d6bc2
    movsx edx, byte ptr [ecx + field_46d]        # 004d6bc5
    mov dword ptr [ebp - local_38], edx          # 004d6bcc
    mov eax, dword ptr [ebp - local_38]          # 004d6bcf
    sub eax, 0xd                                 # 004d6bd2
    mov dword ptr [ebp - local_38], eax          # 004d6bd5
    cmp dword ptr [ebp - local_38], 0x1a         # 004d6bd8
    ja.d32 L_004d6cd9                            # 004d6bdc
    # block 0x004d6be2: entered by fall-through of ja at 0x004d6bdc, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4d712f]
    mov edx, dword ptr [ebp - local_38]          # 004d6be2
    {load} xor ecx, ecx                          # 004d6be5
    mov cl, byte ptr [edx + IDXTAB_004d7147_VA]  # 004d6be7
    jmp dword ptr [4*ecx + SWTAB_004d712f_VA]    # 004d6bed
L_004d6bf4:
    # block 0x004d6bf4: entered by switch case, 8 instruction(s), ends with jge to 0x004d6c22 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d6bf4
    mov ecx, dword ptr [eax + field_469]         # 004d6bf7
    sub ecx, 0x1                                 # 004d6bfd
    mov edx, dword ptr [ebp - local_34]          # 004d6c00
    mov dword ptr [edx + field_469], ecx         # 004d6c03
    mov eax, dword ptr [ebp - local_34]          # 004d6c09
    cmp dword ptr [eax + field_469], 0x0         # 004d6c0c
    jge.d8 L_004d6c22                            # 004d6c13
    # block 0x004d6c15: entered by fall-through of jge at 0x004d6c13, 2 instruction(s), falls into the block at 0x004d6c22
    mov ecx, dword ptr [ebp - local_34]          # 004d6c15
    mov dword ptr [ecx + field_469], 0x0         # 004d6c18
L_004d6c22:
    # block 0x004d6c22: entered by jge at 0x004d6c13, 1 instruction(s), ends with forward jump to 0x004d6cd9
    jmp.d32 L_004d6cd9                           # 004d6c22
L_004d6c27:
    # block 0x004d6c27: entered by switch case, 14 instruction(s), ends with jbe to 0x004d6c6e (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d6c27
    mov eax, dword ptr [edx + field_469]         # 004d6c2a
    add eax, 0x1                                 # 004d6c30
    mov ecx, dword ptr [ebp - local_34]          # 004d6c33
    mov dword ptr [ecx + field_469], eax         # 004d6c36
    mov edi, dword ptr [ebp - local_c]           # 004d6c3c
    or ecx, -0x1                                 # 004d6c3f
    {load} xor eax, eax                          # 004d6c42
    repne scasb al, byte ptr es:[edi]            # 004d6c44
    not ecx                                      # 004d6c46
    add ecx, -0x1                                # 004d6c48
    mov edx, dword ptr [ebp - local_34]          # 004d6c4b
    cmp dword ptr [edx + field_469], ecx         # 004d6c4e
    jbe.d8 L_004d6c6e                            # 004d6c54
    # block 0x004d6c56: entered by fall-through of jbe at 0x004d6c54, 8 instruction(s), falls into the block at 0x004d6c6e
    mov edi, dword ptr [ebp - local_c]           # 004d6c56
    or ecx, -0x1                                 # 004d6c59
    {load} xor eax, eax                          # 004d6c5c
    repne scasb al, byte ptr es:[edi]            # 004d6c5e
    not ecx                                      # 004d6c60
    add ecx, -0x1                                # 004d6c62
    mov eax, dword ptr [ebp - local_34]          # 004d6c65
    mov dword ptr [eax + field_469], ecx         # 004d6c68
L_004d6c6e:
    # block 0x004d6c6e: entered by jbe at 0x004d6c54, 1 instruction(s), ends with forward jump to 0x004d6cd9
    jmp.d8 L_004d6cd9                            # 004d6c6e
L_004d6c70:
    # block 0x004d6c70: entered by switch case, 3 instruction(s), ends with forward jump to 0x004d6cd9
    mov ecx, dword ptr [ebp - local_34]          # 004d6c70
    mov dword ptr [ecx + field_469], 0x0         # 004d6c73
    jmp.d8 L_004d6cd9                            # 004d6c7d
L_004d6c7f:
    # block 0x004d6c7f: entered by switch case, 9 instruction(s), ends with forward jump to 0x004d6cd9
    mov edi, dword ptr [ebp - local_c]           # 004d6c7f
    or ecx, -0x1                                 # 004d6c82
    {load} xor eax, eax                          # 004d6c85
    repne scasb al, byte ptr es:[edi]            # 004d6c87
    not ecx                                      # 004d6c89
    add ecx, -0x1                                # 004d6c8b
    mov edx, dword ptr [ebp - local_34]          # 004d6c8e
    mov dword ptr [edx + field_469], ecx         # 004d6c91
    jmp.d8 L_004d6cd9                            # 004d6c97
L_004d6c99:
    # block 0x004d6c99: entered by switch case, 7 instruction(s), ends with je to 0x004d6cd9 (forward)
    mov edi, 0x63a9a0                            # 004d6c99
    mov esi, dword ptr [ebp - local_34]          # 004d6c9e
    add esi, 0x96d3                              # 004d6ca1
    mov ecx, 0x1                                 # 004d6ca7
    {load} xor eax, eax                          # 004d6cac
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d6cae
    je.d8 L_004d6cd9                             # 004d6cb0
    # block 0x004d6cb2: entered by fall-through of je at 0x004d6cb0, 6 instruction(s), falls into the block at 0x004d6cd9
    mov ecx, dword ptr [ebp - local_34]          # 004d6cb2
    mov dword ptr [ecx + field_455], 0x2         # 004d6cb5
    mov edx, dword ptr [ebp - local_34]          # 004d6cbf
    mov dword ptr [edx + field_955e], 0x0        # 004d6cc2
    mov eax, dword ptr [ebp - local_34]          # 004d6ccc
    mov dword ptr [eax + field_459], 0x0         # 004d6ccf
L_004d6cd9:
    # block 0x004d6cd9: entered by ja at 0x004d6bdc; jmp at 0x004d6c22; jmp at 0x004d6c6e; jmp at 0x004d6c7d; more, 3 instruction(s), ends with forward jump to 0x004d6ee0
    mov ecx, dword ptr [ebp - local_34]          # 004d6cd9
    mov dword ptr [ecx + field_472], 0x0         # 004d6cdc
    jmp.d32 L_004d6ee0                           # 004d6ce6
L_004d6ceb:
    # block 0x004d6ceb: entered by je at 0x004d6bbc, 3 instruction(s), ends with je to 0x004d6ee0 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d6ceb
    cmp dword ptr [edx + field_46e], 0x0         # 004d6cee
    je.d32 L_004d6ee0                            # 004d6cf5
    # block 0x004d6cfb: entered by fall-through of je at 0x004d6cf5, 4 instruction(s), ends with jne to 0x004d6d91 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d6cfb
    movsx ecx, byte ptr [eax + field_46d]        # 004d6cfe
    cmp ecx, 0x8                                 # 004d6d05
    jne.d32 L_004d6d91                           # 004d6d08
    # block 0x004d6d0e: entered by fall-through of jne at 0x004d6d08, 3 instruction(s), ends with jl to 0x004d6d91 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d6d0e
    cmp dword ptr [edx + field_469], 0x1         # 004d6d11
    jl.d8 L_004d6d91                             # 004d6d18
    # block 0x004d6d1a: entered by fall-through of jl at 0x004d6d18, 9 instruction(s), ends with ja to 0x004d6d91 (forward)
    mov edi, dword ptr [ebp - local_c]           # 004d6d1a
    or ecx, -0x1                                 # 004d6d1d
    {load} xor eax, eax                          # 004d6d20
    repne scasb al, byte ptr es:[edi]            # 004d6d22
    not ecx                                      # 004d6d24
    add ecx, -0x1                                # 004d6d26
    mov eax, dword ptr [ebp - local_34]          # 004d6d29
    cmp dword ptr [eax + field_469], ecx         # 004d6d2c
    ja.d8 L_004d6d91                             # 004d6d32
    # block 0x004d6d34: entered by fall-through of ja at 0x004d6d32, 21 instruction(s), calls FUN_00449dc7, ends with jge to 0x004d6d8c (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004d6d34
    mov edx, dword ptr [ecx + field_469]         # 004d6d37
    sub edx, 0x1                                 # 004d6d3d
    push edx                                     # 004d6d40
    mov eax, dword ptr [ebp - local_34]          # 004d6d41
    mov ecx, dword ptr [eax + field_469]         # 004d6d44
    mov edx, dword ptr [ebp - local_c]           # 004d6d4a
    mov al, byte ptr [edx + ecx - field_minus_1] # 004d6d4d
    push eax                                     # 004d6d51
    mov ecx, dword ptr [ebp - local_c]           # 004d6d52
    push ecx                                     # 004d6d55
    call FUN_00449dc7                            # 004d6d56
    add esp, 0xc                                 # 004d6d5b
    mov edx, dword ptr [ebp - local_34]          # 004d6d5e
    mov eax, dword ptr [edx + field_469]         # 004d6d61
    sub eax, 0x1                                 # 004d6d67
    mov ecx, dword ptr [ebp - local_34]          # 004d6d6a
    mov dword ptr [ecx + field_469], eax         # 004d6d6d
    mov edx, dword ptr [ebp - local_34]          # 004d6d73
    cmp dword ptr [edx + field_469], 0x0         # 004d6d76
    jge.d8 L_004d6d8c                            # 004d6d7d
    # block 0x004d6d7f: entered by fall-through of jge at 0x004d6d7d, 2 instruction(s), falls into the block at 0x004d6d8c
    mov eax, dword ptr [ebp - local_34]          # 004d6d7f
    mov dword ptr [eax + field_469], 0x0         # 004d6d82
L_004d6d8c:
    # block 0x004d6d8c: entered by jge at 0x004d6d7d, 1 instruction(s), ends with forward jump to 0x004d6ed3
    jmp.d32 L_004d6ed3                           # 004d6d8c
L_004d6d91:
    # block 0x004d6d91: entered by jne at 0x004d6d08; jl at 0x004d6d18; ja at 0x004d6d32, 4 instruction(s), ends with je to 0x004d6ed3 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004d6d91
    movsx edx, byte ptr [ecx + field_46d]        # 004d6d94
    cmp edx, 0x8                                 # 004d6d9b
    je.d32 L_004d6ed3                            # 004d6d9e
    # block 0x004d6da4: entered by fall-through of je at 0x004d6d9e, 8 instruction(s), ends with ja to 0x004d6ed3 (forward)
    mov edi, dword ptr [ebp - local_c]           # 004d6da4
    or ecx, -0x1                                 # 004d6da7
    {load} xor eax, eax                          # 004d6daa
    repne scasb al, byte ptr es:[edi]            # 004d6dac
    not ecx                                      # 004d6dae
    add ecx, -0x1                                # 004d6db0
    cmp ecx, 0x1f                                # 004d6db3
    ja.d32 L_004d6ed3                            # 004d6db6
    # block 0x004d6dbc: entered by fall-through of ja at 0x004d6db6, 51 instruction(s), calls FUN_00449ef8, FUN_004d3836, ends with jge to 0x004d6eb0 (forward)
    mov edi, dword ptr [ebp - local_c]           # 004d6dbc
    lea edx, [ebp - local_30]                    # 004d6dbf
    or ecx, -0x1                                 # 004d6dc2
    {load} xor eax, eax                          # 004d6dc5
    repne scasb al, byte ptr es:[edi]            # 004d6dc7
    not ecx                                      # 004d6dc9
    {load} sub edi, ecx                          # 004d6dcb
    {load} mov esi, edi                          # 004d6dcd
    {load} mov eax, ecx                          # 004d6dcf
    {load} mov edi, edx                          # 004d6dd1
    shr ecx, 0x2                                 # 004d6dd3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6dd6
    {load} mov ecx, eax                          # 004d6dd8
    and ecx, 0x3                                 # 004d6dda
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d6ddd
    mov ecx, dword ptr [ebp - local_34]          # 004d6ddf
    mov dx, word ptr [ecx + field_469]           # 004d6de2
    push edx                                     # 004d6de9
    mov eax, dword ptr [ebp - local_34]          # 004d6dea
    mov cl, byte ptr [eax + field_46d]           # 004d6ded
    push ecx                                     # 004d6df3
    mov edx, dword ptr [ebp - local_c]           # 004d6df4
    push edx                                     # 004d6df7
    call FUN_00449ef8                            # 004d6df8
    add esp, 0xc                                 # 004d6dfd
    mov eax, dword ptr [ebp - local_34]          # 004d6e00
    movsx ecx, word ptr [eax + field_2b6]        # 004d6e03
    mov edx, dword ptr [ebp - local_34]          # 004d6e0a
    mov dword ptr [edx + field_3390b], ecx       # 004d6e0d
    mov eax, dword ptr [ebp - local_34]          # 004d6e13
    mov ecx, dword ptr [eax + field_3390b]       # 004d6e16
    imul ecx, ecx, 0x1d0                         # 004d6e1c
    add ecx, 0x5adb3a                            # 004d6e22
    push ecx                                     # 004d6e28
    mov edx, dword ptr [ebp - local_34]          # 004d6e29
    mov eax, dword ptr [edx + field_3390b]       # 004d6e2c
    imul eax, eax, 0x7f3                         # 004d6e32
    add eax, 0x5a4c24                            # 004d6e38
    push eax                                     # 004d6e3d
    mov ecx, dword ptr [ebp - local_c]           # 004d6e3e
    push ecx                                     # 004d6e41
    call FUN_004d3836                            # 004d6e42
    add esp, 0xc                                 # 004d6e47
    movsx edx, ax                                # 004d6e4a
    mov eax, dword ptr [ebp - local_34]          # 004d6e4d
    add edx, dword ptr [eax + field_9546]        # 004d6e50
    mov dword ptr [ebp - local_8], edx           # 004d6e56
    mov ecx, dword ptr [ebp - local_34]          # 004d6e59
    mov edx, dword ptr [ebp - local_8]           # 004d6e5c
    cmp edx, dword ptr [ecx + field_9522]        # 004d6e5f
    jge.d8 L_004d6eb0                            # 004d6e65
    # block 0x004d6e67: entered by fall-through of jge at 0x004d6e65, 14 instruction(s), ends with jbe to 0x004d6eae (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d6e67
    mov ecx, dword ptr [eax + field_469]         # 004d6e6a
    add ecx, 0x1                                 # 004d6e70
    mov edx, dword ptr [ebp - local_34]          # 004d6e73
    mov dword ptr [edx + field_469], ecx         # 004d6e76
    mov edi, dword ptr [ebp - local_c]           # 004d6e7c
    or ecx, -0x1                                 # 004d6e7f
    {load} xor eax, eax                          # 004d6e82
    repne scasb al, byte ptr es:[edi]            # 004d6e84
    not ecx                                      # 004d6e86
    add ecx, -0x1                                # 004d6e88
    mov eax, dword ptr [ebp - local_34]          # 004d6e8b
    cmp dword ptr [eax + field_469], ecx         # 004d6e8e
    jbe.d8 L_004d6eae                            # 004d6e94
    # block 0x004d6e96: entered by fall-through of jbe at 0x004d6e94, 8 instruction(s), falls into the block at 0x004d6eae
    mov edi, dword ptr [ebp - local_c]           # 004d6e96
    or ecx, -0x1                                 # 004d6e99
    {load} xor eax, eax                          # 004d6e9c
    repne scasb al, byte ptr es:[edi]            # 004d6e9e
    not ecx                                      # 004d6ea0
    add ecx, -0x1                                # 004d6ea2
    mov edx, dword ptr [ebp - local_34]          # 004d6ea5
    mov dword ptr [edx + field_469], ecx         # 004d6ea8
L_004d6eae:
    # block 0x004d6eae: entered by jbe at 0x004d6e94, 1 instruction(s), ends with forward jump to 0x004d6ed3
    jmp.d8 L_004d6ed3                            # 004d6eae
L_004d6eb0:
    # block 0x004d6eb0: entered by jge at 0x004d6e65, 15 instruction(s), falls into the block at 0x004d6ed3
    lea edi, [ebp - local_30]                    # 004d6eb0
    mov edx, dword ptr [ebp - local_c]           # 004d6eb3
    or ecx, -0x1                                 # 004d6eb6
    {load} xor eax, eax                          # 004d6eb9
    repne scasb al, byte ptr es:[edi]            # 004d6ebb
    not ecx                                      # 004d6ebd
    {load} sub edi, ecx                          # 004d6ebf
    {load} mov esi, edi                          # 004d6ec1
    {load} mov eax, ecx                          # 004d6ec3
    {load} mov edi, edx                          # 004d6ec5
    shr ecx, 0x2                                 # 004d6ec7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6eca
    {load} mov ecx, eax                          # 004d6ecc
    and ecx, 0x3                                 # 004d6ece
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d6ed1
L_004d6ed3:
    # block 0x004d6ed3: entered by jmp at 0x004d6d8c; je at 0x004d6d9e; ja at 0x004d6db6; jmp at 0x004d6eae, 2 instruction(s), falls into the block at 0x004d6ee0
    mov ecx, dword ptr [ebp - local_34]          # 004d6ed3
    mov dword ptr [ecx + field_46e], 0x0         # 004d6ed6
L_004d6ee0:
    # block 0x004d6ee0: entered by jmp at 0x004d6ce6; je at 0x004d6cf5, 56 instruction(s), calls FUN_004c4b12, FUN_004d270b, ends with jne to 0x004d70f4 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d6ee0
    mov eax, dword ptr [edx + field_9506]        # 004d6ee3
    add eax, 0x35                                # 004d6ee9
    push eax                                     # 004d6eec
    mov cx, word ptr [0x5d2f29]                  # 004d6eed
    push ecx                                     # 004d6ef4
    mov edx, dword ptr [ebp - local_34]          # 004d6ef5
    mov eax, dword ptr [edx + field_9506]        # 004d6ef8
    push eax                                     # 004d6efe
    mov ecx, 0x5cf659                            # 004d6eff
    call FUN_004c4b12                            # 004d6f04
    mov ecx, dword ptr [ebp - local_34]          # 004d6f09
    movsx edx, word ptr [ecx + field_2b6]        # 004d6f0c
    mov eax, dword ptr [ebp - local_34]          # 004d6f13
    mov dword ptr [eax + field_3390b], edx       # 004d6f16
    push 0x0                                     # 004d6f1c
    push 0x0                                     # 004d6f1e
    push 0x0                                     # 004d6f20
    mov ecx, dword ptr [ebp - local_34]          # 004d6f22
    mov edx, dword ptr [ecx + field_9506]        # 004d6f25
    push edx                                     # 004d6f2b
    mov eax, dword ptr [ebp - local_34]          # 004d6f2c
    mov ecx, dword ptr [eax + field_3390b]       # 004d6f2f
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d6f35
    push edx                                     # 004d6f3c
    mov eax, dword ptr [ebp - local_34]          # 004d6f3d
    mov ecx, dword ptr [eax + field_9506]        # 004d6f40
    mov edx, dword ptr [ebp - local_34]          # 004d6f46
    movsx eax, word ptr [edx + field_2ba]        # 004d6f49
    mov ecx, dword ptr [ecx + field_41]          # 004d6f50
    {load} add ecx, eax                          # 004d6f53
    push ecx                                     # 004d6f55
    mov edx, dword ptr [ebp - local_34]          # 004d6f56
    mov eax, dword ptr [edx + field_9506]        # 004d6f59
    mov ecx, dword ptr [ebp - local_34]          # 004d6f5f
    movsx edx, word ptr [ecx + field_2b8]        # 004d6f62
    mov eax, dword ptr [eax + field_35]          # 004d6f69
    {load} add eax, edx                          # 004d6f6c
    push eax                                     # 004d6f6e
    mov ecx, dword ptr [ebp - local_34]          # 004d6f6f
    mov edx, dword ptr [ecx + field_3390b]       # 004d6f72
    imul edx, edx, 0x1d0                         # 004d6f78
    add edx, 0x5adb3a                            # 004d6f7e
    push edx                                     # 004d6f84
    mov eax, dword ptr [ebp - local_34]          # 004d6f85
    mov ecx, dword ptr [eax + field_3390b]       # 004d6f88
    imul ecx, ecx, 0x7f3                         # 004d6f8e
    add ecx, 0x5a4c24                            # 004d6f94
    push ecx                                     # 004d6f9a
    mov edx, dword ptr [ebp - local_c]           # 004d6f9b
    push edx                                     # 004d6f9e
    call FUN_004d270b                            # 004d6f9f
    add esp, 0x28                                # 004d6fa4
    mov eax, dword ptr [ebp - local_34]          # 004d6fa7
    cmp dword ptr [eax + field_461], 0x0         # 004d6faa
    jne.d32 L_004d70f4                           # 004d6fb1
    # block 0x004d6fb7: entered by fall-through of jne at 0x004d6fb1, 80 instruction(s), calls FUN_004d3836, FUN_004c5b3a, falls into the block at 0x004d70f4
    mov ecx, dword ptr [ebp - local_34]          # 004d6fb7
    mov edx, dword ptr [ecx + field_469]         # 004d6fba
    mov eax, dword ptr [ebp - local_c]           # 004d6fc0
    mov cl, byte ptr [eax + edx]                 # 004d6fc3
    mov byte ptr [ebp - local_4], cl             # 004d6fc6
    mov edx, dword ptr [ebp - local_34]          # 004d6fc9
    mov eax, dword ptr [edx + field_469]         # 004d6fcc
    mov ecx, dword ptr [ebp - local_c]           # 004d6fd2
    mov byte ptr [ecx + eax], 0x0                # 004d6fd5
    mov edx, dword ptr [ebp - local_34]          # 004d6fd9
    movsx eax, word ptr [edx + field_2b6]        # 004d6fdc
    mov ecx, dword ptr [ebp - local_34]          # 004d6fe3
    mov dword ptr [ecx + field_3390b], eax       # 004d6fe6
    mov edx, dword ptr [ebp - local_34]          # 004d6fec
    mov eax, dword ptr [edx + field_3390b]       # 004d6fef
    imul eax, eax, 0x1d0                         # 004d6ff5
    add eax, 0x5adb3a                            # 004d6ffb
    push eax                                     # 004d7000
    mov ecx, dword ptr [ebp - local_34]          # 004d7001
    mov edx, dword ptr [ecx + field_3390b]       # 004d7004
    imul edx, edx, 0x7f3                         # 004d700a
    add edx, 0x5a4c24                            # 004d7010
    push edx                                     # 004d7016
    mov eax, dword ptr [ebp - local_c]           # 004d7017
    push eax                                     # 004d701a
    call FUN_004d3836                            # 004d701b
    add esp, 0xc                                 # 004d7020
    movsx ecx, ax                                # 004d7023
    mov dword ptr [ebp - local_8], ecx           # 004d7026
    mov edx, dword ptr [ebp - local_34]          # 004d7029
    mov eax, dword ptr [edx + field_469]         # 004d702c
    mov ecx, dword ptr [ebp - local_c]           # 004d7032
    mov dl, byte ptr [ebp - local_4]             # 004d7035
    mov byte ptr [ecx + eax], dl                 # 004d7038
    mov eax, dword ptr [ebp - local_34]          # 004d703b
    mov ecx, dword ptr [eax + field_9506]        # 004d703e
    mov edx, dword ptr [ebp - local_34]          # 004d7044
    movsx eax, word ptr [edx + field_2b8]        # 004d7047
    mov ecx, dword ptr [ecx + field_35]          # 004d704e
    {load} add ecx, eax                          # 004d7051
    add ecx, dword ptr [ebp - local_8]           # 004d7053
    mov edx, dword ptr [ebp - local_34]          # 004d7056
    mov dword ptr [edx + field_97f4], ecx        # 004d7059
    mov eax, dword ptr [ebp - local_34]          # 004d705f
    mov ecx, dword ptr [eax + field_97f4]        # 004d7062
    mov edx, dword ptr [ebp - local_34]          # 004d7068
    mov eax, dword ptr [edx + field_9546]        # 004d706b
    lea ecx, [ecx + eax - field_minus_1]         # 004d7071
    mov edx, dword ptr [ebp - local_34]          # 004d7075
    mov dword ptr [edx + field_97fc], ecx        # 004d7078
    mov eax, dword ptr [ebp - local_34]          # 004d707e
    mov ecx, dword ptr [eax + field_9506]        # 004d7081
    mov edx, dword ptr [ebp - local_34]          # 004d7087
    movsx eax, word ptr [edx + field_2ba]        # 004d708a
    mov ecx, dword ptr [ecx + field_41]          # 004d7091
    {load} add ecx, eax                          # 004d7094
    mov edx, dword ptr [ebp - local_34]          # 004d7096
    mov dword ptr [edx + field_9800], ecx        # 004d7099
    mov eax, dword ptr [ebp - local_34]          # 004d709f
    mov ecx, dword ptr [ebp - local_34]          # 004d70a2
    mov edx, dword ptr [eax + field_9800]        # 004d70a5
    sub edx, dword ptr [ecx + field_954a]        # 004d70ab
    add edx, 0x1                                 # 004d70b1
    mov eax, dword ptr [ebp - local_34]          # 004d70b4
    mov dword ptr [eax + field_97f8], edx        # 004d70b7
    push 0x55a73c                                # 004d70bd
    mov ecx, dword ptr [ebp - local_34]          # 004d70c2
    add ecx, 0x97f4                              # 004d70c5
    push ecx                                     # 004d70cb
    mov edx, dword ptr [ebp - local_34]          # 004d70cc
    add edx, 0x2bc                               # 004d70cf
    push edx                                     # 004d70d5
    mov eax, dword ptr [ebp - local_34]          # 004d70d6
    mov ecx, dword ptr [eax + field_9506]        # 004d70d9
    push ecx                                     # 004d70df
    mov edx, dword ptr [ebp - local_34]          # 004d70e0
    mov eax, dword ptr [edx + field_9512]        # 004d70e3
    push eax                                     # 004d70e9
    mov ecx, 0x5cf659                            # 004d70ea
    call FUN_004c5b3a                            # 004d70ef
L_004d70f4:
    # block 0x004d70f4: entered by jne at 0x004d6fb1, 9 instruction(s), ends with jne to 0x004d711c (forward)
    mov edi, dword ptr [ebp - local_34]          # 004d70f4
    add edi, 0x96d3                              # 004d70f7
    or ecx, -0x1                                 # 004d70fd
    {load} xor eax, eax                          # 004d7100
    repne scasb al, byte ptr es:[edi]            # 004d7102
    not ecx                                      # 004d7104
    add ecx, -0x1                                # 004d7106
    test ecx, ecx                                # 004d7109
    jne.d8 L_004d711c                            # 004d710b
    # block 0x004d710d: entered by fall-through of jne at 0x004d710b, 3 instruction(s), ends with forward jump to 0x004d7129
    mov ecx, dword ptr [ebp - local_34]          # 004d710d
    mov dword ptr [ecx + field_956e], 0x4        # 004d7110
    jmp.d8 L_004d7129                            # 004d711a
L_004d711c:
    # block 0x004d711c: entered by jne at 0x004d710b, 2 instruction(s), falls into the block at 0x004d7129
    mov edx, dword ptr [ebp - local_34]          # 004d711c
    mov dword ptr [edx + field_956e], 0x1        # 004d711f
L_004d7129:
    # block 0x004d7129: entered by jmp at 0x004d711a, 5 instruction(s), ends with ret
    pop edi                                      # 004d7129
    pop esi                                      # 004d712a
    {load} mov esp, ebp                          # 004d712b
    pop ebp                                      # 004d712d
    ret                                          # 004d712e

# --- data items (not part of the function) -------------------------
.org 0x004d712f - 0x401000
SWTAB_004d712f:  # 6 case address(es)
    .long L_004d6c99 - .text + 0x401000
    .long L_004d6c7f - .text + 0x401000
    .long L_004d6c70 - .text + 0x401000
    .long L_004d6bf4 - .text + 0x401000
    .long L_004d6c27 - .text + 0x401000
    .long L_004d6cd9 - .text + 0x401000
.org 0x004d7147 - 0x401000
IDXTAB_004d7147:  # index table of FUN_004d6b48 for the switch jump at 0x004d6bed (27 byte(s))
    .byte 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
    .byte 5, 5, 5, 5, 5, 5, 1, 2, 3, 5, 4
.set SWTAB_004d712f_VA, SWTAB_004d712f - .text + 0x401000
.set IDXTAB_004d7147_VA, IDXTAB_004d7147 - .text + 0x401000

