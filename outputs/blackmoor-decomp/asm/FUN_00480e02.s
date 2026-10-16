# FUN_00480e02
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00480e02
# extent:       0x00480e02-0x00481c8d (3723 code bytes)
# span:         0x00480e02-0x00481ca9 (code 3723, tables 28, padding 0)
# sha256:       be1d795a3c0e32086eb2bd61891e5c988b17eaca53142a999d0029baf3d63eb5
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00480e02
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_e4, local_e8, local_ec, local_f0, local_f4, local_f8
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_1c, field_1e, field_20, field_42, field_43, field_85, field_91, field_798 and 21 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_89, field_93, field_95, field_8c8, field_8ce, field_8d8, field_902 and 20 more; [edi + n] field_minus_1; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_43, field_81, field_8d, field_93, field_95, field_97, field_8c8 and 25 more
# callees:      calls FUN_004e8d96, FUN_004c2790, FUN_0047e582, FUN_004d39f9, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3, FUN_00423259, FUN_00448d11, FUN_004fba69, FUN_0042ba3a, FUN_0047e2a5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 831 instruction(s), 48 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_42, 0x42  # offset +0x42
.equ field_43, 0x43  # offset +0x43
.equ field_81, 0x81  # offset +0x81
.equ field_85, 0x85  # offset +0x85
.equ field_89, 0x89  # offset +0x89
.equ field_8d, 0x8d  # offset +0x8d
.equ field_91, 0x91  # offset +0x91
.equ field_93, 0x93  # offset +0x93
.equ field_95, 0x95  # offset +0x95
.equ field_97, 0x97  # offset +0x97
.equ field_798, 0x798  # offset +0x798
.equ field_8c8, 0x8c8  # offset +0x8c8
.equ field_8ca, 0x8ca  # offset +0x8ca
.equ field_8cc, 0x8cc  # offset +0x8cc
.equ field_8ce, 0x8ce  # offset +0x8ce
.equ field_8d0, 0x8d0  # offset +0x8d0
.equ field_8d4, 0x8d4  # offset +0x8d4
.equ field_8d8, 0x8d8  # offset +0x8d8
.equ field_8dc, 0x8dc  # offset +0x8dc
.equ field_902, 0x902  # offset +0x902
.equ field_9fb, 0x9fb  # offset +0x9fb
.equ field_9fd, 0x9fd  # offset +0x9fd
.equ field_9ff, 0x9ff  # offset +0x9ff
.equ field_a01, 0xa01  # offset +0xa01
.equ field_a03, 0xa03  # offset +0xa03
.equ field_a07, 0xa07  # offset +0xa07
.equ field_a0b, 0xa0b  # offset +0xa0b
.equ field_a0f, 0xa0f  # offset +0xa0f
.equ field_1344, 0x1344  # offset +0x1344
.equ field_1348, 0x1348  # offset +0x1348
.equ field_134c, 0x134c  # offset +0x134c
.equ field_1350, 0x1350  # offset +0x1350
.equ field_13a2, 0x13a2  # offset +0x13a2
.equ field_13a4, 0x13a4  # offset +0x13a4
.equ field_13a8, 0x13a8  # offset +0x13a8
.equ field_13ac, 0x13ac  # offset +0x13ac
.equ field_13b0, 0x13b0  # offset +0x13b0
.equ field_13b1, 0x13b1  # offset +0x13b1
.equ field_13b2, 0x13b2  # offset +0x13b2
.equ field_13b3, 0x13b3  # offset +0x13b3
.equ field_13b4, 0x13b4  # offset +0x13b4
.equ field_13b5, 0x13b5  # offset +0x13b5
.equ field_13b9, 0x13b9  # offset +0x13b9
.equ field_13bd, 0x13bd  # offset +0x13bd
.equ field_13c1, 0x13c1  # offset +0x13c1
.equ field_13c5, 0x13c5  # offset +0x13c5
.equ field_13c9, 0x13c9  # offset +0x13c9
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13ce, 0x13ce  # offset +0x13ce
.equ field_13df, 0x13df  # offset +0x13df
.equ field_13e7, 0x13e7  # offset +0x13e7
.equ field_13eb, 0x13eb  # offset +0x13eb
.equ field_1443, 0x1443  # offset +0x1443
.equ field_1445, 0x1445  # offset +0x1445
.equ field_1447, 0x1447  # offset +0x1447
.equ field_1449, 0x1449  # offset +0x1449
.equ field_144b, 0x144b  # offset +0x144b

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0047e2a5, .text + (0x0047e2a5 - 0x401000)
.set FUN_0047e582, .text + (0x0047e582 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00480e02 - 0x401000
.globl FUN_00480e02
FUN_00480e02:
    # block 0x00480e02: entry, 17 instruction(s), ends with je to 0x00480e6b (forward)
    push ebp                                     # 00480e02
    {load} mov ebp, esp                          # 00480e03
    sub esp, 0xf8                                # 00480e05
    push esi                                     # 00480e0b
    push edi                                     # 00480e0c
    mov dword ptr [ebp - local_f0], ecx          # 00480e0d
    mov dword ptr [ebp - local_14], 0x0          # 00480e13
    movsx eax, word ptr [ebp + arg_8]            # 00480e1a
    imul eax, eax, 0x8d                          # 00480e1e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00480e24
    mov dword ptr [ebp - local_8], ecx           # 00480e2a
    movsx edx, word ptr [ebp + arg_8]            # 00480e2d
    imul edx, edx, 0x8d                          # 00480e31
    mov eax, dword ptr [edx + 0x5bb632]          # 00480e37
    mov dword ptr [ebp - local_f4], eax          # 00480e3d
    cmp dword ptr [ebp - local_f4], 0x0          # 00480e43
    je.d8 L_00480e6b                             # 00480e4a
    # block 0x00480e4c: entered by fall-through of je at 0x00480e4a, 2 instruction(s), ends with je to 0x0048149d (forward)
    cmp dword ptr [ebp - local_f4], 0x1          # 00480e4c
    je.d32 L_0048149d                            # 00480e53
    # block 0x00480e59: entered by fall-through of je at 0x00480e53, 2 instruction(s), ends with je to 0x00481a18 (forward)
    cmp dword ptr [ebp - local_f4], 0x2          # 00480e59
    je.d32 L_00481a18                            # 00480e60
    # block 0x00480e66: entered by fall-through of je at 0x00480e60, 1 instruction(s), ends with forward jump to 0x00481c85
    jmp.d32 L_00481c85                           # 00480e66
L_00480e6b:
    # block 0x00480e6b: entered by je at 0x00480e4a, 86 instruction(s), calls FUN_004e8d96, ends with jne to 0x0048105c (forward)
    mov ecx, dword ptr [ebp - local_f0]          # 00480e6b
    mov dx, word ptr [ebp + arg_8]               # 00480e71
    mov word ptr [ecx + field_1e], dx            # 00480e75
    mov eax, dword ptr [ebp - local_f0]          # 00480e79
    mov dword ptr [eax + field_13c5], 0x1        # 00480e7f
    mov dword ptr [0x5bb1ca], 0x1                # 00480e89
    mov ecx, 0x571442                            # 00480e93
    call FUN_004e8d96                            # 00480e98
    mov ecx, dword ptr [ebp - local_f0]          # 00480e9d
    mov dword ptr [ecx + field_13df], 0x0        # 00480ea3
    mov edx, dword ptr [ebp - local_f0]          # 00480ead
    mov dword ptr [edx + field_1344], 0x0        # 00480eb3
    mov eax, dword ptr [ebp - local_f0]          # 00480ebd
    mov word ptr [eax + field_1350], 0xffff      # 00480ec3
    mov ecx, dword ptr [ebp - local_f0]          # 00480ecc
    mov dword ptr [ecx + field_1344], 0x0        # 00480ed2
    mov edx, dword ptr [ebp - local_f0]          # 00480edc
    mov dword ptr [edx + field_1348], 0x0        # 00480ee2
    mov eax, dword ptr [ebp - local_f0]          # 00480eec
    mov dword ptr [eax + field_134c], 0x0        # 00480ef2
    mov ecx, dword ptr [ebp - local_f0]          # 00480efc
    mov byte ptr [ecx + field_13ce], 0x0         # 00480f02
    mov edx, dword ptr [ebp - local_f0]          # 00480f09
    mov byte ptr [edx + field_13c9], 0x0         # 00480f0f
    mov eax, dword ptr [ebp - local_f0]          # 00480f16
    mov dword ptr [eax + field_13ca], 0x0        # 00480f1c
    mov ecx, dword ptr [ebp - local_f0]          # 00480f26
    movsx edx, word ptr [ecx + field_1e]         # 00480f2c
    imul edx, edx, 0x8d                          # 00480f30
    mov dword ptr [edx + 0x5bb632], 0x1          # 00480f36
    {load} xor eax, eax                          # 00480f40
    mov ecx, dword ptr [ebp - local_f0]          # 00480f42
    add ecx, 0x1352                              # 00480f48
    mov dword ptr [ecx], eax                     # 00480f4e
    mov dword ptr [ecx + field_4], eax           # 00480f50
    mov dword ptr [ecx + field_8], eax           # 00480f53
    mov dword ptr [ecx + field_c], eax           # 00480f56
    {load} xor edx, edx                          # 00480f59
    mov eax, dword ptr [ebp - local_f0]          # 00480f5b
    add eax, 0x1362                              # 00480f61
    mov dword ptr [eax], edx                     # 00480f66
    mov dword ptr [eax + field_4], edx           # 00480f68
    mov dword ptr [eax + field_8], edx           # 00480f6b
    mov dword ptr [eax + field_c], edx           # 00480f6e
    {load} xor ecx, ecx                          # 00480f71
    mov edx, dword ptr [ebp - local_f0]          # 00480f73
    add edx, 0x1372                              # 00480f79
    mov dword ptr [edx], ecx                     # 00480f7f
    mov dword ptr [edx + field_4], ecx           # 00480f81
    mov dword ptr [edx + field_8], ecx           # 00480f84
    mov dword ptr [edx + field_c], ecx           # 00480f87
    {load} xor eax, eax                          # 00480f8a
    mov ecx, dword ptr [ebp - local_f0]          # 00480f8c
    add ecx, 0x1382                              # 00480f92
    mov dword ptr [ecx], eax                     # 00480f98
    mov dword ptr [ecx + field_4], eax           # 00480f9a
    mov dword ptr [ecx + field_8], eax           # 00480f9d
    mov dword ptr [ecx + field_c], eax           # 00480fa0
    {load} xor edx, edx                          # 00480fa3
    mov eax, dword ptr [ebp - local_f0]          # 00480fa5
    add eax, 0x13cf                              # 00480fab
    mov dword ptr [eax], edx                     # 00480fb0
    mov dword ptr [eax + field_4], edx           # 00480fb2
    mov dword ptr [eax + field_8], edx           # 00480fb5
    mov dword ptr [eax + field_c], edx           # 00480fb8
    mov ecx, dword ptr [ebp - local_f0]          # 00480fbb
    mov dword ptr [ecx + field_13e7], 0x0        # 00480fc1
    mov edx, dword ptr [ebp - local_f0]          # 00480fcb
    mov word ptr [edx + field_1445], 0x0         # 00480fd1
    mov eax, dword ptr [ebp - local_f0]          # 00480fda
    mov word ptr [eax + field_1447], 0x0         # 00480fe0
    mov ecx, dword ptr [ebp - local_8]           # 00480fe9
    mov edx, dword ptr [ebp - local_8]           # 00480fec
    mov eax, dword ptr [ecx + field_89]          # 00480fef
    sub eax, dword ptr [edx + field_81]          # 00480ff5
    mov ecx, dword ptr [ebp - local_f0]          # 00480ffb
    mov word ptr [ecx + field_1449], ax          # 00481001
    mov edx, dword ptr [ebp - local_8]           # 00481008
    mov eax, dword ptr [ebp - local_8]           # 0048100b
    mov ecx, dword ptr [edx + field_8d]          # 0048100e
    sub ecx, dword ptr [eax + field_85]          # 00481014
    mov edx, dword ptr [ebp - local_f0]          # 0048101a
    mov word ptr [edx + field_144b], cx          # 00481020
    mov eax, dword ptr [ebp - local_f0]          # 00481027
    cmp dword ptr [eax + field_13a4], 0x0        # 0048102d
    jne.d8 L_0048105c                            # 00481034
    # block 0x00481036: entered by fall-through of jne at 0x00481034, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0048105c
    push 0x54d5dc                                # 00481036
    push 0x6                                     # 0048103b
    mov ecx, dword ptr [ebp - local_8]           # 0048103d
    push ecx                                     # 00481040
    push 0x54d5f4                                # 00481041
    mov ecx, 0x5cf659                            # 00481046
    call FUN_004c2790                            # 0048104b
    mov edx, dword ptr [ebp - local_f0]          # 00481050
    mov dword ptr [edx + field_13a4], eax        # 00481056
L_0048105c:
    # block 0x0048105c: entered by jne at 0x00481034, 2 instruction(s), ends with forward jump to 0x0048106e
    mov dword ptr [ebp - local_c], 0x0           # 0048105c
    jmp.d8 L_0048106e                            # 00481063
L_00481065:
    # block 0x00481065: entered by jmp at 0x004810ab, 3 instruction(s), falls into the block at 0x0048106e
    mov eax, dword ptr [ebp - local_c]           # 00481065
    add eax, 0x1                                 # 00481068
    mov dword ptr [ebp - local_c], eax           # 0048106b
L_0048106e:
    # block 0x0048106e: entered by jmp at 0x00481063, 2 instruction(s), ends with jge to 0x004810ad (forward)
    cmp dword ptr [ebp - local_c], 0x14          # 0048106e
    jge.d8 L_004810ad                            # 00481072
    # block 0x00481074: entered by fall-through of jge at 0x00481072, 2 instruction(s), ends with forward jump to 0x00481086
    mov dword ptr [ebp - local_4], 0x0           # 00481074
    jmp.d8 L_00481086                            # 0048107b
L_0048107d:
    # block 0x0048107d: entered by jmp at 0x004810a9, 3 instruction(s), falls into the block at 0x00481086
    mov ecx, dword ptr [ebp - local_4]           # 0048107d
    add ecx, 0x1                                 # 00481080
    mov dword ptr [ebp - local_4], ecx           # 00481083
L_00481086:
    # block 0x00481086: entered by jmp at 0x0048107b, 2 instruction(s), ends with jge to 0x004810ab (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00481086
    jge.d8 L_004810ab                            # 0048108a
    # block 0x0048108c: entered by fall-through of jge at 0x0048108a, 8 instruction(s), ends with backward jump to 0x0048107d
    mov edx, dword ptr [ebp - local_c]           # 0048108c
    imul edx, edx, 0x60                          # 0048108f
    mov eax, dword ptr [ebp - local_f0]          # 00481092
    lea ecx, [eax + edx + field_20]              # 00481098
    mov edx, dword ptr [ebp - local_4]           # 0048109c
    imul edx, edx, 0x18                          # 0048109f
    mov dword ptr [ecx + edx], 0x0               # 004810a2
    jmp.d8 L_0048107d                            # 004810a9
L_004810ab:
    # block 0x004810ab: entered by jge at 0x0048108a, 1 instruction(s), ends with backward jump to 0x00481065
    jmp.d8 L_00481065                            # 004810ab
L_004810ad:
    # block 0x004810ad: entered by jge at 0x00481072, 5 instruction(s), ends with je to 0x0048112a (forward)
    mov eax, dword ptr [ebp - local_8]           # 004810ad
    {load} xor ecx, ecx                          # 004810b0
    mov cl, byte ptr [eax + field_42]            # 004810b2
    test ecx, ecx                                # 004810b5
    je.d8 L_0048112a                             # 004810b7
    # block 0x004810b9: entered by fall-through of je at 0x004810b7, 2 instruction(s), ends with je to 0x0048112a (forward)
    cmp dword ptr [0x5a055d], 0x0                # 004810b9
    je.d8 L_0048112a                             # 004810c0
    # block 0x004810c2: entered by fall-through of je at 0x004810c0, 3 instruction(s), ends with jne to 0x0048112a (forward)
    movsx edx, word ptr [0x5a0561]               # 004810c2
    cmp edx, dword ptr [0x5bb57b]                # 004810c9
    jne.d8 L_0048112a                            # 004810cf
    # block 0x004810d1: entered by fall-through of jne at 0x004810cf, 17 instruction(s), ends with forward jump to 0x0048118b
    mov edi, dword ptr [ebp - local_f0]          # 004810d1
    add edi, 0x7b4                               # 004810d7
    mov ecx, 0x2e4                               # 004810dd
    mov esi, 0x5a0577                            # 004810e2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004810e7
    mov edi, dword ptr [ebp - local_f0]          # 004810e9
    add edi, 0x7a0                               # 004810ef
    mov ecx, 0x5                                 # 004810f5
    mov esi, 0x5a0563                            # 004810fa
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004810ff
    mov eax, dword ptr [ebp - local_f0]          # 00481101
    mov cx, word ptr [0x5a1107]                  # 00481107
    mov word ptr [eax + field_13a2], cx          # 0048110e
    mov edx, dword ptr [ebp - local_f0]          # 00481115
    mov ax, word ptr [0x5a1109]                  # 0048111b
    mov word ptr [edx + field_1443], ax          # 00481121
    jmp.d8 L_0048118b                            # 00481128
L_0048112a:
    # block 0x0048112a: entered by je at 0x004810b7; je at 0x004810c0; jne at 0x004810cf, 21 instruction(s), falls into the block at 0x0048118b
    mov cx, word ptr [0x5bb57b]                  # 0048112a
    mov word ptr [0x5a0561], cx                  # 00481131
    mov ecx, 0x2e4                               # 00481138
    {load} xor eax, eax                          # 0048113d
    mov edi, dword ptr [ebp - local_f0]          # 0048113f
    add edi, 0x7b4                               # 00481145
    rep stosd dword ptr es:[edi], eax            # 0048114b
    {load} xor edx, edx                          # 0048114d
    mov eax, dword ptr [ebp - local_f0]          # 0048114f
    add eax, 0x7a0                               # 00481155
    mov dword ptr [eax], edx                     # 0048115a
    mov dword ptr [eax + field_4], edx           # 0048115c
    mov dword ptr [eax + field_8], edx           # 0048115f
    mov dword ptr [eax + field_c], edx           # 00481162
    mov dword ptr [eax + field_10], edx          # 00481165
    mov ecx, dword ptr [ebp - local_f0]          # 00481168
    mov edx, dword ptr [ebp - local_8]           # 0048116e
    mov ax, word ptr [edx + field_43]            # 00481171
    mov word ptr [ecx + field_13a2], ax          # 00481175
    mov ecx, dword ptr [ebp - local_f0]          # 0048117c
    mov word ptr [ecx + field_1443], 0x0         # 00481182
L_0048118b:
    # block 0x0048118b: entered by jmp at 0x00481128, 2 instruction(s), ends with forward jump to 0x0048119d
    mov dword ptr [ebp - local_c], 0x0           # 0048118b
    jmp.d8 L_0048119d                            # 00481192
L_00481194:
    # block 0x00481194: entered by jmp at 0x004811c0, 3 instruction(s), falls into the block at 0x0048119d
    mov edx, dword ptr [ebp - local_c]           # 00481194
    add edx, 0x1                                 # 00481197
    mov dword ptr [ebp - local_c], edx           # 0048119a
L_0048119d:
    # block 0x0048119d: entered by jmp at 0x00481192, 4 instruction(s), ends with jge to 0x004811c2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048119d
    movsx ecx, word ptr [eax + field_43]         # 004811a0
    cmp dword ptr [ebp - local_c], ecx           # 004811a4
    jge.d8 L_004811c2                            # 004811a7
    # block 0x004811a9: entered by fall-through of jge at 0x004811a7, 8 instruction(s), calls FUN_0047e582, ends with backward jump to 0x00481194
    push 0x0                                     # 004811a9
    mov dx, word ptr [ebp - local_c]             # 004811ab
    push edx                                     # 004811af
    mov ax, word ptr [ebp - local_c]             # 004811b0
    push eax                                     # 004811b4
    mov ecx, dword ptr [ebp - local_f0]          # 004811b5
    call FUN_0047e582                            # 004811bb
    jmp.d8 L_00481194                            # 004811c0
L_004811c2:
    # block 0x004811c2: entered by jge at 0x004811a7, 7 instruction(s), ends with je to 0x004811ee (forward)
    mov edi, 0x54d5fc                            # 004811c2
    mov esi, dword ptr [ebp - local_8]           # 004811c7
    add esi, 0x21                                # 004811ca
    mov ecx, 0x8                                 # 004811cd
    {load} xor edx, edx                          # 004811d2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004811d4
    je.d8 L_004811ee                             # 004811d6
    # block 0x004811d8: entered by fall-through of je at 0x004811d6, 7 instruction(s), ends with jne to 0x0048120d (forward)
    mov edi, 0x63a89c                            # 004811d8
    mov esi, dword ptr [ebp - local_8]           # 004811dd
    add esi, 0x21                                # 004811e0
    mov ecx, 0x1                                 # 004811e3
    {load} xor eax, eax                          # 004811e8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004811ea
    jne.d8 L_0048120d                            # 004811ec
L_004811ee:
    # block 0x004811ee: entered by je at 0x004811d6; fall-through of jne at 0x004811ec, 5 instruction(s), ends with forward jump to 0x00481243
    mov ecx, dword ptr [ebp - local_f0]          # 004811ee
    mov byte ptr [ecx + field_13b0], 0x0         # 004811f4
    mov edx, dword ptr [ebp - local_f0]          # 004811fb
    mov dword ptr [edx + field_13a8], 0x0        # 00481201
    jmp.d8 L_00481243                            # 0048120b
L_0048120d:
    # block 0x0048120d: entered by jne at 0x004811ec, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x00481243
    push 0x54d604                                # 0048120d
    push 0x6                                     # 00481212
    mov eax, dword ptr [ebp - local_8]           # 00481214
    add eax, 0x21                                # 00481217
    push eax                                     # 0048121a
    push 0x54d620                                # 0048121b
    mov ecx, 0x5cf659                            # 00481220
    call FUN_004c2790                            # 00481225
    mov ecx, dword ptr [ebp - local_f0]          # 0048122a
    mov dword ptr [ecx + field_13a8], eax        # 00481230
    mov edx, dword ptr [ebp - local_f0]          # 00481236
    mov byte ptr [edx + field_13b0], 0x1         # 0048123c
L_00481243:
    # block 0x00481243: entered by jmp at 0x0048120b, 7 instruction(s), ends with je to 0x0048126f (forward)
    mov edi, 0x54d628                            # 00481243
    mov esi, dword ptr [ebp - local_8]           # 00481248
    add esi, 0x60                                # 0048124b
    mov ecx, 0x8                                 # 0048124e
    {load} xor eax, eax                          # 00481253
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481255
    je.d8 L_0048126f                             # 00481257
    # block 0x00481259: entered by fall-through of je at 0x00481257, 7 instruction(s), ends with jne to 0x0048128e (forward)
    mov edi, 0x63a8a0                            # 00481259
    mov esi, dword ptr [ebp - local_8]           # 0048125e
    add esi, 0x60                                # 00481261
    mov ecx, 0x1                                 # 00481264
    {load} xor edx, edx                          # 00481269
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048126b
    jne.d8 L_0048128e                            # 0048126d
L_0048126f:
    # block 0x0048126f: entered by je at 0x00481257; fall-through of jne at 0x0048126d, 5 instruction(s), ends with forward jump to 0x004812c4
    mov eax, dword ptr [ebp - local_f0]          # 0048126f
    mov byte ptr [eax + field_13b4], 0x0         # 00481275
    mov ecx, dword ptr [ebp - local_f0]          # 0048127c
    mov dword ptr [ecx + field_13ac], 0x0        # 00481282
    jmp.d8 L_004812c4                            # 0048128c
L_0048128e:
    # block 0x0048128e: entered by jne at 0x0048126d, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x004812c4
    push 0x54d630                                # 0048128e
    push 0x6                                     # 00481293
    mov edx, dword ptr [ebp - local_8]           # 00481295
    add edx, 0x60                                # 00481298
    push edx                                     # 0048129b
    push 0x54d644                                # 0048129c
    mov ecx, 0x5cf659                            # 004812a1
    call FUN_004c2790                            # 004812a6
    mov ecx, dword ptr [ebp - local_f0]          # 004812ab
    mov dword ptr [ecx + field_13ac], eax        # 004812b1
    mov edx, dword ptr [ebp - local_f0]          # 004812b7
    mov byte ptr [edx + field_13b4], 0x1         # 004812bd
L_004812c4:
    # block 0x004812c4: entered by jmp at 0x0048128c, 67 instruction(s), calls FUN_004d39f9, ends with je to 0x00481414 (forward)
    mov eax, dword ptr [ebp - local_f0]          # 004812c4
    mov byte ptr [eax + field_13b3], 0x0         # 004812ca
    mov ecx, dword ptr [ebp - local_f0]          # 004812d1
    mov byte ptr [ecx + field_13b2], 0x0         # 004812d7
    mov edx, dword ptr [ebp - local_f0]          # 004812de
    mov byte ptr [edx + field_13b1], 0x0         # 004812e4
    call FUN_004d39f9                            # 004812eb
    mov ecx, dword ptr [ebp - local_f0]          # 004812f0
    mov word ptr [ecx + field_1c], ax            # 004812f6
    mov edx, dword ptr [ebp - local_f0]          # 004812fa
    movsx eax, word ptr [edx + field_1c]         # 00481300
    imul eax, eax, 0x4a                          # 00481304
    mov dword ptr [eax + 0x5d1591], 0xa          # 00481307
    mov ecx, dword ptr [ebp - local_f0]          # 00481311
    movsx edx, word ptr [ecx + field_1c]         # 00481317
    imul edx, edx, 0x4a                          # 0048131b
    mov dword ptr [edx + 0x5d1595], 0x481cb9     # 0048131e
    mov eax, dword ptr [ebp - local_f0]          # 00481328
    movsx ecx, word ptr [eax + field_1c]         # 0048132e
    imul ecx, ecx, 0x4a                          # 00481332
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00481335
    mov edx, dword ptr [ebp - local_f0]          # 0048133f
    movsx eax, word ptr [edx + field_1c]         # 00481345
    imul eax, eax, 0x4a                          # 00481349
    mov dword ptr [eax + 0x5d159d], 0x0          # 0048134c
    mov ecx, dword ptr [ebp - local_f0]          # 00481356
    movsx edx, word ptr [ecx + field_1c]         # 0048135c
    imul edx, edx, 0x4a                          # 00481360
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00481363
    mov eax, dword ptr [ebp - local_f0]          # 0048136d
    movsx ecx, word ptr [eax + field_1c]         # 00481373
    imul ecx, ecx, 0x4a                          # 00481377
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048137a
    mov edx, dword ptr [ebp - local_f0]          # 00481384
    movsx eax, word ptr [edx + field_1c]         # 0048138a
    imul eax, eax, 0x4a                          # 0048138e
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00481391
    mov ecx, dword ptr [ebp - local_f0]          # 0048139b
    movsx edx, word ptr [ecx + field_1c]         # 004813a1
    imul edx, edx, 0x4a                          # 004813a5
    mov word ptr [edx + 0x5d15ad], 0x0           # 004813a8
    mov edi, 0x54d64c                            # 004813b1
    mov eax, dword ptr [ebp - local_f0]          # 004813b6
    movsx ecx, word ptr [eax + field_1c]         # 004813bc
    imul ecx, ecx, 0x4a                          # 004813c0
    add ecx, 0x5d15b3                            # 004813c3
    {load} mov edx, ecx                          # 004813c9
    or ecx, -0x1                                 # 004813cb
    {load} xor eax, eax                          # 004813ce
    repne scasb al, byte ptr es:[edi]            # 004813d0
    not ecx                                      # 004813d2
    {load} sub edi, ecx                          # 004813d4
    {load} mov esi, edi                          # 004813d6
    {load} mov eax, ecx                          # 004813d8
    {load} mov edi, edx                          # 004813da
    shr ecx, 0x2                                 # 004813dc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004813df
    {load} mov ecx, eax                          # 004813e1
    and ecx, 0x3                                 # 004813e3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004813e6
    mov edi, 0x54d668                            # 004813e8
    mov esi, dword ptr [ebp - local_8]           # 004813ed
    add esi, 0x746                               # 004813f0
    mov ecx, 0x9                                 # 004813f6
    {load} xor edx, edx                          # 004813fb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004813fd
    je.d8 L_00481414                             # 004813ff
    # block 0x00481401: entered by fall-through of je at 0x004813ff, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00481414
    mov eax, dword ptr [ebp - local_8]           # 00481401
    add eax, 0x746                               # 00481404
    push eax                                     # 00481409
    mov ecx, 0x5c3a67                            # 0048140a
    call FUN_004fb77a                            # 0048140f
L_00481414:
    # block 0x00481414: entered by je at 0x004813ff, 7 instruction(s), ends with je to 0x00481440 (forward)
    mov edi, 0x54d674                            # 00481414
    mov esi, dword ptr [ebp - local_8]           # 00481419
    add esi, 0x777                               # 0048141c
    mov ecx, 0x9                                 # 00481422
    {load} xor edx, edx                          # 00481427
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481429
    je.d8 L_00481440                             # 0048142b
    # block 0x0048142d: entered by fall-through of je at 0x0048142b, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00481440
    mov eax, dword ptr [ebp - local_8]           # 0048142d
    add eax, 0x777                               # 00481430
    push eax                                     # 00481435
    mov ecx, 0x5c3a67                            # 00481436
    call FUN_004fb77a                            # 0048143b
L_00481440:
    # block 0x00481440: entered by je at 0x0048142b, 7 instruction(s), ends with je to 0x0048146c (forward)
    mov edi, 0x54d680                            # 00481440
    mov esi, dword ptr [ebp - local_8]           # 00481445
    add esi, 0x715                               # 00481448
    mov ecx, 0x9                                 # 0048144e
    {load} xor edx, edx                          # 00481453
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481455
    je.d8 L_0048146c                             # 00481457
    # block 0x00481459: entered by fall-through of je at 0x00481457, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0048146c
    mov eax, dword ptr [ebp - local_8]           # 00481459
    add eax, 0x715                               # 0048145c
    push eax                                     # 00481461
    mov ecx, 0x5c3a67                            # 00481462
    call FUN_004fb77a                            # 00481467
L_0048146c:
    # block 0x0048146c: entered by je at 0x00481457, 7 instruction(s), ends with je to 0x00481498 (forward)
    mov edi, 0x54d68c                            # 0048146c
    mov esi, dword ptr [ebp - local_8]           # 00481471
    add esi, 0x7a8                               # 00481474
    mov ecx, 0x9                                 # 0048147a
    {load} xor edx, edx                          # 0048147f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481481
    je.d8 L_00481498                             # 00481483
    # block 0x00481485: entered by fall-through of je at 0x00481483, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00481498
    mov eax, dword ptr [ebp - local_8]           # 00481485
    add eax, 0x7a8                               # 00481488
    push eax                                     # 0048148d
    mov ecx, 0x5c3a67                            # 0048148e
    call FUN_004fb77a                            # 00481493
L_00481498:
    # block 0x00481498: entered by je at 0x00481483, 1 instruction(s), ends with forward jump to 0x00481c85
    jmp.d32 L_00481c85                           # 00481498
L_0048149d:
    # block 0x0048149d: entered by je at 0x00480e53, 5 instruction(s), ends with ja to 0x00481a13 (forward)
    mov ecx, dword ptr [ebp - local_f0]          # 0048149d
    mov edx, dword ptr [ecx + field_13ca]        # 004814a3
    mov dword ptr [ebp - local_f8], edx          # 004814a9
    cmp dword ptr [ebp - local_f8], 0x6          # 004814af
    ja.d32 L_00481a13                            # 004814b6
    # block 0x004814bc: entered by fall-through of ja at 0x004814b6, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x481c8d]
    mov eax, dword ptr [ebp - local_f8]          # 004814bc
    jmp dword ptr [4*eax + SWTAB_00481c8d_VA]    # 004814c2
L_004814c9:
    # block 0x004814c9: entered by switch case, 4 instruction(s), ends with jl to 0x004814f5 (forward)
    mov ecx, dword ptr [ebp - local_f0]          # 004814c9
    movsx edx, word ptr [ecx + field_13a2]       # 004814cf
    cmp edx, 0x50                                # 004814d6
    jl.d8 L_004814f5                             # 004814d9
    # block 0x004814db: entered by fall-through of jl at 0x004814d9, 4 instruction(s), falls into the block at 0x004814f5
    mov eax, dword ptr [ebp - local_f0]          # 004814db
    movsx ecx, word ptr [eax + field_1e]         # 004814e1
    imul ecx, ecx, 0x8d                          # 004814e5
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004814eb
L_004814f5:
    # block 0x004814f5: entered by jl at 0x004814d9, 1 instruction(s), ends with forward jump to 0x00481a13
    jmp.d32 L_00481a13                           # 004814f5
L_004814fa:
    # block 0x004814fa: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048151e (forward)
    call dword ptr [0x52a23c]                    # 004814fa
    mov edx, dword ptr [ebp - local_f0]          # 00481500
    cmp eax, dword ptr [edx + field_13e7]        # 00481506
    jb.d8 L_0048151e                             # 0048150c
    # block 0x0048150e: entered by fall-through of jb at 0x0048150c, 2 instruction(s), falls into the block at 0x0048151e
    mov eax, dword ptr [ebp - local_f0]          # 0048150e
    mov dword ptr [eax + field_13ca], 0x0        # 00481514
L_0048151e:
    # block 0x0048151e: entered by jb at 0x0048150c, 1 instruction(s), ends with forward jump to 0x00481a13
    jmp.d32 L_00481a13                           # 0048151e
L_00481523:
    # block 0x00481523: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048155c (forward)
    call dword ptr [0x52a23c]                    # 00481523
    mov ecx, dword ptr [ebp - local_f0]          # 00481529
    cmp eax, dword ptr [ecx + field_13eb]        # 0048152f
    jb.d8 L_0048155c                             # 00481535
    # block 0x00481537: entered by fall-through of jb at 0x00481535, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0048155c
    mov edx, dword ptr [ebp - local_f0]          # 00481537
    mov dword ptr [edx + field_13ca], 0x4        # 0048153d
    call dword ptr [0x52a23c]                    # 00481547
    add eax, 0x64                                # 0048154d
    mov ecx, dword ptr [ebp - local_f0]          # 00481550
    mov dword ptr [ecx + field_13eb], eax        # 00481556
L_0048155c:
    # block 0x0048155c: entered by jb at 0x00481535, 1 instruction(s), ends with forward jump to 0x00481a13
    jmp.d32 L_00481a13                           # 0048155c
L_00481561:
    # block 0x00481561: entered by switch case, 5 instruction(s), ends with jne to 0x004815c0 (forward)
    mov edx, dword ptr [ebp - local_f0]          # 00481561
    {load} xor eax, eax                          # 00481567
    mov al, byte ptr [edx + field_13b4]          # 00481569
    test eax, eax                                # 0048156f
    jne.d8 L_004815c0                            # 00481571
    # block 0x00481573: entered by fall-through of jne at 0x00481571, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004815bb (forward)
    call dword ptr [0x52a23c]                    # 00481573
    mov ecx, dword ptr [ebp - local_f0]          # 00481579
    cmp eax, dword ptr [ecx + field_13e7]        # 0048157f
    jb.d8 L_004815bb                             # 00481585
    # block 0x00481587: entered by fall-through of jb at 0x00481585, 5 instruction(s), ends with jne to 0x004815ab (forward)
    mov edx, dword ptr [ebp - local_f0]          # 00481587
    {load} xor eax, eax                          # 0048158d
    mov al, byte ptr [edx + field_13ce]          # 0048158f
    test eax, eax                                # 00481595
    jne.d8 L_004815ab                            # 00481597
    # block 0x00481599: entered by fall-through of jne at 0x00481597, 3 instruction(s), ends with forward jump to 0x004815bb
    mov ecx, dword ptr [ebp - local_f0]          # 00481599
    mov dword ptr [ecx + field_13ca], 0x0        # 0048159f
    jmp.d8 L_004815bb                            # 004815a9
L_004815ab:
    # block 0x004815ab: entered by jne at 0x00481597, 2 instruction(s), falls into the block at 0x004815bb
    mov edx, dword ptr [ebp - local_f0]          # 004815ab
    mov dword ptr [edx + field_13ca], 0x6        # 004815b1
L_004815bb:
    # block 0x004815bb: entered by jb at 0x00481585; jmp at 0x004815a9, 1 instruction(s), ends with forward jump to 0x00481811
    jmp.d32 L_00481811                           # 004815bb
L_004815c0:
    # block 0x004815c0: entered by jne at 0x00481571, 9 instruction(s), ends with je to 0x00481620 (forward)
    mov eax, dword ptr [ebp - local_f0]          # 004815c0
    mov byte ptr [eax + field_13b2], 0x1         # 004815c6
    mov edi, 0x54d698                            # 004815cd
    mov esi, dword ptr [ebp - local_8]           # 004815d2
    add esi, 0x777                               # 004815d5
    mov ecx, 0x9                                 # 004815db
    {load} xor edx, edx                          # 004815e0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004815e2
    je.d8 L_00481620                             # 004815e4
    # block 0x004815e6: entered by fall-through of je at 0x004815e4, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00481620 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004815e6
    movsx ecx, word ptr [eax + field_798]        # 004815e9
    mov dword ptr [ebp - local_e8], ecx          # 004815f0
    mov edx, dword ptr [ebp - local_e8]          # 004815f6
    push edx                                     # 004815fc
    mov ecx, 0x5cf1eb                            # 004815fd
    call FUN_004f6334                            # 00481602
    test eax, eax                                # 00481607
    jne.d8 L_00481620                            # 00481609
    # block 0x0048160b: entered by fall-through of jne at 0x00481609, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00481620
    mov eax, dword ptr [ebp - local_8]           # 0048160b
    mov cx, word ptr [eax + field_798]           # 0048160e
    push ecx                                     # 00481615
    mov ecx, 0x5c3a67                            # 00481616
    call FUN_004fb2e3                            # 0048161b
L_00481620:
    # block 0x00481620: entered by je at 0x004815e4; jne at 0x00481609, 12 instruction(s), ends with jl to 0x0048167d (forward)
    mov edx, dword ptr [ebp - local_f0]          # 00481620
    movsx eax, word ptr [edx + field_1447]       # 00481626
    mov ecx, dword ptr [ebp - local_8]           # 0048162d
    movsx ecx, word ptr [ecx + field_93]         # 00481630
    cdq                                          # 00481637
    idiv ecx                                     # 00481638
    mov word ptr [ebp - local_10], ax            # 0048163a
    movsx edx, word ptr [ebp - local_10]         # 0048163e
    mov eax, dword ptr [ebp - local_8]           # 00481642
    movsx ecx, word ptr [eax + field_91]         # 00481645
    {load} cmp edx, ecx                          # 0048164c
    jl.d8 L_0048167d                             # 0048164e
    # block 0x00481650: entered by fall-through of jl at 0x0048164e, 7 instruction(s), falls into the block at 0x0048167d
    mov edx, dword ptr [ebp - local_f0]          # 00481650
    mov word ptr [edx + field_1447], 0x0         # 00481656
    mov eax, dword ptr [ebp - local_f0]          # 0048165f
    mov cx, word ptr [eax + field_1445]          # 00481665
    add cx, 0x1                                  # 0048166c
    mov edx, dword ptr [ebp - local_f0]          # 00481670
    mov word ptr [edx + field_1445], cx          # 00481676
L_0048167d:
    # block 0x0048167d: entered by jl at 0x0048164e, 6 instruction(s), ends with jge to 0x004817b4 (forward)
    mov eax, dword ptr [ebp - local_f0]          # 0048167d
    movsx ecx, word ptr [eax + field_1445]       # 00481683
    mov edx, dword ptr [ebp - local_8]           # 0048168a
    movsx eax, word ptr [edx + field_97]         # 0048168d
    {load} cmp ecx, eax                          # 00481694
    jge.d32 L_004817b4                           # 00481696
    # block 0x0048169c: entered by fall-through of jge at 0x00481696, 56 instruction(s), ends with forward jump to 0x00481811
    mov ecx, dword ptr [ebp - local_f0]          # 0048169c
    movsx eax, word ptr [ecx + field_1447]       # 004816a2
    mov edx, dword ptr [ebp - local_8]           # 004816a9
    movsx ecx, word ptr [edx + field_93]         # 004816ac
    cdq                                          # 004816b3
    idiv ecx                                     # 004816b4
    mov word ptr [ebp - local_10], ax            # 004816b6
    mov edx, dword ptr [ebp - local_f0]          # 004816ba
    movsx eax, word ptr [edx + field_1447]       # 004816c0
    mov ecx, dword ptr [ebp - local_8]           # 004816c7
    movsx ecx, word ptr [ecx + field_93]         # 004816ca
    cdq                                          # 004816d1
    idiv ecx                                     # 004816d2
    mov word ptr [ebp - local_18], dx            # 004816d4
    mov edx, dword ptr [ebp - local_f0]          # 004816d8
    movsx eax, word ptr [edx + field_1449]       # 004816de
    mov ecx, dword ptr [ebp - local_8]           # 004816e5
    movsx edx, word ptr [ecx + field_95]         # 004816e8
    {load} add eax, edx                          # 004816ef
    movsx ecx, word ptr [ebp - local_18]         # 004816f1
    imul eax, ecx                                # 004816f5
    add eax, 0x1                                 # 004816f8
    mov edx, dword ptr [ebp - local_f0]          # 004816fb
    mov dword ptr [edx + field_13b5], eax        # 00481701
    mov eax, dword ptr [ebp - local_f0]          # 00481707
    movsx ecx, word ptr [eax + field_144b]       # 0048170d
    mov edx, dword ptr [ebp - local_8]           # 00481714
    movsx eax, word ptr [edx + field_95]         # 00481717
    {load} add ecx, eax                          # 0048171e
    movsx edx, word ptr [ebp - local_10]         # 00481720
    imul ecx, edx                                # 00481724
    add ecx, 0x1                                 # 00481727
    mov eax, dword ptr [ebp - local_f0]          # 0048172a
    mov dword ptr [eax + field_13b9], ecx        # 00481730
    mov ecx, dword ptr [ebp - local_f0]          # 00481736
    movsx edx, word ptr [ecx + field_1449]       # 0048173c
    mov eax, dword ptr [ebp - local_f0]          # 00481743
    mov ecx, dword ptr [eax + field_13b5]        # 00481749
    {load} add ecx, edx                          # 0048174f
    mov edx, dword ptr [ebp - local_f0]          # 00481751
    mov dword ptr [edx + field_13bd], ecx        # 00481757
    mov eax, dword ptr [ebp - local_f0]          # 0048175d
    movsx ecx, word ptr [eax + field_144b]       # 00481763
    mov edx, dword ptr [ebp - local_f0]          # 0048176a
    mov eax, dword ptr [edx + field_13b9]        # 00481770
    {load} add eax, ecx                          # 00481776
    mov ecx, dword ptr [ebp - local_f0]          # 00481778
    mov dword ptr [ecx + field_13c1], eax        # 0048177e
    mov edx, dword ptr [ebp - local_f0]          # 00481784
    mov ax, word ptr [edx + field_1447]          # 0048178a
    .insn 0x66, 0x05, 0x0001{:u16}               # 00481791
    mov ecx, dword ptr [ebp - local_f0]          # 00481795
    mov word ptr [ecx + field_1447], ax          # 0048179b
    mov edx, dword ptr [ebp - local_f0]          # 004817a2
    mov dword ptr [edx + field_13ca], 0x5        # 004817a8
    jmp.d8 L_00481811                            # 004817b2
L_004817b4:
    # block 0x004817b4: entered by jge at 0x00481696, 11 instruction(s), ends with jne to 0x00481801 (forward)
    mov eax, dword ptr [ebp - local_f0]          # 004817b4
    mov word ptr [eax + field_1445], 0x0         # 004817ba
    mov ecx, dword ptr [ebp - local_f0]          # 004817c3
    mov byte ptr [ecx + field_13b3], 0x1         # 004817c9
    mov edx, dword ptr [ebp - local_f0]          # 004817d0
    mov byte ptr [edx + field_13b2], 0x0         # 004817d6
    mov eax, dword ptr [ebp - local_f0]          # 004817dd
    {load} xor ecx, ecx                          # 004817e3
    mov cl, byte ptr [eax + field_13ce]          # 004817e5
    test ecx, ecx                                # 004817eb
    jne.d8 L_00481801                            # 004817ed
    # block 0x004817ef: entered by fall-through of jne at 0x004817ed, 3 instruction(s), ends with forward jump to 0x00481811
    mov edx, dword ptr [ebp - local_f0]          # 004817ef
    mov dword ptr [edx + field_13ca], 0x0        # 004817f5
    jmp.d8 L_00481811                            # 004817ff
L_00481801:
    # block 0x00481801: entered by jne at 0x004817ed, 2 instruction(s), falls into the block at 0x00481811
    mov eax, dword ptr [ebp - local_f0]          # 00481801
    mov dword ptr [eax + field_13ca], 0x6        # 00481807
L_00481811:
    # block 0x00481811: entered by jmp at 0x004815bb; jmp at 0x004817b2; jmp at 0x004817ff, 1 instruction(s), ends with forward jump to 0x00481a13
    jmp.d32 L_00481a13                           # 00481811
L_00481816:
    # block 0x00481816: entered by switch case, 7 instruction(s), ends with je to 0x004819a4 (forward)
    mov edi, 0x54d6a4                            # 00481816
    mov esi, dword ptr [ebp - local_8]           # 0048181b
    add esi, 0x8e1                               # 0048181e
    mov ecx, 0x9                                 # 00481824
    {load} xor edx, edx                          # 00481829
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048182b
    je.d32 L_004819a4                            # 0048182d
    # block 0x00481833: entered by fall-through of je at 0x0048182d, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00481992 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00481833
    add eax, 0x8e1                               # 00481836
    push eax                                     # 0048183b
    mov ecx, 0x5c3a67                            # 0048183c
    call FUN_004fb77a                            # 00481841
    mov ecx, dword ptr [ebp - local_8]           # 00481846
    mov dx, word ptr [ecx + field_902]           # 00481849
    push edx                                     # 00481850
    mov ecx, 0x5c3a67                            # 00481851
    call FUN_004fb2e3                            # 00481856
    cmp dword ptr [0x5bb202], 0x0                # 0048185b
    je.d32 L_00481992                            # 00481862
    # block 0x00481868: entered by fall-through of je at 0x00481862, 9 instruction(s), ends with jbe to 0x00481915 (forward)
    mov edi, dword ptr [ebp - local_8]           # 00481868
    add edi, 0x912                               # 0048186b
    or ecx, -0x1                                 # 00481871
    {load} xor eax, eax                          # 00481874
    repne scasb al, byte ptr es:[edi]            # 00481876
    not ecx                                      # 00481878
    add ecx, -0x1                                # 0048187a
    test ecx, ecx                                # 0048187d
    jbe.d32 L_00481915                           # 0048187f
    # block 0x00481885: entered by fall-through of jbe at 0x0048187f, 8 instruction(s), calls FUN_00423259, ends with je to 0x0048190e (forward)
    mov eax, dword ptr [ebp - local_8]           # 00481885
    add eax, 0x912                               # 00481888
    push eax                                     # 0048188d
    mov ecx, 0x619a6b                            # 0048188e
    call FUN_00423259                            # 00481893
    mov dword ptr [ebp - local_14], eax          # 00481898
    cmp dword ptr [ebp - local_14], 0x0          # 0048189b
    je.d8 L_0048190e                             # 0048189f
    # block 0x004818a1: entered by fall-through of je at 0x0048189f, 8 instruction(s), ends with ja to 0x0048190e (forward)
    mov edi, dword ptr [ebp - local_14]          # 004818a1
    or ecx, -0x1                                 # 004818a4
    {load} xor eax, eax                          # 004818a7
    repne scasb al, byte ptr es:[edi]            # 004818a9
    not ecx                                      # 004818ab
    add ecx, -0x1                                # 004818ad
    cmp ecx, 0x9c40                              # 004818b0
    ja.d8 L_0048190e                             # 004818b6
    # block 0x004818b8: entered by fall-through of ja at 0x004818b6, 28 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00481915
    mov edi, dword ptr [ebp - local_14]          # 004818b8
    or ecx, -0x1                                 # 004818bb
    {load} xor eax, eax                          # 004818be
    repne scasb al, byte ptr es:[edi]            # 004818c0
    not ecx                                      # 004818c2
    mov esi, dword ptr [ebp - local_14]          # 004818c4
    lea edi, [ebp - local_e4]                    # 004818c7
    {load} mov edx, ecx                          # 004818cd
    shr ecx, 0x2                                 # 004818cf
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004818d2
    {load} mov ecx, edx                          # 004818d4
    and ecx, 0x3                                 # 004818d6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004818d9
    lea edi, [ebp - local_e4]                    # 004818db
    or ecx, -0x1                                 # 004818e1
    {load} xor eax, eax                          # 004818e4
    repne scasb al, byte ptr es:[edi]            # 004818e6
    mov eax, dword ptr [0x54d6b0]                # 004818e8
    mov dword ptr [edi - field_minus_1], eax     # 004818ed
    push 0x0                                     # 004818f0
    push -0x1                                    # 004818f2
    lea ecx, [ebp - local_e4]                    # 004818f4
    push ecx                                     # 004818fa
    mov edx, dword ptr [0x5d03b3]                # 004818fb
    push edx                                     # 00481901
    mov ecx, 0x619a05                            # 00481902
    call FUN_00448d11                            # 00481907
    jmp.d8 L_00481915                            # 0048190c
L_0048190e:
    # block 0x0048190e: entered by je at 0x0048189f; ja at 0x004818b6, 1 instruction(s), falls into the block at 0x00481915
    mov dword ptr [ebp - local_14], 0x0          # 0048190e
L_00481915:
    # block 0x00481915: entered by jbe at 0x0048187f; jmp at 0x0048190c, 2 instruction(s), ends with jne to 0x00481992 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 00481915
    jne.d8 L_00481992                            # 00481919
    # block 0x0048191b: entered by fall-through of jne at 0x00481919, 9 instruction(s), ends with jbe to 0x00481992 (forward)
    mov edi, dword ptr [ebp - local_8]           # 0048191b
    add edi, 0x933                               # 0048191e
    or ecx, -0x1                                 # 00481924
    {load} xor eax, eax                          # 00481927
    repne scasb al, byte ptr es:[edi]            # 00481929
    not ecx                                      # 0048192b
    add ecx, -0x1                                # 0048192d
    test ecx, ecx                                # 00481930
    jbe.d8 L_00481992                            # 00481932
    # block 0x00481934: entered by fall-through of jbe at 0x00481932, 31 instruction(s), calls FUN_00448d11, falls into the block at 0x00481992
    mov eax, dword ptr [ebp - local_8]           # 00481934
    add eax, 0x933                               # 00481937
    {load} mov edi, eax                          # 0048193c
    lea edx, [ebp - local_e4]                    # 0048193e
    or ecx, -0x1                                 # 00481944
    {load} xor eax, eax                          # 00481947
    repne scasb al, byte ptr es:[edi]            # 00481949
    not ecx                                      # 0048194b
    {load} sub edi, ecx                          # 0048194d
    {load} mov esi, edi                          # 0048194f
    {load} mov eax, ecx                          # 00481951
    {load} mov edi, edx                          # 00481953
    shr ecx, 0x2                                 # 00481955
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00481958
    {load} mov ecx, eax                          # 0048195a
    and ecx, 0x3                                 # 0048195c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048195f
    lea edi, [ebp - local_e4]                    # 00481961
    or ecx, -0x1                                 # 00481967
    {load} xor eax, eax                          # 0048196a
    repne scasb al, byte ptr es:[edi]            # 0048196c
    mov ecx, dword ptr [0x54d6b4]                # 0048196e
    mov dword ptr [edi - field_minus_1], ecx     # 00481974
    push 0x0                                     # 00481977
    push -0x1                                    # 00481979
    lea edx, [ebp - local_e4]                    # 0048197b
    push edx                                     # 00481981
    mov eax, dword ptr [0x5d03b3]                # 00481982
    push eax                                     # 00481987
    mov ecx, 0x619a05                            # 00481988
    call FUN_00448d11                            # 0048198d
L_00481992:
    # block 0x00481992: entered by je at 0x00481862; jne at 0x00481919; jbe at 0x00481932, 3 instruction(s), ends with forward jump to 0x004819be
    mov ecx, dword ptr [ebp - local_f0]          # 00481992
    mov dword ptr [ecx + field_13ca], 0x3        # 00481998
    jmp.d8 L_004819be                            # 004819a2
L_004819a4:
    # block 0x004819a4: entered by je at 0x0048182d, 4 instruction(s), falls into the block at 0x004819be
    mov edx, dword ptr [ebp - local_f0]          # 004819a4
    movsx eax, word ptr [edx + field_1e]         # 004819aa
    imul eax, eax, 0x8d                          # 004819ae
    mov dword ptr [eax + 0x5bb632], 0x2          # 004819b4
L_004819be:
    # block 0x004819be: entered by jmp at 0x004819a2, 1 instruction(s), ends with forward jump to 0x00481a13
    jmp.d8 L_00481a13                            # 004819be
L_004819c0:
    # block 0x004819c0: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00481a13 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004819c0
    movsx edx, word ptr [ecx + field_902]        # 004819c3
    mov dword ptr [ebp - local_ec], edx          # 004819ca
    mov eax, dword ptr [ebp - local_ec]          # 004819d0
    push eax                                     # 004819d6
    mov ecx, 0x5cf1eb                            # 004819d7
    call FUN_004f6334                            # 004819dc
    test eax, eax                                # 004819e1
    jne.d8 L_00481a13                            # 004819e3
    # block 0x004819e5: entered by fall-through of jne at 0x004819e3, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x00481a13
    mov ecx, dword ptr [ebp - local_8]           # 004819e5
    add ecx, 0x8e1                               # 004819e8
    push ecx                                     # 004819ee
    mov ecx, 0x5c3a67                            # 004819ef
    call FUN_004fba69                            # 004819f4
    mov edx, dword ptr [ebp - local_f0]          # 004819f9
    movsx eax, word ptr [edx + field_1e]         # 004819ff
    imul eax, eax, 0x8d                          # 00481a03
    mov dword ptr [eax + 0x5bb632], 0x2          # 00481a09
L_00481a13:
    # block 0x00481a13: entered by ja at 0x004814b6; jmp at 0x004814f5; jmp at 0x0048151e; jmp at 0x0048155c; more, 1 instruction(s), ends with forward jump to 0x00481c85
    jmp.d32 L_00481c85                           # 00481a13
L_00481a18:
    # block 0x00481a18: entered by je at 0x00480e60, 8 instruction(s), ends with je to 0x00481a4e (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00481a18
    mov edi, 0x54d6b8                            # 00481a22
    mov esi, dword ptr [ebp - local_8]           # 00481a27
    add esi, 0x746                               # 00481a2a
    mov ecx, 0x9                                 # 00481a30
    {load} xor edx, edx                          # 00481a35
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481a37
    je.d8 L_00481a4e                             # 00481a39
    # block 0x00481a3b: entered by fall-through of je at 0x00481a39, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00481a4e
    mov eax, dword ptr [ebp - local_8]           # 00481a3b
    add eax, 0x746                               # 00481a3e
    push eax                                     # 00481a43
    mov ecx, 0x5c3a67                            # 00481a44
    call FUN_004fba69                            # 00481a49
L_00481a4e:
    # block 0x00481a4e: entered by je at 0x00481a39, 7 instruction(s), ends with je to 0x00481a7a (forward)
    mov edi, 0x54d6c4                            # 00481a4e
    mov esi, dword ptr [ebp - local_8]           # 00481a53
    add esi, 0x777                               # 00481a56
    mov ecx, 0x9                                 # 00481a5c
    {load} xor edx, edx                          # 00481a61
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481a63
    je.d8 L_00481a7a                             # 00481a65
    # block 0x00481a67: entered by fall-through of je at 0x00481a65, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00481a7a
    mov eax, dword ptr [ebp - local_8]           # 00481a67
    add eax, 0x777                               # 00481a6a
    push eax                                     # 00481a6f
    mov ecx, 0x5c3a67                            # 00481a70
    call FUN_004fba69                            # 00481a75
L_00481a7a:
    # block 0x00481a7a: entered by je at 0x00481a65, 7 instruction(s), ends with je to 0x00481aa6 (forward)
    mov edi, 0x54d6d0                            # 00481a7a
    mov esi, dword ptr [ebp - local_8]           # 00481a7f
    add esi, 0x7a8                               # 00481a82
    mov ecx, 0x9                                 # 00481a88
    {load} xor edx, edx                          # 00481a8d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481a8f
    je.d8 L_00481aa6                             # 00481a91
    # block 0x00481a93: entered by fall-through of je at 0x00481a91, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00481aa6
    mov eax, dword ptr [ebp - local_8]           # 00481a93
    add eax, 0x7a8                               # 00481a96
    push eax                                     # 00481a9b
    mov ecx, 0x5c3a67                            # 00481a9c
    call FUN_004fba69                            # 00481aa1
L_00481aa6:
    # block 0x00481aa6: entered by je at 0x00481a91, 7 instruction(s), ends with je to 0x00481ad2 (forward)
    mov edi, 0x54d6dc                            # 00481aa6
    mov esi, dword ptr [ebp - local_8]           # 00481aab
    add esi, 0x715                               # 00481aae
    mov ecx, 0x9                                 # 00481ab4
    {load} xor edx, edx                          # 00481ab9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00481abb
    je.d8 L_00481ad2                             # 00481abd
    # block 0x00481abf: entered by fall-through of je at 0x00481abd, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00481ad2
    mov eax, dword ptr [ebp - local_8]           # 00481abf
    add eax, 0x715                               # 00481ac2
    push eax                                     # 00481ac7
    mov ecx, 0x5c3a67                            # 00481ac8
    call FUN_004fba69                            # 00481acd
L_00481ad2:
    # block 0x00481ad2: entered by je at 0x00481abd, 5 instruction(s), ends with je to 0x00481b9f (forward)
    mov ecx, dword ptr [ebp - local_f0]          # 00481ad2
    {load} xor edx, edx                          # 00481ad8
    mov dl, byte ptr [ecx + field_13c9]          # 00481ada
    test edx, edx                                # 00481ae0
    je.d32 L_00481b9f                            # 00481ae2
    # block 0x00481ae8: entered by fall-through of je at 0x00481ae2, 4 instruction(s), ends with je to 0x00481b9a (forward)
    mov eax, dword ptr [ebp - local_8]           # 00481ae8
    movsx ecx, word ptr [eax + field_9fb]        # 00481aeb
    cmp ecx, 0x270f                              # 00481af2
    je.d32 L_00481b9a                            # 00481af8
    # block 0x00481afe: entered by fall-through of je at 0x00481af8, 25 instruction(s), ends with jne to 0x00481b86 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00481afe
    movsx eax, word ptr [edx + field_9fb]        # 00481b01
    mov dword ptr [0x5bb57b], eax                # 00481b08
    mov ecx, dword ptr [ebp - local_8]           # 00481b0d
    mov dx, word ptr [ecx + field_9fd]           # 00481b10
    mov word ptr [0x5bb599], dx                  # 00481b17
    mov eax, dword ptr [ebp - local_8]           # 00481b1e
    mov cx, word ptr [eax + field_9ff]           # 00481b21
    mov word ptr [0x5bb595], cx                  # 00481b28
    mov edx, dword ptr [ebp - local_8]           # 00481b2f
    mov ax, word ptr [edx + field_a01]           # 00481b32
    mov word ptr [0x5c39ff], ax                  # 00481b39
    mov ecx, dword ptr [ebp - local_8]           # 00481b3f
    mov edx, dword ptr [ecx + field_a03]         # 00481b42
    mov dword ptr [0x5bb59b], edx                # 00481b48
    mov eax, dword ptr [ebp - local_8]           # 00481b4e
    mov ecx, dword ptr [eax + field_a07]         # 00481b51
    mov dword ptr [0x5bb59f], ecx                # 00481b57
    mov edx, dword ptr [ebp - local_8]           # 00481b5d
    mov eax, dword ptr [edx + field_a0b]         # 00481b60
    mov dword ptr [0x5bb5a3], eax                # 00481b66
    mov ecx, dword ptr [ebp - local_8]           # 00481b6b
    movsx edx, word ptr [ecx + field_a0f]        # 00481b6e
    cmp edx, 0x1                                 # 00481b75
    jne.d8 L_00481b86                            # 00481b78
    # block 0x00481b7a: entered by fall-through of jne at 0x00481b78, 2 instruction(s), ends with forward jump to 0x00481b90
    mov dword ptr [0x5bb1ca], 0x0                # 00481b7a
    jmp.d8 L_00481b90                            # 00481b84
L_00481b86:
    # block 0x00481b86: entered by jne at 0x00481b78, 1 instruction(s), falls into the block at 0x00481b90
    mov dword ptr [0x5bb1ca], 0x1                # 00481b86
L_00481b90:
    # block 0x00481b90: entered by jmp at 0x00481b84, 1 instruction(s), falls into the block at 0x00481b9a
    mov dword ptr [0x583999], 0x4                # 00481b90
L_00481b9a:
    # block 0x00481b9a: entered by je at 0x00481af8, 1 instruction(s), ends with forward jump to 0x00481c67
    jmp.d32 L_00481c67                           # 00481b9a
L_00481b9f:
    # block 0x00481b9f: entered by je at 0x00481ae2, 5 instruction(s), ends with je to 0x00481c67 (forward)
    mov eax, dword ptr [ebp - local_f0]          # 00481b9f
    {load} xor ecx, ecx                          # 00481ba5
    mov cl, byte ptr [eax + field_13ce]          # 00481ba7
    test ecx, ecx                                # 00481bad
    je.d32 L_00481c67                            # 00481baf
    # block 0x00481bb5: entered by fall-through of je at 0x00481baf, 4 instruction(s), ends with je to 0x00481c67 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00481bb5
    movsx eax, word ptr [edx + field_8c8]        # 00481bb8
    cmp eax, 0x270f                              # 00481bbf
    je.d32 L_00481c67                            # 00481bc4
    # block 0x00481bca: entered by fall-through of je at 0x00481bc4, 25 instruction(s), ends with jne to 0x00481c53 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00481bca
    movsx edx, word ptr [ecx + field_8c8]        # 00481bcd
    mov dword ptr [0x5bb57b], edx                # 00481bd4
    mov eax, dword ptr [ebp - local_8]           # 00481bda
    mov cx, word ptr [eax + field_8ca]           # 00481bdd
    mov word ptr [0x5bb599], cx                  # 00481be4
    mov edx, dword ptr [ebp - local_8]           # 00481beb
    mov ax, word ptr [edx + field_8cc]           # 00481bee
    mov word ptr [0x5bb595], ax                  # 00481bf5
    mov ecx, dword ptr [ebp - local_8]           # 00481bfb
    mov dx, word ptr [ecx + field_8ce]           # 00481bfe
    mov word ptr [0x5c39ff], dx                  # 00481c05
    mov eax, dword ptr [ebp - local_8]           # 00481c0c
    mov ecx, dword ptr [eax + field_8d0]         # 00481c0f
    mov dword ptr [0x5bb59b], ecx                # 00481c15
    mov edx, dword ptr [ebp - local_8]           # 00481c1b
    mov eax, dword ptr [edx + field_8d4]         # 00481c1e
    mov dword ptr [0x5bb59f], eax                # 00481c24
    mov ecx, dword ptr [ebp - local_8]           # 00481c29
    mov edx, dword ptr [ecx + field_8d8]         # 00481c2c
    mov dword ptr [0x5bb5a3], edx                # 00481c32
    mov eax, dword ptr [ebp - local_8]           # 00481c38
    movsx ecx, word ptr [eax + field_8dc]        # 00481c3b
    cmp ecx, 0x1                                 # 00481c42
    jne.d8 L_00481c53                            # 00481c45
    # block 0x00481c47: entered by fall-through of jne at 0x00481c45, 2 instruction(s), ends with forward jump to 0x00481c5d
    mov dword ptr [0x5bb1ca], 0x0                # 00481c47
    jmp.d8 L_00481c5d                            # 00481c51
L_00481c53:
    # block 0x00481c53: entered by jne at 0x00481c45, 1 instruction(s), falls into the block at 0x00481c5d
    mov dword ptr [0x5bb1ca], 0x1                # 00481c53
L_00481c5d:
    # block 0x00481c5d: entered by jmp at 0x00481c51, 1 instruction(s), falls into the block at 0x00481c67
    mov dword ptr [0x583999], 0x4                # 00481c5d
L_00481c67:
    # block 0x00481c67: entered by jmp at 0x00481b9a; je at 0x00481baf; je at 0x00481bc4, 7 instruction(s), calls FUN_0042ba3a, FUN_0047e2a5, falls into the block at 0x00481c85
    mov edx, dword ptr [ebp - local_f0]          # 00481c67
    mov ax, word ptr [edx + field_1e]            # 00481c6d
    push eax                                     # 00481c71
    call FUN_0042ba3a                            # 00481c72
    add esp, 0x4                                 # 00481c77
    mov ecx, dword ptr [ebp - local_f0]          # 00481c7a
    call FUN_0047e2a5                            # 00481c80
L_00481c85:
    # block 0x00481c85: entered by jmp at 0x00480e66; jmp at 0x00481498; jmp at 0x00481a13, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00481c85
    pop esi                                      # 00481c86
    {load} mov esp, ebp                          # 00481c87
    pop ebp                                      # 00481c89
    ret 0x4                                      # 00481c8a

# --- data items (not part of the function) -------------------------
.org 0x00481c8d - 0x401000
SWTAB_00481c8d:  # 7 case address(es)
    .long L_004814c9 - .text + 0x401000
    .long L_004814fa - .text + 0x401000
    .long L_00481a13 - .text + 0x401000
    .long L_004819c0 - .text + 0x401000
    .long L_00481561 - .text + 0x401000
    .long L_00481523 - .text + 0x401000
    .long L_00481816 - .text + 0x401000
.set SWTAB_00481c8d_VA, SWTAB_00481c8d - .text + 0x401000

