# FUN_004b372c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b372c
# extent:       0x004b372c-0x004b3b3a (1038 code bytes)
# span:         0x004b372c-0x004b3b40 (code 1038, tables 0, padding 6)
# sha256:       7e267821ca82ae4e1760c966f860ea8963cf5031cf33d06961683e84495c6f1e
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b372c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_21, field_18e, field_19a, field_1aa, field_268, field_26c; [ecx + n] field_23, field_192, field_196, field_19a, field_1aa, field_1b0, field_264; [edx + n] field_11d, field_18e, field_192, field_196, field_270
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 247 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_11d, 0x11d  # offset +0x11d
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_196, 0x196  # offset +0x196
.equ field_19a, 0x19a  # offset +0x19a
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_264, 0x264  # offset +0x264
.equ field_268, 0x268  # offset +0x268
.equ field_26c, 0x26c  # offset +0x26c
.equ field_270, 0x270  # offset +0x270

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004b372c - 0x401000
.globl FUN_004b372c
FUN_004b372c:
    # block 0x004b372c: entry, 9 instruction(s), ends with jne to 0x004b37e3 (forward)
    push ebp                                     # 004b372c
    {load} mov ebp, esp                          # 004b372d
    sub esp, 0x2c                                # 004b372f
    movsx eax, word ptr [0x6204df]               # 004b3732
    imul eax, eax, 0x8d                          # 004b3739
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b373f
    mov dword ptr [ebp - local_1c], ecx          # 004b3745
    cmp dword ptr [0x6204fc], 0x1                # 004b3748
    jne.d32 L_004b37e3                           # 004b374f
    # block 0x004b3755: entered by fall-through of jne at 0x004b374f, 4 instruction(s), ends with jne to 0x004b377a (forward)
    mov edx, dword ptr [0x6204f6]                # 004b3755
    sub edx, dword ptr [0x6204ee]                # 004b375b
    test edx, edx                                # 004b3761
    jne.d8 L_004b377a                            # 004b3763
    # block 0x004b3765: entered by fall-through of jne at 0x004b3763, 2 instruction(s), ends with jne to 0x004b3778 (forward)
    cmp dword ptr [0x6204e5], 0x2                # 004b3765
    jne.d8 L_004b3778                            # 004b376c
    # block 0x004b376e: entered by fall-through of jne at 0x004b376c, 1 instruction(s), falls into the block at 0x004b3778
    mov dword ptr [0x6204e5], 0x0                # 004b376e
L_004b3778:
    # block 0x004b3778: entered by jne at 0x004b376c, 1 instruction(s), ends with forward jump to 0x004b37e3
    jmp.d8 L_004b37e3                            # 004b3778
L_004b377a:
    # block 0x004b377a: entered by jne at 0x004b3763, 23 instruction(s), calls FUN_004c5377, falls into the block at 0x004b37e3
    mov eax, dword ptr [0x6204ee]                # 004b377a
    sub eax, dword ptr [0x58318a]                # 004b377f
    mov dword ptr [ebp - local_28], eax          # 004b3785
    mov ecx, dword ptr [0x6204f6]                # 004b3788
    sub ecx, dword ptr [0x58318a]                # 004b378e
    mov dword ptr [ebp - local_20], ecx          # 004b3794
    mov edx, dword ptr [0x6204ea]                # 004b3797
    sub edx, dword ptr [0x583186]                # 004b379d
    mov dword ptr [ebp - local_2c], edx          # 004b37a3
    mov eax, dword ptr [0x6204f2]                # 004b37a6
    sub eax, dword ptr [0x583186]                # 004b37ab
    mov dword ptr [ebp - local_24], eax          # 004b37b1
    push 0x55182c                                # 004b37b4
    push 0x6204ea                                # 004b37b9
    lea ecx, [ebp - local_2c]                    # 004b37be
    push ecx                                     # 004b37c1
    mov edx, dword ptr [0x5cf665]                # 004b37c2
    push edx                                     # 004b37c8
    mov eax, dword ptr [0x5d15e3]                # 004b37c9
    push eax                                     # 004b37ce
    mov ecx, 0x5cf659                            # 004b37cf
    call FUN_004c5377                            # 004b37d4
    mov dword ptr [0x6204fc], 0x0                # 004b37d9
L_004b37e3:
    # block 0x004b37e3: entered by jne at 0x004b374f; jmp at 0x004b3778, 2 instruction(s), ends with forward jump to 0x004b37f7
    mov word ptr [ebp - local_4], 0x0            # 004b37e3
    jmp.d8 L_004b37f7                            # 004b37e9
L_004b37eb:
    # block 0x004b37eb: entered by jmp at 0x004b3920, 3 instruction(s), falls into the block at 0x004b37f7
    mov cx, word ptr [ebp - local_4]             # 004b37eb
    add cx, 0x1                                  # 004b37ef
    mov word ptr [ebp - local_4], cx             # 004b37f3
L_004b37f7:
    # block 0x004b37f7: entered by jmp at 0x004b37e9, 5 instruction(s), ends with jge to 0x004b3925 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b37f7
    mov eax, dword ptr [ebp - local_1c]          # 004b37fb
    movsx ecx, word ptr [eax + field_21]         # 004b37fe
    {load} cmp edx, ecx                          # 004b3802
    jge.d32 L_004b3925                           # 004b3804
    # block 0x004b380a: entered by fall-through of jge at 0x004b3804, 2 instruction(s), ends with forward jump to 0x004b381e
    mov word ptr [ebp - local_18], 0x0           # 004b380a
    jmp.d8 L_004b381e                            # 004b3810
L_004b3812:
    # block 0x004b3812: entered by jmp at 0x004b391b, 3 instruction(s), falls into the block at 0x004b381e
    mov dx, word ptr [ebp - local_18]            # 004b3812
    add dx, 0x1                                  # 004b3816
    mov word ptr [ebp - local_18], dx            # 004b381a
L_004b381e:
    # block 0x004b381e: entered by jmp at 0x004b3810, 5 instruction(s), ends with jge to 0x004b3920 (forward)
    movsx eax, word ptr [ebp - local_18]         # 004b381e
    mov ecx, dword ptr [ebp - local_1c]          # 004b3822
    movsx edx, word ptr [ecx + field_23]         # 004b3825
    {load} cmp eax, edx                          # 004b3829
    jge.d32 L_004b3920                           # 004b382b
    # block 0x004b3831: entered by fall-through of jge at 0x004b382b, 6 instruction(s), ends with je to 0x004b391b (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b3831
    imul eax, eax, 0x1e4                         # 004b3835
    movsx ecx, word ptr [ebp - local_18]         # 004b383b
    imul ecx, ecx, 0x2c                          # 004b383f
    cmp dword ptr [eax + ecx + 0x620518], 0x0    # 004b3842
    je.d32 L_004b391b                            # 004b384a
    # block 0x004b3850: entered by fall-through of je at 0x004b384a, 7 instruction(s), ends with je to 0x004b391b (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b3850
    imul edx, edx, 0x1e4                         # 004b3854
    movsx eax, word ptr [ebp - local_18]         # 004b385a
    imul eax, eax, 0x2c                          # 004b385e
    movsx ecx, word ptr [edx + eax + 0x62051c]   # 004b3861
    test ecx, ecx                                # 004b3869
    je.d32 L_004b391b                            # 004b386b
    # block 0x004b3871: entered by fall-through of je at 0x004b386b, 2 instruction(s), ends with jne to 0x004b38b1 (forward)
    cmp dword ptr [0x6204e5], 0x1                # 004b3871
    jne.d8 L_004b38b1                            # 004b3878
    # block 0x004b387a: entered by fall-through of jne at 0x004b3878, 6 instruction(s), ends with jge to 0x004b38b1 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b387a
    imul edx, edx, 0x1e4                         # 004b387e
    movsx eax, word ptr [ebp - local_18]         # 004b3884
    imul eax, eax, 0x2c                          # 004b3888
    cmp dword ptr [edx + eax + 0x620508], 0x0    # 004b388b
    jge.d8 L_004b38b1                            # 004b3893
    # block 0x004b3895: entered by fall-through of jge at 0x004b3893, 4 instruction(s), ends with forward jump to 0x004b3b36
    movsx ecx, word ptr [0x6204df]               # 004b3895
    imul ecx, ecx, 0x8d                          # 004b389c
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004b38a2
    jmp.d32 L_004b3b36                           # 004b38ac
L_004b38b1:
    # block 0x004b38b1: entered by jne at 0x004b3878; jge at 0x004b3893, 25 instruction(s), calls FUN_004c5377, falls into the block at 0x004b391b
    push 0x551840                                # 004b38b1
    movsx edx, word ptr [ebp - local_4]          # 004b38b6
    imul edx, edx, 0x1e4                         # 004b38ba
    movsx eax, word ptr [ebp - local_18]         # 004b38c0
    imul eax, eax, 0x2c                          # 004b38c4
    lea ecx, [edx + eax + 0x620508]              # 004b38c7
    push ecx                                     # 004b38ce
    movsx edx, word ptr [ebp - local_4]          # 004b38cf
    imul edx, edx, 0x1e4                         # 004b38d3
    movsx eax, word ptr [ebp - local_18]         # 004b38d9
    imul eax, eax, 0x2c                          # 004b38dd
    movsx ecx, word ptr [edx + eax + 0x62051c]   # 004b38e0
    sub ecx, 0x1                                 # 004b38e8
    shl ecx, 0x4                                 # 004b38eb
    mov edx, dword ptr [ebp - local_1c]          # 004b38ee
    lea eax, [edx + ecx + field_11d]             # 004b38f1
    push eax                                     # 004b38f8
    mov ecx, dword ptr [0x5cf665]                # 004b38f9
    push ecx                                     # 004b38ff
    movsx edx, word ptr [0x6204dd]               # 004b3900
    imul edx, edx, 0x4a                          # 004b3907
    mov eax, dword ptr [edx + 0x5d1599]          # 004b390a
    push eax                                     # 004b3910
    mov ecx, 0x5cf659                            # 004b3911
    call FUN_004c5377                            # 004b3916
L_004b391b:
    # block 0x004b391b: entered by je at 0x004b384a; je at 0x004b386b, 1 instruction(s), ends with backward jump to 0x004b3812
    jmp.d32 L_004b3812                           # 004b391b
L_004b3920:
    # block 0x004b3920: entered by jge at 0x004b382b, 1 instruction(s), ends with backward jump to 0x004b37eb
    jmp.d32 L_004b37eb                           # 004b3920
L_004b3925:
    # block 0x004b3925: entered by jge at 0x004b3804, 4 instruction(s), ends with je to 0x004b39b6 (forward)
    {load} xor ecx, ecx                          # 004b3925
    mov cl, byte ptr [0x6219d1]                  # 004b3927
    test ecx, ecx                                # 004b392d
    je.d32 L_004b39b6                            # 004b392f
    # block 0x004b3935: entered by fall-through of je at 0x004b392f, 31 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004b3a3a
    mov edx, dword ptr [ebp - local_1c]          # 004b3935
    mov eax, dword ptr [edx + field_192]         # 004b3938
    add eax, dword ptr [0x58318a]                # 004b393e
    mov dword ptr [ebp - local_10], eax          # 004b3944
    mov ecx, dword ptr [ebp - local_1c]          # 004b3947
    mov edx, dword ptr [ecx + field_19a]         # 004b394a
    add edx, dword ptr [0x58318a]                # 004b3950
    mov dword ptr [ebp - local_8], edx           # 004b3956
    mov eax, dword ptr [ebp - local_1c]          # 004b3959
    mov ecx, dword ptr [eax + field_18e]         # 004b395c
    add ecx, dword ptr [0x583186]                # 004b3962
    mov dword ptr [ebp - local_14], ecx          # 004b3968
    mov edx, dword ptr [ebp - local_1c]          # 004b396b
    mov eax, dword ptr [edx + field_196]         # 004b396e
    add eax, dword ptr [0x583186]                # 004b3974
    mov dword ptr [ebp - local_c], eax           # 004b397a
    push 0x55185c                                # 004b397d
    lea ecx, [ebp - local_14]                    # 004b3982
    push ecx                                     # 004b3985
    mov edx, dword ptr [ebp - local_1c]          # 004b3986
    add edx, 0x17e                               # 004b3989
    push edx                                     # 004b398f
    mov eax, dword ptr [0x5cf665]                # 004b3990
    push eax                                     # 004b3995
    movsx ecx, word ptr [0x6204dd]               # 004b3996
    imul ecx, ecx, 0x4a                          # 004b399d
    mov edx, dword ptr [ecx + 0x5d1599]          # 004b39a0
    push edx                                     # 004b39a6
    mov ecx, 0x5cf659                            # 004b39a7
    call FUN_004c5377                            # 004b39ac
    jmp.d32 L_004b3a3a                           # 004b39b1
L_004b39b6:
    # block 0x004b39b6: entered by je at 0x004b392f, 4 instruction(s), ends with je to 0x004b3a3a (forward)
    {load} xor eax, eax                          # 004b39b6
    mov al, byte ptr [0x6219d0]                  # 004b39b8
    test eax, eax                                # 004b39bd
    je.d8 L_004b3a3a                             # 004b39bf
    # block 0x004b39c1: entered by fall-through of je at 0x004b39bf, 29 instruction(s), calls FUN_004c5377, falls into the block at 0x004b3a3a
    mov ecx, dword ptr [ebp - local_1c]          # 004b39c1
    mov edx, dword ptr [ecx + field_192]         # 004b39c4
    add edx, dword ptr [0x58318a]                # 004b39ca
    mov dword ptr [ebp - local_10], edx          # 004b39d0
    mov eax, dword ptr [ebp - local_1c]          # 004b39d3
    mov ecx, dword ptr [eax + field_19a]         # 004b39d6
    add ecx, dword ptr [0x58318a]                # 004b39dc
    mov dword ptr [ebp - local_8], ecx           # 004b39e2
    mov edx, dword ptr [ebp - local_1c]          # 004b39e5
    mov eax, dword ptr [edx + field_18e]         # 004b39e8
    add eax, dword ptr [0x583186]                # 004b39ee
    mov dword ptr [ebp - local_14], eax          # 004b39f4
    mov ecx, dword ptr [ebp - local_1c]          # 004b39f7
    mov edx, dword ptr [ecx + field_196]         # 004b39fa
    add edx, dword ptr [0x583186]                # 004b3a00
    mov dword ptr [ebp - local_c], edx           # 004b3a06
    push 0x551878                                # 004b3a09
    lea eax, [ebp - local_14]                    # 004b3a0e
    push eax                                     # 004b3a11
    mov ecx, dword ptr [ebp - local_1c]          # 004b3a12
    add ecx, 0x18e                               # 004b3a15
    push ecx                                     # 004b3a1b
    mov edx, dword ptr [0x5cf665]                # 004b3a1c
    push edx                                     # 004b3a22
    mov eax, dword ptr [0x5d15e3]                # 004b3a23
    push eax                                     # 004b3a28
    mov ecx, 0x5cf659                            # 004b3a29
    call FUN_004c5377                            # 004b3a2e
    mov byte ptr [0x6219d0], 0x0                 # 004b3a33
L_004b3a3a:
    # block 0x004b3a3a: entered by jmp at 0x004b39b1; je at 0x004b39bf, 4 instruction(s), ends with jle to 0x004b3b36 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004b3a3a
    movsx edx, word ptr [ecx + field_1aa]        # 004b3a3d
    test edx, edx                                # 004b3a44
    jle.d32 L_004b3b36                           # 004b3a46
    # block 0x004b3a4c: entered by fall-through of jle at 0x004b3a46, 22 instruction(s), ends with jne to 0x004b3aeb (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004b3a4c
    mov ecx, dword ptr [eax + field_268]         # 004b3a4f
    add ecx, dword ptr [0x58318a]                # 004b3a55
    mov dword ptr [ebp - local_10], ecx          # 004b3a5b
    mov edx, dword ptr [ebp - local_1c]          # 004b3a5e
    mov eax, dword ptr [edx + field_270]         # 004b3a61
    add eax, dword ptr [0x58318a]                # 004b3a67
    mov dword ptr [ebp - local_8], eax           # 004b3a6d
    mov ecx, dword ptr [ebp - local_1c]          # 004b3a70
    mov edx, dword ptr [ecx + field_264]         # 004b3a73
    add edx, dword ptr [0x583186]                # 004b3a79
    mov dword ptr [ebp - local_14], edx          # 004b3a7f
    mov eax, dword ptr [ebp - local_1c]          # 004b3a82
    mov ecx, dword ptr [eax + field_26c]         # 004b3a85
    add ecx, dword ptr [0x583186]                # 004b3a8b
    mov dword ptr [ebp - local_c], ecx           # 004b3a91
    movsx edx, word ptr [0x6219d2]               # 004b3a94
    mov eax, dword ptr [ebp - local_1c]          # 004b3a9b
    movsx ecx, word ptr [eax + field_1aa]        # 004b3a9e
    sub ecx, 0x1                                 # 004b3aa5
    {load} cmp edx, ecx                          # 004b3aa8
    jne.d8 L_004b3aeb                            # 004b3aaa
    # block 0x004b3aac: entered by fall-through of jne at 0x004b3aaa, 4 instruction(s), ends with je to 0x004b3aeb (forward)
    {load} xor edx, edx                          # 004b3aac
    mov dl, byte ptr [0x6219d4]                  # 004b3aae
    test edx, edx                                # 004b3ab4
    je.d8 L_004b3aeb                             # 004b3ab6
    # block 0x004b3ab8: entered by fall-through of je at 0x004b3ab6, 14 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004b3b36
    push 0x551894                                # 004b3ab8
    lea eax, [ebp - local_14]                    # 004b3abd
    push eax                                     # 004b3ac0
    mov ecx, dword ptr [ebp - local_1c]          # 004b3ac1
    add ecx, 0x264                               # 004b3ac4
    push ecx                                     # 004b3aca
    mov edx, dword ptr [0x5cf665]                # 004b3acb
    push edx                                     # 004b3ad1
    mov eax, dword ptr [0x5d15e3]                # 004b3ad2
    push eax                                     # 004b3ad7
    mov ecx, 0x5cf659                            # 004b3ad8
    call FUN_004c5377                            # 004b3add
    mov byte ptr [0x6219d4], 0x0                 # 004b3ae2
    jmp.d8 L_004b3b36                            # 004b3ae9
L_004b3aeb:
    # block 0x004b3aeb: entered by jne at 0x004b3aaa; je at 0x004b3ab6, 4 instruction(s), ends with je to 0x004b3b36 (forward)
    {load} xor ecx, ecx                          # 004b3aeb
    mov cl, byte ptr [0x6219d5]                  # 004b3aed
    test ecx, ecx                                # 004b3af3
    je.d8 L_004b3b36                             # 004b3af5
    # block 0x004b3af7: entered by fall-through of je at 0x004b3af5, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004b3b36
    push 0x5518b0                                # 004b3af7
    lea edx, [ebp - local_14]                    # 004b3afc
    push edx                                     # 004b3aff
    movsx eax, word ptr [0x6219d2]               # 004b3b00
    shl eax, 0x4                                 # 004b3b07
    mov ecx, dword ptr [ebp - local_1c]          # 004b3b0a
    lea edx, [ecx + eax + field_1b0]             # 004b3b0d
    push edx                                     # 004b3b14
    mov eax, dword ptr [0x5cf665]                # 004b3b15
    push eax                                     # 004b3b1a
    movsx ecx, word ptr [0x6204dd]               # 004b3b1b
    imul ecx, ecx, 0x4a                          # 004b3b22
    mov edx, dword ptr [ecx + 0x5d1599]          # 004b3b25
    push edx                                     # 004b3b2b
    mov ecx, 0x5cf659                            # 004b3b2c
    call FUN_004c5377                            # 004b3b31
L_004b3b36:
    # block 0x004b3b36: entered by jmp at 0x004b38ac; jle at 0x004b3a46; jmp at 0x004b3ae9; je at 0x004b3af5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b3b36
    pop ebp                                      # 004b3b38
    ret                                          # 004b3b39

# --- data items (not part of the function) -------------------------
.org 0x004b3b3a - 0x401000
PAD_004b3b3a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

