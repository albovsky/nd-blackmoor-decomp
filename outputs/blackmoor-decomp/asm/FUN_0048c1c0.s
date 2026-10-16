# FUN_0048c1c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048c1c0
# extent:       0x0048c1c0-0x0048cc50 (2704 code bytes)
# span:         0x0048c1c0-0x0048cc60 (code 2704, tables 16, padding 0)
# sha256:       b4601410e411322688a32145ca5b85e0c1e39c931681dc7748ac90157abdfabf
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048c1c0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_24, local_28, local_2c, local_30, local_34, local_38, local_3c, local_40, local_48, local_4c
# fields:       [eax + n] field_1c, field_1e, field_22, field_26, field_2e, field_30, field_34, field_37, field_3c, field_41, field_43, field_45 and 13 more; [ecx + n] field_1c, field_1e, field_26, field_2e, field_30, field_34, field_35, field_36, field_37, field_38, field_41, field_43 and 14 more; [edx + n] field_1c, field_1d, field_1e, field_22, field_2e, field_30, field_35, field_36, field_37, field_38, field_3c, field_41 and 17 more
# callees:      calls USER32.dll!IsRectEmpty, FUN_004d39f9, FUN_0050cb1b, FUN_004c2790, FUN_00516530, KERNEL32.dll!GetTickCount, FUN_0050ca3e, FUN_0044a2b7, FUN_0042ba3a, FUN_0048bb86
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 759 instruction(s), 34 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_26, 0x26  # offset +0x26
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_37, 0x37  # offset +0x37
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_44, 0x44  # offset +0x44
.equ field_45, 0x45  # offset +0x45
.equ field_46, 0x46  # offset +0x46
.equ field_47, 0x47  # offset +0x47
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4c, 0x4c  # offset +0x4c
.equ field_4e, 0x4e  # offset +0x4e
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_b4, 0xb4  # offset +0xb4
.equ field_f4, 0xf4  # offset +0xf4
.equ field_134, 0x134  # offset +0x134
.equ field_135, 0x135  # offset +0x135
.equ field_137, 0x137  # offset +0x137
.equ field_139, 0x139  # offset +0x139
.equ field_13b, 0x13b  # offset +0x13b
.equ field_13d, 0x13d  # offset +0x13d
.equ field_141, 0x141  # offset +0x141
.equ field_145, 0x145  # offset +0x145
.equ field_149, 0x149  # offset +0x149
.equ field_14b, 0x14b  # offset +0x14b
.equ field_14d, 0x14d  # offset +0x14d

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0048bb86, .text + (0x0048bb86 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x0048c1c0 - 0x401000
.globl FUN_0048c1c0
FUN_0048c1c0:
    # block 0x0048c1c0: entry, 36 instruction(s), ends with je to 0x0048c249 (forward)
    push ebp                                     # 0048c1c0
    {load} mov ebp, esp                          # 0048c1c1
    sub esp, 0x4c                                # 0048c1c3
    push esi                                     # 0048c1c6
    push edi                                     # 0048c1c7
    mov dword ptr [ebp - local_34], ecx          # 0048c1c8
    mov dword ptr [ebp - local_2c], 0x0          # 0048c1cb
    movsx eax, word ptr [ebp + arg_8]            # 0048c1d2
    imul eax, eax, 0x8d                          # 0048c1d6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048c1dc
    mov dword ptr [ebp - local_30], ecx          # 0048c1e2
    mov ecx, 0x8                                 # 0048c1e5
    {load} xor eax, eax                          # 0048c1ea
    lea edi, [ebp - local_24]                    # 0048c1ec
    rep stosd dword ptr es:[edi], eax            # 0048c1ef
    stosb byte ptr es:[edi], al                  # 0048c1f1
    mov edi, 0x54e640                            # 0048c1f2
    or ecx, -0x1                                 # 0048c1f7
    {load} xor eax, eax                          # 0048c1fa
    repne scasb al, byte ptr es:[edi]            # 0048c1fc
    not ecx                                      # 0048c1fe
    add ecx, -0x1                                # 0048c200
    mov esi, dword ptr [ebp - local_30]          # 0048c203
    lea edi, [ebp - local_24]                    # 0048c206
    {load} mov edx, ecx                          # 0048c209
    shr ecx, 0x2                                 # 0048c20b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048c20e
    {load} mov ecx, edx                          # 0048c210
    and ecx, 0x3                                 # 0048c212
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048c215
    movsx eax, word ptr [ebp + arg_8]            # 0048c217
    imul eax, eax, 0x8d                          # 0048c21b
    mov ecx, dword ptr [eax + 0x5bb632]          # 0048c221
    mov dword ptr [ebp - local_38], ecx          # 0048c227
    cmp dword ptr [ebp - local_38], 0x0          # 0048c22a
    je.d8 L_0048c249                             # 0048c22e
    # block 0x0048c230: entered by fall-through of je at 0x0048c22e, 2 instruction(s), ends with je to 0x0048c80f (forward)
    cmp dword ptr [ebp - local_38], 0x1          # 0048c230
    je.d32 L_0048c80f                            # 0048c234
    # block 0x0048c23a: entered by fall-through of je at 0x0048c234, 2 instruction(s), ends with je to 0x0048cac8 (forward)
    cmp dword ptr [ebp - local_38], 0x2          # 0048c23a
    je.d32 L_0048cac8                            # 0048c23e
    # block 0x0048c244: entered by fall-through of je at 0x0048c23e, 1 instruction(s), ends with forward jump to 0x0048cc48
    jmp.d32 L_0048cc48                           # 0048c244
L_0048c249:
    # block 0x0048c249: entered by je at 0x0048c22e, 36 instruction(s), ends with forward jump to 0x0048c2d5
    mov edx, dword ptr [ebp - local_34]          # 0048c249
    mov byte ptr [edx + field_46], 0x1           # 0048c24c
    mov dword ptr [0x5bb1ca], 0x1                # 0048c250
    mov eax, dword ptr [ebp - local_34]          # 0048c25a
    mov cx, word ptr [ebp + arg_8]               # 0048c25d
    mov word ptr [eax + field_26], cx            # 0048c261
    mov edx, dword ptr [ebp - local_34]          # 0048c265
    mov byte ptr [edx + field_47], 0x0           # 0048c268
    mov eax, dword ptr [ebp - local_34]          # 0048c26c
    mov word ptr [eax + field_54], 0x270f        # 0048c26f
    mov ecx, dword ptr [ebp - local_30]          # 0048c275
    mov edx, dword ptr [ebp - local_30]          # 0048c278
    mov eax, dword ptr [ecx + field_50]          # 0048c27b
    sub eax, dword ptr [edx + field_60]          # 0048c27e
    mov ecx, dword ptr [ebp - local_34]          # 0048c281
    mov word ptr [ecx + field_4c], ax            # 0048c284
    mov edx, dword ptr [ebp - local_30]          # 0048c288
    mov eax, dword ptr [ebp - local_30]          # 0048c28b
    mov ecx, dword ptr [edx + field_48]          # 0048c28e
    sub ecx, dword ptr [eax + field_58]          # 0048c291
    mov edx, dword ptr [ebp - local_34]          # 0048c294
    mov word ptr [edx + field_4e], cx            # 0048c297
    mov eax, dword ptr [ebp - local_30]          # 0048c29b
    mov ecx, dword ptr [ebp - local_30]          # 0048c29e
    mov edx, dword ptr [eax + field_4c]          # 0048c2a1
    sub edx, dword ptr [ecx + field_5c]          # 0048c2a4
    mov eax, dword ptr [ebp - local_34]          # 0048c2a7
    mov word ptr [eax + field_48], dx            # 0048c2aa
    mov ecx, dword ptr [ebp - local_30]          # 0048c2ae
    mov edx, dword ptr [ebp - local_30]          # 0048c2b1
    mov eax, dword ptr [ecx + field_44]          # 0048c2b4
    sub eax, dword ptr [edx + field_54]          # 0048c2b7
    mov ecx, dword ptr [ebp - local_34]          # 0048c2ba
    mov word ptr [ecx + field_4a], ax            # 0048c2bd
    mov word ptr [ebp - local_28], 0x0           # 0048c2c1
    jmp.d8 L_0048c2d5                            # 0048c2c7
L_0048c2c9:
    # block 0x0048c2c9: entered by jmp at 0x0048c356, 3 instruction(s), falls into the block at 0x0048c2d5
    mov dx, word ptr [ebp - local_28]            # 0048c2c9
    add dx, 0x1                                  # 0048c2cd
    mov word ptr [ebp - local_28], dx            # 0048c2d1
L_0048c2d5:
    # block 0x0048c2d5: entered by jmp at 0x0048c2c7, 3 instruction(s), ends with jge to 0x0048c35b (forward)
    movsx eax, word ptr [ebp - local_28]         # 0048c2d5
    cmp eax, 0x4                                 # 0048c2d9
    jge.d8 L_0048c35b                            # 0048c2dc
    # block 0x0048c2de: entered by fall-through of jge at 0x0048c2dc, 8 instruction(s), calls USER32.dll!IsRectEmpty, ends with je to 0x0048c308 (forward)
    movsx ecx, word ptr [ebp - local_28]         # 0048c2de
    shl ecx, 0x4                                 # 0048c2e2
    mov edx, dword ptr [ebp - local_30]          # 0048c2e5
    lea eax, [edx + ecx + field_f4]              # 0048c2e8
    push eax                                     # 0048c2ef
    call dword ptr [0x52a4a8]                    # 0048c2f0
    test eax, eax                                # 0048c2f6
    je.d8 L_0048c308                             # 0048c2f8
    # block 0x0048c2fa: entered by fall-through of je at 0x0048c2f8, 4 instruction(s), ends with forward jump to 0x0048c314
    movsx ecx, word ptr [ebp - local_28]         # 0048c2fa
    mov edx, dword ptr [ebp - local_34]          # 0048c2fe
    mov byte ptr [edx + ecx + field_38], 0x0     # 0048c301
    jmp.d8 L_0048c314                            # 0048c306
L_0048c308:
    # block 0x0048c308: entered by je at 0x0048c2f8, 3 instruction(s), falls into the block at 0x0048c314
    movsx eax, word ptr [ebp - local_28]         # 0048c308
    mov ecx, dword ptr [ebp - local_34]          # 0048c30c
    mov byte ptr [ecx + eax + field_38], 0x1     # 0048c30f
L_0048c314:
    # block 0x0048c314: entered by jmp at 0x0048c306, 8 instruction(s), calls USER32.dll!IsRectEmpty, ends with je to 0x0048c33e (forward)
    movsx edx, word ptr [ebp - local_28]         # 0048c314
    shl edx, 0x4                                 # 0048c318
    mov eax, dword ptr [ebp - local_30]          # 0048c31b
    lea ecx, [eax + edx + field_b4]              # 0048c31e
    push ecx                                     # 0048c325
    call dword ptr [0x52a4a8]                    # 0048c326
    test eax, eax                                # 0048c32c
    je.d8 L_0048c33e                             # 0048c32e
    # block 0x0048c330: entered by fall-through of je at 0x0048c32e, 4 instruction(s), ends with forward jump to 0x0048c34a
    movsx edx, word ptr [ebp - local_28]         # 0048c330
    mov eax, dword ptr [ebp - local_34]          # 0048c334
    mov byte ptr [eax + edx + field_3c], 0x0     # 0048c337
    jmp.d8 L_0048c34a                            # 0048c33c
L_0048c33e:
    # block 0x0048c33e: entered by je at 0x0048c32e, 3 instruction(s), falls into the block at 0x0048c34a
    movsx ecx, word ptr [ebp - local_28]         # 0048c33e
    mov edx, dword ptr [ebp - local_34]          # 0048c342
    mov byte ptr [edx + ecx + field_3c], 0x1     # 0048c345
L_0048c34a:
    # block 0x0048c34a: entered by jmp at 0x0048c33c, 4 instruction(s), ends with backward jump to 0x0048c2c9
    movsx eax, word ptr [ebp - local_28]         # 0048c34a
    mov ecx, dword ptr [ebp - local_34]          # 0048c34e
    mov byte ptr [ecx + eax + field_34], 0x1     # 0048c351
    jmp.d32 L_0048c2c9                           # 0048c356
L_0048c35b:
    # block 0x0048c35b: entered by jge at 0x0048c2dc, 61 instruction(s), calls FUN_004d39f9, ends with jne to 0x0048c5e3 (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048c35b
    mov byte ptr [edx + field_1d], 0x1           # 0048c35e
    call FUN_004d39f9                            # 0048c362
    mov ecx, dword ptr [ebp - local_34]          # 0048c367
    mov word ptr [ecx + field_2e], ax            # 0048c36a
    mov edx, dword ptr [ebp - local_34]          # 0048c36e
    movsx eax, word ptr [edx + field_2e]         # 0048c371
    imul eax, eax, 0x4a                          # 0048c375
    mov dword ptr [eax + 0x5d1591], 0xa          # 0048c378
    mov ecx, dword ptr [ebp - local_34]          # 0048c382
    movsx edx, word ptr [ecx + field_2e]         # 0048c385
    imul edx, edx, 0x4a                          # 0048c389
    mov dword ptr [edx + 0x5d1595], 0x48cc70     # 0048c38c
    mov eax, dword ptr [ebp - local_34]          # 0048c396
    movsx ecx, word ptr [eax + field_2e]         # 0048c399
    imul ecx, ecx, 0x4a                          # 0048c39d
    mov edx, dword ptr [ebp - local_34]          # 0048c3a0
    mov eax, dword ptr [edx + field_1e]          # 0048c3a3
    mov dword ptr [ecx + 0x5d1599], eax          # 0048c3a6
    mov ecx, dword ptr [ebp - local_34]          # 0048c3ac
    movsx edx, word ptr [ecx + field_2e]         # 0048c3af
    imul edx, edx, 0x4a                          # 0048c3b3
    mov dword ptr [edx + 0x5d159d], 0x0          # 0048c3b6
    mov eax, dword ptr [ebp - local_34]          # 0048c3c0
    movsx ecx, word ptr [eax + field_2e]         # 0048c3c3
    imul ecx, ecx, 0x4a                          # 0048c3c7
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 0048c3ca
    mov edx, dword ptr [ebp - local_34]          # 0048c3d4
    movsx eax, word ptr [edx + field_2e]         # 0048c3d7
    imul eax, eax, 0x4a                          # 0048c3db
    mov dword ptr [eax + 0x5d15a5], 0x1          # 0048c3de
    mov ecx, dword ptr [ebp - local_34]          # 0048c3e8
    movsx edx, word ptr [ecx + field_2e]         # 0048c3eb
    imul edx, edx, 0x4a                          # 0048c3ef
    mov dword ptr [edx + 0x5d15a9], 0x1          # 0048c3f2
    mov eax, dword ptr [ebp - local_34]          # 0048c3fc
    movsx ecx, word ptr [eax + field_2e]         # 0048c3ff
    imul ecx, ecx, 0x4a                          # 0048c403
    mov word ptr [ecx + 0x5d15ad], 0x0           # 0048c406
    mov edi, 0x54e650                            # 0048c40f
    mov edx, dword ptr [ebp - local_34]          # 0048c414
    movsx eax, word ptr [edx + field_2e]         # 0048c417
    imul eax, eax, 0x4a                          # 0048c41b
    add eax, 0x5d15b3                            # 0048c41e
    {load} mov edx, eax                          # 0048c423
    or ecx, -0x1                                 # 0048c425
    {load} xor eax, eax                          # 0048c428
    repne scasb al, byte ptr es:[edi]            # 0048c42a
    not ecx                                      # 0048c42c
    {load} sub edi, ecx                          # 0048c42e
    {load} mov esi, edi                          # 0048c430
    {load} mov eax, ecx                          # 0048c432
    {load} mov edi, edx                          # 0048c434
    shr ecx, 0x2                                 # 0048c436
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048c439
    {load} mov ecx, eax                          # 0048c43b
    and ecx, 0x3                                 # 0048c43d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048c440
    mov ecx, dword ptr [ebp - local_34]          # 0048c442
    cmp dword ptr [ecx + field_1e], 0x0          # 0048c445
    jne.d32 L_0048c5e3                           # 0048c449
    # block 0x0048c44f: entered by fall-through of jne at 0x0048c449, 6 instruction(s), ends with jne to 0x0048c48d (forward)
    mov edi, 0x54e668                            # 0048c44f
    mov esi, dword ptr [ebp - local_30]          # 0048c454
    mov ecx, 0xe                                 # 0048c457
    {load} xor edx, edx                          # 0048c45c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048c45e
    jne.d8 L_0048c48d                            # 0048c460
    # block 0x0048c462: entered by fall-through of jne at 0x0048c460, 11 instruction(s), ends with forward jump to 0x0048c5e3
    mov eax, dword ptr [ebp - local_34]          # 0048c462
    mov ecx, dword ptr [0x5d0397]                # 0048c465
    mov dword ptr [eax + field_1e], ecx          # 0048c46b
    mov edx, dword ptr [ebp - local_34]          # 0048c46e
    mov byte ptr [edx + field_45], 0x1           # 0048c471
    mov eax, dword ptr [ebp - local_30]          # 0048c475
    mov ecx, dword ptr [0x619a53]                # 0048c478
    sub ecx, dword ptr [eax + field_60]          # 0048c47e
    mov edx, dword ptr [ebp - local_34]          # 0048c481
    mov word ptr [edx + field_4c], cx            # 0048c484
    jmp.d32 L_0048c5e3                           # 0048c488
L_0048c48d:
    # block 0x0048c48d: entered by jne at 0x0048c460, 6 instruction(s), ends with jne to 0x0048c4cb (forward)
    mov edi, 0x54e678                            # 0048c48d
    mov esi, dword ptr [ebp - local_30]          # 0048c492
    mov ecx, 0xe                                 # 0048c495
    {load} xor eax, eax                          # 0048c49a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048c49c
    jne.d8 L_0048c4cb                            # 0048c49e
    # block 0x0048c4a0: entered by fall-through of jne at 0x0048c49e, 11 instruction(s), ends with forward jump to 0x0048c5e3
    mov ecx, dword ptr [ebp - local_34]          # 0048c4a0
    mov edx, dword ptr [0x5d039b]                # 0048c4a3
    mov dword ptr [ecx + field_1e], edx          # 0048c4a9
    mov eax, dword ptr [ebp - local_34]          # 0048c4ac
    mov byte ptr [eax + field_45], 0x1           # 0048c4af
    mov ecx, dword ptr [ebp - local_30]          # 0048c4b3
    mov edx, dword ptr [0x619a57]                # 0048c4b6
    sub edx, dword ptr [ecx + field_60]          # 0048c4bc
    mov eax, dword ptr [ebp - local_34]          # 0048c4bf
    mov word ptr [eax + field_4c], dx            # 0048c4c2
    jmp.d32 L_0048c5e3                           # 0048c4c6
L_0048c4cb:
    # block 0x0048c4cb: entered by jne at 0x0048c49e, 6 instruction(s), ends with jne to 0x0048c509 (forward)
    mov edi, 0x54e688                            # 0048c4cb
    mov esi, dword ptr [ebp - local_30]          # 0048c4d0
    mov ecx, 0xe                                 # 0048c4d3
    {load} xor edx, edx                          # 0048c4d8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048c4da
    jne.d8 L_0048c509                            # 0048c4dc
    # block 0x0048c4de: entered by fall-through of jne at 0x0048c4dc, 11 instruction(s), ends with forward jump to 0x0048c5e3
    mov eax, dword ptr [ebp - local_34]          # 0048c4de
    mov ecx, dword ptr [0x5d039f]                # 0048c4e1
    mov dword ptr [eax + field_1e], ecx          # 0048c4e7
    mov edx, dword ptr [ebp - local_34]          # 0048c4ea
    mov byte ptr [edx + field_45], 0x1           # 0048c4ed
    mov eax, dword ptr [ebp - local_30]          # 0048c4f1
    mov ecx, dword ptr [0x619a5b]                # 0048c4f4
    sub ecx, dword ptr [eax + field_60]          # 0048c4fa
    mov edx, dword ptr [ebp - local_34]          # 0048c4fd
    mov word ptr [edx + field_4c], cx            # 0048c500
    jmp.d32 L_0048c5e3                           # 0048c504
L_0048c509:
    # block 0x0048c509: entered by jne at 0x0048c4dc, 6 instruction(s), ends with jne to 0x0048c5bc (forward)
    mov edi, 0x54e698                            # 0048c509
    lea esi, [ebp - local_24]                    # 0048c50e
    mov ecx, 0xd                                 # 0048c511
    {load} xor eax, eax                          # 0048c516
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048c518
    jne.d32 L_0048c5bc                           # 0048c51a
    # block 0x0048c520: entered by fall-through of jne at 0x0048c51a, 54 instruction(s), calls FUN_0050cb1b, ends with forward jump to 0x0048c5e3
    mov ecx, 0x8                                 # 0048c520
    {load} xor eax, eax                          # 0048c525
    lea edi, [ebp - local_24]                    # 0048c527
    rep stosd dword ptr es:[edi], eax            # 0048c52a
    stosb byte ptr es:[edi], al                  # 0048c52c
    mov edi, dword ptr [ebp - local_30]          # 0048c52d
    or ecx, -0x1                                 # 0048c530
    {load} xor eax, eax                          # 0048c533
    repne scasb al, byte ptr es:[edi]            # 0048c535
    not ecx                                      # 0048c537
    add ecx, -0x1                                # 0048c539
    {load} mov edx, ecx                          # 0048c53c
    mov edi, 0x54e6a8                            # 0048c53e
    or ecx, -0x1                                 # 0048c543
    {load} xor eax, eax                          # 0048c546
    repne scasb al, byte ptr es:[edi]            # 0048c548
    not ecx                                      # 0048c54a
    add ecx, -0x1                                # 0048c54c
    {load} sub edx, ecx                          # 0048c54f
    mov edi, 0x54e6b8                            # 0048c551
    or ecx, -0x1                                 # 0048c556
    {load} xor eax, eax                          # 0048c559
    repne scasb al, byte ptr es:[edi]            # 0048c55b
    not ecx                                      # 0048c55d
    add ecx, -0x1                                # 0048c55f
    mov esi, dword ptr [ebp - local_30]          # 0048c562
    {load} add esi, ecx                          # 0048c565
    lea edi, [ebp - local_24]                    # 0048c567
    {load} mov ecx, edx                          # 0048c56a
    {load} mov eax, ecx                          # 0048c56c
    shr ecx, 0x2                                 # 0048c56e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048c571
    {load} mov ecx, eax                          # 0048c573
    and ecx, 0x3                                 # 0048c575
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048c578
    lea ecx, [ebp - local_24]                    # 0048c57a
    push ecx                                     # 0048c57d
    call FUN_0050cb1b                            # 0048c57e
    add esp, 0x4                                 # 0048c583
    mov edx, dword ptr [ebp - local_34]          # 0048c586
    mov eax, dword ptr [4*eax + 0x5d039f]        # 0048c589
    mov dword ptr [edx + field_1e], eax          # 0048c590
    mov ecx, dword ptr [ebp - local_34]          # 0048c593
    mov byte ptr [ecx + field_45], 0x1           # 0048c596
    lea edx, [ebp - local_24]                    # 0048c59a
    push edx                                     # 0048c59d
    call FUN_0050cb1b                            # 0048c59e
    add esp, 0x4                                 # 0048c5a3
    mov ecx, dword ptr [ebp - local_30]          # 0048c5a6
    mov edx, dword ptr [4*eax + 0x619a5b]        # 0048c5a9
    sub edx, dword ptr [ecx + field_60]          # 0048c5b0
    mov eax, dword ptr [ebp - local_34]          # 0048c5b3
    mov word ptr [eax + field_4c], dx            # 0048c5b6
    jmp.d8 L_0048c5e3                            # 0048c5ba
L_0048c5bc:
    # block 0x0048c5bc: entered by jne at 0x0048c51a, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x0048c5e3
    push 0x54e6c8                                # 0048c5bc
    push 0x6                                     # 0048c5c1
    mov ecx, dword ptr [ebp - local_30]          # 0048c5c3
    push ecx                                     # 0048c5c6
    push 0x54e6e4                                # 0048c5c7
    mov ecx, 0x5cf659                            # 0048c5cc
    call FUN_004c2790                            # 0048c5d1
    mov edx, dword ptr [ebp - local_34]          # 0048c5d6
    mov dword ptr [edx + field_1e], eax          # 0048c5d9
    mov eax, dword ptr [ebp - local_34]          # 0048c5dc
    mov byte ptr [eax + field_45], 0x0           # 0048c5df
L_0048c5e3:
    # block 0x0048c5e3: entered by jne at 0x0048c449; jmp at 0x0048c488; jmp at 0x0048c4c6; jmp at 0x0048c504; more, 71 instruction(s), calls FUN_004d39f9, ends with jbe to 0x0048c735 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 0048c5e3
    movsx edx, word ptr [ecx + field_2e]         # 0048c5e6
    imul edx, edx, 0x4a                          # 0048c5ea
    mov eax, dword ptr [ebp - local_34]          # 0048c5ed
    mov ecx, dword ptr [eax + field_1e]          # 0048c5f0
    mov dword ptr [edx + 0x5d1599], ecx          # 0048c5f3
    call FUN_004d39f9                            # 0048c5f9
    mov edx, dword ptr [ebp - local_34]          # 0048c5fe
    mov word ptr [edx + field_30], ax            # 0048c601
    mov eax, dword ptr [ebp - local_34]          # 0048c605
    movsx ecx, word ptr [eax + field_30]         # 0048c608
    imul ecx, ecx, 0x4a                          # 0048c60c
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0048c60f
    mov edx, dword ptr [ebp - local_34]          # 0048c619
    movsx eax, word ptr [edx + field_30]         # 0048c61c
    imul eax, eax, 0x4a                          # 0048c620
    mov dword ptr [eax + 0x5d1595], 0x48cc70     # 0048c623
    mov ecx, dword ptr [ebp - local_34]          # 0048c62d
    movsx edx, word ptr [ecx + field_30]         # 0048c630
    imul edx, edx, 0x4a                          # 0048c634
    mov eax, dword ptr [ebp - local_34]          # 0048c637
    mov ecx, dword ptr [eax + field_22]          # 0048c63a
    mov dword ptr [edx + 0x5d1599], ecx          # 0048c63d
    mov edx, dword ptr [ebp - local_34]          # 0048c643
    movsx eax, word ptr [edx + field_30]         # 0048c646
    imul eax, eax, 0x4a                          # 0048c64a
    mov dword ptr [eax + 0x5d159d], 0x0          # 0048c64d
    mov ecx, dword ptr [ebp - local_34]          # 0048c657
    movsx edx, word ptr [ecx + field_30]         # 0048c65a
    imul edx, edx, 0x4a                          # 0048c65e
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0048c661
    mov eax, dword ptr [ebp - local_34]          # 0048c66b
    movsx ecx, word ptr [eax + field_30]         # 0048c66e
    imul ecx, ecx, 0x4a                          # 0048c672
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048c675
    mov edx, dword ptr [ebp - local_34]          # 0048c67f
    movsx eax, word ptr [edx + field_30]         # 0048c682
    imul eax, eax, 0x4a                          # 0048c686
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0048c689
    mov ecx, dword ptr [ebp - local_34]          # 0048c693
    movsx edx, word ptr [ecx + field_30]         # 0048c696
    imul edx, edx, 0x4a                          # 0048c69a
    mov word ptr [edx + 0x5d15ad], 0x0           # 0048c69d
    mov edi, 0x54e6ec                            # 0048c6a6
    mov eax, dword ptr [ebp - local_34]          # 0048c6ab
    movsx ecx, word ptr [eax + field_30]         # 0048c6ae
    imul ecx, ecx, 0x4a                          # 0048c6b2
    add ecx, 0x5d15b3                            # 0048c6b5
    {load} mov edx, ecx                          # 0048c6bb
    or ecx, -0x1                                 # 0048c6bd
    {load} xor eax, eax                          # 0048c6c0
    repne scasb al, byte ptr es:[edi]            # 0048c6c2
    not ecx                                      # 0048c6c4
    {load} sub edi, ecx                          # 0048c6c6
    {load} mov esi, edi                          # 0048c6c8
    {load} mov eax, ecx                          # 0048c6ca
    {load} mov edi, edx                          # 0048c6cc
    shr ecx, 0x2                                 # 0048c6ce
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048c6d1
    {load} mov ecx, eax                          # 0048c6d3
    and ecx, 0x3                                 # 0048c6d5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048c6d8
    mov edi, dword ptr [ebp - local_30]          # 0048c6da
    add edi, 0x21                                # 0048c6dd
    or ecx, -0x1                                 # 0048c6e0
    {load} xor eax, eax                          # 0048c6e3
    repne scasb al, byte ptr es:[edi]            # 0048c6e5
    not ecx                                      # 0048c6e7
    add ecx, -0x1                                # 0048c6e9
    test ecx, ecx                                # 0048c6ec
    jbe.d8 L_0048c735                            # 0048c6ee
    # block 0x0048c6f0: entered by fall-through of jbe at 0x0048c6ee, 9 instruction(s), calls FUN_00516530, ends with je to 0x0048c735 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0048c6f0
    add ecx, 0x21                                # 0048c6f3
    push ecx                                     # 0048c6f6
    mov edx, dword ptr [ebp - local_30]          # 0048c6f7
    push edx                                     # 0048c6fa
    call FUN_00516530                            # 0048c6fb
    add esp, 0x8                                 # 0048c700
    test eax, eax                                # 0048c703
    je.d8 L_0048c735                             # 0048c705
    # block 0x0048c707: entered by fall-through of je at 0x0048c705, 3 instruction(s), ends with jne to 0x0048c733 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048c707
    cmp dword ptr [eax + field_22], 0x0          # 0048c70a
    jne.d8 L_0048c733                            # 0048c70e
    # block 0x0048c710: entered by fall-through of jne at 0x0048c70e, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x0048c733
    push 0x54e708                                # 0048c710
    push 0x6                                     # 0048c715
    mov ecx, dword ptr [ebp - local_30]          # 0048c717
    add ecx, 0x21                                # 0048c71a
    push ecx                                     # 0048c71d
    push 0x54e724                                # 0048c71e
    mov ecx, 0x5cf659                            # 0048c723
    call FUN_004c2790                            # 0048c728
    mov edx, dword ptr [ebp - local_34]          # 0048c72d
    mov dword ptr [edx + field_22], eax          # 0048c730
L_0048c733:
    # block 0x0048c733: entered by jne at 0x0048c70e, 1 instruction(s), ends with forward jump to 0x0048c741
    jmp.d8 L_0048c741                            # 0048c733
L_0048c735:
    # block 0x0048c735: entered by jbe at 0x0048c6ee; je at 0x0048c705, 4 instruction(s), falls into the block at 0x0048c741
    mov eax, dword ptr [ebp - local_34]          # 0048c735
    mov ecx, dword ptr [ebp - local_34]          # 0048c738
    mov edx, dword ptr [ecx + field_1e]          # 0048c73b
    mov dword ptr [eax + field_22], edx          # 0048c73e
L_0048c741:
    # block 0x0048c741: entered by jmp at 0x0048c733, 12 instruction(s), ends with jl to 0x0048c77e (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048c741
    movsx ecx, word ptr [eax + field_30]         # 0048c744
    imul ecx, ecx, 0x4a                          # 0048c748
    mov edx, dword ptr [ebp - local_34]          # 0048c74b
    mov eax, dword ptr [edx + field_22]          # 0048c74e
    mov dword ptr [ecx + 0x5d1599], eax          # 0048c751
    mov ecx, dword ptr [ebp - local_34]          # 0048c757
    movsx edx, word ptr [ecx + field_43]         # 0048c75a
    mov eax, dword ptr [ebp - local_34]          # 0048c75e
    movsx ecx, word ptr [eax + field_4c]         # 0048c761
    {load} cmp edx, ecx                          # 0048c765
    jl.d8 L_0048c77e                             # 0048c767
    # block 0x0048c769: entered by fall-through of jl at 0x0048c767, 6 instruction(s), falls into the block at 0x0048c77e
    mov edx, dword ptr [ebp - local_34]          # 0048c769
    mov eax, dword ptr [ebp - local_34]          # 0048c76c
    mov cx, word ptr [eax + field_4c]            # 0048c76f
    mov word ptr [edx + field_43], cx            # 0048c773
    mov edx, dword ptr [ebp - local_34]          # 0048c777
    mov byte ptr [edx + field_35], 0x0           # 0048c77a
L_0048c77e:
    # block 0x0048c77e: entered by jl at 0x0048c767, 6 instruction(s), ends with jg to 0x0048c7a5 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048c77e
    movsx ecx, word ptr [eax + field_43]         # 0048c781
    mov edx, dword ptr [ebp - local_34]          # 0048c785
    movsx eax, word ptr [edx + field_4e]         # 0048c788
    {load} cmp ecx, eax                          # 0048c78c
    jg.d8 L_0048c7a5                             # 0048c78e
    # block 0x0048c790: entered by fall-through of jg at 0x0048c78e, 6 instruction(s), falls into the block at 0x0048c7a5
    mov ecx, dword ptr [ebp - local_34]          # 0048c790
    mov edx, dword ptr [ebp - local_34]          # 0048c793
    mov ax, word ptr [edx + field_4e]            # 0048c796
    mov word ptr [ecx + field_43], ax            # 0048c79a
    mov ecx, dword ptr [ebp - local_34]          # 0048c79e
    mov byte ptr [ecx + field_34], 0x0           # 0048c7a1
L_0048c7a5:
    # block 0x0048c7a5: entered by jg at 0x0048c78e, 6 instruction(s), ends with jl to 0x0048c7cc (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048c7a5
    movsx eax, word ptr [edx + field_41]         # 0048c7a8
    mov ecx, dword ptr [ebp - local_34]          # 0048c7ac
    movsx edx, word ptr [ecx + field_48]         # 0048c7af
    {load} cmp eax, edx                          # 0048c7b3
    jl.d8 L_0048c7cc                             # 0048c7b5
    # block 0x0048c7b7: entered by fall-through of jl at 0x0048c7b5, 6 instruction(s), falls into the block at 0x0048c7cc
    mov eax, dword ptr [ebp - local_34]          # 0048c7b7
    mov ecx, dword ptr [ebp - local_34]          # 0048c7ba
    mov dx, word ptr [ecx + field_48]            # 0048c7bd
    mov word ptr [eax + field_41], dx            # 0048c7c1
    mov eax, dword ptr [ebp - local_34]          # 0048c7c5
    mov byte ptr [eax + field_37], 0x0           # 0048c7c8
L_0048c7cc:
    # block 0x0048c7cc: entered by jl at 0x0048c7b5, 6 instruction(s), ends with jg to 0x0048c7f3 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 0048c7cc
    movsx edx, word ptr [ecx + field_41]         # 0048c7cf
    mov eax, dword ptr [ebp - local_34]          # 0048c7d3
    movsx ecx, word ptr [eax + field_4a]         # 0048c7d6
    {load} cmp edx, ecx                          # 0048c7da
    jg.d8 L_0048c7f3                             # 0048c7dc
    # block 0x0048c7de: entered by fall-through of jg at 0x0048c7dc, 6 instruction(s), falls into the block at 0x0048c7f3
    mov edx, dword ptr [ebp - local_34]          # 0048c7de
    mov eax, dword ptr [ebp - local_34]          # 0048c7e1
    mov cx, word ptr [eax + field_4a]            # 0048c7e4
    mov word ptr [edx + field_41], cx            # 0048c7e8
    mov edx, dword ptr [ebp - local_34]          # 0048c7ec
    mov byte ptr [edx + field_36], 0x0           # 0048c7ef
L_0048c7f3:
    # block 0x0048c7f3: entered by jg at 0x0048c7dc, 5 instruction(s), ends with forward jump to 0x0048cc48
    mov eax, dword ptr [ebp - local_34]          # 0048c7f3
    movsx ecx, word ptr [eax + field_26]         # 0048c7f6
    imul ecx, ecx, 0x8d                          # 0048c7fa
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0048c800
    jmp.d32 L_0048cc48                           # 0048c80a
L_0048c80f:
    # block 0x0048c80f: entered by je at 0x0048c234, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0048c87f (forward)
    call dword ptr [0x52a23c]                    # 0048c80f
    mov dword ptr [ebp - local_2c], eax          # 0048c815
    movsx edx, word ptr [0x63a4cd]               # 0048c818
    test edx, edx                                # 0048c81f
    je.d8 L_0048c87f                             # 0048c821
    # block 0x0048c823: entered by fall-through of je at 0x0048c821, 27 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0048c87f
    mov eax, dword ptr [ebp - local_34]          # 0048c823
    mov ecx, dword ptr [ebp - local_2c]          # 0048c826
    sub ecx, dword ptr [eax + field_50]          # 0048c829
    mov dword ptr [ebp - local_40], ecx          # 0048c82c
    mov dword ptr [ebp - local_3c], 0x0          # 0048c82f
    fild qword ptr [ebp - local_40]              # 0048c836
    fstp qword ptr [ebp - local_48]              # 0048c839
    fld qword ptr [ebp - local_48]               # 0048c83c
    fdiv qword ptr [0x52c680]                    # 0048c83f
    sub esp, 0x8                                 # 0048c845
    fstp qword ptr [esp]                         # 0048c848
    mov edx, dword ptr [ebp - local_34]          # 0048c84b
    mov eax, dword ptr [ebp - local_2c]          # 0048c84e
    sub eax, dword ptr [edx + field_50]          # 0048c851
    push eax                                     # 0048c854
    mov ecx, dword ptr [ebp - local_2c]          # 0048c855
    push ecx                                     # 0048c858
    mov edx, dword ptr [ebp - local_34]          # 0048c859
    mov eax, dword ptr [edx + field_50]          # 0048c85c
    push eax                                     # 0048c85f
    push 0x54e72c                                # 0048c860
    push 0x63888b                                # 0048c865
    call FUN_0050ca3e                            # 0048c86a
    add esp, 0x1c                                # 0048c86f
    push 0x63888b                                # 0048c872
    call FUN_0044a2b7                            # 0048c877
    add esp, 0x4                                 # 0048c87c
L_0048c87f:
    # block 0x0048c87f: entered by je at 0x0048c821, 12 instruction(s), ends with jae to 0x0048c8a6 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 0048c87f
    mov esi, dword ptr [ebp - local_2c]          # 0048c882
    sub esi, dword ptr [ecx + field_50]          # 0048c885
    mov edx, dword ptr [ebp - local_30]          # 0048c888
    {load} xor eax, eax                          # 0048c88b
    mov al, byte ptr [edx + field_134]           # 0048c88d
    {load} mov ecx, eax                          # 0048c893
    mov eax, 0x3e8                               # 0048c895
    cdq                                          # 0048c89a
    idiv ecx                                     # 0048c89b
    {load} cmp esi, eax                          # 0048c89d
    jae.d8 L_0048c8a6                            # 0048c89f
    # block 0x0048c8a1: entered by fall-through of jae at 0x0048c89f, 1 instruction(s), ends with forward jump to 0x0048cc48
    jmp.d32 L_0048cc48                           # 0048c8a1
L_0048c8a6:
    # block 0x0048c8a6: entered by jae at 0x0048c89f, 6 instruction(s), ends with ja to 0x0048c9c6 (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048c8a6
    {load} xor eax, eax                          # 0048c8a9
    mov al, byte ptr [edx + field_1c]            # 0048c8ab
    mov dword ptr [ebp - local_4c], eax          # 0048c8ae
    cmp dword ptr [ebp - local_4c], 0x3          # 0048c8b1
    ja.d32 L_0048c9c6                            # 0048c8b5
    # block 0x0048c8bb: entered by fall-through of ja at 0x0048c8b5, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x48cc50]
    mov ecx, dword ptr [ebp - local_4c]          # 0048c8bb
    jmp dword ptr [4*ecx + SWTAB_0048cc50_VA]    # 0048c8be
L_0048c8c5:
    # block 0x0048c8c5: entered by switch case, 22 instruction(s), ends with forward jump to 0x0048c9c6
    mov edx, dword ptr [ebp - local_34]          # 0048c8c5
    mov ecx, dword ptr [ebp - local_2c]          # 0048c8c8
    sub ecx, dword ptr [edx + field_50]          # 0048c8cb
    mov edx, dword ptr [ebp - local_30]          # 0048c8ce
    {load} xor eax, eax                          # 0048c8d1
    mov al, byte ptr [edx + field_134]           # 0048c8d3
    {load} mov esi, eax                          # 0048c8d9
    mov eax, 0x3e8                               # 0048c8db
    cdq                                          # 0048c8e0
    idiv esi                                     # 0048c8e1
    {load} mov esi, eax                          # 0048c8e3
    {load} mov eax, ecx                          # 0048c8e5
    {load} xor edx, edx                          # 0048c8e7
    div esi                                      # 0048c8e9
    mov ecx, dword ptr [ebp - local_34]          # 0048c8eb
    mov dx, word ptr [ecx + field_43]            # 0048c8ee
    {load} sub dx, ax                            # 0048c8f2
    mov eax, dword ptr [ebp - local_34]          # 0048c8f5
    mov word ptr [eax + field_43], dx            # 0048c8f8
    mov ecx, dword ptr [ebp - local_34]          # 0048c8fc
    mov byte ptr [ecx + field_35], 0x1           # 0048c8ff
    jmp.d32 L_0048c9c6                           # 0048c903
L_0048c908:
    # block 0x0048c908: entered by switch case, 22 instruction(s), ends with forward jump to 0x0048c9c6
    mov edx, dword ptr [ebp - local_34]          # 0048c908
    mov ecx, dword ptr [ebp - local_2c]          # 0048c90b
    sub ecx, dword ptr [edx + field_50]          # 0048c90e
    mov edx, dword ptr [ebp - local_30]          # 0048c911
    {load} xor eax, eax                          # 0048c914
    mov al, byte ptr [edx + field_134]           # 0048c916
    {load} mov esi, eax                          # 0048c91c
    mov eax, 0x3e8                               # 0048c91e
    cdq                                          # 0048c923
    idiv esi                                     # 0048c924
    {load} mov esi, eax                          # 0048c926
    {load} mov eax, ecx                          # 0048c928
    {load} xor edx, edx                          # 0048c92a
    div esi                                      # 0048c92c
    mov ecx, dword ptr [ebp - local_34]          # 0048c92e
    mov dx, word ptr [ecx + field_43]            # 0048c931
    {load} add dx, ax                            # 0048c935
    mov eax, dword ptr [ebp - local_34]          # 0048c938
    mov word ptr [eax + field_43], dx            # 0048c93b
    mov ecx, dword ptr [ebp - local_34]          # 0048c93f
    mov byte ptr [ecx + field_34], 0x1           # 0048c942
    jmp.d8 L_0048c9c6                            # 0048c946
L_0048c948:
    # block 0x0048c948: entered by switch case, 22 instruction(s), ends with forward jump to 0x0048c9c6
    mov edx, dword ptr [ebp - local_34]          # 0048c948
    mov ecx, dword ptr [ebp - local_2c]          # 0048c94b
    sub ecx, dword ptr [edx + field_50]          # 0048c94e
    mov edx, dword ptr [ebp - local_30]          # 0048c951
    {load} xor eax, eax                          # 0048c954
    mov al, byte ptr [edx + field_134]           # 0048c956
    {load} mov esi, eax                          # 0048c95c
    mov eax, 0x3e8                               # 0048c95e
    cdq                                          # 0048c963
    idiv esi                                     # 0048c964
    {load} mov esi, eax                          # 0048c966
    {load} mov eax, ecx                          # 0048c968
    {load} xor edx, edx                          # 0048c96a
    div esi                                      # 0048c96c
    mov ecx, dword ptr [ebp - local_34]          # 0048c96e
    mov dx, word ptr [ecx + field_41]            # 0048c971
    {load} sub dx, ax                            # 0048c975
    mov eax, dword ptr [ebp - local_34]          # 0048c978
    mov word ptr [eax + field_41], dx            # 0048c97b
    mov ecx, dword ptr [ebp - local_34]          # 0048c97f
    mov byte ptr [ecx + field_37], 0x1           # 0048c982
    jmp.d8 L_0048c9c6                            # 0048c986
L_0048c988:
    # block 0x0048c988: entered by switch case, 21 instruction(s), falls into the block at 0x0048c9c6
    mov edx, dword ptr [ebp - local_34]          # 0048c988
    mov ecx, dword ptr [ebp - local_2c]          # 0048c98b
    sub ecx, dword ptr [edx + field_50]          # 0048c98e
    mov edx, dword ptr [ebp - local_30]          # 0048c991
    {load} xor eax, eax                          # 0048c994
    mov al, byte ptr [edx + field_134]           # 0048c996
    {load} mov esi, eax                          # 0048c99c
    mov eax, 0x3e8                               # 0048c99e
    cdq                                          # 0048c9a3
    idiv esi                                     # 0048c9a4
    {load} mov esi, eax                          # 0048c9a6
    {load} mov eax, ecx                          # 0048c9a8
    {load} xor edx, edx                          # 0048c9aa
    div esi                                      # 0048c9ac
    mov ecx, dword ptr [ebp - local_34]          # 0048c9ae
    mov dx, word ptr [ecx + field_41]            # 0048c9b1
    {load} add dx, ax                            # 0048c9b5
    mov eax, dword ptr [ebp - local_34]          # 0048c9b8
    mov word ptr [eax + field_41], dx            # 0048c9bb
    mov ecx, dword ptr [ebp - local_34]          # 0048c9bf
    mov byte ptr [ecx + field_36], 0x1           # 0048c9c2
L_0048c9c6:
    # block 0x0048c9c6: entered by ja at 0x0048c8b5; jmp at 0x0048c903; jmp at 0x0048c946; jmp at 0x0048c986, 8 instruction(s), ends with jne to 0x0048ca0f (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048c9c6
    mov eax, dword ptr [ebp - local_2c]          # 0048c9c9
    mov dword ptr [edx + field_50], eax          # 0048c9cc
    mov ecx, dword ptr [ebp - local_34]          # 0048c9cf
    {load} xor edx, edx                          # 0048c9d2
    mov dl, byte ptr [ecx + field_1c]            # 0048c9d4
    cmp edx, 0x1                                 # 0048c9d7
    jne.d8 L_0048ca0f                            # 0048c9da
    # block 0x0048c9dc: entered by fall-through of jne at 0x0048c9da, 6 instruction(s), ends with jl to 0x0048ca0f (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048c9dc
    movsx ecx, word ptr [eax + field_43]         # 0048c9df
    mov edx, dword ptr [ebp - local_34]          # 0048c9e3
    movsx eax, word ptr [edx + field_4c]         # 0048c9e6
    {load} cmp ecx, eax                          # 0048c9ea
    jl.d8 L_0048ca0f                             # 0048c9ec
    # block 0x0048c9ee: entered by fall-through of jl at 0x0048c9ec, 9 instruction(s), ends with forward jump to 0x0048cac3
    mov ecx, dword ptr [ebp - local_34]          # 0048c9ee
    mov edx, dword ptr [ebp - local_34]          # 0048c9f1
    mov ax, word ptr [edx + field_4c]            # 0048c9f4
    mov word ptr [ecx + field_43], ax            # 0048c9f8
    mov ecx, dword ptr [ebp - local_34]          # 0048c9fc
    mov byte ptr [ecx + field_35], 0x0           # 0048c9ff
    mov edx, dword ptr [ebp - local_34]          # 0048ca03
    mov byte ptr [edx + field_1c], -0x1          # 0048ca06
    jmp.d32 L_0048cac3                           # 0048ca0a
L_0048ca0f:
    # block 0x0048ca0f: entered by jne at 0x0048c9da; jl at 0x0048c9ec, 5 instruction(s), ends with jne to 0x0048ca4b (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048ca0f
    {load} xor ecx, ecx                          # 0048ca12
    mov cl, byte ptr [eax + field_1c]            # 0048ca14
    test ecx, ecx                                # 0048ca17
    jne.d8 L_0048ca4b                            # 0048ca19
    # block 0x0048ca1b: entered by fall-through of jne at 0x0048ca19, 6 instruction(s), ends with jg to 0x0048ca4b (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048ca1b
    movsx eax, word ptr [edx + field_43]         # 0048ca1e
    mov ecx, dword ptr [ebp - local_34]          # 0048ca22
    movsx edx, word ptr [ecx + field_4e]         # 0048ca25
    {load} cmp eax, edx                          # 0048ca29
    jg.d8 L_0048ca4b                             # 0048ca2b
    # block 0x0048ca2d: entered by fall-through of jg at 0x0048ca2b, 9 instruction(s), ends with forward jump to 0x0048cac3
    mov eax, dword ptr [ebp - local_34]          # 0048ca2d
    mov ecx, dword ptr [ebp - local_34]          # 0048ca30
    mov dx, word ptr [ecx + field_4e]            # 0048ca33
    mov word ptr [eax + field_43], dx            # 0048ca37
    mov eax, dword ptr [ebp - local_34]          # 0048ca3b
    mov byte ptr [eax + field_34], 0x0           # 0048ca3e
    mov ecx, dword ptr [ebp - local_34]          # 0048ca42
    mov byte ptr [ecx + field_1c], -0x1          # 0048ca45
    jmp.d8 L_0048cac3                            # 0048ca49
L_0048ca4b:
    # block 0x0048ca4b: entered by jne at 0x0048ca19; jg at 0x0048ca2b, 5 instruction(s), ends with jne to 0x0048ca88 (forward)
    mov edx, dword ptr [ebp - local_34]          # 0048ca4b
    {load} xor eax, eax                          # 0048ca4e
    mov al, byte ptr [edx + field_1c]            # 0048ca50
    cmp eax, 0x3                                 # 0048ca53
    jne.d8 L_0048ca88                            # 0048ca56
    # block 0x0048ca58: entered by fall-through of jne at 0x0048ca56, 6 instruction(s), ends with jl to 0x0048ca88 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 0048ca58
    movsx edx, word ptr [ecx + field_41]         # 0048ca5b
    mov eax, dword ptr [ebp - local_34]          # 0048ca5f
    movsx ecx, word ptr [eax + field_48]         # 0048ca62
    {load} cmp edx, ecx                          # 0048ca66
    jl.d8 L_0048ca88                             # 0048ca68
    # block 0x0048ca6a: entered by fall-through of jl at 0x0048ca68, 9 instruction(s), ends with forward jump to 0x0048cac3
    mov edx, dword ptr [ebp - local_34]          # 0048ca6a
    mov eax, dword ptr [ebp - local_34]          # 0048ca6d
    mov cx, word ptr [eax + field_48]            # 0048ca70
    mov word ptr [edx + field_41], cx            # 0048ca74
    mov edx, dword ptr [ebp - local_34]          # 0048ca78
    mov byte ptr [edx + field_37], 0x0           # 0048ca7b
    mov eax, dword ptr [ebp - local_34]          # 0048ca7f
    mov byte ptr [eax + field_1c], -0x1          # 0048ca82
    jmp.d8 L_0048cac3                            # 0048ca86
L_0048ca88:
    # block 0x0048ca88: entered by jne at 0x0048ca56; jl at 0x0048ca68, 5 instruction(s), ends with jne to 0x0048cac3 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 0048ca88
    {load} xor edx, edx                          # 0048ca8b
    mov dl, byte ptr [ecx + field_1c]            # 0048ca8d
    cmp edx, 0x2                                 # 0048ca90
    jne.d8 L_0048cac3                            # 0048ca93
    # block 0x0048ca95: entered by fall-through of jne at 0x0048ca93, 6 instruction(s), ends with jg to 0x0048cac3 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048ca95
    movsx ecx, word ptr [eax + field_41]         # 0048ca98
    mov edx, dword ptr [ebp - local_34]          # 0048ca9c
    movsx eax, word ptr [edx + field_4a]         # 0048ca9f
    {load} cmp ecx, eax                          # 0048caa3
    jg.d8 L_0048cac3                             # 0048caa5
    # block 0x0048caa7: entered by fall-through of jg at 0x0048caa5, 8 instruction(s), falls into the block at 0x0048cac3
    mov ecx, dword ptr [ebp - local_34]          # 0048caa7
    mov edx, dword ptr [ebp - local_34]          # 0048caaa
    mov ax, word ptr [edx + field_4a]            # 0048caad
    mov word ptr [ecx + field_41], ax            # 0048cab1
    mov ecx, dword ptr [ebp - local_34]          # 0048cab5
    mov byte ptr [ecx + field_36], 0x0           # 0048cab8
    mov edx, dword ptr [ebp - local_34]          # 0048cabc
    mov byte ptr [edx + field_1c], -0x1          # 0048cabf
L_0048cac3:
    # block 0x0048cac3: entered by jmp at 0x0048ca0a; jmp at 0x0048ca49; jmp at 0x0048ca86; jne at 0x0048ca93; more, 1 instruction(s), ends with forward jump to 0x0048cc48
    jmp.d32 L_0048cc48                           # 0048cac3
L_0048cac8:
    # block 0x0048cac8: entered by je at 0x0048c23e, 9 instruction(s), ends with je to 0x0048cbd2 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0048cac8
    mov eax, dword ptr [ebp - local_34]          # 0048cad2
    mov byte ptr [eax + field_46], 0x0           # 0048cad5
    mov dword ptr [0x5d1a8f], 0x0                # 0048cad9
    mov ecx, dword ptr [ebp - local_34]          # 0048cae3
    {load} xor edx, edx                          # 0048cae6
    mov dl, byte ptr [ecx + field_47]            # 0048cae8
    test edx, edx                                # 0048caeb
    je.d32 L_0048cbd2                            # 0048caed
    # block 0x0048caf3: entered by fall-through of je at 0x0048caed, 4 instruction(s), ends with je to 0x0048cba5 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0048caf3
    movsx ecx, word ptr [eax + field_135]        # 0048caf6
    cmp ecx, 0x270f                              # 0048cafd
    je.d32 L_0048cba5                            # 0048cb03
    # block 0x0048cb09: entered by fall-through of je at 0x0048cb03, 25 instruction(s), ends with jne to 0x0048cb91 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0048cb09
    movsx eax, word ptr [edx + field_135]        # 0048cb0c
    mov dword ptr [0x5bb57b], eax                # 0048cb13
    mov ecx, dword ptr [ebp - local_30]          # 0048cb18
    mov dx, word ptr [ecx + field_137]           # 0048cb1b
    mov word ptr [0x5bb599], dx                  # 0048cb22
    mov eax, dword ptr [ebp - local_30]          # 0048cb29
    mov cx, word ptr [eax + field_139]           # 0048cb2c
    mov word ptr [0x5bb595], cx                  # 0048cb33
    mov edx, dword ptr [ebp - local_30]          # 0048cb3a
    mov ax, word ptr [edx + field_13b]           # 0048cb3d
    mov word ptr [0x5c39ff], ax                  # 0048cb44
    mov ecx, dword ptr [ebp - local_30]          # 0048cb4a
    mov edx, dword ptr [ecx + field_13d]         # 0048cb4d
    mov dword ptr [0x5bb59b], edx                # 0048cb53
    mov eax, dword ptr [ebp - local_30]          # 0048cb59
    mov ecx, dword ptr [eax + field_141]         # 0048cb5c
    mov dword ptr [0x5bb59f], ecx                # 0048cb62
    mov edx, dword ptr [ebp - local_30]          # 0048cb68
    mov eax, dword ptr [edx + field_145]         # 0048cb6b
    mov dword ptr [0x5bb5a3], eax                # 0048cb71
    mov ecx, dword ptr [ebp - local_30]          # 0048cb76
    movsx edx, word ptr [ecx + field_149]        # 0048cb79
    cmp edx, 0x1                                 # 0048cb80
    jne.d8 L_0048cb91                            # 0048cb83
    # block 0x0048cb85: entered by fall-through of jne at 0x0048cb83, 2 instruction(s), ends with forward jump to 0x0048cb9b
    mov dword ptr [0x5bb1ca], 0x0                # 0048cb85
    jmp.d8 L_0048cb9b                            # 0048cb8f
L_0048cb91:
    # block 0x0048cb91: entered by jne at 0x0048cb83, 1 instruction(s), falls into the block at 0x0048cb9b
    mov dword ptr [0x5bb1ca], 0x1                # 0048cb91
L_0048cb9b:
    # block 0x0048cb9b: entered by jmp at 0x0048cb8f, 1 instruction(s), falls into the block at 0x0048cba5
    mov dword ptr [0x583999], 0x4                # 0048cb9b
L_0048cba5:
    # block 0x0048cba5: entered by je at 0x0048cb03, 4 instruction(s), ends with je to 0x0048cbd0 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0048cba5
    movsx ecx, word ptr [eax + field_14b]        # 0048cba8
    cmp ecx, -0x1                                # 0048cbaf
    je.d8 L_0048cbd0                             # 0048cbb2
    # block 0x0048cbb4: entered by fall-through of je at 0x0048cbb2, 6 instruction(s), falls into the block at 0x0048cbd0
    mov edx, dword ptr [ebp - local_30]          # 0048cbb4
    {load} xor eax, eax                          # 0048cbb7
    mov al, byte ptr [edx + field_14d]           # 0048cbb9
    mov ecx, dword ptr [ebp - local_30]          # 0048cbbf
    movsx edx, word ptr [ecx + field_14b]        # 0048cbc2
    mov dword ptr [4*edx + 0x585801], eax        # 0048cbc9
L_0048cbd0:
    # block 0x0048cbd0: entered by je at 0x0048cbb2, 1 instruction(s), ends with forward jump to 0x0048cc30
    jmp.d8 L_0048cc30                            # 0048cbd0
L_0048cbd2:
    # block 0x0048cbd2: entered by je at 0x0048caed, 4 instruction(s), ends with je to 0x0048cc30 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048cbd2
    movsx ecx, word ptr [eax + field_54]         # 0048cbd5
    cmp ecx, 0x270f                              # 0048cbd9
    je.d8 L_0048cc30                             # 0048cbdf
    # block 0x0048cbe1: entered by fall-through of je at 0x0048cbdf, 10 instruction(s), falls into the block at 0x0048cc30
    mov edx, dword ptr [ebp - local_34]          # 0048cbe1
    movsx eax, word ptr [edx + field_54]         # 0048cbe4
    mov dword ptr [0x5bb57b], eax                # 0048cbe8
    mov word ptr [0x5bb599], 0x0                 # 0048cbed
    mov word ptr [0x5bb595], 0x0                 # 0048cbf6
    mov word ptr [0x5c39ff], 0x1                 # 0048cbff
    mov dword ptr [0x5bb59b], 0x0                # 0048cc08
    mov dword ptr [0x5bb59f], 0x0                # 0048cc12
    mov dword ptr [0x5bb5a3], 0x1                # 0048cc1c
    mov dword ptr [0x583999], 0x4                # 0048cc26
L_0048cc30:
    # block 0x0048cc30: entered by jmp at 0x0048cbd0; je at 0x0048cbdf, 7 instruction(s), calls FUN_0042ba3a, FUN_0048bb86, falls into the block at 0x0048cc48
    mov ecx, dword ptr [ebp - local_34]          # 0048cc30
    mov dx, word ptr [ecx + field_26]            # 0048cc33
    push edx                                     # 0048cc37
    call FUN_0042ba3a                            # 0048cc38
    add esp, 0x4                                 # 0048cc3d
    mov ecx, dword ptr [ebp - local_34]          # 0048cc40
    call FUN_0048bb86                            # 0048cc43
L_0048cc48:
    # block 0x0048cc48: entered by jmp at 0x0048c244; jmp at 0x0048c80a; jmp at 0x0048c8a1; jmp at 0x0048cac3, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0048cc48
    pop esi                                      # 0048cc49
    {load} mov esp, ebp                          # 0048cc4a
    pop ebp                                      # 0048cc4c
    ret 0x4                                      # 0048cc4d

# --- data items (not part of the function) -------------------------
.org 0x0048cc50 - 0x401000
SWTAB_0048cc50:  # 4 case address(es)
    .long L_0048c8c5 - .text + 0x401000
    .long L_0048c908 - .text + 0x401000
    .long L_0048c948 - .text + 0x401000
    .long L_0048c988 - .text + 0x401000
.set SWTAB_0048cc50_VA, SWTAB_0048cc50 - .text + 0x401000

