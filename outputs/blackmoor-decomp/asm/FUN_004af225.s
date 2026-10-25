# FUN_004af225
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004af225
# extent:       0x004af225-0x004af96e (1865 code bytes)
# span:         0x004af225-0x004af96e (code 1865, tables 0, padding 0)
# sha256:       6ee17ad23228ab9b89cba9aba70e6f3175a7164a3a7573037bc9773806390054
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004af225
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c, field_1e, field_24, field_2c7, field_2c9, field_2cb, field_2cd, field_2cf, field_2d3, field_2d7, field_2db, field_2dd and 15 more; [ecx + n] field_1c, field_1e, field_20, field_42, field_301, field_c17, field_c1b, field_c20, field_c35; [edx + n] field_1c, field_1e, field_6a, field_c17, field_c24, field_c35
# callees:      calls FUN_004e8d96, FUN_004c2790, FUN_004adb6c, FUN_004ae178, FUN_004c2dfb, FUN_004d39f9, FUN_004fb77a, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004ac97d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 414 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_42, 0x42  # offset +0x42
.equ field_6a, 0x6a  # offset +0x6a
.equ field_2c7, 0x2c7  # offset +0x2c7
.equ field_2c9, 0x2c9  # offset +0x2c9
.equ field_2cb, 0x2cb  # offset +0x2cb
.equ field_2cd, 0x2cd  # offset +0x2cd
.equ field_2cf, 0x2cf  # offset +0x2cf
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2db, 0x2db  # offset +0x2db
.equ field_2dd, 0x2dd  # offset +0x2dd
.equ field_2df, 0x2df  # offset +0x2df
.equ field_301, 0x301  # offset +0x301
.equ field_311, 0x311  # offset +0x311
.equ field_313, 0x313  # offset +0x313
.equ field_315, 0x315  # offset +0x315
.equ field_317, 0x317  # offset +0x317
.equ field_319, 0x319  # offset +0x319
.equ field_31d, 0x31d  # offset +0x31d
.equ field_321, 0x321  # offset +0x321
.equ field_325, 0x325  # offset +0x325
.equ field_327, 0x327  # offset +0x327
.equ field_329, 0x329  # offset +0x329
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c1b, 0xc1b  # offset +0xc1b
.equ field_c1f, 0xc1f  # offset +0xc1f
.equ field_c20, 0xc20  # offset +0xc20
.equ field_c24, 0xc24  # offset +0xc24
.equ field_c35, 0xc35  # offset +0xc35

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004ac97d, .text + (0x004ac97d - 0x401000)
.set FUN_004adb6c, .text + (0x004adb6c - 0x401000)
.set FUN_004ae178, .text + (0x004ae178 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004af225 - 0x401000
.globl FUN_004af225
FUN_004af225:
    # block 0x004af225: entry, 17 instruction(s), ends with je to 0x004af27b (forward)
    push ebp                                     # 004af225
    {load} mov ebp, esp                          # 004af226
    sub esp, 0x14                                # 004af228
    push esi                                     # 004af22b
    push edi                                     # 004af22c
    mov dword ptr [ebp - local_c], ecx           # 004af22d
    movsx eax, word ptr [ebp + arg_8]            # 004af230
    imul eax, eax, 0x8d                          # 004af234
    mov ecx, dword ptr [ebp - local_c]           # 004af23a
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004af23d
    mov dword ptr [ecx + field_c17], edx         # 004af243
    movsx eax, word ptr [ebp + arg_8]            # 004af249
    imul eax, eax, 0x8d                          # 004af24d
    mov ecx, dword ptr [eax + 0x5bb632]          # 004af253
    mov dword ptr [ebp - local_10], ecx          # 004af259
    cmp dword ptr [ebp - local_10], 0x0          # 004af25c
    je.d8 L_004af27b                             # 004af260
    # block 0x004af262: entered by fall-through of je at 0x004af260, 2 instruction(s), ends with je to 0x004af526 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004af262
    je.d32 L_004af526                            # 004af266
    # block 0x004af26c: entered by fall-through of je at 0x004af266, 2 instruction(s), ends with je to 0x004af61e (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004af26c
    je.d32 L_004af61e                            # 004af270
    # block 0x004af276: entered by fall-through of je at 0x004af270, 1 instruction(s), ends with forward jump to 0x004af966
    jmp.d32 L_004af966                           # 004af276
L_004af27b:
    # block 0x004af27b: entered by je at 0x004af260, 20 instruction(s), calls FUN_004e8d96, FUN_004c2790, ends with forward jump to 0x004af2e2
    mov edx, dword ptr [ebp - local_c]           # 004af27b
    mov ax, word ptr [ebp + arg_8]               # 004af27e
    mov word ptr [edx + field_1e], ax            # 004af282
    mov ecx, dword ptr [ebp - local_c]           # 004af286
    mov dword ptr [ecx + field_c1b], 0x1         # 004af289
    mov dword ptr [0x5bb1ca], 0x1                # 004af293
    mov ecx, 0x571442                            # 004af29d
    call FUN_004e8d96                            # 004af2a2
    push 0x55153c                                # 004af2a7
    push 0x6                                     # 004af2ac
    mov edx, dword ptr [ebp - local_c]           # 004af2ae
    mov eax, dword ptr [edx + field_c17]         # 004af2b1
    push eax                                     # 004af2b7
    push 0x551554                                # 004af2b8
    mov ecx, 0x5cf659                            # 004af2bd
    call FUN_004c2790                            # 004af2c2
    mov ecx, dword ptr [ebp - local_c]           # 004af2c7
    mov dword ptr [ecx + field_c35], eax         # 004af2ca
    mov dword ptr [ebp - local_4], 0x0           # 004af2d0
    jmp.d8 L_004af2e2                            # 004af2d7
L_004af2d9:
    # block 0x004af2d9: entered by jmp at 0x004af300, 3 instruction(s), falls into the block at 0x004af2e2
    mov edx, dword ptr [ebp - local_4]           # 004af2d9
    add edx, 0x1                                 # 004af2dc
    mov dword ptr [ebp - local_4], edx           # 004af2df
L_004af2e2:
    # block 0x004af2e2: entered by jmp at 0x004af2d7, 5 instruction(s), ends with jge to 0x004af302 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004af2e2
    mov ecx, dword ptr [eax + field_c17]         # 004af2e5
    movsx edx, word ptr [ecx + field_42]         # 004af2eb
    cmp dword ptr [ebp - local_4], edx           # 004af2ef
    jge.d8 L_004af302                            # 004af2f2
    # block 0x004af2f4: entered by fall-through of jge at 0x004af2f2, 5 instruction(s), calls FUN_004adb6c, ends with backward jump to 0x004af2d9
    mov eax, dword ptr [ebp - local_4]           # 004af2f4
    push eax                                     # 004af2f7
    mov ecx, dword ptr [ebp - local_c]           # 004af2f8
    call FUN_004adb6c                            # 004af2fb
    jmp.d8 L_004af2d9                            # 004af300
L_004af302:
    # block 0x004af302: entered by jge at 0x004af2f2, 71 instruction(s), calls FUN_004ae178, FUN_004c2dfb, FUN_004d39f9, ends with je to 0x004af443 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004af302
    call FUN_004ae178                            # 004af305
    mov ecx, dword ptr [ebp - local_c]           # 004af30a
    add ecx, 0xc35                               # 004af30d
    push ecx                                     # 004af313
    mov ecx, 0x5cf659                            # 004af314
    call FUN_004c2dfb                            # 004af319
    mov edx, dword ptr [ebp - local_c]           # 004af31e
    mov dword ptr [edx + field_c35], 0x0         # 004af321
    call FUN_004d39f9                            # 004af32b
    mov ecx, dword ptr [ebp - local_c]           # 004af330
    mov word ptr [ecx + field_1c], ax            # 004af333
    mov edx, dword ptr [ebp - local_c]           # 004af337
    movsx eax, word ptr [edx + field_1c]         # 004af33a
    imul eax, eax, 0x4a                          # 004af33e
    mov dword ptr [eax + 0x5d1591], 0xa          # 004af341
    mov ecx, dword ptr [ebp - local_c]           # 004af34b
    movsx edx, word ptr [ecx + field_1c]         # 004af34e
    imul edx, edx, 0x4a                          # 004af352
    mov dword ptr [edx + 0x5d1595], 0x4afa1e     # 004af355
    mov eax, dword ptr [ebp - local_c]           # 004af35f
    movsx ecx, word ptr [eax + field_1c]         # 004af362
    imul ecx, ecx, 0x4a                          # 004af366
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004af369
    mov edx, dword ptr [ebp - local_c]           # 004af373
    movsx eax, word ptr [edx + field_1c]         # 004af376
    imul eax, eax, 0x4a                          # 004af37a
    mov dword ptr [eax + 0x5d159d], 0x0          # 004af37d
    mov ecx, dword ptr [ebp - local_c]           # 004af387
    movsx edx, word ptr [ecx + field_1c]         # 004af38a
    imul edx, edx, 0x4a                          # 004af38e
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004af391
    mov eax, dword ptr [ebp - local_c]           # 004af39b
    movsx ecx, word ptr [eax + field_1c]         # 004af39e
    imul ecx, ecx, 0x4a                          # 004af3a2
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004af3a5
    mov edx, dword ptr [ebp - local_c]           # 004af3af
    movsx eax, word ptr [edx + field_1c]         # 004af3b2
    imul eax, eax, 0x4a                          # 004af3b6
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004af3b9
    mov ecx, dword ptr [ebp - local_c]           # 004af3c3
    movsx edx, word ptr [ecx + field_1c]         # 004af3c6
    imul edx, edx, 0x4a                          # 004af3ca
    mov word ptr [edx + 0x5d15ad], 0x0           # 004af3cd
    mov edi, 0x55155c                            # 004af3d6
    mov eax, dword ptr [ebp - local_c]           # 004af3db
    movsx ecx, word ptr [eax + field_1c]         # 004af3de
    imul ecx, ecx, 0x4a                          # 004af3e2
    add ecx, 0x5d15b3                            # 004af3e5
    {load} mov edx, ecx                          # 004af3eb
    or ecx, -0x1                                 # 004af3ed
    {load} xor eax, eax                          # 004af3f0
    repne scasb al, byte ptr es:[edi]            # 004af3f2
    not ecx                                      # 004af3f4
    {load} sub edi, ecx                          # 004af3f6
    {load} mov esi, edi                          # 004af3f8
    {load} mov eax, ecx                          # 004af3fa
    {load} mov edi, edx                          # 004af3fc
    shr ecx, 0x2                                 # 004af3fe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004af401
    {load} mov ecx, eax                          # 004af403
    and ecx, 0x3                                 # 004af405
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004af408
    mov edi, 0x551574                            # 004af40a
    mov ecx, dword ptr [ebp - local_c]           # 004af40f
    mov esi, dword ptr [ecx + field_c17]         # 004af412
    add esi, 0x234                               # 004af418
    mov ecx, 0x9                                 # 004af41e
    {load} xor edx, edx                          # 004af423
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af425
    je.d8 L_004af443                             # 004af427
    # block 0x004af429: entered by fall-through of je at 0x004af427, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004af443
    mov eax, dword ptr [ebp - local_c]           # 004af429
    mov ecx, dword ptr [eax + field_c17]         # 004af42c
    add ecx, 0x234                               # 004af432
    push ecx                                     # 004af438
    mov ecx, 0x5c3a67                            # 004af439
    call FUN_004fb77a                            # 004af43e
L_004af443:
    # block 0x004af443: entered by je at 0x004af427, 8 instruction(s), ends with je to 0x004af47c (forward)
    mov edi, 0x551580                            # 004af443
    mov edx, dword ptr [ebp - local_c]           # 004af448
    mov esi, dword ptr [edx + field_c17]         # 004af44b
    add esi, 0x265                               # 004af451
    mov ecx, 0x9                                 # 004af457
    {load} xor eax, eax                          # 004af45c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af45e
    je.d8 L_004af47c                             # 004af460
    # block 0x004af462: entered by fall-through of je at 0x004af460, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004af47c
    mov ecx, dword ptr [ebp - local_c]           # 004af462
    mov edx, dword ptr [ecx + field_c17]         # 004af465
    add edx, 0x265                               # 004af46b
    push edx                                     # 004af471
    mov ecx, 0x5c3a67                            # 004af472
    call FUN_004fb77a                            # 004af477
L_004af47c:
    # block 0x004af47c: entered by je at 0x004af460, 8 instruction(s), ends with je to 0x004af4b5 (forward)
    mov edi, 0x55158c                            # 004af47c
    mov eax, dword ptr [ebp - local_c]           # 004af481
    mov esi, dword ptr [eax + field_c17]         # 004af484
    add esi, 0x296                               # 004af48a
    mov ecx, 0x9                                 # 004af490
    {load} xor edx, edx                          # 004af495
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af497
    je.d8 L_004af4b5                             # 004af499
    # block 0x004af49b: entered by fall-through of je at 0x004af499, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004af4b5
    mov eax, dword ptr [ebp - local_c]           # 004af49b
    mov ecx, dword ptr [eax + field_c17]         # 004af49e
    add ecx, 0x296                               # 004af4a4
    push ecx                                     # 004af4aa
    mov ecx, 0x5c3a67                            # 004af4ab
    call FUN_004fb77a                            # 004af4b0
L_004af4b5:
    # block 0x004af4b5: entered by je at 0x004af499, 21 instruction(s), ends with forward jump to 0x004af966
    mov edx, dword ptr [ebp - local_c]           # 004af4b5
    mov dword ptr [edx + field_6a], 0x0          # 004af4b8
    mov eax, dword ptr [ebp - local_c]           # 004af4bf
    mov word ptr [eax + field_24], 0xffff        # 004af4c2
    mov ecx, dword ptr [ebp - local_c]           # 004af4c8
    mov dword ptr [ecx + field_20], 0x0          # 004af4cb
    mov edx, dword ptr [ebp - local_c]           # 004af4d2
    mov byte ptr [edx + field_c24], 0x0          # 004af4d5
    mov eax, dword ptr [ebp - local_c]           # 004af4dc
    mov byte ptr [eax + field_c1f], 0x0          # 004af4df
    mov ecx, dword ptr [ebp - local_c]           # 004af4e6
    mov dword ptr [ecx + field_c20], 0x0         # 004af4e9
    mov edx, dword ptr [ebp - local_c]           # 004af4f3
    movsx eax, word ptr [edx + field_1e]         # 004af4f6
    imul eax, eax, 0x8d                          # 004af4fa
    mov dword ptr [eax + 0x5bb626], 0x0          # 004af500
    mov ecx, dword ptr [ebp - local_c]           # 004af50a
    movsx edx, word ptr [ecx + field_1e]         # 004af50d
    imul edx, edx, 0x8d                          # 004af511
    mov dword ptr [edx + 0x5bb632], 0x1          # 004af517
    jmp.d32 L_004af966                           # 004af521
L_004af526:
    # block 0x004af526: entered by je at 0x004af266, 5 instruction(s), ends with je to 0x004af5c3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004af526
    mov ecx, dword ptr [eax + field_c20]         # 004af529
    mov dword ptr [ebp - local_14], ecx          # 004af52f
    cmp dword ptr [ebp - local_14], 0x1          # 004af532
    je.d32 L_004af5c3                            # 004af536
    # block 0x004af53c: entered by fall-through of je at 0x004af536, 2 instruction(s), ends with je to 0x004af547 (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 004af53c
    je.d8 L_004af547                             # 004af540
    # block 0x004af542: entered by fall-through of je at 0x004af540, 1 instruction(s), ends with forward jump to 0x004af619
    jmp.d32 L_004af619                           # 004af542
L_004af547:
    # block 0x004af547: entered by je at 0x004af540, 8 instruction(s), ends with je to 0x004af5aa (forward)
    mov edi, 0x551598                            # 004af547
    mov edx, dword ptr [ebp - local_c]           # 004af54c
    mov esi, dword ptr [edx + field_c17]         # 004af54f
    add esi, 0x2e0                               # 004af555
    mov ecx, 0x9                                 # 004af55b
    {load} xor eax, eax                          # 004af560
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af562
    je.d8 L_004af5aa                             # 004af564
    # block 0x004af566: entered by fall-through of je at 0x004af564, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004af5c1
    mov ecx, dword ptr [ebp - local_c]           # 004af566
    mov edx, dword ptr [ecx + field_c17]         # 004af569
    add edx, 0x2e0                               # 004af56f
    push edx                                     # 004af575
    mov ecx, 0x5c3a67                            # 004af576
    call FUN_004fb77a                            # 004af57b
    mov eax, dword ptr [ebp - local_c]           # 004af580
    mov ecx, dword ptr [eax + field_c17]         # 004af583
    mov dx, word ptr [ecx + field_301]           # 004af589
    push edx                                     # 004af590
    mov ecx, 0x5c3a67                            # 004af591
    call FUN_004fb2e3                            # 004af596
    mov eax, dword ptr [ebp - local_c]           # 004af59b
    mov dword ptr [eax + field_c20], 0x1         # 004af59e
    jmp.d8 L_004af5c1                            # 004af5a8
L_004af5aa:
    # block 0x004af5aa: entered by je at 0x004af564, 4 instruction(s), falls into the block at 0x004af5c1
    mov ecx, dword ptr [ebp - local_c]           # 004af5aa
    movsx edx, word ptr [ecx + field_1e]         # 004af5ad
    imul edx, edx, 0x8d                          # 004af5b1
    mov dword ptr [edx + 0x5bb632], 0x2          # 004af5b7
L_004af5c1:
    # block 0x004af5c1: entered by jmp at 0x004af5a8, 1 instruction(s), ends with forward jump to 0x004af619
    jmp.d8 L_004af619                            # 004af5c1
L_004af5c3:
    # block 0x004af5c3: entered by je at 0x004af536, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x004af619 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004af5c3
    mov ecx, dword ptr [eax + field_c17]         # 004af5c6
    movsx edx, word ptr [ecx + field_301]        # 004af5cc
    mov dword ptr [ebp - local_8], edx           # 004af5d3
    mov eax, dword ptr [ebp - local_8]           # 004af5d6
    push eax                                     # 004af5d9
    mov ecx, 0x5cf1eb                            # 004af5da
    call FUN_004f6334                            # 004af5df
    test eax, eax                                # 004af5e4
    jne.d8 L_004af619                            # 004af5e6
    # block 0x004af5e8: entered by fall-through of jne at 0x004af5e6, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x004af619
    mov ecx, dword ptr [ebp - local_c]           # 004af5e8
    mov edx, dword ptr [ecx + field_c17]         # 004af5eb
    add edx, 0x2e0                               # 004af5f1
    push edx                                     # 004af5f7
    mov ecx, 0x5c3a67                            # 004af5f8
    call FUN_004fba69                            # 004af5fd
    mov eax, dword ptr [ebp - local_c]           # 004af602
    movsx ecx, word ptr [eax + field_1e]         # 004af605
    imul ecx, ecx, 0x8d                          # 004af609
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004af60f
L_004af619:
    # block 0x004af619: entered by jmp at 0x004af542; jmp at 0x004af5c1; jne at 0x004af5e6, 1 instruction(s), ends with forward jump to 0x004af966
    jmp.d32 L_004af966                           # 004af619
L_004af61e:
    # block 0x004af61e: entered by je at 0x004af270, 9 instruction(s), ends with je to 0x004af661 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004af61e
    mov edi, 0x5515a4                            # 004af628
    mov edx, dword ptr [ebp - local_c]           # 004af62d
    mov esi, dword ptr [edx + field_c17]         # 004af630
    add esi, 0x234                               # 004af636
    mov ecx, 0x9                                 # 004af63c
    {load} xor eax, eax                          # 004af641
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af643
    je.d8 L_004af661                             # 004af645
    # block 0x004af647: entered by fall-through of je at 0x004af645, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004af661
    mov ecx, dword ptr [ebp - local_c]           # 004af647
    mov edx, dword ptr [ecx + field_c17]         # 004af64a
    add edx, 0x234                               # 004af650
    push edx                                     # 004af656
    mov ecx, 0x5c3a67                            # 004af657
    call FUN_004fba69                            # 004af65c
L_004af661:
    # block 0x004af661: entered by je at 0x004af645, 8 instruction(s), ends with je to 0x004af69a (forward)
    mov edi, 0x5515b0                            # 004af661
    mov eax, dword ptr [ebp - local_c]           # 004af666
    mov esi, dword ptr [eax + field_c17]         # 004af669
    add esi, 0x265                               # 004af66f
    mov ecx, 0x9                                 # 004af675
    {load} xor edx, edx                          # 004af67a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af67c
    je.d8 L_004af69a                             # 004af67e
    # block 0x004af680: entered by fall-through of je at 0x004af67e, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004af69a
    mov eax, dword ptr [ebp - local_c]           # 004af680
    mov ecx, dword ptr [eax + field_c17]         # 004af683
    add ecx, 0x265                               # 004af689
    push ecx                                     # 004af68f
    mov ecx, 0x5c3a67                            # 004af690
    call FUN_004fba69                            # 004af695
L_004af69a:
    # block 0x004af69a: entered by je at 0x004af67e, 8 instruction(s), ends with je to 0x004af6d3 (forward)
    mov edi, 0x5515bc                            # 004af69a
    mov edx, dword ptr [ebp - local_c]           # 004af69f
    mov esi, dword ptr [edx + field_c17]         # 004af6a2
    add esi, 0x296                               # 004af6a8
    mov ecx, 0x9                                 # 004af6ae
    {load} xor eax, eax                          # 004af6b3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004af6b5
    je.d8 L_004af6d3                             # 004af6b7
    # block 0x004af6b9: entered by fall-through of je at 0x004af6b7, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004af6d3
    mov ecx, dword ptr [ebp - local_c]           # 004af6b9
    mov edx, dword ptr [ecx + field_c17]         # 004af6bc
    add edx, 0x296                               # 004af6c2
    push edx                                     # 004af6c8
    mov ecx, 0x5c3a67                            # 004af6c9
    call FUN_004fba69                            # 004af6ce
L_004af6d3:
    # block 0x004af6d3: entered by je at 0x004af6b7, 5 instruction(s), ends with je to 0x004af813 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004af6d3
    {load} xor ecx, ecx                          # 004af6d6
    mov cl, byte ptr [eax + field_c1f]           # 004af6d8
    test ecx, ecx                                # 004af6de
    je.d32 L_004af813                            # 004af6e0
    # block 0x004af6e6: entered by fall-through of je at 0x004af6e0, 5 instruction(s), ends with je to 0x004af7d1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af6e6
    mov eax, dword ptr [edx + field_c17]         # 004af6e9
    movsx ecx, word ptr [eax + field_311]        # 004af6ef
    cmp ecx, 0x270f                              # 004af6f6
    je.d32 L_004af7d1                            # 004af6fc
    # block 0x004af702: entered by fall-through of je at 0x004af6fc, 33 instruction(s), ends with jne to 0x004af7bd (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af702
    mov eax, dword ptr [edx + field_c17]         # 004af705
    movsx ecx, word ptr [eax + field_311]        # 004af70b
    mov dword ptr [0x5bb57b], ecx                # 004af712
    mov edx, dword ptr [ebp - local_c]           # 004af718
    mov eax, dword ptr [edx + field_c17]         # 004af71b
    mov cx, word ptr [eax + field_313]           # 004af721
    mov word ptr [0x5bb599], cx                  # 004af728
    mov edx, dword ptr [ebp - local_c]           # 004af72f
    mov eax, dword ptr [edx + field_c17]         # 004af732
    mov cx, word ptr [eax + field_315]           # 004af738
    mov word ptr [0x5bb595], cx                  # 004af73f
    mov edx, dword ptr [ebp - local_c]           # 004af746
    mov eax, dword ptr [edx + field_c17]         # 004af749
    mov cx, word ptr [eax + field_317]           # 004af74f
    mov word ptr [0x5c39ff], cx                  # 004af756
    mov edx, dword ptr [ebp - local_c]           # 004af75d
    mov eax, dword ptr [edx + field_c17]         # 004af760
    mov ecx, dword ptr [eax + field_319]         # 004af766
    mov dword ptr [0x5bb59b], ecx                # 004af76c
    mov edx, dword ptr [ebp - local_c]           # 004af772
    mov eax, dword ptr [edx + field_c17]         # 004af775
    mov ecx, dword ptr [eax + field_31d]         # 004af77b
    mov dword ptr [0x5bb59f], ecx                # 004af781
    mov edx, dword ptr [ebp - local_c]           # 004af787
    mov eax, dword ptr [edx + field_c17]         # 004af78a
    mov ecx, dword ptr [eax + field_321]         # 004af790
    mov dword ptr [0x5bb5a3], ecx                # 004af796
    mov edx, dword ptr [ebp - local_c]           # 004af79c
    mov eax, dword ptr [edx + field_c17]         # 004af79f
    movsx ecx, word ptr [eax + field_325]        # 004af7a5
    cmp ecx, 0x1                                 # 004af7ac
    jne.d8 L_004af7bd                            # 004af7af
    # block 0x004af7b1: entered by fall-through of jne at 0x004af7af, 2 instruction(s), ends with forward jump to 0x004af7c7
    mov dword ptr [0x5bb1ca], 0x0                # 004af7b1
    jmp.d8 L_004af7c7                            # 004af7bb
L_004af7bd:
    # block 0x004af7bd: entered by jne at 0x004af7af, 1 instruction(s), falls into the block at 0x004af7c7
    mov dword ptr [0x5bb1ca], 0x1                # 004af7bd
L_004af7c7:
    # block 0x004af7c7: entered by jmp at 0x004af7bb, 1 instruction(s), falls into the block at 0x004af7d1
    mov dword ptr [0x583999], 0x4                # 004af7c7
L_004af7d1:
    # block 0x004af7d1: entered by je at 0x004af6fc, 5 instruction(s), ends with je to 0x004af80e (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af7d1
    mov eax, dword ptr [edx + field_c17]         # 004af7d4
    movsx ecx, word ptr [eax + field_327]        # 004af7da
    cmp ecx, -0x1                                # 004af7e1
    je.d8 L_004af80e                             # 004af7e4
    # block 0x004af7e6: entered by fall-through of je at 0x004af7e4, 8 instruction(s), falls into the block at 0x004af80e
    mov edx, dword ptr [ebp - local_c]           # 004af7e6
    mov eax, dword ptr [edx + field_c17]         # 004af7e9
    {load} xor ecx, ecx                          # 004af7ef
    mov cl, byte ptr [eax + field_329]           # 004af7f1
    mov edx, dword ptr [ebp - local_c]           # 004af7f7
    mov eax, dword ptr [edx + field_c17]         # 004af7fa
    movsx edx, word ptr [eax + field_327]        # 004af800
    mov dword ptr [4*edx + 0x585801], ecx        # 004af807
L_004af80e:
    # block 0x004af80e: entered by je at 0x004af7e4, 1 instruction(s), ends with forward jump to 0x004af94e
    jmp.d32 L_004af94e                           # 004af80e
L_004af813:
    # block 0x004af813: entered by je at 0x004af6e0, 5 instruction(s), ends with je to 0x004af94e (forward)
    mov eax, dword ptr [ebp - local_c]           # 004af813
    {load} xor ecx, ecx                          # 004af816
    mov cl, byte ptr [eax + field_c24]           # 004af818
    test ecx, ecx                                # 004af81e
    je.d32 L_004af94e                            # 004af820
    # block 0x004af826: entered by fall-through of je at 0x004af820, 5 instruction(s), ends with je to 0x004af911 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af826
    mov eax, dword ptr [edx + field_c17]         # 004af829
    movsx ecx, word ptr [eax + field_2c7]        # 004af82f
    cmp ecx, 0x270f                              # 004af836
    je.d32 L_004af911                            # 004af83c
    # block 0x004af842: entered by fall-through of je at 0x004af83c, 33 instruction(s), ends with jne to 0x004af8fd (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af842
    mov eax, dword ptr [edx + field_c17]         # 004af845
    movsx ecx, word ptr [eax + field_2c7]        # 004af84b
    mov dword ptr [0x5bb57b], ecx                # 004af852
    mov edx, dword ptr [ebp - local_c]           # 004af858
    mov eax, dword ptr [edx + field_c17]         # 004af85b
    mov cx, word ptr [eax + field_2c9]           # 004af861
    mov word ptr [0x5bb599], cx                  # 004af868
    mov edx, dword ptr [ebp - local_c]           # 004af86f
    mov eax, dword ptr [edx + field_c17]         # 004af872
    mov cx, word ptr [eax + field_2cb]           # 004af878
    mov word ptr [0x5bb595], cx                  # 004af87f
    mov edx, dword ptr [ebp - local_c]           # 004af886
    mov eax, dword ptr [edx + field_c17]         # 004af889
    mov cx, word ptr [eax + field_2cd]           # 004af88f
    mov word ptr [0x5c39ff], cx                  # 004af896
    mov edx, dword ptr [ebp - local_c]           # 004af89d
    mov eax, dword ptr [edx + field_c17]         # 004af8a0
    mov ecx, dword ptr [eax + field_2cf]         # 004af8a6
    mov dword ptr [0x5bb59b], ecx                # 004af8ac
    mov edx, dword ptr [ebp - local_c]           # 004af8b2
    mov eax, dword ptr [edx + field_c17]         # 004af8b5
    mov ecx, dword ptr [eax + field_2d3]         # 004af8bb
    mov dword ptr [0x5bb59f], ecx                # 004af8c1
    mov edx, dword ptr [ebp - local_c]           # 004af8c7
    mov eax, dword ptr [edx + field_c17]         # 004af8ca
    mov ecx, dword ptr [eax + field_2d7]         # 004af8d0
    mov dword ptr [0x5bb5a3], ecx                # 004af8d6
    mov edx, dword ptr [ebp - local_c]           # 004af8dc
    mov eax, dword ptr [edx + field_c17]         # 004af8df
    movsx ecx, word ptr [eax + field_2db]        # 004af8e5
    cmp ecx, 0x1                                 # 004af8ec
    jne.d8 L_004af8fd                            # 004af8ef
    # block 0x004af8f1: entered by fall-through of jne at 0x004af8ef, 2 instruction(s), ends with forward jump to 0x004af907
    mov dword ptr [0x5bb1ca], 0x0                # 004af8f1
    jmp.d8 L_004af907                            # 004af8fb
L_004af8fd:
    # block 0x004af8fd: entered by jne at 0x004af8ef, 1 instruction(s), falls into the block at 0x004af907
    mov dword ptr [0x5bb1ca], 0x1                # 004af8fd
L_004af907:
    # block 0x004af907: entered by jmp at 0x004af8fb, 1 instruction(s), falls into the block at 0x004af911
    mov dword ptr [0x583999], 0x4                # 004af907
L_004af911:
    # block 0x004af911: entered by je at 0x004af83c, 5 instruction(s), ends with je to 0x004af94e (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af911
    mov eax, dword ptr [edx + field_c17]         # 004af914
    movsx ecx, word ptr [eax + field_2dd]        # 004af91a
    cmp ecx, -0x1                                # 004af921
    je.d8 L_004af94e                             # 004af924
    # block 0x004af926: entered by fall-through of je at 0x004af924, 8 instruction(s), falls into the block at 0x004af94e
    mov edx, dword ptr [ebp - local_c]           # 004af926
    mov eax, dword ptr [edx + field_c17]         # 004af929
    {load} xor ecx, ecx                          # 004af92f
    mov cl, byte ptr [eax + field_2df]           # 004af931
    mov edx, dword ptr [ebp - local_c]           # 004af937
    mov eax, dword ptr [edx + field_c17]         # 004af93a
    movsx edx, word ptr [eax + field_2dd]        # 004af940
    mov dword ptr [4*edx + 0x585801], ecx        # 004af947
L_004af94e:
    # block 0x004af94e: entered by jmp at 0x004af80e; je at 0x004af820; je at 0x004af924, 7 instruction(s), calls FUN_0042ba3a, FUN_004ac97d, falls into the block at 0x004af966
    mov eax, dword ptr [ebp - local_c]           # 004af94e
    mov cx, word ptr [eax + field_1e]            # 004af951
    push ecx                                     # 004af955
    call FUN_0042ba3a                            # 004af956
    add esp, 0x4                                 # 004af95b
    mov ecx, dword ptr [ebp - local_c]           # 004af95e
    call FUN_004ac97d                            # 004af961
L_004af966:
    # block 0x004af966: entered by jmp at 0x004af276; jmp at 0x004af521; jmp at 0x004af619, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004af966
    pop esi                                      # 004af967
    {load} mov esp, ebp                          # 004af968
    pop ebp                                      # 004af96a
    ret 0x4                                      # 004af96b

