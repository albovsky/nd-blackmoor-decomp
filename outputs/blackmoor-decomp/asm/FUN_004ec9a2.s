# FUN_004ec9a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec9a2
# extent:       0x004ec9a2-0x004ed706 (3428 code bytes)
# span:         0x004ec9a2-0x004ed71e (code 3428, tables 24, padding 0)
# sha256:       559a62d3a5083f3ded7f9e667d7110514e706a429a6f96bb0249bbdf9477ef01
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ec9a2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       9 ebp-relative slot(s): local_4, local_9c44, local_9c48, local_9c4c, local_9c50, local_9c54, local_9c58, local_9c5c, local_9c60
# fields:       [eax + n] field_b73, field_b77, field_b7b, field_b7f, field_b87, field_ca0, field_ca4, field_ca8, field_fca, field_fce, field_fda, field_fde and 9 more; [ecx + n] field_985, field_989, field_b73, field_b77, field_b7b, field_b7f, field_b87, field_ca0, field_fca, field_fda, field_fde, field_fe2 and 8 more; [edi + n] field_minus_1; [edx + n] field_989, field_b73, field_b77, field_b7b, field_b83, field_ca0, field_ca8, field_fce, field_fda, field_fde, field_fe2, field_fe6 and 7 more
# callees:      calls FUN_0050c920, FUN_004e0559, FUN_004ee5cd, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_00423259, FUN_005193ca, FUN_00413187, FUN_0043dbd5, FUN_004d36ed, FUN_004e29ec, FUN_004e2913, FUN_004e29b7 and 5 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 724 instruction(s), 31 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_9c44, 0x9c44  # offset -0x9c44
.equ local_9c48, 0x9c48  # offset -0x9c48
.equ local_9c4c, 0x9c4c  # offset -0x9c4c
.equ local_9c50, 0x9c50  # offset -0x9c50
.equ local_9c54, 0x9c54  # offset -0x9c54
.equ local_9c58, 0x9c58  # offset -0x9c58
.equ local_9c5c, 0x9c5c  # offset -0x9c5c
.equ local_9c60, 0x9c60  # offset -0x9c60
.equ field_985, 0x985  # offset +0x985
.equ field_989, 0x989  # offset +0x989
.equ field_b73, 0xb73  # offset +0xb73
.equ field_b77, 0xb77  # offset +0xb77
.equ field_b7b, 0xb7b  # offset +0xb7b
.equ field_b7f, 0xb7f  # offset +0xb7f
.equ field_b83, 0xb83  # offset +0xb83
.equ field_b87, 0xb87  # offset +0xb87
.equ field_ca0, 0xca0  # offset +0xca0
.equ field_ca4, 0xca4  # offset +0xca4
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fce, 0xfce  # offset +0xfce
.equ field_fda, 0xfda  # offset +0xfda
.equ field_fde, 0xfde  # offset +0xfde
.equ field_fe2, 0xfe2  # offset +0xfe2
.equ field_fe6, 0xfe6  # offset +0xfe6
.equ field_28da, 0x28da  # offset +0x28da
.equ field_28dc, 0x28dc  # offset +0x28dc
.equ field_28de, 0x28de  # offset +0x28de
.equ field_28e0, 0x28e0  # offset +0x28e0
.equ field_28e4, 0x28e4  # offset +0x28e4
.equ field_28e8, 0x28e8  # offset +0x28e8
.equ field_28ec, 0x28ec  # offset +0x28ec
.equ field_28f6, 0x28f6  # offset +0x28f6
.equ field_28f8, 0x28f8  # offset +0x28f8
.equ field_28fa, 0x28fa  # offset +0x28fa
.equ field_28fc, 0x28fc  # offset +0x28fc
.equ field_28fe, 0x28fe  # offset +0x28fe
.equ field_2900, 0x2900  # offset +0x2900
.equ field_2902, 0x2902  # offset +0x2902
.equ field_2904, 0x2904  # offset +0x2904

# --- external targets -----------------------------------------------
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e29b7, .text + (0x004e29b7 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004eb96e, .text + (0x004eb96e - 0x401000)
.set FUN_004ec44b, .text + (0x004ec44b - 0x401000)
.set FUN_004ec4b9, .text + (0x004ec4b9 - 0x401000)
.set FUN_004ee5cd, .text + (0x004ee5cd - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x004ec9a2 - 0x401000
.globl FUN_004ec9a2
FUN_004ec9a2:
    # block 0x004ec9a2: entry, 13 instruction(s), calls FUN_0050c920, ends with ja to 0x004ed6ff (forward)
    push ebp                                     # 004ec9a2
    {load} mov ebp, esp                          # 004ec9a3
    mov eax, 0x9c60                              # 004ec9a5
    call FUN_0050c920                            # 004ec9aa
    push ebx                                     # 004ec9af
    push esi                                     # 004ec9b0
    push edi                                     # 004ec9b1
    mov dword ptr [ebp - local_9c58], ecx        # 004ec9b2
    mov eax, dword ptr [ebp - local_9c58]        # 004ec9b8
    mov ecx, dword ptr [eax + field_ca0]         # 004ec9be
    mov dword ptr [ebp - local_9c5c], ecx        # 004ec9c4
    cmp dword ptr [ebp - local_9c5c], 0x5        # 004ec9ca
    ja.d32 L_004ed6ff                            # 004ec9d1
    # block 0x004ec9d7: entered by fall-through of ja at 0x004ec9d1, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4ed706]
    mov edx, dword ptr [ebp - local_9c5c]        # 004ec9d7
    jmp dword ptr [4*edx + SWTAB_004ed706_VA]    # 004ec9dd
L_004ec9e4:
    # block 0x004ec9e4: entered by switch case, 42 instruction(s), calls FUN_004e0559, FUN_004ee5cd, ends with jne to 0x004ecad5 (forward)
    mov ecx, 0x39                                # 004ec9e4
    {load} xor eax, eax                          # 004ec9e9
    mov edi, dword ptr [ebp - local_9c58]        # 004ec9eb
    add edi, 0x28f6                              # 004ec9f1
    rep stosd dword ptr es:[edi], eax            # 004ec9f7
    stosw word ptr es:[edi], ax                  # 004ec9f9
    stosb byte ptr es:[edi], al                  # 004ec9fb
    mov eax, dword ptr [ebp - local_9c58]        # 004ec9fc
    mov word ptr [eax + field_28f6], 0x2         # 004eca02
    mov ecx, dword ptr [ebp - local_9c58]        # 004eca0b
    mov edx, dword ptr [ebp - local_9c58]        # 004eca11
    mov ax, word ptr [edx + field_b83]           # 004eca17
    mov word ptr [ecx + field_28fa], ax          # 004eca1e
    mov ecx, dword ptr [ebp - local_9c58]        # 004eca25
    mov word ptr [ecx + field_28fc], 0x0         # 004eca2b
    mov edx, dword ptr [ebp - local_9c58]        # 004eca34
    mov word ptr [edx + field_28fe], 0x0         # 004eca3a
    mov eax, dword ptr [ebp - local_9c58]        # 004eca43
    mov word ptr [eax + field_2900], 0x0         # 004eca49
    mov ecx, dword ptr [ebp - local_9c58]        # 004eca52
    mov edx, dword ptr [ebp - local_9c58]        # 004eca58
    mov eax, dword ptr [ecx + field_b7b]         # 004eca5e
    sub eax, dword ptr [edx + field_b73]         # 004eca64
    mov ecx, dword ptr [ebp - local_9c58]        # 004eca6a
    mov word ptr [ecx + field_2902], ax          # 004eca70
    mov edx, dword ptr [ebp - local_9c58]        # 004eca77
    mov word ptr [edx + field_2904], 0x3e80      # 004eca7d
    mov eax, dword ptr [ebp - local_9c58]        # 004eca86
    mov word ptr [eax + field_28f8], 0x4         # 004eca8c
    push 0x0                                     # 004eca95
    push 0x0                                     # 004eca97
    push 0x2                                     # 004eca99
    mov ecx, 0x570508                            # 004eca9b
    call FUN_004e0559                            # 004ecaa0
    mov ecx, 0x2710                              # 004ecaa5
    {load} xor eax, eax                          # 004ecaaa
    lea edi, [ebp - local_9c44]                  # 004ecaac
    rep stosd dword ptr es:[edi], eax            # 004ecab2
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecab4
    call FUN_004ee5cd                            # 004ecaba
    test eax, eax                                # 004ecabf
    jne.d8 L_004ecad5                            # 004ecac1
    # block 0x004ecac3: entered by fall-through of jne at 0x004ecac1, 3 instruction(s), ends with forward jump to 0x004ecae5
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecac3
    mov dword ptr [ecx + field_ca0], 0x4         # 004ecac9
    jmp.d8 L_004ecae5                            # 004ecad3
L_004ecad5:
    # block 0x004ecad5: entered by jne at 0x004ecac1, 2 instruction(s), falls into the block at 0x004ecae5
    mov edx, dword ptr [ebp - local_9c58]        # 004ecad5
    mov dword ptr [edx + field_ca0], 0x5         # 004ecadb
L_004ecae5:
    # block 0x004ecae5: entered by jmp at 0x004ecad3, 1 instruction(s), ends with forward jump to 0x004ed6ff
    jmp.d32 L_004ed6ff                           # 004ecae5
L_004ecaea:
    # block 0x004ecaea: entered by switch case, 4 instruction(s), calls FUN_004ee5cd, ends with je to 0x004ecb6d (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecaea
    call FUN_004ee5cd                            # 004ecaf0
    test eax, eax                                # 004ecaf5
    je.d8 L_004ecb6d                             # 004ecaf7
    # block 0x004ecaf9: entered by fall-through of je at 0x004ecaf7, 4 instruction(s), calls FUN_004ee5f2, ends with je to 0x004ecb5d (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecaf9
    call FUN_004ee5f2                            # 004ecaff
    cmp eax, 0x3                                 # 004ecb04
    je.d8 L_004ecb5d                             # 004ecb07
    # block 0x004ecb09: entered by fall-through of je at 0x004ecb07, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004ecb4e (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecb09
    call FUN_004ee5f2                            # 004ecb0f
    push eax                                     # 004ecb14
    push 0x55ccb8                                # 004ecb15
    push 0x63888b                                # 004ecb1a
    call FUN_0050ca3e                            # 004ecb1f
    add esp, 0xc                                 # 004ecb24
    push 0x63888b                                # 004ecb27
    mov ecx, 0x583979                            # 004ecb2c
    call FUN_004264e8                            # 004ecb31
    movsx eax, word ptr [0x63a4cd]               # 004ecb36
    test eax, eax                                # 004ecb3d
    je.d8 L_004ecb4e                             # 004ecb3f
    # block 0x004ecb41: entered by fall-through of je at 0x004ecb3f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ecb4e
    push 0x63888b                                # 004ecb41
    call FUN_0044a2b7                            # 004ecb46
    add esp, 0x4                                 # 004ecb4b
L_004ecb4e:
    # block 0x004ecb4e: entered by je at 0x004ecb3f, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ed6ff
    mov ecx, 0x5cf659                            # 004ecb4e
    call FUN_004c97b4                            # 004ecb53
    jmp.d32 L_004ed6ff                           # 004ecb58
L_004ecb5d:
    # block 0x004ecb5d: entered by je at 0x004ecb07, 2 instruction(s), falls into the block at 0x004ecb6d
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecb5d
    mov dword ptr [ecx + field_ca0], 0x5         # 004ecb63
L_004ecb6d:
    # block 0x004ecb6d: entered by je at 0x004ecaf7, 1 instruction(s), ends with forward jump to 0x004ed6ff
    jmp.d32 L_004ed6ff                           # 004ecb6d
L_004ecb72:
    # block 0x004ecb72: entered by switch case, 6 instruction(s), ends with forward jump to 0x004ecba8
    mov word ptr [ebp - local_9c54], 0x1         # 004ecb72
    movsx edx, word ptr [ebp - local_9c54]       # 004ecb7b
    movsx eax, word ptr [2*edx + 0x59fbdb]       # 004ecb82
    sub eax, 0x1                                 # 004ecb8a
    mov word ptr [ebp - local_9c48], ax          # 004ecb8d
    jmp.d8 L_004ecba8                            # 004ecb94
L_004ecb96:
    # block 0x004ecb96: entered by jmp at 0x004ecce5, 3 instruction(s), falls into the block at 0x004ecba8
    mov cx, word ptr [ebp - local_9c48]          # 004ecb96
    sub cx, 0x1                                  # 004ecb9d
    mov word ptr [ebp - local_9c48], cx          # 004ecba1
L_004ecba8:
    # block 0x004ecba8: entered by jmp at 0x004ecb94, 3 instruction(s), ends with jl to 0x004eccea (forward)
    movsx edx, word ptr [ebp - local_9c48]       # 004ecba8
    test edx, edx                                # 004ecbaf
    jl.d32 L_004eccea                            # 004ecbb1
    # block 0x004ecbb7: entered by fall-through of jl at 0x004ecbb1, 11 instruction(s), calls FUN_00423259, ends with je to 0x004ecce5 (forward)
    movsx eax, word ptr [ebp - local_9c54]       # 004ecbb7
    imul eax, eax, 0x3390                        # 004ecbbe
    movsx ecx, word ptr [ebp - local_9c48]       # 004ecbc4
    imul ecx, ecx, 0x21                          # 004ecbcb
    lea edx, [eax + ecx + 0x5957cb]              # 004ecbce
    push edx                                     # 004ecbd5
    mov ecx, 0x619a6b                            # 004ecbd6
    call FUN_00423259                            # 004ecbdb
    mov dword ptr [ebp - local_9c4c], eax        # 004ecbe0
    cmp dword ptr [ebp - local_9c4c], 0x0        # 004ecbe6
    je.d32 L_004ecce5                            # 004ecbed
    # block 0x004ecbf3: entered by fall-through of je at 0x004ecbed, 6 instruction(s), ends with je to 0x004eccb0 (forward)
    movsx eax, word ptr [ebp - local_9c54]       # 004ecbf3
    imul eax, eax, 0x320                         # 004ecbfa
    movsx ecx, word ptr [ebp - local_9c48]       # 004ecc00
    movsx edx, word ptr [eax + 2*ecx + 0x59f27b] # 004ecc07
    test edx, edx                                # 004ecc0f
    je.d32 L_004eccb0                            # 004ecc11
    # block 0x004ecc17: entered by fall-through of je at 0x004ecc11, 44 instruction(s), calls FUN_005193ca, falls into the block at 0x004eccb0
    lea edi, [ebp - local_9c44]                  # 004ecc17
    or ecx, -0x1                                 # 004ecc1d
    {load} xor eax, eax                          # 004ecc20
    repne scasb al, byte ptr es:[edi]            # 004ecc22
    mov ax, word ptr [0x55cd28]                  # 004ecc24
    mov word ptr [edi - field_minus_1], ax       # 004ecc2a
    movsx ecx, word ptr [ebp - local_9c54]       # 004ecc2e
    imul ecx, ecx, 0x320                         # 004ecc35
    movsx edx, word ptr [ebp - local_9c48]       # 004ecc3b
    mov ax, word ptr [ecx + 2*edx + 0x59f27b]    # 004ecc42
    mov word ptr [ebp - local_4], ax             # 004ecc4a
    push 0xa                                     # 004ecc4e
    lea ecx, [ebp - local_9c50]                  # 004ecc50
    push ecx                                     # 004ecc56
    movsx edx, word ptr [ebp - local_4]          # 004ecc57
    push edx                                     # 004ecc5b
    call FUN_005193ca                            # 004ecc5c
    add esp, 0xc                                 # 004ecc61
    lea edi, [ebp - local_9c50]                  # 004ecc64
    lea edx, [ebp - local_9c44]                  # 004ecc6a
    or ecx, -0x1                                 # 004ecc70
    {load} xor eax, eax                          # 004ecc73
    repne scasb al, byte ptr es:[edi]            # 004ecc75
    not ecx                                      # 004ecc77
    {load} sub edi, ecx                          # 004ecc79
    {load} mov esi, edi                          # 004ecc7b
    {load} mov ebx, ecx                          # 004ecc7d
    {load} mov edi, edx                          # 004ecc7f
    or ecx, -0x1                                 # 004ecc81
    {load} xor eax, eax                          # 004ecc84
    repne scasb al, byte ptr es:[edi]            # 004ecc86
    add edi, -0x1                                # 004ecc88
    {load} mov ecx, ebx                          # 004ecc8b
    shr ecx, 0x2                                 # 004ecc8d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ecc90
    {load} mov ecx, ebx                          # 004ecc92
    and ecx, 0x3                                 # 004ecc94
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ecc97
    lea edi, [ebp - local_9c44]                  # 004ecc99
    or ecx, -0x1                                 # 004ecc9f
    {load} xor eax, eax                          # 004ecca2
    repne scasb al, byte ptr es:[edi]            # 004ecca4
    mov ax, word ptr [0x55cd2c]                  # 004ecca6
    mov word ptr [edi - field_minus_1], ax       # 004eccac
L_004eccb0:
    # block 0x004eccb0: entered by je at 0x004ecc11, 20 instruction(s), falls into the block at 0x004ecce5
    mov edi, dword ptr [ebp - local_9c4c]        # 004eccb0
    lea edx, [ebp - local_9c44]                  # 004eccb6
    or ecx, -0x1                                 # 004eccbc
    {load} xor eax, eax                          # 004eccbf
    repne scasb al, byte ptr es:[edi]            # 004eccc1
    not ecx                                      # 004eccc3
    {load} sub edi, ecx                          # 004eccc5
    {load} mov esi, edi                          # 004eccc7
    {load} mov ebx, ecx                          # 004eccc9
    {load} mov edi, edx                          # 004ecccb
    or ecx, -0x1                                 # 004ecccd
    {load} xor eax, eax                          # 004eccd0
    repne scasb al, byte ptr es:[edi]            # 004eccd2
    add edi, -0x1                                # 004eccd4
    {load} mov ecx, ebx                          # 004eccd7
    shr ecx, 0x2                                 # 004eccd9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eccdc
    {load} mov ecx, ebx                          # 004eccde
    and ecx, 0x3                                 # 004ecce0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ecce3
L_004ecce5:
    # block 0x004ecce5: entered by je at 0x004ecbed, 1 instruction(s), ends with backward jump to 0x004ecb96
    jmp.d32 L_004ecb96                           # 004ecce5
L_004eccea:
    # block 0x004eccea: entered by jl at 0x004ecbb1, 24 instruction(s), calls FUN_00413187, ends with je to 0x004ecd73 (forward)
    lea eax, [ebp - local_9c44]                  # 004eccea
    mov dword ptr [ebp - local_9c4c], eax        # 004eccf0
    push 0x0                                     # 004eccf6
    push 0x0                                     # 004eccf8
    mov ecx, dword ptr [ebp - local_9c4c]        # 004eccfa
    push ecx                                     # 004ecd00
    mov edx, dword ptr [ebp - local_9c58]        # 004ecd01
    add edx, 0x28f6                              # 004ecd07
    push edx                                     # 004ecd0d
    mov ecx, 0x619a41                            # 004ecd0e
    call FUN_00413187                            # 004ecd13
    mov eax, dword ptr [ebp - local_9c58]        # 004ecd18
    mov cx, word ptr [0x619a63]                  # 004ecd1e
    mov word ptr [eax + field_28de], cx          # 004ecd25
    mov edx, dword ptr [ebp - local_9c58]        # 004ecd2c
    mov word ptr [edx + field_28f8], 0x3         # 004ecd32
    mov word ptr [ebp - local_9c54], 0x0         # 004ecd3b
    mov ecx, 0x2710                              # 004ecd44
    {load} xor eax, eax                          # 004ecd49
    lea edi, [ebp - local_9c44]                  # 004ecd4b
    rep stosd dword ptr es:[edi], eax            # 004ecd51
    movsx eax, word ptr [0x58c94f]               # 004ecd53
    test eax, eax                                # 004ecd5a
    je.d8 L_004ecd73                             # 004ecd5c
    # block 0x004ecd5e: entered by fall-through of je at 0x004ecd5c, 4 instruction(s), ends with jne to 0x004ecef1 (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecd5e
    movsx edx, word ptr [ecx + field_b87]        # 004ecd64
    test edx, edx                                # 004ecd6b
    jne.d32 L_004ecef1                           # 004ecd6d
L_004ecd73:
    # block 0x004ecd73: entered by je at 0x004ecd5c; fall-through of jne at 0x004ecd6d, 5 instruction(s), ends with forward jump to 0x004ecda0
    movsx eax, word ptr [ebp - local_9c54]       # 004ecd73
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 004ecd7a
    sub ecx, 0x1                                 # 004ecd82
    mov word ptr [ebp - local_9c48], cx          # 004ecd85
    jmp.d8 L_004ecda0                            # 004ecd8c
L_004ecd8e:
    # block 0x004ecd8e: entered by jmp at 0x004ecede, 3 instruction(s), falls into the block at 0x004ecda0
    mov dx, word ptr [ebp - local_9c48]          # 004ecd8e
    sub dx, 0x1                                  # 004ecd95
    mov word ptr [ebp - local_9c48], dx          # 004ecd99
L_004ecda0:
    # block 0x004ecda0: entered by jmp at 0x004ecd8c, 3 instruction(s), ends with jl to 0x004ecee3 (forward)
    movsx eax, word ptr [ebp - local_9c48]       # 004ecda0
    test eax, eax                                # 004ecda7
    jl.d32 L_004ecee3                            # 004ecda9
    # block 0x004ecdaf: entered by fall-through of jl at 0x004ecda9, 11 instruction(s), calls FUN_00423259, ends with je to 0x004ecede (forward)
    movsx ecx, word ptr [ebp - local_9c54]       # 004ecdaf
    imul ecx, ecx, 0x3390                        # 004ecdb6
    movsx edx, word ptr [ebp - local_9c48]       # 004ecdbc
    imul edx, edx, 0x21                          # 004ecdc3
    lea eax, [ecx + edx + 0x5957cb]              # 004ecdc6
    push eax                                     # 004ecdcd
    mov ecx, 0x619a6b                            # 004ecdce
    call FUN_00423259                            # 004ecdd3
    mov dword ptr [ebp - local_9c4c], eax        # 004ecdd8
    cmp dword ptr [ebp - local_9c4c], 0x0        # 004ecdde
    je.d32 L_004ecede                            # 004ecde5
    # block 0x004ecdeb: entered by fall-through of je at 0x004ecde5, 6 instruction(s), ends with je to 0x004ecea9 (forward)
    movsx ecx, word ptr [ebp - local_9c54]       # 004ecdeb
    imul ecx, ecx, 0x320                         # 004ecdf2
    movsx edx, word ptr [ebp - local_9c48]       # 004ecdf8
    movsx eax, word ptr [ecx + 2*edx + 0x59f27b] # 004ecdff
    test eax, eax                                # 004ece07
    je.d32 L_004ecea9                            # 004ece09
    # block 0x004ece0f: entered by fall-through of je at 0x004ece09, 44 instruction(s), calls FUN_005193ca, falls into the block at 0x004ecea9
    lea edi, [ebp - local_9c44]                  # 004ece0f
    or ecx, -0x1                                 # 004ece15
    {load} xor eax, eax                          # 004ece18
    repne scasb al, byte ptr es:[edi]            # 004ece1a
    mov cx, word ptr [0x55cd30]                  # 004ece1c
    mov word ptr [edi - field_minus_1], cx       # 004ece23
    movsx edx, word ptr [ebp - local_9c54]       # 004ece27
    imul edx, edx, 0x320                         # 004ece2e
    movsx eax, word ptr [ebp - local_9c48]       # 004ece34
    mov cx, word ptr [edx + 2*eax + 0x59f27b]    # 004ece3b
    mov word ptr [ebp - local_4], cx             # 004ece43
    push 0xa                                     # 004ece47
    lea edx, [ebp - local_9c50]                  # 004ece49
    push edx                                     # 004ece4f
    movsx eax, word ptr [ebp - local_4]          # 004ece50
    push eax                                     # 004ece54
    call FUN_005193ca                            # 004ece55
    add esp, 0xc                                 # 004ece5a
    lea edi, [ebp - local_9c50]                  # 004ece5d
    lea edx, [ebp - local_9c44]                  # 004ece63
    or ecx, -0x1                                 # 004ece69
    {load} xor eax, eax                          # 004ece6c
    repne scasb al, byte ptr es:[edi]            # 004ece6e
    not ecx                                      # 004ece70
    {load} sub edi, ecx                          # 004ece72
    {load} mov esi, edi                          # 004ece74
    {load} mov ebx, ecx                          # 004ece76
    {load} mov edi, edx                          # 004ece78
    or ecx, -0x1                                 # 004ece7a
    {load} xor eax, eax                          # 004ece7d
    repne scasb al, byte ptr es:[edi]            # 004ece7f
    add edi, -0x1                                # 004ece81
    {load} mov ecx, ebx                          # 004ece84
    shr ecx, 0x2                                 # 004ece86
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ece89
    {load} mov ecx, ebx                          # 004ece8b
    and ecx, 0x3                                 # 004ece8d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ece90
    lea edi, [ebp - local_9c44]                  # 004ece92
    or ecx, -0x1                                 # 004ece98
    {load} xor eax, eax                          # 004ece9b
    repne scasb al, byte ptr es:[edi]            # 004ece9d
    mov ax, word ptr [0x55cd34]                  # 004ece9f
    mov word ptr [edi - field_minus_1], ax       # 004ecea5
L_004ecea9:
    # block 0x004ecea9: entered by je at 0x004ece09, 20 instruction(s), falls into the block at 0x004ecede
    mov edi, dword ptr [ebp - local_9c4c]        # 004ecea9
    lea edx, [ebp - local_9c44]                  # 004eceaf
    or ecx, -0x1                                 # 004eceb5
    {load} xor eax, eax                          # 004eceb8
    repne scasb al, byte ptr es:[edi]            # 004eceba
    not ecx                                      # 004ecebc
    {load} sub edi, ecx                          # 004ecebe
    {load} mov esi, edi                          # 004ecec0
    {load} mov ebx, ecx                          # 004ecec2
    {load} mov edi, edx                          # 004ecec4
    or ecx, -0x1                                 # 004ecec6
    {load} xor eax, eax                          # 004ecec9
    repne scasb al, byte ptr es:[edi]            # 004ececb
    add edi, -0x1                                # 004ececd
    {load} mov ecx, ebx                          # 004eced0
    shr ecx, 0x2                                 # 004eced2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eced5
    {load} mov ecx, ebx                          # 004eced7
    and ecx, 0x3                                 # 004eced9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ecedc
L_004ecede:
    # block 0x004ecede: entered by je at 0x004ecde5, 1 instruction(s), ends with backward jump to 0x004ecd8e
    jmp.d32 L_004ecd8e                           # 004ecede
L_004ecee3:
    # block 0x004ecee3: entered by jl at 0x004ecda9, 3 instruction(s), ends with forward jump to 0x004ecf4b
    lea eax, [ebp - local_9c44]                  # 004ecee3
    mov dword ptr [ebp - local_9c4c], eax        # 004ecee9
    jmp.d8 L_004ecf4b                            # 004eceef
L_004ecef1:
    # block 0x004ecef1: entered by jne at 0x004ecd6d, 8 instruction(s), calls FUN_00423259, ends with jne to 0x004ecf4b (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecef1
    add ecx, 0xb89                               # 004ecef7
    push ecx                                     # 004ecefd
    mov ecx, 0x619a6b                            # 004ecefe
    call FUN_00423259                            # 004ecf03
    mov dword ptr [ebp - local_9c4c], eax        # 004ecf08
    cmp dword ptr [ebp - local_9c4c], 0x0        # 004ecf0e
    jne.d8 L_004ecf4b                            # 004ecf15
    # block 0x004ecf17: entered by fall-through of jne at 0x004ecf15, 17 instruction(s), falls into the block at 0x004ecf4b
    mov edi, 0x55cd38                            # 004ecf17
    lea edx, [ebp - local_9c44]                  # 004ecf1c
    or ecx, -0x1                                 # 004ecf22
    {load} xor eax, eax                          # 004ecf25
    repne scasb al, byte ptr es:[edi]            # 004ecf27
    not ecx                                      # 004ecf29
    {load} sub edi, ecx                          # 004ecf2b
    {load} mov esi, edi                          # 004ecf2d
    {load} mov eax, ecx                          # 004ecf2f
    {load} mov edi, edx                          # 004ecf31
    shr ecx, 0x2                                 # 004ecf33
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ecf36
    {load} mov ecx, eax                          # 004ecf38
    and ecx, 0x3                                 # 004ecf3a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ecf3d
    lea ecx, [ebp - local_9c44]                  # 004ecf3f
    mov dword ptr [ebp - local_9c4c], ecx        # 004ecf45
L_004ecf4b:
    # block 0x004ecf4b: entered by jmp at 0x004eceef; jne at 0x004ecf15, 15 instruction(s), calls FUN_00413187, ends with forward jump to 0x004ecf9f
    mov edx, dword ptr [ebp - local_9c58]        # 004ecf4b
    add edx, 0x28da                              # 004ecf51
    push edx                                     # 004ecf57
    mov eax, dword ptr [ebp - local_9c58]        # 004ecf58
    add eax, 0xfda                               # 004ecf5e
    push eax                                     # 004ecf63
    mov ecx, dword ptr [ebp - local_9c4c]        # 004ecf64
    push ecx                                     # 004ecf6a
    mov edx, dword ptr [ebp - local_9c58]        # 004ecf6b
    add edx, 0x28f6                              # 004ecf71
    push edx                                     # 004ecf77
    mov ecx, 0x619a41                            # 004ecf78
    call FUN_00413187                            # 004ecf7d
    mov word ptr [ebp - local_9c48], 0x0         # 004ecf82
    jmp.d8 L_004ecf9f                            # 004ecf8b
L_004ecf8d:
    # block 0x004ecf8d: entered by jmp at 0x004ed0a3, 3 instruction(s), falls into the block at 0x004ecf9f
    mov ax, word ptr [ebp - local_9c48]          # 004ecf8d
    .insn 0x66, 0x05, 0x0001{:u16}               # 004ecf94
    mov word ptr [ebp - local_9c48], ax          # 004ecf98
L_004ecf9f:
    # block 0x004ecf9f: entered by jmp at 0x004ecf8b, 5 instruction(s), ends with jge to 0x004ed0a8 (forward)
    movsx ecx, word ptr [ebp - local_9c48]       # 004ecf9f
    mov edx, dword ptr [ebp - local_9c58]        # 004ecfa6
    movsx eax, word ptr [edx + field_28da]       # 004ecfac
    {load} cmp ecx, eax                          # 004ecfb3
    jge.d32 L_004ed0a8                           # 004ecfb5
    # block 0x004ecfbb: entered by fall-through of jge at 0x004ecfb5, 41 instruction(s), ends with backward jump to 0x004ecf8d
    movsx ecx, word ptr [ebp - local_9c48]       # 004ecfbb
    shl ecx, 0x4                                 # 004ecfc2
    mov edx, dword ptr [ebp - local_9c58]        # 004ecfc5
    mov eax, dword ptr [edx + ecx + field_fda]   # 004ecfcb
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecfd2
    add eax, dword ptr [ecx + field_b73]         # 004ecfd8
    movsx edx, word ptr [ebp - local_9c48]       # 004ecfde
    shl edx, 0x4                                 # 004ecfe5
    mov ecx, dword ptr [ebp - local_9c58]        # 004ecfe8
    mov dword ptr [ecx + edx + field_fda], eax   # 004ecfee
    movsx edx, word ptr [ebp - local_9c48]       # 004ecff5
    shl edx, 0x4                                 # 004ecffc
    mov eax, dword ptr [ebp - local_9c58]        # 004ecfff
    mov ecx, dword ptr [eax + edx + field_fe2]   # 004ed005
    mov edx, dword ptr [ebp - local_9c58]        # 004ed00c
    add ecx, dword ptr [edx + field_b73]         # 004ed012
    movsx eax, word ptr [ebp - local_9c48]       # 004ed018
    shl eax, 0x4                                 # 004ed01f
    mov edx, dword ptr [ebp - local_9c58]        # 004ed022
    mov dword ptr [edx + eax + field_fe2], ecx   # 004ed028
    movsx eax, word ptr [ebp - local_9c48]       # 004ed02f
    shl eax, 0x4                                 # 004ed036
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed039
    mov edx, dword ptr [ecx + eax + field_fde]   # 004ed03f
    mov eax, dword ptr [ebp - local_9c58]        # 004ed046
    add edx, dword ptr [eax + field_b77]         # 004ed04c
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed052
    shl ecx, 0x4                                 # 004ed059
    mov eax, dword ptr [ebp - local_9c58]        # 004ed05c
    mov dword ptr [eax + ecx + field_fde], edx   # 004ed062
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed069
    shl ecx, 0x4                                 # 004ed070
    mov edx, dword ptr [ebp - local_9c58]        # 004ed073
    mov eax, dword ptr [edx + ecx + field_fe6]   # 004ed079
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed080
    add eax, dword ptr [ecx + field_b77]         # 004ed086
    movsx edx, word ptr [ebp - local_9c48]       # 004ed08c
    shl edx, 0x4                                 # 004ed093
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed096
    mov dword ptr [ecx + edx + field_fe6], eax   # 004ed09c
    jmp.d32 L_004ecf8d                           # 004ed0a3
L_004ed0a8:
    # block 0x004ed0a8: entered by jge at 0x004ecfb5, 28 instruction(s), calls FUN_0043dbd5, FUN_004d36ed, falls into the block at 0x004ed157
    mov edx, dword ptr [ebp - local_9c58]        # 004ed0a8
    mov ax, word ptr [0x619a5f]                  # 004ed0ae
    mov word ptr [edx + field_28dc], ax          # 004ed0b4
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed0bb
    mov dword ptr [ecx + field_28e0], 0x0        # 004ed0c1
    mov edx, dword ptr [ebp - local_9c58]        # 004ed0cb
    mov dword ptr [edx + field_28e4], 0x0        # 004ed0d1
    mov eax, dword ptr [ebp - local_9c58]        # 004ed0db
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed0e1
    mov edx, dword ptr [eax + field_b7b]         # 004ed0e7
    sub edx, dword ptr [ecx + field_b73]         # 004ed0ed
    mov eax, dword ptr [ebp - local_9c58]        # 004ed0f3
    mov dword ptr [eax + field_28e8], edx        # 004ed0f9
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed0ff
    mov edx, dword ptr [ebp - local_9c58]        # 004ed105
    mov eax, dword ptr [ecx + field_b7f]         # 004ed10b
    sub eax, dword ptr [edx + field_b77]         # 004ed111
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed117
    mov dword ptr [ecx + field_28ec], eax        # 004ed11d
    mov edx, dword ptr [ebp - local_9c58]        # 004ed123
    mov eax, dword ptr [ebp - local_9c58]        # 004ed129
    mov ecx, dword ptr [eax + field_ca4]         # 004ed12f
    mov dword ptr [edx + field_ca0], ecx         # 004ed135
    call FUN_0043dbd5                            # 004ed13b
    call FUN_004d36ed                            # 004ed140
    mov edx, dword ptr [ebp - local_9c58]        # 004ed145
    mov eax, dword ptr [edx + field_ca0]         # 004ed14b
    mov dword ptr [ebp - local_9c60], eax        # 004ed151
L_004ed157:
    # block 0x004ed157: entered by switch case, 2 instruction(s), ends with forward jump to 0x004ed174
    mov word ptr [ebp - local_9c48], 0x0         # 004ed157
    jmp.d8 L_004ed174                            # 004ed160
L_004ed162:
    # block 0x004ed162: entered by jmp at 0x004ed209, 3 instruction(s), falls into the block at 0x004ed174
    mov cx, word ptr [ebp - local_9c48]          # 004ed162
    add cx, 0x1                                  # 004ed169
    mov word ptr [ebp - local_9c48], cx          # 004ed16d
L_004ed174:
    # block 0x004ed174: entered by jmp at 0x004ed160, 3 instruction(s), ends with jge to 0x004ed20e (forward)
    movsx edx, word ptr [ebp - local_9c48]       # 004ed174
    cmp edx, 0x2                                 # 004ed17b
    jge.d32 L_004ed20e                           # 004ed17e
    # block 0x004ed184: entered by fall-through of jge at 0x004ed17e, 5 instruction(s), ends with je to 0x004ed209 (forward)
    movsx eax, word ptr [ebp - local_9c48]       # 004ed184
    imul eax, eax, 0xf7                          # 004ed18b
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed191
    cmp dword ptr [ecx + eax + field_985], 0x0   # 004ed197
    je.d8 L_004ed209                             # 004ed19f
    # block 0x004ed1a1: entered by fall-through of je at 0x004ed19f, 12 instruction(s), calls FUN_004e29ec, FUN_004e2913, ends with je to 0x004ed209 (forward)
    movsx edx, word ptr [ebp - local_9c48]       # 004ed1a1
    imul edx, edx, 0x18f                         # 004ed1a8
    mov eax, dword ptr [ebp - local_9c58]        # 004ed1ae
    lea ecx, [eax + edx + field_ca8]             # 004ed1b4
    call FUN_004e29ec                            # 004ed1bb
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed1c0
    imul ecx, ecx, 0x18f                         # 004ed1c7
    mov edx, dword ptr [ebp - local_9c58]        # 004ed1cd
    lea ecx, [edx + ecx + field_ca8]             # 004ed1d3
    call FUN_004e2913                            # 004ed1da
    test eax, eax                                # 004ed1df
    je.d8 L_004ed209                             # 004ed1e1
    # block 0x004ed1e3: entered by fall-through of je at 0x004ed1e1, 6 instruction(s), falls into the block at 0x004ed209
    movsx eax, word ptr [ebp - local_9c48]       # 004ed1e3
    imul eax, eax, 0xf7                          # 004ed1ea
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed1f0
    mov edx, dword ptr [ebp - local_9c58]        # 004ed1f6
    mov eax, dword ptr [edx + eax + field_989]   # 004ed1fc
    mov dword ptr [ecx + field_fca], eax         # 004ed203
L_004ed209:
    # block 0x004ed209: entered by je at 0x004ed19f; je at 0x004ed1e1, 1 instruction(s), ends with backward jump to 0x004ed162
    jmp.d32 L_004ed162                           # 004ed209
L_004ed20e:
    # block 0x004ed20e: entered by jge at 0x004ed17e, 5 instruction(s), ends with je to 0x004ed6cb (forward)
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed20e
    mov edx, dword ptr [ebp - local_9c58]        # 004ed214
    mov eax, dword ptr [ecx + field_fca]         # 004ed21a
    cmp eax, dword ptr [edx + field_fce]         # 004ed220
    je.d32 L_004ed6cb                            # 004ed226
    # block 0x004ed22c: entered by fall-through of je at 0x004ed226, 2 instruction(s), ends with forward jump to 0x004ed249
    mov word ptr [ebp - local_9c48], 0x0         # 004ed22c
    jmp.d8 L_004ed249                            # 004ed235
L_004ed237:
    # block 0x004ed237: entered by jmp at 0x004ed305, 3 instruction(s), falls into the block at 0x004ed249
    mov cx, word ptr [ebp - local_9c48]          # 004ed237
    add cx, 0x1                                  # 004ed23e
    mov word ptr [ebp - local_9c48], cx          # 004ed242
L_004ed249:
    # block 0x004ed249: entered by jmp at 0x004ed235, 3 instruction(s), ends with jge to 0x004ed30a (forward)
    movsx edx, word ptr [ebp - local_9c48]       # 004ed249
    cmp edx, 0x2                                 # 004ed250
    jge.d32 L_004ed30a                           # 004ed253
    # block 0x004ed259: entered by fall-through of jge at 0x004ed253, 5 instruction(s), ends with je to 0x004ed305 (forward)
    movsx eax, word ptr [ebp - local_9c48]       # 004ed259
    imul eax, eax, 0xf7                          # 004ed260
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed266
    cmp dword ptr [ecx + eax + field_985], 0x0   # 004ed26c
    je.d32 L_004ed305                            # 004ed274
    # block 0x004ed27a: entered by fall-through of je at 0x004ed274, 7 instruction(s), ends with jne to 0x004ed2e4 (forward)
    movsx edx, word ptr [ebp - local_9c48]       # 004ed27a
    imul edx, edx, 0xf7                          # 004ed281
    mov eax, dword ptr [ebp - local_9c58]        # 004ed287
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed28d
    mov eax, dword ptr [eax + field_fca]         # 004ed293
    cmp eax, dword ptr [ecx + edx + field_989]   # 004ed299
    jne.d8 L_004ed2e4                            # 004ed2a0
    # block 0x004ed2a2: entered by fall-through of jne at 0x004ed2a0, 9 instruction(s), calls FUN_004e29b7, ends with jne to 0x004ed2e2 (forward)
    push 0x1                                     # 004ed2a2
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed2a4
    imul ecx, ecx, 0x18f                         # 004ed2ab
    mov edx, dword ptr [ebp - local_9c58]        # 004ed2b1
    lea ecx, [edx + ecx + field_ca8]             # 004ed2b7
    call FUN_004e29b7                            # 004ed2be
    mov eax, dword ptr [ebp - local_9c58]        # 004ed2c3
    cmp dword ptr [eax + field_fca], 0x2         # 004ed2c9
    jne.d8 L_004ed2e2                            # 004ed2d0
    # block 0x004ed2d2: entered by fall-through of jne at 0x004ed2d0, 5 instruction(s), calls FUN_004e0559, falls into the block at 0x004ed2e2
    push 0x1                                     # 004ed2d2
    push 0x0                                     # 004ed2d4
    push 0x2                                     # 004ed2d6
    mov ecx, 0x570508                            # 004ed2d8
    call FUN_004e0559                            # 004ed2dd
L_004ed2e2:
    # block 0x004ed2e2: entered by jne at 0x004ed2d0, 1 instruction(s), ends with forward jump to 0x004ed305
    jmp.d8 L_004ed305                            # 004ed2e2
L_004ed2e4:
    # block 0x004ed2e4: entered by jne at 0x004ed2a0, 6 instruction(s), calls FUN_004e29b7, falls into the block at 0x004ed305
    push 0x0                                     # 004ed2e4
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed2e6
    imul ecx, ecx, 0x18f                         # 004ed2ed
    mov edx, dword ptr [ebp - local_9c58]        # 004ed2f3
    lea ecx, [edx + ecx + field_ca8]             # 004ed2f9
    call FUN_004e29b7                            # 004ed300
L_004ed305:
    # block 0x004ed305: entered by je at 0x004ed274; jmp at 0x004ed2e2, 1 instruction(s), ends with backward jump to 0x004ed237
    jmp.d32 L_004ed237                           # 004ed305
L_004ed30a:
    # block 0x004ed30a: entered by jge at 0x004ed253, 26 instruction(s), calls FUN_004ee673, ends with jne to 0x004ed6cb (forward)
    mov eax, dword ptr [ebp - local_9c58]        # 004ed30a
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed310
    mov edx, dword ptr [ecx + field_fca]         # 004ed316
    mov dword ptr [eax + field_fce], edx         # 004ed31c
    push 0x0                                     # 004ed322
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed324
    call FUN_004ee673                            # 004ed32a
    mov eax, dword ptr [ebp - local_9c58]        # 004ed32f
    mov dword ptr [eax + field_28e0], 0x0        # 004ed335
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed33f
    mov dword ptr [ecx + field_28e4], 0x0        # 004ed345
    mov edx, dword ptr [ebp - local_9c58]        # 004ed34f
    mov eax, dword ptr [ebp - local_9c58]        # 004ed355
    mov ecx, dword ptr [edx + field_b7b]         # 004ed35b
    sub ecx, dword ptr [eax + field_b73]         # 004ed361
    mov edx, dword ptr [ebp - local_9c58]        # 004ed367
    mov dword ptr [edx + field_28e8], ecx        # 004ed36d
    mov eax, dword ptr [ebp - local_9c58]        # 004ed373
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed379
    mov edx, dword ptr [eax + field_b7f]         # 004ed37f
    sub edx, dword ptr [ecx + field_b77]         # 004ed385
    mov eax, dword ptr [ebp - local_9c58]        # 004ed38b
    mov dword ptr [eax + field_28ec], edx        # 004ed391
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed397
    cmp dword ptr [ecx + field_fca], 0x2         # 004ed39d
    jne.d32 L_004ed6cb                           # 004ed3a4
    # block 0x004ed3aa: entered by fall-through of jne at 0x004ed3a4, 3 instruction(s), ends with je to 0x004ed3ca (forward)
    movsx edx, word ptr [0x58c94f]               # 004ed3aa
    test edx, edx                                # 004ed3b1
    je.d8 L_004ed3ca                             # 004ed3b3
    # block 0x004ed3b5: entered by fall-through of je at 0x004ed3b3, 4 instruction(s), ends with jne to 0x004ed6cb (forward)
    mov eax, dword ptr [ebp - local_9c58]        # 004ed3b5
    movsx ecx, word ptr [eax + field_b87]        # 004ed3bb
    test ecx, ecx                                # 004ed3c2
    jne.d32 L_004ed6cb                           # 004ed3c4
L_004ed3ca:
    # block 0x004ed3ca: entered by je at 0x004ed3b3; fall-through of jne at 0x004ed3c4, 12 instruction(s), ends with forward jump to 0x004ed41e
    mov edx, dword ptr [ebp - local_9c58]        # 004ed3ca
    mov word ptr [edx + field_28f8], 0x3         # 004ed3d0
    mov word ptr [ebp - local_9c54], 0x0         # 004ed3d9
    mov ecx, 0x2710                              # 004ed3e2
    {load} xor eax, eax                          # 004ed3e7
    lea edi, [ebp - local_9c44]                  # 004ed3e9
    rep stosd dword ptr es:[edi], eax            # 004ed3ef
    movsx eax, word ptr [ebp - local_9c54]       # 004ed3f1
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 004ed3f8
    sub ecx, 0x1                                 # 004ed400
    mov word ptr [ebp - local_9c48], cx          # 004ed403
    jmp.d8 L_004ed41e                            # 004ed40a
L_004ed40c:
    # block 0x004ed40c: entered by jmp at 0x004ed55c, 3 instruction(s), falls into the block at 0x004ed41e
    mov dx, word ptr [ebp - local_9c48]          # 004ed40c
    sub dx, 0x1                                  # 004ed413
    mov word ptr [ebp - local_9c48], dx          # 004ed417
L_004ed41e:
    # block 0x004ed41e: entered by jmp at 0x004ed40a, 3 instruction(s), ends with jl to 0x004ed561 (forward)
    movsx eax, word ptr [ebp - local_9c48]       # 004ed41e
    test eax, eax                                # 004ed425
    jl.d32 L_004ed561                            # 004ed427
    # block 0x004ed42d: entered by fall-through of jl at 0x004ed427, 11 instruction(s), calls FUN_00423259, ends with je to 0x004ed55c (forward)
    movsx ecx, word ptr [ebp - local_9c54]       # 004ed42d
    imul ecx, ecx, 0x3390                        # 004ed434
    movsx edx, word ptr [ebp - local_9c48]       # 004ed43a
    imul edx, edx, 0x21                          # 004ed441
    lea eax, [ecx + edx + 0x5957cb]              # 004ed444
    push eax                                     # 004ed44b
    mov ecx, 0x619a6b                            # 004ed44c
    call FUN_00423259                            # 004ed451
    mov dword ptr [ebp - local_9c4c], eax        # 004ed456
    cmp dword ptr [ebp - local_9c4c], 0x0        # 004ed45c
    je.d32 L_004ed55c                            # 004ed463
    # block 0x004ed469: entered by fall-through of je at 0x004ed463, 6 instruction(s), ends with je to 0x004ed527 (forward)
    movsx ecx, word ptr [ebp - local_9c54]       # 004ed469
    imul ecx, ecx, 0x320                         # 004ed470
    movsx edx, word ptr [ebp - local_9c48]       # 004ed476
    movsx eax, word ptr [ecx + 2*edx + 0x59f27b] # 004ed47d
    test eax, eax                                # 004ed485
    je.d32 L_004ed527                            # 004ed487
    # block 0x004ed48d: entered by fall-through of je at 0x004ed487, 44 instruction(s), calls FUN_005193ca, falls into the block at 0x004ed527
    lea edi, [ebp - local_9c44]                  # 004ed48d
    or ecx, -0x1                                 # 004ed493
    {load} xor eax, eax                          # 004ed496
    repne scasb al, byte ptr es:[edi]            # 004ed498
    mov cx, word ptr [0x55cd3c]                  # 004ed49a
    mov word ptr [edi - field_minus_1], cx       # 004ed4a1
    movsx edx, word ptr [ebp - local_9c54]       # 004ed4a5
    imul edx, edx, 0x320                         # 004ed4ac
    movsx eax, word ptr [ebp - local_9c48]       # 004ed4b2
    mov cx, word ptr [edx + 2*eax + 0x59f27b]    # 004ed4b9
    mov word ptr [ebp - local_4], cx             # 004ed4c1
    push 0xa                                     # 004ed4c5
    lea edx, [ebp - local_9c50]                  # 004ed4c7
    push edx                                     # 004ed4cd
    movsx eax, word ptr [ebp - local_4]          # 004ed4ce
    push eax                                     # 004ed4d2
    call FUN_005193ca                            # 004ed4d3
    add esp, 0xc                                 # 004ed4d8
    lea edi, [ebp - local_9c50]                  # 004ed4db
    lea edx, [ebp - local_9c44]                  # 004ed4e1
    or ecx, -0x1                                 # 004ed4e7
    {load} xor eax, eax                          # 004ed4ea
    repne scasb al, byte ptr es:[edi]            # 004ed4ec
    not ecx                                      # 004ed4ee
    {load} sub edi, ecx                          # 004ed4f0
    {load} mov esi, edi                          # 004ed4f2
    {load} mov ebx, ecx                          # 004ed4f4
    {load} mov edi, edx                          # 004ed4f6
    or ecx, -0x1                                 # 004ed4f8
    {load} xor eax, eax                          # 004ed4fb
    repne scasb al, byte ptr es:[edi]            # 004ed4fd
    add edi, -0x1                                # 004ed4ff
    {load} mov ecx, ebx                          # 004ed502
    shr ecx, 0x2                                 # 004ed504
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ed507
    {load} mov ecx, ebx                          # 004ed509
    and ecx, 0x3                                 # 004ed50b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ed50e
    lea edi, [ebp - local_9c44]                  # 004ed510
    or ecx, -0x1                                 # 004ed516
    {load} xor eax, eax                          # 004ed519
    repne scasb al, byte ptr es:[edi]            # 004ed51b
    mov ax, word ptr [0x55cd40]                  # 004ed51d
    mov word ptr [edi - field_minus_1], ax       # 004ed523
L_004ed527:
    # block 0x004ed527: entered by je at 0x004ed487, 20 instruction(s), falls into the block at 0x004ed55c
    mov edi, dword ptr [ebp - local_9c4c]        # 004ed527
    lea edx, [ebp - local_9c44]                  # 004ed52d
    or ecx, -0x1                                 # 004ed533
    {load} xor eax, eax                          # 004ed536
    repne scasb al, byte ptr es:[edi]            # 004ed538
    not ecx                                      # 004ed53a
    {load} sub edi, ecx                          # 004ed53c
    {load} mov esi, edi                          # 004ed53e
    {load} mov ebx, ecx                          # 004ed540
    {load} mov edi, edx                          # 004ed542
    or ecx, -0x1                                 # 004ed544
    {load} xor eax, eax                          # 004ed547
    repne scasb al, byte ptr es:[edi]            # 004ed549
    add edi, -0x1                                # 004ed54b
    {load} mov ecx, ebx                          # 004ed54e
    shr ecx, 0x2                                 # 004ed550
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ed553
    {load} mov ecx, ebx                          # 004ed555
    and ecx, 0x3                                 # 004ed557
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ed55a
L_004ed55c:
    # block 0x004ed55c: entered by je at 0x004ed463, 1 instruction(s), ends with backward jump to 0x004ed40c
    jmp.d32 L_004ed40c                           # 004ed55c
L_004ed561:
    # block 0x004ed561: entered by jl at 0x004ed427, 17 instruction(s), calls FUN_00413187, ends with forward jump to 0x004ed5c2
    lea eax, [ebp - local_9c44]                  # 004ed561
    mov dword ptr [ebp - local_9c4c], eax        # 004ed567
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed56d
    add ecx, 0x28da                              # 004ed573
    push ecx                                     # 004ed579
    mov edx, dword ptr [ebp - local_9c58]        # 004ed57a
    add edx, 0xfda                               # 004ed580
    push edx                                     # 004ed586
    mov eax, dword ptr [ebp - local_9c4c]        # 004ed587
    push eax                                     # 004ed58d
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed58e
    add ecx, 0x28f6                              # 004ed594
    push ecx                                     # 004ed59a
    mov ecx, 0x619a41                            # 004ed59b
    call FUN_00413187                            # 004ed5a0
    mov word ptr [ebp - local_9c48], 0x0         # 004ed5a5
    jmp.d8 L_004ed5c2                            # 004ed5ae
L_004ed5b0:
    # block 0x004ed5b0: entered by jmp at 0x004ed6c6, 3 instruction(s), falls into the block at 0x004ed5c2
    mov dx, word ptr [ebp - local_9c48]          # 004ed5b0
    add dx, 0x1                                  # 004ed5b7
    mov word ptr [ebp - local_9c48], dx          # 004ed5bb
L_004ed5c2:
    # block 0x004ed5c2: entered by jmp at 0x004ed5ae, 5 instruction(s), ends with jge to 0x004ed6cb (forward)
    movsx eax, word ptr [ebp - local_9c48]       # 004ed5c2
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed5c9
    movsx edx, word ptr [ecx + field_28da]       # 004ed5cf
    {load} cmp eax, edx                          # 004ed5d6
    jge.d32 L_004ed6cb                           # 004ed5d8
    # block 0x004ed5de: entered by fall-through of jge at 0x004ed5d8, 41 instruction(s), ends with backward jump to 0x004ed5b0
    movsx eax, word ptr [ebp - local_9c48]       # 004ed5de
    shl eax, 0x4                                 # 004ed5e5
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed5e8
    mov edx, dword ptr [ecx + eax + field_fda]   # 004ed5ee
    mov eax, dword ptr [ebp - local_9c58]        # 004ed5f5
    add edx, dword ptr [eax + field_b73]         # 004ed5fb
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed601
    shl ecx, 0x4                                 # 004ed608
    mov eax, dword ptr [ebp - local_9c58]        # 004ed60b
    mov dword ptr [eax + ecx + field_fda], edx   # 004ed611
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed618
    shl ecx, 0x4                                 # 004ed61f
    mov edx, dword ptr [ebp - local_9c58]        # 004ed622
    mov eax, dword ptr [edx + ecx + field_fe2]   # 004ed628
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed62f
    add eax, dword ptr [ecx + field_b73]         # 004ed635
    movsx edx, word ptr [ebp - local_9c48]       # 004ed63b
    shl edx, 0x4                                 # 004ed642
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed645
    mov dword ptr [ecx + edx + field_fe2], eax   # 004ed64b
    movsx edx, word ptr [ebp - local_9c48]       # 004ed652
    shl edx, 0x4                                 # 004ed659
    mov eax, dword ptr [ebp - local_9c58]        # 004ed65c
    mov ecx, dword ptr [eax + edx + field_fde]   # 004ed662
    mov edx, dword ptr [ebp - local_9c58]        # 004ed669
    add ecx, dword ptr [edx + field_b77]         # 004ed66f
    movsx eax, word ptr [ebp - local_9c48]       # 004ed675
    shl eax, 0x4                                 # 004ed67c
    mov edx, dword ptr [ebp - local_9c58]        # 004ed67f
    mov dword ptr [edx + eax + field_fde], ecx   # 004ed685
    movsx eax, word ptr [ebp - local_9c48]       # 004ed68c
    shl eax, 0x4                                 # 004ed693
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed696
    mov edx, dword ptr [ecx + eax + field_fe6]   # 004ed69c
    mov eax, dword ptr [ebp - local_9c58]        # 004ed6a3
    add edx, dword ptr [eax + field_b77]         # 004ed6a9
    movsx ecx, word ptr [ebp - local_9c48]       # 004ed6af
    shl ecx, 0x4                                 # 004ed6b6
    mov eax, dword ptr [ebp - local_9c58]        # 004ed6b9
    mov dword ptr [eax + ecx + field_fe6], edx   # 004ed6bf
    jmp.d32 L_004ed5b0                           # 004ed6c6
L_004ed6cb:
    # block 0x004ed6cb: entered by je at 0x004ed226; jne at 0x004ed3a4; jne at 0x004ed3c4; jge at 0x004ed5d8, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004ed6e9 (forward)
    push 0x1                                     # 004ed6cb
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed6cd
    call FUN_004ee6c7                            # 004ed6d3
    test eax, eax                                # 004ed6d8
    jne.d8 L_004ed6e9                            # 004ed6da
    # block 0x004ed6dc: entered by fall-through of jne at 0x004ed6da, 3 instruction(s), calls FUN_004eb96e, ends with forward jump to 0x004ed6ff
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed6dc
    call FUN_004eb96e                            # 004ed6e2
    jmp.d8 L_004ed6ff                            # 004ed6e7
L_004ed6e9:
    # block 0x004ed6e9: entered by jne at 0x004ed6da, 4 instruction(s), calls FUN_004ec4b9, FUN_004ec44b, falls into the block at 0x004ed6ff
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed6e9
    call FUN_004ec4b9                            # 004ed6ef
    mov ecx, dword ptr [ebp - local_9c58]        # 004ed6f4
    call FUN_004ec44b                            # 004ed6fa
L_004ed6ff:
    # block 0x004ed6ff: entered by ja at 0x004ec9d1; jmp at 0x004ecae5; jmp at 0x004ecb58; jmp at 0x004ecb6d; more, 6 instruction(s), ends with ret
    pop edi                                      # 004ed6ff
    pop esi                                      # 004ed700
    pop ebx                                      # 004ed701
    {load} mov esp, ebp                          # 004ed702
    pop ebp                                      # 004ed704
    ret                                          # 004ed705

# --- data items (not part of the function) -------------------------
.org 0x004ed706 - 0x401000
SWTAB_004ed706:  # 6 case address(es)
    .long L_004ec9e4 - .text + 0x401000
    .long L_004ed6ff - .text + 0x401000
    .long L_004ed157 - .text + 0x401000
    .long L_004ed157 - .text + 0x401000
    .long L_004ecaea - .text + 0x401000
    .long L_004ecb72 - .text + 0x401000
.set SWTAB_004ed706_VA, SWTAB_004ed706 - .text + 0x401000

