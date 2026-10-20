# FUN_004c1716
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c1716
# extent:       0x004c1716-0x004c2790 (4218 code bytes)
# span:         0x004c1716-0x004c2790 (code 4218, tables 0, padding 0)
# sha256:       de0fc75c6b3351d1ec17951f50cfcfd74609eb50bc3a928152f485fc03645e91
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c1716
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_1c, local_3c, local_60, local_70, local_74, local_78, local_7c, local_80, local_84, local_88 and 4 more
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_1c, field_30, field_42, field_46, field_50, field_58, field_5c, field_c4e and 7 more; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1a, field_20, field_46, field_50, field_54, field_58 and 15 more; [edx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1a, field_c52, field_c56, field_c5a, field_c5e, field_d56 and 8 more
# callees:      calls FUN_0044a2b7, FUN_004264e8, FUN_004c97b4, FUN_004fcebe, FUN_004c88c7, FUN_0042639d, FUN_004ca92e, FUN_004bf297, FUN_004bf3b8, FUN_0050ca3e, FUN_0052139c, FUN_004c98b5, FUN_0051dc43, FUN_004c2e97, FUN_004c2c3a, FUN_004c2a8d and 1 more; plus 12 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1019 instruction(s), 80 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_1c, 0x1c  # offset -0x1c
.equ local_3c, 0x3c  # offset -0x3c
.equ local_60, 0x60  # offset -0x60
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_30, 0x30  # offset +0x30
.equ field_42, 0x42  # offset +0x42
.equ field_46, 0x46  # offset +0x46
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_9c, 0x9c  # offset +0x9c
.equ field_308, 0x308  # offset +0x308
.equ field_c4e, 0xc4e  # offset +0xc4e
.equ field_c52, 0xc52  # offset +0xc52
.equ field_c56, 0xc56  # offset +0xc56
.equ field_c5a, 0xc5a  # offset +0xc5a
.equ field_c5e, 0xc5e  # offset +0xc5e
.equ field_c62, 0xc62  # offset +0xc62
.equ field_c66, 0xc66  # offset +0xc66
.equ field_c6a, 0xc6a  # offset +0xc6a
.equ field_c6e, 0xc6e  # offset +0xc6e
.equ field_d56, 0xd56  # offset +0xd56
.equ field_d5a, 0xd5a  # offset +0xd5a
.equ field_d62, 0xd62  # offset +0xd62
.equ field_df6, 0xdf6  # offset +0xdf6
.equ field_dfa, 0xdfa  # offset +0xdfa
.equ field_e42, 0xe42  # offset +0xe42
.equ field_e4a, 0xe4a  # offset +0xe4a
.equ field_e72, 0xe72  # offset +0xe72
.equ field_175c, 0x175c  # offset +0x175c
.equ field_1f24, 0x1f24  # offset +0x1f24
.equ field_1f2c, 0x1f2c  # offset +0x1f2c
.equ field_38ac, 0x38ac  # offset +0x38ac
.equ field_38b8, 0x38b8  # offset +0x38b8
.equ field_38bc, 0x38bc  # offset +0x38bc

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00446ffb, .text + (0x00446ffb - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bf297, .text + (0x004bf297 - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c2c3a, .text + (0x004c2c3a - 0x401000)
.set FUN_004c2e97, .text + (0x004c2e97 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004c98b5, .text + (0x004c98b5 - 0x401000)
.set FUN_004ca92e, .text + (0x004ca92e - 0x401000)
.set FUN_004fcebe, .text + (0x004fcebe - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c1716 - 0x401000
.globl FUN_004c1716
FUN_004c1716:
    # block 0x004c1716: entry, 9 instruction(s), ends with je to 0x004c173f (forward)
    push ebp                                     # 004c1716
    {load} mov ebp, esp                          # 004c1717
    sub esp, 0x98                                # 004c1719
    push esi                                     # 004c171f
    push edi                                     # 004c1720
    mov dword ptr [ebp - local_90], ecx          # 004c1721
    movsx eax, word ptr [0x63a4cd]               # 004c1727
    test eax, eax                                # 004c172e
    je.d8 L_004c173f                             # 004c1730
    # block 0x004c1732: entered by fall-through of je at 0x004c1730, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c173f
    push 0x552de8                                # 004c1732
    call FUN_0044a2b7                            # 004c1737
    add esp, 0x4                                 # 004c173c
L_004c173f:
    # block 0x004c173f: entered by je at 0x004c1730, 4 instruction(s), ends with jne to 0x004c1773 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c173f
    mov edx, dword ptr [ecx + field_1f24]        # 004c1745
    cmp dword ptr [edx + field_175c], -0x1       # 004c174b
    jne.d8 L_004c1773                            # 004c1752
    # block 0x004c1754: entered by fall-through of jne at 0x004c1752, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c2788
    push 0x552e04                                # 004c1754
    mov ecx, 0x583979                            # 004c1759
    call FUN_004264e8                            # 004c175e
    mov ecx, dword ptr [ebp - local_90]          # 004c1763
    call FUN_004c97b4                            # 004c1769
    jmp.d32 L_004c2788                           # 004c176e
L_004c1773:
    # block 0x004c1773: entered by jne at 0x004c1752, 13 instruction(s), ends with jne to 0x004c17c3 (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c1773
    mov ecx, dword ptr [eax + field_1f24]        # 004c1779
    mov edx, dword ptr [ecx + field_175c]        # 004c177f
    imul edx, edx, 0x3e4                         # 004c1785
    mov eax, dword ptr [ebp - local_90]          # 004c178b
    mov ecx, dword ptr [eax + field_1f24]        # 004c1791
    {load} add ecx, edx                          # 004c1797
    mov edx, dword ptr [ebp - local_90]          # 004c1799
    mov dword ptr [edx + field_1f2c], ecx        # 004c179f
    mov eax, dword ptr [ebp - local_90]          # 004c17a5
    mov ecx, dword ptr [eax + field_1f2c]        # 004c17ab
    cmp dword ptr [ecx + field_308], 0x0         # 004c17b1
    jne.d8 L_004c17c3                            # 004c17b8
    # block 0x004c17ba: entered by fall-through of jne at 0x004c17b8, 2 instruction(s), ends with forward jump to 0x004c17d7
    mov dword ptr [ebp - local_8], 0x0           # 004c17ba
    jmp.d8 L_004c17d7                            # 004c17c1
L_004c17c3:
    # block 0x004c17c3: entered by jne at 0x004c17b8, 4 instruction(s), falls into the block at 0x004c17d7
    mov edx, dword ptr [ebp - local_90]          # 004c17c3
    mov eax, dword ptr [edx + field_1f2c]        # 004c17c9
    add eax, 0x30c                               # 004c17cf
    mov dword ptr [ebp - local_8], eax           # 004c17d4
L_004c17d7:
    # block 0x004c17d7: entered by jmp at 0x004c17c1, 11 instruction(s), calls FUN_004fcebe, ends with jge to 0x004c1829 (forward)
    push 0x0                                     # 004c17d7
    push 0x52e56c                                # 004c17d9
    mov ecx, dword ptr [ebp - local_90]          # 004c17de
    add ecx, 0x4                                 # 004c17e4
    push ecx                                     # 004c17e7
    mov edx, dword ptr [ebp - local_8]           # 004c17e8
    push edx                                     # 004c17eb
    call FUN_004fcebe                            # 004c17ec
    mov dword ptr [ebp - local_4], eax           # 004c17f1
    cmp dword ptr [ebp - local_4], 0x0           # 004c17f4
    jge.d8 L_004c1829                            # 004c17f8
    # block 0x004c17fa: entered by fall-through of jge at 0x004c17f8, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov eax, dword ptr [ebp - local_4]           # 004c17fa
    push eax                                     # 004c17fd
    mov ecx, dword ptr [ebp - local_90]          # 004c17fe
    call FUN_004c88c7                            # 004c1804
    push eax                                     # 004c1809
    push 0x552e48                                # 004c180a
    mov ecx, 0x583979                            # 004c180f
    call FUN_0042639d                            # 004c1814
    mov ecx, dword ptr [ebp - local_90]          # 004c1819
    call FUN_004c97b4                            # 004c181f
    jmp.d32 L_004c2788                           # 004c1824
L_004c1829:
    # block 0x004c1829: entered by jge at 0x004c17f8, 3 instruction(s), ends with je to 0x004c1841 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004c1829
    test ecx, ecx                                # 004c1830
    je.d8 L_004c1841                             # 004c1832
    # block 0x004c1834: entered by fall-through of je at 0x004c1832, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1841
    push 0x552ec4                                # 004c1834
    call FUN_0044a2b7                            # 004c1839
    add esp, 0x4                                 # 004c183e
L_004c1841:
    # block 0x004c1841: entered by je at 0x004c1832, 3 instruction(s), ends with je to 0x004c1873 (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c1841
    cmp dword ptr [edx + field_38ac], 0x0        # 004c1847
    je.d8 L_004c1873                             # 004c184e
    # block 0x004c1850: entered by fall-through of je at 0x004c184e, 12 instruction(s), calls indirect dword ptr [eax + 0x50], ends with forward jump to 0x004c1894
    push 0x8                                     # 004c1850
    mov eax, dword ptr [ebp + arg_8]             # 004c1852
    push eax                                     # 004c1855
    mov ecx, dword ptr [ebp - local_90]          # 004c1856
    mov edx, dword ptr [ecx + field_4]           # 004c185c
    mov eax, dword ptr [ebp - local_90]          # 004c185f
    mov ecx, dword ptr [eax + field_4]           # 004c1865
    mov eax, dword ptr [ecx]                     # 004c1868
    push edx                                     # 004c186a
    call dword ptr [eax + field_50]              # 004c186b
    mov dword ptr [ebp - local_4], eax           # 004c186e
    jmp.d8 L_004c1894                            # 004c1871
L_004c1873:
    # block 0x004c1873: entered by je at 0x004c184e, 11 instruction(s), calls indirect dword ptr [ecx + 0x50], falls into the block at 0x004c1894
    push 0x13                                    # 004c1873
    mov ecx, dword ptr [ebp + arg_8]             # 004c1875
    push ecx                                     # 004c1878
    mov edx, dword ptr [ebp - local_90]          # 004c1879
    mov eax, dword ptr [edx + field_4]           # 004c187f
    mov ecx, dword ptr [ebp - local_90]          # 004c1882
    mov edx, dword ptr [ecx + field_4]           # 004c1888
    mov ecx, dword ptr [edx]                     # 004c188b
    push eax                                     # 004c188d
    call dword ptr [ecx + field_50]              # 004c188e
    mov dword ptr [ebp - local_4], eax           # 004c1891
L_004c1894:
    # block 0x004c1894: entered by jmp at 0x004c1871, 2 instruction(s), ends with jge to 0x004c18c9 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004c1894
    jge.d8 L_004c18c9                            # 004c1898
    # block 0x004c189a: entered by fall-through of jge at 0x004c1898, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c189a
    push edx                                     # 004c189d
    mov ecx, dword ptr [ebp - local_90]          # 004c189e
    call FUN_004c88c7                            # 004c18a4
    push eax                                     # 004c18a9
    push 0x552ee4                                # 004c18aa
    mov ecx, 0x583979                            # 004c18af
    call FUN_0042639d                            # 004c18b4
    mov ecx, dword ptr [ebp - local_90]          # 004c18b9
    call FUN_004c97b4                            # 004c18bf
    jmp.d32 L_004c2788                           # 004c18c4
L_004c18c9:
    # block 0x004c18c9: entered by jge at 0x004c1898, 3 instruction(s), ends with je to 0x004c18e1 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c18c9
    test eax, eax                                # 004c18d0
    je.d8 L_004c18e1                             # 004c18d2
    # block 0x004c18d4: entered by fall-through of je at 0x004c18d2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c18e1
    push 0x552f10                                # 004c18d4
    call FUN_0044a2b7                            # 004c18d9
    add esp, 0x4                                 # 004c18de
L_004c18e1:
    # block 0x004c18e1: entered by je at 0x004c18d2, 3 instruction(s), ends with jne to 0x004c1978 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c18e1
    cmp dword ptr [ecx + field_38ac], 0x0        # 004c18e7
    jne.d32 L_004c1978                           # 004c18ee
    # block 0x004c18f4: entered by fall-through of jne at 0x004c18ee, 18 instruction(s), calls indirect dword ptr [ecx + 0x54], ends with jge to 0x004c1960 (forward)
    push 0x0                                     # 004c18f4
    push 0x0                                     # 004c18f6
    movsx edx, word ptr [0x639893]               # 004c18f8
    push edx                                     # 004c18ff
    movsx eax, word ptr [0x63988d]               # 004c1900
    push eax                                     # 004c1907
    movsx ecx, word ptr [0x63988b]               # 004c1908
    push ecx                                     # 004c190f
    mov edx, dword ptr [ebp - local_90]          # 004c1910
    mov eax, dword ptr [edx + field_4]           # 004c1916
    mov ecx, dword ptr [ebp - local_90]          # 004c1919
    mov edx, dword ptr [ecx + field_4]           # 004c191f
    mov ecx, dword ptr [edx]                     # 004c1922
    push eax                                     # 004c1924
    call dword ptr [ecx + field_54]              # 004c1925
    mov dword ptr [ebp - local_4], eax           # 004c1928
    cmp dword ptr [ebp - local_4], 0x0           # 004c192b
    jge.d8 L_004c1960                            # 004c192f
    # block 0x004c1931: entered by fall-through of jge at 0x004c192f, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c1931
    push edx                                     # 004c1934
    mov ecx, dword ptr [ebp - local_90]          # 004c1935
    call FUN_004c88c7                            # 004c193b
    push eax                                     # 004c1940
    push 0x552f2c                                # 004c1941
    mov ecx, 0x583979                            # 004c1946
    call FUN_0042639d                            # 004c194b
    mov ecx, dword ptr [ebp - local_90]          # 004c1950
    call FUN_004c97b4                            # 004c1956
    jmp.d32 L_004c2788                           # 004c195b
L_004c1960:
    # block 0x004c1960: entered by jge at 0x004c192f, 3 instruction(s), ends with je to 0x004c1978 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c1960
    test eax, eax                                # 004c1967
    je.d8 L_004c1978                             # 004c1969
    # block 0x004c196b: entered by fall-through of je at 0x004c1969, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1978
    push 0x552f54                                # 004c196b
    call FUN_0044a2b7                            # 004c1970
    add esp, 0x4                                 # 004c1975
L_004c1978:
    # block 0x004c1978: entered by jne at 0x004c18ee; je at 0x004c1969, 3 instruction(s), ends with je to 0x004c1a80 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c1978
    cmp dword ptr [ecx + field_38ac], 0x0        # 004c197e
    je.d32 L_004c1a80                            # 004c1985
    # block 0x004c198b: entered by fall-through of je at 0x004c1985, 20 instruction(s), calls indirect dword ptr [eax + 0x30], ends with jge to 0x004c1a0c (forward)
    mov ecx, 0x1f                                # 004c198b
    {load} xor eax, eax                          # 004c1990
    mov edi, dword ptr [ebp - local_90]          # 004c1992
    add edi, 0xdf6                               # 004c1998
    rep stosd dword ptr es:[edi], eax            # 004c199e
    mov edx, dword ptr [ebp - local_90]          # 004c19a0
    mov dword ptr [edx + field_df6], 0x7c        # 004c19a6
    mov eax, dword ptr [ebp - local_90]          # 004c19b0
    add eax, 0xdf6                               # 004c19b6
    push eax                                     # 004c19bb
    mov ecx, dword ptr [ebp - local_90]          # 004c19bc
    mov edx, dword ptr [ecx + field_4]           # 004c19c2
    mov eax, dword ptr [ebp - local_90]          # 004c19c5
    mov ecx, dword ptr [eax + field_4]           # 004c19cb
    mov eax, dword ptr [ecx]                     # 004c19ce
    push edx                                     # 004c19d0
    call dword ptr [eax + field_30]              # 004c19d1
    mov dword ptr [ebp - local_4], eax           # 004c19d4
    cmp dword ptr [ebp - local_4], 0x0           # 004c19d7
    jge.d8 L_004c1a0c                            # 004c19db
    # block 0x004c19dd: entered by fall-through of jge at 0x004c19db, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov ecx, dword ptr [ebp - local_4]           # 004c19dd
    push ecx                                     # 004c19e0
    mov ecx, dword ptr [ebp - local_90]          # 004c19e1
    call FUN_004c88c7                            # 004c19e7
    push eax                                     # 004c19ec
    push 0x552f84                                # 004c19ed
    mov ecx, 0x583979                            # 004c19f2
    call FUN_0042639d                            # 004c19f7
    mov ecx, dword ptr [ebp - local_90]          # 004c19fc
    call FUN_004c97b4                            # 004c1a02
    jmp.d32 L_004c2788                           # 004c1a07
L_004c1a0c:
    # block 0x004c1a0c: entered by jge at 0x004c19db, 5 instruction(s), ends with je to 0x004c1a49 (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c1a0c
    mov eax, dword ptr [edx + field_dfa]         # 004c1a12
    and eax, 0x1000                              # 004c1a18
    test eax, eax                                # 004c1a1d
    je.d8 L_004c1a49                             # 004c1a1f
    # block 0x004c1a21: entered by fall-through of je at 0x004c1a1f, 5 instruction(s), ends with je to 0x004c1a49 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c1a21
    mov edx, dword ptr [ecx + field_e42]         # 004c1a27
    and edx, 0x40                                # 004c1a2d
    test edx, edx                                # 004c1a30
    je.d8 L_004c1a49                             # 004c1a32
    # block 0x004c1a34: entered by fall-through of je at 0x004c1a32, 4 instruction(s), ends with je to 0x004c1a68 (forward)
    movsx eax, word ptr [0x639893]               # 004c1a34
    mov ecx, dword ptr [ebp - local_90]          # 004c1a3b
    cmp dword ptr [ecx + field_e4a], eax         # 004c1a41
    je.d8 L_004c1a68                             # 004c1a47
L_004c1a49:
    # block 0x004c1a49: entered by je at 0x004c1a1f; je at 0x004c1a32; fall-through of je at 0x004c1a47, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c2788
    push 0x552fac                                # 004c1a49
    mov ecx, 0x583979                            # 004c1a4e
    call FUN_004264e8                            # 004c1a53
    mov ecx, dword ptr [ebp - local_90]          # 004c1a58
    call FUN_004c97b4                            # 004c1a5e
    jmp.d32 L_004c2788                           # 004c1a63
L_004c1a68:
    # block 0x004c1a68: entered by je at 0x004c1a47, 3 instruction(s), ends with je to 0x004c1a80 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c1a68
    test edx, edx                                # 004c1a6f
    je.d8 L_004c1a80                             # 004c1a71
    # block 0x004c1a73: entered by fall-through of je at 0x004c1a71, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1a80
    push 0x55304c                                # 004c1a73
    call FUN_0044a2b7                            # 004c1a78
    add esp, 0x4                                 # 004c1a7d
L_004c1a80:
    # block 0x004c1a80: entered by je at 0x004c1985; je at 0x004c1a71, 3 instruction(s), ends with je to 0x004c1ade (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c1a80
    test eax, eax                                # 004c1a87
    je.d8 L_004c1ade                             # 004c1a89
    # block 0x004c1a8b: entered by fall-through of je at 0x004c1a89, 18 instruction(s), calls FUN_0044a2b7, FUN_004ca92e, falls into the block at 0x004c1ade
    push 0x553080                                # 004c1a8b
    call FUN_0044a2b7                            # 004c1a90
    add esp, 0x4                                 # 004c1a95
    mov ecx, dword ptr [ebp - local_90]          # 004c1a98
    mov edx, dword ptr [ecx + field_1f2c]        # 004c1a9e
    add edx, 0x8                                 # 004c1aa4
    push edx                                     # 004c1aa7
    mov ecx, dword ptr [ebp - local_90]          # 004c1aa8
    call FUN_004ca92e                            # 004c1aae
    push 0x5530a0                                # 004c1ab3
    call FUN_0044a2b7                            # 004c1ab8
    add esp, 0x4                                 # 004c1abd
    mov eax, dword ptr [ebp - local_90]          # 004c1ac0
    mov ecx, dword ptr [eax + field_1f2c]        # 004c1ac6
    add ecx, 0x184                               # 004c1acc
    push ecx                                     # 004c1ad2
    mov ecx, dword ptr [ebp - local_90]          # 004c1ad3
    call FUN_004ca92e                            # 004c1ad9
L_004c1ade:
    # block 0x004c1ade: entered by je at 0x004c1a89, 8 instruction(s), ends with je to 0x004c1b16 (forward)
    mov ecx, 0x1f                                # 004c1ade
    {load} xor eax, eax                          # 004c1ae3
    lea edi, [ebp - local_84]                    # 004c1ae5
    rep stosd dword ptr es:[edi], eax            # 004c1aeb
    mov dword ptr [ebp - local_84], 0x7c         # 004c1aed
    mov edx, dword ptr [ebp - local_90]          # 004c1af7
    cmp dword ptr [edx + field_38ac], 0x0        # 004c1afd
    je.d8 L_004c1b16                             # 004c1b04
    # block 0x004c1b06: entered by fall-through of je at 0x004c1b04, 3 instruction(s), ends with forward jump to 0x004c1b24
    mov dword ptr [ebp - local_80], 0x1          # 004c1b06
    mov dword ptr [ebp - local_1c], 0x200        # 004c1b0d
    jmp.d8 L_004c1b24                            # 004c1b14
L_004c1b16:
    # block 0x004c1b16: entered by je at 0x004c1b04, 2 instruction(s), falls into the block at 0x004c1b24
    mov dword ptr [ebp - local_80], 0x1          # 004c1b16
    mov dword ptr [ebp - local_1c], 0x10004200   # 004c1b1d
L_004c1b24:
    # block 0x004c1b24: entered by jmp at 0x004c1b14, 16 instruction(s), calls indirect dword ptr [ecx + 0x18], ends with jge to 0x004c1b91 (forward)
    push 0x0                                     # 004c1b24
    mov eax, dword ptr [ebp - local_90]          # 004c1b26
    add eax, 0x8                                 # 004c1b2c
    push eax                                     # 004c1b2f
    lea ecx, [ebp - local_84]                    # 004c1b30
    push ecx                                     # 004c1b36
    mov edx, dword ptr [ebp - local_90]          # 004c1b37
    mov eax, dword ptr [edx + field_4]           # 004c1b3d
    mov ecx, dword ptr [ebp - local_90]          # 004c1b40
    mov edx, dword ptr [ecx + field_4]           # 004c1b46
    mov ecx, dword ptr [edx]                     # 004c1b49
    push eax                                     # 004c1b4b
    call dword ptr [ecx + field_18]              # 004c1b4c
    mov dword ptr [ebp - local_4], eax           # 004c1b4f
    cmp dword ptr [ebp - local_4], 0x0           # 004c1b52
    jge.d8 L_004c1b91                            # 004c1b56
    # block 0x004c1b58: entered by fall-through of jge at 0x004c1b56, 12 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c1b58
    push edx                                     # 004c1b5b
    mov ecx, dword ptr [ebp - local_90]          # 004c1b5c
    call FUN_004c88c7                            # 004c1b62
    push eax                                     # 004c1b67
    push 0x5530c0                                # 004c1b68
    mov ecx, 0x583979                            # 004c1b6d
    call FUN_0042639d                            # 004c1b72
    mov dword ptr [0x5bb20c], 0x1                # 004c1b77
    mov ecx, dword ptr [ebp - local_90]          # 004c1b81
    call FUN_004c97b4                            # 004c1b87
    jmp.d32 L_004c2788                           # 004c1b8c
L_004c1b91:
    # block 0x004c1b91: entered by jge at 0x004c1b56, 8 instruction(s), calls FUN_004bf297, ends with je to 0x004c1c1d (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c1b91
    mov ecx, dword ptr [eax + field_8]           # 004c1b97
    push ecx                                     # 004c1b9a
    mov ecx, 0x6201f9                            # 004c1b9b
    call FUN_004bf297                            # 004c1ba0
    mov dword ptr [ebp - local_88], eax          # 004c1ba5
    cmp dword ptr [ebp - local_88], 0x0          # 004c1bab
    je.d8 L_004c1c1d                             # 004c1bb2
    # block 0x004c1bb4: entered by fall-through of je at 0x004c1bb2, 2 instruction(s), ends with je to 0x004c1c1d (forward)
    cmp dword ptr [ebp - local_88], -0x2         # 004c1bb4
    je.d8 L_004c1c1d                             # 004c1bbb
    # block 0x004c1bbd: entered by fall-through of je at 0x004c1bbb, 14 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004c1c03 (forward)
    push 0x0                                     # 004c1bbd
    mov ecx, 0x6201f9                            # 004c1bbf
    call FUN_004bf3b8                            # 004c1bc4
    push eax                                     # 004c1bc9
    push 0x553130                                # 004c1bca
    push 0x63888b                                # 004c1bcf
    call FUN_0050ca3e                            # 004c1bd4
    add esp, 0xc                                 # 004c1bd9
    push 0x63888b                                # 004c1bdc
    mov ecx, 0x583979                            # 004c1be1
    call FUN_004264e8                            # 004c1be6
    movsx edx, word ptr [0x63a4cd]               # 004c1beb
    test edx, edx                                # 004c1bf2
    je.d8 L_004c1c03                             # 004c1bf4
    # block 0x004c1bf6: entered by fall-through of je at 0x004c1bf4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1c03
    push 0x63888b                                # 004c1bf6
    call FUN_0044a2b7                            # 004c1bfb
    add esp, 0x4                                 # 004c1c00
L_004c1c03:
    # block 0x004c1c03: entered by je at 0x004c1bf4, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004c2788
    mov dword ptr [0x5bb20c], 0x1                # 004c1c03
    mov ecx, dword ptr [ebp - local_90]          # 004c1c0d
    call FUN_004c97b4                            # 004c1c13
    jmp.d32 L_004c2788                           # 004c1c18
L_004c1c1d:
    # block 0x004c1c1d: entered by je at 0x004c1bb2; je at 0x004c1bbb, 18 instruction(s), calls indirect dword ptr [eax + 0x58], ends with jge to 0x004c1c94 (forward)
    mov ecx, 0x1f                                # 004c1c1d
    {load} xor eax, eax                          # 004c1c22
    lea edi, [ebp - local_84]                    # 004c1c24
    rep stosd dword ptr es:[edi], eax            # 004c1c2a
    mov dword ptr [ebp - local_84], 0x7c         # 004c1c2c
    mov dword ptr [ebp - local_80], 0xfff9ee     # 004c1c36
    lea eax, [ebp - local_84]                    # 004c1c3d
    push eax                                     # 004c1c43
    mov ecx, dword ptr [ebp - local_90]          # 004c1c44
    mov edx, dword ptr [ecx + field_8]           # 004c1c4a
    mov eax, dword ptr [ebp - local_90]          # 004c1c4d
    mov ecx, dword ptr [eax + field_8]           # 004c1c53
    mov eax, dword ptr [ecx]                     # 004c1c56
    push edx                                     # 004c1c58
    call dword ptr [eax + field_58]              # 004c1c59
    mov dword ptr [ebp - local_4], eax           # 004c1c5c
    cmp dword ptr [ebp - local_4], 0x0           # 004c1c5f
    jge.d8 L_004c1c94                            # 004c1c63
    # block 0x004c1c65: entered by fall-through of jge at 0x004c1c63, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov ecx, dword ptr [ebp - local_4]           # 004c1c65
    push ecx                                     # 004c1c68
    mov ecx, dword ptr [ebp - local_90]          # 004c1c69
    call FUN_004c88c7                            # 004c1c6f
    push eax                                     # 004c1c74
    push 0x553180                                # 004c1c75
    mov ecx, 0x583979                            # 004c1c7a
    call FUN_0042639d                            # 004c1c7f
    mov ecx, dword ptr [ebp - local_90]          # 004c1c84
    call FUN_004c97b4                            # 004c1c8a
    jmp.d32 L_004c2788                           # 004c1c8f
L_004c1c94:
    # block 0x004c1c94: entered by jge at 0x004c1c63, 2 instruction(s), ends with je to 0x004c1ca6 (forward)
    cmp dword ptr [ebp - local_7c], 0x0          # 004c1c94
    je.d8 L_004c1ca6                             # 004c1c98
    # block 0x004c1c9a: entered by fall-through of je at 0x004c1c98, 2 instruction(s), ends with je to 0x004c1ca6 (forward)
    cmp dword ptr [ebp - local_78], 0x0          # 004c1c9a
    je.d8 L_004c1ca6                             # 004c1c9e
    # block 0x004c1ca0: entered by fall-through of je at 0x004c1c9e, 2 instruction(s), ends with jne to 0x004c1ce6 (forward)
    cmp dword ptr [ebp - local_74], 0x0          # 004c1ca0
    jne.d8 L_004c1ce6                            # 004c1ca4
L_004c1ca6:
    # block 0x004c1ca6: entered by je at 0x004c1c98; je at 0x004c1c9e; fall-through of jne at 0x004c1ca4, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_74]          # 004c1ca6
    push edx                                     # 004c1ca9
    mov eax, dword ptr [ebp - local_70]          # 004c1caa
    push eax                                     # 004c1cad
    mov ecx, dword ptr [ebp - local_78]          # 004c1cae
    push ecx                                     # 004c1cb1
    mov edx, dword ptr [ebp - local_7c]          # 004c1cb2
    push edx                                     # 004c1cb5
    push 0x5531b0                                # 004c1cb6
    push 0x63888b                                # 004c1cbb
    call FUN_0050ca3e                            # 004c1cc0
    add esp, 0x18                                # 004c1cc5
    push 0x0                                     # 004c1cc8
    push 0x0                                     # 004c1cca
    push 0x63888b                                # 004c1ccc
    call FUN_0052139c                            # 004c1cd1
    mov ecx, dword ptr [ebp - local_90]          # 004c1cd6
    call FUN_004c97b4                            # 004c1cdc
    jmp.d32 L_004c2788                           # 004c1ce1
L_004c1ce6:
    # block 0x004c1ce6: entered by jne at 0x004c1ca4, 3 instruction(s), ends with je to 0x004c1e4a (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c1ce6
    test eax, eax                                # 004c1ced
    je.d32 L_004c1e4a                            # 004c1cef
    # block 0x004c1cf5: entered by fall-through of je at 0x004c1cef, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004c1d3b (forward)
    mov ecx, dword ptr [ebp - local_74]          # 004c1cf5
    push ecx                                     # 004c1cf8
    mov edx, dword ptr [ebp - local_70]          # 004c1cf9
    push edx                                     # 004c1cfc
    mov eax, dword ptr [ebp - local_78]          # 004c1cfd
    push eax                                     # 004c1d00
    mov ecx, dword ptr [ebp - local_7c]          # 004c1d01
    push ecx                                     # 004c1d04
    push 0x553228                                # 004c1d05
    push 0x63888b                                # 004c1d0a
    call FUN_0050ca3e                            # 004c1d0f
    add esp, 0x18                                # 004c1d14
    push 0x63888b                                # 004c1d17
    call FUN_0044a2b7                            # 004c1d1c
    add esp, 0x4                                 # 004c1d21
    mov edx, dword ptr [ebp - local_1c]          # 004c1d24
    and edx, 0x4                                 # 004c1d27
    test edx, edx                                # 004c1d2a
    je.d8 L_004c1d3b                             # 004c1d2c
    # block 0x004c1d2e: entered by fall-through of je at 0x004c1d2c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1d3b
    push 0x553284                                # 004c1d2e
    call FUN_0044a2b7                            # 004c1d33
    add esp, 0x4                                 # 004c1d38
L_004c1d3b:
    # block 0x004c1d3b: entered by je at 0x004c1d2c, 4 instruction(s), ends with je to 0x004c1d52 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c1d3b
    and eax, 0x8                                 # 004c1d3e
    test eax, eax                                # 004c1d41
    je.d8 L_004c1d52                             # 004c1d43
    # block 0x004c1d45: entered by fall-through of je at 0x004c1d43, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1d52
    push 0x5532b8                                # 004c1d45
    call FUN_0044a2b7                            # 004c1d4a
    add esp, 0x4                                 # 004c1d4f
L_004c1d52:
    # block 0x004c1d52: entered by je at 0x004c1d43, 4 instruction(s), ends with je to 0x004c1d69 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c1d52
    and ecx, 0x10                                # 004c1d55
    test ecx, ecx                                # 004c1d58
    je.d8 L_004c1d69                             # 004c1d5a
    # block 0x004c1d5c: entered by fall-through of je at 0x004c1d5a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1d69
    push 0x5532e8                                # 004c1d5c
    call FUN_0044a2b7                            # 004c1d61
    add esp, 0x4                                 # 004c1d66
L_004c1d69:
    # block 0x004c1d69: entered by je at 0x004c1d5a, 4 instruction(s), ends with je to 0x004c1d80 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c1d69
    and edx, 0x20                                # 004c1d6c
    test edx, edx                                # 004c1d6f
    je.d8 L_004c1d80                             # 004c1d71
    # block 0x004c1d73: entered by fall-through of je at 0x004c1d71, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1d80
    push 0x553314                                # 004c1d73
    call FUN_0044a2b7                            # 004c1d78
    add esp, 0x4                                 # 004c1d7d
L_004c1d80:
    # block 0x004c1d80: entered by je at 0x004c1d71, 4 instruction(s), ends with je to 0x004c1d99 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c1d80
    and eax, 0x10000000                          # 004c1d83
    test eax, eax                                # 004c1d88
    je.d8 L_004c1d99                             # 004c1d8a
    # block 0x004c1d8c: entered by fall-through of je at 0x004c1d8a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1d99
    push 0x553348                                # 004c1d8c
    call FUN_0044a2b7                            # 004c1d91
    add esp, 0x4                                 # 004c1d96
L_004c1d99:
    # block 0x004c1d99: entered by je at 0x004c1d8a, 4 instruction(s), ends with je to 0x004c1db3 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c1d99
    and ecx, 0x20000000                          # 004c1d9c
    test ecx, ecx                                # 004c1da2
    je.d8 L_004c1db3                             # 004c1da4
    # block 0x004c1da6: entered by fall-through of je at 0x004c1da4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1db3
    push 0x55337c                                # 004c1da6
    call FUN_0044a2b7                            # 004c1dab
    add esp, 0x4                                 # 004c1db0
L_004c1db3:
    # block 0x004c1db3: entered by je at 0x004c1da4, 4 instruction(s), ends with je to 0x004c1dca (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c1db3
    and edx, 0x40                                # 004c1db6
    test edx, edx                                # 004c1db9
    je.d8 L_004c1dca                             # 004c1dbb
    # block 0x004c1dbd: entered by fall-through of je at 0x004c1dbb, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1dca
    push 0x5533b4                                # 004c1dbd
    call FUN_0044a2b7                            # 004c1dc2
    add esp, 0x4                                 # 004c1dc7
L_004c1dca:
    # block 0x004c1dca: entered by je at 0x004c1dbb, 4 instruction(s), ends with je to 0x004c1de3 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c1dca
    and eax, 0x200                               # 004c1dcd
    test eax, eax                                # 004c1dd2
    je.d8 L_004c1de3                             # 004c1dd4
    # block 0x004c1dd6: entered by fall-through of je at 0x004c1dd4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1de3
    push 0x5533ec                                # 004c1dd6
    call FUN_0044a2b7                            # 004c1ddb
    add esp, 0x4                                 # 004c1de0
L_004c1de3:
    # block 0x004c1de3: entered by je at 0x004c1dd4, 4 instruction(s), ends with je to 0x004c1dfd (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c1de3
    and ecx, 0x800                               # 004c1de6
    test ecx, ecx                                # 004c1dec
    je.d8 L_004c1dfd                             # 004c1dee
    # block 0x004c1df0: entered by fall-through of je at 0x004c1dee, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1dfd
    push 0x553424                                # 004c1df0
    call FUN_0044a2b7                            # 004c1df5
    add esp, 0x4                                 # 004c1dfa
L_004c1dfd:
    # block 0x004c1dfd: entered by je at 0x004c1dee, 4 instruction(s), ends with je to 0x004c1e17 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c1dfd
    and edx, 0x4000                              # 004c1e00
    test edx, edx                                # 004c1e06
    je.d8 L_004c1e17                             # 004c1e08
    # block 0x004c1e0a: entered by fall-through of je at 0x004c1e08, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1e17
    push 0x553458                                # 004c1e0a
    call FUN_0044a2b7                            # 004c1e0f
    add esp, 0x4                                 # 004c1e14
L_004c1e17:
    # block 0x004c1e17: entered by je at 0x004c1e08, 4 instruction(s), ends with je to 0x004c1e30 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c1e17
    and eax, 0x8000                              # 004c1e1a
    test eax, eax                                # 004c1e1f
    je.d8 L_004c1e30                             # 004c1e21
    # block 0x004c1e23: entered by fall-through of je at 0x004c1e21, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1e30
    push 0x55348c                                # 004c1e23
    call FUN_0044a2b7                            # 004c1e28
    add esp, 0x4                                 # 004c1e2d
L_004c1e30:
    # block 0x004c1e30: entered by je at 0x004c1e21, 4 instruction(s), ends with je to 0x004c1e4a (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c1e30
    and ecx, 0x10000                             # 004c1e33
    test ecx, ecx                                # 004c1e39
    je.d8 L_004c1e4a                             # 004c1e3b
    # block 0x004c1e3d: entered by fall-through of je at 0x004c1e3b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c1e4a
    push 0x5534bc                                # 004c1e3d
    call FUN_0044a2b7                            # 004c1e42
    add esp, 0x4                                 # 004c1e47
L_004c1e4a:
    # block 0x004c1e4a: entered by je at 0x004c1cef; je at 0x004c1e3b, 7 instruction(s), ends with je to 0x004c215b (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c1e4a
    mov dword ptr [edx + field_c52], 0x0         # 004c1e50
    mov eax, dword ptr [ebp - local_90]          # 004c1e5a
    mov dword ptr [eax + field_46], 0x0          # 004c1e60
    mov ecx, dword ptr [ebp - local_90]          # 004c1e67
    cmp dword ptr [ecx + field_c66], 0x0         # 004c1e6d
    je.d32 L_004c215b                            # 004c1e74
    # block 0x004c1e7a: entered by fall-through of je at 0x004c1e74, 3 instruction(s), ends with jne to 0x004c215b (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c1e7a
    cmp dword ptr [edx + field_38ac], 0x0        # 004c1e80
    jne.d32 L_004c215b                           # 004c1e87
    # block 0x004c1e8d: entered by fall-through of jne at 0x004c1e87, 3 instruction(s), ends with je to 0x004c215b (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c1e8d
    cmp dword ptr [eax + field_c4e], 0x0         # 004c1e93
    je.d32 L_004c215b                            # 004c1e9a
    # block 0x004c1ea0: entered by fall-through of je at 0x004c1e9a, 14 instruction(s), calls indirect dword ptr [ecx], ends with jge to 0x004c1f08 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c1ea0
    add ecx, 0x46                                # 004c1ea6
    push ecx                                     # 004c1ea9
    push 0x52e55c                                # 004c1eaa
    mov edx, dword ptr [ebp - local_90]          # 004c1eaf
    mov eax, dword ptr [edx + field_8]           # 004c1eb5
    mov ecx, dword ptr [ebp - local_90]          # 004c1eb8
    mov edx, dword ptr [ecx + field_8]           # 004c1ebe
    mov ecx, dword ptr [edx]                     # 004c1ec1
    push eax                                     # 004c1ec3
    call dword ptr [ecx]                         # 004c1ec4
    mov dword ptr [ebp - local_4], eax           # 004c1ec6
    cmp dword ptr [ebp - local_4], 0x0           # 004c1ec9
    jge.d8 L_004c1f08                            # 004c1ecd
    # block 0x004c1ecf: entered by fall-through of jge at 0x004c1ecd, 12 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c1ecf
    push edx                                     # 004c1ed2
    mov ecx, dword ptr [ebp - local_90]          # 004c1ed3
    call FUN_004c88c7                            # 004c1ed9
    push eax                                     # 004c1ede
    push 0x5534ec                                # 004c1edf
    mov ecx, 0x583979                            # 004c1ee4
    call FUN_0042639d                            # 004c1ee9
    mov dword ptr [0x5bb20c], 0x1                # 004c1eee
    mov ecx, dword ptr [ebp - local_90]          # 004c1ef8
    call FUN_004c97b4                            # 004c1efe
    jmp.d32 L_004c2788                           # 004c1f03
L_004c1f08:
    # block 0x004c1f08: entered by jge at 0x004c1ecd, 14 instruction(s), calls indirect dword ptr [eax + 0xc], ends with jge to 0x004c1f6e (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c1f08
    add eax, 0x4a                                # 004c1f0e
    push eax                                     # 004c1f11
    push 0x0                                     # 004c1f12
    mov ecx, dword ptr [ebp - local_90]          # 004c1f14
    mov edx, dword ptr [ecx + field_46]          # 004c1f1a
    mov eax, dword ptr [ebp - local_90]          # 004c1f1d
    mov ecx, dword ptr [eax + field_46]          # 004c1f23
    mov eax, dword ptr [ecx]                     # 004c1f26
    push edx                                     # 004c1f28
    call dword ptr [eax + field_c]               # 004c1f29
    mov dword ptr [ebp - local_4], eax           # 004c1f2c
    cmp dword ptr [ebp - local_4], 0x0           # 004c1f2f
    jge.d8 L_004c1f6e                            # 004c1f33
    # block 0x004c1f35: entered by fall-through of jge at 0x004c1f33, 12 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov ecx, dword ptr [ebp - local_4]           # 004c1f35
    push ecx                                     # 004c1f38
    mov ecx, dword ptr [ebp - local_90]          # 004c1f39
    call FUN_004c88c7                            # 004c1f3f
    push eax                                     # 004c1f44
    push 0x553554                                # 004c1f45
    mov ecx, 0x583979                            # 004c1f4a
    call FUN_0042639d                            # 004c1f4f
    mov dword ptr [0x5bb20c], 0x1                # 004c1f54
    mov ecx, dword ptr [ebp - local_90]          # 004c1f5e
    call FUN_004c97b4                            # 004c1f64
    jmp.d32 L_004c2788                           # 004c1f69
L_004c1f6e:
    # block 0x004c1f6e: entered by jge at 0x004c1f33, 7 instruction(s), ends with jge to 0x004c1fb2 (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c1f6e
    mov dword ptr [edx + field_c52], 0x1         # 004c1f74
    mov eax, dword ptr [ebp - local_90]          # 004c1f7e
    mov ecx, dword ptr [ebp - local_90]          # 004c1f84
    mov edx, dword ptr [eax + field_c56]         # 004c1f8a
    cmp edx, dword ptr [ecx + field_c5e]         # 004c1f90
    jge.d8 L_004c1fb2                            # 004c1f96
    # block 0x004c1f98: entered by fall-through of jge at 0x004c1f96, 5 instruction(s), ends with jl to 0x004c1fc2 (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c1f98
    mov ecx, dword ptr [ebp - local_90]          # 004c1f9e
    mov edx, dword ptr [eax + field_c56]         # 004c1fa4
    cmp edx, dword ptr [ecx + field_c5a]         # 004c1faa
    jl.d8 L_004c1fc2                             # 004c1fb0
L_004c1fb2:
    # block 0x004c1fb2: entered by jge at 0x004c1f96; fall-through of jl at 0x004c1fb0, 2 instruction(s), falls into the block at 0x004c1fc2
    mov eax, dword ptr [ebp - local_90]          # 004c1fb2
    mov dword ptr [eax + field_c56], 0x32        # 004c1fb8
L_004c1fc2:
    # block 0x004c1fc2: entered by jl at 0x004c1fb0, 5 instruction(s), ends with jle to 0x004c1ff6 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c1fc2
    mov edx, dword ptr [ebp - local_90]          # 004c1fc8
    mov eax, dword ptr [ecx + field_c5e]         # 004c1fce
    cmp eax, dword ptr [edx + field_c56]         # 004c1fd4
    jle.d8 L_004c1ff6                            # 004c1fda
    # block 0x004c1fdc: entered by fall-through of jle at 0x004c1fda, 5 instruction(s), ends with jl to 0x004c2006 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c1fdc
    mov edx, dword ptr [ebp - local_90]          # 004c1fe2
    mov eax, dword ptr [ecx + field_c5e]         # 004c1fe8
    cmp eax, dword ptr [edx + field_c5a]         # 004c1fee
    jl.d8 L_004c2006                             # 004c1ff4
L_004c1ff6:
    # block 0x004c1ff6: entered by jle at 0x004c1fda; fall-through of jl at 0x004c1ff4, 2 instruction(s), falls into the block at 0x004c2006
    mov ecx, dword ptr [ebp - local_90]          # 004c1ff6
    mov dword ptr [ecx + field_c5e], 0x64        # 004c1ffc
L_004c2006:
    # block 0x004c2006: entered by jl at 0x004c1ff4, 5 instruction(s), ends with jle to 0x004c203a (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c2006
    mov eax, dword ptr [ebp - local_90]          # 004c200c
    mov ecx, dword ptr [edx + field_c5a]         # 004c2012
    cmp ecx, dword ptr [eax + field_c56]         # 004c2018
    jle.d8 L_004c203a                            # 004c201e
    # block 0x004c2020: entered by fall-through of jle at 0x004c201e, 5 instruction(s), ends with jg to 0x004c204a (forward)
    mov edx, dword ptr [ebp - local_90]          # 004c2020
    mov eax, dword ptr [ebp - local_90]          # 004c2026
    mov ecx, dword ptr [edx + field_c5a]         # 004c202c
    cmp ecx, dword ptr [eax + field_c5e]         # 004c2032
    jg.d8 L_004c204a                             # 004c2038
L_004c203a:
    # block 0x004c203a: entered by jle at 0x004c201e; fall-through of jg at 0x004c2038, 2 instruction(s), falls into the block at 0x004c204a
    mov edx, dword ptr [ebp - local_90]          # 004c203a
    mov dword ptr [edx + field_c5a], 0x96        # 004c2040
L_004c204a:
    # block 0x004c204a: entered by jg at 0x004c2038, 5 instruction(s), ends with jle to 0x004c2078 (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c204a
    mov ecx, dword ptr [ebp - local_90]          # 004c2050
    mov edx, dword ptr [eax + field_c62]         # 004c2056
    cmp edx, dword ptr [ecx + field_c56]         # 004c205c
    jle.d8 L_004c2078                            # 004c2062
    # block 0x004c2064: entered by fall-through of jle at 0x004c2062, 4 instruction(s), ends with forward jump to 0x004c208a
    mov eax, dword ptr [ebp - local_90]          # 004c2064
    mov ecx, dword ptr [eax + field_c62]         # 004c206a
    mov dword ptr [ebp - local_94], ecx          # 004c2070
    jmp.d8 L_004c208a                            # 004c2076
L_004c2078:
    # block 0x004c2078: entered by jle at 0x004c2062, 3 instruction(s), falls into the block at 0x004c208a
    mov edx, dword ptr [ebp - local_90]          # 004c2078
    mov eax, dword ptr [edx + field_c56]         # 004c207e
    mov dword ptr [ebp - local_94], eax          # 004c2084
L_004c208a:
    # block 0x004c208a: entered by jmp at 0x004c2076, 8 instruction(s), ends with jge to 0x004c20ca (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c208a
    mov edx, dword ptr [ebp - local_94]          # 004c2090
    mov dword ptr [ecx + field_c62], edx         # 004c2096
    mov eax, dword ptr [ebp - local_90]          # 004c209c
    mov ecx, dword ptr [ebp - local_90]          # 004c20a2
    mov edx, dword ptr [eax + field_c62]         # 004c20a8
    cmp edx, dword ptr [ecx + field_c5a]         # 004c20ae
    jge.d8 L_004c20ca                            # 004c20b4
    # block 0x004c20b6: entered by fall-through of jge at 0x004c20b4, 4 instruction(s), ends with forward jump to 0x004c20dc
    mov eax, dword ptr [ebp - local_90]          # 004c20b6
    mov ecx, dword ptr [eax + field_c62]         # 004c20bc
    mov dword ptr [ebp - local_98], ecx          # 004c20c2
    jmp.d8 L_004c20dc                            # 004c20c8
L_004c20ca:
    # block 0x004c20ca: entered by jge at 0x004c20b4, 3 instruction(s), falls into the block at 0x004c20dc
    mov edx, dword ptr [ebp - local_90]          # 004c20ca
    mov eax, dword ptr [edx + field_c5a]         # 004c20d0
    mov dword ptr [ebp - local_98], eax          # 004c20d6
L_004c20dc:
    # block 0x004c20dc: entered by jmp at 0x004c20c8, 18 instruction(s), ends with je to 0x004c214e (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c20dc
    mov edx, dword ptr [ebp - local_98]          # 004c20e2
    mov dword ptr [ecx + field_c62], edx         # 004c20e8
    mov eax, dword ptr [ebp - local_90]          # 004c20ee
    mov ecx, dword ptr [ebp - local_90]          # 004c20f4
    mov edx, dword ptr [eax + field_c5e]         # 004c20fa
    sub edx, dword ptr [ecx + field_c56]         # 004c2100
    mov eax, dword ptr [ebp - local_90]          # 004c2106
    mov dword ptr [eax + field_c6a], edx         # 004c210c
    mov ecx, dword ptr [ebp - local_90]          # 004c2112
    mov edx, dword ptr [ebp - local_90]          # 004c2118
    mov eax, dword ptr [ecx + field_c5a]         # 004c211e
    sub eax, dword ptr [edx + field_c5e]         # 004c2124
    mov ecx, dword ptr [ebp - local_90]          # 004c212a
    mov dword ptr [ecx + field_c6e], eax         # 004c2130
    movsx edx, word ptr [0x63a4cd]               # 004c2136
    test edx, edx                                # 004c213d
    je.d8 L_004c214e                             # 004c213f
    # block 0x004c2141: entered by fall-through of je at 0x004c213f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c214e
    push 0x5535b8                                # 004c2141
    call FUN_0044a2b7                            # 004c2146
    add esp, 0x4                                 # 004c214b
L_004c214e:
    # block 0x004c214e: entered by je at 0x004c213f, 3 instruction(s), calls FUN_004c98b5, ends with forward jump to 0x004c2173
    mov ecx, dword ptr [ebp - local_90]          # 004c214e
    call FUN_004c98b5                            # 004c2154
    jmp.d8 L_004c2173                            # 004c2159
L_004c215b:
    # block 0x004c215b: entered by je at 0x004c1e74; jne at 0x004c1e87; je at 0x004c1e9a, 3 instruction(s), ends with je to 0x004c2173 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c215b
    test eax, eax                                # 004c2162
    je.d8 L_004c2173                             # 004c2164
    # block 0x004c2166: entered by fall-through of je at 0x004c2164, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2173
    push 0x553600                                # 004c2166
    call FUN_0044a2b7                            # 004c216b
    add esp, 0x4                                 # 004c2170
L_004c2173:
    # block 0x004c2173: entered by jmp at 0x004c2159; je at 0x004c2164, 27 instruction(s), calls indirect dword ptr [ecx + 0x18], ends with jge to 0x004c2211 (forward)
    mov ecx, 0x1f                                # 004c2173
    {load} xor eax, eax                          # 004c2178
    lea edi, [ebp - local_84]                    # 004c217a
    rep stosd dword ptr es:[edi], eax            # 004c2180
    mov dword ptr [ebp - local_84], 0x7c         # 004c2182
    mov dword ptr [ebp - local_80], 0x7          # 004c218c
    movsx ecx, word ptr [0x63988d]               # 004c2193
    mov dword ptr [ebp - local_7c], ecx          # 004c219a
    movsx edx, word ptr [0x63988b]               # 004c219d
    mov dword ptr [ebp - local_78], edx          # 004c21a4
    mov dword ptr [ebp - local_1c], 0x840        # 004c21a7
    push 0x0                                     # 004c21ae
    mov eax, dword ptr [ebp - local_90]          # 004c21b0
    add eax, 0xc                                 # 004c21b6
    push eax                                     # 004c21b9
    lea ecx, [ebp - local_84]                    # 004c21ba
    push ecx                                     # 004c21c0
    mov edx, dword ptr [ebp - local_90]          # 004c21c1
    mov eax, dword ptr [edx + field_4]           # 004c21c7
    mov ecx, dword ptr [ebp - local_90]          # 004c21ca
    mov edx, dword ptr [ecx + field_4]           # 004c21d0
    mov ecx, dword ptr [edx]                     # 004c21d3
    push eax                                     # 004c21d5
    call dword ptr [ecx + field_18]              # 004c21d6
    mov dword ptr [ebp - local_4], eax           # 004c21d9
    cmp dword ptr [ebp - local_4], 0x0           # 004c21dc
    jge.d8 L_004c2211                            # 004c21e0
    # block 0x004c21e2: entered by fall-through of jge at 0x004c21e0, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c21e2
    push edx                                     # 004c21e5
    mov ecx, dword ptr [ebp - local_90]          # 004c21e6
    call FUN_004c88c7                            # 004c21ec
    push eax                                     # 004c21f1
    push 0x553634                                # 004c21f2
    mov ecx, 0x583979                            # 004c21f7
    call FUN_0042639d                            # 004c21fc
    mov ecx, dword ptr [ebp - local_90]          # 004c2201
    call FUN_004c97b4                            # 004c2207
    jmp.d32 L_004c2788                           # 004c220c
L_004c2211:
    # block 0x004c2211: entered by jge at 0x004c21e0, 3 instruction(s), ends with je to 0x004c2229 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c2211
    test eax, eax                                # 004c2218
    je.d8 L_004c2229                             # 004c221a
    # block 0x004c221c: entered by fall-through of je at 0x004c221a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2229
    push 0x553668                                # 004c221c
    call FUN_0044a2b7                            # 004c2221
    add esp, 0x4                                 # 004c2226
L_004c2229:
    # block 0x004c2229: entered by je at 0x004c221a, 18 instruction(s), calls indirect dword ptr [ecx + 0x58], ends with jge to 0x004c22a0 (forward)
    mov ecx, 0x1f                                # 004c2229
    {load} xor eax, eax                          # 004c222e
    lea edi, [ebp - local_84]                    # 004c2230
    rep stosd dword ptr es:[edi], eax            # 004c2236
    mov dword ptr [ebp - local_84], 0x7c         # 004c2238
    mov dword ptr [ebp - local_80], 0xfff9ee     # 004c2242
    lea ecx, [ebp - local_84]                    # 004c2249
    push ecx                                     # 004c224f
    mov edx, dword ptr [ebp - local_90]          # 004c2250
    mov eax, dword ptr [edx + field_c]           # 004c2256
    mov ecx, dword ptr [ebp - local_90]          # 004c2259
    mov edx, dword ptr [ecx + field_c]           # 004c225f
    mov ecx, dword ptr [edx]                     # 004c2262
    push eax                                     # 004c2264
    call dword ptr [ecx + field_58]              # 004c2265
    mov dword ptr [ebp - local_4], eax           # 004c2268
    cmp dword ptr [ebp - local_4], 0x0           # 004c226b
    jge.d8 L_004c22a0                            # 004c226f
    # block 0x004c2271: entered by fall-through of jge at 0x004c226f, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c2271
    push edx                                     # 004c2274
    mov ecx, dword ptr [ebp - local_90]          # 004c2275
    call FUN_004c88c7                            # 004c227b
    push eax                                     # 004c2280
    push 0x55369c                                # 004c2281
    mov ecx, 0x583979                            # 004c2286
    call FUN_0042639d                            # 004c228b
    mov ecx, dword ptr [ebp - local_90]          # 004c2290
    call FUN_004c97b4                            # 004c2296
    jmp.d32 L_004c2788                           # 004c229b
L_004c22a0:
    # block 0x004c22a0: entered by jge at 0x004c226f, 2 instruction(s), ends with je to 0x004c22b2 (forward)
    cmp dword ptr [ebp - local_7c], 0x0          # 004c22a0
    je.d8 L_004c22b2                             # 004c22a4
    # block 0x004c22a6: entered by fall-through of je at 0x004c22a4, 2 instruction(s), ends with je to 0x004c22b2 (forward)
    cmp dword ptr [ebp - local_78], 0x0          # 004c22a6
    je.d8 L_004c22b2                             # 004c22aa
    # block 0x004c22ac: entered by fall-through of je at 0x004c22aa, 2 instruction(s), ends with jne to 0x004c22ee (forward)
    cmp dword ptr [ebp - local_74], 0x0          # 004c22ac
    jne.d8 L_004c22ee                            # 004c22b0
L_004c22b2:
    # block 0x004c22b2: entered by je at 0x004c22a4; je at 0x004c22aa; fall-through of jne at 0x004c22b0, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov eax, dword ptr [ebp - local_74]          # 004c22b2
    push eax                                     # 004c22b5
    mov ecx, dword ptr [ebp - local_78]          # 004c22b6
    push ecx                                     # 004c22b9
    mov edx, dword ptr [ebp - local_7c]          # 004c22ba
    push edx                                     # 004c22bd
    push 0x5536d0                                # 004c22be
    push 0x63888b                                # 004c22c3
    call FUN_0050ca3e                            # 004c22c8
    add esp, 0x14                                # 004c22cd
    push 0x0                                     # 004c22d0
    push 0x0                                     # 004c22d2
    push 0x63888b                                # 004c22d4
    call FUN_0052139c                            # 004c22d9
    mov ecx, dword ptr [ebp - local_90]          # 004c22de
    call FUN_004c97b4                            # 004c22e4
    jmp.d32 L_004c2788                           # 004c22e9
L_004c22ee:
    # block 0x004c22ee: entered by jne at 0x004c22b0, 3 instruction(s), ends with je to 0x004c244e (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c22ee
    test eax, eax                                # 004c22f5
    je.d32 L_004c244e                            # 004c22f7
    # block 0x004c22fd: entered by fall-through of je at 0x004c22f7, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004c233f (forward)
    mov ecx, dword ptr [ebp - local_74]          # 004c22fd
    push ecx                                     # 004c2300
    mov edx, dword ptr [ebp - local_78]          # 004c2301
    push edx                                     # 004c2304
    mov eax, dword ptr [ebp - local_7c]          # 004c2305
    push eax                                     # 004c2308
    push 0x553738                                # 004c2309
    push 0x63888b                                # 004c230e
    call FUN_0050ca3e                            # 004c2313
    add esp, 0x14                                # 004c2318
    push 0x63888b                                # 004c231b
    call FUN_0044a2b7                            # 004c2320
    add esp, 0x4                                 # 004c2325
    mov ecx, dword ptr [ebp - local_1c]          # 004c2328
    and ecx, 0x4                                 # 004c232b
    test ecx, ecx                                # 004c232e
    je.d8 L_004c233f                             # 004c2330
    # block 0x004c2332: entered by fall-through of je at 0x004c2330, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c233f
    push 0x553780                                # 004c2332
    call FUN_0044a2b7                            # 004c2337
    add esp, 0x4                                 # 004c233c
L_004c233f:
    # block 0x004c233f: entered by je at 0x004c2330, 4 instruction(s), ends with je to 0x004c2356 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c233f
    and edx, 0x8                                 # 004c2342
    test edx, edx                                # 004c2345
    je.d8 L_004c2356                             # 004c2347
    # block 0x004c2349: entered by fall-through of je at 0x004c2347, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2356
    push 0x5537b8                                # 004c2349
    call FUN_0044a2b7                            # 004c234e
    add esp, 0x4                                 # 004c2353
L_004c2356:
    # block 0x004c2356: entered by je at 0x004c2347, 4 instruction(s), ends with je to 0x004c236d (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c2356
    and eax, 0x10                                # 004c2359
    test eax, eax                                # 004c235c
    je.d8 L_004c236d                             # 004c235e
    # block 0x004c2360: entered by fall-through of je at 0x004c235e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c236d
    push 0x5537ec                                # 004c2360
    call FUN_0044a2b7                            # 004c2365
    add esp, 0x4                                 # 004c236a
L_004c236d:
    # block 0x004c236d: entered by je at 0x004c235e, 4 instruction(s), ends with je to 0x004c2384 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c236d
    and ecx, 0x20                                # 004c2370
    test ecx, ecx                                # 004c2373
    je.d8 L_004c2384                             # 004c2375
    # block 0x004c2377: entered by fall-through of je at 0x004c2375, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2384
    push 0x55381c                                # 004c2377
    call FUN_0044a2b7                            # 004c237c
    add esp, 0x4                                 # 004c2381
L_004c2384:
    # block 0x004c2384: entered by je at 0x004c2375, 4 instruction(s), ends with je to 0x004c239e (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c2384
    and edx, 0x10000000                          # 004c2387
    test edx, edx                                # 004c238d
    je.d8 L_004c239e                             # 004c238f
    # block 0x004c2391: entered by fall-through of je at 0x004c238f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c239e
    push 0x553854                                # 004c2391
    call FUN_0044a2b7                            # 004c2396
    add esp, 0x4                                 # 004c239b
L_004c239e:
    # block 0x004c239e: entered by je at 0x004c238f, 4 instruction(s), ends with je to 0x004c23b7 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c239e
    and eax, 0x20000000                          # 004c23a1
    test eax, eax                                # 004c23a6
    je.d8 L_004c23b7                             # 004c23a8
    # block 0x004c23aa: entered by fall-through of je at 0x004c23a8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c23b7
    push 0x55388c                                # 004c23aa
    call FUN_0044a2b7                            # 004c23af
    add esp, 0x4                                 # 004c23b4
L_004c23b7:
    # block 0x004c23b7: entered by je at 0x004c23a8, 4 instruction(s), ends with je to 0x004c23ce (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c23b7
    and ecx, 0x40                                # 004c23ba
    test ecx, ecx                                # 004c23bd
    je.d8 L_004c23ce                             # 004c23bf
    # block 0x004c23c1: entered by fall-through of je at 0x004c23bf, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c23ce
    push 0x5538c8                                # 004c23c1
    call FUN_0044a2b7                            # 004c23c6
    add esp, 0x4                                 # 004c23cb
L_004c23ce:
    # block 0x004c23ce: entered by je at 0x004c23bf, 4 instruction(s), ends with je to 0x004c23e8 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c23ce
    and edx, 0x200                               # 004c23d1
    test edx, edx                                # 004c23d7
    je.d8 L_004c23e8                             # 004c23d9
    # block 0x004c23db: entered by fall-through of je at 0x004c23d9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c23e8
    push 0x553904                                # 004c23db
    call FUN_0044a2b7                            # 004c23e0
    add esp, 0x4                                 # 004c23e5
L_004c23e8:
    # block 0x004c23e8: entered by je at 0x004c23d9, 4 instruction(s), ends with je to 0x004c2401 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c23e8
    and eax, 0x800                               # 004c23eb
    test eax, eax                                # 004c23f0
    je.d8 L_004c2401                             # 004c23f2
    # block 0x004c23f4: entered by fall-through of je at 0x004c23f2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2401
    push 0x553940                                # 004c23f4
    call FUN_0044a2b7                            # 004c23f9
    add esp, 0x4                                 # 004c23fe
L_004c2401:
    # block 0x004c2401: entered by je at 0x004c23f2, 4 instruction(s), ends with je to 0x004c241b (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c2401
    and ecx, 0x4000                              # 004c2404
    test ecx, ecx                                # 004c240a
    je.d8 L_004c241b                             # 004c240c
    # block 0x004c240e: entered by fall-through of je at 0x004c240c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c241b
    push 0x553978                                # 004c240e
    call FUN_0044a2b7                            # 004c2413
    add esp, 0x4                                 # 004c2418
L_004c241b:
    # block 0x004c241b: entered by je at 0x004c240c, 4 instruction(s), ends with je to 0x004c2435 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c241b
    and edx, 0x8000                              # 004c241e
    test edx, edx                                # 004c2424
    je.d8 L_004c2435                             # 004c2426
    # block 0x004c2428: entered by fall-through of je at 0x004c2426, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2435
    push 0x5539b0                                # 004c2428
    call FUN_0044a2b7                            # 004c242d
    add esp, 0x4                                 # 004c2432
L_004c2435:
    # block 0x004c2435: entered by je at 0x004c2426, 4 instruction(s), ends with je to 0x004c244e (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c2435
    and eax, 0x10000                             # 004c2438
    test eax, eax                                # 004c243d
    je.d8 L_004c244e                             # 004c243f
    # block 0x004c2441: entered by fall-through of je at 0x004c243f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c244e
    push 0x5539e4                                # 004c2441
    call FUN_0044a2b7                            # 004c2446
    add esp, 0x4                                 # 004c244b
L_004c244e:
    # block 0x004c244e: entered by je at 0x004c22f7; je at 0x004c243f, 32 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c24f9 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c244e
    mov dx, word ptr [0x639895]                  # 004c2454
    mov word ptr [ecx + field_20], dx            # 004c245b
    mov eax, dword ptr [ebp - local_90]          # 004c245f
    mov ecx, dword ptr [ebp - local_74]          # 004c2465
    mov dword ptr [eax + field_1c], ecx          # 004c2468
    mov edx, dword ptr [ebp - local_90]          # 004c246b
    mov ax, word ptr [ebp - local_78]            # 004c2471
    mov word ptr [edx + field_18], ax            # 004c2475
    mov ecx, dword ptr [ebp - local_90]          # 004c2479
    mov dx, word ptr [ebp - local_7c]            # 004c247f
    mov word ptr [ecx + field_1a], dx            # 004c2483
    mov eax, dword ptr [ebp - local_74]          # 004c2487
    imul eax, dword ptr [ebp - local_7c]         # 004c248a
    mov ecx, dword ptr [ebp - local_90]          # 004c248e
    mov dword ptr [ecx + field_10], eax          # 004c2494
    mov edi, dword ptr [ebp - local_90]          # 004c2497
    add edi, 0x22                                # 004c249d
    mov ecx, 0x8                                 # 004c24a0
    lea esi, [ebp - local_3c]                    # 004c24a5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c24a8
    mov edx, dword ptr [ebp - local_90]          # 004c24aa
    mov eax, dword ptr [edx + field_10]          # 004c24b0
    push eax                                     # 004c24b3
    call FUN_0051dc43                            # 004c24b4
    add esp, 0x4                                 # 004c24b9
    mov dword ptr [ebp - local_8c], eax          # 004c24bc
    mov ecx, dword ptr [ebp - local_90]          # 004c24c2
    mov edx, dword ptr [ebp - local_8c]          # 004c24c8
    mov dword ptr [ecx + field_14], edx          # 004c24ce
    cmp dword ptr [ebp - local_8c], 0x0          # 004c24d1
    jne.d8 L_004c24f9                            # 004c24d8
    # block 0x004c24da: entered by fall-through of jne at 0x004c24d8, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c2788
    push 0x553a18                                # 004c24da
    mov ecx, 0x583979                            # 004c24df
    call FUN_004264e8                            # 004c24e4
    mov ecx, dword ptr [ebp - local_90]          # 004c24e9
    call FUN_004c97b4                            # 004c24ef
    jmp.d32 L_004c2788                           # 004c24f4
L_004c24f9:
    # block 0x004c24f9: entered by jne at 0x004c24d8, 50 instruction(s), calls indirect dword ptr [ecx + 0x9c], ends with jge to 0x004c25e8 (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c24f9
    mov ecx, dword ptr [eax + field_10]          # 004c24ff
    {load} xor eax, eax                          # 004c2502
    mov edx, dword ptr [ebp - local_90]          # 004c2504
    mov edi, dword ptr [edx + field_14]          # 004c250a
    {load} mov edx, ecx                          # 004c250d
    shr ecx, 0x2                                 # 004c250f
    rep stosd dword ptr es:[edi], eax            # 004c2512
    {load} mov ecx, edx                          # 004c2514
    and ecx, 0x3                                 # 004c2516
    rep stosb byte ptr es:[edi], al              # 004c2519
    mov ecx, 0x1f                                # 004c251b
    {load} xor eax, eax                          # 004c2520
    lea edi, [ebp - local_84]                    # 004c2522
    rep stosd dword ptr es:[edi], eax            # 004c2528
    mov dword ptr [ebp - local_84], 0x7c         # 004c252a
    mov dword ptr [ebp - local_80], 0x180e       # 004c2534
    mov eax, dword ptr [ebp - local_90]          # 004c253b
    mov ecx, dword ptr [ebp - local_80]          # 004c2541
    mov dword ptr [eax + field_42], ecx          # 004c2544
    mov edx, dword ptr [ebp - local_90]          # 004c2547
    movsx eax, word ptr [edx + field_1a]         # 004c254d
    mov dword ptr [ebp - local_7c], eax          # 004c2551
    mov ecx, dword ptr [ebp - local_90]          # 004c2554
    movsx edx, word ptr [ecx + field_18]         # 004c255a
    mov dword ptr [ebp - local_78], edx          # 004c255e
    mov eax, dword ptr [ebp - local_90]          # 004c2561
    mov ecx, dword ptr [eax + field_1c]          # 004c2567
    mov dword ptr [ebp - local_74], ecx          # 004c256a
    mov edx, dword ptr [ebp - local_90]          # 004c256d
    mov eax, dword ptr [edx + field_14]          # 004c2573
    mov dword ptr [ebp - local_60], eax          # 004c2576
    mov esi, dword ptr [ebp - local_90]          # 004c2579
    add esi, 0x22                                # 004c257f
    mov ecx, 0x8                                 # 004c2582
    lea edi, [ebp - local_3c]                    # 004c2587
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c258a
    push 0x0                                     # 004c258c
    lea ecx, [ebp - local_84]                    # 004c258e
    push ecx                                     # 004c2594
    mov edx, dword ptr [ebp - local_90]          # 004c2595
    mov eax, dword ptr [edx + field_c]           # 004c259b
    mov ecx, dword ptr [ebp - local_90]          # 004c259e
    mov edx, dword ptr [ecx + field_c]           # 004c25a4
    mov ecx, dword ptr [edx]                     # 004c25a7
    push eax                                     # 004c25a9
    call dword ptr [ecx + field_9c]              # 004c25aa
    mov dword ptr [ebp - local_4], eax           # 004c25b0
    cmp dword ptr [ebp - local_4], 0x0           # 004c25b3
    jge.d8 L_004c25e8                            # 004c25b7
    # block 0x004c25b9: entered by fall-through of jge at 0x004c25b7, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2788
    mov edx, dword ptr [ebp - local_4]           # 004c25b9
    push edx                                     # 004c25bc
    mov ecx, dword ptr [ebp - local_90]          # 004c25bd
    call FUN_004c88c7                            # 004c25c3
    push eax                                     # 004c25c8
    push 0x553aa4                                # 004c25c9
    mov ecx, 0x583979                            # 004c25ce
    call FUN_0042639d                            # 004c25d3
    mov ecx, dword ptr [ebp - local_90]          # 004c25d8
    call FUN_004c97b4                            # 004c25de
    jmp.d32 L_004c2788                           # 004c25e3
L_004c25e8:
    # block 0x004c25e8: entered by jge at 0x004c25b7, 22 instruction(s), calls indirect dword ptr [eax + 0x5c], ends with je to 0x004c2692 (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c25e8
    mov dword ptr [eax + field_e72], 0x40        # 004c25ee
    mov ecx, dword ptr [ebp - local_90]          # 004c25f8
    add ecx, 0x38bc                              # 004c25fe
    push ecx                                     # 004c2604
    mov edx, dword ptr [ebp - local_90]          # 004c2605
    add edx, 0x38b8                              # 004c260b
    push edx                                     # 004c2611
    mov eax, dword ptr [ebp - local_90]          # 004c2612
    add eax, 0xe72                               # 004c2618
    push eax                                     # 004c261d
    mov ecx, dword ptr [ebp - local_90]          # 004c261e
    mov edx, dword ptr [ecx + field_4]           # 004c2624
    mov eax, dword ptr [ebp - local_90]          # 004c2627
    mov ecx, dword ptr [eax + field_4]           # 004c262d
    mov eax, dword ptr [ecx]                     # 004c2630
    push edx                                     # 004c2632
    call dword ptr [eax + field_5c]              # 004c2633
    mov dword ptr [ebp - local_4], eax           # 004c2636
    movsx ecx, word ptr [0x63a4cd]               # 004c2639
    test ecx, ecx                                # 004c2640
    je.d8 L_004c2692                             # 004c2642
    # block 0x004c2644: entered by fall-through of je at 0x004c2642, 2 instruction(s), ends with jge to 0x004c2659 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004c2644
    jge.d8 L_004c2659                            # 004c2648
    # block 0x004c264a: entered by fall-through of jge at 0x004c2648, 4 instruction(s), calls FUN_0044a2b7, ends with forward jump to 0x004c2692
    push 0x553ad8                                # 004c264a
    call FUN_0044a2b7                            # 004c264f
    add esp, 0x4                                 # 004c2654
    jmp.d8 L_004c2692                            # 004c2657
L_004c2659:
    # block 0x004c2659: entered by jge at 0x004c2648, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c2692
    mov edx, dword ptr [ebp - local_90]          # 004c2659
    mov eax, dword ptr [edx + field_38bc]        # 004c265f
    push eax                                     # 004c2665
    mov ecx, dword ptr [ebp - local_90]          # 004c2666
    mov edx, dword ptr [ecx + field_38b8]        # 004c266c
    push edx                                     # 004c2672
    push 0x553b24                                # 004c2673
    push 0x63888b                                # 004c2678
    call FUN_0050ca3e                            # 004c267d
    add esp, 0x10                                # 004c2682
    push 0x63888b                                # 004c2685
    call FUN_0044a2b7                            # 004c268a
    add esp, 0x4                                 # 004c268f
L_004c2692:
    # block 0x004c2692: entered by je at 0x004c2642; jmp at 0x004c2657, 8 instruction(s), calls FUN_004c2e97, ends with jne to 0x004c26cd (forward)
    mov eax, dword ptr [ebp - local_90]          # 004c2692
    mov ecx, dword ptr [eax + field_8]           # 004c2698
    push ecx                                     # 004c269b
    mov ecx, dword ptr [ebp - local_90]          # 004c269c
    call FUN_004c2e97                            # 004c26a2
    movsx edx, ax                                # 004c26a7
    test edx, edx                                # 004c26aa
    jne.d8 L_004c26cd                            # 004c26ac
    # block 0x004c26ae: entered by fall-through of jne at 0x004c26ac, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c2788
    push 0x553b60                                # 004c26ae
    mov ecx, 0x583979                            # 004c26b3
    call FUN_004264e8                            # 004c26b8
    mov ecx, dword ptr [ebp - local_90]          # 004c26bd
    call FUN_004c97b4                            # 004c26c3
    jmp.d32 L_004c2788                           # 004c26c8
L_004c26cd:
    # block 0x004c26cd: entered by jne at 0x004c26ac, 40 instruction(s), calls FUN_004c2c3a, FUN_004c2a8d, FUN_00446ffb, ends with je to 0x004c2788 (forward)
    push 0x553b90                                # 004c26cd
    push 0x1                                     # 004c26d2
    push 0x8                                     # 004c26d4
    mov eax, dword ptr [0x583192]                # 004c26d6
    sub eax, dword ptr [0x58318a]                # 004c26db
    add eax, 0x1                                 # 004c26e1
    push eax                                     # 004c26e4
    mov ecx, dword ptr [0x58318e]                # 004c26e5
    sub ecx, dword ptr [0x583186]                # 004c26eb
    add ecx, 0x1                                 # 004c26f1
    push ecx                                     # 004c26f4
    mov ecx, dword ptr [ebp - local_90]          # 004c26f5
    call FUN_004c2c3a                            # 004c26fb
    mov edx, dword ptr [ebp - local_90]          # 004c2700
    mov dword ptr [edx + field_d62], eax         # 004c2706
    push 0x553b9c                                # 004c270c
    push 0x8                                     # 004c2711
    mov ax, word ptr [0x5b0a76]                  # 004c2713
    push eax                                     # 004c2719
    mov cx, word ptr [0x5b0a74]                  # 004c271a
    push ecx                                     # 004c2721
    mov ecx, dword ptr [ebp - local_90]          # 004c2722
    call FUN_004c2a8d                            # 004c2728
    mov edx, dword ptr [ebp - local_90]          # 004c272d
    mov dword ptr [edx + field_d56], eax         # 004c2733
    push 0x553bb4                                # 004c2739
    push 0x8                                     # 004c273e
    mov ax, word ptr [0x5b15f0]                  # 004c2740
    push eax                                     # 004c2746
    mov cx, word ptr [0x5b15ee]                  # 004c2747
    push ecx                                     # 004c274e
    mov ecx, dword ptr [ebp - local_90]          # 004c274f
    call FUN_004c2a8d                            # 004c2755
    mov edx, dword ptr [ebp - local_90]          # 004c275a
    mov dword ptr [edx + field_d5a], eax         # 004c2760
    mov ecx, 0x6198d7                            # 004c2766
    call FUN_00446ffb                            # 004c276b
    movsx eax, word ptr [0x63a4cd]               # 004c2770
    test eax, eax                                # 004c2777
    je.d8 L_004c2788                             # 004c2779
    # block 0x004c277b: entered by fall-through of je at 0x004c2779, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c2788
    push 0x553bd0                                # 004c277b
    call FUN_0044a2b7                            # 004c2780
    add esp, 0x4                                 # 004c2785
L_004c2788:
    # block 0x004c2788: entered by jmp at 0x004c176e; jmp at 0x004c1824; jmp at 0x004c18c4; jmp at 0x004c195b; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004c2788
    pop esi                                      # 004c2789
    {load} mov esp, ebp                          # 004c278a
    pop ebp                                      # 004c278c
    ret 0x4                                      # 004c278d

