# FUN_004cd243
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cd243
# extent:       0x004cd243-0x004cd645 (1026 code bytes)
# span:         0x004cd243-0x004cd645 (code 1026, tables 0, padding 0)
# sha256:       5b186c92f48dc216b08e6bab3d683b068f4662942bf6f94f956acd4faa4659a3
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cd243_read_tables
# naming:       native port src/original_methods_fl28c.c:m4cd243_read_tables (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4cd243_read_tables (scene-table reader). Oracle: 302/302 instructions of the 1026 code bytes, 16/16 jcc directions, 264 scenarios. See tasks/fl28c-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_23, field_29, field_2d, field_2f, field_31, field_216, field_222, field_226, field_22a; [ecx + n] field_23, field_25, field_2d, field_2f, field_222, field_23e; [edx + n] field_21, field_23, field_25, field_29, field_2f, field_222
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004cf1e4, FUN_0042639d, FUN_004c97b4, FUN_004cf276
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28c.c:m4cd243_read_tables (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 302 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_216, 0x216  # offset +0x216
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_23e, 0x23e  # offset +0x23e

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cf1e4, .text + (0x004cf1e4 - 0x401000)
.set FUN_004cf276, .text + (0x004cf276 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004cd243 - 0x401000
.globl FUN_004cd243
FUN_004cd243:
    # block 0x004cd243: entry, 9 instruction(s), ends with je to 0x004cd293 (forward)
    push ebp                                     # 004cd243
    {load} mov ebp, esp                          # 004cd244
    sub esp, 0x14                                # 004cd246
    push esi                                     # 004cd249
    push edi                                     # 004cd24a
    mov dword ptr [ebp - local_14], ecx          # 004cd24b
    mov eax, dword ptr [ebp - local_14]          # 004cd24e
    cmp dword ptr [eax + field_216], 0x0         # 004cd251
    je.d8 L_004cd293                             # 004cd258
    # block 0x004cd25a: entered by fall-through of je at 0x004cd258, 3 instruction(s), ends with je to 0x004cd28c (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004cd25a
    test ecx, ecx                                # 004cd261
    je.d8 L_004cd28c                             # 004cd263
    # block 0x004cd265: entered by fall-through of je at 0x004cd263, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cd28c
    movsx edx, word ptr [0x5c39e3]               # 004cd265
    push edx                                     # 004cd26c
    push 0x55907c                                # 004cd26d
    push 0x63888b                                # 004cd272
    call FUN_0050ca3e                            # 004cd277
    add esp, 0xc                                 # 004cd27c
    push 0x63888b                                # 004cd27f
    call FUN_0044a2b7                            # 004cd284
    add esp, 0x4                                 # 004cd289
L_004cd28c:
    # block 0x004cd28c: entered by je at 0x004cd263, 2 instruction(s), ends with forward jump to 0x004cd63d
    {load} xor eax, eax                          # 004cd28c
    jmp.d32 L_004cd63d                           # 004cd28e
L_004cd293:
    # block 0x004cd293: entered by je at 0x004cd258, 10 instruction(s), calls FUN_004cf1e4, ends with jne to 0x004cd2fb (forward)
    movsx eax, word ptr [0x5c39e3]               # 004cd293
    mov ecx, dword ptr [ebp - local_14]          # 004cd29a
    mov dword ptr [ecx + field_23e], eax         # 004cd29d
    push 0x27                                    # 004cd2a3
    mov edx, dword ptr [ebp + arg_8]             # 004cd2a5
    push edx                                     # 004cd2a8
    mov ecx, dword ptr [ebp - local_14]          # 004cd2a9
    call FUN_004cf1e4                            # 004cd2ac
    test eax, eax                                # 004cd2b1
    jne.d8 L_004cd2fb                            # 004cd2b3
    # block 0x004cd2b5: entered by fall-through of jne at 0x004cd2b3, 16 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004cd63d
    movsx eax, word ptr [0x5c39e3]               # 004cd2b5
    push eax                                     # 004cd2bc
    mov ecx, dword ptr [0x5bb57b]                # 004cd2bd
    push ecx                                     # 004cd2c3
    push 0x5590f8                                # 004cd2c4
    push 0x63888b                                # 004cd2c9
    call FUN_0050ca3e                            # 004cd2ce
    add esp, 0x10                                # 004cd2d3
    push 0x63888b                                # 004cd2d6
    push 0x559124                                # 004cd2db
    mov ecx, 0x583979                            # 004cd2e0
    call FUN_0042639d                            # 004cd2e5
    mov ecx, 0x5cf659                            # 004cd2ea
    call FUN_004c97b4                            # 004cd2ef
    {load} xor eax, eax                          # 004cd2f4
    jmp.d32 L_004cd63d                           # 004cd2f6
L_004cd2fb:
    # block 0x004cd2fb: entered by jne at 0x004cd2b3, 34 instruction(s), calls FUN_004cf1e4, ends with jne to 0x004cd3a3 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 004cd2fb
    mov esi, dword ptr [edx]                     # 004cd2fe
    mov eax, dword ptr [ebp + arg_8]             # 004cd300
    mov edi, dword ptr [eax]                     # 004cd303
    mov ecx, 0x9                                 # 004cd305
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cd30a
    movsw word ptr es:[edi], word ptr [esi]      # 004cd30c
    movsb byte ptr es:[edi], byte ptr [esi]      # 004cd30e
    mov ecx, dword ptr [ebp + arg_10]            # 004cd30f
    mov edx, dword ptr [ecx]                     # 004cd312
    add edx, 0x27                                # 004cd314
    mov eax, dword ptr [ebp + arg_10]            # 004cd317
    mov dword ptr [eax], edx                     # 004cd31a
    mov ecx, dword ptr [ebp + arg_c]             # 004cd31c
    mov edx, dword ptr [ecx]                     # 004cd31f
    add edx, 0x27                                # 004cd321
    mov eax, dword ptr [ebp + arg_c]             # 004cd324
    mov dword ptr [eax], edx                     # 004cd327
    mov ecx, dword ptr [ebp - local_14]          # 004cd329
    mov edx, dword ptr [ebp + arg_8]             # 004cd32c
    mov eax, dword ptr [edx]                     # 004cd32f
    mov dword ptr [ecx + field_222], eax         # 004cd331
    mov ecx, dword ptr [ebp - local_14]          # 004cd337
    mov edx, dword ptr [ecx + field_222]         # 004cd33a
    movsx eax, word ptr [edx + field_23]         # 004cd340
    imul eax, eax, 0x35                          # 004cd344
    push eax                                     # 004cd347
    mov ecx, dword ptr [ebp - local_14]          # 004cd348
    add ecx, 0x226                               # 004cd34b
    push ecx                                     # 004cd351
    mov ecx, dword ptr [ebp - local_14]          # 004cd352
    call FUN_004cf1e4                            # 004cd355
    test eax, eax                                # 004cd35a
    jne.d8 L_004cd3a3                            # 004cd35c
    # block 0x004cd35e: entered by fall-through of jne at 0x004cd35c, 16 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004cd63d
    movsx edx, word ptr [0x5c39e3]               # 004cd35e
    push edx                                     # 004cd365
    mov eax, dword ptr [0x5bb57b]                # 004cd366
    push eax                                     # 004cd36b
    push 0x559140                                # 004cd36c
    push 0x63888b                                # 004cd371
    call FUN_0050ca3e                            # 004cd376
    add esp, 0x10                                # 004cd37b
    push 0x63888b                                # 004cd37e
    push 0x559184                                # 004cd383
    mov ecx, 0x583979                            # 004cd388
    call FUN_0042639d                            # 004cd38d
    mov ecx, 0x5cf659                            # 004cd392
    call FUN_004c97b4                            # 004cd397
    {load} xor eax, eax                          # 004cd39c
    jmp.d32 L_004cd63d                           # 004cd39e
L_004cd3a3:
    # block 0x004cd3a3: entered by jne at 0x004cd35c, 3 instruction(s), ends with forward jump to 0x004cd3bc
    mov dword ptr [ebp - local_c], 0x0           # 004cd3a3
    mov dword ptr [ebp - local_8], 0x0           # 004cd3aa
    jmp.d8 L_004cd3bc                            # 004cd3b1
L_004cd3b3:
    # block 0x004cd3b3: entered by jmp at 0x004cd529, 3 instruction(s), falls into the block at 0x004cd3bc
    mov ecx, dword ptr [ebp - local_8]           # 004cd3b3
    add ecx, 0x1                                 # 004cd3b6
    mov dword ptr [ebp - local_8], ecx           # 004cd3b9
L_004cd3bc:
    # block 0x004cd3bc: entered by jmp at 0x004cd3b1, 5 instruction(s), ends with jge to 0x004cd52e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004cd3bc
    mov eax, dword ptr [edx + field_222]         # 004cd3bf
    movsx ecx, word ptr [eax + field_23]         # 004cd3c5
    cmp dword ptr [ebp - local_8], ecx           # 004cd3c9
    jge.d32 L_004cd52e                           # 004cd3cc
    # block 0x004cd3d2: entered by fall-through of jge at 0x004cd3cc, 71 instruction(s), calls FUN_004cf1e4, ends with jne to 0x004cd4f1 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cd3d2
    imul edx, edx, 0x35                          # 004cd3d5
    mov eax, dword ptr [ebp - local_14]          # 004cd3d8
    mov ecx, dword ptr [eax + field_226]         # 004cd3db
    {load} add ecx, edx                          # 004cd3e1
    mov dword ptr [ebp - local_10], ecx          # 004cd3e3
    mov edx, dword ptr [ebp + arg_c]             # 004cd3e6
    mov eax, dword ptr [edx]                     # 004cd3e9
    add eax, dword ptr [ebp - local_c]           # 004cd3eb
    mov dword ptr [ebp - local_4], eax           # 004cd3ee
    mov ecx, 0x8                                 # 004cd3f1
    mov esi, dword ptr [ebp - local_4]           # 004cd3f6
    mov edi, dword ptr [ebp - local_10]          # 004cd3f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cd3fc
    movsb byte ptr es:[edi], byte ptr [esi]      # 004cd3fe
    mov ecx, dword ptr [ebp - local_c]           # 004cd3ff
    add ecx, 0x21                                # 004cd402
    mov dword ptr [ebp - local_c], ecx           # 004cd405
    mov edx, dword ptr [ebp - local_10]          # 004cd408
    mov eax, dword ptr [ebp - local_4]           # 004cd40b
    mov cx, word ptr [eax + field_21]            # 004cd40e
    mov word ptr [edx + field_21], cx            # 004cd412
    mov edx, dword ptr [ebp - local_c]           # 004cd416
    add edx, 0x2                                 # 004cd419
    mov dword ptr [ebp - local_c], edx           # 004cd41c
    mov eax, dword ptr [ebp - local_10]          # 004cd41f
    mov ecx, dword ptr [ebp - local_4]           # 004cd422
    mov dx, word ptr [ecx + field_23]            # 004cd425
    mov word ptr [eax + field_23], dx            # 004cd429
    mov eax, dword ptr [ebp - local_c]           # 004cd42d
    add eax, 0x2                                 # 004cd430
    mov dword ptr [ebp - local_c], eax           # 004cd433
    mov ecx, dword ptr [ebp - local_10]          # 004cd436
    mov edx, dword ptr [ebp - local_4]           # 004cd439
    mov eax, dword ptr [edx + field_25]          # 004cd43c
    mov dword ptr [ecx + field_25], eax          # 004cd43f
    mov ecx, dword ptr [ebp - local_c]           # 004cd442
    add ecx, 0x4                                 # 004cd445
    mov dword ptr [ebp - local_c], ecx           # 004cd448
    mov edx, dword ptr [ebp - local_10]          # 004cd44b
    mov eax, dword ptr [ebp - local_4]           # 004cd44e
    mov ecx, dword ptr [eax + field_29]          # 004cd451
    mov dword ptr [edx + field_29], ecx          # 004cd454
    mov edx, dword ptr [ebp - local_c]           # 004cd457
    add edx, 0x4                                 # 004cd45a
    mov dword ptr [ebp - local_c], edx           # 004cd45d
    mov eax, dword ptr [ebp - local_10]          # 004cd460
    mov ecx, dword ptr [ebp - local_4]           # 004cd463
    mov dx, word ptr [ecx + field_2d]            # 004cd466
    mov word ptr [eax + field_2d], dx            # 004cd46a
    mov eax, dword ptr [ebp - local_c]           # 004cd46e
    add eax, 0x2                                 # 004cd471
    mov dword ptr [ebp - local_c], eax           # 004cd474
    mov ecx, dword ptr [ebp - local_10]          # 004cd477
    mov edx, dword ptr [ebp - local_4]           # 004cd47a
    mov ax, word ptr [edx + field_2f]            # 004cd47d
    mov word ptr [ecx + field_2f], ax            # 004cd481
    mov ecx, dword ptr [ebp - local_c]           # 004cd485
    add ecx, 0x2                                 # 004cd488
    mov dword ptr [ebp - local_c], ecx           # 004cd48b
    mov edx, dword ptr [ebp - local_10]          # 004cd48e
    movsx eax, word ptr [edx + field_2f]         # 004cd491
    imul eax, eax, 0x23                          # 004cd495
    push eax                                     # 004cd498
    mov ecx, dword ptr [ebp - local_10]          # 004cd499
    add ecx, 0x31                                # 004cd49c
    push ecx                                     # 004cd49f
    mov ecx, dword ptr [ebp - local_14]          # 004cd4a0
    call FUN_004cf1e4                            # 004cd4a3
    test eax, eax                                # 004cd4a8
    jne.d8 L_004cd4f1                            # 004cd4aa
    # block 0x004cd4ac: entered by fall-through of jne at 0x004cd4aa, 16 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004cd63d
    movsx edx, word ptr [0x5c39e3]               # 004cd4ac
    push edx                                     # 004cd4b3
    mov eax, dword ptr [0x5bb57b]                # 004cd4b4
    push eax                                     # 004cd4b9
    push 0x5591a0                                # 004cd4ba
    push 0x63888b                                # 004cd4bf
    call FUN_0050ca3e                            # 004cd4c4
    add esp, 0x10                                # 004cd4c9
    push 0x63888b                                # 004cd4cc
    push 0x5591e4                                # 004cd4d1
    mov ecx, 0x583979                            # 004cd4d6
    call FUN_0042639d                            # 004cd4db
    mov ecx, 0x5cf659                            # 004cd4e0
    call FUN_004c97b4                            # 004cd4e5
    {load} xor eax, eax                          # 004cd4ea
    jmp.d32 L_004cd63d                           # 004cd4ec
L_004cd4f1:
    # block 0x004cd4f1: entered by jne at 0x004cd4aa, 21 instruction(s), ends with backward jump to 0x004cd3b3
    mov ecx, dword ptr [ebp - local_10]          # 004cd4f1
    movsx ecx, word ptr [ecx + field_2f]         # 004cd4f4
    imul ecx, ecx, 0x23                          # 004cd4f8
    mov edx, dword ptr [ebp + arg_c]             # 004cd4fb
    mov esi, dword ptr [edx]                     # 004cd4fe
    add esi, dword ptr [ebp - local_c]           # 004cd500
    mov eax, dword ptr [ebp - local_10]          # 004cd503
    mov edi, dword ptr [eax + field_31]          # 004cd506
    {load} mov edx, ecx                          # 004cd509
    shr ecx, 0x2                                 # 004cd50b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cd50e
    {load} mov ecx, edx                          # 004cd510
    and ecx, 0x3                                 # 004cd512
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004cd515
    mov eax, dword ptr [ebp - local_10]          # 004cd517
    movsx ecx, word ptr [eax + field_2f]         # 004cd51a
    imul ecx, ecx, 0x23                          # 004cd51e
    mov edx, dword ptr [ebp - local_c]           # 004cd521
    {load} add edx, ecx                          # 004cd524
    mov dword ptr [ebp - local_c], edx           # 004cd526
    jmp.d32 L_004cd3b3                           # 004cd529
L_004cd52e:
    # block 0x004cd52e: entered by jge at 0x004cd3cc, 22 instruction(s), calls FUN_004cf1e4, ends with jne to 0x004cd5b4 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004cd52e
    mov ecx, dword ptr [eax]                     # 004cd531
    add ecx, dword ptr [ebp - local_c]           # 004cd533
    mov edx, dword ptr [ebp + arg_10]            # 004cd536
    mov dword ptr [edx], ecx                     # 004cd539
    mov eax, dword ptr [ebp + arg_c]             # 004cd53b
    mov ecx, dword ptr [eax]                     # 004cd53e
    add ecx, dword ptr [ebp - local_c]           # 004cd540
    mov edx, dword ptr [ebp + arg_c]             # 004cd543
    mov dword ptr [edx], ecx                     # 004cd546
    mov eax, dword ptr [ebp - local_14]          # 004cd548
    mov ecx, dword ptr [eax + field_222]         # 004cd54b
    movsx edx, word ptr [ecx + field_25]         # 004cd551
    imul edx, edx, 0x22                          # 004cd555
    push edx                                     # 004cd558
    mov eax, dword ptr [ebp - local_14]          # 004cd559
    add eax, 0x22a                               # 004cd55c
    push eax                                     # 004cd561
    mov ecx, dword ptr [ebp - local_14]          # 004cd562
    call FUN_004cf1e4                            # 004cd565
    test eax, eax                                # 004cd56a
    jne.d8 L_004cd5b4                            # 004cd56c
    # block 0x004cd56e: entered by fall-through of jne at 0x004cd56c, 16 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004cd63d
    movsx ecx, word ptr [0x5c39e3]               # 004cd56e
    push ecx                                     # 004cd575
    mov edx, dword ptr [0x5bb57b]                # 004cd576
    push edx                                     # 004cd57c
    push 0x559200                                # 004cd57d
    push 0x63888b                                # 004cd582
    call FUN_0050ca3e                            # 004cd587
    add esp, 0x10                                # 004cd58c
    push 0x63888b                                # 004cd58f
    push 0x559240                                # 004cd594
    mov ecx, 0x583979                            # 004cd599
    call FUN_0042639d                            # 004cd59e
    mov ecx, 0x5cf659                            # 004cd5a3
    call FUN_004c97b4                            # 004cd5a8
    {load} xor eax, eax                          # 004cd5ad
    jmp.d32 L_004cd63d                           # 004cd5af
L_004cd5b4:
    # block 0x004cd5b4: entered by jne at 0x004cd56c, 35 instruction(s), ends with je to 0x004cd638 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004cd5b4
    mov ecx, dword ptr [eax + field_222]         # 004cd5b7
    movsx ecx, word ptr [ecx + field_25]         # 004cd5bd
    imul ecx, ecx, 0x22                          # 004cd5c1
    mov edx, dword ptr [ebp + arg_c]             # 004cd5c4
    mov esi, dword ptr [edx]                     # 004cd5c7
    mov eax, dword ptr [ebp - local_14]          # 004cd5c9
    mov edi, dword ptr [eax + field_22a]         # 004cd5cc
    {load} mov edx, ecx                          # 004cd5d2
    shr ecx, 0x2                                 # 004cd5d4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cd5d7
    {load} mov ecx, edx                          # 004cd5d9
    and ecx, 0x3                                 # 004cd5db
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004cd5de
    mov eax, dword ptr [ebp - local_14]          # 004cd5e0
    mov ecx, dword ptr [eax + field_222]         # 004cd5e3
    movsx edx, word ptr [ecx + field_25]         # 004cd5e9
    imul edx, edx, 0x22                          # 004cd5ed
    mov eax, dword ptr [ebp + arg_10]            # 004cd5f0
    mov ecx, dword ptr [eax]                     # 004cd5f3
    {load} add ecx, edx                          # 004cd5f5
    mov edx, dword ptr [ebp + arg_10]            # 004cd5f7
    mov dword ptr [edx], ecx                     # 004cd5fa
    mov eax, dword ptr [ebp - local_14]          # 004cd5fc
    mov ecx, dword ptr [eax + field_222]         # 004cd5ff
    movsx edx, word ptr [ecx + field_25]         # 004cd605
    imul edx, edx, 0x22                          # 004cd609
    mov eax, dword ptr [ebp + arg_c]             # 004cd60c
    mov ecx, dword ptr [eax]                     # 004cd60f
    {load} add ecx, edx                          # 004cd611
    mov edx, dword ptr [ebp + arg_c]             # 004cd613
    mov dword ptr [edx], ecx                     # 004cd616
    movsx eax, word ptr [0x63a4cd]               # 004cd618
    test eax, eax                                # 004cd61f
    je.d8 L_004cd638                             # 004cd621
    # block 0x004cd623: entered by fall-through of je at 0x004cd621, 5 instruction(s), calls FUN_004cf276, FUN_0044a2b7, falls into the block at 0x004cd638
    mov ecx, dword ptr [ebp - local_14]          # 004cd623
    call FUN_004cf276                            # 004cd626
    push 0x55925c                                # 004cd62b
    call FUN_0044a2b7                            # 004cd630
    add esp, 0x4                                 # 004cd635
L_004cd638:
    # block 0x004cd638: entered by je at 0x004cd621, 1 instruction(s), falls into the block at 0x004cd63d
    mov eax, 0x1                                 # 004cd638
L_004cd63d:
    # block 0x004cd63d: entered by jmp at 0x004cd28e; jmp at 0x004cd2f6; jmp at 0x004cd39e; jmp at 0x004cd4ec; more, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004cd63d
    pop esi                                      # 004cd63e
    {load} mov esp, ebp                          # 004cd63f
    pop ebp                                      # 004cd641
    ret 0xc                                      # 004cd642

