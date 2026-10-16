# FUN_004aa81e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aa81e
# extent:       0x004aa81e-0x004aaef5 (1751 code bytes)
# span:         0x004aa81e-0x004aaef5 (code 1751, tables 0, padding 0)
# sha256:       38bed2cc8054c8a9852f280870d693d6805c49ea8daaee2e43174ddac9f1953d
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aa81e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_1d, field_21, field_29, field_2b, field_42, field_47, field_48, field_84, field_88, field_90, field_9a, field_ce and 4 more; [ecx + n] field_1c, field_25, field_29, field_2b, field_42, field_45, field_46, field_48, field_73, field_86, field_8c, field_98 and 7 more; [edx + n] field_4, field_8, field_c, field_10, field_1d, field_21, field_25, field_29, field_2c, field_40, field_42, field_45 and 12 more
# callees:      calls FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004f6334, FUN_004fba69, FUN_00448d11, FUN_004fb2e3, FUN_0042ba3a, FUN_004a9f63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 435 instruction(s), 28 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2c, 0x2c  # offset +0x2c
.equ field_40, 0x40  # offset +0x40
.equ field_42, 0x42  # offset +0x42
.equ field_45, 0x45  # offset +0x45
.equ field_46, 0x46  # offset +0x46
.equ field_47, 0x47  # offset +0x47
.equ field_48, 0x48  # offset +0x48
.equ field_73, 0x73  # offset +0x73
.equ field_84, 0x84  # offset +0x84
.equ field_86, 0x86  # offset +0x86
.equ field_88, 0x88  # offset +0x88
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9a, 0x9a  # offset +0x9a
.equ field_9c, 0x9c  # offset +0x9c
.equ field_be, 0xbe  # offset +0xbe
.equ field_ce, 0xce  # offset +0xce
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d4, 0xd4  # offset +0xd4
.equ field_d6, 0xd6  # offset +0xd6
.equ field_da, 0xda  # offset +0xda
.equ field_de, 0xde  # offset +0xde
.equ field_e2, 0xe2  # offset +0xe2
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e6, 0xe6  # offset +0xe6
.equ field_f7, 0xf7  # offset +0xf7
.equ field_119, 0x119  # offset +0x119
.equ field_13a, 0x13a  # offset +0x13a

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004a9f63, .text + (0x004a9f63 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004aa81e - 0x401000
.globl FUN_004aa81e
FUN_004aa81e:
    # block 0x004aa81e: entry, 16 instruction(s), ends with je to 0x004aa86e (forward)
    push ebp                                     # 004aa81e
    {load} mov ebp, esp                          # 004aa81f
    sub esp, 0x24                                # 004aa821
    push esi                                     # 004aa824
    push edi                                     # 004aa825
    mov dword ptr [ebp - local_1c], ecx          # 004aa826
    movsx eax, word ptr [ebp + arg_8]            # 004aa829
    imul eax, eax, 0x8d                          # 004aa82d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004aa833
    mov dword ptr [ebp - local_4], ecx           # 004aa839
    movsx edx, word ptr [ebp + arg_8]            # 004aa83c
    imul edx, edx, 0x8d                          # 004aa840
    mov eax, dword ptr [edx + 0x5bb632]          # 004aa846
    mov dword ptr [ebp - local_20], eax          # 004aa84c
    cmp dword ptr [ebp - local_20], 0x0          # 004aa84f
    je.d8 L_004aa86e                             # 004aa853
    # block 0x004aa855: entered by fall-through of je at 0x004aa853, 2 instruction(s), ends with je to 0x004aaa6b (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 004aa855
    je.d32 L_004aaa6b                            # 004aa859
    # block 0x004aa85f: entered by fall-through of je at 0x004aa859, 2 instruction(s), ends with je to 0x004aac4e (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 004aa85f
    je.d32 L_004aac4e                            # 004aa863
    # block 0x004aa869: entered by fall-through of je at 0x004aa863, 1 instruction(s), ends with forward jump to 0x004aaeed
    jmp.d32 L_004aaeed                           # 004aa869
L_004aa86e:
    # block 0x004aa86e: entered by je at 0x004aa853, 87 instruction(s), calls FUN_004d39f9, ends with jne to 0x004aa9e1 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004aa86e
    mov byte ptr [ecx + field_45], 0x1           # 004aa871
    mov edx, dword ptr [ebp - local_1c]          # 004aa875
    mov byte ptr [edx + field_47], 0x0           # 004aa878
    mov eax, dword ptr [ebp - local_1c]          # 004aa87c
    mov byte ptr [eax + field_2b], 0x0           # 004aa87f
    mov ecx, dword ptr [ebp - local_1c]          # 004aa883
    mov word ptr [ecx + field_42], 0x0           # 004aa886
    mov edx, dword ptr [ebp - local_1c]          # 004aa88c
    mov word ptr [edx + field_40], 0x0           # 004aa88f
    mov dword ptr [0x5bb1ca], 0x1                # 004aa895
    mov eax, dword ptr [ebp - local_1c]          # 004aa89f
    mov cx, word ptr [ebp + arg_8]               # 004aa8a2
    mov word ptr [eax + field_21], cx            # 004aa8a6
    mov edx, dword ptr [ebp - local_1c]          # 004aa8aa
    mov byte ptr [edx + field_46], 0x0           # 004aa8ad
    mov eax, dword ptr [ebp - local_1c]          # 004aa8b1
    mov word ptr [eax + field_48], 0x0           # 004aa8b4
    mov ecx, dword ptr [ebp - local_1c]          # 004aa8ba
    mov byte ptr [ecx + field_1c], 0x1           # 004aa8bd
    call FUN_004d39f9                            # 004aa8c1
    mov edx, dword ptr [ebp - local_1c]          # 004aa8c6
    mov word ptr [edx + field_29], ax            # 004aa8c9
    mov eax, dword ptr [ebp - local_1c]          # 004aa8cd
    movsx ecx, word ptr [eax + field_29]         # 004aa8d0
    imul ecx, ecx, 0x4a                          # 004aa8d4
    mov dword ptr [ecx + 0x5d1591], 0xa          # 004aa8d7
    mov edx, dword ptr [ebp - local_1c]          # 004aa8e1
    movsx eax, word ptr [edx + field_29]         # 004aa8e4
    imul eax, eax, 0x4a                          # 004aa8e8
    mov dword ptr [eax + 0x5d1595], 0x4aaf05     # 004aa8eb
    mov ecx, dword ptr [ebp - local_1c]          # 004aa8f5
    movsx edx, word ptr [ecx + field_29]         # 004aa8f8
    imul edx, edx, 0x4a                          # 004aa8fc
    mov eax, dword ptr [ebp - local_1c]          # 004aa8ff
    mov ecx, dword ptr [eax + field_1d]          # 004aa902
    mov dword ptr [edx + 0x5d1599], ecx          # 004aa905
    mov edx, dword ptr [ebp - local_1c]          # 004aa90b
    movsx eax, word ptr [edx + field_29]         # 004aa90e
    imul eax, eax, 0x4a                          # 004aa912
    mov dword ptr [eax + 0x5d159d], 0x0          # 004aa915
    mov ecx, dword ptr [ebp - local_1c]          # 004aa91f
    movsx edx, word ptr [ecx + field_29]         # 004aa922
    imul edx, edx, 0x4a                          # 004aa926
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004aa929
    mov eax, dword ptr [ebp - local_1c]          # 004aa933
    movsx ecx, word ptr [eax + field_29]         # 004aa936
    imul ecx, ecx, 0x4a                          # 004aa93a
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004aa93d
    mov edx, dword ptr [ebp - local_1c]          # 004aa947
    movsx eax, word ptr [edx + field_29]         # 004aa94a
    imul eax, eax, 0x4a                          # 004aa94e
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004aa951
    mov ecx, dword ptr [ebp - local_1c]          # 004aa95b
    movsx edx, word ptr [ecx + field_29]         # 004aa95e
    imul edx, edx, 0x4a                          # 004aa962
    mov word ptr [edx + 0x5d15ad], 0x0           # 004aa965
    mov edi, 0x550e54                            # 004aa96e
    mov eax, dword ptr [ebp - local_1c]          # 004aa973
    movsx ecx, word ptr [eax + field_29]         # 004aa976
    imul ecx, ecx, 0x4a                          # 004aa97a
    add ecx, 0x5d15b3                            # 004aa97d
    {load} mov edx, ecx                          # 004aa983
    or ecx, -0x1                                 # 004aa985
    {load} xor eax, eax                          # 004aa988
    repne scasb al, byte ptr es:[edi]            # 004aa98a
    not ecx                                      # 004aa98c
    {load} sub edi, ecx                          # 004aa98e
    {load} mov esi, edi                          # 004aa990
    {load} mov eax, ecx                          # 004aa992
    {load} mov edi, edx                          # 004aa994
    shr ecx, 0x2                                 # 004aa996
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004aa999
    {load} mov ecx, eax                          # 004aa99b
    and ecx, 0x3                                 # 004aa99d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004aa9a0
    {load} xor ecx, ecx                          # 004aa9a2
    mov edx, dword ptr [ebp - local_1c]          # 004aa9a4
    add edx, 0x2c                                # 004aa9a7
    mov dword ptr [edx], ecx                     # 004aa9aa
    mov dword ptr [edx + field_4], ecx           # 004aa9ac
    mov dword ptr [edx + field_8], ecx           # 004aa9af
    mov dword ptr [edx + field_c], ecx           # 004aa9b2
    mov dword ptr [edx + field_10], ecx          # 004aa9b5
    mov eax, dword ptr [ebp - local_1c]          # 004aa9b8
    cmp dword ptr [eax + field_1d], 0x0          # 004aa9bb
    jne.d8 L_004aa9e1                            # 004aa9bf
    # block 0x004aa9c1: entered by fall-through of jne at 0x004aa9bf, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004aa9e1
    push 0x550e70                                # 004aa9c1
    push 0x6                                     # 004aa9c6
    mov ecx, dword ptr [ebp - local_4]           # 004aa9c8
    push ecx                                     # 004aa9cb
    push 0x550e8c                                # 004aa9cc
    mov ecx, 0x5cf659                            # 004aa9d1
    call FUN_004c2790                            # 004aa9d6
    mov edx, dword ptr [ebp - local_1c]          # 004aa9db
    mov dword ptr [edx + field_1d], eax          # 004aa9de
L_004aa9e1:
    # block 0x004aa9e1: entered by jne at 0x004aa9bf, 13 instruction(s), ends with je to 0x004aaa1e (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004aa9e1
    movsx ecx, word ptr [eax + field_29]         # 004aa9e4
    imul ecx, ecx, 0x4a                          # 004aa9e8
    mov edx, dword ptr [ebp - local_1c]          # 004aa9eb
    mov eax, dword ptr [edx + field_1d]          # 004aa9ee
    mov dword ptr [ecx + 0x5d1599], eax          # 004aa9f1
    mov edi, 0x550e94                            # 004aa9f7
    mov esi, dword ptr [ebp - local_4]           # 004aa9fc
    add esi, 0x21                                # 004aa9ff
    mov ecx, 0x9                                 # 004aaa02
    {load} xor edx, edx                          # 004aaa07
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aaa09
    je.d8 L_004aaa1e                             # 004aaa0b
    # block 0x004aaa0d: entered by fall-through of je at 0x004aaa0b, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004aaa1e
    mov eax, dword ptr [ebp - local_4]           # 004aaa0d
    add eax, 0x21                                # 004aaa10
    push eax                                     # 004aaa13
    mov ecx, 0x5c3a67                            # 004aaa14
    call FUN_004fb77a                            # 004aaa19
L_004aaa1e:
    # block 0x004aaa1e: entered by je at 0x004aaa0b, 7 instruction(s), ends with je to 0x004aaa45 (forward)
    mov edi, 0x550ea0                            # 004aaa1e
    mov esi, dword ptr [ebp - local_4]           # 004aaa23
    add esi, 0x52                                # 004aaa26
    mov ecx, 0x9                                 # 004aaa29
    {load} xor edx, edx                          # 004aaa2e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aaa30
    je.d8 L_004aaa45                             # 004aaa32
    # block 0x004aaa34: entered by fall-through of je at 0x004aaa32, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004aaa45
    mov eax, dword ptr [ebp - local_4]           # 004aaa34
    add eax, 0x52                                # 004aaa37
    push eax                                     # 004aaa3a
    mov ecx, 0x5c3a67                            # 004aaa3b
    call FUN_004fb77a                            # 004aaa40
L_004aaa45:
    # block 0x004aaa45: entered by je at 0x004aaa32, 7 instruction(s), ends with forward jump to 0x004aaeed
    mov ecx, dword ptr [ebp - local_1c]          # 004aaa45
    mov dword ptr [ecx + field_25], 0x0          # 004aaa48
    mov edx, dword ptr [ebp - local_1c]          # 004aaa4f
    movsx eax, word ptr [edx + field_21]         # 004aaa52
    imul eax, eax, 0x8d                          # 004aaa56
    mov dword ptr [eax + 0x5bb632], 0x1          # 004aaa5c
    jmp.d32 L_004aaeed                           # 004aaa66
L_004aaa6b:
    # block 0x004aaa6b: entered by je at 0x004aa859, 5 instruction(s), ends with je to 0x004aab1a (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004aaa6b
    mov edx, dword ptr [ecx + field_25]          # 004aaa6e
    mov dword ptr [ebp - local_24], edx          # 004aaa71
    cmp dword ptr [ebp - local_24], 0x1          # 004aaa74
    je.d32 L_004aab1a                            # 004aaa78
    # block 0x004aaa7e: entered by fall-through of je at 0x004aaa78, 2 instruction(s), ends with je to 0x004aaa93 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 004aaa7e
    je.d8 L_004aaa93                             # 004aaa82
    # block 0x004aaa84: entered by fall-through of je at 0x004aaa82, 2 instruction(s), ends with je to 0x004aabff (forward)
    cmp dword ptr [ebp - local_24], 0x4          # 004aaa84
    je.d32 L_004aabff                            # 004aaa88
    # block 0x004aaa8e: entered by fall-through of je at 0x004aaa88, 1 instruction(s), ends with forward jump to 0x004aac49
    jmp.d32 L_004aac49                           # 004aaa8e
L_004aaa93:
    # block 0x004aaa93: entered by je at 0x004aaa82, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x004aab15 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004aaa93
    movsx ecx, word ptr [eax + field_42]         # 004aaa96
    imul ecx, ecx, 0x15c                         # 004aaa9a
    mov edx, dword ptr [ebp - local_4]           # 004aaaa0
    movsx eax, word ptr [edx + ecx + field_13a]  # 004aaaa3
    mov dword ptr [ebp - local_8], eax           # 004aaaab
    mov ecx, dword ptr [ebp - local_8]           # 004aaaae
    push ecx                                     # 004aaab1
    mov ecx, 0x5cf1eb                            # 004aaab2
    call FUN_004f6334                            # 004aaab7
    test eax, eax                                # 004aaabc
    jne.d8 L_004aab15                            # 004aaabe
    # block 0x004aaac0: entered by fall-through of jne at 0x004aaabe, 10 instruction(s), calls FUN_004fba69, ends with je to 0x004aab04 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004aaac0
    movsx eax, word ptr [edx + field_42]         # 004aaac3
    imul eax, eax, 0x15c                         # 004aaac7
    mov ecx, dword ptr [ebp - local_4]           # 004aaacd
    lea edx, [ecx + eax + field_119]             # 004aaad0
    push edx                                     # 004aaad7
    mov ecx, 0x5c3a67                            # 004aaad8
    call FUN_004fba69                            # 004aaadd
    cmp dword ptr [0x5bb202], 0x0                # 004aaae2
    je.d8 L_004aab04                             # 004aaae9
    # block 0x004aaaeb: entered by fall-through of je at 0x004aaae9, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x004aab04
    push 0x0                                     # 004aaaeb
    push -0x1                                    # 004aaaed
    push 0x550eac                                # 004aaaef
    mov eax, dword ptr [0x5d03b3]                # 004aaaf4
    push eax                                     # 004aaaf9
    mov ecx, 0x619a05                            # 004aaafa
    call FUN_00448d11                            # 004aaaff
L_004aab04:
    # block 0x004aab04: entered by je at 0x004aaae9, 4 instruction(s), falls into the block at 0x004aab15
    mov ecx, dword ptr [ebp - local_1c]          # 004aab04
    mov byte ptr [ecx + field_2b], 0x1           # 004aab07
    mov edx, dword ptr [ebp - local_1c]          # 004aab0b
    mov dword ptr [edx + field_25], 0x0          # 004aab0e
L_004aab15:
    # block 0x004aab15: entered by jne at 0x004aaabe, 1 instruction(s), ends with forward jump to 0x004aac49
    jmp.d32 L_004aac49                           # 004aab15
L_004aab1a:
    # block 0x004aab1a: entered by je at 0x004aaa78, 7 instruction(s), ends with je to 0x004aabc3 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004aab1a
    movsx ecx, word ptr [eax + field_42]         # 004aab1d
    mov edx, dword ptr [ebp - local_1c]          # 004aab21
    {load} xor eax, eax                          # 004aab24
    mov al, byte ptr [edx + ecx + field_2c]      # 004aab26
    test eax, eax                                # 004aab2a
    je.d32 L_004aabc3                            # 004aab2c
    # block 0x004aab32: entered by fall-through of je at 0x004aab2c, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004aabc3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004aab32
    movsx edx, word ptr [ecx + field_73]         # 004aab35
    mov dword ptr [ebp - local_c], edx           # 004aab39
    mov eax, dword ptr [ebp - local_c]           # 004aab3c
    push eax                                     # 004aab3f
    mov ecx, 0x5cf1eb                            # 004aab40
    call FUN_004f6334                            # 004aab45
    test eax, eax                                # 004aab4a
    jne.d8 L_004aabc3                            # 004aab4c
    # block 0x004aab4e: entered by fall-through of jne at 0x004aab4c, 6 instruction(s), ends with jne to 0x004aabb7 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004aab4e
    movsx edx, word ptr [ecx + field_48]         # 004aab51
    mov eax, dword ptr [ebp - local_4]           # 004aab55
    movsx ecx, word ptr [eax + field_f7]         # 004aab58
    {load} cmp edx, ecx                          # 004aab5f
    jne.d8 L_004aabb7                            # 004aab61
    # block 0x004aab63: entered by fall-through of jne at 0x004aab61, 7 instruction(s), ends with je to 0x004aaba4 (forward)
    mov edi, 0x550eb4                            # 004aab63
    mov esi, dword ptr [ebp - local_4]           # 004aab68
    add esi, 0x9d                                # 004aab6b
    mov ecx, 0x9                                 # 004aab71
    {load} xor edx, edx                          # 004aab76
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aab78
    je.d8 L_004aaba4                             # 004aab7a
    # block 0x004aab7c: entered by fall-through of je at 0x004aab7a, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004aaba4
    mov eax, dword ptr [ebp - local_4]           # 004aab7c
    add eax, 0x9d                                # 004aab7f
    push eax                                     # 004aab84
    mov ecx, 0x5c3a67                            # 004aab85
    call FUN_004fb77a                            # 004aab8a
    mov ecx, dword ptr [ebp - local_4]           # 004aab8f
    mov dx, word ptr [ecx + field_be]            # 004aab92
    push edx                                     # 004aab99
    mov ecx, 0x5c3a67                            # 004aab9a
    call FUN_004fb2e3                            # 004aab9f
L_004aaba4:
    # block 0x004aaba4: entered by je at 0x004aab7a, 5 instruction(s), ends with forward jump to 0x004aabc1
    mov eax, dword ptr [ebp - local_1c]          # 004aaba4
    mov byte ptr [eax + field_47], 0x1           # 004aaba7
    mov ecx, dword ptr [ebp - local_1c]          # 004aabab
    mov dword ptr [ecx + field_25], 0x4          # 004aabae
    jmp.d8 L_004aabc1                            # 004aabb5
L_004aabb7:
    # block 0x004aabb7: entered by jne at 0x004aab61, 2 instruction(s), falls into the block at 0x004aabc1
    mov edx, dword ptr [ebp - local_1c]          # 004aabb7
    mov dword ptr [edx + field_25], 0x0          # 004aabba
L_004aabc1:
    # block 0x004aabc1: entered by jmp at 0x004aabb5, 1 instruction(s), ends with forward jump to 0x004aabfd
    jmp.d8 L_004aabfd                            # 004aabc1
L_004aabc3:
    # block 0x004aabc3: entered by je at 0x004aab2c; jne at 0x004aab4c, 7 instruction(s), ends with jne to 0x004aabfd (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004aabc3
    movsx ecx, word ptr [eax + field_42]         # 004aabc6
    mov edx, dword ptr [ebp - local_1c]          # 004aabca
    {load} xor eax, eax                          # 004aabcd
    mov al, byte ptr [edx + ecx + field_2c]      # 004aabcf
    test eax, eax                                # 004aabd3
    jne.d8 L_004aabfd                            # 004aabd5
    # block 0x004aabd7: entered by fall-through of jne at 0x004aabd5, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004aabfd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004aabd7
    movsx edx, word ptr [ecx + field_42]         # 004aabda
    mov dword ptr [ebp - local_10], edx          # 004aabde
    mov eax, dword ptr [ebp - local_10]          # 004aabe1
    push eax                                     # 004aabe4
    mov ecx, 0x5cf1eb                            # 004aabe5
    call FUN_004f6334                            # 004aabea
    test eax, eax                                # 004aabef
    jne.d8 L_004aabfd                            # 004aabf1
    # block 0x004aabf3: entered by fall-through of jne at 0x004aabf1, 2 instruction(s), falls into the block at 0x004aabfd
    mov ecx, dword ptr [ebp - local_1c]          # 004aabf3
    mov dword ptr [ecx + field_25], 0x0          # 004aabf6
L_004aabfd:
    # block 0x004aabfd: entered by jmp at 0x004aabc1; jne at 0x004aabd5; jne at 0x004aabf1, 1 instruction(s), ends with forward jump to 0x004aac49
    jmp.d8 L_004aac49                            # 004aabfd
L_004aabff:
    # block 0x004aabff: entered by je at 0x004aaa88, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004aac49 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004aabff
    movsx eax, word ptr [edx + field_be]         # 004aac02
    mov dword ptr [ebp - local_14], eax          # 004aac09
    mov ecx, dword ptr [ebp - local_14]          # 004aac0c
    push ecx                                     # 004aac0f
    mov ecx, 0x5cf1eb                            # 004aac10
    call FUN_004f6334                            # 004aac15
    test eax, eax                                # 004aac1a
    jne.d8 L_004aac49                            # 004aac1c
    # block 0x004aac1e: entered by fall-through of jne at 0x004aac1c, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004aac49
    mov edx, dword ptr [ebp - local_4]           # 004aac1e
    add edx, 0x9d                                # 004aac21
    push edx                                     # 004aac27
    mov ecx, 0x5c3a67                            # 004aac28
    call FUN_004fba69                            # 004aac2d
    mov eax, dword ptr [ebp - local_1c]          # 004aac32
    movsx ecx, word ptr [eax + field_21]         # 004aac35
    imul ecx, ecx, 0x8d                          # 004aac39
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004aac3f
L_004aac49:
    # block 0x004aac49: entered by jmp at 0x004aaa8e; jmp at 0x004aab15; jmp at 0x004aabfd; jne at 0x004aac1c, 1 instruction(s), ends with forward jump to 0x004aaeed
    jmp.d32 L_004aaeed                           # 004aac49
L_004aac4e:
    # block 0x004aac4e: entered by je at 0x004aa863, 11 instruction(s), ends with je to 0x004aac90 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004aac4e
    mov edx, dword ptr [ebp - local_1c]          # 004aac58
    mov byte ptr [edx + field_45], 0x0           # 004aac5b
    mov dword ptr [0x5d1a8f], 0x0                # 004aac5f
    mov edi, 0x550ec0                            # 004aac69
    mov esi, dword ptr [ebp - local_4]           # 004aac6e
    add esi, 0x21                                # 004aac71
    mov ecx, 0x9                                 # 004aac74
    {load} xor eax, eax                          # 004aac79
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aac7b
    je.d8 L_004aac90                             # 004aac7d
    # block 0x004aac7f: entered by fall-through of je at 0x004aac7d, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004aac90
    mov ecx, dword ptr [ebp - local_4]           # 004aac7f
    add ecx, 0x21                                # 004aac82
    push ecx                                     # 004aac85
    mov ecx, 0x5c3a67                            # 004aac86
    call FUN_004fba69                            # 004aac8b
L_004aac90:
    # block 0x004aac90: entered by je at 0x004aac7d, 7 instruction(s), ends with je to 0x004aacb7 (forward)
    mov edi, 0x550ecc                            # 004aac90
    mov esi, dword ptr [ebp - local_4]           # 004aac95
    add esi, 0x52                                # 004aac98
    mov ecx, 0x9                                 # 004aac9b
    {load} xor edx, edx                          # 004aaca0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aaca2
    je.d8 L_004aacb7                             # 004aaca4
    # block 0x004aaca6: entered by fall-through of je at 0x004aaca4, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004aacb7
    mov eax, dword ptr [ebp - local_4]           # 004aaca6
    add eax, 0x52                                # 004aaca9
    push eax                                     # 004aacac
    mov ecx, 0x5c3a67                            # 004aacad
    call FUN_004fba69                            # 004aacb2
L_004aacb7:
    # block 0x004aacb7: entered by je at 0x004aaca4, 5 instruction(s), ends with je to 0x004aadf8 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004aacb7
    {load} xor edx, edx                          # 004aacba
    mov dl, byte ptr [ecx + field_46]            # 004aacbc
    test edx, edx                                # 004aacbf
    je.d32 L_004aadf8                            # 004aacc1
    # block 0x004aacc7: entered by fall-through of je at 0x004aacc1, 12 instruction(s), calls FUN_004f6334, ends with je to 0x004aad16 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004aacc7
    movsx ecx, word ptr [eax + field_42]         # 004aacca
    imul ecx, ecx, 0x15c                         # 004aacce
    mov edx, dword ptr [ebp - local_4]           # 004aacd4
    movsx eax, word ptr [edx + ecx + field_13a]  # 004aacd7
    mov dword ptr [ebp - local_18], eax          # 004aacdf
    mov ecx, dword ptr [ebp - local_18]          # 004aace2
    push ecx                                     # 004aace5
    mov ecx, 0x5cf1eb                            # 004aace6
    call FUN_004f6334                            # 004aaceb
    test eax, eax                                # 004aacf0
    je.d8 L_004aad16                             # 004aacf2
    # block 0x004aacf4: entered by fall-through of je at 0x004aacf2, 8 instruction(s), calls FUN_004fba69, falls into the block at 0x004aad16
    mov edx, dword ptr [ebp - local_1c]          # 004aacf4
    movsx eax, word ptr [edx + field_42]         # 004aacf7
    imul eax, eax, 0x15c                         # 004aacfb
    mov ecx, dword ptr [ebp - local_4]           # 004aad01
    lea edx, [ecx + eax + field_119]             # 004aad04
    push edx                                     # 004aad0b
    mov ecx, 0x5c3a67                            # 004aad0c
    call FUN_004fba69                            # 004aad11
L_004aad16:
    # block 0x004aad16: entered by je at 0x004aacf2, 4 instruction(s), ends with je to 0x004aadc8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004aad16
    movsx ecx, word ptr [eax + field_ce]         # 004aad19
    cmp ecx, 0x270f                              # 004aad20
    je.d32 L_004aadc8                            # 004aad26
    # block 0x004aad2c: entered by fall-through of je at 0x004aad26, 25 instruction(s), ends with jne to 0x004aadb4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004aad2c
    movsx eax, word ptr [edx + field_ce]         # 004aad2f
    mov dword ptr [0x5bb57b], eax                # 004aad36
    mov ecx, dword ptr [ebp - local_4]           # 004aad3b
    mov dx, word ptr [ecx + field_d0]            # 004aad3e
    mov word ptr [0x5bb599], dx                  # 004aad45
    mov eax, dword ptr [ebp - local_4]           # 004aad4c
    mov cx, word ptr [eax + field_d2]            # 004aad4f
    mov word ptr [0x5bb595], cx                  # 004aad56
    mov edx, dword ptr [ebp - local_4]           # 004aad5d
    mov ax, word ptr [edx + field_d4]            # 004aad60
    mov word ptr [0x5c39ff], ax                  # 004aad67
    mov ecx, dword ptr [ebp - local_4]           # 004aad6d
    mov edx, dword ptr [ecx + field_d6]          # 004aad70
    mov dword ptr [0x5bb59b], edx                # 004aad76
    mov eax, dword ptr [ebp - local_4]           # 004aad7c
    mov ecx, dword ptr [eax + field_da]          # 004aad7f
    mov dword ptr [0x5bb59f], ecx                # 004aad85
    mov edx, dword ptr [ebp - local_4]           # 004aad8b
    mov eax, dword ptr [edx + field_de]          # 004aad8e
    mov dword ptr [0x5bb5a3], eax                # 004aad94
    mov ecx, dword ptr [ebp - local_4]           # 004aad99
    movsx edx, word ptr [ecx + field_e2]         # 004aad9c
    cmp edx, 0x1                                 # 004aada3
    jne.d8 L_004aadb4                            # 004aada6
    # block 0x004aada8: entered by fall-through of jne at 0x004aada6, 2 instruction(s), ends with forward jump to 0x004aadbe
    mov dword ptr [0x5bb1ca], 0x0                # 004aada8
    jmp.d8 L_004aadbe                            # 004aadb2
L_004aadb4:
    # block 0x004aadb4: entered by jne at 0x004aada6, 1 instruction(s), falls into the block at 0x004aadbe
    mov dword ptr [0x5bb1ca], 0x1                # 004aadb4
L_004aadbe:
    # block 0x004aadbe: entered by jmp at 0x004aadb2, 1 instruction(s), falls into the block at 0x004aadc8
    mov dword ptr [0x583999], 0x4                # 004aadbe
L_004aadc8:
    # block 0x004aadc8: entered by je at 0x004aad26, 4 instruction(s), ends with je to 0x004aadf3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004aadc8
    movsx ecx, word ptr [eax + field_e4]         # 004aadcb
    cmp ecx, -0x1                                # 004aadd2
    je.d8 L_004aadf3                             # 004aadd5
    # block 0x004aadd7: entered by fall-through of je at 0x004aadd5, 6 instruction(s), falls into the block at 0x004aadf3
    mov edx, dword ptr [ebp - local_4]           # 004aadd7
    {load} xor eax, eax                          # 004aadda
    mov al, byte ptr [edx + field_e6]            # 004aaddc
    mov ecx, dword ptr [ebp - local_4]           # 004aade2
    movsx edx, word ptr [ecx + field_e4]         # 004aade5
    mov dword ptr [4*edx + 0x585801], eax        # 004aadec
L_004aadf3:
    # block 0x004aadf3: entered by je at 0x004aadd5, 1 instruction(s), ends with forward jump to 0x004aaed5
    jmp.d32 L_004aaed5                           # 004aadf3
L_004aadf8:
    # block 0x004aadf8: entered by je at 0x004aacc1, 4 instruction(s), ends with je to 0x004aaeaa (forward)
    mov eax, dword ptr [ebp - local_4]           # 004aadf8
    movsx ecx, word ptr [eax + field_84]         # 004aadfb
    cmp ecx, 0x270f                              # 004aae02
    je.d32 L_004aaeaa                            # 004aae08
    # block 0x004aae0e: entered by fall-through of je at 0x004aae08, 25 instruction(s), ends with jne to 0x004aae96 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004aae0e
    movsx eax, word ptr [edx + field_84]         # 004aae11
    mov dword ptr [0x5bb57b], eax                # 004aae18
    mov ecx, dword ptr [ebp - local_4]           # 004aae1d
    mov dx, word ptr [ecx + field_86]            # 004aae20
    mov word ptr [0x5bb599], dx                  # 004aae27
    mov eax, dword ptr [ebp - local_4]           # 004aae2e
    mov cx, word ptr [eax + field_88]            # 004aae31
    mov word ptr [0x5bb595], cx                  # 004aae38
    mov edx, dword ptr [ebp - local_4]           # 004aae3f
    mov ax, word ptr [edx + field_8a]            # 004aae42
    mov word ptr [0x5c39ff], ax                  # 004aae49
    mov ecx, dword ptr [ebp - local_4]           # 004aae4f
    mov edx, dword ptr [ecx + field_8c]          # 004aae52
    mov dword ptr [0x5bb59b], edx                # 004aae58
    mov eax, dword ptr [ebp - local_4]           # 004aae5e
    mov ecx, dword ptr [eax + field_90]          # 004aae61
    mov dword ptr [0x5bb59f], ecx                # 004aae67
    mov edx, dword ptr [ebp - local_4]           # 004aae6d
    mov eax, dword ptr [edx + field_94]          # 004aae70
    mov dword ptr [0x5bb5a3], eax                # 004aae76
    mov ecx, dword ptr [ebp - local_4]           # 004aae7b
    movsx edx, word ptr [ecx + field_98]         # 004aae7e
    cmp edx, 0x1                                 # 004aae85
    jne.d8 L_004aae96                            # 004aae88
    # block 0x004aae8a: entered by fall-through of jne at 0x004aae88, 2 instruction(s), ends with forward jump to 0x004aaea0
    mov dword ptr [0x5bb1ca], 0x0                # 004aae8a
    jmp.d8 L_004aaea0                            # 004aae94
L_004aae96:
    # block 0x004aae96: entered by jne at 0x004aae88, 1 instruction(s), falls into the block at 0x004aaea0
    mov dword ptr [0x5bb1ca], 0x1                # 004aae96
L_004aaea0:
    # block 0x004aaea0: entered by jmp at 0x004aae94, 1 instruction(s), falls into the block at 0x004aaeaa
    mov dword ptr [0x583999], 0x4                # 004aaea0
L_004aaeaa:
    # block 0x004aaeaa: entered by je at 0x004aae08, 4 instruction(s), ends with je to 0x004aaed5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004aaeaa
    movsx ecx, word ptr [eax + field_9a]         # 004aaead
    cmp ecx, -0x1                                # 004aaeb4
    je.d8 L_004aaed5                             # 004aaeb7
    # block 0x004aaeb9: entered by fall-through of je at 0x004aaeb7, 6 instruction(s), falls into the block at 0x004aaed5
    mov edx, dword ptr [ebp - local_4]           # 004aaeb9
    {load} xor eax, eax                          # 004aaebc
    mov al, byte ptr [edx + field_9c]            # 004aaebe
    mov ecx, dword ptr [ebp - local_4]           # 004aaec4
    movsx edx, word ptr [ecx + field_9a]         # 004aaec7
    mov dword ptr [4*edx + 0x585801], eax        # 004aaece
L_004aaed5:
    # block 0x004aaed5: entered by jmp at 0x004aadf3; je at 0x004aaeb7, 7 instruction(s), calls FUN_0042ba3a, FUN_004a9f63, falls into the block at 0x004aaeed
    mov eax, dword ptr [ebp - local_1c]          # 004aaed5
    mov cx, word ptr [eax + field_21]            # 004aaed8
    push ecx                                     # 004aaedc
    call FUN_0042ba3a                            # 004aaedd
    add esp, 0x4                                 # 004aaee2
    mov ecx, dword ptr [ebp - local_1c]          # 004aaee5
    call FUN_004a9f63                            # 004aaee8
L_004aaeed:
    # block 0x004aaeed: entered by jmp at 0x004aa869; jmp at 0x004aaa66; jmp at 0x004aac49, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004aaeed
    pop esi                                      # 004aaeee
    {load} mov esp, ebp                          # 004aaeef
    pop ebp                                      # 004aaef1
    ret 0x4                                      # 004aaef2

