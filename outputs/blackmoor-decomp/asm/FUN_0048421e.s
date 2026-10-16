# FUN_0048421e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048421e
# extent:       0x0048421e-0x00484622 (1028 code bytes)
# span:         0x0048421e-0x00484622 (code 1028, tables 0, padding 0)
# sha256:       d0106e6bfe32c4c95139a4b90978007858e27baaeb2c17f400beae1668eaeaf9
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048421e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_4, field_8, field_c, field_14, field_16, field_18, field_1c, field_22, field_23, field_26, field_2b, field_84 and 1 more; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_16, field_22, field_23, field_24, field_28, field_2b, field_56 and 2 more; [edx + n] field_4, field_8, field_c, field_10, field_14, field_16, field_21, field_24, field_2d, field_40, field_41, field_57 and 1 more
# callees:      calls FUN_004841cb, FUN_00484f0d, FUN_004c2a8d, FUN_004c51a5, FUN_004c7070
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 327 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_56, 0x56  # offset +0x56
.equ field_57, 0x57  # offset +0x57
.equ field_7f, 0x7f  # offset +0x7f
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_004841cb, .text + (0x004841cb - 0x401000)
.set FUN_00484f0d, .text + (0x00484f0d - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c7070, .text + (0x004c7070 - 0x401000)

.org 0x0048421e - 0x401000
.globl FUN_0048421e
FUN_0048421e:
    # block 0x0048421e: entry, 36 instruction(s), ends with je to 0x00484327 (forward)
    push ebp                                     # 0048421e
    {load} mov ebp, esp                          # 0048421f
    sub esp, 0x38                                # 00484221
    push esi                                     # 00484224
    push edi                                     # 00484225
    mov dword ptr [ebp - local_38], ecx          # 00484226
    mov eax, dword ptr [ebp - local_38]          # 00484229
    movsx ecx, word ptr [eax + field_26]         # 0048422c
    imul ecx, ecx, 0x8d                          # 00484230
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00484236
    mov dword ptr [ebp - local_18], edx          # 0048423c
    movsx eax, word ptr [ebp + arg_8]            # 0048423f
    imul eax, eax, 0x85                          # 00484243
    mov ecx, dword ptr [ebp - local_38]          # 00484249
    lea edx, [ecx + eax + field_28]              # 0048424c
    mov dword ptr [ebp - local_24], edx          # 00484250
    movsx eax, word ptr [ebp + arg_8]            # 00484253
    imul eax, eax, 0x42                          # 00484257
    mov ecx, dword ptr [ebp - local_18]          # 0048425a
    lea edx, [ecx + eax + field_7f]              # 0048425d
    mov dword ptr [ebp - local_4], edx           # 00484261
    mov eax, dword ptr [ebp - local_24]          # 00484264
    mov word ptr [eax], 0x0                      # 00484267
    mov ecx, dword ptr [ebp - local_24]          # 0048426c
    mov edx, dword ptr [ebp - local_4]           # 0048426f
    mov al, byte ptr [edx + field_40]            # 00484272
    mov byte ptr [ecx + field_22], al            # 00484275
    mov ecx, dword ptr [ebp - local_24]          # 00484278
    mov edx, dword ptr [ebp - local_4]           # 0048427b
    mov al, byte ptr [edx + field_41]            # 0048427e
    mov byte ptr [ecx + field_23], al            # 00484281
    mov ecx, dword ptr [ebp - local_24]          # 00484284
    {load} xor edx, edx                          # 00484287
    mov dl, byte ptr [ecx + field_23]            # 00484289
    test edx, edx                                # 0048428c
    je.d32 L_00484327                            # 0048428e
    # block 0x00484294: entered by fall-through of je at 0x0048428e, 27 instruction(s), calls FUN_004841cb, ends with je to 0x00484325 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00484294
    add eax, 0x20                                # 00484297
    mov ecx, dword ptr [ebp - local_24]          # 0048429a
    add ecx, 0x2                                 # 0048429d
    mov edx, dword ptr [eax]                     # 004842a0
    mov dword ptr [ecx], edx                     # 004842a2
    mov edx, dword ptr [eax + field_4]           # 004842a4
    mov dword ptr [ecx + field_4], edx           # 004842a7
    mov edx, dword ptr [eax + field_8]           # 004842aa
    mov dword ptr [ecx + field_8], edx           # 004842ad
    mov eax, dword ptr [eax + field_c]           # 004842b0
    mov dword ptr [ecx + field_c], eax           # 004842b3
    mov ecx, dword ptr [ebp - local_24]          # 004842b6
    add ecx, 0x12                                # 004842b9
    push ecx                                     # 004842bc
    mov edx, dword ptr [ebp - local_24]          # 004842bd
    add edx, 0x2                                 # 004842c0
    push edx                                     # 004842c3
    mov ecx, dword ptr [ebp - local_38]          # 004842c4
    call FUN_004841cb                            # 004842c7
    mov eax, dword ptr [ebp - local_24]          # 004842cc
    mov byte ptr [eax + field_22], 0x0           # 004842cf
    mov ecx, dword ptr [ebp - local_18]          # 004842d3
    {load} xor edx, edx                          # 004842d6
    mov dl, byte ptr [ecx + field_56]            # 004842d8
    test edx, edx                                # 004842db
    je.d8 L_00484325                             # 004842dd
    # block 0x004842df: entered by fall-through of je at 0x004842dd, 2 instruction(s), ends with forward jump to 0x004842f3
    mov word ptr [ebp - local_c], 0x0            # 004842df
    jmp.d8 L_004842f3                            # 004842e5
L_004842e7:
    # block 0x004842e7: entered by jmp at 0x00484323, 3 instruction(s), falls into the block at 0x004842f3
    mov ax, word ptr [ebp - local_c]             # 004842e7
    .insn 0x66, 0x05, 0x0001{:u16}               # 004842eb
    mov word ptr [ebp - local_c], ax             # 004842ef
L_004842f3:
    # block 0x004842f3: entered by jmp at 0x004842e5, 5 instruction(s), ends with jge to 0x00484325 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004842f3
    mov edx, dword ptr [ebp - local_18]          # 004842f7
    movsx eax, word ptr [edx + field_21]         # 004842fa
    {load} cmp ecx, eax                          # 004842fe
    jge.d8 L_00484325                            # 00484300
    # block 0x00484302: entered by fall-through of jge at 0x00484300, 7 instruction(s), ends with jne to 0x00484323 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00484302
    mov edx, dword ptr [ebp - local_18]          # 00484306
    movsx eax, word ptr [edx + 2*ecx + field_57] # 00484309
    movsx ecx, word ptr [ebp + arg_8]            # 0048430e
    add ecx, 0x1                                 # 00484312
    {load} cmp eax, ecx                          # 00484315
    jne.d8 L_00484323                            # 00484317
    # block 0x00484319: entered by fall-through of jne at 0x00484317, 3 instruction(s), falls into the block at 0x00484323
    mov edx, dword ptr [ebp - local_24]          # 00484319
    mov ax, word ptr [ebp - local_c]             # 0048431c
    mov word ptr [edx], ax                       # 00484320
L_00484323:
    # block 0x00484323: entered by jne at 0x00484317, 1 instruction(s), ends with backward jump to 0x004842e7
    jmp.d8 L_004842e7                            # 00484323
L_00484325:
    # block 0x00484325: entered by je at 0x004842dd; jge at 0x00484300, 1 instruction(s), ends with forward jump to 0x0048435f
    jmp.d8 L_0048435f                            # 00484325
L_00484327:
    # block 0x00484327: entered by je at 0x0048428e, 20 instruction(s), calls FUN_004841cb, falls into the block at 0x0048435f
    mov ecx, dword ptr [ebp - local_4]           # 00484327
    add ecx, 0x30                                # 0048432a
    mov edx, dword ptr [ebp - local_24]          # 0048432d
    add edx, 0x2                                 # 00484330
    mov eax, dword ptr [ecx]                     # 00484333
    mov dword ptr [edx], eax                     # 00484335
    mov eax, dword ptr [ecx + field_4]           # 00484337
    mov dword ptr [edx + field_4], eax           # 0048433a
    mov eax, dword ptr [ecx + field_8]           # 0048433d
    mov dword ptr [edx + field_8], eax           # 00484340
    mov ecx, dword ptr [ecx + field_c]           # 00484343
    mov dword ptr [edx + field_c], ecx           # 00484346
    mov edx, dword ptr [ebp - local_24]          # 00484349
    add edx, 0x12                                # 0048434c
    push edx                                     # 0048434f
    mov eax, dword ptr [ebp - local_24]          # 00484350
    add eax, 0x2                                 # 00484353
    push eax                                     # 00484356
    mov ecx, dword ptr [ebp - local_38]          # 00484357
    call FUN_004841cb                            # 0048435a
L_0048435f:
    # block 0x0048435f: entered by jmp at 0x00484325, 10 instruction(s), calls FUN_00484f0d, ends with je to 0x004843e6 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048435f
    add ecx, 0x24                                # 00484362
    mov dword ptr [ebp - local_14], ecx          # 00484365
    mov edx, dword ptr [ebp - local_4]           # 00484368
    add edx, 0x10                                # 0048436b
    push edx                                     # 0048436e
    mov ecx, dword ptr [ebp - local_38]          # 0048436f
    call FUN_00484f0d                            # 00484372
    test eax, eax                                # 00484377
    je.d8 L_004843e6                             # 00484379
    # block 0x0048437b: entered by fall-through of je at 0x00484379, 33 instruction(s), ends with forward jump to 0x0048444b
    mov eax, dword ptr [ebp - local_4]           # 0048437b
    mov ecx, dword ptr [ebp - local_4]           # 0048437e
    mov edx, dword ptr [eax + field_18]          # 00484381
    sub edx, dword ptr [ecx + field_10]          # 00484384
    add edx, 0x1                                 # 00484387
    mov eax, dword ptr [ebp - local_14]          # 0048438a
    mov word ptr [eax + field_14], dx            # 0048438d
    mov ecx, dword ptr [ebp - local_14]          # 00484391
    mov dx, word ptr [ecx + field_14]            # 00484394
    mov word ptr [ebp - local_1c], dx            # 00484398
    mov eax, dword ptr [ebp - local_4]           # 0048439c
    mov ecx, dword ptr [ebp - local_4]           # 0048439f
    mov edx, dword ptr [eax + field_1c]          # 004843a2
    sub edx, dword ptr [ecx + field_14]          # 004843a5
    add edx, 0x1                                 # 004843a8
    mov eax, dword ptr [ebp - local_14]          # 004843ab
    mov word ptr [eax + field_16], dx            # 004843ae
    mov ecx, dword ptr [ebp - local_14]          # 004843b2
    mov dx, word ptr [ecx + field_16]            # 004843b5
    mov word ptr [ebp - local_10], dx            # 004843b9
    mov eax, dword ptr [ebp - local_4]           # 004843bd
    add eax, 0x10                                # 004843c0
    mov ecx, dword ptr [eax]                     # 004843c3
    mov dword ptr [ebp - local_34], ecx          # 004843c5
    mov edx, dword ptr [eax + field_4]           # 004843c8
    mov dword ptr [ebp - local_30], edx          # 004843cb
    mov ecx, dword ptr [eax + field_8]           # 004843ce
    mov dword ptr [ebp - local_2c], ecx          # 004843d1
    mov edx, dword ptr [eax + field_c]           # 004843d4
    mov dword ptr [ebp - local_28], edx          # 004843d7
    mov eax, dword ptr [ebp - local_24]          # 004843da
    mov byte ptr [eax + field_84], 0x0           # 004843dd
    jmp.d8 L_0048444b                            # 004843e4
L_004843e6:
    # block 0x004843e6: entered by je at 0x00484379, 31 instruction(s), falls into the block at 0x0048444b
    mov ecx, dword ptr [ebp - local_4]           # 004843e6
    mov edx, dword ptr [ebp - local_4]           # 004843e9
    mov eax, dword ptr [ecx + field_8]           # 004843ec
    sub eax, dword ptr [edx]                     # 004843ef
    add eax, 0x1                                 # 004843f1
    mov ecx, dword ptr [ebp - local_14]          # 004843f4
    mov word ptr [ecx + field_14], ax            # 004843f7
    mov edx, dword ptr [ebp - local_14]          # 004843fb
    mov ax, word ptr [edx + field_14]            # 004843fe
    mov word ptr [ebp - local_1c], ax            # 00484402
    mov ecx, dword ptr [ebp - local_4]           # 00484406
    mov edx, dword ptr [ebp - local_4]           # 00484409
    mov eax, dword ptr [ecx + field_c]           # 0048440c
    sub eax, dword ptr [edx + field_4]           # 0048440f
    add eax, 0x1                                 # 00484412
    mov ecx, dword ptr [ebp - local_14]          # 00484415
    mov word ptr [ecx + field_16], ax            # 00484418
    mov edx, dword ptr [ebp - local_14]          # 0048441c
    mov ax, word ptr [edx + field_16]            # 0048441f
    mov word ptr [ebp - local_10], ax            # 00484423
    mov ecx, dword ptr [ebp - local_4]           # 00484427
    mov edx, dword ptr [ecx]                     # 0048442a
    mov dword ptr [ebp - local_34], edx          # 0048442c
    mov eax, dword ptr [ecx + field_4]           # 0048442f
    mov dword ptr [ebp - local_30], eax          # 00484432
    mov edx, dword ptr [ecx + field_8]           # 00484435
    mov dword ptr [ebp - local_2c], edx          # 00484438
    mov eax, dword ptr [ecx + field_c]           # 0048443b
    mov dword ptr [ebp - local_28], eax          # 0048443e
    mov ecx, dword ptr [ebp - local_24]          # 00484441
    mov byte ptr [ecx + field_84], 0x1           # 00484444
L_0048444b:
    # block 0x0048444b: entered by jmp at 0x004843e4, 45 instruction(s), calls FUN_004c2a8d, FUN_004c51a5, ends with jne to 0x004844ea (forward)
    push 0x54da9c                                # 0048444b
    push 0x6                                     # 00484450
    mov dx, word ptr [ebp - local_10]            # 00484452
    push edx                                     # 00484456
    mov ax, word ptr [ebp - local_1c]            # 00484457
    push eax                                     # 0048445b
    mov ecx, 0x5cf659                            # 0048445c
    call FUN_004c2a8d                            # 00484461
    mov ecx, dword ptr [ebp - local_14]          # 00484466
    mov dword ptr [ecx], eax                     # 00484469
    mov edx, dword ptr [ebp - local_14]          # 0048446b
    mov dword ptr [edx + field_8], 0x0           # 0048446e
    mov eax, dword ptr [ebp - local_14]          # 00484475
    mov dword ptr [eax + field_4], 0x0           # 00484478
    movsx ecx, word ptr [ebp - local_10]         # 0048447f
    mov edx, dword ptr [ebp - local_14]          # 00484483
    mov eax, dword ptr [edx + field_8]           # 00484486
    lea ecx, [eax + ecx - field_minus_1]         # 00484489
    mov edx, dword ptr [ebp - local_14]          # 0048448d
    mov dword ptr [edx + field_10], ecx          # 00484490
    movsx eax, word ptr [ebp - local_1c]         # 00484493
    mov ecx, dword ptr [ebp - local_14]          # 00484497
    mov edx, dword ptr [ecx + field_4]           # 0048449a
    lea eax, [edx + eax - field_minus_1]         # 0048449d
    mov ecx, dword ptr [ebp - local_14]          # 004844a1
    mov dword ptr [ecx + field_c], eax           # 004844a4
    push 0x54dad0                                # 004844a7
    mov edx, dword ptr [ebp - local_14]          # 004844ac
    add edx, 0x4                                 # 004844af
    push edx                                     # 004844b2
    lea eax, [ebp - local_34]                    # 004844b3
    push eax                                     # 004844b6
    mov ecx, dword ptr [ebp - local_14]          # 004844b7
    mov edx, dword ptr [ecx]                     # 004844ba
    push edx                                     # 004844bc
    mov eax, dword ptr [ebp - local_38]          # 004844bd
    mov ecx, dword ptr [eax + field_22]          # 004844c0
    push ecx                                     # 004844c3
    mov ecx, 0x5cf659                            # 004844c4
    call FUN_004c51a5                            # 004844c9
    mov edx, dword ptr [ebp - local_18]          # 004844ce
    {load} xor eax, eax                          # 004844d1
    mov al, byte ptr [edx + field_24]            # 004844d3
    test eax, eax                                # 004844d6
    jne.d8 L_004844ea                            # 004844d8
    # block 0x004844da: entered by fall-through of jne at 0x004844d8, 5 instruction(s), ends with je to 0x0048461a (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004844da
    {load} xor edx, edx                          # 004844dd
    mov dl, byte ptr [ecx + field_22]            # 004844df
    test edx, edx                                # 004844e2
    je.d32 L_0048461a                            # 004844e4
L_004844ea:
    # block 0x004844ea: entered by jne at 0x004844d8; fall-through of je at 0x004844e4, 2 instruction(s), ends with forward jump to 0x004844f8
    mov byte ptr [ebp - local_8], 0x1            # 004844ea
    jmp.d8 L_004844f8                            # 004844ee
L_004844f0:
    # block 0x004844f0: entered by jmp at 0x00484615, 3 instruction(s), falls into the block at 0x004844f8
    mov al, byte ptr [ebp - local_8]             # 004844f0
    add al, 0x1                                  # 004844f3
    mov byte ptr [ebp - local_8], al             # 004844f5
L_004844f8:
    # block 0x004844f8: entered by jmp at 0x004844ee, 4 instruction(s), ends with jge to 0x0048461a (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004844f8
    and ecx, 0xff                                # 004844fb
    cmp ecx, 0x4                                 # 00484501
    jge.d32 L_0048461a                           # 00484504
    # block 0x0048450a: entered by fall-through of jge at 0x00484504, 13 instruction(s), ends with jne to 0x0048460c (forward)
    mov edx, dword ptr [ebp - local_14]          # 0048450a
    mov dword ptr [ebp - local_20], edx          # 0048450d
    mov eax, dword ptr [ebp - local_8]           # 00484510
    and eax, 0xff                                # 00484513
    imul eax, eax, 0x18                          # 00484518
    mov ecx, dword ptr [ebp - local_24]          # 0048451b
    lea edx, [ecx + eax + field_24]              # 0048451e
    mov dword ptr [ebp - local_14], edx          # 00484522
    mov eax, dword ptr [ebp - local_24]          # 00484525
    {load} xor ecx, ecx                          # 00484528
    mov cl, byte ptr [eax + field_23]            # 0048452a
    test ecx, ecx                                # 0048452d
    jne.d32 L_0048460c                           # 0048452f
    # block 0x00484535: entered by fall-through of jne at 0x0048452f, 68 instruction(s), calls FUN_004c2a8d, FUN_004c7070, ends with forward jump to 0x00484615
    push 0x54db0c                                # 00484535
    push 0x6                                     # 0048453a
    mov dx, word ptr [ebp - local_10]            # 0048453c
    push edx                                     # 00484540
    mov ax, word ptr [ebp - local_1c]            # 00484541
    push eax                                     # 00484545
    mov ecx, 0x5cf659                            # 00484546
    call FUN_004c2a8d                            # 0048454b
    mov ecx, dword ptr [ebp - local_14]          # 00484550
    mov dword ptr [ecx], eax                     # 00484553
    mov edx, dword ptr [ebp - local_20]          # 00484555
    mov eax, dword ptr [edx]                     # 00484558
    mov ecx, dword ptr [eax + field_23]          # 0048455a
    mov edx, dword ptr [ebp - local_20]          # 0048455d
    mov eax, dword ptr [edx]                     # 00484560
    mov esi, dword ptr [eax]                     # 00484562
    mov edx, dword ptr [ebp - local_14]          # 00484564
    mov eax, dword ptr [edx]                     # 00484567
    mov edi, dword ptr [eax]                     # 00484569
    {load} mov edx, ecx                          # 0048456b
    shr ecx, 0x2                                 # 0048456d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00484570
    {load} mov ecx, edx                          # 00484572
    and ecx, 0x3                                 # 00484574
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00484577
    push 0x63a8a4                                # 00484579
    mov eax, dword ptr [ebp - local_14]          # 0048457e
    mov ecx, dword ptr [eax]                     # 00484581
    push ecx                                     # 00484583
    mov ecx, 0x5cf659                            # 00484584
    call FUN_004c7070                            # 00484589
    mov edx, dword ptr [ebp - local_14]          # 0048458e
    mov dword ptr [edx + field_4], 0x0           # 00484591
    mov eax, dword ptr [ebp - local_14]          # 00484598
    mov dword ptr [eax + field_8], 0x0           # 0048459b
    mov ecx, dword ptr [ebp - local_14]          # 004845a2
    mov edx, dword ptr [ecx]                     # 004845a5
    movsx eax, word ptr [edx + field_2d]         # 004845a7
    mov ecx, dword ptr [ebp - local_14]          # 004845ab
    mov edx, dword ptr [ecx + field_8]           # 004845ae
    lea eax, [edx + eax - field_minus_1]         # 004845b1
    mov ecx, dword ptr [ebp - local_14]          # 004845b5
    mov dword ptr [ecx + field_10], eax          # 004845b8
    mov edx, dword ptr [ebp - local_14]          # 004845bb
    mov eax, dword ptr [edx]                     # 004845be
    movsx ecx, word ptr [eax + field_2b]         # 004845c0
    mov edx, dword ptr [ebp - local_14]          # 004845c4
    mov eax, dword ptr [edx + field_4]           # 004845c7
    lea ecx, [eax + ecx - field_minus_1]         # 004845ca
    mov edx, dword ptr [ebp - local_14]          # 004845ce
    mov dword ptr [edx + field_c], ecx           # 004845d1
    mov eax, dword ptr [ebp - local_14]          # 004845d4
    mov ecx, dword ptr [eax]                     # 004845d7
    mov edx, dword ptr [ebp - local_14]          # 004845d9
    mov ax, word ptr [ecx + field_2b]            # 004845dc
    mov word ptr [edx + field_14], ax            # 004845e0
    mov ecx, dword ptr [ebp - local_14]          # 004845e4
    mov edx, dword ptr [ecx]                     # 004845e7
    mov eax, dword ptr [ebp - local_14]          # 004845e9
    mov cx, word ptr [edx + field_2d]            # 004845ec
    mov word ptr [eax + field_16], cx            # 004845f0
    mov edx, dword ptr [ebp - local_14]          # 004845f4
    mov ax, word ptr [edx + field_14]            # 004845f7
    mov word ptr [ebp - local_1c], ax            # 004845fb
    mov ecx, dword ptr [ebp - local_14]          # 004845ff
    mov dx, word ptr [ecx + field_16]            # 00484602
    mov word ptr [ebp - local_10], dx            # 00484606
    jmp.d8 L_00484615                            # 0048460a
L_0048460c:
    # block 0x0048460c: entered by jne at 0x0048452f, 2 instruction(s), falls into the block at 0x00484615
    mov eax, dword ptr [ebp - local_14]          # 0048460c
    mov dword ptr [eax], 0x0                     # 0048460f
L_00484615:
    # block 0x00484615: entered by jmp at 0x0048460a, 1 instruction(s), ends with backward jump to 0x004844f0
    jmp.d32 L_004844f0                           # 00484615
L_0048461a:
    # block 0x0048461a: entered by je at 0x004844e4; jge at 0x00484504, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0048461a
    pop esi                                      # 0048461b
    {load} mov esp, ebp                          # 0048461c
    pop ebp                                      # 0048461e
    ret 0x4                                      # 0048461f

