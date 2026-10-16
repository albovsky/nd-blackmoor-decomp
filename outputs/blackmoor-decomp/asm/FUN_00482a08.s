# FUN_00482a08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482a08
# extent:       0x00482a08-0x00483aa1 (4249 code bytes)
# span:         0x00482a08-0x00483ac9 (code 4249, tables 40, padding 0)
# sha256:       309e5e28ffbea4279de333282e8e5b2d0bb2272f57dd17e5621767744d2b46bb
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00482a08
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 1 more
# fields:       [eax + n] field_4, field_8, field_a, field_1c, field_1e, field_21, field_28, field_78, field_7c, field_7e, field_92, field_94 and 21 more; [ecx + n] field_2, field_3, field_4, field_8, field_a, field_1c, field_1e, field_20, field_21, field_22, field_24, field_28 and 36 more; [edx + n] field_2, field_1c, field_21, field_22, field_24, field_28, field_78, field_7e, field_92, field_94, field_95, field_a0 and 31 more
# callees:      calls FUN_004c924d, FUN_004d39f9, FUN_004c2790, KERNEL32.dll!GetTickCount, FUN_004fb77a, FUN_004fb2e3, FUN_004fba69, FUN_004f6334, FUN_00448d11, FUN_004c92c5, FUN_004821ab, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1012 instruction(s), 66 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_7e, 0x7e  # offset +0x7e
.equ field_7f, 0x7f  # offset +0x7f
.equ field_83, 0x83  # offset +0x83
.equ field_87, 0x87  # offset +0x87
.equ field_8b, 0x8b  # offset +0x8b
.equ field_8f, 0x8f  # offset +0x8f
.equ field_91, 0x91  # offset +0x91
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94
.equ field_95, 0x95  # offset +0x95
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_a8, 0xa8  # offset +0xa8
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ab, 0xab  # offset +0xab
.equ field_ac, 0xac  # offset +0xac
.equ field_af, 0xaf  # offset +0xaf
.equ field_b3, 0xb3  # offset +0xb3
.equ field_eb, 0xeb  # offset +0xeb
.equ field_ef, 0xef  # offset +0xef
.equ field_f3, 0xf3  # offset +0xf3
.equ field_f7, 0xf7  # offset +0xf7
.equ field_fb, 0xfb  # offset +0xfb
.equ field_fc, 0xfc  # offset +0xfc
.equ field_3d7, 0x3d7  # offset +0x3d7
.equ field_408, 0x408  # offset +0x408
.equ field_439, 0x439  # offset +0x439
.equ field_46a, 0x46a  # offset +0x46a
.equ field_49b, 0x49b  # offset +0x49b
.equ field_4ab, 0x4ab  # offset +0x4ab
.equ field_760, 0x760  # offset +0x760
.equ field_838, 0x838  # offset +0x838
.equ field_83a, 0x83a  # offset +0x83a
.equ field_83c, 0x83c  # offset +0x83c
.equ field_83e, 0x83e  # offset +0x83e
.equ field_840, 0x840  # offset +0x840
.equ field_844, 0x844  # offset +0x844
.equ field_848, 0x848  # offset +0x848
.equ field_84c, 0x84c  # offset +0x84c
.equ field_84e, 0x84e  # offset +0x84e
.equ field_850, 0x850  # offset +0x850
.equ field_852, 0x852  # offset +0x852
.equ field_854, 0x854  # offset +0x854
.equ field_856, 0x856  # offset +0x856
.equ field_858, 0x858  # offset +0x858
.equ field_85a, 0x85a  # offset +0x85a
.equ field_85e, 0x85e  # offset +0x85e
.equ field_862, 0x862  # offset +0x862
.equ field_866, 0x866  # offset +0x866
.equ field_868, 0x868  # offset +0x868
.equ field_86a, 0x86a  # offset +0x86a
.equ field_87c, 0x87c  # offset +0x87c
.equ field_87e, 0x87e  # offset +0x87e
.equ field_89b, 0x89b  # offset +0x89b
.equ field_89d, 0x89d  # offset +0x89d
.equ field_89f, 0x89f  # offset +0x89f
.equ field_8a1, 0x8a1  # offset +0x8a1
.equ field_8a3, 0x8a3  # offset +0x8a3
.equ field_8a7, 0x8a7  # offset +0x8a7
.equ field_8ab, 0x8ab  # offset +0x8ab
.equ field_8af, 0x8af  # offset +0x8af
.equ field_8b1, 0x8b1  # offset +0x8b1
.equ field_8b3, 0x8b3  # offset +0x8b3

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004821ab, .text + (0x004821ab - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00482a08 - 0x401000
.globl FUN_00482a08
FUN_00482a08:
    # block 0x00482a08: entry, 17 instruction(s), ends with je to 0x00482a59 (forward)
    push ebp                                     # 00482a08
    {load} mov ebp, esp                          # 00482a09
    sub esp, 0x34                                # 00482a0b
    push ebx                                     # 00482a0e
    push esi                                     # 00482a0f
    push edi                                     # 00482a10
    mov dword ptr [ebp - local_28], ecx          # 00482a11
    movsx eax, word ptr [ebp + arg_8]            # 00482a14
    imul eax, eax, 0x8d                          # 00482a18
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00482a1e
    mov dword ptr [ebp - local_4], ecx           # 00482a24
    movsx edx, word ptr [ebp + arg_8]            # 00482a27
    imul edx, edx, 0x8d                          # 00482a2b
    mov eax, dword ptr [edx + 0x5bb632]          # 00482a31
    mov dword ptr [ebp - local_2c], eax          # 00482a37
    cmp dword ptr [ebp - local_2c], 0x0          # 00482a3a
    je.d8 L_00482a59                             # 00482a3e
    # block 0x00482a40: entered by fall-through of je at 0x00482a3e, 2 instruction(s), ends with je to 0x00482dd8 (forward)
    cmp dword ptr [ebp - local_2c], 0x1          # 00482a40
    je.d32 L_00482dd8                            # 00482a44
    # block 0x00482a4a: entered by fall-through of je at 0x00482a44, 2 instruction(s), ends with je to 0x004836ae (forward)
    cmp dword ptr [ebp - local_2c], 0x2          # 00482a4a
    je.d32 L_004836ae                            # 00482a4e
    # block 0x00482a54: entered by fall-through of je at 0x00482a4e, 1 instruction(s), ends with forward jump to 0x00483a98
    jmp.d32 L_00483a98                           # 00482a54
L_00482a59:
    # block 0x00482a59: entered by je at 0x00482a3e, 12 instruction(s), ends with je to 0x00482aa3 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00482a59
    mov byte ptr [ecx + field_a8], 0x1           # 00482a5c
    mov dword ptr [0x5bb1ca], 0x1                # 00482a63
    mov edx, dword ptr [ebp - local_28]          # 00482a6d
    mov word ptr [edx + field_a9], 0xffff        # 00482a70
    mov eax, dword ptr [ebp - local_28]          # 00482a79
    mov word ptr [eax + field_a0], 0x7           # 00482a7c
    mov ecx, dword ptr [ebp - local_4]           # 00482a85
    {load} xor edx, edx                          # 00482a88
    mov dl, byte ptr [ecx + field_fb]            # 00482a8a
    test edx, edx                                # 00482a90
    je.d8 L_00482aa3                             # 00482a92
    # block 0x00482a94: entered by fall-through of je at 0x00482a92, 3 instruction(s), ends with forward jump to 0x00482ab0
    mov eax, dword ptr [ebp - local_28]          # 00482a94
    mov dword ptr [eax + field_a2], 0x0          # 00482a97
    jmp.d8 L_00482ab0                            # 00482aa1
L_00482aa3:
    # block 0x00482aa3: entered by je at 0x00482a92, 2 instruction(s), falls into the block at 0x00482ab0
    mov ecx, dword ptr [ebp - local_28]          # 00482aa3
    mov dword ptr [ecx + field_a2], 0x1          # 00482aa6
L_00482ab0:
    # block 0x00482ab0: entered by jmp at 0x00482aa1, 25 instruction(s), ends with je to 0x00482b25 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00482ab0
    mov word ptr [edx + field_a6], 0xffff        # 00482ab3
    mov eax, dword ptr [ebp - local_28]          # 00482abc
    mov cx, word ptr [ebp + arg_8]               # 00482abf
    mov word ptr [eax + field_1e], cx            # 00482ac3
    mov edx, dword ptr [ebp - local_28]          # 00482ac7
    mov byte ptr [edx + field_ab], 0x0           # 00482aca
    mov eax, dword ptr [ebp - local_28]          # 00482ad1
    mov byte ptr [eax + field_ac], 0x0           # 00482ad4
    mov ecx, dword ptr [ebp - local_28]          # 00482adb
    mov word ptr [ecx + field_92], 0x0           # 00482ade
    {load} xor edx, edx                          # 00482ae7
    mov eax, dword ptr [ebp - local_28]          # 00482ae9
    add eax, 0x95                                # 00482aec
    mov dword ptr [eax], edx                     # 00482af1
    mov dword ptr [eax + field_4], edx           # 00482af3
    mov word ptr [eax + field_8], dx             # 00482af6
    mov byte ptr [eax + field_a], dl             # 00482afa
    mov ecx, dword ptr [ebp - local_28]          # 00482afd
    mov byte ptr [ecx + field_91], 0x0           # 00482b00
    mov edx, dword ptr [ebp - local_4]           # 00482b07
    {load} xor eax, eax                          # 00482b0a
    mov al, byte ptr [edx + field_21]            # 00482b0c
    test eax, eax                                # 00482b0f
    je.d8 L_00482b25                             # 00482b11
    # block 0x00482b13: entered by fall-through of je at 0x00482b11, 5 instruction(s), calls FUN_004c924d, falls into the block at 0x00482b25
    mov ecx, dword ptr [ebp - local_4]           # 00482b13
    mov dx, word ptr [ecx + field_22]            # 00482b16
    push edx                                     # 00482b1a
    mov ecx, 0x5cf659                            # 00482b1b
    call FUN_004c924d                            # 00482b20
L_00482b25:
    # block 0x00482b25: entered by je at 0x00482b11, 8 instruction(s), ends with forward jump to 0x00482b58
    mov eax, dword ptr [ebp - local_28]          # 00482b25
    mov word ptr [eax + field_7c], 0x0           # 00482b28
    mov ecx, dword ptr [ebp - local_28]          # 00482b2e
    mov word ptr [ecx + field_8f], 0x0           # 00482b31
    mov edx, dword ptr [ebp - local_28]          # 00482b3a
    mov byte ptr [edx + field_94], 0x0           # 00482b3d
    mov word ptr [ebp - local_c], 0x0            # 00482b44
    jmp.d8 L_00482b58                            # 00482b4a
L_00482b4c:
    # block 0x00482b4c: entered by jmp at 0x00482b79, 3 instruction(s), falls into the block at 0x00482b58
    mov ax, word ptr [ebp - local_c]             # 00482b4c
    .insn 0x66, 0x05, 0x0001{:u16}               # 00482b50
    mov word ptr [ebp - local_c], ax             # 00482b54
L_00482b58:
    # block 0x00482b58: entered by jmp at 0x00482b4a, 5 instruction(s), ends with jge to 0x00482b7b (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00482b58
    mov edx, dword ptr [ebp - local_4]           # 00482b5c
    movsx eax, word ptr [edx + field_fc]         # 00482b5f
    {load} cmp ecx, eax                          # 00482b66
    jge.d8 L_00482b7b                            # 00482b68
    # block 0x00482b6a: entered by fall-through of jge at 0x00482b68, 4 instruction(s), ends with backward jump to 0x00482b4c
    movsx ecx, word ptr [ebp - local_c]          # 00482b6a
    mov edx, dword ptr [ebp - local_28]          # 00482b6e
    mov dword ptr [edx + 4*ecx + field_28], 0x0  # 00482b71
    jmp.d8 L_00482b4c                            # 00482b79
L_00482b7b:
    # block 0x00482b7b: entered by jge at 0x00482b68, 57 instruction(s), calls FUN_004d39f9, ends with jne to 0x00482c83 (forward)
    call FUN_004d39f9                            # 00482b7b
    mov ecx, dword ptr [ebp - local_28]          # 00482b80
    mov word ptr [ecx + field_1c], ax            # 00482b83
    mov edx, dword ptr [ebp - local_28]          # 00482b87
    movsx eax, word ptr [edx + field_1c]         # 00482b8a
    imul eax, eax, 0x4a                          # 00482b8e
    mov dword ptr [eax + 0x5d1591], 0xa          # 00482b91
    mov ecx, dword ptr [ebp - local_28]          # 00482b9b
    movsx edx, word ptr [ecx + field_1c]         # 00482b9e
    imul edx, edx, 0x4a                          # 00482ba2
    mov dword ptr [edx + 0x5d1595], 0x483ad9     # 00482ba5
    mov eax, dword ptr [ebp - local_28]          # 00482baf
    movsx ecx, word ptr [eax + field_1c]         # 00482bb2
    imul ecx, ecx, 0x4a                          # 00482bb6
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00482bb9
    mov edx, dword ptr [ebp - local_28]          # 00482bc3
    movsx eax, word ptr [edx + field_1c]         # 00482bc6
    imul eax, eax, 0x4a                          # 00482bca
    mov dword ptr [eax + 0x5d159d], 0x0          # 00482bcd
    mov ecx, dword ptr [ebp - local_28]          # 00482bd7
    movsx edx, word ptr [ecx + field_1c]         # 00482bda
    imul edx, edx, 0x4a                          # 00482bde
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00482be1
    mov eax, dword ptr [ebp - local_28]          # 00482beb
    movsx ecx, word ptr [eax + field_1c]         # 00482bee
    imul ecx, ecx, 0x4a                          # 00482bf2
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00482bf5
    mov edx, dword ptr [ebp - local_28]          # 00482bff
    movsx eax, word ptr [edx + field_1c]         # 00482c02
    imul eax, eax, 0x4a                          # 00482c06
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00482c09
    mov ecx, dword ptr [ebp - local_28]          # 00482c13
    movsx edx, word ptr [ecx + field_1c]         # 00482c16
    imul edx, edx, 0x4a                          # 00482c1a
    mov word ptr [edx + 0x5d15ad], 0x0           # 00482c1d
    mov edi, 0x54d8b4                            # 00482c26
    mov eax, dword ptr [ebp - local_28]          # 00482c2b
    movsx ecx, word ptr [eax + field_1c]         # 00482c2e
    imul ecx, ecx, 0x4a                          # 00482c32
    add ecx, 0x5d15b3                            # 00482c35
    {load} mov edx, ecx                          # 00482c3b
    or ecx, -0x1                                 # 00482c3d
    {load} xor eax, eax                          # 00482c40
    repne scasb al, byte ptr es:[edi]            # 00482c42
    not ecx                                      # 00482c44
    {load} sub edi, ecx                          # 00482c46
    {load} mov esi, edi                          # 00482c48
    {load} mov eax, ecx                          # 00482c4a
    {load} mov edi, edx                          # 00482c4c
    shr ecx, 0x2                                 # 00482c4e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00482c51
    {load} mov ecx, eax                          # 00482c53
    and ecx, 0x3                                 # 00482c55
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00482c58
    mov ecx, dword ptr [ebp - local_28]          # 00482c5a
    cmp dword ptr [ecx + field_20], 0x0          # 00482c5d
    jne.d8 L_00482c83                            # 00482c61
    # block 0x00482c63: entered by fall-through of jne at 0x00482c61, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00482c83
    push 0x54d8c8                                # 00482c63
    push 0x6                                     # 00482c68
    mov edx, dword ptr [ebp - local_4]           # 00482c6a
    push edx                                     # 00482c6d
    push 0x54d8dc                                # 00482c6e
    mov ecx, 0x5cf659                            # 00482c73
    call FUN_004c2790                            # 00482c78
    mov ecx, dword ptr [ebp - local_28]          # 00482c7d
    mov dword ptr [ecx + field_20], eax          # 00482c80
L_00482c83:
    # block 0x00482c83: entered by jne at 0x00482c61, 3 instruction(s), ends with jne to 0x00482ce3 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00482c83
    cmp dword ptr [edx + field_24], 0x0          # 00482c86
    jne.d8 L_00482ce3                            # 00482c8a
    # block 0x00482c8c: entered by fall-through of jne at 0x00482c8a, 9 instruction(s), ends with je to 0x00482ce3 (forward)
    mov edi, dword ptr [ebp - local_4]           # 00482c8c
    add edi, 0x24                                # 00482c8f
    or ecx, -0x1                                 # 00482c92
    {load} xor eax, eax                          # 00482c95
    repne scasb al, byte ptr es:[edi]            # 00482c97
    not ecx                                      # 00482c99
    add ecx, -0x1                                # 00482c9b
    test ecx, ecx                                # 00482c9e
    je.d8 L_00482ce3                             # 00482ca0
    # block 0x00482ca2: entered by fall-through of je at 0x00482ca0, 18 instruction(s), calls FUN_004c2790, KERNEL32.dll!GetTickCount, ends with forward jump to 0x00482cf4
    push 0x54d8e4                                # 00482ca2
    push 0x6                                     # 00482ca7
    mov eax, dword ptr [ebp - local_4]           # 00482ca9
    add eax, 0x24                                # 00482cac
    push eax                                     # 00482caf
    push 0x54d8fc                                # 00482cb0
    mov ecx, 0x5cf659                            # 00482cb5
    call FUN_004c2790                            # 00482cba
    mov ecx, dword ptr [ebp - local_28]          # 00482cbf
    mov dword ptr [ecx + field_24], eax          # 00482cc2
    mov edx, dword ptr [ebp - local_28]          # 00482cc5
    mov byte ptr [edx + field_7e], 0x1           # 00482cc8
    call dword ptr [0x52a23c]                    # 00482ccc
    mov ecx, dword ptr [ebp - local_4]           # 00482cd2
    add eax, dword ptr [ecx + field_45]          # 00482cd5
    mov edx, dword ptr [ebp - local_28]          # 00482cd8
    mov dword ptr [edx + field_b3], eax          # 00482cdb
    jmp.d8 L_00482cf4                            # 00482ce1
L_00482ce3:
    # block 0x00482ce3: entered by jne at 0x00482c8a; je at 0x00482ca0, 4 instruction(s), falls into the block at 0x00482cf4
    mov eax, dword ptr [ebp - local_28]          # 00482ce3
    mov byte ptr [eax + field_7e], 0x0           # 00482ce6
    mov ecx, dword ptr [ebp - local_28]          # 00482cea
    mov dword ptr [ecx + field_24], 0x0          # 00482ced
L_00482cf4:
    # block 0x00482cf4: entered by jmp at 0x00482ce1, 29 instruction(s), ends with je to 0x00482db2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00482cf4
    mov eax, dword ptr [edx + field_ef]          # 00482cf7
    add eax, dword ptr [0x58318a]                # 00482cfd
    mov ecx, dword ptr [ebp - local_28]          # 00482d03
    mov dword ptr [ecx + field_83], eax          # 00482d06
    mov edx, dword ptr [ebp - local_4]           # 00482d0c
    mov eax, dword ptr [edx + field_f7]          # 00482d0f
    add eax, dword ptr [0x58318a]                # 00482d15
    mov ecx, dword ptr [ebp - local_28]          # 00482d1b
    mov dword ptr [ecx + field_8b], eax          # 00482d1e
    mov edx, dword ptr [ebp - local_4]           # 00482d24
    mov eax, dword ptr [edx + field_eb]          # 00482d27
    add eax, dword ptr [0x583186]                # 00482d2d
    mov ecx, dword ptr [ebp - local_28]          # 00482d33
    mov dword ptr [ecx + field_7f], eax          # 00482d36
    mov edx, dword ptr [ebp - local_4]           # 00482d39
    mov eax, dword ptr [edx + field_f3]          # 00482d3c
    add eax, dword ptr [0x583186]                # 00482d42
    mov ecx, dword ptr [ebp - local_28]          # 00482d48
    mov dword ptr [ecx + field_87], eax          # 00482d4b
    mov edx, dword ptr [ebp - local_28]          # 00482d51
    mov dword ptr [edx + field_af], 0x0          # 00482d54
    mov edi, 0x54d904                            # 00482d5e
    mov esi, dword ptr [ebp - local_4]           # 00482d63
    add esi, 0x3e7                               # 00482d66
    mov ecx, 0x9                                 # 00482d6c
    {load} xor eax, eax                          # 00482d71
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00482d73
    je.d8 L_00482db2                             # 00482d75
    # block 0x00482d77: entered by fall-through of je at 0x00482d75, 14 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00482db2
    mov ecx, dword ptr [ebp - local_4]           # 00482d77
    add ecx, 0x3e7                               # 00482d7a
    push ecx                                     # 00482d80
    mov ecx, 0x5c3a67                            # 00482d81
    call FUN_004fb77a                            # 00482d86
    mov edx, dword ptr [ebp - local_4]           # 00482d8b
    mov ax, word ptr [edx + field_408]           # 00482d8e
    push eax                                     # 00482d95
    mov ecx, 0x5c3a67                            # 00482d96
    call FUN_004fb2e3                            # 00482d9b
    mov ecx, dword ptr [ebp - local_4]           # 00482da0
    add ecx, 0x3e7                               # 00482da3
    mov edx, dword ptr [ebp - local_28]          # 00482da9
    mov dword ptr [edx + field_af], ecx          # 00482dac
L_00482db2:
    # block 0x00482db2: entered by je at 0x00482d75, 7 instruction(s), ends with forward jump to 0x00483a98
    mov eax, dword ptr [ebp - local_28]          # 00482db2
    mov dword ptr [eax + field_78], 0x0          # 00482db5
    mov ecx, dword ptr [ebp - local_28]          # 00482dbc
    movsx edx, word ptr [ecx + field_1e]         # 00482dbf
    imul edx, edx, 0x8d                          # 00482dc3
    mov dword ptr [edx + 0x5bb632], 0x1          # 00482dc9
    jmp.d32 L_00483a98                           # 00482dd3
L_00482dd8:
    # block 0x00482dd8: entered by je at 0x00482a44, 5 instruction(s), ends with ja to 0x004836a9 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00482dd8
    mov ecx, dword ptr [eax + field_78]          # 00482ddb
    mov dword ptr [ebp - local_30], ecx          # 00482dde
    cmp dword ptr [ebp - local_30], 0x9          # 00482de1
    ja.d32 L_004836a9                            # 00482de5
    # block 0x00482deb: entered by fall-through of ja at 0x00482de5, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x483aa1]
    mov edx, dword ptr [ebp - local_30]          # 00482deb
    jmp dword ptr [4*edx + SWTAB_00483aa1_VA]    # 00482dee
L_00482df5:
    # block 0x00482df5: entered by switch case, 4 instruction(s), ends with je to 0x00482e38 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00482df5
    movsx ecx, word ptr [eax + field_a9]         # 00482df8
    cmp ecx, -0x1                                # 00482dff
    je.d8 L_00482e38                             # 00482e02
    # block 0x00482e04: entered by fall-through of je at 0x00482e02, 12 instruction(s), calls FUN_004fba69, ends with forward jump to 0x00482e85
    mov edx, dword ptr [ebp - local_4]           # 00482e04
    add edx, 0x3e7                               # 00482e07
    push edx                                     # 00482e0d
    mov ecx, 0x5c3a67                            # 00482e0e
    call FUN_004fba69                            # 00482e13
    mov eax, dword ptr [ebp - local_28]          # 00482e18
    mov dword ptr [eax + field_af], 0x0          # 00482e1b
    mov ecx, dword ptr [ebp - local_28]          # 00482e25
    mov dword ptr [ecx + field_78], 0x1          # 00482e28
    mov edx, dword ptr [ebp - local_28]          # 00482e2f
    mov byte ptr [edx + field_7e], 0x0           # 00482e32
    jmp.d8 L_00482e85                            # 00482e36
L_00482e38:
    # block 0x00482e38: entered by je at 0x00482e02, 5 instruction(s), ends with je to 0x00482e85 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00482e38
    {load} xor ecx, ecx                          # 00482e3b
    mov cl, byte ptr [eax + field_7e]            # 00482e3d
    test ecx, ecx                                # 00482e40
    je.d8 L_00482e85                             # 00482e42
    # block 0x00482e44: entered by fall-through of je at 0x00482e42, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00482e85 (forward)
    call dword ptr [0x52a23c]                    # 00482e44
    mov edx, dword ptr [ebp - local_28]          # 00482e4a
    cmp eax, dword ptr [edx + field_b3]          # 00482e4d
    jbe.d8 L_00482e85                            # 00482e53
    # block 0x00482e55: entered by fall-through of jbe at 0x00482e53, 14 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00482e85
    mov eax, dword ptr [ebp - local_28]          # 00482e55
    movsx eax, word ptr [eax + field_7c]         # 00482e58
    add eax, 0x1                                 # 00482e5c
    mov ecx, dword ptr [ebp - local_4]           # 00482e5f
    movsx ecx, word ptr [ecx + field_49]         # 00482e62
    cdq                                          # 00482e66
    idiv ecx                                     # 00482e67
    mov eax, dword ptr [ebp - local_28]          # 00482e69
    mov word ptr [eax + field_7c], dx            # 00482e6c
    call dword ptr [0x52a23c]                    # 00482e70
    mov ecx, dword ptr [ebp - local_4]           # 00482e76
    add eax, dword ptr [ecx + field_45]          # 00482e79
    mov edx, dword ptr [ebp - local_28]          # 00482e7c
    mov dword ptr [edx + field_b3], eax          # 00482e7f
L_00482e85:
    # block 0x00482e85: entered by jmp at 0x00482e36; je at 0x00482e42; jbe at 0x00482e53; switch case, 4 instruction(s), ends with je to 0x00482ff4 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00482e85
    movsx ecx, word ptr [eax + field_a9]         # 00482e88
    cmp ecx, -0x1                                # 00482e8f
    je.d32 L_00482ff4                            # 00482e92
    # block 0x00482e98: entered by fall-through of je at 0x00482e92, 7 instruction(s), ends with je to 0x00482fe3 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00482e98
    movsx eax, word ptr [edx + field_a9]         # 00482e9b
    mov ecx, dword ptr [ebp - local_28]          # 00482ea2
    mov edx, dword ptr [ecx + 4*eax + field_28]  # 00482ea5
    mov dword ptr [ebp - local_34], edx          # 00482ea9
    cmp dword ptr [ebp - local_34], 0x0          # 00482eac
    je.d32 L_00482fe3                            # 00482eb0
    # block 0x00482eb6: entered by fall-through of je at 0x00482eb0, 2 instruction(s), ends with je to 0x00482ecb (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 00482eb6
    je.d8 L_00482ecb                             # 00482eba
    # block 0x00482ebc: entered by fall-through of je at 0x00482eba, 2 instruction(s), ends with je to 0x00482f8c (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 00482ebc
    je.d32 L_00482f8c                            # 00482ec0
    # block 0x00482ec6: entered by fall-through of je at 0x00482ec0, 1 instruction(s), ends with forward jump to 0x00482fef
    jmp.d32 L_00482fef                           # 00482ec6
L_00482ecb:
    # block 0x00482ecb: entered by je at 0x00482eba, 29 instruction(s), ends with je to 0x00482f75 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00482ecb
    movsx ecx, word ptr [eax + field_a9]         # 00482ece
    imul ecx, ecx, 0x21                          # 00482ed5
    mov edx, dword ptr [ebp - local_4]           # 00482ed8
    lea eax, [edx + ecx + field_4ab]             # 00482edb
    {load} mov edi, eax                          # 00482ee2
    mov ecx, dword ptr [ebp - local_4]           # 00482ee4
    add ecx, 0x47a                               # 00482ee7
    {load} mov edx, ecx                          # 00482eed
    or ecx, -0x1                                 # 00482eef
    {load} xor eax, eax                          # 00482ef2
    repne scasb al, byte ptr es:[edi]            # 00482ef4
    not ecx                                      # 00482ef6
    {load} sub edi, ecx                          # 00482ef8
    {load} mov esi, edi                          # 00482efa
    {load} mov eax, ecx                          # 00482efc
    {load} mov edi, edx                          # 00482efe
    shr ecx, 0x2                                 # 00482f00
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00482f03
    {load} mov ecx, eax                          # 00482f05
    and ecx, 0x3                                 # 00482f07
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00482f0a
    mov edi, 0x54d910                            # 00482f0c
    mov esi, dword ptr [ebp - local_4]           # 00482f11
    add esi, 0x47a                               # 00482f14
    mov ecx, 0x9                                 # 00482f1a
    {load} xor edx, edx                          # 00482f1f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00482f21
    je.d8 L_00482f75                             # 00482f23
    # block 0x00482f25: entered by fall-through of je at 0x00482f23, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00482f8a
    mov eax, dword ptr [ebp - local_4]           # 00482f25
    add eax, 0x47a                               # 00482f28
    push eax                                     # 00482f2d
    mov ecx, 0x5c3a67                            # 00482f2e
    call FUN_004fb77a                            # 00482f33
    mov ecx, dword ptr [ebp - local_4]           # 00482f38
    mov dx, word ptr [ecx + field_49b]           # 00482f3b
    push edx                                     # 00482f42
    mov ecx, 0x5c3a67                            # 00482f43
    call FUN_004fb2e3                            # 00482f48
    mov eax, dword ptr [ebp - local_4]           # 00482f4d
    add eax, 0x47a                               # 00482f50
    mov ecx, dword ptr [ebp - local_28]          # 00482f55
    mov dword ptr [ecx + field_af], eax          # 00482f58
    mov edx, dword ptr [ebp - local_28]          # 00482f5e
    movsx eax, word ptr [edx + field_a9]         # 00482f61
    mov ecx, dword ptr [ebp - local_28]          # 00482f68
    mov dword ptr [ecx + 4*eax + field_28], 0x2  # 00482f6b
    jmp.d8 L_00482f8a                            # 00482f73
L_00482f75:
    # block 0x00482f75: entered by je at 0x00482f23, 4 instruction(s), falls into the block at 0x00482f8a
    mov edx, dword ptr [ebp - local_28]          # 00482f75
    movsx eax, word ptr [edx + field_a9]         # 00482f78
    mov ecx, dword ptr [ebp - local_28]          # 00482f7f
    mov dword ptr [ecx + 4*eax + field_28], 0x0  # 00482f82
L_00482f8a:
    # block 0x00482f8a: entered by jmp at 0x00482f73, 1 instruction(s), ends with forward jump to 0x00482fef
    jmp.d8 L_00482fef                            # 00482f8a
L_00482f8c:
    # block 0x00482f8c: entered by je at 0x00482ec0, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00482fe1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00482f8c
    movsx eax, word ptr [edx + field_49b]        # 00482f8f
    mov dword ptr [ebp - local_14], eax          # 00482f96
    mov ecx, dword ptr [ebp - local_14]          # 00482f99
    push ecx                                     # 00482f9c
    mov ecx, 0x5cf1eb                            # 00482f9d
    call FUN_004f6334                            # 00482fa2
    test eax, eax                                # 00482fa7
    jne.d8 L_00482fe1                            # 00482fa9
    # block 0x00482fab: entered by fall-through of jne at 0x00482fa9, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x00482fe1
    mov edx, dword ptr [ebp - local_4]           # 00482fab
    add edx, 0x47a                               # 00482fae
    push edx                                     # 00482fb4
    mov ecx, 0x5c3a67                            # 00482fb5
    call FUN_004fba69                            # 00482fba
    mov eax, dword ptr [ebp - local_28]          # 00482fbf
    mov dword ptr [eax + field_af], 0x0          # 00482fc2
    mov ecx, dword ptr [ebp - local_28]          # 00482fcc
    movsx edx, word ptr [ecx + field_a9]         # 00482fcf
    mov eax, dword ptr [ebp - local_28]          # 00482fd6
    mov dword ptr [eax + 4*edx + field_28], 0x0  # 00482fd9
L_00482fe1:
    # block 0x00482fe1: entered by jne at 0x00482fa9, 1 instruction(s), ends with forward jump to 0x00482fef
    jmp.d8 L_00482fef                            # 00482fe1
L_00482fe3:
    # block 0x00482fe3: entered by je at 0x00482eb0, 2 instruction(s), falls into the block at 0x00482fef
    mov ecx, dword ptr [ebp - local_28]          # 00482fe3
    mov word ptr [ecx + field_a9], 0xffff        # 00482fe6
L_00482fef:
    # block 0x00482fef: entered by jmp at 0x00482ec6; jmp at 0x00482f8a; jmp at 0x00482fe1, 1 instruction(s), ends with forward jump to 0x004831d8
    jmp.d32 L_004831d8                           # 00482fef
L_00482ff4:
    # block 0x00482ff4: entered by je at 0x00482e92, 5 instruction(s), ends with je to 0x00483192 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00482ff4
    {load} xor eax, eax                          # 00482ff7
    mov al, byte ptr [edx + field_fb]            # 00482ff9
    test eax, eax                                # 00482fff
    je.d32 L_00483192                            # 00483001
    # block 0x00483007: entered by fall-through of je at 0x00483001, 5 instruction(s), ends with jne to 0x00483192 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00483007
    {load} xor edx, edx                          # 0048300a
    mov dl, byte ptr [ecx + field_91]            # 0048300c
    test edx, edx                                # 00483012
    jne.d32 L_00483192                           # 00483014
    # block 0x0048301a: entered by fall-through of jne at 0x00483014, 4 instruction(s), ends with jle to 0x00483119 (forward)
    mov eax, dword ptr [ebp - local_28]          # 0048301a
    movsx ecx, word ptr [eax + field_92]         # 0048301d
    test ecx, ecx                                # 00483024
    jle.d32 L_00483119                           # 00483026
    # block 0x0048302c: entered by fall-through of jle at 0x00483026, 3 instruction(s), ends with jne to 0x00483119 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0048302c
    cmp dword ptr [edx + field_a2], 0x0          # 0048302f
    jne.d32 L_00483119                           # 00483036
    # block 0x0048303c: entered by fall-through of jne at 0x00483036, 2 instruction(s), ends with forward jump to 0x00483050
    mov word ptr [ebp - local_c], 0x0            # 0048303c
    jmp.d8 L_00483050                            # 00483042
L_00483044:
    # block 0x00483044: entered by jmp at 0x00483114, 3 instruction(s), falls into the block at 0x00483050
    mov ax, word ptr [ebp - local_c]             # 00483044
    .insn 0x66, 0x05, 0x0001{:u16}               # 00483048
    mov word ptr [ebp - local_c], ax             # 0048304c
L_00483050:
    # block 0x00483050: entered by jmp at 0x00483042, 5 instruction(s), ends with jge to 0x00483119 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00483050
    mov edx, dword ptr [ebp - local_4]           # 00483054
    movsx eax, word ptr [edx + field_87c]        # 00483057
    {load} cmp ecx, eax                          # 0048305e
    jge.d32 L_00483119                           # 00483060
    # block 0x00483066: entered by fall-through of jge at 0x00483060, 2 instruction(s), ends with forward jump to 0x0048307a
    mov word ptr [ebp - local_8], 0x0            # 00483066
    jmp.d8 L_0048307a                            # 0048306c
L_0048306e:
    # block 0x0048306e: entered by jmp at 0x0048310f, 3 instruction(s), falls into the block at 0x0048307a
    mov cx, word ptr [ebp - local_8]             # 0048306e
    add cx, 0x1                                  # 00483072
    mov word ptr [ebp - local_8], cx             # 00483076
L_0048307a:
    # block 0x0048307a: entered by jmp at 0x0048306c, 3 instruction(s), ends with jge to 0x00483114 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0048307a
    cmp edx, 0x7                                 # 0048307e
    jge.d32 L_00483114                           # 00483081
    # block 0x00483087: entered by fall-through of jge at 0x00483081, 13 instruction(s), ends with je to 0x004830ca (forward)
    movsx eax, word ptr [ebp - local_c]          # 00483087
    imul eax, eax, 0x37                          # 0048308b
    mov ecx, dword ptr [ebp - local_4]           # 0048308e
    lea edx, [ecx + eax + field_87e]             # 00483091
    movsx eax, word ptr [ebp - local_8]          # 00483098
    {load} xor ecx, ecx                          # 0048309c
    mov cl, byte ptr [edx + eax + field_2]       # 0048309e
    movsx edx, word ptr [ebp - local_8]          # 004830a2
    mov eax, dword ptr [ebp - local_28]          # 004830a6
    {load} xor ebx, ebx                          # 004830a9
    mov bl, byte ptr [eax + edx + field_95]      # 004830ab
    {load} cmp ecx, ebx                          # 004830b2
    je.d8 L_004830ca                             # 004830b4
    # block 0x004830b6: entered by fall-through of je at 0x004830b4, 4 instruction(s), ends with forward jump to 0x0048310f
    mov ecx, dword ptr [ebp - local_28]          # 004830b6
    mov word ptr [ecx + field_a0], 0x7           # 004830b9
    mov word ptr [ebp - local_8], 0x7            # 004830c2
    jmp.d8 L_0048310f                            # 004830c8
L_004830ca:
    # block 0x004830ca: entered by je at 0x004830b4, 9 instruction(s), ends with jne to 0x0048310f (forward)
    movsx edx, word ptr [ebp - local_c]          # 004830ca
    imul edx, edx, 0x37                          # 004830ce
    mov eax, dword ptr [ebp - local_4]           # 004830d1
    lea ecx, [eax + edx + field_87e]             # 004830d4
    movsx edx, word ptr [ebp - local_8]          # 004830db
    {load} xor eax, eax                          # 004830df
    mov al, byte ptr [ecx + edx + field_3]       # 004830e1
    cmp eax, 0xa                                 # 004830e5
    jne.d8 L_0048310f                            # 004830e8
    # block 0x004830ea: entered by fall-through of jne at 0x004830e8, 8 instruction(s), falls into the block at 0x0048310f
    movsx ecx, word ptr [ebp - local_8]          # 004830ea
    add ecx, 0x1                                 # 004830ee
    mov edx, dword ptr [ebp - local_28]          # 004830f1
    mov word ptr [edx + field_a0], cx            # 004830f4
    mov word ptr [ebp - local_8], 0x7            # 004830fb
    mov eax, dword ptr [ebp - local_4]           # 00483101
    mov cx, word ptr [eax + field_87c]           # 00483104
    mov word ptr [ebp - local_c], cx             # 0048310b
L_0048310f:
    # block 0x0048310f: entered by jmp at 0x004830c8; jne at 0x004830e8, 1 instruction(s), ends with backward jump to 0x0048306e
    jmp.d32 L_0048306e                           # 0048310f
L_00483114:
    # block 0x00483114: entered by jge at 0x00483081, 1 instruction(s), ends with backward jump to 0x00483044
    jmp.d32 L_00483044                           # 00483114
L_00483119:
    # block 0x00483119: entered by jle at 0x00483026; jne at 0x00483036; jge at 0x00483060, 3 instruction(s), ends with jne to 0x0048313d (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483119
    cmp dword ptr [edx + field_a2], 0x0          # 0048311c
    jne.d8 L_0048313d                            # 00483123
    # block 0x00483125: entered by fall-through of jne at 0x00483123, 6 instruction(s), ends with jge to 0x00483158 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00483125
    movsx ecx, word ptr [eax + field_92]         # 00483128
    mov edx, dword ptr [ebp - local_28]          # 0048312f
    movsx eax, word ptr [edx + field_a0]         # 00483132
    {load} cmp ecx, eax                          # 00483139
    jge.d8 L_00483158                            # 0048313b
L_0048313d:
    # block 0x0048313d: entered by jne at 0x00483123; fall-through of jge at 0x0048313b, 3 instruction(s), ends with jne to 0x00483190 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0048313d
    cmp dword ptr [ecx + field_a2], 0x1          # 00483140
    jne.d8 L_00483190                            # 00483147
    # block 0x00483149: entered by fall-through of jne at 0x00483147, 4 instruction(s), ends with jl to 0x00483190 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483149
    movsx eax, word ptr [edx + field_92]         # 0048314c
    cmp eax, 0xb                                 # 00483153
    jl.d8 L_00483190                             # 00483156
L_00483158:
    # block 0x00483158: entered by jge at 0x0048313b; fall-through of jl at 0x00483156, 2 instruction(s), ends with je to 0x00483186 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 00483158
    je.d8 L_00483186                             # 0048315f
    # block 0x00483161: entered by fall-through of je at 0x0048315f, 5 instruction(s), ends with jne to 0x00483186 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00483161
    {load} xor edx, edx                          # 00483164
    mov dl, byte ptr [ecx + field_21]            # 00483166
    test edx, edx                                # 00483169
    jne.d8 L_00483186                            # 0048316b
    # block 0x0048316d: entered by fall-through of jne at 0x0048316b, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x00483186
    push 0x0                                     # 0048316d
    push -0x1                                    # 0048316f
    push 0x54d91c                                # 00483171
    mov eax, dword ptr [0x5d03b3]                # 00483176
    push eax                                     # 0048317b
    mov ecx, 0x619a05                            # 0048317c
    call FUN_00448d11                            # 00483181
L_00483186:
    # block 0x00483186: entered by je at 0x0048315f; jne at 0x0048316b, 2 instruction(s), falls into the block at 0x00483190
    mov ecx, dword ptr [ebp - local_28]          # 00483186
    mov dword ptr [ecx + field_78], 0x2          # 00483189
L_00483190:
    # block 0x00483190: entered by jne at 0x00483147; jl at 0x00483156, 1 instruction(s), ends with forward jump to 0x004831d8
    jmp.d8 L_004831d8                            # 00483190
L_00483192:
    # block 0x00483192: entered by je at 0x00483001; jne at 0x00483014, 4 instruction(s), ends with jle to 0x004831d8 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483192
    movsx eax, word ptr [edx + field_92]         # 00483195
    cmp eax, 0xb                                 # 0048319c
    jle.d8 L_004831d8                            # 0048319f
    # block 0x004831a1: entered by fall-through of jle at 0x0048319f, 13 instruction(s), falls into the block at 0x004831d8
    mov ecx, dword ptr [ebp - local_28]          # 004831a1
    mov word ptr [ecx + field_92], 0x0           # 004831a4
    mov edx, dword ptr [ebp - local_28]          # 004831ad
    mov byte ptr [edx + field_94], 0x1           # 004831b0
    {load} xor eax, eax                          # 004831b7
    mov ecx, dword ptr [ebp - local_28]          # 004831b9
    add ecx, 0x95                                # 004831bc
    mov dword ptr [ecx], eax                     # 004831c2
    mov dword ptr [ecx + field_4], eax           # 004831c4
    mov word ptr [ecx + field_8], ax             # 004831c7
    mov byte ptr [ecx + field_a], al             # 004831cb
    mov edx, dword ptr [ebp - local_28]          # 004831ce
    mov dword ptr [edx + field_78], 0x1          # 004831d1
L_004831d8:
    # block 0x004831d8: entered by jmp at 0x00482fef; jmp at 0x00483190; jle at 0x0048319f, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 004831d8
L_004831dd:
    # block 0x004831dd: entered by switch case, 7 instruction(s), ends with je to 0x0048323d (forward)
    mov edi, 0x54d930                            # 004831dd
    mov esi, dword ptr [ebp - local_4]           # 004831e2
    add esi, 0x3b6                               # 004831e5
    mov ecx, 0x9                                 # 004831eb
    {load} xor eax, eax                          # 004831f0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004831f2
    je.d8 L_0048323d                             # 004831f4
    # block 0x004831f6: entered by fall-through of je at 0x004831f4, 17 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00483247
    mov ecx, dword ptr [ebp - local_4]           # 004831f6
    add ecx, 0x3b6                               # 004831f9
    push ecx                                     # 004831ff
    mov ecx, 0x5c3a67                            # 00483200
    call FUN_004fb77a                            # 00483205
    mov edx, dword ptr [ebp - local_4]           # 0048320a
    mov ax, word ptr [edx + field_3d7]           # 0048320d
    push eax                                     # 00483214
    mov ecx, 0x5c3a67                            # 00483215
    call FUN_004fb2e3                            # 0048321a
    mov ecx, dword ptr [ebp - local_4]           # 0048321f
    add ecx, 0x3b6                               # 00483222
    mov edx, dword ptr [ebp - local_28]          # 00483228
    mov dword ptr [edx + field_af], ecx          # 0048322b
    mov eax, dword ptr [ebp - local_28]          # 00483231
    mov dword ptr [eax + field_78], 0x3          # 00483234
    jmp.d8 L_00483247                            # 0048323b
L_0048323d:
    # block 0x0048323d: entered by je at 0x004831f4, 2 instruction(s), falls into the block at 0x00483247
    mov ecx, dword ptr [ebp - local_28]          # 0048323d
    mov dword ptr [ecx + field_78], 0x4          # 00483240
L_00483247:
    # block 0x00483247: entered by jmp at 0x0048323b, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 00483247
L_0048324c:
    # block 0x0048324c: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00483296 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048324c
    movsx eax, word ptr [edx + field_3d7]        # 0048324f
    mov dword ptr [ebp - local_18], eax          # 00483256
    mov ecx, dword ptr [ebp - local_18]          # 00483259
    push ecx                                     # 0048325c
    mov ecx, 0x5cf1eb                            # 0048325d
    call FUN_004f6334                            # 00483262
    test eax, eax                                # 00483267
    jne.d8 L_00483296                            # 00483269
    # block 0x0048326b: entered by fall-through of jne at 0x00483269, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x00483296
    mov edx, dword ptr [ebp - local_4]           # 0048326b
    add edx, 0x3b6                               # 0048326e
    push edx                                     # 00483274
    mov ecx, 0x5c3a67                            # 00483275
    call FUN_004fba69                            # 0048327a
    mov eax, dword ptr [ebp - local_28]          # 0048327f
    mov dword ptr [eax + field_af], 0x0          # 00483282
    mov ecx, dword ptr [ebp - local_28]          # 0048328c
    mov dword ptr [ecx + field_78], 0x4          # 0048328f
L_00483296:
    # block 0x00483296: entered by jne at 0x00483269, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 00483296
L_0048329b:
    # block 0x0048329b: entered by switch case, 3 instruction(s), ends with forward jump to 0x004832b6
    mov dword ptr [ebp - local_10], 0x1          # 0048329b
    mov word ptr [ebp - local_c], 0x0            # 004832a2
    jmp.d8 L_004832b6                            # 004832a8
L_004832aa:
    # block 0x004832aa: entered by jmp at 0x004833a0, 3 instruction(s), falls into the block at 0x004832b6
    mov dx, word ptr [ebp - local_c]             # 004832aa
    add dx, 0x1                                  # 004832ae
    mov word ptr [ebp - local_c], dx             # 004832b2
L_004832b6:
    # block 0x004832b6: entered by jmp at 0x004832a8, 5 instruction(s), ends with jge to 0x004833a5 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004832b6
    mov ecx, dword ptr [ebp - local_4]           # 004832ba
    movsx edx, word ptr [ecx + field_87c]        # 004832bd
    {load} cmp eax, edx                          # 004832c4
    jge.d32 L_004833a5                           # 004832c6
    # block 0x004832cc: entered by fall-through of jge at 0x004832c6, 4 instruction(s), ends with jne to 0x00483341 (forward)
    mov dword ptr [ebp - local_10], 0x0          # 004832cc
    mov eax, dword ptr [ebp - local_28]          # 004832d3
    cmp dword ptr [eax + field_a2], 0x0          # 004832d6
    jne.d8 L_00483341                            # 004832dd
    # block 0x004832df: entered by fall-through of jne at 0x004832dd, 2 instruction(s), ends with forward jump to 0x004832f3
    mov word ptr [ebp - local_8], 0x0            # 004832df
    jmp.d8 L_004832f3                            # 004832e5
L_004832e7:
    # block 0x004832e7: entered by jmp at 0x0048333d, 3 instruction(s), falls into the block at 0x004832f3
    mov cx, word ptr [ebp - local_8]             # 004832e7
    add cx, 0x1                                  # 004832eb
    mov word ptr [ebp - local_8], cx             # 004832ef
L_004832f3:
    # block 0x004832f3: entered by jmp at 0x004832e5, 5 instruction(s), ends with jge to 0x0048333f (forward)
    movsx edx, word ptr [ebp - local_8]          # 004832f3
    mov eax, dword ptr [ebp - local_28]          # 004832f7
    movsx ecx, word ptr [eax + field_a0]         # 004832fa
    {load} cmp edx, ecx                          # 00483301
    jge.d8 L_0048333f                            # 00483303
    # block 0x00483305: entered by fall-through of jge at 0x00483303, 13 instruction(s), ends with je to 0x0048333d (forward)
    movsx edx, word ptr [ebp - local_c]          # 00483305
    imul edx, edx, 0x37                          # 00483309
    mov eax, dword ptr [ebp - local_4]           # 0048330c
    lea ecx, [eax + edx + field_87e]             # 0048330f
    movsx edx, word ptr [ebp - local_8]          # 00483316
    {load} xor eax, eax                          # 0048331a
    mov al, byte ptr [ecx + edx + field_2]       # 0048331c
    movsx ecx, word ptr [ebp - local_8]          # 00483320
    mov edx, dword ptr [ebp - local_28]          # 00483324
    {load} xor ebx, ebx                          # 00483327
    mov bl, byte ptr [edx + ecx + field_95]      # 00483329
    {load} cmp eax, ebx                          # 00483330
    je.d8 L_0048333d                             # 00483332
    # block 0x00483334: entered by fall-through of je at 0x00483332, 2 instruction(s), ends with forward jump to 0x0048333f
    mov dword ptr [ebp - local_10], 0x1          # 00483334
    jmp.d8 L_0048333f                            # 0048333b
L_0048333d:
    # block 0x0048333d: entered by je at 0x00483332, 1 instruction(s), ends with backward jump to 0x004832e7
    jmp.d8 L_004832e7                            # 0048333d
L_0048333f:
    # block 0x0048333f: entered by jge at 0x00483303; jmp at 0x0048333b, 1 instruction(s), ends with forward jump to 0x00483398
    jmp.d8 L_00483398                            # 0048333f
L_00483341:
    # block 0x00483341: entered by jne at 0x004832dd, 2 instruction(s), ends with forward jump to 0x00483355
    mov word ptr [ebp - local_8], 0x0            # 00483341
    jmp.d8 L_00483355                            # 00483347
L_00483349:
    # block 0x00483349: entered by jmp at 0x00483396, 3 instruction(s), falls into the block at 0x00483355
    mov ax, word ptr [ebp - local_8]             # 00483349
    .insn 0x66, 0x05, 0x0001{:u16}               # 0048334d
    mov word ptr [ebp - local_8], ax             # 00483351
L_00483355:
    # block 0x00483355: entered by jmp at 0x00483347, 3 instruction(s), ends with jge to 0x00483398 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00483355
    cmp ecx, 0xb                                 # 00483359
    jge.d8 L_00483398                            # 0048335c
    # block 0x0048335e: entered by fall-through of jge at 0x0048335c, 13 instruction(s), ends with je to 0x00483396 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0048335e
    imul edx, edx, 0x37                          # 00483362
    mov eax, dword ptr [ebp - local_4]           # 00483365
    lea ecx, [eax + edx + field_87e]             # 00483368
    movsx edx, word ptr [ebp - local_8]          # 0048336f
    {load} xor eax, eax                          # 00483373
    mov al, byte ptr [ecx + edx + field_2]       # 00483375
    movsx ecx, word ptr [ebp - local_8]          # 00483379
    mov edx, dword ptr [ebp - local_28]          # 0048337d
    {load} xor ebx, ebx                          # 00483380
    mov bl, byte ptr [edx + ecx + field_95]      # 00483382
    {load} cmp eax, ebx                          # 00483389
    je.d8 L_00483396                             # 0048338b
    # block 0x0048338d: entered by fall-through of je at 0x0048338b, 2 instruction(s), ends with forward jump to 0x00483398
    mov dword ptr [ebp - local_10], 0x1          # 0048338d
    jmp.d8 L_00483398                            # 00483394
L_00483396:
    # block 0x00483396: entered by je at 0x0048338b, 1 instruction(s), ends with backward jump to 0x00483349
    jmp.d8 L_00483349                            # 00483396
L_00483398:
    # block 0x00483398: entered by jmp at 0x0048333f; jge at 0x0048335c; jmp at 0x00483394, 2 instruction(s), ends with jne to 0x004833a0 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 00483398
    jne.d8 L_004833a0                            # 0048339c
    # block 0x0048339e: entered by fall-through of jne at 0x0048339c, 1 instruction(s), ends with forward jump to 0x004833a5
    jmp.d8 L_004833a5                            # 0048339e
L_004833a0:
    # block 0x004833a0: entered by jne at 0x0048339c, 1 instruction(s), ends with backward jump to 0x004832aa
    jmp.d32 L_004832aa                           # 004833a0
L_004833a5:
    # block 0x004833a5: entered by jge at 0x004832c6; jmp at 0x0048339e, 2 instruction(s), ends with jne to 0x00483434 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 004833a5
    jne.d32 L_00483434                           # 004833a9
    # block 0x004833af: entered by fall-through of jne at 0x004833a9, 10 instruction(s), ends with je to 0x0048341b (forward)
    mov eax, dword ptr [ebp - local_28]          # 004833af
    mov cx, word ptr [ebp - local_c]             # 004833b2
    mov word ptr [eax + field_a6], cx            # 004833b6
    mov edi, 0x54d93c                            # 004833bd
    mov esi, dword ptr [ebp - local_4]           # 004833c2
    add esi, 0x418                               # 004833c5
    mov ecx, 0x9                                 # 004833cb
    {load} xor edx, edx                          # 004833d0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004833d2
    je.d8 L_0048341b                             # 004833d4
    # block 0x004833d6: entered by fall-through of je at 0x004833d4, 17 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00483432
    mov eax, dword ptr [ebp - local_4]           # 004833d6
    add eax, 0x418                               # 004833d9
    push eax                                     # 004833de
    mov ecx, 0x5c3a67                            # 004833df
    call FUN_004fb77a                            # 004833e4
    mov ecx, dword ptr [ebp - local_4]           # 004833e9
    mov dx, word ptr [ecx + field_439]           # 004833ec
    push edx                                     # 004833f3
    mov ecx, 0x5c3a67                            # 004833f4
    call FUN_004fb2e3                            # 004833f9
    mov eax, dword ptr [ebp - local_4]           # 004833fe
    add eax, 0x418                               # 00483401
    mov ecx, dword ptr [ebp - local_28]          # 00483406
    mov dword ptr [ecx + field_af], eax          # 00483409
    mov edx, dword ptr [ebp - local_28]          # 0048340f
    mov dword ptr [edx + field_78], 0x5          # 00483412
    jmp.d8 L_00483432                            # 00483419
L_0048341b:
    # block 0x0048341b: entered by je at 0x004833d4, 4 instruction(s), falls into the block at 0x00483432
    mov eax, dword ptr [ebp - local_28]          # 0048341b
    movsx ecx, word ptr [eax + field_1e]         # 0048341e
    imul ecx, ecx, 0x8d                          # 00483422
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00483428
L_00483432:
    # block 0x00483432: entered by jmp at 0x00483419, 1 instruction(s), ends with forward jump to 0x0048343e
    jmp.d8 L_0048343e                            # 00483432
L_00483434:
    # block 0x00483434: entered by jne at 0x004833a9, 2 instruction(s), falls into the block at 0x0048343e
    mov edx, dword ptr [ebp - local_28]          # 00483434
    mov dword ptr [edx + field_78], 0x6          # 00483437
L_0048343e:
    # block 0x0048343e: entered by jmp at 0x00483432, 12 instruction(s), ends with forward jump to 0x004836a9
    mov eax, dword ptr [ebp - local_28]          # 0048343e
    mov byte ptr [eax + field_94], 0x1           # 00483441
    mov ecx, dword ptr [ebp - local_28]          # 00483448
    mov word ptr [ecx + field_92], 0x0           # 0048344b
    {load} xor edx, edx                          # 00483454
    mov eax, dword ptr [ebp - local_28]          # 00483456
    add eax, 0x95                                # 00483459
    mov dword ptr [eax], edx                     # 0048345e
    mov dword ptr [eax + field_4], edx           # 00483460
    mov word ptr [eax + field_8], dx             # 00483463
    mov byte ptr [eax + field_a], dl             # 00483467
    jmp.d32 L_004836a9                           # 0048346a
L_0048346f:
    # block 0x0048346f: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004834c6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048346f
    movsx edx, word ptr [ecx + field_439]        # 00483472
    mov dword ptr [ebp - local_1c], edx          # 00483479
    mov eax, dword ptr [ebp - local_1c]          # 0048347c
    push eax                                     # 0048347f
    mov ecx, 0x5cf1eb                            # 00483480
    call FUN_004f6334                            # 00483485
    test eax, eax                                # 0048348a
    jne.d8 L_004834c6                            # 0048348c
    # block 0x0048348e: entered by fall-through of jne at 0x0048348c, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x004834c6
    mov ecx, dword ptr [ebp - local_4]           # 0048348e
    add ecx, 0x418                               # 00483491
    push ecx                                     # 00483497
    mov ecx, 0x5c3a67                            # 00483498
    call FUN_004fba69                            # 0048349d
    mov edx, dword ptr [ebp - local_28]          # 004834a2
    mov dword ptr [edx + field_af], 0x0          # 004834a5
    mov eax, dword ptr [ebp - local_28]          # 004834af
    movsx ecx, word ptr [eax + field_1e]         # 004834b2
    imul ecx, ecx, 0x8d                          # 004834b6
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004834bc
L_004834c6:
    # block 0x004834c6: entered by jne at 0x0048348c, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 004834c6
L_004834cb:
    # block 0x004834cb: entered by switch case, 2 instruction(s), ends with je to 0x004834f2 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004834cb
    je.d8 L_004834f2                             # 004834d2
    # block 0x004834d4: entered by fall-through of je at 0x004834d2, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x004834f2
    push 0x0                                     # 004834d4
    push -0x1                                    # 004834d6
    mov edx, dword ptr [ebp - local_4]           # 004834d8
    add edx, 0x770                               # 004834db
    push edx                                     # 004834e1
    mov eax, dword ptr [0x5d03b3]                # 004834e2
    push eax                                     # 004834e7
    mov ecx, 0x619a05                            # 004834e8
    call FUN_00448d11                            # 004834ed
L_004834f2:
    # block 0x004834f2: entered by je at 0x004834d2, 7 instruction(s), ends with je to 0x00483550 (forward)
    mov edi, 0x54d948                            # 004834f2
    mov esi, dword ptr [ebp - local_4]           # 004834f7
    add esi, 0x73f                               # 004834fa
    mov ecx, 0x9                                 # 00483500
    {load} xor edx, edx                          # 00483505
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00483507
    je.d8 L_00483550                             # 00483509
    # block 0x0048350b: entered by fall-through of je at 0x00483509, 17 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00483571
    mov eax, dword ptr [ebp - local_4]           # 0048350b
    add eax, 0x73f                               # 0048350e
    push eax                                     # 00483513
    mov ecx, 0x5c3a67                            # 00483514
    call FUN_004fb77a                            # 00483519
    mov ecx, dword ptr [ebp - local_4]           # 0048351e
    mov dx, word ptr [ecx + field_760]           # 00483521
    push edx                                     # 00483528
    mov ecx, 0x5c3a67                            # 00483529
    call FUN_004fb2e3                            # 0048352e
    mov eax, dword ptr [ebp - local_4]           # 00483533
    add eax, 0x73f                               # 00483536
    mov ecx, dword ptr [ebp - local_28]          # 0048353b
    mov dword ptr [ecx + field_af], eax          # 0048353e
    mov edx, dword ptr [ebp - local_28]          # 00483544
    mov dword ptr [edx + field_78], 0x7          # 00483547
    jmp.d8 L_00483571                            # 0048354e
L_00483550:
    # block 0x00483550: entered by je at 0x00483509, 6 instruction(s), falls into the block at 0x00483571
    mov eax, dword ptr [ebp - local_28]          # 00483550
    mov byte ptr [eax + field_ac], 0x1           # 00483553
    mov ecx, dword ptr [ebp - local_28]          # 0048355a
    movsx edx, word ptr [ecx + field_1e]         # 0048355d
    imul edx, edx, 0x8d                          # 00483561
    mov dword ptr [edx + 0x5bb632], 0x2          # 00483567
L_00483571:
    # block 0x00483571: entered by jmp at 0x0048354e, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 00483571
L_00483576:
    # block 0x00483576: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004835d6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00483576
    movsx ecx, word ptr [eax + field_760]        # 00483579
    mov dword ptr [ebp - local_20], ecx          # 00483580
    mov edx, dword ptr [ebp - local_20]          # 00483583
    push edx                                     # 00483586
    mov ecx, 0x5cf1eb                            # 00483587
    call FUN_004f6334                            # 0048358c
    test eax, eax                                # 00483591
    jne.d8 L_004835d6                            # 00483593
    # block 0x00483595: entered by fall-through of jne at 0x00483593, 13 instruction(s), calls FUN_004fba69, falls into the block at 0x004835d6
    mov eax, dword ptr [ebp - local_4]           # 00483595
    add eax, 0x73f                               # 00483598
    push eax                                     # 0048359d
    mov ecx, 0x5c3a67                            # 0048359e
    call FUN_004fba69                            # 004835a3
    mov ecx, dword ptr [ebp - local_28]          # 004835a8
    mov dword ptr [ecx + field_af], 0x0          # 004835ab
    mov edx, dword ptr [ebp - local_28]          # 004835b5
    mov byte ptr [edx + field_ac], 0x1           # 004835b8
    mov eax, dword ptr [ebp - local_28]          # 004835bf
    movsx ecx, word ptr [eax + field_1e]         # 004835c2
    imul ecx, ecx, 0x8d                          # 004835c6
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004835cc
L_004835d6:
    # block 0x004835d6: entered by jne at 0x00483593, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d32 L_004836a9                           # 004835d6
L_004835db:
    # block 0x004835db: entered by switch case, 7 instruction(s), ends with je to 0x00483639 (forward)
    mov edi, 0x54d954                            # 004835db
    mov esi, dword ptr [ebp - local_4]           # 004835e0
    add esi, 0x449                               # 004835e3
    mov ecx, 0x9                                 # 004835e9
    {load} xor edx, edx                          # 004835ee
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004835f0
    je.d8 L_00483639                             # 004835f2
    # block 0x004835f4: entered by fall-through of je at 0x004835f2, 17 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00483650
    mov eax, dword ptr [ebp - local_4]           # 004835f4
    add eax, 0x449                               # 004835f7
    push eax                                     # 004835fc
    mov ecx, 0x5c3a67                            # 004835fd
    call FUN_004fb77a                            # 00483602
    mov ecx, dword ptr [ebp - local_4]           # 00483607
    mov dx, word ptr [ecx + field_46a]           # 0048360a
    push edx                                     # 00483611
    mov ecx, 0x5c3a67                            # 00483612
    call FUN_004fb2e3                            # 00483617
    mov eax, dword ptr [ebp - local_4]           # 0048361c
    add eax, 0x449                               # 0048361f
    mov ecx, dword ptr [ebp - local_28]          # 00483624
    mov dword ptr [ecx + field_af], eax          # 00483627
    mov edx, dword ptr [ebp - local_28]          # 0048362d
    mov dword ptr [edx + field_78], 0x9          # 00483630
    jmp.d8 L_00483650                            # 00483637
L_00483639:
    # block 0x00483639: entered by je at 0x004835f2, 4 instruction(s), falls into the block at 0x00483650
    mov eax, dword ptr [ebp - local_28]          # 00483639
    movsx ecx, word ptr [eax + field_1e]         # 0048363c
    imul ecx, ecx, 0x8d                          # 00483640
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00483646
L_00483650:
    # block 0x00483650: entered by jmp at 0x00483637, 1 instruction(s), ends with forward jump to 0x004836a9
    jmp.d8 L_004836a9                            # 00483650
L_00483652:
    # block 0x00483652: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004836a9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00483652
    movsx eax, word ptr [edx + field_46a]        # 00483655
    mov dword ptr [ebp - local_24], eax          # 0048365c
    mov ecx, dword ptr [ebp - local_24]          # 0048365f
    push ecx                                     # 00483662
    mov ecx, 0x5cf1eb                            # 00483663
    call FUN_004f6334                            # 00483668
    test eax, eax                                # 0048366d
    jne.d8 L_004836a9                            # 0048366f
    # block 0x00483671: entered by fall-through of jne at 0x0048366f, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x004836a9
    mov edx, dword ptr [ebp - local_4]           # 00483671
    add edx, 0x449                               # 00483674
    push edx                                     # 0048367a
    mov ecx, 0x5c3a67                            # 0048367b
    call FUN_004fba69                            # 00483680
    mov eax, dword ptr [ebp - local_28]          # 00483685
    mov dword ptr [eax + field_af], 0x0          # 00483688
    mov ecx, dword ptr [ebp - local_28]          # 00483692
    movsx edx, word ptr [ecx + field_1e]         # 00483695
    imul edx, edx, 0x8d                          # 00483699
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048369f
L_004836a9:
    # block 0x004836a9: entered by ja at 0x00482de5; jmp at 0x004831d8; jmp at 0x00483247; jmp at 0x00483296; more, 1 instruction(s), ends with forward jump to 0x00483a98
    jmp.d32 L_00483a98                           # 004836a9
L_004836ae:
    # block 0x004836ae: entered by je at 0x00482a4e, 6 instruction(s), ends with je to 0x004836d6 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004836ae
    mov eax, dword ptr [ebp - local_4]           # 004836b8
    {load} xor ecx, ecx                          # 004836bb
    mov cl, byte ptr [eax + field_21]            # 004836bd
    test ecx, ecx                                # 004836c0
    je.d8 L_004836d6                             # 004836c2
    # block 0x004836c4: entered by fall-through of je at 0x004836c2, 5 instruction(s), calls FUN_004c92c5, falls into the block at 0x004836d6
    mov edx, dword ptr [ebp - local_4]           # 004836c4
    mov ax, word ptr [edx + field_22]            # 004836c7
    push eax                                     # 004836cb
    mov ecx, 0x5cf659                            # 004836cc
    call FUN_004c92c5                            # 004836d1
L_004836d6:
    # block 0x004836d6: entered by je at 0x004836c2, 7 instruction(s), calls FUN_004821ab, ends with je to 0x00483708 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004836d6
    mov byte ptr [ecx + field_a8], 0x0           # 004836d9
    mov ecx, dword ptr [ebp - local_28]          # 004836e0
    call FUN_004821ab                            # 004836e3
    mov edx, dword ptr [ebp - local_28]          # 004836e8
    cmp dword ptr [edx + field_af], 0x0          # 004836eb
    je.d8 L_00483708                             # 004836f2
    # block 0x004836f4: entered by fall-through of je at 0x004836f2, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00483708
    mov eax, dword ptr [ebp - local_28]          # 004836f4
    mov ecx, dword ptr [eax + field_af]          # 004836f7
    push ecx                                     # 004836fd
    mov ecx, 0x5c3a67                            # 004836fe
    call FUN_004fba69                            # 00483703
L_00483708:
    # block 0x00483708: entered by je at 0x004836f2, 5 instruction(s), ends with je to 0x004837fd (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483708
    {load} xor eax, eax                          # 0048370b
    mov al, byte ptr [edx + field_ab]            # 0048370d
    test eax, eax                                # 00483713
    je.d32 L_004837fd                            # 00483715
    # block 0x0048371b: entered by fall-through of je at 0x00483715, 4 instruction(s), ends with je to 0x004837ce (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048371b
    movsx edx, word ptr [ecx + field_852]        # 0048371e
    cmp edx, 0x270f                              # 00483725
    je.d32 L_004837ce                            # 0048372b
    # block 0x00483731: entered by fall-through of je at 0x0048372b, 25 instruction(s), ends with jne to 0x004837ba (forward)
    mov eax, dword ptr [ebp - local_4]           # 00483731
    movsx ecx, word ptr [eax + field_852]        # 00483734
    mov dword ptr [0x5bb57b], ecx                # 0048373b
    mov edx, dword ptr [ebp - local_4]           # 00483741
    mov ax, word ptr [edx + field_854]           # 00483744
    mov word ptr [0x5bb599], ax                  # 0048374b
    mov ecx, dword ptr [ebp - local_4]           # 00483751
    mov dx, word ptr [ecx + field_856]           # 00483754
    mov word ptr [0x5bb595], dx                  # 0048375b
    mov eax, dword ptr [ebp - local_4]           # 00483762
    mov cx, word ptr [eax + field_858]           # 00483765
    mov word ptr [0x5c39ff], cx                  # 0048376c
    mov edx, dword ptr [ebp - local_4]           # 00483773
    mov eax, dword ptr [edx + field_85a]         # 00483776
    mov dword ptr [0x5bb59b], eax                # 0048377c
    mov ecx, dword ptr [ebp - local_4]           # 00483781
    mov edx, dword ptr [ecx + field_85e]         # 00483784
    mov dword ptr [0x5bb59f], edx                # 0048378a
    mov eax, dword ptr [ebp - local_4]           # 00483790
    mov ecx, dword ptr [eax + field_862]         # 00483793
    mov dword ptr [0x5bb5a3], ecx                # 00483799
    mov edx, dword ptr [ebp - local_4]           # 0048379f
    movsx eax, word ptr [edx + field_866]        # 004837a2
    cmp eax, 0x1                                 # 004837a9
    jne.d8 L_004837ba                            # 004837ac
    # block 0x004837ae: entered by fall-through of jne at 0x004837ac, 2 instruction(s), ends with forward jump to 0x004837c4
    mov dword ptr [0x5bb1ca], 0x0                # 004837ae
    jmp.d8 L_004837c4                            # 004837b8
L_004837ba:
    # block 0x004837ba: entered by jne at 0x004837ac, 1 instruction(s), falls into the block at 0x004837c4
    mov dword ptr [0x5bb1ca], 0x1                # 004837ba
L_004837c4:
    # block 0x004837c4: entered by jmp at 0x004837b8, 1 instruction(s), falls into the block at 0x004837ce
    mov dword ptr [0x583999], 0x4                # 004837c4
L_004837ce:
    # block 0x004837ce: entered by je at 0x0048372b, 4 instruction(s), ends with je to 0x004837f8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004837ce
    movsx edx, word ptr [ecx + field_868]        # 004837d1
    cmp edx, -0x1                                # 004837d8
    je.d8 L_004837f8                             # 004837db
    # block 0x004837dd: entered by fall-through of je at 0x004837db, 5 instruction(s), falls into the block at 0x004837f8
    mov eax, dword ptr [ebp - local_4]           # 004837dd
    movsx ecx, word ptr [eax + field_86a]        # 004837e0
    mov edx, dword ptr [ebp - local_4]           # 004837e7
    movsx eax, word ptr [edx + field_868]        # 004837ea
    mov dword ptr [4*eax + 0x585801], ecx        # 004837f1
L_004837f8:
    # block 0x004837f8: entered by je at 0x004837db, 1 instruction(s), ends with forward jump to 0x00483a88
    jmp.d32 L_00483a88                           # 004837f8
L_004837fd:
    # block 0x004837fd: entered by je at 0x00483715, 5 instruction(s), ends with je to 0x004838f1 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004837fd
    {load} xor edx, edx                          # 00483800
    mov dl, byte ptr [ecx + field_ac]            # 00483802
    test edx, edx                                # 00483808
    je.d32 L_004838f1                            # 0048380a
    # block 0x00483810: entered by fall-through of je at 0x0048380a, 4 instruction(s), ends with je to 0x004838c2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00483810
    movsx ecx, word ptr [eax + field_838]        # 00483813
    cmp ecx, 0x270f                              # 0048381a
    je.d32 L_004838c2                            # 00483820
    # block 0x00483826: entered by fall-through of je at 0x00483820, 25 instruction(s), ends with jne to 0x004838ae (forward)
    mov edx, dword ptr [ebp - local_4]           # 00483826
    movsx eax, word ptr [edx + field_838]        # 00483829
    mov dword ptr [0x5bb57b], eax                # 00483830
    mov ecx, dword ptr [ebp - local_4]           # 00483835
    mov dx, word ptr [ecx + field_83a]           # 00483838
    mov word ptr [0x5bb599], dx                  # 0048383f
    mov eax, dword ptr [ebp - local_4]           # 00483846
    mov cx, word ptr [eax + field_83c]           # 00483849
    mov word ptr [0x5bb595], cx                  # 00483850
    mov edx, dword ptr [ebp - local_4]           # 00483857
    mov ax, word ptr [edx + field_83e]           # 0048385a
    mov word ptr [0x5c39ff], ax                  # 00483861
    mov ecx, dword ptr [ebp - local_4]           # 00483867
    mov edx, dword ptr [ecx + field_840]         # 0048386a
    mov dword ptr [0x5bb59b], edx                # 00483870
    mov eax, dword ptr [ebp - local_4]           # 00483876
    mov ecx, dword ptr [eax + field_844]         # 00483879
    mov dword ptr [0x5bb59f], ecx                # 0048387f
    mov edx, dword ptr [ebp - local_4]           # 00483885
    mov eax, dword ptr [edx + field_848]         # 00483888
    mov dword ptr [0x5bb5a3], eax                # 0048388e
    mov ecx, dword ptr [ebp - local_4]           # 00483893
    movsx edx, word ptr [ecx + field_84c]        # 00483896
    cmp edx, 0x1                                 # 0048389d
    jne.d8 L_004838ae                            # 004838a0
    # block 0x004838a2: entered by fall-through of jne at 0x004838a0, 2 instruction(s), ends with forward jump to 0x004838b8
    mov dword ptr [0x5bb1ca], 0x0                # 004838a2
    jmp.d8 L_004838b8                            # 004838ac
L_004838ae:
    # block 0x004838ae: entered by jne at 0x004838a0, 1 instruction(s), falls into the block at 0x004838b8
    mov dword ptr [0x5bb1ca], 0x1                # 004838ae
L_004838b8:
    # block 0x004838b8: entered by jmp at 0x004838ac, 1 instruction(s), falls into the block at 0x004838c2
    mov dword ptr [0x583999], 0x4                # 004838b8
L_004838c2:
    # block 0x004838c2: entered by je at 0x00483820, 4 instruction(s), ends with je to 0x004838ec (forward)
    mov eax, dword ptr [ebp - local_4]           # 004838c2
    movsx ecx, word ptr [eax + field_84e]        # 004838c5
    cmp ecx, -0x1                                # 004838cc
    je.d8 L_004838ec                             # 004838cf
    # block 0x004838d1: entered by fall-through of je at 0x004838cf, 5 instruction(s), falls into the block at 0x004838ec
    mov edx, dword ptr [ebp - local_4]           # 004838d1
    movsx eax, word ptr [edx + field_850]        # 004838d4
    mov ecx, dword ptr [ebp - local_4]           # 004838db
    movsx edx, word ptr [ecx + field_84e]        # 004838de
    mov dword ptr [4*edx + 0x585801], eax        # 004838e5
L_004838ec:
    # block 0x004838ec: entered by je at 0x004838cf, 1 instruction(s), ends with forward jump to 0x00483a88
    jmp.d32 L_00483a88                           # 004838ec
L_004838f1:
    # block 0x004838f1: entered by je at 0x0048380a, 4 instruction(s), ends with je to 0x00483a88 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004838f1
    movsx ecx, word ptr [eax + field_a6]         # 004838f4
    cmp ecx, -0x1                                # 004838fb
    je.d32 L_00483a88                            # 004838fe
    # block 0x00483904: entered by fall-through of je at 0x004838fe, 7 instruction(s), ends with je to 0x00483a34 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483904
    movsx eax, word ptr [edx + field_a6]         # 00483907
    imul eax, eax, 0x37                          # 0048390e
    mov ecx, dword ptr [ebp - local_4]           # 00483911
    movsx edx, word ptr [ecx + eax + field_89b]  # 00483914
    cmp edx, 0x270f                              # 0048391c
    je.d32 L_00483a34                            # 00483922
    # block 0x00483928: entered by fall-through of je at 0x00483922, 49 instruction(s), ends with jne to 0x00483a20 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00483928
    movsx ecx, word ptr [eax + field_a6]         # 0048392b
    imul ecx, ecx, 0x37                          # 00483932
    mov edx, dword ptr [ebp - local_4]           # 00483935
    movsx eax, word ptr [edx + ecx + field_89b]  # 00483938
    mov dword ptr [0x5bb57b], eax                # 00483940
    mov ecx, dword ptr [ebp - local_28]          # 00483945
    movsx edx, word ptr [ecx + field_a6]         # 00483948
    imul edx, edx, 0x37                          # 0048394f
    mov eax, dword ptr [ebp - local_4]           # 00483952
    mov cx, word ptr [eax + edx + field_89d]     # 00483955
    mov word ptr [0x5bb599], cx                  # 0048395d
    mov edx, dword ptr [ebp - local_28]          # 00483964
    movsx eax, word ptr [edx + field_a6]         # 00483967
    imul eax, eax, 0x37                          # 0048396e
    mov ecx, dword ptr [ebp - local_4]           # 00483971
    mov dx, word ptr [ecx + eax + field_89f]     # 00483974
    mov word ptr [0x5bb595], dx                  # 0048397c
    mov eax, dword ptr [ebp - local_28]          # 00483983
    movsx ecx, word ptr [eax + field_a6]         # 00483986
    imul ecx, ecx, 0x37                          # 0048398d
    mov edx, dword ptr [ebp - local_4]           # 00483990
    mov ax, word ptr [edx + ecx + field_8a1]     # 00483993
    mov word ptr [0x5c39ff], ax                  # 0048399b
    mov ecx, dword ptr [ebp - local_28]          # 004839a1
    movsx edx, word ptr [ecx + field_a6]         # 004839a4
    imul edx, edx, 0x37                          # 004839ab
    mov eax, dword ptr [ebp - local_4]           # 004839ae
    mov ecx, dword ptr [eax + edx + field_8a3]   # 004839b1
    mov dword ptr [0x5bb59b], ecx                # 004839b8
    mov edx, dword ptr [ebp - local_28]          # 004839be
    movsx eax, word ptr [edx + field_a6]         # 004839c1
    imul eax, eax, 0x37                          # 004839c8
    mov ecx, dword ptr [ebp - local_4]           # 004839cb
    mov edx, dword ptr [ecx + eax + field_8a7]   # 004839ce
    mov dword ptr [0x5bb59f], edx                # 004839d5
    mov eax, dword ptr [ebp - local_28]          # 004839db
    movsx ecx, word ptr [eax + field_a6]         # 004839de
    imul ecx, ecx, 0x37                          # 004839e5
    mov edx, dword ptr [ebp - local_4]           # 004839e8
    mov eax, dword ptr [edx + ecx + field_8ab]   # 004839eb
    mov dword ptr [0x5bb5a3], eax                # 004839f2
    mov ecx, dword ptr [ebp - local_28]          # 004839f7
    movsx edx, word ptr [ecx + field_a6]         # 004839fa
    imul edx, edx, 0x37                          # 00483a01
    mov eax, dword ptr [ebp - local_4]           # 00483a04
    movsx ecx, word ptr [eax + edx + field_8af]  # 00483a07
    cmp ecx, 0x1                                 # 00483a0f
    jne.d8 L_00483a20                            # 00483a12
    # block 0x00483a14: entered by fall-through of jne at 0x00483a12, 2 instruction(s), ends with forward jump to 0x00483a2a
    mov dword ptr [0x5bb1ca], 0x0                # 00483a14
    jmp.d8 L_00483a2a                            # 00483a1e
L_00483a20:
    # block 0x00483a20: entered by jne at 0x00483a12, 1 instruction(s), falls into the block at 0x00483a2a
    mov dword ptr [0x5bb1ca], 0x1                # 00483a20
L_00483a2a:
    # block 0x00483a2a: entered by jmp at 0x00483a1e, 1 instruction(s), falls into the block at 0x00483a34
    mov dword ptr [0x583999], 0x4                # 00483a2a
L_00483a34:
    # block 0x00483a34: entered by je at 0x00483922, 7 instruction(s), ends with je to 0x00483a88 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00483a34
    movsx eax, word ptr [edx + field_a6]         # 00483a37
    imul eax, eax, 0x37                          # 00483a3e
    mov ecx, dword ptr [ebp - local_4]           # 00483a41
    movsx edx, word ptr [ecx + eax + field_8b1]  # 00483a44
    cmp edx, -0x1                                # 00483a4c
    je.d8 L_00483a88                             # 00483a4f
    # block 0x00483a51: entered by fall-through of je at 0x00483a4f, 11 instruction(s), falls into the block at 0x00483a88
    mov eax, dword ptr [ebp - local_28]          # 00483a51
    movsx ecx, word ptr [eax + field_a6]         # 00483a54
    imul ecx, ecx, 0x37                          # 00483a5b
    mov edx, dword ptr [ebp - local_4]           # 00483a5e
    movsx eax, word ptr [edx + ecx + field_8b3]  # 00483a61
    mov ecx, dword ptr [ebp - local_28]          # 00483a69
    movsx edx, word ptr [ecx + field_a6]         # 00483a6c
    imul edx, edx, 0x37                          # 00483a73
    mov ecx, dword ptr [ebp - local_4]           # 00483a76
    movsx edx, word ptr [ecx + edx + field_8b1]  # 00483a79
    mov dword ptr [4*edx + 0x585801], eax        # 00483a81
L_00483a88:
    # block 0x00483a88: entered by jmp at 0x004837f8; jmp at 0x004838ec; je at 0x004838fe; je at 0x00483a4f, 5 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00483a98
    mov eax, dword ptr [ebp - local_28]          # 00483a88
    mov cx, word ptr [eax + field_1e]            # 00483a8b
    push ecx                                     # 00483a8f
    call FUN_0042ba3a                            # 00483a90
    add esp, 0x4                                 # 00483a95
L_00483a98:
    # block 0x00483a98: entered by jmp at 0x00482a54; jmp at 0x00482dd3; jmp at 0x004836a9, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 00483a98
    pop esi                                      # 00483a99
    pop ebx                                      # 00483a9a
    {load} mov esp, ebp                          # 00483a9b
    pop ebp                                      # 00483a9d
    ret 0x4                                      # 00483a9e

# --- data items (not part of the function) -------------------------
.org 0x00483aa1 - 0x401000
SWTAB_00483aa1:  # 10 case address(es)
    .long L_00482df5 - .text + 0x401000
    .long L_00482e85 - .text + 0x401000
    .long L_004831dd - .text + 0x401000
    .long L_0048324c - .text + 0x401000
    .long L_0048329b - .text + 0x401000
    .long L_0048346f - .text + 0x401000
    .long L_004834cb - .text + 0x401000
    .long L_00483576 - .text + 0x401000
    .long L_004835db - .text + 0x401000
    .long L_00483652 - .text + 0x401000
.set SWTAB_00483aa1_VA, SWTAB_00483aa1 - .text + 0x401000

