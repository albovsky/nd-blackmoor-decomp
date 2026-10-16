# FUN_0043d227
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043d227
# extent:       0x0043d227-0x0043d6be (1175 code bytes)
# span:         0x0043d227-0x0043d6be (code 1175, tables 0, padding 0)
# sha256:       baac2189c67d287bb94c06899cf0ee218b66dbadb7be2677198dfd363bceebce
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043d227
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_4, local_c, local_10, local_110, local_114, local_118, local_11c, local_4f5c, local_4f68, local_6088, local_608c, local_6090 and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c920, FUN_004ee5cd, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_00433c60, FUN_00433e63, FUN_004343a2, FUN_0042639d, FUN_00427a40, FUN_0042e693, FUN_00447c36
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:prepare_a28_handoff_frames (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 260 instruction(s), 28 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_4f5c, 0x4f5c  # offset -0x4f5c
.equ local_4f68, 0x4f68  # offset -0x4f68
.equ local_6088, 0x6088  # offset -0x6088
.equ local_608c, 0x608c  # offset -0x608c
.equ local_6090, 0x6090  # offset -0x6090
.equ local_6094, 0x6094  # offset -0x6094

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0042e693, .text + (0x0042e693 - 0x401000)
.set FUN_00433c60, .text + (0x00433c60 - 0x401000)
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)
.set FUN_00447c36, .text + (0x00447c36 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004ee5cd, .text + (0x004ee5cd - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0043d227 - 0x401000
.globl FUN_0043d227
FUN_0043d227:
    # block 0x0043d227: entry, 15 instruction(s), calls FUN_0050c920, ends with jne to 0x0043d27a (forward)
    push ebp                                     # 0043d227
    {load} mov ebp, esp                          # 0043d228
    push -0x1                                    # 0043d22a
    push 0x527e92                                # 0043d22c
    mov eax, dword ptr fs:[0x0]                  # 0043d231
    push eax                                     # 0043d237
    mov dword ptr fs:[0x0], esp                  # 0043d238
    mov eax, 0x6088                              # 0043d23f
    call FUN_0050c920                            # 0043d244
    push esi                                     # 0043d249
    push edi                                     # 0043d24a
    mov dword ptr [ebp - local_118], 0x0         # 0043d24b
    mov dword ptr [ebp - local_114], 0x0         # 0043d255
    cmp dword ptr [0x5bb22a], 0x0                # 0043d25f
    jne.d8 L_0043d27a                            # 0043d266
    # block 0x0043d268: entered by fall-through of jne at 0x0043d266, 4 instruction(s), calls FUN_004ee5cd, ends with jne to 0x0043d667 (forward)
    mov ecx, 0x57fd34                            # 0043d268
    call FUN_004ee5cd                            # 0043d26d
    test eax, eax                                # 0043d272
    jne.d32 L_0043d667                           # 0043d274
L_0043d27a:
    # block 0x0043d27a: entered by jne at 0x0043d266; fall-through of jne at 0x0043d274, 4 instruction(s), ends with jle to 0x0043d2f4 (forward)
    mov dword ptr [ebp - local_10], 0x0          # 0043d27a
    mov dword ptr [ebp - local_11c], 0x0         # 0043d281
    cmp dword ptr [0x5bb57b], 0x2706             # 0043d28b
    jle.d8 L_0043d2f4                            # 0043d295
    # block 0x0043d297: entered by fall-through of jle at 0x0043d295, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0043d2db (forward)
    push 0x2706                                  # 0043d297
    mov eax, dword ptr [0x5bb57b]                # 0043d29c
    push eax                                     # 0043d2a1
    push 0x54739c                                # 0043d2a2
    push 0x63888b                                # 0043d2a7
    call FUN_0050ca3e                            # 0043d2ac
    add esp, 0x10                                # 0043d2b1
    push 0x63888b                                # 0043d2b4
    mov ecx, 0x583979                            # 0043d2b9
    call FUN_004264e8                            # 0043d2be
    movsx ecx, word ptr [0x63a4cd]               # 0043d2c3
    test ecx, ecx                                # 0043d2ca
    je.d8 L_0043d2db                             # 0043d2cc
    # block 0x0043d2ce: entered by fall-through of je at 0x0043d2cc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043d2db
    push 0x63888b                                # 0043d2ce
    call FUN_0044a2b7                            # 0043d2d3
    add esp, 0x4                                 # 0043d2d8
L_0043d2db:
    # block 0x0043d2db: entered by je at 0x0043d2cc, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0043d6ae
    mov dword ptr [0x63a58a], 0x1                # 0043d2db
    mov ecx, 0x5cf659                            # 0043d2e5
    call FUN_004c97b4                            # 0043d2ea
    jmp.d32 L_0043d6ae                           # 0043d2ef
L_0043d2f4:
    # block 0x0043d2f4: entered by jle at 0x0043d295, 15 instruction(s), calls FUN_0050ca3e, FUN_00433c60, ends with je to 0x0043d34e (forward)
    movsx edx, word ptr [0x5bb57b]               # 0043d2f4
    push edx                                     # 0043d2fb
    push 0x5473dc                                # 0043d2fc
    push 0x5473e0                                # 0043d301
    lea eax, [ebp - local_110]                   # 0043d306
    push eax                                     # 0043d30c
    call FUN_0050ca3e                            # 0043d30d
    add esp, 0x10                                # 0043d312
    lea ecx, [ebp - local_110]                   # 0043d315
    push ecx                                     # 0043d31b
    lea ecx, [ebp - local_6088]                  # 0043d31c
    call FUN_00433c60                            # 0043d322
    mov dword ptr [ebp - local_4], 0x0           # 0043d327
    cmp dword ptr [0x63a58a], 0x0                # 0043d32e
    je.d8 L_0043d34e                             # 0043d335
    # block 0x0043d337: entered by fall-through of je at 0x0043d335, 4 instruction(s), calls FUN_00433e63, ends with forward jump to 0x0043d6ae
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d337
    lea ecx, [ebp - local_6088]                  # 0043d33e
    call FUN_00433e63                            # 0043d344
    jmp.d32 L_0043d6ae                           # 0043d349
L_0043d34e:
    # block 0x0043d34e: entered by je at 0x0043d335, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x0043d405 (forward)
    push 0x5473e8                                # 0043d34e
    lea ecx, [ebp - local_6088]                  # 0043d353
    call FUN_004343a2                            # 0043d359
    test eax, eax                                # 0043d35e
    jne.d32 L_0043d405                           # 0043d360
    # block 0x0043d366: entered by fall-through of jne at 0x0043d360, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x0043d3ed (forward)
    push 0x5473f0                                # 0043d366
    lea ecx, [ebp - local_6088]                  # 0043d36b
    call FUN_004343a2                            # 0043d371
    test eax, eax                                # 0043d376
    jne.d8 L_0043d3ed                            # 0043d378
    # block 0x0043d37a: entered by fall-through of jne at 0x0043d378, 13 instruction(s), calls FUN_0050ca3e, FUN_0042639d, ends with je to 0x0043d3c2 (forward)
    push 0x5473f8                                # 0043d37a
    push 0x547400                                # 0043d37f
    push 0x547408                                # 0043d384
    push 0x63888b                                # 0043d389
    call FUN_0050ca3e                            # 0043d38e
    add esp, 0x10                                # 0043d393
    push 0x547418                                # 0043d396
    push 0x547420                                # 0043d39b
    mov ecx, 0x583979                            # 0043d3a0
    call FUN_0042639d                            # 0043d3a5
    movsx edx, word ptr [0x63a4cd]               # 0043d3aa
    test edx, edx                                # 0043d3b1
    je.d8 L_0043d3c2                             # 0043d3b3
    # block 0x0043d3b5: entered by fall-through of je at 0x0043d3b3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043d3c2
    push 0x63888b                                # 0043d3b5
    call FUN_0044a2b7                            # 0043d3ba
    add esp, 0x4                                 # 0043d3bf
L_0043d3c2:
    # block 0x0043d3c2: entered by je at 0x0043d3b3, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043d6ae
    mov dword ptr [0x63a58a], 0x1                # 0043d3c2
    mov ecx, 0x5cf659                            # 0043d3cc
    call FUN_004c97b4                            # 0043d3d1
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d3d6
    lea ecx, [ebp - local_6088]                  # 0043d3dd
    call FUN_00433e63                            # 0043d3e3
    jmp.d32 L_0043d6ae                           # 0043d3e8
L_0043d3ed:
    # block 0x0043d3ed: entered by jne at 0x0043d378, 4 instruction(s), ends with forward jump to 0x0043d411
    mov dword ptr [ebp - local_11c], 0x1         # 0043d3ed
    mov eax, dword ptr [ebp - local_4f68]        # 0043d3f7
    mov dword ptr [ebp - local_114], eax         # 0043d3fd
    jmp.d8 L_0043d411                            # 0043d403
L_0043d405:
    # block 0x0043d405: entered by jne at 0x0043d360, 2 instruction(s), falls into the block at 0x0043d411
    mov ecx, dword ptr [ebp - local_4f68]        # 0043d405
    mov dword ptr [ebp - local_118], ecx         # 0043d40b
L_0043d411:
    # block 0x0043d411: entered by jmp at 0x0043d403, 3 instruction(s), ends with je to 0x0043d448 (forward)
    mov byte ptr [0x63888b], 0x0                 # 0043d411
    cmp dword ptr [ebp - local_4f5c], 0xa5       # 0043d418
    je.d8 L_0043d448                             # 0043d422
    # block 0x0043d424: entered by fall-through of je at 0x0043d422, 2 instruction(s), ends with jne to 0x0043d448 (forward)
    cmp dword ptr [ebp - local_11c], 0x0         # 0043d424
    jne.d8 L_0043d448                            # 0043d42b
    # block 0x0043d42d: entered by fall-through of jne at 0x0043d42b, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0043d473
    lea edx, [ebp - local_110]                   # 0043d42d
    push edx                                     # 0043d433
    push 0x547434                                # 0043d434
    push 0x63888b                                # 0043d439
    call FUN_0050ca3e                            # 0043d43e
    add esp, 0xc                                 # 0043d443
    jmp.d8 L_0043d473                            # 0043d446
L_0043d448:
    # block 0x0043d448: entered by je at 0x0043d422; jne at 0x0043d42b, 2 instruction(s), ends with je to 0x0043d473 (forward)
    cmp dword ptr [ebp - local_4f5c], 0x7e       # 0043d448
    je.d8 L_0043d473                             # 0043d44f
    # block 0x0043d451: entered by fall-through of je at 0x0043d44f, 2 instruction(s), ends with je to 0x0043d473 (forward)
    cmp dword ptr [ebp - local_11c], 0x0         # 0043d451
    je.d8 L_0043d473                             # 0043d458
    # block 0x0043d45a: entered by fall-through of je at 0x0043d458, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x0043d473
    lea eax, [ebp - local_110]                   # 0043d45a
    push eax                                     # 0043d460
    push 0x547474                                # 0043d461
    push 0x63888b                                # 0043d466
    call FUN_0050ca3e                            # 0043d46b
    add esp, 0xc                                 # 0043d470
L_0043d473:
    # block 0x0043d473: entered by jmp at 0x0043d446; je at 0x0043d44f; je at 0x0043d458, 8 instruction(s), ends with jbe to 0x0043d4da (forward)
    mov edi, 0x63888b                            # 0043d473
    or ecx, -0x1                                 # 0043d478
    {load} xor eax, eax                          # 0043d47b
    repne scasb al, byte ptr es:[edi]            # 0043d47d
    not ecx                                      # 0043d47f
    add ecx, -0x1                                # 0043d481
    test ecx, ecx                                # 0043d484
    jbe.d8 L_0043d4da                            # 0043d486
    # block 0x0043d488: entered by fall-through of jbe at 0x0043d486, 6 instruction(s), calls FUN_004264e8, ends with je to 0x0043d4af (forward)
    push 0x63888b                                # 0043d488
    mov ecx, 0x583979                            # 0043d48d
    call FUN_004264e8                            # 0043d492
    movsx ecx, word ptr [0x63a4cd]               # 0043d497
    test ecx, ecx                                # 0043d49e
    je.d8 L_0043d4af                             # 0043d4a0
    # block 0x0043d4a2: entered by fall-through of je at 0x0043d4a0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043d4af
    push 0x63888b                                # 0043d4a2
    call FUN_0044a2b7                            # 0043d4a7
    add esp, 0x4                                 # 0043d4ac
L_0043d4af:
    # block 0x0043d4af: entered by je at 0x0043d4a0, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043d6ae
    mov dword ptr [0x63a58a], 0x1                # 0043d4af
    mov ecx, 0x5cf659                            # 0043d4b9
    call FUN_004c97b4                            # 0043d4be
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d4c3
    lea ecx, [ebp - local_6088]                  # 0043d4ca
    call FUN_00433e63                            # 0043d4d0
    jmp.d32 L_0043d6ae                           # 0043d4d5
L_0043d4da:
    # block 0x0043d4da: entered by jbe at 0x0043d486, 2 instruction(s), ends with je to 0x0043d527 (forward)
    cmp dword ptr [ebp - local_11c], 0x0         # 0043d4da
    je.d8 L_0043d527                             # 0043d4e1
    # block 0x0043d4e3: entered by fall-through of je at 0x0043d4e1, 7 instruction(s), ends with jne to 0x0043d505 (forward)
    mov edi, 0x5474bc                            # 0043d4e3
    mov esi, dword ptr [ebp - local_114]         # 0043d4e8
    add esi, 0x32                                # 0043d4ee
    mov ecx, 0xd                                 # 0043d4f1
    {load} xor edx, edx                          # 0043d4f6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043d4f8
    jne.d8 L_0043d505                            # 0043d4fa
    # block 0x0043d4fc: entered by fall-through of jne at 0x0043d4fa, 2 instruction(s), ends with forward jump to 0x0043d525
    mov dword ptr [ebp - local_10], 0x1          # 0043d4fc
    jmp.d8 L_0043d525                            # 0043d503
L_0043d505:
    # block 0x0043d505: entered by jne at 0x0043d4fa, 7 instruction(s), ends with jne to 0x0043d525 (forward)
    mov edi, 0x5474cc                            # 0043d505
    mov esi, dword ptr [ebp - local_114]         # 0043d50a
    add esi, 0x32                                # 0043d510
    mov ecx, 0x11                                # 0043d513
    {load} xor eax, eax                          # 0043d518
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043d51a
    jne.d8 L_0043d525                            # 0043d51c
    # block 0x0043d51e: entered by fall-through of jne at 0x0043d51c, 1 instruction(s), falls into the block at 0x0043d525
    mov dword ptr [ebp - local_10], 0x2          # 0043d51e
L_0043d525:
    # block 0x0043d525: entered by jmp at 0x0043d503; jne at 0x0043d51c, 1 instruction(s), ends with forward jump to 0x0043d569
    jmp.d8 L_0043d569                            # 0043d525
L_0043d527:
    # block 0x0043d527: entered by je at 0x0043d4e1, 7 instruction(s), ends with jne to 0x0043d549 (forward)
    mov edi, 0x5474e0                            # 0043d527
    mov esi, dword ptr [ebp - local_118]         # 0043d52c
    add esi, 0x32                                # 0043d532
    mov ecx, 0xd                                 # 0043d535
    {load} xor edx, edx                          # 0043d53a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043d53c
    jne.d8 L_0043d549                            # 0043d53e
    # block 0x0043d540: entered by fall-through of jne at 0x0043d53e, 2 instruction(s), ends with forward jump to 0x0043d569
    mov dword ptr [ebp - local_10], 0x1          # 0043d540
    jmp.d8 L_0043d569                            # 0043d547
L_0043d549:
    # block 0x0043d549: entered by jne at 0x0043d53e, 7 instruction(s), ends with jne to 0x0043d569 (forward)
    mov edi, 0x5474f0                            # 0043d549
    mov esi, dword ptr [ebp - local_118]         # 0043d54e
    add esi, 0x32                                # 0043d554
    mov ecx, 0x11                                # 0043d557
    {load} xor eax, eax                          # 0043d55c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043d55e
    jne.d8 L_0043d569                            # 0043d560
    # block 0x0043d562: entered by fall-through of jne at 0x0043d560, 1 instruction(s), falls into the block at 0x0043d569
    mov dword ptr [ebp - local_10], 0x2          # 0043d562
L_0043d569:
    # block 0x0043d569: entered by jmp at 0x0043d525; jmp at 0x0043d547; jne at 0x0043d560, 2 instruction(s), ends with je to 0x0043d5d2 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 0043d569
    je.d8 L_0043d5d2                             # 0043d570
    # block 0x0043d572: entered by fall-through of je at 0x0043d570, 2 instruction(s), ends with jne to 0x0043d5d2 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0043d572
    jne.d8 L_0043d5d2                            # 0043d576
    # block 0x0043d578: entered by fall-through of jne at 0x0043d576, 5 instruction(s), ends with je to 0x0043d5a1 (forward)
    mov dword ptr [0x583999], 0x3                # 0043d578
    mov dword ptr [0x63a5c0], 0x1                # 0043d582
    mov ecx, 0x1                                 # 0043d58c
    test ecx, ecx                                # 0043d591
    je.d8 L_0043d5a1                             # 0043d593
    # block 0x0043d595: entered by fall-through of je at 0x0043d593, 2 instruction(s), ends with forward jump to 0x0043d5bb
    mov dword ptr [ebp - local_608c], 0x0        # 0043d595
    jmp.d8 L_0043d5bb                            # 0043d59f
L_0043d5a1:
    # block 0x0043d5a1: entered by je at 0x0043d593, 6 instruction(s), calls FUN_00427a40, falls into the block at 0x0043d5bb
    mov edx, dword ptr [0x5bb57b]                # 0043d5a1
    push edx                                     # 0043d5a7
    push 0x547504                                # 0043d5a8
    call FUN_00427a40                            # 0043d5ad
    add esp, 0x8                                 # 0043d5b2
    mov dword ptr [ebp - local_608c], eax        # 0043d5b5
L_0043d5bb:
    # block 0x0043d5bb: entered by jmp at 0x0043d59f, 4 instruction(s), calls FUN_00433e63, ends with forward jump to 0x0043d6ae
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d5bb
    lea ecx, [ebp - local_6088]                  # 0043d5c2
    call FUN_00433e63                            # 0043d5c8
    jmp.d32 L_0043d6ae                           # 0043d5cd
L_0043d5d2:
    # block 0x0043d5d2: entered by je at 0x0043d570; jne at 0x0043d576, 4 instruction(s), calls FUN_004ee5cd, ends with jne to 0x0043d655 (forward)
    mov ecx, 0x57fd34                            # 0043d5d2
    call FUN_004ee5cd                            # 0043d5d7
    test eax, eax                                # 0043d5dc
    jne.d8 L_0043d655                            # 0043d5de
    # block 0x0043d5e0: entered by fall-through of jne at 0x0043d5de, 2 instruction(s), ends with jne to 0x0043d655 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0043d5e0
    jne.d8 L_0043d655                            # 0043d5e4
    # block 0x0043d5e6: entered by fall-through of jne at 0x0043d5e4, 3 instruction(s), ends with jne to 0x0043d5fe (forward)
    movsx eax, word ptr [0x5c3a31]               # 0043d5e6
    cmp eax, 0x270f                              # 0043d5ed
    jne.d8 L_0043d5fe                            # 0043d5f2
    # block 0x0043d5f4: entered by fall-through of jne at 0x0043d5f2, 3 instruction(s), calls FUN_0042e693, falls into the block at 0x0043d5fe
    push 0x2                                     # 0043d5f4
    call FUN_0042e693                            # 0043d5f6
    add esp, 0x4                                 # 0043d5fb
L_0043d5fe:
    # block 0x0043d5fe: entered by jne at 0x0043d5f2, 5 instruction(s), ends with je to 0x0043d627 (forward)
    mov dword ptr [0x583999], 0x3                # 0043d5fe
    mov dword ptr [0x63a5c4], 0x1                # 0043d608
    mov ecx, 0x1                                 # 0043d612
    test ecx, ecx                                # 0043d617
    je.d8 L_0043d627                             # 0043d619
    # block 0x0043d61b: entered by fall-through of je at 0x0043d619, 2 instruction(s), ends with forward jump to 0x0043d641
    mov dword ptr [ebp - local_6090], 0x0        # 0043d61b
    jmp.d8 L_0043d641                            # 0043d625
L_0043d627:
    # block 0x0043d627: entered by je at 0x0043d619, 6 instruction(s), calls FUN_00427a40, falls into the block at 0x0043d641
    mov edx, dword ptr [0x5bb57b]                # 0043d627
    push edx                                     # 0043d62d
    push 0x54755c                                # 0043d62e
    call FUN_00427a40                            # 0043d633
    add esp, 0x8                                 # 0043d638
    mov dword ptr [ebp - local_6090], eax        # 0043d63b
L_0043d641:
    # block 0x0043d641: entered by jmp at 0x0043d625, 4 instruction(s), calls FUN_00433e63, ends with forward jump to 0x0043d6ae
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d641
    lea ecx, [ebp - local_6088]                  # 0043d648
    call FUN_00433e63                            # 0043d64e
    jmp.d8 L_0043d6ae                            # 0043d653
L_0043d655:
    # block 0x0043d655: entered by jne at 0x0043d5de; jne at 0x0043d5e4, 3 instruction(s), calls FUN_00433e63, falls into the block at 0x0043d667
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043d655
    lea ecx, [ebp - local_6088]                  # 0043d65c
    call FUN_00433e63                            # 0043d662
L_0043d667:
    # block 0x0043d667: entered by jne at 0x0043d274, 3 instruction(s), ends with je to 0x0043d67c (forward)
    mov eax, 0x1                                 # 0043d667
    test eax, eax                                # 0043d66c
    je.d8 L_0043d67c                             # 0043d66e
    # block 0x0043d670: entered by fall-through of je at 0x0043d66e, 2 instruction(s), ends with forward jump to 0x0043d696
    mov dword ptr [ebp - local_6094], 0x0        # 0043d670
    jmp.d8 L_0043d696                            # 0043d67a
L_0043d67c:
    # block 0x0043d67c: entered by je at 0x0043d66e, 6 instruction(s), calls FUN_00427a40, falls into the block at 0x0043d696
    mov ecx, dword ptr [0x5bb57b]                # 0043d67c
    push ecx                                     # 0043d682
    push 0x5475c0                                # 0043d683
    call FUN_00427a40                            # 0043d688
    add esp, 0x8                                 # 0043d68d
    mov dword ptr [ebp - local_6094], eax        # 0043d690
L_0043d696:
    # block 0x0043d696: entered by jmp at 0x0043d67a, 4 instruction(s), calls FUN_00447c36, ends with jne to 0x0043d6ae (forward)
    mov ecx, 0x6198d7                            # 0043d696
    call FUN_00447c36                            # 0043d69b
    test eax, eax                                # 0043d6a0
    jne.d8 L_0043d6ae                            # 0043d6a2
    # block 0x0043d6a4: entered by fall-through of jne at 0x0043d6a2, 1 instruction(s), falls into the block at 0x0043d6ae
    mov dword ptr [0x583999], 0x1                # 0043d6a4
L_0043d6ae:
    # block 0x0043d6ae: entered by jmp at 0x0043d2ef; jmp at 0x0043d349; jmp at 0x0043d3e8; jmp at 0x0043d4d5; more, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0043d6ae
    mov dword ptr fs:[0x0], ecx                  # 0043d6b1
    pop edi                                      # 0043d6b8
    pop esi                                      # 0043d6b9
    {load} mov esp, ebp                          # 0043d6ba
    pop ebp                                      # 0043d6bc
    ret                                          # 0043d6bd

