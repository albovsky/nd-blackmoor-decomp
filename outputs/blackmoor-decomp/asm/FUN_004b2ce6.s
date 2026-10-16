# FUN_004b2ce6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b2ce6
# extent:       0x004b2ce6-0x004b3704 (2590 code bytes)
# span:         0x004b2ce6-0x004b371c (code 2590, tables 24, padding 0)
# sha256:       e51b694e2cb344a6aac6d2f93c6e884ff195357448f56a5e1a36f03354f50ff6
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b2ce6
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_1e, field_24, field_28, field_29, field_3b, field_121, field_1aa, field_1ac and 16 more; [ecx + n] field_1c, field_1e, field_20, field_24, field_3b, field_135, field_1aa, field_250, field_309, field_30f, field_31b, field_31d and 19 more; [edx + n] field_1c, field_24, field_129, field_12d, field_1aa, field_250, field_307, field_30d, field_317, field_31f, field_320, field_353 and 14 more
# callees:      calls FUN_004e8d96, FUN_004b0f9f, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004b2c32, FUN_004b05ae, FUN_004afec1, FUN_004fb2e3, FUN_004fba69, FUN_004b01e8, FUN_004f6334, FUN_00427a40, FUN_0042ba3a, FUN_004afd7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 590 instruction(s), 39 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_29, 0x29  # offset +0x29
.equ field_3b, 0x3b  # offset +0x3b
.equ field_121, 0x121  # offset +0x121
.equ field_129, 0x129  # offset +0x129
.equ field_12d, 0x12d  # offset +0x12d
.equ field_135, 0x135  # offset +0x135
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ac, 0x1ac  # offset +0x1ac
.equ field_250, 0x250  # offset +0x250
.equ field_2c6, 0x2c6  # offset +0x2c6
.equ field_307, 0x307  # offset +0x307
.equ field_309, 0x309  # offset +0x309
.equ field_30b, 0x30b  # offset +0x30b
.equ field_30d, 0x30d  # offset +0x30d
.equ field_30f, 0x30f  # offset +0x30f
.equ field_313, 0x313  # offset +0x313
.equ field_317, 0x317  # offset +0x317
.equ field_31b, 0x31b  # offset +0x31b
.equ field_31d, 0x31d  # offset +0x31d
.equ field_31f, 0x31f  # offset +0x31f
.equ field_320, 0x320  # offset +0x320
.equ field_343, 0x343  # offset +0x343
.equ field_353, 0x353  # offset +0x353
.equ field_355, 0x355  # offset +0x355
.equ field_357, 0x357  # offset +0x357
.equ field_359, 0x359  # offset +0x359
.equ field_35b, 0x35b  # offset +0x35b
.equ field_35f, 0x35f  # offset +0x35f
.equ field_363, 0x363  # offset +0x363
.equ field_367, 0x367  # offset +0x367
.equ field_369, 0x369  # offset +0x369
.equ field_36b, 0x36b  # offset +0x36b
.equ field_150f, 0x150f  # offset +0x150f
.equ field_1510, 0x1510  # offset +0x1510
.equ field_1511, 0x1511  # offset +0x1511
.equ field_1513, 0x1513  # offset +0x1513
.equ field_1514, 0x1514  # offset +0x1514
.equ field_1515, 0x1515  # offset +0x1515
.equ field_1519, 0x1519  # offset +0x1519
.equ field_151d, 0x151d  # offset +0x151d
.equ field_1521, 0x1521  # offset +0x1521
.equ field_1525, 0x1525  # offset +0x1525
.equ field_1529, 0x1529  # offset +0x1529
.equ field_152d, 0x152d  # offset +0x152d
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1533, 0x1533  # offset +0x1533
.equ field_1535, 0x1535  # offset +0x1535
.equ field_1537, 0x1537  # offset +0x1537
.equ field_153b, 0x153b  # offset +0x153b
.equ field_153f, 0x153f  # offset +0x153f

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004afd7e, .text + (0x004afd7e - 0x401000)
.set FUN_004afec1, .text + (0x004afec1 - 0x401000)
.set FUN_004b01e8, .text + (0x004b01e8 - 0x401000)
.set FUN_004b05ae, .text + (0x004b05ae - 0x401000)
.set FUN_004b0f9f, .text + (0x004b0f9f - 0x401000)
.set FUN_004b2c32, .text + (0x004b2c32 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004b2ce6 - 0x401000
.globl FUN_004b2ce6
FUN_004b2ce6:
    # block 0x004b2ce6: entry, 16 instruction(s), ends with je to 0x004b2d36 (forward)
    push ebp                                     # 004b2ce6
    {load} mov ebp, esp                          # 004b2ce7
    sub esp, 0x18                                # 004b2ce9
    push esi                                     # 004b2cec
    push edi                                     # 004b2ced
    mov dword ptr [ebp - local_c], ecx           # 004b2cee
    movsx eax, word ptr [ebp + arg_8]            # 004b2cf1
    imul eax, eax, 0x8d                          # 004b2cf5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b2cfb
    mov dword ptr [ebp - local_4], ecx           # 004b2d01
    movsx edx, word ptr [ebp + arg_8]            # 004b2d04
    imul edx, edx, 0x8d                          # 004b2d08
    mov eax, dword ptr [edx + 0x5bb632]          # 004b2d0e
    mov dword ptr [ebp - local_10], eax          # 004b2d14
    cmp dword ptr [ebp - local_10], 0x0          # 004b2d17
    je.d8 L_004b2d36                             # 004b2d1b
    # block 0x004b2d1d: entered by fall-through of je at 0x004b2d1b, 2 instruction(s), ends with je to 0x004b304d (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004b2d1d
    je.d32 L_004b304d                            # 004b2d21
    # block 0x004b2d27: entered by fall-through of je at 0x004b2d21, 2 instruction(s), ends with je to 0x004b34a3 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004b2d27
    je.d32 L_004b34a3                            # 004b2d2b
    # block 0x004b2d31: entered by fall-through of je at 0x004b2d2b, 1 instruction(s), ends with forward jump to 0x004b36fc
    jmp.d32 L_004b36fc                           # 004b2d31
L_004b2d36:
    # block 0x004b2d36: entered by je at 0x004b2d1b, 85 instruction(s), calls FUN_004e8d96, FUN_004b0f9f, FUN_004d39f9, ends with jne to 0x004b2ec3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b2d36
    mov dx, word ptr [ebp + arg_8]               # 004b2d39
    mov word ptr [ecx + field_1e], dx            # 004b2d3d
    mov eax, dword ptr [ebp - local_c]           # 004b2d41
    mov dword ptr [eax + field_1515], 0x1        # 004b2d44
    mov dword ptr [0x5bb1ca], 0x1                # 004b2d4e
    mov ecx, 0x571442                            # 004b2d58
    call FUN_004e8d96                            # 004b2d5d
    mov ecx, dword ptr [ebp - local_4]           # 004b2d62
    mov edx, dword ptr [ebp - local_4]           # 004b2d65
    mov eax, dword ptr [ecx + field_135]         # 004b2d68
    sub eax, dword ptr [edx + field_12d]         # 004b2d6e
    mov ecx, dword ptr [ebp - local_c]           # 004b2d74
    mov dword ptr [ecx + field_1529], eax        # 004b2d77
    mov edx, dword ptr [ebp - local_4]           # 004b2d7d
    mov eax, dword ptr [ebp - local_4]           # 004b2d80
    mov ecx, dword ptr [edx + field_129]         # 004b2d83
    sub ecx, dword ptr [eax + field_121]         # 004b2d89
    mov edx, dword ptr [ebp - local_c]           # 004b2d8f
    mov dword ptr [edx + field_152d], ecx        # 004b2d92
    mov ecx, dword ptr [ebp - local_c]           # 004b2d98
    call FUN_004b0f9f                            # 004b2d9b
    mov eax, dword ptr [ebp - local_c]           # 004b2da0
    mov byte ptr [eax + field_28], 0x1           # 004b2da3
    mov ecx, dword ptr [ebp - local_c]           # 004b2da7
    mov byte ptr [ecx + field_150f], 0x0         # 004b2daa
    mov edx, dword ptr [ebp - local_c]           # 004b2db1
    mov byte ptr [edx + field_1510], 0x0         # 004b2db4
    call FUN_004d39f9                            # 004b2dbb
    mov ecx, dword ptr [ebp - local_c]           # 004b2dc0
    mov word ptr [ecx + field_1c], ax            # 004b2dc3
    mov edx, dword ptr [ebp - local_c]           # 004b2dc7
    movsx eax, word ptr [edx + field_1c]         # 004b2dca
    imul eax, eax, 0x4a                          # 004b2dce
    mov dword ptr [eax + 0x5d1591], 0xa          # 004b2dd1
    mov ecx, dword ptr [ebp - local_c]           # 004b2ddb
    movsx edx, word ptr [ecx + field_1c]         # 004b2dde
    imul edx, edx, 0x4a                          # 004b2de2
    mov dword ptr [edx + 0x5d1595], 0x4b372c     # 004b2de5
    mov eax, dword ptr [ebp - local_c]           # 004b2def
    movsx ecx, word ptr [eax + field_1c]         # 004b2df2
    imul ecx, ecx, 0x4a                          # 004b2df6
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004b2df9
    mov edx, dword ptr [ebp - local_c]           # 004b2e03
    movsx eax, word ptr [edx + field_1c]         # 004b2e06
    imul eax, eax, 0x4a                          # 004b2e0a
    mov dword ptr [eax + 0x5d159d], 0x0          # 004b2e0d
    mov ecx, dword ptr [ebp - local_c]           # 004b2e17
    movsx edx, word ptr [ecx + field_1c]         # 004b2e1a
    imul edx, edx, 0x4a                          # 004b2e1e
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004b2e21
    mov eax, dword ptr [ebp - local_c]           # 004b2e2b
    movsx ecx, word ptr [eax + field_1c]         # 004b2e2e
    imul ecx, ecx, 0x4a                          # 004b2e32
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004b2e35
    mov edx, dword ptr [ebp - local_c]           # 004b2e3f
    movsx eax, word ptr [edx + field_1c]         # 004b2e42
    imul eax, eax, 0x4a                          # 004b2e46
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004b2e49
    mov ecx, dword ptr [ebp - local_c]           # 004b2e53
    movsx edx, word ptr [ecx + field_1c]         # 004b2e56
    imul edx, edx, 0x4a                          # 004b2e5a
    mov word ptr [edx + 0x5d15ad], 0x0           # 004b2e5d
    mov edi, 0x55177c                            # 004b2e66
    mov eax, dword ptr [ebp - local_c]           # 004b2e6b
    movsx ecx, word ptr [eax + field_1c]         # 004b2e6e
    imul ecx, ecx, 0x4a                          # 004b2e72
    add ecx, 0x5d15b3                            # 004b2e75
    {load} mov edx, ecx                          # 004b2e7b
    or ecx, -0x1                                 # 004b2e7d
    {load} xor eax, eax                          # 004b2e80
    repne scasb al, byte ptr es:[edi]            # 004b2e82
    not ecx                                      # 004b2e84
    {load} sub edi, ecx                          # 004b2e86
    {load} mov esi, edi                          # 004b2e88
    {load} mov eax, ecx                          # 004b2e8a
    {load} mov edi, edx                          # 004b2e8c
    shr ecx, 0x2                                 # 004b2e8e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b2e91
    {load} mov ecx, eax                          # 004b2e93
    and ecx, 0x3                                 # 004b2e95
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004b2e98
    mov ecx, dword ptr [ebp - local_c]           # 004b2e9a
    cmp dword ptr [ecx + field_20], 0x0          # 004b2e9d
    jne.d8 L_004b2ec3                            # 004b2ea1
    # block 0x004b2ea3: entered by fall-through of jne at 0x004b2ea1, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004b2ec3
    push 0x551798                                # 004b2ea3
    push 0x6                                     # 004b2ea8
    mov edx, dword ptr [ebp - local_4]           # 004b2eaa
    push edx                                     # 004b2ead
    push 0x5517b0                                # 004b2eae
    mov ecx, 0x5cf659                            # 004b2eb3
    call FUN_004c2790                            # 004b2eb8
    mov ecx, dword ptr [ebp - local_c]           # 004b2ebd
    mov dword ptr [ecx + field_20], eax          # 004b2ec0
L_004b2ec3:
    # block 0x004b2ec3: entered by jne at 0x004b2ea1, 13 instruction(s), ends with je to 0x004b2f06 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b2ec3
    movsx eax, word ptr [edx + field_1c]         # 004b2ec6
    imul eax, eax, 0x4a                          # 004b2eca
    mov ecx, dword ptr [ebp - local_c]           # 004b2ecd
    mov edx, dword ptr [ecx + field_20]          # 004b2ed0
    mov dword ptr [eax + 0x5d1599], edx          # 004b2ed3
    mov edi, 0x5517b8                            # 004b2ed9
    mov esi, dword ptr [ebp - local_4]           # 004b2ede
    add esi, 0x274                               # 004b2ee1
    mov ecx, 0x9                                 # 004b2ee7
    {load} xor eax, eax                          # 004b2eec
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b2eee
    je.d8 L_004b2f06                             # 004b2ef0
    # block 0x004b2ef2: entered by fall-through of je at 0x004b2ef0, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b2f06
    mov ecx, dword ptr [ebp - local_4]           # 004b2ef2
    add ecx, 0x274                               # 004b2ef5
    push ecx                                     # 004b2efb
    mov ecx, 0x5c3a67                            # 004b2efc
    call FUN_004fb77a                            # 004b2f01
L_004b2f06:
    # block 0x004b2f06: entered by je at 0x004b2ef0, 7 instruction(s), ends with je to 0x004b2f32 (forward)
    mov edi, 0x5517c4                            # 004b2f06
    mov esi, dword ptr [ebp - local_4]           # 004b2f0b
    add esi, 0x2a5                               # 004b2f0e
    mov ecx, 0x9                                 # 004b2f14
    {load} xor edx, edx                          # 004b2f19
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b2f1b
    je.d8 L_004b2f32                             # 004b2f1d
    # block 0x004b2f1f: entered by fall-through of je at 0x004b2f1d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b2f32
    mov eax, dword ptr [ebp - local_4]           # 004b2f1f
    add eax, 0x2a5                               # 004b2f22
    push eax                                     # 004b2f27
    mov ecx, 0x5c3a67                            # 004b2f28
    call FUN_004fb77a                            # 004b2f2d
L_004b2f32:
    # block 0x004b2f32: entered by je at 0x004b2f1d, 25 instruction(s), ends with je to 0x004b2fd5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b2f32
    mov dword ptr [ecx + field_151d], 0x0        # 004b2f35
    mov edx, dword ptr [ebp - local_c]           # 004b2f3f
    mov dword ptr [edx + field_1519], 0x0        # 004b2f42
    mov eax, dword ptr [ebp - local_c]           # 004b2f4c
    mov dword ptr [eax + field_24], 0x0          # 004b2f4f
    mov dword ptr [0x63a8c8], 0x0                # 004b2f56
    mov ecx, dword ptr [ebp - local_c]           # 004b2f60
    movsx edx, word ptr [ecx + field_1e]         # 004b2f63
    imul edx, edx, 0x8d                          # 004b2f67
    mov dword ptr [edx + 0x5bb632], 0x1          # 004b2f6d
    mov eax, dword ptr [ebp - local_c]           # 004b2f77
    mov word ptr [eax + field_1531], 0x0         # 004b2f7a
    mov ecx, dword ptr [ebp - local_c]           # 004b2f83
    mov word ptr [ecx + field_1535], 0x0         # 004b2f86
    mov edx, dword ptr [ebp - local_c]           # 004b2f8f
    mov word ptr [edx + field_1533], 0x0         # 004b2f92
    mov eax, dword ptr [ebp - local_c]           # 004b2f9b
    mov dword ptr [eax + field_3b], 0x0          # 004b2f9e
    mov ecx, dword ptr [ebp - local_c]           # 004b2fa5
    mov word ptr [ecx + field_1511], 0x0         # 004b2fa8
    mov edx, dword ptr [ebp - local_4]           # 004b2fb1
    movsx eax, word ptr [edx + field_250]        # 004b2fb4
    cmp eax, -0x1                                # 004b2fbb
    je.d8 L_004b2fd5                             # 004b2fbe
    # block 0x004b2fc0: entered by fall-through of je at 0x004b2fbe, 3 instruction(s), falls into the block at 0x004b2fd5
    mov ecx, dword ptr [ebp - local_4]           # 004b2fc0
    movsx edx, word ptr [ecx + field_250]        # 004b2fc3
    mov dword ptr [4*edx + 0x585801], 0x1        # 004b2fca
L_004b2fd5:
    # block 0x004b2fd5: entered by je at 0x004b2fbe, 4 instruction(s), ends with jle to 0x004b302b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b2fd5
    movsx ecx, word ptr [eax + field_1aa]        # 004b2fd8
    test ecx, ecx                                # 004b2fdf
    jle.d8 L_004b302b                            # 004b2fe1
    # block 0x004b2fe3: entered by fall-through of jle at 0x004b2fe1, 17 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b3035
    mov edx, dword ptr [ebp - local_c]           # 004b2fe3
    mov byte ptr [edx + field_1514], 0x1         # 004b2fe6
    call dword ptr [0x52a23c]                    # 004b2fed
    {load} mov ecx, eax                          # 004b2ff3
    mov edx, dword ptr [ebp - local_4]           # 004b2ff5
    movsx esi, word ptr [edx + field_1aa]        # 004b2ff8
    mov eax, dword ptr [ebp - local_4]           # 004b2fff
    mov eax, dword ptr [eax + field_1ac]         # 004b3002
    {load} xor edx, edx                          # 004b3008
    div esi                                      # 004b300a
    imul eax, eax, 0x3e8                         # 004b300c
    {load} add ecx, eax                          # 004b3012
    mov edx, dword ptr [ebp - local_c]           # 004b3014
    mov dword ptr [edx + field_153b], ecx        # 004b3017
    mov eax, dword ptr [ebp - local_c]           # 004b301d
    mov word ptr [eax + field_153f], 0x0         # 004b3020
    jmp.d8 L_004b3035                            # 004b3029
L_004b302b:
    # block 0x004b302b: entered by jle at 0x004b2fe1, 2 instruction(s), falls into the block at 0x004b3035
    mov ecx, dword ptr [ebp - local_c]           # 004b302b
    mov byte ptr [ecx + field_1514], 0x0         # 004b302e
L_004b3035:
    # block 0x004b3035: entered by jmp at 0x004b3029, 8 instruction(s), ends with forward jump to 0x004b36fc
    {load} xor edx, edx                          # 004b3035
    mov eax, dword ptr [ebp - local_c]           # 004b3037
    add eax, 0x29                                # 004b303a
    mov dword ptr [eax], edx                     # 004b303d
    mov dword ptr [eax + field_4], edx           # 004b303f
    mov dword ptr [eax + field_8], edx           # 004b3042
    mov dword ptr [eax + field_c], edx           # 004b3045
    jmp.d32 L_004b36fc                           # 004b3048
L_004b304d:
    # block 0x004b304d: entered by je at 0x004b2d21, 5 instruction(s), ends with ja to 0x004b3454 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b304d
    mov edx, dword ptr [ecx + field_24]          # 004b3050
    mov dword ptr [ebp - local_14], edx          # 004b3053
    cmp dword ptr [ebp - local_14], 0x5          # 004b3056
    ja.d32 L_004b3454                            # 004b305a
    # block 0x004b3060: entered by fall-through of ja at 0x004b305a, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4b3704]
    mov eax, dword ptr [ebp - local_14]          # 004b3060
    jmp dword ptr [4*eax + SWTAB_004b3704_VA]    # 004b3063
L_004b306a:
    # block 0x004b306a: entered by switch case, 6 instruction(s), ends with jle to 0x004b324a (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b306a
    mov dword ptr [ecx + field_3b], 0x0          # 004b306d
    mov edx, dword ptr [ebp - local_4]           # 004b3074
    movsx eax, word ptr [edx + field_1aa]        # 004b3077
    test eax, eax                                # 004b307e
    jle.d32 L_004b324a                           # 004b3080
    # block 0x004b3086: entered by fall-through of jle at 0x004b3080, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b31b5 (forward)
    call dword ptr [0x52a23c]                    # 004b3086
    mov ecx, dword ptr [ebp - local_c]           # 004b308c
    cmp eax, dword ptr [ecx + field_153b]        # 004b308f
    jb.d32 L_004b31b5                            # 004b3095
    # block 0x004b309b: entered by fall-through of jb at 0x004b3095, 7 instruction(s), ends with jge to 0x004b318c (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b309b
    movsx eax, word ptr [edx + field_1511]       # 004b309e
    mov ecx, dword ptr [ebp - local_4]           # 004b30a5
    movsx edx, word ptr [ecx + field_1aa]        # 004b30a8
    sub edx, 0x1                                 # 004b30af
    {load} cmp eax, edx                          # 004b30b2
    jge.d32 L_004b318c                           # 004b30b4
    # block 0x004b30ba: entered by fall-through of jge at 0x004b30b4, 6 instruction(s), ends with je to 0x004b30f4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b30ba
    movsx ecx, word ptr [eax + field_1511]       # 004b30bd
    mov edx, dword ptr [ebp - local_4]           # 004b30c4
    movsx eax, word ptr [edx + 2*ecx + field_250] # 004b30c7
    cmp eax, -0x1                                # 004b30cf
    je.d8 L_004b30f4                             # 004b30d2
    # block 0x004b30d4: entered by fall-through of je at 0x004b30d2, 5 instruction(s), falls into the block at 0x004b30f4
    mov ecx, dword ptr [ebp - local_c]           # 004b30d4
    movsx edx, word ptr [ecx + field_1511]       # 004b30d7
    mov eax, dword ptr [ebp - local_4]           # 004b30de
    movsx ecx, word ptr [eax + 2*edx + field_250] # 004b30e1
    mov dword ptr [4*ecx + 0x585801], 0x0        # 004b30e9
L_004b30f4:
    # block 0x004b30f4: entered by je at 0x004b30d2, 11 instruction(s), ends with je to 0x004b3146 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b30f4
    mov ax, word ptr [edx + field_1511]          # 004b30f7
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b30fe
    mov ecx, dword ptr [ebp - local_c]           # 004b3102
    mov word ptr [ecx + field_1511], ax          # 004b3105
    mov edx, dword ptr [ebp - local_c]           # 004b310c
    movsx eax, word ptr [edx + field_1511]       # 004b310f
    mov ecx, dword ptr [ebp - local_4]           # 004b3116
    movsx edx, word ptr [ecx + 2*eax + field_250] # 004b3119
    cmp edx, -0x1                                # 004b3121
    je.d8 L_004b3146                             # 004b3124
    # block 0x004b3126: entered by fall-through of je at 0x004b3124, 5 instruction(s), falls into the block at 0x004b3146
    mov eax, dword ptr [ebp - local_c]           # 004b3126
    movsx ecx, word ptr [eax + field_1511]       # 004b3129
    mov edx, dword ptr [ebp - local_4]           # 004b3130
    movsx eax, word ptr [edx + 2*ecx + field_250] # 004b3133
    mov dword ptr [4*eax + 0x585801], 0x1        # 004b313b
L_004b3146:
    # block 0x004b3146: entered by je at 0x004b3124, 17 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b31b0
    call dword ptr [0x52a23c]                    # 004b3146
    {load} mov ecx, eax                          # 004b314c
    mov edx, dword ptr [ebp - local_4]           # 004b314e
    movsx esi, word ptr [edx + field_1aa]        # 004b3151
    mov eax, dword ptr [ebp - local_4]           # 004b3158
    mov eax, dword ptr [eax + field_1ac]         # 004b315b
    {load} xor edx, edx                          # 004b3161
    div esi                                      # 004b3163
    imul eax, eax, 0x3e8                         # 004b3165
    {load} add ecx, eax                          # 004b316b
    mov edx, dword ptr [ebp - local_c]           # 004b316d
    mov dword ptr [edx + field_153b], ecx        # 004b3170
    call dword ptr [0x52a23c]                    # 004b3176
    add eax, 0x3e8                               # 004b317c
    mov ecx, dword ptr [ebp - local_c]           # 004b3181
    mov dword ptr [ecx + field_1525], eax        # 004b3184
    jmp.d8 L_004b31b0                            # 004b318a
L_004b318c:
    # block 0x004b318c: entered by jge at 0x004b30b4, 6 instruction(s), falls into the block at 0x004b31b0
    mov edx, dword ptr [ebp - local_c]           # 004b318c
    mov dword ptr [edx + field_1519], 0x1        # 004b318f
    mov eax, dword ptr [ebp - local_c]           # 004b3199
    movsx ecx, word ptr [eax + field_1e]         # 004b319c
    imul ecx, ecx, 0x8d                          # 004b31a0
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004b31a6
L_004b31b0:
    # block 0x004b31b0: entered by jmp at 0x004b318a, 1 instruction(s), ends with forward jump to 0x004b324a
    jmp.d32 L_004b324a                           # 004b31b0
L_004b31b5:
    # block 0x004b31b5: entered by jb at 0x004b3095, 7 instruction(s), ends with jne to 0x004b324a (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b31b5
    movsx eax, word ptr [edx + field_1511]       # 004b31b8
    mov ecx, dword ptr [ebp - local_4]           # 004b31bf
    movsx edx, word ptr [ecx + field_1aa]        # 004b31c2
    sub edx, 0x1                                 # 004b31c9
    {load} cmp eax, edx                          # 004b31cc
    jne.d8 L_004b324a                            # 004b31ce
    # block 0x004b31d0: entered by fall-through of jne at 0x004b31ce, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b3217 (forward)
    call dword ptr [0x52a23c]                    # 004b31d0
    mov ecx, dword ptr [ebp - local_c]           # 004b31d6
    cmp eax, dword ptr [ecx + field_1525]        # 004b31d9
    jb.d8 L_004b3217                             # 004b31df
    # block 0x004b31e1: entered by fall-through of jb at 0x004b31df, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b324a
    mov edx, dword ptr [ebp - local_c]           # 004b31e1
    mov byte ptr [edx + field_1513], 0x1         # 004b31e4
    call dword ptr [0x52a23c]                    # 004b31eb
    add eax, 0x3e8                               # 004b31f1
    mov ecx, dword ptr [ebp - local_c]           # 004b31f6
    mov dword ptr [ecx + field_1525], eax        # 004b31f9
    mov edx, dword ptr [ebp - local_c]           # 004b31ff
    mov word ptr [edx + field_153f], 0x0         # 004b3202
    mov eax, dword ptr [ebp - local_c]           # 004b320b
    mov byte ptr [eax + field_1514], 0x0         # 004b320e
    jmp.d8 L_004b324a                            # 004b3215
L_004b3217:
    # block 0x004b3217: entered by jb at 0x004b31df, 4 instruction(s), ends with jne to 0x004b3232 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b3217
    movsx edx, word ptr [ecx + field_153f]       # 004b321a
    cmp edx, 0xf                                 # 004b3221
    jne.d8 L_004b3232                            # 004b3224
    # block 0x004b3226: entered by fall-through of jne at 0x004b3224, 3 instruction(s), ends with forward jump to 0x004b324a
    mov eax, dword ptr [ebp - local_c]           # 004b3226
    mov byte ptr [eax + field_1514], 0x1         # 004b3229
    jmp.d8 L_004b324a                            # 004b3230
L_004b3232:
    # block 0x004b3232: entered by jne at 0x004b3224, 5 instruction(s), falls into the block at 0x004b324a
    mov ecx, dword ptr [ebp - local_c]           # 004b3232
    mov dx, word ptr [ecx + field_153f]          # 004b3235
    add dx, 0x1                                  # 004b323c
    mov eax, dword ptr [ebp - local_c]           # 004b3240
    mov word ptr [eax + field_153f], dx          # 004b3243
L_004b324a:
    # block 0x004b324a: entered by jle at 0x004b3080; jmp at 0x004b31b0; jne at 0x004b31ce; jmp at 0x004b3215; more, 4 instruction(s), calls FUN_004b2c32, ends with je to 0x004b326c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b324a
    call FUN_004b2c32                            # 004b324d
    test eax, eax                                # 004b3252
    je.d8 L_004b326c                             # 004b3254
    # block 0x004b3256: entered by fall-through of je at 0x004b3254, 4 instruction(s), falls into the block at 0x004b326c
    mov ecx, dword ptr [ebp - local_c]           # 004b3256
    mov word ptr [ecx + field_1533], 0x0         # 004b3259
    mov edx, dword ptr [ebp - local_c]           # 004b3262
    mov dword ptr [edx + field_24], 0x1          # 004b3265
L_004b326c:
    # block 0x004b326c: entered by je at 0x004b3254, 1 instruction(s), ends with forward jump to 0x004b3454
    jmp.d32 L_004b3454                           # 004b326c
L_004b3271:
    # block 0x004b3271: entered by switch case, 4 instruction(s), calls FUN_004b05ae, ends with je to 0x004b32cc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b3271
    call FUN_004b05ae                            # 004b3274
    test eax, eax                                # 004b3279
    je.d8 L_004b32cc                             # 004b327b
    # block 0x004b327d: entered by fall-through of je at 0x004b327b, 7 instruction(s), calls FUN_004afec1, ends with jne to 0x004b32cc (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b327d
    mov cx, word ptr [eax + field_1531]          # 004b3280
    push ecx                                     # 004b3287
    mov ecx, dword ptr [ebp - local_c]           # 004b3288
    call FUN_004afec1                            # 004b328b
    test eax, eax                                # 004b3290
    jne.d8 L_004b32cc                            # 004b3292
    # block 0x004b3294: entered by fall-through of jne at 0x004b3292, 7 instruction(s), ends with je to 0x004b32c2 (forward)
    mov edi, 0x5517d0                            # 004b3294
    mov esi, dword ptr [ebp - local_4]           # 004b3299
    add esi, 0x2a5                               # 004b329c
    mov ecx, 0x9                                 # 004b32a2
    {load} xor edx, edx                          # 004b32a7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b32a9
    je.d8 L_004b32c2                             # 004b32ab
    # block 0x004b32ad: entered by fall-through of je at 0x004b32ab, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b32c2
    mov eax, dword ptr [ebp - local_4]           # 004b32ad
    mov cx, word ptr [eax + field_2c6]           # 004b32b0
    push ecx                                     # 004b32b7
    mov ecx, 0x5c3a67                            # 004b32b8
    call FUN_004fb2e3                            # 004b32bd
L_004b32c2:
    # block 0x004b32c2: entered by je at 0x004b32ab, 2 instruction(s), falls into the block at 0x004b32cc
    mov edx, dword ptr [ebp - local_c]           # 004b32c2
    mov dword ptr [edx + field_24], 0x0          # 004b32c5
L_004b32cc:
    # block 0x004b32cc: entered by je at 0x004b327b; jne at 0x004b3292, 1 instruction(s), ends with forward jump to 0x004b3454
    jmp.d32 L_004b3454                           # 004b32cc
L_004b32d1:
    # block 0x004b32d1: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b331a (forward)
    call dword ptr [0x52a23c]                    # 004b32d1
    mov ecx, dword ptr [ebp - local_c]           # 004b32d7
    cmp eax, dword ptr [ecx + field_1537]        # 004b32da
    jb.d8 L_004b331a                             # 004b32e0
    # block 0x004b32e2: entered by fall-through of jb at 0x004b32e0, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x004b331a
    mov edx, dword ptr [ebp - local_c]           # 004b32e2
    mov dword ptr [edx + field_1519], 0x1        # 004b32e5
    mov eax, dword ptr [ebp - local_c]           # 004b32ef
    movsx ecx, word ptr [eax + field_1e]         # 004b32f2
    imul ecx, ecx, 0x8d                          # 004b32f6
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004b32fc
    mov edx, dword ptr [ebp - local_4]           # 004b3306
    add edx, 0x2d6                               # 004b3309
    push edx                                     # 004b330f
    mov ecx, 0x5c3a67                            # 004b3310
    call FUN_004fba69                            # 004b3315
L_004b331a:
    # block 0x004b331a: entered by jb at 0x004b32e0, 1 instruction(s), ends with forward jump to 0x004b3454
    jmp.d32 L_004b3454                           # 004b331a
L_004b331f:
    # block 0x004b331f: entered by switch case, 4 instruction(s), ends with je to 0x004b3364 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b331f
    movsx ecx, word ptr [eax + field_29]         # 004b3322
    cmp ecx, 0x14                                # 004b3326
    je.d8 L_004b3364                             # 004b3329
    # block 0x004b332b: entered by fall-through of je at 0x004b3329, 4 instruction(s), calls FUN_004b01e8, ends with je to 0x004b3362 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b332b
    call FUN_004b01e8                            # 004b332e
    test eax, eax                                # 004b3333
    je.d8 L_004b3362                             # 004b3335
    # block 0x004b3337: entered by fall-through of je at 0x004b3335, 9 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004b3362
    call dword ptr [0x52a23c]                    # 004b3337
    mov edx, dword ptr [ebp - local_4]           # 004b333d
    movsx ecx, word ptr [edx + field_320]        # 004b3340
    imul ecx, ecx, 0x3e8                         # 004b3347
    {load} add eax, ecx                          # 004b334d
    mov edx, dword ptr [ebp - local_c]           # 004b334f
    mov dword ptr [edx + field_1521], eax        # 004b3352
    mov eax, dword ptr [ebp - local_c]           # 004b3358
    mov dword ptr [eax + field_24], 0x5          # 004b335b
L_004b3362:
    # block 0x004b3362: entered by je at 0x004b3335, 1 instruction(s), ends with forward jump to 0x004b338f
    jmp.d8 L_004b338f                            # 004b3362
L_004b3364:
    # block 0x004b3364: entered by je at 0x004b3329, 9 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004b338f
    call dword ptr [0x52a23c]                    # 004b3364
    mov ecx, dword ptr [ebp - local_4]           # 004b336a
    movsx edx, word ptr [ecx + field_320]        # 004b336d
    imul edx, edx, 0x3e8                         # 004b3374
    {load} add eax, edx                          # 004b337a
    mov ecx, dword ptr [ebp - local_c]           # 004b337c
    mov dword ptr [ecx + field_1521], eax        # 004b337f
    mov edx, dword ptr [ebp - local_c]           # 004b3385
    mov dword ptr [edx + field_24], 0x5          # 004b3388
L_004b338f:
    # block 0x004b338f: entered by jmp at 0x004b3362, 1 instruction(s), ends with forward jump to 0x004b3454
    jmp.d32 L_004b3454                           # 004b338f
L_004b3394:
    # block 0x004b3394: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b3409 (forward)
    call dword ptr [0x52a23c]                    # 004b3394
    mov ecx, dword ptr [ebp - local_c]           # 004b339a
    cmp eax, dword ptr [ecx + field_1521]        # 004b339d
    jb.d8 L_004b3409                             # 004b33a3
    # block 0x004b33a5: entered by fall-through of jb at 0x004b33a3, 7 instruction(s), ends with je to 0x004b33f2 (forward)
    mov edi, 0x5517dc                            # 004b33a5
    mov esi, dword ptr [ebp - local_4]           # 004b33aa
    add esi, 0x322                               # 004b33ad
    mov ecx, 0x9                                 # 004b33b3
    {load} xor edx, edx                          # 004b33b8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b33ba
    je.d8 L_004b33f2                             # 004b33bc
    # block 0x004b33be: entered by fall-through of je at 0x004b33bc, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004b3409
    mov eax, dword ptr [ebp - local_4]           # 004b33be
    add eax, 0x322                               # 004b33c1
    push eax                                     # 004b33c6
    mov ecx, 0x5c3a67                            # 004b33c7
    call FUN_004fb77a                            # 004b33cc
    mov ecx, dword ptr [ebp - local_4]           # 004b33d1
    mov dx, word ptr [ecx + field_343]           # 004b33d4
    push edx                                     # 004b33db
    mov ecx, 0x5c3a67                            # 004b33dc
    call FUN_004fb2e3                            # 004b33e1
    mov eax, dword ptr [ebp - local_c]           # 004b33e6
    mov dword ptr [eax + field_24], 0x4          # 004b33e9
    jmp.d8 L_004b3409                            # 004b33f0
L_004b33f2:
    # block 0x004b33f2: entered by je at 0x004b33bc, 4 instruction(s), falls into the block at 0x004b3409
    mov ecx, dword ptr [ebp - local_c]           # 004b33f2
    movsx edx, word ptr [ecx + field_1e]         # 004b33f5
    imul edx, edx, 0x8d                          # 004b33f9
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b33ff
L_004b3409:
    # block 0x004b3409: entered by jb at 0x004b33a3; jmp at 0x004b33f0, 1 instruction(s), ends with forward jump to 0x004b3454
    jmp.d8 L_004b3454                            # 004b3409
L_004b340b:
    # block 0x004b340b: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b3454 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b340b
    movsx ecx, word ptr [eax + field_343]        # 004b340e
    mov dword ptr [ebp - local_8], ecx           # 004b3415
    mov edx, dword ptr [ebp - local_8]           # 004b3418
    push edx                                     # 004b341b
    mov ecx, 0x5cf1eb                            # 004b341c
    call FUN_004f6334                            # 004b3421
    test eax, eax                                # 004b3426
    jne.d8 L_004b3454                            # 004b3428
    # block 0x004b342a: entered by fall-through of jne at 0x004b3428, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004b3454
    mov eax, dword ptr [ebp - local_4]           # 004b342a
    add eax, 0x322                               # 004b342d
    push eax                                     # 004b3432
    mov ecx, 0x5c3a67                            # 004b3433
    call FUN_004fba69                            # 004b3438
    mov ecx, dword ptr [ebp - local_c]           # 004b343d
    movsx edx, word ptr [ecx + field_1e]         # 004b3440
    imul edx, edx, 0x8d                          # 004b3444
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b344a
L_004b3454:
    # block 0x004b3454: entered by ja at 0x004b305a; jmp at 0x004b326c; jmp at 0x004b32cc; jmp at 0x004b331a; more, 4 instruction(s), ends with je to 0x004b349e (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b3454
    mov ecx, dword ptr [0x63a8c8]                # 004b3457
    cmp ecx, dword ptr [eax + field_24]          # 004b345d
    je.d8 L_004b349e                             # 004b3460
    # block 0x004b3462: entered by fall-through of je at 0x004b3460, 3 instruction(s), ends with je to 0x004b3474 (forward)
    mov edx, 0x1                                 # 004b3462
    test edx, edx                                # 004b3467
    je.d8 L_004b3474                             # 004b3469
    # block 0x004b346b: entered by fall-through of je at 0x004b3469, 2 instruction(s), ends with forward jump to 0x004b3492
    mov dword ptr [ebp - local_18], 0x0          # 004b346b
    jmp.d8 L_004b3492                            # 004b3472
L_004b3474:
    # block 0x004b3474: entered by je at 0x004b3469, 8 instruction(s), calls FUN_00427a40, falls into the block at 0x004b3492
    mov eax, dword ptr [ebp - local_c]           # 004b3474
    mov ecx, dword ptr [eax + field_24]          # 004b3477
    mov edx, dword ptr [4*ecx + 0x551670]        # 004b347a
    push edx                                     # 004b3481
    push 0x5517e8                                # 004b3482
    call FUN_00427a40                            # 004b3487
    add esp, 0x8                                 # 004b348c
    mov dword ptr [ebp - local_18], eax          # 004b348f
L_004b3492:
    # block 0x004b3492: entered by jmp at 0x004b3472, 3 instruction(s), falls into the block at 0x004b349e
    mov eax, dword ptr [ebp - local_c]           # 004b3492
    mov ecx, dword ptr [eax + field_24]          # 004b3495
    mov dword ptr [0x63a8c8], ecx                # 004b3498
L_004b349e:
    # block 0x004b349e: entered by je at 0x004b3460, 1 instruction(s), ends with forward jump to 0x004b36fc
    jmp.d32 L_004b36fc                           # 004b349e
L_004b34a3:
    # block 0x004b34a3: entered by je at 0x004b2d2b, 8 instruction(s), ends with je to 0x004b34d9 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004b34a3
    mov edi, 0x551814                            # 004b34ad
    mov esi, dword ptr [ebp - local_4]           # 004b34b2
    add esi, 0x274                               # 004b34b5
    mov ecx, 0x9                                 # 004b34bb
    {load} xor edx, edx                          # 004b34c0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b34c2
    je.d8 L_004b34d9                             # 004b34c4
    # block 0x004b34c6: entered by fall-through of je at 0x004b34c4, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004b34d9
    mov eax, dword ptr [ebp - local_4]           # 004b34c6
    add eax, 0x274                               # 004b34c9
    push eax                                     # 004b34ce
    mov ecx, 0x5c3a67                            # 004b34cf
    call FUN_004fba69                            # 004b34d4
L_004b34d9:
    # block 0x004b34d9: entered by je at 0x004b34c4, 7 instruction(s), ends with je to 0x004b3505 (forward)
    mov edi, 0x551820                            # 004b34d9
    mov esi, dword ptr [ebp - local_4]           # 004b34de
    add esi, 0x2a5                               # 004b34e1
    mov ecx, 0x9                                 # 004b34e7
    {load} xor edx, edx                          # 004b34ec
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b34ee
    je.d8 L_004b3505                             # 004b34f0
    # block 0x004b34f2: entered by fall-through of je at 0x004b34f0, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004b3505
    mov eax, dword ptr [ebp - local_4]           # 004b34f2
    add eax, 0x2a5                               # 004b34f5
    push eax                                     # 004b34fa
    mov ecx, 0x5c3a67                            # 004b34fb
    call FUN_004fba69                            # 004b3500
L_004b3505:
    # block 0x004b3505: entered by je at 0x004b34f0, 3 instruction(s), ends with je to 0x004b35f7 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b3505
    cmp dword ptr [ecx + field_1519], 0x0        # 004b3508
    je.d32 L_004b35f7                            # 004b350f
    # block 0x004b3515: entered by fall-through of je at 0x004b350f, 4 instruction(s), ends with je to 0x004b35c7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b3515
    movsx eax, word ptr [edx + field_353]        # 004b3518
    cmp eax, 0x270f                              # 004b351f
    je.d32 L_004b35c7                            # 004b3524
    # block 0x004b352a: entered by fall-through of je at 0x004b3524, 25 instruction(s), ends with jne to 0x004b35b3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b352a
    movsx edx, word ptr [ecx + field_353]        # 004b352d
    mov dword ptr [0x5bb57b], edx                # 004b3534
    mov eax, dword ptr [ebp - local_4]           # 004b353a
    mov cx, word ptr [eax + field_355]           # 004b353d
    mov word ptr [0x5bb599], cx                  # 004b3544
    mov edx, dword ptr [ebp - local_4]           # 004b354b
    mov ax, word ptr [edx + field_357]           # 004b354e
    mov word ptr [0x5bb595], ax                  # 004b3555
    mov ecx, dword ptr [ebp - local_4]           # 004b355b
    mov dx, word ptr [ecx + field_359]           # 004b355e
    mov word ptr [0x5c39ff], dx                  # 004b3565
    mov eax, dword ptr [ebp - local_4]           # 004b356c
    mov ecx, dword ptr [eax + field_35b]         # 004b356f
    mov dword ptr [0x5bb59b], ecx                # 004b3575
    mov edx, dword ptr [ebp - local_4]           # 004b357b
    mov eax, dword ptr [edx + field_35f]         # 004b357e
    mov dword ptr [0x5bb59f], eax                # 004b3584
    mov ecx, dword ptr [ebp - local_4]           # 004b3589
    mov edx, dword ptr [ecx + field_363]         # 004b358c
    mov dword ptr [0x5bb5a3], edx                # 004b3592
    mov eax, dword ptr [ebp - local_4]           # 004b3598
    movsx ecx, word ptr [eax + field_367]        # 004b359b
    cmp ecx, 0x1                                 # 004b35a2
    jne.d8 L_004b35b3                            # 004b35a5
    # block 0x004b35a7: entered by fall-through of jne at 0x004b35a5, 2 instruction(s), ends with forward jump to 0x004b35bd
    mov dword ptr [0x5bb1ca], 0x0                # 004b35a7
    jmp.d8 L_004b35bd                            # 004b35b1
L_004b35b3:
    # block 0x004b35b3: entered by jne at 0x004b35a5, 1 instruction(s), falls into the block at 0x004b35bd
    mov dword ptr [0x5bb1ca], 0x1                # 004b35b3
L_004b35bd:
    # block 0x004b35bd: entered by jmp at 0x004b35b1, 1 instruction(s), falls into the block at 0x004b35c7
    mov dword ptr [0x583999], 0x4                # 004b35bd
L_004b35c7:
    # block 0x004b35c7: entered by je at 0x004b3524, 4 instruction(s), ends with je to 0x004b35f2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b35c7
    movsx eax, word ptr [edx + field_369]        # 004b35ca
    cmp eax, -0x1                                # 004b35d1
    je.d8 L_004b35f2                             # 004b35d4
    # block 0x004b35d6: entered by fall-through of je at 0x004b35d4, 6 instruction(s), falls into the block at 0x004b35f2
    mov ecx, dword ptr [ebp - local_4]           # 004b35d6
    {load} xor edx, edx                          # 004b35d9
    mov dl, byte ptr [ecx + field_36b]           # 004b35db
    mov eax, dword ptr [ebp - local_4]           # 004b35e1
    movsx ecx, word ptr [eax + field_369]        # 004b35e4
    mov dword ptr [4*ecx + 0x585801], edx        # 004b35eb
L_004b35f2:
    # block 0x004b35f2: entered by je at 0x004b35d4, 1 instruction(s), ends with forward jump to 0x004b36e4
    jmp.d32 L_004b36e4                           # 004b35f2
L_004b35f7:
    # block 0x004b35f7: entered by je at 0x004b350f, 3 instruction(s), ends with je to 0x004b36e4 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b35f7
    cmp dword ptr [edx + field_151d], 0x0        # 004b35fa
    je.d32 L_004b36e4                            # 004b3601
    # block 0x004b3607: entered by fall-through of je at 0x004b3601, 4 instruction(s), ends with je to 0x004b36b9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b3607
    movsx ecx, word ptr [eax + field_307]        # 004b360a
    cmp ecx, 0x270f                              # 004b3611
    je.d32 L_004b36b9                            # 004b3617
    # block 0x004b361d: entered by fall-through of je at 0x004b3617, 25 instruction(s), ends with jne to 0x004b36a5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b361d
    movsx eax, word ptr [edx + field_307]        # 004b3620
    mov dword ptr [0x5bb57b], eax                # 004b3627
    mov ecx, dword ptr [ebp - local_4]           # 004b362c
    mov dx, word ptr [ecx + field_309]           # 004b362f
    mov word ptr [0x5bb599], dx                  # 004b3636
    mov eax, dword ptr [ebp - local_4]           # 004b363d
    mov cx, word ptr [eax + field_30b]           # 004b3640
    mov word ptr [0x5bb595], cx                  # 004b3647
    mov edx, dword ptr [ebp - local_4]           # 004b364e
    mov ax, word ptr [edx + field_30d]           # 004b3651
    mov word ptr [0x5c39ff], ax                  # 004b3658
    mov ecx, dword ptr [ebp - local_4]           # 004b365e
    mov edx, dword ptr [ecx + field_30f]         # 004b3661
    mov dword ptr [0x5bb59b], edx                # 004b3667
    mov eax, dword ptr [ebp - local_4]           # 004b366d
    mov ecx, dword ptr [eax + field_313]         # 004b3670
    mov dword ptr [0x5bb59f], ecx                # 004b3676
    mov edx, dword ptr [ebp - local_4]           # 004b367c
    mov eax, dword ptr [edx + field_317]         # 004b367f
    mov dword ptr [0x5bb5a3], eax                # 004b3685
    mov ecx, dword ptr [ebp - local_4]           # 004b368a
    movsx edx, word ptr [ecx + field_31b]        # 004b368d
    cmp edx, 0x1                                 # 004b3694
    jne.d8 L_004b36a5                            # 004b3697
    # block 0x004b3699: entered by fall-through of jne at 0x004b3697, 2 instruction(s), ends with forward jump to 0x004b36af
    mov dword ptr [0x5bb1ca], 0x0                # 004b3699
    jmp.d8 L_004b36af                            # 004b36a3
L_004b36a5:
    # block 0x004b36a5: entered by jne at 0x004b3697, 1 instruction(s), falls into the block at 0x004b36af
    mov dword ptr [0x5bb1ca], 0x1                # 004b36a5
L_004b36af:
    # block 0x004b36af: entered by jmp at 0x004b36a3, 1 instruction(s), falls into the block at 0x004b36b9
    mov dword ptr [0x583999], 0x4                # 004b36af
L_004b36b9:
    # block 0x004b36b9: entered by je at 0x004b3617, 4 instruction(s), ends with je to 0x004b36e4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b36b9
    movsx ecx, word ptr [eax + field_31d]        # 004b36bc
    cmp ecx, -0x1                                # 004b36c3
    je.d8 L_004b36e4                             # 004b36c6
    # block 0x004b36c8: entered by fall-through of je at 0x004b36c6, 6 instruction(s), falls into the block at 0x004b36e4
    mov edx, dword ptr [ebp - local_4]           # 004b36c8
    {load} xor eax, eax                          # 004b36cb
    mov al, byte ptr [edx + field_31f]           # 004b36cd
    mov ecx, dword ptr [ebp - local_4]           # 004b36d3
    movsx edx, word ptr [ecx + field_31d]        # 004b36d6
    mov dword ptr [4*edx + 0x585801], eax        # 004b36dd
L_004b36e4:
    # block 0x004b36e4: entered by jmp at 0x004b35f2; je at 0x004b3601; je at 0x004b36c6, 7 instruction(s), calls FUN_0042ba3a, FUN_004afd7e, falls into the block at 0x004b36fc
    mov eax, dword ptr [ebp - local_c]           # 004b36e4
    mov cx, word ptr [eax + field_1e]            # 004b36e7
    push ecx                                     # 004b36eb
    call FUN_0042ba3a                            # 004b36ec
    add esp, 0x4                                 # 004b36f1
    mov ecx, dword ptr [ebp - local_c]           # 004b36f4
    call FUN_004afd7e                            # 004b36f7
L_004b36fc:
    # block 0x004b36fc: entered by jmp at 0x004b2d31; jmp at 0x004b3048; jmp at 0x004b349e, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b36fc
    pop esi                                      # 004b36fd
    {load} mov esp, ebp                          # 004b36fe
    pop ebp                                      # 004b3700
    ret 0x4                                      # 004b3701

# --- data items (not part of the function) -------------------------
.org 0x004b3704 - 0x401000
SWTAB_004b3704:  # 6 case address(es)
    .long L_004b306a - .text + 0x401000
    .long L_004b331f - .text + 0x401000
    .long L_004b3271 - .text + 0x401000
    .long L_004b32d1 - .text + 0x401000
    .long L_004b340b - .text + 0x401000
    .long L_004b3394 - .text + 0x401000
.set SWTAB_004b3704_VA, SWTAB_004b3704 - .text + 0x401000

