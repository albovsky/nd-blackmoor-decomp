# FUN_004aef4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aef4a
# extent:       0x004aef4a-0x004af225 (731 code bytes)
# span:         0x004aef4a-0x004af225 (code 731, tables 0, padding 0)
# sha256:       047da88b056095c512a1d4d9dfbc11250e40ba8ad58700beb53afb05df40357a
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aef4a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       27 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 15 more
# fields:       [eax + n] field_4, field_8, field_c, field_26; [ecx + n] field_4, field_8, field_c, field_20, field_6e; [edx + n] field_4, field_8, field_c, field_1c, field_27
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m4ad310_click_2774_2776 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 253 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e

# --- external targets -----------------------------------------------

.org 0x004aef4a - 0x401000
.globl FUN_004aef4a
FUN_004aef4a:
    # block 0x004aef4a: entry, 56 instruction(s), ends with jge to 0x004af03a (forward)
    push ebp                                     # 004aef4a
    {load} mov ebp, esp                          # 004aef4b
    sub esp, 0x6c                                # 004aef4d
    mov dword ptr [ebp - local_6c], ecx          # 004aef50
    mov eax, dword ptr [ebp + arg_8]             # 004aef53
    imul eax, eax, 0xc7                          # 004aef56
    mov ecx, dword ptr [ebp - local_6c]          # 004aef5c
    lea edx, [ecx + eax + field_6e]              # 004aef5f
    mov dword ptr [ebp - local_68], edx          # 004aef63
    mov eax, dword ptr [ebp - local_68]          # 004aef66
    {load} xor ecx, ecx                          # 004aef69
    mov cl, byte ptr [eax + field_26]            # 004aef6b
    imul ecx, ecx, 0x28                          # 004aef6e
    mov edx, dword ptr [ebp - local_68]          # 004aef71
    lea eax, [edx + ecx + field_27]              # 004aef74
    mov dword ptr [ebp - local_54], eax          # 004aef78
    mov ecx, dword ptr [ebp - local_68]          # 004aef7b
    add ecx, 0x2                                 # 004aef7e
    mov dword ptr [ebp - local_4c], ecx          # 004aef81
    mov edx, dword ptr [ebp - local_54]          # 004aef84
    mov eax, dword ptr [edx + field_1c]          # 004aef87
    mov dword ptr [ebp - local_10], eax          # 004aef8a
    mov ecx, dword ptr [ebp - local_54]          # 004aef8d
    mov dx, word ptr [ecx + field_20]            # 004aef90
    mov word ptr [ebp - local_8], dx             # 004aef94
    mov eax, dword ptr [ebp + arg_c]             # 004aef98
    imul eax, eax, 0xc7                          # 004aef9b
    mov ecx, dword ptr [ebp - local_6c]          # 004aefa1
    lea edx, [ecx + eax + field_6e]              # 004aefa4
    mov dword ptr [ebp - local_18], edx          # 004aefa8
    mov eax, dword ptr [ebp - local_18]          # 004aefab
    {load} xor ecx, ecx                          # 004aefae
    mov cl, byte ptr [eax + field_26]            # 004aefb0
    imul ecx, ecx, 0x28                          # 004aefb3
    mov edx, dword ptr [ebp - local_18]          # 004aefb6
    lea eax, [edx + ecx + field_27]              # 004aefb9
    mov dword ptr [ebp - local_50], eax          # 004aefbd
    mov ecx, dword ptr [ebp - local_18]          # 004aefc0
    add ecx, 0x2                                 # 004aefc3
    mov dword ptr [ebp - local_64], ecx          # 004aefc6
    mov edx, dword ptr [ebp - local_50]          # 004aefc9
    mov eax, dword ptr [edx + field_1c]          # 004aefcc
    mov dword ptr [ebp - local_3c], eax          # 004aefcf
    mov ecx, dword ptr [ebp - local_50]          # 004aefd2
    mov dx, word ptr [ecx + field_20]            # 004aefd5
    mov word ptr [ebp - local_44], dx            # 004aefd9
    or eax, -0x1                                 # 004aefdd
    mov dword ptr [ebp - local_2c], eax          # 004aefe0
    mov dword ptr [ebp - local_28], eax          # 004aefe3
    mov dword ptr [ebp - local_24], eax          # 004aefe6
    mov dword ptr [ebp - local_20], eax          # 004aefe9
    mov ecx, dword ptr [ebp - local_4c]          # 004aefec
    mov edx, dword ptr [ebp - local_64]          # 004aefef
    mov eax, dword ptr [ecx]                     # 004aeff2
    cmp eax, dword ptr [edx]                     # 004aeff4
    jge.d8 L_004af03a                            # 004aeff6
    # block 0x004aeff8: entered by fall-through of jge at 0x004aeff6, 5 instruction(s), ends with jl to 0x004af031 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004aeff8
    mov edx, dword ptr [ebp - local_64]          # 004aeffb
    mov eax, dword ptr [ecx + field_8]           # 004aeffe
    cmp eax, dword ptr [edx]                     # 004af001
    jl.d8 L_004af031                             # 004af003
    # block 0x004af005: entered by fall-through of jl at 0x004af003, 8 instruction(s), ends with jle to 0x004af026 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004af005
    mov edx, dword ptr [ecx]                     # 004af008
    mov dword ptr [ebp - local_2c], edx          # 004af00a
    mov eax, dword ptr [ebp - local_4c]          # 004af00d
    mov ecx, dword ptr [ebp - local_64]          # 004af010
    mov edx, dword ptr [eax + field_8]           # 004af013
    cmp edx, dword ptr [ecx + field_8]           # 004af016
    jle.d8 L_004af026                            # 004af019
    # block 0x004af01b: entered by fall-through of jle at 0x004af019, 4 instruction(s), ends with forward jump to 0x004af02f
    mov eax, dword ptr [ebp - local_64]          # 004af01b
    mov ecx, dword ptr [eax + field_8]           # 004af01e
    mov dword ptr [ebp - local_24], ecx          # 004af021
    jmp.d8 L_004af02f                            # 004af024
L_004af026:
    # block 0x004af026: entered by jle at 0x004af019, 3 instruction(s), falls into the block at 0x004af02f
    mov edx, dword ptr [ebp - local_4c]          # 004af026
    mov eax, dword ptr [edx + field_8]           # 004af029
    mov dword ptr [ebp - local_24], eax          # 004af02c
L_004af02f:
    # block 0x004af02f: entered by jmp at 0x004af024, 1 instruction(s), ends with forward jump to 0x004af038
    jmp.d8 L_004af038                            # 004af02f
L_004af031:
    # block 0x004af031: entered by jl at 0x004af003, 2 instruction(s), ends with forward jump to 0x004af21f
    {load} xor eax, eax                          # 004af031
    jmp.d32 L_004af21f                           # 004af033
L_004af038:
    # block 0x004af038: entered by jmp at 0x004af02f, 1 instruction(s), ends with forward jump to 0x004af07a
    jmp.d8 L_004af07a                            # 004af038
L_004af03a:
    # block 0x004af03a: entered by jge at 0x004aeff6, 5 instruction(s), ends with jg to 0x004af073 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af03a
    mov edx, dword ptr [ebp - local_64]          # 004af03d
    mov eax, dword ptr [ecx]                     # 004af040
    cmp eax, dword ptr [edx + field_8]           # 004af042
    jg.d8 L_004af073                             # 004af045
    # block 0x004af047: entered by fall-through of jg at 0x004af045, 8 instruction(s), ends with jg to 0x004af068 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af047
    mov edx, dword ptr [ecx]                     # 004af04a
    mov dword ptr [ebp - local_2c], edx          # 004af04c
    mov eax, dword ptr [ebp - local_4c]          # 004af04f
    mov ecx, dword ptr [ebp - local_64]          # 004af052
    mov edx, dword ptr [eax + field_8]           # 004af055
    cmp edx, dword ptr [ecx + field_8]           # 004af058
    jg.d8 L_004af068                             # 004af05b
    # block 0x004af05d: entered by fall-through of jg at 0x004af05b, 4 instruction(s), ends with forward jump to 0x004af071
    mov eax, dword ptr [ebp - local_4c]          # 004af05d
    mov ecx, dword ptr [eax + field_8]           # 004af060
    mov dword ptr [ebp - local_24], ecx          # 004af063
    jmp.d8 L_004af071                            # 004af066
L_004af068:
    # block 0x004af068: entered by jg at 0x004af05b, 3 instruction(s), falls into the block at 0x004af071
    mov edx, dword ptr [ebp - local_64]          # 004af068
    mov eax, dword ptr [edx + field_8]           # 004af06b
    mov dword ptr [ebp - local_24], eax          # 004af06e
L_004af071:
    # block 0x004af071: entered by jmp at 0x004af066, 1 instruction(s), ends with forward jump to 0x004af07a
    jmp.d8 L_004af07a                            # 004af071
L_004af073:
    # block 0x004af073: entered by jg at 0x004af045, 2 instruction(s), ends with forward jump to 0x004af21f
    {load} xor eax, eax                          # 004af073
    jmp.d32 L_004af21f                           # 004af075
L_004af07a:
    # block 0x004af07a: entered by jmp at 0x004af038; jmp at 0x004af071, 5 instruction(s), ends with jge to 0x004af0cc (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af07a
    mov edx, dword ptr [ebp - local_64]          # 004af07d
    mov eax, dword ptr [ecx + field_4]           # 004af080
    cmp eax, dword ptr [edx + field_4]           # 004af083
    jge.d8 L_004af0cc                            # 004af086
    # block 0x004af088: entered by fall-through of jge at 0x004af086, 5 instruction(s), ends with jl to 0x004af0c3 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af088
    mov edx, dword ptr [ebp - local_64]          # 004af08b
    mov eax, dword ptr [ecx + field_c]           # 004af08e
    cmp eax, dword ptr [edx + field_4]           # 004af091
    jl.d8 L_004af0c3                             # 004af094
    # block 0x004af096: entered by fall-through of jl at 0x004af094, 8 instruction(s), ends with jle to 0x004af0b8 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004af096
    mov edx, dword ptr [ecx + field_4]           # 004af099
    mov dword ptr [ebp - local_28], edx          # 004af09c
    mov eax, dword ptr [ebp - local_4c]          # 004af09f
    mov ecx, dword ptr [ebp - local_64]          # 004af0a2
    mov edx, dword ptr [eax + field_c]           # 004af0a5
    cmp edx, dword ptr [ecx + field_c]           # 004af0a8
    jle.d8 L_004af0b8                            # 004af0ab
    # block 0x004af0ad: entered by fall-through of jle at 0x004af0ab, 4 instruction(s), ends with forward jump to 0x004af0c1
    mov eax, dword ptr [ebp - local_64]          # 004af0ad
    mov ecx, dword ptr [eax + field_c]           # 004af0b0
    mov dword ptr [ebp - local_20], ecx          # 004af0b3
    jmp.d8 L_004af0c1                            # 004af0b6
L_004af0b8:
    # block 0x004af0b8: entered by jle at 0x004af0ab, 3 instruction(s), falls into the block at 0x004af0c1
    mov edx, dword ptr [ebp - local_4c]          # 004af0b8
    mov eax, dword ptr [edx + field_c]           # 004af0bb
    mov dword ptr [ebp - local_20], eax          # 004af0be
L_004af0c1:
    # block 0x004af0c1: entered by jmp at 0x004af0b6, 1 instruction(s), ends with forward jump to 0x004af0ca
    jmp.d8 L_004af0ca                            # 004af0c1
L_004af0c3:
    # block 0x004af0c3: entered by jl at 0x004af094, 2 instruction(s), ends with forward jump to 0x004af21f
    {load} xor eax, eax                          # 004af0c3
    jmp.d32 L_004af21f                           # 004af0c5
L_004af0ca:
    # block 0x004af0ca: entered by jmp at 0x004af0c1, 1 instruction(s), ends with forward jump to 0x004af10e
    jmp.d8 L_004af10e                            # 004af0ca
L_004af0cc:
    # block 0x004af0cc: entered by jge at 0x004af086, 5 instruction(s), ends with jg to 0x004af107 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af0cc
    mov edx, dword ptr [ebp - local_64]          # 004af0cf
    mov eax, dword ptr [ecx + field_4]           # 004af0d2
    cmp eax, dword ptr [edx + field_c]           # 004af0d5
    jg.d8 L_004af107                             # 004af0d8
    # block 0x004af0da: entered by fall-through of jg at 0x004af0d8, 8 instruction(s), ends with jg to 0x004af0fc (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004af0da
    mov edx, dword ptr [ecx + field_4]           # 004af0dd
    mov dword ptr [ebp - local_28], edx          # 004af0e0
    mov eax, dword ptr [ebp - local_4c]          # 004af0e3
    mov ecx, dword ptr [ebp - local_64]          # 004af0e6
    mov edx, dword ptr [eax + field_c]           # 004af0e9
    cmp edx, dword ptr [ecx + field_c]           # 004af0ec
    jg.d8 L_004af0fc                             # 004af0ef
    # block 0x004af0f1: entered by fall-through of jg at 0x004af0ef, 4 instruction(s), ends with forward jump to 0x004af105
    mov eax, dword ptr [ebp - local_4c]          # 004af0f1
    mov ecx, dword ptr [eax + field_c]           # 004af0f4
    mov dword ptr [ebp - local_20], ecx          # 004af0f7
    jmp.d8 L_004af105                            # 004af0fa
L_004af0fc:
    # block 0x004af0fc: entered by jg at 0x004af0ef, 3 instruction(s), falls into the block at 0x004af105
    mov edx, dword ptr [ebp - local_64]          # 004af0fc
    mov eax, dword ptr [edx + field_c]           # 004af0ff
    mov dword ptr [ebp - local_20], eax          # 004af102
L_004af105:
    # block 0x004af105: entered by jmp at 0x004af0fa, 1 instruction(s), ends with forward jump to 0x004af10e
    jmp.d8 L_004af10e                            # 004af105
L_004af107:
    # block 0x004af107: entered by jg at 0x004af0d8, 2 instruction(s), ends with forward jump to 0x004af21f
    {load} xor eax, eax                          # 004af107
    jmp.d32 L_004af21f                           # 004af109
L_004af10e:
    # block 0x004af10e: entered by jmp at 0x004af0ca; jmp at 0x004af105, 2 instruction(s), ends with je to 0x004af126 (forward)
    cmp dword ptr [ebp - local_28], -0x1         # 004af10e
    je.d8 L_004af126                             # 004af112
    # block 0x004af114: entered by fall-through of je at 0x004af112, 2 instruction(s), ends with je to 0x004af126 (forward)
    cmp dword ptr [ebp - local_20], -0x1         # 004af114
    je.d8 L_004af126                             # 004af118
    # block 0x004af11a: entered by fall-through of je at 0x004af118, 2 instruction(s), ends with je to 0x004af126 (forward)
    cmp dword ptr [ebp - local_2c], -0x1         # 004af11a
    je.d8 L_004af126                             # 004af11e
    # block 0x004af120: entered by fall-through of je at 0x004af11e, 2 instruction(s), ends with jne to 0x004af12d (forward)
    cmp dword ptr [ebp - local_24], -0x1         # 004af120
    jne.d8 L_004af12d                            # 004af124
L_004af126:
    # block 0x004af126: entered by je at 0x004af112; je at 0x004af118; je at 0x004af11e; fall-through of jne at 0x004af124, 2 instruction(s), ends with forward jump to 0x004af21f
    {load} xor eax, eax                          # 004af126
    jmp.d32 L_004af21f                           # 004af128
L_004af12d:
    # block 0x004af12d: entered by jne at 0x004af124, 37 instruction(s), ends with forward jump to 0x004af1a9
    mov ecx, dword ptr [ebp - local_4c]          # 004af12d
    mov edx, dword ptr [ebp - local_2c]          # 004af130
    sub edx, dword ptr [ecx]                     # 004af133
    mov dword ptr [ebp - local_5c], edx          # 004af135
    mov eax, dword ptr [ebp - local_4c]          # 004af138
    mov ecx, dword ptr [ebp - local_24]          # 004af13b
    sub ecx, dword ptr [eax]                     # 004af13e
    mov dword ptr [ebp - local_38], ecx          # 004af140
    mov edx, dword ptr [ebp - local_4c]          # 004af143
    mov eax, dword ptr [ebp - local_28]          # 004af146
    sub eax, dword ptr [edx + field_4]           # 004af149
    mov dword ptr [ebp - local_60], eax          # 004af14c
    mov ecx, dword ptr [ebp - local_4c]          # 004af14f
    mov edx, dword ptr [ebp - local_20]          # 004af152
    sub edx, dword ptr [ecx + field_4]           # 004af155
    mov dword ptr [ebp - local_4], edx           # 004af158
    mov eax, dword ptr [ebp - local_64]          # 004af15b
    mov ecx, dword ptr [ebp - local_2c]          # 004af15e
    sub ecx, dword ptr [eax]                     # 004af161
    mov dword ptr [ebp - local_14], ecx          # 004af163
    mov edx, dword ptr [ebp - local_64]          # 004af166
    mov eax, dword ptr [ebp - local_24]          # 004af169
    sub eax, dword ptr [edx]                     # 004af16c
    mov dword ptr [ebp - local_34], eax          # 004af16e
    mov ecx, dword ptr [ebp - local_64]          # 004af171
    mov edx, dword ptr [ebp - local_28]          # 004af174
    sub edx, dword ptr [ecx + field_4]           # 004af177
    mov dword ptr [ebp - local_c], edx           # 004af17a
    mov eax, dword ptr [ebp - local_64]          # 004af17d
    mov ecx, dword ptr [ebp - local_20]          # 004af180
    sub ecx, dword ptr [eax + field_4]           # 004af183
    mov dword ptr [ebp - local_40], ecx          # 004af186
    mov edx, dword ptr [ebp - local_60]          # 004af189
    mov dword ptr [ebp - local_30], edx          # 004af18c
    mov eax, dword ptr [ebp - local_c]           # 004af18f
    mov dword ptr [ebp - local_58], eax          # 004af192
    jmp.d8 L_004af1a9                            # 004af195
L_004af197:
    # block 0x004af197: entered by jmp at 0x004af218, 6 instruction(s), falls into the block at 0x004af1a9
    mov ecx, dword ptr [ebp - local_30]          # 004af197
    add ecx, 0x1                                 # 004af19a
    mov dword ptr [ebp - local_30], ecx          # 004af19d
    mov edx, dword ptr [ebp - local_58]          # 004af1a0
    add edx, 0x1                                 # 004af1a3
    mov dword ptr [ebp - local_58], edx          # 004af1a6
L_004af1a9:
    # block 0x004af1a9: entered by jmp at 0x004af195, 3 instruction(s), ends with jg to 0x004af21d (forward)
    mov eax, dword ptr [ebp - local_30]          # 004af1a9
    cmp eax, dword ptr [ebp - local_4]           # 004af1ac
    jg.d8 L_004af21d                             # 004af1af
    # block 0x004af1b1: entered by fall-through of jg at 0x004af1af, 5 instruction(s), ends with forward jump to 0x004af1d1
    mov ecx, dword ptr [ebp - local_5c]          # 004af1b1
    mov dword ptr [ebp - local_1c], ecx          # 004af1b4
    mov edx, dword ptr [ebp - local_14]          # 004af1b7
    mov dword ptr [ebp - local_48], edx          # 004af1ba
    jmp.d8 L_004af1d1                            # 004af1bd
L_004af1bf:
    # block 0x004af1bf: entered by jmp at 0x004af216, 6 instruction(s), falls into the block at 0x004af1d1
    mov eax, dword ptr [ebp - local_1c]          # 004af1bf
    add eax, 0x1                                 # 004af1c2
    mov dword ptr [ebp - local_1c], eax          # 004af1c5
    mov ecx, dword ptr [ebp - local_48]          # 004af1c8
    add ecx, 0x1                                 # 004af1cb
    mov dword ptr [ebp - local_48], ecx          # 004af1ce
L_004af1d1:
    # block 0x004af1d1: entered by jmp at 0x004af1bd, 3 instruction(s), ends with jg to 0x004af218 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004af1d1
    cmp edx, dword ptr [ebp - local_38]          # 004af1d4
    jg.d8 L_004af218                             # 004af1d7
    # block 0x004af1d9: entered by fall-through of jg at 0x004af1d7, 10 instruction(s), ends with je to 0x004af216 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004af1d9
    mov ecx, dword ptr [ebp - local_30]          # 004af1dd
    imul ecx, eax                                # 004af1e0
    mov edx, dword ptr [ebp - local_10]          # 004af1e3
    {load} add edx, ecx                          # 004af1e6
    mov eax, dword ptr [ebp - local_1c]          # 004af1e8
    {load} xor ecx, ecx                          # 004af1eb
    mov cl, byte ptr [edx + eax]                 # 004af1ed
    test ecx, ecx                                # 004af1f0
    je.d8 L_004af216                             # 004af1f2
    # block 0x004af1f4: entered by fall-through of je at 0x004af1f2, 10 instruction(s), ends with je to 0x004af216 (forward)
    movsx edx, word ptr [ebp - local_44]         # 004af1f4
    mov eax, dword ptr [ebp - local_58]          # 004af1f8
    imul eax, edx                                # 004af1fb
    mov ecx, dword ptr [ebp - local_3c]          # 004af1fe
    {load} add ecx, eax                          # 004af201
    mov edx, dword ptr [ebp - local_48]          # 004af203
    {load} xor eax, eax                          # 004af206
    mov al, byte ptr [ecx + edx]                 # 004af208
    test eax, eax                                # 004af20b
    je.d8 L_004af216                             # 004af20d
    # block 0x004af20f: entered by fall-through of je at 0x004af20d, 2 instruction(s), ends with forward jump to 0x004af21f
    mov eax, 0x1                                 # 004af20f
    jmp.d8 L_004af21f                            # 004af214
L_004af216:
    # block 0x004af216: entered by je at 0x004af1f2; je at 0x004af20d, 1 instruction(s), ends with backward jump to 0x004af1bf
    jmp.d8 L_004af1bf                            # 004af216
L_004af218:
    # block 0x004af218: entered by jg at 0x004af1d7, 1 instruction(s), ends with backward jump to 0x004af197
    jmp.d32 L_004af197                           # 004af218
L_004af21d:
    # block 0x004af21d: entered by jg at 0x004af1af, 1 instruction(s), falls into the block at 0x004af21f
    {load} xor eax, eax                          # 004af21d
L_004af21f:
    # block 0x004af21f: entered by jmp at 0x004af033; jmp at 0x004af075; jmp at 0x004af0c5; jmp at 0x004af109; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004af21f
    pop ebp                                      # 004af221
    ret 0x8                                      # 004af222

