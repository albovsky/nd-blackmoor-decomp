# FUN_004662d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004662d8
# extent:       0x004662d8-0x00466da1 (2761 code bytes)
# span:         0x004662d8-0x00466db1 (code 2761, tables 16, padding 0)
# sha256:       ed3d82a5d74304dde8ff0c2910348c69aadf17143e488745b7af06d3b82ceb61
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004662d8
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_1c, field_1e, field_24, field_28, field_2e, field_3e, field_40, field_41, field_42, field_45, field_49, field_54 and 15 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_2a, field_2c, field_2e, field_41, field_43, field_45 and 22 more; [edx + n] field_1c, field_24, field_2a, field_2c, field_2e, field_3e, field_3f, field_42, field_43, field_4d, field_4e, field_50 and 13 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_00466247, FUN_004f6334, FUN_004fb2e3, FUN_004fc878, KERNEL32.dll!GetTickCount, FUN_004fba69, FUN_0042ba3a, FUN_00465b3c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 696 instruction(s), 56 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_3e, 0x3e  # offset +0x3e
.equ field_3f, 0x3f  # offset +0x3f
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_42, 0x42  # offset +0x42
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_4e, 0x4e  # offset +0x4e
.equ field_4f, 0x4f  # offset +0x4f
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_308, 0x308  # offset +0x308
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3fd, 0x3fd  # offset +0x3fd
.equ field_4c1, 0x4c1  # offset +0x4c1
.equ field_4d1, 0x4d1  # offset +0x4d1
.equ field_4d3, 0x4d3  # offset +0x4d3
.equ field_4d5, 0x4d5  # offset +0x4d5
.equ field_4d7, 0x4d7  # offset +0x4d7
.equ field_4d9, 0x4d9  # offset +0x4d9
.equ field_4dd, 0x4dd  # offset +0x4dd
.equ field_4e1, 0x4e1  # offset +0x4e1
.equ field_4e5, 0x4e5  # offset +0x4e5
.equ field_4e7, 0x4e7  # offset +0x4e7
.equ field_4e9, 0x4e9  # offset +0x4e9
.equ field_50d, 0x50d  # offset +0x50d
.equ field_51d, 0x51d  # offset +0x51d
.equ field_51e, 0x51e  # offset +0x51e
.equ field_520, 0x520  # offset +0x520
.equ field_522, 0x522  # offset +0x522
.equ field_524, 0x524  # offset +0x524
.equ field_526, 0x526  # offset +0x526
.equ field_528, 0x528  # offset +0x528
.equ field_52c, 0x52c  # offset +0x52c
.equ field_530, 0x530  # offset +0x530
.equ field_534, 0x534  # offset +0x534
.equ field_536, 0x536  # offset +0x536
.equ field_538, 0x538  # offset +0x538
.equ field_53a, 0x53a  # offset +0x53a
.equ field_53c, 0x53c  # offset +0x53c
.equ field_53e, 0x53e  # offset +0x53e
.equ field_542, 0x542  # offset +0x542
.equ field_546, 0x546  # offset +0x546
.equ field_54a, 0x54a  # offset +0x54a
.equ field_54c, 0x54c  # offset +0x54c
.equ field_54e, 0x54e  # offset +0x54e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00465b3c, .text + (0x00465b3c - 0x401000)
.set FUN_00466247, .text + (0x00466247 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_004fc878, .text + (0x004fc878 - 0x401000)

.org 0x004662d8 - 0x401000
.globl FUN_004662d8
FUN_004662d8:
    # block 0x004662d8: entry, 16 instruction(s), ends with je to 0x00466328 (forward)
    push ebp                                     # 004662d8
    {load} mov ebp, esp                          # 004662d9
    sub esp, 0x24                                # 004662db
    push esi                                     # 004662de
    push edi                                     # 004662df
    mov dword ptr [ebp - local_1c], ecx          # 004662e0
    movsx eax, word ptr [ebp + arg_8]            # 004662e3
    imul eax, eax, 0x8d                          # 004662e7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004662ed
    mov dword ptr [ebp - local_c], ecx           # 004662f3
    movsx edx, word ptr [ebp + arg_8]            # 004662f6
    imul edx, edx, 0x8d                          # 004662fa
    mov eax, dword ptr [edx + 0x5bb632]          # 00466300
    mov dword ptr [ebp - local_20], eax          # 00466306
    cmp dword ptr [ebp - local_20], 0x0          # 00466309
    je.d8 L_00466328                             # 0046630d
    # block 0x0046630f: entered by fall-through of je at 0x0046630d, 2 instruction(s), ends with je to 0x0046663a (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 0046630f
    je.d32 L_0046663a                            # 00466313
    # block 0x00466319: entered by fall-through of je at 0x00466313, 2 instruction(s), ends with je to 0x004669aa (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 00466319
    je.d32 L_004669aa                            # 0046631d
    # block 0x00466323: entered by fall-through of je at 0x0046631d, 1 instruction(s), ends with forward jump to 0x00466d99
    jmp.d32 L_00466d99                           # 00466323
L_00466328:
    # block 0x00466328: entered by je at 0x0046630d, 11 instruction(s), ends with je to 0x0046636b (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00466328
    mov dx, word ptr [ebp + arg_8]               # 0046632b
    mov word ptr [ecx + field_1e], dx            # 0046632f
    mov eax, dword ptr [ebp - local_1c]          # 00466333
    mov dword ptr [eax + field_49], 0x1          # 00466336
    mov dword ptr [0x5bb1ca], 0x1                # 0046633d
    mov ecx, dword ptr [ebp - local_c]           # 00466347
    {load} xor edx, edx                          # 0046634a
    mov dl, byte ptr [ecx + field_51d]           # 0046634c
    test edx, edx                                # 00466352
    je.d8 L_0046636b                             # 00466354
    # block 0x00466356: entered by fall-through of je at 0x00466354, 5 instruction(s), ends with je to 0x00466375 (forward)
    movsx eax, word ptr [0x583a29]               # 00466356
    mov ecx, dword ptr [ebp - local_c]           # 0046635d
    movsx edx, word ptr [ecx + field_51e]        # 00466360
    {load} cmp eax, edx                          # 00466367
    je.d8 L_00466375                             # 00466369
L_0046636b:
    # block 0x0046636b: entered by je at 0x00466354; fall-through of je at 0x00466369, 2 instruction(s), calls FUN_004e8d96, falls into the block at 0x00466375
    mov ecx, 0x571442                            # 0046636b
    call FUN_004e8d96                            # 00466370
L_00466375:
    # block 0x00466375: entered by je at 0x00466369, 86 instruction(s), calls FUN_004d39f9, ends with jne to 0x004664e7 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00466375
    mov word ptr [eax + field_28], 0x0           # 00466378
    mov ecx, dword ptr [ebp - local_1c]          # 0046637e
    mov word ptr [ecx + field_2a], 0x0           # 00466381
    mov edx, dword ptr [ebp - local_1c]          # 00466387
    mov word ptr [edx + field_2c], 0x0           # 0046638a
    {load} xor eax, eax                          # 00466390
    mov ecx, dword ptr [ebp - local_1c]          # 00466392
    add ecx, 0x2e                                # 00466395
    mov dword ptr [ecx], eax                     # 00466398
    mov dword ptr [ecx + field_4], eax           # 0046639a
    mov dword ptr [ecx + field_8], eax           # 0046639d
    mov dword ptr [ecx + field_c], eax           # 004663a0
    mov edx, dword ptr [ebp - local_1c]          # 004663a3
    mov byte ptr [edx + field_3e], 0x0           # 004663a6
    mov eax, dword ptr [ebp - local_1c]          # 004663aa
    mov byte ptr [eax + field_42], 0x0           # 004663ad
    mov ecx, dword ptr [ebp - local_1c]          # 004663b1
    mov byte ptr [ecx + field_4f], 0x0           # 004663b4
    mov edx, dword ptr [ebp - local_1c]          # 004663b8
    mov byte ptr [edx + field_3f], 0x0           # 004663bb
    mov eax, dword ptr [ebp - local_1c]          # 004663bf
    mov byte ptr [eax + field_40], 0x0           # 004663c2
    mov ecx, dword ptr [ebp - local_1c]          # 004663c6
    mov byte ptr [ecx + field_41], 0x1           # 004663c9
    mov edx, dword ptr [ebp - local_1c]          # 004663cd
    mov word ptr [edx + field_43], 0x0           # 004663d0
    mov eax, dword ptr [ebp - local_1c]          # 004663d6
    mov word ptr [eax + field_54], 0x0           # 004663d9
    call FUN_004d39f9                            # 004663df
    mov ecx, dword ptr [ebp - local_1c]          # 004663e4
    mov word ptr [ecx + field_1c], ax            # 004663e7
    mov edx, dword ptr [ebp - local_1c]          # 004663eb
    movsx eax, word ptr [edx + field_1c]         # 004663ee
    imul eax, eax, 0x4a                          # 004663f2
    mov dword ptr [eax + 0x5d1591], 0xa          # 004663f5
    mov ecx, dword ptr [ebp - local_1c]          # 004663ff
    movsx edx, word ptr [ecx + field_1c]         # 00466402
    imul edx, edx, 0x4a                          # 00466406
    mov dword ptr [edx + 0x5d1595], 0x466e14     # 00466409
    mov eax, dword ptr [ebp - local_1c]          # 00466413
    movsx ecx, word ptr [eax + field_1c]         # 00466416
    imul ecx, ecx, 0x4a                          # 0046641a
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0046641d
    mov edx, dword ptr [ebp - local_1c]          # 00466427
    movsx eax, word ptr [edx + field_1c]         # 0046642a
    imul eax, eax, 0x4a                          # 0046642e
    mov dword ptr [eax + 0x5d159d], 0x0          # 00466431
    mov ecx, dword ptr [ebp - local_1c]          # 0046643b
    movsx edx, word ptr [ecx + field_1c]         # 0046643e
    imul edx, edx, 0x4a                          # 00466442
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00466445
    mov eax, dword ptr [ebp - local_1c]          # 0046644f
    movsx ecx, word ptr [eax + field_1c]         # 00466452
    imul ecx, ecx, 0x4a                          # 00466456
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00466459
    mov edx, dword ptr [ebp - local_1c]          # 00466463
    movsx eax, word ptr [edx + field_1c]         # 00466466
    imul eax, eax, 0x4a                          # 0046646a
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0046646d
    mov ecx, dword ptr [ebp - local_1c]          # 00466477
    movsx edx, word ptr [ecx + field_1c]         # 0046647a
    imul edx, edx, 0x4a                          # 0046647e
    mov word ptr [edx + 0x5d15ad], 0x0           # 00466481
    mov edi, 0x54b558                            # 0046648a
    mov eax, dword ptr [ebp - local_1c]          # 0046648f
    movsx ecx, word ptr [eax + field_1c]         # 00466492
    imul ecx, ecx, 0x4a                          # 00466496
    add ecx, 0x5d15b3                            # 00466499
    {load} mov edx, ecx                          # 0046649f
    or ecx, -0x1                                 # 004664a1
    {load} xor eax, eax                          # 004664a4
    repne scasb al, byte ptr es:[edi]            # 004664a6
    not ecx                                      # 004664a8
    {load} sub edi, ecx                          # 004664aa
    {load} mov esi, edi                          # 004664ac
    {load} mov eax, ecx                          # 004664ae
    {load} mov edi, edx                          # 004664b0
    shr ecx, 0x2                                 # 004664b2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004664b5
    {load} mov ecx, eax                          # 004664b7
    and ecx, 0x3                                 # 004664b9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004664bc
    mov ecx, dword ptr [ebp - local_1c]          # 004664be
    cmp dword ptr [ecx + field_20], 0x0          # 004664c1
    jne.d8 L_004664e7                            # 004664c5
    # block 0x004664c7: entered by fall-through of jne at 0x004664c5, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004664e7
    push 0x54b570                                # 004664c7
    push 0x6                                     # 004664cc
    mov edx, dword ptr [ebp - local_c]           # 004664ce
    push edx                                     # 004664d1
    push 0x54b588                                # 004664d2
    mov ecx, 0x5cf659                            # 004664d7
    call FUN_004c2790                            # 004664dc
    mov ecx, dword ptr [ebp - local_1c]          # 004664e1
    mov dword ptr [ecx + field_20], eax          # 004664e4
L_004664e7:
    # block 0x004664e7: entered by jne at 0x004664c5, 9 instruction(s), ends with jne to 0x00466529 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004664e7
    movsx eax, word ptr [edx + field_1c]         # 004664ea
    imul eax, eax, 0x4a                          # 004664ee
    mov ecx, dword ptr [ebp - local_1c]          # 004664f1
    mov edx, dword ptr [ecx + field_20]          # 004664f4
    mov dword ptr [eax + 0x5d1599], edx          # 004664f7
    mov eax, dword ptr [ebp - local_1c]          # 004664fd
    cmp dword ptr [eax + field_24], 0x0          # 00466500
    jne.d8 L_00466529                            # 00466504
    # block 0x00466506: entered by fall-through of jne at 0x00466504, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x00466529
    push 0x54b590                                # 00466506
    push 0x6                                     # 0046650b
    mov ecx, dword ptr [ebp - local_c]           # 0046650d
    add ecx, 0x21                                # 00466510
    push ecx                                     # 00466513
    push 0x54b5a8                                # 00466514
    mov ecx, 0x5cf659                            # 00466519
    call FUN_004c2790                            # 0046651e
    mov edx, dword ptr [ebp - local_1c]          # 00466523
    mov dword ptr [edx + field_24], eax          # 00466526
L_00466529:
    # block 0x00466529: entered by jne at 0x00466504, 7 instruction(s), ends with je to 0x00466556 (forward)
    mov edi, 0x54b5b0                            # 00466529
    mov esi, dword ptr [ebp - local_c]           # 0046652e
    add esi, 0x3dc                               # 00466531
    mov ecx, 0x9                                 # 00466537
    {load} xor eax, eax                          # 0046653c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046653e
    je.d8 L_00466556                             # 00466540
    # block 0x00466542: entered by fall-through of je at 0x00466540, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00466556
    mov ecx, dword ptr [ebp - local_c]           # 00466542
    add ecx, 0x3dc                               # 00466545
    push ecx                                     # 0046654b
    mov ecx, 0x5c3a67                            # 0046654c
    call FUN_004fb77a                            # 00466551
L_00466556:
    # block 0x00466556: entered by je at 0x00466540, 7 instruction(s), ends with je to 0x00466582 (forward)
    mov edi, 0x54b5bc                            # 00466556
    mov esi, dword ptr [ebp - local_c]           # 0046655b
    add esi, 0x40d                               # 0046655e
    mov ecx, 0x9                                 # 00466564
    {load} xor edx, edx                          # 00466569
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046656b
    je.d8 L_00466582                             # 0046656d
    # block 0x0046656f: entered by fall-through of je at 0x0046656d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00466582
    mov eax, dword ptr [ebp - local_c]           # 0046656f
    add eax, 0x40d                               # 00466572
    push eax                                     # 00466577
    mov ecx, 0x5c3a67                            # 00466578
    call FUN_004fb77a                            # 0046657d
L_00466582:
    # block 0x00466582: entered by je at 0x0046656d, 7 instruction(s), ends with je to 0x004665ae (forward)
    mov edi, 0x54b5c8                            # 00466582
    mov esi, dword ptr [ebp - local_c]           # 00466587
    add esi, 0x43e                               # 0046658a
    mov ecx, 0x9                                 # 00466590
    {load} xor edx, edx                          # 00466595
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00466597
    je.d8 L_004665ae                             # 00466599
    # block 0x0046659b: entered by fall-through of je at 0x00466599, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004665ae
    mov eax, dword ptr [ebp - local_c]           # 0046659b
    add eax, 0x43e                               # 0046659e
    push eax                                     # 004665a3
    mov ecx, 0x5c3a67                            # 004665a4
    call FUN_004fb77a                            # 004665a9
L_004665ae:
    # block 0x004665ae: entered by je at 0x00466599, 7 instruction(s), ends with je to 0x004665da (forward)
    mov edi, 0x54b5d4                            # 004665ae
    mov esi, dword ptr [ebp - local_c]           # 004665b3
    add esi, 0x46f                               # 004665b6
    mov ecx, 0x9                                 # 004665bc
    {load} xor edx, edx                          # 004665c1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004665c3
    je.d8 L_004665da                             # 004665c5
    # block 0x004665c7: entered by fall-through of je at 0x004665c5, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004665da
    mov eax, dword ptr [ebp - local_c]           # 004665c7
    add eax, 0x46f                               # 004665ca
    push eax                                     # 004665cf
    mov ecx, 0x5c3a67                            # 004665d0
    call FUN_004fb77a                            # 004665d5
L_004665da:
    # block 0x004665da: entered by je at 0x004665c5, 7 instruction(s), ends with je to 0x00466606 (forward)
    mov edi, 0x54b5e0                            # 004665da
    mov esi, dword ptr [ebp - local_c]           # 004665df
    add esi, 0x4a0                               # 004665e2
    mov ecx, 0x9                                 # 004665e8
    {load} xor edx, edx                          # 004665ed
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004665ef
    je.d8 L_00466606                             # 004665f1
    # block 0x004665f3: entered by fall-through of je at 0x004665f1, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00466606
    mov eax, dword ptr [ebp - local_c]           # 004665f3
    add eax, 0x4a0                               # 004665f6
    push eax                                     # 004665fb
    mov ecx, 0x5c3a67                            # 004665fc
    call FUN_004fb77a                            # 00466601
L_00466606:
    # block 0x00466606: entered by je at 0x004665f1, 11 instruction(s), ends with forward jump to 0x00466d99
    mov ecx, dword ptr [ebp - local_1c]          # 00466606
    mov byte ptr [ecx + field_4e], 0x0           # 00466609
    mov edx, dword ptr [ebp - local_1c]          # 0046660d
    mov byte ptr [edx + field_4d], 0x0           # 00466610
    mov eax, dword ptr [ebp - local_1c]          # 00466614
    mov dword ptr [eax + field_45], 0x0          # 00466617
    mov ecx, dword ptr [ebp - local_1c]          # 0046661e
    movsx edx, word ptr [ecx + field_1e]         # 00466621
    imul edx, edx, 0x8d                          # 00466625
    mov dword ptr [edx + 0x5bb632], 0x1          # 0046662b
    jmp.d32 L_00466d99                           # 00466635
L_0046663a:
    # block 0x0046663a: entered by je at 0x00466313, 5 instruction(s), ends with ja to 0x004669a5 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 0046663a
    mov ecx, dword ptr [eax + field_45]          # 0046663d
    mov dword ptr [ebp - local_24], ecx          # 00466640
    cmp dword ptr [ebp - local_24], 0x3          # 00466643
    ja.d32 L_004669a5                            # 00466647
    # block 0x0046664d: entered by fall-through of ja at 0x00466647, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x466da1]
    mov edx, dword ptr [ebp - local_24]          # 0046664d
    jmp dword ptr [4*edx + SWTAB_00466da1_VA]    # 00466650
L_00466657:
    # block 0x00466657: entered by switch case, 5 instruction(s), ends with jne to 0x00466670 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00466657
    {load} xor ecx, ecx                          # 0046665a
    mov cl, byte ptr [eax + field_3e]            # 0046665c
    test ecx, ecx                                # 0046665f
    jne.d8 L_00466670                            # 00466661
    # block 0x00466663: entered by fall-through of jne at 0x00466661, 3 instruction(s), calls FUN_00466247, ends with forward jump to 0x004668a4
    mov ecx, dword ptr [ebp - local_1c]          # 00466663
    call FUN_00466247                            # 00466666
    jmp.d32 L_004668a4                           # 0046666b
L_00466670:
    # block 0x00466670: entered by jne at 0x00466661, 5 instruction(s), ends with jne to 0x004668a4 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00466670
    {load} xor eax, eax                          # 00466673
    mov al, byte ptr [edx + field_4e]            # 00466675
    test eax, eax                                # 00466678
    jne.d32 L_004668a4                           # 0046667a
    # block 0x00466680: entered by fall-through of jne at 0x0046667a, 7 instruction(s), ends with jge to 0x004666af (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00466680
    movsx edx, word ptr [ecx + field_43]         # 00466683
    mov eax, dword ptr [ebp - local_c]           # 00466687
    movsx ecx, word ptr [eax + field_308]        # 0046668a
    sub ecx, 0x1                                 # 00466691
    {load} cmp edx, ecx                          # 00466694
    jge.d8 L_004666af                            # 00466696
    # block 0x00466698: entered by fall-through of jge at 0x00466696, 6 instruction(s), ends with forward jump to 0x00466882
    mov edx, dword ptr [ebp - local_1c]          # 00466698
    mov ax, word ptr [edx + field_43]            # 0046669b
    .insn 0x66, 0x05, 0x0001{:u16}               # 0046669f
    mov ecx, dword ptr [ebp - local_1c]          # 004666a3
    mov word ptr [ecx + field_43], ax            # 004666a6
    jmp.d32 L_00466882                           # 004666aa
L_004666af:
    # block 0x004666af: entered by jge at 0x00466696, 9 instruction(s), ends with je to 0x00466705 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004666af
    mov word ptr [edx + field_43], 0x0           # 004666b2
    mov edi, 0x54b5ec                            # 004666b8
    mov esi, dword ptr [ebp - local_c]           # 004666bd
    add esi, 0x3dc                               # 004666c0
    mov ecx, 0x9                                 # 004666c6
    {load} xor eax, eax                          # 004666cb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004666cd
    je.d8 L_00466705                             # 004666cf
    # block 0x004666d1: entered by fall-through of je at 0x004666cf, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00466705 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004666d1
    movsx edx, word ptr [ecx + field_3fd]        # 004666d4
    mov dword ptr [ebp - local_10], edx          # 004666db
    mov eax, dword ptr [ebp - local_10]          # 004666de
    push eax                                     # 004666e1
    mov ecx, 0x5cf1eb                            # 004666e2
    call FUN_004f6334                            # 004666e7
    test eax, eax                                # 004666ec
    jne.d8 L_00466705                            # 004666ee
    # block 0x004666f0: entered by fall-through of jne at 0x004666ee, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00466705
    mov ecx, dword ptr [ebp - local_c]           # 004666f0
    mov dx, word ptr [ecx + field_3fd]           # 004666f3
    push edx                                     # 004666fa
    mov ecx, 0x5c3a67                            # 004666fb
    call FUN_004fb2e3                            # 00466700
L_00466705:
    # block 0x00466705: entered by je at 0x004666cf; jne at 0x004666ee, 4 instruction(s), ends with jne to 0x004667c5 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00466705
    movsx ecx, word ptr [eax + field_54]         # 00466708
    cmp ecx, 0xe                                 # 0046670c
    jne.d32 L_004667c5                           # 0046670f
    # block 0x00466715: entered by fall-through of jne at 0x0046670f, 12 instruction(s), ends with jge to 0x00466753 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00466715
    mov byte ptr [edx + field_3e], 0x0           # 00466718
    mov eax, dword ptr [ebp - local_1c]          # 0046671c
    mov byte ptr [eax + field_42], 0x1           # 0046671f
    mov ecx, dword ptr [ebp - local_1c]          # 00466723
    movsx edx, word ptr [ecx + field_2a]         # 00466726
    mov eax, dword ptr [ebp - local_1c]          # 0046672a
    movsx ecx, word ptr [eax + 2*edx + field_2e] # 0046672d
    mov edx, dword ptr [ebp - local_1c]          # 00466732
    movsx eax, word ptr [edx + field_2c]         # 00466735
    {load} cmp ecx, eax                          # 00466739
    jge.d8 L_00466753                            # 0046673b
    # block 0x0046673d: entered by fall-through of jge at 0x0046673b, 6 instruction(s), falls into the block at 0x00466753
    mov ecx, dword ptr [ebp - local_1c]          # 0046673d
    movsx edx, word ptr [ecx + field_2a]         # 00466740
    mov eax, dword ptr [ebp - local_1c]          # 00466744
    mov ecx, dword ptr [ebp - local_1c]          # 00466747
    mov cx, word ptr [ecx + field_2c]            # 0046674a
    mov word ptr [eax + 2*edx + field_2e], cx    # 0046674e
L_00466753:
    # block 0x00466753: entered by jge at 0x0046673b, 6 instruction(s), ends with jle to 0x004667a7 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00466753
    movsx eax, word ptr [edx + field_2a]         # 00466756
    mov ecx, dword ptr [ebp - local_1c]          # 0046675a
    movsx edx, word ptr [ecx + 2*eax + field_2e] # 0046675d
    test edx, edx                                # 00466762
    jle.d8 L_004667a7                            # 00466764
    # block 0x00466766: entered by fall-through of jle at 0x00466764, 5 instruction(s), ends with je to 0x004667a7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00466766
    {load} xor ecx, ecx                          # 00466769
    mov cl, byte ptr [eax + field_51d]           # 0046676b
    test ecx, ecx                                # 00466771
    je.d8 L_004667a7                             # 00466773
    # block 0x00466775: entered by fall-through of je at 0x00466773, 4 instruction(s), ends with je to 0x004667a7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00466775
    movsx eax, word ptr [edx + field_51e]        # 00466778
    cmp dword ptr [4*eax + 0x583bd5], 0x1        # 0046677f
    je.d8 L_004667a7                             # 00466787
    # block 0x00466789: entered by fall-through of je at 0x00466787, 5 instruction(s), ends with je to 0x004667a7 (forward)
    movsx ecx, word ptr [0x583a29]               # 00466789
    mov edx, dword ptr [ebp - local_c]           # 00466790
    movsx eax, word ptr [edx + field_51e]        # 00466793
    {load} cmp ecx, eax                          # 0046679a
    je.d8 L_004667a7                             # 0046679c
    # block 0x0046679e: entered by fall-through of je at 0x0046679c, 3 instruction(s), ends with forward jump to 0x004667c0
    mov ecx, dword ptr [ebp - local_1c]          # 0046679e
    mov byte ptr [ecx + field_4f], 0x1           # 004667a1
    jmp.d8 L_004667c0                            # 004667a5
L_004667a7:
    # block 0x004667a7: entered by jle at 0x00466764; je at 0x00466773; je at 0x00466787; je at 0x0046679c, 6 instruction(s), falls into the block at 0x004667c0
    mov edx, dword ptr [ebp - local_1c]          # 004667a7
    mov word ptr [edx + field_2c], 0x0           # 004667aa
    mov eax, dword ptr [ebp - local_1c]          # 004667b0
    mov byte ptr [eax + field_41], 0x1           # 004667b3
    mov ecx, dword ptr [ebp - local_1c]          # 004667b7
    mov word ptr [ecx + field_54], 0x0           # 004667ba
L_004667c0:
    # block 0x004667c0: entered by jmp at 0x004667a5, 1 instruction(s), ends with forward jump to 0x00466870
    jmp.d32 L_00466870                           # 004667c0
L_004667c5:
    # block 0x004667c5: entered by jne at 0x0046670f, 4 instruction(s), ends with jl to 0x0046680c (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004667c5
    movsx eax, word ptr [edx + field_54]         # 004667c8
    cmp eax, 0xc                                 # 004667cc
    jl.d8 L_0046680c                             # 004667cf
    # block 0x004667d1: entered by fall-through of jl at 0x004667cf, 4 instruction(s), ends with jle to 0x0046680a (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004667d1
    movsx edx, word ptr [ecx + field_2c]         # 004667d4
    test edx, edx                                # 004667d8
    jle.d8 L_0046680a                            # 004667da
    # block 0x004667dc: entered by fall-through of jle at 0x004667da, 7 instruction(s), ends with je to 0x0046680a (forward)
    mov edi, 0x54b5f8                            # 004667dc
    mov esi, dword ptr [ebp - local_c]           # 004667e1
    add esi, 0x4a0                               # 004667e4
    mov ecx, 0x9                                 # 004667ea
    {load} xor eax, eax                          # 004667ef
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004667f1
    je.d8 L_0046680a                             # 004667f3
    # block 0x004667f5: entered by fall-through of je at 0x004667f3, 5 instruction(s), calls FUN_004fc878, falls into the block at 0x0046680a
    mov ecx, dword ptr [ebp - local_c]           # 004667f5
    mov dx, word ptr [ecx + field_4c1]           # 004667f8
    push edx                                     # 004667ff
    mov ecx, 0x5c3a67                            # 00466800
    call FUN_004fc878                            # 00466805
L_0046680a:
    # block 0x0046680a: entered by jle at 0x004667da; je at 0x004667f3, 1 instruction(s), ends with forward jump to 0x00466870
    jmp.d8 L_00466870                            # 0046680a
L_0046680c:
    # block 0x0046680c: entered by jl at 0x004667cf, 4 instruction(s), ends with jl to 0x00466870 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 0046680c
    movsx ecx, word ptr [eax + field_54]         # 0046680f
    cmp ecx, 0x2                                 # 00466813
    jl.d8 L_00466870                             # 00466816
    # block 0x00466818: entered by fall-through of jl at 0x00466816, 4 instruction(s), ends with jle to 0x00466870 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00466818
    movsx eax, word ptr [edx + field_2c]         # 0046681b
    test eax, eax                                # 0046681f
    jle.d8 L_00466870                            # 00466821
    # block 0x00466823: entered by fall-through of jle at 0x00466821, 7 instruction(s), ends with je to 0x00466870 (forward)
    mov edi, 0x54b604                            # 00466823
    mov esi, dword ptr [ebp - local_c]           # 00466828
    add esi, 0x4a0                               # 0046682b
    mov ecx, 0x9                                 # 00466831
    {load} xor edx, edx                          # 00466836
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00466838
    je.d8 L_00466870                             # 0046683a
    # block 0x0046683c: entered by fall-through of je at 0x0046683a, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00466870 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046683c
    movsx ecx, word ptr [eax + field_4c1]        # 0046683f
    mov dword ptr [ebp - local_14], ecx          # 00466846
    mov edx, dword ptr [ebp - local_14]          # 00466849
    push edx                                     # 0046684c
    mov ecx, 0x5cf1eb                            # 0046684d
    call FUN_004f6334                            # 00466852
    test eax, eax                                # 00466857
    jne.d8 L_00466870                            # 00466859
    # block 0x0046685b: entered by fall-through of jne at 0x00466859, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00466870
    mov eax, dword ptr [ebp - local_c]           # 0046685b
    mov cx, word ptr [eax + field_4c1]           # 0046685e
    push ecx                                     # 00466865
    mov ecx, 0x5c3a67                            # 00466866
    call FUN_004fb2e3                            # 0046686b
L_00466870:
    # block 0x00466870: entered by jmp at 0x004667c0; jmp at 0x0046680a; jl at 0x00466816; jle at 0x00466821; more, 5 instruction(s), falls into the block at 0x00466882
    mov edx, dword ptr [ebp - local_1c]          # 00466870
    mov ax, word ptr [edx + field_54]            # 00466873
    .insn 0x66, 0x05, 0x0001{:u16}               # 00466877
    mov ecx, dword ptr [ebp - local_1c]          # 0046687b
    mov word ptr [ecx + field_54], ax            # 0046687e
L_00466882:
    # block 0x00466882: entered by jmp at 0x004666aa, 8 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004668a4
    call dword ptr [0x52a23c]                    # 00466882
    mov edx, dword ptr [ebp - local_c]           # 00466888
    movsx ecx, word ptr [edx + field_3ca]        # 0046688b
    {load} add eax, ecx                          # 00466892
    mov edx, dword ptr [ebp - local_1c]          # 00466894
    mov dword ptr [edx + field_50], eax          # 00466897
    mov eax, dword ptr [ebp - local_1c]          # 0046689a
    mov dword ptr [eax + field_45], 0x2          # 0046689d
L_004668a4:
    # block 0x004668a4: entered by jmp at 0x0046666b; jne at 0x0046667a, 1 instruction(s), ends with forward jump to 0x004669a5
    jmp.d32 L_004669a5                           # 004668a4
L_004668a9:
    # block 0x004668a9: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004668e5 (forward)
    call dword ptr [0x52a23c]                    # 004668a9
    mov ecx, dword ptr [ebp - local_1c]          # 004668af
    cmp eax, dword ptr [ecx + field_50]          # 004668b2
    jb.d8 L_004668e5                             # 004668b5
    # block 0x004668b7: entered by fall-through of jb at 0x004668b5, 5 instruction(s), ends with jne to 0x004668db (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004668b7
    {load} xor eax, eax                          # 004668ba
    mov al, byte ptr [edx + field_4e]            # 004668bc
    test eax, eax                                # 004668bf
    jne.d8 L_004668db                            # 004668c1
    # block 0x004668c3: entered by fall-through of jne at 0x004668c1, 5 instruction(s), ends with jne to 0x004668db (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004668c3
    {load} xor edx, edx                          # 004668c6
    mov dl, byte ptr [ecx + field_4f]            # 004668c8
    test edx, edx                                # 004668cb
    jne.d8 L_004668db                            # 004668cd
    # block 0x004668cf: entered by fall-through of jne at 0x004668cd, 3 instruction(s), ends with forward jump to 0x004668e5
    mov eax, dword ptr [ebp - local_1c]          # 004668cf
    mov dword ptr [eax + field_45], 0x0          # 004668d2
    jmp.d8 L_004668e5                            # 004668d9
L_004668db:
    # block 0x004668db: entered by jne at 0x004668c1; jne at 0x004668cd, 2 instruction(s), falls into the block at 0x004668e5
    mov ecx, dword ptr [ebp - local_1c]          # 004668db
    mov dword ptr [ecx + field_45], 0x1          # 004668de
L_004668e5:
    # block 0x004668e5: entered by jb at 0x004668b5; jmp at 0x004668d9, 1 instruction(s), ends with forward jump to 0x004669a5
    jmp.d32 L_004669a5                           # 004668e5
L_004668ea:
    # block 0x004668ea: entered by switch case, 5 instruction(s), ends with je to 0x00466943 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004668ea
    {load} xor eax, eax                          # 004668ed
    mov al, byte ptr [edx + field_4e]            # 004668ef
    test eax, eax                                # 004668f2
    je.d8 L_00466943                             # 004668f4
    # block 0x004668f6: entered by fall-through of je at 0x004668f4, 7 instruction(s), ends with je to 0x00466943 (forward)
    mov edi, 0x54b610                            # 004668f6
    mov esi, dword ptr [ebp - local_c]           # 004668fb
    add esi, 0x4ec                               # 004668fe
    mov ecx, 0x9                                 # 00466904
    {load} xor edx, edx                          # 00466909
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046690b
    je.d8 L_00466943                             # 0046690d
    # block 0x0046690f: entered by fall-through of je at 0x0046690d, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0046695a
    mov eax, dword ptr [ebp - local_c]           # 0046690f
    add eax, 0x4ec                               # 00466912
    push eax                                     # 00466917
    mov ecx, 0x5c3a67                            # 00466918
    call FUN_004fb77a                            # 0046691d
    mov ecx, dword ptr [ebp - local_c]           # 00466922
    mov dx, word ptr [ecx + field_50d]           # 00466925
    push edx                                     # 0046692c
    mov ecx, 0x5c3a67                            # 0046692d
    call FUN_004fb2e3                            # 00466932
    mov eax, dword ptr [ebp - local_1c]          # 00466937
    mov dword ptr [eax + field_45], 0x3          # 0046693a
    jmp.d8 L_0046695a                            # 00466941
L_00466943:
    # block 0x00466943: entered by je at 0x004668f4; je at 0x0046690d, 4 instruction(s), falls into the block at 0x0046695a
    mov ecx, dword ptr [ebp - local_1c]          # 00466943
    movsx edx, word ptr [ecx + field_1e]         # 00466946
    imul edx, edx, 0x8d                          # 0046694a
    mov dword ptr [edx + 0x5bb632], 0x2          # 00466950
L_0046695a:
    # block 0x0046695a: entered by jmp at 0x00466941, 1 instruction(s), ends with forward jump to 0x004669a5
    jmp.d8 L_004669a5                            # 0046695a
L_0046695c:
    # block 0x0046695c: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004669a5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046695c
    movsx ecx, word ptr [eax + field_50d]        # 0046695f
    mov dword ptr [ebp - local_18], ecx          # 00466966
    mov edx, dword ptr [ebp - local_18]          # 00466969
    push edx                                     # 0046696c
    mov ecx, 0x5cf1eb                            # 0046696d
    call FUN_004f6334                            # 00466972
    test eax, eax                                # 00466977
    jne.d8 L_004669a5                            # 00466979
    # block 0x0046697b: entered by fall-through of jne at 0x00466979, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004669a5
    mov eax, dword ptr [ebp - local_c]           # 0046697b
    add eax, 0x4ec                               # 0046697e
    push eax                                     # 00466983
    mov ecx, 0x5c3a67                            # 00466984
    call FUN_004fba69                            # 00466989
    mov ecx, dword ptr [ebp - local_1c]          # 0046698e
    movsx edx, word ptr [ecx + field_1e]         # 00466991
    imul edx, edx, 0x8d                          # 00466995
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046699b
L_004669a5:
    # block 0x004669a5: entered by ja at 0x00466647; jmp at 0x004668a4; jmp at 0x004668e5; jmp at 0x0046695a; more, 1 instruction(s), ends with forward jump to 0x00466d99
    jmp.d32 L_00466d99                           # 004669a5
L_004669aa:
    # block 0x004669aa: entered by je at 0x0046631d, 8 instruction(s), ends with je to 0x004669e1 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004669aa
    mov edi, 0x54b61c                            # 004669b4
    mov esi, dword ptr [ebp - local_c]           # 004669b9
    add esi, 0x3dc                               # 004669bc
    mov ecx, 0x9                                 # 004669c2
    {load} xor eax, eax                          # 004669c7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004669c9
    je.d8 L_004669e1                             # 004669cb
    # block 0x004669cd: entered by fall-through of je at 0x004669cb, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004669e1
    mov ecx, dword ptr [ebp - local_c]           # 004669cd
    add ecx, 0x3dc                               # 004669d0
    push ecx                                     # 004669d6
    mov ecx, 0x5c3a67                            # 004669d7
    call FUN_004fba69                            # 004669dc
L_004669e1:
    # block 0x004669e1: entered by je at 0x004669cb, 7 instruction(s), ends with je to 0x00466a0d (forward)
    mov edi, 0x54b628                            # 004669e1
    mov esi, dword ptr [ebp - local_c]           # 004669e6
    add esi, 0x40d                               # 004669e9
    mov ecx, 0x9                                 # 004669ef
    {load} xor edx, edx                          # 004669f4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004669f6
    je.d8 L_00466a0d                             # 004669f8
    # block 0x004669fa: entered by fall-through of je at 0x004669f8, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00466a0d
    mov eax, dword ptr [ebp - local_c]           # 004669fa
    add eax, 0x40d                               # 004669fd
    push eax                                     # 00466a02
    mov ecx, 0x5c3a67                            # 00466a03
    call FUN_004fba69                            # 00466a08
L_00466a0d:
    # block 0x00466a0d: entered by je at 0x004669f8, 7 instruction(s), ends with je to 0x00466a39 (forward)
    mov edi, 0x54b634                            # 00466a0d
    mov esi, dword ptr [ebp - local_c]           # 00466a12
    add esi, 0x43e                               # 00466a15
    mov ecx, 0x9                                 # 00466a1b
    {load} xor edx, edx                          # 00466a20
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00466a22
    je.d8 L_00466a39                             # 00466a24
    # block 0x00466a26: entered by fall-through of je at 0x00466a24, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00466a39
    mov eax, dword ptr [ebp - local_c]           # 00466a26
    add eax, 0x43e                               # 00466a29
    push eax                                     # 00466a2e
    mov ecx, 0x5c3a67                            # 00466a2f
    call FUN_004fba69                            # 00466a34
L_00466a39:
    # block 0x00466a39: entered by je at 0x00466a24, 7 instruction(s), ends with je to 0x00466a65 (forward)
    mov edi, 0x54b640                            # 00466a39
    mov esi, dword ptr [ebp - local_c]           # 00466a3e
    add esi, 0x46f                               # 00466a41
    mov ecx, 0x9                                 # 00466a47
    {load} xor edx, edx                          # 00466a4c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00466a4e
    je.d8 L_00466a65                             # 00466a50
    # block 0x00466a52: entered by fall-through of je at 0x00466a50, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00466a65
    mov eax, dword ptr [ebp - local_c]           # 00466a52
    add eax, 0x46f                               # 00466a55
    push eax                                     # 00466a5a
    mov ecx, 0x5c3a67                            # 00466a5b
    call FUN_004fba69                            # 00466a60
L_00466a65:
    # block 0x00466a65: entered by je at 0x00466a50, 7 instruction(s), ends with je to 0x00466a91 (forward)
    mov edi, 0x54b64c                            # 00466a65
    mov esi, dword ptr [ebp - local_c]           # 00466a6a
    add esi, 0x4a0                               # 00466a6d
    mov ecx, 0x9                                 # 00466a73
    {load} xor edx, edx                          # 00466a78
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00466a7a
    je.d8 L_00466a91                             # 00466a7c
    # block 0x00466a7e: entered by fall-through of je at 0x00466a7c, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00466a91
    mov eax, dword ptr [ebp - local_c]           # 00466a7e
    add eax, 0x4a0                               # 00466a81
    push eax                                     # 00466a86
    mov ecx, 0x5c3a67                            # 00466a87
    call FUN_004fba69                            # 00466a8c
L_00466a91:
    # block 0x00466a91: entered by je at 0x00466a7c, 5 instruction(s), ends with je to 0x00466bcc (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00466a91
    {load} xor edx, edx                          # 00466a94
    mov dl, byte ptr [ecx + field_4d]            # 00466a96
    test edx, edx                                # 00466a99
    je.d32 L_00466bcc                            # 00466a9b
    # block 0x00466aa1: entered by fall-through of je at 0x00466a9b, 4 instruction(s), ends with je to 0x00466b53 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00466aa1
    movsx ecx, word ptr [eax + field_536]        # 00466aa4
    cmp ecx, 0x270f                              # 00466aab
    je.d32 L_00466b53                            # 00466ab1
    # block 0x00466ab7: entered by fall-through of je at 0x00466ab1, 25 instruction(s), ends with jne to 0x00466b3f (forward)
    mov edx, dword ptr [ebp - local_c]           # 00466ab7
    movsx eax, word ptr [edx + field_536]        # 00466aba
    mov dword ptr [0x5bb57b], eax                # 00466ac1
    mov ecx, dword ptr [ebp - local_c]           # 00466ac6
    mov dx, word ptr [ecx + field_538]           # 00466ac9
    mov word ptr [0x5bb599], dx                  # 00466ad0
    mov eax, dword ptr [ebp - local_c]           # 00466ad7
    mov cx, word ptr [eax + field_53a]           # 00466ada
    mov word ptr [0x5bb595], cx                  # 00466ae1
    mov edx, dword ptr [ebp - local_c]           # 00466ae8
    mov ax, word ptr [edx + field_53c]           # 00466aeb
    mov word ptr [0x5c39ff], ax                  # 00466af2
    mov ecx, dword ptr [ebp - local_c]           # 00466af8
    mov edx, dword ptr [ecx + field_53e]         # 00466afb
    mov dword ptr [0x5bb59b], edx                # 00466b01
    mov eax, dword ptr [ebp - local_c]           # 00466b07
    mov ecx, dword ptr [eax + field_542]         # 00466b0a
    mov dword ptr [0x5bb59f], ecx                # 00466b10
    mov edx, dword ptr [ebp - local_c]           # 00466b16
    mov eax, dword ptr [edx + field_546]         # 00466b19
    mov dword ptr [0x5bb5a3], eax                # 00466b1f
    mov ecx, dword ptr [ebp - local_c]           # 00466b24
    movsx edx, word ptr [ecx + field_54a]        # 00466b27
    cmp edx, 0x1                                 # 00466b2e
    jne.d8 L_00466b3f                            # 00466b31
    # block 0x00466b33: entered by fall-through of jne at 0x00466b31, 2 instruction(s), ends with forward jump to 0x00466b49
    mov dword ptr [0x5bb1ca], 0x0                # 00466b33
    jmp.d8 L_00466b49                            # 00466b3d
L_00466b3f:
    # block 0x00466b3f: entered by jne at 0x00466b31, 1 instruction(s), falls into the block at 0x00466b49
    mov dword ptr [0x5bb1ca], 0x1                # 00466b3f
L_00466b49:
    # block 0x00466b49: entered by jmp at 0x00466b3d, 1 instruction(s), falls into the block at 0x00466b53
    mov dword ptr [0x583999], 0x4                # 00466b49
L_00466b53:
    # block 0x00466b53: entered by je at 0x00466ab1, 3 instruction(s), ends with forward jump to 0x00466b6b
    mov byte ptr [ebp - local_8], 0x0            # 00466b53
    mov word ptr [ebp - local_4], 0x0            # 00466b57
    jmp.d8 L_00466b6b                            # 00466b5d
L_00466b5f:
    # block 0x00466b5f: entered by jmp at 0x00466b8e, 3 instruction(s), falls into the block at 0x00466b6b
    mov ax, word ptr [ebp - local_4]             # 00466b5f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00466b63
    mov word ptr [ebp - local_4], ax             # 00466b67
L_00466b6b:
    # block 0x00466b6b: entered by jmp at 0x00466b5d, 5 instruction(s), ends with jge to 0x00466b90 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00466b6b
    mov edx, dword ptr [ebp - local_c]           # 00466b6f
    movsx eax, word ptr [edx + field_42]         # 00466b72
    {load} cmp ecx, eax                          # 00466b76
    jge.d8 L_00466b90                            # 00466b78
    # block 0x00466b7a: entered by fall-through of jge at 0x00466b78, 5 instruction(s), ends with je to 0x00466b8e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00466b7a
    mov edx, dword ptr [ebp - local_1c]          # 00466b7e
    movsx eax, word ptr [edx + 2*ecx + field_2e] # 00466b81
    test eax, eax                                # 00466b86
    je.d8 L_00466b8e                             # 00466b88
    # block 0x00466b8a: entered by fall-through of je at 0x00466b88, 1 instruction(s), falls into the block at 0x00466b8e
    mov byte ptr [ebp - local_8], 0x1            # 00466b8a
L_00466b8e:
    # block 0x00466b8e: entered by je at 0x00466b88, 1 instruction(s), ends with backward jump to 0x00466b5f
    jmp.d8 L_00466b5f                            # 00466b8e
L_00466b90:
    # block 0x00466b90: entered by jge at 0x00466b78, 4 instruction(s), ends with je to 0x00466bc7 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00466b90
    movsx edx, word ptr [ecx + field_54c]        # 00466b93
    cmp edx, -0x1                                # 00466b9a
    je.d8 L_00466bc7                             # 00466b9d
    # block 0x00466b9f: entered by fall-through of je at 0x00466b9d, 4 instruction(s), ends with je to 0x00466bc7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00466b9f
    and eax, 0xff                                # 00466ba2
    test eax, eax                                # 00466ba7
    je.d8 L_00466bc7                             # 00466ba9
    # block 0x00466bab: entered by fall-through of je at 0x00466ba9, 6 instruction(s), falls into the block at 0x00466bc7
    mov ecx, dword ptr [ebp - local_c]           # 00466bab
    {load} xor edx, edx                          # 00466bae
    mov dl, byte ptr [ecx + field_54e]           # 00466bb0
    mov eax, dword ptr [ebp - local_c]           # 00466bb6
    movsx ecx, word ptr [eax + field_54c]        # 00466bb9
    mov dword ptr [4*ecx + 0x585801], edx        # 00466bc0
L_00466bc7:
    # block 0x00466bc7: entered by je at 0x00466b9d; je at 0x00466ba9, 1 instruction(s), ends with forward jump to 0x00466d81
    jmp.d32 L_00466d81                           # 00466bc7
L_00466bcc:
    # block 0x00466bcc: entered by je at 0x00466a9b, 5 instruction(s), ends with je to 0x00466cbf (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00466bcc
    {load} xor eax, eax                          # 00466bcf
    mov al, byte ptr [edx + field_4e]            # 00466bd1
    test eax, eax                                # 00466bd4
    je.d32 L_00466cbf                            # 00466bd6
    # block 0x00466bdc: entered by fall-through of je at 0x00466bd6, 4 instruction(s), ends with je to 0x00466c8f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00466bdc
    movsx edx, word ptr [ecx + field_4d1]        # 00466bdf
    cmp edx, 0x270f                              # 00466be6
    je.d32 L_00466c8f                            # 00466bec
    # block 0x00466bf2: entered by fall-through of je at 0x00466bec, 25 instruction(s), ends with jne to 0x00466c7b (forward)
    mov eax, dword ptr [ebp - local_c]           # 00466bf2
    movsx ecx, word ptr [eax + field_4d1]        # 00466bf5
    mov dword ptr [0x5bb57b], ecx                # 00466bfc
    mov edx, dword ptr [ebp - local_c]           # 00466c02
    mov ax, word ptr [edx + field_4d3]           # 00466c05
    mov word ptr [0x5bb599], ax                  # 00466c0c
    mov ecx, dword ptr [ebp - local_c]           # 00466c12
    mov dx, word ptr [ecx + field_4d5]           # 00466c15
    mov word ptr [0x5bb595], dx                  # 00466c1c
    mov eax, dword ptr [ebp - local_c]           # 00466c23
    mov cx, word ptr [eax + field_4d7]           # 00466c26
    mov word ptr [0x5c39ff], cx                  # 00466c2d
    mov edx, dword ptr [ebp - local_c]           # 00466c34
    mov eax, dword ptr [edx + field_4d9]         # 00466c37
    mov dword ptr [0x5bb59b], eax                # 00466c3d
    mov ecx, dword ptr [ebp - local_c]           # 00466c42
    mov edx, dword ptr [ecx + field_4dd]         # 00466c45
    mov dword ptr [0x5bb59f], edx                # 00466c4b
    mov eax, dword ptr [ebp - local_c]           # 00466c51
    mov ecx, dword ptr [eax + field_4e1]         # 00466c54
    mov dword ptr [0x5bb5a3], ecx                # 00466c5a
    mov edx, dword ptr [ebp - local_c]           # 00466c60
    movsx eax, word ptr [edx + field_4e5]        # 00466c63
    cmp eax, 0x1                                 # 00466c6a
    jne.d8 L_00466c7b                            # 00466c6d
    # block 0x00466c6f: entered by fall-through of jne at 0x00466c6d, 2 instruction(s), ends with forward jump to 0x00466c85
    mov dword ptr [0x5bb1ca], 0x0                # 00466c6f
    jmp.d8 L_00466c85                            # 00466c79
L_00466c7b:
    # block 0x00466c7b: entered by jne at 0x00466c6d, 1 instruction(s), falls into the block at 0x00466c85
    mov dword ptr [0x5bb1ca], 0x1                # 00466c7b
L_00466c85:
    # block 0x00466c85: entered by jmp at 0x00466c79, 1 instruction(s), falls into the block at 0x00466c8f
    mov dword ptr [0x583999], 0x4                # 00466c85
L_00466c8f:
    # block 0x00466c8f: entered by je at 0x00466bec, 4 instruction(s), ends with je to 0x00466cba (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00466c8f
    movsx edx, word ptr [ecx + field_4e7]        # 00466c92
    cmp edx, -0x1                                # 00466c99
    je.d8 L_00466cba                             # 00466c9c
    # block 0x00466c9e: entered by fall-through of je at 0x00466c9c, 6 instruction(s), falls into the block at 0x00466cba
    mov eax, dword ptr [ebp - local_c]           # 00466c9e
    {load} xor ecx, ecx                          # 00466ca1
    mov cl, byte ptr [eax + field_4e9]           # 00466ca3
    mov edx, dword ptr [ebp - local_c]           # 00466ca9
    movsx eax, word ptr [edx + field_4e7]        # 00466cac
    mov dword ptr [4*eax + 0x585801], ecx        # 00466cb3
L_00466cba:
    # block 0x00466cba: entered by je at 0x00466c9c, 1 instruction(s), ends with forward jump to 0x00466d81
    jmp.d32 L_00466d81                           # 00466cba
L_00466cbf:
    # block 0x00466cbf: entered by je at 0x00466bd6, 5 instruction(s), ends with je to 0x00466d81 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00466cbf
    {load} xor edx, edx                          # 00466cc2
    mov dl, byte ptr [ecx + field_4f]            # 00466cc4
    test edx, edx                                # 00466cc7
    je.d32 L_00466d81                            # 00466cc9
    # block 0x00466ccf: entered by fall-through of je at 0x00466cc9, 4 instruction(s), ends with je to 0x00466d81 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00466ccf
    movsx ecx, word ptr [eax + field_520]        # 00466cd2
    cmp ecx, 0x270f                              # 00466cd9
    je.d32 L_00466d81                            # 00466cdf
    # block 0x00466ce5: entered by fall-through of je at 0x00466cdf, 25 instruction(s), ends with jne to 0x00466d6d (forward)
    mov edx, dword ptr [ebp - local_c]           # 00466ce5
    movsx eax, word ptr [edx + field_520]        # 00466ce8
    mov dword ptr [0x5bb57b], eax                # 00466cef
    mov ecx, dword ptr [ebp - local_c]           # 00466cf4
    mov dx, word ptr [ecx + field_522]           # 00466cf7
    mov word ptr [0x5bb599], dx                  # 00466cfe
    mov eax, dword ptr [ebp - local_c]           # 00466d05
    mov cx, word ptr [eax + field_524]           # 00466d08
    mov word ptr [0x5bb595], cx                  # 00466d0f
    mov edx, dword ptr [ebp - local_c]           # 00466d16
    mov ax, word ptr [edx + field_526]           # 00466d19
    mov word ptr [0x5c39ff], ax                  # 00466d20
    mov ecx, dword ptr [ebp - local_c]           # 00466d26
    mov edx, dword ptr [ecx + field_528]         # 00466d29
    mov dword ptr [0x5bb59b], edx                # 00466d2f
    mov eax, dword ptr [ebp - local_c]           # 00466d35
    mov ecx, dword ptr [eax + field_52c]         # 00466d38
    mov dword ptr [0x5bb59f], ecx                # 00466d3e
    mov edx, dword ptr [ebp - local_c]           # 00466d44
    mov eax, dword ptr [edx + field_530]         # 00466d47
    mov dword ptr [0x5bb5a3], eax                # 00466d4d
    mov ecx, dword ptr [ebp - local_c]           # 00466d52
    movsx edx, word ptr [ecx + field_534]        # 00466d55
    cmp edx, 0x1                                 # 00466d5c
    jne.d8 L_00466d6d                            # 00466d5f
    # block 0x00466d61: entered by fall-through of jne at 0x00466d5f, 2 instruction(s), ends with forward jump to 0x00466d77
    mov dword ptr [0x5bb1ca], 0x0                # 00466d61
    jmp.d8 L_00466d77                            # 00466d6b
L_00466d6d:
    # block 0x00466d6d: entered by jne at 0x00466d5f, 1 instruction(s), falls into the block at 0x00466d77
    mov dword ptr [0x5bb1ca], 0x1                # 00466d6d
L_00466d77:
    # block 0x00466d77: entered by jmp at 0x00466d6b, 1 instruction(s), falls into the block at 0x00466d81
    mov dword ptr [0x583999], 0x4                # 00466d77
L_00466d81:
    # block 0x00466d81: entered by jmp at 0x00466bc7; jmp at 0x00466cba; je at 0x00466cc9; je at 0x00466cdf, 7 instruction(s), calls FUN_0042ba3a, FUN_00465b3c, falls into the block at 0x00466d99
    mov eax, dword ptr [ebp - local_1c]          # 00466d81
    mov cx, word ptr [eax + field_1e]            # 00466d84
    push ecx                                     # 00466d88
    call FUN_0042ba3a                            # 00466d89
    add esp, 0x4                                 # 00466d8e
    mov ecx, dword ptr [ebp - local_1c]          # 00466d91
    call FUN_00465b3c                            # 00466d94
L_00466d99:
    # block 0x00466d99: entered by jmp at 0x00466323; jmp at 0x00466635; jmp at 0x004669a5, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00466d99
    pop esi                                      # 00466d9a
    {load} mov esp, ebp                          # 00466d9b
    pop ebp                                      # 00466d9d
    ret 0x4                                      # 00466d9e

# --- data items (not part of the function) -------------------------
.org 0x00466da1 - 0x401000
SWTAB_00466da1:  # 4 case address(es)
    .long L_00466657 - .text + 0x401000
    .long L_004668ea - .text + 0x401000
    .long L_004668a9 - .text + 0x401000
    .long L_0046695c - .text + 0x401000
.set SWTAB_00466da1_VA, SWTAB_00466da1 - .text + 0x401000

