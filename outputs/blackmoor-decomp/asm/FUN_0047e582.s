# FUN_0047e582
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e582
# extent:       0x0047e582-0x0047e8fe (892 code bytes)
# span:         0x0047e582-0x0047e8fe (code 892, tables 0, padding 0)
# sha256:       35316b5f3316d70ae40750c62c47839d22752540ac805edc105e6fe1b901acce
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         piece_init
# naming:       native port src/action_family_eb_runtime.c:piece_init (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      Compared the original piece_init instruction by instruction with the native: persistence/scene skip test, field stores and rect translate, valid-rect choice of source rect, surface create, entry rect, blit, and the three-step rotation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 1 more
# fields:       [eax + n] field_4, field_16, field_1e, field_23, field_24, field_2b, field_42, field_13a4, field_minus_1; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_16, field_18, field_1c, field_20, field_22, field_23, field_28 and 4 more; [edx + n] field_4, field_8, field_c, field_10, field_14, field_16, field_20, field_24, field_2d, field_48, field_minus_1
# callees:      calls FUN_0047e52f, FUN_0047e99e, FUN_004c2a8d, FUN_004c51a5, FUN_004c7070
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:piece_init (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 279 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_42, 0x42  # offset +0x42
.equ field_48, 0x48  # offset +0x48
.equ field_99, 0x99  # offset +0x99
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_13a4, 0x13a4  # offset +0x13a4

# --- external targets -----------------------------------------------
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047e99e, .text + (0x0047e99e - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c7070, .text + (0x004c7070 - 0x401000)

.org 0x0047e582 - 0x401000
.globl FUN_0047e582
FUN_0047e582:
    # block 0x0047e582: entry, 23 instruction(s), ends with jne to 0x0047e5f5 (forward)
    push ebp                                     # 0047e582
    {load} mov ebp, esp                          # 0047e583
    sub esp, 0x34                                # 0047e585
    push esi                                     # 0047e588
    push edi                                     # 0047e589
    mov dword ptr [ebp - local_34], ecx          # 0047e58a
    mov eax, dword ptr [ebp - local_34]          # 0047e58d
    movsx ecx, word ptr [eax + field_1e]         # 0047e590
    imul ecx, ecx, 0x8d                          # 0047e594
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047e59a
    mov dword ptr [ebp - local_c], edx           # 0047e5a0
    movsx eax, word ptr [ebp + arg_8]            # 0047e5a3
    imul eax, eax, 0x25                          # 0047e5a7
    mov ecx, dword ptr [ebp - local_34]          # 0047e5aa
    lea edx, [ecx + eax + field_7b4]             # 0047e5ad
    mov dword ptr [ebp - local_20], edx          # 0047e5b4
    movsx eax, word ptr [ebp + arg_c]            # 0047e5b7
    imul eax, eax, 0x53                          # 0047e5bb
    mov ecx, dword ptr [ebp - local_c]           # 0047e5be
    lea edx, [ecx + eax + field_99]              # 0047e5c1
    mov dword ptr [ebp - local_4], edx           # 0047e5c8
    cmp dword ptr [ebp + arg_10], 0x0            # 0047e5cb
    jne.d8 L_0047e5f5                            # 0047e5cf
    # block 0x0047e5d1: entered by fall-through of jne at 0x0047e5cf, 5 instruction(s), ends with je to 0x0047e5f5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047e5d1
    {load} xor ecx, ecx                          # 0047e5d4
    mov cl, byte ptr [eax + field_42]            # 0047e5d6
    test ecx, ecx                                # 0047e5d9
    je.d8 L_0047e5f5                             # 0047e5db
    # block 0x0047e5dd: entered by fall-through of je at 0x0047e5db, 2 instruction(s), ends with je to 0x0047e5f5 (forward)
    cmp dword ptr [0x5a055d], 0x0                # 0047e5dd
    je.d8 L_0047e5f5                             # 0047e5e4
    # block 0x0047e5e6: entered by fall-through of je at 0x0047e5e4, 3 instruction(s), ends with je to 0x0047e645 (forward)
    movsx edx, word ptr [0x5a0561]               # 0047e5e6
    cmp edx, dword ptr [0x5bb57b]                # 0047e5ed
    je.d8 L_0047e645                             # 0047e5f3
L_0047e5f5:
    # block 0x0047e5f5: entered by jne at 0x0047e5cf; je at 0x0047e5db; je at 0x0047e5e4; fall-through of je at 0x0047e5f3, 27 instruction(s), calls FUN_0047e52f, falls into the block at 0x0047e645
    mov eax, dword ptr [ebp - local_20]          # 0047e5f5
    mov word ptr [eax], 0x0                      # 0047e5f8
    mov ecx, dword ptr [ebp - local_20]          # 0047e5fd
    mov dl, byte ptr [ebp + arg_c]               # 0047e600
    mov byte ptr [ecx + field_23], dl            # 0047e603
    mov eax, dword ptr [ebp - local_20]          # 0047e606
    mov byte ptr [eax + field_24], 0x0           # 0047e609
    mov ecx, dword ptr [ebp - local_4]           # 0047e60d
    add ecx, 0x10                                # 0047e610
    mov edx, dword ptr [ebp - local_20]          # 0047e613
    add edx, 0x2                                 # 0047e616
    mov eax, dword ptr [ecx]                     # 0047e619
    mov dword ptr [edx], eax                     # 0047e61b
    mov eax, dword ptr [ecx + field_4]           # 0047e61d
    mov dword ptr [edx + field_4], eax           # 0047e620
    mov eax, dword ptr [ecx + field_8]           # 0047e623
    mov dword ptr [edx + field_8], eax           # 0047e626
    mov ecx, dword ptr [ecx + field_c]           # 0047e629
    mov dword ptr [edx + field_c], ecx           # 0047e62c
    mov edx, dword ptr [ebp - local_20]          # 0047e62f
    add edx, 0x12                                # 0047e632
    push edx                                     # 0047e635
    mov eax, dword ptr [ebp - local_20]          # 0047e636
    add eax, 0x2                                 # 0047e639
    push eax                                     # 0047e63c
    mov ecx, dword ptr [ebp - local_34]          # 0047e63d
    call FUN_0047e52f                            # 0047e640
L_0047e645:
    # block 0x0047e645: entered by je at 0x0047e5f3, 4 instruction(s), ends with jne to 0x0047e8f6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047e645
    movsx edx, word ptr [ebp + arg_c]            # 0047e649
    {load} cmp ecx, edx                          # 0047e64d
    jne.d32 L_0047e8f6                           # 0047e64f
    # block 0x0047e655: entered by fall-through of jne at 0x0047e64f, 12 instruction(s), calls FUN_0047e99e, ends with je to 0x0047e6da (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047e655
    imul eax, eax, 0x60                          # 0047e659
    mov ecx, dword ptr [ebp - local_34]          # 0047e65c
    lea edx, [ecx + eax + field_20]              # 0047e65f
    mov dword ptr [ebp - local_14], edx          # 0047e663
    mov eax, dword ptr [ebp - local_4]           # 0047e666
    add eax, 0x20                                # 0047e669
    push eax                                     # 0047e66c
    mov ecx, dword ptr [ebp - local_34]          # 0047e66d
    call FUN_0047e99e                            # 0047e670
    test eax, eax                                # 0047e675
    je.d8 L_0047e6da                             # 0047e677
    # block 0x0047e679: entered by fall-through of je at 0x0047e677, 31 instruction(s), ends with forward jump to 0x0047e736
    mov ecx, dword ptr [ebp - local_4]           # 0047e679
    mov edx, dword ptr [ebp - local_4]           # 0047e67c
    mov eax, dword ptr [ecx + field_28]          # 0047e67f
    sub eax, dword ptr [edx + field_20]          # 0047e682
    add eax, 0x1                                 # 0047e685
    mov ecx, dword ptr [ebp - local_14]          # 0047e688
    mov word ptr [ecx + field_14], ax            # 0047e68b
    mov edx, dword ptr [ebp - local_14]          # 0047e68f
    mov ax, word ptr [edx + field_14]            # 0047e692
    mov word ptr [ebp - local_18], ax            # 0047e696
    mov ecx, dword ptr [ebp - local_4]           # 0047e69a
    mov edx, dword ptr [ebp - local_4]           # 0047e69d
    mov eax, dword ptr [ecx + field_2c]          # 0047e6a0
    sub eax, dword ptr [edx + field_24]          # 0047e6a3
    add eax, 0x1                                 # 0047e6a6
    mov ecx, dword ptr [ebp - local_14]          # 0047e6a9
    mov word ptr [ecx + field_16], ax            # 0047e6ac
    mov edx, dword ptr [ebp - local_14]          # 0047e6b0
    mov ax, word ptr [edx + field_16]            # 0047e6b3
    mov word ptr [ebp - local_10], ax            # 0047e6b7
    mov ecx, dword ptr [ebp - local_4]           # 0047e6bb
    add ecx, 0x20                                # 0047e6be
    mov edx, dword ptr [ecx]                     # 0047e6c1
    mov dword ptr [ebp - local_30], edx          # 0047e6c3
    mov eax, dword ptr [ecx + field_4]           # 0047e6c6
    mov dword ptr [ebp - local_2c], eax          # 0047e6c9
    mov edx, dword ptr [ecx + field_8]           # 0047e6cc
    mov dword ptr [ebp - local_28], edx          # 0047e6cf
    mov eax, dword ptr [ecx + field_c]           # 0047e6d2
    mov dword ptr [ebp - local_24], eax          # 0047e6d5
    jmp.d8 L_0047e736                            # 0047e6d8
L_0047e6da:
    # block 0x0047e6da: entered by je at 0x0047e677, 29 instruction(s), falls into the block at 0x0047e736
    mov ecx, dword ptr [ebp - local_4]           # 0047e6da
    mov edx, dword ptr [ebp - local_4]           # 0047e6dd
    mov eax, dword ptr [ecx + field_18]          # 0047e6e0
    sub eax, dword ptr [edx + field_10]          # 0047e6e3
    add eax, 0x1                                 # 0047e6e6
    mov ecx, dword ptr [ebp - local_14]          # 0047e6e9
    mov word ptr [ecx + field_14], ax            # 0047e6ec
    mov edx, dword ptr [ebp - local_14]          # 0047e6f0
    mov ax, word ptr [edx + field_14]            # 0047e6f3
    mov word ptr [ebp - local_18], ax            # 0047e6f7
    mov ecx, dword ptr [ebp - local_4]           # 0047e6fb
    mov edx, dword ptr [ebp - local_4]           # 0047e6fe
    mov eax, dword ptr [ecx + field_1c]          # 0047e701
    sub eax, dword ptr [edx + field_14]          # 0047e704
    add eax, 0x1                                 # 0047e707
    mov ecx, dword ptr [ebp - local_14]          # 0047e70a
    mov word ptr [ecx + field_16], ax            # 0047e70d
    mov edx, dword ptr [ebp - local_14]          # 0047e711
    mov ax, word ptr [edx + field_16]            # 0047e714
    mov word ptr [ebp - local_10], ax            # 0047e718
    mov ecx, dword ptr [ebp - local_4]           # 0047e71c
    mov edx, dword ptr [ecx]                     # 0047e71f
    mov dword ptr [ebp - local_30], edx          # 0047e721
    mov eax, dword ptr [ecx + field_4]           # 0047e724
    mov dword ptr [ebp - local_2c], eax          # 0047e727
    mov edx, dword ptr [ecx + field_8]           # 0047e72a
    mov dword ptr [ebp - local_28], edx          # 0047e72d
    mov eax, dword ptr [ecx + field_c]           # 0047e730
    mov dword ptr [ebp - local_24], eax          # 0047e733
L_0047e736:
    # block 0x0047e736: entered by jmp at 0x0047e6d8, 45 instruction(s), calls FUN_004c2a8d, FUN_004c51a5, ends with jne to 0x0047e7d8 (forward)
    push 0x54d4f0                                # 0047e736
    push 0x6                                     # 0047e73b
    mov cx, word ptr [ebp - local_10]            # 0047e73d
    push ecx                                     # 0047e741
    mov dx, word ptr [ebp - local_18]            # 0047e742
    push edx                                     # 0047e746
    mov ecx, 0x5cf659                            # 0047e747
    call FUN_004c2a8d                            # 0047e74c
    mov ecx, dword ptr [ebp - local_14]          # 0047e751
    mov dword ptr [ecx], eax                     # 0047e754
    mov edx, dword ptr [ebp - local_14]          # 0047e756
    mov dword ptr [edx + field_8], 0x0           # 0047e759
    mov eax, dword ptr [ebp - local_14]          # 0047e760
    mov dword ptr [eax + field_4], 0x0           # 0047e763
    movsx ecx, word ptr [ebp - local_10]         # 0047e76a
    mov edx, dword ptr [ebp - local_14]          # 0047e76e
    mov eax, dword ptr [edx + field_8]           # 0047e771
    lea ecx, [eax + ecx - field_minus_1]         # 0047e774
    mov edx, dword ptr [ebp - local_14]          # 0047e778
    mov dword ptr [edx + field_10], ecx          # 0047e77b
    movsx eax, word ptr [ebp - local_18]         # 0047e77e
    mov ecx, dword ptr [ebp - local_14]          # 0047e782
    mov edx, dword ptr [ecx + field_4]           # 0047e785
    lea eax, [edx + eax - field_minus_1]         # 0047e788
    mov ecx, dword ptr [ebp - local_14]          # 0047e78c
    mov dword ptr [ecx + field_c], eax           # 0047e78f
    push 0x54d528                                # 0047e792
    mov edx, dword ptr [ebp - local_14]          # 0047e797
    add edx, 0x4                                 # 0047e79a
    push edx                                     # 0047e79d
    lea eax, [ebp - local_30]                    # 0047e79e
    push eax                                     # 0047e7a1
    mov ecx, dword ptr [ebp - local_14]          # 0047e7a2
    mov edx, dword ptr [ecx]                     # 0047e7a5
    push edx                                     # 0047e7a7
    mov eax, dword ptr [ebp - local_34]          # 0047e7a8
    mov ecx, dword ptr [eax + field_13a4]        # 0047e7ab
    push ecx                                     # 0047e7b1
    mov ecx, 0x5cf659                            # 0047e7b2
    call FUN_004c51a5                            # 0047e7b7
    mov edx, dword ptr [ebp - local_c]           # 0047e7bc
    {load} xor eax, eax                          # 0047e7bf
    mov al, byte ptr [edx + field_48]            # 0047e7c1
    test eax, eax                                # 0047e7c4
    jne.d8 L_0047e7d8                            # 0047e7c6
    # block 0x0047e7c8: entered by fall-through of jne at 0x0047e7c6, 5 instruction(s), ends with je to 0x0047e8f6 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047e7c8
    {load} xor edx, edx                          # 0047e7cb
    mov dl, byte ptr [ecx + field_22]            # 0047e7cd
    test edx, edx                                # 0047e7d0
    je.d32 L_0047e8f6                            # 0047e7d2
L_0047e7d8:
    # block 0x0047e7d8: entered by jne at 0x0047e7c6; fall-through of je at 0x0047e7d2, 2 instruction(s), ends with forward jump to 0x0047e7e6
    mov byte ptr [ebp - local_8], 0x1            # 0047e7d8
    jmp.d8 L_0047e7e6                            # 0047e7dc
L_0047e7de:
    # block 0x0047e7de: entered by jmp at 0x0047e8f1, 3 instruction(s), falls into the block at 0x0047e7e6
    mov al, byte ptr [ebp - local_8]             # 0047e7de
    add al, 0x1                                  # 0047e7e1
    mov byte ptr [ebp - local_8], al             # 0047e7e3
L_0047e7e6:
    # block 0x0047e7e6: entered by jmp at 0x0047e7dc, 4 instruction(s), ends with jge to 0x0047e8f6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047e7e6
    and ecx, 0xff                                # 0047e7e9
    cmp ecx, 0x4                                 # 0047e7ef
    jge.d32 L_0047e8f6                           # 0047e7f2
    # block 0x0047e7f8: entered by fall-through of jge at 0x0047e7f2, 79 instruction(s), calls FUN_004c2a8d, FUN_004c7070, ends with backward jump to 0x0047e7de
    mov edx, dword ptr [ebp - local_14]          # 0047e7f8
    mov dword ptr [ebp - local_1c], edx          # 0047e7fb
    movsx eax, word ptr [ebp + arg_c]            # 0047e7fe
    imul eax, eax, 0x60                          # 0047e802
    mov ecx, dword ptr [ebp - local_34]          # 0047e805
    lea edx, [ecx + eax + field_20]              # 0047e808
    mov eax, dword ptr [ebp - local_8]           # 0047e80c
    and eax, 0xff                                # 0047e80f
    imul eax, eax, 0x18                          # 0047e814
    {load} add edx, eax                          # 0047e817
    mov dword ptr [ebp - local_14], edx          # 0047e819
    push 0x54d564                                # 0047e81c
    push 0x6                                     # 0047e821
    mov cx, word ptr [ebp - local_10]            # 0047e823
    push ecx                                     # 0047e827
    mov dx, word ptr [ebp - local_18]            # 0047e828
    push edx                                     # 0047e82c
    mov ecx, 0x5cf659                            # 0047e82d
    call FUN_004c2a8d                            # 0047e832
    mov ecx, dword ptr [ebp - local_14]          # 0047e837
    mov dword ptr [ecx], eax                     # 0047e83a
    mov edx, dword ptr [ebp - local_1c]          # 0047e83c
    mov eax, dword ptr [edx]                     # 0047e83f
    mov ecx, dword ptr [eax + field_23]          # 0047e841
    mov edx, dword ptr [ebp - local_1c]          # 0047e844
    mov eax, dword ptr [edx]                     # 0047e847
    mov esi, dword ptr [eax]                     # 0047e849
    mov edx, dword ptr [ebp - local_14]          # 0047e84b
    mov eax, dword ptr [edx]                     # 0047e84e
    mov edi, dword ptr [eax]                     # 0047e850
    {load} mov edx, ecx                          # 0047e852
    shr ecx, 0x2                                 # 0047e854
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047e857
    {load} mov ecx, edx                          # 0047e859
    and ecx, 0x3                                 # 0047e85b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047e85e
    push 0x63a898                                # 0047e860
    mov eax, dword ptr [ebp - local_14]          # 0047e865
    mov ecx, dword ptr [eax]                     # 0047e868
    push ecx                                     # 0047e86a
    mov ecx, 0x5cf659                            # 0047e86b
    call FUN_004c7070                            # 0047e870
    mov edx, dword ptr [ebp - local_14]          # 0047e875
    mov dword ptr [edx + field_8], 0x0           # 0047e878
    mov eax, dword ptr [ebp - local_14]          # 0047e87f
    mov dword ptr [eax + field_4], 0x0           # 0047e882
    mov ecx, dword ptr [ebp - local_14]          # 0047e889
    mov edx, dword ptr [ecx]                     # 0047e88c
    movsx eax, word ptr [edx + field_2d]         # 0047e88e
    mov ecx, dword ptr [ebp - local_14]          # 0047e892
    mov edx, dword ptr [ecx + field_8]           # 0047e895
    lea eax, [edx + eax - field_minus_1]         # 0047e898
    mov ecx, dword ptr [ebp - local_14]          # 0047e89c
    mov dword ptr [ecx + field_10], eax          # 0047e89f
    mov edx, dword ptr [ebp - local_14]          # 0047e8a2
    mov eax, dword ptr [edx]                     # 0047e8a5
    movsx ecx, word ptr [eax + field_2b]         # 0047e8a7
    mov edx, dword ptr [ebp - local_14]          # 0047e8ab
    mov eax, dword ptr [edx + field_4]           # 0047e8ae
    lea ecx, [eax + ecx - field_minus_1]         # 0047e8b1
    mov edx, dword ptr [ebp - local_14]          # 0047e8b5
    mov dword ptr [edx + field_c], ecx           # 0047e8b8
    mov eax, dword ptr [ebp - local_14]          # 0047e8bb
    mov ecx, dword ptr [eax]                     # 0047e8be
    mov edx, dword ptr [ebp - local_14]          # 0047e8c0
    mov ax, word ptr [ecx + field_2b]            # 0047e8c3
    mov word ptr [edx + field_14], ax            # 0047e8c7
    mov ecx, dword ptr [ebp - local_14]          # 0047e8cb
    mov edx, dword ptr [ecx]                     # 0047e8ce
    mov eax, dword ptr [ebp - local_14]          # 0047e8d0
    mov cx, word ptr [edx + field_2d]            # 0047e8d3
    mov word ptr [eax + field_16], cx            # 0047e8d7
    mov edx, dword ptr [ebp - local_14]          # 0047e8db
    mov ax, word ptr [edx + field_14]            # 0047e8de
    mov word ptr [ebp - local_18], ax            # 0047e8e2
    mov ecx, dword ptr [ebp - local_14]          # 0047e8e6
    mov dx, word ptr [ecx + field_16]            # 0047e8e9
    mov word ptr [ebp - local_10], dx            # 0047e8ed
    jmp.d32 L_0047e7de                           # 0047e8f1
L_0047e8f6:
    # block 0x0047e8f6: entered by jne at 0x0047e64f; je at 0x0047e7d2; jge at 0x0047e7f2, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047e8f6
    pop esi                                      # 0047e8f7
    {load} mov esp, ebp                          # 0047e8f8
    pop ebp                                      # 0047e8fa
    ret 0xc                                      # 0047e8fb

