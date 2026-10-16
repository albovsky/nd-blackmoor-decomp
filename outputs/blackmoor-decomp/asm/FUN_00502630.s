# FUN_00502630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502630
# extent:       0x00502630-0x0050281b (491 code bytes)
# span:         0x00502630-0x00502820 (code 491, tables 0, padding 5)
# sha256:       4d30ace74f9b88946c24f961c95bd056baecbf43f603f581d30ea816950ac9ab
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502630
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10, field_14, field_1c, field_20; [esp + n] stk_8, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_38
# callees:      calls FUN_005023f0, FUN_0050e97e, FUN_005025c0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 173 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_005023f0, .text + (0x005023f0 - 0x401000)
.set FUN_005025c0, .text + (0x005025c0 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x00502630 - 0x401000
.globl FUN_00502630
FUN_00502630:
    # block 0x00502630: entry, 9 instruction(s), ends with je to 0x00502654 (forward)
    sub esp, 0x14                                # 00502630
    push ebp                                     # 00502633
    push esi                                     # 00502634
    mov esi, dword ptr [esp + stk_20]            # 00502635
    {load} xor ebp, ebp                          # 00502639
    mov dword ptr [esp + stk_8], ebp             # 0050263b
    mov eax, dword ptr [esi + field_c]           # 0050263f
    cmp eax, 0x1                                 # 00502642
    je.d8 L_00502654                             # 00502645
    # block 0x00502647: entered by fall-through of je at 0x00502645, 2 instruction(s), ends with je to 0x00502654 (forward)
    cmp eax, 0x2                                 # 00502647
    je.d8 L_00502654                             # 0050264a
    # block 0x0050264c: entered by fall-through of je at 0x0050264a, 5 instruction(s), ends with ret
    pop esi                                      # 0050264c
    {load} xor eax, eax                          # 0050264d
    pop ebp                                      # 0050264f
    add esp, 0x14                                # 00502650
    ret                                          # 00502653
L_00502654:
    # block 0x00502654: entered by je at 0x00502645; je at 0x0050264a, 21 instruction(s), calls FUN_005023f0, FUN_0050e97e, ends with je to 0x00502746 (forward)
    mov eax, dword ptr [esi + field_10]          # 00502654
    push ebx                                     # 00502657
    push edi                                     # 00502658
    push eax                                     # 00502659
    call FUN_005023f0                            # 0050265a
    mov ecx, dword ptr [esi + field_14]          # 0050265f
    fstp dword ptr [esp + stk_1c]                # 00502662
    push ecx                                     # 00502666
    call FUN_005023f0                            # 00502667
    mov edx, dword ptr [esi]                     # 0050266c
    push 0x4                                     # 0050266e
    imul edx, dword ptr [esp + stk_38]           # 00502670
    fstp dword ptr [esp + stk_20]                # 00502675
    push edx                                     # 00502679
    call FUN_0050e97e                            # 0050267a
    {load} mov edi, eax                          # 0050267f
    mov eax, dword ptr [esi + field_c]           # 00502681
    add esp, 0x10                                # 00502684
    dec eax                                      # 00502687
    mov dword ptr [esp + stk_2c], edi            # 00502688
    je.d32 L_00502746                            # 0050268c
    # block 0x00502692: entered by fall-through of je at 0x0050268c, 2 instruction(s), ends with jne to 0x00502811 (forward)
    dec eax                                      # 00502692
    jne.d32 L_00502811                           # 00502693
    # block 0x00502699: entered by fall-through of jne at 0x00502693, 4 instruction(s), ends with jle to 0x00502811 (forward)
    mov eax, dword ptr [esi + field_4]           # 00502699
    {load} xor edx, edx                          # 0050269c
    {load} cmp eax, ebp                          # 0050269e
    jle.d32 L_00502811                           # 005026a0
    # block 0x005026a6: entered by fall-through of jle at 0x005026a0, 2 instruction(s), falls into the block at 0x005026ae
    mov ebx, dword ptr [esp + stk_30]            # 005026a6
    mov dword ptr [esp + stk_28], ebx            # 005026aa
L_005026ae:
    # block 0x005026ae: entered by jl at 0x00502736, 2 instruction(s), ends with je to 0x005026bb (forward)
    test ebx, ebx                                # 005026ae
    je.d8 L_005026bb                             # 005026b0
    # block 0x005026b2: entered by fall-through of je at 0x005026b0, 3 instruction(s), ends with je to 0x00502730 (forward)
    mov eax, dword ptr [esi + field_8]           # 005026b2
    cmp dword ptr [eax + 4*edx], 0x0             # 005026b5
    je.d8 L_00502730                             # 005026b9
L_005026bb:
    # block 0x005026bb: entered by je at 0x005026b0; fall-through of je at 0x005026b9, 5 instruction(s), ends with jle to 0x0050271c (forward)
    mov eax, dword ptr [esi]                     # 005026bb
    {load} xor ecx, ecx                          # 005026bd
    test eax, eax                                # 005026bf
    mov dword ptr [esp + stk_2c], 0x0            # 005026c1
    jle.d8 L_0050271c                            # 005026c9
L_005026cb:
    # block 0x005026cb: entered by jl at 0x0050271a; fall-through of jle at 0x005026c9, 12 instruction(s), ends with je to 0x005026f2 (forward)
    {load} mov ebx, eax                          # 005026cb
    mov ebp, dword ptr [esi + field_20]          # 005026cd
    imul ebx, edx                                # 005026d0
    {load} add ebx, ecx                          # 005026d3
    {disp8} fild dword ptr [ebp + 4*ebx]         # 005026d5
    mov ebx, dword ptr [esi + field_1c]          # 005026d9
    test ebx, ebx                                # 005026dc
    fabs                                         # 005026de
    fmul dword ptr [esp + stk_14]                # 005026e0
    fadd dword ptr [esp + stk_2c]                # 005026e4
    fadd dword ptr [esp + stk_18]                # 005026e8
    je.d8 L_005026f2                             # 005026ec
    # block 0x005026ee: entered by fall-through of je at 0x005026ec, 1 instruction(s), falls into the block at 0x005026f2
    fst dword ptr [esp + stk_2c]                 # 005026ee
L_005026f2:
    # block 0x005026f2: entered by je at 0x005026ec, 3 instruction(s), ends with je to 0x0050270b (forward)
    mov ebx, dword ptr [esp + stk_30]            # 005026f2
    test ebx, ebx                                # 005026f6
    je.d8 L_0050270b                             # 005026f8
    # block 0x005026fa: entered by fall-through of je at 0x005026f8, 6 instruction(s), ends with forward jump to 0x00502715
    mov ebp, dword ptr [esp + stk_28]            # 005026fa
    {disp8} mov ebp, dword ptr [ebp]             # 005026fe
    imul ebp, eax                                # 00502701
    {load} add ebp, ecx                          # 00502704
    fstp dword ptr [edi + 4*ebp]                 # 00502706
    jmp.d8 L_00502715                            # 00502709
L_0050270b:
    # block 0x0050270b: entered by je at 0x005026f8, 3 instruction(s), falls into the block at 0x00502715
    imul eax, dword ptr [esp + stk_10]           # 0050270b
    {load} add eax, ecx                          # 00502710
    fstp dword ptr [edi + 4*eax]                 # 00502712
L_00502715:
    # block 0x00502715: entered by jmp at 0x00502709, 4 instruction(s), ends with jl to 0x005026cb (backward)
    mov eax, dword ptr [esi]                     # 00502715
    inc ecx                                      # 00502717
    {load} cmp ecx, eax                          # 00502718
    jl.d8 L_005026cb                             # 0050271a
L_0050271c:
    # block 0x0050271c: entered by jle at 0x005026c9; fall-through of jl at 0x0050271a, 6 instruction(s), falls into the block at 0x00502730
    mov ecx, dword ptr [esp + stk_10]            # 0050271c
    mov eax, dword ptr [esp + stk_28]            # 00502720
    inc ecx                                      # 00502724
    add eax, 0x4                                 # 00502725
    mov dword ptr [esp + stk_10], ecx            # 00502728
    mov dword ptr [esp + stk_28], eax            # 0050272c
L_00502730:
    # block 0x00502730: entered by je at 0x005026b9, 4 instruction(s), ends with jl to 0x005026ae (backward)
    mov eax, dword ptr [esi + field_4]           # 00502730
    inc edx                                      # 00502733
    {load} cmp edx, eax                          # 00502734
    jl.d32 L_005026ae                            # 00502736
    # block 0x0050273c: entered by fall-through of jl at 0x00502736, 7 instruction(s), ends with ret
    {load} mov eax, edi                          # 0050273c
    pop edi                                      # 0050273e
    pop ebx                                      # 0050273f
    pop esi                                      # 00502740
    pop ebp                                      # 00502741
    add esp, 0x14                                # 00502742
    ret                                          # 00502745
L_00502746:
    # block 0x00502746: entered by je at 0x0050268c, 7 instruction(s), calls FUN_005025c0, ends with jle to 0x00502811 (forward)
    push esi                                     # 00502746
    call FUN_005025c0                            # 00502747
    mov dword ptr [esp + stk_24], eax            # 0050274c
    mov eax, dword ptr [esi + field_4]           # 00502750
    add esp, 0x4                                 # 00502753
    {load} cmp eax, ebp                          # 00502756
    jle.d32 L_00502811                           # 00502758
    # block 0x0050275e: entered by fall-through of jle at 0x00502758, 2 instruction(s), falls into the block at 0x00502766
    mov ecx, dword ptr [esp + stk_30]            # 0050275e
    mov dword ptr [esp + stk_28], ecx            # 00502762
L_00502766:
    # block 0x00502766: entered by jl at 0x0050280b, 3 instruction(s), ends with je to 0x0050277b (forward)
    mov eax, dword ptr [esp + stk_30]            # 00502766
    test eax, eax                                # 0050276a
    je.d8 L_0050277b                             # 0050276c
    # block 0x0050276e: entered by fall-through of je at 0x0050276c, 3 instruction(s), ends with je to 0x00502805 (forward)
    mov edx, dword ptr [esi + field_8]           # 0050276e
    cmp dword ptr [edx + 4*ebp], 0x0             # 00502771
    je.d32 L_00502805                            # 00502775
L_0050277b:
    # block 0x0050277b: entered by je at 0x0050276c; fall-through of je at 0x00502775, 6 instruction(s), ends with jle to 0x005027ed (forward)
    mov ecx, dword ptr [esi]                     # 0050277b
    {load} xor edi, edi                          # 0050277d
    test ecx, ecx                                # 0050277f
    mov dword ptr [esp + stk_1c], 0x0            # 00502781
    mov ebx, 0x1                                 # 00502789
    jle.d8 L_005027ed                            # 0050278e
L_00502790:
    # block 0x00502790: entered by jl at 0x005027eb; fall-through of jle at 0x0050278e, 14 instruction(s), ends with je to 0x005027b9 (forward)
    {load} mov eax, ebp                          # 00502790
    cdq                                          # 00502792
    idiv ebx                                     # 00502793
    cdq                                          # 00502795
    idiv dword ptr [esp + stk_20]                # 00502796
    mov eax, dword ptr [esi + field_20]          # 0050279a
    fild dword ptr [eax + 4*edx]                 # 0050279d
    mov eax, dword ptr [esi + field_1c]          # 005027a0
    test eax, eax                                # 005027a3
    fabs                                         # 005027a5
    fmul dword ptr [esp + stk_14]                # 005027a7
    fadd dword ptr [esp + stk_1c]                # 005027ab
    fadd dword ptr [esp + stk_18]                # 005027af
    je.d8 L_005027b9                             # 005027b3
    # block 0x005027b5: entered by fall-through of je at 0x005027b3, 1 instruction(s), falls into the block at 0x005027b9
    fst dword ptr [esp + stk_1c]                 # 005027b5
L_005027b9:
    # block 0x005027b9: entered by je at 0x005027b3, 3 instruction(s), ends with je to 0x005027d3 (forward)
    mov eax, dword ptr [esp + stk_30]            # 005027b9
    test eax, eax                                # 005027bd
    je.d8 L_005027d3                             # 005027bf
    # block 0x005027c1: entered by fall-through of je at 0x005027bf, 6 instruction(s), ends with forward jump to 0x005027e1
    mov edx, dword ptr [esp + stk_28]            # 005027c1
    mov eax, dword ptr [esp + stk_2c]            # 005027c5
    imul ecx, dword ptr [edx]                    # 005027c9
    {load} add ecx, edi                          # 005027cc
    fstp dword ptr [eax + 4*ecx]                 # 005027ce
    jmp.d8 L_005027e1                            # 005027d1
L_005027d3:
    # block 0x005027d3: entered by je at 0x005027bf, 4 instruction(s), falls into the block at 0x005027e1
    imul ecx, dword ptr [esp + stk_10]           # 005027d3
    mov edx, dword ptr [esp + stk_2c]            # 005027d8
    {load} add ecx, edi                          # 005027dc
    fstp dword ptr [edx + 4*ecx]                 # 005027de
L_005027e1:
    # block 0x005027e1: entered by jmp at 0x005027d1, 5 instruction(s), ends with jl to 0x00502790 (backward)
    imul ebx, dword ptr [esp + stk_20]           # 005027e1
    mov ecx, dword ptr [esi]                     # 005027e6
    inc edi                                      # 005027e8
    {load} cmp edi, ecx                          # 005027e9
    jl.d8 L_00502790                             # 005027eb
L_005027ed:
    # block 0x005027ed: entered by jle at 0x0050278e; fall-through of jl at 0x005027eb, 7 instruction(s), falls into the block at 0x00502805
    mov ecx, dword ptr [esp + stk_10]            # 005027ed
    mov eax, dword ptr [esp + stk_28]            # 005027f1
    mov edi, dword ptr [esp + stk_2c]            # 005027f5
    inc ecx                                      # 005027f9
    add eax, 0x4                                 # 005027fa
    mov dword ptr [esp + stk_10], ecx            # 005027fd
    mov dword ptr [esp + stk_28], eax            # 00502801
L_00502805:
    # block 0x00502805: entered by je at 0x00502775, 4 instruction(s), ends with jl to 0x00502766 (backward)
    mov eax, dword ptr [esi + field_4]           # 00502805
    inc ebp                                      # 00502808
    {load} cmp ebp, eax                          # 00502809
    jl.d32 L_00502766                            # 0050280b
L_00502811:
    # block 0x00502811: entered by jne at 0x00502693; jle at 0x005026a0; jle at 0x00502758; fall-through of jl at 0x0050280b, 7 instruction(s), ends with ret
    {load} mov eax, edi                          # 00502811
    pop edi                                      # 00502813
    pop ebx                                      # 00502814
    pop esi                                      # 00502815
    pop ebp                                      # 00502816
    add esp, 0x14                                # 00502817
    ret                                          # 0050281a

# --- data items (not part of the function) -------------------------
.org 0x0050281b - 0x401000
PAD_0050281b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

