# FUN_004516c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004516c7
# extent:       0x004516c7-0x004523b5 (3310 code bytes)
# span:         0x004516c7-0x004523b5 (code 3310, tables 0, padding 0)
# sha256:       08f92f9ecb208d15e44ce76df865fa47c6abbc0ba2a3a267bc92260e17de93e7
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004516c7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_4, field_8, field_c, field_18, field_28, field_30, field_3c, field_40, field_44, field_58, field_94, field_a4 and 37 more; [ecx + n] field_4, field_8, field_c, field_14, field_20, field_24, field_28, field_2c, field_34, field_44, field_4c, field_58 and 39 more; [edx + n] field_4, field_8, field_c, field_10, field_1c, field_24, field_38, field_3c, field_40, field_48, field_50, field_58 and 35 more; [esi + n] field_2b0
# callees:      calls FUN_004524a8, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_0044fa8e, FUN_0050cd50, FUN_004c2a8d, FUN_004c51a5, FUN_004547bc, FUN_004523b5, FUN_004c5b3a, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 823 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
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
.equ field_58, 0x58  # offset +0x58
.equ field_8c, 0x8c  # offset +0x8c
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c4, 0xc4  # offset +0xc4
.equ field_c8, 0xc8  # offset +0xc8
.equ field_cc, 0xcc  # offset +0xcc
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d4, 0xd4  # offset +0xd4
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_118, 0x118  # offset +0x118
.equ field_11c, 0x11c  # offset +0x11c
.equ field_120, 0x120  # offset +0x120
.equ field_124, 0x124  # offset +0x124
.equ field_148, 0x148  # offset +0x148
.equ field_14c, 0x14c  # offset +0x14c
.equ field_160, 0x160  # offset +0x160
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_174, 0x174  # offset +0x174
.equ field_180, 0x180  # offset +0x180
.equ field_254, 0x254  # offset +0x254
.equ field_26c, 0x26c  # offset +0x26c
.equ field_298, 0x298  # offset +0x298
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2b0, 0x2b0  # offset +0x2b0
.equ field_2dc, 0x2dc  # offset +0x2dc
.equ field_2e0, 0x2e0  # offset +0x2e0
.equ field_301, 0x301  # offset +0x301
.equ field_31c, 0x31c  # offset +0x31c
.equ field_320, 0x320  # offset +0x320
.equ field_324, 0x324  # offset +0x324
.equ field_328, 0x328  # offset +0x328
.equ field_32c, 0x32c  # offset +0x32c
.equ field_330, 0x330  # offset +0x330
.equ field_334, 0x334  # offset +0x334
.equ field_338, 0x338  # offset +0x338
.equ field_33c, 0x33c  # offset +0x33c
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_348, 0x348  # offset +0x348
.equ field_34c, 0x34c  # offset +0x34c
.equ field_350, 0x350  # offset +0x350
.equ field_354, 0x354  # offset +0x354
.equ field_358, 0x358  # offset +0x358
.equ field_50c, 0x50c  # offset +0x50c
.equ field_510, 0x510  # offset +0x510
.equ field_54c, 0x54c  # offset +0x54c
.equ field_6d3, 0x6d3  # offset +0x6d3
.equ field_6d7, 0x6d7  # offset +0x6d7
.equ field_6db, 0x6db  # offset +0x6db
.equ field_6df, 0x6df  # offset +0x6df

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044fa8e, .text + (0x0044fa8e - 0x401000)
.set FUN_004523b5, .text + (0x004523b5 - 0x401000)
.set FUN_004524a8, .text + (0x004524a8 - 0x401000)
.set FUN_004547bc, .text + (0x004547bc - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c5b3a, .text + (0x004c5b3a - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004516c7 - 0x401000
.globl FUN_004516c7
FUN_004516c7:
    # block 0x004516c7: entry, 12 instruction(s), calls FUN_004524a8, ends with jne to 0x00451736 (forward)
    push ebp                                     # 004516c7
    {load} mov ebp, esp                          # 004516c8
    sub esp, 0x2c                                # 004516ca
    push esi                                     # 004516cd
    mov dword ptr [ebp - local_2c], ecx          # 004516ce
    mov ecx, dword ptr [ebp - local_2c]          # 004516d1
    call FUN_004524a8                            # 004516d4
    mov ecx, dword ptr [ebp - local_2c]          # 004516d9
    mov dword ptr [ecx + field_b0], eax          # 004516dc
    mov edx, dword ptr [ebp - local_2c]          # 004516e2
    cmp dword ptr [edx + field_b0], -0x1         # 004516e5
    jne.d8 L_00451736                            # 004516ec
    # block 0x004516ee: entered by fall-through of jne at 0x004516ec, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x00451727 (forward)
    push 0x549998                                # 004516ee
    push 0x63888b                                # 004516f3
    call FUN_0050ca3e                            # 004516f8
    add esp, 0x8                                 # 004516fd
    push 0x63888b                                # 00451700
    mov ecx, 0x583979                            # 00451705
    call FUN_004264e8                            # 0045170a
    movsx eax, word ptr [0x63a4cd]               # 0045170f
    test eax, eax                                # 00451716
    je.d8 L_00451727                             # 00451718
    # block 0x0045171a: entered by fall-through of je at 0x00451718, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00451727
    push 0x63888b                                # 0045171a
    call FUN_0044a2b7                            # 0045171f
    add esp, 0x4                                 # 00451724
L_00451727:
    # block 0x00451727: entered by je at 0x00451718, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004523b0
    mov ecx, 0x5cf659                            # 00451727
    call FUN_004c97b4                            # 0045172c
    jmp.d32 L_004523b0                           # 00451731
L_00451736:
    # block 0x00451736: entered by jne at 0x004516ec, 72 instruction(s), calls FUN_0044fa8e, ends with je to 0x004518d4 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 00451736
    call FUN_0044fa8e                            # 00451739
    mov ecx, dword ptr [ebp - local_2c]          # 0045173e
    mov eax, dword ptr [ecx + field_8c]          # 00451741
    cdq                                          # 00451747
    {load} sub eax, edx                          # 00451748
    sar eax                                      # 0045174a
    mov edx, dword ptr [ebp - local_2c]          # 0045174c
    mov ecx, dword ptr [edx + field_3c]          # 0045174f
    {load} add ecx, eax                          # 00451752
    mov edx, dword ptr [ebp - local_2c]          # 00451754
    mov eax, dword ptr [edx + field_94]          # 00451757
    cdq                                          # 0045175d
    {load} sub eax, edx                          # 0045175e
    sar eax                                      # 00451760
    {load} sub ecx, eax                          # 00451762
    mov eax, dword ptr [ebp - local_2c]          # 00451764
    mov dword ptr [eax + field_c8], ecx          # 00451767
    mov ecx, dword ptr [ebp - local_2c]          # 0045176d
    mov edx, dword ptr [ecx + field_c8]          # 00451770
    mov eax, dword ptr [ebp - local_2c]          # 00451776
    mov ecx, dword ptr [eax + field_94]          # 00451779
    lea edx, [edx + ecx - field_minus_1]         # 0045177f
    mov eax, dword ptr [ebp - local_2c]          # 00451783
    mov dword ptr [eax + field_d0], edx          # 00451786
    mov ecx, dword ptr [ebp - local_2c]          # 0045178c
    mov edx, dword ptr [ebp - local_2c]          # 0045178f
    mov eax, dword ptr [edx + field_a0]          # 00451792
    mov dword ptr [ecx + field_d4], eax          # 00451798
    mov ecx, dword ptr [ebp - local_2c]          # 0045179e
    mov edx, dword ptr [ebp - local_2c]          # 004517a1
    mov eax, dword ptr [ecx + field_d4]          # 004517a4
    sub eax, dword ptr [edx + field_98]          # 004517aa
    add eax, 0x1                                 # 004517b0
    mov ecx, dword ptr [ebp - local_2c]          # 004517b3
    mov dword ptr [ecx + field_cc], eax          # 004517b6
    mov edx, dword ptr [ebp - local_2c]          # 004517bc
    add edx, 0xc8                                # 004517bf
    mov eax, dword ptr [ebp - local_2c]          # 004517c5
    add eax, 0xd8                                # 004517c8
    mov ecx, dword ptr [edx]                     # 004517cd
    mov dword ptr [eax], ecx                     # 004517cf
    mov ecx, dword ptr [edx + field_4]           # 004517d1
    mov dword ptr [eax + field_4], ecx           # 004517d4
    mov ecx, dword ptr [edx + field_8]           # 004517d7
    mov dword ptr [eax + field_8], ecx           # 004517da
    mov edx, dword ptr [edx + field_c]           # 004517dd
    mov dword ptr [eax + field_c], edx           # 004517e0
    mov eax, dword ptr [ebp - local_2c]          # 004517e3
    mov dword ptr [eax + field_c0], 0x0          # 004517e6
    mov ecx, dword ptr [ebp - local_2c]          # 004517f0
    fild dword ptr [ecx + field_c8]              # 004517f3
    mov edx, dword ptr [ebp - local_2c]          # 004517f9
    fstp dword ptr [edx + field_50c]             # 004517fc
    mov eax, dword ptr [ebp - local_2c]          # 00451802
    mov ecx, dword ptr [eax + field_8]           # 00451805
    add ecx, 0x85                                # 00451808
    mov edx, dword ptr [ebp - local_2c]          # 0045180e
    add edx, 0x108                               # 00451811
    mov eax, dword ptr [ecx]                     # 00451817
    mov dword ptr [edx], eax                     # 00451819
    mov eax, dword ptr [ecx + field_4]           # 0045181b
    mov dword ptr [edx + field_4], eax           # 0045181e
    mov eax, dword ptr [ecx + field_8]           # 00451821
    mov dword ptr [edx + field_8], eax           # 00451824
    mov ecx, dword ptr [ecx + field_c]           # 00451827
    mov dword ptr [edx + field_c], ecx           # 0045182a
    mov edx, dword ptr [ebp - local_2c]          # 0045182d
    mov eax, dword ptr [edx + field_8]           # 00451830
    movsx ecx, byte ptr [eax + field_301]        # 00451833
    test ecx, ecx                                # 0045183a
    je.d32 L_004518d4                            # 0045183c
    # block 0x00451842: entered by fall-through of je at 0x0045183c, 34 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x00451967
    call FUN_0050cd50                            # 00451842
    mov edx, dword ptr [ebp - local_2c]          # 00451847
    mov ecx, dword ptr [ebp - local_2c]          # 0045184a
    mov esi, dword ptr [edx + field_94]          # 0045184d
    sub esi, dword ptr [ecx + field_164]         # 00451853
    cdq                                          # 00451859
    idiv esi                                     # 0045185a
    mov eax, dword ptr [ebp - local_2c]          # 0045185c
    mov dword ptr [eax + field_174], edx         # 0045185f
    mov ecx, dword ptr [ebp - local_2c]          # 00451865
    mov edx, dword ptr [ecx + field_c8]          # 00451868
    mov eax, dword ptr [ebp - local_2c]          # 0045186e
    add edx, dword ptr [eax + field_174]         # 00451871
    mov ecx, dword ptr [ebp - local_2c]          # 00451877
    mov dword ptr [ecx + field_118], edx         # 0045187a
    mov edx, dword ptr [ebp - local_2c]          # 00451880
    mov eax, dword ptr [edx + field_118]         # 00451883
    mov ecx, dword ptr [ebp - local_2c]          # 00451889
    mov edx, dword ptr [ecx + field_164]         # 0045188c
    lea eax, [eax + edx - field_minus_1]         # 00451892
    mov ecx, dword ptr [ebp - local_2c]          # 00451896
    mov dword ptr [ecx + field_120], eax         # 00451899
    mov edx, dword ptr [ebp - local_2c]          # 0045189f
    mov eax, dword ptr [ebp - local_2c]          # 004518a2
    mov ecx, dword ptr [eax + field_cc]          # 004518a5
    mov dword ptr [edx + field_124], ecx         # 004518ab
    mov edx, dword ptr [ebp - local_2c]          # 004518b1
    mov eax, dword ptr [ebp - local_2c]          # 004518b4
    mov ecx, dword ptr [edx + field_124]         # 004518b7
    sub ecx, dword ptr [eax + field_168]         # 004518bd
    add ecx, 0x1                                 # 004518c3
    mov edx, dword ptr [ebp - local_2c]          # 004518c6
    mov dword ptr [edx + field_11c], ecx         # 004518c9
    jmp.d32 L_00451967                           # 004518cf
L_004518d4:
    # block 0x004518d4: entered by je at 0x0045183c, 38 instruction(s), falls into the block at 0x00451967
    mov eax, dword ptr [ebp - local_2c]          # 004518d4
    mov eax, dword ptr [eax + field_94]          # 004518d7
    cdq                                          # 004518dd
    {load} sub eax, edx                          # 004518de
    {load} mov ecx, eax                          # 004518e0
    sar ecx                                      # 004518e2
    mov edx, dword ptr [ebp - local_2c]          # 004518e4
    mov eax, dword ptr [edx + field_164]         # 004518e7
    cdq                                          # 004518ed
    {load} sub eax, edx                          # 004518ee
    sar eax                                      # 004518f0
    {load} sub ecx, eax                          # 004518f2
    mov eax, dword ptr [ebp - local_2c]          # 004518f4
    mov dword ptr [eax + field_174], ecx         # 004518f7
    mov ecx, dword ptr [ebp - local_2c]          # 004518fd
    mov edx, dword ptr [ecx + field_c8]          # 00451900
    mov eax, dword ptr [ebp - local_2c]          # 00451906
    add edx, dword ptr [eax + field_174]         # 00451909
    mov ecx, dword ptr [ebp - local_2c]          # 0045190f
    mov dword ptr [ecx + field_118], edx         # 00451912
    mov edx, dword ptr [ebp - local_2c]          # 00451918
    mov eax, dword ptr [edx + field_118]         # 0045191b
    mov ecx, dword ptr [ebp - local_2c]          # 00451921
    mov edx, dword ptr [ecx + field_164]         # 00451924
    lea eax, [eax + edx - field_minus_1]         # 0045192a
    mov ecx, dword ptr [ebp - local_2c]          # 0045192e
    mov dword ptr [ecx + field_120], eax         # 00451931
    mov edx, dword ptr [ebp - local_2c]          # 00451937
    mov eax, dword ptr [ebp - local_2c]          # 0045193a
    mov ecx, dword ptr [eax + field_cc]          # 0045193d
    mov dword ptr [edx + field_124], ecx         # 00451943
    mov edx, dword ptr [ebp - local_2c]          # 00451949
    mov eax, dword ptr [ebp - local_2c]          # 0045194c
    mov ecx, dword ptr [edx + field_124]         # 0045194f
    sub ecx, dword ptr [eax + field_168]         # 00451955
    add ecx, 0x1                                 # 0045195b
    mov edx, dword ptr [ebp - local_2c]          # 0045195e
    mov dword ptr [edx + field_11c], ecx         # 00451961
L_00451967:
    # block 0x00451967: entered by jmp at 0x004518cf, 75 instruction(s), ends with jg to 0x00451ae2 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 00451967
    mov ecx, dword ptr [eax + field_118]         # 0045196a
    mov edx, dword ptr [ebp - local_2c]          # 00451970
    add ecx, dword ptr [edx + field_16c]         # 00451973
    mov eax, dword ptr [ebp - local_2c]          # 00451979
    mov dword ptr [eax + field_148], ecx         # 0045197c
    mov ecx, dword ptr [ebp - local_2c]          # 00451982
    mov edx, dword ptr [ecx + field_11c]         # 00451985
    mov eax, dword ptr [ebp - local_2c]          # 0045198b
    add edx, dword ptr [eax + field_170]         # 0045198e
    mov ecx, dword ptr [ebp - local_2c]          # 00451994
    mov dword ptr [ecx + field_14c], edx         # 00451997
    mov edx, dword ptr [ebp - local_2c]          # 0045199d
    fild dword ptr [edx + field_118]             # 004519a0
    mov eax, dword ptr [ebp - local_2c]          # 004519a6
    fstp dword ptr [eax + field_100]             # 004519a9
    mov ecx, dword ptr [ebp - local_2c]          # 004519af
    fild dword ptr [ecx + field_11c]             # 004519b2
    mov edx, dword ptr [ebp - local_2c]          # 004519b8
    fstp dword ptr [edx + field_104]             # 004519bb
    mov eax, dword ptr [ebp - local_2c]          # 004519c1
    add eax, 0x118                               # 004519c4
    mov ecx, dword ptr [ebp - local_2c]          # 004519c9
    add ecx, 0x150                               # 004519cc
    mov edx, dword ptr [eax]                     # 004519d2
    mov dword ptr [ecx], edx                     # 004519d4
    mov edx, dword ptr [eax + field_4]           # 004519d6
    mov dword ptr [ecx + field_4], edx           # 004519d9
    mov edx, dword ptr [eax + field_8]           # 004519dc
    mov dword ptr [ecx + field_8], edx           # 004519df
    mov eax, dword ptr [eax + field_c]           # 004519e2
    mov dword ptr [ecx + field_c], eax           # 004519e5
    mov ecx, dword ptr [ebp - local_2c]          # 004519e8
    mov dword ptr [ecx + field_180], 0x0         # 004519eb
    mov edx, dword ptr [ebp - local_2c]          # 004519f5
    mov dword ptr [edx + field_160], 0x0         # 004519f8
    mov eax, dword ptr [ebp - local_2c]          # 00451a02
    mov ecx, dword ptr [eax + field_b0]          # 00451a05
    mov edx, dword ptr [ebp - local_2c]          # 00451a0b
    mov eax, dword ptr [ebp - local_2c]          # 00451a0e
    mov edx, dword ptr [edx + field_a4]          # 00451a11
    imul edx, dword ptr [eax + 8*ecx + field_2ac] # 00451a17
    mov eax, dword ptr [ebp - local_2c]          # 00451a1f
    mov dword ptr [eax + field_b8], edx          # 00451a22
    mov ecx, dword ptr [ebp - local_2c]          # 00451a28
    mov edx, dword ptr [ecx + field_b0]          # 00451a2b
    mov eax, dword ptr [ebp - local_2c]          # 00451a31
    mov ecx, dword ptr [ebp - local_2c]          # 00451a34
    mov eax, dword ptr [eax + field_a8]          # 00451a37
    imul eax, dword ptr [ecx + 8*edx + field_2b0] # 00451a3d
    mov ecx, dword ptr [ebp - local_2c]          # 00451a45
    mov dword ptr [ecx + field_bc], eax          # 00451a48
    mov edx, dword ptr [ebp - local_2c]          # 00451a4e
    mov eax, dword ptr [edx + field_b0]          # 00451a51
    mov ecx, dword ptr [ebp - local_2c]          # 00451a57
    mov edx, dword ptr [ecx + field_b0]          # 00451a5a
    mov ecx, dword ptr [ebp - local_2c]          # 00451a60
    mov esi, dword ptr [ebp - local_2c]          # 00451a63
    mov eax, dword ptr [ecx + 8*eax + field_2ac] # 00451a66
    imul eax, dword ptr [esi + 8*edx + field_2b0] # 00451a6d
    mov ecx, dword ptr [ebp - local_2c]          # 00451a75
    mov dword ptr [ecx + field_ac], eax          # 00451a78
    mov edx, dword ptr [ebp - local_2c]          # 00451a7e
    mov eax, dword ptr [edx + field_3c]          # 00451a81
    mov ecx, dword ptr [ebp - local_2c]          # 00451a84
    add eax, dword ptr [ecx + field_b8]          # 00451a87
    mov edx, dword ptr [ebp - local_2c]          # 00451a8d
    mov ecx, dword ptr [edx + field_b0]          # 00451a90
    mov edx, dword ptr [ebp - local_2c]          # 00451a96
    add eax, dword ptr [edx + 8*ecx + field_2dc] # 00451a99
    mov ecx, dword ptr [ebp - local_2c]          # 00451aa0
    mov edx, dword ptr [ecx + field_354]         # 00451aa3
    add edx, 0x1                                 # 00451aa9
    {load} cmp eax, edx                          # 00451aac
    jg.d8 L_00451ae2                             # 00451aae
    # block 0x00451ab0: entered by fall-through of jg at 0x00451aae, 13 instruction(s), ends with jle to 0x00451b3e (forward)
    mov eax, dword ptr [ebp - local_2c]          # 00451ab0
    mov ecx, dword ptr [eax + field_40]          # 00451ab3
    mov edx, dword ptr [ebp - local_2c]          # 00451ab6
    add ecx, dword ptr [edx + field_bc]          # 00451ab9
    mov eax, dword ptr [ebp - local_2c]          # 00451abf
    mov edx, dword ptr [eax + field_b0]          # 00451ac2
    mov eax, dword ptr [ebp - local_2c]          # 00451ac8
    add ecx, dword ptr [eax + 8*edx + field_2e0] # 00451acb
    mov edx, dword ptr [ebp - local_2c]          # 00451ad2
    mov eax, dword ptr [edx + field_358]         # 00451ad5
    add eax, 0x1                                 # 00451adb
    {load} cmp ecx, eax                          # 00451ade
    jle.d8 L_00451b3e                            # 00451ae0
L_00451ae2:
    # block 0x00451ae2: entered by jg at 0x00451aae; fall-through of jle at 0x00451ae0, 16 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x00451b2f (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 00451ae2
    mov edx, dword ptr [ecx + field_bc]          # 00451ae5
    push edx                                     # 00451aeb
    mov eax, dword ptr [ebp - local_2c]          # 00451aec
    mov ecx, dword ptr [eax + field_b8]          # 00451aef
    push ecx                                     # 00451af5
    push 0x549a18                                # 00451af6
    push 0x63888b                                # 00451afb
    call FUN_0050ca3e                            # 00451b00
    add esp, 0x10                                # 00451b05
    push 0x63888b                                # 00451b08
    mov ecx, 0x583979                            # 00451b0d
    call FUN_004264e8                            # 00451b12
    movsx edx, word ptr [0x63a4cd]               # 00451b17
    test edx, edx                                # 00451b1e
    je.d8 L_00451b2f                             # 00451b20
    # block 0x00451b22: entered by fall-through of je at 0x00451b20, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00451b2f
    push 0x63888b                                # 00451b22
    call FUN_0044a2b7                            # 00451b27
    add esp, 0x4                                 # 00451b2c
L_00451b2f:
    # block 0x00451b2f: entered by je at 0x00451b20, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004523b0
    mov ecx, 0x5cf659                            # 00451b2f
    call FUN_004c97b4                            # 00451b34
    jmp.d32 L_004523b0                           # 00451b39
L_00451b3e:
    # block 0x00451b3e: entered by jle at 0x00451ae0, 109 instruction(s), calls FUN_004c2a8d, FUN_004c51a5, FUN_004547bc, FUN_004523b5, ends with forward jump to 0x00451d12
    push 0x549a84                                # 00451b3e
    push 0x6                                     # 00451b43
    mov eax, dword ptr [ebp - local_2c]          # 00451b45
    mov cx, word ptr [eax + field_bc]            # 00451b48
    push ecx                                     # 00451b4f
    mov edx, dword ptr [ebp - local_2c]          # 00451b50
    mov ax, word ptr [edx + field_b8]            # 00451b53
    push eax                                     # 00451b5a
    mov ecx, 0x5cf659                            # 00451b5b
    call FUN_004c2a8d                            # 00451b60
    mov ecx, dword ptr [ebp - local_2c]          # 00451b65
    mov dword ptr [ecx + field_2a4], eax         # 00451b68
    mov edx, dword ptr [ebp - local_2c]          # 00451b6e
    mov eax, dword ptr [edx + field_2a4]         # 00451b71
    add eax, 0x35                                # 00451b77
    mov ecx, dword ptr [ebp - local_2c]          # 00451b7a
    add ecx, 0x30c                               # 00451b7d
    mov edx, dword ptr [eax]                     # 00451b83
    mov dword ptr [ecx], edx                     # 00451b85
    mov edx, dword ptr [eax + field_4]           # 00451b87
    mov dword ptr [ecx + field_4], edx           # 00451b8a
    mov edx, dword ptr [eax + field_8]           # 00451b8d
    mov dword ptr [ecx + field_8], edx           # 00451b90
    mov eax, dword ptr [eax + field_c]           # 00451b93
    mov dword ptr [ecx + field_c], eax           # 00451b96
    mov ecx, dword ptr [ebp - local_2c]          # 00451b99
    mov edx, dword ptr [ecx + field_b0]          # 00451b9c
    mov eax, dword ptr [ebp - local_2c]          # 00451ba2
    mov ecx, dword ptr [eax + field_3c]          # 00451ba5
    mov eax, dword ptr [ebp - local_2c]          # 00451ba8
    add ecx, dword ptr [eax + 8*edx + field_2dc] # 00451bab
    mov edx, dword ptr [ebp - local_2c]          # 00451bb2
    mov dword ptr [edx + field_31c], ecx         # 00451bb5
    mov eax, dword ptr [ebp - local_2c]          # 00451bbb
    mov ecx, dword ptr [eax + field_b0]          # 00451bbe
    mov edx, dword ptr [ebp - local_2c]          # 00451bc4
    mov eax, dword ptr [edx + field_40]          # 00451bc7
    mov edx, dword ptr [ebp - local_2c]          # 00451bca
    add eax, dword ptr [edx + 8*ecx + field_2e0] # 00451bcd
    mov ecx, dword ptr [ebp - local_2c]          # 00451bd4
    mov dword ptr [ecx + field_320], eax         # 00451bd7
    mov edx, dword ptr [ebp - local_2c]          # 00451bdd
    mov eax, dword ptr [edx + field_31c]         # 00451be0
    mov ecx, dword ptr [ebp - local_2c]          # 00451be6
    mov edx, dword ptr [ecx + field_b8]          # 00451be9
    lea eax, [eax + edx - field_minus_1]         # 00451bef
    mov ecx, dword ptr [ebp - local_2c]          # 00451bf3
    mov dword ptr [ecx + field_324], eax         # 00451bf6
    mov edx, dword ptr [ebp - local_2c]          # 00451bfc
    mov eax, dword ptr [edx + field_320]         # 00451bff
    mov ecx, dword ptr [ebp - local_2c]          # 00451c05
    mov edx, dword ptr [ecx + field_bc]          # 00451c08
    lea eax, [eax + edx - field_minus_1]         # 00451c0e
    mov ecx, dword ptr [ebp - local_2c]          # 00451c12
    mov dword ptr [ecx + field_328], eax         # 00451c15
    mov edx, dword ptr [ebp - local_2c]          # 00451c1b
    mov eax, dword ptr [ebp - local_2c]          # 00451c1e
    mov ecx, dword ptr [edx + field_31c]         # 00451c21
    sub ecx, dword ptr [eax + field_34c]         # 00451c27
    mov edx, dword ptr [ebp - local_2c]          # 00451c2d
    mov dword ptr [edx + field_32c], ecx         # 00451c30
    mov eax, dword ptr [ebp - local_2c]          # 00451c36
    mov ecx, dword ptr [ebp - local_2c]          # 00451c39
    mov edx, dword ptr [eax + field_320]         # 00451c3c
    sub edx, dword ptr [ecx + field_350]         # 00451c42
    mov eax, dword ptr [ebp - local_2c]          # 00451c48
    mov dword ptr [eax + field_330], edx         # 00451c4b
    mov ecx, dword ptr [ebp - local_2c]          # 00451c51
    mov edx, dword ptr [ecx + field_32c]         # 00451c54
    mov eax, dword ptr [ebp - local_2c]          # 00451c5a
    mov ecx, dword ptr [eax + field_b8]          # 00451c5d
    lea edx, [edx + ecx - field_minus_1]         # 00451c63
    mov eax, dword ptr [ebp - local_2c]          # 00451c67
    mov dword ptr [eax + field_334], edx         # 00451c6a
    mov ecx, dword ptr [ebp - local_2c]          # 00451c70
    mov edx, dword ptr [ecx + field_330]         # 00451c73
    mov eax, dword ptr [ebp - local_2c]          # 00451c79
    mov ecx, dword ptr [eax + field_bc]          # 00451c7c
    lea edx, [edx + ecx - field_minus_1]         # 00451c82
    mov eax, dword ptr [ebp - local_2c]          # 00451c86
    mov dword ptr [eax + field_338], edx         # 00451c89
    push 0x549aa8                                # 00451c8f
    mov ecx, dword ptr [ebp - local_2c]          # 00451c94
    add ecx, 0x30c                               # 00451c97
    push ecx                                     # 00451c9d
    mov edx, dword ptr [ebp - local_2c]          # 00451c9e
    add edx, 0x32c                               # 00451ca1
    push edx                                     # 00451ca7
    mov eax, dword ptr [ebp - local_2c]          # 00451ca8
    mov ecx, dword ptr [eax + field_2a4]         # 00451cab
    push ecx                                     # 00451cb1
    mov edx, dword ptr [0x5d15e3]                # 00451cb2
    push edx                                     # 00451cb8
    mov ecx, 0x5cf659                            # 00451cb9
    call FUN_004c51a5                            # 00451cbe
    mov eax, dword ptr [ebp - local_2c]          # 00451cc3
    mov ecx, dword ptr [eax + field_ac]          # 00451cc6
    imul ecx, ecx, 0x5c                          # 00451ccc
    push ecx                                     # 00451ccf
    mov edx, dword ptr [ebp - local_2c]          # 00451cd0
    add edx, 0x2a0                               # 00451cd3
    push edx                                     # 00451cd9
    mov ecx, dword ptr [ebp - local_2c]          # 00451cda
    call FUN_004547bc                            # 00451cdd
    mov ecx, dword ptr [ebp - local_2c]          # 00451ce2
    call FUN_004523b5                            # 00451ce5
    mov dword ptr [ebp - local_14], 0x0          # 00451cea
    mov dword ptr [ebp - local_8], 0x0           # 00451cf1
    jmp.d8 L_00451d12                            # 00451cf8
L_00451cfa:
    # block 0x00451cfa: entered by jmp at 0x00452098, 7 instruction(s), falls into the block at 0x00451d12
    mov eax, dword ptr [ebp - local_14]          # 00451cfa
    add eax, 0x1                                 # 00451cfd
    mov dword ptr [ebp - local_14], eax          # 00451d00
    mov ecx, dword ptr [ebp - local_2c]          # 00451d03
    mov edx, dword ptr [ebp - local_8]           # 00451d06
    add edx, dword ptr [ecx + field_a8]          # 00451d09
    mov dword ptr [ebp - local_8], edx           # 00451d0f
L_00451d12:
    # block 0x00451d12: entered by jmp at 0x00451cf8, 6 instruction(s), ends with jge to 0x0045209d (forward)
    mov eax, dword ptr [ebp - local_2c]          # 00451d12
    mov ecx, dword ptr [eax + field_b0]          # 00451d15
    mov edx, dword ptr [ebp - local_2c]          # 00451d1b
    mov eax, dword ptr [ebp - local_14]          # 00451d1e
    cmp eax, dword ptr [edx + 8*ecx + field_2b0] # 00451d21
    jge.d32 L_0045209d                           # 00451d28
    # block 0x00451d2e: entered by fall-through of jge at 0x00451d28, 3 instruction(s), ends with forward jump to 0x00451d56
    mov dword ptr [ebp - local_10], 0x0          # 00451d2e
    mov dword ptr [ebp - local_4], 0x0           # 00451d35
    jmp.d8 L_00451d56                            # 00451d3c
L_00451d3e:
    # block 0x00451d3e: entered by jmp at 0x00452093, 7 instruction(s), falls into the block at 0x00451d56
    mov ecx, dword ptr [ebp - local_10]          # 00451d3e
    add ecx, 0x1                                 # 00451d41
    mov dword ptr [ebp - local_10], ecx          # 00451d44
    mov edx, dword ptr [ebp - local_2c]          # 00451d47
    mov eax, dword ptr [ebp - local_4]           # 00451d4a
    add eax, dword ptr [edx + field_a4]          # 00451d4d
    mov dword ptr [ebp - local_4], eax           # 00451d53
L_00451d56:
    # block 0x00451d56: entered by jmp at 0x00451d3c, 6 instruction(s), ends with jge to 0x00452098 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 00451d56
    mov edx, dword ptr [ecx + field_b0]          # 00451d59
    mov eax, dword ptr [ebp - local_2c]          # 00451d5f
    mov ecx, dword ptr [ebp - local_10]          # 00451d62
    cmp ecx, dword ptr [eax + 8*edx + field_2ac] # 00451d65
    jge.d32 L_00452098                           # 00451d6c
    # block 0x00451d72: entered by fall-through of jge at 0x00451d6c, 123 instruction(s), ends with je to 0x00451fa0 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 00451d72
    mov eax, dword ptr [edx + field_b0]          # 00451d75
    mov ecx, dword ptr [ebp - local_2c]          # 00451d7b
    mov edx, dword ptr [ebp - local_14]          # 00451d7e
    imul edx, dword ptr [ecx + 8*eax + field_2ac] # 00451d81
    add edx, dword ptr [ebp - local_10]          # 00451d89
    mov dword ptr [ebp - local_18], edx          # 00451d8c
    mov eax, dword ptr [ebp - local_18]          # 00451d8f
    imul eax, eax, 0x5c                          # 00451d92
    mov ecx, dword ptr [ebp - local_2c]          # 00451d95
    mov edx, dword ptr [ecx + field_2a0]         # 00451d98
    mov eax, dword ptr [edx + eax + field_40]    # 00451d9e
    mov dword ptr [ebp - local_c], eax           # 00451da2
    mov ecx, dword ptr [ebp - local_8]           # 00451da5
    mov dword ptr [ebp - local_24], ecx          # 00451da8
    mov edx, dword ptr [ebp - local_2c]          # 00451dab
    mov eax, dword ptr [edx + field_a8]          # 00451dae
    mov ecx, dword ptr [ebp - local_24]          # 00451db4
    lea edx, [ecx + eax - field_minus_1]         # 00451db7
    mov dword ptr [ebp - local_1c], edx          # 00451dbb
    mov eax, dword ptr [ebp - local_4]           # 00451dbe
    mov dword ptr [ebp - local_28], eax          # 00451dc1
    mov ecx, dword ptr [ebp - local_2c]          # 00451dc4
    mov edx, dword ptr [ecx + field_a4]          # 00451dc7
    mov eax, dword ptr [ebp - local_28]          # 00451dcd
    lea ecx, [eax + edx - field_minus_1]         # 00451dd0
    mov dword ptr [ebp - local_20], ecx          # 00451dd4
    mov edx, dword ptr [ebp - local_2c]          # 00451dd7
    mov eax, dword ptr [ebp - local_28]          # 00451dda
    add eax, dword ptr [edx + field_31c]         # 00451ddd
    mov ecx, dword ptr [ebp - local_2c]          # 00451de3
    sub eax, dword ptr [ecx + field_34c]         # 00451de6
    mov edx, dword ptr [ebp - local_18]          # 00451dec
    imul edx, edx, 0x5c                          # 00451def
    mov ecx, dword ptr [ebp - local_2c]          # 00451df2
    mov ecx, dword ptr [ecx + field_2a0]         # 00451df5
    mov dword ptr [ecx + edx + field_20], eax    # 00451dfb
    mov edx, dword ptr [ebp - local_18]          # 00451dff
    imul edx, edx, 0x5c                          # 00451e02
    mov eax, dword ptr [ebp - local_2c]          # 00451e05
    mov ecx, dword ptr [eax + field_2a0]         # 00451e08
    mov edx, dword ptr [ecx + edx + field_20]    # 00451e0e
    mov eax, dword ptr [ebp - local_2c]          # 00451e12
    mov ecx, dword ptr [eax + field_a4]          # 00451e15
    lea edx, [edx + ecx - field_minus_1]         # 00451e1b
    mov eax, dword ptr [ebp - local_18]          # 00451e1f
    imul eax, eax, 0x5c                          # 00451e22
    mov ecx, dword ptr [ebp - local_2c]          # 00451e25
    mov ecx, dword ptr [ecx + field_2a0]         # 00451e28
    mov dword ptr [ecx + eax + field_28], edx    # 00451e2e
    mov edx, dword ptr [ebp - local_2c]          # 00451e32
    mov eax, dword ptr [ebp - local_24]          # 00451e35
    add eax, dword ptr [edx + field_320]         # 00451e38
    mov ecx, dword ptr [ebp - local_2c]          # 00451e3e
    sub eax, dword ptr [ecx + field_350]         # 00451e41
    mov edx, dword ptr [ebp - local_18]          # 00451e47
    imul edx, edx, 0x5c                          # 00451e4a
    mov ecx, dword ptr [ebp - local_2c]          # 00451e4d
    mov ecx, dword ptr [ecx + field_2a0]         # 00451e50
    mov dword ptr [ecx + edx + field_24], eax    # 00451e56
    mov edx, dword ptr [ebp - local_18]          # 00451e5a
    imul edx, edx, 0x5c                          # 00451e5d
    mov eax, dword ptr [ebp - local_2c]          # 00451e60
    mov ecx, dword ptr [eax + field_2a0]         # 00451e63
    mov edx, dword ptr [ecx + edx + field_24]    # 00451e69
    mov eax, dword ptr [ebp - local_2c]          # 00451e6d
    mov ecx, dword ptr [eax + field_a8]          # 00451e70
    lea edx, [edx + ecx - field_minus_1]         # 00451e76
    mov eax, dword ptr [ebp - local_18]          # 00451e7a
    imul eax, eax, 0x5c                          # 00451e7d
    mov ecx, dword ptr [ebp - local_2c]          # 00451e80
    mov ecx, dword ptr [ecx + field_2a0]         # 00451e83
    mov dword ptr [ecx + eax + field_2c], edx    # 00451e89
    mov edx, dword ptr [ebp - local_18]          # 00451e8d
    imul edx, edx, 0x5c                          # 00451e90
    mov eax, dword ptr [ebp - local_2c]          # 00451e93
    mov ecx, dword ptr [eax + field_2a0]         # 00451e96
    mov edx, dword ptr [ecx + edx + field_20]    # 00451e9c
    mov eax, dword ptr [ebp - local_2c]          # 00451ea0
    add edx, dword ptr [eax + field_34c]         # 00451ea3
    mov ecx, dword ptr [ebp - local_18]          # 00451ea9
    imul ecx, ecx, 0x5c                          # 00451eac
    mov eax, dword ptr [ebp - local_2c]          # 00451eaf
    mov eax, dword ptr [eax + field_2a0]         # 00451eb2
    mov dword ptr [eax + ecx + field_30], edx    # 00451eb8
    mov ecx, dword ptr [ebp - local_18]          # 00451ebc
    imul ecx, ecx, 0x5c                          # 00451ebf
    mov edx, dword ptr [ebp - local_2c]          # 00451ec2
    mov eax, dword ptr [edx + field_2a0]         # 00451ec5
    mov ecx, dword ptr [eax + ecx + field_28]    # 00451ecb
    mov edx, dword ptr [ebp - local_2c]          # 00451ecf
    add ecx, dword ptr [edx + field_34c]         # 00451ed2
    mov eax, dword ptr [ebp - local_18]          # 00451ed8
    imul eax, eax, 0x5c                          # 00451edb
    mov edx, dword ptr [ebp - local_2c]          # 00451ede
    mov edx, dword ptr [edx + field_2a0]         # 00451ee1
    mov dword ptr [edx + eax + field_38], ecx    # 00451ee7
    mov eax, dword ptr [ebp - local_18]          # 00451eeb
    imul eax, eax, 0x5c                          # 00451eee
    mov ecx, dword ptr [ebp - local_2c]          # 00451ef1
    mov edx, dword ptr [ecx + field_2a0]         # 00451ef4
    mov eax, dword ptr [edx + eax + field_24]    # 00451efa
    mov ecx, dword ptr [ebp - local_2c]          # 00451efe
    add eax, dword ptr [ecx + field_350]         # 00451f01
    mov edx, dword ptr [ebp - local_18]          # 00451f07
    imul edx, edx, 0x5c                          # 00451f0a
    mov ecx, dword ptr [ebp - local_2c]          # 00451f0d
    mov ecx, dword ptr [ecx + field_2a0]         # 00451f10
    mov dword ptr [ecx + edx + field_34], eax    # 00451f16
    mov edx, dword ptr [ebp - local_18]          # 00451f1a
    imul edx, edx, 0x5c                          # 00451f1d
    mov eax, dword ptr [ebp - local_2c]          # 00451f20
    mov ecx, dword ptr [eax + field_2a0]         # 00451f23
    mov edx, dword ptr [ecx + edx + field_2c]    # 00451f29
    mov eax, dword ptr [ebp - local_2c]          # 00451f2d
    add edx, dword ptr [eax + field_350]         # 00451f30
    mov ecx, dword ptr [ebp - local_18]          # 00451f36
    imul ecx, ecx, 0x5c                          # 00451f39
    mov eax, dword ptr [ebp - local_2c]          # 00451f3c
    mov eax, dword ptr [eax + field_2a0]         # 00451f3f
    mov dword ptr [eax + ecx + field_3c], edx    # 00451f45
    cmp dword ptr [ebp - local_c], -0x1          # 00451f49
    je.d8 L_00451fa0                             # 00451f4d
    # block 0x00451f4f: entered by fall-through of je at 0x00451f4d, 23 instruction(s), calls FUN_004c5b3a, ends with forward jump to 0x00451fef
    mov ecx, dword ptr [ebp - local_18]          # 00451f4f
    imul ecx, ecx, 0x5c                          # 00451f52
    mov edx, dword ptr [ebp - local_2c]          # 00451f55
    mov eax, dword ptr [edx + field_2a0]         # 00451f58
    mov dword ptr [eax + ecx + field_58], 0x1    # 00451f5e
    push 0x549ad4                                # 00451f66
    lea ecx, [ebp - local_28]                    # 00451f6b
    push ecx                                     # 00451f6e
    mov edx, dword ptr [ebp - local_2c]          # 00451f6f
    mov eax, dword ptr [edx + field_8]           # 00451f72
    mov ecx, dword ptr [ebp - local_c]           # 00451f75
    shl ecx, 0x4                                 # 00451f78
    lea edx, [eax + ecx + field_a5]              # 00451f7b
    push edx                                     # 00451f82
    mov eax, dword ptr [ebp - local_2c]          # 00451f83
    mov ecx, dword ptr [eax + field_2a4]         # 00451f86
    push ecx                                     # 00451f8c
    mov edx, dword ptr [ebp - local_2c]          # 00451f8d
    mov eax, dword ptr [edx + field_c]           # 00451f90
    push eax                                     # 00451f93
    mov ecx, 0x5cf659                            # 00451f94
    call FUN_004c5b3a                            # 00451f99
    jmp.d8 L_00451fef                            # 00451f9e
L_00451fa0:
    # block 0x00451fa0: entered by je at 0x00451f4d, 21 instruction(s), calls FUN_004c51a5, falls into the block at 0x00451fef
    mov ecx, dword ptr [ebp - local_18]          # 00451fa0
    imul ecx, ecx, 0x5c                          # 00451fa3
    mov edx, dword ptr [ebp - local_2c]          # 00451fa6
    mov eax, dword ptr [edx + field_2a0]         # 00451fa9
    mov dword ptr [eax + ecx + field_58], 0x0    # 00451faf
    push 0x549afc                                # 00451fb7
    lea ecx, [ebp - local_28]                    # 00451fbc
    push ecx                                     # 00451fbf
    mov edx, dword ptr [ebp - local_18]          # 00451fc0
    imul edx, edx, 0x5c                          # 00451fc3
    mov eax, dword ptr [ebp - local_2c]          # 00451fc6
    mov ecx, dword ptr [eax + field_2a0]         # 00451fc9
    lea edx, [ecx + edx + field_20]              # 00451fcf
    push edx                                     # 00451fd3
    mov eax, dword ptr [ebp - local_2c]          # 00451fd4
    mov ecx, dword ptr [eax + field_2a4]         # 00451fd7
    push ecx                                     # 00451fdd
    mov edx, dword ptr [0x5d15e3]                # 00451fde
    push edx                                     # 00451fe4
    mov ecx, 0x5cf659                            # 00451fe5
    call FUN_004c51a5                            # 00451fea
L_00451fef:
    # block 0x00451fef: entered by jmp at 0x00451f9e, 46 instruction(s), ends with backward jump to 0x00451d3e
    mov eax, dword ptr [ebp - local_18]          # 00451fef
    imul eax, eax, 0x5c                          # 00451ff2
    mov ecx, dword ptr [ebp - local_2c]          # 00451ff5
    mov edx, dword ptr [ecx + field_2a0]         # 00451ff8
    {load} add edx, eax                          # 00451ffe
    mov eax, dword ptr [ebp - local_28]          # 00452000
    mov dword ptr [edx], eax                     # 00452003
    mov ecx, dword ptr [ebp - local_24]          # 00452005
    mov dword ptr [edx + field_4], ecx           # 00452008
    mov eax, dword ptr [ebp - local_20]          # 0045200b
    mov dword ptr [edx + field_8], eax           # 0045200e
    mov ecx, dword ptr [ebp - local_1c]          # 00452011
    mov dword ptr [edx + field_c], ecx           # 00452014
    mov edx, dword ptr [ebp - local_2c]          # 00452017
    mov eax, dword ptr [ebp - local_28]          # 0045201a
    add eax, dword ptr [edx + field_31c]         # 0045201d
    mov ecx, dword ptr [ebp - local_18]          # 00452023
    imul ecx, ecx, 0x5c                          # 00452026
    mov edx, dword ptr [ebp - local_2c]          # 00452029
    mov edx, dword ptr [edx + field_2a0]         # 0045202c
    mov dword ptr [edx + ecx + field_10], eax    # 00452032
    mov eax, dword ptr [ebp - local_2c]          # 00452036
    mov ecx, dword ptr [ebp - local_20]          # 00452039
    add ecx, dword ptr [eax + field_31c]         # 0045203c
    mov edx, dword ptr [ebp - local_18]          # 00452042
    imul edx, edx, 0x5c                          # 00452045
    mov eax, dword ptr [ebp - local_2c]          # 00452048
    mov eax, dword ptr [eax + field_2a0]         # 0045204b
    mov dword ptr [eax + edx + field_18], ecx    # 00452051
    mov ecx, dword ptr [ebp - local_2c]          # 00452055
    mov edx, dword ptr [ebp - local_24]          # 00452058
    add edx, dword ptr [ecx + field_320]         # 0045205b
    mov eax, dword ptr [ebp - local_18]          # 00452061
    imul eax, eax, 0x5c                          # 00452064
    mov ecx, dword ptr [ebp - local_2c]          # 00452067
    mov ecx, dword ptr [ecx + field_2a0]         # 0045206a
    mov dword ptr [ecx + eax + field_14], edx    # 00452070
    mov edx, dword ptr [ebp - local_2c]          # 00452074
    mov eax, dword ptr [ebp - local_1c]          # 00452077
    add eax, dword ptr [edx + field_320]         # 0045207a
    mov ecx, dword ptr [ebp - local_18]          # 00452080
    imul ecx, ecx, 0x5c                          # 00452083
    mov edx, dword ptr [ebp - local_2c]          # 00452086
    mov edx, dword ptr [edx + field_2a0]         # 00452089
    mov dword ptr [edx + ecx + field_1c], eax    # 0045208f
    jmp.d32 L_00451d3e                           # 00452093
L_00452098:
    # block 0x00452098: entered by jge at 0x00451d6c, 1 instruction(s), ends with backward jump to 0x00451cfa
    jmp.d32 L_00451cfa                           # 00452098
L_0045209d:
    # block 0x0045209d: entered by jge at 0x00451d28, 2 instruction(s), ends with forward jump to 0x004520af
    mov dword ptr [ebp - local_14], 0x0          # 0045209d
    jmp.d8 L_004520af                            # 004520a4
L_004520a6:
    # block 0x004520a6: entered by jmp at 0x00452308, 3 instruction(s), falls into the block at 0x004520af
    mov eax, dword ptr [ebp - local_14]          # 004520a6
    add eax, 0x1                                 # 004520a9
    mov dword ptr [ebp - local_14], eax          # 004520ac
L_004520af:
    # block 0x004520af: entered by jmp at 0x004520a4, 6 instruction(s), ends with jge to 0x0045230d (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004520af
    mov edx, dword ptr [ecx + field_b0]          # 004520b2
    mov eax, dword ptr [ebp - local_2c]          # 004520b8
    mov ecx, dword ptr [ebp - local_14]          # 004520bb
    cmp ecx, dword ptr [eax + 8*edx + field_2b0] # 004520be
    jge.d32 L_0045230d                           # 004520c5
    # block 0x004520cb: entered by fall-through of jge at 0x004520c5, 2 instruction(s), ends with forward jump to 0x004520dd
    mov dword ptr [ebp - local_10], 0x0          # 004520cb
    jmp.d8 L_004520dd                            # 004520d2
L_004520d4:
    # block 0x004520d4: entered by jmp at 0x00452180; jmp at 0x00452303, 3 instruction(s), falls into the block at 0x004520dd
    mov edx, dword ptr [ebp - local_10]          # 004520d4
    add edx, 0x1                                 # 004520d7
    mov dword ptr [ebp - local_10], edx          # 004520da
L_004520dd:
    # block 0x004520dd: entered by jmp at 0x004520d2, 6 instruction(s), ends with jge to 0x00452308 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 004520dd
    mov ecx, dword ptr [eax + field_b0]          # 004520e0
    mov edx, dword ptr [ebp - local_2c]          # 004520e6
    mov eax, dword ptr [ebp - local_10]          # 004520e9
    cmp eax, dword ptr [edx + 8*ecx + field_2ac] # 004520ec
    jge.d32 L_00452308                           # 004520f3
    # block 0x004520f9: entered by fall-through of jge at 0x004520f3, 10 instruction(s), ends with forward jump to 0x0045213a
    mov ecx, dword ptr [ebp - local_2c]          # 004520f9
    mov edx, dword ptr [ecx + field_b0]          # 004520fc
    mov eax, dword ptr [ebp - local_2c]          # 00452102
    mov ecx, dword ptr [ebp - local_14]          # 00452105
    imul ecx, dword ptr [eax + 8*edx + field_2ac] # 00452108
    add ecx, dword ptr [ebp - local_10]          # 00452110
    mov dword ptr [ebp - local_18], ecx          # 00452113
    mov edx, dword ptr [ebp - local_2c]          # 00452116
    mov dword ptr [edx + field_510], 0x0         # 00452119
    jmp.d8 L_0045213a                            # 00452123
L_00452125:
    # block 0x00452125: entered by jmp at 0x00452168, 5 instruction(s), falls into the block at 0x0045213a
    mov eax, dword ptr [ebp - local_2c]          # 00452125
    mov ecx, dword ptr [eax + field_510]         # 00452128
    add ecx, 0x1                                 # 0045212e
    mov edx, dword ptr [ebp - local_2c]          # 00452131
    mov dword ptr [edx + field_510], ecx         # 00452134
L_0045213a:
    # block 0x0045213a: entered by jmp at 0x00452123, 3 instruction(s), ends with jge to 0x0045216a (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0045213a
    cmp dword ptr [eax + field_510], 0x4         # 0045213d
    jge.d8 L_0045216a                            # 00452144
    # block 0x00452146: entered by fall-through of jge at 0x00452144, 9 instruction(s), ends with backward jump to 0x00452125
    mov ecx, dword ptr [ebp - local_18]          # 00452146
    imul ecx, ecx, 0x5c                          # 00452149
    mov edx, dword ptr [ebp - local_2c]          # 0045214c
    mov eax, dword ptr [edx + field_2a0]         # 0045214f
    {load} add eax, ecx                          # 00452155
    mov ecx, dword ptr [ebp - local_2c]          # 00452157
    mov edx, dword ptr [ecx + field_510]         # 0045215a
    mov dword ptr [eax + 4*edx + field_44], 0xffffffff # 00452160
    jmp.d8 L_00452125                            # 00452168
L_0045216a:
    # block 0x0045216a: entered by jge at 0x00452144, 6 instruction(s), ends with jne to 0x00452185 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0045216a
    imul eax, eax, 0x5c                          # 0045216d
    mov ecx, dword ptr [ebp - local_2c]          # 00452170
    mov edx, dword ptr [ecx + field_2a0]         # 00452173
    cmp dword ptr [edx + eax + field_58], 0x0    # 00452179
    jne.d8 L_00452185                            # 0045217e
    # block 0x00452180: entered by fall-through of jne at 0x0045217e, 1 instruction(s), ends with backward jump to 0x004520d4
    jmp.d32 L_004520d4                           # 00452180
L_00452185:
    # block 0x00452185: entered by jne at 0x0045217e, 2 instruction(s), ends with je to 0x004521e2 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 00452185
    je.d8 L_004521e2                             # 00452189
    # block 0x0045218b: entered by fall-through of je at 0x00452189, 14 instruction(s), ends with jne to 0x004521e2 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0045218b
    mov ecx, dword ptr [eax + field_b0]          # 0045218e
    mov edx, dword ptr [ebp - local_2c]          # 00452194
    mov eax, dword ptr [ebp - local_18]          # 00452197
    sub eax, dword ptr [edx + 8*ecx + field_2ac] # 0045219a
    mov ecx, dword ptr [ebp - local_2c]          # 004521a1
    mov dword ptr [ecx + field_6d3], eax         # 004521a4
    mov edx, dword ptr [ebp - local_2c]          # 004521aa
    mov eax, dword ptr [edx + field_6d3]         # 004521ad
    imul eax, eax, 0x5c                          # 004521b3
    mov ecx, dword ptr [ebp - local_2c]          # 004521b6
    mov edx, dword ptr [ecx + field_2a0]         # 004521b9
    cmp dword ptr [edx + eax + field_58], 0x1    # 004521bf
    jne.d8 L_004521e2                            # 004521c4
    # block 0x004521c6: entered by fall-through of jne at 0x004521c4, 7 instruction(s), falls into the block at 0x004521e2
    mov eax, dword ptr [ebp - local_18]          # 004521c6
    imul eax, eax, 0x5c                          # 004521c9
    mov ecx, dword ptr [ebp - local_2c]          # 004521cc
    mov edx, dword ptr [ecx + field_2a0]         # 004521cf
    mov ecx, dword ptr [ebp - local_2c]          # 004521d5
    mov ecx, dword ptr [ecx + field_6d3]         # 004521d8
    mov dword ptr [edx + eax + field_48], ecx    # 004521de
L_004521e2:
    # block 0x004521e2: entered by je at 0x00452189; jne at 0x004521c4, 7 instruction(s), ends with je to 0x00452254 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 004521e2
    mov eax, dword ptr [edx + field_b0]          # 004521e5
    mov ecx, dword ptr [ebp - local_2c]          # 004521eb
    mov edx, dword ptr [ecx + 8*eax + field_2b0] # 004521ee
    sub edx, 0x1                                 # 004521f5
    cmp dword ptr [ebp - local_14], edx          # 004521f8
    je.d8 L_00452254                             # 004521fb
    # block 0x004521fd: entered by fall-through of je at 0x004521fb, 14 instruction(s), ends with jne to 0x00452254 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 004521fd
    mov ecx, dword ptr [eax + field_b0]          # 00452200
    mov edx, dword ptr [ebp - local_2c]          # 00452206
    mov eax, dword ptr [ebp - local_18]          # 00452209
    add eax, dword ptr [edx + 8*ecx + field_2ac] # 0045220c
    mov ecx, dword ptr [ebp - local_2c]          # 00452213
    mov dword ptr [ecx + field_6db], eax         # 00452216
    mov edx, dword ptr [ebp - local_2c]          # 0045221c
    mov eax, dword ptr [edx + field_6db]         # 0045221f
    imul eax, eax, 0x5c                          # 00452225
    mov ecx, dword ptr [ebp - local_2c]          # 00452228
    mov edx, dword ptr [ecx + field_2a0]         # 0045222b
    cmp dword ptr [edx + eax + field_58], 0x1    # 00452231
    jne.d8 L_00452254                            # 00452236
    # block 0x00452238: entered by fall-through of jne at 0x00452236, 7 instruction(s), falls into the block at 0x00452254
    mov eax, dword ptr [ebp - local_18]          # 00452238
    imul eax, eax, 0x5c                          # 0045223b
    mov ecx, dword ptr [ebp - local_2c]          # 0045223e
    mov edx, dword ptr [ecx + field_2a0]         # 00452241
    mov ecx, dword ptr [ebp - local_2c]          # 00452247
    mov ecx, dword ptr [ecx + field_6db]         # 0045224a
    mov dword ptr [edx + eax + field_50], ecx    # 00452250
L_00452254:
    # block 0x00452254: entered by je at 0x004521fb; jne at 0x00452236, 2 instruction(s), ends with je to 0x004522a1 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 00452254
    je.d8 L_004522a1                             # 00452258
    # block 0x0045225a: entered by fall-through of je at 0x00452258, 11 instruction(s), ends with jne to 0x004522a1 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0045225a
    sub edx, 0x1                                 # 0045225d
    mov eax, dword ptr [ebp - local_2c]          # 00452260
    mov dword ptr [eax + field_6d7], edx         # 00452263
    mov ecx, dword ptr [ebp - local_2c]          # 00452269
    mov edx, dword ptr [ecx + field_6d7]         # 0045226c
    imul edx, edx, 0x5c                          # 00452272
    mov eax, dword ptr [ebp - local_2c]          # 00452275
    mov ecx, dword ptr [eax + field_2a0]         # 00452278
    cmp dword ptr [ecx + edx + field_58], 0x1    # 0045227e
    jne.d8 L_004522a1                            # 00452283
    # block 0x00452285: entered by fall-through of jne at 0x00452283, 7 instruction(s), falls into the block at 0x004522a1
    mov edx, dword ptr [ebp - local_18]          # 00452285
    imul edx, edx, 0x5c                          # 00452288
    mov eax, dword ptr [ebp - local_2c]          # 0045228b
    mov ecx, dword ptr [eax + field_2a0]         # 0045228e
    mov eax, dword ptr [ebp - local_2c]          # 00452294
    mov eax, dword ptr [eax + field_6d7]         # 00452297
    mov dword ptr [ecx + edx + field_44], eax    # 0045229d
L_004522a1:
    # block 0x004522a1: entered by je at 0x00452258; jne at 0x00452283, 7 instruction(s), ends with je to 0x00452303 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004522a1
    mov edx, dword ptr [ecx + field_b0]          # 004522a4
    mov eax, dword ptr [ebp - local_2c]          # 004522aa
    mov ecx, dword ptr [eax + 8*edx + field_2ac] # 004522ad
    sub ecx, 0x1                                 # 004522b4
    cmp dword ptr [ebp - local_10], ecx          # 004522b7
    je.d8 L_00452303                             # 004522ba
    # block 0x004522bc: entered by fall-through of je at 0x004522ba, 11 instruction(s), ends with jne to 0x00452303 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004522bc
    add edx, 0x1                                 # 004522bf
    mov eax, dword ptr [ebp - local_2c]          # 004522c2
    mov dword ptr [eax + field_6df], edx         # 004522c5
    mov ecx, dword ptr [ebp - local_2c]          # 004522cb
    mov edx, dword ptr [ecx + field_6df]         # 004522ce
    imul edx, edx, 0x5c                          # 004522d4
    mov eax, dword ptr [ebp - local_2c]          # 004522d7
    mov ecx, dword ptr [eax + field_2a0]         # 004522da
    cmp dword ptr [ecx + edx + field_58], 0x1    # 004522e0
    jne.d8 L_00452303                            # 004522e5
    # block 0x004522e7: entered by fall-through of jne at 0x004522e5, 7 instruction(s), falls into the block at 0x00452303
    mov edx, dword ptr [ebp - local_18]          # 004522e7
    imul edx, edx, 0x5c                          # 004522ea
    mov eax, dword ptr [ebp - local_2c]          # 004522ed
    mov ecx, dword ptr [eax + field_2a0]         # 004522f0
    mov eax, dword ptr [ebp - local_2c]          # 004522f6
    mov eax, dword ptr [eax + field_6df]         # 004522f9
    mov dword ptr [ecx + edx + field_4c], eax    # 004522ff
L_00452303:
    # block 0x00452303: entered by je at 0x004522ba; jne at 0x004522e5, 1 instruction(s), ends with backward jump to 0x004520d4
    jmp.d32 L_004520d4                           # 00452303
L_00452308:
    # block 0x00452308: entered by jge at 0x004520f3, 1 instruction(s), ends with backward jump to 0x004520a6
    jmp.d32 L_004520a6                           # 00452308
L_0045230d:
    # block 0x0045230d: entered by jge at 0x004520c5, 20 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x00452394 (forward)
    call dword ptr [0x52a23c]                    # 0045230d
    mov ecx, dword ptr [ebp - local_2c]          # 00452313
    mov dword ptr [ecx + field_344], eax         # 00452316
    mov edx, dword ptr [ebp - local_2c]          # 0045231c
    mov dword ptr [edx + field_348], 0x0         # 0045231f
    mov eax, dword ptr [ebp - local_2c]          # 00452329
    mov dword ptr [eax + field_33c], 0x0         # 0045232c
    mov ecx, dword ptr [ebp - local_2c]          # 00452336
    mov dword ptr [ecx + field_340], 0x0         # 00452339
    mov edx, dword ptr [ebp - local_2c]          # 00452343
    mov eax, dword ptr [edx + field_b0]          # 00452346
    mov ecx, dword ptr [ebp - local_2c]          # 0045234c
    mov dword ptr [ecx + 4*eax + field_254], 0x0 # 0045234f
    mov edx, dword ptr [ebp - local_2c]          # 0045235a
    mov dword ptr [edx + field_298], 0x0         # 0045235d
    mov eax, dword ptr [ebp - local_2c]          # 00452367
    mov dword ptr [eax + field_c4], 0x1          # 0045236a
    mov ecx, dword ptr [ebp - local_2c]          # 00452374
    cmp dword ptr [ecx + field_54c], 0x0         # 00452377
    je.d8 L_00452394                             # 0045237e
    # block 0x00452380: entered by fall-through of je at 0x0045237e, 5 instruction(s), ends with forward jump to 0x004523b0
    mov edx, dword ptr [ebp - local_2c]          # 00452380
    mov eax, dword ptr [ebp - local_2c]          # 00452383
    mov ecx, dword ptr [eax + field_26c]         # 00452386
    mov dword ptr [edx + field_b4], ecx          # 0045238c
    jmp.d8 L_004523b0                            # 00452392
L_00452394:
    # block 0x00452394: entered by je at 0x0045237e, 6 instruction(s), falls into the block at 0x004523b0
    mov edx, dword ptr [ebp - local_2c]          # 00452394
    mov eax, dword ptr [edx + field_b0]          # 00452397
    mov ecx, dword ptr [ebp - local_2c]          # 0045239d
    mov edx, dword ptr [ebp - local_2c]          # 004523a0
    mov eax, dword ptr [edx + 4*eax + field_254] # 004523a3
    mov dword ptr [ecx + field_b4], eax          # 004523aa
L_004523b0:
    # block 0x004523b0: entered by jmp at 0x00451731; jmp at 0x00451b39; jmp at 0x00452392, 4 instruction(s), ends with ret
    pop esi                                      # 004523b0
    {load} mov esp, ebp                          # 004523b1
    pop ebp                                      # 004523b3
    ret                                          # 004523b4

