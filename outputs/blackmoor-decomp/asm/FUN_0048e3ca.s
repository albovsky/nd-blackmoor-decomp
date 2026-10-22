# FUN_0048e3ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e3ca
# extent:       0x0048e3ca-0x0048e628 (606 code bytes)
# span:         0x0048e3ca-0x0048e628 (code 606, tables 0, padding 0)
# sha256:       d720b605a1ee6e911f408e7558aeb67d0a4ac58d90472c6c7495684fb9b008f6
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e3ca
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_164; [ecx + n] field_b0, field_100, field_123, field_164; [edi + n] field_minus_1; [edx + n] field_b0, field_123, field_141, field_164
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_00423259, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_b0, 0xb0  # offset +0xb0
.equ field_100, 0x100  # offset +0x100
.equ field_123, 0x123  # offset +0x123
.equ field_141, 0x141  # offset +0x141
.equ field_164, 0x164  # offset +0x164

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048e3ca - 0x401000
.globl FUN_0048e3ca
FUN_0048e3ca:
    # block 0x0048e3ca: entry, 27 instruction(s), calls FUN_0051dc43, ends with jne to 0x0048e45c (forward)
    push ebp                                     # 0048e3ca
    {load} mov ebp, esp                          # 0048e3cb
    sub esp, 0x18                                # 0048e3cd
    push esi                                     # 0048e3d0
    push edi                                     # 0048e3d1
    mov dword ptr [ebp - local_18], ecx          # 0048e3d2
    mov eax, dword ptr [ebp + arg_c]             # 0048e3d5
    mov ecx, dword ptr [eax]                     # 0048e3d8
    mov dword ptr [ebp - local_c], ecx           # 0048e3da
    mov edx, dword ptr [ebp - local_c]           # 0048e3dd
    movsx eax, word ptr [edx + field_b0]         # 0048e3e0
    mov ecx, 0x1e                                # 0048e3e7
    {load} sub ecx, eax                          # 0048e3ec
    imul ecx, ecx, 0xd0                          # 0048e3ee
    mov edx, 0x1912                              # 0048e3f4
    {load} sub edx, ecx                          # 0048e3f9
    mov word ptr [ebp - local_10], dx            # 0048e3fb
    movsx eax, word ptr [ebp - local_10]         # 0048e3ff
    push eax                                     # 0048e403
    call FUN_0051dc43                            # 0048e404
    add esp, 0x4                                 # 0048e409
    mov dword ptr [ebp - local_14], eax          # 0048e40c
    mov ecx, dword ptr [ebp + arg_8]             # 0048e40f
    mov edx, dword ptr [ebp - local_14]          # 0048e412
    mov dword ptr [ecx], edx                     # 0048e415
    cmp dword ptr [ebp - local_14], 0x0          # 0048e417
    jne.d8 L_0048e45c                            # 0048e41b
    # block 0x0048e41d: entered by fall-through of jne at 0x0048e41b, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0048e45c
    movsx eax, word ptr [0x5c39e3]               # 0048e41d
    push eax                                     # 0048e424
    mov ecx, dword ptr [0x5bb57b]                # 0048e425
    push ecx                                     # 0048e42b
    push 0x54e924                                # 0048e42c
    push 0x63888b                                # 0048e431
    call FUN_0050ca3e                            # 0048e436
    add esp, 0x10                                # 0048e43b
    push 0x63888b                                # 0048e43e
    push 0x54e950                                # 0048e443
    mov ecx, 0x583979                            # 0048e448
    call FUN_0042639d                            # 0048e44d
    mov ecx, 0x5cf659                            # 0048e452
    call FUN_004c97b4                            # 0048e457
L_0048e45c:
    # block 0x0048e45c: entered by jne at 0x0048e41b, 2 instruction(s), ends with forward jump to 0x0048e470
    mov word ptr [ebp - local_8], 0x0            # 0048e45c
    jmp.d8 L_0048e470                            # 0048e462
L_0048e464:
    # block 0x0048e464: entered by jmp at 0x0048e5c7, 3 instruction(s), falls into the block at 0x0048e470
    mov dx, word ptr [ebp - local_8]             # 0048e464
    add dx, 0x1                                  # 0048e468
    mov word ptr [ebp - local_8], dx             # 0048e46c
L_0048e470:
    # block 0x0048e470: entered by jmp at 0x0048e462, 5 instruction(s), ends with jge to 0x0048e5cc (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048e470
    mov ecx, dword ptr [ebp - local_c]           # 0048e474
    movsx edx, word ptr [ecx + field_b0]         # 0048e477
    {load} cmp eax, edx                          # 0048e47e
    jge.d32 L_0048e5cc                           # 0048e480
    # block 0x0048e486: entered by fall-through of jge at 0x0048e480, 9 instruction(s), ends with jne to 0x0048e526 (forward)
    mov edi, 0x63a8b0                            # 0048e486
    movsx eax, word ptr [ebp - local_8]          # 0048e48b
    imul eax, eax, 0xd0                          # 0048e48f
    mov ecx, dword ptr [ebp - local_c]           # 0048e495
    lea esi, [ecx + eax + field_123]             # 0048e498
    mov ecx, 0x1                                 # 0048e49f
    {load} xor edx, edx                          # 0048e4a4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048e4a6
    jne.d8 L_0048e526                            # 0048e4a8
    # block 0x0048e4aa: entered by fall-through of jne at 0x0048e4a8, 10 instruction(s), calls FUN_00423259, ends with je to 0x0048e526 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048e4aa
    imul eax, eax, 0xd0                          # 0048e4ae
    mov ecx, dword ptr [ebp - local_c]           # 0048e4b4
    lea edx, [ecx + eax + field_100]             # 0048e4b7
    push edx                                     # 0048e4be
    mov ecx, 0x619a6b                            # 0048e4bf
    call FUN_00423259                            # 0048e4c4
    mov dword ptr [ebp - local_4], eax           # 0048e4c9
    cmp dword ptr [ebp - local_4], 0x0           # 0048e4cc
    je.d8 L_0048e526                             # 0048e4d0
    # block 0x0048e4d2: entered by fall-through of je at 0x0048e4d0, 25 instruction(s), falls into the block at 0x0048e526
    mov edi, dword ptr [ebp - local_4]           # 0048e4d2
    or ecx, -0x1                                 # 0048e4d5
    {load} xor eax, eax                          # 0048e4d8
    repne scasb al, byte ptr es:[edi]            # 0048e4da
    not ecx                                      # 0048e4dc
    mov esi, dword ptr [ebp - local_4]           # 0048e4de
    movsx eax, word ptr [ebp - local_8]          # 0048e4e1
    imul eax, eax, 0xd0                          # 0048e4e5
    mov edx, dword ptr [ebp - local_c]           # 0048e4eb
    lea edi, [edx + eax + field_123]             # 0048e4ee
    {load} mov eax, ecx                          # 0048e4f5
    shr ecx, 0x2                                 # 0048e4f7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048e4fa
    {load} mov ecx, eax                          # 0048e4fc
    and ecx, 0x3                                 # 0048e4fe
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048e501
    movsx ecx, word ptr [ebp - local_8]          # 0048e503
    imul ecx, ecx, 0xd0                          # 0048e507
    mov edx, dword ptr [ebp - local_c]           # 0048e50d
    lea edi, [edx + ecx + field_123]             # 0048e510
    or ecx, -0x1                                 # 0048e517
    {load} xor eax, eax                          # 0048e51a
    repne scasb al, byte ptr es:[edi]            # 0048e51c
    mov eax, dword ptr [0x54e96c]                # 0048e51e
    mov dword ptr [edi - field_minus_1], eax     # 0048e523
L_0048e526:
    # block 0x0048e526: entered by jne at 0x0048e4a8; je at 0x0048e4d0, 9 instruction(s), ends with jne to 0x0048e5c7 (forward)
    mov edi, 0x63a8b4                            # 0048e526
    movsx ecx, word ptr [ebp - local_8]          # 0048e52b
    imul ecx, ecx, 0xd0                          # 0048e52f
    mov edx, dword ptr [ebp - local_c]           # 0048e535
    lea esi, [edx + ecx + field_164]             # 0048e538
    mov ecx, 0x1                                 # 0048e53f
    {load} xor eax, eax                          # 0048e544
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048e546
    jne.d8 L_0048e5c7                            # 0048e548
    # block 0x0048e54a: entered by fall-through of jne at 0x0048e548, 10 instruction(s), calls FUN_00423259, ends with je to 0x0048e5c7 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0048e54a
    imul ecx, ecx, 0xd0                          # 0048e54e
    mov edx, dword ptr [ebp - local_c]           # 0048e554
    lea eax, [edx + ecx + field_141]             # 0048e557
    push eax                                     # 0048e55e
    mov ecx, 0x619a6b                            # 0048e55f
    call FUN_00423259                            # 0048e564
    mov dword ptr [ebp - local_4], eax           # 0048e569
    cmp dword ptr [ebp - local_4], 0x0           # 0048e56c
    je.d8 L_0048e5c7                             # 0048e570
    # block 0x0048e572: entered by fall-through of je at 0x0048e570, 25 instruction(s), falls into the block at 0x0048e5c7
    mov edi, dword ptr [ebp - local_4]           # 0048e572
    or ecx, -0x1                                 # 0048e575
    {load} xor eax, eax                          # 0048e578
    repne scasb al, byte ptr es:[edi]            # 0048e57a
    not ecx                                      # 0048e57c
    mov esi, dword ptr [ebp - local_4]           # 0048e57e
    movsx edx, word ptr [ebp - local_8]          # 0048e581
    imul edx, edx, 0xd0                          # 0048e585
    mov eax, dword ptr [ebp - local_c]           # 0048e58b
    lea edi, [eax + edx + field_164]             # 0048e58e
    {load} mov edx, ecx                          # 0048e595
    shr ecx, 0x2                                 # 0048e597
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048e59a
    {load} mov ecx, edx                          # 0048e59c
    and ecx, 0x3                                 # 0048e59e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048e5a1
    movsx eax, word ptr [ebp - local_8]          # 0048e5a3
    imul eax, eax, 0xd0                          # 0048e5a7
    mov ecx, dword ptr [ebp - local_c]           # 0048e5ad
    lea edi, [ecx + eax + field_164]             # 0048e5b0
    or ecx, -0x1                                 # 0048e5b7
    {load} xor eax, eax                          # 0048e5ba
    repne scasb al, byte ptr es:[edi]            # 0048e5bc
    mov edx, dword ptr [0x54e970]                # 0048e5be
    mov dword ptr [edi - field_minus_1], edx     # 0048e5c4
L_0048e5c7:
    # block 0x0048e5c7: entered by jne at 0x0048e548; je at 0x0048e570, 1 instruction(s), ends with backward jump to 0x0048e464
    jmp.d32 L_0048e464                           # 0048e5c7
L_0048e5cc:
    # block 0x0048e5cc: entered by jge at 0x0048e480, 26 instruction(s), ends with je to 0x0048e620 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0048e5cc
    mov eax, dword ptr [ebp + arg_c]             # 0048e5d0
    mov esi, dword ptr [eax]                     # 0048e5d3
    mov edx, dword ptr [ebp + arg_8]             # 0048e5d5
    mov edi, dword ptr [edx]                     # 0048e5d8
    {load} mov eax, ecx                          # 0048e5da
    shr ecx, 0x2                                 # 0048e5dc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048e5df
    {load} mov ecx, eax                          # 0048e5e1
    and ecx, 0x3                                 # 0048e5e3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048e5e6
    movsx ecx, word ptr [ebp - local_10]         # 0048e5e8
    mov edx, dword ptr [ebp + arg_10]            # 0048e5ec
    mov eax, dword ptr [edx]                     # 0048e5ef
    {load} add eax, ecx                          # 0048e5f1
    mov ecx, dword ptr [ebp + arg_10]            # 0048e5f3
    mov dword ptr [ecx], eax                     # 0048e5f6
    movsx edx, word ptr [ebp - local_10]         # 0048e5f8
    mov eax, dword ptr [ebp + arg_c]             # 0048e5fc
    mov ecx, dword ptr [eax]                     # 0048e5ff
    {load} add ecx, edx                          # 0048e601
    mov edx, dword ptr [ebp + arg_c]             # 0048e603
    mov dword ptr [edx], ecx                     # 0048e606
    movsx eax, word ptr [0x63a4cd]               # 0048e608
    test eax, eax                                # 0048e60f
    je.d8 L_0048e620                             # 0048e611
    # block 0x0048e613: entered by fall-through of je at 0x0048e611, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0048e620
    push 0x54e974                                # 0048e613
    call FUN_0044a2b7                            # 0048e618
    add esp, 0x4                                 # 0048e61d
L_0048e620:
    # block 0x0048e620: entered by je at 0x0048e611, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0048e620
    pop esi                                      # 0048e621
    {load} mov esp, ebp                          # 0048e622
    pop ebp                                      # 0048e624
    ret 0xc                                      # 0048e625

