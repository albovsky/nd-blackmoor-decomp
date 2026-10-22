# FUN_004033db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004033db
# extent:       0x004033db-0x00403ea4 (2761 code bytes)
# span:         0x004033db-0x00403ea4 (code 2761, tables 0, padding 0)
# sha256:       19091a83402a04c2cd1fde95ec905bc573ddc40c17be2a28428c58e793bde201
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4033db_lifted
# naming:       native port src/original_methods_fl40.c:m4033db_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 8 seeds; oracle: 648/648 instructions executed, 14/14 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       70 ebp-relative slot(s): local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34, local_38, local_3c, local_40 and 58 more
# fields:       [eax + n] field_1c, field_490, field_494, field_498, field_49c, field_4a0, field_4a8; [ecx + n] field_1c, field_48c, field_490, field_494, field_498, field_49c, field_4a0, field_4a4; [edx + n] field_1c, field_48c, field_490, field_494, field_498, field_49c, field_4a0, field_4a4
# callees:      calls FUN_005193ca, FUN_0051d58b, USER32.dll!SendMessageA, FUN_0050ca3e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4033db_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 648 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
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
.equ local_e0, 0xe0  # offset -0xe0
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ local_fc, 0xfc  # offset -0xfc
.equ local_100, 0x100  # offset -0x100
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ field_1c, 0x1c  # offset +0x1c
.equ field_48c, 0x48c  # offset +0x48c
.equ field_490, 0x490  # offset +0x490
.equ field_494, 0x494  # offset +0x494
.equ field_498, 0x498  # offset +0x498
.equ field_49c, 0x49c  # offset +0x49c
.equ field_4a0, 0x4a0  # offset +0x4a0
.equ field_4a4, 0x4a4  # offset +0x4a4
.equ field_4a8, 0x4a8  # offset +0x4a8

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)
.set FUN_0051d58b, .text + (0x0051d58b - 0x401000)

.org 0x004033db - 0x401000
.globl FUN_004033db
FUN_004033db:
    # block 0x004033db: entry, 116 instruction(s), calls FUN_005193ca, FUN_0051d58b, ends with je to 0x004035b3 (forward)
    push ebp                                     # 004033db
    {load} mov ebp, esp                          # 004033dc
    sub esp, 0x128                               # 004033de
    mov dword ptr [ebp - local_128], ecx         # 004033e4
    push 0xa                                     # 004033ea
    lea eax, [ebp - local_14]                    # 004033ec
    push eax                                     # 004033ef
    movsx ecx, word ptr [0x5ec33c]               # 004033f0
    push ecx                                     # 004033f7
    call FUN_005193ca                            # 004033f8
    add esp, 0xc                                 # 004033fd
    push eax                                     # 00403400
    mov ecx, dword ptr [ebp - local_128]         # 00403401
    add ecx, 0x8c                                # 00403407
    call FUN_0051d58b                            # 0040340d
    push 0xa                                     # 00403412
    lea edx, [ebp - local_14]                    # 00403414
    push edx                                     # 00403417
    movsx eax, word ptr [0x5ec33e]               # 00403418
    push eax                                     # 0040341f
    call FUN_005193ca                            # 00403420
    add esp, 0xc                                 # 00403425
    push eax                                     # 00403428
    mov ecx, dword ptr [ebp - local_128]         # 00403429
    add ecx, 0xcc                                # 0040342f
    call FUN_0051d58b                            # 00403435
    push 0xa                                     # 0040343a
    lea ecx, [ebp - local_14]                    # 0040343c
    push ecx                                     # 0040343f
    movsx edx, word ptr [0x5ec340]               # 00403440
    push edx                                     # 00403447
    call FUN_005193ca                            # 00403448
    add esp, 0xc                                 # 0040344d
    push eax                                     # 00403450
    mov ecx, dword ptr [ebp - local_128]         # 00403451
    add ecx, 0x10c                               # 00403457
    call FUN_0051d58b                            # 0040345d
    push 0xa                                     # 00403462
    lea eax, [ebp - local_14]                    # 00403464
    push eax                                     # 00403467
    movsx ecx, word ptr [0x5e5684]               # 00403468
    push ecx                                     # 0040346f
    call FUN_005193ca                            # 00403470
    add esp, 0xc                                 # 00403475
    push eax                                     # 00403478
    mov ecx, dword ptr [ebp - local_128]         # 00403479
    add ecx, 0x14c                               # 0040347f
    call FUN_0051d58b                            # 00403485
    push 0xa                                     # 0040348a
    lea edx, [ebp - local_14]                    # 0040348c
    push edx                                     # 0040348f
    movsx eax, word ptr [0x5e5686]               # 00403490
    push eax                                     # 00403497
    call FUN_005193ca                            # 00403498
    add esp, 0xc                                 # 0040349d
    push eax                                     # 004034a0
    mov ecx, dword ptr [ebp - local_128]         # 004034a1
    add ecx, 0x18c                               # 004034a7
    call FUN_0051d58b                            # 004034ad
    push 0xa                                     # 004034b2
    lea ecx, [ebp - local_14]                    # 004034b4
    push ecx                                     # 004034b7
    movsx edx, word ptr [0x5e5688]               # 004034b8
    push edx                                     # 004034bf
    call FUN_005193ca                            # 004034c0
    add esp, 0xc                                 # 004034c5
    push eax                                     # 004034c8
    mov ecx, dword ptr [ebp - local_128]         # 004034c9
    add ecx, 0x1cc                               # 004034cf
    call FUN_0051d58b                            # 004034d5
    push 0xa                                     # 004034da
    lea eax, [ebp - local_14]                    # 004034dc
    push eax                                     # 004034df
    movsx ecx, word ptr [0x5ec33a]               # 004034e0
    push ecx                                     # 004034e7
    call FUN_005193ca                            # 004034e8
    add esp, 0xc                                 # 004034ed
    push eax                                     # 004034f0
    mov ecx, dword ptr [ebp - local_128]         # 004034f1
    add ecx, 0x38c                               # 004034f7
    call FUN_0051d58b                            # 004034fd
    push 0xa                                     # 00403502
    lea edx, [ebp - local_14]                    # 00403504
    push edx                                     # 00403507
    movsx eax, word ptr [0x5ec284]               # 00403508
    push eax                                     # 0040350f
    call FUN_005193ca                            # 00403510
    add esp, 0xc                                 # 00403515
    push eax                                     # 00403518
    mov ecx, dword ptr [ebp - local_128]         # 00403519
    add ecx, 0x3cc                               # 0040351f
    call FUN_0051d58b                            # 00403525
    push 0xa                                     # 0040352a
    lea ecx, [ebp - local_14]                    # 0040352c
    push ecx                                     # 0040352f
    movsx edx, word ptr [0x5ec286]               # 00403530
    push edx                                     # 00403537
    call FUN_005193ca                            # 00403538
    add esp, 0xc                                 # 0040353d
    push eax                                     # 00403540
    mov ecx, dword ptr [ebp - local_128]         # 00403541
    add ecx, 0x40c                               # 00403547
    call FUN_0051d58b                            # 0040354d
    push 0xa                                     # 00403552
    lea eax, [ebp - local_14]                    # 00403554
    push eax                                     # 00403557
    movsx ecx, word ptr [0x5ec288]               # 00403558
    push ecx                                     # 0040355f
    call FUN_005193ca                            # 00403560
    add esp, 0xc                                 # 00403565
    push eax                                     # 00403568
    mov ecx, dword ptr [ebp - local_128]         # 00403569
    add ecx, 0x44c                               # 0040356f
    call FUN_0051d58b                            # 00403575
    cmp dword ptr [0x5ec342], 0x0                # 0040357a
    je.d8 L_004035b3                             # 00403581
    # block 0x00403583: entered by fall-through of je at 0x00403581, 13 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x004035e1
    mov dword ptr [ebp - local_1c], 0x1          # 00403583
    mov edx, dword ptr [ebp - local_128]         # 0040358a
    mov eax, dword ptr [edx + field_48c]         # 00403590
    mov dword ptr [ebp - local_18], eax          # 00403596
    push 0x0                                     # 00403599
    mov ecx, dword ptr [ebp - local_1c]          # 0040359b
    push ecx                                     # 0040359e
    push 0xf1                                    # 0040359f
    mov edx, dword ptr [ebp - local_18]          # 004035a4
    mov eax, dword ptr [edx + field_1c]          # 004035a7
    push eax                                     # 004035aa
    call dword ptr [0x52a4c8]                    # 004035ab
    jmp.d8 L_004035e1                            # 004035b1
L_004035b3:
    # block 0x004035b3: entered by je at 0x00403581, 12 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x004035e1
    mov dword ptr [ebp - local_24], 0x0          # 004035b3
    mov ecx, dword ptr [ebp - local_128]         # 004035ba
    mov edx, dword ptr [ecx + field_48c]         # 004035c0
    mov dword ptr [ebp - local_20], edx          # 004035c6
    push 0x0                                     # 004035c9
    mov eax, dword ptr [ebp - local_24]          # 004035cb
    push eax                                     # 004035ce
    push 0xf1                                    # 004035cf
    mov ecx, dword ptr [ebp - local_20]          # 004035d4
    mov edx, dword ptr [ecx + field_1c]          # 004035d7
    push edx                                     # 004035da
    call dword ptr [0x52a4c8]                    # 004035db
L_004035e1:
    # block 0x004035e1: entered by jmp at 0x004035b1, 94 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, FUN_005193ca, ends with je to 0x00403784 (forward)
    mov eax, dword ptr [0x5c3a63]                # 004035e1
    push eax                                     # 004035e6
    push 0x53e8dc                                # 004035e7
    lea ecx, [ebp - local_14]                    # 004035ec
    push ecx                                     # 004035ef
    call FUN_0050ca3e                            # 004035f0
    add esp, 0xc                                 # 004035f5
    lea edx, [ebp - local_14]                    # 004035f8
    push edx                                     # 004035fb
    mov eax, dword ptr [ebp - local_128]         # 004035fc
    mov ecx, dword ptr [eax + field_4a8]         # 00403602
    call FUN_0051d58b                            # 00403608
    push 0xa                                     # 0040360d
    lea ecx, [ebp - local_14]                    # 0040360f
    push ecx                                     # 00403612
    mov edx, dword ptr [0x5c3a63]                # 00403613
    imul edx, edx, 0x106                         # 00403619
    mov eax, dword ptr [edx + 0x5e56a6]          # 0040361f
    push eax                                     # 00403625
    call FUN_005193ca                            # 00403626
    add esp, 0xc                                 # 0040362b
    push eax                                     # 0040362e
    mov ecx, dword ptr [ebp - local_128]         # 0040362f
    add ecx, 0x20c                               # 00403635
    call FUN_0051d58b                            # 0040363b
    push 0xa                                     # 00403640
    lea ecx, [ebp - local_14]                    # 00403642
    push ecx                                     # 00403645
    mov edx, dword ptr [0x5c3a63]                # 00403646
    imul edx, edx, 0x106                         # 0040364c
    mov eax, dword ptr [edx + 0x5e56aa]          # 00403652
    push eax                                     # 00403658
    call FUN_005193ca                            # 00403659
    add esp, 0xc                                 # 0040365e
    push eax                                     # 00403661
    mov ecx, dword ptr [ebp - local_128]         # 00403662
    add ecx, 0x24c                               # 00403668
    call FUN_0051d58b                            # 0040366e
    push 0xa                                     # 00403673
    lea ecx, [ebp - local_14]                    # 00403675
    push ecx                                     # 00403678
    mov edx, dword ptr [0x5c3a63]                # 00403679
    imul edx, edx, 0x106                         # 0040367f
    mov eax, dword ptr [edx + 0x5e56a2]          # 00403685
    push eax                                     # 0040368b
    call FUN_005193ca                            # 0040368c
    add esp, 0xc                                 # 00403691
    push eax                                     # 00403694
    mov ecx, dword ptr [ebp - local_128]         # 00403695
    add ecx, 0x28c                               # 0040369b
    call FUN_0051d58b                            # 004036a1
    push 0xa                                     # 004036a6
    lea ecx, [ebp - local_14]                    # 004036a8
    push ecx                                     # 004036ab
    mov edx, dword ptr [0x5c3a63]                # 004036ac
    imul edx, edx, 0x106                         # 004036b2
    mov eax, dword ptr [edx + 0x5e56ba]          # 004036b8
    push eax                                     # 004036be
    call FUN_005193ca                            # 004036bf
    add esp, 0xc                                 # 004036c4
    push eax                                     # 004036c7
    mov ecx, dword ptr [ebp - local_128]         # 004036c8
    add ecx, 0x2cc                               # 004036ce
    call FUN_0051d58b                            # 004036d4
    push 0xa                                     # 004036d9
    lea ecx, [ebp - local_14]                    # 004036db
    push ecx                                     # 004036de
    mov edx, dword ptr [0x5c3a63]                # 004036df
    imul edx, edx, 0x106                         # 004036e5
    mov eax, dword ptr [edx + 0x5e56be]          # 004036eb
    push eax                                     # 004036f1
    call FUN_005193ca                            # 004036f2
    add esp, 0xc                                 # 004036f7
    push eax                                     # 004036fa
    mov ecx, dword ptr [ebp - local_128]         # 004036fb
    add ecx, 0x30c                               # 00403701
    call FUN_0051d58b                            # 00403707
    push 0xa                                     # 0040370c
    lea ecx, [ebp - local_14]                    # 0040370e
    push ecx                                     # 00403711
    mov edx, dword ptr [0x5c3a63]                # 00403712
    imul edx, edx, 0x106                         # 00403718
    mov eax, dword ptr [edx + 0x5e56b6]          # 0040371e
    push eax                                     # 00403724
    call FUN_005193ca                            # 00403725
    add esp, 0xc                                 # 0040372a
    push eax                                     # 0040372d
    mov ecx, dword ptr [ebp - local_128]         # 0040372e
    add ecx, 0x34c                               # 00403734
    call FUN_0051d58b                            # 0040373a
    mov ecx, dword ptr [0x5c3a63]                # 0040373f
    imul ecx, ecx, 0x106                         # 00403745
    cmp dword ptr [ecx + 0x5e56ae], 0x0          # 0040374b
    je.d8 L_00403784                             # 00403752
    # block 0x00403754: entered by fall-through of je at 0x00403752, 13 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x004037b2
    mov dword ptr [ebp - local_2c], 0x1          # 00403754
    mov edx, dword ptr [ebp - local_128]         # 0040375b
    mov eax, dword ptr [edx + field_4a4]         # 00403761
    mov dword ptr [ebp - local_28], eax          # 00403767
    push 0x0                                     # 0040376a
    mov ecx, dword ptr [ebp - local_2c]          # 0040376c
    push ecx                                     # 0040376f
    push 0xf1                                    # 00403770
    mov edx, dword ptr [ebp - local_28]          # 00403775
    mov eax, dword ptr [edx + field_1c]          # 00403778
    push eax                                     # 0040377b
    call dword ptr [0x52a4c8]                    # 0040377c
    jmp.d8 L_004037b2                            # 00403782
L_00403784:
    # block 0x00403784: entered by je at 0x00403752, 12 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x004037b2
    mov dword ptr [ebp - local_34], 0x0          # 00403784
    mov ecx, dword ptr [ebp - local_128]         # 0040378b
    mov edx, dword ptr [ecx + field_4a4]         # 00403791
    mov dword ptr [ebp - local_30], edx          # 00403797
    push 0x0                                     # 0040379a
    mov eax, dword ptr [ebp - local_34]          # 0040379c
    push eax                                     # 0040379f
    push 0xf1                                    # 004037a0
    mov ecx, dword ptr [ebp - local_30]          # 004037a5
    mov edx, dword ptr [ecx + field_1c]          # 004037a8
    push edx                                     # 004037ab
    call dword ptr [0x52a4c8]                    # 004037ac
L_004037b2:
    # block 0x004037b2: entered by jmp at 0x00403782, 4 instruction(s), ends with jne to 0x004038b5 (forward)
    mov eax, dword ptr [0x5c3a63]                # 004037b2
    imul eax, eax, 0x106                         # 004037b7
    cmp dword ptr [eax + 0x5e569a], 0x0          # 004037bd
    jne.d32 L_004038b5                           # 004037c4
    # block 0x004037ca: entered by fall-through of jne at 0x004037c4, 61 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x00403ea0
    mov dword ptr [ebp - local_3c], 0x1          # 004037ca
    mov ecx, dword ptr [ebp - local_128]         # 004037d1
    mov edx, dword ptr [ecx + field_494]         # 004037d7
    mov dword ptr [ebp - local_38], edx          # 004037dd
    push 0x0                                     # 004037e0
    mov eax, dword ptr [ebp - local_3c]          # 004037e2
    push eax                                     # 004037e5
    push 0xf1                                    # 004037e6
    mov ecx, dword ptr [ebp - local_38]          # 004037eb
    mov edx, dword ptr [ecx + field_1c]          # 004037ee
    push edx                                     # 004037f1
    call dword ptr [0x52a4c8]                    # 004037f2
    mov dword ptr [ebp - local_44], 0x0          # 004037f8
    mov eax, dword ptr [ebp - local_128]         # 004037ff
    mov ecx, dword ptr [eax + field_490]         # 00403805
    mov dword ptr [ebp - local_40], ecx          # 0040380b
    push 0x0                                     # 0040380e
    mov edx, dword ptr [ebp - local_44]          # 00403810
    push edx                                     # 00403813
    push 0xf1                                    # 00403814
    mov eax, dword ptr [ebp - local_40]          # 00403819
    mov ecx, dword ptr [eax + field_1c]          # 0040381c
    push ecx                                     # 0040381f
    call dword ptr [0x52a4c8]                    # 00403820
    mov dword ptr [ebp - local_4c], 0x0          # 00403826
    mov edx, dword ptr [ebp - local_128]         # 0040382d
    mov eax, dword ptr [edx + field_498]         # 00403833
    mov dword ptr [ebp - local_48], eax          # 00403839
    push 0x0                                     # 0040383c
    mov ecx, dword ptr [ebp - local_4c]          # 0040383e
    push ecx                                     # 00403841
    push 0xf1                                    # 00403842
    mov edx, dword ptr [ebp - local_48]          # 00403847
    mov eax, dword ptr [edx + field_1c]          # 0040384a
    push eax                                     # 0040384d
    call dword ptr [0x52a4c8]                    # 0040384e
    mov dword ptr [ebp - local_54], 0x0          # 00403854
    mov ecx, dword ptr [ebp - local_128]         # 0040385b
    mov edx, dword ptr [ecx + field_49c]         # 00403861
    mov dword ptr [ebp - local_50], edx          # 00403867
    push 0x0                                     # 0040386a
    mov eax, dword ptr [ebp - local_54]          # 0040386c
    push eax                                     # 0040386f
    push 0xf1                                    # 00403870
    mov ecx, dword ptr [ebp - local_50]          # 00403875
    mov edx, dword ptr [ecx + field_1c]          # 00403878
    push edx                                     # 0040387b
    call dword ptr [0x52a4c8]                    # 0040387c
    mov dword ptr [ebp - local_5c], 0x0          # 00403882
    mov eax, dword ptr [ebp - local_128]         # 00403889
    mov ecx, dword ptr [eax + field_4a0]         # 0040388f
    mov dword ptr [ebp - local_58], ecx          # 00403895
    push 0x0                                     # 00403898
    mov edx, dword ptr [ebp - local_5c]          # 0040389a
    push edx                                     # 0040389d
    push 0xf1                                    # 0040389e
    mov eax, dword ptr [ebp - local_58]          # 004038a3
    mov ecx, dword ptr [eax + field_1c]          # 004038a6
    push ecx                                     # 004038a9
    call dword ptr [0x52a4c8]                    # 004038aa
    jmp.d32 L_00403ea0                           # 004038b0
L_004038b5:
    # block 0x004038b5: entered by jne at 0x004037c4, 4 instruction(s), ends with jne to 0x004039bf (forward)
    mov edx, dword ptr [0x5c3a63]                # 004038b5
    imul edx, edx, 0x106                         # 004038bb
    cmp dword ptr [edx + 0x5e569a], 0x1          # 004038c1
    jne.d32 L_004039bf                           # 004038c8
    # block 0x004038ce: entered by fall-through of jne at 0x004038c8, 61 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x00403ea0
    mov dword ptr [ebp - local_64], 0x0          # 004038ce
    mov eax, dword ptr [ebp - local_128]         # 004038d5
    mov ecx, dword ptr [eax + field_494]         # 004038db
    mov dword ptr [ebp - local_60], ecx          # 004038e1
    push 0x0                                     # 004038e4
    mov edx, dword ptr [ebp - local_64]          # 004038e6
    push edx                                     # 004038e9
    push 0xf1                                    # 004038ea
    mov eax, dword ptr [ebp - local_60]          # 004038ef
    mov ecx, dword ptr [eax + field_1c]          # 004038f2
    push ecx                                     # 004038f5
    call dword ptr [0x52a4c8]                    # 004038f6
    mov dword ptr [ebp - local_6c], 0x1          # 004038fc
    mov edx, dword ptr [ebp - local_128]         # 00403903
    mov eax, dword ptr [edx + field_490]         # 00403909
    mov dword ptr [ebp - local_68], eax          # 0040390f
    push 0x0                                     # 00403912
    mov ecx, dword ptr [ebp - local_6c]          # 00403914
    push ecx                                     # 00403917
    push 0xf1                                    # 00403918
    mov edx, dword ptr [ebp - local_68]          # 0040391d
    mov eax, dword ptr [edx + field_1c]          # 00403920
    push eax                                     # 00403923
    call dword ptr [0x52a4c8]                    # 00403924
    mov dword ptr [ebp - local_74], 0x0          # 0040392a
    mov ecx, dword ptr [ebp - local_128]         # 00403931
    mov edx, dword ptr [ecx + field_498]         # 00403937
    mov dword ptr [ebp - local_70], edx          # 0040393d
    push 0x0                                     # 00403940
    mov eax, dword ptr [ebp - local_74]          # 00403942
    push eax                                     # 00403945
    push 0xf1                                    # 00403946
    mov ecx, dword ptr [ebp - local_70]          # 0040394b
    mov edx, dword ptr [ecx + field_1c]          # 0040394e
    push edx                                     # 00403951
    call dword ptr [0x52a4c8]                    # 00403952
    mov dword ptr [ebp - local_7c], 0x0          # 00403958
    mov eax, dword ptr [ebp - local_128]         # 0040395f
    mov ecx, dword ptr [eax + field_49c]         # 00403965
    mov dword ptr [ebp - local_78], ecx          # 0040396b
    push 0x0                                     # 0040396e
    mov edx, dword ptr [ebp - local_7c]          # 00403970
    push edx                                     # 00403973
    push 0xf1                                    # 00403974
    mov eax, dword ptr [ebp - local_78]          # 00403979
    mov ecx, dword ptr [eax + field_1c]          # 0040397c
    push ecx                                     # 0040397f
    call dword ptr [0x52a4c8]                    # 00403980
    mov dword ptr [ebp - local_84], 0x0          # 00403986
    mov edx, dword ptr [ebp - local_128]         # 00403990
    mov eax, dword ptr [edx + field_4a0]         # 00403996
    mov dword ptr [ebp - local_80], eax          # 0040399c
    push 0x0                                     # 0040399f
    mov ecx, dword ptr [ebp - local_84]          # 004039a1
    push ecx                                     # 004039a7
    push 0xf1                                    # 004039a8
    mov edx, dword ptr [ebp - local_80]          # 004039ad
    mov eax, dword ptr [edx + field_1c]          # 004039b0
    push eax                                     # 004039b3
    call dword ptr [0x52a4c8]                    # 004039b4
    jmp.d32 L_00403ea0                           # 004039ba
L_004039bf:
    # block 0x004039bf: entered by jne at 0x004038c8, 4 instruction(s), ends with jne to 0x00403aff (forward)
    mov ecx, dword ptr [0x5c3a63]                # 004039bf
    imul ecx, ecx, 0x106                         # 004039c5
    cmp dword ptr [ecx + 0x5e569a], 0x2          # 004039cb
    jne.d32 L_00403aff                           # 004039d2
    # block 0x004039d8: entered by fall-through of jne at 0x004039d2, 61 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x00403ea0
    mov dword ptr [ebp - local_8c], 0x0          # 004039d8
    mov edx, dword ptr [ebp - local_128]         # 004039e2
    mov eax, dword ptr [edx + field_494]         # 004039e8
    mov dword ptr [ebp - local_88], eax          # 004039ee
    push 0x0                                     # 004039f4
    mov ecx, dword ptr [ebp - local_8c]          # 004039f6
    push ecx                                     # 004039fc
    push 0xf1                                    # 004039fd
    mov edx, dword ptr [ebp - local_88]          # 00403a02
    mov eax, dword ptr [edx + field_1c]          # 00403a08
    push eax                                     # 00403a0b
    call dword ptr [0x52a4c8]                    # 00403a0c
    mov dword ptr [ebp - local_94], 0x0          # 00403a12
    mov ecx, dword ptr [ebp - local_128]         # 00403a1c
    mov edx, dword ptr [ecx + field_490]         # 00403a22
    mov dword ptr [ebp - local_90], edx          # 00403a28
    push 0x0                                     # 00403a2e
    mov eax, dword ptr [ebp - local_94]          # 00403a30
    push eax                                     # 00403a36
    push 0xf1                                    # 00403a37
    mov ecx, dword ptr [ebp - local_90]          # 00403a3c
    mov edx, dword ptr [ecx + field_1c]          # 00403a42
    push edx                                     # 00403a45
    call dword ptr [0x52a4c8]                    # 00403a46
    mov dword ptr [ebp - local_9c], 0x1          # 00403a4c
    mov eax, dword ptr [ebp - local_128]         # 00403a56
    mov ecx, dword ptr [eax + field_498]         # 00403a5c
    mov dword ptr [ebp - local_98], ecx          # 00403a62
    push 0x0                                     # 00403a68
    mov edx, dword ptr [ebp - local_9c]          # 00403a6a
    push edx                                     # 00403a70
    push 0xf1                                    # 00403a71
    mov eax, dword ptr [ebp - local_98]          # 00403a76
    mov ecx, dword ptr [eax + field_1c]          # 00403a7c
    push ecx                                     # 00403a7f
    call dword ptr [0x52a4c8]                    # 00403a80
    mov dword ptr [ebp - local_a4], 0x0          # 00403a86
    mov edx, dword ptr [ebp - local_128]         # 00403a90
    mov eax, dword ptr [edx + field_49c]         # 00403a96
    mov dword ptr [ebp - local_a0], eax          # 00403a9c
    push 0x0                                     # 00403aa2
    mov ecx, dword ptr [ebp - local_a4]          # 00403aa4
    push ecx                                     # 00403aaa
    push 0xf1                                    # 00403aab
    mov edx, dword ptr [ebp - local_a0]          # 00403ab0
    mov eax, dword ptr [edx + field_1c]          # 00403ab6
    push eax                                     # 00403ab9
    call dword ptr [0x52a4c8]                    # 00403aba
    mov dword ptr [ebp - local_ac], 0x0          # 00403ac0
    mov ecx, dword ptr [ebp - local_128]         # 00403aca
    mov edx, dword ptr [ecx + field_4a0]         # 00403ad0
    mov dword ptr [ebp - local_a8], edx          # 00403ad6
    push 0x0                                     # 00403adc
    mov eax, dword ptr [ebp - local_ac]          # 00403ade
    push eax                                     # 00403ae4
    push 0xf1                                    # 00403ae5
    mov ecx, dword ptr [ebp - local_a8]          # 00403aea
    mov edx, dword ptr [ecx + field_1c]          # 00403af0
    push edx                                     # 00403af3
    call dword ptr [0x52a4c8]                    # 00403af4
    jmp.d32 L_00403ea0                           # 00403afa
L_00403aff:
    # block 0x00403aff: entered by jne at 0x004039d2, 4 instruction(s), ends with jne to 0x00403c3e (forward)
    mov eax, dword ptr [0x5c3a63]                # 00403aff
    imul eax, eax, 0x106                         # 00403b04
    cmp dword ptr [eax + 0x5e569a], 0x5          # 00403b0a
    jne.d32 L_00403c3e                           # 00403b11
    # block 0x00403b17: entered by fall-through of jne at 0x00403b11, 61 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x00403ea0
    mov dword ptr [ebp - local_b4], 0x0          # 00403b17
    mov ecx, dword ptr [ebp - local_128]         # 00403b21
    mov edx, dword ptr [ecx + field_494]         # 00403b27
    mov dword ptr [ebp - local_b0], edx          # 00403b2d
    push 0x0                                     # 00403b33
    mov eax, dword ptr [ebp - local_b4]          # 00403b35
    push eax                                     # 00403b3b
    push 0xf1                                    # 00403b3c
    mov ecx, dword ptr [ebp - local_b0]          # 00403b41
    mov edx, dword ptr [ecx + field_1c]          # 00403b47
    push edx                                     # 00403b4a
    call dword ptr [0x52a4c8]                    # 00403b4b
    mov dword ptr [ebp - local_bc], 0x0          # 00403b51
    mov eax, dword ptr [ebp - local_128]         # 00403b5b
    mov ecx, dword ptr [eax + field_490]         # 00403b61
    mov dword ptr [ebp - local_b8], ecx          # 00403b67
    push 0x0                                     # 00403b6d
    mov edx, dword ptr [ebp - local_bc]          # 00403b6f
    push edx                                     # 00403b75
    push 0xf1                                    # 00403b76
    mov eax, dword ptr [ebp - local_b8]          # 00403b7b
    mov ecx, dword ptr [eax + field_1c]          # 00403b81
    push ecx                                     # 00403b84
    call dword ptr [0x52a4c8]                    # 00403b85
    mov dword ptr [ebp - local_c4], 0x0          # 00403b8b
    mov edx, dword ptr [ebp - local_128]         # 00403b95
    mov eax, dword ptr [edx + field_498]         # 00403b9b
    mov dword ptr [ebp - local_c0], eax          # 00403ba1
    push 0x0                                     # 00403ba7
    mov ecx, dword ptr [ebp - local_c4]          # 00403ba9
    push ecx                                     # 00403baf
    push 0xf1                                    # 00403bb0
    mov edx, dword ptr [ebp - local_c0]          # 00403bb5
    mov eax, dword ptr [edx + field_1c]          # 00403bbb
    push eax                                     # 00403bbe
    call dword ptr [0x52a4c8]                    # 00403bbf
    mov dword ptr [ebp - local_cc], 0x1          # 00403bc5
    mov ecx, dword ptr [ebp - local_128]         # 00403bcf
    mov edx, dword ptr [ecx + field_49c]         # 00403bd5
    mov dword ptr [ebp - local_c8], edx          # 00403bdb
    push 0x0                                     # 00403be1
    mov eax, dword ptr [ebp - local_cc]          # 00403be3
    push eax                                     # 00403be9
    push 0xf1                                    # 00403bea
    mov ecx, dword ptr [ebp - local_c8]          # 00403bef
    mov edx, dword ptr [ecx + field_1c]          # 00403bf5
    push edx                                     # 00403bf8
    call dword ptr [0x52a4c8]                    # 00403bf9
    mov dword ptr [ebp - local_d4], 0x0          # 00403bff
    mov eax, dword ptr [ebp - local_128]         # 00403c09
    mov ecx, dword ptr [eax + field_4a0]         # 00403c0f
    mov dword ptr [ebp - local_d0], ecx          # 00403c15
    push 0x0                                     # 00403c1b
    mov edx, dword ptr [ebp - local_d4]          # 00403c1d
    push edx                                     # 00403c23
    push 0xf1                                    # 00403c24
    mov eax, dword ptr [ebp - local_d0]          # 00403c29
    mov ecx, dword ptr [eax + field_1c]          # 00403c2f
    push ecx                                     # 00403c32
    call dword ptr [0x52a4c8]                    # 00403c33
    jmp.d32 L_00403ea0                           # 00403c39
L_00403c3e:
    # block 0x00403c3e: entered by jne at 0x00403b11, 4 instruction(s), ends with jne to 0x00403d7e (forward)
    mov edx, dword ptr [0x5c3a63]                # 00403c3e
    imul edx, edx, 0x106                         # 00403c44
    cmp dword ptr [edx + 0x5e569a], 0x6          # 00403c4a
    jne.d32 L_00403d7e                           # 00403c51
    # block 0x00403c57: entered by fall-through of jne at 0x00403c51, 61 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x00403ea0
    mov dword ptr [ebp - local_dc], 0x0          # 00403c57
    mov eax, dword ptr [ebp - local_128]         # 00403c61
    mov ecx, dword ptr [eax + field_494]         # 00403c67
    mov dword ptr [ebp - local_d8], ecx          # 00403c6d
    push 0x0                                     # 00403c73
    mov edx, dword ptr [ebp - local_dc]          # 00403c75
    push edx                                     # 00403c7b
    push 0xf1                                    # 00403c7c
    mov eax, dword ptr [ebp - local_d8]          # 00403c81
    mov ecx, dword ptr [eax + field_1c]          # 00403c87
    push ecx                                     # 00403c8a
    call dword ptr [0x52a4c8]                    # 00403c8b
    mov dword ptr [ebp - local_e4], 0x0          # 00403c91
    mov edx, dword ptr [ebp - local_128]         # 00403c9b
    mov eax, dword ptr [edx + field_490]         # 00403ca1
    mov dword ptr [ebp - local_e0], eax          # 00403ca7
    push 0x0                                     # 00403cad
    mov ecx, dword ptr [ebp - local_e4]          # 00403caf
    push ecx                                     # 00403cb5
    push 0xf1                                    # 00403cb6
    mov edx, dword ptr [ebp - local_e0]          # 00403cbb
    mov eax, dword ptr [edx + field_1c]          # 00403cc1
    push eax                                     # 00403cc4
    call dword ptr [0x52a4c8]                    # 00403cc5
    mov dword ptr [ebp - local_ec], 0x0          # 00403ccb
    mov ecx, dword ptr [ebp - local_128]         # 00403cd5
    mov edx, dword ptr [ecx + field_498]         # 00403cdb
    mov dword ptr [ebp - local_e8], edx          # 00403ce1
    push 0x0                                     # 00403ce7
    mov eax, dword ptr [ebp - local_ec]          # 00403ce9
    push eax                                     # 00403cef
    push 0xf1                                    # 00403cf0
    mov ecx, dword ptr [ebp - local_e8]          # 00403cf5
    mov edx, dword ptr [ecx + field_1c]          # 00403cfb
    push edx                                     # 00403cfe
    call dword ptr [0x52a4c8]                    # 00403cff
    mov dword ptr [ebp - local_f4], 0x0          # 00403d05
    mov eax, dword ptr [ebp - local_128]         # 00403d0f
    mov ecx, dword ptr [eax + field_49c]         # 00403d15
    mov dword ptr [ebp - local_f0], ecx          # 00403d1b
    push 0x0                                     # 00403d21
    mov edx, dword ptr [ebp - local_f4]          # 00403d23
    push edx                                     # 00403d29
    push 0xf1                                    # 00403d2a
    mov eax, dword ptr [ebp - local_f0]          # 00403d2f
    mov ecx, dword ptr [eax + field_1c]          # 00403d35
    push ecx                                     # 00403d38
    call dword ptr [0x52a4c8]                    # 00403d39
    mov dword ptr [ebp - local_fc], 0x1          # 00403d3f
    mov edx, dword ptr [ebp - local_128]         # 00403d49
    mov eax, dword ptr [edx + field_4a0]         # 00403d4f
    mov dword ptr [ebp - local_f8], eax          # 00403d55
    push 0x0                                     # 00403d5b
    mov ecx, dword ptr [ebp - local_fc]          # 00403d5d
    push ecx                                     # 00403d63
    push 0xf1                                    # 00403d64
    mov edx, dword ptr [ebp - local_f8]          # 00403d69
    mov eax, dword ptr [edx + field_1c]          # 00403d6f
    push eax                                     # 00403d72
    call dword ptr [0x52a4c8]                    # 00403d73
    jmp.d32 L_00403ea0                           # 00403d79
L_00403d7e:
    # block 0x00403d7e: entered by jne at 0x00403c51, 60 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x00403ea0
    mov dword ptr [ebp - local_104], 0x0         # 00403d7e
    mov ecx, dword ptr [ebp - local_128]         # 00403d88
    mov edx, dword ptr [ecx + field_494]         # 00403d8e
    mov dword ptr [ebp - local_100], edx         # 00403d94
    push 0x0                                     # 00403d9a
    mov eax, dword ptr [ebp - local_104]         # 00403d9c
    push eax                                     # 00403da2
    push 0xf1                                    # 00403da3
    mov ecx, dword ptr [ebp - local_100]         # 00403da8
    mov edx, dword ptr [ecx + field_1c]          # 00403dae
    push edx                                     # 00403db1
    call dword ptr [0x52a4c8]                    # 00403db2
    mov dword ptr [ebp - local_10c], 0x0         # 00403db8
    mov eax, dword ptr [ebp - local_128]         # 00403dc2
    mov ecx, dword ptr [eax + field_490]         # 00403dc8
    mov dword ptr [ebp - local_108], ecx         # 00403dce
    push 0x0                                     # 00403dd4
    mov edx, dword ptr [ebp - local_10c]         # 00403dd6
    push edx                                     # 00403ddc
    push 0xf1                                    # 00403ddd
    mov eax, dword ptr [ebp - local_108]         # 00403de2
    mov ecx, dword ptr [eax + field_1c]          # 00403de8
    push ecx                                     # 00403deb
    call dword ptr [0x52a4c8]                    # 00403dec
    mov dword ptr [ebp - local_114], 0x0         # 00403df2
    mov edx, dword ptr [ebp - local_128]         # 00403dfc
    mov eax, dword ptr [edx + field_498]         # 00403e02
    mov dword ptr [ebp - local_110], eax         # 00403e08
    push 0x0                                     # 00403e0e
    mov ecx, dword ptr [ebp - local_114]         # 00403e10
    push ecx                                     # 00403e16
    push 0xf1                                    # 00403e17
    mov edx, dword ptr [ebp - local_110]         # 00403e1c
    mov eax, dword ptr [edx + field_1c]          # 00403e22
    push eax                                     # 00403e25
    call dword ptr [0x52a4c8]                    # 00403e26
    mov dword ptr [ebp - local_11c], 0x0         # 00403e2c
    mov ecx, dword ptr [ebp - local_128]         # 00403e36
    mov edx, dword ptr [ecx + field_49c]         # 00403e3c
    mov dword ptr [ebp - local_118], edx         # 00403e42
    push 0x0                                     # 00403e48
    mov eax, dword ptr [ebp - local_11c]         # 00403e4a
    push eax                                     # 00403e50
    push 0xf1                                    # 00403e51
    mov ecx, dword ptr [ebp - local_118]         # 00403e56
    mov edx, dword ptr [ecx + field_1c]          # 00403e5c
    push edx                                     # 00403e5f
    call dword ptr [0x52a4c8]                    # 00403e60
    mov dword ptr [ebp - local_124], 0x0         # 00403e66
    mov eax, dword ptr [ebp - local_128]         # 00403e70
    mov ecx, dword ptr [eax + field_4a0]         # 00403e76
    mov dword ptr [ebp - local_120], ecx         # 00403e7c
    push 0x0                                     # 00403e82
    mov edx, dword ptr [ebp - local_124]         # 00403e84
    push edx                                     # 00403e8a
    push 0xf1                                    # 00403e8b
    mov eax, dword ptr [ebp - local_120]         # 00403e90
    mov ecx, dword ptr [eax + field_1c]          # 00403e96
    push ecx                                     # 00403e99
    call dword ptr [0x52a4c8]                    # 00403e9a
L_00403ea0:
    # block 0x00403ea0: entered by jmp at 0x004038b0; jmp at 0x004039ba; jmp at 0x00403afa; jmp at 0x00403c39; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00403ea0
    pop ebp                                      # 00403ea2
    ret                                          # 00403ea3

