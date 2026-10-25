# FUN_00450dd5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00450dd5
# extent:       0x00450dd5-0x004511d2 (1021 code bytes)
# span:         0x00450dd5-0x004511d2 (code 1021, tables 0, padding 0)
# sha256:       1a84274d1b416bb7f10dc091b49ecfa8d49c08d1664e29c7e6ed5b82c8459f44
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00450dd5
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_c, field_10, field_1c, field_4c, field_ac, field_168, field_170, field_184, field_2a0, field_6bf, field_6c3 and 3 more; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_48, field_58, field_a4, field_a8, field_164 and 7 more; [edx + n] field_4, field_8, field_14, field_44, field_50, field_58, field_b0, field_164, field_184, field_2a0, field_6b3, field_6b7 and 3 more
# callees:      calls FUN_0045445a, FUN_00453f4f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 280 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_184, 0x184  # offset +0x184
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_31c, 0x31c  # offset +0x31c
.equ field_320, 0x320  # offset +0x320
.equ field_6b3, 0x6b3  # offset +0x6b3
.equ field_6b7, 0x6b7  # offset +0x6b7
.equ field_6bb, 0x6bb  # offset +0x6bb
.equ field_6bf, 0x6bf  # offset +0x6bf
.equ field_6c3, 0x6c3  # offset +0x6c3
.equ field_6c7, 0x6c7  # offset +0x6c7
.equ field_6cb, 0x6cb  # offset +0x6cb
.equ field_6cf, 0x6cf  # offset +0x6cf

# --- external targets -----------------------------------------------
.set FUN_00453f4f, .text + (0x00453f4f - 0x401000)
.set FUN_0045445a, .text + (0x0045445a - 0x401000)

.org 0x00450dd5 - 0x401000
.globl FUN_00450dd5
FUN_00450dd5:
    # block 0x00450dd5: entry, 35 instruction(s), ends with jl to 0x00450e51 (forward)
    push ebp                                     # 00450dd5
    {load} mov ebp, esp                          # 00450dd6
    sub esp, 0x18                                # 00450dd8
    mov dword ptr [ebp - local_18], ecx          # 00450ddb
    mov eax, dword ptr [ebp + arg_c]             # 00450dde
    mov ecx, dword ptr [ebp - local_18]          # 00450de1
    mov edx, dword ptr [eax]                     # 00450de4
    sub edx, dword ptr [ecx + field_31c]         # 00450de6
    mov dword ptr [ebp - local_10], edx          # 00450dec
    mov eax, dword ptr [ebp + arg_c]             # 00450def
    mov ecx, dword ptr [ebp - local_18]          # 00450df2
    mov edx, dword ptr [eax + field_4]           # 00450df5
    sub edx, dword ptr [ecx + field_320]         # 00450df8
    mov dword ptr [ebp - local_c], edx           # 00450dfe
    mov ecx, dword ptr [ebp - local_18]          # 00450e01
    mov eax, dword ptr [ebp - local_10]          # 00450e04
    cdq                                          # 00450e07
    idiv dword ptr [ecx + field_a4]              # 00450e08
    mov dword ptr [ebp - local_14], eax          # 00450e0e
    mov ecx, dword ptr [ebp - local_18]          # 00450e11
    mov eax, dword ptr [ebp - local_c]           # 00450e14
    cdq                                          # 00450e17
    idiv dword ptr [ecx + field_a8]              # 00450e18
    mov dword ptr [ebp - local_8], eax           # 00450e1e
    mov edx, dword ptr [ebp - local_18]          # 00450e21
    mov eax, dword ptr [edx + field_b0]          # 00450e24
    mov ecx, dword ptr [ebp - local_18]          # 00450e2a
    mov edx, dword ptr [ebp - local_8]           # 00450e2d
    imul edx, dword ptr [ecx + 8*eax + field_2ac] # 00450e30
    add edx, dword ptr [ebp - local_14]          # 00450e38
    mov dword ptr [ebp - local_4], edx           # 00450e3b
    mov eax, dword ptr [ebp - local_18]          # 00450e3e
    mov ecx, dword ptr [ebp - local_4]           # 00450e41
    cmp ecx, dword ptr [eax + field_ac]          # 00450e44
    jl.d8 L_00450e51                             # 00450e4a
    # block 0x00450e4c: entered by fall-through of jl at 0x00450e4a, 1 instruction(s), ends with forward jump to 0x004511cc
    jmp.d32 L_004511cc                           # 00450e4c
L_00450e51:
    # block 0x00450e51: entered by jl at 0x00450e4a, 6 instruction(s), ends with je to 0x00450e6c (forward)
    mov edx, dword ptr [ebp - local_4]           # 00450e51
    imul edx, edx, 0x5c                          # 00450e54
    mov eax, dword ptr [ebp - local_18]          # 00450e57
    mov ecx, dword ptr [eax + field_2a0]         # 00450e5a
    cmp dword ptr [ecx + edx + field_58], 0x1    # 00450e60
    je.d8 L_00450e6c                             # 00450e65
    # block 0x00450e67: entered by fall-through of je at 0x00450e65, 1 instruction(s), ends with forward jump to 0x004511cc
    jmp.d32 L_004511cc                           # 00450e67
L_00450e6c:
    # block 0x00450e6c: entered by je at 0x00450e65, 50 instruction(s), ends with jne to 0x00450fc3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00450e6c
    imul edx, edx, 0x5c                          # 00450e6f
    mov eax, dword ptr [ebp - local_18]          # 00450e72
    mov ecx, dword ptr [eax + field_2a0]         # 00450e75
    mov eax, dword ptr [ebp - local_18]          # 00450e7b
    mov ecx, dword ptr [ecx + edx + field_10]    # 00450e7e
    mov dword ptr [eax + field_6c3], ecx         # 00450e82
    mov edx, dword ptr [ebp - local_18]          # 00450e88
    mov eax, dword ptr [ebp - local_18]          # 00450e8b
    mov ecx, dword ptr [eax + field_6c3]         # 00450e8e
    mov dword ptr [edx + field_6b3], ecx         # 00450e94
    mov edx, dword ptr [ebp - local_4]           # 00450e9a
    imul edx, edx, 0x5c                          # 00450e9d
    mov eax, dword ptr [ebp - local_18]          # 00450ea0
    mov ecx, dword ptr [eax + field_2a0]         # 00450ea3
    mov eax, dword ptr [ebp - local_18]          # 00450ea9
    mov ecx, dword ptr [ecx + edx + field_14]    # 00450eac
    mov dword ptr [eax + field_6bf], ecx         # 00450eb0
    mov edx, dword ptr [ebp - local_18]          # 00450eb6
    mov eax, dword ptr [ebp - local_18]          # 00450eb9
    mov ecx, dword ptr [eax + field_6bf]         # 00450ebc
    mov dword ptr [edx + field_6b7], ecx         # 00450ec2
    mov edx, dword ptr [ebp - local_4]           # 00450ec8
    imul edx, edx, 0x5c                          # 00450ecb
    mov eax, dword ptr [ebp - local_18]          # 00450ece
    mov ecx, dword ptr [eax + field_2a0]         # 00450ed1
    mov eax, dword ptr [ebp - local_18]          # 00450ed7
    mov ecx, dword ptr [ecx + edx + field_18]    # 00450eda
    mov dword ptr [eax + field_6cb], ecx         # 00450ede
    mov edx, dword ptr [ebp - local_18]          # 00450ee4
    mov eax, dword ptr [ebp - local_18]          # 00450ee7
    mov ecx, dword ptr [eax + field_6cb]         # 00450eea
    mov dword ptr [edx + field_6bb], ecx         # 00450ef0
    mov edx, dword ptr [ebp - local_4]           # 00450ef6
    imul edx, edx, 0x5c                          # 00450ef9
    mov eax, dword ptr [ebp - local_18]          # 00450efc
    mov ecx, dword ptr [eax + field_2a0]         # 00450eff
    mov eax, dword ptr [ebp - local_18]          # 00450f05
    mov ecx, dword ptr [ecx + edx + field_1c]    # 00450f08
    mov dword ptr [eax + field_6cf], ecx         # 00450f0c
    mov edx, dword ptr [ebp - local_18]          # 00450f12
    mov eax, dword ptr [ebp - local_18]          # 00450f15
    mov ecx, dword ptr [eax + field_6cf]         # 00450f18
    mov dword ptr [edx + field_6c7], ecx         # 00450f1e
    mov edx, dword ptr [ebp - local_4]           # 00450f24
    imul edx, edx, 0x5c                          # 00450f27
    mov eax, dword ptr [ebp - local_18]          # 00450f2a
    mov ecx, dword ptr [eax + field_2a0]         # 00450f2d
    cmp dword ptr [ecx + edx + field_48], -0x1   # 00450f33
    jne.d32 L_00450fc3                           # 00450f38
    # block 0x00450f3e: entered by fall-through of jne at 0x00450f38, 15 instruction(s), calls FUN_0045445a, ends with je to 0x00450fc3 (forward)
    mov edx, dword ptr [ebp - local_18]          # 00450f3e
    add edx, 0x6bb                               # 00450f41
    push edx                                     # 00450f47
    mov eax, dword ptr [ebp - local_18]          # 00450f48
    add eax, 0x6b3                               # 00450f4b
    push eax                                     # 00450f50
    mov ecx, dword ptr [ebp + arg_c]             # 00450f51
    push ecx                                     # 00450f54
    mov edx, dword ptr [ebp - local_18]          # 00450f55
    add edx, 0x148                               # 00450f58
    push edx                                     # 00450f5e
    mov ecx, dword ptr [ebp - local_18]          # 00450f5f
    call FUN_0045445a                            # 00450f62
    test eax, eax                                # 00450f67
    je.d8 L_00450fc3                             # 00450f69
    # block 0x00450f6b: entered by fall-through of je at 0x00450f69, 23 instruction(s), ends with forward jump to 0x00451191
    mov eax, dword ptr [ebp - local_4]           # 00450f6b
    imul eax, eax, 0x5c                          # 00450f6e
    mov ecx, dword ptr [ebp - local_18]          # 00450f71
    mov edx, dword ptr [ecx + field_2a0]         # 00450f74
    mov ecx, dword ptr [ebp + arg_8]             # 00450f7a
    mov edx, dword ptr [edx + eax + field_14]    # 00450f7d
    mov dword ptr [ecx + field_c], edx           # 00450f81
    mov eax, dword ptr [ebp + arg_8]             # 00450f84
    mov ecx, dword ptr [ebp - local_18]          # 00450f87
    mov edx, dword ptr [eax + field_c]           # 00450f8a
    sub edx, dword ptr [ecx + field_168]         # 00450f8d
    add edx, 0x1                                 # 00450f93
    mov eax, dword ptr [ebp + arg_8]             # 00450f96
    mov dword ptr [eax + field_4], edx           # 00450f99
    mov ecx, dword ptr [ebp + arg_8]             # 00450f9c
    mov edx, dword ptr [ecx + field_4]           # 00450f9f
    mov eax, dword ptr [ebp - local_18]          # 00450fa2
    add edx, dword ptr [eax + field_170]         # 00450fa5
    mov ecx, dword ptr [ebp + arg_c]             # 00450fab
    mov dword ptr [ecx + field_4], edx           # 00450fae
    mov edx, dword ptr [ebp - local_18]          # 00450fb1
    mov dword ptr [edx + field_184], 0x8         # 00450fb4
    jmp.d32 L_00451191                           # 00450fbe
L_00450fc3:
    # block 0x00450fc3: entered by jne at 0x00450f38; je at 0x00450f69, 6 instruction(s), ends with jne to 0x00451062 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00450fc3
    imul eax, eax, 0x5c                          # 00450fc6
    mov ecx, dword ptr [ebp - local_18]          # 00450fc9
    mov edx, dword ptr [ecx + field_2a0]         # 00450fcc
    cmp dword ptr [edx + eax + field_50], -0x1   # 00450fd2
    jne.d32 L_00451062                           # 00450fd7
    # block 0x00450fdd: entered by fall-through of jne at 0x00450fd7, 15 instruction(s), calls FUN_0045445a, ends with je to 0x00451062 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00450fdd
    add eax, 0x6cb                               # 00450fe0
    push eax                                     # 00450fe5
    mov ecx, dword ptr [ebp - local_18]          # 00450fe6
    add ecx, 0x6c3                               # 00450fe9
    push ecx                                     # 00450fef
    mov edx, dword ptr [ebp + arg_c]             # 00450ff0
    push edx                                     # 00450ff3
    mov eax, dword ptr [ebp - local_18]          # 00450ff4
    add eax, 0x148                               # 00450ff7
    push eax                                     # 00450ffc
    mov ecx, dword ptr [ebp - local_18]          # 00450ffd
    call FUN_0045445a                            # 00451000
    test eax, eax                                # 00451005
    je.d8 L_00451062                             # 00451007
    # block 0x00451009: entered by fall-through of je at 0x00451007, 23 instruction(s), ends with forward jump to 0x00451191
    mov ecx, dword ptr [ebp - local_4]           # 00451009
    imul ecx, ecx, 0x5c                          # 0045100c
    mov edx, dword ptr [ebp - local_18]          # 0045100f
    mov eax, dword ptr [edx + field_2a0]         # 00451012
    mov edx, dword ptr [ebp + arg_8]             # 00451018
    mov eax, dword ptr [eax + ecx + field_1c]    # 0045101b
    mov dword ptr [edx + field_4], eax           # 0045101f
    mov ecx, dword ptr [ebp + arg_8]             # 00451022
    mov edx, dword ptr [ecx + field_4]           # 00451025
    mov eax, dword ptr [ebp - local_18]          # 00451028
    mov ecx, dword ptr [eax + field_168]         # 0045102b
    lea edx, [edx + ecx - field_minus_1]         # 00451031
    mov eax, dword ptr [ebp + arg_8]             # 00451035
    mov dword ptr [eax + field_c], edx           # 00451038
    mov ecx, dword ptr [ebp + arg_8]             # 0045103b
    mov edx, dword ptr [ecx + field_4]           # 0045103e
    mov eax, dword ptr [ebp - local_18]          # 00451041
    add edx, dword ptr [eax + field_170]         # 00451044
    mov ecx, dword ptr [ebp + arg_c]             # 0045104a
    mov dword ptr [ecx + field_4], edx           # 0045104d
    mov edx, dword ptr [ebp - local_18]          # 00451050
    mov dword ptr [edx + field_184], 0xa         # 00451053
    jmp.d32 L_00451191                           # 0045105d
L_00451062:
    # block 0x00451062: entered by jne at 0x00450fd7; je at 0x00451007, 6 instruction(s), ends with jne to 0x004510fd (forward)
    mov eax, dword ptr [ebp - local_4]           # 00451062
    imul eax, eax, 0x5c                          # 00451065
    mov ecx, dword ptr [ebp - local_18]          # 00451068
    mov edx, dword ptr [ecx + field_2a0]         # 0045106b
    cmp dword ptr [edx + eax + field_44], -0x1   # 00451071
    jne.d32 L_004510fd                           # 00451076
    # block 0x0045107c: entered by fall-through of jne at 0x00451076, 15 instruction(s), calls FUN_0045445a, ends with je to 0x004510fd (forward)
    mov eax, dword ptr [ebp - local_18]          # 0045107c
    add eax, 0x6c3                               # 0045107f
    push eax                                     # 00451084
    mov ecx, dword ptr [ebp - local_18]          # 00451085
    add ecx, 0x6b3                               # 00451088
    push ecx                                     # 0045108e
    mov edx, dword ptr [ebp + arg_c]             # 0045108f
    push edx                                     # 00451092
    mov eax, dword ptr [ebp - local_18]          # 00451093
    add eax, 0x148                               # 00451096
    push eax                                     # 0045109b
    mov ecx, dword ptr [ebp - local_18]          # 0045109c
    call FUN_0045445a                            # 0045109f
    test eax, eax                                # 004510a4
    je.d8 L_004510fd                             # 004510a6
    # block 0x004510a8: entered by fall-through of je at 0x004510a6, 23 instruction(s), ends with forward jump to 0x00451191
    mov ecx, dword ptr [ebp - local_4]           # 004510a8
    imul ecx, ecx, 0x5c                          # 004510ab
    mov edx, dword ptr [ebp - local_18]          # 004510ae
    mov eax, dword ptr [edx + field_2a0]         # 004510b1
    mov edx, dword ptr [ebp + arg_8]             # 004510b7
    mov eax, dword ptr [eax + ecx + field_10]    # 004510ba
    mov dword ptr [edx + field_8], eax           # 004510be
    mov ecx, dword ptr [ebp + arg_8]             # 004510c1
    mov edx, dword ptr [ebp - local_18]          # 004510c4
    mov eax, dword ptr [ecx + field_8]           # 004510c7
    sub eax, dword ptr [edx + field_164]         # 004510ca
    add eax, 0x1                                 # 004510d0
    mov ecx, dword ptr [ebp + arg_8]             # 004510d3
    mov dword ptr [ecx], eax                     # 004510d6
    mov edx, dword ptr [ebp + arg_8]             # 004510d8
    mov eax, dword ptr [edx]                     # 004510db
    mov ecx, dword ptr [ebp - local_18]          # 004510dd
    add eax, dword ptr [ecx + field_16c]         # 004510e0
    mov edx, dword ptr [ebp + arg_c]             # 004510e6
    mov dword ptr [edx], eax                     # 004510e9
    mov eax, dword ptr [ebp - local_18]          # 004510eb
    mov dword ptr [eax + field_184], 0x7         # 004510ee
    jmp.d32 L_00451191                           # 004510f8
L_004510fd:
    # block 0x004510fd: entered by jne at 0x00451076; je at 0x004510a6, 6 instruction(s), ends with jne to 0x00451191 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004510fd
    imul ecx, ecx, 0x5c                          # 00451100
    mov edx, dword ptr [ebp - local_18]          # 00451103
    mov eax, dword ptr [edx + field_2a0]         # 00451106
    cmp dword ptr [eax + ecx + field_4c], -0x1   # 0045110c
    jne.d8 L_00451191                            # 00451111
    # block 0x00451113: entered by fall-through of jne at 0x00451111, 15 instruction(s), calls FUN_0045445a, ends with je to 0x00451191 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00451113
    add ecx, 0x6cb                               # 00451116
    push ecx                                     # 0045111c
    mov edx, dword ptr [ebp - local_18]          # 0045111d
    add edx, 0x6bb                               # 00451120
    push edx                                     # 00451126
    mov eax, dword ptr [ebp + arg_c]             # 00451127
    push eax                                     # 0045112a
    mov ecx, dword ptr [ebp - local_18]          # 0045112b
    add ecx, 0x148                               # 0045112e
    push ecx                                     # 00451134
    mov ecx, dword ptr [ebp - local_18]          # 00451135
    call FUN_0045445a                            # 00451138
    test eax, eax                                # 0045113d
    je.d8 L_00451191                             # 0045113f
    # block 0x00451141: entered by fall-through of je at 0x0045113f, 22 instruction(s), falls into the block at 0x00451191
    mov edx, dword ptr [ebp - local_4]           # 00451141
    imul edx, edx, 0x5c                          # 00451144
    mov eax, dword ptr [ebp - local_18]          # 00451147
    mov ecx, dword ptr [eax + field_2a0]         # 0045114a
    mov eax, dword ptr [ebp + arg_8]             # 00451150
    mov ecx, dword ptr [ecx + edx + field_18]    # 00451153
    mov dword ptr [eax], ecx                     # 00451157
    mov edx, dword ptr [ebp + arg_8]             # 00451159
    mov eax, dword ptr [edx]                     # 0045115c
    mov ecx, dword ptr [ebp - local_18]          # 0045115e
    mov edx, dword ptr [ecx + field_164]         # 00451161
    lea eax, [eax + edx - field_minus_1]         # 00451167
    mov ecx, dword ptr [ebp + arg_8]             # 0045116b
    mov dword ptr [ecx + field_8], eax           # 0045116e
    mov edx, dword ptr [ebp + arg_8]             # 00451171
    mov eax, dword ptr [edx]                     # 00451174
    mov ecx, dword ptr [ebp - local_18]          # 00451176
    add eax, dword ptr [ecx + field_16c]         # 00451179
    mov edx, dword ptr [ebp + arg_c]             # 0045117f
    mov dword ptr [edx], eax                     # 00451182
    mov eax, dword ptr [ebp - local_18]          # 00451184
    mov dword ptr [eax + field_184], 0x9         # 00451187
L_00451191:
    # block 0x00451191: entered by jmp at 0x00450fbe; jmp at 0x0045105d; jmp at 0x004510f8; jne at 0x00451111; more, 3 instruction(s), ends with jne to 0x004511aa (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00451191
    cmp dword ptr [ecx + field_184], -0x2        # 00451194
    jne.d8 L_004511aa                            # 0045119b
    # block 0x0045119d: entered by fall-through of jne at 0x0045119b, 2 instruction(s), falls into the block at 0x004511aa
    mov edx, dword ptr [ebp - local_18]          # 0045119d
    mov dword ptr [edx + field_184], 0xf         # 004511a0
L_004511aa:
    # block 0x004511aa: entered by jne at 0x0045119b, 6 instruction(s), ends with jne to 0x004511cc (forward)
    mov eax, dword ptr [ebp - local_4]           # 004511aa
    imul eax, eax, 0x5c                          # 004511ad
    mov ecx, dword ptr [ebp - local_18]          # 004511b0
    mov edx, dword ptr [ecx + field_2a0]         # 004511b3
    cmp dword ptr [edx + eax + field_58], 0x1    # 004511b9
    jne.d8 L_004511cc                            # 004511be
    # block 0x004511c0: entered by fall-through of jne at 0x004511be, 4 instruction(s), calls FUN_00453f4f, falls into the block at 0x004511cc
    mov eax, dword ptr [ebp - local_4]           # 004511c0
    push eax                                     # 004511c3
    mov ecx, dword ptr [ebp - local_18]          # 004511c4
    call FUN_00453f4f                            # 004511c7
L_004511cc:
    # block 0x004511cc: entered by jmp at 0x00450e4c; jmp at 0x00450e67; jne at 0x004511be, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004511cc
    pop ebp                                      # 004511ce
    ret 0x8                                      # 004511cf

