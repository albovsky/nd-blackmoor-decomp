# FUN_004be6a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be6a4
# extent:       0x004be6a4-0x004bed0b (1639 code bytes)
# span:         0x004be6a4-0x004bed40 (code 1639, tables 44, padding 9)
# sha256:       6573fcb184cf9adf7a6c9efd48a9b6169c39a5c2c3b2d3109e276803bdbdd5d0
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be6a4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 4 more
# fields:       [eax + n] field_80, field_128, field_150, field_544, field_704, field_minus_1; [ecx + n] field_78, field_84, field_12c, field_150, field_614, field_794, field_7bc; [edx + n] field_7c, field_128, field_150, field_534, field_684
# callees:      calls FUN_004c5377, FUN_004be1dd, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 414 instruction(s), 21 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_128, 0x128  # offset +0x128
.equ field_12c, 0x12c  # offset +0x12c
.equ field_150, 0x150  # offset +0x150
.equ field_534, 0x534  # offset +0x534
.equ field_544, 0x544  # offset +0x544
.equ field_614, 0x614  # offset +0x614
.equ field_684, 0x684  # offset +0x684
.equ field_704, 0x704  # offset +0x704
.equ field_794, 0x794  # offset +0x794
.equ field_7bc, 0x7bc  # offset +0x7bc

# --- external targets -----------------------------------------------
.set FUN_004be1dd, .text + (0x004be1dd - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004be6a4 - 0x401000
.globl FUN_004be6a4
FUN_004be6a4:
    # block 0x004be6a4: entry, 7 instruction(s), ends with jne to 0x004be6c0 (forward)
    push ebp                                     # 004be6a4
    {load} mov ebp, esp                          # 004be6a5
    sub esp, 0x40                                # 004be6a7
    mov eax, dword ptr [0x61df6e]                # 004be6aa
    mov dword ptr [ebp - local_1c], eax          # 004be6af
    cmp dword ptr [0x61df8a], 0x0                # 004be6b2
    jne.d8 L_004be6c0                            # 004be6b9
    # block 0x004be6bb: entered by fall-through of jne at 0x004be6b9, 1 instruction(s), ends with forward jump to 0x004bed07
    jmp.d32 L_004bed07                           # 004be6bb
L_004be6c0:
    # block 0x004be6c0: entered by jne at 0x004be6b9, 2 instruction(s), ends with je to 0x004be704 (forward)
    cmp dword ptr [0x61e10a], 0x0                # 004be6c0
    je.d8 L_004be704                             # 004be6c7
    # block 0x004be6c9: entered by fall-through of je at 0x004be6c7, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x004be704
    push 0x5521d0                                # 004be6c9
    push 0x61dfae                                # 004be6ce
    push 0x583196                                # 004be6d3
    mov ecx, dword ptr [0x5cf665]                # 004be6d8
    push ecx                                     # 004be6de
    mov edx, dword ptr [0x5d15e3]                # 004be6df
    push edx                                     # 004be6e5
    mov ecx, 0x5cf659                            # 004be6e6
    call FUN_004c5377                            # 004be6eb
    mov dword ptr [0x61e10a], 0x0                # 004be6f0
    mov dword ptr [0x61e106], 0x0                # 004be6fa
L_004be704:
    # block 0x004be704: entered by je at 0x004be6c7, 2 instruction(s), ends with je to 0x004be776 (forward)
    cmp dword ptr [0x61e106], 0x0                # 004be704
    je.d8 L_004be776                             # 004be70b
    # block 0x004be70d: entered by fall-through of je at 0x004be70b, 23 instruction(s), calls FUN_004c5377, falls into the block at 0x004be776
    mov eax, dword ptr [0x61e122]                # 004be70d
    sub eax, dword ptr [0x61e132]                # 004be712
    mov dword ptr [ebp - local_18], eax          # 004be718
    mov ecx, dword ptr [0x61e12a]                # 004be71b
    sub ecx, dword ptr [0x61e132]                # 004be721
    mov dword ptr [ebp - local_10], ecx          # 004be727
    mov edx, dword ptr [0x61e126]                # 004be72a
    sub edx, dword ptr [0x61e136]                # 004be730
    mov dword ptr [ebp - local_14], edx          # 004be736
    mov eax, dword ptr [0x61e12e]                # 004be739
    sub eax, dword ptr [0x61e136]                # 004be73e
    mov dword ptr [ebp - local_c], eax           # 004be744
    push 0x552200                                # 004be747
    push 0x61e122                                # 004be74c
    lea ecx, [ebp - local_18]                    # 004be751
    push ecx                                     # 004be754
    mov edx, dword ptr [0x5cf665]                # 004be755
    push edx                                     # 004be75b
    mov eax, dword ptr [0x5d15e3]                # 004be75c
    push eax                                     # 004be761
    mov ecx, 0x5cf659                            # 004be762
    call FUN_004c5377                            # 004be767
    mov dword ptr [0x61e106], 0x0                # 004be76c
L_004be776:
    # block 0x004be776: entered by je at 0x004be70b, 2 instruction(s), ends with je to 0x004be857 (forward)
    cmp dword ptr [0x61dfa2], 0x0                # 004be776
    je.d32 L_004be857                            # 004be77d
    # block 0x004be783: entered by fall-through of je at 0x004be77d, 2 instruction(s), falls into the block at 0x004be78c
    mov ecx, dword ptr [0x61dfa2]                # 004be783
    mov dword ptr [ebp - local_4], ecx           # 004be789
L_004be78c:
    # block 0x004be78c: entered by jmp at 0x004be852, 2 instruction(s), ends with je to 0x004be857 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004be78c
    je.d32 L_004be857                            # 004be790
    # block 0x004be796: entered by fall-through of je at 0x004be790, 3 instruction(s), ends with je to 0x004be818 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004be796
    cmp dword ptr [edx + field_128], 0x0         # 004be799
    je.d8 L_004be818                             # 004be7a0
    # block 0x004be7a2: entered by fall-through of je at 0x004be7a0, 30 instruction(s), calls FUN_004c5377, falls into the block at 0x004be818
    mov eax, dword ptr [ebp - local_4]           # 004be7a2
    mov dword ptr [eax + field_128], 0x0         # 004be7a5
    mov ecx, dword ptr [ebp - local_4]           # 004be7af
    mov edx, dword ptr [ecx + field_78]          # 004be7b2
    sub edx, dword ptr [0x61e132]                # 004be7b5
    mov dword ptr [ebp - local_2c], edx          # 004be7bb
    mov eax, dword ptr [ebp - local_4]           # 004be7be
    mov ecx, dword ptr [eax + field_80]          # 004be7c1
    sub ecx, dword ptr [0x61e132]                # 004be7c7
    mov dword ptr [ebp - local_24], ecx          # 004be7cd
    mov edx, dword ptr [ebp - local_4]           # 004be7d0
    mov eax, dword ptr [edx + field_7c]          # 004be7d3
    sub eax, dword ptr [0x61e136]                # 004be7d6
    mov dword ptr [ebp - local_28], eax          # 004be7dc
    mov ecx, dword ptr [ebp - local_4]           # 004be7df
    mov edx, dword ptr [ecx + field_84]          # 004be7e2
    sub edx, dword ptr [0x61e136]                # 004be7e8
    mov dword ptr [ebp - local_20], edx          # 004be7ee
    push 0x552228                                # 004be7f1
    mov eax, dword ptr [ebp - local_4]           # 004be7f6
    add eax, 0x78                                # 004be7f9
    push eax                                     # 004be7fc
    lea ecx, [ebp - local_2c]                    # 004be7fd
    push ecx                                     # 004be800
    mov edx, dword ptr [0x5cf665]                # 004be801
    push edx                                     # 004be807
    mov eax, dword ptr [0x5d15e3]                # 004be808
    push eax                                     # 004be80d
    mov ecx, 0x5cf659                            # 004be80e
    call FUN_004c5377                            # 004be813
L_004be818:
    # block 0x004be818: entered by je at 0x004be7a0, 3 instruction(s), ends with je to 0x004be846 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004be818
    cmp dword ptr [ecx + field_12c], 0x0         # 004be81b
    je.d8 L_004be846                             # 004be822
    # block 0x004be824: entered by fall-through of je at 0x004be822, 10 instruction(s), calls FUN_004be1dd, ends with forward jump to 0x004be852
    mov edx, dword ptr [ebp - local_4]           # 004be824
    mov eax, dword ptr [edx + field_150]         # 004be827
    mov dword ptr [ebp - local_30], eax          # 004be82d
    mov ecx, dword ptr [ebp - local_4]           # 004be830
    push ecx                                     # 004be833
    mov ecx, 0x61df56                            # 004be834
    call FUN_004be1dd                            # 004be839
    mov edx, dword ptr [ebp - local_30]          # 004be83e
    mov dword ptr [ebp - local_4], edx           # 004be841
    jmp.d8 L_004be852                            # 004be844
L_004be846:
    # block 0x004be846: entered by je at 0x004be822, 3 instruction(s), falls into the block at 0x004be852
    mov eax, dword ptr [ebp - local_4]           # 004be846
    mov ecx, dword ptr [eax + field_150]         # 004be849
    mov dword ptr [ebp - local_4], ecx           # 004be84f
L_004be852:
    # block 0x004be852: entered by jmp at 0x004be844, 1 instruction(s), ends with backward jump to 0x004be78c
    jmp.d32 L_004be78c                           # 004be852
L_004be857:
    # block 0x004be857: entered by je at 0x004be77d; je at 0x004be790, 4 instruction(s), ends with ja to 0x004bec3d (forward)
    mov edx, dword ptr [0x61df72]                # 004be857
    mov dword ptr [ebp - local_34], edx          # 004be85d
    cmp dword ptr [ebp - local_34], 0x6          # 004be860
    ja.d32 L_004bec3d                            # 004be864
    # block 0x004be86a: entered by fall-through of ja at 0x004be864, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4bed0b]
    mov eax, dword ptr [ebp - local_34]          # 004be86a
    jmp dword ptr [4*eax + SWTAB_004bed0b_VA]    # 004be86d
L_004be874:
    # block 0x004be874: entered by switch case, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004bec3d
    push 0x552250                                # 004be874
    push 0x61e03e                                # 004be879
    mov ecx, dword ptr [0x61df62]                # 004be87e
    add ecx, 0x35                                # 004be884
    push ecx                                     # 004be887
    mov edx, dword ptr [0x5cf665]                # 004be888
    push edx                                     # 004be88e
    mov eax, dword ptr [0x61df62]                # 004be88f
    push eax                                     # 004be894
    mov ecx, 0x5cf659                            # 004be895
    call FUN_004c5377                            # 004be89a
    jmp.d32 L_004bec3d                           # 004be89f
L_004be8a4:
    # block 0x004be8a4: entered by switch case, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004bec3d
    push 0x552278                                # 004be8a4
    push 0x61e03e                                # 004be8a9
    mov ecx, dword ptr [0x61df66]                # 004be8ae
    add ecx, 0x35                                # 004be8b4
    push ecx                                     # 004be8b7
    mov edx, dword ptr [0x5cf665]                # 004be8b8
    push edx                                     # 004be8be
    mov eax, dword ptr [0x61df66]                # 004be8bf
    push eax                                     # 004be8c4
    mov ecx, 0x5cf659                            # 004be8c5
    call FUN_004c5377                            # 004be8ca
    jmp.d32 L_004bec3d                           # 004be8cf
L_004be8d4:
    # block 0x004be8d4: entered by switch case, 2 instruction(s), ends with je to 0x004be908 (forward)
    cmp dword ptr [0x61df8e], 0x0                # 004be8d4
    je.d8 L_004be908                             # 004be8db
    # block 0x004be8dd: entered by fall-through of je at 0x004be8db, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x004be908
    push 0x5522a8                                # 004be8dd
    push 0x61e03e                                # 004be8e2
    mov ecx, dword ptr [0x61df6a]                # 004be8e7
    add ecx, 0x35                                # 004be8ed
    push ecx                                     # 004be8f0
    mov edx, dword ptr [0x5cf665]                # 004be8f1
    push edx                                     # 004be8f7
    mov eax, dword ptr [0x61df6a]                # 004be8f8
    push eax                                     # 004be8fd
    mov ecx, 0x5cf659                            # 004be8fe
    call FUN_004c5377                            # 004be903
L_004be908:
    # block 0x004be908: entered by je at 0x004be8db, 1 instruction(s), ends with forward jump to 0x004bec3d
    jmp.d32 L_004bec3d                           # 004be908
L_004be90d:
    # block 0x004be90d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004be91f
    mov dword ptr [ebp - local_8], 0x0           # 004be90d
    jmp.d8 L_004be91f                            # 004be914
L_004be916:
    # block 0x004be916: entered by jmp at 0x004be969, 3 instruction(s), falls into the block at 0x004be91f
    mov ecx, dword ptr [ebp - local_8]           # 004be916
    add ecx, 0x1                                 # 004be919
    mov dword ptr [ebp - local_8], ecx           # 004be91c
L_004be91f:
    # block 0x004be91f: entered by jmp at 0x004be914, 2 instruction(s), ends with jge to 0x004be96b (forward)
    cmp dword ptr [ebp - local_8], 0x7           # 004be91f
    jge.d8 L_004be96b                            # 004be923
    # block 0x004be925: entered by fall-through of jge at 0x004be923, 19 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004be916
    push 0x5522cc                                # 004be925
    mov edx, dword ptr [ebp - local_8]           # 004be92a
    shl edx, 0x4                                 # 004be92d
    add edx, 0x61e04e                            # 004be930
    push edx                                     # 004be936
    mov eax, dword ptr [ebp - local_8]           # 004be937
    shl eax, 0x4                                 # 004be93a
    mov ecx, dword ptr [ebp - local_1c]          # 004be93d
    lea edx, [ecx + eax + field_614]             # 004be940
    push edx                                     # 004be947
    mov eax, dword ptr [0x5cf665]                # 004be948
    push eax                                     # 004be94d
    movsx ecx, word ptr [0x61df5a]               # 004be94e
    imul ecx, ecx, 0x4a                          # 004be955
    mov edx, dword ptr [ecx + 0x5d1599]          # 004be958
    push edx                                     # 004be95e
    mov ecx, 0x5cf659                            # 004be95f
    call FUN_004c5d4b                            # 004be964
    jmp.d8 L_004be916                            # 004be969
L_004be96b:
    # block 0x004be96b: entered by jge at 0x004be923, 2 instruction(s), ends with je to 0x004be9c4 (forward)
    cmp dword ptr [0x61dfa2], 0x0                # 004be96b
    je.d8 L_004be9c4                             # 004be972
    # block 0x004be974: entered by fall-through of je at 0x004be972, 2 instruction(s), falls into the block at 0x004be97c
    mov eax, dword ptr [0x61dfa2]                # 004be974
    mov dword ptr [ebp - local_4], eax           # 004be979
L_004be97c:
    # block 0x004be97c: entered by jmp at 0x004be9c2, 2 instruction(s), ends with je to 0x004be9c4 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004be97c
    je.d8 L_004be9c4                             # 004be980
    # block 0x004be982: entered by fall-through of je at 0x004be980, 20 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004be97c
    mov ecx, dword ptr [ebp - local_4]           # 004be982
    push ecx                                     # 004be985
    mov edx, dword ptr [ebp - local_4]           # 004be986
    add edx, 0x68                                # 004be989
    push edx                                     # 004be98c
    mov eax, dword ptr [ebp - local_4]           # 004be98d
    add eax, 0x58                                # 004be990
    push eax                                     # 004be993
    mov ecx, dword ptr [0x5cf665]                # 004be994
    push ecx                                     # 004be99a
    movsx edx, word ptr [0x61df5a]               # 004be99b
    imul edx, edx, 0x4a                          # 004be9a2
    mov eax, dword ptr [edx + 0x5d1599]          # 004be9a5
    push eax                                     # 004be9ab
    mov ecx, 0x5cf659                            # 004be9ac
    call FUN_004c5d4b                            # 004be9b1
    mov ecx, dword ptr [ebp - local_4]           # 004be9b6
    mov edx, dword ptr [ecx + field_150]         # 004be9b9
    mov dword ptr [ebp - local_4], edx           # 004be9bf
    jmp.d8 L_004be97c                            # 004be9c2
L_004be9c4:
    # block 0x004be9c4: entered by je at 0x004be972; je at 0x004be980, 4 instruction(s), ends with je to 0x004be9e0 (forward)
    mov eax, dword ptr [0x61e21a]                # 004be9c4
    mov dword ptr [ebp - local_38], eax          # 004be9c9
    cmp dword ptr [ebp - local_38], 0x0          # 004be9cc
    je.d8 L_004be9e0                             # 004be9d0
    # block 0x004be9d2: entered by fall-through of je at 0x004be9d0, 2 instruction(s), ends with jle to 0x004bea50 (forward)
    cmp dword ptr [ebp - local_38], 0x0          # 004be9d2
    jle.d8 L_004bea50                            # 004be9d6
    # block 0x004be9d8: entered by fall-through of jle at 0x004be9d6, 2 instruction(s), ends with jle to 0x004bea0d (forward)
    cmp dword ptr [ebp - local_38], 0x8          # 004be9d8
    jle.d8 L_004bea0d                            # 004be9dc
    # block 0x004be9de: entered by fall-through of jle at 0x004be9dc, 1 instruction(s), ends with forward jump to 0x004bea50
    jmp.d8 L_004bea50                            # 004be9de
L_004be9e0:
    # block 0x004be9e0: entered by je at 0x004be9d0, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004bea50
    push 0x5522ec                                # 004be9e0
    push 0x61dfce                                # 004be9e5
    mov ecx, dword ptr [ebp - local_1c]          # 004be9ea
    add ecx, 0x7ac                               # 004be9ed
    push ecx                                     # 004be9f3
    mov edx, dword ptr [0x5cf665]                # 004be9f4
    push edx                                     # 004be9fa
    mov eax, dword ptr [0x5d15e3]                # 004be9fb
    push eax                                     # 004bea00
    mov ecx, 0x5cf659                            # 004bea01
    call FUN_004c5377                            # 004bea06
    jmp.d8 L_004bea50                            # 004bea0b
L_004bea0d:
    # block 0x004bea0d: entered by jle at 0x004be9dc, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004bea50
    push 0x552314                                # 004bea0d
    push 0x61dfce                                # 004bea12
    mov ecx, dword ptr [0x61e21a]                # 004bea17
    sub ecx, 0x1                                 # 004bea1d
    shl ecx, 0x4                                 # 004bea20
    mov edx, dword ptr [ebp - local_1c]          # 004bea23
    lea eax, [edx + ecx + field_684]             # 004bea26
    push eax                                     # 004bea2d
    mov ecx, dword ptr [0x5cf665]                # 004bea2e
    push ecx                                     # 004bea34
    movsx edx, word ptr [0x61df5a]               # 004bea35
    imul edx, edx, 0x4a                          # 004bea3c
    mov eax, dword ptr [edx + 0x5d1599]          # 004bea3f
    push eax                                     # 004bea45
    mov ecx, 0x5cf659                            # 004bea46
    call FUN_004c5377                            # 004bea4b
L_004bea50:
    # block 0x004bea50: entered by jle at 0x004be9d6; jmp at 0x004be9de; jmp at 0x004bea0b, 2 instruction(s), ends with forward jump to 0x004bea62
    mov dword ptr [ebp - local_8], 0x0           # 004bea50
    jmp.d8 L_004bea62                            # 004bea57
L_004bea59:
    # block 0x004bea59: entered by jmp at 0x004beaf3, 3 instruction(s), falls into the block at 0x004bea62
    mov ecx, dword ptr [ebp - local_8]           # 004bea59
    add ecx, 0x1                                 # 004bea5c
    mov dword ptr [ebp - local_8], ecx           # 004bea5f
L_004bea62:
    # block 0x004bea62: entered by jmp at 0x004bea57, 2 instruction(s), ends with jge to 0x004beaf8 (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 004bea62
    jge.d32 L_004beaf8                           # 004bea66
    # block 0x004bea6c: entered by fall-through of jge at 0x004bea66, 4 instruction(s), ends with jl to 0x004beab9 (forward)
    mov edx, dword ptr [0x61e226]                # 004bea6c
    sub edx, 0x1                                 # 004bea72
    cmp edx, dword ptr [ebp - local_8]           # 004bea75
    jl.d8 L_004beab9                             # 004bea78
    # block 0x004bea7a: entered by fall-through of jl at 0x004bea78, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004beaf3
    push 0x55233c                                # 004bea7a
    mov eax, dword ptr [ebp - local_8]           # 004bea7f
    shl eax, 0x4                                 # 004bea82
    add eax, 0x61dfde                            # 004bea85
    push eax                                     # 004bea8a
    mov ecx, dword ptr [ebp - local_1c]          # 004bea8b
    add ecx, 0xa4                                # 004bea8e
    push ecx                                     # 004bea94
    mov edx, dword ptr [0x5cf665]                # 004bea95
    push edx                                     # 004bea9b
    movsx eax, word ptr [0x61df5a]               # 004bea9c
    imul eax, eax, 0x4a                          # 004beaa3
    mov ecx, dword ptr [eax + 0x5d1599]          # 004beaa6
    push ecx                                     # 004beaac
    mov ecx, 0x5cf659                            # 004beaad
    call FUN_004c5d4b                            # 004beab2
    jmp.d8 L_004beaf3                            # 004beab7
L_004beab9:
    # block 0x004beab9: entered by jl at 0x004bea78, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004beaf3
    push 0x55235c                                # 004beab9
    mov edx, dword ptr [ebp - local_8]           # 004beabe
    shl edx, 0x4                                 # 004beac1
    add edx, 0x61dfde                            # 004beac4
    push edx                                     # 004beaca
    mov eax, dword ptr [ebp - local_8]           # 004beacb
    shl eax, 0x4                                 # 004beace
    mov ecx, dword ptr [ebp - local_1c]          # 004bead1
    lea edx, [ecx + eax + field_7bc]             # 004bead4
    push edx                                     # 004beadb
    mov eax, dword ptr [0x5cf665]                # 004beadc
    push eax                                     # 004beae1
    mov ecx, dword ptr [0x5d15e3]                # 004beae2
    push ecx                                     # 004beae8
    mov ecx, 0x5cf659                            # 004beae9
    call FUN_004c5377                            # 004beaee
L_004beaf3:
    # block 0x004beaf3: entered by jmp at 0x004beab7, 1 instruction(s), ends with backward jump to 0x004bea59
    jmp.d32 L_004bea59                           # 004beaf3
L_004beaf8:
    # block 0x004beaf8: entered by jge at 0x004bea66, 4 instruction(s), ends with ja to 0x004bec3d (forward)
    mov edx, dword ptr [0x61df76]                # 004beaf8
    mov dword ptr [ebp - local_3c], edx          # 004beafe
    cmp dword ptr [ebp - local_3c], 0x3          # 004beb01
    ja.d32 L_004bec3d                            # 004beb05
    # block 0x004beb0b: entered by fall-through of ja at 0x004beb05, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4bed27]
    mov eax, dword ptr [ebp - local_3c]          # 004beb0b
    jmp dword ptr [4*eax + SWTAB_004bed27_VA]    # 004beb0e
L_004beb15:
    # block 0x004beb15: entered by switch case, 14 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004bec3d
    push 0x55237c                                # 004beb15
    push 0x61e112                                # 004beb1a
    mov ecx, dword ptr [ebp - local_1c]          # 004beb1f
    add ecx, 0x84                                # 004beb22
    push ecx                                     # 004beb28
    mov edx, dword ptr [0x5cf665]                # 004beb29
    push edx                                     # 004beb2f
    movsx eax, word ptr [0x61df5a]               # 004beb30
    imul eax, eax, 0x4a                          # 004beb37
    mov ecx, dword ptr [eax + 0x5d1599]          # 004beb3a
    push ecx                                     # 004beb40
    mov ecx, 0x5cf659                            # 004beb41
    call FUN_004c5d4b                            # 004beb46
    jmp.d32 L_004bec3d                           # 004beb4b
L_004beb50:
    # block 0x004beb50: entered by switch case, 14 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004bec3d
    push 0x55239c                                # 004beb50
    push 0x61e112                                # 004beb55
    mov edx, dword ptr [ebp - local_1c]          # 004beb5a
    add edx, 0x94                                # 004beb5d
    push edx                                     # 004beb63
    mov eax, dword ptr [0x5cf665]                # 004beb64
    push eax                                     # 004beb69
    movsx ecx, word ptr [0x61df5a]               # 004beb6a
    imul ecx, ecx, 0x4a                          # 004beb71
    mov edx, dword ptr [ecx + 0x5d1599]          # 004beb74
    push edx                                     # 004beb7a
    mov ecx, 0x5cf659                            # 004beb7b
    call FUN_004c5d4b                            # 004beb80
    jmp.d32 L_004bec3d                           # 004beb85
L_004beb8a:
    # block 0x004beb8a: entered by switch case, 44 instruction(s), calls FUN_004c5377, FUN_004c5d4b, falls into the block at 0x004bec3d
    mov eax, dword ptr [0x61e112]                # 004beb8a
    add eax, dword ptr [0x61e0ea]                # 004beb8f
    mov ecx, dword ptr [ebp - local_1c]          # 004beb95
    add eax, dword ptr [ecx + field_794]         # 004beb98
    mov dword ptr [ebp - local_2c], eax          # 004beb9e
    mov edx, dword ptr [0x61e0ee]                # 004beba1
    mov eax, dword ptr [ebp - local_2c]          # 004beba7
    lea ecx, [eax + edx - field_minus_1]         # 004bebaa
    mov dword ptr [ebp - local_24], ecx          # 004bebae
    mov edx, dword ptr [0x61e0c6]                # 004bebb1
    mov dword ptr [ebp - local_20], edx          # 004bebb7
    mov eax, dword ptr [ebp - local_20]          # 004bebba
    sub eax, dword ptr [0x61e0f2]                # 004bebbd
    add eax, 0x1                                 # 004bebc3
    mov dword ptr [ebp - local_28], eax          # 004bebc6
    push 0x5523c0                                # 004bebc9
    lea ecx, [ebp - local_2c]                    # 004bebce
    push ecx                                     # 004bebd1
    mov edx, dword ptr [0x61e0f6]                # 004bebd2
    shl edx, 0x4                                 # 004bebd8
    mov eax, dword ptr [ebp - local_1c]          # 004bebdb
    lea ecx, [eax + edx + field_704]             # 004bebde
    push ecx                                     # 004bebe5
    mov edx, dword ptr [0x5cf665]                # 004bebe6
    push edx                                     # 004bebec
    movsx eax, word ptr [0x61df5a]               # 004bebed
    imul eax, eax, 0x4a                          # 004bebf4
    mov ecx, dword ptr [eax + 0x5d1599]          # 004bebf7
    push ecx                                     # 004bebfd
    mov ecx, 0x5cf659                            # 004bebfe
    call FUN_004c5377                            # 004bec03
    push 0x5523ec                                # 004bec08
    push 0x61e112                                # 004bec0d
    mov edx, dword ptr [ebp - local_1c]          # 004bec12
    add edx, 0x84                                # 004bec15
    push edx                                     # 004bec1b
    mov eax, dword ptr [0x5cf665]                # 004bec1c
    push eax                                     # 004bec21
    movsx ecx, word ptr [0x61df5a]               # 004bec22
    imul ecx, ecx, 0x4a                          # 004bec29
    mov edx, dword ptr [ecx + 0x5d1599]          # 004bec2c
    push edx                                     # 004bec32
    mov ecx, 0x5cf659                            # 004bec33
    call FUN_004c5d4b                            # 004bec38
L_004bec3d:
    # block 0x004bec3d: entered by ja at 0x004be864; jmp at 0x004be89f; jmp at 0x004be8cf; jmp at 0x004be908; more, 2 instruction(s), ends with forward jump to 0x004bec4f
    mov dword ptr [ebp - local_8], 0x0           # 004bec3d
    jmp.d8 L_004bec4f                            # 004bec44
L_004bec46:
    # block 0x004bec46: entered by jmp at 0x004bed02, 3 instruction(s), falls into the block at 0x004bec4f
    mov eax, dword ptr [ebp - local_8]           # 004bec46
    add eax, 0x1                                 # 004bec49
    mov dword ptr [ebp - local_8], eax           # 004bec4c
L_004bec4f:
    # block 0x004bec4f: entered by jmp at 0x004bec44, 2 instruction(s), ends with jge to 0x004bed07 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004bec4f
    jge.d32 L_004bed07                           # 004bec53
    # block 0x004bec59: entered by fall-through of jge at 0x004bec53, 5 instruction(s), ends with je to 0x004bec77 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bec59
    mov edx, dword ptr [8*ecx + 0x61df7a]        # 004bec5c
    mov dword ptr [ebp - local_40], edx          # 004bec63
    cmp dword ptr [ebp - local_40], 0x0          # 004bec66
    je.d8 L_004bec77                             # 004bec6a
    # block 0x004bec6c: entered by fall-through of je at 0x004bec6a, 2 instruction(s), ends with je to 0x004becbd (forward)
    cmp dword ptr [ebp - local_40], 0x1          # 004bec6c
    je.d8 L_004becbd                             # 004bec70
    # block 0x004bec72: entered by fall-through of je at 0x004bec70, 1 instruction(s), ends with forward jump to 0x004bed02
    jmp.d32 L_004bed02                           # 004bec72
L_004bec77:
    # block 0x004bec77: entered by je at 0x004bec6a, 19 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004bed02
    push 0x55240c                                # 004bec77
    mov eax, dword ptr [ebp - local_8]           # 004bec7c
    shl eax, 0x4                                 # 004bec7f
    add eax, 0x61e00e                            # 004bec82
    push eax                                     # 004bec87
    mov ecx, dword ptr [ebp - local_8]           # 004bec88
    shl ecx, 0x5                                 # 004bec8b
    mov edx, dword ptr [ebp - local_1c]          # 004bec8e
    lea eax, [edx + ecx + field_534]             # 004bec91
    push eax                                     # 004bec98
    mov ecx, dword ptr [0x5cf665]                # 004bec99
    push ecx                                     # 004bec9f
    movsx edx, word ptr [0x61df5a]               # 004beca0
    imul edx, edx, 0x4a                          # 004beca7
    mov eax, dword ptr [edx + 0x5d1599]          # 004becaa
    push eax                                     # 004becb0
    mov ecx, 0x5cf659                            # 004becb1
    call FUN_004c5377                            # 004becb6
    jmp.d8 L_004bed02                            # 004becbb
L_004becbd:
    # block 0x004becbd: entered by je at 0x004bec70, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x004bed02
    push 0x552430                                # 004becbd
    mov ecx, dword ptr [ebp - local_8]           # 004becc2
    shl ecx, 0x4                                 # 004becc5
    add ecx, 0x61e00e                            # 004becc8
    push ecx                                     # 004becce
    mov edx, dword ptr [ebp - local_8]           # 004beccf
    shl edx, 0x5                                 # 004becd2
    mov eax, dword ptr [ebp - local_1c]          # 004becd5
    lea ecx, [eax + edx + field_544]             # 004becd8
    push ecx                                     # 004becdf
    mov edx, dword ptr [0x5cf665]                # 004bece0
    push edx                                     # 004bece6
    movsx eax, word ptr [0x61df5a]               # 004bece7
    imul eax, eax, 0x4a                          # 004becee
    mov ecx, dword ptr [eax + 0x5d1599]          # 004becf1
    push ecx                                     # 004becf7
    mov ecx, 0x5cf659                            # 004becf8
    call FUN_004c5377                            # 004becfd
L_004bed02:
    # block 0x004bed02: entered by jmp at 0x004bec72; jmp at 0x004becbb, 1 instruction(s), ends with backward jump to 0x004bec46
    jmp.d32 L_004bec46                           # 004bed02
L_004bed07:
    # block 0x004bed07: entered by jmp at 0x004be6bb; jge at 0x004bec53, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bed07
    pop ebp                                      # 004bed09
    ret                                          # 004bed0a

# --- data items (not part of the function) -------------------------
.org 0x004bed0b - 0x401000
SWTAB_004bed0b:  # 7 case address(es)
    .long L_004be874 - .text + 0x401000
    .long L_004be90d - .text + 0x401000
    .long L_004be8d4 - .text + 0x401000
    .long L_004be8a4 - .text + 0x401000
    .long L_004bec3d - .text + 0x401000
    .long L_004bec3d - .text + 0x401000
    .long L_004be8d4 - .text + 0x401000
.org 0x004bed27 - 0x401000
SWTAB_004bed27:  # 4 case address(es)
    .long L_004beb15 - .text + 0x401000
    .long L_004beb8a - .text + 0x401000
    .long L_004beb15 - .text + 0x401000
    .long L_004beb50 - .text + 0x401000
.org 0x004bed37 - 0x401000
PAD_004bed37:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc
.set SWTAB_004bed0b_VA, SWTAB_004bed0b - .text + 0x401000
.set SWTAB_004bed27_VA, SWTAB_004bed27 - .text + 0x401000

