# FUN_0041c7f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c7f4
# extent:       0x0041c7f4-0x0041db08 (4884 code bytes)
# span:         0x0041c7f4-0x0041db40 (code 4884, tables 56, padding 0)
# sha256:       82494f827f032ea3fea9a8906abba1faf7909b33ddf1b3cc94eee759933fda54
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_3f_conversation_constructor
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:70 says "A-3F.1 constructor 0x41c7f4 model"
# name-note:    Constructor of the raw 0x3f/0x3e conversation row object (A-3F.1).
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       31 ebp-relative slot(s): local_4, local_6, local_27, local_29, local_4a, local_6b, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 19 more
# fields:       [eax + n] field_2, field_4, field_6, field_2f, field_169, field_1b8, field_793, field_795, field_799, field_79b, field_79f, field_7a1; [ecx + n] field_2, field_4, field_6, field_21, field_2d, field_aa, field_167, field_196, field_776, field_793, field_795, field_799 and 3 more; [edx + n] field_2, field_4, field_6, field_196, field_774, field_793, field_795, field_799, field_79b, field_79f, field_7a1
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_00423259, FUN_0052139c, FUN_0041c3ba, FUN_0041c544, FUN_0041c509, FUN_0041c770, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/action_sound.c:present_caption (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 1117 instruction(s), 34 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_6, 0x6  # offset -0x6
.equ local_27, 0x27  # offset -0x27
.equ local_29, 0x29  # offset -0x29
.equ local_4a, 0x4a  # offset -0x4a
.equ local_6b, 0x6b  # offset -0x6b
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_cb, 0xcb  # offset -0xcb
.equ local_ec, 0xec  # offset -0xec
.equ local_ee, 0xee  # offset -0xee
.equ local_10f, 0x10f  # offset -0x10f
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_160, 0x160  # offset -0x160
.equ local_164, 0x164  # offset -0x164
.equ local_168, 0x168  # offset -0x168
.equ local_16c, 0x16c  # offset -0x16c
.equ local_170, 0x170  # offset -0x170
.equ local_174, 0x174  # offset -0x174
.equ local_178, 0x178  # offset -0x178
.equ local_17c, 0x17c  # offset -0x17c
.equ local_180, 0x180  # offset -0x180
.equ local_184, 0x184  # offset -0x184
.equ local_188, 0x188  # offset -0x188
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_21, 0x21  # offset +0x21
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_aa, 0xaa  # offset +0xaa
.equ field_167, 0x167  # offset +0x167
.equ field_169, 0x169  # offset +0x169
.equ field_196, 0x196  # offset +0x196
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_774, 0x774  # offset +0x774
.equ field_776, 0x776  # offset +0x776
.equ field_793, 0x793  # offset +0x793
.equ field_795, 0x795  # offset +0x795
.equ field_799, 0x799  # offset +0x799
.equ field_79b, 0x79b  # offset +0x79b
.equ field_79f, 0x79f  # offset +0x79f
.equ field_7a1, 0x7a1  # offset +0x7a1

# --- external targets -----------------------------------------------
.set FUN_0041c3ba, .text + (0x0041c3ba - 0x401000)
.set FUN_0041c509, .text + (0x0041c509 - 0x401000)
.set FUN_0041c544, .text + (0x0041c544 - 0x401000)
.set FUN_0041c770, .text + (0x0041c770 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041c7f4 - 0x401000
.globl FUN_0041c7f4
FUN_0041c7f4:
    # block 0x0041c7f4: entry, 19 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041c87d (forward)
    push ebp                                     # 0041c7f4
    {load} mov ebp, esp                          # 0041c7f5
    sub esp, 0x188                               # 0041c7f7
    push esi                                     # 0041c7fd
    push edi                                     # 0041c7fe
    mov dword ptr [ebp - local_180], ecx         # 0041c7ff
    mov dword ptr [ebp - local_a0], 0x0          # 0041c805
    mov eax, dword ptr [ebp + arg_c]             # 0041c80f
    mov ecx, dword ptr [eax]                     # 0041c812
    mov dword ptr [ebp - local_4], ecx           # 0041c814
    push 0x7a5                                   # 0041c817
    call FUN_0051dc43                            # 0041c81c
    add esp, 0x4                                 # 0041c821
    mov dword ptr [ebp - local_164], eax         # 0041c824
    mov edx, dword ptr [ebp + arg_8]             # 0041c82a
    mov eax, dword ptr [ebp - local_164]         # 0041c82d
    mov dword ptr [edx], eax                     # 0041c833
    cmp dword ptr [ebp - local_164], 0x0         # 0041c835
    jne.d8 L_0041c87d                            # 0041c83c
    # block 0x0041c83e: entered by fall-through of jne at 0x0041c83c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041c87d
    movsx ecx, word ptr [0x5c39e3]               # 0041c83e
    push ecx                                     # 0041c845
    mov edx, dword ptr [0x5bb57b]                # 0041c846
    push edx                                     # 0041c84c
    push 0x543284                                # 0041c84d
    push 0x63888b                                # 0041c852
    call FUN_0050ca3e                            # 0041c857
    add esp, 0x10                                # 0041c85c
    push 0x63888b                                # 0041c85f
    push 0x5432b0                                # 0041c864
    mov ecx, 0x583979                            # 0041c869
    call FUN_0042639d                            # 0041c86e
    mov ecx, 0x5cf659                            # 0041c873
    call FUN_004c97b4                            # 0041c878
L_0041c87d:
    # block 0x0041c87d: entered by jne at 0x0041c83c, 10 instruction(s), ends with ja to 0x0041ce29 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0041c87d
    mov ecx, dword ptr [eax]                     # 0041c880
    mov dword ptr [ebp - local_9c], ecx          # 0041c882
    movsx edx, word ptr [ebp + arg_14]           # 0041c888
    mov dword ptr [ebp - local_184], edx         # 0041c88c
    mov eax, dword ptr [ebp - local_184]         # 0041c892
    sub eax, 0x39                                # 0041c898
    mov dword ptr [ebp - local_184], eax         # 0041c89b
    cmp dword ptr [ebp - local_184], 0x6         # 0041c8a1
    ja.d32 L_0041ce29                            # 0041c8a8
    # block 0x0041c8ae: entered by fall-through of ja at 0x0041c8a8, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x41db08]
    mov ecx, dword ptr [ebp - local_184]         # 0041c8ae
    jmp dword ptr [4*ecx + SWTAB_0041db08_VA]    # 0041c8b4
L_0041c8bb:
    # block 0x0041c8bb: entered by switch case, 21 instruction(s), ends with forward jump to 0x0041ce29
    mov esi, dword ptr [ebp - local_4]           # 0041c8bb
    add esi, dword ptr [ebp - local_a0]          # 0041c8be
    mov ecx, 0x5a                                # 0041c8c4
    mov edi, dword ptr [ebp - local_9c]          # 0041c8c9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c8cf
    movsw word ptr es:[edi], word ptr [esi]      # 0041c8d1
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041c8d3
    mov edx, dword ptr [ebp - local_a0]          # 0041c8d4
    add edx, 0x16b                               # 0041c8da
    mov dword ptr [ebp - local_a0], edx          # 0041c8e0
    mov esi, dword ptr [ebp - local_4]           # 0041c8e6
    add esi, dword ptr [ebp - local_a0]          # 0041c8e9
    mov edi, dword ptr [ebp - local_9c]          # 0041c8ef
    add edi, 0x16b                               # 0041c8f5
    mov ecx, 0x177                               # 0041c8fb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c900
    mov dword ptr [ebp - local_a4], 0x5dc        # 0041c902
    mov eax, dword ptr [ebp - local_a0]          # 0041c90c
    add eax, dword ptr [ebp - local_a4]          # 0041c912
    mov dword ptr [ebp - local_a0], eax          # 0041c918
    jmp.d32 L_0041ce29                           # 0041c91e
L_0041c923:
    # block 0x0041c923: entered by switch case, 20 instruction(s), ends with forward jump to 0x0041ce29
    mov esi, dword ptr [ebp - local_4]           # 0041c923
    add esi, dword ptr [ebp - local_a0]          # 0041c926
    mov ecx, 0xc                                 # 0041c92c
    mov edi, dword ptr [ebp - local_9c]          # 0041c931
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c937
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041c939
    mov ecx, dword ptr [ebp - local_a0]          # 0041c93a
    add ecx, 0x31                                # 0041c940
    mov dword ptr [ebp - local_a0], ecx          # 0041c943
    mov esi, dword ptr [ebp - local_4]           # 0041c949
    add esi, dword ptr [ebp - local_a0]          # 0041c94c
    mov edi, dword ptr [ebp - local_9c]          # 0041c952
    add edi, 0x16b                               # 0041c958
    mov ecx, 0x177                               # 0041c95e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c963
    mov dword ptr [ebp - local_a4], 0x5dc        # 0041c965
    mov edx, dword ptr [ebp - local_a0]          # 0041c96f
    add edx, dword ptr [ebp - local_a4]          # 0041c975
    mov dword ptr [ebp - local_a0], edx          # 0041c97b
    jmp.d32 L_0041ce29                           # 0041c981
L_0041c986:
    # block 0x0041c986: entered by switch case, 24 instruction(s), calls FUN_00423259, ends with jne to 0x0041ca60 (forward)
    mov esi, dword ptr [ebp - local_4]           # 0041c986
    add esi, dword ptr [ebp - local_a0]          # 0041c989
    mov ecx, 0x5a                                # 0041c98f
    mov edi, dword ptr [ebp - local_9c]          # 0041c994
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c99a
    movsw word ptr es:[edi], word ptr [esi]      # 0041c99c
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041c99e
    mov eax, dword ptr [ebp - local_a0]          # 0041c99f
    add eax, 0x16b                               # 0041c9a5
    mov dword ptr [ebp - local_a0], eax          # 0041c9aa
    mov esi, dword ptr [ebp - local_4]           # 0041c9b0
    add esi, dword ptr [ebp - local_a0]          # 0041c9b3
    mov ecx, 0x8                                 # 0041c9b9
    lea edi, [ebp - local_c8]                    # 0041c9be
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c9c4
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041c9c6
    lea ecx, [ebp - local_c8]                    # 0041c9c7
    push ecx                                     # 0041c9cd
    mov ecx, dword ptr [ebp - local_180]         # 0041c9ce
    add ecx, 0xfd1                               # 0041c9d4
    call FUN_00423259                            # 0041c9da
    mov dword ptr [ebp - local_134], eax         # 0041c9df
    cmp dword ptr [ebp - local_134], 0x0         # 0041c9e5
    jne.d8 L_0041ca60                            # 0041c9ec
    # block 0x0041c9ee: entered by fall-through of jne at 0x0041c9ec, 3 instruction(s), ends with je to 0x0041ca43 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0041c9ee
    test edx, edx                                # 0041c9f5
    je.d8 L_0041ca43                             # 0041c9f7
    # block 0x0041c9f9: entered by fall-through of je at 0x0041c9f7, 20 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x0041ca5e
    mov eax, dword ptr [0x5bb57b]                # 0041c9f9
    push eax                                     # 0041c9fe
    lea ecx, [ebp - local_c8]                    # 0041c9ff
    push ecx                                     # 0041ca05
    push 0x5432cc                                # 0041ca06
    push 0x63888b                                # 0041ca0b
    call FUN_0050ca3e                            # 0041ca10
    add esp, 0x10                                # 0041ca15
    push 0x0                                     # 0041ca18
    push 0x0                                     # 0041ca1a
    push 0x63888b                                # 0041ca1c
    call FUN_0052139c                            # 0041ca21
    mov edi, dword ptr [ebp - local_9c]          # 0041ca26
    add edi, 0x16b                               # 0041ca2c
    mov ecx, 0xb                                 # 0041ca32
    mov esi, 0x543310                            # 0041ca37
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ca3c
    movsw word ptr es:[edi], word ptr [esi]      # 0041ca3e
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041ca40
    jmp.d8 L_0041ca5e                            # 0041ca41
L_0041ca43:
    # block 0x0041ca43: entered by je at 0x0041c9f7, 7 instruction(s), falls into the block at 0x0041ca5e
    mov edi, dword ptr [ebp - local_9c]          # 0041ca43
    add edi, 0x16b                               # 0041ca49
    mov ecx, 0xb                                 # 0041ca4f
    mov esi, 0x543340                            # 0041ca54
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ca59
    movsw word ptr es:[edi], word ptr [esi]      # 0041ca5b
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041ca5d
L_0041ca5e:
    # block 0x0041ca5e: entered by jmp at 0x0041ca41, 1 instruction(s), ends with forward jump to 0x0041ca8f
    jmp.d8 L_0041ca8f                            # 0041ca5e
L_0041ca60:
    # block 0x0041ca60: entered by jne at 0x0041c9ec, 14 instruction(s), falls into the block at 0x0041ca8f
    mov edi, dword ptr [ebp - local_134]         # 0041ca60
    or ecx, -0x1                                 # 0041ca66
    {load} xor eax, eax                          # 0041ca69
    repne scasb al, byte ptr es:[edi]            # 0041ca6b
    not ecx                                      # 0041ca6d
    mov esi, dword ptr [ebp - local_134]         # 0041ca6f
    mov edi, dword ptr [ebp - local_9c]          # 0041ca75
    add edi, 0x16b                               # 0041ca7b
    {load} mov edx, ecx                          # 0041ca81
    shr ecx, 0x2                                 # 0041ca83
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ca86
    {load} mov ecx, edx                          # 0041ca88
    and ecx, 0x3                                 # 0041ca8a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041ca8d
L_0041ca8f:
    # block 0x0041ca8f: entered by jmp at 0x0041ca5e, 4 instruction(s), ends with forward jump to 0x0041ce29
    mov eax, dword ptr [ebp - local_a0]          # 0041ca8f
    add eax, 0x21                                # 0041ca95
    mov dword ptr [ebp - local_a0], eax          # 0041ca98
    jmp.d32 L_0041ce29                           # 0041ca9e
L_0041caa3:
    # block 0x0041caa3: entered by switch case, 109 instruction(s), calls FUN_0041c3ba, FUN_0041c544, ends with forward jump to 0x0041ce29
    mov ecx, dword ptr [ebp - local_9c]          # 0041caa3
    push ecx                                     # 0041caa9
    mov ecx, dword ptr [ebp - local_180]         # 0041caaa
    call FUN_0041c3ba                            # 0041cab0
    mov esi, dword ptr [ebp - local_4]           # 0041cab5
    add esi, dword ptr [ebp - local_a0]          # 0041cab8
    mov ecx, 0x22                                # 0041cabe
    lea edi, [ebp - local_8c]                    # 0041cac3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cac9
    mov edx, dword ptr [ebp - local_a0]          # 0041cacb
    add edx, 0x88                                # 0041cad1
    mov dword ptr [ebp - local_a0], edx          # 0041cad7
    lea edi, [ebp - local_8c]                    # 0041cadd
    mov edx, dword ptr [ebp - local_9c]          # 0041cae3
    or ecx, -0x1                                 # 0041cae9
    {load} xor eax, eax                          # 0041caec
    repne scasb al, byte ptr es:[edi]            # 0041caee
    not ecx                                      # 0041caf0
    {load} sub edi, ecx                          # 0041caf2
    {load} mov esi, edi                          # 0041caf4
    {load} mov eax, ecx                          # 0041caf6
    {load} mov edi, edx                          # 0041caf8
    shr ecx, 0x2                                 # 0041cafa
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cafd
    {load} mov ecx, eax                          # 0041caff
    and ecx, 0x3                                 # 0041cb01
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cb04
    lea edi, [ebp - local_6b]                    # 0041cb06
    mov ecx, dword ptr [ebp - local_9c]          # 0041cb09
    add ecx, 0x21                                # 0041cb0f
    {load} mov edx, ecx                          # 0041cb12
    or ecx, -0x1                                 # 0041cb14
    {load} xor eax, eax                          # 0041cb17
    repne scasb al, byte ptr es:[edi]            # 0041cb19
    not ecx                                      # 0041cb1b
    {load} sub edi, ecx                          # 0041cb1d
    {load} mov esi, edi                          # 0041cb1f
    {load} mov eax, ecx                          # 0041cb21
    {load} mov edi, edx                          # 0041cb23
    shr ecx, 0x2                                 # 0041cb25
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cb28
    {load} mov ecx, eax                          # 0041cb2a
    and ecx, 0x3                                 # 0041cb2c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cb2f
    lea edi, [ebp - local_4a]                    # 0041cb31
    mov ecx, dword ptr [ebp - local_9c]          # 0041cb34
    add ecx, 0x42                                # 0041cb3a
    {load} mov edx, ecx                          # 0041cb3d
    or ecx, -0x1                                 # 0041cb3f
    {load} xor eax, eax                          # 0041cb42
    repne scasb al, byte ptr es:[edi]            # 0041cb44
    not ecx                                      # 0041cb46
    {load} sub edi, ecx                          # 0041cb48
    {load} mov esi, edi                          # 0041cb4a
    {load} mov eax, ecx                          # 0041cb4c
    {load} mov edi, edx                          # 0041cb4e
    shr ecx, 0x2                                 # 0041cb50
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cb53
    {load} mov ecx, eax                          # 0041cb55
    and ecx, 0x3                                 # 0041cb57
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cb5a
    mov ecx, dword ptr [ebp - local_9c]          # 0041cb5c
    mov dx, word ptr [ebp - local_29]            # 0041cb62
    mov word ptr [ecx + field_aa], dx            # 0041cb66
    lea edi, [ebp - local_27]                    # 0041cb6d
    mov eax, dword ptr [ebp - local_9c]          # 0041cb70
    add eax, 0x13a                               # 0041cb76
    {load} mov edx, eax                          # 0041cb7b
    or ecx, -0x1                                 # 0041cb7d
    {load} xor eax, eax                          # 0041cb80
    repne scasb al, byte ptr es:[edi]            # 0041cb82
    not ecx                                      # 0041cb84
    {load} sub edi, ecx                          # 0041cb86
    {load} mov esi, edi                          # 0041cb88
    {load} mov eax, ecx                          # 0041cb8a
    {load} mov edi, edx                          # 0041cb8c
    shr ecx, 0x2                                 # 0041cb8e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cb91
    {load} mov ecx, eax                          # 0041cb93
    and ecx, 0x3                                 # 0041cb95
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cb98
    mov ecx, dword ptr [ebp - local_9c]          # 0041cb9a
    mov dx, word ptr [ebp - local_6]             # 0041cba0
    mov word ptr [ecx + field_167], dx           # 0041cba4
    mov eax, dword ptr [ebp - local_9c]          # 0041cbab
    mov cx, word ptr [ebp - local_6]             # 0041cbb1
    mov word ptr [eax + field_169], cx           # 0041cbb5
    mov edx, dword ptr [ebp - local_9c]          # 0041cbbc
    mov ax, word ptr [ebp - local_6]             # 0041cbc2
    mov word ptr [edx + field_774], ax           # 0041cbc6
    mov ecx, dword ptr [ebp - local_9c]          # 0041cbcd
    mov dx, word ptr [ebp - local_6]             # 0041cbd3
    mov word ptr [ecx + field_776], dx           # 0041cbd7
    mov esi, dword ptr [ebp - local_4]           # 0041cbde
    add esi, dword ptr [ebp - local_a0]          # 0041cbe1
    mov ecx, 0xa                                 # 0041cbe7
    lea edi, [ebp - local_160]                   # 0041cbec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cbf2
    movsw word ptr es:[edi], word ptr [esi]      # 0041cbf4
    mov eax, dword ptr [ebp - local_a0]          # 0041cbf6
    add eax, 0x2a                                # 0041cbfc
    mov dword ptr [ebp - local_a0], eax          # 0041cbff
    lea ecx, [ebp - local_160]                   # 0041cc05
    push ecx                                     # 0041cc0b
    mov edx, dword ptr [ebp - local_9c]          # 0041cc0c
    push edx                                     # 0041cc12
    mov ecx, dword ptr [ebp - local_180]         # 0041cc13
    call FUN_0041c544                            # 0041cc19
    jmp.d32 L_0041ce29                           # 0041cc1e
L_0041cc23:
    # block 0x0041cc23: entered by switch case, 23 instruction(s), calls FUN_00423259, ends with jne to 0x0041ccf9 (forward)
    mov esi, dword ptr [ebp - local_4]           # 0041cc23
    add esi, dword ptr [ebp - local_a0]          # 0041cc26
    mov ecx, 0xc                                 # 0041cc2c
    mov edi, dword ptr [ebp - local_9c]          # 0041cc31
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cc37
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041cc39
    mov eax, dword ptr [ebp - local_a0]          # 0041cc3a
    add eax, 0x31                                # 0041cc40
    mov dword ptr [ebp - local_a0], eax          # 0041cc43
    mov esi, dword ptr [ebp - local_4]           # 0041cc49
    add esi, dword ptr [ebp - local_a0]          # 0041cc4c
    mov ecx, 0x8                                 # 0041cc52
    lea edi, [ebp - local_c8]                    # 0041cc57
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cc5d
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041cc5f
    lea ecx, [ebp - local_c8]                    # 0041cc60
    push ecx                                     # 0041cc66
    mov ecx, dword ptr [ebp - local_180]         # 0041cc67
    add ecx, 0xfd1                               # 0041cc6d
    call FUN_00423259                            # 0041cc73
    mov dword ptr [ebp - local_134], eax         # 0041cc78
    cmp dword ptr [ebp - local_134], 0x0         # 0041cc7e
    jne.d8 L_0041ccf9                            # 0041cc85
    # block 0x0041cc87: entered by fall-through of jne at 0x0041cc85, 3 instruction(s), ends with je to 0x0041ccdc (forward)
    movsx edx, word ptr [0x63a4cd]               # 0041cc87
    test edx, edx                                # 0041cc8e
    je.d8 L_0041ccdc                             # 0041cc90
    # block 0x0041cc92: entered by fall-through of je at 0x0041cc90, 20 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x0041ccf7
    mov eax, dword ptr [0x5bb57b]                # 0041cc92
    push eax                                     # 0041cc97
    lea ecx, [ebp - local_c8]                    # 0041cc98
    push ecx                                     # 0041cc9e
    push 0x543370                                # 0041cc9f
    push 0x63888b                                # 0041cca4
    call FUN_0050ca3e                            # 0041cca9
    add esp, 0x10                                # 0041ccae
    push 0x0                                     # 0041ccb1
    push 0x0                                     # 0041ccb3
    push 0x63888b                                # 0041ccb5
    call FUN_0052139c                            # 0041ccba
    mov edi, dword ptr [ebp - local_9c]          # 0041ccbf
    add edi, 0x16b                               # 0041ccc5
    mov ecx, 0xb                                 # 0041cccb
    mov esi, 0x5433b4                            # 0041ccd0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ccd5
    movsw word ptr es:[edi], word ptr [esi]      # 0041ccd7
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041ccd9
    jmp.d8 L_0041ccf7                            # 0041ccda
L_0041ccdc:
    # block 0x0041ccdc: entered by je at 0x0041cc90, 7 instruction(s), falls into the block at 0x0041ccf7
    mov edi, dword ptr [ebp - local_9c]          # 0041ccdc
    add edi, 0x16b                               # 0041cce2
    mov ecx, 0xb                                 # 0041cce8
    mov esi, 0x5433e4                            # 0041cced
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ccf2
    movsw word ptr es:[edi], word ptr [esi]      # 0041ccf4
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041ccf6
L_0041ccf7:
    # block 0x0041ccf7: entered by jmp at 0x0041ccda, 1 instruction(s), ends with forward jump to 0x0041cd28
    jmp.d8 L_0041cd28                            # 0041ccf7
L_0041ccf9:
    # block 0x0041ccf9: entered by jne at 0x0041cc85, 14 instruction(s), falls into the block at 0x0041cd28
    mov edi, dword ptr [ebp - local_134]         # 0041ccf9
    or ecx, -0x1                                 # 0041ccff
    {load} xor eax, eax                          # 0041cd02
    repne scasb al, byte ptr es:[edi]            # 0041cd04
    not ecx                                      # 0041cd06
    mov esi, dword ptr [ebp - local_134]         # 0041cd08
    mov edi, dword ptr [ebp - local_9c]          # 0041cd0e
    add edi, 0x16b                               # 0041cd14
    {load} mov edx, ecx                          # 0041cd1a
    shr ecx, 0x2                                 # 0041cd1c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cd1f
    {load} mov ecx, edx                          # 0041cd21
    and ecx, 0x3                                 # 0041cd23
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cd26
L_0041cd28:
    # block 0x0041cd28: entered by jmp at 0x0041ccf7, 4 instruction(s), ends with forward jump to 0x0041ce29
    mov eax, dword ptr [ebp - local_a0]          # 0041cd28
    add eax, 0x21                                # 0041cd2e
    mov dword ptr [ebp - local_a0], eax          # 0041cd31
    jmp.d32 L_0041ce29                           # 0041cd37
L_0041cd3c:
    # block 0x0041cd3c: entered by switch case, 56 instruction(s), calls FUN_0041c509, FUN_0041c544, falls into the block at 0x0041ce29
    mov ecx, dword ptr [ebp - local_9c]          # 0041cd3c
    push ecx                                     # 0041cd42
    mov ecx, dword ptr [ebp - local_180]         # 0041cd43
    call FUN_0041c509                            # 0041cd49
    mov esi, dword ptr [ebp - local_4]           # 0041cd4e
    add esi, dword ptr [ebp - local_a0]          # 0041cd51
    mov ecx, 0x8                                 # 0041cd57
    lea edi, [ebp - local_ec]                    # 0041cd5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cd62
    movsw word ptr es:[edi], word ptr [esi]      # 0041cd64
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041cd66
    mov edx, dword ptr [ebp - local_a0]          # 0041cd67
    add edx, 0x23                                # 0041cd6d
    mov dword ptr [ebp - local_a0], edx          # 0041cd70
    lea edi, [ebp - local_ec]                    # 0041cd76
    mov edx, dword ptr [ebp - local_9c]          # 0041cd7c
    or ecx, -0x1                                 # 0041cd82
    {load} xor eax, eax                          # 0041cd85
    repne scasb al, byte ptr es:[edi]            # 0041cd87
    not ecx                                      # 0041cd89
    {load} sub edi, ecx                          # 0041cd8b
    {load} mov esi, edi                          # 0041cd8d
    {load} mov eax, ecx                          # 0041cd8f
    {load} mov edi, edx                          # 0041cd91
    shr ecx, 0x2                                 # 0041cd93
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cd96
    {load} mov ecx, eax                          # 0041cd98
    and ecx, 0x3                                 # 0041cd9a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041cd9d
    mov ecx, dword ptr [ebp - local_9c]          # 0041cd9f
    mov dx, word ptr [ebp - local_cb]            # 0041cda5
    mov word ptr [ecx + field_2d], dx            # 0041cdac
    mov eax, dword ptr [ebp - local_9c]          # 0041cdb0
    mov cx, word ptr [ebp - local_cb]            # 0041cdb6
    mov word ptr [eax + field_2f], cx            # 0041cdbd
    mov edx, dword ptr [ebp - local_9c]          # 0041cdc1
    mov ax, word ptr [ebp - local_cb]            # 0041cdc7
    mov word ptr [edx + field_774], ax           # 0041cdce
    mov ecx, dword ptr [ebp - local_9c]          # 0041cdd5
    mov dx, word ptr [ebp - local_cb]            # 0041cddb
    mov word ptr [ecx + field_776], dx           # 0041cde2
    mov esi, dword ptr [ebp - local_4]           # 0041cde9
    add esi, dword ptr [ebp - local_a0]          # 0041cdec
    mov ecx, 0xa                                 # 0041cdf2
    lea edi, [ebp - local_160]                   # 0041cdf7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041cdfd
    movsw word ptr es:[edi], word ptr [esi]      # 0041cdff
    mov eax, dword ptr [ebp - local_a0]          # 0041ce01
    add eax, 0x2a                                # 0041ce07
    mov dword ptr [ebp - local_a0], eax          # 0041ce0a
    lea ecx, [ebp - local_160]                   # 0041ce10
    push ecx                                     # 0041ce16
    mov edx, dword ptr [ebp - local_9c]          # 0041ce17
    push edx                                     # 0041ce1d
    mov ecx, dword ptr [ebp - local_180]         # 0041ce1e
    call FUN_0041c544                            # 0041ce24
L_0041ce29:
    # block 0x0041ce29: entered by ja at 0x0041c8a8; jmp at 0x0041c91e; jmp at 0x0041c981; jmp at 0x0041ca9e; more, 3 instruction(s), ends with je to 0x0041cea9 (forward)
    movsx eax, word ptr [ebp + arg_14]           # 0041ce29
    cmp eax, 0x3e                                # 0041ce2d
    je.d8 L_0041cea9                             # 0041ce30
    # block 0x0041ce32: entered by fall-through of je at 0x0041ce30, 3 instruction(s), ends with je to 0x0041cea9 (forward)
    movsx ecx, word ptr [ebp + arg_14]           # 0041ce32
    cmp ecx, 0x3f                                # 0041ce36
    je.d8 L_0041cea9                             # 0041ce39
    # block 0x0041ce3b: entered by fall-through of je at 0x0041ce39, 23 instruction(s), falls into the block at 0x0041cea9
    mov dword ptr [ebp - local_90], 0x4c         # 0041ce3b
    mov ecx, dword ptr [ebp - local_90]          # 0041ce45
    mov esi, dword ptr [ebp - local_4]           # 0041ce4b
    add esi, dword ptr [ebp - local_a0]          # 0041ce4e
    mov edi, dword ptr [ebp - local_9c]          # 0041ce54
    add edi, 0x747                               # 0041ce5a
    {load} mov edx, ecx                          # 0041ce60
    shr ecx, 0x2                                 # 0041ce62
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041ce65
    {load} mov ecx, edx                          # 0041ce67
    and ecx, 0x3                                 # 0041ce69
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041ce6c
    mov eax, dword ptr [ebp - local_a0]          # 0041ce6e
    add eax, dword ptr [ebp - local_90]          # 0041ce74
    mov dword ptr [ebp - local_a0], eax          # 0041ce7a
    mov ecx, dword ptr [ebp - local_4]           # 0041ce80
    add ecx, dword ptr [ebp - local_a0]          # 0041ce83
    movsx dx, byte ptr [ecx]                     # 0041ce89
    mov eax, dword ptr [ebp - local_9c]          # 0041ce8d
    mov word ptr [eax + field_793], dx           # 0041ce93
    mov ecx, dword ptr [ebp - local_a0]          # 0041ce9a
    add ecx, 0x2                                 # 0041cea0
    mov dword ptr [ebp - local_a0], ecx          # 0041cea3
L_0041cea9:
    # block 0x0041cea9: entered by je at 0x0041ce30; je at 0x0041ce39, 4 instruction(s), ends with jle to 0x0041d47c (forward)
    mov edx, dword ptr [ebp - local_9c]          # 0041cea9
    movsx eax, word ptr [edx + field_793]        # 0041ceaf
    test eax, eax                                # 0041ceb6
    jle.d32 L_0041d47c                           # 0041ceb8
    # block 0x0041cebe: entered by fall-through of jle at 0x0041ceb8, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041cf39 (forward)
    mov ecx, dword ptr [ebp - local_9c]          # 0041cebe
    movsx edx, word ptr [ecx + field_793]        # 0041cec4
    imul edx, edx, 0x1d1                         # 0041cecb
    push edx                                     # 0041ced1
    call FUN_0051dc43                            # 0041ced2
    add esp, 0x4                                 # 0041ced7
    mov dword ptr [ebp - local_168], eax         # 0041ceda
    mov eax, dword ptr [ebp - local_9c]          # 0041cee0
    mov ecx, dword ptr [ebp - local_168]         # 0041cee6
    mov dword ptr [eax + field_795], ecx         # 0041ceec
    cmp dword ptr [ebp - local_168], 0x0         # 0041cef2
    jne.d8 L_0041cf39                            # 0041cef9
    # block 0x0041cefb: entered by fall-through of jne at 0x0041cef9, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041cf39
    movsx edx, word ptr [0x5c39e3]               # 0041cefb
    push edx                                     # 0041cf02
    mov eax, dword ptr [0x5bb57b]                # 0041cf03
    push eax                                     # 0041cf08
    push 0x543414                                # 0041cf09
    push 0x63888b                                # 0041cf0e
    call FUN_0050ca3e                            # 0041cf13
    add esp, 0x10                                # 0041cf18
    push 0x63888b                                # 0041cf1b
    push 0x543450                                # 0041cf20
    mov ecx, 0x583979                            # 0041cf25
    call FUN_0042639d                            # 0041cf2a
    mov ecx, 0x5cf659                            # 0041cf2f
    call FUN_004c97b4                            # 0041cf34
L_0041cf39:
    # block 0x0041cf39: entered by jne at 0x0041cef9, 2 instruction(s), ends with forward jump to 0x0041cf56
    mov word ptr [ebp - local_94], 0x0           # 0041cf39
    jmp.d8 L_0041cf56                            # 0041cf42
L_0041cf44:
    # block 0x0041cf44: entered by jmp at 0x0041d475, 3 instruction(s), falls into the block at 0x0041cf56
    mov cx, word ptr [ebp - local_94]            # 0041cf44
    add cx, 0x1                                  # 0041cf4b
    mov word ptr [ebp - local_94], cx            # 0041cf4f
L_0041cf56:
    # block 0x0041cf56: entered by jmp at 0x0041cf42, 5 instruction(s), ends with jge to 0x0041d47a (forward)
    movsx edx, word ptr [ebp - local_94]         # 0041cf56
    mov eax, dword ptr [ebp - local_9c]          # 0041cf5d
    movsx ecx, word ptr [eax + field_793]        # 0041cf63
    {load} cmp edx, ecx                          # 0041cf6a
    jge.d32 L_0041d47a                           # 0041cf6c
    # block 0x0041cf72: entered by fall-through of jge at 0x0041cf6c, 18 instruction(s), ends with jle to 0x0041d100 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0041cf72
    add edx, dword ptr [ebp - local_a0]          # 0041cf75
    movsx ax, byte ptr [edx]                     # 0041cf7b
    movsx ecx, word ptr [ebp - local_94]         # 0041cf7f
    imul ecx, ecx, 0x1d1                         # 0041cf86
    mov edx, dword ptr [ebp - local_9c]          # 0041cf8c
    mov edx, dword ptr [edx + field_795]         # 0041cf92
    mov word ptr [edx + ecx], ax                 # 0041cf98
    mov eax, dword ptr [ebp - local_a0]          # 0041cf9c
    add eax, 0x2                                 # 0041cfa2
    mov dword ptr [ebp - local_a0], eax          # 0041cfa5
    movsx ecx, word ptr [ebp - local_94]         # 0041cfab
    imul ecx, ecx, 0x1d1                         # 0041cfb2
    mov edx, dword ptr [ebp - local_9c]          # 0041cfb8
    mov eax, dword ptr [edx + field_795]         # 0041cfbe
    movsx ecx, word ptr [eax + ecx]              # 0041cfc4
    test ecx, ecx                                # 0041cfc8
    jle.d32 L_0041d100                           # 0041cfca
    # block 0x0041cfd0: entered by fall-through of jle at 0x0041cfca, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041d069 (forward)
    movsx edx, word ptr [ebp - local_94]         # 0041cfd0
    imul edx, edx, 0x1d1                         # 0041cfd7
    mov eax, dword ptr [ebp - local_9c]          # 0041cfdd
    mov ecx, dword ptr [eax + field_795]         # 0041cfe3
    movsx edx, word ptr [ecx + edx]              # 0041cfe9
    imul edx, edx, 0x5                           # 0041cfed
    push edx                                     # 0041cff0
    call FUN_0051dc43                            # 0041cff1
    add esp, 0x4                                 # 0041cff6
    mov dword ptr [ebp - local_16c], eax         # 0041cff9
    movsx eax, word ptr [ebp - local_94]         # 0041cfff
    imul eax, eax, 0x1d1                         # 0041d006
    mov ecx, dword ptr [ebp - local_9c]          # 0041d00c
    mov edx, dword ptr [ecx + field_795]         # 0041d012
    mov ecx, dword ptr [ebp - local_16c]         # 0041d018
    mov dword ptr [edx + eax + field_2], ecx     # 0041d01e
    cmp dword ptr [ebp - local_16c], 0x0         # 0041d022
    jne.d8 L_0041d069                            # 0041d029
    # block 0x0041d02b: entered by fall-through of jne at 0x0041d029, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041d069
    movsx edx, word ptr [0x5c39e3]               # 0041d02b
    push edx                                     # 0041d032
    mov eax, dword ptr [0x5bb57b]                # 0041d033
    push eax                                     # 0041d038
    push 0x54346c                                # 0041d039
    push 0x63888b                                # 0041d03e
    call FUN_0050ca3e                            # 0041d043
    add esp, 0x10                                # 0041d048
    push 0x63888b                                # 0041d04b
    push 0x5434b8                                # 0041d050
    mov ecx, 0x583979                            # 0041d055
    call FUN_0042639d                            # 0041d05a
    mov ecx, 0x5cf659                            # 0041d05f
    call FUN_004c97b4                            # 0041d064
L_0041d069:
    # block 0x0041d069: entered by jne at 0x0041d029, 2 instruction(s), ends with forward jump to 0x0041d086
    mov word ptr [ebp - local_98], 0x0           # 0041d069
    jmp.d8 L_0041d086                            # 0041d072
L_0041d074:
    # block 0x0041d074: entered by jmp at 0x0041d0f9, 3 instruction(s), falls into the block at 0x0041d086
    mov cx, word ptr [ebp - local_98]            # 0041d074
    add cx, 0x1                                  # 0041d07b
    mov word ptr [ebp - local_98], cx            # 0041d07f
L_0041d086:
    # block 0x0041d086: entered by jmp at 0x0041d072, 8 instruction(s), ends with jge to 0x0041d0fe (forward)
    movsx edx, word ptr [ebp - local_98]         # 0041d086
    movsx eax, word ptr [ebp - local_94]         # 0041d08d
    imul eax, eax, 0x1d1                         # 0041d094
    mov ecx, dword ptr [ebp - local_9c]          # 0041d09a
    mov ecx, dword ptr [ecx + field_795]         # 0041d0a0
    movsx eax, word ptr [ecx + eax]              # 0041d0a6
    {load} cmp edx, eax                          # 0041d0aa
    jge.d8 L_0041d0fe                            # 0041d0ac
    # block 0x0041d0ae: entered by fall-through of jge at 0x0041d0ac, 18 instruction(s), ends with backward jump to 0x0041d074
    mov ecx, dword ptr [ebp - local_4]           # 0041d0ae
    add ecx, dword ptr [ebp - local_a0]          # 0041d0b1
    movsx edx, word ptr [ebp - local_94]         # 0041d0b7
    imul edx, edx, 0x1d1                         # 0041d0be
    mov eax, dword ptr [ebp - local_9c]          # 0041d0c4
    mov eax, dword ptr [eax + field_795]         # 0041d0ca
    movsx esi, word ptr [ebp - local_98]         # 0041d0d0
    imul esi, esi, 0x5                           # 0041d0d7
    mov edx, dword ptr [eax + edx + field_2]     # 0041d0da
    {load} add edx, esi                          # 0041d0de
    mov eax, dword ptr [ecx]                     # 0041d0e0
    mov dword ptr [edx], eax                     # 0041d0e2
    mov cl, byte ptr [ecx + field_4]             # 0041d0e4
    mov byte ptr [edx + field_4], cl             # 0041d0e7
    mov edx, dword ptr [ebp - local_a0]          # 0041d0ea
    add edx, 0x5                                 # 0041d0f0
    mov dword ptr [ebp - local_a0], edx          # 0041d0f3
    jmp.d32 L_0041d074                           # 0041d0f9
L_0041d0fe:
    # block 0x0041d0fe: entered by jge at 0x0041d0ac, 1 instruction(s), ends with forward jump to 0x0041d121
    jmp.d8 L_0041d121                            # 0041d0fe
L_0041d100:
    # block 0x0041d100: entered by jle at 0x0041cfca, 5 instruction(s), falls into the block at 0x0041d121
    movsx eax, word ptr [ebp - local_94]         # 0041d100
    imul eax, eax, 0x1d1                         # 0041d107
    mov ecx, dword ptr [ebp - local_9c]          # 0041d10d
    mov edx, dword ptr [ecx + field_795]         # 0041d113
    mov dword ptr [edx + eax + field_2], 0x0     # 0041d119
L_0041d121:
    # block 0x0041d121: entered by jmp at 0x0041d0fe, 7 instruction(s), ends with ja to 0x0041d475 (forward)
    movsx eax, word ptr [ebp + arg_14]           # 0041d121
    mov dword ptr [ebp - local_188], eax         # 0041d125
    mov ecx, dword ptr [ebp - local_188]         # 0041d12b
    sub ecx, 0x39                                # 0041d131
    mov dword ptr [ebp - local_188], ecx         # 0041d134
    cmp dword ptr [ebp - local_188], 0x6         # 0041d13a
    ja.d32 L_0041d475                            # 0041d141
    # block 0x0041d147: entered by fall-through of ja at 0x0041d141, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x41db24]
    mov edx, dword ptr [ebp - local_188]         # 0041d147
    jmp dword ptr [4*edx + SWTAB_0041db24_VA]    # 0041d14d
L_0041d154:
    # block 0x0041d154: entered by switch case, 15 instruction(s), ends with forward jump to 0x0041d475
    mov esi, dword ptr [ebp - local_4]           # 0041d154
    add esi, dword ptr [ebp - local_a0]          # 0041d157
    movsx eax, word ptr [ebp - local_94]         # 0041d15d
    imul eax, eax, 0x1d1                         # 0041d164
    mov ecx, dword ptr [ebp - local_9c]          # 0041d16a
    mov edx, dword ptr [ecx + field_795]         # 0041d170
    lea edi, [edx + eax + field_6]               # 0041d176
    mov ecx, 0x72                                # 0041d17a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d17f
    movsw word ptr es:[edi], word ptr [esi]      # 0041d181
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041d183
    mov eax, dword ptr [ebp - local_a0]          # 0041d184
    add eax, 0x1cb                               # 0041d18a
    mov dword ptr [ebp - local_a0], eax          # 0041d18f
    jmp.d32 L_0041d475                           # 0041d195
L_0041d19a:
    # block 0x0041d19a: entered by switch case, 14 instruction(s), calls FUN_00423259, ends with jne to 0x0041d251 (forward)
    mov esi, dword ptr [ebp - local_4]           # 0041d19a
    add esi, dword ptr [ebp - local_a0]          # 0041d19d
    mov ecx, 0x8                                 # 0041d1a3
    lea edi, [ebp - local_c8]                    # 0041d1a8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d1ae
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041d1b0
    lea ecx, [ebp - local_c8]                    # 0041d1b1
    push ecx                                     # 0041d1b7
    mov ecx, dword ptr [ebp - local_180]         # 0041d1b8
    add ecx, 0xfd1                               # 0041d1be
    call FUN_00423259                            # 0041d1c4
    mov dword ptr [ebp - local_134], eax         # 0041d1c9
    cmp dword ptr [ebp - local_134], 0x0         # 0041d1cf
    jne.d8 L_0041d251                            # 0041d1d6
    # block 0x0041d1d8: entered by fall-through of jne at 0x0041d1d6, 3 instruction(s), ends with je to 0x0041d210 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0041d1d8
    test edx, edx                                # 0041d1df
    je.d8 L_0041d210                             # 0041d1e1
    # block 0x0041d1e3: entered by fall-through of je at 0x0041d1e1, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0041d210
    mov eax, dword ptr [0x5bb57b]                # 0041d1e3
    push eax                                     # 0041d1e8
    lea ecx, [ebp - local_c8]                    # 0041d1e9
    push ecx                                     # 0041d1ef
    push 0x5434d4                                # 0041d1f0
    push 0x63888b                                # 0041d1f5
    call FUN_0050ca3e                            # 0041d1fa
    add esp, 0x10                                # 0041d1ff
    push 0x0                                     # 0041d202
    push 0x0                                     # 0041d204
    push 0x63888b                                # 0041d206
    call FUN_0052139c                            # 0041d20b
L_0041d210:
    # block 0x0041d210: entered by je at 0x0041d1e1, 20 instruction(s), ends with forward jump to 0x0041d291
    mov edi, 0x543518                            # 0041d210
    movsx edx, word ptr [ebp - local_94]         # 0041d215
    imul edx, edx, 0x1d1                         # 0041d21c
    mov eax, dword ptr [ebp - local_9c]          # 0041d222
    mov ecx, dword ptr [eax + field_795]         # 0041d228
    lea edx, [ecx + edx + field_6]               # 0041d22e
    or ecx, -0x1                                 # 0041d232
    {load} xor eax, eax                          # 0041d235
    repne scasb al, byte ptr es:[edi]            # 0041d237
    not ecx                                      # 0041d239
    {load} sub edi, ecx                          # 0041d23b
    {load} mov esi, edi                          # 0041d23d
    {load} mov eax, ecx                          # 0041d23f
    {load} mov edi, edx                          # 0041d241
    shr ecx, 0x2                                 # 0041d243
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d246
    {load} mov ecx, eax                          # 0041d248
    and ecx, 0x3                                 # 0041d24a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041d24d
    jmp.d8 L_0041d291                            # 0041d24f
L_0041d251:
    # block 0x0041d251: entered by jne at 0x0041d1d6, 17 instruction(s), falls into the block at 0x0041d291
    mov edi, dword ptr [ebp - local_134]         # 0041d251
    or ecx, -0x1                                 # 0041d257
    {load} xor eax, eax                          # 0041d25a
    repne scasb al, byte ptr es:[edi]            # 0041d25c
    not ecx                                      # 0041d25e
    mov esi, dword ptr [ebp - local_134]         # 0041d260
    movsx edx, word ptr [ebp - local_94]         # 0041d266
    imul edx, edx, 0x1d1                         # 0041d26d
    mov eax, dword ptr [ebp - local_9c]          # 0041d273
    mov eax, dword ptr [eax + field_795]         # 0041d279
    lea edi, [eax + edx + field_6]               # 0041d27f
    {load} mov edx, ecx                          # 0041d283
    shr ecx, 0x2                                 # 0041d285
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d288
    {load} mov ecx, edx                          # 0041d28a
    and ecx, 0x3                                 # 0041d28c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041d28f
L_0041d291:
    # block 0x0041d291: entered by jmp at 0x0041d24f, 16 instruction(s), ends with forward jump to 0x0041d475
    mov eax, dword ptr [ebp - local_a0]          # 0041d291
    mov ecx, dword ptr [ebp - local_4]           # 0041d297
    lea esi, [ecx + eax + field_21]              # 0041d29a
    movsx edx, word ptr [ebp - local_94]         # 0041d29e
    imul edx, edx, 0x1d1                         # 0041d2a5
    mov eax, dword ptr [ebp - local_9c]          # 0041d2ab
    mov ecx, dword ptr [eax + field_795]         # 0041d2b1
    lea edi, [ecx + edx + field_196]             # 0041d2b7
    mov ecx, 0xe                                 # 0041d2be
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d2c3
    movsw word ptr es:[edi], word ptr [esi]      # 0041d2c5
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041d2c7
    mov edx, dword ptr [ebp - local_a0]          # 0041d2c8
    add edx, 0x5c                                # 0041d2ce
    mov dword ptr [ebp - local_a0], edx          # 0041d2d1
    jmp.d32 L_0041d475                           # 0041d2d7
L_0041d2dc:
    # block 0x0041d2dc: entered by switch case, 24 instruction(s), calls FUN_0041c770, FUN_00423259, ends with jne to 0x0041d3c8 (forward)
    movsx eax, word ptr [ebp - local_94]         # 0041d2dc
    imul eax, eax, 0x1d1                         # 0041d2e3
    mov ecx, dword ptr [ebp - local_9c]          # 0041d2e9
    mov edx, dword ptr [ecx + field_795]         # 0041d2ef
    {load} add edx, eax                          # 0041d2f5
    push edx                                     # 0041d2f7
    mov ecx, dword ptr [ebp - local_180]         # 0041d2f8
    call FUN_0041c770                            # 0041d2fe
    mov esi, dword ptr [ebp - local_4]           # 0041d303
    add esi, dword ptr [ebp - local_a0]          # 0041d306
    mov ecx, 0x11                                # 0041d30c
    lea edi, [ebp - local_130]                   # 0041d311
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d317
    mov eax, dword ptr [ebp - local_a0]          # 0041d319
    add eax, 0x44                                # 0041d31f
    mov dword ptr [ebp - local_a0], eax          # 0041d322
    lea ecx, [ebp - local_130]                   # 0041d328
    push ecx                                     # 0041d32e
    mov ecx, dword ptr [ebp - local_180]         # 0041d32f
    add ecx, 0xfd1                               # 0041d335
    call FUN_00423259                            # 0041d33b
    mov dword ptr [ebp - local_134], eax         # 0041d340
    cmp dword ptr [ebp - local_134], 0x0         # 0041d346
    jne.d8 L_0041d3c8                            # 0041d34d
    # block 0x0041d34f: entered by fall-through of jne at 0x0041d34d, 3 instruction(s), ends with je to 0x0041d387 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0041d34f
    test edx, edx                                # 0041d356
    je.d8 L_0041d387                             # 0041d358
    # block 0x0041d35a: entered by fall-through of je at 0x0041d358, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0041d387
    mov eax, dword ptr [0x5bb57b]                # 0041d35a
    push eax                                     # 0041d35f
    lea ecx, [ebp - local_130]                   # 0041d360
    push ecx                                     # 0041d366
    push 0x54355c                                # 0041d367
    push 0x63888b                                # 0041d36c
    call FUN_0050ca3e                            # 0041d371
    add esp, 0x10                                # 0041d376
    push 0x0                                     # 0041d379
    push 0x0                                     # 0041d37b
    push 0x63888b                                # 0041d37d
    call FUN_0052139c                            # 0041d382
L_0041d387:
    # block 0x0041d387: entered by je at 0x0041d358, 20 instruction(s), ends with forward jump to 0x0041d408
    mov edi, 0x5435b0                            # 0041d387
    movsx edx, word ptr [ebp - local_94]         # 0041d38c
    imul edx, edx, 0x1d1                         # 0041d393
    mov eax, dword ptr [ebp - local_9c]          # 0041d399
    mov ecx, dword ptr [eax + field_795]         # 0041d39f
    lea edx, [ecx + edx + field_6]               # 0041d3a5
    or ecx, -0x1                                 # 0041d3a9
    {load} xor eax, eax                          # 0041d3ac
    repne scasb al, byte ptr es:[edi]            # 0041d3ae
    not ecx                                      # 0041d3b0
    {load} sub edi, ecx                          # 0041d3b2
    {load} mov esi, edi                          # 0041d3b4
    {load} mov eax, ecx                          # 0041d3b6
    {load} mov edi, edx                          # 0041d3b8
    shr ecx, 0x2                                 # 0041d3ba
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d3bd
    {load} mov ecx, eax                          # 0041d3bf
    and ecx, 0x3                                 # 0041d3c1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041d3c4
    jmp.d8 L_0041d408                            # 0041d3c6
L_0041d3c8:
    # block 0x0041d3c8: entered by jne at 0x0041d34d, 17 instruction(s), falls into the block at 0x0041d408
    mov edi, dword ptr [ebp - local_134]         # 0041d3c8
    or ecx, -0x1                                 # 0041d3ce
    {load} xor eax, eax                          # 0041d3d1
    repne scasb al, byte ptr es:[edi]            # 0041d3d3
    not ecx                                      # 0041d3d5
    mov esi, dword ptr [ebp - local_134]         # 0041d3d7
    movsx edx, word ptr [ebp - local_94]         # 0041d3dd
    imul edx, edx, 0x1d1                         # 0041d3e4
    mov eax, dword ptr [ebp - local_9c]          # 0041d3ea
    mov eax, dword ptr [eax + field_795]         # 0041d3f0
    lea edi, [eax + edx + field_6]               # 0041d3f6
    {load} mov edx, ecx                          # 0041d3fa
    shr ecx, 0x2                                 # 0041d3fc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d3ff
    {load} mov ecx, edx                          # 0041d401
    and ecx, 0x3                                 # 0041d403
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041d406
L_0041d408:
    # block 0x0041d408: entered by jmp at 0x0041d3c6, 26 instruction(s), falls into the block at 0x0041d475
    lea edi, [ebp - local_10f]                   # 0041d408
    movsx eax, word ptr [ebp - local_94]         # 0041d40e
    imul eax, eax, 0x1d1                         # 0041d415
    mov ecx, dword ptr [ebp - local_9c]          # 0041d41b
    mov edx, dword ptr [ecx + field_795]         # 0041d421
    lea eax, [edx + eax + field_196]             # 0041d427
    {load} mov edx, eax                          # 0041d42e
    or ecx, -0x1                                 # 0041d430
    {load} xor eax, eax                          # 0041d433
    repne scasb al, byte ptr es:[edi]            # 0041d435
    not ecx                                      # 0041d437
    {load} sub edi, ecx                          # 0041d439
    {load} mov esi, edi                          # 0041d43b
    {load} mov eax, ecx                          # 0041d43d
    {load} mov edi, edx                          # 0041d43f
    shr ecx, 0x2                                 # 0041d441
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d444
    {load} mov ecx, eax                          # 0041d446
    and ecx, 0x3                                 # 0041d448
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041d44b
    movsx ecx, word ptr [ebp - local_94]         # 0041d44d
    imul ecx, ecx, 0x1d1                         # 0041d454
    mov edx, dword ptr [ebp - local_9c]          # 0041d45a
    mov eax, dword ptr [edx + field_795]         # 0041d460
    mov dx, word ptr [ebp - local_ee]            # 0041d466
    mov word ptr [eax + ecx + field_1b8], dx     # 0041d46d
L_0041d475:
    # block 0x0041d475: entered by ja at 0x0041d141; jmp at 0x0041d195; jmp at 0x0041d2d7; switch case, 1 instruction(s), ends with backward jump to 0x0041cf44
    jmp.d32 L_0041cf44                           # 0041d475
L_0041d47a:
    # block 0x0041d47a: entered by jge at 0x0041cf6c, 1 instruction(s), ends with forward jump to 0x0041d48c
    jmp.d8 L_0041d48c                            # 0041d47a
L_0041d47c:
    # block 0x0041d47c: entered by jle at 0x0041ceb8, 2 instruction(s), falls into the block at 0x0041d48c
    mov eax, dword ptr [ebp - local_9c]          # 0041d47c
    mov dword ptr [eax + field_795], 0x0         # 0041d482
L_0041d48c:
    # block 0x0041d48c: entered by jmp at 0x0041d47a, 3 instruction(s), ends with je to 0x0041d7be (forward)
    movsx ecx, word ptr [ebp + arg_14]           # 0041d48c
    cmp ecx, 0x3e                                # 0041d490
    je.d32 L_0041d7be                            # 0041d493
    # block 0x0041d499: entered by fall-through of je at 0x0041d493, 3 instruction(s), ends with je to 0x0041d7be (forward)
    movsx edx, word ptr [ebp + arg_14]           # 0041d499
    cmp edx, 0x3f                                # 0041d49d
    je.d32 L_0041d7be                            # 0041d4a0
    # block 0x0041d4a6: entered by fall-through of je at 0x0041d4a0, 12 instruction(s), ends with jle to 0x0041d7ae (forward)
    mov eax, dword ptr [ebp - local_4]           # 0041d4a6
    add eax, dword ptr [ebp - local_a0]          # 0041d4a9
    movsx cx, byte ptr [eax]                     # 0041d4af
    mov edx, dword ptr [ebp - local_9c]          # 0041d4b3
    mov word ptr [edx + field_799], cx           # 0041d4b9
    mov eax, dword ptr [ebp - local_a0]          # 0041d4c0
    add eax, 0x2                                 # 0041d4c6
    mov dword ptr [ebp - local_a0], eax          # 0041d4c9
    mov ecx, dword ptr [ebp - local_9c]          # 0041d4cf
    movsx edx, word ptr [ecx + field_799]        # 0041d4d5
    test edx, edx                                # 0041d4dc
    jle.d32 L_0041d7ae                           # 0041d4de
    # block 0x0041d4e4: entered by fall-through of jle at 0x0041d4de, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041d55d (forward)
    mov eax, dword ptr [ebp - local_9c]          # 0041d4e4
    movsx ecx, word ptr [eax + field_799]        # 0041d4ea
    imul ecx, ecx, 0x1c                          # 0041d4f1
    push ecx                                     # 0041d4f4
    call FUN_0051dc43                            # 0041d4f5
    add esp, 0x4                                 # 0041d4fa
    mov dword ptr [ebp - local_170], eax         # 0041d4fd
    mov edx, dword ptr [ebp - local_9c]          # 0041d503
    mov eax, dword ptr [ebp - local_170]         # 0041d509
    mov dword ptr [edx + field_79b], eax         # 0041d50f
    cmp dword ptr [ebp - local_170], 0x0         # 0041d515
    jne.d8 L_0041d55d                            # 0041d51c
    # block 0x0041d51e: entered by fall-through of jne at 0x0041d51c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041d55d
    movsx ecx, word ptr [0x5c39e3]               # 0041d51e
    push ecx                                     # 0041d525
    mov edx, dword ptr [0x5bb57b]                # 0041d526
    push edx                                     # 0041d52c
    push 0x5435f4                                # 0041d52d
    push 0x63888b                                # 0041d532
    call FUN_0050ca3e                            # 0041d537
    add esp, 0x10                                # 0041d53c
    push 0x63888b                                # 0041d53f
    push 0x543634                                # 0041d544
    mov ecx, 0x583979                            # 0041d549
    call FUN_0042639d                            # 0041d54e
    mov ecx, 0x5cf659                            # 0041d553
    call FUN_004c97b4                            # 0041d558
L_0041d55d:
    # block 0x0041d55d: entered by jne at 0x0041d51c, 2 instruction(s), ends with forward jump to 0x0041d57a
    mov word ptr [ebp - local_94], 0x0           # 0041d55d
    jmp.d8 L_0041d57a                            # 0041d566
L_0041d568:
    # block 0x0041d568: entered by jmp at 0x0041d7a7, 3 instruction(s), falls into the block at 0x0041d57a
    mov ax, word ptr [ebp - local_94]            # 0041d568
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041d56f
    mov word ptr [ebp - local_94], ax            # 0041d573
L_0041d57a:
    # block 0x0041d57a: entered by jmp at 0x0041d566, 5 instruction(s), ends with jge to 0x0041d7ac (forward)
    movsx ecx, word ptr [ebp - local_94]         # 0041d57a
    mov edx, dword ptr [ebp - local_9c]          # 0041d581
    movsx eax, word ptr [edx + field_799]        # 0041d587
    {load} cmp ecx, eax                          # 0041d58e
    jge.d32 L_0041d7ac                           # 0041d590
    # block 0x0041d596: entered by fall-through of jge at 0x0041d590, 18 instruction(s), ends with jle to 0x0041d74e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0041d596
    add ecx, dword ptr [ebp - local_a0]          # 0041d599
    movsx dx, byte ptr [ecx]                     # 0041d59f
    movsx eax, word ptr [ebp - local_94]         # 0041d5a3
    imul eax, eax, 0x1c                          # 0041d5aa
    mov ecx, dword ptr [ebp - local_9c]          # 0041d5ad
    mov ecx, dword ptr [ecx + field_79b]         # 0041d5b3
    mov word ptr [ecx + eax], dx                 # 0041d5b9
    mov edx, dword ptr [ebp - local_a0]          # 0041d5bd
    add edx, 0x2                                 # 0041d5c3
    mov dword ptr [ebp - local_a0], edx          # 0041d5c6
    movsx eax, word ptr [ebp - local_94]         # 0041d5cc
    imul eax, eax, 0x1c                          # 0041d5d3
    mov ecx, dword ptr [ebp - local_9c]          # 0041d5d6
    mov edx, dword ptr [ecx + field_79b]         # 0041d5dc
    movsx eax, word ptr [edx + eax]              # 0041d5e2
    test eax, eax                                # 0041d5e6
    jle.d32 L_0041d74e                           # 0041d5e8
    # block 0x0041d5ee: entered by fall-through of jle at 0x0041d5e8, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041d682 (forward)
    movsx ecx, word ptr [ebp - local_94]         # 0041d5ee
    imul ecx, ecx, 0x1c                          # 0041d5f5
    mov edx, dword ptr [ebp - local_9c]          # 0041d5f8
    mov eax, dword ptr [edx + field_79b]         # 0041d5fe
    movsx ecx, word ptr [eax + ecx]              # 0041d604
    imul ecx, ecx, 0x5                           # 0041d608
    push ecx                                     # 0041d60b
    call FUN_0051dc43                            # 0041d60c
    add esp, 0x4                                 # 0041d611
    mov dword ptr [ebp - local_174], eax         # 0041d614
    movsx edx, word ptr [ebp - local_94]         # 0041d61a
    imul edx, edx, 0x1c                          # 0041d621
    mov eax, dword ptr [ebp - local_9c]          # 0041d624
    mov ecx, dword ptr [eax + field_79b]         # 0041d62a
    mov eax, dword ptr [ebp - local_174]         # 0041d630
    mov dword ptr [ecx + edx + field_2], eax     # 0041d636
    cmp dword ptr [ebp - local_174], 0x0         # 0041d63a
    jne.d8 L_0041d682                            # 0041d641
    # block 0x0041d643: entered by fall-through of jne at 0x0041d641, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041d682
    movsx ecx, word ptr [0x5c39e3]               # 0041d643
    push ecx                                     # 0041d64a
    mov edx, dword ptr [0x5bb57b]                # 0041d64b
    push edx                                     # 0041d651
    push 0x543650                                # 0041d652
    push 0x63888b                                # 0041d657
    call FUN_0050ca3e                            # 0041d65c
    add esp, 0x10                                # 0041d661
    push 0x63888b                                # 0041d664
    push 0x5436a0                                # 0041d669
    mov ecx, 0x583979                            # 0041d66e
    call FUN_0042639d                            # 0041d673
    mov ecx, 0x5cf659                            # 0041d678
    call FUN_004c97b4                            # 0041d67d
L_0041d682:
    # block 0x0041d682: entered by jne at 0x0041d641, 2 instruction(s), ends with forward jump to 0x0041d69f
    mov word ptr [ebp - local_98], 0x0           # 0041d682
    jmp.d8 L_0041d69f                            # 0041d68b
L_0041d68d:
    # block 0x0041d68d: entered by jmp at 0x0041d70c, 3 instruction(s), falls into the block at 0x0041d69f
    mov ax, word ptr [ebp - local_98]            # 0041d68d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041d694
    mov word ptr [ebp - local_98], ax            # 0041d698
L_0041d69f:
    # block 0x0041d69f: entered by jmp at 0x0041d68b, 8 instruction(s), ends with jge to 0x0041d711 (forward)
    movsx ecx, word ptr [ebp - local_98]         # 0041d69f
    movsx edx, word ptr [ebp - local_94]         # 0041d6a6
    imul edx, edx, 0x1c                          # 0041d6ad
    mov eax, dword ptr [ebp - local_9c]          # 0041d6b0
    mov eax, dword ptr [eax + field_79b]         # 0041d6b6
    movsx edx, word ptr [eax + edx]              # 0041d6bc
    {load} cmp ecx, edx                          # 0041d6c0
    jge.d8 L_0041d711                            # 0041d6c2
    # block 0x0041d6c4: entered by fall-through of jge at 0x0041d6c2, 18 instruction(s), ends with backward jump to 0x0041d68d
    mov eax, dword ptr [ebp - local_4]           # 0041d6c4
    add eax, dword ptr [ebp - local_a0]          # 0041d6c7
    movsx ecx, word ptr [ebp - local_94]         # 0041d6cd
    imul ecx, ecx, 0x1c                          # 0041d6d4
    mov edx, dword ptr [ebp - local_9c]          # 0041d6d7
    mov edx, dword ptr [edx + field_79b]         # 0041d6dd
    movsx esi, word ptr [ebp - local_98]         # 0041d6e3
    imul esi, esi, 0x5                           # 0041d6ea
    mov ecx, dword ptr [edx + ecx + field_2]     # 0041d6ed
    {load} add ecx, esi                          # 0041d6f1
    mov edx, dword ptr [eax]                     # 0041d6f3
    mov dword ptr [ecx], edx                     # 0041d6f5
    mov al, byte ptr [eax + field_4]             # 0041d6f7
    mov byte ptr [ecx + field_4], al             # 0041d6fa
    mov ecx, dword ptr [ebp - local_a0]          # 0041d6fd
    add ecx, 0x5                                 # 0041d703
    mov dword ptr [ebp - local_a0], ecx          # 0041d706
    jmp.d32 L_0041d68d                           # 0041d70c
L_0041d711:
    # block 0x0041d711: entered by jge at 0x0041d6c2, 14 instruction(s), ends with forward jump to 0x0041d7a7
    mov esi, dword ptr [ebp - local_4]           # 0041d711
    add esi, dword ptr [ebp - local_a0]          # 0041d714
    movsx edx, word ptr [ebp - local_94]         # 0041d71a
    imul edx, edx, 0x1c                          # 0041d721
    mov eax, dword ptr [ebp - local_9c]          # 0041d724
    mov ecx, dword ptr [eax + field_79b]         # 0041d72a
    lea edi, [ecx + edx + field_6]               # 0041d730
    mov ecx, 0x5                                 # 0041d734
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d739
    movsw word ptr es:[edi], word ptr [esi]      # 0041d73b
    mov edx, dword ptr [ebp - local_a0]          # 0041d73d
    add edx, 0x16                                # 0041d743
    mov dword ptr [ebp - local_a0], edx          # 0041d746
    jmp.d8 L_0041d7a7                            # 0041d74c
L_0041d74e:
    # block 0x0041d74e: entered by jle at 0x0041d5e8, 18 instruction(s), falls into the block at 0x0041d7a7
    movsx eax, word ptr [ebp - local_94]         # 0041d74e
    imul eax, eax, 0x1c                          # 0041d755
    mov ecx, dword ptr [ebp - local_9c]          # 0041d758
    mov edx, dword ptr [ecx + field_79b]         # 0041d75e
    mov dword ptr [edx + eax + field_2], 0x0     # 0041d764
    mov esi, dword ptr [ebp - local_4]           # 0041d76c
    add esi, dword ptr [ebp - local_a0]          # 0041d76f
    movsx eax, word ptr [ebp - local_94]         # 0041d775
    imul eax, eax, 0x1c                          # 0041d77c
    mov ecx, dword ptr [ebp - local_9c]          # 0041d77f
    mov edx, dword ptr [ecx + field_79b]         # 0041d785
    lea edi, [edx + eax + field_6]               # 0041d78b
    mov ecx, 0x5                                 # 0041d78f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041d794
    movsw word ptr es:[edi], word ptr [esi]      # 0041d796
    mov eax, dword ptr [ebp - local_a0]          # 0041d798
    add eax, 0x16                                # 0041d79e
    mov dword ptr [ebp - local_a0], eax          # 0041d7a1
L_0041d7a7:
    # block 0x0041d7a7: entered by jmp at 0x0041d74c, 1 instruction(s), ends with backward jump to 0x0041d568
    jmp.d32 L_0041d568                           # 0041d7a7
L_0041d7ac:
    # block 0x0041d7ac: entered by jge at 0x0041d590, 1 instruction(s), ends with forward jump to 0x0041d7be
    jmp.d8 L_0041d7be                            # 0041d7ac
L_0041d7ae:
    # block 0x0041d7ae: entered by jle at 0x0041d4de, 2 instruction(s), falls into the block at 0x0041d7be
    mov ecx, dword ptr [ebp - local_9c]          # 0041d7ae
    mov dword ptr [ecx + field_79b], 0x0         # 0041d7b4
L_0041d7be:
    # block 0x0041d7be: entered by je at 0x0041d493; je at 0x0041d4a0; jmp at 0x0041d7ac, 12 instruction(s), ends with jle to 0x0041dab8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0041d7be
    add edx, dword ptr [ebp - local_a0]          # 0041d7c1
    movsx ax, byte ptr [edx]                     # 0041d7c7
    mov ecx, dword ptr [ebp - local_9c]          # 0041d7cb
    mov word ptr [ecx + field_79f], ax           # 0041d7d1
    mov edx, dword ptr [ebp - local_a0]          # 0041d7d8
    add edx, 0x2                                 # 0041d7de
    mov dword ptr [ebp - local_a0], edx          # 0041d7e1
    mov eax, dword ptr [ebp - local_9c]          # 0041d7e7
    movsx ecx, word ptr [eax + field_79f]        # 0041d7ed
    test ecx, ecx                                # 0041d7f4
    jle.d32 L_0041dab8                           # 0041d7f6
    # block 0x0041d7fc: entered by fall-through of jle at 0x0041d7f6, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041d875 (forward)
    mov edx, dword ptr [ebp - local_9c]          # 0041d7fc
    movsx eax, word ptr [edx + field_79f]        # 0041d802
    imul eax, eax, 0xa                           # 0041d809
    push eax                                     # 0041d80c
    call FUN_0051dc43                            # 0041d80d
    add esp, 0x4                                 # 0041d812
    mov dword ptr [ebp - local_178], eax         # 0041d815
    mov ecx, dword ptr [ebp - local_9c]          # 0041d81b
    mov edx, dword ptr [ebp - local_178]         # 0041d821
    mov dword ptr [ecx + field_7a1], edx         # 0041d827
    cmp dword ptr [ebp - local_178], 0x0         # 0041d82d
    jne.d8 L_0041d875                            # 0041d834
    # block 0x0041d836: entered by fall-through of jne at 0x0041d834, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041d875
    movsx eax, word ptr [0x5c39e3]               # 0041d836
    push eax                                     # 0041d83d
    mov ecx, dword ptr [0x5bb57b]                # 0041d83e
    push ecx                                     # 0041d844
    push 0x5436bc                                # 0041d845
    push 0x63888b                                # 0041d84a
    call FUN_0050ca3e                            # 0041d84f
    add esp, 0x10                                # 0041d854
    push 0x63888b                                # 0041d857
    push 0x5436f4                                # 0041d85c
    mov ecx, 0x583979                            # 0041d861
    call FUN_0042639d                            # 0041d866
    mov ecx, 0x5cf659                            # 0041d86b
    call FUN_004c97b4                            # 0041d870
L_0041d875:
    # block 0x0041d875: entered by jne at 0x0041d834, 2 instruction(s), ends with forward jump to 0x0041d892
    mov word ptr [ebp - local_94], 0x0           # 0041d875
    jmp.d8 L_0041d892                            # 0041d87e
L_0041d880:
    # block 0x0041d880: entered by jmp at 0x0041dab1, 3 instruction(s), falls into the block at 0x0041d892
    mov dx, word ptr [ebp - local_94]            # 0041d880
    add dx, 0x1                                  # 0041d887
    mov word ptr [ebp - local_94], dx            # 0041d88b
L_0041d892:
    # block 0x0041d892: entered by jmp at 0x0041d87e, 5 instruction(s), ends with jge to 0x0041dab6 (forward)
    movsx eax, word ptr [ebp - local_94]         # 0041d892
    mov ecx, dword ptr [ebp - local_9c]          # 0041d899
    movsx edx, word ptr [ecx + field_79f]        # 0041d89f
    {load} cmp eax, edx                          # 0041d8a6
    jge.d32 L_0041dab6                           # 0041d8a8
    # block 0x0041d8ae: entered by fall-through of jge at 0x0041d8a8, 18 instruction(s), ends with jle to 0x0041da5f (forward)
    mov eax, dword ptr [ebp - local_4]           # 0041d8ae
    add eax, dword ptr [ebp - local_a0]          # 0041d8b1
    movsx cx, byte ptr [eax]                     # 0041d8b7
    movsx edx, word ptr [ebp - local_94]         # 0041d8bb
    imul edx, edx, 0xa                           # 0041d8c2
    mov eax, dword ptr [ebp - local_9c]          # 0041d8c5
    mov eax, dword ptr [eax + field_7a1]         # 0041d8cb
    mov word ptr [eax + edx], cx                 # 0041d8d1
    mov ecx, dword ptr [ebp - local_a0]          # 0041d8d5
    add ecx, 0x2                                 # 0041d8db
    mov dword ptr [ebp - local_a0], ecx          # 0041d8de
    movsx edx, word ptr [ebp - local_94]         # 0041d8e4
    imul edx, edx, 0xa                           # 0041d8eb
    mov eax, dword ptr [ebp - local_9c]          # 0041d8ee
    mov ecx, dword ptr [eax + field_7a1]         # 0041d8f4
    movsx edx, word ptr [ecx + edx]              # 0041d8fa
    test edx, edx                                # 0041d8fe
    jle.d32 L_0041da5f                           # 0041d900
    # block 0x0041d906: entered by fall-through of jle at 0x0041d900, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041d99a (forward)
    movsx eax, word ptr [ebp - local_94]         # 0041d906
    imul eax, eax, 0xa                           # 0041d90d
    mov ecx, dword ptr [ebp - local_9c]          # 0041d910
    mov edx, dword ptr [ecx + field_7a1]         # 0041d916
    movsx eax, word ptr [edx + eax]              # 0041d91c
    imul eax, eax, 0x5                           # 0041d920
    push eax                                     # 0041d923
    call FUN_0051dc43                            # 0041d924
    add esp, 0x4                                 # 0041d929
    mov dword ptr [ebp - local_17c], eax         # 0041d92c
    movsx ecx, word ptr [ebp - local_94]         # 0041d932
    imul ecx, ecx, 0xa                           # 0041d939
    mov edx, dword ptr [ebp - local_9c]          # 0041d93c
    mov eax, dword ptr [edx + field_7a1]         # 0041d942
    mov edx, dword ptr [ebp - local_17c]         # 0041d948
    mov dword ptr [eax + ecx + field_2], edx     # 0041d94e
    cmp dword ptr [ebp - local_17c], 0x0         # 0041d952
    jne.d8 L_0041d99a                            # 0041d959
    # block 0x0041d95b: entered by fall-through of jne at 0x0041d959, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041d99a
    movsx eax, word ptr [0x5c39e3]               # 0041d95b
    push eax                                     # 0041d962
    mov ecx, dword ptr [0x5bb57b]                # 0041d963
    push ecx                                     # 0041d969
    push 0x543710                                # 0041d96a
    push 0x63888b                                # 0041d96f
    call FUN_0050ca3e                            # 0041d974
    add esp, 0x10                                # 0041d979
    push 0x63888b                                # 0041d97c
    push 0x543758                                # 0041d981
    mov ecx, 0x583979                            # 0041d986
    call FUN_0042639d                            # 0041d98b
    mov ecx, 0x5cf659                            # 0041d990
    call FUN_004c97b4                            # 0041d995
L_0041d99a:
    # block 0x0041d99a: entered by jne at 0x0041d959, 2 instruction(s), ends with forward jump to 0x0041d9b7
    mov word ptr [ebp - local_98], 0x0           # 0041d99a
    jmp.d8 L_0041d9b7                            # 0041d9a3
L_0041d9a5:
    # block 0x0041d9a5: entered by jmp at 0x0041da24, 3 instruction(s), falls into the block at 0x0041d9b7
    mov dx, word ptr [ebp - local_98]            # 0041d9a5
    add dx, 0x1                                  # 0041d9ac
    mov word ptr [ebp - local_98], dx            # 0041d9b0
L_0041d9b7:
    # block 0x0041d9b7: entered by jmp at 0x0041d9a3, 8 instruction(s), ends with jge to 0x0041da29 (forward)
    movsx eax, word ptr [ebp - local_98]         # 0041d9b7
    movsx ecx, word ptr [ebp - local_94]         # 0041d9be
    imul ecx, ecx, 0xa                           # 0041d9c5
    mov edx, dword ptr [ebp - local_9c]          # 0041d9c8
    mov edx, dword ptr [edx + field_7a1]         # 0041d9ce
    movsx ecx, word ptr [edx + ecx]              # 0041d9d4
    {load} cmp eax, ecx                          # 0041d9d8
    jge.d8 L_0041da29                            # 0041d9da
    # block 0x0041d9dc: entered by fall-through of jge at 0x0041d9da, 18 instruction(s), ends with backward jump to 0x0041d9a5
    mov edx, dword ptr [ebp - local_4]           # 0041d9dc
    add edx, dword ptr [ebp - local_a0]          # 0041d9df
    movsx eax, word ptr [ebp - local_94]         # 0041d9e5
    imul eax, eax, 0xa                           # 0041d9ec
    mov ecx, dword ptr [ebp - local_9c]          # 0041d9ef
    mov ecx, dword ptr [ecx + field_7a1]         # 0041d9f5
    movsx esi, word ptr [ebp - local_98]         # 0041d9fb
    imul esi, esi, 0x5                           # 0041da02
    mov eax, dword ptr [ecx + eax + field_2]     # 0041da05
    {load} add eax, esi                          # 0041da09
    mov ecx, dword ptr [edx]                     # 0041da0b
    mov dword ptr [eax], ecx                     # 0041da0d
    mov dl, byte ptr [edx + field_4]             # 0041da0f
    mov byte ptr [eax + field_4], dl             # 0041da12
    mov eax, dword ptr [ebp - local_a0]          # 0041da15
    add eax, 0x5                                 # 0041da1b
    mov dword ptr [ebp - local_a0], eax          # 0041da1e
    jmp.d32 L_0041d9a5                           # 0041da24
L_0041da29:
    # block 0x0041da29: entered by jge at 0x0041d9da, 12 instruction(s), ends with forward jump to 0x0041dab1
    movsx ecx, word ptr [ebp - local_94]         # 0041da29
    imul ecx, ecx, 0xa                           # 0041da30
    mov edx, dword ptr [ebp - local_9c]          # 0041da33
    mov eax, dword ptr [edx + field_7a1]         # 0041da39
    mov edx, dword ptr [ebp - local_4]           # 0041da3f
    add edx, dword ptr [ebp - local_a0]          # 0041da42
    mov edx, dword ptr [edx]                     # 0041da48
    mov dword ptr [eax + ecx + field_6], edx     # 0041da4a
    mov eax, dword ptr [ebp - local_a0]          # 0041da4e
    add eax, 0x4                                 # 0041da54
    mov dword ptr [ebp - local_a0], eax          # 0041da57
    jmp.d8 L_0041dab1                            # 0041da5d
L_0041da5f:
    # block 0x0041da5f: entered by jle at 0x0041d900, 16 instruction(s), falls into the block at 0x0041dab1
    movsx ecx, word ptr [ebp - local_94]         # 0041da5f
    imul ecx, ecx, 0xa                           # 0041da66
    mov edx, dword ptr [ebp - local_9c]          # 0041da69
    mov eax, dword ptr [edx + field_7a1]         # 0041da6f
    mov dword ptr [eax + ecx + field_2], 0x0     # 0041da75
    movsx ecx, word ptr [ebp - local_94]         # 0041da7d
    imul ecx, ecx, 0xa                           # 0041da84
    mov edx, dword ptr [ebp - local_9c]          # 0041da87
    mov eax, dword ptr [edx + field_7a1]         # 0041da8d
    mov edx, dword ptr [ebp - local_4]           # 0041da93
    add edx, dword ptr [ebp - local_a0]          # 0041da96
    mov edx, dword ptr [edx]                     # 0041da9c
    mov dword ptr [eax + ecx + field_6], edx     # 0041da9e
    mov eax, dword ptr [ebp - local_a0]          # 0041daa2
    add eax, 0x4                                 # 0041daa8
    mov dword ptr [ebp - local_a0], eax          # 0041daab
L_0041dab1:
    # block 0x0041dab1: entered by jmp at 0x0041da5d, 1 instruction(s), ends with backward jump to 0x0041d880
    jmp.d32 L_0041d880                           # 0041dab1
L_0041dab6:
    # block 0x0041dab6: entered by jge at 0x0041d8a8, 1 instruction(s), ends with forward jump to 0x0041dac8
    jmp.d8 L_0041dac8                            # 0041dab6
L_0041dab8:
    # block 0x0041dab8: entered by jle at 0x0041d7f6, 2 instruction(s), falls into the block at 0x0041dac8
    mov ecx, dword ptr [ebp - local_9c]          # 0041dab8
    mov dword ptr [ecx + field_7a1], 0x0         # 0041dabe
L_0041dac8:
    # block 0x0041dac8: entered by jmp at 0x0041dab6, 13 instruction(s), ends with je to 0x0041db00 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 0041dac8
    mov eax, dword ptr [edx]                     # 0041dacb
    add eax, dword ptr [ebp - local_a0]          # 0041dacd
    mov ecx, dword ptr [ebp + arg_10]            # 0041dad3
    mov dword ptr [ecx], eax                     # 0041dad6
    mov edx, dword ptr [ebp + arg_c]             # 0041dad8
    mov eax, dword ptr [edx]                     # 0041dadb
    add eax, dword ptr [ebp - local_a0]          # 0041dadd
    mov ecx, dword ptr [ebp + arg_c]             # 0041dae3
    mov dword ptr [ecx], eax                     # 0041dae6
    movsx edx, word ptr [0x63a4cd]               # 0041dae8
    test edx, edx                                # 0041daef
    je.d8 L_0041db00                             # 0041daf1
    # block 0x0041daf3: entered by fall-through of je at 0x0041daf1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041db00
    push 0x543774                                # 0041daf3
    call FUN_0044a2b7                            # 0041daf8
    add esp, 0x4                                 # 0041dafd
L_0041db00:
    # block 0x0041db00: entered by je at 0x0041daf1, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 0041db00
    pop esi                                      # 0041db01
    {load} mov esp, ebp                          # 0041db02
    pop ebp                                      # 0041db04
    ret 0x10                                     # 0041db05

# --- data items (not part of the function) -------------------------
.org 0x0041db08 - 0x401000
SWTAB_0041db08:  # 7 case address(es)
    .long L_0041c8bb - .text + 0x401000
    .long L_0041c923 - .text + 0x401000
    .long L_0041c986 - .text + 0x401000
    .long L_0041cc23 - .text + 0x401000
    .long L_0041ce29 - .text + 0x401000
    .long L_0041caa3 - .text + 0x401000
    .long L_0041cd3c - .text + 0x401000
.org 0x0041db24 - 0x401000
SWTAB_0041db24:  # 7 case address(es)
    .long L_0041d154 - .text + 0x401000
    .long L_0041d154 - .text + 0x401000
    .long L_0041d19a - .text + 0x401000
    .long L_0041d19a - .text + 0x401000
    .long L_0041d475 - .text + 0x401000
    .long L_0041d2dc - .text + 0x401000
    .long L_0041d2dc - .text + 0x401000
.set SWTAB_0041db08_VA, SWTAB_0041db08 - .text + 0x401000
.set SWTAB_0041db24_VA, SWTAB_0041db24 - .text + 0x401000

