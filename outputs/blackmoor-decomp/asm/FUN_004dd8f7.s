# FUN_004dd8f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd8f7
# extent:       0x004dd8f7-0x004de009 (1810 code bytes)
# span:         0x004dd8f7-0x004de009 (code 1810, tables 0, padding 0)
# sha256:       0eeac5c8dcb6d733b1e3f37c25b0ca43c1b713fb6ac5aed9001cbf94ca9db303
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dd8f7
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34
# fields:       [eax + n] field_4, field_39, field_3d, field_ad, field_b1, field_dd, field_f3, field_101, field_109, field_10d, field_32f; [ecx + n] field_39, field_3d, field_41, field_b5, field_e1, field_f1, field_f3, field_f5, field_111, field_32f; [edx + n] field_45, field_a9, field_d9, field_e1, field_f1, field_f3, field_f9, field_fd, field_105, field_minus_1
# callees:      calls FUN_004daeb5, FUN_004dae88, FUN_004dad60, FUN_004daef1, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_0043dbd5, FUN_004c97b4, FUN_004db870, FUN_0052139c, FUN_004c2dfb, FUN_004cf7e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 373 instruction(s), 30 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ad, 0xad  # offset +0xad
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b5, 0xb5  # offset +0xb5
.equ field_d9, 0xd9  # offset +0xd9
.equ field_dd, 0xdd  # offset +0xdd
.equ field_e1, 0xe1  # offset +0xe1
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f3, 0xf3  # offset +0xf3
.equ field_f5, 0xf5  # offset +0xf5
.equ field_f9, 0xf9  # offset +0xf9
.equ field_fd, 0xfd  # offset +0xfd
.equ field_101, 0x101  # offset +0x101
.equ field_105, 0x105  # offset +0x105
.equ field_109, 0x109  # offset +0x109
.equ field_10d, 0x10d  # offset +0x10d
.equ field_111, 0x111  # offset +0x111
.equ field_32f, 0x32f  # offset +0x32f

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cf7e0, .text + (0x004cf7e0 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004daef1, .text + (0x004daef1 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004dd8f7 - 0x401000
.globl FUN_004dd8f7
FUN_004dd8f7:
    # block 0x004dd8f7: entry, 10 instruction(s), ends with je to 0x004dd92c (forward)
    push ebp                                     # 004dd8f7
    {load} mov ebp, esp                          # 004dd8f8
    sub esp, 0x34                                # 004dd8fa
    push edi                                     # 004dd8fd
    mov dword ptr [ebp - local_24], ecx          # 004dd8fe
    mov eax, dword ptr [ebp - local_24]          # 004dd901
    mov ecx, dword ptr [eax + field_dd]          # 004dd904
    mov dword ptr [ebp - local_28], ecx          # 004dd90a
    cmp dword ptr [ebp - local_28], 0x0          # 004dd90d
    je.d8 L_004dd92c                             # 004dd911
    # block 0x004dd913: entered by fall-through of je at 0x004dd911, 2 instruction(s), ends with je to 0x004dde01 (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 004dd913
    je.d32 L_004dde01                            # 004dd917
    # block 0x004dd91d: entered by fall-through of je at 0x004dd917, 2 instruction(s), ends with je to 0x004dde34 (forward)
    cmp dword ptr [ebp - local_28], 0x3          # 004dd91d
    je.d32 L_004dde34                            # 004dd921
    # block 0x004dd927: entered by fall-through of je at 0x004dd921, 1 instruction(s), ends with forward jump to 0x004ddff5
    jmp.d32 L_004ddff5                           # 004dd927
L_004dd92c:
    # block 0x004dd92c: entered by je at 0x004dd911, 19 instruction(s), calls FUN_004daeb5, ends with jne to 0x004dd991 (forward)
    lea edx, [ebp - local_18]                    # 004dd92c
    push edx                                     # 004dd92f
    mov ecx, 0x5830a6                            # 004dd930
    call FUN_004daeb5                            # 004dd935
    mov ecx, dword ptr [eax]                     # 004dd93a
    mov edx, dword ptr [eax + field_4]           # 004dd93c
    mov dword ptr [0x5830e2], ecx                # 004dd93f
    mov dword ptr [0x5830e6], edx                # 004dd945
    mov eax, dword ptr [0x5830e2]                # 004dd94b
    mov dword ptr [0x5c3a53], eax                # 004dd950
    mov ecx, dword ptr [0x5830e6]                # 004dd955
    mov dword ptr [0x5c3a57], ecx                # 004dd95b
    mov edx, dword ptr [0x5830ea]                # 004dd961
    mov dword ptr [ebp - local_20], edx          # 004dd967
    mov eax, dword ptr [0x5830ee]                # 004dd96a
    mov dword ptr [ebp - local_1c], eax          # 004dd96f
    mov ecx, dword ptr [0x5830e2]                # 004dd972
    cmp ecx, dword ptr [ebp - local_20]          # 004dd978
    jne.d8 L_004dd991                            # 004dd97b
    # block 0x004dd97d: entered by fall-through of jne at 0x004dd97b, 3 instruction(s), ends with jne to 0x004dd991 (forward)
    mov edx, dword ptr [0x5830e6]                # 004dd97d
    cmp edx, dword ptr [ebp - local_1c]          # 004dd983
    jne.d8 L_004dd991                            # 004dd986
    # block 0x004dd988: entered by fall-through of jne at 0x004dd986, 2 instruction(s), ends with forward jump to 0x004dd998
    mov dword ptr [ebp - local_2c], 0x0          # 004dd988
    jmp.d8 L_004dd998                            # 004dd98f
L_004dd991:
    # block 0x004dd991: entered by jne at 0x004dd97b; jne at 0x004dd986, 1 instruction(s), falls into the block at 0x004dd998
    mov dword ptr [ebp - local_2c], 0x1          # 004dd991
L_004dd998:
    # block 0x004dd998: entered by jmp at 0x004dd98f, 2 instruction(s), ends with je to 0x004ddb24 (forward)
    cmp dword ptr [ebp - local_2c], 0x0          # 004dd998
    je.d32 L_004ddb24                            # 004dd99c
    # block 0x004dd9a2: entered by fall-through of je at 0x004dd99c, 3 instruction(s), ends with jne to 0x004ddb24 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004dd9a2
    cmp dword ptr [eax + field_32f], 0x0         # 004dd9a5
    jne.d32 L_004ddb24                           # 004dd9ac
    # block 0x004dd9b2: entered by fall-through of jne at 0x004dd9ac, 16 instruction(s), ends with jle to 0x004dda2c (forward)
    mov ecx, dword ptr [0x583106]                # 004dd9b2
    mov dword ptr [0x5830f6], ecx                # 004dd9b8
    mov edx, dword ptr [0x58310e]                # 004dd9be
    mov dword ptr [0x5830fe], edx                # 004dd9c4
    mov eax, dword ptr [0x583102]                # 004dd9ca
    mov dword ptr [0x5830f2], eax                # 004dd9cf
    mov ecx, dword ptr [0x58310a]                # 004dd9d4
    mov dword ptr [0x5830fa], ecx                # 004dd9da
    movsx edx, word ptr [0x63988b]               # 004dd9e0
    mov eax, dword ptr [0x5b44f4]                # 004dd9e7
    shl eax, 0x2                                 # 004dd9ec
    mov ecx, dword ptr [0x5b44f0]                # 004dd9ef
    movsx eax, word ptr [eax + 8*ecx + 0x5b3790] # 004dd9f5
    {load} sub edx, eax                          # 004dd9fd
    cmp dword ptr [0x5830e2], edx                # 004dd9ff
    jle.d8 L_004dda2c                            # 004dda05
    # block 0x004dda07: entered by fall-through of jle at 0x004dda05, 7 instruction(s), falls into the block at 0x004dda2c
    movsx ecx, word ptr [0x63988b]               # 004dda07
    mov edx, dword ptr [0x5b44f4]                # 004dda0e
    shl edx, 0x2                                 # 004dda14
    mov eax, dword ptr [0x5b44f0]                # 004dda17
    movsx edx, word ptr [edx + 8*eax + 0x5b3790] # 004dda1c
    {load} sub ecx, edx                          # 004dda24
    mov dword ptr [0x5830e2], ecx                # 004dda26
L_004dda2c:
    # block 0x004dda2c: entered by jle at 0x004dda05, 8 instruction(s), ends with jle to 0x004dda79 (forward)
    movsx eax, word ptr [0x63988d]               # 004dda2c
    mov ecx, dword ptr [0x5b44f4]                # 004dda33
    shl ecx, 0x2                                 # 004dda39
    mov edx, dword ptr [0x5b44f0]                # 004dda3c
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004dda42
    {load} sub eax, ecx                          # 004dda4a
    cmp dword ptr [0x5830e6], eax                # 004dda4c
    jle.d8 L_004dda79                            # 004dda52
    # block 0x004dda54: entered by fall-through of jle at 0x004dda52, 7 instruction(s), falls into the block at 0x004dda79
    movsx edx, word ptr [0x63988d]               # 004dda54
    mov eax, dword ptr [0x5b44f4]                # 004dda5b
    shl eax, 0x2                                 # 004dda60
    mov ecx, dword ptr [0x5b44f0]                # 004dda63
    movsx eax, word ptr [eax + 8*ecx + 0x5b3792] # 004dda69
    {load} sub edx, eax                          # 004dda71
    mov dword ptr [0x5830e6], edx                # 004dda73
L_004dda79:
    # block 0x004dda79: entered by jle at 0x004dda52, 32 instruction(s), calls FUN_004dae88, ends with forward jump to 0x004ddb47
    mov ecx, dword ptr [0x5830e6]                # 004dda79
    mov dword ptr [0x583106], ecx                # 004dda7f
    mov edx, dword ptr [0x5b44f4]                # 004dda85
    shl edx, 0x2                                 # 004dda8b
    mov eax, dword ptr [0x5b44f0]                # 004dda8e
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004dda93
    mov edx, dword ptr [0x583106]                # 004dda9b
    lea eax, [edx + ecx - field_minus_1]         # 004ddaa1
    mov dword ptr [0x58310e], eax                # 004ddaa5
    mov ecx, dword ptr [0x5830e2]                # 004ddaaa
    mov dword ptr [0x583102], ecx                # 004ddab0
    mov edx, dword ptr [0x5b44f4]                # 004ddab6
    shl edx, 0x2                                 # 004ddabc
    mov eax, dword ptr [0x5b44f0]                # 004ddabf
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004ddac4
    mov edx, dword ptr [0x583102]                # 004ddacc
    lea eax, [edx + ecx - field_minus_1]         # 004ddad2
    mov dword ptr [0x58310a], eax                # 004ddad6
    mov ecx, dword ptr [0x5830e6]                # 004ddadb
    push ecx                                     # 004ddae1
    mov edx, dword ptr [0x5830e2]                # 004ddae2
    push edx                                     # 004ddae8
    mov ecx, 0x5830a6                            # 004ddae9
    call FUN_004dae88                            # 004ddaee
    mov eax, dword ptr [ebp - local_24]          # 004ddaf3
    mov dword ptr [eax + field_32f], 0x1         # 004ddaf6
    mov dword ptr [0x5d2ded], 0x1                # 004ddb00
    mov ecx, dword ptr [0x5830e2]                # 004ddb0a
    mov dword ptr [0x5830ea], ecx                # 004ddb10
    mov edx, dword ptr [0x5830e6]                # 004ddb16
    mov dword ptr [0x5830ee], edx                # 004ddb1c
    jmp.d8 L_004ddb47                            # 004ddb22
L_004ddb24:
    # block 0x004ddb24: entered by je at 0x004dd99c; jne at 0x004dd9ac, 3 instruction(s), ends with je to 0x004ddb47 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004ddb24
    cmp dword ptr [eax + field_32f], 0x0         # 004ddb27
    je.d8 L_004ddb47                             # 004ddb2e
    # block 0x004ddb30: entered by fall-through of je at 0x004ddb2e, 3 instruction(s), falls into the block at 0x004ddb47
    mov ecx, dword ptr [ebp - local_24]          # 004ddb30
    mov dword ptr [ecx + field_32f], 0x0         # 004ddb33
    mov dword ptr [0x5d2ded], 0x0                # 004ddb3d
L_004ddb47:
    # block 0x004ddb47: entered by jmp at 0x004ddb22; je at 0x004ddb2e, 4 instruction(s), ends with je to 0x004ddb6e (forward)
    mov edx, dword ptr [ebp - local_24]          # 004ddb47
    movsx eax, word ptr [edx + field_f3]         # 004ddb4a
    cmp eax, -0x1                                # 004ddb51
    je.d8 L_004ddb6e                             # 004ddb54
    # block 0x004ddb56: entered by fall-through of je at 0x004ddb54, 4 instruction(s), ends with forward jump to 0x004ddb78
    mov dword ptr [0x5d2e81], 0x1                # 004ddb56
    mov ecx, dword ptr [ebp - local_24]          # 004ddb60
    mov word ptr [ecx + field_f3], 0xffff        # 004ddb63
    jmp.d8 L_004ddb78                            # 004ddb6c
L_004ddb6e:
    # block 0x004ddb6e: entered by je at 0x004ddb54, 1 instruction(s), falls into the block at 0x004ddb78
    mov dword ptr [0x5d2e81], 0x0                # 004ddb6e
L_004ddb78:
    # block 0x004ddb78: entered by jmp at 0x004ddb6c, 15 instruction(s), ends with forward jump to 0x004ddbd1
    mov dword ptr [ebp - local_8], 0x0           # 004ddb78
    mov edx, dword ptr [0x5b44f0]                # 004ddb7f
    shl edx, 0x4                                 # 004ddb85
    mov eax, dword ptr [0x5b44f4]                # 004ddb88
    mov ecx, dword ptr [0x583106]                # 004ddb8d
    add ecx, dword ptr [edx + 8*eax + 0x5b30d0]  # 004ddb93
    mov word ptr [ebp - local_4], cx             # 004ddb9a
    mov edx, dword ptr [0x5b44f0]                # 004ddb9e
    shl edx, 0x4                                 # 004ddba4
    mov eax, dword ptr [0x5b44f4]                # 004ddba7
    mov ecx, dword ptr [0x583102]                # 004ddbac
    add ecx, dword ptr [edx + 8*eax + 0x5b30cc]  # 004ddbb2
    mov word ptr [ebp - local_10], cx            # 004ddbb9
    mov word ptr [ebp - local_c], 0x0            # 004ddbbd
    jmp.d8 L_004ddbd1                            # 004ddbc3
L_004ddbc5:
    # block 0x004ddbc5: entered by jmp at 0x004ddde4, 3 instruction(s), falls into the block at 0x004ddbd1
    mov dx, word ptr [ebp - local_c]             # 004ddbc5
    add dx, 0x1                                  # 004ddbc9
    mov word ptr [ebp - local_c], dx             # 004ddbcd
L_004ddbd1:
    # block 0x004ddbd1: entered by jmp at 0x004ddbc3, 3 instruction(s), ends with jge to 0x004ddde9 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004ddbd1
    cmp eax, 0x3                                 # 004ddbd5
    jge.d32 L_004ddde9                           # 004ddbd8
    # block 0x004ddbde: entered by fall-through of jge at 0x004ddbd8, 8 instruction(s), ends with jl to 0x004ddde4 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004ddbde
    movsx edx, word ptr [ebp - local_c]          # 004ddbe2
    shl edx, 0x4                                 # 004ddbe6
    mov eax, dword ptr [ebp - local_24]          # 004ddbe9
    mov edx, dword ptr [eax + edx + field_3d]    # 004ddbec
    sub edx, 0xa                                 # 004ddbf0
    {load} cmp ecx, edx                          # 004ddbf3
    jl.d32 L_004ddde4                            # 004ddbf5
    # block 0x004ddbfb: entered by fall-through of jl at 0x004ddbf5, 8 instruction(s), ends with jg to 0x004ddde4 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ddbfb
    movsx ecx, word ptr [ebp - local_c]          # 004ddbff
    shl ecx, 0x4                                 # 004ddc03
    mov edx, dword ptr [ebp - local_24]          # 004ddc06
    mov ecx, dword ptr [edx + ecx + field_45]    # 004ddc09
    add ecx, 0x14                                # 004ddc0d
    {load} cmp eax, ecx                          # 004ddc10
    jg.d32 L_004ddde4                            # 004ddc12
    # block 0x004ddc18: entered by fall-through of jg at 0x004ddc12, 6 instruction(s), ends with jl to 0x004ddde4 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004ddc18
    movsx eax, word ptr [ebp - local_c]          # 004ddc1c
    shl eax, 0x4                                 # 004ddc20
    mov ecx, dword ptr [ebp - local_24]          # 004ddc23
    cmp edx, dword ptr [ecx + eax + field_39]    # 004ddc26
    jl.d32 L_004ddde4                            # 004ddc2a
    # block 0x004ddc30: entered by fall-through of jl at 0x004ddc2a, 8 instruction(s), ends with jg to 0x004ddde4 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004ddc30
    movsx eax, word ptr [ebp - local_c]          # 004ddc34
    shl eax, 0x4                                 # 004ddc38
    mov ecx, dword ptr [ebp - local_24]          # 004ddc3b
    mov eax, dword ptr [ecx + eax + field_41]    # 004ddc3e
    add eax, 0x14                                # 004ddc42
    {load} cmp edx, eax                          # 004ddc45
    jg.d32 L_004ddde4                            # 004ddc47
    # block 0x004ddc4d: entered by fall-through of jg at 0x004ddc47, 4 instruction(s), ends with jne to 0x004ddde4 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004ddc4d
    movsx edx, word ptr [ecx + field_f1]         # 004ddc50
    cmp edx, -0x1                                # 004ddc57
    jne.d32 L_004ddde4                           # 004ddc5a
    # block 0x004ddc60: entered by fall-through of jne at 0x004ddc5a, 10 instruction(s), ends with je to 0x004ddc9c (forward)
    mov dword ptr [ebp - local_8], 0x1           # 004ddc60
    mov eax, dword ptr [ebp - local_24]          # 004ddc67
    mov cx, word ptr [ebp - local_c]             # 004ddc6a
    mov word ptr [eax + field_f3], cx            # 004ddc6e
    mov dword ptr [0x5d2e81], 0x1                # 004ddc75
    mov edx, dword ptr [ebp - local_24]          # 004ddc7f
    mov eax, dword ptr [edx + field_e1]          # 004ddc82
    mov dword ptr [ebp - local_30], eax          # 004ddc88
    cmp dword ptr [ebp - local_30], 0x0          # 004ddc8b
    je.d8 L_004ddc9c                             # 004ddc8f
    # block 0x004ddc91: entered by fall-through of je at 0x004ddc8f, 2 instruction(s), ends with je to 0x004ddcb8 (forward)
    cmp dword ptr [ebp - local_30], 0x1          # 004ddc91
    je.d8 L_004ddcb8                             # 004ddc95
    # block 0x004ddc97: entered by fall-through of je at 0x004ddc95, 1 instruction(s), ends with forward jump to 0x004ddde2
    jmp.d32 L_004ddde2                           # 004ddc97
L_004ddc9c:
    # block 0x004ddc9c: entered by je at 0x004ddc8f, 5 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004ddde2
    mov ecx, 0x5830a6                            # 004ddc9c
    call FUN_004dad60                            # 004ddca1
    mov ecx, dword ptr [ebp - local_24]          # 004ddca6
    mov dword ptr [ecx + field_e1], 0x1          # 004ddca9
    jmp.d32 L_004ddde2                           # 004ddcb3
L_004ddcb8:
    # block 0x004ddcb8: entered by je at 0x004ddc95, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004ddde2 (forward)
    mov ecx, 0x5830a6                            # 004ddcb8
    call FUN_004daef1                            # 004ddcbd
    cmp eax, 0x2                                 # 004ddcc2
    jne.d32 L_004ddde2                           # 004ddcc5
    # block 0x004ddccb: entered by fall-through of jne at 0x004ddcc5, 64 instruction(s), calls FUN_004dad60, KERNEL32.dll!GetTickCount, FUN_004fb2e3, falls into the block at 0x004ddde2
    mov edx, dword ptr [ebp - local_24]          # 004ddccb
    mov ax, word ptr [ebp - local_c]             # 004ddcce
    mov word ptr [edx + field_f1], ax            # 004ddcd2
    mov ecx, 0x5830a6                            # 004ddcd9
    call FUN_004dad60                            # 004ddcde
    movsx ecx, word ptr [ebp - local_c]          # 004ddce3
    shl ecx, 0x4                                 # 004ddce7
    mov edx, dword ptr [ebp - local_24]          # 004ddcea
    mov eax, dword ptr [ebp - local_24]          # 004ddced
    mov ecx, dword ptr [eax + ecx + field_ad]    # 004ddcf0
    mov dword ptr [edx + field_f9], ecx          # 004ddcf7
    movsx edx, word ptr [ebp - local_c]          # 004ddcfd
    shl edx, 0x4                                 # 004ddd01
    mov eax, dword ptr [ebp - local_24]          # 004ddd04
    mov ecx, dword ptr [ebp - local_24]          # 004ddd07
    mov edx, dword ptr [ecx + edx + field_b5]    # 004ddd0a
    mov dword ptr [eax + field_101], edx         # 004ddd11
    movsx eax, word ptr [ebp - local_c]          # 004ddd17
    shl eax, 0x4                                 # 004ddd1b
    mov ecx, dword ptr [ebp - local_24]          # 004ddd1e
    mov edx, dword ptr [ebp - local_24]          # 004ddd21
    mov eax, dword ptr [edx + eax + field_a9]    # 004ddd24
    mov dword ptr [ecx + field_f5], eax          # 004ddd2b
    movsx ecx, word ptr [ebp - local_c]          # 004ddd31
    shl ecx, 0x4                                 # 004ddd35
    mov edx, dword ptr [ebp - local_24]          # 004ddd38
    mov eax, dword ptr [ebp - local_24]          # 004ddd3b
    mov ecx, dword ptr [eax + ecx + field_b1]    # 004ddd3e
    mov dword ptr [edx + field_fd], ecx          # 004ddd45
    movsx edx, word ptr [ebp - local_c]          # 004ddd4b
    shl edx, 0x4                                 # 004ddd4f
    mov eax, dword ptr [ebp - local_24]          # 004ddd52
    mov ecx, dword ptr [ebp - local_24]          # 004ddd55
    mov edx, dword ptr [ecx + edx + field_3d]    # 004ddd58
    mov dword ptr [eax + field_109], edx         # 004ddd5c
    movsx eax, word ptr [ebp - local_c]          # 004ddd62
    shl eax, 0x4                                 # 004ddd66
    mov ecx, dword ptr [ebp - local_24]          # 004ddd69
    mov edx, dword ptr [ebp - local_24]          # 004ddd6c
    mov eax, dword ptr [edx + eax + field_45]    # 004ddd6f
    mov dword ptr [ecx + field_111], eax         # 004ddd73
    movsx ecx, word ptr [ebp - local_c]          # 004ddd79
    shl ecx, 0x4                                 # 004ddd7d
    mov edx, dword ptr [ebp - local_24]          # 004ddd80
    mov eax, dword ptr [ebp - local_24]          # 004ddd83
    mov ecx, dword ptr [eax + ecx + field_39]    # 004ddd86
    mov dword ptr [edx + field_105], ecx         # 004ddd8a
    movsx edx, word ptr [ebp - local_c]          # 004ddd90
    shl edx, 0x4                                 # 004ddd94
    mov eax, dword ptr [ebp - local_24]          # 004ddd97
    mov ecx, dword ptr [ebp - local_24]          # 004ddd9a
    mov edx, dword ptr [ecx + edx + field_41]    # 004ddd9d
    mov dword ptr [eax + field_10d], edx         # 004ddda1
    call dword ptr [0x52a23c]                    # 004ddda7
    movsx ecx, word ptr [0x5b0282]               # 004dddad
    {load} add eax, ecx                          # 004dddb4
    mov edx, dword ptr [ebp - local_24]          # 004dddb6
    mov dword ptr [edx + field_d9], eax          # 004dddb9
    push 0x17                                    # 004dddbf
    mov ecx, 0x5c3a67                            # 004dddc1
    call FUN_004fb2e3                            # 004dddc6
    mov dword ptr [0x5d2e37], 0x1                # 004dddcb
    mov eax, dword ptr [ebp - local_24]          # 004dddd5
    mov dword ptr [eax + field_dd], 0x2          # 004dddd8
L_004ddde2:
    # block 0x004ddde2: entered by jmp at 0x004ddc97; jmp at 0x004ddcb3; jne at 0x004ddcc5, 1 instruction(s), ends with forward jump to 0x004ddde9
    jmp.d8 L_004ddde9                            # 004ddde2
L_004ddde4:
    # block 0x004ddde4: entered by jl at 0x004ddbf5; jg at 0x004ddc12; jl at 0x004ddc2a; jg at 0x004ddc47; jne at 0x004ddc5a, 1 instruction(s), ends with backward jump to 0x004ddbc5
    jmp.d32 L_004ddbc5                           # 004ddde4
L_004ddde9:
    # block 0x004ddde9: entered by jge at 0x004ddbd8; jmp at 0x004ddde2, 2 instruction(s), ends with jne to 0x004dddfc (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004ddde9
    jne.d8 L_004dddfc                            # 004ddded
    # block 0x004dddef: entered by fall-through of jne at 0x004ddded, 2 instruction(s), falls into the block at 0x004dddfc
    mov ecx, dword ptr [ebp - local_24]          # 004dddef
    mov dword ptr [ecx + field_e1], 0x0          # 004dddf2
L_004dddfc:
    # block 0x004dddfc: entered by jne at 0x004ddded, 1 instruction(s), ends with forward jump to 0x004ddff5
    jmp.d32 L_004ddff5                           # 004dddfc
L_004dde01:
    # block 0x004dde01: entered by je at 0x004dd917, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004dde2f (forward)
    call dword ptr [0x52a23c]                    # 004dde01
    mov edx, dword ptr [ebp - local_24]          # 004dde07
    cmp eax, dword ptr [edx + field_d9]          # 004dde0a
    jbe.d8 L_004dde2f                            # 004dde10
    # block 0x004dde12: entered by fall-through of jbe at 0x004dde10, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004dde2f (forward)
    push 0x17                                    # 004dde12
    mov ecx, 0x5cf1eb                            # 004dde14
    call FUN_004f6334                            # 004dde19
    test eax, eax                                # 004dde1e
    jne.d8 L_004dde2f                            # 004dde20
    # block 0x004dde22: entered by fall-through of jne at 0x004dde20, 2 instruction(s), falls into the block at 0x004dde2f
    mov eax, dword ptr [ebp - local_24]          # 004dde22
    mov dword ptr [eax + field_dd], 0x3          # 004dde25
L_004dde2f:
    # block 0x004dde2f: entered by jbe at 0x004dde10; jne at 0x004dde20, 1 instruction(s), ends with forward jump to 0x004ddff5
    jmp.d32 L_004ddff5                           # 004dde2f
L_004dde34:
    # block 0x004dde34: entered by je at 0x004dd921, 7 instruction(s), calls FUN_004dad60, ends with je to 0x004dde6a (forward)
    mov ecx, 0x5830a6                            # 004dde34
    call FUN_004dad60                            # 004dde39
    mov ecx, dword ptr [ebp - local_24]          # 004dde3e
    movsx edx, word ptr [ecx + field_f1]         # 004dde41
    mov dword ptr [ebp - local_34], edx          # 004dde48
    cmp dword ptr [ebp - local_34], 0x0          # 004dde4b
    je.d8 L_004dde6a                             # 004dde4f
    # block 0x004dde51: entered by fall-through of je at 0x004dde4f, 2 instruction(s), ends with je to 0x004ddef7 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 004dde51
    je.d32 L_004ddef7                            # 004dde55
    # block 0x004dde5b: entered by fall-through of je at 0x004dde55, 2 instruction(s), ends with je to 0x004ddf6d (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 004dde5b
    je.d32 L_004ddf6d                            # 004dde5f
    # block 0x004dde65: entered by fall-through of je at 0x004dde5f, 1 instruction(s), ends with forward jump to 0x004ddf9a
    jmp.d32 L_004ddf9a                           # 004dde65
L_004dde6a:
    # block 0x004dde6a: entered by je at 0x004dde4f, 2 instruction(s), ends with jne to 0x004dde90 (forward)
    cmp dword ptr [ebp + arg_8], 0xb             # 004dde6a
    jne.d8 L_004dde90                            # 004dde6e
    # block 0x004dde70: entered by fall-through of jne at 0x004dde6e, 4 instruction(s), ends with forward jump to 0x004ddeed
    mov dword ptr [0x583985], 0x6                # 004dde70
    mov dword ptr [0x583981], 0x7                # 004dde7a
    mov dword ptr [0x5e2e74], 0x0                # 004dde84
    jmp.d8 L_004ddeed                            # 004dde8e
L_004dde90:
    # block 0x004dde90: entered by jne at 0x004dde6e, 2 instruction(s), ends with jne to 0x004ddecf (forward)
    cmp dword ptr [ebp + arg_8], 0x11            # 004dde90
    jne.d8 L_004ddecf                            # 004dde94
    # block 0x004dde96: entered by fall-through of jne at 0x004dde94, 10 instruction(s), ends with forward jump to 0x004ddeed
    mov dword ptr [0x583985], 0xe                # 004dde96
    mov dword ptr [0x583981], 0xe                # 004ddea0
    mov dword ptr [0x583999], 0x0                # 004ddeaa
    mov dword ptr [0x5e32b9], 0x0                # 004ddeb4
    mov ecx, 0x8                                 # 004ddebe
    {load} xor eax, eax                          # 004ddec3
    mov edi, 0x63a565                            # 004ddec5
    rep stosd dword ptr es:[edi], eax            # 004ddeca
    stosb byte ptr es:[edi], al                  # 004ddecc
    jmp.d8 L_004ddeed                            # 004ddecd
L_004ddecf:
    # block 0x004ddecf: entered by jne at 0x004dde94, 3 instruction(s), falls into the block at 0x004ddeed
    mov dword ptr [0x583981], 0x7                # 004ddecf
    mov dword ptr [0x5e2e74], 0x2                # 004dded9
    mov dword ptr [0x5e32c5], 0x2                # 004ddee3
L_004ddeed:
    # block 0x004ddeed: entered by jmp at 0x004dde8e; jmp at 0x004ddecd, 2 instruction(s), calls FUN_0043dbd5, ends with forward jump to 0x004ddfb2
    call FUN_0043dbd5                            # 004ddeed
    jmp.d32 L_004ddfb2                           # 004ddef2
L_004ddef7:
    # block 0x004ddef7: entered by je at 0x004dde55, 2 instruction(s), ends with jne to 0x004ddf1d (forward)
    cmp dword ptr [ebp + arg_8], 0xb             # 004ddef7
    jne.d8 L_004ddf1d                            # 004ddefb
    # block 0x004ddefd: entered by fall-through of jne at 0x004ddefb, 5 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ddf6b
    mov dword ptr [0x583985], 0xb                # 004ddefd
    mov dword ptr [0x5bb20c], 0x1                # 004ddf07
    mov ecx, 0x5cf659                            # 004ddf11
    call FUN_004c97b4                            # 004ddf16
    jmp.d8 L_004ddf6b                            # 004ddf1b
L_004ddf1d:
    # block 0x004ddf1d: entered by jne at 0x004ddefb, 2 instruction(s), ends with jne to 0x004ddf4d (forward)
    cmp dword ptr [ebp + arg_8], 0x11            # 004ddf1d
    jne.d8 L_004ddf4d                            # 004ddf21
    # block 0x004ddf23: entered by fall-through of jne at 0x004ddf21, 5 instruction(s), ends with forward jump to 0x004ddf6b
    mov dword ptr [0x583985], 0xe                # 004ddf23
    mov dword ptr [0x583981], 0x7                # 004ddf2d
    mov dword ptr [0x5e2e74], 0x0                # 004ddf37
    mov dword ptr [0x5e32b9], 0x0                # 004ddf41
    jmp.d8 L_004ddf6b                            # 004ddf4b
L_004ddf4d:
    # block 0x004ddf4d: entered by jne at 0x004ddf21, 3 instruction(s), falls into the block at 0x004ddf6b
    mov dword ptr [0x583985], 0x6                # 004ddf4d
    mov dword ptr [0x583981], 0x7                # 004ddf57
    mov dword ptr [0x5e2e74], 0x0                # 004ddf61
L_004ddf6b:
    # block 0x004ddf6b: entered by jmp at 0x004ddf1b; jmp at 0x004ddf4b, 1 instruction(s), ends with forward jump to 0x004ddfb2
    jmp.d8 L_004ddfb2                            # 004ddf6b
L_004ddf6d:
    # block 0x004ddf6d: entered by je at 0x004dde5f, 8 instruction(s), calls FUN_0043dbd5, FUN_004db870, ends with forward jump to 0x004ddfb2
    mov eax, dword ptr [ebp + arg_8]             # 004ddf6d
    mov dword ptr [0x583985], eax                # 004ddf70
    mov dword ptr [0x583981], 0x6                # 004ddf75
    mov dword ptr [0x5839a1], 0x0                # 004ddf7f
    call FUN_0043dbd5                            # 004ddf89
    mov ecx, 0x5830ce                            # 004ddf8e
    call FUN_004db870                            # 004ddf93
    jmp.d8 L_004ddfb2                            # 004ddf98
L_004ddf9a:
    # block 0x004ddf9a: entered by jmp at 0x004dde65, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004ddfb2
    push 0x0                                     # 004ddf9a
    push 0x0                                     # 004ddf9c
    push 0x55b794                                # 004ddf9e
    call FUN_0052139c                            # 004ddfa3
    mov ecx, 0x5cf659                            # 004ddfa8
    call FUN_004c97b4                            # 004ddfad
L_004ddfb2:
    # block 0x004ddfb2: entered by jmp at 0x004ddef2; jmp at 0x004ddf6b; jmp at 0x004ddf98, 9 instruction(s), calls FUN_004c2dfb, ends with forward jump to 0x004de002
    mov dword ptr [0x5d2d59], 0x0                # 004ddfb2
    mov dword ptr [0x5d2da3], 0x0                # 004ddfbc
    mov dword ptr [0x5d2ded], 0x0                # 004ddfc6
    mov dword ptr [0x5d2e37], 0x0                # 004ddfd0
    mov dword ptr [0x5d2e81], 0x0                # 004ddfda
    push 0x5d0383                                # 004ddfe4
    mov ecx, 0x5cf659                            # 004ddfe9
    call FUN_004c2dfb                            # 004ddfee
    jmp.d8 L_004de002                            # 004ddff3
L_004ddff5:
    # block 0x004ddff5: entered by jmp at 0x004dd927; jmp at 0x004dddfc; jmp at 0x004dde2f, 3 instruction(s), calls FUN_004cf7e0, falls into the block at 0x004de002
    push 0x55b6b8                                # 004ddff5
    call FUN_004cf7e0                            # 004ddffa
    add esp, 0x4                                 # 004ddfff
L_004de002:
    # block 0x004de002: entered by jmp at 0x004ddff3, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004de002
    {load} mov esp, ebp                          # 004de003
    pop ebp                                      # 004de005
    ret 0x4                                      # 004de006

