# FUN_004edcb1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004edcb1
# extent:       0x004edcb1-0x004edf96 (741 code bytes)
# span:         0x004edcb1-0x004edf96 (code 741, tables 0, padding 0)
# sha256:       001d6ef919032a37aa553d7cd4463f5182487bf33e5be27eaf034851e0d0b67e
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004edcb1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_20, field_24, field_28, field_51, field_93, field_15f, field_665, field_669 and 6 more; [ecx + n] field_4, field_8, field_c, field_51, field_73, field_77, field_7b, field_7f, field_83, field_87, field_8b, field_8f and 2 more; [edx + n] field_4, field_8, field_c, field_252, field_679, field_681
# callees:      calls FUN_004edae5, FUN_004fb77a, FUN_004e1db3, FUN_004eeb23
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 186 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_51, 0x51  # offset +0x51
.equ field_73, 0x73  # offset +0x73
.equ field_77, 0x77  # offset +0x77
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7f, 0x7f  # offset +0x7f
.equ field_83, 0x83  # offset +0x83
.equ field_87, 0x87  # offset +0x87
.equ field_8b, 0x8b  # offset +0x8b
.equ field_8f, 0x8f  # offset +0x8f
.equ field_93, 0x93  # offset +0x93
.equ field_15f, 0x15f  # offset +0x15f
.equ field_252, 0x252  # offset +0x252
.equ field_665, 0x665  # offset +0x665
.equ field_669, 0x669  # offset +0x669
.equ field_66d, 0x66d  # offset +0x66d
.equ field_671, 0x671  # offset +0x671
.equ field_675, 0x675  # offset +0x675
.equ field_679, 0x679  # offset +0x679
.equ field_67d, 0x67d  # offset +0x67d
.equ field_681, 0x681  # offset +0x681

# --- external targets -----------------------------------------------
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)
.set FUN_004edae5, .text + (0x004edae5 - 0x401000)
.set FUN_004eeb23, .text + (0x004eeb23 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004edcb1 - 0x401000
.globl FUN_004edcb1
FUN_004edcb1:
    # block 0x004edcb1: entry, 16 instruction(s), calls FUN_004edae5, ends with je to 0x004edd8c (forward)
    push ebp                                     # 004edcb1
    {load} mov ebp, esp                          # 004edcb2
    push ecx                                     # 004edcb4
    push esi                                     # 004edcb5
    push edi                                     # 004edcb6
    mov dword ptr [ebp - local_4], ecx           # 004edcb7
    mov ecx, dword ptr [ebp - local_4]           # 004edcba
    call FUN_004edae5                            # 004edcbd
    mov edi, dword ptr [ebp - local_4]           # 004edcc2
    add edi, 0x2c                                # 004edcc5
    mov ecx, 0xbc                                # 004edcc8
    mov esi, dword ptr [ebp + arg_8]             # 004edccd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004edcd0
    mov eax, dword ptr [ebp - local_4]           # 004edcd2
    cmp dword ptr [eax + field_93], 0x0          # 004edcd5
    je.d32 L_004edd8c                            # 004edcdc
    # block 0x004edce2: entered by fall-through of je at 0x004edcdc, 41 instruction(s), ends with forward jump to 0x004eddd5
    mov ecx, dword ptr [ebp - local_4]           # 004edce2
    mov edx, dword ptr [ecx + field_73]          # 004edce5
    add edx, dword ptr [0x583186]                # 004edce8
    mov eax, dword ptr [ebp - local_4]           # 004edcee
    mov dword ptr [eax + field_1c], edx          # 004edcf1
    mov ecx, dword ptr [ebp - local_4]           # 004edcf4
    mov edx, dword ptr [ecx + field_7b]          # 004edcf7
    add edx, dword ptr [0x583186]                # 004edcfa
    mov eax, dword ptr [ebp - local_4]           # 004edd00
    mov dword ptr [eax + field_24], edx          # 004edd03
    mov ecx, dword ptr [ebp - local_4]           # 004edd06
    mov edx, dword ptr [ecx + field_77]          # 004edd09
    add edx, dword ptr [0x58318a]                # 004edd0c
    mov eax, dword ptr [ebp - local_4]           # 004edd12
    mov dword ptr [eax + field_20], edx          # 004edd15
    mov ecx, dword ptr [ebp - local_4]           # 004edd18
    mov edx, dword ptr [ecx + field_7f]          # 004edd1b
    add edx, dword ptr [0x58318a]                # 004edd1e
    mov eax, dword ptr [ebp - local_4]           # 004edd24
    mov dword ptr [eax + field_28], edx          # 004edd27
    mov ecx, dword ptr [ebp - local_4]           # 004edd2a
    mov edx, dword ptr [ecx + field_83]          # 004edd2d
    add edx, dword ptr [0x583186]                # 004edd33
    mov eax, dword ptr [ebp - local_4]           # 004edd39
    mov dword ptr [eax + field_665], edx         # 004edd3c
    mov ecx, dword ptr [ebp - local_4]           # 004edd42
    mov edx, dword ptr [ecx + field_8b]          # 004edd45
    add edx, dword ptr [0x583186]                # 004edd4b
    mov eax, dword ptr [ebp - local_4]           # 004edd51
    mov dword ptr [eax + field_66d], edx         # 004edd54
    mov ecx, dword ptr [ebp - local_4]           # 004edd5a
    mov edx, dword ptr [ecx + field_87]          # 004edd5d
    add edx, dword ptr [0x58318a]                # 004edd63
    mov eax, dword ptr [ebp - local_4]           # 004edd69
    mov dword ptr [eax + field_669], edx         # 004edd6c
    mov ecx, dword ptr [ebp - local_4]           # 004edd72
    mov edx, dword ptr [ecx + field_8f]          # 004edd75
    add edx, dword ptr [0x58318a]                # 004edd7b
    mov eax, dword ptr [ebp - local_4]           # 004edd81
    mov dword ptr [eax + field_671], edx         # 004edd84
    jmp.d8 L_004eddd5                            # 004edd8a
L_004edd8c:
    # block 0x004edd8c: entered by je at 0x004edcdc, 24 instruction(s), falls into the block at 0x004eddd5
    mov ecx, dword ptr [ebp - local_4]           # 004edd8c
    add ecx, 0x73                                # 004edd8f
    mov edx, dword ptr [ebp - local_4]           # 004edd92
    add edx, 0x1c                                # 004edd95
    mov eax, dword ptr [ecx]                     # 004edd98
    mov dword ptr [edx], eax                     # 004edd9a
    mov eax, dword ptr [ecx + field_4]           # 004edd9c
    mov dword ptr [edx + field_4], eax           # 004edd9f
    mov eax, dword ptr [ecx + field_8]           # 004edda2
    mov dword ptr [edx + field_8], eax           # 004edda5
    mov ecx, dword ptr [ecx + field_c]           # 004edda8
    mov dword ptr [edx + field_c], ecx           # 004eddab
    mov edx, dword ptr [ebp - local_4]           # 004eddae
    add edx, 0x83                                # 004eddb1
    mov eax, dword ptr [ebp - local_4]           # 004eddb7
    add eax, 0x665                               # 004eddba
    mov ecx, dword ptr [edx]                     # 004eddbf
    mov dword ptr [eax], ecx                     # 004eddc1
    mov ecx, dword ptr [edx + field_4]           # 004eddc3
    mov dword ptr [eax + field_4], ecx           # 004eddc6
    mov ecx, dword ptr [edx + field_8]           # 004eddc9
    mov dword ptr [eax + field_8], ecx           # 004eddcc
    mov edx, dword ptr [edx + field_c]           # 004eddcf
    mov dword ptr [eax + field_c], edx           # 004eddd2
L_004eddd5:
    # block 0x004eddd5: entered by jmp at 0x004edd8a, 7 instruction(s), ends with jne to 0x004eddfd (forward)
    mov edi, 0x55cd98                            # 004eddd5
    mov esi, dword ptr [ebp - local_4]           # 004eddda
    add esi, 0x9b                                # 004edddd
    mov ecx, 0x9                                 # 004edde3
    {load} xor eax, eax                          # 004edde8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eddea
    jne.d8 L_004eddfd                            # 004eddec
    # block 0x004eddee: entered by fall-through of jne at 0x004eddec, 3 instruction(s), ends with forward jump to 0x004ede1e
    mov ecx, dword ptr [ebp - local_4]           # 004eddee
    mov dword ptr [ecx + field_675], 0x0         # 004eddf1
    jmp.d8 L_004ede1e                            # 004eddfb
L_004eddfd:
    # block 0x004eddfd: entered by jne at 0x004eddec, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x004ede1e
    mov edx, dword ptr [ebp - local_4]           # 004eddfd
    add edx, 0x9b                                # 004ede00
    push edx                                     # 004ede06
    mov ecx, 0x5c3a67                            # 004ede07
    call FUN_004fb77a                            # 004ede0c
    mov eax, dword ptr [ebp - local_4]           # 004ede11
    mov dword ptr [eax + field_675], 0x1         # 004ede14
L_004ede1e:
    # block 0x004ede1e: entered by jmp at 0x004eddfb, 7 instruction(s), ends with jne to 0x004ede46 (forward)
    mov edi, 0x55cda4                            # 004ede1e
    mov esi, dword ptr [ebp - local_4]           # 004ede23
    add esi, 0xcc                                # 004ede26
    mov ecx, 0x9                                 # 004ede2c
    {load} xor edx, edx                          # 004ede31
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ede33
    jne.d8 L_004ede46                            # 004ede35
    # block 0x004ede37: entered by fall-through of jne at 0x004ede35, 3 instruction(s), ends with forward jump to 0x004ede67
    mov eax, dword ptr [ebp - local_4]           # 004ede37
    mov dword ptr [eax + field_679], 0x0         # 004ede3a
    jmp.d8 L_004ede67                            # 004ede44
L_004ede46:
    # block 0x004ede46: entered by jne at 0x004ede35, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x004ede67
    mov ecx, dword ptr [ebp - local_4]           # 004ede46
    add ecx, 0xcc                                # 004ede49
    push ecx                                     # 004ede4f
    mov ecx, 0x5c3a67                            # 004ede50
    call FUN_004fb77a                            # 004ede55
    mov edx, dword ptr [ebp - local_4]           # 004ede5a
    mov dword ptr [edx + field_679], 0x1         # 004ede5d
L_004ede67:
    # block 0x004ede67: entered by jmp at 0x004ede44, 7 instruction(s), ends with jne to 0x004ede8f (forward)
    mov edi, 0x55cdb0                            # 004ede67
    mov esi, dword ptr [ebp - local_4]           # 004ede6c
    add esi, 0xfd                                # 004ede6f
    mov ecx, 0x9                                 # 004ede75
    {load} xor eax, eax                          # 004ede7a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ede7c
    jne.d8 L_004ede8f                            # 004ede7e
    # block 0x004ede80: entered by fall-through of jne at 0x004ede7e, 3 instruction(s), ends with forward jump to 0x004edeb0
    mov ecx, dword ptr [ebp - local_4]           # 004ede80
    mov dword ptr [ecx + field_67d], 0x0         # 004ede83
    jmp.d8 L_004edeb0                            # 004ede8d
L_004ede8f:
    # block 0x004ede8f: entered by jne at 0x004ede7e, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x004edeb0
    mov edx, dword ptr [ebp - local_4]           # 004ede8f
    add edx, 0xfd                                # 004ede92
    push edx                                     # 004ede98
    mov ecx, 0x5c3a67                            # 004ede99
    call FUN_004fb77a                            # 004ede9e
    mov eax, dword ptr [ebp - local_4]           # 004edea3
    mov dword ptr [eax + field_67d], 0x1         # 004edea6
L_004edeb0:
    # block 0x004edeb0: entered by jmp at 0x004ede8d, 7 instruction(s), ends with jne to 0x004eded8 (forward)
    mov edi, 0x55cdbc                            # 004edeb0
    mov esi, dword ptr [ebp - local_4]           # 004edeb5
    add esi, 0x12e                               # 004edeb8
    mov ecx, 0x9                                 # 004edebe
    {load} xor edx, edx                          # 004edec3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004edec5
    jne.d8 L_004eded8                            # 004edec7
    # block 0x004edec9: entered by fall-through of jne at 0x004edec7, 3 instruction(s), ends with forward jump to 0x004edef9
    mov eax, dword ptr [ebp - local_4]           # 004edec9
    mov dword ptr [eax + field_681], 0x0         # 004edecc
    jmp.d8 L_004edef9                            # 004eded6
L_004eded8:
    # block 0x004eded8: entered by jne at 0x004edec7, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x004edef9
    mov ecx, dword ptr [ebp - local_4]           # 004eded8
    add ecx, 0x12e                               # 004ededb
    push ecx                                     # 004edee1
    mov ecx, 0x5c3a67                            # 004edee2
    call FUN_004fb77a                            # 004edee7
    mov edx, dword ptr [ebp - local_4]           # 004edeec
    mov dword ptr [edx + field_681], 0x1         # 004edeef
L_004edef9:
    # block 0x004edef9: entered by jmp at 0x004eded6, 3 instruction(s), ends with je to 0x004edf1d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004edef9
    cmp dword ptr [eax + field_15f], 0x0         # 004edefc
    je.d8 L_004edf1d                             # 004edf03
    # block 0x004edf05: entered by fall-through of je at 0x004edf03, 6 instruction(s), calls FUN_004e1db3, falls into the block at 0x004edf1d
    mov ecx, dword ptr [ebp - local_4]           # 004edf05
    add ecx, 0x163                               # 004edf08
    push ecx                                     # 004edf0e
    mov ecx, dword ptr [ebp - local_4]           # 004edf0f
    add ecx, 0x31c                               # 004edf12
    call FUN_004e1db3                            # 004edf18
L_004edf1d:
    # block 0x004edf1d: entered by je at 0x004edf03, 3 instruction(s), ends with je to 0x004edf40 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004edf1d
    cmp dword ptr [edx + field_252], 0x0         # 004edf20
    je.d8 L_004edf40                             # 004edf27
    # block 0x004edf29: entered by fall-through of je at 0x004edf27, 6 instruction(s), calls FUN_004eeb23, falls into the block at 0x004edf40
    mov eax, dword ptr [ebp - local_4]           # 004edf29
    add eax, 0x256                               # 004edf2c
    push eax                                     # 004edf31
    mov ecx, dword ptr [ebp - local_4]           # 004edf32
    add ecx, 0x4b7                               # 004edf35
    call FUN_004eeb23                            # 004edf3b
L_004edf40:
    # block 0x004edf40: entered by je at 0x004edf27, 4 instruction(s), ends with je to 0x004edf79 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edf40
    movsx edx, word ptr [ecx + field_51]         # 004edf43
    cmp edx, 0x270f                              # 004edf47
    je.d8 L_004edf79                             # 004edf4d
    # block 0x004edf4f: entered by fall-through of je at 0x004edf4d, 6 instruction(s), falls into the block at 0x004edf79
    mov eax, dword ptr [ebp - local_4]           # 004edf4f
    movsx ecx, word ptr [eax + field_51]         # 004edf52
    mov dword ptr [0x5bb57b], ecx                # 004edf56
    mov word ptr [0x5c39ff], 0x1                 # 004edf5c
    mov dword ptr [0x583999], 0x4                # 004edf65
    mov dword ptr [0x55cd94], 0x0                # 004edf6f
L_004edf79:
    # block 0x004edf79: entered by je at 0x004edf4d, 2 instruction(s), ends with je to 0x004edf89 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004edf79
    je.d8 L_004edf89                             # 004edf7d
    # block 0x004edf7f: entered by fall-through of je at 0x004edf7d, 1 instruction(s), falls into the block at 0x004edf89
    mov dword ptr [0x5839a9], 0x1                # 004edf7f
L_004edf89:
    # block 0x004edf89: entered by je at 0x004edf7d, 6 instruction(s), ends with ret 0x8
    mov eax, 0x1                                 # 004edf89
    pop edi                                      # 004edf8e
    pop esi                                      # 004edf8f
    {load} mov esp, ebp                          # 004edf90
    pop ebp                                      # 004edf92
    ret 0x8                                      # 004edf93

