# FUN_004cbba9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cbba9
# extent:       0x004cbba9-0x004cbf72 (969 code bytes)
# span:         0x004cbba9-0x004cbf72 (code 969, tables 0, padding 0)
# sha256:       43560a4a3b0918e72ad68874b74f2341659055c4e94a18a376ba2df825f43a56
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cbba9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1a, field_122, field_12a, field_12e; [ecx + n] field_2, field_1a, field_21, field_122, field_12a, field_12e; [edx + n] field_2, field_9, field_1a, field_25, field_122, field_12a, field_12e
# callees:      calls FUN_004cbb00, FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_004cc70f, FUN_0050cf61, FUN_0050cee4, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 292 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_122, 0x122  # offset +0x122
.equ field_12a, 0x12a  # offset +0x12a
.equ field_12e, 0x12e  # offset +0x12e

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cbb00, .text + (0x004cbb00 - 0x401000)
.set FUN_004cc70f, .text + (0x004cc70f - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x004cbba9 - 0x401000
.globl FUN_004cbba9
FUN_004cbba9:
    # block 0x004cbba9: entry, 8 instruction(s), ends with je to 0x004cbbc2 (forward)
    push ebp                                     # 004cbba9
    {load} mov ebp, esp                          # 004cbbaa
    push ecx                                     # 004cbbac
    push edi                                     # 004cbbad
    mov dword ptr [ebp - local_4], ecx           # 004cbbae
    mov eax, dword ptr [ebp - local_4]           # 004cbbb1
    cmp dword ptr [eax + field_1a], 0x0          # 004cbbb4
    je.d8 L_004cbbc2                             # 004cbbb8
    # block 0x004cbbba: entered by fall-through of je at 0x004cbbb8, 2 instruction(s), calls FUN_004cbb00, falls into the block at 0x004cbbc2
    mov ecx, dword ptr [ebp - local_4]           # 004cbbba
    call FUN_004cbb00                            # 004cbbbd
L_004cbbc2:
    # block 0x004cbbc2: entered by je at 0x004cbbb8, 8 instruction(s), ends with jne to 0x004cbbf0 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 004cbbc2
    or ecx, -0x1                                 # 004cbbc5
    {load} xor eax, eax                          # 004cbbc8
    repne scasb al, byte ptr es:[edi]            # 004cbbca
    not ecx                                      # 004cbbcc
    add ecx, -0x1                                # 004cbbce
    test ecx, ecx                                # 004cbbd1
    jne.d8 L_004cbbf0                            # 004cbbd3
    # block 0x004cbbd5: entered by fall-through of jne at 0x004cbbd3, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cbf69
    mov ecx, dword ptr [ebp + arg_8]             # 004cbbd5
    push ecx                                     # 004cbbd8
    push 0x558c48                                # 004cbbd9
    push 0x63888b                                # 004cbbde
    call FUN_0050ca3e                            # 004cbbe3
    add esp, 0xc                                 # 004cbbe8
    jmp.d32 L_004cbf69                           # 004cbbeb
L_004cbbf0:
    # block 0x004cbbf0: entered by jne at 0x004cbbd3, 2 instruction(s), ends with je to 0x004cbc1d (forward)
    cmp dword ptr [0x5bb1fa], 0x0                # 004cbbf0
    je.d8 L_004cbc1d                             # 004cbbf7
    # block 0x004cbbf9: entered by fall-through of je at 0x004cbbf7, 11 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x004cbc3f
    push 0x558c98                                # 004cbbf9
    mov edx, dword ptr [ebp + arg_8]             # 004cbbfe
    push edx                                     # 004cbc01
    push 0x639db1                                # 004cbc02
    push 0x639da2                                # 004cbc07
    mov eax, dword ptr [ebp - local_4]           # 004cbc0c
    add eax, 0x1e                                # 004cbc0f
    push eax                                     # 004cbc12
    call FUN_0050cd72                            # 004cbc13
    add esp, 0x14                                # 004cbc18
    jmp.d8 L_004cbc3f                            # 004cbc1b
L_004cbc1d:
    # block 0x004cbc1d: entered by je at 0x004cbbf7, 10 instruction(s), calls FUN_0050cd72, falls into the block at 0x004cbc3f
    push 0x558c9c                                # 004cbc1d
    mov ecx, dword ptr [ebp + arg_8]             # 004cbc22
    push ecx                                     # 004cbc25
    push 0x639db1                                # 004cbc26
    push 0x639dae                                # 004cbc2b
    mov edx, dword ptr [ebp - local_4]           # 004cbc30
    add edx, 0x1e                                # 004cbc33
    push edx                                     # 004cbc36
    call FUN_0050cd72                            # 004cbc37
    add esp, 0x14                                # 004cbc3c
L_004cbc3f:
    # block 0x004cbc3f: entered by jmp at 0x004cbc1b, 13 instruction(s), calls FUN_0050d0a9, ends with jne to 0x004cbc93 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cbc3f
    mov dword ptr [eax + field_12a], 0x0         # 004cbc42
    push 0x558ca0                                # 004cbc4c
    mov ecx, dword ptr [ebp - local_4]           # 004cbc51
    add ecx, 0x1e                                # 004cbc54
    push ecx                                     # 004cbc57
    call FUN_0050d0a9                            # 004cbc58
    add esp, 0x8                                 # 004cbc5d
    mov edx, dword ptr [ebp - local_4]           # 004cbc60
    mov dword ptr [edx + field_12a], eax         # 004cbc63
    mov eax, dword ptr [ebp - local_4]           # 004cbc69
    cmp dword ptr [eax + field_12a], 0x0         # 004cbc6c
    jne.d8 L_004cbc93                            # 004cbc73
    # block 0x004cbc75: entered by fall-through of jne at 0x004cbc73, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cbf67
    mov ecx, dword ptr [ebp - local_4]           # 004cbc75
    add ecx, 0x1e                                # 004cbc78
    push ecx                                     # 004cbc7b
    push 0x558ca4                                # 004cbc7c
    push 0x63888b                                # 004cbc81
    call FUN_0050ca3e                            # 004cbc86
    add esp, 0xc                                 # 004cbc8b
    jmp.d32 L_004cbf67                           # 004cbc8e
L_004cbc93:
    # block 0x004cbc93: entered by jne at 0x004cbc73, 18 instruction(s), calls FUN_004cc70f, FUN_0050cf61, ends with jne to 0x004cbceb (forward)
    push 0x29                                    # 004cbc93
    mov edx, dword ptr [ebp - local_4]           # 004cbc95
    add edx, 0x1a                                # 004cbc98
    push edx                                     # 004cbc9b
    mov ecx, dword ptr [ebp - local_4]           # 004cbc9c
    call FUN_004cc70f                            # 004cbc9f
    mov eax, dword ptr [ebp - local_4]           # 004cbca4
    mov ecx, dword ptr [eax + field_12a]         # 004cbca7
    push ecx                                     # 004cbcad
    push 0x1                                     # 004cbcae
    push 0x21                                    # 004cbcb0
    mov edx, dword ptr [ebp - local_4]           # 004cbcb2
    mov eax, dword ptr [edx + field_1a]          # 004cbcb5
    push eax                                     # 004cbcb8
    call FUN_0050cf61                            # 004cbcb9
    add esp, 0x10                                # 004cbcbe
    cmp eax, 0x1                                 # 004cbcc1
    jne.d8 L_004cbceb                            # 004cbcc4
    # block 0x004cbcc6: entered by fall-through of jne at 0x004cbcc4, 13 instruction(s), calls FUN_0050cf61, ends with je to 0x004cbd09 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cbcc6
    mov edx, dword ptr [ecx + field_12a]         # 004cbcc9
    push edx                                     # 004cbccf
    push 0x1                                     # 004cbcd0
    push 0x4                                     # 004cbcd2
    mov eax, dword ptr [ebp - local_4]           # 004cbcd4
    mov ecx, dword ptr [eax + field_1a]          # 004cbcd7
    add ecx, 0x21                                # 004cbcda
    push ecx                                     # 004cbcdd
    call FUN_0050cf61                            # 004cbcde
    add esp, 0x10                                # 004cbce3
    cmp eax, 0x1                                 # 004cbce6
    je.d8 L_004cbd09                             # 004cbce9
L_004cbceb:
    # block 0x004cbceb: entered by jne at 0x004cbcc4; fall-through of je at 0x004cbce9, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cbf65
    mov edx, dword ptr [ebp - local_4]           # 004cbceb
    add edx, 0x1e                                # 004cbcee
    push edx                                     # 004cbcf1
    push 0x558cf4                                # 004cbcf2
    push 0x63888b                                # 004cbcf7
    call FUN_0050ca3e                            # 004cbcfc
    add esp, 0xc                                 # 004cbd01
    jmp.d32 L_004cbf65                           # 004cbd04
L_004cbd09:
    # block 0x004cbd09: entered by je at 0x004cbce9, 14 instruction(s), calls FUN_004cc70f, ends with forward jump to 0x004cbd4c
    mov eax, dword ptr [ebp - local_4]           # 004cbd09
    mov ecx, dword ptr [eax + field_1a]          # 004cbd0c
    mov edx, dword ptr [ecx + field_21]          # 004cbd0f
    imul edx, edx, 0xd                           # 004cbd12
    push edx                                     # 004cbd15
    mov eax, dword ptr [ebp - local_4]           # 004cbd16
    mov ecx, dword ptr [eax + field_1a]          # 004cbd19
    add ecx, 0x25                                # 004cbd1c
    push ecx                                     # 004cbd1f
    mov ecx, dword ptr [ebp - local_4]           # 004cbd20
    call FUN_004cc70f                            # 004cbd23
    mov edx, dword ptr [ebp - local_4]           # 004cbd28
    mov dword ptr [edx + field_12e], 0x0         # 004cbd2b
    jmp.d8 L_004cbd4c                            # 004cbd35
L_004cbd37:
    # block 0x004cbd37: entered by jmp at 0x004cbef7, 5 instruction(s), falls into the block at 0x004cbd4c
    mov eax, dword ptr [ebp - local_4]           # 004cbd37
    mov ecx, dword ptr [eax + field_12e]         # 004cbd3a
    add ecx, 0x1                                 # 004cbd40
    mov edx, dword ptr [ebp - local_4]           # 004cbd43
    mov dword ptr [edx + field_12e], ecx         # 004cbd46
L_004cbd4c:
    # block 0x004cbd4c: entered by jmp at 0x004cbd35, 6 instruction(s), ends with jge to 0x004cbefc (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cbd4c
    mov ecx, dword ptr [eax + field_1a]          # 004cbd4f
    mov edx, dword ptr [ebp - local_4]           # 004cbd52
    mov eax, dword ptr [edx + field_12e]         # 004cbd55
    cmp eax, dword ptr [ecx + field_21]          # 004cbd5b
    jge.d32 L_004cbefc                           # 004cbd5e
    # block 0x004cbd64: entered by fall-through of jge at 0x004cbd5e, 21 instruction(s), calls FUN_0050cf61, ends with jne to 0x004cbe4d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cbd64
    mov edx, dword ptr [ecx + field_1a]          # 004cbd67
    mov eax, dword ptr [ebp - local_4]           # 004cbd6a
    mov ecx, dword ptr [eax + field_12e]         # 004cbd6d
    imul ecx, ecx, 0xd                           # 004cbd73
    mov edx, dword ptr [edx + field_25]          # 004cbd76
    {load} add edx, ecx                          # 004cbd79
    mov eax, dword ptr [ebp - local_4]           # 004cbd7b
    mov dword ptr [eax + field_122], edx         # 004cbd7e
    mov ecx, dword ptr [ebp - local_4]           # 004cbd84
    mov edx, dword ptr [ecx + field_12a]         # 004cbd87
    push edx                                     # 004cbd8d
    push 0x1                                     # 004cbd8e
    push 0x2                                     # 004cbd90
    mov eax, dword ptr [ebp - local_4]           # 004cbd92
    mov ecx, dword ptr [eax + field_122]         # 004cbd95
    push ecx                                     # 004cbd9b
    call FUN_0050cf61                            # 004cbd9c
    add esp, 0x10                                # 004cbda1
    cmp eax, 0x1                                 # 004cbda4
    jne.d32 L_004cbe4d                           # 004cbda7
    # block 0x004cbdad: entered by fall-through of jne at 0x004cbda7, 13 instruction(s), calls FUN_0050cf61, ends with jne to 0x004cbe4d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cbdad
    mov eax, dword ptr [edx + field_12a]         # 004cbdb0
    push eax                                     # 004cbdb6
    push 0x1                                     # 004cbdb7
    push 0x2                                     # 004cbdb9
    mov ecx, dword ptr [ebp - local_4]           # 004cbdbb
    mov edx, dword ptr [ecx + field_122]         # 004cbdbe
    add edx, 0x2                                 # 004cbdc4
    push edx                                     # 004cbdc7
    call FUN_0050cf61                            # 004cbdc8
    add esp, 0x10                                # 004cbdcd
    cmp eax, 0x1                                 # 004cbdd0
    jne.d8 L_004cbe4d                            # 004cbdd3
    # block 0x004cbdd5: entered by fall-through of jne at 0x004cbdd3, 13 instruction(s), calls FUN_0050cf61, ends with jne to 0x004cbe4d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cbdd5
    mov ecx, dword ptr [eax + field_12a]         # 004cbdd8
    push ecx                                     # 004cbdde
    push 0x1                                     # 004cbddf
    push 0x1                                     # 004cbde1
    mov edx, dword ptr [ebp - local_4]           # 004cbde3
    mov eax, dword ptr [edx + field_122]         # 004cbde6
    add eax, 0x4                                 # 004cbdec
    push eax                                     # 004cbdef
    call FUN_0050cf61                            # 004cbdf0
    add esp, 0x10                                # 004cbdf5
    cmp eax, 0x1                                 # 004cbdf8
    jne.d8 L_004cbe4d                            # 004cbdfb
    # block 0x004cbdfd: entered by fall-through of jne at 0x004cbdfb, 13 instruction(s), calls FUN_0050cf61, ends with jne to 0x004cbe4d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cbdfd
    mov edx, dword ptr [ecx + field_12a]         # 004cbe00
    push edx                                     # 004cbe06
    push 0x1                                     # 004cbe07
    push 0x2                                     # 004cbe09
    mov eax, dword ptr [ebp - local_4]           # 004cbe0b
    mov ecx, dword ptr [eax + field_122]         # 004cbe0e
    add ecx, 0x5                                 # 004cbe14
    push ecx                                     # 004cbe17
    call FUN_0050cf61                            # 004cbe18
    add esp, 0x10                                # 004cbe1d
    cmp eax, 0x1                                 # 004cbe20
    jne.d8 L_004cbe4d                            # 004cbe23
    # block 0x004cbe25: entered by fall-through of jne at 0x004cbe23, 13 instruction(s), calls FUN_0050cf61, ends with je to 0x004cbe75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cbe25
    mov eax, dword ptr [edx + field_12a]         # 004cbe28
    push eax                                     # 004cbe2e
    push 0x1                                     # 004cbe2f
    push 0x2                                     # 004cbe31
    mov ecx, dword ptr [ebp - local_4]           # 004cbe33
    mov edx, dword ptr [ecx + field_122]         # 004cbe36
    add edx, 0x7                                 # 004cbe3c
    push edx                                     # 004cbe3f
    call FUN_0050cf61                            # 004cbe40
    add esp, 0x10                                # 004cbe45
    cmp eax, 0x1                                 # 004cbe48
    je.d8 L_004cbe75                             # 004cbe4b
L_004cbe4d:
    # block 0x004cbe4d: entered by jne at 0x004cbda7; jne at 0x004cbdd3; jne at 0x004cbdfb; jne at 0x004cbe23; more, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cbf63
    mov eax, dword ptr [ebp - local_4]           # 004cbe4d
    add eax, 0x1e                                # 004cbe50
    push eax                                     # 004cbe53
    mov ecx, dword ptr [ebp - local_4]           # 004cbe54
    mov edx, dword ptr [ecx + field_12e]         # 004cbe57
    push edx                                     # 004cbe5d
    push 0x558d64                                # 004cbe5e
    push 0x63888b                                # 004cbe63
    call FUN_0050ca3e                            # 004cbe68
    add esp, 0x10                                # 004cbe6d
    jmp.d32 L_004cbf63                           # 004cbe70
L_004cbe75:
    # block 0x004cbe75: entered by je at 0x004cbe4b, 28 instruction(s), calls FUN_004cc70f, FUN_0050cf61, ends with je to 0x004cbef7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cbe75
    mov ecx, dword ptr [eax + field_122]         # 004cbe78
    movsx edx, word ptr [ecx + field_2]          # 004cbe7e
    imul edx, edx, 0x18                          # 004cbe82
    push edx                                     # 004cbe85
    mov eax, dword ptr [ebp - local_4]           # 004cbe86
    mov ecx, dword ptr [eax + field_122]         # 004cbe89
    add ecx, 0x9                                 # 004cbe8f
    push ecx                                     # 004cbe92
    mov ecx, dword ptr [ebp - local_4]           # 004cbe93
    call FUN_004cc70f                            # 004cbe96
    mov edx, dword ptr [ebp - local_4]           # 004cbe9b
    mov eax, dword ptr [edx + field_12a]         # 004cbe9e
    push eax                                     # 004cbea4
    push 0x1                                     # 004cbea5
    mov ecx, dword ptr [ebp - local_4]           # 004cbea7
    mov edx, dword ptr [ecx + field_122]         # 004cbeaa
    movsx eax, word ptr [edx + field_2]          # 004cbeb0
    imul eax, eax, 0x18                          # 004cbeb4
    push eax                                     # 004cbeb7
    mov ecx, dword ptr [ebp - local_4]           # 004cbeb8
    mov edx, dword ptr [ecx + field_122]         # 004cbebb
    mov eax, dword ptr [edx + field_9]           # 004cbec1
    push eax                                     # 004cbec4
    call FUN_0050cf61                            # 004cbec5
    add esp, 0x10                                # 004cbeca
    cmp eax, 0x1                                 # 004cbecd
    je.d8 L_004cbef7                             # 004cbed0
    # block 0x004cbed2: entered by fall-through of je at 0x004cbed0, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cbf61
    mov ecx, dword ptr [ebp - local_4]           # 004cbed2
    add ecx, 0x1e                                # 004cbed5
    push ecx                                     # 004cbed8
    mov edx, dword ptr [ebp - local_4]           # 004cbed9
    mov eax, dword ptr [edx + field_12e]         # 004cbedc
    push eax                                     # 004cbee2
    push 0x558dc8                                # 004cbee3
    push 0x63888b                                # 004cbee8
    call FUN_0050ca3e                            # 004cbeed
    add esp, 0x10                                # 004cbef2
    jmp.d8 L_004cbf61                            # 004cbef5
L_004cbef7:
    # block 0x004cbef7: entered by je at 0x004cbed0, 1 instruction(s), ends with backward jump to 0x004cbd37
    jmp.d32 L_004cbd37                           # 004cbef7
L_004cbefc:
    # block 0x004cbefc: entered by jge at 0x004cbd5e, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x004cbf6b
    mov ecx, dword ptr [ebp - local_4]           # 004cbefc
    mov edx, dword ptr [ecx + field_12a]         # 004cbeff
    push edx                                     # 004cbf05
    call FUN_0050cee4                            # 004cbf06
    add esp, 0x4                                 # 004cbf0b
    jmp.d8 L_004cbf6b                            # 004cbf0e
L_004cbf10:
    # block 0x004cbf10: entered by jmp at 0x004cbf61; jmp at 0x004cbf63; jmp at 0x004cbf65; jmp at 0x004cbf67; more, 6 instruction(s), calls FUN_004264e8, ends with je to 0x004cbf37 (forward)
    push 0x63888b                                # 004cbf10
    mov ecx, 0x583979                            # 004cbf15
    call FUN_004264e8                            # 004cbf1a
    movsx eax, word ptr [0x63a4cd]               # 004cbf1f
    test eax, eax                                # 004cbf26
    je.d8 L_004cbf37                             # 004cbf28
    # block 0x004cbf2a: entered by fall-through of je at 0x004cbf28, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cbf37
    push 0x63888b                                # 004cbf2a
    call FUN_0044a2b7                            # 004cbf2f
    add esp, 0x4                                 # 004cbf34
L_004cbf37:
    # block 0x004cbf37: entered by je at 0x004cbf28, 3 instruction(s), ends with je to 0x004cbf55 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cbf37
    cmp dword ptr [ecx + field_12a], 0x0         # 004cbf3a
    je.d8 L_004cbf55                             # 004cbf41
    # block 0x004cbf43: entered by fall-through of je at 0x004cbf41, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x004cbf55
    mov edx, dword ptr [ebp - local_4]           # 004cbf43
    mov eax, dword ptr [edx + field_12a]         # 004cbf46
    push eax                                     # 004cbf4c
    call FUN_0050cee4                            # 004cbf4d
    add esp, 0x4                                 # 004cbf52
L_004cbf55:
    # block 0x004cbf55: entered by je at 0x004cbf41, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cbf6b
    mov ecx, 0x5cf659                            # 004cbf55
    call FUN_004c97b4                            # 004cbf5a
    jmp.d8 L_004cbf6b                            # 004cbf5f
L_004cbf61:
    # block 0x004cbf61: entered by jmp at 0x004cbef5, 1 instruction(s), ends with backward jump to 0x004cbf10
    jmp.d8 L_004cbf10                            # 004cbf61
L_004cbf63:
    # block 0x004cbf63: entered by jmp at 0x004cbe70, 1 instruction(s), ends with backward jump to 0x004cbf10
    jmp.d8 L_004cbf10                            # 004cbf63
L_004cbf65:
    # block 0x004cbf65: entered by jmp at 0x004cbd04, 1 instruction(s), ends with backward jump to 0x004cbf10
    jmp.d8 L_004cbf10                            # 004cbf65
L_004cbf67:
    # block 0x004cbf67: entered by jmp at 0x004cbc8e, 1 instruction(s), ends with backward jump to 0x004cbf10
    jmp.d8 L_004cbf10                            # 004cbf67
L_004cbf69:
    # block 0x004cbf69: entered by jmp at 0x004cbbeb, 1 instruction(s), ends with backward jump to 0x004cbf10
    jmp.d8 L_004cbf10                            # 004cbf69
L_004cbf6b:
    # block 0x004cbf6b: entered by jmp at 0x004cbf0e; jmp at 0x004cbf5f, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004cbf6b
    {load} mov esp, ebp                          # 004cbf6c
    pop ebp                                      # 004cbf6e
    ret 0x4                                      # 004cbf6f

