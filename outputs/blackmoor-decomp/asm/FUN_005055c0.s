# FUN_005055c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005055c0
# extent:       0x005055c0-0x00505ac1 (1281 code bytes)
# span:         0x005055c0-0x00505ad0 (code 1281, tables 0, padding 15)
# sha256:       420017ae3fdf48943fb8e8765ff104f28405fb20db1acfadbbf890d72a90cf1d
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005055c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24, field_minus_4, field_minus_8, field_minus_c and 8 more; [ebp + n] field_4, field_c, field_minus_20; [ebx + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c, field_10, field_18, field_20, field_28, field_30, field_38, field_minus_4, field_minus_8, field_minus_c and 5 more; [edi + n] field_4; [edx + n] field_4, field_8, field_c, field_10, field_14, field_20, field_24, field_minus_4, field_minus_8, field_minus_c, field_minus_10, field_minus_1c and 1 more; [esi + n] field_4, field_8, field_c, field_minus_4, field_minus_8, field_minus_c, field_minus_10, field_minus_1c, field_minus_20; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_34, stk_38, stk_3c
# callees:      calls FUN_00506060, FUN_00505ad0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 448 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28
.equ field_minus_2c, 0x2c  # offset -0x2c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ field_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_00505ad0, .text + (0x00505ad0 - 0x401000)
.set FUN_00506060, .text + (0x00506060 - 0x401000)

.org 0x005055c0 - 0x401000
.globl FUN_005055c0
FUN_005055c0:
    # block 0x005055c0: entry, 21 instruction(s), falls into the block at 0x005055fb
    sub esp, 0x20                                # 005055c0
    push ebx                                     # 005055c3
    mov ebx, dword ptr [esp + stk_28]            # 005055c4
    push ebp                                     # 005055c8
    mov ebp, dword ptr [esp + stk_34]            # 005055c9
    mov eax, dword ptr [ebx]                     # 005055cd
    push esi                                     # 005055cf
    push edi                                     # 005055d0
    mov esi, dword ptr [esp + stk_38]            # 005055d1
    {load} mov edi, eax                          # 005055d5
    sar edi                                      # 005055d7
    sar eax, 0x2                                 # 005055d9
    mov dword ptr [esp + stk_2c], edi            # 005055dc
    lea ecx, [esi + 4*edi - field_minus_1c]      # 005055e0
    lea edx, [eax + edi]                         # 005055e4
    shl eax, 0x2                                 # 005055e7
    {disp8} lea ebp, [ebp + 4*edx]               # 005055ea
    mov dword ptr [esp + stk_18], eax            # 005055ee
    add eax, dword ptr [ebx + field_8]           # 005055f2
    mov dword ptr [esp + stk_24], ebp            # 005055f5
    {load} mov edx, ebp                          # 005055f9
L_005055fb:
    # block 0x005055fb: entered by jae at 0x0050564d, 31 instruction(s), ends with jae to 0x005055fb (backward)
    fld dword ptr [ecx + field_8]                # 005055fb
    fmul dword ptr [eax + field_c]               # 005055fe
    sub edx, 0x10                                # 00505601
    sub ecx, 0x20                                # 00505604
    add eax, 0x10                                # 00505607
    {load} cmp ecx, esi                          # 0050560a
    fchs                                         # 0050560c
    fld dword ptr [ecx + field_20]               # 0050560e
    fmul dword ptr [eax - field_minus_8]         # 00505611
    fsubp st(1), st                              # 00505614
    fstp dword ptr [edx]                         # 00505616
    fld dword ptr [ecx + field_20]               # 00505618
    fmul dword ptr [eax - field_minus_4]         # 0050561b
    fld dword ptr [ecx + field_28]               # 0050561e
    fmul dword ptr [eax - field_minus_8]         # 00505621
    fsubp st(1), st                              # 00505624
    fstp dword ptr [edx + field_4]               # 00505626
    fld dword ptr [eax - field_minus_c]          # 00505629
    fmul dword ptr [ecx + field_38]              # 0050562c
    fchs                                         # 0050562f
    fld dword ptr [ecx + field_30]               # 00505631
    fmul dword ptr [eax - field_minus_10]        # 00505634
    fsubp st(1), st                              # 00505637
    fstp dword ptr [edx + field_8]               # 00505639
    fld dword ptr [eax - field_minus_c]          # 0050563c
    fmul dword ptr [ecx + field_30]              # 0050563f
    fld dword ptr [eax - field_minus_10]         # 00505642
    fmul dword ptr [ecx + field_38]              # 00505645
    fsubp st(1), st                              # 00505648
    fstp dword ptr [edx + field_c]               # 0050564a
    jae.d8 L_005055fb                            # 0050564d
    # block 0x0050564f: entered by fall-through of jae at 0x0050564d, 5 instruction(s), falls into the block at 0x0050565e
    mov eax, dword ptr [esp + stk_18]            # 0050564f
    {load} mov edx, ebp                          # 00505653
    mov ebp, dword ptr [ebx + field_8]           # 00505655
    lea ecx, [esi + 4*edi - field_minus_20]      # 00505658
    {load} add eax, ebp                          # 0050565c
L_0050565e:
    # block 0x0050565e: entered by jae at 0x005056ab, 29 instruction(s), ends with jae to 0x0050565e (backward)
    fld dword ptr [ecx + field_10]               # 0050565e
    fmul dword ptr [eax - field_minus_4]         # 00505661
    fld dword ptr [eax - field_minus_8]          # 00505664
    fmul dword ptr [ecx + field_18]              # 00505667
    sub eax, 0x10                                # 0050566a
    sub ecx, 0x20                                # 0050566d
    add edx, 0x10                                # 00505670
    {load} cmp ecx, esi                          # 00505673
    faddp st(1), st                              # 00505675
    fstp dword ptr [edx - field_minus_10]        # 00505677
    fld dword ptr [ecx + field_30]               # 0050567a
    fmul dword ptr [eax + field_8]               # 0050567d
    fld dword ptr [eax + field_c]                # 00505680
    fmul dword ptr [ecx + field_38]              # 00505683
    fsubp st(1), st                              # 00505686
    fstp dword ptr [edx - field_minus_c]         # 00505688
    fld dword ptr [ecx + field_28]               # 0050568b
    fmul dword ptr [eax]                         # 0050568e
    fld dword ptr [ecx + field_20]               # 00505690
    fmul dword ptr [eax + field_4]               # 00505693
    faddp st(1), st                              # 00505696
    fstp dword ptr [edx - field_minus_8]         # 00505698
    fld dword ptr [ecx + field_20]               # 0050569b
    fmul dword ptr [eax]                         # 0050569e
    fld dword ptr [eax + field_4]                # 005056a0
    fmul dword ptr [ecx + field_28]              # 005056a3
    fsubp st(1), st                              # 005056a6
    fstp dword ptr [edx - field_minus_4]         # 005056a8
    jae.d8 L_0050565e                            # 005056ab
    # block 0x005056ad: entered by fall-through of jae at 0x005056ab, 12 instruction(s), ends with jle to 0x005057e4 (forward)
    mov eax, dword ptr [esp + stk_3c]            # 005056ad
    mov edx, dword ptr [ebx + field_8]           # 005056b1
    lea ebp, [4*edi]                             # 005056b4
    mov dword ptr [esp + stk_20], edx            # 005056bb
    mov dword ptr [esp + stk_28], ebp            # 005056bf
    {load} add ebp, eax                          # 005056c3
    mov eax, dword ptr [ebx + field_4]           # 005056c5
    mov dword ptr [esp + stk_1c], ebp            # 005056c8
    sub eax, 0x6                                 # 005056cc
    test eax, eax                                # 005056cf
    mov dword ptr [esp + stk_38], eax            # 005056d1
    jle.d32 L_005057e4                           # 005056d5
    # block 0x005056db: entered by fall-through of jle at 0x005056d5, 7 instruction(s), falls into the block at 0x005056ee
    {load} mov ecx, edi                          # 005056db
    {load} mov esi, edi                          # 005056dd
    sar ecx                                      # 005056df
    add edx, 0x10                                # 005056e1
    {load} sub esi, ecx                          # 005056e4
    lea eax, [ebp + 4*ecx - field_minus_20]      # 005056e6
    lea ecx, [eax + 4*esi + field_1c]            # 005056ea
L_005056ee:
    # block 0x005056ee: entered by jae at 0x005057da, 89 instruction(s), ends with jae to 0x005056ee (backward)
    fld dword ptr [ecx - field_minus_4]          # 005056ee
    fsub dword ptr [eax + field_18]              # 005056f1
    fld dword ptr [ecx]                          # 005056f4
    fsub dword ptr [eax + field_1c]              # 005056f6
    fld dword ptr [ecx - field_minus_4]          # 005056f9
    fadd dword ptr [eax + field_18]              # 005056fc
    fstp dword ptr [ecx - field_minus_4]         # 005056ff
    fld dword ptr [eax + field_1c]               # 00505702
    fadd dword ptr [ecx]                         # 00505705
    fstp dword ptr [ecx]                         # 00505707
    fld st(0)                                    # 00505709
    fmul dword ptr [edx - field_minus_c]         # 0050570b
    fld st(2)                                    # 0050570e
    fmul dword ptr [edx - field_minus_10]        # 00505710
    faddp st(1), st                              # 00505713
    fstp dword ptr [eax + field_18]              # 00505715
    fmul dword ptr [edx - field_minus_10]        # 00505718
    fxch st(1)                                   # 0050571b
    fmul dword ptr [edx - field_minus_c]         # 0050571d
    fsubp st(1), st                              # 00505720
    fstp dword ptr [eax + field_1c]              # 00505722
    fld dword ptr [ecx - field_minus_c]          # 00505725
    fsub dword ptr [eax + field_10]              # 00505728
    fld dword ptr [ecx - field_minus_8]          # 0050572b
    fsub dword ptr [eax + field_14]              # 0050572e
    fld dword ptr [eax + field_10]               # 00505731
    fadd dword ptr [ecx - field_minus_c]         # 00505734
    fstp dword ptr [ecx - field_minus_c]         # 00505737
    fld dword ptr [ecx - field_minus_8]          # 0050573a
    fadd dword ptr [eax + field_14]              # 0050573d
    fstp dword ptr [ecx - field_minus_8]         # 00505740
    fld st(0)                                    # 00505743
    fmul dword ptr [edx + field_4]               # 00505745
    fld st(2)                                    # 00505748
    fmul dword ptr [edx]                         # 0050574a
    faddp st(1), st                              # 0050574c
    fstp dword ptr [eax + field_10]              # 0050574e
    fmul dword ptr [edx]                         # 00505751
    fxch st(1)                                   # 00505753
    fmul dword ptr [edx + field_4]               # 00505755
    fsubp st(1), st                              # 00505758
    fstp dword ptr [eax + field_14]              # 0050575a
    fld dword ptr [ecx - field_minus_14]         # 0050575d
    fsub dword ptr [eax + field_8]               # 00505760
    fld dword ptr [ecx - field_minus_10]         # 00505763
    fsub dword ptr [eax + field_c]               # 00505766
    fld dword ptr [eax + field_8]                # 00505769
    fadd dword ptr [ecx - field_minus_14]        # 0050576c
    fstp dword ptr [ecx - field_minus_14]        # 0050576f
    fld dword ptr [ecx - field_minus_10]         # 00505772
    fadd dword ptr [eax + field_c]               # 00505775
    fstp dword ptr [ecx - field_minus_10]        # 00505778
    fld st(0)                                    # 0050577b
    fmul dword ptr [edx + field_14]              # 0050577d
    fld st(2)                                    # 00505780
    fmul dword ptr [edx + field_10]              # 00505782
    faddp st(1), st                              # 00505785
    fstp dword ptr [eax + field_8]               # 00505787
    fmul dword ptr [edx + field_10]              # 0050578a
    fxch st(1)                                   # 0050578d
    fmul dword ptr [edx + field_14]              # 0050578f
    fsubp st(1), st                              # 00505792
    fstp dword ptr [eax + field_c]               # 00505794
    fld dword ptr [ecx - field_minus_1c]         # 00505797
    fsub dword ptr [eax]                         # 0050579a
    fld dword ptr [ecx - field_minus_18]         # 0050579c
    fsub dword ptr [eax + field_4]               # 0050579f
    fld dword ptr [ecx - field_minus_1c]         # 005057a2
    fadd dword ptr [eax]                         # 005057a5
    fstp dword ptr [ecx - field_minus_1c]        # 005057a7
    fld dword ptr [eax + field_4]                # 005057aa
    fadd dword ptr [ecx - field_minus_18]        # 005057ad
    fstp dword ptr [ecx - field_minus_18]        # 005057b0
    fld st(0)                                    # 005057b3
    fmul dword ptr [edx + field_24]              # 005057b5
    fld st(2)                                    # 005057b8
    fmul dword ptr [edx + field_20]              # 005057ba
    sub eax, 0x20                                # 005057bd
    sub ecx, 0x20                                # 005057c0
    add edx, 0x40                                # 005057c3
    {load} cmp eax, ebp                          # 005057c6
    faddp st(1), st                              # 005057c8
    fstp dword ptr [eax + field_20]              # 005057ca
    fmul dword ptr [edx - field_minus_20]        # 005057cd
    fxch st(1)                                   # 005057d0
    fmul dword ptr [edx - field_minus_1c]        # 005057d2
    fsubp st(1), st                              # 005057d5
    fstp dword ptr [eax + field_24]              # 005057d7
    jae.d32 L_005056ee                           # 005057da
    # block 0x005057e0: entered by fall-through of jae at 0x005057da, 1 instruction(s), falls into the block at 0x005057e4
    mov eax, dword ptr [esp + stk_38]            # 005057e0
L_005057e4:
    # block 0x005057e4: entered by jle at 0x005056d5, 5 instruction(s), ends with jle to 0x00505850 (forward)
    dec eax                                      # 005057e4
    mov ecx, 0x1                                 # 005057e5
    test eax, eax                                # 005057ea
    mov dword ptr [esp + stk_10], ecx            # 005057ec
    jle.d8 L_00505850                            # 005057f0
    # block 0x005057f2: entered by fall-through of jle at 0x005057f0, 1 instruction(s), falls into the block at 0x005057f6
    mov dword ptr [esp + stk_14], eax            # 005057f2
L_005057f6:
    # block 0x005057f6: entered by jne at 0x0050584e, 4 instruction(s), ends with jle to 0x00505840 (forward)
    mov eax, 0x1                                 # 005057f6
    shl eax, cl                                  # 005057fb
    test eax, eax                                # 005057fd
    jle.d8 L_00505840                            # 005057ff
    # block 0x00505801: entered by fall-through of jle at 0x005057ff, 5 instruction(s), falls into the block at 0x00505810
    mov ebx, 0x4                                 # 00505801
    {load} mov esi, edi                          # 00505806
    shl ebx, cl                                  # 00505808
    sar esi, cl                                  # 0050580a
    mov dword ptr [esp + stk_38], eax            # 0050580c
L_00505810:
    # block 0x00505810: entered by jne at 0x00505832, 13 instruction(s), calls FUN_00506060, ends with jne to 0x00505810 (backward)
    mov ecx, dword ptr [esp + stk_20]            # 00505810
    push ebx                                     # 00505814
    push esi                                     # 00505815
    push ebp                                     # 00505816
    push ecx                                     # 00505817
    call FUN_00506060                            # 00505818
    lea eax, [4*esi]                             # 0050581d
    add esp, 0x10                                # 00505824
    {load} add ebp, eax                          # 00505827
    mov eax, dword ptr [esp + stk_38]            # 00505829
    dec eax                                      # 0050582d
    mov dword ptr [esp + stk_38], eax            # 0050582e
    jne.d8 L_00505810                            # 00505832
    # block 0x00505834: entered by fall-through of jne at 0x00505832, 3 instruction(s), falls into the block at 0x00505840
    mov ebx, dword ptr [esp + stk_34]            # 00505834
    mov ebp, dword ptr [esp + stk_1c]            # 00505838
    mov ecx, dword ptr [esp + stk_10]            # 0050583c
L_00505840:
    # block 0x00505840: entered by jle at 0x005057ff, 6 instruction(s), ends with jne to 0x005057f6 (backward)
    mov eax, dword ptr [esp + stk_14]            # 00505840
    inc ecx                                      # 00505844
    dec eax                                      # 00505845
    mov dword ptr [esp + stk_10], ecx            # 00505846
    mov dword ptr [esp + stk_14], eax            # 0050584a
    jne.d8 L_005057f6                            # 0050584e
L_00505850:
    # block 0x00505850: entered by jle at 0x005057f0; fall-through of jne at 0x0050584e, 2 instruction(s), ends with jle to 0x0050586c (forward)
    test edi, edi                                # 00505850
    jle.d8 L_0050586c                            # 00505852
    # block 0x00505854: entered by fall-through of jle at 0x00505852, 2 instruction(s), falls into the block at 0x0050585a
    add edi, 0x1f                                # 00505854
    shr edi, 0x5                                 # 00505857
L_0050585a:
    # block 0x0050585a: entered by jne at 0x0050586a, 6 instruction(s), calls FUN_00505ad0, ends with jne to 0x0050585a (backward)
    push ebp                                     # 0050585a
    call FUN_00505ad0                            # 0050585b
    add esp, 0x4                                 # 00505860
    add ebp, 0x80                                # 00505863
    dec edi                                      # 00505869
    jne.d8 L_0050585a                            # 0050586a
L_0050586c:
    # block 0x0050586c: entered by jle at 0x00505852; fall-through of jne at 0x0050586a, 10 instruction(s), falls into the block at 0x00505888
    mov eax, dword ptr [ebx]                     # 0050586c
    mov edx, dword ptr [esp + stk_3c]            # 0050586e
    {load} mov ecx, eax                          # 00505872
    mov esi, dword ptr [ebx + field_c]           # 00505874
    sar ecx                                      # 00505877
    lea ebp, [edx + 4*ecx]                       # 00505879
    mov ecx, dword ptr [ebx + field_8]           # 0050587c
    add edx, 0x8                                 # 0050587f
    lea eax, [ecx + 4*eax]                       # 00505882
    lea ecx, [ebp + field_c]                     # 00505885
L_00505888:
    # block 0x00505888: entered by jb at 0x00505977, 78 instruction(s), ends with jb to 0x00505888 (backward)
    mov edi, dword ptr [esi]                     # 00505888
    mov ebx, dword ptr [esi + field_4]           # 0050588a
    sub ecx, 0x10                                # 0050588d
    fld dword ptr [ebp + 4*edi + field_4]        # 00505890
    fsub dword ptr [ebp + 4*ebx + field_4]       # 00505894
    {disp8} fld dword ptr [ebp + 4*ebx]          # 00505898
    {disp8} lea edi, [ebp + 4*edi]               # 0050589c
    {disp8} lea ebx, [ebp + 4*ebx]               # 005058a0
    fadd dword ptr [edi]                         # 005058a4
    fld st(0)                                    # 005058a6
    fmul dword ptr [eax]                         # 005058a8
    fld st(2)                                    # 005058aa
    fmul dword ptr [eax + field_4]               # 005058ac
    faddp st(1), st                              # 005058af
    fstp dword ptr [esp + stk_38]                # 005058b1
    fmul dword ptr [eax + field_4]               # 005058b5
    fxch st(1)                                   # 005058b8
    fmul dword ptr [eax]                         # 005058ba
    fsubp st(1), st                              # 005058bc
    fld dword ptr [ebx + field_4]                # 005058be
    fadd dword ptr [edi + field_4]               # 005058c1
    fmul dword ptr [0x52cd14]                    # 005058c4
    fld dword ptr [edi]                          # 005058ca
    fsub dword ptr [ebx]                         # 005058cc
    fmul dword ptr [0x52cd14]                    # 005058ce
    fstp dword ptr [esp + stk_10]                # 005058d4
    fld dword ptr [esp + stk_38]                 # 005058d8
    fadd st, st(1)                               # 005058dc
    fstp dword ptr [edx - field_minus_8]         # 005058de
    fsub dword ptr [esp + stk_38]                # 005058e1
    fstp dword ptr [ecx - field_minus_4]         # 005058e5
    fld st(0)                                    # 005058e8
    fadd dword ptr [esp + stk_10]                # 005058ea
    fstp dword ptr [edx - field_minus_4]         # 005058ee
    fsub dword ptr [esp + stk_10]                # 005058f1
    fstp dword ptr [ecx]                         # 005058f5
    mov edi, dword ptr [esi + field_8]           # 005058f7
    mov ebx, dword ptr [esi + field_c]           # 005058fa
    fld dword ptr [ebp + 4*edi + field_4]        # 005058fd
    fsub dword ptr [ebp + 4*ebx + field_4]       # 00505901
    {disp8} fld dword ptr [ebp + 4*ebx]          # 00505905
    {disp8} lea edi, [ebp + 4*edi]               # 00505909
    {disp8} lea ebx, [ebp + 4*ebx]               # 0050590d
    fadd dword ptr [edi]                         # 00505911
    fld st(0)                                    # 00505913
    fmul dword ptr [eax + field_8]               # 00505915
    fld st(2)                                    # 00505918
    fmul dword ptr [eax + field_c]               # 0050591a
    faddp st(1), st                              # 0050591d
    fstp dword ptr [esp + stk_38]                # 0050591f
    fmul dword ptr [eax + field_c]               # 00505923
    fxch st(1)                                   # 00505926
    fmul dword ptr [eax + field_8]               # 00505928
    fsubp st(1), st                              # 0050592b
    fld dword ptr [ebx + field_4]                # 0050592d
    fadd dword ptr [edi + field_4]               # 00505930
    fmul dword ptr [0x52cd14]                    # 00505933
    fld dword ptr [edi]                          # 00505939
    fsub dword ptr [ebx]                         # 0050593b
    fmul dword ptr [0x52cd14]                    # 0050593d
    fstp dword ptr [esp + stk_10]                # 00505943
    fld dword ptr [esp + stk_38]                 # 00505947
    fadd st, st(1)                               # 0050594b
    fstp dword ptr [edx]                         # 0050594d
    fsub dword ptr [esp + stk_38]                # 0050594f
    fstp dword ptr [ecx - field_minus_c]         # 00505953
    fld st(0)                                    # 00505956
    fadd dword ptr [esp + stk_10]                # 00505958
    fstp dword ptr [edx + field_4]               # 0050595c
    fsub dword ptr [esp + stk_10]                # 0050595f
    add edx, 0x10                                # 00505963
    lea edi, [ecx - field_minus_c]               # 00505966
    add eax, 0x10                                # 00505969
    add esi, 0x10                                # 0050596c
    lea ebx, [edx - field_minus_8]               # 0050596f
    fstp dword ptr [ecx - field_minus_8]         # 00505972
    {load} cmp ebx, edi                          # 00505975
    jb.d32 L_00505888                            # 00505977
    # block 0x0050597d: entered by fall-through of jb at 0x00505977, 9 instruction(s), falls into the block at 0x00505999
    mov eax, dword ptr [esp + stk_34]            # 0050597d
    mov ecx, dword ptr [esp + stk_28]            # 00505981
    mov edi, dword ptr [esp + stk_24]            # 00505985
    mov ebx, dword ptr [eax + field_8]           # 00505989
    {load} mov edx, edi                          # 0050598c
    {load} add ecx, ebx                          # 0050598e
    mov ebx, dword ptr [esp + stk_3c]            # 00505990
    {load} mov esi, edi                          # 00505994
    lea eax, [ebx + field_c]                     # 00505996
L_00505999:
    # block 0x00505999: entered by jb at 0x00505a38, 59 instruction(s), ends with jb to 0x00505999 (backward)
    fld dword ptr [ecx + field_4]                # 00505999
    fmul dword ptr [eax - field_minus_c]         # 0050599c
    fld dword ptr [eax - field_minus_8]          # 0050599f
    fmul dword ptr [ecx]                         # 005059a2
    sub edx, 0x10                                # 005059a4
    add eax, 0x20                                # 005059a7
    add esi, 0x10                                # 005059aa
    add ecx, 0x20                                # 005059ad
    fsubp st(1), st                              # 005059b0
    lea ebp, [eax - field_minus_c]               # 005059b2
    {load} cmp ebp, edx                          # 005059b5
    fstp dword ptr [edx + field_c]               # 005059b7
    fld dword ptr [ecx - field_minus_1c]         # 005059ba
    fmul dword ptr [eax - field_minus_28]        # 005059bd
    fld dword ptr [eax - field_minus_2c]         # 005059c0
    fmul dword ptr [ecx - field_minus_20]        # 005059c3
    faddp st(1), st                              # 005059c6
    fchs                                         # 005059c8
    fstp dword ptr [esi - field_minus_10]        # 005059ca
    fld dword ptr [eax - field_minus_24]         # 005059cd
    fmul dword ptr [ecx - field_minus_14]        # 005059d0
    fld dword ptr [eax - field_minus_20]         # 005059d3
    fmul dword ptr [ecx - field_minus_18]        # 005059d6
    fsubp st(1), st                              # 005059d9
    fstp dword ptr [edx + field_8]               # 005059db
    fld dword ptr [eax - field_minus_20]         # 005059de
    fmul dword ptr [ecx - field_minus_14]        # 005059e1
    fld dword ptr [eax - field_minus_24]         # 005059e4
    fmul dword ptr [ecx - field_minus_18]        # 005059e7
    faddp st(1), st                              # 005059ea
    fchs                                         # 005059ec
    fstp dword ptr [esi - field_minus_c]         # 005059ee
    fld dword ptr [eax - field_minus_1c]         # 005059f1
    fmul dword ptr [ecx - field_minus_c]         # 005059f4
    fld dword ptr [eax - field_minus_18]         # 005059f7
    fmul dword ptr [ecx - field_minus_10]        # 005059fa
    fsubp st(1), st                              # 005059fd
    fstp dword ptr [edx + field_4]               # 005059ff
    fld dword ptr [eax - field_minus_18]         # 00505a02
    fmul dword ptr [ecx - field_minus_c]         # 00505a05
    fld dword ptr [eax - field_minus_1c]         # 00505a08
    fmul dword ptr [ecx - field_minus_10]        # 00505a0b
    faddp st(1), st                              # 00505a0e
    fchs                                         # 00505a10
    fstp dword ptr [esi - field_minus_8]         # 00505a12
    fld dword ptr [eax - field_minus_14]         # 00505a15
    fmul dword ptr [ecx - field_minus_4]         # 00505a18
    fld dword ptr [eax - field_minus_10]         # 00505a1b
    fmul dword ptr [ecx - field_minus_8]         # 00505a1e
    fsubp st(1), st                              # 00505a21
    fstp dword ptr [edx]                         # 00505a23
    fld dword ptr [eax - field_minus_10]         # 00505a25
    fmul dword ptr [ecx - field_minus_4]         # 00505a28
    fld dword ptr [eax - field_minus_14]         # 00505a2b
    fmul dword ptr [ecx - field_minus_8]         # 00505a2e
    faddp st(1), st                              # 00505a31
    fchs                                         # 00505a33
    fstp dword ptr [esi - field_minus_4]         # 00505a35
    jb.d32 L_00505999                            # 00505a38
    # block 0x00505a3e: entered by fall-through of jb at 0x00505a38, 7 instruction(s), falls into the block at 0x00505a56
    mov esi, dword ptr [esp + stk_2c]            # 00505a3e
    mov ecx, dword ptr [esp + stk_18]            # 00505a42
    mov edx, 0x2                                 # 00505a46
    {load} mov eax, edi                          # 00505a4b
    {load} sub edx, esi                          # 00505a4d
    lea ecx, [ecx + ebx + field_8]               # 00505a4f
    lea edx, [eax + 4*edx]                       # 00505a53
L_00505a56:
    # block 0x00505a56: entered by jb at 0x00505a8e, 22 instruction(s), ends with jb to 0x00505a56 (backward)
    fld dword ptr [eax - field_minus_4]          # 00505a56
    sub eax, 0x10                                # 00505a59
    sub edx, 0x10                                # 00505a5c
    add ecx, 0x10                                # 00505a5f
    fst dword ptr [edx + field_4]                # 00505a62
    fchs                                         # 00505a65
    fstp dword ptr [ecx - field_minus_18]        # 00505a67
    fld dword ptr [eax + field_8]                # 00505a6a
    lea esi, [ecx - field_minus_8]               # 00505a6d
    fst dword ptr [edx]                          # 00505a70
    fchs                                         # 00505a72
    fstp dword ptr [ecx - field_minus_14]        # 00505a74
    fld dword ptr [eax + field_4]                # 00505a77
    {load} cmp esi, eax                          # 00505a7a
    fst dword ptr [edx - field_minus_4]          # 00505a7c
    fchs                                         # 00505a7f
    fstp dword ptr [ecx - field_minus_10]        # 00505a81
    fld dword ptr [eax]                          # 00505a84
    fst dword ptr [edx - field_minus_8]          # 00505a86
    fchs                                         # 00505a89
    fstp dword ptr [ecx - field_minus_c]         # 00505a8b
    jb.d8 L_00505a56                             # 00505a8e
    # block 0x00505a90: entered by fall-through of jb at 0x00505a8e, 3 instruction(s), falls into the block at 0x00505a98
    mov edx, dword ptr [esp + stk_1c]            # 00505a90
    {load} mov ecx, edi                          # 00505a94
    {load} mov eax, edi                          # 00505a96
L_00505a98:
    # block 0x00505a98: entered by ja at 0x00505ab7, 12 instruction(s), ends with ja to 0x00505a98 (backward)
    mov esi, dword ptr [ecx + field_c]           # 00505a98
    sub eax, 0x10                                # 00505a9b
    add ecx, 0x10                                # 00505a9e
    {load} cmp eax, edx                          # 00505aa1
    mov dword ptr [eax], esi                     # 00505aa3
    mov esi, dword ptr [ecx - field_minus_8]     # 00505aa5
    mov dword ptr [eax + field_4], esi           # 00505aa8
    mov esi, dword ptr [ecx - field_minus_c]     # 00505aab
    mov dword ptr [eax + field_8], esi           # 00505aae
    mov esi, dword ptr [ecx - field_minus_10]    # 00505ab1
    mov dword ptr [eax + field_c], esi           # 00505ab4
    ja.d8 L_00505a98                             # 00505ab7
    # block 0x00505ab9: entered by fall-through of ja at 0x00505ab7, 6 instruction(s), ends with ret
    pop edi                                      # 00505ab9
    pop esi                                      # 00505aba
    pop ebp                                      # 00505abb
    pop ebx                                      # 00505abc
    add esp, 0x20                                # 00505abd
    ret                                          # 00505ac0

# --- data items (not part of the function) -------------------------
.org 0x00505ac1 - 0x401000
PAD_00505ac1:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

