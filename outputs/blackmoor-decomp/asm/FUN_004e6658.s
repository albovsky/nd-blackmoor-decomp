# FUN_004e6658
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e6658
# extent:       0x004e6658-0x004e71da (2946 code bytes)
# span:         0x004e6658-0x004e71da (code 2946, tables 0, padding 0)
# sha256:       d54690229be03d218b49707ae77ad91b6abebdfa29f4bbfe40ac853e7687c465
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e6658
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_1e, local_20, local_24, local_28, local_2c and 4 more
# fields:       [eax + n] field_15f, field_6a7, field_6ce, field_719, field_71d, field_721, field_eb4, field_140a, field_140c, field_4528, field_4530; [ecx + n] field_4, field_8, field_c, field_6a5, field_6ce, field_719, field_725, field_eb0, field_f50, field_140a, field_4530, field_4577; [edx + n] field_6ce, field_71d, field_140a, field_140c, field_1ca2, field_4528, field_4530, field_4577
# callees:      calls FUN_004ee86f, FUN_004ee630, FUN_004c5377, FUN_004e2b99, FUN_004d2c20, FUN_004e6548, FUN_005193ca, FUN_004e2956, FUN_004e5fdb, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 781 instruction(s), 36 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_15f, 0x15f  # offset +0x15f
.equ field_6a5, 0x6a5  # offset +0x6a5
.equ field_6a7, 0x6a7  # offset +0x6a7
.equ field_6ce, 0x6ce  # offset +0x6ce
.equ field_719, 0x719  # offset +0x719
.equ field_71d, 0x71d  # offset +0x71d
.equ field_721, 0x721  # offset +0x721
.equ field_725, 0x725  # offset +0x725
.equ field_eb0, 0xeb0  # offset +0xeb0
.equ field_eb4, 0xeb4  # offset +0xeb4
.equ field_f50, 0xf50  # offset +0xf50
.equ field_140a, 0x140a  # offset +0x140a
.equ field_140c, 0x140c  # offset +0x140c
.equ field_1ca2, 0x1ca2  # offset +0x1ca2
.equ field_4528, 0x4528  # offset +0x4528
.equ field_4530, 0x4530  # offset +0x4530
.equ field_4577, 0x4577  # offset +0x4577

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_004e2956, .text + (0x004e2956 - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)
.set FUN_004e5fdb, .text + (0x004e5fdb - 0x401000)
.set FUN_004e6548, .text + (0x004e6548 - 0x401000)
.set FUN_004ee630, .text + (0x004ee630 - 0x401000)
.set FUN_004ee86f, .text + (0x004ee86f - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x004e6658 - 0x401000
.globl FUN_004e6658
FUN_004e6658:
    # block 0x004e6658: entry, 12 instruction(s), ends with je to 0x004e668e (forward)
    push ebp                                     # 004e6658
    {load} mov ebp, esp                          # 004e6659
    sub esp, 0x3c                                # 004e665b
    push esi                                     # 004e665e
    push edi                                     # 004e665f
    mov dword ptr [ebp - local_3c], ecx          # 004e6660
    mov eax, dword ptr [ebp - local_3c]          # 004e6663
    mov cx, word ptr [eax + field_eb4]           # 004e6666
    mov word ptr [ebp - local_8], cx             # 004e666d
    mov edx, dword ptr [ebp - local_3c]          # 004e6671
    cmp dword ptr [edx + field_4528], 0x2        # 004e6674
    je.d8 L_004e668e                             # 004e667b
    # block 0x004e667d: entered by fall-through of je at 0x004e667b, 3 instruction(s), ends with je to 0x004e668e (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e667d
    cmp dword ptr [eax + field_4528], 0x3        # 004e6680
    je.d8 L_004e668e                             # 004e6687
    # block 0x004e6689: entered by fall-through of je at 0x004e6687, 1 instruction(s), ends with forward jump to 0x004e71d4
    jmp.d32 L_004e71d4                           # 004e6689
L_004e668e:
    # block 0x004e668e: entered by je at 0x004e667b; je at 0x004e6687, 5 instruction(s), calls FUN_004ee86f, ends with je to 0x004e66d6 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e668e
    call FUN_004ee86f                            # 004e6691
    mov ecx, dword ptr [ebp - local_3c]          # 004e6696
    cmp dword ptr [ecx + field_4530], 0xc        # 004e6699
    je.d8 L_004e66d6                             # 004e66a0
    # block 0x004e66a2: entered by fall-through of je at 0x004e66a0, 3 instruction(s), ends with je to 0x004e66d6 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e66a2
    cmp dword ptr [edx + field_4530], 0xd        # 004e66a5
    je.d8 L_004e66d6                             # 004e66ac
    # block 0x004e66ae: entered by fall-through of je at 0x004e66ac, 3 instruction(s), ends with je to 0x004e66d6 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e66ae
    cmp dword ptr [eax + field_4530], 0xe        # 004e66b1
    je.d8 L_004e66d6                             # 004e66b8
    # block 0x004e66ba: entered by fall-through of je at 0x004e66b8, 3 instruction(s), ends with je to 0x004e66d6 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e66ba
    cmp dword ptr [ecx + field_4530], 0xf        # 004e66bd
    je.d8 L_004e66d6                             # 004e66c4
    # block 0x004e66c6: entered by fall-through of je at 0x004e66c4, 3 instruction(s), ends with jne to 0x004e6778 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e66c6
    cmp dword ptr [edx + field_4530], 0x10       # 004e66c9
    jne.d32 L_004e6778                           # 004e66d0
L_004e66d6:
    # block 0x004e66d6: entered by je at 0x004e66a0; je at 0x004e66ac; je at 0x004e66b8; je at 0x004e66c4; more, 37 instruction(s), calls FUN_004ee630, FUN_004c5377, FUN_004e2b99, ends with forward jump to 0x004e681f
    mov eax, dword ptr [ebp - local_3c]          # 004e66d6
    mov dword ptr [eax + field_15f], 0x0         # 004e66d9
    mov ecx, dword ptr [ebp - local_3c]          # 004e66e3
    mov edx, dword ptr [ecx + field_719]         # 004e66e6
    add edx, dword ptr [0x583186]                # 004e66ec
    mov dword ptr [ebp - local_18], edx          # 004e66f2
    mov eax, dword ptr [ebp - local_3c]          # 004e66f5
    mov ecx, dword ptr [eax + field_721]         # 004e66f8
    add ecx, dword ptr [0x583186]                # 004e66fe
    mov dword ptr [ebp - local_10], ecx          # 004e6704
    mov edx, dword ptr [ebp - local_3c]          # 004e6707
    mov eax, dword ptr [edx + field_71d]         # 004e670a
    add eax, dword ptr [0x58318a]                # 004e6710
    mov dword ptr [ebp - local_14], eax          # 004e6716
    mov ecx, dword ptr [ebp - local_3c]          # 004e6719
    mov edx, dword ptr [ecx + field_725]         # 004e671c
    add edx, dword ptr [0x58318a]                # 004e6722
    mov dword ptr [ebp - local_c], edx           # 004e6728
    push 0x55c1cc                                # 004e672b
    lea eax, [ebp - local_18]                    # 004e6730
    push eax                                     # 004e6733
    mov ecx, dword ptr [ebp - local_3c]          # 004e6734
    add ecx, 0x10bd                              # 004e6737
    push ecx                                     # 004e673d
    mov edx, dword ptr [0x5cf665]                # 004e673e
    push edx                                     # 004e6744
    mov ecx, dword ptr [ebp - local_3c]          # 004e6745
    call FUN_004ee630                            # 004e6748
    push eax                                     # 004e674d
    mov ecx, 0x5cf659                            # 004e674e
    call FUN_004c5377                            # 004e6753
    mov eax, dword ptr [ebp - local_3c]          # 004e6758
    mov dword ptr [eax + field_15f], 0x1         # 004e675b
    mov ecx, dword ptr [ebp - local_3c]          # 004e6765
    add ecx, 0x31c                               # 004e6768
    call FUN_004e2b99                            # 004e676e
    jmp.d32 L_004e681f                           # 004e6773
L_004e6778:
    # block 0x004e6778: entered by jne at 0x004e66d0, 45 instruction(s), calls FUN_004ee630, FUN_004c5377, falls into the block at 0x004e681f
    mov ecx, dword ptr [ebp - local_3c]          # 004e6778
    add ecx, 0xea0                               # 004e677b
    mov edx, dword ptr [ecx]                     # 004e6781
    mov dword ptr [ebp - local_18], edx          # 004e6783
    mov eax, dword ptr [ecx + field_4]           # 004e6786
    mov dword ptr [ebp - local_14], eax          # 004e6789
    mov edx, dword ptr [ecx + field_8]           # 004e678c
    mov dword ptr [ebp - local_10], edx          # 004e678f
    mov eax, dword ptr [ecx + field_c]           # 004e6792
    mov dword ptr [ebp - local_c], eax           # 004e6795
    mov ecx, dword ptr [ebp - local_3c]          # 004e6798
    mov edx, dword ptr [ecx + field_f50]         # 004e679b
    mov dword ptr [ebp - local_c], edx           # 004e67a1
    mov eax, dword ptr [ebp - local_3c]          # 004e67a4
    mov ecx, dword ptr [ebp - local_14]          # 004e67a7
    sub ecx, dword ptr [eax + field_71d]         # 004e67aa
    sub ecx, dword ptr [0x58318a]                # 004e67b0
    mov dword ptr [ebp - local_34], ecx          # 004e67b6
    mov edx, dword ptr [ebp - local_3c]          # 004e67b9
    mov eax, dword ptr [ebp - local_c]           # 004e67bc
    sub eax, dword ptr [edx + field_71d]         # 004e67bf
    sub eax, dword ptr [0x58318a]                # 004e67c5
    mov dword ptr [ebp - local_2c], eax          # 004e67cb
    mov ecx, dword ptr [ebp - local_3c]          # 004e67ce
    mov edx, dword ptr [ebp - local_18]          # 004e67d1
    sub edx, dword ptr [ecx + field_719]         # 004e67d4
    sub edx, dword ptr [0x583186]                # 004e67da
    mov dword ptr [ebp - local_38], edx          # 004e67e0
    mov eax, dword ptr [ebp - local_3c]          # 004e67e3
    mov ecx, dword ptr [ebp - local_10]          # 004e67e6
    sub ecx, dword ptr [eax + field_719]         # 004e67e9
    sub ecx, dword ptr [0x583186]                # 004e67ef
    mov dword ptr [ebp - local_30], ecx          # 004e67f5
    push 0x55c1e4                                # 004e67f8
    lea edx, [ebp - local_18]                    # 004e67fd
    push edx                                     # 004e6800
    lea eax, [ebp - local_38]                    # 004e6801
    push eax                                     # 004e6804
    mov ecx, dword ptr [0x5cf665]                # 004e6805
    push ecx                                     # 004e680b
    mov ecx, dword ptr [ebp - local_3c]          # 004e680c
    call FUN_004ee630                            # 004e680f
    push eax                                     # 004e6814
    mov ecx, 0x5cf659                            # 004e6815
    call FUN_004c5377                            # 004e681a
L_004e681f:
    # block 0x004e681f: entered by jmp at 0x004e6773, 3 instruction(s), ends with jne to 0x004e6b48 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e681f
    cmp dword ptr [edx + field_4530], 0x0        # 004e6822
    jne.d32 L_004e6b48                           # 004e6829
    # block 0x004e682f: entered by fall-through of jne at 0x004e6829, 2 instruction(s), ends with je to 0x004e686d (forward)
    cmp dword ptr [0x5a1e54], 0x0                # 004e682f
    je.d8 L_004e686d                             # 004e6836
    # block 0x004e6838: entered by fall-through of je at 0x004e6836, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e68a0
    push 0x55c1fc                                # 004e6838
    mov eax, dword ptr [ebp - local_3c]          # 004e683d
    add eax, 0x1015                              # 004e6840
    push eax                                     # 004e6845
    mov ecx, dword ptr [ebp - local_3c]          # 004e6846
    add ecx, 0x1005                              # 004e6849
    push ecx                                     # 004e684f
    mov edx, dword ptr [0x5cf665]                # 004e6850
    push edx                                     # 004e6856
    mov eax, dword ptr [ebp - local_3c]          # 004e6857
    mov ecx, dword ptr [eax + field_6ce]         # 004e685a
    push ecx                                     # 004e6860
    mov ecx, 0x5cf659                            # 004e6861
    call FUN_004c5377                            # 004e6866
    jmp.d8 L_004e68a0                            # 004e686b
L_004e686d:
    # block 0x004e686d: entered by je at 0x004e6836, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e68a0
    push 0x55c218                                # 004e686d
    mov edx, dword ptr [ebp - local_3c]          # 004e6872
    add edx, 0x1015                              # 004e6875
    push edx                                     # 004e687b
    mov eax, dword ptr [ebp - local_3c]          # 004e687c
    add eax, 0xff5                               # 004e687f
    push eax                                     # 004e6884
    mov ecx, dword ptr [0x5cf665]                # 004e6885
    push ecx                                     # 004e688b
    mov edx, dword ptr [ebp - local_3c]          # 004e688c
    mov eax, dword ptr [edx + field_6ce]         # 004e688f
    push eax                                     # 004e6895
    mov ecx, 0x5cf659                            # 004e6896
    call FUN_004c5377                            # 004e689b
L_004e68a0:
    # block 0x004e68a0: entered by jmp at 0x004e686b, 2 instruction(s), ends with je to 0x004e68e7 (forward)
    cmp dword ptr [0x5a1e58], 0x0                # 004e68a0
    je.d8 L_004e68e7                             # 004e68a7
    # block 0x004e68a9: entered by fall-through of je at 0x004e68a7, 2 instruction(s), ends with jne to 0x004e68e7 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 004e68a9
    jne.d8 L_004e68e7                            # 004e68b0
    # block 0x004e68b2: entered by fall-through of jne at 0x004e68b0, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e6923
    push 0x55c234                                # 004e68b2
    mov ecx, dword ptr [ebp - local_3c]          # 004e68b7
    add ecx, 0xfe5                               # 004e68ba
    push ecx                                     # 004e68c0
    mov edx, dword ptr [ebp - local_3c]          # 004e68c1
    add edx, 0xfd5                               # 004e68c4
    push edx                                     # 004e68ca
    mov eax, dword ptr [0x5cf665]                # 004e68cb
    push eax                                     # 004e68d0
    mov ecx, dword ptr [ebp - local_3c]          # 004e68d1
    mov edx, dword ptr [ecx + field_6ce]         # 004e68d4
    push edx                                     # 004e68da
    mov ecx, 0x5cf659                            # 004e68db
    call FUN_004c5377                            # 004e68e0
    jmp.d8 L_004e6923                            # 004e68e5
L_004e68e7:
    # block 0x004e68e7: entered by je at 0x004e68a7; jne at 0x004e68b0, 2 instruction(s), ends with jne to 0x004e6923 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 004e68e7
    jne.d8 L_004e6923                            # 004e68ee
    # block 0x004e68f0: entered by fall-through of jne at 0x004e68ee, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6923
    push 0x55c250                                # 004e68f0
    mov eax, dword ptr [ebp - local_3c]          # 004e68f5
    add eax, 0xfe5                               # 004e68f8
    push eax                                     # 004e68fd
    mov ecx, dword ptr [ebp - local_3c]          # 004e68fe
    add ecx, 0xfc5                               # 004e6901
    push ecx                                     # 004e6907
    mov edx, dword ptr [0x5cf665]                # 004e6908
    push edx                                     # 004e690e
    mov eax, dword ptr [ebp - local_3c]          # 004e690f
    mov ecx, dword ptr [eax + field_6ce]         # 004e6912
    push ecx                                     # 004e6918
    mov ecx, 0x5cf659                            # 004e6919
    call FUN_004c5377                            # 004e691e
L_004e6923:
    # block 0x004e6923: entered by jmp at 0x004e68e5; jne at 0x004e68ee, 30 instruction(s), calls FUN_004c5377, ends with je to 0x004e6af9 (forward)
    push 0x55c26c                                # 004e6923
    mov edx, dword ptr [ebp - local_3c]          # 004e6928
    add edx, 0xf44                               # 004e692b
    push edx                                     # 004e6931
    mov eax, dword ptr [ebp - local_3c]          # 004e6932
    add eax, 0xf34                               # 004e6935
    push eax                                     # 004e693a
    mov ecx, dword ptr [0x5cf665]                # 004e693b
    push ecx                                     # 004e6941
    mov edx, dword ptr [ebp - local_3c]          # 004e6942
    mov eax, dword ptr [edx + field_6ce]         # 004e6945
    push eax                                     # 004e694b
    mov ecx, 0x5cf659                            # 004e694c
    call FUN_004c5377                            # 004e6951
    push 0x55c284                                # 004e6956
    mov ecx, dword ptr [ebp - local_3c]          # 004e695b
    add ecx, 0xf64                               # 004e695e
    push ecx                                     # 004e6964
    mov edx, dword ptr [ebp - local_3c]          # 004e6965
    add edx, 0xf54                               # 004e6968
    push edx                                     # 004e696e
    mov eax, dword ptr [0x5cf665]                # 004e696f
    push eax                                     # 004e6974
    mov ecx, dword ptr [ebp - local_3c]          # 004e6975
    mov edx, dword ptr [ecx + field_6ce]         # 004e6978
    push edx                                     # 004e697e
    mov ecx, 0x5cf659                            # 004e697f
    call FUN_004c5377                            # 004e6984
    cmp dword ptr [0x5a1e58], 0x0                # 004e6989
    je.d32 L_004e6af9                            # 004e6990
    # block 0x004e6996: entered by fall-through of je at 0x004e6990, 7 instruction(s), ends with je to 0x004e6af9 (forward)
    mov edi, 0x63a9f4                            # 004e6996
    mov esi, dword ptr [ebp - local_3c]          # 004e699b
    add esi, 0xed8                               # 004e699e
    mov ecx, 0x1                                 # 004e69a4
    {load} xor eax, eax                          # 004e69a9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e69ab
    je.d32 L_004e6af9                            # 004e69ad
    # block 0x004e69b3: entered by fall-through of je at 0x004e69ad, 86 instruction(s), calls FUN_004d2c20, ends with forward jump to 0x004e6b48
    mov ecx, dword ptr [ebp - local_3c]          # 004e69b3
    mov edx, dword ptr [ecx + field_eb0]         # 004e69b6
    add edx, 0x1                                 # 004e69bc
    mov word ptr [ebp - local_4], dx             # 004e69bf
    push 0x0                                     # 004e69c3
    mov eax, dword ptr [0x5cf665]                # 004e69c5
    push eax                                     # 004e69ca
    mov ecx, dword ptr [ebp - local_3c]          # 004e69cb
    movsx edx, word ptr [ecx + field_140a]       # 004e69ce
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004e69d5
    push eax                                     # 004e69dc
    movsx ecx, word ptr [ebp - local_8]          # 004e69dd
    sub ecx, 0xa                                 # 004e69e1
    push ecx                                     # 004e69e4
    mov dx, word ptr [ebp - local_4]             # 004e69e5
    push edx                                     # 004e69e9
    mov eax, dword ptr [ebp - local_3c]          # 004e69ea
    movsx ecx, word ptr [eax + field_140a]       # 004e69ed
    imul ecx, ecx, 0x1d0                         # 004e69f4
    add ecx, 0x5adb3a                            # 004e69fa
    push ecx                                     # 004e6a00
    mov edx, dword ptr [ebp - local_3c]          # 004e6a01
    movsx eax, word ptr [edx + field_140a]       # 004e6a04
    imul eax, eax, 0x7f3                         # 004e6a0b
    add eax, 0x5a4c24                            # 004e6a11
    push eax                                     # 004e6a16
    mov ecx, dword ptr [ebp - local_3c]          # 004e6a17
    add ecx, 0xed8                               # 004e6a1a
    push ecx                                     # 004e6a20
    call FUN_004d2c20                            # 004e6a21
    add esp, 0x20                                # 004e6a26
    push 0x0                                     # 004e6a29
    mov edx, dword ptr [0x5cf665]                # 004e6a2b
    push edx                                     # 004e6a31
    mov eax, dword ptr [ebp - local_3c]          # 004e6a32
    movsx ecx, word ptr [eax + field_140a]       # 004e6a35
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004e6a3c
    push edx                                     # 004e6a43
    movsx eax, word ptr [ebp - local_8]          # 004e6a44
    add eax, 0x14                                # 004e6a48
    push eax                                     # 004e6a4b
    mov cx, word ptr [ebp - local_4]             # 004e6a4c
    push ecx                                     # 004e6a50
    mov edx, dword ptr [ebp - local_3c]          # 004e6a51
    movsx eax, word ptr [edx + field_140a]       # 004e6a54
    imul eax, eax, 0x1d0                         # 004e6a5b
    add eax, 0x5adb3a                            # 004e6a61
    push eax                                     # 004e6a66
    mov ecx, dword ptr [ebp - local_3c]          # 004e6a67
    movsx edx, word ptr [ecx + field_140a]       # 004e6a6a
    imul edx, edx, 0x7f3                         # 004e6a71
    add edx, 0x5a4c24                            # 004e6a77
    push edx                                     # 004e6a7d
    mov eax, dword ptr [ebp - local_3c]          # 004e6a7e
    add eax, 0xeec                               # 004e6a81
    push eax                                     # 004e6a86
    call FUN_004d2c20                            # 004e6a87
    add esp, 0x20                                # 004e6a8c
    push 0x0                                     # 004e6a8f
    mov ecx, dword ptr [0x5cf665]                # 004e6a91
    push ecx                                     # 004e6a97
    mov edx, dword ptr [ebp - local_3c]          # 004e6a98
    movsx eax, word ptr [edx + field_140a]       # 004e6a9b
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004e6aa2
    push ecx                                     # 004e6aa9
    movsx edx, word ptr [ebp - local_8]          # 004e6aaa
    add edx, 0x32                                # 004e6aae
    push edx                                     # 004e6ab1
    mov ax, word ptr [ebp - local_4]             # 004e6ab2
    push eax                                     # 004e6ab6
    mov ecx, dword ptr [ebp - local_3c]          # 004e6ab7
    movsx edx, word ptr [ecx + field_140a]       # 004e6aba
    imul edx, edx, 0x1d0                         # 004e6ac1
    add edx, 0x5adb3a                            # 004e6ac7
    push edx                                     # 004e6acd
    mov eax, dword ptr [ebp - local_3c]          # 004e6ace
    movsx ecx, word ptr [eax + field_140a]       # 004e6ad1
    imul ecx, ecx, 0x7f3                         # 004e6ad8
    add ecx, 0x5a4c24                            # 004e6ade
    push ecx                                     # 004e6ae4
    mov edx, dword ptr [ebp - local_3c]          # 004e6ae5
    add edx, 0xf00                               # 004e6ae8
    push edx                                     # 004e6aee
    call FUN_004d2c20                            # 004e6aef
    add esp, 0x20                                # 004e6af4
    jmp.d8 L_004e6b48                            # 004e6af7
L_004e6af9:
    # block 0x004e6af9: entered by je at 0x004e6990; je at 0x004e69ad, 2 instruction(s), ends with jne to 0x004e6b48 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 004e6af9
    jne.d8 L_004e6b48                            # 004e6b00
    # block 0x004e6b02: entered by fall-through of jne at 0x004e6b00, 19 instruction(s), calls FUN_004c5377, FUN_004e6548, falls into the block at 0x004e6b48
    push 0x55c29c                                # 004e6b02
    mov eax, dword ptr [ebp - local_3c]          # 004e6b07
    add eax, 0xec8                               # 004e6b0a
    push eax                                     # 004e6b0f
    mov ecx, dword ptr [ebp - local_3c]          # 004e6b10
    add ecx, 0xeb8                               # 004e6b13
    push ecx                                     # 004e6b19
    mov edx, dword ptr [0x5cf665]                # 004e6b1a
    push edx                                     # 004e6b20
    mov eax, dword ptr [ebp - local_3c]          # 004e6b21
    mov ecx, dword ptr [eax + field_6ce]         # 004e6b24
    push ecx                                     # 004e6b2a
    mov ecx, 0x5cf659                            # 004e6b2b
    call FUN_004c5377                            # 004e6b30
    mov edx, dword ptr [ebp - local_3c]          # 004e6b35
    mov ax, word ptr [edx + field_140c]          # 004e6b38
    push eax                                     # 004e6b3f
    mov ecx, dword ptr [ebp - local_3c]          # 004e6b40
    call FUN_004e6548                            # 004e6b43
L_004e6b48:
    # block 0x004e6b48: entered by jne at 0x004e6829; jmp at 0x004e6af7; jne at 0x004e6b00, 2 instruction(s), ends with je to 0x004e6bbc (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 004e6b48
    je.d8 L_004e6bbc                             # 004e6b4f
    # block 0x004e6b51: entered by fall-through of je at 0x004e6b4f, 29 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e71d4
    push 0x55c2b0                                # 004e6b51
    mov ecx, dword ptr [ebp - local_3c]          # 004e6b56
    add ecx, 0x1055                              # 004e6b59
    push ecx                                     # 004e6b5f
    mov edx, dword ptr [ebp - local_3c]          # 004e6b60
    add edx, 0x1045                              # 004e6b63
    push edx                                     # 004e6b69
    mov eax, dword ptr [0x5cf665]                # 004e6b6a
    push eax                                     # 004e6b6f
    mov ecx, dword ptr [ebp - local_3c]          # 004e6b70
    mov edx, dword ptr [ecx + field_6ce]         # 004e6b73
    push edx                                     # 004e6b79
    mov ecx, 0x5cf659                            # 004e6b7a
    call FUN_004c5377                            # 004e6b7f
    push 0x55c2cc                                # 004e6b84
    mov eax, dword ptr [ebp - local_3c]          # 004e6b89
    add eax, 0x1085                              # 004e6b8c
    push eax                                     # 004e6b91
    mov ecx, dword ptr [ebp - local_3c]          # 004e6b92
    add ecx, 0x1065                              # 004e6b95
    push ecx                                     # 004e6b9b
    mov edx, dword ptr [0x5cf665]                # 004e6b9c
    push edx                                     # 004e6ba2
    mov eax, dword ptr [ebp - local_3c]          # 004e6ba3
    mov ecx, dword ptr [eax + field_6ce]         # 004e6ba6
    push ecx                                     # 004e6bac
    mov ecx, 0x5cf659                            # 004e6bad
    call FUN_004c5377                            # 004e6bb2
    jmp.d32 L_004e71d4                           # 004e6bb7
L_004e6bbc:
    # block 0x004e6bbc: entered by je at 0x004e6b4f, 2 instruction(s), ends with forward jump to 0x004e6bd0
    mov word ptr [ebp - local_1c], 0x0           # 004e6bbc
    jmp.d8 L_004e6bd0                            # 004e6bc2
L_004e6bc4:
    # block 0x004e6bc4: entered by jmp at 0x004e6bf2, 3 instruction(s), falls into the block at 0x004e6bd0
    mov dx, word ptr [ebp - local_1c]            # 004e6bc4
    add dx, 0x1                                  # 004e6bc8
    mov word ptr [ebp - local_1c], dx            # 004e6bcc
L_004e6bd0:
    # block 0x004e6bd0: entered by jmp at 0x004e6bc2, 3 instruction(s), ends with jge to 0x004e6bf4 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 004e6bd0
    cmp eax, 0x1a                                # 004e6bd4
    jge.d8 L_004e6bf4                            # 004e6bd7
    # block 0x004e6bd9: entered by fall-through of jge at 0x004e6bd7, 6 instruction(s), calls FUN_004e2b99, ends with backward jump to 0x004e6bc4
    movsx ecx, word ptr [ebp - local_1c]         # 004e6bd9
    imul ecx, ecx, 0x18f                         # 004e6bdd
    mov edx, dword ptr [ebp - local_3c]          # 004e6be3
    lea ecx, [edx + ecx + field_1ca2]            # 004e6be6
    call FUN_004e2b99                            # 004e6bed
    jmp.d8 L_004e6bc4                            # 004e6bf2
L_004e6bf4:
    # block 0x004e6bf4: entered by jge at 0x004e6bd7, 3 instruction(s), ends with jge to 0x004e6e6a (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e6bf4
    cmp dword ptr [eax + field_4530], 0x9        # 004e6bf7
    jge.d32 L_004e6e6a                           # 004e6bfe
    # block 0x004e6c04: entered by fall-through of jge at 0x004e6bfe, 4 instruction(s), ends with jle to 0x004e6d96 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e6c04
    movsx edx, word ptr [ecx + field_6a5]        # 004e6c07
    test edx, edx                                # 004e6c0e
    jle.d32 L_004e6d96                           # 004e6c10
    # block 0x004e6c16: entered by fall-through of jle at 0x004e6c10, 38 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e6cad
    push 0x55c2ec                                # 004e6c16
    mov eax, dword ptr [ebp - local_3c]          # 004e6c1b
    add eax, 0xf24                               # 004e6c1e
    push eax                                     # 004e6c23
    mov ecx, dword ptr [ebp - local_3c]          # 004e6c24
    add ecx, 0xf14                               # 004e6c27
    push ecx                                     # 004e6c2d
    mov edx, dword ptr [0x5cf665]                # 004e6c2e
    push edx                                     # 004e6c34
    mov eax, dword ptr [ebp - local_3c]          # 004e6c35
    mov ecx, dword ptr [eax + field_6ce]         # 004e6c38
    push ecx                                     # 004e6c3e
    mov ecx, 0x5cf659                            # 004e6c3f
    call FUN_004c5377                            # 004e6c44
    push 0x55c304                                # 004e6c49
    mov edx, dword ptr [ebp - local_3c]          # 004e6c4e
    add edx, 0x1035                              # 004e6c51
    push edx                                     # 004e6c57
    mov eax, dword ptr [ebp - local_3c]          # 004e6c58
    add eax, 0x1025                              # 004e6c5b
    push eax                                     # 004e6c60
    mov ecx, dword ptr [0x5cf665]                # 004e6c61
    push ecx                                     # 004e6c67
    mov edx, dword ptr [ebp - local_3c]          # 004e6c68
    mov eax, dword ptr [edx + field_6ce]         # 004e6c6b
    push eax                                     # 004e6c71
    mov ecx, 0x5cf659                            # 004e6c72
    call FUN_004c5377                            # 004e6c77
    mov ecx, dword ptr [ebp - local_3c]          # 004e6c7c
    mov dx, word ptr [ecx + field_eb0]           # 004e6c7f
    mov word ptr [ebp - local_4], dx             # 004e6c86
    {load} xor eax, eax                          # 004e6c8a
    mov dword ptr [ebp - local_28], eax          # 004e6c8c
    mov dword ptr [ebp - local_24], eax          # 004e6c8f
    mov word ptr [ebp - local_20], ax            # 004e6c92
    mov byte ptr [ebp - local_1e], al            # 004e6c96
    mov word ptr [ebp - local_1c], 0x0           # 004e6c99
    jmp.d8 L_004e6cad                            # 004e6c9f
L_004e6ca1:
    # block 0x004e6ca1: entered by jmp at 0x004e6cec, 3 instruction(s), falls into the block at 0x004e6cad
    mov cx, word ptr [ebp - local_1c]            # 004e6ca1
    add cx, 0x1                                  # 004e6ca5
    mov word ptr [ebp - local_1c], cx            # 004e6ca9
L_004e6cad:
    # block 0x004e6cad: entered by jmp at 0x004e6c9f, 3 instruction(s), ends with jge to 0x004e6cee (forward)
    movsx edx, word ptr [ebp - local_1c]         # 004e6cad
    cmp edx, 0xb                                 # 004e6cb1
    jge.d8 L_004e6cee                            # 004e6cb4
    # block 0x004e6cb6: entered by fall-through of jge at 0x004e6cb4, 5 instruction(s), ends with jge to 0x004e6cee (forward)
    movsx eax, word ptr [ebp - local_1c]         # 004e6cb6
    mov ecx, dword ptr [ebp - local_3c]          # 004e6cba
    movsx edx, word ptr [ecx + field_6a5]        # 004e6cbd
    {load} cmp eax, edx                          # 004e6cc4
    jge.d8 L_004e6cee                            # 004e6cc6
    # block 0x004e6cc8: entered by fall-through of jge at 0x004e6cc6, 12 instruction(s), calls FUN_005193ca, ends with backward jump to 0x004e6ca1
    push 0xa                                     # 004e6cc8
    movsx eax, word ptr [ebp - local_1c]         # 004e6cca
    lea ecx, [ebp + eax - local_28]              # 004e6cce
    push ecx                                     # 004e6cd2
    movsx edx, word ptr [ebp - local_1c]         # 004e6cd3
    mov eax, dword ptr [ebp - local_3c]          # 004e6cd7
    {load} xor ecx, ecx                          # 004e6cda
    mov cl, byte ptr [eax + edx + field_6a7]     # 004e6cdc
    push ecx                                     # 004e6ce3
    call FUN_005193ca                            # 004e6ce4
    add esp, 0xc                                 # 004e6ce9
    jmp.d8 L_004e6ca1                            # 004e6cec
L_004e6cee:
    # block 0x004e6cee: entered by jge at 0x004e6cb4; jge at 0x004e6cc6, 30 instruction(s), calls FUN_004d2c20, FUN_004e2956, ends with jne to 0x004e6d91 (forward)
    push 0x0                                     # 004e6cee
    mov edx, dword ptr [0x5cf665]                # 004e6cf0
    push edx                                     # 004e6cf6
    mov eax, dword ptr [ebp - local_3c]          # 004e6cf7
    movsx ecx, word ptr [eax + field_140a]       # 004e6cfa
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004e6d01
    push edx                                     # 004e6d08
    mov ax, word ptr [ebp - local_8]             # 004e6d09
    push eax                                     # 004e6d0d
    mov cx, word ptr [ebp - local_4]             # 004e6d0e
    push ecx                                     # 004e6d12
    mov edx, dword ptr [ebp - local_3c]          # 004e6d13
    movsx eax, word ptr [edx + field_140a]       # 004e6d16
    imul eax, eax, 0x1d0                         # 004e6d1d
    add eax, 0x5adb3a                            # 004e6d23
    push eax                                     # 004e6d28
    mov ecx, dword ptr [ebp - local_3c]          # 004e6d29
    movsx edx, word ptr [ecx + field_140a]       # 004e6d2c
    imul edx, edx, 0x7f3                         # 004e6d33
    add edx, 0x5a4c24                            # 004e6d39
    push edx                                     # 004e6d3f
    lea eax, [ebp - local_28]                    # 004e6d40
    push eax                                     # 004e6d43
    call FUN_004d2c20                            # 004e6d44
    add esp, 0x20                                # 004e6d49
    mov ecx, dword ptr [ebp - local_3c]          # 004e6d4c
    add ecx, 0x2f56                              # 004e6d4f
    call FUN_004e2956                            # 004e6d55
    test eax, eax                                # 004e6d5a
    jne.d8 L_004e6d91                            # 004e6d5c
    # block 0x004e6d5e: entered by fall-through of jne at 0x004e6d5c, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6d91
    push 0x55c31c                                # 004e6d5e
    mov ecx, dword ptr [ebp - local_3c]          # 004e6d63
    add ecx, 0xe90                               # 004e6d66
    push ecx                                     # 004e6d6c
    mov edx, dword ptr [ebp - local_3c]          # 004e6d6d
    add edx, 0xe80                               # 004e6d70
    push edx                                     # 004e6d76
    mov eax, dword ptr [0x5cf665]                # 004e6d77
    push eax                                     # 004e6d7c
    mov ecx, dword ptr [ebp - local_3c]          # 004e6d7d
    mov edx, dword ptr [ecx + field_6ce]         # 004e6d80
    push edx                                     # 004e6d86
    mov ecx, 0x5cf659                            # 004e6d87
    call FUN_004c5377                            # 004e6d8c
L_004e6d91:
    # block 0x004e6d91: entered by jne at 0x004e6d5c, 1 instruction(s), ends with forward jump to 0x004e6e65
    jmp.d32 L_004e6e65                           # 004e6d91
L_004e6d96:
    # block 0x004e6d96: entered by jle at 0x004e6c10, 3 instruction(s), ends with jl to 0x004e6e26 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e6d96
    cmp dword ptr [eax + field_4530], 0x2        # 004e6d99
    jl.d32 L_004e6e26                            # 004e6da0
    # block 0x004e6da6: entered by fall-through of jl at 0x004e6da0, 3 instruction(s), ends with jg to 0x004e6e26 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e6da6
    cmp dword ptr [ecx + field_4530], 0x6        # 004e6da9
    jg.d8 L_004e6e26                             # 004e6db0
    # block 0x004e6db2: entered by fall-through of jg at 0x004e6db0, 3 instruction(s), ends with jne to 0x004e6df1 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e6db2
    cmp dword ptr [edx + field_4530], 0x6        # 004e6db5
    jne.d8 L_004e6df1                            # 004e6dbc
    # block 0x004e6dbe: entered by fall-through of jne at 0x004e6dbc, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6df1
    push 0x55c334                                # 004e6dbe
    mov eax, dword ptr [ebp - local_3c]          # 004e6dc3
    add eax, 0x1055                              # 004e6dc6
    push eax                                     # 004e6dcb
    mov ecx, dword ptr [ebp - local_3c]          # 004e6dcc
    add ecx, 0x1045                              # 004e6dcf
    push ecx                                     # 004e6dd5
    mov edx, dword ptr [0x5cf665]                # 004e6dd6
    push edx                                     # 004e6ddc
    mov eax, dword ptr [ebp - local_3c]          # 004e6ddd
    mov ecx, dword ptr [eax + field_6ce]         # 004e6de0
    push ecx                                     # 004e6de6
    mov ecx, 0x5cf659                            # 004e6de7
    call FUN_004c5377                            # 004e6dec
L_004e6df1:
    # block 0x004e6df1: entered by jne at 0x004e6dbc, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e6e65
    push 0x55c34c                                # 004e6df1
    mov edx, dword ptr [ebp - local_3c]          # 004e6df6
    add edx, 0x1085                              # 004e6df9
    push edx                                     # 004e6dff
    mov eax, dword ptr [ebp - local_3c]          # 004e6e00
    add eax, 0x1065                              # 004e6e03
    push eax                                     # 004e6e08
    mov ecx, dword ptr [0x5cf665]                # 004e6e09
    push ecx                                     # 004e6e0f
    mov edx, dword ptr [ebp - local_3c]          # 004e6e10
    mov eax, dword ptr [edx + field_6ce]         # 004e6e13
    push eax                                     # 004e6e19
    mov ecx, 0x5cf659                            # 004e6e1a
    call FUN_004c5377                            # 004e6e1f
    jmp.d8 L_004e6e65                            # 004e6e24
L_004e6e26:
    # block 0x004e6e26: entered by jl at 0x004e6da0; jg at 0x004e6db0, 3 instruction(s), ends with jne to 0x004e6e65 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e6e26
    cmp dword ptr [ecx + field_4530], 0x8        # 004e6e29
    jne.d8 L_004e6e65                            # 004e6e30
    # block 0x004e6e32: entered by fall-through of jne at 0x004e6e30, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6e65
    push 0x55c36c                                # 004e6e32
    mov edx, dword ptr [ebp - local_3c]          # 004e6e37
    add edx, 0x1085                              # 004e6e3a
    push edx                                     # 004e6e40
    mov eax, dword ptr [ebp - local_3c]          # 004e6e41
    add eax, 0x1075                              # 004e6e44
    push eax                                     # 004e6e49
    mov ecx, dword ptr [0x5cf665]                # 004e6e4a
    push ecx                                     # 004e6e50
    mov edx, dword ptr [ebp - local_3c]          # 004e6e51
    mov eax, dword ptr [edx + field_6ce]         # 004e6e54
    push eax                                     # 004e6e5a
    mov ecx, 0x5cf659                            # 004e6e5b
    call FUN_004c5377                            # 004e6e60
L_004e6e65:
    # block 0x004e6e65: entered by jmp at 0x004e6d91; jmp at 0x004e6e24; jne at 0x004e6e30, 1 instruction(s), ends with forward jump to 0x004e71d4
    jmp.d32 L_004e71d4                           # 004e6e65
L_004e6e6a:
    # block 0x004e6e6a: entered by jge at 0x004e6bfe, 3 instruction(s), ends with jne to 0x004e6f4a (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e6e6a
    cmp dword ptr [ecx + field_4530], 0x9        # 004e6e6d
    jne.d32 L_004e6f4a                           # 004e6e74
    # block 0x004e6e7a: entered by fall-through of jne at 0x004e6e74, 42 instruction(s), calls FUN_004e5fdb, FUN_004c5377, FUN_004e2956, ends with jne to 0x004e6f45 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e6e7a
    mov ax, word ptr [edx + field_140c]          # 004e6e7d
    push eax                                     # 004e6e84
    mov ecx, dword ptr [ebp - local_3c]          # 004e6e85
    mov dx, word ptr [ecx + field_4577]          # 004e6e88
    push edx                                     # 004e6e8f
    push 0x9                                     # 004e6e90
    mov ecx, dword ptr [ebp - local_3c]          # 004e6e92
    call FUN_004e5fdb                            # 004e6e95
    push 0x55c38c                                # 004e6e9a
    mov eax, dword ptr [ebp - local_3c]          # 004e6e9f
    add eax, 0x695                               # 004e6ea2
    push eax                                     # 004e6ea7
    mov ecx, dword ptr [ebp - local_3c]          # 004e6ea8
    add ecx, 0x10dd                              # 004e6eab
    push ecx                                     # 004e6eb1
    mov edx, dword ptr [0x5cf665]                # 004e6eb2
    push edx                                     # 004e6eb8
    mov eax, dword ptr [ebp - local_3c]          # 004e6eb9
    mov ecx, dword ptr [eax + field_6ce]         # 004e6ebc
    push ecx                                     # 004e6ec2
    mov ecx, 0x5cf659                            # 004e6ec3
    call FUN_004c5377                            # 004e6ec8
    push 0x55c3a4                                # 004e6ecd
    mov edx, dword ptr [ebp - local_3c]          # 004e6ed2
    add edx, 0x110d                              # 004e6ed5
    push edx                                     # 004e6edb
    mov eax, dword ptr [ebp - local_3c]          # 004e6edc
    add eax, 0x10fd                              # 004e6edf
    push eax                                     # 004e6ee4
    mov ecx, dword ptr [0x5cf665]                # 004e6ee5
    push ecx                                     # 004e6eeb
    mov edx, dword ptr [ebp - local_3c]          # 004e6eec
    mov eax, dword ptr [edx + field_6ce]         # 004e6eef
    push eax                                     # 004e6ef5
    mov ecx, 0x5cf659                            # 004e6ef6
    call FUN_004c5377                            # 004e6efb
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f00
    add ecx, 0x2f56                              # 004e6f03
    call FUN_004e2956                            # 004e6f09
    test eax, eax                                # 004e6f0e
    jne.d8 L_004e6f45                            # 004e6f10
    # block 0x004e6f12: entered by fall-through of jne at 0x004e6f10, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6f45
    push 0x55c3bc                                # 004e6f12
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f17
    add ecx, 0xe90                               # 004e6f1a
    push ecx                                     # 004e6f20
    mov edx, dword ptr [ebp - local_3c]          # 004e6f21
    add edx, 0xe80                               # 004e6f24
    push edx                                     # 004e6f2a
    mov eax, dword ptr [0x5cf665]                # 004e6f2b
    push eax                                     # 004e6f30
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f31
    mov edx, dword ptr [ecx + field_6ce]         # 004e6f34
    push edx                                     # 004e6f3a
    mov ecx, 0x5cf659                            # 004e6f3b
    call FUN_004c5377                            # 004e6f40
L_004e6f45:
    # block 0x004e6f45: entered by jne at 0x004e6f10, 1 instruction(s), ends with forward jump to 0x004e71d4
    jmp.d32 L_004e71d4                           # 004e6f45
L_004e6f4a:
    # block 0x004e6f4a: entered by jne at 0x004e6e74, 3 instruction(s), ends with jne to 0x004e6f8e (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e6f4a
    cmp dword ptr [eax + field_4530], 0xb        # 004e6f4d
    jne.d8 L_004e6f8e                            # 004e6f54
    # block 0x004e6f56: entered by fall-through of jne at 0x004e6f54, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e71d4
    push 0x55c3d4                                # 004e6f56
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f5b
    add ecx, 0x10ad                              # 004e6f5e
    push ecx                                     # 004e6f64
    mov edx, dword ptr [ebp - local_3c]          # 004e6f65
    add edx, 0x109d                              # 004e6f68
    push edx                                     # 004e6f6e
    mov eax, dword ptr [0x5cf665]                # 004e6f6f
    push eax                                     # 004e6f74
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f75
    mov edx, dword ptr [ecx + field_6ce]         # 004e6f78
    push edx                                     # 004e6f7e
    mov ecx, 0x5cf659                            # 004e6f7f
    call FUN_004c5377                            # 004e6f84
    jmp.d32 L_004e71d4                           # 004e6f89
L_004e6f8e:
    # block 0x004e6f8e: entered by jne at 0x004e6f54, 3 instruction(s), ends with jne to 0x004e7001 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e6f8e
    cmp dword ptr [eax + field_4530], 0xa        # 004e6f91
    jne.d8 L_004e7001                            # 004e6f98
    # block 0x004e6f9a: entered by fall-through of jne at 0x004e6f98, 28 instruction(s), calls FUN_004c5377, FUN_004c5d4b, ends with forward jump to 0x004e71d4
    push 0x55c3f0                                # 004e6f9a
    mov ecx, dword ptr [ebp - local_3c]          # 004e6f9f
    add ecx, 0x136d                              # 004e6fa2
    push ecx                                     # 004e6fa8
    mov edx, dword ptr [ebp - local_3c]          # 004e6fa9
    add edx, 0x135d                              # 004e6fac
    push edx                                     # 004e6fb2
    mov eax, dword ptr [0x5cf665]                # 004e6fb3
    push eax                                     # 004e6fb8
    mov ecx, dword ptr [ebp - local_3c]          # 004e6fb9
    mov edx, dword ptr [ecx + field_6ce]         # 004e6fbc
    push edx                                     # 004e6fc2
    mov ecx, 0x5cf659                            # 004e6fc3
    call FUN_004c5377                            # 004e6fc8
    push 0x55c408                                # 004e6fcd
    mov eax, dword ptr [ebp - local_3c]          # 004e6fd2
    add eax, 0x53d7                              # 004e6fd5
    push eax                                     # 004e6fda
    mov ecx, dword ptr [ebp - local_3c]          # 004e6fdb
    add ecx, 0x53c7                              # 004e6fde
    push ecx                                     # 004e6fe4
    mov edx, dword ptr [0x5cf665]                # 004e6fe5
    push edx                                     # 004e6feb
    mov eax, dword ptr [0x5d039f]                # 004e6fec
    push eax                                     # 004e6ff1
    mov ecx, 0x5cf659                            # 004e6ff2
    call FUN_004c5d4b                            # 004e6ff7
    jmp.d32 L_004e71d4                           # 004e6ffc
L_004e7001:
    # block 0x004e7001: entered by jne at 0x004e6f98, 3 instruction(s), ends with je to 0x004e7019 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e7001
    cmp dword ptr [ecx + field_4530], 0xe        # 004e7004
    je.d8 L_004e7019                             # 004e700b
    # block 0x004e700d: entered by fall-through of je at 0x004e700b, 3 instruction(s), ends with jne to 0x004e707a (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e700d
    cmp dword ptr [edx + field_4530], 0xf        # 004e7010
    jne.d8 L_004e707a                            # 004e7017
L_004e7019:
    # block 0x004e7019: entered by je at 0x004e700b; fall-through of jne at 0x004e7017, 26 instruction(s), calls FUN_004c5377, FUN_004e5fdb, ends with forward jump to 0x004e71d4
    push 0x55c424                                # 004e7019
    mov eax, dword ptr [ebp - local_3c]          # 004e701e
    add eax, 0x134d                              # 004e7021
    push eax                                     # 004e7026
    mov ecx, dword ptr [ebp - local_3c]          # 004e7027
    add ecx, 0x133d                              # 004e702a
    push ecx                                     # 004e7030
    mov edx, dword ptr [0x5cf665]                # 004e7031
    push edx                                     # 004e7037
    mov eax, dword ptr [ebp - local_3c]          # 004e7038
    mov ecx, dword ptr [eax + field_6ce]         # 004e703b
    push ecx                                     # 004e7041
    mov ecx, 0x5cf659                            # 004e7042
    call FUN_004c5377                            # 004e7047
    mov edx, dword ptr [ebp - local_3c]          # 004e704c
    mov ax, word ptr [edx + field_140c]          # 004e704f
    push eax                                     # 004e7056
    mov ecx, dword ptr [ebp - local_3c]          # 004e7057
    mov dx, word ptr [ecx + field_4577]          # 004e705a
    push edx                                     # 004e7061
    mov eax, dword ptr [ebp - local_3c]          # 004e7062
    mov cx, word ptr [eax + field_4530]          # 004e7065
    push ecx                                     # 004e706c
    mov ecx, dword ptr [ebp - local_3c]          # 004e706d
    call FUN_004e5fdb                            # 004e7070
    jmp.d32 L_004e71d4                           # 004e7075
L_004e707a:
    # block 0x004e707a: entered by jne at 0x004e7017, 3 instruction(s), ends with jne to 0x004e70ee (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004e707a
    cmp dword ptr [edx + field_4530], 0x10       # 004e707d
    jne.d8 L_004e70ee                            # 004e7084
    # block 0x004e7086: entered by fall-through of jne at 0x004e7084, 28 instruction(s), calls FUN_004c5377, FUN_004c5d4b, ends with forward jump to 0x004e71d4
    push 0x55c440                                # 004e7086
    mov eax, dword ptr [ebp - local_3c]          # 004e708b
    add eax, 0x134d                              # 004e708e
    push eax                                     # 004e7093
    mov ecx, dword ptr [ebp - local_3c]          # 004e7094
    add ecx, 0x133d                              # 004e7097
    push ecx                                     # 004e709d
    mov edx, dword ptr [0x5cf665]                # 004e709e
    push edx                                     # 004e70a4
    mov eax, dword ptr [ebp - local_3c]          # 004e70a5
    mov ecx, dword ptr [eax + field_6ce]         # 004e70a8
    push ecx                                     # 004e70ae
    mov ecx, 0x5cf659                            # 004e70af
    call FUN_004c5377                            # 004e70b4
    push 0x55c45c                                # 004e70b9
    mov edx, dword ptr [ebp - local_3c]          # 004e70be
    add edx, 0x53d7                              # 004e70c1
    push edx                                     # 004e70c7
    mov eax, dword ptr [ebp - local_3c]          # 004e70c8
    add eax, 0x53c7                              # 004e70cb
    push eax                                     # 004e70d0
    mov ecx, dword ptr [0x5cf665]                # 004e70d1
    push ecx                                     # 004e70d7
    mov edx, dword ptr [0x5d039f]                # 004e70d8
    push edx                                     # 004e70de
    mov ecx, 0x5cf659                            # 004e70df
    call FUN_004c5d4b                            # 004e70e4
    jmp.d32 L_004e71d4                           # 004e70e9
L_004e70ee:
    # block 0x004e70ee: entered by jne at 0x004e7084, 3 instruction(s), ends with jne to 0x004e7152 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004e70ee
    cmp dword ptr [eax + field_4530], 0xd        # 004e70f1
    jne.d8 L_004e7152                            # 004e70f8
    # block 0x004e70fa: entered by fall-through of jne at 0x004e70f8, 24 instruction(s), calls FUN_004c5377, FUN_004e5fdb, ends with forward jump to 0x004e71d4
    push 0x55c478                                # 004e70fa
    mov ecx, dword ptr [ebp - local_3c]          # 004e70ff
    add ecx, 0x130d                              # 004e7102
    push ecx                                     # 004e7108
    mov edx, dword ptr [ebp - local_3c]          # 004e7109
    add edx, 0x12fd                              # 004e710c
    push edx                                     # 004e7112
    mov eax, dword ptr [0x5cf665]                # 004e7113
    push eax                                     # 004e7118
    mov ecx, dword ptr [ebp - local_3c]          # 004e7119
    mov edx, dword ptr [ecx + field_6ce]         # 004e711c
    push edx                                     # 004e7122
    mov ecx, 0x5cf659                            # 004e7123
    call FUN_004c5377                            # 004e7128
    mov eax, dword ptr [ebp - local_3c]          # 004e712d
    mov cx, word ptr [eax + field_140c]          # 004e7130
    push ecx                                     # 004e7137
    mov edx, dword ptr [ebp - local_3c]          # 004e7138
    mov ax, word ptr [edx + field_4577]          # 004e713b
    push eax                                     # 004e7142
    push 0xd                                     # 004e7143
    mov ecx, dword ptr [ebp - local_3c]          # 004e7145
    call FUN_004e5fdb                            # 004e7148
    jmp.d32 L_004e71d4                           # 004e714d
L_004e7152:
    # block 0x004e7152: entered by jne at 0x004e70f8, 3 instruction(s), ends with jne to 0x004e71d4 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e7152
    cmp dword ptr [ecx + field_4530], 0xc        # 004e7155
    jne.d8 L_004e71d4                            # 004e715c
    # block 0x004e715e: entered by fall-through of jne at 0x004e715c, 5 instruction(s), calls FUN_004e2956, ends with jne to 0x004e71a4 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004e715e
    add ecx, 0x420a                              # 004e7161
    call FUN_004e2956                            # 004e7167
    cmp eax, 0x4                                 # 004e716c
    jne.d8 L_004e71a4                            # 004e716f
    # block 0x004e7171: entered by fall-through of jne at 0x004e716f, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e71a4
    push 0x55c494                                # 004e7171
    mov edx, dword ptr [ebp - local_3c]          # 004e7176
    add edx, 0x138d                              # 004e7179
    push edx                                     # 004e717f
    mov eax, dword ptr [ebp - local_3c]          # 004e7180
    add eax, 0x137d                              # 004e7183
    push eax                                     # 004e7188
    mov ecx, dword ptr [0x5cf665]                # 004e7189
    push ecx                                     # 004e718f
    mov edx, dword ptr [ebp - local_3c]          # 004e7190
    mov eax, dword ptr [edx + field_6ce]         # 004e7193
    push eax                                     # 004e7199
    mov ecx, 0x5cf659                            # 004e719a
    call FUN_004c5377                            # 004e719f
L_004e71a4:
    # block 0x004e71a4: entered by jne at 0x004e716f, 13 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004e71d4
    push 0x55c4b0                                # 004e71a4
    mov ecx, dword ptr [ebp - local_3c]          # 004e71a9
    add ecx, 0x53d7                              # 004e71ac
    push ecx                                     # 004e71b2
    mov edx, dword ptr [ebp - local_3c]          # 004e71b3
    add edx, 0x53c7                              # 004e71b6
    push edx                                     # 004e71bc
    mov eax, dword ptr [0x5cf665]                # 004e71bd
    push eax                                     # 004e71c2
    mov ecx, dword ptr [0x5d039f]                # 004e71c3
    push ecx                                     # 004e71c9
    mov ecx, 0x5cf659                            # 004e71ca
    call FUN_004c5d4b                            # 004e71cf
L_004e71d4:
    # block 0x004e71d4: entered by jmp at 0x004e6689; jmp at 0x004e6bb7; jmp at 0x004e6e65; jmp at 0x004e6f45; more, 5 instruction(s), ends with ret
    pop edi                                      # 004e71d4
    pop esi                                      # 004e71d5
    {load} mov esp, ebp                          # 004e71d6
    pop ebp                                      # 004e71d8
    ret                                          # 004e71d9

