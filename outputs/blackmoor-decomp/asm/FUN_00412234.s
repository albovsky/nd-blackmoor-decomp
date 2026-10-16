# FUN_00412234
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00412234
# extent:       0x00412234-0x00412787 (1363 code bytes)
# span:         0x00412234-0x00412787 (code 1363, tables 0, padding 0)
# sha256:       6d0a17177eb1731cd471f63e4d4eca7b08d9421720d7aa6d11ad223c81c9c8d6
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00412234
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       9 ebp-relative slot(s): local_4, local_9c44, local_9c48, local_9c4c, local_9c50, local_9c54, local_9c58, local_9c5c, local_9c60
# fields:       [eax + n] field_4, field_c, field_1036; [ecx + n] field_2, field_c, field_102a; [edi + n] field_2, field_minus_1; [edx + n] field_e7, field_e9, field_102a, field_1036
# callees:      calls FUN_0050c920, FUN_00423259, FUN_005193ca, FUN_004d3836, FUN_00413187, FUN_0042ba3a, FUN_00411b16
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 325 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_9c44, 0x9c44  # offset -0x9c44
.equ local_9c48, 0x9c48  # offset -0x9c48
.equ local_9c4c, 0x9c4c  # offset -0x9c4c
.equ local_9c50, 0x9c50  # offset -0x9c50
.equ local_9c54, 0x9c54  # offset -0x9c54
.equ local_9c58, 0x9c58  # offset -0x9c58
.equ local_9c5c, 0x9c5c  # offset -0x9c5c
.equ local_9c60, 0x9c60  # offset -0x9c60
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e7, 0xe7  # offset +0xe7
.equ field_e9, 0xe9  # offset +0xe9
.equ field_102a, 0x102a  # offset +0x102a
.equ field_1036, 0x1036  # offset +0x1036

# --- external targets -----------------------------------------------
.set FUN_00411b16, .text + (0x00411b16 - 0x401000)
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x00412234 - 0x401000
.globl FUN_00412234
FUN_00412234:
    # block 0x00412234: entry, 12 instruction(s), calls FUN_0050c920, ends with jne to 0x0041277e (forward)
    push ebp                                     # 00412234
    {load} mov ebp, esp                          # 00412235
    mov eax, 0x9c60                              # 00412237
    call FUN_0050c920                            # 0041223c
    push ebx                                     # 00412241
    push esi                                     # 00412242
    push edi                                     # 00412243
    mov dword ptr [ebp - local_9c60], ecx        # 00412244
    movsx eax, word ptr [ebp + arg_8]            # 0041224a
    imul eax, eax, 0x8d                          # 0041224e
    cmp dword ptr [eax + 0x5bb632], 0x0          # 00412254
    jne.d32 L_0041277e                           # 0041225b
    # block 0x00412261: entered by fall-through of jne at 0x0041225b, 25 instruction(s), ends with jne to 0x0041267c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00412261
    imul ecx, ecx, 0x8d                          # 00412265
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0041226b
    mov dword ptr [ebp - local_9c48], edx        # 00412271
    mov eax, dword ptr [ebp - local_9c48]        # 00412277
    mov cx, word ptr [eax + field_4]             # 0041227d
    mov word ptr [ebp - local_9c54], cx          # 00412281
    mov edx, dword ptr [ebp - local_9c60]        # 00412288
    mov dword ptr [edx + field_102a], 0x0        # 0041228e
    mov eax, dword ptr [ebp - local_9c60]        # 00412298
    mov ecx, dword ptr [ebp - local_9c48]        # 0041229e
    mov dx, word ptr [ecx + field_2]             # 004122a4
    mov word ptr [eax + field_4], dx             # 004122a8
    mov eax, dword ptr [ebp - local_9c60]        # 004122ac
    movsx ecx, word ptr [eax + field_4]          # 004122b2
    sub ecx, 0x3                                 # 004122b6
    mov word ptr [ebp - local_9c5c], cx          # 004122b9
    mov ecx, 0x2710                              # 004122c0
    {load} xor eax, eax                          # 004122c5
    lea edi, [ebp - local_9c44]                  # 004122c7
    rep stosd dword ptr es:[edi], eax            # 004122cd
    mov edx, dword ptr [ebp - local_9c48]        # 004122cf
    movsx eax, word ptr [edx + field_e7]         # 004122d5
    test eax, eax                                # 004122dc
    jne.d32 L_0041267c                           # 004122de
    # block 0x004122e4: entered by fall-through of jne at 0x004122de, 5 instruction(s), ends with forward jump to 0x00412311
    movsx ecx, word ptr [ebp - local_9c5c]       # 004122e4
    movsx edx, word ptr [2*ecx + 0x59fbdb]       # 004122eb
    sub edx, 0x1                                 # 004122f3
    mov word ptr [ebp - local_9c4c], dx          # 004122f6
    jmp.d8 L_00412311                            # 004122fd
L_004122ff:
    # block 0x004122ff: entered by jmp at 0x00412672, 3 instruction(s), falls into the block at 0x00412311
    mov ax, word ptr [ebp - local_9c4c]          # 004122ff
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00412306
    mov word ptr [ebp - local_9c4c], ax          # 0041230a
L_00412311:
    # block 0x00412311: entered by jmp at 0x004122fd, 3 instruction(s), ends with jl to 0x00412677 (forward)
    movsx ecx, word ptr [ebp - local_9c4c]       # 00412311
    test ecx, ecx                                # 00412318
    jl.d32 L_00412677                            # 0041231a
    # block 0x00412320: entered by fall-through of jl at 0x0041231a, 12 instruction(s), calls FUN_00423259, ends with je to 0x00412672 (forward)
    movsx edx, word ptr [ebp - local_9c5c]       # 00412320
    imul edx, edx, 0x3390                        # 00412327
    movsx eax, word ptr [ebp - local_9c4c]       # 0041232d
    imul eax, eax, 0x21                          # 00412334
    lea ecx, [edx + eax + 0x5957cb]              # 00412337
    push ecx                                     # 0041233e
    mov ecx, dword ptr [ebp - local_9c60]        # 0041233f
    add ecx, 0x2a                                # 00412345
    call FUN_00423259                            # 00412348
    mov dword ptr [ebp - local_9c50], eax        # 0041234d
    cmp dword ptr [ebp - local_9c50], 0x0        # 00412353
    je.d32 L_00412672                            # 0041235a
    # block 0x00412360: entered by fall-through of je at 0x0041235a, 6 instruction(s), ends with jl to 0x0041241c (forward)
    movsx edx, word ptr [ebp - local_9c5c]       # 00412360
    imul edx, edx, 0x320                         # 00412367
    movsx eax, word ptr [ebp - local_9c4c]       # 0041236d
    movsx ecx, word ptr [edx + 2*eax + 0x59f27b] # 00412374
    cmp ecx, 0xa                                 # 0041237c
    jl.d32 L_0041241c                            # 0041237f
    # block 0x00412385: entered by fall-through of jl at 0x0041237f, 44 instruction(s), calls FUN_005193ca, falls into the block at 0x0041241c
    lea edi, [ebp - local_9c44]                  # 00412385
    or ecx, -0x1                                 # 0041238b
    {load} xor eax, eax                          # 0041238e
    repne scasb al, byte ptr es:[edi]            # 00412390
    add edi, -0x1                                # 00412392
    mov dx, word ptr [0x541638]                  # 00412395
    mov word ptr [edi], dx                       # 0041239c
    mov al, byte ptr [0x54163a]                  # 0041239f
    mov byte ptr [edi + field_2], al             # 004123a4
    push 0xa                                     # 004123a7
    lea ecx, [ebp - local_9c58]                  # 004123a9
    push ecx                                     # 004123af
    movsx edx, word ptr [ebp - local_9c4c]       # 004123b0
    push edx                                     # 004123b7
    call FUN_005193ca                            # 004123b8
    add esp, 0xc                                 # 004123bd
    lea edi, [ebp - local_9c58]                  # 004123c0
    lea edx, [ebp - local_9c44]                  # 004123c6
    or ecx, -0x1                                 # 004123cc
    {load} xor eax, eax                          # 004123cf
    repne scasb al, byte ptr es:[edi]            # 004123d1
    not ecx                                      # 004123d3
    {load} sub edi, ecx                          # 004123d5
    {load} mov esi, edi                          # 004123d7
    {load} mov ebx, ecx                          # 004123d9
    {load} mov edi, edx                          # 004123db
    or ecx, -0x1                                 # 004123dd
    {load} xor eax, eax                          # 004123e0
    repne scasb al, byte ptr es:[edi]            # 004123e2
    add edi, -0x1                                # 004123e4
    {load} mov ecx, ebx                          # 004123e7
    shr ecx, 0x2                                 # 004123e9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004123ec
    {load} mov ecx, ebx                          # 004123ee
    and ecx, 0x3                                 # 004123f0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004123f3
    lea edi, [ebp - local_9c44]                  # 004123f5
    or ecx, -0x1                                 # 004123fb
    {load} xor eax, eax                          # 004123fe
    repne scasb al, byte ptr es:[edi]            # 00412400
    mov ax, word ptr [0x54163c]                  # 00412402
    mov word ptr [edi - field_minus_1], ax       # 00412408
    mov ecx, dword ptr [ebp - local_9c60]        # 0041240c
    mov dword ptr [ecx + field_102a], 0x1        # 00412412
L_0041241c:
    # block 0x0041241c: entered by jl at 0x0041237f, 5 instruction(s), ends with jne to 0x00412561 (forward)
    mov edx, dword ptr [ebp - local_9c48]        # 0041241c
    {load} xor eax, eax                          # 00412422
    mov al, byte ptr [edx + field_e9]            # 00412424
    cmp eax, 0x1                                 # 0041242a
    jne.d32 L_00412561                           # 0041242d
    # block 0x00412433: entered by fall-through of jne at 0x0041242d, 6 instruction(s), ends with je to 0x00412561 (forward)
    movsx ecx, word ptr [ebp - local_9c5c]       # 00412433
    imul ecx, ecx, 0x320                         # 0041243a
    movsx edx, word ptr [ebp - local_9c4c]       # 00412440
    movsx eax, word ptr [ecx + 2*edx + 0x59f27b] # 00412447
    test eax, eax                                # 0041244f
    je.d32 L_00412561                            # 00412451
    # block 0x00412457: entered by fall-through of je at 0x00412451, 6 instruction(s), ends with je to 0x00412561 (forward)
    movsx ecx, word ptr [ebp - local_9c5c]       # 00412457
    imul ecx, ecx, 0x320                         # 0041245e
    movsx edx, word ptr [ebp - local_9c4c]       # 00412464
    movsx eax, word ptr [ecx + 2*edx + 0x59f27b] # 0041246b
    cmp eax, 0xa                                 # 00412473
    je.d32 L_00412561                            # 00412476
    # block 0x0041247c: entered by fall-through of je at 0x00412476, 12 instruction(s), ends with jle to 0x004124df (forward)
    lea edi, [ebp - local_9c44]                  # 0041247c
    or ecx, -0x1                                 # 00412482
    {load} xor eax, eax                          # 00412485
    repne scasb al, byte ptr es:[edi]            # 00412487
    mov cx, word ptr [0x541640]                  # 00412489
    mov word ptr [edi - field_minus_1], cx       # 00412490
    movsx edx, word ptr [ebp - local_9c5c]       # 00412494
    imul edx, edx, 0x320                         # 0041249b
    movsx eax, word ptr [ebp - local_9c4c]       # 004124a1
    movsx ecx, word ptr [edx + 2*eax + 0x59f27b] # 004124a8
    cmp ecx, 0xa                                 # 004124b0
    jle.d8 L_004124df                            # 004124b3
    # block 0x004124b5: entered by fall-through of jle at 0x004124b3, 9 instruction(s), ends with forward jump to 0x004124ff
    movsx edx, word ptr [ebp - local_9c5c]       # 004124b5
    imul edx, edx, 0x320                         # 004124bc
    movsx eax, word ptr [ebp - local_9c4c]       # 004124c2
    movsx eax, word ptr [edx + 2*eax + 0x59f27b] # 004124c9
    cdq                                          # 004124d1
    mov ecx, 0xa                                 # 004124d2
    idiv ecx                                     # 004124d7
    mov word ptr [ebp - local_4], dx             # 004124d9
    jmp.d8 L_004124ff                            # 004124dd
L_004124df:
    # block 0x004124df: entered by jle at 0x004124b3, 5 instruction(s), falls into the block at 0x004124ff
    movsx edx, word ptr [ebp - local_9c5c]       # 004124df
    imul edx, edx, 0x320                         # 004124e6
    movsx eax, word ptr [ebp - local_9c4c]       # 004124ec
    mov cx, word ptr [edx + 2*eax + 0x59f27b]    # 004124f3
    mov word ptr [ebp - local_4], cx             # 004124fb
L_004124ff:
    # block 0x004124ff: entered by jmp at 0x004124dd, 33 instruction(s), calls FUN_005193ca, falls into the block at 0x00412561
    push 0xa                                     # 004124ff
    lea edx, [ebp - local_9c58]                  # 00412501
    push edx                                     # 00412507
    movsx eax, word ptr [ebp - local_4]          # 00412508
    push eax                                     # 0041250c
    call FUN_005193ca                            # 0041250d
    add esp, 0xc                                 # 00412512
    lea edi, [ebp - local_9c58]                  # 00412515
    lea edx, [ebp - local_9c44]                  # 0041251b
    or ecx, -0x1                                 # 00412521
    {load} xor eax, eax                          # 00412524
    repne scasb al, byte ptr es:[edi]            # 00412526
    not ecx                                      # 00412528
    {load} sub edi, ecx                          # 0041252a
    {load} mov esi, edi                          # 0041252c
    {load} mov ebx, ecx                          # 0041252e
    {load} mov edi, edx                          # 00412530
    or ecx, -0x1                                 # 00412532
    {load} xor eax, eax                          # 00412535
    repne scasb al, byte ptr es:[edi]            # 00412537
    add edi, -0x1                                # 00412539
    {load} mov ecx, ebx                          # 0041253c
    shr ecx, 0x2                                 # 0041253e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412541
    {load} mov ecx, ebx                          # 00412543
    and ecx, 0x3                                 # 00412545
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412548
    lea edi, [ebp - local_9c44]                  # 0041254a
    or ecx, -0x1                                 # 00412550
    {load} xor eax, eax                          # 00412553
    repne scasb al, byte ptr es:[edi]            # 00412555
    mov ax, word ptr [0x541644]                  # 00412557
    mov word ptr [edi - field_minus_1], ax       # 0041255d
L_00412561:
    # block 0x00412561: entered by jne at 0x0041242d; je at 0x00412451; je at 0x00412476, 26 instruction(s), ends with jl to 0x00412621 (forward)
    mov edi, dword ptr [ebp - local_9c50]        # 00412561
    lea edx, [ebp - local_9c44]                  # 00412567
    or ecx, -0x1                                 # 0041256d
    {load} xor eax, eax                          # 00412570
    repne scasb al, byte ptr es:[edi]            # 00412572
    not ecx                                      # 00412574
    {load} sub edi, ecx                          # 00412576
    {load} mov esi, edi                          # 00412578
    {load} mov ebx, ecx                          # 0041257a
    {load} mov edi, edx                          # 0041257c
    or ecx, -0x1                                 # 0041257e
    {load} xor eax, eax                          # 00412581
    repne scasb al, byte ptr es:[edi]            # 00412583
    add edi, -0x1                                # 00412585
    {load} mov ecx, ebx                          # 00412588
    shr ecx, 0x2                                 # 0041258a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041258d
    {load} mov ecx, ebx                          # 0041258f
    and ecx, 0x3                                 # 00412591
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412594
    movsx eax, word ptr [ebp - local_9c5c]       # 00412596
    imul eax, eax, 0x320                         # 0041259d
    movsx ecx, word ptr [ebp - local_9c4c]       # 004125a3
    movsx edx, word ptr [eax + 2*ecx + 0x59f27b] # 004125aa
    cmp edx, 0xa                                 # 004125b2
    jl.d8 L_00412621                             # 004125b5
    # block 0x004125b7: entered by fall-through of jl at 0x004125b5, 17 instruction(s), calls FUN_004d3836, ends with jle to 0x00412621 (forward)
    movsx eax, word ptr [ebp - local_9c54]       # 004125b7
    imul eax, eax, 0x1d0                         # 004125be
    add eax, 0x5adb3a                            # 004125c4
    push eax                                     # 004125c9
    movsx ecx, word ptr [ebp - local_9c54]       # 004125ca
    imul ecx, ecx, 0x7f3                         # 004125d1
    add ecx, 0x5a4c24                            # 004125d7
    push ecx                                     # 004125dd
    mov edx, dword ptr [ebp - local_9c50]        # 004125de
    push edx                                     # 004125e4
    call FUN_004d3836                            # 004125e5
    add esp, 0xc                                 # 004125ea
    movsx eax, ax                                # 004125ed
    mov ecx, dword ptr [ebp - local_9c48]        # 004125f0
    movsx edx, word ptr [ecx + field_c]          # 004125f6
    {load} cmp eax, edx                          # 004125fa
    jle.d8 L_00412621                            # 004125fc
    # block 0x004125fe: entered by fall-through of jle at 0x004125fc, 7 instruction(s), ends with forward jump to 0x0041263c
    mov eax, dword ptr [ebp - local_9c48]        # 004125fe
    movsx ecx, word ptr [eax + field_c]          # 00412604
    movsx edx, word ptr [ebp - local_9c4c]       # 00412608
    shl edx, 0x4                                 # 0041260f
    mov eax, dword ptr [ebp - local_9c60]        # 00412612
    mov dword ptr [eax + edx + field_1036], ecx  # 00412618
    jmp.d8 L_0041263c                            # 0041261f
L_00412621:
    # block 0x00412621: entered by jl at 0x004125b5; jle at 0x004125fc, 4 instruction(s), falls into the block at 0x0041263c
    movsx ecx, word ptr [ebp - local_9c4c]       # 00412621
    shl ecx, 0x4                                 # 00412628
    mov edx, dword ptr [ebp - local_9c60]        # 0041262b
    mov dword ptr [edx + ecx + field_1036], 0x0  # 00412631
L_0041263c:
    # block 0x0041263c: entered by jmp at 0x0041261f, 6 instruction(s), ends with jl to 0x00412672 (forward)
    movsx eax, word ptr [ebp - local_9c5c]       # 0041263c
    imul eax, eax, 0x320                         # 00412643
    movsx ecx, word ptr [ebp - local_9c4c]       # 00412649
    movsx edx, word ptr [eax + 2*ecx + 0x59f27b] # 00412650
    cmp edx, 0xa                                 # 00412658
    jl.d8 L_00412672                             # 0041265b
    # block 0x0041265d: entered by fall-through of jl at 0x0041265b, 6 instruction(s), falls into the block at 0x00412672
    lea edi, [ebp - local_9c44]                  # 0041265d
    or ecx, -0x1                                 # 00412663
    {load} xor eax, eax                          # 00412666
    repne scasb al, byte ptr es:[edi]            # 00412668
    mov eax, dword ptr [0x541648]                # 0041266a
    mov dword ptr [edi - field_minus_1], eax     # 0041266f
L_00412672:
    # block 0x00412672: entered by je at 0x0041235a; jl at 0x0041265b, 1 instruction(s), ends with backward jump to 0x004122ff
    jmp.d32 L_004122ff                           # 00412672
L_00412677:
    # block 0x00412677: entered by jl at 0x0041231a, 1 instruction(s), ends with forward jump to 0x00412729
    jmp.d32 L_00412729                           # 00412677
L_0041267c:
    # block 0x0041267c: entered by jne at 0x004122de, 2 instruction(s), ends with forward jump to 0x00412699
    mov word ptr [ebp - local_9c4c], 0x0         # 0041267c
    jmp.d8 L_00412699                            # 00412685
L_00412687:
    # block 0x00412687: entered by jmp at 0x00412724, 3 instruction(s), falls into the block at 0x00412699
    mov cx, word ptr [ebp - local_9c4c]          # 00412687
    add cx, 0x1                                  # 0041268e
    mov word ptr [ebp - local_9c4c], cx          # 00412692
L_00412699:
    # block 0x00412699: entered by jmp at 0x00412685, 5 instruction(s), ends with jge to 0x00412729 (forward)
    movsx edx, word ptr [ebp - local_9c4c]       # 00412699
    movsx eax, word ptr [ebp - local_9c5c]       # 004126a0
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 004126a7
    {load} cmp edx, ecx                          # 004126af
    jge.d8 L_00412729                            # 004126b1
    # block 0x004126b3: entered by fall-through of jge at 0x004126b1, 12 instruction(s), calls FUN_00423259, ends with je to 0x00412724 (forward)
    movsx edx, word ptr [ebp - local_9c5c]       # 004126b3
    imul edx, edx, 0x3390                        # 004126ba
    movsx eax, word ptr [ebp - local_9c4c]       # 004126c0
    imul eax, eax, 0x21                          # 004126c7
    lea ecx, [edx + eax + 0x5957cb]              # 004126ca
    push ecx                                     # 004126d1
    mov ecx, dword ptr [ebp - local_9c60]        # 004126d2
    add ecx, 0x2a                                # 004126d8
    call FUN_00423259                            # 004126db
    mov dword ptr [ebp - local_9c50], eax        # 004126e0
    cmp dword ptr [ebp - local_9c50], 0x0        # 004126e6
    je.d8 L_00412724                             # 004126ed
    # block 0x004126ef: entered by fall-through of je at 0x004126ed, 20 instruction(s), falls into the block at 0x00412724
    mov edi, dword ptr [ebp - local_9c50]        # 004126ef
    lea edx, [ebp - local_9c44]                  # 004126f5
    or ecx, -0x1                                 # 004126fb
    {load} xor eax, eax                          # 004126fe
    repne scasb al, byte ptr es:[edi]            # 00412700
    not ecx                                      # 00412702
    {load} sub edi, ecx                          # 00412704
    {load} mov esi, edi                          # 00412706
    {load} mov ebx, ecx                          # 00412708
    {load} mov edi, edx                          # 0041270a
    or ecx, -0x1                                 # 0041270c
    {load} xor eax, eax                          # 0041270f
    repne scasb al, byte ptr es:[edi]            # 00412711
    add edi, -0x1                                # 00412713
    {load} mov ecx, ebx                          # 00412716
    shr ecx, 0x2                                 # 00412718
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041271b
    {load} mov ecx, ebx                          # 0041271d
    and ecx, 0x3                                 # 0041271f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412722
L_00412724:
    # block 0x00412724: entered by je at 0x004126ed, 1 instruction(s), ends with backward jump to 0x00412687
    jmp.d32 L_00412687                           # 00412724
L_00412729:
    # block 0x00412729: entered by jmp at 0x00412677; jge at 0x004126b1, 22 instruction(s), calls FUN_00413187, FUN_0042ba3a, FUN_00411b16, falls into the block at 0x0041277e
    lea eax, [ebp - local_9c44]                  # 00412729
    mov dword ptr [ebp - local_9c50], eax        # 0041272f
    push 0x0                                     # 00412735
    push 0x0                                     # 00412737
    mov ecx, dword ptr [ebp - local_9c50]        # 00412739
    push ecx                                     # 0041273f
    mov edx, dword ptr [ebp - local_9c48]        # 00412740
    push edx                                     # 00412746
    mov ecx, dword ptr [ebp - local_9c60]        # 00412747
    call FUN_00413187                            # 0041274d
    mov ax, word ptr [ebp + arg_8]               # 00412752
    push eax                                     # 00412756
    call FUN_0042ba3a                            # 00412757
    add esp, 0x4                                 # 0041275c
    mov cx, word ptr [ebp - local_9c5c]          # 0041275f
    push ecx                                     # 00412766
    mov dx, word ptr [ebp + arg_8]               # 00412767
    push edx                                     # 0041276b
    mov eax, dword ptr [ebp - local_9c48]        # 0041276c
    push eax                                     # 00412772
    mov ecx, dword ptr [ebp - local_9c60]        # 00412773
    call FUN_00411b16                            # 00412779
L_0041277e:
    # block 0x0041277e: entered by jne at 0x0041225b, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 0041277e
    pop esi                                      # 0041277f
    pop ebx                                      # 00412780
    {load} mov esp, ebp                          # 00412781
    pop ebp                                      # 00412783
    ret 0x4                                      # 00412784

