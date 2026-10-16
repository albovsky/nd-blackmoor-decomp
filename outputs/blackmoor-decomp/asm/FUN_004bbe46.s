# FUN_004bbe46
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bbe46
# extent:       0x004bbe46-0x004bc2aa (1124 code bytes)
# span:         0x004bbe46-0x004bc2aa (code 1124, tables 0, padding 0)
# sha256:       7c96b219aabbf82663cd18e6b60dd14df10614a8449d60f66752680fc251fe46
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bbe46
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_24, local_28, local_2c, local_30, local_34 and 4 more
# fields:       [eax + n] field_4, field_8, field_c, field_18, field_38, field_50, field_54, field_60, field_68, field_6c, field_70, field_e0 and 7 more; [ecx + n] field_4, field_8, field_c, field_18, field_34, field_58, field_b4, field_b8, field_e0, field_130, field_140, field_144 and 7 more; [edx + n] field_4, field_8, field_c, field_18, field_30, field_54, field_68, field_6c, field_74, field_b4, field_bc, field_c0 and 8 more; [esi + n] field_8d0, field_8dc
# callees:      calls FUN_004be367, FUN_0050cd50, FUN_0050ca3e, FUN_0050ce04, FUN_004bb3de, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 327 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_e0, 0xe0  # offset +0xe0
.equ field_114, 0x114  # offset +0x114
.equ field_128, 0x128  # offset +0x128
.equ field_130, 0x130  # offset +0x130
.equ field_134, 0x134  # offset +0x134
.equ field_13c, 0x13c  # offset +0x13c
.equ field_140, 0x140  # offset +0x140
.equ field_144, 0x144  # offset +0x144
.equ field_148, 0x148  # offset +0x148
.equ field_17c, 0x17c  # offset +0x17c
.equ field_2f4, 0x2f4  # offset +0x2f4
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fc, 0x2fc  # offset +0x2fc
.equ field_300, 0x300  # offset +0x300
.equ field_318, 0x318  # offset +0x318
.equ field_354, 0x354  # offset +0x354
.equ field_8cc, 0x8cc  # offset +0x8cc
.equ field_8d0, 0x8d0  # offset +0x8d0
.equ field_8d4, 0x8d4  # offset +0x8d4
.equ field_8d8, 0x8d8  # offset +0x8d8
.equ field_8dc, 0x8dc  # offset +0x8dc
.equ field_8e0, 0x8e0  # offset +0x8e0

# --- external targets -----------------------------------------------
.set FUN_004bb3de, .text + (0x004bb3de - 0x401000)
.set FUN_004be367, .text + (0x004be367 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004bbe46 - 0x401000
.globl FUN_004bbe46
FUN_004bbe46:
    # block 0x004bbe46: entry, 16 instruction(s), calls FUN_004be367, ends with je to 0x004bbe80 (forward)
    push ebp                                     # 004bbe46
    {load} mov ebp, esp                          # 004bbe47
    sub esp, 0x48                                # 004bbe49
    push esi                                     # 004bbe4c
    push edi                                     # 004bbe4d
    mov dword ptr [ebp - local_10], ecx          # 004bbe4e
    mov ecx, dword ptr [ebp - local_10]          # 004bbe51
    call FUN_004be367                            # 004bbe54
    mov dword ptr [ebp - local_4], eax           # 004bbe59
    mov eax, dword ptr [ebp - local_4]           # 004bbe5c
    mov ecx, dword ptr [ebp + arg_8]             # 004bbe5f
    mov dword ptr [eax + field_38], ecx          # 004bbe62
    mov edx, dword ptr [ebp + arg_8]             # 004bbe65
    mov dword ptr [ebp - local_14], edx          # 004bbe68
    cmp dword ptr [ebp - local_14], 0x0          # 004bbe6b
    je.d8 L_004bbe80                             # 004bbe6f
    # block 0x004bbe71: entered by fall-through of je at 0x004bbe6f, 2 instruction(s), ends with je to 0x004bc008 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 004bbe71
    je.d32 L_004bc008                            # 004bbe75
    # block 0x004bbe7b: entered by fall-through of je at 0x004bbe75, 1 instruction(s), ends with forward jump to 0x004bc18b
    jmp.d32 L_004bc18b                           # 004bbe7b
L_004bbe80:
    # block 0x004bbe80: entered by je at 0x004bbe6f, 112 instruction(s), calls FUN_0050cd50, FUN_0050ca3e, FUN_0050ce04, ends with forward jump to 0x004bc18b
    call FUN_0050cd50                            # 004bbe80
    cdq                                          # 004bbe85
    mov ecx, 0x6                                 # 004bbe86
    idiv ecx                                     # 004bbe8b
    mov dword ptr [ebp - local_8], edx           # 004bbe8d
    mov edx, dword ptr [ebp - local_4]           # 004bbe90
    mov eax, dword ptr [ebp - local_8]           # 004bbe93
    mov dword ptr [edx + field_30], eax          # 004bbe96
    mov ecx, dword ptr [ebp - local_4]           # 004bbe99
    mov edx, dword ptr [0x63a8cc]                # 004bbe9c
    mov dword ptr [ecx + field_34], edx          # 004bbea2
    mov eax, dword ptr [0x63a8cc]                # 004bbea5
    push eax                                     # 004bbeaa
    mov ecx, dword ptr [ebp - local_8]           # 004bbeab
    push ecx                                     # 004bbeae
    push 0x551f60                                # 004bbeaf
    mov edx, dword ptr [ebp - local_4]           # 004bbeb4
    push edx                                     # 004bbeb7
    call FUN_0050ca3e                            # 004bbeb8
    add esp, 0x10                                # 004bbebd
    mov eax, dword ptr [0x63a8cc]                # 004bbec0
    add eax, 0x1                                 # 004bbec5
    mov dword ptr [0x63a8cc], eax                # 004bbec8
    mov ecx, dword ptr [ebp - local_10]          # 004bbecd
    mov edx, dword ptr [ecx + field_18]          # 004bbed0
    mov eax, dword ptr [ebp - local_8]           # 004bbed3
    shl eax, 0x4                                 # 004bbed6
    mov ecx, dword ptr [ebp - local_10]          # 004bbed9
    mov ecx, dword ptr [ecx + field_18]          # 004bbedc
    mov esi, dword ptr [ebp - local_8]           # 004bbedf
    shl esi, 0x4                                 # 004bbee2
    mov edx, dword ptr [edx + eax + field_c0]    # 004bbee5
    sub edx, dword ptr [ecx + esi + field_b8]    # 004bbeec
    add edx, 0x1                                 # 004bbef3
    mov eax, dword ptr [ebp - local_4]           # 004bbef6
    mov dword ptr [eax + field_54], edx          # 004bbef9
    mov ecx, dword ptr [ebp - local_10]          # 004bbefc
    mov edx, dword ptr [ecx + field_18]          # 004bbeff
    mov eax, dword ptr [ebp - local_8]           # 004bbf02
    shl eax, 0x4                                 # 004bbf05
    mov ecx, dword ptr [ebp - local_10]          # 004bbf08
    mov ecx, dword ptr [ecx + field_18]          # 004bbf0b
    mov esi, dword ptr [ebp - local_8]           # 004bbf0e
    shl esi, 0x4                                 # 004bbf11
    mov edx, dword ptr [edx + eax + field_bc]    # 004bbf14
    sub edx, dword ptr [ecx + esi + field_b4]    # 004bbf1b
    add edx, 0x1                                 # 004bbf22
    mov eax, dword ptr [ebp - local_4]           # 004bbf25
    mov dword ptr [eax + field_50], edx          # 004bbf28
    mov ecx, dword ptr [ebp - local_10]          # 004bbf2b
    mov edx, dword ptr [ecx + field_18]          # 004bbf2e
    mov eax, dword ptr [ebp - local_8]           # 004bbf31
    shl eax, 0x4                                 # 004bbf34
    lea ecx, [edx + eax + field_b4]              # 004bbf37
    mov edx, dword ptr [ebp - local_4]           # 004bbf3e
    add edx, 0x40                                # 004bbf41
    mov eax, dword ptr [ecx]                     # 004bbf44
    mov dword ptr [edx], eax                     # 004bbf46
    mov eax, dword ptr [ecx + field_4]           # 004bbf48
    mov dword ptr [edx + field_4], eax           # 004bbf4b
    mov eax, dword ptr [ecx + field_8]           # 004bbf4e
    mov dword ptr [edx + field_8], eax           # 004bbf51
    mov ecx, dword ptr [ecx + field_c]           # 004bbf54
    mov dword ptr [edx + field_c], ecx           # 004bbf57
    mov edx, dword ptr [ebp - local_10]          # 004bbf5a
    mov eax, dword ptr [edx + field_18]          # 004bbf5d
    mov ecx, dword ptr [ebp - local_8]           # 004bbf60
    imul ecx, ecx, 0x50                          # 004bbf63
    lea esi, [eax + ecx + field_114]             # 004bbf66
    mov edi, dword ptr [ebp - local_4]           # 004bbf6d
    add edi, 0x88                                # 004bbf70
    mov ecx, 0x14                                # 004bbf76
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bbf7b
    mov edx, dword ptr [ebp - local_10]          # 004bbf7d
    mov eax, dword ptr [edx + field_18]          # 004bbf80
    mov ecx, dword ptr [ebp - local_4]           # 004bbf83
    mov edx, dword ptr [eax + field_8cc]         # 004bbf86
    mov dword ptr [ecx + field_130], edx         # 004bbf8c
    mov eax, dword ptr [ebp - local_10]          # 004bbf92
    mov esi, dword ptr [eax + field_18]          # 004bbf95
    call FUN_0050cd50                            # 004bbf98
    {load} mov edi, eax                          # 004bbf9d
    mov ecx, dword ptr [ebp - local_10]          # 004bbf9f
    mov edx, dword ptr [ecx + field_18]          # 004bbfa2
    mov eax, dword ptr [ebp - local_10]          # 004bbfa5
    mov ecx, dword ptr [eax + field_18]          # 004bbfa8
    fld dword ptr [edx + field_8d4]              # 004bbfab
    fsub dword ptr [ecx + field_8d0]             # 004bbfb1
    call FUN_0050ce04                            # 004bbfb7
    {load} mov ecx, eax                          # 004bbfbc
    {load} mov eax, edi                          # 004bbfbe
    cdq                                          # 004bbfc0
    idiv ecx                                     # 004bbfc1
    mov dword ptr [ebp - local_18], edx          # 004bbfc3
    fild dword ptr [ebp - local_18]              # 004bbfc6
    fstp dword ptr [ebp - local_1c]              # 004bbfc9
    fld dword ptr [ebp - local_1c]               # 004bbfcc
    fadd dword ptr [esi + field_8d0]             # 004bbfcf
    fstp qword ptr [ebp - local_24]              # 004bbfd5
    call FUN_0050cd50                            # 004bbfd8
    cdq                                          # 004bbfdd
    mov ecx, 0xa                                 # 004bbfde
    idiv ecx                                     # 004bbfe3
    mov dword ptr [ebp - local_28], edx          # 004bbfe5
    fild dword ptr [ebp - local_28]              # 004bbfe8
    fstp dword ptr [ebp - local_2c]              # 004bbfeb
    fld dword ptr [ebp - local_2c]               # 004bbfee
    fdiv qword ptr [0x52e208]                    # 004bbff1
    fadd qword ptr [ebp - local_24]              # 004bbff7
    mov edx, dword ptr [ebp - local_4]           # 004bbffa
    fstp dword ptr [edx + field_134]             # 004bbffd
    jmp.d32 L_004bc18b                           # 004bc003
L_004bc008:
    # block 0x004bc008: entered by je at 0x004bbe75, 111 instruction(s), calls FUN_0050cd50, FUN_0050ca3e, FUN_0050ce04, falls into the block at 0x004bc18b
    call FUN_0050cd50                            # 004bc008
    cdq                                          # 004bc00d
    mov ecx, 0x6                                 # 004bc00e
    idiv ecx                                     # 004bc013
    mov dword ptr [ebp - local_c], edx           # 004bc015
    mov edx, dword ptr [ebp - local_4]           # 004bc018
    mov eax, dword ptr [ebp - local_c]           # 004bc01b
    mov dword ptr [edx + field_30], eax          # 004bc01e
    mov ecx, dword ptr [ebp - local_4]           # 004bc021
    mov edx, dword ptr [0x63a8d0]                # 004bc024
    mov dword ptr [ecx + field_34], edx          # 004bc02a
    mov eax, dword ptr [0x63a8d0]                # 004bc02d
    push eax                                     # 004bc032
    mov ecx, dword ptr [ebp - local_c]           # 004bc033
    push ecx                                     # 004bc036
    push 0x551f6c                                # 004bc037
    mov edx, dword ptr [ebp - local_4]           # 004bc03c
    push edx                                     # 004bc03f
    call FUN_0050ca3e                            # 004bc040
    add esp, 0x10                                # 004bc045
    mov eax, dword ptr [0x63a8d0]                # 004bc048
    add eax, 0x1                                 # 004bc04d
    mov dword ptr [0x63a8d0], eax                # 004bc050
    mov ecx, dword ptr [ebp - local_10]          # 004bc055
    mov edx, dword ptr [ecx + field_18]          # 004bc058
    mov eax, dword ptr [ebp - local_c]           # 004bc05b
    shl eax, 0x4                                 # 004bc05e
    mov ecx, dword ptr [ebp - local_10]          # 004bc061
    mov ecx, dword ptr [ecx + field_18]          # 004bc064
    mov esi, dword ptr [ebp - local_c]           # 004bc067
    shl esi, 0x4                                 # 004bc06a
    mov edx, dword ptr [edx + eax + field_300]   # 004bc06d
    sub edx, dword ptr [ecx + esi + field_2f8]   # 004bc074
    add edx, 0x1                                 # 004bc07b
    mov eax, dword ptr [ebp - local_4]           # 004bc07e
    mov dword ptr [eax + field_54], edx          # 004bc081
    mov ecx, dword ptr [ebp - local_10]          # 004bc084
    mov edx, dword ptr [ecx + field_18]          # 004bc087
    mov eax, dword ptr [ebp - local_c]           # 004bc08a
    shl eax, 0x4                                 # 004bc08d
    mov ecx, dword ptr [ebp - local_10]          # 004bc090
    mov ecx, dword ptr [ecx + field_18]          # 004bc093
    mov esi, dword ptr [ebp - local_c]           # 004bc096
    shl esi, 0x4                                 # 004bc099
    mov edx, dword ptr [edx + eax + field_2fc]   # 004bc09c
    sub edx, dword ptr [ecx + esi + field_2f4]   # 004bc0a3
    add edx, 0x1                                 # 004bc0aa
    mov eax, dword ptr [ebp - local_4]           # 004bc0ad
    mov dword ptr [eax + field_50], edx          # 004bc0b0
    mov ecx, dword ptr [ebp - local_10]          # 004bc0b3
    mov edx, dword ptr [ecx + field_18]          # 004bc0b6
    mov eax, dword ptr [ebp - local_c]           # 004bc0b9
    shl eax, 0x4                                 # 004bc0bc
    lea ecx, [edx + eax + field_2f4]             # 004bc0bf
    mov edx, dword ptr [ebp - local_4]           # 004bc0c6
    add edx, 0x40                                # 004bc0c9
    mov eax, dword ptr [ecx]                     # 004bc0cc
    mov dword ptr [edx], eax                     # 004bc0ce
    mov eax, dword ptr [ecx + field_4]           # 004bc0d0
    mov dword ptr [edx + field_4], eax           # 004bc0d3
    mov eax, dword ptr [ecx + field_8]           # 004bc0d6
    mov dword ptr [edx + field_8], eax           # 004bc0d9
    mov ecx, dword ptr [ecx + field_c]           # 004bc0dc
    mov dword ptr [edx + field_c], ecx           # 004bc0df
    mov edx, dword ptr [ebp - local_10]          # 004bc0e2
    mov eax, dword ptr [edx + field_18]          # 004bc0e5
    mov ecx, dword ptr [ebp - local_c]           # 004bc0e8
    imul ecx, ecx, 0x50                          # 004bc0eb
    lea esi, [eax + ecx + field_354]             # 004bc0ee
    mov edi, dword ptr [ebp - local_4]           # 004bc0f5
    add edi, 0x88                                # 004bc0f8
    mov ecx, 0x14                                # 004bc0fe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bc103
    mov edx, dword ptr [ebp - local_10]          # 004bc105
    mov eax, dword ptr [edx + field_18]          # 004bc108
    mov ecx, dword ptr [ebp - local_4]           # 004bc10b
    mov edx, dword ptr [eax + field_8d8]         # 004bc10e
    mov dword ptr [ecx + field_130], edx         # 004bc114
    mov eax, dword ptr [ebp - local_10]          # 004bc11a
    mov esi, dword ptr [eax + field_18]          # 004bc11d
    call FUN_0050cd50                            # 004bc120
    {load} mov edi, eax                          # 004bc125
    mov ecx, dword ptr [ebp - local_10]          # 004bc127
    mov edx, dword ptr [ecx + field_18]          # 004bc12a
    mov eax, dword ptr [ebp - local_10]          # 004bc12d
    mov ecx, dword ptr [eax + field_18]          # 004bc130
    fld dword ptr [edx + field_8e0]              # 004bc133
    fsub dword ptr [ecx + field_8dc]             # 004bc139
    call FUN_0050ce04                            # 004bc13f
    {load} mov ecx, eax                          # 004bc144
    {load} mov eax, edi                          # 004bc146
    cdq                                          # 004bc148
    idiv ecx                                     # 004bc149
    mov dword ptr [ebp - local_30], edx          # 004bc14b
    fild dword ptr [ebp - local_30]              # 004bc14e
    fstp dword ptr [ebp - local_34]              # 004bc151
    fld dword ptr [ebp - local_34]               # 004bc154
    fadd dword ptr [esi + field_8dc]             # 004bc157
    fstp qword ptr [ebp - local_3c]              # 004bc15d
    call FUN_0050cd50                            # 004bc160
    cdq                                          # 004bc165
    mov ecx, 0xa                                 # 004bc166
    idiv ecx                                     # 004bc16b
    mov dword ptr [ebp - local_40], edx          # 004bc16d
    fild dword ptr [ebp - local_40]              # 004bc170
    fstp dword ptr [ebp - local_44]              # 004bc173
    fld dword ptr [ebp - local_44]               # 004bc176
    fdiv qword ptr [0x52e208]                    # 004bc179
    fadd qword ptr [ebp - local_3c]              # 004bc17f
    mov edx, dword ptr [ebp - local_4]           # 004bc182
    fstp dword ptr [edx + field_134]             # 004bc185
L_004bc18b:
    # block 0x004bc18b: entered by jmp at 0x004bbe7b; jmp at 0x004bc003, 85 instruction(s), calls FUN_0050cd50, FUN_004bb3de, KERNEL32.dll!GetTickCount, ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004bc18b
    add eax, 0x40                                # 004bc18e
    mov ecx, dword ptr [ebp - local_4]           # 004bc191
    add ecx, 0x58                                # 004bc194
    mov edx, dword ptr [eax]                     # 004bc197
    mov dword ptr [ecx], edx                     # 004bc199
    mov edx, dword ptr [eax + field_4]           # 004bc19b
    mov dword ptr [ecx + field_4], edx           # 004bc19e
    mov edx, dword ptr [eax + field_8]           # 004bc1a1
    mov dword ptr [ecx + field_8], edx           # 004bc1a4
    mov eax, dword ptr [eax + field_c]           # 004bc1a7
    mov dword ptr [ecx + field_c], eax           # 004bc1aa
    mov ecx, dword ptr [ebp - local_4]           # 004bc1ad
    mov edx, dword ptr [ecx + field_58]          # 004bc1b0
    add edx, 0x1                                 # 004bc1b3
    mov eax, dword ptr [ebp - local_4]           # 004bc1b6
    mov dword ptr [eax + field_60], edx          # 004bc1b9
    call FUN_0050cd50                            # 004bc1bc
    mov ecx, dword ptr [ebp - local_10]          # 004bc1c1
    mov edx, dword ptr [ebp - local_4]           # 004bc1c4
    mov ecx, dword ptr [ecx + field_318]         # 004bc1c7
    sub ecx, dword ptr [edx + field_54]          # 004bc1cd
    cdq                                          # 004bc1d0
    idiv ecx                                     # 004bc1d1
    mov eax, dword ptr [ebp - local_10]          # 004bc1d3
    mov ecx, dword ptr [eax + field_17c]         # 004bc1d6
    {load} add ecx, edx                          # 004bc1dc
    mov edx, dword ptr [ebp - local_4]           # 004bc1de
    mov dword ptr [edx + field_6c], ecx          # 004bc1e1
    mov eax, dword ptr [ebp - local_4]           # 004bc1e4
    mov ecx, dword ptr [eax + field_6c]          # 004bc1e7
    mov edx, dword ptr [ebp - local_4]           # 004bc1ea
    mov eax, dword ptr [edx + field_54]          # 004bc1ed
    lea ecx, [ecx + eax - field_minus_1]         # 004bc1f0
    mov edx, dword ptr [ebp - local_4]           # 004bc1f4
    mov dword ptr [edx + field_74], ecx          # 004bc1f7
    mov eax, dword ptr [ebp - local_10]          # 004bc1fa
    mov ecx, dword ptr [eax + field_e0]          # 004bc1fd
    sub ecx, 0x1                                 # 004bc203
    mov edx, dword ptr [ebp - local_4]           # 004bc206
    mov dword ptr [edx + field_68], ecx          # 004bc209
    mov eax, dword ptr [ebp - local_4]           # 004bc20c
    mov ecx, dword ptr [ebp - local_10]          # 004bc20f
    mov edx, dword ptr [ecx + field_e0]          # 004bc212
    mov dword ptr [eax + field_70], edx          # 004bc218
    mov eax, dword ptr [ebp - local_4]           # 004bc21b
    fild dword ptr [eax + field_68]              # 004bc21e
    mov ecx, dword ptr [ebp - local_4]           # 004bc221
    fstp dword ptr [ecx + field_144]             # 004bc224
    mov edx, dword ptr [ebp - local_4]           # 004bc22a
    add edx, 0x68                                # 004bc22d
    mov eax, dword ptr [ebp - local_4]           # 004bc230
    add eax, 0x78                                # 004bc233
    mov ecx, dword ptr [edx]                     # 004bc236
    mov dword ptr [eax], ecx                     # 004bc238
    mov ecx, dword ptr [edx + field_4]           # 004bc23a
    mov dword ptr [eax + field_4], ecx           # 004bc23d
    mov ecx, dword ptr [edx + field_8]           # 004bc240
    mov dword ptr [eax + field_8], ecx           # 004bc243
    mov edx, dword ptr [edx + field_c]           # 004bc246
    mov dword ptr [eax + field_c], edx           # 004bc249
    mov eax, dword ptr [ebp - local_4]           # 004bc24c
    mov dword ptr [eax + field_128], 0x0         # 004bc24f
    mov ecx, dword ptr [ebp - local_4]           # 004bc259
    push ecx                                     # 004bc25c
    mov ecx, dword ptr [ebp - local_10]          # 004bc25d
    call FUN_004bb3de                            # 004bc260
    mov edx, dword ptr [ebp - local_4]           # 004bc265
    fild dword ptr [edx + field_130]             # 004bc268
    fstp dword ptr [ebp - local_48]              # 004bc26e
    mov eax, dword ptr [ebp - local_4]           # 004bc271
    fld dword ptr [eax + field_134]              # 004bc274
    fdiv dword ptr [ebp - local_48]              # 004bc27a
    mov ecx, dword ptr [ebp - local_4]           # 004bc27d
    fstp dword ptr [ecx + field_148]             # 004bc280
    mov edx, dword ptr [ebp - local_4]           # 004bc286
    mov dword ptr [edx + field_13c], 0x0         # 004bc289
    call dword ptr [0x52a23c]                    # 004bc293
    mov ecx, dword ptr [ebp - local_4]           # 004bc299
    mov dword ptr [ecx + field_140], eax         # 004bc29c
    pop edi                                      # 004bc2a2
    pop esi                                      # 004bc2a3
    {load} mov esp, ebp                          # 004bc2a4
    pop ebp                                      # 004bc2a6
    ret 0x4                                      # 004bc2a7

