# FUN_0044efcd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044efcd
# extent:       0x0044efcd-0x0044f4ea (1309 code bytes)
# span:         0x0044efcd-0x0044f4ea (code 1309, tables 0, padding 0)
# sha256:       539b628853614ed85eaf0a5ce418042bcc436b12458c22a6ac0db433d59710c9
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044efcd
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1c, field_1e, field_24, field_26, field_2c, field_6b, field_224, field_22c, field_242, field_248, field_254, field_256; [ecx + n] field_1c, field_1e, field_20, field_21, field_23, field_2c, field_63, field_67, field_222, field_228, field_234, field_240 and 3 more; [edx + n] field_1c, field_1e, field_28, field_220, field_226, field_230, field_240, field_244, field_24c, field_256
# callees:      calls FUN_004e8d96, FUN_0044e816, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_0044e9ae, FUN_004fba69, FUN_0042ba3a, FUN_0044e78e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 311 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_63, 0x63  # offset +0x63
.equ field_67, 0x67  # offset +0x67
.equ field_6b, 0x6b  # offset +0x6b
.equ field_220, 0x220  # offset +0x220
.equ field_222, 0x222  # offset +0x222
.equ field_224, 0x224  # offset +0x224
.equ field_226, 0x226  # offset +0x226
.equ field_228, 0x228  # offset +0x228
.equ field_22c, 0x22c  # offset +0x22c
.equ field_230, 0x230  # offset +0x230
.equ field_234, 0x234  # offset +0x234
.equ field_240, 0x240  # offset +0x240
.equ field_242, 0x242  # offset +0x242
.equ field_244, 0x244  # offset +0x244
.equ field_246, 0x246  # offset +0x246
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254
.equ field_256, 0x256  # offset +0x256
.equ field_258, 0x258  # offset +0x258

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044e78e, .text + (0x0044e78e - 0x401000)
.set FUN_0044e816, .text + (0x0044e816 - 0x401000)
.set FUN_0044e9ae, .text + (0x0044e9ae - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0044efcd - 0x401000
.globl FUN_0044efcd
FUN_0044efcd:
    # block 0x0044efcd: entry, 16 instruction(s), ends with je to 0x0044f01d (forward)
    push ebp                                     # 0044efcd
    {load} mov ebp, esp                          # 0044efce
    sub esp, 0x10                                # 0044efd0
    push esi                                     # 0044efd3
    push edi                                     # 0044efd4
    mov dword ptr [ebp - local_8], ecx           # 0044efd5
    movsx eax, word ptr [ebp + arg_8]            # 0044efd8
    imul eax, eax, 0x8d                          # 0044efdc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044efe2
    mov dword ptr [ebp - local_4], ecx           # 0044efe8
    movsx edx, word ptr [ebp + arg_8]            # 0044efeb
    imul edx, edx, 0x8d                          # 0044efef
    mov eax, dword ptr [edx + 0x5bb632]          # 0044eff5
    mov dword ptr [ebp - local_c], eax           # 0044effb
    cmp dword ptr [ebp - local_c], 0x0           # 0044effe
    je.d8 L_0044f01d                             # 0044f002
    # block 0x0044f004: entered by fall-through of je at 0x0044f002, 2 instruction(s), ends with je to 0x0044f247 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 0044f004
    je.d32 L_0044f247                            # 0044f008
    # block 0x0044f00e: entered by fall-through of je at 0x0044f008, 2 instruction(s), ends with je to 0x0044f2b1 (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 0044f00e
    je.d32 L_0044f2b1                            # 0044f012
    # block 0x0044f018: entered by fall-through of je at 0x0044f012, 1 instruction(s), ends with forward jump to 0x0044f4e2
    jmp.d32 L_0044f4e2                           # 0044f018
L_0044f01d:
    # block 0x0044f01d: entered by je at 0x0044f002, 85 instruction(s), calls FUN_004e8d96, FUN_0044e816, FUN_004d39f9, ends with jne to 0x0044f1a7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044f01d
    mov dx, word ptr [ebp + arg_8]               # 0044f020
    mov word ptr [ecx + field_1e], dx            # 0044f024
    mov eax, dword ptr [ebp - local_8]           # 0044f028
    mov dword ptr [eax + field_6b], 0x1          # 0044f02b
    mov dword ptr [0x5bb1ca], 0x1                # 0044f032
    mov ecx, 0x571442                            # 0044f03c
    call FUN_004e8d96                            # 0044f041
    mov ecx, dword ptr [ebp - local_8]           # 0044f046
    mov dword ptr [ecx + field_67], 0x0          # 0044f049
    mov edx, dword ptr [ebp - local_8]           # 0044f050
    mov dword ptr [edx + field_28], 0x0          # 0044f053
    mov eax, dword ptr [ebp - local_8]           # 0044f05a
    mov ecx, dword ptr [ebp - local_4]           # 0044f05d
    mov dx, word ptr [ecx + field_21]            # 0044f060
    mov word ptr [eax + field_24], dx            # 0044f064
    mov eax, dword ptr [ebp - local_8]           # 0044f068
    mov ecx, dword ptr [ebp - local_4]           # 0044f06b
    mov dx, word ptr [ecx + field_23]            # 0044f06e
    mov word ptr [eax + field_26], dx            # 0044f072
    mov ecx, dword ptr [ebp - local_8]           # 0044f076
    call FUN_0044e816                            # 0044f079
    mov eax, dword ptr [ebp - local_8]           # 0044f07e
    mov dword ptr [eax + field_2c], 0x0          # 0044f081
    mov ecx, dword ptr [ebp - local_8]           # 0044f088
    movsx edx, word ptr [ecx + field_1e]         # 0044f08b
    imul edx, edx, 0x8d                          # 0044f08f
    mov dword ptr [edx + 0x5bb632], 0x1          # 0044f095
    call FUN_004d39f9                            # 0044f09f
    mov ecx, dword ptr [ebp - local_8]           # 0044f0a4
    mov word ptr [ecx + field_1c], ax            # 0044f0a7
    mov edx, dword ptr [ebp - local_8]           # 0044f0ab
    movsx eax, word ptr [edx + field_1c]         # 0044f0ae
    imul eax, eax, 0x4a                          # 0044f0b2
    mov dword ptr [eax + 0x5d1591], 0xa          # 0044f0b5
    mov ecx, dword ptr [ebp - local_8]           # 0044f0bf
    movsx edx, word ptr [ecx + field_1c]         # 0044f0c2
    imul edx, edx, 0x4a                          # 0044f0c6
    mov dword ptr [edx + 0x5d1595], 0x44f4fa     # 0044f0c9
    mov eax, dword ptr [ebp - local_8]           # 0044f0d3
    movsx ecx, word ptr [eax + field_1c]         # 0044f0d6
    imul ecx, ecx, 0x4a                          # 0044f0da
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0044f0dd
    mov edx, dword ptr [ebp - local_8]           # 0044f0e7
    movsx eax, word ptr [edx + field_1c]         # 0044f0ea
    imul eax, eax, 0x4a                          # 0044f0ee
    mov dword ptr [eax + 0x5d159d], 0x0          # 0044f0f1
    mov ecx, dword ptr [ebp - local_8]           # 0044f0fb
    movsx edx, word ptr [ecx + field_1c]         # 0044f0fe
    imul edx, edx, 0x4a                          # 0044f102
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0044f105
    mov eax, dword ptr [ebp - local_8]           # 0044f10f
    movsx ecx, word ptr [eax + field_1c]         # 0044f112
    imul ecx, ecx, 0x4a                          # 0044f116
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0044f119
    mov edx, dword ptr [ebp - local_8]           # 0044f123
    movsx eax, word ptr [edx + field_1c]         # 0044f126
    imul eax, eax, 0x4a                          # 0044f12a
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0044f12d
    mov ecx, dword ptr [ebp - local_8]           # 0044f137
    movsx edx, word ptr [ecx + field_1c]         # 0044f13a
    imul edx, edx, 0x4a                          # 0044f13e
    mov word ptr [edx + 0x5d15ad], 0x0           # 0044f141
    mov edi, 0x549830                            # 0044f14a
    mov eax, dword ptr [ebp - local_8]           # 0044f14f
    movsx ecx, word ptr [eax + field_1c]         # 0044f152
    imul ecx, ecx, 0x4a                          # 0044f156
    add ecx, 0x5d15b3                            # 0044f159
    {load} mov edx, ecx                          # 0044f15f
    or ecx, -0x1                                 # 0044f161
    {load} xor eax, eax                          # 0044f164
    repne scasb al, byte ptr es:[edi]            # 0044f166
    not ecx                                      # 0044f168
    {load} sub edi, ecx                          # 0044f16a
    {load} mov esi, edi                          # 0044f16c
    {load} mov eax, ecx                          # 0044f16e
    {load} mov edi, edx                          # 0044f170
    shr ecx, 0x2                                 # 0044f172
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044f175
    {load} mov ecx, eax                          # 0044f177
    and ecx, 0x3                                 # 0044f179
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044f17c
    mov ecx, dword ptr [ebp - local_8]           # 0044f17e
    cmp dword ptr [ecx + field_20], 0x0          # 0044f181
    jne.d8 L_0044f1a7                            # 0044f185
    # block 0x0044f187: entered by fall-through of jne at 0x0044f185, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0044f1a7
    push 0x54984c                                # 0044f187
    push 0x6                                     # 0044f18c
    mov edx, dword ptr [ebp - local_4]           # 0044f18e
    push edx                                     # 0044f191
    push 0x549868                                # 0044f192
    mov ecx, 0x5cf659                            # 0044f197
    call FUN_004c2790                            # 0044f19c
    mov ecx, dword ptr [ebp - local_8]           # 0044f1a1
    mov dword ptr [ecx + field_20], eax          # 0044f1a4
L_0044f1a7:
    # block 0x0044f1a7: entered by jne at 0x0044f185, 13 instruction(s), ends with je to 0x0044f1ea (forward)
    mov edx, dword ptr [ebp - local_8]           # 0044f1a7
    movsx eax, word ptr [edx + field_1c]         # 0044f1aa
    imul eax, eax, 0x4a                          # 0044f1ae
    mov ecx, dword ptr [ebp - local_8]           # 0044f1b1
    mov edx, dword ptr [ecx + field_20]          # 0044f1b4
    mov dword ptr [eax + 0x5d1599], edx          # 0044f1b7
    mov edi, 0x549870                            # 0044f1bd
    mov esi, dword ptr [ebp - local_4]           # 0044f1c2
    add esi, 0x1be                               # 0044f1c5
    mov ecx, 0x9                                 # 0044f1cb
    {load} xor eax, eax                          # 0044f1d0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f1d2
    je.d8 L_0044f1ea                             # 0044f1d4
    # block 0x0044f1d6: entered by fall-through of je at 0x0044f1d4, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0044f1ea
    mov ecx, dword ptr [ebp - local_4]           # 0044f1d6
    add ecx, 0x1be                               # 0044f1d9
    push ecx                                     # 0044f1df
    mov ecx, 0x5c3a67                            # 0044f1e0
    call FUN_004fb77a                            # 0044f1e5
L_0044f1ea:
    # block 0x0044f1ea: entered by je at 0x0044f1d4, 7 instruction(s), ends with je to 0x0044f216 (forward)
    mov edi, 0x54987c                            # 0044f1ea
    mov esi, dword ptr [ebp - local_4]           # 0044f1ef
    add esi, 0x18d                               # 0044f1f2
    mov ecx, 0x9                                 # 0044f1f8
    {load} xor edx, edx                          # 0044f1fd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f1ff
    je.d8 L_0044f216                             # 0044f201
    # block 0x0044f203: entered by fall-through of je at 0x0044f201, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0044f216
    mov eax, dword ptr [ebp - local_4]           # 0044f203
    add eax, 0x18d                               # 0044f206
    push eax                                     # 0044f20b
    mov ecx, 0x5c3a67                            # 0044f20c
    call FUN_004fb77a                            # 0044f211
L_0044f216:
    # block 0x0044f216: entered by je at 0x0044f201, 7 instruction(s), ends with je to 0x0044f242 (forward)
    mov edi, 0x549888                            # 0044f216
    mov esi, dword ptr [ebp - local_4]           # 0044f21b
    add esi, 0x1ef                               # 0044f21e
    mov ecx, 0x9                                 # 0044f224
    {load} xor edx, edx                          # 0044f229
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f22b
    je.d8 L_0044f242                             # 0044f22d
    # block 0x0044f22f: entered by fall-through of je at 0x0044f22d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0044f242
    mov eax, dword ptr [ebp - local_4]           # 0044f22f
    add eax, 0x1ef                               # 0044f232
    push eax                                     # 0044f237
    mov ecx, 0x5c3a67                            # 0044f238
    call FUN_004fb77a                            # 0044f23d
L_0044f242:
    # block 0x0044f242: entered by je at 0x0044f22d, 1 instruction(s), ends with forward jump to 0x0044f4e2
    jmp.d32 L_0044f4e2                           # 0044f242
L_0044f247:
    # block 0x0044f247: entered by je at 0x0044f008, 5 instruction(s), ends with je to 0x0044f25e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044f247
    mov edx, dword ptr [ecx + field_2c]          # 0044f24a
    mov dword ptr [ebp - local_10], edx          # 0044f24d
    cmp dword ptr [ebp - local_10], 0x1          # 0044f250
    je.d8 L_0044f25e                             # 0044f254
    # block 0x0044f256: entered by fall-through of je at 0x0044f254, 2 instruction(s), ends with je to 0x0044f28d (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0044f256
    je.d8 L_0044f28d                             # 0044f25a
    # block 0x0044f25c: entered by fall-through of je at 0x0044f25a, 1 instruction(s), ends with forward jump to 0x0044f2ac
    jmp.d8 L_0044f2ac                            # 0044f25c
L_0044f25e:
    # block 0x0044f25e: entered by je at 0x0044f254, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0044f28b (forward)
    call dword ptr [0x52a23c]                    # 0044f25e
    mov ecx, dword ptr [ebp - local_8]           # 0044f264
    cmp eax, dword ptr [ecx + field_63]          # 0044f267
    jb.d8 L_0044f28b                             # 0044f26a
    # block 0x0044f26c: entered by fall-through of jb at 0x0044f26a, 3 instruction(s), ends with jne to 0x0044f281 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0044f26c
    cmp dword ptr [edx + field_28], 0x0          # 0044f26f
    jne.d8 L_0044f281                            # 0044f273
    # block 0x0044f275: entered by fall-through of jne at 0x0044f273, 3 instruction(s), ends with forward jump to 0x0044f28b
    mov eax, dword ptr [ebp - local_8]           # 0044f275
    mov dword ptr [eax + field_2c], 0x0          # 0044f278
    jmp.d8 L_0044f28b                            # 0044f27f
L_0044f281:
    # block 0x0044f281: entered by jne at 0x0044f273, 2 instruction(s), falls into the block at 0x0044f28b
    mov ecx, dword ptr [ebp - local_8]           # 0044f281
    mov dword ptr [ecx + field_2c], 0x2          # 0044f284
L_0044f28b:
    # block 0x0044f28b: entered by jb at 0x0044f26a; jmp at 0x0044f27f, 1 instruction(s), ends with forward jump to 0x0044f2ac
    jmp.d8 L_0044f2ac                            # 0044f28b
L_0044f28d:
    # block 0x0044f28d: entered by je at 0x0044f25a, 6 instruction(s), calls FUN_0044e9ae, falls into the block at 0x0044f2ac
    mov ecx, dword ptr [ebp - local_8]           # 0044f28d
    call FUN_0044e9ae                            # 0044f290
    mov edx, dword ptr [ebp - local_8]           # 0044f295
    movsx eax, word ptr [edx + field_1e]         # 0044f298
    imul eax, eax, 0x8d                          # 0044f29c
    mov dword ptr [eax + 0x5bb632], 0x2          # 0044f2a2
L_0044f2ac:
    # block 0x0044f2ac: entered by jmp at 0x0044f25c; jmp at 0x0044f28b, 1 instruction(s), ends with forward jump to 0x0044f4e2
    jmp.d32 L_0044f4e2                           # 0044f2ac
L_0044f2b1:
    # block 0x0044f2b1: entered by je at 0x0044f012, 8 instruction(s), ends with je to 0x0044f2e7 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0044f2b1
    mov edi, 0x549894                            # 0044f2bb
    mov esi, dword ptr [ebp - local_4]           # 0044f2c0
    add esi, 0x1be                               # 0044f2c3
    mov ecx, 0x9                                 # 0044f2c9
    {load} xor edx, edx                          # 0044f2ce
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f2d0
    je.d8 L_0044f2e7                             # 0044f2d2
    # block 0x0044f2d4: entered by fall-through of je at 0x0044f2d2, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0044f2e7
    mov eax, dword ptr [ebp - local_4]           # 0044f2d4
    add eax, 0x1be                               # 0044f2d7
    push eax                                     # 0044f2dc
    mov ecx, 0x5c3a67                            # 0044f2dd
    call FUN_004fba69                            # 0044f2e2
L_0044f2e7:
    # block 0x0044f2e7: entered by je at 0x0044f2d2, 7 instruction(s), ends with je to 0x0044f313 (forward)
    mov edi, 0x5498a0                            # 0044f2e7
    mov esi, dword ptr [ebp - local_4]           # 0044f2ec
    add esi, 0x18d                               # 0044f2ef
    mov ecx, 0x9                                 # 0044f2f5
    {load} xor edx, edx                          # 0044f2fa
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f2fc
    je.d8 L_0044f313                             # 0044f2fe
    # block 0x0044f300: entered by fall-through of je at 0x0044f2fe, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0044f313
    mov eax, dword ptr [ebp - local_4]           # 0044f300
    add eax, 0x18d                               # 0044f303
    push eax                                     # 0044f308
    mov ecx, 0x5c3a67                            # 0044f309
    call FUN_004fba69                            # 0044f30e
L_0044f313:
    # block 0x0044f313: entered by je at 0x0044f2fe, 7 instruction(s), ends with je to 0x0044f33f (forward)
    mov edi, 0x5498ac                            # 0044f313
    mov esi, dword ptr [ebp - local_4]           # 0044f318
    add esi, 0x1ef                               # 0044f31b
    mov ecx, 0x9                                 # 0044f321
    {load} xor edx, edx                          # 0044f326
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044f328
    je.d8 L_0044f33f                             # 0044f32a
    # block 0x0044f32c: entered by fall-through of je at 0x0044f32a, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0044f33f
    mov eax, dword ptr [ebp - local_4]           # 0044f32c
    add eax, 0x1ef                               # 0044f32f
    push eax                                     # 0044f334
    mov ecx, 0x5c3a67                            # 0044f335
    call FUN_004fba69                            # 0044f33a
L_0044f33f:
    # block 0x0044f33f: entered by je at 0x0044f32a, 3 instruction(s), ends with je to 0x0044f42e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044f33f
    cmp dword ptr [ecx + field_67], 0x0          # 0044f342
    je.d32 L_0044f42e                            # 0044f346
    # block 0x0044f34c: entered by fall-through of je at 0x0044f346, 4 instruction(s), ends with je to 0x0044f3fe (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044f34c
    movsx eax, word ptr [edx + field_240]        # 0044f34f
    cmp eax, 0x270f                              # 0044f356
    je.d32 L_0044f3fe                            # 0044f35b
    # block 0x0044f361: entered by fall-through of je at 0x0044f35b, 25 instruction(s), ends with jne to 0x0044f3ea (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044f361
    movsx edx, word ptr [ecx + field_240]        # 0044f364
    mov dword ptr [0x5bb57b], edx                # 0044f36b
    mov eax, dword ptr [ebp - local_4]           # 0044f371
    mov cx, word ptr [eax + field_242]           # 0044f374
    mov word ptr [0x5bb599], cx                  # 0044f37b
    mov edx, dword ptr [ebp - local_4]           # 0044f382
    mov ax, word ptr [edx + field_244]           # 0044f385
    mov word ptr [0x5bb595], ax                  # 0044f38c
    mov ecx, dword ptr [ebp - local_4]           # 0044f392
    mov dx, word ptr [ecx + field_246]           # 0044f395
    mov word ptr [0x5c39ff], dx                  # 0044f39c
    mov eax, dword ptr [ebp - local_4]           # 0044f3a3
    mov ecx, dword ptr [eax + field_248]         # 0044f3a6
    mov dword ptr [0x5bb59b], ecx                # 0044f3ac
    mov edx, dword ptr [ebp - local_4]           # 0044f3b2
    mov eax, dword ptr [edx + field_24c]         # 0044f3b5
    mov dword ptr [0x5bb59f], eax                # 0044f3bb
    mov ecx, dword ptr [ebp - local_4]           # 0044f3c0
    mov edx, dword ptr [ecx + field_250]         # 0044f3c3
    mov dword ptr [0x5bb5a3], edx                # 0044f3c9
    mov eax, dword ptr [ebp - local_4]           # 0044f3cf
    movsx ecx, word ptr [eax + field_254]        # 0044f3d2
    cmp ecx, 0x1                                 # 0044f3d9
    jne.d8 L_0044f3ea                            # 0044f3dc
    # block 0x0044f3de: entered by fall-through of jne at 0x0044f3dc, 2 instruction(s), ends with forward jump to 0x0044f3f4
    mov dword ptr [0x5bb1ca], 0x0                # 0044f3de
    jmp.d8 L_0044f3f4                            # 0044f3e8
L_0044f3ea:
    # block 0x0044f3ea: entered by jne at 0x0044f3dc, 1 instruction(s), falls into the block at 0x0044f3f4
    mov dword ptr [0x5bb1ca], 0x1                # 0044f3ea
L_0044f3f4:
    # block 0x0044f3f4: entered by jmp at 0x0044f3e8, 1 instruction(s), falls into the block at 0x0044f3fe
    mov dword ptr [0x583999], 0x4                # 0044f3f4
L_0044f3fe:
    # block 0x0044f3fe: entered by je at 0x0044f35b, 4 instruction(s), ends with je to 0x0044f429 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044f3fe
    movsx eax, word ptr [edx + field_256]        # 0044f401
    cmp eax, -0x1                                # 0044f408
    je.d8 L_0044f429                             # 0044f40b
    # block 0x0044f40d: entered by fall-through of je at 0x0044f40b, 6 instruction(s), falls into the block at 0x0044f429
    mov ecx, dword ptr [ebp - local_4]           # 0044f40d
    {load} xor edx, edx                          # 0044f410
    mov dl, byte ptr [ecx + field_258]           # 0044f412
    mov eax, dword ptr [ebp - local_4]           # 0044f418
    movsx ecx, word ptr [eax + field_256]        # 0044f41b
    mov dword ptr [4*ecx + 0x585801], edx        # 0044f422
L_0044f429:
    # block 0x0044f429: entered by je at 0x0044f40b, 1 instruction(s), ends with forward jump to 0x0044f4ca
    jmp.d32 L_0044f4ca                           # 0044f429
L_0044f42e:
    # block 0x0044f42e: entered by je at 0x0044f346, 25 instruction(s), ends with jne to 0x0044f4b6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044f42e
    movsx eax, word ptr [edx + field_220]        # 0044f431
    mov dword ptr [0x5bb57b], eax                # 0044f438
    mov ecx, dword ptr [ebp - local_4]           # 0044f43d
    mov dx, word ptr [ecx + field_222]           # 0044f440
    mov word ptr [0x5bb599], dx                  # 0044f447
    mov eax, dword ptr [ebp - local_4]           # 0044f44e
    mov cx, word ptr [eax + field_224]           # 0044f451
    mov word ptr [0x5bb595], cx                  # 0044f458
    mov edx, dword ptr [ebp - local_4]           # 0044f45f
    mov ax, word ptr [edx + field_226]           # 0044f462
    mov word ptr [0x5c39ff], ax                  # 0044f469
    mov ecx, dword ptr [ebp - local_4]           # 0044f46f
    mov edx, dword ptr [ecx + field_228]         # 0044f472
    mov dword ptr [0x5bb59b], edx                # 0044f478
    mov eax, dword ptr [ebp - local_4]           # 0044f47e
    mov ecx, dword ptr [eax + field_22c]         # 0044f481
    mov dword ptr [0x5bb59f], ecx                # 0044f487
    mov edx, dword ptr [ebp - local_4]           # 0044f48d
    mov eax, dword ptr [edx + field_230]         # 0044f490
    mov dword ptr [0x5bb5a3], eax                # 0044f496
    mov ecx, dword ptr [ebp - local_4]           # 0044f49b
    movsx edx, word ptr [ecx + field_234]        # 0044f49e
    cmp edx, 0x1                                 # 0044f4a5
    jne.d8 L_0044f4b6                            # 0044f4a8
    # block 0x0044f4aa: entered by fall-through of jne at 0x0044f4a8, 2 instruction(s), ends with forward jump to 0x0044f4c0
    mov dword ptr [0x5bb1ca], 0x0                # 0044f4aa
    jmp.d8 L_0044f4c0                            # 0044f4b4
L_0044f4b6:
    # block 0x0044f4b6: entered by jne at 0x0044f4a8, 1 instruction(s), falls into the block at 0x0044f4c0
    mov dword ptr [0x5bb1ca], 0x1                # 0044f4b6
L_0044f4c0:
    # block 0x0044f4c0: entered by jmp at 0x0044f4b4, 1 instruction(s), falls into the block at 0x0044f4ca
    mov dword ptr [0x583999], 0x4                # 0044f4c0
L_0044f4ca:
    # block 0x0044f4ca: entered by jmp at 0x0044f429, 7 instruction(s), calls FUN_0042ba3a, FUN_0044e78e, falls into the block at 0x0044f4e2
    mov eax, dword ptr [ebp - local_8]           # 0044f4ca
    mov cx, word ptr [eax + field_1e]            # 0044f4cd
    push ecx                                     # 0044f4d1
    call FUN_0042ba3a                            # 0044f4d2
    add esp, 0x4                                 # 0044f4d7
    mov ecx, dword ptr [ebp - local_8]           # 0044f4da
    call FUN_0044e78e                            # 0044f4dd
L_0044f4e2:
    # block 0x0044f4e2: entered by jmp at 0x0044f018; jmp at 0x0044f242; jmp at 0x0044f2ac, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0044f4e2
    pop esi                                      # 0044f4e3
    {load} mov esp, ebp                          # 0044f4e4
    pop ebp                                      # 0044f4e6
    ret 0x4                                      # 0044f4e7

