# FUN_0043a7ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043a7ca
# extent:       0x0043a7ca-0x0043d1c3 (10745 code bytes)
# span:         0x0043a7ca-0x0043d227 (code 10745, tables 100, padding 0)
# sha256:       6dfc2184c04912c59fafa7ff6d193853c2dd732f123688d42e6ac623d05c5237
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043a7ca
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       38 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 26 more
# fields:       [eax + n] field_8, field_c, field_14, field_49, field_de; [ecx + n] field_4, field_14, field_18, field_21, field_23, field_de, field_e0, field_138, field_169, field_256, field_292, field_557; [edi + n] field_4, field_6; [edx + n] field_4, field_10, field_18, field_21, field_23, field_138, field_292
# callees:      calls KERNEL32.dll!GetTickCount, FUN_0043d7f0, FUN_004dadff, FUN_004fafc7, FUN_004e8622, FUN_004e8994, FUN_004e89b9, FUN_004e94c1, FUN_004ebb5b, FUN_004ebd2e, FUN_004ebd53, FUN_004ec9a2, FUN_004e3093, FUN_004e3525, FUN_004e40fb, FUN_004e4cb6 and 103 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2335 instruction(s), 299 conditional branch(es) and 5 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
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
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_49, 0x49  # offset +0x49
.equ field_de, 0xde  # offset +0xde
.equ field_e0, 0xe0  # offset +0xe0
.equ field_138, 0x138  # offset +0x138
.equ field_169, 0x169  # offset +0x169
.equ field_256, 0x256  # offset +0x256
.equ field_292, 0x292  # offset +0x292
.equ field_557, 0x557  # offset +0x557

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_00415176, .text + (0x00415176 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00423f57, .text + (0x00423f57 - 0x401000)
.set FUN_00423fbb, .text + (0x00423fbb - 0x401000)
.set FUN_00424035, .text + (0x00424035 - 0x401000)
.set FUN_0042405a, .text + (0x0042405a - 0x401000)
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_00427a50, .text + (0x00427a50 - 0x401000)
.set FUN_0042ad27, .text + (0x0042ad27 - 0x401000)
.set FUN_0042ae0a, .text + (0x0042ae0a - 0x401000)
.set FUN_0042e5c6, .text + (0x0042e5c6 - 0x401000)
.set FUN_00433bd2, .text + (0x00433bd2 - 0x401000)
.set FUN_0043d6be, .text + (0x0043d6be - 0x401000)
.set FUN_0043d7f0, .text + (0x0043d7f0 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044a32c, .text + (0x0044a32c - 0x401000)
.set FUN_0044d624, .text + (0x0044d624 - 0x401000)
.set FUN_0044edfb, .text + (0x0044edfb - 0x401000)
.set FUN_0045565f, .text + (0x0045565f - 0x401000)
.set FUN_004574e4, .text + (0x004574e4 - 0x401000)
.set FUN_004588ad, .text + (0x004588ad - 0x401000)
.set FUN_00459e49, .text + (0x00459e49 - 0x401000)
.set FUN_0045b872, .text + (0x0045b872 - 0x401000)
.set FUN_0045e587, .text + (0x0045e587 - 0x401000)
.set FUN_004631d1, .text + (0x004631d1 - 0x401000)
.set FUN_00464c59, .text + (0x00464c59 - 0x401000)
.set FUN_00466073, .text + (0x00466073 - 0x401000)
.set FUN_0046793a, .text + (0x0046793a - 0x401000)
.set FUN_0046957d, .text + (0x0046957d - 0x401000)
.set FUN_0046c6a9, .text + (0x0046c6a9 - 0x401000)
.set FUN_0046ebff, .text + (0x0046ebff - 0x401000)
.set FUN_004712bd, .text + (0x004712bd - 0x401000)
.set FUN_00473ffc, .text + (0x00473ffc - 0x401000)
.set FUN_0047608e, .text + (0x0047608e - 0x401000)
.set FUN_0047a03c, .text + (0x0047a03c - 0x401000)
.set FUN_0047b767, .text + (0x0047b767 - 0x401000)
.set FUN_0047d77d, .text + (0x0047d77d - 0x401000)
.set FUN_0047ef0f, .text + (0x0047ef0f - 0x401000)
.set FUN_0047ff0e, .text + (0x0047ff0e - 0x401000)
.set FUN_00482724, .text + (0x00482724 - 0x401000)
.set FUN_00484ac0, .text + (0x00484ac0 - 0x401000)
.set FUN_0048569e, .text + (0x0048569e - 0x401000)
.set FUN_00487ed5, .text + (0x00487ed5 - 0x401000)
.set FUN_0048ab49, .text + (0x0048ab49 - 0x401000)
.set FUN_0048c0ac, .text + (0x0048c0ac - 0x401000)
.set FUN_0048c148, .text + (0x0048c148 - 0x401000)
.set FUN_0048d5f4, .text + (0x0048d5f4 - 0x401000)
.set FUN_0048e851, .text + (0x0048e851 - 0x401000)
.set FUN_00493a47, .text + (0x00493a47 - 0x401000)
.set FUN_004a1efd, .text + (0x004a1efd - 0x401000)
.set FUN_004a44c0, .text + (0x004a44c0 - 0x401000)
.set FUN_004a6946, .text + (0x004a6946 - 0x401000)
.set FUN_004a8818, .text + (0x004a8818 - 0x401000)
.set FUN_004aa3d2, .text + (0x004aa3d2 - 0x401000)
.set FUN_004ab899, .text + (0x004ab899 - 0x401000)
.set FUN_004ad310, .text + (0x004ad310 - 0x401000)
.set FUN_004ad590, .text + (0x004ad590 - 0x401000)
.set FUN_004b2a9e, .text + (0x004b2a9e - 0x401000)
.set FUN_004b45ed, .text + (0x004b45ed - 0x401000)
.set FUN_004b617a, .text + (0x004b617a - 0x401000)
.set FUN_004b7563, .text + (0x004b7563 - 0x401000)
.set FUN_004b82cd, .text + (0x004b82cd - 0x401000)
.set FUN_004ba4f2, .text + (0x004ba4f2 - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004bf1f0, .text + (0x004bf1f0 - 0x401000)
.set FUN_004c3c5d, .text + (0x004c3c5d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cb3ab, .text + (0x004cb3ab - 0x401000)
.set FUN_004cf9f4, .text + (0x004cf9f4 - 0x401000)
.set FUN_004d3073, .text + (0x004d3073 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004d3c1d, .text + (0x004d3c1d - 0x401000)
.set FUN_004d3c31, .text + (0x004d3c31 - 0x401000)
.set FUN_004d3c42, .text + (0x004d3c42 - 0x401000)
.set FUN_004d3d20, .text + (0x004d3d20 - 0x401000)
.set FUN_004d3d48, .text + (0x004d3d48 - 0x401000)
.set FUN_004d4043, .text + (0x004d4043 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004daf3f, .text + (0x004daf3f - 0x401000)
.set FUN_004daf6e, .text + (0x004daf6e - 0x401000)
.set FUN_004de413, .text + (0x004de413 - 0x401000)
.set FUN_004de4f9, .text + (0x004de4f9 - 0x401000)
.set FUN_004e0978, .text + (0x004e0978 - 0x401000)
.set FUN_004e0e2b, .text + (0x004e0e2b - 0x401000)
.set FUN_004e3093, .text + (0x004e3093 - 0x401000)
.set FUN_004e3525, .text + (0x004e3525 - 0x401000)
.set FUN_004e40fb, .text + (0x004e40fb - 0x401000)
.set FUN_004e467f, .text + (0x004e467f - 0x401000)
.set FUN_004e4cb6, .text + (0x004e4cb6 - 0x401000)
.set FUN_004e78c2, .text + (0x004e78c2 - 0x401000)
.set FUN_004e7970, .text + (0x004e7970 - 0x401000)
.set FUN_004e812f, .text + (0x004e812f - 0x401000)
.set FUN_004e8622, .text + (0x004e8622 - 0x401000)
.set FUN_004e8994, .text + (0x004e8994 - 0x401000)
.set FUN_004e89b9, .text + (0x004e89b9 - 0x401000)
.set FUN_004e8dc8, .text + (0x004e8dc8 - 0x401000)
.set FUN_004e94c1, .text + (0x004e94c1 - 0x401000)
.set FUN_004ea361, .text + (0x004ea361 - 0x401000)
.set FUN_004eb107, .text + (0x004eb107 - 0x401000)
.set FUN_004eb184, .text + (0x004eb184 - 0x401000)
.set FUN_004ebb5b, .text + (0x004ebb5b - 0x401000)
.set FUN_004ebd2e, .text + (0x004ebd2e - 0x401000)
.set FUN_004ebd53, .text + (0x004ebd53 - 0x401000)
.set FUN_004ec087, .text + (0x004ec087 - 0x401000)
.set FUN_004ec9a2, .text + (0x004ec9a2 - 0x401000)
.set FUN_004ee5cd, .text + (0x004ee5cd - 0x401000)
.set FUN_004f52a9, .text + (0x004f52a9 - 0x401000)
.set FUN_004f7c36, .text + (0x004f7c36 - 0x401000)
.set FUN_004fafc7, .text + (0x004fafc7 - 0x401000)
.set FUN_004fb086, .text + (0x004fb086 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fc05d, .text + (0x004fc05d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0043a7ca - 0x401000
.globl FUN_0043a7ca
FUN_0043a7ca:
    # block 0x0043a7ca: entry, 14 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0043d7f0, FUN_004dadff, ends with jne to 0x0043a80e (forward)
    push ebp                                     # 0043a7ca
    {load} mov ebp, esp                          # 0043a7cb
    sub esp, 0xfc                                # 0043a7cd
    push esi                                     # 0043a7d3
    push edi                                     # 0043a7d4
    call dword ptr [0x52a23c]                    # 0043a7d5
    mov dword ptr [ebp - local_4], eax           # 0043a7db
    mov dword ptr [ebp - local_14], 0x0          # 0043a7de
    mov dword ptr [ebp - local_40], 0xffffffff   # 0043a7e5
    call FUN_0043d7f0                            # 0043a7ec
    mov ecx, 0x5830a6                            # 0043a7f1
    call FUN_004dadff                            # 0043a7f6
    cmp dword ptr [0x583204], 0x1                # 0043a7fb
    jne.d8 L_0043a80e                            # 0043a802
    # block 0x0043a804: entered by fall-through of jne at 0x0043a802, 1 instruction(s), falls into the block at 0x0043a80e
    mov dword ptr [0x583204], 0x0                # 0043a804
L_0043a80e:
    # block 0x0043a80e: entered by jne at 0x0043a802, 4 instruction(s), ends with je to 0x0043a856 (forward)
    {load} xor eax, eax                          # 0043a80e
    mov al, byte ptr [0x583220]                  # 0043a810
    test eax, eax                                # 0043a815
    je.d8 L_0043a856                             # 0043a817
    # block 0x0043a819: entered by fall-through of je at 0x0043a817, 9 instruction(s), calls FUN_004fafc7, ends with forward jump to 0x0043d1bd
    mov byte ptr [0x583220], 0x0                 # 0043a819
    mov ecx, dword ptr [ebp - local_4]           # 0043a820
    mov dword ptr [0x585d5d], ecx                # 0043a823
    mov dword ptr [0x583985], 0xe                # 0043a829
    mov dword ptr [0x583981], 0x6                # 0043a833
    mov dword ptr [0x5839a1], 0x0                # 0043a83d
    mov ecx, 0x5c3a67                            # 0043a847
    call FUN_004fafc7                            # 0043a84c
    jmp.d32 L_0043d1bd                           # 0043a851
L_0043a856:
    # block 0x0043a856: entered by je at 0x0043a817, 4 instruction(s), ends with je to 0x0043a8b7 (forward)
    {load} xor edx, edx                          # 0043a856
    mov dl, byte ptr [0x583232]                  # 0043a858
    test edx, edx                                # 0043a85e
    je.d8 L_0043a8b7                             # 0043a860
    # block 0x0043a862: entered by fall-through of je at 0x0043a860, 2 instruction(s), ends with jne to 0x0043a8b7 (forward)
    cmp dword ptr [0x583204], 0x0                # 0043a862
    jne.d8 L_0043a8b7                            # 0043a869
    # block 0x0043a86b: entered by fall-through of jne at 0x0043a869, 14 instruction(s), calls FUN_004e8622, FUN_004e8994, FUN_004e89b9, FUN_004e94c1, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x583985], 0xe                # 0043a86b
    mov byte ptr [0x583232], 0x0                 # 0043a875
    mov dword ptr [0x583204], 0x3                # 0043a87c
    mov ecx, 0x571442                            # 0043a886
    call FUN_004e8622                            # 0043a88b
    push 0x2                                     # 0043a890
    mov ecx, 0x571442                            # 0043a892
    call FUN_004e8994                            # 0043a897
    push 0x0                                     # 0043a89c
    mov ecx, 0x571442                            # 0043a89e
    call FUN_004e89b9                            # 0043a8a3
    mov ecx, 0x571442                            # 0043a8a8
    call FUN_004e94c1                            # 0043a8ad
    jmp.d32 L_0043d1bd                           # 0043a8b2
L_0043a8b7:
    # block 0x0043a8b7: entered by je at 0x0043a860; jne at 0x0043a869, 4 instruction(s), ends with je to 0x0043a917 (forward)
    {load} xor eax, eax                          # 0043a8b7
    mov al, byte ptr [0x583233]                  # 0043a8b9
    test eax, eax                                # 0043a8be
    je.d8 L_0043a917                             # 0043a8c0
    # block 0x0043a8c2: entered by fall-through of je at 0x0043a8c0, 2 instruction(s), ends with jne to 0x0043a917 (forward)
    cmp dword ptr [0x583204], 0x0                # 0043a8c2
    jne.d8 L_0043a917                            # 0043a8c9
    # block 0x0043a8cb: entered by fall-through of jne at 0x0043a8c9, 14 instruction(s), calls FUN_004ebb5b, FUN_004ebd2e, FUN_004ebd53, FUN_004ec9a2, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x583985], 0xe                # 0043a8cb
    mov byte ptr [0x583233], 0x0                 # 0043a8d5
    mov dword ptr [0x583204], 0x4                # 0043a8dc
    mov ecx, 0x57fd34                            # 0043a8e6
    call FUN_004ebb5b                            # 0043a8eb
    push 0x2                                     # 0043a8f0
    mov ecx, 0x57fd34                            # 0043a8f2
    call FUN_004ebd2e                            # 0043a8f7
    push 0x0                                     # 0043a8fc
    mov ecx, 0x57fd34                            # 0043a8fe
    call FUN_004ebd53                            # 0043a903
    mov ecx, 0x57fd34                            # 0043a908
    call FUN_004ec9a2                            # 0043a90d
    jmp.d32 L_0043d1bd                           # 0043a912
L_0043a917:
    # block 0x0043a917: entered by je at 0x0043a8c0; jne at 0x0043a8c9, 4 instruction(s), ends with je to 0x0043a978 (forward)
    {load} xor ecx, ecx                          # 0043a917
    mov cl, byte ptr [0x583234]                  # 0043a919
    test ecx, ecx                                # 0043a91f
    je.d8 L_0043a978                             # 0043a921
    # block 0x0043a923: entered by fall-through of je at 0x0043a921, 2 instruction(s), ends with jne to 0x0043a978 (forward)
    cmp dword ptr [0x583204], 0x0                # 0043a923
    jne.d8 L_0043a978                            # 0043a92a
    # block 0x0043a92c: entered by fall-through of jne at 0x0043a92a, 14 instruction(s), calls FUN_004e3093, FUN_004e3525, FUN_004e40fb, FUN_004e4cb6, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x583985], 0xe                # 0043a92c
    mov byte ptr [0x583234], 0x0                 # 0043a936
    mov dword ptr [0x583204], 0x5                # 0043a93d
    mov ecx, 0x57975c                            # 0043a947
    call FUN_004e3093                            # 0043a94c
    push 0x2                                     # 0043a951
    mov ecx, 0x57975c                            # 0043a953
    call FUN_004e3525                            # 0043a958
    push 0x0                                     # 0043a95d
    mov ecx, 0x57975c                            # 0043a95f
    call FUN_004e40fb                            # 0043a964
    mov ecx, 0x57975c                            # 0043a969
    call FUN_004e4cb6                            # 0043a96e
    jmp.d32 L_0043d1bd                           # 0043a973
L_0043a978:
    # block 0x0043a978: entered by je at 0x0043a921; jne at 0x0043a92a, 4 instruction(s), ends with je to 0x0043a9c0 (forward)
    {load} xor edx, edx                          # 0043a978
    mov dl, byte ptr [0x58321f]                  # 0043a97a
    test edx, edx                                # 0043a980
    je.d8 L_0043a9c0                             # 0043a982
    # block 0x0043a984: entered by fall-through of je at 0x0043a982, 9 instruction(s), calls FUN_004fafc7, ends with forward jump to 0x0043d1bd
    mov eax, dword ptr [ebp - local_4]           # 0043a984
    mov dword ptr [0x585d5d], eax                # 0043a987
    mov dword ptr [0x583985], 0xe                # 0043a98c
    mov dword ptr [0x583981], 0xa                # 0043a996
    mov dword ptr [0x5839a5], 0x0                # 0043a9a0
    mov byte ptr [0x58321f], 0x0                 # 0043a9aa
    mov ecx, 0x5c3a67                            # 0043a9b1
    call FUN_004fafc7                            # 0043a9b6
    jmp.d32 L_0043d1bd                           # 0043a9bb
L_0043a9c0:
    # block 0x0043a9c0: entered by je at 0x0043a982, 4 instruction(s), ends with je to 0x0043aa09 (forward)
    {load} xor ecx, ecx                          # 0043a9c0
    mov cl, byte ptr [0x583229]                  # 0043a9c2
    test ecx, ecx                                # 0043a9c8
    je.d8 L_0043aa09                             # 0043a9ca
    # block 0x0043a9cc: entered by fall-through of je at 0x0043a9ca, 9 instruction(s), calls FUN_004fafc7, ends with forward jump to 0x0043d1bd
    mov edx, dword ptr [ebp - local_4]           # 0043a9cc
    mov dword ptr [0x585d5d], edx                # 0043a9cf
    mov dword ptr [0x583985], 0xe                # 0043a9d5
    mov dword ptr [0x583981], 0x10               # 0043a9df
    mov dword ptr [0x5839ad], 0x0                # 0043a9e9
    mov byte ptr [0x583229], 0x0                 # 0043a9f3
    mov ecx, 0x5c3a67                            # 0043a9fa
    call FUN_004fafc7                            # 0043a9ff
    jmp.d32 L_0043d1bd                           # 0043aa04
L_0043aa09:
    # block 0x0043aa09: entered by je at 0x0043a9ca, 2 instruction(s), ends with je to 0x0043ab7d (forward)
    cmp dword ptr [0x583985], 0xe                # 0043aa09
    je.d32 L_0043ab7d                            # 0043aa10
    # block 0x0043aa16: entered by fall-through of je at 0x0043aa10, 6 instruction(s), calls FUN_004f52a9, ends with jne to 0x0043ab41 (forward)
    mov ecx, 0x5cf1eb                            # 0043aa16
    call FUN_004f52a9                            # 0043aa1b
    mov eax, dword ptr [ebp - local_4]           # 0043aa20
    mov dword ptr [0x585d61], eax                # 0043aa23
    cmp dword ptr [0x5e32b5], 0x0                # 0043aa28
    jne.d32 L_0043ab41                           # 0043aa2f
    # block 0x0043aa35: entered by fall-through of jne at 0x0043aa2f, 3 instruction(s), ends with jbe to 0x0043ab41 (forward)
    mov ecx, dword ptr [0x585d61]                # 0043aa35
    cmp ecx, dword ptr [0x585d5d]                # 0043aa3b
    jbe.d32 L_0043ab41                           # 0043aa41
    # block 0x0043aa47: entered by fall-through of jbe at 0x0043aa41, 11 instruction(s), ends with jge to 0x0043aa85 (forward)
    mov edx, dword ptr [0x585d61]                # 0043aa47
    sub edx, dword ptr [0x585d5d]                # 0043aa4d
    mov dword ptr [ebp - local_3c], edx          # 0043aa53
    mov eax, dword ptr [0x585d37]                # 0043aa56
    sub eax, dword ptr [ebp - local_3c]          # 0043aa5b
    mov dword ptr [0x585d37], eax                # 0043aa5e
    mov ecx, dword ptr [0x585d41]                # 0043aa63
    sub ecx, dword ptr [ebp - local_3c]          # 0043aa69
    mov dword ptr [0x585d41], ecx                # 0043aa6c
    cmp dword ptr [0x585d37], 0x0                # 0043aa72
    jge.d8 L_0043aa85                            # 0043aa79
    # block 0x0043aa7b: entered by fall-through of jge at 0x0043aa79, 1 instruction(s), falls into the block at 0x0043aa85
    mov dword ptr [0x585d37], 0x0                # 0043aa7b
L_0043aa85:
    # block 0x0043aa85: entered by jge at 0x0043aa79, 2 instruction(s), ends with jge to 0x0043aa98 (forward)
    cmp dword ptr [0x585d41], 0x0                # 0043aa85
    jge.d8 L_0043aa98                            # 0043aa8c
    # block 0x0043aa8e: entered by fall-through of jge at 0x0043aa8c, 1 instruction(s), falls into the block at 0x0043aa98
    mov dword ptr [0x585d41], 0x0                # 0043aa8e
L_0043aa98:
    # block 0x0043aa98: entered by jge at 0x0043aa8c, 2 instruction(s), ends with forward jump to 0x0043aaac
    mov word ptr [ebp - local_1c], 0x0           # 0043aa98
    jmp.d8 L_0043aaac                            # 0043aa9e
L_0043aaa0:
    # block 0x0043aaa0: entered by jmp at 0x0043ab3c, 3 instruction(s), falls into the block at 0x0043aaac
    mov dx, word ptr [ebp - local_1c]            # 0043aaa0
    add dx, 0x1                                  # 0043aaa4
    mov word ptr [ebp - local_1c], dx            # 0043aaa8
L_0043aaac:
    # block 0x0043aaac: entered by jmp at 0x0043aa9e, 3 instruction(s), ends with jge to 0x0043ab41 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0043aaac
    cmp eax, 0xa                                 # 0043aab0
    jge.d32 L_0043ab41                           # 0043aab3
    # block 0x0043aab9: entered by fall-through of jge at 0x0043aab3, 4 instruction(s), ends with je to 0x0043aaf2 (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 0043aab9
    imul ecx, ecx, 0x106                         # 0043aabd
    cmp dword ptr [ecx + 0x585d65], 0x1          # 0043aac3
    je.d8 L_0043aaf2                             # 0043aaca
    # block 0x0043aacc: entered by fall-through of je at 0x0043aaca, 4 instruction(s), ends with je to 0x0043aaf2 (forward)
    movsx edx, word ptr [ebp - local_1c]         # 0043aacc
    imul edx, edx, 0x106                         # 0043aad0
    cmp dword ptr [edx + 0x585d65], 0x5          # 0043aad6
    je.d8 L_0043aaf2                             # 0043aadd
    # block 0x0043aadf: entered by fall-through of je at 0x0043aadd, 4 instruction(s), ends with jne to 0x0043ab3c (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0043aadf
    imul eax, eax, 0x106                         # 0043aae3
    cmp dword ptr [eax + 0x585d65], 0x6          # 0043aae9
    jne.d8 L_0043ab3c                            # 0043aaf0
L_0043aaf2:
    # block 0x0043aaf2: entered by je at 0x0043aaca; je at 0x0043aadd; fall-through of jne at 0x0043aaf0, 11 instruction(s), ends with jge to 0x0043ab3c (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 0043aaf2
    imul ecx, ecx, 0x106                         # 0043aaf6
    mov edx, dword ptr [ecx + 0x585d69]          # 0043aafc
    sub edx, dword ptr [ebp - local_3c]          # 0043ab02
    movsx eax, word ptr [ebp - local_1c]         # 0043ab05
    imul eax, eax, 0x106                         # 0043ab09
    mov dword ptr [eax + 0x585d69], edx          # 0043ab0f
    movsx ecx, word ptr [ebp - local_1c]         # 0043ab15
    imul ecx, ecx, 0x106                         # 0043ab19
    cmp dword ptr [ecx + 0x585d69], 0x0          # 0043ab1f
    jge.d8 L_0043ab3c                            # 0043ab26
    # block 0x0043ab28: entered by fall-through of jge at 0x0043ab26, 3 instruction(s), falls into the block at 0x0043ab3c
    movsx edx, word ptr [ebp - local_1c]         # 0043ab28
    imul edx, edx, 0x106                         # 0043ab2c
    mov dword ptr [edx + 0x585d69], 0x0          # 0043ab32
L_0043ab3c:
    # block 0x0043ab3c: entered by jne at 0x0043aaf0; jge at 0x0043ab26, 1 instruction(s), ends with backward jump to 0x0043aaa0
    jmp.d32 L_0043aaa0                           # 0043ab3c
L_0043ab41:
    # block 0x0043ab41: entered by jne at 0x0043aa2f; jbe at 0x0043aa41; jge at 0x0043aab3, 10 instruction(s), calls FUN_004d36ed, FUN_004e812f, FUN_004fb086, FUN_004fc05d, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x5c39e5], 0xffffffff         # 0043ab41
    call FUN_004d36ed                            # 0043ab4b
    mov ecx, 0x571442                            # 0043ab50
    call FUN_004e812f                            # 0043ab55
    mov ecx, 0x5c3a67                            # 0043ab5a
    call FUN_004fb086                            # 0043ab5f
    mov ecx, 0x5c3a67                            # 0043ab64
    call FUN_004fc05d                            # 0043ab69
    mov dword ptr [0x583985], 0xe                # 0043ab6e
    jmp.d32 L_0043d1bd                           # 0043ab78
L_0043ab7d:
    # block 0x0043ab7d: entered by je at 0x0043aa10, 4 instruction(s), ends with jae to 0x0043aba3 (forward)
    mov dword ptr [ebp - local_38], 0x0          # 0043ab7d
    mov eax, dword ptr [0x585d33]                # 0043ab84
    cmp eax, dword ptr [ebp - local_4]           # 0043ab89
    jae.d8 L_0043aba3                            # 0043ab8c
    # block 0x0043ab8e: entered by fall-through of jae at 0x0043ab8c, 5 instruction(s), falls into the block at 0x0043aba3
    mov ecx, dword ptr [ebp - local_4]           # 0043ab8e
    sub ecx, dword ptr [0x585d33]                # 0043ab91
    mov dword ptr [ebp - local_38], ecx          # 0043ab97
    mov edx, dword ptr [ebp - local_4]           # 0043ab9a
    mov dword ptr [0x585d33], edx                # 0043ab9d
L_0043aba3:
    # block 0x0043aba3: entered by jae at 0x0043ab8c, 26 instruction(s), ends with forward jump to 0x0043ac12
    mov eax, dword ptr [0x585d37]                # 0043aba3
    add eax, dword ptr [ebp - local_38]          # 0043aba8
    mov dword ptr [0x585d37], eax                # 0043abab
    mov eax, dword ptr [0x585d37]                # 0043abb0
    cdq                                          # 0043abb5
    mov ecx, 0x3e8                               # 0043abb6
    idiv ecx                                     # 0043abbb
    cdq                                          # 0043abbd
    mov ecx, 0x3c                                # 0043abbe
    idiv ecx                                     # 0043abc3
    mov word ptr [0x585d3b], dx                  # 0043abc5
    mov eax, dword ptr [0x585d37]                # 0043abcc
    {load} xor edx, edx                          # 0043abd1
    mov ecx, 0xea60                              # 0043abd3
    div ecx                                      # 0043abd8
    {load} xor edx, edx                          # 0043abda
    mov ecx, 0x3c                                # 0043abdc
    div ecx                                      # 0043abe1
    mov word ptr [0x585d3d], dx                  # 0043abe3
    mov eax, dword ptr [0x585d37]                # 0043abea
    {load} xor edx, edx                          # 0043abef
    mov ecx, 0x36ee80                            # 0043abf1
    div ecx                                      # 0043abf6
    mov word ptr [0x585d3f], ax                  # 0043abf8
    mov word ptr [ebp - local_1c], 0x0           # 0043abfe
    jmp.d8 L_0043ac12                            # 0043ac04
L_0043ac06:
    # block 0x0043ac06: entered by jmp at 0x0043af3a, 3 instruction(s), falls into the block at 0x0043ac12
    mov dx, word ptr [ebp - local_1c]            # 0043ac06
    add dx, 0x1                                  # 0043ac0a
    mov word ptr [ebp - local_1c], dx            # 0043ac0e
L_0043ac12:
    # block 0x0043ac12: entered by jmp at 0x0043ac04, 3 instruction(s), ends with jge to 0x0043af3f (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0043ac12
    cmp eax, 0xa                                 # 0043ac16
    jge.d32 L_0043af3f                           # 0043ac19
    # block 0x0043ac1f: entered by fall-through of jge at 0x0043ac19, 7 instruction(s), ends with je to 0x0043ac4e (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 0043ac1f
    imul ecx, ecx, 0x106                         # 0043ac23
    add ecx, 0x585d65                            # 0043ac29
    mov dword ptr [ebp - local_4c], ecx          # 0043ac2f
    mov edx, dword ptr [ebp - local_4c]          # 0043ac32
    cmp dword ptr [edx], 0x1                     # 0043ac35
    je.d8 L_0043ac4e                             # 0043ac38
    # block 0x0043ac3a: entered by fall-through of je at 0x0043ac38, 3 instruction(s), ends with je to 0x0043ac4e (forward)
    mov eax, dword ptr [ebp - local_4c]          # 0043ac3a
    cmp dword ptr [eax], 0x5                     # 0043ac3d
    je.d8 L_0043ac4e                             # 0043ac40
    # block 0x0043ac42: entered by fall-through of je at 0x0043ac40, 3 instruction(s), ends with jne to 0x0043af3a (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 0043ac42
    cmp dword ptr [ecx], 0x6                     # 0043ac45
    jne.d32 L_0043af3a                           # 0043ac48
L_0043ac4e:
    # block 0x0043ac4e: entered by je at 0x0043ac38; je at 0x0043ac40; fall-through of jne at 0x0043ac48, 35 instruction(s), ends with je to 0x0043acc0 (forward)
    mov edx, dword ptr [ebp - local_4c]          # 0043ac4e
    mov eax, dword ptr [edx + field_4]           # 0043ac51
    add eax, dword ptr [ebp - local_38]          # 0043ac54
    mov ecx, dword ptr [ebp - local_4c]          # 0043ac57
    mov dword ptr [ecx + field_4], eax           # 0043ac5a
    mov edx, dword ptr [ebp - local_4c]          # 0043ac5d
    mov eax, dword ptr [edx + field_4]           # 0043ac60
    cdq                                          # 0043ac63
    mov ecx, 0x3e8                               # 0043ac64
    idiv ecx                                     # 0043ac69
    cdq                                          # 0043ac6b
    mov ecx, 0x3c                                # 0043ac6c
    idiv ecx                                     # 0043ac71
    mov eax, dword ptr [ebp - local_4c]          # 0043ac73
    mov dword ptr [eax + field_8], edx           # 0043ac76
    mov ecx, dword ptr [ebp - local_4c]          # 0043ac79
    mov eax, dword ptr [ecx + field_4]           # 0043ac7c
    {load} xor edx, edx                          # 0043ac7f
    mov ecx, 0xea60                              # 0043ac81
    div ecx                                      # 0043ac86
    {load} xor edx, edx                          # 0043ac88
    mov ecx, 0x3c                                # 0043ac8a
    div ecx                                      # 0043ac8f
    mov eax, dword ptr [ebp - local_4c]          # 0043ac91
    mov dword ptr [eax + field_c], edx           # 0043ac94
    mov ecx, dword ptr [ebp - local_4c]          # 0043ac97
    mov eax, dword ptr [ecx + field_4]           # 0043ac9a
    {load} xor edx, edx                          # 0043ac9d
    mov ecx, 0x36ee80                            # 0043ac9f
    div ecx                                      # 0043aca4
    mov edx, dword ptr [ebp - local_4c]          # 0043aca6
    mov dword ptr [edx + field_10], eax          # 0043aca9
    mov eax, dword ptr [ebp - local_4c]          # 0043acac
    cmp dword ptr [eax], 0x5                     # 0043acaf
    je.d8 L_0043acc0                             # 0043acb2
    # block 0x0043acb4: entered by fall-through of je at 0x0043acb2, 3 instruction(s), ends with jne to 0x0043af3a (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 0043acb4
    cmp dword ptr [ecx], 0x6                     # 0043acb7
    jne.d32 L_0043af3a                           # 0043acba
L_0043acc0:
    # block 0x0043acc0: entered by je at 0x0043acb2; fall-through of jne at 0x0043acba, 3 instruction(s), ends with jle to 0x0043af3a (forward)
    mov edx, dword ptr [ebp - local_4c]          # 0043acc0
    cmp dword ptr [edx + field_18], 0x0          # 0043acc3
    jle.d32 L_0043af3a                           # 0043acc7
    # block 0x0043accd: entered by fall-through of jle at 0x0043acc7, 3 instruction(s), ends with jne to 0x0043af3a (forward)
    mov eax, dword ptr [ebp - local_4c]          # 0043accd
    cmp dword ptr [eax + field_14], 0x0          # 0043acd0
    jne.d32 L_0043af3a                           # 0043acd4
    # block 0x0043acda: entered by fall-through of jne at 0x0043acd4, 5 instruction(s), ends with jg to 0x0043af3a (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 0043acda
    mov edx, dword ptr [ebp - local_4c]          # 0043acdd
    mov eax, dword ptr [ecx + field_18]          # 0043ace0
    cmp eax, dword ptr [edx + field_4]           # 0043ace3
    jg.d32 L_0043af3a                            # 0043ace6
    # block 0x0043acec: entered by fall-through of jg at 0x0043ace6, 4 instruction(s), ends with forward jump to 0x0043ad08
    mov ecx, dword ptr [ebp - local_4c]          # 0043acec
    mov dword ptr [ecx + field_14], 0x1          # 0043acef
    mov dword ptr [ebp - local_50], 0x0          # 0043acf6
    jmp.d8 L_0043ad08                            # 0043acfd
L_0043acff:
    # block 0x0043acff: entered by jmp at 0x0043ad44, 3 instruction(s), falls into the block at 0x0043ad08
    mov edx, dword ptr [ebp - local_50]          # 0043acff
    add edx, 0x1                                 # 0043ad02
    mov dword ptr [ebp - local_50], edx          # 0043ad05
L_0043ad08:
    # block 0x0043ad08: entered by jmp at 0x0043acfd, 2 instruction(s), ends with jge to 0x0043ad46 (forward)
    cmp dword ptr [ebp - local_50], 0xa          # 0043ad08
    jge.d8 L_0043ad46                            # 0043ad0c
    # block 0x0043ad0e: entered by fall-through of jge at 0x0043ad0c, 5 instruction(s), ends with je to 0x0043ad44 (forward)
    mov eax, dword ptr [ebp - local_50]          # 0043ad0e
    mov ecx, dword ptr [ebp - local_4c]          # 0043ad11
    movsx edx, word ptr [ecx + 4*eax + field_de] # 0043ad14
    cmp edx, -0x1                                # 0043ad1c
    je.d8 L_0043ad44                             # 0043ad1f
    # block 0x0043ad21: entered by fall-through of je at 0x0043ad1f, 7 instruction(s), falls into the block at 0x0043ad44
    mov eax, dword ptr [ebp - local_50]          # 0043ad21
    mov ecx, dword ptr [ebp - local_4c]          # 0043ad24
    movsx edx, word ptr [ecx + 4*eax + field_e0] # 0043ad27
    mov eax, dword ptr [ebp - local_50]          # 0043ad2f
    mov ecx, dword ptr [ebp - local_4c]          # 0043ad32
    movsx eax, word ptr [ecx + 4*eax + field_de] # 0043ad35
    mov dword ptr [4*eax + 0x585801], edx        # 0043ad3d
L_0043ad44:
    # block 0x0043ad44: entered by je at 0x0043ad1f, 1 instruction(s), ends with backward jump to 0x0043acff
    jmp.d8 L_0043acff                            # 0043ad44
L_0043ad46:
    # block 0x0043ad46: entered by jge at 0x0043ad0c, 2 instruction(s), ends with forward jump to 0x0043ad58
    mov dword ptr [ebp - local_54], 0x0          # 0043ad46
    jmp.d8 L_0043ad58                            # 0043ad4d
L_0043ad4f:
    # block 0x0043ad4f: entered by jmp at 0x0043ad6e, 3 instruction(s), falls into the block at 0x0043ad58
    mov ecx, dword ptr [ebp - local_54]          # 0043ad4f
    add ecx, 0x1                                 # 0043ad52
    mov dword ptr [ebp - local_54], ecx          # 0043ad55
L_0043ad58:
    # block 0x0043ad58: entered by jmp at 0x0043ad4d, 2 instruction(s), ends with jge to 0x0043ad70 (forward)
    cmp dword ptr [ebp - local_54], 0xa          # 0043ad58
    jge.d8 L_0043ad70                            # 0043ad5c
    # block 0x0043ad5e: entered by fall-through of jge at 0x0043ad5c, 4 instruction(s), ends with backward jump to 0x0043ad4f
    mov edx, dword ptr [ebp - local_54]          # 0043ad5e
    mov eax, dword ptr [ebp - local_4c]          # 0043ad61
    mov word ptr [eax + 4*edx + field_de], 0xffff # 0043ad64
    jmp.d8 L_0043ad4f                            # 0043ad6e
L_0043ad70:
    # block 0x0043ad70: entered by jge at 0x0043ad5c, 8 instruction(s), calls FUN_00516530, ends with je to 0x0043adab (forward)
    push 0x547208                                # 0043ad70
    mov ecx, dword ptr [ebp - local_4c]          # 0043ad75
    add ecx, 0x28                                # 0043ad78
    push ecx                                     # 0043ad7b
    call FUN_00516530                            # 0043ad7c
    add esp, 0x8                                 # 0043ad81
    test eax, eax                                # 0043ad84
    je.d8 L_0043adab                             # 0043ad86
    # block 0x0043ad88: entered by fall-through of je at 0x0043ad86, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x0043adab
    mov edx, dword ptr [ebp - local_4c]          # 0043ad88
    add edx, 0x28                                # 0043ad8b
    push edx                                     # 0043ad8e
    mov ecx, 0x5c3a67                            # 0043ad8f
    call FUN_004fb77a                            # 0043ad94
    mov eax, dword ptr [ebp - local_4c]          # 0043ad99
    mov cx, word ptr [eax + field_49]            # 0043ad9c
    push ecx                                     # 0043ada0
    mov ecx, 0x5c3a67                            # 0043ada1
    call FUN_004fb2e3                            # 0043ada6
L_0043adab:
    # block 0x0043adab: entered by je at 0x0043ad86, 3 instruction(s), ends with je to 0x0043af13 (forward)
    mov dword ptr [ebp - local_58], 0x0          # 0043adab
    cmp dword ptr [0x5bb202], 0x0                # 0043adb2
    je.d32 L_0043af13                            # 0043adb9
    # block 0x0043adbf: entered by fall-through of je at 0x0043adb9, 9 instruction(s), ends with jbe to 0x0043ae81 (forward)
    mov edi, dword ptr [ebp - local_4c]          # 0043adbf
    add edi, 0x59                                # 0043adc2
    or ecx, -0x1                                 # 0043adc5
    {load} xor eax, eax                          # 0043adc8
    repne scasb al, byte ptr es:[edi]            # 0043adca
    not ecx                                      # 0043adcc
    add ecx, -0x1                                # 0043adce
    test ecx, ecx                                # 0043add1
    jbe.d32 L_0043ae81                           # 0043add3
    # block 0x0043add9: entered by fall-through of jbe at 0x0043add3, 8 instruction(s), calls FUN_00423259, ends with je to 0x0043ae7a (forward)
    mov edx, dword ptr [ebp - local_4c]          # 0043add9
    add edx, 0x59                                # 0043addc
    push edx                                     # 0043addf
    mov ecx, 0x619a6b                            # 0043ade0
    call FUN_00423259                            # 0043ade5
    mov dword ptr [ebp - local_58], eax          # 0043adea
    cmp dword ptr [ebp - local_58], 0x0          # 0043aded
    je.d32 L_0043ae7a                            # 0043adf1
    # block 0x0043adf7: entered by fall-through of je at 0x0043adf1, 8 instruction(s), ends with ja to 0x0043ae7a (forward)
    mov edi, dword ptr [ebp - local_58]          # 0043adf7
    or ecx, -0x1                                 # 0043adfa
    {load} xor eax, eax                          # 0043adfd
    repne scasb al, byte ptr es:[edi]            # 0043adff
    not ecx                                      # 0043ae01
    add ecx, -0x1                                # 0043ae03
    cmp ecx, 0x9c40                              # 0043ae06
    ja.d8 L_0043ae7a                             # 0043ae0c
    # block 0x0043ae0e: entered by fall-through of ja at 0x0043ae0c, 33 instruction(s), calls FUN_00448d11, ends with forward jump to 0x0043ae81
    mov edi, dword ptr [ebp - local_58]          # 0043ae0e
    or ecx, -0x1                                 # 0043ae11
    {load} xor eax, eax                          # 0043ae14
    repne scasb al, byte ptr es:[edi]            # 0043ae16
    not ecx                                      # 0043ae18
    mov esi, dword ptr [ebp - local_58]          # 0043ae1a
    lea edi, [ebp - local_c0]                    # 0043ae1d
    {load} mov eax, ecx                          # 0043ae23
    shr ecx, 0x2                                 # 0043ae25
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043ae28
    {load} mov ecx, eax                          # 0043ae2a
    and ecx, 0x3                                 # 0043ae2c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043ae2f
    lea edi, [ebp - local_c0]                    # 0043ae31
    or ecx, -0x1                                 # 0043ae37
    {load} xor eax, eax                          # 0043ae3a
    repne scasb al, byte ptr es:[edi]            # 0043ae3c
    add edi, -0x1                                # 0043ae3e
    mov ecx, dword ptr [0x547214]                # 0043ae41
    mov dword ptr [edi], ecx                     # 0043ae47
    mov dx, word ptr [0x547218]                  # 0043ae49
    mov word ptr [edi + field_4], dx             # 0043ae50
    mov al, byte ptr [0x54721a]                  # 0043ae54
    mov byte ptr [edi + field_6], al             # 0043ae59
    push 0x0                                     # 0043ae5c
    push -0x1                                    # 0043ae5e
    lea ecx, [ebp - local_c0]                    # 0043ae60
    push ecx                                     # 0043ae66
    mov edx, dword ptr [0x5d03b3]                # 0043ae67
    push edx                                     # 0043ae6d
    mov ecx, 0x619a05                            # 0043ae6e
    call FUN_00448d11                            # 0043ae73
    jmp.d8 L_0043ae81                            # 0043ae78
L_0043ae7a:
    # block 0x0043ae7a: entered by je at 0x0043adf1; ja at 0x0043ae0c, 1 instruction(s), falls into the block at 0x0043ae81
    mov dword ptr [ebp - local_58], 0x0          # 0043ae7a
L_0043ae81:
    # block 0x0043ae81: entered by jbe at 0x0043add3; jmp at 0x0043ae78, 2 instruction(s), ends with jne to 0x0043af13 (forward)
    cmp dword ptr [ebp - local_58], 0x0          # 0043ae81
    jne.d32 L_0043af13                           # 0043ae85
    # block 0x0043ae8b: entered by fall-through of jne at 0x0043ae85, 9 instruction(s), ends with jbe to 0x0043af13 (forward)
    mov edi, dword ptr [ebp - local_4c]          # 0043ae8b
    add edi, 0x7a                                # 0043ae8e
    or ecx, -0x1                                 # 0043ae91
    {load} xor eax, eax                          # 0043ae94
    repne scasb al, byte ptr es:[edi]            # 0043ae96
    not ecx                                      # 0043ae98
    add ecx, -0x1                                # 0043ae9a
    test ecx, ecx                                # 0043ae9d
    jbe.d8 L_0043af13                            # 0043ae9f
    # block 0x0043aea1: entered by fall-through of jbe at 0x0043ae9f, 36 instruction(s), calls FUN_00448d11, falls into the block at 0x0043af13
    mov eax, dword ptr [ebp - local_4c]          # 0043aea1
    add eax, 0x7a                                # 0043aea4
    {load} mov edi, eax                          # 0043aea7
    lea edx, [ebp - local_c0]                    # 0043aea9
    or ecx, -0x1                                 # 0043aeaf
    {load} xor eax, eax                          # 0043aeb2
    repne scasb al, byte ptr es:[edi]            # 0043aeb4
    not ecx                                      # 0043aeb6
    {load} sub edi, ecx                          # 0043aeb8
    {load} mov esi, edi                          # 0043aeba
    {load} mov eax, ecx                          # 0043aebc
    {load} mov edi, edx                          # 0043aebe
    shr ecx, 0x2                                 # 0043aec0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043aec3
    {load} mov ecx, eax                          # 0043aec5
    and ecx, 0x3                                 # 0043aec7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043aeca
    lea edi, [ebp - local_c0]                    # 0043aecc
    or ecx, -0x1                                 # 0043aed2
    {load} xor eax, eax                          # 0043aed5
    repne scasb al, byte ptr es:[edi]            # 0043aed7
    add edi, -0x1                                # 0043aed9
    mov ecx, dword ptr [0x54721c]                # 0043aedc
    mov dword ptr [edi], ecx                     # 0043aee2
    mov dx, word ptr [0x547220]                  # 0043aee4
    mov word ptr [edi + field_4], dx             # 0043aeeb
    mov al, byte ptr [0x547222]                  # 0043aeef
    mov byte ptr [edi + field_6], al             # 0043aef4
    push 0x0                                     # 0043aef7
    push -0x1                                    # 0043aef9
    lea ecx, [ebp - local_c0]                    # 0043aefb
    push ecx                                     # 0043af01
    mov edx, dword ptr [0x5d03b3]                # 0043af02
    push edx                                     # 0043af08
    mov ecx, 0x619a05                            # 0043af09
    call FUN_00448d11                            # 0043af0e
L_0043af13:
    # block 0x0043af13: entered by je at 0x0043adb9; jne at 0x0043ae85; jbe at 0x0043ae9f, 3 instruction(s), ends with jne to 0x0043af29 (forward)
    mov eax, dword ptr [ebp - local_4c]          # 0043af13
    cmp dword ptr [eax], 0x5                     # 0043af16
    jne.d8 L_0043af29                            # 0043af19
    # block 0x0043af1b: entered by fall-through of jne at 0x0043af19, 5 instruction(s), calls FUN_00433bd2, ends with forward jump to 0x0043af3a
    mov ecx, dword ptr [ebp - local_4c]          # 0043af1b
    push ecx                                     # 0043af1e
    call FUN_00433bd2                            # 0043af1f
    add esp, 0x4                                 # 0043af24
    jmp.d8 L_0043af3a                            # 0043af27
L_0043af29:
    # block 0x0043af29: entered by jne at 0x0043af19, 3 instruction(s), ends with jne to 0x0043af3a (forward)
    mov edx, dword ptr [ebp - local_4c]          # 0043af29
    cmp dword ptr [edx], 0x6                     # 0043af2c
    jne.d8 L_0043af3a                            # 0043af2f
    # block 0x0043af31: entered by fall-through of jne at 0x0043af2f, 2 instruction(s), falls into the block at 0x0043af3a
    mov eax, dword ptr [ebp - local_4c]          # 0043af31
    mov dword ptr [eax], 0x1                     # 0043af34
L_0043af3a:
    # block 0x0043af3a: entered by jne at 0x0043ac48; jne at 0x0043acba; jle at 0x0043acc7; jne at 0x0043acd4; more, 1 instruction(s), ends with backward jump to 0x0043ac06
    jmp.d32 L_0043ac06                           # 0043af3a
L_0043af3f:
    # block 0x0043af3f: entered by jge at 0x0043ac19, 27 instruction(s), ends with jb to 0x0043afcb (forward)
    mov ecx, dword ptr [0x585d41]                # 0043af3f
    add ecx, dword ptr [ebp - local_38]          # 0043af45
    mov dword ptr [0x585d41], ecx                # 0043af48
    mov eax, dword ptr [0x585d41]                # 0043af4e
    cdq                                          # 0043af53
    mov ecx, 0x3e8                               # 0043af54
    idiv ecx                                     # 0043af59
    cdq                                          # 0043af5b
    mov ecx, 0x3c                                # 0043af5c
    idiv ecx                                     # 0043af61
    mov word ptr [0x585d45], dx                  # 0043af63
    mov eax, dword ptr [0x585d41]                # 0043af6a
    {load} xor edx, edx                          # 0043af6f
    mov ecx, 0xea60                              # 0043af71
    div ecx                                      # 0043af76
    {load} xor edx, edx                          # 0043af78
    mov ecx, 0x3c                                # 0043af7a
    div ecx                                      # 0043af7f
    mov word ptr [0x585d47], dx                  # 0043af81
    mov eax, dword ptr [0x585d41]                # 0043af88
    {load} xor edx, edx                          # 0043af8d
    mov ecx, 0x36ee80                            # 0043af8f
    div ecx                                      # 0043af94
    mov word ptr [0x585d49], ax                  # 0043af96
    mov edx, dword ptr [ebp - local_4]           # 0043af9c
    cmp edx, dword ptr [0x585d55]                # 0043af9f
    jb.d8 L_0043afcb                             # 0043afa5
    # block 0x0043afa7: entered by fall-through of jb at 0x0043afa5, 7 instruction(s), falls into the block at 0x0043afcb
    movsx eax, word ptr [0x5b0280]               # 0043afa7
    mov ecx, dword ptr [ebp - local_4]           # 0043afae
    {load} add ecx, eax                          # 0043afb1
    mov dword ptr [0x585d55], ecx                # 0043afb3
    mov dx, word ptr [0x585d4f]                  # 0043afb9
    add dx, 0x1                                  # 0043afc0
    mov word ptr [0x585d4f], dx                  # 0043afc4
L_0043afcb:
    # block 0x0043afcb: entered by jb at 0x0043afa5, 3 instruction(s), ends with jl to 0x0043b01f (forward)
    movsx eax, word ptr [0x585d4f]               # 0043afcb
    cmp eax, 0x3c                                # 0043afd2
    jl.d8 L_0043b01f                             # 0043afd5
    # block 0x0043afd7: entered by fall-through of jl at 0x0043afd5, 14 instruction(s), ends with forward jump to 0x0043b04c
    movsx eax, word ptr [0x585d4f]               # 0043afd7
    cdq                                          # 0043afde
    mov ecx, 0x3c                                # 0043afdf
    idiv ecx                                     # 0043afe4
    mov word ptr [ebp - local_c4], ax            # 0043afe6
    mov dx, word ptr [0x585d51]                  # 0043afed
    add dx, word ptr [ebp - local_c4]            # 0043aff4
    mov word ptr [0x585d51], dx                  # 0043affb
    movsx eax, word ptr [ebp - local_c4]         # 0043b002
    imul eax, eax, 0x3c                          # 0043b009
    mov cx, word ptr [0x585d4f]                  # 0043b00c
    {load} sub cx, ax                            # 0043b013
    mov word ptr [0x585d4f], cx                  # 0043b016
    jmp.d8 L_0043b04c                            # 0043b01d
L_0043b01f:
    # block 0x0043b01f: entered by jl at 0x0043afd5, 3 instruction(s), ends with jge to 0x0043b04c (forward)
    movsx edx, word ptr [0x585d4f]               # 0043b01f
    test edx, edx                                # 0043b026
    jge.d8 L_0043b04c                            # 0043b028
    # block 0x0043b02a: entered by fall-through of jge at 0x0043b028, 6 instruction(s), falls into the block at 0x0043b04c
    mov ax, word ptr [0x585d51]                  # 0043b02a
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0043b030
    mov word ptr [0x585d51], ax                  # 0043b034
    mov cx, word ptr [0x585d4f]                  # 0043b03a
    add cx, 0x3c                                 # 0043b041
    mov word ptr [0x585d4f], cx                  # 0043b045
L_0043b04c:
    # block 0x0043b04c: entered by jmp at 0x0043b01d; jge at 0x0043b028, 3 instruction(s), ends with jl to 0x0043b07c (forward)
    movsx edx, word ptr [0x585d51]               # 0043b04c
    cmp edx, 0x18                                # 0043b053
    jl.d8 L_0043b07c                             # 0043b056
    # block 0x0043b058: entered by fall-through of jl at 0x0043b056, 7 instruction(s), ends with forward jump to 0x0043b0f2
    mov ax, word ptr [0x585d51]                  # 0043b058
    .insn 0x66, 0x2d, 0x0018{:u16}               # 0043b05e
    mov word ptr [0x585d51], ax                  # 0043b062
    mov cx, word ptr [0x585d53]                  # 0043b068
    add cx, 0x1                                  # 0043b06f
    mov word ptr [0x585d53], cx                  # 0043b073
    jmp.d8 L_0043b0f2                            # 0043b07a
L_0043b07c:
    # block 0x0043b07c: entered by jl at 0x0043b056, 3 instruction(s), ends with jge to 0x0043b0b6 (forward)
    movsx edx, word ptr [0x585d51]               # 0043b07c
    test edx, edx                                # 0043b083
    jge.d8 L_0043b0b6                            # 0043b085
    # block 0x0043b087: entered by fall-through of jge at 0x0043b085, 6 instruction(s), ends with jle to 0x0043b0b4 (forward)
    movsx eax, word ptr [0x585d51]               # 0043b087
    add eax, 0x18                                # 0043b08e
    mov word ptr [0x585d51], ax                  # 0043b091
    movsx ecx, word ptr [0x585d53]               # 0043b097
    test ecx, ecx                                # 0043b09e
    jle.d8 L_0043b0b4                            # 0043b0a0
    # block 0x0043b0a2: entered by fall-through of jle at 0x0043b0a0, 3 instruction(s), falls into the block at 0x0043b0b4
    mov dx, word ptr [0x585d53]                  # 0043b0a2
    sub dx, 0x1                                  # 0043b0a9
    mov word ptr [0x585d53], dx                  # 0043b0ad
L_0043b0b4:
    # block 0x0043b0b4: entered by jle at 0x0043b0a0, 1 instruction(s), ends with forward jump to 0x0043b0f2
    jmp.d8 L_0043b0f2                            # 0043b0b4
L_0043b0b6:
    # block 0x0043b0b6: entered by jge at 0x0043b085, 3 instruction(s), ends with jne to 0x0043b0f2 (forward)
    movsx eax, word ptr [0x585d53]               # 0043b0b6
    cmp eax, 0x1                                 # 0043b0bd
    jne.d8 L_0043b0f2                            # 0043b0c0
    # block 0x0043b0c2: entered by fall-through of jne at 0x0043b0c0, 4 instruction(s), ends with jl to 0x0043b0f2 (forward)
    movsx ecx, word ptr [0x585d51]               # 0043b0c2
    movsx edx, word ptr [0x585d59]               # 0043b0c9
    {load} cmp ecx, edx                          # 0043b0d0
    jl.d8 L_0043b0f2                             # 0043b0d2
    # block 0x0043b0d4: entered by fall-through of jl at 0x0043b0d2, 3 instruction(s), ends with je to 0x0043b0f2 (forward)
    movsx eax, word ptr [0x585d5b]               # 0043b0d4
    cmp eax, -0x1                                # 0043b0db
    je.d8 L_0043b0f2                             # 0043b0de
    # block 0x0043b0e0: entered by fall-through of je at 0x0043b0de, 2 instruction(s), falls into the block at 0x0043b0f2
    movsx ecx, word ptr [0x585d5b]               # 0043b0e0
    mov dword ptr [4*ecx + 0x585801], 0x1        # 0043b0e7
L_0043b0f2:
    # block 0x0043b0f2: entered by jmp at 0x0043b07a; jmp at 0x0043b0b4; jne at 0x0043b0c0; jl at 0x0043b0d2; more, 8 instruction(s), ends with jg to 0x0043b134 (forward)
    movsx edx, word ptr [0x585d51]               # 0043b0f2
    imul edx, edx, 0x3c                          # 0043b0f9
    movsx eax, word ptr [0x585d4f]               # 0043b0fc
    {load} add edx, eax                          # 0043b103
    mov dword ptr [0x585d4b], edx                # 0043b105
    movsx ecx, word ptr [0x5b0284]               # 0043b10b
    cmp ecx, dword ptr [0x585d4b]                # 0043b112
    jg.d8 L_0043b134                             # 0043b118
    # block 0x0043b11a: entered by fall-through of jg at 0x0043b118, 3 instruction(s), ends with jg to 0x0043b134 (forward)
    movsx edx, word ptr [0x5b0286]               # 0043b11a
    cmp dword ptr [0x585d4b], edx                # 0043b121
    jg.d8 L_0043b134                             # 0043b127
    # block 0x0043b129: entered by fall-through of jg at 0x0043b127, 2 instruction(s), ends with forward jump to 0x0043b13d
    mov word ptr [0x5bb20a], 0x0                 # 0043b129
    jmp.d8 L_0043b13d                            # 0043b132
L_0043b134:
    # block 0x0043b134: entered by jg at 0x0043b118; jg at 0x0043b127, 1 instruction(s), falls into the block at 0x0043b13d
    mov word ptr [0x5bb20a], 0x1                 # 0043b134
L_0043b13d:
    # block 0x0043b13d: entered by jmp at 0x0043b132, 4 instruction(s), calls FUN_004d3c31, ends with je to 0x0043b155 (forward)
    mov ecx, 0x61c387                            # 0043b13d
    call FUN_004d3c31                            # 0043b142
    test eax, eax                                # 0043b147
    je.d8 L_0043b155                             # 0043b149
    # block 0x0043b14b: entered by fall-through of je at 0x0043b149, 2 instruction(s), calls FUN_004d3d48, falls into the block at 0x0043b155
    mov ecx, 0x61c387                            # 0043b14b
    call FUN_004d3d48                            # 0043b150
L_0043b155:
    # block 0x0043b155: entered by je at 0x0043b149, 4 instruction(s), ends with je to 0x0043b173 (forward)
    {load} xor eax, eax                          # 0043b155
    mov al, byte ptr [0x61c6ad]                  # 0043b157
    test eax, eax                                # 0043b15c
    je.d8 L_0043b173                             # 0043b15e
    # block 0x0043b160: entered by fall-through of je at 0x0043b15e, 2 instruction(s), ends with je to 0x0043b173 (forward)
    cmp dword ptr [0x61c7bd], 0x0                # 0043b160
    je.d8 L_0043b173                             # 0043b167
    # block 0x0043b169: entered by fall-through of je at 0x0043b167, 2 instruction(s), calls FUN_004d4043, falls into the block at 0x0043b173
    mov ecx, 0x61c387                            # 0043b169
    call FUN_004d4043                            # 0043b16e
L_0043b173:
    # block 0x0043b173: entered by je at 0x0043b15e; je at 0x0043b167, 6 instruction(s), calls FUN_004f52a9, ends with jne to 0x0043b194 (forward)
    mov ecx, 0x5cf1eb                            # 0043b173
    call FUN_004f52a9                            # 0043b178
    {load} xor ecx, ecx                          # 0043b17d
    mov cl, byte ptr [0x58321d]                  # 0043b17f
    cmp ecx, 0x1                                 # 0043b185
    jne.d8 L_0043b194                            # 0043b188
    # block 0x0043b18a: entered by fall-through of jne at 0x0043b188, 2 instruction(s), calls FUN_0048c148, falls into the block at 0x0043b194
    mov ecx, 0x624686                            # 0043b18a
    call FUN_0048c148                            # 0043b18f
L_0043b194:
    # block 0x0043b194: entered by jne at 0x0043b188, 4 instruction(s), calls FUN_004daf3f, ends with je to 0x0043c0d1 (forward)
    mov ecx, 0x5830a6                            # 0043b194
    call FUN_004daf3f                            # 0043b199
    test eax, eax                                # 0043b19e
    je.d32 L_0043c0d1                            # 0043b1a0
    # block 0x0043b1a6: entered by fall-through of je at 0x0043b1a0, 7 instruction(s), ends with ja to 0x0043b1d7 (forward)
    mov edx, dword ptr [0x583204]                # 0043b1a6
    mov dword ptr [ebp - local_c8], edx          # 0043b1ac
    mov eax, dword ptr [ebp - local_c8]          # 0043b1b2
    sub eax, 0x2                                 # 0043b1b8
    mov dword ptr [ebp - local_c8], eax          # 0043b1bb
    cmp dword ptr [ebp - local_c8], 0x3          # 0043b1c1
    ja.d8 L_0043b1d7                             # 0043b1c8
    # block 0x0043b1ca: entered by fall-through of ja at 0x0043b1c8, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x43d1c3]
    mov ecx, dword ptr [ebp - local_c8]          # 0043b1ca
    jmp dword ptr [4*ecx + SWTAB_0043d1c3_VA]    # 0043b1d0
L_0043b1d7:
    # block 0x0043b1d7: entered by ja at 0x0043b1c8, 4 instruction(s), calls FUN_004e0978, ends with jne to 0x0043b212 (forward)
    mov ecx, 0x570508                            # 0043b1d7
    call FUN_004e0978                            # 0043b1dc
    cmp dword ptr [0x5e32b9], 0x0                # 0043b1e1
    jne.d8 L_0043b212                            # 0043b1e8
    # block 0x0043b1ea: entered by fall-through of jne at 0x0043b1e8, 2 instruction(s), ends with jne to 0x0043b212 (forward)
    cmp dword ptr [0x5bb1de], 0x0                # 0043b1ea
    jne.d8 L_0043b212                            # 0043b1f1
    # block 0x0043b1f3: entered by fall-through of jne at 0x0043b1f1, 2 instruction(s), ends with je to 0x0043b212 (forward)
    cmp dword ptr [0x5bb57b], 0x0                # 0043b1f3
    je.d8 L_0043b212                             # 0043b1fa
    # block 0x0043b1fc: entered by fall-through of je at 0x0043b1fa, 2 instruction(s), ends with je to 0x0043b212 (forward)
    cmp dword ptr [0x5c39e5], 0x27d8             # 0043b1fc
    je.d8 L_0043b212                             # 0043b206
    # block 0x0043b208: entered by fall-through of je at 0x0043b206, 1 instruction(s), falls into the block at 0x0043b212
    mov dword ptr [0x5e32b9], 0x1                # 0043b208
L_0043b212:
    # block 0x0043b212: entered by jne at 0x0043b1e8; jne at 0x0043b1f1; je at 0x0043b1fa; je at 0x0043b206, 4 instruction(s), ends with je to 0x0043b228 (forward)
    {load} xor edx, edx                          # 0043b212
    mov dl, byte ptr [0x5a161f]                  # 0043b214
    test edx, edx                                # 0043b21a
    je.d8 L_0043b228                             # 0043b21c
    # block 0x0043b21e: entered by fall-through of je at 0x0043b21c, 2 instruction(s), calls FUN_004de413, falls into the block at 0x0043b228
    mov ecx, 0x61f864                            # 0043b21e
    call FUN_004de413                            # 0043b223
L_0043b228:
    # block 0x0043b228: entered by je at 0x0043b21c, 90 instruction(s), calls FUN_0046957d, FUN_004b45ed, FUN_00459e49, FUN_004a44c0, FUN_0048ab49, FUN_004a1efd, FUN_0048e851,..., ends with je to 0x0043b592 (forward)
    mov ecx, 0x616ab2                            # 0043b228
    call FUN_0046957d                            # 0043b22d
    mov ecx, 0x617066                            # 0043b232
    call FUN_004b45ed                            # 0043b237
    mov ecx, 0x61c7ed                            # 0043b23c
    call FUN_00459e49                            # 0043b241
    mov ecx, 0x61c8cf                            # 0043b246
    call FUN_004a44c0                            # 0043b24b
    mov ecx, 0x61d10f                            # 0043b250
    call FUN_0048ab49                            # 0043b255
    mov ecx, 0x61d2dd                            # 0043b25a
    call FUN_004a1efd                            # 0043b25f
    mov ecx, 0x624dc9                            # 0043b264
    call FUN_0048e851                            # 0043b269
    mov ecx, 0x61d345                            # 0043b26e
    call FUN_0048d5f4                            # 0043b273
    mov ecx, 0x61d3a1                            # 0043b278
    call FUN_004a6946                            # 0043b27d
    mov ecx, 0x61d449                            # 0043b282
    call FUN_004b617a                            # 0043b287
    mov ecx, 0x61d6c1                            # 0043b28c
    call FUN_004ab899                            # 0043b291
    mov ecx, 0x61d723                            # 0043b296
    call FUN_00466073                            # 0043b29b
    mov ecx, 0x61d779                            # 0043b2a0
    call FUN_004631d1                            # 0043b2a5
    mov ecx, 0x61d7d8                            # 0043b2aa
    call FUN_00487ed5                            # 0043b2af
    mov ecx, 0x6204c1                            # 0043b2b4
    call FUN_004b2a9e                            # 0043b2b9
    mov ecx, 0x621a02                            # 0043b2be
    call FUN_0047a03c                            # 0043b2c3
    mov ecx, 0x622fa2                            # 0043b2c8
    call FUN_0047608e                            # 0043b2cd
    mov ecx, 0x62387c                            # 0043b2d2
    call FUN_004712bd                            # 0043b2d7
    mov ecx, 0x624686                            # 0043b2dc
    call FUN_0048c0ac                            # 0043b2e1
    mov ecx, 0x6246dc                            # 0043b2e6
    call FUN_0047d77d                            # 0043b2eb
    mov ecx, 0x624734                            # 0043b2f0
    call FUN_0045b872                            # 0043b2f5
    mov ecx, 0x6248ed                            # 0043b2fa
    call FUN_004574e4                            # 0043b2ff
    mov ecx, 0x624931                            # 0043b304
    call FUN_0044edfb                            # 0043b309
    mov ecx, 0x6249a0                            # 0043b30e
    call FUN_004b7563                            # 0043b313
    mov ecx, 0x6249dc                            # 0043b318
    call FUN_0045565f                            # 0043b31d
    mov ecx, 0x6252ad                            # 0043b322
    call FUN_0048569e                            # 0043b327
    mov ecx, 0x625ee8                            # 0043b32c
    call FUN_0047ff0e                            # 0043b331
    mov ecx, 0x627335                            # 0043b336
    call FUN_004a8818                            # 0043b33b
    mov ecx, 0x61e65c                            # 0043b340
    call FUN_0046793a                            # 0043b345
    mov ecx, 0x61e95c                            # 0043b34a
    call FUN_00473ffc                            # 0043b34f
    mov ecx, 0x61ed7b                            # 0043b354
    call FUN_004588ad                            # 0043b359
    mov ecx, 0x61ee6e                            # 0043b35e
    call FUN_004b82cd                            # 0043b363
    mov ecx, 0x628732                            # 0043b368
    call FUN_0046c6a9                            # 0043b36d
    mov ecx, 0x61f4b1                            # 0043b372
    call FUN_0045e587                            # 0043b377
    mov ecx, 0x630a34                            # 0043b37c
    call FUN_004aa3d2                            # 0043b381
    mov ecx, 0x624b50                            # 0043b386
    call FUN_00464c59                            # 0043b38b
    mov ecx, 0x624c2a                            # 0043b390
    call FUN_0046ebff                            # 0043b395
    mov ecx, 0x61df56                            # 0043b39a
    call FUN_004ba4f2                            # 0043b39f
    mov ecx, 0x61e398                            # 0043b3a4
    call FUN_0047b767                            # 0043b3a9
    mov ecx, 0x63847b                            # 0043b3ae
    call FUN_004cb3ab                            # 0043b3b3
    mov ecx, 0x624cbf                            # 0043b3b8
    call FUN_0044d624                            # 0043b3bd
    mov ecx, 0x624d12                            # 0043b3c2
    call FUN_00482724                            # 0043b3c7
    mov ecx, 0x6369e4                            # 0043b3cc
    call FUN_004ad310                            # 0043b3d1
    {load} xor eax, eax                          # 0043b3d6
    mov al, byte ptr [0x5b5158]                  # 0043b3d8
    test eax, eax                                # 0043b3dd
    je.d32 L_0043b592                            # 0043b3df
    # block 0x0043b3e5: entered by fall-through of je at 0x0043b3df, 4 instruction(s), ends with jne to 0x0043b592 (forward)
    {load} xor ecx, ecx                          # 0043b3e5
    mov cl, byte ptr [0x5b516a]                  # 0043b3e7
    test ecx, ecx                                # 0043b3ed
    jne.d32 L_0043b592                           # 0043b3ef
    # block 0x0043b3f5: entered by fall-through of jne at 0x0043b3ef, 2 instruction(s), ends with jne to 0x0043b592 (forward)
    cmp dword ptr [0x5c39e5], 0x2719             # 0043b3f5
    jne.d32 L_0043b592                           # 0043b3ff
    # block 0x0043b405: entered by fall-through of jne at 0x0043b3ff, 5 instruction(s), ends with je to 0x0043b4a2 (forward)
    movsx edx, word ptr [0x5b515b]               # 0043b405
    {load} xor eax, eax                          # 0043b40c
    mov al, byte ptr [edx + 0x5b5128]            # 0043b40e
    test eax, eax                                # 0043b414
    je.d32 L_0043b4a2                            # 0043b416
    # block 0x0043b41c: entered by fall-through of je at 0x0043b416, 10 instruction(s), ends with jge to 0x0043b44f (forward)
    movsx ecx, word ptr [0x5b515b]               # 0043b41c
    mov byte ptr [ecx + 0x5b5128], 0x0           # 0043b423
    mov dx, word ptr [0x5b5166]                  # 0043b42a
    mov word ptr [ebp - local_48], dx            # 0043b431
    mov ax, word ptr [ebp - local_48]            # 0043b435
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0043b439
    mov word ptr [ebp - local_48], ax            # 0043b43d
    movsx ecx, word ptr [ebp - local_48]         # 0043b441
    test ecx, ecx                                # 0043b445
    jge.d8 L_0043b44f                            # 0043b447
    # block 0x0043b449: entered by fall-through of jge at 0x0043b447, 1 instruction(s), falls into the block at 0x0043b44f
    mov word ptr [ebp - local_48], 0x0           # 0043b449
L_0043b44f:
    # block 0x0043b44f: entered by jge at 0x0043b447, 5 instruction(s), ends with jne to 0x0043b49d (forward)
    movsx edx, word ptr [ebp - local_48]         # 0043b44f
    movsx eax, word ptr [2*edx + 0x5b5138]       # 0043b453
    movsx ecx, word ptr [0x5b515b]               # 0043b45b
    {load} cmp eax, ecx                          # 0043b462
    jne.d8 L_0043b49d                            # 0043b464
    # block 0x0043b466: entered by fall-through of jne at 0x0043b464, 6 instruction(s), ends with jge to 0x0043b48c (forward)
    mov dx, word ptr [0x5b5166]                  # 0043b466
    sub dx, 0x1                                  # 0043b46d
    mov word ptr [0x5b5166], dx                  # 0043b471
    movsx eax, word ptr [0x5b5166]               # 0043b478
    test eax, eax                                # 0043b47f
    jge.d8 L_0043b48c                            # 0043b481
    # block 0x0043b483: entered by fall-through of jge at 0x0043b481, 1 instruction(s), falls into the block at 0x0043b48c
    mov word ptr [0x5b5166], 0x0                 # 0043b483
L_0043b48c:
    # block 0x0043b48c: entered by jge at 0x0043b481, 2 instruction(s), falls into the block at 0x0043b49d
    movsx ecx, word ptr [0x5b5166]               # 0043b48c
    mov word ptr [2*ecx + 0x5b5138], 0xffff      # 0043b493
L_0043b49d:
    # block 0x0043b49d: entered by jne at 0x0043b464, 1 instruction(s), ends with forward jump to 0x0043b53b
    jmp.d32 L_0043b53b                           # 0043b49d
L_0043b4a2:
    # block 0x0043b4a2: entered by je at 0x0043b416, 10 instruction(s), ends with jg to 0x0043b4ea (forward)
    movsx edx, word ptr [0x5b515b]               # 0043b4a2
    mov byte ptr [edx + 0x5b5128], 0x1           # 0043b4a9
    movsx eax, word ptr [0x5b5166]               # 0043b4b0
    movsx ecx, word ptr [0x5b5159]               # 0043b4b7
    imul ecx, ecx, 0x8d                          # 0043b4be
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043b4c4
    movsx ecx, word ptr [edx + field_21]         # 0043b4ca
    sub ecx, 0x1                                 # 0043b4ce
    {load} cmp eax, ecx                          # 0043b4d1
    jg.d8 L_0043b4ea                             # 0043b4d3
    # block 0x0043b4d5: entered by fall-through of jg at 0x0043b4d3, 3 instruction(s), falls into the block at 0x0043b4ea
    movsx edx, word ptr [0x5b5166]               # 0043b4d5
    mov ax, word ptr [0x5b515b]                  # 0043b4dc
    mov word ptr [2*edx + 0x5b5138], ax          # 0043b4e2
L_0043b4ea:
    # block 0x0043b4ea: entered by jg at 0x0043b4d3, 10 instruction(s), ends with jle to 0x0043b53b (forward)
    mov cx, word ptr [0x5b5166]                  # 0043b4ea
    add cx, 0x1                                  # 0043b4f1
    mov word ptr [0x5b5166], cx                  # 0043b4f5
    movsx edx, word ptr [0x5b5166]               # 0043b4fc
    movsx eax, word ptr [0x5b5159]               # 0043b503
    imul eax, eax, 0x8d                          # 0043b50a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b510
    movsx eax, word ptr [ecx + field_21]         # 0043b516
    {load} cmp edx, eax                          # 0043b51a
    jle.d8 L_0043b53b                            # 0043b51c
    # block 0x0043b51e: entered by fall-through of jle at 0x0043b51c, 5 instruction(s), falls into the block at 0x0043b53b
    movsx ecx, word ptr [0x5b5159]               # 0043b51e
    imul ecx, ecx, 0x8d                          # 0043b525
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043b52b
    mov ax, word ptr [edx + field_21]            # 0043b531
    mov word ptr [0x5b5166], ax                  # 0043b535
L_0043b53b:
    # block 0x0043b53b: entered by jmp at 0x0043b49d; jle at 0x0043b51c, 2 instruction(s), ends with je to 0x0043b592 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043b53b
    je.d8 L_0043b592                             # 0043b542
    # block 0x0043b544: entered by fall-through of je at 0x0043b542, 9 instruction(s), ends with je to 0x0043b592 (forward)
    mov edi, 0x547224                            # 0043b544
    movsx ecx, word ptr [0x5b5159]               # 0043b549
    imul ecx, ecx, 0x8d                          # 0043b550
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0043b556
    add esi, 0x235                               # 0043b55c
    mov ecx, 0x9                                 # 0043b562
    {load} xor edx, edx                          # 0043b567
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043b569
    je.d8 L_0043b592                             # 0043b56b
    # block 0x0043b56d: entered by fall-through of je at 0x0043b56b, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043b592
    movsx eax, word ptr [0x5b5159]               # 0043b56d
    imul eax, eax, 0x8d                          # 0043b574
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b57a
    mov dx, word ptr [ecx + field_256]           # 0043b580
    push edx                                     # 0043b587
    mov ecx, 0x5c3a67                            # 0043b588
    call FUN_004fb2e3                            # 0043b58d
L_0043b592:
    # block 0x0043b592: entered by je at 0x0043b3df; jne at 0x0043b3ef; jne at 0x0043b3ff; je at 0x0043b542; je at 0x0043b56b, 4 instruction(s), ends with je to 0x0043b5d3 (forward)
    {load} xor eax, eax                          # 0043b592
    mov al, byte ptr [0x5b5158]                  # 0043b594
    test eax, eax                                # 0043b599
    je.d8 L_0043b5d3                             # 0043b59b
    # block 0x0043b59d: entered by fall-through of je at 0x0043b59b, 4 instruction(s), ends with jne to 0x0043b5d3 (forward)
    {load} xor ecx, ecx                          # 0043b59d
    mov cl, byte ptr [0x5b516a]                  # 0043b59f
    test ecx, ecx                                # 0043b5a5
    jne.d8 L_0043b5d3                            # 0043b5a7
    # block 0x0043b5a9: entered by fall-through of jne at 0x0043b5a7, 2 instruction(s), ends with jne to 0x0043b5d3 (forward)
    cmp dword ptr [0x5c39e5], 0x271a             # 0043b5a9
    jne.d8 L_0043b5d3                            # 0043b5b3
    # block 0x0043b5b5: entered by fall-through of jne at 0x0043b5b3, 4 instruction(s), falls into the block at 0x0043b5d3
    mov byte ptr [0x5b515d], 0x1                 # 0043b5b5
    movsx edx, word ptr [0x5b5159]               # 0043b5bc
    imul edx, edx, 0x8d                          # 0043b5c3
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043b5c9
L_0043b5d3:
    # block 0x0043b5d3: entered by je at 0x0043b59b; jne at 0x0043b5a7; jne at 0x0043b5b3, 4 instruction(s), ends with je to 0x0043b797 (forward)
    {load} xor eax, eax                          # 0043b5d3
    mov al, byte ptr [0x5b615e]                  # 0043b5d5
    test eax, eax                                # 0043b5da
    je.d32 L_0043b797                            # 0043b5dc
    # block 0x0043b5e2: entered by fall-through of je at 0x0043b5dc, 4 instruction(s), ends with jne to 0x0043b797 (forward)
    {load} xor ecx, ecx                          # 0043b5e2
    mov cl, byte ptr [0x5b616a]                  # 0043b5e4
    test ecx, ecx                                # 0043b5ea
    jne.d32 L_0043b797                           # 0043b5ec
    # block 0x0043b5f2: entered by fall-through of jne at 0x0043b5ec, 2 instruction(s), ends with jne to 0x0043b797 (forward)
    cmp dword ptr [0x5c39e5], 0x2722             # 0043b5f2
    jne.d32 L_0043b797                           # 0043b5fc
    # block 0x0043b602: entered by fall-through of jne at 0x0043b5fc, 3 instruction(s), ends with je to 0x0043b797 (forward)
    movsx edx, word ptr [0x5b6161]               # 0043b602
    cmp edx, -0x1                                # 0043b609
    je.d32 L_0043b797                            # 0043b60c
    # block 0x0043b612: entered by fall-through of je at 0x0043b60c, 3 instruction(s), ends with je to 0x0043b797 (forward)
    movsx eax, word ptr [0x5b6163]               # 0043b612
    cmp eax, -0x1                                # 0043b619
    je.d32 L_0043b797                            # 0043b61c
    # block 0x0043b622: entered by fall-through of je at 0x0043b61c, 20 instruction(s), ends with forward jump to 0x0043b697
    movsx ecx, word ptr [0x5b6163]               # 0043b622
    imul ecx, ecx, 0xc                           # 0043b629
    movsx edx, word ptr [0x5b6161]               # 0043b62c
    mov ax, word ptr [ecx + 2*edx + 0x591992]    # 0043b633
    mov word ptr [ebp - local_10], ax            # 0043b63b
    movsx ecx, word ptr [0x5b615f]               # 0043b63f
    imul ecx, ecx, 0x8d                          # 0043b646
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043b64c
    mov ax, word ptr [edx + field_23]            # 0043b652
    mov word ptr [ebp - local_34], ax            # 0043b656
    movsx ecx, word ptr [0x5b615f]               # 0043b65a
    imul ecx, ecx, 0x8d                          # 0043b661
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043b667
    mov ax, word ptr [edx + field_21]            # 0043b66d
    mov word ptr [ebp - local_8], ax             # 0043b671
    mov word ptr [ebp - local_44], 0xffff        # 0043b675
    mov cx, word ptr [ebp - local_44]            # 0043b67b
    mov word ptr [ebp - local_30], cx            # 0043b67f
    mov word ptr [ebp - local_24], 0x0           # 0043b683
    jmp.d8 L_0043b697                            # 0043b689
L_0043b68b:
    # block 0x0043b68b: entered by jmp at 0x0043b6fa, 3 instruction(s), falls into the block at 0x0043b697
    mov dx, word ptr [ebp - local_24]            # 0043b68b
    add dx, 0x1                                  # 0043b68f
    mov word ptr [ebp - local_24], dx            # 0043b693
L_0043b697:
    # block 0x0043b697: entered by jmp at 0x0043b689, 4 instruction(s), ends with jge to 0x0043b6fc (forward)
    movsx eax, word ptr [ebp - local_24]         # 0043b697
    movsx ecx, word ptr [ebp - local_34]         # 0043b69b
    {load} cmp eax, ecx                          # 0043b69f
    jge.d8 L_0043b6fc                            # 0043b6a1
    # block 0x0043b6a3: entered by fall-through of jge at 0x0043b6a1, 2 instruction(s), ends with forward jump to 0x0043b6b7
    mov word ptr [ebp - local_20], 0x0           # 0043b6a3
    jmp.d8 L_0043b6b7                            # 0043b6a9
L_0043b6ab:
    # block 0x0043b6ab: entered by jmp at 0x0043b6ed, 3 instruction(s), falls into the block at 0x0043b6b7
    mov dx, word ptr [ebp - local_20]            # 0043b6ab
    add dx, 0x1                                  # 0043b6af
    mov word ptr [ebp - local_20], dx            # 0043b6b3
L_0043b6b7:
    # block 0x0043b6b7: entered by jmp at 0x0043b6a9, 4 instruction(s), ends with jge to 0x0043b6ef (forward)
    movsx eax, word ptr [ebp - local_20]         # 0043b6b7
    movsx ecx, word ptr [ebp - local_8]          # 0043b6bb
    {load} cmp eax, ecx                          # 0043b6bf
    jge.d8 L_0043b6ef                            # 0043b6c1
    # block 0x0043b6c3: entered by fall-through of jge at 0x0043b6c1, 6 instruction(s), ends with jne to 0x0043b6ed (forward)
    movsx edx, word ptr [ebp - local_24]         # 0043b6c3
    imul edx, edx, 0xc                           # 0043b6c7
    movsx eax, word ptr [ebp - local_20]         # 0043b6ca
    movsx ecx, word ptr [edx + 2*eax + 0x591992] # 0043b6ce
    cmp ecx, -0xa                                # 0043b6d6
    jne.d8 L_0043b6ed                            # 0043b6d9
    # block 0x0043b6db: entered by fall-through of jne at 0x0043b6d9, 5 instruction(s), ends with forward jump to 0x0043b6ef
    mov dx, word ptr [ebp - local_20]            # 0043b6db
    mov word ptr [ebp - local_30], dx            # 0043b6df
    mov ax, word ptr [ebp - local_24]            # 0043b6e3
    mov word ptr [ebp - local_44], ax            # 0043b6e7
    jmp.d8 L_0043b6ef                            # 0043b6eb
L_0043b6ed:
    # block 0x0043b6ed: entered by jne at 0x0043b6d9, 1 instruction(s), ends with backward jump to 0x0043b6ab
    jmp.d8 L_0043b6ab                            # 0043b6ed
L_0043b6ef:
    # block 0x0043b6ef: entered by jge at 0x0043b6c1; jmp at 0x0043b6eb, 3 instruction(s), ends with je to 0x0043b6fa (forward)
    movsx ecx, word ptr [ebp - local_30]         # 0043b6ef
    cmp ecx, -0x1                                # 0043b6f3
    je.d8 L_0043b6fa                             # 0043b6f6
    # block 0x0043b6f8: entered by fall-through of je at 0x0043b6f6, 1 instruction(s), ends with forward jump to 0x0043b6fc
    jmp.d8 L_0043b6fc                            # 0043b6f8
L_0043b6fa:
    # block 0x0043b6fa: entered by je at 0x0043b6f6, 1 instruction(s), ends with backward jump to 0x0043b68b
    jmp.d8 L_0043b68b                            # 0043b6fa
L_0043b6fc:
    # block 0x0043b6fc: entered by jge at 0x0043b6a1; jmp at 0x0043b6f8, 3 instruction(s), ends with je to 0x0043b740 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0043b6fc
    cmp edx, -0x1                                # 0043b700
    je.d8 L_0043b740                             # 0043b703
    # block 0x0043b705: entered by fall-through of je at 0x0043b703, 3 instruction(s), ends with je to 0x0043b740 (forward)
    movsx eax, word ptr [ebp - local_44]         # 0043b705
    cmp eax, -0x1                                # 0043b709
    je.d8 L_0043b740                             # 0043b70c
    # block 0x0043b70e: entered by fall-through of je at 0x0043b70c, 9 instruction(s), falls into the block at 0x0043b740
    movsx ecx, word ptr [ebp - local_44]         # 0043b70e
    imul ecx, ecx, 0xc                           # 0043b712
    movsx edx, word ptr [ebp - local_30]         # 0043b715
    mov ax, word ptr [ebp - local_10]            # 0043b719
    mov word ptr [ecx + 2*edx + 0x591992], ax    # 0043b71d
    movsx ecx, word ptr [0x5b6163]               # 0043b725
    imul ecx, ecx, 0xc                           # 0043b72c
    movsx edx, word ptr [0x5b6161]               # 0043b72f
    mov word ptr [ecx + 2*edx + 0x591992], 0xfff6 # 0043b736
L_0043b740:
    # block 0x0043b740: entered by je at 0x0043b703; je at 0x0043b70c, 2 instruction(s), ends with je to 0x0043b797 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043b740
    je.d8 L_0043b797                             # 0043b747
    # block 0x0043b749: entered by fall-through of je at 0x0043b747, 9 instruction(s), ends with je to 0x0043b797 (forward)
    mov edi, 0x547230                            # 0043b749
    movsx eax, word ptr [0x5b615f]               # 0043b74e
    imul eax, eax, 0x8d                          # 0043b755
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043b75b
    add esi, 0x536                               # 0043b761
    mov ecx, 0x9                                 # 0043b767
    {load} xor edx, edx                          # 0043b76c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043b76e
    je.d8 L_0043b797                             # 0043b770
    # block 0x0043b772: entered by fall-through of je at 0x0043b770, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043b797
    movsx eax, word ptr [0x5b615f]               # 0043b772
    imul eax, eax, 0x8d                          # 0043b779
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b77f
    mov dx, word ptr [ecx + field_557]           # 0043b785
    push edx                                     # 0043b78c
    mov ecx, 0x5c3a67                            # 0043b78d
    call FUN_004fb2e3                            # 0043b792
L_0043b797:
    # block 0x0043b797: entered by je at 0x0043b5dc; jne at 0x0043b5ec; jne at 0x0043b5fc; je at 0x0043b60c; more, 4 instruction(s), ends with je to 0x0043b7d8 (forward)
    {load} xor eax, eax                          # 0043b797
    mov al, byte ptr [0x5b615e]                  # 0043b799
    test eax, eax                                # 0043b79e
    je.d8 L_0043b7d8                             # 0043b7a0
    # block 0x0043b7a2: entered by fall-through of je at 0x0043b7a0, 4 instruction(s), ends with jne to 0x0043b7d8 (forward)
    {load} xor ecx, ecx                          # 0043b7a2
    mov cl, byte ptr [0x5b616a]                  # 0043b7a4
    test ecx, ecx                                # 0043b7aa
    jne.d8 L_0043b7d8                            # 0043b7ac
    # block 0x0043b7ae: entered by fall-through of jne at 0x0043b7ac, 2 instruction(s), ends with jne to 0x0043b7d8 (forward)
    cmp dword ptr [0x5c39e5], 0x2723             # 0043b7ae
    jne.d8 L_0043b7d8                            # 0043b7b8
    # block 0x0043b7ba: entered by fall-through of jne at 0x0043b7b8, 4 instruction(s), falls into the block at 0x0043b7d8
    mov byte ptr [0x5b6165], 0x1                 # 0043b7ba
    movsx edx, word ptr [0x5b615f]               # 0043b7c1
    imul edx, edx, 0x8d                          # 0043b7c8
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043b7ce
L_0043b7d8:
    # block 0x0043b7d8: entered by je at 0x0043b7a0; jne at 0x0043b7ac; jne at 0x0043b7b8, 4 instruction(s), ends with je to 0x0043b8c8 (forward)
    {load} xor eax, eax                          # 0043b7d8
    mov al, byte ptr [0x5b51ab]                  # 0043b7da
    test eax, eax                                # 0043b7df
    je.d32 L_0043b8c8                            # 0043b7e1
    # block 0x0043b7e7: entered by fall-through of je at 0x0043b7e1, 4 instruction(s), ends with jne to 0x0043b8c8 (forward)
    {load} xor ecx, ecx                          # 0043b7e7
    mov cl, byte ptr [0x5b51b9]                  # 0043b7e9
    test ecx, ecx                                # 0043b7ef
    jne.d32 L_0043b8c8                           # 0043b7f1
    # block 0x0043b7f7: entered by fall-through of jne at 0x0043b7f1, 2 instruction(s), ends with jne to 0x0043b8c8 (forward)
    cmp dword ptr [0x5c39e5], 0x271b             # 0043b7f7
    jne.d32 L_0043b8c8                           # 0043b801
    # block 0x0043b807: entered by fall-through of jne at 0x0043b801, 12 instruction(s), ends with jl to 0x0043b85f (forward)
    movsx edx, word ptr [0x5b51ae]               # 0043b807
    mov eax, dword ptr [4*edx + 0x5b516b]        # 0043b80e
    add eax, 0x1                                 # 0043b815
    movsx ecx, word ptr [0x5b51ae]               # 0043b818
    mov dword ptr [4*ecx + 0x5b516b], eax        # 0043b81f
    movsx edx, word ptr [0x5b51ae]               # 0043b826
    movsx eax, word ptr [0x5b51ac]               # 0043b82d
    imul eax, eax, 0x8d                          # 0043b834
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b83a
    movsx eax, word ptr [ecx + field_23]         # 0043b840
    cmp dword ptr [4*edx + 0x5b516b], eax        # 0043b844
    jl.d8 L_0043b85f                             # 0043b84b
    # block 0x0043b84d: entered by fall-through of jl at 0x0043b84b, 2 instruction(s), falls into the block at 0x0043b85f
    movsx ecx, word ptr [0x5b51ae]               # 0043b84d
    mov dword ptr [4*ecx + 0x5b516b], 0x0        # 0043b854
L_0043b85f:
    # block 0x0043b85f: entered by jl at 0x0043b84b, 4 instruction(s), ends with je to 0x0043b8c8 (forward)
    movsx edx, word ptr [0x5b51ae]               # 0043b85f
    mov dword ptr [4*edx + 0x5b518b], 0x1        # 0043b866
    cmp dword ptr [0x5bb1ca], 0x0                # 0043b871
    je.d8 L_0043b8c8                             # 0043b878
    # block 0x0043b87a: entered by fall-through of je at 0x0043b878, 9 instruction(s), ends with je to 0x0043b8c8 (forward)
    mov edi, 0x54723c                            # 0043b87a
    movsx eax, word ptr [0x5b51ac]               # 0043b87f
    imul eax, eax, 0x8d                          # 0043b886
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043b88c
    add esi, 0x271                               # 0043b892
    mov ecx, 0x9                                 # 0043b898
    {load} xor edx, edx                          # 0043b89d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043b89f
    je.d8 L_0043b8c8                             # 0043b8a1
    # block 0x0043b8a3: entered by fall-through of je at 0x0043b8a1, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043b8c8
    movsx eax, word ptr [0x5b51ac]               # 0043b8a3
    imul eax, eax, 0x8d                          # 0043b8aa
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b8b0
    mov dx, word ptr [ecx + field_292]           # 0043b8b6
    push edx                                     # 0043b8bd
    mov ecx, 0x5c3a67                            # 0043b8be
    call FUN_004fb2e3                            # 0043b8c3
L_0043b8c8:
    # block 0x0043b8c8: entered by je at 0x0043b7e1; jne at 0x0043b7f1; jne at 0x0043b801; je at 0x0043b878; je at 0x0043b8a1, 4 instruction(s), ends with je to 0x0043b9b8 (forward)
    {load} xor eax, eax                          # 0043b8c8
    mov al, byte ptr [0x5b51ab]                  # 0043b8ca
    test eax, eax                                # 0043b8cf
    je.d32 L_0043b9b8                            # 0043b8d1
    # block 0x0043b8d7: entered by fall-through of je at 0x0043b8d1, 4 instruction(s), ends with jne to 0x0043b9b8 (forward)
    {load} xor ecx, ecx                          # 0043b8d7
    mov cl, byte ptr [0x5b51b9]                  # 0043b8d9
    test ecx, ecx                                # 0043b8df
    jne.d32 L_0043b9b8                           # 0043b8e1
    # block 0x0043b8e7: entered by fall-through of jne at 0x0043b8e1, 2 instruction(s), ends with jne to 0x0043b9b8 (forward)
    cmp dword ptr [0x5c39e5], 0x271c             # 0043b8e7
    jne.d32 L_0043b9b8                           # 0043b8f1
    # block 0x0043b8f7: entered by fall-through of jne at 0x0043b8f1, 8 instruction(s), ends with jge to 0x0043b94f (forward)
    movsx edx, word ptr [0x5b51ae]               # 0043b8f7
    mov eax, dword ptr [4*edx + 0x5b516b]        # 0043b8fe
    sub eax, 0x1                                 # 0043b905
    movsx ecx, word ptr [0x5b51ae]               # 0043b908
    mov dword ptr [4*ecx + 0x5b516b], eax        # 0043b90f
    movsx edx, word ptr [0x5b51ae]               # 0043b916
    cmp dword ptr [4*edx + 0x5b516b], 0x0        # 0043b91d
    jge.d8 L_0043b94f                            # 0043b925
    # block 0x0043b927: entered by fall-through of jge at 0x0043b925, 7 instruction(s), falls into the block at 0x0043b94f
    movsx eax, word ptr [0x5b51ac]               # 0043b927
    imul eax, eax, 0x8d                          # 0043b92e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043b934
    movsx edx, word ptr [ecx + field_23]         # 0043b93a
    sub edx, 0x1                                 # 0043b93e
    movsx eax, word ptr [0x5b51ae]               # 0043b941
    mov dword ptr [4*eax + 0x5b516b], edx        # 0043b948
L_0043b94f:
    # block 0x0043b94f: entered by jge at 0x0043b925, 4 instruction(s), ends with je to 0x0043b9b8 (forward)
    movsx ecx, word ptr [0x5b51ae]               # 0043b94f
    mov dword ptr [4*ecx + 0x5b518b], 0x1        # 0043b956
    cmp dword ptr [0x5bb1ca], 0x0                # 0043b961
    je.d8 L_0043b9b8                             # 0043b968
    # block 0x0043b96a: entered by fall-through of je at 0x0043b968, 9 instruction(s), ends with je to 0x0043b9b8 (forward)
    mov edi, 0x547248                            # 0043b96a
    movsx edx, word ptr [0x5b51ac]               # 0043b96f
    imul edx, edx, 0x8d                          # 0043b976
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0043b97c
    add esi, 0x271                               # 0043b982
    mov ecx, 0x9                                 # 0043b988
    {load} xor eax, eax                          # 0043b98d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043b98f
    je.d8 L_0043b9b8                             # 0043b991
    # block 0x0043b993: entered by fall-through of je at 0x0043b991, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043b9b8
    movsx ecx, word ptr [0x5b51ac]               # 0043b993
    imul ecx, ecx, 0x8d                          # 0043b99a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043b9a0
    mov ax, word ptr [edx + field_292]           # 0043b9a6
    push eax                                     # 0043b9ad
    mov ecx, 0x5c3a67                            # 0043b9ae
    call FUN_004fb2e3                            # 0043b9b3
L_0043b9b8:
    # block 0x0043b9b8: entered by je at 0x0043b8d1; jne at 0x0043b8e1; jne at 0x0043b8f1; je at 0x0043b968; je at 0x0043b991, 4 instruction(s), ends with je to 0x0043b9fa (forward)
    {load} xor ecx, ecx                          # 0043b9b8
    mov cl, byte ptr [0x5b51ab]                  # 0043b9ba
    test ecx, ecx                                # 0043b9c0
    je.d8 L_0043b9fa                             # 0043b9c2
    # block 0x0043b9c4: entered by fall-through of je at 0x0043b9c2, 4 instruction(s), ends with jne to 0x0043b9fa (forward)
    {load} xor edx, edx                          # 0043b9c4
    mov dl, byte ptr [0x5b51b9]                  # 0043b9c6
    test edx, edx                                # 0043b9cc
    jne.d8 L_0043b9fa                            # 0043b9ce
    # block 0x0043b9d0: entered by fall-through of jne at 0x0043b9ce, 2 instruction(s), ends with jne to 0x0043b9fa (forward)
    cmp dword ptr [0x5c39e5], 0x271d             # 0043b9d0
    jne.d8 L_0043b9fa                            # 0043b9da
    # block 0x0043b9dc: entered by fall-through of jne at 0x0043b9da, 4 instruction(s), falls into the block at 0x0043b9fa
    mov byte ptr [0x5b51b0], 0x1                 # 0043b9dc
    movsx eax, word ptr [0x5b51ac]               # 0043b9e3
    imul eax, eax, 0x8d                          # 0043b9ea
    mov dword ptr [eax + 0x5bb632], 0x2          # 0043b9f0
L_0043b9fa:
    # block 0x0043b9fa: entered by je at 0x0043b9c2; jne at 0x0043b9ce; jne at 0x0043b9da, 4 instruction(s), ends with je to 0x0043baa8 (forward)
    {load} xor ecx, ecx                          # 0043b9fa
    mov cl, byte ptr [0x5b51f6]                  # 0043b9fc
    test ecx, ecx                                # 0043ba02
    je.d32 L_0043baa8                            # 0043ba04
    # block 0x0043ba0a: entered by fall-through of je at 0x0043ba04, 2 instruction(s), ends with je to 0x0043ba20 (forward)
    cmp dword ptr [0x5b5233], 0x0                # 0043ba0a
    je.d8 L_0043ba20                             # 0043ba11
    # block 0x0043ba13: entered by fall-through of je at 0x0043ba11, 2 instruction(s), ends with jne to 0x0043baa8 (forward)
    cmp dword ptr [0x5b5233], 0x1                # 0043ba13
    jne.d32 L_0043baa8                           # 0043ba1a
L_0043ba20:
    # block 0x0043ba20: entered by je at 0x0043ba11; fall-through of jne at 0x0043ba1a, 3 instruction(s), ends with jne to 0x0043baa8 (forward)
    movsx edx, word ptr [0x5b51f7]               # 0043ba20
    cmp edx, -0x1                                # 0043ba27
    jne.d8 L_0043baa8                            # 0043ba2a
    # block 0x0043ba2c: entered by fall-through of jne at 0x0043ba2a, 2 instruction(s), ends with jne to 0x0043baa8 (forward)
    cmp dword ptr [0x5c39e5], 0x2720             # 0043ba2c
    jne.d8 L_0043baa8                            # 0043ba36
    # block 0x0043ba38: entered by fall-through of jne at 0x0043ba36, 8 instruction(s), ends with jne to 0x0043ba84 (forward)
    mov ax, word ptr [0x5b51fd]                  # 0043ba38
    mov word ptr [0x5b51f7], ax                  # 0043ba3e
    movsx ecx, word ptr [0x5b51ee]               # 0043ba44
    mov dl, byte ptr [0x5b51f7]                  # 0043ba4b
    mov byte ptr [ecx + 0x5b51e1], dl            # 0043ba51
    movsx eax, word ptr [0x5b51ee]               # 0043ba57
    test eax, eax                                # 0043ba5e
    jne.d8 L_0043ba84                            # 0043ba60
    # block 0x0043ba62: entered by fall-through of jne at 0x0043ba60, 3 instruction(s), ends with jne to 0x0043ba7a (forward)
    movsx ecx, word ptr [0x5b51f7]               # 0043ba62
    cmp ecx, 0x1                                 # 0043ba69
    jne.d8 L_0043ba7a                            # 0043ba6c
    # block 0x0043ba6e: entered by fall-through of jne at 0x0043ba6c, 2 instruction(s), ends with forward jump to 0x0043ba84
    mov dword ptr [0x5b51f0], 0x1                # 0043ba6e
    jmp.d8 L_0043ba84                            # 0043ba78
L_0043ba7a:
    # block 0x0043ba7a: entered by jne at 0x0043ba6c, 1 instruction(s), falls into the block at 0x0043ba84
    mov dword ptr [0x5b51f0], 0x0                # 0043ba7a
L_0043ba84:
    # block 0x0043ba84: entered by jne at 0x0043ba60; jmp at 0x0043ba78, 5 instruction(s), falls into the block at 0x0043baa8
    mov dx, word ptr [0x5b51ee]                  # 0043ba84
    add dx, 0x1                                  # 0043ba8b
    mov word ptr [0x5b51ee], dx                  # 0043ba8f
    movsx eax, word ptr [0x5b51f7]               # 0043ba96
    mov dword ptr [4*eax + 0x5b5203], 0x1        # 0043ba9d
L_0043baa8:
    # block 0x0043baa8: entered by je at 0x0043ba04; jne at 0x0043ba1a; jne at 0x0043ba2a; jne at 0x0043ba36, 4 instruction(s), ends with je to 0x0043bae7 (forward)
    {load} xor ecx, ecx                          # 0043baa8
    mov cl, byte ptr [0x5b51f6]                  # 0043baaa
    test ecx, ecx                                # 0043bab0
    je.d8 L_0043bae7                             # 0043bab2
    # block 0x0043bab4: entered by fall-through of je at 0x0043bab2, 4 instruction(s), ends with jne to 0x0043bae7 (forward)
    movsx edx, word ptr [0x5b51fb]               # 0043bab4
    imul edx, edx, 0x8d                          # 0043babb
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0043bac1
    jne.d8 L_0043bae7                            # 0043bac8
    # block 0x0043baca: entered by fall-through of jne at 0x0043bac8, 2 instruction(s), ends with jne to 0x0043bae7 (forward)
    cmp dword ptr [0x5c39e5], 0x2721             # 0043baca
    jne.d8 L_0043bae7                            # 0043bad4
    # block 0x0043bad6: entered by fall-through of jne at 0x0043bad4, 2 instruction(s), falls into the block at 0x0043bae7
    mov byte ptr [0x5b51f9], 0x1                 # 0043bad6
    mov dword ptr [0x5b5233], 0x8                # 0043badd
L_0043bae7:
    # block 0x0043bae7: entered by je at 0x0043bab2; jne at 0x0043bac8; jne at 0x0043bad4, 4 instruction(s), ends with je to 0x0043beaa (forward)
    {load} xor eax, eax                          # 0043bae7
    mov al, byte ptr [0x5b51c6]                  # 0043bae9
    test eax, eax                                # 0043baee
    je.d32 L_0043beaa                            # 0043baf0
    # block 0x0043baf6: entered by fall-through of je at 0x0043baf0, 4 instruction(s), ends with jne to 0x0043beaa (forward)
    {load} xor ecx, ecx                          # 0043baf6
    mov cl, byte ptr [0x5b51e0]                  # 0043baf8
    test ecx, ecx                                # 0043bafe
    jne.d32 L_0043beaa                           # 0043bb00
    # block 0x0043bb06: entered by fall-through of jne at 0x0043bb00, 2 instruction(s), ends with jne to 0x0043beaa (forward)
    cmp dword ptr [0x5c39e5], 0x271e             # 0043bb06
    jne.d32 L_0043beaa                           # 0043bb10
    # block 0x0043bb16: entered by fall-through of jne at 0x0043bb10, 4 instruction(s), ends with je to 0x0043bb4b (forward)
    movsx edx, word ptr [0x5b51c9]               # 0043bb16
    mov dword ptr [ebp - local_cc], edx          # 0043bb1d
    cmp dword ptr [ebp - local_cc], 0x0          # 0043bb23
    je.d8 L_0043bb4b                             # 0043bb2a
    # block 0x0043bb2c: entered by fall-through of je at 0x0043bb2a, 2 instruction(s), ends with je to 0x0043bc28 (forward)
    cmp dword ptr [ebp - local_cc], 0x1          # 0043bb2c
    je.d32 L_0043bc28                            # 0043bb33
    # block 0x0043bb39: entered by fall-through of je at 0x0043bb33, 2 instruction(s), ends with je to 0x0043bd6c (forward)
    cmp dword ptr [ebp - local_cc], 0x2          # 0043bb39
    je.d32 L_0043bd6c                            # 0043bb40
    # block 0x0043bb46: entered by fall-through of je at 0x0043bb40, 1 instruction(s), ends with forward jump to 0x0043beaa
    jmp.d32 L_0043beaa                           # 0043bb46
L_0043bb4b:
    # block 0x0043bb4b: entered by je at 0x0043bb2a, 4 instruction(s), ends with je to 0x0043bb6a (forward)
    mov eax, dword ptr [0x5b51d4]                # 0043bb4b
    mov dword ptr [ebp - local_d0], eax          # 0043bb50
    cmp dword ptr [ebp - local_d0], 0x0          # 0043bb56
    je.d8 L_0043bb6a                             # 0043bb5d
    # block 0x0043bb5f: entered by fall-through of je at 0x0043bb5d, 2 instruction(s), ends with je to 0x0043bb9d (forward)
    cmp dword ptr [ebp - local_d0], 0x1          # 0043bb5f
    je.d8 L_0043bb9d                             # 0043bb66
    # block 0x0043bb68: entered by fall-through of je at 0x0043bb66, 1 instruction(s), ends with forward jump to 0x0043bbcc
    jmp.d8 L_0043bbcc                            # 0043bb68
L_0043bb6a:
    # block 0x0043bb6a: entered by je at 0x0043bb5d, 5 instruction(s), ends with jge to 0x0043bb9b (forward)
    mov ecx, dword ptr [0x5b51ba]                # 0043bb6a
    sub ecx, 0x1                                 # 0043bb70
    mov dword ptr [0x5b51ba], ecx                # 0043bb73
    cmp dword ptr [0x5b51ba], 0x0                # 0043bb79
    jge.d8 L_0043bb9b                            # 0043bb80
    # block 0x0043bb82: entered by fall-through of jge at 0x0043bb80, 4 instruction(s), falls into the block at 0x0043bb9b
    mov edx, dword ptr [0x5b51ba]                # 0043bb82
    add edx, 0x2                                 # 0043bb88
    mov dword ptr [0x5b51ba], edx                # 0043bb8b
    mov dword ptr [0x5b51d4], 0x1                # 0043bb91
L_0043bb9b:
    # block 0x0043bb9b: entered by jge at 0x0043bb80, 1 instruction(s), ends with forward jump to 0x0043bbcc
    jmp.d8 L_0043bbcc                            # 0043bb9b
L_0043bb9d:
    # block 0x0043bb9d: entered by je at 0x0043bb66, 5 instruction(s), ends with jne to 0x0043bbcc (forward)
    mov eax, dword ptr [0x5b51ba]                # 0043bb9d
    add eax, 0x1                                 # 0043bba2
    mov dword ptr [0x5b51ba], eax                # 0043bba5
    cmp dword ptr [0x5b51ba], 0x4                # 0043bbaa
    jne.d8 L_0043bbcc                            # 0043bbb1
    # block 0x0043bbb3: entered by fall-through of jne at 0x0043bbb1, 4 instruction(s), falls into the block at 0x0043bbcc
    mov ecx, dword ptr [0x5b51ba]                # 0043bbb3
    sub ecx, 0x2                                 # 0043bbb9
    mov dword ptr [0x5b51ba], ecx                # 0043bbbc
    mov dword ptr [0x5b51d4], 0x0                # 0043bbc2
L_0043bbcc:
    # block 0x0043bbcc: entered by jmp at 0x0043bb68; jmp at 0x0043bb9b; jne at 0x0043bbb1, 2 instruction(s), ends with je to 0x0043bc23 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043bbcc
    je.d8 L_0043bc23                             # 0043bbd3
    # block 0x0043bbd5: entered by fall-through of je at 0x0043bbd3, 9 instruction(s), ends with je to 0x0043bc23 (forward)
    mov edi, 0x547254                            # 0043bbd5
    movsx edx, word ptr [0x5b51c7]               # 0043bbda
    imul edx, edx, 0x8d                          # 0043bbe1
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0043bbe7
    add esi, 0x117                               # 0043bbed
    mov ecx, 0x9                                 # 0043bbf3
    {load} xor eax, eax                          # 0043bbf8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043bbfa
    je.d8 L_0043bc23                             # 0043bbfc
    # block 0x0043bbfe: entered by fall-through of je at 0x0043bbfc, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043bc23
    movsx ecx, word ptr [0x5b51c7]               # 0043bbfe
    imul ecx, ecx, 0x8d                          # 0043bc05
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043bc0b
    mov ax, word ptr [edx + field_138]           # 0043bc11
    push eax                                     # 0043bc18
    mov ecx, 0x5c3a67                            # 0043bc19
    call FUN_004fb2e3                            # 0043bc1e
L_0043bc23:
    # block 0x0043bc23: entered by je at 0x0043bbd3; je at 0x0043bbfc, 1 instruction(s), ends with forward jump to 0x0043beaa
    jmp.d32 L_0043beaa                           # 0043bc23
L_0043bc28:
    # block 0x0043bc28: entered by je at 0x0043bb33, 2 instruction(s), ends with jne to 0x0043bd10 (forward)
    cmp dword ptr [0x5b51ba], 0x1                # 0043bc28
    jne.d32 L_0043bd10                           # 0043bc2f
    # block 0x0043bc35: entered by fall-through of jne at 0x0043bc2f, 4 instruction(s), ends with je to 0x0043bc55 (forward)
    mov ecx, dword ptr [0x5b51d8]                # 0043bc35
    mov dword ptr [ebp - local_d4], ecx          # 0043bc3b
    cmp dword ptr [ebp - local_d4], 0x0          # 0043bc41
    je.d8 L_0043bc55                             # 0043bc48
    # block 0x0043bc4a: entered by fall-through of je at 0x0043bc48, 2 instruction(s), ends with je to 0x0043bc86 (forward)
    cmp dword ptr [ebp - local_d4], 0x1          # 0043bc4a
    je.d8 L_0043bc86                             # 0043bc51
    # block 0x0043bc53: entered by fall-through of je at 0x0043bc51, 1 instruction(s), ends with forward jump to 0x0043bcb7
    jmp.d8 L_0043bcb7                            # 0043bc53
L_0043bc55:
    # block 0x0043bc55: entered by je at 0x0043bc48, 5 instruction(s), ends with jge to 0x0043bc84 (forward)
    mov edx, dword ptr [0x5b51be]                # 0043bc55
    sub edx, 0x1                                 # 0043bc5b
    mov dword ptr [0x5b51be], edx                # 0043bc5e
    cmp dword ptr [0x5b51be], 0x0                # 0043bc64
    jge.d8 L_0043bc84                            # 0043bc6b
    # block 0x0043bc6d: entered by fall-through of jge at 0x0043bc6b, 4 instruction(s), falls into the block at 0x0043bc84
    mov eax, dword ptr [0x5b51be]                # 0043bc6d
    add eax, 0x2                                 # 0043bc72
    mov dword ptr [0x5b51be], eax                # 0043bc75
    mov dword ptr [0x5b51d8], 0x1                # 0043bc7a
L_0043bc84:
    # block 0x0043bc84: entered by jge at 0x0043bc6b, 1 instruction(s), ends with forward jump to 0x0043bcb7
    jmp.d8 L_0043bcb7                            # 0043bc84
L_0043bc86:
    # block 0x0043bc86: entered by je at 0x0043bc51, 5 instruction(s), ends with jne to 0x0043bcb7 (forward)
    mov ecx, dword ptr [0x5b51be]                # 0043bc86
    add ecx, 0x1                                 # 0043bc8c
    mov dword ptr [0x5b51be], ecx                # 0043bc8f
    cmp dword ptr [0x5b51be], 0x4                # 0043bc95
    jne.d8 L_0043bcb7                            # 0043bc9c
    # block 0x0043bc9e: entered by fall-through of jne at 0x0043bc9c, 4 instruction(s), falls into the block at 0x0043bcb7
    mov edx, dword ptr [0x5b51be]                # 0043bc9e
    sub edx, 0x2                                 # 0043bca4
    mov dword ptr [0x5b51be], edx                # 0043bca7
    mov dword ptr [0x5b51d8], 0x0                # 0043bcad
L_0043bcb7:
    # block 0x0043bcb7: entered by jmp at 0x0043bc53; jmp at 0x0043bc84; jne at 0x0043bc9c, 2 instruction(s), ends with je to 0x0043bd0e (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043bcb7
    je.d8 L_0043bd0e                             # 0043bcbe
    # block 0x0043bcc0: entered by fall-through of je at 0x0043bcbe, 9 instruction(s), ends with je to 0x0043bd0e (forward)
    mov edi, 0x547260                            # 0043bcc0
    movsx eax, word ptr [0x5b51c7]               # 0043bcc5
    imul eax, eax, 0x8d                          # 0043bccc
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043bcd2
    add esi, 0x117                               # 0043bcd8
    mov ecx, 0x9                                 # 0043bcde
    {load} xor edx, edx                          # 0043bce3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043bce5
    je.d8 L_0043bd0e                             # 0043bce7
    # block 0x0043bce9: entered by fall-through of je at 0x0043bce7, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043bd0e
    movsx eax, word ptr [0x5b51c7]               # 0043bce9
    imul eax, eax, 0x8d                          # 0043bcf0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043bcf6
    mov dx, word ptr [ecx + field_138]           # 0043bcfc
    push edx                                     # 0043bd03
    mov ecx, 0x5c3a67                            # 0043bd04
    call FUN_004fb2e3                            # 0043bd09
L_0043bd0e:
    # block 0x0043bd0e: entered by je at 0x0043bcbe; je at 0x0043bce7, 1 instruction(s), ends with forward jump to 0x0043bd67
    jmp.d8 L_0043bd67                            # 0043bd0e
L_0043bd10:
    # block 0x0043bd10: entered by jne at 0x0043bc2f, 2 instruction(s), ends with je to 0x0043bd67 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043bd10
    je.d8 L_0043bd67                             # 0043bd17
    # block 0x0043bd19: entered by fall-through of je at 0x0043bd17, 9 instruction(s), ends with je to 0x0043bd67 (forward)
    mov edi, 0x54726c                            # 0043bd19
    movsx eax, word ptr [0x5b51c7]               # 0043bd1e
    imul eax, eax, 0x8d                          # 0043bd25
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043bd2b
    add esi, 0x148                               # 0043bd31
    mov ecx, 0x9                                 # 0043bd37
    {load} xor edx, edx                          # 0043bd3c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043bd3e
    je.d8 L_0043bd67                             # 0043bd40
    # block 0x0043bd42: entered by fall-through of je at 0x0043bd40, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043bd67
    movsx eax, word ptr [0x5b51c7]               # 0043bd42
    imul eax, eax, 0x8d                          # 0043bd49
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043bd4f
    mov dx, word ptr [ecx + field_169]           # 0043bd55
    push edx                                     # 0043bd5c
    mov ecx, 0x5c3a67                            # 0043bd5d
    call FUN_004fb2e3                            # 0043bd62
L_0043bd67:
    # block 0x0043bd67: entered by jmp at 0x0043bd0e; je at 0x0043bd17; je at 0x0043bd40, 1 instruction(s), ends with forward jump to 0x0043beaa
    jmp.d32 L_0043beaa                           # 0043bd67
L_0043bd6c:
    # block 0x0043bd6c: entered by je at 0x0043bb40, 2 instruction(s), ends with jne to 0x0043be53 (forward)
    cmp dword ptr [0x5b51ba], 0x2                # 0043bd6c
    jne.d32 L_0043be53                           # 0043bd73
    # block 0x0043bd79: entered by fall-through of jne at 0x0043bd73, 4 instruction(s), ends with je to 0x0043bd98 (forward)
    mov eax, dword ptr [0x5b51dc]                # 0043bd79
    mov dword ptr [ebp - local_d8], eax          # 0043bd7e
    cmp dword ptr [ebp - local_d8], 0x0          # 0043bd84
    je.d8 L_0043bd98                             # 0043bd8b
    # block 0x0043bd8d: entered by fall-through of je at 0x0043bd8b, 2 instruction(s), ends with je to 0x0043bdcb (forward)
    cmp dword ptr [ebp - local_d8], 0x1          # 0043bd8d
    je.d8 L_0043bdcb                             # 0043bd94
    # block 0x0043bd96: entered by fall-through of je at 0x0043bd94, 1 instruction(s), ends with forward jump to 0x0043bdfa
    jmp.d8 L_0043bdfa                            # 0043bd96
L_0043bd98:
    # block 0x0043bd98: entered by je at 0x0043bd8b, 5 instruction(s), ends with jge to 0x0043bdc9 (forward)
    mov ecx, dword ptr [0x5b51c2]                # 0043bd98
    sub ecx, 0x1                                 # 0043bd9e
    mov dword ptr [0x5b51c2], ecx                # 0043bda1
    cmp dword ptr [0x5b51c2], 0x0                # 0043bda7
    jge.d8 L_0043bdc9                            # 0043bdae
    # block 0x0043bdb0: entered by fall-through of jge at 0x0043bdae, 4 instruction(s), falls into the block at 0x0043bdc9
    mov edx, dword ptr [0x5b51c2]                # 0043bdb0
    add edx, 0x2                                 # 0043bdb6
    mov dword ptr [0x5b51c2], edx                # 0043bdb9
    mov dword ptr [0x5b51dc], 0x1                # 0043bdbf
L_0043bdc9:
    # block 0x0043bdc9: entered by jge at 0x0043bdae, 1 instruction(s), ends with forward jump to 0x0043bdfa
    jmp.d8 L_0043bdfa                            # 0043bdc9
L_0043bdcb:
    # block 0x0043bdcb: entered by je at 0x0043bd94, 5 instruction(s), ends with jne to 0x0043bdfa (forward)
    mov eax, dword ptr [0x5b51c2]                # 0043bdcb
    add eax, 0x1                                 # 0043bdd0
    mov dword ptr [0x5b51c2], eax                # 0043bdd3
    cmp dword ptr [0x5b51c2], 0x4                # 0043bdd8
    jne.d8 L_0043bdfa                            # 0043bddf
    # block 0x0043bde1: entered by fall-through of jne at 0x0043bddf, 4 instruction(s), falls into the block at 0x0043bdfa
    mov ecx, dword ptr [0x5b51c2]                # 0043bde1
    sub ecx, 0x2                                 # 0043bde7
    mov dword ptr [0x5b51c2], ecx                # 0043bdea
    mov dword ptr [0x5b51dc], 0x0                # 0043bdf0
L_0043bdfa:
    # block 0x0043bdfa: entered by jmp at 0x0043bd96; jmp at 0x0043bdc9; jne at 0x0043bddf, 2 instruction(s), ends with je to 0x0043be51 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043bdfa
    je.d8 L_0043be51                             # 0043be01
    # block 0x0043be03: entered by fall-through of je at 0x0043be01, 9 instruction(s), ends with je to 0x0043be51 (forward)
    mov edi, 0x547278                            # 0043be03
    movsx edx, word ptr [0x5b51c7]               # 0043be08
    imul edx, edx, 0x8d                          # 0043be0f
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0043be15
    add esi, 0x117                               # 0043be1b
    mov ecx, 0x9                                 # 0043be21
    {load} xor eax, eax                          # 0043be26
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043be28
    je.d8 L_0043be51                             # 0043be2a
    # block 0x0043be2c: entered by fall-through of je at 0x0043be2a, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043be51
    movsx ecx, word ptr [0x5b51c7]               # 0043be2c
    imul ecx, ecx, 0x8d                          # 0043be33
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043be39
    mov ax, word ptr [edx + field_138]           # 0043be3f
    push eax                                     # 0043be46
    mov ecx, 0x5c3a67                            # 0043be47
    call FUN_004fb2e3                            # 0043be4c
L_0043be51:
    # block 0x0043be51: entered by je at 0x0043be01; je at 0x0043be2a, 1 instruction(s), ends with forward jump to 0x0043beaa
    jmp.d8 L_0043beaa                            # 0043be51
L_0043be53:
    # block 0x0043be53: entered by jne at 0x0043bd73, 2 instruction(s), ends with je to 0x0043beaa (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043be53
    je.d8 L_0043beaa                             # 0043be5a
    # block 0x0043be5c: entered by fall-through of je at 0x0043be5a, 9 instruction(s), ends with je to 0x0043beaa (forward)
    mov edi, 0x547284                            # 0043be5c
    movsx ecx, word ptr [0x5b51c7]               # 0043be61
    imul ecx, ecx, 0x8d                          # 0043be68
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0043be6e
    add esi, 0x148                               # 0043be74
    mov ecx, 0x9                                 # 0043be7a
    {load} xor edx, edx                          # 0043be7f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043be81
    je.d8 L_0043beaa                             # 0043be83
    # block 0x0043be85: entered by fall-through of je at 0x0043be83, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0043beaa
    movsx eax, word ptr [0x5b51c7]               # 0043be85
    imul eax, eax, 0x8d                          # 0043be8c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043be92
    mov dx, word ptr [ecx + field_169]           # 0043be98
    push edx                                     # 0043be9f
    mov ecx, 0x5c3a67                            # 0043bea0
    call FUN_004fb2e3                            # 0043bea5
L_0043beaa:
    # block 0x0043beaa: entered by je at 0x0043baf0; jne at 0x0043bb00; jne at 0x0043bb10; jmp at 0x0043bb46; more, 4 instruction(s), ends with je to 0x0043beeb (forward)
    {load} xor eax, eax                          # 0043beaa
    mov al, byte ptr [0x5b51c6]                  # 0043beac
    test eax, eax                                # 0043beb1
    je.d8 L_0043beeb                             # 0043beb3
    # block 0x0043beb5: entered by fall-through of je at 0x0043beb3, 4 instruction(s), ends with jne to 0x0043beeb (forward)
    {load} xor ecx, ecx                          # 0043beb5
    mov cl, byte ptr [0x5b51e0]                  # 0043beb7
    test ecx, ecx                                # 0043bebd
    jne.d8 L_0043beeb                            # 0043bebf
    # block 0x0043bec1: entered by fall-through of jne at 0x0043bebf, 2 instruction(s), ends with jne to 0x0043beeb (forward)
    cmp dword ptr [0x5c39e5], 0x271f             # 0043bec1
    jne.d8 L_0043beeb                            # 0043becb
    # block 0x0043becd: entered by fall-through of jne at 0x0043becb, 4 instruction(s), falls into the block at 0x0043beeb
    mov byte ptr [0x5b51cb], 0x1                 # 0043becd
    movsx edx, word ptr [0x5b51c7]               # 0043bed4
    imul edx, edx, 0x8d                          # 0043bedb
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043bee1
L_0043beeb:
    # block 0x0043beeb: entered by je at 0x0043beb3; jne at 0x0043bebf; jne at 0x0043becb, 4 instruction(s), ends with je to 0x0043bf2c (forward)
    {load} xor eax, eax                          # 0043beeb
    mov al, byte ptr [0x5b61af]                  # 0043beed
    test eax, eax                                # 0043bef2
    je.d8 L_0043bf2c                             # 0043bef4
    # block 0x0043bef6: entered by fall-through of je at 0x0043bef4, 4 instruction(s), ends with jne to 0x0043bf2c (forward)
    {load} xor ecx, ecx                          # 0043bef6
    mov cl, byte ptr [0x5b61bc]                  # 0043bef8
    test ecx, ecx                                # 0043befe
    jne.d8 L_0043bf2c                            # 0043bf00
    # block 0x0043bf02: entered by fall-through of jne at 0x0043bf00, 2 instruction(s), ends with jne to 0x0043bf2c (forward)
    cmp dword ptr [0x5c39e5], 0x2724             # 0043bf02
    jne.d8 L_0043bf2c                            # 0043bf0c
    # block 0x0043bf0e: entered by fall-through of jne at 0x0043bf0c, 4 instruction(s), falls into the block at 0x0043bf2c
    mov byte ptr [0x5b61b2], 0x1                 # 0043bf0e
    movsx edx, word ptr [0x5b61b0]               # 0043bf15
    imul edx, edx, 0x8d                          # 0043bf1c
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043bf22
L_0043bf2c:
    # block 0x0043bf2c: entered by je at 0x0043bef4; jne at 0x0043bf00; jne at 0x0043bf0c, 2 instruction(s), ends with jne to 0x0043bf69 (forward)
    cmp dword ptr [0x5c39e5], 0x2711             # 0043bf2c
    jne.d8 L_0043bf69                            # 0043bf36
    # block 0x0043bf38: entered by fall-through of jne at 0x0043bf36, 4 instruction(s), calls FUN_004d3c31, ends with jne to 0x0043bf69 (forward)
    mov ecx, 0x61c387                            # 0043bf38
    call FUN_004d3c31                            # 0043bf3d
    test eax, eax                                # 0043bf42
    jne.d8 L_0043bf69                            # 0043bf44
    # block 0x0043bf46: entered by fall-through of jne at 0x0043bf44, 4 instruction(s), ends with jne to 0x0043bf69 (forward)
    {load} xor eax, eax                          # 0043bf46
    mov al, byte ptr [0x61c6ad]                  # 0043bf48
    test eax, eax                                # 0043bf4d
    jne.d8 L_0043bf69                            # 0043bf4f
    # block 0x0043bf51: entered by fall-through of jne at 0x0043bf4f, 2 instruction(s), ends with jne to 0x0043bf69 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 0043bf51
    jne.d8 L_0043bf69                            # 0043bf58
    # block 0x0043bf5a: entered by fall-through of jne at 0x0043bf58, 3 instruction(s), calls FUN_004d3c42, ends with forward jump to 0x0043c09c
    mov ecx, 0x61c387                            # 0043bf5a
    call FUN_004d3c42                            # 0043bf5f
    jmp.d32 L_0043c09c                           # 0043bf64
L_0043bf69:
    # block 0x0043bf69: entered by jne at 0x0043bf36; jne at 0x0043bf44; jne at 0x0043bf4f; jne at 0x0043bf58, 2 instruction(s), ends with jne to 0x0043bfb6 (forward)
    cmp dword ptr [0x5c39e5], 0x2711             # 0043bf69
    jne.d8 L_0043bfb6                            # 0043bf73
    # block 0x0043bf75: entered by fall-through of jne at 0x0043bf73, 4 instruction(s), calls FUN_004d3c31, ends with je to 0x0043bfb6 (forward)
    mov ecx, 0x61c387                            # 0043bf75
    call FUN_004d3c31                            # 0043bf7a
    test eax, eax                                # 0043bf7f
    je.d8 L_0043bfb6                             # 0043bf81
    # block 0x0043bf83: entered by fall-through of je at 0x0043bf81, 4 instruction(s), ends with jne to 0x0043bfb6 (forward)
    {load} xor ecx, ecx                          # 0043bf83
    mov cl, byte ptr [0x61c6ad]                  # 0043bf85
    test ecx, ecx                                # 0043bf8b
    jne.d8 L_0043bfb6                            # 0043bf8d
    # block 0x0043bf8f: entered by fall-through of jne at 0x0043bf8d, 4 instruction(s), calls FUN_004d3c1d, ends with jne to 0x0043bfb6 (forward)
    mov ecx, 0x61c387                            # 0043bf8f
    call FUN_004d3c1d                            # 0043bf94
    cmp eax, 0x2                                 # 0043bf99
    jne.d8 L_0043bfb6                            # 0043bf9c
    # block 0x0043bf9e: entered by fall-through of jne at 0x0043bf9c, 2 instruction(s), ends with jne to 0x0043bfb6 (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 0043bf9e
    jne.d8 L_0043bfb6                            # 0043bfa5
    # block 0x0043bfa7: entered by fall-through of jne at 0x0043bfa5, 3 instruction(s), calls FUN_004d3d20, ends with forward jump to 0x0043c09c
    mov ecx, 0x61c387                            # 0043bfa7
    call FUN_004d3d20                            # 0043bfac
    jmp.d32 L_0043c09c                           # 0043bfb1
L_0043bfb6:
    # block 0x0043bfb6: entered by jne at 0x0043bf73; je at 0x0043bf81; jne at 0x0043bf8d; jne at 0x0043bf9c; more, 2 instruction(s), ends with jl to 0x0043c09c (forward)
    cmp dword ptr [0x5c39e5], 0x0                # 0043bfb6
    jl.d32 L_0043c09c                            # 0043bfbd
    # block 0x0043bfc3: entered by fall-through of jl at 0x0043bfbd, 2 instruction(s), ends with jge to 0x0043c09c (forward)
    cmp dword ptr [0x5c39e5], 0xf0               # 0043bfc3
    jge.d32 L_0043c09c                           # 0043bfcd
    # block 0x0043bfd3: entered by fall-through of jge at 0x0043bfcd, 2 instruction(s), ends with jne to 0x0043c09c (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 0043bfd3
    jne.d32 L_0043c09c                           # 0043bfda
    # block 0x0043bfe0: entered by fall-through of jne at 0x0043bfda, 8 instruction(s), calls FUN_0042405a, ends with je to 0x0043c048 (forward)
    mov edx, dword ptr [0x5c39e5]                # 0043bfe0
    imul edx, edx, 0x8d                          # 0043bfe6
    add edx, 0x5bb5e9                            # 0043bfec
    push edx                                     # 0043bff2
    mov ecx, 0x63786d                            # 0043bff3
    call FUN_0042405a                            # 0043bff8
    test eax, eax                                # 0043bffd
    je.d8 L_0043c048                             # 0043bfff
    # block 0x0043c001: entered by fall-through of je at 0x0043bfff, 9 instruction(s), calls FUN_00423f57, ends with je to 0x0043c074 (forward)
    push 0x0                                     # 0043c001
    mov eax, dword ptr [0x5c39e5]                # 0043c003
    imul eax, eax, 0x8d                          # 0043c008
    add eax, 0x5bb5e9                            # 0043c00e
    push eax                                     # 0043c013
    mov ecx, 0x63786d                            # 0043c014
    call FUN_00423f57                            # 0043c019
    test eax, eax                                # 0043c01e
    je.d8 L_0043c074                             # 0043c020
    # block 0x0043c022: entered by fall-through of je at 0x0043c020, 9 instruction(s), calls FUN_00424035, ends with je to 0x0043c074 (forward)
    mov ecx, dword ptr [0x5c39e5]                # 0043c022
    imul ecx, ecx, 0x8d                          # 0043c028
    add ecx, 0x5bb5e9                            # 0043c02e
    push ecx                                     # 0043c034
    mov ecx, 0x63786d                            # 0043c035
    call FUN_00424035                            # 0043c03a
    mov dword ptr [ebp - local_40], eax          # 0043c03f
    cmp dword ptr [ebp - local_40], -0x1         # 0043c042
    je.d8 L_0043c074                             # 0043c046
L_0043c048:
    # block 0x0043c048: entered by je at 0x0043bfff; fall-through of je at 0x0043c046, 5 instruction(s), ends with jl to 0x0043c072 (forward)
    mov edx, dword ptr [0x5c39e5]                # 0043c048
    imul edx, edx, 0x8d                          # 0043c04e
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043c054
    cmp dword ptr [ebp - local_40], 0x0          # 0043c05e
    jl.d8 L_0043c072                             # 0043c062
    # block 0x0043c064: entered by fall-through of jl at 0x0043c062, 4 instruction(s), calls FUN_004eb107, falls into the block at 0x0043c072
    mov eax, dword ptr [ebp - local_40]          # 0043c064
    push eax                                     # 0043c067
    mov ecx, 0x571442                            # 0043c068
    call FUN_004eb107                            # 0043c06d
L_0043c072:
    # block 0x0043c072: entered by jl at 0x0043c062, 1 instruction(s), ends with forward jump to 0x0043c09c
    jmp.d8 L_0043c09c                            # 0043c072
L_0043c074:
    # block 0x0043c074: entered by je at 0x0043c020; je at 0x0043c046, 9 instruction(s), calls FUN_00423fbb, FUN_004eb184, falls into the block at 0x0043c09c
    mov ecx, dword ptr [0x5c39e5]                # 0043c074
    imul ecx, ecx, 0x8d                          # 0043c07a
    add ecx, 0x5bb5e9                            # 0043c080
    push ecx                                     # 0043c086
    mov ecx, 0x63786d                            # 0043c087
    call FUN_00423fbb                            # 0043c08c
    push eax                                     # 0043c091
    mov ecx, 0x571442                            # 0043c092
    call FUN_004eb184                            # 0043c097
L_0043c09c:
    # block 0x0043c09c: entered by jmp at 0x0043bf64; jmp at 0x0043bfb1; jl at 0x0043bfbd; jge at 0x0043bfcd; more, 1 instruction(s), ends with forward jump to 0x0043c0cc
    jmp.d8 L_0043c0cc                            # 0043c09c
L_0043c09e:
    # block 0x0043c09e: entered by switch case, 3 instruction(s), calls FUN_004e78c2, ends with forward jump to 0x0043c0cc
    mov ecx, 0x582711                            # 0043c09e
    call FUN_004e78c2                            # 0043c0a3
    jmp.d8 L_0043c0cc                            # 0043c0a8
L_0043c0aa:
    # block 0x0043c0aa: entered by switch case, 3 instruction(s), calls FUN_004e8dc8, ends with forward jump to 0x0043c0cc
    mov ecx, 0x571442                            # 0043c0aa
    call FUN_004e8dc8                            # 0043c0af
    jmp.d8 L_0043c0cc                            # 0043c0b4
L_0043c0b6:
    # block 0x0043c0b6: entered by switch case, 3 instruction(s), calls FUN_004ec087, ends with forward jump to 0x0043c0cc
    mov ecx, 0x57fd34                            # 0043c0b6
    call FUN_004ec087                            # 0043c0bb
    jmp.d8 L_0043c0cc                            # 0043c0c0
L_0043c0c2:
    # block 0x0043c0c2: entered by switch case, 2 instruction(s), calls FUN_004e467f, falls into the block at 0x0043c0cc
    mov ecx, 0x57975c                            # 0043c0c2
    call FUN_004e467f                            # 0043c0c7
L_0043c0cc:
    # block 0x0043c0cc: entered by jmp at 0x0043c09c; jmp at 0x0043c0a8; jmp at 0x0043c0b4; jmp at 0x0043c0c0, 1 instruction(s), ends with forward jump to 0x0043cc61
    jmp.d32 L_0043cc61                           # 0043c0cc
L_0043c0d1:
    # block 0x0043c0d1: entered by je at 0x0043b1a0, 4 instruction(s), calls FUN_004daf6e, ends with je to 0x0043c133 (forward)
    mov ecx, 0x5830a6                            # 0043c0d1
    call FUN_004daf6e                            # 0043c0d6
    test eax, eax                                # 0043c0db
    je.d8 L_0043c133                             # 0043c0dd
    # block 0x0043c0df: entered by fall-through of je at 0x0043c0dd, 7 instruction(s), ends with ja to 0x0043c110 (forward)
    mov edx, dword ptr [0x583204]                # 0043c0df
    mov dword ptr [ebp - local_dc], edx          # 0043c0e5
    mov eax, dword ptr [ebp - local_dc]          # 0043c0eb
    sub eax, 0x2                                 # 0043c0f1
    mov dword ptr [ebp - local_dc], eax          # 0043c0f4
    cmp dword ptr [ebp - local_dc], 0x3          # 0043c0fa
    ja.d8 L_0043c110                             # 0043c101
    # block 0x0043c103: entered by fall-through of ja at 0x0043c101, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x43d1d3]
    mov ecx, dword ptr [ebp - local_dc]          # 0043c103
    jmp dword ptr [4*ecx + SWTAB_0043d1d3_VA]    # 0043c109
L_0043c110:
    # block 0x0043c110: entered by ja at 0x0043c101, 6 instruction(s), calls FUN_004ad590, FUN_00484ac0, FUN_0047ef0f, falls into the block at 0x0043c12e
    mov ecx, 0x6369e4                            # 0043c110
    call FUN_004ad590                            # 0043c115
    mov ecx, 0x6252ad                            # 0043c11a
    call FUN_00484ac0                            # 0043c11f
    mov ecx, 0x625ee8                            # 0043c124
    call FUN_0047ef0f                            # 0043c129
L_0043c12e:
    # block 0x0043c12e: entered by switch case, 1 instruction(s), ends with forward jump to 0x0043cc61
    jmp.d32 L_0043cc61                           # 0043c12e
L_0043c133:
    # block 0x0043c133: entered by je at 0x0043c0dd, 4 instruction(s), ends with je to 0x0043c14e (forward)
    {load} xor edx, edx                          # 0043c133
    mov dl, byte ptr [0x58321d]                  # 0043c135
    test edx, edx                                # 0043c13b
    je.d8 L_0043c14e                             # 0043c13d
    # block 0x0043c13f: entered by fall-through of je at 0x0043c13d, 4 instruction(s), ends with je to 0x0043c1f4 (forward)
    {load} xor eax, eax                          # 0043c13f
    mov al, byte ptr [0x58321e]                  # 0043c141
    test eax, eax                                # 0043c146
    je.d32 L_0043c1f4                            # 0043c148
L_0043c14e:
    # block 0x0043c14e: entered by je at 0x0043c13d; fall-through of je at 0x0043c148, 4 instruction(s), ends with jne to 0x0043c173 (forward)
    {load} xor ecx, ecx                          # 0043c14e
    mov cl, byte ptr [0x58321d]                  # 0043c150
    test ecx, ecx                                # 0043c156
    jne.d8 L_0043c173                            # 0043c158
    # block 0x0043c15a: entered by fall-through of jne at 0x0043c158, 4 instruction(s), ends with je to 0x0043c173 (forward)
    {load} xor edx, edx                          # 0043c15a
    mov dl, byte ptr [0x58321e]                  # 0043c15c
    test edx, edx                                # 0043c162
    je.d8 L_0043c173                             # 0043c164
    # block 0x0043c166: entered by fall-through of je at 0x0043c164, 2 instruction(s), ends with jne to 0x0043c1f4 (forward)
    cmp dword ptr [0x5a4c20], 0x0                # 0043c166
    jne.d32 L_0043c1f4                           # 0043c16d
L_0043c173:
    # block 0x0043c173: entered by jne at 0x0043c158; je at 0x0043c164; fall-through of jne at 0x0043c16d, 4 instruction(s), ends with jne to 0x0043c1f4 (forward)
    {load} xor eax, eax                          # 0043c173
    mov al, byte ptr [0x583215]                  # 0043c175
    test eax, eax                                # 0043c17a
    jne.d8 L_0043c1f4                            # 0043c17c
    # block 0x0043c17e: entered by fall-through of jne at 0x0043c17c, 4 instruction(s), ends with jne to 0x0043c1f4 (forward)
    {load} xor ecx, ecx                          # 0043c17e
    mov cl, byte ptr [0x583216]                  # 0043c180
    test ecx, ecx                                # 0043c186
    jne.d8 L_0043c1f4                            # 0043c188
    # block 0x0043c18a: entered by fall-through of jne at 0x0043c188, 4 instruction(s), ends with jne to 0x0043c1f4 (forward)
    {load} xor edx, edx                          # 0043c18a
    mov dl, byte ptr [0x583213]                  # 0043c18c
    test edx, edx                                # 0043c192
    jne.d8 L_0043c1f4                            # 0043c194
    # block 0x0043c196: entered by fall-through of jne at 0x0043c194, 4 instruction(s), ends with jne to 0x0043c1f4 (forward)
    {load} xor eax, eax                          # 0043c196
    mov al, byte ptr [0x583214]                  # 0043c198
    test eax, eax                                # 0043c19d
    jne.d8 L_0043c1f4                            # 0043c19f
    # block 0x0043c1a1: entered by fall-through of jne at 0x0043c19f, 4 instruction(s), ends with je to 0x0043c1b6 (forward)
    {load} xor ecx, ecx                          # 0043c1a1
    mov cl, byte ptr [0x583227]                  # 0043c1a3
    test ecx, ecx                                # 0043c1a9
    je.d8 L_0043c1b6                             # 0043c1ab
    # block 0x0043c1ad: entered by fall-through of je at 0x0043c1ab, 2 instruction(s), ends with jne to 0x0043c1f4 (forward)
    cmp dword ptr [0x5a4c20], 0x0                # 0043c1ad
    jne.d8 L_0043c1f4                            # 0043c1b4
L_0043c1b6:
    # block 0x0043c1b6: entered by je at 0x0043c1ab; fall-through of jne at 0x0043c1b4, 4 instruction(s), ends with je to 0x0043c1cb (forward)
    {load} xor edx, edx                          # 0043c1b6
    mov dl, byte ptr [0x583228]                  # 0043c1b8
    test edx, edx                                # 0043c1be
    je.d8 L_0043c1cb                             # 0043c1c0
    # block 0x0043c1c2: entered by fall-through of je at 0x0043c1c0, 2 instruction(s), ends with jne to 0x0043c1f4 (forward)
    cmp dword ptr [0x5a4c20], 0x0                # 0043c1c2
    jne.d8 L_0043c1f4                            # 0043c1c9
L_0043c1cb:
    # block 0x0043c1cb: entered by je at 0x0043c1c0; fall-through of jne at 0x0043c1c9, 4 instruction(s), ends with je to 0x0043c1df (forward)
    {load} xor eax, eax                          # 0043c1cb
    mov al, byte ptr [0x583225]                  # 0043c1cd
    test eax, eax                                # 0043c1d2
    je.d8 L_0043c1df                             # 0043c1d4
    # block 0x0043c1d6: entered by fall-through of je at 0x0043c1d4, 2 instruction(s), ends with jne to 0x0043c1f4 (forward)
    cmp dword ptr [0x5a4c20], 0x0                # 0043c1d6
    jne.d8 L_0043c1f4                            # 0043c1dd
L_0043c1df:
    # block 0x0043c1df: entered by je at 0x0043c1d4; fall-through of jne at 0x0043c1dd, 4 instruction(s), ends with je to 0x0043c216 (forward)
    {load} xor ecx, ecx                          # 0043c1df
    mov cl, byte ptr [0x583226]                  # 0043c1e1
    test ecx, ecx                                # 0043c1e7
    je.d8 L_0043c216                             # 0043c1e9
    # block 0x0043c1eb: entered by fall-through of je at 0x0043c1e9, 2 instruction(s), ends with je to 0x0043c216 (forward)
    cmp dword ptr [0x5a4c20], 0x0                # 0043c1eb
    je.d8 L_0043c216                             # 0043c1f2
L_0043c1f4:
    # block 0x0043c1f4: entered by je at 0x0043c148; jne at 0x0043c16d; jne at 0x0043c17c; jne at 0x0043c188; more, 2 instruction(s), ends with je to 0x0043c216 (forward)
    cmp dword ptr [0x5a4c18], 0x0                # 0043c1f4
    je.d8 L_0043c216                             # 0043c1fb
    # block 0x0043c1fd: entered by fall-through of je at 0x0043c1fb, 3 instruction(s), ends with jbe to 0x0043c216 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0043c1fd
    cmp edx, dword ptr [0x63a5c8]                # 0043c200
    jbe.d8 L_0043c216                            # 0043c206
    # block 0x0043c208: entered by fall-through of jbe at 0x0043c206, 4 instruction(s), calls FUN_00493a47, ends with je to 0x0043c251 (forward)
    mov ecx, 0x630a9a                            # 0043c208
    call FUN_00493a47                            # 0043c20d
    test eax, eax                                # 0043c212
    je.d8 L_0043c251                             # 0043c214
L_0043c216:
    # block 0x0043c216: entered by je at 0x0043c1e9; je at 0x0043c1f2; je at 0x0043c1fb; jbe at 0x0043c206; more, 3 instruction(s), ends with je to 0x0043c946 (forward)
    movsx eax, word ptr [0x5bb2ce]               # 0043c216
    cmp eax, 0x14d                               # 0043c21d
    je.d32 L_0043c946                            # 0043c222
    # block 0x0043c228: entered by fall-through of je at 0x0043c222, 2 instruction(s), ends with je to 0x0043c946 (forward)
    cmp dword ptr [0x5bb206], 0x0                # 0043c228
    je.d32 L_0043c946                            # 0043c22f
    # block 0x0043c235: entered by fall-through of je at 0x0043c22f, 3 instruction(s), ends with jbe to 0x0043c946 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0043c235
    cmp ecx, dword ptr [0x63a5c8]                # 0043c238
    jbe.d32 L_0043c946                           # 0043c23e
    # block 0x0043c244: entered by fall-through of jbe at 0x0043c23e, 2 instruction(s), ends with je to 0x0043c946 (forward)
    cmp dword ptr [0x5a4c18], 0x0                # 0043c244
    je.d32 L_0043c946                            # 0043c24b
L_0043c251:
    # block 0x0043c251: entered by je at 0x0043c214; fall-through of je at 0x0043c24b, 7 instruction(s), ends with ja to 0x0043c282 (forward)
    mov edx, dword ptr [0x583204]                # 0043c251
    mov dword ptr [ebp - local_e0], edx          # 0043c257
    mov eax, dword ptr [ebp - local_e0]          # 0043c25d
    sub eax, 0x2                                 # 0043c263
    mov dword ptr [ebp - local_e0], eax          # 0043c266
    cmp dword ptr [ebp - local_e0], 0x3          # 0043c26c
    ja.d8 L_0043c282                             # 0043c273
    # block 0x0043c275: entered by fall-through of ja at 0x0043c273, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x43d1e3]
    mov ecx, dword ptr [ebp - local_e0]          # 0043c275
    jmp dword ptr [4*ecx + SWTAB_0043d1e3_VA]    # 0043c27b
L_0043c282:
    # block 0x0043c282: entered by ja at 0x0043c273, 7 instruction(s), ends with ja to 0x0043c88d (forward)
    mov edx, dword ptr [0x5a4c18]                # 0043c282
    mov dword ptr [ebp - local_e4], edx          # 0043c288
    mov eax, dword ptr [ebp - local_e4]          # 0043c28e
    sub eax, 0x1                                 # 0043c294
    mov dword ptr [ebp - local_e4], eax          # 0043c297
    cmp dword ptr [ebp - local_e4], 0x7          # 0043c29d
    ja.d32 L_0043c88d                            # 0043c2a4
    # block 0x0043c2aa: entered by fall-through of ja at 0x0043c2a4, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x43d1f3]
    mov ecx, dword ptr [ebp - local_e4]          # 0043c2aa
    jmp dword ptr [4*ecx + SWTAB_0043d1f3_VA]    # 0043c2b0
L_0043c2b7:
    # block 0x0043c2b7: entered by switch case, 7 instruction(s), ends with jle to 0x0043c32d (forward)
    mov dx, word ptr [0x5bb50b]                  # 0043c2b7
    add dx, word ptr [0x5bb2c6]                  # 0043c2be
    mov word ptr [0x5bb50b], dx                  # 0043c2c5
    movsx eax, word ptr [0x5bb50b]               # 0043c2cc
    movsx ecx, word ptr [0x5bb4e5]               # 0043c2d3
    {load} cmp eax, ecx                          # 0043c2da
    jle.d8 L_0043c32d                            # 0043c2dc
    # block 0x0043c2de: entered by fall-through of jle at 0x0043c2dc, 3 instruction(s), ends with jne to 0x0043c2f8 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c2de
    cmp edx, 0x1                                 # 0043c2e5
    jne.d8 L_0043c2f8                            # 0043c2e8
    # block 0x0043c2ea: entered by fall-through of jne at 0x0043c2e8, 3 instruction(s), ends with forward jump to 0x0043c32d
    mov ax, word ptr [0x5bb4e3]                  # 0043c2ea
    mov word ptr [0x5bb50b], ax                  # 0043c2f0
    jmp.d8 L_0043c32d                            # 0043c2f6
L_0043c2f8:
    # block 0x0043c2f8: entered by jne at 0x0043c2e8, 3 instruction(s), ends with jne to 0x0043c314 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c2f8
    cmp ecx, 0x2                                 # 0043c2ff
    jne.d8 L_0043c314                            # 0043c302
    # block 0x0043c304: entered by fall-through of jne at 0x0043c302, 3 instruction(s), ends with forward jump to 0x0043c32d
    mov dx, word ptr [0x5bb4e5]                  # 0043c304
    mov word ptr [0x5bb50b], dx                  # 0043c30b
    jmp.d8 L_0043c32d                            # 0043c312
L_0043c314:
    # block 0x0043c314: entered by jne at 0x0043c302, 3 instruction(s), ends with jne to 0x0043c32d (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c314
    test eax, eax                                # 0043c31b
    jne.d8 L_0043c32d                            # 0043c31d
    # block 0x0043c31f: entered by fall-through of jne at 0x0043c31d, 2 instruction(s), falls into the block at 0x0043c32d
    mov cx, word ptr [0x5bb4e5]                  # 0043c31f
    mov word ptr [0x5bb50b], cx                  # 0043c326
L_0043c32d:
    # block 0x0043c32d: entered by jle at 0x0043c2dc; jmp at 0x0043c2f6; jmp at 0x0043c312; jne at 0x0043c31d, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c32d
L_0043c332:
    # block 0x0043c332: entered by switch case, 7 instruction(s), ends with jge to 0x0043c3a8 (forward)
    mov dx, word ptr [0x5bb50b]                  # 0043c332
    sub dx, word ptr [0x5bb2c6]                  # 0043c339
    mov word ptr [0x5bb50b], dx                  # 0043c340
    movsx eax, word ptr [0x5bb50b]               # 0043c347
    movsx ecx, word ptr [0x5bb4e3]               # 0043c34e
    {load} cmp eax, ecx                          # 0043c355
    jge.d8 L_0043c3a8                            # 0043c357
    # block 0x0043c359: entered by fall-through of jge at 0x0043c357, 3 instruction(s), ends with jne to 0x0043c373 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c359
    cmp edx, 0x1                                 # 0043c360
    jne.d8 L_0043c373                            # 0043c363
    # block 0x0043c365: entered by fall-through of jne at 0x0043c363, 3 instruction(s), ends with forward jump to 0x0043c3a8
    mov ax, word ptr [0x5bb4e5]                  # 0043c365
    mov word ptr [0x5bb50b], ax                  # 0043c36b
    jmp.d8 L_0043c3a8                            # 0043c371
L_0043c373:
    # block 0x0043c373: entered by jne at 0x0043c363, 3 instruction(s), ends with jne to 0x0043c38f (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c373
    cmp ecx, 0x2                                 # 0043c37a
    jne.d8 L_0043c38f                            # 0043c37d
    # block 0x0043c37f: entered by fall-through of jne at 0x0043c37d, 3 instruction(s), ends with forward jump to 0x0043c3a8
    mov dx, word ptr [0x5bb4e3]                  # 0043c37f
    mov word ptr [0x5bb50b], dx                  # 0043c386
    jmp.d8 L_0043c3a8                            # 0043c38d
L_0043c38f:
    # block 0x0043c38f: entered by jne at 0x0043c37d, 3 instruction(s), ends with jne to 0x0043c3a8 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c38f
    test eax, eax                                # 0043c396
    jne.d8 L_0043c3a8                            # 0043c398
    # block 0x0043c39a: entered by fall-through of jne at 0x0043c398, 2 instruction(s), falls into the block at 0x0043c3a8
    mov cx, word ptr [0x5bb4e3]                  # 0043c39a
    mov word ptr [0x5bb50b], cx                  # 0043c3a1
L_0043c3a8:
    # block 0x0043c3a8: entered by jge at 0x0043c357; jmp at 0x0043c371; jmp at 0x0043c38d; jne at 0x0043c398, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c3a8
L_0043c3ad:
    # block 0x0043c3ad: entered by switch case, 3 instruction(s), ends with jne to 0x0043c3c2 (forward)
    mov dword ptr [ebp - local_14], 0x1          # 0043c3ad
    cmp dword ptr [0x5bb587], 0x0                # 0043c3b4
    jne.d8 L_0043c3c2                            # 0043c3bb
    # block 0x0043c3bd: entered by fall-through of jne at 0x0043c3bb, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c3bd
L_0043c3c2:
    # block 0x0043c3c2: entered by jne at 0x0043c3bb, 6 instruction(s), ends with jge to 0x0043c3fd (forward)
    movsx edx, word ptr [0x5c39fd]               # 0043c3c2
    mov eax, dword ptr [0x5bb587]                # 0043c3c9
    {load} sub eax, edx                          # 0043c3ce
    mov dword ptr [ebp - local_28], eax          # 0043c3d0
    cmp dword ptr [ebp - local_28], 0x0          # 0043c3d3
    jge.d8 L_0043c3fd                            # 0043c3d7
    # block 0x0043c3d9: entered by fall-through of jge at 0x0043c3d7, 7 instruction(s), ends with forward jump to 0x0043c425
    mov dword ptr [0x5bb587], 0x0                # 0043c3d9
    movsx ecx, word ptr [0x5c39fd]               # 0043c3e3
    mov edx, dword ptr [0x5bb58f]                # 0043c3ea
    {load} sub edx, ecx                          # 0043c3f0
    sub edx, dword ptr [ebp - local_28]          # 0043c3f2
    mov dword ptr [0x5bb58f], edx                # 0043c3f5
    jmp.d8 L_0043c425                            # 0043c3fb
L_0043c3fd:
    # block 0x0043c3fd: entered by jge at 0x0043c3d7, 8 instruction(s), falls into the block at 0x0043c425
    movsx eax, word ptr [0x5c39fd]               # 0043c3fd
    mov ecx, dword ptr [0x5bb587]                # 0043c404
    {load} sub ecx, eax                          # 0043c40a
    mov dword ptr [0x5bb587], ecx                # 0043c40c
    movsx edx, word ptr [0x5c39fd]               # 0043c412
    mov eax, dword ptr [0x5bb58f]                # 0043c419
    {load} sub eax, edx                          # 0043c41e
    mov dword ptr [0x5bb58f], eax                # 0043c420
L_0043c425:
    # block 0x0043c425: entered by jmp at 0x0043c3fb, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c425
L_0043c42a:
    # block 0x0043c42a: entered by switch case, 4 instruction(s), ends with jne to 0x0043c444 (forward)
    mov dword ptr [ebp - local_14], 0x1          # 0043c42a
    mov ecx, dword ptr [0x5bb58f]                # 0043c431
    cmp ecx, dword ptr [0x5bb4fd]                # 0043c437
    jne.d8 L_0043c444                            # 0043c43d
    # block 0x0043c43f: entered by fall-through of jne at 0x0043c43d, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c43f
L_0043c444:
    # block 0x0043c444: entered by jne at 0x0043c43d, 7 instruction(s), ends with jle to 0x0043c492 (forward)
    movsx edx, word ptr [0x5c39fd]               # 0043c444
    mov eax, dword ptr [0x5bb58f]                # 0043c44b
    {load} add eax, edx                          # 0043c450
    mov dword ptr [ebp - local_28], eax          # 0043c452
    mov ecx, dword ptr [ebp - local_28]          # 0043c455
    cmp ecx, dword ptr [0x5bb4fd]                # 0043c458
    jle.d8 L_0043c492                            # 0043c45e
    # block 0x0043c460: entered by fall-through of jle at 0x0043c45e, 11 instruction(s), ends with forward jump to 0x0043c4ba
    mov edx, dword ptr [ebp - local_28]          # 0043c460
    sub edx, dword ptr [0x5bb4fd]                # 0043c463
    mov dword ptr [ebp - local_28], edx          # 0043c469
    movsx eax, word ptr [0x5c39fd]               # 0043c46c
    mov ecx, dword ptr [0x5bb587]                # 0043c473
    {load} add ecx, eax                          # 0043c479
    sub ecx, dword ptr [ebp - local_28]          # 0043c47b
    mov dword ptr [0x5bb587], ecx                # 0043c47e
    mov edx, dword ptr [0x5bb4fd]                # 0043c484
    mov dword ptr [0x5bb58f], edx                # 0043c48a
    jmp.d8 L_0043c4ba                            # 0043c490
L_0043c492:
    # block 0x0043c492: entered by jle at 0x0043c45e, 8 instruction(s), falls into the block at 0x0043c4ba
    movsx eax, word ptr [0x5c39fd]               # 0043c492
    mov ecx, dword ptr [0x5bb587]                # 0043c499
    {load} add ecx, eax                          # 0043c49f
    mov dword ptr [0x5bb587], ecx                # 0043c4a1
    movsx edx, word ptr [0x5c39fd]               # 0043c4a7
    mov eax, dword ptr [0x5bb58f]                # 0043c4ae
    {load} add eax, edx                          # 0043c4b3
    mov dword ptr [0x5bb58f], eax                # 0043c4b5
L_0043c4ba:
    # block 0x0043c4ba: entered by jmp at 0x0043c490, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c4ba
L_0043c4bf:
    # block 0x0043c4bf: entered by switch case, 6 instruction(s), ends with jge to 0x0043c4fb (forward)
    movsx ecx, word ptr [0x5c39fd]               # 0043c4bf
    mov edx, dword ptr [0x5bb587]                # 0043c4c6
    {load} sub edx, ecx                          # 0043c4cc
    mov dword ptr [ebp - local_28], edx          # 0043c4ce
    cmp dword ptr [ebp - local_28], 0x0          # 0043c4d1
    jge.d8 L_0043c4fb                            # 0043c4d5
    # block 0x0043c4d7: entered by fall-through of jge at 0x0043c4d5, 7 instruction(s), ends with forward jump to 0x0043c523
    mov dword ptr [0x5bb587], 0x0                # 0043c4d7
    movsx eax, word ptr [0x5c39fd]               # 0043c4e1
    mov ecx, dword ptr [0x5bb58f]                # 0043c4e8
    {load} sub ecx, eax                          # 0043c4ee
    sub ecx, dword ptr [ebp - local_28]          # 0043c4f0
    mov dword ptr [0x5bb58f], ecx                # 0043c4f3
    jmp.d8 L_0043c523                            # 0043c4f9
L_0043c4fb:
    # block 0x0043c4fb: entered by jge at 0x0043c4d5, 8 instruction(s), falls into the block at 0x0043c523
    movsx edx, word ptr [0x5c39fd]               # 0043c4fb
    mov eax, dword ptr [0x5bb587]                # 0043c502
    {load} sub eax, edx                          # 0043c507
    mov dword ptr [0x5bb587], eax                # 0043c509
    movsx ecx, word ptr [0x5c39fd]               # 0043c50e
    mov edx, dword ptr [0x5bb58f]                # 0043c515
    {load} sub edx, ecx                          # 0043c51b
    mov dword ptr [0x5bb58f], edx                # 0043c51d
L_0043c523:
    # block 0x0043c523: entered by jmp at 0x0043c4f9, 7 instruction(s), ends with jle to 0x0043c5a5 (forward)
    mov ax, word ptr [0x5bb50b]                  # 0043c523
    add ax, word ptr [0x5bb2c6]                  # 0043c529
    mov word ptr [0x5bb50b], ax                  # 0043c530
    movsx ecx, word ptr [0x5bb50b]               # 0043c536
    movsx edx, word ptr [0x5bb4e5]               # 0043c53d
    {load} cmp ecx, edx                          # 0043c544
    jle.d8 L_0043c5a5                            # 0043c546
    # block 0x0043c548: entered by fall-through of jle at 0x0043c546, 3 instruction(s), ends with jne to 0x0043c564 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c548
    cmp eax, 0x1                                 # 0043c54f
    jne.d8 L_0043c564                            # 0043c552
    # block 0x0043c554: entered by fall-through of jne at 0x0043c552, 3 instruction(s), ends with forward jump to 0x0043c5a5
    mov cx, word ptr [0x5bb4e3]                  # 0043c554
    mov word ptr [0x5bb50b], cx                  # 0043c55b
    jmp.d8 L_0043c5a5                            # 0043c562
L_0043c564:
    # block 0x0043c564: entered by jne at 0x0043c552, 3 instruction(s), ends with jne to 0x0043c585 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c564
    cmp edx, 0x2                                 # 0043c56b
    jne.d8 L_0043c585                            # 0043c56e
    # block 0x0043c570: entered by fall-through of jne at 0x0043c56e, 4 instruction(s), ends with forward jump to 0x0043c5a5
    mov ax, word ptr [0x5bb4e5]                  # 0043c570
    mov word ptr [0x5bb50b], ax                  # 0043c576
    mov dword ptr [ebp - local_14], 0x1          # 0043c57c
    jmp.d8 L_0043c5a5                            # 0043c583
L_0043c585:
    # block 0x0043c585: entered by jne at 0x0043c56e, 3 instruction(s), ends with jne to 0x0043c5a5 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c585
    test ecx, ecx                                # 0043c58c
    jne.d8 L_0043c5a5                            # 0043c58e
    # block 0x0043c590: entered by fall-through of jne at 0x0043c58e, 3 instruction(s), falls into the block at 0x0043c5a5
    mov dx, word ptr [0x5bb4e5]                  # 0043c590
    mov word ptr [0x5bb50b], dx                  # 0043c597
    mov dword ptr [ebp - local_14], 0x1          # 0043c59e
L_0043c5a5:
    # block 0x0043c5a5: entered by jle at 0x0043c546; jmp at 0x0043c562; jmp at 0x0043c583; jne at 0x0043c58e, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c5a5
L_0043c5aa:
    # block 0x0043c5aa: entered by switch case, 6 instruction(s), ends with jge to 0x0043c5e4 (forward)
    movsx eax, word ptr [0x5c39fd]               # 0043c5aa
    mov ecx, dword ptr [0x5bb587]                # 0043c5b1
    {load} sub ecx, eax                          # 0043c5b7
    mov dword ptr [ebp - local_28], ecx          # 0043c5b9
    cmp dword ptr [ebp - local_28], 0x0          # 0043c5bc
    jge.d8 L_0043c5e4                            # 0043c5c0
    # block 0x0043c5c2: entered by fall-through of jge at 0x0043c5c0, 7 instruction(s), ends with forward jump to 0x0043c60e
    mov dword ptr [0x5bb587], 0x0                # 0043c5c2
    movsx edx, word ptr [0x5c39fd]               # 0043c5cc
    mov eax, dword ptr [0x5bb58f]                # 0043c5d3
    {load} sub eax, edx                          # 0043c5d8
    sub eax, dword ptr [ebp - local_28]          # 0043c5da
    mov dword ptr [0x5bb58f], eax                # 0043c5dd
    jmp.d8 L_0043c60e                            # 0043c5e2
L_0043c5e4:
    # block 0x0043c5e4: entered by jge at 0x0043c5c0, 8 instruction(s), falls into the block at 0x0043c60e
    movsx ecx, word ptr [0x5c39fd]               # 0043c5e4
    mov edx, dword ptr [0x5bb587]                # 0043c5eb
    {load} sub edx, ecx                          # 0043c5f1
    mov dword ptr [0x5bb587], edx                # 0043c5f3
    movsx eax, word ptr [0x5c39fd]               # 0043c5f9
    mov ecx, dword ptr [0x5bb58f]                # 0043c600
    {load} sub ecx, eax                          # 0043c606
    mov dword ptr [0x5bb58f], ecx                # 0043c608
L_0043c60e:
    # block 0x0043c60e: entered by jmp at 0x0043c5e2, 7 instruction(s), ends with jge to 0x0043c692 (forward)
    mov dx, word ptr [0x5bb50b]                  # 0043c60e
    sub dx, word ptr [0x5bb2c6]                  # 0043c615
    mov word ptr [0x5bb50b], dx                  # 0043c61c
    movsx eax, word ptr [0x5bb50b]               # 0043c623
    movsx ecx, word ptr [0x5bb4e3]               # 0043c62a
    {load} cmp eax, ecx                          # 0043c631
    jge.d8 L_0043c692                            # 0043c633
    # block 0x0043c635: entered by fall-through of jge at 0x0043c633, 3 instruction(s), ends with jne to 0x0043c64f (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c635
    cmp edx, 0x1                                 # 0043c63c
    jne.d8 L_0043c64f                            # 0043c63f
    # block 0x0043c641: entered by fall-through of jne at 0x0043c63f, 3 instruction(s), ends with forward jump to 0x0043c692
    mov ax, word ptr [0x5bb4e5]                  # 0043c641
    mov word ptr [0x5bb50b], ax                  # 0043c647
    jmp.d8 L_0043c692                            # 0043c64d
L_0043c64f:
    # block 0x0043c64f: entered by jne at 0x0043c63f, 3 instruction(s), ends with jne to 0x0043c672 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c64f
    cmp ecx, 0x2                                 # 0043c656
    jne.d8 L_0043c672                            # 0043c659
    # block 0x0043c65b: entered by fall-through of jne at 0x0043c659, 4 instruction(s), ends with forward jump to 0x0043c692
    mov dx, word ptr [0x5bb4e3]                  # 0043c65b
    mov word ptr [0x5bb50b], dx                  # 0043c662
    mov dword ptr [ebp - local_14], 0x1          # 0043c669
    jmp.d8 L_0043c692                            # 0043c670
L_0043c672:
    # block 0x0043c672: entered by jne at 0x0043c659, 3 instruction(s), ends with jne to 0x0043c692 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c672
    test eax, eax                                # 0043c679
    jne.d8 L_0043c692                            # 0043c67b
    # block 0x0043c67d: entered by fall-through of jne at 0x0043c67b, 3 instruction(s), falls into the block at 0x0043c692
    mov cx, word ptr [0x5bb4e3]                  # 0043c67d
    mov word ptr [0x5bb50b], cx                  # 0043c684
    mov dword ptr [ebp - local_14], 0x1          # 0043c68b
L_0043c692:
    # block 0x0043c692: entered by jge at 0x0043c633; jmp at 0x0043c64d; jmp at 0x0043c670; jne at 0x0043c67b, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c692
L_0043c697:
    # block 0x0043c697: entered by switch case, 7 instruction(s), ends with jle to 0x0043c6e5 (forward)
    movsx edx, word ptr [0x5c39fd]               # 0043c697
    mov eax, dword ptr [0x5bb58f]                # 0043c69e
    {load} add eax, edx                          # 0043c6a3
    mov dword ptr [ebp - local_28], eax          # 0043c6a5
    mov ecx, dword ptr [ebp - local_28]          # 0043c6a8
    cmp ecx, dword ptr [0x5bb4fd]                # 0043c6ab
    jle.d8 L_0043c6e5                            # 0043c6b1
    # block 0x0043c6b3: entered by fall-through of jle at 0x0043c6b1, 11 instruction(s), ends with forward jump to 0x0043c70d
    mov edx, dword ptr [ebp - local_28]          # 0043c6b3
    sub edx, dword ptr [0x5bb4fd]                # 0043c6b6
    mov dword ptr [ebp - local_28], edx          # 0043c6bc
    movsx eax, word ptr [0x5c39fd]               # 0043c6bf
    mov ecx, dword ptr [0x5bb587]                # 0043c6c6
    {load} add ecx, eax                          # 0043c6cc
    sub ecx, dword ptr [ebp - local_28]          # 0043c6ce
    mov dword ptr [0x5bb587], ecx                # 0043c6d1
    mov edx, dword ptr [0x5bb4fd]                # 0043c6d7
    mov dword ptr [0x5bb58f], edx                # 0043c6dd
    jmp.d8 L_0043c70d                            # 0043c6e3
L_0043c6e5:
    # block 0x0043c6e5: entered by jle at 0x0043c6b1, 8 instruction(s), falls into the block at 0x0043c70d
    movsx eax, word ptr [0x5c39fd]               # 0043c6e5
    mov ecx, dword ptr [0x5bb587]                # 0043c6ec
    {load} add ecx, eax                          # 0043c6f2
    mov dword ptr [0x5bb587], ecx                # 0043c6f4
    movsx edx, word ptr [0x5c39fd]               # 0043c6fa
    mov eax, dword ptr [0x5bb58f]                # 0043c701
    {load} add eax, edx                          # 0043c706
    mov dword ptr [0x5bb58f], eax                # 0043c708
L_0043c70d:
    # block 0x0043c70d: entered by jmp at 0x0043c6e3, 7 instruction(s), ends with jle to 0x0043c791 (forward)
    mov cx, word ptr [0x5bb50b]                  # 0043c70d
    add cx, word ptr [0x5bb2c6]                  # 0043c714
    mov word ptr [0x5bb50b], cx                  # 0043c71b
    movsx edx, word ptr [0x5bb50b]               # 0043c722
    movsx eax, word ptr [0x5bb4e5]               # 0043c729
    {load} cmp edx, eax                          # 0043c730
    jle.d8 L_0043c791                            # 0043c732
    # block 0x0043c734: entered by fall-through of jle at 0x0043c732, 3 instruction(s), ends with jne to 0x0043c750 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c734
    cmp ecx, 0x1                                 # 0043c73b
    jne.d8 L_0043c750                            # 0043c73e
    # block 0x0043c740: entered by fall-through of jne at 0x0043c73e, 3 instruction(s), ends with forward jump to 0x0043c791
    mov dx, word ptr [0x5bb4e3]                  # 0043c740
    mov word ptr [0x5bb50b], dx                  # 0043c747
    jmp.d8 L_0043c791                            # 0043c74e
L_0043c750:
    # block 0x0043c750: entered by jne at 0x0043c73e, 3 instruction(s), ends with jne to 0x0043c773 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c750
    cmp eax, 0x2                                 # 0043c757
    jne.d8 L_0043c773                            # 0043c75a
    # block 0x0043c75c: entered by fall-through of jne at 0x0043c75a, 4 instruction(s), ends with forward jump to 0x0043c791
    mov cx, word ptr [0x5bb4e5]                  # 0043c75c
    mov word ptr [0x5bb50b], cx                  # 0043c763
    mov dword ptr [ebp - local_14], 0x1          # 0043c76a
    jmp.d8 L_0043c791                            # 0043c771
L_0043c773:
    # block 0x0043c773: entered by jne at 0x0043c75a, 3 instruction(s), ends with jne to 0x0043c791 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c773
    test edx, edx                                # 0043c77a
    jne.d8 L_0043c791                            # 0043c77c
    # block 0x0043c77e: entered by fall-through of jne at 0x0043c77c, 3 instruction(s), falls into the block at 0x0043c791
    mov ax, word ptr [0x5bb4e5]                  # 0043c77e
    mov word ptr [0x5bb50b], ax                  # 0043c784
    mov dword ptr [ebp - local_14], 0x1          # 0043c78a
L_0043c791:
    # block 0x0043c791: entered by jle at 0x0043c732; jmp at 0x0043c74e; jmp at 0x0043c771; jne at 0x0043c77c, 1 instruction(s), ends with forward jump to 0x0043c88d
    jmp.d32 L_0043c88d                           # 0043c791
L_0043c796:
    # block 0x0043c796: entered by switch case, 7 instruction(s), ends with jle to 0x0043c7e3 (forward)
    movsx ecx, word ptr [0x5c39fd]               # 0043c796
    mov edx, dword ptr [0x5bb58f]                # 0043c79d
    {load} add edx, ecx                          # 0043c7a3
    mov dword ptr [ebp - local_28], edx          # 0043c7a5
    mov eax, dword ptr [ebp - local_28]          # 0043c7a8
    cmp eax, dword ptr [0x5bb4fd]                # 0043c7ab
    jle.d8 L_0043c7e3                            # 0043c7b1
    # block 0x0043c7b3: entered by fall-through of jle at 0x0043c7b1, 11 instruction(s), ends with forward jump to 0x0043c80b
    mov ecx, dword ptr [ebp - local_28]          # 0043c7b3
    sub ecx, dword ptr [0x5bb4fd]                # 0043c7b6
    mov dword ptr [ebp - local_28], ecx          # 0043c7bc
    movsx edx, word ptr [0x5c39fd]               # 0043c7bf
    mov eax, dword ptr [0x5bb587]                # 0043c7c6
    {load} add eax, edx                          # 0043c7cb
    sub eax, dword ptr [ebp - local_28]          # 0043c7cd
    mov dword ptr [0x5bb587], eax                # 0043c7d0
    mov ecx, dword ptr [0x5bb4fd]                # 0043c7d5
    mov dword ptr [0x5bb58f], ecx                # 0043c7db
    jmp.d8 L_0043c80b                            # 0043c7e1
L_0043c7e3:
    # block 0x0043c7e3: entered by jle at 0x0043c7b1, 8 instruction(s), falls into the block at 0x0043c80b
    movsx edx, word ptr [0x5c39fd]               # 0043c7e3
    mov eax, dword ptr [0x5bb587]                # 0043c7ea
    {load} add eax, edx                          # 0043c7ef
    mov dword ptr [0x5bb587], eax                # 0043c7f1
    movsx ecx, word ptr [0x5c39fd]               # 0043c7f6
    mov edx, dword ptr [0x5bb58f]                # 0043c7fd
    {load} add edx, ecx                          # 0043c803
    mov dword ptr [0x5bb58f], edx                # 0043c805
L_0043c80b:
    # block 0x0043c80b: entered by jmp at 0x0043c7e1, 7 instruction(s), ends with jge to 0x0043c88d (forward)
    mov ax, word ptr [0x5bb50b]                  # 0043c80b
    sub ax, word ptr [0x5bb2c6]                  # 0043c811
    mov word ptr [0x5bb50b], ax                  # 0043c818
    movsx ecx, word ptr [0x5bb50b]               # 0043c81e
    movsx edx, word ptr [0x5bb4e3]               # 0043c825
    {load} cmp ecx, edx                          # 0043c82c
    jge.d8 L_0043c88d                            # 0043c82e
    # block 0x0043c830: entered by fall-through of jge at 0x0043c82e, 3 instruction(s), ends with jne to 0x0043c84c (forward)
    movsx eax, word ptr [0x5bb2b6]               # 0043c830
    cmp eax, 0x1                                 # 0043c837
    jne.d8 L_0043c84c                            # 0043c83a
    # block 0x0043c83c: entered by fall-through of jne at 0x0043c83a, 3 instruction(s), ends with forward jump to 0x0043c88d
    mov cx, word ptr [0x5bb4e5]                  # 0043c83c
    mov word ptr [0x5bb50b], cx                  # 0043c843
    jmp.d8 L_0043c88d                            # 0043c84a
L_0043c84c:
    # block 0x0043c84c: entered by jne at 0x0043c83a, 3 instruction(s), ends with jne to 0x0043c86d (forward)
    movsx edx, word ptr [0x5bb2b6]               # 0043c84c
    cmp edx, 0x2                                 # 0043c853
    jne.d8 L_0043c86d                            # 0043c856
    # block 0x0043c858: entered by fall-through of jne at 0x0043c856, 4 instruction(s), ends with forward jump to 0x0043c88d
    mov ax, word ptr [0x5bb4e3]                  # 0043c858
    mov word ptr [0x5bb50b], ax                  # 0043c85e
    mov dword ptr [ebp - local_14], 0x1          # 0043c864
    jmp.d8 L_0043c88d                            # 0043c86b
L_0043c86d:
    # block 0x0043c86d: entered by jne at 0x0043c856, 3 instruction(s), ends with jne to 0x0043c88d (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 0043c86d
    test ecx, ecx                                # 0043c874
    jne.d8 L_0043c88d                            # 0043c876
    # block 0x0043c878: entered by fall-through of jne at 0x0043c876, 3 instruction(s), falls into the block at 0x0043c88d
    mov dx, word ptr [0x5bb4e3]                  # 0043c878
    mov word ptr [0x5bb50b], dx                  # 0043c87f
    mov dword ptr [ebp - local_14], 0x1          # 0043c886
L_0043c88d:
    # block 0x0043c88d: entered by ja at 0x0043c2a4; jmp at 0x0043c32d; jmp at 0x0043c3a8; jmp at 0x0043c3bd; more, 4 instruction(s), ends with jne to 0x0043c8c7 (forward)
    {load} xor eax, eax                          # 0043c88d
    mov al, byte ptr [0x58321d]                  # 0043c88f
    test eax, eax                                # 0043c894
    jne.d8 L_0043c8c7                            # 0043c896
    # block 0x0043c898: entered by fall-through of jne at 0x0043c896, 4 instruction(s), ends with jne to 0x0043c8c7 (forward)
    {load} xor ecx, ecx                          # 0043c898
    mov cl, byte ptr [0x583215]                  # 0043c89a
    test ecx, ecx                                # 0043c8a0
    jne.d8 L_0043c8c7                            # 0043c8a2
    # block 0x0043c8a4: entered by fall-through of jne at 0x0043c8a2, 4 instruction(s), ends with jne to 0x0043c8c7 (forward)
    {load} xor edx, edx                          # 0043c8a4
    mov dl, byte ptr [0x583216]                  # 0043c8a6
    test edx, edx                                # 0043c8ac
    jne.d8 L_0043c8c7                            # 0043c8ae
    # block 0x0043c8b0: entered by fall-through of jne at 0x0043c8ae, 4 instruction(s), ends with jne to 0x0043c8c7 (forward)
    {load} xor eax, eax                          # 0043c8b0
    mov al, byte ptr [0x583213]                  # 0043c8b2
    test eax, eax                                # 0043c8b7
    jne.d8 L_0043c8c7                            # 0043c8b9
    # block 0x0043c8bb: entered by fall-through of jne at 0x0043c8b9, 4 instruction(s), ends with je to 0x0043c8dd (forward)
    {load} xor ecx, ecx                          # 0043c8bb
    mov cl, byte ptr [0x583214]                  # 0043c8bd
    test ecx, ecx                                # 0043c8c3
    je.d8 L_0043c8dd                             # 0043c8c5
L_0043c8c7:
    # block 0x0043c8c7: entered by jne at 0x0043c896; jne at 0x0043c8a2; jne at 0x0043c8ae; jne at 0x0043c8b9; more, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0043c941
    call dword ptr [0x52a23c]                    # 0043c8c7
    movsx edx, word ptr [0x5bb2ce]               # 0043c8cd
    {load} add eax, edx                          # 0043c8d4
    mov dword ptr [0x63a5c8], eax                # 0043c8d6
    jmp.d8 L_0043c941                            # 0043c8db
L_0043c8dd:
    # block 0x0043c8dd: entered by je at 0x0043c8c5, 4 instruction(s), ends with jne to 0x0043c917 (forward)
    {load} xor eax, eax                          # 0043c8dd
    mov al, byte ptr [0x58321e]                  # 0043c8df
    test eax, eax                                # 0043c8e4
    jne.d8 L_0043c917                            # 0043c8e6
    # block 0x0043c8e8: entered by fall-through of jne at 0x0043c8e6, 4 instruction(s), ends with jne to 0x0043c917 (forward)
    {load} xor ecx, ecx                          # 0043c8e8
    mov cl, byte ptr [0x583227]                  # 0043c8ea
    test ecx, ecx                                # 0043c8f0
    jne.d8 L_0043c917                            # 0043c8f2
    # block 0x0043c8f4: entered by fall-through of jne at 0x0043c8f2, 4 instruction(s), ends with jne to 0x0043c917 (forward)
    {load} xor edx, edx                          # 0043c8f4
    mov dl, byte ptr [0x583228]                  # 0043c8f6
    test edx, edx                                # 0043c8fc
    jne.d8 L_0043c917                            # 0043c8fe
    # block 0x0043c900: entered by fall-through of jne at 0x0043c8fe, 4 instruction(s), ends with jne to 0x0043c917 (forward)
    {load} xor eax, eax                          # 0043c900
    mov al, byte ptr [0x583225]                  # 0043c902
    test eax, eax                                # 0043c907
    jne.d8 L_0043c917                            # 0043c909
    # block 0x0043c90b: entered by fall-through of jne at 0x0043c909, 4 instruction(s), ends with je to 0x0043c92d (forward)
    {load} xor ecx, ecx                          # 0043c90b
    mov cl, byte ptr [0x583226]                  # 0043c90d
    test ecx, ecx                                # 0043c913
    je.d8 L_0043c92d                             # 0043c915
L_0043c917:
    # block 0x0043c917: entered by jne at 0x0043c8e6; jne at 0x0043c8f2; jne at 0x0043c8fe; jne at 0x0043c909; more, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0043c941
    call dword ptr [0x52a23c]                    # 0043c917
    movsx edx, word ptr [0x5bb2d0]               # 0043c91d
    {load} add eax, edx                          # 0043c924
    mov dword ptr [0x63a5c8], eax                # 0043c926
    jmp.d8 L_0043c941                            # 0043c92b
L_0043c92d:
    # block 0x0043c92d: entered by je at 0x0043c915, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0043c941
    call dword ptr [0x52a23c]                    # 0043c92d
    movsx ecx, word ptr [0x5bb2ce]               # 0043c933
    {load} add eax, ecx                          # 0043c93a
    mov dword ptr [0x63a5c8], eax                # 0043c93c
L_0043c941:
    # block 0x0043c941: entered by jmp at 0x0043c8db; jmp at 0x0043c92b; switch case, 1 instruction(s), ends with forward jump to 0x0043cc61
    jmp.d32 L_0043cc61                           # 0043c941
L_0043c946:
    # block 0x0043c946: entered by je at 0x0043c222; je at 0x0043c22f; jbe at 0x0043c23e; je at 0x0043c24b, 4 instruction(s), calls FUN_004f52a9, ends with jne to 0x0043cbf3 (forward)
    mov ecx, 0x5cf1eb                            # 0043c946
    call FUN_004f52a9                            # 0043c94b
    cmp dword ptr [0x5bb571], 0x0                # 0043c950
    jne.d32 L_0043cbf3                           # 0043c957
    # block 0x0043c95d: entered by fall-through of jne at 0x0043c957, 3 instruction(s), ends with jne to 0x0043cbf3 (forward)
    mov edx, dword ptr [0x63a5b4]                # 0043c95d
    cmp edx, dword ptr [0x583106]                # 0043c963
    jne.d32 L_0043cbf3                           # 0043c969
    # block 0x0043c96f: entered by fall-through of jne at 0x0043c969, 3 instruction(s), ends with jne to 0x0043cbf3 (forward)
    mov eax, dword ptr [0x63a5b0]                # 0043c96f
    cmp eax, dword ptr [0x583102]                # 0043c974
    jne.d32 L_0043cbf3                           # 0043c97a
    # block 0x0043c980: entered by fall-through of jne at 0x0043c97a, 3 instruction(s), ends with jne to 0x0043cbf3 (forward)
    mov ecx, dword ptr [0x63a5bc]                # 0043c980
    cmp ecx, dword ptr [0x58310e]                # 0043c986
    jne.d32 L_0043cbf3                           # 0043c98c
    # block 0x0043c992: entered by fall-through of jne at 0x0043c98c, 3 instruction(s), ends with jne to 0x0043cbf3 (forward)
    mov edx, dword ptr [0x63a5b8]                # 0043c992
    cmp edx, dword ptr [0x58310a]                # 0043c998
    jne.d32 L_0043cbf3                           # 0043c99e
    # block 0x0043c9a4: entered by fall-through of jne at 0x0043c99e, 3 instruction(s), ends with jbe to 0x0043cbf3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0043c9a4
    cmp eax, dword ptr [0x5bb1e6]                # 0043c9a7
    jbe.d32 L_0043cbf3                           # 0043c9ad
    # block 0x0043c9b3: entered by fall-through of jbe at 0x0043c9ad, 7 instruction(s), ends with forward jump to 0x0043c9dd
    movsx ecx, word ptr [0x5b027c]               # 0043c9b3
    mov edx, dword ptr [ebp - local_4]           # 0043c9ba
    {load} add edx, ecx                          # 0043c9bd
    mov dword ptr [0x5bb1e6], edx                # 0043c9bf
    mov ax, word ptr [0x5bb4e3]                  # 0043c9c5
    mov word ptr [ebp - local_1c], ax            # 0043c9cb
    jmp.d8 L_0043c9dd                            # 0043c9cf
L_0043c9d1:
    # block 0x0043c9d1: entered by jmp at 0x0043cbec, 3 instruction(s), falls into the block at 0x0043c9dd
    mov cx, word ptr [ebp - local_1c]            # 0043c9d1
    add cx, 0x1                                  # 0043c9d5
    mov word ptr [ebp - local_1c], cx            # 0043c9d9
L_0043c9dd:
    # block 0x0043c9dd: entered by jmp at 0x0043c9cf, 4 instruction(s), ends with jg to 0x0043cbf1 (forward)
    movsx edx, word ptr [ebp - local_1c]         # 0043c9dd
    movsx eax, word ptr [0x5bb4e5]               # 0043c9e1
    {load} cmp edx, eax                          # 0043c9e8
    jg.d32 L_0043cbf1                            # 0043c9ea
    # block 0x0043c9f0: entered by fall-through of jg at 0x0043c9ea, 3 instruction(s), ends with jne to 0x0043cbec (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 0043c9f0
    cmp dword ptr [4*ecx + 0x5bb50d], 0x0        # 0043c9f4
    jne.d32 L_0043cbec                           # 0043c9fc
    # block 0x0043ca02: entered by fall-through of jne at 0x0043c9fc, 4 instruction(s), ends with je to 0x0043caa2 (forward)
    mov edx, dword ptr [0x5bb4df]                # 0043ca02
    mov dword ptr [ebp - local_e8], edx          # 0043ca08
    cmp dword ptr [ebp - local_e8], 0x1          # 0043ca0e
    je.d32 L_0043caa2                            # 0043ca15
    # block 0x0043ca1b: entered by fall-through of je at 0x0043ca15, 5 instruction(s), ends with jl to 0x0043ca6e (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0043ca1b
    sub eax, 0x1                                 # 0043ca1f
    movsx ecx, word ptr [0x5bb4e3]               # 0043ca22
    {load} cmp eax, ecx                          # 0043ca29
    jl.d8 L_0043ca6e                             # 0043ca2b
    # block 0x0043ca2d: entered by fall-through of jl at 0x0043ca2b, 17 instruction(s), calls FUN_00415176, ends with forward jump to 0x0043ca9d
    movsx edx, word ptr [ebp - local_1c]         # 0043ca2d
    sub edx, 0x1                                 # 0043ca31
    push edx                                     # 0043ca34
    movsx eax, word ptr [ebp - local_1c]         # 0043ca35
    mov ecx, dword ptr [4*eax + 0x5bb441]        # 0043ca39
    push ecx                                     # 0043ca40
    movsx edx, word ptr [ebp - local_1c]         # 0043ca41
    lea eax, [2*edx + 0x5bb4a9]                  # 0043ca45
    push eax                                     # 0043ca4c
    mov cx, word ptr [ebp - local_1c]            # 0043ca4d
    push ecx                                     # 0043ca51
    push 0x5bb2d3                                # 0043ca52
    mov ecx, 0x5e2dbe                            # 0043ca57
    call FUN_00415176                            # 0043ca5c
    movsx edx, word ptr [ebp - local_1c]         # 0043ca61
    mov dword ptr [4*edx + 0x5bb445], eax        # 0043ca65
    jmp.d8 L_0043ca9d                            # 0043ca6c
L_0043ca6e:
    # block 0x0043ca6e: entered by jl at 0x0043ca2b, 12 instruction(s), calls FUN_00415176, falls into the block at 0x0043ca9d
    push 0x0                                     # 0043ca6e
    push 0x0                                     # 0043ca70
    movsx eax, word ptr [ebp - local_1c]         # 0043ca72
    lea ecx, [2*eax + 0x5bb4a9]                  # 0043ca76
    push ecx                                     # 0043ca7d
    mov dx, word ptr [ebp - local_1c]            # 0043ca7e
    push edx                                     # 0043ca82
    push 0x5bb2d3                                # 0043ca83
    mov ecx, 0x5e2dbe                            # 0043ca88
    call FUN_00415176                            # 0043ca8d
    movsx ecx, word ptr [ebp - local_1c]         # 0043ca92
    mov dword ptr [4*ecx + 0x5bb445], eax        # 0043ca96
L_0043ca9d:
    # block 0x0043ca9d: entered by jmp at 0x0043ca6c, 1 instruction(s), ends with forward jump to 0x0043cb2e
    jmp.d32 L_0043cb2e                           # 0043ca9d
L_0043caa2:
    # block 0x0043caa2: entered by je at 0x0043ca15, 12 instruction(s), calls FUN_004bf1f0, ends with jne to 0x0043cb2e (forward)
    movsx edx, word ptr [ebp - local_1c]         # 0043caa2
    add edx, 0x1                                 # 0043caa6
    push edx                                     # 0043caa9
    mov eax, dword ptr [0x5bb4db]                # 0043caaa
    push eax                                     # 0043caaf
    mov ecx, 0x6201f9                            # 0043cab0
    call FUN_004bf1f0                            # 0043cab5
    movsx ecx, word ptr [ebp - local_1c]         # 0043caba
    mov dword ptr [4*ecx + 0x5bb445], eax        # 0043cabe
    movsx edx, word ptr [ebp - local_1c]         # 0043cac5
    cmp dword ptr [4*edx + 0x5bb445], 0x0        # 0043cac9
    jne.d8 L_0043cb2e                            # 0043cad1
    # block 0x0043cad3: entered by fall-through of jne at 0x0043cad1, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0043cb15 (forward)
    push 0x5bb320                                # 0043cad3
    movsx eax, word ptr [ebp - local_1c]         # 0043cad8
    push eax                                     # 0043cadc
    push 0x547290                                # 0043cadd
    push 0x63888b                                # 0043cae2
    call FUN_0050ca3e                            # 0043cae7
    add esp, 0x10                                # 0043caec
    push 0x0                                     # 0043caef
    push 0x0                                     # 0043caf1
    push 0x63888b                                # 0043caf3
    call FUN_0052139c                            # 0043caf8
    movsx ecx, word ptr [0x63a4cd]               # 0043cafd
    test ecx, ecx                                # 0043cb04
    je.d8 L_0043cb15                             # 0043cb06
    # block 0x0043cb08: entered by fall-through of je at 0x0043cb06, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043cb15
    push 0x63888b                                # 0043cb08
    call FUN_0044a2b7                            # 0043cb0d
    add esp, 0x4                                 # 0043cb12
L_0043cb15:
    # block 0x0043cb15: entered by je at 0x0043cb06, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x63a58a], 0x4                # 0043cb15
    mov ecx, 0x5cf659                            # 0043cb1f
    call FUN_004c97b4                            # 0043cb24
    jmp.d32 L_0043d1bd                           # 0043cb29
L_0043cb2e:
    # block 0x0043cb2e: entered by jmp at 0x0043ca9d; jne at 0x0043cad1, 6 instruction(s), ends with forward jump to 0x0043cb5f
    movsx edx, word ptr [ebp - local_1c]         # 0043cb2e
    mov dword ptr [4*edx + 0x5bb50d], 0x1        # 0043cb32
    mov dword ptr [0x5bb571], 0x1                # 0043cb3d
    mov ax, word ptr [0x5bb4e3]                  # 0043cb47
    mov word ptr [ebp - local_18], ax            # 0043cb4d
    jmp.d8 L_0043cb5f                            # 0043cb51
L_0043cb53:
    # block 0x0043cb53: entered by jmp at 0x0043cb88, 3 instruction(s), falls into the block at 0x0043cb5f
    mov cx, word ptr [ebp - local_18]            # 0043cb53
    add cx, 0x1                                  # 0043cb57
    mov word ptr [ebp - local_18], cx            # 0043cb5b
L_0043cb5f:
    # block 0x0043cb5f: entered by jmp at 0x0043cb51, 4 instruction(s), ends with jg to 0x0043cb8a (forward)
    movsx edx, word ptr [ebp - local_18]         # 0043cb5f
    movsx eax, word ptr [0x5bb4e5]               # 0043cb63
    {load} cmp edx, eax                          # 0043cb6a
    jg.d8 L_0043cb8a                             # 0043cb6c
    # block 0x0043cb6e: entered by fall-through of jg at 0x0043cb6c, 3 instruction(s), ends with jne to 0x0043cb88 (forward)
    movsx ecx, word ptr [ebp - local_18]         # 0043cb6e
    cmp dword ptr [4*ecx + 0x5bb50d], 0x0        # 0043cb72
    jne.d8 L_0043cb88                            # 0043cb7a
    # block 0x0043cb7c: entered by fall-through of jne at 0x0043cb7a, 2 instruction(s), ends with forward jump to 0x0043cb8a
    mov dword ptr [0x5bb571], 0x0                # 0043cb7c
    jmp.d8 L_0043cb8a                            # 0043cb86
L_0043cb88:
    # block 0x0043cb88: entered by jne at 0x0043cb7a, 1 instruction(s), ends with backward jump to 0x0043cb53
    jmp.d8 L_0043cb53                            # 0043cb88
L_0043cb8a:
    # block 0x0043cb8a: entered by jg at 0x0043cb6c; jmp at 0x0043cb86, 2 instruction(s), ends with je to 0x0043cbea (forward)
    cmp dword ptr [0x5bb571], 0x0                # 0043cb8a
    je.d8 L_0043cbea                             # 0043cb91
    # block 0x0043cb93: entered by fall-through of je at 0x0043cb91, 4 instruction(s), ends with je to 0x0043cbb9 (forward)
    mov edx, dword ptr [0x5bb4df]                # 0043cb93
    mov dword ptr [ebp - local_ec], edx          # 0043cb99
    cmp dword ptr [ebp - local_ec], 0x1          # 0043cb9f
    je.d8 L_0043cbb9                             # 0043cba6
    # block 0x0043cba8: entered by fall-through of je at 0x0043cba6, 4 instruction(s), calls FUN_00415011, ends with forward jump to 0x0043cbc8
    push 0x5bb2d3                                # 0043cba8
    mov ecx, 0x5e2dbe                            # 0043cbad
    call FUN_00415011                            # 0043cbb2
    jmp.d8 L_0043cbc8                            # 0043cbb7
L_0043cbb9:
    # block 0x0043cbb9: entered by je at 0x0043cba6, 3 instruction(s), calls FUN_004bedfa, falls into the block at 0x0043cbc8
    push 0x5bb4db                                # 0043cbb9
    mov ecx, 0x6201f9                            # 0043cbbe
    call FUN_004bedfa                            # 0043cbc3
L_0043cbc8:
    # block 0x0043cbc8: entered by jmp at 0x0043cbb7, 4 instruction(s), ends with je to 0x0043cbea (forward)
    mov dword ptr [0x5a4c20], 0x1                # 0043cbc8
    movsx eax, word ptr [0x63a4cd]               # 0043cbd2
    test eax, eax                                # 0043cbd9
    je.d8 L_0043cbea                             # 0043cbdb
    # block 0x0043cbdd: entered by fall-through of je at 0x0043cbdb, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043cbea
    push 0x5472d0                                # 0043cbdd
    call FUN_0044a2b7                            # 0043cbe2
    add esp, 0x4                                 # 0043cbe7
L_0043cbea:
    # block 0x0043cbea: entered by je at 0x0043cb91; je at 0x0043cbdb, 1 instruction(s), ends with forward jump to 0x0043cbf1
    jmp.d8 L_0043cbf1                            # 0043cbea
L_0043cbec:
    # block 0x0043cbec: entered by jne at 0x0043c9fc, 1 instruction(s), ends with backward jump to 0x0043c9d1
    jmp.d32 L_0043c9d1                           # 0043cbec
L_0043cbf1:
    # block 0x0043cbf1: entered by jg at 0x0043c9ea; jmp at 0x0043cbea, 1 instruction(s), ends with forward jump to 0x0043cc61
    jmp.d8 L_0043cc61                            # 0043cbf1
L_0043cbf3:
    # block 0x0043cbf3: entered by jne at 0x0043c957; jne at 0x0043c969; jne at 0x0043c97a; jne at 0x0043c98c; more, 2 instruction(s), ends with jne to 0x0043cc61 (forward)
    cmp dword ptr [0x5bb571], 0x0                # 0043cbf3
    jne.d8 L_0043cc61                            # 0043cbfa
    # block 0x0043cbfc: entered by fall-through of jne at 0x0043cbfa, 3 instruction(s), ends with jne to 0x0043cc33 (forward)
    mov ecx, dword ptr [0x63a5b4]                # 0043cbfc
    cmp ecx, dword ptr [0x583106]                # 0043cc02
    jne.d8 L_0043cc33                            # 0043cc08
    # block 0x0043cc0a: entered by fall-through of jne at 0x0043cc08, 3 instruction(s), ends with jne to 0x0043cc33 (forward)
    mov edx, dword ptr [0x63a5b0]                # 0043cc0a
    cmp edx, dword ptr [0x583102]                # 0043cc10
    jne.d8 L_0043cc33                            # 0043cc16
    # block 0x0043cc18: entered by fall-through of jne at 0x0043cc16, 3 instruction(s), ends with jne to 0x0043cc33 (forward)
    mov eax, dword ptr [0x63a5bc]                # 0043cc18
    cmp eax, dword ptr [0x58310e]                # 0043cc1d
    jne.d8 L_0043cc33                            # 0043cc23
    # block 0x0043cc25: entered by fall-through of jne at 0x0043cc23, 3 instruction(s), ends with je to 0x0043cc61 (forward)
    mov ecx, dword ptr [0x63a5b8]                # 0043cc25
    cmp ecx, dword ptr [0x58310a]                # 0043cc2b
    je.d8 L_0043cc61                             # 0043cc31
L_0043cc33:
    # block 0x0043cc33: entered by jne at 0x0043cc08; jne at 0x0043cc16; jne at 0x0043cc23; fall-through of je at 0x0043cc31, 8 instruction(s), falls into the block at 0x0043cc61
    mov edx, dword ptr [0x583106]                # 0043cc33
    mov dword ptr [0x63a5b4], edx                # 0043cc39
    mov eax, dword ptr [0x583102]                # 0043cc3f
    mov dword ptr [0x63a5b0], eax                # 0043cc44
    mov ecx, dword ptr [0x58310e]                # 0043cc49
    mov dword ptr [0x63a5bc], ecx                # 0043cc4f
    mov edx, dword ptr [0x58310a]                # 0043cc55
    mov dword ptr [0x63a5b8], edx                # 0043cc5b
L_0043cc61:
    # block 0x0043cc61: entered by jmp at 0x0043c0cc; jmp at 0x0043c12e; jmp at 0x0043c941; jmp at 0x0043cbf1; more, 2 instruction(s), ends with jne to 0x0043ce92 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0043cc61
    jne.d32 L_0043ce92                           # 0043cc65
    # block 0x0043cc6b: entered by fall-through of jne at 0x0043cc65, 3 instruction(s), ends with jne to 0x0043ce92 (forward)
    movsx eax, word ptr [0x5bb50b]               # 0043cc6b
    cmp dword ptr [4*eax + 0x5bb50d], 0x0        # 0043cc72
    jne.d32 L_0043ce92                           # 0043cc7a
    # block 0x0043cc80: entered by fall-through of jne at 0x0043cc7a, 4 instruction(s), ends with je to 0x0043cd3a (forward)
    mov ecx, dword ptr [0x5bb4df]                # 0043cc80
    mov dword ptr [ebp - local_f0], ecx          # 0043cc86
    cmp dword ptr [ebp - local_f0], 0x1          # 0043cc8c
    je.d32 L_0043cd3a                            # 0043cc93
    # block 0x0043cc99: entered by fall-through of je at 0x0043cc93, 5 instruction(s), ends with jl to 0x0043ccfd (forward)
    movsx edx, word ptr [0x5bb50b]               # 0043cc99
    sub edx, 0x1                                 # 0043cca0
    movsx eax, word ptr [0x5bb4e3]               # 0043cca3
    {load} cmp edx, eax                          # 0043ccaa
    jl.d8 L_0043ccfd                             # 0043ccac
    # block 0x0043ccae: entered by fall-through of jl at 0x0043ccac, 17 instruction(s), calls FUN_00415176, ends with forward jump to 0x0043cd35
    movsx ecx, word ptr [0x5bb50b]               # 0043ccae
    sub ecx, 0x1                                 # 0043ccb5
    push ecx                                     # 0043ccb8
    movsx edx, word ptr [0x5bb50b]               # 0043ccb9
    mov eax, dword ptr [4*edx + 0x5bb441]        # 0043ccc0
    push eax                                     # 0043ccc7
    movsx ecx, word ptr [0x5bb50b]               # 0043ccc8
    lea edx, [2*ecx + 0x5bb4a9]                  # 0043cccf
    push edx                                     # 0043ccd6
    mov ax, word ptr [0x5bb50b]                  # 0043ccd7
    push eax                                     # 0043ccdd
    push 0x5bb2d3                                # 0043ccde
    mov ecx, 0x5e2dbe                            # 0043cce3
    call FUN_00415176                            # 0043cce8
    movsx ecx, word ptr [0x5bb50b]               # 0043cced
    mov dword ptr [4*ecx + 0x5bb445], eax        # 0043ccf4
    jmp.d8 L_0043cd35                            # 0043ccfb
L_0043ccfd:
    # block 0x0043ccfd: entered by jl at 0x0043ccac, 12 instruction(s), calls FUN_00415176, falls into the block at 0x0043cd35
    push 0x0                                     # 0043ccfd
    push 0x0                                     # 0043ccff
    movsx edx, word ptr [0x5bb50b]               # 0043cd01
    lea eax, [2*edx + 0x5bb4a9]                  # 0043cd08
    push eax                                     # 0043cd0f
    mov cx, word ptr [0x5bb50b]                  # 0043cd10
    push ecx                                     # 0043cd17
    push 0x5bb2d3                                # 0043cd18
    mov ecx, 0x5e2dbe                            # 0043cd1d
    call FUN_00415176                            # 0043cd22
    movsx edx, word ptr [0x5bb50b]               # 0043cd27
    mov dword ptr [4*edx + 0x5bb445], eax        # 0043cd2e
L_0043cd35:
    # block 0x0043cd35: entered by jmp at 0x0043ccfb, 1 instruction(s), ends with forward jump to 0x0043cdd3
    jmp.d32 L_0043cdd3                           # 0043cd35
L_0043cd3a:
    # block 0x0043cd3a: entered by je at 0x0043cc93, 12 instruction(s), calls FUN_004bf1f0, ends with jne to 0x0043cdd3 (forward)
    movsx eax, word ptr [0x5bb50b]               # 0043cd3a
    add eax, 0x1                                 # 0043cd41
    push eax                                     # 0043cd44
    mov ecx, dword ptr [0x5bb4db]                # 0043cd45
    push ecx                                     # 0043cd4b
    mov ecx, 0x6201f9                            # 0043cd4c
    call FUN_004bf1f0                            # 0043cd51
    movsx edx, word ptr [0x5bb50b]               # 0043cd56
    mov dword ptr [4*edx + 0x5bb445], eax        # 0043cd5d
    movsx eax, word ptr [0x5bb50b]               # 0043cd64
    cmp dword ptr [4*eax + 0x5bb445], 0x0        # 0043cd6b
    jne.d8 L_0043cdd3                            # 0043cd73
    # block 0x0043cd75: entered by fall-through of jne at 0x0043cd73, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0043cdba (forward)
    push 0x5bb320                                # 0043cd75
    movsx ecx, word ptr [0x5bb50b]               # 0043cd7a
    push ecx                                     # 0043cd81
    push 0x547300                                # 0043cd82
    push 0x63888b                                # 0043cd87
    call FUN_0050ca3e                            # 0043cd8c
    add esp, 0x10                                # 0043cd91
    push 0x0                                     # 0043cd94
    push 0x0                                     # 0043cd96
    push 0x63888b                                # 0043cd98
    call FUN_0052139c                            # 0043cd9d
    movsx edx, word ptr [0x63a4cd]               # 0043cda2
    test edx, edx                                # 0043cda9
    je.d8 L_0043cdba                             # 0043cdab
    # block 0x0043cdad: entered by fall-through of je at 0x0043cdab, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043cdba
    push 0x63888b                                # 0043cdad
    call FUN_0044a2b7                            # 0043cdb2
    add esp, 0x4                                 # 0043cdb7
L_0043cdba:
    # block 0x0043cdba: entered by je at 0x0043cdab, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0043d1bd
    mov dword ptr [0x63a58a], 0x4                # 0043cdba
    mov ecx, 0x5cf659                            # 0043cdc4
    call FUN_004c97b4                            # 0043cdc9
    jmp.d32 L_0043d1bd                           # 0043cdce
L_0043cdd3:
    # block 0x0043cdd3: entered by jmp at 0x0043cd35; jne at 0x0043cd73, 6 instruction(s), ends with forward jump to 0x0043ce08
    movsx eax, word ptr [0x5bb50b]               # 0043cdd3
    mov dword ptr [4*eax + 0x5bb50d], 0x1        # 0043cdda
    mov dword ptr [0x5bb571], 0x1                # 0043cde5
    mov cx, word ptr [0x5bb4e3]                  # 0043cdef
    mov word ptr [ebp - local_18], cx            # 0043cdf6
    jmp.d8 L_0043ce08                            # 0043cdfa
L_0043cdfc:
    # block 0x0043cdfc: entered by jmp at 0x0043ce31, 3 instruction(s), falls into the block at 0x0043ce08
    mov dx, word ptr [ebp - local_18]            # 0043cdfc
    add dx, 0x1                                  # 0043ce00
    mov word ptr [ebp - local_18], dx            # 0043ce04
L_0043ce08:
    # block 0x0043ce08: entered by jmp at 0x0043cdfa, 4 instruction(s), ends with jg to 0x0043ce33 (forward)
    movsx eax, word ptr [ebp - local_18]         # 0043ce08
    movsx ecx, word ptr [0x5bb4e5]               # 0043ce0c
    {load} cmp eax, ecx                          # 0043ce13
    jg.d8 L_0043ce33                             # 0043ce15
    # block 0x0043ce17: entered by fall-through of jg at 0x0043ce15, 3 instruction(s), ends with jne to 0x0043ce31 (forward)
    movsx edx, word ptr [ebp - local_18]         # 0043ce17
    cmp dword ptr [4*edx + 0x5bb50d], 0x0        # 0043ce1b
    jne.d8 L_0043ce31                            # 0043ce23
    # block 0x0043ce25: entered by fall-through of jne at 0x0043ce23, 2 instruction(s), ends with forward jump to 0x0043ce33
    mov dword ptr [0x5bb571], 0x0                # 0043ce25
    jmp.d8 L_0043ce33                            # 0043ce2f
L_0043ce31:
    # block 0x0043ce31: entered by jne at 0x0043ce23, 1 instruction(s), ends with backward jump to 0x0043cdfc
    jmp.d8 L_0043cdfc                            # 0043ce31
L_0043ce33:
    # block 0x0043ce33: entered by jg at 0x0043ce15; jmp at 0x0043ce2f, 2 instruction(s), ends with je to 0x0043ce92 (forward)
    cmp dword ptr [0x5bb571], 0x0                # 0043ce33
    je.d8 L_0043ce92                             # 0043ce3a
    # block 0x0043ce3c: entered by fall-through of je at 0x0043ce3a, 4 instruction(s), ends with je to 0x0043ce61 (forward)
    mov eax, dword ptr [0x5bb4df]                # 0043ce3c
    mov dword ptr [ebp - local_f4], eax          # 0043ce41
    cmp dword ptr [ebp - local_f4], 0x1          # 0043ce47
    je.d8 L_0043ce61                             # 0043ce4e
    # block 0x0043ce50: entered by fall-through of je at 0x0043ce4e, 4 instruction(s), calls FUN_00415011, ends with forward jump to 0x0043ce70
    push 0x5bb2d3                                # 0043ce50
    mov ecx, 0x5e2dbe                            # 0043ce55
    call FUN_00415011                            # 0043ce5a
    jmp.d8 L_0043ce70                            # 0043ce5f
L_0043ce61:
    # block 0x0043ce61: entered by je at 0x0043ce4e, 3 instruction(s), calls FUN_004bedfa, falls into the block at 0x0043ce70
    push 0x5bb4db                                # 0043ce61
    mov ecx, 0x6201f9                            # 0043ce66
    call FUN_004bedfa                            # 0043ce6b
L_0043ce70:
    # block 0x0043ce70: entered by jmp at 0x0043ce5f, 4 instruction(s), ends with je to 0x0043ce92 (forward)
    mov dword ptr [0x5a4c20], 0x1                # 0043ce70
    movsx ecx, word ptr [0x63a4cd]               # 0043ce7a
    test ecx, ecx                                # 0043ce81
    je.d8 L_0043ce92                             # 0043ce83
    # block 0x0043ce85: entered by fall-through of je at 0x0043ce83, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043ce92
    push 0x547340                                # 0043ce85
    call FUN_0044a2b7                            # 0043ce8a
    add esp, 0x4                                 # 0043ce8f
L_0043ce92:
    # block 0x0043ce92: entered by jne at 0x0043cc65; jne at 0x0043cc7a; je at 0x0043ce3a; je at 0x0043ce83, 4 instruction(s), ends with jne to 0x0043ceaa (forward)
    movsx edx, word ptr [0x5bb509]               # 0043ce92
    movsx eax, word ptr [0x5bb50b]               # 0043ce99
    {load} cmp edx, eax                          # 0043cea0
    jne.d8 L_0043ceaa                            # 0043cea2
    # block 0x0043cea4: entered by fall-through of jne at 0x0043cea2, 2 instruction(s), ends with je to 0x0043cf17 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0043cea4
    je.d8 L_0043cf17                             # 0043cea8
L_0043ceaa:
    # block 0x0043ceaa: entered by jne at 0x0043cea2; fall-through of je at 0x0043cea8, 16 instruction(s), ends with je to 0x0043cf06 (forward)
    movsx ecx, word ptr [0x5bb50b]               # 0043ceaa
    movsx edx, word ptr [0x5bb4ed]               # 0043ceb1
    mov eax, dword ptr [0x5bb587]                # 0043ceb8
    imul eax, edx                                # 0043cebd
    mov ecx, dword ptr [4*ecx + 0x5bb445]        # 0043cec0
    {load} add ecx, eax                          # 0043cec7
    movsx edx, word ptr [0x639895]               # 0043cec9
    mov eax, dword ptr [0x5bb583]                # 0043ced0
    imul eax, edx                                # 0043ced5
    {load} add ecx, eax                          # 0043ced8
    mov edx, dword ptr [0x5d03bb]                # 0043ceda
    mov dword ptr [edx], ecx                     # 0043cee0
    movsx eax, word ptr [0x5bb509]               # 0043cee2
    movsx ecx, word ptr [0x5bb50b]               # 0043cee9
    {load} cmp eax, ecx                          # 0043cef0
    je.d8 L_0043cf06                             # 0043cef2
    # block 0x0043cef4: entered by fall-through of je at 0x0043cef2, 4 instruction(s), calls FUN_004f7c36, falls into the block at 0x0043cf06
    mov dx, word ptr [0x5bb50b]                  # 0043cef4
    push edx                                     # 0043cefb
    mov ecx, 0x5cf1eb                            # 0043cefc
    call FUN_004f7c36                            # 0043cf01
L_0043cf06:
    # block 0x0043cf06: entered by je at 0x0043cef2, 3 instruction(s), calls FUN_004d36ed, falls into the block at 0x0043cf17
    mov ax, word ptr [0x5bb50b]                  # 0043cf06
    mov word ptr [0x5bb509], ax                  # 0043cf0c
    call FUN_004d36ed                            # 0043cf12
L_0043cf17:
    # block 0x0043cf17: entered by je at 0x0043cea8, 11 instruction(s), calls FUN_00427a50, ends with ja to 0x0043cf97 (forward)
    mov cx, word ptr [0x5bb50b]                  # 0043cf17
    mov word ptr [0x5c3a51], cx                  # 0043cf1e
    mov dword ptr [0x5c3a47], 0x1                # 0043cf25
    call FUN_00427a50                            # 0043cf2f
    mov edx, dword ptr [0x583204]                # 0043cf34
    mov dword ptr [ebp - local_f8], edx          # 0043cf3a
    mov eax, dword ptr [ebp - local_f8]          # 0043cf40
    sub eax, 0x1                                 # 0043cf46
    mov dword ptr [ebp - local_f8], eax          # 0043cf49
    cmp dword ptr [ebp - local_f8], 0x4          # 0043cf4f
    ja.d8 L_0043cf97                             # 0043cf56
    # block 0x0043cf58: entered by fall-through of ja at 0x0043cf56, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x43d213]
    mov ecx, dword ptr [ebp - local_f8]          # 0043cf58
    jmp dword ptr [4*ecx + SWTAB_0043d213_VA]    # 0043cf5e
L_0043cf65:
    # block 0x0043cf65: entered by switch case, 1 instruction(s), ends with forward jump to 0x0043cfb7
    jmp.d8 L_0043cfb7                            # 0043cf65
L_0043cf67:
    # block 0x0043cf67: entered by switch case, 3 instruction(s), calls FUN_004e7970, ends with forward jump to 0x0043cfb7
    mov ecx, 0x582711                            # 0043cf67
    call FUN_004e7970                            # 0043cf6c
    jmp.d8 L_0043cfb7                            # 0043cf71
L_0043cf73:
    # block 0x0043cf73: entered by switch case, 3 instruction(s), calls FUN_004e94c1, ends with forward jump to 0x0043cfb7
    mov ecx, 0x571442                            # 0043cf73
    call FUN_004e94c1                            # 0043cf78
    jmp.d8 L_0043cfb7                            # 0043cf7d
L_0043cf7f:
    # block 0x0043cf7f: entered by switch case, 3 instruction(s), calls FUN_004ec9a2, ends with forward jump to 0x0043cfb7
    mov ecx, 0x57fd34                            # 0043cf7f
    call FUN_004ec9a2                            # 0043cf84
    jmp.d8 L_0043cfb7                            # 0043cf89
L_0043cf8b:
    # block 0x0043cf8b: entered by switch case, 3 instruction(s), calls FUN_004e4cb6, ends with forward jump to 0x0043cfb7
    mov ecx, 0x57975c                            # 0043cf8b
    call FUN_004e4cb6                            # 0043cf90
    jmp.d8 L_0043cfb7                            # 0043cf95
L_0043cf97:
    # block 0x0043cf97: entered by ja at 0x0043cf56, 6 instruction(s), calls FUN_004e0e2b, ends with je to 0x0043cfb7 (forward)
    mov ecx, 0x570508                            # 0043cf97
    call FUN_004e0e2b                            # 0043cf9c
    {load} xor edx, edx                          # 0043cfa1
    mov dl, byte ptr [0x5a161f]                  # 0043cfa3
    test edx, edx                                # 0043cfa9
    je.d8 L_0043cfb7                             # 0043cfab
    # block 0x0043cfad: entered by fall-through of je at 0x0043cfab, 2 instruction(s), calls FUN_004de4f9, falls into the block at 0x0043cfb7
    mov ecx, 0x61f864                            # 0043cfad
    call FUN_004de4f9                            # 0043cfb2
L_0043cfb7:
    # block 0x0043cfb7: entered by jmp at 0x0043cf65; jmp at 0x0043cf71; jmp at 0x0043cf7d; jmp at 0x0043cf89; more, 2 instruction(s), ends with je to 0x0043cfc9 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0043cfb7
    je.d8 L_0043cfc9                             # 0043cfbe
    # block 0x0043cfc0: entered by fall-through of je at 0x0043cfbe, 2 instruction(s), ends with je to 0x0043cfd3 (forward)
    cmp dword ptr [0x583999], 0x3                # 0043cfc0
    je.d8 L_0043cfd3                             # 0043cfc7
L_0043cfc9:
    # block 0x0043cfc9: entered by je at 0x0043cfbe; fall-through of je at 0x0043cfc7, 2 instruction(s), calls FUN_0043d6be, ends with forward jump to 0x0043d1bd
    call FUN_0043d6be                            # 0043cfc9
    jmp.d32 L_0043d1bd                           # 0043cfce
L_0043cfd3:
    # block 0x0043cfd3: entered by je at 0x0043cfc7, 2 instruction(s), ends with jne to 0x0043cff9 (forward)
    cmp dword ptr [0x5bb22a], 0x0                # 0043cfd3
    jne.d8 L_0043cff9                            # 0043cfda
    # block 0x0043cfdc: entered by fall-through of jne at 0x0043cfda, 2 instruction(s), ends with je to 0x0043cff9 (forward)
    cmp dword ptr [0x63a5c0], 0x0                # 0043cfdc
    je.d8 L_0043cff9                             # 0043cfe3
    # block 0x0043cfe5: entered by fall-through of je at 0x0043cfe3, 3 instruction(s), calls FUN_0043d6be, ends with forward jump to 0x0043d1bd
    call FUN_0043d6be                            # 0043cfe5
    mov dword ptr [0x583999], 0x4                # 0043cfea
    jmp.d32 L_0043d1bd                           # 0043cff4
L_0043cff9:
    # block 0x0043cff9: entered by jne at 0x0043cfda; je at 0x0043cfe3, 4 instruction(s), calls FUN_004ee5cd, ends with je to 0x0043d066 (forward)
    mov ecx, 0x57fd34                            # 0043cff9
    call FUN_004ee5cd                            # 0043cffe
    test eax, eax                                # 0043d003
    je.d8 L_0043d066                             # 0043d005
    # block 0x0043d007: entered by fall-through of je at 0x0043d005, 2 instruction(s), ends with je to 0x0043d066 (forward)
    cmp dword ptr [0x63a5c4], 0x0                # 0043d007
    je.d8 L_0043d066                             # 0043d00e
    # block 0x0043d010: entered by fall-through of je at 0x0043d00e, 3 instruction(s), ends with je to 0x0043d023 (forward)
    movsx eax, word ptr [0x5c3a31]               # 0043d010
    cmp eax, 0x270f                              # 0043d017
    je.d8 L_0043d023                             # 0043d01c
    # block 0x0043d01e: entered by fall-through of je at 0x0043d01c, 1 instruction(s), calls FUN_0042e5c6, falls into the block at 0x0043d023
    call FUN_0042e5c6                            # 0043d01e
L_0043d023:
    # block 0x0043d023: entered by je at 0x0043d01c, 3 instruction(s), ends with je to 0x0043d038 (forward)
    mov ecx, 0x1                                 # 0043d023
    test ecx, ecx                                # 0043d028
    je.d8 L_0043d038                             # 0043d02a
    # block 0x0043d02c: entered by fall-through of je at 0x0043d02a, 2 instruction(s), ends with forward jump to 0x0043d052
    mov dword ptr [ebp - local_fc], 0x0          # 0043d02c
    jmp.d8 L_0043d052                            # 0043d036
L_0043d038:
    # block 0x0043d038: entered by je at 0x0043d02a, 6 instruction(s), calls FUN_00427a40, falls into the block at 0x0043d052
    mov edx, dword ptr [0x5bb57b]                # 0043d038
    push edx                                     # 0043d03e
    push 0x547370                                # 0043d03f
    call FUN_00427a40                            # 0043d044
    add esp, 0x8                                 # 0043d049
    mov dword ptr [ebp - local_fc], eax          # 0043d04c
L_0043d052:
    # block 0x0043d052: entered by jmp at 0x0043d036, 3 instruction(s), calls FUN_0043d6be, ends with forward jump to 0x0043d1bd
    call FUN_0043d6be                            # 0043d052
    mov dword ptr [0x583999], 0x4                # 0043d057
    jmp.d32 L_0043d1bd                           # 0043d061
L_0043d066:
    # block 0x0043d066: entered by je at 0x0043d005; je at 0x0043d00e, 2 instruction(s), ends with je to 0x0043d0b4 (forward)
    cmp dword ptr [0x5831c8], 0x0                # 0043d066
    je.d8 L_0043d0b4                             # 0043d06d
    # block 0x0043d06f: entered by fall-through of je at 0x0043d06d, 6 instruction(s), ends with jg to 0x0043d097 (forward)
    mov ax, word ptr [0x5831c6]                  # 0043d06f
    .insn 0x66, 0x05, 0x0001{:u16}               # 0043d075
    mov word ptr [0x5831c6], ax                  # 0043d079
    movsx ecx, word ptr [0x5831c6]               # 0043d07f
    cmp ecx, 0x1                                 # 0043d086
    jg.d8 L_0043d097                             # 0043d089
    # block 0x0043d08b: entered by fall-through of jg at 0x0043d089, 2 instruction(s), ends with forward jump to 0x0043d0b4
    mov dword ptr [0x5d15ef], 0x1                # 0043d08b
    jmp.d8 L_0043d0b4                            # 0043d095
L_0043d097:
    # block 0x0043d097: entered by jg at 0x0043d089, 3 instruction(s), falls into the block at 0x0043d0b4
    mov dword ptr [0x5d15ef], 0x0                # 0043d097
    mov word ptr [0x5831c6], 0x0                 # 0043d0a1
    mov dword ptr [0x5831c8], 0x0                # 0043d0aa
L_0043d0b4:
    # block 0x0043d0b4: entered by je at 0x0043d06d; jmp at 0x0043d095, 2 instruction(s), ends with jne to 0x0043d0d2 (forward)
    cmp dword ptr [0x5b15c8], 0x0                # 0043d0b4
    jne.d8 L_0043d0d2                            # 0043d0bb
    # block 0x0043d0bd: entered by fall-through of jne at 0x0043d0bb, 2 instruction(s), ends with je to 0x0043d0d2 (forward)
    cmp dword ptr [0x5b15d6], 0x0                # 0043d0bd
    je.d8 L_0043d0d2                             # 0043d0c4
    # block 0x0043d0c6: entered by fall-through of je at 0x0043d0c4, 2 instruction(s), ends with forward jump to 0x0043d0dc
    mov dword ptr [0x5d17f5], 0x1                # 0043d0c6
    jmp.d8 L_0043d0dc                            # 0043d0d0
L_0043d0d2:
    # block 0x0043d0d2: entered by jne at 0x0043d0bb; je at 0x0043d0c4, 1 instruction(s), falls into the block at 0x0043d0dc
    mov dword ptr [0x5d17f5], 0x0                # 0043d0d2
L_0043d0dc:
    # block 0x0043d0dc: entered by jmp at 0x0043d0d0, 2 instruction(s), ends with je to 0x0043d0ea (forward)
    cmp dword ptr [0x5b15c8], 0x0                # 0043d0dc
    je.d8 L_0043d0ea                             # 0043d0e3
    # block 0x0043d0e5: entered by fall-through of je at 0x0043d0e3, 1 instruction(s), calls FUN_0042ad27, falls into the block at 0x0043d0ea
    call FUN_0042ad27                            # 0043d0e5
L_0043d0ea:
    # block 0x0043d0ea: entered by je at 0x0043d0e3, 2 instruction(s), ends with jne to 0x0043d108 (forward)
    cmp dword ptr [0x5b1602], 0x0                # 0043d0ea
    jne.d8 L_0043d108                            # 0043d0f1
    # block 0x0043d0f3: entered by fall-through of jne at 0x0043d0f1, 2 instruction(s), ends with je to 0x0043d108 (forward)
    cmp dword ptr [0x5b1606], 0x0                # 0043d0f3
    je.d8 L_0043d108                             # 0043d0fa
    # block 0x0043d0fc: entered by fall-through of je at 0x0043d0fa, 2 instruction(s), ends with forward jump to 0x0043d112
    mov dword ptr [0x5d1889], 0x1                # 0043d0fc
    jmp.d8 L_0043d112                            # 0043d106
L_0043d108:
    # block 0x0043d108: entered by jne at 0x0043d0f1; je at 0x0043d0fa, 1 instruction(s), falls into the block at 0x0043d112
    mov dword ptr [0x5d1889], 0x0                # 0043d108
L_0043d112:
    # block 0x0043d112: entered by jmp at 0x0043d106, 2 instruction(s), ends with je to 0x0043d120 (forward)
    cmp dword ptr [0x5b1602], 0x0                # 0043d112
    je.d8 L_0043d120                             # 0043d119
    # block 0x0043d11b: entered by fall-through of je at 0x0043d119, 1 instruction(s), calls FUN_0042ae0a, falls into the block at 0x0043d120
    call FUN_0042ae0a                            # 0043d11b
L_0043d120:
    # block 0x0043d120: entered by je at 0x0043d119, 6 instruction(s), calls FUN_004ea361, FUN_004f52a9, ends with jne to 0x0043d144 (forward)
    mov ecx, 0x571442                            # 0043d120
    call FUN_004ea361                            # 0043d125
    mov ecx, 0x5cf1eb                            # 0043d12a
    call FUN_004f52a9                            # 0043d12f
    cmp dword ptr [0x5839a9], 0x0                # 0043d134
    jne.d8 L_0043d144                            # 0043d13b
    # block 0x0043d13d: entered by fall-through of jne at 0x0043d13b, 2 instruction(s), calls FUN_004d3073, ends with forward jump to 0x0043d162
    call FUN_004d3073                            # 0043d13d
    jmp.d8 L_0043d162                            # 0043d142
L_0043d144:
    # block 0x0043d144: entered by jne at 0x0043d13b, 3 instruction(s), falls into the block at 0x0043d162
    mov dword ptr [0x5d1639], 0x0                # 0043d144
    mov dword ptr [0x5a4c18], 0x0                # 0043d14e
    mov dword ptr [0x5c39e5], 0xffffffff         # 0043d158
L_0043d162:
    # block 0x0043d162: entered by jmp at 0x0043d142, 4 instruction(s), ends with je to 0x0043d178 (forward)
    {load} xor edx, edx                          # 0043d162
    mov dl, byte ptr [0x583224]                  # 0043d164
    test edx, edx                                # 0043d16a
    je.d8 L_0043d178                             # 0043d16c
    # block 0x0043d16e: entered by fall-through of je at 0x0043d16c, 2 instruction(s), calls FUN_004c3c5d, falls into the block at 0x0043d178
    mov ecx, 0x5cf659                            # 0043d16e
    call FUN_004c3c5d                            # 0043d173
L_0043d178:
    # block 0x0043d178: entered by je at 0x0043d16c, 5 instruction(s), calls FUN_004cf9f4, ends with je to 0x0043d1b8 (forward)
    call FUN_004cf9f4                            # 0043d178
    {load} xor eax, eax                          # 0043d17d
    mov al, byte ptr [0x58320d]                  # 0043d17f
    test eax, eax                                # 0043d184
    je.d8 L_0043d1b8                             # 0043d186
    # block 0x0043d188: entered by fall-through of je at 0x0043d186, 9 instruction(s), calls FUN_0044a32c, ends with je to 0x0043d1ac (forward)
    lea ecx, [ebp - local_2c]                    # 0043d188
    push ecx                                     # 0043d18b
    call FUN_0044a32c                            # 0043d18c
    add esp, 0x4                                 # 0043d191
    fstp dword ptr [ebp - local_c]               # 0043d194
    mov edx, dword ptr [ebp - local_2c]          # 0043d197
    and edx, 0xff                                # 0043d19a
    test edx, edx                                # 0043d1a0
    je.d8 L_0043d1ac                             # 0043d1a2
    # block 0x0043d1a4: entered by fall-through of je at 0x0043d1a2, 2 instruction(s), falls into the block at 0x0043d1ac
    mov eax, dword ptr [ebp - local_c]           # 0043d1a4
    mov dword ptr [0x63a5cc], eax                # 0043d1a7
L_0043d1ac:
    # block 0x0043d1ac: entered by je at 0x0043d1a2, 2 instruction(s), falls into the block at 0x0043d1b8
    mov ecx, dword ptr [0x63a5cc]                # 0043d1ac
    mov dword ptr [0x5c3a4b], ecx                # 0043d1b2
L_0043d1b8:
    # block 0x0043d1b8: entered by je at 0x0043d186, 1 instruction(s), calls FUN_0043d6be, falls into the block at 0x0043d1bd
    call FUN_0043d6be                            # 0043d1b8
L_0043d1bd:
    # block 0x0043d1bd: entered by jmp at 0x0043a851; jmp at 0x0043a8b2; jmp at 0x0043a912; jmp at 0x0043a973; more, 5 instruction(s), ends with ret
    pop edi                                      # 0043d1bd
    pop esi                                      # 0043d1be
    {load} mov esp, ebp                          # 0043d1bf
    pop ebp                                      # 0043d1c1
    ret                                          # 0043d1c2

# --- data items (not part of the function) -------------------------
.org 0x0043d1c3 - 0x401000
SWTAB_0043d1c3:  # 4 case address(es)
    .long L_0043c09e - .text + 0x401000
    .long L_0043c0aa - .text + 0x401000
    .long L_0043c0b6 - .text + 0x401000
    .long L_0043c0c2 - .text + 0x401000
.org 0x0043d1d3 - 0x401000
SWTAB_0043d1d3:  # 4 case address(es)
    .long L_0043c12e - .text + 0x401000
    .long L_0043c12e - .text + 0x401000
    .long L_0043c12e - .text + 0x401000
    .long L_0043c12e - .text + 0x401000
.org 0x0043d1e3 - 0x401000
SWTAB_0043d1e3:  # 4 case address(es)
    .long L_0043c941 - .text + 0x401000
    .long L_0043c941 - .text + 0x401000
    .long L_0043c941 - .text + 0x401000
    .long L_0043c941 - .text + 0x401000
.org 0x0043d1f3 - 0x401000
SWTAB_0043d1f3:  # 8 case address(es)
    .long L_0043c2b7 - .text + 0x401000
    .long L_0043c332 - .text + 0x401000
    .long L_0043c3ad - .text + 0x401000
    .long L_0043c42a - .text + 0x401000
    .long L_0043c4bf - .text + 0x401000
    .long L_0043c5aa - .text + 0x401000
    .long L_0043c697 - .text + 0x401000
    .long L_0043c796 - .text + 0x401000
.org 0x0043d213 - 0x401000
SWTAB_0043d213:  # 5 case address(es)
    .long L_0043cf65 - .text + 0x401000
    .long L_0043cf67 - .text + 0x401000
    .long L_0043cf73 - .text + 0x401000
    .long L_0043cf7f - .text + 0x401000
    .long L_0043cf8b - .text + 0x401000
.set SWTAB_0043d1c3_VA, SWTAB_0043d1c3 - .text + 0x401000
.set SWTAB_0043d1d3_VA, SWTAB_0043d1d3 - .text + 0x401000
.set SWTAB_0043d1e3_VA, SWTAB_0043d1e3 - .text + 0x401000
.set SWTAB_0043d1f3_VA, SWTAB_0043d1f3 - .text + 0x401000
.set SWTAB_0043d213_VA, SWTAB_0043d213 - .text + 0x401000

