# FUN_0044c4c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c4c1
# extent:       0x0044c4c1-0x0044c9db (1306 code bytes)
# span:         0x0044c4c1-0x0044c9db (code 1306, tables 0, padding 0)
# sha256:       8dd6a87ff43cc31725db8afa3dfd0c7740e39e6b738b109f71072a9cd21911e7
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c4c1
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       12 ebp-relative slot(s): local_104, local_204, local_308, local_30c, local_310, local_314, local_318, local_31c, local_320, local_324, local_328, local_32c
# fields:       [eax + n] field_4, field_10, field_176, field_186, field_18c, field_18e, field_194, field_196, field_198, field_19a, field_19e, field_1a2 and 7 more; [ecx + n] field_4, field_c, field_17, field_19, field_176, field_186, field_18c, field_18e, field_190, field_194, field_196, field_198 and 7 more; [edx + n] field_15, field_17, field_19, field_1b, field_1c, field_20, field_186, field_18c, field_198, field_19a, field_19e, field_1a2 and 3 more
# callees:      calls FUN_0050cd72, FUN_00449d90, FUN_00414ceb, FUN_004bf315, FUN_004bf3b8, FUN_0044a2b7, FUN_004264e8, FUN_004c97b4, FUN_004bee5f, FUN_0050ca3e, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 329 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_104, 0x104  # offset -0x104
.equ local_204, 0x204  # offset -0x204
.equ local_308, 0x308  # offset -0x308
.equ local_30c, 0x30c  # offset -0x30c
.equ local_310, 0x310  # offset -0x310
.equ local_314, 0x314  # offset -0x314
.equ local_318, 0x318  # offset -0x318
.equ local_31c, 0x31c  # offset -0x31c
.equ local_320, 0x320  # offset -0x320
.equ local_324, 0x324  # offset -0x324
.equ local_328, 0x328  # offset -0x328
.equ local_32c, 0x32c  # offset -0x32c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_15, 0x15  # offset +0x15
.equ field_17, 0x17  # offset +0x17
.equ field_19, 0x19  # offset +0x19
.equ field_1b, 0x1b  # offset +0x1b
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_176, 0x176  # offset +0x176
.equ field_186, 0x186  # offset +0x186
.equ field_18c, 0x18c  # offset +0x18c
.equ field_18e, 0x18e  # offset +0x18e
.equ field_190, 0x190  # offset +0x190
.equ field_194, 0x194  # offset +0x194
.equ field_196, 0x196  # offset +0x196
.equ field_198, 0x198  # offset +0x198
.equ field_19a, 0x19a  # offset +0x19a
.equ field_19e, 0x19e  # offset +0x19e
.equ field_1a2, 0x1a2  # offset +0x1a2
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8

# --- external targets -----------------------------------------------
.set FUN_00414ceb, .text + (0x00414ceb - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00449d90, .text + (0x00449d90 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bee5f, .text + (0x004bee5f - 0x401000)
.set FUN_004bf315, .text + (0x004bf315 - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x0044c4c1 - 0x401000
.globl FUN_0044c4c1
FUN_0044c4c1:
    # block 0x0044c4c1: entry, 10 instruction(s), ends with je to 0x0044c50e (forward)
    push ebp                                     # 0044c4c1
    {load} mov ebp, esp                          # 0044c4c2
    sub esp, 0x32c                               # 0044c4c4
    push esi                                     # 0044c4ca
    push edi                                     # 0044c4cb
    mov eax, dword ptr [ebp + arg_8]             # 0044c4cc
    mov ecx, dword ptr [eax + field_176]         # 0044c4cf
    mov dword ptr [ebp - local_310], ecx         # 0044c4d5
    cmp dword ptr [ebp - local_310], 0x1         # 0044c4db
    je.d8 L_0044c50e                             # 0044c4e2
    # block 0x0044c4e4: entered by fall-through of je at 0x0044c4e2, 16 instruction(s), ends with forward jump to 0x0044c536
    mov edi, 0x54938c                            # 0044c4e4
    lea edx, [ebp - local_204]                   # 0044c4e9
    or ecx, -0x1                                 # 0044c4ef
    {load} xor eax, eax                          # 0044c4f2
    repne scasb al, byte ptr es:[edi]            # 0044c4f4
    not ecx                                      # 0044c4f6
    {load} sub edi, ecx                          # 0044c4f8
    {load} mov esi, edi                          # 0044c4fa
    {load} mov eax, ecx                          # 0044c4fc
    {load} mov edi, edx                          # 0044c4fe
    shr ecx, 0x2                                 # 0044c500
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044c503
    {load} mov ecx, eax                          # 0044c505
    and ecx, 0x3                                 # 0044c507
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044c50a
    jmp.d8 L_0044c536                            # 0044c50c
L_0044c50e:
    # block 0x0044c50e: entered by je at 0x0044c4e2, 15 instruction(s), falls into the block at 0x0044c536
    mov edi, 0x549394                            # 0044c50e
    lea edx, [ebp - local_204]                   # 0044c513
    or ecx, -0x1                                 # 0044c519
    {load} xor eax, eax                          # 0044c51c
    repne scasb al, byte ptr es:[edi]            # 0044c51e
    not ecx                                      # 0044c520
    {load} sub edi, ecx                          # 0044c522
    {load} mov esi, edi                          # 0044c524
    {load} mov eax, ecx                          # 0044c526
    {load} mov edi, edx                          # 0044c528
    shr ecx, 0x2                                 # 0044c52a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044c52d
    {load} mov ecx, eax                          # 0044c52f
    and ecx, 0x3                                 # 0044c531
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044c534
L_0044c536:
    # block 0x0044c536: entered by jmp at 0x0044c50c, 19 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with jne to 0x0044c5d5 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0044c536
    mov word ptr [ecx + field_1c4], 0x1          # 0044c539
    lea edx, [ebp - local_204]                   # 0044c542
    push edx                                     # 0044c548
    mov eax, dword ptr [ebp + arg_8]             # 0044c549
    add eax, 0x151                               # 0044c54c
    push eax                                     # 0044c551
    push 0x639eb5                                # 0044c552
    push 0x639dae                                # 0044c557
    lea ecx, [ebp - local_308]                   # 0044c55c
    push ecx                                     # 0044c562
    call FUN_0050cd72                            # 0044c563
    add esp, 0x14                                # 0044c568
    lea edx, [ebp - local_308]                   # 0044c56b
    push edx                                     # 0044c571
    call FUN_00449d90                            # 0044c572
    add esp, 0x4                                 # 0044c577
    test eax, eax                                # 0044c57a
    jne.d8 L_0044c5d5                            # 0044c57c
    # block 0x0044c57e: entered by fall-through of jne at 0x0044c57c, 29 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x0044c600
    lea eax, [ebp - local_204]                   # 0044c57e
    push eax                                     # 0044c584
    mov ecx, dword ptr [ebp + arg_8]             # 0044c585
    add ecx, 0x151                               # 0044c588
    push ecx                                     # 0044c58e
    push 0x639fb9                                # 0044c58f
    push 0x639dab                                # 0044c594
    lea edx, [ebp - local_104]                   # 0044c599
    push edx                                     # 0044c59f
    call FUN_0050cd72                            # 0044c5a0
    add esp, 0x14                                # 0044c5a5
    lea edi, [ebp - local_104]                   # 0044c5a8
    mov eax, dword ptr [ebp + arg_8]             # 0044c5ae
    add eax, 0x4d                                # 0044c5b1
    {load} mov edx, eax                          # 0044c5b4
    or ecx, -0x1                                 # 0044c5b6
    {load} xor eax, eax                          # 0044c5b9
    repne scasb al, byte ptr es:[edi]            # 0044c5bb
    not ecx                                      # 0044c5bd
    {load} sub edi, ecx                          # 0044c5bf
    {load} mov esi, edi                          # 0044c5c1
    {load} mov eax, ecx                          # 0044c5c3
    {load} mov edi, edx                          # 0044c5c5
    shr ecx, 0x2                                 # 0044c5c7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044c5ca
    {load} mov ecx, eax                          # 0044c5cc
    and ecx, 0x3                                 # 0044c5ce
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044c5d1
    jmp.d8 L_0044c600                            # 0044c5d3
L_0044c5d5:
    # block 0x0044c5d5: entered by jne at 0x0044c57c, 17 instruction(s), falls into the block at 0x0044c600
    lea edi, [ebp - local_308]                   # 0044c5d5
    mov ecx, dword ptr [ebp + arg_8]             # 0044c5db
    add ecx, 0x4d                                # 0044c5de
    {load} mov edx, ecx                          # 0044c5e1
    or ecx, -0x1                                 # 0044c5e3
    {load} xor eax, eax                          # 0044c5e6
    repne scasb al, byte ptr es:[edi]            # 0044c5e8
    not ecx                                      # 0044c5ea
    {load} sub edi, ecx                          # 0044c5ec
    {load} mov esi, edi                          # 0044c5ee
    {load} mov eax, ecx                          # 0044c5f0
    {load} mov edi, edx                          # 0044c5f2
    shr ecx, 0x2                                 # 0044c5f4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044c5f7
    {load} mov ecx, eax                          # 0044c5f9
    and ecx, 0x3                                 # 0044c5fb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044c5fe
L_0044c600:
    # block 0x0044c600: entered by jmp at 0x0044c5d3, 5 instruction(s), ends with je to 0x0044c739 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0044c600
    mov edx, dword ptr [ecx + field_176]         # 0044c603
    mov dword ptr [ebp - local_314], edx         # 0044c609
    cmp dword ptr [ebp - local_314], 0x1         # 0044c60f
    je.d32 L_0044c739                            # 0044c616
    # block 0x0044c61c: entered by fall-through of je at 0x0044c616, 67 instruction(s), calls FUN_00414ceb, ends with forward jump to 0x0044c98d
    mov eax, dword ptr [ebp + arg_8]             # 0044c61c
    push eax                                     # 0044c61f
    mov ecx, 0x5e2dbe                            # 0044c620
    call FUN_00414ceb                            # 0044c625
    mov ecx, dword ptr [ebp + arg_8]             # 0044c62a
    mov word ptr [ecx + field_18c], 0x0          # 0044c62d
    mov edx, dword ptr [ebp + arg_8]             # 0044c636
    movsx eax, word ptr [edx + field_15]         # 0044c639
    mov ecx, dword ptr [ebp + arg_8]             # 0044c63d
    mov dword ptr [ecx + field_190], eax         # 0044c640
    mov edx, dword ptr [ebp + arg_8]             # 0044c646
    movsx eax, word ptr [edx + field_18c]        # 0044c649
    mov ecx, dword ptr [ebp + arg_8]             # 0044c650
    mov edx, dword ptr [ecx + field_190]         # 0044c653
    lea eax, [eax + edx - field_minus_1]         # 0044c659
    mov ecx, dword ptr [ebp + arg_8]             # 0044c65d
    mov word ptr [ecx + field_18e], ax           # 0044c660
    mov edx, dword ptr [ebp + arg_8]             # 0044c667
    mov dword ptr [edx + field_19e], 0x0         # 0044c66a
    mov eax, dword ptr [ebp + arg_8]             # 0044c674
    mov dword ptr [eax + field_19a], 0x0         # 0044c677
    mov ecx, dword ptr [ebp + arg_8]             # 0044c681
    movsx edx, word ptr [ecx + field_19]         # 0044c684
    mov eax, dword ptr [ebp + arg_8]             # 0044c688
    mov ecx, dword ptr [eax + field_19e]         # 0044c68b
    lea edx, [ecx + edx - field_minus_1]         # 0044c691
    mov eax, dword ptr [ebp + arg_8]             # 0044c695
    mov dword ptr [eax + field_1a6], edx         # 0044c698
    mov ecx, dword ptr [ebp + arg_8]             # 0044c69e
    movsx edx, word ptr [ecx + field_17]         # 0044c6a1
    mov eax, dword ptr [ebp + arg_8]             # 0044c6a5
    mov ecx, dword ptr [eax + field_19a]         # 0044c6a8
    lea edx, [ecx + edx - field_minus_1]         # 0044c6ae
    mov eax, dword ptr [ebp + arg_8]             # 0044c6b2
    mov dword ptr [eax + field_1a2], edx         # 0044c6b5
    mov ecx, dword ptr [ebp + arg_8]             # 0044c6bb
    mov edx, dword ptr [ebp + arg_8]             # 0044c6be
    mov ax, word ptr [edx + field_17]            # 0044c6c1
    mov word ptr [ecx + field_194], ax           # 0044c6c5
    mov ecx, dword ptr [ebp + arg_8]             # 0044c6cc
    mov edx, dword ptr [ebp + arg_8]             # 0044c6cf
    mov ax, word ptr [edx + field_19]            # 0044c6d2
    mov word ptr [ecx + field_198], ax           # 0044c6d6
    mov ecx, dword ptr [ebp + arg_8]             # 0044c6dd
    movsx ecx, word ptr [ecx + field_194]        # 0044c6e0
    mov edx, dword ptr [ebp + arg_8]             # 0044c6e7
    {load} xor eax, eax                          # 0044c6ea
    mov al, byte ptr [edx + field_1b]            # 0044c6ec
    cdq                                          # 0044c6ef
    and edx, 0x7                                 # 0044c6f0
    {load} add eax, edx                          # 0044c6f3
    sar eax, 0x3                                 # 0044c6f5
    imul ecx, eax                                # 0044c6f8
    mov eax, dword ptr [ebp + arg_8]             # 0044c6fb
    mov word ptr [eax + field_196], cx           # 0044c6fe
    mov ecx, dword ptr [ebp + arg_8]             # 0044c705
    mov edx, dword ptr [ebp + arg_8]             # 0044c708
    mov eax, dword ptr [edx + field_1c]          # 0044c70b
    mov dword ptr [ecx + field_1ba], eax         # 0044c70e
    mov ecx, dword ptr [ebp + arg_8]             # 0044c714
    movsx edx, word ptr [ecx + field_196]        # 0044c717
    mov eax, dword ptr [ebp + arg_8]             # 0044c71e
    movsx ecx, word ptr [eax + field_198]        # 0044c721
    imul edx, ecx                                # 0044c728
    mov eax, dword ptr [ebp + arg_8]             # 0044c72b
    mov dword ptr [eax + field_1c8], edx         # 0044c72e
    jmp.d32 L_0044c98d                           # 0044c734
L_0044c739:
    # block 0x0044c739: entered by je at 0x0044c616, 11 instruction(s), calls FUN_004bf315, ends with jne to 0x0044c7bb (forward)
    push 0x0                                     # 0044c739
    mov ecx, dword ptr [ebp + arg_8]             # 0044c73b
    add ecx, 0x4d                                # 0044c73e
    push ecx                                     # 0044c741
    mov ecx, 0x6201f9                            # 0044c742
    call FUN_004bf315                            # 0044c747
    mov edx, dword ptr [ebp + arg_8]             # 0044c74c
    mov dword ptr [edx + field_186], eax         # 0044c74f
    mov eax, dword ptr [ebp + arg_8]             # 0044c755
    cmp dword ptr [eax + field_186], 0x0         # 0044c758
    jne.d8 L_0044c7bb                            # 0044c75f
    # block 0x0044c761: entered by fall-through of jne at 0x0044c75f, 3 instruction(s), ends with je to 0x0044c786 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0044c761
    test ecx, ecx                                # 0044c768
    je.d8 L_0044c786                             # 0044c76a
    # block 0x0044c76c: entered by fall-through of je at 0x0044c76a, 8 instruction(s), calls FUN_004bf3b8, FUN_0044a2b7, falls into the block at 0x0044c786
    mov edx, dword ptr [ebp + arg_8]             # 0044c76c
    add edx, 0x4d                                # 0044c76f
    push edx                                     # 0044c772
    mov ecx, 0x6201f9                            # 0044c773
    call FUN_004bf3b8                            # 0044c778
    push eax                                     # 0044c77d
    call FUN_0044a2b7                            # 0044c77e
    add esp, 0x4                                 # 0044c783
L_0044c786:
    # block 0x0044c786: entered by je at 0x0044c76a, 12 instruction(s), calls FUN_004bf3b8, FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x0044c9d5
    mov eax, dword ptr [ebp + arg_8]             # 0044c786
    add eax, 0x4d                                # 0044c789
    push eax                                     # 0044c78c
    mov ecx, 0x6201f9                            # 0044c78d
    call FUN_004bf3b8                            # 0044c792
    push eax                                     # 0044c797
    mov ecx, 0x583979                            # 0044c798
    call FUN_004264e8                            # 0044c79d
    mov dword ptr [0x5bb20c], 0x1                # 0044c7a2
    mov ecx, 0x5cf659                            # 0044c7ac
    call FUN_004c97b4                            # 0044c7b1
    jmp.d32 L_0044c9d5                           # 0044c7b6
L_0044c7bb:
    # block 0x0044c7bb: entered by jne at 0x0044c75f, 9 instruction(s), calls FUN_004bee5f, ends with je to 0x0044c7ea (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0044c7bb
    mov edx, dword ptr [ecx + field_186]         # 0044c7be
    push edx                                     # 0044c7c4
    mov ecx, 0x6201f9                            # 0044c7c5
    call FUN_004bee5f                            # 0044c7ca
    mov dword ptr [ebp - local_30c], eax         # 0044c7cf
    mov eax, dword ptr [ebp + arg_8]             # 0044c7d5
    cmp dword ptr [eax + field_186], 0x0         # 0044c7d8
    je.d8 L_0044c7ea                             # 0044c7df
    # block 0x0044c7e1: entered by fall-through of je at 0x0044c7df, 2 instruction(s), ends with jne to 0x0044c843 (forward)
    cmp dword ptr [ebp - local_30c], 0x0         # 0044c7e1
    jne.d8 L_0044c843                            # 0044c7e8
L_0044c7ea:
    # block 0x0044c7ea: entered by je at 0x0044c7df; fall-through of jne at 0x0044c7e8, 10 instruction(s), calls FUN_0050ca3e, ends with je to 0x0044c81b (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0044c7ea
    add ecx, 0x4d                                # 0044c7ed
    push ecx                                     # 0044c7f0
    push 0x54939c                                # 0044c7f1
    push 0x63888b                                # 0044c7f6
    call FUN_0050ca3e                            # 0044c7fb
    add esp, 0xc                                 # 0044c800
    movsx edx, word ptr [0x63a4cd]               # 0044c803
    test edx, edx                                # 0044c80a
    je.d8 L_0044c81b                             # 0044c80c
    # block 0x0044c80e: entered by fall-through of je at 0x0044c80c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c81b
    push 0x63888b                                # 0044c80e
    call FUN_0044a2b7                            # 0044c813
    add esp, 0x4                                 # 0044c818
L_0044c81b:
    # block 0x0044c81b: entered by je at 0x0044c80c, 7 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x0044c9d5
    push 0x63888b                                # 0044c81b
    mov ecx, 0x583979                            # 0044c820
    call FUN_004264e8                            # 0044c825
    mov dword ptr [0x5bb20c], 0x1                # 0044c82a
    mov ecx, 0x5cf659                            # 0044c834
    call FUN_004c97b4                            # 0044c839
    jmp.d32 L_0044c9d5                           # 0044c83e
L_0044c843:
    # block 0x0044c843: entered by jne at 0x0044c7e8, 65 instruction(s), calls FUN_0050ce04, falls into the block at 0x0044c98d
    mov eax, dword ptr [ebp + arg_8]             # 0044c843
    mov word ptr [eax + field_18c], 0x0          # 0044c846
    mov ecx, dword ptr [ebp + arg_8]             # 0044c84f
    mov edx, dword ptr [ebp - local_30c]         # 0044c852
    mov eax, dword ptr [edx + field_20]          # 0044c858
    mov dword ptr [ecx + field_190], eax         # 0044c85b
    mov ecx, dword ptr [ebp + arg_8]             # 0044c861
    mov edx, dword ptr [ecx + field_190]         # 0044c864
    sub edx, 0x1                                 # 0044c86a
    mov eax, dword ptr [ebp + arg_8]             # 0044c86d
    mov word ptr [eax + field_18e], dx           # 0044c870
    mov ecx, dword ptr [ebp + arg_8]             # 0044c877
    mov dword ptr [ecx + field_19e], 0x0         # 0044c87a
    mov edx, dword ptr [ebp + arg_8]             # 0044c884
    mov dword ptr [edx + field_19a], 0x0         # 0044c887
    mov eax, dword ptr [ebp - local_30c]         # 0044c891
    mov ecx, dword ptr [eax + field_4]           # 0044c897
    sub ecx, 0x1                                 # 0044c89a
    mov edx, dword ptr [ebp + arg_8]             # 0044c89d
    mov dword ptr [edx + field_1a6], ecx         # 0044c8a0
    mov eax, dword ptr [ebp - local_30c]         # 0044c8a6
    mov ecx, dword ptr [eax]                     # 0044c8ac
    sub ecx, 0x1                                 # 0044c8ae
    mov edx, dword ptr [ebp + arg_8]             # 0044c8b1
    mov dword ptr [edx + field_1a2], ecx         # 0044c8b4
    mov eax, dword ptr [ebp + arg_8]             # 0044c8ba
    mov ecx, dword ptr [ebp - local_30c]         # 0044c8bd
    mov dx, word ptr [ecx]                       # 0044c8c3
    mov word ptr [eax + field_194], dx           # 0044c8c6
    mov eax, dword ptr [ebp + arg_8]             # 0044c8cd
    mov ecx, dword ptr [ebp - local_30c]         # 0044c8d0
    mov dx, word ptr [ecx + field_4]             # 0044c8d6
    mov word ptr [eax + field_198], dx           # 0044c8da
    movsx eax, word ptr [0x639895]               # 0044c8e1
    mov ecx, dword ptr [ebp - local_30c]         # 0044c8e8
    mov edx, dword ptr [ecx]                     # 0044c8ee
    imul edx, eax                                # 0044c8f0
    mov eax, dword ptr [ebp + arg_8]             # 0044c8f3
    mov word ptr [eax + field_196], dx           # 0044c8f6
    mov ecx, dword ptr [ebp - local_30c]         # 0044c8fd
    mov edx, dword ptr [ecx + field_c]           # 0044c903
    mov dword ptr [ebp - local_31c], edx         # 0044c906
    mov dword ptr [ebp - local_318], 0x0         # 0044c90c
    fild qword ptr [ebp - local_31c]             # 0044c916
    fstp dword ptr [ebp - local_320]             # 0044c91c
    mov eax, dword ptr [ebp - local_30c]         # 0044c922
    mov ecx, dword ptr [eax + field_10]          # 0044c928
    mov dword ptr [ebp - local_328], ecx         # 0044c92b
    mov dword ptr [ebp - local_324], 0x0         # 0044c931
    fild qword ptr [ebp - local_328]             # 0044c93b
    fstp dword ptr [ebp - local_32c]             # 0044c941
    fld dword ptr [ebp - local_320]              # 0044c947
    fdiv dword ptr [ebp - local_32c]             # 0044c94d
    fdivr qword ptr [0x52c598]                   # 0044c953
    fmul qword ptr [0x52c590]                    # 0044c959
    call FUN_0050ce04                            # 0044c95f
    mov edx, dword ptr [ebp + arg_8]             # 0044c964
    mov dword ptr [edx + field_1ba], eax         # 0044c967
    mov eax, dword ptr [ebp + arg_8]             # 0044c96d
    movsx ecx, word ptr [eax + field_196]        # 0044c970
    mov edx, dword ptr [ebp + arg_8]             # 0044c977
    movsx eax, word ptr [edx + field_198]        # 0044c97a
    imul ecx, eax                                # 0044c981
    mov edx, dword ptr [ebp + arg_8]             # 0044c984
    mov dword ptr [edx + field_1c8], ecx         # 0044c987
L_0044c98d:
    # block 0x0044c98d: entered by jmp at 0x0044c734, 16 instruction(s), falls into the block at 0x0044c9d5
    mov eax, dword ptr [ebp + arg_8]             # 0044c98d
    mov ecx, dword ptr [ebp + arg_8]             # 0044c990
    mov edx, dword ptr [ecx + field_19e]         # 0044c993
    mov dword ptr [eax + field_1ae], edx         # 0044c999
    mov eax, dword ptr [ebp + arg_8]             # 0044c99f
    mov ecx, dword ptr [ebp + arg_8]             # 0044c9a2
    mov edx, dword ptr [ecx + field_1a6]         # 0044c9a5
    mov dword ptr [eax + field_1b6], edx         # 0044c9ab
    mov eax, dword ptr [ebp + arg_8]             # 0044c9b1
    mov ecx, dword ptr [ebp + arg_8]             # 0044c9b4
    mov edx, dword ptr [ecx + field_19a]         # 0044c9b7
    mov dword ptr [eax + field_1aa], edx         # 0044c9bd
    mov eax, dword ptr [ebp + arg_8]             # 0044c9c3
    mov ecx, dword ptr [ebp + arg_8]             # 0044c9c6
    mov edx, dword ptr [ecx + field_1a2]         # 0044c9c9
    mov dword ptr [eax + field_1b2], edx         # 0044c9cf
L_0044c9d5:
    # block 0x0044c9d5: entered by jmp at 0x0044c7b6; jmp at 0x0044c83e, 5 instruction(s), ends with ret
    pop edi                                      # 0044c9d5
    pop esi                                      # 0044c9d6
    {load} mov esp, ebp                          # 0044c9d7
    pop ebp                                      # 0044c9d9
    ret                                          # 0044c9da

