# FUN_0042f510
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042f510
# extent:       0x0042f510-0x0042fc70 (1888 code bytes)
# span:         0x0042f510-0x0042fc70 (code 1888, tables 0, padding 0)
# sha256:       e354318a2b0ce68f92d1516f47e929537631152264d3ea54c95971e557b5242f
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042f510
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_567, field_569, field_56b, field_56d, field_56f, field_573, field_577, field_57b, field_57d, field_57f; [ecx + n] field_21, field_23, field_4a5, field_5a1; [edx + n] field_4ee, field_5a1, field_5b1, field_5b3, field_5b5, field_5b7, field_5b9, field_5bd, field_5c1, field_5c5, field_5c7, field_5c9
# callees:      calls FUN_004e8d96, FUN_0050ca3e, FUN_0044a2b7, FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 386 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_4a5, 0x4a5  # offset +0x4a5
.equ field_4ee, 0x4ee  # offset +0x4ee
.equ field_567, 0x567  # offset +0x567
.equ field_569, 0x569  # offset +0x569
.equ field_56b, 0x56b  # offset +0x56b
.equ field_56d, 0x56d  # offset +0x56d
.equ field_56f, 0x56f  # offset +0x56f
.equ field_573, 0x573  # offset +0x573
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57d, 0x57d  # offset +0x57d
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5a1, 0x5a1  # offset +0x5a1
.equ field_5b1, 0x5b1  # offset +0x5b1
.equ field_5b3, 0x5b3  # offset +0x5b3
.equ field_5b5, 0x5b5  # offset +0x5b5
.equ field_5b7, 0x5b7  # offset +0x5b7
.equ field_5b9, 0x5b9  # offset +0x5b9
.equ field_5bd, 0x5bd  # offset +0x5bd
.equ field_5c1, 0x5c1  # offset +0x5c1
.equ field_5c5, 0x5c5  # offset +0x5c5
.equ field_5c7, 0x5c7  # offset +0x5c7
.equ field_5c9, 0x5c9  # offset +0x5c9

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0042f510 - 0x401000
.globl FUN_0042f510
FUN_0042f510:
    # block 0x0042f510: entry, 11 instruction(s), ends with je to 0x0042f54a (forward)
    push ebp                                     # 0042f510
    {load} mov ebp, esp                          # 0042f511
    sub esp, 0x14                                # 0042f513
    push esi                                     # 0042f516
    push edi                                     # 0042f517
    movsx eax, word ptr [ebp + arg_8]            # 0042f518
    imul eax, eax, 0x8d                          # 0042f51c
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042f522
    mov dword ptr [ebp - local_10], ecx          # 0042f528
    cmp dword ptr [ebp - local_10], 0x0          # 0042f52b
    je.d8 L_0042f54a                             # 0042f52f
    # block 0x0042f531: entered by fall-through of je at 0x0042f52f, 2 instruction(s), ends with je to 0x0042f6e3 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0042f531
    je.d32 L_0042f6e3                            # 0042f535
    # block 0x0042f53b: entered by fall-through of je at 0x0042f535, 2 instruction(s), ends with je to 0x0042f8df (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0042f53b
    je.d32 L_0042f8df                            # 0042f53f
    # block 0x0042f545: entered by fall-through of je at 0x0042f53f, 1 instruction(s), ends with forward jump to 0x0042fc6a
    jmp.d32 L_0042fc6a                           # 0042f545
L_0042f54a:
    # block 0x0042f54a: entered by je at 0x0042f52f, 11 instruction(s), calls FUN_004e8d96, ends with je to 0x0042f5d8 (forward)
    mov byte ptr [0x5b615e], 0x1                 # 0042f54a
    mov byte ptr [0x5b616a], 0x0                 # 0042f551
    mov dword ptr [0x5bb1ca], 0x1                # 0042f558
    mov dx, word ptr [ebp + arg_8]               # 0042f562
    mov word ptr [0x5b615f], dx                  # 0042f566
    mov byte ptr [0x5b6165], 0x0                 # 0042f56d
    mov ecx, 0x571442                            # 0042f574
    call FUN_004e8d96                            # 0042f579
    movsx eax, word ptr [0x591990]               # 0042f57e
    test eax, eax                                # 0042f585
    je.d8 L_0042f5d8                             # 0042f587
    # block 0x0042f589: entered by fall-through of je at 0x0042f587, 3 instruction(s), ends with jne to 0x0042f5d8 (forward)
    movsx ecx, word ptr [0x591992]               # 0042f589
    cmp ecx, -0x1                                # 0042f590
    jne.d8 L_0042f5d8                            # 0042f593
    # block 0x0042f595: entered by fall-through of jne at 0x0042f593, 3 instruction(s), ends with je to 0x0042f5cf (forward)
    movsx edx, word ptr [0x63a4cd]               # 0042f595
    test edx, edx                                # 0042f59c
    je.d8 L_0042f5cf                             # 0042f59e
    # block 0x0042f5a0: entered by fall-through of je at 0x0042f59e, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0042f5cf
    movsx eax, word ptr [0x591992]               # 0042f5a0
    push eax                                     # 0042f5a7
    movsx ecx, word ptr [0x591990]               # 0042f5a8
    push ecx                                     # 0042f5af
    push 0x545b6c                                # 0042f5b0
    push 0x63888b                                # 0042f5b5
    call FUN_0050ca3e                            # 0042f5ba
    add esp, 0x10                                # 0042f5bf
    push 0x63888b                                # 0042f5c2
    call FUN_0044a2b7                            # 0042f5c7
    add esp, 0x4                                 # 0042f5cc
L_0042f5cf:
    # block 0x0042f5cf: entered by je at 0x0042f59e, 1 instruction(s), falls into the block at 0x0042f5d8
    mov word ptr [0x591990], 0x0                 # 0042f5cf
L_0042f5d8:
    # block 0x0042f5d8: entered by je at 0x0042f587; jne at 0x0042f593, 3 instruction(s), ends with je to 0x0042f5ff (forward)
    movsx edx, word ptr [0x591990]               # 0042f5d8
    test edx, edx                                # 0042f5df
    je.d8 L_0042f5ff                             # 0042f5e1
    # block 0x0042f5e3: entered by fall-through of je at 0x0042f5e1, 7 instruction(s), ends with jne to 0x0042f621 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042f5e3
    imul eax, eax, 0x8d                          # 0042f5e7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f5ed
    {load} xor edx, edx                          # 0042f5f3
    mov dl, byte ptr [ecx + field_4a5]           # 0042f5f5
    test edx, edx                                # 0042f5fb
    jne.d8 L_0042f621                            # 0042f5fd
L_0042f5ff:
    # block 0x0042f5ff: entered by je at 0x0042f5e1; fall-through of jne at 0x0042f5fd, 7 instruction(s), falls into the block at 0x0042f621
    movsx eax, word ptr [ebp + arg_8]            # 0042f5ff
    imul eax, eax, 0x8d                          # 0042f603
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0042f609
    add esi, 0x4a6                               # 0042f60f
    mov ecx, 0x12                                # 0042f615
    mov edi, 0x591992                            # 0042f61a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042f61f
L_0042f621:
    # block 0x0042f621: entered by jne at 0x0042f5fd, 26 instruction(s), calls FUN_004c2dfb, FUN_004c2790, ends with je to 0x0042f6c0 (forward)
    mov word ptr [0x591990], 0x1                 # 0042f621
    push 0x5d03db                                # 0042f62a
    mov ecx, 0x5cf659                            # 0042f62f
    call FUN_004c2dfb                            # 0042f634
    push 0x545bf4                                # 0042f639
    push 0x6                                     # 0042f63e
    movsx ecx, word ptr [ebp + arg_8]            # 0042f640
    imul ecx, ecx, 0x8d                          # 0042f644
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f64a
    push edx                                     # 0042f650
    push 0x545c0c                                # 0042f651
    mov ecx, 0x5cf659                            # 0042f656
    call FUN_004c2790                            # 0042f65b
    mov dword ptr [0x5d03db], eax                # 0042f660
    mov eax, dword ptr [0x5d03db]                # 0042f665
    mov dword ptr [0x5d1bab], eax                # 0042f66a
    mov dword ptr [0x5d1bb7], 0x1                # 0042f66f
    mov edi, 0x545c14                            # 0042f679
    movsx ecx, word ptr [ebp + arg_8]            # 0042f67e
    imul ecx, ecx, 0x8d                          # 0042f682
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0042f688
    add esi, 0x536                               # 0042f68e
    mov ecx, 0x9                                 # 0042f694
    {load} xor edx, edx                          # 0042f699
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042f69b
    je.d8 L_0042f6c0                             # 0042f69d
    # block 0x0042f69f: entered by fall-through of je at 0x0042f69d, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x0042f6c0
    movsx eax, word ptr [ebp + arg_8]            # 0042f69f
    imul eax, eax, 0x8d                          # 0042f6a3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f6a9
    add ecx, 0x536                               # 0042f6af
    push ecx                                     # 0042f6b5
    mov ecx, 0x5c3a67                            # 0042f6b6
    call FUN_004fb77a                            # 0042f6bb
L_0042f6c0:
    # block 0x0042f6c0: entered by je at 0x0042f69d, 5 instruction(s), ends with forward jump to 0x0042fc6a
    mov dword ptr [0x5b6166], 0x0                # 0042f6c0
    movsx edx, word ptr [ebp + arg_8]            # 0042f6ca
    imul edx, edx, 0x8d                          # 0042f6ce
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042f6d4
    jmp.d32 L_0042fc6a                           # 0042f6de
L_0042f6e3:
    # block 0x0042f6e3: entered by je at 0x0042f535, 4 instruction(s), ends with je to 0x0042f70a (forward)
    mov eax, dword ptr [0x5b6166]                # 0042f6e3
    mov dword ptr [ebp - local_14], eax          # 0042f6e8
    cmp dword ptr [ebp - local_14], 0x0          # 0042f6eb
    je.d8 L_0042f70a                             # 0042f6ef
    # block 0x0042f6f1: entered by fall-through of je at 0x0042f6ef, 2 instruction(s), ends with je to 0x0042f87a (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 0042f6f1
    je.d32 L_0042f87a                            # 0042f6f5
    # block 0x0042f6fb: entered by fall-through of je at 0x0042f6f5, 2 instruction(s), ends with je to 0x0042f7ef (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 0042f6fb
    je.d32 L_0042f7ef                            # 0042f6ff
    # block 0x0042f705: entered by fall-through of je at 0x0042f6ff, 1 instruction(s), ends with forward jump to 0x0042f8da
    jmp.d32 L_0042f8da                           # 0042f705
L_0042f70a:
    # block 0x0042f70a: entered by je at 0x0042f6ef, 3 instruction(s), ends with forward jump to 0x0042f725
    mov byte ptr [0x5b616a], 0x1                 # 0042f70a
    mov word ptr [ebp - local_8], 0x0            # 0042f711
    jmp.d8 L_0042f725                            # 0042f717
L_0042f719:
    # block 0x0042f719: entered by jmp at 0x0042f7ca, 3 instruction(s), falls into the block at 0x0042f725
    mov cx, word ptr [ebp - local_8]             # 0042f719
    add cx, 0x1                                  # 0042f71d
    mov word ptr [ebp - local_8], cx             # 0042f721
L_0042f725:
    # block 0x0042f725: entered by jmp at 0x0042f717, 7 instruction(s), ends with jge to 0x0042f7cf (forward)
    movsx edx, word ptr [ebp - local_8]          # 0042f725
    movsx eax, word ptr [ebp + arg_8]            # 0042f729
    imul eax, eax, 0x8d                          # 0042f72d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f733
    movsx eax, word ptr [ecx + field_23]         # 0042f739
    {load} cmp edx, eax                          # 0042f73d
    jge.d32 L_0042f7cf                           # 0042f73f
    # block 0x0042f745: entered by fall-through of jge at 0x0042f73f, 2 instruction(s), ends with forward jump to 0x0042f759
    mov word ptr [ebp - local_4], 0x0            # 0042f745
    jmp.d8 L_0042f759                            # 0042f74b
L_0042f74d:
    # block 0x0042f74d: entered by jmp at 0x0042f7bb, 3 instruction(s), falls into the block at 0x0042f759
    mov cx, word ptr [ebp - local_4]             # 0042f74d
    add cx, 0x1                                  # 0042f751
    mov word ptr [ebp - local_4], cx             # 0042f755
L_0042f759:
    # block 0x0042f759: entered by jmp at 0x0042f74b, 7 instruction(s), ends with jge to 0x0042f7bd (forward)
    movsx edx, word ptr [ebp - local_4]          # 0042f759
    movsx eax, word ptr [ebp + arg_8]            # 0042f75d
    imul eax, eax, 0x8d                          # 0042f761
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f767
    movsx eax, word ptr [ecx + field_21]         # 0042f76d
    {load} cmp edx, eax                          # 0042f771
    jge.d8 L_0042f7bd                            # 0042f773
    # block 0x0042f775: entered by fall-through of jge at 0x0042f773, 14 instruction(s), ends with je to 0x0042f7bb (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042f775
    imul ecx, ecx, 0xc                           # 0042f779
    movsx edx, word ptr [ebp - local_4]          # 0042f77c
    movsx eax, word ptr [ecx + 2*edx + 0x591992] # 0042f780
    movsx ecx, word ptr [ebp + arg_8]            # 0042f788
    imul ecx, ecx, 0x8d                          # 0042f78c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f792
    movsx ecx, word ptr [ebp - local_8]          # 0042f798
    imul ecx, ecx, 0xc                           # 0042f79c
    lea edx, [edx + ecx + field_4ee]             # 0042f79f
    movsx ecx, word ptr [ebp - local_4]          # 0042f7a6
    movsx edx, word ptr [edx + 2*ecx]            # 0042f7aa
    {load} cmp eax, edx                          # 0042f7ae
    je.d8 L_0042f7bb                             # 0042f7b0
    # block 0x0042f7b2: entered by fall-through of je at 0x0042f7b0, 2 instruction(s), ends with forward jump to 0x0042f7bd
    mov byte ptr [0x5b616a], 0x0                 # 0042f7b2
    jmp.d8 L_0042f7bd                            # 0042f7b9
L_0042f7bb:
    # block 0x0042f7bb: entered by je at 0x0042f7b0, 1 instruction(s), ends with backward jump to 0x0042f74d
    jmp.d8 L_0042f74d                            # 0042f7bb
L_0042f7bd:
    # block 0x0042f7bd: entered by jge at 0x0042f773; jmp at 0x0042f7b9, 4 instruction(s), ends with jne to 0x0042f7ca (forward)
    {load} xor eax, eax                          # 0042f7bd
    mov al, byte ptr [0x5b616a]                  # 0042f7bf
    test eax, eax                                # 0042f7c4
    jne.d8 L_0042f7ca                            # 0042f7c6
    # block 0x0042f7c8: entered by fall-through of jne at 0x0042f7c6, 1 instruction(s), ends with forward jump to 0x0042f7cf
    jmp.d8 L_0042f7cf                            # 0042f7c8
L_0042f7ca:
    # block 0x0042f7ca: entered by jne at 0x0042f7c6, 1 instruction(s), ends with backward jump to 0x0042f719
    jmp.d32 L_0042f719                           # 0042f7ca
L_0042f7cf:
    # block 0x0042f7cf: entered by jge at 0x0042f73f; jmp at 0x0042f7c8, 4 instruction(s), ends with je to 0x0042f7ea (forward)
    {load} xor ecx, ecx                          # 0042f7cf
    mov cl, byte ptr [0x5b616a]                  # 0042f7d1
    test ecx, ecx                                # 0042f7d7
    je.d8 L_0042f7ea                             # 0042f7d9
    # block 0x0042f7db: entered by fall-through of je at 0x0042f7d9, 2 instruction(s), ends with forward jump to 0x0042f8da
    mov dword ptr [0x5b6166], 0x2                # 0042f7db
    jmp.d32 L_0042f8da                           # 0042f7e5
L_0042f7ea:
    # block 0x0042f7ea: entered by je at 0x0042f7d9, 1 instruction(s), ends with forward jump to 0x0042f8da
    jmp.d32 L_0042f8da                           # 0042f7ea
L_0042f7ef:
    # block 0x0042f7ef: entered by je at 0x0042f6ff, 9 instruction(s), ends with je to 0x0042f864 (forward)
    mov edi, 0x545c20                            # 0042f7ef
    movsx edx, word ptr [ebp + arg_8]            # 0042f7f4
    imul edx, edx, 0x8d                          # 0042f7f8
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0042f7fe
    add esi, 0x580                               # 0042f804
    mov ecx, 0x9                                 # 0042f80a
    {load} xor eax, eax                          # 0042f80f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042f811
    je.d8 L_0042f864                             # 0042f813
    # block 0x0042f815: entered by fall-through of je at 0x0042f813, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0042f878
    movsx ecx, word ptr [ebp + arg_8]            # 0042f815
    imul ecx, ecx, 0x8d                          # 0042f819
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f81f
    add edx, 0x580                               # 0042f825
    push edx                                     # 0042f82b
    mov ecx, 0x5c3a67                            # 0042f82c
    call FUN_004fb77a                            # 0042f831
    movsx eax, word ptr [ebp + arg_8]            # 0042f836
    imul eax, eax, 0x8d                          # 0042f83a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f840
    mov dx, word ptr [ecx + field_5a1]           # 0042f846
    push edx                                     # 0042f84d
    mov ecx, 0x5c3a67                            # 0042f84e
    call FUN_004fb2e3                            # 0042f853
    mov dword ptr [0x5b6166], 0x1                # 0042f858
    jmp.d8 L_0042f878                            # 0042f862
L_0042f864:
    # block 0x0042f864: entered by je at 0x0042f813, 3 instruction(s), falls into the block at 0x0042f878
    movsx eax, word ptr [ebp + arg_8]            # 0042f864
    imul eax, eax, 0x8d                          # 0042f868
    mov dword ptr [eax + 0x5bb632], 0x2          # 0042f86e
L_0042f878:
    # block 0x0042f878: entered by jmp at 0x0042f862, 1 instruction(s), ends with forward jump to 0x0042f8da
    jmp.d8 L_0042f8da                            # 0042f878
L_0042f87a:
    # block 0x0042f87a: entered by je at 0x0042f6f5, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x0042f8da (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f87a
    imul ecx, ecx, 0x8d                          # 0042f87e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f884
    movsx eax, word ptr [edx + field_5a1]        # 0042f88a
    mov dword ptr [ebp - local_c], eax           # 0042f891
    mov ecx, dword ptr [ebp - local_c]           # 0042f894
    push ecx                                     # 0042f897
    mov ecx, 0x5cf1eb                            # 0042f898
    call FUN_004f6334                            # 0042f89d
    test eax, eax                                # 0042f8a2
    jne.d8 L_0042f8da                            # 0042f8a4
    # block 0x0042f8a6: entered by fall-through of jne at 0x0042f8a4, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x0042f8da
    movsx edx, word ptr [ebp + arg_8]            # 0042f8a6
    imul edx, edx, 0x8d                          # 0042f8aa
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042f8b0
    add eax, 0x580                               # 0042f8b6
    push eax                                     # 0042f8bb
    mov ecx, 0x5c3a67                            # 0042f8bc
    call FUN_004fba69                            # 0042f8c1
    movsx ecx, word ptr [ebp + arg_8]            # 0042f8c6
    imul ecx, ecx, 0x8d                          # 0042f8ca
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0042f8d0
L_0042f8da:
    # block 0x0042f8da: entered by jmp at 0x0042f705; jmp at 0x0042f7e5; jmp at 0x0042f7ea; jmp at 0x0042f878; more, 1 instruction(s), ends with forward jump to 0x0042fc6a
    jmp.d32 L_0042fc6a                           # 0042f8da
L_0042f8df:
    # block 0x0042f8df: entered by je at 0x0042f53f, 15 instruction(s), calls FUN_004c2dfb, ends with je to 0x0042f950 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0042f8df
    mov byte ptr [0x5b615e], 0x0                 # 0042f8e9
    push 0x5d03db                                # 0042f8f0
    mov ecx, 0x5cf659                            # 0042f8f5
    call FUN_004c2dfb                            # 0042f8fa
    mov dword ptr [0x5d1bb7], 0x0                # 0042f8ff
    mov edi, 0x545c2c                            # 0042f909
    movsx edx, word ptr [ebp + arg_8]            # 0042f90e
    imul edx, edx, 0x8d                          # 0042f912
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0042f918
    add esi, 0x536                               # 0042f91e
    mov ecx, 0x9                                 # 0042f924
    {load} xor eax, eax                          # 0042f929
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042f92b
    je.d8 L_0042f950                             # 0042f92d
    # block 0x0042f92f: entered by fall-through of je at 0x0042f92d, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x0042f950
    movsx ecx, word ptr [ebp + arg_8]            # 0042f92f
    imul ecx, ecx, 0x8d                          # 0042f933
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f939
    add edx, 0x536                               # 0042f93f
    push edx                                     # 0042f945
    mov ecx, 0x5c3a67                            # 0042f946
    call FUN_004fba69                            # 0042f94b
L_0042f950:
    # block 0x0042f950: entered by je at 0x0042f92d, 4 instruction(s), ends with je to 0x0042fad8 (forward)
    {load} xor eax, eax                          # 0042f950
    mov al, byte ptr [0x5b6165]                  # 0042f952
    test eax, eax                                # 0042f957
    je.d32 L_0042fad8                            # 0042f959
    # block 0x0042f95f: entered by fall-through of je at 0x0042f959, 6 instruction(s), ends with je to 0x0042fa81 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f95f
    imul ecx, ecx, 0x8d                          # 0042f963
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f969
    movsx eax, word ptr [edx + field_5b1]        # 0042f96f
    cmp eax, 0x270f                              # 0042f976
    je.d32 L_0042fa81                            # 0042f97b
    # block 0x0042f981: entered by fall-through of je at 0x0042f97b, 41 instruction(s), ends with jne to 0x0042fa6d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f981
    imul ecx, ecx, 0x8d                          # 0042f985
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f98b
    movsx eax, word ptr [edx + field_5b1]        # 0042f991
    mov dword ptr [0x5bb57b], eax                # 0042f998
    movsx ecx, word ptr [ebp + arg_8]            # 0042f99d
    imul ecx, ecx, 0x8d                          # 0042f9a1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f9a7
    mov ax, word ptr [edx + field_5b3]           # 0042f9ad
    mov word ptr [0x5bb599], ax                  # 0042f9b4
    movsx ecx, word ptr [ebp + arg_8]            # 0042f9ba
    imul ecx, ecx, 0x8d                          # 0042f9be
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f9c4
    mov ax, word ptr [edx + field_5b5]           # 0042f9ca
    mov word ptr [0x5bb595], ax                  # 0042f9d1
    movsx ecx, word ptr [ebp + arg_8]            # 0042f9d7
    imul ecx, ecx, 0x8d                          # 0042f9db
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f9e1
    mov ax, word ptr [edx + field_5b7]           # 0042f9e7
    mov word ptr [0x5c39ff], ax                  # 0042f9ee
    movsx ecx, word ptr [ebp + arg_8]            # 0042f9f4
    imul ecx, ecx, 0x8d                          # 0042f9f8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f9fe
    mov eax, dword ptr [edx + field_5b9]         # 0042fa04
    mov dword ptr [0x5bb59b], eax                # 0042fa0a
    movsx ecx, word ptr [ebp + arg_8]            # 0042fa0f
    imul ecx, ecx, 0x8d                          # 0042fa13
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042fa19
    mov eax, dword ptr [edx + field_5bd]         # 0042fa1f
    mov dword ptr [0x5bb59f], eax                # 0042fa25
    movsx ecx, word ptr [ebp + arg_8]            # 0042fa2a
    imul ecx, ecx, 0x8d                          # 0042fa2e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042fa34
    mov eax, dword ptr [edx + field_5c1]         # 0042fa3a
    mov dword ptr [0x5bb5a3], eax                # 0042fa40
    movsx ecx, word ptr [ebp + arg_8]            # 0042fa45
    imul ecx, ecx, 0x8d                          # 0042fa49
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042fa4f
    movsx eax, word ptr [edx + field_5c5]        # 0042fa55
    cmp eax, 0x1                                 # 0042fa5c
    jne.d8 L_0042fa6d                            # 0042fa5f
    # block 0x0042fa61: entered by fall-through of jne at 0x0042fa5f, 2 instruction(s), ends with forward jump to 0x0042fa77
    mov dword ptr [0x5bb1ca], 0x0                # 0042fa61
    jmp.d8 L_0042fa77                            # 0042fa6b
L_0042fa6d:
    # block 0x0042fa6d: entered by jne at 0x0042fa5f, 1 instruction(s), falls into the block at 0x0042fa77
    mov dword ptr [0x5bb1ca], 0x1                # 0042fa6d
L_0042fa77:
    # block 0x0042fa77: entered by jmp at 0x0042fa6b, 1 instruction(s), falls into the block at 0x0042fa81
    mov dword ptr [0x583999], 0x4                # 0042fa77
L_0042fa81:
    # block 0x0042fa81: entered by je at 0x0042f97b, 6 instruction(s), ends with je to 0x0042fad3 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042fa81
    imul ecx, ecx, 0x8d                          # 0042fa85
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042fa8b
    movsx eax, word ptr [edx + field_5c7]        # 0042fa91
    cmp eax, -0x1                                # 0042fa98
    je.d8 L_0042fad3                             # 0042fa9b
    # block 0x0042fa9d: entered by fall-through of je at 0x0042fa9b, 10 instruction(s), falls into the block at 0x0042fad3
    movsx ecx, word ptr [ebp + arg_8]            # 0042fa9d
    imul ecx, ecx, 0x8d                          # 0042faa1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042faa7
    {load} xor eax, eax                          # 0042faad
    mov al, byte ptr [edx + field_5c9]           # 0042faaf
    movsx ecx, word ptr [ebp + arg_8]            # 0042fab5
    imul ecx, ecx, 0x8d                          # 0042fab9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042fabf
    movsx ecx, word ptr [edx + field_5c7]        # 0042fac5
    mov dword ptr [4*ecx + 0x585801], eax        # 0042facc
L_0042fad3:
    # block 0x0042fad3: entered by je at 0x0042fa9b, 1 instruction(s), ends with forward jump to 0x0042fc5d
    jmp.d32 L_0042fc5d                           # 0042fad3
L_0042fad8:
    # block 0x0042fad8: entered by je at 0x0042f959, 7 instruction(s), ends with je to 0x0042fc0b (forward)
    mov word ptr [0x591990], 0x0                 # 0042fad8
    movsx edx, word ptr [ebp + arg_8]            # 0042fae1
    imul edx, edx, 0x8d                          # 0042fae5
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042faeb
    movsx ecx, word ptr [eax + field_567]        # 0042faf1
    cmp ecx, 0x270f                              # 0042faf8
    je.d32 L_0042fc0b                            # 0042fafe
    # block 0x0042fb04: entered by fall-through of je at 0x0042fafe, 41 instruction(s), ends with jne to 0x0042fbf7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042fb04
    imul edx, edx, 0x8d                          # 0042fb08
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fb0e
    movsx ecx, word ptr [eax + field_567]        # 0042fb14
    mov dword ptr [0x5bb57b], ecx                # 0042fb1b
    movsx edx, word ptr [ebp + arg_8]            # 0042fb21
    imul edx, edx, 0x8d                          # 0042fb25
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fb2b
    mov cx, word ptr [eax + field_569]           # 0042fb31
    mov word ptr [0x5bb599], cx                  # 0042fb38
    movsx edx, word ptr [ebp + arg_8]            # 0042fb3f
    imul edx, edx, 0x8d                          # 0042fb43
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fb49
    mov cx, word ptr [eax + field_56b]           # 0042fb4f
    mov word ptr [0x5bb595], cx                  # 0042fb56
    movsx edx, word ptr [ebp + arg_8]            # 0042fb5d
    imul edx, edx, 0x8d                          # 0042fb61
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fb67
    mov cx, word ptr [eax + field_56d]           # 0042fb6d
    mov word ptr [0x5c39ff], cx                  # 0042fb74
    movsx edx, word ptr [ebp + arg_8]            # 0042fb7b
    imul edx, edx, 0x8d                          # 0042fb7f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fb85
    mov ecx, dword ptr [eax + field_56f]         # 0042fb8b
    mov dword ptr [0x5bb59b], ecx                # 0042fb91
    movsx edx, word ptr [ebp + arg_8]            # 0042fb97
    imul edx, edx, 0x8d                          # 0042fb9b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fba1
    mov ecx, dword ptr [eax + field_573]         # 0042fba7
    mov dword ptr [0x5bb59f], ecx                # 0042fbad
    movsx edx, word ptr [ebp + arg_8]            # 0042fbb3
    imul edx, edx, 0x8d                          # 0042fbb7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fbbd
    mov ecx, dword ptr [eax + field_577]         # 0042fbc3
    mov dword ptr [0x5bb5a3], ecx                # 0042fbc9
    movsx edx, word ptr [ebp + arg_8]            # 0042fbcf
    imul edx, edx, 0x8d                          # 0042fbd3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fbd9
    movsx ecx, word ptr [eax + field_57b]        # 0042fbdf
    cmp ecx, 0x1                                 # 0042fbe6
    jne.d8 L_0042fbf7                            # 0042fbe9
    # block 0x0042fbeb: entered by fall-through of jne at 0x0042fbe9, 2 instruction(s), ends with forward jump to 0x0042fc01
    mov dword ptr [0x5bb1ca], 0x0                # 0042fbeb
    jmp.d8 L_0042fc01                            # 0042fbf5
L_0042fbf7:
    # block 0x0042fbf7: entered by jne at 0x0042fbe9, 1 instruction(s), falls into the block at 0x0042fc01
    mov dword ptr [0x5bb1ca], 0x1                # 0042fbf7
L_0042fc01:
    # block 0x0042fc01: entered by jmp at 0x0042fbf5, 1 instruction(s), falls into the block at 0x0042fc0b
    mov dword ptr [0x583999], 0x4                # 0042fc01
L_0042fc0b:
    # block 0x0042fc0b: entered by je at 0x0042fafe, 6 instruction(s), ends with je to 0x0042fc5d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042fc0b
    imul edx, edx, 0x8d                          # 0042fc0f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fc15
    movsx ecx, word ptr [eax + field_57d]        # 0042fc1b
    cmp ecx, -0x1                                # 0042fc22
    je.d8 L_0042fc5d                             # 0042fc25
    # block 0x0042fc27: entered by fall-through of je at 0x0042fc25, 10 instruction(s), falls into the block at 0x0042fc5d
    movsx edx, word ptr [ebp + arg_8]            # 0042fc27
    imul edx, edx, 0x8d                          # 0042fc2b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fc31
    {load} xor ecx, ecx                          # 0042fc37
    mov cl, byte ptr [eax + field_57f]           # 0042fc39
    movsx edx, word ptr [ebp + arg_8]            # 0042fc3f
    imul edx, edx, 0x8d                          # 0042fc43
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042fc49
    movsx edx, word ptr [eax + field_57d]        # 0042fc4f
    mov dword ptr [4*edx + 0x585801], ecx        # 0042fc56
L_0042fc5d:
    # block 0x0042fc5d: entered by jmp at 0x0042fad3; je at 0x0042fc25, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042fc6a
    mov ax, word ptr [ebp + arg_8]               # 0042fc5d
    push eax                                     # 0042fc61
    call FUN_0042ba3a                            # 0042fc62
    add esp, 0x4                                 # 0042fc67
L_0042fc6a:
    # block 0x0042fc6a: entered by jmp at 0x0042f545; jmp at 0x0042f6de; jmp at 0x0042f8da, 5 instruction(s), ends with ret
    pop edi                                      # 0042fc6a
    pop esi                                      # 0042fc6b
    {load} mov esp, ebp                          # 0042fc6c
    pop ebp                                      # 0042fc6e
    ret                                          # 0042fc6f

