# FUN_00504410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00504410
# extent:       0x00504410-0x00504fc0 (2992 code bytes)
# span:         0x00504410-0x00504fc0 (code 2992, tables 0, padding 0)
# sha256:       04cf490cdc54f6f532f986804b68c4a000925cc931a5305d69472fc411b0fef2
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00504410
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_minus_4, field_minus_8, field_minus_c; [ebp + n] field_8; [ebx + n] field_minus_2; [ecx + n] field_1, field_4, field_8, field_minus_4, field_minus_8, field_minus_c; [edi + n] field_4, field_8, field_minus_4, field_minus_8; [edx + n] field_minus_1; [esi + n] field_minus_1, field_minus_4, field_minus_8, field_minus_c; [esp + n] stk_c, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38 and 13 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 932 instruction(s), 78 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c
.equ stk_60, 0x60  # offset +0x60
.equ stk_64, 0x64  # offset +0x64
.equ stk_68, 0x68  # offset +0x68
.equ stk_6c, 0x6c  # offset +0x6c
.equ stk_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------

.org 0x00504410 - 0x401000
.globl FUN_00504410
FUN_00504410:
    # block 0x00504410: entry, 28 instruction(s), ends with je to 0x005048d0 (forward)
    sub esp, 0x38                                # 00504410
    fild dword ptr [esp + stk_40]                # 00504413
    mov ecx, dword ptr [esp + stk_40]            # 00504417
    mov edx, dword ptr [esp + stk_3c]            # 0050441b
    push ebx                                     # 0050441f
    push ebp                                     # 00504420
    fdivr dword ptr [0x566a10]                   # 00504421
    lea eax, [ecx + field_1]                     # 00504427
    push esi                                     # 0050442a
    sar eax                                      # 0050442b
    mov dword ptr [esp + stk_c], eax             # 0050442d
    lea eax, [edx - field_minus_1]               # 00504431
    sar eax                                      # 00504434
    mov dword ptr [esp + stk_20], eax            # 00504436
    {load} mov eax, edx                          # 0050443a
    push edi                                     # 0050443c
    fld st(0)                                    # 0050443d
    imul eax, dword ptr [esp + stk_54]           # 0050443f
    fcos                                         # 00504444
    mov dword ptr [esp + stk_4c], eax            # 00504446
    {load} mov eax, edx                          # 0050444a
    fstp dword ptr [esp + stk_38]                # 0050444c
    imul eax, ecx                                # 00504450
    fsin                                         # 00504453
    cmp edx, 0x1                                 # 00504455
    mov dword ptr [esp + stk_18], eax            # 00504458
    fstp dword ptr [esp + stk_34]                # 0050445c
    je.d32 L_005048d0                            # 00504460
    # block 0x00504466: entered by fall-through of je at 0x00504460, 3 instruction(s), ends with jle to 0x00504483 (forward)
    mov esi, dword ptr [esp + stk_58]            # 00504466
    test esi, esi                                # 0050446a
    jle.d8 L_00504483                            # 0050446c
    # block 0x0050446e: entered by fall-through of jle at 0x0050446c, 3 instruction(s), falls into the block at 0x00504478
    mov eax, dword ptr [esp + stk_6c]            # 0050446e
    mov ecx, dword ptr [esp + stk_64]            # 00504472
    {load} sub ecx, eax                          # 00504476
L_00504478:
    # block 0x00504478: entered by jne at 0x00504481, 5 instruction(s), ends with jne to 0x00504478 (backward)
    mov edi, dword ptr [ecx + eax]               # 00504478
    mov dword ptr [eax], edi                     # 0050447b
    add eax, 0x4                                 # 0050447d
    dec esi                                      # 00504480
    jne.d8 L_00504478                            # 00504481
L_00504483:
    # block 0x00504483: entered by jle at 0x0050446c; fall-through of jne at 0x00504481, 3 instruction(s), ends with jle to 0x005044de (forward)
    mov esi, dword ptr [esp + stk_50]            # 00504483
    cmp esi, 0x1                                 # 00504487
    jle.d8 L_005044de                            # 0050448a
    # block 0x0050448c: entered by fall-through of jle at 0x0050448a, 4 instruction(s), falls into the block at 0x0050449b
    mov eax, dword ptr [esp + stk_68]            # 0050448c
    mov ebx, dword ptr [esp + stk_54]            # 00504490
    lea ecx, [esi - field_minus_1]               # 00504494
    mov dword ptr [esp + stk_20], ecx            # 00504497
L_0050449b:
    # block 0x0050449b: entered by jne at 0x005044da, 6 instruction(s), ends with jle to 0x005044d1 (forward)
    mov ecx, dword ptr [esp + stk_4c]            # 0050449b
    shl ecx, 0x2                                 # 0050449f
    {load} add eax, ecx                          # 005044a2
    test ebx, ebx                                # 005044a4
    mov dword ptr [esp + stk_3c], eax            # 005044a6
    jle.d8 L_005044d1                            # 005044aa
    # block 0x005044ac: entered by fall-through of jle at 0x005044aa, 5 instruction(s), falls into the block at 0x005044bf
    mov ecx, dword ptr [esp + stk_60]            # 005044ac
    mov esi, dword ptr [esp + stk_68]            # 005044b0
    {load} sub ecx, esi                          # 005044b4
    lea edi, [4*edx]                             # 005044b6
    {load} mov esi, ebx                          # 005044bd
L_005044bf:
    # block 0x005044bf: entered by jne at 0x005044c7, 5 instruction(s), ends with jne to 0x005044bf (backward)
    mov ebp, dword ptr [ecx + eax]               # 005044bf
    mov dword ptr [eax], ebp                     # 005044c2
    {load} add eax, edi                          # 005044c4
    dec esi                                      # 005044c6
    jne.d8 L_005044bf                            # 005044c7
    # block 0x005044c9: entered by fall-through of jne at 0x005044c7, 2 instruction(s), falls into the block at 0x005044d1
    mov eax, dword ptr [esp + stk_3c]            # 005044c9
    mov esi, dword ptr [esp + stk_50]            # 005044cd
L_005044d1:
    # block 0x005044d1: entered by jle at 0x005044aa, 4 instruction(s), ends with jne to 0x0050449b (backward)
    mov ecx, dword ptr [esp + stk_20]            # 005044d1
    dec ecx                                      # 005044d5
    mov dword ptr [esp + stk_20], ecx            # 005044d6
    jne.d8 L_0050449b                            # 005044da
    # block 0x005044dc: entered by fall-through of jne at 0x005044da, 1 instruction(s), ends with forward jump to 0x005044e2
    jmp.d8 L_005044e2                            # 005044dc
L_005044de:
    # block 0x005044de: entered by jle at 0x0050448a, 1 instruction(s), falls into the block at 0x005044e2
    mov ebx, dword ptr [esp + stk_54]            # 005044de
L_005044e2:
    # block 0x005044e2: entered by jmp at 0x005044dc, 5 instruction(s), ends with jle to 0x005045da (forward)
    mov ecx, dword ptr [esp + stk_24]            # 005044e2
    {load} mov eax, edx                          # 005044e6
    neg eax                                      # 005044e8
    {load} cmp ecx, ebx                          # 005044ea
    jle.d32 L_005045da                           # 005044ec
    # block 0x005044f2: entered by fall-through of jle at 0x005044ec, 2 instruction(s), ends with jle to 0x005046a8 (forward)
    cmp esi, 0x1                                 # 005044f2
    jle.d32 L_005046a8                           # 005044f5
    # block 0x005044fb: entered by fall-through of jle at 0x005044f5, 9 instruction(s), falls into the block at 0x00504519
    mov ecx, dword ptr [esp + stk_4c]            # 005044fb
    {load} xor edi, edi                          # 005044ff
    shl ecx, 0x2                                 # 00504501
    mov dword ptr [esp + stk_3c], ecx            # 00504504
    mov ecx, dword ptr [esp + stk_70]            # 00504508
    dec esi                                      # 0050450c
    lea eax, [ecx + 4*eax - field_minus_4]       # 0050450d
    mov dword ptr [esp + stk_14], esi            # 00504511
    mov dword ptr [esp + stk_70], eax            # 00504515
L_00504519:
    # block 0x00504519: entered by jne at 0x005045cf, 11 instruction(s), ends with jle to 0x005045c6 (forward)
    mov eax, dword ptr [esp + stk_3c]            # 00504519
    mov ebp, dword ptr [esp + stk_70]            # 0050451d
    {load} add edi, eax                          # 00504521
    lea ecx, [4*edx]                             # 00504523
    {load} mov eax, edi                          # 0050452a
    {load} add ebp, ecx                          # 0050452c
    {load} sub eax, ecx                          # 0050452e
    mov dword ptr [esp + stk_30], edi            # 00504530
    test ebx, ebx                                # 00504534
    mov dword ptr [esp + stk_70], ebp            # 00504536
    jle.d32 L_005045c6                           # 0050453a
    # block 0x00504540: entered by fall-through of jle at 0x0050453a, 6 instruction(s), falls into the block at 0x00504557
    mov ecx, dword ptr [esp + stk_68]            # 00504540
    mov dword ptr [esp + stk_20], ebx            # 00504544
    lea ebp, [eax + ecx]                         # 00504548
    mov ecx, dword ptr [esp + stk_60]            # 0050454b
    lea eax, [eax + ecx - field_minus_4]         # 0050454f
    mov dword ptr [esp + stk_1c], eax            # 00504553
L_00504557:
    # block 0x00504557: entered by jne at 0x005045c0, 7 instruction(s), ends with jle to 0x005045b7 (forward)
    mov ecx, dword ptr [esp + stk_1c]            # 00504557
    lea eax, [4*edx]                             # 0050455b
    {load} add ebp, eax                          # 00504562
    {load} add ecx, eax                          # 00504564
    cmp edx, 0x2                                 # 00504566
    mov dword ptr [esp + stk_1c], ecx            # 00504569
    jle.d8 L_005045b7                            # 0050456d
    # block 0x0050456f: entered by fall-through of jle at 0x0050456d, 8 instruction(s), falls into the block at 0x00504588
    mov edi, dword ptr [esp + stk_68]            # 0050456f
    mov esi, dword ptr [esp + stk_60]            # 00504573
    mov ecx, dword ptr [esp + stk_70]            # 00504577
    mov eax, dword ptr [esp + stk_1c]            # 0050457b
    {load} sub edi, esi                          # 0050457f
    lea esi, [edx - field_minus_1]               # 00504581
    {load} mov ebx, ebp                          # 00504584
    shr esi                                      # 00504586
L_00504588:
    # block 0x00504588: entered by jne at 0x005045b1, 17 instruction(s), ends with jne to 0x00504588 (backward)
    fld dword ptr [eax + field_c]                # 00504588
    fmul dword ptr [ecx + field_8]               # 0050458b
    fld dword ptr [eax + field_8]                # 0050458e
    add eax, 0x8                                 # 00504591
    add ecx, 0x8                                 # 00504594
    add ebx, 0x8                                 # 00504597
    dec esi                                      # 0050459a
    fmul dword ptr [ecx - field_minus_4]         # 0050459b
    faddp st(1), st                              # 0050459e
    fstp dword ptr [edi + eax]                   # 005045a0
    fld dword ptr [ecx - field_minus_4]          # 005045a3
    fmul dword ptr [eax + field_4]               # 005045a6
    fld dword ptr [eax]                          # 005045a9
    fmul dword ptr [ecx]                         # 005045ab
    fsubp st(1), st                              # 005045ad
    fstp dword ptr [ebx]                         # 005045af
    jne.d8 L_00504588                            # 005045b1
    # block 0x005045b3: entered by fall-through of jne at 0x005045b1, 1 instruction(s), falls into the block at 0x005045b7
    mov ebx, dword ptr [esp + stk_54]            # 005045b3
L_005045b7:
    # block 0x005045b7: entered by jle at 0x0050456d, 4 instruction(s), ends with jne to 0x00504557 (backward)
    mov eax, dword ptr [esp + stk_20]            # 005045b7
    dec eax                                      # 005045bb
    mov dword ptr [esp + stk_20], eax            # 005045bc
    jne.d8 L_00504557                            # 005045c0
    # block 0x005045c2: entered by fall-through of jne at 0x005045c0, 1 instruction(s), falls into the block at 0x005045c6
    mov edi, dword ptr [esp + stk_30]            # 005045c2
L_005045c6:
    # block 0x005045c6: entered by jle at 0x0050453a, 4 instruction(s), ends with jne to 0x00504519 (backward)
    mov eax, dword ptr [esp + stk_14]            # 005045c6
    dec eax                                      # 005045ca
    mov dword ptr [esp + stk_14], eax            # 005045cb
    jne.d32 L_00504519                           # 005045cf
    # block 0x005045d5: entered by fall-through of jne at 0x005045cf, 1 instruction(s), ends with forward jump to 0x005046a8
    jmp.d32 L_005046a8                           # 005045d5
L_005045da:
    # block 0x005045da: entered by jle at 0x005044ec, 2 instruction(s), ends with jle to 0x005046a8 (forward)
    cmp esi, 0x1                                 # 005045da
    jle.d32 L_005046a8                           # 005045dd
    # block 0x005045e3: entered by fall-through of jle at 0x005045dd, 9 instruction(s), falls into the block at 0x00504606
    mov ecx, dword ptr [esp + stk_70]            # 005045e3
    mov esi, dword ptr [esp + stk_68]            # 005045e7
    lea ebp, [4*edx]                             # 005045eb
    lea ecx, [ecx + 4*eax - field_minus_4]       # 005045f2
    mov eax, dword ptr [esp + stk_60]            # 005045f6
    lea edi, [eax - field_minus_4]               # 005045fa
    mov eax, dword ptr [esp + stk_50]            # 005045fd
    dec eax                                      # 00504601
    mov dword ptr [esp + stk_20], eax            # 00504602
L_00504606:
    # block 0x00504606: entered by jne at 0x005046a2, 10 instruction(s), ends with jle to 0x00504699 (forward)
    mov eax, dword ptr [esp + stk_4c]            # 00504606
    {load} add ecx, ebp                          # 0050460a
    shl eax, 0x2                                 # 0050460c
    {load} add esi, eax                          # 0050460f
    {load} add edi, eax                          # 00504611
    cmp edx, 0x2                                 # 00504613
    mov dword ptr [esp + stk_2c], ecx            # 00504616
    mov dword ptr [esp + stk_1c], esi            # 0050461a
    mov dword ptr [esp + stk_28], edi            # 0050461e
    jle.d8 L_00504699                            # 00504622
    # block 0x00504624: entered by fall-through of jle at 0x00504622, 4 instruction(s), falls into the block at 0x0050462f
    {load} mov eax, edi                          # 00504624
    lea edi, [edx - field_minus_1]               # 00504626
    shr edi                                      # 00504629
    mov dword ptr [esp + stk_70], edi            # 0050462b
L_0050462f:
    # block 0x0050462f: entered by jne at 0x0050468b, 8 instruction(s), ends with jle to 0x00504682 (forward)
    mov edi, dword ptr [esp + stk_54]            # 0050462f
    add ecx, 0x8                                 # 00504633
    add esi, 0x8                                 # 00504636
    add eax, 0x8                                 # 00504639
    test edi, edi                                # 0050463c
    mov dword ptr [esp + stk_30], esi            # 0050463e
    mov dword ptr [esp + stk_3c], eax            # 00504642
    jle.d8 L_00504682                            # 00504646
    # block 0x00504648: entered by fall-through of jle at 0x00504646, 4 instruction(s), falls into the block at 0x00504656
    mov edi, dword ptr [esp + stk_68]            # 00504648
    mov ebx, dword ptr [esp + stk_60]            # 0050464c
    {load} sub edi, ebx                          # 00504650
    mov ebx, dword ptr [esp + stk_54]            # 00504652
L_00504656:
    # block 0x00504656: entered by jne at 0x00504678, 16 instruction(s), ends with jne to 0x00504656 (backward)
    fld dword ptr [eax]                          # 00504656
    fmul dword ptr [ecx - field_minus_4]         # 00504658
    fld dword ptr [eax + field_4]                # 0050465b
    fmul dword ptr [ecx]                         # 0050465e
    faddp st(1), st                              # 00504660
    fstp dword ptr [eax + edi]                   # 00504662
    fld dword ptr [eax + field_4]                # 00504665
    fmul dword ptr [ecx - field_minus_4]         # 00504668
    fld dword ptr [ecx]                          # 0050466b
    fmul dword ptr [eax]                         # 0050466d
    {load} add eax, ebp                          # 0050466f
    fsubp st(1), st                              # 00504671
    fstp dword ptr [esi]                         # 00504673
    {load} add esi, ebp                          # 00504675
    dec ebx                                      # 00504677
    jne.d8 L_00504656                            # 00504678
    # block 0x0050467a: entered by fall-through of jne at 0x00504678, 2 instruction(s), falls into the block at 0x00504682
    mov eax, dword ptr [esp + stk_3c]            # 0050467a
    mov esi, dword ptr [esp + stk_30]            # 0050467e
L_00504682:
    # block 0x00504682: entered by jle at 0x00504646, 4 instruction(s), ends with jne to 0x0050462f (backward)
    mov edi, dword ptr [esp + stk_70]            # 00504682
    dec edi                                      # 00504686
    mov dword ptr [esp + stk_70], edi            # 00504687
    jne.d8 L_0050462f                            # 0050468b
    # block 0x0050468d: entered by fall-through of jne at 0x0050468b, 3 instruction(s), falls into the block at 0x00504699
    mov ecx, dword ptr [esp + stk_2c]            # 0050468d
    mov edi, dword ptr [esp + stk_28]            # 00504691
    mov esi, dword ptr [esp + stk_1c]            # 00504695
L_00504699:
    # block 0x00504699: entered by jle at 0x00504622, 4 instruction(s), ends with jne to 0x00504606 (backward)
    mov eax, dword ptr [esp + stk_20]            # 00504699
    dec eax                                      # 0050469d
    mov dword ptr [esp + stk_20], eax            # 0050469e
    jne.d32 L_00504606                           # 005046a2
L_005046a8:
    # block 0x005046a8: entered by jle at 0x005044f5; jmp at 0x005045d5; jle at 0x005045dd; fall-through of jne at 0x005046a2, 8 instruction(s), ends with jge to 0x005047c4 (forward)
    mov ebp, dword ptr [esp + stk_4c]            # 005046a8
    mov ecx, dword ptr [esp + stk_54]            # 005046ac
    mov eax, dword ptr [esp + stk_24]            # 005046b0
    imul ebp, dword ptr [esp + stk_50]           # 005046b4
    {load} xor ebx, ebx                          # 005046b9
    {load} cmp eax, ecx                          # 005046bb
    mov eax, dword ptr [esp + stk_10]            # 005046bd
    jge.d32 L_005047c4                           # 005046c1
    # block 0x005046c7: entered by fall-through of jge at 0x005046c1, 2 instruction(s), ends with jle to 0x005048d0 (forward)
    cmp eax, 0x1                                 # 005046c7
    jle.d32 L_005048d0                           # 005046ca
    # block 0x005046d0: entered by fall-through of jle at 0x005046ca, 2 instruction(s), falls into the block at 0x005046d5
    dec eax                                      # 005046d0
    mov dword ptr [esp + stk_30], eax            # 005046d1
L_005046d5:
    # block 0x005046d5: entered by jne at 0x005047b9, 7 instruction(s), ends with jle to 0x005047b0 (forward)
    mov eax, dword ptr [esp + stk_4c]            # 005046d5
    {load} add ebx, eax                          # 005046d9
    {load} sub ebp, eax                          # 005046db
    cmp edx, 0x2                                 # 005046dd
    mov dword ptr [esp + stk_1c], ebx            # 005046e0
    mov dword ptr [esp + stk_70], ebp            # 005046e4
    jle.d32 L_005047b0                           # 005046e8
    # block 0x005046ee: entered by fall-through of jle at 0x005046e8, 7 instruction(s), falls into the block at 0x0050470b
    lea eax, [edx - field_minus_1]               # 005046ee
    {load} sub ebp, ebx                          # 005046f1
    shr eax                                      # 005046f3
    lea edi, [4*ebx]                             # 005046f5
    lea esi, [4*edx]                             # 005046fc
    mov dword ptr [esp + stk_40], ebp            # 00504703
    mov dword ptr [esp + stk_2c], eax            # 00504707
L_0050470b:
    # block 0x0050470b: entered by jne at 0x005047a2, 10 instruction(s), ends with jle to 0x00504799 (forward)
    add ebx, 0x2                                 # 0050470b
    add edi, 0x8                                 # 0050470e
    {load} mov ecx, ebx                          # 00504711
    {load} mov eax, edi                          # 00504713
    {load} sub ecx, edx                          # 00504715
    {load} sub eax, esi                          # 00504717
    cmp dword ptr [esp + stk_54], 0x0            # 00504719
    mov dword ptr [esp + stk_14], ebx            # 0050471e
    mov dword ptr [esp + stk_3c], edi            # 00504722
    jle.d8 L_00504799                            # 00504726
    # block 0x00504728: entered by fall-through of jle at 0x00504726, 12 instruction(s), falls into the block at 0x00504751
    mov edi, dword ptr [esp + stk_60]            # 00504728
    {load} add ecx, ebp                          # 0050472c
    shl ecx, 0x2                                 # 0050472e
    lea ebx, [eax + edi]                         # 00504731
    lea ebp, [ecx + edi]                         # 00504734
    mov dword ptr [esp + stk_20], ebp            # 00504737
    mov ebp, dword ptr [esp + stk_68]            # 0050473b
    {load} sub edi, ebp                          # 0050473f
    lea eax, [eax + ebp - field_minus_4]         # 00504741
    lea ecx, [ecx + ebp - field_minus_4]         # 00504745
    mov ebp, dword ptr [esp + stk_54]            # 00504749
    mov dword ptr [esp + stk_28], ebp            # 0050474d
L_00504751:
    # block 0x00504751: entered by jne at 0x0050478b, 22 instruction(s), ends with jne to 0x00504751 (backward)
    fld dword ptr [eax + esi]                    # 00504751
    fadd dword ptr [ecx + esi]                   # 00504754
    {load} add eax, esi                          # 00504757
    {load} add ecx, esi                          # 00504759
    mov ebp, dword ptr [esp + stk_20]            # 0050475b
    {load} add ebx, esi                          # 0050475f
    {load} add ebp, esi                          # 00504761
    fstp dword ptr [edi + eax]                   # 00504763
    fld dword ptr [eax + field_4]                # 00504766
    fsub dword ptr [ecx + field_4]               # 00504769
    mov dword ptr [esp + stk_20], ebp            # 0050476c
    fstp dword ptr [ecx + edi]                   # 00504770
    fld dword ptr [ecx + field_4]                # 00504773
    fadd dword ptr [eax + field_4]               # 00504776
    fstp dword ptr [ebx]                         # 00504779
    fld dword ptr [ecx]                          # 0050477b
    fsub dword ptr [eax]                         # 0050477d
    {disp8} fstp dword ptr [ebp]                 # 0050477f
    mov ebp, dword ptr [esp + stk_28]            # 00504782
    dec ebp                                      # 00504786
    mov dword ptr [esp + stk_28], ebp            # 00504787
    jne.d8 L_00504751                            # 0050478b
    # block 0x0050478d: entered by fall-through of jne at 0x0050478b, 3 instruction(s), falls into the block at 0x00504799
    mov edi, dword ptr [esp + stk_3c]            # 0050478d
    mov ebp, dword ptr [esp + stk_40]            # 00504791
    mov ebx, dword ptr [esp + stk_14]            # 00504795
L_00504799:
    # block 0x00504799: entered by jle at 0x00504726, 4 instruction(s), ends with jne to 0x0050470b (backward)
    mov eax, dword ptr [esp + stk_2c]            # 00504799
    dec eax                                      # 0050479d
    mov dword ptr [esp + stk_2c], eax            # 0050479e
    jne.d32 L_0050470b                           # 005047a2
    # block 0x005047a8: entered by fall-through of jne at 0x005047a2, 2 instruction(s), falls into the block at 0x005047b0
    mov ebx, dword ptr [esp + stk_1c]            # 005047a8
    mov ebp, dword ptr [esp + stk_70]            # 005047ac
L_005047b0:
    # block 0x005047b0: entered by jle at 0x005046e8, 4 instruction(s), ends with jne to 0x005046d5 (backward)
    mov eax, dword ptr [esp + stk_30]            # 005047b0
    dec eax                                      # 005047b4
    mov dword ptr [esp + stk_30], eax            # 005047b5
    jne.d32 L_005046d5                           # 005047b9
    # block 0x005047bf: entered by fall-through of jne at 0x005047b9, 1 instruction(s), ends with forward jump to 0x005048d0
    jmp.d32 L_005048d0                           # 005047bf
L_005047c4:
    # block 0x005047c4: entered by jge at 0x005046c1, 2 instruction(s), ends with jle to 0x005048d0 (forward)
    cmp eax, 0x1                                 # 005047c4
    jle.d32 L_005048d0                           # 005047c7
    # block 0x005047cd: entered by fall-through of jle at 0x005047c7, 9 instruction(s), falls into the block at 0x005047ea
    mov eax, dword ptr [esp + stk_60]            # 005047cd
    {load} mov ebx, eax                          # 005047d1
    lea edi, [eax + 4*ebp]                       # 005047d3
    mov eax, dword ptr [esp + stk_68]            # 005047d6
    lea ecx, [eax + 4*ebp - field_minus_4]       # 005047da
    lea esi, [eax - field_minus_4]               # 005047de
    mov eax, dword ptr [esp + stk_10]            # 005047e1
    dec eax                                      # 005047e5
    mov dword ptr [esp + stk_1c], eax            # 005047e6
L_005047ea:
    # block 0x005047ea: entered by jne at 0x005048ca, 13 instruction(s), ends with jle to 0x005048c1 (forward)
    mov eax, dword ptr [esp + stk_4c]            # 005047ea
    shl eax, 0x2                                 # 005047ee
    {load} add ebx, eax                          # 005047f1
    {load} add esi, eax                          # 005047f3
    {load} sub edi, eax                          # 005047f5
    {load} sub ecx, eax                          # 005047f7
    mov eax, dword ptr [esp + stk_54]            # 005047f9
    mov dword ptr [esp + stk_40], ebx            # 005047fd
    test eax, eax                                # 00504801
    mov dword ptr [esp + stk_14], esi            # 00504803
    mov dword ptr [esp + stk_44], edi            # 00504807
    mov dword ptr [esp + stk_3c], ecx            # 0050480b
    jle.d32 L_005048c1                           # 0050480f
    # block 0x00504815: entered by fall-through of jle at 0x0050480f, 6 instruction(s), falls into the block at 0x0050482b
    {load} mov ebp, edi                          # 00504815
    mov dword ptr [esp + stk_30], ebx            # 00504817
    mov dword ptr [esp + stk_70], esi            # 0050481b
    mov dword ptr [esp + stk_2c], ebp            # 0050481f
    mov dword ptr [esp + stk_28], ecx            # 00504823
    mov dword ptr [esp + stk_20], eax            # 00504827
L_0050482b:
    # block 0x0050482b: entered by jne at 0x005048ab, 2 instruction(s), ends with jle to 0x00504873 (forward)
    cmp edx, 0x2                                 # 0050482b
    jle.d8 L_00504873                            # 0050482e
    # block 0x00504830: entered by fall-through of jle at 0x0050482e, 6 instruction(s), falls into the block at 0x00504843
    mov esi, dword ptr [esp + stk_60]            # 00504830
    mov edi, dword ptr [esp + stk_68]            # 00504834
    mov eax, dword ptr [esp + stk_70]            # 00504838
    {load} sub esi, edi                          # 0050483c
    lea edi, [edx - field_minus_1]               # 0050483e
    shr edi                                      # 00504841
L_00504843:
    # block 0x00504843: entered by jne at 0x00504871, 18 instruction(s), ends with jne to 0x00504843 (backward)
    fld dword ptr [ecx + field_8]                # 00504843
    fadd dword ptr [eax + field_8]               # 00504846
    add ecx, 0x8                                 # 00504849
    add eax, 0x8                                 # 0050484c
    add ebx, 0x8                                 # 0050484f
    add ebp, 0x8                                 # 00504852
    dec edi                                      # 00504855
    fstp dword ptr [esi + eax]                   # 00504856
    fld dword ptr [eax + field_4]                # 00504859
    fsub dword ptr [ecx + field_4]               # 0050485c
    fstp dword ptr [ecx + esi]                   # 0050485f
    fld dword ptr [ecx + field_4]                # 00504862
    fadd dword ptr [eax + field_4]               # 00504865
    fstp dword ptr [ebx]                         # 00504868
    fld dword ptr [ecx]                          # 0050486a
    fsub dword ptr [eax]                         # 0050486c
    {disp8} fstp dword ptr [ebp]                 # 0050486e
    jne.d8 L_00504843                            # 00504871
L_00504873:
    # block 0x00504873: entered by jle at 0x0050482e; fall-through of jne at 0x00504871, 17 instruction(s), ends with jne to 0x0050482b (backward)
    mov ebp, dword ptr [esp + stk_70]            # 00504873
    mov ebx, dword ptr [esp + stk_30]            # 00504877
    mov ecx, dword ptr [esp + stk_28]            # 0050487b
    lea eax, [4*edx]                             # 0050487f
    {load} add ebp, eax                          # 00504886
    {load} add ebx, eax                          # 00504888
    mov dword ptr [esp + stk_70], ebp            # 0050488a
    mov ebp, dword ptr [esp + stk_2c]            # 0050488e
    {load} add ebp, eax                          # 00504892
    {load} add ecx, eax                          # 00504894
    mov eax, dword ptr [esp + stk_20]            # 00504896
    mov dword ptr [esp + stk_30], ebx            # 0050489a
    dec eax                                      # 0050489e
    mov dword ptr [esp + stk_2c], ebp            # 0050489f
    mov dword ptr [esp + stk_28], ecx            # 005048a3
    mov dword ptr [esp + stk_20], eax            # 005048a7
    jne.d32 L_0050482b                           # 005048ab
    # block 0x005048b1: entered by fall-through of jne at 0x005048ab, 4 instruction(s), falls into the block at 0x005048c1
    mov ebx, dword ptr [esp + stk_40]            # 005048b1
    mov ecx, dword ptr [esp + stk_3c]            # 005048b5
    mov esi, dword ptr [esp + stk_14]            # 005048b9
    mov edi, dword ptr [esp + stk_44]            # 005048bd
L_005048c1:
    # block 0x005048c1: entered by jle at 0x0050480f, 4 instruction(s), ends with jne to 0x005047ea (backward)
    mov eax, dword ptr [esp + stk_1c]            # 005048c1
    dec eax                                      # 005048c5
    mov dword ptr [esp + stk_1c], eax            # 005048c6
    jne.d32 L_005047ea                           # 005048ca
L_005048d0:
    # block 0x005048d0: entered by je at 0x00504460; jle at 0x005046ca; jmp at 0x005047bf; jle at 0x005047c7; more, 3 instruction(s), ends with jle to 0x005048ef (forward)
    mov ebp, dword ptr [esp + stk_58]            # 005048d0
    test ebp, ebp                                # 005048d4
    jle.d8 L_005048ef                            # 005048d6
    # block 0x005048d8: entered by fall-through of jle at 0x005048d6, 4 instruction(s), falls into the block at 0x005048e4
    mov eax, dword ptr [esp + stk_64]            # 005048d8
    mov ecx, dword ptr [esp + stk_6c]            # 005048dc
    {load} sub ecx, eax                          # 005048e0
    {load} mov esi, ebp                          # 005048e2
L_005048e4:
    # block 0x005048e4: entered by jne at 0x005048ed, 5 instruction(s), ends with jne to 0x005048e4 (backward)
    mov edi, dword ptr [ecx + eax]               # 005048e4
    mov dword ptr [eax], edi                     # 005048e7
    add eax, 0x4                                 # 005048e9
    dec esi                                      # 005048ec
    jne.d8 L_005048e4                            # 005048ed
L_005048ef:
    # block 0x005048ef: entered by jle at 0x005048d6; fall-through of jne at 0x005048ed, 8 instruction(s), ends with jle to 0x005049aa (forward)
    mov ecx, dword ptr [esp + stk_50]            # 005048ef
    mov ebx, dword ptr [esp + stk_10]            # 005048f3
    imul ecx, ebp                                # 005048f7
    {load} xor edi, edi                          # 005048fa
    cmp ebx, 0x1                                 # 005048fc
    mov dword ptr [esp + stk_40], ecx            # 005048ff
    mov dword ptr [esp + stk_70], ecx            # 00504903
    jle.d32 L_005049aa                           # 00504907
    # block 0x0050490d: entered by fall-through of jle at 0x00504907, 5 instruction(s), ends with forward jump to 0x0050491e
    mov esi, dword ptr [esp + stk_4c]            # 0050490d
    {load} xor ecx, ecx                          # 00504911
    dec ebx                                      # 00504913
    mov dword ptr [esp + stk_2c], ebx            # 00504914
    jmp.d8 L_0050491e                            # 00504918
L_0050491a:
    # block 0x0050491a: entered by jne at 0x0050499c, 1 instruction(s), falls into the block at 0x0050491e
    mov ecx, dword ptr [esp + stk_44]            # 0050491a
L_0050491e:
    # block 0x0050491e: entered by jmp at 0x00504918, 14 instruction(s), ends with jle to 0x00504993 (forward)
    lea eax, [4*esi]                             # 0050491e
    {load} add edi, esi                          # 00504925
    {load} add ecx, eax                          # 00504927
    mov eax, dword ptr [esp + stk_70]            # 00504929
    {load} sub eax, esi                          # 0050492d
    lea ebx, [4*edx]                             # 0050492f
    mov dword ptr [esp + stk_44], ecx            # 00504936
    mov dword ptr [esp + stk_70], eax            # 0050493a
    {load} mov eax, edi                          # 0050493e
    {load} sub ecx, ebx                          # 00504940
    mov ebx, dword ptr [esp + stk_54]            # 00504942
    {load} sub eax, edx                          # 00504946
    test ebx, ebx                                # 00504948
    jle.d8 L_00504993                            # 0050494a
    # block 0x0050494c: entered by fall-through of jle at 0x0050494a, 10 instruction(s), falls into the block at 0x0050496b
    mov esi, dword ptr [esp + stk_70]            # 0050494c
    mov ebx, dword ptr [esp + stk_68]            # 00504950
    {load} sub eax, edi                          # 00504954
    {load} add ecx, ebx                          # 00504956
    {load} add eax, esi                          # 00504958
    mov esi, dword ptr [esp + stk_60]            # 0050495a
    {load} sub esi, ebx                          # 0050495e
    lea eax, [ebx + 4*eax]                       # 00504960
    mov ebx, dword ptr [esp + stk_54]            # 00504963
    mov dword ptr [esp + stk_30], ebx            # 00504967
L_0050496b:
    # block 0x0050496b: entered by jne at 0x0050498d, 13 instruction(s), ends with jne to 0x0050496b (backward)
    lea ebx, [4*edx]                             # 0050496b
    {load} add eax, ebx                          # 00504972
    {load} add ecx, ebx                          # 00504974
    mov ebx, dword ptr [esp + stk_30]            # 00504976
    fld dword ptr [eax]                          # 0050497a
    fadd dword ptr [ecx]                         # 0050497c
    dec ebx                                      # 0050497e
    mov dword ptr [esp + stk_30], ebx            # 0050497f
    fstp dword ptr [ecx + esi]                   # 00504983
    fld dword ptr [eax]                          # 00504986
    fsub dword ptr [ecx]                         # 00504988
    fstp dword ptr [eax + esi]                   # 0050498a
    jne.d8 L_0050496b                            # 0050498d
    # block 0x0050498f: entered by fall-through of jne at 0x0050498d, 1 instruction(s), falls into the block at 0x00504993
    mov esi, dword ptr [esp + stk_4c]            # 0050498f
L_00504993:
    # block 0x00504993: entered by jle at 0x0050494a, 4 instruction(s), ends with jne to 0x0050491a (backward)
    mov eax, dword ptr [esp + stk_2c]            # 00504993
    dec eax                                      # 00504997
    mov dword ptr [esp + stk_2c], eax            # 00504998
    jne.d32 L_0050491a                           # 0050499c
    # block 0x005049a2: entered by fall-through of jne at 0x0050499c, 2 instruction(s), falls into the block at 0x005049aa
    mov ecx, dword ptr [esp + stk_40]            # 005049a2
    mov ebx, dword ptr [esp + stk_10]            # 005049a6
L_005049aa:
    # block 0x005049aa: entered by jle at 0x00504907, 8 instruction(s), ends with jle to 0x00504b33 (forward)
    mov eax, dword ptr [esp + stk_50]            # 005049aa
    mov dword ptr [esp + stk_60], 0x3f800000     # 005049ae
    dec eax                                      # 005049b6
    imul eax, ebp                                # 005049b7
    fld dword ptr [0x52db78]                     # 005049ba
    cmp ebx, 0x1                                 # 005049c0
    mov dword ptr [esp + stk_30], eax            # 005049c3
    jle.d32 L_00504b33                           # 005049c7
    # block 0x005049cd: entered by fall-through of jle at 0x005049c7, 7 instruction(s), falls into the block at 0x005049e5
    mov eax, dword ptr [esp + stk_6c]            # 005049cd
    dec ebx                                      # 005049d1
    fld dword ptr [esp + stk_60]                 # 005049d2
    lea ecx, [eax + 4*ecx]                       # 005049d6
    mov dword ptr [esp + stk_14], eax            # 005049d9
    mov dword ptr [esp + stk_70], ecx            # 005049dd
    mov dword ptr [esp + stk_3c], ebx            # 005049e1
L_005049e5:
    # block 0x005049e5: entered by jne at 0x00504b2b, 20 instruction(s), ends with jle to 0x00504a68 (forward)
    fld st(0)                                    # 005049e5
    fmul dword ptr [esp + stk_38]                # 005049e7
    fld st(2)                                    # 005049eb
    fmul dword ptr [esp + stk_34]                # 005049ed
    mov edi, dword ptr [esp + stk_14]            # 005049f1
    mov esi, dword ptr [esp + stk_70]            # 005049f5
    lea eax, [4*ebp]                             # 005049f9
    fsubp st(1), st                              # 00504a00
    {load} add edi, eax                          # 00504a02
    {load} sub esi, eax                          # 00504a04
    test ebp, ebp                                # 00504a06
    fstp dword ptr [esp + stk_60]                # 00504a08
    mov dword ptr [esp + stk_14], edi            # 00504a0c
    mov dword ptr [esp + stk_70], esi            # 00504a10
    fmul dword ptr [esp + stk_34]                # 00504a14
    fxch st(1)                                   # 00504a18
    fmul dword ptr [esp + stk_38]                # 00504a1a
    faddp st(1), st                              # 00504a1e
    fld dword ptr [esp + stk_60]                 # 00504a20
    jle.d8 L_00504a68                            # 00504a24
    # block 0x00504a26: entered by fall-through of jle at 0x00504a24, 7 instruction(s), falls into the block at 0x00504a3f
    mov ebx, dword ptr [esp + stk_64]            # 00504a26
    mov ecx, dword ptr [esp + stk_30]            # 00504a2a
    mov edi, dword ptr [esp + stk_70]            # 00504a2e
    mov ebp, dword ptr [esp + stk_58]            # 00504a32
    lea esi, [ebx + 4*ecx]                       # 00504a36
    mov ecx, dword ptr [esp + stk_14]            # 00504a39
    {load} add eax, ebx                          # 00504a3d
L_00504a3f:
    # block 0x00504a3f: entered by jne at 0x00504a62, 14 instruction(s), ends with jne to 0x00504a3f (backward)
    fld dword ptr [esp + stk_60]                 # 00504a3f
    fmul dword ptr [eax]                         # 00504a43
    add eax, 0x4                                 # 00504a45
    add ecx, 0x4                                 # 00504a48
    add esi, 0x4                                 # 00504a4b
    add edi, 0x4                                 # 00504a4e
    fadd dword ptr [ebx]                         # 00504a51
    add ebx, 0x4                                 # 00504a53
    dec ebp                                      # 00504a56
    fstp dword ptr [ecx - field_minus_4]         # 00504a57
    fld st(1)                                    # 00504a5a
    fmul dword ptr [esi - field_minus_4]         # 00504a5c
    fstp dword ptr [edi - field_minus_4]         # 00504a5f
    jne.d8 L_00504a3f                            # 00504a62
    # block 0x00504a64: entered by fall-through of jne at 0x00504a62, 1 instruction(s), falls into the block at 0x00504a68
    mov ebp, dword ptr [esp + stk_58]            # 00504a64
L_00504a68:
    # block 0x00504a68: entered by jle at 0x00504a24, 6 instruction(s), ends with jle to 0x00504b20 (forward)
    mov ecx, dword ptr [esp + stk_10]            # 00504a68
    mov eax, dword ptr [esp + stk_60]            # 00504a6c
    cmp ecx, 0x2                                 # 00504a70
    mov dword ptr [esp + stk_44], eax            # 00504a73
    fld st(1)                                    # 00504a77
    jle.d32 L_00504b20                           # 00504a79
    # block 0x00504a7f: entered by fall-through of jle at 0x00504a79, 9 instruction(s), falls into the block at 0x00504aa0
    mov eax, dword ptr [esp + stk_64]            # 00504a7f
    add ecx, -0x2                                # 00504a83
    fld dword ptr [esp + stk_44]                 # 00504a86
    lea esi, [eax + 4*ebp]                       # 00504a8a
    mov dword ptr [esp + stk_28], ecx            # 00504a8d
    mov dword ptr [esp + stk_20], esi            # 00504a91
    mov esi, dword ptr [esp + stk_30]            # 00504a95
    lea eax, [eax + 4*esi]                       # 00504a99
    mov dword ptr [esp + stk_1c], eax            # 00504a9c
L_00504aa0:
    # block 0x00504aa0: entered by jne at 0x00504b1c, 21 instruction(s), ends with jle to 0x00504b13 (forward)
    fld st(0)                                    # 00504aa0
    fmul dword ptr [esp + stk_60]                # 00504aa2
    fld st(2)                                    # 00504aa6
    fmul st, st(5)                               # 00504aa8
    mov esi, dword ptr [esp + stk_20]            # 00504aaa
    mov ecx, dword ptr [esp + stk_1c]            # 00504aae
    lea eax, [4*ebp]                             # 00504ab2
    fsubp st(1), st                              # 00504ab9
    {load} add esi, eax                          # 00504abb
    {load} sub ecx, eax                          # 00504abd
    test ebp, ebp                                # 00504abf
    fstp dword ptr [esp + stk_2c]                # 00504ac1
    fxch st(1)                                   # 00504ac5
    fmul dword ptr [esp + stk_60]                # 00504ac7
    fxch st(1)                                   # 00504acb
    fmul st, st(3)                               # 00504acd
    mov dword ptr [esp + stk_20], esi            # 00504acf
    mov dword ptr [esp + stk_1c], ecx            # 00504ad3
    faddp st(1), st                              # 00504ad7
    fld dword ptr [esp + stk_2c]                 # 00504ad9
    jle.d8 L_00504b13                            # 00504add
    # block 0x00504adf: entered by fall-through of jle at 0x00504add, 4 instruction(s), falls into the block at 0x00504aed
    mov ecx, dword ptr [esp + stk_70]            # 00504adf
    mov edi, dword ptr [esp + stk_1c]            # 00504ae3
    mov eax, dword ptr [esp + stk_14]            # 00504ae7
    {load} mov ebx, ebp                          # 00504aeb
L_00504aed:
    # block 0x00504aed: entered by jne at 0x00504b11, 14 instruction(s), ends with jne to 0x00504aed (backward)
    fld dword ptr [esp + stk_2c]                 # 00504aed
    fmul dword ptr [esi]                         # 00504af1
    add esi, 0x4                                 # 00504af3
    add eax, 0x4                                 # 00504af6
    add edi, 0x4                                 # 00504af9
    add ecx, 0x4                                 # 00504afc
    fadd dword ptr [eax - field_minus_4]         # 00504aff
    dec ebx                                      # 00504b02
    fstp dword ptr [eax - field_minus_4]         # 00504b03
    fld st(1)                                    # 00504b06
    fmul dword ptr [edi - field_minus_4]         # 00504b08
    fadd dword ptr [ecx - field_minus_4]         # 00504b0b
    fstp dword ptr [ecx - field_minus_4]         # 00504b0e
    jne.d8 L_00504aed                            # 00504b11
L_00504b13:
    # block 0x00504b13: entered by jle at 0x00504add; fall-through of jne at 0x00504b11, 4 instruction(s), ends with jne to 0x00504aa0 (backward)
    mov eax, dword ptr [esp + stk_28]            # 00504b13
    dec eax                                      # 00504b17
    mov dword ptr [esp + stk_28], eax            # 00504b18
    jne.d8 L_00504aa0                            # 00504b1c
    # block 0x00504b1e: entered by fall-through of jne at 0x00504b1c, 1 instruction(s), falls into the block at 0x00504b20
    fstp st(0)                                   # 00504b1e
L_00504b20:
    # block 0x00504b20: entered by jle at 0x00504a79, 5 instruction(s), ends with jne to 0x005049e5 (backward)
    mov eax, dword ptr [esp + stk_3c]            # 00504b20
    dec eax                                      # 00504b24
    fstp st(0)                                   # 00504b25
    mov dword ptr [esp + stk_3c], eax            # 00504b27
    jne.d32 L_005049e5                           # 00504b2b
    # block 0x00504b31: entered by fall-through of jne at 0x00504b2b, 1 instruction(s), falls into the block at 0x00504b33
    fstp st(0)                                   # 00504b31
L_00504b33:
    # block 0x00504b33: entered by jle at 0x005049c7, 4 instruction(s), ends with jle to 0x00504b77 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00504b33
    cmp eax, 0x1                                 # 00504b37
    fstp st(0)                                   # 00504b3a
    jle.d8 L_00504b77                            # 00504b3c
    # block 0x00504b3e: entered by fall-through of jle at 0x00504b3c, 4 instruction(s), falls into the block at 0x00504b4e
    mov edi, dword ptr [esp + stk_64]            # 00504b3e
    dec eax                                      # 00504b42
    lea ebx, [4*ebp]                             # 00504b43
    mov dword ptr [esp + stk_60], eax            # 00504b4a
L_00504b4e:
    # block 0x00504b4e: entered by jne at 0x00504b75, 3 instruction(s), ends with jle to 0x00504b6c (forward)
    {load} add edi, ebx                          # 00504b4e
    test ebp, ebp                                # 00504b50
    jle.d8 L_00504b6c                            # 00504b52
    # block 0x00504b54: entered by fall-through of jle at 0x00504b52, 3 instruction(s), falls into the block at 0x00504b5c
    mov eax, dword ptr [esp + stk_6c]            # 00504b54
    {load} mov ecx, edi                          # 00504b58
    {load} mov esi, ebp                          # 00504b5a
L_00504b5c:
    # block 0x00504b5c: entered by jne at 0x00504b6a, 7 instruction(s), ends with jne to 0x00504b5c (backward)
    fld dword ptr [ecx]                          # 00504b5c
    fadd dword ptr [eax]                         # 00504b5e
    add ecx, 0x4                                 # 00504b60
    add eax, 0x4                                 # 00504b63
    dec esi                                      # 00504b66
    fstp dword ptr [eax - field_minus_4]         # 00504b67
    jne.d8 L_00504b5c                            # 00504b6a
L_00504b6c:
    # block 0x00504b6c: entered by jle at 0x00504b52; fall-through of jne at 0x00504b6a, 4 instruction(s), ends with jne to 0x00504b4e (backward)
    mov eax, dword ptr [esp + stk_60]            # 00504b6c
    dec eax                                      # 00504b70
    mov dword ptr [esp + stk_60], eax            # 00504b71
    jne.d8 L_00504b4e                            # 00504b75
L_00504b77:
    # block 0x00504b77: entered by jle at 0x00504b3c; fall-through of jne at 0x00504b75, 4 instruction(s), ends with jge to 0x00504bd6 (forward)
    mov ebx, dword ptr [esp + stk_54]            # 00504b77
    mov edi, dword ptr [esp + stk_5c]            # 00504b7b
    {load} cmp edx, ebx                          # 00504b7f
    jge.d8 L_00504bd6                            # 00504b81
    # block 0x00504b83: entered by fall-through of jge at 0x00504b81, 2 instruction(s), ends with jle to 0x00504c3c (forward)
    test edx, edx                                # 00504b83
    jle.d32 L_00504c3c                           # 00504b85
    # block 0x00504b8b: entered by fall-through of jle at 0x00504b85, 5 instruction(s), falls into the block at 0x00504b9b
    mov esi, dword ptr [esp + stk_68]            # 00504b8b
    {load} mov ecx, edi                          # 00504b8f
    {load} sub ecx, esi                          # 00504b91
    mov dword ptr [esp + stk_60], edx            # 00504b93
    mov dword ptr [esp + stk_64], ecx            # 00504b97
L_00504b9b:
    # block 0x00504b9b: entered by jne at 0x00504bd2, 2 instruction(s), ends with jle to 0x00504bc6 (forward)
    test ebx, ebx                                # 00504b9b
    jle.d8 L_00504bc6                            # 00504b9d
    # block 0x00504b9f: entered by fall-through of jle at 0x00504b9d, 3 instruction(s), falls into the block at 0x00504ba5
    {load} add ecx, esi                          # 00504b9f
    {load} mov eax, esi                          # 00504ba1
    {load} mov ebp, ebx                          # 00504ba3
L_00504ba5:
    # block 0x00504ba5: entered by jne at 0x00504bbc, 9 instruction(s), ends with jne to 0x00504ba5 (backward)
    mov edi, dword ptr [eax]                     # 00504ba5
    mov dword ptr [ecx], edi                     # 00504ba7
    lea edi, [4*edx]                             # 00504ba9
    {load} add eax, edi                          # 00504bb0
    mov edi, dword ptr [esp + stk_18]            # 00504bb2
    shl edi, 0x2                                 # 00504bb6
    {load} add ecx, edi                          # 00504bb9
    dec ebp                                      # 00504bbb
    jne.d8 L_00504ba5                            # 00504bbc
    # block 0x00504bbe: entered by fall-through of jne at 0x00504bbc, 2 instruction(s), falls into the block at 0x00504bc6
    mov ecx, dword ptr [esp + stk_64]            # 00504bbe
    mov edi, dword ptr [esp + stk_5c]            # 00504bc2
L_00504bc6:
    # block 0x00504bc6: entered by jle at 0x00504b9d, 5 instruction(s), ends with jne to 0x00504b9b (backward)
    mov eax, dword ptr [esp + stk_60]            # 00504bc6
    add esi, 0x4                                 # 00504bca
    dec eax                                      # 00504bcd
    mov dword ptr [esp + stk_60], eax            # 00504bce
    jne.d8 L_00504b9b                            # 00504bd2
    # block 0x00504bd4: entered by fall-through of jne at 0x00504bd2, 1 instruction(s), ends with forward jump to 0x00504c3c
    jmp.d8 L_00504c3c                            # 00504bd4
L_00504bd6:
    # block 0x00504bd6: entered by jge at 0x00504b81, 2 instruction(s), ends with jle to 0x00504c3c (forward)
    test ebx, ebx                                # 00504bd6
    jle.d8 L_00504c3c                            # 00504bd8
    # block 0x00504bda: entered by fall-through of jle at 0x00504bd8, 8 instruction(s), falls into the block at 0x00504bfb
    mov ecx, dword ptr [esp + stk_18]            # 00504bda
    mov dword ptr [esp + stk_58], ebx            # 00504bde
    lea eax, [4*ecx]                             # 00504be2
    mov ecx, dword ptr [esp + stk_68]            # 00504be9
    mov dword ptr [esp + stk_60], ecx            # 00504bed
    {load} mov ecx, edi                          # 00504bf1
    mov dword ptr [esp + stk_6c], eax            # 00504bf3
    mov dword ptr [esp + stk_64], ecx            # 00504bf7
L_00504bfb:
    # block 0x00504bfb: entered by jne at 0x00504c3a, 2 instruction(s), ends with jle to 0x00504c12 (forward)
    test edx, edx                                # 00504bfb
    jle.d8 L_00504c12                            # 00504bfd
    # block 0x00504bff: entered by fall-through of jle at 0x00504bfd, 2 instruction(s), falls into the block at 0x00504c05
    mov eax, dword ptr [esp + stk_60]            # 00504bff
    {load} mov esi, edx                          # 00504c03
L_00504c05:
    # block 0x00504c05: entered by jne at 0x00504c10, 6 instruction(s), ends with jne to 0x00504c05 (backward)
    mov ebp, dword ptr [eax]                     # 00504c05
    add eax, 0x4                                 # 00504c07
    mov dword ptr [ecx], ebp                     # 00504c0a
    add ecx, 0x4                                 # 00504c0c
    dec esi                                      # 00504c0f
    jne.d8 L_00504c05                            # 00504c10
L_00504c12:
    # block 0x00504c12: entered by jle at 0x00504bfd; fall-through of jne at 0x00504c10, 12 instruction(s), ends with jne to 0x00504bfb (backward)
    mov ebp, dword ptr [esp + stk_60]            # 00504c12
    mov ecx, dword ptr [esp + stk_64]            # 00504c16
    mov esi, dword ptr [esp + stk_6c]            # 00504c1a
    lea eax, [4*edx]                             # 00504c1e
    {load} add ebp, eax                          # 00504c25
    mov eax, dword ptr [esp + stk_58]            # 00504c27
    {load} add ecx, esi                          # 00504c2b
    dec eax                                      # 00504c2d
    mov dword ptr [esp + stk_60], ebp            # 00504c2e
    mov dword ptr [esp + stk_64], ecx            # 00504c32
    mov dword ptr [esp + stk_58], eax            # 00504c36
    jne.d8 L_00504bfb                            # 00504c3a
L_00504c3c:
    # block 0x00504c3c: entered by jle at 0x00504b85; jmp at 0x00504bd4; jle at 0x00504bd8; fall-through of jne at 0x00504c3a, 8 instruction(s), ends with jle to 0x00504ce4 (forward)
    mov ebp, dword ptr [esp + stk_4c]            # 00504c3c
    mov esi, dword ptr [esp + stk_10]            # 00504c40
    {load} mov eax, ebp                          # 00504c44
    lea ecx, [edx + edx]                         # 00504c46
    imul eax, dword ptr [esp + stk_50]           # 00504c49
    cmp esi, 0x1                                 # 00504c4e
    mov dword ptr [esp + stk_44], eax            # 00504c51
    jle.d32 L_00504ce4                           # 00504c55
    # block 0x00504c5b: entered by fall-through of jle at 0x00504c55, 8 instruction(s), falls into the block at 0x00504c74
    shl ecx, 0x2                                 # 00504c5b
    mov dword ptr [esp + stk_64], ecx            # 00504c5e
    mov ecx, dword ptr [esp + stk_68]            # 00504c62
    lea esi, [ecx + 4*eax]                       # 00504c66
    {load} mov eax, edi                          # 00504c69
    mov edi, dword ptr [esp + stk_10]            # 00504c6b
    dec edi                                      # 00504c6f
    mov dword ptr [esp + stk_50], edi            # 00504c70
L_00504c74:
    # block 0x00504c74: entered by jne at 0x00504cda, 10 instruction(s), ends with jle to 0x00504cd1 (forward)
    mov edi, dword ptr [esp + stk_64]            # 00504c74
    {load} add eax, edi                          # 00504c78
    lea edi, [4*ebp]                             # 00504c7a
    {load} add ecx, edi                          # 00504c81
    {load} sub esi, edi                          # 00504c83
    test ebx, ebx                                # 00504c85
    mov dword ptr [esp + stk_58], eax            # 00504c87
    mov dword ptr [esp + stk_6c], ecx            # 00504c8b
    mov dword ptr [esp + stk_70], esi            # 00504c8f
    jle.d8 L_00504cd1                            # 00504c93
    # block 0x00504c95: entered by fall-through of jle at 0x00504c93, 2 instruction(s), falls into the block at 0x00504ca0
    lea edi, [4*edx]                             # 00504c95
    mov dword ptr [esp + stk_60], ebx            # 00504c9c
L_00504ca0:
    # block 0x00504ca0: entered by jne at 0x00504cbf, 13 instruction(s), ends with jne to 0x00504ca0 (backward)
    mov ebp, dword ptr [ecx]                     # 00504ca0
    {load} add ecx, edi                          # 00504ca2
    mov dword ptr [eax - field_minus_4], ebp     # 00504ca4
    mov ebp, dword ptr [esi]                     # 00504ca7
    mov dword ptr [eax], ebp                     # 00504ca9
    mov ebp, dword ptr [esp + stk_18]            # 00504cab
    shl ebp, 0x2                                 # 00504caf
    {load} add eax, ebp                          # 00504cb2
    mov ebp, dword ptr [esp + stk_60]            # 00504cb4
    {load} add esi, edi                          # 00504cb8
    dec ebp                                      # 00504cba
    mov dword ptr [esp + stk_60], ebp            # 00504cbb
    jne.d8 L_00504ca0                            # 00504cbf
    # block 0x00504cc1: entered by fall-through of jne at 0x00504cbf, 4 instruction(s), falls into the block at 0x00504cd1
    mov eax, dword ptr [esp + stk_58]            # 00504cc1
    mov ecx, dword ptr [esp + stk_6c]            # 00504cc5
    mov esi, dword ptr [esp + stk_70]            # 00504cc9
    mov ebp, dword ptr [esp + stk_4c]            # 00504ccd
L_00504cd1:
    # block 0x00504cd1: entered by jle at 0x00504c93, 4 instruction(s), ends with jne to 0x00504c74 (backward)
    mov edi, dword ptr [esp + stk_50]            # 00504cd1
    dec edi                                      # 00504cd5
    mov dword ptr [esp + stk_50], edi            # 00504cd6
    jne.d8 L_00504c74                            # 00504cda
    # block 0x00504cdc: entered by fall-through of jne at 0x00504cda, 2 instruction(s), falls into the block at 0x00504ce4
    mov eax, dword ptr [esp + stk_44]            # 00504cdc
    mov edi, dword ptr [esp + stk_5c]            # 00504ce0
L_00504ce4:
    # block 0x00504ce4: entered by jle at 0x00504c55, 3 instruction(s), ends with je to 0x00504fb8 (forward)
    mov ecx, 0x1                                 # 00504ce4
    {load} cmp edx, ecx                          # 00504ce9
    je.d32 L_00504fb8                            # 00504ceb
    # block 0x00504cf1: entered by fall-through of je at 0x00504ceb, 2 instruction(s), ends with jge to 0x00504e91 (forward)
    cmp dword ptr [esp + stk_24], ebx            # 00504cf1
    jge.d32 L_00504e91                           # 00504cf5
    # block 0x00504cfb: entered by fall-through of jge at 0x00504cf5, 6 instruction(s), ends with jle to 0x00504fb8 (forward)
    mov esi, dword ptr [esp + stk_10]            # 00504cfb
    {load} mov ebx, edx                          # 00504cff
    neg ebx                                      # 00504d01
    {load} cmp esi, ecx                          # 00504d03
    mov dword ptr [esp + stk_14], 0x0            # 00504d05
    jle.d32 L_00504fb8                           # 00504d0d
    # block 0x00504d13: entered by fall-through of jle at 0x00504d0d, 15 instruction(s), ends with forward jump to 0x00504d4b
    mov ecx, dword ptr [esp + stk_4c]            # 00504d13
    {load} xor ebp, ebp                          # 00504d17
    shl eax, 0x2                                 # 00504d19
    mov dword ptr [esp + stk_60], eax            # 00504d1c
    lea eax, [edx + edx]                         # 00504d20
    shl eax, 0x2                                 # 00504d23
    mov dword ptr [esp + stk_44], eax            # 00504d26
    mov eax, dword ptr [esp + stk_10]            # 00504d2a
    lea esi, [4*ecx]                             # 00504d2e
    lea ecx, [ebx + edx - field_minus_2]         # 00504d35
    dec eax                                      # 00504d39
    mov dword ptr [esp + stk_38], esi            # 00504d3a
    lea edi, [edi + 4*ecx]                       # 00504d3e
    mov dword ptr [esp + stk_3c], eax            # 00504d41
    jmp.d8 L_00504d4b                            # 00504d45
L_00504d47:
    # block 0x00504d47: entered by jne at 0x00504e83, 1 instruction(s), falls into the block at 0x00504d4b
    mov ebx, dword ptr [esp + stk_1c]            # 00504d47
L_00504d4b:
    # block 0x00504d4b: entered by jmp at 0x00504d45, 18 instruction(s), ends with jle to 0x00504e7a (forward)
    lea eax, [edx + edx]                         # 00504d4b
    {load} add ebp, esi                          # 00504d4e
    {load} add ebx, eax                          # 00504d50
    {load} add ecx, eax                          # 00504d52
    mov dword ptr [esp + stk_1c], ebx            # 00504d54
    mov ebx, dword ptr [esp + stk_44]            # 00504d58
    {load} add edi, ebx                          # 00504d5c
    mov ebx, dword ptr [esp + stk_14]            # 00504d5e
    {load} add ebx, eax                          # 00504d62
    mov dword ptr [esp + stk_34], ecx            # 00504d64
    mov dword ptr [esp + stk_14], ebx            # 00504d68
    mov ebx, dword ptr [esp + stk_60]            # 00504d6c
    {load} sub ebx, esi                          # 00504d70
    cmp edx, 0x2                                 # 00504d72
    mov dword ptr [esp + stk_30], edi            # 00504d75
    mov dword ptr [esp + stk_40], ebp            # 00504d79
    mov dword ptr [esp + stk_60], ebx            # 00504d7d
    jle.d32 L_00504e7a                           # 00504d81
    # block 0x00504d87: entered by fall-through of jle at 0x00504d81, 8 instruction(s), falls into the block at 0x00504da7
    mov dword ptr [esp + stk_50], ecx            # 00504d87
    lea ecx, [edx - field_minus_1]               # 00504d8b
    lea eax, [ebp + field_8]                     # 00504d8e
    mov dword ptr [esp + stk_64], 0x4            # 00504d91
    shr ecx                                      # 00504d99
    mov dword ptr [esp + stk_6c], eax            # 00504d9b
    mov dword ptr [esp + stk_70], edi            # 00504d9f
    mov dword ptr [esp + stk_4c], ecx            # 00504da3
L_00504da7:
    # block 0x00504da7: entered by jne at 0x00504e68, 3 instruction(s), ends with jle to 0x00504e37 (forward)
    mov ecx, dword ptr [esp + stk_54]            # 00504da7
    test ecx, ecx                                # 00504dab
    jle.d32 L_00504e37                           # 00504dad
    # block 0x00504db3: entered by fall-through of jle at 0x00504dad, 20 instruction(s), falls into the block at 0x00504df7
    mov ecx, dword ptr [esp + stk_18]            # 00504db3
    mov esi, dword ptr [esp + stk_68]            # 00504db7
    lea ebx, [4*ecx]                             # 00504dbb
    lea ecx, [eax + esi]                         # 00504dc2
    {load} sub eax, ebp                          # 00504dc5
    mov ebp, dword ptr [esp + stk_60]            # 00504dc7
    {load} add eax, ebp                          # 00504dcb
    mov ebp, dword ptr [esp + stk_1c]            # 00504dcd
    {load} add eax, esi                          # 00504dd1
    mov esi, dword ptr [esp + stk_50]            # 00504dd3
    {load} sub esi, ebp                          # 00504dd7
    mov ebp, dword ptr [esp + stk_64]            # 00504dd9
    {load} sub esi, edx                          # 00504ddd
    {load} add esi, ebp                          # 00504ddf
    mov ebp, dword ptr [esp + stk_14]            # 00504de1
    {load} add esi, ebp                          # 00504de5
    mov ebp, dword ptr [esp + stk_5c]            # 00504de7
    {disp8} lea esi, [ebp + 4*esi]               # 00504deb
    mov ebp, dword ptr [esp + stk_54]            # 00504def
    mov dword ptr [esp + stk_58], ebp            # 00504df3
L_00504df7:
    # block 0x00504df7: entered by jne at 0x00504e2d, 21 instruction(s), ends with jne to 0x00504df7 (backward)
    fld dword ptr [ecx - field_minus_4]          # 00504df7
    fadd dword ptr [eax - field_minus_4]         # 00504dfa
    lea ebp, [4*edx]                             # 00504dfd
    fstp dword ptr [esi - field_minus_4]         # 00504e04
    fld dword ptr [ecx - field_minus_4]          # 00504e07
    fsub dword ptr [eax - field_minus_4]         # 00504e0a
    fstp dword ptr [edi - field_minus_4]         # 00504e0d
    fld dword ptr [eax]                          # 00504e10
    fadd dword ptr [ecx]                         # 00504e12
    fstp dword ptr [esi]                         # 00504e14
    fld dword ptr [eax]                          # 00504e16
    fsub dword ptr [ecx]                         # 00504e18
    {load} add eax, ebp                          # 00504e1a
    {load} add ecx, ebp                          # 00504e1c
    mov ebp, dword ptr [esp + stk_58]            # 00504e1e
    {load} add esi, ebx                          # 00504e22
    fstp dword ptr [edi]                         # 00504e24
    {load} add edi, ebx                          # 00504e26
    dec ebp                                      # 00504e28
    mov dword ptr [esp + stk_58], ebp            # 00504e29
    jne.d8 L_00504df7                            # 00504e2d
    # block 0x00504e2f: entered by fall-through of jne at 0x00504e2d, 2 instruction(s), falls into the block at 0x00504e37
    mov ebp, dword ptr [esp + stk_40]            # 00504e2f
    mov eax, dword ptr [esp + stk_6c]            # 00504e33
L_00504e37:
    # block 0x00504e37: entered by jle at 0x00504dad, 15 instruction(s), ends with jne to 0x00504da7 (backward)
    mov edi, dword ptr [esp + stk_70]            # 00504e37
    mov ebx, dword ptr [esp + stk_50]            # 00504e3b
    mov esi, dword ptr [esp + stk_64]            # 00504e3f
    mov ecx, dword ptr [esp + stk_4c]            # 00504e43
    add eax, 0x8                                 # 00504e47
    sub edi, 0x8                                 # 00504e4a
    sub ebx, 0x2                                 # 00504e4d
    add esi, 0x4                                 # 00504e50
    dec ecx                                      # 00504e53
    mov dword ptr [esp + stk_6c], eax            # 00504e54
    mov dword ptr [esp + stk_70], edi            # 00504e58
    mov dword ptr [esp + stk_50], ebx            # 00504e5c
    mov dword ptr [esp + stk_64], esi            # 00504e60
    mov dword ptr [esp + stk_4c], ecx            # 00504e64
    jne.d32 L_00504da7                           # 00504e68
    # block 0x00504e6e: entered by fall-through of jne at 0x00504e68, 3 instruction(s), falls into the block at 0x00504e7a
    mov esi, dword ptr [esp + stk_38]            # 00504e6e
    mov ecx, dword ptr [esp + stk_34]            # 00504e72
    mov edi, dword ptr [esp + stk_30]            # 00504e76
L_00504e7a:
    # block 0x00504e7a: entered by jle at 0x00504d81, 4 instruction(s), ends with jne to 0x00504d47 (backward)
    mov eax, dword ptr [esp + stk_3c]            # 00504e7a
    dec eax                                      # 00504e7e
    mov dword ptr [esp + stk_3c], eax            # 00504e7f
    jne.d32 L_00504d47                           # 00504e83
    # block 0x00504e89: entered by fall-through of jne at 0x00504e83, 6 instruction(s), ends with ret
    pop edi                                      # 00504e89
    pop esi                                      # 00504e8a
    pop ebp                                      # 00504e8b
    pop ebx                                      # 00504e8c
    add esp, 0x38                                # 00504e8d
    ret                                          # 00504e90
L_00504e91:
    # block 0x00504e91: entered by jge at 0x00504cf5, 4 instruction(s), ends with jle to 0x00504fb8 (forward)
    {load} mov esi, edx                          # 00504e91
    neg esi                                      # 00504e93
    cmp dword ptr [esp + stk_10], ecx            # 00504e95
    jle.d32 L_00504fb8                           # 00504e99
    # block 0x00504e9f: entered by fall-through of jle at 0x00504e99, 15 instruction(s), falls into the block at 0x00504ed1
    lea ecx, [edx + edx]                         # 00504e9f
    {load} add esi, edx                          # 00504ea2
    shl ecx, 0x2                                 # 00504ea4
    mov dword ptr [esp + stk_5c], ecx            # 00504ea7
    mov ecx, dword ptr [esp + stk_68]            # 00504eab
    shl ebp, 0x2                                 # 00504eaf
    lea eax, [ecx + 4*eax + field_8]             # 00504eb2
    add ecx, 0x8                                 # 00504eb6
    mov dword ptr [esp + stk_68], eax            # 00504eb9
    lea eax, [edi + field_8]                     # 00504ebd
    lea edi, [edi + 4*esi - field_minus_8]       # 00504ec0
    mov esi, dword ptr [esp + stk_10]            # 00504ec4
    dec esi                                      # 00504ec8
    mov dword ptr [esp + stk_70], ebp            # 00504ec9
    mov dword ptr [esp + stk_6c], esi            # 00504ecd
L_00504ed1:
    # block 0x00504ed1: entered by jne at 0x00504fb2, 12 instruction(s), ends with jle to 0x00504fa9 (forward)
    mov esi, dword ptr [esp + stk_5c]            # 00504ed1
    {load} add ecx, ebp                          # 00504ed5
    {load} add edi, esi                          # 00504ed7
    {load} add eax, esi                          # 00504ed9
    mov esi, dword ptr [esp + stk_68]            # 00504edb
    mov dword ptr [esp + stk_44], edi            # 00504edf
    {load} sub esi, ebp                          # 00504ee3
    mov dword ptr [esp + stk_4c], eax            # 00504ee5
    test ebx, ebx                                # 00504ee9
    mov dword ptr [esp + stk_40], ecx            # 00504eeb
    mov dword ptr [esp + stk_68], esi            # 00504eef
    jle.d32 L_00504fa9                           # 00504ef3
    # block 0x00504ef9: entered by fall-through of jle at 0x00504ef3, 6 instruction(s), falls into the block at 0x00504f0d
    mov dword ptr [esp + stk_50], ecx            # 00504ef9
    {load} mov ecx, esi                          # 00504efd
    mov dword ptr [esp + stk_60], edi            # 00504eff
    {load} mov ebp, eax                          # 00504f03
    mov dword ptr [esp + stk_64], ecx            # 00504f05
    mov dword ptr [esp + stk_58], ebx            # 00504f09
L_00504f0d:
    # block 0x00504f0d: entered by jne at 0x00504f8f, 2 instruction(s), ends with jle to 0x00504f58 (forward)
    cmp edx, 0x2                                 # 00504f0d
    jle.d8 L_00504f58                            # 00504f10
    # block 0x00504f12: entered by fall-through of jle at 0x00504f10, 6 instruction(s), falls into the block at 0x00504f25
    mov ecx, dword ptr [esp + stk_50]            # 00504f12
    mov eax, dword ptr [esp + stk_64]            # 00504f16
    mov edi, dword ptr [esp + stk_60]            # 00504f1a
    lea ebx, [edx - field_minus_1]               # 00504f1e
    {load} mov esi, ebp                          # 00504f21
    shr ebx                                      # 00504f23
L_00504f25:
    # block 0x00504f25: entered by jne at 0x00504f56, 18 instruction(s), ends with jne to 0x00504f25 (backward)
    fld dword ptr [ecx - field_minus_4]          # 00504f25
    fadd dword ptr [eax - field_minus_4]         # 00504f28
    add esi, 0x8                                 # 00504f2b
    add eax, 0x8                                 # 00504f2e
    add ecx, 0x8                                 # 00504f31
    sub edi, 0x8                                 # 00504f34
    dec ebx                                      # 00504f37
    fstp dword ptr [esi - field_minus_c]         # 00504f38
    fld dword ptr [ecx - field_minus_c]          # 00504f3b
    fsub dword ptr [eax - field_minus_c]         # 00504f3e
    fstp dword ptr [edi + field_4]               # 00504f41
    fld dword ptr [ecx - field_minus_8]          # 00504f44
    fadd dword ptr [eax - field_minus_8]         # 00504f47
    fstp dword ptr [esi - field_minus_8]         # 00504f4a
    fld dword ptr [eax - field_minus_8]          # 00504f4d
    fsub dword ptr [ecx - field_minus_8]         # 00504f50
    fstp dword ptr [edi + field_8]               # 00504f53
    jne.d8 L_00504f25                            # 00504f56
L_00504f58:
    # block 0x00504f58: entered by jle at 0x00504f10; fall-through of jne at 0x00504f56, 17 instruction(s), ends with jne to 0x00504f0d (backward)
    mov eax, dword ptr [esp + stk_18]            # 00504f58
    mov edi, dword ptr [esp + stk_60]            # 00504f5c
    mov esi, dword ptr [esp + stk_50]            # 00504f60
    mov ecx, dword ptr [esp + stk_64]            # 00504f64
    shl eax, 0x2                                 # 00504f68
    {load} add ebp, eax                          # 00504f6b
    {load} add edi, eax                          # 00504f6d
    lea eax, [4*edx]                             # 00504f6f
    mov dword ptr [esp + stk_60], edi            # 00504f76
    {load} add esi, eax                          # 00504f7a
    {load} add ecx, eax                          # 00504f7c
    mov eax, dword ptr [esp + stk_58]            # 00504f7e
    mov dword ptr [esp + stk_50], esi            # 00504f82
    dec eax                                      # 00504f86
    mov dword ptr [esp + stk_64], ecx            # 00504f87
    mov dword ptr [esp + stk_58], eax            # 00504f8b
    jne.d32 L_00504f0d                           # 00504f8f
    # block 0x00504f95: entered by fall-through of jne at 0x00504f8f, 5 instruction(s), falls into the block at 0x00504fa9
    mov ebx, dword ptr [esp + stk_54]            # 00504f95
    mov ebp, dword ptr [esp + stk_70]            # 00504f99
    mov eax, dword ptr [esp + stk_4c]            # 00504f9d
    mov edi, dword ptr [esp + stk_44]            # 00504fa1
    mov ecx, dword ptr [esp + stk_40]            # 00504fa5
L_00504fa9:
    # block 0x00504fa9: entered by jle at 0x00504ef3, 4 instruction(s), ends with jne to 0x00504ed1 (backward)
    mov esi, dword ptr [esp + stk_6c]            # 00504fa9
    dec esi                                      # 00504fad
    mov dword ptr [esp + stk_6c], esi            # 00504fae
    jne.d32 L_00504ed1                           # 00504fb2
L_00504fb8:
    # block 0x00504fb8: entered by je at 0x00504ceb; jle at 0x00504d0d; jle at 0x00504e99; fall-through of jne at 0x00504fb2, 6 instruction(s), ends with ret
    pop edi                                      # 00504fb8
    pop esi                                      # 00504fb9
    pop ebp                                      # 00504fba
    pop ebx                                      # 00504fbb
    add esp, 0x38                                # 00504fbc
    ret                                          # 00504fbf

