# FUN_004eeb23
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eeb23
# extent:       0x004eeb23-0x004ef2d1 (1966 code bytes)
# span:         0x004eeb23-0x004ef2d1 (code 1966, tables 0, padding 0)
# sha256:       ab3a46772675163f744bf65b0f5e4f268e3d2b11d62d056387267b0ff50fbb46
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eeb23
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_5a, field_66, field_a6, field_ae, field_b2, field_b6, field_ba, field_d2, field_d6 and 14 more; [ecx + n] field_4, field_8, field_c, field_5e, field_6a, field_9e, field_aa, field_ce, field_12e, field_132, field_136, field_13a and 10 more; [edx + n] field_4, field_8, field_c, field_10, field_14, field_5a, field_62, field_a2, field_be, field_ce, field_12e, field_132 and 13 more
# callees:      calls FUN_004ee9bb, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004ef89b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 504 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_9e, 0x9e  # offset +0x9e
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ae, 0xae  # offset +0xae
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_be, 0xbe  # offset +0xbe
.equ field_ce, 0xce  # offset +0xce
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d6, 0xd6  # offset +0xd6
.equ field_da, 0xda  # offset +0xda
.equ field_12e, 0x12e  # offset +0x12e
.equ field_132, 0x132  # offset +0x132
.equ field_136, 0x136  # offset +0x136
.equ field_13a, 0x13a  # offset +0x13a
.equ field_13e, 0x13e  # offset +0x13e
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_172, 0x172  # offset +0x172
.equ field_176, 0x176  # offset +0x176
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_1a2, 0x1a2  # offset +0x1a2
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_1aa, 0x1aa  # offset +0x1aa

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004ee9bb, .text + (0x004ee9bb - 0x401000)
.set FUN_004ef89b, .text + (0x004ef89b - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004eeb23 - 0x401000
.globl FUN_004eeb23
FUN_004eeb23:
    # block 0x004eeb23: entry, 21 instruction(s), calls FUN_004ee9bb, ends with jne to 0x004eeb6d (forward)
    push ebp                                     # 004eeb23
    {load} mov ebp, esp                          # 004eeb24
    sub esp, 0x10                                # 004eeb26
    push esi                                     # 004eeb29
    push edi                                     # 004eeb2a
    mov dword ptr [ebp - local_4], ecx           # 004eeb2b
    mov ecx, dword ptr [ebp - local_4]           # 004eeb2e
    call FUN_004ee9bb                            # 004eeb31
    mov edi, dword ptr [ebp - local_4]           # 004eeb36
    add edi, 0x18                                # 004eeb39
    mov ecx, 0x31                                # 004eeb3c
    mov esi, dword ptr [ebp + arg_8]             # 004eeb41
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eeb44
    movsw word ptr es:[edi], word ptr [esi]      # 004eeb46
    mov edi, 0x55ce14                            # 004eeb48
    mov esi, dword ptr [ebp - local_4]           # 004eeb4d
    add esi, 0x18                                # 004eeb50
    mov ecx, 0xf                                 # 004eeb53
    {load} xor eax, eax                          # 004eeb58
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eeb5a
    jne.d8 L_004eeb6d                            # 004eeb5c
    # block 0x004eeb5e: entered by fall-through of jne at 0x004eeb5c, 3 instruction(s), ends with forward jump to 0x004eeb7a
    mov ecx, dword ptr [ebp - local_4]           # 004eeb5e
    mov dword ptr [ecx + field_1a2], 0x1         # 004eeb61
    jmp.d8 L_004eeb7a                            # 004eeb6b
L_004eeb6d:
    # block 0x004eeb6d: entered by jne at 0x004eeb5c, 2 instruction(s), falls into the block at 0x004eeb7a
    mov edx, dword ptr [ebp - local_4]           # 004eeb6d
    mov dword ptr [edx + field_1a2], 0x0         # 004eeb70
L_004eeb7a:
    # block 0x004eeb7a: entered by jmp at 0x004eeb6b, 3 instruction(s), ends with je to 0x004eec37 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004eeb7a
    cmp dword ptr [eax + field_1a2], 0x0         # 004eeb7d
    je.d32 L_004eec37                            # 004eeb84
    # block 0x004eeb8a: entered by fall-through of je at 0x004eeb84, 41 instruction(s), ends with forward jump to 0x004eeccd
    mov ecx, dword ptr [ebp - local_4]           # 004eeb8a
    add ecx, 0xde                                # 004eeb8d
    mov edx, dword ptr [0x5afc3e]                # 004eeb93
    mov dword ptr [ecx], edx                     # 004eeb99
    mov eax, dword ptr [0x5afc42]                # 004eeb9b
    mov dword ptr [ecx + field_4], eax           # 004eeba0
    mov edx, dword ptr [0x5afc46]                # 004eeba3
    mov dword ptr [ecx + field_8], edx           # 004eeba9
    mov eax, dword ptr [0x5afc4a]                # 004eebac
    mov dword ptr [ecx + field_c], eax           # 004eebb1
    mov ecx, dword ptr [ebp - local_4]           # 004eebb4
    add ecx, 0xee                                # 004eebb7
    mov edx, dword ptr [0x5afc4e]                # 004eebbd
    mov dword ptr [ecx], edx                     # 004eebc3
    mov eax, dword ptr [0x5afc52]                # 004eebc5
    mov dword ptr [ecx + field_4], eax           # 004eebca
    mov edx, dword ptr [0x5afc56]                # 004eebcd
    mov dword ptr [ecx + field_8], edx           # 004eebd3
    mov eax, dword ptr [0x5afc5a]                # 004eebd6
    mov dword ptr [ecx + field_c], eax           # 004eebdb
    mov ecx, dword ptr [ebp - local_4]           # 004eebde
    add ecx, 0xfe                                # 004eebe1
    mov edx, dword ptr [0x5afc5e]                # 004eebe7
    mov dword ptr [ecx], edx                     # 004eebed
    mov eax, dword ptr [0x5afc62]                # 004eebef
    mov dword ptr [ecx + field_4], eax           # 004eebf4
    mov edx, dword ptr [0x5afc66]                # 004eebf7
    mov dword ptr [ecx + field_8], edx           # 004eebfd
    mov eax, dword ptr [0x5afc6a]                # 004eec00
    mov dword ptr [ecx + field_c], eax           # 004eec05
    mov ecx, dword ptr [ebp - local_4]           # 004eec08
    add ecx, 0x10e                               # 004eec0b
    mov edx, dword ptr [0x5afc6e]                # 004eec11
    mov dword ptr [ecx], edx                     # 004eec17
    mov eax, dword ptr [0x5afc72]                # 004eec19
    mov dword ptr [ecx + field_4], eax           # 004eec1e
    mov edx, dword ptr [0x5afc76]                # 004eec21
    mov dword ptr [ecx + field_8], edx           # 004eec27
    mov eax, dword ptr [0x5afc7a]                # 004eec2a
    mov dword ptr [ecx + field_c], eax           # 004eec2f
    jmp.d32 L_004eeccd                           # 004eec32
L_004eec37:
    # block 0x004eec37: entered by je at 0x004eeb84, 48 instruction(s), falls into the block at 0x004eeccd
    mov ecx, dword ptr [ebp - local_4]           # 004eec37
    add ecx, 0x5e                                # 004eec3a
    mov edx, dword ptr [ebp - local_4]           # 004eec3d
    add edx, 0xde                                # 004eec40
    mov eax, dword ptr [ecx]                     # 004eec46
    mov dword ptr [edx], eax                     # 004eec48
    mov eax, dword ptr [ecx + field_4]           # 004eec4a
    mov dword ptr [edx + field_4], eax           # 004eec4d
    mov eax, dword ptr [ecx + field_8]           # 004eec50
    mov dword ptr [edx + field_8], eax           # 004eec53
    mov ecx, dword ptr [ecx + field_c]           # 004eec56
    mov dword ptr [edx + field_c], ecx           # 004eec59
    mov edx, dword ptr [ebp - local_4]           # 004eec5c
    add edx, 0x6e                                # 004eec5f
    mov eax, dword ptr [ebp - local_4]           # 004eec62
    add eax, 0xee                                # 004eec65
    mov ecx, dword ptr [edx]                     # 004eec6a
    mov dword ptr [eax], ecx                     # 004eec6c
    mov ecx, dword ptr [edx + field_4]           # 004eec6e
    mov dword ptr [eax + field_4], ecx           # 004eec71
    mov ecx, dword ptr [edx + field_8]           # 004eec74
    mov dword ptr [eax + field_8], ecx           # 004eec77
    mov edx, dword ptr [edx + field_c]           # 004eec7a
    mov dword ptr [eax + field_c], edx           # 004eec7d
    mov eax, dword ptr [ebp - local_4]           # 004eec80
    add eax, 0x7e                                # 004eec83
    mov ecx, dword ptr [ebp - local_4]           # 004eec86
    add ecx, 0xfe                                # 004eec89
    mov edx, dword ptr [eax]                     # 004eec8f
    mov dword ptr [ecx], edx                     # 004eec91
    mov edx, dword ptr [eax + field_4]           # 004eec93
    mov dword ptr [ecx + field_4], edx           # 004eec96
    mov edx, dword ptr [eax + field_8]           # 004eec99
    mov dword ptr [ecx + field_8], edx           # 004eec9c
    mov eax, dword ptr [eax + field_c]           # 004eec9f
    mov dword ptr [ecx + field_c], eax           # 004eeca2
    mov ecx, dword ptr [ebp - local_4]           # 004eeca5
    add ecx, 0x8e                                # 004eeca8
    mov edx, dword ptr [ebp - local_4]           # 004eecae
    add edx, 0x10e                               # 004eecb1
    mov eax, dword ptr [ecx]                     # 004eecb7
    mov dword ptr [edx], eax                     # 004eecb9
    mov eax, dword ptr [ecx + field_4]           # 004eecbb
    mov dword ptr [edx + field_4], eax           # 004eecbe
    mov eax, dword ptr [ecx + field_8]           # 004eecc1
    mov dword ptr [edx + field_8], eax           # 004eecc4
    mov ecx, dword ptr [ecx + field_c]           # 004eecc7
    mov dword ptr [edx + field_c], ecx           # 004eecca
L_004eeccd:
    # block 0x004eeccd: entered by jmp at 0x004eec32, 3 instruction(s), ends with je to 0x004eed3b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004eeccd
    cmp dword ptr [edx + field_be], 0x0          # 004eecd0
    je.d8 L_004eed3b                             # 004eecd7
    # block 0x004eecd9: entered by fall-through of je at 0x004eecd7, 21 instruction(s), ends with forward jump to 0x004eed62
    mov eax, dword ptr [ebp - local_4]           # 004eecd9
    mov ecx, dword ptr [eax + field_ae]          # 004eecdc
    add ecx, dword ptr [0x583186]                # 004eece2
    mov edx, dword ptr [ebp - local_4]           # 004eece8
    mov dword ptr [edx + field_12e], ecx         # 004eeceb
    mov eax, dword ptr [ebp - local_4]           # 004eecf1
    mov ecx, dword ptr [eax + field_b6]          # 004eecf4
    add ecx, dword ptr [0x583186]                # 004eecfa
    mov edx, dword ptr [ebp - local_4]           # 004eed00
    mov dword ptr [edx + field_136], ecx         # 004eed03
    mov eax, dword ptr [ebp - local_4]           # 004eed09
    mov ecx, dword ptr [eax + field_b2]          # 004eed0c
    add ecx, dword ptr [0x58318a]                # 004eed12
    mov edx, dword ptr [ebp - local_4]           # 004eed18
    mov dword ptr [edx + field_132], ecx         # 004eed1b
    mov eax, dword ptr [ebp - local_4]           # 004eed21
    mov ecx, dword ptr [eax + field_ba]          # 004eed24
    add ecx, dword ptr [0x58318a]                # 004eed2a
    mov edx, dword ptr [ebp - local_4]           # 004eed30
    mov dword ptr [edx + field_13a], ecx         # 004eed33
    jmp.d8 L_004eed62                            # 004eed39
L_004eed3b:
    # block 0x004eed3b: entered by je at 0x004eecd7, 12 instruction(s), falls into the block at 0x004eed62
    mov eax, dword ptr [ebp - local_4]           # 004eed3b
    add eax, 0xae                                # 004eed3e
    mov ecx, dword ptr [ebp - local_4]           # 004eed43
    add ecx, 0x12e                               # 004eed46
    mov edx, dword ptr [eax]                     # 004eed4c
    mov dword ptr [ecx], edx                     # 004eed4e
    mov edx, dword ptr [eax + field_4]           # 004eed50
    mov dword ptr [ecx + field_4], edx           # 004eed53
    mov edx, dword ptr [eax + field_8]           # 004eed56
    mov dword ptr [ecx + field_8], edx           # 004eed59
    mov eax, dword ptr [eax + field_c]           # 004eed5c
    mov dword ptr [ecx + field_c], eax           # 004eed5f
L_004eed62:
    # block 0x004eed62: entered by jmp at 0x004eed39, 33 instruction(s), ends with jne to 0x004eedf1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eed62
    mov edx, dword ptr [ebp - local_4]           # 004eed65
    mov eax, dword ptr [ecx + field_136]         # 004eed68
    sub eax, dword ptr [edx + field_12e]         # 004eed6e
    add eax, 0x1                                 # 004eed74
    mov ecx, dword ptr [ebp - local_4]           # 004eed77
    mov dword ptr [ecx + field_172], eax         # 004eed7a
    mov edx, dword ptr [ebp - local_4]           # 004eed80
    mov eax, dword ptr [ebp - local_4]           # 004eed83
    mov ecx, dword ptr [edx + field_13a]         # 004eed86
    sub ecx, dword ptr [eax + field_132]         # 004eed8c
    add ecx, 0x1                                 # 004eed92
    mov edx, dword ptr [ebp - local_4]           # 004eed95
    mov dword ptr [edx + field_176], ecx         # 004eed98
    mov eax, dword ptr [ebp - local_4]           # 004eed9e
    mov ecx, dword ptr [ebp - local_4]           # 004eeda1
    mov edx, dword ptr [eax + field_66]          # 004eeda4
    sub edx, dword ptr [ecx + field_5e]          # 004eeda7
    add edx, 0x1                                 # 004eedaa
    mov eax, dword ptr [ebp - local_4]           # 004eedad
    mov dword ptr [eax + field_17a], edx         # 004eedb0
    mov ecx, dword ptr [ebp - local_4]           # 004eedb6
    mov edx, dword ptr [ebp - local_4]           # 004eedb9
    mov eax, dword ptr [ecx + field_6a]          # 004eedbc
    sub eax, dword ptr [edx + field_62]          # 004eedbf
    add eax, 0x1                                 # 004eedc2
    mov ecx, dword ptr [ebp - local_4]           # 004eedc5
    mov dword ptr [ecx + field_17e], eax         # 004eedc8
    mov edx, dword ptr [ebp - local_4]           # 004eedce
    mov eax, dword ptr [ebp - local_4]           # 004eedd1
    mov ecx, dword ptr [edx + field_172]         # 004eedd4
    cmp ecx, dword ptr [eax + field_17a]         # 004eedda
    jne.d8 L_004eedf1                            # 004eede0
    # block 0x004eede2: entered by fall-through of jne at 0x004eede0, 3 instruction(s), ends with forward jump to 0x004eedfe
    mov edx, dword ptr [ebp - local_4]           # 004eede2
    mov dword ptr [edx + field_1aa], 0x1         # 004eede5
    jmp.d8 L_004eedfe                            # 004eedef
L_004eedf1:
    # block 0x004eedf1: entered by jne at 0x004eede0, 2 instruction(s), falls into the block at 0x004eedfe
    mov eax, dword ptr [ebp - local_4]           # 004eedf1
    mov dword ptr [eax + field_1aa], 0x0         # 004eedf4
L_004eedfe:
    # block 0x004eedfe: entered by jmp at 0x004eedef, 5 instruction(s), ends with jne to 0x004eee21 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eedfe
    mov edx, dword ptr [ebp - local_4]           # 004eee01
    mov eax, dword ptr [ecx + field_176]         # 004eee04
    cmp eax, dword ptr [edx + field_17e]         # 004eee0a
    jne.d8 L_004eee21                            # 004eee10
    # block 0x004eee12: entered by fall-through of jne at 0x004eee10, 3 instruction(s), ends with forward jump to 0x004eee2e
    mov ecx, dword ptr [ebp - local_4]           # 004eee12
    mov dword ptr [ecx + field_1a6], 0x1         # 004eee15
    jmp.d8 L_004eee2e                            # 004eee1f
L_004eee21:
    # block 0x004eee21: entered by jne at 0x004eee10, 2 instruction(s), falls into the block at 0x004eee2e
    mov edx, dword ptr [ebp - local_4]           # 004eee21
    mov dword ptr [edx + field_1a6], 0x0         # 004eee24
L_004eee2e:
    # block 0x004eee2e: entered by jmp at 0x004eee1f, 8 instruction(s), ends with jne to 0x004eee6e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004eee2e
    mov ecx, dword ptr [ebp - local_4]           # 004eee31
    mov edx, dword ptr [eax + field_a6]          # 004eee34
    sub edx, dword ptr [ecx + field_9e]          # 004eee3a
    add edx, 0x1                                 # 004eee40
    mov eax, dword ptr [ebp - local_4]           # 004eee43
    cmp edx, dword ptr [eax + field_172]         # 004eee46
    jne.d8 L_004eee6e                            # 004eee4c
    # block 0x004eee4e: entered by fall-through of jne at 0x004eee4c, 8 instruction(s), ends with je to 0x004eeebd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eee4e
    mov edx, dword ptr [ebp - local_4]           # 004eee51
    mov eax, dword ptr [ecx + field_aa]          # 004eee54
    sub eax, dword ptr [edx + field_a2]          # 004eee5a
    add eax, 0x1                                 # 004eee60
    mov ecx, dword ptr [ebp - local_4]           # 004eee63
    cmp eax, dword ptr [ecx + field_176]         # 004eee66
    je.d8 L_004eeebd                             # 004eee6c
L_004eee6e:
    # block 0x004eee6e: entered by jne at 0x004eee4c; fall-through of je at 0x004eee6c, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004eeeae (forward)
    mov edx, dword ptr [ebp - local_4]           # 004eee6e
    mov eax, dword ptr [edx + field_5a]          # 004eee71
    push eax                                     # 004eee74
    push 0x55ce24                                # 004eee75
    push 0x63888b                                # 004eee7a
    call FUN_0050ca3e                            # 004eee7f
    add esp, 0xc                                 # 004eee84
    push 0x63888b                                # 004eee87
    mov ecx, 0x583979                            # 004eee8c
    call FUN_004264e8                            # 004eee91
    movsx ecx, word ptr [0x63a4cd]               # 004eee96
    test ecx, ecx                                # 004eee9d
    je.d8 L_004eeeae                             # 004eee9f
    # block 0x004eeea1: entered by fall-through of je at 0x004eee9f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004eeeae
    push 0x63888b                                # 004eeea1
    call FUN_0044a2b7                            # 004eeea6
    add esp, 0x4                                 # 004eeeab
L_004eeeae:
    # block 0x004eeeae: entered by je at 0x004eee9f, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ef2c9
    mov ecx, 0x5cf659                            # 004eeeae
    call FUN_004c97b4                            # 004eeeb3
    jmp.d32 L_004ef2c9                           # 004eeeb8
L_004eeebd:
    # block 0x004eeebd: entered by je at 0x004eee6c, 13 instruction(s), ends with je to 0x004eeefc (forward)
    mov edx, dword ptr [ebp - local_4]           # 004eeebd
    mov eax, dword ptr [ebp - local_4]           # 004eeec0
    mov ecx, dword ptr [eax + field_da]          # 004eeec3
    mov dword ptr [edx + field_10], ecx          # 004eeec9
    mov edx, dword ptr [ebp - local_4]           # 004eeecc
    mov eax, dword ptr [ebp - local_4]           # 004eeecf
    mov ecx, dword ptr [eax + field_d6]          # 004eeed2
    mov dword ptr [edx + field_14], ecx          # 004eeed8
    mov edx, dword ptr [ebp - local_4]           # 004eeedb
    mov eax, dword ptr [edx + field_ce]          # 004eeede
    mov dword ptr [ebp - local_8], eax           # 004eeee4
    cmp dword ptr [ebp - local_8], 0x0           # 004eeee7
    je.d8 L_004eeefc                             # 004eeeeb
    # block 0x004eeeed: entered by fall-through of je at 0x004eeeeb, 2 instruction(s), ends with je to 0x004ef0b5 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004eeeed
    je.d32 L_004ef0b5                            # 004eeef1
    # block 0x004eeef7: entered by fall-through of je at 0x004eeef1, 1 instruction(s), ends with forward jump to 0x004ef26b
    jmp.d32 L_004ef26b                           # 004eeef7
L_004eeefc:
    # block 0x004eeefc: entered by je at 0x004eeeeb, 14 instruction(s), ends with je to 0x004eef44 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eeefc
    mov edx, dword ptr [ebp - local_4]           # 004eeeff
    mov eax, dword ptr [ecx + field_136]         # 004eef02
    sub eax, dword ptr [edx + field_12e]         # 004eef08
    add eax, 0x1                                 # 004eef0e
    mov ecx, dword ptr [ebp - local_4]           # 004eef11
    sub eax, dword ptr [ecx + field_17a]         # 004eef14
    mov edx, dword ptr [ebp - local_4]           # 004eef1a
    mov dword ptr [edx + field_15e], eax         # 004eef1d
    mov eax, dword ptr [ebp - local_4]           # 004eef23
    mov ecx, dword ptr [eax + field_d2]          # 004eef26
    mov dword ptr [ebp - local_c], ecx           # 004eef2c
    cmp dword ptr [ebp - local_c], 0x0           # 004eef2f
    je.d8 L_004eef44                             # 004eef33
    # block 0x004eef35: entered by fall-through of je at 0x004eef33, 2 instruction(s), ends with je to 0x004eeffd (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004eef35
    je.d32 L_004eeffd                            # 004eef39
    # block 0x004eef3f: entered by fall-through of je at 0x004eef39, 1 instruction(s), ends with forward jump to 0x004ef0b0
    jmp.d32 L_004ef0b0                           # 004eef3f
L_004eef44:
    # block 0x004eef44: entered by je at 0x004eef33, 14 instruction(s), ends with je to 0x004eefa7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004eef44
    mov eax, dword ptr [ebp - local_4]           # 004eef47
    mov ecx, dword ptr [eax + field_12e]         # 004eef4a
    mov dword ptr [edx + field_13e], ecx         # 004eef50
    mov edx, dword ptr [ebp - local_4]           # 004eef56
    mov eax, dword ptr [edx + field_13e]         # 004eef59
    mov ecx, dword ptr [ebp - local_4]           # 004eef5f
    mov edx, dword ptr [ecx + field_17a]         # 004eef62
    lea eax, [eax + edx - field_minus_1]         # 004eef68
    mov ecx, dword ptr [ebp - local_4]           # 004eef6c
    mov dword ptr [ecx + field_146], eax         # 004eef6f
    mov edx, dword ptr [ebp - local_4]           # 004eef75
    cmp dword ptr [edx + field_1a6], 0x0         # 004eef78
    je.d8 L_004eefa7                             # 004eef7f
    # block 0x004eef81: entered by fall-through of je at 0x004eef7f, 9 instruction(s), ends with forward jump to 0x004eeff8
    mov eax, dword ptr [ebp - local_4]           # 004eef81
    mov ecx, dword ptr [ebp - local_4]           # 004eef84
    mov edx, dword ptr [ecx + field_132]         # 004eef87
    mov dword ptr [eax + field_142], edx         # 004eef8d
    mov eax, dword ptr [ebp - local_4]           # 004eef93
    mov ecx, dword ptr [ebp - local_4]           # 004eef96
    mov edx, dword ptr [ecx + field_13a]         # 004eef99
    mov dword ptr [eax + field_14a], edx         # 004eef9f
    jmp.d8 L_004eeff8                            # 004eefa5
L_004eefa7:
    # block 0x004eefa7: entered by je at 0x004eef7f, 23 instruction(s), falls into the block at 0x004eeff8
    mov eax, dword ptr [ebp - local_4]           # 004eefa7
    mov eax, dword ptr [eax + field_176]         # 004eefaa
    cdq                                          # 004eefb0
    {load} sub eax, edx                          # 004eefb1
    sar eax                                      # 004eefb3
    mov ecx, dword ptr [ebp - local_4]           # 004eefb5
    mov ecx, dword ptr [ecx + field_132]         # 004eefb8
    {load} add ecx, eax                          # 004eefbe
    mov edx, dword ptr [ebp - local_4]           # 004eefc0
    mov eax, dword ptr [edx + field_17e]         # 004eefc3
    cdq                                          # 004eefc9
    {load} sub eax, edx                          # 004eefca
    sar eax                                      # 004eefcc
    {load} sub ecx, eax                          # 004eefce
    mov eax, dword ptr [ebp - local_4]           # 004eefd0
    mov dword ptr [eax + field_142], ecx         # 004eefd3
    mov ecx, dword ptr [ebp - local_4]           # 004eefd9
    mov edx, dword ptr [ecx + field_142]         # 004eefdc
    mov eax, dword ptr [ebp - local_4]           # 004eefe2
    mov ecx, dword ptr [eax + field_17e]         # 004eefe5
    lea edx, [edx + ecx - field_minus_1]         # 004eefeb
    mov eax, dword ptr [ebp - local_4]           # 004eefef
    mov dword ptr [eax + field_14a], edx         # 004eeff2
L_004eeff8:
    # block 0x004eeff8: entered by jmp at 0x004eefa5, 1 instruction(s), ends with forward jump to 0x004ef0b0
    jmp.d32 L_004ef0b0                           # 004eeff8
L_004eeffd:
    # block 0x004eeffd: entered by je at 0x004eef39, 14 instruction(s), ends with je to 0x004ef05f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eeffd
    mov edx, dword ptr [ebp - local_4]           # 004ef000
    mov eax, dword ptr [edx + field_136]         # 004ef003
    mov dword ptr [ecx + field_146], eax         # 004ef009
    mov ecx, dword ptr [ebp - local_4]           # 004ef00f
    mov edx, dword ptr [ebp - local_4]           # 004ef012
    mov eax, dword ptr [ecx + field_146]         # 004ef015
    sub eax, dword ptr [edx + field_17a]         # 004ef01b
    add eax, 0x1                                 # 004ef021
    mov ecx, dword ptr [ebp - local_4]           # 004ef024
    mov dword ptr [ecx + field_13e], eax         # 004ef027
    mov edx, dword ptr [ebp - local_4]           # 004ef02d
    cmp dword ptr [edx + field_1a6], 0x0         # 004ef030
    je.d8 L_004ef05f                             # 004ef037
    # block 0x004ef039: entered by fall-through of je at 0x004ef037, 9 instruction(s), ends with forward jump to 0x004ef0b0
    mov eax, dword ptr [ebp - local_4]           # 004ef039
    mov ecx, dword ptr [ebp - local_4]           # 004ef03c
    mov edx, dword ptr [ecx + field_132]         # 004ef03f
    mov dword ptr [eax + field_142], edx         # 004ef045
    mov eax, dword ptr [ebp - local_4]           # 004ef04b
    mov ecx, dword ptr [ebp - local_4]           # 004ef04e
    mov edx, dword ptr [ecx + field_13a]         # 004ef051
    mov dword ptr [eax + field_14a], edx         # 004ef057
    jmp.d8 L_004ef0b0                            # 004ef05d
L_004ef05f:
    # block 0x004ef05f: entered by je at 0x004ef037, 23 instruction(s), falls into the block at 0x004ef0b0
    mov eax, dword ptr [ebp - local_4]           # 004ef05f
    mov eax, dword ptr [eax + field_176]         # 004ef062
    cdq                                          # 004ef068
    {load} sub eax, edx                          # 004ef069
    sar eax                                      # 004ef06b
    mov ecx, dword ptr [ebp - local_4]           # 004ef06d
    mov ecx, dword ptr [ecx + field_132]         # 004ef070
    {load} add ecx, eax                          # 004ef076
    mov edx, dword ptr [ebp - local_4]           # 004ef078
    mov eax, dword ptr [edx + field_17e]         # 004ef07b
    cdq                                          # 004ef081
    {load} sub eax, edx                          # 004ef082
    sar eax                                      # 004ef084
    {load} sub ecx, eax                          # 004ef086
    mov eax, dword ptr [ebp - local_4]           # 004ef088
    mov dword ptr [eax + field_142], ecx         # 004ef08b
    mov ecx, dword ptr [ebp - local_4]           # 004ef091
    mov edx, dword ptr [ecx + field_142]         # 004ef094
    mov eax, dword ptr [ebp - local_4]           # 004ef09a
    mov ecx, dword ptr [eax + field_17e]         # 004ef09d
    lea edx, [edx + ecx - field_minus_1]         # 004ef0a3
    mov eax, dword ptr [ebp - local_4]           # 004ef0a7
    mov dword ptr [eax + field_14a], edx         # 004ef0aa
L_004ef0b0:
    # block 0x004ef0b0: entered by jmp at 0x004eef3f; jmp at 0x004eeff8; jmp at 0x004ef05d, 1 instruction(s), ends with forward jump to 0x004ef2c1
    jmp.d32 L_004ef2c1                           # 004ef0b0
L_004ef0b5:
    # block 0x004ef0b5: entered by je at 0x004eeef1, 14 instruction(s), ends with je to 0x004ef0fd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef0b5
    mov edx, dword ptr [ebp - local_4]           # 004ef0b8
    mov eax, dword ptr [ecx + field_13a]         # 004ef0bb
    sub eax, dword ptr [edx + field_132]         # 004ef0c1
    add eax, 0x1                                 # 004ef0c7
    mov ecx, dword ptr [ebp - local_4]           # 004ef0ca
    sub eax, dword ptr [ecx + field_17e]         # 004ef0cd
    mov edx, dword ptr [ebp - local_4]           # 004ef0d3
    mov dword ptr [edx + field_15e], eax         # 004ef0d6
    mov eax, dword ptr [ebp - local_4]           # 004ef0dc
    mov ecx, dword ptr [eax + field_d2]          # 004ef0df
    mov dword ptr [ebp - local_10], ecx          # 004ef0e5
    cmp dword ptr [ebp - local_10], 0x2          # 004ef0e8
    je.d8 L_004ef0fd                             # 004ef0ec
    # block 0x004ef0ee: entered by fall-through of je at 0x004ef0ec, 2 instruction(s), ends with je to 0x004ef1b6 (forward)
    cmp dword ptr [ebp - local_10], 0x3          # 004ef0ee
    je.d32 L_004ef1b6                            # 004ef0f2
    # block 0x004ef0f8: entered by fall-through of je at 0x004ef0f2, 1 instruction(s), ends with forward jump to 0x004ef269
    jmp.d32 L_004ef269                           # 004ef0f8
L_004ef0fd:
    # block 0x004ef0fd: entered by je at 0x004ef0ec, 14 instruction(s), ends with je to 0x004ef160 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef0fd
    mov eax, dword ptr [ebp - local_4]           # 004ef100
    mov ecx, dword ptr [eax + field_132]         # 004ef103
    mov dword ptr [edx + field_142], ecx         # 004ef109
    mov edx, dword ptr [ebp - local_4]           # 004ef10f
    mov eax, dword ptr [edx + field_132]         # 004ef112
    mov ecx, dword ptr [ebp - local_4]           # 004ef118
    mov edx, dword ptr [ecx + field_17e]         # 004ef11b
    lea eax, [eax + edx - field_minus_1]         # 004ef121
    mov ecx, dword ptr [ebp - local_4]           # 004ef125
    mov dword ptr [ecx + field_14a], eax         # 004ef128
    mov edx, dword ptr [ebp - local_4]           # 004ef12e
    cmp dword ptr [edx + field_1aa], 0x0         # 004ef131
    je.d8 L_004ef160                             # 004ef138
    # block 0x004ef13a: entered by fall-through of je at 0x004ef138, 9 instruction(s), ends with forward jump to 0x004ef1b1
    mov eax, dword ptr [ebp - local_4]           # 004ef13a
    mov ecx, dword ptr [ebp - local_4]           # 004ef13d
    mov edx, dword ptr [ecx + field_12e]         # 004ef140
    mov dword ptr [eax + field_13e], edx         # 004ef146
    mov eax, dword ptr [ebp - local_4]           # 004ef14c
    mov ecx, dword ptr [ebp - local_4]           # 004ef14f
    mov edx, dword ptr [ecx + field_136]         # 004ef152
    mov dword ptr [eax + field_146], edx         # 004ef158
    jmp.d8 L_004ef1b1                            # 004ef15e
L_004ef160:
    # block 0x004ef160: entered by je at 0x004ef138, 23 instruction(s), falls into the block at 0x004ef1b1
    mov eax, dword ptr [ebp - local_4]           # 004ef160
    mov eax, dword ptr [eax + field_172]         # 004ef163
    cdq                                          # 004ef169
    {load} sub eax, edx                          # 004ef16a
    sar eax                                      # 004ef16c
    mov ecx, dword ptr [ebp - local_4]           # 004ef16e
    mov ecx, dword ptr [ecx + field_12e]         # 004ef171
    {load} add ecx, eax                          # 004ef177
    mov edx, dword ptr [ebp - local_4]           # 004ef179
    mov eax, dword ptr [edx + field_17a]         # 004ef17c
    cdq                                          # 004ef182
    {load} sub eax, edx                          # 004ef183
    sar eax                                      # 004ef185
    {load} sub ecx, eax                          # 004ef187
    mov eax, dword ptr [ebp - local_4]           # 004ef189
    mov dword ptr [eax + field_13e], ecx         # 004ef18c
    mov ecx, dword ptr [ebp - local_4]           # 004ef192
    mov edx, dword ptr [ecx + field_13e]         # 004ef195
    mov eax, dword ptr [ebp - local_4]           # 004ef19b
    mov ecx, dword ptr [eax + field_17a]         # 004ef19e
    lea edx, [edx + ecx - field_minus_1]         # 004ef1a4
    mov eax, dword ptr [ebp - local_4]           # 004ef1a8
    mov dword ptr [eax + field_146], edx         # 004ef1ab
L_004ef1b1:
    # block 0x004ef1b1: entered by jmp at 0x004ef15e, 1 instruction(s), ends with forward jump to 0x004ef269
    jmp.d32 L_004ef269                           # 004ef1b1
L_004ef1b6:
    # block 0x004ef1b6: entered by je at 0x004ef0f2, 14 instruction(s), ends with je to 0x004ef218 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef1b6
    mov edx, dword ptr [ebp - local_4]           # 004ef1b9
    mov eax, dword ptr [edx + field_13a]         # 004ef1bc
    mov dword ptr [ecx + field_14a], eax         # 004ef1c2
    mov ecx, dword ptr [ebp - local_4]           # 004ef1c8
    mov edx, dword ptr [ebp - local_4]           # 004ef1cb
    mov eax, dword ptr [ecx + field_13a]         # 004ef1ce
    sub eax, dword ptr [edx + field_17e]         # 004ef1d4
    add eax, 0x1                                 # 004ef1da
    mov ecx, dword ptr [ebp - local_4]           # 004ef1dd
    mov dword ptr [ecx + field_142], eax         # 004ef1e0
    mov edx, dword ptr [ebp - local_4]           # 004ef1e6
    cmp dword ptr [edx + field_1aa], 0x0         # 004ef1e9
    je.d8 L_004ef218                             # 004ef1f0
    # block 0x004ef1f2: entered by fall-through of je at 0x004ef1f0, 9 instruction(s), ends with forward jump to 0x004ef269
    mov eax, dword ptr [ebp - local_4]           # 004ef1f2
    mov ecx, dword ptr [ebp - local_4]           # 004ef1f5
    mov edx, dword ptr [ecx + field_12e]         # 004ef1f8
    mov dword ptr [eax + field_13e], edx         # 004ef1fe
    mov eax, dword ptr [ebp - local_4]           # 004ef204
    mov ecx, dword ptr [ebp - local_4]           # 004ef207
    mov edx, dword ptr [ecx + field_136]         # 004ef20a
    mov dword ptr [eax + field_146], edx         # 004ef210
    jmp.d8 L_004ef269                            # 004ef216
L_004ef218:
    # block 0x004ef218: entered by je at 0x004ef1f0, 23 instruction(s), falls into the block at 0x004ef269
    mov eax, dword ptr [ebp - local_4]           # 004ef218
    mov eax, dword ptr [eax + field_172]         # 004ef21b
    cdq                                          # 004ef221
    {load} sub eax, edx                          # 004ef222
    sar eax                                      # 004ef224
    mov ecx, dword ptr [ebp - local_4]           # 004ef226
    mov ecx, dword ptr [ecx + field_12e]         # 004ef229
    {load} add ecx, eax                          # 004ef22f
    mov edx, dword ptr [ebp - local_4]           # 004ef231
    mov eax, dword ptr [edx + field_17a]         # 004ef234
    cdq                                          # 004ef23a
    {load} sub eax, edx                          # 004ef23b
    sar eax                                      # 004ef23d
    {load} sub ecx, eax                          # 004ef23f
    mov eax, dword ptr [ebp - local_4]           # 004ef241
    mov dword ptr [eax + field_13e], ecx         # 004ef244
    mov ecx, dword ptr [ebp - local_4]           # 004ef24a
    mov edx, dword ptr [ecx + field_13e]         # 004ef24d
    mov eax, dword ptr [ebp - local_4]           # 004ef253
    mov ecx, dword ptr [eax + field_17a]         # 004ef256
    lea edx, [edx + ecx - field_minus_1]         # 004ef25c
    mov eax, dword ptr [ebp - local_4]           # 004ef260
    mov dword ptr [eax + field_146], edx         # 004ef263
L_004ef269:
    # block 0x004ef269: entered by jmp at 0x004ef0f8; jmp at 0x004ef1b1; jmp at 0x004ef216, 1 instruction(s), ends with forward jump to 0x004ef2c1
    jmp.d8 L_004ef2c1                            # 004ef269
L_004ef26b:
    # block 0x004ef26b: entered by jmp at 0x004eeef7, 16 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004ef2b5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef26b
    mov edx, dword ptr [ecx + field_ce]          # 004ef26e
    push edx                                     # 004ef274
    mov eax, dword ptr [ebp - local_4]           # 004ef275
    mov ecx, dword ptr [eax + field_5a]          # 004ef278
    push ecx                                     # 004ef27b
    push 0x55ce88                                # 004ef27c
    push 0x63888b                                # 004ef281
    call FUN_0050ca3e                            # 004ef286
    add esp, 0x10                                # 004ef28b
    push 0x63888b                                # 004ef28e
    mov ecx, 0x583979                            # 004ef293
    call FUN_004264e8                            # 004ef298
    movsx edx, word ptr [0x63a4cd]               # 004ef29d
    test edx, edx                                # 004ef2a4
    je.d8 L_004ef2b5                             # 004ef2a6
    # block 0x004ef2a8: entered by fall-through of je at 0x004ef2a6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ef2b5
    push 0x63888b                                # 004ef2a8
    call FUN_0044a2b7                            # 004ef2ad
    add esp, 0x4                                 # 004ef2b2
L_004ef2b5:
    # block 0x004ef2b5: entered by je at 0x004ef2a6, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ef2c9
    mov ecx, 0x5cf659                            # 004ef2b5
    call FUN_004c97b4                            # 004ef2ba
    jmp.d8 L_004ef2c9                            # 004ef2bf
L_004ef2c1:
    # block 0x004ef2c1: entered by jmp at 0x004ef0b0; jmp at 0x004ef269, 2 instruction(s), calls FUN_004ef89b, falls into the block at 0x004ef2c9
    mov ecx, dword ptr [ebp - local_4]           # 004ef2c1
    call FUN_004ef89b                            # 004ef2c4
L_004ef2c9:
    # block 0x004ef2c9: entered by jmp at 0x004eeeb8; jmp at 0x004ef2bf, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004ef2c9
    pop esi                                      # 004ef2ca
    {load} mov esp, ebp                          # 004ef2cb
    pop ebp                                      # 004ef2cd
    ret 0x4                                      # 004ef2ce

