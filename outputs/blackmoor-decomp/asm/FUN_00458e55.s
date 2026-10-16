# FUN_00458e55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458e55
# extent:       0x00458e55-0x004595c9 (1908 code bytes)
# span:         0x00458e55-0x004595e1 (code 1908, tables 24, padding 0)
# sha256:       070e8623d2959d85c91b0225a7145f6aa87c399d0ee7125e1d0a25966fb57c15
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00458e55
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_20, field_24, field_26, field_3a, field_3c, field_90, field_98, field_9d, field_b8 and 9 more; [ecx + n] field_4, field_8, field_c, field_1c, field_20, field_24, field_26, field_2e, field_3a, field_3c, field_9c, field_9d and 11 more; [edx + n] field_4, field_8, field_c, field_20, field_21, field_24, field_26, field_32, field_3a, field_3c, field_94, field_9c and 11 more
# callees:      calls FUN_004e8d96, FUN_004c2790, FUN_004d39f9, FUN_00458dce, FUN_00458c9b, KERNEL32.dll!GetTickCount, FUN_004fba69, FUN_004f6334, FUN_004fb2e3, FUN_0042ba3a, FUN_00457fc2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 448 instruction(s), 25 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3c, 0x3c  # offset +0x3c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_9d, 0x9d  # offset +0x9d
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_f1, 0xf1  # offset +0xf1
.equ field_54b, 0x54b  # offset +0x54b
.equ field_58c, 0x58c  # offset +0x58c
.equ field_5f0, 0x5f0  # offset +0x5f0
.equ field_5f2, 0x5f2  # offset +0x5f2
.equ field_624, 0x624  # offset +0x624
.equ field_626, 0x626  # offset +0x626
.equ field_627, 0x627  # offset +0x627
.equ field_629, 0x629  # offset +0x629
.equ field_62b, 0x62b  # offset +0x62b
.equ field_62d, 0x62d  # offset +0x62d
.equ field_62f, 0x62f  # offset +0x62f
.equ field_633, 0x633  # offset +0x633
.equ field_637, 0x637  # offset +0x637
.equ field_63b, 0x63b  # offset +0x63b
.equ field_63d, 0x63d  # offset +0x63d
.equ field_63f, 0x63f  # offset +0x63f
.equ field_641, 0x641  # offset +0x641
.equ field_643, 0x643  # offset +0x643
.equ field_645, 0x645  # offset +0x645
.equ field_649, 0x649  # offset +0x649
.equ field_64d, 0x64d  # offset +0x64d
.equ field_651, 0x651  # offset +0x651

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00457fc2, .text + (0x00457fc2 - 0x401000)
.set FUN_00458c9b, .text + (0x00458c9b - 0x401000)
.set FUN_00458dce, .text + (0x00458dce - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00458e55 - 0x401000
.globl FUN_00458e55
FUN_00458e55:
    # block 0x00458e55: entry, 17 instruction(s), ends with je to 0x00458eac (forward)
    push ebp                                     # 00458e55
    {load} mov ebp, esp                          # 00458e56
    sub esp, 0x18                                # 00458e58
    push esi                                     # 00458e5b
    push edi                                     # 00458e5c
    mov dword ptr [ebp - local_10], ecx          # 00458e5d
    mov dword ptr [ebp - local_4], 0x0           # 00458e60
    movsx eax, word ptr [ebp + arg_8]            # 00458e67
    imul eax, eax, 0x8d                          # 00458e6b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00458e71
    mov dword ptr [ebp - local_8], ecx           # 00458e77
    movsx edx, word ptr [ebp + arg_8]            # 00458e7a
    imul edx, edx, 0x8d                          # 00458e7e
    mov eax, dword ptr [edx + 0x5bb632]          # 00458e84
    mov dword ptr [ebp - local_14], eax          # 00458e8a
    cmp dword ptr [ebp - local_14], 0x0          # 00458e8d
    je.d8 L_00458eac                             # 00458e91
    # block 0x00458e93: entered by fall-through of je at 0x00458e91, 2 instruction(s), ends with je to 0x004590ba (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 00458e93
    je.d32 L_004590ba                            # 00458e97
    # block 0x00458e9d: entered by fall-through of je at 0x00458e97, 2 instruction(s), ends with je to 0x0045940f (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 00458e9d
    je.d32 L_0045940f                            # 00458ea1
    # block 0x00458ea7: entered by fall-through of je at 0x00458ea1, 1 instruction(s), ends with forward jump to 0x004595c1
    jmp.d32 L_004595c1                           # 00458ea7
L_00458eac:
    # block 0x00458eac: entered by je at 0x00458e91, 68 instruction(s), calls FUN_004e8d96, ends with jne to 0x00458fd8 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00458eac
    mov dx, word ptr [ebp + arg_8]               # 00458eaf
    mov word ptr [ecx + field_26], dx            # 00458eb3
    mov eax, dword ptr [ebp - local_10]          # 00458eb7
    mov dword ptr [eax + field_98], 0x1          # 00458eba
    mov dword ptr [0x5bb1ca], 0x1                # 00458ec4
    mov ecx, 0x571442                            # 00458ece
    call FUN_004e8d96                            # 00458ed3
    mov ecx, dword ptr [ebp - local_10]          # 00458ed8
    mov word ptr [ecx + field_3a], 0xffff        # 00458edb
    mov edx, dword ptr [ebp - local_10]          # 00458ee1
    mov word ptr [edx + field_3c], 0xffff        # 00458ee4
    mov eax, dword ptr [ebp - local_10]          # 00458eea
    mov dword ptr [eax + field_90], 0x0          # 00458eed
    mov ecx, dword ptr [ebp - local_10]          # 00458ef7
    mov dword ptr [ecx + field_2e], 0x0          # 00458efa
    mov edx, dword ptr [ebp - local_10]          # 00458f01
    mov dword ptr [edx + field_32], 0x0          # 00458f04
    mov eax, dword ptr [ebp - local_10]          # 00458f0b
    mov byte ptr [eax + field_9d], 0x0           # 00458f0e
    mov ecx, dword ptr [ebp - local_10]          # 00458f15
    mov byte ptr [ecx + field_9c], 0x0           # 00458f18
    mov edx, dword ptr [ebp - local_10]          # 00458f1f
    mov dword ptr [edx + field_20], 0x0          # 00458f22
    mov eax, dword ptr [ebp - local_10]          # 00458f29
    movsx ecx, word ptr [eax + field_26]         # 00458f2c
    imul ecx, ecx, 0x8d                          # 00458f30
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00458f36
    {load} xor edx, edx                          # 00458f40
    mov eax, dword ptr [ebp - local_10]          # 00458f42
    add eax, 0x3e                                # 00458f45
    mov dword ptr [eax], edx                     # 00458f48
    mov dword ptr [eax + field_4], edx           # 00458f4a
    mov dword ptr [eax + field_8], edx           # 00458f4d
    mov dword ptr [eax + field_c], edx           # 00458f50
    {load} xor ecx, ecx                          # 00458f53
    mov edx, dword ptr [ebp - local_10]          # 00458f55
    add edx, 0x4e                                # 00458f58
    mov dword ptr [edx], ecx                     # 00458f5b
    mov dword ptr [edx + field_4], ecx           # 00458f5d
    mov dword ptr [edx + field_8], ecx           # 00458f60
    mov dword ptr [edx + field_c], ecx           # 00458f63
    {load} xor eax, eax                          # 00458f66
    mov ecx, dword ptr [ebp - local_10]          # 00458f68
    add ecx, 0x5e                                # 00458f6b
    mov dword ptr [ecx], eax                     # 00458f6e
    mov dword ptr [ecx + field_4], eax           # 00458f70
    mov dword ptr [ecx + field_8], eax           # 00458f73
    mov dword ptr [ecx + field_c], eax           # 00458f76
    {load} xor edx, edx                          # 00458f79
    mov eax, dword ptr [ebp - local_10]          # 00458f7b
    add eax, 0x6e                                # 00458f7e
    mov dword ptr [eax], edx                     # 00458f81
    mov dword ptr [eax + field_4], edx           # 00458f83
    mov dword ptr [eax + field_8], edx           # 00458f86
    mov dword ptr [eax + field_c], edx           # 00458f89
    {load} xor ecx, ecx                          # 00458f8c
    mov edx, dword ptr [ebp - local_10]          # 00458f8e
    add edx, 0x9e                                # 00458f91
    mov dword ptr [edx], ecx                     # 00458f97
    mov dword ptr [edx + field_4], ecx           # 00458f99
    mov dword ptr [edx + field_8], ecx           # 00458f9c
    mov dword ptr [edx + field_c], ecx           # 00458f9f
    mov eax, dword ptr [ebp - local_10]          # 00458fa2
    mov dword ptr [eax + field_b8], 0x0          # 00458fa5
    mov ecx, dword ptr [ebp - local_10]          # 00458faf
    cmp dword ptr [ecx + field_1c], 0x0          # 00458fb2
    jne.d8 L_00458fd8                            # 00458fb6
    # block 0x00458fb8: entered by fall-through of jne at 0x00458fb6, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00458fd8
    push 0x54a62c                                # 00458fb8
    push 0x6                                     # 00458fbd
    mov edx, dword ptr [ebp - local_8]           # 00458fbf
    push edx                                     # 00458fc2
    push 0x54a644                                # 00458fc3
    mov ecx, 0x5cf659                            # 00458fc8
    call FUN_004c2790                            # 00458fcd
    mov ecx, dword ptr [ebp - local_10]          # 00458fd2
    mov dword ptr [ecx + field_1c], eax          # 00458fd5
L_00458fd8:
    # block 0x00458fd8: entered by jne at 0x00458fb6, 54 instruction(s), calls FUN_004d39f9, ends with forward jump to 0x004595c1
    call FUN_004d39f9                            # 00458fd8
    mov edx, dword ptr [ebp - local_10]          # 00458fdd
    mov word ptr [edx + field_24], ax            # 00458fe0
    mov eax, dword ptr [ebp - local_10]          # 00458fe4
    movsx ecx, word ptr [eax + field_24]         # 00458fe7
    imul ecx, ecx, 0x4a                          # 00458feb
    mov dword ptr [ecx + 0x5d1591], 0xa          # 00458fee
    mov edx, dword ptr [ebp - local_10]          # 00458ff8
    movsx eax, word ptr [edx + field_24]         # 00458ffb
    imul eax, eax, 0x4a                          # 00458fff
    mov dword ptr [eax + 0x5d1595], 0x4595f1     # 00459002
    mov ecx, dword ptr [ebp - local_10]          # 0045900c
    movsx edx, word ptr [ecx + field_24]         # 0045900f
    imul edx, edx, 0x4a                          # 00459013
    mov dword ptr [edx + 0x5d1599], 0x0          # 00459016
    mov eax, dword ptr [ebp - local_10]          # 00459020
    movsx ecx, word ptr [eax + field_24]         # 00459023
    imul ecx, ecx, 0x4a                          # 00459027
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0045902a
    mov edx, dword ptr [ebp - local_10]          # 00459034
    movsx eax, word ptr [edx + field_24]         # 00459037
    imul eax, eax, 0x4a                          # 0045903b
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0045903e
    mov ecx, dword ptr [ebp - local_10]          # 00459048
    movsx edx, word ptr [ecx + field_24]         # 0045904b
    imul edx, edx, 0x4a                          # 0045904f
    mov dword ptr [edx + 0x5d15a5], 0x1          # 00459052
    mov eax, dword ptr [ebp - local_10]          # 0045905c
    movsx ecx, word ptr [eax + field_24]         # 0045905f
    imul ecx, ecx, 0x4a                          # 00459063
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 00459066
    mov edx, dword ptr [ebp - local_10]          # 00459070
    movsx eax, word ptr [edx + field_24]         # 00459073
    imul eax, eax, 0x4a                          # 00459077
    mov word ptr [eax + 0x5d15ad], 0x0           # 0045907a
    mov edi, 0x54a64c                            # 00459083
    mov ecx, dword ptr [ebp - local_10]          # 00459088
    movsx edx, word ptr [ecx + field_24]         # 0045908b
    imul edx, edx, 0x4a                          # 0045908f
    add edx, 0x5d15b3                            # 00459092
    or ecx, -0x1                                 # 00459098
    {load} xor eax, eax                          # 0045909b
    repne scasb al, byte ptr es:[edi]            # 0045909d
    not ecx                                      # 0045909f
    {load} sub edi, ecx                          # 004590a1
    {load} mov esi, edi                          # 004590a3
    {load} mov eax, ecx                          # 004590a5
    {load} mov edi, edx                          # 004590a7
    shr ecx, 0x2                                 # 004590a9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004590ac
    {load} mov ecx, eax                          # 004590ae
    and ecx, 0x3                                 # 004590b0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004590b3
    jmp.d32 L_004595c1                           # 004590b5
L_004590ba:
    # block 0x004590ba: entered by je at 0x00458e97, 5 instruction(s), ends with ja to 0x0045940a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004590ba
    mov edx, dword ptr [ecx + field_20]          # 004590bd
    mov dword ptr [ebp - local_18], edx          # 004590c0
    cmp dword ptr [ebp - local_18], 0x5          # 004590c3
    ja.d32 L_0045940a                            # 004590c7
    # block 0x004590cd: entered by fall-through of ja at 0x004590c7, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4595c9]
    mov eax, dword ptr [ebp - local_18]          # 004590cd
    jmp dword ptr [4*eax + SWTAB_004595c9_VA]    # 004590d0
L_004590d7:
    # block 0x004590d7: entered by switch case, 5 instruction(s), ends with jl to 0x00459108 (forward)
    movsx ecx, word ptr [0x5a4c08]               # 004590d7
    mov edx, dword ptr [ebp - local_8]           # 004590de
    movsx eax, word ptr [edx + field_21]         # 004590e1
    {load} cmp ecx, eax                          # 004590e5
    jl.d8 L_00459108                             # 004590e7
    # block 0x004590e9: entered by fall-through of jl at 0x004590e7, 6 instruction(s), calls FUN_00458dce, falls into the block at 0x00459108
    mov ecx, dword ptr [ebp - local_10]          # 004590e9
    call FUN_00458dce                            # 004590ec
    mov ecx, dword ptr [ebp - local_10]          # 004590f1
    mov dword ptr [ecx + field_20], 0x4          # 004590f4
    mov edx, dword ptr [ebp - local_10]          # 004590fb
    mov dword ptr [edx + field_94], 0x1          # 004590fe
L_00459108:
    # block 0x00459108: entered by jl at 0x004590e7, 1 instruction(s), ends with forward jump to 0x0045940a
    jmp.d32 L_0045940a                           # 00459108
L_0045910d:
    # block 0x0045910d: entered by switch case, 4 instruction(s), ends with jne to 0x0045916c (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045910d
    movsx ecx, word ptr [eax + field_f1]         # 00459110
    test ecx, ecx                                # 00459117
    jne.d8 L_0045916c                            # 00459119
    # block 0x0045911b: entered by fall-through of jne at 0x00459119, 13 instruction(s), ends with je to 0x0045916a (forward)
    mov esi, dword ptr [ebp - local_8]           # 0045911b
    add esi, 0x5f3                               # 0045911e
    mov edi, dword ptr [ebp - local_10]          # 00459124
    add edi, 0xc0                                # 00459127
    mov ecx, 0xc                                 # 0045912d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00459132
    movsb byte ptr es:[edi], byte ptr [esi]      # 00459134
    mov edx, dword ptr [ebp - local_10]          # 00459135
    mov byte ptr [edx + field_9d], 0x1           # 00459138
    mov eax, dword ptr [ebp - local_8]           # 0045913f
    movsx ecx, word ptr [eax + field_624]        # 00459142
    cmp ecx, -0x1                                # 00459149
    je.d8 L_0045916a                             # 0045914c
    # block 0x0045914e: entered by fall-through of je at 0x0045914c, 6 instruction(s), falls into the block at 0x0045916a
    mov edx, dword ptr [ebp - local_8]           # 0045914e
    {load} xor eax, eax                          # 00459151
    mov al, byte ptr [edx + field_626]           # 00459153
    mov ecx, dword ptr [ebp - local_8]           # 00459159
    movsx edx, word ptr [ecx + field_624]        # 0045915c
    mov dword ptr [4*edx + 0x585801], eax        # 00459163
L_0045916a:
    # block 0x0045916a: entered by je at 0x0045914c, 1 instruction(s), ends with forward jump to 0x004591e5
    jmp.d8 L_004591e5                            # 0045916a
L_0045916c:
    # block 0x0045916c: entered by jne at 0x00459119, 6 instruction(s), ends with jg to 0x004591cb (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045916c
    movsx ecx, word ptr [eax + field_f1]         # 0045916f
    mov edx, dword ptr [ebp - local_8]           # 00459176
    movsx eax, word ptr [edx + field_58c]        # 00459179
    {load} cmp ecx, eax                          # 00459180
    jg.d8 L_004591cb                             # 00459182
    # block 0x00459184: entered by fall-through of jg at 0x00459182, 11 instruction(s), ends with je to 0x004591c9 (forward)
    mov esi, dword ptr [ebp - local_8]           # 00459184
    add esi, 0x58e                               # 00459187
    mov edi, dword ptr [ebp - local_10]          # 0045918d
    add edi, 0xc0                                # 00459190
    mov ecx, 0xc                                 # 00459196
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045919b
    movsb byte ptr es:[edi], byte ptr [esi]      # 0045919d
    mov ecx, dword ptr [ebp - local_8]           # 0045919e
    movsx edx, word ptr [ecx + field_5f0]        # 004591a1
    cmp edx, -0x1                                # 004591a8
    je.d8 L_004591c9                             # 004591ab
    # block 0x004591ad: entered by fall-through of je at 0x004591ab, 6 instruction(s), falls into the block at 0x004591c9
    mov eax, dword ptr [ebp - local_8]           # 004591ad
    {load} xor ecx, ecx                          # 004591b0
    mov cl, byte ptr [eax + field_5f2]           # 004591b2
    mov edx, dword ptr [ebp - local_8]           # 004591b8
    movsx eax, word ptr [edx + field_5f0]        # 004591bb
    mov dword ptr [4*eax + 0x585801], ecx        # 004591c2
L_004591c9:
    # block 0x004591c9: entered by je at 0x004591ab, 1 instruction(s), ends with forward jump to 0x004591e5
    jmp.d8 L_004591e5                            # 004591c9
L_004591cb:
    # block 0x004591cb: entered by jg at 0x00459182, 7 instruction(s), falls into the block at 0x004591e5
    mov esi, dword ptr [ebp - local_8]           # 004591cb
    add esi, 0x5bf                               # 004591ce
    mov edi, dword ptr [ebp - local_10]          # 004591d4
    add edi, 0xc0                                # 004591d7
    mov ecx, 0xc                                 # 004591dd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004591e2
    movsb byte ptr es:[edi], byte ptr [esi]      # 004591e4
L_004591e5:
    # block 0x004591e5: entered by jmp at 0x0045916a; jmp at 0x004591c9, 7 instruction(s), calls FUN_00458c9b, ends with je to 0x00459210 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004591e5
    call FUN_00458c9b                            # 004591e8
    mov ecx, dword ptr [ebp - local_10]          # 004591ed
    {load} xor edx, edx                          # 004591f0
    mov dl, byte ptr [ecx + field_9d]            # 004591f2
    test edx, edx                                # 004591f8
    je.d8 L_00459210                             # 004591fa
    # block 0x004591fc: entered by fall-through of je at 0x004591fa, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00459210
    call dword ptr [0x52a23c]                    # 004591fc
    add eax, 0xfa0                               # 00459202
    mov ecx, dword ptr [ebp - local_10]          # 00459207
    mov dword ptr [ecx + field_b8], eax          # 0045920a
L_00459210:
    # block 0x00459210: entered by je at 0x004591fa, 3 instruction(s), ends with forward jump to 0x0045940a
    mov edx, dword ptr [ebp - local_10]          # 00459210
    mov dword ptr [edx + field_20], 0x5          # 00459213
    jmp.d32 L_0045940a                           # 0045921a
L_0045921f:
    # block 0x0045921f: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045926a (forward)
    call dword ptr [0x52a23c]                    # 0045921f
    mov ecx, dword ptr [ebp - local_10]          # 00459225
    cmp eax, dword ptr [ecx + field_b8]          # 00459228
    jb.d8 L_0045926a                             # 0045922e
    # block 0x00459230: entered by fall-through of jb at 0x0045922e, 10 instruction(s), calls FUN_004fba69, ends with je to 0x0045926a (forward)
    mov edx, dword ptr [ebp - local_10]          # 00459230
    add edx, 0xc0                                # 00459233
    push edx                                     # 00459239
    mov ecx, 0x5c3a67                            # 0045923a
    call FUN_004fba69                            # 0045923f
    mov eax, dword ptr [ebp - local_10]          # 00459244
    {load} xor ecx, ecx                          # 00459247
    mov cl, byte ptr [eax + field_9d]            # 00459249
    test ecx, ecx                                # 0045924f
    je.d8 L_0045926a                             # 00459251
    # block 0x00459253: entered by fall-through of je at 0x00459251, 4 instruction(s), falls into the block at 0x0045926a
    mov edx, dword ptr [ebp - local_10]          # 00459253
    movsx eax, word ptr [edx + field_26]         # 00459256
    imul eax, eax, 0x8d                          # 0045925a
    mov dword ptr [eax + 0x5bb632], 0x2          # 00459260
L_0045926a:
    # block 0x0045926a: entered by jb at 0x0045922e; je at 0x00459251, 1 instruction(s), ends with forward jump to 0x0045940a
    jmp.d32 L_0045940a                           # 0045926a
L_0045926f:
    # block 0x0045926f: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045929e (forward)
    call dword ptr [0x52a23c]                    # 0045926f
    mov ecx, dword ptr [ebp - local_10]          # 00459275
    cmp eax, dword ptr [ecx + field_b8]          # 00459278
    jb.d8 L_0045929e                             # 0045927e
    # block 0x00459280: entered by fall-through of jb at 0x0045927e, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x0045929e
    mov edx, dword ptr [ebp - local_10]          # 00459280
    add edx, 0xc0                                # 00459283
    push edx                                     # 00459289
    mov ecx, 0x5c3a67                            # 0045928a
    call FUN_004fba69                            # 0045928f
    mov eax, dword ptr [ebp - local_10]          # 00459294
    mov dword ptr [eax + field_20], 0x0          # 00459297
L_0045929e:
    # block 0x0045929e: entered by jb at 0x0045927e, 1 instruction(s), ends with forward jump to 0x0045940a
    jmp.d32 L_0045940a                           # 0045929e
L_004592a3:
    # block 0x004592a3: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004592d7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004592a3
    movsx edx, word ptr [ecx + field_54b]        # 004592a6
    mov dword ptr [ebp - local_c], edx           # 004592ad
    mov eax, dword ptr [ebp - local_c]           # 004592b0
    push eax                                     # 004592b3
    mov ecx, 0x5cf1eb                            # 004592b4
    call FUN_004f6334                            # 004592b9
    test eax, eax                                # 004592be
    jne.d8 L_004592d7                            # 004592c0
    # block 0x004592c2: entered by fall-through of jne at 0x004592c0, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004592d7
    mov ecx, dword ptr [ebp - local_8]           # 004592c2
    mov dx, word ptr [ecx + field_54b]           # 004592c5
    push edx                                     # 004592cc
    mov ecx, 0x5c3a67                            # 004592cd
    call FUN_004fb2e3                            # 004592d2
L_004592d7:
    # block 0x004592d7: entered by jne at 0x004592c0, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045937b (forward)
    call dword ptr [0x52a23c]                    # 004592d7
    mov ecx, dword ptr [ebp - local_10]          # 004592dd
    cmp eax, dword ptr [ecx + field_bc]          # 004592e0
    jb.d32 L_0045937b                            # 004592e6
    # block 0x004592ec: entered by fall-through of jb at 0x004592e6, 5 instruction(s), ends with jne to 0x00459357 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004592ec
    movsx eax, word ptr [edx + field_3c]         # 004592ef
    movsx ecx, word ptr [0x5a4c08]               # 004592f3
    {load} cmp eax, ecx                          # 004592fa
    jne.d8 L_00459357                            # 004592fc
    # block 0x004592fe: entered by fall-through of jne at 0x004592fc, 19 instruction(s), calls FUN_004fba69, ends with forward jump to 0x0045937b
    movsx edx, word ptr [0x5a4c08]               # 004592fe
    mov eax, dword ptr [ebp - local_10]          # 00459305
    mov cx, word ptr [eax + field_3a]            # 00459308
    mov word ptr [2*edx + 0x5a4bd6], cx          # 0045930c
    mov dx, word ptr [0x5a4c08]                  # 00459314
    add dx, 0x1                                  # 0045931b
    mov word ptr [0x5a4c08], dx                  # 0045931f
    mov eax, dword ptr [ebp - local_10]          # 00459326
    mov dword ptr [eax + field_20], 0x0          # 00459329
    mov ecx, dword ptr [ebp - local_10]          # 00459330
    mov word ptr [ecx + field_3c], 0xffff        # 00459333
    mov edx, dword ptr [ebp - local_10]          # 00459339
    mov word ptr [edx + field_3a], 0xffff        # 0045933c
    mov eax, dword ptr [ebp - local_8]           # 00459342
    add eax, 0x52a                               # 00459345
    push eax                                     # 0045934a
    mov ecx, 0x5c3a67                            # 0045934b
    call FUN_004fba69                            # 00459350
    jmp.d8 L_0045937b                            # 00459355
L_00459357:
    # block 0x00459357: entered by jne at 0x004592fc, 9 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045937b
    mov ecx, dword ptr [ebp - local_10]          # 00459357
    mov dx, word ptr [ecx + field_3c]            # 0045935a
    sub dx, 0x1                                  # 0045935e
    mov eax, dword ptr [ebp - local_10]          # 00459362
    mov word ptr [eax + field_3c], dx            # 00459365
    call dword ptr [0x52a23c]                    # 00459369
    add eax, 0x28                                # 0045936f
    mov ecx, dword ptr [ebp - local_10]          # 00459372
    mov dword ptr [ecx + field_bc], eax          # 00459375
L_0045937b:
    # block 0x0045937b: entered by jb at 0x004592e6; jmp at 0x00459355, 1 instruction(s), ends with forward jump to 0x0045940a
    jmp.d32 L_0045940a                           # 0045937b
L_00459380:
    # block 0x00459380: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045940a (forward)
    call dword ptr [0x52a23c]                    # 00459380
    mov edx, dword ptr [ebp - local_10]          # 00459386
    cmp eax, dword ptr [edx + field_bc]          # 00459389
    jb.d8 L_0045940a                             # 0045938f
    # block 0x00459391: entered by fall-through of jb at 0x0045938f, 6 instruction(s), ends with jle to 0x004593e6 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00459391
    movsx ecx, word ptr [eax + field_3c]         # 00459394
    mov edx, dword ptr [ebp - local_8]           # 00459398
    movsx eax, word ptr [edx + field_21]         # 0045939b
    {load} cmp ecx, eax                          # 0045939f
    jle.d8 L_004593e6                            # 004593a1
    # block 0x004593a3: entered by fall-through of jle at 0x004593a1, 14 instruction(s), calls FUN_004fba69, ends with forward jump to 0x0045940a
    movsx ecx, word ptr [0x5a4c08]               # 004593a3
    mov word ptr [2*ecx + 0x5a4bd6], 0xffff      # 004593aa
    mov edx, dword ptr [ebp - local_10]          # 004593b4
    mov dword ptr [edx + field_20], 0x0          # 004593b7
    mov eax, dword ptr [ebp - local_10]          # 004593be
    mov word ptr [eax + field_3c], 0xffff        # 004593c1
    mov ecx, dword ptr [ebp - local_10]          # 004593c7
    mov word ptr [ecx + field_3a], 0xffff        # 004593ca
    mov edx, dword ptr [ebp - local_8]           # 004593d0
    add edx, 0x55b                               # 004593d3
    push edx                                     # 004593d9
    mov ecx, 0x5c3a67                            # 004593da
    call FUN_004fba69                            # 004593df
    jmp.d8 L_0045940a                            # 004593e4
L_004593e6:
    # block 0x004593e6: entered by jle at 0x004593a1, 9 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045940a
    mov eax, dword ptr [ebp - local_10]          # 004593e6
    mov cx, word ptr [eax + field_3c]            # 004593e9
    add cx, 0x1                                  # 004593ed
    mov edx, dword ptr [ebp - local_10]          # 004593f1
    mov word ptr [edx + field_3c], cx            # 004593f4
    call dword ptr [0x52a23c]                    # 004593f8
    add eax, 0x28                                # 004593fe
    mov ecx, dword ptr [ebp - local_10]          # 00459401
    mov dword ptr [ecx + field_bc], eax          # 00459404
L_0045940a:
    # block 0x0045940a: entered by ja at 0x004590c7; jmp at 0x00459108; jmp at 0x0045921a; jmp at 0x0045926a; more, 1 instruction(s), ends with forward jump to 0x004595c1
    jmp.d32 L_004595c1                           # 0045940a
L_0045940f:
    # block 0x0045940f: entered by je at 0x00458ea1, 6 instruction(s), ends with je to 0x004594e4 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0045940f
    mov edx, dword ptr [ebp - local_10]          # 00459419
    {load} xor eax, eax                          # 0045941c
    mov al, byte ptr [edx + field_9c]            # 0045941e
    test eax, eax                                # 00459424
    je.d32 L_004594e4                            # 00459426
    # block 0x0045942c: entered by fall-through of je at 0x00459426, 4 instruction(s), ends with je to 0x004594df (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045942c
    movsx edx, word ptr [ecx + field_63d]        # 0045942f
    cmp edx, 0x270f                              # 00459436
    je.d32 L_004594df                            # 0045943c
    # block 0x00459442: entered by fall-through of je at 0x0045943c, 25 instruction(s), ends with jne to 0x004594cb (forward)
    mov eax, dword ptr [ebp - local_8]           # 00459442
    movsx ecx, word ptr [eax + field_63d]        # 00459445
    mov dword ptr [0x5bb57b], ecx                # 0045944c
    mov edx, dword ptr [ebp - local_8]           # 00459452
    mov ax, word ptr [edx + field_63f]           # 00459455
    mov word ptr [0x5bb599], ax                  # 0045945c
    mov ecx, dword ptr [ebp - local_8]           # 00459462
    mov dx, word ptr [ecx + field_641]           # 00459465
    mov word ptr [0x5bb595], dx                  # 0045946c
    mov eax, dword ptr [ebp - local_8]           # 00459473
    mov cx, word ptr [eax + field_643]           # 00459476
    mov word ptr [0x5c39ff], cx                  # 0045947d
    mov edx, dword ptr [ebp - local_8]           # 00459484
    mov eax, dword ptr [edx + field_645]         # 00459487
    mov dword ptr [0x5bb59b], eax                # 0045948d
    mov ecx, dword ptr [ebp - local_8]           # 00459492
    mov edx, dword ptr [ecx + field_649]         # 00459495
    mov dword ptr [0x5bb59f], edx                # 0045949b
    mov eax, dword ptr [ebp - local_8]           # 004594a1
    mov ecx, dword ptr [eax + field_64d]         # 004594a4
    mov dword ptr [0x5bb5a3], ecx                # 004594aa
    mov edx, dword ptr [ebp - local_8]           # 004594b0
    movsx eax, word ptr [edx + field_651]        # 004594b3
    cmp eax, 0x1                                 # 004594ba
    jne.d8 L_004594cb                            # 004594bd
    # block 0x004594bf: entered by fall-through of jne at 0x004594bd, 2 instruction(s), ends with forward jump to 0x004594d5
    mov dword ptr [0x5bb1ca], 0x0                # 004594bf
    jmp.d8 L_004594d5                            # 004594c9
L_004594cb:
    # block 0x004594cb: entered by jne at 0x004594bd, 1 instruction(s), falls into the block at 0x004594d5
    mov dword ptr [0x5bb1ca], 0x1                # 004594cb
L_004594d5:
    # block 0x004594d5: entered by jmp at 0x004594c9, 1 instruction(s), falls into the block at 0x004594df
    mov dword ptr [0x583999], 0x4                # 004594d5
L_004594df:
    # block 0x004594df: entered by je at 0x0045943c, 1 instruction(s), ends with forward jump to 0x004595a9
    jmp.d32 L_004595a9                           # 004594df
L_004594e4:
    # block 0x004594e4: entered by je at 0x00459426, 5 instruction(s), ends with je to 0x004595a9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004594e4
    {load} xor edx, edx                          # 004594e7
    mov dl, byte ptr [ecx + field_9d]            # 004594e9
    test edx, edx                                # 004594ef
    je.d32 L_004595a9                            # 004594f1
    # block 0x004594f7: entered by fall-through of je at 0x004594f1, 4 instruction(s), ends with je to 0x004595a9 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004594f7
    movsx ecx, word ptr [eax + field_627]        # 004594fa
    cmp ecx, 0x270f                              # 00459501
    je.d32 L_004595a9                            # 00459507
    # block 0x0045950d: entered by fall-through of je at 0x00459507, 25 instruction(s), ends with jne to 0x00459595 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0045950d
    movsx eax, word ptr [edx + field_627]        # 00459510
    mov dword ptr [0x5bb57b], eax                # 00459517
    mov ecx, dword ptr [ebp - local_8]           # 0045951c
    mov dx, word ptr [ecx + field_629]           # 0045951f
    mov word ptr [0x5bb599], dx                  # 00459526
    mov eax, dword ptr [ebp - local_8]           # 0045952d
    mov cx, word ptr [eax + field_62b]           # 00459530
    mov word ptr [0x5bb595], cx                  # 00459537
    mov edx, dword ptr [ebp - local_8]           # 0045953e
    mov ax, word ptr [edx + field_62d]           # 00459541
    mov word ptr [0x5c39ff], ax                  # 00459548
    mov ecx, dword ptr [ebp - local_8]           # 0045954e
    mov edx, dword ptr [ecx + field_62f]         # 00459551
    mov dword ptr [0x5bb59b], edx                # 00459557
    mov eax, dword ptr [ebp - local_8]           # 0045955d
    mov ecx, dword ptr [eax + field_633]         # 00459560
    mov dword ptr [0x5bb59f], ecx                # 00459566
    mov edx, dword ptr [ebp - local_8]           # 0045956c
    mov eax, dword ptr [edx + field_637]         # 0045956f
    mov dword ptr [0x5bb5a3], eax                # 00459575
    mov ecx, dword ptr [ebp - local_8]           # 0045957a
    movsx edx, word ptr [ecx + field_63b]        # 0045957d
    cmp edx, 0x1                                 # 00459584
    jne.d8 L_00459595                            # 00459587
    # block 0x00459589: entered by fall-through of jne at 0x00459587, 2 instruction(s), ends with forward jump to 0x0045959f
    mov dword ptr [0x5bb1ca], 0x0                # 00459589
    jmp.d8 L_0045959f                            # 00459593
L_00459595:
    # block 0x00459595: entered by jne at 0x00459587, 1 instruction(s), falls into the block at 0x0045959f
    mov dword ptr [0x5bb1ca], 0x1                # 00459595
L_0045959f:
    # block 0x0045959f: entered by jmp at 0x00459593, 1 instruction(s), falls into the block at 0x004595a9
    mov dword ptr [0x583999], 0x4                # 0045959f
L_004595a9:
    # block 0x004595a9: entered by jmp at 0x004594df; je at 0x004594f1; je at 0x00459507, 7 instruction(s), calls FUN_0042ba3a, FUN_00457fc2, falls into the block at 0x004595c1
    mov eax, dword ptr [ebp - local_10]          # 004595a9
    mov cx, word ptr [eax + field_26]            # 004595ac
    push ecx                                     # 004595b0
    call FUN_0042ba3a                            # 004595b1
    add esp, 0x4                                 # 004595b6
    mov ecx, dword ptr [ebp - local_10]          # 004595b9
    call FUN_00457fc2                            # 004595bc
L_004595c1:
    # block 0x004595c1: entered by jmp at 0x00458ea7; jmp at 0x004590b5; jmp at 0x0045940a, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004595c1
    pop esi                                      # 004595c2
    {load} mov esp, ebp                          # 004595c3
    pop ebp                                      # 004595c5
    ret 0x4                                      # 004595c6

# --- data items (not part of the function) -------------------------
.org 0x004595c9 - 0x401000
SWTAB_004595c9:  # 6 case address(es)
    .long L_004590d7 - .text + 0x401000
    .long L_004592a3 - .text + 0x401000
    .long L_00459380 - .text + 0x401000
    .long L_0045926f - .text + 0x401000
    .long L_0045910d - .text + 0x401000
    .long L_0045921f - .text + 0x401000
.set SWTAB_004595c9_VA, SWTAB_004595c9 - .text + 0x401000

