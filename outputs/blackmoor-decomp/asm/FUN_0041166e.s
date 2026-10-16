# FUN_0041166e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041166e
# extent:       0x0041166e-0x0041195c (750 code bytes)
# span:         0x0041166e-0x0041195c (code 750, tables 0, padding 0)
# sha256:       340ef8c5d146650ca7e60fc2c39552d9311932a2255a753bf549e7e2465e004b
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041166e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_20e; [ecx + n] field_2, field_20e; [edx + n] field_1ec, field_20e
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0051dc43, FUN_0042639d, FUN_0044a2b7, FUN_00423259
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 223 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1ec, 0x1ec  # offset +0x1ec
.equ field_20e, 0x20e  # offset +0x20e

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041166e - 0x401000
.globl FUN_0041166e
FUN_0041166e:
    # block 0x0041166e: entry, 14 instruction(s), ends with jne to 0x004117f7 (forward)
    push ebp                                     # 0041166e
    {load} mov ebp, esp                          # 0041166f
    sub esp, 0x18                                # 00411671
    push esi                                     # 00411674
    push edi                                     # 00411675
    mov dword ptr [ebp - local_18], ecx          # 00411676
    mov eax, dword ptr [ebp + arg_c]             # 00411679
    mov ecx, dword ptr [eax]                     # 0041167c
    mov dword ptr [ebp - local_c], ecx           # 0041167e
    mov edx, dword ptr [ebp - local_c]           # 00411681
    {load} xor eax, eax                          # 00411684
    mov al, byte ptr [edx + field_1ec]           # 00411686
    test eax, eax                                # 0041168c
    jne.d32 L_004117f7                           # 0041168e
    # block 0x00411694: entered by fall-through of jne at 0x0041168e, 4 instruction(s), ends with jle to 0x004116d2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00411694
    movsx edx, word ptr [ecx + field_2]          # 00411697
    cmp edx, 0x2                                 # 0041169b
    jle.d8 L_004116d2                            # 0041169e
    # block 0x004116a0: entered by fall-through of jle at 0x0041169e, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004116d2
    mov eax, dword ptr [ebp - local_c]           # 004116a0
    movsx ecx, word ptr [eax + field_2]          # 004116a3
    push ecx                                     # 004116a7
    push 0x5411e0                                # 004116a8
    push 0x63888b                                # 004116ad
    call FUN_0050ca3e                            # 004116b2
    add esp, 0xc                                 # 004116b7
    push 0x0                                     # 004116ba
    push 0x0                                     # 004116bc
    push 0x63888b                                # 004116be
    call FUN_0052139c                            # 004116c3
    mov ecx, 0x5cf659                            # 004116c8
    call FUN_004c97b4                            # 004116cd
L_004116d2:
    # block 0x004116d2: entered by jle at 0x0041169e, 4 instruction(s), ends with jl to 0x00411718 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004116d2
    movsx eax, word ptr [edx + field_20e]        # 004116d5
    cmp eax, 0x9c40                              # 004116dc
    jl.d8 L_00411718                             # 004116e1
    # block 0x004116e3: entered by fall-through of jl at 0x004116e1, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00411718
    mov ecx, dword ptr [ebp - local_c]           # 004116e3
    movsx edx, word ptr [ecx + field_20e]        # 004116e6
    push edx                                     # 004116ed
    push 0x541218                                # 004116ee
    push 0x63888b                                # 004116f3
    call FUN_0050ca3e                            # 004116f8
    add esp, 0xc                                 # 004116fd
    push 0x0                                     # 00411700
    push 0x0                                     # 00411702
    push 0x63888b                                # 00411704
    call FUN_0052139c                            # 00411709
    mov ecx, 0x5cf659                            # 0041170e
    call FUN_004c97b4                            # 00411713
L_00411718:
    # block 0x00411718: entered by jl at 0x004116e1, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00411786 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00411718
    movsx ecx, word ptr [eax + field_20e]        # 0041171b
    add ecx, 0x210                               # 00411722
    mov dword ptr [ebp - local_8], ecx           # 00411728
    mov edx, dword ptr [ebp - local_8]           # 0041172b
    push edx                                     # 0041172e
    call FUN_0051dc43                            # 0041172f
    add esp, 0x4                                 # 00411734
    mov dword ptr [ebp - local_10], eax          # 00411737
    mov eax, dword ptr [ebp + arg_8]             # 0041173a
    mov ecx, dword ptr [ebp - local_10]          # 0041173d
    mov dword ptr [eax], ecx                     # 00411740
    cmp dword ptr [ebp - local_10], 0x0          # 00411742
    jne.d8 L_00411786                            # 00411746
    # block 0x00411748: entered by fall-through of jne at 0x00411746, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411786
    movsx edx, word ptr [0x5c39e3]               # 00411748
    push edx                                     # 0041174f
    mov eax, dword ptr [0x5bb57b]                # 00411750
    push eax                                     # 00411755
    push 0x541258                                # 00411756
    push 0x63888b                                # 0041175b
    call FUN_0050ca3e                            # 00411760
    add esp, 0x10                                # 00411765
    push 0x63888b                                # 00411768
    push 0x541284                                # 0041176d
    mov ecx, 0x583979                            # 00411772
    call FUN_0042639d                            # 00411777
    mov ecx, 0x5cf659                            # 0041177c
    call FUN_004c97b4                            # 00411781
L_00411786:
    # block 0x00411786: entered by jne at 0x00411746, 33 instruction(s), ends with je to 0x004117f2 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00411786
    mov edx, dword ptr [ebp + arg_c]             # 00411789
    mov esi, dword ptr [edx]                     # 0041178c
    mov eax, dword ptr [ebp + arg_8]             # 0041178e
    mov edi, dword ptr [eax]                     # 00411791
    {load} mov edx, ecx                          # 00411793
    shr ecx, 0x2                                 # 00411795
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411798
    {load} mov ecx, edx                          # 0041179a
    and ecx, 0x3                                 # 0041179c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041179f
    mov eax, dword ptr [ebp + arg_10]            # 004117a1
    mov ecx, dword ptr [eax]                     # 004117a4
    add ecx, dword ptr [ebp - local_8]           # 004117a6
    mov edx, dword ptr [ebp + arg_10]            # 004117a9
    mov dword ptr [edx], ecx                     # 004117ac
    mov eax, dword ptr [ebp + arg_c]             # 004117ae
    mov ecx, dword ptr [eax]                     # 004117b1
    add ecx, dword ptr [ebp - local_8]           # 004117b3
    mov edx, dword ptr [ebp + arg_c]             # 004117b6
    mov dword ptr [edx], ecx                     # 004117b9
    mov edi, dword ptr [ebp - local_c]           # 004117bb
    add edi, 0x210                               # 004117be
    or ecx, -0x1                                 # 004117c4
    {load} xor eax, eax                          # 004117c7
    repne scasb al, byte ptr es:[edi]            # 004117c9
    not ecx                                      # 004117cb
    add ecx, -0x1                                # 004117cd
    mov eax, dword ptr [ebp - local_c]           # 004117d0
    mov word ptr [eax + field_20e], cx           # 004117d3
    movsx ecx, word ptr [0x63a4cd]               # 004117da
    test ecx, ecx                                # 004117e1
    je.d8 L_004117f2                             # 004117e3
    # block 0x004117e5: entered by fall-through of je at 0x004117e3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004117f2
    push 0x5412a0                                # 004117e5
    call FUN_0044a2b7                            # 004117ea
    add esp, 0x4                                 # 004117ef
L_004117f2:
    # block 0x004117f2: entered by je at 0x004117e3, 1 instruction(s), ends with forward jump to 0x00411954
    jmp.d32 L_00411954                           # 004117f2
L_004117f7:
    # block 0x004117f7: entered by jne at 0x0041168e, 9 instruction(s), calls FUN_00423259, ends with jne to 0x00411828 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004117f7
    add edx, 0x1ed                               # 004117fa
    push edx                                     # 00411800
    mov ecx, dword ptr [ebp - local_18]          # 00411801
    add ecx, 0x2a                                # 00411804
    call FUN_00423259                            # 00411807
    mov dword ptr [ebp - local_4], eax           # 0041180c
    cmp dword ptr [ebp - local_4], 0x0           # 0041180f
    jne.d8 L_00411828                            # 00411813
    # block 0x00411815: entered by fall-through of jne at 0x00411813, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00411954
    push 0x0                                     # 00411815
    push 0x0                                     # 00411817
    push 0x5412d4                                # 00411819
    call FUN_0052139c                            # 0041181e
    jmp.d32 L_00411954                           # 00411823
L_00411828:
    # block 0x00411828: entered by jne at 0x00411813, 8 instruction(s), ends with jbe to 0x00411869 (forward)
    mov edi, dword ptr [ebp - local_4]           # 00411828
    or ecx, -0x1                                 # 0041182b
    {load} xor eax, eax                          # 0041182e
    repne scasb al, byte ptr es:[edi]            # 00411830
    not ecx                                      # 00411832
    add ecx, -0x1                                # 00411834
    cmp ecx, 0x9c40                              # 00411837
    jbe.d8 L_00411869                            # 0041183d
    # block 0x0041183f: entered by fall-through of jbe at 0x0041183d, 10 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00411869
    push 0x5412f0                                # 0041183f
    push 0x63888b                                # 00411844
    call FUN_0050ca3e                            # 00411849
    add esp, 0x8                                 # 0041184e
    push 0x0                                     # 00411851
    push 0x0                                     # 00411853
    push 0x63888b                                # 00411855
    call FUN_0052139c                            # 0041185a
    mov ecx, 0x5cf659                            # 0041185f
    call FUN_004c97b4                            # 00411864
L_00411869:
    # block 0x00411869: entered by jbe at 0x0041183d, 17 instruction(s), calls FUN_0051dc43, ends with jne to 0x004118da (forward)
    mov edi, dword ptr [ebp - local_4]           # 00411869
    or ecx, -0x1                                 # 0041186c
    {load} xor eax, eax                          # 0041186f
    repne scasb al, byte ptr es:[edi]            # 00411871
    not ecx                                      # 00411873
    add ecx, 0x210                               # 00411875
    mov dword ptr [ebp - local_8], ecx           # 0041187b
    mov eax, dword ptr [ebp - local_8]           # 0041187e
    push eax                                     # 00411881
    call FUN_0051dc43                            # 00411882
    add esp, 0x4                                 # 00411887
    mov dword ptr [ebp - local_14], eax          # 0041188a
    mov ecx, dword ptr [ebp + arg_8]             # 0041188d
    mov edx, dword ptr [ebp - local_14]          # 00411890
    mov dword ptr [ecx], edx                     # 00411893
    cmp dword ptr [ebp - local_14], 0x0          # 00411895
    jne.d8 L_004118da                            # 00411899
    # block 0x0041189b: entered by fall-through of jne at 0x00411899, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004118da
    movsx eax, word ptr [0x5c39e3]               # 0041189b
    push eax                                     # 004118a2
    mov ecx, dword ptr [0x5bb57b]                # 004118a3
    push ecx                                     # 004118a9
    push 0x54133c                                # 004118aa
    push 0x63888b                                # 004118af
    call FUN_0050ca3e                            # 004118b4
    add esp, 0x10                                # 004118b9
    push 0x63888b                                # 004118bc
    push 0x541368                                # 004118c1
    mov ecx, 0x583979                            # 004118c6
    call FUN_0042639d                            # 004118cb
    mov ecx, 0x5cf659                            # 004118d0
    call FUN_004c97b4                            # 004118d5
L_004118da:
    # block 0x004118da: entered by jne at 0x00411899, 42 instruction(s), falls into the block at 0x00411954
    mov edx, dword ptr [ebp + arg_c]             # 004118da
    mov esi, dword ptr [edx]                     # 004118dd
    mov eax, dword ptr [ebp + arg_8]             # 004118df
    mov edi, dword ptr [eax]                     # 004118e2
    mov ecx, 0x83                                # 004118e4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004118e9
    movsw word ptr es:[edi], word ptr [esi]      # 004118eb
    mov ecx, dword ptr [ebp + arg_8]             # 004118ed
    mov edx, dword ptr [ecx]                     # 004118f0
    mov dword ptr [ebp - local_c], edx           # 004118f2
    mov edi, dword ptr [ebp - local_4]           # 004118f5
    or ecx, -0x1                                 # 004118f8
    {load} xor eax, eax                          # 004118fb
    repne scasb al, byte ptr es:[edi]            # 004118fd
    not ecx                                      # 004118ff
    add ecx, -0x1                                # 00411901
    mov eax, dword ptr [ebp - local_c]           # 00411904
    mov word ptr [eax + field_20e], cx           # 00411907
    mov edi, dword ptr [ebp - local_4]           # 0041190e
    or ecx, -0x1                                 # 00411911
    {load} xor eax, eax                          # 00411914
    repne scasb al, byte ptr es:[edi]            # 00411916
    not ecx                                      # 00411918
    mov esi, dword ptr [ebp - local_4]           # 0041191a
    mov edi, dword ptr [ebp - local_c]           # 0041191d
    add edi, 0x210                               # 00411920
    {load} mov edx, ecx                          # 00411926
    shr ecx, 0x2                                 # 00411928
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041192b
    {load} mov ecx, edx                          # 0041192d
    and ecx, 0x3                                 # 0041192f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411932
    mov eax, dword ptr [ebp + arg_10]            # 00411934
    mov ecx, dword ptr [eax]                     # 00411937
    add ecx, 0x210                               # 00411939
    mov edx, dword ptr [ebp + arg_10]            # 0041193f
    mov dword ptr [edx], ecx                     # 00411942
    mov eax, dword ptr [ebp + arg_c]             # 00411944
    mov ecx, dword ptr [eax]                     # 00411947
    add ecx, 0x210                               # 00411949
    mov edx, dword ptr [ebp + arg_c]             # 0041194f
    mov dword ptr [edx], ecx                     # 00411952
L_00411954:
    # block 0x00411954: entered by jmp at 0x004117f2; jmp at 0x00411823, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00411954
    pop esi                                      # 00411955
    {load} mov esp, ebp                          # 00411956
    pop ebp                                      # 00411958
    ret 0xc                                      # 00411959

