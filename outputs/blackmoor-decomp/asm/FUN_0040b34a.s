# FUN_0040b34a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b34a
# extent:       0x0040b34a-0x00410ca4 (22874 code bytes)
# span:         0x0040b34a-0x00410f99 (code 22874, tables 757, padding 0)
# sha256:       4062d1654b520613e4628df3f85ac8f69b60b0507d4f522513b45cc9dd6833de
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b34a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       103 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_48, local_4c, local_50 and 91 more
# fields:       [eax + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_12, field_14, field_16, field_32, field_6d and 4 more; [ecx + n] field_2, field_4, field_8, field_a, field_c, field_e, field_28, field_2a, field_2e, field_6d, field_71, field_aa and 1 more; [edi + n] field_minus_1; [edx + n] field_2, field_3, field_4, field_6, field_8, field_a, field_c, field_d, field_12, field_16, field_30, field_31 and 8 more
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_0051dc43, FUN_0042639d, FUN_004c97b4, FUN_0040b2d0, FUN_00414692, FUN_004caff5, FUN_004471ca, FUN_004cd243, FUN_004cd645, FUN_0041c7f4, FUN_004bf8c2, FUN_00488e9c, FUN_0048905b, FUN_004895cc and 63 more
# track-n:      outputs/blackmoor-decomp/src/action_family_62.c:action_family_62_decode (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 5261 instruction(s), 181 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_cc, 0xcc  # offset -0xcc
.equ local_d0, 0xd0  # offset -0xd0
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ local_fc, 0xfc  # offset -0xfc
.equ local_100, 0x100  # offset -0x100
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_150, 0x150  # offset -0x150
.equ local_154, 0x154  # offset -0x154
.equ local_158, 0x158  # offset -0x158
.equ local_15c, 0x15c  # offset -0x15c
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
.equ local_18c, 0x18c  # offset -0x18c
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ local_1b4, 0x1b4  # offset -0x1b4
.equ local_1b8, 0x1b8  # offset -0x1b8
.equ local_1bc, 0x1bc  # offset -0x1bc
.equ local_1c0, 0x1c0  # offset -0x1c0
.equ local_1c4, 0x1c4  # offset -0x1c4
.equ local_1c8, 0x1c8  # offset -0x1c8
.equ local_1cc, 0x1cc  # offset -0x1cc
.equ local_1d0, 0x1d0  # offset -0x1d0
.equ local_1d4, 0x1d4  # offset -0x1d4
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc
.equ local_1e0, 0x1e0  # offset -0x1e0
.equ local_1e4, 0x1e4  # offset -0x1e4
.equ local_1e8, 0x1e8  # offset -0x1e8
.equ local_1ec, 0x1ec  # offset -0x1ec
.equ local_1f0, 0x1f0  # offset -0x1f0
.equ local_1f4, 0x1f4  # offset -0x1f4
.equ local_1f8, 0x1f8  # offset -0x1f8
.equ local_1fc, 0x1fc  # offset -0x1fc
.equ local_200, 0x200  # offset -0x200
.equ local_204, 0x204  # offset -0x204
.equ local_208, 0x208  # offset -0x208
.equ local_20c, 0x20c  # offset -0x20c
.equ local_210, 0x210  # offset -0x210
.equ local_214, 0x214  # offset -0x214
.equ local_218, 0x218  # offset -0x218
.equ local_21c, 0x21c  # offset -0x21c
.equ local_220, 0x220  # offset -0x220
.equ local_224, 0x224  # offset -0x224
.equ local_228, 0x228  # offset -0x228
.equ local_22c, 0x22c  # offset -0x22c
.equ local_230, 0x230  # offset -0x230
.equ local_234, 0x234  # offset -0x234
.equ local_238, 0x238  # offset -0x238
.equ local_23c, 0x23c  # offset -0x23c
.equ field_minus_2710, 0x2710  # offset -0x2710
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_31, 0x31  # offset +0x31
.equ field_32, 0x32  # offset +0x32
.equ field_4a, 0x4a  # offset +0x4a
.equ field_6d, 0x6d  # offset +0x6d
.equ field_6f, 0x6f  # offset +0x6f
.equ field_71, 0x71  # offset +0x71
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ac, 0xac  # offset +0xac
.equ field_ad, 0xad  # offset +0xad
.equ field_c2, 0xc2  # offset +0xc2
.equ field_627, 0x627  # offset +0x627

# --- external targets -----------------------------------------------
.set FUN_0040b2d0, .text + (0x0040b2d0 - 0x401000)
.set FUN_00410f99, .text + (0x00410f99 - 0x401000)
.set FUN_0041137f, .text + (0x0041137f - 0x401000)
.set FUN_0041166e, .text + (0x0041166e - 0x401000)
.set FUN_0041195c, .text + (0x0041195c - 0x401000)
.set FUN_00411a22, .text + (0x00411a22 - 0x401000)
.set FUN_00414692, .text + (0x00414692 - 0x401000)
.set FUN_0041c7f4, .text + (0x0041c7f4 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00424aa8, .text + (0x00424aa8 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004471ca, .text + (0x004471ca - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044b05a, .text + (0x0044b05a - 0x401000)
.set FUN_0044b102, .text + (0x0044b102 - 0x401000)
.set FUN_0044b1b4, .text + (0x0044b1b4 - 0x401000)
.set FUN_0044d1d1, .text + (0x0044d1d1 - 0x401000)
.set FUN_0044e8a2, .text + (0x0044e8a2 - 0x401000)
.set FUN_0044fbe3, .text + (0x0044fbe3 - 0x401000)
.set FUN_00454e70, .text + (0x00454e70 - 0x401000)
.set FUN_00456fb6, .text + (0x00456fb6 - 0x401000)
.set FUN_0045807c, .text + (0x0045807c - 0x401000)
.set FUN_00459c10, .text + (0x00459c10 - 0x401000)
.set FUN_0045b4ae, .text + (0x0045b4ae - 0x401000)
.set FUN_0045ddd0, .text + (0x0045ddd0 - 0x401000)
.set FUN_00461903, .text + (0x00461903 - 0x401000)
.set FUN_00464100, .text + (0x00464100 - 0x401000)
.set FUN_00465bde, .text + (0x00465bde - 0x401000)
.set FUN_00467688, .text + (0x00467688 - 0x401000)
.set FUN_00468f9f, .text + (0x00468f9f - 0x401000)
.set FUN_0046b79a, .text + (0x0046b79a - 0x401000)
.set FUN_0046e823, .text + (0x0046e823 - 0x401000)
.set FUN_00470e8e, .text + (0x00470e8e - 0x401000)
.set FUN_0047314b, .text + (0x0047314b - 0x401000)
.set FUN_00475964, .text + (0x00475964 - 0x401000)
.set FUN_004782db, .text + (0x004782db - 0x401000)
.set FUN_0047b3f0, .text + (0x0047b3f0 - 0x401000)
.set FUN_0047d682, .text + (0x0047d682 - 0x401000)
.set FUN_0047e477, .text + (0x0047e477 - 0x401000)
.set FUN_00482248, .text + (0x00482248 - 0x401000)
.set FUN_00484110, .text + (0x00484110 - 0x401000)
.set FUN_00487bd7, .text + (0x00487bd7 - 0x401000)
.set FUN_00488e9c, .text + (0x00488e9c - 0x401000)
.set FUN_0048905b, .text + (0x0048905b - 0x401000)
.set FUN_004895cc, .text + (0x004895cc - 0x401000)
.set FUN_0048a865, .text + (0x0048a865 - 0x401000)
.set FUN_0048bca6, .text + (0x0048bca6 - 0x401000)
.set FUN_0048d12d, .text + (0x0048d12d - 0x401000)
.set FUN_0048e3ca, .text + (0x0048e3ca - 0x401000)
.set FUN_004a1d3a, .text + (0x004a1d3a - 0x401000)
.set FUN_004a3a33, .text + (0x004a3a33 - 0x401000)
.set FUN_004a64b9, .text + (0x004a64b9 - 0x401000)
.set FUN_004a7e50, .text + (0x004a7e50 - 0x401000)
.set FUN_004aa002, .text + (0x004aa002 - 0x401000)
.set FUN_004ab46d, .text + (0x004ab46d - 0x401000)
.set FUN_004acbf1, .text + (0x004acbf1 - 0x401000)
.set FUN_004afe09, .text + (0x004afe09 - 0x401000)
.set FUN_004b3ddf, .text + (0x004b3ddf - 0x401000)
.set FUN_004b5c5c, .text + (0x004b5c5c - 0x401000)
.set FUN_004b72cf, .text + (0x004b72cf - 0x401000)
.set FUN_004b80d9, .text + (0x004b80d9 - 0x401000)
.set FUN_004ba2bd, .text + (0x004ba2bd - 0x401000)
.set FUN_004bf8c2, .text + (0x004bf8c2 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004caff5, .text + (0x004caff5 - 0x401000)
.set FUN_004cd243, .text + (0x004cd243 - 0x401000)
.set FUN_004cd645, .text + (0x004cd645 - 0x401000)
.set FUN_004e9a2c, .text + (0x004e9a2c - 0x401000)
.set FUN_004e9add, .text + (0x004e9add - 0x401000)
.set FUN_004e9b87, .text + (0x004e9b87 - 0x401000)
.set FUN_004e9c2f, .text + (0x004e9c2f - 0x401000)
.set FUN_004e9cdf, .text + (0x004e9cdf - 0x401000)
.set FUN_004e9d8f, .text + (0x004e9d8f - 0x401000)
.set FUN_004fcda1, .text + (0x004fcda1 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0040b34a - 0x401000
.globl FUN_0040b34a
FUN_0040b34a:
    # block 0x0040b34a: entry, 10 instruction(s), ends with forward jump to 0x0040b37e
    push ebp                                     # 0040b34a
    {load} mov ebp, esp                          # 0040b34b
    sub esp, 0x23c                               # 0040b34d
    push esi                                     # 0040b353
    push edi                                     # 0040b354
    mov dword ptr [ebp - local_108], 0x1         # 0040b355
    movsx eax, word ptr [0x5c39e3]               # 0040b35f
    mov dword ptr [ebp - local_d0], eax          # 0040b366
    mov dword ptr [ebp - local_4], 0x0           # 0040b36c
    jmp.d8 L_0040b37e                            # 0040b373
L_0040b375:
    # block 0x0040b375: entered by jmp at 0x0040b3a9, 3 instruction(s), falls into the block at 0x0040b37e
    mov ecx, dword ptr [ebp - local_4]           # 0040b375
    add ecx, 0x1                                 # 0040b378
    mov dword ptr [ebp - local_4], ecx           # 0040b37b
L_0040b37e:
    # block 0x0040b37e: entered by jmp at 0x0040b373, 3 instruction(s), ends with jge to 0x0040b3ab (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040b37e
    cmp dword ptr [ebp - local_4], edx           # 0040b385
    jge.d8 L_0040b3ab                            # 0040b388
    # block 0x0040b38a: entered by fall-through of jge at 0x0040b388, 4 instruction(s), ends with je to 0x0040b3a9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0040b38a
    imul eax, eax, 0x8d                          # 0040b38d
    cmp dword ptr [eax + 0x5bb638], 0x0          # 0040b393
    je.d8 L_0040b3a9                             # 0040b39a
    # block 0x0040b39c: entered by fall-through of je at 0x0040b39a, 3 instruction(s), ends with forward jump to 0x0040b3ab
    mov cx, word ptr [ebp - local_4]             # 0040b39c
    mov word ptr [0x5c39e3], cx                  # 0040b3a0
    jmp.d8 L_0040b3ab                            # 0040b3a7
L_0040b3a9:
    # block 0x0040b3a9: entered by je at 0x0040b39a, 1 instruction(s), ends with backward jump to 0x0040b375
    jmp.d8 L_0040b375                            # 0040b3a9
L_0040b3ab:
    # block 0x0040b3ab: entered by jge at 0x0040b388; jmp at 0x0040b3a7, 37 instruction(s), ends with je to 0x0040b4ad (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0040b3ab
    add edx, 0x32                                # 0040b3ae
    mov dword ptr [ebp - local_20], edx          # 0040b3b1
    mov dword ptr [ebp - local_cc], 0x32         # 0040b3b4
    mov eax, dword ptr [ebp + arg_8]             # 0040b3be
    mov dword ptr [ebp - local_104], eax         # 0040b3c1
    mov edi, dword ptr [ebp - local_104]         # 0040b3c7
    movsx ecx, word ptr [0x5c39e3]               # 0040b3cd
    imul ecx, ecx, 0x8d                          # 0040b3d4
    add ecx, 0x5bb5b3                            # 0040b3da
    {load} mov edx, ecx                          # 0040b3e0
    or ecx, -0x1                                 # 0040b3e2
    {load} xor eax, eax                          # 0040b3e5
    repne scasb al, byte ptr es:[edi]            # 0040b3e7
    not ecx                                      # 0040b3e9
    {load} sub edi, ecx                          # 0040b3eb
    {load} mov esi, edi                          # 0040b3ed
    {load} mov eax, ecx                          # 0040b3ef
    {load} mov edi, edx                          # 0040b3f1
    shr ecx, 0x2                                 # 0040b3f3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040b3f6
    {load} mov ecx, eax                          # 0040b3f8
    and ecx, 0x3                                 # 0040b3fa
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040b3fd
    movsx ecx, word ptr [0x5c39e3]               # 0040b3ff
    imul ecx, ecx, 0x8d                          # 0040b406
    mov edx, dword ptr [ebp - local_104]         # 0040b40c
    mov al, byte ptr [edx + field_30]            # 0040b412
    mov byte ptr [ecx + 0x5bb5e3], al            # 0040b415
    movsx ecx, word ptr [0x5c39e3]               # 0040b41b
    imul ecx, ecx, 0x8d                          # 0040b422
    mov edx, dword ptr [ebp - local_104]         # 0040b428
    mov al, byte ptr [edx + field_31]            # 0040b42e
    mov byte ptr [ecx + 0x5bb5e4], al            # 0040b431
    movsx ecx, word ptr [0x63a4cd]               # 0040b437
    test ecx, ecx                                # 0040b43e
    je.d8 L_0040b4ad                             # 0040b440
    # block 0x0040b442: entered by fall-through of je at 0x0040b440, 25 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0040b4ad
    mov edx, dword ptr [ebp + arg_c]             # 0040b442
    push edx                                     # 0040b445
    movsx eax, word ptr [0x5c39e3]               # 0040b446
    imul eax, eax, 0x8d                          # 0040b44d
    {load} xor ecx, ecx                          # 0040b453
    mov cl, byte ptr [eax + 0x5bb5e4]            # 0040b455
    push ecx                                     # 0040b45b
    movsx edx, word ptr [0x5c39e3]               # 0040b45c
    imul edx, edx, 0x8d                          # 0040b463
    {load} xor eax, eax                          # 0040b469
    mov al, byte ptr [edx + 0x5bb5e3]            # 0040b46b
    push eax                                     # 0040b471
    movsx ecx, word ptr [0x5c39e3]               # 0040b472
    imul ecx, ecx, 0x8d                          # 0040b479
    add ecx, 0x5bb5b3                            # 0040b47f
    push ecx                                     # 0040b485
    movsx edx, word ptr [0x5c39e3]               # 0040b486
    push edx                                     # 0040b48d
    push 0x53ecf8                                # 0040b48e
    push 0x63888b                                # 0040b493
    call FUN_0050ca3e                            # 0040b498
    add esp, 0x1c                                # 0040b49d
    push 0x63888b                                # 0040b4a0
    call FUN_0044a2b7                            # 0040b4a5
    add esp, 0x4                                 # 0040b4aa
L_0040b4ad:
    # block 0x0040b4ad: entered by je at 0x0040b440, 11 instruction(s), ends with ja to 0x00410a22 (forward)
    mov dword ptr [ebp - local_f8], 0x1          # 0040b4ad
    movsx eax, word ptr [0x5c39e3]               # 0040b4b7
    imul eax, eax, 0x8d                          # 0040b4be
    {load} xor ecx, ecx                          # 0040b4c4
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0040b4c6
    mov dword ptr [ebp - local_238], ecx         # 0040b4cc
    mov edx, dword ptr [ebp - local_238]         # 0040b4d2
    sub edx, 0xa                                 # 0040b4d8
    mov dword ptr [ebp - local_238], edx         # 0040b4db
    cmp dword ptr [ebp - local_238], 0xec        # 0040b4e1
    ja.d32 L_00410a22                            # 0040b4eb
    # block 0x0040b4f1: entered by fall-through of ja at 0x0040b4eb, 4 instruction(s), ends with indirect jump dword ptr [4*eax + 0x410ca4]
    mov ecx, dword ptr [ebp - local_238]         # 0040b4f1
    {load} xor eax, eax                          # 0040b4f7
    mov al, byte ptr [ecx + IDXTAB_00410e9c_VA]  # 0040b4f9
    jmp dword ptr [4*eax + SWTAB_00410ca4_VA]    # 0040b4ff
L_0040b506:
    # block 0x0040b506: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040b57c (forward)
    push 0x28                                    # 0040b506
    call FUN_0051dc43                            # 0040b508
    add esp, 0x4                                 # 0040b50d
    mov dword ptr [ebp - local_14c], eax         # 0040b510
    movsx edx, word ptr [0x5c39e3]               # 0040b516
    imul edx, edx, 0x8d                          # 0040b51d
    mov eax, dword ptr [ebp - local_14c]         # 0040b523
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040b529
    cmp dword ptr [ebp - local_14c], 0x0         # 0040b52f
    jne.d8 L_0040b57c                            # 0040b536
    # block 0x0040b538: entered by fall-through of jne at 0x0040b536, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040b538
    push ecx                                     # 0040b53f
    mov edx, dword ptr [0x5bb57b]                # 0040b540
    push edx                                     # 0040b546
    push 0x53ed50                                # 0040b547
    push 0x63888b                                # 0040b54c
    call FUN_0050ca3e                            # 0040b551
    add esp, 0x10                                # 0040b556
    push 0x63888b                                # 0040b559
    push 0x53ed7c                                # 0040b55e
    mov ecx, 0x583979                            # 0040b563
    call FUN_0042639d                            # 0040b568
    mov ecx, 0x5cf659                            # 0040b56d
    call FUN_004c97b4                            # 0040b572
    jmp.d32 L_00410c9e                           # 0040b577
L_0040b57c:
    # block 0x0040b57c: entered by jne at 0x0040b536, 26 instruction(s), calls FUN_0040b2d0, ends with forward jump to 0x00410a68
    movsx eax, word ptr [0x5c39e3]               # 0040b57c
    imul eax, eax, 0x8d                          # 0040b583
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040b589
    add edi, 0x2                                 # 0040b58f
    mov ecx, 0x9                                 # 0040b592
    mov esi, dword ptr [ebp - local_20]          # 0040b597
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040b59a
    movsw word ptr es:[edi], word ptr [esi]      # 0040b59c
    movsx ecx, word ptr [0x5c39e3]               # 0040b59e
    imul ecx, ecx, 0x8d                          # 0040b5a5
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040b5ab
    push edx                                     # 0040b5b1
    call FUN_0040b2d0                            # 0040b5b2
    add esp, 0x4                                 # 0040b5b7
    movzx ax, al                                 # 0040b5ba
    movsx ecx, word ptr [0x5c39e3]               # 0040b5be
    imul ecx, ecx, 0x8d                          # 0040b5c5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b5cb
    mov word ptr [edx], ax                       # 0040b5d1
    mov eax, dword ptr [ebp - local_cc]          # 0040b5d4
    add eax, 0x26                                # 0040b5da
    mov dword ptr [ebp - local_cc], eax          # 0040b5dd
    mov ecx, dword ptr [ebp - local_20]          # 0040b5e3
    add ecx, 0x26                                # 0040b5e6
    mov dword ptr [ebp - local_20], ecx          # 0040b5e9
    jmp.d32 L_00410a68                           # 0040b5ec
L_0040b5f1:
    # block 0x0040b5f1: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040b667 (forward)
    push 0x28                                    # 0040b5f1
    call FUN_0051dc43                            # 0040b5f3
    add esp, 0x4                                 # 0040b5f8
    mov dword ptr [ebp - local_150], eax         # 0040b5fb
    movsx edx, word ptr [0x5c39e3]               # 0040b601
    imul edx, edx, 0x8d                          # 0040b608
    mov eax, dword ptr [ebp - local_150]         # 0040b60e
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040b614
    cmp dword ptr [ebp - local_150], 0x0         # 0040b61a
    jne.d8 L_0040b667                            # 0040b621
    # block 0x0040b623: entered by fall-through of jne at 0x0040b621, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040b623
    push ecx                                     # 0040b62a
    mov edx, dword ptr [0x5bb57b]                # 0040b62b
    push edx                                     # 0040b631
    push 0x53ed98                                # 0040b632
    push 0x63888b                                # 0040b637
    call FUN_0050ca3e                            # 0040b63c
    add esp, 0x10                                # 0040b641
    push 0x63888b                                # 0040b644
    push 0x53edc4                                # 0040b649
    mov ecx, 0x583979                            # 0040b64e
    call FUN_0042639d                            # 0040b653
    mov ecx, 0x5cf659                            # 0040b658
    call FUN_004c97b4                            # 0040b65d
    jmp.d32 L_00410c9e                           # 0040b662
L_0040b667:
    # block 0x0040b667: entered by jne at 0x0040b621, 71 instruction(s), calls FUN_0040b2d0, ends with forward jump to 0x00410a68
    movsx eax, word ptr [0x5c39e3]               # 0040b667
    imul eax, eax, 0x8d                          # 0040b66e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b674
    mov edx, dword ptr [ebp - local_20]          # 0040b67a
    mov ax, word ptr [edx + field_2]             # 0040b67d
    mov word ptr [ecx + field_2], ax             # 0040b681
    mov ecx, dword ptr [ebp - local_20]          # 0040b685
    add ecx, 0x4                                 # 0040b688
    movsx edx, word ptr [0x5c39e3]               # 0040b68b
    imul edx, edx, 0x8d                          # 0040b692
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b698
    add eax, 0x18                                # 0040b69e
    mov edx, dword ptr [ecx]                     # 0040b6a1
    mov dword ptr [eax], edx                     # 0040b6a3
    mov edx, dword ptr [ecx + field_4]           # 0040b6a5
    mov dword ptr [eax + field_4], edx           # 0040b6a8
    mov edx, dword ptr [ecx + field_8]           # 0040b6ab
    mov dword ptr [eax + field_8], edx           # 0040b6ae
    mov ecx, dword ptr [ecx + field_c]           # 0040b6b1
    mov dword ptr [eax + field_c], ecx           # 0040b6b4
    movsx edx, word ptr [0x5c39e3]               # 0040b6b7
    imul edx, edx, 0x8d                          # 0040b6be
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b6c4
    mov word ptr [eax + field_4], 0x0            # 0040b6ca
    movsx ecx, word ptr [0x5c39e3]               # 0040b6d0
    imul ecx, ecx, 0x8d                          # 0040b6d7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b6dd
    mov word ptr [edx + field_6], 0x0            # 0040b6e3
    movsx eax, word ptr [0x5c39e3]               # 0040b6e9
    imul eax, eax, 0x8d                          # 0040b6f0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b6f6
    mov dword ptr [ecx + field_a], 0x0           # 0040b6fc
    movsx edx, word ptr [0x5c39e3]               # 0040b703
    imul edx, edx, 0x8d                          # 0040b70a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b710
    mov dword ptr [eax + field_e], 0x0           # 0040b716
    movsx ecx, word ptr [0x5c39e3]               # 0040b71d
    imul ecx, ecx, 0x8d                          # 0040b724
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b72a
    mov dword ptr [edx + field_12], 0x1          # 0040b730
    movsx eax, word ptr [0x5c39e3]               # 0040b737
    imul eax, eax, 0x8d                          # 0040b73e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b744
    mov word ptr [ecx + field_8], 0x1            # 0040b74a
    movsx edx, word ptr [0x5c39e3]               # 0040b750
    imul edx, edx, 0x8d                          # 0040b757
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b75d
    mov word ptr [eax + field_16], 0x0           # 0040b763
    movsx ecx, word ptr [0x5c39e3]               # 0040b769
    imul ecx, ecx, 0x8d                          # 0040b770
    mov edx, dword ptr [ebp - local_20]          # 0040b776
    mov al, byte ptr [edx]                       # 0040b779
    mov byte ptr [ecx + 0x5bb5e3], al            # 0040b77b
    movsx ecx, word ptr [0x5c39e3]               # 0040b781
    imul ecx, ecx, 0x8d                          # 0040b788
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040b78e
    push edx                                     # 0040b794
    call FUN_0040b2d0                            # 0040b795
    add esp, 0x4                                 # 0040b79a
    movzx ax, al                                 # 0040b79d
    movsx ecx, word ptr [0x5c39e3]               # 0040b7a1
    imul ecx, ecx, 0x8d                          # 0040b7a8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b7ae
    mov word ptr [edx], ax                       # 0040b7b4
    mov eax, dword ptr [ebp - local_cc]          # 0040b7b7
    add eax, 0x14                                # 0040b7bd
    mov dword ptr [ebp - local_cc], eax          # 0040b7c0
    mov ecx, dword ptr [ebp - local_20]          # 0040b7c6
    add ecx, 0x14                                # 0040b7c9
    mov dword ptr [ebp - local_20], ecx          # 0040b7cc
    jmp.d32 L_00410a68                           # 0040b7cf
L_0040b7d4:
    # block 0x0040b7d4: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040b84a (forward)
    push 0x28                                    # 0040b7d4
    call FUN_0051dc43                            # 0040b7d6
    add esp, 0x4                                 # 0040b7db
    mov dword ptr [ebp - local_154], eax         # 0040b7de
    movsx edx, word ptr [0x5c39e3]               # 0040b7e4
    imul edx, edx, 0x8d                          # 0040b7eb
    mov eax, dword ptr [ebp - local_154]         # 0040b7f1
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040b7f7
    cmp dword ptr [ebp - local_154], 0x0         # 0040b7fd
    jne.d8 L_0040b84a                            # 0040b804
    # block 0x0040b806: entered by fall-through of jne at 0x0040b804, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040b806
    push ecx                                     # 0040b80d
    mov edx, dword ptr [0x5bb57b]                # 0040b80e
    push edx                                     # 0040b814
    push 0x53ede0                                # 0040b815
    push 0x63888b                                # 0040b81a
    call FUN_0050ca3e                            # 0040b81f
    add esp, 0x10                                # 0040b824
    push 0x63888b                                # 0040b827
    push 0x53ee0c                                # 0040b82c
    mov ecx, 0x583979                            # 0040b831
    call FUN_0042639d                            # 0040b836
    mov ecx, 0x5cf659                            # 0040b83b
    call FUN_004c97b4                            # 0040b840
    jmp.d32 L_00410c9e                           # 0040b845
L_0040b84a:
    # block 0x0040b84a: entered by jne at 0x0040b804, 65 instruction(s), ends with forward jump to 0x00410a68
    movsx eax, word ptr [0x5c39e3]               # 0040b84a
    imul eax, eax, 0x8d                          # 0040b851
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b857
    mov edx, dword ptr [ebp - local_20]          # 0040b85d
    mov ax, word ptr [edx]                       # 0040b860
    mov word ptr [ecx], ax                       # 0040b863
    movsx ecx, word ptr [0x5c39e3]               # 0040b866
    imul ecx, ecx, 0x8d                          # 0040b86d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b873
    mov eax, dword ptr [ebp - local_20]          # 0040b879
    mov cx, word ptr [eax + field_2]             # 0040b87c
    mov word ptr [edx + field_2], cx             # 0040b880
    movsx edx, word ptr [0x5c39e3]               # 0040b884
    imul edx, edx, 0x8d                          # 0040b88b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b891
    mov ecx, dword ptr [ebp - local_20]          # 0040b897
    mov dx, word ptr [ecx + field_4]             # 0040b89a
    mov word ptr [eax + field_4], dx             # 0040b89e
    movsx eax, word ptr [0x5c39e3]               # 0040b8a2
    imul eax, eax, 0x8d                          # 0040b8a9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b8af
    mov edx, dword ptr [ebp - local_20]          # 0040b8b5
    mov ax, word ptr [edx + field_6]             # 0040b8b8
    mov word ptr [ecx + field_8], ax             # 0040b8bc
    mov ecx, dword ptr [ebp - local_20]          # 0040b8c0
    add ecx, 0x8                                 # 0040b8c3
    movsx edx, word ptr [0x5c39e3]               # 0040b8c6
    imul edx, edx, 0x8d                          # 0040b8cd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b8d3
    add eax, 0x18                                # 0040b8d9
    mov edx, dword ptr [ecx]                     # 0040b8dc
    mov dword ptr [eax], edx                     # 0040b8de
    mov edx, dword ptr [ecx + field_4]           # 0040b8e0
    mov dword ptr [eax + field_4], edx           # 0040b8e3
    mov edx, dword ptr [ecx + field_8]           # 0040b8e6
    mov dword ptr [eax + field_8], edx           # 0040b8e9
    mov ecx, dword ptr [ecx + field_c]           # 0040b8ec
    mov dword ptr [eax + field_c], ecx           # 0040b8ef
    movsx edx, word ptr [0x5c39e3]               # 0040b8f2
    imul edx, edx, 0x8d                          # 0040b8f9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b8ff
    mov word ptr [eax + field_6], 0x0            # 0040b905
    movsx ecx, word ptr [0x5c39e3]               # 0040b90b
    imul ecx, ecx, 0x8d                          # 0040b912
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b918
    mov dword ptr [edx + field_a], 0x0           # 0040b91e
    movsx eax, word ptr [0x5c39e3]               # 0040b925
    imul eax, eax, 0x8d                          # 0040b92c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040b932
    mov dword ptr [ecx + field_e], 0x0           # 0040b938
    movsx edx, word ptr [0x5c39e3]               # 0040b93f
    imul edx, edx, 0x8d                          # 0040b946
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040b94c
    mov dword ptr [eax + field_12], 0x1          # 0040b952
    movsx ecx, word ptr [0x5c39e3]               # 0040b959
    imul ecx, ecx, 0x8d                          # 0040b960
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040b966
    mov word ptr [edx + field_16], 0x0           # 0040b96c
    mov eax, dword ptr [ebp - local_cc]          # 0040b972
    add eax, 0x18                                # 0040b978
    mov dword ptr [ebp - local_cc], eax          # 0040b97b
    mov ecx, dword ptr [ebp - local_20]          # 0040b981
    add ecx, 0x18                                # 0040b984
    mov dword ptr [ebp - local_20], ecx          # 0040b987
    jmp.d32 L_00410a68                           # 0040b98a
L_0040b98f:
    # block 0x0040b98f: entered by switch case, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ba24 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0040b98f
    mov dword ptr [ebp - local_14], edx          # 0040b992
    mov eax, dword ptr [ebp - local_14]          # 0040b995
    movsx ecx, word ptr [eax + field_14]         # 0040b998
    imul ecx, ecx, 0x12                          # 0040b99c
    add ecx, 0x16                                # 0040b99f
    mov word ptr [ebp - local_118], cx           # 0040b9a2
    movsx edx, word ptr [ebp - local_118]        # 0040b9a9
    push edx                                     # 0040b9b0
    call FUN_0051dc43                            # 0040b9b1
    add esp, 0x4                                 # 0040b9b6
    mov dword ptr [ebp - local_158], eax         # 0040b9b9
    movsx eax, word ptr [0x5c39e3]               # 0040b9bf
    imul eax, eax, 0x8d                          # 0040b9c6
    mov ecx, dword ptr [ebp - local_158]         # 0040b9cc
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040b9d2
    cmp dword ptr [ebp - local_158], 0x0         # 0040b9d8
    jne.d8 L_0040ba24                            # 0040b9df
    # block 0x0040b9e1: entered by fall-through of jne at 0x0040b9df, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040b9e1
    push edx                                     # 0040b9e8
    mov eax, dword ptr [0x5bb57b]                # 0040b9e9
    push eax                                     # 0040b9ee
    push 0x53ee28                                # 0040b9ef
    push 0x63888b                                # 0040b9f4
    call FUN_0050ca3e                            # 0040b9f9
    add esp, 0x10                                # 0040b9fe
    push 0x63888b                                # 0040ba01
    push 0x53ee54                                # 0040ba06
    mov ecx, 0x583979                            # 0040ba0b
    call FUN_0042639d                            # 0040ba10
    mov ecx, 0x5cf659                            # 0040ba15
    call FUN_004c97b4                            # 0040ba1a
    jmp.d32 L_00410c9e                           # 0040ba1f
L_0040ba24:
    # block 0x0040ba24: entered by jne at 0x0040b9df, 22 instruction(s), ends with je to 0x0040baf8 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040ba24
    mov esi, dword ptr [ebp - local_20]          # 0040ba2b
    movsx edx, word ptr [0x5c39e3]               # 0040ba2e
    imul edx, edx, 0x8d                          # 0040ba35
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040ba3b
    {load} mov eax, ecx                          # 0040ba41
    shr ecx, 0x2                                 # 0040ba43
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ba46
    {load} mov ecx, eax                          # 0040ba48
    and ecx, 0x3                                 # 0040ba4a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040ba4d
    movsx ecx, word ptr [ebp - local_118]        # 0040ba4f
    mov edx, dword ptr [ebp - local_cc]          # 0040ba56
    {load} add edx, ecx                          # 0040ba5c
    mov dword ptr [ebp - local_cc], edx          # 0040ba5e
    movsx eax, word ptr [ebp - local_118]        # 0040ba64
    mov ecx, dword ptr [ebp - local_20]          # 0040ba6b
    {load} add ecx, eax                          # 0040ba6e
    mov dword ptr [ebp - local_20], ecx          # 0040ba70
    movsx edx, word ptr [0x63a4cd]               # 0040ba73
    test edx, edx                                # 0040ba7a
    je.d8 L_0040baf8                             # 0040ba7c
    # block 0x0040ba7e: entered by fall-through of je at 0x0040ba7c, 10 instruction(s), ends with ja to 0x0040baf8 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040ba7e
    imul eax, eax, 0x8d                          # 0040ba85
    {load} xor ecx, ecx                          # 0040ba8b
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0040ba8d
    mov dword ptr [ebp - local_23c], ecx         # 0040ba93
    mov edx, dword ptr [ebp - local_23c]         # 0040ba99
    sub edx, 0x16                                # 0040ba9f
    mov dword ptr [ebp - local_23c], edx         # 0040baa2
    cmp dword ptr [ebp - local_23c], 0x3         # 0040baa8
    ja.d8 L_0040baf8                             # 0040baaf
    # block 0x0040bab1: entered by fall-through of ja at 0x0040baaf, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x410f89]
    mov eax, dword ptr [ebp - local_23c]         # 0040bab1
    jmp dword ptr [4*eax + SWTAB_00410f89_VA]    # 0040bab7
L_0040babe:
    # block 0x0040babe: entered by switch case, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x0040baf8
    push 0x53ee70                                # 0040babe
    call FUN_0044a2b7                            # 0040bac3
    add esp, 0x4                                 # 0040bac8
    jmp.d8 L_0040baf8                            # 0040bacb
L_0040bacd:
    # block 0x0040bacd: entered by switch case, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x0040baf8
    push 0x53eeb0                                # 0040bacd
    call FUN_0044a2b7                            # 0040bad2
    add esp, 0x4                                 # 0040bad7
    jmp.d8 L_0040baf8                            # 0040bada
L_0040badc:
    # block 0x0040badc: entered by switch case, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x0040baf8
    push 0x53eef8                                # 0040badc
    call FUN_0044a2b7                            # 0040bae1
    add esp, 0x4                                 # 0040bae6
    jmp.d8 L_0040baf8                            # 0040bae9
L_0040baeb:
    # block 0x0040baeb: entered by switch case, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040baf8
    push 0x53ef3c                                # 0040baeb
    call FUN_0044a2b7                            # 0040baf0
    add esp, 0x4                                 # 0040baf5
L_0040baf8:
    # block 0x0040baf8: entered by je at 0x0040ba7c; ja at 0x0040baaf; jmp at 0x0040bacb; jmp at 0x0040bada; more, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040baf8
L_0040bafd:
    # block 0x0040bafd: entered by switch case, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040bb99 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0040bafd
    mov dword ptr [ebp - local_bc], ecx          # 0040bb00
    mov edx, dword ptr [ebp - local_bc]          # 0040bb06
    movsx eax, word ptr [edx + field_8]          # 0040bb0c
    imul eax, eax, 0x12                          # 0040bb10
    add eax, 0xa                                 # 0040bb13
    mov word ptr [ebp - local_118], ax           # 0040bb16
    movsx ecx, word ptr [ebp - local_118]        # 0040bb1d
    push ecx                                     # 0040bb24
    call FUN_0051dc43                            # 0040bb25
    add esp, 0x4                                 # 0040bb2a
    mov dword ptr [ebp - local_15c], eax         # 0040bb2d
    movsx edx, word ptr [0x5c39e3]               # 0040bb33
    imul edx, edx, 0x8d                          # 0040bb3a
    mov eax, dword ptr [ebp - local_15c]         # 0040bb40
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040bb46
    cmp dword ptr [ebp - local_15c], 0x0         # 0040bb4c
    jne.d8 L_0040bb99                            # 0040bb53
    # block 0x0040bb55: entered by fall-through of jne at 0x0040bb53, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040bb55
    push ecx                                     # 0040bb5c
    mov edx, dword ptr [0x5bb57b]                # 0040bb5d
    push edx                                     # 0040bb63
    push 0x53ef7c                                # 0040bb64
    push 0x63888b                                # 0040bb69
    call FUN_0050ca3e                            # 0040bb6e
    add esp, 0x10                                # 0040bb73
    push 0x63888b                                # 0040bb76
    push 0x53efa8                                # 0040bb7b
    mov ecx, 0x583979                            # 0040bb80
    call FUN_0042639d                            # 0040bb85
    mov ecx, 0x5cf659                            # 0040bb8a
    call FUN_004c97b4                            # 0040bb8f
    jmp.d32 L_00410c9e                           # 0040bb94
L_0040bb99:
    # block 0x0040bb99: entered by jne at 0x0040bb53, 20 instruction(s), ends with forward jump to 0x00410a68
    movsx ecx, word ptr [ebp - local_118]        # 0040bb99
    mov esi, dword ptr [ebp - local_20]          # 0040bba0
    movsx eax, word ptr [0x5c39e3]               # 0040bba3
    imul eax, eax, 0x8d                          # 0040bbaa
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040bbb0
    {load} mov edx, ecx                          # 0040bbb6
    shr ecx, 0x2                                 # 0040bbb8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040bbbb
    {load} mov ecx, edx                          # 0040bbbd
    and ecx, 0x3                                 # 0040bbbf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040bbc2
    movsx eax, word ptr [ebp - local_118]        # 0040bbc4
    mov ecx, dword ptr [ebp - local_cc]          # 0040bbcb
    {load} add ecx, eax                          # 0040bbd1
    mov dword ptr [ebp - local_cc], ecx          # 0040bbd3
    movsx edx, word ptr [ebp - local_118]        # 0040bbd9
    mov eax, dword ptr [ebp - local_20]          # 0040bbe0
    {load} add eax, edx                          # 0040bbe3
    mov dword ptr [ebp - local_20], eax          # 0040bbe5
    jmp.d32 L_00410a68                           # 0040bbe8
L_0040bbed:
    # block 0x0040bbed: entered by switch case, 11 instruction(s), calls FUN_00414692, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040bbed
    push ecx                                     # 0040bbf3
    lea edx, [ebp - local_20]                    # 0040bbf4
    push edx                                     # 0040bbf7
    movsx eax, word ptr [0x5c39e3]               # 0040bbf8
    imul eax, eax, 0x8d                          # 0040bbff
    add eax, 0x5bb5e5                            # 0040bc05
    push eax                                     # 0040bc0a
    mov ecx, 0x6385db                            # 0040bc0b
    call FUN_00414692                            # 0040bc10
    jmp.d32 L_00410a68                           # 0040bc15
L_0040bc1a:
    # block 0x0040bc1a: entered by switch case, 11 instruction(s), calls FUN_004caff5, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040bc1a
    push ecx                                     # 0040bc20
    lea edx, [ebp - local_20]                    # 0040bc21
    push edx                                     # 0040bc24
    movsx eax, word ptr [0x5c39e3]               # 0040bc25
    imul eax, eax, 0x8d                          # 0040bc2c
    add eax, 0x5bb5e5                            # 0040bc32
    push eax                                     # 0040bc37
    mov ecx, 0x63847b                            # 0040bc38
    call FUN_004caff5                            # 0040bc3d
    jmp.d32 L_00410a68                           # 0040bc42
L_0040bc47:
    # block 0x0040bc47: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040bcbd (forward)
    push 0x8                                     # 0040bc47
    call FUN_0051dc43                            # 0040bc49
    add esp, 0x4                                 # 0040bc4e
    mov dword ptr [ebp - local_160], eax         # 0040bc51
    movsx ecx, word ptr [0x5c39e3]               # 0040bc57
    imul ecx, ecx, 0x8d                          # 0040bc5e
    mov edx, dword ptr [ebp - local_160]         # 0040bc64
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040bc6a
    cmp dword ptr [ebp - local_160], 0x0         # 0040bc70
    jne.d8 L_0040bcbd                            # 0040bc77
    # block 0x0040bc79: entered by fall-through of jne at 0x0040bc77, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040bc79
    push eax                                     # 0040bc80
    mov ecx, dword ptr [0x5bb57b]                # 0040bc81
    push ecx                                     # 0040bc87
    push 0x53efc4                                # 0040bc88
    push 0x63888b                                # 0040bc8d
    call FUN_0050ca3e                            # 0040bc92
    add esp, 0x10                                # 0040bc97
    push 0x63888b                                # 0040bc9a
    push 0x53eff0                                # 0040bc9f
    mov ecx, 0x583979                            # 0040bca4
    call FUN_0042639d                            # 0040bca9
    mov ecx, 0x5cf659                            # 0040bcae
    call FUN_004c97b4                            # 0040bcb3
    jmp.d32 L_00410c9e                           # 0040bcb8
L_0040bcbd:
    # block 0x0040bcbd: entered by jne at 0x0040bc77, 17 instruction(s), ends with je to 0x0040bd0d (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040bcbd
    imul edx, edx, 0x8d                          # 0040bcc4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040bcca
    mov ecx, dword ptr [ebp - local_20]          # 0040bcd0
    mov edx, dword ptr [ecx]                     # 0040bcd3
    mov dword ptr [eax], edx                     # 0040bcd5
    mov ecx, dword ptr [ecx + field_4]           # 0040bcd7
    mov dword ptr [eax + field_4], ecx           # 0040bcda
    mov edx, dword ptr [ebp - local_cc]          # 0040bcdd
    add edx, 0x8                                 # 0040bce3
    mov dword ptr [ebp - local_cc], edx          # 0040bce6
    mov eax, dword ptr [ebp - local_20]          # 0040bcec
    add eax, 0x8                                 # 0040bcef
    mov dword ptr [ebp - local_20], eax          # 0040bcf2
    movsx ecx, word ptr [0x63a4cd]               # 0040bcf5
    test ecx, ecx                                # 0040bcfc
    je.d8 L_0040bd0d                             # 0040bcfe
    # block 0x0040bd00: entered by fall-through of je at 0x0040bcfe, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040bd0d
    push 0x53f00c                                # 0040bd00
    call FUN_0044a2b7                            # 0040bd05
    add esp, 0x4                                 # 0040bd0a
L_0040bd0d:
    # block 0x0040bd0d: entered by je at 0x0040bcfe, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040bd0d
L_0040bd12:
    # block 0x0040bd12: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040bd88 (forward)
    push 0x8                                     # 0040bd12
    call FUN_0051dc43                            # 0040bd14
    add esp, 0x4                                 # 0040bd19
    mov dword ptr [ebp - local_164], eax         # 0040bd1c
    movsx edx, word ptr [0x5c39e3]               # 0040bd22
    imul edx, edx, 0x8d                          # 0040bd29
    mov eax, dword ptr [ebp - local_164]         # 0040bd2f
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040bd35
    cmp dword ptr [ebp - local_164], 0x0         # 0040bd3b
    jne.d8 L_0040bd88                            # 0040bd42
    # block 0x0040bd44: entered by fall-through of jne at 0x0040bd42, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040bd44
    push ecx                                     # 0040bd4b
    mov edx, dword ptr [0x5bb57b]                # 0040bd4c
    push edx                                     # 0040bd52
    push 0x53f038                                # 0040bd53
    push 0x63888b                                # 0040bd58
    call FUN_0050ca3e                            # 0040bd5d
    add esp, 0x10                                # 0040bd62
    push 0x63888b                                # 0040bd65
    push 0x53f064                                # 0040bd6a
    mov ecx, 0x583979                            # 0040bd6f
    call FUN_0042639d                            # 0040bd74
    mov ecx, 0x5cf659                            # 0040bd79
    call FUN_004c97b4                            # 0040bd7e
    jmp.d32 L_00410c9e                           # 0040bd83
L_0040bd88:
    # block 0x0040bd88: entered by jne at 0x0040bd42, 17 instruction(s), ends with je to 0x0040bdd8 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040bd88
    imul eax, eax, 0x8d                          # 0040bd8f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040bd95
    mov edx, dword ptr [ebp - local_20]          # 0040bd9b
    mov eax, dword ptr [edx]                     # 0040bd9e
    mov dword ptr [ecx], eax                     # 0040bda0
    mov edx, dword ptr [edx + field_4]           # 0040bda2
    mov dword ptr [ecx + field_4], edx           # 0040bda5
    mov eax, dword ptr [ebp - local_cc]          # 0040bda8
    add eax, 0x8                                 # 0040bdae
    mov dword ptr [ebp - local_cc], eax          # 0040bdb1
    mov ecx, dword ptr [ebp - local_20]          # 0040bdb7
    add ecx, 0x8                                 # 0040bdba
    mov dword ptr [ebp - local_20], ecx          # 0040bdbd
    movsx edx, word ptr [0x63a4cd]               # 0040bdc0
    test edx, edx                                # 0040bdc7
    je.d8 L_0040bdd8                             # 0040bdc9
    # block 0x0040bdcb: entered by fall-through of je at 0x0040bdc9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040bdd8
    push 0x53f080                                # 0040bdcb
    call FUN_0044a2b7                            # 0040bdd0
    add esp, 0x4                                 # 0040bdd5
L_0040bdd8:
    # block 0x0040bdd8: entered by je at 0x0040bdc9, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040bdd8
L_0040bddd:
    # block 0x0040bddd: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040be52 (forward)
    push 0x14                                    # 0040bddd
    call FUN_0051dc43                            # 0040bddf
    add esp, 0x4                                 # 0040bde4
    mov dword ptr [ebp - local_168], eax         # 0040bde7
    movsx eax, word ptr [0x5c39e3]               # 0040bded
    imul eax, eax, 0x8d                          # 0040bdf4
    mov ecx, dword ptr [ebp - local_168]         # 0040bdfa
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040be00
    cmp dword ptr [ebp - local_168], 0x0         # 0040be06
    jne.d8 L_0040be52                            # 0040be0d
    # block 0x0040be0f: entered by fall-through of jne at 0x0040be0d, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040be0f
    push edx                                     # 0040be16
    mov eax, dword ptr [0x5bb57b]                # 0040be17
    push eax                                     # 0040be1c
    push 0x53f0b0                                # 0040be1d
    push 0x63888b                                # 0040be22
    call FUN_0050ca3e                            # 0040be27
    add esp, 0x10                                # 0040be2c
    push 0x63888b                                # 0040be2f
    push 0x53f0dc                                # 0040be34
    mov ecx, 0x583979                            # 0040be39
    call FUN_0042639d                            # 0040be3e
    mov ecx, 0x5cf659                            # 0040be43
    call FUN_004c97b4                            # 0040be48
    jmp.d32 L_00410c9e                           # 0040be4d
L_0040be52:
    # block 0x0040be52: entered by jne at 0x0040be0d, 15 instruction(s), ends with je to 0x0040be9f (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040be52
    imul ecx, ecx, 0x8d                          # 0040be59
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040be5f
    mov ecx, 0x5                                 # 0040be65
    mov esi, dword ptr [ebp - local_20]          # 0040be6a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040be6d
    mov edx, dword ptr [ebp - local_cc]          # 0040be6f
    add edx, 0x14                                # 0040be75
    mov dword ptr [ebp - local_cc], edx          # 0040be78
    mov eax, dword ptr [ebp - local_20]          # 0040be7e
    add eax, 0x14                                # 0040be81
    mov dword ptr [ebp - local_20], eax          # 0040be84
    movsx ecx, word ptr [0x63a4cd]               # 0040be87
    test ecx, ecx                                # 0040be8e
    je.d8 L_0040be9f                             # 0040be90
    # block 0x0040be92: entered by fall-through of je at 0x0040be90, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040be9f
    push 0x53f0f8                                # 0040be92
    call FUN_0044a2b7                            # 0040be97
    add esp, 0x4                                 # 0040be9c
L_0040be9f:
    # block 0x0040be9f: entered by je at 0x0040be90, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040be9f
L_0040bea4:
    # block 0x0040bea4: entered by switch case, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040bf3f (forward)
    mov edx, dword ptr [ebp - local_20]          # 0040bea4
    mov dword ptr [ebp - local_c4], edx          # 0040bea7
    mov eax, dword ptr [ebp - local_c4]          # 0040bead
    movsx ecx, word ptr [eax + field_32]         # 0040beb3
    imul ecx, ecx, 0x12                          # 0040beb7
    add ecx, 0x34                                # 0040beba
    mov word ptr [ebp - local_118], cx           # 0040bebd
    movsx edx, word ptr [ebp - local_118]        # 0040bec4
    push edx                                     # 0040becb
    call FUN_0051dc43                            # 0040becc
    add esp, 0x4                                 # 0040bed1
    mov dword ptr [ebp - local_16c], eax         # 0040bed4
    movsx eax, word ptr [0x5c39e3]               # 0040beda
    imul eax, eax, 0x8d                          # 0040bee1
    mov ecx, dword ptr [ebp - local_16c]         # 0040bee7
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040beed
    cmp dword ptr [ebp - local_16c], 0x0         # 0040bef3
    jne.d8 L_0040bf3f                            # 0040befa
    # block 0x0040befc: entered by fall-through of jne at 0x0040befa, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040befc
    push edx                                     # 0040bf03
    mov eax, dword ptr [0x5bb57b]                # 0040bf04
    push eax                                     # 0040bf09
    push 0x53f128                                # 0040bf0a
    push 0x63888b                                # 0040bf0f
    call FUN_0050ca3e                            # 0040bf14
    add esp, 0x10                                # 0040bf19
    push 0x63888b                                # 0040bf1c
    push 0x53f154                                # 0040bf21
    mov ecx, 0x583979                            # 0040bf26
    call FUN_0042639d                            # 0040bf2b
    mov ecx, 0x5cf659                            # 0040bf30
    call FUN_004c97b4                            # 0040bf35
    jmp.d32 L_00410c9e                           # 0040bf3a
L_0040bf3f:
    # block 0x0040bf3f: entered by jne at 0x0040befa, 22 instruction(s), ends with je to 0x0040bfa6 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040bf3f
    mov esi, dword ptr [ebp - local_20]          # 0040bf46
    movsx edx, word ptr [0x5c39e3]               # 0040bf49
    imul edx, edx, 0x8d                          # 0040bf50
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040bf56
    {load} mov eax, ecx                          # 0040bf5c
    shr ecx, 0x2                                 # 0040bf5e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040bf61
    {load} mov ecx, eax                          # 0040bf63
    and ecx, 0x3                                 # 0040bf65
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040bf68
    movsx ecx, word ptr [ebp - local_118]        # 0040bf6a
    mov edx, dword ptr [ebp - local_cc]          # 0040bf71
    {load} add edx, ecx                          # 0040bf77
    mov dword ptr [ebp - local_cc], edx          # 0040bf79
    movsx eax, word ptr [ebp - local_118]        # 0040bf7f
    mov ecx, dword ptr [ebp - local_20]          # 0040bf86
    {load} add ecx, eax                          # 0040bf89
    mov dword ptr [ebp - local_20], ecx          # 0040bf8b
    movsx edx, word ptr [0x63a4cd]               # 0040bf8e
    test edx, edx                                # 0040bf95
    je.d8 L_0040bfa6                             # 0040bf97
    # block 0x0040bf99: entered by fall-through of je at 0x0040bf97, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040bfa6
    push 0x53f170                                # 0040bf99
    call FUN_0044a2b7                            # 0040bf9e
    add esp, 0x4                                 # 0040bfa3
L_0040bfa6:
    # block 0x0040bfa6: entered by je at 0x0040bf97, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040bfa6
L_0040bfab:
    # block 0x0040bfab: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040c020 (forward)
    push 0x1                                     # 0040bfab
    call FUN_0051dc43                            # 0040bfad
    add esp, 0x4                                 # 0040bfb2
    mov dword ptr [ebp - local_170], eax         # 0040bfb5
    movsx eax, word ptr [0x5c39e3]               # 0040bfbb
    imul eax, eax, 0x8d                          # 0040bfc2
    mov ecx, dword ptr [ebp - local_170]         # 0040bfc8
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040bfce
    cmp dword ptr [ebp - local_170], 0x0         # 0040bfd4
    jne.d8 L_0040c020                            # 0040bfdb
    # block 0x0040bfdd: entered by fall-through of jne at 0x0040bfdb, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040bfdd
    push edx                                     # 0040bfe4
    mov eax, dword ptr [0x5bb57b]                # 0040bfe5
    push eax                                     # 0040bfea
    push 0x53f1b4                                # 0040bfeb
    push 0x63888b                                # 0040bff0
    call FUN_0050ca3e                            # 0040bff5
    add esp, 0x10                                # 0040bffa
    push 0x63888b                                # 0040bffd
    push 0x53f1e0                                # 0040c002
    mov ecx, 0x583979                            # 0040c007
    call FUN_0042639d                            # 0040c00c
    mov ecx, 0x5cf659                            # 0040c011
    call FUN_004c97b4                            # 0040c016
    jmp.d32 L_00410c9e                           # 0040c01b
L_0040c020:
    # block 0x0040c020: entered by jne at 0x0040bfdb, 15 instruction(s), ends with je to 0x0040c0ad (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040c020
    imul ecx, ecx, 0x8d                          # 0040c027
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040c02d
    mov eax, dword ptr [ebp - local_20]          # 0040c033
    mov cl, byte ptr [eax]                       # 0040c036
    mov byte ptr [edx], cl                       # 0040c038
    mov edx, dword ptr [ebp - local_cc]          # 0040c03a
    add edx, 0x1                                 # 0040c040
    mov dword ptr [ebp - local_cc], edx          # 0040c043
    mov eax, dword ptr [ebp - local_20]          # 0040c049
    add eax, 0x1                                 # 0040c04c
    mov dword ptr [ebp - local_20], eax          # 0040c04f
    movsx ecx, word ptr [0x63a4cd]               # 0040c052
    test ecx, ecx                                # 0040c059
    je.d8 L_0040c0ad                             # 0040c05b
    # block 0x0040c05d: entered by fall-through of je at 0x0040c05b, 6 instruction(s), ends with jne to 0x0040c086 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040c05d
    imul edx, edx, 0x8d                          # 0040c064
    {load} xor eax, eax                          # 0040c06a
    mov al, byte ptr [edx + 0x5bb5e3]            # 0040c06c
    cmp eax, 0x1e                                # 0040c072
    jne.d8 L_0040c086                            # 0040c075
    # block 0x0040c077: entered by fall-through of jne at 0x0040c075, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x0040c0ad
    push 0x53f1fc                                # 0040c077
    call FUN_0044a2b7                            # 0040c07c
    add esp, 0x4                                 # 0040c081
    jmp.d8 L_0040c0ad                            # 0040c084
L_0040c086:
    # block 0x0040c086: entered by jne at 0x0040c075, 6 instruction(s), ends with jne to 0x0040c0ad (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040c086
    imul ecx, ecx, 0x8d                          # 0040c08d
    {load} xor edx, edx                          # 0040c093
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040c095
    cmp edx, 0x1f                                # 0040c09b
    jne.d8 L_0040c0ad                            # 0040c09e
    # block 0x0040c0a0: entered by fall-through of jne at 0x0040c09e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c0ad
    push 0x53f234                                # 0040c0a0
    call FUN_0044a2b7                            # 0040c0a5
    add esp, 0x4                                 # 0040c0aa
L_0040c0ad:
    # block 0x0040c0ad: entered by je at 0x0040c05b; jmp at 0x0040c084; jne at 0x0040c09e, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040c0ad
L_0040c0b2:
    # block 0x0040c0b2: entered by switch case, 11 instruction(s), calls FUN_004471ca, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c0b2
    push eax                                     # 0040c0b8
    lea ecx, [ebp - local_20]                    # 0040c0b9
    push ecx                                     # 0040c0bc
    movsx edx, word ptr [0x5c39e3]               # 0040c0bd
    imul edx, edx, 0x8d                          # 0040c0c4
    add edx, 0x5bb5e5                            # 0040c0ca
    push edx                                     # 0040c0d0
    mov ecx, 0x6198d7                            # 0040c0d1
    call FUN_004471ca                            # 0040c0d6
    jmp.d32 L_00410a68                           # 0040c0db
L_0040c0e0:
    # block 0x0040c0e0: entered by switch case, 12 instruction(s), calls FUN_004cd243, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c0e0
    push eax                                     # 0040c0e6
    lea ecx, [ebp - local_20]                    # 0040c0e7
    push ecx                                     # 0040c0ea
    movsx edx, word ptr [0x5c39e3]               # 0040c0eb
    imul edx, edx, 0x8d                          # 0040c0f2
    add edx, 0x5bb5e5                            # 0040c0f8
    push edx                                     # 0040c0fe
    mov ecx, 0x63821d                            # 0040c0ff
    call FUN_004cd243                            # 0040c104
    mov dword ptr [ebp - local_108], eax         # 0040c109
    jmp.d32 L_00410a68                           # 0040c10f
L_0040c114:
    # block 0x0040c114: entered by switch case, 11 instruction(s), calls FUN_004cd645, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c114
    push eax                                     # 0040c11a
    lea ecx, [ebp - local_20]                    # 0040c11b
    push ecx                                     # 0040c11e
    movsx edx, word ptr [0x5c39e3]               # 0040c11f
    imul edx, edx, 0x8d                          # 0040c126
    add edx, 0x5bb5e5                            # 0040c12c
    push edx                                     # 0040c132
    mov ecx, 0x63821d                            # 0040c133
    call FUN_004cd645                            # 0040c138
    jmp.d32 L_00410a68                           # 0040c13d
L_0040c142:
    # block 0x0040c142: entered by switch case, 15 instruction(s), calls FUN_0041c7f4, ends with forward jump to 0x00410a68
    movsx eax, word ptr [0x5c39e3]               # 0040c142
    imul eax, eax, 0x8d                          # 0040c149
    movzx cx, byte ptr [eax + 0x5bb5e3]          # 0040c14f
    push ecx                                     # 0040c157
    lea edx, [ebp - local_cc]                    # 0040c158
    push edx                                     # 0040c15e
    lea eax, [ebp - local_20]                    # 0040c15f
    push eax                                     # 0040c162
    movsx ecx, word ptr [0x5c39e3]               # 0040c163
    imul ecx, ecx, 0x8d                          # 0040c16a
    add ecx, 0x5bb5e5                            # 0040c170
    push ecx                                     # 0040c176
    mov ecx, 0x6177e8                            # 0040c177
    call FUN_0041c7f4                            # 0040c17c
    jmp.d32 L_00410a68                           # 0040c181
L_0040c186:
    # block 0x0040c186: entered by switch case, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040c22f (forward)
    mov edx, dword ptr [ebp - local_20]          # 0040c186
    mov dword ptr [ebp - local_134], edx         # 0040c189
    mov eax, dword ptr [ebp - local_134]         # 0040c18f
    movsx ecx, word ptr [eax + field_6d]         # 0040c195
    imul ecx, ecx, 0x6                           # 0040c199
    mov edx, dword ptr [ebp - local_134]         # 0040c19c
    movsx eax, word ptr [edx + field_6f]         # 0040c1a2
    imul eax, eax, 0x42                          # 0040c1a6
    lea ecx, [ecx + eax + field_71]              # 0040c1a9
    mov word ptr [ebp - local_118], cx           # 0040c1ad
    movsx edx, word ptr [ebp - local_118]        # 0040c1b4
    push edx                                     # 0040c1bb
    call FUN_0051dc43                            # 0040c1bc
    add esp, 0x4                                 # 0040c1c1
    mov dword ptr [ebp - local_174], eax         # 0040c1c4
    movsx eax, word ptr [0x5c39e3]               # 0040c1ca
    imul eax, eax, 0x8d                          # 0040c1d1
    mov ecx, dword ptr [ebp - local_174]         # 0040c1d7
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040c1dd
    cmp dword ptr [ebp - local_174], 0x0         # 0040c1e3
    jne.d8 L_0040c22f                            # 0040c1ea
    # block 0x0040c1ec: entered by fall-through of jne at 0x0040c1ea, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040c1ec
    push edx                                     # 0040c1f3
    mov eax, dword ptr [0x5bb57b]                # 0040c1f4
    push eax                                     # 0040c1f9
    push 0x53f270                                # 0040c1fa
    push 0x63888b                                # 0040c1ff
    call FUN_0050ca3e                            # 0040c204
    add esp, 0x10                                # 0040c209
    push 0x63888b                                # 0040c20c
    push 0x53f29c                                # 0040c211
    mov ecx, 0x583979                            # 0040c216
    call FUN_0042639d                            # 0040c21b
    mov ecx, 0x5cf659                            # 0040c220
    call FUN_004c97b4                            # 0040c225
    jmp.d32 L_00410c9e                           # 0040c22a
L_0040c22f:
    # block 0x0040c22f: entered by jne at 0x0040c1ea, 22 instruction(s), ends with je to 0x0040c296 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040c22f
    mov esi, dword ptr [ebp - local_20]          # 0040c236
    movsx edx, word ptr [0x5c39e3]               # 0040c239
    imul edx, edx, 0x8d                          # 0040c240
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040c246
    {load} mov eax, ecx                          # 0040c24c
    shr ecx, 0x2                                 # 0040c24e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040c251
    {load} mov ecx, eax                          # 0040c253
    and ecx, 0x3                                 # 0040c255
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040c258
    movsx ecx, word ptr [ebp - local_118]        # 0040c25a
    mov edx, dword ptr [ebp - local_cc]          # 0040c261
    {load} add edx, ecx                          # 0040c267
    mov dword ptr [ebp - local_cc], edx          # 0040c269
    movsx eax, word ptr [ebp - local_118]        # 0040c26f
    mov ecx, dword ptr [ebp - local_20]          # 0040c276
    {load} add ecx, eax                          # 0040c279
    mov dword ptr [ebp - local_20], ecx          # 0040c27b
    movsx edx, word ptr [0x63a4cd]               # 0040c27e
    test edx, edx                                # 0040c285
    je.d8 L_0040c296                             # 0040c287
    # block 0x0040c289: entered by fall-through of je at 0x0040c287, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c296
    push 0x53f2b8                                # 0040c289
    call FUN_0044a2b7                            # 0040c28e
    add esp, 0x4                                 # 0040c293
L_0040c296:
    # block 0x0040c296: entered by je at 0x0040c287, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040c296
L_0040c29b:
    # block 0x0040c29b: entered by switch case, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040c33c (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040c29b
    mov dword ptr [ebp - local_4c], eax          # 0040c29e
    mov ecx, dword ptr [ebp - local_4c]          # 0040c2a1
    movsx edx, word ptr [ecx + field_6d]         # 0040c2a4
    imul edx, edx, 0x6                           # 0040c2a8
    mov eax, dword ptr [ebp - local_4c]          # 0040c2ab
    movsx ecx, word ptr [eax + field_6f]         # 0040c2ae
    imul ecx, ecx, 0x42                          # 0040c2b2
    lea edx, [edx + ecx + field_71]              # 0040c2b5
    mov word ptr [ebp - local_118], dx           # 0040c2b9
    movsx eax, word ptr [ebp - local_118]        # 0040c2c0
    push eax                                     # 0040c2c7
    call FUN_0051dc43                            # 0040c2c8
    add esp, 0x4                                 # 0040c2cd
    mov dword ptr [ebp - local_178], eax         # 0040c2d0
    movsx ecx, word ptr [0x5c39e3]               # 0040c2d6
    imul ecx, ecx, 0x8d                          # 0040c2dd
    mov edx, dword ptr [ebp - local_178]         # 0040c2e3
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040c2e9
    cmp dword ptr [ebp - local_178], 0x0         # 0040c2ef
    jne.d8 L_0040c33c                            # 0040c2f6
    # block 0x0040c2f8: entered by fall-through of jne at 0x0040c2f6, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040c2f8
    push eax                                     # 0040c2ff
    mov ecx, dword ptr [0x5bb57b]                # 0040c300
    push ecx                                     # 0040c306
    push 0x53f2f8                                # 0040c307
    push 0x63888b                                # 0040c30c
    call FUN_0050ca3e                            # 0040c311
    add esp, 0x10                                # 0040c316
    push 0x63888b                                # 0040c319
    push 0x53f324                                # 0040c31e
    mov ecx, 0x583979                            # 0040c323
    call FUN_0042639d                            # 0040c328
    mov ecx, 0x5cf659                            # 0040c32d
    call FUN_004c97b4                            # 0040c332
    jmp.d32 L_00410c9e                           # 0040c337
L_0040c33c:
    # block 0x0040c33c: entered by jne at 0x0040c2f6, 22 instruction(s), ends with je to 0x0040c3a3 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040c33c
    mov esi, dword ptr [ebp - local_20]          # 0040c343
    movsx edx, word ptr [0x5c39e3]               # 0040c346
    imul edx, edx, 0x8d                          # 0040c34d
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040c353
    {load} mov eax, ecx                          # 0040c359
    shr ecx, 0x2                                 # 0040c35b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040c35e
    {load} mov ecx, eax                          # 0040c360
    and ecx, 0x3                                 # 0040c362
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040c365
    movsx ecx, word ptr [ebp - local_118]        # 0040c367
    mov edx, dword ptr [ebp - local_cc]          # 0040c36e
    {load} add edx, ecx                          # 0040c374
    mov dword ptr [ebp - local_cc], edx          # 0040c376
    movsx eax, word ptr [ebp - local_118]        # 0040c37c
    mov ecx, dword ptr [ebp - local_20]          # 0040c383
    {load} add ecx, eax                          # 0040c386
    mov dword ptr [ebp - local_20], ecx          # 0040c388
    movsx edx, word ptr [0x63a4cd]               # 0040c38b
    test edx, edx                                # 0040c392
    je.d8 L_0040c3a3                             # 0040c394
    # block 0x0040c396: entered by fall-through of je at 0x0040c394, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c3a3
    push 0x53f340                                # 0040c396
    call FUN_0044a2b7                            # 0040c39b
    add esp, 0x4                                 # 0040c3a0
L_0040c3a3:
    # block 0x0040c3a3: entered by je at 0x0040c394, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040c3a3
L_0040c3a8:
    # block 0x0040c3a8: entered by switch case, 11 instruction(s), calls FUN_004bf8c2, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c3a8
    push eax                                     # 0040c3ae
    lea ecx, [ebp - local_20]                    # 0040c3af
    push ecx                                     # 0040c3b2
    movsx edx, word ptr [0x5c39e3]               # 0040c3b3
    imul edx, edx, 0x8d                          # 0040c3ba
    add edx, 0x5bb5e5                            # 0040c3c0
    push edx                                     # 0040c3c6
    mov ecx, 0x637fcf                            # 0040c3c7
    call FUN_004bf8c2                            # 0040c3cc
    jmp.d32 L_00410a68                           # 0040c3d1
L_0040c3d6:
    # block 0x0040c3d6: entered by switch case, 11 instruction(s), calls FUN_00488e9c, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c3d6
    push eax                                     # 0040c3dc
    lea ecx, [ebp - local_20]                    # 0040c3dd
    push ecx                                     # 0040c3e0
    movsx edx, word ptr [0x5c39e3]               # 0040c3e1
    imul edx, edx, 0x8d                          # 0040c3e8
    add edx, 0x5bb5e5                            # 0040c3ee
    push edx                                     # 0040c3f4
    mov ecx, 0x619935                            # 0040c3f5
    call FUN_00488e9c                            # 0040c3fa
    jmp.d32 L_00410a68                           # 0040c3ff
L_0040c404:
    # block 0x0040c404: entered by switch case, 14 instruction(s), calls FUN_0048905b, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040c404
    push eax                                     # 0040c40a
    lea ecx, [ebp - local_20]                    # 0040c40b
    push ecx                                     # 0040c40e
    movsx edx, word ptr [0x5c39e3]               # 0040c40f
    imul edx, edx, 0x8d                          # 0040c416
    add edx, 0x5bb5e5                            # 0040c41c
    push edx                                     # 0040c422
    mov ecx, 0x619935                            # 0040c423
    call FUN_0048905b                            # 0040c428
    movsx eax, word ptr [0x5c39e3]               # 0040c42d
    imul eax, eax, 0x8d                          # 0040c434
    mov byte ptr [eax + 0x5bb5e3], 0x36          # 0040c43a
    jmp.d32 L_00410a68                           # 0040c441
L_0040c446:
    # block 0x0040c446: entered by switch case, 14 instruction(s), calls FUN_004895cc, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040c446
    push ecx                                     # 0040c44c
    lea edx, [ebp - local_20]                    # 0040c44d
    push edx                                     # 0040c450
    movsx eax, word ptr [0x5c39e3]               # 0040c451
    imul eax, eax, 0x8d                          # 0040c458
    add eax, 0x5bb5e5                            # 0040c45e
    push eax                                     # 0040c463
    mov ecx, 0x619935                            # 0040c464
    call FUN_004895cc                            # 0040c469
    movsx ecx, word ptr [0x5c39e3]               # 0040c46e
    imul ecx, ecx, 0x8d                          # 0040c475
    mov byte ptr [ecx + 0x5bb5e3], 0x36          # 0040c47b
    jmp.d32 L_00410a68                           # 0040c482
L_0040c487:
    # block 0x0040c487: entered by switch case, 11 instruction(s), calls FUN_0041137f, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c487
    push edx                                     # 0040c48d
    lea eax, [ebp - local_20]                    # 0040c48e
    push eax                                     # 0040c491
    movsx ecx, word ptr [0x5c39e3]               # 0040c492
    imul ecx, ecx, 0x8d                          # 0040c499
    add ecx, 0x5bb5e5                            # 0040c49f
    push ecx                                     # 0040c4a5
    mov ecx, 0x619a41                            # 0040c4a6
    call FUN_0041137f                            # 0040c4ab
    jmp.d32 L_00410a68                           # 0040c4b0
L_0040c4b5:
    # block 0x0040c4b5: entered by switch case, 11 instruction(s), calls FUN_0041166e, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c4b5
    push edx                                     # 0040c4bb
    lea eax, [ebp - local_20]                    # 0040c4bc
    push eax                                     # 0040c4bf
    movsx ecx, word ptr [0x5c39e3]               # 0040c4c0
    imul ecx, ecx, 0x8d                          # 0040c4c7
    add ecx, 0x5bb5e5                            # 0040c4cd
    push ecx                                     # 0040c4d3
    mov ecx, 0x619a41                            # 0040c4d4
    call FUN_0041166e                            # 0040c4d9
    jmp.d32 L_00410a68                           # 0040c4de
L_0040c4e3:
    # block 0x0040c4e3: entered by switch case, 11 instruction(s), calls FUN_0041195c, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c4e3
    push edx                                     # 0040c4e9
    lea eax, [ebp - local_20]                    # 0040c4ea
    push eax                                     # 0040c4ed
    movsx ecx, word ptr [0x5c39e3]               # 0040c4ee
    imul ecx, ecx, 0x8d                          # 0040c4f5
    add ecx, 0x5bb5e5                            # 0040c4fb
    push ecx                                     # 0040c501
    mov ecx, 0x619a41                            # 0040c502
    call FUN_0041195c                            # 0040c507
    jmp.d32 L_00410a68                           # 0040c50c
L_0040c511:
    # block 0x0040c511: entered by switch case, 11 instruction(s), calls FUN_00411a22, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c511
    push edx                                     # 0040c517
    lea eax, [ebp - local_20]                    # 0040c518
    push eax                                     # 0040c51b
    movsx ecx, word ptr [0x5c39e3]               # 0040c51c
    imul ecx, ecx, 0x8d                          # 0040c523
    add ecx, 0x5bb5e5                            # 0040c529
    push ecx                                     # 0040c52f
    mov ecx, 0x619a41                            # 0040c530
    call FUN_00411a22                            # 0040c535
    jmp.d32 L_00410a68                           # 0040c53a
L_0040c53f:
    # block 0x0040c53f: entered by switch case, 11 instruction(s), calls FUN_00411a22, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c53f
    push edx                                     # 0040c545
    lea eax, [ebp - local_20]                    # 0040c546
    push eax                                     # 0040c549
    movsx ecx, word ptr [0x5c39e3]               # 0040c54a
    imul ecx, ecx, 0x8d                          # 0040c551
    add ecx, 0x5bb5e5                            # 0040c557
    push ecx                                     # 0040c55d
    mov ecx, 0x619a41                            # 0040c55e
    call FUN_00411a22                            # 0040c563
    jmp.d32 L_00410a68                           # 0040c568
L_0040c56d:
    # block 0x0040c56d: entered by switch case, 11 instruction(s), calls FUN_00411a22, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c56d
    push edx                                     # 0040c573
    lea eax, [ebp - local_20]                    # 0040c574
    push eax                                     # 0040c577
    movsx ecx, word ptr [0x5c39e3]               # 0040c578
    imul ecx, ecx, 0x8d                          # 0040c57f
    add ecx, 0x5bb5e5                            # 0040c585
    push ecx                                     # 0040c58b
    mov ecx, 0x619a41                            # 0040c58c
    call FUN_00411a22                            # 0040c591
    jmp.d32 L_00410a68                           # 0040c596
L_0040c59b:
    # block 0x0040c59b: entered by switch case, 11 instruction(s), calls FUN_0044b05a, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c59b
    push edx                                     # 0040c5a1
    lea eax, [ebp - local_20]                    # 0040c5a2
    push eax                                     # 0040c5a5
    movsx ecx, word ptr [0x5c39e3]               # 0040c5a6
    imul ecx, ecx, 0x8d                          # 0040c5ad
    add ecx, 0x5bb5e5                            # 0040c5b3
    push ecx                                     # 0040c5b9
    mov ecx, 0x637fb1                            # 0040c5ba
    call FUN_0044b05a                            # 0040c5bf
    jmp.d32 L_00410a68                           # 0040c5c4
L_0040c5c9:
    # block 0x0040c5c9: entered by switch case, 11 instruction(s), calls FUN_0044b102, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c5c9
    push edx                                     # 0040c5cf
    lea eax, [ebp - local_20]                    # 0040c5d0
    push eax                                     # 0040c5d3
    movsx ecx, word ptr [0x5c39e3]               # 0040c5d4
    imul ecx, ecx, 0x8d                          # 0040c5db
    add ecx, 0x5bb5e5                            # 0040c5e1
    push ecx                                     # 0040c5e7
    mov ecx, 0x637fb1                            # 0040c5e8
    call FUN_0044b102                            # 0040c5ed
    jmp.d32 L_00410a68                           # 0040c5f2
L_0040c5f7:
    # block 0x0040c5f7: entered by switch case, 11 instruction(s), calls FUN_0044b1b4, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 0040c5f7
    push edx                                     # 0040c5fd
    lea eax, [ebp - local_20]                    # 0040c5fe
    push eax                                     # 0040c601
    movsx ecx, word ptr [0x5c39e3]               # 0040c602
    imul ecx, ecx, 0x8d                          # 0040c609
    add ecx, 0x5bb5e5                            # 0040c60f
    push ecx                                     # 0040c615
    mov ecx, 0x637fb1                            # 0040c616
    call FUN_0044b1b4                            # 0040c61b
    jmp.d32 L_00410a68                           # 0040c620
L_0040c625:
    # block 0x0040c625: entered by switch case, 6 instruction(s), ends with jne to 0x0040c88d (forward)
    mov edx, dword ptr [ebp - local_20]          # 0040c625
    mov dword ptr [ebp - local_13c], edx         # 0040c628
    mov eax, dword ptr [ebp - local_13c]         # 0040c62e
    movsx ecx, word ptr [eax]                    # 0040c634
    cmp ecx, -0x1                                # 0040c637
    jne.d32 L_0040c88d                           # 0040c63a
    # block 0x0040c640: entered by fall-through of jne at 0x0040c63a, 13 instruction(s), calls FUN_00423259, ends with jne to 0x0040c6e5 (forward)
    mov esi, dword ptr [ebp - local_13c]         # 0040c640
    add esi, 0x2                                 # 0040c646
    mov ecx, 0x8                                 # 0040c649
    lea edi, [ebp - local_f4]                    # 0040c64e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040c654
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040c656
    lea edx, [ebp - local_f4]                    # 0040c657
    push edx                                     # 0040c65d
    mov ecx, 0x619a6b                            # 0040c65e
    call FUN_00423259                            # 0040c663
    mov dword ptr [ebp - local_110], eax         # 0040c668
    cmp dword ptr [ebp - local_110], 0x0         # 0040c66e
    jne.d8 L_0040c6e5                            # 0040c675
    # block 0x0040c677: entered by fall-through of jne at 0x0040c675, 3 instruction(s), ends with je to 0x0040c6bc (forward)
    movsx eax, word ptr [0x63a4cd]               # 0040c677
    test eax, eax                                # 0040c67e
    je.d8 L_0040c6bc                             # 0040c680
    # block 0x0040c682: entered by fall-through of je at 0x0040c680, 16 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, falls into the block at 0x0040c6bc
    lea ecx, [ebp - local_f4]                    # 0040c682
    push ecx                                     # 0040c688
    push 0x53f380                                # 0040c689
    lea edx, [ebp - local_b8]                    # 0040c68e
    push edx                                     # 0040c694
    call FUN_0050ca3e                            # 0040c695
    add esp, 0xc                                 # 0040c69a
    push 0x0                                     # 0040c69d
    push 0x0                                     # 0040c69f
    lea eax, [ebp - local_b8]                    # 0040c6a1
    push eax                                     # 0040c6a7
    call FUN_0052139c                            # 0040c6a8
    lea ecx, [ebp - local_b8]                    # 0040c6ad
    push ecx                                     # 0040c6b3
    call FUN_0044a2b7                            # 0040c6b4
    add esp, 0x4                                 # 0040c6b9
L_0040c6bc:
    # block 0x0040c6bc: entered by je at 0x0040c680, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0040c746
    lea edx, [ebp - local_f4]                    # 0040c6bc
    push edx                                     # 0040c6c2
    push 0x53f398                                # 0040c6c3
    lea eax, [ebp - local_b8]                    # 0040c6c8
    push eax                                     # 0040c6ce
    call FUN_0050ca3e                            # 0040c6cf
    add esp, 0xc                                 # 0040c6d4
    lea ecx, [ebp - local_b8]                    # 0040c6d7
    mov dword ptr [ebp - local_110], ecx         # 0040c6dd
    jmp.d8 L_0040c746                            # 0040c6e3
L_0040c6e5:
    # block 0x0040c6e5: entered by jne at 0x0040c675, 8 instruction(s), ends with jbe to 0x0040c746 (forward)
    mov edi, dword ptr [ebp - local_110]         # 0040c6e5
    or ecx, -0x1                                 # 0040c6eb
    {load} xor eax, eax                          # 0040c6ee
    repne scasb al, byte ptr es:[edi]            # 0040c6f0
    not ecx                                      # 0040c6f2
    add ecx, -0x1                                # 0040c6f4
    cmp ecx, 0x9c40                              # 0040c6f7
    jbe.d8 L_0040c746                            # 0040c6fd
    # block 0x0040c6ff: entered by fall-through of jbe at 0x0040c6fd, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0040c737 (forward)
    push 0x53f3dc                                # 0040c6ff
    push 0x63888b                                # 0040c704
    call FUN_0050ca3e                            # 0040c709
    add esp, 0x8                                 # 0040c70e
    push 0x0                                     # 0040c711
    push 0x0                                     # 0040c713
    push 0x63888b                                # 0040c715
    call FUN_0052139c                            # 0040c71a
    movsx edx, word ptr [0x63a4cd]               # 0040c71f
    test edx, edx                                # 0040c726
    je.d8 L_0040c737                             # 0040c728
    # block 0x0040c72a: entered by fall-through of je at 0x0040c728, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c737
    push 0x63888b                                # 0040c72a
    call FUN_0044a2b7                            # 0040c72f
    add esp, 0x4                                 # 0040c734
L_0040c737:
    # block 0x0040c737: entered by je at 0x0040c728, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040c737
    call FUN_004c97b4                            # 0040c73c
    jmp.d32 L_00410a68                           # 0040c741
L_0040c746:
    # block 0x0040c746: entered by jmp at 0x0040c6e3; jbe at 0x0040c6fd, 27 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040c7fb (forward)
    mov word ptr [ebp - local_118], 0x23         # 0040c746
    mov edi, dword ptr [ebp - local_110]         # 0040c74f
    or ecx, -0x1                                 # 0040c755
    {load} xor eax, eax                          # 0040c758
    repne scasb al, byte ptr es:[edi]            # 0040c75a
    not ecx                                      # 0040c75c
    add ecx, -0x1                                # 0040c75e
    {load} mov edx, ecx                          # 0040c761
    mov edi, 0x53f428                            # 0040c763
    or ecx, -0x1                                 # 0040c768
    {load} xor eax, eax                          # 0040c76b
    repne scasb al, byte ptr es:[edi]            # 0040c76d
    not ecx                                      # 0040c76f
    add ecx, -0x1                                # 0040c771
    lea eax, [edx + ecx + field_3]               # 0040c774
    mov word ptr [ebp - local_c8], ax            # 0040c778
    movsx ecx, word ptr [ebp - local_c8]         # 0040c77f
    push ecx                                     # 0040c786
    call FUN_0051dc43                            # 0040c787
    add esp, 0x4                                 # 0040c78c
    mov dword ptr [ebp - local_17c], eax         # 0040c78f
    movsx edx, word ptr [0x5c39e3]               # 0040c795
    imul edx, edx, 0x8d                          # 0040c79c
    mov eax, dword ptr [ebp - local_17c]         # 0040c7a2
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040c7a8
    cmp dword ptr [ebp - local_17c], 0x0         # 0040c7ae
    jne.d8 L_0040c7fb                            # 0040c7b5
    # block 0x0040c7b7: entered by fall-through of jne at 0x0040c7b5, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410a68
    movsx ecx, word ptr [0x5c39e3]               # 0040c7b7
    push ecx                                     # 0040c7be
    mov edx, dword ptr [0x5bb57b]                # 0040c7bf
    push edx                                     # 0040c7c5
    push 0x53f42c                                # 0040c7c6
    push 0x63888b                                # 0040c7cb
    call FUN_0050ca3e                            # 0040c7d0
    add esp, 0x10                                # 0040c7d5
    push 0x63888b                                # 0040c7d8
    push 0x53f458                                # 0040c7dd
    mov ecx, 0x583979                            # 0040c7e2
    call FUN_0042639d                            # 0040c7e7
    mov ecx, 0x5cf659                            # 0040c7ec
    call FUN_004c97b4                            # 0040c7f1
    jmp.d32 L_00410a68                           # 0040c7f6
L_0040c7fb:
    # block 0x0040c7fb: entered by jne at 0x0040c7b5, 42 instruction(s), ends with forward jump to 0x0040ca6b
    movsx eax, word ptr [0x5c39e3]               # 0040c7fb
    imul eax, eax, 0x8d                          # 0040c802
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040c808
    mov dword ptr [ebp - local_13c], ecx         # 0040c80e
    mov edi, dword ptr [ebp - local_110]         # 0040c814
    or ecx, -0x1                                 # 0040c81a
    {load} xor eax, eax                          # 0040c81d
    repne scasb al, byte ptr es:[edi]            # 0040c81f
    not ecx                                      # 0040c821
    add ecx, -0x1                                # 0040c823
    {load} mov edx, ecx                          # 0040c826
    mov edi, 0x53f474                            # 0040c828
    or ecx, -0x1                                 # 0040c82d
    {load} xor eax, eax                          # 0040c830
    repne scasb al, byte ptr es:[edi]            # 0040c832
    not ecx                                      # 0040c834
    add ecx, -0x1                                # 0040c836
    {load} add edx, ecx                          # 0040c839
    mov eax, dword ptr [ebp - local_13c]         # 0040c83b
    mov word ptr [eax], dx                       # 0040c841
    mov edi, dword ptr [ebp - local_110]         # 0040c844
    or ecx, -0x1                                 # 0040c84a
    {load} xor eax, eax                          # 0040c84d
    repne scasb al, byte ptr es:[edi]            # 0040c84f
    not ecx                                      # 0040c851
    mov esi, dword ptr [ebp - local_110]         # 0040c853
    mov edi, dword ptr [ebp - local_13c]         # 0040c859
    add edi, 0x2                                 # 0040c85f
    {load} mov edx, ecx                          # 0040c862
    shr ecx, 0x2                                 # 0040c864
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040c867
    {load} mov ecx, edx                          # 0040c869
    and ecx, 0x3                                 # 0040c86b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040c86e
    mov edi, dword ptr [ebp - local_13c]         # 0040c870
    add edi, 0x2                                 # 0040c876
    or ecx, -0x1                                 # 0040c879
    {load} xor eax, eax                          # 0040c87c
    repne scasb al, byte ptr es:[edi]            # 0040c87e
    mov eax, dword ptr [0x53f478]                # 0040c880
    mov dword ptr [edi - field_minus_1], eax     # 0040c885
    jmp.d32 L_0040ca6b                           # 0040c888
L_0040c88d:
    # block 0x0040c88d: entered by jne at 0x0040c63a, 14 instruction(s), ends with jl to 0x0040c914 (forward)
    mov ecx, dword ptr [ebp - local_13c]         # 0040c88d
    movsx edx, word ptr [ecx]                    # 0040c893
    mov edi, 0x53f47c                            # 0040c896
    or ecx, -0x1                                 # 0040c89b
    {load} xor eax, eax                          # 0040c89e
    repne scasb al, byte ptr es:[edi]            # 0040c8a0
    not ecx                                      # 0040c8a2
    add ecx, -0x1                                # 0040c8a4
    lea eax, [edx + ecx + field_2]               # 0040c8a7
    mov word ptr [ebp - local_118], ax           # 0040c8ab
    mov ecx, dword ptr [ebp - local_13c]         # 0040c8b2
    movsx edx, word ptr [ecx]                    # 0040c8b8
    cmp edx, 0x2710                              # 0040c8bb
    jl.d8 L_0040c914                             # 0040c8c1
    # block 0x0040c8c3: entered by fall-through of jl at 0x0040c8c1, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0040c905 (forward)
    mov eax, dword ptr [ebp - local_13c]         # 0040c8c3
    movsx ecx, word ptr [eax]                    # 0040c8c9
    push ecx                                     # 0040c8cc
    push 0x53f480                                # 0040c8cd
    push 0x63888b                                # 0040c8d2
    call FUN_0050ca3e                            # 0040c8d7
    add esp, 0xc                                 # 0040c8dc
    push 0x0                                     # 0040c8df
    push 0x0                                     # 0040c8e1
    push 0x63888b                                # 0040c8e3
    call FUN_0052139c                            # 0040c8e8
    movsx edx, word ptr [0x63a4cd]               # 0040c8ed
    test edx, edx                                # 0040c8f4
    je.d8 L_0040c905                             # 0040c8f6
    # block 0x0040c8f8: entered by fall-through of je at 0x0040c8f6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c905
    push 0x63888b                                # 0040c8f8
    call FUN_0044a2b7                            # 0040c8fd
    add esp, 0x4                                 # 0040c902
L_0040c905:
    # block 0x0040c905: entered by je at 0x0040c8f6, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040c905
    call FUN_004c97b4                            # 0040c90a
    jmp.d32 L_00410a68                           # 0040c90f
L_0040c914:
    # block 0x0040c914: entered by jl at 0x0040c8c1, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040c9a8 (forward)
    movsx eax, word ptr [ebp - local_118]        # 0040c914
    push eax                                     # 0040c91b
    call FUN_0051dc43                            # 0040c91c
    add esp, 0x4                                 # 0040c921
    mov dword ptr [ebp - local_180], eax         # 0040c924
    movsx ecx, word ptr [0x5c39e3]               # 0040c92a
    imul ecx, ecx, 0x8d                          # 0040c931
    mov edx, dword ptr [ebp - local_180]         # 0040c937
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040c93d
    cmp dword ptr [ebp - local_180], 0x0         # 0040c943
    jne.d8 L_0040c9a8                            # 0040c94a
    # block 0x0040c94c: entered by fall-through of jne at 0x0040c94a, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, ends with je to 0x0040c999 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040c94c
    push eax                                     # 0040c953
    mov ecx, dword ptr [0x5bb57b]                # 0040c954
    push ecx                                     # 0040c95a
    push 0x53f4c8                                # 0040c95b
    push 0x63888b                                # 0040c960
    call FUN_0050ca3e                            # 0040c965
    add esp, 0x10                                # 0040c96a
    push 0x63888b                                # 0040c96d
    push 0x53f4f4                                # 0040c972
    mov ecx, 0x583979                            # 0040c977
    call FUN_0042639d                            # 0040c97c
    movsx edx, word ptr [0x63a4cd]               # 0040c981
    test edx, edx                                # 0040c988
    je.d8 L_0040c999                             # 0040c98a
    # block 0x0040c98c: entered by fall-through of je at 0x0040c98a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040c999
    push 0x63888b                                # 0040c98c
    call FUN_0044a2b7                            # 0040c991
    add esp, 0x4                                 # 0040c996
L_0040c999:
    # block 0x0040c999: entered by je at 0x0040c98a, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040c999
    call FUN_004c97b4                            # 0040c99e
    jmp.d32 L_00410a68                           # 0040c9a3
L_0040c9a8:
    # block 0x0040c9a8: entered by jne at 0x0040c94a, 52 instruction(s), falls into the block at 0x0040ca6b
    mov edi, 0x53f510                            # 0040c9a8
    or ecx, -0x1                                 # 0040c9ad
    {load} xor eax, eax                          # 0040c9b0
    repne scasb al, byte ptr es:[edi]            # 0040c9b2
    not ecx                                      # 0040c9b4
    add ecx, -0x1                                # 0040c9b6
    mov ax, word ptr [ebp - local_118]           # 0040c9b9
    {load} sub ax, cx                            # 0040c9c0
    mov word ptr [ebp - local_118], ax           # 0040c9c3
    movsx ecx, word ptr [ebp - local_118]        # 0040c9ca
    mov esi, dword ptr [ebp - local_20]          # 0040c9d1
    movsx edx, word ptr [0x5c39e3]               # 0040c9d4
    imul edx, edx, 0x8d                          # 0040c9db
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040c9e1
    {load} mov eax, ecx                          # 0040c9e7
    shr ecx, 0x2                                 # 0040c9e9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040c9ec
    {load} mov ecx, eax                          # 0040c9ee
    and ecx, 0x3                                 # 0040c9f0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040c9f3
    movsx ecx, word ptr [0x5c39e3]               # 0040c9f5
    imul ecx, ecx, 0x8d                          # 0040c9fc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040ca02
    mov dword ptr [ebp - local_13c], edx         # 0040ca08
    mov edi, 0x53f514                            # 0040ca0e
    or ecx, -0x1                                 # 0040ca13
    {load} xor eax, eax                          # 0040ca16
    repne scasb al, byte ptr es:[edi]            # 0040ca18
    not ecx                                      # 0040ca1a
    add ecx, -0x1                                # 0040ca1c
    mov esi, 0x53f518                            # 0040ca1f
    mov eax, dword ptr [ebp - local_13c]         # 0040ca24
    movsx edx, word ptr [eax]                    # 0040ca2a
    mov eax, dword ptr [ebp - local_13c]         # 0040ca2d
    lea edi, [eax + edx + field_2]               # 0040ca33
    {load} mov edx, ecx                          # 0040ca37
    shr ecx, 0x2                                 # 0040ca39
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ca3c
    {load} mov ecx, edx                          # 0040ca3e
    and ecx, 0x3                                 # 0040ca40
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040ca43
    mov edi, 0x53f51c                            # 0040ca45
    or ecx, -0x1                                 # 0040ca4a
    {load} xor eax, eax                          # 0040ca4d
    repne scasb al, byte ptr es:[edi]            # 0040ca4f
    not ecx                                      # 0040ca51
    add ecx, -0x1                                # 0040ca53
    mov eax, dword ptr [ebp - local_13c]         # 0040ca56
    mov dx, word ptr [eax]                       # 0040ca5c
    {load} add dx, cx                            # 0040ca5f
    mov eax, dword ptr [ebp - local_13c]         # 0040ca62
    mov word ptr [eax], dx                       # 0040ca68
L_0040ca6b:
    # block 0x0040ca6b: entered by jmp at 0x0040c888, 11 instruction(s), ends with je to 0x0040caa7 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040ca6b
    mov edx, dword ptr [ebp - local_cc]          # 0040ca72
    {load} add edx, ecx                          # 0040ca78
    mov dword ptr [ebp - local_cc], edx          # 0040ca7a
    movsx eax, word ptr [ebp - local_118]        # 0040ca80
    mov ecx, dword ptr [ebp - local_20]          # 0040ca87
    {load} add ecx, eax                          # 0040ca8a
    mov dword ptr [ebp - local_20], ecx          # 0040ca8c
    movsx edx, word ptr [0x63a4cd]               # 0040ca8f
    test edx, edx                                # 0040ca96
    je.d8 L_0040caa7                             # 0040ca98
    # block 0x0040ca9a: entered by fall-through of je at 0x0040ca98, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040caa7
    push 0x53f520                                # 0040ca9a
    call FUN_0044a2b7                            # 0040ca9f
    add esp, 0x4                                 # 0040caa4
L_0040caa7:
    # block 0x0040caa7: entered by je at 0x0040ca98, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040caa7
L_0040caac:
    # block 0x0040caac: entered by switch case, 6 instruction(s), ends with jne to 0x0040cd62 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040caac
    mov dword ptr [ebp - local_114], eax         # 0040caaf
    mov ecx, dword ptr [ebp - local_114]         # 0040cab5
    movsx edx, word ptr [ecx + field_a]          # 0040cabb
    cmp edx, -0x1                                # 0040cabf
    jne.d32 L_0040cd62                           # 0040cac2
    # block 0x0040cac8: entered by fall-through of jne at 0x0040cac2, 13 instruction(s), calls FUN_00423259, ends with jne to 0x0040cb6d (forward)
    mov esi, dword ptr [ebp - local_114]         # 0040cac8
    add esi, 0xc                                 # 0040cace
    mov ecx, 0x8                                 # 0040cad1
    lea edi, [ebp - local_f4]                    # 0040cad6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040cadc
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040cade
    lea eax, [ebp - local_f4]                    # 0040cadf
    push eax                                     # 0040cae5
    mov ecx, 0x619a6b                            # 0040cae6
    call FUN_00423259                            # 0040caeb
    mov dword ptr [ebp - local_110], eax         # 0040caf0
    cmp dword ptr [ebp - local_110], 0x0         # 0040caf6
    jne.d8 L_0040cb6d                            # 0040cafd
    # block 0x0040caff: entered by fall-through of jne at 0x0040cafd, 3 instruction(s), ends with je to 0x0040cb44 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0040caff
    test ecx, ecx                                # 0040cb06
    je.d8 L_0040cb44                             # 0040cb08
    # block 0x0040cb0a: entered by fall-through of je at 0x0040cb08, 16 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, falls into the block at 0x0040cb44
    lea edx, [ebp - local_f4]                    # 0040cb0a
    push edx                                     # 0040cb10
    push 0x53f550                                # 0040cb11
    lea eax, [ebp - local_b8]                    # 0040cb16
    push eax                                     # 0040cb1c
    call FUN_0050ca3e                            # 0040cb1d
    add esp, 0xc                                 # 0040cb22
    push 0x0                                     # 0040cb25
    push 0x0                                     # 0040cb27
    lea ecx, [ebp - local_b8]                    # 0040cb29
    push ecx                                     # 0040cb2f
    call FUN_0052139c                            # 0040cb30
    lea edx, [ebp - local_b8]                    # 0040cb35
    push edx                                     # 0040cb3b
    call FUN_0044a2b7                            # 0040cb3c
    add esp, 0x4                                 # 0040cb41
L_0040cb44:
    # block 0x0040cb44: entered by je at 0x0040cb08, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0040cbce
    lea eax, [ebp - local_f4]                    # 0040cb44
    push eax                                     # 0040cb4a
    push 0x53f568                                # 0040cb4b
    lea ecx, [ebp - local_b8]                    # 0040cb50
    push ecx                                     # 0040cb56
    call FUN_0050ca3e                            # 0040cb57
    add esp, 0xc                                 # 0040cb5c
    lea edx, [ebp - local_b8]                    # 0040cb5f
    mov dword ptr [ebp - local_110], edx         # 0040cb65
    jmp.d8 L_0040cbce                            # 0040cb6b
L_0040cb6d:
    # block 0x0040cb6d: entered by jne at 0x0040cafd, 8 instruction(s), ends with jbe to 0x0040cbce (forward)
    mov edi, dword ptr [ebp - local_110]         # 0040cb6d
    or ecx, -0x1                                 # 0040cb73
    {load} xor eax, eax                          # 0040cb76
    repne scasb al, byte ptr es:[edi]            # 0040cb78
    not ecx                                      # 0040cb7a
    add ecx, -0x1                                # 0040cb7c
    cmp ecx, 0x9c40                              # 0040cb7f
    jbe.d8 L_0040cbce                            # 0040cb85
    # block 0x0040cb87: entered by fall-through of jbe at 0x0040cb85, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0040cbbf (forward)
    push 0x53f5ac                                # 0040cb87
    push 0x63888b                                # 0040cb8c
    call FUN_0050ca3e                            # 0040cb91
    add esp, 0x8                                 # 0040cb96
    push 0x0                                     # 0040cb99
    push 0x0                                     # 0040cb9b
    push 0x63888b                                # 0040cb9d
    call FUN_0052139c                            # 0040cba2
    movsx eax, word ptr [0x63a4cd]               # 0040cba7
    test eax, eax                                # 0040cbae
    je.d8 L_0040cbbf                             # 0040cbb0
    # block 0x0040cbb2: entered by fall-through of je at 0x0040cbb0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040cbbf
    push 0x63888b                                # 0040cbb2
    call FUN_0044a2b7                            # 0040cbb7
    add esp, 0x4                                 # 0040cbbc
L_0040cbbf:
    # block 0x0040cbbf: entered by je at 0x0040cbb0, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040cbbf
    call FUN_004c97b4                            # 0040cbc4
    jmp.d32 L_00410a68                           # 0040cbc9
L_0040cbce:
    # block 0x0040cbce: entered by jmp at 0x0040cb6b; jbe at 0x0040cb85, 27 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040cc83 (forward)
    mov word ptr [ebp - local_118], 0x2d         # 0040cbce
    mov edi, dword ptr [ebp - local_110]         # 0040cbd7
    or ecx, -0x1                                 # 0040cbdd
    {load} xor eax, eax                          # 0040cbe0
    repne scasb al, byte ptr es:[edi]            # 0040cbe2
    not ecx                                      # 0040cbe4
    add ecx, -0x1                                # 0040cbe6
    {load} mov edx, ecx                          # 0040cbe9
    mov edi, 0x53f604                            # 0040cbeb
    or ecx, -0x1                                 # 0040cbf0
    {load} xor eax, eax                          # 0040cbf3
    repne scasb al, byte ptr es:[edi]            # 0040cbf5
    not ecx                                      # 0040cbf7
    add ecx, -0x1                                # 0040cbf9
    lea eax, [edx + ecx + field_d]               # 0040cbfc
    mov word ptr [ebp - local_c8], ax            # 0040cc00
    movsx ecx, word ptr [ebp - local_c8]         # 0040cc07
    push ecx                                     # 0040cc0e
    call FUN_0051dc43                            # 0040cc0f
    add esp, 0x4                                 # 0040cc14
    mov dword ptr [ebp - local_184], eax         # 0040cc17
    movsx edx, word ptr [0x5c39e3]               # 0040cc1d
    imul edx, edx, 0x8d                          # 0040cc24
    mov eax, dword ptr [ebp - local_184]         # 0040cc2a
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040cc30
    cmp dword ptr [ebp - local_184], 0x0         # 0040cc36
    jne.d8 L_0040cc83                            # 0040cc3d
    # block 0x0040cc3f: entered by fall-through of jne at 0x0040cc3d, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410a68
    movsx ecx, word ptr [0x5c39e3]               # 0040cc3f
    push ecx                                     # 0040cc46
    mov edx, dword ptr [0x5bb57b]                # 0040cc47
    push edx                                     # 0040cc4d
    push 0x53f608                                # 0040cc4e
    push 0x63888b                                # 0040cc53
    call FUN_0050ca3e                            # 0040cc58
    add esp, 0x10                                # 0040cc5d
    push 0x63888b                                # 0040cc60
    push 0x53f634                                # 0040cc65
    mov ecx, 0x583979                            # 0040cc6a
    call FUN_0042639d                            # 0040cc6f
    mov ecx, 0x5cf659                            # 0040cc74
    call FUN_004c97b4                            # 0040cc79
    jmp.d32 L_00410a68                           # 0040cc7e
L_0040cc83:
    # block 0x0040cc83: entered by jne at 0x0040cc3d, 58 instruction(s), ends with forward jump to 0x0040cf46
    movsx eax, word ptr [0x5c39e3]               # 0040cc83
    imul eax, eax, 0x8d                          # 0040cc8a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040cc90
    mov dword ptr [ebp - local_138], ecx         # 0040cc96
    mov edx, dword ptr [ebp - local_138]         # 0040cc9c
    mov eax, dword ptr [ebp - local_114]         # 0040cca2
    mov cx, word ptr [eax]                       # 0040cca8
    mov word ptr [edx], cx                       # 0040ccab
    mov edx, dword ptr [ebp - local_138]         # 0040ccae
    mov eax, dword ptr [ebp - local_114]         # 0040ccb4
    mov cx, word ptr [eax + field_2]             # 0040ccba
    mov word ptr [edx + field_2], cx             # 0040ccbe
    mov edx, dword ptr [ebp - local_138]         # 0040ccc2
    mov eax, dword ptr [ebp - local_114]         # 0040ccc8
    mov cx, word ptr [eax + field_4]             # 0040ccce
    mov word ptr [edx + field_4], cx             # 0040ccd2
    mov edx, dword ptr [ebp - local_138]         # 0040ccd6
    mov eax, dword ptr [ebp - local_114]         # 0040ccdc
    mov ecx, dword ptr [eax + field_6]           # 0040cce2
    mov dword ptr [edx + field_6], ecx           # 0040cce5
    mov edi, dword ptr [ebp - local_110]         # 0040cce8
    or ecx, -0x1                                 # 0040ccee
    {load} xor eax, eax                          # 0040ccf1
    repne scasb al, byte ptr es:[edi]            # 0040ccf3
    not ecx                                      # 0040ccf5
    add ecx, -0x1                                # 0040ccf7
    {load} mov edx, ecx                          # 0040ccfa
    mov edi, 0x53f650                            # 0040ccfc
    or ecx, -0x1                                 # 0040cd01
    {load} xor eax, eax                          # 0040cd04
    repne scasb al, byte ptr es:[edi]            # 0040cd06
    not ecx                                      # 0040cd08
    add ecx, -0x1                                # 0040cd0a
    {load} add edx, ecx                          # 0040cd0d
    mov eax, dword ptr [ebp - local_138]         # 0040cd0f
    mov word ptr [eax + field_a], dx             # 0040cd15
    mov edi, dword ptr [ebp - local_110]         # 0040cd19
    or ecx, -0x1                                 # 0040cd1f
    {load} xor eax, eax                          # 0040cd22
    repne scasb al, byte ptr es:[edi]            # 0040cd24
    not ecx                                      # 0040cd26
    mov esi, dword ptr [ebp - local_110]         # 0040cd28
    mov edi, dword ptr [ebp - local_138]         # 0040cd2e
    add edi, 0xc                                 # 0040cd34
    {load} mov edx, ecx                          # 0040cd37
    shr ecx, 0x2                                 # 0040cd39
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040cd3c
    {load} mov ecx, edx                          # 0040cd3e
    and ecx, 0x3                                 # 0040cd40
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040cd43
    mov edi, dword ptr [ebp - local_138]         # 0040cd45
    add edi, 0xc                                 # 0040cd4b
    or ecx, -0x1                                 # 0040cd4e
    {load} xor eax, eax                          # 0040cd51
    repne scasb al, byte ptr es:[edi]            # 0040cd53
    mov eax, dword ptr [0x53f654]                # 0040cd55
    mov dword ptr [edi - field_minus_1], eax     # 0040cd5a
    jmp.d32 L_0040cf46                           # 0040cd5d
L_0040cd62:
    # block 0x0040cd62: entered by jne at 0x0040cac2, 14 instruction(s), ends with jl to 0x0040cdec (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0040cd62
    movsx edx, word ptr [ecx + field_a]          # 0040cd68
    mov edi, 0x53f658                            # 0040cd6c
    or ecx, -0x1                                 # 0040cd71
    {load} xor eax, eax                          # 0040cd74
    repne scasb al, byte ptr es:[edi]            # 0040cd76
    not ecx                                      # 0040cd78
    add ecx, -0x1                                # 0040cd7a
    lea eax, [edx + ecx + field_c]               # 0040cd7d
    mov word ptr [ebp - local_118], ax           # 0040cd81
    mov ecx, dword ptr [ebp - local_114]         # 0040cd88
    movsx edx, word ptr [ecx + field_a]          # 0040cd8e
    cmp edx, 0x2710                              # 0040cd92
    jl.d8 L_0040cdec                             # 0040cd98
    # block 0x0040cd9a: entered by fall-through of jl at 0x0040cd98, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0040cddd (forward)
    mov eax, dword ptr [ebp - local_114]         # 0040cd9a
    movsx ecx, word ptr [eax + field_a]          # 0040cda0
    push ecx                                     # 0040cda4
    push 0x53f65c                                # 0040cda5
    push 0x63888b                                # 0040cdaa
    call FUN_0050ca3e                            # 0040cdaf
    add esp, 0xc                                 # 0040cdb4
    push 0x0                                     # 0040cdb7
    push 0x0                                     # 0040cdb9
    push 0x63888b                                # 0040cdbb
    call FUN_0052139c                            # 0040cdc0
    movsx edx, word ptr [0x63a4cd]               # 0040cdc5
    test edx, edx                                # 0040cdcc
    je.d8 L_0040cddd                             # 0040cdce
    # block 0x0040cdd0: entered by fall-through of je at 0x0040cdce, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040cddd
    push 0x63888b                                # 0040cdd0
    call FUN_0044a2b7                            # 0040cdd5
    add esp, 0x4                                 # 0040cdda
L_0040cddd:
    # block 0x0040cddd: entered by je at 0x0040cdce, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040cddd
    call FUN_004c97b4                            # 0040cde2
    jmp.d32 L_00410a68                           # 0040cde7
L_0040cdec:
    # block 0x0040cdec: entered by jl at 0x0040cd98, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ce80 (forward)
    movsx eax, word ptr [ebp - local_118]        # 0040cdec
    push eax                                     # 0040cdf3
    call FUN_0051dc43                            # 0040cdf4
    add esp, 0x4                                 # 0040cdf9
    mov dword ptr [ebp - local_188], eax         # 0040cdfc
    movsx ecx, word ptr [0x5c39e3]               # 0040ce02
    imul ecx, ecx, 0x8d                          # 0040ce09
    mov edx, dword ptr [ebp - local_188]         # 0040ce0f
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040ce15
    cmp dword ptr [ebp - local_188], 0x0         # 0040ce1b
    jne.d8 L_0040ce80                            # 0040ce22
    # block 0x0040ce24: entered by fall-through of jne at 0x0040ce22, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, ends with je to 0x0040ce71 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040ce24
    push eax                                     # 0040ce2b
    mov ecx, dword ptr [0x5bb57b]                # 0040ce2c
    push ecx                                     # 0040ce32
    push 0x53f6ac                                # 0040ce33
    push 0x63888b                                # 0040ce38
    call FUN_0050ca3e                            # 0040ce3d
    add esp, 0x10                                # 0040ce42
    push 0x63888b                                # 0040ce45
    push 0x53f6d8                                # 0040ce4a
    mov ecx, 0x583979                            # 0040ce4f
    call FUN_0042639d                            # 0040ce54
    movsx edx, word ptr [0x63a4cd]               # 0040ce59
    test edx, edx                                # 0040ce60
    je.d8 L_0040ce71                             # 0040ce62
    # block 0x0040ce64: entered by fall-through of je at 0x0040ce62, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040ce71
    push 0x63888b                                # 0040ce64
    call FUN_0044a2b7                            # 0040ce69
    add esp, 0x4                                 # 0040ce6e
L_0040ce71:
    # block 0x0040ce71: entered by je at 0x0040ce62, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00410a68
    mov ecx, 0x5cf659                            # 0040ce71
    call FUN_004c97b4                            # 0040ce76
    jmp.d32 L_00410a68                           # 0040ce7b
L_0040ce80:
    # block 0x0040ce80: entered by jne at 0x0040ce22, 52 instruction(s), falls into the block at 0x0040cf46
    mov edi, 0x53f6f4                            # 0040ce80
    or ecx, -0x1                                 # 0040ce85
    {load} xor eax, eax                          # 0040ce88
    repne scasb al, byte ptr es:[edi]            # 0040ce8a
    not ecx                                      # 0040ce8c
    add ecx, -0x1                                # 0040ce8e
    mov ax, word ptr [ebp - local_118]           # 0040ce91
    {load} sub ax, cx                            # 0040ce98
    mov word ptr [ebp - local_118], ax           # 0040ce9b
    movsx ecx, word ptr [ebp - local_118]        # 0040cea2
    mov esi, dword ptr [ebp - local_20]          # 0040cea9
    movsx edx, word ptr [0x5c39e3]               # 0040ceac
    imul edx, edx, 0x8d                          # 0040ceb3
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040ceb9
    {load} mov eax, ecx                          # 0040cebf
    shr ecx, 0x2                                 # 0040cec1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040cec4
    {load} mov ecx, eax                          # 0040cec6
    and ecx, 0x3                                 # 0040cec8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040cecb
    movsx ecx, word ptr [0x5c39e3]               # 0040cecd
    imul ecx, ecx, 0x8d                          # 0040ced4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040ceda
    mov dword ptr [ebp - local_114], edx         # 0040cee0
    mov edi, 0x53f6f8                            # 0040cee6
    or ecx, -0x1                                 # 0040ceeb
    {load} xor eax, eax                          # 0040ceee
    repne scasb al, byte ptr es:[edi]            # 0040cef0
    not ecx                                      # 0040cef2
    add ecx, -0x1                                # 0040cef4
    mov esi, 0x53f6fc                            # 0040cef7
    mov eax, dword ptr [ebp - local_114]         # 0040cefc
    movsx edx, word ptr [eax + field_a]          # 0040cf02
    mov eax, dword ptr [ebp - local_114]         # 0040cf06
    lea edi, [eax + edx + field_c]               # 0040cf0c
    {load} mov edx, ecx                          # 0040cf10
    shr ecx, 0x2                                 # 0040cf12
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040cf15
    {load} mov ecx, edx                          # 0040cf17
    and ecx, 0x3                                 # 0040cf19
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040cf1c
    mov edi, 0x53f700                            # 0040cf1e
    or ecx, -0x1                                 # 0040cf23
    {load} xor eax, eax                          # 0040cf26
    repne scasb al, byte ptr es:[edi]            # 0040cf28
    not ecx                                      # 0040cf2a
    add ecx, -0x1                                # 0040cf2c
    mov eax, dword ptr [ebp - local_114]         # 0040cf2f
    mov dx, word ptr [eax + field_a]             # 0040cf35
    {load} add dx, cx                            # 0040cf39
    mov eax, dword ptr [ebp - local_114]         # 0040cf3c
    mov word ptr [eax + field_a], dx             # 0040cf42
L_0040cf46:
    # block 0x0040cf46: entered by jmp at 0x0040cd5d, 11 instruction(s), ends with je to 0x0040cf82 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040cf46
    mov edx, dword ptr [ebp - local_cc]          # 0040cf4d
    {load} add edx, ecx                          # 0040cf53
    mov dword ptr [ebp - local_cc], edx          # 0040cf55
    movsx eax, word ptr [ebp - local_118]        # 0040cf5b
    mov ecx, dword ptr [ebp - local_20]          # 0040cf62
    {load} add ecx, eax                          # 0040cf65
    mov dword ptr [ebp - local_20], ecx          # 0040cf67
    movsx edx, word ptr [0x63a4cd]               # 0040cf6a
    test edx, edx                                # 0040cf71
    je.d8 L_0040cf82                             # 0040cf73
    # block 0x0040cf75: entered by fall-through of je at 0x0040cf73, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040cf82
    push 0x53f704                                # 0040cf75
    call FUN_0044a2b7                            # 0040cf7a
    add esp, 0x4                                 # 0040cf7f
L_0040cf82:
    # block 0x0040cf82: entered by je at 0x0040cf73, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040cf82
L_0040cf87:
    # block 0x0040cf87: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040cffc (forward)
    push 0x1                                     # 0040cf87
    call FUN_0051dc43                            # 0040cf89
    add esp, 0x4                                 # 0040cf8e
    mov dword ptr [ebp - local_18c], eax         # 0040cf91
    movsx eax, word ptr [0x5c39e3]               # 0040cf97
    imul eax, eax, 0x8d                          # 0040cf9e
    mov ecx, dword ptr [ebp - local_18c]         # 0040cfa4
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040cfaa
    cmp dword ptr [ebp - local_18c], 0x0         # 0040cfb0
    jne.d8 L_0040cffc                            # 0040cfb7
    # block 0x0040cfb9: entered by fall-through of jne at 0x0040cfb7, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040cfb9
    push edx                                     # 0040cfc0
    mov eax, dword ptr [0x5bb57b]                # 0040cfc1
    push eax                                     # 0040cfc6
    push 0x53f73c                                # 0040cfc7
    push 0x63888b                                # 0040cfcc
    call FUN_0050ca3e                            # 0040cfd1
    add esp, 0x10                                # 0040cfd6
    push 0x63888b                                # 0040cfd9
    push 0x53f768                                # 0040cfde
    mov ecx, 0x583979                            # 0040cfe3
    call FUN_0042639d                            # 0040cfe8
    mov ecx, 0x5cf659                            # 0040cfed
    call FUN_004c97b4                            # 0040cff2
    jmp.d32 L_00410c9e                           # 0040cff7
L_0040cffc:
    # block 0x0040cffc: entered by jne at 0x0040cfb7, 15 instruction(s), ends with je to 0x0040d046 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040cffc
    imul ecx, ecx, 0x8d                          # 0040d003
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040d009
    mov eax, dword ptr [ebp - local_20]          # 0040d00f
    mov cl, byte ptr [eax]                       # 0040d012
    mov byte ptr [edx], cl                       # 0040d014
    mov edx, dword ptr [ebp - local_cc]          # 0040d016
    add edx, 0x1                                 # 0040d01c
    mov dword ptr [ebp - local_cc], edx          # 0040d01f
    mov eax, dword ptr [ebp - local_20]          # 0040d025
    add eax, 0x1                                 # 0040d028
    mov dword ptr [ebp - local_20], eax          # 0040d02b
    movsx ecx, word ptr [0x63a4cd]               # 0040d02e
    test ecx, ecx                                # 0040d035
    je.d8 L_0040d046                             # 0040d037
    # block 0x0040d039: entered by fall-through of je at 0x0040d037, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d046
    push 0x53f784                                # 0040d039
    call FUN_0044a2b7                            # 0040d03e
    add esp, 0x4                                 # 0040d043
L_0040d046:
    # block 0x0040d046: entered by je at 0x0040d037, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d046
L_0040d04b:
    # block 0x0040d04b: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d0c1 (forward)
    push 0x5                                     # 0040d04b
    call FUN_0051dc43                            # 0040d04d
    add esp, 0x4                                 # 0040d052
    mov dword ptr [ebp - local_190], eax         # 0040d055
    movsx edx, word ptr [0x5c39e3]               # 0040d05b
    imul edx, edx, 0x8d                          # 0040d062
    mov eax, dword ptr [ebp - local_190]         # 0040d068
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040d06e
    cmp dword ptr [ebp - local_190], 0x0         # 0040d074
    jne.d8 L_0040d0c1                            # 0040d07b
    # block 0x0040d07d: entered by fall-through of jne at 0x0040d07b, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040d07d
    push ecx                                     # 0040d084
    mov edx, dword ptr [0x5bb57b]                # 0040d085
    push edx                                     # 0040d08b
    push 0x53f7b4                                # 0040d08c
    push 0x63888b                                # 0040d091
    call FUN_0050ca3e                            # 0040d096
    add esp, 0x10                                # 0040d09b
    push 0x63888b                                # 0040d09e
    push 0x53f7e0                                # 0040d0a3
    mov ecx, 0x583979                            # 0040d0a8
    call FUN_0042639d                            # 0040d0ad
    mov ecx, 0x5cf659                            # 0040d0b2
    call FUN_004c97b4                            # 0040d0b7
    jmp.d32 L_00410c9e                           # 0040d0bc
L_0040d0c1:
    # block 0x0040d0c1: entered by jne at 0x0040d07b, 17 instruction(s), ends with je to 0x0040d111 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040d0c1
    imul eax, eax, 0x8d                          # 0040d0c8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040d0ce
    mov edx, dword ptr [ebp - local_20]          # 0040d0d4
    mov eax, dword ptr [edx]                     # 0040d0d7
    mov dword ptr [ecx], eax                     # 0040d0d9
    mov dl, byte ptr [edx + field_4]             # 0040d0db
    mov byte ptr [ecx + field_4], dl             # 0040d0de
    mov eax, dword ptr [ebp - local_cc]          # 0040d0e1
    add eax, 0x5                                 # 0040d0e7
    mov dword ptr [ebp - local_cc], eax          # 0040d0ea
    mov ecx, dword ptr [ebp - local_20]          # 0040d0f0
    add ecx, 0x5                                 # 0040d0f3
    mov dword ptr [ebp - local_20], ecx          # 0040d0f6
    movsx edx, word ptr [0x63a4cd]               # 0040d0f9
    test edx, edx                                # 0040d100
    je.d8 L_0040d111                             # 0040d102
    # block 0x0040d104: entered by fall-through of je at 0x0040d102, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d111
    push 0x53f7fc                                # 0040d104
    call FUN_0044a2b7                            # 0040d109
    add esp, 0x4                                 # 0040d10e
L_0040d111:
    # block 0x0040d111: entered by je at 0x0040d102, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d111
L_0040d116:
    # block 0x0040d116: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d18b (forward)
    push 0x1                                     # 0040d116
    call FUN_0051dc43                            # 0040d118
    add esp, 0x4                                 # 0040d11d
    mov dword ptr [ebp - local_194], eax         # 0040d120
    movsx eax, word ptr [0x5c39e3]               # 0040d126
    imul eax, eax, 0x8d                          # 0040d12d
    mov ecx, dword ptr [ebp - local_194]         # 0040d133
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040d139
    cmp dword ptr [ebp - local_194], 0x0         # 0040d13f
    jne.d8 L_0040d18b                            # 0040d146
    # block 0x0040d148: entered by fall-through of jne at 0x0040d146, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040d148
    push edx                                     # 0040d14f
    mov eax, dword ptr [0x5bb57b]                # 0040d150
    push eax                                     # 0040d155
    push 0x53f830                                # 0040d156
    push 0x63888b                                # 0040d15b
    call FUN_0050ca3e                            # 0040d160
    add esp, 0x10                                # 0040d165
    push 0x63888b                                # 0040d168
    push 0x53f85c                                # 0040d16d
    mov ecx, 0x583979                            # 0040d172
    call FUN_0042639d                            # 0040d177
    mov ecx, 0x5cf659                            # 0040d17c
    call FUN_004c97b4                            # 0040d181
    jmp.d32 L_00410c9e                           # 0040d186
L_0040d18b:
    # block 0x0040d18b: entered by jne at 0x0040d146, 15 instruction(s), ends with je to 0x0040d1d5 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040d18b
    imul ecx, ecx, 0x8d                          # 0040d192
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040d198
    mov eax, dword ptr [ebp - local_20]          # 0040d19e
    mov cl, byte ptr [eax]                       # 0040d1a1
    mov byte ptr [edx], cl                       # 0040d1a3
    mov edx, dword ptr [ebp - local_cc]          # 0040d1a5
    add edx, 0x1                                 # 0040d1ab
    mov dword ptr [ebp - local_cc], edx          # 0040d1ae
    mov eax, dword ptr [ebp - local_20]          # 0040d1b4
    add eax, 0x1                                 # 0040d1b7
    mov dword ptr [ebp - local_20], eax          # 0040d1ba
    movsx ecx, word ptr [0x63a4cd]               # 0040d1bd
    test ecx, ecx                                # 0040d1c4
    je.d8 L_0040d1d5                             # 0040d1c6
    # block 0x0040d1c8: entered by fall-through of je at 0x0040d1c6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d1d5
    push 0x53f878                                # 0040d1c8
    call FUN_0044a2b7                            # 0040d1cd
    add esp, 0x4                                 # 0040d1d2
L_0040d1d5:
    # block 0x0040d1d5: entered by je at 0x0040d1c6, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d1d5
L_0040d1da:
    # block 0x0040d1da: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d250 (forward)
    push 0x1                                     # 0040d1da
    call FUN_0051dc43                            # 0040d1dc
    add esp, 0x4                                 # 0040d1e1
    mov dword ptr [ebp - local_198], eax         # 0040d1e4
    movsx edx, word ptr [0x5c39e3]               # 0040d1ea
    imul edx, edx, 0x8d                          # 0040d1f1
    mov eax, dword ptr [ebp - local_198]         # 0040d1f7
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040d1fd
    cmp dword ptr [ebp - local_198], 0x0         # 0040d203
    jne.d8 L_0040d250                            # 0040d20a
    # block 0x0040d20c: entered by fall-through of jne at 0x0040d20a, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040d20c
    push ecx                                     # 0040d213
    mov edx, dword ptr [0x5bb57b]                # 0040d214
    push edx                                     # 0040d21a
    push 0x53f8b0                                # 0040d21b
    push 0x63888b                                # 0040d220
    call FUN_0050ca3e                            # 0040d225
    add esp, 0x10                                # 0040d22a
    push 0x63888b                                # 0040d22d
    push 0x53f8dc                                # 0040d232
    mov ecx, 0x583979                            # 0040d237
    call FUN_0042639d                            # 0040d23c
    mov ecx, 0x5cf659                            # 0040d241
    call FUN_004c97b4                            # 0040d246
    jmp.d32 L_00410c9e                           # 0040d24b
L_0040d250:
    # block 0x0040d250: entered by jne at 0x0040d20a, 15 instruction(s), ends with je to 0x0040d29a (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040d250
    imul eax, eax, 0x8d                          # 0040d257
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040d25d
    mov edx, dword ptr [ebp - local_20]          # 0040d263
    mov al, byte ptr [edx]                       # 0040d266
    mov byte ptr [ecx], al                       # 0040d268
    mov ecx, dword ptr [ebp - local_cc]          # 0040d26a
    add ecx, 0x1                                 # 0040d270
    mov dword ptr [ebp - local_cc], ecx          # 0040d273
    mov edx, dword ptr [ebp - local_20]          # 0040d279
    add edx, 0x1                                 # 0040d27c
    mov dword ptr [ebp - local_20], edx          # 0040d27f
    movsx eax, word ptr [0x63a4cd]               # 0040d282
    test eax, eax                                # 0040d289
    je.d8 L_0040d29a                             # 0040d28b
    # block 0x0040d28d: entered by fall-through of je at 0x0040d28b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d29a
    push 0x53f8f8                                # 0040d28d
    call FUN_0044a2b7                            # 0040d292
    add esp, 0x4                                 # 0040d297
L_0040d29a:
    # block 0x0040d29a: entered by je at 0x0040d28b, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d29a
L_0040d29f:
    # block 0x0040d29f: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d315 (forward)
    push 0x1                                     # 0040d29f
    call FUN_0051dc43                            # 0040d2a1
    add esp, 0x4                                 # 0040d2a6
    mov dword ptr [ebp - local_19c], eax         # 0040d2a9
    movsx ecx, word ptr [0x5c39e3]               # 0040d2af
    imul ecx, ecx, 0x8d                          # 0040d2b6
    mov edx, dword ptr [ebp - local_19c]         # 0040d2bc
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040d2c2
    cmp dword ptr [ebp - local_19c], 0x0         # 0040d2c8
    jne.d8 L_0040d315                            # 0040d2cf
    # block 0x0040d2d1: entered by fall-through of jne at 0x0040d2cf, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040d2d1
    push eax                                     # 0040d2d8
    mov ecx, dword ptr [0x5bb57b]                # 0040d2d9
    push ecx                                     # 0040d2df
    push 0x53f934                                # 0040d2e0
    push 0x63888b                                # 0040d2e5
    call FUN_0050ca3e                            # 0040d2ea
    add esp, 0x10                                # 0040d2ef
    push 0x63888b                                # 0040d2f2
    push 0x53f960                                # 0040d2f7
    mov ecx, 0x583979                            # 0040d2fc
    call FUN_0042639d                            # 0040d301
    mov ecx, 0x5cf659                            # 0040d306
    call FUN_004c97b4                            # 0040d30b
    jmp.d32 L_00410c9e                           # 0040d310
L_0040d315:
    # block 0x0040d315: entered by jne at 0x0040d2cf, 15 instruction(s), ends with je to 0x0040d35f (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040d315
    imul edx, edx, 0x8d                          # 0040d31c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040d322
    mov ecx, dword ptr [ebp - local_20]          # 0040d328
    mov dl, byte ptr [ecx]                       # 0040d32b
    mov byte ptr [eax], dl                       # 0040d32d
    mov eax, dword ptr [ebp - local_cc]          # 0040d32f
    add eax, 0x1                                 # 0040d335
    mov dword ptr [ebp - local_cc], eax          # 0040d338
    mov ecx, dword ptr [ebp - local_20]          # 0040d33e
    add ecx, 0x1                                 # 0040d341
    mov dword ptr [ebp - local_20], ecx          # 0040d344
    movsx edx, word ptr [0x63a4cd]               # 0040d347
    test edx, edx                                # 0040d34e
    je.d8 L_0040d35f                             # 0040d350
    # block 0x0040d352: entered by fall-through of je at 0x0040d350, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d35f
    push 0x53f97c                                # 0040d352
    call FUN_0044a2b7                            # 0040d357
    add esp, 0x4                                 # 0040d35c
L_0040d35f:
    # block 0x0040d35f: entered by je at 0x0040d350, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d35f
L_0040d364:
    # block 0x0040d364: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d3d9 (forward)
    push 0x1                                     # 0040d364
    call FUN_0051dc43                            # 0040d366
    add esp, 0x4                                 # 0040d36b
    mov dword ptr [ebp - local_1a0], eax         # 0040d36e
    movsx eax, word ptr [0x5c39e3]               # 0040d374
    imul eax, eax, 0x8d                          # 0040d37b
    mov ecx, dword ptr [ebp - local_1a0]         # 0040d381
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040d387
    cmp dword ptr [ebp - local_1a0], 0x0         # 0040d38d
    jne.d8 L_0040d3d9                            # 0040d394
    # block 0x0040d396: entered by fall-through of jne at 0x0040d394, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040d396
    push edx                                     # 0040d39d
    mov eax, dword ptr [0x5bb57b]                # 0040d39e
    push eax                                     # 0040d3a3
    push 0x53f9b8                                # 0040d3a4
    push 0x63888b                                # 0040d3a9
    call FUN_0050ca3e                            # 0040d3ae
    add esp, 0x10                                # 0040d3b3
    push 0x63888b                                # 0040d3b6
    push 0x53f9e4                                # 0040d3bb
    mov ecx, 0x583979                            # 0040d3c0
    call FUN_0042639d                            # 0040d3c5
    mov ecx, 0x5cf659                            # 0040d3ca
    call FUN_004c97b4                            # 0040d3cf
    jmp.d32 L_00410c9e                           # 0040d3d4
L_0040d3d9:
    # block 0x0040d3d9: entered by jne at 0x0040d394, 15 instruction(s), ends with je to 0x0040d423 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040d3d9
    imul ecx, ecx, 0x8d                          # 0040d3e0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040d3e6
    mov eax, dword ptr [ebp - local_20]          # 0040d3ec
    mov cl, byte ptr [eax]                       # 0040d3ef
    mov byte ptr [edx], cl                       # 0040d3f1
    mov edx, dword ptr [ebp - local_cc]          # 0040d3f3
    add edx, 0x1                                 # 0040d3f9
    mov dword ptr [ebp - local_cc], edx          # 0040d3fc
    mov eax, dword ptr [ebp - local_20]          # 0040d402
    add eax, 0x1                                 # 0040d405
    mov dword ptr [ebp - local_20], eax          # 0040d408
    movsx ecx, word ptr [0x63a4cd]               # 0040d40b
    test ecx, ecx                                # 0040d412
    je.d8 L_0040d423                             # 0040d414
    # block 0x0040d416: entered by fall-through of je at 0x0040d414, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d423
    push 0x53fa00                                # 0040d416
    call FUN_0044a2b7                            # 0040d41b
    add esp, 0x4                                 # 0040d420
L_0040d423:
    # block 0x0040d423: entered by je at 0x0040d414, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d423
L_0040d428:
    # block 0x0040d428: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d49e (forward)
    push 0x1                                     # 0040d428
    call FUN_0051dc43                            # 0040d42a
    add esp, 0x4                                 # 0040d42f
    mov dword ptr [ebp - local_1a4], eax         # 0040d432
    movsx edx, word ptr [0x5c39e3]               # 0040d438
    imul edx, edx, 0x8d                          # 0040d43f
    mov eax, dword ptr [ebp - local_1a4]         # 0040d445
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040d44b
    cmp dword ptr [ebp - local_1a4], 0x0         # 0040d451
    jne.d8 L_0040d49e                            # 0040d458
    # block 0x0040d45a: entered by fall-through of jne at 0x0040d458, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040d45a
    push ecx                                     # 0040d461
    mov edx, dword ptr [0x5bb57b]                # 0040d462
    push edx                                     # 0040d468
    push 0x53fa38                                # 0040d469
    push 0x63888b                                # 0040d46e
    call FUN_0050ca3e                            # 0040d473
    add esp, 0x10                                # 0040d478
    push 0x63888b                                # 0040d47b
    push 0x53fa64                                # 0040d480
    mov ecx, 0x583979                            # 0040d485
    call FUN_0042639d                            # 0040d48a
    mov ecx, 0x5cf659                            # 0040d48f
    call FUN_004c97b4                            # 0040d494
    jmp.d32 L_00410c9e                           # 0040d499
L_0040d49e:
    # block 0x0040d49e: entered by jne at 0x0040d458, 15 instruction(s), ends with je to 0x0040d4e8 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040d49e
    imul eax, eax, 0x8d                          # 0040d4a5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040d4ab
    mov edx, dword ptr [ebp - local_20]          # 0040d4b1
    mov al, byte ptr [edx]                       # 0040d4b4
    mov byte ptr [ecx], al                       # 0040d4b6
    mov ecx, dword ptr [ebp - local_cc]          # 0040d4b8
    add ecx, 0x1                                 # 0040d4be
    mov dword ptr [ebp - local_cc], ecx          # 0040d4c1
    mov edx, dword ptr [ebp - local_20]          # 0040d4c7
    add edx, 0x1                                 # 0040d4ca
    mov dword ptr [ebp - local_20], edx          # 0040d4cd
    movsx eax, word ptr [0x63a4cd]               # 0040d4d0
    test eax, eax                                # 0040d4d7
    je.d8 L_0040d4e8                             # 0040d4d9
    # block 0x0040d4db: entered by fall-through of je at 0x0040d4d9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d4e8
    push 0x53fa80                                # 0040d4db
    call FUN_0044a2b7                            # 0040d4e0
    add esp, 0x4                                 # 0040d4e5
L_0040d4e8:
    # block 0x0040d4e8: entered by je at 0x0040d4d9, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d4e8
L_0040d4ed:
    # block 0x0040d4ed: entered by switch case, 6 instruction(s), ends with jle to 0x0040d55a (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0040d4ed
    mov dword ptr [ebp - local_8], ecx           # 0040d4f0
    mov edx, dword ptr [ebp - local_8]           # 0040d4f3
    movsx eax, word ptr [edx + field_c2]         # 0040d4f6
    cmp eax, 0xa                                 # 0040d4fd
    jle.d8 L_0040d55a                            # 0040d500
    # block 0x0040d502: entered by fall-through of jle at 0x0040d500, 17 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0040d555 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040d502
    push ecx                                     # 0040d509
    mov edx, dword ptr [0x5bb57b]                # 0040d50a
    push edx                                     # 0040d510
    mov eax, dword ptr [ebp - local_8]           # 0040d511
    movsx ecx, word ptr [eax + field_c2]         # 0040d514
    push ecx                                     # 0040d51b
    push 0x53fab0                                # 0040d51c
    push 0x63888b                                # 0040d521
    call FUN_0050ca3e                            # 0040d526
    add esp, 0x14                                # 0040d52b
    push 0x63888b                                # 0040d52e
    mov ecx, 0x583979                            # 0040d533
    call FUN_004264e8                            # 0040d538
    movsx edx, word ptr [0x63a4cd]               # 0040d53d
    test edx, edx                                # 0040d544
    je.d8 L_0040d555                             # 0040d546
    # block 0x0040d548: entered by fall-through of je at 0x0040d546, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d555
    push 0x63888b                                # 0040d548
    call FUN_0044a2b7                            # 0040d54d
    add esp, 0x4                                 # 0040d552
L_0040d555:
    # block 0x0040d555: entered by je at 0x0040d546, 1 instruction(s), ends with forward jump to 0x00410c9e
    jmp.d32 L_00410c9e                           # 0040d555
L_0040d55a:
    # block 0x0040d55a: entered by jle at 0x0040d500, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d5fe (forward)
    mov eax, dword ptr [ebp - local_8]           # 0040d55a
    movsx ecx, word ptr [eax + field_c2]         # 0040d55d
    shl ecx, 0x2                                 # 0040d564
    mov word ptr [ebp - local_140], cx           # 0040d567
    movsx edx, word ptr [ebp - local_140]        # 0040d56e
    add edx, 0xc4                                # 0040d575
    mov word ptr [ebp - local_118], dx           # 0040d57b
    movsx eax, word ptr [ebp - local_118]        # 0040d582
    push eax                                     # 0040d589
    call FUN_0051dc43                            # 0040d58a
    add esp, 0x4                                 # 0040d58f
    mov dword ptr [ebp - local_1a8], eax         # 0040d592
    movsx ecx, word ptr [0x5c39e3]               # 0040d598
    imul ecx, ecx, 0x8d                          # 0040d59f
    mov edx, dword ptr [ebp - local_1a8]         # 0040d5a5
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040d5ab
    cmp dword ptr [ebp - local_1a8], 0x0         # 0040d5b1
    jne.d8 L_0040d5fe                            # 0040d5b8
    # block 0x0040d5ba: entered by fall-through of jne at 0x0040d5b8, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040d5ba
    push eax                                     # 0040d5c1
    mov ecx, dword ptr [0x5bb57b]                # 0040d5c2
    push ecx                                     # 0040d5c8
    push 0x53fb18                                # 0040d5c9
    push 0x63888b                                # 0040d5ce
    call FUN_0050ca3e                            # 0040d5d3
    add esp, 0x10                                # 0040d5d8
    push 0x63888b                                # 0040d5db
    push 0x53fb44                                # 0040d5e0
    mov ecx, 0x583979                            # 0040d5e5
    call FUN_0042639d                            # 0040d5ea
    mov ecx, 0x5cf659                            # 0040d5ef
    call FUN_004c97b4                            # 0040d5f4
    jmp.d32 L_00410c9e                           # 0040d5f9
L_0040d5fe:
    # block 0x0040d5fe: entered by jne at 0x0040d5b8, 35 instruction(s), ends with je to 0x0040d6a5 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040d5fe
    imul edx, edx, 0x8d                          # 0040d605
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040d60b
    mov ecx, 0x31                                # 0040d611
    mov esi, dword ptr [ebp - local_20]          # 0040d616
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040d619
    mov eax, dword ptr [ebp - local_cc]          # 0040d61b
    add eax, 0xc4                                # 0040d621
    mov dword ptr [ebp - local_cc], eax          # 0040d626
    mov ecx, dword ptr [ebp - local_20]          # 0040d62c
    add ecx, 0xc4                                # 0040d62f
    mov dword ptr [ebp - local_20], ecx          # 0040d635
    movsx ecx, word ptr [ebp - local_140]        # 0040d638
    mov esi, dword ptr [ebp - local_20]          # 0040d63f
    movsx edx, word ptr [0x5c39e3]               # 0040d642
    imul edx, edx, 0x8d                          # 0040d649
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040d64f
    add edi, 0xc4                                # 0040d655
    {load} mov eax, ecx                          # 0040d65b
    shr ecx, 0x2                                 # 0040d65d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040d660
    {load} mov ecx, eax                          # 0040d662
    and ecx, 0x3                                 # 0040d664
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040d667
    movsx ecx, word ptr [ebp - local_140]        # 0040d669
    mov edx, dword ptr [ebp - local_cc]          # 0040d670
    {load} add edx, ecx                          # 0040d676
    mov dword ptr [ebp - local_cc], edx          # 0040d678
    movsx eax, word ptr [ebp - local_140]        # 0040d67e
    mov ecx, dword ptr [ebp - local_20]          # 0040d685
    {load} add ecx, eax                          # 0040d688
    mov dword ptr [ebp - local_20], ecx          # 0040d68a
    movsx edx, word ptr [0x63a4cd]               # 0040d68d
    test edx, edx                                # 0040d694
    je.d8 L_0040d6a5                             # 0040d696
    # block 0x0040d698: entered by fall-through of je at 0x0040d696, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d6a5
    push 0x53fb60                                # 0040d698
    call FUN_0044a2b7                            # 0040d69d
    add esp, 0x4                                 # 0040d6a2
L_0040d6a5:
    # block 0x0040d6a5: entered by je at 0x0040d696, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d6a5
L_0040d6aa:
    # block 0x0040d6aa: entered by switch case, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d740 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040d6aa
    mov dword ptr [ebp - local_c], eax           # 0040d6ad
    mov ecx, dword ptr [ebp - local_c]           # 0040d6b0
    movsx edx, word ptr [ecx + field_28]         # 0040d6b3
    imul edx, edx, 0x12                          # 0040d6b7
    add edx, 0x2a                                # 0040d6ba
    mov word ptr [ebp - local_118], dx           # 0040d6bd
    movsx eax, word ptr [ebp - local_118]        # 0040d6c4
    push eax                                     # 0040d6cb
    call FUN_0051dc43                            # 0040d6cc
    add esp, 0x4                                 # 0040d6d1
    mov dword ptr [ebp - local_1ac], eax         # 0040d6d4
    movsx ecx, word ptr [0x5c39e3]               # 0040d6da
    imul ecx, ecx, 0x8d                          # 0040d6e1
    mov edx, dword ptr [ebp - local_1ac]         # 0040d6e7
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040d6ed
    cmp dword ptr [ebp - local_1ac], 0x0         # 0040d6f3
    jne.d8 L_0040d740                            # 0040d6fa
    # block 0x0040d6fc: entered by fall-through of jne at 0x0040d6fa, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040d6fc
    push eax                                     # 0040d703
    mov ecx, dword ptr [0x5bb57b]                # 0040d704
    push ecx                                     # 0040d70a
    push 0x53fb90                                # 0040d70b
    push 0x63888b                                # 0040d710
    call FUN_0050ca3e                            # 0040d715
    add esp, 0x10                                # 0040d71a
    push 0x63888b                                # 0040d71d
    push 0x53fbbc                                # 0040d722
    mov ecx, 0x583979                            # 0040d727
    call FUN_0042639d                            # 0040d72c
    mov ecx, 0x5cf659                            # 0040d731
    call FUN_004c97b4                            # 0040d736
    jmp.d32 L_00410c9e                           # 0040d73b
L_0040d740:
    # block 0x0040d740: entered by jne at 0x0040d6fa, 22 instruction(s), ends with je to 0x0040d7a7 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040d740
    mov esi, dword ptr [ebp - local_20]          # 0040d747
    movsx edx, word ptr [0x5c39e3]               # 0040d74a
    imul edx, edx, 0x8d                          # 0040d751
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040d757
    {load} mov eax, ecx                          # 0040d75d
    shr ecx, 0x2                                 # 0040d75f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040d762
    {load} mov ecx, eax                          # 0040d764
    and ecx, 0x3                                 # 0040d766
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040d769
    movsx ecx, word ptr [ebp - local_118]        # 0040d76b
    mov edx, dword ptr [ebp - local_cc]          # 0040d772
    {load} add edx, ecx                          # 0040d778
    mov dword ptr [ebp - local_cc], edx          # 0040d77a
    movsx eax, word ptr [ebp - local_118]        # 0040d780
    mov ecx, dword ptr [ebp - local_20]          # 0040d787
    {load} add ecx, eax                          # 0040d78a
    mov dword ptr [ebp - local_20], ecx          # 0040d78c
    movsx edx, word ptr [0x63a4cd]               # 0040d78f
    test edx, edx                                # 0040d796
    je.d8 L_0040d7a7                             # 0040d798
    # block 0x0040d79a: entered by fall-through of je at 0x0040d798, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d7a7
    push 0x53fbd8                                # 0040d79a
    call FUN_0044a2b7                            # 0040d79f
    add esp, 0x4                                 # 0040d7a4
L_0040d7a7:
    # block 0x0040d7a7: entered by je at 0x0040d798, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d7a7
L_0040d7ac:
    # block 0x0040d7ac: entered by switch case, 17 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d842 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040d7ac
    movsx cx, byte ptr [eax]                     # 0040d7af
    mov word ptr [ebp - local_18], cx            # 0040d7b3
    movsx edx, word ptr [ebp - local_18]         # 0040d7b7
    lea eax, [edx + edx + field_2]               # 0040d7bb
    mov word ptr [ebp - local_118], ax           # 0040d7bf
    movsx ecx, word ptr [ebp - local_118]        # 0040d7c6
    push ecx                                     # 0040d7cd
    call FUN_0051dc43                            # 0040d7ce
    add esp, 0x4                                 # 0040d7d3
    mov dword ptr [ebp - local_1b0], eax         # 0040d7d6
    movsx edx, word ptr [0x5c39e3]               # 0040d7dc
    imul edx, edx, 0x8d                          # 0040d7e3
    mov eax, dword ptr [ebp - local_1b0]         # 0040d7e9
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040d7ef
    cmp dword ptr [ebp - local_1b0], 0x0         # 0040d7f5
    jne.d8 L_0040d842                            # 0040d7fc
    # block 0x0040d7fe: entered by fall-through of jne at 0x0040d7fc, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040d7fe
    push ecx                                     # 0040d805
    mov edx, dword ptr [0x5bb57b]                # 0040d806
    push edx                                     # 0040d80c
    push 0x53fc00                                # 0040d80d
    push 0x63888b                                # 0040d812
    call FUN_0050ca3e                            # 0040d817
    add esp, 0x10                                # 0040d81c
    push 0x63888b                                # 0040d81f
    push 0x53fc2c                                # 0040d824
    mov ecx, 0x583979                            # 0040d829
    call FUN_0042639d                            # 0040d82e
    mov ecx, 0x5cf659                            # 0040d833
    call FUN_004c97b4                            # 0040d838
    jmp.d32 L_00410c9e                           # 0040d83d
L_0040d842:
    # block 0x0040d842: entered by jne at 0x0040d7fc, 20 instruction(s), ends with forward jump to 0x00410a68
    movsx ecx, word ptr [ebp - local_118]        # 0040d842
    mov esi, dword ptr [ebp - local_20]          # 0040d849
    movsx eax, word ptr [0x5c39e3]               # 0040d84c
    imul eax, eax, 0x8d                          # 0040d853
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040d859
    {load} mov edx, ecx                          # 0040d85f
    shr ecx, 0x2                                 # 0040d861
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040d864
    {load} mov ecx, edx                          # 0040d866
    and ecx, 0x3                                 # 0040d868
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040d86b
    movsx eax, word ptr [ebp - local_118]        # 0040d86d
    mov ecx, dword ptr [ebp - local_cc]          # 0040d874
    {load} add ecx, eax                          # 0040d87a
    mov dword ptr [ebp - local_cc], ecx          # 0040d87c
    movsx edx, word ptr [ebp - local_118]        # 0040d882
    mov eax, dword ptr [ebp - local_20]          # 0040d889
    {load} add eax, edx                          # 0040d88c
    mov dword ptr [ebp - local_20], eax          # 0040d88e
    jmp.d32 L_00410a68                           # 0040d891
L_0040d896:
    # block 0x0040d896: entered by switch case, 6 instruction(s), ends with jne to 0x0040d8cc (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040d896
    imul ecx, ecx, 0x8d                          # 0040d89d
    {load} xor edx, edx                          # 0040d8a3
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040d8a5
    cmp edx, 0x63                                # 0040d8ab
    jne.d8 L_0040d8cc                            # 0040d8ae
    # block 0x0040d8b0: entered by fall-through of jne at 0x0040d8ae, 8 instruction(s), ends with forward jump to 0x0040d8ec
    mov eax, dword ptr [ebp - local_20]          # 0040d8b0
    mov dword ptr [ebp - local_1c], eax          # 0040d8b3
    mov ecx, dword ptr [ebp - local_1c]          # 0040d8b6
    movsx edx, word ptr [ecx + field_2a]         # 0040d8b9
    imul edx, edx, 0x12                          # 0040d8bd
    add edx, 0x2c                                # 0040d8c0
    mov word ptr [ebp - local_118], dx           # 0040d8c3
    jmp.d8 L_0040d8ec                            # 0040d8ca
L_0040d8cc:
    # block 0x0040d8cc: entered by jne at 0x0040d8ae, 7 instruction(s), falls into the block at 0x0040d8ec
    mov eax, dword ptr [ebp - local_20]          # 0040d8cc
    mov dword ptr [ebp - local_130], eax         # 0040d8cf
    mov ecx, dword ptr [ebp - local_130]         # 0040d8d5
    movsx edx, word ptr [ecx + field_a]          # 0040d8db
    imul edx, edx, 0x12                          # 0040d8df
    add edx, 0xc                                 # 0040d8e2
    mov word ptr [ebp - local_118], dx           # 0040d8e5
L_0040d8ec:
    # block 0x0040d8ec: entered by jmp at 0x0040d8ca, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040d968 (forward)
    movsx eax, word ptr [ebp - local_118]        # 0040d8ec
    push eax                                     # 0040d8f3
    call FUN_0051dc43                            # 0040d8f4
    add esp, 0x4                                 # 0040d8f9
    mov dword ptr [ebp - local_1b4], eax         # 0040d8fc
    movsx ecx, word ptr [0x5c39e3]               # 0040d902
    imul ecx, ecx, 0x8d                          # 0040d909
    mov edx, dword ptr [ebp - local_1b4]         # 0040d90f
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040d915
    cmp dword ptr [ebp - local_1b4], 0x0         # 0040d91b
    jne.d8 L_0040d968                            # 0040d922
    # block 0x0040d924: entered by fall-through of jne at 0x0040d922, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040d924
    push eax                                     # 0040d92b
    mov ecx, dword ptr [0x5bb57b]                # 0040d92c
    push ecx                                     # 0040d932
    push 0x53fc48                                # 0040d933
    push 0x63888b                                # 0040d938
    call FUN_0050ca3e                            # 0040d93d
    add esp, 0x10                                # 0040d942
    push 0x63888b                                # 0040d945
    push 0x53fc74                                # 0040d94a
    mov ecx, 0x583979                            # 0040d94f
    call FUN_0042639d                            # 0040d954
    mov ecx, 0x5cf659                            # 0040d959
    call FUN_004c97b4                            # 0040d95e
    jmp.d32 L_00410c9e                           # 0040d963
L_0040d968:
    # block 0x0040d968: entered by jne at 0x0040d922, 22 instruction(s), ends with je to 0x0040d9cf (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040d968
    mov esi, dword ptr [ebp - local_20]          # 0040d96f
    movsx edx, word ptr [0x5c39e3]               # 0040d972
    imul edx, edx, 0x8d                          # 0040d979
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040d97f
    {load} mov eax, ecx                          # 0040d985
    shr ecx, 0x2                                 # 0040d987
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040d98a
    {load} mov ecx, eax                          # 0040d98c
    and ecx, 0x3                                 # 0040d98e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040d991
    movsx ecx, word ptr [ebp - local_118]        # 0040d993
    mov edx, dword ptr [ebp - local_cc]          # 0040d99a
    {load} add edx, ecx                          # 0040d9a0
    mov dword ptr [ebp - local_cc], edx          # 0040d9a2
    movsx eax, word ptr [ebp - local_118]        # 0040d9a8
    mov ecx, dword ptr [ebp - local_20]          # 0040d9af
    {load} add ecx, eax                          # 0040d9b2
    mov dword ptr [ebp - local_20], ecx          # 0040d9b4
    movsx edx, word ptr [0x63a4cd]               # 0040d9b7
    test edx, edx                                # 0040d9be
    je.d8 L_0040d9cf                             # 0040d9c0
    # block 0x0040d9c2: entered by fall-through of je at 0x0040d9c0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040d9cf
    push 0x53fc90                                # 0040d9c2
    call FUN_0044a2b7                            # 0040d9c7
    add esp, 0x4                                 # 0040d9cc
L_0040d9cf:
    # block 0x0040d9cf: entered by je at 0x0040d9c0, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040d9cf
L_0040d9d4:
    # block 0x0040d9d4: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040da49 (forward)
    push 0x28                                    # 0040d9d4
    call FUN_0051dc43                            # 0040d9d6
    add esp, 0x4                                 # 0040d9db
    mov dword ptr [ebp - local_1b8], eax         # 0040d9de
    movsx eax, word ptr [0x5c39e3]               # 0040d9e4
    imul eax, eax, 0x8d                          # 0040d9eb
    mov ecx, dword ptr [ebp - local_1b8]         # 0040d9f1
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040d9f7
    cmp dword ptr [ebp - local_1b8], 0x0         # 0040d9fd
    jne.d8 L_0040da49                            # 0040da04
    # block 0x0040da06: entered by fall-through of jne at 0x0040da04, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040da06
    push edx                                     # 0040da0d
    mov eax, dword ptr [0x5bb57b]                # 0040da0e
    push eax                                     # 0040da13
    push 0x53fcbc                                # 0040da14
    push 0x63888b                                # 0040da19
    call FUN_0050ca3e                            # 0040da1e
    add esp, 0x10                                # 0040da23
    push 0x63888b                                # 0040da26
    push 0x53fce8                                # 0040da2b
    mov ecx, 0x583979                            # 0040da30
    call FUN_0042639d                            # 0040da35
    mov ecx, 0x5cf659                            # 0040da3a
    call FUN_004c97b4                            # 0040da3f
    jmp.d32 L_00410c9e                           # 0040da44
L_0040da49:
    # block 0x0040da49: entered by jne at 0x0040da04, 15 instruction(s), ends with je to 0x0040da96 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040da49
    imul ecx, ecx, 0x8d                          # 0040da50
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040da56
    mov ecx, 0xa                                 # 0040da5c
    mov esi, dword ptr [ebp - local_20]          # 0040da61
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040da64
    mov edx, dword ptr [ebp - local_cc]          # 0040da66
    add edx, 0x28                                # 0040da6c
    mov dword ptr [ebp - local_cc], edx          # 0040da6f
    mov eax, dword ptr [ebp - local_20]          # 0040da75
    add eax, 0x28                                # 0040da78
    mov dword ptr [ebp - local_20], eax          # 0040da7b
    movsx ecx, word ptr [0x63a4cd]               # 0040da7e
    test ecx, ecx                                # 0040da85
    je.d8 L_0040da96                             # 0040da87
    # block 0x0040da89: entered by fall-through of je at 0x0040da87, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040da96
    push 0x53fd04                                # 0040da89
    call FUN_0044a2b7                            # 0040da8e
    add esp, 0x4                                 # 0040da93
L_0040da96:
    # block 0x0040da96: entered by je at 0x0040da87, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040da96
L_0040da9b:
    # block 0x0040da9b: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040db11 (forward)
    push 0x8                                     # 0040da9b
    call FUN_0051dc43                            # 0040da9d
    add esp, 0x4                                 # 0040daa2
    mov dword ptr [ebp - local_1bc], eax         # 0040daa5
    movsx edx, word ptr [0x5c39e3]               # 0040daab
    imul edx, edx, 0x8d                          # 0040dab2
    mov eax, dword ptr [ebp - local_1bc]         # 0040dab8
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040dabe
    cmp dword ptr [ebp - local_1bc], 0x0         # 0040dac4
    jne.d8 L_0040db11                            # 0040dacb
    # block 0x0040dacd: entered by fall-through of jne at 0x0040dacb, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040dacd
    push ecx                                     # 0040dad4
    mov edx, dword ptr [0x5bb57b]                # 0040dad5
    push edx                                     # 0040dadb
    push 0x53fd34                                # 0040dadc
    push 0x63888b                                # 0040dae1
    call FUN_0050ca3e                            # 0040dae6
    add esp, 0x10                                # 0040daeb
    push 0x63888b                                # 0040daee
    push 0x53fd60                                # 0040daf3
    mov ecx, 0x583979                            # 0040daf8
    call FUN_0042639d                            # 0040dafd
    mov ecx, 0x5cf659                            # 0040db02
    call FUN_004c97b4                            # 0040db07
    jmp.d32 L_00410c9e                           # 0040db0c
L_0040db11:
    # block 0x0040db11: entered by jne at 0x0040dacb, 17 instruction(s), ends with je to 0x0040db61 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040db11
    imul eax, eax, 0x8d                          # 0040db18
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040db1e
    mov edx, dword ptr [ebp - local_20]          # 0040db24
    mov eax, dword ptr [edx]                     # 0040db27
    mov dword ptr [ecx], eax                     # 0040db29
    mov edx, dword ptr [edx + field_4]           # 0040db2b
    mov dword ptr [ecx + field_4], edx           # 0040db2e
    mov eax, dword ptr [ebp - local_cc]          # 0040db31
    add eax, 0x8                                 # 0040db37
    mov dword ptr [ebp - local_cc], eax          # 0040db3a
    mov ecx, dword ptr [ebp - local_20]          # 0040db40
    add ecx, 0x8                                 # 0040db43
    mov dword ptr [ebp - local_20], ecx          # 0040db46
    movsx edx, word ptr [0x63a4cd]               # 0040db49
    test edx, edx                                # 0040db50
    je.d8 L_0040db61                             # 0040db52
    # block 0x0040db54: entered by fall-through of je at 0x0040db52, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040db61
    push 0x53fd7c                                # 0040db54
    call FUN_0044a2b7                            # 0040db59
    add esp, 0x4                                 # 0040db5e
L_0040db61:
    # block 0x0040db61: entered by je at 0x0040db52, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040db61
L_0040db66:
    # block 0x0040db66: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040dbde (forward)
    push 0x2db                                   # 0040db66
    call FUN_0051dc43                            # 0040db6b
    add esp, 0x4                                 # 0040db70
    mov dword ptr [ebp - local_1c0], eax         # 0040db73
    movsx eax, word ptr [0x5c39e3]               # 0040db79
    imul eax, eax, 0x8d                          # 0040db80
    mov ecx, dword ptr [ebp - local_1c0]         # 0040db86
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040db8c
    cmp dword ptr [ebp - local_1c0], 0x0         # 0040db92
    jne.d8 L_0040dbde                            # 0040db99
    # block 0x0040db9b: entered by fall-through of jne at 0x0040db99, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040db9b
    push edx                                     # 0040dba2
    mov eax, dword ptr [0x5bb57b]                # 0040dba3
    push eax                                     # 0040dba8
    push 0x53fdb0                                # 0040dba9
    push 0x63888b                                # 0040dbae
    call FUN_0050ca3e                            # 0040dbb3
    add esp, 0x10                                # 0040dbb8
    push 0x63888b                                # 0040dbbb
    push 0x53fddc                                # 0040dbc0
    mov ecx, 0x583979                            # 0040dbc5
    call FUN_0042639d                            # 0040dbca
    mov ecx, 0x5cf659                            # 0040dbcf
    call FUN_004c97b4                            # 0040dbd4
    jmp.d32 L_00410c9e                           # 0040dbd9
L_0040dbde:
    # block 0x0040dbde: entered by jne at 0x0040db99, 17 instruction(s), ends with je to 0x0040dc33 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040dbde
    imul ecx, ecx, 0x8d                          # 0040dbe5
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040dbeb
    mov ecx, 0xb6                                # 0040dbf1
    mov esi, dword ptr [ebp - local_20]          # 0040dbf6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040dbf9
    movsw word ptr es:[edi], word ptr [esi]      # 0040dbfb
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040dbfd
    mov edx, dword ptr [ebp - local_cc]          # 0040dbfe
    add edx, 0x2db                               # 0040dc04
    mov dword ptr [ebp - local_cc], edx          # 0040dc0a
    mov eax, dword ptr [ebp - local_20]          # 0040dc10
    add eax, 0x2db                               # 0040dc13
    mov dword ptr [ebp - local_20], eax          # 0040dc18
    movsx ecx, word ptr [0x63a4cd]               # 0040dc1b
    test ecx, ecx                                # 0040dc22
    je.d8 L_0040dc33                             # 0040dc24
    # block 0x0040dc26: entered by fall-through of je at 0x0040dc24, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040dc33
    push 0x53fdf8                                # 0040dc26
    call FUN_0044a2b7                            # 0040dc2b
    add esp, 0x4                                 # 0040dc30
L_0040dc33:
    # block 0x0040dc33: entered by je at 0x0040dc24, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040dc33
L_0040dc38:
    # block 0x0040dc38: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040dcb1 (forward)
    push 0x317                                   # 0040dc38
    call FUN_0051dc43                            # 0040dc3d
    add esp, 0x4                                 # 0040dc42
    mov dword ptr [ebp - local_1c4], eax         # 0040dc45
    movsx edx, word ptr [0x5c39e3]               # 0040dc4b
    imul edx, edx, 0x8d                          # 0040dc52
    mov eax, dword ptr [ebp - local_1c4]         # 0040dc58
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040dc5e
    cmp dword ptr [ebp - local_1c4], 0x0         # 0040dc64
    jne.d8 L_0040dcb1                            # 0040dc6b
    # block 0x0040dc6d: entered by fall-through of jne at 0x0040dc6b, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040dc6d
    push ecx                                     # 0040dc74
    mov edx, dword ptr [0x5bb57b]                # 0040dc75
    push edx                                     # 0040dc7b
    push 0x53fe2c                                # 0040dc7c
    push 0x63888b                                # 0040dc81
    call FUN_0050ca3e                            # 0040dc86
    add esp, 0x10                                # 0040dc8b
    push 0x63888b                                # 0040dc8e
    push 0x53fe58                                # 0040dc93
    mov ecx, 0x583979                            # 0040dc98
    call FUN_0042639d                            # 0040dc9d
    mov ecx, 0x5cf659                            # 0040dca2
    call FUN_004c97b4                            # 0040dca7
    jmp.d32 L_00410c9e                           # 0040dcac
L_0040dcb1:
    # block 0x0040dcb1: entered by jne at 0x0040dc6b, 17 instruction(s), ends with je to 0x0040dd07 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040dcb1
    imul eax, eax, 0x8d                          # 0040dcb8
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040dcbe
    mov ecx, 0xc5                                # 0040dcc4
    mov esi, dword ptr [ebp - local_20]          # 0040dcc9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040dccc
    movsw word ptr es:[edi], word ptr [esi]      # 0040dcce
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040dcd0
    mov ecx, dword ptr [ebp - local_cc]          # 0040dcd1
    add ecx, 0x317                               # 0040dcd7
    mov dword ptr [ebp - local_cc], ecx          # 0040dcdd
    mov edx, dword ptr [ebp - local_20]          # 0040dce3
    add edx, 0x317                               # 0040dce6
    mov dword ptr [ebp - local_20], edx          # 0040dcec
    movsx eax, word ptr [0x63a4cd]               # 0040dcef
    test eax, eax                                # 0040dcf6
    je.d8 L_0040dd07                             # 0040dcf8
    # block 0x0040dcfa: entered by fall-through of je at 0x0040dcf8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040dd07
    push 0x53fe74                                # 0040dcfa
    call FUN_0044a2b7                            # 0040dcff
    add esp, 0x4                                 # 0040dd04
L_0040dd07:
    # block 0x0040dd07: entered by je at 0x0040dcf8, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040dd07
L_0040dd0c:
    # block 0x0040dd0c: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040dd85 (forward)
    push 0x1ee                                   # 0040dd0c
    call FUN_0051dc43                            # 0040dd11
    add esp, 0x4                                 # 0040dd16
    mov dword ptr [ebp - local_1c8], eax         # 0040dd19
    movsx ecx, word ptr [0x5c39e3]               # 0040dd1f
    imul ecx, ecx, 0x8d                          # 0040dd26
    mov edx, dword ptr [ebp - local_1c8]         # 0040dd2c
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040dd32
    cmp dword ptr [ebp - local_1c8], 0x0         # 0040dd38
    jne.d8 L_0040dd85                            # 0040dd3f
    # block 0x0040dd41: entered by fall-through of jne at 0x0040dd3f, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040dd41
    push eax                                     # 0040dd48
    mov ecx, dword ptr [0x5bb57b]                # 0040dd49
    push ecx                                     # 0040dd4f
    push 0x53feac                                # 0040dd50
    push 0x63888b                                # 0040dd55
    call FUN_0050ca3e                            # 0040dd5a
    add esp, 0x10                                # 0040dd5f
    push 0x63888b                                # 0040dd62
    push 0x53fed8                                # 0040dd67
    mov ecx, 0x583979                            # 0040dd6c
    call FUN_0042639d                            # 0040dd71
    mov ecx, 0x5cf659                            # 0040dd76
    call FUN_004c97b4                            # 0040dd7b
    jmp.d32 L_00410c9e                           # 0040dd80
L_0040dd85:
    # block 0x0040dd85: entered by jne at 0x0040dd3f, 16 instruction(s), ends with je to 0x0040ddd9 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040dd85
    imul edx, edx, 0x8d                          # 0040dd8c
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040dd92
    mov ecx, 0x7b                                # 0040dd98
    mov esi, dword ptr [ebp - local_20]          # 0040dd9d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040dda0
    movsw word ptr es:[edi], word ptr [esi]      # 0040dda2
    mov eax, dword ptr [ebp - local_cc]          # 0040dda4
    add eax, 0x1ee                               # 0040ddaa
    mov dword ptr [ebp - local_cc], eax          # 0040ddaf
    mov ecx, dword ptr [ebp - local_20]          # 0040ddb5
    add ecx, 0x1ee                               # 0040ddb8
    mov dword ptr [ebp - local_20], ecx          # 0040ddbe
    movsx edx, word ptr [0x63a4cd]               # 0040ddc1
    test edx, edx                                # 0040ddc8
    je.d8 L_0040ddd9                             # 0040ddca
    # block 0x0040ddcc: entered by fall-through of je at 0x0040ddca, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040ddd9
    push 0x53fef4                                # 0040ddcc
    call FUN_0044a2b7                            # 0040ddd1
    add esp, 0x4                                 # 0040ddd6
L_0040ddd9:
    # block 0x0040ddd9: entered by je at 0x0040ddca, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040ddd9
L_0040ddde:
    # block 0x0040ddde: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040de56 (forward)
    push 0x25cd                                  # 0040ddde
    call FUN_0051dc43                            # 0040dde3
    add esp, 0x4                                 # 0040dde8
    mov dword ptr [ebp - local_1cc], eax         # 0040ddeb
    movsx eax, word ptr [0x5c39e3]               # 0040ddf1
    imul eax, eax, 0x8d                          # 0040ddf8
    mov ecx, dword ptr [ebp - local_1cc]         # 0040ddfe
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040de04
    cmp dword ptr [ebp - local_1cc], 0x0         # 0040de0a
    jne.d8 L_0040de56                            # 0040de11
    # block 0x0040de13: entered by fall-through of jne at 0x0040de11, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040de13
    push edx                                     # 0040de1a
    mov eax, dword ptr [0x5bb57b]                # 0040de1b
    push eax                                     # 0040de20
    push 0x53ff24                                # 0040de21
    push 0x63888b                                # 0040de26
    call FUN_0050ca3e                            # 0040de2b
    add esp, 0x10                                # 0040de30
    push 0x63888b                                # 0040de33
    push 0x53ff50                                # 0040de38
    mov ecx, 0x583979                            # 0040de3d
    call FUN_0042639d                            # 0040de42
    mov ecx, 0x5cf659                            # 0040de47
    call FUN_004c97b4                            # 0040de4c
    jmp.d32 L_00410c9e                           # 0040de51
L_0040de56:
    # block 0x0040de56: entered by jne at 0x0040de11, 40 instruction(s), ends with je to 0x0040df1d (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040de56
    imul ecx, ecx, 0x8d                          # 0040de5d
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040de63
    mov ecx, 0x18a                               # 0040de69
    mov esi, dword ptr [ebp - local_20]          # 0040de6e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040de71
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040de73
    mov edx, dword ptr [ebp - local_20]          # 0040de74
    add edx, 0x629                               # 0040de77
    mov dword ptr [ebp - local_20], edx          # 0040de7d
    mov eax, dword ptr [ebp - local_cc]          # 0040de80
    add eax, 0x629                               # 0040de86
    mov dword ptr [ebp - local_cc], eax          # 0040de8b
    movsx ecx, word ptr [0x5c39e3]               # 0040de91
    imul ecx, ecx, 0x8d                          # 0040de98
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040de9e
    movsx eax, word ptr [edx + field_627]        # 0040dea4
    imul eax, eax, 0x10e                         # 0040deab
    mov dword ptr [ebp - local_100], eax         # 0040deb1
    mov ecx, dword ptr [ebp - local_100]         # 0040deb7
    mov esi, dword ptr [ebp - local_20]          # 0040debd
    movsx edx, word ptr [0x5c39e3]               # 0040dec0
    imul edx, edx, 0x8d                          # 0040dec7
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040decd
    add edi, 0x629                               # 0040ded3
    {load} mov eax, ecx                          # 0040ded9
    shr ecx, 0x2                                 # 0040dedb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040dede
    {load} mov ecx, eax                          # 0040dee0
    and ecx, 0x3                                 # 0040dee2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040dee5
    mov ecx, dword ptr [ebp - local_cc]          # 0040dee7
    add ecx, dword ptr [ebp - local_100]         # 0040deed
    mov dword ptr [ebp - local_cc], ecx          # 0040def3
    mov edx, dword ptr [ebp - local_20]          # 0040def9
    add edx, dword ptr [ebp - local_100]         # 0040defc
    mov dword ptr [ebp - local_20], edx          # 0040df02
    movsx eax, word ptr [0x63a4cd]               # 0040df05
    test eax, eax                                # 0040df0c
    je.d8 L_0040df1d                             # 0040df0e
    # block 0x0040df10: entered by fall-through of je at 0x0040df0e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040df1d
    push 0x53ff6c                                # 0040df10
    call FUN_0044a2b7                            # 0040df15
    add esp, 0x4                                 # 0040df1a
L_0040df1d:
    # block 0x0040df1d: entered by je at 0x0040df0e, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040df1d
L_0040df22:
    # block 0x0040df22: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040df9b (forward)
    push 0x5da                                   # 0040df22
    call FUN_0051dc43                            # 0040df27
    add esp, 0x4                                 # 0040df2c
    mov dword ptr [ebp - local_1d0], eax         # 0040df2f
    movsx ecx, word ptr [0x5c39e3]               # 0040df35
    imul ecx, ecx, 0x8d                          # 0040df3c
    mov edx, dword ptr [ebp - local_1d0]         # 0040df42
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040df48
    cmp dword ptr [ebp - local_1d0], 0x0         # 0040df4e
    jne.d8 L_0040df9b                            # 0040df55
    # block 0x0040df57: entered by fall-through of jne at 0x0040df55, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040df57
    push eax                                     # 0040df5e
    mov ecx, dword ptr [0x5bb57b]                # 0040df5f
    push ecx                                     # 0040df65
    push 0x53ff98                                # 0040df66
    push 0x63888b                                # 0040df6b
    call FUN_0050ca3e                            # 0040df70
    add esp, 0x10                                # 0040df75
    push 0x63888b                                # 0040df78
    push 0x53ffc4                                # 0040df7d
    mov ecx, 0x583979                            # 0040df82
    call FUN_0042639d                            # 0040df87
    mov ecx, 0x5cf659                            # 0040df8c
    call FUN_004c97b4                            # 0040df91
    jmp.d32 L_00410c9e                           # 0040df96
L_0040df9b:
    # block 0x0040df9b: entered by jne at 0x0040df55, 16 instruction(s), ends with je to 0x0040dfef (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040df9b
    imul edx, edx, 0x8d                          # 0040dfa2
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040dfa8
    mov ecx, 0x176                               # 0040dfae
    mov esi, dword ptr [ebp - local_20]          # 0040dfb3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040dfb6
    movsw word ptr es:[edi], word ptr [esi]      # 0040dfb8
    mov eax, dword ptr [ebp - local_cc]          # 0040dfba
    add eax, 0x5da                               # 0040dfc0
    mov dword ptr [ebp - local_cc], eax          # 0040dfc5
    mov ecx, dword ptr [ebp - local_20]          # 0040dfcb
    add ecx, 0x5da                               # 0040dfce
    mov dword ptr [ebp - local_20], ecx          # 0040dfd4
    movsx edx, word ptr [0x63a4cd]               # 0040dfd7
    test edx, edx                                # 0040dfde
    je.d8 L_0040dfef                             # 0040dfe0
    # block 0x0040dfe2: entered by fall-through of je at 0x0040dfe0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040dfef
    push 0x53ffe0                                # 0040dfe2
    call FUN_0044a2b7                            # 0040dfe7
    add esp, 0x4                                 # 0040dfec
L_0040dfef:
    # block 0x0040dfef: entered by je at 0x0040dfe0, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040dfef
L_0040dff4:
    # block 0x0040dff4: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e06c (forward)
    push 0x23f                                   # 0040dff4
    call FUN_0051dc43                            # 0040dff9
    add esp, 0x4                                 # 0040dffe
    mov dword ptr [ebp - local_1d4], eax         # 0040e001
    movsx eax, word ptr [0x5c39e3]               # 0040e007
    imul eax, eax, 0x8d                          # 0040e00e
    mov ecx, dword ptr [ebp - local_1d4]         # 0040e014
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040e01a
    cmp dword ptr [ebp - local_1d4], 0x0         # 0040e020
    jne.d8 L_0040e06c                            # 0040e027
    # block 0x0040e029: entered by fall-through of jne at 0x0040e027, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040e029
    push edx                                     # 0040e030
    mov eax, dword ptr [0x5bb57b]                # 0040e031
    push eax                                     # 0040e036
    push 0x540010                                # 0040e037
    push 0x63888b                                # 0040e03c
    call FUN_0050ca3e                            # 0040e041
    add esp, 0x10                                # 0040e046
    push 0x63888b                                # 0040e049
    push 0x54003c                                # 0040e04e
    mov ecx, 0x583979                            # 0040e053
    call FUN_0042639d                            # 0040e058
    mov ecx, 0x5cf659                            # 0040e05d
    call FUN_004c97b4                            # 0040e062
    jmp.d32 L_00410c9e                           # 0040e067
L_0040e06c:
    # block 0x0040e06c: entered by jne at 0x0040e027, 17 instruction(s), ends with je to 0x0040e0c1 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040e06c
    imul ecx, ecx, 0x8d                          # 0040e073
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040e079
    mov ecx, 0x8f                                # 0040e07f
    mov esi, dword ptr [ebp - local_20]          # 0040e084
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040e087
    movsw word ptr es:[edi], word ptr [esi]      # 0040e089
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040e08b
    mov edx, dword ptr [ebp - local_cc]          # 0040e08c
    add edx, 0x23f                               # 0040e092
    mov dword ptr [ebp - local_cc], edx          # 0040e098
    mov eax, dword ptr [ebp - local_20]          # 0040e09e
    add eax, 0x23f                               # 0040e0a1
    mov dword ptr [ebp - local_20], eax          # 0040e0a6
    movsx ecx, word ptr [0x63a4cd]               # 0040e0a9
    test ecx, ecx                                # 0040e0b0
    je.d8 L_0040e0c1                             # 0040e0b2
    # block 0x0040e0b4: entered by fall-through of je at 0x0040e0b2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e0c1
    push 0x540058                                # 0040e0b4
    call FUN_0044a2b7                            # 0040e0b9
    add esp, 0x4                                 # 0040e0be
L_0040e0c1:
    # block 0x0040e0c1: entered by je at 0x0040e0b2, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e0c1
L_0040e0c6:
    # block 0x0040e0c6: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e13c (forward)
    push 0x1                                     # 0040e0c6
    call FUN_0051dc43                            # 0040e0c8
    add esp, 0x4                                 # 0040e0cd
    mov dword ptr [ebp - local_1d8], eax         # 0040e0d0
    movsx edx, word ptr [0x5c39e3]               # 0040e0d6
    imul edx, edx, 0x8d                          # 0040e0dd
    mov eax, dword ptr [ebp - local_1d8]         # 0040e0e3
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040e0e9
    cmp dword ptr [ebp - local_1d8], 0x0         # 0040e0ef
    jne.d8 L_0040e13c                            # 0040e0f6
    # block 0x0040e0f8: entered by fall-through of jne at 0x0040e0f6, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040e0f8
    push ecx                                     # 0040e0ff
    mov edx, dword ptr [0x5bb57b]                # 0040e100
    push edx                                     # 0040e106
    push 0x54008c                                # 0040e107
    push 0x63888b                                # 0040e10c
    call FUN_0050ca3e                            # 0040e111
    add esp, 0x10                                # 0040e116
    push 0x63888b                                # 0040e119
    push 0x5400b8                                # 0040e11e
    mov ecx, 0x583979                            # 0040e123
    call FUN_0042639d                            # 0040e128
    mov ecx, 0x5cf659                            # 0040e12d
    call FUN_004c97b4                            # 0040e132
    jmp.d32 L_00410c9e                           # 0040e137
L_0040e13c:
    # block 0x0040e13c: entered by jne at 0x0040e0f6, 15 instruction(s), ends with je to 0x0040e186 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040e13c
    imul eax, eax, 0x8d                          # 0040e143
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040e149
    mov edx, dword ptr [ebp - local_20]          # 0040e14f
    mov al, byte ptr [edx]                       # 0040e152
    mov byte ptr [ecx], al                       # 0040e154
    mov ecx, dword ptr [ebp - local_cc]          # 0040e156
    add ecx, 0x1                                 # 0040e15c
    mov dword ptr [ebp - local_cc], ecx          # 0040e15f
    mov edx, dword ptr [ebp - local_20]          # 0040e165
    add edx, 0x1                                 # 0040e168
    mov dword ptr [ebp - local_20], edx          # 0040e16b
    movsx eax, word ptr [0x63a4cd]               # 0040e16e
    test eax, eax                                # 0040e175
    je.d8 L_0040e186                             # 0040e177
    # block 0x0040e179: entered by fall-through of je at 0x0040e177, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e186
    push 0x5400d4                                # 0040e179
    call FUN_0044a2b7                            # 0040e17e
    add esp, 0x4                                 # 0040e183
L_0040e186:
    # block 0x0040e186: entered by je at 0x0040e177, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e186
L_0040e18b:
    # block 0x0040e18b: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e201 (forward)
    push 0x1                                     # 0040e18b
    call FUN_0051dc43                            # 0040e18d
    add esp, 0x4                                 # 0040e192
    mov dword ptr [ebp - local_1dc], eax         # 0040e195
    movsx ecx, word ptr [0x5c39e3]               # 0040e19b
    imul ecx, ecx, 0x8d                          # 0040e1a2
    mov edx, dword ptr [ebp - local_1dc]         # 0040e1a8
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040e1ae
    cmp dword ptr [ebp - local_1dc], 0x0         # 0040e1b4
    jne.d8 L_0040e201                            # 0040e1bb
    # block 0x0040e1bd: entered by fall-through of jne at 0x0040e1bb, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040e1bd
    push eax                                     # 0040e1c4
    mov ecx, dword ptr [0x5bb57b]                # 0040e1c5
    push ecx                                     # 0040e1cb
    push 0x540100                                # 0040e1cc
    push 0x63888b                                # 0040e1d1
    call FUN_0050ca3e                            # 0040e1d6
    add esp, 0x10                                # 0040e1db
    push 0x63888b                                # 0040e1de
    push 0x54012c                                # 0040e1e3
    mov ecx, 0x583979                            # 0040e1e8
    call FUN_0042639d                            # 0040e1ed
    mov ecx, 0x5cf659                            # 0040e1f2
    call FUN_004c97b4                            # 0040e1f7
    jmp.d32 L_00410c9e                           # 0040e1fc
L_0040e201:
    # block 0x0040e201: entered by jne at 0x0040e1bb, 15 instruction(s), ends with je to 0x0040e24b (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040e201
    imul edx, edx, 0x8d                          # 0040e208
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040e20e
    mov ecx, dword ptr [ebp - local_20]          # 0040e214
    mov dl, byte ptr [ecx]                       # 0040e217
    mov byte ptr [eax], dl                       # 0040e219
    mov eax, dword ptr [ebp - local_cc]          # 0040e21b
    add eax, 0x1                                 # 0040e221
    mov dword ptr [ebp - local_cc], eax          # 0040e224
    mov ecx, dword ptr [ebp - local_20]          # 0040e22a
    add ecx, 0x1                                 # 0040e22d
    mov dword ptr [ebp - local_20], ecx          # 0040e230
    movsx edx, word ptr [0x63a4cd]               # 0040e233
    test edx, edx                                # 0040e23a
    je.d8 L_0040e24b                             # 0040e23c
    # block 0x0040e23e: entered by fall-through of je at 0x0040e23c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e24b
    push 0x540148                                # 0040e23e
    call FUN_0044a2b7                            # 0040e243
    add esp, 0x4                                 # 0040e248
L_0040e24b:
    # block 0x0040e24b: entered by je at 0x0040e23c, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e24b
L_0040e250:
    # block 0x0040e250: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e2c5 (forward)
    push 0x1                                     # 0040e250
    call FUN_0051dc43                            # 0040e252
    add esp, 0x4                                 # 0040e257
    mov dword ptr [ebp - local_1e0], eax         # 0040e25a
    movsx eax, word ptr [0x5c39e3]               # 0040e260
    imul eax, eax, 0x8d                          # 0040e267
    mov ecx, dword ptr [ebp - local_1e0]         # 0040e26d
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040e273
    cmp dword ptr [ebp - local_1e0], 0x0         # 0040e279
    jne.d8 L_0040e2c5                            # 0040e280
    # block 0x0040e282: entered by fall-through of jne at 0x0040e280, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040e282
    push edx                                     # 0040e289
    mov eax, dword ptr [0x5bb57b]                # 0040e28a
    push eax                                     # 0040e28f
    push 0x540174                                # 0040e290
    push 0x63888b                                # 0040e295
    call FUN_0050ca3e                            # 0040e29a
    add esp, 0x10                                # 0040e29f
    push 0x63888b                                # 0040e2a2
    push 0x5401a0                                # 0040e2a7
    mov ecx, 0x583979                            # 0040e2ac
    call FUN_0042639d                            # 0040e2b1
    mov ecx, 0x5cf659                            # 0040e2b6
    call FUN_004c97b4                            # 0040e2bb
    jmp.d32 L_00410c9e                           # 0040e2c0
L_0040e2c5:
    # block 0x0040e2c5: entered by jne at 0x0040e280, 15 instruction(s), ends with je to 0x0040e30f (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040e2c5
    imul ecx, ecx, 0x8d                          # 0040e2cc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040e2d2
    mov eax, dword ptr [ebp - local_20]          # 0040e2d8
    mov cl, byte ptr [eax]                       # 0040e2db
    mov byte ptr [edx], cl                       # 0040e2dd
    mov edx, dword ptr [ebp - local_cc]          # 0040e2df
    add edx, 0x1                                 # 0040e2e5
    mov dword ptr [ebp - local_cc], edx          # 0040e2e8
    mov eax, dword ptr [ebp - local_20]          # 0040e2ee
    add eax, 0x1                                 # 0040e2f1
    mov dword ptr [ebp - local_20], eax          # 0040e2f4
    movsx ecx, word ptr [0x63a4cd]               # 0040e2f7
    test ecx, ecx                                # 0040e2fe
    je.d8 L_0040e30f                             # 0040e300
    # block 0x0040e302: entered by fall-through of je at 0x0040e300, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e30f
    push 0x5401bc                                # 0040e302
    call FUN_0044a2b7                            # 0040e307
    add esp, 0x4                                 # 0040e30c
L_0040e30f:
    # block 0x0040e30f: entered by je at 0x0040e300, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e30f
L_0040e314:
    # block 0x0040e314: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e38a (forward)
    push 0x1                                     # 0040e314
    call FUN_0051dc43                            # 0040e316
    add esp, 0x4                                 # 0040e31b
    mov dword ptr [ebp - local_1e4], eax         # 0040e31e
    movsx edx, word ptr [0x5c39e3]               # 0040e324
    imul edx, edx, 0x8d                          # 0040e32b
    mov eax, dword ptr [ebp - local_1e4]         # 0040e331
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040e337
    cmp dword ptr [ebp - local_1e4], 0x0         # 0040e33d
    jne.d8 L_0040e38a                            # 0040e344
    # block 0x0040e346: entered by fall-through of jne at 0x0040e344, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040e346
    push ecx                                     # 0040e34d
    mov edx, dword ptr [0x5bb57b]                # 0040e34e
    push edx                                     # 0040e354
    push 0x5401ec                                # 0040e355
    push 0x63888b                                # 0040e35a
    call FUN_0050ca3e                            # 0040e35f
    add esp, 0x10                                # 0040e364
    push 0x63888b                                # 0040e367
    push 0x540218                                # 0040e36c
    mov ecx, 0x583979                            # 0040e371
    call FUN_0042639d                            # 0040e376
    mov ecx, 0x5cf659                            # 0040e37b
    call FUN_004c97b4                            # 0040e380
    jmp.d32 L_00410c9e                           # 0040e385
L_0040e38a:
    # block 0x0040e38a: entered by jne at 0x0040e344, 15 instruction(s), ends with je to 0x0040e3d4 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040e38a
    imul eax, eax, 0x8d                          # 0040e391
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040e397
    mov edx, dword ptr [ebp - local_20]          # 0040e39d
    mov al, byte ptr [edx]                       # 0040e3a0
    mov byte ptr [ecx], al                       # 0040e3a2
    mov ecx, dword ptr [ebp - local_cc]          # 0040e3a4
    add ecx, 0x1                                 # 0040e3aa
    mov dword ptr [ebp - local_cc], ecx          # 0040e3ad
    mov edx, dword ptr [ebp - local_20]          # 0040e3b3
    add edx, 0x1                                 # 0040e3b6
    mov dword ptr [ebp - local_20], edx          # 0040e3b9
    movsx eax, word ptr [0x63a4cd]               # 0040e3bc
    test eax, eax                                # 0040e3c3
    je.d8 L_0040e3d4                             # 0040e3c5
    # block 0x0040e3c7: entered by fall-through of je at 0x0040e3c5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e3d4
    push 0x540234                                # 0040e3c7
    call FUN_0044a2b7                            # 0040e3cc
    add esp, 0x4                                 # 0040e3d1
L_0040e3d4:
    # block 0x0040e3d4: entered by je at 0x0040e3c5, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e3d4
L_0040e3d9:
    # block 0x0040e3d9: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e44f (forward)
    push 0x1                                     # 0040e3d9
    call FUN_0051dc43                            # 0040e3db
    add esp, 0x4                                 # 0040e3e0
    mov dword ptr [ebp - local_1e8], eax         # 0040e3e3
    movsx ecx, word ptr [0x5c39e3]               # 0040e3e9
    imul ecx, ecx, 0x8d                          # 0040e3f0
    mov edx, dword ptr [ebp - local_1e8]         # 0040e3f6
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040e3fc
    cmp dword ptr [ebp - local_1e8], 0x0         # 0040e402
    jne.d8 L_0040e44f                            # 0040e409
    # block 0x0040e40b: entered by fall-through of jne at 0x0040e409, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040e40b
    push eax                                     # 0040e412
    mov ecx, dword ptr [0x5bb57b]                # 0040e413
    push ecx                                     # 0040e419
    push 0x540260                                # 0040e41a
    push 0x63888b                                # 0040e41f
    call FUN_0050ca3e                            # 0040e424
    add esp, 0x10                                # 0040e429
    push 0x63888b                                # 0040e42c
    push 0x54028c                                # 0040e431
    mov ecx, 0x583979                            # 0040e436
    call FUN_0042639d                            # 0040e43b
    mov ecx, 0x5cf659                            # 0040e440
    call FUN_004c97b4                            # 0040e445
    jmp.d32 L_00410c9e                           # 0040e44a
L_0040e44f:
    # block 0x0040e44f: entered by jne at 0x0040e409, 15 instruction(s), ends with je to 0x0040e499 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040e44f
    imul edx, edx, 0x8d                          # 0040e456
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040e45c
    mov ecx, dword ptr [ebp - local_20]          # 0040e462
    mov dl, byte ptr [ecx]                       # 0040e465
    mov byte ptr [eax], dl                       # 0040e467
    mov eax, dword ptr [ebp - local_cc]          # 0040e469
    add eax, 0x1                                 # 0040e46f
    mov dword ptr [ebp - local_cc], eax          # 0040e472
    mov ecx, dword ptr [ebp - local_20]          # 0040e478
    add ecx, 0x1                                 # 0040e47b
    mov dword ptr [ebp - local_20], ecx          # 0040e47e
    movsx edx, word ptr [0x63a4cd]               # 0040e481
    test edx, edx                                # 0040e488
    je.d8 L_0040e499                             # 0040e48a
    # block 0x0040e48c: entered by fall-through of je at 0x0040e48a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e499
    push 0x5402a8                                # 0040e48c
    call FUN_0044a2b7                            # 0040e491
    add esp, 0x4                                 # 0040e496
L_0040e499:
    # block 0x0040e499: entered by je at 0x0040e48a, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e499
L_0040e49e:
    # block 0x0040e49e: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e513 (forward)
    push 0x6                                     # 0040e49e
    call FUN_0051dc43                            # 0040e4a0
    add esp, 0x4                                 # 0040e4a5
    mov dword ptr [ebp - local_1ec], eax         # 0040e4a8
    movsx eax, word ptr [0x5c39e3]               # 0040e4ae
    imul eax, eax, 0x8d                          # 0040e4b5
    mov ecx, dword ptr [ebp - local_1ec]         # 0040e4bb
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040e4c1
    cmp dword ptr [ebp - local_1ec], 0x0         # 0040e4c7
    jne.d8 L_0040e513                            # 0040e4ce
    # block 0x0040e4d0: entered by fall-through of jne at 0x0040e4ce, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040e4d0
    push edx                                     # 0040e4d7
    mov eax, dword ptr [0x5bb57b]                # 0040e4d8
    push eax                                     # 0040e4dd
    push 0x5402d4                                # 0040e4de
    push 0x63888b                                # 0040e4e3
    call FUN_0050ca3e                            # 0040e4e8
    add esp, 0x10                                # 0040e4ed
    push 0x63888b                                # 0040e4f0
    push 0x540300                                # 0040e4f5
    mov ecx, 0x583979                            # 0040e4fa
    call FUN_0042639d                            # 0040e4ff
    mov ecx, 0x5cf659                            # 0040e504
    call FUN_004c97b4                            # 0040e509
    jmp.d32 L_00410c9e                           # 0040e50e
L_0040e513:
    # block 0x0040e513: entered by jne at 0x0040e4ce, 17 instruction(s), ends with je to 0x0040e565 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040e513
    imul ecx, ecx, 0x8d                          # 0040e51a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040e520
    mov eax, dword ptr [ebp - local_20]          # 0040e526
    mov ecx, dword ptr [eax]                     # 0040e529
    mov dword ptr [edx], ecx                     # 0040e52b
    mov ax, word ptr [eax + field_4]             # 0040e52d
    mov word ptr [edx + field_4], ax             # 0040e531
    mov ecx, dword ptr [ebp - local_cc]          # 0040e535
    add ecx, 0x6                                 # 0040e53b
    mov dword ptr [ebp - local_cc], ecx          # 0040e53e
    mov edx, dword ptr [ebp - local_20]          # 0040e544
    add edx, 0x6                                 # 0040e547
    mov dword ptr [ebp - local_20], edx          # 0040e54a
    movsx eax, word ptr [0x63a4cd]               # 0040e54d
    test eax, eax                                # 0040e554
    je.d8 L_0040e565                             # 0040e556
    # block 0x0040e558: entered by fall-through of je at 0x0040e556, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e565
    push 0x54031c                                # 0040e558
    call FUN_0044a2b7                            # 0040e55d
    add esp, 0x4                                 # 0040e562
L_0040e565:
    # block 0x0040e565: entered by je at 0x0040e556, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e565
L_0040e56a:
    # block 0x0040e56a: entered by switch case, 11 instruction(s), calls FUN_004e9c2f, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040e56a
    push ecx                                     # 0040e570
    lea edx, [ebp - local_20]                    # 0040e571
    push edx                                     # 0040e574
    movsx eax, word ptr [0x5c39e3]               # 0040e575
    imul eax, eax, 0x8d                          # 0040e57c
    add eax, 0x5bb5e5                            # 0040e582
    push eax                                     # 0040e587
    mov ecx, 0x571442                            # 0040e588
    call FUN_004e9c2f                            # 0040e58d
    jmp.d32 L_00410a68                           # 0040e592
L_0040e597:
    # block 0x0040e597: entered by switch case, 11 instruction(s), calls FUN_004e9add, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040e597
    push ecx                                     # 0040e59d
    lea edx, [ebp - local_20]                    # 0040e59e
    push edx                                     # 0040e5a1
    movsx eax, word ptr [0x5c39e3]               # 0040e5a2
    imul eax, eax, 0x8d                          # 0040e5a9
    add eax, 0x5bb5e5                            # 0040e5af
    push eax                                     # 0040e5b4
    mov ecx, 0x571442                            # 0040e5b5
    call FUN_004e9add                            # 0040e5ba
    jmp.d32 L_00410a68                           # 0040e5bf
L_0040e5c4:
    # block 0x0040e5c4: entered by switch case, 11 instruction(s), calls FUN_004e9cdf, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040e5c4
    push ecx                                     # 0040e5ca
    lea edx, [ebp - local_20]                    # 0040e5cb
    push edx                                     # 0040e5ce
    movsx eax, word ptr [0x5c39e3]               # 0040e5cf
    imul eax, eax, 0x8d                          # 0040e5d6
    add eax, 0x5bb5e5                            # 0040e5dc
    push eax                                     # 0040e5e1
    mov ecx, 0x571442                            # 0040e5e2
    call FUN_004e9cdf                            # 0040e5e7
    jmp.d32 L_00410a68                           # 0040e5ec
L_0040e5f1:
    # block 0x0040e5f1: entered by switch case, 11 instruction(s), calls FUN_004e9b87, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0040e5f1
    push ecx                                     # 0040e5f7
    lea edx, [ebp - local_20]                    # 0040e5f8
    push edx                                     # 0040e5fb
    movsx eax, word ptr [0x5c39e3]               # 0040e5fc
    imul eax, eax, 0x8d                          # 0040e603
    add eax, 0x5bb5e5                            # 0040e609
    push eax                                     # 0040e60e
    mov ecx, 0x571442                            # 0040e60f
    call FUN_004e9b87                            # 0040e614
    jmp.d32 L_00410a68                           # 0040e619
L_0040e61e:
    # block 0x0040e61e: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e694 (forward)
    push 0x1                                     # 0040e61e
    call FUN_0051dc43                            # 0040e620
    add esp, 0x4                                 # 0040e625
    mov dword ptr [ebp - local_1f0], eax         # 0040e628
    movsx ecx, word ptr [0x5c39e3]               # 0040e62e
    imul ecx, ecx, 0x8d                          # 0040e635
    mov edx, dword ptr [ebp - local_1f0]         # 0040e63b
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040e641
    cmp dword ptr [ebp - local_1f0], 0x0         # 0040e647
    jne.d8 L_0040e694                            # 0040e64e
    # block 0x0040e650: entered by fall-through of jne at 0x0040e64e, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040e650
    push eax                                     # 0040e657
    mov ecx, dword ptr [0x5bb57b]                # 0040e658
    push ecx                                     # 0040e65e
    push 0x540350                                # 0040e65f
    push 0x63888b                                # 0040e664
    call FUN_0050ca3e                            # 0040e669
    add esp, 0x10                                # 0040e66e
    push 0x63888b                                # 0040e671
    push 0x54037c                                # 0040e676
    mov ecx, 0x583979                            # 0040e67b
    call FUN_0042639d                            # 0040e680
    mov ecx, 0x5cf659                            # 0040e685
    call FUN_004c97b4                            # 0040e68a
    jmp.d32 L_00410c9e                           # 0040e68f
L_0040e694:
    # block 0x0040e694: entered by jne at 0x0040e64e, 15 instruction(s), ends with je to 0x0040e6de (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040e694
    imul edx, edx, 0x8d                          # 0040e69b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040e6a1
    mov ecx, dword ptr [ebp - local_20]          # 0040e6a7
    mov dl, byte ptr [ecx]                       # 0040e6aa
    mov byte ptr [eax], dl                       # 0040e6ac
    mov eax, dword ptr [ebp - local_cc]          # 0040e6ae
    add eax, 0x1                                 # 0040e6b4
    mov dword ptr [ebp - local_cc], eax          # 0040e6b7
    mov ecx, dword ptr [ebp - local_20]          # 0040e6bd
    add ecx, 0x1                                 # 0040e6c0
    mov dword ptr [ebp - local_20], ecx          # 0040e6c3
    movsx edx, word ptr [0x63a4cd]               # 0040e6c6
    test edx, edx                                # 0040e6cd
    je.d8 L_0040e6de                             # 0040e6cf
    # block 0x0040e6d1: entered by fall-through of je at 0x0040e6cf, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e6de
    push 0x540398                                # 0040e6d1
    call FUN_0044a2b7                            # 0040e6d6
    add esp, 0x4                                 # 0040e6db
L_0040e6de:
    # block 0x0040e6de: entered by je at 0x0040e6cf, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e6de
L_0040e6e3:
    # block 0x0040e6e3: entered by switch case, 11 instruction(s), calls FUN_004e9d8f, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040e6e3
    push eax                                     # 0040e6e9
    lea ecx, [ebp - local_20]                    # 0040e6ea
    push ecx                                     # 0040e6ed
    movsx edx, word ptr [0x5c39e3]               # 0040e6ee
    imul edx, edx, 0x8d                          # 0040e6f5
    add edx, 0x5bb5e5                            # 0040e6fb
    push edx                                     # 0040e701
    mov ecx, 0x571442                            # 0040e702
    call FUN_004e9d8f                            # 0040e707
    jmp.d32 L_00410a68                           # 0040e70c
L_0040e711:
    # block 0x0040e711: entered by switch case, 11 instruction(s), calls FUN_004e9a2c, ends with forward jump to 0x00410a68
    lea eax, [ebp - local_cc]                    # 0040e711
    push eax                                     # 0040e717
    lea ecx, [ebp - local_20]                    # 0040e718
    push ecx                                     # 0040e71b
    movsx edx, word ptr [0x5c39e3]               # 0040e71c
    imul edx, edx, 0x8d                          # 0040e723
    add edx, 0x5bb5e5                            # 0040e729
    push edx                                     # 0040e72f
    mov ecx, 0x571442                            # 0040e730
    call FUN_004e9a2c                            # 0040e735
    jmp.d32 L_00410a68                           # 0040e73a
L_0040e73f:
    # block 0x0040e73f: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e7b4 (forward)
    push 0x2                                     # 0040e73f
    call FUN_0051dc43                            # 0040e741
    add esp, 0x4                                 # 0040e746
    mov dword ptr [ebp - local_1f4], eax         # 0040e749
    movsx eax, word ptr [0x5c39e3]               # 0040e74f
    imul eax, eax, 0x8d                          # 0040e756
    mov ecx, dword ptr [ebp - local_1f4]         # 0040e75c
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040e762
    cmp dword ptr [ebp - local_1f4], 0x0         # 0040e768
    jne.d8 L_0040e7b4                            # 0040e76f
    # block 0x0040e771: entered by fall-through of jne at 0x0040e76f, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040e771
    push edx                                     # 0040e778
    mov eax, dword ptr [0x5bb57b]                # 0040e779
    push eax                                     # 0040e77e
    push 0x5403d4                                # 0040e77f
    push 0x63888b                                # 0040e784
    call FUN_0050ca3e                            # 0040e789
    add esp, 0x10                                # 0040e78e
    push 0x63888b                                # 0040e791
    push 0x540400                                # 0040e796
    mov ecx, 0x583979                            # 0040e79b
    call FUN_0042639d                            # 0040e7a0
    mov ecx, 0x5cf659                            # 0040e7a5
    call FUN_004c97b4                            # 0040e7aa
    jmp.d32 L_00410c9e                           # 0040e7af
L_0040e7b4:
    # block 0x0040e7b4: entered by jne at 0x0040e76f, 15 instruction(s), ends with je to 0x0040e800 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040e7b4
    imul ecx, ecx, 0x8d                          # 0040e7bb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040e7c1
    mov eax, dword ptr [ebp - local_20]          # 0040e7c7
    mov cx, word ptr [eax]                       # 0040e7ca
    mov word ptr [edx], cx                       # 0040e7cd
    mov edx, dword ptr [ebp - local_cc]          # 0040e7d0
    add edx, 0x2                                 # 0040e7d6
    mov dword ptr [ebp - local_cc], edx          # 0040e7d9
    mov eax, dword ptr [ebp - local_20]          # 0040e7df
    add eax, 0x2                                 # 0040e7e2
    mov dword ptr [ebp - local_20], eax          # 0040e7e5
    movsx ecx, word ptr [0x63a4cd]               # 0040e7e8
    test ecx, ecx                                # 0040e7ef
    je.d8 L_0040e800                             # 0040e7f1
    # block 0x0040e7f3: entered by fall-through of je at 0x0040e7f1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e800
    push 0x54041c                                # 0040e7f3
    call FUN_0044a2b7                            # 0040e7f8
    add esp, 0x4                                 # 0040e7fd
L_0040e800:
    # block 0x0040e800: entered by je at 0x0040e7f1, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e800
L_0040e805:
    # block 0x0040e805: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e87b (forward)
    push 0x2                                     # 0040e805
    call FUN_0051dc43                            # 0040e807
    add esp, 0x4                                 # 0040e80c
    mov dword ptr [ebp - local_1f8], eax         # 0040e80f
    movsx edx, word ptr [0x5c39e3]               # 0040e815
    imul edx, edx, 0x8d                          # 0040e81c
    mov eax, dword ptr [ebp - local_1f8]         # 0040e822
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040e828
    cmp dword ptr [ebp - local_1f8], 0x0         # 0040e82e
    jne.d8 L_0040e87b                            # 0040e835
    # block 0x0040e837: entered by fall-through of jne at 0x0040e835, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040e837
    push ecx                                     # 0040e83e
    mov edx, dword ptr [0x5bb57b]                # 0040e83f
    push edx                                     # 0040e845
    push 0x540458                                # 0040e846
    push 0x63888b                                # 0040e84b
    call FUN_0050ca3e                            # 0040e850
    add esp, 0x10                                # 0040e855
    push 0x63888b                                # 0040e858
    push 0x540484                                # 0040e85d
    mov ecx, 0x583979                            # 0040e862
    call FUN_0042639d                            # 0040e867
    mov ecx, 0x5cf659                            # 0040e86c
    call FUN_004c97b4                            # 0040e871
    jmp.d32 L_00410c9e                           # 0040e876
L_0040e87b:
    # block 0x0040e87b: entered by jne at 0x0040e835, 15 instruction(s), ends with je to 0x0040e8c7 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040e87b
    imul eax, eax, 0x8d                          # 0040e882
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040e888
    mov edx, dword ptr [ebp - local_20]          # 0040e88e
    mov ax, word ptr [edx]                       # 0040e891
    mov word ptr [ecx], ax                       # 0040e894
    mov ecx, dword ptr [ebp - local_cc]          # 0040e897
    add ecx, 0x2                                 # 0040e89d
    mov dword ptr [ebp - local_cc], ecx          # 0040e8a0
    mov edx, dword ptr [ebp - local_20]          # 0040e8a6
    add edx, 0x2                                 # 0040e8a9
    mov dword ptr [ebp - local_20], edx          # 0040e8ac
    movsx eax, word ptr [0x63a4cd]               # 0040e8af
    test eax, eax                                # 0040e8b6
    je.d8 L_0040e8c7                             # 0040e8b8
    # block 0x0040e8ba: entered by fall-through of je at 0x0040e8b8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e8c7
    push 0x5404a0                                # 0040e8ba
    call FUN_0044a2b7                            # 0040e8bf
    add esp, 0x4                                 # 0040e8c4
L_0040e8c7:
    # block 0x0040e8c7: entered by je at 0x0040e8b8, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e8c7
L_0040e8cc:
    # block 0x0040e8cc: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040e942 (forward)
    push 0x29                                    # 0040e8cc
    call FUN_0051dc43                            # 0040e8ce
    add esp, 0x4                                 # 0040e8d3
    mov dword ptr [ebp - local_1fc], eax         # 0040e8d6
    movsx ecx, word ptr [0x5c39e3]               # 0040e8dc
    imul ecx, ecx, 0x8d                          # 0040e8e3
    mov edx, dword ptr [ebp - local_1fc]         # 0040e8e9
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040e8ef
    cmp dword ptr [ebp - local_1fc], 0x0         # 0040e8f5
    jne.d8 L_0040e942                            # 0040e8fc
    # block 0x0040e8fe: entered by fall-through of jne at 0x0040e8fc, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040e8fe
    push eax                                     # 0040e905
    mov ecx, dword ptr [0x5bb57b]                # 0040e906
    push ecx                                     # 0040e90c
    push 0x5404d8                                # 0040e90d
    push 0x63888b                                # 0040e912
    call FUN_0050ca3e                            # 0040e917
    add esp, 0x10                                # 0040e91c
    push 0x63888b                                # 0040e91f
    push 0x540504                                # 0040e924
    mov ecx, 0x583979                            # 0040e929
    call FUN_0042639d                            # 0040e92e
    mov ecx, 0x5cf659                            # 0040e933
    call FUN_004c97b4                            # 0040e938
    jmp.d32 L_00410c9e                           # 0040e93d
L_0040e942:
    # block 0x0040e942: entered by jne at 0x0040e8fc, 16 instruction(s), ends with je to 0x0040e990 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040e942
    imul edx, edx, 0x8d                          # 0040e949
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040e94f
    mov ecx, 0xa                                 # 0040e955
    mov esi, dword ptr [ebp - local_20]          # 0040e95a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040e95d
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040e95f
    mov eax, dword ptr [ebp - local_cc]          # 0040e960
    add eax, 0x29                                # 0040e966
    mov dword ptr [ebp - local_cc], eax          # 0040e969
    mov ecx, dword ptr [ebp - local_20]          # 0040e96f
    add ecx, 0x29                                # 0040e972
    mov dword ptr [ebp - local_20], ecx          # 0040e975
    movsx edx, word ptr [0x63a4cd]               # 0040e978
    test edx, edx                                # 0040e97f
    je.d8 L_0040e990                             # 0040e981
    # block 0x0040e983: entered by fall-through of je at 0x0040e981, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040e990
    push 0x540520                                # 0040e983
    call FUN_0044a2b7                            # 0040e988
    add esp, 0x4                                 # 0040e98d
L_0040e990:
    # block 0x0040e990: entered by je at 0x0040e981, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040e990
L_0040e995:
    # block 0x0040e995: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ea0a (forward)
    push 0x4a                                    # 0040e995
    call FUN_0051dc43                            # 0040e997
    add esp, 0x4                                 # 0040e99c
    mov dword ptr [ebp - local_200], eax         # 0040e99f
    movsx eax, word ptr [0x5c39e3]               # 0040e9a5
    imul eax, eax, 0x8d                          # 0040e9ac
    mov ecx, dword ptr [ebp - local_200]         # 0040e9b2
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040e9b8
    cmp dword ptr [ebp - local_200], 0x0         # 0040e9be
    jne.d8 L_0040ea0a                            # 0040e9c5
    # block 0x0040e9c7: entered by fall-through of jne at 0x0040e9c5, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0040e9c7
    push edx                                     # 0040e9ce
    mov eax, dword ptr [0x5bb57b]                # 0040e9cf
    push eax                                     # 0040e9d4
    push 0x540554                                # 0040e9d5
    push 0x63888b                                # 0040e9da
    call FUN_0050ca3e                            # 0040e9df
    add esp, 0x10                                # 0040e9e4
    push 0x63888b                                # 0040e9e7
    push 0x540580                                # 0040e9ec
    mov ecx, 0x583979                            # 0040e9f1
    call FUN_0042639d                            # 0040e9f6
    mov ecx, 0x5cf659                            # 0040e9fb
    call FUN_004c97b4                            # 0040ea00
    jmp.d32 L_00410c9e                           # 0040ea05
L_0040ea0a:
    # block 0x0040ea0a: entered by jne at 0x0040e9c5, 16 instruction(s), ends with je to 0x0040ea59 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040ea0a
    imul ecx, ecx, 0x8d                          # 0040ea11
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0040ea17
    mov ecx, 0x12                                # 0040ea1d
    mov esi, dword ptr [ebp - local_20]          # 0040ea22
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ea25
    movsw word ptr es:[edi], word ptr [esi]      # 0040ea27
    mov edx, dword ptr [ebp - local_cc]          # 0040ea29
    add edx, 0x4a                                # 0040ea2f
    mov dword ptr [ebp - local_cc], edx          # 0040ea32
    mov eax, dword ptr [ebp - local_20]          # 0040ea38
    add eax, 0x4a                                # 0040ea3b
    mov dword ptr [ebp - local_20], eax          # 0040ea3e
    movsx ecx, word ptr [0x63a4cd]               # 0040ea41
    test ecx, ecx                                # 0040ea48
    je.d8 L_0040ea59                             # 0040ea4a
    # block 0x0040ea4c: entered by fall-through of je at 0x0040ea4a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040ea59
    push 0x54059c                                # 0040ea4c
    call FUN_0044a2b7                            # 0040ea51
    add esp, 0x4                                 # 0040ea56
L_0040ea59:
    # block 0x0040ea59: entered by je at 0x0040ea4a, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040ea59
L_0040ea5e:
    # block 0x0040ea5e: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ead4 (forward)
    push 0x32                                    # 0040ea5e
    call FUN_0051dc43                            # 0040ea60
    add esp, 0x4                                 # 0040ea65
    mov dword ptr [ebp - local_204], eax         # 0040ea68
    movsx edx, word ptr [0x5c39e3]               # 0040ea6e
    imul edx, edx, 0x8d                          # 0040ea75
    mov eax, dword ptr [ebp - local_204]         # 0040ea7b
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040ea81
    cmp dword ptr [ebp - local_204], 0x0         # 0040ea87
    jne.d8 L_0040ead4                            # 0040ea8e
    # block 0x0040ea90: entered by fall-through of jne at 0x0040ea8e, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040ea90
    push ecx                                     # 0040ea97
    mov edx, dword ptr [0x5bb57b]                # 0040ea98
    push edx                                     # 0040ea9e
    push 0x5405d0                                # 0040ea9f
    push 0x63888b                                # 0040eaa4
    call FUN_0050ca3e                            # 0040eaa9
    add esp, 0x10                                # 0040eaae
    push 0x63888b                                # 0040eab1
    push 0x5405fc                                # 0040eab6
    mov ecx, 0x583979                            # 0040eabb
    call FUN_0042639d                            # 0040eac0
    mov ecx, 0x5cf659                            # 0040eac5
    call FUN_004c97b4                            # 0040eaca
    jmp.d32 L_00410c9e                           # 0040eacf
L_0040ead4:
    # block 0x0040ead4: entered by jne at 0x0040ea8e, 16 instruction(s), ends with je to 0x0040eb23 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040ead4
    imul eax, eax, 0x8d                          # 0040eadb
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040eae1
    mov ecx, 0xc                                 # 0040eae7
    mov esi, dword ptr [ebp - local_20]          # 0040eaec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040eaef
    movsw word ptr es:[edi], word ptr [esi]      # 0040eaf1
    mov ecx, dword ptr [ebp - local_cc]          # 0040eaf3
    add ecx, 0x32                                # 0040eaf9
    mov dword ptr [ebp - local_cc], ecx          # 0040eafc
    mov edx, dword ptr [ebp - local_20]          # 0040eb02
    add edx, 0x32                                # 0040eb05
    mov dword ptr [ebp - local_20], edx          # 0040eb08
    movsx eax, word ptr [0x63a4cd]               # 0040eb0b
    test eax, eax                                # 0040eb12
    je.d8 L_0040eb23                             # 0040eb14
    # block 0x0040eb16: entered by fall-through of je at 0x0040eb14, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040eb23
    push 0x540618                                # 0040eb16
    call FUN_0044a2b7                            # 0040eb1b
    add esp, 0x4                                 # 0040eb20
L_0040eb23:
    # block 0x0040eb23: entered by je at 0x0040eb14, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040eb23
L_0040eb28:
    # block 0x0040eb28: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040eba1 (forward)
    push 0xaa                                    # 0040eb28
    call FUN_0051dc43                            # 0040eb2d
    add esp, 0x4                                 # 0040eb32
    mov dword ptr [ebp - local_208], eax         # 0040eb35
    movsx ecx, word ptr [0x5c39e3]               # 0040eb3b
    imul ecx, ecx, 0x8d                          # 0040eb42
    mov edx, dword ptr [ebp - local_208]         # 0040eb48
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040eb4e
    cmp dword ptr [ebp - local_208], 0x0         # 0040eb54
    jne.d8 L_0040eba1                            # 0040eb5b
    # block 0x0040eb5d: entered by fall-through of jne at 0x0040eb5b, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040eb5d
    push eax                                     # 0040eb64
    mov ecx, dword ptr [0x5bb57b]                # 0040eb65
    push ecx                                     # 0040eb6b
    push 0x54064c                                # 0040eb6c
    push 0x63888b                                # 0040eb71
    call FUN_0050ca3e                            # 0040eb76
    add esp, 0x10                                # 0040eb7b
    push 0x63888b                                # 0040eb7e
    push 0x540678                                # 0040eb83
    mov ecx, 0x583979                            # 0040eb88
    call FUN_0042639d                            # 0040eb8d
    mov ecx, 0x5cf659                            # 0040eb92
    call FUN_004c97b4                            # 0040eb97
    jmp.d32 L_00410c9e                           # 0040eb9c
L_0040eba1:
    # block 0x0040eba1: entered by jne at 0x0040eb5b, 16 instruction(s), ends with je to 0x0040ebf5 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040eba1
    imul edx, edx, 0x8d                          # 0040eba8
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040ebae
    mov ecx, 0x2a                                # 0040ebb4
    mov esi, dword ptr [ebp - local_20]          # 0040ebb9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ebbc
    movsw word ptr es:[edi], word ptr [esi]      # 0040ebbe
    mov eax, dword ptr [ebp - local_cc]          # 0040ebc0
    add eax, 0xaa                                # 0040ebc6
    mov dword ptr [ebp - local_cc], eax          # 0040ebcb
    mov ecx, dword ptr [ebp - local_20]          # 0040ebd1
    add ecx, 0xaa                                # 0040ebd4
    mov dword ptr [ebp - local_20], ecx          # 0040ebda
    movsx edx, word ptr [0x63a4cd]               # 0040ebdd
    test edx, edx                                # 0040ebe4
    je.d8 L_0040ebf5                             # 0040ebe6
    # block 0x0040ebe8: entered by fall-through of je at 0x0040ebe6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040ebf5
    push 0x540694                                # 0040ebe8
    call FUN_0044a2b7                            # 0040ebed
    add esp, 0x4                                 # 0040ebf2
L_0040ebf5:
    # block 0x0040ebf5: entered by je at 0x0040ebe6, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040ebf5
L_0040ebfa:
    # block 0x0040ebfa: entered by switch case, 6 instruction(s), ends with jne to 0x0040ee5c (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040ebfa
    mov dword ptr [ebp - local_120], eax         # 0040ebfd
    mov ecx, dword ptr [ebp - local_120]         # 0040ec03
    movsx edx, word ptr [ecx + field_aa]         # 0040ec09
    cmp edx, -0x1                                # 0040ec10
    jne.d32 L_0040ee5c                           # 0040ec13
    # block 0x0040ec19: entered by fall-through of jne at 0x0040ec13, 13 instruction(s), calls FUN_00423259, ends with jne to 0x0040ecb2 (forward)
    mov esi, dword ptr [ebp - local_120]         # 0040ec19
    add esi, 0xac                                # 0040ec1f
    mov ecx, 0x8                                 # 0040ec25
    lea edi, [ebp - local_f4]                    # 0040ec2a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ec30
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040ec32
    lea eax, [ebp - local_f4]                    # 0040ec33
    push eax                                     # 0040ec39
    mov ecx, 0x619a6b                            # 0040ec3a
    call FUN_00423259                            # 0040ec3f
    mov dword ptr [ebp - local_110], eax         # 0040ec44
    cmp dword ptr [ebp - local_110], 0x0         # 0040ec4a
    jne.d8 L_0040ecb2                            # 0040ec51
    # block 0x0040ec53: entered by fall-through of jne at 0x0040ec51, 3 instruction(s), ends with je to 0x0040ec89 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0040ec53
    test ecx, ecx                                # 0040ec5a
    je.d8 L_0040ec89                             # 0040ec5c
    # block 0x0040ec5e: entered by fall-through of je at 0x0040ec5c, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0040ec89
    lea edx, [ebp - local_f4]                    # 0040ec5e
    push edx                                     # 0040ec64
    push 0x5406e0                                # 0040ec65
    lea eax, [ebp - local_b8]                    # 0040ec6a
    push eax                                     # 0040ec70
    call FUN_0050ca3e                            # 0040ec71
    add esp, 0xc                                 # 0040ec76
    push 0x0                                     # 0040ec79
    push 0x0                                     # 0040ec7b
    lea ecx, [ebp - local_b8]                    # 0040ec7d
    push ecx                                     # 0040ec83
    call FUN_0052139c                            # 0040ec84
L_0040ec89:
    # block 0x0040ec89: entered by je at 0x0040ec5c, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0040ecf6
    lea edx, [ebp - local_f4]                    # 0040ec89
    push edx                                     # 0040ec8f
    push 0x5406f8                                # 0040ec90
    lea eax, [ebp - local_b8]                    # 0040ec95
    push eax                                     # 0040ec9b
    call FUN_0050ca3e                            # 0040ec9c
    add esp, 0xc                                 # 0040eca1
    lea ecx, [ebp - local_b8]                    # 0040eca4
    mov dword ptr [ebp - local_110], ecx         # 0040ecaa
    jmp.d8 L_0040ecf6                            # 0040ecb0
L_0040ecb2:
    # block 0x0040ecb2: entered by jne at 0x0040ec51, 8 instruction(s), ends with jbe to 0x0040ecf6 (forward)
    mov edi, dword ptr [ebp - local_110]         # 0040ecb2
    or ecx, -0x1                                 # 0040ecb8
    {load} xor eax, eax                          # 0040ecbb
    repne scasb al, byte ptr es:[edi]            # 0040ecbd
    not ecx                                      # 0040ecbf
    add ecx, -0x1                                # 0040ecc1
    cmp ecx, 0x9c40                              # 0040ecc4
    jbe.d8 L_0040ecf6                            # 0040ecca
    # block 0x0040eccc: entered by fall-through of jbe at 0x0040ecca, 10 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0040ecf6
    push 0x54073c                                # 0040eccc
    push 0x63888b                                # 0040ecd1
    call FUN_0050ca3e                            # 0040ecd6
    add esp, 0x8                                 # 0040ecdb
    push 0x0                                     # 0040ecde
    push 0x0                                     # 0040ece0
    push 0x63888b                                # 0040ece2
    call FUN_0052139c                            # 0040ece7
    mov ecx, 0x5cf659                            # 0040ecec
    call FUN_004c97b4                            # 0040ecf1
L_0040ecf6:
    # block 0x0040ecf6: entered by jmp at 0x0040ecb0; jbe at 0x0040ecca, 26 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040eda5 (forward)
    mov edi, dword ptr [ebp - local_110]         # 0040ecf6
    or ecx, -0x1                                 # 0040ecfc
    {load} xor eax, eax                          # 0040ecff
    repne scasb al, byte ptr es:[edi]            # 0040ed01
    not ecx                                      # 0040ed03
    add ecx, -0x1                                # 0040ed05
    {load} mov edx, ecx                          # 0040ed08
    mov edi, 0x540788                            # 0040ed0a
    or ecx, -0x1                                 # 0040ed0f
    {load} xor eax, eax                          # 0040ed12
    repne scasb al, byte ptr es:[edi]            # 0040ed14
    not ecx                                      # 0040ed16
    add ecx, -0x1                                # 0040ed18
    lea eax, [edx + ecx + field_ad]              # 0040ed1b
    mov word ptr [ebp - local_118], ax           # 0040ed22
    movsx ecx, word ptr [ebp - local_118]        # 0040ed29
    push ecx                                     # 0040ed30
    call FUN_0051dc43                            # 0040ed31
    add esp, 0x4                                 # 0040ed36
    mov dword ptr [ebp - local_20c], eax         # 0040ed39
    movsx edx, word ptr [0x5c39e3]               # 0040ed3f
    imul edx, edx, 0x8d                          # 0040ed46
    mov eax, dword ptr [ebp - local_20c]         # 0040ed4c
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040ed52
    cmp dword ptr [ebp - local_20c], 0x0         # 0040ed58
    jne.d8 L_0040eda5                            # 0040ed5f
    # block 0x0040ed61: entered by fall-through of jne at 0x0040ed5f, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040ed61
    push ecx                                     # 0040ed68
    mov edx, dword ptr [0x5bb57b]                # 0040ed69
    push edx                                     # 0040ed6f
    push 0x54078c                                # 0040ed70
    push 0x63888b                                # 0040ed75
    call FUN_0050ca3e                            # 0040ed7a
    add esp, 0x10                                # 0040ed7f
    push 0x63888b                                # 0040ed82
    push 0x5407b8                                # 0040ed87
    mov ecx, 0x583979                            # 0040ed8c
    call FUN_0042639d                            # 0040ed91
    mov ecx, 0x5cf659                            # 0040ed96
    call FUN_004c97b4                            # 0040ed9b
    jmp.d32 L_00410c9e                           # 0040eda0
L_0040eda5:
    # block 0x0040eda5: entered by jne at 0x0040ed5f, 48 instruction(s), ends with forward jump to 0x0040f028
    movsx eax, word ptr [0x5c39e3]               # 0040eda5
    imul eax, eax, 0x8d                          # 0040edac
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040edb2
    mov dword ptr [ebp - local_120], ecx         # 0040edb8
    mov word ptr [ebp - local_118], 0xcd         # 0040edbe
    mov ecx, 0x2a                                # 0040edc7
    mov esi, dword ptr [ebp - local_20]          # 0040edcc
    mov edi, dword ptr [ebp - local_120]         # 0040edcf
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040edd5
    movsw word ptr es:[edi], word ptr [esi]      # 0040edd7
    mov edi, dword ptr [ebp - local_110]         # 0040edd9
    or ecx, -0x1                                 # 0040eddf
    {load} xor eax, eax                          # 0040ede2
    repne scasb al, byte ptr es:[edi]            # 0040ede4
    not ecx                                      # 0040ede6
    add ecx, -0x1                                # 0040ede8
    {load} mov edx, ecx                          # 0040edeb
    mov edi, 0x5407d4                            # 0040eded
    or ecx, -0x1                                 # 0040edf2
    {load} xor eax, eax                          # 0040edf5
    repne scasb al, byte ptr es:[edi]            # 0040edf7
    not ecx                                      # 0040edf9
    add ecx, -0x1                                # 0040edfb
    {load} add edx, ecx                          # 0040edfe
    mov eax, dword ptr [ebp - local_120]         # 0040ee00
    mov word ptr [eax + field_aa], dx            # 0040ee06
    mov edi, dword ptr [ebp - local_110]         # 0040ee0d
    or ecx, -0x1                                 # 0040ee13
    {load} xor eax, eax                          # 0040ee16
    repne scasb al, byte ptr es:[edi]            # 0040ee18
    not ecx                                      # 0040ee1a
    mov esi, dword ptr [ebp - local_110]         # 0040ee1c
    mov edi, dword ptr [ebp - local_120]         # 0040ee22
    add edi, 0xac                                # 0040ee28
    {load} mov edx, ecx                          # 0040ee2e
    shr ecx, 0x2                                 # 0040ee30
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ee33
    {load} mov ecx, edx                          # 0040ee35
    and ecx, 0x3                                 # 0040ee37
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040ee3a
    mov edi, dword ptr [ebp - local_120]         # 0040ee3c
    add edi, 0xac                                # 0040ee42
    or ecx, -0x1                                 # 0040ee48
    {load} xor eax, eax                          # 0040ee4b
    repne scasb al, byte ptr es:[edi]            # 0040ee4d
    mov eax, dword ptr [0x5407d8]                # 0040ee4f
    mov dword ptr [edi - field_minus_1], eax     # 0040ee54
    jmp.d32 L_0040f028                           # 0040ee57
L_0040ee5c:
    # block 0x0040ee5c: entered by jne at 0x0040ec13, 4 instruction(s), ends with jl to 0x0040eeae (forward)
    mov ecx, dword ptr [ebp - local_120]         # 0040ee5c
    movsx edx, word ptr [ecx + field_aa]         # 0040ee62
    cmp edx, 0x2710                              # 0040ee69
    jl.d8 L_0040eeae                             # 0040ee6f
    # block 0x0040ee71: entered by fall-through of jl at 0x0040ee6f, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x00410c9e
    mov eax, dword ptr [ebp - local_120]         # 0040ee71
    movsx ecx, word ptr [eax + field_aa]         # 0040ee77
    push ecx                                     # 0040ee7e
    push 0x5407dc                                # 0040ee7f
    push 0x63888b                                # 0040ee84
    call FUN_0050ca3e                            # 0040ee89
    add esp, 0xc                                 # 0040ee8e
    push 0x0                                     # 0040ee91
    push 0x0                                     # 0040ee93
    push 0x63888b                                # 0040ee95
    call FUN_0052139c                            # 0040ee9a
    mov ecx, 0x5cf659                            # 0040ee9f
    call FUN_004c97b4                            # 0040eea4
    jmp.d32 L_00410c9e                           # 0040eea9
L_0040eeae:
    # block 0x0040eeae: entered by jl at 0x0040ee6f, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ef56 (forward)
    mov edx, dword ptr [ebp - local_120]         # 0040eeae
    movsx edx, word ptr [edx + field_aa]         # 0040eeb4
    mov edi, 0x540828                            # 0040eebb
    or ecx, -0x1                                 # 0040eec0
    {load} xor eax, eax                          # 0040eec3
    repne scasb al, byte ptr es:[edi]            # 0040eec5
    not ecx                                      # 0040eec7
    add ecx, -0x1                                # 0040eec9
    lea eax, [edx + ecx + field_ac]              # 0040eecc
    mov word ptr [ebp - local_118], ax           # 0040eed3
    movsx ecx, word ptr [ebp - local_118]        # 0040eeda
    push ecx                                     # 0040eee1
    call FUN_0051dc43                            # 0040eee2
    add esp, 0x4                                 # 0040eee7
    mov dword ptr [ebp - local_210], eax         # 0040eeea
    movsx edx, word ptr [0x5c39e3]               # 0040eef0
    imul edx, edx, 0x8d                          # 0040eef7
    mov eax, dword ptr [ebp - local_210]         # 0040eefd
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040ef03
    cmp dword ptr [ebp - local_210], 0x0         # 0040ef09
    jne.d8 L_0040ef56                            # 0040ef10
    # block 0x0040ef12: entered by fall-through of jne at 0x0040ef10, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040ef12
    push ecx                                     # 0040ef19
    mov edx, dword ptr [0x5bb57b]                # 0040ef1a
    push edx                                     # 0040ef20
    push 0x54082c                                # 0040ef21
    push 0x63888b                                # 0040ef26
    call FUN_0050ca3e                            # 0040ef2b
    add esp, 0x10                                # 0040ef30
    push 0x63888b                                # 0040ef33
    push 0x540858                                # 0040ef38
    mov ecx, 0x583979                            # 0040ef3d
    call FUN_0042639d                            # 0040ef42
    mov ecx, 0x5cf659                            # 0040ef47
    call FUN_004c97b4                            # 0040ef4c
    jmp.d32 L_00410c9e                           # 0040ef51
L_0040ef56:
    # block 0x0040ef56: entered by jne at 0x0040ef10, 52 instruction(s), falls into the block at 0x0040f028
    mov edi, 0x540874                            # 0040ef56
    or ecx, -0x1                                 # 0040ef5b
    {load} xor eax, eax                          # 0040ef5e
    repne scasb al, byte ptr es:[edi]            # 0040ef60
    not ecx                                      # 0040ef62
    add ecx, -0x1                                # 0040ef64
    mov ax, word ptr [ebp - local_118]           # 0040ef67
    {load} sub ax, cx                            # 0040ef6e
    mov word ptr [ebp - local_118], ax           # 0040ef71
    movsx ecx, word ptr [ebp - local_118]        # 0040ef78
    mov esi, dword ptr [ebp - local_20]          # 0040ef7f
    movsx edx, word ptr [0x5c39e3]               # 0040ef82
    imul edx, edx, 0x8d                          # 0040ef89
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040ef8f
    {load} mov eax, ecx                          # 0040ef95
    shr ecx, 0x2                                 # 0040ef97
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ef9a
    {load} mov ecx, eax                          # 0040ef9c
    and ecx, 0x3                                 # 0040ef9e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040efa1
    movsx ecx, word ptr [0x5c39e3]               # 0040efa3
    imul ecx, ecx, 0x8d                          # 0040efaa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040efb0
    mov dword ptr [ebp - local_120], edx         # 0040efb6
    mov edi, 0x540878                            # 0040efbc
    or ecx, -0x1                                 # 0040efc1
    {load} xor eax, eax                          # 0040efc4
    repne scasb al, byte ptr es:[edi]            # 0040efc6
    not ecx                                      # 0040efc8
    add ecx, -0x1                                # 0040efca
    mov esi, 0x54087c                            # 0040efcd
    mov eax, dword ptr [ebp - local_120]         # 0040efd2
    movsx edx, word ptr [eax + field_aa]         # 0040efd8
    mov eax, dword ptr [ebp - local_120]         # 0040efdf
    lea edi, [eax + edx + field_ac]              # 0040efe5
    {load} mov edx, ecx                          # 0040efec
    shr ecx, 0x2                                 # 0040efee
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040eff1
    {load} mov ecx, edx                          # 0040eff3
    and ecx, 0x3                                 # 0040eff5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040eff8
    mov edi, 0x540880                            # 0040effa
    or ecx, -0x1                                 # 0040efff
    {load} xor eax, eax                          # 0040f002
    repne scasb al, byte ptr es:[edi]            # 0040f004
    not ecx                                      # 0040f006
    add ecx, -0x1                                # 0040f008
    mov eax, dword ptr [ebp - local_120]         # 0040f00b
    mov dx, word ptr [eax + field_aa]            # 0040f011
    {load} add dx, cx                            # 0040f018
    mov eax, dword ptr [ebp - local_120]         # 0040f01b
    mov word ptr [eax + field_aa], dx            # 0040f021
L_0040f028:
    # block 0x0040f028: entered by jmp at 0x0040ee57, 11 instruction(s), ends with je to 0x0040f064 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040f028
    mov edx, dword ptr [ebp - local_cc]          # 0040f02f
    {load} add edx, ecx                          # 0040f035
    mov dword ptr [ebp - local_cc], edx          # 0040f037
    movsx eax, word ptr [ebp - local_118]        # 0040f03d
    mov ecx, dword ptr [ebp - local_20]          # 0040f044
    {load} add ecx, eax                          # 0040f047
    mov dword ptr [ebp - local_20], ecx          # 0040f049
    movsx edx, word ptr [0x63a4cd]               # 0040f04c
    test edx, edx                                # 0040f053
    je.d8 L_0040f064                             # 0040f055
    # block 0x0040f057: entered by fall-through of je at 0x0040f055, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040f064
    push 0x540884                                # 0040f057
    call FUN_0044a2b7                            # 0040f05c
    add esp, 0x4                                 # 0040f061
L_0040f064:
    # block 0x0040f064: entered by je at 0x0040f055, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040f064
L_0040f069:
    # block 0x0040f069: entered by switch case, 8 instruction(s), ends with jne to 0x0040f0af (forward)
    mov eax, dword ptr [ebp - local_20]          # 0040f069
    mov dword ptr [ebp - local_11c], eax         # 0040f06c
    movsx ecx, word ptr [0x5c39e3]               # 0040f072
    imul ecx, ecx, 0x8d                          # 0040f079
    {load} xor edx, edx                          # 0040f07f
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040f081
    cmp edx, 0xa1                                # 0040f087
    jne.d8 L_0040f0af                            # 0040f08d
    # block 0x0040f08f: entered by fall-through of jne at 0x0040f08d, 7 instruction(s), ends with forward jump to 0x0040f0c4
    mov eax, dword ptr [ebp - local_20]          # 0040f08f
    mov dword ptr [ebp - local_128], eax         # 0040f092
    mov ecx, dword ptr [ebp - local_128]         # 0040f098
    add ecx, 0x31                                # 0040f09e
    mov dword ptr [ebp - local_fc], ecx          # 0040f0a1
    mov word ptr [ebp - local_18], 0x2743        # 0040f0a7
    jmp.d8 L_0040f0c4                            # 0040f0ad
L_0040f0af:
    # block 0x0040f0af: entered by jne at 0x0040f08d, 4 instruction(s), falls into the block at 0x0040f0c4
    mov edx, dword ptr [ebp - local_11c]         # 0040f0af
    add edx, 0x2e                                # 0040f0b5
    mov dword ptr [ebp - local_fc], edx          # 0040f0b8
    mov word ptr [ebp - local_18], 0x2740        # 0040f0be
L_0040f0c4:
    # block 0x0040f0c4: entered by jmp at 0x0040f0ad, 4 instruction(s), ends with jne to 0x0040f1de (forward)
    mov eax, dword ptr [ebp - local_fc]          # 0040f0c4
    movsx ecx, word ptr [eax]                    # 0040f0ca
    cmp ecx, -0x1                                # 0040f0cd
    jne.d32 L_0040f1de                           # 0040f0d0
    # block 0x0040f0d6: entered by fall-through of jne at 0x0040f0d0, 13 instruction(s), calls FUN_00423259, ends with jne to 0x0040f16c (forward)
    mov esi, dword ptr [ebp - local_fc]          # 0040f0d6
    add esi, 0x2                                 # 0040f0dc
    mov ecx, 0x8                                 # 0040f0df
    lea edi, [ebp - local_f4]                    # 0040f0e4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f0ea
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040f0ec
    lea edx, [ebp - local_f4]                    # 0040f0ed
    push edx                                     # 0040f0f3
    mov ecx, 0x619a6b                            # 0040f0f4
    call FUN_00423259                            # 0040f0f9
    mov dword ptr [ebp - local_110], eax         # 0040f0fe
    cmp dword ptr [ebp - local_110], 0x0         # 0040f104
    jne.d8 L_0040f16c                            # 0040f10b
    # block 0x0040f10d: entered by fall-through of jne at 0x0040f10b, 3 instruction(s), ends with je to 0x0040f143 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0040f10d
    test eax, eax                                # 0040f114
    je.d8 L_0040f143                             # 0040f116
    # block 0x0040f118: entered by fall-through of je at 0x0040f116, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0040f143
    lea ecx, [ebp - local_f4]                    # 0040f118
    push ecx                                     # 0040f11e
    push 0x5408bc                                # 0040f11f
    lea edx, [ebp - local_b8]                    # 0040f124
    push edx                                     # 0040f12a
    call FUN_0050ca3e                            # 0040f12b
    add esp, 0xc                                 # 0040f130
    push 0x0                                     # 0040f133
    push 0x0                                     # 0040f135
    lea eax, [ebp - local_b8]                    # 0040f137
    push eax                                     # 0040f13d
    call FUN_0052139c                            # 0040f13e
L_0040f143:
    # block 0x0040f143: entered by je at 0x0040f116, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0040f1b0
    lea ecx, [ebp - local_f4]                    # 0040f143
    push ecx                                     # 0040f149
    push 0x5408dc                                # 0040f14a
    lea edx, [ebp - local_b8]                    # 0040f14f
    push edx                                     # 0040f155
    call FUN_0050ca3e                            # 0040f156
    add esp, 0xc                                 # 0040f15b
    lea eax, [ebp - local_b8]                    # 0040f15e
    mov dword ptr [ebp - local_110], eax         # 0040f164
    jmp.d8 L_0040f1b0                            # 0040f16a
L_0040f16c:
    # block 0x0040f16c: entered by jne at 0x0040f10b, 8 instruction(s), ends with jbe to 0x0040f1b0 (forward)
    mov edi, dword ptr [ebp - local_110]         # 0040f16c
    or ecx, -0x1                                 # 0040f172
    {load} xor eax, eax                          # 0040f175
    repne scasb al, byte ptr es:[edi]            # 0040f177
    not ecx                                      # 0040f179
    add ecx, -0x1                                # 0040f17b
    cmp ecx, 0x9c40                              # 0040f17e
    jbe.d8 L_0040f1b0                            # 0040f184
    # block 0x0040f186: entered by fall-through of jbe at 0x0040f184, 10 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0040f1b0
    push 0x540920                                # 0040f186
    push 0x63888b                                # 0040f18b
    call FUN_0050ca3e                            # 0040f190
    add esp, 0x8                                 # 0040f195
    push 0x0                                     # 0040f198
    push 0x0                                     # 0040f19a
    push 0x63888b                                # 0040f19c
    call FUN_0052139c                            # 0040f1a1
    mov ecx, 0x5cf659                            # 0040f1a6
    call FUN_004c97b4                            # 0040f1ab
L_0040f1b0:
    # block 0x0040f1b0: entered by jmp at 0x0040f16a; jbe at 0x0040f184, 11 instruction(s), ends with forward jump to 0x0040f253
    mov edi, dword ptr [ebp - local_110]         # 0040f1b0
    or ecx, -0x1                                 # 0040f1b6
    {load} xor eax, eax                          # 0040f1b9
    repne scasb al, byte ptr es:[edi]            # 0040f1bb
    not ecx                                      # 0040f1bd
    add ecx, 0xac                                # 0040f1bf
    mov word ptr [ebp - local_118], cx           # 0040f1c5
    movsx ecx, word ptr [ebp - local_18]         # 0040f1cc
    sub ecx, 0x26ef                              # 0040f1d0
    mov dword ptr [ebp - local_124], ecx         # 0040f1d6
    jmp.d8 L_0040f253                            # 0040f1dc
L_0040f1de:
    # block 0x0040f1de: entered by jne at 0x0040f0d0, 4 instruction(s), ends with jl to 0x0040f223 (forward)
    mov edx, dword ptr [ebp - local_fc]          # 0040f1de
    movsx eax, word ptr [edx]                    # 0040f1e4
    cmp eax, 0x2710                              # 0040f1e7
    jl.d8 L_0040f223                             # 0040f1ec
    # block 0x0040f1ee: entered by fall-through of jl at 0x0040f1ec, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0040f223
    mov ecx, dword ptr [ebp - local_11c]         # 0040f1ee
    movsx edx, word ptr [ecx + field_2e]         # 0040f1f4
    push edx                                     # 0040f1f8
    push 0x54096c                                # 0040f1f9
    push 0x63888b                                # 0040f1fe
    call FUN_0050ca3e                            # 0040f203
    add esp, 0xc                                 # 0040f208
    push 0x0                                     # 0040f20b
    push 0x0                                     # 0040f20d
    push 0x63888b                                # 0040f20f
    call FUN_0052139c                            # 0040f214
    mov ecx, 0x5cf659                            # 0040f219
    call FUN_004c97b4                            # 0040f21e
L_0040f223:
    # block 0x0040f223: entered by jl at 0x0040f1ec, 9 instruction(s), falls into the block at 0x0040f253
    mov eax, dword ptr [ebp - local_fc]          # 0040f223
    movsx ecx, word ptr [eax]                    # 0040f229
    movsx edx, word ptr [ebp - local_18]         # 0040f22c
    lea eax, [ecx + edx - field_minus_2710]      # 0040f230
    mov dword ptr [ebp - local_124], eax         # 0040f237
    mov ecx, dword ptr [ebp - local_fc]          # 0040f23d
    movsx edx, word ptr [ecx]                    # 0040f243
    add edx, 0xac                                # 0040f246
    mov word ptr [ebp - local_118], dx           # 0040f24c
L_0040f253:
    # block 0x0040f253: entered by jmp at 0x0040f1dc, 20 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040f2f1 (forward)
    mov edi, 0x5409b8                            # 0040f253
    or ecx, -0x1                                 # 0040f258
    {load} xor eax, eax                          # 0040f25b
    repne scasb al, byte ptr es:[edi]            # 0040f25d
    not ecx                                      # 0040f25f
    add ecx, -0x1                                # 0040f261
    mov ax, word ptr [ebp - local_118]           # 0040f264
    {load} add ax, cx                            # 0040f26b
    mov word ptr [ebp - local_118], ax           # 0040f26e
    movsx ecx, word ptr [ebp - local_118]        # 0040f275
    push ecx                                     # 0040f27c
    call FUN_0051dc43                            # 0040f27d
    add esp, 0x4                                 # 0040f282
    mov dword ptr [ebp - local_214], eax         # 0040f285
    movsx edx, word ptr [0x5c39e3]               # 0040f28b
    imul edx, edx, 0x8d                          # 0040f292
    mov eax, dword ptr [ebp - local_214]         # 0040f298
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040f29e
    cmp dword ptr [ebp - local_214], 0x0         # 0040f2a4
    jne.d8 L_0040f2f1                            # 0040f2ab
    # block 0x0040f2ad: entered by fall-through of jne at 0x0040f2ab, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040f2ad
    push ecx                                     # 0040f2b4
    mov edx, dword ptr [0x5bb57b]                # 0040f2b5
    push edx                                     # 0040f2bb
    push 0x5409bc                                # 0040f2bc
    push 0x63888b                                # 0040f2c1
    call FUN_0050ca3e                            # 0040f2c6
    add esp, 0x10                                # 0040f2cb
    push 0x63888b                                # 0040f2ce
    push 0x5409e8                                # 0040f2d3
    mov ecx, 0x583979                            # 0040f2d8
    call FUN_0042639d                            # 0040f2dd
    mov ecx, 0x5cf659                            # 0040f2e2
    call FUN_004c97b4                            # 0040f2e7
    jmp.d32 L_00410c9e                           # 0040f2ec
L_0040f2f1:
    # block 0x0040f2f1: entered by jne at 0x0040f2ab, 17 instruction(s), ends with jne to 0x0040f372 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040f2f1
    {load} xor eax, eax                          # 0040f2f8
    movsx edx, word ptr [0x5c39e3]               # 0040f2fa
    imul edx, edx, 0x8d                          # 0040f301
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040f307
    {load} mov edx, ecx                          # 0040f30d
    shr ecx, 0x2                                 # 0040f30f
    rep stosd dword ptr es:[edi], eax            # 0040f312
    {load} mov ecx, edx                          # 0040f314
    and ecx, 0x3                                 # 0040f316
    rep stosb byte ptr es:[edi], al              # 0040f319
    movsx eax, word ptr [0x5c39e3]               # 0040f31b
    imul eax, eax, 0x8d                          # 0040f322
    {load} xor ecx, ecx                          # 0040f328
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0040f32a
    cmp ecx, 0xa1                                # 0040f330
    jne.d8 L_0040f372                            # 0040f336
    # block 0x0040f338: entered by fall-through of jne at 0x0040f336, 15 instruction(s), calls FUN_00410f99, ends with forward jump to 0x0040f399
    mov edx, dword ptr [ebp - local_128]         # 0040f338
    mov al, byte ptr [edx + field_30]            # 0040f33e
    push eax                                     # 0040f341
    mov ecx, dword ptr [ebp - local_128]         # 0040f342
    mov dx, word ptr [ecx + field_2e]            # 0040f348
    push edx                                     # 0040f34c
    mov eax, dword ptr [ebp - local_11c]         # 0040f34d
    push eax                                     # 0040f353
    movsx ecx, word ptr [0x5c39e3]               # 0040f354
    imul ecx, ecx, 0x8d                          # 0040f35b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040f361
    push edx                                     # 0040f367
    call FUN_00410f99                            # 0040f368
    add esp, 0x10                                # 0040f36d
    jmp.d8 L_0040f399                            # 0040f370
L_0040f372:
    # block 0x0040f372: entered by jne at 0x0040f336, 10 instruction(s), calls FUN_00410f99, falls into the block at 0x0040f399
    push 0x1                                     # 0040f372
    push -0x1                                    # 0040f374
    mov eax, dword ptr [ebp - local_11c]         # 0040f376
    push eax                                     # 0040f37c
    movsx ecx, word ptr [0x5c39e3]               # 0040f37d
    imul ecx, ecx, 0x8d                          # 0040f384
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040f38a
    push edx                                     # 0040f390
    call FUN_00410f99                            # 0040f391
    add esp, 0x10                                # 0040f396
L_0040f399:
    # block 0x0040f399: entered by jmp at 0x0040f370, 8 instruction(s), ends with jne to 0x0040f42f (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040f399
    imul eax, eax, 0x8d                          # 0040f3a0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0040f3a6
    mov dword ptr [ebp - local_120], ecx         # 0040f3ac
    mov edx, dword ptr [ebp - local_fc]          # 0040f3b2
    movsx eax, word ptr [edx]                    # 0040f3b8
    cmp eax, -0x1                                # 0040f3bb
    jne.d8 L_0040f42f                            # 0040f3be
    # block 0x0040f3c0: entered by fall-through of jne at 0x0040f3be, 30 instruction(s), ends with forward jump to 0x0040f4b8
    mov edi, dword ptr [ebp - local_110]         # 0040f3c0
    or ecx, -0x1                                 # 0040f3c6
    {load} xor eax, eax                          # 0040f3c9
    repne scasb al, byte ptr es:[edi]            # 0040f3cb
    not ecx                                      # 0040f3cd
    add ecx, -0x1                                # 0040f3cf
    mov edx, dword ptr [ebp - local_120]         # 0040f3d2
    mov word ptr [edx + field_aa], cx            # 0040f3d8
    mov edi, dword ptr [ebp - local_110]         # 0040f3df
    or ecx, -0x1                                 # 0040f3e5
    {load} xor eax, eax                          # 0040f3e8
    repne scasb al, byte ptr es:[edi]            # 0040f3ea
    not ecx                                      # 0040f3ec
    mov esi, dword ptr [ebp - local_110]         # 0040f3ee
    mov edi, dword ptr [ebp - local_120]         # 0040f3f4
    add edi, 0xac                                # 0040f3fa
    {load} mov eax, ecx                          # 0040f400
    shr ecx, 0x2                                 # 0040f402
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f405
    {load} mov ecx, eax                          # 0040f407
    and ecx, 0x3                                 # 0040f409
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040f40c
    mov edi, dword ptr [ebp - local_120]         # 0040f40e
    add edi, 0xac                                # 0040f414
    or ecx, -0x1                                 # 0040f41a
    {load} xor eax, eax                          # 0040f41d
    repne scasb al, byte ptr es:[edi]            # 0040f41f
    mov ecx, dword ptr [0x540a04]                # 0040f421
    mov dword ptr [edi - field_minus_1], ecx     # 0040f427
    jmp.d32 L_0040f4b8                           # 0040f42a
L_0040f42f:
    # block 0x0040f42f: entered by jne at 0x0040f3be, 18 instruction(s), ends with je to 0x0040f4b8 (forward)
    mov edx, dword ptr [ebp - local_fc]          # 0040f42f
    movsx eax, word ptr [edx]                    # 0040f435
    add eax, 0x2                                 # 0040f438
    mov word ptr [ebp - local_118], ax           # 0040f43b
    movsx ecx, word ptr [ebp - local_118]        # 0040f442
    mov esi, dword ptr [ebp - local_fc]          # 0040f449
    mov edi, dword ptr [ebp - local_120]         # 0040f44f
    add edi, 0xaa                                # 0040f455
    {load} mov edx, ecx                          # 0040f45b
    shr ecx, 0x2                                 # 0040f45d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f460
    {load} mov ecx, edx                          # 0040f462
    and ecx, 0x3                                 # 0040f464
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040f467
    mov eax, dword ptr [ebp - local_120]         # 0040f469
    movsx ecx, word ptr [eax + field_aa]         # 0040f46f
    test ecx, ecx                                # 0040f476
    je.d8 L_0040f4b8                             # 0040f478
    # block 0x0040f47a: entered by fall-through of je at 0x0040f478, 17 instruction(s), falls into the block at 0x0040f4b8
    mov edi, 0x540a08                            # 0040f47a
    or ecx, -0x1                                 # 0040f47f
    {load} xor eax, eax                          # 0040f482
    repne scasb al, byte ptr es:[edi]            # 0040f484
    not ecx                                      # 0040f486
    add ecx, -0x1                                # 0040f488
    mov esi, 0x540a0c                            # 0040f48b
    mov edx, dword ptr [ebp - local_120]         # 0040f490
    movsx eax, word ptr [edx + field_aa]         # 0040f496
    mov edx, dword ptr [ebp - local_120]         # 0040f49d
    lea edi, [edx + eax + field_ac]              # 0040f4a3
    {load} mov eax, ecx                          # 0040f4aa
    shr ecx, 0x2                                 # 0040f4ac
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f4af
    {load} mov ecx, eax                          # 0040f4b1
    and ecx, 0x3                                 # 0040f4b3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040f4b6
L_0040f4b8:
    # block 0x0040f4b8: entered by jmp at 0x0040f42a; je at 0x0040f478, 4 instruction(s), ends with je to 0x0040f4f7 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 0040f4b8
    movsx edx, word ptr [ecx + field_aa]         # 0040f4be
    test edx, edx                                # 0040f4c5
    je.d8 L_0040f4f7                             # 0040f4c7
    # block 0x0040f4c9: entered by fall-through of je at 0x0040f4c7, 11 instruction(s), falls into the block at 0x0040f4f7
    mov edi, 0x540a10                            # 0040f4c9
    or ecx, -0x1                                 # 0040f4ce
    {load} xor eax, eax                          # 0040f4d1
    repne scasb al, byte ptr es:[edi]            # 0040f4d3
    not ecx                                      # 0040f4d5
    add ecx, -0x1                                # 0040f4d7
    mov eax, dword ptr [ebp - local_120]         # 0040f4da
    mov dx, word ptr [eax + field_aa]            # 0040f4e0
    {load} add dx, cx                            # 0040f4e7
    mov eax, dword ptr [ebp - local_120]         # 0040f4ea
    mov word ptr [eax + field_aa], dx            # 0040f4f0
L_0040f4f7:
    # block 0x0040f4f7: entered by je at 0x0040f4c7, 9 instruction(s), ends with je to 0x0040f52d (forward)
    mov ecx, dword ptr [ebp - local_cc]          # 0040f4f7
    add ecx, dword ptr [ebp - local_124]         # 0040f4fd
    mov dword ptr [ebp - local_cc], ecx          # 0040f503
    mov edx, dword ptr [ebp - local_20]          # 0040f509
    add edx, dword ptr [ebp - local_124]         # 0040f50c
    mov dword ptr [ebp - local_20], edx          # 0040f512
    movsx eax, word ptr [0x63a4cd]               # 0040f515
    test eax, eax                                # 0040f51c
    je.d8 L_0040f52d                             # 0040f51e
    # block 0x0040f520: entered by fall-through of je at 0x0040f51e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040f52d
    push 0x540a14                                # 0040f520
    call FUN_0044a2b7                            # 0040f525
    add esp, 0x4                                 # 0040f52a
L_0040f52d:
    # block 0x0040f52d: entered by je at 0x0040f51e, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040f52d
L_0040f532:
    # block 0x0040f532: entered by switch case, 6 instruction(s), ends with jl to 0x0040f582 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0040f532
    mov dword ptr [ebp - local_12c], ecx         # 0040f535
    mov edx, dword ptr [ebp - local_12c]         # 0040f53b
    movsx eax, word ptr [edx]                    # 0040f541
    cmp eax, 0xa                                 # 0040f544
    jl.d8 L_0040f582                             # 0040f547
    # block 0x0040f549: entered by fall-through of jl at 0x0040f547, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x00410c9e
    mov ecx, dword ptr [ebp - local_12c]         # 0040f549
    movsx edx, word ptr [ecx]                    # 0040f54f
    push edx                                     # 0040f552
    push 0x540a48                                # 0040f553
    push 0x63888b                                # 0040f558
    call FUN_0050ca3e                            # 0040f55d
    add esp, 0xc                                 # 0040f562
    push 0x0                                     # 0040f565
    push 0x0                                     # 0040f567
    push 0x63888b                                # 0040f569
    call FUN_0052139c                            # 0040f56e
    mov ecx, 0x5cf659                            # 0040f573
    call FUN_004c97b4                            # 0040f578
    jmp.d32 L_00410c9e                           # 0040f57d
L_0040f582:
    # block 0x0040f582: entered by jl at 0x0040f547, 18 instruction(s), ends with forward jump to 0x0040f5ec
    mov eax, dword ptr [ebp - local_12c]         # 0040f582
    movsx ecx, word ptr [eax]                    # 0040f588
    sub ecx, 0x1                                 # 0040f58b
    imul ecx, ecx, 0x21                          # 0040f58e
    add ecx, 0x2                                 # 0040f591
    mov word ptr [ebp - local_118], cx           # 0040f594
    movsx edx, word ptr [ebp - local_118]        # 0040f59b
    mov eax, dword ptr [ebp - local_cc]          # 0040f5a2
    {load} add eax, edx                          # 0040f5a8
    mov dword ptr [ebp - local_cc], eax          # 0040f5aa
    movsx ecx, word ptr [ebp - local_118]        # 0040f5b0
    mov edx, dword ptr [ebp - local_20]          # 0040f5b7
    {load} add edx, ecx                          # 0040f5ba
    mov dword ptr [ebp - local_20], edx          # 0040f5bc
    mov dword ptr [ebp - local_10c], 0x0         # 0040f5bf
    mov word ptr [ebp - local_10], 0xffff        # 0040f5c9
    mov word ptr [ebp - local_c0], 0x0           # 0040f5cf
    jmp.d8 L_0040f5ec                            # 0040f5d8
L_0040f5da:
    # block 0x0040f5da: entered by jmp at 0x0040f695, 3 instruction(s), falls into the block at 0x0040f5ec
    mov ax, word ptr [ebp - local_c0]            # 0040f5da
    .insn 0x66, 0x05, 0x0001{:u16}               # 0040f5e1
    mov word ptr [ebp - local_c0], ax            # 0040f5e5
L_0040f5ec:
    # block 0x0040f5ec: entered by jmp at 0x0040f5d8, 5 instruction(s), ends with jge to 0x0040f69a (forward)
    movsx ecx, word ptr [ebp - local_c0]         # 0040f5ec
    mov edx, dword ptr [ebp - local_12c]         # 0040f5f3
    movsx eax, word ptr [edx]                    # 0040f5f9
    {load} cmp ecx, eax                          # 0040f5fc
    jge.d32 L_0040f69a                           # 0040f5fe
    # block 0x0040f604: entered by fall-through of jge at 0x0040f5fe, 6 instruction(s), ends with jne to 0x0040f695 (forward)
    movsx ecx, word ptr [ebp - local_c0]         # 0040f604
    imul ecx, ecx, 0x21                          # 0040f60b
    mov edx, dword ptr [ebp - local_12c]         # 0040f60e
    movsx eax, byte ptr [edx + ecx + field_2]    # 0040f614
    cmp eax, 0x2a                                # 0040f619
    jne.d8 L_0040f695                            # 0040f61c
    # block 0x0040f61e: entered by fall-through of jne at 0x0040f61c, 40 instruction(s), falls into the block at 0x0040f695
    movsx ecx, word ptr [ebp - local_c0]         # 0040f61e
    imul ecx, ecx, 0x21                          # 0040f625
    mov edx, dword ptr [ebp - local_12c]         # 0040f628
    lea eax, [edx + ecx + field_3]               # 0040f62e
    {load} mov edi, eax                          # 0040f632
    lea edx, [ebp - local_48]                    # 0040f634
    or ecx, -0x1                                 # 0040f637
    {load} xor eax, eax                          # 0040f63a
    repne scasb al, byte ptr es:[edi]            # 0040f63c
    not ecx                                      # 0040f63e
    {load} sub edi, ecx                          # 0040f640
    {load} mov esi, edi                          # 0040f642
    {load} mov eax, ecx                          # 0040f644
    {load} mov edi, edx                          # 0040f646
    shr ecx, 0x2                                 # 0040f648
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f64b
    {load} mov ecx, eax                          # 0040f64d
    and ecx, 0x3                                 # 0040f64f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040f652
    lea edi, [ebp - local_48]                    # 0040f654
    movsx ecx, word ptr [ebp - local_c0]         # 0040f657
    imul ecx, ecx, 0x21                          # 0040f65e
    mov edx, dword ptr [ebp - local_12c]         # 0040f661
    lea eax, [edx + ecx + field_2]               # 0040f667
    {load} mov edx, eax                          # 0040f66b
    or ecx, -0x1                                 # 0040f66d
    {load} xor eax, eax                          # 0040f670
    repne scasb al, byte ptr es:[edi]            # 0040f672
    not ecx                                      # 0040f674
    {load} sub edi, ecx                          # 0040f676
    {load} mov esi, edi                          # 0040f678
    {load} mov eax, ecx                          # 0040f67a
    {load} mov edi, edx                          # 0040f67c
    shr ecx, 0x2                                 # 0040f67e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f681
    {load} mov ecx, eax                          # 0040f683
    and ecx, 0x3                                 # 0040f685
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040f688
    mov cx, word ptr [ebp - local_c0]            # 0040f68a
    mov word ptr [ebp - local_10], cx            # 0040f691
L_0040f695:
    # block 0x0040f695: entered by jne at 0x0040f61c, 1 instruction(s), ends with backward jump to 0x0040f5da
    jmp.d32 L_0040f5da                           # 0040f695
L_0040f69a:
    # block 0x0040f69a: entered by jge at 0x0040f5fe, 3 instruction(s), ends with jne to 0x0040f6b8 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0040f69a
    cmp edx, -0x1                                # 0040f69e
    jne.d8 L_0040f6b8                            # 0040f6a1
    # block 0x0040f6a3: entered by fall-through of jne at 0x0040f6a1, 6 instruction(s), calls FUN_0050cd50, falls into the block at 0x0040f6b8
    call FUN_0050cd50                            # 0040f6a3
    mov ecx, dword ptr [ebp - local_12c]         # 0040f6a8
    movsx ecx, word ptr [ecx]                    # 0040f6ae
    cdq                                          # 0040f6b1
    idiv ecx                                     # 0040f6b2
    mov word ptr [ebp - local_10], dx            # 0040f6b4
L_0040f6b8:
    # block 0x0040f6b8: entered by jne at 0x0040f6a1, 6 instruction(s), ends with jne to 0x0040f7d6 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040f6b8
    imul edx, edx, 0x8d                          # 0040f6bf
    {load} xor eax, eax                          # 0040f6c5
    mov al, byte ptr [edx + 0x5bb5e3]            # 0040f6c7
    cmp eax, 0x9e                                # 0040f6cd
    jne.d32 L_0040f7d6                           # 0040f6d2
    # block 0x0040f6d8: entered by fall-through of jne at 0x0040f6d2, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040f751 (forward)
    push 0xaa                                    # 0040f6d8
    call FUN_0051dc43                            # 0040f6dd
    add esp, 0x4                                 # 0040f6e2
    mov dword ptr [ebp - local_218], eax         # 0040f6e5
    movsx ecx, word ptr [0x5c39e3]               # 0040f6eb
    imul ecx, ecx, 0x8d                          # 0040f6f2
    mov edx, dword ptr [ebp - local_218]         # 0040f6f8
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040f6fe
    cmp dword ptr [ebp - local_218], 0x0         # 0040f704
    jne.d8 L_0040f751                            # 0040f70b
    # block 0x0040f70d: entered by fall-through of jne at 0x0040f70b, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040f70d
    push eax                                     # 0040f714
    mov ecx, dword ptr [0x5bb57b]                # 0040f715
    push ecx                                     # 0040f71b
    push 0x540a9c                                # 0040f71c
    push 0x63888b                                # 0040f721
    call FUN_0050ca3e                            # 0040f726
    add esp, 0x10                                # 0040f72b
    push 0x63888b                                # 0040f72e
    push 0x540ac8                                # 0040f733
    mov ecx, 0x583979                            # 0040f738
    call FUN_0042639d                            # 0040f73d
    mov ecx, 0x5cf659                            # 0040f742
    call FUN_004c97b4                            # 0040f747
    jmp.d32 L_00410c9e                           # 0040f74c
L_0040f751:
    # block 0x0040f751: entered by jne at 0x0040f70b, 26 instruction(s), ends with je to 0x0040f7d1 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0040f751
    imul edx, edx, 0x8d                          # 0040f758
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040f75e
    mov ecx, 0x2a                                # 0040f764
    mov esi, dword ptr [ebp - local_20]          # 0040f769
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f76c
    movsw word ptr es:[edi], word ptr [esi]      # 0040f76e
    movsx eax, word ptr [ebp - local_10]         # 0040f770
    imul eax, eax, 0x21                          # 0040f774
    mov ecx, dword ptr [ebp - local_12c]         # 0040f777
    lea esi, [ecx + eax + field_2]               # 0040f77d
    movsx edx, word ptr [0x5c39e3]               # 0040f781
    imul edx, edx, 0x8d                          # 0040f788
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040f78e
    mov ecx, 0x8                                 # 0040f794
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f799
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040f79b
    mov eax, dword ptr [ebp - local_cc]          # 0040f79c
    add eax, 0xaa                                # 0040f7a2
    mov dword ptr [ebp - local_cc], eax          # 0040f7a7
    mov ecx, dword ptr [ebp - local_20]          # 0040f7ad
    add ecx, 0xaa                                # 0040f7b0
    mov dword ptr [ebp - local_20], ecx          # 0040f7b6
    movsx edx, word ptr [0x63a4cd]               # 0040f7b9
    test edx, edx                                # 0040f7c0
    je.d8 L_0040f7d1                             # 0040f7c2
    # block 0x0040f7c4: entered by fall-through of je at 0x0040f7c2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040f7d1
    push 0x540ae4                                # 0040f7c4
    call FUN_0044a2b7                            # 0040f7c9
    add esp, 0x4                                 # 0040f7ce
L_0040f7d1:
    # block 0x0040f7d1: entered by je at 0x0040f7c2, 1 instruction(s), ends with forward jump to 0x0040fd12
    jmp.d32 L_0040fd12                           # 0040f7d1
L_0040f7d6:
    # block 0x0040f7d6: entered by jne at 0x0040f6d2, 12 instruction(s), ends with forward jump to 0x0040f830
    mov eax, dword ptr [ebp - local_20]          # 0040f7d6
    mov dword ptr [ebp - local_11c], eax         # 0040f7d9
    mov ecx, dword ptr [ebp - local_11c]         # 0040f7df
    add ecx, 0x2e                                # 0040f7e5
    mov dword ptr [ebp - local_fc], ecx          # 0040f7e8
    mov edx, dword ptr [ebp - local_fc]          # 0040f7ee
    mov dword ptr [ebp - local_110], edx         # 0040f7f4
    mov dword ptr [ebp - local_24], 0x0          # 0040f7fa
    mov word ptr [ebp - local_c8], 0x0           # 0040f801
    mov word ptr [ebp - local_118], 0xac         # 0040f80a
    mov word ptr [ebp - local_c0], 0x0           # 0040f813
    jmp.d8 L_0040f830                            # 0040f81c
L_0040f81e:
    # block 0x0040f81e: entered by jmp at 0x0040fa1c, 3 instruction(s), falls into the block at 0x0040f830
    mov ax, word ptr [ebp - local_c0]            # 0040f81e
    .insn 0x66, 0x05, 0x0001{:u16}               # 0040f825
    mov word ptr [ebp - local_c0], ax            # 0040f829
L_0040f830:
    # block 0x0040f830: entered by jmp at 0x0040f81c, 5 instruction(s), ends with jge to 0x0040fa21 (forward)
    movsx ecx, word ptr [ebp - local_c0]         # 0040f830
    mov edx, dword ptr [ebp - local_12c]         # 0040f837
    movsx eax, word ptr [edx]                    # 0040f83d
    {load} cmp ecx, eax                          # 0040f840
    jge.d32 L_0040fa21                           # 0040f842
    # block 0x0040f848: entered by fall-through of jge at 0x0040f842, 4 instruction(s), ends with jne to 0x0040f984 (forward)
    movsx ecx, word ptr [ebp - local_c0]         # 0040f848
    movsx edx, word ptr [ebp - local_10]         # 0040f84f
    {load} cmp ecx, edx                          # 0040f853
    jne.d32 L_0040f984                           # 0040f855
    # block 0x0040f85b: entered by fall-through of jne at 0x0040f855, 6 instruction(s), ends with jne to 0x0040f960 (forward)
    mov eax, dword ptr [ebp - local_fc]          # 0040f85b
    mov dword ptr [ebp - local_54], eax          # 0040f861
    mov ecx, dword ptr [ebp - local_54]          # 0040f864
    movsx edx, word ptr [ecx]                    # 0040f867
    cmp edx, -0x1                                # 0040f86a
    jne.d32 L_0040f960                           # 0040f86d
    # block 0x0040f873: entered by fall-through of jne at 0x0040f86d, 13 instruction(s), calls FUN_00423259, ends with jne to 0x0040f900 (forward)
    mov esi, dword ptr [ebp - local_fc]          # 0040f873
    add esi, 0x2                                 # 0040f879
    mov ecx, 0x8                                 # 0040f87c
    lea edi, [ebp - local_f4]                    # 0040f881
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040f887
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040f889
    lea eax, [ebp - local_f4]                    # 0040f88a
    push eax                                     # 0040f890
    mov ecx, 0x619a6b                            # 0040f891
    call FUN_00423259                            # 0040f896
    mov dword ptr [ebp - local_24], eax          # 0040f89b
    cmp dword ptr [ebp - local_24], 0x0          # 0040f89e
    jne.d8 L_0040f900                            # 0040f8a2
    # block 0x0040f8a4: entered by fall-through of jne at 0x0040f8a2, 3 instruction(s), ends with je to 0x0040f8da (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0040f8a4
    test ecx, ecx                                # 0040f8ab
    je.d8 L_0040f8da                             # 0040f8ad
    # block 0x0040f8af: entered by fall-through of je at 0x0040f8ad, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0040f8da
    lea edx, [ebp - local_f4]                    # 0040f8af
    push edx                                     # 0040f8b5
    push 0x540b18                                # 0040f8b6
    lea eax, [ebp - local_b8]                    # 0040f8bb
    push eax                                     # 0040f8c1
    call FUN_0050ca3e                            # 0040f8c2
    add esp, 0xc                                 # 0040f8c7
    push 0x0                                     # 0040f8ca
    push 0x0                                     # 0040f8cc
    lea ecx, [ebp - local_b8]                    # 0040f8ce
    push ecx                                     # 0040f8d4
    call FUN_0052139c                            # 0040f8d5
L_0040f8da:
    # block 0x0040f8da: entered by je at 0x0040f8ad, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0040f941
    lea edx, [ebp - local_f4]                    # 0040f8da
    push edx                                     # 0040f8e0
    push 0x540b30                                # 0040f8e1
    lea eax, [ebp - local_b8]                    # 0040f8e6
    push eax                                     # 0040f8ec
    call FUN_0050ca3e                            # 0040f8ed
    add esp, 0xc                                 # 0040f8f2
    lea ecx, [ebp - local_b8]                    # 0040f8f5
    mov dword ptr [ebp - local_24], ecx          # 0040f8fb
    jmp.d8 L_0040f941                            # 0040f8fe
L_0040f900:
    # block 0x0040f900: entered by jne at 0x0040f8a2, 8 instruction(s), ends with jbe to 0x0040f941 (forward)
    mov edi, dword ptr [ebp - local_24]          # 0040f900
    or ecx, -0x1                                 # 0040f903
    {load} xor eax, eax                          # 0040f906
    repne scasb al, byte ptr es:[edi]            # 0040f908
    not ecx                                      # 0040f90a
    add ecx, -0x1                                # 0040f90c
    cmp ecx, 0x9c40                              # 0040f90f
    jbe.d8 L_0040f941                            # 0040f915
    # block 0x0040f917: entered by fall-through of jbe at 0x0040f915, 10 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0040f941
    push 0x540b74                                # 0040f917
    push 0x63888b                                # 0040f91c
    call FUN_0050ca3e                            # 0040f921
    add esp, 0x8                                 # 0040f926
    push 0x0                                     # 0040f929
    push 0x0                                     # 0040f92b
    push 0x63888b                                # 0040f92d
    call FUN_0052139c                            # 0040f932
    mov ecx, 0x5cf659                            # 0040f937
    call FUN_004c97b4                            # 0040f93c
L_0040f941:
    # block 0x0040f941: entered by jmp at 0x0040f8fe; jbe at 0x0040f915, 9 instruction(s), ends with forward jump to 0x0040f984
    mov edi, dword ptr [ebp - local_24]          # 0040f941
    or ecx, -0x1                                 # 0040f944
    {load} xor eax, eax                          # 0040f947
    repne scasb al, byte ptr es:[edi]            # 0040f949
    not ecx                                      # 0040f94b
    mov dx, word ptr [ebp - local_118]           # 0040f94d
    {load} add dx, cx                            # 0040f954
    mov word ptr [ebp - local_118], dx           # 0040f957
    jmp.d8 L_0040f984                            # 0040f95e
L_0040f960:
    # block 0x0040f960: entered by jne at 0x0040f86d, 4 instruction(s), ends with jl to 0x0040f984 (forward)
    mov eax, dword ptr [ebp - local_fc]          # 0040f960
    movsx ecx, word ptr [eax]                    # 0040f966
    test ecx, ecx                                # 0040f969
    jl.d8 L_0040f984                             # 0040f96b
    # block 0x0040f96d: entered by fall-through of jl at 0x0040f96b, 4 instruction(s), falls into the block at 0x0040f984
    mov edx, dword ptr [ebp - local_fc]          # 0040f96d
    mov ax, word ptr [ebp - local_118]           # 0040f973
    add ax, word ptr [edx]                       # 0040f97a
    mov word ptr [ebp - local_118], ax           # 0040f97d
L_0040f984:
    # block 0x0040f984: entered by jne at 0x0040f855; jmp at 0x0040f95e; jl at 0x0040f96b, 4 instruction(s), ends with jne to 0x0040f9c1 (forward)
    mov ecx, dword ptr [ebp - local_fc]          # 0040f984
    movsx edx, word ptr [ecx]                    # 0040f98a
    cmp edx, -0x1                                # 0040f98d
    jne.d8 L_0040f9c1                            # 0040f990
    # block 0x0040f992: entered by fall-through of jne at 0x0040f990, 9 instruction(s), ends with forward jump to 0x0040fa1c
    mov ax, word ptr [ebp - local_c8]            # 0040f992
    .insn 0x66, 0x05, 0x0023{:u16}               # 0040f999
    mov word ptr [ebp - local_c8], ax            # 0040f99d
    mov ecx, dword ptr [ebp - local_110]         # 0040f9a4
    add ecx, 0x23                                # 0040f9aa
    mov dword ptr [ebp - local_110], ecx         # 0040f9ad
    mov edx, dword ptr [ebp - local_110]         # 0040f9b3
    mov dword ptr [ebp - local_fc], edx          # 0040f9b9
    jmp.d8 L_0040fa1c                            # 0040f9bf
L_0040f9c1:
    # block 0x0040f9c1: entered by jne at 0x0040f990, 4 instruction(s), ends with jl to 0x0040fa12 (forward)
    mov eax, dword ptr [ebp - local_fc]          # 0040f9c1
    movsx ecx, word ptr [eax]                    # 0040f9c7
    test ecx, ecx                                # 0040f9ca
    jl.d8 L_0040fa12                             # 0040f9cc
    # block 0x0040f9ce: entered by fall-through of jl at 0x0040f9cc, 14 instruction(s), ends with forward jump to 0x0040fa1c
    mov edx, dword ptr [ebp - local_fc]          # 0040f9ce
    movsx eax, word ptr [edx]                    # 0040f9d4
    add eax, 0x2                                 # 0040f9d7
    mov cx, word ptr [ebp - local_c8]            # 0040f9da
    {load} add cx, ax                            # 0040f9e1
    mov word ptr [ebp - local_c8], cx            # 0040f9e4
    mov edx, dword ptr [ebp - local_fc]          # 0040f9eb
    movsx eax, word ptr [edx]                    # 0040f9f1
    mov ecx, dword ptr [ebp - local_110]         # 0040f9f4
    lea edx, [ecx + eax + field_2]               # 0040f9fa
    mov dword ptr [ebp - local_110], edx         # 0040f9fe
    mov eax, dword ptr [ebp - local_110]         # 0040fa04
    mov dword ptr [ebp - local_fc], eax          # 0040fa0a
    jmp.d8 L_0040fa1c                            # 0040fa10
L_0040fa12:
    # block 0x0040fa12: entered by jl at 0x0040f9cc, 1 instruction(s), falls into the block at 0x0040fa1c
    mov dword ptr [ebp - local_10c], 0x1         # 0040fa12
L_0040fa1c:
    # block 0x0040fa1c: entered by jmp at 0x0040f9bf; jmp at 0x0040fa10, 1 instruction(s), ends with backward jump to 0x0040f81e
    jmp.d32 L_0040f81e                           # 0040fa1c
L_0040fa21:
    # block 0x0040fa21: entered by jge at 0x0040f842, 4 instruction(s), ends with jg to 0x0040fa36 (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0040fa21
    movsx edx, word ptr [ecx]                    # 0040fa24
    test edx, edx                                # 0040fa27
    jg.d8 L_0040fa36                             # 0040fa29
    # block 0x0040fa2b: entered by fall-through of jg at 0x0040fa29, 4 instruction(s), ends with jne to 0x0040fa58 (forward)
    mov eax, dword ptr [ebp - local_54]          # 0040fa2b
    movsx ecx, word ptr [eax]                    # 0040fa2e
    cmp ecx, -0x1                                # 0040fa31
    jne.d8 L_0040fa58                            # 0040fa34
L_0040fa36:
    # block 0x0040fa36: entered by jg at 0x0040fa29; fall-through of jne at 0x0040fa34, 9 instruction(s), falls into the block at 0x0040fa58
    mov edi, 0x540bc0                            # 0040fa36
    or ecx, -0x1                                 # 0040fa3b
    {load} xor eax, eax                          # 0040fa3e
    repne scasb al, byte ptr es:[edi]            # 0040fa40
    not ecx                                      # 0040fa42
    add ecx, -0x1                                # 0040fa44
    mov dx, word ptr [ebp - local_118]           # 0040fa47
    {load} add dx, cx                            # 0040fa4e
    mov word ptr [ebp - local_118], dx           # 0040fa51
L_0040fa58:
    # block 0x0040fa58: entered by jne at 0x0040fa34, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040fad4 (forward)
    movsx eax, word ptr [ebp - local_118]        # 0040fa58
    push eax                                     # 0040fa5f
    call FUN_0051dc43                            # 0040fa60
    add esp, 0x4                                 # 0040fa65
    mov dword ptr [ebp - local_21c], eax         # 0040fa68
    movsx ecx, word ptr [0x5c39e3]               # 0040fa6e
    imul ecx, ecx, 0x8d                          # 0040fa75
    mov edx, dword ptr [ebp - local_21c]         # 0040fa7b
    mov dword ptr [ecx + 0x5bb5e5], edx          # 0040fa81
    cmp dword ptr [ebp - local_21c], 0x0         # 0040fa87
    jne.d8 L_0040fad4                            # 0040fa8e
    # block 0x0040fa90: entered by fall-through of jne at 0x0040fa8e, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 0040fa90
    push eax                                     # 0040fa97
    mov ecx, dword ptr [0x5bb57b]                # 0040fa98
    push ecx                                     # 0040fa9e
    push 0x540bc4                                # 0040fa9f
    push 0x63888b                                # 0040faa4
    call FUN_0050ca3e                            # 0040faa9
    add esp, 0x10                                # 0040faae
    push 0x63888b                                # 0040fab1
    push 0x540bf0                                # 0040fab6
    mov ecx, 0x583979                            # 0040fabb
    call FUN_0042639d                            # 0040fac0
    mov ecx, 0x5cf659                            # 0040fac5
    call FUN_004c97b4                            # 0040faca
    jmp.d32 L_00410c9e                           # 0040facf
L_0040fad4:
    # block 0x0040fad4: entered by jne at 0x0040fa8e, 33 instruction(s), calls FUN_00410f99, ends with jne to 0x0040fba0 (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040fad4
    {load} xor eax, eax                          # 0040fadb
    movsx edx, word ptr [0x5c39e3]               # 0040fadd
    imul edx, edx, 0x8d                          # 0040fae4
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040faea
    {load} mov edx, ecx                          # 0040faf0
    shr ecx, 0x2                                 # 0040faf2
    rep stosd dword ptr es:[edi], eax            # 0040faf5
    {load} mov ecx, edx                          # 0040faf7
    and ecx, 0x3                                 # 0040faf9
    rep stosb byte ptr es:[edi], al              # 0040fafc
    push 0x1                                     # 0040fafe
    push -0x1                                    # 0040fb00
    mov eax, dword ptr [ebp - local_20]          # 0040fb02
    push eax                                     # 0040fb05
    movsx ecx, word ptr [0x5c39e3]               # 0040fb06
    imul ecx, ecx, 0x8d                          # 0040fb0d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040fb13
    push edx                                     # 0040fb19
    call FUN_00410f99                            # 0040fb1a
    add esp, 0x10                                # 0040fb1f
    movsx eax, word ptr [ebp - local_10]         # 0040fb22
    imul eax, eax, 0x21                          # 0040fb26
    mov ecx, dword ptr [ebp - local_12c]         # 0040fb29
    lea esi, [ecx + eax + field_2]               # 0040fb2f
    movsx edx, word ptr [0x5c39e3]               # 0040fb33
    imul edx, edx, 0x8d                          # 0040fb3a
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040fb40
    mov ecx, 0x8                                 # 0040fb46
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fb4b
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040fb4d
    cmp dword ptr [ebp - local_24], 0x0          # 0040fb4e
    jne.d8 L_0040fba0                            # 0040fb52
    # block 0x0040fb54: entered by fall-through of jne at 0x0040fb52, 2 instruction(s), ends with jne to 0x0040fba0 (forward)
    cmp dword ptr [ebp - local_10c], 0x0         # 0040fb54
    jne.d8 L_0040fba0                            # 0040fb5b
    # block 0x0040fb5d: entered by fall-through of jne at 0x0040fb5b, 17 instruction(s), ends with forward jump to 0x0040fc05
    mov eax, dword ptr [ebp - local_54]          # 0040fb5d
    movsx ecx, word ptr [eax]                    # 0040fb60
    add ecx, 0x2                                 # 0040fb63
    mov word ptr [ebp - local_118], cx           # 0040fb66
    movsx ecx, word ptr [ebp - local_118]        # 0040fb6d
    mov esi, dword ptr [ebp - local_54]          # 0040fb74
    movsx edx, word ptr [0x5c39e3]               # 0040fb77
    imul edx, edx, 0x8d                          # 0040fb7e
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040fb84
    add edi, 0xaa                                # 0040fb8a
    {load} mov eax, ecx                          # 0040fb90
    shr ecx, 0x2                                 # 0040fb92
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fb95
    {load} mov ecx, eax                          # 0040fb97
    and ecx, 0x3                                 # 0040fb99
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040fb9c
    jmp.d8 L_0040fc05                            # 0040fb9e
L_0040fba0:
    # block 0x0040fba0: entered by jne at 0x0040fb52; jne at 0x0040fb5b, 2 instruction(s), ends with je to 0x0040fc05 (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0040fba0
    je.d8 L_0040fc05                             # 0040fba4
    # block 0x0040fba6: entered by fall-through of je at 0x0040fba4, 26 instruction(s), falls into the block at 0x0040fc05
    mov edi, dword ptr [ebp - local_24]          # 0040fba6
    or ecx, -0x1                                 # 0040fba9
    {load} xor eax, eax                          # 0040fbac
    repne scasb al, byte ptr es:[edi]            # 0040fbae
    not ecx                                      # 0040fbb0
    add ecx, -0x1                                # 0040fbb2
    movsx edx, word ptr [0x5c39e3]               # 0040fbb5
    imul edx, edx, 0x8d                          # 0040fbbc
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040fbc2
    mov word ptr [eax + field_aa], cx            # 0040fbc8
    mov edi, dword ptr [ebp - local_24]          # 0040fbcf
    or ecx, -0x1                                 # 0040fbd2
    {load} xor eax, eax                          # 0040fbd5
    repne scasb al, byte ptr es:[edi]            # 0040fbd7
    not ecx                                      # 0040fbd9
    mov esi, dword ptr [ebp - local_24]          # 0040fbdb
    movsx edx, word ptr [0x5c39e3]               # 0040fbde
    imul edx, edx, 0x8d                          # 0040fbe5
    mov edi, dword ptr [edx + 0x5bb5e5]          # 0040fbeb
    add edi, 0xac                                # 0040fbf1
    {load} mov eax, ecx                          # 0040fbf7
    shr ecx, 0x2                                 # 0040fbf9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fbfc
    {load} mov ecx, eax                          # 0040fbfe
    and ecx, 0x3                                 # 0040fc00
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040fc03
L_0040fc05:
    # block 0x0040fc05: entered by jmp at 0x0040fb9e; je at 0x0040fba4, 4 instruction(s), ends with jg to 0x0040fc1e (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0040fc05
    movsx edx, word ptr [ecx]                    # 0040fc08
    test edx, edx                                # 0040fc0b
    jg.d8 L_0040fc1e                             # 0040fc0d
    # block 0x0040fc0f: entered by fall-through of jg at 0x0040fc0d, 4 instruction(s), ends with jne to 0x0040fcbe (forward)
    mov eax, dword ptr [ebp - local_54]          # 0040fc0f
    movsx ecx, word ptr [eax]                    # 0040fc12
    cmp ecx, -0x1                                # 0040fc15
    jne.d32 L_0040fcbe                           # 0040fc18
L_0040fc1e:
    # block 0x0040fc1e: entered by jg at 0x0040fc0d; fall-through of jne at 0x0040fc18, 36 instruction(s), falls into the block at 0x0040fcbe
    mov edi, 0x540c0c                            # 0040fc1e
    or ecx, -0x1                                 # 0040fc23
    {load} xor eax, eax                          # 0040fc26
    repne scasb al, byte ptr es:[edi]            # 0040fc28
    not ecx                                      # 0040fc2a
    add ecx, -0x1                                # 0040fc2c
    mov esi, 0x540c10                            # 0040fc2f
    movsx edx, word ptr [0x5c39e3]               # 0040fc34
    imul edx, edx, 0x8d                          # 0040fc3b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0040fc41
    movsx edx, word ptr [0x5c39e3]               # 0040fc47
    imul edx, edx, 0x8d                          # 0040fc4e
    mov edx, dword ptr [edx + 0x5bb5e5]          # 0040fc54
    movsx edx, word ptr [edx + field_aa]         # 0040fc5a
    lea edi, [eax + edx + field_ac]              # 0040fc61
    {load} mov eax, ecx                          # 0040fc68
    shr ecx, 0x2                                 # 0040fc6a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fc6d
    {load} mov ecx, eax                          # 0040fc6f
    and ecx, 0x3                                 # 0040fc71
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040fc74
    movsx ecx, word ptr [0x5c39e3]               # 0040fc76
    imul ecx, ecx, 0x8d                          # 0040fc7d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040fc83
    mov edi, 0x540c14                            # 0040fc89
    or ecx, -0x1                                 # 0040fc8e
    {load} xor eax, eax                          # 0040fc91
    repne scasb al, byte ptr es:[edi]            # 0040fc93
    not ecx                                      # 0040fc95
    add ecx, -0x1                                # 0040fc97
    mov ax, word ptr [edx + field_aa]            # 0040fc9a
    {load} add ax, cx                            # 0040fca1
    movsx ecx, word ptr [0x5c39e3]               # 0040fca4
    imul ecx, ecx, 0x8d                          # 0040fcab
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0040fcb1
    mov word ptr [edx + field_aa], ax            # 0040fcb7
L_0040fcbe:
    # block 0x0040fcbe: entered by jne at 0x0040fc18, 14 instruction(s), ends with je to 0x0040fd12 (forward)
    movsx eax, word ptr [ebp - local_c8]         # 0040fcbe
    mov ecx, dword ptr [ebp - local_cc]          # 0040fcc5
    lea edx, [ecx + eax + field_2e]              # 0040fccb
    mov dword ptr [ebp - local_cc], edx          # 0040fccf
    movsx eax, word ptr [ebp - local_c8]         # 0040fcd5
    mov ecx, dword ptr [ebp - local_20]          # 0040fcdc
    lea edx, [ecx + eax + field_2e]              # 0040fcdf
    mov dword ptr [ebp - local_20], edx          # 0040fce3
    movsx eax, word ptr [0x5c39e3]               # 0040fce6
    imul eax, eax, 0x8d                          # 0040fced
    mov byte ptr [eax + 0x5bb5e3], -0x61         # 0040fcf3
    movsx ecx, word ptr [0x63a4cd]               # 0040fcfa
    test ecx, ecx                                # 0040fd01
    je.d8 L_0040fd12                             # 0040fd03
    # block 0x0040fd05: entered by fall-through of je at 0x0040fd03, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040fd12
    push 0x540c18                                # 0040fd05
    call FUN_0044a2b7                            # 0040fd0a
    add esp, 0x4                                 # 0040fd0f
L_0040fd12:
    # block 0x0040fd12: entered by jmp at 0x0040f7d1; je at 0x0040fd03, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040fd12
L_0040fd17:
    # block 0x0040fd17: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040fd8d (forward)
    push 0x3d                                    # 0040fd17
    call FUN_0051dc43                            # 0040fd19
    add esp, 0x4                                 # 0040fd1e
    mov dword ptr [ebp - local_220], eax         # 0040fd21
    movsx edx, word ptr [0x5c39e3]               # 0040fd27
    imul edx, edx, 0x8d                          # 0040fd2e
    mov eax, dword ptr [ebp - local_220]         # 0040fd34
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040fd3a
    cmp dword ptr [ebp - local_220], 0x0         # 0040fd40
    jne.d8 L_0040fd8d                            # 0040fd47
    # block 0x0040fd49: entered by fall-through of jne at 0x0040fd47, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040fd49
    push ecx                                     # 0040fd50
    mov edx, dword ptr [0x5bb57b]                # 0040fd51
    push edx                                     # 0040fd57
    push 0x540c54                                # 0040fd58
    push 0x63888b                                # 0040fd5d
    call FUN_0050ca3e                            # 0040fd62
    add esp, 0x10                                # 0040fd67
    push 0x63888b                                # 0040fd6a
    push 0x540c80                                # 0040fd6f
    mov ecx, 0x583979                            # 0040fd74
    call FUN_0042639d                            # 0040fd79
    mov ecx, 0x5cf659                            # 0040fd7e
    call FUN_004c97b4                            # 0040fd83
    jmp.d32 L_00410c9e                           # 0040fd88
L_0040fd8d:
    # block 0x0040fd8d: entered by jne at 0x0040fd47, 16 instruction(s), ends with je to 0x0040fddb (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040fd8d
    imul eax, eax, 0x8d                          # 0040fd94
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040fd9a
    mov ecx, 0xf                                 # 0040fda0
    mov esi, dword ptr [ebp - local_20]          # 0040fda5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fda8
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040fdaa
    mov ecx, dword ptr [ebp - local_cc]          # 0040fdab
    add ecx, 0x3d                                # 0040fdb1
    mov dword ptr [ebp - local_cc], ecx          # 0040fdb4
    mov edx, dword ptr [ebp - local_20]          # 0040fdba
    add edx, 0x3d                                # 0040fdbd
    mov dword ptr [ebp - local_20], edx          # 0040fdc0
    movsx eax, word ptr [0x63a4cd]               # 0040fdc3
    test eax, eax                                # 0040fdca
    je.d8 L_0040fddb                             # 0040fdcc
    # block 0x0040fdce: entered by fall-through of je at 0x0040fdcc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040fddb
    push 0x540c9c                                # 0040fdce
    call FUN_0044a2b7                            # 0040fdd3
    add esp, 0x4                                 # 0040fdd8
L_0040fddb:
    # block 0x0040fddb: entered by je at 0x0040fdcc, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040fddb
L_0040fde0:
    # block 0x0040fde0: entered by switch case, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040fe76 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0040fde0
    mov dword ptr [ebp - local_50], ecx          # 0040fde3
    mov edx, dword ptr [ebp - local_50]          # 0040fde6
    movsx eax, word ptr [edx + field_4a]         # 0040fde9
    imul eax, eax, 0x12                          # 0040fded
    add eax, 0x4c                                # 0040fdf0
    mov word ptr [ebp - local_118], ax           # 0040fdf3
    movsx ecx, word ptr [ebp - local_118]        # 0040fdfa
    push ecx                                     # 0040fe01
    call FUN_0051dc43                            # 0040fe02
    add esp, 0x4                                 # 0040fe07
    mov dword ptr [ebp - local_224], eax         # 0040fe0a
    movsx edx, word ptr [0x5c39e3]               # 0040fe10
    imul edx, edx, 0x8d                          # 0040fe17
    mov eax, dword ptr [ebp - local_224]         # 0040fe1d
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040fe23
    cmp dword ptr [ebp - local_224], 0x0         # 0040fe29
    jne.d8 L_0040fe76                            # 0040fe30
    # block 0x0040fe32: entered by fall-through of jne at 0x0040fe30, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040fe32
    push ecx                                     # 0040fe39
    mov edx, dword ptr [0x5bb57b]                # 0040fe3a
    push edx                                     # 0040fe40
    push 0x540cd8                                # 0040fe41
    push 0x63888b                                # 0040fe46
    call FUN_0050ca3e                            # 0040fe4b
    add esp, 0x10                                # 0040fe50
    push 0x63888b                                # 0040fe53
    push 0x540d04                                # 0040fe58
    mov ecx, 0x583979                            # 0040fe5d
    call FUN_0042639d                            # 0040fe62
    mov ecx, 0x5cf659                            # 0040fe67
    call FUN_004c97b4                            # 0040fe6c
    jmp.d32 L_00410c9e                           # 0040fe71
L_0040fe76:
    # block 0x0040fe76: entered by jne at 0x0040fe30, 22 instruction(s), ends with je to 0x0040fedd (forward)
    movsx ecx, word ptr [ebp - local_118]        # 0040fe76
    mov esi, dword ptr [ebp - local_20]          # 0040fe7d
    movsx eax, word ptr [0x5c39e3]               # 0040fe80
    imul eax, eax, 0x8d                          # 0040fe87
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040fe8d
    {load} mov edx, ecx                          # 0040fe93
    shr ecx, 0x2                                 # 0040fe95
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040fe98
    {load} mov ecx, edx                          # 0040fe9a
    and ecx, 0x3                                 # 0040fe9c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040fe9f
    movsx eax, word ptr [ebp - local_118]        # 0040fea1
    mov ecx, dword ptr [ebp - local_cc]          # 0040fea8
    {load} add ecx, eax                          # 0040feae
    mov dword ptr [ebp - local_cc], ecx          # 0040feb0
    movsx edx, word ptr [ebp - local_118]        # 0040feb6
    mov eax, dword ptr [ebp - local_20]          # 0040febd
    {load} add eax, edx                          # 0040fec0
    mov dword ptr [ebp - local_20], eax          # 0040fec2
    movsx ecx, word ptr [0x63a4cd]               # 0040fec5
    test ecx, ecx                                # 0040fecc
    je.d8 L_0040fedd                             # 0040fece
    # block 0x0040fed0: entered by fall-through of je at 0x0040fece, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040fedd
    push 0x540d20                                # 0040fed0
    call FUN_0044a2b7                            # 0040fed5
    add esp, 0x4                                 # 0040feda
L_0040fedd:
    # block 0x0040fedd: entered by je at 0x0040fece, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040fedd
L_0040fee2:
    # block 0x0040fee2: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0040ff58 (forward)
    push 0x1b                                    # 0040fee2
    call FUN_0051dc43                            # 0040fee4
    add esp, 0x4                                 # 0040fee9
    mov dword ptr [ebp - local_228], eax         # 0040feec
    movsx edx, word ptr [0x5c39e3]               # 0040fef2
    imul edx, edx, 0x8d                          # 0040fef9
    mov eax, dword ptr [ebp - local_228]         # 0040feff
    mov dword ptr [edx + 0x5bb5e5], eax          # 0040ff05
    cmp dword ptr [ebp - local_228], 0x0         # 0040ff0b
    jne.d8 L_0040ff58                            # 0040ff12
    # block 0x0040ff14: entered by fall-through of jne at 0x0040ff12, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 0040ff14
    push ecx                                     # 0040ff1b
    mov edx, dword ptr [0x5bb57b]                # 0040ff1c
    push edx                                     # 0040ff22
    push 0x540d58                                # 0040ff23
    push 0x63888b                                # 0040ff28
    call FUN_0050ca3e                            # 0040ff2d
    add esp, 0x10                                # 0040ff32
    push 0x63888b                                # 0040ff35
    push 0x540d84                                # 0040ff3a
    mov ecx, 0x583979                            # 0040ff3f
    call FUN_0042639d                            # 0040ff44
    mov ecx, 0x5cf659                            # 0040ff49
    call FUN_004c97b4                            # 0040ff4e
    jmp.d32 L_00410c9e                           # 0040ff53
L_0040ff58:
    # block 0x0040ff58: entered by jne at 0x0040ff12, 17 instruction(s), ends with je to 0x0040ffd4 (forward)
    movsx eax, word ptr [0x5c39e3]               # 0040ff58
    imul eax, eax, 0x8d                          # 0040ff5f
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0040ff65
    mov ecx, 0x6                                 # 0040ff6b
    mov esi, dword ptr [ebp - local_20]          # 0040ff70
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040ff73
    movsw word ptr es:[edi], word ptr [esi]      # 0040ff75
    movsb byte ptr es:[edi], byte ptr [esi]      # 0040ff77
    mov ecx, dword ptr [ebp - local_cc]          # 0040ff78
    add ecx, 0x1b                                # 0040ff7e
    mov dword ptr [ebp - local_cc], ecx          # 0040ff81
    mov edx, dword ptr [ebp - local_20]          # 0040ff87
    add edx, 0x1b                                # 0040ff8a
    mov dword ptr [ebp - local_20], edx          # 0040ff8d
    movsx eax, word ptr [0x63a4cd]               # 0040ff90
    test eax, eax                                # 0040ff97
    je.d8 L_0040ffd4                             # 0040ff99
    # block 0x0040ff9b: entered by fall-through of je at 0x0040ff99, 6 instruction(s), ends with jne to 0x0040ffc7 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0040ff9b
    imul ecx, ecx, 0x8d                          # 0040ffa2
    {load} xor edx, edx                          # 0040ffa8
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0040ffaa
    cmp edx, 0x9a                                # 0040ffb0
    jne.d8 L_0040ffc7                            # 0040ffb6
    # block 0x0040ffb8: entered by fall-through of jne at 0x0040ffb6, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x0040ffd4
    push 0x540da0                                # 0040ffb8
    call FUN_0044a2b7                            # 0040ffbd
    add esp, 0x4                                 # 0040ffc2
    jmp.d8 L_0040ffd4                            # 0040ffc5
L_0040ffc7:
    # block 0x0040ffc7: entered by jne at 0x0040ffb6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0040ffd4
    push 0x540dd0                                # 0040ffc7
    call FUN_0044a2b7                            # 0040ffcc
    add esp, 0x4                                 # 0040ffd1
L_0040ffd4:
    # block 0x0040ffd4: entered by je at 0x0040ff99; jmp at 0x0040ffc5, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0040ffd4
L_0040ffd9:
    # block 0x0040ffd9: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041004e (forward)
    push 0x8                                     # 0040ffd9
    call FUN_0051dc43                            # 0040ffdb
    add esp, 0x4                                 # 0040ffe0
    mov dword ptr [ebp - local_22c], eax         # 0040ffe3
    movsx eax, word ptr [0x5c39e3]               # 0040ffe9
    imul eax, eax, 0x8d                          # 0040fff0
    mov ecx, dword ptr [ebp - local_22c]         # 0040fff6
    mov dword ptr [eax + 0x5bb5e5], ecx          # 0040fffc
    cmp dword ptr [ebp - local_22c], 0x0         # 00410002
    jne.d8 L_0041004e                            # 00410009
    # block 0x0041000b: entered by fall-through of jne at 0x00410009, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx edx, word ptr [0x5c39e3]               # 0041000b
    push edx                                     # 00410012
    mov eax, dword ptr [0x5bb57b]                # 00410013
    push eax                                     # 00410018
    push 0x540e08                                # 00410019
    push 0x63888b                                # 0041001e
    call FUN_0050ca3e                            # 00410023
    add esp, 0x10                                # 00410028
    push 0x63888b                                # 0041002b
    push 0x540e34                                # 00410030
    mov ecx, 0x583979                            # 00410035
    call FUN_0042639d                            # 0041003a
    mov ecx, 0x5cf659                            # 0041003f
    call FUN_004c97b4                            # 00410044
    jmp.d32 L_00410c9e                           # 00410049
L_0041004e:
    # block 0x0041004e: entered by jne at 0x00410009, 17 instruction(s), ends with je to 0x0041009e (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0041004e
    imul ecx, ecx, 0x8d                          # 00410055
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0041005b
    mov eax, dword ptr [ebp - local_20]          # 00410061
    mov ecx, dword ptr [eax]                     # 00410064
    mov dword ptr [edx], ecx                     # 00410066
    mov eax, dword ptr [eax + field_4]           # 00410068
    mov dword ptr [edx + field_4], eax           # 0041006b
    mov ecx, dword ptr [ebp - local_cc]          # 0041006e
    add ecx, 0x8                                 # 00410074
    mov dword ptr [ebp - local_cc], ecx          # 00410077
    mov edx, dword ptr [ebp - local_20]          # 0041007d
    add edx, 0x8                                 # 00410080
    mov dword ptr [ebp - local_20], edx          # 00410083
    movsx eax, word ptr [0x63a4cd]               # 00410086
    test eax, eax                                # 0041008d
    je.d8 L_0041009e                             # 0041008f
    # block 0x00410091: entered by fall-through of je at 0x0041008f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041009e
    push 0x540e50                                # 00410091
    call FUN_0044a2b7                            # 00410096
    add esp, 0x4                                 # 0041009b
L_0041009e:
    # block 0x0041009e: entered by je at 0x0041008f, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0041009e
L_004100a3:
    # block 0x004100a3: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x00410119 (forward)
    push 0x3                                     # 004100a3
    call FUN_0051dc43                            # 004100a5
    add esp, 0x4                                 # 004100aa
    mov dword ptr [ebp - local_230], eax         # 004100ad
    movsx ecx, word ptr [0x5c39e3]               # 004100b3
    imul ecx, ecx, 0x8d                          # 004100ba
    mov edx, dword ptr [ebp - local_230]         # 004100c0
    mov dword ptr [ecx + 0x5bb5e5], edx          # 004100c6
    cmp dword ptr [ebp - local_230], 0x0         # 004100cc
    jne.d8 L_00410119                            # 004100d3
    # block 0x004100d5: entered by fall-through of jne at 0x004100d3, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx eax, word ptr [0x5c39e3]               # 004100d5
    push eax                                     # 004100dc
    mov ecx, dword ptr [0x5bb57b]                # 004100dd
    push ecx                                     # 004100e3
    push 0x540e88                                # 004100e4
    push 0x63888b                                # 004100e9
    call FUN_0050ca3e                            # 004100ee
    add esp, 0x10                                # 004100f3
    push 0x63888b                                # 004100f6
    push 0x540eb4                                # 004100fb
    mov ecx, 0x583979                            # 00410100
    call FUN_0042639d                            # 00410105
    mov ecx, 0x5cf659                            # 0041010a
    call FUN_004c97b4                            # 0041010f
    jmp.d32 L_00410c9e                           # 00410114
L_00410119:
    # block 0x00410119: entered by jne at 0x004100d3, 17 instruction(s), ends with je to 0x0041016b (forward)
    movsx edx, word ptr [0x5c39e3]               # 00410119
    imul edx, edx, 0x8d                          # 00410120
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00410126
    mov ecx, dword ptr [ebp - local_20]          # 0041012c
    mov dx, word ptr [ecx]                       # 0041012f
    mov word ptr [eax], dx                       # 00410132
    mov cl, byte ptr [ecx + field_2]             # 00410135
    mov byte ptr [eax + field_2], cl             # 00410138
    mov edx, dword ptr [ebp - local_cc]          # 0041013b
    add edx, 0x3                                 # 00410141
    mov dword ptr [ebp - local_cc], edx          # 00410144
    mov eax, dword ptr [ebp - local_20]          # 0041014a
    add eax, 0x3                                 # 0041014d
    mov dword ptr [ebp - local_20], eax          # 00410150
    movsx ecx, word ptr [0x63a4cd]               # 00410153
    test ecx, ecx                                # 0041015a
    je.d8 L_0041016b                             # 0041015c
    # block 0x0041015e: entered by fall-through of je at 0x0041015c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041016b
    push 0x540ed0                                # 0041015e
    call FUN_0044a2b7                            # 00410163
    add esp, 0x4                                 # 00410168
L_0041016b:
    # block 0x0041016b: entered by je at 0x0041015c, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 0041016b
L_00410170:
    # block 0x00410170: entered by switch case, 11 instruction(s), calls FUN_004fcda1, ends with forward jump to 0x00410a68
    lea edx, [ebp - local_cc]                    # 00410170
    push edx                                     # 00410176
    lea eax, [ebp - local_20]                    # 00410177
    push eax                                     # 0041017a
    movsx ecx, word ptr [0x5c39e3]               # 0041017b
    imul ecx, ecx, 0x8d                          # 00410182
    add ecx, 0x5bb5e5                            # 00410188
    push ecx                                     # 0041018e
    mov ecx, 0x5c3a67                            # 0041018f
    call FUN_004fcda1                            # 00410194
    jmp.d32 L_00410a68                           # 00410199
L_0041019e:
    # block 0x0041019e: entered by switch case, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x00410214 (forward)
    push 0x32                                    # 0041019e
    call FUN_0051dc43                            # 004101a0
    add esp, 0x4                                 # 004101a5
    mov dword ptr [ebp - local_234], eax         # 004101a8
    movsx edx, word ptr [0x5c39e3]               # 004101ae
    imul edx, edx, 0x8d                          # 004101b5
    mov eax, dword ptr [ebp - local_234]         # 004101bb
    mov dword ptr [edx + 0x5bb5e5], eax          # 004101c1
    cmp dword ptr [ebp - local_234], 0x0         # 004101c7
    jne.d8 L_00410214                            # 004101ce
    # block 0x004101d0: entered by fall-through of jne at 0x004101ce, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x00410c9e
    movsx ecx, word ptr [0x5c39e3]               # 004101d0
    push ecx                                     # 004101d7
    mov edx, dword ptr [0x5bb57b]                # 004101d8
    push edx                                     # 004101de
    push 0x540f00                                # 004101df
    push 0x63888b                                # 004101e4
    call FUN_0050ca3e                            # 004101e9
    add esp, 0x10                                # 004101ee
    push 0x63888b                                # 004101f1
    push 0x540f2c                                # 004101f6
    mov ecx, 0x583979                            # 004101fb
    call FUN_0042639d                            # 00410200
    mov ecx, 0x5cf659                            # 00410205
    call FUN_004c97b4                            # 0041020a
    jmp.d32 L_00410c9e                           # 0041020f
L_00410214:
    # block 0x00410214: entered by jne at 0x004101ce, 16 instruction(s), ends with je to 0x00410263 (forward)
    movsx eax, word ptr [0x5c39e3]               # 00410214
    imul eax, eax, 0x8d                          # 0041021b
    mov edi, dword ptr [eax + 0x5bb5e5]          # 00410221
    mov ecx, 0xc                                 # 00410227
    mov esi, dword ptr [ebp - local_20]          # 0041022c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041022f
    movsw word ptr es:[edi], word ptr [esi]      # 00410231
    mov ecx, dword ptr [ebp - local_cc]          # 00410233
    add ecx, 0x32                                # 00410239
    mov dword ptr [ebp - local_cc], ecx          # 0041023c
    mov edx, dword ptr [ebp - local_20]          # 00410242
    add edx, 0x32                                # 00410245
    mov dword ptr [ebp - local_20], edx          # 00410248
    movsx eax, word ptr [0x63a4cd]               # 0041024b
    test eax, eax                                # 00410252
    je.d8 L_00410263                             # 00410254
    # block 0x00410256: entered by fall-through of je at 0x00410254, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00410263
    push 0x540f48                                # 00410256
    call FUN_0044a2b7                            # 0041025b
    add esp, 0x4                                 # 00410260
L_00410263:
    # block 0x00410263: entered by je at 0x00410254, 1 instruction(s), ends with forward jump to 0x00410a68
    jmp.d32 L_00410a68                           # 00410263
L_00410268:
    # block 0x00410268: entered by switch case, 11 instruction(s), calls FUN_00468f9f, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410268
    push ecx                                     # 0041026e
    lea edx, [ebp - local_20]                    # 0041026f
    push edx                                     # 00410272
    movsx eax, word ptr [0x5c39e3]               # 00410273
    imul eax, eax, 0x8d                          # 0041027a
    add eax, 0x5bb5e5                            # 00410280
    push eax                                     # 00410285
    mov ecx, 0x616ab2                            # 00410286
    call FUN_00468f9f                            # 0041028b
    jmp.d32 L_00410a68                           # 00410290
L_00410295:
    # block 0x00410295: entered by switch case, 11 instruction(s), calls FUN_004b3ddf, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410295
    push ecx                                     # 0041029b
    lea edx, [ebp - local_20]                    # 0041029c
    push edx                                     # 0041029f
    movsx eax, word ptr [0x5c39e3]               # 004102a0
    imul eax, eax, 0x8d                          # 004102a7
    add eax, 0x5bb5e5                            # 004102ad
    push eax                                     # 004102b2
    mov ecx, 0x617066                            # 004102b3
    call FUN_004b3ddf                            # 004102b8
    jmp.d32 L_00410a68                           # 004102bd
L_004102c2:
    # block 0x004102c2: entered by switch case, 11 instruction(s), calls FUN_00459c10, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004102c2
    push ecx                                     # 004102c8
    lea edx, [ebp - local_20]                    # 004102c9
    push edx                                     # 004102cc
    movsx eax, word ptr [0x5c39e3]               # 004102cd
    imul eax, eax, 0x8d                          # 004102d4
    add eax, 0x5bb5e5                            # 004102da
    push eax                                     # 004102df
    mov ecx, 0x61c7ed                            # 004102e0
    call FUN_00459c10                            # 004102e5
    jmp.d32 L_00410a68                           # 004102ea
L_004102ef:
    # block 0x004102ef: entered by switch case, 11 instruction(s), calls FUN_004a3a33, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004102ef
    push ecx                                     # 004102f5
    lea edx, [ebp - local_20]                    # 004102f6
    push edx                                     # 004102f9
    movsx eax, word ptr [0x5c39e3]               # 004102fa
    imul eax, eax, 0x8d                          # 00410301
    add eax, 0x5bb5e5                            # 00410307
    push eax                                     # 0041030c
    mov ecx, 0x61c8cf                            # 0041030d
    call FUN_004a3a33                            # 00410312
    jmp.d32 L_00410a68                           # 00410317
L_0041031c:
    # block 0x0041031c: entered by switch case, 11 instruction(s), calls FUN_0048a865, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041031c
    push ecx                                     # 00410322
    lea edx, [ebp - local_20]                    # 00410323
    push edx                                     # 00410326
    movsx eax, word ptr [0x5c39e3]               # 00410327
    imul eax, eax, 0x8d                          # 0041032e
    add eax, 0x5bb5e5                            # 00410334
    push eax                                     # 00410339
    mov ecx, 0x61d10f                            # 0041033a
    call FUN_0048a865                            # 0041033f
    jmp.d32 L_00410a68                           # 00410344
L_00410349:
    # block 0x00410349: entered by switch case, 11 instruction(s), calls FUN_004a1d3a, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410349
    push ecx                                     # 0041034f
    lea edx, [ebp - local_20]                    # 00410350
    push edx                                     # 00410353
    movsx eax, word ptr [0x5c39e3]               # 00410354
    imul eax, eax, 0x8d                          # 0041035b
    add eax, 0x5bb5e5                            # 00410361
    push eax                                     # 00410366
    mov ecx, 0x61d2dd                            # 00410367
    call FUN_004a1d3a                            # 0041036c
    jmp.d32 L_00410a68                           # 00410371
L_00410376:
    # block 0x00410376: entered by switch case, 11 instruction(s), calls FUN_004acbf1, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410376
    push ecx                                     # 0041037c
    lea edx, [ebp - local_20]                    # 0041037d
    push edx                                     # 00410380
    movsx eax, word ptr [0x5c39e3]               # 00410381
    imul eax, eax, 0x8d                          # 00410388
    add eax, 0x5bb5e5                            # 0041038e
    push eax                                     # 00410393
    mov ecx, 0x6369e4                            # 00410394
    call FUN_004acbf1                            # 00410399
    jmp.d32 L_00410a68                           # 0041039e
L_004103a3:
    # block 0x004103a3: entered by switch case, 11 instruction(s), calls FUN_0048d12d, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004103a3
    push ecx                                     # 004103a9
    lea edx, [ebp - local_20]                    # 004103aa
    push edx                                     # 004103ad
    movsx eax, word ptr [0x5c39e3]               # 004103ae
    imul eax, eax, 0x8d                          # 004103b5
    add eax, 0x5bb5e5                            # 004103bb
    push eax                                     # 004103c0
    mov ecx, 0x61d345                            # 004103c1
    call FUN_0048d12d                            # 004103c6
    jmp.d32 L_00410a68                           # 004103cb
L_004103d0:
    # block 0x004103d0: entered by switch case, 11 instruction(s), calls FUN_004b5c5c, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004103d0
    push ecx                                     # 004103d6
    lea edx, [ebp - local_20]                    # 004103d7
    push edx                                     # 004103da
    movsx eax, word ptr [0x5c39e3]               # 004103db
    imul eax, eax, 0x8d                          # 004103e2
    add eax, 0x5bb5e5                            # 004103e8
    push eax                                     # 004103ed
    mov ecx, 0x61d449                            # 004103ee
    call FUN_004b5c5c                            # 004103f3
    jmp.d32 L_00410a68                           # 004103f8
L_004103fd:
    # block 0x004103fd: entered by switch case, 11 instruction(s), calls FUN_004ab46d, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004103fd
    push ecx                                     # 00410403
    lea edx, [ebp - local_20]                    # 00410404
    push edx                                     # 00410407
    movsx eax, word ptr [0x5c39e3]               # 00410408
    imul eax, eax, 0x8d                          # 0041040f
    add eax, 0x5bb5e5                            # 00410415
    push eax                                     # 0041041a
    mov ecx, 0x61d6c1                            # 0041041b
    call FUN_004ab46d                            # 00410420
    jmp.d32 L_00410a68                           # 00410425
L_0041042a:
    # block 0x0041042a: entered by switch case, 11 instruction(s), calls FUN_00465bde, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041042a
    push ecx                                     # 00410430
    lea edx, [ebp - local_20]                    # 00410431
    push edx                                     # 00410434
    movsx eax, word ptr [0x5c39e3]               # 00410435
    imul eax, eax, 0x8d                          # 0041043c
    add eax, 0x5bb5e5                            # 00410442
    push eax                                     # 00410447
    mov ecx, 0x61d723                            # 00410448
    call FUN_00465bde                            # 0041044d
    jmp.d32 L_00410a68                           # 00410452
L_00410457:
    # block 0x00410457: entered by switch case, 11 instruction(s), calls FUN_004a64b9, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410457
    push ecx                                     # 0041045d
    lea edx, [ebp - local_20]                    # 0041045e
    push edx                                     # 00410461
    movsx eax, word ptr [0x5c39e3]               # 00410462
    imul eax, eax, 0x8d                          # 00410469
    add eax, 0x5bb5e5                            # 0041046f
    push eax                                     # 00410474
    mov ecx, 0x61d3a1                            # 00410475
    call FUN_004a64b9                            # 0041047a
    jmp.d32 L_00410a68                           # 0041047f
L_00410484:
    # block 0x00410484: entered by switch case, 11 instruction(s), calls FUN_00461903, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410484
    push ecx                                     # 0041048a
    lea edx, [ebp - local_20]                    # 0041048b
    push edx                                     # 0041048e
    movsx eax, word ptr [0x5c39e3]               # 0041048f
    imul eax, eax, 0x8d                          # 00410496
    add eax, 0x5bb5e5                            # 0041049c
    push eax                                     # 004104a1
    mov ecx, 0x61d779                            # 004104a2
    call FUN_00461903                            # 004104a7
    jmp.d32 L_00410a68                           # 004104ac
L_004104b1:
    # block 0x004104b1: entered by switch case, 11 instruction(s), calls FUN_00487bd7, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004104b1
    push ecx                                     # 004104b7
    lea edx, [ebp - local_20]                    # 004104b8
    push edx                                     # 004104bb
    movsx eax, word ptr [0x5c39e3]               # 004104bc
    imul eax, eax, 0x8d                          # 004104c3
    add eax, 0x5bb5e5                            # 004104c9
    push eax                                     # 004104ce
    mov ecx, 0x61d7d8                            # 004104cf
    call FUN_00487bd7                            # 004104d4
    jmp.d32 L_00410a68                           # 004104d9
L_004104de:
    # block 0x004104de: entered by switch case, 11 instruction(s), calls FUN_004afe09, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004104de
    push ecx                                     # 004104e4
    lea edx, [ebp - local_20]                    # 004104e5
    push edx                                     # 004104e8
    movsx eax, word ptr [0x5c39e3]               # 004104e9
    imul eax, eax, 0x8d                          # 004104f0
    add eax, 0x5bb5e5                            # 004104f6
    push eax                                     # 004104fb
    mov ecx, 0x6204c1                            # 004104fc
    call FUN_004afe09                            # 00410501
    jmp.d32 L_00410a68                           # 00410506
L_0041050b:
    # block 0x0041050b: entered by switch case, 12 instruction(s), calls FUN_00470e8e, ends with forward jump to 0x00410a68
    push 0x0                                     # 0041050b
    lea ecx, [ebp - local_cc]                    # 0041050d
    push ecx                                     # 00410513
    lea edx, [ebp - local_20]                    # 00410514
    push edx                                     # 00410517
    movsx eax, word ptr [0x5c39e3]               # 00410518
    imul eax, eax, 0x8d                          # 0041051f
    add eax, 0x5bb5e5                            # 00410525
    push eax                                     # 0041052a
    mov ecx, 0x62387c                            # 0041052b
    call FUN_00470e8e                            # 00410530
    jmp.d32 L_00410a68                           # 00410535
L_0041053a:
    # block 0x0041053a: entered by switch case, 12 instruction(s), calls FUN_00470e8e, ends with forward jump to 0x00410a68
    push 0x1                                     # 0041053a
    lea ecx, [ebp - local_cc]                    # 0041053c
    push ecx                                     # 00410542
    lea edx, [ebp - local_20]                    # 00410543
    push edx                                     # 00410546
    movsx eax, word ptr [0x5c39e3]               # 00410547
    imul eax, eax, 0x8d                          # 0041054e
    add eax, 0x5bb5e5                            # 00410554
    push eax                                     # 00410559
    mov ecx, 0x62387c                            # 0041055a
    call FUN_00470e8e                            # 0041055f
    jmp.d32 L_00410a68                           # 00410564
L_00410569:
    # block 0x00410569: entered by switch case, 11 instruction(s), calls FUN_0048bca6, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410569
    push ecx                                     # 0041056f
    lea edx, [ebp - local_20]                    # 00410570
    push edx                                     # 00410573
    movsx eax, word ptr [0x5c39e3]               # 00410574
    imul eax, eax, 0x8d                          # 0041057b
    add eax, 0x5bb5e5                            # 00410581
    push eax                                     # 00410586
    mov ecx, 0x624686                            # 00410587
    call FUN_0048bca6                            # 0041058c
    jmp.d32 L_00410a68                           # 00410591
L_00410596:
    # block 0x00410596: entered by switch case, 11 instruction(s), calls FUN_0047d682, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410596
    push ecx                                     # 0041059c
    lea edx, [ebp - local_20]                    # 0041059d
    push edx                                     # 004105a0
    movsx eax, word ptr [0x5c39e3]               # 004105a1
    imul eax, eax, 0x8d                          # 004105a8
    add eax, 0x5bb5e5                            # 004105ae
    push eax                                     # 004105b3
    mov ecx, 0x6246dc                            # 004105b4
    call FUN_0047d682                            # 004105b9
    jmp.d32 L_00410a68                           # 004105be
L_004105c3:
    # block 0x004105c3: entered by switch case, 11 instruction(s), calls FUN_004782db, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004105c3
    push ecx                                     # 004105c9
    lea edx, [ebp - local_20]                    # 004105ca
    push edx                                     # 004105cd
    movsx eax, word ptr [0x5c39e3]               # 004105ce
    imul eax, eax, 0x8d                          # 004105d5
    add eax, 0x5bb5e5                            # 004105db
    push eax                                     # 004105e0
    mov ecx, 0x621a02                            # 004105e1
    call FUN_004782db                            # 004105e6
    jmp.d32 L_00410a68                           # 004105eb
L_004105f0:
    # block 0x004105f0: entered by switch case, 11 instruction(s), calls FUN_00475964, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004105f0
    push ecx                                     # 004105f6
    lea edx, [ebp - local_20]                    # 004105f7
    push edx                                     # 004105fa
    movsx eax, word ptr [0x5c39e3]               # 004105fb
    imul eax, eax, 0x8d                          # 00410602
    add eax, 0x5bb5e5                            # 00410608
    push eax                                     # 0041060d
    mov ecx, 0x622fa2                            # 0041060e
    call FUN_00475964                            # 00410613
    jmp.d32 L_00410a68                           # 00410618
L_0041061d:
    # block 0x0041061d: entered by switch case, 11 instruction(s), calls FUN_0045b4ae, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041061d
    push ecx                                     # 00410623
    lea edx, [ebp - local_20]                    # 00410624
    push edx                                     # 00410627
    movsx eax, word ptr [0x5c39e3]               # 00410628
    imul eax, eax, 0x8d                          # 0041062f
    add eax, 0x5bb5e5                            # 00410635
    push eax                                     # 0041063a
    mov ecx, 0x624734                            # 0041063b
    call FUN_0045b4ae                            # 00410640
    jmp.d32 L_00410a68                           # 00410645
L_0041064a:
    # block 0x0041064a: entered by switch case, 11 instruction(s), calls FUN_00456fb6, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041064a
    push ecx                                     # 00410650
    lea edx, [ebp - local_20]                    # 00410651
    push edx                                     # 00410654
    movsx eax, word ptr [0x5c39e3]               # 00410655
    imul eax, eax, 0x8d                          # 0041065c
    add eax, 0x5bb5e5                            # 00410662
    push eax                                     # 00410667
    mov ecx, 0x6248ed                            # 00410668
    call FUN_00456fb6                            # 0041066d
    jmp.d32 L_00410a68                           # 00410672
L_00410677:
    # block 0x00410677: entered by switch case, 11 instruction(s), calls FUN_0044e8a2, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410677
    push ecx                                     # 0041067d
    lea edx, [ebp - local_20]                    # 0041067e
    push edx                                     # 00410681
    movsx eax, word ptr [0x5c39e3]               # 00410682
    imul eax, eax, 0x8d                          # 00410689
    add eax, 0x5bb5e5                            # 0041068f
    push eax                                     # 00410694
    mov ecx, 0x624931                            # 00410695
    call FUN_0044e8a2                            # 0041069a
    jmp.d32 L_00410a68                           # 0041069f
L_004106a4:
    # block 0x004106a4: entered by switch case, 11 instruction(s), calls FUN_004b72cf, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004106a4
    push ecx                                     # 004106aa
    lea edx, [ebp - local_20]                    # 004106ab
    push edx                                     # 004106ae
    movsx eax, word ptr [0x5c39e3]               # 004106af
    imul eax, eax, 0x8d                          # 004106b6
    add eax, 0x5bb5e5                            # 004106bc
    push eax                                     # 004106c1
    mov ecx, 0x6249a0                            # 004106c2
    call FUN_004b72cf                            # 004106c7
    jmp.d32 L_00410a68                           # 004106cc
L_004106d1:
    # block 0x004106d1: entered by switch case, 11 instruction(s), calls FUN_00454e70, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004106d1
    push ecx                                     # 004106d7
    lea edx, [ebp - local_20]                    # 004106d8
    push edx                                     # 004106db
    movsx eax, word ptr [0x5c39e3]               # 004106dc
    imul eax, eax, 0x8d                          # 004106e3
    add eax, 0x5bb5e5                            # 004106e9
    push eax                                     # 004106ee
    mov ecx, 0x6249dc                            # 004106ef
    call FUN_00454e70                            # 004106f4
    jmp.d32 L_00410a68                           # 004106f9
L_004106fe:
    # block 0x004106fe: entered by switch case, 11 instruction(s), calls FUN_00464100, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004106fe
    push ecx                                     # 00410704
    lea edx, [ebp - local_20]                    # 00410705
    push edx                                     # 00410708
    movsx eax, word ptr [0x5c39e3]               # 00410709
    imul eax, eax, 0x8d                          # 00410710
    add eax, 0x5bb5e5                            # 00410716
    push eax                                     # 0041071b
    mov ecx, 0x624b50                            # 0041071c
    call FUN_00464100                            # 00410721
    jmp.d32 L_00410a68                           # 00410726
L_0041072b:
    # block 0x0041072b: entered by switch case, 11 instruction(s), calls FUN_0046e823, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041072b
    push ecx                                     # 00410731
    lea edx, [ebp - local_20]                    # 00410732
    push edx                                     # 00410735
    movsx eax, word ptr [0x5c39e3]               # 00410736
    imul eax, eax, 0x8d                          # 0041073d
    add eax, 0x5bb5e5                            # 00410743
    push eax                                     # 00410748
    mov ecx, 0x624c2a                            # 00410749
    call FUN_0046e823                            # 0041074e
    jmp.d32 L_00410a68                           # 00410753
L_00410758:
    # block 0x00410758: entered by switch case, 11 instruction(s), calls FUN_0044fbe3, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410758
    push ecx                                     # 0041075e
    lea edx, [ebp - local_20]                    # 0041075f
    push edx                                     # 00410762
    movsx eax, word ptr [0x5c39e3]               # 00410763
    imul eax, eax, 0x8d                          # 0041076a
    add eax, 0x5bb5e5                            # 00410770
    push eax                                     # 00410775
    mov ecx, 0x61d873                            # 00410776
    call FUN_0044fbe3                            # 0041077b
    jmp.d32 L_00410a68                           # 00410780
L_00410785:
    # block 0x00410785: entered by switch case, 11 instruction(s), calls FUN_0047b3f0, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410785
    push ecx                                     # 0041078b
    lea edx, [ebp - local_20]                    # 0041078c
    push edx                                     # 0041078f
    movsx eax, word ptr [0x5c39e3]               # 00410790
    imul eax, eax, 0x8d                          # 00410797
    add eax, 0x5bb5e5                            # 0041079d
    push eax                                     # 004107a2
    mov ecx, 0x61e398                            # 004107a3
    call FUN_0047b3f0                            # 004107a8
    jmp.d32 L_00410a68                           # 004107ad
L_004107b2:
    # block 0x004107b2: entered by switch case, 11 instruction(s), calls FUN_004ba2bd, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004107b2
    push ecx                                     # 004107b8
    lea edx, [ebp - local_20]                    # 004107b9
    push edx                                     # 004107bc
    movsx eax, word ptr [0x5c39e3]               # 004107bd
    imul eax, eax, 0x8d                          # 004107c4
    add eax, 0x5bb5e5                            # 004107ca
    push eax                                     # 004107cf
    mov ecx, 0x61df56                            # 004107d0
    call FUN_004ba2bd                            # 004107d5
    jmp.d32 L_00410a68                           # 004107da
L_004107df:
    # block 0x004107df: entered by switch case, 11 instruction(s), calls FUN_0044d1d1, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004107df
    push ecx                                     # 004107e5
    lea edx, [ebp - local_20]                    # 004107e6
    push edx                                     # 004107e9
    movsx eax, word ptr [0x5c39e3]               # 004107ea
    imul eax, eax, 0x8d                          # 004107f1
    add eax, 0x5bb5e5                            # 004107f7
    push eax                                     # 004107fc
    mov ecx, 0x624cbf                            # 004107fd
    call FUN_0044d1d1                            # 00410802
    jmp.d32 L_00410a68                           # 00410807
L_0041080c:
    # block 0x0041080c: entered by switch case, 11 instruction(s), calls FUN_00482248, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041080c
    push ecx                                     # 00410812
    lea edx, [ebp - local_20]                    # 00410813
    push edx                                     # 00410816
    movsx eax, word ptr [0x5c39e3]               # 00410817
    imul eax, eax, 0x8d                          # 0041081e
    add eax, 0x5bb5e5                            # 00410824
    push eax                                     # 00410829
    mov ecx, 0x624d12                            # 0041082a
    call FUN_00482248                            # 0041082f
    jmp.d32 L_00410a68                           # 00410834
L_00410839:
    # block 0x00410839: entered by switch case, 11 instruction(s), calls FUN_0048e3ca, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410839
    push ecx                                     # 0041083f
    lea edx, [ebp - local_20]                    # 00410840
    push edx                                     # 00410843
    movsx eax, word ptr [0x5c39e3]               # 00410844
    imul eax, eax, 0x8d                          # 0041084b
    add eax, 0x5bb5e5                            # 00410851
    push eax                                     # 00410856
    mov ecx, 0x624dc9                            # 00410857
    call FUN_0048e3ca                            # 0041085c
    jmp.d32 L_00410a68                           # 00410861
L_00410866:
    # block 0x00410866: entered by switch case, 11 instruction(s), calls FUN_004aa002, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410866
    push ecx                                     # 0041086c
    lea edx, [ebp - local_20]                    # 0041086d
    push edx                                     # 00410870
    movsx eax, word ptr [0x5c39e3]               # 00410871
    imul eax, eax, 0x8d                          # 00410878
    add eax, 0x5bb5e5                            # 0041087e
    push eax                                     # 00410883
    mov ecx, 0x630a34                            # 00410884
    call FUN_004aa002                            # 00410889
    jmp.d32 L_00410a68                           # 0041088e
L_00410893:
    # block 0x00410893: entered by switch case, 11 instruction(s), calls FUN_00484110, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410893
    push ecx                                     # 00410899
    lea edx, [ebp - local_20]                    # 0041089a
    push edx                                     # 0041089d
    movsx eax, word ptr [0x5c39e3]               # 0041089e
    imul eax, eax, 0x8d                          # 004108a5
    add eax, 0x5bb5e5                            # 004108ab
    push eax                                     # 004108b0
    mov ecx, 0x6252ad                            # 004108b1
    call FUN_00484110                            # 004108b6
    jmp.d32 L_00410a68                           # 004108bb
L_004108c0:
    # block 0x004108c0: entered by switch case, 11 instruction(s), calls FUN_0047e477, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004108c0
    push ecx                                     # 004108c6
    lea edx, [ebp - local_20]                    # 004108c7
    push edx                                     # 004108ca
    movsx eax, word ptr [0x5c39e3]               # 004108cb
    imul eax, eax, 0x8d                          # 004108d2
    add eax, 0x5bb5e5                            # 004108d8
    push eax                                     # 004108dd
    mov ecx, 0x625ee8                            # 004108de
    call FUN_0047e477                            # 004108e3
    jmp.d32 L_00410a68                           # 004108e8
L_004108ed:
    # block 0x004108ed: entered by switch case, 11 instruction(s), calls FUN_004a7e50, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004108ed
    push ecx                                     # 004108f3
    lea edx, [ebp - local_20]                    # 004108f4
    push edx                                     # 004108f7
    movsx eax, word ptr [0x5c39e3]               # 004108f8
    imul eax, eax, 0x8d                          # 004108ff
    add eax, 0x5bb5e5                            # 00410905
    push eax                                     # 0041090a
    mov ecx, 0x627335                            # 0041090b
    call FUN_004a7e50                            # 00410910
    jmp.d32 L_00410a68                           # 00410915
L_0041091a:
    # block 0x0041091a: entered by switch case, 11 instruction(s), calls FUN_0046b79a, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 0041091a
    push ecx                                     # 00410920
    lea edx, [ebp - local_20]                    # 00410921
    push edx                                     # 00410924
    movsx eax, word ptr [0x5c39e3]               # 00410925
    imul eax, eax, 0x8d                          # 0041092c
    add eax, 0x5bb5e5                            # 00410932
    push eax                                     # 00410937
    mov ecx, 0x628732                            # 00410938
    call FUN_0046b79a                            # 0041093d
    jmp.d32 L_00410a68                           # 00410942
L_00410947:
    # block 0x00410947: entered by switch case, 11 instruction(s), calls FUN_00467688, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410947
    push ecx                                     # 0041094d
    lea edx, [ebp - local_20]                    # 0041094e
    push edx                                     # 00410951
    movsx eax, word ptr [0x5c39e3]               # 00410952
    imul eax, eax, 0x8d                          # 00410959
    add eax, 0x5bb5e5                            # 0041095f
    push eax                                     # 00410964
    mov ecx, 0x61e65c                            # 00410965
    call FUN_00467688                            # 0041096a
    jmp.d32 L_00410a68                           # 0041096f
L_00410974:
    # block 0x00410974: entered by switch case, 11 instruction(s), calls FUN_0047314b, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 00410974
    push ecx                                     # 0041097a
    lea edx, [ebp - local_20]                    # 0041097b
    push edx                                     # 0041097e
    movsx eax, word ptr [0x5c39e3]               # 0041097f
    imul eax, eax, 0x8d                          # 00410986
    add eax, 0x5bb5e5                            # 0041098c
    push eax                                     # 00410991
    mov ecx, 0x61e95c                            # 00410992
    call FUN_0047314b                            # 00410997
    jmp.d32 L_00410a68                           # 0041099c
L_004109a1:
    # block 0x004109a1: entered by switch case, 11 instruction(s), calls FUN_0045807c, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004109a1
    push ecx                                     # 004109a7
    lea edx, [ebp - local_20]                    # 004109a8
    push edx                                     # 004109ab
    movsx eax, word ptr [0x5c39e3]               # 004109ac
    imul eax, eax, 0x8d                          # 004109b3
    add eax, 0x5bb5e5                            # 004109b9
    push eax                                     # 004109be
    mov ecx, 0x61ed7b                            # 004109bf
    call FUN_0045807c                            # 004109c4
    jmp.d32 L_00410a68                           # 004109c9
L_004109ce:
    # block 0x004109ce: entered by switch case, 11 instruction(s), calls FUN_004b80d9, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004109ce
    push ecx                                     # 004109d4
    lea edx, [ebp - local_20]                    # 004109d5
    push edx                                     # 004109d8
    movsx eax, word ptr [0x5c39e3]               # 004109d9
    imul eax, eax, 0x8d                          # 004109e0
    add eax, 0x5bb5e5                            # 004109e6
    push eax                                     # 004109eb
    mov ecx, 0x61ee6e                            # 004109ec
    call FUN_004b80d9                            # 004109f1
    jmp.d8 L_00410a68                            # 004109f6
L_004109f8:
    # block 0x004109f8: entered by switch case, 11 instruction(s), calls FUN_0045ddd0, ends with forward jump to 0x00410a68
    lea ecx, [ebp - local_cc]                    # 004109f8
    push ecx                                     # 004109fe
    lea edx, [ebp - local_20]                    # 004109ff
    push edx                                     # 00410a02
    movsx eax, word ptr [0x5c39e3]               # 00410a03
    imul eax, eax, 0x8d                          # 00410a0a
    add eax, 0x5bb5e5                            # 00410a10
    push eax                                     # 00410a15
    mov ecx, 0x61f4b1                            # 00410a16
    call FUN_0045ddd0                            # 00410a1b
    jmp.d8 L_00410a68                            # 00410a20
L_00410a22:
    # block 0x00410a22: entered by ja at 0x0040b4eb; switch case, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00410a68
    movsx ecx, word ptr [0x5c39e3]               # 00410a22
    imul ecx, ecx, 0x8d                          # 00410a29
    {load} xor edx, edx                          # 00410a2f
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 00410a31
    push edx                                     # 00410a37
    push 0x540f78                                # 00410a38
    push 0x63888b                                # 00410a3d
    call FUN_0050ca3e                            # 00410a42
    add esp, 0xc                                 # 00410a47
    push 0x63888b                                # 00410a4a
    push 0x540f80                                # 00410a4f
    mov ecx, 0x583979                            # 00410a54
    call FUN_0042639d                            # 00410a59
    mov ecx, 0x5cf659                            # 00410a5e
    call FUN_004c97b4                            # 00410a63
L_00410a68:
    # block 0x00410a68: entered by jmp at 0x0040b5ec; jmp at 0x0040b7cf; jmp at 0x0040b98a; jmp at 0x0040baf8; more, 2 instruction(s), ends with je to 0x00410b2d (forward)
    cmp dword ptr [ebp - local_108], 0x0         # 00410a68
    je.d32 L_00410b2d                            # 00410a6f
    # block 0x00410a75: entered by fall-through of je at 0x00410a6f, 2 instruction(s), ends with je to 0x00410aaa (forward)
    cmp dword ptr [ebp - local_f8], 0x0          # 00410a75
    je.d8 L_00410aaa                             # 00410a7c
    # block 0x00410a7e: entered by fall-through of je at 0x00410a7c, 12 instruction(s), calls FUN_00424aa8, falls into the block at 0x00410aaa
    mov eax, dword ptr [ebp - local_20]          # 00410a7e
    push eax                                     # 00410a81
    mov ecx, dword ptr [ebp + arg_c]             # 00410a82
    push ecx                                     # 00410a85
    mov edx, dword ptr [ebp - local_cc]          # 00410a86
    push edx                                     # 00410a8c
    movsx eax, word ptr [0x5c39e3]               # 00410a8d
    imul eax, eax, 0x8d                          # 00410a94
    add eax, 0x5bb5b3                            # 00410a9a
    push eax                                     # 00410a9f
    mov ecx, 0x63786d                            # 00410aa0
    call FUN_00424aa8                            # 00410aa5
L_00410aaa:
    # block 0x00410aaa: entered by je at 0x00410a7c, 5 instruction(s), ends with jne to 0x00410ae3 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 00410aaa
    imul ecx, ecx, 0x8d                          # 00410ab1
    mov dword ptr [ecx + 0x5bb638], 0x0          # 00410ab7
    cmp dword ptr [0x5c3a01], 0x2                # 00410ac1
    jne.d8 L_00410ae3                            # 00410ac8
    # block 0x00410aca: entered by fall-through of jne at 0x00410ac8, 4 instruction(s), ends with forward jump to 0x00410afa
    movsx edx, word ptr [0x5c39e3]               # 00410aca
    imul edx, edx, 0x8d                          # 00410ad1
    mov dword ptr [edx + 0x5bb63c], 0x1          # 00410ad7
    jmp.d8 L_00410afa                            # 00410ae1
L_00410ae3:
    # block 0x00410ae3: entered by jne at 0x00410ac8, 3 instruction(s), falls into the block at 0x00410afa
    movsx eax, word ptr [0x5c39e3]               # 00410ae3
    imul eax, eax, 0x8d                          # 00410aea
    mov dword ptr [eax + 0x5bb63c], 0x0          # 00410af0
L_00410afa:
    # block 0x00410afa: entered by jmp at 0x00410ae1, 3 instruction(s), ends with jne to 0x00410b1b (forward)
    movsx ecx, word ptr [0x5c39e3]               # 00410afa
    cmp dword ptr [ebp - local_d0], ecx          # 00410b01
    jne.d8 L_00410b1b                            # 00410b07
    # block 0x00410b09: entered by fall-through of jne at 0x00410b07, 4 instruction(s), ends with forward jump to 0x00410b28
    mov edx, dword ptr [ebp - local_d0]          # 00410b09
    add edx, 0x1                                 # 00410b0f
    mov word ptr [0x5c39e3], dx                  # 00410b12
    jmp.d8 L_00410b28                            # 00410b19
L_00410b1b:
    # block 0x00410b1b: entered by jne at 0x00410b07, 2 instruction(s), falls into the block at 0x00410b28
    mov ax, word ptr [ebp - local_d0]            # 00410b1b
    mov word ptr [0x5c39e3], ax                  # 00410b22
L_00410b28:
    # block 0x00410b28: entered by jmp at 0x00410b19, 1 instruction(s), ends with forward jump to 0x00410c07
    jmp.d32 L_00410c07                           # 00410b28
L_00410b2d:
    # block 0x00410b2d: entered by je at 0x00410a6f, 24 instruction(s), ends with je to 0x00410bf9 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 00410b2d
    imul ecx, ecx, 0x8d                          # 00410b34
    mov byte ptr [ecx + 0x5bb5e3], 0x0           # 00410b3a
    movsx edx, word ptr [0x5c39e3]               # 00410b41
    imul edx, edx, 0x8d                          # 00410b48
    mov byte ptr [edx + 0x5bb625], 0x0           # 00410b4e
    movsx eax, word ptr [0x5c39e3]               # 00410b55
    imul eax, eax, 0x8d                          # 00410b5c
    mov dword ptr [eax + 0x5bb626], 0x0          # 00410b62
    movsx ecx, word ptr [0x5c39e3]               # 00410b6c
    imul ecx, ecx, 0x8d                          # 00410b73
    mov dword ptr [ecx + 0x5bb632], 0x0          # 00410b79
    movsx edx, word ptr [0x5c39e3]               # 00410b83
    imul edx, edx, 0x8d                          # 00410b8a
    mov word ptr [edx + 0x5bb636], 0xffff        # 00410b90
    movsx eax, word ptr [0x5c39e3]               # 00410b99
    imul eax, eax, 0x8d                          # 00410ba0
    mov dword ptr [eax + 0x5bb638], 0x1          # 00410ba6
    movsx ecx, word ptr [0x5c39e3]               # 00410bb0
    imul ecx, ecx, 0x8d                          # 00410bb7
    mov dword ptr [ecx + 0x5bb63c], 0x0          # 00410bbd
    movsx edx, word ptr [0x63a4cd]               # 00410bc7
    test edx, edx                                # 00410bce
    je.d8 L_00410bf9                             # 00410bd0
    # block 0x00410bd2: entered by fall-through of je at 0x00410bd0, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00410bf9
    movsx eax, word ptr [0x5c39e3]               # 00410bd2
    push eax                                     # 00410bd9
    push 0x540fa4                                # 00410bda
    push 0x63888b                                # 00410bdf
    call FUN_0050ca3e                            # 00410be4
    add esp, 0xc                                 # 00410be9
    push 0x63888b                                # 00410bec
    call FUN_0044a2b7                            # 00410bf1
    add esp, 0x4                                 # 00410bf6
L_00410bf9:
    # block 0x00410bf9: entered by je at 0x00410bd0, 2 instruction(s), falls into the block at 0x00410c07
    mov cx, word ptr [ebp - local_d0]            # 00410bf9
    mov word ptr [0x5c39e3], cx                  # 00410c00
L_00410c07:
    # block 0x00410c07: entered by jmp at 0x00410b28, 3 instruction(s), ends with je to 0x00410c9e (forward)
    movsx edx, word ptr [0x63a4cd]               # 00410c07
    test edx, edx                                # 00410c0e
    je.d32 L_00410c9e                            # 00410c10
    # block 0x00410c16: entered by fall-through of je at 0x00410c10, 3 instruction(s), ends with forward jump to 0x00410c3b
    mov dword ptr [ebp - local_144], 0x0         # 00410c16
    mov dword ptr [ebp - local_148], 0x0         # 00410c20
    jmp.d8 L_00410c3b                            # 00410c2a
L_00410c2c:
    # block 0x00410c2c: entered by jmp at 0x00410c6e, 3 instruction(s), falls into the block at 0x00410c3b
    mov eax, dword ptr [ebp - local_144]         # 00410c2c
    add eax, 0x1                                 # 00410c32
    mov dword ptr [ebp - local_144], eax         # 00410c35
L_00410c3b:
    # block 0x00410c3b: entered by jmp at 0x00410c2a, 3 instruction(s), ends with jge to 0x00410c70 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 00410c3b
    cmp dword ptr [ebp - local_144], ecx         # 00410c42
    jge.d8 L_00410c70                            # 00410c48
    # block 0x00410c4a: entered by fall-through of jge at 0x00410c48, 4 instruction(s), ends with jne to 0x00410c6e (forward)
    mov edx, dword ptr [ebp - local_144]         # 00410c4a
    imul edx, edx, 0x8d                          # 00410c50
    cmp dword ptr [edx + 0x5bb638], 0x0          # 00410c56
    jne.d8 L_00410c6e                            # 00410c5d
    # block 0x00410c5f: entered by fall-through of jne at 0x00410c5d, 3 instruction(s), falls into the block at 0x00410c6e
    mov eax, dword ptr [ebp - local_148]         # 00410c5f
    add eax, 0x1                                 # 00410c65
    mov dword ptr [ebp - local_148], eax         # 00410c68
L_00410c6e:
    # block 0x00410c6e: entered by jne at 0x00410c5d, 1 instruction(s), ends with backward jump to 0x00410c2c
    jmp.d8 L_00410c2c                            # 00410c6e
L_00410c70:
    # block 0x00410c70: entered by jge at 0x00410c48, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00410c9e
    mov ecx, dword ptr [ebp - local_148]         # 00410c70
    push ecx                                     # 00410c76
    movsx edx, word ptr [0x5c39e3]               # 00410c77
    push edx                                     # 00410c7e
    push 0x540fe4                                # 00410c7f
    push 0x63888b                                # 00410c84
    call FUN_0050ca3e                            # 00410c89
    add esp, 0x10                                # 00410c8e
    push 0x63888b                                # 00410c91
    call FUN_0044a2b7                            # 00410c96
    add esp, 0x4                                 # 00410c9b
L_00410c9e:
    # block 0x00410c9e: entered by jmp at 0x0040b577; jmp at 0x0040b662; jmp at 0x0040b845; jmp at 0x0040ba1f; more, 5 instruction(s), ends with ret
    pop edi                                      # 00410c9e
    pop esi                                      # 00410c9f
    {load} mov esp, ebp                          # 00410ca0
    pop ebp                                      # 00410ca2
    ret                                          # 00410ca3

# --- data items (not part of the function) -------------------------
.org 0x00410ca4 - 0x401000
SWTAB_00410ca4:  # 126 case address(es)
    .long L_0040bddd - .text + 0x401000
    .long L_0040b7d4 - .text + 0x401000
    .long L_0040bafd - .text + 0x401000
    .long L_0040b506 - .text + 0x401000
    .long L_0040b5f1 - .text + 0x401000
    .long L_0040b98f - .text + 0x401000
    .long L_0040bea4 - .text + 0x401000
    .long L_0040bbed - .text + 0x401000
    .long L_0040bc1a - .text + 0x401000
    .long L_0040bc47 - .text + 0x401000
    .long L_0040bfab - .text + 0x401000
    .long L_0040bd12 - .text + 0x401000
    .long L_0040c0b2 - .text + 0x401000
    .long L_0040c0e0 - .text + 0x401000
    .long L_0040c114 - .text + 0x401000
    .long L_0040c186 - .text + 0x401000
    .long L_0040c29b - .text + 0x401000
    .long L_0040c3a8 - .text + 0x401000
    .long L_0040c3d6 - .text + 0x401000
    .long L_0040c446 - .text + 0x401000
    .long L_0040c404 - .text + 0x401000
    .long L_0040c142 - .text + 0x401000
    .long L_0040c487 - .text + 0x401000
    .long L_0040c4b5 - .text + 0x401000
    .long L_0040d4ed - .text + 0x401000
    .long L_0040c4e3 - .text + 0x401000
    .long L_0040c511 - .text + 0x401000
    .long L_0040c53f - .text + 0x401000
    .long L_0040c56d - .text + 0x401000
    .long L_0040c625 - .text + 0x401000
    .long L_0040cf87 - .text + 0x401000
    .long L_0040c59b - .text + 0x401000
    .long L_0040c5c9 - .text + 0x401000
    .long L_0040c5f7 - .text + 0x401000
    .long L_0040caac - .text + 0x401000
    .long L_0040d7ac - .text + 0x401000
    .long L_0040da9b - .text + 0x401000
    .long L_0040d896 - .text + 0x401000
    .long L_0040d04b - .text + 0x401000
    .long L_0040d116 - .text + 0x401000
    .long L_0040d1da - .text + 0x401000
    .long L_0040d29f - .text + 0x401000
    .long L_0040d364 - .text + 0x401000
    .long L_0040d428 - .text + 0x401000
    .long L_0040d6aa - .text + 0x401000
    .long L_0040d9d4 - .text + 0x401000
    .long L_0040e0c6 - .text + 0x401000
    .long L_0040e18b - .text + 0x401000
    .long L_0040e250 - .text + 0x401000
    .long L_0040e314 - .text + 0x401000
    .long L_0040e3d9 - .text + 0x401000
    .long L_0040e49e - .text + 0x401000
    .long L_0040dc38 - .text + 0x401000
    .long L_0040dd0c - .text + 0x401000
    .long L_0040ddde - .text + 0x401000
    .long L_0040df22 - .text + 0x401000
    .long L_0040dff4 - .text + 0x401000
    .long L_0040db66 - .text + 0x401000
    .long L_0040e56a - .text + 0x401000
    .long L_0040e597 - .text + 0x401000
    .long L_0040e6e3 - .text + 0x401000
    .long L_0040e711 - .text + 0x401000
    .long L_0040e5c4 - .text + 0x401000
    .long L_0040e61e - .text + 0x401000
    .long L_0040e5f1 - .text + 0x401000
    .long L_0040e73f - .text + 0x401000
    .long L_0040e805 - .text + 0x401000
    .long L_0040e8cc - .text + 0x401000
    .long L_0040e995 - .text + 0x401000
    .long L_0040ffd9 - .text + 0x401000
    .long L_0040ea5e - .text + 0x401000
    .long L_004100a3 - .text + 0x401000
    .long L_0040eb28 - .text + 0x401000
    .long L_0040f532 - .text + 0x401000
    .long L_0040fd17 - .text + 0x401000
    .long L_0040fde0 - .text + 0x401000
    .long L_0040fee2 - .text + 0x401000
    .long L_00410170 - .text + 0x401000
    .long L_0040ebfa - .text + 0x401000
    .long L_0040f069 - .text + 0x401000
    .long L_0041019e - .text + 0x401000
    .long L_004107df - .text + 0x401000
    .long L_00410268 - .text + 0x401000
    .long L_00410295 - .text + 0x401000
    .long L_004102c2 - .text + 0x401000
    .long L_004102ef - .text + 0x401000
    .long L_0041031c - .text + 0x401000
    .long L_00410349 - .text + 0x401000
    .long L_00410376 - .text + 0x401000
    .long L_004103a3 - .text + 0x401000
    .long L_004103d0 - .text + 0x401000
    .long L_00410457 - .text + 0x401000
    .long L_00410484 - .text + 0x401000
    .long L_004104b1 - .text + 0x401000
    .long L_004104de - .text + 0x401000
    .long L_0041050b - .text + 0x401000
    .long L_004105c3 - .text + 0x401000
    .long L_00410569 - .text + 0x401000
    .long L_00410596 - .text + 0x401000
    .long L_0041061d - .text + 0x401000
    .long L_0041064a - .text + 0x401000
    .long L_004106a4 - .text + 0x401000
    .long L_0041072b - .text + 0x401000
    .long L_004106d1 - .text + 0x401000
    .long L_004106fe - .text + 0x401000
    .long L_0041053a - .text + 0x401000
    .long L_004103fd - .text + 0x401000
    .long L_0041042a - .text + 0x401000
    .long L_004105f0 - .text + 0x401000
    .long L_00410758 - .text + 0x401000
    .long L_0041080c - .text + 0x401000
    .long L_00410839 - .text + 0x401000
    .long L_00410677 - .text + 0x401000
    .long L_00410866 - .text + 0x401000
    .long L_00410893 - .text + 0x401000
    .long L_004108c0 - .text + 0x401000
    .long L_004107b2 - .text + 0x401000
    .long L_00410785 - .text + 0x401000
    .long L_004108ed - .text + 0x401000
    .long L_00410947 - .text + 0x401000
    .long L_00410974 - .text + 0x401000
    .long L_004109a1 - .text + 0x401000
    .long L_0041091a - .text + 0x401000
    .long L_004109ce - .text + 0x401000
    .long L_004109f8 - .text + 0x401000
    .long L_00410a22 - .text + 0x401000
.org 0x00410e9c - 0x401000
IDXTAB_00410e9c:  # index table of FUN_0040b34a for the switch jump at 0x0040b4ff (237 byte(s))
    .byte 0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5
    .byte 6, 7, 8, 9, 10, 10, 11, 125, 125, 125, 125, 125, 125, 125, 12, 125
    .byte 125, 125, 125, 13, 14, 125, 125, 125, 125, 15, 16, 17, 18, 19, 20, 21
    .byte 21, 21, 21, 125, 21, 21, 125, 125, 125, 22, 23, 24, 25, 26, 27, 28
    .byte 125, 29, 30, 31, 32, 33, 125, 34, 125, 125, 125, 125, 125, 125, 125, 125
    .byte 125, 125, 125, 125, 125, 125, 35, 36, 37, 37, 38, 39, 40, 41, 42, 43
    .byte 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59
    .byte 60, 61, 62, 63, 64, 125, 65, 66, 67, 68, 125, 125, 125, 125, 125, 125
    .byte 125, 125, 125, 125, 125, 125, 125, 125, 125, 69, 70, 71, 72, 73, 74, 75
    .byte 76, 76, 77, 78, 73, 79, 80, 79, 125, 125, 125, 125, 125, 125, 125, 125
    .byte 81, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125
    .byte 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 82, 83
    .byte 84, 85, 86, 87, 125, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98
    .byte 99, 100, 101, 102, 103, 104, 105, 106, 107, 125, 108, 109, 110, 111, 112, 113
    .byte 114, 115, 125, 116, 117, 118, 125, 119, 120, 121, 122, 123, 124
.org 0x00410f89 - 0x401000
SWTAB_00410f89:  # 4 case address(es)
    .long L_0040babe - .text + 0x401000
    .long L_0040bacd - .text + 0x401000
    .long L_0040baeb - .text + 0x401000
    .long L_0040badc - .text + 0x401000
.set SWTAB_00410ca4_VA, SWTAB_00410ca4 - .text + 0x401000
.set IDXTAB_00410e9c_VA, IDXTAB_00410e9c - .text + 0x401000
.set SWTAB_00410f89_VA, SWTAB_00410f89 - .text + 0x401000

