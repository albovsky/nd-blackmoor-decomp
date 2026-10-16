# FUN_0044423f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044423f
# extent:       0x0044423f-0x0044499c (1885 code bytes)
# span:         0x0044423f-0x0044499c (code 1885, tables 0, padding 0)
# sha256:       5d16b5f8b7fde0d5f14e9ded9fd925019a6dc3eecff7d7d3aae20918f55fd954
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044423f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 432 instruction(s), 36 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0044423f - 0x401000
.globl FUN_0044423f
FUN_0044423f:
    # block 0x0044423f: entry, 7 instruction(s), ends with jne to 0x0044430a (forward)
    push ebp                                     # 0044423f
    {load} mov ebp, esp                          # 00444240
    sub esp, 0x1d4                               # 00444242
    push esi                                     # 00444248
    push edi                                     # 00444249
    cmp dword ptr [0x587089], 0x1                # 0044424a
    jne.d32 L_0044430a                           # 00444251
    # block 0x00444257: entered by fall-through of jne at 0x00444251, 2 instruction(s), ends with jne to 0x0044430a (forward)
    cmp dword ptr [0x587561], 0x0                # 00444257
    jne.d32 L_0044430a                           # 0044425e
    # block 0x00444264: entered by fall-through of jne at 0x0044425e, 2 instruction(s), ends with jne to 0x0044430a (forward)
    cmp dword ptr [0x587521], 0x0                # 00444264
    jne.d32 L_0044430a                           # 0044426b
    # block 0x00444271: entered by fall-through of jne at 0x0044426b, 2 instruction(s), ends with jne to 0x0044430a (forward)
    cmp dword ptr [0x5871f9], 0x0                # 00444271
    jne.d32 L_0044430a                           # 00444278
    # block 0x0044427e: entered by fall-through of jne at 0x00444278, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044430a
    push 0x548028                                # 0044427e
    push 0x63a7c8                                # 00444283
    lea eax, [ebp - local_1ce]                   # 00444288
    push eax                                     # 0044428e
    call FUN_0043f210                            # 0044428f
    add esp, 0xc                                 # 00444294
    mov edi, 0x548030                            # 00444297
    lea edx, [ebp - local_3e]                    # 0044429c
    or ecx, -0x1                                 # 0044429f
    {load} xor eax, eax                          # 004442a2
    repne scasb al, byte ptr es:[edi]            # 004442a4
    not ecx                                      # 004442a6
    {load} sub edi, ecx                          # 004442a8
    {load} mov esi, edi                          # 004442aa
    {load} mov eax, ecx                          # 004442ac
    {load} mov edi, edx                          # 004442ae
    shr ecx, 0x2                                 # 004442b0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004442b3
    {load} mov ecx, eax                          # 004442b5
    and ecx, 0x3                                 # 004442b7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004442ba
    mov word ptr [ebp - local_1c], 0x6ac         # 004442bc
    mov word ptr [ebp - local_1a], 0x0           # 004442c2
    mov word ptr [ebp - local_18], 0x0           # 004442c8
    mov word ptr [ebp - local_16], 0x1           # 004442ce
    mov word ptr [ebp - local_8], 0xffff         # 004442d4
    mov byte ptr [ebp - local_6], 0x0            # 004442da
    mov word ptr [ebp - local_5], 0x2            # 004442de
    mov dword ptr [ebp - local_14], 0x0          # 004442e4
    mov dword ptr [ebp - local_10], 0x0          # 004442eb
    mov dword ptr [ebp - local_c], 0x1           # 004442f2
    lea ecx, [ebp - local_1d4]                   # 004442f9
    push ecx                                     # 004442ff
    mov ecx, 0x6177e8                            # 00444300
    call FUN_0041fa11                            # 00444305
L_0044430a:
    # block 0x0044430a: entered by jne at 0x00444251; jne at 0x0044425e; jne at 0x0044426b; jne at 0x00444278, 2 instruction(s), ends with jne to 0x004443d7 (forward)
    cmp dword ptr [0x586f59], 0x1                # 0044430a
    jne.d32 L_004443d7                           # 00444311
    # block 0x00444317: entered by fall-through of jne at 0x00444311, 2 instruction(s), ends with jne to 0x004443d7 (forward)
    cmp dword ptr [0x5871f9], 0x1                # 00444317
    jne.d32 L_004443d7                           # 0044431e
    # block 0x00444324: entered by fall-through of jne at 0x0044431e, 2 instruction(s), ends with jne to 0x004443d7 (forward)
    cmp dword ptr [0x587521], 0x0                # 00444324
    jne.d32 L_004443d7                           # 0044432b
    # block 0x00444331: entered by fall-through of jne at 0x0044432b, 2 instruction(s), ends with jne to 0x004443d7 (forward)
    cmp dword ptr [0x587561], 0x0                # 00444331
    jne.d32 L_004443d7                           # 00444338
    # block 0x0044433e: entered by fall-through of jne at 0x00444338, 2 instruction(s), ends with jne to 0x004443d7 (forward)
    cmp dword ptr [0x5871f1], 0x0                # 0044433e
    jne.d32 L_004443d7                           # 00444345
    # block 0x0044434b: entered by fall-through of jne at 0x00444345, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004443d7
    push 0x548038                                # 0044434b
    push 0x63a7cc                                # 00444350
    lea edx, [ebp - local_1ce]                   # 00444355
    push edx                                     # 0044435b
    call FUN_0043f210                            # 0044435c
    add esp, 0xc                                 # 00444361
    mov edi, 0x548040                            # 00444364
    lea edx, [ebp - local_3e]                    # 00444369
    or ecx, -0x1                                 # 0044436c
    {load} xor eax, eax                          # 0044436f
    repne scasb al, byte ptr es:[edi]            # 00444371
    not ecx                                      # 00444373
    {load} sub edi, ecx                          # 00444375
    {load} mov esi, edi                          # 00444377
    {load} mov eax, ecx                          # 00444379
    {load} mov edi, edx                          # 0044437b
    shr ecx, 0x2                                 # 0044437d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444380
    {load} mov ecx, eax                          # 00444382
    and ecx, 0x3                                 # 00444384
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444387
    mov word ptr [ebp - local_1c], 0x6ae         # 00444389
    mov word ptr [ebp - local_1a], 0x0           # 0044438f
    mov word ptr [ebp - local_18], 0x0           # 00444395
    mov word ptr [ebp - local_16], 0x1           # 0044439b
    mov word ptr [ebp - local_8], 0xffff         # 004443a1
    mov byte ptr [ebp - local_6], 0x0            # 004443a7
    mov word ptr [ebp - local_5], 0x2            # 004443ab
    mov dword ptr [ebp - local_14], 0x0          # 004443b1
    mov dword ptr [ebp - local_10], 0x0          # 004443b8
    mov dword ptr [ebp - local_c], 0x1           # 004443bf
    lea ecx, [ebp - local_1d4]                   # 004443c6
    push ecx                                     # 004443cc
    mov ecx, 0x6177e8                            # 004443cd
    call FUN_0041fa11                            # 004443d2
L_004443d7:
    # block 0x004443d7: entered by jne at 0x00444311; jne at 0x0044431e; jne at 0x0044432b; jne at 0x00444338; more, 2 instruction(s), ends with jne to 0x0044448a (forward)
    cmp dword ptr [0x5875e5], 0x1                # 004443d7
    jne.d32 L_0044448a                           # 004443de
    # block 0x004443e4: entered by fall-through of jne at 0x004443de, 2 instruction(s), ends with jne to 0x0044448a (forward)
    cmp dword ptr [0x587751], 0x0                # 004443e4
    jne.d32 L_0044448a                           # 004443eb
    # block 0x004443f1: entered by fall-through of jne at 0x004443eb, 2 instruction(s), ends with jne to 0x0044448a (forward)
    cmp dword ptr [0x5871fd], 0x0                # 004443f1
    jne.d32 L_0044448a                           # 004443f8
    # block 0x004443fe: entered by fall-through of jne at 0x004443f8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044448a
    push 0x548048                                # 004443fe
    push 0x63a7d0                                # 00444403
    lea edx, [ebp - local_1ce]                   # 00444408
    push edx                                     # 0044440e
    call FUN_0043f210                            # 0044440f
    add esp, 0xc                                 # 00444414
    mov edi, 0x548050                            # 00444417
    lea edx, [ebp - local_3e]                    # 0044441c
    or ecx, -0x1                                 # 0044441f
    {load} xor eax, eax                          # 00444422
    repne scasb al, byte ptr es:[edi]            # 00444424
    not ecx                                      # 00444426
    {load} sub edi, ecx                          # 00444428
    {load} mov esi, edi                          # 0044442a
    {load} mov eax, ecx                          # 0044442c
    {load} mov edi, edx                          # 0044442e
    shr ecx, 0x2                                 # 00444430
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444433
    {load} mov ecx, eax                          # 00444435
    and ecx, 0x3                                 # 00444437
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044443a
    mov word ptr [ebp - local_1c], 0x6b0         # 0044443c
    mov word ptr [ebp - local_1a], 0x0           # 00444442
    mov word ptr [ebp - local_18], 0x0           # 00444448
    mov word ptr [ebp - local_16], 0x1           # 0044444e
    mov word ptr [ebp - local_8], 0xffff         # 00444454
    mov byte ptr [ebp - local_6], 0x0            # 0044445a
    mov word ptr [ebp - local_5], 0x2            # 0044445e
    mov dword ptr [ebp - local_14], 0x0          # 00444464
    mov dword ptr [ebp - local_10], 0x0          # 0044446b
    mov dword ptr [ebp - local_c], 0x1           # 00444472
    lea ecx, [ebp - local_1d4]                   # 00444479
    push ecx                                     # 0044447f
    mov ecx, 0x6177e8                            # 00444480
    call FUN_0041fa11                            # 00444485
L_0044448a:
    # block 0x0044448a: entered by jne at 0x004443de; jne at 0x004443eb; jne at 0x004443f8, 2 instruction(s), ends with jne to 0x0044454a (forward)
    cmp dword ptr [0x587661], 0x1                # 0044448a
    jne.d32 L_0044454a                           # 00444491
    # block 0x00444497: entered by fall-through of jne at 0x00444491, 2 instruction(s), ends with jne to 0x0044454a (forward)
    cmp dword ptr [0x586fed], 0x1                # 00444497
    jne.d32 L_0044454a                           # 0044449e
    # block 0x004444a4: entered by fall-through of jne at 0x0044449e, 2 instruction(s), ends with jne to 0x0044454a (forward)
    cmp dword ptr [0x58773d], 0x0                # 004444a4
    jne.d32 L_0044454a                           # 004444ab
    # block 0x004444b1: entered by fall-through of jne at 0x004444ab, 2 instruction(s), ends with jne to 0x0044454a (forward)
    cmp dword ptr [0x587205], 0x0                # 004444b1
    jne.d32 L_0044454a                           # 004444b8
    # block 0x004444be: entered by fall-through of jne at 0x004444b8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044454a
    push 0x548058                                # 004444be
    push 0x63a7d4                                # 004444c3
    lea edx, [ebp - local_1ce]                   # 004444c8
    push edx                                     # 004444ce
    call FUN_0043f210                            # 004444cf
    add esp, 0xc                                 # 004444d4
    mov edi, 0x548060                            # 004444d7
    lea edx, [ebp - local_3e]                    # 004444dc
    or ecx, -0x1                                 # 004444df
    {load} xor eax, eax                          # 004444e2
    repne scasb al, byte ptr es:[edi]            # 004444e4
    not ecx                                      # 004444e6
    {load} sub edi, ecx                          # 004444e8
    {load} mov esi, edi                          # 004444ea
    {load} mov eax, ecx                          # 004444ec
    {load} mov edi, edx                          # 004444ee
    shr ecx, 0x2                                 # 004444f0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004444f3
    {load} mov ecx, eax                          # 004444f5
    and ecx, 0x3                                 # 004444f7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004444fa
    mov word ptr [ebp - local_1c], 0x6b3         # 004444fc
    mov word ptr [ebp - local_1a], 0x0           # 00444502
    mov word ptr [ebp - local_18], 0x0           # 00444508
    mov word ptr [ebp - local_16], 0x1           # 0044450e
    mov word ptr [ebp - local_8], 0xffff         # 00444514
    mov byte ptr [ebp - local_6], 0x0            # 0044451a
    mov word ptr [ebp - local_5], 0x2            # 0044451e
    mov dword ptr [ebp - local_14], 0x0          # 00444524
    mov dword ptr [ebp - local_10], 0x0          # 0044452b
    mov dword ptr [ebp - local_c], 0x1           # 00444532
    lea ecx, [ebp - local_1d4]                   # 00444539
    push ecx                                     # 0044453f
    mov ecx, 0x6177e8                            # 00444540
    call FUN_0041fa11                            # 00444545
L_0044454a:
    # block 0x0044454a: entered by jne at 0x00444491; jne at 0x0044449e; jne at 0x004444ab; jne at 0x004444b8, 2 instruction(s), ends with jne to 0x004445fd (forward)
    cmp dword ptr [0x587491], 0x1                # 0044454a
    jne.d32 L_004445fd                           # 00444551
    # block 0x00444557: entered by fall-through of jne at 0x00444551, 2 instruction(s), ends with jne to 0x004445fd (forward)
    cmp dword ptr [0x587751], 0x0                # 00444557
    jne.d32 L_004445fd                           # 0044455e
    # block 0x00444564: entered by fall-through of jne at 0x0044455e, 2 instruction(s), ends with jne to 0x004445fd (forward)
    cmp dword ptr [0x5871ed], 0x0                # 00444564
    jne.d32 L_004445fd                           # 0044456b
    # block 0x00444571: entered by fall-through of jne at 0x0044456b, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004445fd
    push 0x548068                                # 00444571
    push 0x63a7d8                                # 00444576
    lea edx, [ebp - local_1ce]                   # 0044457b
    push edx                                     # 00444581
    call FUN_0043f210                            # 00444582
    add esp, 0xc                                 # 00444587
    mov edi, 0x548070                            # 0044458a
    lea edx, [ebp - local_3e]                    # 0044458f
    or ecx, -0x1                                 # 00444592
    {load} xor eax, eax                          # 00444595
    repne scasb al, byte ptr es:[edi]            # 00444597
    not ecx                                      # 00444599
    {load} sub edi, ecx                          # 0044459b
    {load} mov esi, edi                          # 0044459d
    {load} mov eax, ecx                          # 0044459f
    {load} mov edi, edx                          # 004445a1
    shr ecx, 0x2                                 # 004445a3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004445a6
    {load} mov ecx, eax                          # 004445a8
    and ecx, 0x3                                 # 004445aa
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004445ad
    mov word ptr [ebp - local_1c], 0x6b6         # 004445af
    mov word ptr [ebp - local_1a], 0x0           # 004445b5
    mov word ptr [ebp - local_18], 0x0           # 004445bb
    mov word ptr [ebp - local_16], 0x1           # 004445c1
    mov word ptr [ebp - local_8], 0xffff         # 004445c7
    mov byte ptr [ebp - local_6], 0x0            # 004445cd
    mov word ptr [ebp - local_5], 0x2            # 004445d1
    mov dword ptr [ebp - local_14], 0x0          # 004445d7
    mov dword ptr [ebp - local_10], 0x0          # 004445de
    mov dword ptr [ebp - local_c], 0x1           # 004445e5
    lea ecx, [ebp - local_1d4]                   # 004445ec
    push ecx                                     # 004445f2
    mov ecx, 0x6177e8                            # 004445f3
    call FUN_0041fa11                            # 004445f8
L_004445fd:
    # block 0x004445fd: entered by jne at 0x00444551; jne at 0x0044455e; jne at 0x0044456b, 2 instruction(s), ends with jne to 0x004446ca (forward)
    cmp dword ptr [0x5869e5], 0x1                # 004445fd
    jne.d32 L_004446ca                           # 00444604
    # block 0x0044460a: entered by fall-through of jne at 0x00444604, 2 instruction(s), ends with jne to 0x004446ca (forward)
    cmp dword ptr [0x586f59], 0x1                # 0044460a
    jne.d32 L_004446ca                           # 00444611
    # block 0x00444617: entered by fall-through of jne at 0x00444611, 2 instruction(s), ends with jne to 0x004446ca (forward)
    cmp dword ptr [0x587235], 0x1                # 00444617
    jne.d32 L_004446ca                           # 0044461e
    # block 0x00444624: entered by fall-through of jne at 0x0044461e, 2 instruction(s), ends with jne to 0x004446ca (forward)
    cmp dword ptr [0x587561], 0x0                # 00444624
    jne.d32 L_004446ca                           # 0044462b
    # block 0x00444631: entered by fall-through of jne at 0x0044462b, 2 instruction(s), ends with jne to 0x004446ca (forward)
    cmp dword ptr [0x5871e9], 0x0                # 00444631
    jne.d32 L_004446ca                           # 00444638
    # block 0x0044463e: entered by fall-through of jne at 0x00444638, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004446ca
    push 0x548078                                # 0044463e
    push 0x63a7dc                                # 00444643
    lea edx, [ebp - local_1ce]                   # 00444648
    push edx                                     # 0044464e
    call FUN_0043f210                            # 0044464f
    add esp, 0xc                                 # 00444654
    mov edi, 0x548080                            # 00444657
    lea edx, [ebp - local_3e]                    # 0044465c
    or ecx, -0x1                                 # 0044465f
    {load} xor eax, eax                          # 00444662
    repne scasb al, byte ptr es:[edi]            # 00444664
    not ecx                                      # 00444666
    {load} sub edi, ecx                          # 00444668
    {load} mov esi, edi                          # 0044466a
    {load} mov eax, ecx                          # 0044466c
    {load} mov edi, edx                          # 0044466e
    shr ecx, 0x2                                 # 00444670
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444673
    {load} mov ecx, eax                          # 00444675
    and ecx, 0x3                                 # 00444677
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044467a
    mov word ptr [ebp - local_1c], 0x6b9         # 0044467c
    mov word ptr [ebp - local_1a], 0x0           # 00444682
    mov word ptr [ebp - local_18], 0x0           # 00444688
    mov word ptr [ebp - local_16], 0x1           # 0044468e
    mov word ptr [ebp - local_8], 0xffff         # 00444694
    mov byte ptr [ebp - local_6], 0x0            # 0044469a
    mov word ptr [ebp - local_5], 0x2            # 0044469e
    mov dword ptr [ebp - local_14], 0x0          # 004446a4
    mov dword ptr [ebp - local_10], 0x0          # 004446ab
    mov dword ptr [ebp - local_c], 0x1           # 004446b2
    lea ecx, [ebp - local_1d4]                   # 004446b9
    push ecx                                     # 004446bf
    mov ecx, 0x6177e8                            # 004446c0
    call FUN_0041fa11                            # 004446c5
L_004446ca:
    # block 0x004446ca: entered by jne at 0x00444604; jne at 0x00444611; jne at 0x0044461e; jne at 0x0044462b; more, 2 instruction(s), ends with jne to 0x00444770 (forward)
    cmp dword ptr [0x587655], 0x1                # 004446ca
    jne.d32 L_00444770                           # 004446d1
    # block 0x004446d7: entered by fall-through of jne at 0x004446d1, 2 instruction(s), ends with jne to 0x00444770 (forward)
    cmp dword ptr [0x587201], 0x0                # 004446d7
    jne.d32 L_00444770                           # 004446de
    # block 0x004446e4: entered by fall-through of jne at 0x004446de, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444770
    push 0x548088                                # 004446e4
    push 0x63a7e0                                # 004446e9
    lea edx, [ebp - local_1ce]                   # 004446ee
    push edx                                     # 004446f4
    call FUN_0043f210                            # 004446f5
    add esp, 0xc                                 # 004446fa
    mov edi, 0x548090                            # 004446fd
    lea edx, [ebp - local_3e]                    # 00444702
    or ecx, -0x1                                 # 00444705
    {load} xor eax, eax                          # 00444708
    repne scasb al, byte ptr es:[edi]            # 0044470a
    not ecx                                      # 0044470c
    {load} sub edi, ecx                          # 0044470e
    {load} mov esi, edi                          # 00444710
    {load} mov eax, ecx                          # 00444712
    {load} mov edi, edx                          # 00444714
    shr ecx, 0x2                                 # 00444716
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444719
    {load} mov ecx, eax                          # 0044471b
    and ecx, 0x3                                 # 0044471d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444720
    mov word ptr [ebp - local_1c], 0x6bd         # 00444722
    mov word ptr [ebp - local_1a], 0x0           # 00444728
    mov word ptr [ebp - local_18], 0x0           # 0044472e
    mov word ptr [ebp - local_16], 0x1           # 00444734
    mov word ptr [ebp - local_8], 0xffff         # 0044473a
    mov byte ptr [ebp - local_6], 0x0            # 00444740
    mov word ptr [ebp - local_5], 0x2            # 00444744
    mov dword ptr [ebp - local_14], 0x0          # 0044474a
    mov dword ptr [ebp - local_10], 0x0          # 00444751
    mov dword ptr [ebp - local_c], 0x1           # 00444758
    lea ecx, [ebp - local_1d4]                   # 0044475f
    push ecx                                     # 00444765
    mov ecx, 0x6177e8                            # 00444766
    call FUN_0041fa11                            # 0044476b
L_00444770:
    # block 0x00444770: entered by jne at 0x004446d1; jne at 0x004446de, 2 instruction(s), ends with jne to 0x00444830 (forward)
    cmp dword ptr [0x5869ad], 0x1                # 00444770
    jne.d32 L_00444830                           # 00444777
    # block 0x0044477d: entered by fall-through of jne at 0x00444777, 2 instruction(s), ends with jne to 0x00444830 (forward)
    cmp dword ptr [0x586bad], 0x1                # 0044477d
    jne.d32 L_00444830                           # 00444784
    # block 0x0044478a: entered by fall-through of jne at 0x00444784, 2 instruction(s), ends with jne to 0x00444830 (forward)
    cmp dword ptr [0x587205], 0x1                # 0044478a
    jne.d32 L_00444830                           # 00444791
    # block 0x00444797: entered by fall-through of jne at 0x00444791, 2 instruction(s), ends with jne to 0x00444830 (forward)
    cmp dword ptr [0x587209], 0x0                # 00444797
    jne.d32 L_00444830                           # 0044479e
    # block 0x004447a4: entered by fall-through of jne at 0x0044479e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444830
    push 0x548098                                # 004447a4
    push 0x63a7e4                                # 004447a9
    lea edx, [ebp - local_1ce]                   # 004447ae
    push edx                                     # 004447b4
    call FUN_0043f210                            # 004447b5
    add esp, 0xc                                 # 004447ba
    mov edi, 0x5480a0                            # 004447bd
    lea edx, [ebp - local_3e]                    # 004447c2
    or ecx, -0x1                                 # 004447c5
    {load} xor eax, eax                          # 004447c8
    repne scasb al, byte ptr es:[edi]            # 004447ca
    not ecx                                      # 004447cc
    {load} sub edi, ecx                          # 004447ce
    {load} mov esi, edi                          # 004447d0
    {load} mov eax, ecx                          # 004447d2
    {load} mov edi, edx                          # 004447d4
    shr ecx, 0x2                                 # 004447d6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004447d9
    {load} mov ecx, eax                          # 004447db
    and ecx, 0x3                                 # 004447dd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004447e0
    mov word ptr [ebp - local_1c], 0x6be         # 004447e2
    mov word ptr [ebp - local_1a], 0x0           # 004447e8
    mov word ptr [ebp - local_18], 0x0           # 004447ee
    mov word ptr [ebp - local_16], 0x1           # 004447f4
    mov word ptr [ebp - local_8], 0xffff         # 004447fa
    mov byte ptr [ebp - local_6], 0x0            # 00444800
    mov word ptr [ebp - local_5], 0x2            # 00444804
    mov dword ptr [ebp - local_14], 0x0          # 0044480a
    mov dword ptr [ebp - local_10], 0x0          # 00444811
    mov dword ptr [ebp - local_c], 0x1           # 00444818
    lea ecx, [ebp - local_1d4]                   # 0044481f
    push ecx                                     # 00444825
    mov ecx, 0x6177e8                            # 00444826
    call FUN_0041fa11                            # 0044482b
L_00444830:
    # block 0x00444830: entered by jne at 0x00444777; jne at 0x00444784; jne at 0x00444791; jne at 0x0044479e, 2 instruction(s), ends with jne to 0x004448e3 (forward)
    cmp dword ptr [0x587561], 0x1                # 00444830
    jne.d32 L_004448e3                           # 00444837
    # block 0x0044483d: entered by fall-through of jne at 0x00444837, 2 instruction(s), ends with jne to 0x004448e3 (forward)
    cmp dword ptr [0x5871e9], 0x1                # 0044483d
    jne.d32 L_004448e3                           # 00444844
    # block 0x0044484a: entered by fall-through of jne at 0x00444844, 2 instruction(s), ends with jne to 0x004448e3 (forward)
    cmp dword ptr [0x5871f5], 0x0                # 0044484a
    jne.d32 L_004448e3                           # 00444851
    # block 0x00444857: entered by fall-through of jne at 0x00444851, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004448e3
    push 0x5480a8                                # 00444857
    push 0x63a7e8                                # 0044485c
    lea edx, [ebp - local_1ce]                   # 00444861
    push edx                                     # 00444867
    call FUN_0043f210                            # 00444868
    add esp, 0xc                                 # 0044486d
    mov edi, 0x5480b0                            # 00444870
    lea edx, [ebp - local_3e]                    # 00444875
    or ecx, -0x1                                 # 00444878
    {load} xor eax, eax                          # 0044487b
    repne scasb al, byte ptr es:[edi]            # 0044487d
    not ecx                                      # 0044487f
    {load} sub edi, ecx                          # 00444881
    {load} mov esi, edi                          # 00444883
    {load} mov eax, ecx                          # 00444885
    {load} mov edi, edx                          # 00444887
    shr ecx, 0x2                                 # 00444889
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044488c
    {load} mov ecx, eax                          # 0044488e
    and ecx, 0x3                                 # 00444890
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444893
    mov word ptr [ebp - local_1c], 0x6c2         # 00444895
    mov word ptr [ebp - local_1a], 0x0           # 0044489b
    mov word ptr [ebp - local_18], 0x0           # 004448a1
    mov word ptr [ebp - local_16], 0x1           # 004448a7
    mov word ptr [ebp - local_8], 0xffff         # 004448ad
    mov byte ptr [ebp - local_6], 0x0            # 004448b3
    mov word ptr [ebp - local_5], 0x2            # 004448b7
    mov dword ptr [ebp - local_14], 0x0          # 004448bd
    mov dword ptr [ebp - local_10], 0x0          # 004448c4
    mov dword ptr [ebp - local_c], 0x1           # 004448cb
    lea ecx, [ebp - local_1d4]                   # 004448d2
    push ecx                                     # 004448d8
    mov ecx, 0x6177e8                            # 004448d9
    call FUN_0041fa11                            # 004448de
L_004448e3:
    # block 0x004448e3: entered by jne at 0x00444837; jne at 0x00444844; jne at 0x00444851, 2 instruction(s), ends with jne to 0x00444996 (forward)
    cmp dword ptr [0x587561], 0x1                # 004448e3
    jne.d32 L_00444996                           # 004448ea
    # block 0x004448f0: entered by fall-through of jne at 0x004448ea, 2 instruction(s), ends with jne to 0x00444996 (forward)
    cmp dword ptr [0x5871e9], 0x0                # 004448f0
    jne.d32 L_00444996                           # 004448f7
    # block 0x004448fd: entered by fall-through of jne at 0x004448f7, 2 instruction(s), ends with jne to 0x00444996 (forward)
    cmp dword ptr [0x5871f5], 0x0                # 004448fd
    jne.d32 L_00444996                           # 00444904
    # block 0x0044490a: entered by fall-through of jne at 0x00444904, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444996
    push 0x5480b8                                # 0044490a
    push 0x63a7ec                                # 0044490f
    lea edx, [ebp - local_1ce]                   # 00444914
    push edx                                     # 0044491a
    call FUN_0043f210                            # 0044491b
    add esp, 0xc                                 # 00444920
    mov edi, 0x5480c0                            # 00444923
    lea edx, [ebp - local_3e]                    # 00444928
    or ecx, -0x1                                 # 0044492b
    {load} xor eax, eax                          # 0044492e
    repne scasb al, byte ptr es:[edi]            # 00444930
    not ecx                                      # 00444932
    {load} sub edi, ecx                          # 00444934
    {load} mov esi, edi                          # 00444936
    {load} mov eax, ecx                          # 00444938
    {load} mov edi, edx                          # 0044493a
    shr ecx, 0x2                                 # 0044493c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044493f
    {load} mov ecx, eax                          # 00444941
    and ecx, 0x3                                 # 00444943
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444946
    mov word ptr [ebp - local_1c], 0x6c3         # 00444948
    mov word ptr [ebp - local_1a], 0x0           # 0044494e
    mov word ptr [ebp - local_18], 0x0           # 00444954
    mov word ptr [ebp - local_16], 0x1           # 0044495a
    mov word ptr [ebp - local_8], 0xffff         # 00444960
    mov byte ptr [ebp - local_6], 0x0            # 00444966
    mov word ptr [ebp - local_5], 0x2            # 0044496a
    mov dword ptr [ebp - local_14], 0x0          # 00444970
    mov dword ptr [ebp - local_10], 0x0          # 00444977
    mov dword ptr [ebp - local_c], 0x1           # 0044497e
    lea ecx, [ebp - local_1d4]                   # 00444985
    push ecx                                     # 0044498b
    mov ecx, 0x6177e8                            # 0044498c
    call FUN_0041fa11                            # 00444991
L_00444996:
    # block 0x00444996: entered by jne at 0x004448ea; jne at 0x004448f7; jne at 0x00444904, 5 instruction(s), ends with ret
    pop edi                                      # 00444996
    pop esi                                      # 00444997
    {load} mov esp, ebp                          # 00444998
    pop ebp                                      # 0044499a
    ret                                          # 0044499b

