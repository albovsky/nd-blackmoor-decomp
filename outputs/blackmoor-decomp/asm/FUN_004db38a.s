# FUN_004db38a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db38a
# extent:       0x004db38a-0x004db770 (998 code bytes)
# span:         0x004db38a-0x004db780 (code 998, tables 16, padding 0)
# sha256:       870e2173d1aba51f7e01767800e69b48b6f40c6b3705efc9b9bbb9bd760159a3
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db38a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_14, field_18, field_28, field_34, field_38, field_3c, field_40, field_a0, field_minus_1; [ecx + n] field_14, field_18, field_1c, field_20, field_24, field_28, field_2c, field_30, field_34, field_38, field_40, field_94 and 1 more; [edx + n] field_4, field_8, field_c, field_14, field_18, field_24, field_30, field_34, field_38, field_3c, field_40, field_44 and 7 more
# callees:      calls FUN_004dadff, FUN_004daeb5, FUN_004dbb13, FUN_004d57e8, FUN_004db780, FUN_004d5834, FUN_004db817, FUN_004d5316, FUN_004d56e2, FUN_0050ca3e, FUN_0044a2b7, FUN_004dae88
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 283 instruction(s), 9 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004d5316, .text + (0x004d5316 - 0x401000)
.set FUN_004d56e2, .text + (0x004d56e2 - 0x401000)
.set FUN_004d57e8, .text + (0x004d57e8 - 0x401000)
.set FUN_004d5834, .text + (0x004d5834 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004db780, .text + (0x004db780 - 0x401000)
.set FUN_004db817, .text + (0x004db817 - 0x401000)
.set FUN_004dbb13, .text + (0x004dbb13 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004db38a - 0x401000
.globl FUN_004db38a
FUN_004db38a:
    # block 0x004db38a: entry, 42 instruction(s), calls FUN_004dadff, FUN_004daeb5, FUN_004dbb13, ends with jle to 0x004db459 (forward)
    push ebp                                     # 004db38a
    {load} mov ebp, esp                          # 004db38b
    sub esp, 0x18                                # 004db38d
    mov dword ptr [ebp - local_14], ecx          # 004db390
    mov ecx, 0x5830a6                            # 004db393
    call FUN_004dadff                            # 004db398
    mov dword ptr [0x5d16cd], 0x0                # 004db39d
    mov dword ptr [0x5d1683], 0x0                # 004db3a7
    lea eax, [ebp - local_10]                    # 004db3b1
    push eax                                     # 004db3b4
    mov ecx, 0x5830a6                            # 004db3b5
    call FUN_004daeb5                            # 004db3ba
    mov ecx, dword ptr [eax]                     # 004db3bf
    mov edx, dword ptr [eax + field_4]           # 004db3c1
    mov eax, dword ptr [ebp - local_14]          # 004db3c4
    mov dword ptr [eax + field_14], ecx          # 004db3c7
    mov dword ptr [eax + field_18], edx          # 004db3ca
    mov ecx, dword ptr [ebp - local_14]          # 004db3cd
    call FUN_004dbb13                            # 004db3d0
    mov ecx, dword ptr [ebp - local_14]          # 004db3d5
    mov edx, dword ptr [ebp - local_14]          # 004db3d8
    mov eax, dword ptr [ecx + field_14]          # 004db3db
    sub eax, dword ptr [edx + field_34]          # 004db3de
    cdq                                          # 004db3e1
    {load} xor eax, edx                          # 004db3e2
    {load} sub eax, edx                          # 004db3e4
    mov ecx, dword ptr [ebp - local_14]          # 004db3e6
    mov dword ptr [ecx + field_94], eax          # 004db3e9
    mov edx, dword ptr [ebp - local_14]          # 004db3ef
    mov eax, dword ptr [ebp - local_14]          # 004db3f2
    mov ecx, dword ptr [edx + field_18]          # 004db3f5
    sub ecx, dword ptr [eax + field_38]          # 004db3f8
    {load} mov eax, ecx                          # 004db3fb
    cdq                                          # 004db3fd
    {load} xor eax, edx                          # 004db3fe
    {load} sub eax, edx                          # 004db400
    mov edx, dword ptr [ebp - local_14]          # 004db402
    mov dword ptr [edx + field_98], eax          # 004db405
    movsx eax, word ptr [0x5d2f0d]               # 004db40b
    mov ecx, dword ptr [ebp - local_14]          # 004db412
    cmp dword ptr [ecx + field_94], eax          # 004db415
    jle.d8 L_004db459                            # 004db41b
    # block 0x004db41d: entered by fall-through of jle at 0x004db41b, 6 instruction(s), ends with jle to 0x004db444 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004db41d
    mov eax, dword ptr [ebp - local_14]          # 004db420
    mov ecx, dword ptr [edx + field_14]          # 004db423
    sub ecx, dword ptr [eax + field_34]          # 004db426
    test ecx, ecx                                # 004db429
    jle.d8 L_004db444                            # 004db42b
    # block 0x004db42d: entered by fall-through of jle at 0x004db42b, 7 instruction(s), ends with forward jump to 0x004db459
    movsx edx, word ptr [0x5d2f0d]               # 004db42d
    mov eax, dword ptr [ebp - local_14]          # 004db434
    mov ecx, dword ptr [eax + field_34]          # 004db437
    {load} add ecx, edx                          # 004db43a
    mov edx, dword ptr [ebp - local_14]          # 004db43c
    mov dword ptr [edx + field_14], ecx          # 004db43f
    jmp.d8 L_004db459                            # 004db442
L_004db444:
    # block 0x004db444: entered by jle at 0x004db42b, 6 instruction(s), falls into the block at 0x004db459
    movsx eax, word ptr [0x5d2f0d]               # 004db444
    mov ecx, dword ptr [ebp - local_14]          # 004db44b
    mov edx, dword ptr [ecx + field_34]          # 004db44e
    {load} sub edx, eax                          # 004db451
    mov eax, dword ptr [ebp - local_14]          # 004db453
    mov dword ptr [eax + field_14], edx          # 004db456
L_004db459:
    # block 0x004db459: entered by jle at 0x004db41b; jmp at 0x004db442, 4 instruction(s), ends with jle to 0x004db4a7 (forward)
    movsx ecx, word ptr [0x5d2f0f]               # 004db459
    mov edx, dword ptr [ebp - local_14]          # 004db460
    cmp dword ptr [edx + field_98], ecx          # 004db463
    jle.d8 L_004db4a7                            # 004db469
    # block 0x004db46b: entered by fall-through of jle at 0x004db469, 6 instruction(s), ends with jle to 0x004db492 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004db46b
    mov ecx, dword ptr [ebp - local_14]          # 004db46e
    mov edx, dword ptr [eax + field_18]          # 004db471
    sub edx, dword ptr [ecx + field_38]          # 004db474
    test edx, edx                                # 004db477
    jle.d8 L_004db492                            # 004db479
    # block 0x004db47b: entered by fall-through of jle at 0x004db479, 7 instruction(s), ends with forward jump to 0x004db4a7
    movsx eax, word ptr [0x5d2f0f]               # 004db47b
    mov ecx, dword ptr [ebp - local_14]          # 004db482
    mov edx, dword ptr [ecx + field_38]          # 004db485
    {load} add edx, eax                          # 004db488
    mov eax, dword ptr [ebp - local_14]          # 004db48a
    mov dword ptr [eax + field_18], edx          # 004db48d
    jmp.d8 L_004db4a7                            # 004db490
L_004db492:
    # block 0x004db492: entered by jle at 0x004db479, 6 instruction(s), falls into the block at 0x004db4a7
    movsx ecx, word ptr [0x5d2f0f]               # 004db492
    mov edx, dword ptr [ebp - local_14]          # 004db499
    mov eax, dword ptr [edx + field_38]          # 004db49c
    {load} sub eax, ecx                          # 004db49f
    mov ecx, dword ptr [ebp - local_14]          # 004db4a1
    mov dword ptr [ecx + field_18], eax          # 004db4a4
L_004db4a7:
    # block 0x004db4a7: entered by jle at 0x004db469; jmp at 0x004db490, 9 instruction(s), calls FUN_004dbb13, ends with ja to 0x004db4d1 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004db4a7
    call FUN_004dbb13                            # 004db4aa
    mov edx, dword ptr [0x583204]                # 004db4af
    mov dword ptr [ebp - local_18], edx          # 004db4b5
    mov eax, dword ptr [ebp - local_18]          # 004db4b8
    sub eax, 0x2                                 # 004db4bb
    mov dword ptr [ebp - local_18], eax          # 004db4be
    cmp dword ptr [ebp - local_18], 0x3          # 004db4c1
    ja.d8 L_004db4d1                             # 004db4c5
    # block 0x004db4c7: entered by fall-through of ja at 0x004db4c5, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4db770]
    mov ecx, dword ptr [ebp - local_18]          # 004db4c7
    jmp dword ptr [4*ecx + SWTAB_004db770_VA]    # 004db4ca
L_004db4d1:
    # block 0x004db4d1: entered by ja at 0x004db4c5, 8 instruction(s), calls FUN_004d57e8, ends with je to 0x004db4f8 (forward)
    push 0x583186                                # 004db4d1
    mov edx, dword ptr [ebp - local_14]          # 004db4d6
    add edx, 0x34                                # 004db4d9
    push edx                                     # 004db4dc
    mov ecx, 0x570450                            # 004db4dd
    call FUN_004d57e8                            # 004db4e2
    test eax, eax                                # 004db4e7
    je.d8 L_004db4f8                             # 004db4e9
    # block 0x004db4eb: entered by fall-through of je at 0x004db4e9, 3 instruction(s), calls FUN_004db780, ends with forward jump to 0x004db672
    mov ecx, dword ptr [ebp - local_14]          # 004db4eb
    call FUN_004db780                            # 004db4ee
    jmp.d32 L_004db672                           # 004db4f3
L_004db4f8:
    # block 0x004db4f8: entered by je at 0x004db4e9, 8 instruction(s), calls FUN_004d5834, ends with je to 0x004db51f (forward)
    push 0x583186                                # 004db4f8
    mov eax, dword ptr [ebp - local_14]          # 004db4fd
    add eax, 0x34                                # 004db500
    push eax                                     # 004db503
    mov ecx, 0x570450                            # 004db504
    call FUN_004d5834                            # 004db509
    test eax, eax                                # 004db50e
    je.d8 L_004db51f                             # 004db510
    # block 0x004db512: entered by fall-through of je at 0x004db510, 3 instruction(s), calls FUN_004db817, ends with forward jump to 0x004db672
    mov ecx, dword ptr [ebp - local_14]          # 004db512
    call FUN_004db817                            # 004db515
    jmp.d32 L_004db672                           # 004db51a
L_004db51f:
    # block 0x004db51f: entered by je at 0x004db510, 26 instruction(s), calls FUN_004d5316, ends with je to 0x004db611 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004db51f
    mov edx, dword ptr [ebp - local_14]          # 004db522
    mov eax, dword ptr [edx + field_38]          # 004db525
    mov dword ptr [ecx + field_28], eax          # 004db528
    mov ecx, dword ptr [ebp - local_14]          # 004db52b
    mov edx, dword ptr [ebp - local_14]          # 004db52e
    mov eax, dword ptr [edx + field_40]          # 004db531
    mov dword ptr [ecx + field_30], eax          # 004db534
    mov ecx, dword ptr [ebp - local_14]          # 004db537
    mov edx, dword ptr [ebp - local_14]          # 004db53a
    mov eax, dword ptr [edx + field_34]          # 004db53d
    mov dword ptr [ecx + field_24], eax          # 004db540
    mov ecx, dword ptr [ebp - local_14]          # 004db543
    mov edx, dword ptr [ebp - local_14]          # 004db546
    mov eax, dword ptr [edx + field_3c]          # 004db549
    mov dword ptr [ecx + field_2c], eax          # 004db54c
    mov dword ptr [0x5d1683], 0x1                # 004db54f
    push 0x583186                                # 004db559
    mov ecx, dword ptr [ebp - local_14]          # 004db55e
    add ecx, 0x34                                # 004db561
    push ecx                                     # 004db564
    mov ecx, 0x570450                            # 004db565
    call FUN_004d5316                            # 004db56a
    mov dword ptr [ebp - local_4], eax           # 004db56f
    cmp dword ptr [ebp - local_4], 0x0           # 004db572
    je.d32 L_004db611                            # 004db576
    # block 0x004db57c: entered by fall-through of je at 0x004db576, 45 instruction(s), calls FUN_004d56e2, ends with forward jump to 0x004db672
    mov edx, dword ptr [ebp - local_14]          # 004db57c
    add edx, 0x34                                # 004db57f
    mov eax, dword ptr [ebp - local_14]          # 004db582
    add eax, 0x54                                # 004db585
    mov ecx, dword ptr [edx]                     # 004db588
    mov dword ptr [eax], ecx                     # 004db58a
    mov ecx, dword ptr [edx + field_4]           # 004db58c
    mov dword ptr [eax + field_4], ecx           # 004db58f
    mov ecx, dword ptr [edx + field_8]           # 004db592
    mov dword ptr [eax + field_8], ecx           # 004db595
    mov edx, dword ptr [edx + field_c]           # 004db598
    mov dword ptr [eax + field_c], edx           # 004db59b
    mov eax, dword ptr [ebp - local_14]          # 004db59e
    mov ecx, dword ptr [eax + field_34]          # 004db5a1
    sub ecx, dword ptr [0x583186]                # 004db5a4
    mov edx, dword ptr [ebp - local_14]          # 004db5aa
    mov dword ptr [edx + field_44], ecx          # 004db5ad
    mov eax, dword ptr [ebp - local_14]          # 004db5b0
    mov ecx, dword ptr [eax + field_3c]          # 004db5b3
    sub ecx, dword ptr [0x583186]                # 004db5b6
    mov edx, dword ptr [ebp - local_14]          # 004db5bc
    mov dword ptr [edx + field_4c], ecx          # 004db5bf
    mov eax, dword ptr [ebp - local_14]          # 004db5c2
    mov ecx, dword ptr [eax + field_38]          # 004db5c5
    sub ecx, dword ptr [0x58318a]                # 004db5c8
    mov edx, dword ptr [ebp - local_14]          # 004db5ce
    mov dword ptr [edx + field_48], ecx          # 004db5d1
    mov eax, dword ptr [ebp - local_14]          # 004db5d4
    mov ecx, dword ptr [eax + field_40]          # 004db5d7
    sub ecx, dword ptr [0x58318a]                # 004db5da
    mov edx, dword ptr [ebp - local_14]          # 004db5e0
    mov dword ptr [edx + field_50], ecx          # 004db5e3
    mov eax, dword ptr [ebp - local_4]           # 004db5e6
    push eax                                     # 004db5e9
    mov ecx, dword ptr [ebp - local_14]          # 004db5ea
    add ecx, 0x54                                # 004db5ed
    push ecx                                     # 004db5f0
    mov edx, dword ptr [ebp - local_14]          # 004db5f1
    add edx, 0x44                                # 004db5f4
    push edx                                     # 004db5f7
    mov ecx, 0x570450                            # 004db5f8
    call FUN_004d56e2                            # 004db5fd
    mov dword ptr [ebp - local_8], eax           # 004db602
    mov dword ptr [0x5d16cd], 0x1                # 004db605
    jmp.d8 L_004db672                            # 004db60f
L_004db611:
    # block 0x004db611: entered by je at 0x004db576, 3 instruction(s), ends with je to 0x004db672 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004db611
    test eax, eax                                # 004db618
    je.d8 L_004db672                             # 004db61a
    # block 0x004db61c: entered by fall-through of je at 0x004db61a, 27 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004db672
    mov ecx, dword ptr [0x583192]                # 004db61c
    push ecx                                     # 004db622
    mov edx, dword ptr [0x58318e]                # 004db623
    push edx                                     # 004db629
    mov eax, dword ptr [0x58318a]                # 004db62a
    push eax                                     # 004db62f
    mov ecx, dword ptr [0x583186]                # 004db630
    push ecx                                     # 004db636
    mov edx, dword ptr [ebp - local_14]          # 004db637
    mov eax, dword ptr [edx + field_30]          # 004db63a
    push eax                                     # 004db63d
    mov ecx, dword ptr [ebp - local_14]          # 004db63e
    mov edx, dword ptr [ecx + field_2c]          # 004db641
    push edx                                     # 004db644
    mov eax, dword ptr [ebp - local_14]          # 004db645
    mov ecx, dword ptr [eax + field_28]          # 004db648
    push ecx                                     # 004db64b
    mov edx, dword ptr [ebp - local_14]          # 004db64c
    mov eax, dword ptr [edx + field_24]          # 004db64f
    push eax                                     # 004db652
    push 0x55af64                                # 004db653
    push 0x63888b                                # 004db658
    call FUN_0050ca3e                            # 004db65d
    add esp, 0x28                                # 004db662
    push 0x63888b                                # 004db665
    call FUN_0044a2b7                            # 004db66a
    add esp, 0x4                                 # 004db66f
L_004db672:
    # block 0x004db672: entered by jmp at 0x004db4f3; jmp at 0x004db51a; jmp at 0x004db60f; je at 0x004db61a; switch case, 65 instruction(s), calls FUN_004dae88, ends with ret
    mov ecx, dword ptr [ebp - local_14]          # 004db672
    mov edx, dword ptr [ebp - local_14]          # 004db675
    mov eax, dword ptr [edx + field_18]          # 004db678
    mov dword ptr [ecx + field_38], eax          # 004db67b
    mov ecx, dword ptr [0x5b44f4]                # 004db67e
    shl ecx, 0x2                                 # 004db684
    mov edx, dword ptr [0x5b44f0]                # 004db687
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004db68d
    mov ecx, dword ptr [ebp - local_14]          # 004db695
    mov edx, dword ptr [ecx + field_38]          # 004db698
    lea eax, [edx + eax - field_minus_1]         # 004db69b
    mov ecx, dword ptr [ebp - local_14]          # 004db69f
    mov dword ptr [ecx + field_40], eax          # 004db6a2
    mov edx, dword ptr [ebp - local_14]          # 004db6a5
    mov eax, dword ptr [ebp - local_14]          # 004db6a8
    mov ecx, dword ptr [eax + field_14]          # 004db6ab
    mov dword ptr [edx + field_34], ecx          # 004db6ae
    mov edx, dword ptr [0x5b44f4]                # 004db6b1
    shl edx, 0x2                                 # 004db6b7
    mov eax, dword ptr [0x5b44f0]                # 004db6ba
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004db6bf
    mov edx, dword ptr [ebp - local_14]          # 004db6c7
    mov eax, dword ptr [edx + field_34]          # 004db6ca
    lea ecx, [eax + ecx - field_minus_1]         # 004db6cd
    mov edx, dword ptr [ebp - local_14]          # 004db6d1
    mov dword ptr [edx + field_3c], ecx          # 004db6d4
    mov eax, dword ptr [ebp - local_14]          # 004db6d7
    mov ecx, dword ptr [eax + field_18]          # 004db6da
    push ecx                                     # 004db6dd
    mov edx, dword ptr [ebp - local_14]          # 004db6de
    mov eax, dword ptr [edx + field_14]          # 004db6e1
    push eax                                     # 004db6e4
    mov ecx, 0x5830a6                            # 004db6e5
    call FUN_004dae88                            # 004db6ea
    mov ecx, dword ptr [ebp - local_14]          # 004db6ef
    mov edx, dword ptr [ebp - local_14]          # 004db6f2
    mov eax, dword ptr [edx + field_14]          # 004db6f5
    mov dword ptr [ecx + field_1c], eax          # 004db6f8
    mov ecx, dword ptr [ebp - local_14]          # 004db6fb
    mov edx, dword ptr [ebp - local_14]          # 004db6fe
    mov eax, dword ptr [edx + field_18]          # 004db701
    mov dword ptr [ecx + field_20], eax          # 004db704
    mov ecx, dword ptr [0x5b44f0]                # 004db707
    shl ecx, 0x4                                 # 004db70d
    mov edx, dword ptr [0x5b44f4]                # 004db710
    mov eax, dword ptr [0x583106]                # 004db716
    add eax, dword ptr [ecx + 8*edx + 0x5b30d0]  # 004db71b
    mov ecx, dword ptr [ebp - local_14]          # 004db722
    mov dword ptr [ecx + field_9c], eax          # 004db725
    mov edx, dword ptr [0x5b44f0]                # 004db72b
    shl edx, 0x4                                 # 004db731
    mov eax, dword ptr [0x5b44f4]                # 004db734
    mov ecx, dword ptr [0x583102]                # 004db739
    add ecx, dword ptr [edx + 8*eax + 0x5b30cc]  # 004db73f
    mov edx, dword ptr [ebp - local_14]          # 004db746
    mov dword ptr [edx + field_a0], ecx          # 004db749
    mov eax, dword ptr [ebp - local_14]          # 004db74f
    mov ecx, dword ptr [eax + field_a0]          # 004db752
    mov dword ptr [0x5c3a53], ecx                # 004db758
    mov edx, dword ptr [ebp - local_14]          # 004db75e
    mov eax, dword ptr [edx + field_9c]          # 004db761
    mov dword ptr [0x5c3a57], eax                # 004db767
    {load} mov esp, ebp                          # 004db76c
    pop ebp                                      # 004db76e
    ret                                          # 004db76f

# --- data items (not part of the function) -------------------------
.org 0x004db770 - 0x401000
SWTAB_004db770:  # 4 case address(es)
    .long L_004db672 - .text + 0x401000
    .long L_004db672 - .text + 0x401000
    .long L_004db672 - .text + 0x401000
    .long L_004db672 - .text + 0x401000
.set SWTAB_004db770_VA, SWTAB_004db770 - .text + 0x401000

