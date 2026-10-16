# FUN_004fd690
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd690
# extent:       0x004fd690-0x004fd8ac (540 code bytes)
# span:         0x004fd690-0x004fd8b0 (code 540, tables 0, padding 4)
# sha256:       f94caeff644767364e29d81b62496eef4c210229a84ec0f439c83b96458f4780
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd690
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_4; [ecx + n] field_4; [edi + n] field_8, field_c, field_34, field_38, field_40; [esi + n] field_1; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_34, stk_38, stk_3c, stk_40, stk_44 and 6 more; [scaled index + n] field_8
# callees:      calls FUN_0050eb20, FUN_004fd650, FUN_004fd2b0, FUN_0050b260, FUN_004fd690, FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 200 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ field_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ field_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ field_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fd650, .text + (0x004fd650 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050eb20, .text + (0x0050eb20 - 0x401000)

.org 0x004fd690 - 0x401000
.globl FUN_004fd690
FUN_004fd690:
L_004fd690:
    # block 0x004fd690: entry, 16 instruction(s), ends with jg to 0x004fd7b5 (forward)
    sub esp, 0x28                                # 004fd690
    mov edx, dword ptr [esp + stk_40]            # 004fd693
    push ebx                                     # 004fd697
    mov ebx, dword ptr [esp + stk_3c]            # 004fd698
    push ebp                                     # 004fd69c
    mov ebp, dword ptr [esp + stk_4c]            # 004fd69d
    push esi                                     # 004fd6a1
    mov esi, dword ptr [esp + stk_48]            # 004fd6a2
    push edi                                     # 004fd6a6
    {load} mov edi, ebp                          # 004fd6a7
    {load} cmp esi, ebp                          # 004fd6a9
    mov dword ptr [esp + stk_10], edx            # 004fd6ab
    mov dword ptr [esp + stk_14], edi            # 004fd6af
    mov dword ptr [esp + stk_18], edx            # 004fd6b3
    mov dword ptr [esp + stk_1c], ebp            # 004fd6b7
    jg.d32 L_004fd7b5                            # 004fd6bb
    # block 0x004fd6c1: entered by fall-through of jg at 0x004fd6bb, 1 instruction(s), ends with jl to 0x004fd6d5 (forward)
    jl.d8 L_004fd6d5                             # 004fd6c1
    # block 0x004fd6c3: entered by fall-through of jl at 0x004fd6c1, 2 instruction(s), ends with jae to 0x004fd7b5 (forward)
    {load} cmp ebx, edx                          # 004fd6c3
    jae.d32 L_004fd7b5                           # 004fd6c5
    # block 0x004fd6cb: entered by fall-through of jae at 0x004fd6c5, 1 instruction(s), ends with forward jump to 0x004fd6d5
    jmp.d8 L_004fd6d5                            # 004fd6cb
L_004fd6cd:
    # block 0x004fd6cd: entered by jl at 0x004fd79f; jb at 0x004fd7ab, 2 instruction(s), falls into the block at 0x004fd6d5
    mov edx, dword ptr [esp + stk_10]            # 004fd6cd
    mov edi, dword ptr [esp + stk_14]            # 004fd6d1
L_004fd6d5:
    # block 0x004fd6d5: entered by jl at 0x004fd6c1; jmp at 0x004fd6cb, 6 instruction(s), ends with jg to 0x004fd6f3 (forward)
    {load} mov ecx, edx                          # 004fd6d5
    {load} mov eax, edi                          # 004fd6d7
    {load} sub ecx, ebx                          # 004fd6d9
    {load} sbb eax, esi                          # 004fd6db
    test eax, eax                                # 004fd6dd
    jg.d8 L_004fd6f3                             # 004fd6df
    # block 0x004fd6e1: entered by fall-through of jg at 0x004fd6df, 1 instruction(s), ends with jl to 0x004fd6eb (forward)
    jl.d8 L_004fd6eb                             # 004fd6e1
    # block 0x004fd6e3: entered by fall-through of jl at 0x004fd6e1, 2 instruction(s), ends with jae to 0x004fd6f3 (forward)
    cmp ecx, 0x2134                              # 004fd6e3
    jae.d8 L_004fd6f3                            # 004fd6e9
L_004fd6eb:
    # block 0x004fd6eb: entered by jl at 0x004fd6e1; fall-through of jae at 0x004fd6e9, 3 instruction(s), ends with forward jump to 0x004fd708
    {load} mov ebp, ebx                          # 004fd6eb
    mov dword ptr [esp + stk_4c], esi            # 004fd6ed
    jmp.d8 L_004fd708                            # 004fd6f1
L_004fd6f3:
    # block 0x004fd6f3: entered by jg at 0x004fd6df; jae at 0x004fd6e9, 9 instruction(s), calls FUN_0050eb20, falls into the block at 0x004fd708
    {load} add edx, ebx                          # 004fd6f3
    push 0x0                                     # 004fd6f5
    {load} adc edi, esi                          # 004fd6f7
    push 0x2                                     # 004fd6f9
    push edi                                     # 004fd6fb
    push edx                                     # 004fd6fc
    call FUN_0050eb20                            # 004fd6fd
    {load} mov ebp, eax                          # 004fd702
    mov dword ptr [esp + stk_4c], edx            # 004fd704
L_004fd708:
    # block 0x004fd708: entered by jmp at 0x004fd6f1, 17 instruction(s), calls FUN_004fd650, FUN_004fd2b0, ends with jne to 0x004fd73e (forward)
    mov eax, dword ptr [esp + stk_4c]            # 004fd708
    mov edi, dword ptr [esp + stk_3c]            # 004fd70c
    push eax                                     # 004fd710
    push ebp                                     # 004fd711
    push edi                                     # 004fd712
    call FUN_004fd650                            # 004fd713
    push -0x1                                    # 004fd718
    lea ecx, [esp + stk_38]                      # 004fd71a
    push -0x1                                    # 004fd71e
    push ecx                                     # 004fd720
    push edi                                     # 004fd721
    call FUN_004fd2b0                            # 004fd722
    add esp, 0x1c                                # 004fd727
    cmp eax, -0x80                               # 004fd72a
    mov dword ptr [esp + stk_20], eax            # 004fd72d
    {load} mov edi, edx                          # 004fd731
    jne.d8 L_004fd73e                            # 004fd733
    # block 0x004fd735: entered by fall-through of jne at 0x004fd733, 2 instruction(s), ends with je to 0x004fd83f (forward)
    cmp edi, -0x1                                # 004fd735
    je.d32 L_004fd83f                            # 004fd738
L_004fd73e:
    # block 0x004fd73e: entered by jne at 0x004fd733; fall-through of je at 0x004fd738, 2 instruction(s), ends with jl to 0x004fd77d (forward)
    test edi, edi                                # 004fd73e
    jl.d8 L_004fd77d                             # 004fd740
    # block 0x004fd742: entered by fall-through of jl at 0x004fd740, 1 instruction(s), ends with jg to 0x004fd748 (forward)
    jg.d8 L_004fd748                             # 004fd742
    # block 0x004fd744: entered by fall-through of jg at 0x004fd742, 2 instruction(s), ends with jb to 0x004fd77d (forward)
    test eax, eax                                # 004fd744
    jb.d8 L_004fd77d                             # 004fd746
L_004fd748:
    # block 0x004fd748: entered by jg at 0x004fd742; fall-through of jb at 0x004fd746, 7 instruction(s), calls FUN_0050b260, ends with jne to 0x004fd779 (forward)
    lea edx, [esp + stk_28]                      # 004fd748
    push edx                                     # 004fd74c
    call FUN_0050b260                            # 004fd74d
    mov ecx, dword ptr [esp + stk_5c]            # 004fd752
    add esp, 0x4                                 # 004fd756
    {load} cmp eax, ecx                          # 004fd759
    jne.d8 L_004fd779                            # 004fd75b
    # block 0x004fd75d: entered by fall-through of jne at 0x004fd75b, 12 instruction(s), ends with forward jump to 0x004fd79b
    mov eax, dword ptr [esp + stk_34]            # 004fd75d
    mov ecx, dword ptr [esp + stk_20]            # 004fd761
    cdq                                          # 004fd765
    {load} mov ebx, eax                          # 004fd766
    mov eax, dword ptr [esp + stk_2c]            # 004fd768
    {load} mov esi, edx                          # 004fd76c
    cdq                                          # 004fd76e
    {load} add ebx, eax                          # 004fd76f
    {load} adc esi, edx                          # 004fd771
    {load} add ebx, ecx                          # 004fd773
    {load} adc esi, edi                          # 004fd775
    jmp.d8 L_004fd79b                            # 004fd777
L_004fd779:
    # block 0x004fd779: entered by jne at 0x004fd75b, 1 instruction(s), falls into the block at 0x004fd77d
    mov eax, dword ptr [esp + stk_20]            # 004fd779
L_004fd77d:
    # block 0x004fd77d: entered by jl at 0x004fd740; jb at 0x004fd746, 5 instruction(s), ends with jl to 0x004fd79b (forward)
    mov ecx, dword ptr [esp + stk_4c]            # 004fd77d
    mov dword ptr [esp + stk_10], ebp            # 004fd781
    test edi, edi                                # 004fd785
    mov dword ptr [esp + stk_14], ecx            # 004fd787
    jl.d8 L_004fd79b                             # 004fd78b
    # block 0x004fd78d: entered by fall-through of jl at 0x004fd78b, 1 instruction(s), ends with jg to 0x004fd793 (forward)
    jg.d8 L_004fd793                             # 004fd78d
    # block 0x004fd78f: entered by fall-through of jg at 0x004fd78d, 2 instruction(s), ends with jb to 0x004fd79b (forward)
    test eax, eax                                # 004fd78f
    jb.d8 L_004fd79b                             # 004fd791
L_004fd793:
    # block 0x004fd793: entered by jg at 0x004fd78d; fall-through of jb at 0x004fd791, 2 instruction(s), falls into the block at 0x004fd79b
    mov dword ptr [esp + stk_18], eax            # 004fd793
    mov dword ptr [esp + stk_1c], edi            # 004fd797
L_004fd79b:
    # block 0x004fd79b: entered by jmp at 0x004fd777; jl at 0x004fd78b; jb at 0x004fd791, 2 instruction(s), ends with jl to 0x004fd6cd (backward)
    cmp esi, dword ptr [esp + stk_14]            # 004fd79b
    jl.d32 L_004fd6cd                            # 004fd79f
    # block 0x004fd7a5: entered by fall-through of jl at 0x004fd79f, 1 instruction(s), ends with jg to 0x004fd7b1 (forward)
    jg.d8 L_004fd7b1                             # 004fd7a5
    # block 0x004fd7a7: entered by fall-through of jg at 0x004fd7a5, 2 instruction(s), ends with jb to 0x004fd6cd (backward)
    cmp ebx, dword ptr [esp + stk_10]            # 004fd7a7
    jb.d32 L_004fd6cd                            # 004fd7ab
L_004fd7b1:
    # block 0x004fd7b1: entered by jg at 0x004fd7a5; fall-through of jb at 0x004fd7ab, 1 instruction(s), falls into the block at 0x004fd7b5
    mov ebp, dword ptr [esp + stk_54]            # 004fd7b1
L_004fd7b5:
    # block 0x004fd7b5: entered by jg at 0x004fd6bb; jae at 0x004fd6c5, 16 instruction(s), calls FUN_004fd650, FUN_004fd2b0, ends with jne to 0x004fd7ed (forward)
    mov edx, dword ptr [esp + stk_1c]            # 004fd7b5
    mov eax, dword ptr [esp + stk_18]            # 004fd7b9
    mov edi, dword ptr [esp + stk_3c]            # 004fd7bd
    push edx                                     # 004fd7c1
    push eax                                     # 004fd7c2
    push edi                                     # 004fd7c3
    call FUN_004fd650                            # 004fd7c4
    push -0x1                                    # 004fd7c9
    lea ecx, [esp + stk_38]                      # 004fd7cb
    push -0x1                                    # 004fd7cf
    push ecx                                     # 004fd7d1
    push edi                                     # 004fd7d2
    call FUN_004fd2b0                            # 004fd7d3
    add esp, 0x1c                                # 004fd7d8
    cmp eax, -0x80                               # 004fd7db
    jne.d8 L_004fd7ed                            # 004fd7de
    # block 0x004fd7e0: entered by fall-through of jne at 0x004fd7de, 2 instruction(s), ends with jne to 0x004fd7ed (forward)
    cmp edx, -0x1                                # 004fd7e0
    jne.d8 L_004fd7ed                            # 004fd7e3
    # block 0x004fd7e5: entered by fall-through of jne at 0x004fd7e3, 6 instruction(s), ends with ret
    pop edi                                      # 004fd7e5
    pop esi                                      # 004fd7e6
    pop ebp                                      # 004fd7e7
    pop ebx                                      # 004fd7e8
    add esp, 0x28                                # 004fd7e9
    ret                                          # 004fd7ec
L_004fd7ed:
    # block 0x004fd7ed: entered by jne at 0x004fd7de; jne at 0x004fd7e3, 2 instruction(s), ends with jg to 0x004fd84c (forward)
    {load} cmp esi, ebp                          # 004fd7ed
    jg.d8 L_004fd84c                             # 004fd7ef
    # block 0x004fd7f1: entered by fall-through of jg at 0x004fd7ef, 1 instruction(s), ends with jl to 0x004fd7f9 (forward)
    jl.d8 L_004fd7f9                             # 004fd7f1
    # block 0x004fd7f3: entered by fall-through of jl at 0x004fd7f1, 2 instruction(s), ends with jae to 0x004fd84c (forward)
    cmp ebx, dword ptr [esp + stk_50]            # 004fd7f3
    jae.d8 L_004fd84c                            # 004fd7f7
L_004fd7f9:
    # block 0x004fd7f9: entered by jl at 0x004fd7f1; fall-through of jae at 0x004fd7f7, 2 instruction(s), ends with jl to 0x004fd84c (forward)
    test edx, edx                                # 004fd7f9
    jl.d8 L_004fd84c                             # 004fd7fb
    # block 0x004fd7fd: entered by fall-through of jl at 0x004fd7fb, 1 instruction(s), ends with jg to 0x004fd803 (forward)
    jg.d8 L_004fd803                             # 004fd7fd
    # block 0x004fd7ff: entered by fall-through of jg at 0x004fd7fd, 2 instruction(s), ends with jb to 0x004fd84c (forward)
    test eax, eax                                # 004fd7ff
    jb.d8 L_004fd84c                             # 004fd801
L_004fd803:
    # block 0x004fd803: entered by jg at 0x004fd7fd; fall-through of jb at 0x004fd801, 24 instruction(s), calls FUN_0050b260, FUN_004fd690, ends with jne to 0x004fd886 (forward)
    mov esi, dword ptr [esp + stk_5c]            # 004fd803
    lea eax, [esp + stk_28]                      # 004fd807
    lea edx, [esi + field_1]                     # 004fd80b
    push edx                                     # 004fd80e
    push eax                                     # 004fd80f
    call FUN_0050b260                            # 004fd810
    mov ecx, dword ptr [esp + stk_58]            # 004fd815
    mov edx, dword ptr [edi + field_c]           # 004fd819
    add esp, 0x4                                 # 004fd81c
    push eax                                     # 004fd81f
    mov eax, dword ptr [edi + field_8]           # 004fd820
    push ebp                                     # 004fd823
    push ecx                                     # 004fd824
    mov ecx, dword ptr [esp + stk_2c]            # 004fd825
    push edx                                     # 004fd829
    mov edx, dword ptr [esp + stk_2c]            # 004fd82a
    push eax                                     # 004fd82e
    push ecx                                     # 004fd82f
    push edx                                     # 004fd830
    push edi                                     # 004fd831
    call L_004fd690                              # 004fd832
    add esp, 0x24                                # 004fd837
    cmp eax, -0x80                               # 004fd83a
    jne.d8 L_004fd886                            # 004fd83d
L_004fd83f:
    # block 0x004fd83f: entered by je at 0x004fd738; fall-through of jne at 0x004fd83d, 7 instruction(s), ends with ret
    pop edi                                      # 004fd83f
    pop esi                                      # 004fd840
    pop ebp                                      # 004fd841
    mov eax, 0xffffff80                          # 004fd842
    pop ebx                                      # 004fd847
    add esp, 0x28                                # 004fd848
    ret                                          # 004fd84b
L_004fd84c:
    # block 0x004fd84c: entered by jg at 0x004fd7ef; jae at 0x004fd7f7; jl at 0x004fd7fb; jb at 0x004fd801, 17 instruction(s), calls FUN_0050ea90, falls into the block at 0x004fd886
    mov eax, dword ptr [esp + stk_5c]            # 004fd84c
    lea ebp, [eax + field_1]                     # 004fd850
    mov dword ptr [edi + field_34], ebp          # 004fd853
    lea ecx, [8*ebp + field_8]                   # 004fd856
    push ecx                                     # 004fd85d
    call FUN_0050ea90                            # 004fd85e
    mov edx, dword ptr [edi + field_34]          # 004fd863
    mov dword ptr [edi + field_38], eax          # 004fd866
    shl edx, 0x2                                 # 004fd869
    push edx                                     # 004fd86c
    call FUN_0050ea90                            # 004fd86d
    mov dword ptr [edi + field_40], eax          # 004fd872
    mov eax, dword ptr [edi + field_38]          # 004fd875
    add esp, 0x8                                 # 004fd878
    mov dword ptr [eax + 8*ebp], ebx             # 004fd87b
    mov dword ptr [eax + 8*ebp + field_4], esi   # 004fd87e
    mov esi, dword ptr [esp + stk_5c]            # 004fd882
L_004fd886:
    # block 0x004fd886: entered by jne at 0x004fd83d, 15 instruction(s), ends with ret
    mov ecx, dword ptr [edi + field_38]          # 004fd886
    mov edx, dword ptr [esp + stk_40]            # 004fd889
    mov eax, dword ptr [esp + stk_44]            # 004fd88d
    mov dword ptr [ecx + 8*esi], edx             # 004fd891
    mov edx, dword ptr [esp + stk_58]            # 004fd894
    mov dword ptr [ecx + 8*esi + field_4], eax   # 004fd898
    mov ecx, dword ptr [edi + field_40]          # 004fd89c
    pop edi                                      # 004fd89f
    {load} xor eax, eax                          # 004fd8a0
    mov dword ptr [ecx + 4*esi], edx             # 004fd8a2
    pop esi                                      # 004fd8a5
    pop ebp                                      # 004fd8a6
    pop ebx                                      # 004fd8a7
    add esp, 0x28                                # 004fd8a8
    ret                                          # 004fd8ab

# --- data items (not part of the function) -------------------------
.org 0x004fd8ac - 0x401000
PAD_004fd8ac:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

