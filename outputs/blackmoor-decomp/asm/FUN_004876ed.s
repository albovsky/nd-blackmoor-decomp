# FUN_004876ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004876ed
# extent:       0x004876ed-0x004879f7 (778 code bytes)
# span:         0x004876ed-0x00487a00 (code 778, tables 0, padding 9)
# sha256:       3b2a9a30c50cd1aaaf6b0b1bc7158a8fa5d452bb399a7e67245f3ba28eff56de
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004876ed
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_2c
# fields:       [eax + n] field_22, field_28, field_84; [ecx + n] field_22, field_24; [edx + n] field_21, field_22, field_24, field_28, field_7f
# callees:      calls FUN_004c5377, FUN_004841cb, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 208 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_2c, 0x2c  # offset -0x2c
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_7f, 0x7f  # offset +0x7f
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_004841cb, .text + (0x004841cb - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004876ed - 0x401000
.globl FUN_004876ed
FUN_004876ed:
    # block 0x004876ed: entry, 9 instruction(s), ends with jne to 0x0048771b (forward)
    push ebp                                     # 004876ed
    {load} mov ebp, esp                          # 004876ee
    sub esp, 0x2c                                # 004876f0
    movsx eax, word ptr [0x6252d3]               # 004876f3
    imul eax, eax, 0x8d                          # 004876fa
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00487700
    mov dword ptr [ebp - local_c], ecx           # 00487706
    cmp dword ptr [0x625d43], 0x0                # 00487709
    jne.d8 L_0048771b                            # 00487710
    # block 0x00487712: entered by fall-through of jne at 0x00487710, 2 instruction(s), ends with je to 0x0048774b (forward)
    cmp dword ptr [0x625d3f], 0x0                # 00487712
    je.d8 L_0048774b                             # 00487719
L_0048771b:
    # block 0x0048771b: entered by jne at 0x00487710; fall-through of je at 0x00487719, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x0048774b
    push 0x54dc64                                # 0048771b
    push 0x625d6d                                # 00487720
    push 0x625d4d                                # 00487725
    mov edx, dword ptr [0x5cf665]                # 0048772a
    push edx                                     # 00487730
    mov eax, dword ptr [0x5d15e3]                # 00487731
    push eax                                     # 00487736
    mov ecx, 0x5cf659                            # 00487737
    call FUN_004c5377                            # 0048773c
    mov dword ptr [0x625d43], 0x0                # 00487741
L_0048774b:
    # block 0x0048774b: entered by je at 0x00487719, 2 instruction(s), ends with je to 0x00487796 (forward)
    cmp dword ptr [0x625d47], 0x0                # 0048774b
    je.d8 L_00487796                             # 00487752
    # block 0x00487754: entered by fall-through of je at 0x00487752, 16 instruction(s), calls FUN_004841cb, FUN_004c5377, falls into the block at 0x00487796
    lea ecx, [ebp - local_2c]                    # 00487754
    push ecx                                     # 00487757
    push 0x625d8d                                # 00487758
    mov ecx, 0x6252ad                            # 0048775d
    call FUN_004841cb                            # 00487762
    push 0x54dc98                                # 00487767
    lea edx, [ebp - local_2c]                    # 0048776c
    push edx                                     # 0048776f
    push 0x625d8d                                # 00487770
    mov eax, dword ptr [0x5cf665]                # 00487775
    push eax                                     # 0048777a
    mov ecx, dword ptr [0x5d15e3]                # 0048777b
    push ecx                                     # 00487781
    mov ecx, 0x5cf659                            # 00487782
    call FUN_004c5377                            # 00487787
    mov dword ptr [0x625d47], 0x0                # 0048778c
L_00487796:
    # block 0x00487796: entered by je at 0x00487752, 7 instruction(s), ends with je to 0x004877be (forward)
    mov edx, dword ptr [ebp - local_c]           # 00487796
    mov ax, word ptr [edx + field_21]            # 00487799
    mov word ptr [ebp - local_14], ax            # 0048779d
    mov cx, word ptr [ebp - local_14]            # 004877a1
    mov word ptr [ebp - local_1c], cx            # 004877a5
    cmp dword ptr [0x625d3f], 0x0                # 004877a9
    je.d8 L_004877be                             # 004877b0
    # block 0x004877b2: entered by fall-through of je at 0x004877b0, 3 instruction(s), falls into the block at 0x004877be
    mov dx, word ptr [ebp - local_1c]            # 004877b2
    sub dx, 0x1                                  # 004877b6
    mov word ptr [ebp - local_1c], dx            # 004877ba
L_004877be:
    # block 0x004877be: entered by je at 0x004877b0, 3 instruction(s), ends with forward jump to 0x004877d8
    mov word ptr [ebp - local_4], 0x0            # 004877be
    mov word ptr [ebp - local_10], 0x0           # 004877c4
    jmp.d8 L_004877d8                            # 004877ca
L_004877cc:
    # block 0x004877cc: entered by jmp at 0x004878f1, 3 instruction(s), falls into the block at 0x004877d8
    mov ax, word ptr [ebp - local_4]             # 004877cc
    .insn 0x66, 0x05, 0x0001{:u16}               # 004877d0
    mov word ptr [ebp - local_4], ax             # 004877d4
L_004877d8:
    # block 0x004877d8: entered by jmp at 0x004877ca, 4 instruction(s), ends with je to 0x004878f6 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004877d8
    movsx edx, word ptr [ebp - local_1c]         # 004877dc
    {load} cmp ecx, edx                          # 004877e0
    je.d32 L_004878f6                            # 004877e2
    # block 0x004877e8: entered by fall-through of je at 0x004877e2, 2 instruction(s), ends with forward jump to 0x004877fc
    mov word ptr [ebp - local_8], 0x0            # 004877e8
    jmp.d8 L_004877fc                            # 004877ee
L_004877f0:
    # block 0x004877f0: entered by jmp at 0x00487824; jmp at 0x004878ec, 3 instruction(s), falls into the block at 0x004877fc
    mov ax, word ptr [ebp - local_8]             # 004877f0
    .insn 0x66, 0x05, 0x0001{:u16}               # 004877f4
    mov word ptr [ebp - local_8], ax             # 004877f8
L_004877fc:
    # block 0x004877fc: entered by jmp at 0x004877ee, 4 instruction(s), ends with jge to 0x004878f1 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004877fc
    movsx edx, word ptr [ebp - local_14]         # 00487800
    {load} cmp ecx, edx                          # 00487804
    jge.d32 L_004878f1                           # 00487806
    # block 0x0048780c: entered by fall-through of jge at 0x00487806, 2 instruction(s), ends with je to 0x00487826 (forward)
    cmp dword ptr [0x625d3f], 0x0                # 0048780c
    je.d8 L_00487826                             # 00487813
    # block 0x00487815: entered by fall-through of je at 0x00487813, 4 instruction(s), ends with jne to 0x00487826 (forward)
    movsx eax, word ptr [0x625d4b]               # 00487815
    movsx ecx, word ptr [ebp - local_8]          # 0048781c
    {load} cmp eax, ecx                          # 00487820
    jne.d8 L_00487826                            # 00487822
    # block 0x00487824: entered by fall-through of jne at 0x00487822, 1 instruction(s), ends with backward jump to 0x004877f0
    jmp.d8 L_004877f0                            # 00487824
L_00487826:
    # block 0x00487826: entered by je at 0x00487813; jne at 0x00487822, 9 instruction(s), ends with jne to 0x004878ec (forward)
    movsx edx, word ptr [ebp - local_8]          # 00487826
    imul edx, edx, 0x85                          # 0048782a
    add edx, 0x6252d5                            # 00487830
    mov dword ptr [ebp - local_18], edx          # 00487836
    mov eax, dword ptr [ebp - local_18]          # 00487839
    movsx ecx, word ptr [eax]                    # 0048783c
    movsx edx, word ptr [ebp - local_4]          # 0048783f
    {load} cmp ecx, edx                          # 00487843
    jne.d32 L_004878ec                           # 00487845
    # block 0x0048784b: entered by fall-through of jne at 0x00487845, 5 instruction(s), ends with je to 0x0048789f (forward)
    mov eax, dword ptr [ebp - local_18]          # 0048784b
    {load} xor ecx, ecx                          # 0048784e
    mov cl, byte ptr [eax + field_84]            # 00487850
    test ecx, ecx                                # 00487856
    je.d8 L_0048789f                             # 00487858
    # block 0x0048785a: entered by fall-through of je at 0x00487858, 23 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004878d2
    push 0x54dcc8                                # 0048785a
    mov edx, dword ptr [ebp - local_18]          # 0048785f
    add edx, 0x12                                # 00487862
    push edx                                     # 00487865
    mov eax, dword ptr [ebp - local_18]          # 00487866
    {load} xor ecx, ecx                          # 00487869
    mov cl, byte ptr [eax + field_22]            # 0048786b
    imul ecx, ecx, 0x18                          # 0048786e
    mov edx, dword ptr [ebp - local_18]          # 00487871
    lea eax, [edx + ecx + field_28]              # 00487874
    push eax                                     # 00487878
    mov ecx, dword ptr [0x5cf665]                # 00487879
    push ecx                                     # 0048787f
    mov edx, dword ptr [ebp - local_18]          # 00487880
    {load} xor eax, eax                          # 00487883
    mov al, byte ptr [edx + field_22]            # 00487885
    imul eax, eax, 0x18                          # 00487888
    mov ecx, dword ptr [ebp - local_18]          # 0048788b
    mov edx, dword ptr [ecx + eax + field_24]    # 0048788e
    push edx                                     # 00487892
    mov ecx, 0x5cf659                            # 00487893
    call FUN_004c5d4b                            # 00487898
    jmp.d8 L_004878d2                            # 0048789d
L_0048789f:
    # block 0x0048789f: entered by je at 0x00487858, 15 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004878d2
    push 0x54dce8                                # 0048789f
    mov eax, dword ptr [ebp - local_18]          # 004878a4
    add eax, 0x12                                # 004878a7
    push eax                                     # 004878aa
    movsx ecx, word ptr [ebp - local_8]          # 004878ab
    imul ecx, ecx, 0x42                          # 004878af
    mov edx, dword ptr [ebp - local_c]           # 004878b2
    lea eax, [edx + ecx + field_7f]              # 004878b5
    push eax                                     # 004878b9
    mov ecx, dword ptr [0x5cf665]                # 004878ba
    push ecx                                     # 004878c0
    mov edx, dword ptr [0x6252cf]                # 004878c1
    push edx                                     # 004878c7
    mov ecx, 0x5cf659                            # 004878c8
    call FUN_004c5d4b                            # 004878cd
L_004878d2:
    # block 0x004878d2: entered by jmp at 0x0048789d, 7 instruction(s), ends with jne to 0x004878ec (forward)
    mov ax, word ptr [ebp - local_10]            # 004878d2
    .insn 0x66, 0x05, 0x0001{:u16}               # 004878d6
    mov word ptr [ebp - local_10], ax            # 004878da
    movsx ecx, word ptr [ebp - local_10]         # 004878de
    movsx edx, word ptr [ebp - local_1c]         # 004878e2
    {load} cmp ecx, edx                          # 004878e6
    jne.d8 L_004878ec                            # 004878e8
    # block 0x004878ea: entered by fall-through of jne at 0x004878e8, 1 instruction(s), ends with forward jump to 0x004878f1
    jmp.d8 L_004878f1                            # 004878ea
L_004878ec:
    # block 0x004878ec: entered by jne at 0x00487845; jne at 0x004878e8, 1 instruction(s), ends with backward jump to 0x004877f0
    jmp.d32 L_004877f0                           # 004878ec
L_004878f1:
    # block 0x004878f1: entered by jge at 0x00487806; jmp at 0x004878ea, 1 instruction(s), ends with backward jump to 0x004877cc
    jmp.d32 L_004877cc                           # 004878f1
L_004878f6:
    # block 0x004878f6: entered by je at 0x004877e2, 2 instruction(s), ends with je to 0x00487955 (forward)
    cmp dword ptr [0x625d3f], 0x0                # 004878f6
    je.d8 L_00487955                             # 004878fd
    # block 0x004878ff: entered by fall-through of je at 0x004878fd, 24 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00487955
    movsx eax, word ptr [0x625d4b]               # 004878ff
    imul eax, eax, 0x85                          # 00487906
    add eax, 0x6252d5                            # 0048790c
    mov dword ptr [ebp - local_18], eax          # 00487911
    push 0x54dd0c                                # 00487914
    push 0x625d7d                                # 00487919
    mov ecx, dword ptr [ebp - local_18]          # 0048791e
    {load} xor edx, edx                          # 00487921
    mov dl, byte ptr [ecx + field_22]            # 00487923
    imul edx, edx, 0x18                          # 00487926
    mov eax, dword ptr [ebp - local_18]          # 00487929
    lea ecx, [eax + edx + field_28]              # 0048792c
    push ecx                                     # 00487930
    mov edx, dword ptr [0x5cf665]                # 00487931
    push edx                                     # 00487937
    mov eax, dword ptr [ebp - local_18]          # 00487938
    {load} xor ecx, ecx                          # 0048793b
    mov cl, byte ptr [eax + field_22]            # 0048793d
    imul ecx, ecx, 0x18                          # 00487940
    mov edx, dword ptr [ebp - local_18]          # 00487943
    mov eax, dword ptr [edx + ecx + field_24]    # 00487946
    push eax                                     # 0048794a
    mov ecx, 0x5cf659                            # 0048794b
    call FUN_004c5d4b                            # 00487950
L_00487955:
    # block 0x00487955: entered by je at 0x004878fd, 2 instruction(s), ends with je to 0x0048799e (forward)
    cmp dword ptr [0x625e40], 0x0                # 00487955
    je.d8 L_0048799e                             # 0048795c
    # block 0x0048795e: entered by fall-through of je at 0x0048795c, 18 instruction(s), calls FUN_004841cb, FUN_004c5377, ends with forward jump to 0x004879f3
    lea ecx, [ebp - local_2c]                    # 0048795e
    push ecx                                     # 00487961
    mov edx, dword ptr [ebp - local_c]           # 00487962
    add edx, 0x5e8                               # 00487965
    push edx                                     # 0048796b
    mov ecx, 0x6252ad                            # 0048796c
    call FUN_004841cb                            # 00487971
    push 0x54dd34                                # 00487976
    lea eax, [ebp - local_2c]                    # 0048797b
    push eax                                     # 0048797e
    push 0x625e44                                # 0048797f
    mov ecx, dword ptr [0x5cf665]                # 00487984
    push ecx                                     # 0048798a
    mov edx, dword ptr [0x6252cb]                # 0048798b
    push edx                                     # 00487991
    mov ecx, 0x5cf659                            # 00487992
    call FUN_004c5377                            # 00487997
    jmp.d8 L_004879f3                            # 0048799c
L_0048799e:
    # block 0x0048799e: entered by je at 0x0048795c, 2 instruction(s), ends with je to 0x004879f3 (forward)
    cmp dword ptr [0x625e3c], 0x0                # 0048799e
    je.d8 L_004879f3                             # 004879a5
    # block 0x004879a7: entered by fall-through of je at 0x004879a5, 20 instruction(s), calls FUN_004841cb, FUN_004c5377, falls into the block at 0x004879f3
    lea eax, [ebp - local_2c]                    # 004879a7
    push eax                                     # 004879aa
    mov ecx, dword ptr [ebp - local_c]           # 004879ab
    add ecx, 0x5e8                               # 004879ae
    push ecx                                     # 004879b4
    mov ecx, 0x6252ad                            # 004879b5
    call FUN_004841cb                            # 004879ba
    push 0x54dd50                                # 004879bf
    lea edx, [ebp - local_2c]                    # 004879c4
    push edx                                     # 004879c7
    mov eax, dword ptr [ebp - local_c]           # 004879c8
    add eax, 0x5e8                               # 004879cb
    push eax                                     # 004879d0
    mov ecx, dword ptr [0x5cf665]                # 004879d1
    push ecx                                     # 004879d7
    mov edx, dword ptr [0x5d15e3]                # 004879d8
    push edx                                     # 004879de
    mov ecx, 0x5cf659                            # 004879df
    call FUN_004c5377                            # 004879e4
    mov dword ptr [0x625e3c], 0x0                # 004879e9
L_004879f3:
    # block 0x004879f3: entered by jmp at 0x0048799c; je at 0x004879a5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004879f3
    pop ebp                                      # 004879f5
    ret                                          # 004879f6

# --- data items (not part of the function) -------------------------
.org 0x004879f7 - 0x401000
PAD_004879f7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

