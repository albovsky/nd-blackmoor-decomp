# FUN_0045a07b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045a07b
# extent:       0x0045a07b-0x0045ae46 (3531 code bytes)
# span:         0x0045a07b-0x0045ae5e (code 3531, tables 24, padding 0)
# sha256:       6583d8f7d1852cd1acf591724e43919c636612f81e772bf74dcadeea7b223626
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045a07b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1c, field_22, field_28, field_65, field_69, field_6c, field_70, field_78, field_b8, field_c8, field_d6, field_db and 17 more; [ecx + n] field_1c, field_22, field_2c, field_30, field_68, field_6d, field_7c, field_80, field_c4, field_c8, field_ce, field_d7 and 16 more; [edx + n] field_1c, field_1e, field_22, field_34, field_61, field_74, field_84, field_bc, field_c0, field_c8, field_d7, field_db and 13 more
# callees:      calls FUN_004e8d96, FUN_0052139c, FUN_004c97b4, FUN_004c2dfb, FUN_004c2790, FUN_004d39f9, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0044a2b7, FUN_0042ba3a, FUN_00459b87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 779 instruction(s), 32 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_68, 0x68  # offset +0x68
.equ field_69, 0x69  # offset +0x69
.equ field_6c, 0x6c  # offset +0x6c
.equ field_6d, 0x6d  # offset +0x6d
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c4, 0xc4  # offset +0xc4
.equ field_c8, 0xc8  # offset +0xc8
.equ field_ce, 0xce  # offset +0xce
.equ field_d6, 0xd6  # offset +0xd6
.equ field_d7, 0xd7  # offset +0xd7
.equ field_db, 0xdb  # offset +0xdb
.equ field_df, 0xdf  # offset +0xdf
.equ field_e1, 0xe1  # offset +0xe1
.equ field_141, 0x141  # offset +0x141
.equ field_145, 0x145  # offset +0x145
.equ field_149, 0x149  # offset +0x149
.equ field_14d, 0x14d  # offset +0x14d
.equ field_191, 0x191  # offset +0x191
.equ field_195, 0x195  # offset +0x195
.equ field_199, 0x199  # offset +0x199
.equ field_19d, 0x19d  # offset +0x19d
.equ field_1a1, 0x1a1  # offset +0x1a1
.equ field_1a5, 0x1a5  # offset +0x1a5
.equ field_1a9, 0x1a9  # offset +0x1a9
.equ field_1ad, 0x1ad  # offset +0x1ad
.equ field_1b1, 0x1b1  # offset +0x1b1
.equ field_219, 0x219  # offset +0x219
.equ field_21b, 0x21b  # offset +0x21b
.equ field_21d, 0x21d  # offset +0x21d
.equ field_21f, 0x21f  # offset +0x21f
.equ field_221, 0x221  # offset +0x221
.equ field_225, 0x225  # offset +0x225
.equ field_229, 0x229  # offset +0x229
.equ field_22d, 0x22d  # offset +0x22d
.equ field_22f, 0x22f  # offset +0x22f
.equ field_231, 0x231  # offset +0x231
.equ field_232, 0x232  # offset +0x232
.equ field_255, 0x255  # offset +0x255
.equ field_265, 0x265  # offset +0x265
.equ field_267, 0x267  # offset +0x267
.equ field_269, 0x269  # offset +0x269
.equ field_26b, 0x26b  # offset +0x26b
.equ field_26d, 0x26d  # offset +0x26d
.equ field_271, 0x271  # offset +0x271
.equ field_275, 0x275  # offset +0x275
.equ field_279, 0x279  # offset +0x279
.equ field_27b, 0x27b  # offset +0x27b
.equ field_27d, 0x27d  # offset +0x27d
.equ field_27e, 0x27e  # offset +0x27e
.equ field_2a1, 0x2a1  # offset +0x2a1

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_00459b87, .text + (0x00459b87 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0045a07b - 0x401000
.globl FUN_0045a07b
FUN_0045a07b:
    # block 0x0045a07b: entry, 14 instruction(s), ends with je to 0x0045a0bc (forward)
    push ebp                                     # 0045a07b
    {load} mov ebp, esp                          # 0045a07c
    sub esp, 0x18                                # 0045a07e
    push ebx                                     # 0045a081
    push esi                                     # 0045a082
    push edi                                     # 0045a083
    mov dword ptr [ebp - local_10], ecx          # 0045a084
    mov eax, dword ptr [ebp - local_10]          # 0045a087
    movsx ecx, word ptr [eax + field_1c]         # 0045a08a
    imul ecx, ecx, 0x8d                          # 0045a08e
    mov edx, dword ptr [ecx + 0x5bb632]          # 0045a094
    mov dword ptr [ebp - local_14], edx          # 0045a09a
    cmp dword ptr [ebp - local_14], 0x0          # 0045a09d
    je.d8 L_0045a0bc                             # 0045a0a1
    # block 0x0045a0a3: entered by fall-through of je at 0x0045a0a1, 2 instruction(s), ends with je to 0x0045a675 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 0045a0a3
    je.d32 L_0045a675                            # 0045a0a7
    # block 0x0045a0ad: entered by fall-through of je at 0x0045a0a7, 2 instruction(s), ends with je to 0x0045aab5 (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 0045a0ad
    je.d32 L_0045aab5                            # 0045a0b1
    # block 0x0045a0b7: entered by fall-through of je at 0x0045a0b1, 1 instruction(s), ends with forward jump to 0x0045ae3d
    jmp.d32 L_0045ae3d                           # 0045a0b7
L_0045a0bc:
    # block 0x0045a0bc: entered by je at 0x0045a0a1, 20 instruction(s), calls FUN_004e8d96, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0045a127
    mov eax, dword ptr [ebp - local_10]          # 0045a0bc
    mov byte ptr [eax + field_d6], 0x1           # 0045a0bf
    mov ecx, dword ptr [ebp - local_10]          # 0045a0c6
    mov byte ptr [ecx + field_e1], 0x0           # 0045a0c9
    mov dword ptr [0x5bb1ca], 0x1                # 0045a0d0
    mov edx, dword ptr [ebp - local_10]          # 0045a0da
    mov ax, word ptr [ebp + arg_8]               # 0045a0dd
    mov word ptr [edx + field_1c], ax            # 0045a0e1
    mov ecx, 0x571442                            # 0045a0e5
    call FUN_004e8d96                            # 0045a0ea
    push 0x0                                     # 0045a0ef
    push 0x0                                     # 0045a0f1
    push 0x54a7dc                                # 0045a0f3
    call FUN_0052139c                            # 0045a0f8
    mov ecx, 0x5cf659                            # 0045a0fd
    call FUN_004c97b4                            # 0045a102
    mov ecx, dword ptr [ebp - local_10]          # 0045a107
    mov word ptr [ecx + field_df], 0x0           # 0045a10a
    mov word ptr [ebp - local_4], 0x0            # 0045a113
    jmp.d8 L_0045a127                            # 0045a119
L_0045a11b:
    # block 0x0045a11b: entered by jmp at 0x0045a14d, 3 instruction(s), falls into the block at 0x0045a127
    mov dx, word ptr [ebp - local_4]             # 0045a11b
    add dx, 0x1                                  # 0045a11f
    mov word ptr [ebp - local_4], dx             # 0045a123
L_0045a127:
    # block 0x0045a127: entered by jmp at 0x0045a119, 3 instruction(s), ends with jge to 0x0045a14f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045a127
    cmp eax, 0x4                                 # 0045a12b
    jge.d8 L_0045a14f                            # 0045a12e
    # block 0x0045a130: entered by fall-through of jge at 0x0045a12e, 7 instruction(s), ends with backward jump to 0x0045a11b
    movsx ecx, word ptr [ebp - local_4]          # 0045a130
    mov edx, dword ptr [ebp - local_10]          # 0045a134
    mov byte ptr [edx + ecx + field_1e], 0x0     # 0045a137
    movsx eax, word ptr [ebp - local_4]          # 0045a13c
    mov ecx, dword ptr [ebp - local_10]          # 0045a140
    mov word ptr [ecx + 2*eax + field_ce], 0xffff # 0045a143
    jmp.d8 L_0045a11b                            # 0045a14d
L_0045a14f:
    # block 0x0045a14f: entered by jge at 0x0045a12e, 2 instruction(s), ends with forward jump to 0x0045a163
    mov word ptr [ebp - local_4], 0x0            # 0045a14f
    jmp.d8 L_0045a163                            # 0045a155
L_0045a157:
    # block 0x0045a157: entered by jmp at 0x0045a23e, 3 instruction(s), falls into the block at 0x0045a163
    mov dx, word ptr [ebp - local_4]             # 0045a157
    add dx, 0x1                                  # 0045a15b
    mov word ptr [ebp - local_4], dx             # 0045a15f
L_0045a163:
    # block 0x0045a163: entered by jmp at 0x0045a155, 3 instruction(s), ends with jge to 0x0045a243 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045a163
    cmp eax, 0x4                                 # 0045a167
    jge.d32 L_0045a243                           # 0045a16a
    # block 0x0045a170: entered by fall-through of jge at 0x0045a16a, 49 instruction(s), ends with backward jump to 0x0045a157
    mov ecx, dword ptr [ebp - local_10]          # 0045a170
    movsx edx, word ptr [ecx + field_1c]         # 0045a173
    imul edx, edx, 0x8d                          # 0045a177
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a17d
    movsx ecx, word ptr [ebp - local_4]          # 0045a183
    shl ecx, 0x4                                 # 0045a187
    mov edx, dword ptr [eax + ecx + field_65]    # 0045a18a
    add edx, dword ptr [0x58318a]                # 0045a18e
    movsx eax, word ptr [ebp - local_4]          # 0045a194
    shl eax, 0x4                                 # 0045a198
    mov ecx, dword ptr [ebp - local_10]          # 0045a19b
    mov dword ptr [ecx + eax + field_7c], edx    # 0045a19e
    mov edx, dword ptr [ebp - local_10]          # 0045a1a2
    movsx eax, word ptr [edx + field_1c]         # 0045a1a5
    imul eax, eax, 0x8d                          # 0045a1a9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a1af
    movsx edx, word ptr [ebp - local_4]          # 0045a1b5
    shl edx, 0x4                                 # 0045a1b9
    mov eax, dword ptr [ecx + edx + field_6d]    # 0045a1bc
    add eax, dword ptr [0x58318a]                # 0045a1c0
    movsx ecx, word ptr [ebp - local_4]          # 0045a1c6
    shl ecx, 0x4                                 # 0045a1ca
    mov edx, dword ptr [ebp - local_10]          # 0045a1cd
    mov dword ptr [edx + ecx + field_84], eax    # 0045a1d0
    mov eax, dword ptr [ebp - local_10]          # 0045a1d7
    movsx ecx, word ptr [eax + field_1c]         # 0045a1da
    imul ecx, ecx, 0x8d                          # 0045a1de
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a1e4
    movsx eax, word ptr [ebp - local_4]          # 0045a1ea
    shl eax, 0x4                                 # 0045a1ee
    mov ecx, dword ptr [edx + eax + field_61]    # 0045a1f1
    add ecx, dword ptr [0x583186]                # 0045a1f5
    movsx edx, word ptr [ebp - local_4]          # 0045a1fb
    shl edx, 0x4                                 # 0045a1ff
    mov eax, dword ptr [ebp - local_10]          # 0045a202
    mov dword ptr [eax + edx + field_78], ecx    # 0045a205
    mov ecx, dword ptr [ebp - local_10]          # 0045a209
    movsx edx, word ptr [ecx + field_1c]         # 0045a20c
    imul edx, edx, 0x8d                          # 0045a210
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a216
    movsx ecx, word ptr [ebp - local_4]          # 0045a21c
    shl ecx, 0x4                                 # 0045a220
    mov edx, dword ptr [eax + ecx + field_69]    # 0045a223
    add edx, dword ptr [0x583186]                # 0045a227
    movsx eax, word ptr [ebp - local_4]          # 0045a22d
    shl eax, 0x4                                 # 0045a231
    mov ecx, dword ptr [ebp - local_10]          # 0045a234
    mov dword ptr [ecx + eax + field_80], edx    # 0045a237
    jmp.d32 L_0045a157                           # 0045a23e
L_0045a243:
    # block 0x0045a243: entered by jge at 0x0045a16a, 2 instruction(s), ends with forward jump to 0x0045a257
    mov word ptr [ebp - local_4], 0x0            # 0045a243
    jmp.d8 L_0045a257                            # 0045a249
L_0045a24b:
    # block 0x0045a24b: entered by jmp at 0x0045a338, 3 instruction(s), falls into the block at 0x0045a257
    mov dx, word ptr [ebp - local_4]             # 0045a24b
    add dx, 0x1                                  # 0045a24f
    mov word ptr [ebp - local_4], dx             # 0045a253
L_0045a257:
    # block 0x0045a257: entered by jmp at 0x0045a249, 3 instruction(s), ends with jge to 0x0045a33d (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045a257
    cmp eax, 0x4                                 # 0045a25b
    jge.d32 L_0045a33d                           # 0045a25e
    # block 0x0045a264: entered by fall-through of jge at 0x0045a25e, 49 instruction(s), ends with backward jump to 0x0045a24b
    mov ecx, dword ptr [ebp - local_10]          # 0045a264
    movsx edx, word ptr [ecx + field_1c]         # 0045a267
    imul edx, edx, 0x8d                          # 0045a26b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a271
    movsx ecx, word ptr [ebp - local_4]          # 0045a277
    shl ecx, 0x4                                 # 0045a27b
    mov edx, dword ptr [eax + ecx + field_145]   # 0045a27e
    add edx, dword ptr [0x58318a]                # 0045a285
    movsx eax, word ptr [ebp - local_4]          # 0045a28b
    shl eax, 0x4                                 # 0045a28f
    mov ecx, dword ptr [ebp - local_10]          # 0045a292
    mov dword ptr [ecx + eax + field_2c], edx    # 0045a295
    mov edx, dword ptr [ebp - local_10]          # 0045a299
    movsx eax, word ptr [edx + field_1c]         # 0045a29c
    imul eax, eax, 0x8d                          # 0045a2a0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a2a6
    movsx edx, word ptr [ebp - local_4]          # 0045a2ac
    shl edx, 0x4                                 # 0045a2b0
    mov eax, dword ptr [ecx + edx + field_14d]   # 0045a2b3
    add eax, dword ptr [0x58318a]                # 0045a2ba
    movsx ecx, word ptr [ebp - local_4]          # 0045a2c0
    shl ecx, 0x4                                 # 0045a2c4
    mov edx, dword ptr [ebp - local_10]          # 0045a2c7
    mov dword ptr [edx + ecx + field_34], eax    # 0045a2ca
    mov eax, dword ptr [ebp - local_10]          # 0045a2ce
    movsx ecx, word ptr [eax + field_1c]         # 0045a2d1
    imul ecx, ecx, 0x8d                          # 0045a2d5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a2db
    movsx eax, word ptr [ebp - local_4]          # 0045a2e1
    shl eax, 0x4                                 # 0045a2e5
    mov ecx, dword ptr [edx + eax + field_141]   # 0045a2e8
    add ecx, dword ptr [0x583186]                # 0045a2ef
    movsx edx, word ptr [ebp - local_4]          # 0045a2f5
    shl edx, 0x4                                 # 0045a2f9
    mov eax, dword ptr [ebp - local_10]          # 0045a2fc
    mov dword ptr [eax + edx + field_28], ecx    # 0045a2ff
    mov ecx, dword ptr [ebp - local_10]          # 0045a303
    movsx edx, word ptr [ecx + field_1c]         # 0045a306
    imul edx, edx, 0x8d                          # 0045a30a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a310
    movsx ecx, word ptr [ebp - local_4]          # 0045a316
    shl ecx, 0x4                                 # 0045a31a
    mov edx, dword ptr [eax + ecx + field_149]   # 0045a31d
    add edx, dword ptr [0x583186]                # 0045a324
    movsx eax, word ptr [ebp - local_4]          # 0045a32a
    shl eax, 0x4                                 # 0045a32e
    mov ecx, dword ptr [ebp - local_10]          # 0045a331
    mov dword ptr [ecx + eax + field_30], edx    # 0045a334
    jmp.d32 L_0045a24b                           # 0045a338
L_0045a33d:
    # block 0x0045a33d: entered by jge at 0x0045a25e, 67 instruction(s), ends with je to 0x0045a491 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045a33d
    movsx eax, word ptr [edx + field_1c]         # 0045a340
    imul eax, eax, 0x8d                          # 0045a344
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a34a
    mov edx, dword ptr [ecx + field_195]         # 0045a350
    add edx, dword ptr [0x58318a]                # 0045a356
    mov eax, dword ptr [ebp - local_10]          # 0045a35c
    mov dword ptr [eax + field_6c], edx          # 0045a35f
    mov ecx, dword ptr [ebp - local_10]          # 0045a362
    movsx edx, word ptr [ecx + field_1c]         # 0045a365
    imul edx, edx, 0x8d                          # 0045a369
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a36f
    mov ecx, dword ptr [eax + field_19d]         # 0045a375
    add ecx, dword ptr [0x58318a]                # 0045a37b
    mov edx, dword ptr [ebp - local_10]          # 0045a381
    mov dword ptr [edx + field_74], ecx          # 0045a384
    mov eax, dword ptr [ebp - local_10]          # 0045a387
    movsx ecx, word ptr [eax + field_1c]         # 0045a38a
    imul ecx, ecx, 0x8d                          # 0045a38e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a394
    mov eax, dword ptr [edx + field_191]         # 0045a39a
    add eax, dword ptr [0x583186]                # 0045a3a0
    mov ecx, dword ptr [ebp - local_10]          # 0045a3a6
    mov dword ptr [ecx + field_68], eax          # 0045a3a9
    mov edx, dword ptr [ebp - local_10]          # 0045a3ac
    movsx eax, word ptr [edx + field_1c]         # 0045a3af
    imul eax, eax, 0x8d                          # 0045a3b3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a3b9
    mov edx, dword ptr [ecx + field_199]         # 0045a3bf
    add edx, dword ptr [0x583186]                # 0045a3c5
    mov eax, dword ptr [ebp - local_10]          # 0045a3cb
    mov dword ptr [eax + field_70], edx          # 0045a3ce
    mov ecx, dword ptr [ebp - local_10]          # 0045a3d1
    movsx edx, word ptr [ecx + field_1c]         # 0045a3d4
    imul edx, edx, 0x8d                          # 0045a3d8
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a3de
    mov ecx, dword ptr [eax + field_1a5]         # 0045a3e4
    add ecx, dword ptr [0x58318a]                # 0045a3ea
    mov edx, dword ptr [ebp - local_10]          # 0045a3f0
    mov dword ptr [edx + field_bc], ecx          # 0045a3f3
    mov eax, dword ptr [ebp - local_10]          # 0045a3f9
    movsx ecx, word ptr [eax + field_1c]         # 0045a3fc
    imul ecx, ecx, 0x8d                          # 0045a400
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a406
    mov eax, dword ptr [edx + field_1ad]         # 0045a40c
    add eax, dword ptr [0x58318a]                # 0045a412
    mov ecx, dword ptr [ebp - local_10]          # 0045a418
    mov dword ptr [ecx + field_c4], eax          # 0045a41b
    mov edx, dword ptr [ebp - local_10]          # 0045a421
    movsx eax, word ptr [edx + field_1c]         # 0045a424
    imul eax, eax, 0x8d                          # 0045a428
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a42e
    mov edx, dword ptr [ecx + field_1a1]         # 0045a434
    add edx, dword ptr [0x583186]                # 0045a43a
    mov eax, dword ptr [ebp - local_10]          # 0045a440
    mov dword ptr [eax + field_b8], edx          # 0045a443
    mov ecx, dword ptr [ebp - local_10]          # 0045a449
    movsx edx, word ptr [ecx + field_1c]         # 0045a44c
    imul edx, edx, 0x8d                          # 0045a450
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a456
    mov ecx, dword ptr [eax + field_1a9]         # 0045a45c
    add ecx, dword ptr [0x583186]                # 0045a462
    mov edx, dword ptr [ebp - local_10]          # 0045a468
    mov dword ptr [edx + field_c0], ecx          # 0045a46b
    mov eax, dword ptr [ebp - local_10]          # 0045a471
    cmp dword ptr [eax + field_c8], 0x0          # 0045a474
    je.d8 L_0045a491                             # 0045a47b
    # block 0x0045a47d: entered by fall-through of je at 0x0045a47b, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0045a491
    mov ecx, dword ptr [ebp - local_10]          # 0045a47d
    add ecx, 0xc8                                # 0045a480
    push ecx                                     # 0045a486
    mov ecx, 0x5cf659                            # 0045a487
    call FUN_004c2dfb                            # 0045a48c
L_0045a491:
    # block 0x0045a491: entered by je at 0x0045a47b, 3 instruction(s), ends with jne to 0x0045a4d0 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045a491
    cmp dword ptr [edx + field_c8], 0x0          # 0045a494
    jne.d8 L_0045a4d0                            # 0045a49b
    # block 0x0045a49d: entered by fall-through of jne at 0x0045a49b, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x0045a4d0
    push 0x54a83c                                # 0045a49d
    push 0x6                                     # 0045a4a2
    mov eax, dword ptr [ebp - local_10]          # 0045a4a4
    movsx ecx, word ptr [eax + field_1c]         # 0045a4a7
    imul ecx, ecx, 0x8d                          # 0045a4ab
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a4b1
    push edx                                     # 0045a4b7
    push 0x54a854                                # 0045a4b8
    mov ecx, 0x5cf659                            # 0045a4bd
    call FUN_004c2790                            # 0045a4c2
    mov ecx, dword ptr [ebp - local_10]          # 0045a4c7
    mov dword ptr [ecx + field_c8], eax          # 0045a4ca
L_0045a4d0:
    # block 0x0045a4d0: entered by jne at 0x0045a49b, 66 instruction(s), calls FUN_004d39f9, ends with je to 0x0045a600 (forward)
    call FUN_004d39f9                            # 0045a4d0
    mov edx, dword ptr [ebp - local_10]          # 0045a4d5
    mov word ptr [edx + field_22], ax            # 0045a4d8
    mov eax, dword ptr [ebp - local_10]          # 0045a4dc
    movsx ecx, word ptr [eax + field_22]         # 0045a4df
    imul ecx, ecx, 0x4a                          # 0045a4e3
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0045a4e6
    mov edx, dword ptr [ebp - local_10]          # 0045a4f0
    movsx eax, word ptr [edx + field_22]         # 0045a4f3
    imul eax, eax, 0x4a                          # 0045a4f7
    mov dword ptr [eax + 0x5d1595], 0x45ae6e     # 0045a4fa
    mov ecx, dword ptr [ebp - local_10]          # 0045a504
    movsx edx, word ptr [ecx + field_22]         # 0045a507
    imul edx, edx, 0x4a                          # 0045a50b
    mov eax, dword ptr [ebp - local_10]          # 0045a50e
    mov ecx, dword ptr [eax + field_c8]          # 0045a511
    mov dword ptr [edx + 0x5d1599], ecx          # 0045a517
    mov edx, dword ptr [ebp - local_10]          # 0045a51d
    movsx eax, word ptr [edx + field_22]         # 0045a520
    imul eax, eax, 0x4a                          # 0045a524
    mov dword ptr [eax + 0x5d159d], 0x0          # 0045a527
    mov ecx, dword ptr [ebp - local_10]          # 0045a531
    movsx edx, word ptr [ecx + field_22]         # 0045a534
    imul edx, edx, 0x4a                          # 0045a538
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0045a53b
    mov eax, dword ptr [ebp - local_10]          # 0045a545
    movsx ecx, word ptr [eax + field_22]         # 0045a548
    imul ecx, ecx, 0x4a                          # 0045a54c
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0045a54f
    mov edx, dword ptr [ebp - local_10]          # 0045a559
    movsx eax, word ptr [edx + field_22]         # 0045a55c
    imul eax, eax, 0x4a                          # 0045a560
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0045a563
    mov ecx, dword ptr [ebp - local_10]          # 0045a56d
    movsx edx, word ptr [ecx + field_22]         # 0045a570
    imul edx, edx, 0x4a                          # 0045a574
    mov word ptr [edx + 0x5d15ad], 0x0           # 0045a577
    mov edi, 0x54a85c                            # 0045a580
    mov eax, dword ptr [ebp - local_10]          # 0045a585
    movsx ecx, word ptr [eax + field_22]         # 0045a588
    imul ecx, ecx, 0x4a                          # 0045a58c
    add ecx, 0x5d15b3                            # 0045a58f
    {load} mov edx, ecx                          # 0045a595
    or ecx, -0x1                                 # 0045a597
    {load} xor eax, eax                          # 0045a59a
    repne scasb al, byte ptr es:[edi]            # 0045a59c
    not ecx                                      # 0045a59e
    {load} sub edi, ecx                          # 0045a5a0
    {load} mov esi, edi                          # 0045a5a2
    {load} mov eax, ecx                          # 0045a5a4
    {load} mov edi, edx                          # 0045a5a6
    shr ecx, 0x2                                 # 0045a5a8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045a5ab
    {load} mov ecx, eax                          # 0045a5ad
    and ecx, 0x3                                 # 0045a5af
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045a5b2
    mov edi, 0x54a874                            # 0045a5b4
    mov ecx, dword ptr [ebp - local_10]          # 0045a5b9
    movsx edx, word ptr [ecx + field_1c]         # 0045a5bc
    imul edx, edx, 0x8d                          # 0045a5c0
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0045a5c6
    add esi, 0x1b5                               # 0045a5cc
    mov ecx, 0x9                                 # 0045a5d2
    {load} xor eax, eax                          # 0045a5d7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045a5d9
    je.d8 L_0045a600                             # 0045a5db
    # block 0x0045a5dd: entered by fall-through of je at 0x0045a5db, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045a600
    mov ecx, dword ptr [ebp - local_10]          # 0045a5dd
    movsx edx, word ptr [ecx + field_1c]         # 0045a5e0
    imul edx, edx, 0x8d                          # 0045a5e4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a5ea
    add eax, 0x1b5                               # 0045a5f0
    push eax                                     # 0045a5f5
    mov ecx, 0x5c3a67                            # 0045a5f6
    call FUN_004fb77a                            # 0045a5fb
L_0045a600:
    # block 0x0045a600: entered by je at 0x0045a5db, 10 instruction(s), ends with je to 0x0045a64c (forward)
    mov edi, 0x54a880                            # 0045a600
    mov ecx, dword ptr [ebp - local_10]          # 0045a605
    movsx edx, word ptr [ecx + field_1c]         # 0045a608
    imul edx, edx, 0x8d                          # 0045a60c
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0045a612
    add esi, 0x1e6                               # 0045a618
    mov ecx, 0x9                                 # 0045a61e
    {load} xor eax, eax                          # 0045a623
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045a625
    je.d8 L_0045a64c                             # 0045a627
    # block 0x0045a629: entered by fall-through of je at 0x0045a627, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045a64c
    mov ecx, dword ptr [ebp - local_10]          # 0045a629
    movsx edx, word ptr [ecx + field_1c]         # 0045a62c
    imul edx, edx, 0x8d                          # 0045a630
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a636
    add eax, 0x1e6                               # 0045a63c
    push eax                                     # 0045a641
    mov ecx, 0x5c3a67                            # 0045a642
    call FUN_004fb77a                            # 0045a647
L_0045a64c:
    # block 0x0045a64c: entered by je at 0x0045a627, 7 instruction(s), ends with forward jump to 0x0045ae3d
    mov ecx, dword ptr [ebp - local_10]          # 0045a64c
    mov dword ptr [ecx + field_db], 0x0          # 0045a64f
    mov edx, dword ptr [ebp - local_10]          # 0045a659
    movsx eax, word ptr [edx + field_1c]         # 0045a65c
    imul eax, eax, 0x8d                          # 0045a660
    mov dword ptr [eax + 0x5bb632], 0x1          # 0045a666
    jmp.d32 L_0045ae3d                           # 0045a670
L_0045a675:
    # block 0x0045a675: entered by je at 0x0045a0a7, 5 instruction(s), ends with ja to 0x0045aab0 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045a675
    mov edx, dword ptr [ecx + field_db]          # 0045a678
    mov dword ptr [ebp - local_18], edx          # 0045a67e
    cmp dword ptr [ebp - local_18], 0x5          # 0045a681
    ja.d32 L_0045aab0                            # 0045a685
    # block 0x0045a68b: entered by fall-through of ja at 0x0045a685, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x45ae46]
    mov eax, dword ptr [ebp - local_18]          # 0045a68b
    jmp dword ptr [4*eax + SWTAB_0045ae46_VA]    # 0045a68e
L_0045a695:
    # block 0x0045a695: entered by switch case, 2 instruction(s), ends with forward jump to 0x0045a6a9
    mov word ptr [ebp - local_4], 0x0            # 0045a695
    jmp.d8 L_0045a6a9                            # 0045a69b
L_0045a69d:
    # block 0x0045a69d: entered by jmp at 0x0045a712, 3 instruction(s), falls into the block at 0x0045a6a9
    mov cx, word ptr [ebp - local_4]             # 0045a69d
    add cx, 0x1                                  # 0045a6a1
    mov word ptr [ebp - local_4], cx             # 0045a6a5
L_0045a6a9:
    # block 0x0045a6a9: entered by jmp at 0x0045a69b, 3 instruction(s), ends with jge to 0x0045a714 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0045a6a9
    cmp edx, 0x4                                 # 0045a6ad
    jge.d8 L_0045a714                            # 0045a6b0
    # block 0x0045a6b2: entered by fall-through of jge at 0x0045a6b0, 5 instruction(s), ends with jg to 0x0045a6c6 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045a6b2
    movsx ecx, word ptr [eax + field_df]         # 0045a6b5
    movsx edx, word ptr [ebp - local_4]          # 0045a6bc
    {load} cmp ecx, edx                          # 0045a6c0
    jg.d8 L_0045a6c6                             # 0045a6c2
    # block 0x0045a6c4: entered by fall-through of jg at 0x0045a6c2, 1 instruction(s), ends with forward jump to 0x0045a714
    jmp.d8 L_0045a714                            # 0045a6c4
L_0045a6c6:
    # block 0x0045a6c6: entered by jg at 0x0045a6c2, 12 instruction(s), ends with je to 0x0045a712 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045a6c6
    mov ecx, dword ptr [ebp - local_10]          # 0045a6ca
    movsx edx, word ptr [ecx + 2*eax + field_ce] # 0045a6cd
    mov eax, dword ptr [ebp - local_10]          # 0045a6d5
    movsx ecx, word ptr [eax + field_1c]         # 0045a6d8
    imul ecx, ecx, 0x8d                          # 0045a6dc
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0045a6e2
    movsx ecx, word ptr [ebp - local_4]          # 0045a6e8
    {load} xor ebx, ebx                          # 0045a6ec
    mov bl, byte ptr [eax + ecx + field_1b1]     # 0045a6ee
    {load} cmp edx, ebx                          # 0045a6f5
    je.d8 L_0045a712                             # 0045a6f7
    # block 0x0045a6f9: entered by fall-through of je at 0x0045a6f7, 5 instruction(s), ends with forward jump to 0x0045a714
    mov edx, dword ptr [ebp - local_10]          # 0045a6f9
    mov byte ptr [edx + field_e1], 0x0           # 0045a6fc
    mov eax, dword ptr [ebp - local_10]          # 0045a703
    mov dword ptr [eax + field_db], 0x2          # 0045a706
    jmp.d8 L_0045a714                            # 0045a710
L_0045a712:
    # block 0x0045a712: entered by je at 0x0045a6f7, 1 instruction(s), ends with backward jump to 0x0045a69d
    jmp.d8 L_0045a69d                            # 0045a712
L_0045a714:
    # block 0x0045a714: entered by jge at 0x0045a6b0; jmp at 0x0045a6c4; jmp at 0x0045a710, 3 instruction(s), ends with jne to 0x0045a739 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0045a714
    cmp ecx, 0x4                                 # 0045a718
    jne.d8 L_0045a739                            # 0045a71b
    # block 0x0045a71d: entered by fall-through of jne at 0x0045a71b, 5 instruction(s), ends with forward jump to 0x0045aab0
    mov edx, dword ptr [ebp - local_10]          # 0045a71d
    mov byte ptr [edx + field_e1], 0x1           # 0045a720
    mov eax, dword ptr [ebp - local_10]          # 0045a727
    mov dword ptr [eax + field_db], 0x1          # 0045a72a
    jmp.d32 L_0045aab0                           # 0045a734
L_0045a739:
    # block 0x0045a739: entered by jne at 0x0045a71b, 1 instruction(s), ends with forward jump to 0x0045aab0
    jmp.d32 L_0045aab0                           # 0045a739
L_0045a73e:
    # block 0x0045a73e: entered by switch case, 7 instruction(s), ends with je to 0x0045a799 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045a73e
    movsx edx, word ptr [ecx + field_1c]         # 0045a741
    imul edx, edx, 0x8d                          # 0045a745
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a74b
    movsx ecx, word ptr [eax + field_22f]        # 0045a751
    cmp ecx, -0x1                                # 0045a758
    je.d8 L_0045a799                             # 0045a75b
    # block 0x0045a75d: entered by fall-through of je at 0x0045a75b, 12 instruction(s), falls into the block at 0x0045a799
    mov edx, dword ptr [ebp - local_10]          # 0045a75d
    movsx eax, word ptr [edx + field_1c]         # 0045a760
    imul eax, eax, 0x8d                          # 0045a764
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a76a
    {load} xor edx, edx                          # 0045a770
    mov dl, byte ptr [ecx + field_231]           # 0045a772
    mov eax, dword ptr [ebp - local_10]          # 0045a778
    movsx ecx, word ptr [eax + field_1c]         # 0045a77b
    imul ecx, ecx, 0x8d                          # 0045a77f
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0045a785
    movsx ecx, word ptr [eax + field_22f]        # 0045a78b
    mov dword ptr [4*ecx + 0x585801], edx        # 0045a792
L_0045a799:
    # block 0x0045a799: entered by je at 0x0045a75b, 13 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045aab0
    call dword ptr [0x52a23c]                    # 0045a799
    mov edx, dword ptr [ebp - local_10]          # 0045a79f
    movsx ecx, word ptr [edx + field_1c]         # 0045a7a2
    imul ecx, ecx, 0x8d                          # 0045a7a6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a7ac
    movsx ecx, word ptr [edx + field_232]        # 0045a7b2
    imul ecx, ecx, 0x3e8                         # 0045a7b9
    {load} add eax, ecx                          # 0045a7bf
    mov edx, dword ptr [ebp - local_10]          # 0045a7c1
    mov dword ptr [edx + field_d7], eax          # 0045a7c4
    mov eax, dword ptr [ebp - local_10]          # 0045a7ca
    mov dword ptr [eax + field_db], 0x3          # 0045a7cd
    jmp.d32 L_0045aab0                           # 0045a7d7
L_0045a7dc:
    # block 0x0045a7dc: entered by switch case, 7 instruction(s), ends with je to 0x0045a837 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045a7dc
    movsx edx, word ptr [ecx + field_1c]         # 0045a7df
    imul edx, edx, 0x8d                          # 0045a7e3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a7e9
    movsx ecx, word ptr [eax + field_27b]        # 0045a7ef
    cmp ecx, -0x1                                # 0045a7f6
    je.d8 L_0045a837                             # 0045a7f9
    # block 0x0045a7fb: entered by fall-through of je at 0x0045a7f9, 12 instruction(s), falls into the block at 0x0045a837
    mov edx, dword ptr [ebp - local_10]          # 0045a7fb
    movsx eax, word ptr [edx + field_1c]         # 0045a7fe
    imul eax, eax, 0x8d                          # 0045a802
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a808
    {load} xor edx, edx                          # 0045a80e
    mov dl, byte ptr [ecx + field_27d]           # 0045a810
    mov eax, dword ptr [ebp - local_10]          # 0045a816
    movsx ecx, word ptr [eax + field_1c]         # 0045a819
    imul ecx, ecx, 0x8d                          # 0045a81d
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0045a823
    movsx ecx, word ptr [eax + field_27b]        # 0045a829
    mov dword ptr [4*ecx + 0x585801], edx        # 0045a830
L_0045a837:
    # block 0x0045a837: entered by je at 0x0045a7f9, 13 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045aab0
    call dword ptr [0x52a23c]                    # 0045a837
    mov edx, dword ptr [ebp - local_10]          # 0045a83d
    movsx ecx, word ptr [edx + field_1c]         # 0045a840
    imul ecx, ecx, 0x8d                          # 0045a844
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a84a
    movsx ecx, word ptr [edx + field_27e]        # 0045a850
    imul ecx, ecx, 0x3e8                         # 0045a857
    {load} add eax, ecx                          # 0045a85d
    mov edx, dword ptr [ebp - local_10]          # 0045a85f
    mov dword ptr [edx + field_d7], eax          # 0045a862
    mov eax, dword ptr [ebp - local_10]          # 0045a868
    mov dword ptr [eax + field_db], 0x3          # 0045a86b
    jmp.d32 L_0045aab0                           # 0045a875
L_0045a87a:
    # block 0x0045a87a: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045a9d6 (forward)
    call dword ptr [0x52a23c]                    # 0045a87a
    mov ecx, dword ptr [ebp - local_10]          # 0045a880
    cmp eax, dword ptr [ecx + field_d7]          # 0045a883
    jb.d32 L_0045a9d6                            # 0045a889
    # block 0x0045a88f: entered by fall-through of jb at 0x0045a889, 5 instruction(s), ends with je to 0x0045a93e (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045a88f
    {load} xor eax, eax                          # 0045a892
    mov al, byte ptr [edx + field_e1]            # 0045a894
    test eax, eax                                # 0045a89a
    je.d32 L_0045a93e                            # 0045a89c
    # block 0x0045a8a2: entered by fall-through of je at 0x0045a89c, 10 instruction(s), ends with je to 0x0045a922 (forward)
    mov edi, 0x54a88c                            # 0045a8a2
    mov ecx, dword ptr [ebp - local_10]          # 0045a8a7
    movsx edx, word ptr [ecx + field_1c]         # 0045a8aa
    imul edx, edx, 0x8d                          # 0045a8ae
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0045a8b4
    add esi, 0x234                               # 0045a8ba
    mov ecx, 0x9                                 # 0045a8c0
    {load} xor eax, eax                          # 0045a8c5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045a8c7
    je.d8 L_0045a922                             # 0045a8c9
    # block 0x0045a8cb: entered by fall-through of je at 0x0045a8c9, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0045a939
    mov ecx, dword ptr [ebp - local_10]          # 0045a8cb
    movsx edx, word ptr [ecx + field_1c]         # 0045a8ce
    imul edx, edx, 0x8d                          # 0045a8d2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a8d8
    add eax, 0x234                               # 0045a8de
    push eax                                     # 0045a8e3
    mov ecx, 0x5c3a67                            # 0045a8e4
    call FUN_004fb77a                            # 0045a8e9
    mov ecx, dword ptr [ebp - local_10]          # 0045a8ee
    movsx edx, word ptr [ecx + field_1c]         # 0045a8f1
    imul edx, edx, 0x8d                          # 0045a8f5
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a8fb
    mov cx, word ptr [eax + field_255]           # 0045a901
    push ecx                                     # 0045a908
    mov ecx, 0x5c3a67                            # 0045a909
    call FUN_004fb2e3                            # 0045a90e
    mov edx, dword ptr [ebp - local_10]          # 0045a913
    mov dword ptr [edx + field_db], 0x4          # 0045a916
    jmp.d8 L_0045a939                            # 0045a920
L_0045a922:
    # block 0x0045a922: entered by je at 0x0045a8c9, 4 instruction(s), falls into the block at 0x0045a939
    mov eax, dword ptr [ebp - local_10]          # 0045a922
    movsx ecx, word ptr [eax + field_1c]         # 0045a925
    imul ecx, ecx, 0x8d                          # 0045a929
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0045a92f
L_0045a939:
    # block 0x0045a939: entered by jmp at 0x0045a920, 1 instruction(s), ends with forward jump to 0x0045a9d6
    jmp.d32 L_0045a9d6                           # 0045a939
L_0045a93e:
    # block 0x0045a93e: entered by je at 0x0045a89c, 10 instruction(s), ends with je to 0x0045a9bf (forward)
    mov edi, 0x54a898                            # 0045a93e
    mov edx, dword ptr [ebp - local_10]          # 0045a943
    movsx eax, word ptr [edx + field_1c]         # 0045a946
    imul eax, eax, 0x8d                          # 0045a94a
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0045a950
    add esi, 0x280                               # 0045a956
    mov ecx, 0x9                                 # 0045a95c
    {load} xor edx, edx                          # 0045a961
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045a963
    je.d8 L_0045a9bf                             # 0045a965
    # block 0x0045a967: entered by fall-through of je at 0x0045a965, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0045a9d6
    mov eax, dword ptr [ebp - local_10]          # 0045a967
    movsx ecx, word ptr [eax + field_1c]         # 0045a96a
    imul ecx, ecx, 0x8d                          # 0045a96e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a974
    add edx, 0x280                               # 0045a97a
    push edx                                     # 0045a980
    mov ecx, 0x5c3a67                            # 0045a981
    call FUN_004fb77a                            # 0045a986
    mov eax, dword ptr [ebp - local_10]          # 0045a98b
    movsx ecx, word ptr [eax + field_1c]         # 0045a98e
    imul ecx, ecx, 0x8d                          # 0045a992
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a998
    mov ax, word ptr [edx + field_2a1]           # 0045a99e
    push eax                                     # 0045a9a5
    mov ecx, 0x5c3a67                            # 0045a9a6
    call FUN_004fb2e3                            # 0045a9ab
    mov ecx, dword ptr [ebp - local_10]          # 0045a9b0
    mov dword ptr [ecx + field_db], 0x5          # 0045a9b3
    jmp.d8 L_0045a9d6                            # 0045a9bd
L_0045a9bf:
    # block 0x0045a9bf: entered by je at 0x0045a965, 4 instruction(s), falls into the block at 0x0045a9d6
    mov edx, dword ptr [ebp - local_10]          # 0045a9bf
    movsx eax, word ptr [edx + field_1c]         # 0045a9c2
    imul eax, eax, 0x8d                          # 0045a9c6
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045a9cc
L_0045a9d6:
    # block 0x0045a9d6: entered by jb at 0x0045a889; jmp at 0x0045a939; jmp at 0x0045a9bd, 1 instruction(s), ends with forward jump to 0x0045aab0
    jmp.d32 L_0045aab0                           # 0045a9d6
L_0045a9db:
    # block 0x0045a9db: entered by switch case, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x0045aa45 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045a9db
    movsx edx, word ptr [ecx + field_1c]         # 0045a9de
    imul edx, edx, 0x8d                          # 0045a9e2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045a9e8
    movsx ecx, word ptr [eax + field_255]        # 0045a9ee
    mov dword ptr [ebp - local_8], ecx           # 0045a9f5
    mov edx, dword ptr [ebp - local_8]           # 0045a9f8
    push edx                                     # 0045a9fb
    mov ecx, 0x5cf1eb                            # 0045a9fc
    call FUN_004f6334                            # 0045aa01
    test eax, eax                                # 0045aa06
    jne.d8 L_0045aa45                            # 0045aa08
    # block 0x0045aa0a: entered by fall-through of jne at 0x0045aa08, 12 instruction(s), calls FUN_004fba69, falls into the block at 0x0045aa45
    mov eax, dword ptr [ebp - local_10]          # 0045aa0a
    movsx ecx, word ptr [eax + field_1c]         # 0045aa0d
    imul ecx, ecx, 0x8d                          # 0045aa11
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045aa17
    add edx, 0x234                               # 0045aa1d
    push edx                                     # 0045aa23
    mov ecx, 0x5c3a67                            # 0045aa24
    call FUN_004fba69                            # 0045aa29
    mov eax, dword ptr [ebp - local_10]          # 0045aa2e
    movsx ecx, word ptr [eax + field_1c]         # 0045aa31
    imul ecx, ecx, 0x8d                          # 0045aa35
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0045aa3b
L_0045aa45:
    # block 0x0045aa45: entered by jne at 0x0045aa08, 1 instruction(s), ends with forward jump to 0x0045aab0
    jmp.d8 L_0045aab0                            # 0045aa45
L_0045aa47:
    # block 0x0045aa47: entered by switch case, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x0045aab0 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045aa47
    movsx eax, word ptr [edx + field_1c]         # 0045aa4a
    imul eax, eax, 0x8d                          # 0045aa4e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045aa54
    movsx edx, word ptr [ecx + field_2a1]        # 0045aa5a
    mov dword ptr [ebp - local_c], edx           # 0045aa61
    mov eax, dword ptr [ebp - local_c]           # 0045aa64
    push eax                                     # 0045aa67
    mov ecx, 0x5cf1eb                            # 0045aa68
    call FUN_004f6334                            # 0045aa6d
    test eax, eax                                # 0045aa72
    jne.d8 L_0045aab0                            # 0045aa74
    # block 0x0045aa76: entered by fall-through of jne at 0x0045aa74, 12 instruction(s), calls FUN_004fba69, falls into the block at 0x0045aab0
    mov ecx, dword ptr [ebp - local_10]          # 0045aa76
    movsx edx, word ptr [ecx + field_1c]         # 0045aa79
    imul edx, edx, 0x8d                          # 0045aa7d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045aa83
    add eax, 0x280                               # 0045aa89
    push eax                                     # 0045aa8e
    mov ecx, 0x5c3a67                            # 0045aa8f
    call FUN_004fba69                            # 0045aa94
    mov ecx, dword ptr [ebp - local_10]          # 0045aa99
    movsx edx, word ptr [ecx + field_1c]         # 0045aa9c
    imul edx, edx, 0x8d                          # 0045aaa0
    mov dword ptr [edx + 0x5bb632], 0x2          # 0045aaa6
L_0045aab0:
    # block 0x0045aab0: entered by ja at 0x0045a685; jmp at 0x0045a734; jmp at 0x0045a739; jmp at 0x0045a7d7; more, 1 instruction(s), ends with forward jump to 0x0045ae3d
    jmp.d32 L_0045ae3d                           # 0045aab0
L_0045aab5:
    # block 0x0045aab5: entered by je at 0x0045a0b1, 11 instruction(s), ends with je to 0x0045ab0c (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0045aab5
    mov edi, 0x54a8a4                            # 0045aabf
    mov eax, dword ptr [ebp - local_10]          # 0045aac4
    movsx ecx, word ptr [eax + field_1c]         # 0045aac7
    imul ecx, ecx, 0x8d                          # 0045aacb
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0045aad1
    add esi, 0x1b5                               # 0045aad7
    mov ecx, 0x9                                 # 0045aadd
    {load} xor edx, edx                          # 0045aae2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045aae4
    je.d8 L_0045ab0c                             # 0045aae6
    # block 0x0045aae8: entered by fall-through of je at 0x0045aae6, 8 instruction(s), calls FUN_004fba69, falls into the block at 0x0045ab0c
    mov eax, dword ptr [ebp - local_10]          # 0045aae8
    movsx ecx, word ptr [eax + field_1c]         # 0045aaeb
    imul ecx, ecx, 0x8d                          # 0045aaef
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045aaf5
    add edx, 0x1b5                               # 0045aafb
    push edx                                     # 0045ab01
    mov ecx, 0x5c3a67                            # 0045ab02
    call FUN_004fba69                            # 0045ab07
L_0045ab0c:
    # block 0x0045ab0c: entered by je at 0x0045aae6, 10 instruction(s), ends with je to 0x0045ab59 (forward)
    mov edi, 0x54a8b0                            # 0045ab0c
    mov eax, dword ptr [ebp - local_10]          # 0045ab11
    movsx ecx, word ptr [eax + field_1c]         # 0045ab14
    imul ecx, ecx, 0x8d                          # 0045ab18
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0045ab1e
    add esi, 0x1e6                               # 0045ab24
    mov ecx, 0x9                                 # 0045ab2a
    {load} xor edx, edx                          # 0045ab2f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045ab31
    je.d8 L_0045ab59                             # 0045ab33
    # block 0x0045ab35: entered by fall-through of je at 0x0045ab33, 8 instruction(s), calls FUN_004fba69, falls into the block at 0x0045ab59
    mov eax, dword ptr [ebp - local_10]          # 0045ab35
    movsx ecx, word ptr [eax + field_1c]         # 0045ab38
    imul ecx, ecx, 0x8d                          # 0045ab3c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ab42
    add edx, 0x1e6                               # 0045ab48
    push edx                                     # 0045ab4e
    mov ecx, 0x5c3a67                            # 0045ab4f
    call FUN_004fba69                            # 0045ab54
L_0045ab59:
    # block 0x0045ab59: entered by je at 0x0045ab33, 5 instruction(s), ends with je to 0x0045accb (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045ab59
    {load} xor ecx, ecx                          # 0045ab5c
    mov cl, byte ptr [eax + field_e1]            # 0045ab5e
    test ecx, ecx                                # 0045ab64
    je.d32 L_0045accb                            # 0045ab66
    # block 0x0045ab6c: entered by fall-through of je at 0x0045ab66, 7 instruction(s), ends with je to 0x0045acc6 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045ab6c
    movsx eax, word ptr [edx + field_1c]         # 0045ab6f
    imul eax, eax, 0x8d                          # 0045ab73
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045ab79
    movsx edx, word ptr [ecx + field_219]        # 0045ab7f
    cmp edx, 0x270f                              # 0045ab86
    je.d32 L_0045acc6                            # 0045ab8c
    # block 0x0045ab92: entered by fall-through of je at 0x0045ab8c, 49 instruction(s), ends with jne to 0x0045ac9a (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045ab92
    movsx ecx, word ptr [eax + field_1c]         # 0045ab95
    imul ecx, ecx, 0x8d                          # 0045ab99
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ab9f
    movsx eax, word ptr [edx + field_219]        # 0045aba5
    mov dword ptr [0x5bb57b], eax                # 0045abac
    mov ecx, dword ptr [ebp - local_10]          # 0045abb1
    movsx edx, word ptr [ecx + field_1c]         # 0045abb4
    imul edx, edx, 0x8d                          # 0045abb8
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045abbe
    mov cx, word ptr [eax + field_21b]           # 0045abc4
    mov word ptr [0x5bb599], cx                  # 0045abcb
    mov edx, dword ptr [ebp - local_10]          # 0045abd2
    movsx eax, word ptr [edx + field_1c]         # 0045abd5
    imul eax, eax, 0x8d                          # 0045abd9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045abdf
    mov dx, word ptr [ecx + field_21d]           # 0045abe5
    mov word ptr [0x5bb595], dx                  # 0045abec
    mov eax, dword ptr [ebp - local_10]          # 0045abf3
    movsx ecx, word ptr [eax + field_1c]         # 0045abf6
    imul ecx, ecx, 0x8d                          # 0045abfa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ac00
    mov ax, word ptr [edx + field_21f]           # 0045ac06
    mov word ptr [0x5c39ff], ax                  # 0045ac0d
    mov ecx, dword ptr [ebp - local_10]          # 0045ac13
    movsx edx, word ptr [ecx + field_1c]         # 0045ac16
    imul edx, edx, 0x8d                          # 0045ac1a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045ac20
    mov ecx, dword ptr [eax + field_221]         # 0045ac26
    mov dword ptr [0x5bb59b], ecx                # 0045ac2c
    mov edx, dword ptr [ebp - local_10]          # 0045ac32
    movsx eax, word ptr [edx + field_1c]         # 0045ac35
    imul eax, eax, 0x8d                          # 0045ac39
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045ac3f
    mov edx, dword ptr [ecx + field_225]         # 0045ac45
    mov dword ptr [0x5bb59f], edx                # 0045ac4b
    mov eax, dword ptr [ebp - local_10]          # 0045ac51
    movsx ecx, word ptr [eax + field_1c]         # 0045ac54
    imul ecx, ecx, 0x8d                          # 0045ac58
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ac5e
    mov eax, dword ptr [edx + field_229]         # 0045ac64
    mov dword ptr [0x5bb5a3], eax                # 0045ac6a
    mov ecx, dword ptr [ebp - local_10]          # 0045ac6f
    movsx edx, word ptr [ecx + field_1c]         # 0045ac72
    imul edx, edx, 0x8d                          # 0045ac76
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045ac7c
    movsx ecx, word ptr [eax + field_22d]        # 0045ac82
    cmp ecx, 0x1                                 # 0045ac89
    jne.d8 L_0045ac9a                            # 0045ac8c
    # block 0x0045ac8e: entered by fall-through of jne at 0x0045ac8c, 2 instruction(s), ends with forward jump to 0x0045aca4
    mov dword ptr [0x5bb1ca], 0x0                # 0045ac8e
    jmp.d8 L_0045aca4                            # 0045ac98
L_0045ac9a:
    # block 0x0045ac9a: entered by jne at 0x0045ac8c, 1 instruction(s), falls into the block at 0x0045aca4
    mov dword ptr [0x5bb1ca], 0x1                # 0045ac9a
L_0045aca4:
    # block 0x0045aca4: entered by jmp at 0x0045ac98, 4 instruction(s), ends with je to 0x0045acc6 (forward)
    mov dword ptr [0x583999], 0x4                # 0045aca4
    movsx edx, word ptr [0x63a4cd]               # 0045acae
    test edx, edx                                # 0045acb5
    je.d8 L_0045acc6                             # 0045acb7
    # block 0x0045acb9: entered by fall-through of je at 0x0045acb7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045acc6
    push 0x54a8bc                                # 0045acb9
    call FUN_0044a2b7                            # 0045acbe
    add esp, 0x4                                 # 0045acc3
L_0045acc6:
    # block 0x0045acc6: entered by je at 0x0045ab8c; je at 0x0045acb7, 1 instruction(s), ends with forward jump to 0x0045ae25
    jmp.d32 L_0045ae25                           # 0045acc6
L_0045accb:
    # block 0x0045accb: entered by je at 0x0045ab66, 7 instruction(s), ends with je to 0x0045ae25 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045accb
    movsx ecx, word ptr [eax + field_1c]         # 0045acce
    imul ecx, ecx, 0x8d                          # 0045acd2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045acd8
    movsx eax, word ptr [edx + field_265]        # 0045acde
    cmp eax, 0x270f                              # 0045ace5
    je.d32 L_0045ae25                            # 0045acea
    # block 0x0045acf0: entered by fall-through of je at 0x0045acea, 49 instruction(s), ends with jne to 0x0045adf9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045acf0
    movsx edx, word ptr [ecx + field_1c]         # 0045acf3
    imul edx, edx, 0x8d                          # 0045acf7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045acfd
    movsx ecx, word ptr [eax + field_265]        # 0045ad03
    mov dword ptr [0x5bb57b], ecx                # 0045ad0a
    mov edx, dword ptr [ebp - local_10]          # 0045ad10
    movsx eax, word ptr [edx + field_1c]         # 0045ad13
    imul eax, eax, 0x8d                          # 0045ad17
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045ad1d
    mov dx, word ptr [ecx + field_267]           # 0045ad23
    mov word ptr [0x5bb599], dx                  # 0045ad2a
    mov eax, dword ptr [ebp - local_10]          # 0045ad31
    movsx ecx, word ptr [eax + field_1c]         # 0045ad34
    imul ecx, ecx, 0x8d                          # 0045ad38
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ad3e
    mov ax, word ptr [edx + field_269]           # 0045ad44
    mov word ptr [0x5bb595], ax                  # 0045ad4b
    mov ecx, dword ptr [ebp - local_10]          # 0045ad51
    movsx edx, word ptr [ecx + field_1c]         # 0045ad54
    imul edx, edx, 0x8d                          # 0045ad58
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045ad5e
    mov cx, word ptr [eax + field_26b]           # 0045ad64
    mov word ptr [0x5c39ff], cx                  # 0045ad6b
    mov edx, dword ptr [ebp - local_10]          # 0045ad72
    movsx eax, word ptr [edx + field_1c]         # 0045ad75
    imul eax, eax, 0x8d                          # 0045ad79
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045ad7f
    mov edx, dword ptr [ecx + field_26d]         # 0045ad85
    mov dword ptr [0x5bb59b], edx                # 0045ad8b
    mov eax, dword ptr [ebp - local_10]          # 0045ad91
    movsx ecx, word ptr [eax + field_1c]         # 0045ad94
    imul ecx, ecx, 0x8d                          # 0045ad98
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ad9e
    mov eax, dword ptr [edx + field_271]         # 0045ada4
    mov dword ptr [0x5bb59f], eax                # 0045adaa
    mov ecx, dword ptr [ebp - local_10]          # 0045adaf
    movsx edx, word ptr [ecx + field_1c]         # 0045adb2
    imul edx, edx, 0x8d                          # 0045adb6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0045adbc
    mov ecx, dword ptr [eax + field_275]         # 0045adc2
    mov dword ptr [0x5bb5a3], ecx                # 0045adc8
    mov edx, dword ptr [ebp - local_10]          # 0045adce
    movsx eax, word ptr [edx + field_1c]         # 0045add1
    imul eax, eax, 0x8d                          # 0045add5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045addb
    movsx edx, word ptr [ecx + field_279]        # 0045ade1
    cmp edx, 0x1                                 # 0045ade8
    jne.d8 L_0045adf9                            # 0045adeb
    # block 0x0045aded: entered by fall-through of jne at 0x0045adeb, 2 instruction(s), ends with forward jump to 0x0045ae03
    mov dword ptr [0x5bb1ca], 0x0                # 0045aded
    jmp.d8 L_0045ae03                            # 0045adf7
L_0045adf9:
    # block 0x0045adf9: entered by jne at 0x0045adeb, 1 instruction(s), falls into the block at 0x0045ae03
    mov dword ptr [0x5bb1ca], 0x1                # 0045adf9
L_0045ae03:
    # block 0x0045ae03: entered by jmp at 0x0045adf7, 4 instruction(s), ends with je to 0x0045ae25 (forward)
    mov dword ptr [0x583999], 0x4                # 0045ae03
    movsx eax, word ptr [0x63a4cd]               # 0045ae0d
    test eax, eax                                # 0045ae14
    je.d8 L_0045ae25                             # 0045ae16
    # block 0x0045ae18: entered by fall-through of je at 0x0045ae16, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045ae25
    push 0x54a900                                # 0045ae18
    call FUN_0044a2b7                            # 0045ae1d
    add esp, 0x4                                 # 0045ae22
L_0045ae25:
    # block 0x0045ae25: entered by jmp at 0x0045acc6; je at 0x0045acea; je at 0x0045ae16, 7 instruction(s), calls FUN_0042ba3a, FUN_00459b87, falls into the block at 0x0045ae3d
    mov ecx, dword ptr [ebp - local_10]          # 0045ae25
    mov dx, word ptr [ecx + field_1c]            # 0045ae28
    push edx                                     # 0045ae2c
    call FUN_0042ba3a                            # 0045ae2d
    add esp, 0x4                                 # 0045ae32
    mov ecx, dword ptr [ebp - local_10]          # 0045ae35
    call FUN_00459b87                            # 0045ae38
L_0045ae3d:
    # block 0x0045ae3d: entered by jmp at 0x0045a0b7; jmp at 0x0045a670; jmp at 0x0045aab0, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 0045ae3d
    pop esi                                      # 0045ae3e
    pop ebx                                      # 0045ae3f
    {load} mov esp, ebp                          # 0045ae40
    pop ebp                                      # 0045ae42
    ret 0x4                                      # 0045ae43

# --- data items (not part of the function) -------------------------
.org 0x0045ae46 - 0x401000
SWTAB_0045ae46:  # 6 case address(es)
    .long L_0045a695 - .text + 0x401000
    .long L_0045a73e - .text + 0x401000
    .long L_0045a7dc - .text + 0x401000
    .long L_0045a87a - .text + 0x401000
    .long L_0045a9db - .text + 0x401000
    .long L_0045aa47 - .text + 0x401000
.set SWTAB_0045ae46_VA, SWTAB_0045ae46 - .text + 0x401000

