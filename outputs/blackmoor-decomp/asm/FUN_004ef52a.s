# FUN_004ef52a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef52a
# extent:       0x004ef52a-0x004ef89b (881 code bytes)
# span:         0x004ef52a-0x004ef89b (code 881, tables 0, padding 0)
# sha256:       c4deba782045a0277f8594e0b459ee8a4a9aa631c21faf7b8924095f33b408b4
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_slider_thumb_rect_placer
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.c:220 says "0x4ef52a: thumb rectangle from the offset."
# name-note:    Computes the slider thumb rectangle from the offset.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_ce, field_12e, field_132, field_136, field_13e, field_142, field_146, field_14a, field_166, field_176, field_17a, field_17e and 3 more; [ecx + n] field_d2, field_12e, field_132, field_136, field_13a, field_13e, field_142, field_146, field_14a, field_172, field_176, field_17a and 1 more; [edx + n] field_d2, field_12e, field_132, field_136, field_13a, field_13e, field_142, field_146, field_14a, field_166, field_172, field_17a and 3 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 226 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_ce, 0xce  # offset +0xce
.equ field_d2, 0xd2  # offset +0xd2
.equ field_12e, 0x12e  # offset +0x12e
.equ field_132, 0x132  # offset +0x132
.equ field_136, 0x136  # offset +0x136
.equ field_13a, 0x13a  # offset +0x13a
.equ field_13e, 0x13e  # offset +0x13e
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_166, 0x166  # offset +0x166
.equ field_172, 0x172  # offset +0x172
.equ field_176, 0x176  # offset +0x176
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_1aa, 0x1aa  # offset +0x1aa

# --- external targets -----------------------------------------------

.org 0x004ef52a - 0x401000
.globl FUN_004ef52a
FUN_004ef52a:
    # block 0x004ef52a: entry, 9 instruction(s), ends with je to 0x004ef554 (forward)
    push ebp                                     # 004ef52a
    {load} mov ebp, esp                          # 004ef52b
    sub esp, 0x10                                # 004ef52d
    mov dword ptr [ebp - local_4], ecx           # 004ef530
    mov eax, dword ptr [ebp - local_4]           # 004ef533
    mov ecx, dword ptr [eax + field_ce]          # 004ef536
    mov dword ptr [ebp - local_8], ecx           # 004ef53c
    cmp dword ptr [ebp - local_8], 0x0           # 004ef53f
    je.d8 L_004ef554                             # 004ef543
    # block 0x004ef545: entered by fall-through of je at 0x004ef543, 2 instruction(s), ends with je to 0x004ef6f8 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004ef545
    je.d32 L_004ef6f8                            # 004ef549
    # block 0x004ef54f: entered by fall-through of je at 0x004ef549, 1 instruction(s), ends with forward jump to 0x004ef897
    jmp.d32 L_004ef897                           # 004ef54f
L_004ef554:
    # block 0x004ef554: entered by je at 0x004ef543, 5 instruction(s), ends with je to 0x004ef575 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef554
    mov eax, dword ptr [edx + field_d2]          # 004ef557
    mov dword ptr [ebp - local_c], eax           # 004ef55d
    cmp dword ptr [ebp - local_c], 0x0           # 004ef560
    je.d8 L_004ef575                             # 004ef564
    # block 0x004ef566: entered by fall-through of je at 0x004ef564, 2 instruction(s), ends with je to 0x004ef637 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004ef566
    je.d32 L_004ef637                            # 004ef56a
    # block 0x004ef570: entered by fall-through of je at 0x004ef56a, 1 instruction(s), ends with forward jump to 0x004ef6f3
    jmp.d32 L_004ef6f3                           # 004ef570
L_004ef575:
    # block 0x004ef575: entered by je at 0x004ef564, 16 instruction(s), ends with je to 0x004ef5e1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef575
    mov edx, dword ptr [ecx + field_12e]         # 004ef578
    mov eax, dword ptr [ebp - local_4]           # 004ef57e
    add edx, dword ptr [eax + field_166]         # 004ef581
    mov ecx, dword ptr [ebp - local_4]           # 004ef587
    mov dword ptr [ecx + field_13e], edx         # 004ef58a
    mov edx, dword ptr [ebp - local_4]           # 004ef590
    mov eax, dword ptr [edx + field_13e]         # 004ef593
    mov ecx, dword ptr [ebp - local_4]           # 004ef599
    mov edx, dword ptr [ecx + field_17a]         # 004ef59c
    lea eax, [eax + edx - field_minus_1]         # 004ef5a2
    mov ecx, dword ptr [ebp - local_4]           # 004ef5a6
    mov dword ptr [ecx + field_146], eax         # 004ef5a9
    mov edx, dword ptr [ebp - local_4]           # 004ef5af
    cmp dword ptr [edx + field_1a6], 0x0         # 004ef5b2
    je.d8 L_004ef5e1                             # 004ef5b9
    # block 0x004ef5bb: entered by fall-through of je at 0x004ef5b9, 9 instruction(s), ends with forward jump to 0x004ef632
    mov eax, dword ptr [ebp - local_4]           # 004ef5bb
    mov ecx, dword ptr [ebp - local_4]           # 004ef5be
    mov edx, dword ptr [ecx + field_132]         # 004ef5c1
    mov dword ptr [eax + field_142], edx         # 004ef5c7
    mov eax, dword ptr [ebp - local_4]           # 004ef5cd
    mov ecx, dword ptr [ebp - local_4]           # 004ef5d0
    mov edx, dword ptr [ecx + field_13a]         # 004ef5d3
    mov dword ptr [eax + field_14a], edx         # 004ef5d9
    jmp.d8 L_004ef632                            # 004ef5df
L_004ef5e1:
    # block 0x004ef5e1: entered by je at 0x004ef5b9, 23 instruction(s), falls into the block at 0x004ef632
    mov eax, dword ptr [ebp - local_4]           # 004ef5e1
    mov eax, dword ptr [eax + field_176]         # 004ef5e4
    cdq                                          # 004ef5ea
    {load} sub eax, edx                          # 004ef5eb
    sar eax                                      # 004ef5ed
    mov ecx, dword ptr [ebp - local_4]           # 004ef5ef
    mov ecx, dword ptr [ecx + field_132]         # 004ef5f2
    {load} add ecx, eax                          # 004ef5f8
    mov edx, dword ptr [ebp - local_4]           # 004ef5fa
    mov eax, dword ptr [edx + field_17e]         # 004ef5fd
    cdq                                          # 004ef603
    {load} sub eax, edx                          # 004ef604
    sar eax                                      # 004ef606
    {load} sub ecx, eax                          # 004ef608
    mov eax, dword ptr [ebp - local_4]           # 004ef60a
    mov dword ptr [eax + field_142], ecx         # 004ef60d
    mov ecx, dword ptr [ebp - local_4]           # 004ef613
    mov edx, dword ptr [ecx + field_142]         # 004ef616
    mov eax, dword ptr [ebp - local_4]           # 004ef61c
    mov ecx, dword ptr [eax + field_17e]         # 004ef61f
    lea edx, [edx + ecx - field_minus_1]         # 004ef625
    mov eax, dword ptr [ebp - local_4]           # 004ef629
    mov dword ptr [eax + field_14a], edx         # 004ef62c
L_004ef632:
    # block 0x004ef632: entered by jmp at 0x004ef5df, 1 instruction(s), ends with forward jump to 0x004ef6f3
    jmp.d32 L_004ef6f3                           # 004ef632
L_004ef637:
    # block 0x004ef637: entered by je at 0x004ef56a, 16 instruction(s), ends with je to 0x004ef6a2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef637
    mov edx, dword ptr [ebp - local_4]           # 004ef63a
    mov eax, dword ptr [ecx + field_136]         # 004ef63d
    sub eax, dword ptr [edx + field_166]         # 004ef643
    mov ecx, dword ptr [ebp - local_4]           # 004ef649
    mov dword ptr [ecx + field_146], eax         # 004ef64c
    mov edx, dword ptr [ebp - local_4]           # 004ef652
    mov eax, dword ptr [ebp - local_4]           # 004ef655
    mov ecx, dword ptr [edx + field_146]         # 004ef658
    sub ecx, dword ptr [eax + field_17a]         # 004ef65e
    add ecx, 0x1                                 # 004ef664
    mov edx, dword ptr [ebp - local_4]           # 004ef667
    mov dword ptr [edx + field_13e], ecx         # 004ef66a
    mov eax, dword ptr [ebp - local_4]           # 004ef670
    cmp dword ptr [eax + field_1a6], 0x0         # 004ef673
    je.d8 L_004ef6a2                             # 004ef67a
    # block 0x004ef67c: entered by fall-through of je at 0x004ef67a, 9 instruction(s), ends with forward jump to 0x004ef6f3
    mov ecx, dword ptr [ebp - local_4]           # 004ef67c
    mov edx, dword ptr [ebp - local_4]           # 004ef67f
    mov eax, dword ptr [edx + field_132]         # 004ef682
    mov dword ptr [ecx + field_142], eax         # 004ef688
    mov ecx, dword ptr [ebp - local_4]           # 004ef68e
    mov edx, dword ptr [ebp - local_4]           # 004ef691
    mov eax, dword ptr [edx + field_13a]         # 004ef694
    mov dword ptr [ecx + field_14a], eax         # 004ef69a
    jmp.d8 L_004ef6f3                            # 004ef6a0
L_004ef6a2:
    # block 0x004ef6a2: entered by je at 0x004ef67a, 23 instruction(s), falls into the block at 0x004ef6f3
    mov ecx, dword ptr [ebp - local_4]           # 004ef6a2
    mov eax, dword ptr [ecx + field_176]         # 004ef6a5
    cdq                                          # 004ef6ab
    {load} sub eax, edx                          # 004ef6ac
    sar eax                                      # 004ef6ae
    mov edx, dword ptr [ebp - local_4]           # 004ef6b0
    mov ecx, dword ptr [edx + field_132]         # 004ef6b3
    {load} add ecx, eax                          # 004ef6b9
    mov edx, dword ptr [ebp - local_4]           # 004ef6bb
    mov eax, dword ptr [edx + field_17e]         # 004ef6be
    cdq                                          # 004ef6c4
    {load} sub eax, edx                          # 004ef6c5
    sar eax                                      # 004ef6c7
    {load} sub ecx, eax                          # 004ef6c9
    mov eax, dword ptr [ebp - local_4]           # 004ef6cb
    mov dword ptr [eax + field_142], ecx         # 004ef6ce
    mov ecx, dword ptr [ebp - local_4]           # 004ef6d4
    mov edx, dword ptr [ecx + field_142]         # 004ef6d7
    mov eax, dword ptr [ebp - local_4]           # 004ef6dd
    mov ecx, dword ptr [eax + field_17e]         # 004ef6e0
    lea edx, [edx + ecx - field_minus_1]         # 004ef6e6
    mov eax, dword ptr [ebp - local_4]           # 004ef6ea
    mov dword ptr [eax + field_14a], edx         # 004ef6ed
L_004ef6f3:
    # block 0x004ef6f3: entered by jmp at 0x004ef570; jmp at 0x004ef632; jmp at 0x004ef6a0, 1 instruction(s), ends with forward jump to 0x004ef897
    jmp.d32 L_004ef897                           # 004ef6f3
L_004ef6f8:
    # block 0x004ef6f8: entered by je at 0x004ef549, 5 instruction(s), ends with je to 0x004ef719 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef6f8
    mov edx, dword ptr [ecx + field_d2]          # 004ef6fb
    mov dword ptr [ebp - local_10], edx          # 004ef701
    cmp dword ptr [ebp - local_10], 0x2          # 004ef704
    je.d8 L_004ef719                             # 004ef708
    # block 0x004ef70a: entered by fall-through of je at 0x004ef708, 2 instruction(s), ends with je to 0x004ef7db (forward)
    cmp dword ptr [ebp - local_10], 0x3          # 004ef70a
    je.d32 L_004ef7db                            # 004ef70e
    # block 0x004ef714: entered by fall-through of je at 0x004ef70e, 1 instruction(s), ends with forward jump to 0x004ef897
    jmp.d32 L_004ef897                           # 004ef714
L_004ef719:
    # block 0x004ef719: entered by je at 0x004ef708, 16 instruction(s), ends with je to 0x004ef785 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ef719
    mov ecx, dword ptr [eax + field_132]         # 004ef71c
    mov edx, dword ptr [ebp - local_4]           # 004ef722
    add ecx, dword ptr [edx + field_166]         # 004ef725
    mov eax, dword ptr [ebp - local_4]           # 004ef72b
    mov dword ptr [eax + field_142], ecx         # 004ef72e
    mov ecx, dword ptr [ebp - local_4]           # 004ef734
    mov edx, dword ptr [ecx + field_142]         # 004ef737
    mov eax, dword ptr [ebp - local_4]           # 004ef73d
    mov ecx, dword ptr [eax + field_17e]         # 004ef740
    lea edx, [edx + ecx - field_minus_1]         # 004ef746
    mov eax, dword ptr [ebp - local_4]           # 004ef74a
    mov dword ptr [eax + field_14a], edx         # 004ef74d
    mov ecx, dword ptr [ebp - local_4]           # 004ef753
    cmp dword ptr [ecx + field_1aa], 0x0         # 004ef756
    je.d8 L_004ef785                             # 004ef75d
    # block 0x004ef75f: entered by fall-through of je at 0x004ef75d, 9 instruction(s), ends with forward jump to 0x004ef7d6
    mov edx, dword ptr [ebp - local_4]           # 004ef75f
    mov eax, dword ptr [ebp - local_4]           # 004ef762
    mov ecx, dword ptr [eax + field_12e]         # 004ef765
    mov dword ptr [edx + field_13e], ecx         # 004ef76b
    mov edx, dword ptr [ebp - local_4]           # 004ef771
    mov eax, dword ptr [ebp - local_4]           # 004ef774
    mov ecx, dword ptr [eax + field_136]         # 004ef777
    mov dword ptr [edx + field_146], ecx         # 004ef77d
    jmp.d8 L_004ef7d6                            # 004ef783
L_004ef785:
    # block 0x004ef785: entered by je at 0x004ef75d, 23 instruction(s), falls into the block at 0x004ef7d6
    mov edx, dword ptr [ebp - local_4]           # 004ef785
    mov eax, dword ptr [edx + field_172]         # 004ef788
    cdq                                          # 004ef78e
    {load} sub eax, edx                          # 004ef78f
    sar eax                                      # 004ef791
    mov ecx, dword ptr [ebp - local_4]           # 004ef793
    mov ecx, dword ptr [ecx + field_12e]         # 004ef796
    {load} add ecx, eax                          # 004ef79c
    mov edx, dword ptr [ebp - local_4]           # 004ef79e
    mov eax, dword ptr [edx + field_17a]         # 004ef7a1
    cdq                                          # 004ef7a7
    {load} sub eax, edx                          # 004ef7a8
    sar eax                                      # 004ef7aa
    {load} sub ecx, eax                          # 004ef7ac
    mov eax, dword ptr [ebp - local_4]           # 004ef7ae
    mov dword ptr [eax + field_13e], ecx         # 004ef7b1
    mov ecx, dword ptr [ebp - local_4]           # 004ef7b7
    mov edx, dword ptr [ecx + field_13e]         # 004ef7ba
    mov eax, dword ptr [ebp - local_4]           # 004ef7c0
    mov ecx, dword ptr [eax + field_17a]         # 004ef7c3
    lea edx, [edx + ecx - field_minus_1]         # 004ef7c9
    mov eax, dword ptr [ebp - local_4]           # 004ef7cd
    mov dword ptr [eax + field_146], edx         # 004ef7d0
L_004ef7d6:
    # block 0x004ef7d6: entered by jmp at 0x004ef783, 1 instruction(s), ends with forward jump to 0x004ef897
    jmp.d32 L_004ef897                           # 004ef7d6
L_004ef7db:
    # block 0x004ef7db: entered by je at 0x004ef70e, 16 instruction(s), ends with je to 0x004ef846 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef7db
    mov edx, dword ptr [ebp - local_4]           # 004ef7de
    mov eax, dword ptr [ecx + field_13a]         # 004ef7e1
    sub eax, dword ptr [edx + field_166]         # 004ef7e7
    mov ecx, dword ptr [ebp - local_4]           # 004ef7ed
    mov dword ptr [ecx + field_14a], eax         # 004ef7f0
    mov edx, dword ptr [ebp - local_4]           # 004ef7f6
    mov eax, dword ptr [ebp - local_4]           # 004ef7f9
    mov ecx, dword ptr [edx + field_14a]         # 004ef7fc
    sub ecx, dword ptr [eax + field_17e]         # 004ef802
    add ecx, 0x1                                 # 004ef808
    mov edx, dword ptr [ebp - local_4]           # 004ef80b
    mov dword ptr [edx + field_142], ecx         # 004ef80e
    mov eax, dword ptr [ebp - local_4]           # 004ef814
    cmp dword ptr [eax + field_1aa], 0x0         # 004ef817
    je.d8 L_004ef846                             # 004ef81e
    # block 0x004ef820: entered by fall-through of je at 0x004ef81e, 9 instruction(s), ends with forward jump to 0x004ef897
    mov ecx, dword ptr [ebp - local_4]           # 004ef820
    mov edx, dword ptr [ebp - local_4]           # 004ef823
    mov eax, dword ptr [edx + field_12e]         # 004ef826
    mov dword ptr [ecx + field_13e], eax         # 004ef82c
    mov ecx, dword ptr [ebp - local_4]           # 004ef832
    mov edx, dword ptr [ebp - local_4]           # 004ef835
    mov eax, dword ptr [edx + field_136]         # 004ef838
    mov dword ptr [ecx + field_146], eax         # 004ef83e
    jmp.d8 L_004ef897                            # 004ef844
L_004ef846:
    # block 0x004ef846: entered by je at 0x004ef81e, 23 instruction(s), falls into the block at 0x004ef897
    mov ecx, dword ptr [ebp - local_4]           # 004ef846
    mov eax, dword ptr [ecx + field_172]         # 004ef849
    cdq                                          # 004ef84f
    {load} sub eax, edx                          # 004ef850
    sar eax                                      # 004ef852
    mov edx, dword ptr [ebp - local_4]           # 004ef854
    mov ecx, dword ptr [edx + field_12e]         # 004ef857
    {load} add ecx, eax                          # 004ef85d
    mov edx, dword ptr [ebp - local_4]           # 004ef85f
    mov eax, dword ptr [edx + field_17a]         # 004ef862
    cdq                                          # 004ef868
    {load} sub eax, edx                          # 004ef869
    sar eax                                      # 004ef86b
    {load} sub ecx, eax                          # 004ef86d
    mov eax, dword ptr [ebp - local_4]           # 004ef86f
    mov dword ptr [eax + field_13e], ecx         # 004ef872
    mov ecx, dword ptr [ebp - local_4]           # 004ef878
    mov edx, dword ptr [ecx + field_13e]         # 004ef87b
    mov eax, dword ptr [ebp - local_4]           # 004ef881
    mov ecx, dword ptr [eax + field_17a]         # 004ef884
    lea edx, [edx + ecx - field_minus_1]         # 004ef88a
    mov eax, dword ptr [ebp - local_4]           # 004ef88e
    mov dword ptr [eax + field_146], edx         # 004ef891
L_004ef897:
    # block 0x004ef897: entered by jmp at 0x004ef54f; jmp at 0x004ef6f3; jmp at 0x004ef714; jmp at 0x004ef7d6; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ef897
    pop ebp                                      # 004ef899
    ret                                          # 004ef89a

