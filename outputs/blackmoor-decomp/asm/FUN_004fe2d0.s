# FUN_004fe2d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe2d0
# extent:       0x004fe2d0-0x004fe62e (862 code bytes)
# span:         0x004fe2d0-0x004fe630 (code 862, tables 0, padding 2)
# sha256:       57de982dcd417e8686592ed8b479ffc20beac24bfde848141b073fc0de89f7c7
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ local_10, 0x10  # [ebp - 0x10]
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]
.equ arg_10, 0x10  # [ebp + 0x10]
.equ arg_14, 0x14  # [ebp + 0x14]
.equ arg_18, 0x18  # [ebp + 0x18]
.equ arg_1c, 0x1c  # [ebp + 0x1c]
.equ arg_20, 0x20  # [ebp + 0x20]

# --- external targets -----------------------------------------------
.set FUN_004fdfd0, .text + (0x004fdfd0 - 0x401000)
.set FUN_004fe290, .text + (0x004fe290 - 0x401000)
.set FUN_004fe630, .text + (0x004fe630 - 0x401000)
.set FUN_004ff9a0, .text + (0x004ff9a0 - 0x401000)
.set FUN_004ffa00, .text + (0x004ffa00 - 0x401000)

.org 0x004fe2d0 - 0x401000
.globl FUN_004fe2d0
FUN_004fe2d0:
    # block 0x004fe2d0: <unfilled>
    push ebp                                     # 004fe2d0
    {load} mov ebp, esp                          # 004fe2d1
    sub esp, 0x18                                # 004fe2d3
    push ebx                                     # 004fe2d6
    push esi                                     # 004fe2d7
    push edi                                     # 004fe2d8
    call FUN_004fe630                            # 004fe2d9
    mov edi, dword ptr [ebp + arg_8]             # 004fe2de
    mov dword ptr [ebp - local_10], eax          # 004fe2e1
    cmp dword ptr [edi + 0x58], 0x2              # 004fe2e4
    jge.d8 L_004fe2f6                            # 004fe2e8
    # block 0x004fe2ea: <unfilled>
    pop edi                                      # 004fe2ea
    pop esi                                      # 004fe2eb
    mov eax, 0xffffff7d                          # 004fe2ec
    pop ebx                                      # 004fe2f1
    {load} mov esp, ebp                          # 004fe2f2
    pop ebp                                      # 004fe2f4
    ret                                          # 004fe2f5
L_004fe2f6:
    # block 0x004fe2f6: <unfilled>
    mov ebx, 0x3                                 # 004fe2f6
L_004fe2fb:
    # block 0x004fe2fb: <unfilled>
    cmp dword ptr [edi + 0x58], ebx              # 004fe2fb
    jl.d8 L_004fe31c                             # 004fe2fe
    # block 0x004fe300: <unfilled>
    lea eax, [ebp - local_4]                     # 004fe300
    lea ecx, [edi + 0x1da]                       # 004fe303
    push eax                                     # 004fe309
    push ecx                                     # 004fe30a
    call FUN_004ff9a0                            # 004fe30b
    {load} mov esi, eax                          # 004fe310
    add esp, 0x8                                 # 004fe312
    test esi, esi                                # 004fe315
    mov dword ptr [ebp - local_8], esi           # 004fe317
    jne.d8 L_004fe341                            # 004fe31a
L_004fe31c:
    # block 0x004fe31c: <unfilled>
    push 0x1                                     # 004fe31c
    push 0x0                                     # 004fe31e
    push edi                                     # 004fe320
    call FUN_004fdfd0                            # 004fe321
    add esp, 0xc                                 # 004fe326
    cmp eax, -0x2                                # 004fe329
    je.d8 L_004fe338                             # 004fe32c
    # block 0x004fe32e: <unfilled>
    test eax, eax                                # 004fe32e
    jle.d32 L_004fe627                           # 004fe330
    # block 0x004fe336: <unfilled>
    jmp.d8 L_004fe2fb                            # 004fe336
L_004fe338:
    # block 0x004fe338: <unfilled>
    pop edi                                      # 004fe338
    pop esi                                      # 004fe339
    {load} xor eax, eax                          # 004fe33a
    pop ebx                                      # 004fe33c
    {load} mov esp, ebp                          # 004fe33d
    pop ebp                                      # 004fe33f
    ret                                          # 004fe340
L_004fe341:
    # block 0x004fe341: <unfilled>
    jle.d32 L_004fe625                           # 004fe341
    # block 0x004fe347: <unfilled>
    push -0x1                                    # 004fe347
    push edi                                     # 004fe349
    call FUN_004fe290                            # 004fe34a
    mov ebx, dword ptr [eax + 0x4]               # 004fe34f
    mov edi, dword ptr [ebp + arg_18]            # 004fe352
    {load} mov ecx, ebx                          # 004fe355
    mov eax, dword ptr [ebp + arg_10]            # 004fe357
    imul ecx, edi                                # 004fe35a
    cdq                                          # 004fe35d
    idiv ecx                                     # 004fe35e
    add esp, 0x8                                 # 004fe360
    mov dword ptr [ebp - local_c], ebx           # 004fe363
    mov dword ptr [ebp - local_18], ecx          # 004fe366
    {load} cmp esi, eax                          # 004fe369
    jle.d8 L_004fe372                            # 004fe36b
    # block 0x004fe36d: <unfilled>
    mov dword ptr [ebp - local_8], eax           # 004fe36d
    {load} mov esi, eax                          # 004fe370
L_004fe372:
    # block 0x004fe372: <unfilled>
    test esi, esi                                # 004fe372
    jg.d8 L_004fe382                             # 004fe374
    # block 0x004fe376: <unfilled>
    pop edi                                      # 004fe376
    pop esi                                      # 004fe377
    mov eax, 0xffffff7d                          # 004fe378
    pop ebx                                      # 004fe37d
    {load} mov esp, ebp                          # 004fe37e
    pop ebp                                      # 004fe380
    ret                                          # 004fe381
L_004fe382:
    # block 0x004fe382: <unfilled>
    cmp edi, 0x1                                 # 004fe382
    jne.d8 L_004fe3fb                            # 004fe385
    # block 0x004fe387: <unfilled>
    mov edx, dword ptr [ebp + arg_1c]            # 004fe387
    neg edx                                      # 004fe38a
    {load} sbb edx, edx                          # 004fe38c
    {load} xor edi, edi                          # 004fe38e
    and edx, -0x80                               # 004fe390
    add edx, 0x80                                # 004fe393
    test esi, esi                                # 004fe399
    jle.d32 L_004fe5e6                           # 004fe39b
    # block 0x004fe3a1: <unfilled>
    mov esi, dword ptr [ebp + arg_c]             # 004fe3a1
L_004fe3a4:
    # block 0x004fe3a4: <unfilled>
    {load} xor eax, eax                          # 004fe3a4
    test ebx, ebx                                # 004fe3a6
    jle.d8 L_004fe3ec                            # 004fe3a8
L_004fe3aa:
    # block 0x004fe3aa: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004fe3aa
    mov ecx, dword ptr [ecx + 4*eax]             # 004fe3ad
    fld dword ptr [ecx + 4*edi]                  # 004fe3b0
    fmul dword ptr [0x52e580]                    # 004fe3b3
    fstp qword ptr [ebp - local_14]              # 004fe3b9
    fld qword ptr [ebp - local_14]               # 004fe3bc
    fistp dword ptr [ebp + arg_c]                # 004fe3bf
    mov ecx, dword ptr [ebp + arg_c]             # 004fe3c2
    cmp ecx, 0x7f                                # 004fe3c5
    jle.d8 L_004fe3d1                            # 004fe3c8
    # block 0x004fe3ca: <unfilled>
    mov ecx, 0x7f                                # 004fe3ca
    jmp.d8 L_004fe3db                            # 004fe3cf
L_004fe3d1:
    # block 0x004fe3d1: <unfilled>
    cmp ecx, -0x80                               # 004fe3d1
    jge.d8 L_004fe3db                            # 004fe3d4
    # block 0x004fe3d6: <unfilled>
    mov ecx, 0xffffff80                          # 004fe3d6
L_004fe3db:
    # block 0x004fe3db: <unfilled>
    {load} mov bl, dl                            # 004fe3db
    {load} add bl, cl                            # 004fe3dd
    mov ecx, dword ptr [ebp - local_c]           # 004fe3df
    mov byte ptr [esi], bl                       # 004fe3e2
    inc esi                                      # 004fe3e4
    inc eax                                      # 004fe3e5
    {load} cmp eax, ecx                          # 004fe3e6
    jl.d8 L_004fe3aa                             # 004fe3e8
    # block 0x004fe3ea: <unfilled>
    {load} mov ebx, ecx                          # 004fe3ea
L_004fe3ec:
    # block 0x004fe3ec: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004fe3ec
    inc edi                                      # 004fe3ef
    {load} cmp edi, eax                          # 004fe3f0
    jl.d8 L_004fe3a4                             # 004fe3f2
    # block 0x004fe3f4: <unfilled>
    {load} mov esi, eax                          # 004fe3f4
    jmp.d32 L_004fe5e6                           # 004fe3f6
L_004fe3fb:
    # block 0x004fe3fb: <unfilled>
    mov eax, dword ptr [ebp + arg_1c]            # 004fe3fb
    mov ecx, dword ptr [ebp + arg_14]            # 004fe3fe
    mov edi, dword ptr [ebp - local_10]          # 004fe401
    {load} mov edx, eax                          # 004fe404
    neg edx                                      # 004fe406
    {load} sbb edx, edx                          # 004fe408
    and edx, 0xffff8000                          # 004fe40a
    add edx, 0x8000                              # 004fe410
    {load} cmp edi, ecx                          # 004fe416
    mov dword ptr [ebp + arg_1c], edx            # 004fe418
    jne.d32 L_004fe515                           # 004fe41b
    # block 0x004fe421: <unfilled>
    test eax, eax                                # 004fe421
    je.d8 L_004fe496                             # 004fe423
    # block 0x004fe425: <unfilled>
    {load} xor edi, edi                          # 004fe425
    test ebx, ebx                                # 004fe427
    jle.d32 L_004fe5e6                           # 004fe429
    # block 0x004fe42f: <unfilled>
    mov edx, dword ptr [ebp + arg_c]             # 004fe42f
    mov dword ptr [ebp + arg_c], edx             # 004fe432
L_004fe435:
    # block 0x004fe435: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004fe435
    test esi, esi                                # 004fe438
    mov ecx, dword ptr [eax + 4*edi]             # 004fe43a
    jle.d8 L_004fe483                            # 004fe43d
    # block 0x004fe43f: <unfilled>
    mov esi, dword ptr [ebp - local_8]           # 004fe43f
    {load} add ebx, ebx                          # 004fe442
L_004fe444:
    # block 0x004fe444: <unfilled>
    fld dword ptr [ecx]                          # 004fe444
    fmul dword ptr [0x52e57c]                    # 004fe446
    fstp qword ptr [ebp - local_14]              # 004fe44c
    fld qword ptr [ebp - local_14]               # 004fe44f
    fistp dword ptr [ebp + arg_1c]               # 004fe452
    mov eax, dword ptr [ebp + arg_1c]            # 004fe455
    cmp eax, 0x7fff                              # 004fe458
    jle.d8 L_004fe466                            # 004fe45d
    # block 0x004fe45f: <unfilled>
    mov eax, 0x7fff                              # 004fe45f
    jmp.d8 L_004fe472                            # 004fe464
L_004fe466:
    # block 0x004fe466: <unfilled>
    cmp eax, 0xffff8000                          # 004fe466
    jge.d8 L_004fe472                            # 004fe46b
    # block 0x004fe46d: <unfilled>
    mov eax, 0xffff8000                          # 004fe46d
L_004fe472:
    # block 0x004fe472: <unfilled>
    mov word ptr [edx], ax                       # 004fe472
    {load} add edx, ebx                          # 004fe475
    add ecx, 0x4                                 # 004fe477
    dec esi                                      # 004fe47a
    jne.d8 L_004fe444                            # 004fe47b
    # block 0x004fe47d: <unfilled>
    mov ebx, dword ptr [ebp - local_c]           # 004fe47d
    mov esi, dword ptr [ebp - local_8]           # 004fe480
L_004fe483:
    # block 0x004fe483: <unfilled>
    mov edx, dword ptr [ebp + arg_c]             # 004fe483
    inc edi                                      # 004fe486
    add edx, 0x2                                 # 004fe487
    {load} cmp edi, ebx                          # 004fe48a
    mov dword ptr [ebp + arg_c], edx             # 004fe48c
    jl.d8 L_004fe435                             # 004fe48f
    # block 0x004fe491: <unfilled>
    jmp.d32 L_004fe5e6                           # 004fe491
L_004fe496:
    # block 0x004fe496: <unfilled>
    {load} xor eax, eax                          # 004fe496
    test ebx, ebx                                # 004fe498
    mov dword ptr [ebp + arg_18], eax            # 004fe49a
    jle.d32 L_004fe5e6                           # 004fe49d
    # block 0x004fe4a3: <unfilled>
    mov ecx, dword ptr [ebp + arg_c]             # 004fe4a3
    mov dword ptr [ebp + arg_c], ecx             # 004fe4a6
L_004fe4a9:
    # block 0x004fe4a9: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004fe4a9
    test esi, esi                                # 004fe4ac
    mov edx, dword ptr [edx + 4*eax]             # 004fe4ae
    jle.d8 L_004fe4ff                            # 004fe4b1
    # block 0x004fe4b3: <unfilled>
    mov esi, dword ptr [ebp - local_8]           # 004fe4b3
    {load} add ebx, ebx                          # 004fe4b6
L_004fe4b8:
    # block 0x004fe4b8: <unfilled>
    fld dword ptr [edx]                          # 004fe4b8
    fmul dword ptr [0x52e57c]                    # 004fe4ba
    fstp qword ptr [ebp - local_14]              # 004fe4c0
    fld qword ptr [ebp - local_14]               # 004fe4c3
    fistp dword ptr [ebp + arg_10]               # 004fe4c6
    mov eax, dword ptr [ebp + arg_10]            # 004fe4c9
    cmp eax, 0x7fff                              # 004fe4cc
    jle.d8 L_004fe4da                            # 004fe4d1
    # block 0x004fe4d3: <unfilled>
    mov eax, 0x7fff                              # 004fe4d3
    jmp.d8 L_004fe4e6                            # 004fe4d8
L_004fe4da:
    # block 0x004fe4da: <unfilled>
    cmp eax, 0xffff8000                          # 004fe4da
    jge.d8 L_004fe4e6                            # 004fe4df
    # block 0x004fe4e1: <unfilled>
    mov eax, 0xffff8000                          # 004fe4e1
L_004fe4e6:
    # block 0x004fe4e6: <unfilled>
    mov edi, dword ptr [ebp + arg_1c]            # 004fe4e6
    add edx, 0x4                                 # 004fe4e9
    {load} add edi, eax                          # 004fe4ec
    mov word ptr [ecx], di                       # 004fe4ee
    {load} add ecx, ebx                          # 004fe4f1
    dec esi                                      # 004fe4f3
    jne.d8 L_004fe4b8                            # 004fe4f4
    # block 0x004fe4f6: <unfilled>
    mov eax, dword ptr [ebp + arg_18]            # 004fe4f6
    mov ebx, dword ptr [ebp - local_c]           # 004fe4f9
    mov esi, dword ptr [ebp - local_8]           # 004fe4fc
L_004fe4ff:
    # block 0x004fe4ff: <unfilled>
    mov ecx, dword ptr [ebp + arg_c]             # 004fe4ff
    inc eax                                      # 004fe502
    add ecx, 0x2                                 # 004fe503
    {load} cmp eax, ebx                          # 004fe506
    mov dword ptr [ebp + arg_18], eax            # 004fe508
    mov dword ptr [ebp + arg_c], ecx             # 004fe50b
    jl.d8 L_004fe4a9                             # 004fe50e
    # block 0x004fe510: <unfilled>
    jmp.d32 L_004fe5e6                           # 004fe510
L_004fe515:
    # block 0x004fe515: <unfilled>
    {load} xor edi, edi                          # 004fe515
    {load} cmp ecx, edi                          # 004fe517
    je.d8 L_004fe582                             # 004fe519
    # block 0x004fe51b: <unfilled>
    {load} cmp esi, edi                          # 004fe51b
    jle.d32 L_004fe5e6                           # 004fe51d
    # block 0x004fe523: <unfilled>
    mov esi, dword ptr [ebp + arg_c]             # 004fe523
L_004fe526:
    # block 0x004fe526: <unfilled>
    {load} xor ecx, ecx                          # 004fe526
    test ebx, ebx                                # 004fe528
    jle.d8 L_004fe576                            # 004fe52a
L_004fe52c:
    # block 0x004fe52c: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004fe52c
    mov eax, dword ptr [eax + 4*ecx]             # 004fe52f
    fld dword ptr [eax + 4*edi]                  # 004fe532
    fmul dword ptr [0x52e57c]                    # 004fe535
    fstp qword ptr [ebp - local_14]              # 004fe53b
    fld qword ptr [ebp - local_14]               # 004fe53e
    fistp dword ptr [ebp + arg_c]                # 004fe541
    mov eax, dword ptr [ebp + arg_c]             # 004fe544
    cmp eax, 0x7fff                              # 004fe547
    jle.d8 L_004fe555                            # 004fe54c
    # block 0x004fe54e: <unfilled>
    mov eax, 0x7fff                              # 004fe54e
    jmp.d8 L_004fe561                            # 004fe553
L_004fe555:
    # block 0x004fe555: <unfilled>
    cmp eax, 0xffff8000                          # 004fe555
    jge.d8 L_004fe561                            # 004fe55a
    # block 0x004fe55c: <unfilled>
    mov eax, 0xffff8000                          # 004fe55c
L_004fe561:
    # block 0x004fe561: <unfilled>
    {load} add eax, edx                          # 004fe561
    {load} mov edx, eax                          # 004fe563
    sar edx, 0x8                                 # 004fe565
    mov byte ptr [esi], dl                       # 004fe568
    inc esi                                      # 004fe56a
    mov edx, dword ptr [ebp + arg_1c]            # 004fe56b
    mov byte ptr [esi], al                       # 004fe56e
    inc esi                                      # 004fe570
    inc ecx                                      # 004fe571
    {load} cmp ecx, ebx                          # 004fe572
    jl.d8 L_004fe52c                             # 004fe574
L_004fe576:
    # block 0x004fe576: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004fe576
    inc edi                                      # 004fe579
    {load} cmp edi, eax                          # 004fe57a
    jl.d8 L_004fe526                             # 004fe57c
    # block 0x004fe57e: <unfilled>
    {load} mov esi, eax                          # 004fe57e
    jmp.d8 L_004fe5e6                            # 004fe580
L_004fe582:
    # block 0x004fe582: <unfilled>
    {load} cmp esi, edi                          # 004fe582
    mov dword ptr [ebp + arg_18], edi            # 004fe584
    jle.d8 L_004fe5e6                            # 004fe587
    # block 0x004fe589: <unfilled>
    mov edx, dword ptr [ebp + arg_c]             # 004fe589
L_004fe58c:
    # block 0x004fe58c: <unfilled>
    {load} xor ecx, ecx                          # 004fe58c
    test ebx, ebx                                # 004fe58e
    jle.d8 L_004fe5db                            # 004fe590
L_004fe592:
    # block 0x004fe592: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004fe592
    mov edi, dword ptr [ebp + arg_18]            # 004fe595
    mov eax, dword ptr [eax + 4*ecx]             # 004fe598
    fld dword ptr [eax + 4*edi]                  # 004fe59b
    fmul dword ptr [0x52e57c]                    # 004fe59e
    fstp qword ptr [ebp - local_14]              # 004fe5a4
    fld qword ptr [ebp - local_14]               # 004fe5a7
    fistp dword ptr [ebp + arg_c]                # 004fe5aa
    mov eax, dword ptr [ebp + arg_c]             # 004fe5ad
    cmp eax, 0x7fff                              # 004fe5b0
    jle.d8 L_004fe5be                            # 004fe5b5
    # block 0x004fe5b7: <unfilled>
    mov eax, 0x7fff                              # 004fe5b7
    jmp.d8 L_004fe5ca                            # 004fe5bc
L_004fe5be:
    # block 0x004fe5be: <unfilled>
    cmp eax, 0xffff8000                          # 004fe5be
    jge.d8 L_004fe5ca                            # 004fe5c3
    # block 0x004fe5c5: <unfilled>
    mov eax, 0xffff8000                          # 004fe5c5
L_004fe5ca:
    # block 0x004fe5ca: <unfilled>
    add eax, dword ptr [ebp + arg_1c]            # 004fe5ca
    mov byte ptr [edx], al                       # 004fe5cd
    inc edx                                      # 004fe5cf
    sar eax, 0x8                                 # 004fe5d0
    mov byte ptr [edx], al                       # 004fe5d3
    inc edx                                      # 004fe5d5
    inc ecx                                      # 004fe5d6
    {load} cmp ecx, ebx                          # 004fe5d7
    jl.d8 L_004fe592                             # 004fe5d9
L_004fe5db:
    # block 0x004fe5db: <unfilled>
    mov eax, dword ptr [ebp + arg_18]            # 004fe5db
    inc eax                                      # 004fe5de
    {load} cmp eax, esi                          # 004fe5df
    mov dword ptr [ebp + arg_18], eax            # 004fe5e1
    jl.d8 L_004fe58c                             # 004fe5e4
L_004fe5e6:
    # block 0x004fe5e6: <unfilled>
    mov edi, dword ptr [ebp + arg_8]             # 004fe5e6
    push esi                                     # 004fe5e9
    lea ecx, [edi + 0x1da]                       # 004fe5ea
    push ecx                                     # 004fe5f0
    call FUN_004ffa00                            # 004fe5f1
    mov ecx, dword ptr [edi + 0x50]              # 004fe5f6
    {load} mov eax, esi                          # 004fe5f9
    cdq                                          # 004fe5fb
    add esp, 0x8                                 # 004fe5fc
    {load} add ecx, eax                          # 004fe5ff
    mov eax, dword ptr [ebp + arg_20]            # 004fe601
    mov dword ptr [edi + 0x50], ecx              # 004fe604
    mov ebx, dword ptr [edi + 0x54]              # 004fe607
    {load} adc ebx, edx                          # 004fe60a
    test eax, eax                                # 004fe60c
    mov dword ptr [edi + 0x54], ebx              # 004fe60e
    je.d8 L_004fe618                             # 004fe611
    # block 0x004fe613: <unfilled>
    mov edx, dword ptr [edi + 0x60]              # 004fe613
    mov dword ptr [eax], edx                     # 004fe616
L_004fe618:
    # block 0x004fe618: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 004fe618
    pop edi                                      # 004fe61b
    imul eax, esi                                # 004fe61c
    pop esi                                      # 004fe61f
    pop ebx                                      # 004fe620
    {load} mov esp, ebp                          # 004fe621
    pop ebp                                      # 004fe623
    ret                                          # 004fe624
L_004fe625:
    # block 0x004fe625: <unfilled>
    {load} mov eax, esi                          # 004fe625
L_004fe627:
    # block 0x004fe627: <unfilled>
    pop edi                                      # 004fe627
    pop esi                                      # 004fe628
    pop ebx                                      # 004fe629
    {load} mov esp, ebp                          # 004fe62a
    pop ebp                                      # 004fe62c
    ret                                          # 004fe62d

# --- data items (not part of the function) -------------------------
.org 0x004fe62e - 0x401000
PAD_004fe62e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90
