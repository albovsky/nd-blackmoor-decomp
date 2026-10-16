# FUN_0046f4b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f4b0
# extent:       0x0046f4b0-0x0046f6c5 (533 code bytes)
# span:         0x0046f4b0-0x0046f6c5 (code 533, tables 0, padding 0)
# sha256:       1e68663bd24bd4b8d7a7b59104f9c40a16028e5e91cbcda8b1736c9da60b01e7
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046f4b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1e, field_5b, field_91, field_ca, field_172, field_cb4; [ecx + n] field_10, field_23, field_53, field_5b, field_91, field_a7, field_ca, field_cb, field_170; [edx + n] field_21, field_5b, field_91, field_a5, field_a7, field_c8, field_172
# callees:      calls FUN_0046f8ae, FUN_0046f6c5, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 145 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_53, 0x53  # offset +0x53
.equ field_5b, 0x5b  # offset +0x5b
.equ field_91, 0x91  # offset +0x91
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a7, 0xa7  # offset +0xa7
.equ field_c8, 0xc8  # offset +0xc8
.equ field_ca, 0xca  # offset +0xca
.equ field_cb, 0xcb  # offset +0xcb
.equ field_170, 0x170  # offset +0x170
.equ field_172, 0x172  # offset +0x172
.equ field_cb4, 0xcb4  # offset +0xcb4

# --- external targets -----------------------------------------------
.set FUN_0046f6c5, .text + (0x0046f6c5 - 0x401000)
.set FUN_0046f8ae, .text + (0x0046f8ae - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0046f4b0 - 0x401000
.globl FUN_0046f4b0
FUN_0046f4b0:
    # block 0x0046f4b0: entry, 14 instruction(s), ends with forward jump to 0x0046f4f2
    push ebp                                     # 0046f4b0
    {load} mov ebp, esp                          # 0046f4b1
    sub esp, 0x18                                # 0046f4b3
    mov dword ptr [ebp - local_18], ecx          # 0046f4b6
    mov dword ptr [ebp - local_14], 0xffffffff   # 0046f4b9
    mov eax, dword ptr [ebp - local_18]          # 0046f4c0
    movsx ecx, word ptr [eax + field_1e]         # 0046f4c3
    imul ecx, ecx, 0x8d                          # 0046f4c7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046f4cd
    mov dword ptr [ebp - local_10], edx          # 0046f4d3
    mov eax, dword ptr [ebp - local_18]          # 0046f4d6
    mov dword ptr [eax + field_5b], 0x1          # 0046f4d9
    mov dword ptr [ebp - local_8], 0x0           # 0046f4e0
    jmp.d8 L_0046f4f2                            # 0046f4e7
L_0046f4e9:
    # block 0x0046f4e9: entered by jmp at 0x0046f527, 3 instruction(s), falls into the block at 0x0046f4f2
    mov ecx, dword ptr [ebp - local_8]           # 0046f4e9
    add ecx, 0x1                                 # 0046f4ec
    mov dword ptr [ebp - local_8], ecx           # 0046f4ef
L_0046f4f2:
    # block 0x0046f4f2: entered by jmp at 0x0046f4e7, 4 instruction(s), ends with jge to 0x0046f529 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f4f2
    movsx eax, word ptr [edx + field_21]         # 0046f4f5
    cmp dword ptr [ebp - local_8], eax           # 0046f4f9
    jge.d8 L_0046f529                            # 0046f4fc
    # block 0x0046f4fe: entered by fall-through of jge at 0x0046f4fc, 9 instruction(s), ends with je to 0x0046f527 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0046f4fe
    add ecx, dword ptr [ebp - local_8]           # 0046f501
    {load} xor edx, edx                          # 0046f504
    mov dl, byte ptr [ecx + field_53]            # 0046f506
    mov eax, dword ptr [ebp - local_8]           # 0046f509
    mov ecx, dword ptr [ebp - local_10]          # 0046f50c
    movsx eax, word ptr [ecx + 2*eax + field_cb] # 0046f50f
    {load} cmp edx, eax                          # 0046f517
    je.d8 L_0046f527                             # 0046f519
    # block 0x0046f51b: entered by fall-through of je at 0x0046f519, 3 instruction(s), ends with forward jump to 0x0046f529
    mov ecx, dword ptr [ebp - local_18]          # 0046f51b
    mov dword ptr [ecx + field_5b], 0x0          # 0046f51e
    jmp.d8 L_0046f529                            # 0046f525
L_0046f527:
    # block 0x0046f527: entered by je at 0x0046f519, 1 instruction(s), ends with backward jump to 0x0046f4e9
    jmp.d8 L_0046f4e9                            # 0046f527
L_0046f529:
    # block 0x0046f529: entered by jge at 0x0046f4fc; jmp at 0x0046f525, 3 instruction(s), ends with je to 0x0046f574 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0046f529
    cmp dword ptr [edx + field_5b], 0x0          # 0046f52c
    je.d8 L_0046f574                             # 0046f530
    # block 0x0046f532: entered by fall-through of je at 0x0046f530, 5 instruction(s), ends with je to 0x0046f55e (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046f532
    {load} xor ecx, ecx                          # 0046f535
    mov cl, byte ptr [eax + field_172]           # 0046f537
    cmp ecx, -0x1                                # 0046f53d
    je.d8 L_0046f55e                             # 0046f540
    # block 0x0046f542: entered by fall-through of je at 0x0046f540, 6 instruction(s), falls into the block at 0x0046f55e
    mov edx, dword ptr [ebp - local_10]          # 0046f542
    {load} xor eax, eax                          # 0046f545
    mov al, byte ptr [edx + field_172]           # 0046f547
    mov ecx, dword ptr [ebp - local_10]          # 0046f54d
    movsx edx, word ptr [ecx + field_170]        # 0046f550
    mov dword ptr [4*edx + 0x585801], eax        # 0046f557
L_0046f55e:
    # block 0x0046f55e: entered by je at 0x0046f540, 6 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0046f6c1
    mov eax, dword ptr [ebp - local_10]          # 0046f55e
    add eax, 0xdb                                # 0046f561
    push eax                                     # 0046f566
    mov ecx, dword ptr [ebp - local_18]          # 0046f567
    call FUN_0046f8ae                            # 0046f56a
    jmp.d32 L_0046f6c1                           # 0046f56f
L_0046f574:
    # block 0x0046f574: entered by je at 0x0046f530, 3 instruction(s), ends with forward jump to 0x0046f58d
    mov dword ptr [ebp - local_4], 0x1           # 0046f574
    mov dword ptr [ebp - local_8], 0x0           # 0046f57b
    jmp.d8 L_0046f58d                            # 0046f582
L_0046f584:
    # block 0x0046f584: entered by jmp at 0x0046f5bc, 3 instruction(s), falls into the block at 0x0046f58d
    mov ecx, dword ptr [ebp - local_8]           # 0046f584
    add ecx, 0x1                                 # 0046f587
    mov dword ptr [ebp - local_8], ecx           # 0046f58a
L_0046f58d:
    # block 0x0046f58d: entered by jmp at 0x0046f582, 4 instruction(s), ends with jge to 0x0046f5be (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046f58d
    movsx eax, word ptr [edx + field_21]         # 0046f590
    cmp dword ptr [ebp - local_8], eax           # 0046f594
    jge.d8 L_0046f5be                            # 0046f597
    # block 0x0046f599: entered by fall-through of jge at 0x0046f597, 9 instruction(s), ends with je to 0x0046f5bc (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0046f599
    add ecx, dword ptr [ebp - local_8]           # 0046f59c
    {load} xor edx, edx                          # 0046f59f
    mov dl, byte ptr [ecx + field_53]            # 0046f5a1
    mov eax, dword ptr [ebp - local_8]           # 0046f5a4
    mov ecx, dword ptr [ebp - local_10]          # 0046f5a7
    movsx eax, word ptr [ecx + 2*eax + field_23] # 0046f5aa
    {load} cmp edx, eax                          # 0046f5af
    je.d8 L_0046f5bc                             # 0046f5b1
    # block 0x0046f5b3: entered by fall-through of je at 0x0046f5b1, 2 instruction(s), ends with forward jump to 0x0046f5be
    mov dword ptr [ebp - local_4], 0x0           # 0046f5b3
    jmp.d8 L_0046f5be                            # 0046f5ba
L_0046f5bc:
    # block 0x0046f5bc: entered by je at 0x0046f5b1, 1 instruction(s), ends with backward jump to 0x0046f584
    jmp.d8 L_0046f584                            # 0046f5bc
L_0046f5be:
    # block 0x0046f5be: entered by jge at 0x0046f597; jmp at 0x0046f5ba, 2 instruction(s), ends with je to 0x0046f604 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0046f5be
    je.d8 L_0046f604                             # 0046f5c2
    # block 0x0046f5c4: entered by fall-through of je at 0x0046f5c2, 5 instruction(s), ends with je to 0x0046f5f0 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046f5c4
    {load} xor edx, edx                          # 0046f5c7
    mov dl, byte ptr [ecx + field_ca]            # 0046f5c9
    cmp edx, -0x1                                # 0046f5cf
    je.d8 L_0046f5f0                             # 0046f5d2
    # block 0x0046f5d4: entered by fall-through of je at 0x0046f5d2, 6 instruction(s), falls into the block at 0x0046f5f0
    mov eax, dword ptr [ebp - local_10]          # 0046f5d4
    {load} xor ecx, ecx                          # 0046f5d7
    mov cl, byte ptr [eax + field_ca]            # 0046f5d9
    mov edx, dword ptr [ebp - local_10]          # 0046f5df
    movsx eax, word ptr [edx + field_c8]         # 0046f5e2
    mov dword ptr [4*eax + 0x585801], ecx        # 0046f5e9
L_0046f5f0:
    # block 0x0046f5f0: entered by je at 0x0046f5d2, 6 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0046f6c1
    mov ecx, dword ptr [ebp - local_10]          # 0046f5f0
    add ecx, 0x33                                # 0046f5f3
    push ecx                                     # 0046f5f6
    mov ecx, dword ptr [ebp - local_18]          # 0046f5f7
    call FUN_0046f8ae                            # 0046f5fa
    jmp.d32 L_0046f6c1                           # 0046f5ff
L_0046f604:
    # block 0x0046f604: entered by je at 0x0046f5c2, 6 instruction(s), calls FUN_0046f6c5, ends with jl to 0x0046f695 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0046f604
    call FUN_0046f6c5                            # 0046f607
    movsx edx, ax                                # 0046f60c
    mov dword ptr [ebp - local_14], edx          # 0046f60f
    cmp dword ptr [ebp - local_14], 0x0          # 0046f612
    jl.d8 L_0046f695                             # 0046f616
    # block 0x0046f618: entered by fall-through of jl at 0x0046f616, 8 instruction(s), ends with je to 0x0046f674 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046f618
    imul eax, eax, 0xa8                          # 0046f61b
    mov ecx, dword ptr [ebp - local_18]          # 0046f621
    mov edx, dword ptr [ecx + field_91]          # 0046f624
    {load} xor ecx, ecx                          # 0046f62a
    mov cl, byte ptr [edx + eax + field_a7]      # 0046f62c
    cmp ecx, -0x1                                # 0046f633
    je.d8 L_0046f674                             # 0046f636
    # block 0x0046f638: entered by fall-through of je at 0x0046f636, 12 instruction(s), falls into the block at 0x0046f674
    mov edx, dword ptr [ebp - local_14]          # 0046f638
    imul edx, edx, 0xa8                          # 0046f63b
    mov eax, dword ptr [ebp - local_18]          # 0046f641
    mov ecx, dword ptr [eax + field_91]          # 0046f644
    {load} xor eax, eax                          # 0046f64a
    mov al, byte ptr [ecx + edx + field_a7]      # 0046f64c
    mov ecx, dword ptr [ebp - local_14]          # 0046f653
    imul ecx, ecx, 0xa8                          # 0046f656
    mov edx, dword ptr [ebp - local_18]          # 0046f65c
    mov edx, dword ptr [edx + field_91]          # 0046f65f
    movsx ecx, word ptr [edx + ecx + field_a5]   # 0046f665
    mov dword ptr [4*ecx + 0x585801], eax        # 0046f66d
L_0046f674:
    # block 0x0046f674: entered by je at 0x0046f636, 9 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0046f6c1
    mov edx, dword ptr [ebp - local_14]          # 0046f674
    imul edx, edx, 0xa8                          # 0046f677
    mov eax, dword ptr [ebp - local_18]          # 0046f67d
    mov ecx, dword ptr [eax + field_91]          # 0046f680
    lea edx, [ecx + edx + field_10]              # 0046f686
    push edx                                     # 0046f68a
    mov ecx, dword ptr [ebp - local_18]          # 0046f68b
    call FUN_0046f8ae                            # 0046f68e
    jmp.d8 L_0046f6c1                            # 0046f693
L_0046f695:
    # block 0x0046f695: entered by jl at 0x0046f616, 12 instruction(s), calls FUN_0050cd50, FUN_0046f8ae, falls into the block at 0x0046f6c1
    call FUN_0050cd50                            # 0046f695
    cdq                                          # 0046f69a
    mov ecx, 0x3                                 # 0046f69b
    idiv ecx                                     # 0046f6a0
    mov dword ptr [ebp - local_c], edx           # 0046f6a2
    mov edx, dword ptr [ebp - local_c]           # 0046f6a5
    imul edx, edx, 0x95                          # 0046f6a8
    mov eax, dword ptr [ebp - local_10]          # 0046f6ae
    lea ecx, [eax + edx + field_cb4]             # 0046f6b1
    push ecx                                     # 0046f6b8
    mov ecx, dword ptr [ebp - local_18]          # 0046f6b9
    call FUN_0046f8ae                            # 0046f6bc
L_0046f6c1:
    # block 0x0046f6c1: entered by jmp at 0x0046f56f; jmp at 0x0046f5ff; jmp at 0x0046f693, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046f6c1
    pop ebp                                      # 0046f6c3
    ret                                          # 0046f6c4

