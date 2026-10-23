# FUN_004e8622
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8622
# extent:       0x004e8622-0x004e8994 (882 code bytes)
# span:         0x004e8622-0x004e8994 (code 882, tables 0, padding 0)
# sha256:       47f48692cdc43abe891bc97857dcc63000337a0d01c9d8a26b8c60b8dcc9f5cc
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e8622
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_6f10, field_6f18, field_7016, field_7fb6, field_7fc6, field_7fd2, field_822e, field_8232; [ecx + n] field_4, field_8, field_c, field_6b87, field_6e10, field_6f10, field_6f1c, field_7012, field_7016, field_701a, field_7654, field_7fca and 1 more; [edx + n] field_4, field_8, field_c, field_6f14, field_7654, field_7fc6, field_7fce, field_822e, field_8236
# callees:      calls FUN_004ee572, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004e7ba7, FUN_004edcb1, FUN_004ee6c7, FUN_004ee673, FUN_004e1db3, FUN_004e2990, FUN_004e29b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 209 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_6b87, 0x6b87  # offset +0x6b87
.equ field_6e10, 0x6e10  # offset +0x6e10
.equ field_6f10, 0x6f10  # offset +0x6f10
.equ field_6f14, 0x6f14  # offset +0x6f14
.equ field_6f18, 0x6f18  # offset +0x6f18
.equ field_6f1c, 0x6f1c  # offset +0x6f1c
.equ field_7012, 0x7012  # offset +0x7012
.equ field_7016, 0x7016  # offset +0x7016
.equ field_701a, 0x701a  # offset +0x701a
.equ field_7654, 0x7654  # offset +0x7654
.equ field_7fb6, 0x7fb6  # offset +0x7fb6
.equ field_7fc6, 0x7fc6  # offset +0x7fc6
.equ field_7fca, 0x7fca  # offset +0x7fca
.equ field_7fce, 0x7fce  # offset +0x7fce
.equ field_7fd2, 0x7fd2  # offset +0x7fd2
.equ field_822e, 0x822e  # offset +0x822e
.equ field_8232, 0x8232  # offset +0x8232
.equ field_8236, 0x8236  # offset +0x8236

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)
.set FUN_004e2990, .text + (0x004e2990 - 0x401000)
.set FUN_004e29b7, .text + (0x004e29b7 - 0x401000)
.set FUN_004e7ba7, .text + (0x004e7ba7 - 0x401000)
.set FUN_004edcb1, .text + (0x004edcb1 - 0x401000)
.set FUN_004ee572, .text + (0x004ee572 - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e8622 - 0x401000
.globl FUN_004e8622
FUN_004e8622:
    # block 0x004e8622: entry, 8 instruction(s), calls FUN_004ee572, ends with je to 0x004e8686 (forward)
    push ebp                                     # 004e8622
    {load} mov ebp, esp                          # 004e8623
    push ecx                                     # 004e8625
    mov dword ptr [ebp - local_4], ecx           # 004e8626
    mov ecx, dword ptr [ebp - local_4]           # 004e8629
    call FUN_004ee572                            # 004e862c
    test eax, eax                                # 004e8631
    je.d8 L_004e8686                             # 004e8633
    # block 0x004e8635: entered by fall-through of je at 0x004e8633, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004e8677 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8635
    call FUN_004ee5f2                            # 004e8638
    push eax                                     # 004e863d
    push 0x55c5f0                                # 004e863e
    push 0x63888b                                # 004e8643
    call FUN_0050ca3e                            # 004e8648
    add esp, 0xc                                 # 004e864d
    push 0x63888b                                # 004e8650
    mov ecx, 0x583979                            # 004e8655
    call FUN_004264e8                            # 004e865a
    movsx eax, word ptr [0x63a4cd]               # 004e865f
    test eax, eax                                # 004e8666
    je.d8 L_004e8677                             # 004e8668
    # block 0x004e866a: entered by fall-through of je at 0x004e8668, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e8677
    push 0x63888b                                # 004e866a
    call FUN_0044a2b7                            # 004e866f
    add esp, 0x4                                 # 004e8674
L_004e8677:
    # block 0x004e8677: entered by je at 0x004e8668, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004e8990
    mov ecx, 0x5cf659                            # 004e8677
    call FUN_004c97b4                            # 004e867c
    jmp.d32 L_004e8990                           # 004e8681
L_004e8686:
    # block 0x004e8686: entered by je at 0x004e8633, 17 instruction(s), calls FUN_004e7ba7, FUN_004edcb1, FUN_004ee6c7, FUN_004ee673, ends with forward jump to 0x004e86da
    mov ecx, dword ptr [ebp - local_4]           # 004e8686
    call FUN_004e7ba7                            # 004e8689
    push 0x1                                     # 004e868e
    mov ecx, dword ptr [ebp - local_4]           # 004e8690
    add ecx, 0x6b20                              # 004e8693
    push ecx                                     # 004e8699
    mov ecx, dword ptr [ebp - local_4]           # 004e869a
    call FUN_004edcb1                            # 004e869d
    push 0x1                                     # 004e86a2
    mov ecx, dword ptr [ebp - local_4]           # 004e86a4
    call FUN_004ee6c7                            # 004e86a7
    push 0x0                                     # 004e86ac
    mov ecx, dword ptr [ebp - local_4]           # 004e86ae
    call FUN_004ee673                            # 004e86b1
    mov edx, dword ptr [ebp - local_4]           # 004e86b6
    mov dword ptr [edx + field_822e], 0x0        # 004e86b9
    jmp.d8 L_004e86da                            # 004e86c3
L_004e86c5:
    # block 0x004e86c5: entered by jmp at 0x004e8848, 5 instruction(s), falls into the block at 0x004e86da
    mov eax, dword ptr [ebp - local_4]           # 004e86c5
    mov ecx, dword ptr [eax + field_822e]        # 004e86c8
    add ecx, 0x1                                 # 004e86ce
    mov edx, dword ptr [ebp - local_4]           # 004e86d1
    mov dword ptr [edx + field_822e], ecx        # 004e86d4
L_004e86da:
    # block 0x004e86da: entered by jmp at 0x004e86c3, 3 instruction(s), ends with jge to 0x004e884d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e86da
    cmp dword ptr [eax + field_822e], 0x10       # 004e86dd
    jge.d32 L_004e884d                           # 004e86e4
    # block 0x004e86ea: entered by fall-through of jge at 0x004e86e4, 3 instruction(s), ends with je to 0x004e87c4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e86ea
    cmp dword ptr [ecx + field_6b87], 0x0        # 004e86ed
    je.d32 L_004e87c4                            # 004e86f4
    # block 0x004e86fa: entered by fall-through of je at 0x004e86f4, 45 instruction(s), ends with forward jump to 0x004e8806
    mov edx, dword ptr [ebp - local_4]           # 004e86fa
    mov eax, dword ptr [edx + field_822e]        # 004e86fd
    shl eax, 0x4                                 # 004e8703
    mov ecx, dword ptr [ebp - local_4]           # 004e8706
    mov edx, dword ptr [ecx + eax + field_6f10]  # 004e8709
    add edx, dword ptr [0x583186]                # 004e8710
    mov eax, dword ptr [ebp - local_4]           # 004e8716
    mov ecx, dword ptr [eax + field_822e]        # 004e8719
    imul ecx, ecx, 0x28                          # 004e871f
    mov eax, dword ptr [ebp - local_4]           # 004e8722
    mov dword ptr [eax + ecx + field_7fc6], edx  # 004e8725
    mov ecx, dword ptr [ebp - local_4]           # 004e872c
    mov edx, dword ptr [ecx + field_822e]        # 004e872f
    shl edx, 0x4                                 # 004e8735
    mov eax, dword ptr [ebp - local_4]           # 004e8738
    mov ecx, dword ptr [eax + edx + field_6f18]  # 004e873b
    add ecx, dword ptr [0x583186]                # 004e8742
    mov edx, dword ptr [ebp - local_4]           # 004e8748
    mov eax, dword ptr [edx + field_822e]        # 004e874b
    imul eax, eax, 0x28                          # 004e8751
    mov edx, dword ptr [ebp - local_4]           # 004e8754
    mov dword ptr [edx + eax + field_7fce], ecx  # 004e8757
    mov eax, dword ptr [ebp - local_4]           # 004e875e
    mov ecx, dword ptr [eax + field_822e]        # 004e8761
    shl ecx, 0x4                                 # 004e8767
    mov edx, dword ptr [ebp - local_4]           # 004e876a
    mov eax, dword ptr [edx + ecx + field_6f14]  # 004e876d
    add eax, dword ptr [0x58318a]                # 004e8774
    mov ecx, dword ptr [ebp - local_4]           # 004e877a
    mov edx, dword ptr [ecx + field_822e]        # 004e877d
    imul edx, edx, 0x28                          # 004e8783
    mov ecx, dword ptr [ebp - local_4]           # 004e8786
    mov dword ptr [ecx + edx + field_7fca], eax  # 004e8789
    mov edx, dword ptr [ebp - local_4]           # 004e8790
    mov eax, dword ptr [edx + field_822e]        # 004e8793
    shl eax, 0x4                                 # 004e8799
    mov ecx, dword ptr [ebp - local_4]           # 004e879c
    mov edx, dword ptr [ecx + eax + field_6f1c]  # 004e879f
    add edx, dword ptr [0x58318a]                # 004e87a6
    mov eax, dword ptr [ebp - local_4]           # 004e87ac
    mov ecx, dword ptr [eax + field_822e]        # 004e87af
    imul ecx, ecx, 0x28                          # 004e87b5
    mov eax, dword ptr [ebp - local_4]           # 004e87b8
    mov dword ptr [eax + ecx + field_7fd2], edx  # 004e87bb
    jmp.d8 L_004e8806                            # 004e87c2
L_004e87c4:
    # block 0x004e87c4: entered by je at 0x004e86f4, 18 instruction(s), falls into the block at 0x004e8806
    mov ecx, dword ptr [ebp - local_4]           # 004e87c4
    mov edx, dword ptr [ecx + field_822e]        # 004e87c7
    shl edx, 0x4                                 # 004e87cd
    mov eax, dword ptr [ebp - local_4]           # 004e87d0
    lea ecx, [eax + edx + field_6f10]            # 004e87d3
    mov edx, dword ptr [ebp - local_4]           # 004e87da
    mov eax, dword ptr [edx + field_822e]        # 004e87dd
    imul eax, eax, 0x28                          # 004e87e3
    mov edx, dword ptr [ebp - local_4]           # 004e87e6
    lea eax, [edx + eax + field_7fc6]            # 004e87e9
    mov edx, dword ptr [ecx]                     # 004e87f0
    mov dword ptr [eax], edx                     # 004e87f2
    mov edx, dword ptr [ecx + field_4]           # 004e87f4
    mov dword ptr [eax + field_4], edx           # 004e87f7
    mov edx, dword ptr [ecx + field_8]           # 004e87fa
    mov dword ptr [eax + field_8], edx           # 004e87fd
    mov ecx, dword ptr [ecx + field_c]           # 004e8800
    mov dword ptr [eax + field_c], ecx           # 004e8803
L_004e8806:
    # block 0x004e8806: entered by jmp at 0x004e87c2, 19 instruction(s), ends with backward jump to 0x004e86c5
    mov edx, dword ptr [ebp - local_4]           # 004e8806
    mov eax, dword ptr [edx + field_822e]        # 004e8809
    shl eax, 0x4                                 # 004e880f
    mov ecx, dword ptr [ebp - local_4]           # 004e8812
    lea edx, [ecx + eax + field_6e10]            # 004e8815
    mov eax, dword ptr [ebp - local_4]           # 004e881c
    mov ecx, dword ptr [eax + field_822e]        # 004e881f
    imul ecx, ecx, 0x28                          # 004e8825
    mov eax, dword ptr [ebp - local_4]           # 004e8828
    lea ecx, [eax + ecx + field_7fb6]            # 004e882b
    mov eax, dword ptr [edx]                     # 004e8832
    mov dword ptr [ecx], eax                     # 004e8834
    mov eax, dword ptr [edx + field_4]           # 004e8836
    mov dword ptr [ecx + field_4], eax           # 004e8839
    mov eax, dword ptr [edx + field_8]           # 004e883c
    mov dword ptr [ecx + field_8], eax           # 004e883f
    mov edx, dword ptr [edx + field_c]           # 004e8842
    mov dword ptr [ecx + field_c], edx           # 004e8845
    jmp.d32 L_004e86c5                           # 004e8848
L_004e884d:
    # block 0x004e884d: entered by jge at 0x004e86e4, 3 instruction(s), ends with forward jump to 0x004e8871
    mov eax, dword ptr [ebp - local_4]           # 004e884d
    mov dword ptr [eax + field_822e], 0x0        # 004e8850
    jmp.d8 L_004e8871                            # 004e885a
L_004e885c:
    # block 0x004e885c: entered by jmp at 0x004e898b, 5 instruction(s), falls into the block at 0x004e8871
    mov ecx, dword ptr [ebp - local_4]           # 004e885c
    mov edx, dword ptr [ecx + field_822e]        # 004e885f
    add edx, 0x1                                 # 004e8865
    mov eax, dword ptr [ebp - local_4]           # 004e8868
    mov dword ptr [eax + field_822e], edx        # 004e886b
L_004e8871:
    # block 0x004e8871: entered by jmp at 0x004e885a, 3 instruction(s), ends with jge to 0x004e8990 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8871
    cmp dword ptr [ecx + field_822e], 0x6        # 004e8874
    jge.d32 L_004e8990                           # 004e887b
    # block 0x004e8881: entered by fall-through of jge at 0x004e887b, 6 instruction(s), ends with je to 0x004e898b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e8881
    mov eax, dword ptr [edx + field_822e]        # 004e8884
    imul eax, eax, 0xf7                          # 004e888a
    mov ecx, dword ptr [ebp - local_4]           # 004e8890
    cmp dword ptr [ecx + eax + field_7012], 0x0  # 004e8893
    je.d32 L_004e898b                            # 004e889b
    # block 0x004e88a1: entered by fall-through of je at 0x004e889b, 22 instruction(s), calls FUN_004e1db3, FUN_004e2990, ends with jne to 0x004e896b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e88a1
    mov eax, dword ptr [edx + field_822e]        # 004e88a4
    imul eax, eax, 0xf7                          # 004e88aa
    mov ecx, dword ptr [ebp - local_4]           # 004e88b0
    lea edx, [ecx + eax + field_701a]            # 004e88b3
    push edx                                     # 004e88ba
    mov eax, dword ptr [ebp - local_4]           # 004e88bb
    mov ecx, dword ptr [eax + field_822e]        # 004e88be
    imul ecx, ecx, 0x18f                         # 004e88c4
    mov edx, dword ptr [ebp - local_4]           # 004e88ca
    lea ecx, [edx + ecx + field_7654]            # 004e88cd
    call FUN_004e1db3                            # 004e88d4
    push 0x1                                     # 004e88d9
    mov eax, dword ptr [ebp - local_4]           # 004e88db
    mov ecx, dword ptr [eax + field_822e]        # 004e88de
    imul ecx, ecx, 0x18f                         # 004e88e4
    mov edx, dword ptr [ebp - local_4]           # 004e88ea
    lea ecx, [edx + ecx + field_7654]            # 004e88ed
    call FUN_004e2990                            # 004e88f4
    mov eax, dword ptr [ebp - local_4]           # 004e88f9
    cmp dword ptr [eax + field_8232], -0x1       # 004e88fc
    jne.d8 L_004e896b                            # 004e8903
    # block 0x004e8905: entered by fall-through of jne at 0x004e8903, 22 instruction(s), calls FUN_004e29b7, ends with forward jump to 0x004e898b
    mov ecx, dword ptr [ebp - local_4]           # 004e8905
    mov edx, dword ptr [ecx + field_822e]        # 004e8908
    imul edx, edx, 0xf7                          # 004e890e
    mov eax, dword ptr [ebp - local_4]           # 004e8914
    mov ecx, dword ptr [ebp - local_4]           # 004e8917
    mov edx, dword ptr [ecx + edx + field_7016]  # 004e891a
    mov dword ptr [eax + field_8232], edx        # 004e8921
    mov eax, dword ptr [ebp - local_4]           # 004e8927
    mov ecx, dword ptr [eax + field_822e]        # 004e892a
    imul ecx, ecx, 0xf7                          # 004e8930
    mov edx, dword ptr [ebp - local_4]           # 004e8936
    mov eax, dword ptr [ebp - local_4]           # 004e8939
    mov ecx, dword ptr [eax + ecx + field_7016]  # 004e893c
    mov dword ptr [edx + field_8236], ecx        # 004e8943
    push 0x1                                     # 004e8949
    mov edx, dword ptr [ebp - local_4]           # 004e894b
    mov eax, dword ptr [edx + field_822e]        # 004e894e
    imul eax, eax, 0x18f                         # 004e8954
    mov ecx, dword ptr [ebp - local_4]           # 004e895a
    lea ecx, [ecx + eax + field_7654]            # 004e895d
    call FUN_004e29b7                            # 004e8964
    jmp.d8 L_004e898b                            # 004e8969
L_004e896b:
    # block 0x004e896b: entered by jne at 0x004e8903, 7 instruction(s), calls FUN_004e29b7, falls into the block at 0x004e898b
    push 0x0                                     # 004e896b
    mov edx, dword ptr [ebp - local_4]           # 004e896d
    mov eax, dword ptr [edx + field_822e]        # 004e8970
    imul eax, eax, 0x18f                         # 004e8976
    mov ecx, dword ptr [ebp - local_4]           # 004e897c
    lea ecx, [ecx + eax + field_7654]            # 004e897f
    call FUN_004e29b7                            # 004e8986
L_004e898b:
    # block 0x004e898b: entered by je at 0x004e889b; jmp at 0x004e8969, 1 instruction(s), ends with backward jump to 0x004e885c
    jmp.d32 L_004e885c                           # 004e898b
L_004e8990:
    # block 0x004e8990: entered by jmp at 0x004e8681; jge at 0x004e887b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e8990
    pop ebp                                      # 004e8992
    ret                                          # 004e8993

