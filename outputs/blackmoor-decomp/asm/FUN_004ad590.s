# FUN_004ad590
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ad590
# extent:       0x004ad590-0x004ada0d (1149 code bytes)
# span:         0x004ad590-0x004ada0d (code 1149, tables 0, padding 0)
# sha256:       e487b10086512e31683196fb3ec7725b793b76a6b4180c4195274b46ede8c561
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ad590
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_30, local_34, local_38, local_3c, local_40, local_44, local_46
# fields:       [eax + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_18, field_20, field_22, field_24, field_26 and 9 more; [ecx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_1e, field_20, field_26, field_42, field_4a and 5 more; [edx + n] field_2, field_6, field_a, field_e, field_12, field_14, field_16, field_1a, field_1e, field_20, field_22, field_26 and 3 more
# callees:      calls FUN_004af96e, FUN_004ae683, FUN_004ada0d, FUN_004ae495, FUN_004ae96c, FUN_004aef4a, FUN_004adae8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 351 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_46, 0x46  # offset -0x46
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_42, 0x42  # offset +0x42
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6e, 0x6e  # offset +0x6e
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c1b, 0xc1b  # offset +0xc1b
.equ field_c20, 0xc20  # offset +0xc20
.equ field_c24, 0xc24  # offset +0xc24
.equ field_e57, 0xe57  # offset +0xe57

# --- external targets -----------------------------------------------
.set FUN_004ada0d, .text + (0x004ada0d - 0x401000)
.set FUN_004adae8, .text + (0x004adae8 - 0x401000)
.set FUN_004ae495, .text + (0x004ae495 - 0x401000)
.set FUN_004ae683, .text + (0x004ae683 - 0x401000)
.set FUN_004ae96c, .text + (0x004ae96c - 0x401000)
.set FUN_004aef4a, .text + (0x004aef4a - 0x401000)
.set FUN_004af96e, .text + (0x004af96e - 0x401000)

.org 0x004ad590 - 0x401000
.globl FUN_004ad590
FUN_004ad590:
    # block 0x004ad590: entry, 8 instruction(s), ends with je to 0x004ada08 (forward)
    push ebp                                     # 004ad590
    {load} mov ebp, esp                          # 004ad591
    sub esp, 0x48                                # 004ad593
    push edi                                     # 004ad596
    mov dword ptr [ebp - local_44], ecx          # 004ad597
    mov eax, dword ptr [ebp - local_44]          # 004ad59a
    cmp dword ptr [eax + field_c1b], 0x0         # 004ad59d
    je.d32 L_004ada08                            # 004ad5a4
    # block 0x004ad5aa: entered by fall-through of je at 0x004ad5a4, 5 instruction(s), ends with jne to 0x004ada08 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ad5aa
    {load} xor edx, edx                          # 004ad5ad
    mov dl, byte ptr [ecx + field_c24]           # 004ad5af
    test edx, edx                                # 004ad5b5
    jne.d32 L_004ada08                           # 004ad5b7
    # block 0x004ad5bd: entered by fall-through of jne at 0x004ad5b7, 3 instruction(s), ends with jne to 0x004ada08 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004ad5bd
    cmp dword ptr [eax + field_c20], 0x0         # 004ad5c0
    jne.d32 L_004ada08                           # 004ad5c7
    # block 0x004ad5cd: entered by fall-through of jne at 0x004ad5c7, 5 instruction(s), ends with jne to 0x004ada08 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ad5cd
    movsx edx, word ptr [ecx + field_1e]         # 004ad5d0
    imul edx, edx, 0x8d                          # 004ad5d4
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004ad5da
    jne.d32 L_004ada08                           # 004ad5e1
    # block 0x004ad5e7: entered by fall-through of jne at 0x004ad5e1, 4 instruction(s), ends with je to 0x004ada08 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004ad5e7
    movsx ecx, word ptr [eax + field_e57]        # 004ad5ea
    test ecx, ecx                                # 004ad5f1
    je.d32 L_004ada08                            # 004ad5f3
    # block 0x004ad5f9: entered by fall-through of je at 0x004ad5f3, 4 instruction(s), ends with je to 0x004ad637 (forward)
    mov dword ptr [ebp - local_38], 0xffffffff   # 004ad5f9
    mov edx, dword ptr [ebp - local_44]          # 004ad600
    cmp dword ptr [edx + field_20], 0x0          # 004ad603
    je.d8 L_004ad637                             # 004ad607
    # block 0x004ad609: entered by fall-through of je at 0x004ad607, 14 instruction(s), ends with forward jump to 0x004ad684
    mov eax, dword ptr [ebp - local_44]          # 004ad609
    movsx ecx, word ptr [eax + field_24]         # 004ad60c
    imul ecx, ecx, 0xc7                          # 004ad610
    mov edx, dword ptr [ebp - local_44]          # 004ad616
    lea eax, [edx + ecx + field_6e]              # 004ad619
    mov dword ptr [ebp - local_40], eax          # 004ad61d
    mov ecx, dword ptr [ebp - local_40]          # 004ad620
    {load} xor edx, edx                          # 004ad623
    mov dl, byte ptr [ecx + field_26]            # 004ad625
    imul edx, edx, 0x28                          # 004ad628
    mov eax, dword ptr [ebp - local_40]          # 004ad62b
    lea ecx, [eax + edx + field_27]              # 004ad62e
    mov dword ptr [ebp - local_c], ecx           # 004ad632
    jmp.d8 L_004ad684                            # 004ad635
L_004ad637:
    # block 0x004ad637: entered by je at 0x004ad607, 6 instruction(s), calls FUN_004af96e, ends with jne to 0x004ad650 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ad637
    call FUN_004af96e                            # 004ad63a
    movsx edx, ax                                # 004ad63f
    mov dword ptr [ebp - local_38], edx          # 004ad642
    cmp dword ptr [ebp - local_38], -0x1         # 004ad645
    jne.d8 L_004ad650                            # 004ad649
    # block 0x004ad64b: entered by fall-through of jne at 0x004ad649, 1 instruction(s), ends with forward jump to 0x004ada08
    jmp.d32 L_004ada08                           # 004ad64b
L_004ad650:
    # block 0x004ad650: entered by jne at 0x004ad649, 16 instruction(s), calls FUN_004ae683, falls into the block at 0x004ad684
    mov eax, dword ptr [ebp - local_38]          # 004ad650
    imul eax, eax, 0xc7                          # 004ad653
    mov ecx, dword ptr [ebp - local_44]          # 004ad659
    lea edx, [ecx + eax + field_6e]              # 004ad65c
    mov dword ptr [ebp - local_40], edx          # 004ad660
    mov eax, dword ptr [ebp - local_40]          # 004ad663
    {load} xor ecx, ecx                          # 004ad666
    mov cl, byte ptr [eax + field_26]            # 004ad668
    imul ecx, ecx, 0x28                          # 004ad66b
    mov edx, dword ptr [ebp - local_40]          # 004ad66e
    lea eax, [edx + ecx + field_27]              # 004ad671
    mov dword ptr [ebp - local_c], eax           # 004ad675
    mov ecx, dword ptr [ebp - local_38]          # 004ad678
    push ecx                                     # 004ad67b
    mov ecx, dword ptr [ebp - local_44]          # 004ad67c
    call FUN_004ae683                            # 004ad67f
L_004ad684:
    # block 0x004ad684: entered by jmp at 0x004ad635, 64 instruction(s), calls FUN_004ada0d, ends with jl to 0x004ad751 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ad684
    call FUN_004ada0d                            # 004ad687
    mov edx, dword ptr [ebp - local_44]          # 004ad68c
    mov dword ptr [edx + field_46], 0x1          # 004ad68f
    mov eax, dword ptr [ebp - local_40]          # 004ad696
    add eax, 0x2                                 # 004ad699
    mov ecx, dword ptr [ebp - local_44]          # 004ad69c
    add ecx, 0x4a                                # 004ad69f
    mov edx, dword ptr [eax]                     # 004ad6a2
    mov dword ptr [ecx], edx                     # 004ad6a4
    mov edx, dword ptr [eax + field_4]           # 004ad6a6
    mov dword ptr [ecx + field_4], edx           # 004ad6a9
    mov edx, dword ptr [eax + field_8]           # 004ad6ac
    mov dword ptr [ecx + field_8], edx           # 004ad6af
    mov eax, dword ptr [eax + field_c]           # 004ad6b2
    mov dword ptr [ecx + field_c], eax           # 004ad6b5
    mov ecx, dword ptr [ebp - local_44]          # 004ad6b8
    mov edx, dword ptr [ecx + field_4e]          # 004ad6bb
    add edx, dword ptr [0x58318a]                # 004ad6be
    mov eax, dword ptr [ebp - local_44]          # 004ad6c4
    mov dword ptr [eax + field_5e], edx          # 004ad6c7
    mov ecx, dword ptr [ebp - local_44]          # 004ad6ca
    mov edx, dword ptr [ecx + field_56]          # 004ad6cd
    add edx, dword ptr [0x58318a]                # 004ad6d0
    mov eax, dword ptr [ebp - local_44]          # 004ad6d6
    mov dword ptr [eax + field_66], edx          # 004ad6d9
    mov ecx, dword ptr [ebp - local_44]          # 004ad6dc
    mov edx, dword ptr [ecx + field_4a]          # 004ad6df
    add edx, dword ptr [0x583186]                # 004ad6e2
    mov eax, dword ptr [ebp - local_44]          # 004ad6e8
    mov dword ptr [eax + field_5a], edx          # 004ad6eb
    mov ecx, dword ptr [ebp - local_44]          # 004ad6ee
    mov edx, dword ptr [ecx + field_52]          # 004ad6f1
    add edx, dword ptr [0x583186]                # 004ad6f4
    mov eax, dword ptr [ebp - local_44]          # 004ad6fa
    mov dword ptr [eax + field_62], edx          # 004ad6fd
    mov ecx, dword ptr [ebp - local_c]           # 004ad700
    movsx eax, word ptr [ecx + field_20]         # 004ad703
    cdq                                          # 004ad707
    {load} sub eax, edx                          # 004ad708
    sar eax                                      # 004ad70a
    mov edx, dword ptr [ebp - local_40]          # 004ad70c
    mov ecx, dword ptr [edx + field_2]           # 004ad70f
    {load} add ecx, eax                          # 004ad712
    mov dword ptr [ebp - local_10], ecx          # 004ad714
    mov edx, dword ptr [ebp - local_c]           # 004ad717
    movsx eax, word ptr [edx + field_22]         # 004ad71a
    cdq                                          # 004ad71e
    {load} sub eax, edx                          # 004ad71f
    sar eax                                      # 004ad721
    mov ecx, dword ptr [ebp - local_40]          # 004ad723
    mov edx, dword ptr [ecx + field_6]           # 004ad726
    {load} add edx, eax                          # 004ad729
    mov dword ptr [ebp - local_4], edx           # 004ad72b
    mov eax, dword ptr [ebp - local_40]          # 004ad72e
    mov cl, byte ptr [eax + field_26]            # 004ad731
    add cl, 0x1                                  # 004ad734
    mov edx, dword ptr [ebp - local_40]          # 004ad737
    mov byte ptr [edx + field_26], cl            # 004ad73a
    mov eax, dword ptr [ebp - local_40]          # 004ad73d
    {load} xor ecx, ecx                          # 004ad740
    mov cl, byte ptr [eax + field_26]            # 004ad742
    cmp ecx, 0x4                                 # 004ad745
    jl.d8 L_004ad751                             # 004ad748
    # block 0x004ad74a: entered by fall-through of jl at 0x004ad748, 2 instruction(s), falls into the block at 0x004ad751
    mov edx, dword ptr [ebp - local_40]          # 004ad74a
    mov byte ptr [edx + field_26], 0x0           # 004ad74d
L_004ad751:
    # block 0x004ad751: entered by jl at 0x004ad748, 45 instruction(s), calls FUN_004ae495, ends with jge to 0x004ad801 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ad751
    {load} xor ecx, ecx                          # 004ad754
    mov cl, byte ptr [eax + field_26]            # 004ad756
    imul ecx, ecx, 0x28                          # 004ad759
    mov edx, dword ptr [ebp - local_40]          # 004ad75c
    lea eax, [edx + ecx + field_27]              # 004ad75f
    mov dword ptr [ebp - local_c], eax           # 004ad763
    mov ecx, dword ptr [ebp - local_38]          # 004ad766
    push ecx                                     # 004ad769
    mov ecx, dword ptr [ebp - local_44]          # 004ad76a
    call FUN_004ae495                            # 004ad76d
    mov edx, dword ptr [ebp - local_c]           # 004ad772
    movsx eax, word ptr [edx + field_20]         # 004ad775
    cdq                                          # 004ad779
    {load} sub eax, edx                          # 004ad77a
    sar eax                                      # 004ad77c
    mov ecx, dword ptr [ebp - local_10]          # 004ad77e
    {load} sub ecx, eax                          # 004ad781
    mov edx, dword ptr [ebp - local_40]          # 004ad783
    mov dword ptr [edx + field_2], ecx           # 004ad786
    mov eax, dword ptr [ebp - local_c]           # 004ad789
    movsx eax, word ptr [eax + field_22]         # 004ad78c
    cdq                                          # 004ad790
    {load} sub eax, edx                          # 004ad791
    sar eax                                      # 004ad793
    mov ecx, dword ptr [ebp - local_4]           # 004ad795
    {load} sub ecx, eax                          # 004ad798
    mov edx, dword ptr [ebp - local_40]          # 004ad79a
    mov dword ptr [edx + field_6], ecx           # 004ad79d
    mov eax, dword ptr [ebp - local_40]          # 004ad7a0
    mov ecx, dword ptr [eax + field_2]           # 004ad7a3
    mov edx, dword ptr [ebp - local_c]           # 004ad7a6
    add ecx, dword ptr [edx + field_14]          # 004ad7a9
    mov eax, dword ptr [ebp - local_40]          # 004ad7ac
    mov dword ptr [eax + field_a], ecx           # 004ad7af
    mov ecx, dword ptr [ebp - local_40]          # 004ad7b2
    mov edx, dword ptr [ecx + field_6]           # 004ad7b5
    mov eax, dword ptr [ebp - local_c]           # 004ad7b8
    add edx, dword ptr [eax + field_18]          # 004ad7bb
    mov ecx, dword ptr [ebp - local_40]          # 004ad7be
    mov dword ptr [ecx + field_e], edx           # 004ad7c1
    mov edx, dword ptr [ebp - local_40]          # 004ad7c4
    mov eax, dword ptr [edx + field_6]           # 004ad7c7
    cmp eax, dword ptr [0x58319a]                # 004ad7ca
    jge.d8 L_004ad801                            # 004ad7d0
    # block 0x004ad7d2: entered by fall-through of jge at 0x004ad7d0, 15 instruction(s), ends with forward jump to 0x004ad83c
    mov ecx, dword ptr [ebp - local_40]          # 004ad7d2
    mov edx, dword ptr [0x58319a]                # 004ad7d5
    sub edx, dword ptr [ecx + field_6]           # 004ad7db
    mov dword ptr [ebp - local_34], edx          # 004ad7de
    mov eax, dword ptr [ebp - local_40]          # 004ad7e1
    mov ecx, dword ptr [eax + field_6]           # 004ad7e4
    add ecx, dword ptr [ebp - local_34]          # 004ad7e7
    mov edx, dword ptr [ebp - local_40]          # 004ad7ea
    mov dword ptr [edx + field_6], ecx           # 004ad7ed
    mov eax, dword ptr [ebp - local_40]          # 004ad7f0
    mov ecx, dword ptr [eax + field_e]           # 004ad7f3
    add ecx, dword ptr [ebp - local_34]          # 004ad7f6
    mov edx, dword ptr [ebp - local_40]          # 004ad7f9
    mov dword ptr [edx + field_e], ecx           # 004ad7fc
    jmp.d8 L_004ad83c                            # 004ad7ff
L_004ad801:
    # block 0x004ad801: entered by jge at 0x004ad7d0, 4 instruction(s), ends with jle to 0x004ad83c (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ad801
    mov ecx, dword ptr [eax + field_e]           # 004ad804
    cmp ecx, dword ptr [0x5831a2]                # 004ad807
    jle.d8 L_004ad83c                            # 004ad80d
    # block 0x004ad80f: entered by fall-through of jle at 0x004ad80d, 14 instruction(s), falls into the block at 0x004ad83c
    mov edx, dword ptr [ebp - local_40]          # 004ad80f
    mov eax, dword ptr [edx + field_e]           # 004ad812
    sub eax, dword ptr [0x5831a2]                # 004ad815
    mov dword ptr [ebp - local_34], eax          # 004ad81b
    mov ecx, dword ptr [ebp - local_40]          # 004ad81e
    mov edx, dword ptr [ecx + field_6]           # 004ad821
    sub edx, dword ptr [ebp - local_34]          # 004ad824
    mov eax, dword ptr [ebp - local_40]          # 004ad827
    mov dword ptr [eax + field_6], edx           # 004ad82a
    mov ecx, dword ptr [ebp - local_40]          # 004ad82d
    mov edx, dword ptr [ecx + field_e]           # 004ad830
    sub edx, dword ptr [ebp - local_34]          # 004ad833
    mov eax, dword ptr [ebp - local_40]          # 004ad836
    mov dword ptr [eax + field_e], edx           # 004ad839
L_004ad83c:
    # block 0x004ad83c: entered by jmp at 0x004ad7ff; jle at 0x004ad80d, 4 instruction(s), ends with jge to 0x004ad879 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 004ad83c
    mov edx, dword ptr [ecx + field_2]           # 004ad83f
    cmp edx, dword ptr [0x583196]                # 004ad842
    jge.d8 L_004ad879                            # 004ad848
    # block 0x004ad84a: entered by fall-through of jge at 0x004ad848, 15 instruction(s), ends with forward jump to 0x004ad8b4
    mov eax, dword ptr [ebp - local_40]          # 004ad84a
    mov ecx, dword ptr [0x583196]                # 004ad84d
    sub ecx, dword ptr [eax + field_2]           # 004ad853
    mov dword ptr [ebp - local_34], ecx          # 004ad856
    mov edx, dword ptr [ebp - local_40]          # 004ad859
    mov eax, dword ptr [edx + field_2]           # 004ad85c
    add eax, dword ptr [ebp - local_34]          # 004ad85f
    mov ecx, dword ptr [ebp - local_40]          # 004ad862
    mov dword ptr [ecx + field_2], eax           # 004ad865
    mov edx, dword ptr [ebp - local_40]          # 004ad868
    mov eax, dword ptr [edx + field_a]           # 004ad86b
    add eax, dword ptr [ebp - local_34]          # 004ad86e
    mov ecx, dword ptr [ebp - local_40]          # 004ad871
    mov dword ptr [ecx + field_a], eax           # 004ad874
    jmp.d8 L_004ad8b4                            # 004ad877
L_004ad879:
    # block 0x004ad879: entered by jge at 0x004ad848, 4 instruction(s), ends with jle to 0x004ad8b4 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ad879
    mov eax, dword ptr [edx + field_a]           # 004ad87c
    cmp eax, dword ptr [0x58319e]                # 004ad87f
    jle.d8 L_004ad8b4                            # 004ad885
    # block 0x004ad887: entered by fall-through of jle at 0x004ad885, 14 instruction(s), falls into the block at 0x004ad8b4
    mov ecx, dword ptr [ebp - local_40]          # 004ad887
    mov edx, dword ptr [ecx + field_a]           # 004ad88a
    sub edx, dword ptr [0x58319e]                # 004ad88d
    mov dword ptr [ebp - local_34], edx          # 004ad893
    mov eax, dword ptr [ebp - local_40]          # 004ad896
    mov ecx, dword ptr [eax + field_2]           # 004ad899
    sub ecx, dword ptr [ebp - local_34]          # 004ad89c
    mov edx, dword ptr [ebp - local_40]          # 004ad89f
    mov dword ptr [edx + field_2], ecx           # 004ad8a2
    mov eax, dword ptr [ebp - local_40]          # 004ad8a5
    mov ecx, dword ptr [eax + field_a]           # 004ad8a8
    sub ecx, dword ptr [ebp - local_34]          # 004ad8ab
    mov edx, dword ptr [ebp - local_40]          # 004ad8ae
    mov dword ptr [edx + field_a], ecx           # 004ad8b1
L_004ad8b4:
    # block 0x004ad8b4: entered by jmp at 0x004ad877; jle at 0x004ad885, 23 instruction(s), ends with jne to 0x004ada00 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ad8b4
    mov ecx, dword ptr [eax + field_6]           # 004ad8b7
    add ecx, dword ptr [0x58318a]                # 004ad8ba
    mov edx, dword ptr [ebp - local_40]          # 004ad8c0
    mov dword ptr [edx + field_16], ecx          # 004ad8c3
    mov eax, dword ptr [ebp - local_40]          # 004ad8c6
    mov ecx, dword ptr [eax + field_e]           # 004ad8c9
    add ecx, dword ptr [0x58318a]                # 004ad8cc
    mov edx, dword ptr [ebp - local_40]          # 004ad8d2
    mov dword ptr [edx + field_1e], ecx          # 004ad8d5
    mov eax, dword ptr [ebp - local_40]          # 004ad8d8
    mov ecx, dword ptr [eax + field_2]           # 004ad8db
    add ecx, dword ptr [0x583186]                # 004ad8de
    mov edx, dword ptr [ebp - local_40]          # 004ad8e4
    mov dword ptr [edx + field_12], ecx          # 004ad8e7
    mov eax, dword ptr [ebp - local_40]          # 004ad8ea
    mov ecx, dword ptr [eax + field_a]           # 004ad8ed
    add ecx, dword ptr [0x583186]                # 004ad8f0
    mov edx, dword ptr [ebp - local_40]          # 004ad8f6
    mov dword ptr [edx + field_1a], ecx          # 004ad8f9
    mov eax, dword ptr [ebp - local_44]          # 004ad8fc
    cmp dword ptr [eax + field_20], 0x0          # 004ad8ff
    jne.d32 L_004ada00                           # 004ad903
    # block 0x004ad909: entered by fall-through of jne at 0x004ad903, 12 instruction(s), calls FUN_004ae96c, ends with forward jump to 0x004ad93d
    mov ecx, dword ptr [ebp - local_38]          # 004ad909
    push ecx                                     # 004ad90c
    mov ecx, dword ptr [ebp - local_44]          # 004ad90d
    call FUN_004ae96c                            # 004ad910
    mov ecx, 0x7                                 # 004ad915
    or eax, -0x1                                 # 004ad91a
    lea edi, [ebp - local_30]                    # 004ad91d
    rep stosd dword ptr es:[edi], eax            # 004ad920
    stosw word ptr es:[edi], ax                  # 004ad922
    mov dword ptr [ebp - local_3c], 0x0          # 004ad924
    mov dword ptr [ebp - local_8], 0x0           # 004ad92b
    jmp.d8 L_004ad93d                            # 004ad932
L_004ad934:
    # block 0x004ad934: entered by jmp at 0x004ad957; jmp at 0x004ad982, 3 instruction(s), falls into the block at 0x004ad93d
    mov edx, dword ptr [ebp - local_8]           # 004ad934
    add edx, 0x1                                 # 004ad937
    mov dword ptr [ebp - local_8], edx           # 004ad93a
L_004ad93d:
    # block 0x004ad93d: entered by jmp at 0x004ad932, 5 instruction(s), ends with jge to 0x004ad984 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004ad93d
    mov ecx, dword ptr [eax + field_c17]         # 004ad940
    movsx edx, word ptr [ecx + field_42]         # 004ad946
    cmp dword ptr [ebp - local_8], edx           # 004ad94a
    jge.d8 L_004ad984                            # 004ad94d
    # block 0x004ad94f: entered by fall-through of jge at 0x004ad94d, 3 instruction(s), ends with jne to 0x004ad959 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ad94f
    cmp eax, dword ptr [ebp - local_38]          # 004ad952
    jne.d8 L_004ad959                            # 004ad955
    # block 0x004ad957: entered by fall-through of jne at 0x004ad955, 1 instruction(s), ends with backward jump to 0x004ad934
    jmp.d8 L_004ad934                            # 004ad957
L_004ad959:
    # block 0x004ad959: entered by jne at 0x004ad955, 8 instruction(s), calls FUN_004aef4a, ends with je to 0x004ad982 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ad959
    push ecx                                     # 004ad95c
    mov edx, dword ptr [ebp - local_38]          # 004ad95d
    push edx                                     # 004ad960
    mov ecx, dword ptr [ebp - local_44]          # 004ad961
    call FUN_004aef4a                            # 004ad964
    test eax, eax                                # 004ad969
    je.d8 L_004ad982                             # 004ad96b
    # block 0x004ad96d: entered by fall-through of je at 0x004ad96b, 6 instruction(s), falls into the block at 0x004ad982
    mov eax, dword ptr [ebp - local_3c]          # 004ad96d
    mov cx, word ptr [ebp - local_8]             # 004ad970
    mov word ptr [ebp + 2*eax - local_30], cx    # 004ad974
    mov edx, dword ptr [ebp - local_3c]          # 004ad979
    add edx, 0x1                                 # 004ad97c
    mov dword ptr [ebp - local_3c], edx          # 004ad97f
L_004ad982:
    # block 0x004ad982: entered by je at 0x004ad96b, 1 instruction(s), ends with backward jump to 0x004ad934
    jmp.d8 L_004ad934                            # 004ad982
L_004ad984:
    # block 0x004ad984: entered by jge at 0x004ad94d, 2 instruction(s), ends with forward jump to 0x004ad996
    mov dword ptr [ebp - local_8], 0x0           # 004ad984
    jmp.d8 L_004ad996                            # 004ad98b
L_004ad98d:
    # block 0x004ad98d: entered by jmp at 0x004ad9ee, 3 instruction(s), falls into the block at 0x004ad996
    mov eax, dword ptr [ebp - local_8]           # 004ad98d
    add eax, 0x1                                 # 004ad990
    mov dword ptr [ebp - local_8], eax           # 004ad993
L_004ad996:
    # block 0x004ad996: entered by jmp at 0x004ad98b, 3 instruction(s), ends with jge to 0x004ad9f0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ad996
    cmp ecx, dword ptr [ebp - local_3c]          # 004ad999
    jge.d8 L_004ad9f0                            # 004ad99c
    # block 0x004ad99e: entered by fall-through of jge at 0x004ad99c, 9 instruction(s), ends with jle to 0x004ad9ca (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ad99e
    movsx eax, word ptr [edx]                    # 004ad9a1
    mov ecx, dword ptr [ebp - local_8]           # 004ad9a4
    movsx edx, word ptr [ebp + 2*ecx - local_30] # 004ad9a7
    imul edx, edx, 0xc7                          # 004ad9ac
    mov ecx, dword ptr [ebp - local_44]          # 004ad9b2
    movsx edx, word ptr [ecx + edx + field_6e]   # 004ad9b5
    {load} cmp eax, edx                          # 004ad9ba
    jle.d8 L_004ad9ca                            # 004ad9bc
    # block 0x004ad9be: entered by fall-through of jle at 0x004ad9bc, 4 instruction(s), ends with forward jump to 0x004ad9e4
    mov eax, dword ptr [ebp - local_40]          # 004ad9be
    mov cx, word ptr [eax]                       # 004ad9c1
    mov word ptr [ebp - local_46], cx            # 004ad9c4
    jmp.d8 L_004ad9e4                            # 004ad9c8
L_004ad9ca:
    # block 0x004ad9ca: entered by jle at 0x004ad9bc, 6 instruction(s), falls into the block at 0x004ad9e4
    mov edx, dword ptr [ebp - local_8]           # 004ad9ca
    movsx eax, word ptr [ebp + 2*edx - local_30] # 004ad9cd
    imul eax, eax, 0xc7                          # 004ad9d2
    mov ecx, dword ptr [ebp - local_44]          # 004ad9d8
    mov dx, word ptr [ecx + eax + field_6e]      # 004ad9db
    mov word ptr [ebp - local_46], dx            # 004ad9e0
L_004ad9e4:
    # block 0x004ad9e4: entered by jmp at 0x004ad9c8, 4 instruction(s), ends with backward jump to 0x004ad98d
    mov eax, dword ptr [ebp - local_40]          # 004ad9e4
    mov cx, word ptr [ebp - local_46]            # 004ad9e7
    mov word ptr [eax], cx                       # 004ad9eb
    jmp.d8 L_004ad98d                            # 004ad9ee
L_004ad9f0:
    # block 0x004ad9f0: entered by jge at 0x004ad99c, 5 instruction(s), falls into the block at 0x004ada00
    mov edx, dword ptr [ebp - local_40]          # 004ad9f0
    mov ax, word ptr [edx]                       # 004ad9f3
    .insn 0x66, 0x05, 0x0001{:u16}               # 004ad9f6
    mov ecx, dword ptr [ebp - local_40]          # 004ad9fa
    mov word ptr [ecx], ax                       # 004ad9fd
L_004ada00:
    # block 0x004ada00: entered by jne at 0x004ad903, 2 instruction(s), calls FUN_004adae8, falls into the block at 0x004ada08
    mov ecx, dword ptr [ebp - local_44]          # 004ada00
    call FUN_004adae8                            # 004ada03
L_004ada08:
    # block 0x004ada08: entered by je at 0x004ad5a4; jne at 0x004ad5b7; jne at 0x004ad5c7; jne at 0x004ad5e1; more, 4 instruction(s), ends with ret
    pop edi                                      # 004ada08
    {load} mov esp, ebp                          # 004ada09
    pop ebp                                      # 004ada0b
    ret                                          # 004ada0c

