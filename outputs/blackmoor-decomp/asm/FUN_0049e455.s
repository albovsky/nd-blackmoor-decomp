# FUN_0049e455
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049e455
# extent:       0x0049e455-0x0049f86a (5141 code bytes)
# span:         0x0049e455-0x0049f86a (code 5141, tables 0, padding 0)
# sha256:       2958dd5aa9df25a140516986b64b8d52d61f446e538c08a15b7d38c410bad271
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049e455
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       36 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_44, local_48, local_4c, local_50, local_54 and 24 more
# fields:       [eax + n] field_2, field_4, field_8, field_1c, field_24, field_c8, field_e38, field_e3c, field_e40, field_e44, field_minus_2, field_minus_4; [ecx + n] field_4, field_8, field_1c, field_e1c, field_e20, field_e2c, field_e38, field_e40, field_minus_4, field_minus_8; [edx + n] field_4, field_8, field_1c, field_2c, field_188, field_e38, field_e3c, field_e40, field_e44, field_minus_4, field_minus_8
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050ce04, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1193 instruction(s), 87 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_c8, 0xc8  # offset +0xc8
.equ field_188, 0x188  # offset +0x188
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e2c, 0xe2c  # offset +0xe2c
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e40, 0xe40  # offset +0xe40
.equ field_e44, 0xe44  # offset +0xe44

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049e455 - 0x401000
.globl FUN_0049e455
FUN_0049e455:
    # block 0x0049e455: entry, 7 instruction(s), ends with forward jump to 0x0049e47d
    push ebp                                     # 0049e455
    {load} mov ebp, esp                          # 0049e456
    sub esp, 0xb4                                # 0049e458
    mov dword ptr [ebp - local_98], ecx          # 0049e45e
    mov dword ptr [ebp - local_4c], 0x0          # 0049e464
    mov dword ptr [ebp - local_50], 0x0          # 0049e46b
    jmp.d8 L_0049e47d                            # 0049e472
L_0049e474:
    # block 0x0049e474: entered by jmp at 0x0049e4a9; jmp at 0x0049e4d1, 3 instruction(s), falls into the block at 0x0049e47d
    mov eax, dword ptr [ebp - local_50]          # 0049e474
    add eax, 0x1                                 # 0049e477
    mov dword ptr [ebp - local_50], eax          # 0049e47a
L_0049e47d:
    # block 0x0049e47d: entered by jmp at 0x0049e472, 2 instruction(s), ends with jge to 0x0049e4d3 (forward)
    cmp dword ptr [ebp - local_50], 0xa          # 0049e47d
    jge.d8 L_0049e4d3                            # 0049e481
    # block 0x0049e483: entered by fall-through of jge at 0x0049e481, 9 instruction(s), ends with jne to 0x0049e4ab (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0049e483
    imul ecx, ecx, 0x15e                         # 0049e486
    mov edx, dword ptr [ebp - local_98]          # 0049e48c
    lea eax, [edx + ecx + field_2c]              # 0049e492
    mov ecx, dword ptr [ebp - local_50]          # 0049e496
    mov edx, dword ptr [eax + 4*ecx + field_c8]  # 0049e499
    mov dword ptr [ebp - local_8], edx           # 0049e4a0
    cmp dword ptr [ebp - local_8], -0x1          # 0049e4a3
    jne.d8 L_0049e4ab                            # 0049e4a7
    # block 0x0049e4a9: entered by fall-through of jne at 0x0049e4a7, 1 instruction(s), ends with backward jump to 0x0049e474
    jmp.d8 L_0049e474                            # 0049e4a9
L_0049e4ab:
    # block 0x0049e4ab: entered by jne at 0x0049e4a7, 12 instruction(s), ends with backward jump to 0x0049e474
    mov eax, dword ptr [ebp - local_4c]          # 0049e4ab
    mov ecx, dword ptr [ebp - local_8]           # 0049e4ae
    mov dword ptr [ebp + 4*eax - local_44], ecx  # 0049e4b1
    mov edx, dword ptr [ebp - local_4c]          # 0049e4b5
    mov eax, dword ptr [ebp + 4*edx - local_44]  # 0049e4b8
    and eax, 0xffffff                            # 0049e4bc
    mov ecx, dword ptr [ebp - local_4c]          # 0049e4c1
    mov dword ptr [ebp + 4*ecx - local_44], eax  # 0049e4c4
    mov edx, dword ptr [ebp - local_4c]          # 0049e4c8
    add edx, 0x1                                 # 0049e4cb
    mov dword ptr [ebp - local_4c], edx          # 0049e4ce
    jmp.d8 L_0049e474                            # 0049e4d1
L_0049e4d3:
    # block 0x0049e4d3: entered by jge at 0x0049e481, 2 instruction(s), ends with jne to 0x0049e507 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 0049e4d3
    jne.d8 L_0049e507                            # 0049e4d7
    # block 0x0049e4d9: entered by fall-through of jne at 0x0049e4d7, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049e507
    mov eax, dword ptr [ebp + arg_8]             # 0049e4d9
    push eax                                     # 0049e4dc
    push 0x54ff04                                # 0049e4dd
    push 0x63888b                                # 0049e4e2
    call FUN_0050ca3e                            # 0049e4e7
    add esp, 0xc                                 # 0049e4ec
    push 0x0                                     # 0049e4ef
    push 0x0                                     # 0049e4f1
    push 0x63888b                                # 0049e4f3
    call FUN_0052139c                            # 0049e4f8
    mov ecx, 0x5cf659                            # 0049e4fd
    call FUN_004c97b4                            # 0049e502
L_0049e507:
    # block 0x0049e507: entered by jne at 0x0049e4d7, 13 instruction(s), calls FUN_0050ce04, falls into the block at 0x0049e551
    mov ecx, dword ptr [ebp + arg_8]             # 0049e507
    imul ecx, ecx, 0x15e                         # 0049e50a
    mov edx, dword ptr [ebp - local_98]          # 0049e510
    movsx eax, word ptr [edx + ecx + field_188]  # 0049e516
    mov dword ptr [ebp - local_9c], eax          # 0049e51e
    fild dword ptr [ebp - local_9c]              # 0049e524
    fstp dword ptr [ebp - local_a0]              # 0049e52a
    mov ecx, dword ptr [ebp - local_98]          # 0049e530
    fld dword ptr [ebp - local_a0]               # 0049e536
    fmul dword ptr [ecx + field_e2c]             # 0049e53c
    call FUN_0050ce04                            # 0049e542
    mov dword ptr [ebp - local_64], eax          # 0049e547
    mov dword ptr [ebp - local_48], 0x0          # 0049e54a
L_0049e551:
    # block 0x0049e551: entered by jmp at 0x0049f85f, 3 instruction(s), ends with jge to 0x0049f864 (forward)
    mov edx, dword ptr [ebp - local_48]          # 0049e551
    cmp edx, dword ptr [ebp - local_64]          # 0049e554
    jge.d32 L_0049f864                           # 0049e557
    # block 0x0049e55d: entered by fall-through of jge at 0x0049e557, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x0049e56e (forward)
    call FUN_0050cd50                            # 0049e55d
    and eax, 0x80000001                          # 0049e562
    jns.d8 L_0049e56e                            # 0049e567
    # block 0x0049e569: entered by fall-through of jns at 0x0049e567, 3 instruction(s), falls into the block at 0x0049e56e
    dec eax                                      # 0049e569
    or eax, -0x2                                 # 0049e56a
    inc eax                                      # 0049e56d
L_0049e56e:
    # block 0x0049e56e: entered by jns at 0x0049e567, 4 instruction(s), calls FUN_0050cd50, ends with jns to 0x0049e582 (forward)
    mov dword ptr [ebp - local_4], eax           # 0049e56e
    call FUN_0050cd50                            # 0049e571
    and eax, 0x80000001                          # 0049e576
    jns.d8 L_0049e582                            # 0049e57b
    # block 0x0049e57d: entered by fall-through of jns at 0x0049e57b, 3 instruction(s), falls into the block at 0x0049e582
    dec eax                                      # 0049e57d
    or eax, -0x2                                 # 0049e57e
    inc eax                                      # 0049e581
L_0049e582:
    # block 0x0049e582: entered by jns at 0x0049e57b, 9 instruction(s), falls into the block at 0x0049e5ba
    mov dword ptr [ebp - local_1c], eax          # 0049e582
    mov dword ptr [ebp - local_5c], 0x0          # 0049e585
    mov dword ptr [ebp - local_70], 0x0          # 0049e58c
    mov dword ptr [ebp - local_90], 0x0          # 0049e593
    mov dword ptr [ebp - local_94], 0x0          # 0049e59d
    mov eax, dword ptr [ebp - local_98]          # 0049e5a7
    mov ecx, dword ptr [eax + field_24]          # 0049e5ad
    mov dword ptr [ebp - local_10], ecx          # 0049e5b0
    mov dword ptr [ebp - local_68], 0x0          # 0049e5b3
L_0049e5ba:
    # block 0x0049e5ba: entered by jmp at 0x0049e62d; jmp at 0x0049f098, 2 instruction(s), ends with jne to 0x0049f09d (forward)
    cmp dword ptr [ebp - local_68], 0x0          # 0049e5ba
    jne.d32 L_0049f09d                           # 0049e5be
    # block 0x0049e5c4: entered by fall-through of jne at 0x0049e5be, 5 instruction(s), ends with jg to 0x0049e5d8 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0049e5c4
    sub edx, 0x1                                 # 0049e5c7
    mov dword ptr [ebp - local_10], edx          # 0049e5ca
    cmp dword ptr [ebp - local_10], 0x0          # 0049e5cd
    jg.d8 L_0049e5d8                             # 0049e5d1
    # block 0x0049e5d3: entered by fall-through of jg at 0x0049e5d1, 1 instruction(s), ends with forward jump to 0x0049f09d
    jmp.d32 L_0049f09d                           # 0049e5d3
L_0049e5d8:
    # block 0x0049e5d8: entered by jg at 0x0049e5d1, 21 instruction(s), calls FUN_0050cd50, ends with je to 0x0049e62f (forward)
    call FUN_0050cd50                            # 0049e5d8
    mov ecx, dword ptr [ebp - local_98]          # 0049e5dd
    cdq                                          # 0049e5e3
    idiv dword ptr [ecx + field_e20]             # 0049e5e4
    add edx, dword ptr [ebp + arg_c]             # 0049e5ea
    mov dword ptr [ebp - local_5c], edx          # 0049e5ed
    call FUN_0050cd50                            # 0049e5f0
    mov ecx, dword ptr [ebp - local_98]          # 0049e5f5
    cdq                                          # 0049e5fb
    idiv dword ptr [ecx + field_e1c]             # 0049e5fc
    add edx, dword ptr [ebp + arg_10]            # 0049e602
    mov dword ptr [ebp - local_70], edx          # 0049e605
    mov edx, dword ptr [ebp - local_98]          # 0049e608
    mov eax, dword ptr [ebp - local_5c]          # 0049e60e
    imul eax, dword ptr [edx + field_1c]         # 0049e611
    mov ecx, dword ptr [ebp - local_98]          # 0049e615
    mov edx, dword ptr [ecx + field_e38]         # 0049e61b
    lea eax, [edx + 4*eax]                       # 0049e621
    mov ecx, dword ptr [ebp - local_70]          # 0049e624
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049e627
    je.d8 L_0049e62f                             # 0049e62b
    # block 0x0049e62d: entered by fall-through of je at 0x0049e62b, 1 instruction(s), ends with backward jump to 0x0049e5ba
    jmp.d8 L_0049e5ba                            # 0049e62d
L_0049e62f:
    # block 0x0049e62f: entered by je at 0x0049e62b, 4 instruction(s), ends with je to 0x0049e653 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0049e62f
    mov dword ptr [ebp - local_a4], edx          # 0049e632
    cmp dword ptr [ebp - local_a4], 0x0          # 0049e638
    je.d8 L_0049e653                             # 0049e63f
    # block 0x0049e641: entered by fall-through of je at 0x0049e63f, 2 instruction(s), ends with je to 0x0049eb7d (forward)
    cmp dword ptr [ebp - local_a4], 0x1          # 0049e641
    je.d32 L_0049eb7d                            # 0049e648
    # block 0x0049e64e: entered by fall-through of je at 0x0049e648, 1 instruction(s), ends with forward jump to 0x0049f098
    jmp.d32 L_0049f098                           # 0049e64e
L_0049e653:
    # block 0x0049e653: entered by je at 0x0049e63f, 9 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov eax, dword ptr [ebp - local_98]          # 0049e653
    mov ecx, dword ptr [ebp - local_5c]          # 0049e659
    imul ecx, dword ptr [eax + field_1c]         # 0049e65c
    mov edx, dword ptr [ebp - local_98]          # 0049e660
    mov eax, dword ptr [edx + field_e38]         # 0049e666
    lea ecx, [eax + 4*ecx]                       # 0049e66c
    mov edx, dword ptr [ebp - local_70]          # 0049e66f
    cmp dword ptr [ecx + 4*edx - field_minus_4], 0x0 # 0049e672
    jne.d32 L_0049e8e5                           # 0049e677
    # block 0x0049e67d: entered by fall-through of jne at 0x0049e677, 11 instruction(s), ends with je to 0x0049e8e5 (forward)
    mov eax, dword ptr [ebp - local_98]          # 0049e67d
    mov ecx, dword ptr [ebp - local_5c]          # 0049e683
    imul ecx, dword ptr [eax + field_1c]         # 0049e686
    mov edx, dword ptr [ebp - local_98]          # 0049e68a
    mov eax, dword ptr [edx + field_e38]         # 0049e690
    lea ecx, [eax + 4*ecx]                       # 0049e696
    mov edx, dword ptr [ebp - local_70]          # 0049e699
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 0049e69c
    and eax, 0x1000000                           # 0049e6a0
    test eax, eax                                # 0049e6a5
    je.d32 L_0049e8e5                            # 0049e6a7
    # block 0x0049e6ad: entered by fall-through of je at 0x0049e6a7, 11 instruction(s), ends with je to 0x0049e8e5 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049e6ad
    mov edx, dword ptr [ebp - local_5c]          # 0049e6b3
    imul edx, dword ptr [ecx + field_1c]         # 0049e6b6
    mov eax, dword ptr [ebp - local_98]          # 0049e6ba
    mov ecx, dword ptr [eax + field_e38]         # 0049e6c0
    lea edx, [ecx + 4*edx]                       # 0049e6c6
    mov eax, dword ptr [ebp - local_70]          # 0049e6c9
    mov ecx, dword ptr [edx + 4*eax - field_minus_8] # 0049e6cc
    and ecx, 0x1000000                           # 0049e6d0
    test ecx, ecx                                # 0049e6d6
    je.d32 L_0049e8e5                            # 0049e6d8
    # block 0x0049e6de: entered by fall-through of je at 0x0049e6d8, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049e6de
    sub edx, 0x1                                 # 0049e6e1
    mov eax, dword ptr [ebp - local_98]          # 0049e6e4
    imul edx, dword ptr [eax + field_1c]         # 0049e6ea
    mov ecx, dword ptr [ebp - local_98]          # 0049e6ee
    mov eax, dword ptr [ecx + field_e38]         # 0049e6f4
    lea ecx, [eax + 4*edx]                       # 0049e6fa
    mov edx, dword ptr [ebp - local_70]          # 0049e6fd
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049e700
    jne.d32 L_0049e8e5                           # 0049e704
    # block 0x0049e70a: entered by fall-through of jne at 0x0049e704, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e70a
    sub eax, 0x2                                 # 0049e70d
    mov ecx, dword ptr [ebp - local_98]          # 0049e710
    imul eax, dword ptr [ecx + field_1c]         # 0049e716
    mov edx, dword ptr [ebp - local_98]          # 0049e71a
    mov ecx, dword ptr [edx + field_e38]         # 0049e720
    lea edx, [ecx + 4*eax]                       # 0049e726
    mov eax, dword ptr [ebp - local_70]          # 0049e729
    cmp dword ptr [edx + 4*eax], 0x0             # 0049e72c
    jne.d32 L_0049e8e5                           # 0049e730
    # block 0x0049e736: entered by fall-through of jne at 0x0049e730, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049e736
    add ecx, 0x1                                 # 0049e739
    mov edx, dword ptr [ebp - local_98]          # 0049e73c
    imul ecx, dword ptr [edx + field_1c]         # 0049e742
    mov eax, dword ptr [ebp - local_98]          # 0049e746
    mov edx, dword ptr [eax + field_e38]         # 0049e74c
    lea eax, [edx + 4*ecx]                       # 0049e752
    mov ecx, dword ptr [ebp - local_70]          # 0049e755
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049e758
    jne.d32 L_0049e8e5                           # 0049e75c
    # block 0x0049e762: entered by fall-through of jne at 0x0049e75c, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049e762
    add edx, 0x2                                 # 0049e765
    mov eax, dword ptr [ebp - local_98]          # 0049e768
    imul edx, dword ptr [eax + field_1c]         # 0049e76e
    mov ecx, dword ptr [ebp - local_98]          # 0049e772
    mov eax, dword ptr [ecx + field_e38]         # 0049e778
    lea ecx, [eax + 4*edx]                       # 0049e77e
    mov edx, dword ptr [ebp - local_70]          # 0049e781
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049e784
    jne.d32 L_0049e8e5                           # 0049e788
    # block 0x0049e78e: entered by fall-through of jne at 0x0049e788, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e78e
    sub eax, 0x1                                 # 0049e791
    mov ecx, dword ptr [ebp - local_98]          # 0049e794
    imul eax, dword ptr [ecx + field_1c]         # 0049e79a
    mov edx, dword ptr [ebp - local_98]          # 0049e79e
    mov ecx, dword ptr [edx + field_e38]         # 0049e7a4
    lea edx, [ecx + 4*eax]                       # 0049e7aa
    mov eax, dword ptr [ebp - local_70]          # 0049e7ad
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 0049e7b0
    jne.d32 L_0049e8e5                           # 0049e7b5
    # block 0x0049e7bb: entered by fall-through of jne at 0x0049e7b5, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049e7bb
    sub ecx, 0x2                                 # 0049e7be
    mov edx, dword ptr [ebp - local_98]          # 0049e7c1
    imul ecx, dword ptr [edx + field_1c]         # 0049e7c7
    mov eax, dword ptr [ebp - local_98]          # 0049e7cb
    mov edx, dword ptr [eax + field_e38]         # 0049e7d1
    lea eax, [edx + 4*ecx]                       # 0049e7d7
    mov ecx, dword ptr [ebp - local_70]          # 0049e7da
    cmp dword ptr [eax + 4*ecx - field_minus_4], 0x0 # 0049e7dd
    jne.d32 L_0049e8e5                           # 0049e7e2
    # block 0x0049e7e8: entered by fall-through of jne at 0x0049e7e2, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049e7e8
    add edx, 0x1                                 # 0049e7eb
    mov eax, dword ptr [ebp - local_98]          # 0049e7ee
    imul edx, dword ptr [eax + field_1c]         # 0049e7f4
    mov ecx, dword ptr [ebp - local_98]          # 0049e7f8
    mov eax, dword ptr [ecx + field_e38]         # 0049e7fe
    lea ecx, [eax + 4*edx]                       # 0049e804
    mov edx, dword ptr [ebp - local_70]          # 0049e807
    cmp dword ptr [ecx + 4*edx - field_minus_4], 0x0 # 0049e80a
    jne.d32 L_0049e8e5                           # 0049e80f
    # block 0x0049e815: entered by fall-through of jne at 0x0049e80f, 10 instruction(s), ends with jne to 0x0049e8e5 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e815
    add eax, 0x2                                 # 0049e818
    mov ecx, dword ptr [ebp - local_98]          # 0049e81b
    imul eax, dword ptr [ecx + field_1c]         # 0049e821
    mov edx, dword ptr [ebp - local_98]          # 0049e825
    mov ecx, dword ptr [edx + field_e38]         # 0049e82b
    lea edx, [ecx + 4*eax]                       # 0049e831
    mov eax, dword ptr [ebp - local_70]          # 0049e834
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 0049e837
    jne.d32 L_0049e8e5                           # 0049e83c
    # block 0x0049e842: entered by fall-through of jne at 0x0049e83c, 14 instruction(s), ends with jne to 0x0049e8e0 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049e842
    mov dword ptr [ebp - local_90], ecx          # 0049e845
    mov edx, dword ptr [ebp - local_70]          # 0049e84b
    sub edx, 0x1                                 # 0049e84e
    mov dword ptr [ebp - local_94], edx          # 0049e851
    mov eax, dword ptr [ebp - local_98]          # 0049e857
    mov ecx, dword ptr [ebp - local_5c]          # 0049e85d
    imul ecx, dword ptr [eax + field_1c]         # 0049e860
    mov edx, dword ptr [ebp - local_98]          # 0049e864
    mov eax, dword ptr [edx + field_e3c]         # 0049e86a
    lea ecx, [eax + 4*ecx]                       # 0049e870
    mov edx, dword ptr [ebp - local_70]          # 0049e873
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049e876
    jne.d8 L_0049e8e0                            # 0049e87a
    # block 0x0049e87c: entered by fall-through of jne at 0x0049e87a, 9 instruction(s), ends with jne to 0x0049e8e0 (forward)
    mov eax, dword ptr [ebp - local_98]          # 0049e87c
    mov ecx, dword ptr [ebp - local_90]          # 0049e882
    imul ecx, dword ptr [eax + field_1c]         # 0049e888
    mov edx, dword ptr [ebp - local_98]          # 0049e88c
    mov eax, dword ptr [edx + field_e3c]         # 0049e892
    lea ecx, [eax + 4*ecx]                       # 0049e898
    mov edx, dword ptr [ebp - local_94]          # 0049e89b
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049e8a1
    jne.d8 L_0049e8e0                            # 0049e8a5
    # block 0x0049e8a7: entered by fall-through of jne at 0x0049e8a5, 3 instruction(s), ends with jne to 0x0049e8bd (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e8a7
    cmp eax, dword ptr [0x6329c9]                # 0049e8aa
    jne.d8 L_0049e8bd                            # 0049e8b0
    # block 0x0049e8b2: entered by fall-through of jne at 0x0049e8b0, 3 instruction(s), ends with je to 0x0049e8e0 (forward)
    mov ecx, dword ptr [ebp - local_70]          # 0049e8b2
    cmp ecx, dword ptr [0x6329cd]                # 0049e8b5
    je.d8 L_0049e8e0                             # 0049e8bb
L_0049e8bd:
    # block 0x0049e8bd: entered by jne at 0x0049e8b0; fall-through of je at 0x0049e8bb, 3 instruction(s), ends with jne to 0x0049e8d9 (forward)
    mov edx, dword ptr [ebp - local_90]          # 0049e8bd
    cmp edx, dword ptr [0x6329c9]                # 0049e8c3
    jne.d8 L_0049e8d9                            # 0049e8c9
    # block 0x0049e8cb: entered by fall-through of jne at 0x0049e8c9, 3 instruction(s), ends with je to 0x0049e8e0 (forward)
    mov eax, dword ptr [ebp - local_94]          # 0049e8cb
    cmp eax, dword ptr [0x6329cd]                # 0049e8d1
    je.d8 L_0049e8e0                             # 0049e8d7
L_0049e8d9:
    # block 0x0049e8d9: entered by jne at 0x0049e8c9; fall-through of je at 0x0049e8d7, 1 instruction(s), falls into the block at 0x0049e8e0
    mov dword ptr [ebp - local_68], 0x1          # 0049e8d9
L_0049e8e0:
    # block 0x0049e8e0: entered by jne at 0x0049e87a; jne at 0x0049e8a5; je at 0x0049e8bb; je at 0x0049e8d7, 1 instruction(s), ends with forward jump to 0x0049f098
    jmp.d32 L_0049f098                           # 0049e8e0
L_0049e8e5:
    # block 0x0049e8e5: entered by jne at 0x0049e677; je at 0x0049e6a7; je at 0x0049e6d8; jne at 0x0049e704; more, 9 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049e8e5
    mov edx, dword ptr [ebp - local_5c]          # 0049e8eb
    imul edx, dword ptr [ecx + field_1c]         # 0049e8ee
    mov eax, dword ptr [ebp - local_98]          # 0049e8f2
    mov ecx, dword ptr [eax + field_e38]         # 0049e8f8
    lea edx, [ecx + 4*edx]                       # 0049e8fe
    mov eax, dword ptr [ebp - local_70]          # 0049e901
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049e904
    jne.d32 L_0049eb78                           # 0049e909
    # block 0x0049e90f: entered by fall-through of jne at 0x0049e909, 11 instruction(s), ends with je to 0x0049eb78 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049e90f
    mov edx, dword ptr [ebp - local_5c]          # 0049e915
    imul edx, dword ptr [ecx + field_1c]         # 0049e918
    mov eax, dword ptr [ebp - local_98]          # 0049e91c
    mov ecx, dword ptr [eax + field_e38]         # 0049e922
    lea edx, [ecx + 4*edx]                       # 0049e928
    mov eax, dword ptr [ebp - local_70]          # 0049e92b
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049e92e
    and ecx, 0x1000000                           # 0049e932
    test ecx, ecx                                # 0049e938
    je.d32 L_0049eb78                            # 0049e93a
    # block 0x0049e940: entered by fall-through of je at 0x0049e93a, 11 instruction(s), ends with je to 0x0049eb78 (forward)
    mov edx, dword ptr [ebp - local_98]          # 0049e940
    mov eax, dword ptr [ebp - local_5c]          # 0049e946
    imul eax, dword ptr [edx + field_1c]         # 0049e949
    mov ecx, dword ptr [ebp - local_98]          # 0049e94d
    mov edx, dword ptr [ecx + field_e38]         # 0049e953
    lea eax, [edx + 4*eax]                       # 0049e959
    mov ecx, dword ptr [ebp - local_70]          # 0049e95c
    mov edx, dword ptr [eax + 4*ecx + field_8]   # 0049e95f
    and edx, 0x1000000                           # 0049e963
    test edx, edx                                # 0049e969
    je.d32 L_0049eb78                            # 0049e96b
    # block 0x0049e971: entered by fall-through of je at 0x0049e96b, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e971
    sub eax, 0x1                                 # 0049e974
    mov ecx, dword ptr [ebp - local_98]          # 0049e977
    imul eax, dword ptr [ecx + field_1c]         # 0049e97d
    mov edx, dword ptr [ebp - local_98]          # 0049e981
    mov ecx, dword ptr [edx + field_e38]         # 0049e987
    lea edx, [ecx + 4*eax]                       # 0049e98d
    mov eax, dword ptr [ebp - local_70]          # 0049e990
    cmp dword ptr [edx + 4*eax], 0x0             # 0049e993
    jne.d32 L_0049eb78                           # 0049e997
    # block 0x0049e99d: entered by fall-through of jne at 0x0049e997, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049e99d
    sub ecx, 0x2                                 # 0049e9a0
    mov edx, dword ptr [ebp - local_98]          # 0049e9a3
    imul ecx, dword ptr [edx + field_1c]         # 0049e9a9
    mov eax, dword ptr [ebp - local_98]          # 0049e9ad
    mov edx, dword ptr [eax + field_e38]         # 0049e9b3
    lea eax, [edx + 4*ecx]                       # 0049e9b9
    mov ecx, dword ptr [ebp - local_70]          # 0049e9bc
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049e9bf
    jne.d32 L_0049eb78                           # 0049e9c3
    # block 0x0049e9c9: entered by fall-through of jne at 0x0049e9c3, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049e9c9
    add edx, 0x1                                 # 0049e9cc
    mov eax, dword ptr [ebp - local_98]          # 0049e9cf
    imul edx, dword ptr [eax + field_1c]         # 0049e9d5
    mov ecx, dword ptr [ebp - local_98]          # 0049e9d9
    mov eax, dword ptr [ecx + field_e38]         # 0049e9df
    lea ecx, [eax + 4*edx]                       # 0049e9e5
    mov edx, dword ptr [ebp - local_70]          # 0049e9e8
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049e9eb
    jne.d32 L_0049eb78                           # 0049e9ef
    # block 0x0049e9f5: entered by fall-through of jne at 0x0049e9ef, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049e9f5
    add eax, 0x2                                 # 0049e9f8
    mov ecx, dword ptr [ebp - local_98]          # 0049e9fb
    imul eax, dword ptr [ecx + field_1c]         # 0049ea01
    mov edx, dword ptr [ebp - local_98]          # 0049ea05
    mov ecx, dword ptr [edx + field_e38]         # 0049ea0b
    lea edx, [ecx + 4*eax]                       # 0049ea11
    mov eax, dword ptr [ebp - local_70]          # 0049ea14
    cmp dword ptr [edx + 4*eax], 0x0             # 0049ea17
    jne.d32 L_0049eb78                           # 0049ea1b
    # block 0x0049ea21: entered by fall-through of jne at 0x0049ea1b, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049ea21
    sub ecx, 0x1                                 # 0049ea24
    mov edx, dword ptr [ebp - local_98]          # 0049ea27
    imul ecx, dword ptr [edx + field_1c]         # 0049ea2d
    mov eax, dword ptr [ebp - local_98]          # 0049ea31
    mov edx, dword ptr [eax + field_e38]         # 0049ea37
    lea eax, [edx + 4*ecx]                       # 0049ea3d
    mov ecx, dword ptr [ebp - local_70]          # 0049ea40
    cmp dword ptr [eax + 4*ecx + field_4], 0x0   # 0049ea43
    jne.d32 L_0049eb78                           # 0049ea48
    # block 0x0049ea4e: entered by fall-through of jne at 0x0049ea48, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ea4e
    sub edx, 0x2                                 # 0049ea51
    mov eax, dword ptr [ebp - local_98]          # 0049ea54
    imul edx, dword ptr [eax + field_1c]         # 0049ea5a
    mov ecx, dword ptr [ebp - local_98]          # 0049ea5e
    mov eax, dword ptr [ecx + field_e38]         # 0049ea64
    lea ecx, [eax + 4*edx]                       # 0049ea6a
    mov edx, dword ptr [ebp - local_70]          # 0049ea6d
    cmp dword ptr [ecx + 4*edx + field_4], 0x0   # 0049ea70
    jne.d32 L_0049eb78                           # 0049ea75
    # block 0x0049ea7b: entered by fall-through of jne at 0x0049ea75, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049ea7b
    add eax, 0x1                                 # 0049ea7e
    mov ecx, dword ptr [ebp - local_98]          # 0049ea81
    imul eax, dword ptr [ecx + field_1c]         # 0049ea87
    mov edx, dword ptr [ebp - local_98]          # 0049ea8b
    mov ecx, dword ptr [edx + field_e38]         # 0049ea91
    lea edx, [ecx + 4*eax]                       # 0049ea97
    mov eax, dword ptr [ebp - local_70]          # 0049ea9a
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049ea9d
    jne.d32 L_0049eb78                           # 0049eaa2
    # block 0x0049eaa8: entered by fall-through of jne at 0x0049eaa2, 10 instruction(s), ends with jne to 0x0049eb78 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049eaa8
    add ecx, 0x2                                 # 0049eaab
    mov edx, dword ptr [ebp - local_98]          # 0049eaae
    imul ecx, dword ptr [edx + field_1c]         # 0049eab4
    mov eax, dword ptr [ebp - local_98]          # 0049eab8
    mov edx, dword ptr [eax + field_e38]         # 0049eabe
    lea eax, [edx + 4*ecx]                       # 0049eac4
    mov ecx, dword ptr [ebp - local_70]          # 0049eac7
    cmp dword ptr [eax + 4*ecx + field_4], 0x0   # 0049eaca
    jne.d32 L_0049eb78                           # 0049eacf
    # block 0x0049ead5: entered by fall-through of jne at 0x0049eacf, 14 instruction(s), ends with jne to 0x0049eb73 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ead5
    mov dword ptr [ebp - local_90], edx          # 0049ead8
    mov eax, dword ptr [ebp - local_70]          # 0049eade
    add eax, 0x1                                 # 0049eae1
    mov dword ptr [ebp - local_94], eax          # 0049eae4
    mov ecx, dword ptr [ebp - local_98]          # 0049eaea
    mov edx, dword ptr [ebp - local_5c]          # 0049eaf0
    imul edx, dword ptr [ecx + field_1c]         # 0049eaf3
    mov eax, dword ptr [ebp - local_98]          # 0049eaf7
    mov ecx, dword ptr [eax + field_e3c]         # 0049eafd
    lea edx, [ecx + 4*edx]                       # 0049eb03
    mov eax, dword ptr [ebp - local_70]          # 0049eb06
    cmp dword ptr [edx + 4*eax], 0x0             # 0049eb09
    jne.d8 L_0049eb73                            # 0049eb0d
    # block 0x0049eb0f: entered by fall-through of jne at 0x0049eb0d, 9 instruction(s), ends with jne to 0x0049eb73 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049eb0f
    mov edx, dword ptr [ebp - local_90]          # 0049eb15
    imul edx, dword ptr [ecx + field_1c]         # 0049eb1b
    mov eax, dword ptr [ebp - local_98]          # 0049eb1f
    mov ecx, dword ptr [eax + field_e3c]         # 0049eb25
    lea edx, [ecx + 4*edx]                       # 0049eb2b
    mov eax, dword ptr [ebp - local_94]          # 0049eb2e
    cmp dword ptr [edx + 4*eax], 0x0             # 0049eb34
    jne.d8 L_0049eb73                            # 0049eb38
    # block 0x0049eb3a: entered by fall-through of jne at 0x0049eb38, 3 instruction(s), ends with jne to 0x0049eb50 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049eb3a
    cmp ecx, dword ptr [0x6329c9]                # 0049eb3d
    jne.d8 L_0049eb50                            # 0049eb43
    # block 0x0049eb45: entered by fall-through of jne at 0x0049eb43, 3 instruction(s), ends with je to 0x0049eb73 (forward)
    mov edx, dword ptr [ebp - local_70]          # 0049eb45
    cmp edx, dword ptr [0x6329cd]                # 0049eb48
    je.d8 L_0049eb73                             # 0049eb4e
L_0049eb50:
    # block 0x0049eb50: entered by jne at 0x0049eb43; fall-through of je at 0x0049eb4e, 3 instruction(s), ends with jne to 0x0049eb6c (forward)
    mov eax, dword ptr [ebp - local_90]          # 0049eb50
    cmp eax, dword ptr [0x6329c9]                # 0049eb56
    jne.d8 L_0049eb6c                            # 0049eb5c
    # block 0x0049eb5e: entered by fall-through of jne at 0x0049eb5c, 3 instruction(s), ends with je to 0x0049eb73 (forward)
    mov ecx, dword ptr [ebp - local_94]          # 0049eb5e
    cmp ecx, dword ptr [0x6329cd]                # 0049eb64
    je.d8 L_0049eb73                             # 0049eb6a
L_0049eb6c:
    # block 0x0049eb6c: entered by jne at 0x0049eb5c; fall-through of je at 0x0049eb6a, 1 instruction(s), falls into the block at 0x0049eb73
    mov dword ptr [ebp - local_68], 0x1          # 0049eb6c
L_0049eb73:
    # block 0x0049eb73: entered by jne at 0x0049eb0d; jne at 0x0049eb38; je at 0x0049eb4e; je at 0x0049eb6a, 1 instruction(s), ends with forward jump to 0x0049f098
    jmp.d32 L_0049f098                           # 0049eb73
L_0049eb78:
    # block 0x0049eb78: entered by jne at 0x0049e909; je at 0x0049e93a; je at 0x0049e96b; jne at 0x0049e997; more, 1 instruction(s), ends with forward jump to 0x0049f098
    jmp.d32 L_0049f098                           # 0049eb78
L_0049eb7d:
    # block 0x0049eb7d: entered by je at 0x0049e648, 10 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049eb7d
    sub edx, 0x1                                 # 0049eb80
    mov eax, dword ptr [ebp - local_98]          # 0049eb83
    imul edx, dword ptr [eax + field_1c]         # 0049eb89
    mov ecx, dword ptr [ebp - local_98]          # 0049eb8d
    mov eax, dword ptr [ecx + field_e38]         # 0049eb93
    lea ecx, [eax + 4*edx]                       # 0049eb99
    mov edx, dword ptr [ebp - local_70]          # 0049eb9c
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049eb9f
    jne.d32 L_0049ee0d                           # 0049eba3
    # block 0x0049eba9: entered by fall-through of jne at 0x0049eba3, 12 instruction(s), ends with je to 0x0049ee0d (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049eba9
    add eax, 0x1                                 # 0049ebac
    mov ecx, dword ptr [ebp - local_98]          # 0049ebaf
    imul eax, dword ptr [ecx + field_1c]         # 0049ebb5
    mov edx, dword ptr [ebp - local_98]          # 0049ebb9
    mov ecx, dword ptr [edx + field_e38]         # 0049ebbf
    lea edx, [ecx + 4*eax]                       # 0049ebc5
    mov eax, dword ptr [ebp - local_70]          # 0049ebc8
    mov ecx, dword ptr [edx + 4*eax]             # 0049ebcb
    and ecx, 0x1000000                           # 0049ebce
    test ecx, ecx                                # 0049ebd4
    je.d32 L_0049ee0d                            # 0049ebd6
    # block 0x0049ebdc: entered by fall-through of je at 0x0049ebd6, 12 instruction(s), ends with je to 0x0049ee0d (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ebdc
    sub edx, 0x2                                 # 0049ebdf
    mov eax, dword ptr [ebp - local_98]          # 0049ebe2
    imul edx, dword ptr [eax + field_1c]         # 0049ebe8
    mov ecx, dword ptr [ebp - local_98]          # 0049ebec
    mov eax, dword ptr [ecx + field_e38]         # 0049ebf2
    lea ecx, [eax + 4*edx]                       # 0049ebf8
    mov edx, dword ptr [ebp - local_70]          # 0049ebfb
    mov eax, dword ptr [ecx + 4*edx]             # 0049ebfe
    and eax, 0x1000000                           # 0049ec01
    test eax, eax                                # 0049ec06
    je.d32 L_0049ee0d                            # 0049ec08
    # block 0x0049ec0e: entered by fall-through of je at 0x0049ec08, 9 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ec0e
    mov edx, dword ptr [ebp - local_5c]          # 0049ec14
    imul edx, dword ptr [ecx + field_1c]         # 0049ec17
    mov eax, dword ptr [ebp - local_98]          # 0049ec1b
    mov ecx, dword ptr [eax + field_e38]         # 0049ec21
    lea edx, [ecx + 4*edx]                       # 0049ec27
    mov eax, dword ptr [ebp - local_70]          # 0049ec2a
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 0049ec2d
    jne.d32 L_0049ee0d                           # 0049ec32
    # block 0x0049ec38: entered by fall-through of jne at 0x0049ec32, 9 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ec38
    mov edx, dword ptr [ebp - local_5c]          # 0049ec3e
    imul edx, dword ptr [ecx + field_1c]         # 0049ec41
    mov eax, dword ptr [ebp - local_98]          # 0049ec45
    mov ecx, dword ptr [eax + field_e38]         # 0049ec4b
    lea edx, [ecx + 4*edx]                       # 0049ec51
    mov eax, dword ptr [ebp - local_70]          # 0049ec54
    cmp dword ptr [edx + 4*eax - field_minus_8], 0x0 # 0049ec57
    jne.d32 L_0049ee0d                           # 0049ec5c
    # block 0x0049ec62: entered by fall-through of jne at 0x0049ec5c, 9 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ec62
    mov edx, dword ptr [ebp - local_5c]          # 0049ec68
    imul edx, dword ptr [ecx + field_1c]         # 0049ec6b
    mov eax, dword ptr [ebp - local_98]          # 0049ec6f
    mov ecx, dword ptr [eax + field_e38]         # 0049ec75
    lea edx, [ecx + 4*edx]                       # 0049ec7b
    mov eax, dword ptr [ebp - local_70]          # 0049ec7e
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049ec81
    jne.d32 L_0049ee0d                           # 0049ec86
    # block 0x0049ec8c: entered by fall-through of jne at 0x0049ec86, 9 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ec8c
    mov edx, dword ptr [ebp - local_5c]          # 0049ec92
    imul edx, dword ptr [ecx + field_1c]         # 0049ec95
    mov eax, dword ptr [ebp - local_98]          # 0049ec99
    mov ecx, dword ptr [eax + field_e38]         # 0049ec9f
    lea edx, [ecx + 4*edx]                       # 0049eca5
    mov eax, dword ptr [ebp - local_70]          # 0049eca8
    cmp dword ptr [edx + 4*eax + field_8], 0x0   # 0049ecab
    jne.d32 L_0049ee0d                           # 0049ecb0
    # block 0x0049ecb6: entered by fall-through of jne at 0x0049ecb0, 10 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049ecb6
    sub ecx, 0x1                                 # 0049ecb9
    mov edx, dword ptr [ebp - local_98]          # 0049ecbc
    imul ecx, dword ptr [edx + field_1c]         # 0049ecc2
    mov eax, dword ptr [ebp - local_98]          # 0049ecc6
    mov edx, dword ptr [eax + field_e38]         # 0049eccc
    lea eax, [edx + 4*ecx]                       # 0049ecd2
    mov ecx, dword ptr [ebp - local_70]          # 0049ecd5
    cmp dword ptr [eax + 4*ecx - field_minus_4], 0x0 # 0049ecd8
    jne.d32 L_0049ee0d                           # 0049ecdd
    # block 0x0049ece3: entered by fall-through of jne at 0x0049ecdd, 10 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ece3
    sub edx, 0x1                                 # 0049ece6
    mov eax, dword ptr [ebp - local_98]          # 0049ece9
    imul edx, dword ptr [eax + field_1c]         # 0049ecef
    mov ecx, dword ptr [ebp - local_98]          # 0049ecf3
    mov eax, dword ptr [ecx + field_e38]         # 0049ecf9
    lea ecx, [eax + 4*edx]                       # 0049ecff
    mov edx, dword ptr [ebp - local_70]          # 0049ed02
    cmp dword ptr [ecx + 4*edx - field_minus_8], 0x0 # 0049ed05
    jne.d32 L_0049ee0d                           # 0049ed0a
    # block 0x0049ed10: entered by fall-through of jne at 0x0049ed0a, 10 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049ed10
    sub eax, 0x1                                 # 0049ed13
    mov ecx, dword ptr [ebp - local_98]          # 0049ed16
    imul eax, dword ptr [ecx + field_1c]         # 0049ed1c
    mov edx, dword ptr [ebp - local_98]          # 0049ed20
    mov ecx, dword ptr [edx + field_e38]         # 0049ed26
    lea edx, [ecx + 4*eax]                       # 0049ed2c
    mov eax, dword ptr [ebp - local_70]          # 0049ed2f
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049ed32
    jne.d32 L_0049ee0d                           # 0049ed37
    # block 0x0049ed3d: entered by fall-through of jne at 0x0049ed37, 10 instruction(s), ends with jne to 0x0049ee0d (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049ed3d
    sub ecx, 0x1                                 # 0049ed40
    mov edx, dword ptr [ebp - local_98]          # 0049ed43
    imul ecx, dword ptr [edx + field_1c]         # 0049ed49
    mov eax, dword ptr [ebp - local_98]          # 0049ed4d
    mov edx, dword ptr [eax + field_e38]         # 0049ed53
    lea eax, [edx + 4*ecx]                       # 0049ed59
    mov ecx, dword ptr [ebp - local_70]          # 0049ed5c
    cmp dword ptr [eax + 4*ecx + field_8], 0x0   # 0049ed5f
    jne.d32 L_0049ee0d                           # 0049ed64
    # block 0x0049ed6a: entered by fall-through of jne at 0x0049ed64, 14 instruction(s), ends with jne to 0x0049ee08 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ed6a
    sub edx, 0x1                                 # 0049ed6d
    mov dword ptr [ebp - local_90], edx          # 0049ed70
    mov eax, dword ptr [ebp - local_70]          # 0049ed76
    mov dword ptr [ebp - local_94], eax          # 0049ed79
    mov ecx, dword ptr [ebp - local_98]          # 0049ed7f
    mov edx, dword ptr [ebp - local_5c]          # 0049ed85
    imul edx, dword ptr [ecx + field_1c]         # 0049ed88
    mov eax, dword ptr [ebp - local_98]          # 0049ed8c
    mov ecx, dword ptr [eax + field_e3c]         # 0049ed92
    lea edx, [ecx + 4*edx]                       # 0049ed98
    mov eax, dword ptr [ebp - local_70]          # 0049ed9b
    cmp dword ptr [edx + 4*eax], 0x0             # 0049ed9e
    jne.d8 L_0049ee08                            # 0049eda2
    # block 0x0049eda4: entered by fall-through of jne at 0x0049eda2, 9 instruction(s), ends with jne to 0x0049ee08 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049eda4
    mov edx, dword ptr [ebp - local_90]          # 0049edaa
    imul edx, dword ptr [ecx + field_1c]         # 0049edb0
    mov eax, dword ptr [ebp - local_98]          # 0049edb4
    mov ecx, dword ptr [eax + field_e3c]         # 0049edba
    lea edx, [ecx + 4*edx]                       # 0049edc0
    mov eax, dword ptr [ebp - local_94]          # 0049edc3
    cmp dword ptr [edx + 4*eax], 0x0             # 0049edc9
    jne.d8 L_0049ee08                            # 0049edcd
    # block 0x0049edcf: entered by fall-through of jne at 0x0049edcd, 3 instruction(s), ends with jne to 0x0049ede5 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049edcf
    cmp ecx, dword ptr [0x6329c9]                # 0049edd2
    jne.d8 L_0049ede5                            # 0049edd8
    # block 0x0049edda: entered by fall-through of jne at 0x0049edd8, 3 instruction(s), ends with je to 0x0049ee08 (forward)
    mov edx, dword ptr [ebp - local_70]          # 0049edda
    cmp edx, dword ptr [0x6329cd]                # 0049eddd
    je.d8 L_0049ee08                             # 0049ede3
L_0049ede5:
    # block 0x0049ede5: entered by jne at 0x0049edd8; fall-through of je at 0x0049ede3, 3 instruction(s), ends with jne to 0x0049ee01 (forward)
    mov eax, dword ptr [ebp - local_90]          # 0049ede5
    cmp eax, dword ptr [0x6329c9]                # 0049edeb
    jne.d8 L_0049ee01                            # 0049edf1
    # block 0x0049edf3: entered by fall-through of jne at 0x0049edf1, 3 instruction(s), ends with je to 0x0049ee08 (forward)
    mov ecx, dword ptr [ebp - local_94]          # 0049edf3
    cmp ecx, dword ptr [0x6329cd]                # 0049edf9
    je.d8 L_0049ee08                             # 0049edff
L_0049ee01:
    # block 0x0049ee01: entered by jne at 0x0049edf1; fall-through of je at 0x0049edff, 1 instruction(s), falls into the block at 0x0049ee08
    mov dword ptr [ebp - local_68], 0x1          # 0049ee01
L_0049ee08:
    # block 0x0049ee08: entered by jne at 0x0049eda2; jne at 0x0049edcd; je at 0x0049ede3; je at 0x0049edff, 1 instruction(s), ends with forward jump to 0x0049f098
    jmp.d32 L_0049f098                           # 0049ee08
L_0049ee0d:
    # block 0x0049ee0d: entered by jne at 0x0049eba3; je at 0x0049ebd6; je at 0x0049ec08; jne at 0x0049ec32; more, 10 instruction(s), ends with jne to 0x0049f098 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ee0d
    add edx, 0x1                                 # 0049ee10
    mov eax, dword ptr [ebp - local_98]          # 0049ee13
    imul edx, dword ptr [eax + field_1c]         # 0049ee19
    mov ecx, dword ptr [ebp - local_98]          # 0049ee1d
    mov eax, dword ptr [ecx + field_e38]         # 0049ee23
    lea ecx, [eax + 4*edx]                       # 0049ee29
    mov edx, dword ptr [ebp - local_70]          # 0049ee2c
    cmp dword ptr [ecx + 4*edx], 0x0             # 0049ee2f
    jne.d32 L_0049f098                           # 0049ee33
    # block 0x0049ee39: entered by fall-through of jne at 0x0049ee33, 12 instruction(s), ends with je to 0x0049f098 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049ee39
    sub eax, 0x1                                 # 0049ee3c
    mov ecx, dword ptr [ebp - local_98]          # 0049ee3f
    imul eax, dword ptr [ecx + field_1c]         # 0049ee45
    mov edx, dword ptr [ebp - local_98]          # 0049ee49
    mov ecx, dword ptr [edx + field_e38]         # 0049ee4f
    lea edx, [ecx + 4*eax]                       # 0049ee55
    mov eax, dword ptr [ebp - local_70]          # 0049ee58
    mov ecx, dword ptr [edx + 4*eax]             # 0049ee5b
    and ecx, 0x1000000                           # 0049ee5e
    test ecx, ecx                                # 0049ee64
    je.d32 L_0049f098                            # 0049ee66
    # block 0x0049ee6c: entered by fall-through of je at 0x0049ee66, 12 instruction(s), ends with je to 0x0049f098 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ee6c
    add edx, 0x2                                 # 0049ee6f
    mov eax, dword ptr [ebp - local_98]          # 0049ee72
    imul edx, dword ptr [eax + field_1c]         # 0049ee78
    mov ecx, dword ptr [ebp - local_98]          # 0049ee7c
    mov eax, dword ptr [ecx + field_e38]         # 0049ee82
    lea ecx, [eax + 4*edx]                       # 0049ee88
    mov edx, dword ptr [ebp - local_70]          # 0049ee8b
    mov eax, dword ptr [ecx + 4*edx]             # 0049ee8e
    and eax, 0x1000000                           # 0049ee91
    test eax, eax                                # 0049ee96
    je.d32 L_0049f098                            # 0049ee98
    # block 0x0049ee9e: entered by fall-through of je at 0x0049ee98, 9 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ee9e
    mov edx, dword ptr [ebp - local_5c]          # 0049eea4
    imul edx, dword ptr [ecx + field_1c]         # 0049eea7
    mov eax, dword ptr [ebp - local_98]          # 0049eeab
    mov ecx, dword ptr [eax + field_e38]         # 0049eeb1
    lea edx, [ecx + 4*edx]                       # 0049eeb7
    mov eax, dword ptr [ebp - local_70]          # 0049eeba
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 0049eebd
    jne.d32 L_0049f098                           # 0049eec2
    # block 0x0049eec8: entered by fall-through of jne at 0x0049eec2, 9 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049eec8
    mov edx, dword ptr [ebp - local_5c]          # 0049eece
    imul edx, dword ptr [ecx + field_1c]         # 0049eed1
    mov eax, dword ptr [ebp - local_98]          # 0049eed5
    mov ecx, dword ptr [eax + field_e38]         # 0049eedb
    lea edx, [ecx + 4*edx]                       # 0049eee1
    mov eax, dword ptr [ebp - local_70]          # 0049eee4
    cmp dword ptr [edx + 4*eax - field_minus_8], 0x0 # 0049eee7
    jne.d32 L_0049f098                           # 0049eeec
    # block 0x0049eef2: entered by fall-through of jne at 0x0049eeec, 9 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049eef2
    mov edx, dword ptr [ebp - local_5c]          # 0049eef8
    imul edx, dword ptr [ecx + field_1c]         # 0049eefb
    mov eax, dword ptr [ebp - local_98]          # 0049eeff
    mov ecx, dword ptr [eax + field_e38]         # 0049ef05
    lea edx, [ecx + 4*edx]                       # 0049ef0b
    mov eax, dword ptr [ebp - local_70]          # 0049ef0e
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049ef11
    jne.d32 L_0049f098                           # 0049ef16
    # block 0x0049ef1c: entered by fall-through of jne at 0x0049ef16, 9 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049ef1c
    mov edx, dword ptr [ebp - local_5c]          # 0049ef22
    imul edx, dword ptr [ecx + field_1c]         # 0049ef25
    mov eax, dword ptr [ebp - local_98]          # 0049ef29
    mov ecx, dword ptr [eax + field_e38]         # 0049ef2f
    lea edx, [ecx + 4*edx]                       # 0049ef35
    mov eax, dword ptr [ebp - local_70]          # 0049ef38
    cmp dword ptr [edx + 4*eax + field_8], 0x0   # 0049ef3b
    jne.d32 L_0049f098                           # 0049ef40
    # block 0x0049ef46: entered by fall-through of jne at 0x0049ef40, 10 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049ef46
    add ecx, 0x1                                 # 0049ef49
    mov edx, dword ptr [ebp - local_98]          # 0049ef4c
    imul ecx, dword ptr [edx + field_1c]         # 0049ef52
    mov eax, dword ptr [ebp - local_98]          # 0049ef56
    mov edx, dword ptr [eax + field_e38]         # 0049ef5c
    lea eax, [edx + 4*ecx]                       # 0049ef62
    mov ecx, dword ptr [ebp - local_70]          # 0049ef65
    cmp dword ptr [eax + 4*ecx - field_minus_4], 0x0 # 0049ef68
    jne.d32 L_0049f098                           # 0049ef6d
    # block 0x0049ef73: entered by fall-through of jne at 0x0049ef6d, 10 instruction(s), ends with jne to 0x0049f098 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049ef73
    add edx, 0x1                                 # 0049ef76
    mov eax, dword ptr [ebp - local_98]          # 0049ef79
    imul edx, dword ptr [eax + field_1c]         # 0049ef7f
    mov ecx, dword ptr [ebp - local_98]          # 0049ef83
    mov eax, dword ptr [ecx + field_e38]         # 0049ef89
    lea ecx, [eax + 4*edx]                       # 0049ef8f
    mov edx, dword ptr [ebp - local_70]          # 0049ef92
    cmp dword ptr [ecx + 4*edx - field_minus_8], 0x0 # 0049ef95
    jne.d32 L_0049f098                           # 0049ef9a
    # block 0x0049efa0: entered by fall-through of jne at 0x0049ef9a, 10 instruction(s), ends with jne to 0x0049f098 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049efa0
    add eax, 0x1                                 # 0049efa3
    mov ecx, dword ptr [ebp - local_98]          # 0049efa6
    imul eax, dword ptr [ecx + field_1c]         # 0049efac
    mov edx, dword ptr [ebp - local_98]          # 0049efb0
    mov ecx, dword ptr [edx + field_e38]         # 0049efb6
    lea edx, [ecx + 4*eax]                       # 0049efbc
    mov eax, dword ptr [ebp - local_70]          # 0049efbf
    cmp dword ptr [edx + 4*eax + field_4], 0x0   # 0049efc2
    jne.d32 L_0049f098                           # 0049efc7
    # block 0x0049efcd: entered by fall-through of jne at 0x0049efc7, 10 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049efcd
    add ecx, 0x1                                 # 0049efd0
    mov edx, dword ptr [ebp - local_98]          # 0049efd3
    imul ecx, dword ptr [edx + field_1c]         # 0049efd9
    mov eax, dword ptr [ebp - local_98]          # 0049efdd
    mov edx, dword ptr [eax + field_e38]         # 0049efe3
    lea eax, [edx + 4*ecx]                       # 0049efe9
    mov ecx, dword ptr [ebp - local_70]          # 0049efec
    cmp dword ptr [eax + 4*ecx + field_8], 0x0   # 0049efef
    jne.d32 L_0049f098                           # 0049eff4
    # block 0x0049effa: entered by fall-through of jne at 0x0049eff4, 14 instruction(s), ends with jne to 0x0049f098 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049effa
    add edx, 0x1                                 # 0049effd
    mov dword ptr [ebp - local_90], edx          # 0049f000
    mov eax, dword ptr [ebp - local_70]          # 0049f006
    mov dword ptr [ebp - local_94], eax          # 0049f009
    mov ecx, dword ptr [ebp - local_98]          # 0049f00f
    mov edx, dword ptr [ebp - local_5c]          # 0049f015
    imul edx, dword ptr [ecx + field_1c]         # 0049f018
    mov eax, dword ptr [ebp - local_98]          # 0049f01c
    mov ecx, dword ptr [eax + field_e3c]         # 0049f022
    lea edx, [ecx + 4*edx]                       # 0049f028
    mov eax, dword ptr [ebp - local_70]          # 0049f02b
    cmp dword ptr [edx + 4*eax], 0x0             # 0049f02e
    jne.d8 L_0049f098                            # 0049f032
    # block 0x0049f034: entered by fall-through of jne at 0x0049f032, 9 instruction(s), ends with jne to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0049f034
    mov edx, dword ptr [ebp - local_90]          # 0049f03a
    imul edx, dword ptr [ecx + field_1c]         # 0049f040
    mov eax, dword ptr [ebp - local_98]          # 0049f044
    mov ecx, dword ptr [eax + field_e3c]         # 0049f04a
    lea edx, [ecx + 4*edx]                       # 0049f050
    mov eax, dword ptr [ebp - local_94]          # 0049f053
    cmp dword ptr [edx + 4*eax], 0x0             # 0049f059
    jne.d8 L_0049f098                            # 0049f05d
    # block 0x0049f05f: entered by fall-through of jne at 0x0049f05d, 3 instruction(s), ends with jne to 0x0049f075 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049f05f
    cmp ecx, dword ptr [0x6329c9]                # 0049f062
    jne.d8 L_0049f075                            # 0049f068
    # block 0x0049f06a: entered by fall-through of jne at 0x0049f068, 3 instruction(s), ends with je to 0x0049f098 (forward)
    mov edx, dword ptr [ebp - local_70]          # 0049f06a
    cmp edx, dword ptr [0x6329cd]                # 0049f06d
    je.d8 L_0049f098                             # 0049f073
L_0049f075:
    # block 0x0049f075: entered by jne at 0x0049f068; fall-through of je at 0x0049f073, 3 instruction(s), ends with jne to 0x0049f091 (forward)
    mov eax, dword ptr [ebp - local_90]          # 0049f075
    cmp eax, dword ptr [0x6329c9]                # 0049f07b
    jne.d8 L_0049f091                            # 0049f081
    # block 0x0049f083: entered by fall-through of jne at 0x0049f081, 3 instruction(s), ends with je to 0x0049f098 (forward)
    mov ecx, dword ptr [ebp - local_94]          # 0049f083
    cmp ecx, dword ptr [0x6329cd]                # 0049f089
    je.d8 L_0049f098                             # 0049f08f
L_0049f091:
    # block 0x0049f091: entered by jne at 0x0049f081; fall-through of je at 0x0049f08f, 1 instruction(s), falls into the block at 0x0049f098
    mov dword ptr [ebp - local_68], 0x1          # 0049f091
L_0049f098:
    # block 0x0049f098: entered by jmp at 0x0049e64e; jmp at 0x0049e8e0; jmp at 0x0049eb73; jmp at 0x0049eb78; more, 1 instruction(s), ends with backward jump to 0x0049e5ba
    jmp.d32 L_0049e5ba                           # 0049f098
L_0049f09d:
    # block 0x0049f09d: entered by jne at 0x0049e5be; jmp at 0x0049e5d3, 2 instruction(s), ends with je to 0x0049f85d (forward)
    cmp dword ptr [ebp - local_68], 0x0          # 0049f09d
    je.d32 L_0049f85d                            # 0049f0a1
    # block 0x0049f0a7: entered by fall-through of je at 0x0049f0a1, 12 instruction(s), calls FUN_0050cd50, ends with jne to 0x0049f393 (forward)
    call FUN_0050cd50                            # 0049f0a7
    cdq                                          # 0049f0ac
    idiv dword ptr [ebp - local_4c]              # 0049f0ad
    mov dword ptr [ebp - local_84], edx          # 0049f0b0
    mov edx, dword ptr [ebp - local_84]          # 0049f0b6
    mov eax, dword ptr [ebp + 4*edx - local_44]  # 0049f0bc
    mov dword ptr [ebp - local_60], eax          # 0049f0c0
    mov ecx, dword ptr [ebp - local_60]          # 0049f0c3
    or ecx, 0x38000000                           # 0049f0c6
    mov dword ptr [ebp - local_60], ecx          # 0049f0cc
    cmp dword ptr [ebp - local_4], 0x0           # 0049f0cf
    jne.d32 L_0049f393                           # 0049f0d3
    # block 0x0049f0d9: entered by fall-through of jne at 0x0049f0d3, 5 instruction(s), ends with jne to 0x0049f241 (forward)
    mov edx, dword ptr [ebp - local_60]          # 0049f0d9
    or edx, 0x2000000                            # 0049f0dc
    mov dword ptr [ebp - local_60], edx          # 0049f0e2
    cmp dword ptr [ebp - local_1c], 0x0          # 0049f0e5
    jne.d32 L_0049f241                           # 0049f0e9
    # block 0x0049f0ef: entered by fall-through of jne at 0x0049f0e9, 5 instruction(s), ends with jle to 0x0049f10b (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049f0ef
    mov dword ptr [ebp - local_58], eax          # 0049f0f2
    mov ecx, dword ptr [ebp - local_70]          # 0049f0f5
    cmp ecx, dword ptr [ebp - local_94]          # 0049f0f8
    jle.d8 L_0049f10b                            # 0049f0fe
    # block 0x0049f100: entered by fall-through of jle at 0x0049f0fe, 3 instruction(s), ends with forward jump to 0x0049f117
    mov edx, dword ptr [ebp - local_70]          # 0049f100
    mov dword ptr [ebp - local_a8], edx          # 0049f103
    jmp.d8 L_0049f117                            # 0049f109
L_0049f10b:
    # block 0x0049f10b: entered by jle at 0x0049f0fe, 2 instruction(s), falls into the block at 0x0049f117
    mov eax, dword ptr [ebp - local_94]          # 0049f10b
    mov dword ptr [ebp - local_a8], eax          # 0049f111
L_0049f117:
    # block 0x0049f117: entered by jmp at 0x0049f109, 66 instruction(s), ends with forward jump to 0x0049f38e
    mov ecx, dword ptr [ebp - local_a8]          # 0049f117
    mov dword ptr [ebp - local_6c], ecx          # 0049f11d
    mov edx, dword ptr [ebp - local_98]          # 0049f120
    mov eax, dword ptr [ebp - local_58]          # 0049f126
    imul eax, dword ptr [edx + field_1c]         # 0049f129
    mov ecx, dword ptr [ebp - local_98]          # 0049f12d
    mov edx, dword ptr [ecx + field_e38]         # 0049f133
    lea eax, [edx + 4*eax]                       # 0049f139
    mov ecx, dword ptr [ebp - local_6c]          # 0049f13c
    mov edx, dword ptr [ebp - local_60]          # 0049f13f
    mov dword ptr [eax + 4*ecx], edx             # 0049f142
    mov eax, dword ptr [ebp - local_98]          # 0049f145
    mov ecx, dword ptr [ebp - local_58]          # 0049f14b
    imul ecx, dword ptr [eax + field_1c]         # 0049f14e
    mov edx, dword ptr [ebp - local_98]          # 0049f152
    mov eax, dword ptr [edx + field_e38]         # 0049f158
    lea ecx, [eax + 4*ecx]                       # 0049f15e
    mov edx, dword ptr [ebp - local_6c]          # 0049f161
    mov eax, dword ptr [ecx + 4*edx - field_minus_8] # 0049f164
    mov dword ptr [ebp - local_8c], eax          # 0049f168
    mov ecx, dword ptr [ebp - local_98]          # 0049f16e
    mov edx, dword ptr [ebp - local_58]          # 0049f174
    imul edx, dword ptr [ecx + field_1c]         # 0049f177
    mov eax, dword ptr [ebp - local_98]          # 0049f17b
    mov ecx, dword ptr [eax + field_e38]         # 0049f181
    lea edx, [ecx + 4*edx]                       # 0049f187
    mov eax, dword ptr [ebp - local_6c]          # 0049f18a
    mov ecx, dword ptr [ebp - local_8c]          # 0049f18d
    mov dword ptr [edx + 4*eax - field_minus_4], ecx # 0049f193
    mov edx, dword ptr [ebp - local_98]          # 0049f197
    mov eax, dword ptr [ebp - local_58]          # 0049f19d
    imul eax, dword ptr [edx + field_1c]         # 0049f1a0
    mov ecx, dword ptr [ebp - local_98]          # 0049f1a4
    mov edx, dword ptr [ecx + field_e40]         # 0049f1aa
    lea eax, [edx + 2*eax]                       # 0049f1b0
    mov ecx, dword ptr [ebp - local_6c]          # 0049f1b3
    mov dx, word ptr [eax + 2*ecx + field_2]     # 0049f1b6
    mov word ptr [ebp - local_88], dx            # 0049f1bb
    mov eax, dword ptr [ebp - local_98]          # 0049f1c2
    mov ecx, dword ptr [ebp - local_58]          # 0049f1c8
    imul ecx, dword ptr [eax + field_1c]         # 0049f1cb
    mov edx, dword ptr [ebp - local_98]          # 0049f1cf
    mov eax, dword ptr [edx + field_e40]         # 0049f1d5
    lea ecx, [eax + 2*ecx]                       # 0049f1db
    mov edx, dword ptr [ebp - local_6c]          # 0049f1de
    mov ax, word ptr [ebp - local_88]            # 0049f1e1
    mov word ptr [ecx + 2*edx], ax               # 0049f1e8
    mov ecx, dword ptr [ebp - local_98]          # 0049f1ec
    mov edx, dword ptr [ebp - local_58]          # 0049f1f2
    imul edx, dword ptr [ecx + field_1c]         # 0049f1f5
    mov eax, dword ptr [ebp - local_98]          # 0049f1f9
    mov ecx, dword ptr [eax + field_e40]         # 0049f1ff
    lea edx, [ecx + 2*edx]                       # 0049f205
    mov eax, dword ptr [ebp - local_6c]          # 0049f208
    mov cx, word ptr [edx + 2*eax - field_minus_4] # 0049f20b
    mov word ptr [ebp - local_54], cx            # 0049f210
    mov edx, dword ptr [ebp - local_98]          # 0049f214
    mov eax, dword ptr [ebp - local_58]          # 0049f21a
    imul eax, dword ptr [edx + field_1c]         # 0049f21d
    mov ecx, dword ptr [ebp - local_98]          # 0049f221
    mov edx, dword ptr [ecx + field_e40]         # 0049f227
    lea eax, [edx + 2*eax]                       # 0049f22d
    mov ecx, dword ptr [ebp - local_6c]          # 0049f230
    mov dx, word ptr [ebp - local_54]            # 0049f233
    mov word ptr [eax + 2*ecx - field_minus_2], dx # 0049f237
    jmp.d32 L_0049f38e                           # 0049f23c
L_0049f241:
    # block 0x0049f241: entered by jne at 0x0049f0e9, 5 instruction(s), ends with jge to 0x0049f25d (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049f241
    mov dword ptr [ebp - local_58], eax          # 0049f244
    mov ecx, dword ptr [ebp - local_70]          # 0049f247
    cmp ecx, dword ptr [ebp - local_94]          # 0049f24a
    jge.d8 L_0049f25d                            # 0049f250
    # block 0x0049f252: entered by fall-through of jge at 0x0049f250, 3 instruction(s), ends with forward jump to 0x0049f269
    mov edx, dword ptr [ebp - local_70]          # 0049f252
    mov dword ptr [ebp - local_ac], edx          # 0049f255
    jmp.d8 L_0049f269                            # 0049f25b
L_0049f25d:
    # block 0x0049f25d: entered by jge at 0x0049f250, 2 instruction(s), falls into the block at 0x0049f269
    mov eax, dword ptr [ebp - local_94]          # 0049f25d
    mov dword ptr [ebp - local_ac], eax          # 0049f263
L_0049f269:
    # block 0x0049f269: entered by jmp at 0x0049f25b, 65 instruction(s), falls into the block at 0x0049f38e
    mov ecx, dword ptr [ebp - local_ac]          # 0049f269
    mov dword ptr [ebp - local_6c], ecx          # 0049f26f
    mov edx, dword ptr [ebp - local_98]          # 0049f272
    mov eax, dword ptr [ebp - local_58]          # 0049f278
    imul eax, dword ptr [edx + field_1c]         # 0049f27b
    mov ecx, dword ptr [ebp - local_98]          # 0049f27f
    mov edx, dword ptr [ecx + field_e38]         # 0049f285
    lea eax, [edx + 4*eax]                       # 0049f28b
    mov ecx, dword ptr [ebp - local_6c]          # 0049f28e
    mov edx, dword ptr [ebp - local_60]          # 0049f291
    mov dword ptr [eax + 4*ecx], edx             # 0049f294
    mov eax, dword ptr [ebp - local_98]          # 0049f297
    mov ecx, dword ptr [ebp - local_58]          # 0049f29d
    imul ecx, dword ptr [eax + field_1c]         # 0049f2a0
    mov edx, dword ptr [ebp - local_98]          # 0049f2a4
    mov eax, dword ptr [edx + field_e38]         # 0049f2aa
    lea ecx, [eax + 4*ecx]                       # 0049f2b0
    mov edx, dword ptr [ebp - local_6c]          # 0049f2b3
    mov eax, dword ptr [ecx + 4*edx + field_8]   # 0049f2b6
    mov dword ptr [ebp - local_8c], eax          # 0049f2ba
    mov ecx, dword ptr [ebp - local_98]          # 0049f2c0
    mov edx, dword ptr [ebp - local_58]          # 0049f2c6
    imul edx, dword ptr [ecx + field_1c]         # 0049f2c9
    mov eax, dword ptr [ebp - local_98]          # 0049f2cd
    mov ecx, dword ptr [eax + field_e38]         # 0049f2d3
    lea edx, [ecx + 4*edx]                       # 0049f2d9
    mov eax, dword ptr [ebp - local_6c]          # 0049f2dc
    mov ecx, dword ptr [ebp - local_8c]          # 0049f2df
    mov dword ptr [edx + 4*eax + field_4], ecx   # 0049f2e5
    mov edx, dword ptr [ebp - local_98]          # 0049f2e9
    mov eax, dword ptr [ebp - local_58]          # 0049f2ef
    imul eax, dword ptr [edx + field_1c]         # 0049f2f2
    mov ecx, dword ptr [ebp - local_98]          # 0049f2f6
    mov edx, dword ptr [ecx + field_e40]         # 0049f2fc
    lea eax, [edx + 2*eax]                       # 0049f302
    mov ecx, dword ptr [ebp - local_6c]          # 0049f305
    mov dx, word ptr [eax + 2*ecx - field_minus_2] # 0049f308
    mov word ptr [ebp - local_88], dx            # 0049f30d
    mov eax, dword ptr [ebp - local_98]          # 0049f314
    mov ecx, dword ptr [ebp - local_58]          # 0049f31a
    imul ecx, dword ptr [eax + field_1c]         # 0049f31d
    mov edx, dword ptr [ebp - local_98]          # 0049f321
    mov eax, dword ptr [edx + field_e40]         # 0049f327
    lea ecx, [eax + 2*ecx]                       # 0049f32d
    mov edx, dword ptr [ebp - local_6c]          # 0049f330
    mov ax, word ptr [ebp - local_88]            # 0049f333
    mov word ptr [ecx + 2*edx], ax               # 0049f33a
    mov ecx, dword ptr [ebp - local_98]          # 0049f33e
    mov edx, dword ptr [ebp - local_58]          # 0049f344
    imul edx, dword ptr [ecx + field_1c]         # 0049f347
    mov eax, dword ptr [ebp - local_98]          # 0049f34b
    mov ecx, dword ptr [eax + field_e40]         # 0049f351
    lea edx, [ecx + 2*edx]                       # 0049f357
    mov eax, dword ptr [ebp - local_6c]          # 0049f35a
    mov cx, word ptr [edx + 2*eax + field_4]     # 0049f35d
    mov word ptr [ebp - local_54], cx            # 0049f362
    mov edx, dword ptr [ebp - local_98]          # 0049f366
    mov eax, dword ptr [ebp - local_58]          # 0049f36c
    imul eax, dword ptr [edx + field_1c]         # 0049f36f
    mov ecx, dword ptr [ebp - local_98]          # 0049f373
    mov edx, dword ptr [ecx + field_e40]         # 0049f379
    lea eax, [edx + 2*eax]                       # 0049f37f
    mov ecx, dword ptr [ebp - local_6c]          # 0049f382
    mov dx, word ptr [ebp - local_54]            # 0049f385
    mov word ptr [eax + 2*ecx + field_2], dx     # 0049f389
L_0049f38e:
    # block 0x0049f38e: entered by jmp at 0x0049f23c, 1 instruction(s), ends with forward jump to 0x0049f65b
    jmp.d32 L_0049f65b                           # 0049f38e
L_0049f393:
    # block 0x0049f393: entered by jne at 0x0049f0d3, 5 instruction(s), ends with jne to 0x0049f504 (forward)
    mov eax, dword ptr [ebp - local_60]          # 0049f393
    or eax, 0x4000000                            # 0049f396
    mov dword ptr [ebp - local_60], eax          # 0049f39b
    cmp dword ptr [ebp - local_1c], 0x0          # 0049f39e
    jne.d32 L_0049f504                           # 0049f3a2
    # block 0x0049f3a8: entered by fall-through of jne at 0x0049f3a2, 3 instruction(s), ends with jge to 0x0049f3be (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049f3a8
    cmp ecx, dword ptr [ebp - local_90]          # 0049f3ab
    jge.d8 L_0049f3be                            # 0049f3b1
    # block 0x0049f3b3: entered by fall-through of jge at 0x0049f3b1, 3 instruction(s), ends with forward jump to 0x0049f3ca
    mov edx, dword ptr [ebp - local_5c]          # 0049f3b3
    mov dword ptr [ebp - local_b0], edx          # 0049f3b6
    jmp.d8 L_0049f3ca                            # 0049f3bc
L_0049f3be:
    # block 0x0049f3be: entered by jge at 0x0049f3b1, 2 instruction(s), falls into the block at 0x0049f3ca
    mov eax, dword ptr [ebp - local_90]          # 0049f3be
    mov dword ptr [ebp - local_b0], eax          # 0049f3c4
L_0049f3ca:
    # block 0x0049f3ca: entered by jmp at 0x0049f3bc, 73 instruction(s), ends with forward jump to 0x0049f65b
    mov ecx, dword ptr [ebp - local_b0]          # 0049f3ca
    mov dword ptr [ebp - local_58], ecx          # 0049f3d0
    mov edx, dword ptr [ebp - local_70]          # 0049f3d3
    mov dword ptr [ebp - local_6c], edx          # 0049f3d6
    mov eax, dword ptr [ebp - local_98]          # 0049f3d9
    mov ecx, dword ptr [ebp - local_58]          # 0049f3df
    imul ecx, dword ptr [eax + field_1c]         # 0049f3e2
    mov edx, dword ptr [ebp - local_98]          # 0049f3e6
    mov eax, dword ptr [edx + field_e38]         # 0049f3ec
    lea ecx, [eax + 4*ecx]                       # 0049f3f2
    mov edx, dword ptr [ebp - local_6c]          # 0049f3f5
    mov eax, dword ptr [ebp - local_60]          # 0049f3f8
    mov dword ptr [ecx + 4*edx], eax             # 0049f3fb
    mov ecx, dword ptr [ebp - local_58]          # 0049f3fe
    add ecx, 0x2                                 # 0049f401
    mov edx, dword ptr [ebp - local_98]          # 0049f404
    imul ecx, dword ptr [edx + field_1c]         # 0049f40a
    mov eax, dword ptr [ebp - local_98]          # 0049f40e
    mov edx, dword ptr [eax + field_e38]         # 0049f414
    lea eax, [edx + 4*ecx]                       # 0049f41a
    mov ecx, dword ptr [ebp - local_6c]          # 0049f41d
    mov edx, dword ptr [eax + 4*ecx]             # 0049f420
    mov dword ptr [ebp - local_8c], edx          # 0049f423
    mov eax, dword ptr [ebp - local_58]          # 0049f429
    add eax, 0x1                                 # 0049f42c
    mov ecx, dword ptr [ebp - local_98]          # 0049f42f
    imul eax, dword ptr [ecx + field_1c]         # 0049f435
    mov edx, dword ptr [ebp - local_98]          # 0049f439
    mov ecx, dword ptr [edx + field_e38]         # 0049f43f
    lea edx, [ecx + 4*eax]                       # 0049f445
    mov eax, dword ptr [ebp - local_6c]          # 0049f448
    mov ecx, dword ptr [ebp - local_8c]          # 0049f44b
    mov dword ptr [edx + 4*eax], ecx             # 0049f451
    mov edx, dword ptr [ebp - local_58]          # 0049f454
    sub edx, 0x1                                 # 0049f457
    mov eax, dword ptr [ebp - local_98]          # 0049f45a
    imul edx, dword ptr [eax + field_1c]         # 0049f460
    mov ecx, dword ptr [ebp - local_98]          # 0049f464
    mov eax, dword ptr [ecx + field_e40]         # 0049f46a
    lea ecx, [eax + 2*edx]                       # 0049f470
    mov edx, dword ptr [ebp - local_6c]          # 0049f473
    mov ax, word ptr [ecx + 2*edx]               # 0049f476
    mov word ptr [ebp - local_88], ax            # 0049f47a
    mov ecx, dword ptr [ebp - local_98]          # 0049f481
    mov edx, dword ptr [ebp - local_58]          # 0049f487
    imul edx, dword ptr [ecx + field_1c]         # 0049f48a
    mov eax, dword ptr [ebp - local_98]          # 0049f48e
    mov ecx, dword ptr [eax + field_e40]         # 0049f494
    lea edx, [ecx + 2*edx]                       # 0049f49a
    mov eax, dword ptr [ebp - local_6c]          # 0049f49d
    mov cx, word ptr [ebp - local_88]            # 0049f4a0
    mov word ptr [edx + 2*eax], cx               # 0049f4a7
    mov edx, dword ptr [ebp - local_58]          # 0049f4ab
    add edx, 0x2                                 # 0049f4ae
    mov eax, dword ptr [ebp - local_98]          # 0049f4b1
    imul edx, dword ptr [eax + field_1c]         # 0049f4b7
    mov ecx, dword ptr [ebp - local_98]          # 0049f4bb
    mov eax, dword ptr [ecx + field_e40]         # 0049f4c1
    lea ecx, [eax + 2*edx]                       # 0049f4c7
    mov edx, dword ptr [ebp - local_6c]          # 0049f4ca
    mov ax, word ptr [ecx + 2*edx]               # 0049f4cd
    mov word ptr [ebp - local_54], ax            # 0049f4d1
    mov ecx, dword ptr [ebp - local_58]          # 0049f4d5
    add ecx, 0x1                                 # 0049f4d8
    mov edx, dword ptr [ebp - local_98]          # 0049f4db
    imul ecx, dword ptr [edx + field_1c]         # 0049f4e1
    mov eax, dword ptr [ebp - local_98]          # 0049f4e5
    mov edx, dword ptr [eax + field_e40]         # 0049f4eb
    lea eax, [edx + 2*ecx]                       # 0049f4f1
    mov ecx, dword ptr [ebp - local_6c]          # 0049f4f4
    mov dx, word ptr [ebp - local_54]            # 0049f4f7
    mov word ptr [eax + 2*ecx], dx               # 0049f4fb
    jmp.d32 L_0049f65b                           # 0049f4ff
L_0049f504:
    # block 0x0049f504: entered by jne at 0x0049f3a2, 3 instruction(s), ends with jle to 0x0049f51a (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049f504
    cmp eax, dword ptr [ebp - local_90]          # 0049f507
    jle.d8 L_0049f51a                            # 0049f50d
    # block 0x0049f50f: entered by fall-through of jle at 0x0049f50d, 3 instruction(s), ends with forward jump to 0x0049f526
    mov ecx, dword ptr [ebp - local_5c]          # 0049f50f
    mov dword ptr [ebp - local_b4], ecx          # 0049f512
    jmp.d8 L_0049f526                            # 0049f518
L_0049f51a:
    # block 0x0049f51a: entered by jle at 0x0049f50d, 2 instruction(s), falls into the block at 0x0049f526
    mov edx, dword ptr [ebp - local_90]          # 0049f51a
    mov dword ptr [ebp - local_b4], edx          # 0049f520
L_0049f526:
    # block 0x0049f526: entered by jmp at 0x0049f518, 72 instruction(s), falls into the block at 0x0049f65b
    mov eax, dword ptr [ebp - local_b4]          # 0049f526
    mov dword ptr [ebp - local_58], eax          # 0049f52c
    mov ecx, dword ptr [ebp - local_70]          # 0049f52f
    mov dword ptr [ebp - local_6c], ecx          # 0049f532
    mov edx, dword ptr [ebp - local_98]          # 0049f535
    mov eax, dword ptr [ebp - local_58]          # 0049f53b
    imul eax, dword ptr [edx + field_1c]         # 0049f53e
    mov ecx, dword ptr [ebp - local_98]          # 0049f542
    mov edx, dword ptr [ecx + field_e38]         # 0049f548
    lea eax, [edx + 4*eax]                       # 0049f54e
    mov ecx, dword ptr [ebp - local_6c]          # 0049f551
    mov edx, dword ptr [ebp - local_60]          # 0049f554
    mov dword ptr [eax + 4*ecx], edx             # 0049f557
    mov eax, dword ptr [ebp - local_58]          # 0049f55a
    sub eax, 0x2                                 # 0049f55d
    mov ecx, dword ptr [ebp - local_98]          # 0049f560
    imul eax, dword ptr [ecx + field_1c]         # 0049f566
    mov edx, dword ptr [ebp - local_98]          # 0049f56a
    mov ecx, dword ptr [edx + field_e38]         # 0049f570
    lea edx, [ecx + 4*eax]                       # 0049f576
    mov eax, dword ptr [ebp - local_6c]          # 0049f579
    mov ecx, dword ptr [edx + 4*eax]             # 0049f57c
    mov dword ptr [ebp - local_8c], ecx          # 0049f57f
    mov edx, dword ptr [ebp - local_58]          # 0049f585
    sub edx, 0x1                                 # 0049f588
    mov eax, dword ptr [ebp - local_98]          # 0049f58b
    imul edx, dword ptr [eax + field_1c]         # 0049f591
    mov ecx, dword ptr [ebp - local_98]          # 0049f595
    mov eax, dword ptr [ecx + field_e38]         # 0049f59b
    lea ecx, [eax + 4*edx]                       # 0049f5a1
    mov edx, dword ptr [ebp - local_6c]          # 0049f5a4
    mov eax, dword ptr [ebp - local_8c]          # 0049f5a7
    mov dword ptr [ecx + 4*edx], eax             # 0049f5ad
    mov ecx, dword ptr [ebp - local_58]          # 0049f5b0
    add ecx, 0x1                                 # 0049f5b3
    mov edx, dword ptr [ebp - local_98]          # 0049f5b6
    imul ecx, dword ptr [edx + field_1c]         # 0049f5bc
    mov eax, dword ptr [ebp - local_98]          # 0049f5c0
    mov edx, dword ptr [eax + field_e40]         # 0049f5c6
    lea eax, [edx + 2*ecx]                       # 0049f5cc
    mov ecx, dword ptr [ebp - local_6c]          # 0049f5cf
    mov dx, word ptr [eax + 2*ecx]               # 0049f5d2
    mov word ptr [ebp - local_88], dx            # 0049f5d6
    mov eax, dword ptr [ebp - local_98]          # 0049f5dd
    mov ecx, dword ptr [ebp - local_58]          # 0049f5e3
    imul ecx, dword ptr [eax + field_1c]         # 0049f5e6
    mov edx, dword ptr [ebp - local_98]          # 0049f5ea
    mov eax, dword ptr [edx + field_e40]         # 0049f5f0
    lea ecx, [eax + 2*ecx]                       # 0049f5f6
    mov edx, dword ptr [ebp - local_6c]          # 0049f5f9
    mov ax, word ptr [ebp - local_88]            # 0049f5fc
    mov word ptr [ecx + 2*edx], ax               # 0049f603
    mov ecx, dword ptr [ebp - local_58]          # 0049f607
    sub ecx, 0x2                                 # 0049f60a
    mov edx, dword ptr [ebp - local_98]          # 0049f60d
    imul ecx, dword ptr [edx + field_1c]         # 0049f613
    mov eax, dword ptr [ebp - local_98]          # 0049f617
    mov edx, dword ptr [eax + field_e40]         # 0049f61d
    lea eax, [edx + 2*ecx]                       # 0049f623
    mov ecx, dword ptr [ebp - local_6c]          # 0049f626
    mov dx, word ptr [eax + 2*ecx]               # 0049f629
    mov word ptr [ebp - local_54], dx            # 0049f62d
    mov eax, dword ptr [ebp - local_58]          # 0049f631
    sub eax, 0x1                                 # 0049f634
    mov ecx, dword ptr [ebp - local_98]          # 0049f637
    imul eax, dword ptr [ecx + field_1c]         # 0049f63d
    mov edx, dword ptr [ebp - local_98]          # 0049f641
    mov ecx, dword ptr [edx + field_e40]         # 0049f647
    lea edx, [ecx + 2*eax]                       # 0049f64d
    mov eax, dword ptr [ebp - local_6c]          # 0049f650
    mov cx, word ptr [ebp - local_54]            # 0049f653
    mov word ptr [edx + 2*eax], cx               # 0049f657
L_0049f65b:
    # block 0x0049f65b: entered by jmp at 0x0049f38e; jmp at 0x0049f4ff, 137 instruction(s), ends with forward jump to 0x0049f85f
    mov dword ptr [ebp - local_80], 0x0          # 0049f65b
    mov dword ptr [ebp - local_74], 0x0          # 0049f662
    mov dword ptr [ebp - local_14], 0x0          # 0049f669
    mov edx, dword ptr [ebp - local_88]          # 0049f670
    and edx, 0xffff                              # 0049f676
    sar edx, 0x8                                 # 0049f67c
    and edx, 0xf                                 # 0049f67f
    mov dword ptr [ebp - local_80], edx          # 0049f682
    mov eax, dword ptr [ebp - local_88]          # 0049f685
    and eax, 0xffff                              # 0049f68b
    sar eax, 0x4                                 # 0049f690
    and eax, 0xf                                 # 0049f693
    mov dword ptr [ebp - local_74], eax          # 0049f696
    mov ecx, dword ptr [ebp - local_88]          # 0049f699
    and ecx, 0xffff                              # 0049f69f
    and ecx, 0xf                                 # 0049f6a5
    mov dword ptr [ebp - local_14], ecx          # 0049f6a8
    mov edx, dword ptr [ebp - local_88]          # 0049f6ab
    and edx, 0xffff                              # 0049f6b1
    and edx, 0xf000                              # 0049f6b7
    mov word ptr [ebp - local_78], dx            # 0049f6bd
    mov eax, dword ptr [ebp - local_80]          # 0049f6c1
    sub eax, 0x2                                 # 0049f6c4
    mov dword ptr [ebp - local_80], eax          # 0049f6c7
    mov ecx, dword ptr [ebp - local_74]          # 0049f6ca
    sub ecx, 0x2                                 # 0049f6cd
    mov dword ptr [ebp - local_74], ecx          # 0049f6d0
    mov edx, dword ptr [ebp - local_14]          # 0049f6d3
    sub edx, 0x2                                 # 0049f6d6
    mov dword ptr [ebp - local_14], edx          # 0049f6d9
    {load} xor eax, eax                          # 0049f6dc
    cmp dword ptr [ebp - local_80], 0x0          # 0049f6de
    setle al                                     # 0049f6e2
    dec eax                                      # 0049f6e5
    and eax, dword ptr [ebp - local_80]          # 0049f6e6
    mov dword ptr [ebp - local_80], eax          # 0049f6e9
    {load} xor ecx, ecx                          # 0049f6ec
    cmp dword ptr [ebp - local_74], 0x0          # 0049f6ee
    setle cl                                     # 0049f6f2
    dec ecx                                      # 0049f6f5
    and ecx, dword ptr [ebp - local_74]          # 0049f6f6
    mov dword ptr [ebp - local_74], ecx          # 0049f6f9
    {load} xor edx, edx                          # 0049f6fc
    cmp dword ptr [ebp - local_14], 0x0          # 0049f6fe
    setle dl                                     # 0049f702
    dec edx                                      # 0049f705
    and edx, dword ptr [ebp - local_14]          # 0049f706
    mov dword ptr [ebp - local_14], edx          # 0049f709
    mov eax, dword ptr [ebp - local_80]          # 0049f70c
    shl eax, 0x8                                 # 0049f70f
    mov dword ptr [ebp - local_80], eax          # 0049f712
    mov ecx, dword ptr [ebp - local_74]          # 0049f715
    shl ecx, 0x4                                 # 0049f718
    mov dword ptr [ebp - local_74], ecx          # 0049f71b
    mov word ptr [ebp - local_88], 0x0           # 0049f71e
    mov edx, dword ptr [ebp - local_78]          # 0049f727
    and edx, 0xffff                              # 0049f72a
    or edx, dword ptr [ebp - local_80]           # 0049f730
    or edx, dword ptr [ebp - local_74]           # 0049f733
    or edx, dword ptr [ebp - local_14]           # 0049f736
    mov word ptr [ebp - local_88], dx            # 0049f739
    mov eax, dword ptr [ebp - local_98]          # 0049f740
    mov ecx, dword ptr [ebp - local_58]          # 0049f746
    imul ecx, dword ptr [eax + field_1c]         # 0049f749
    mov edx, dword ptr [ebp - local_98]          # 0049f74d
    mov eax, dword ptr [edx + field_e40]         # 0049f753
    lea ecx, [eax + 2*ecx]                       # 0049f759
    mov edx, dword ptr [ebp - local_6c]          # 0049f75c
    mov ax, word ptr [ebp - local_88]            # 0049f75f
    mov word ptr [ecx + 2*edx], ax               # 0049f766
    mov dword ptr [ebp - local_7c], 0x0          # 0049f76a
    mov ecx, dword ptr [ebp - local_7c]          # 0049f771
    mov dword ptr [ebp - local_c], ecx           # 0049f774
    mov dx, word ptr [ebp - local_c]             # 0049f777
    mov word ptr [ebp - local_18], dx            # 0049f77b
    mov eax, dword ptr [ebp - local_98]          # 0049f77f
    mov ecx, dword ptr [ebp - local_58]          # 0049f785
    imul ecx, dword ptr [eax + field_1c]         # 0049f788
    mov edx, dword ptr [ebp - local_98]          # 0049f78c
    mov eax, dword ptr [edx + field_e44]         # 0049f792
    lea ecx, [eax + 2*ecx]                       # 0049f798
    mov edx, dword ptr [ebp - local_6c]          # 0049f79b
    mov ax, word ptr [ecx + 2*edx]               # 0049f79e
    mov word ptr [ebp - local_18], ax            # 0049f7a2
    mov ecx, dword ptr [ebp - local_18]          # 0049f7a6
    and ecx, 0xffff                              # 0049f7a9
    sar ecx, 0x4                                 # 0049f7af
    and ecx, 0xf                                 # 0049f7b2
    mov dword ptr [ebp - local_7c], ecx          # 0049f7b5
    mov edx, dword ptr [ebp - local_18]          # 0049f7b8
    and edx, 0xffff                              # 0049f7bb
    and edx, 0xf                                 # 0049f7c1
    mov dword ptr [ebp - local_c], edx           # 0049f7c4
    mov eax, dword ptr [ebp - local_18]          # 0049f7c7
    and eax, 0xffff                              # 0049f7ca
    and eax, 0xf000                              # 0049f7cf
    mov word ptr [ebp - local_78], ax            # 0049f7d4
    mov ecx, dword ptr [ebp - local_7c]          # 0049f7d8
    sub ecx, 0x2                                 # 0049f7db
    mov dword ptr [ebp - local_7c], ecx          # 0049f7de
    mov edx, dword ptr [ebp - local_c]           # 0049f7e1
    sub edx, 0x2                                 # 0049f7e4
    mov dword ptr [ebp - local_c], edx           # 0049f7e7
    {load} xor eax, eax                          # 0049f7ea
    cmp dword ptr [ebp - local_7c], 0x0          # 0049f7ec
    setle al                                     # 0049f7f0
    dec eax                                      # 0049f7f3
    and eax, dword ptr [ebp - local_7c]          # 0049f7f4
    mov dword ptr [ebp - local_7c], eax          # 0049f7f7
    {load} xor ecx, ecx                          # 0049f7fa
    cmp dword ptr [ebp - local_c], 0x0           # 0049f7fc
    setle cl                                     # 0049f800
    dec ecx                                      # 0049f803
    and ecx, dword ptr [ebp - local_c]           # 0049f804
    mov dword ptr [ebp - local_c], ecx           # 0049f807
    mov edx, dword ptr [ebp - local_7c]          # 0049f80a
    shl edx, 0x4                                 # 0049f80d
    mov dword ptr [ebp - local_7c], edx          # 0049f810
    mov word ptr [ebp - local_18], 0x0           # 0049f813
    mov eax, dword ptr [ebp - local_78]          # 0049f819
    and eax, 0xffff                              # 0049f81c
    or eax, dword ptr [ebp - local_7c]           # 0049f821
    or eax, dword ptr [ebp - local_c]            # 0049f824
    mov word ptr [ebp - local_18], ax            # 0049f827
    mov ecx, dword ptr [ebp - local_98]          # 0049f82b
    mov edx, dword ptr [ebp - local_58]          # 0049f831
    imul edx, dword ptr [ecx + field_1c]         # 0049f834
    mov eax, dword ptr [ebp - local_98]          # 0049f838
    mov ecx, dword ptr [eax + field_e44]         # 0049f83e
    lea edx, [ecx + 2*edx]                       # 0049f844
    mov eax, dword ptr [ebp - local_6c]          # 0049f847
    mov cx, word ptr [ebp - local_18]            # 0049f84a
    mov word ptr [edx + 2*eax], cx               # 0049f84e
    mov edx, dword ptr [ebp - local_48]          # 0049f852
    add edx, 0x1                                 # 0049f855
    mov dword ptr [ebp - local_48], edx          # 0049f858
    jmp.d8 L_0049f85f                            # 0049f85b
L_0049f85d:
    # block 0x0049f85d: entered by je at 0x0049f0a1, 1 instruction(s), ends with forward jump to 0x0049f864
    jmp.d8 L_0049f864                            # 0049f85d
L_0049f85f:
    # block 0x0049f85f: entered by jmp at 0x0049f85b, 1 instruction(s), ends with backward jump to 0x0049e551
    jmp.d32 L_0049e551                           # 0049f85f
L_0049f864:
    # block 0x0049f864: entered by jge at 0x0049e557; jmp at 0x0049f85d, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0049f864
    pop ebp                                      # 0049f866
    ret 0xc                                      # 0049f867

