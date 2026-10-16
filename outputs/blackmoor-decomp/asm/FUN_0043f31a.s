# FUN_0043f31a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f31a
# extent:       0x0043f31a-0x0043ff18 (3070 code bytes)
# span:         0x0043f31a-0x0043ff18 (code 3070, tables 0, padding 0)
# sha256:       e26bc0a579f9612fbee51fda7c6894045caeda446e066557083f13e4ea71c4cc
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043f31a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 722 instruction(s), 41 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_3e, 0x3e  # offset -0x3e
.equ local_1ce, 0x1ce  # offset -0x1ce
.equ local_1d4, 0x1d4  # offset -0x1d4

# --- external targets -----------------------------------------------
.set FUN_0041fa11, .text + (0x0041fa11 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)

.org 0x0043f31a - 0x401000
.globl FUN_0043f31a
FUN_0043f31a:
    # block 0x0043f31a: entry, 7 instruction(s), ends with jne to 0x0043f3cb (forward)
    push ebp                                     # 0043f31a
    {load} mov ebp, esp                          # 0043f31b
    sub esp, 0x1d4                               # 0043f31d
    push esi                                     # 0043f323
    push edi                                     # 0043f324
    cmp dword ptr [0x587661], 0x1                # 0043f325
    jne.d32 L_0043f3cb                           # 0043f32c
    # block 0x0043f332: entered by fall-through of jne at 0x0043f32c, 2 instruction(s), ends with jne to 0x0043f3cb (forward)
    cmp dword ptr [0x587009], 0x0                # 0043f332
    jne.d32 L_0043f3cb                           # 0043f339
    # block 0x0043f33f: entered by fall-through of jne at 0x0043f339, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f3cb
    push 0x5478c8                                # 0043f33f
    push 0x63a5f0                                # 0043f344
    lea eax, [ebp - local_1ce]                   # 0043f349
    push eax                                     # 0043f34f
    call FUN_0043f210                            # 0043f350
    add esp, 0xc                                 # 0043f355
    mov edi, 0x5478d0                            # 0043f358
    lea edx, [ebp - local_3e]                    # 0043f35d
    or ecx, -0x1                                 # 0043f360
    {load} xor eax, eax                          # 0043f363
    repne scasb al, byte ptr es:[edi]            # 0043f365
    not ecx                                      # 0043f367
    {load} sub edi, ecx                          # 0043f369
    {load} mov esi, edi                          # 0043f36b
    {load} mov eax, ecx                          # 0043f36d
    {load} mov edi, edx                          # 0043f36f
    shr ecx, 0x2                                 # 0043f371
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f374
    {load} mov ecx, eax                          # 0043f376
    and ecx, 0x3                                 # 0043f378
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f37b
    mov word ptr [ebp - local_1c], 0x41a         # 0043f37d
    mov word ptr [ebp - local_1a], 0x0           # 0043f383
    mov word ptr [ebp - local_18], 0x0           # 0043f389
    mov word ptr [ebp - local_16], 0x1           # 0043f38f
    mov word ptr [ebp - local_8], 0xffff         # 0043f395
    mov byte ptr [ebp - local_6], 0x0            # 0043f39b
    mov word ptr [ebp - local_5], 0x2            # 0043f39f
    mov dword ptr [ebp - local_14], 0x0          # 0043f3a5
    mov dword ptr [ebp - local_10], 0x0          # 0043f3ac
    mov dword ptr [ebp - local_c], 0x1           # 0043f3b3
    lea ecx, [ebp - local_1d4]                   # 0043f3ba
    push ecx                                     # 0043f3c0
    mov ecx, 0x6177e8                            # 0043f3c1
    call FUN_0041fa11                            # 0043f3c6
L_0043f3cb:
    # block 0x0043f3cb: entered by jne at 0x0043f32c; jne at 0x0043f339, 2 instruction(s), ends with jne to 0x0043f47e (forward)
    cmp dword ptr [0x5876c1], 0x1                # 0043f3cb
    jne.d32 L_0043f47e                           # 0043f3d2
    # block 0x0043f3d8: entered by fall-through of jne at 0x0043f3d2, 2 instruction(s), ends with jne to 0x0043f47e (forward)
    cmp dword ptr [0x5874b9], 0x1                # 0043f3d8
    jne.d32 L_0043f47e                           # 0043f3df
    # block 0x0043f3e5: entered by fall-through of jne at 0x0043f3df, 2 instruction(s), ends with jne to 0x0043f47e (forward)
    cmp dword ptr [0x586ffd], 0x0                # 0043f3e5
    jne.d32 L_0043f47e                           # 0043f3ec
    # block 0x0043f3f2: entered by fall-through of jne at 0x0043f3ec, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f47e
    push 0x5478d8                                # 0043f3f2
    push 0x63a5f4                                # 0043f3f7
    lea edx, [ebp - local_1ce]                   # 0043f3fc
    push edx                                     # 0043f402
    call FUN_0043f210                            # 0043f403
    add esp, 0xc                                 # 0043f408
    mov edi, 0x5478e0                            # 0043f40b
    lea edx, [ebp - local_3e]                    # 0043f410
    or ecx, -0x1                                 # 0043f413
    {load} xor eax, eax                          # 0043f416
    repne scasb al, byte ptr es:[edi]            # 0043f418
    not ecx                                      # 0043f41a
    {load} sub edi, ecx                          # 0043f41c
    {load} mov esi, edi                          # 0043f41e
    {load} mov eax, ecx                          # 0043f420
    {load} mov edi, edx                          # 0043f422
    shr ecx, 0x2                                 # 0043f424
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f427
    {load} mov ecx, eax                          # 0043f429
    and ecx, 0x3                                 # 0043f42b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f42e
    mov word ptr [ebp - local_1c], 0x41f         # 0043f430
    mov word ptr [ebp - local_1a], 0x0           # 0043f436
    mov word ptr [ebp - local_18], 0x0           # 0043f43c
    mov word ptr [ebp - local_16], 0x1           # 0043f442
    mov word ptr [ebp - local_8], 0xffff         # 0043f448
    mov byte ptr [ebp - local_6], 0x0            # 0043f44e
    mov word ptr [ebp - local_5], 0x2            # 0043f452
    mov dword ptr [ebp - local_14], 0x0          # 0043f458
    mov dword ptr [ebp - local_10], 0x0          # 0043f45f
    mov dword ptr [ebp - local_c], 0x1           # 0043f466
    lea ecx, [ebp - local_1d4]                   # 0043f46d
    push ecx                                     # 0043f473
    mov ecx, 0x6177e8                            # 0043f474
    call FUN_0041fa11                            # 0043f479
L_0043f47e:
    # block 0x0043f47e: entered by jne at 0x0043f3d2; jne at 0x0043f3df; jne at 0x0043f3ec, 2 instruction(s), ends with jne to 0x0043f524 (forward)
    cmp dword ptr [0x5870a1], 0x1                # 0043f47e
    jne.d32 L_0043f524                           # 0043f485
    # block 0x0043f48b: entered by fall-through of jne at 0x0043f485, 2 instruction(s), ends with jne to 0x0043f524 (forward)
    cmp dword ptr [0x587021], 0x0                # 0043f48b
    jne.d32 L_0043f524                           # 0043f492
    # block 0x0043f498: entered by fall-through of jne at 0x0043f492, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f524
    push 0x5478e8                                # 0043f498
    push 0x63a5f8                                # 0043f49d
    lea edx, [ebp - local_1ce]                   # 0043f4a2
    push edx                                     # 0043f4a8
    call FUN_0043f210                            # 0043f4a9
    add esp, 0xc                                 # 0043f4ae
    mov edi, 0x5478f0                            # 0043f4b1
    lea edx, [ebp - local_3e]                    # 0043f4b6
    or ecx, -0x1                                 # 0043f4b9
    {load} xor eax, eax                          # 0043f4bc
    repne scasb al, byte ptr es:[edi]            # 0043f4be
    not ecx                                      # 0043f4c0
    {load} sub edi, ecx                          # 0043f4c2
    {load} mov esi, edi                          # 0043f4c4
    {load} mov eax, ecx                          # 0043f4c6
    {load} mov edi, edx                          # 0043f4c8
    shr ecx, 0x2                                 # 0043f4ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f4cd
    {load} mov ecx, eax                          # 0043f4cf
    and ecx, 0x3                                 # 0043f4d1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f4d4
    mov word ptr [ebp - local_1c], 0x422         # 0043f4d6
    mov word ptr [ebp - local_1a], 0x0           # 0043f4dc
    mov word ptr [ebp - local_18], 0x0           # 0043f4e2
    mov word ptr [ebp - local_16], 0x1           # 0043f4e8
    mov word ptr [ebp - local_8], 0xffff         # 0043f4ee
    mov byte ptr [ebp - local_6], 0x0            # 0043f4f4
    mov word ptr [ebp - local_5], 0x2            # 0043f4f8
    mov dword ptr [ebp - local_14], 0x0          # 0043f4fe
    mov dword ptr [ebp - local_10], 0x0          # 0043f505
    mov dword ptr [ebp - local_c], 0x1           # 0043f50c
    lea ecx, [ebp - local_1d4]                   # 0043f513
    push ecx                                     # 0043f519
    mov ecx, 0x6177e8                            # 0043f51a
    call FUN_0041fa11                            # 0043f51f
L_0043f524:
    # block 0x0043f524: entered by jne at 0x0043f485; jne at 0x0043f492, 2 instruction(s), ends with jne to 0x0043f5ca (forward)
    cmp dword ptr [0x586dcd], 0x1                # 0043f524
    jne.d32 L_0043f5ca                           # 0043f52b
    # block 0x0043f531: entered by fall-through of jne at 0x0043f52b, 2 instruction(s), ends with jne to 0x0043f5ca (forward)
    cmp dword ptr [0x586fe1], 0x0                # 0043f531
    jne.d32 L_0043f5ca                           # 0043f538
    # block 0x0043f53e: entered by fall-through of jne at 0x0043f538, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f5ca
    push 0x5478f8                                # 0043f53e
    push 0x63a5fc                                # 0043f543
    lea edx, [ebp - local_1ce]                   # 0043f548
    push edx                                     # 0043f54e
    call FUN_0043f210                            # 0043f54f
    add esp, 0xc                                 # 0043f554
    mov edi, 0x547900                            # 0043f557
    lea edx, [ebp - local_3e]                    # 0043f55c
    or ecx, -0x1                                 # 0043f55f
    {load} xor eax, eax                          # 0043f562
    repne scasb al, byte ptr es:[edi]            # 0043f564
    not ecx                                      # 0043f566
    {load} sub edi, ecx                          # 0043f568
    {load} mov esi, edi                          # 0043f56a
    {load} mov eax, ecx                          # 0043f56c
    {load} mov edi, edx                          # 0043f56e
    shr ecx, 0x2                                 # 0043f570
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f573
    {load} mov ecx, eax                          # 0043f575
    and ecx, 0x3                                 # 0043f577
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f57a
    mov word ptr [ebp - local_1c], 0x424         # 0043f57c
    mov word ptr [ebp - local_1a], 0x0           # 0043f582
    mov word ptr [ebp - local_18], 0x0           # 0043f588
    mov word ptr [ebp - local_16], 0x1           # 0043f58e
    mov word ptr [ebp - local_8], 0xffff         # 0043f594
    mov byte ptr [ebp - local_6], 0x0            # 0043f59a
    mov word ptr [ebp - local_5], 0x2            # 0043f59e
    mov dword ptr [ebp - local_14], 0x0          # 0043f5a4
    mov dword ptr [ebp - local_10], 0x0          # 0043f5ab
    mov dword ptr [ebp - local_c], 0x1           # 0043f5b2
    lea ecx, [ebp - local_1d4]                   # 0043f5b9
    push ecx                                     # 0043f5bf
    mov ecx, 0x6177e8                            # 0043f5c0
    call FUN_0041fa11                            # 0043f5c5
L_0043f5ca:
    # block 0x0043f5ca: entered by jne at 0x0043f52b; jne at 0x0043f538, 2 instruction(s), ends with jne to 0x0043f663 (forward)
    cmp dword ptr [0x586fbd], 0x0                # 0043f5ca
    jne.d32 L_0043f663                           # 0043f5d1
    # block 0x0043f5d7: entered by fall-through of jne at 0x0043f5d1, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f663
    push 0x547908                                # 0043f5d7
    push 0x63a600                                # 0043f5dc
    lea edx, [ebp - local_1ce]                   # 0043f5e1
    push edx                                     # 0043f5e7
    call FUN_0043f210                            # 0043f5e8
    add esp, 0xc                                 # 0043f5ed
    mov edi, 0x547910                            # 0043f5f0
    lea edx, [ebp - local_3e]                    # 0043f5f5
    or ecx, -0x1                                 # 0043f5f8
    {load} xor eax, eax                          # 0043f5fb
    repne scasb al, byte ptr es:[edi]            # 0043f5fd
    not ecx                                      # 0043f5ff
    {load} sub edi, ecx                          # 0043f601
    {load} mov esi, edi                          # 0043f603
    {load} mov eax, ecx                          # 0043f605
    {load} mov edi, edx                          # 0043f607
    shr ecx, 0x2                                 # 0043f609
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f60c
    {load} mov ecx, eax                          # 0043f60e
    and ecx, 0x3                                 # 0043f610
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f613
    mov word ptr [ebp - local_1c], 0x425         # 0043f615
    mov word ptr [ebp - local_1a], 0x0           # 0043f61b
    mov word ptr [ebp - local_18], 0x0           # 0043f621
    mov word ptr [ebp - local_16], 0x1           # 0043f627
    mov word ptr [ebp - local_8], 0xffff         # 0043f62d
    mov byte ptr [ebp - local_6], 0x0            # 0043f633
    mov word ptr [ebp - local_5], 0x2            # 0043f637
    mov dword ptr [ebp - local_14], 0x0          # 0043f63d
    mov dword ptr [ebp - local_10], 0x0          # 0043f644
    mov dword ptr [ebp - local_c], 0x1           # 0043f64b
    lea ecx, [ebp - local_1d4]                   # 0043f652
    push ecx                                     # 0043f658
    mov ecx, 0x6177e8                            # 0043f659
    call FUN_0041fa11                            # 0043f65e
L_0043f663:
    # block 0x0043f663: entered by jne at 0x0043f5d1, 2 instruction(s), ends with jne to 0x0043f6fc (forward)
    cmp dword ptr [0x586fe5], 0x0                # 0043f663
    jne.d32 L_0043f6fc                           # 0043f66a
    # block 0x0043f670: entered by fall-through of jne at 0x0043f66a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f6fc
    push 0x547918                                # 0043f670
    push 0x63a604                                # 0043f675
    lea edx, [ebp - local_1ce]                   # 0043f67a
    push edx                                     # 0043f680
    call FUN_0043f210                            # 0043f681
    add esp, 0xc                                 # 0043f686
    mov edi, 0x547920                            # 0043f689
    lea edx, [ebp - local_3e]                    # 0043f68e
    or ecx, -0x1                                 # 0043f691
    {load} xor eax, eax                          # 0043f694
    repne scasb al, byte ptr es:[edi]            # 0043f696
    not ecx                                      # 0043f698
    {load} sub edi, ecx                          # 0043f69a
    {load} mov esi, edi                          # 0043f69c
    {load} mov eax, ecx                          # 0043f69e
    {load} mov edi, edx                          # 0043f6a0
    shr ecx, 0x2                                 # 0043f6a2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f6a5
    {load} mov ecx, eax                          # 0043f6a7
    and ecx, 0x3                                 # 0043f6a9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f6ac
    mov word ptr [ebp - local_1c], 0x426         # 0043f6ae
    mov word ptr [ebp - local_1a], 0x0           # 0043f6b4
    mov word ptr [ebp - local_18], 0x0           # 0043f6ba
    mov word ptr [ebp - local_16], 0x1           # 0043f6c0
    mov word ptr [ebp - local_8], 0xffff         # 0043f6c6
    mov byte ptr [ebp - local_6], 0x0            # 0043f6cc
    mov word ptr [ebp - local_5], 0x2            # 0043f6d0
    mov dword ptr [ebp - local_14], 0x0          # 0043f6d6
    mov dword ptr [ebp - local_10], 0x0          # 0043f6dd
    mov dword ptr [ebp - local_c], 0x1           # 0043f6e4
    lea ecx, [ebp - local_1d4]                   # 0043f6eb
    push ecx                                     # 0043f6f1
    mov ecx, 0x6177e8                            # 0043f6f2
    call FUN_0041fa11                            # 0043f6f7
L_0043f6fc:
    # block 0x0043f6fc: entered by jne at 0x0043f66a, 2 instruction(s), ends with jne to 0x0043f7a2 (forward)
    cmp dword ptr [0x586fe1], 0x1                # 0043f6fc
    jne.d32 L_0043f7a2                           # 0043f703
    # block 0x0043f709: entered by fall-through of jne at 0x0043f703, 2 instruction(s), ends with jne to 0x0043f7a2 (forward)
    cmp dword ptr [0x586fad], 0x0                # 0043f709
    jne.d32 L_0043f7a2                           # 0043f710
    # block 0x0043f716: entered by fall-through of jne at 0x0043f710, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f7a2
    push 0x547928                                # 0043f716
    push 0x63a608                                # 0043f71b
    lea edx, [ebp - local_1ce]                   # 0043f720
    push edx                                     # 0043f726
    call FUN_0043f210                            # 0043f727
    add esp, 0xc                                 # 0043f72c
    mov edi, 0x547930                            # 0043f72f
    lea edx, [ebp - local_3e]                    # 0043f734
    or ecx, -0x1                                 # 0043f737
    {load} xor eax, eax                          # 0043f73a
    repne scasb al, byte ptr es:[edi]            # 0043f73c
    not ecx                                      # 0043f73e
    {load} sub edi, ecx                          # 0043f740
    {load} mov esi, edi                          # 0043f742
    {load} mov eax, ecx                          # 0043f744
    {load} mov edi, edx                          # 0043f746
    shr ecx, 0x2                                 # 0043f748
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f74b
    {load} mov ecx, eax                          # 0043f74d
    and ecx, 0x3                                 # 0043f74f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f752
    mov word ptr [ebp - local_1c], 0x427         # 0043f754
    mov word ptr [ebp - local_1a], 0x0           # 0043f75a
    mov word ptr [ebp - local_18], 0x0           # 0043f760
    mov word ptr [ebp - local_16], 0x1           # 0043f766
    mov word ptr [ebp - local_8], 0xffff         # 0043f76c
    mov byte ptr [ebp - local_6], 0x0            # 0043f772
    mov word ptr [ebp - local_5], 0x2            # 0043f776
    mov dword ptr [ebp - local_14], 0x0          # 0043f77c
    mov dword ptr [ebp - local_10], 0x0          # 0043f783
    mov dword ptr [ebp - local_c], 0x1           # 0043f78a
    lea ecx, [ebp - local_1d4]                   # 0043f791
    push ecx                                     # 0043f797
    mov ecx, 0x6177e8                            # 0043f798
    call FUN_0041fa11                            # 0043f79d
L_0043f7a2:
    # block 0x0043f7a2: entered by jne at 0x0043f703; jne at 0x0043f710, 2 instruction(s), ends with jne to 0x0043f848 (forward)
    cmp dword ptr [0x587689], 0x1                # 0043f7a2
    jne.d32 L_0043f848                           # 0043f7a9
    # block 0x0043f7af: entered by fall-through of jne at 0x0043f7a9, 2 instruction(s), ends with jne to 0x0043f848 (forward)
    cmp dword ptr [0x587025], 0x0                # 0043f7af
    jne.d32 L_0043f848                           # 0043f7b6
    # block 0x0043f7bc: entered by fall-through of jne at 0x0043f7b6, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f848
    push 0x547938                                # 0043f7bc
    push 0x63a60c                                # 0043f7c1
    lea edx, [ebp - local_1ce]                   # 0043f7c6
    push edx                                     # 0043f7cc
    call FUN_0043f210                            # 0043f7cd
    add esp, 0xc                                 # 0043f7d2
    mov edi, 0x547940                            # 0043f7d5
    lea edx, [ebp - local_3e]                    # 0043f7da
    or ecx, -0x1                                 # 0043f7dd
    {load} xor eax, eax                          # 0043f7e0
    repne scasb al, byte ptr es:[edi]            # 0043f7e2
    not ecx                                      # 0043f7e4
    {load} sub edi, ecx                          # 0043f7e6
    {load} mov esi, edi                          # 0043f7e8
    {load} mov eax, ecx                          # 0043f7ea
    {load} mov edi, edx                          # 0043f7ec
    shr ecx, 0x2                                 # 0043f7ee
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f7f1
    {load} mov ecx, eax                          # 0043f7f3
    and ecx, 0x3                                 # 0043f7f5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f7f8
    mov word ptr [ebp - local_1c], 0x429         # 0043f7fa
    mov word ptr [ebp - local_1a], 0x0           # 0043f800
    mov word ptr [ebp - local_18], 0x0           # 0043f806
    mov word ptr [ebp - local_16], 0x1           # 0043f80c
    mov word ptr [ebp - local_8], 0xffff         # 0043f812
    mov byte ptr [ebp - local_6], 0x0            # 0043f818
    mov word ptr [ebp - local_5], 0x2            # 0043f81c
    mov dword ptr [ebp - local_14], 0x0          # 0043f822
    mov dword ptr [ebp - local_10], 0x0          # 0043f829
    mov dword ptr [ebp - local_c], 0x1           # 0043f830
    lea ecx, [ebp - local_1d4]                   # 0043f837
    push ecx                                     # 0043f83d
    mov ecx, 0x6177e8                            # 0043f83e
    call FUN_0041fa11                            # 0043f843
L_0043f848:
    # block 0x0043f848: entered by jne at 0x0043f7a9; jne at 0x0043f7b6, 2 instruction(s), ends with jne to 0x0043f8ee (forward)
    cmp dword ptr [0x587085], 0x1                # 0043f848
    jne.d32 L_0043f8ee                           # 0043f84f
    # block 0x0043f855: entered by fall-through of jne at 0x0043f84f, 2 instruction(s), ends with jne to 0x0043f8ee (forward)
    cmp dword ptr [0x586fd5], 0x0                # 0043f855
    jne.d32 L_0043f8ee                           # 0043f85c
    # block 0x0043f862: entered by fall-through of jne at 0x0043f85c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f8ee
    push 0x547948                                # 0043f862
    push 0x63a610                                # 0043f867
    lea edx, [ebp - local_1ce]                   # 0043f86c
    push edx                                     # 0043f872
    call FUN_0043f210                            # 0043f873
    add esp, 0xc                                 # 0043f878
    mov edi, 0x547950                            # 0043f87b
    lea edx, [ebp - local_3e]                    # 0043f880
    or ecx, -0x1                                 # 0043f883
    {load} xor eax, eax                          # 0043f886
    repne scasb al, byte ptr es:[edi]            # 0043f888
    not ecx                                      # 0043f88a
    {load} sub edi, ecx                          # 0043f88c
    {load} mov esi, edi                          # 0043f88e
    {load} mov eax, ecx                          # 0043f890
    {load} mov edi, edx                          # 0043f892
    shr ecx, 0x2                                 # 0043f894
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f897
    {load} mov ecx, eax                          # 0043f899
    and ecx, 0x3                                 # 0043f89b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f89e
    mov word ptr [ebp - local_1c], 0x42b         # 0043f8a0
    mov word ptr [ebp - local_1a], 0x0           # 0043f8a6
    mov word ptr [ebp - local_18], 0x0           # 0043f8ac
    mov word ptr [ebp - local_16], 0x1           # 0043f8b2
    mov word ptr [ebp - local_8], 0xffff         # 0043f8b8
    mov byte ptr [ebp - local_6], 0x0            # 0043f8be
    mov word ptr [ebp - local_5], 0x2            # 0043f8c2
    mov dword ptr [ebp - local_14], 0x0          # 0043f8c8
    mov dword ptr [ebp - local_10], 0x0          # 0043f8cf
    mov dword ptr [ebp - local_c], 0x1           # 0043f8d6
    lea ecx, [ebp - local_1d4]                   # 0043f8dd
    push ecx                                     # 0043f8e3
    mov ecx, 0x6177e8                            # 0043f8e4
    call FUN_0041fa11                            # 0043f8e9
L_0043f8ee:
    # block 0x0043f8ee: entered by jne at 0x0043f84f; jne at 0x0043f85c, 2 instruction(s), ends with jne to 0x0043f9a1 (forward)
    cmp dword ptr [0x586eed], 0x1                # 0043f8ee
    jne.d32 L_0043f9a1                           # 0043f8f5
    # block 0x0043f8fb: entered by fall-through of jne at 0x0043f8f5, 2 instruction(s), ends with jne to 0x0043f9a1 (forward)
    cmp dword ptr [0x586fd5], 0x1                # 0043f8fb
    jne.d32 L_0043f9a1                           # 0043f902
    # block 0x0043f908: entered by fall-through of jne at 0x0043f902, 2 instruction(s), ends with jne to 0x0043f9a1 (forward)
    cmp dword ptr [0x586fd9], 0x0                # 0043f908
    jne.d32 L_0043f9a1                           # 0043f90f
    # block 0x0043f915: entered by fall-through of jne at 0x0043f90f, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043f9a1
    push 0x547958                                # 0043f915
    push 0x63a614                                # 0043f91a
    lea edx, [ebp - local_1ce]                   # 0043f91f
    push edx                                     # 0043f925
    call FUN_0043f210                            # 0043f926
    add esp, 0xc                                 # 0043f92b
    mov edi, 0x547960                            # 0043f92e
    lea edx, [ebp - local_3e]                    # 0043f933
    or ecx, -0x1                                 # 0043f936
    {load} xor eax, eax                          # 0043f939
    repne scasb al, byte ptr es:[edi]            # 0043f93b
    not ecx                                      # 0043f93d
    {load} sub edi, ecx                          # 0043f93f
    {load} mov esi, edi                          # 0043f941
    {load} mov eax, ecx                          # 0043f943
    {load} mov edi, edx                          # 0043f945
    shr ecx, 0x2                                 # 0043f947
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f94a
    {load} mov ecx, eax                          # 0043f94c
    and ecx, 0x3                                 # 0043f94e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f951
    mov word ptr [ebp - local_1c], 0x42c         # 0043f953
    mov word ptr [ebp - local_1a], 0x0           # 0043f959
    mov word ptr [ebp - local_18], 0x0           # 0043f95f
    mov word ptr [ebp - local_16], 0x1           # 0043f965
    mov word ptr [ebp - local_8], 0xffff         # 0043f96b
    mov byte ptr [ebp - local_6], 0x0            # 0043f971
    mov word ptr [ebp - local_5], 0x2            # 0043f975
    mov dword ptr [ebp - local_14], 0x0          # 0043f97b
    mov dword ptr [ebp - local_10], 0x0          # 0043f982
    mov dword ptr [ebp - local_c], 0x1           # 0043f989
    lea ecx, [ebp - local_1d4]                   # 0043f990
    push ecx                                     # 0043f996
    mov ecx, 0x6177e8                            # 0043f997
    call FUN_0041fa11                            # 0043f99c
L_0043f9a1:
    # block 0x0043f9a1: entered by jne at 0x0043f8f5; jne at 0x0043f902; jne at 0x0043f90f, 2 instruction(s), ends with jne to 0x0043fa47 (forward)
    cmp dword ptr [0x586bb9], 0x1                # 0043f9a1
    jne.d32 L_0043fa47                           # 0043f9a8
    # block 0x0043f9ae: entered by fall-through of jne at 0x0043f9a8, 2 instruction(s), ends with jne to 0x0043fa47 (forward)
    cmp dword ptr [0x586fcd], 0x0                # 0043f9ae
    jne.d32 L_0043fa47                           # 0043f9b5
    # block 0x0043f9bb: entered by fall-through of jne at 0x0043f9b5, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fa47
    push 0x547968                                # 0043f9bb
    push 0x63a618                                # 0043f9c0
    lea edx, [ebp - local_1ce]                   # 0043f9c5
    push edx                                     # 0043f9cb
    call FUN_0043f210                            # 0043f9cc
    add esp, 0xc                                 # 0043f9d1
    mov edi, 0x547970                            # 0043f9d4
    lea edx, [ebp - local_3e]                    # 0043f9d9
    or ecx, -0x1                                 # 0043f9dc
    {load} xor eax, eax                          # 0043f9df
    repne scasb al, byte ptr es:[edi]            # 0043f9e1
    not ecx                                      # 0043f9e3
    {load} sub edi, ecx                          # 0043f9e5
    {load} mov esi, edi                          # 0043f9e7
    {load} mov eax, ecx                          # 0043f9e9
    {load} mov edi, edx                          # 0043f9eb
    shr ecx, 0x2                                 # 0043f9ed
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f9f0
    {load} mov ecx, eax                          # 0043f9f2
    and ecx, 0x3                                 # 0043f9f4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f9f7
    mov word ptr [ebp - local_1c], 0x430         # 0043f9f9
    mov word ptr [ebp - local_1a], 0x0           # 0043f9ff
    mov word ptr [ebp - local_18], 0x0           # 0043fa05
    mov word ptr [ebp - local_16], 0x1           # 0043fa0b
    mov word ptr [ebp - local_8], 0xffff         # 0043fa11
    mov byte ptr [ebp - local_6], 0x0            # 0043fa17
    mov word ptr [ebp - local_5], 0x2            # 0043fa1b
    mov dword ptr [ebp - local_14], 0x0          # 0043fa21
    mov dword ptr [ebp - local_10], 0x0          # 0043fa28
    mov dword ptr [ebp - local_c], 0x1           # 0043fa2f
    lea ecx, [ebp - local_1d4]                   # 0043fa36
    push ecx                                     # 0043fa3c
    mov ecx, 0x6177e8                            # 0043fa3d
    call FUN_0041fa11                            # 0043fa42
L_0043fa47:
    # block 0x0043fa47: entered by jne at 0x0043f9a8; jne at 0x0043f9b5, 2 instruction(s), ends with jne to 0x0043fafa (forward)
    cmp dword ptr [0x587525], 0x1                # 0043fa47
    jne.d32 L_0043fafa                           # 0043fa4e
    # block 0x0043fa54: entered by fall-through of jne at 0x0043fa4e, 2 instruction(s), ends with jne to 0x0043fafa (forward)
    cmp dword ptr [0x586d15], 0x0                # 0043fa54
    jne.d32 L_0043fafa                           # 0043fa5b
    # block 0x0043fa61: entered by fall-through of jne at 0x0043fa5b, 2 instruction(s), ends with jne to 0x0043fafa (forward)
    cmp dword ptr [0x586fc9], 0x0                # 0043fa61
    jne.d32 L_0043fafa                           # 0043fa68
    # block 0x0043fa6e: entered by fall-through of jne at 0x0043fa68, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fafa
    push 0x547978                                # 0043fa6e
    push 0x63a61c                                # 0043fa73
    lea edx, [ebp - local_1ce]                   # 0043fa78
    push edx                                     # 0043fa7e
    call FUN_0043f210                            # 0043fa7f
    add esp, 0xc                                 # 0043fa84
    mov edi, 0x547980                            # 0043fa87
    lea edx, [ebp - local_3e]                    # 0043fa8c
    or ecx, -0x1                                 # 0043fa8f
    {load} xor eax, eax                          # 0043fa92
    repne scasb al, byte ptr es:[edi]            # 0043fa94
    not ecx                                      # 0043fa96
    {load} sub edi, ecx                          # 0043fa98
    {load} mov esi, edi                          # 0043fa9a
    {load} mov eax, ecx                          # 0043fa9c
    {load} mov edi, edx                          # 0043fa9e
    shr ecx, 0x2                                 # 0043faa0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043faa3
    {load} mov ecx, eax                          # 0043faa5
    and ecx, 0x3                                 # 0043faa7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043faaa
    mov word ptr [ebp - local_1c], 0x433         # 0043faac
    mov word ptr [ebp - local_1a], 0x0           # 0043fab2
    mov word ptr [ebp - local_18], 0x0           # 0043fab8
    mov word ptr [ebp - local_16], 0x1           # 0043fabe
    mov word ptr [ebp - local_8], 0xffff         # 0043fac4
    mov byte ptr [ebp - local_6], 0x0            # 0043faca
    mov word ptr [ebp - local_5], 0x2            # 0043face
    mov dword ptr [ebp - local_14], 0x0          # 0043fad4
    mov dword ptr [ebp - local_10], 0x0          # 0043fadb
    mov dword ptr [ebp - local_c], 0x1           # 0043fae2
    lea ecx, [ebp - local_1d4]                   # 0043fae9
    push ecx                                     # 0043faef
    mov ecx, 0x6177e8                            # 0043faf0
    call FUN_0041fa11                            # 0043faf5
L_0043fafa:
    # block 0x0043fafa: entered by jne at 0x0043fa4e; jne at 0x0043fa5b; jne at 0x0043fa68, 2 instruction(s), ends with jne to 0x0043fba0 (forward)
    cmp dword ptr [0x587655], 0x1                # 0043fafa
    jne.d32 L_0043fba0                           # 0043fb01
    # block 0x0043fb07: entered by fall-through of jne at 0x0043fb01, 2 instruction(s), ends with jne to 0x0043fba0 (forward)
    cmp dword ptr [0x587001], 0x0                # 0043fb07
    jne.d32 L_0043fba0                           # 0043fb0e
    # block 0x0043fb14: entered by fall-through of jne at 0x0043fb0e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fba0
    push 0x547988                                # 0043fb14
    push 0x63a620                                # 0043fb19
    lea edx, [ebp - local_1ce]                   # 0043fb1e
    push edx                                     # 0043fb24
    call FUN_0043f210                            # 0043fb25
    add esp, 0xc                                 # 0043fb2a
    mov edi, 0x547990                            # 0043fb2d
    lea edx, [ebp - local_3e]                    # 0043fb32
    or ecx, -0x1                                 # 0043fb35
    {load} xor eax, eax                          # 0043fb38
    repne scasb al, byte ptr es:[edi]            # 0043fb3a
    not ecx                                      # 0043fb3c
    {load} sub edi, ecx                          # 0043fb3e
    {load} mov esi, edi                          # 0043fb40
    {load} mov eax, ecx                          # 0043fb42
    {load} mov edi, edx                          # 0043fb44
    shr ecx, 0x2                                 # 0043fb46
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043fb49
    {load} mov ecx, eax                          # 0043fb4b
    and ecx, 0x3                                 # 0043fb4d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fb50
    mov word ptr [ebp - local_1c], 0x434         # 0043fb52
    mov word ptr [ebp - local_1a], 0x0           # 0043fb58
    mov word ptr [ebp - local_18], 0x0           # 0043fb5e
    mov word ptr [ebp - local_16], 0x1           # 0043fb64
    mov word ptr [ebp - local_8], 0xffff         # 0043fb6a
    mov byte ptr [ebp - local_6], 0x0            # 0043fb70
    mov word ptr [ebp - local_5], 0x2            # 0043fb74
    mov dword ptr [ebp - local_14], 0x0          # 0043fb7a
    mov dword ptr [ebp - local_10], 0x0          # 0043fb81
    mov dword ptr [ebp - local_c], 0x1           # 0043fb88
    lea ecx, [ebp - local_1d4]                   # 0043fb8f
    push ecx                                     # 0043fb95
    mov ecx, 0x6177e8                            # 0043fb96
    call FUN_0041fa11                            # 0043fb9b
L_0043fba0:
    # block 0x0043fba0: entered by jne at 0x0043fb01; jne at 0x0043fb0e, 2 instruction(s), ends with jne to 0x0043fc46 (forward)
    cmp dword ptr [0x587505], 0x1                # 0043fba0
    jne.d32 L_0043fc46                           # 0043fba7
    # block 0x0043fbad: entered by fall-through of jne at 0x0043fba7, 2 instruction(s), ends with jne to 0x0043fc46 (forward)
    cmp dword ptr [0x586fb9], 0x0                # 0043fbad
    jne.d32 L_0043fc46                           # 0043fbb4
    # block 0x0043fbba: entered by fall-through of jne at 0x0043fbb4, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fc46
    push 0x547998                                # 0043fbba
    push 0x63a624                                # 0043fbbf
    lea edx, [ebp - local_1ce]                   # 0043fbc4
    push edx                                     # 0043fbca
    call FUN_0043f210                            # 0043fbcb
    add esp, 0xc                                 # 0043fbd0
    mov edi, 0x5479a0                            # 0043fbd3
    lea edx, [ebp - local_3e]                    # 0043fbd8
    or ecx, -0x1                                 # 0043fbdb
    {load} xor eax, eax                          # 0043fbde
    repne scasb al, byte ptr es:[edi]            # 0043fbe0
    not ecx                                      # 0043fbe2
    {load} sub edi, ecx                          # 0043fbe4
    {load} mov esi, edi                          # 0043fbe6
    {load} mov eax, ecx                          # 0043fbe8
    {load} mov edi, edx                          # 0043fbea
    shr ecx, 0x2                                 # 0043fbec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043fbef
    {load} mov ecx, eax                          # 0043fbf1
    and ecx, 0x3                                 # 0043fbf3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fbf6
    mov word ptr [ebp - local_1c], 0x435         # 0043fbf8
    mov word ptr [ebp - local_1a], 0x0           # 0043fbfe
    mov word ptr [ebp - local_18], 0x0           # 0043fc04
    mov word ptr [ebp - local_16], 0x1           # 0043fc0a
    mov word ptr [ebp - local_8], 0xffff         # 0043fc10
    mov byte ptr [ebp - local_6], 0x0            # 0043fc16
    mov word ptr [ebp - local_5], 0x2            # 0043fc1a
    mov dword ptr [ebp - local_14], 0x0          # 0043fc20
    mov dword ptr [ebp - local_10], 0x0          # 0043fc27
    mov dword ptr [ebp - local_c], 0x1           # 0043fc2e
    lea ecx, [ebp - local_1d4]                   # 0043fc35
    push ecx                                     # 0043fc3b
    mov ecx, 0x6177e8                            # 0043fc3c
    call FUN_0041fa11                            # 0043fc41
L_0043fc46:
    # block 0x0043fc46: entered by jne at 0x0043fba7; jne at 0x0043fbb4, 2 instruction(s), ends with jne to 0x0043fd06 (forward)
    cmp dword ptr [0x587855], 0x1                # 0043fc46
    jne.d32 L_0043fd06                           # 0043fc4d
    # block 0x0043fc53: entered by fall-through of jne at 0x0043fc4d, 2 instruction(s), ends with jne to 0x0043fd06 (forward)
    cmp dword ptr [0x587705], 0x0                # 0043fc53
    jne.d32 L_0043fd06                           # 0043fc5a
    # block 0x0043fc60: entered by fall-through of jne at 0x0043fc5a, 2 instruction(s), ends with jne to 0x0043fd06 (forward)
    cmp dword ptr [0x586da5], 0x0                # 0043fc60
    jne.d32 L_0043fd06                           # 0043fc67
    # block 0x0043fc6d: entered by fall-through of jne at 0x0043fc67, 2 instruction(s), ends with jne to 0x0043fd06 (forward)
    cmp dword ptr [0x586fd1], 0x0                # 0043fc6d
    jne.d32 L_0043fd06                           # 0043fc74
    # block 0x0043fc7a: entered by fall-through of jne at 0x0043fc74, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fd06
    push 0x5479a8                                # 0043fc7a
    push 0x63a628                                # 0043fc7f
    lea edx, [ebp - local_1ce]                   # 0043fc84
    push edx                                     # 0043fc8a
    call FUN_0043f210                            # 0043fc8b
    add esp, 0xc                                 # 0043fc90
    mov edi, 0x5479b0                            # 0043fc93
    lea edx, [ebp - local_3e]                    # 0043fc98
    or ecx, -0x1                                 # 0043fc9b
    {load} xor eax, eax                          # 0043fc9e
    repne scasb al, byte ptr es:[edi]            # 0043fca0
    not ecx                                      # 0043fca2
    {load} sub edi, ecx                          # 0043fca4
    {load} mov esi, edi                          # 0043fca6
    {load} mov eax, ecx                          # 0043fca8
    {load} mov edi, edx                          # 0043fcaa
    shr ecx, 0x2                                 # 0043fcac
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043fcaf
    {load} mov ecx, eax                          # 0043fcb1
    and ecx, 0x3                                 # 0043fcb3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fcb6
    mov word ptr [ebp - local_1c], 0x436         # 0043fcb8
    mov word ptr [ebp - local_1a], 0x0           # 0043fcbe
    mov word ptr [ebp - local_18], 0x0           # 0043fcc4
    mov word ptr [ebp - local_16], 0x1           # 0043fcca
    mov word ptr [ebp - local_8], 0xffff         # 0043fcd0
    mov byte ptr [ebp - local_6], 0x0            # 0043fcd6
    mov word ptr [ebp - local_5], 0x2            # 0043fcda
    mov dword ptr [ebp - local_14], 0x0          # 0043fce0
    mov dword ptr [ebp - local_10], 0x0          # 0043fce7
    mov dword ptr [ebp - local_c], 0x1           # 0043fcee
    lea ecx, [ebp - local_1d4]                   # 0043fcf5
    push ecx                                     # 0043fcfb
    mov ecx, 0x6177e8                            # 0043fcfc
    call FUN_0041fa11                            # 0043fd01
L_0043fd06:
    # block 0x0043fd06: entered by jne at 0x0043fc4d; jne at 0x0043fc5a; jne at 0x0043fc67; jne at 0x0043fc74, 2 instruction(s), ends with jne to 0x0043fdac (forward)
    cmp dword ptr [0x586d15], 0x1                # 0043fd06
    jne.d32 L_0043fdac                           # 0043fd0d
    # block 0x0043fd13: entered by fall-through of jne at 0x0043fd0d, 2 instruction(s), ends with jne to 0x0043fdac (forward)
    cmp dword ptr [0x58701d], 0x0                # 0043fd13
    jne.d32 L_0043fdac                           # 0043fd1a
    # block 0x0043fd20: entered by fall-through of jne at 0x0043fd1a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fdac
    push 0x5479b8                                # 0043fd20
    push 0x63a62c                                # 0043fd25
    lea edx, [ebp - local_1ce]                   # 0043fd2a
    push edx                                     # 0043fd30
    call FUN_0043f210                            # 0043fd31
    add esp, 0xc                                 # 0043fd36
    mov edi, 0x5479c0                            # 0043fd39
    lea edx, [ebp - local_3e]                    # 0043fd3e
    or ecx, -0x1                                 # 0043fd41
    {load} xor eax, eax                          # 0043fd44
    repne scasb al, byte ptr es:[edi]            # 0043fd46
    not ecx                                      # 0043fd48
    {load} sub edi, ecx                          # 0043fd4a
    {load} mov esi, edi                          # 0043fd4c
    {load} mov eax, ecx                          # 0043fd4e
    {load} mov edi, edx                          # 0043fd50
    shr ecx, 0x2                                 # 0043fd52
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043fd55
    {load} mov ecx, eax                          # 0043fd57
    and ecx, 0x3                                 # 0043fd59
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fd5c
    mov word ptr [ebp - local_1c], 0x43a         # 0043fd5e
    mov word ptr [ebp - local_1a], 0x0           # 0043fd64
    mov word ptr [ebp - local_18], 0x0           # 0043fd6a
    mov word ptr [ebp - local_16], 0x1           # 0043fd70
    mov word ptr [ebp - local_8], 0xffff         # 0043fd76
    mov byte ptr [ebp - local_6], 0x0            # 0043fd7c
    mov word ptr [ebp - local_5], 0x2            # 0043fd80
    mov dword ptr [ebp - local_14], 0x0          # 0043fd86
    mov dword ptr [ebp - local_10], 0x0          # 0043fd8d
    mov dword ptr [ebp - local_c], 0x1           # 0043fd94
    lea ecx, [ebp - local_1d4]                   # 0043fd9b
    push ecx                                     # 0043fda1
    mov ecx, 0x6177e8                            # 0043fda2
    call FUN_0041fa11                            # 0043fda7
L_0043fdac:
    # block 0x0043fdac: entered by jne at 0x0043fd0d; jne at 0x0043fd1a, 2 instruction(s), ends with jne to 0x0043fe6c (forward)
    cmp dword ptr [0x586ffd], 0x1                # 0043fdac
    jne.d32 L_0043fe6c                           # 0043fdb3
    # block 0x0043fdb9: entered by fall-through of jne at 0x0043fdb3, 2 instruction(s), ends with jne to 0x0043fe6c (forward)
    cmp dword ptr [0x587881], 0x1                # 0043fdb9
    jne.d32 L_0043fe6c                           # 0043fdc0
    # block 0x0043fdc6: entered by fall-through of jne at 0x0043fdc0, 2 instruction(s), ends with jne to 0x0043fe6c (forward)
    cmp dword ptr [0x587749], 0x0                # 0043fdc6
    jne.d32 L_0043fe6c                           # 0043fdcd
    # block 0x0043fdd3: entered by fall-through of jne at 0x0043fdcd, 2 instruction(s), ends with jne to 0x0043fe6c (forward)
    cmp dword ptr [0x586fe9], 0x0                # 0043fdd3
    jne.d32 L_0043fe6c                           # 0043fdda
    # block 0x0043fde0: entered by fall-through of jne at 0x0043fdda, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043fe6c
    push 0x5479c8                                # 0043fde0
    push 0x63a630                                # 0043fde5
    lea edx, [ebp - local_1ce]                   # 0043fdea
    push edx                                     # 0043fdf0
    call FUN_0043f210                            # 0043fdf1
    add esp, 0xc                                 # 0043fdf6
    mov edi, 0x5479d0                            # 0043fdf9
    lea edx, [ebp - local_3e]                    # 0043fdfe
    or ecx, -0x1                                 # 0043fe01
    {load} xor eax, eax                          # 0043fe04
    repne scasb al, byte ptr es:[edi]            # 0043fe06
    not ecx                                      # 0043fe08
    {load} sub edi, ecx                          # 0043fe0a
    {load} mov esi, edi                          # 0043fe0c
    {load} mov eax, ecx                          # 0043fe0e
    {load} mov edi, edx                          # 0043fe10
    shr ecx, 0x2                                 # 0043fe12
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043fe15
    {load} mov ecx, eax                          # 0043fe17
    and ecx, 0x3                                 # 0043fe19
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fe1c
    mov word ptr [ebp - local_1c], 0x43e         # 0043fe1e
    mov word ptr [ebp - local_1a], 0x0           # 0043fe24
    mov word ptr [ebp - local_18], 0x0           # 0043fe2a
    mov word ptr [ebp - local_16], 0x1           # 0043fe30
    mov word ptr [ebp - local_8], 0xffff         # 0043fe36
    mov byte ptr [ebp - local_6], 0x0            # 0043fe3c
    mov word ptr [ebp - local_5], 0x2            # 0043fe40
    mov dword ptr [ebp - local_14], 0x0          # 0043fe46
    mov dword ptr [ebp - local_10], 0x0          # 0043fe4d
    mov dword ptr [ebp - local_c], 0x1           # 0043fe54
    lea ecx, [ebp - local_1d4]                   # 0043fe5b
    push ecx                                     # 0043fe61
    mov ecx, 0x6177e8                            # 0043fe62
    call FUN_0041fa11                            # 0043fe67
L_0043fe6c:
    # block 0x0043fe6c: entered by jne at 0x0043fdb3; jne at 0x0043fdc0; jne at 0x0043fdcd; jne at 0x0043fdda, 2 instruction(s), ends with jne to 0x0043ff12 (forward)
    cmp dword ptr [0x587749], 0x1                # 0043fe6c
    jne.d32 L_0043ff12                           # 0043fe73
    # block 0x0043fe79: entered by fall-through of jne at 0x0043fe73, 2 instruction(s), ends with jne to 0x0043ff12 (forward)
    cmp dword ptr [0x587015], 0x0                # 0043fe79
    jne.d32 L_0043ff12                           # 0043fe80
    # block 0x0043fe86: entered by fall-through of jne at 0x0043fe80, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043ff12
    push 0x5479d8                                # 0043fe86
    push 0x63a634                                # 0043fe8b
    lea edx, [ebp - local_1ce]                   # 0043fe90
    push edx                                     # 0043fe96
    call FUN_0043f210                            # 0043fe97
    add esp, 0xc                                 # 0043fe9c
    mov edi, 0x5479e0                            # 0043fe9f
    lea edx, [ebp - local_3e]                    # 0043fea4
    or ecx, -0x1                                 # 0043fea7
    {load} xor eax, eax                          # 0043feaa
    repne scasb al, byte ptr es:[edi]            # 0043feac
    not ecx                                      # 0043feae
    {load} sub edi, ecx                          # 0043feb0
    {load} mov esi, edi                          # 0043feb2
    {load} mov eax, ecx                          # 0043feb4
    {load} mov edi, edx                          # 0043feb6
    shr ecx, 0x2                                 # 0043feb8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043febb
    {load} mov ecx, eax                          # 0043febd
    and ecx, 0x3                                 # 0043febf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043fec2
    mov word ptr [ebp - local_1c], 0x440         # 0043fec4
    mov word ptr [ebp - local_1a], 0x0           # 0043feca
    mov word ptr [ebp - local_18], 0x0           # 0043fed0
    mov word ptr [ebp - local_16], 0x1           # 0043fed6
    mov word ptr [ebp - local_8], 0xffff         # 0043fedc
    mov byte ptr [ebp - local_6], 0x0            # 0043fee2
    mov word ptr [ebp - local_5], 0x2            # 0043fee6
    mov dword ptr [ebp - local_14], 0x0          # 0043feec
    mov dword ptr [ebp - local_10], 0x0          # 0043fef3
    mov dword ptr [ebp - local_c], 0x1           # 0043fefa
    lea ecx, [ebp - local_1d4]                   # 0043ff01
    push ecx                                     # 0043ff07
    mov ecx, 0x6177e8                            # 0043ff08
    call FUN_0041fa11                            # 0043ff0d
L_0043ff12:
    # block 0x0043ff12: entered by jne at 0x0043fe73; jne at 0x0043fe80, 5 instruction(s), ends with ret
    pop edi                                      # 0043ff12
    pop esi                                      # 0043ff13
    {load} mov esp, ebp                          # 0043ff14
    pop ebp                                      # 0043ff16
    ret                                          # 0043ff17

