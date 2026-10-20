# FUN_004da430
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004da430
# extent:       0x004da430-0x004dad11 (2273 code bytes)
# span:         0x004da430-0x004dad60 (code 2273, tables 72, padding 7)
# sha256:       73df1fe2a86cf89bbf7e5c6b8bcb2613fe23513427793bc537ce92598311d9e1
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_startup_menu_dispatcher
# naming:       INFERRED (lower confidence, not verified): the repository text README.md:40 says "original x86 `0x4da430` routine"; world-init-recovery.md:7 says "At VA 0x4da430, menu dispatch DAT_005aff55 == 1"
# name-note:    Startup menu selector and dispatch routine (hover, button boundaries, NEW GAME selection).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 2 more
# fields:       [eax + n] field_4; [edx + n] field_minus_1
# callees:      calls FUN_004daeb5, FUN_004dae88, FUN_004dad60, FUN_004daef1, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_0043dbd5, FUN_0044a2b7, FUN_004d7a15, FUN_004d812e, FUN_004db870, FUN_004c97b4, FUN_004c2dfb, FUN_004cf7e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 457 instruction(s), 43 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cf7e0, .text + (0x004cf7e0 - 0x401000)
.set FUN_004d7a15, .text + (0x004d7a15 - 0x401000)
.set FUN_004d812e, .text + (0x004d812e - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004daef1, .text + (0x004daef1 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004da430 - 0x401000
.globl FUN_004da430
FUN_004da430:
    # block 0x004da430: entry, 8 instruction(s), ends with je to 0x004da45e (forward)
    push ebp                                     # 004da430
    {load} mov ebp, esp                          # 004da431
    sub esp, 0x3c                                # 004da433
    push edi                                     # 004da436
    mov eax, dword ptr [0x5aff4d]                # 004da437
    mov dword ptr [ebp - local_2c], eax          # 004da43c
    cmp dword ptr [ebp - local_2c], 0x0          # 004da43f
    je.d8 L_004da45e                             # 004da443
    # block 0x004da445: entered by fall-through of je at 0x004da443, 2 instruction(s), ends with je to 0x004da97a (forward)
    cmp dword ptr [ebp - local_2c], 0x2          # 004da445
    je.d32 L_004da97a                            # 004da449
    # block 0x004da44f: entered by fall-through of je at 0x004da449, 2 instruction(s), ends with je to 0x004da9b5 (forward)
    cmp dword ptr [ebp - local_2c], 0x3          # 004da44f
    je.d32 L_004da9b5                            # 004da453
    # block 0x004da459: entered by fall-through of je at 0x004da453, 1 instruction(s), ends with forward jump to 0x004dacff
    jmp.d32 L_004dacff                           # 004da459
L_004da45e:
    # block 0x004da45e: entered by je at 0x004da443, 19 instruction(s), calls FUN_004daeb5, ends with jne to 0x004da4c3 (forward)
    lea ecx, [ebp - local_1c]                    # 004da45e
    push ecx                                     # 004da461
    mov ecx, 0x5830a6                            # 004da462
    call FUN_004daeb5                            # 004da467
    mov edx, dword ptr [eax]                     # 004da46c
    mov eax, dword ptr [eax + field_4]           # 004da46e
    mov dword ptr [0x5830e2], edx                # 004da471
    mov dword ptr [0x5830e6], eax                # 004da477
    mov ecx, dword ptr [0x5830e2]                # 004da47c
    mov dword ptr [0x5c3a53], ecx                # 004da482
    mov edx, dword ptr [0x5830e6]                # 004da488
    mov dword ptr [0x5c3a57], edx                # 004da48e
    mov eax, dword ptr [0x5830ea]                # 004da494
    mov dword ptr [ebp - local_24], eax          # 004da499
    mov ecx, dword ptr [0x5830ee]                # 004da49c
    mov dword ptr [ebp - local_20], ecx          # 004da4a2
    mov edx, dword ptr [0x5830e2]                # 004da4a5
    cmp edx, dword ptr [ebp - local_24]          # 004da4ab
    jne.d8 L_004da4c3                            # 004da4ae
    # block 0x004da4b0: entered by fall-through of jne at 0x004da4ae, 3 instruction(s), ends with jne to 0x004da4c3 (forward)
    mov eax, dword ptr [0x5830e6]                # 004da4b0
    cmp eax, dword ptr [ebp - local_20]          # 004da4b5
    jne.d8 L_004da4c3                            # 004da4b8
    # block 0x004da4ba: entered by fall-through of jne at 0x004da4b8, 2 instruction(s), ends with forward jump to 0x004da4ca
    mov dword ptr [ebp - local_30], 0x0          # 004da4ba
    jmp.d8 L_004da4ca                            # 004da4c1
L_004da4c3:
    # block 0x004da4c3: entered by jne at 0x004da4ae; jne at 0x004da4b8, 1 instruction(s), falls into the block at 0x004da4ca
    mov dword ptr [ebp - local_30], 0x1          # 004da4c3
L_004da4ca:
    # block 0x004da4ca: entered by jmp at 0x004da4c1, 2 instruction(s), ends with je to 0x004da658 (forward)
    cmp dword ptr [ebp - local_30], 0x0          # 004da4ca
    je.d32 L_004da658                            # 004da4ce
    # block 0x004da4d4: entered by fall-through of je at 0x004da4ce, 2 instruction(s), ends with jne to 0x004da658 (forward)
    cmp dword ptr [0x5830d6], 0x0                # 004da4d4
    jne.d32 L_004da658                           # 004da4db
    # block 0x004da4e1: entered by fall-through of jne at 0x004da4db, 16 instruction(s), ends with jl to 0x004da55b (forward)
    mov ecx, dword ptr [0x583106]                # 004da4e1
    mov dword ptr [0x5830f6], ecx                # 004da4e7
    mov edx, dword ptr [0x58310e]                # 004da4ed
    mov dword ptr [0x5830fe], edx                # 004da4f3
    mov eax, dword ptr [0x583102]                # 004da4f9
    mov dword ptr [0x5830f2], eax                # 004da4fe
    mov ecx, dword ptr [0x58310a]                # 004da503
    mov dword ptr [0x5830fa], ecx                # 004da509
    movsx edx, word ptr [0x63988b]               # 004da50f
    mov eax, dword ptr [0x5b44f4]                # 004da516
    shl eax, 0x2                                 # 004da51b
    mov ecx, dword ptr [0x5b44f0]                # 004da51e
    movsx eax, word ptr [eax + 8*ecx + 0x5b3790] # 004da524
    {load} sub edx, eax                          # 004da52c
    cmp dword ptr [0x5830e2], edx                # 004da52e
    jl.d8 L_004da55b                             # 004da534
    # block 0x004da536: entered by fall-through of jl at 0x004da534, 7 instruction(s), falls into the block at 0x004da55b
    movsx ecx, word ptr [0x63988b]               # 004da536
    mov edx, dword ptr [0x5b44f4]                # 004da53d
    shl edx, 0x2                                 # 004da543
    mov eax, dword ptr [0x5b44f0]                # 004da546
    movsx edx, word ptr [edx + 8*eax + 0x5b3790] # 004da54b
    {load} sub ecx, edx                          # 004da553
    mov dword ptr [0x5830e2], ecx                # 004da555
L_004da55b:
    # block 0x004da55b: entered by jl at 0x004da534, 8 instruction(s), ends with jl to 0x004da5a8 (forward)
    movsx eax, word ptr [0x63988d]               # 004da55b
    mov ecx, dword ptr [0x5b44f4]                # 004da562
    shl ecx, 0x2                                 # 004da568
    mov edx, dword ptr [0x5b44f0]                # 004da56b
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004da571
    {load} sub eax, ecx                          # 004da579
    cmp dword ptr [0x5830e6], eax                # 004da57b
    jl.d8 L_004da5a8                             # 004da581
    # block 0x004da583: entered by fall-through of jl at 0x004da581, 7 instruction(s), falls into the block at 0x004da5a8
    movsx edx, word ptr [0x63988d]               # 004da583
    mov eax, dword ptr [0x5b44f4]                # 004da58a
    shl eax, 0x2                                 # 004da58f
    mov ecx, dword ptr [0x5b44f0]                # 004da592
    movsx eax, word ptr [eax + 8*ecx + 0x5b3792] # 004da598
    {load} sub edx, eax                          # 004da5a0
    mov dword ptr [0x5830e6], edx                # 004da5a2
L_004da5a8:
    # block 0x004da5a8: entered by jl at 0x004da581, 32 instruction(s), calls FUN_004dae88, ends with forward jump to 0x004da675
    mov ecx, dword ptr [0x5830e6]                # 004da5a8
    mov dword ptr [0x583106], ecx                # 004da5ae
    mov edx, dword ptr [0x5b44f4]                # 004da5b4
    shl edx, 0x2                                 # 004da5ba
    mov eax, dword ptr [0x5b44f0]                # 004da5bd
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004da5c2
    mov edx, dword ptr [0x583106]                # 004da5ca
    lea eax, [edx + ecx - field_minus_1]         # 004da5d0
    mov dword ptr [0x58310e], eax                # 004da5d4
    mov ecx, dword ptr [0x5830e2]                # 004da5d9
    mov dword ptr [0x583102], ecx                # 004da5df
    mov edx, dword ptr [0x5b44f4]                # 004da5e5
    shl edx, 0x2                                 # 004da5eb
    mov eax, dword ptr [0x5b44f0]                # 004da5ee
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004da5f3
    mov edx, dword ptr [0x583102]                # 004da5fb
    lea eax, [edx + ecx - field_minus_1]         # 004da601
    mov dword ptr [0x58310a], eax                # 004da605
    mov ecx, dword ptr [0x5830e6]                # 004da60a
    push ecx                                     # 004da610
    mov edx, dword ptr [0x5830e2]                # 004da611
    push edx                                     # 004da617
    mov ecx, 0x5830a6                            # 004da618
    call FUN_004dae88                            # 004da61d
    mov dword ptr [0x63a9c4], 0x0                # 004da622
    mov dword ptr [0x5830d6], 0x1                # 004da62c
    mov dword ptr [0x5d2abf], 0x1                # 004da636
    mov eax, dword ptr [0x5830e2]                # 004da640
    mov dword ptr [0x5830ea], eax                # 004da645
    mov ecx, dword ptr [0x5830e6]                # 004da64a
    mov dword ptr [0x5830ee], ecx                # 004da650
    jmp.d8 L_004da675                            # 004da656
L_004da658:
    # block 0x004da658: entered by je at 0x004da4ce; jne at 0x004da4db, 2 instruction(s), ends with je to 0x004da675 (forward)
    cmp dword ptr [0x5830d6], 0x0                # 004da658
    je.d8 L_004da675                             # 004da65f
    # block 0x004da661: entered by fall-through of je at 0x004da65f, 2 instruction(s), falls into the block at 0x004da675
    mov dword ptr [0x5830d6], 0x0                # 004da661
    mov dword ptr [0x5d2abf], 0x0                # 004da66b
L_004da675:
    # block 0x004da675: entered by jmp at 0x004da656; je at 0x004da65f, 3 instruction(s), ends with je to 0x004da696 (forward)
    movsx edx, word ptr [0x5aff57]               # 004da675
    cmp edx, -0x1                                # 004da67c
    je.d8 L_004da696                             # 004da67f
    # block 0x004da681: entered by fall-through of je at 0x004da67f, 3 instruction(s), ends with forward jump to 0x004da6a0
    mov dword ptr [0x5d2b53], 0x1                # 004da681
    mov word ptr [0x5aff57], 0xffff              # 004da68b
    jmp.d8 L_004da6a0                            # 004da694
L_004da696:
    # block 0x004da696: entered by je at 0x004da67f, 1 instruction(s), falls into the block at 0x004da6a0
    mov dword ptr [0x5d2b53], 0x0                # 004da696
L_004da6a0:
    # block 0x004da6a0: entered by jmp at 0x004da694, 15 instruction(s), ends with forward jump to 0x004da6f9
    mov dword ptr [ebp - local_c], 0x0           # 004da6a0
    mov eax, dword ptr [0x5b44f0]                # 004da6a7
    shl eax, 0x4                                 # 004da6ac
    mov ecx, dword ptr [0x5b44f4]                # 004da6af
    mov edx, dword ptr [0x583106]                # 004da6b5
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004da6bb
    mov word ptr [ebp - local_4], dx             # 004da6c2
    mov eax, dword ptr [0x5b44f0]                # 004da6c6
    shl eax, 0x4                                 # 004da6cb
    mov ecx, dword ptr [0x5b44f4]                # 004da6ce
    mov edx, dword ptr [0x583102]                # 004da6d4
    add edx, dword ptr [eax + 8*ecx + 0x5b30cc]  # 004da6da
    mov word ptr [ebp - local_14], dx            # 004da6e1
    mov word ptr [ebp - local_10], 0x0           # 004da6e5
    jmp.d8 L_004da6f9                            # 004da6eb
L_004da6ed:
    # block 0x004da6ed: entered by jmp at 0x004da78a; jmp at 0x004da960, 3 instruction(s), falls into the block at 0x004da6f9
    mov ax, word ptr [ebp - local_10]            # 004da6ed
    .insn 0x66, 0x05, 0x0001{:u16}               # 004da6f1
    mov word ptr [ebp - local_10], ax            # 004da6f5
L_004da6f9:
    # block 0x004da6f9: entered by jmp at 0x004da6eb, 3 instruction(s), ends with jge to 0x004da965 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004da6f9
    cmp ecx, 0x9                                 # 004da6fd
    jge.d32 L_004da965                           # 004da700
    # block 0x004da706: entered by fall-through of jge at 0x004da700, 5 instruction(s), ends with jl to 0x004da960 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004da706
    movsx eax, word ptr [ebp - local_10]         # 004da70a
    shl eax, 0x4                                 # 004da70e
    cmp edx, dword ptr [eax + 0x5afd09]          # 004da711
    jl.d32 L_004da960                            # 004da717
    # block 0x004da71d: entered by fall-through of jl at 0x004da717, 6 instruction(s), ends with jg to 0x004da960 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004da71d
    sub ecx, 0xa                                 # 004da721
    movsx edx, word ptr [ebp - local_10]         # 004da724
    shl edx, 0x4                                 # 004da728
    cmp ecx, dword ptr [edx + 0x5afd11]          # 004da72b
    jg.d32 L_004da960                            # 004da731
    # block 0x004da737: entered by fall-through of jg at 0x004da731, 5 instruction(s), ends with jl to 0x004da960 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004da737
    movsx ecx, word ptr [ebp - local_10]         # 004da73b
    shl ecx, 0x4                                 # 004da73f
    cmp eax, dword ptr [ecx + 0x5afd05]          # 004da742
    jl.d32 L_004da960                            # 004da748
    # block 0x004da74e: entered by fall-through of jl at 0x004da748, 5 instruction(s), ends with jg to 0x004da960 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004da74e
    movsx eax, word ptr [ebp - local_10]         # 004da752
    shl eax, 0x4                                 # 004da756
    cmp edx, dword ptr [eax + 0x5afd0d]          # 004da759
    jg.d32 L_004da960                            # 004da75f
    # block 0x004da765: entered by fall-through of jg at 0x004da75f, 3 instruction(s), ends with jne to 0x004da960 (forward)
    movsx ecx, word ptr [0x5aff55]               # 004da765
    cmp ecx, -0x1                                # 004da76c
    jne.d32 L_004da960                           # 004da76f
    # block 0x004da775: entered by fall-through of jne at 0x004da76f, 4 instruction(s), ends with je to 0x004da78f (forward)
    mov dword ptr [ebp - local_c], 0x1           # 004da775
    movsx edx, word ptr [ebp - local_10]         # 004da77c
    cmp dword ptr [4*edx + 0x5aff79], 0x0        # 004da780
    je.d8 L_004da78f                             # 004da788
    # block 0x004da78a: entered by fall-through of je at 0x004da788, 1 instruction(s), ends with backward jump to 0x004da6ed
    jmp.d32 L_004da6ed                           # 004da78a
L_004da78f:
    # block 0x004da78f: entered by je at 0x004da788, 7 instruction(s), ends with je to 0x004da7bd (forward)
    mov ax, word ptr [ebp - local_10]            # 004da78f
    mov word ptr [0x5aff57], ax                  # 004da793
    mov dword ptr [0x5d2b53], 0x1                # 004da799
    mov ecx, dword ptr [0x5aff51]                # 004da7a3
    mov dword ptr [ebp - local_34], ecx          # 004da7a9
    cmp dword ptr [ebp - local_34], 0x0          # 004da7ac
    je.d8 L_004da7bd                             # 004da7b0
    # block 0x004da7b2: entered by fall-through of je at 0x004da7b0, 2 instruction(s), ends with je to 0x004da7d6 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 004da7b2
    je.d8 L_004da7d6                             # 004da7b6
    # block 0x004da7b8: entered by fall-through of je at 0x004da7b6, 1 instruction(s), ends with forward jump to 0x004da95e
    jmp.d32 L_004da95e                           # 004da7b8
L_004da7bd:
    # block 0x004da7bd: entered by je at 0x004da7b0, 4 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004da95e
    mov ecx, 0x5830a6                            # 004da7bd
    call FUN_004dad60                            # 004da7c2
    mov dword ptr [0x5aff51], 0x1                # 004da7c7
    jmp.d32 L_004da95e                           # 004da7d1
L_004da7d6:
    # block 0x004da7d6: entered by je at 0x004da7b6, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004da95e (forward)
    mov ecx, 0x5830a6                            # 004da7d6
    call FUN_004daef1                            # 004da7db
    cmp eax, 0x2                                 # 004da7e0
    jne.d32 L_004da95e                           # 004da7e3
    # block 0x004da7e9: entered by fall-through of jne at 0x004da7e3, 42 instruction(s), calls FUN_004dad60, ends with ja to 0x004da940 (forward)
    mov dx, word ptr [ebp - local_10]            # 004da7e9
    mov word ptr [0x5aff55], dx                  # 004da7ed
    mov ecx, 0x5830a6                            # 004da7f4
    call FUN_004dad60                            # 004da7f9
    movsx eax, word ptr [ebp - local_10]         # 004da7fe
    shl eax, 0x4                                 # 004da802
    mov ecx, dword ptr [eax + 0x5afd99]          # 004da805
    mov dword ptr [0x5aff5d], ecx                # 004da80b
    movsx edx, word ptr [ebp - local_10]         # 004da811
    shl edx, 0x4                                 # 004da815
    mov eax, dword ptr [edx + 0x5afda1]          # 004da818
    mov dword ptr [0x5aff65], eax                # 004da81e
    movsx ecx, word ptr [ebp - local_10]         # 004da823
    shl ecx, 0x4                                 # 004da827
    mov edx, dword ptr [ecx + 0x5afd95]          # 004da82a
    mov dword ptr [0x5aff59], edx                # 004da830
    movsx eax, word ptr [ebp - local_10]         # 004da836
    shl eax, 0x4                                 # 004da83a
    mov ecx, dword ptr [eax + 0x5afd9d]          # 004da83d
    mov dword ptr [0x5aff61], ecx                # 004da843
    movsx edx, word ptr [ebp - local_10]         # 004da849
    shl edx, 0x4                                 # 004da84d
    mov eax, dword ptr [edx + 0x5afd09]          # 004da850
    mov dword ptr [0x5aff6d], eax                # 004da856
    movsx ecx, word ptr [ebp - local_10]         # 004da85b
    shl ecx, 0x4                                 # 004da85f
    mov edx, dword ptr [ecx + 0x5afd11]          # 004da862
    mov dword ptr [0x5aff75], edx                # 004da868
    movsx eax, word ptr [ebp - local_10]         # 004da86e
    shl eax, 0x4                                 # 004da872
    mov ecx, dword ptr [eax + 0x5afd05]          # 004da875
    mov dword ptr [0x5aff69], ecx                # 004da87b
    movsx edx, word ptr [ebp - local_10]         # 004da881
    shl edx, 0x4                                 # 004da885
    mov eax, dword ptr [edx + 0x5afd0d]          # 004da888
    mov dword ptr [0x5aff71], eax                # 004da88e
    mov dword ptr [0x5d2b09], 0x1                # 004da893
    mov word ptr [0x63a9c0], 0x17                # 004da89d
    movsx ecx, word ptr [0x5aff55]               # 004da8a6
    mov dword ptr [ebp - local_38], ecx          # 004da8ad
    cmp dword ptr [ebp - local_38], 0x8          # 004da8b0
    ja.d32 L_004da940                            # 004da8b4
    # block 0x004da8ba: entered by fall-through of ja at 0x004da8b4, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4dad11]
    mov edx, dword ptr [ebp - local_38]          # 004da8ba
    jmp dword ptr [4*edx + SWTAB_004dad11_VA]    # 004da8bd
L_004da8c4:
    # block 0x004da8c4: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da8c4
    mov ecx, 0x5c3a67                            # 004da8c6
    call FUN_004fb2e3                            # 004da8cb
    jmp.d8 L_004da940                            # 004da8d0
L_004da8d2:
    # block 0x004da8d2: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da8d2
    mov ecx, 0x5c3a67                            # 004da8d4
    call FUN_004fb2e3                            # 004da8d9
    jmp.d8 L_004da940                            # 004da8de
L_004da8e0:
    # block 0x004da8e0: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da8e0
    mov ecx, 0x5c3a67                            # 004da8e2
    call FUN_004fb2e3                            # 004da8e7
    jmp.d8 L_004da940                            # 004da8ec
L_004da8ee:
    # block 0x004da8ee: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da8ee
    mov ecx, 0x5c3a67                            # 004da8f0
    call FUN_004fb2e3                            # 004da8f5
    jmp.d8 L_004da940                            # 004da8fa
L_004da8fc:
    # block 0x004da8fc: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da8fc
    mov ecx, 0x5c3a67                            # 004da8fe
    call FUN_004fb2e3                            # 004da903
    jmp.d8 L_004da940                            # 004da908
L_004da90a:
    # block 0x004da90a: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da90a
    mov ecx, 0x5c3a67                            # 004da90c
    call FUN_004fb2e3                            # 004da911
    jmp.d8 L_004da940                            # 004da916
L_004da918:
    # block 0x004da918: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da918
    mov ecx, 0x5c3a67                            # 004da91a
    call FUN_004fb2e3                            # 004da91f
    jmp.d8 L_004da940                            # 004da924
L_004da926:
    # block 0x004da926: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004da940
    push 0x17                                    # 004da926
    mov ecx, 0x5c3a67                            # 004da928
    call FUN_004fb2e3                            # 004da92d
    jmp.d8 L_004da940                            # 004da932
L_004da934:
    # block 0x004da934: entered by switch case, 3 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004da940
    push 0x17                                    # 004da934
    mov ecx, 0x5c3a67                            # 004da936
    call FUN_004fb2e3                            # 004da93b
L_004da940:
    # block 0x004da940: entered by ja at 0x004da8b4; jmp at 0x004da8d0; jmp at 0x004da8de; jmp at 0x004da8ec; more, 5 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004da95e
    call dword ptr [0x52a23c]                    # 004da940
    movsx ecx, word ptr [0x5b0282]               # 004da946
    {load} add eax, ecx                          # 004da94d
    mov dword ptr [0x5aff49], eax                # 004da94f
    mov dword ptr [0x5aff4d], 0x2                # 004da954
L_004da95e:
    # block 0x004da95e: entered by jmp at 0x004da7b8; jmp at 0x004da7d1; jne at 0x004da7e3, 1 instruction(s), ends with forward jump to 0x004da965
    jmp.d8 L_004da965                            # 004da95e
L_004da960:
    # block 0x004da960: entered by jl at 0x004da717; jg at 0x004da731; jl at 0x004da748; jg at 0x004da75f; jne at 0x004da76f, 1 instruction(s), ends with backward jump to 0x004da6ed
    jmp.d32 L_004da6ed                           # 004da960
L_004da965:
    # block 0x004da965: entered by jge at 0x004da700; jmp at 0x004da95e, 2 instruction(s), ends with jne to 0x004da975 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004da965
    jne.d8 L_004da975                            # 004da969
    # block 0x004da96b: entered by fall-through of jne at 0x004da969, 1 instruction(s), falls into the block at 0x004da975
    mov dword ptr [0x5aff51], 0x0                # 004da96b
L_004da975:
    # block 0x004da975: entered by jne at 0x004da969, 1 instruction(s), ends with forward jump to 0x004dacff
    jmp.d32 L_004dacff                           # 004da975
L_004da97a:
    # block 0x004da97a: entered by je at 0x004da449, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004da9b0 (forward)
    call dword ptr [0x52a23c]                    # 004da97a
    cmp eax, dword ptr [0x5aff49]                # 004da980
    jbe.d8 L_004da9b0                            # 004da986
    # block 0x004da988: entered by fall-through of jbe at 0x004da986, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004da9b0 (forward)
    {load} xor edx, edx                          # 004da988
    mov dx, word ptr [0x63a9c0]                  # 004da98a
    mov dword ptr [ebp - local_28], edx          # 004da991
    mov eax, dword ptr [ebp - local_28]          # 004da994
    push eax                                     # 004da997
    mov ecx, 0x5cf1eb                            # 004da998
    call FUN_004f6334                            # 004da99d
    test eax, eax                                # 004da9a2
    jne.d8 L_004da9b0                            # 004da9a4
    # block 0x004da9a6: entered by fall-through of jne at 0x004da9a4, 1 instruction(s), falls into the block at 0x004da9b0
    mov dword ptr [0x5aff4d], 0x3                # 004da9a6
L_004da9b0:
    # block 0x004da9b0: entered by jbe at 0x004da986; jne at 0x004da9a4, 1 instruction(s), ends with forward jump to 0x004dacff
    jmp.d32 L_004dacff                           # 004da9b0
L_004da9b5:
    # block 0x004da9b5: entered by je at 0x004da453, 8 instruction(s), calls FUN_004dad60, ends with ja to 0x004dac98 (forward)
    mov dword ptr [ebp - local_8], 0x1           # 004da9b5
    mov ecx, 0x5830a6                            # 004da9bc
    call FUN_004dad60                            # 004da9c1
    mov dword ptr [0x583985], 0x6                # 004da9c6
    movsx ecx, word ptr [0x5aff55]               # 004da9d0
    mov dword ptr [ebp - local_3c], ecx          # 004da9d7
    cmp dword ptr [ebp - local_3c], 0x8          # 004da9da
    ja.d32 L_004dac98                            # 004da9de
    # block 0x004da9e4: entered by fall-through of ja at 0x004da9de, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4dad35]
    mov edx, dword ptr [ebp - local_3c]          # 004da9e4
    jmp dword ptr [4*edx + SWTAB_004dad35_VA]    # 004da9e7
L_004da9ee:
    # block 0x004da9ee: entered by switch case, 6 instruction(s), calls FUN_0043dbd5, ends with je to 0x004daa1f (forward)
    mov dword ptr [0x583981], 0x5                # 004da9ee
    mov dword ptr [0x583991], 0x0                # 004da9f8
    call FUN_0043dbd5                            # 004daa02
    movsx eax, word ptr [0x63a4cd]               # 004daa07
    test eax, eax                                # 004daa0e
    je.d8 L_004daa1f                             # 004daa10
    # block 0x004daa12: entered by fall-through of je at 0x004daa10, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004daa1f
    push 0x55ad80                                # 004daa12
    call FUN_0044a2b7                            # 004daa17
    add esp, 0x4                                 # 004daa1c
L_004daa1f:
    # block 0x004daa1f: entered by je at 0x004daa10, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004daa1f
L_004daa24:
    # block 0x004daa24: entered by switch case, 3 instruction(s), ends with je to 0x004daa57 (forward)
    mov dword ptr [0x5bb1e2], 0x1                # 004daa24
    cmp dword ptr [0x5e32b9], 0x0                # 004daa2e
    je.d8 L_004daa57                             # 004daa35
    # block 0x004daa37: entered by fall-through of je at 0x004daa35, 4 instruction(s), ends with forward jump to 0x004daa7a
    mov dword ptr [0x583981], 0x11               # 004daa37
    mov dword ptr [0x616783], 0x0                # 004daa41
    mov dword ptr [0x5e32b9], 0x0                # 004daa4b
    jmp.d8 L_004daa7a                            # 004daa55
L_004daa57:
    # block 0x004daa57: entered by je at 0x004daa35, 7 instruction(s), falls into the block at 0x004daa7a
    mov dword ptr [0x583981], 0xe                # 004daa57
    mov dword ptr [0x583999], 0x0                # 004daa61
    mov ecx, 0x8                                 # 004daa6b
    {load} xor eax, eax                          # 004daa70
    mov edi, 0x63a565                            # 004daa72
    rep stosd dword ptr es:[edi], eax            # 004daa77
    stosb byte ptr es:[edi], al                  # 004daa79
L_004daa7a:
    # block 0x004daa7a: entered by jmp at 0x004daa55, 4 instruction(s), calls FUN_0043dbd5, ends with je to 0x004daa97 (forward)
    call FUN_0043dbd5                            # 004daa7a
    movsx ecx, word ptr [0x63a4cd]               # 004daa7f
    test ecx, ecx                                # 004daa86
    je.d8 L_004daa97                             # 004daa88
    # block 0x004daa8a: entered by fall-through of je at 0x004daa88, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004daa97
    push 0x55adb4                                # 004daa8a
    call FUN_0044a2b7                            # 004daa8f
    add esp, 0x4                                 # 004daa94
L_004daa97:
    # block 0x004daa97: entered by je at 0x004daa88, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004daa97
L_004daa9c:
    # block 0x004daa9c: entered by switch case, 2 instruction(s), ends with je to 0x004daabf (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004daa9c
    je.d8 L_004daabf                             # 004daaa3
    # block 0x004daaa5: entered by fall-through of je at 0x004daaa3, 2 instruction(s), ends with jne to 0x004daabf (forward)
    cmp dword ptr [0x5bb1de], 0x0                # 004daaa5
    jne.d8 L_004daabf                            # 004daaac
    # block 0x004daaae: entered by fall-through of jne at 0x004daaac, 4 instruction(s), calls FUN_004d7a15, falls into the block at 0x004daabf
    push 0x0                                     # 004daaae
    push 0x55ade8                                # 004daab0
    mov ecx, 0x5e2e70                            # 004daab5
    call FUN_004d7a15                            # 004daaba
L_004daabf:
    # block 0x004daabf: entered by je at 0x004daaa3; jne at 0x004daaac, 7 instruction(s), calls FUN_0043dbd5, ends with je to 0x004daafa (forward)
    mov dword ptr [0x5bb1de], 0x1                # 004daabf
    mov dword ptr [0x583981], 0xe                # 004daac9
    mov dword ptr [0x583999], 0x0                # 004daad3
    call FUN_0043dbd5                            # 004daadd
    movsx edx, word ptr [0x63a4cd]               # 004daae2
    test edx, edx                                # 004daae9
    je.d8 L_004daafa                             # 004daaeb
    # block 0x004daaed: entered by fall-through of je at 0x004daaeb, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004daafa
    push 0x55adf8                                # 004daaed
    call FUN_0044a2b7                            # 004daaf2
    add esp, 0x4                                 # 004daaf7
L_004daafa:
    # block 0x004daafa: entered by je at 0x004daaeb, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004daafa
L_004daaff:
    # block 0x004daaff: entered by switch case, 6 instruction(s), calls FUN_0043dbd5, ends with je to 0x004dab30 (forward)
    mov dword ptr [0x583981], 0x7                # 004daaff
    mov dword ptr [0x5e2e74], 0x0                # 004dab09
    call FUN_0043dbd5                            # 004dab13
    movsx eax, word ptr [0x63a4cd]               # 004dab18
    test eax, eax                                # 004dab1f
    je.d8 L_004dab30                             # 004dab21
    # block 0x004dab23: entered by fall-through of je at 0x004dab21, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dab30
    push 0x55ae28                                # 004dab23
    call FUN_0044a2b7                            # 004dab28
    add esp, 0x4                                 # 004dab2d
L_004dab30:
    # block 0x004dab30: entered by je at 0x004dab21, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004dab30
L_004dab35:
    # block 0x004dab35: entered by switch case, 5 instruction(s), calls FUN_004d812e, ends with je to 0x004daba7 (forward)
    push 0x55ae64                                # 004dab35
    mov ecx, 0x5e2e70                            # 004dab3a
    call FUN_004d812e                            # 004dab3f
    test eax, eax                                # 004dab44
    je.d8 L_004daba7                             # 004dab46
    # block 0x004dab48: entered by fall-through of je at 0x004dab46, 3 instruction(s), ends with jne to 0x004dab62 (forward)
    movsx ecx, word ptr [0x58c993]               # 004dab48
    cmp ecx, 0x270f                              # 004dab4f
    jne.d8 L_004dab62                            # 004dab55
    # block 0x004dab57: entered by fall-through of jne at 0x004dab55, 2 instruction(s), ends with forward jump to 0x004dab74
    mov word ptr [0x58c993], 0x1                 # 004dab57
    jmp.d8 L_004dab74                            # 004dab60
L_004dab62:
    # block 0x004dab62: entered by jne at 0x004dab55, 3 instruction(s), falls into the block at 0x004dab74
    mov dx, word ptr [0x58c993]                  # 004dab62
    add dx, 0x1                                  # 004dab69
    mov word ptr [0x58c993], dx                  # 004dab6d
L_004dab74:
    # block 0x004dab74: entered by jmp at 0x004dab60, 7 instruction(s), calls FUN_0043dbd5, FUN_004db870, ends with je to 0x004daba5 (forward)
    mov dword ptr [0x5bb1e2], 0x1                # 004dab74
    call FUN_0043dbd5                            # 004dab7e
    mov ecx, 0x5830ce                            # 004dab83
    call FUN_004db870                            # 004dab88
    movsx eax, word ptr [0x63a4cd]               # 004dab8d
    test eax, eax                                # 004dab94
    je.d8 L_004daba5                             # 004dab96
    # block 0x004dab98: entered by fall-through of je at 0x004dab96, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004daba5
    push 0x55ae74                                # 004dab98
    call FUN_0044a2b7                            # 004dab9d
    add esp, 0x4                                 # 004daba2
L_004daba5:
    # block 0x004daba5: entered by je at 0x004dab96, 1 instruction(s), ends with forward jump to 0x004dabae
    jmp.d8 L_004dabae                            # 004daba5
L_004daba7:
    # block 0x004daba7: entered by je at 0x004dab46, 1 instruction(s), falls into the block at 0x004dabae
    mov dword ptr [ebp - local_8], 0x0           # 004daba7
L_004dabae:
    # block 0x004dabae: entered by jmp at 0x004daba5, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004dabae
L_004dabb3:
    # block 0x004dabb3: entered by switch case, 2 instruction(s), ends with je to 0x004dabef (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004dabb3
    je.d8 L_004dabef                             # 004dabba
    # block 0x004dabbc: entered by fall-through of je at 0x004dabba, 7 instruction(s), calls FUN_0043dbd5, FUN_004db870, ends with je to 0x004dabed (forward)
    mov dword ptr [0x583981], 0xe                # 004dabbc
    call FUN_0043dbd5                            # 004dabc6
    mov ecx, 0x5830ce                            # 004dabcb
    call FUN_004db870                            # 004dabd0
    movsx ecx, word ptr [0x63a4cd]               # 004dabd5
    test ecx, ecx                                # 004dabdc
    je.d8 L_004dabed                             # 004dabde
    # block 0x004dabe0: entered by fall-through of je at 0x004dabde, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dabed
    push 0x55aecc                                # 004dabe0
    call FUN_0044a2b7                            # 004dabe5
    add esp, 0x4                                 # 004dabea
L_004dabed:
    # block 0x004dabed: entered by je at 0x004dabde, 1 instruction(s), ends with forward jump to 0x004dabf6
    jmp.d8 L_004dabf6                            # 004dabed
L_004dabef:
    # block 0x004dabef: entered by je at 0x004dabba, 1 instruction(s), falls into the block at 0x004dabf6
    mov dword ptr [ebp - local_8], 0x0           # 004dabef
L_004dabf6:
    # block 0x004dabf6: entered by jmp at 0x004dabed, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d32 L_004dac98                           # 004dabf6
L_004dabfb:
    # block 0x004dabfb: entered by switch case, 5 instruction(s), ends with je to 0x004dac27 (forward)
    mov dword ptr [0x583981], 0x8                # 004dabfb
    mov dword ptr [0x583995], 0x0                # 004dac05
    movsx edx, word ptr [0x63a4cd]               # 004dac0f
    test edx, edx                                # 004dac16
    je.d8 L_004dac27                             # 004dac18
    # block 0x004dac1a: entered by fall-through of je at 0x004dac18, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dac27
    push 0x55af04                                # 004dac1a
    call FUN_0044a2b7                            # 004dac1f
    add esp, 0x4                                 # 004dac24
L_004dac27:
    # block 0x004dac27: entered by je at 0x004dac18, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d8 L_004dac98                            # 004dac27
L_004dac29:
    # block 0x004dac29: entered by switch case, 2 instruction(s), ends with je to 0x004dac51 (forward)
    cmp dword ptr [0x5e32b9], 0x0                # 004dac29
    je.d8 L_004dac51                             # 004dac30
    # block 0x004dac32: entered by fall-through of je at 0x004dac30, 2 instruction(s), ends with je to 0x004dac51 (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004dac32
    je.d8 L_004dac51                             # 004dac39
    # block 0x004dac3b: entered by fall-through of je at 0x004dac39, 3 instruction(s), ends with forward jump to 0x004dac65
    mov dword ptr [0x583981], 0xb                # 004dac3b
    mov dword ptr [0x616783], 0x0                # 004dac45
    jmp.d8 L_004dac65                            # 004dac4f
L_004dac51:
    # block 0x004dac51: entered by je at 0x004dac30; je at 0x004dac39, 3 instruction(s), calls FUN_004c97b4, falls into the block at 0x004dac65
    mov dword ptr [0x5bb20c], 0x1                # 004dac51
    mov ecx, 0x5cf659                            # 004dac5b
    call FUN_004c97b4                            # 004dac60
L_004dac65:
    # block 0x004dac65: entered by jmp at 0x004dac4f, 1 instruction(s), ends with forward jump to 0x004dac98
    jmp.d8 L_004dac98                            # 004dac65
L_004dac67:
    # block 0x004dac67: entered by switch case, 6 instruction(s), calls FUN_0043dbd5, ends with je to 0x004dac98 (forward)
    mov dword ptr [0x583981], 0xa                # 004dac67
    mov dword ptr [0x5839a5], 0x0                # 004dac71
    call FUN_0043dbd5                            # 004dac7b
    movsx eax, word ptr [0x63a4cd]               # 004dac80
    test eax, eax                                # 004dac87
    je.d8 L_004dac98                             # 004dac89
    # block 0x004dac8b: entered by fall-through of je at 0x004dac89, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dac98
    push 0x55af34                                # 004dac8b
    call FUN_0044a2b7                            # 004dac90
    add esp, 0x4                                 # 004dac95
L_004dac98:
    # block 0x004dac98: entered by ja at 0x004da9de; jmp at 0x004daa1f; jmp at 0x004daa97; jmp at 0x004daafa; more, 2 instruction(s), ends with je to 0x004daceb (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004dac98
    je.d8 L_004daceb                             # 004dac9c
    # block 0x004dac9e: entered by fall-through of je at 0x004dac9c, 10 instruction(s), calls FUN_004c2dfb, ends with forward jump to 0x004dad0c
    mov dword ptr [0x5d2a2b], 0x0                # 004dac9e
    mov dword ptr [0x5d2a75], 0x0                # 004daca8
    mov dword ptr [0x5d2abf], 0x0                # 004dacb2
    mov dword ptr [0x5d2b09], 0x0                # 004dacbc
    mov dword ptr [0x5d2b53], 0x0                # 004dacc6
    mov dword ptr [0x5d2b9d], 0x0                # 004dacd0
    push 0x5d037b                                # 004dacda
    mov ecx, 0x5cf659                            # 004dacdf
    call FUN_004c2dfb                            # 004dace4
    jmp.d8 L_004dad0c                            # 004dace9
L_004daceb:
    # block 0x004daceb: entered by je at 0x004dac9c, 2 instruction(s), falls into the block at 0x004dacff
    mov dword ptr [0x5839a1], 0x0                # 004daceb
    mov dword ptr [0x5aff4d], 0x4                # 004dacf5
L_004dacff:
    # block 0x004dacff: entered by jmp at 0x004da459; jmp at 0x004da975; jmp at 0x004da9b0, 3 instruction(s), calls FUN_004cf7e0, falls into the block at 0x004dad0c
    push 0x55abd0                                # 004dacff
    call FUN_004cf7e0                            # 004dad04
    add esp, 0x4                                 # 004dad09
L_004dad0c:
    # block 0x004dad0c: entered by jmp at 0x004dace9, 4 instruction(s), ends with ret
    pop edi                                      # 004dad0c
    {load} mov esp, ebp                          # 004dad0d
    pop ebp                                      # 004dad0f
    ret                                          # 004dad10

# --- data items (not part of the function) -------------------------
.org 0x004dad11 - 0x401000
SWTAB_004dad11:  # 9 case address(es)
    .long L_004da8c4 - .text + 0x401000
    .long L_004da8d2 - .text + 0x401000
    .long L_004da8e0 - .text + 0x401000
    .long L_004da8fc - .text + 0x401000
    .long L_004da8ee - .text + 0x401000
    .long L_004da918 - .text + 0x401000
    .long L_004da926 - .text + 0x401000
    .long L_004da934 - .text + 0x401000
    .long L_004da90a - .text + 0x401000
.org 0x004dad35 - 0x401000
SWTAB_004dad35:  # 9 case address(es)
    .long L_004da9ee - .text + 0x401000
    .long L_004daa24 - .text + 0x401000
    .long L_004daaff - .text + 0x401000
    .long L_004dabb3 - .text + 0x401000
    .long L_004dab35 - .text + 0x401000
    .long L_004dabfb - .text + 0x401000
    .long L_004dac29 - .text + 0x401000
    .long L_004dac67 - .text + 0x401000
    .long L_004daa9c - .text + 0x401000
.org 0x004dad59 - 0x401000
PAD_004dad59:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc
.set SWTAB_004dad11_VA, SWTAB_004dad11 - .text + 0x401000
.set SWTAB_004dad35_VA, SWTAB_004dad35 - .text + 0x401000

