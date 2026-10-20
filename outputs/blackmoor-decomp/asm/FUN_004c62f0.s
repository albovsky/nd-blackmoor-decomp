# FUN_004c62f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c62f0
# extent:       0x004c62f0-0x004c6929 (1593 code bytes)
# span:         0x004c62f0-0x004c6929 (code 1593, tables 0, padding 0)
# sha256:       4ceeadff45d34858cb017ccd7176fa8443e84c6467ec2dd77ceaf50769030e7c
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_alpha_blend_blit
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d9_runtime.h:206 says "0x4c62f0 DFBltAlpha: dst = bg + trunc((puzzle - bg) * alpha) per channel"
# name-note:    DFBltAlpha: blends the puzzle surface over the background per channel by an alpha value.
# arguments:    9 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28; ret 0x24 (callee pops 36 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       37 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_74, local_88, local_98, local_9c, local_a0 and 25 more
# fields:       [eax + n] field_4, field_8, field_c, field_2f; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c, field_2f
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_0050ce04, FUN_004c4202, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.h:d9_blit_alpha (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 437 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_74, 0x74  # offset -0x74
.equ local_88, 0x88  # offset -0x88
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_cc, 0xcc  # offset -0xcc
.equ local_d0, 0xd0  # offset -0xd0
.equ local_d4, 0xd4  # offset -0xd4
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc
.equ local_2d8, 0x2d8  # offset -0x2d8
.equ local_2dc, 0x2dc  # offset -0x2dc
.equ local_2e0, 0x2e0  # offset -0x2e0
.equ local_2e4, 0x2e4  # offset -0x2e4
.equ local_2e8, 0x2e8  # offset -0x2e8
.equ local_2ec, 0x2ec  # offset -0x2ec
.equ local_2f0, 0x2f0  # offset -0x2f0
.equ local_2f4, 0x2f4  # offset -0x2f4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c62f0 - 0x401000
.globl FUN_004c62f0
FUN_004c62f0:
    # block 0x004c62f0: entry, 9 instruction(s), ends with je to 0x004c6546 (forward)
    push ebp                                     # 004c62f0
    {load} mov ebp, esp                          # 004c62f1
    sub esp, 0x2f4                               # 004c62f3
    push esi                                     # 004c62f9
    push edi                                     # 004c62fa
    mov dword ptr [ebp - local_2dc], ecx         # 004c62fb
    movsx eax, word ptr [0x63a4cd]               # 004c6301
    test eax, eax                                # 004c6308
    je.d32 L_004c6546                            # 004c630a
    # block 0x004c6310: entered by fall-through of je at 0x004c630a, 76 instruction(s), calls FUN_0050ca3e, ends with jne to 0x004c641a (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 004c6310
    mov edx, dword ptr [ebp + arg_18]            # 004c6313
    mov eax, dword ptr [ecx + field_8]           # 004c6316
    sub eax, dword ptr [edx]                     # 004c6319
    mov dword ptr [ebp - local_dc], eax          # 004c631b
    mov ecx, dword ptr [ebp + arg_18]            # 004c6321
    mov edx, dword ptr [ebp + arg_18]            # 004c6324
    mov eax, dword ptr [ecx + field_c]           # 004c6327
    sub eax, dword ptr [edx + field_4]           # 004c632a
    mov dword ptr [ebp - local_d8], eax          # 004c632d
    mov ecx, dword ptr [ebp + arg_1c]            # 004c6333
    mov edx, dword ptr [ebp + arg_1c]            # 004c6336
    mov eax, dword ptr [ecx + field_8]           # 004c6339
    sub eax, dword ptr [edx]                     # 004c633c
    mov dword ptr [ebp - local_d0], eax          # 004c633e
    mov ecx, dword ptr [ebp + arg_1c]            # 004c6344
    mov edx, dword ptr [ebp + arg_1c]            # 004c6347
    mov eax, dword ptr [ecx + field_c]           # 004c634a
    sub eax, dword ptr [edx + field_4]           # 004c634d
    mov dword ptr [ebp - local_cc], eax          # 004c6350
    mov ecx, dword ptr [ebp + arg_20]            # 004c6356
    mov edx, dword ptr [ebp + arg_20]            # 004c6359
    mov eax, dword ptr [ecx + field_8]           # 004c635c
    sub eax, dword ptr [edx]                     # 004c635f
    mov dword ptr [ebp - local_d4], eax          # 004c6361
    mov ecx, dword ptr [ebp + arg_20]            # 004c6367
    mov edx, dword ptr [ebp + arg_20]            # 004c636a
    mov eax, dword ptr [ecx + field_c]           # 004c636d
    sub eax, dword ptr [edx + field_4]           # 004c6370
    mov dword ptr [ebp - local_1dc], eax         # 004c6373
    mov ecx, dword ptr [ebp + arg_20]            # 004c6379
    mov edx, dword ptr [ecx + field_c]           # 004c637c
    push edx                                     # 004c637f
    mov eax, dword ptr [ebp + arg_20]            # 004c6380
    mov ecx, dword ptr [eax + field_8]           # 004c6383
    push ecx                                     # 004c6386
    mov edx, dword ptr [ebp + arg_20]            # 004c6387
    mov eax, dword ptr [edx + field_4]           # 004c638a
    push eax                                     # 004c638d
    mov ecx, dword ptr [ebp + arg_20]            # 004c638e
    mov edx, dword ptr [ecx]                     # 004c6391
    push edx                                     # 004c6393
    mov eax, dword ptr [ebp + arg_1c]            # 004c6394
    mov ecx, dword ptr [eax + field_c]           # 004c6397
    push ecx                                     # 004c639a
    mov edx, dword ptr [ebp + arg_1c]            # 004c639b
    mov eax, dword ptr [edx + field_8]           # 004c639e
    push eax                                     # 004c63a1
    mov ecx, dword ptr [ebp + arg_1c]            # 004c63a2
    mov edx, dword ptr [ecx + field_4]           # 004c63a5
    push edx                                     # 004c63a8
    mov eax, dword ptr [ebp + arg_1c]            # 004c63a9
    mov ecx, dword ptr [eax]                     # 004c63ac
    push ecx                                     # 004c63ae
    mov edx, dword ptr [ebp + arg_18]            # 004c63af
    mov eax, dword ptr [edx + field_c]           # 004c63b2
    push eax                                     # 004c63b5
    mov ecx, dword ptr [ebp + arg_18]            # 004c63b6
    mov edx, dword ptr [ecx + field_8]           # 004c63b9
    push edx                                     # 004c63bc
    mov eax, dword ptr [ebp + arg_18]            # 004c63bd
    mov ecx, dword ptr [eax + field_4]           # 004c63c0
    push ecx                                     # 004c63c3
    mov edx, dword ptr [ebp + arg_18]            # 004c63c4
    mov eax, dword ptr [edx]                     # 004c63c7
    push eax                                     # 004c63c9
    mov ecx, dword ptr [ebp + arg_28]            # 004c63ca
    push ecx                                     # 004c63cd
    push 0x554f24                                # 004c63ce
    lea edx, [ebp - local_2d8]                   # 004c63d3
    push edx                                     # 004c63d9
    call FUN_0050ca3e                            # 004c63da
    add esp, 0x3c                                # 004c63df
    mov eax, dword ptr [ebp - local_dc]          # 004c63e2
    cmp eax, dword ptr [ebp - local_d4]          # 004c63e8
    jne.d8 L_004c641a                            # 004c63ee
    # block 0x004c63f0: entered by fall-through of jne at 0x004c63ee, 3 instruction(s), ends with jne to 0x004c641a (forward)
    mov ecx, dword ptr [ebp - local_d8]          # 004c63f0
    cmp ecx, dword ptr [ebp - local_1dc]         # 004c63f6
    jne.d8 L_004c641a                            # 004c63fc
    # block 0x004c63fe: entered by fall-through of jne at 0x004c63fc, 3 instruction(s), ends with jne to 0x004c641a (forward)
    mov edx, dword ptr [ebp - local_d0]          # 004c63fe
    cmp edx, dword ptr [ebp - local_d4]          # 004c6404
    jne.d8 L_004c641a                            # 004c640a
    # block 0x004c640c: entered by fall-through of jne at 0x004c640a, 3 instruction(s), ends with je to 0x004c6455 (forward)
    mov eax, dword ptr [ebp - local_cc]          # 004c640c
    cmp eax, dword ptr [ebp - local_1dc]         # 004c6412
    je.d8 L_004c6455                             # 004c6418
L_004c641a:
    # block 0x004c641a: entered by jne at 0x004c63ee; jne at 0x004c63fc; jne at 0x004c640a; fall-through of je at 0x004c6418, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6921
    lea ecx, [ebp - local_2d8]                   # 004c641a
    push ecx                                     # 004c6420
    push 0x554f88                                # 004c6421
    lea edx, [ebp - local_1d8]                   # 004c6426
    push edx                                     # 004c642c
    call FUN_0050ca3e                            # 004c642d
    add esp, 0xc                                 # 004c6432
    push 0x0                                     # 004c6435
    push 0x0                                     # 004c6437
    lea eax, [ebp - local_1d8]                   # 004c6439
    push eax                                     # 004c643f
    call FUN_0052139c                            # 004c6440
    mov ecx, dword ptr [ebp - local_2dc]         # 004c6445
    call FUN_004c97b4                            # 004c644b
    jmp.d32 L_004c6921                           # 004c6450
L_004c6455:
    # block 0x004c6455: entered by je at 0x004c6418, 2 instruction(s), ends with je to 0x004c6467 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c6455
    je.d8 L_004c6467                             # 004c6459
    # block 0x004c645b: entered by fall-through of je at 0x004c6459, 2 instruction(s), ends with je to 0x004c6467 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c645b
    je.d8 L_004c6467                             # 004c645f
    # block 0x004c6461: entered by fall-through of je at 0x004c645f, 2 instruction(s), ends with jne to 0x004c64a2 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 004c6461
    jne.d8 L_004c64a2                            # 004c6465
L_004c6467:
    # block 0x004c6467: entered by je at 0x004c6459; je at 0x004c645f; fall-through of jne at 0x004c6465, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6921
    lea ecx, [ebp - local_2d8]                   # 004c6467
    push ecx                                     # 004c646d
    push 0x554fcc                                # 004c646e
    lea edx, [ebp - local_1d8]                   # 004c6473
    push edx                                     # 004c6479
    call FUN_0050ca3e                            # 004c647a
    add esp, 0xc                                 # 004c647f
    push 0x0                                     # 004c6482
    push 0x0                                     # 004c6484
    lea eax, [ebp - local_1d8]                   # 004c6486
    push eax                                     # 004c648c
    call FUN_0052139c                            # 004c648d
    mov ecx, dword ptr [ebp - local_2dc]         # 004c6492
    call FUN_004c97b4                            # 004c6498
    jmp.d32 L_004c6921                           # 004c649d
L_004c64a2:
    # block 0x004c64a2: entered by jne at 0x004c6465, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 004c64a2
    cmp dword ptr [ecx + field_8], 0x0           # 004c64a5
    jl.d8 L_004c650b                             # 004c64a9
    # block 0x004c64ab: entered by fall-through of jl at 0x004c64a9, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov edx, dword ptr [ebp + arg_18]            # 004c64ab
    cmp dword ptr [edx], 0x0                     # 004c64ae
    jl.d8 L_004c650b                             # 004c64b1
    # block 0x004c64b3: entered by fall-through of jl at 0x004c64b1, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov eax, dword ptr [ebp + arg_18]            # 004c64b3
    cmp dword ptr [eax + field_c], 0x0           # 004c64b6
    jl.d8 L_004c650b                             # 004c64ba
    # block 0x004c64bc: entered by fall-through of jl at 0x004c64ba, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 004c64bc
    cmp dword ptr [ecx + field_4], 0x0           # 004c64bf
    jl.d8 L_004c650b                             # 004c64c3
    # block 0x004c64c5: entered by fall-through of jl at 0x004c64c3, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov edx, dword ptr [ebp + arg_1c]            # 004c64c5
    cmp dword ptr [edx + field_8], 0x0           # 004c64c8
    jl.d8 L_004c650b                             # 004c64cc
    # block 0x004c64ce: entered by fall-through of jl at 0x004c64cc, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov eax, dword ptr [ebp + arg_1c]            # 004c64ce
    cmp dword ptr [eax], 0x0                     # 004c64d1
    jl.d8 L_004c650b                             # 004c64d4
    # block 0x004c64d6: entered by fall-through of jl at 0x004c64d4, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov ecx, dword ptr [ebp + arg_1c]            # 004c64d6
    cmp dword ptr [ecx + field_c], 0x0           # 004c64d9
    jl.d8 L_004c650b                             # 004c64dd
    # block 0x004c64df: entered by fall-through of jl at 0x004c64dd, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov edx, dword ptr [ebp + arg_1c]            # 004c64df
    cmp dword ptr [edx + field_4], 0x0           # 004c64e2
    jl.d8 L_004c650b                             # 004c64e6
    # block 0x004c64e8: entered by fall-through of jl at 0x004c64e6, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov eax, dword ptr [ebp + arg_20]            # 004c64e8
    cmp dword ptr [eax + field_8], 0x0           # 004c64eb
    jl.d8 L_004c650b                             # 004c64ef
    # block 0x004c64f1: entered by fall-through of jl at 0x004c64ef, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov ecx, dword ptr [ebp + arg_20]            # 004c64f1
    cmp dword ptr [ecx], 0x0                     # 004c64f4
    jl.d8 L_004c650b                             # 004c64f7
    # block 0x004c64f9: entered by fall-through of jl at 0x004c64f7, 3 instruction(s), ends with jl to 0x004c650b (forward)
    mov edx, dword ptr [ebp + arg_20]            # 004c64f9
    cmp dword ptr [edx + field_c], 0x0           # 004c64fc
    jl.d8 L_004c650b                             # 004c6500
    # block 0x004c6502: entered by fall-through of jl at 0x004c6500, 3 instruction(s), ends with jge to 0x004c6546 (forward)
    mov eax, dword ptr [ebp + arg_20]            # 004c6502
    cmp dword ptr [eax + field_4], 0x0           # 004c6505
    jge.d8 L_004c6546                            # 004c6509
L_004c650b:
    # block 0x004c650b: entered by jl at 0x004c64a9; jl at 0x004c64b1; jl at 0x004c64ba; jl at 0x004c64c3; more, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6921
    lea ecx, [ebp - local_2d8]                   # 004c650b
    push ecx                                     # 004c6511
    push 0x554ffc                                # 004c6512
    lea edx, [ebp - local_1d8]                   # 004c6517
    push edx                                     # 004c651d
    call FUN_0050ca3e                            # 004c651e
    add esp, 0xc                                 # 004c6523
    push 0x0                                     # 004c6526
    push 0x0                                     # 004c6528
    lea eax, [ebp - local_1d8]                   # 004c652a
    push eax                                     # 004c6530
    call FUN_0052139c                            # 004c6531
    mov ecx, dword ptr [ebp - local_2dc]         # 004c6536
    call FUN_004c97b4                            # 004c653c
    jmp.d32 L_004c6921                           # 004c6541
L_004c6546:
    # block 0x004c6546: entered by je at 0x004c630a; jge at 0x004c6509, 78 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c6649
    push 0x20                                    # 004c6546
    mov ecx, dword ptr [ebp + arg_28]            # 004c6548
    push ecx                                     # 004c654b
    lea edx, [ebp - local_98]                    # 004c654c
    push edx                                     # 004c6552
    mov eax, dword ptr [ebp + arg_20]            # 004c6553
    push eax                                     # 004c6556
    mov ecx, dword ptr [ebp + arg_10]            # 004c6557
    push ecx                                     # 004c655a
    mov ecx, dword ptr [ebp - local_2dc]         # 004c655b
    call FUN_004c4067                            # 004c6561
    mov edx, dword ptr [ebp + arg_8]             # 004c6566
    movsx eax, word ptr [edx + field_2f]         # 004c6569
    cdq                                          # 004c656d
    {load} sub eax, edx                          # 004c656e
    sar eax                                      # 004c6570
    mov dword ptr [ebp - local_a8], eax          # 004c6572
    mov eax, dword ptr [ebp - local_88]          # 004c6578
    cdq                                          # 004c657e
    {load} sub eax, edx                          # 004c657f
    sar eax                                      # 004c6581
    mov dword ptr [ebp - local_bc], eax          # 004c6583
    mov eax, dword ptr [ebp + arg_8]             # 004c6589
    movsx ecx, word ptr [eax + field_2f]         # 004c658c
    mov edx, dword ptr [ebp + arg_18]            # 004c6590
    mov eax, dword ptr [edx + field_4]           # 004c6593
    imul eax, ecx                                # 004c6596
    mov ecx, dword ptr [ebp + arg_8]             # 004c6599
    mov edx, dword ptr [ecx]                     # 004c659c
    {load} add edx, eax                          # 004c659e
    movsx eax, word ptr [0x639895]               # 004c65a0
    mov ecx, dword ptr [ebp + arg_18]            # 004c65a7
    mov ecx, dword ptr [ecx]                     # 004c65aa
    imul ecx, eax                                # 004c65ac
    {load} add edx, ecx                          # 004c65af
    mov dword ptr [ebp - local_14], edx          # 004c65b1
    mov edx, dword ptr [ebp + arg_c]             # 004c65b4
    movsx eax, word ptr [edx + field_2f]         # 004c65b7
    mov ecx, dword ptr [ebp + arg_1c]            # 004c65bb
    mov edx, dword ptr [ecx + field_4]           # 004c65be
    imul edx, eax                                # 004c65c1
    mov eax, dword ptr [ebp + arg_c]             # 004c65c4
    mov ecx, dword ptr [eax]                     # 004c65c7
    {load} add ecx, edx                          # 004c65c9
    movsx edx, word ptr [0x639895]               # 004c65cb
    mov eax, dword ptr [ebp + arg_1c]            # 004c65d2
    mov eax, dword ptr [eax]                     # 004c65d5
    imul eax, edx                                # 004c65d7
    {load} add ecx, eax                          # 004c65da
    mov dword ptr [ebp - local_1c], ecx          # 004c65dc
    mov ecx, dword ptr [ebp + arg_24]            # 004c65df
    mov edx, dword ptr [ecx + field_8]           # 004c65e2
    add edx, 0x1                                 # 004c65e5
    mov eax, dword ptr [ebp + arg_24]            # 004c65e8
    mov ecx, dword ptr [eax + field_4]           # 004c65eb
    imul ecx, edx                                # 004c65ee
    mov edx, dword ptr [ebp + arg_14]            # 004c65f1
    lea eax, [edx + 4*ecx]                       # 004c65f4
    mov ecx, dword ptr [ebp + arg_24]            # 004c65f7
    mov edx, dword ptr [ecx]                     # 004c65fa
    lea eax, [eax + 4*edx]                       # 004c65fc
    mov dword ptr [ebp - local_9c], eax          # 004c65ff
    mov ecx, dword ptr [ebp + arg_18]            # 004c6605
    mov edx, dword ptr [ebp + arg_18]            # 004c6608
    mov eax, dword ptr [ecx + field_c]           # 004c660b
    sub eax, dword ptr [edx + field_4]           # 004c660e
    add eax, 0x1                                 # 004c6611
    mov dword ptr [ebp - local_a4], eax          # 004c6614
    mov ecx, dword ptr [ebp + arg_18]            # 004c661a
    mov edx, dword ptr [ebp + arg_18]            # 004c661d
    mov eax, dword ptr [ecx + field_8]           # 004c6620
    sub eax, dword ptr [edx]                     # 004c6623
    add eax, 0x1                                 # 004c6625
    mov dword ptr [ebp - local_b0], eax          # 004c6628
    mov ecx, dword ptr [ebp - local_74]          # 004c662e
    mov dword ptr [ebp - local_a0], ecx          # 004c6631
    mov dword ptr [ebp - local_8], 0x0           # 004c6637
    jmp.d8 L_004c6649                            # 004c663e
L_004c6640:
    # block 0x004c6640: entered by jmp at 0x004c68e7, 3 instruction(s), falls into the block at 0x004c6649
    mov edx, dword ptr [ebp - local_8]           # 004c6640
    add edx, 0x1                                 # 004c6643
    mov dword ptr [ebp - local_8], edx           # 004c6646
L_004c6649:
    # block 0x004c6649: entered by jmp at 0x004c663e, 3 instruction(s), ends with jge to 0x004c68ec (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c6649
    cmp eax, dword ptr [ebp - local_a4]          # 004c664c
    jge.d32 L_004c68ec                           # 004c6652
    # block 0x004c6658: entered by fall-through of jge at 0x004c6652, 2 instruction(s), ends with forward jump to 0x004c666a
    mov dword ptr [ebp - local_4], 0x0           # 004c6658
    jmp.d8 L_004c666a                            # 004c665f
L_004c6661:
    # block 0x004c6661: entered by jmp at 0x004c6899, 3 instruction(s), falls into the block at 0x004c666a
    mov ecx, dword ptr [ebp - local_4]           # 004c6661
    add ecx, 0x1                                 # 004c6664
    mov dword ptr [ebp - local_4], ecx           # 004c6667
L_004c666a:
    # block 0x004c666a: entered by jmp at 0x004c665f, 3 instruction(s), ends with jge to 0x004c689e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c666a
    cmp edx, dword ptr [ebp - local_b0]          # 004c666d
    jge.d32 L_004c689e                           # 004c6673
    # block 0x004c6679: entered by fall-through of jge at 0x004c6673, 126 instruction(s), calls FUN_0050ce04, ends with backward jump to 0x004c6661
    mov eax, dword ptr [ebp - local_4]           # 004c6679
    mov ecx, dword ptr [ebp - local_14]          # 004c667c
    mov dx, word ptr [ecx + 2*eax]               # 004c667f
    mov word ptr [ebp - local_c8], dx            # 004c6683
    mov eax, dword ptr [ebp - local_c8]          # 004c668a
    and eax, 0xffff                              # 004c6690
    {load} xor ecx, ecx                          # 004c6695
    mov cl, byte ptr [0x5d2f1b]                  # 004c6697
    sar eax, cl                                  # 004c669d
    {load} xor ecx, ecx                          # 004c669f
    mov cl, byte ptr [0x5d2f1f]                  # 004c66a1
    {load} and eax, ecx                          # 004c66a7
    mov word ptr [ebp - local_10], ax            # 004c66a9
    mov edx, dword ptr [ebp - local_c8]          # 004c66ad
    and edx, 0xffff                              # 004c66b3
    {load} xor ecx, ecx                          # 004c66b9
    mov cl, byte ptr [0x5d2f1a]                  # 004c66bb
    sar edx, cl                                  # 004c66c1
    {load} xor eax, eax                          # 004c66c3
    mov al, byte ptr [0x5d2f1e]                  # 004c66c5
    {load} and edx, eax                          # 004c66ca
    mov word ptr [ebp - local_ac], dx            # 004c66cc
    mov edx, dword ptr [ebp - local_c8]          # 004c66d3
    and edx, 0xffff                              # 004c66d9
    {load} xor ecx, ecx                          # 004c66df
    mov cl, byte ptr [0x5d2f19]                  # 004c66e1
    sar edx, cl                                  # 004c66e7
    {load} xor eax, eax                          # 004c66e9
    mov al, byte ptr [0x5d2f1d]                  # 004c66eb
    {load} and edx, eax                          # 004c66f0
    mov word ptr [ebp - local_c], dx             # 004c66f2
    mov ecx, dword ptr [ebp - local_4]           # 004c66f6
    mov edx, dword ptr [ebp - local_1c]          # 004c66f9
    mov ax, word ptr [edx + 2*ecx]               # 004c66fc
    mov word ptr [ebp - local_b4], ax            # 004c6700
    mov edx, dword ptr [ebp - local_b4]          # 004c6707
    and edx, 0xffff                              # 004c670d
    {load} xor ecx, ecx                          # 004c6713
    mov cl, byte ptr [0x5d2f1b]                  # 004c6715
    sar edx, cl                                  # 004c671b
    {load} xor eax, eax                          # 004c671d
    mov al, byte ptr [0x5d2f1f]                  # 004c671f
    {load} and edx, eax                          # 004c6724
    mov word ptr [ebp - local_c4], dx            # 004c6726
    mov edx, dword ptr [ebp - local_b4]          # 004c672d
    and edx, 0xffff                              # 004c6733
    {load} xor ecx, ecx                          # 004c6739
    mov cl, byte ptr [0x5d2f1a]                  # 004c673b
    sar edx, cl                                  # 004c6741
    {load} xor eax, eax                          # 004c6743
    mov al, byte ptr [0x5d2f1e]                  # 004c6745
    {load} and edx, eax                          # 004c674a
    mov word ptr [ebp - local_18], dx            # 004c674c
    mov edx, dword ptr [ebp - local_b4]          # 004c6750
    and edx, 0xffff                              # 004c6756
    {load} xor ecx, ecx                          # 004c675c
    mov cl, byte ptr [0x5d2f19]                  # 004c675e
    sar edx, cl                                  # 004c6764
    {load} xor eax, eax                          # 004c6766
    mov al, byte ptr [0x5d2f1d]                  # 004c6768
    {load} and edx, eax                          # 004c676d
    mov word ptr [ebp - local_c0], dx            # 004c676f
    mov ecx, dword ptr [ebp - local_4]           # 004c6776
    mov edx, dword ptr [ebp - local_9c]          # 004c6779
    mov eax, dword ptr [edx + 4*ecx]             # 004c677f
    mov dword ptr [ebp - local_b8], eax          # 004c6782
    mov esi, dword ptr [ebp - local_c4]          # 004c6788
    and esi, 0xffff                              # 004c678e
    mov ecx, dword ptr [ebp - local_10]          # 004c6794
    and ecx, 0xffff                              # 004c6797
    mov edx, dword ptr [ebp - local_c4]          # 004c679d
    and edx, 0xffff                              # 004c67a3
    {load} sub ecx, edx                          # 004c67a9
    mov dword ptr [ebp - local_2e0], ecx         # 004c67ab
    fild dword ptr [ebp - local_2e0]             # 004c67b1
    fstp dword ptr [ebp - local_2e4]             # 004c67b7
    fld dword ptr [ebp - local_2e4]              # 004c67bd
    fmul dword ptr [ebp - local_b8]              # 004c67c3
    call FUN_0050ce04                            # 004c67c9
    and eax, 0xffff                              # 004c67ce
    {load} add esi, eax                          # 004c67d3
    {load} xor ecx, ecx                          # 004c67d5
    mov cl, byte ptr [0x5d2f1b]                  # 004c67d7
    shl esi, cl                                  # 004c67dd
    mov edi, dword ptr [ebp - local_18]          # 004c67df
    and edi, 0xffff                              # 004c67e2
    mov eax, dword ptr [ebp - local_ac]          # 004c67e8
    and eax, 0xffff                              # 004c67ee
    mov ecx, dword ptr [ebp - local_18]          # 004c67f3
    and ecx, 0xffff                              # 004c67f6
    {load} sub eax, ecx                          # 004c67fc
    mov dword ptr [ebp - local_2e8], eax         # 004c67fe
    fild dword ptr [ebp - local_2e8]             # 004c6804
    fstp dword ptr [ebp - local_2ec]             # 004c680a
    fld dword ptr [ebp - local_2ec]              # 004c6810
    fmul dword ptr [ebp - local_b8]              # 004c6816
    call FUN_0050ce04                            # 004c681c
    and eax, 0xffff                              # 004c6821
    {load} add edi, eax                          # 004c6826
    {load} xor ecx, ecx                          # 004c6828
    mov cl, byte ptr [0x5d2f1a]                  # 004c682a
    shl edi, cl                                  # 004c6830
    {load} or esi, edi                           # 004c6832
    mov edi, dword ptr [ebp - local_c0]          # 004c6834
    and edi, 0xffff                              # 004c683a
    mov edx, dword ptr [ebp - local_c]           # 004c6840
    and edx, 0xffff                              # 004c6843
    mov eax, dword ptr [ebp - local_c0]          # 004c6849
    and eax, 0xffff                              # 004c684f
    {load} sub edx, eax                          # 004c6854
    mov dword ptr [ebp - local_2f0], edx         # 004c6856
    fild dword ptr [ebp - local_2f0]             # 004c685c
    fstp dword ptr [ebp - local_2f4]             # 004c6862
    fld dword ptr [ebp - local_2f4]              # 004c6868
    fmul dword ptr [ebp - local_b8]              # 004c686e
    call FUN_0050ce04                            # 004c6874
    and eax, 0xffff                              # 004c6879
    {load} add edi, eax                          # 004c687e
    {load} xor ecx, ecx                          # 004c6880
    mov cl, byte ptr [0x5d2f19]                  # 004c6882
    shl edi, cl                                  # 004c6888
    {load} or esi, edi                           # 004c688a
    mov ecx, dword ptr [ebp - local_4]           # 004c688c
    mov edx, dword ptr [ebp - local_a0]          # 004c688f
    mov word ptr [edx + 2*ecx], si               # 004c6895
    jmp.d32 L_004c6661                           # 004c6899
L_004c689e:
    # block 0x004c689e: entered by jge at 0x004c6673, 18 instruction(s), ends with backward jump to 0x004c6640
    mov eax, dword ptr [ebp - local_a8]          # 004c689e
    mov ecx, dword ptr [ebp - local_14]          # 004c68a4
    lea edx, [ecx + 2*eax]                       # 004c68a7
    mov dword ptr [ebp - local_14], edx          # 004c68aa
    mov eax, dword ptr [ebp - local_a8]          # 004c68ad
    mov ecx, dword ptr [ebp - local_1c]          # 004c68b3
    lea edx, [ecx + 2*eax]                       # 004c68b6
    mov dword ptr [ebp - local_1c], edx          # 004c68b9
    mov eax, dword ptr [ebp - local_bc]          # 004c68bc
    mov ecx, dword ptr [ebp - local_a0]          # 004c68c2
    lea edx, [ecx + 2*eax]                       # 004c68c8
    mov dword ptr [ebp - local_a0], edx          # 004c68cb
    mov eax, dword ptr [ebp + arg_24]            # 004c68d1
    mov ecx, dword ptr [eax + field_8]           # 004c68d4
    mov edx, dword ptr [ebp - local_9c]          # 004c68d7
    lea eax, [edx + 4*ecx + field_4]             # 004c68dd
    mov dword ptr [ebp - local_9c], eax          # 004c68e1
    jmp.d32 L_004c6640                           # 004c68e7
L_004c68ec:
    # block 0x004c68ec: entered by jge at 0x004c6652, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c6921 (forward)
    push 0x555030                                # 004c68ec
    mov ecx, dword ptr [ebp + arg_20]            # 004c68f1
    push ecx                                     # 004c68f4
    mov edx, dword ptr [ebp + arg_10]            # 004c68f5
    push edx                                     # 004c68f8
    mov ecx, dword ptr [ebp - local_2dc]         # 004c68f9
    call FUN_004c4202                            # 004c68ff
    mov eax, dword ptr [ebp - local_2dc]         # 004c6904
    mov ecx, dword ptr [ebp + arg_10]            # 004c690a
    cmp ecx, dword ptr [eax + field_c]           # 004c690d
    jne.d8 L_004c6921                            # 004c6910
    # block 0x004c6912: entered by fall-through of jne at 0x004c6910, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c6921
    mov edx, dword ptr [ebp + arg_20]            # 004c6912
    push edx                                     # 004c6915
    mov ecx, dword ptr [ebp - local_2dc]         # 004c6916
    call FUN_004c952f                            # 004c691c
L_004c6921:
    # block 0x004c6921: entered by jmp at 0x004c6450; jmp at 0x004c649d; jmp at 0x004c6541; jne at 0x004c6910, 5 instruction(s), ends with ret 0x24
    pop edi                                      # 004c6921
    pop esi                                      # 004c6922
    {load} mov esp, ebp                          # 004c6923
    pop ebp                                      # 004c6925
    ret 0x24                                     # 004c6926

