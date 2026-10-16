# FUN_004cbf72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cbf72
# extent:       0x004cbf72-0x004cc3bd (1099 code bytes)
# span:         0x004cbf72-0x004cc3bd (code 1099, tables 0, padding 0)
# sha256:       e9a7582506123bbe69c6e939dd78bb8ce7b246222ae897e194ccb8857be0edad
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cbf72
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_4, field_7, field_8, field_9, field_10, field_16, field_1a, field_122, field_126, field_12e, field_132 and 2 more; [ecx + n] field_5, field_c, field_1a, field_21, field_122, field_126, field_132, field_13a, field_13e, field_142, field_146; [edx + n] field_2, field_4, field_8, field_10, field_14, field_1a, field_21, field_25, field_122, field_126, field_12e, field_132 and 3 more
# callees:      calls FUN_004cbb00, FUN_004cc70f, FUN_004cc3bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 279 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ field_7, 0x7  # offset +0x7
.equ field_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_12e, 0x12e  # offset +0x12e
.equ field_132, 0x132  # offset +0x132
.equ field_13a, 0x13a  # offset +0x13a
.equ field_13e, 0x13e  # offset +0x13e
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146

# --- external targets -----------------------------------------------
.set FUN_004cbb00, .text + (0x004cbb00 - 0x401000)
.set FUN_004cc3bd, .text + (0x004cc3bd - 0x401000)
.set FUN_004cc70f, .text + (0x004cc70f - 0x401000)

.org 0x004cbf72 - 0x401000
.globl FUN_004cbf72
FUN_004cbf72:
    # block 0x004cbf72: entry, 27 instruction(s), ends with je to 0x004cbfee (forward)
    push ebp                                     # 004cbf72
    {load} mov ebp, esp                          # 004cbf73
    sub esp, 0x18                                # 004cbf75
    push esi                                     # 004cbf78
    push edi                                     # 004cbf79
    mov dword ptr [ebp - local_14], ecx          # 004cbf7a
    mov dword ptr [ebp - local_c], 0x1           # 004cbf7d
    mov dword ptr [ebp - local_10], 0x1          # 004cbf84
    mov dword ptr [ebp - local_8], 0x0           # 004cbf8b
    mov dword ptr [ebp - local_4], 0x0           # 004cbf92
    mov eax, dword ptr [ebp - local_14]          # 004cbf99
    mov dword ptr [eax + field_13a], 0x0         # 004cbf9c
    mov ecx, dword ptr [ebp - local_14]          # 004cbfa6
    mov dword ptr [ecx + field_13e], 0x0         # 004cbfa9
    mov edx, dword ptr [ebp - local_14]          # 004cbfb3
    mov eax, dword ptr [edx + field_13a]         # 004cbfb6
    add eax, 0x18                                # 004cbfbc
    mov ecx, dword ptr [ebp - local_14]          # 004cbfbf
    mov dword ptr [ecx + field_142], eax         # 004cbfc2
    mov edx, dword ptr [ebp - local_14]          # 004cbfc8
    mov eax, dword ptr [edx + field_13e]         # 004cbfcb
    add eax, 0x18                                # 004cbfd1
    mov ecx, dword ptr [ebp - local_14]          # 004cbfd4
    mov dword ptr [ecx + field_146], eax         # 004cbfd7
    mov edx, dword ptr [ebp - local_14]          # 004cbfdd
    cmp dword ptr [edx + field_1a], 0x0          # 004cbfe0
    je.d8 L_004cbfee                             # 004cbfe4
    # block 0x004cbfe6: entered by fall-through of je at 0x004cbfe4, 2 instruction(s), calls FUN_004cbb00, falls into the block at 0x004cbfee
    mov ecx, dword ptr [ebp - local_14]          # 004cbfe6
    call FUN_004cbb00                            # 004cbfe9
L_004cbfee:
    # block 0x004cbfee: entered by je at 0x004cbfe4, 39 instruction(s), calls FUN_004cc70f, ends with forward jump to 0x004cc077
    push 0x29                                    # 004cbfee
    mov eax, dword ptr [ebp - local_14]          # 004cbff0
    add eax, 0x1a                                # 004cbff3
    push eax                                     # 004cbff6
    mov ecx, dword ptr [ebp - local_14]          # 004cbff7
    call FUN_004cc70f                            # 004cbffa
    mov edi, 0x558e30                            # 004cbfff
    mov ecx, dword ptr [ebp - local_14]          # 004cc004
    mov edx, dword ptr [ecx + field_1a]          # 004cc007
    or ecx, -0x1                                 # 004cc00a
    {load} xor eax, eax                          # 004cc00d
    repne scasb al, byte ptr es:[edi]            # 004cc00f
    not ecx                                      # 004cc011
    {load} sub edi, ecx                          # 004cc013
    {load} mov esi, edi                          # 004cc015
    {load} mov eax, ecx                          # 004cc017
    {load} mov edi, edx                          # 004cc019
    shr ecx, 0x2                                 # 004cc01b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cc01e
    {load} mov ecx, eax                          # 004cc020
    and ecx, 0x3                                 # 004cc022
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004cc025
    mov ecx, dword ptr [ebp - local_14]          # 004cc027
    mov edx, dword ptr [ecx + field_1a]          # 004cc02a
    mov dword ptr [edx + field_21], 0x1c2        # 004cc02d
    mov eax, dword ptr [ebp - local_14]          # 004cc034
    mov ecx, dword ptr [eax + field_1a]          # 004cc037
    mov edx, dword ptr [ecx + field_21]          # 004cc03a
    imul edx, edx, 0xd                           # 004cc03d
    push edx                                     # 004cc040
    mov eax, dword ptr [ebp - local_14]          # 004cc041
    mov ecx, dword ptr [eax + field_1a]          # 004cc044
    add ecx, 0x25                                # 004cc047
    push ecx                                     # 004cc04a
    mov ecx, dword ptr [ebp - local_14]          # 004cc04b
    call FUN_004cc70f                            # 004cc04e
    mov edx, dword ptr [ebp - local_14]          # 004cc053
    mov dword ptr [edx + field_12e], 0x0         # 004cc056
    jmp.d8 L_004cc077                            # 004cc060
L_004cc062:
    # block 0x004cc062: entered by jmp at 0x004cc3aa, 5 instruction(s), falls into the block at 0x004cc077
    mov eax, dword ptr [ebp - local_14]          # 004cc062
    mov ecx, dword ptr [eax + field_12e]         # 004cc065
    add ecx, 0x1                                 # 004cc06b
    mov edx, dword ptr [ebp - local_14]          # 004cc06e
    mov dword ptr [edx + field_12e], ecx         # 004cc071
L_004cc077:
    # block 0x004cc077: entered by jmp at 0x004cc060, 6 instruction(s), ends with jge to 0x004cc3af (forward)
    mov eax, dword ptr [ebp - local_14]          # 004cc077
    mov ecx, dword ptr [eax + field_1a]          # 004cc07a
    mov edx, dword ptr [ebp - local_14]          # 004cc07d
    mov eax, dword ptr [edx + field_12e]         # 004cc080
    cmp eax, dword ptr [ecx + field_21]          # 004cc086
    jge.d32 L_004cc3af                           # 004cc089
    # block 0x004cc08f: entered by fall-through of jge at 0x004cc089, 40 instruction(s), calls FUN_004cc70f, ends with forward jump to 0x004cc149
    mov ecx, dword ptr [ebp - local_14]          # 004cc08f
    mov edx, dword ptr [ecx + field_1a]          # 004cc092
    mov eax, dword ptr [ebp - local_14]          # 004cc095
    mov ecx, dword ptr [eax + field_12e]         # 004cc098
    imul ecx, ecx, 0xd                           # 004cc09e
    mov edx, dword ptr [edx + field_25]          # 004cc0a1
    {load} add edx, ecx                          # 004cc0a4
    mov eax, dword ptr [ebp - local_14]          # 004cc0a6
    mov dword ptr [eax + field_122], edx         # 004cc0a9
    mov ecx, dword ptr [ebp - local_14]          # 004cc0af
    mov edx, dword ptr [ecx + field_122]         # 004cc0b2
    mov eax, dword ptr [ebp - local_14]          # 004cc0b8
    mov cx, word ptr [eax + field_12e]           # 004cc0bb
    mov word ptr [edx], cx                       # 004cc0c2
    mov edx, dword ptr [ebp - local_14]          # 004cc0c5
    mov eax, dword ptr [edx + field_122]         # 004cc0c8
    mov word ptr [eax + field_2], 0x2            # 004cc0ce
    mov ecx, dword ptr [ebp - local_14]          # 004cc0d4
    mov edx, dword ptr [ecx + field_122]         # 004cc0d7
    mov byte ptr [edx + field_4], 0x1            # 004cc0dd
    mov eax, dword ptr [ebp - local_14]          # 004cc0e1
    mov ecx, dword ptr [eax + field_122]         # 004cc0e4
    mov word ptr [ecx + field_5], 0x0            # 004cc0ea
    mov edx, dword ptr [ebp - local_14]          # 004cc0f0
    mov eax, dword ptr [edx + field_122]         # 004cc0f3
    mov word ptr [eax + field_7], 0x0            # 004cc0f9
    mov ecx, dword ptr [ebp - local_14]          # 004cc0ff
    mov edx, dword ptr [ecx + field_122]         # 004cc102
    movsx eax, word ptr [edx + field_2]          # 004cc108
    imul eax, eax, 0x18                          # 004cc10c
    push eax                                     # 004cc10f
    mov ecx, dword ptr [ebp - local_14]          # 004cc110
    mov edx, dword ptr [ecx + field_122]         # 004cc113
    add edx, 0x9                                 # 004cc119
    push edx                                     # 004cc11c
    mov ecx, dword ptr [ebp - local_14]          # 004cc11d
    call FUN_004cc70f                            # 004cc120
    mov eax, dword ptr [ebp - local_14]          # 004cc125
    mov dword ptr [eax + field_132], 0x0         # 004cc128
    jmp.d8 L_004cc149                            # 004cc132
L_004cc134:
    # block 0x004cc134: entered by jmp at 0x004cc3a5, 5 instruction(s), falls into the block at 0x004cc149
    mov ecx, dword ptr [ebp - local_14]          # 004cc134
    mov edx, dword ptr [ecx + field_132]         # 004cc137
    add edx, 0x1                                 # 004cc13d
    mov eax, dword ptr [ebp - local_14]          # 004cc140
    mov dword ptr [eax + field_132], edx         # 004cc143
L_004cc149:
    # block 0x004cc149: entered by jmp at 0x004cc132, 6 instruction(s), ends with jge to 0x004cc3aa (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004cc149
    mov edx, dword ptr [ecx + field_122]         # 004cc14c
    movsx eax, word ptr [edx + field_2]          # 004cc152
    mov ecx, dword ptr [ebp - local_14]          # 004cc156
    cmp dword ptr [ecx + field_132], eax         # 004cc159
    jge.d32 L_004cc3aa                           # 004cc15f
    # block 0x004cc165: entered by fall-through of jge at 0x004cc15f, 14 instruction(s), ends with je to 0x004cc1a5 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004cc165
    mov eax, dword ptr [edx + field_122]         # 004cc168
    mov ecx, dword ptr [ebp - local_14]          # 004cc16e
    mov edx, dword ptr [ecx + field_132]         # 004cc171
    imul edx, edx, 0x18                          # 004cc177
    mov eax, dword ptr [eax + field_9]           # 004cc17a
    {load} add eax, edx                          # 004cc17d
    mov ecx, dword ptr [ebp - local_14]          # 004cc17f
    mov dword ptr [ecx + field_126], eax         # 004cc182
    mov edx, dword ptr [ebp - local_14]          # 004cc188
    mov eax, dword ptr [edx + field_132]         # 004cc18b
    mov dword ptr [ebp - local_18], eax          # 004cc191
    cmp dword ptr [ebp - local_18], 0x0          # 004cc194
    je.d8 L_004cc1a5                             # 004cc198
    # block 0x004cc19a: entered by fall-through of je at 0x004cc198, 2 instruction(s), ends with je to 0x004cc1fb (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 004cc19a
    je.d8 L_004cc1fb                             # 004cc19e
    # block 0x004cc1a0: entered by fall-through of je at 0x004cc19e, 1 instruction(s), ends with forward jump to 0x004cc23b
    jmp.d32 L_004cc23b                           # 004cc1a0
L_004cc1a5:
    # block 0x004cc1a5: entered by je at 0x004cc198, 21 instruction(s), ends with forward jump to 0x004cc23b
    mov ecx, dword ptr [ebp - local_14]          # 004cc1a5
    mov edx, dword ptr [ecx + field_126]         # 004cc1a8
    mov eax, dword ptr [ebp - local_14]          # 004cc1ae
    mov ecx, dword ptr [eax + field_13a]         # 004cc1b1
    mov dword ptr [edx + field_4], ecx           # 004cc1b7
    mov edx, dword ptr [ebp - local_14]          # 004cc1ba
    mov eax, dword ptr [edx + field_126]         # 004cc1bd
    mov ecx, dword ptr [ebp - local_14]          # 004cc1c3
    mov edx, dword ptr [ecx + field_13e]         # 004cc1c6
    mov dword ptr [eax + field_8], edx           # 004cc1cc
    mov eax, dword ptr [ebp - local_14]          # 004cc1cf
    mov ecx, dword ptr [eax + field_126]         # 004cc1d2
    mov edx, dword ptr [ebp - local_14]          # 004cc1d8
    mov eax, dword ptr [edx + field_142]         # 004cc1db
    mov dword ptr [ecx + field_c], eax           # 004cc1e1
    mov ecx, dword ptr [ebp - local_14]          # 004cc1e4
    mov edx, dword ptr [ecx + field_126]         # 004cc1e7
    mov eax, dword ptr [ebp - local_14]          # 004cc1ed
    mov ecx, dword ptr [eax + field_146]         # 004cc1f0
    mov dword ptr [edx + field_10], ecx          # 004cc1f6
    jmp.d8 L_004cc23b                            # 004cc1f9
L_004cc1fb:
    # block 0x004cc1fb: entered by je at 0x004cc19e, 12 instruction(s), falls into the block at 0x004cc23b
    mov edx, dword ptr [ebp - local_14]          # 004cc1fb
    mov eax, dword ptr [edx + field_126]         # 004cc1fe
    mov dword ptr [eax + field_4], 0x0           # 004cc204
    mov ecx, dword ptr [ebp - local_14]          # 004cc20b
    mov edx, dword ptr [ecx + field_126]         # 004cc20e
    mov dword ptr [edx + field_8], 0x0           # 004cc214
    mov eax, dword ptr [ebp - local_14]          # 004cc21b
    mov ecx, dword ptr [eax + field_126]         # 004cc21e
    mov dword ptr [ecx + field_c], 0x18          # 004cc224
    mov edx, dword ptr [ebp - local_14]          # 004cc22b
    mov eax, dword ptr [edx + field_126]         # 004cc22e
    mov dword ptr [eax + field_10], 0xe          # 004cc234
L_004cc23b:
    # block 0x004cc23b: entered by jmp at 0x004cc1a0; jmp at 0x004cc1f9, 20 instruction(s), ends with je to 0x004cc3a5 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004cc23b
    mov edx, dword ptr [ecx + field_126]         # 004cc23e
    mov eax, dword ptr [ebp - local_14]          # 004cc244
    mov ecx, dword ptr [eax + field_132]         # 004cc247
    mov dword ptr [edx], ecx                     # 004cc24d
    mov edx, dword ptr [ebp - local_14]          # 004cc24f
    mov eax, dword ptr [edx + field_132]         # 004cc252
    add eax, 0x1                                 # 004cc258
    mov ecx, dword ptr [ebp - local_14]          # 004cc25b
    mov edx, dword ptr [ecx + field_126]         # 004cc25e
    mov word ptr [edx + field_14], ax            # 004cc264
    mov eax, dword ptr [ebp - local_14]          # 004cc268
    mov ecx, dword ptr [eax + field_132]         # 004cc26b
    add ecx, 0x1                                 # 004cc271
    mov edx, dword ptr [ebp - local_14]          # 004cc274
    mov eax, dword ptr [edx + field_126]         # 004cc277
    mov word ptr [eax + field_16], cx            # 004cc27d
    mov ecx, 0x1                                 # 004cc281
    test ecx, ecx                                # 004cc286
    je.d32 L_004cc3a5                            # 004cc288
    # block 0x004cc28e: entered by fall-through of je at 0x004cc288, 2 instruction(s), ends with je to 0x004cc2db (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004cc28e
    je.d8 L_004cc2db                             # 004cc292
    # block 0x004cc294: entered by fall-through of je at 0x004cc292, 7 instruction(s), ends with jl to 0x004cc2b8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cc294
    add edx, 0x3                                 # 004cc297
    mov dword ptr [ebp - local_8], edx           # 004cc29a
    mov eax, dword ptr [ebp - local_8]           # 004cc29d
    add eax, 0x19                                # 004cc2a0
    cmp eax, 0x10c                               # 004cc2a3
    jl.d8 L_004cc2b8                             # 004cc2a8
    # block 0x004cc2aa: entered by fall-through of jl at 0x004cc2a8, 2 instruction(s), falls into the block at 0x004cc2b8
    mov dword ptr [ebp - local_c], 0x0           # 004cc2aa
    mov dword ptr [ebp - local_8], 0xf3          # 004cc2b1
L_004cc2b8:
    # block 0x004cc2b8: entered by jl at 0x004cc2a8, 9 instruction(s), ends with forward jump to 0x004cc319
    mov ecx, dword ptr [ebp - local_14]          # 004cc2b8
    mov edx, dword ptr [ebp - local_8]           # 004cc2bb
    mov dword ptr [ecx + field_13a], edx         # 004cc2be
    mov eax, dword ptr [ebp - local_14]          # 004cc2c4
    mov ecx, dword ptr [eax + field_13a]         # 004cc2c7
    add ecx, 0x18                                # 004cc2cd
    mov edx, dword ptr [ebp - local_14]          # 004cc2d0
    mov dword ptr [edx + field_142], ecx         # 004cc2d3
    jmp.d8 L_004cc319                            # 004cc2d9
L_004cc2db:
    # block 0x004cc2db: entered by je at 0x004cc292, 5 instruction(s), ends with jg to 0x004cc2f8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cc2db
    sub eax, 0x3                                 # 004cc2de
    mov dword ptr [ebp - local_8], eax           # 004cc2e1
    cmp dword ptr [ebp - local_8], 0x0           # 004cc2e4
    jg.d8 L_004cc2f8                             # 004cc2e8
    # block 0x004cc2ea: entered by fall-through of jg at 0x004cc2e8, 2 instruction(s), falls into the block at 0x004cc2f8
    mov dword ptr [ebp - local_c], 0x1           # 004cc2ea
    mov dword ptr [ebp - local_8], 0x0           # 004cc2f1
L_004cc2f8:
    # block 0x004cc2f8: entered by jg at 0x004cc2e8, 8 instruction(s), falls into the block at 0x004cc319
    mov ecx, dword ptr [ebp - local_14]          # 004cc2f8
    mov edx, dword ptr [ebp - local_8]           # 004cc2fb
    mov dword ptr [ecx + field_13a], edx         # 004cc2fe
    mov eax, dword ptr [ebp - local_14]          # 004cc304
    mov ecx, dword ptr [eax + field_13a]         # 004cc307
    add ecx, 0x18                                # 004cc30d
    mov edx, dword ptr [ebp - local_14]          # 004cc310
    mov dword ptr [edx + field_142], ecx         # 004cc313
L_004cc319:
    # block 0x004cc319: entered by jmp at 0x004cc2d9, 2 instruction(s), ends with je to 0x004cc367 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 004cc319
    je.d8 L_004cc367                             # 004cc31d
    # block 0x004cc31f: entered by fall-through of je at 0x004cc31d, 7 instruction(s), ends with jl to 0x004cc344 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc31f
    add eax, 0x2                                 # 004cc322
    mov dword ptr [ebp - local_4], eax           # 004cc325
    mov ecx, dword ptr [ebp - local_4]           # 004cc328
    add ecx, 0x19                                # 004cc32b
    cmp ecx, 0x92                                # 004cc32e
    jl.d8 L_004cc344                             # 004cc334
    # block 0x004cc336: entered by fall-through of jl at 0x004cc334, 2 instruction(s), falls into the block at 0x004cc344
    mov dword ptr [ebp - local_10], 0x0          # 004cc336
    mov dword ptr [ebp - local_4], 0x79          # 004cc33d
L_004cc344:
    # block 0x004cc344: entered by jl at 0x004cc334, 9 instruction(s), ends with forward jump to 0x004cc3a5
    mov edx, dword ptr [ebp - local_14]          # 004cc344
    mov eax, dword ptr [ebp - local_4]           # 004cc347
    mov dword ptr [edx + field_13e], eax         # 004cc34a
    mov ecx, dword ptr [ebp - local_14]          # 004cc350
    mov edx, dword ptr [ecx + field_13e]         # 004cc353
    add edx, 0x18                                # 004cc359
    mov eax, dword ptr [ebp - local_14]          # 004cc35c
    mov dword ptr [eax + field_146], edx         # 004cc35f
    jmp.d8 L_004cc3a5                            # 004cc365
L_004cc367:
    # block 0x004cc367: entered by je at 0x004cc31d, 5 instruction(s), ends with jg to 0x004cc384 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cc367
    sub ecx, 0x2                                 # 004cc36a
    mov dword ptr [ebp - local_4], ecx           # 004cc36d
    cmp dword ptr [ebp - local_4], 0x0           # 004cc370
    jg.d8 L_004cc384                             # 004cc374
    # block 0x004cc376: entered by fall-through of jg at 0x004cc374, 2 instruction(s), falls into the block at 0x004cc384
    mov dword ptr [ebp - local_10], 0x1          # 004cc376
    mov dword ptr [ebp - local_4], 0x0           # 004cc37d
L_004cc384:
    # block 0x004cc384: entered by jg at 0x004cc374, 8 instruction(s), falls into the block at 0x004cc3a5
    mov edx, dword ptr [ebp - local_14]          # 004cc384
    mov eax, dword ptr [ebp - local_4]           # 004cc387
    mov dword ptr [edx + field_13e], eax         # 004cc38a
    mov ecx, dword ptr [ebp - local_14]          # 004cc390
    mov edx, dword ptr [ecx + field_13e]         # 004cc393
    add edx, 0x18                                # 004cc399
    mov eax, dword ptr [ebp - local_14]          # 004cc39c
    mov dword ptr [eax + field_146], edx         # 004cc39f
L_004cc3a5:
    # block 0x004cc3a5: entered by je at 0x004cc288; jmp at 0x004cc365, 1 instruction(s), ends with backward jump to 0x004cc134
    jmp.d32 L_004cc134                           # 004cc3a5
L_004cc3aa:
    # block 0x004cc3aa: entered by jge at 0x004cc15f, 1 instruction(s), ends with backward jump to 0x004cc062
    jmp.d32 L_004cc062                           # 004cc3aa
L_004cc3af:
    # block 0x004cc3af: entered by jge at 0x004cc089, 7 instruction(s), calls FUN_004cc3bd, ends with ret
    mov ecx, dword ptr [ebp - local_14]          # 004cc3af
    call FUN_004cc3bd                            # 004cc3b2
    pop edi                                      # 004cc3b7
    pop esi                                      # 004cc3b8
    {load} mov esp, ebp                          # 004cc3b9
    pop ebp                                      # 004cc3bb
    ret                                          # 004cc3bc

