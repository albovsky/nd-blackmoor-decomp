# FUN_004ef89b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef89b
# extent:       0x004ef89b-0x004eff03 (1640 code bytes)
# span:         0x004ef89b-0x004eff03 (code 1640, tables 0, padding 0)
# sha256:       774d34d0063b3b38a31a3134853a60f150b3bcfe7e4a2a909c027113fd5e787e
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef89b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       24 ebp-relative slot(s): local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 12 more
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_c6, field_ce, field_d2, field_12e, field_132, field_13a, field_142, field_146 and 15 more; [ecx + n] field_8, field_c, field_10, field_d2, field_132, field_13e, field_146, field_14a, field_15a, field_15e, field_162, field_166 and 10 more; [edx + n] field_4, field_8, field_c, field_10, field_d2, field_12e, field_136, field_13e, field_142, field_14a, field_14e, field_15e and 11 more
# callees:      calls FUN_004c2790, FUN_0050ce04, FUN_004dadff, FUN_004daeb5, FUN_004ef52a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 399 instruction(s), 30 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
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
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_c6, 0xc6  # offset +0xc6
.equ field_ce, 0xce  # offset +0xce
.equ field_d2, 0xd2  # offset +0xd2
.equ field_12e, 0x12e  # offset +0x12e
.equ field_132, 0x132  # offset +0x132
.equ field_136, 0x136  # offset +0x136
.equ field_13a, 0x13a  # offset +0x13a
.equ field_13e, 0x13e  # offset +0x13e
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152
.equ field_156, 0x156  # offset +0x156
.equ field_15a, 0x15a  # offset +0x15a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16e, 0x16e  # offset +0x16e
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_186, 0x186  # offset +0x186
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_196, 0x196  # offset +0x196
.equ field_19a, 0x19a  # offset +0x19a
.equ field_19e, 0x19e  # offset +0x19e
.equ field_1a2, 0x1a2  # offset +0x1a2

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004ef52a, .text + (0x004ef52a - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004ef89b - 0x401000
.globl FUN_004ef89b
FUN_004ef89b:
    # block 0x004ef89b: entry, 9 instruction(s), ends with je to 0x004ef8c2 (forward)
    push ebp                                     # 004ef89b
    {load} mov ebp, esp                          # 004ef89c
    sub esp, 0x64                                # 004ef89e
    mov dword ptr [ebp - local_40], ecx          # 004ef8a1
    mov eax, dword ptr [ebp - local_40]          # 004ef8a4
    mov ecx, dword ptr [eax + field_4]           # 004ef8a7
    mov dword ptr [ebp - local_44], ecx          # 004ef8aa
    cmp dword ptr [ebp - local_44], 0x0          # 004ef8ad
    je.d8 L_004ef8c2                             # 004ef8b1
    # block 0x004ef8b3: entered by fall-through of je at 0x004ef8b1, 2 instruction(s), ends with je to 0x004ef943 (forward)
    cmp dword ptr [ebp - local_44], 0x1          # 004ef8b3
    je.d32 L_004ef943                            # 004ef8b7
    # block 0x004ef8bd: entered by fall-through of je at 0x004ef8b7, 1 instruction(s), ends with forward jump to 0x004efeee
    jmp.d32 L_004efeee                           # 004ef8bd
L_004ef8c2:
    # block 0x004ef8c2: entered by je at 0x004ef8b1, 3 instruction(s), ends with je to 0x004ef8dc (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ef8c2
    cmp dword ptr [edx + field_1a2], 0x0         # 004ef8c5
    je.d8 L_004ef8dc                             # 004ef8cc
    # block 0x004ef8ce: entered by fall-through of je at 0x004ef8cc, 4 instruction(s), ends with forward jump to 0x004ef908
    mov eax, dword ptr [ebp - local_40]          # 004ef8ce
    mov ecx, dword ptr [0x5d0377]                # 004ef8d1
    mov dword ptr [eax + field_8], ecx           # 004ef8d7
    jmp.d8 L_004ef908                            # 004ef8da
L_004ef8dc:
    # block 0x004ef8dc: entered by je at 0x004ef8cc, 3 instruction(s), ends with jne to 0x004ef908 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ef8dc
    cmp dword ptr [edx + field_8], 0x0           # 004ef8df
    jne.d8 L_004ef908                            # 004ef8e3
    # block 0x004ef8e5: entered by fall-through of jne at 0x004ef8e3, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004ef908
    push 0x55cec0                                # 004ef8e5
    push 0x6                                     # 004ef8ea
    mov eax, dword ptr [ebp - local_40]          # 004ef8ec
    add eax, 0x18                                # 004ef8ef
    push eax                                     # 004ef8f2
    push 0x55cecc                                # 004ef8f3
    mov ecx, 0x5cf659                            # 004ef8f8
    call FUN_004c2790                            # 004ef8fd
    mov ecx, dword ptr [ebp - local_40]          # 004ef902
    mov dword ptr [ecx + field_8], eax           # 004ef905
L_004ef908:
    # block 0x004ef908: entered by jmp at 0x004ef8da; jne at 0x004ef8e3, 3 instruction(s), ends with jne to 0x004ef934 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ef908
    cmp dword ptr [edx + field_c], 0x0           # 004ef90b
    jne.d8 L_004ef934                            # 004ef90f
    # block 0x004ef911: entered by fall-through of jne at 0x004ef90f, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004ef934
    push 0x55ced4                                # 004ef911
    push 0x6                                     # 004ef916
    mov eax, dword ptr [ebp - local_40]          # 004ef918
    add eax, 0x39                                # 004ef91b
    push eax                                     # 004ef91e
    push 0x55cee8                                # 004ef91f
    mov ecx, 0x5cf659                            # 004ef924
    call FUN_004c2790                            # 004ef929
    mov ecx, dword ptr [ebp - local_40]          # 004ef92e
    mov dword ptr [ecx + field_c], eax           # 004ef931
L_004ef934:
    # block 0x004ef934: entered by jne at 0x004ef90f, 3 instruction(s), ends with forward jump to 0x004efeee
    mov edx, dword ptr [ebp - local_40]          # 004ef934
    mov dword ptr [edx + field_4], 0x1           # 004ef937
    jmp.d32 L_004efeee                           # 004ef93e
L_004ef943:
    # block 0x004ef943: entered by je at 0x004ef8b7, 3 instruction(s), ends with je to 0x004efa3c (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ef943
    cmp dword ptr [eax + field_19e], 0x0         # 004ef946
    je.d32 L_004efa3c                            # 004ef94d
    # block 0x004ef953: entered by fall-through of je at 0x004ef94d, 21 instruction(s), calls FUN_0050ce04, ends with je to 0x004ef9b1 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 004ef953
    fild dword ptr [ecx + field_162]             # 004ef956
    fstp dword ptr [ebp - local_48]              # 004ef95c
    fld dword ptr [ebp - local_48]               # 004ef95f
    fdiv dword ptr [0x52cbec]                    # 004ef962
    mov edx, dword ptr [ebp - local_40]          # 004ef968
    fstp dword ptr [edx + field_16a]             # 004ef96b
    mov eax, dword ptr [ebp - local_40]          # 004ef971
    fild dword ptr [eax + field_15e]             # 004ef974
    fstp dword ptr [ebp - local_4c]              # 004ef97a
    mov ecx, dword ptr [ebp - local_40]          # 004ef97d
    fld dword ptr [ebp - local_4c]               # 004ef980
    fmul dword ptr [ecx + field_16a]             # 004ef983
    call FUN_0050ce04                            # 004ef989
    mov edx, dword ptr [ebp - local_40]          # 004ef98e
    mov dword ptr [edx + field_166], eax         # 004ef991
    mov eax, dword ptr [ebp - local_40]          # 004ef997
    mov ecx, dword ptr [eax + field_ce]          # 004ef99a
    mov dword ptr [ebp - local_50], ecx          # 004ef9a0
    cmp dword ptr [ebp - local_50], 0x0          # 004ef9a3
    je.d8 L_004ef9b1                             # 004ef9a7
    # block 0x004ef9a9: entered by fall-through of je at 0x004ef9a7, 2 instruction(s), ends with je to 0x004ef9f0 (forward)
    cmp dword ptr [ebp - local_50], 0x1          # 004ef9a9
    je.d8 L_004ef9f0                             # 004ef9ad
    # block 0x004ef9af: entered by fall-through of je at 0x004ef9ad, 1 instruction(s), ends with forward jump to 0x004efa2f
    jmp.d8 L_004efa2f                            # 004ef9af
L_004ef9b1:
    # block 0x004ef9b1: entered by je at 0x004ef9a7, 3 instruction(s), ends with jne to 0x004ef9f0 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ef9b1
    cmp dword ptr [edx + field_d2], 0x1          # 004ef9b4
    jne.d8 L_004ef9f0                            # 004ef9bb
    # block 0x004ef9bd: entered by fall-through of jne at 0x004ef9bb, 11 instruction(s), falls into the block at 0x004ef9f0
    mov eax, dword ptr [ebp - local_40]          # 004ef9bd
    mov ecx, dword ptr [ebp - local_40]          # 004ef9c0
    mov edx, dword ptr [eax + field_15e]         # 004ef9c3
    sub edx, dword ptr [ecx + field_166]         # 004ef9c9
    mov eax, dword ptr [ebp - local_40]          # 004ef9cf
    mov dword ptr [eax + field_166], edx         # 004ef9d2
    mov ecx, dword ptr [ebp - local_40]          # 004ef9d8
    fld dword ptr [0x52cbf4]                     # 004ef9db
    fsub dword ptr [ecx + field_16a]             # 004ef9e1
    mov edx, dword ptr [ebp - local_40]          # 004ef9e7
    fstp dword ptr [edx + field_16a]             # 004ef9ea
L_004ef9f0:
    # block 0x004ef9f0: entered by je at 0x004ef9ad; jne at 0x004ef9bb, 3 instruction(s), ends with jne to 0x004efa2f (forward)
    mov eax, dword ptr [ebp - local_40]          # 004ef9f0
    cmp dword ptr [eax + field_d2], 0x3          # 004ef9f3
    jne.d8 L_004efa2f                            # 004ef9fa
    # block 0x004ef9fc: entered by fall-through of jne at 0x004ef9fa, 11 instruction(s), falls into the block at 0x004efa2f
    mov ecx, dword ptr [ebp - local_40]          # 004ef9fc
    mov edx, dword ptr [ebp - local_40]          # 004ef9ff
    mov eax, dword ptr [ecx + field_15e]         # 004efa02
    sub eax, dword ptr [edx + field_166]         # 004efa08
    mov ecx, dword ptr [ebp - local_40]          # 004efa0e
    mov dword ptr [ecx + field_166], eax         # 004efa11
    mov edx, dword ptr [ebp - local_40]          # 004efa17
    fld dword ptr [0x52cbf4]                     # 004efa1a
    fsub dword ptr [edx + field_16a]             # 004efa20
    mov eax, dword ptr [ebp - local_40]          # 004efa26
    fstp dword ptr [eax + field_16a]             # 004efa29
L_004efa2f:
    # block 0x004efa2f: entered by jmp at 0x004ef9af; jne at 0x004ef9fa, 2 instruction(s), falls into the block at 0x004efa3c
    mov ecx, dword ptr [ebp - local_40]          # 004efa2f
    mov dword ptr [ecx + field_19e], 0x0         # 004efa32
L_004efa3c:
    # block 0x004efa3c: entered by je at 0x004ef94d, 14 instruction(s), calls FUN_004dadff, FUN_004daeb5, ends with je to 0x004efa7e (forward)
    mov ecx, 0x5830a6                            # 004efa3c
    call FUN_004dadff                            # 004efa41
    lea edx, [ebp - local_8]                     # 004efa46
    push edx                                     # 004efa49
    mov ecx, 0x5830a6                            # 004efa4a
    call FUN_004daeb5                            # 004efa4f
    mov ecx, dword ptr [eax]                     # 004efa54
    mov edx, dword ptr [eax + field_4]           # 004efa56
    mov eax, dword ptr [ebp - local_40]          # 004efa59
    mov dword ptr [eax + field_18a], ecx         # 004efa5c
    mov dword ptr [eax + field_18e], edx         # 004efa62
    mov ecx, dword ptr [ebp - local_40]          # 004efa68
    cmp dword ptr [ecx + field_10], 0x0          # 004efa6b
    je.d8 L_004efa7e                             # 004efa6f
    # block 0x004efa71: entered by fall-through of je at 0x004efa6f, 3 instruction(s), ends with jne to 0x004efb14 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efa71
    cmp dword ptr [edx + field_10], 0x1          # 004efa74
    jne.d32 L_004efb14                           # 004efa78
L_004efa7e:
    # block 0x004efa7e: entered by je at 0x004efa6f; fall-through of jne at 0x004efa78, 3 instruction(s), ends with jne to 0x004efb14 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efa7e
    cmp dword ptr [eax + field_16e], 0x0         # 004efa81
    jne.d32 L_004efb14                           # 004efa88
    # block 0x004efa8e: entered by fall-through of jne at 0x004efa88, 3 instruction(s), ends with je to 0x004efb14 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 004efa8e
    cmp dword ptr [ecx + field_19a], 0x0         # 004efa91
    je.d8 L_004efb14                             # 004efa98
    # block 0x004efa9a: entered by fall-through of je at 0x004efa98, 4 instruction(s), ends with jne to 0x004efb14 (forward)
    {load} xor edx, edx                          # 004efa9a
    mov dl, byte ptr [0x58321d]                  # 004efa9c
    cmp edx, 0x1                                 # 004efaa2
    jne.d8 L_004efb14                            # 004efaa5
    # block 0x004efaa7: entered by fall-through of jne at 0x004efaa5, 23 instruction(s), ends with je to 0x004efb0f (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efaa7
    mov dword ptr [eax + field_16e], 0x1         # 004efaaa
    mov ecx, dword ptr [ebp - local_40]          # 004efab4
    mov edx, dword ptr [ecx + field_18a]         # 004efab7
    mov eax, dword ptr [ecx + field_18e]         # 004efabd
    mov ecx, dword ptr [ebp - local_40]          # 004efac3
    mov dword ptr [ecx + field_182], edx         # 004efac6
    mov dword ptr [ecx + field_186], eax         # 004efacc
    mov edx, dword ptr [ebp - local_40]          # 004efad2
    add edx, 0x13e                               # 004efad5
    mov eax, dword ptr [ebp - local_40]          # 004efadb
    add eax, 0x14e                               # 004efade
    mov ecx, dword ptr [edx]                     # 004efae3
    mov dword ptr [eax], ecx                     # 004efae5
    mov ecx, dword ptr [edx + field_4]           # 004efae7
    mov dword ptr [eax + field_4], ecx           # 004efaea
    mov ecx, dword ptr [edx + field_8]           # 004efaed
    mov dword ptr [eax + field_8], ecx           # 004efaf0
    mov edx, dword ptr [edx + field_c]           # 004efaf3
    mov dword ptr [eax + field_c], edx           # 004efaf6
    mov eax, dword ptr [ebp - local_40]          # 004efaf9
    cmp dword ptr [eax + field_c6], 0x0          # 004efafc
    je.d8 L_004efb0f                             # 004efb03
    # block 0x004efb05: entered by fall-through of je at 0x004efb03, 2 instruction(s), falls into the block at 0x004efb0f
    mov ecx, dword ptr [ebp - local_40]          # 004efb05
    mov dword ptr [ecx + field_10], 0x2          # 004efb08
L_004efb0f:
    # block 0x004efb0f: entered by je at 0x004efb03, 1 instruction(s), ends with forward jump to 0x004efeee
    jmp.d32 L_004efeee                           # 004efb0f
L_004efb14:
    # block 0x004efb14: entered by jne at 0x004efa78; jne at 0x004efa88; je at 0x004efa98; jne at 0x004efaa5, 3 instruction(s), ends with jne to 0x004efea4 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efb14
    cmp dword ptr [edx + field_16e], 0x1         # 004efb17
    jne.d32 L_004efea4                           # 004efb1e
    # block 0x004efb24: entered by fall-through of jne at 0x004efb1e, 3 instruction(s), ends with je to 0x004efea4 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efb24
    cmp dword ptr [eax + field_19a], 0x0         # 004efb27
    je.d32 L_004efea4                            # 004efb2e
    # block 0x004efb34: entered by fall-through of je at 0x004efb2e, 4 instruction(s), ends with jne to 0x004efea4 (forward)
    {load} xor ecx, ecx                          # 004efb34
    mov cl, byte ptr [0x58321d]                  # 004efb36
    cmp ecx, 0x1                                 # 004efb3c
    jne.d32 L_004efea4                           # 004efb3f
    # block 0x004efb45: entered by fall-through of jne at 0x004efb3f, 42 instruction(s), ends with je to 0x004efbe3 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efb45
    mov eax, dword ptr [edx + field_182]         # 004efb48
    mov ecx, dword ptr [edx + field_186]         # 004efb4e
    mov dword ptr [ebp - local_20], eax          # 004efb54
    mov dword ptr [ebp - local_1c], ecx          # 004efb57
    mov edx, dword ptr [ebp - local_40]          # 004efb5a
    add edx, 0x18a                               # 004efb5d
    mov dword ptr [ebp - local_3c], edx          # 004efb63
    mov eax, dword ptr [ebp - local_3c]          # 004efb66
    mov ecx, dword ptr [eax + field_4]           # 004efb69
    sub ecx, dword ptr [ebp - local_1c]          # 004efb6c
    mov dword ptr [ebp - local_38], ecx          # 004efb6f
    mov edx, dword ptr [ebp - local_3c]          # 004efb72
    mov eax, dword ptr [edx]                     # 004efb75
    sub eax, dword ptr [ebp - local_20]          # 004efb77
    mov dword ptr [ebp - local_34], eax          # 004efb7a
    mov ecx, dword ptr [ebp - local_34]          # 004efb7d
    mov dword ptr [ebp - local_30], ecx          # 004efb80
    mov edx, dword ptr [ebp - local_38]          # 004efb83
    mov dword ptr [ebp - local_2c], edx          # 004efb86
    mov eax, dword ptr [ebp - local_30]          # 004efb89
    mov ecx, dword ptr [ebp - local_2c]          # 004efb8c
    mov dword ptr [ebp - local_28], eax          # 004efb8f
    mov dword ptr [ebp - local_24], ecx          # 004efb92
    mov edx, dword ptr [ebp - local_28]          # 004efb95
    mov eax, dword ptr [ebp - local_24]          # 004efb98
    mov dword ptr [ebp - local_18], edx          # 004efb9b
    mov dword ptr [ebp - local_14], eax          # 004efb9e
    mov ecx, dword ptr [ebp - local_18]          # 004efba1
    mov dword ptr [ebp - local_10], ecx          # 004efba4
    mov edx, dword ptr [ebp - local_14]          # 004efba7
    mov dword ptr [ebp - local_c], edx           # 004efbaa
    mov eax, dword ptr [ebp - local_40]          # 004efbad
    mov ecx, dword ptr [ebp - local_10]          # 004efbb0
    mov dword ptr [eax + field_192], ecx         # 004efbb3
    mov edx, dword ptr [ebp - local_c]           # 004efbb9
    mov dword ptr [eax + field_196], edx         # 004efbbc
    mov eax, dword ptr [ebp - local_40]          # 004efbc2
    mov ecx, dword ptr [eax + field_ce]          # 004efbc5
    mov dword ptr [ebp - local_54], ecx          # 004efbcb
    cmp dword ptr [ebp - local_54], 0x0          # 004efbce
    je.d8 L_004efbe3                             # 004efbd2
    # block 0x004efbd4: entered by fall-through of je at 0x004efbd2, 2 instruction(s), ends with je to 0x004efd45 (forward)
    cmp dword ptr [ebp - local_54], 0x1          # 004efbd4
    je.d32 L_004efd45                            # 004efbd8
    # block 0x004efbde: entered by fall-through of je at 0x004efbd8, 1 instruction(s), ends with forward jump to 0x004efea2
    jmp.d32 L_004efea2                           # 004efbde
L_004efbe3:
    # block 0x004efbe3: entered by je at 0x004efbd2, 17 instruction(s), ends with jge to 0x004efc5e (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efbe3
    mov eax, dword ptr [edx + field_14e]         # 004efbe6
    mov ecx, dword ptr [ebp - local_40]          # 004efbec
    add eax, dword ptr [ecx + field_192]         # 004efbef
    mov edx, dword ptr [ebp - local_40]          # 004efbf5
    mov dword ptr [edx + field_13e], eax         # 004efbf8
    mov eax, dword ptr [ebp - local_40]          # 004efbfe
    mov ecx, dword ptr [eax + field_156]         # 004efc01
    mov edx, dword ptr [ebp - local_40]          # 004efc07
    add ecx, dword ptr [edx + field_192]         # 004efc0a
    mov eax, dword ptr [ebp - local_40]          # 004efc10
    mov dword ptr [eax + field_146], ecx         # 004efc13
    mov ecx, dword ptr [ebp - local_40]          # 004efc19
    mov edx, dword ptr [ebp - local_40]          # 004efc1c
    mov eax, dword ptr [ecx + field_13e]         # 004efc1f
    cmp eax, dword ptr [edx + field_12e]         # 004efc25
    jge.d8 L_004efc5e                            # 004efc2b
    # block 0x004efc2d: entered by fall-through of jge at 0x004efc2b, 11 instruction(s), falls into the block at 0x004efc5e
    mov ecx, dword ptr [ebp - local_40]          # 004efc2d
    mov edx, dword ptr [ebp - local_40]          # 004efc30
    mov eax, dword ptr [edx + field_12e]         # 004efc33
    mov dword ptr [ecx + field_13e], eax         # 004efc39
    mov ecx, dword ptr [ebp - local_40]          # 004efc3f
    mov edx, dword ptr [ecx + field_13e]         # 004efc42
    mov eax, dword ptr [ebp - local_40]          # 004efc48
    mov ecx, dword ptr [eax + field_17a]         # 004efc4b
    lea edx, [edx + ecx - field_minus_1]         # 004efc51
    mov eax, dword ptr [ebp - local_40]          # 004efc55
    mov dword ptr [eax + field_146], edx         # 004efc58
L_004efc5e:
    # block 0x004efc5e: entered by jge at 0x004efc2b, 5 instruction(s), ends with jle to 0x004efca2 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 004efc5e
    mov edx, dword ptr [ebp - local_40]          # 004efc61
    mov eax, dword ptr [ecx + field_146]         # 004efc64
    cmp eax, dword ptr [edx + field_136]         # 004efc6a
    jle.d8 L_004efca2                            # 004efc70
    # block 0x004efc72: entered by fall-through of jle at 0x004efc70, 11 instruction(s), falls into the block at 0x004efca2
    mov ecx, dword ptr [ebp - local_40]          # 004efc72
    mov edx, dword ptr [ebp - local_40]          # 004efc75
    mov eax, dword ptr [edx + field_136]         # 004efc78
    mov dword ptr [ecx + field_146], eax         # 004efc7e
    mov ecx, dword ptr [ebp - local_40]          # 004efc84
    mov edx, dword ptr [ebp - local_40]          # 004efc87
    mov eax, dword ptr [ecx + field_146]         # 004efc8a
    sub eax, dword ptr [edx + field_17a]         # 004efc90
    add eax, 0x1                                 # 004efc96
    mov ecx, dword ptr [ebp - local_40]          # 004efc99
    mov dword ptr [ecx + field_13e], eax         # 004efc9c
L_004efca2:
    # block 0x004efca2: entered by jle at 0x004efc70, 19 instruction(s), ends with jne to 0x004efd23 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efca2
    mov eax, dword ptr [ebp - local_40]          # 004efca5
    mov ecx, dword ptr [edx + field_13e]         # 004efca8
    sub ecx, dword ptr [eax + field_12e]         # 004efcae
    mov edx, dword ptr [ebp - local_40]          # 004efcb4
    mov dword ptr [edx + field_166], ecx         # 004efcb7
    mov eax, dword ptr [ebp - local_40]          # 004efcbd
    fild dword ptr [eax + field_166]             # 004efcc0
    fstp dword ptr [ebp - local_58]              # 004efcc6
    mov ecx, dword ptr [ebp - local_40]          # 004efcc9
    fild dword ptr [ecx + field_15e]             # 004efccc
    fstp dword ptr [ebp - local_5c]              # 004efcd2
    fld dword ptr [ebp - local_58]               # 004efcd5
    fdiv dword ptr [ebp - local_5c]              # 004efcd8
    mov edx, dword ptr [ebp - local_40]          # 004efcdb
    fstp dword ptr [edx + field_16a]             # 004efcde
    mov eax, dword ptr [ebp - local_40]          # 004efce4
    cmp dword ptr [eax + field_d2], 0x1          # 004efce7
    jne.d8 L_004efd23                            # 004efcee
    # block 0x004efcf0: entered by fall-through of jne at 0x004efcee, 11 instruction(s), falls into the block at 0x004efd23
    mov ecx, dword ptr [ebp - local_40]          # 004efcf0
    mov edx, dword ptr [ebp - local_40]          # 004efcf3
    mov eax, dword ptr [ecx + field_15e]         # 004efcf6
    sub eax, dword ptr [edx + field_166]         # 004efcfc
    mov ecx, dword ptr [ebp - local_40]          # 004efd02
    mov dword ptr [ecx + field_166], eax         # 004efd05
    mov edx, dword ptr [ebp - local_40]          # 004efd0b
    fld dword ptr [0x52cbf4]                     # 004efd0e
    fsub dword ptr [edx + field_16a]             # 004efd14
    mov eax, dword ptr [ebp - local_40]          # 004efd1a
    fstp dword ptr [eax + field_16a]             # 004efd1d
L_004efd23:
    # block 0x004efd23: entered by jne at 0x004efcee, 7 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004efea2
    mov ecx, dword ptr [ebp - local_40]          # 004efd23
    fld dword ptr [ecx + field_16a]              # 004efd26
    fmul dword ptr [0x52cbec]                    # 004efd2c
    call FUN_0050ce04                            # 004efd32
    mov edx, dword ptr [ebp - local_40]          # 004efd37
    mov dword ptr [edx + field_162], eax         # 004efd3a
    jmp.d32 L_004efea2                           # 004efd40
L_004efd45:
    # block 0x004efd45: entered by je at 0x004efbd8, 17 instruction(s), ends with jge to 0x004efdc0 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efd45
    mov ecx, dword ptr [eax + field_152]         # 004efd48
    mov edx, dword ptr [ebp - local_40]          # 004efd4e
    add ecx, dword ptr [edx + field_196]         # 004efd51
    mov eax, dword ptr [ebp - local_40]          # 004efd57
    mov dword ptr [eax + field_142], ecx         # 004efd5a
    mov ecx, dword ptr [ebp - local_40]          # 004efd60
    mov edx, dword ptr [ecx + field_15a]         # 004efd63
    mov eax, dword ptr [ebp - local_40]          # 004efd69
    add edx, dword ptr [eax + field_196]         # 004efd6c
    mov ecx, dword ptr [ebp - local_40]          # 004efd72
    mov dword ptr [ecx + field_14a], edx         # 004efd75
    mov edx, dword ptr [ebp - local_40]          # 004efd7b
    mov eax, dword ptr [ebp - local_40]          # 004efd7e
    mov ecx, dword ptr [edx + field_142]         # 004efd81
    cmp ecx, dword ptr [eax + field_132]         # 004efd87
    jge.d8 L_004efdc0                            # 004efd8d
    # block 0x004efd8f: entered by fall-through of jge at 0x004efd8d, 11 instruction(s), falls into the block at 0x004efdc0
    mov edx, dword ptr [ebp - local_40]          # 004efd8f
    mov eax, dword ptr [ebp - local_40]          # 004efd92
    mov ecx, dword ptr [eax + field_132]         # 004efd95
    mov dword ptr [edx + field_142], ecx         # 004efd9b
    mov edx, dword ptr [ebp - local_40]          # 004efda1
    mov eax, dword ptr [edx + field_142]         # 004efda4
    mov ecx, dword ptr [ebp - local_40]          # 004efdaa
    mov edx, dword ptr [ecx + field_17e]         # 004efdad
    lea eax, [eax + edx - field_minus_1]         # 004efdb3
    mov ecx, dword ptr [ebp - local_40]          # 004efdb7
    mov dword ptr [ecx + field_14a], eax         # 004efdba
L_004efdc0:
    # block 0x004efdc0: entered by jge at 0x004efd8d, 5 instruction(s), ends with jle to 0x004efe04 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efdc0
    mov eax, dword ptr [ebp - local_40]          # 004efdc3
    mov ecx, dword ptr [edx + field_14a]         # 004efdc6
    cmp ecx, dword ptr [eax + field_13a]         # 004efdcc
    jle.d8 L_004efe04                            # 004efdd2
    # block 0x004efdd4: entered by fall-through of jle at 0x004efdd2, 11 instruction(s), falls into the block at 0x004efe04
    mov edx, dword ptr [ebp - local_40]          # 004efdd4
    mov eax, dword ptr [ebp - local_40]          # 004efdd7
    mov ecx, dword ptr [eax + field_13a]         # 004efdda
    mov dword ptr [edx + field_14a], ecx         # 004efde0
    mov edx, dword ptr [ebp - local_40]          # 004efde6
    mov eax, dword ptr [ebp - local_40]          # 004efde9
    mov ecx, dword ptr [edx + field_14a]         # 004efdec
    sub ecx, dword ptr [eax + field_17e]         # 004efdf2
    add ecx, 0x1                                 # 004efdf8
    mov edx, dword ptr [ebp - local_40]          # 004efdfb
    mov dword ptr [edx + field_142], ecx         # 004efdfe
L_004efe04:
    # block 0x004efe04: entered by jle at 0x004efdd2, 19 instruction(s), ends with jne to 0x004efe85 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efe04
    mov ecx, dword ptr [ebp - local_40]          # 004efe07
    mov edx, dword ptr [eax + field_142]         # 004efe0a
    sub edx, dword ptr [ecx + field_132]         # 004efe10
    mov eax, dword ptr [ebp - local_40]          # 004efe16
    mov dword ptr [eax + field_166], edx         # 004efe19
    mov ecx, dword ptr [ebp - local_40]          # 004efe1f
    fild dword ptr [ecx + field_166]             # 004efe22
    fstp dword ptr [ebp - local_60]              # 004efe28
    mov edx, dword ptr [ebp - local_40]          # 004efe2b
    fild dword ptr [edx + field_15e]             # 004efe2e
    fstp dword ptr [ebp - local_64]              # 004efe34
    fld dword ptr [ebp - local_60]               # 004efe37
    fdiv dword ptr [ebp - local_64]              # 004efe3a
    mov eax, dword ptr [ebp - local_40]          # 004efe3d
    fstp dword ptr [eax + field_16a]             # 004efe40
    mov ecx, dword ptr [ebp - local_40]          # 004efe46
    cmp dword ptr [ecx + field_d2], 0x3          # 004efe49
    jne.d8 L_004efe85                            # 004efe50
    # block 0x004efe52: entered by fall-through of jne at 0x004efe50, 11 instruction(s), falls into the block at 0x004efe85
    mov edx, dword ptr [ebp - local_40]          # 004efe52
    mov eax, dword ptr [ebp - local_40]          # 004efe55
    mov ecx, dword ptr [edx + field_15e]         # 004efe58
    sub ecx, dword ptr [eax + field_166]         # 004efe5e
    mov edx, dword ptr [ebp - local_40]          # 004efe64
    mov dword ptr [edx + field_166], ecx         # 004efe67
    mov eax, dword ptr [ebp - local_40]          # 004efe6d
    fld dword ptr [0x52cbf4]                     # 004efe70
    fsub dword ptr [eax + field_16a]             # 004efe76
    mov ecx, dword ptr [ebp - local_40]          # 004efe7c
    fstp dword ptr [ecx + field_16a]             # 004efe7f
L_004efe85:
    # block 0x004efe85: entered by jne at 0x004efe50, 6 instruction(s), calls FUN_0050ce04, falls into the block at 0x004efea2
    mov edx, dword ptr [ebp - local_40]          # 004efe85
    fld dword ptr [edx + field_16a]              # 004efe88
    fmul dword ptr [0x52cbec]                    # 004efe8e
    call FUN_0050ce04                            # 004efe94
    mov ecx, dword ptr [ebp - local_40]          # 004efe99
    mov dword ptr [ecx + field_162], eax         # 004efe9c
L_004efea2:
    # block 0x004efea2: entered by jmp at 0x004efbde; jmp at 0x004efd40, 1 instruction(s), ends with forward jump to 0x004efeee
    jmp.d8 L_004efeee                            # 004efea2
L_004efea4:
    # block 0x004efea4: entered by jne at 0x004efb1e; je at 0x004efb2e; jne at 0x004efb3f, 3 instruction(s), ends with jne to 0x004efee1 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004efea4
    cmp dword ptr [edx + field_16e], 0x1         # 004efea7
    jne.d8 L_004efee1                            # 004efeae
    # block 0x004efeb0: entered by fall-through of jne at 0x004efeae, 3 instruction(s), ends with je to 0x004efec8 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004efeb0
    cmp dword ptr [eax + field_19a], 0x0         # 004efeb3
    je.d8 L_004efec8                             # 004efeba
    # block 0x004efebc: entered by fall-through of je at 0x004efeba, 4 instruction(s), ends with jne to 0x004efee1 (forward)
    {load} xor ecx, ecx                          # 004efebc
    mov cl, byte ptr [0x58321d]                  # 004efebe
    test ecx, ecx                                # 004efec4
    jne.d8 L_004efee1                            # 004efec6
L_004efec8:
    # block 0x004efec8: entered by je at 0x004efeba; fall-through of jne at 0x004efec6, 5 instruction(s), ends with forward jump to 0x004efeee
    mov edx, dword ptr [ebp - local_40]          # 004efec8
    mov dword ptr [edx + field_16e], 0x0         # 004efecb
    mov eax, dword ptr [ebp - local_40]          # 004efed5
    mov dword ptr [eax + field_10], 0x0          # 004efed8
    jmp.d8 L_004efeee                            # 004efedf
L_004efee1:
    # block 0x004efee1: entered by jne at 0x004efeae; jne at 0x004efec6, 2 instruction(s), falls into the block at 0x004efeee
    mov ecx, dword ptr [ebp - local_40]          # 004efee1
    mov dword ptr [ecx + field_16e], 0x0         # 004efee4
L_004efeee:
    # block 0x004efeee: entered by jmp at 0x004ef8bd; jmp at 0x004ef93e; jmp at 0x004efb0f; jmp at 0x004efea2; more, 7 instruction(s), calls FUN_004ef52a, ends with ret
    mov ecx, dword ptr [ebp - local_40]          # 004efeee
    call FUN_004ef52a                            # 004efef1
    mov edx, dword ptr [ebp - local_40]          # 004efef6
    mov eax, dword ptr [edx + field_162]         # 004efef9
    {load} mov esp, ebp                          # 004efeff
    pop ebp                                      # 004eff01
    ret                                          # 004eff02

