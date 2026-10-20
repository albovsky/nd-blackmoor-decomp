# FUN_004c5377
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c5377
# extent:       0x004c5377-0x004c558b (532 code bytes)
# span:         0x004c5377-0x004c558b (code 532, tables 0, padding 0)
# sha256:       c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c5377_blit_rows
# naming:       native port src/original_methods_fl27b.c:m4c5377_blit_rows (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4c5377_blit_rows: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27b-handoff.md.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_64, local_78, local_88, local_8c, local_90, local_94, local_190, local_194, local_198 and 2 more
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4c5377_blit_rows (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 165 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_64, 0x64  # offset -0x64
.equ local_78, 0x78  # offset -0x78
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c5377 - 0x401000
.globl FUN_004c5377
FUN_004c5377:
    # block 0x004c5377: entry, 9 instruction(s), ends with je to 0x004c5473 (forward)
    push ebp                                     # 004c5377
    {load} mov ebp, esp                          # 004c5378
    sub esp, 0x1a0                               # 004c537a
    push esi                                     # 004c5380
    push edi                                     # 004c5381
    mov dword ptr [ebp - local_1a0], ecx         # 004c5382
    movsx eax, word ptr [0x63a4cd]               # 004c5388
    test eax, eax                                # 004c538f
    je.d32 L_004c5473                            # 004c5391
    # block 0x004c5397: entered by fall-through of je at 0x004c5391, 23 instruction(s), ends with jne to 0x004c5405 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c5397
    mov edx, dword ptr [ebp + arg_10]            # 004c539a
    mov eax, dword ptr [ecx + field_8]           # 004c539d
    sub eax, dword ptr [edx]                     # 004c53a0
    mov dword ptr [ebp - local_19c], eax         # 004c53a2
    mov ecx, dword ptr [ebp + arg_10]            # 004c53a8
    mov edx, dword ptr [ebp + arg_10]            # 004c53ab
    mov eax, dword ptr [ecx + field_c]           # 004c53ae
    sub eax, dword ptr [edx + field_4]           # 004c53b1
    mov dword ptr [ebp - local_198], eax         # 004c53b4
    mov ecx, dword ptr [ebp + arg_14]            # 004c53ba
    mov edx, dword ptr [ebp + arg_14]            # 004c53bd
    mov eax, dword ptr [ecx + field_8]           # 004c53c0
    sub eax, dword ptr [edx]                     # 004c53c3
    mov dword ptr [ebp - local_94], eax          # 004c53c5
    mov ecx, dword ptr [ebp + arg_14]            # 004c53cb
    mov edx, dword ptr [ebp + arg_14]            # 004c53ce
    mov eax, dword ptr [ecx + field_c]           # 004c53d1
    sub eax, dword ptr [edx + field_4]           # 004c53d4
    mov dword ptr [ebp - local_194], eax         # 004c53d7
    mov ecx, dword ptr [ebp - local_19c]         # 004c53dd
    cmp ecx, dword ptr [ebp - local_94]          # 004c53e3
    jne.d8 L_004c5405                            # 004c53e9
    # block 0x004c53eb: entered by fall-through of jne at 0x004c53e9, 3 instruction(s), ends with jne to 0x004c5405 (forward)
    mov edx, dword ptr [ebp - local_198]         # 004c53eb
    cmp edx, dword ptr [ebp - local_194]         # 004c53f1
    jne.d8 L_004c5405                            # 004c53f7
    # block 0x004c53f9: entered by fall-through of jne at 0x004c53f7, 2 instruction(s), ends with je to 0x004c5405 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c53f9
    je.d8 L_004c5405                             # 004c53fd
    # block 0x004c53ff: entered by fall-through of je at 0x004c53fd, 2 instruction(s), ends with jne to 0x004c5473 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c53ff
    jne.d8 L_004c5473                            # 004c5403
L_004c5405:
    # block 0x004c5405: entered by jne at 0x004c53e9; jne at 0x004c53f7; je at 0x004c53fd; fall-through of jne at 0x004c5403, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c5583
    mov eax, dword ptr [ebp + arg_14]            # 004c5405
    mov ecx, dword ptr [eax + field_c]           # 004c5408
    push ecx                                     # 004c540b
    mov edx, dword ptr [ebp + arg_14]            # 004c540c
    mov eax, dword ptr [edx + field_8]           # 004c540f
    push eax                                     # 004c5412
    mov ecx, dword ptr [ebp + arg_14]            # 004c5413
    mov edx, dword ptr [ecx + field_4]           # 004c5416
    push edx                                     # 004c5419
    mov eax, dword ptr [ebp + arg_14]            # 004c541a
    mov ecx, dword ptr [eax]                     # 004c541d
    push ecx                                     # 004c541f
    mov edx, dword ptr [ebp + arg_10]            # 004c5420
    mov eax, dword ptr [edx + field_c]           # 004c5423
    push eax                                     # 004c5426
    mov ecx, dword ptr [ebp + arg_10]            # 004c5427
    mov edx, dword ptr [ecx + field_8]           # 004c542a
    push edx                                     # 004c542d
    mov eax, dword ptr [ebp + arg_10]            # 004c542e
    mov ecx, dword ptr [eax + field_4]           # 004c5431
    push ecx                                     # 004c5434
    mov edx, dword ptr [ebp + arg_10]            # 004c5435
    mov eax, dword ptr [edx]                     # 004c5438
    push eax                                     # 004c543a
    mov ecx, dword ptr [ebp + arg_18]            # 004c543b
    push ecx                                     # 004c543e
    push 0x5548ec                                # 004c543f
    lea edx, [ebp - local_190]                   # 004c5444
    push edx                                     # 004c544a
    call FUN_0050ca3e                            # 004c544b
    add esp, 0x2c                                # 004c5450
    push 0x0                                     # 004c5453
    push 0x0                                     # 004c5455
    lea eax, [ebp - local_190]                   # 004c5457
    push eax                                     # 004c545d
    call FUN_0052139c                            # 004c545e
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5463
    call FUN_004c97b4                            # 004c5469
    jmp.d32 L_004c5583                           # 004c546e
L_004c5473:
    # block 0x004c5473: entered by je at 0x004c5391; jne at 0x004c5403, 43 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c550f
    mov ecx, dword ptr [ebp + arg_8]             # 004c5473
    movsx edx, word ptr [ecx + field_2f]         # 004c5476
    mov eax, dword ptr [ebp + arg_10]            # 004c547a
    mov ecx, dword ptr [eax + field_4]           # 004c547d
    imul ecx, edx                                # 004c5480
    mov edx, dword ptr [ebp + arg_8]             # 004c5483
    mov eax, dword ptr [edx]                     # 004c5486
    {load} add eax, ecx                          # 004c5488
    movsx ecx, word ptr [0x639895]               # 004c548a
    mov edx, dword ptr [ebp + arg_10]            # 004c5491
    mov edx, dword ptr [edx]                     # 004c5494
    imul edx, ecx                                # 004c5496
    {load} add eax, edx                          # 004c5499
    mov dword ptr [ebp - local_8], eax           # 004c549b
    push 0x20                                    # 004c549e
    mov eax, dword ptr [ebp + arg_18]            # 004c54a0
    push eax                                     # 004c54a3
    lea ecx, [ebp - local_88]                    # 004c54a4
    push ecx                                     # 004c54aa
    mov edx, dword ptr [ebp + arg_14]            # 004c54ab
    push edx                                     # 004c54ae
    mov eax, dword ptr [ebp + arg_c]             # 004c54af
    push eax                                     # 004c54b2
    mov ecx, dword ptr [ebp - local_1a0]         # 004c54b3
    call FUN_004c4067                            # 004c54b9
    mov ecx, dword ptr [ebp + arg_10]            # 004c54be
    mov edx, dword ptr [ebp + arg_10]            # 004c54c1
    mov eax, dword ptr [ecx + field_c]           # 004c54c4
    sub eax, dword ptr [edx + field_4]           # 004c54c7
    add eax, 0x1                                 # 004c54ca
    mov dword ptr [ebp - local_8c], eax          # 004c54cd
    mov ecx, dword ptr [ebp + arg_10]            # 004c54d3
    mov edx, dword ptr [ebp + arg_10]            # 004c54d6
    mov eax, dword ptr [ecx + field_8]           # 004c54d9
    sub eax, dword ptr [edx]                     # 004c54dc
    add eax, 0x1                                 # 004c54de
    movsx ecx, word ptr [0x639895]               # 004c54e1
    imul eax, ecx                                # 004c54e8
    mov dword ptr [ebp - local_c], eax           # 004c54eb
    mov edx, dword ptr [ebp - local_64]          # 004c54ee
    mov dword ptr [ebp - local_4], edx           # 004c54f1
    mov dword ptr [ebp - local_90], 0x0          # 004c54f4
    jmp.d8 L_004c550f                            # 004c54fe
L_004c5500:
    # block 0x004c5500: entered by jmp at 0x004c554c, 3 instruction(s), falls into the block at 0x004c550f
    mov eax, dword ptr [ebp - local_90]          # 004c5500
    add eax, 0x1                                 # 004c5506
    mov dword ptr [ebp - local_90], eax          # 004c5509
L_004c550f:
    # block 0x004c550f: entered by jmp at 0x004c54fe, 3 instruction(s), ends with jge to 0x004c554e (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c550f
    cmp ecx, dword ptr [ebp - local_8c]          # 004c5515
    jge.d8 L_004c554e                            # 004c551b
    # block 0x004c551d: entered by fall-through of jge at 0x004c551b, 18 instruction(s), ends with backward jump to 0x004c5500
    mov ecx, dword ptr [ebp - local_c]           # 004c551d
    mov esi, dword ptr [ebp - local_8]           # 004c5520
    mov edi, dword ptr [ebp - local_4]           # 004c5523
    {load} mov edx, ecx                          # 004c5526
    shr ecx, 0x2                                 # 004c5528
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c552b
    {load} mov ecx, edx                          # 004c552d
    and ecx, 0x3                                 # 004c552f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c5532
    mov eax, dword ptr [ebp + arg_8]             # 004c5534
    movsx ecx, word ptr [eax + field_2f]         # 004c5537
    mov edx, dword ptr [ebp - local_8]           # 004c553b
    {load} add edx, ecx                          # 004c553e
    mov dword ptr [ebp - local_8], edx           # 004c5540
    mov eax, dword ptr [ebp - local_4]           # 004c5543
    add eax, dword ptr [ebp - local_78]          # 004c5546
    mov dword ptr [ebp - local_4], eax           # 004c5549
    jmp.d8 L_004c5500                            # 004c554c
L_004c554e:
    # block 0x004c554e: entered by jge at 0x004c551b, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c5583 (forward)
    push 0x554990                                # 004c554e
    mov ecx, dword ptr [ebp + arg_14]            # 004c5553
    push ecx                                     # 004c5556
    mov edx, dword ptr [ebp + arg_c]             # 004c5557
    push edx                                     # 004c555a
    mov ecx, dword ptr [ebp - local_1a0]         # 004c555b
    call FUN_004c4202                            # 004c5561
    mov eax, dword ptr [ebp - local_1a0]         # 004c5566
    mov ecx, dword ptr [ebp + arg_c]             # 004c556c
    cmp ecx, dword ptr [eax + field_c]           # 004c556f
    jne.d8 L_004c5583                            # 004c5572
    # block 0x004c5574: entered by fall-through of jne at 0x004c5572, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c5583
    mov edx, dword ptr [ebp + arg_14]            # 004c5574
    push edx                                     # 004c5577
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5578
    call FUN_004c952f                            # 004c557e
L_004c5583:
    # block 0x004c5583: entered by jmp at 0x004c546e; jne at 0x004c5572, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c5583
    pop esi                                      # 004c5584
    {load} mov esp, ebp                          # 004c5585
    pop ebp                                      # 004c5587
    ret 0x14                                     # 004c5588

