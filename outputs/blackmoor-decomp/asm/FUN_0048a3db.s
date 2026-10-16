# FUN_0048a3db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a3db
# extent:       0x0048a3db-0x0048a5eb (528 code bytes)
# span:         0x0048a3db-0x0048a5f0 (code 528, tables 0, padding 5)
# sha256:       fa1c571827b29129694af10d621255d0ababe74411e3f17c646165eb987f28d6
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048a3db
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_4, field_1a, field_1e, field_29, field_aa2, field_ab6; [ecx + n] field_2, field_16, field_aa, field_ac, field_6ec, field_ab6; [edx + n] field_6, field_a, field_e, field_12, field_22, field_23, field_aa2, field_aae
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, FUN_004c97b4, FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/action_family_36_runtime.h:overlay36_draw_slot (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 154 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_29, 0x29  # offset +0x29
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ac, 0xac  # offset +0xac
.equ field_6ec, 0x6ec  # offset +0x6ec
.equ field_aa2, 0xaa2  # offset +0xaa2
.equ field_aae, 0xaae  # offset +0xaae
.equ field_ab6, 0xab6  # offset +0xab6

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0048a3db - 0x401000
.globl FUN_0048a3db
FUN_0048a3db:
    # block 0x0048a3db: entry, 13 instruction(s), ends with je to 0x0048a456 (forward)
    push ebp                                     # 0048a3db
    {load} mov ebp, esp                          # 0048a3dc
    sub esp, 0x38                                # 0048a3de
    mov eax, dword ptr [ebp + arg_8]             # 0048a3e1
    imul eax, eax, 0x4a                          # 0048a3e4
    mov ecx, dword ptr [eax + 0x5d15af]          # 0048a3e7
    mov dword ptr [ebp - local_c], ecx           # 0048a3ed
    mov edx, dword ptr [ebp - local_c]           # 0048a3f0
    mov dword ptr [ebp - local_8], edx           # 0048a3f3
    mov eax, dword ptr [ebp - local_c]           # 0048a3f6
    movsx ecx, word ptr [eax + field_aa2]        # 0048a3f9
    cmp dword ptr [ebp + arg_8], ecx             # 0048a400
    je.d8 L_0048a456                             # 0048a403
    # block 0x0048a405: entered by fall-through of je at 0x0048a403, 12 instruction(s), calls FUN_0050ca3e, ends with je to 0x0048a43e (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048a405
    movsx eax, word ptr [edx + field_aa2]        # 0048a408
    push eax                                     # 0048a40f
    mov ecx, dword ptr [ebp + arg_8]             # 0048a410
    push ecx                                     # 0048a413
    push 0x54e1f4                                # 0048a414
    push 0x63888b                                # 0048a419
    call FUN_0050ca3e                            # 0048a41e
    add esp, 0x10                                # 0048a423
    movsx edx, word ptr [0x63a4cd]               # 0048a426
    test edx, edx                                # 0048a42d
    je.d8 L_0048a43e                             # 0048a42f
    # block 0x0048a431: entered by fall-through of je at 0x0048a42f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0048a43e
    push 0x63888b                                # 0048a431
    call FUN_0044a2b7                            # 0048a436
    add esp, 0x4                                 # 0048a43b
L_0048a43e:
    # block 0x0048a43e: entered by je at 0x0048a42f, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0048a456
    push 0x0                                     # 0048a43e
    push 0x0                                     # 0048a440
    push 0x63888b                                # 0048a442
    call FUN_0052139c                            # 0048a447
    mov ecx, 0x5cf659                            # 0048a44c
    call FUN_004c97b4                            # 0048a451
L_0048a456:
    # block 0x0048a456: entered by je at 0x0048a403, 2 instruction(s), ends with forward jump to 0x0048a468
    mov dword ptr [ebp - local_38], 0x0          # 0048a456
    jmp.d8 L_0048a468                            # 0048a45d
L_0048a45f:
    # block 0x0048a45f: entered by jmp at 0x0048a5e2, 3 instruction(s), falls into the block at 0x0048a468
    mov eax, dword ptr [ebp - local_38]          # 0048a45f
    add eax, 0x1                                 # 0048a462
    mov dword ptr [ebp - local_38], eax          # 0048a465
L_0048a468:
    # block 0x0048a468: entered by jmp at 0x0048a45d, 4 instruction(s), ends with jge to 0x0048a5e7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048a468
    movsx edx, word ptr [ecx + field_aa]         # 0048a46b
    cmp dword ptr [ebp - local_38], edx          # 0048a472
    jge.d32 L_0048a5e7                           # 0048a475
    # block 0x0048a47b: entered by fall-through of jge at 0x0048a475, 10 instruction(s), ends with jne to 0x0048a5e2 (forward)
    mov eax, dword ptr [ebp - local_38]          # 0048a47b
    imul eax, eax, 0x26                          # 0048a47e
    mov ecx, dword ptr [ebp - local_c]           # 0048a481
    lea edx, [ecx + eax + field_6ec]             # 0048a484
    mov dword ptr [ebp - local_4], edx           # 0048a48b
    mov eax, dword ptr [ebp - local_4]           # 0048a48e
    movsx ecx, word ptr [eax]                    # 0048a491
    movsx edx, word ptr [0x5bb50b]               # 0048a494
    {load} cmp ecx, edx                          # 0048a49b
    jne.d32 L_0048a5e2                           # 0048a49d
    # block 0x0048a4a3: entered by fall-through of jne at 0x0048a49d, 4 instruction(s), ends with jne to 0x0048a4be (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048a4a3
    movsx ecx, word ptr [eax + field_29]         # 0048a4a6
    cmp ecx, 0x2                                 # 0048a4aa
    jne.d8 L_0048a4be                            # 0048a4ad
    # block 0x0048a4af: entered by fall-through of jne at 0x0048a4ad, 4 instruction(s), ends with forward jump to 0x0048a4c8
    mov edx, dword ptr [ebp - local_c]           # 0048a4af
    movsx eax, word ptr [edx + field_aae]        # 0048a4b2
    mov dword ptr [ebp - local_34], eax          # 0048a4b9
    jmp.d8 L_0048a4c8                            # 0048a4bc
L_0048a4be:
    # block 0x0048a4be: entered by jne at 0x0048a4ad, 3 instruction(s), falls into the block at 0x0048a4c8
    mov ecx, dword ptr [ebp - local_4]           # 0048a4be
    movsx edx, word ptr [ecx + field_2]          # 0048a4c1
    mov dword ptr [ebp - local_34], edx          # 0048a4c5
L_0048a4c8:
    # block 0x0048a4c8: entered by jmp at 0x0048a4bc, 45 instruction(s), ends with jne to 0x0048a586 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0048a4c8
    shl eax, 0x4                                 # 0048a4cb
    mov ecx, dword ptr [ebp - local_c]           # 0048a4ce
    lea edx, [ecx + eax + field_ac]              # 0048a4d1
    mov dword ptr [ebp - local_10], edx          # 0048a4d8
    mov eax, dword ptr [ebp - local_10]          # 0048a4db
    mov ecx, dword ptr [eax + field_4]           # 0048a4de
    mov edx, dword ptr [ebp - local_4]           # 0048a4e1
    add ecx, dword ptr [edx + field_a]           # 0048a4e4
    mov dword ptr [ebp - local_2c], ecx          # 0048a4e7
    mov eax, dword ptr [ebp - local_10]          # 0048a4ea
    mov ecx, dword ptr [eax + field_4]           # 0048a4ed
    mov edx, dword ptr [ebp - local_4]           # 0048a4f0
    add ecx, dword ptr [edx + field_12]          # 0048a4f3
    mov dword ptr [ebp - local_24], ecx          # 0048a4f6
    mov eax, dword ptr [ebp - local_10]          # 0048a4f9
    mov ecx, dword ptr [eax]                     # 0048a4fc
    mov edx, dword ptr [ebp - local_4]           # 0048a4fe
    add ecx, dword ptr [edx + field_6]           # 0048a501
    mov dword ptr [ebp - local_30], ecx          # 0048a504
    mov eax, dword ptr [ebp - local_10]          # 0048a507
    mov ecx, dword ptr [eax]                     # 0048a50a
    mov edx, dword ptr [ebp - local_4]           # 0048a50c
    add ecx, dword ptr [edx + field_e]           # 0048a50f
    mov dword ptr [ebp - local_28], ecx          # 0048a512
    mov eax, dword ptr [ebp - local_4]           # 0048a515
    mov ecx, dword ptr [eax + field_1a]          # 0048a518
    add ecx, dword ptr [0x58318a]                # 0048a51b
    mov dword ptr [ebp - local_1c], ecx          # 0048a521
    mov edx, dword ptr [ebp - local_4]           # 0048a524
    mov eax, dword ptr [edx + field_22]          # 0048a527
    add eax, dword ptr [0x58318a]                # 0048a52a
    mov dword ptr [ebp - local_14], eax          # 0048a530
    mov ecx, dword ptr [ebp - local_4]           # 0048a533
    mov edx, dword ptr [ecx + field_16]          # 0048a536
    add edx, dword ptr [0x583186]                # 0048a539
    mov dword ptr [ebp - local_20], edx          # 0048a53f
    mov eax, dword ptr [ebp - local_4]           # 0048a542
    mov ecx, dword ptr [eax + field_1e]          # 0048a545
    add ecx, dword ptr [0x583186]                # 0048a548
    mov dword ptr [ebp - local_18], ecx          # 0048a54e
    mov edx, dword ptr [ebp - local_8]           # 0048a551
    movsx eax, word ptr [edx + field_23]         # 0048a554
    cmp eax, 0x1                                 # 0048a558
    jne.d8 L_0048a586                            # 0048a55b
    # block 0x0048a55d: entered by fall-through of jne at 0x0048a55b, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0048a5e2
    push 0x54e270                                # 0048a55d
    lea ecx, [ebp - local_20]                    # 0048a562
    push ecx                                     # 0048a565
    lea edx, [ebp - local_30]                    # 0048a566
    push edx                                     # 0048a569
    mov eax, dword ptr [0x5cf665]                # 0048a56a
    push eax                                     # 0048a56f
    mov ecx, dword ptr [ebp - local_c]           # 0048a570
    mov edx, dword ptr [ecx + field_ab6]         # 0048a573
    push edx                                     # 0048a579
    mov ecx, 0x5cf659                            # 0048a57a
    call FUN_004c5377                            # 0048a57f
    jmp.d8 L_0048a5e2                            # 0048a584
L_0048a586:
    # block 0x0048a586: entered by jne at 0x0048a55b, 4 instruction(s), ends with jne to 0x0048a5ba (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048a586
    movsx ecx, word ptr [eax + field_29]         # 0048a589
    cmp ecx, 0x2                                 # 0048a58d
    jne.d8 L_0048a5ba                            # 0048a590
    # block 0x0048a592: entered by fall-through of jne at 0x0048a590, 12 instruction(s), calls FUN_004c5377, falls into the block at 0x0048a5ba
    push 0x54e288                                # 0048a592
    lea edx, [ebp - local_20]                    # 0048a597
    push edx                                     # 0048a59a
    mov eax, dword ptr [ebp - local_4]           # 0048a59b
    add eax, 0x16                                # 0048a59e
    push eax                                     # 0048a5a1
    mov ecx, dword ptr [0x5cf665]                # 0048a5a2
    push ecx                                     # 0048a5a8
    mov edx, dword ptr [0x5d15e3]                # 0048a5a9
    push edx                                     # 0048a5af
    mov ecx, 0x5cf659                            # 0048a5b0
    call FUN_004c5377                            # 0048a5b5
L_0048a5ba:
    # block 0x0048a5ba: entered by jne at 0x0048a590, 12 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0048a5e2
    push 0x54e2b4                                # 0048a5ba
    lea eax, [ebp - local_20]                    # 0048a5bf
    push eax                                     # 0048a5c2
    lea ecx, [ebp - local_30]                    # 0048a5c3
    push ecx                                     # 0048a5c6
    mov edx, dword ptr [0x5cf665]                # 0048a5c7
    push edx                                     # 0048a5cd
    mov eax, dword ptr [ebp - local_c]           # 0048a5ce
    mov ecx, dword ptr [eax + field_ab6]         # 0048a5d1
    push ecx                                     # 0048a5d7
    mov ecx, 0x5cf659                            # 0048a5d8
    call FUN_004c5d4b                            # 0048a5dd
L_0048a5e2:
    # block 0x0048a5e2: entered by jne at 0x0048a49d; jmp at 0x0048a584, 1 instruction(s), ends with backward jump to 0x0048a45f
    jmp.d32 L_0048a45f                           # 0048a5e2
L_0048a5e7:
    # block 0x0048a5e7: entered by jge at 0x0048a475, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048a5e7
    pop ebp                                      # 0048a5e9
    ret                                          # 0048a5ea

# --- data items (not part of the function) -------------------------
.org 0x0048a5eb - 0x401000
PAD_0048a5eb:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

