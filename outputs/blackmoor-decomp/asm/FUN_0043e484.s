# FUN_0043e484
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043e484
# extent:       0x0043e484-0x0043e6e8 (612 code bytes)
# span:         0x0043e484-0x0043e776 (code 612, tables 142, padding 0)
# sha256:       daa9bd1371a4c459032816779346b44eadd7f7f10c32f4cf3a1857a6428520d6
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043e484
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041db40, FUN_0051dc6c, FUN_00423b51, FUN_0050ca3e, FUN_0044a2b7, FUN_004234b5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 136 instruction(s), 10 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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

# --- external targets -----------------------------------------------
.set FUN_0041db40, .text + (0x0041db40 - 0x401000)
.set FUN_004234b5, .text + (0x004234b5 - 0x401000)
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043e484 - 0x401000
.globl FUN_0043e484
FUN_0043e484:
    # block 0x0043e484: entry, 5 instruction(s), ends with forward jump to 0x0043e49c
    push ebp                                     # 0043e484
    {load} mov ebp, esp                          # 0043e485
    sub esp, 0x18                                # 0043e487
    mov dword ptr [ebp - local_8], 0x0           # 0043e48a
    jmp.d8 L_0043e49c                            # 0043e491
L_0043e493:
    # block 0x0043e493: entered by jmp at 0x0043e6d5, 3 instruction(s), falls into the block at 0x0043e49c
    mov eax, dword ptr [ebp - local_8]           # 0043e493
    add eax, 0x1                                 # 0043e496
    mov dword ptr [ebp - local_8], eax           # 0043e499
L_0043e49c:
    # block 0x0043e49c: entered by jmp at 0x0043e491, 3 instruction(s), ends with jge to 0x0043e6da (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0043e49c
    cmp dword ptr [ebp - local_8], ecx           # 0043e4a3
    jge.d32 L_0043e6da                           # 0043e4a6
    # block 0x0043e4ac: entered by fall-through of jge at 0x0043e4a6, 11 instruction(s), ends with ja to 0x0043e611 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 0043e4ac
    mov edx, dword ptr [ebp - local_8]           # 0043e4b3
    imul edx, edx, 0x8d                          # 0043e4b6
    {load} xor eax, eax                          # 0043e4bc
    mov al, byte ptr [edx + 0x5bb5e3]            # 0043e4be
    mov dword ptr [ebp - local_18], eax          # 0043e4c4
    mov ecx, dword ptr [ebp - local_18]          # 0043e4c7
    sub ecx, 0xa                                 # 0043e4ca
    mov dword ptr [ebp - local_18], ecx          # 0043e4cd
    cmp dword ptr [ebp - local_18], 0x79         # 0043e4d0
    ja.d32 L_0043e611                            # 0043e4d4
    # block 0x0043e4da: entered by fall-through of ja at 0x0043e4d4, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x43e6e8]
    mov eax, dword ptr [ebp - local_18]          # 0043e4da
    {load} xor edx, edx                          # 0043e4dd
    mov dl, byte ptr [eax + IDXTAB_0043e6fc_VA]  # 0043e4df
    jmp dword ptr [4*edx + SWTAB_0043e6e8_VA]    # 0043e4e5
L_0043e4ec:
    # block 0x0043e4ec: entered by switch case, 6 instruction(s), ends with jne to 0x0043e510 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0043e4ec
    imul ecx, ecx, 0x8d                          # 0043e4ef
    {load} xor edx, edx                          # 0043e4f5
    mov dl, byte ptr [ecx + 0x5bb625]            # 0043e4f7
    test edx, edx                                # 0043e4fd
    jne.d8 L_0043e510                            # 0043e4ff
    # block 0x0043e501: entered by fall-through of jne at 0x0043e4ff, 4 instruction(s), calls FUN_0041db40, falls into the block at 0x0043e510
    mov ax, word ptr [ebp - local_8]             # 0043e501
    push eax                                     # 0043e505
    mov ecx, 0x6177e8                            # 0043e506
    call FUN_0041db40                            # 0043e50b
L_0043e510:
    # block 0x0043e510: entered by jne at 0x0043e4ff, 2 instruction(s), ends with forward jump to 0x0043e611
    mov dword ptr [ebp - local_4], 0x1           # 0043e510
    jmp.d32 L_0043e611                           # 0043e517
L_0043e51c:
    # block 0x0043e51c: entered by switch case, 4 instruction(s), ends with je to 0x0043e55f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0043e51c
    imul ecx, ecx, 0x8d                          # 0043e51f
    cmp dword ptr [ecx + 0x5bb5e5], 0x0          # 0043e525
    je.d8 L_0043e55f                             # 0043e52c
    # block 0x0043e52e: entered by fall-through of je at 0x0043e52c, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e55f
    mov edx, dword ptr [ebp - local_8]           # 0043e52e
    imul edx, edx, 0x8d                          # 0043e531
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043e537
    mov dword ptr [ebp - local_c], eax           # 0043e53d
    mov ecx, dword ptr [ebp - local_c]           # 0043e540
    push ecx                                     # 0043e543
    call FUN_0051dc6c                            # 0043e544
    add esp, 0x4                                 # 0043e549
    mov edx, dword ptr [ebp - local_8]           # 0043e54c
    imul edx, edx, 0x8d                          # 0043e54f
    mov dword ptr [edx + 0x5bb5e5], 0x0          # 0043e555
L_0043e55f:
    # block 0x0043e55f: entered by je at 0x0043e52c, 2 instruction(s), ends with forward jump to 0x0043e611
    mov dword ptr [ebp - local_4], 0x1           # 0043e55f
    jmp.d32 L_0043e611                           # 0043e566
L_0043e56b:
    # block 0x0043e56b: entered by switch case, 2 instruction(s), ends with jne to 0x0043e5be (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 0043e56b
    jne.d8 L_0043e5be                            # 0043e572
    # block 0x0043e574: entered by fall-through of jne at 0x0043e572, 4 instruction(s), ends with je to 0x0043e5b7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0043e574
    imul eax, eax, 0x8d                          # 0043e577
    cmp dword ptr [eax + 0x5bb5e5], 0x0          # 0043e57d
    je.d8 L_0043e5b7                             # 0043e584
    # block 0x0043e586: entered by fall-through of je at 0x0043e584, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e5b7
    mov ecx, dword ptr [ebp - local_8]           # 0043e586
    imul ecx, ecx, 0x8d                          # 0043e589
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043e58f
    mov dword ptr [ebp - local_10], edx          # 0043e595
    mov eax, dword ptr [ebp - local_10]          # 0043e598
    push eax                                     # 0043e59b
    call FUN_0051dc6c                            # 0043e59c
    add esp, 0x4                                 # 0043e5a1
    mov ecx, dword ptr [ebp - local_8]           # 0043e5a4
    imul ecx, ecx, 0x8d                          # 0043e5a7
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 0043e5ad
L_0043e5b7:
    # block 0x0043e5b7: entered by je at 0x0043e584, 1 instruction(s), falls into the block at 0x0043e5be
    mov dword ptr [ebp - local_4], 0x1           # 0043e5b7
L_0043e5be:
    # block 0x0043e5be: entered by jne at 0x0043e572; switch case, 2 instruction(s), ends with je to 0x0043e611 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 0043e5be
    je.d8 L_0043e611                             # 0043e5c5
    # block 0x0043e5c7: entered by fall-through of je at 0x0043e5c5, 4 instruction(s), ends with je to 0x0043e60a (forward)
    mov edx, dword ptr [ebp - local_8]           # 0043e5c7
    imul edx, edx, 0x8d                          # 0043e5ca
    cmp dword ptr [edx + 0x5bb5e5], 0x0          # 0043e5d0
    je.d8 L_0043e60a                             # 0043e5d7
    # block 0x0043e5d9: entered by fall-through of je at 0x0043e5d7, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e60a
    mov eax, dword ptr [ebp - local_8]           # 0043e5d9
    imul eax, eax, 0x8d                          # 0043e5dc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043e5e2
    mov dword ptr [ebp - local_14], ecx          # 0043e5e8
    mov edx, dword ptr [ebp - local_14]          # 0043e5eb
    push edx                                     # 0043e5ee
    call FUN_0051dc6c                            # 0043e5ef
    add esp, 0x4                                 # 0043e5f4
    mov eax, dword ptr [ebp - local_8]           # 0043e5f7
    imul eax, eax, 0x8d                          # 0043e5fa
    mov dword ptr [eax + 0x5bb5e5], 0x0          # 0043e600
L_0043e60a:
    # block 0x0043e60a: entered by je at 0x0043e5d7, 1 instruction(s), falls into the block at 0x0043e611
    mov dword ptr [ebp - local_4], 0x1           # 0043e60a
L_0043e611:
    # block 0x0043e611: entered by ja at 0x0043e4d4; jmp at 0x0043e517; jmp at 0x0043e566; je at 0x0043e5c5; switch case, 2 instruction(s), ends with je to 0x0043e6d5 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0043e611
    je.d32 L_0043e6d5                            # 0043e615
    # block 0x0043e61b: entered by fall-through of je at 0x0043e615, 28 instruction(s), calls FUN_00423b51, ends with je to 0x0043e6d5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0043e61b
    imul ecx, ecx, 0x8d                          # 0043e61e
    mov byte ptr [ecx + 0x5bb5e3], 0x0           # 0043e624
    mov edx, dword ptr [ebp - local_8]           # 0043e62b
    imul edx, edx, 0x8d                          # 0043e62e
    mov byte ptr [edx + 0x5bb625], 0x0           # 0043e634
    mov eax, dword ptr [ebp - local_8]           # 0043e63b
    imul eax, eax, 0x8d                          # 0043e63e
    mov dword ptr [eax + 0x5bb626], 0x0          # 0043e644
    mov ecx, dword ptr [ebp - local_8]           # 0043e64e
    imul ecx, ecx, 0x8d                          # 0043e651
    mov dword ptr [ecx + 0x5bb632], 0x0          # 0043e657
    mov edx, dword ptr [ebp - local_8]           # 0043e661
    imul edx, edx, 0x8d                          # 0043e664
    mov word ptr [edx + 0x5bb636], 0xffff        # 0043e66a
    mov eax, dword ptr [ebp - local_8]           # 0043e673
    imul eax, eax, 0x8d                          # 0043e676
    mov dword ptr [eax + 0x5bb638], 0x1          # 0043e67c
    mov ecx, dword ptr [ebp - local_8]           # 0043e686
    imul ecx, ecx, 0x8d                          # 0043e689
    mov dword ptr [ecx + 0x5bb63c], 0x0          # 0043e68f
    mov edx, dword ptr [ebp - local_8]           # 0043e699
    push edx                                     # 0043e69c
    mov ecx, 0x63786d                            # 0043e69d
    call FUN_00423b51                            # 0043e6a2
    movsx eax, word ptr [0x63a4cd]               # 0043e6a7
    test eax, eax                                # 0043e6ae
    je.d8 L_0043e6d5                             # 0043e6b0
    # block 0x0043e6b2: entered by fall-through of je at 0x0043e6b0, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0043e6d5
    mov ecx, dword ptr [ebp - local_8]           # 0043e6b2
    push ecx                                     # 0043e6b5
    push 0x547674                                # 0043e6b6
    push 0x63888b                                # 0043e6bb
    call FUN_0050ca3e                            # 0043e6c0
    add esp, 0xc                                 # 0043e6c5
    push 0x63888b                                # 0043e6c8
    call FUN_0044a2b7                            # 0043e6cd
    add esp, 0x4                                 # 0043e6d2
L_0043e6d5:
    # block 0x0043e6d5: entered by je at 0x0043e615; je at 0x0043e6b0, 1 instruction(s), ends with backward jump to 0x0043e493
    jmp.d32 L_0043e493                           # 0043e6d5
L_0043e6da:
    # block 0x0043e6da: entered by jge at 0x0043e4a6, 5 instruction(s), calls FUN_004234b5, ends with ret
    mov ecx, 0x63786d                            # 0043e6da
    call FUN_004234b5                            # 0043e6df
    {load} mov esp, ebp                          # 0043e6e4
    pop ebp                                      # 0043e6e6
    ret                                          # 0043e6e7

# --- data items (not part of the function) -------------------------
.org 0x0043e6e8 - 0x401000
SWTAB_0043e6e8:  # 5 case address(es)
    .long L_0043e56b - .text + 0x401000
    .long L_0043e51c - .text + 0x401000
    .long L_0043e4ec - .text + 0x401000
    .long L_0043e5be - .text + 0x401000
    .long L_0043e611 - .text + 0x401000
.org 0x0043e6fc - 0x401000
IDXTAB_0043e6fc:  # index table of FUN_0043e484 for the switch jump at 0x0043e4e5 (122 byte(s))
    .byte 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2
    .byte 2, 2, 2, 4, 2, 2, 4, 4, 4, 4, 4, 4, 4, 1, 4, 4
    .byte 4, 3, 3, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
    .byte 4, 4, 4, 4, 4, 4, 4, 1, 1, 1
.set SWTAB_0043e6e8_VA, SWTAB_0043e6e8 - .text + 0x401000
.set IDXTAB_0043e6fc_VA, IDXTAB_0043e6fc - .text + 0x401000

