# FUN_004181c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004181c6
# extent:       0x004181c6-0x00418e52 (3212 code bytes)
# span:         0x004181c6-0x00418e52 (code 3212, tables 0, padding 0)
# sha256:       6b051b4c2e88716c21eaee5129f423c2df6e6606d79c447ea48561b09f27a64e
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004181c6
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       41 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_114, local_118, local_11c, local_124, local_128, local_12a, local_12c, local_130 and 29 more
# fields:       [eax + n] field_1, field_4, field_8, field_c, field_29, field_2f, field_49, field_4b, field_4d, field_51, field_59, field_571 and 5 more; [ecx + n] field_4, field_8, field_c, field_23, field_27, field_2d, field_39, field_51, field_59, field_571, field_577, field_57b and 2 more; [edx + n] field_1, field_4, field_8, field_c, field_23, field_27, field_2b, field_2d, field_2f, field_31, field_51, field_59 and 5 more
# callees:      calls FUN_0050d0bc, FUN_0050ca3e, FUN_0052139c, FUN_0050cd72, FUN_0041a102, FUN_0050d0a9, FUN_0050cf61, FUN_0051dc43, FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, FUN_0041a216, FUN_0041a19c, FUN_0050ce2b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 823 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12a, 0x12a  # offset -0x12a
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_14e, 0x14e  # offset -0x14e
.equ local_150, 0x150  # offset -0x150
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
.equ local_1a1, 0x1a1  # offset -0x1a1
.equ local_1a2, 0x1a2  # offset -0x1a2
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_39, 0x39  # offset +0x39
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_571, 0x571  # offset +0x571
.equ field_573, 0x573  # offset +0x573
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_5c4, 0x5c4  # offset +0x5c4
.equ field_845, 0x845  # offset +0x845

# --- external targets -----------------------------------------------
.set FUN_0041a102, .text + (0x0041a102 - 0x401000)
.set FUN_0041a19c, .text + (0x0041a19c - 0x401000)
.set FUN_0041a216, .text + (0x0041a216 - 0x401000)
.set FUN_0041b6e2, .text + (0x0041b6e2 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004181c6 - 0x401000
.globl FUN_004181c6
FUN_004181c6:
    # block 0x004181c6: entry, 15 instruction(s), calls FUN_0050d0bc, ends with je to 0x0041822d (forward)
    push ebp                                     # 004181c6
    {load} mov ebp, esp                          # 004181c7
    sub esp, 0x1b0                               # 004181c9
    push esi                                     # 004181cf
    push edi                                     # 004181d0
    mov dword ptr [ebp - local_194], ecx         # 004181d1
    mov dword ptr [ebp - local_4], 0x0           # 004181d7
    mov eax, dword ptr [ebp + arg_c]             # 004181de
    push eax                                     # 004181e1
    call FUN_0050d0bc                            # 004181e2
    add esp, 0x4                                 # 004181e7
    mov dword ptr [ebp + arg_c], eax             # 004181ea
    mov ecx, dword ptr [ebp + arg_10]            # 004181ed
    cmp dword ptr [ecx], 0x0                     # 004181f0
    je.d8 L_0041822d                             # 004181f3
    # block 0x004181f5: entered by fall-through of je at 0x004181f3, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e45
    mov edx, dword ptr [ebp + arg_c]             # 004181f5
    push edx                                     # 004181f8
    push 0x5426bc                                # 004181f9
    mov eax, dword ptr [ebp - local_194]         # 004181fe
    add eax, 0x31f                               # 00418204
    push eax                                     # 00418209
    call FUN_0050ca3e                            # 0041820a
    add esp, 0xc                                 # 0041820f
    push 0x0                                     # 00418212
    push 0x0                                     # 00418214
    mov ecx, dword ptr [ebp - local_194]         # 00418216
    add ecx, 0x31f                               # 0041821c
    push ecx                                     # 00418222
    call FUN_0052139c                            # 00418223
    jmp.d32 L_00418e45                           # 00418228
L_0041822d:
    # block 0x0041822d: entered by je at 0x004181f3, 2 instruction(s), ends with je to 0x00418645 (forward)
    cmp dword ptr [0x5bb1fe], 0x0                # 0041822d
    je.d32 L_00418645                            # 00418234
    # block 0x0041823a: entered by fall-through of je at 0x00418234, 20 instruction(s), calls FUN_0050cd72, FUN_0041a102, ends with je to 0x00418645 (forward)
    push 0x54272c                                # 0041823a
    mov edx, dword ptr [ebp + arg_c]             # 0041823f
    push edx                                     # 00418242
    mov eax, dword ptr [ebp - local_194]         # 00418243
    add eax, 0x1f                                # 00418249
    push eax                                     # 0041824c
    mov ecx, dword ptr [ebp - local_194]         # 0041824d
    add ecx, 0x1c                                # 00418253
    push ecx                                     # 00418256
    lea edx, [ebp - local_114]                   # 00418257
    push edx                                     # 0041825d
    call FUN_0050cd72                            # 0041825e
    add esp, 0x14                                # 00418263
    lea eax, [ebp - local_114]                   # 00418266
    push eax                                     # 0041826c
    mov ecx, dword ptr [ebp - local_194]         # 0041826d
    call FUN_0041a102                            # 00418273
    movsx ecx, ax                                # 00418278
    test ecx, ecx                                # 0041827b
    je.d32 L_00418645                            # 0041827d
    # block 0x00418283: entered by fall-through of je at 0x0041827d, 16 instruction(s), calls FUN_0050d0a9, FUN_0050cf61, ends with je to 0x004182f1 (forward)
    push 0x542734                                # 00418283
    lea edx, [ebp - local_114]                   # 00418288
    push edx                                     # 0041828e
    call FUN_0050d0a9                            # 0041828f
    add esp, 0x8                                 # 00418294
    mov dword ptr [ebp - local_8], eax           # 00418297
    mov eax, dword ptr [ebp - local_8]           # 0041829a
    push eax                                     # 0041829d
    push 0x1                                     # 0041829e
    push 0x51                                    # 004182a0
    lea ecx, [ebp - local_168]                   # 004182a2
    push ecx                                     # 004182a8
    call FUN_0050cf61                            # 004182a9
    add esp, 0x10                                # 004182ae
    cmp eax, 0x1                                 # 004182b1
    je.d8 L_004182f1                             # 004182b4
    # block 0x004182b6: entered by fall-through of je at 0x004182b4, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e40
    lea edx, [ebp - local_114]                   # 004182b6
    push edx                                     # 004182bc
    push 0x542738                                # 004182bd
    mov eax, dword ptr [ebp - local_194]         # 004182c2
    add eax, 0x31f                               # 004182c8
    push eax                                     # 004182cd
    call FUN_0050ca3e                            # 004182ce
    add esp, 0xc                                 # 004182d3
    push 0x0                                     # 004182d6
    push 0x0                                     # 004182d8
    mov ecx, dword ptr [ebp - local_194]         # 004182da
    add ecx, 0x31f                               # 004182e0
    push ecx                                     # 004182e6
    call FUN_0052139c                            # 004182e7
    jmp.d32 L_00418e40                           # 004182ec
L_004182f1:
    # block 0x004182f1: entered by je at 0x004182b4, 6 instruction(s), ends with jne to 0x00418328 (forward)
    mov edi, 0x542764                            # 004182f1
    lea esi, [ebp - local_168]                   # 004182f6
    mov ecx, 0x14                                # 004182fc
    {load} xor edx, edx                          # 00418301
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00418303
    jne.d8 L_00418328                            # 00418305
    # block 0x00418307: entered by fall-through of jne at 0x00418305, 4 instruction(s), ends with jne to 0x00418328 (forward)
    mov eax, dword ptr [ebp - local_150]         # 00418307
    and eax, 0xffff                              # 0041830d
    cmp eax, 0x2                                 # 00418312
    jne.d8 L_00418328                            # 00418315
    # block 0x00418317: entered by fall-through of jne at 0x00418315, 4 instruction(s), ends with je to 0x0041833b (forward)
    mov ecx, dword ptr [ebp - local_14e]         # 00418317
    and ecx, 0xffff                              # 0041831d
    cmp ecx, 0x1                                 # 00418323
    je.d8 L_0041833b                             # 00418326
L_00418328:
    # block 0x00418328: entered by jne at 0x00418305; jne at 0x00418315; fall-through of je at 0x00418326, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e3b
    push 0x0                                     # 00418328
    push 0x0                                     # 0041832a
    push 0x542778                                # 0041832c
    call FUN_0052139c                            # 00418331
    jmp.d32 L_00418e3b                           # 00418336
L_0041833b:
    # block 0x0041833b: entered by je at 0x00418326, 36 instruction(s), ends with je to 0x004183ec (forward)
    mov edx, dword ptr [ebp + arg_10]            # 0041833b
    mov ax, word ptr [ebp - local_12c]           # 0041833e
    mov word ptr [edx + field_2b], ax            # 00418345
    mov ecx, dword ptr [ebp + arg_10]            # 00418349
    mov dx, word ptr [ebp - local_128]           # 0041834c
    mov word ptr [ecx + field_2d], dx            # 00418353
    mov eax, dword ptr [ebp + arg_10]            # 00418357
    mov cx, word ptr [ebp - local_12a]           # 0041835a
    mov word ptr [eax + field_2f], cx            # 00418361
    mov edx, dword ptr [ebp + arg_10]            # 00418365
    mov ax, word ptr [ebp - local_128]           # 00418368
    mov word ptr [edx + field_31], ax            # 0041836f
    mov ecx, dword ptr [ebp + arg_10]            # 00418373
    add ecx, 0x35                                # 00418376
    mov edx, dword ptr [ebp - local_14c]         # 00418379
    mov dword ptr [ecx], edx                     # 0041837f
    mov eax, dword ptr [ebp - local_148]         # 00418381
    mov dword ptr [ecx + field_4], eax           # 00418387
    mov edx, dword ptr [ebp - local_144]         # 0041838a
    mov dword ptr [ecx + field_8], edx           # 00418390
    mov eax, dword ptr [ebp - local_140]         # 00418393
    mov dword ptr [ecx + field_c], eax           # 00418399
    mov ecx, dword ptr [ebp + arg_10]            # 0041839c
    add ecx, 0x45                                # 0041839f
    mov edx, dword ptr [ebp - local_13c]         # 004183a2
    mov dword ptr [ecx], edx                     # 004183a8
    mov eax, dword ptr [ebp - local_138]         # 004183aa
    mov dword ptr [ecx + field_4], eax           # 004183b0
    mov edx, dword ptr [ebp - local_134]         # 004183b3
    mov dword ptr [ecx + field_8], edx           # 004183b9
    mov eax, dword ptr [ebp - local_130]         # 004183bc
    mov dword ptr [ecx + field_c], eax           # 004183c2
    mov cl, byte ptr [ebp - local_118]           # 004183c5
    mov byte ptr [ebp - local_198], cl           # 004183cb
    cmp byte ptr [ebp - local_198], 0x2          # 004183d1
    je.d8 L_004183ec                             # 004183d8
    # block 0x004183da: entered by fall-through of je at 0x004183d8, 2 instruction(s), ends with je to 0x00418524 (forward)
    cmp byte ptr [ebp - local_198], 0x3          # 004183da
    je.d32 L_00418524                            # 004183e1
    # block 0x004183e7: entered by fall-through of je at 0x004183e1, 1 instruction(s), ends with forward jump to 0x00418645
    jmp.d32 L_00418645                           # 004183e7
L_004183ec:
    # block 0x004183ec: entered by je at 0x004183d8, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418423 (forward)
    mov edx, dword ptr [ebp - local_11c]         # 004183ec
    push edx                                     # 004183f2
    call FUN_0051dc43                            # 004183f3
    add esp, 0x4                                 # 004183f8
    mov dword ptr [ebp - local_16c], eax         # 004183fb
    mov eax, dword ptr [ebp - local_16c]         # 00418401
    mov dword ptr [ebp - local_4], eax           # 00418407
    cmp dword ptr [ebp - local_4], 0x0           # 0041840a
    jne.d8 L_00418423                            # 0041840e
    # block 0x00418410: entered by fall-through of jne at 0x0041840e, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e36
    push 0x0                                     # 00418410
    push 0x0                                     # 00418412
    push 0x5427b0                                # 00418414
    call FUN_0052139c                            # 00418419
    jmp.d32 L_00418e36                           # 0041841e
L_00418423:
    # block 0x00418423: entered by jne at 0x0041840e, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041845f (forward)
    mov ecx, dword ptr [ebp - local_124]         # 00418423
    push ecx                                     # 00418429
    call FUN_0051dc43                            # 0041842a
    add esp, 0x4                                 # 0041842f
    mov dword ptr [ebp - local_170], eax         # 00418432
    mov edx, dword ptr [ebp + arg_10]            # 00418438
    mov eax, dword ptr [ebp - local_170]         # 0041843b
    mov dword ptr [edx], eax                     # 00418441
    cmp dword ptr [ebp - local_170], 0x0         # 00418443
    jne.d8 L_0041845f                            # 0041844a
    # block 0x0041844c: entered by fall-through of jne at 0x0041844a, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e31
    push 0x0                                     # 0041844c
    push 0x0                                     # 0041844e
    push 0x5427e4                                # 00418450
    call FUN_0052139c                            # 00418455
    jmp.d32 L_00418e31                           # 0041845a
L_0041845f:
    # block 0x0041845f: entered by jne at 0x0041844a, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x004184b8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041845f
    push ecx                                     # 00418462
    push 0x1                                     # 00418463
    mov edx, dword ptr [ebp - local_11c]         # 00418465
    push edx                                     # 0041846b
    mov eax, dword ptr [ebp - local_4]           # 0041846c
    push eax                                     # 0041846f
    call FUN_0050cf61                            # 00418470
    add esp, 0x10                                # 00418475
    cmp eax, 0x1                                 # 00418478
    je.d8 L_004184b8                             # 0041847b
    # block 0x0041847d: entered by fall-through of je at 0x0041847b, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e2c
    lea ecx, [ebp - local_114]                   # 0041847d
    push ecx                                     # 00418483
    push 0x54281c                                # 00418484
    mov edx, dword ptr [ebp - local_194]         # 00418489
    add edx, 0x31f                               # 0041848f
    push edx                                     # 00418495
    call FUN_0050ca3e                            # 00418496
    add esp, 0xc                                 # 0041849b
    push 0x0                                     # 0041849e
    push 0x0                                     # 004184a0
    mov eax, dword ptr [ebp - local_194]         # 004184a2
    add eax, 0x31f                               # 004184a8
    push eax                                     # 004184ad
    call FUN_0052139c                            # 004184ae
    jmp.d32 L_00418e2c                           # 004184b3
L_004184b8:
    # block 0x004184b8: entered by je at 0x0041847b, 31 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, ends with forward jump to 0x00418e2a
    mov ecx, dword ptr [ebp - local_124]         # 004184b8
    push ecx                                     # 004184be
    mov edx, dword ptr [ebp - local_11c]         # 004184bf
    push edx                                     # 004184c5
    mov eax, dword ptr [ebp + arg_10]            # 004184c6
    mov ecx, dword ptr [eax]                     # 004184c9
    push ecx                                     # 004184cb
    mov edx, dword ptr [ebp - local_4]           # 004184cc
    push edx                                     # 004184cf
    mov ecx, dword ptr [ebp - local_194]         # 004184d0
    add ecx, 0x51f                               # 004184d6
    call FUN_0041b6e2                            # 004184dc
    mov eax, dword ptr [ebp - local_8]           # 004184e1
    push eax                                     # 004184e4
    call FUN_0050cee4                            # 004184e5
    add esp, 0x4                                 # 004184ea
    mov ecx, dword ptr [ebp - local_124]         # 004184ed
    push ecx                                     # 004184f3
    mov edx, dword ptr [ebp + arg_10]            # 004184f4
    mov eax, dword ptr [edx]                     # 004184f7
    push eax                                     # 004184f9
    mov ecx, 0x5cf659                            # 004184fa
    call FUN_004c7314                            # 004184ff
    mov ecx, dword ptr [ebp + arg_10]            # 00418504
    mov edx, dword ptr [ebp - local_124]         # 00418507
    mov dword ptr [ecx + field_23], edx          # 0041850d
    mov eax, dword ptr [ebp - local_124]         # 00418510
    add eax, 0x59                                # 00418516
    mov ecx, dword ptr [ebp + arg_10]            # 00418519
    mov dword ptr [ecx + field_27], eax          # 0041851c
    jmp.d32 L_00418e2a                           # 0041851f
L_00418524:
    # block 0x00418524: entered by je at 0x004183e1, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041855b (forward)
    mov edx, dword ptr [ebp - local_11c]         # 00418524
    push edx                                     # 0041852a
    call FUN_0051dc43                            # 0041852b
    add esp, 0x4                                 # 00418530
    mov dword ptr [ebp - local_174], eax         # 00418533
    mov eax, dword ptr [ebp - local_174]         # 00418539
    mov dword ptr [ebp - local_4], eax           # 0041853f
    cmp dword ptr [ebp - local_4], 0x0           # 00418542
    jne.d8 L_0041855b                            # 00418546
    # block 0x00418548: entered by fall-through of jne at 0x00418546, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e28
    push 0x0                                     # 00418548
    push 0x0                                     # 0041854a
    push 0x54283c                                # 0041854c
    call FUN_0052139c                            # 00418551
    jmp.d32 L_00418e28                           # 00418556
L_0041855b:
    # block 0x0041855b: entered by jne at 0x00418546, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418597 (forward)
    mov ecx, dword ptr [ebp - local_124]         # 0041855b
    push ecx                                     # 00418561
    call FUN_0051dc43                            # 00418562
    add esp, 0x4                                 # 00418567
    mov dword ptr [ebp - local_178], eax         # 0041856a
    mov edx, dword ptr [ebp + arg_10]            # 00418570
    mov eax, dword ptr [ebp - local_178]         # 00418573
    mov dword ptr [edx], eax                     # 00418579
    cmp dword ptr [ebp - local_178], 0x0         # 0041857b
    jne.d8 L_00418597                            # 00418582
    # block 0x00418584: entered by fall-through of jne at 0x00418582, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e26
    push 0x0                                     # 00418584
    push 0x0                                     # 00418586
    push 0x542870                                # 00418588
    call FUN_0052139c                            # 0041858d
    jmp.d32 L_00418e26                           # 00418592
L_00418597:
    # block 0x00418597: entered by jne at 0x00418582, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x004185f0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00418597
    push ecx                                     # 0041859a
    push 0x1                                     # 0041859b
    mov edx, dword ptr [ebp - local_11c]         # 0041859d
    push edx                                     # 004185a3
    mov eax, dword ptr [ebp - local_4]           # 004185a4
    push eax                                     # 004185a7
    call FUN_0050cf61                            # 004185a8
    add esp, 0x10                                # 004185ad
    cmp eax, 0x1                                 # 004185b0
    je.d8 L_004185f0                             # 004185b3
    # block 0x004185b5: entered by fall-through of je at 0x004185b3, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e24
    lea ecx, [ebp - local_114]                   # 004185b5
    push ecx                                     # 004185bb
    push 0x5428a8                                # 004185bc
    mov edx, dword ptr [ebp - local_194]         # 004185c1
    add edx, 0x31f                               # 004185c7
    push edx                                     # 004185cd
    call FUN_0050ca3e                            # 004185ce
    add esp, 0xc                                 # 004185d3
    push 0x0                                     # 004185d6
    push 0x0                                     # 004185d8
    mov eax, dword ptr [ebp - local_194]         # 004185da
    add eax, 0x31f                               # 004185e0
    push eax                                     # 004185e5
    call FUN_0052139c                            # 004185e6
    jmp.d32 L_00418e24                           # 004185eb
L_004185f0:
    # block 0x004185f0: entered by je at 0x004185b3, 24 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, ends with forward jump to 0x00418e22
    mov ecx, dword ptr [ebp - local_124]         # 004185f0
    push ecx                                     # 004185f6
    mov edx, dword ptr [ebp - local_11c]         # 004185f7
    push edx                                     # 004185fd
    mov eax, dword ptr [ebp + arg_10]            # 004185fe
    mov ecx, dword ptr [eax]                     # 00418601
    push ecx                                     # 00418603
    mov edx, dword ptr [ebp - local_4]           # 00418604
    push edx                                     # 00418607
    mov ecx, dword ptr [ebp - local_194]         # 00418608
    add ecx, 0x51f                               # 0041860e
    call FUN_0041b6e2                            # 00418614
    mov eax, dword ptr [ebp - local_8]           # 00418619
    push eax                                     # 0041861c
    call FUN_0050cee4                            # 0041861d
    add esp, 0x4                                 # 00418622
    mov ecx, dword ptr [ebp + arg_10]            # 00418625
    mov edx, dword ptr [ebp - local_124]         # 00418628
    mov dword ptr [ecx + field_23], edx          # 0041862e
    mov eax, dword ptr [ebp - local_124]         # 00418631
    add eax, 0x59                                # 00418637
    mov ecx, dword ptr [ebp + arg_10]            # 0041863a
    mov dword ptr [ecx + field_27], eax          # 0041863d
    jmp.d32 L_00418e22                           # 00418640
L_00418645:
    # block 0x00418645: entered by je at 0x00418234; je at 0x0041827d; jmp at 0x004183e7, 10 instruction(s), calls FUN_0041a216, ends with jne to 0x004186ab (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00418645
    push edx                                     # 00418648
    mov ecx, dword ptr [ebp - local_194]         # 00418649
    call FUN_0041a216                            # 0041864f
    mov ecx, dword ptr [ebp - local_194]         # 00418654
    mov word ptr [ecx + field_571], ax           # 0041865a
    mov edx, dword ptr [ebp - local_194]         # 00418661
    movsx eax, word ptr [edx + field_571]        # 00418667
    cmp eax, -0x1                                # 0041866e
    jne.d8 L_004186ab                            # 00418671
    # block 0x00418673: entered by fall-through of jne at 0x00418671, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e20
    mov ecx, dword ptr [ebp + arg_8]             # 00418673
    push ecx                                     # 00418676
    push 0x5428c8                                # 00418677
    mov edx, dword ptr [ebp - local_194]         # 0041867c
    add edx, 0x31f                               # 00418682
    push edx                                     # 00418688
    call FUN_0050ca3e                            # 00418689
    add esp, 0xc                                 # 0041868e
    push 0x0                                     # 00418691
    push 0x0                                     # 00418693
    mov eax, dword ptr [ebp - local_194]         # 00418695
    add eax, 0x31f                               # 0041869b
    push eax                                     # 004186a0
    call FUN_0052139c                            # 004186a1
    jmp.d32 L_00418e20                           # 004186a6
L_004186ab:
    # block 0x004186ab: entered by jne at 0x00418671, 34 instruction(s), calls FUN_0041a19c, ends with jne to 0x0041879b (forward)
    mov ecx, dword ptr [ebp - local_194]         # 004186ab
    movsx edx, word ptr [ecx + field_571]        # 004186b1
    imul edx, edx, 0x84d                         # 004186b8
    mov eax, dword ptr [ebp - local_194]         # 004186be
    lea ecx, [eax + edx + field_57f]             # 004186c4
    mov edx, dword ptr [ebp - local_194]         # 004186cb
    mov dword ptr [edx + field_57b], ecx         # 004186d1
    mov eax, dword ptr [ebp - local_194]         # 004186d7
    movsx ecx, word ptr [eax + field_571]        # 004186dd
    imul ecx, ecx, 0x84d                         # 004186e4
    mov edx, dword ptr [ebp - local_194]         # 004186ea
    mov eax, dword ptr [ebp - local_194]         # 004186f0
    mov ecx, dword ptr [eax + ecx + field_5c0]   # 004186f6
    mov dword ptr [edx + field_577], ecx         # 004186fd
    mov edx, dword ptr [ebp - local_194]         # 00418703
    movsx eax, word ptr [edx + field_571]        # 00418709
    imul eax, eax, 0x84d                         # 00418710
    mov ecx, dword ptr [ebp - local_194]         # 00418716
    lea edx, [ecx + eax + field_5c4]             # 0041871c
    mov eax, dword ptr [ebp - local_194]         # 00418723
    mov dword ptr [eax + field_573], edx         # 00418729
    mov ecx, dword ptr [ebp + arg_c]             # 0041872f
    push ecx                                     # 00418732
    mov ecx, dword ptr [ebp - local_194]         # 00418733
    call FUN_0041a19c                            # 00418739
    mov word ptr [ebp - local_c], ax             # 0041873e
    movsx edx, word ptr [ebp - local_c]          # 00418742
    mov eax, dword ptr [ebp - local_194]         # 00418746
    mov ecx, dword ptr [eax + field_573]         # 0041874c
    mov dx, word ptr [ecx + 2*edx]               # 00418752
    mov word ptr [ebp - local_10], dx            # 00418756
    movsx eax, word ptr [ebp - local_10]         # 0041875a
    cmp eax, -0x1                                # 0041875e
    jne.d8 L_0041879b                            # 00418761
    # block 0x00418763: entered by fall-through of jne at 0x00418761, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e1e
    mov ecx, dword ptr [ebp + arg_c]             # 00418763
    push ecx                                     # 00418766
    push 0x542904                                # 00418767
    mov edx, dword ptr [ebp - local_194]         # 0041876c
    add edx, 0x31f                               # 00418772
    push edx                                     # 00418778
    call FUN_0050ca3e                            # 00418779
    add esp, 0xc                                 # 0041877e
    push 0x0                                     # 00418781
    push 0x0                                     # 00418783
    mov eax, dword ptr [ebp - local_194]         # 00418785
    add eax, 0x31f                               # 0041878b
    push eax                                     # 00418790
    call FUN_0052139c                            # 00418791
    jmp.d32 L_00418e1e                           # 00418796
L_0041879b:
    # block 0x0041879b: entered by jne at 0x00418761; jmp at 0x004188ab, 3 instruction(s), ends with je to 0x004188b0 (forward)
    mov ecx, 0x1                                 # 0041879b
    test ecx, ecx                                # 004187a0
    je.d32 L_004188b0                            # 004187a2
    # block 0x004187a8: entered by fall-through of je at 0x004187a2, 8 instruction(s), falls into the block at 0x004187cc
    mov edx, dword ptr [ebp + arg_c]             # 004187a8
    mov dword ptr [ebp - local_19c], edx         # 004187ab
    movsx eax, word ptr [ebp - local_10]         # 004187b1
    imul eax, eax, 0x5e                          # 004187b5
    mov ecx, dword ptr [ebp - local_194]         # 004187b8
    mov edx, dword ptr [ecx + field_577]         # 004187be
    {load} add edx, eax                          # 004187c4
    mov dword ptr [ebp - local_1a0], edx         # 004187c6
L_004187cc:
    # block 0x004187cc: entered by jne at 0x0041881c, 6 instruction(s), ends with jne to 0x0041882a (forward)
    mov eax, dword ptr [ebp - local_1a0]         # 004187cc
    mov cl, byte ptr [eax]                       # 004187d2
    mov byte ptr [ebp - local_1a1], cl           # 004187d4
    mov edx, dword ptr [ebp - local_19c]         # 004187da
    cmp cl, byte ptr [edx]                       # 004187e0
    jne.d8 L_0041882a                            # 004187e2
    # block 0x004187e4: entered by fall-through of jne at 0x004187e2, 2 instruction(s), ends with je to 0x0041881e (forward)
    cmp byte ptr [ebp - local_1a1], 0x0          # 004187e4
    je.d8 L_0041881e                             # 004187eb
    # block 0x004187ed: entered by fall-through of je at 0x004187eb, 6 instruction(s), ends with jne to 0x0041882a (forward)
    mov eax, dword ptr [ebp - local_1a0]         # 004187ed
    mov cl, byte ptr [eax + field_1]             # 004187f3
    mov byte ptr [ebp - local_1a2], cl           # 004187f6
    mov edx, dword ptr [ebp - local_19c]         # 004187fc
    cmp cl, byte ptr [edx + field_1]             # 00418802
    jne.d8 L_0041882a                            # 00418805
    # block 0x00418807: entered by fall-through of jne at 0x00418805, 4 instruction(s), ends with jne to 0x004187cc (backward)
    add dword ptr [ebp - local_1a0], 0x2         # 00418807
    add dword ptr [ebp - local_19c], 0x2         # 0041880e
    cmp byte ptr [ebp - local_1a2], 0x0          # 00418815
    jne.d8 L_004187cc                            # 0041881c
L_0041881e:
    # block 0x0041881e: entered by je at 0x004187eb; fall-through of jne at 0x0041881c, 2 instruction(s), ends with forward jump to 0x00418835
    mov dword ptr [ebp - local_1a8], 0x0         # 0041881e
    jmp.d8 L_00418835                            # 00418828
L_0041882a:
    # block 0x0041882a: entered by jne at 0x004187e2; jne at 0x00418805, 3 instruction(s), falls into the block at 0x00418835
    {load} sbb eax, eax                          # 0041882a
    sbb eax, -0x1                                # 0041882c
    mov dword ptr [ebp - local_1a8], eax         # 0041882f
L_00418835:
    # block 0x00418835: entered by jmp at 0x00418828, 4 instruction(s), ends with je to 0x004188a9 (forward)
    mov ecx, dword ptr [ebp - local_1a8]         # 00418835
    mov dword ptr [ebp - local_1ac], ecx         # 0041883b
    cmp dword ptr [ebp - local_1ac], 0x0         # 00418841
    je.d8 L_004188a9                             # 00418848
    # block 0x0041884a: entered by fall-through of je at 0x00418848, 9 instruction(s), ends with jne to 0x004188a7 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0041884a
    imul edx, edx, 0x5e                          # 0041884e
    mov eax, dword ptr [ebp - local_194]         # 00418851
    mov ecx, dword ptr [eax + field_577]         # 00418857
    mov dx, word ptr [ecx + edx + field_27]      # 0041885d
    mov word ptr [ebp - local_10], dx            # 00418862
    movsx eax, word ptr [ebp - local_10]         # 00418866
    cmp eax, -0x1                                # 0041886a
    jne.d8 L_004188a7                            # 0041886d
    # block 0x0041886f: entered by fall-through of jne at 0x0041886d, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e1c
    mov ecx, dword ptr [ebp + arg_c]             # 0041886f
    push ecx                                     # 00418872
    push 0x542934                                # 00418873
    mov edx, dword ptr [ebp - local_194]         # 00418878
    add edx, 0x31f                               # 0041887e
    push edx                                     # 00418884
    call FUN_0050ca3e                            # 00418885
    add esp, 0xc                                 # 0041888a
    push 0x0                                     # 0041888d
    push 0x0                                     # 0041888f
    mov eax, dword ptr [ebp - local_194]         # 00418891
    add eax, 0x31f                               # 00418897
    push eax                                     # 0041889c
    call FUN_0052139c                            # 0041889d
    jmp.d32 L_00418e1c                           # 004188a2
L_004188a7:
    # block 0x004188a7: entered by jne at 0x0041886d, 1 instruction(s), ends with forward jump to 0x004188ab
    jmp.d8 L_004188ab                            # 004188a7
L_004188a9:
    # block 0x004188a9: entered by je at 0x00418848, 1 instruction(s), ends with forward jump to 0x004188b0
    jmp.d8 L_004188b0                            # 004188a9
L_004188ab:
    # block 0x004188ab: entered by jmp at 0x004188a7, 1 instruction(s), ends with backward jump to 0x0041879b
    jmp.d32 L_0041879b                           # 004188ab
L_004188b0:
    # block 0x004188b0: entered by je at 0x004187a2; jmp at 0x004188a9, 66 instruction(s), ends with je to 0x004189ca (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004188b0
    imul ecx, ecx, 0x5e                          # 004188b4
    mov edx, dword ptr [ebp - local_194]         # 004188b7
    mov eax, dword ptr [edx + field_577]         # 004188bd
    mov edx, dword ptr [ebp + arg_10]            # 004188c3
    mov ax, word ptr [eax + ecx + field_49]      # 004188c6
    mov word ptr [edx + field_2b], ax            # 004188cb
    movsx ecx, word ptr [ebp - local_10]         # 004188cf
    imul ecx, ecx, 0x5e                          # 004188d3
    mov edx, dword ptr [ebp - local_194]         # 004188d6
    mov eax, dword ptr [edx + field_577]         # 004188dc
    mov edx, dword ptr [ebp + arg_10]            # 004188e2
    mov ax, word ptr [eax + ecx + field_4d]      # 004188e5
    mov word ptr [edx + field_2d], ax            # 004188ea
    movsx ecx, word ptr [ebp - local_10]         # 004188ee
    imul ecx, ecx, 0x5e                          # 004188f2
    mov edx, dword ptr [ebp - local_194]         # 004188f5
    mov eax, dword ptr [edx + field_577]         # 004188fb
    mov edx, dword ptr [ebp + arg_10]            # 00418901
    mov ax, word ptr [eax + ecx + field_4b]      # 00418904
    mov word ptr [edx + field_2f], ax            # 00418909
    movsx ecx, word ptr [ebp - local_10]         # 0041890d
    imul ecx, ecx, 0x5e                          # 00418911
    mov edx, dword ptr [ebp - local_194]         # 00418914
    mov eax, dword ptr [edx + field_577]         # 0041891a
    mov edx, dword ptr [ebp + arg_10]            # 00418920
    mov ax, word ptr [eax + ecx + field_4d]      # 00418923
    mov word ptr [edx + field_31], ax            # 00418928
    movsx ecx, word ptr [ebp - local_10]         # 0041892c
    imul ecx, ecx, 0x5e                          # 00418930
    mov edx, dword ptr [ebp - local_194]         # 00418933
    mov eax, dword ptr [edx + field_577]         # 00418939
    lea ecx, [eax + ecx + field_29]              # 0041893f
    mov edx, dword ptr [ebp + arg_10]            # 00418943
    add edx, 0x35                                # 00418946
    mov eax, dword ptr [ecx]                     # 00418949
    mov dword ptr [edx], eax                     # 0041894b
    mov eax, dword ptr [ecx + field_4]           # 0041894d
    mov dword ptr [edx + field_4], eax           # 00418950
    mov eax, dword ptr [ecx + field_8]           # 00418953
    mov dword ptr [edx + field_8], eax           # 00418956
    mov ecx, dword ptr [ecx + field_c]           # 00418959
    mov dword ptr [edx + field_c], ecx           # 0041895c
    movsx edx, word ptr [ebp - local_10]         # 0041895f
    imul edx, edx, 0x5e                          # 00418963
    mov eax, dword ptr [ebp - local_194]         # 00418966
    mov ecx, dword ptr [eax + field_577]         # 0041896c
    lea edx, [ecx + edx + field_39]              # 00418972
    mov eax, dword ptr [ebp + arg_10]            # 00418976
    add eax, 0x45                                # 00418979
    mov ecx, dword ptr [edx]                     # 0041897c
    mov dword ptr [eax], ecx                     # 0041897e
    mov ecx, dword ptr [edx + field_4]           # 00418980
    mov dword ptr [eax + field_4], ecx           # 00418983
    mov ecx, dword ptr [edx + field_8]           # 00418986
    mov dword ptr [eax + field_8], ecx           # 00418989
    mov edx, dword ptr [edx + field_c]           # 0041898c
    mov dword ptr [eax + field_c], edx           # 0041898f
    movsx eax, word ptr [ebp - local_10]         # 00418992
    imul eax, eax, 0x5e                          # 00418996
    mov ecx, dword ptr [ebp - local_194]         # 00418999
    mov edx, dword ptr [ecx + field_577]         # 0041899f
    mov al, byte ptr [edx + eax + field_5d]      # 004189a5
    mov byte ptr [ebp - local_1b0], al           # 004189a9
    cmp byte ptr [ebp - local_1b0], 0x2          # 004189af
    je.d8 L_004189ca                             # 004189b6
    # block 0x004189b8: entered by fall-through of je at 0x004189b6, 2 instruction(s), ends with je to 0x00418bd1 (forward)
    cmp byte ptr [ebp - local_1b0], 0x3          # 004189b8
    je.d32 L_00418bd1                            # 004189bf
    # block 0x004189c5: entered by fall-through of je at 0x004189bf, 1 instruction(s), ends with forward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 004189c5
L_004189ca:
    # block 0x004189ca: entered by je at 0x004189b6, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418a12 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004189ca
    imul ecx, ecx, 0x5e                          # 004189ce
    mov edx, dword ptr [ebp - local_194]         # 004189d1
    mov eax, dword ptr [edx + field_577]         # 004189d7
    mov ecx, dword ptr [eax + ecx + field_59]    # 004189dd
    push ecx                                     # 004189e1
    call FUN_0051dc43                            # 004189e2
    add esp, 0x4                                 # 004189e7
    mov dword ptr [ebp - local_17c], eax         # 004189ea
    mov edx, dword ptr [ebp - local_17c]         # 004189f0
    mov dword ptr [ebp - local_4], edx           # 004189f6
    cmp dword ptr [ebp - local_4], 0x0           # 004189f9
    jne.d8 L_00418a12                            # 004189fd
    # block 0x004189ff: entered by fall-through of jne at 0x004189fd, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e1a
    push 0x0                                     # 004189ff
    push 0x0                                     # 00418a01
    push 0x542964                                # 00418a03
    call FUN_0052139c                            # 00418a08
    jmp.d32 L_00418e1a                           # 00418a0d
L_00418a12:
    # block 0x00418a12: entered by jne at 0x004189fd, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418a5f (forward)
    movsx eax, word ptr [ebp - local_10]         # 00418a12
    imul eax, eax, 0x5e                          # 00418a16
    mov ecx, dword ptr [ebp - local_194]         # 00418a19
    mov edx, dword ptr [ecx + field_577]         # 00418a1f
    mov eax, dword ptr [edx + eax + field_51]    # 00418a25
    push eax                                     # 00418a29
    call FUN_0051dc43                            # 00418a2a
    add esp, 0x4                                 # 00418a2f
    mov dword ptr [ebp - local_180], eax         # 00418a32
    mov ecx, dword ptr [ebp + arg_10]            # 00418a38
    mov edx, dword ptr [ebp - local_180]         # 00418a3b
    mov dword ptr [ecx], edx                     # 00418a41
    cmp dword ptr [ebp - local_180], 0x0         # 00418a43
    jne.d8 L_00418a5f                            # 00418a4a
    # block 0x00418a4c: entered by fall-through of jne at 0x00418a4a, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e18
    push 0x0                                     # 00418a4c
    push 0x0                                     # 00418a4e
    push 0x542998                                # 00418a50
    call FUN_0052139c                            # 00418a55
    jmp.d32 L_00418e18                           # 00418a5a
L_00418a5f:
    # block 0x00418a5f: entered by jne at 0x00418a4a, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00418b1c (forward)
    push 0x0                                     # 00418a5f
    movsx eax, word ptr [ebp - local_10]         # 00418a61
    imul eax, eax, 0x5e                          # 00418a65
    mov ecx, dword ptr [ebp - local_194]         # 00418a68
    mov edx, dword ptr [ecx + field_577]         # 00418a6e
    mov eax, dword ptr [edx + eax + field_23]    # 00418a74
    push eax                                     # 00418a78
    mov ecx, dword ptr [ebp - local_194]         # 00418a79
    mov edx, dword ptr [ecx + field_57b]         # 00418a7f
    mov eax, dword ptr [edx + field_845]         # 00418a85
    push eax                                     # 00418a8b
    call FUN_0050ce2b                            # 00418a8c
    add esp, 0xc                                 # 00418a91
    mov ecx, dword ptr [ebp - local_194]         # 00418a94
    mov edx, dword ptr [ecx + field_57b]         # 00418a9a
    mov eax, dword ptr [edx + field_845]         # 00418aa0
    push eax                                     # 00418aa6
    push 0x1                                     # 00418aa7
    movsx ecx, word ptr [ebp - local_10]         # 00418aa9
    imul ecx, ecx, 0x5e                          # 00418aad
    mov edx, dword ptr [ebp - local_194]         # 00418ab0
    mov eax, dword ptr [edx + field_577]         # 00418ab6
    mov ecx, dword ptr [eax + ecx + field_59]    # 00418abc
    push ecx                                     # 00418ac0
    mov edx, dword ptr [ebp - local_4]           # 00418ac1
    push edx                                     # 00418ac4
    call FUN_0050cf61                            # 00418ac5
    add esp, 0x10                                # 00418aca
    cmp eax, 0x1                                 # 00418acd
    je.d8 L_00418b1c                             # 00418ad0
    # block 0x00418ad2: entered by fall-through of je at 0x00418ad0, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e16
    movsx eax, word ptr [ebp - local_10]         # 00418ad2
    imul eax, eax, 0x5e                          # 00418ad6
    mov ecx, dword ptr [ebp - local_194]         # 00418ad9
    mov edx, dword ptr [ecx + field_577]         # 00418adf
    {load} add edx, eax                          # 00418ae5
    push edx                                     # 00418ae7
    push 0x5429d0                                # 00418ae8
    mov eax, dword ptr [ebp - local_194]         # 00418aed
    add eax, 0x31f                               # 00418af3
    push eax                                     # 00418af8
    call FUN_0050ca3e                            # 00418af9
    add esp, 0xc                                 # 00418afe
    push 0x0                                     # 00418b01
    push 0x0                                     # 00418b03
    mov ecx, dword ptr [ebp - local_194]         # 00418b05
    add ecx, 0x31f                               # 00418b0b
    push ecx                                     # 00418b11
    call FUN_0052139c                            # 00418b12
    jmp.d32 L_00418e16                           # 00418b17
L_00418b1c:
    # block 0x00418b1c: entered by je at 0x00418ad0, 47 instruction(s), calls FUN_0041b6e2, FUN_004c7314, ends with forward jump to 0x00418e14
    movsx edx, word ptr [ebp - local_10]         # 00418b1c
    imul edx, edx, 0x5e                          # 00418b20
    mov eax, dword ptr [ebp - local_194]         # 00418b23
    mov ecx, dword ptr [eax + field_577]         # 00418b29
    mov edx, dword ptr [ecx + edx + field_51]    # 00418b2f
    push edx                                     # 00418b33
    movsx eax, word ptr [ebp - local_10]         # 00418b34
    imul eax, eax, 0x5e                          # 00418b38
    mov ecx, dword ptr [ebp - local_194]         # 00418b3b
    mov edx, dword ptr [ecx + field_577]         # 00418b41
    mov eax, dword ptr [edx + eax + field_59]    # 00418b47
    push eax                                     # 00418b4b
    mov ecx, dword ptr [ebp + arg_10]            # 00418b4c
    mov edx, dword ptr [ecx]                     # 00418b4f
    push edx                                     # 00418b51
    mov eax, dword ptr [ebp - local_4]           # 00418b52
    push eax                                     # 00418b55
    mov ecx, dword ptr [ebp - local_194]         # 00418b56
    add ecx, 0x51f                               # 00418b5c
    call FUN_0041b6e2                            # 00418b62
    movsx ecx, word ptr [ebp - local_10]         # 00418b67
    imul ecx, ecx, 0x5e                          # 00418b6b
    mov edx, dword ptr [ebp - local_194]         # 00418b6e
    mov eax, dword ptr [edx + field_577]         # 00418b74
    mov ecx, dword ptr [eax + ecx + field_51]    # 00418b7a
    push ecx                                     # 00418b7e
    mov edx, dword ptr [ebp + arg_10]            # 00418b7f
    mov eax, dword ptr [edx]                     # 00418b82
    push eax                                     # 00418b84
    mov ecx, 0x5cf659                            # 00418b85
    call FUN_004c7314                            # 00418b8a
    movsx ecx, word ptr [ebp - local_10]         # 00418b8f
    imul ecx, ecx, 0x5e                          # 00418b93
    mov edx, dword ptr [ebp - local_194]         # 00418b96
    mov eax, dword ptr [edx + field_577]         # 00418b9c
    mov edx, dword ptr [ebp + arg_10]            # 00418ba2
    mov eax, dword ptr [eax + ecx + field_51]    # 00418ba5
    mov dword ptr [edx + field_23], eax          # 00418ba9
    movsx ecx, word ptr [ebp - local_10]         # 00418bac
    imul ecx, ecx, 0x5e                          # 00418bb0
    mov edx, dword ptr [ebp - local_194]         # 00418bb3
    mov eax, dword ptr [edx + field_577]         # 00418bb9
    mov ecx, dword ptr [eax + ecx + field_51]    # 00418bbf
    add ecx, 0x59                                # 00418bc3
    mov edx, dword ptr [ebp + arg_10]            # 00418bc6
    mov dword ptr [edx + field_27], ecx          # 00418bc9
    jmp.d32 L_00418e14                           # 00418bcc
L_00418bd1:
    # block 0x00418bd1: entered by je at 0x004189bf, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418c19 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00418bd1
    imul eax, eax, 0x5e                          # 00418bd5
    mov ecx, dword ptr [ebp - local_194]         # 00418bd8
    mov edx, dword ptr [ecx + field_577]         # 00418bde
    mov eax, dword ptr [edx + eax + field_59]    # 00418be4
    push eax                                     # 00418be8
    call FUN_0051dc43                            # 00418be9
    add esp, 0x4                                 # 00418bee
    mov dword ptr [ebp - local_184], eax         # 00418bf1
    mov ecx, dword ptr [ebp - local_184]         # 00418bf7
    mov dword ptr [ebp - local_4], ecx           # 00418bfd
    cmp dword ptr [ebp - local_4], 0x0           # 00418c00
    jne.d8 L_00418c19                            # 00418c04
    # block 0x00418c06: entered by fall-through of jne at 0x00418c04, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e12
    push 0x0                                     # 00418c06
    push 0x0                                     # 00418c08
    push 0x5429f4                                # 00418c0a
    call FUN_0052139c                            # 00418c0f
    jmp.d32 L_00418e12                           # 00418c14
L_00418c19:
    # block 0x00418c19: entered by jne at 0x00418c04, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418c66 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00418c19
    imul edx, edx, 0x5e                          # 00418c1d
    mov eax, dword ptr [ebp - local_194]         # 00418c20
    mov ecx, dword ptr [eax + field_577]         # 00418c26
    mov edx, dword ptr [ecx + edx + field_51]    # 00418c2c
    push edx                                     # 00418c30
    call FUN_0051dc43                            # 00418c31
    add esp, 0x4                                 # 00418c36
    mov dword ptr [ebp - local_188], eax         # 00418c39
    mov eax, dword ptr [ebp + arg_10]            # 00418c3f
    mov ecx, dword ptr [ebp - local_188]         # 00418c42
    mov dword ptr [eax], ecx                     # 00418c48
    cmp dword ptr [ebp - local_188], 0x0         # 00418c4a
    jne.d8 L_00418c66                            # 00418c51
    # block 0x00418c53: entered by fall-through of jne at 0x00418c51, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00418e10
    push 0x0                                     # 00418c53
    push 0x0                                     # 00418c55
    push 0x542a28                                # 00418c57
    call FUN_0052139c                            # 00418c5c
    jmp.d32 L_00418e10                           # 00418c61
L_00418c66:
    # block 0x00418c66: entered by jne at 0x00418c51, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00418d23 (forward)
    push 0x0                                     # 00418c66
    movsx edx, word ptr [ebp - local_10]         # 00418c68
    imul edx, edx, 0x5e                          # 00418c6c
    mov eax, dword ptr [ebp - local_194]         # 00418c6f
    mov ecx, dword ptr [eax + field_577]         # 00418c75
    mov edx, dword ptr [ecx + edx + field_23]    # 00418c7b
    push edx                                     # 00418c7f
    mov eax, dword ptr [ebp - local_194]         # 00418c80
    mov ecx, dword ptr [eax + field_57b]         # 00418c86
    mov edx, dword ptr [ecx + field_845]         # 00418c8c
    push edx                                     # 00418c92
    call FUN_0050ce2b                            # 00418c93
    add esp, 0xc                                 # 00418c98
    mov eax, dword ptr [ebp - local_194]         # 00418c9b
    mov ecx, dword ptr [eax + field_57b]         # 00418ca1
    mov edx, dword ptr [ecx + field_845]         # 00418ca7
    push edx                                     # 00418cad
    push 0x1                                     # 00418cae
    movsx eax, word ptr [ebp - local_10]         # 00418cb0
    imul eax, eax, 0x5e                          # 00418cb4
    mov ecx, dword ptr [ebp - local_194]         # 00418cb7
    mov edx, dword ptr [ecx + field_577]         # 00418cbd
    mov eax, dword ptr [edx + eax + field_59]    # 00418cc3
    push eax                                     # 00418cc7
    mov ecx, dword ptr [ebp - local_4]           # 00418cc8
    push ecx                                     # 00418ccb
    call FUN_0050cf61                            # 00418ccc
    add esp, 0x10                                # 00418cd1
    cmp eax, 0x1                                 # 00418cd4
    je.d8 L_00418d23                             # 00418cd7
    # block 0x00418cd9: entered by fall-through of je at 0x00418cd7, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00418e0e
    movsx edx, word ptr [ebp - local_10]         # 00418cd9
    imul edx, edx, 0x5e                          # 00418cdd
    mov eax, dword ptr [ebp - local_194]         # 00418ce0
    mov ecx, dword ptr [eax + field_577]         # 00418ce6
    {load} add ecx, edx                          # 00418cec
    push ecx                                     # 00418cee
    push 0x542a60                                # 00418cef
    mov edx, dword ptr [ebp - local_194]         # 00418cf4
    add edx, 0x31f                               # 00418cfa
    push edx                                     # 00418d00
    call FUN_0050ca3e                            # 00418d01
    add esp, 0xc                                 # 00418d06
    push 0x0                                     # 00418d09
    push 0x0                                     # 00418d0b
    mov eax, dword ptr [ebp - local_194]         # 00418d0d
    add eax, 0x31f                               # 00418d13
    push eax                                     # 00418d18
    call FUN_0052139c                            # 00418d19
    jmp.d32 L_00418e0e                           # 00418d1e
L_00418d23:
    # block 0x00418d23: entered by je at 0x00418cd7, 36 instruction(s), calls FUN_0041b6e2, ends with forward jump to 0x00418e0c
    movsx ecx, word ptr [ebp - local_10]         # 00418d23
    imul ecx, ecx, 0x5e                          # 00418d27
    mov edx, dword ptr [ebp - local_194]         # 00418d2a
    mov eax, dword ptr [edx + field_577]         # 00418d30
    mov ecx, dword ptr [eax + ecx + field_51]    # 00418d36
    push ecx                                     # 00418d3a
    movsx edx, word ptr [ebp - local_10]         # 00418d3b
    imul edx, edx, 0x5e                          # 00418d3f
    mov eax, dword ptr [ebp - local_194]         # 00418d42
    mov ecx, dword ptr [eax + field_577]         # 00418d48
    mov edx, dword ptr [ecx + edx + field_59]    # 00418d4e
    push edx                                     # 00418d52
    mov eax, dword ptr [ebp + arg_10]            # 00418d53
    mov ecx, dword ptr [eax]                     # 00418d56
    push ecx                                     # 00418d58
    mov edx, dword ptr [ebp - local_4]           # 00418d59
    push edx                                     # 00418d5c
    mov ecx, dword ptr [ebp - local_194]         # 00418d5d
    add ecx, 0x51f                               # 00418d63
    call FUN_0041b6e2                            # 00418d69
    movsx eax, word ptr [ebp - local_10]         # 00418d6e
    imul eax, eax, 0x5e                          # 00418d72
    mov ecx, dword ptr [ebp - local_194]         # 00418d75
    mov edx, dword ptr [ecx + field_577]         # 00418d7b
    mov ecx, dword ptr [ebp + arg_10]            # 00418d81
    mov edx, dword ptr [edx + eax + field_51]    # 00418d84
    mov dword ptr [ecx + field_23], edx          # 00418d88
    movsx eax, word ptr [ebp - local_10]         # 00418d8b
    imul eax, eax, 0x5e                          # 00418d8f
    mov ecx, dword ptr [ebp - local_194]         # 00418d92
    mov edx, dword ptr [ecx + field_577]         # 00418d98
    mov eax, dword ptr [edx + eax + field_51]    # 00418d9e
    add eax, 0x59                                # 00418da2
    mov ecx, dword ptr [ebp + arg_10]            # 00418da5
    mov dword ptr [ecx + field_27], eax          # 00418da8
    jmp.d8 L_00418e0c                            # 00418dab
L_00418dad:
    # block 0x00418dad: entered by jmp at 0x004189c5; jmp at 0x00418e0e; jmp at 0x00418e10; jmp at 0x00418e12; more, 3 instruction(s), ends with je to 0x00418dd8 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 00418dad
    cmp dword ptr [edx], 0x0                     # 00418db0
    je.d8 L_00418dd8                             # 00418db3
    # block 0x00418db5: entered by fall-through of je at 0x00418db3, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00418dd8
    mov eax, dword ptr [ebp + arg_10]            # 00418db5
    mov ecx, dword ptr [eax]                     # 00418db8
    mov dword ptr [ebp - local_18c], ecx         # 00418dba
    mov edx, dword ptr [ebp - local_18c]         # 00418dc0
    push edx                                     # 00418dc6
    call FUN_0051dc6c                            # 00418dc7
    add esp, 0x4                                 # 00418dcc
    mov eax, dword ptr [ebp + arg_10]            # 00418dcf
    mov dword ptr [eax], 0x0                     # 00418dd2
L_00418dd8:
    # block 0x00418dd8: entered by je at 0x00418db3, 5 instruction(s), falls into the block at 0x00418de5
    mov ecx, 0x16                                # 00418dd8
    {load} xor eax, eax                          # 00418ddd
    mov edi, dword ptr [ebp + arg_10]            # 00418ddf
    rep stosd dword ptr es:[edi], eax            # 00418de2
    stosb byte ptr es:[edi], al                  # 00418de4
L_00418de5:
    # block 0x00418de5: entered by jmp at 0x00418e0c; jmp at 0x00418e14; jmp at 0x00418e22; jmp at 0x00418e2a, 2 instruction(s), ends with je to 0x00418e0a (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00418de5
    je.d8 L_00418e0a                             # 00418de9
    # block 0x00418deb: entered by fall-through of je at 0x00418de9, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00418e0a
    mov ecx, dword ptr [ebp - local_4]           # 00418deb
    mov dword ptr [ebp - local_190], ecx         # 00418dee
    mov edx, dword ptr [ebp - local_190]         # 00418df4
    push edx                                     # 00418dfa
    call FUN_0051dc6c                            # 00418dfb
    add esp, 0x4                                 # 00418e00
    mov dword ptr [ebp - local_4], 0x0           # 00418e03
L_00418e0a:
    # block 0x00418e0a: entered by je at 0x00418de9, 1 instruction(s), ends with forward jump to 0x00418e4a
    jmp.d8 L_00418e4a                            # 00418e0a
L_00418e0c:
    # block 0x00418e0c: entered by jmp at 0x00418dab, 1 instruction(s), ends with backward jump to 0x00418de5
    jmp.d8 L_00418de5                            # 00418e0c
L_00418e0e:
    # block 0x00418e0e: entered by jmp at 0x00418d1e, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e0e
L_00418e10:
    # block 0x00418e10: entered by jmp at 0x00418c61, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e10
L_00418e12:
    # block 0x00418e12: entered by jmp at 0x00418c14, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e12
L_00418e14:
    # block 0x00418e14: entered by jmp at 0x00418bcc, 1 instruction(s), ends with backward jump to 0x00418de5
    jmp.d8 L_00418de5                            # 00418e14
L_00418e16:
    # block 0x00418e16: entered by jmp at 0x00418b17, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e16
L_00418e18:
    # block 0x00418e18: entered by jmp at 0x00418a5a, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e18
L_00418e1a:
    # block 0x00418e1a: entered by jmp at 0x00418a0d, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e1a
L_00418e1c:
    # block 0x00418e1c: entered by jmp at 0x004188a2, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e1c
L_00418e1e:
    # block 0x00418e1e: entered by jmp at 0x00418796, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e1e
L_00418e20:
    # block 0x00418e20: entered by jmp at 0x004186a6, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e20
L_00418e22:
    # block 0x00418e22: entered by jmp at 0x00418640, 1 instruction(s), ends with backward jump to 0x00418de5
    jmp.d8 L_00418de5                            # 00418e22
L_00418e24:
    # block 0x00418e24: entered by jmp at 0x004185eb, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e24
L_00418e26:
    # block 0x00418e26: entered by jmp at 0x00418592, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e26
L_00418e28:
    # block 0x00418e28: entered by jmp at 0x00418556, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d8 L_00418dad                            # 00418e28
L_00418e2a:
    # block 0x00418e2a: entered by jmp at 0x0041851f, 1 instruction(s), ends with backward jump to 0x00418de5
    jmp.d8 L_00418de5                            # 00418e2a
L_00418e2c:
    # block 0x00418e2c: entered by jmp at 0x004184b3, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e2c
L_00418e31:
    # block 0x00418e31: entered by jmp at 0x0041845a, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e31
L_00418e36:
    # block 0x00418e36: entered by jmp at 0x0041841e, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e36
L_00418e3b:
    # block 0x00418e3b: entered by jmp at 0x00418336, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e3b
L_00418e40:
    # block 0x00418e40: entered by jmp at 0x004182ec, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e40
L_00418e45:
    # block 0x00418e45: entered by jmp at 0x00418228, 1 instruction(s), ends with backward jump to 0x00418dad
    jmp.d32 L_00418dad                           # 00418e45
L_00418e4a:
    # block 0x00418e4a: entered by jmp at 0x00418e0a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00418e4a
    pop esi                                      # 00418e4b
    {load} mov esp, ebp                          # 00418e4c
    pop ebp                                      # 00418e4e
    ret 0xc                                      # 00418e4f

