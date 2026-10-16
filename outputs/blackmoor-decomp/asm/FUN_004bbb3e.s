# FUN_004bbb3e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bbb3e
# extent:       0x004bbb3e-0x004bbe46 (776 code bytes)
# span:         0x004bbb3e-0x004bbe46 (code 776, tables 0, padding 0)
# sha256:       af741fd4f360c6def6495f6eb99602c91d6ea7d86e614bd6c0497f19f6ef652f
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bbb3e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_40, field_4c, field_58, field_68, field_6c, field_70, field_74, field_d8, field_e0 and 5 more; [ecx + n] field_4, field_8, field_c, field_38, field_50, field_58, field_60, field_68, field_70, field_78, field_7c, field_80 and 6 more; [edx + n] field_4, field_8, field_c, field_3c, field_4c, field_60, field_68, field_70, field_d8, field_e0, field_12c, field_13c and 2 more
# callees:      calls KERNEL32.dll!GetTickCount, FUN_0050ce04, FUN_004bb3de
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 227 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_d8, 0xd8  # offset +0xd8
.equ field_e0, 0xe0  # offset +0xe0
.equ field_128, 0x128  # offset +0x128
.equ field_12c, 0x12c  # offset +0x12c
.equ field_13c, 0x13c  # offset +0x13c
.equ field_140, 0x140  # offset +0x140
.equ field_144, 0x144  # offset +0x144
.equ field_148, 0x148  # offset +0x148
.equ field_150, 0x150  # offset +0x150
.equ field_2d8, 0x2d8  # offset +0x2d8

# --- external targets -----------------------------------------------
.set FUN_004bb3de, .text + (0x004bb3de - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004bbb3e - 0x401000
.globl FUN_004bbb3e
FUN_004bbb3e:
    # block 0x004bbb3e: entry, 7 instruction(s), ends with jne to 0x004bbb62 (forward)
    push ebp                                     # 004bbb3e
    {load} mov ebp, esp                          # 004bbb3f
    sub esp, 0x18                                # 004bbb41
    mov dword ptr [ebp - local_c], ecx           # 004bbb44
    mov eax, dword ptr [ebp - local_c]           # 004bbb47
    cmp dword ptr [eax + field_40], 0x0          # 004bbb4a
    jne.d8 L_004bbb62                            # 004bbb4e
    # block 0x004bbb50: entered by fall-through of jne at 0x004bbb4e, 3 instruction(s), ends with jne to 0x004bbb62 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004bbb50
    cmp dword ptr [ecx + field_38], 0x0          # 004bbb53
    jne.d8 L_004bbb62                            # 004bbb57
    # block 0x004bbb59: entered by fall-through of jne at 0x004bbb57, 3 instruction(s), ends with je to 0x004bbb67 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004bbb59
    cmp dword ptr [edx + field_3c], 0x0          # 004bbb5c
    je.d8 L_004bbb67                             # 004bbb60
L_004bbb62:
    # block 0x004bbb62: entered by jne at 0x004bbb4e; jne at 0x004bbb57; fall-through of je at 0x004bbb60, 1 instruction(s), ends with forward jump to 0x004bbe42
    jmp.d32 L_004bbe42                           # 004bbb62
L_004bbb67:
    # block 0x004bbb67: entered by je at 0x004bbb60, 6 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004bbe42 (forward)
    call dword ptr [0x52a23c]                    # 004bbb67
    mov ecx, dword ptr [ebp - local_c]           # 004bbb6d
    mov dword ptr [ecx + field_2d8], eax         # 004bbb70
    mov edx, dword ptr [ebp - local_c]           # 004bbb76
    cmp dword ptr [edx + field_4c], 0x0          # 004bbb79
    je.d32 L_004bbe42                            # 004bbb7d
    # block 0x004bbb83: entered by fall-through of je at 0x004bbb7d, 3 instruction(s), falls into the block at 0x004bbb8c
    mov eax, dword ptr [ebp - local_c]           # 004bbb83
    mov ecx, dword ptr [eax + field_4c]          # 004bbb86
    mov dword ptr [ebp - local_8], ecx           # 004bbb89
L_004bbb8c:
    # block 0x004bbb8c: entered by jmp at 0x004bbe3d, 2 instruction(s), ends with je to 0x004bbe42 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004bbb8c
    je.d32 L_004bbe42                            # 004bbb90
    # block 0x004bbb96: entered by fall-through of je at 0x004bbb90, 49 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004bbc58
    mov edx, dword ptr [ebp - local_c]           # 004bbb96
    mov eax, dword ptr [ebp - local_8]           # 004bbb99
    mov ecx, dword ptr [edx + field_2d8]         # 004bbb9c
    sub ecx, dword ptr [eax + field_140]         # 004bbba2
    mov edx, dword ptr [ebp - local_8]           # 004bbba8
    mov dword ptr [edx + field_13c], ecx         # 004bbbab
    mov eax, dword ptr [ebp - local_8]           # 004bbbb1
    mov ecx, dword ptr [ebp - local_c]           # 004bbbb4
    mov edx, dword ptr [ecx + field_2d8]         # 004bbbb7
    mov dword ptr [eax + field_140], edx         # 004bbbbd
    mov eax, dword ptr [ebp - local_8]           # 004bbbc3
    add eax, 0x68                                # 004bbbc6
    mov ecx, dword ptr [ebp - local_8]           # 004bbbc9
    add ecx, 0x78                                # 004bbbcc
    mov edx, dword ptr [eax]                     # 004bbbcf
    mov dword ptr [ecx], edx                     # 004bbbd1
    mov edx, dword ptr [eax + field_4]           # 004bbbd3
    mov dword ptr [ecx + field_4], edx           # 004bbbd6
    mov edx, dword ptr [eax + field_8]           # 004bbbd9
    mov dword ptr [ecx + field_8], edx           # 004bbbdc
    mov eax, dword ptr [eax + field_c]           # 004bbbdf
    mov dword ptr [ecx + field_c], eax           # 004bbbe2
    mov ecx, dword ptr [ebp - local_8]           # 004bbbe5
    mov edx, dword ptr [ecx + field_13c]         # 004bbbe8
    mov dword ptr [ebp - local_14], edx          # 004bbbee
    mov dword ptr [ebp - local_10], 0x0          # 004bbbf1
    fild qword ptr [ebp - local_14]              # 004bbbf8
    fstp dword ptr [ebp - local_18]              # 004bbbfb
    mov eax, dword ptr [ebp - local_8]           # 004bbbfe
    fld dword ptr [ebp - local_18]               # 004bbc01
    fmul dword ptr [eax + field_148]             # 004bbc04
    mov ecx, dword ptr [ebp - local_8]           # 004bbc0a
    fsubr dword ptr [ecx + field_144]            # 004bbc0d
    mov edx, dword ptr [ebp - local_8]           # 004bbc13
    fstp dword ptr [edx + field_144]             # 004bbc16
    mov eax, dword ptr [ebp - local_8]           # 004bbc1c
    fld dword ptr [eax + field_144]              # 004bbc1f
    call FUN_0050ce04                            # 004bbc25
    mov ecx, dword ptr [ebp - local_8]           # 004bbc2a
    mov dword ptr [ecx + field_68], eax          # 004bbc2d
    mov edx, dword ptr [ebp - local_8]           # 004bbc30
    mov eax, dword ptr [edx + field_68]          # 004bbc33
    mov ecx, dword ptr [ebp - local_8]           # 004bbc36
    mov edx, dword ptr [ecx + field_50]          # 004bbc39
    lea eax, [eax + edx - field_minus_1]         # 004bbc3c
    mov ecx, dword ptr [ebp - local_8]           # 004bbc40
    mov dword ptr [ecx + field_70], eax          # 004bbc43
    mov dword ptr [ebp - local_4], 0x0           # 004bbc46
    jmp.d8 L_004bbc58                            # 004bbc4d
L_004bbc4f:
    # block 0x004bbc4f: entered by jmp at 0x004bbc72, 3 instruction(s), falls into the block at 0x004bbc58
    mov edx, dword ptr [ebp - local_4]           # 004bbc4f
    add edx, 0x1                                 # 004bbc52
    mov dword ptr [ebp - local_4], edx           # 004bbc55
L_004bbc58:
    # block 0x004bbc58: entered by jmp at 0x004bbc4d, 2 instruction(s), ends with jge to 0x004bbc74 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 004bbc58
    jge.d8 L_004bbc74                            # 004bbc5c
    # block 0x004bbc5e: entered by fall-through of jge at 0x004bbc5c, 5 instruction(s), ends with backward jump to 0x004bbc4f
    mov eax, dword ptr [ebp - local_4]           # 004bbc5e
    imul eax, eax, 0x14                          # 004bbc61
    mov ecx, dword ptr [ebp - local_8]           # 004bbc64
    mov dword ptr [ecx + eax + field_d8], 0x0    # 004bbc67
    jmp.d8 L_004bbc4f                            # 004bbc72
L_004bbc74:
    # block 0x004bbc74: entered by jge at 0x004bbc5c, 5 instruction(s), ends with jg to 0x004bbc97 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bbc74
    mov eax, dword ptr [ebp - local_c]           # 004bbc77
    mov ecx, dword ptr [edx + field_70]          # 004bbc7a
    cmp ecx, dword ptr [eax + field_d8]          # 004bbc7d
    jg.d8 L_004bbc97                             # 004bbc83
    # block 0x004bbc85: entered by fall-through of jg at 0x004bbc83, 3 instruction(s), ends with forward jump to 0x004bbde6
    mov edx, dword ptr [ebp - local_8]           # 004bbc85
    mov dword ptr [edx + field_12c], 0x1         # 004bbc88
    jmp.d32 L_004bbde6                           # 004bbc92
L_004bbc97:
    # block 0x004bbc97: entered by jg at 0x004bbc83, 5 instruction(s), ends with jge to 0x004bbd18 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbc97
    mov ecx, dword ptr [ebp - local_c]           # 004bbc9a
    mov edx, dword ptr [eax + field_68]          # 004bbc9d
    cmp edx, dword ptr [ecx + field_d8]          # 004bbca0
    jge.d8 L_004bbd18                            # 004bbca6
    # block 0x004bbca8: entered by fall-through of jge at 0x004bbca6, 5 instruction(s), ends with jle to 0x004bbd18 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbca8
    mov ecx, dword ptr [ebp - local_c]           # 004bbcab
    mov edx, dword ptr [eax + field_70]          # 004bbcae
    cmp edx, dword ptr [ecx + field_d8]          # 004bbcb1
    jle.d8 L_004bbd18                            # 004bbcb7
    # block 0x004bbcb9: entered by fall-through of jle at 0x004bbcb7, 30 instruction(s), calls FUN_004bb3de, ends with forward jump to 0x004bbde6
    mov eax, dword ptr [ebp - local_8]           # 004bbcb9
    add eax, 0x40                                # 004bbcbc
    mov ecx, dword ptr [ebp - local_8]           # 004bbcbf
    add ecx, 0x58                                # 004bbcc2
    mov edx, dword ptr [eax]                     # 004bbcc5
    mov dword ptr [ecx], edx                     # 004bbcc7
    mov edx, dword ptr [eax + field_4]           # 004bbcc9
    mov dword ptr [ecx + field_4], edx           # 004bbccc
    mov edx, dword ptr [eax + field_8]           # 004bbccf
    mov dword ptr [ecx + field_8], edx           # 004bbcd2
    mov eax, dword ptr [eax + field_c]           # 004bbcd5
    mov dword ptr [ecx + field_c], eax           # 004bbcd8
    mov ecx, dword ptr [ebp - local_c]           # 004bbcdb
    mov edx, dword ptr [ebp - local_8]           # 004bbcde
    mov eax, dword ptr [ecx + field_d8]          # 004bbce1
    sub eax, dword ptr [edx + field_68]          # 004bbce7
    mov ecx, dword ptr [ebp - local_8]           # 004bbcea
    mov edx, dword ptr [ecx + field_58]          # 004bbced
    {load} add edx, eax                          # 004bbcf0
    mov eax, dword ptr [ebp - local_8]           # 004bbcf2
    mov dword ptr [eax + field_58], edx          # 004bbcf5
    mov ecx, dword ptr [ebp - local_8]           # 004bbcf8
    mov edx, dword ptr [ebp - local_c]           # 004bbcfb
    mov eax, dword ptr [edx + field_d8]          # 004bbcfe
    mov dword ptr [ecx + field_68], eax          # 004bbd04
    mov ecx, dword ptr [ebp - local_8]           # 004bbd07
    push ecx                                     # 004bbd0a
    mov ecx, dword ptr [ebp - local_c]           # 004bbd0b
    call FUN_004bb3de                            # 004bbd0e
    jmp.d32 L_004bbde6                           # 004bbd13
L_004bbd18:
    # block 0x004bbd18: entered by jge at 0x004bbca6; jle at 0x004bbcb7, 5 instruction(s), ends with jl to 0x004bbd6a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bbd18
    mov eax, dword ptr [ebp - local_c]           # 004bbd1b
    mov ecx, dword ptr [edx + field_68]          # 004bbd1e
    cmp ecx, dword ptr [eax + field_d8]          # 004bbd21
    jl.d8 L_004bbd6a                             # 004bbd27
    # block 0x004bbd29: entered by fall-through of jl at 0x004bbd27, 5 instruction(s), ends with jg to 0x004bbd6a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bbd29
    mov eax, dword ptr [ebp - local_c]           # 004bbd2c
    mov ecx, dword ptr [edx + field_70]          # 004bbd2f
    cmp ecx, dword ptr [eax + field_e0]          # 004bbd32
    jg.d8 L_004bbd6a                             # 004bbd38
    # block 0x004bbd3a: entered by fall-through of jg at 0x004bbd38, 17 instruction(s), calls FUN_004bb3de, ends with forward jump to 0x004bbde6
    mov edx, dword ptr [ebp - local_8]           # 004bbd3a
    add edx, 0x40                                # 004bbd3d
    mov eax, dword ptr [ebp - local_8]           # 004bbd40
    add eax, 0x58                                # 004bbd43
    mov ecx, dword ptr [edx]                     # 004bbd46
    mov dword ptr [eax], ecx                     # 004bbd48
    mov ecx, dword ptr [edx + field_4]           # 004bbd4a
    mov dword ptr [eax + field_4], ecx           # 004bbd4d
    mov ecx, dword ptr [edx + field_8]           # 004bbd50
    mov dword ptr [eax + field_8], ecx           # 004bbd53
    mov edx, dword ptr [edx + field_c]           # 004bbd56
    mov dword ptr [eax + field_c], edx           # 004bbd59
    mov eax, dword ptr [ebp - local_8]           # 004bbd5c
    push eax                                     # 004bbd5f
    mov ecx, dword ptr [ebp - local_c]           # 004bbd60
    call FUN_004bb3de                            # 004bbd63
    jmp.d8 L_004bbde6                            # 004bbd68
L_004bbd6a:
    # block 0x004bbd6a: entered by jl at 0x004bbd27; jg at 0x004bbd38, 5 instruction(s), ends with jg to 0x004bbde6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bbd6a
    mov edx, dword ptr [ebp - local_c]           # 004bbd6d
    mov eax, dword ptr [ecx + field_68]          # 004bbd70
    cmp eax, dword ptr [edx + field_e0]          # 004bbd73
    jg.d8 L_004bbde6                             # 004bbd79
    # block 0x004bbd7b: entered by fall-through of jg at 0x004bbd79, 5 instruction(s), ends with jl to 0x004bbde6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bbd7b
    mov edx, dword ptr [ebp - local_c]           # 004bbd7e
    mov eax, dword ptr [ecx + field_70]          # 004bbd81
    cmp eax, dword ptr [edx + field_e0]          # 004bbd84
    jl.d8 L_004bbde6                             # 004bbd8a
    # block 0x004bbd8c: entered by fall-through of jl at 0x004bbd8a, 29 instruction(s), calls FUN_004bb3de, falls into the block at 0x004bbde6
    mov ecx, dword ptr [ebp - local_8]           # 004bbd8c
    add ecx, 0x40                                # 004bbd8f
    mov edx, dword ptr [ebp - local_8]           # 004bbd92
    add edx, 0x58                                # 004bbd95
    mov eax, dword ptr [ecx]                     # 004bbd98
    mov dword ptr [edx], eax                     # 004bbd9a
    mov eax, dword ptr [ecx + field_4]           # 004bbd9c
    mov dword ptr [edx + field_4], eax           # 004bbd9f
    mov eax, dword ptr [ecx + field_8]           # 004bbda2
    mov dword ptr [edx + field_8], eax           # 004bbda5
    mov ecx, dword ptr [ecx + field_c]           # 004bbda8
    mov dword ptr [edx + field_c], ecx           # 004bbdab
    mov edx, dword ptr [ebp - local_8]           # 004bbdae
    mov eax, dword ptr [ebp - local_c]           # 004bbdb1
    mov ecx, dword ptr [edx + field_70]          # 004bbdb4
    sub ecx, dword ptr [eax + field_e0]          # 004bbdb7
    mov edx, dword ptr [ebp - local_8]           # 004bbdbd
    mov eax, dword ptr [edx + field_60]          # 004bbdc0
    {load} sub eax, ecx                          # 004bbdc3
    mov ecx, dword ptr [ebp - local_8]           # 004bbdc5
    mov dword ptr [ecx + field_60], eax          # 004bbdc8
    mov edx, dword ptr [ebp - local_8]           # 004bbdcb
    mov eax, dword ptr [ebp - local_c]           # 004bbdce
    mov ecx, dword ptr [eax + field_e0]          # 004bbdd1
    mov dword ptr [edx + field_70], ecx          # 004bbdd7
    mov edx, dword ptr [ebp - local_8]           # 004bbdda
    push edx                                     # 004bbddd
    mov ecx, dword ptr [ebp - local_c]           # 004bbdde
    call FUN_004bb3de                            # 004bbde1
L_004bbde6:
    # block 0x004bbde6: entered by jmp at 0x004bbc92; jmp at 0x004bbd13; jmp at 0x004bbd68; jg at 0x004bbd79; more, 5 instruction(s), ends with jne to 0x004bbe24 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbde6
    mov ecx, dword ptr [ebp - local_8]           # 004bbde9
    mov edx, dword ptr [eax + field_68]          # 004bbdec
    cmp edx, dword ptr [ecx + field_78]          # 004bbdef
    jne.d8 L_004bbe24                            # 004bbdf2
    # block 0x004bbdf4: entered by fall-through of jne at 0x004bbdf2, 5 instruction(s), ends with jne to 0x004bbe24 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbdf4
    mov ecx, dword ptr [ebp - local_8]           # 004bbdf7
    mov edx, dword ptr [eax + field_70]          # 004bbdfa
    cmp edx, dword ptr [ecx + field_80]          # 004bbdfd
    jne.d8 L_004bbe24                            # 004bbe03
    # block 0x004bbe05: entered by fall-through of jne at 0x004bbe03, 5 instruction(s), ends with jne to 0x004bbe24 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbe05
    mov ecx, dword ptr [ebp - local_8]           # 004bbe08
    mov edx, dword ptr [eax + field_6c]          # 004bbe0b
    cmp edx, dword ptr [ecx + field_7c]          # 004bbe0e
    jne.d8 L_004bbe24                            # 004bbe11
    # block 0x004bbe13: entered by fall-through of jne at 0x004bbe11, 5 instruction(s), ends with je to 0x004bbe31 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bbe13
    mov ecx, dword ptr [ebp - local_8]           # 004bbe16
    mov edx, dword ptr [eax + field_74]          # 004bbe19
    cmp edx, dword ptr [ecx + field_84]          # 004bbe1c
    je.d8 L_004bbe31                             # 004bbe22
L_004bbe24:
    # block 0x004bbe24: entered by jne at 0x004bbdf2; jne at 0x004bbe03; jne at 0x004bbe11; fall-through of je at 0x004bbe22, 2 instruction(s), falls into the block at 0x004bbe31
    mov eax, dword ptr [ebp - local_8]           # 004bbe24
    mov dword ptr [eax + field_128], 0x1         # 004bbe27
L_004bbe31:
    # block 0x004bbe31: entered by je at 0x004bbe22, 4 instruction(s), ends with backward jump to 0x004bbb8c
    mov ecx, dword ptr [ebp - local_8]           # 004bbe31
    mov edx, dword ptr [ecx + field_150]         # 004bbe34
    mov dword ptr [ebp - local_8], edx           # 004bbe3a
    jmp.d32 L_004bbb8c                           # 004bbe3d
L_004bbe42:
    # block 0x004bbe42: entered by jmp at 0x004bbb62; je at 0x004bbb7d; je at 0x004bbb90, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bbe42
    pop ebp                                      # 004bbe44
    ret                                          # 004bbe45

