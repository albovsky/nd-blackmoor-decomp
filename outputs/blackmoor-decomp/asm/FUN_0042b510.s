# FUN_0042b510
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042b510
# extent:       0x0042b510-0x0042b87a (874 code bytes)
# span:         0x0042b510-0x0042b87a (code 874, tables 0, padding 0)
# sha256:       7b6add44ee603469b4796a06cc173c2882506ba7fb33ff3aa16d3e984e257663
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_hot_multiframe_scene_change_handler
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/42b510.c.txt, not original source) refers to the data labelled s_ProcessHotMultiFrMultiSceneChang_0054570c
# name-note:    Three-state handler for a hot multi-frame scene-change record: checks a variable condition, sets the next scene globals, and errors with ProcessHotMultiFrMultiSceneChange on a bad type.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_6, field_8, field_13, field_19, field_1f, field_22, field_2f, field_31, field_3a; [ecx + n] field_4, field_a, field_f, field_17, field_1d, field_1f, field_2a, field_2e, field_2f, field_3e; [edx + n] field_2, field_8, field_b, field_17, field_1b, field_21, field_26, field_31, field_32, field_34, field_36, field_42
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 214 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_b, 0xb  # offset +0xb
.equ field_f, 0xf  # offset +0xf
.equ field_13, 0x13  # offset +0x13
.equ field_17, 0x17  # offset +0x17
.equ field_19, 0x19  # offset +0x19
.equ field_1b, 0x1b  # offset +0x1b
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1f, 0x1f  # offset +0x1f
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_32, 0x32  # offset +0x32
.equ field_34, 0x34  # offset +0x34
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042b510 - 0x401000
.globl FUN_0042b510
FUN_0042b510:
    # block 0x0042b510: entry, 13 instruction(s), ends with je to 0x0042b557 (forward)
    push ebp                                     # 0042b510
    {load} mov ebp, esp                          # 0042b511
    sub esp, 0x14                                # 0042b513
    movsx eax, word ptr [ebp + arg_8]            # 0042b516
    imul eax, eax, 0x8d                          # 0042b51a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b520
    mov dword ptr [ebp - local_4], ecx           # 0042b526
    movsx edx, word ptr [ebp + arg_8]            # 0042b529
    imul edx, edx, 0x8d                          # 0042b52d
    mov eax, dword ptr [edx + 0x5bb632]          # 0042b533
    mov dword ptr [ebp - local_10], eax          # 0042b539
    cmp dword ptr [ebp - local_10], 0x0          # 0042b53c
    je.d8 L_0042b557                             # 0042b540
    # block 0x0042b542: entered by fall-through of je at 0x0042b540, 2 instruction(s), ends with je to 0x0042b575 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0042b542
    je.d8 L_0042b575                             # 0042b546
    # block 0x0042b548: entered by fall-through of je at 0x0042b546, 2 instruction(s), ends with je to 0x0042b66e (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0042b548
    je.d32 L_0042b66e                            # 0042b54c
    # block 0x0042b552: entered by fall-through of je at 0x0042b54c, 1 instruction(s), ends with forward jump to 0x0042b876
    jmp.d32 L_0042b876                           # 0042b552
L_0042b557:
    # block 0x0042b557: entered by je at 0x0042b540, 4 instruction(s), falls into the block at 0x0042b575
    mov dword ptr [0x5bb1ca], 0x1                # 0042b557
    movsx ecx, word ptr [ebp + arg_8]            # 0042b561
    imul ecx, ecx, 0x8d                          # 0042b565
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0042b56b
L_0042b575:
    # block 0x0042b575: entered by je at 0x0042b546, 5 instruction(s), ends with forward jump to 0x0042b59d
    movsx edx, word ptr [ebp + arg_8]            # 0042b575
    imul edx, edx, 0x8d                          # 0042b579
    mov dword ptr [edx + 0x5bb626], 0x0          # 0042b57f
    mov word ptr [ebp - local_8], 0x0            # 0042b589
    jmp.d8 L_0042b59d                            # 0042b58f
L_0042b591:
    # block 0x0042b591: entered by jmp at 0x0042b664, 3 instruction(s), falls into the block at 0x0042b59d
    mov ax, word ptr [ebp - local_8]             # 0042b591
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042b595
    mov word ptr [ebp - local_8], ax             # 0042b599
L_0042b59d:
    # block 0x0042b59d: entered by jmp at 0x0042b58f, 5 instruction(s), ends with jge to 0x0042b669 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042b59d
    mov edx, dword ptr [ebp - local_4]           # 0042b5a1
    movsx eax, word ptr [edx + field_32]         # 0042b5a4
    {load} cmp ecx, eax                          # 0042b5a8
    jge.d32 L_0042b669                           # 0042b5aa
    # block 0x0042b5b0: entered by fall-through of jge at 0x0042b5aa, 7 instruction(s), ends with jne to 0x0042b664 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042b5b0
    imul ecx, ecx, 0x12                          # 0042b5b4
    mov edx, dword ptr [ebp - local_4]           # 0042b5b7
    movsx eax, word ptr [edx + ecx + field_34]   # 0042b5ba
    movsx ecx, word ptr [0x5bb50b]               # 0042b5bf
    {load} cmp eax, ecx                          # 0042b5c6
    jne.d32 L_0042b664                           # 0042b5c8
    # block 0x0042b5ce: entered by fall-through of jne at 0x0042b5c8, 32 instruction(s), ends with forward jump to 0x0042b669
    movsx edx, word ptr [ebp + arg_8]            # 0042b5ce
    imul edx, edx, 0x8d                          # 0042b5d2
    mov dword ptr [edx + 0x5bb626], 0x1          # 0042b5d8
    movsx eax, word ptr [ebp - local_8]          # 0042b5e2
    imul eax, eax, 0x12                          # 0042b5e6
    movsx ecx, word ptr [ebp + arg_8]            # 0042b5e9
    imul ecx, ecx, 0x8d                          # 0042b5ed
    mov edx, dword ptr [ebp - local_4]           # 0042b5f3
    mov ax, word ptr [edx + eax + field_36]      # 0042b5f6
    mov word ptr [ecx + 0x5bb62a], ax            # 0042b5fb
    movsx ecx, word ptr [ebp - local_8]          # 0042b602
    imul ecx, ecx, 0x12                          # 0042b606
    movsx edx, word ptr [ebp + arg_8]            # 0042b609
    imul edx, edx, 0x8d                          # 0042b60d
    mov eax, dword ptr [ebp - local_4]           # 0042b613
    mov cx, word ptr [eax + ecx + field_3a]      # 0042b616
    mov word ptr [edx + 0x5bb62c], cx            # 0042b61b
    movsx edx, word ptr [ebp - local_8]          # 0042b622
    imul edx, edx, 0x12                          # 0042b626
    movsx eax, word ptr [ebp + arg_8]            # 0042b629
    imul eax, eax, 0x8d                          # 0042b62d
    mov ecx, dword ptr [ebp - local_4]           # 0042b633
    mov dx, word ptr [ecx + edx + field_3e]      # 0042b636
    mov word ptr [eax + 0x5bb62e], dx            # 0042b63b
    movsx eax, word ptr [ebp - local_8]          # 0042b642
    imul eax, eax, 0x12                          # 0042b646
    movsx ecx, word ptr [ebp + arg_8]            # 0042b649
    imul ecx, ecx, 0x8d                          # 0042b64d
    mov edx, dword ptr [ebp - local_4]           # 0042b653
    mov ax, word ptr [edx + eax + field_42]      # 0042b656
    mov word ptr [ecx + 0x5bb630], ax            # 0042b65b
    jmp.d8 L_0042b669                            # 0042b662
L_0042b664:
    # block 0x0042b664: entered by jne at 0x0042b5c8, 1 instruction(s), ends with backward jump to 0x0042b591
    jmp.d32 L_0042b591                           # 0042b664
L_0042b669:
    # block 0x0042b669: entered by jge at 0x0042b5aa; jmp at 0x0042b662, 1 instruction(s), ends with forward jump to 0x0042b876
    jmp.d32 L_0042b876                           # 0042b669
L_0042b66e:
    # block 0x0042b66e: entered by je at 0x0042b54c, 6 instruction(s), ends with je to 0x0042b691 (forward)
    mov word ptr [ebp - local_c], 0x0            # 0042b66e
    mov ecx, dword ptr [ebp - local_4]           # 0042b674
    mov dl, byte ptr [ecx + field_2e]            # 0042b677
    mov byte ptr [ebp - local_14], dl            # 0042b67a
    cmp byte ptr [ebp - local_14], 0x1           # 0042b67d
    je.d8 L_0042b691                             # 0042b681
    # block 0x0042b683: entered by fall-through of je at 0x0042b681, 2 instruction(s), ends with je to 0x0042b6b9 (forward)
    cmp byte ptr [ebp - local_14], 0x2           # 0042b683
    je.d8 L_0042b6b9                             # 0042b687
    # block 0x0042b689: entered by fall-through of je at 0x0042b687, 2 instruction(s), ends with je to 0x0042b6e1 (forward)
    cmp byte ptr [ebp - local_14], 0x3           # 0042b689
    je.d8 L_0042b6e1                             # 0042b68d
    # block 0x0042b68f: entered by fall-through of je at 0x0042b68d, 1 instruction(s), ends with forward jump to 0x0042b704
    jmp.d8 L_0042b704                            # 0042b68f
L_0042b691:
    # block 0x0042b691: entered by je at 0x0042b681, 7 instruction(s), ends with jne to 0x0042b6b1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0042b691
    movsx ecx, word ptr [eax + field_2f]         # 0042b694
    mov edx, dword ptr [ebp - local_4]           # 0042b698
    {load} xor eax, eax                          # 0042b69b
    mov al, byte ptr [edx + field_31]            # 0042b69d
    cmp dword ptr [4*ecx + 0x585801], eax        # 0042b6a0
    jne.d8 L_0042b6b1                            # 0042b6a7
    # block 0x0042b6a9: entered by fall-through of jne at 0x0042b6a7, 2 instruction(s), ends with forward jump to 0x0042b6b7
    mov word ptr [ebp - local_c], 0x0            # 0042b6a9
    jmp.d8 L_0042b6b7                            # 0042b6af
L_0042b6b1:
    # block 0x0042b6b1: entered by jne at 0x0042b6a7, 1 instruction(s), falls into the block at 0x0042b6b7
    mov word ptr [ebp - local_c], 0x1            # 0042b6b1
L_0042b6b7:
    # block 0x0042b6b7: entered by jmp at 0x0042b6af, 1 instruction(s), ends with forward jump to 0x0042b733
    jmp.d8 L_0042b733                            # 0042b6b7
L_0042b6b9:
    # block 0x0042b6b9: entered by je at 0x0042b687, 7 instruction(s), ends with jne to 0x0042b6d9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0042b6b9
    movsx edx, word ptr [ecx + field_2f]         # 0042b6bc
    mov eax, dword ptr [ebp - local_4]           # 0042b6c0
    {load} xor ecx, ecx                          # 0042b6c3
    mov cl, byte ptr [eax + field_31]            # 0042b6c5
    cmp dword ptr [4*edx + 0x583bd5], ecx        # 0042b6c8
    jne.d8 L_0042b6d9                            # 0042b6cf
    # block 0x0042b6d1: entered by fall-through of jne at 0x0042b6cf, 2 instruction(s), ends with forward jump to 0x0042b6df
    mov word ptr [ebp - local_c], 0x0            # 0042b6d1
    jmp.d8 L_0042b6df                            # 0042b6d7
L_0042b6d9:
    # block 0x0042b6d9: entered by jne at 0x0042b6cf, 1 instruction(s), falls into the block at 0x0042b6df
    mov word ptr [ebp - local_c], 0x1            # 0042b6d9
L_0042b6df:
    # block 0x0042b6df: entered by jmp at 0x0042b6d7, 1 instruction(s), ends with forward jump to 0x0042b733
    jmp.d8 L_0042b733                            # 0042b6df
L_0042b6e1:
    # block 0x0042b6e1: entered by je at 0x0042b68d, 6 instruction(s), ends with jne to 0x0042b6fc (forward)
    movsx edx, word ptr [0x583a29]               # 0042b6e1
    mov eax, dword ptr [ebp - local_4]           # 0042b6e8
    {load} xor ecx, ecx                          # 0042b6eb
    mov cl, byte ptr [eax + field_31]            # 0042b6ed
    {load} cmp edx, ecx                          # 0042b6f0
    jne.d8 L_0042b6fc                            # 0042b6f2
    # block 0x0042b6f4: entered by fall-through of jne at 0x0042b6f2, 2 instruction(s), ends with forward jump to 0x0042b702
    mov word ptr [ebp - local_c], 0x0            # 0042b6f4
    jmp.d8 L_0042b702                            # 0042b6fa
L_0042b6fc:
    # block 0x0042b6fc: entered by jne at 0x0042b6f2, 1 instruction(s), falls into the block at 0x0042b702
    mov word ptr [ebp - local_c], 0x1            # 0042b6fc
L_0042b702:
    # block 0x0042b702: entered by jmp at 0x0042b6fa, 1 instruction(s), ends with forward jump to 0x0042b733
    jmp.d8 L_0042b733                            # 0042b702
L_0042b704:
    # block 0x0042b704: entered by jmp at 0x0042b68f, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0042b733
    movsx edx, word ptr [ebp + arg_8]            # 0042b704
    push edx                                     # 0042b708
    push 0x54570c                                # 0042b709
    push 0x63888b                                # 0042b70e
    call FUN_0050ca3e                            # 0042b713
    add esp, 0xc                                 # 0042b718
    push 0x0                                     # 0042b71b
    push 0x0                                     # 0042b71d
    push 0x63888b                                # 0042b71f
    call FUN_0052139c                            # 0042b724
    mov ecx, 0x5cf659                            # 0042b729
    call FUN_004c97b4                            # 0042b72e
L_0042b733:
    # block 0x0042b733: entered by jmp at 0x0042b6b7; jmp at 0x0042b6df; jmp at 0x0042b702, 3 instruction(s), ends with jne to 0x0042b7d6 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0042b733
    test eax, eax                                # 0042b737
    jne.d32 L_0042b7d6                           # 0042b739
    # block 0x0042b73f: entered by fall-through of jne at 0x0042b739, 4 instruction(s), ends with je to 0x0042b7af (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0042b73f
    movsx edx, word ptr [ecx]                    # 0042b742
    cmp edx, 0x270f                              # 0042b745
    je.d8 L_0042b7af                             # 0042b74b
    # block 0x0042b74d: entered by fall-through of je at 0x0042b74b, 22 instruction(s), falls into the block at 0x0042b7af
    mov eax, dword ptr [ebp - local_4]           # 0042b74d
    movsx ecx, word ptr [eax]                    # 0042b750
    mov dword ptr [0x5bb57b], ecx                # 0042b753
    mov edx, dword ptr [ebp - local_4]           # 0042b759
    mov ax, word ptr [edx + field_2]             # 0042b75c
    mov word ptr [0x5bb599], ax                  # 0042b760
    mov ecx, dword ptr [ebp - local_4]           # 0042b766
    mov dx, word ptr [ecx + field_4]             # 0042b769
    mov word ptr [0x5bb595], dx                  # 0042b76d
    mov eax, dword ptr [ebp - local_4]           # 0042b774
    mov cx, word ptr [eax + field_6]             # 0042b777
    mov word ptr [0x5c39ff], cx                  # 0042b77b
    mov edx, dword ptr [ebp - local_4]           # 0042b782
    mov eax, dword ptr [edx + field_b]           # 0042b785
    mov dword ptr [0x5bb59b], eax                # 0042b788
    mov ecx, dword ptr [ebp - local_4]           # 0042b78d
    mov edx, dword ptr [ecx + field_f]           # 0042b790
    mov dword ptr [0x5bb59f], edx                # 0042b793
    mov eax, dword ptr [ebp - local_4]           # 0042b799
    mov ecx, dword ptr [eax + field_13]          # 0042b79c
    mov dword ptr [0x5bb5a3], ecx                # 0042b79f
    mov dword ptr [0x583999], 0x4                # 0042b7a5
L_0042b7af:
    # block 0x0042b7af: entered by je at 0x0042b74b, 4 instruction(s), ends with je to 0x0042b7d1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0042b7af
    movsx eax, word ptr [edx + field_8]          # 0042b7b2
    cmp eax, -0x1                                # 0042b7b6
    je.d8 L_0042b7d1                             # 0042b7b9
    # block 0x0042b7bb: entered by fall-through of je at 0x0042b7b9, 6 instruction(s), falls into the block at 0x0042b7d1
    mov ecx, dword ptr [ebp - local_4]           # 0042b7bb
    {load} xor edx, edx                          # 0042b7be
    mov dl, byte ptr [ecx + field_a]             # 0042b7c0
    mov eax, dword ptr [ebp - local_4]           # 0042b7c3
    movsx ecx, word ptr [eax + field_8]          # 0042b7c6
    mov dword ptr [4*ecx + 0x585801], edx        # 0042b7ca
L_0042b7d1:
    # block 0x0042b7d1: entered by je at 0x0042b7b9, 1 instruction(s), ends with forward jump to 0x0042b869
    jmp.d32 L_0042b869                           # 0042b7d1
L_0042b7d6:
    # block 0x0042b7d6: entered by jne at 0x0042b739, 4 instruction(s), ends with je to 0x0042b847 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0042b7d6
    movsx eax, word ptr [edx + field_17]         # 0042b7d9
    cmp eax, 0x270f                              # 0042b7dd
    je.d8 L_0042b847                             # 0042b7e2
    # block 0x0042b7e4: entered by fall-through of je at 0x0042b7e2, 22 instruction(s), falls into the block at 0x0042b847
    mov ecx, dword ptr [ebp - local_4]           # 0042b7e4
    movsx edx, word ptr [ecx + field_17]         # 0042b7e7
    mov dword ptr [0x5bb57b], edx                # 0042b7eb
    mov eax, dword ptr [ebp - local_4]           # 0042b7f1
    mov cx, word ptr [eax + field_19]            # 0042b7f4
    mov word ptr [0x5bb599], cx                  # 0042b7f8
    mov edx, dword ptr [ebp - local_4]           # 0042b7ff
    mov ax, word ptr [edx + field_1b]            # 0042b802
    mov word ptr [0x5bb595], ax                  # 0042b806
    mov ecx, dword ptr [ebp - local_4]           # 0042b80c
    mov dx, word ptr [ecx + field_1d]            # 0042b80f
    mov word ptr [0x5c39ff], dx                  # 0042b813
    mov eax, dword ptr [ebp - local_4]           # 0042b81a
    mov ecx, dword ptr [eax + field_22]          # 0042b81d
    mov dword ptr [0x5bb59b], ecx                # 0042b820
    mov edx, dword ptr [ebp - local_4]           # 0042b826
    mov eax, dword ptr [edx + field_26]          # 0042b829
    mov dword ptr [0x5bb59f], eax                # 0042b82c
    mov ecx, dword ptr [ebp - local_4]           # 0042b831
    mov edx, dword ptr [ecx + field_2a]          # 0042b834
    mov dword ptr [0x5bb5a3], edx                # 0042b837
    mov dword ptr [0x583999], 0x4                # 0042b83d
L_0042b847:
    # block 0x0042b847: entered by je at 0x0042b7e2, 4 instruction(s), ends with je to 0x0042b869 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0042b847
    movsx ecx, word ptr [eax + field_1f]         # 0042b84a
    cmp ecx, -0x1                                # 0042b84e
    je.d8 L_0042b869                             # 0042b851
    # block 0x0042b853: entered by fall-through of je at 0x0042b851, 6 instruction(s), falls into the block at 0x0042b869
    mov edx, dword ptr [ebp - local_4]           # 0042b853
    {load} xor eax, eax                          # 0042b856
    mov al, byte ptr [edx + field_21]            # 0042b858
    mov ecx, dword ptr [ebp - local_4]           # 0042b85b
    movsx edx, word ptr [ecx + field_1f]         # 0042b85e
    mov dword ptr [4*edx + 0x585801], eax        # 0042b862
L_0042b869:
    # block 0x0042b869: entered by jmp at 0x0042b7d1; je at 0x0042b851, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042b876
    mov ax, word ptr [ebp + arg_8]               # 0042b869
    push eax                                     # 0042b86d
    call FUN_0042ba3a                            # 0042b86e
    add esp, 0x4                                 # 0042b873
L_0042b876:
    # block 0x0042b876: entered by jmp at 0x0042b552; jmp at 0x0042b669, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042b876
    pop ebp                                      # 0042b878
    ret                                          # 0042b879

