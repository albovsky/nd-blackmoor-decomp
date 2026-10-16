# FUN_00508720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508720
# extent:       0x00508720-0x005088bf (415 code bytes)
# span:         0x00508720-0x005088c0 (code 415, tables 0, padding 1)
# sha256:       1c7b6554d136fb8ffdcb1ae31a9ca98b22ba605adc214d2fefdc83294c30d150
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508720
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_28, field_minus_1, field_minus_4; [ebp + n] field_4, field_8, field_c, field_614; [ebx + n] field_minus_1; [edx + n] field_minus_100; [esp + n] stk_4, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38 and 2 more
# callees:      calls FUN_004fee30
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 147 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005088c0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_100, 0x100  # offset -0x100
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_44, 0x44  # offset +0x44
.equ field_614, 0x614  # offset +0x614

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)

.org 0x00508720 - 0x401000
.globl FUN_00508720
FUN_00508720:
    # block 0x00508720: entry, 54 instruction(s), calls FUN_004fee30, ends with jle to 0x005088a8 (forward)
    sub esp, 0x1c                                # 00508720
    mov eax, dword ptr [esp + stk_24]            # 00508723
    push ebx                                     # 00508727
    push ebp                                     # 00508728
    push esi                                     # 00508729
    mov ebp, dword ptr [eax]                     # 0050872a
    push edi                                     # 0050872c
    mov edi, dword ptr [esp + stk_30]            # 0050872d
    push 0x4                                     # 00508731
    mov edx, dword ptr [ebp + field_c]           # 00508733
    mov esi, dword ptr [ebp + field_4]           # 00508736
    mov ecx, dword ptr [ebp + field_8]           # 00508739
    mov dword ptr [esp + stk_2c], edx            # 0050873c
    {disp8} mov edx, dword ptr [ebp]             # 00508740
    push edi                                     # 00508743
    {load} sub esi, edx                          # 00508744
    mov dword ptr [esp + stk_18], ecx            # 00508746
    {load} mov eax, esi                          # 0050874a
    cdq                                          # 0050874c
    idiv ecx                                     # 0050874d
    mov dword ptr [esp + stk_28], eax            # 0050874f
    call FUN_004fee30                            # 00508753
    mov ebx, dword ptr [esp + stk_44]            # 00508758
    mov dword ptr [esp + stk_1c], eax            # 0050875c
    {load} mov eax, esi                          # 00508760
    imul eax, ebx                                # 00508762
    cdq                                          # 00508765
    idiv dword ptr [esp + stk_18]                # 00508766
    {load} mov esi, eax                          # 0050876a
    shl esi, 0x2                                 # 0050876c
    push esi                                     # 0050876f
    push edi                                     # 00508770
    call FUN_004fee30                            # 00508771
    {load} mov edi, eax                          # 00508776
    mov eax, dword ptr [esp + stk_24]            # 00508778
    {load} mov ecx, esi                          # 0050877c
    add esp, 0x10                                # 0050877e
    {load} mov edx, ecx                          # 00508781
    mov dword ptr [eax], edi                     # 00508783
    {load} xor eax, eax                          # 00508785
    shr ecx, 0x2                                 # 00508787
    rep stosd dword ptr es:[edi], eax            # 0050878a
    {load} mov ecx, edx                          # 0050878c
    and ecx, 0x3                                 # 0050878e
    rep stosb byte ptr es:[edi], al              # 00508791
    {disp8} mov eax, dword ptr [ebp]             # 00508793
    {load} xor edi, edi                          # 00508796
    cdq                                          # 00508798
    idiv ebx                                     # 00508799
    mov dword ptr [esp + stk_1c], edi            # 0050879b
    mov dword ptr [esp + stk_30], eax            # 0050879f
    mov eax, dword ptr [esp + stk_20]            # 005087a3
    test eax, eax                                # 005087a7
    jle.d32 L_005088a8                           # 005087a9
L_005087af:
    # block 0x005087af: entered by jl at 0x005088a2; fall-through of jle at 0x005087a9, 6 instruction(s), ends with jle to 0x00508856 (forward)
    mov eax, dword ptr [esp + stk_10]            # 005087af
    mov dword ptr [esp + stk_3c], 0x0            # 005087b3
    fld dword ptr [0x52db78]                     # 005087bb
    test eax, eax                                # 005087c1
    mov dword ptr [esp + stk_18], 0x0            # 005087c3
    jle.d32 L_00508856                           # 005087cb
    # block 0x005087d1: entered by fall-through of jle at 0x005087cb, 5 instruction(s), falls into the block at 0x005087e6
    mov eax, dword ptr [esp + stk_38]            # 005087d1
    mov edx, dword ptr [esp + stk_30]            # 005087d5
    mov ecx, dword ptr [eax]                     # 005087d9
    lea esi, [4*edx]                             # 005087db
    mov dword ptr [esp + stk_24], ecx            # 005087e2
L_005087e6:
    # block 0x005087e6: entered by jl at 0x00508850, 9 instruction(s), ends with jne to 0x00508804 (forward)
    mov eax, dword ptr [esp + stk_24]            # 005087e6
    fld dword ptr [esi + eax]                    # 005087ea
    fabs                                         # 005087ed
    fld dword ptr [esp + stk_3c]                 # 005087ef
    fld st(1)                                    # 005087f3
    fcompp                                       # 005087f5
    fnstsw ax                                    # 005087f7
    test ah, 0x41                                # 005087f9
    jne.d8 L_00508804                            # 005087fc
    # block 0x005087fe: entered by fall-through of jne at 0x005087fc, 2 instruction(s), ends with forward jump to 0x00508806
    fstp dword ptr [esp + stk_3c]                # 005087fe
    jmp.d8 L_00508806                            # 00508802
L_00508804:
    # block 0x00508804: entered by jne at 0x005087fc, 1 instruction(s), falls into the block at 0x00508806
    fstp st(0)                                   # 00508804
L_00508806:
    # block 0x00508806: entered by jmp at 0x00508802, 2 instruction(s), ends with jle to 0x00508834 (forward)
    cmp ebx, 0x1                                 # 00508806
    jle.d8 L_00508834                            # 00508809
    # block 0x0050880b: entered by fall-through of jle at 0x00508809, 3 instruction(s), falls into the block at 0x00508815
    mov ecx, dword ptr [esp + stk_38]            # 0050880b
    lea edi, [ebx - field_minus_1]               # 0050880f
    add ecx, 0x4                                 # 00508812
L_00508815:
    # block 0x00508815: entered by jne at 0x00508832, 9 instruction(s), ends with je to 0x0050882e (forward)
    mov edx, dword ptr [ecx]                     # 00508815
    {load} add edx, esi                          # 00508817
    fld dword ptr [edx]                          # 00508819
    fabs                                         # 0050881b
    fld st(1)                                    # 0050881d
    fcompp                                       # 0050881f
    fnstsw ax                                    # 00508821
    test ah, 0x1                                 # 00508823
    je.d8 L_0050882e                             # 00508826
    # block 0x00508828: entered by fall-through of je at 0x00508826, 3 instruction(s), falls into the block at 0x0050882e
    fstp st(0)                                   # 00508828
    fld dword ptr [edx]                          # 0050882a
    fabs                                         # 0050882c
L_0050882e:
    # block 0x0050882e: entered by je at 0x00508826, 3 instruction(s), ends with jne to 0x00508815 (backward)
    add ecx, 0x4                                 # 0050882e
    dec edi                                      # 00508831
    jne.d8 L_00508815                            # 00508832
L_00508834:
    # block 0x00508834: entered by jle at 0x00508809; fall-through of jne at 0x00508832, 10 instruction(s), ends with jl to 0x005087e6 (backward)
    mov eax, dword ptr [esp + stk_30]            # 00508834
    mov ecx, dword ptr [esp + stk_10]            # 00508838
    inc eax                                      # 0050883c
    add esi, 0x4                                 # 0050883d
    mov dword ptr [esp + stk_30], eax            # 00508840
    mov eax, dword ptr [esp + stk_18]            # 00508844
    {load} add eax, ebx                          # 00508848
    {load} cmp eax, ecx                          # 0050884a
    mov dword ptr [esp + stk_18], eax            # 0050884c
    jl.d8 L_005087e6                             # 00508850
    # block 0x00508852: entered by fall-through of jl at 0x00508850, 1 instruction(s), falls into the block at 0x00508856
    mov edi, dword ptr [esp + stk_1c]            # 00508852
L_00508856:
    # block 0x00508856: entered by jle at 0x005087cb, 5 instruction(s), ends with jle to 0x0050888b (forward)
    mov eax, dword ptr [esp + stk_28]            # 00508856
    {load} xor ecx, ecx                          # 0050885a
    lea esi, [eax - field_minus_1]               # 0050885c
    test esi, esi                                # 0050885f
    jle.d8 L_0050888b                            # 00508861
    # block 0x00508863: entered by fall-through of jle at 0x00508861, 1 instruction(s), falls into the block at 0x00508869
    lea edx, [ebp + field_614]                   # 00508863
L_00508869:
    # block 0x00508869: entered by jl at 0x00508889, 5 instruction(s), ends with je to 0x00508883 (forward)
    fld dword ptr [esp + stk_3c]                 # 00508869
    fcomp dword ptr [edx - field_minus_100]      # 0050886d
    fnstsw ax                                    # 00508873
    test ah, 0x41                                # 00508875
    je.d8 L_00508883                             # 00508878
    # block 0x0050887a: entered by fall-through of je at 0x00508878, 4 instruction(s), ends with jne to 0x0050888b (forward)
    fcom dword ptr [edx]                         # 0050887a
    fnstsw ax                                    # 0050887c
    test ah, 0x41                                # 0050887e
    jne.d8 L_0050888b                            # 00508881
L_00508883:
    # block 0x00508883: entered by je at 0x00508878; fall-through of jne at 0x00508881, 4 instruction(s), ends with jl to 0x00508869 (backward)
    inc ecx                                      # 00508883
    add edx, 0x4                                 # 00508884
    {load} cmp ecx, esi                          # 00508887
    jl.d8 L_00508869                             # 00508889
L_0050888b:
    # block 0x0050888b: entered by jle at 0x00508861; jne at 0x00508881; fall-through of jl at 0x00508889, 9 instruction(s), ends with jl to 0x005087af (backward)
    mov edx, dword ptr [esp + stk_14]            # 0050888b
    inc edi                                      # 0050888f
    fstp st(0)                                   # 00508890
    mov eax, dword ptr [edx]                     # 00508892
    mov dword ptr [esp + stk_1c], edi            # 00508894
    mov dword ptr [eax + 4*edi - field_minus_4], ecx # 00508898
    mov eax, dword ptr [esp + stk_20]            # 0050889c
    {load} cmp edi, eax                          # 005088a0
    jl.d32 L_005087af                            # 005088a2
L_005088a8:
    # block 0x005088a8: entered by jle at 0x005087a9; fall-through of jl at 0x005088a2, 11 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_34]            # 005088a8
    pop edi                                      # 005088ac
    pop esi                                      # 005088ad
    pop ebp                                      # 005088ae
    mov ecx, dword ptr [eax + field_28]          # 005088af
    pop ebx                                      # 005088b2
    inc ecx                                      # 005088b3
    mov dword ptr [eax + field_28], ecx          # 005088b4
    mov eax, dword ptr [esp + stk_4]             # 005088b7
    add esp, 0x1c                                # 005088bb
    ret                                          # 005088be

# --- data items (not part of the function) -------------------------
.org 0x005088bf - 0x401000
PAD_005088bf:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

