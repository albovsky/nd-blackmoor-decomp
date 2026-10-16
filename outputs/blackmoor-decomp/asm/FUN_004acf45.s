# FUN_004acf45
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004acf45
# extent:       0x004acf45-0x004ad1e5 (672 code bytes)
# span:         0x004acf45-0x004ad1e5 (code 672, tables 0, padding 0)
# sha256:       b398d62e011c59a660278a4f3b170c6da7db9f122ed4e8fa9d3f13c29e3159f0
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004acf45
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_6, field_e, field_24, field_c17, field_c1b, field_e57; [ecx + n] field_2, field_6, field_a, field_1c, field_20, field_24, field_27, field_42, field_6e, field_c17, field_c25, field_c29 and 3 more; [edx + n] field_2, field_4, field_8, field_c, field_24, field_26, field_32a, field_32e, field_332, field_336, field_e39
# callees:      calls FUN_004acdc2, FUN_004ad1e5, FUN_004aec35, FUN_004ae452, FUN_004ae495
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 183 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_42, 0x42  # offset +0x42
.equ field_6e, 0x6e  # offset +0x6e
.equ field_32a, 0x32a  # offset +0x32a
.equ field_32e, 0x32e  # offset +0x32e
.equ field_332, 0x332  # offset +0x332
.equ field_336, 0x336  # offset +0x336
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c1b, 0xc1b  # offset +0xc1b
.equ field_c25, 0xc25  # offset +0xc25
.equ field_c29, 0xc29  # offset +0xc29
.equ field_c2d, 0xc2d  # offset +0xc2d
.equ field_c31, 0xc31  # offset +0xc31
.equ field_e39, 0xe39  # offset +0xe39
.equ field_e57, 0xe57  # offset +0xe57

# --- external targets -----------------------------------------------
.set FUN_004acdc2, .text + (0x004acdc2 - 0x401000)
.set FUN_004ad1e5, .text + (0x004ad1e5 - 0x401000)
.set FUN_004ae452, .text + (0x004ae452 - 0x401000)
.set FUN_004ae495, .text + (0x004ae495 - 0x401000)
.set FUN_004aec35, .text + (0x004aec35 - 0x401000)

.org 0x004acf45 - 0x401000
.globl FUN_004acf45
FUN_004acf45:
    # block 0x004acf45: entry, 8 instruction(s), ends with je to 0x004ad1dc (forward)
    push ebp                                     # 004acf45
    {load} mov ebp, esp                          # 004acf46
    sub esp, 0x20                                # 004acf48
    push edi                                     # 004acf4b
    mov dword ptr [ebp - local_20], ecx          # 004acf4c
    mov eax, dword ptr [ebp - local_20]          # 004acf4f
    cmp dword ptr [eax + field_c1b], 0x0         # 004acf52
    je.d32 L_004ad1dc                            # 004acf59
    # block 0x004acf5f: entered by fall-through of je at 0x004acf59, 19 instruction(s), ends with je to 0x004ad027 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004acf5f
    mov edx, dword ptr [ebp + arg_10]            # 004acf62
    mov eax, dword ptr [edx + field_4]           # 004acf65
    mov dword ptr [ecx + field_c29], eax         # 004acf68
    mov ecx, dword ptr [ebp - local_20]          # 004acf6e
    mov edx, dword ptr [ebp + arg_10]            # 004acf71
    mov eax, dword ptr [edx + field_c]           # 004acf74
    mov dword ptr [ecx + field_c31], eax         # 004acf77
    mov ecx, dword ptr [ebp - local_20]          # 004acf7d
    mov edx, dword ptr [ebp + arg_10]            # 004acf80
    mov eax, dword ptr [edx]                     # 004acf83
    mov dword ptr [ecx + field_c25], eax         # 004acf85
    mov ecx, dword ptr [ebp - local_20]          # 004acf8b
    mov edx, dword ptr [ebp + arg_10]            # 004acf8e
    mov eax, dword ptr [edx + field_8]           # 004acf91
    mov dword ptr [ecx + field_c2d], eax         # 004acf94
    mov ecx, dword ptr [ebp - local_20]          # 004acf9a
    cmp dword ptr [ecx + field_20], 0x0          # 004acf9d
    je.d32 L_004ad027                            # 004acfa1
    # block 0x004acfa7: entered by fall-through of je at 0x004acfa1, 17 instruction(s), calls FUN_004acdc2, FUN_004ad1e5, FUN_004aec35, ends with je to 0x004ad00d (forward)
    mov edx, dword ptr [ebp - local_20]          # 004acfa7
    movsx eax, word ptr [edx + field_24]         # 004acfaa
    imul eax, eax, 0xc7                          # 004acfae
    mov ecx, dword ptr [ebp - local_20]          # 004acfb4
    lea edx, [ecx + eax + field_6e]              # 004acfb7
    mov dword ptr [ebp - local_1c], edx          # 004acfbb
    mov ecx, dword ptr [ebp - local_20]          # 004acfbe
    call FUN_004acdc2                            # 004acfc1
    push 0x2776                                  # 004acfc6
    mov ecx, dword ptr [ebp - local_20]          # 004acfcb
    call FUN_004ad1e5                            # 004acfce
    lea eax, [ebp - local_10]                    # 004acfd3
    push eax                                     # 004acfd6
    mov ecx, dword ptr [ebp - local_20]          # 004acfd7
    call FUN_004aec35                            # 004acfda
    test eax, eax                                # 004acfdf
    je.d8 L_004ad00d                             # 004acfe1
    # block 0x004acfe3: entered by fall-through of je at 0x004acfe1, 2 instruction(s), ends with je to 0x004acffb (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 004acfe3
    je.d8 L_004acffb                             # 004acfe7
    # block 0x004acfe9: entered by fall-through of je at 0x004acfe7, 6 instruction(s), calls FUN_004ae452, ends with forward jump to 0x004ad00b
    mov ecx, dword ptr [ebp - local_20]          # 004acfe9
    movsx edx, word ptr [ecx + field_24]         # 004acfec
    push edx                                     # 004acff0
    mov ecx, dword ptr [ebp - local_20]          # 004acff1
    call FUN_004ae452                            # 004acff4
    jmp.d8 L_004ad00b                            # 004acff9
L_004acffb:
    # block 0x004acffb: entered by je at 0x004acfe7, 5 instruction(s), calls FUN_004ae495, falls into the block at 0x004ad00b
    mov eax, dword ptr [ebp - local_20]          # 004acffb
    movsx ecx, word ptr [eax + field_24]         # 004acffe
    push ecx                                     # 004ad002
    mov ecx, dword ptr [ebp - local_20]          # 004ad003
    call FUN_004ae495                            # 004ad006
L_004ad00b:
    # block 0x004ad00b: entered by jmp at 0x004acff9, 1 instruction(s), ends with forward jump to 0x004ad01d
    jmp.d8 L_004ad01d                            # 004ad00b
L_004ad00d:
    # block 0x004ad00d: entered by je at 0x004acfe1, 5 instruction(s), calls FUN_004ae495, falls into the block at 0x004ad01d
    mov edx, dword ptr [ebp - local_20]          # 004ad00d
    movsx eax, word ptr [edx + field_24]         # 004ad010
    push eax                                     # 004ad014
    mov ecx, dword ptr [ebp - local_20]          # 004ad015
    call FUN_004ae495                            # 004ad018
L_004ad01d:
    # block 0x004ad01d: entered by jmp at 0x004ad00b, 2 instruction(s), ends with forward jump to 0x004ad1de
    mov eax, 0x1                                 # 004ad01d
    jmp.d32 L_004ad1de                           # 004ad022
L_004ad027:
    # block 0x004ad027: entered by je at 0x004acfa1, 10 instruction(s), ends with forward jump to 0x004ad059
    mov ecx, 0x7                                 # 004ad027
    {load} xor eax, eax                          # 004ad02c
    mov edi, dword ptr [ebp - local_20]          # 004ad02e
    add edi, 0xe39                               # 004ad031
    rep stosd dword ptr es:[edi], eax            # 004ad037
    stosw word ptr es:[edi], ax                  # 004ad039
    mov ecx, dword ptr [ebp - local_20]          # 004ad03b
    mov word ptr [ecx + field_e57], 0x0          # 004ad03e
    mov dword ptr [ebp - local_14], 0x0          # 004ad047
    jmp.d8 L_004ad059                            # 004ad04e
L_004ad050:
    # block 0x004ad050: entered by jmp at 0x004ad14d, 3 instruction(s), falls into the block at 0x004ad059
    mov edx, dword ptr [ebp - local_14]          # 004ad050
    add edx, 0x1                                 # 004ad053
    mov dword ptr [ebp - local_14], edx          # 004ad056
L_004ad059:
    # block 0x004ad059: entered by jmp at 0x004ad04e, 5 instruction(s), ends with jge to 0x004ad152 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004ad059
    mov ecx, dword ptr [eax + field_c17]         # 004ad05c
    movsx edx, word ptr [ecx + field_42]         # 004ad062
    cmp dword ptr [ebp - local_14], edx          # 004ad066
    jge.d32 L_004ad152                           # 004ad069
    # block 0x004ad06f: entered by fall-through of jge at 0x004ad069, 9 instruction(s), ends with jl to 0x004ad14d (forward)
    mov eax, dword ptr [ebp - local_14]          # 004ad06f
    imul eax, eax, 0xc7                          # 004ad072
    mov ecx, dword ptr [ebp - local_20]          # 004ad078
    lea edx, [ecx + eax + field_6e]              # 004ad07b
    mov dword ptr [ebp - local_1c], edx          # 004ad07f
    movsx eax, word ptr [ebp + arg_c]            # 004ad082
    mov ecx, dword ptr [ebp - local_1c]          # 004ad086
    cmp eax, dword ptr [ecx + field_6]           # 004ad089
    jl.d32 L_004ad14d                            # 004ad08c
    # block 0x004ad092: entered by fall-through of jl at 0x004ad08c, 4 instruction(s), ends with jg to 0x004ad14d (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004ad092
    mov eax, dword ptr [ebp - local_1c]          # 004ad096
    cmp edx, dword ptr [eax + field_e]           # 004ad099
    jg.d32 L_004ad14d                            # 004ad09c
    # block 0x004ad0a2: entered by fall-through of jg at 0x004ad09c, 4 instruction(s), ends with jl to 0x004ad14d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ad0a2
    mov edx, dword ptr [ebp - local_1c]          # 004ad0a6
    cmp ecx, dword ptr [edx + field_2]           # 004ad0a9
    jl.d32 L_004ad14d                            # 004ad0ac
    # block 0x004ad0b2: entered by fall-through of jl at 0x004ad0ac, 4 instruction(s), ends with jg to 0x004ad14d (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ad0b2
    mov ecx, dword ptr [ebp - local_1c]          # 004ad0b6
    cmp eax, dword ptr [ecx + field_a]           # 004ad0b9
    jg.d32 L_004ad14d                            # 004ad0bc
    # block 0x004ad0c2: entered by fall-through of jg at 0x004ad0bc, 29 instruction(s), ends with je to 0x004ad14d (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004ad0c2
    {load} xor eax, eax                          # 004ad0c5
    mov al, byte ptr [edx + field_26]            # 004ad0c7
    imul eax, eax, 0x28                          # 004ad0ca
    mov ecx, dword ptr [ebp - local_1c]          # 004ad0cd
    lea edx, [ecx + eax + field_27]              # 004ad0d0
    mov dword ptr [ebp - local_18], edx          # 004ad0d4
    movsx eax, word ptr [ebp + arg_8]            # 004ad0d7
    mov ecx, dword ptr [ebp - local_1c]          # 004ad0db
    sub eax, dword ptr [ecx + field_2]           # 004ad0de
    mov dword ptr [ebp - local_4], eax           # 004ad0e1
    movsx edx, word ptr [ebp + arg_c]            # 004ad0e4
    mov eax, dword ptr [ebp - local_1c]          # 004ad0e8
    sub edx, dword ptr [eax + field_6]           # 004ad0eb
    mov dword ptr [ebp - local_8], edx           # 004ad0ee
    mov ecx, dword ptr [ebp - local_18]          # 004ad0f1
    movsx edx, word ptr [ecx + field_20]         # 004ad0f4
    mov eax, dword ptr [ebp - local_8]           # 004ad0f8
    imul eax, edx                                # 004ad0fb
    mov ecx, dword ptr [ebp - local_18]          # 004ad0fe
    mov edx, dword ptr [ecx + field_1c]          # 004ad101
    {load} add edx, eax                          # 004ad104
    mov eax, dword ptr [ebp - local_4]           # 004ad106
    mov cl, byte ptr [edx + eax]                 # 004ad109
    mov byte ptr [ebp - local_c], cl             # 004ad10c
    mov edx, dword ptr [ebp - local_c]           # 004ad10f
    and edx, 0xff                                # 004ad112
    test edx, edx                                # 004ad118
    je.d8 L_004ad14d                             # 004ad11a
    # block 0x004ad11c: entered by fall-through of je at 0x004ad11a, 10 instruction(s), falls into the block at 0x004ad14d
    mov eax, dword ptr [ebp - local_20]          # 004ad11c
    movsx ecx, word ptr [eax + field_e57]        # 004ad11f
    mov edx, dword ptr [ebp - local_20]          # 004ad126
    mov ax, word ptr [ebp - local_14]            # 004ad129
    mov word ptr [edx + 2*ecx + field_e39], ax   # 004ad12d
    mov ecx, dword ptr [ebp - local_20]          # 004ad135
    mov dx, word ptr [ecx + field_e57]           # 004ad138
    add dx, 0x1                                  # 004ad13f
    mov eax, dword ptr [ebp - local_20]          # 004ad143
    mov word ptr [eax + field_e57], dx           # 004ad146
L_004ad14d:
    # block 0x004ad14d: entered by jl at 0x004ad08c; jg at 0x004ad09c; jl at 0x004ad0ac; jg at 0x004ad0bc; je at 0x004ad11a, 1 instruction(s), ends with backward jump to 0x004ad050
    jmp.d32 L_004ad050                           # 004ad14d
L_004ad152:
    # block 0x004ad152: entered by jge at 0x004ad069, 4 instruction(s), ends with je to 0x004ad174 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004ad152
    movsx edx, word ptr [ecx + field_e57]        # 004ad155
    test edx, edx                                # 004ad15c
    je.d8 L_004ad174                             # 004ad15e
    # block 0x004ad160: entered by fall-through of je at 0x004ad15e, 5 instruction(s), calls FUN_004ad1e5, ends with forward jump to 0x004ad1de
    push 0x2774                                  # 004ad160
    mov ecx, dword ptr [ebp - local_20]          # 004ad165
    call FUN_004ad1e5                            # 004ad168
    mov eax, 0x1                                 # 004ad16d
    jmp.d8 L_004ad1de                            # 004ad172
L_004ad174:
    # block 0x004ad174: entered by je at 0x004ad15e, 5 instruction(s), ends with jl to 0x004ad1dc (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ad174
    mov ecx, dword ptr [ebp - local_20]          # 004ad178
    mov edx, dword ptr [ecx + field_c17]         # 004ad17b
    cmp eax, dword ptr [edx + field_32e]         # 004ad181
    jl.d8 L_004ad1dc                             # 004ad187
    # block 0x004ad189: entered by fall-through of jl at 0x004ad187, 5 instruction(s), ends with jg to 0x004ad1dc (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ad189
    mov ecx, dword ptr [ebp - local_20]          # 004ad18d
    mov edx, dword ptr [ecx + field_c17]         # 004ad190
    cmp eax, dword ptr [edx + field_336]         # 004ad196
    jg.d8 L_004ad1dc                             # 004ad19c
    # block 0x004ad19e: entered by fall-through of jg at 0x004ad19c, 5 instruction(s), ends with jl to 0x004ad1dc (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ad19e
    mov ecx, dword ptr [ebp - local_20]          # 004ad1a2
    mov edx, dword ptr [ecx + field_c17]         # 004ad1a5
    cmp eax, dword ptr [edx + field_32a]         # 004ad1ab
    jl.d8 L_004ad1dc                             # 004ad1b1
    # block 0x004ad1b3: entered by fall-through of jl at 0x004ad1b1, 5 instruction(s), ends with jg to 0x004ad1dc (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ad1b3
    mov ecx, dword ptr [ebp - local_20]          # 004ad1b7
    mov edx, dword ptr [ecx + field_c17]         # 004ad1ba
    cmp eax, dword ptr [edx + field_332]         # 004ad1c0
    jg.d8 L_004ad1dc                             # 004ad1c6
    # block 0x004ad1c8: entered by fall-through of jg at 0x004ad1c6, 5 instruction(s), calls FUN_004ad1e5, ends with forward jump to 0x004ad1de
    push 0x2775                                  # 004ad1c8
    mov ecx, dword ptr [ebp - local_20]          # 004ad1cd
    call FUN_004ad1e5                            # 004ad1d0
    mov eax, 0x1                                 # 004ad1d5
    jmp.d8 L_004ad1de                            # 004ad1da
L_004ad1dc:
    # block 0x004ad1dc: entered by je at 0x004acf59; jl at 0x004ad187; jg at 0x004ad19c; jl at 0x004ad1b1; jg at 0x004ad1c6, 1 instruction(s), falls into the block at 0x004ad1de
    {load} xor eax, eax                          # 004ad1dc
L_004ad1de:
    # block 0x004ad1de: entered by jmp at 0x004ad022; jmp at 0x004ad172; jmp at 0x004ad1da, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 004ad1de
    {load} mov esp, ebp                          # 004ad1df
    pop ebp                                      # 004ad1e1
    ret 0xc                                      # 004ad1e2

