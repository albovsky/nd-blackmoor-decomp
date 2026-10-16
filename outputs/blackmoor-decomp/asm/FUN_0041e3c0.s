# FUN_0041e3c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e3c0
# extent:       0x0041e3c0-0x0041e647 (647 code bytes)
# span:         0x0041e3c0-0x0041e647 (code 647, tables 0, padding 0)
# sha256:       96668493d1f4eda163a3da88b563ae49ba32c1e86b0f33da83c40544fdd961da
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041e3c0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_40, local_44, local_48, local_4c, local_50
# fields:       [ecx + n] field_7d9; [edi + n] field_minus_1; [edx + n] field_ea5, field_f21
# callees:      calls FUN_0051e745, FUN_0051ea75, FUN_0050ca3e, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 203 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ arg_8, 0x8  # offset +0x8
.equ field_7d9, 0x7d9  # offset +0x7d9
.equ field_ea5, 0xea5  # offset +0xea5
.equ field_f21, 0xf21  # offset +0xf21

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051e745, .text + (0x0051e745 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x0041e3c0 - 0x401000
.globl FUN_0041e3c0
FUN_0041e3c0:
    # block 0x0041e3c0: entry, 54 instruction(s), calls FUN_0051e745, FUN_0051ea75, ends with je to 0x0041e4b6 (forward)
    push ebp                                     # 0041e3c0
    {load} mov ebp, esp                          # 0041e3c1
    sub esp, 0x50                                # 0041e3c3
    push ebx                                     # 0041e3c6
    push esi                                     # 0041e3c7
    push edi                                     # 0041e3c8
    mov dword ptr [ebp - local_50], ecx          # 0041e3c9
    mov word ptr [ebp - local_8], 0x0            # 0041e3cc
    mov ecx, dword ptr [ebp - local_50]          # 0041e3d2
    add ecx, 0xf1d                               # 0041e3d5
    call FUN_0051e745                            # 0041e3db
    push 0x3a98                                  # 0041e3e0
    mov ecx, dword ptr [ebp - local_50]          # 0041e3e5
    add ecx, 0xf1d                               # 0041e3e8
    call FUN_0051ea75                            # 0041e3ee
    mov dword ptr [ebp - local_c], eax           # 0041e3f3
    mov ecx, 0xea6                               # 0041e3f6
    {load} xor eax, eax                          # 0041e3fb
    mov edi, dword ptr [ebp - local_c]           # 0041e3fd
    rep stosd dword ptr es:[edi], eax            # 0041e400
    movsx eax, word ptr [ebp + arg_8]            # 0041e402
    imul eax, eax, 0x8d                          # 0041e406
    mov edi, dword ptr [eax + 0x5bb5e5]          # 0041e40c
    add edi, 0x16b                               # 0041e412
    or ecx, -0x1                                 # 0041e418
    {load} xor eax, eax                          # 0041e41b
    repne scasb al, byte ptr es:[edi]            # 0041e41d
    not ecx                                      # 0041e41f
    add ecx, -0x1                                # 0041e421
    movsx edx, word ptr [ebp + arg_8]            # 0041e424
    imul edx, edx, 0x8d                          # 0041e428
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0041e42e
    add esi, 0x16b                               # 0041e434
    mov edi, dword ptr [ebp - local_c]           # 0041e43a
    {load} mov eax, ecx                          # 0041e43d
    shr ecx, 0x2                                 # 0041e43f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e442
    {load} mov ecx, eax                          # 0041e444
    and ecx, 0x3                                 # 0041e446
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e449
    movsx ecx, word ptr [ebp + arg_8]            # 0041e44b
    imul ecx, ecx, 0x8d                          # 0041e44f
    mov edi, dword ptr [ecx + 0x5bb5e5]          # 0041e455
    add edi, 0x16b                               # 0041e45b
    or ecx, -0x1                                 # 0041e461
    {load} xor eax, eax                          # 0041e464
    repne scasb al, byte ptr es:[edi]            # 0041e466
    not ecx                                      # 0041e468
    add ecx, -0x1                                # 0041e46a
    mov dx, word ptr [ebp - local_8]             # 0041e46d
    {load} add dx, cx                            # 0041e471
    mov word ptr [ebp - local_8], dx             # 0041e474
    cmp dword ptr [0x5bb202], 0x0                # 0041e478
    je.d8 L_0041e4b6                             # 0041e47f
    # block 0x0041e481: entered by fall-through of je at 0x0041e47f, 17 instruction(s), falls into the block at 0x0041e4b6
    movsx eax, word ptr [ebp - local_8]          # 0041e481
    mov edi, dword ptr [ebp - local_c]           # 0041e485
    {load} add edi, eax                          # 0041e488
    or ecx, -0x1                                 # 0041e48a
    {load} xor eax, eax                          # 0041e48d
    repne scasb al, byte ptr es:[edi]            # 0041e48f
    mov ecx, dword ptr [0x54388c]                # 0041e491
    mov dword ptr [edi - field_minus_1], ecx     # 0041e497
    mov edi, 0x543890                            # 0041e49a
    or ecx, -0x1                                 # 0041e49f
    {load} xor eax, eax                          # 0041e4a2
    repne scasb al, byte ptr es:[edi]            # 0041e4a4
    not ecx                                      # 0041e4a6
    add ecx, -0x1                                # 0041e4a8
    mov dx, word ptr [ebp - local_8]             # 0041e4ab
    {load} add dx, cx                            # 0041e4af
    mov word ptr [ebp - local_8], dx             # 0041e4b2
L_0041e4b6:
    # block 0x0041e4b6: entered by je at 0x0041e47f, 2 instruction(s), ends with forward jump to 0x0041e4ca
    mov word ptr [ebp - local_4], 0x0            # 0041e4b6
    jmp.d8 L_0041e4ca                            # 0041e4bc
L_0041e4be:
    # block 0x0041e4be: entered by jmp at 0x0041e610, 3 instruction(s), falls into the block at 0x0041e4ca
    mov ax, word ptr [ebp - local_4]             # 0041e4be
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041e4c2
    mov word ptr [ebp - local_4], ax             # 0041e4c6
L_0041e4ca:
    # block 0x0041e4ca: entered by jmp at 0x0041e4bc, 5 instruction(s), ends with jge to 0x0041e615 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041e4ca
    mov edx, dword ptr [ebp - local_50]          # 0041e4ce
    movsx eax, word ptr [edx + field_f21]        # 0041e4d1
    {load} cmp ecx, eax                          # 0041e4d8
    jge.d32 L_0041e615                           # 0041e4da
    # block 0x0041e4e0: entered by fall-through of jge at 0x0041e4da, 3 instruction(s), ends with je to 0x0041e51c (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041e4e0
    test ecx, ecx                                # 0041e4e4
    je.d8 L_0041e51c                             # 0041e4e6
    # block 0x0041e4e8: entered by fall-through of je at 0x0041e4e6, 17 instruction(s), falls into the block at 0x0041e51c
    movsx edx, word ptr [ebp - local_8]          # 0041e4e8
    mov edi, dword ptr [ebp - local_c]           # 0041e4ec
    {load} add edi, edx                          # 0041e4ef
    or ecx, -0x1                                 # 0041e4f1
    {load} xor eax, eax                          # 0041e4f4
    repne scasb al, byte ptr es:[edi]            # 0041e4f6
    mov eax, dword ptr [0x543894]                # 0041e4f8
    mov dword ptr [edi - field_minus_1], eax     # 0041e4fd
    mov edi, 0x543898                            # 0041e500
    or ecx, -0x1                                 # 0041e505
    {load} xor eax, eax                          # 0041e508
    repne scasb al, byte ptr es:[edi]            # 0041e50a
    not ecx                                      # 0041e50c
    add ecx, -0x1                                # 0041e50e
    mov dx, word ptr [ebp - local_8]             # 0041e511
    {load} add dx, cx                            # 0041e515
    mov word ptr [ebp - local_8], dx             # 0041e518
L_0041e51c:
    # block 0x0041e51c: entered by je at 0x0041e4e6, 84 instruction(s), calls FUN_0050ca3e, ends with backward jump to 0x0041e4be
    movsx eax, word ptr [ebp - local_4]          # 0041e51c
    imul eax, eax, 0x3a                          # 0041e520
    mov ecx, dword ptr [ebp - local_50]          # 0041e523
    lea edx, [ecx + eax + field_7d9]             # 0041e526
    push edx                                     # 0041e52d
    movsx eax, word ptr [ebp - local_4]          # 0041e52e
    push eax                                     # 0041e532
    movsx ecx, word ptr [ebp - local_4]          # 0041e533
    push ecx                                     # 0041e537
    push 0x54389c                                # 0041e538
    lea edx, [ebp - local_40]                    # 0041e53d
    push edx                                     # 0041e540
    call FUN_0050ca3e                            # 0041e541
    add esp, 0x14                                # 0041e546
    lea edi, [ebp - local_40]                    # 0041e549
    movsx eax, word ptr [ebp - local_8]          # 0041e54c
    mov ecx, dword ptr [ebp - local_c]           # 0041e550
    {load} add ecx, eax                          # 0041e553
    {load} mov edx, ecx                          # 0041e555
    or ecx, -0x1                                 # 0041e557
    {load} xor eax, eax                          # 0041e55a
    repne scasb al, byte ptr es:[edi]            # 0041e55c
    not ecx                                      # 0041e55e
    {load} sub edi, ecx                          # 0041e560
    {load} mov esi, edi                          # 0041e562
    {load} mov ebx, ecx                          # 0041e564
    {load} mov edi, edx                          # 0041e566
    or ecx, -0x1                                 # 0041e568
    {load} xor eax, eax                          # 0041e56b
    repne scasb al, byte ptr es:[edi]            # 0041e56d
    add edi, -0x1                                # 0041e56f
    {load} mov ecx, ebx                          # 0041e572
    shr ecx, 0x2                                 # 0041e574
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e577
    {load} mov ecx, ebx                          # 0041e579
    and ecx, 0x3                                 # 0041e57b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e57e
    lea edi, [ebp - local_40]                    # 0041e580
    or ecx, -0x1                                 # 0041e583
    {load} xor eax, eax                          # 0041e586
    repne scasb al, byte ptr es:[edi]            # 0041e588
    not ecx                                      # 0041e58a
    add ecx, -0x1                                # 0041e58c
    mov ax, word ptr [ebp - local_8]             # 0041e58f
    {load} add ax, cx                            # 0041e593
    mov word ptr [ebp - local_8], ax             # 0041e596
    movsx ecx, word ptr [ebp - local_4]          # 0041e59a
    mov edx, dword ptr [ebp - local_50]          # 0041e59e
    mov eax, dword ptr [edx + 4*ecx + field_ea5] # 0041e5a1
    mov dword ptr [ebp - local_44], eax          # 0041e5a8
    movsx ecx, word ptr [ebp - local_4]          # 0041e5ab
    mov edx, dword ptr [ebp - local_50]          # 0041e5af
    mov eax, dword ptr [edx + 4*ecx + field_ea5] # 0041e5b2
    mov dword ptr [ebp - local_48], eax          # 0041e5b9
    mov edi, dword ptr [ebp - local_44]          # 0041e5bc
    or ecx, -0x1                                 # 0041e5bf
    {load} xor eax, eax                          # 0041e5c2
    repne scasb al, byte ptr es:[edi]            # 0041e5c4
    not ecx                                      # 0041e5c6
    add ecx, -0x1                                # 0041e5c8
    mov esi, dword ptr [ebp - local_48]          # 0041e5cb
    movsx edx, word ptr [ebp - local_8]          # 0041e5ce
    mov edi, dword ptr [ebp - local_c]           # 0041e5d2
    {load} add edi, edx                          # 0041e5d5
    {load} mov eax, ecx                          # 0041e5d7
    shr ecx, 0x2                                 # 0041e5d9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e5dc
    {load} mov ecx, eax                          # 0041e5de
    and ecx, 0x3                                 # 0041e5e0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e5e3
    movsx ecx, word ptr [ebp - local_4]          # 0041e5e5
    mov edx, dword ptr [ebp - local_50]          # 0041e5e9
    mov eax, dword ptr [edx + 4*ecx + field_ea5] # 0041e5ec
    mov dword ptr [ebp - local_4c], eax          # 0041e5f3
    mov edi, dword ptr [ebp - local_4c]          # 0041e5f6
    or ecx, -0x1                                 # 0041e5f9
    {load} xor eax, eax                          # 0041e5fc
    repne scasb al, byte ptr es:[edi]            # 0041e5fe
    not ecx                                      # 0041e600
    add ecx, -0x1                                # 0041e602
    mov dx, word ptr [ebp - local_8]             # 0041e605
    {load} add dx, cx                            # 0041e609
    mov word ptr [ebp - local_8], dx             # 0041e60c
    jmp.d32 L_0041e4be                           # 0041e610
L_0041e615:
    # block 0x0041e615: entered by jge at 0x0041e4da, 18 instruction(s), calls FUN_0051eac4, ends with ret 0x4
    movsx eax, word ptr [ebp - local_8]          # 0041e615
    mov edi, dword ptr [ebp - local_c]           # 0041e619
    {load} add edi, eax                          # 0041e61c
    or ecx, -0x1                                 # 0041e61e
    {load} xor eax, eax                          # 0041e621
    repne scasb al, byte ptr es:[edi]            # 0041e623
    mov ecx, dword ptr [0x5438b0]                # 0041e625
    mov dword ptr [edi - field_minus_1], ecx     # 0041e62b
    push -0x1                                    # 0041e62e
    mov ecx, dword ptr [ebp - local_50]          # 0041e630
    add ecx, 0xf1d                               # 0041e633
    call FUN_0051eac4                            # 0041e639
    pop edi                                      # 0041e63e
    pop esi                                      # 0041e63f
    pop ebx                                      # 0041e640
    {load} mov esp, ebp                          # 0041e641
    pop ebp                                      # 0041e643
    ret 0x4                                      # 0041e644

