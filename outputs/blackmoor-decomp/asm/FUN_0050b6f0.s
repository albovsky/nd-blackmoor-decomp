# FUN_0050b6f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b6f0
# extent:       0x0050b6f0-0x0050b9d3 (739 code bytes)
# span:         0x0050b6f0-0x0050b9e0 (code 739, tables 0, padding 13)
# sha256:       f2b7fa281e49dbcafe5babce81419758398a012d1347f5fd692e8f02a5c4d44b
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b6f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebx + n] field_8, field_c, field_10, field_14, field_1a, field_1c, field_20, field_24, field_146, field_14e, field_152; [ecx + n] field_1b; [edi + n] field_8, field_c; [edx + n] field_1b, field_minus_4; [esi + n] field_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 5 more
# callees:      calls FUN_0050b140, FUN_0050b150, FUN_0050b160, FUN_0050b170, FUN_0050b180, FUN_0050b260, FUN_0050b290, FUN_0050ed50, FUN_0050b460, FUN_0050b430
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 259 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1b, 0x1b  # offset +0x1b
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
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
.equ stk_5c, 0x5c  # offset +0x5c
.equ field_146, 0x146  # offset +0x146
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152

# --- external targets -----------------------------------------------
.set FUN_0050b140, .text + (0x0050b140 - 0x401000)
.set FUN_0050b150, .text + (0x0050b150 - 0x401000)
.set FUN_0050b160, .text + (0x0050b160 - 0x401000)
.set FUN_0050b170, .text + (0x0050b170 - 0x401000)
.set FUN_0050b180, .text + (0x0050b180 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050b290, .text + (0x0050b290 - 0x401000)
.set FUN_0050b430, .text + (0x0050b430 - 0x401000)
.set FUN_0050b460, .text + (0x0050b460 - 0x401000)
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)

.org 0x0050b6f0 - 0x401000
.globl FUN_0050b6f0
FUN_0050b6f0:
    # block 0x0050b6f0: entry, 44 instruction(s), calls FUN_0050b140, FUN_0050b150, FUN_0050b160, FUN_0050b170, FUN_0050b180, FUN_0050b260, FUN_0050b290, ends with je to 0x0050b798 (forward)
    sub esp, 0x2c                                # 0050b6f0
    push ebx                                     # 0050b6f3
    push ebp                                     # 0050b6f4
    push esi                                     # 0050b6f5
    push edi                                     # 0050b6f6
    mov edi, dword ptr [esp + stk_44]            # 0050b6f7
    {load} xor ebp, ebp                          # 0050b6fb
    push edi                                     # 0050b6fd
    mov ebx, dword ptr [edi]                     # 0050b6fe
    mov eax, dword ptr [edi + field_8]           # 0050b700
    mov esi, dword ptr [edi + field_c]           # 0050b703
    mov dword ptr [esp + stk_20], ebx            # 0050b706
    mov dword ptr [esp + stk_14], eax            # 0050b70a
    mov dword ptr [esp + stk_18], esi            # 0050b70e
    call FUN_0050b140                            # 0050b712
    push edi                                     # 0050b717
    mov dword ptr [esp + stk_30], eax            # 0050b718
    call FUN_0050b150                            # 0050b71c
    push edi                                     # 0050b721
    mov dword ptr [esp + stk_38], eax            # 0050b722
    call FUN_0050b160                            # 0050b726
    push edi                                     # 0050b72b
    mov dword ptr [esp + stk_28], eax            # 0050b72c
    call FUN_0050b170                            # 0050b730
    push edi                                     # 0050b735
    mov dword ptr [esp + stk_44], eax            # 0050b736
    call FUN_0050b180                            # 0050b73a
    push edi                                     # 0050b73f
    mov dword ptr [esp + stk_4c], eax            # 0050b740
    mov dword ptr [esp + stk_50], edx            # 0050b744
    call FUN_0050b260                            # 0050b748
    push edi                                     # 0050b74d
    mov dword ptr [esp + stk_40], eax            # 0050b74e
    call FUN_0050b290                            # 0050b752
    {load} xor ecx, ecx                          # 0050b757
    mov dword ptr [esp + stk_3c], eax            # 0050b759
    mov cl, byte ptr [ebx + field_1a]            # 0050b75d
    mov ebx, dword ptr [esp + stk_5c]            # 0050b760
    add esp, 0x1c                                # 0050b764
    mov dword ptr [esp + stk_44], ecx            # 0050b767
    mov eax, dword ptr [ebx + field_c]           # 0050b76b
    mov edi, dword ptr [ebx + field_24]          # 0050b76e
    test eax, eax                                # 0050b771
    je.d8 L_0050b798                             # 0050b773
    # block 0x0050b775: entered by fall-through of je at 0x0050b773, 5 instruction(s), ends with je to 0x0050b791 (forward)
    mov ecx, dword ptr [ebx + field_8]           # 0050b775
    {load} sub ecx, eax                          # 0050b778
    mov dword ptr [ebx + field_8], ecx           # 0050b77a
    {load} mov edx, ecx                          # 0050b77d
    je.d8 L_0050b791                             # 0050b77f
    # block 0x0050b781: entered by fall-through of je at 0x0050b77f, 7 instruction(s), calls FUN_0050ed50, falls into the block at 0x0050b791
    mov ecx, dword ptr [ebx]                     # 0050b781
    push edx                                     # 0050b783
    lea edx, [ecx + eax]                         # 0050b784
    push edx                                     # 0050b787
    push ecx                                     # 0050b788
    call FUN_0050ed50                            # 0050b789
    add esp, 0xc                                 # 0050b78e
L_0050b791:
    # block 0x0050b791: entered by je at 0x0050b77f, 1 instruction(s), falls into the block at 0x0050b798
    mov dword ptr [ebx + field_c], 0x0           # 0050b791
L_0050b798:
    # block 0x0050b798: entered by je at 0x0050b773, 2 instruction(s), ends with je to 0x0050b7f6 (forward)
    test edi, edi                                # 0050b798
    je.d8 L_0050b7f6                             # 0050b79a
    # block 0x0050b79c: entered by fall-through of je at 0x0050b79a, 4 instruction(s), ends with je to 0x0050b7df (forward)
    mov ecx, dword ptr [ebx + field_1c]          # 0050b79c
    {load} mov eax, ecx                          # 0050b79f
    {load} sub eax, edi                          # 0050b7a1
    je.d8 L_0050b7df                             # 0050b7a3
    # block 0x0050b7a5: entered by fall-through of je at 0x0050b7a3, 24 instruction(s), calls FUN_0050ed50, falls into the block at 0x0050b7df
    mov eax, dword ptr [ebx + field_10]          # 0050b7a5
    {load} mov edx, edi                          # 0050b7a8
    shl edx, 0x1e                                # 0050b7aa
    {load} sub edx, edi                          # 0050b7ad
    {load} add edx, ecx                          # 0050b7af
    lea ecx, [eax + 4*edi]                       # 0050b7b1
    shl edx, 0x2                                 # 0050b7b4
    push edx                                     # 0050b7b7
    push ecx                                     # 0050b7b8
    push eax                                     # 0050b7b9
    call FUN_0050ed50                            # 0050b7ba
    mov ecx, dword ptr [ebx + field_1c]          # 0050b7bf
    mov eax, dword ptr [ebx + field_14]          # 0050b7c2
    {load} mov edx, edi                          # 0050b7c5
    shl edx, 0x1d                                # 0050b7c7
    {load} sub edx, edi                          # 0050b7ca
    {load} add edx, ecx                          # 0050b7cc
    lea ecx, [eax + 8*edi]                       # 0050b7ce
    shl edx, 0x3                                 # 0050b7d1
    push edx                                     # 0050b7d4
    push ecx                                     # 0050b7d5
    push eax                                     # 0050b7d6
    call FUN_0050ed50                            # 0050b7d7
    add esp, 0x18                                # 0050b7dc
L_0050b7df:
    # block 0x0050b7df: entered by je at 0x0050b7a3, 7 instruction(s), falls into the block at 0x0050b7f6
    mov ecx, dword ptr [ebx + field_1c]          # 0050b7df
    mov eax, dword ptr [ebx + field_20]          # 0050b7e2
    {load} sub ecx, edi                          # 0050b7e5
    {load} sub eax, edi                          # 0050b7e7
    mov dword ptr [ebx + field_1c], ecx          # 0050b7e9
    mov dword ptr [ebx + field_20], eax          # 0050b7ec
    mov dword ptr [ebx + field_24], 0x0          # 0050b7ef
L_0050b7f6:
    # block 0x0050b7f6: entered by je at 0x0050b79a, 4 instruction(s), ends with je to 0x0050b80f (forward)
    mov edx, dword ptr [esp + stk_24]            # 0050b7f6
    mov eax, dword ptr [ebx + field_14e]         # 0050b7fa
    {load} cmp edx, eax                          # 0050b800
    je.d8 L_0050b80f                             # 0050b802
    # block 0x0050b804: entered by fall-through of je at 0x0050b802, 7 instruction(s), ends with ret
    pop edi                                      # 0050b804
    pop esi                                      # 0050b805
    pop ebp                                      # 0050b806
    or eax, -0x1                                 # 0050b807
    pop ebx                                      # 0050b80a
    add esp, 0x2c                                # 0050b80b
    ret                                          # 0050b80e
L_0050b80f:
    # block 0x0050b80f: entered by je at 0x0050b802, 3 instruction(s), ends with jle to 0x0050b822 (forward)
    mov eax, dword ptr [esp + stk_28]            # 0050b80f
    test eax, eax                                # 0050b813
    jle.d8 L_0050b822                            # 0050b815
    # block 0x0050b817: entered by fall-through of jle at 0x0050b815, 7 instruction(s), ends with ret
    pop edi                                      # 0050b817
    pop esi                                      # 0050b818
    pop ebp                                      # 0050b819
    or eax, -0x1                                 # 0050b81a
    pop ebx                                      # 0050b81d
    add esp, 0x2c                                # 0050b81e
    ret                                          # 0050b821
L_0050b822:
    # block 0x0050b822: entered by jle at 0x0050b815, 10 instruction(s), calls FUN_0050b460, ends with je to 0x0050b8d3 (forward)
    mov eax, dword ptr [esp + stk_44]            # 0050b822
    inc eax                                      # 0050b826
    push eax                                     # 0050b827
    push ebx                                     # 0050b828
    call FUN_0050b460                            # 0050b829
    mov eax, dword ptr [ebx + field_152]         # 0050b82e
    mov ecx, dword ptr [esp + stk_28]            # 0050b834
    add esp, 0x8                                 # 0050b838
    {load} cmp ecx, eax                          # 0050b83b
    je.d32 L_0050b8d3                            # 0050b83d
    # block 0x0050b843: entered by fall-through of je at 0x0050b83d, 4 instruction(s), ends with jge to 0x0050b866 (forward)
    mov edx, dword ptr [ebx + field_20]          # 0050b843
    mov ecx, dword ptr [ebx + field_1c]          # 0050b846
    {load} cmp edx, ecx                          # 0050b849
    jge.d8 L_0050b866                            # 0050b84b
    # block 0x0050b84d: entered by fall-through of jge at 0x0050b84b, 3 instruction(s), falls into the block at 0x0050b855
    mov eax, dword ptr [ebx + field_10]          # 0050b84d
    {load} sub ecx, edx                          # 0050b850
    lea eax, [eax + 4*edx]                       # 0050b852
L_0050b855:
    # block 0x0050b855: entered by jne at 0x0050b864, 6 instruction(s), ends with jne to 0x0050b855 (backward)
    mov edi, dword ptr [eax]                     # 0050b855
    add eax, 0x4                                 # 0050b857
    and edi, 0xff                                # 0050b85a
    sub dword ptr [ebx + field_8], edi           # 0050b860
    dec ecx                                      # 0050b863
    jne.d8 L_0050b855                            # 0050b864
L_0050b866:
    # block 0x0050b866: entered by jge at 0x0050b84b; fall-through of jne at 0x0050b864, 4 instruction(s), ends with je to 0x0050b88c (forward)
    mov eax, dword ptr [ebx + field_152]         # 0050b866
    mov dword ptr [ebx + field_1c], edx          # 0050b86c
    cmp eax, -0x1                                # 0050b86f
    je.d8 L_0050b88c                             # 0050b872
    # block 0x0050b874: entered by fall-through of je at 0x0050b872, 8 instruction(s), falls into the block at 0x0050b88c
    mov ecx, dword ptr [ebx + field_10]          # 0050b874
    mov dword ptr [ecx + 4*edx], 0x400           # 0050b877
    mov ecx, dword ptr [ebx + field_1c]          # 0050b87e
    mov eax, dword ptr [ebx + field_20]          # 0050b881
    inc ecx                                      # 0050b884
    inc eax                                      # 0050b885
    mov dword ptr [ebx + field_1c], ecx          # 0050b886
    mov dword ptr [ebx + field_20], eax          # 0050b889
L_0050b88c:
    # block 0x0050b88c: entered by je at 0x0050b872, 3 instruction(s), ends with je to 0x0050b8d3 (forward)
    mov eax, dword ptr [esp + stk_2c]            # 0050b88c
    test eax, eax                                # 0050b890
    je.d8 L_0050b8d3                             # 0050b892
    # block 0x0050b894: entered by fall-through of je at 0x0050b892, 4 instruction(s), ends with jle to 0x0050b8d7 (forward)
    mov edi, dword ptr [esp + stk_44]            # 0050b894
    mov dword ptr [esp + stk_18], 0x0            # 0050b898
    test edi, edi                                # 0050b8a0
    jle.d8 L_0050b8d7                            # 0050b8a2
L_0050b8a4:
    # block 0x0050b8a4: entered by jl at 0x0050b8c4; fall-through of jle at 0x0050b8a2, 9 instruction(s), ends with jl to 0x0050b8cc (forward)
    mov edx, dword ptr [esp + stk_1c]            # 0050b8a4
    mov ecx, dword ptr [esp + stk_10]            # 0050b8a8
    {load} xor eax, eax                          # 0050b8ac
    mov al, byte ptr [edx + ebp + field_1b]      # 0050b8ae
    {load} add ecx, eax                          # 0050b8b2
    {load} sub esi, eax                          # 0050b8b4
    cmp eax, 0xff                                # 0050b8b6
    mov dword ptr [esp + stk_10], ecx            # 0050b8bb
    jl.d8 L_0050b8cc                             # 0050b8bf
    # block 0x0050b8c1: entered by fall-through of jl at 0x0050b8bf, 3 instruction(s), ends with jl to 0x0050b8a4 (backward)
    inc ebp                                      # 0050b8c1
    {load} cmp ebp, edi                          # 0050b8c2
    jl.d8 L_0050b8a4                             # 0050b8c4
    # block 0x0050b8c6: entered by fall-through of jl at 0x0050b8c4, 2 instruction(s), ends with forward jump to 0x0050b8d7
    mov dword ptr [esp + stk_14], esi            # 0050b8c6
    jmp.d8 L_0050b8d7                            # 0050b8ca
L_0050b8cc:
    # block 0x0050b8cc: entered by jl at 0x0050b8bf, 3 instruction(s), ends with forward jump to 0x0050b8d7
    mov dword ptr [esp + stk_14], esi            # 0050b8cc
    inc ebp                                      # 0050b8d0
    jmp.d8 L_0050b8d7                            # 0050b8d1
L_0050b8d3:
    # block 0x0050b8d3: entered by je at 0x0050b83d; je at 0x0050b892, 1 instruction(s), falls into the block at 0x0050b8d7
    mov edi, dword ptr [esp + stk_44]            # 0050b8d3
L_0050b8d7:
    # block 0x0050b8d7: entered by jle at 0x0050b8a2; jmp at 0x0050b8ca; jmp at 0x0050b8d1, 2 instruction(s), ends with je to 0x0050b910 (forward)
    test esi, esi                                # 0050b8d7
    je.d8 L_0050b910                             # 0050b8d9
    # block 0x0050b8db: entered by fall-through of je at 0x0050b8d9, 20 instruction(s), calls FUN_0050b430, falls into the block at 0x0050b910
    push esi                                     # 0050b8db
    push ebx                                     # 0050b8dc
    call FUN_0050b430                            # 0050b8dd
    mov edi, dword ptr [ebx + field_8]           # 0050b8e2
    mov eax, dword ptr [ebx]                     # 0050b8e5
    {load} mov ecx, esi                          # 0050b8e7
    mov esi, dword ptr [esp + stk_18]            # 0050b8e9
    {load} add edi, eax                          # 0050b8ed
    {load} mov eax, ecx                          # 0050b8ef
    shr ecx, 0x2                                 # 0050b8f1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0050b8f4
    {load} mov ecx, eax                          # 0050b8f6
    add esp, 0x8                                 # 0050b8f8
    and ecx, 0x3                                 # 0050b8fb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0050b8fe
    mov ecx, dword ptr [esp + stk_14]            # 0050b900
    mov eax, dword ptr [ebx + field_8]           # 0050b904
    mov edi, dword ptr [esp + stk_44]            # 0050b907
    {load} add eax, ecx                          # 0050b90b
    mov dword ptr [ebx + field_8], eax           # 0050b90d
L_0050b910:
    # block 0x0050b910: entered by je at 0x0050b8d9, 3 instruction(s), ends with jge to 0x0050b995 (forward)
    or edx, -0x1                                 # 0050b910
    {load} cmp ebp, edi                          # 0050b913
    jge.d8 L_0050b995                            # 0050b915
L_0050b917:
    # block 0x0050b917: entered by jl at 0x0050b97c; fall-through of jge at 0x0050b915, 13 instruction(s), ends with je to 0x0050b95e (forward)
    mov ecx, dword ptr [esp + stk_1c]            # 0050b917
    mov esi, dword ptr [ebx + field_10]          # 0050b91b
    {load} xor eax, eax                          # 0050b91e
    mov al, byte ptr [ecx + ebp + field_1b]      # 0050b920
    mov ecx, dword ptr [ebx + field_1c]          # 0050b924
    mov dword ptr [esi + 4*ecx], eax             # 0050b927
    mov ecx, dword ptr [ebx + field_1c]          # 0050b92a
    mov esi, dword ptr [ebx + field_14]          # 0050b92d
    mov dword ptr [esi + 8*ecx], 0xffffffff      # 0050b930
    mov dword ptr [esi + 8*ecx + field_4], 0xffffffff # 0050b937
    mov ecx, dword ptr [esp + stk_18]            # 0050b93f
    test ecx, ecx                                # 0050b943
    je.d8 L_0050b95e                             # 0050b945
    # block 0x0050b947: entered by fall-through of je at 0x0050b945, 5 instruction(s), falls into the block at 0x0050b95e
    mov ecx, dword ptr [ebx + field_1c]          # 0050b947
    mov esi, dword ptr [ebx + field_10]          # 0050b94a
    mov dword ptr [esp + stk_18], 0x0            # 0050b94d
    lea ecx, [esi + 4*ecx]                       # 0050b955
    or dword ptr [ecx], 0x100                    # 0050b958
L_0050b95e:
    # block 0x0050b95e: entered by je at 0x0050b945, 2 instruction(s), ends with jge to 0x0050b968 (forward)
    cmp eax, 0xff                                # 0050b95e
    jge.d8 L_0050b968                            # 0050b963
    # block 0x0050b965: entered by fall-through of jge at 0x0050b963, 1 instruction(s), falls into the block at 0x0050b968
    mov edx, dword ptr [ebx + field_1c]          # 0050b965
L_0050b968:
    # block 0x0050b968: entered by jge at 0x0050b963, 6 instruction(s), ends with jge to 0x0050b97a (forward)
    mov ecx, dword ptr [ebx + field_1c]          # 0050b968
    inc ecx                                      # 0050b96b
    inc ebp                                      # 0050b96c
    cmp eax, 0xff                                # 0050b96d
    mov dword ptr [ebx + field_1c], ecx          # 0050b972
    jge.d8 L_0050b97a                            # 0050b975
    # block 0x0050b977: entered by fall-through of jge at 0x0050b975, 1 instruction(s), falls into the block at 0x0050b97a
    mov dword ptr [ebx + field_20], ecx          # 0050b977
L_0050b97a:
    # block 0x0050b97a: entered by jge at 0x0050b975, 2 instruction(s), ends with jl to 0x0050b917 (backward)
    {load} cmp ebp, edi                          # 0050b97a
    jl.d8 L_0050b917                             # 0050b97c
    # block 0x0050b97e: entered by fall-through of jl at 0x0050b97c, 2 instruction(s), ends with je to 0x0050b995 (forward)
    cmp edx, -0x1                                # 0050b97e
    je.d8 L_0050b995                             # 0050b981
    # block 0x0050b983: entered by fall-through of je at 0x0050b981, 5 instruction(s), falls into the block at 0x0050b995
    mov eax, dword ptr [ebx + field_14]          # 0050b983
    mov ecx, dword ptr [esp + stk_34]            # 0050b986
    mov dword ptr [eax + 8*edx], ecx             # 0050b98a
    mov ecx, dword ptr [esp + stk_38]            # 0050b98d
    mov dword ptr [eax + 8*edx + field_4], ecx   # 0050b991
L_0050b995:
    # block 0x0050b995: entered by jge at 0x0050b915; je at 0x0050b981, 3 instruction(s), ends with je to 0x0050b9be (forward)
    mov eax, dword ptr [esp + stk_30]            # 0050b995
    test eax, eax                                # 0050b999
    je.d8 L_0050b9be                             # 0050b99b
    # block 0x0050b99d: entered by fall-through of je at 0x0050b99b, 4 instruction(s), ends with jle to 0x0050b9be (forward)
    mov eax, dword ptr [ebx + field_1c]          # 0050b99d
    mov dword ptr [ebx + field_146], 0x1         # 0050b9a0
    test eax, eax                                # 0050b9aa
    jle.d8 L_0050b9be                            # 0050b9ac
    # block 0x0050b9ae: entered by fall-through of jle at 0x0050b9ac, 5 instruction(s), falls into the block at 0x0050b9be
    mov edx, dword ptr [ebx + field_10]          # 0050b9ae
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0050b9b1
    lea eax, [edx + 4*eax - field_minus_4]       # 0050b9b5
    or ch, 0x2                                   # 0050b9b9
    mov dword ptr [eax], ecx                     # 0050b9bc
L_0050b9be:
    # block 0x0050b9be: entered by je at 0x0050b99b; jle at 0x0050b9ac, 10 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_20]            # 0050b9be
    pop edi                                      # 0050b9c2
    inc eax                                      # 0050b9c3
    pop esi                                      # 0050b9c4
    mov dword ptr [ebx + field_152], eax         # 0050b9c5
    pop ebp                                      # 0050b9cb
    {load} xor eax, eax                          # 0050b9cc
    pop ebx                                      # 0050b9ce
    add esp, 0x2c                                # 0050b9cf
    ret                                          # 0050b9d2

# --- data items (not part of the function) -------------------------
.org 0x0050b9d3 - 0x401000
PAD_0050b9d3:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

