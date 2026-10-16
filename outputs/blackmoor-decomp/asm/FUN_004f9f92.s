# FUN_004f9f92
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9f92
# extent:       0x004f9f92-0x004fa127 (405 code bytes)
# span:         0x004f9f92-0x004fa127 (code 405, tables 0, padding 0)
# sha256:       ce4f4941704f220ad3d0fc2b66d6ff703e14d0357a8d35f0069183f14090339b
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f9f92
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       21 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_24, local_28, local_30, local_34, local_3c and 9 more
# fields:       [eax + n] field_14, field_1c, field_24, field_2a3, field_2a7; [ecx + n] field_14, field_24, field_162, field_2a7, field_2ab, field_3ce; [edx + n] field_14, field_18, field_1c, field_20, field_28, field_2a3, field_2ab
# callees:      calls FUN_004f709c, FUN_0050ce04, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 120 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_6c, 0x6c  # offset -0x6c
.equ arg_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_162, 0x162  # offset +0x162
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004f9f92 - 0x401000
.globl FUN_004f9f92
FUN_004f9f92:
    # block 0x004f9f92: entry, 17 instruction(s), calls FUN_004f709c, ends with je to 0x004f9fd5 (forward)
    push ebp                                     # 004f9f92
    {load} mov ebp, esp                          # 004f9f93
    sub esp, 0x6c                                # 004f9f95
    mov dword ptr [ebp - local_18], ecx          # 004f9f98
    mov eax, dword ptr [ebp + arg_8]             # 004f9f9b
    imul eax, eax, 0x5bb                         # 004f9f9e
    mov ecx, dword ptr [ebp - local_18]          # 004f9fa4
    mov edx, dword ptr [ecx + field_3ce]         # 004f9fa7
    {load} add edx, eax                          # 004f9fad
    mov dword ptr [ebp - local_14], edx          # 004f9faf
    mov eax, dword ptr [ebp - local_14]          # 004f9fb2
    add eax, 0x19e                               # 004f9fb5
    mov dword ptr [ebp - local_4], eax           # 004f9fba
    mov ecx, dword ptr [ebp - local_18]          # 004f9fbd
    call FUN_004f709c                            # 004f9fc0
    test eax, eax                                # 004f9fc5
    je.d8 L_004f9fd5                             # 004f9fc7
    # block 0x004f9fc9: entered by fall-through of je at 0x004f9fc7, 3 instruction(s), ends with jne to 0x004f9fda (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004f9fc9
    cmp dword ptr [ecx + field_162], 0x0         # 004f9fcc
    jne.d8 L_004f9fda                            # 004f9fd3
L_004f9fd5:
    # block 0x004f9fd5: entered by je at 0x004f9fc7; fall-through of jne at 0x004f9fd3, 1 instruction(s), ends with forward jump to 0x004fa121
    jmp.d32 L_004fa121                           # 004f9fd5
L_004f9fda:
    # block 0x004f9fda: entered by jne at 0x004f9fd3, 35 instruction(s), calls FUN_0050ce04, ends with je to 0x004fa084 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f9fda
    mov eax, dword ptr [ebp - local_4]           # 004f9fdd
    mov ecx, dword ptr [edx + field_18]          # 004f9fe0
    sub ecx, dword ptr [eax + field_14]          # 004f9fe3
    mov dword ptr [ebp - local_1c], ecx          # 004f9fe6
    fild dword ptr [ebp - local_1c]              # 004f9fe9
    fstp qword ptr [ebp - local_24]              # 004f9fec
    fld qword ptr [ebp - local_24]               # 004f9fef
    fmul qword ptr [0x52c680]                    # 004f9ff2
    call FUN_0050ce04                            # 004f9ff8
    mov dword ptr [ebp - local_10], eax          # 004f9ffd
    mov edx, dword ptr [ebp - local_4]           # 004fa000
    mov eax, dword ptr [ebp - local_4]           # 004fa003
    mov ecx, dword ptr [edx + field_20]          # 004fa006
    sub ecx, dword ptr [eax + field_1c]          # 004fa009
    mov dword ptr [ebp - local_28], ecx          # 004fa00c
    fild dword ptr [ebp - local_28]              # 004fa00f
    fstp qword ptr [ebp - local_30]              # 004fa012
    fld qword ptr [ebp - local_30]               # 004fa015
    fmul qword ptr [0x52c680]                    # 004fa018
    call FUN_0050ce04                            # 004fa01e
    mov dword ptr [ebp - local_c], eax           # 004fa023
    mov edx, dword ptr [ebp - local_4]           # 004fa026
    mov eax, dword ptr [ebp - local_4]           # 004fa029
    mov ecx, dword ptr [edx + field_28]          # 004fa02c
    sub ecx, dword ptr [eax + field_24]          # 004fa02f
    mov dword ptr [ebp - local_34], ecx          # 004fa032
    fild dword ptr [ebp - local_34]              # 004fa035
    fstp qword ptr [ebp - local_3c]              # 004fa038
    fld qword ptr [ebp - local_3c]               # 004fa03b
    fmul qword ptr [0x52c680]                    # 004fa03e
    call FUN_0050ce04                            # 004fa044
    mov dword ptr [ebp - local_8], eax           # 004fa049
    cmp dword ptr [ebp - local_10], 0x0          # 004fa04c
    je.d8 L_004fa084                             # 004fa050
    # block 0x004fa052: entered by fall-through of je at 0x004fa050, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa093
    call FUN_0050cd50                            # 004fa052
    cdq                                          # 004fa057
    idiv dword ptr [ebp - local_10]              # 004fa058
    mov dword ptr [ebp - local_40], edx          # 004fa05b
    fild dword ptr [ebp - local_40]              # 004fa05e
    fstp dword ptr [ebp - local_44]              # 004fa061
    fld dword ptr [ebp - local_44]               # 004fa064
    fdiv qword ptr [0x52c680]                    # 004fa067
    mov edx, dword ptr [ebp - local_4]           # 004fa06d
    fild dword ptr [edx + field_14]              # 004fa070
    fstp qword ptr [ebp - local_4c]              # 004fa073
    fadd qword ptr [ebp - local_4c]              # 004fa076
    mov eax, dword ptr [ebp - local_14]          # 004fa079
    fstp dword ptr [eax + field_2a3]             # 004fa07c
    jmp.d8 L_004fa093                            # 004fa082
L_004fa084:
    # block 0x004fa084: entered by je at 0x004fa050, 4 instruction(s), falls into the block at 0x004fa093
    mov ecx, dword ptr [ebp - local_4]           # 004fa084
    fild dword ptr [ecx + field_14]              # 004fa087
    mov edx, dword ptr [ebp - local_14]          # 004fa08a
    fstp dword ptr [edx + field_2a3]             # 004fa08d
L_004fa093:
    # block 0x004fa093: entered by jmp at 0x004fa082, 2 instruction(s), ends with je to 0x004fa0cb (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004fa093
    je.d8 L_004fa0cb                             # 004fa097
    # block 0x004fa099: entered by fall-through of je at 0x004fa097, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa0da
    call FUN_0050cd50                            # 004fa099
    cdq                                          # 004fa09e
    idiv dword ptr [ebp - local_c]               # 004fa09f
    mov dword ptr [ebp - local_50], edx          # 004fa0a2
    fild dword ptr [ebp - local_50]              # 004fa0a5
    fstp dword ptr [ebp - local_54]              # 004fa0a8
    fld dword ptr [ebp - local_54]               # 004fa0ab
    fdiv qword ptr [0x52c680]                    # 004fa0ae
    mov eax, dword ptr [ebp - local_4]           # 004fa0b4
    fild dword ptr [eax + field_1c]              # 004fa0b7
    fstp qword ptr [ebp - local_5c]              # 004fa0ba
    fadd qword ptr [ebp - local_5c]              # 004fa0bd
    mov ecx, dword ptr [ebp - local_14]          # 004fa0c0
    fstp dword ptr [ecx + field_2a7]             # 004fa0c3
    jmp.d8 L_004fa0da                            # 004fa0c9
L_004fa0cb:
    # block 0x004fa0cb: entered by je at 0x004fa097, 4 instruction(s), falls into the block at 0x004fa0da
    mov edx, dword ptr [ebp - local_4]           # 004fa0cb
    fild dword ptr [edx + field_1c]              # 004fa0ce
    mov eax, dword ptr [ebp - local_14]          # 004fa0d1
    fstp dword ptr [eax + field_2a7]             # 004fa0d4
L_004fa0da:
    # block 0x004fa0da: entered by jmp at 0x004fa0c9, 2 instruction(s), ends with je to 0x004fa112 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004fa0da
    je.d8 L_004fa112                             # 004fa0de
    # block 0x004fa0e0: entered by fall-through of je at 0x004fa0de, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa121
    call FUN_0050cd50                            # 004fa0e0
    cdq                                          # 004fa0e5
    idiv dword ptr [ebp - local_8]               # 004fa0e6
    mov dword ptr [ebp - local_60], edx          # 004fa0e9
    fild dword ptr [ebp - local_60]              # 004fa0ec
    fstp dword ptr [ebp - local_64]              # 004fa0ef
    fld dword ptr [ebp - local_64]               # 004fa0f2
    fdiv qword ptr [0x52c680]                    # 004fa0f5
    mov ecx, dword ptr [ebp - local_4]           # 004fa0fb
    fild dword ptr [ecx + field_24]              # 004fa0fe
    fstp qword ptr [ebp - local_6c]              # 004fa101
    fadd qword ptr [ebp - local_6c]              # 004fa104
    mov edx, dword ptr [ebp - local_14]          # 004fa107
    fstp dword ptr [edx + field_2ab]             # 004fa10a
    jmp.d8 L_004fa121                            # 004fa110
L_004fa112:
    # block 0x004fa112: entered by je at 0x004fa0de, 4 instruction(s), falls into the block at 0x004fa121
    mov eax, dword ptr [ebp - local_4]           # 004fa112
    fild dword ptr [eax + field_24]              # 004fa115
    mov ecx, dword ptr [ebp - local_14]          # 004fa118
    fstp dword ptr [ecx + field_2ab]             # 004fa11b
L_004fa121:
    # block 0x004fa121: entered by jmp at 0x004f9fd5; jmp at 0x004fa110, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004fa121
    pop ebp                                      # 004fa123
    ret 0x4                                      # 004fa124

