# FUN_004d5f91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5f91
# extent:       0x004d5f91-0x004d65e9 (1624 code bytes)
# span:         0x004d5f91-0x004d65e9 (code 1624, tables 0, padding 0)
# sha256:       a1aeadb12939a3ef2fbe77af320305b67c33e8e009b5956dac051120044f8246
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5f91
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_94da, field_955a, field_956e, field_9576, field_957e, field_9586, field_95a6, field_95aa, field_9718 and 8 more; [ecx + n] field_4, field_8, field_c, field_950e, field_9522, field_9526, field_956e, field_9572, field_9576, field_9582, field_9586, field_95a6 and 11 more; [edx + n] field_94d6, field_950e, field_9522, field_9526, field_955a, field_9572, field_957a, field_9582, field_95a6, field_9718, field_97e8, field_989c and 3 more
# callees:      calls FUN_004d65e9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 396 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_94d6, 0x94d6  # offset +0x94d6
.equ field_94da, 0x94da  # offset +0x94da
.equ field_950e, 0x950e  # offset +0x950e
.equ field_9522, 0x9522  # offset +0x9522
.equ field_9526, 0x9526  # offset +0x9526
.equ field_955a, 0x955a  # offset +0x955a
.equ field_956e, 0x956e  # offset +0x956e
.equ field_9572, 0x9572  # offset +0x9572
.equ field_9576, 0x9576  # offset +0x9576
.equ field_957a, 0x957a  # offset +0x957a
.equ field_957e, 0x957e  # offset +0x957e
.equ field_9582, 0x9582  # offset +0x9582
.equ field_9586, 0x9586  # offset +0x9586
.equ field_95a6, 0x95a6  # offset +0x95a6
.equ field_95aa, 0x95aa  # offset +0x95aa
.equ field_9714, 0x9714  # offset +0x9714
.equ field_9718, 0x9718  # offset +0x9718
.equ field_971c, 0x971c  # offset +0x971c
.equ field_9720, 0x9720  # offset +0x9720
.equ field_9754, 0x9754  # offset +0x9754
.equ field_9758, 0x9758  # offset +0x9758
.equ field_975c, 0x975c  # offset +0x975c
.equ field_9760, 0x9760  # offset +0x9760
.equ field_97e4, 0x97e4  # offset +0x97e4
.equ field_97e8, 0x97e8  # offset +0x97e8
.equ field_97ec, 0x97ec  # offset +0x97ec
.equ field_97f0, 0x97f0  # offset +0x97f0
.equ field_9810, 0x9810  # offset +0x9810
.equ field_989c, 0x989c  # offset +0x989c
.equ field_98a4, 0x98a4  # offset +0x98a4
.equ field_98a8, 0x98a8  # offset +0x98a8

# --- external targets -----------------------------------------------
.set FUN_004d65e9, .text + (0x004d65e9 - 0x401000)

.org 0x004d5f91 - 0x401000
.globl FUN_004d5f91
FUN_004d5f91:
    # block 0x004d5f91: entry, 9 instruction(s), ends with jne to 0x004d6316 (forward)
    push ebp                                     # 004d5f91
    {load} mov ebp, esp                          # 004d5f92
    push ecx                                     # 004d5f94
    push esi                                     # 004d5f95
    push edi                                     # 004d5f96
    mov dword ptr [ebp - local_4], ecx           # 004d5f97
    mov eax, dword ptr [ebp - local_4]           # 004d5f9a
    cmp dword ptr [eax + field_955a], 0x0        # 004d5f9d
    jne.d32 L_004d6316                           # 004d5fa4
    # block 0x004d5faa: entered by fall-through of jne at 0x004d5fa4, 12 instruction(s), ends with jne to 0x004d6012 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d5faa
    mov edx, dword ptr [ebp - local_4]           # 004d5fad
    mov eax, dword ptr [edx + field_94d6]        # 004d5fb0
    mov dword ptr [ecx + field_950e], eax        # 004d5fb6
    mov ecx, dword ptr [ebp - local_4]           # 004d5fbc
    mov dword ptr [ecx + field_98a4], 0x0        # 004d5fbf
    mov edi, 0x63a99c                            # 004d5fc9
    mov esi, 0x63a565                            # 004d5fce
    mov ecx, 0x1                                 # 004d5fd3
    {load} xor edx, edx                          # 004d5fd8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d5fda
    jne.d8 L_004d6012                            # 004d5fdc
    # block 0x004d5fde: entered by fall-through of jne at 0x004d5fdc, 20 instruction(s), ends with forward jump to 0x004d603f
    mov eax, dword ptr [ebp - local_4]           # 004d5fde
    add eax, 0x2ef                               # 004d5fe1
    {load} mov edi, eax                          # 004d5fe6
    mov ecx, dword ptr [ebp - local_4]           # 004d5fe8
    add ecx, 0x96d3                              # 004d5feb
    {load} mov edx, ecx                          # 004d5ff1
    or ecx, -0x1                                 # 004d5ff3
    {load} xor eax, eax                          # 004d5ff6
    repne scasb al, byte ptr es:[edi]            # 004d5ff8
    not ecx                                      # 004d5ffa
    {load} sub edi, ecx                          # 004d5ffc
    {load} mov esi, edi                          # 004d5ffe
    {load} mov eax, ecx                          # 004d6000
    {load} mov edi, edx                          # 004d6002
    shr ecx, 0x2                                 # 004d6004
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6007
    {load} mov ecx, eax                          # 004d6009
    and ecx, 0x3                                 # 004d600b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d600e
    jmp.d8 L_004d603f                            # 004d6010
L_004d6012:
    # block 0x004d6012: entered by jne at 0x004d5fdc, 17 instruction(s), falls into the block at 0x004d603f
    mov edi, 0x63a565                            # 004d6012
    mov ecx, dword ptr [ebp - local_4]           # 004d6017
    add ecx, 0x96d3                              # 004d601a
    {load} mov edx, ecx                          # 004d6020
    or ecx, -0x1                                 # 004d6022
    {load} xor eax, eax                          # 004d6025
    repne scasb al, byte ptr es:[edi]            # 004d6027
    not ecx                                      # 004d6029
    {load} sub edi, ecx                          # 004d602b
    {load} mov esi, edi                          # 004d602d
    {load} mov eax, ecx                          # 004d602f
    {load} mov edi, edx                          # 004d6031
    shr ecx, 0x2                                 # 004d6033
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6036
    {load} mov ecx, eax                          # 004d6038
    and ecx, 0x3                                 # 004d603a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d603d
L_004d603f:
    # block 0x004d603f: entered by jmp at 0x004d6010, 2 instruction(s), ends with je to 0x004d6081 (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004d603f
    je.d8 L_004d6081                             # 004d6046
    # block 0x004d6048: entered by fall-through of je at 0x004d6046, 14 instruction(s), calls FUN_004d65e9, ends with forward jump to 0x004d60b9
    mov ecx, dword ptr [ebp - local_4]           # 004d6048
    mov dword ptr [ecx + field_956e], 0x1        # 004d604b
    mov edx, dword ptr [ebp - local_4]           # 004d6055
    mov dword ptr [edx + field_95a6], 0x1        # 004d6058
    mov eax, dword ptr [ebp - local_4]           # 004d6062
    add eax, 0x96d3                              # 004d6065
    push eax                                     # 004d606a
    mov ecx, dword ptr [ebp - local_4]           # 004d606b
    mov edx, dword ptr [ecx + field_95a6]        # 004d606e
    push edx                                     # 004d6074
    push 0x9                                     # 004d6075
    mov ecx, dword ptr [ebp - local_4]           # 004d6077
    call FUN_004d65e9                            # 004d607a
    jmp.d8 L_004d60b9                            # 004d607f
L_004d6081:
    # block 0x004d6081: entered by je at 0x004d6046, 13 instruction(s), calls FUN_004d65e9, falls into the block at 0x004d60b9
    mov eax, dword ptr [ebp - local_4]           # 004d6081
    mov dword ptr [eax + field_956e], 0x4        # 004d6084
    mov ecx, dword ptr [ebp - local_4]           # 004d608e
    mov dword ptr [ecx + field_95a6], 0x0        # 004d6091
    mov edx, dword ptr [ebp - local_4]           # 004d609b
    add edx, 0x96d3                              # 004d609e
    push edx                                     # 004d60a4
    mov eax, dword ptr [ebp - local_4]           # 004d60a5
    mov ecx, dword ptr [eax + field_95a6]        # 004d60a8
    push ecx                                     # 004d60ae
    push 0x9                                     # 004d60af
    mov ecx, dword ptr [ebp - local_4]           # 004d60b1
    call FUN_004d65e9                            # 004d60b4
L_004d60b9:
    # block 0x004d60b9: entered by jmp at 0x004d607f, 19 instruction(s), ends with jle to 0x004d6125 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d60b9
    mov dword ptr [edx + field_97e8], 0x0        # 004d60bc
    mov eax, dword ptr [ebp - local_4]           # 004d60c6
    mov dword ptr [eax + field_97e4], 0x0        # 004d60c9
    mov ecx, dword ptr [ebp - local_4]           # 004d60d3
    mov edx, dword ptr [ecx + field_9522]        # 004d60d6
    sub edx, 0x1                                 # 004d60dc
    mov eax, dword ptr [ebp - local_4]           # 004d60df
    mov dword ptr [eax + field_97ec], edx        # 004d60e2
    mov ecx, dword ptr [ebp - local_4]           # 004d60e8
    mov edx, dword ptr [ecx + field_9526]        # 004d60eb
    sub edx, 0x1                                 # 004d60f1
    mov eax, dword ptr [ebp - local_4]           # 004d60f4
    mov dword ptr [eax + field_97f0], edx        # 004d60f7
    mov ecx, dword ptr [ebp - local_4]           # 004d60fd
    mov dword ptr [ecx + field_9572], 0x0        # 004d6100
    mov edx, dword ptr [ebp - local_4]           # 004d610a
    cmp dword ptr [edx + field_989c], 0x8        # 004d610d
    jle.d8 L_004d6125                            # 004d6114
    # block 0x004d6116: entered by fall-through of jle at 0x004d6114, 3 instruction(s), ends with forward jump to 0x004d6132
    mov eax, dword ptr [ebp - local_4]           # 004d6116
    mov dword ptr [eax + field_9576], 0x1        # 004d6119
    jmp.d8 L_004d6132                            # 004d6123
L_004d6125:
    # block 0x004d6125: entered by jle at 0x004d6114, 2 instruction(s), falls into the block at 0x004d6132
    mov ecx, dword ptr [ebp - local_4]           # 004d6125
    mov dword ptr [ecx + field_9576], 0x0        # 004d6128
L_004d6132:
    # block 0x004d6132: entered by jmp at 0x004d6123, 16 instruction(s), ends with forward jump to 0x004d6192
    mov edx, dword ptr [ebp - local_4]           # 004d6132
    mov dword ptr [edx + field_957a], 0x4        # 004d6135
    mov eax, dword ptr [ebp - local_4]           # 004d613f
    mov dword ptr [eax + field_957e], 0x1        # 004d6142
    mov ecx, dword ptr [ebp - local_4]           # 004d614c
    mov dword ptr [ecx + field_9582], 0x0        # 004d614f
    {load} xor edx, edx                          # 004d6159
    mov eax, dword ptr [ebp - local_4]           # 004d615b
    add eax, 0x9754                              # 004d615e
    mov dword ptr [eax], edx                     # 004d6163
    mov dword ptr [eax + field_4], edx           # 004d6165
    mov dword ptr [eax + field_8], edx           # 004d6168
    mov dword ptr [eax + field_c], edx           # 004d616b
    mov ecx, dword ptr [ebp - local_4]           # 004d616e
    mov dword ptr [ecx + field_98a8], 0x0        # 004d6171
    jmp.d8 L_004d6192                            # 004d617b
L_004d617d:
    # block 0x004d617d: entered by jmp at 0x004d630c, 5 instruction(s), falls into the block at 0x004d6192
    mov edx, dword ptr [ebp - local_4]           # 004d617d
    mov eax, dword ptr [edx + field_98a8]        # 004d6180
    add eax, 0x1                                 # 004d6186
    mov ecx, dword ptr [ebp - local_4]           # 004d6189
    mov dword ptr [ecx + field_98a8], eax        # 004d618c
L_004d6192:
    # block 0x004d6192: entered by jmp at 0x004d617b, 3 instruction(s), ends with jge to 0x004d6311 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d6192
    cmp dword ptr [edx + field_98a8], 0x8        # 004d6195
    jge.d32 L_004d6311                           # 004d619c
    # block 0x004d61a2: entered by fall-through of jge at 0x004d619c, 7 instruction(s), ends with jge to 0x004d6271 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d61a2
    mov ecx, dword ptr [eax + field_98a8]        # 004d61a5
    mov edx, dword ptr [ebp - local_4]           # 004d61ab
    add ecx, dword ptr [edx + field_98a4]        # 004d61ae
    mov eax, dword ptr [ebp - local_4]           # 004d61b4
    cmp ecx, dword ptr [eax + field_989c]        # 004d61b7
    jge.d32 L_004d6271                           # 004d61bd
    # block 0x004d61c3: entered by fall-through of jge at 0x004d61bd, 48 instruction(s), calls FUN_004d65e9, ends with forward jump to 0x004d6288
    mov ecx, dword ptr [ebp - local_4]           # 004d61c3
    mov edx, dword ptr [ecx + field_98a8]        # 004d61c6
    mov eax, dword ptr [ebp - local_4]           # 004d61cc
    mov dword ptr [eax + 4*edx + field_9586], 0x1 # 004d61cf
    mov ecx, dword ptr [ebp - local_4]           # 004d61da
    mov edx, dword ptr [ecx + field_98a8]        # 004d61dd
    mov eax, dword ptr [ebp - local_4]           # 004d61e3
    add edx, dword ptr [eax + field_98a4]        # 004d61e6
    mov ecx, dword ptr [ebp - local_4]           # 004d61ec
    mov edi, dword ptr [ecx + 4*edx + field_9810] # 004d61ef
    mov edx, dword ptr [ebp - local_4]           # 004d61f6
    mov eax, dword ptr [edx + field_98a8]        # 004d61f9
    add eax, 0x1                                 # 004d61ff
    imul eax, eax, 0x21                          # 004d6202
    mov ecx, dword ptr [ebp - local_4]           # 004d6205
    lea edx, [ecx + eax + field_95aa]            # 004d6208
    or ecx, -0x1                                 # 004d620f
    {load} xor eax, eax                          # 004d6212
    repne scasb al, byte ptr es:[edi]            # 004d6214
    not ecx                                      # 004d6216
    {load} sub edi, ecx                          # 004d6218
    {load} mov esi, edi                          # 004d621a
    {load} mov eax, ecx                          # 004d621c
    {load} mov edi, edx                          # 004d621e
    shr ecx, 0x2                                 # 004d6220
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6223
    {load} mov ecx, eax                          # 004d6225
    and ecx, 0x3                                 # 004d6227
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d622a
    mov ecx, dword ptr [ebp - local_4]           # 004d622c
    mov edx, dword ptr [ecx + field_98a8]        # 004d622f
    add edx, 0x1                                 # 004d6235
    imul edx, edx, 0x21                          # 004d6238
    mov eax, dword ptr [ebp - local_4]           # 004d623b
    lea ecx, [eax + edx + field_95aa]            # 004d623e
    push ecx                                     # 004d6245
    mov edx, dword ptr [ebp - local_4]           # 004d6246
    mov eax, dword ptr [edx + field_98a8]        # 004d6249
    mov ecx, dword ptr [ebp - local_4]           # 004d624f
    mov edx, dword ptr [ecx + 4*eax + field_9586] # 004d6252
    push edx                                     # 004d6259
    mov eax, dword ptr [ebp - local_4]           # 004d625a
    mov ecx, dword ptr [eax + field_98a8]        # 004d625d
    add ecx, 0x1                                 # 004d6263
    push ecx                                     # 004d6266
    mov ecx, dword ptr [ebp - local_4]           # 004d6267
    call FUN_004d65e9                            # 004d626a
    jmp.d8 L_004d6288                            # 004d626f
L_004d6271:
    # block 0x004d6271: entered by jge at 0x004d61bd, 4 instruction(s), falls into the block at 0x004d6288
    mov edx, dword ptr [ebp - local_4]           # 004d6271
    mov eax, dword ptr [edx + field_98a8]        # 004d6274
    mov ecx, dword ptr [ebp - local_4]           # 004d627a
    mov dword ptr [ecx + 4*eax + field_9586], 0x0 # 004d627d
L_004d6288:
    # block 0x004d6288: entered by jmp at 0x004d626f, 31 instruction(s), ends with backward jump to 0x004d617d
    mov edx, dword ptr [ebp - local_4]           # 004d6288
    mov eax, dword ptr [edx + field_98a8]        # 004d628b
    add eax, 0x1                                 # 004d6291
    shl eax, 0x4                                 # 004d6294
    mov ecx, dword ptr [ebp - local_4]           # 004d6297
    mov dword ptr [ecx + eax + field_9758], 0x0  # 004d629a
    mov edx, dword ptr [ebp - local_4]           # 004d62a5
    mov eax, dword ptr [edx + field_98a8]        # 004d62a8
    add eax, 0x1                                 # 004d62ae
    shl eax, 0x4                                 # 004d62b1
    mov ecx, dword ptr [ebp - local_4]           # 004d62b4
    mov dword ptr [ecx + eax + field_9754], 0x0  # 004d62b7
    mov edx, dword ptr [ebp - local_4]           # 004d62c2
    mov eax, dword ptr [edx + field_9522]        # 004d62c5
    sub eax, 0x1                                 # 004d62cb
    mov ecx, dword ptr [ebp - local_4]           # 004d62ce
    mov edx, dword ptr [ecx + field_98a8]        # 004d62d1
    add edx, 0x1                                 # 004d62d7
    shl edx, 0x4                                 # 004d62da
    mov ecx, dword ptr [ebp - local_4]           # 004d62dd
    mov dword ptr [ecx + edx + field_975c], eax  # 004d62e0
    mov edx, dword ptr [ebp - local_4]           # 004d62e7
    mov eax, dword ptr [edx + field_9526]        # 004d62ea
    sub eax, 0x1                                 # 004d62f0
    mov ecx, dword ptr [ebp - local_4]           # 004d62f3
    mov edx, dword ptr [ecx + field_98a8]        # 004d62f6
    add edx, 0x1                                 # 004d62fc
    shl edx, 0x4                                 # 004d62ff
    mov ecx, dword ptr [ebp - local_4]           # 004d6302
    mov dword ptr [ecx + edx + field_9760], eax  # 004d6305
    jmp.d32 L_004d617d                           # 004d630c
L_004d6311:
    # block 0x004d6311: entered by jge at 0x004d619c, 1 instruction(s), ends with forward jump to 0x004d6564
    jmp.d32 L_004d6564                           # 004d6311
L_004d6316:
    # block 0x004d6316: entered by jne at 0x004d5fa4, 19 instruction(s), ends with jge to 0x004d6376 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d6316
    mov eax, dword ptr [ebp - local_4]           # 004d6319
    mov ecx, dword ptr [eax + field_94da]        # 004d631c
    mov dword ptr [edx + field_950e], ecx        # 004d6322
    mov edx, dword ptr [ebp - local_4]           # 004d6328
    mov eax, dword ptr [edx + field_955a]        # 004d632b
    sub eax, 0x1                                 # 004d6331
    imul eax, eax, 0x9                           # 004d6334
    add eax, 0x8                                 # 004d6337
    mov ecx, dword ptr [ebp - local_4]           # 004d633a
    mov dword ptr [ecx + field_98a4], eax        # 004d633d
    mov edx, dword ptr [ebp - local_4]           # 004d6343
    mov dword ptr [edx + field_9572], 0x1        # 004d6346
    mov eax, dword ptr [ebp - local_4]           # 004d6350
    mov ecx, dword ptr [eax + field_98a4]        # 004d6353
    add ecx, 0x9                                 # 004d6359
    mov edx, dword ptr [ebp - local_4]           # 004d635c
    cmp ecx, dword ptr [edx + field_989c]        # 004d635f
    jge.d8 L_004d6376                            # 004d6365
    # block 0x004d6367: entered by fall-through of jge at 0x004d6365, 3 instruction(s), ends with forward jump to 0x004d6383
    mov eax, dword ptr [ebp - local_4]           # 004d6367
    mov dword ptr [eax + field_9576], 0x1        # 004d636a
    jmp.d8 L_004d6383                            # 004d6374
L_004d6376:
    # block 0x004d6376: entered by jge at 0x004d6365, 2 instruction(s), falls into the block at 0x004d6383
    mov ecx, dword ptr [ebp - local_4]           # 004d6376
    mov dword ptr [ecx + field_9576], 0x0        # 004d6379
L_004d6383:
    # block 0x004d6383: entered by jmp at 0x004d6374, 20 instruction(s), calls FUN_004d65e9, ends with forward jump to 0x004d63f8
    mov edx, dword ptr [ebp - local_4]           # 004d6383
    mov dword ptr [edx + field_957a], 0x4        # 004d6386
    mov eax, dword ptr [ebp - local_4]           # 004d6390
    mov dword ptr [eax + field_957e], 0x1        # 004d6393
    mov ecx, dword ptr [ebp - local_4]           # 004d639d
    mov dword ptr [ecx + field_956e], 0x0        # 004d63a0
    mov edx, dword ptr [ebp - local_4]           # 004d63aa
    mov dword ptr [edx + field_95a6], 0x0        # 004d63ad
    mov eax, dword ptr [ebp - local_4]           # 004d63b7
    add eax, 0x96d3                              # 004d63ba
    push eax                                     # 004d63bf
    mov ecx, dword ptr [ebp - local_4]           # 004d63c0
    mov edx, dword ptr [ecx + field_95a6]        # 004d63c3
    push edx                                     # 004d63c9
    push 0x9                                     # 004d63ca
    mov ecx, dword ptr [ebp - local_4]           # 004d63cc
    call FUN_004d65e9                            # 004d63cf
    mov eax, dword ptr [ebp - local_4]           # 004d63d4
    mov dword ptr [eax + field_98a8], 0x0        # 004d63d7
    jmp.d8 L_004d63f8                            # 004d63e1
L_004d63e3:
    # block 0x004d63e3: entered by jmp at 0x004d655f, 5 instruction(s), falls into the block at 0x004d63f8
    mov ecx, dword ptr [ebp - local_4]           # 004d63e3
    mov edx, dword ptr [ecx + field_98a8]        # 004d63e6
    add edx, 0x1                                 # 004d63ec
    mov eax, dword ptr [ebp - local_4]           # 004d63ef
    mov dword ptr [eax + field_98a8], edx        # 004d63f2
L_004d63f8:
    # block 0x004d63f8: entered by jmp at 0x004d63e1, 3 instruction(s), ends with jge to 0x004d6564 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d63f8
    cmp dword ptr [ecx + field_98a8], 0x9        # 004d63fb
    jge.d32 L_004d6564                           # 004d6402
    # block 0x004d6408: entered by fall-through of jge at 0x004d6402, 7 instruction(s), ends with jge to 0x004d64d0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d6408
    mov eax, dword ptr [edx + field_98a8]        # 004d640b
    mov ecx, dword ptr [ebp - local_4]           # 004d6411
    add eax, dword ptr [ecx + field_98a4]        # 004d6414
    mov edx, dword ptr [ebp - local_4]           # 004d641a
    cmp eax, dword ptr [edx + field_989c]        # 004d641d
    jge.d32 L_004d64d0                           # 004d6423
    # block 0x004d6429: entered by fall-through of jge at 0x004d6423, 46 instruction(s), calls FUN_004d65e9, ends with forward jump to 0x004d64e7
    mov eax, dword ptr [ebp - local_4]           # 004d6429
    mov ecx, dword ptr [eax + field_98a8]        # 004d642c
    mov edx, dword ptr [ebp - local_4]           # 004d6432
    mov dword ptr [edx + 4*ecx + field_9582], 0x1 # 004d6435
    mov eax, dword ptr [ebp - local_4]           # 004d6440
    mov ecx, dword ptr [eax + field_98a8]        # 004d6443
    mov edx, dword ptr [ebp - local_4]           # 004d6449
    add ecx, dword ptr [edx + field_98a4]        # 004d644c
    mov eax, dword ptr [ebp - local_4]           # 004d6452
    mov edi, dword ptr [eax + 4*ecx + field_9810] # 004d6455
    mov ecx, dword ptr [ebp - local_4]           # 004d645c
    mov edx, dword ptr [ecx + field_98a8]        # 004d645f
    imul edx, edx, 0x21                          # 004d6465
    mov eax, dword ptr [ebp - local_4]           # 004d6468
    lea ecx, [eax + edx + field_95aa]            # 004d646b
    {load} mov edx, ecx                          # 004d6472
    or ecx, -0x1                                 # 004d6474
    {load} xor eax, eax                          # 004d6477
    repne scasb al, byte ptr es:[edi]            # 004d6479
    not ecx                                      # 004d647b
    {load} sub edi, ecx                          # 004d647d
    {load} mov esi, edi                          # 004d647f
    {load} mov eax, ecx                          # 004d6481
    {load} mov edi, edx                          # 004d6483
    shr ecx, 0x2                                 # 004d6485
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d6488
    {load} mov ecx, eax                          # 004d648a
    and ecx, 0x3                                 # 004d648c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d648f
    mov ecx, dword ptr [ebp - local_4]           # 004d6491
    mov edx, dword ptr [ecx + field_98a8]        # 004d6494
    imul edx, edx, 0x21                          # 004d649a
    mov eax, dword ptr [ebp - local_4]           # 004d649d
    lea ecx, [eax + edx + field_95aa]            # 004d64a0
    push ecx                                     # 004d64a7
    mov edx, dword ptr [ebp - local_4]           # 004d64a8
    mov eax, dword ptr [edx + field_98a8]        # 004d64ab
    mov ecx, dword ptr [ebp - local_4]           # 004d64b1
    mov edx, dword ptr [ecx + 4*eax + field_9582] # 004d64b4
    push edx                                     # 004d64bb
    mov eax, dword ptr [ebp - local_4]           # 004d64bc
    mov ecx, dword ptr [eax + field_98a8]        # 004d64bf
    push ecx                                     # 004d64c5
    mov ecx, dword ptr [ebp - local_4]           # 004d64c6
    call FUN_004d65e9                            # 004d64c9
    jmp.d8 L_004d64e7                            # 004d64ce
L_004d64d0:
    # block 0x004d64d0: entered by jge at 0x004d6423, 4 instruction(s), falls into the block at 0x004d64e7
    mov edx, dword ptr [ebp - local_4]           # 004d64d0
    mov eax, dword ptr [edx + field_98a8]        # 004d64d3
    mov ecx, dword ptr [ebp - local_4]           # 004d64d9
    mov dword ptr [ecx + 4*eax + field_9582], 0x0 # 004d64dc
L_004d64e7:
    # block 0x004d64e7: entered by jmp at 0x004d64ce, 27 instruction(s), ends with backward jump to 0x004d63e3
    mov edx, dword ptr [ebp - local_4]           # 004d64e7
    mov eax, dword ptr [edx + field_98a8]        # 004d64ea
    shl eax, 0x4                                 # 004d64f0
    mov ecx, dword ptr [ebp - local_4]           # 004d64f3
    mov dword ptr [ecx + eax + field_9758], 0x0  # 004d64f6
    mov edx, dword ptr [ebp - local_4]           # 004d6501
    mov eax, dword ptr [edx + field_98a8]        # 004d6504
    shl eax, 0x4                                 # 004d650a
    mov ecx, dword ptr [ebp - local_4]           # 004d650d
    mov dword ptr [ecx + eax + field_9754], 0x0  # 004d6510
    mov edx, dword ptr [ebp - local_4]           # 004d651b
    mov eax, dword ptr [edx + field_9522]        # 004d651e
    sub eax, 0x1                                 # 004d6524
    mov ecx, dword ptr [ebp - local_4]           # 004d6527
    mov edx, dword ptr [ecx + field_98a8]        # 004d652a
    shl edx, 0x4                                 # 004d6530
    mov ecx, dword ptr [ebp - local_4]           # 004d6533
    mov dword ptr [ecx + edx + field_975c], eax  # 004d6536
    mov edx, dword ptr [ebp - local_4]           # 004d653d
    mov eax, dword ptr [edx + field_9526]        # 004d6540
    sub eax, 0x1                                 # 004d6546
    mov ecx, dword ptr [ebp - local_4]           # 004d6549
    mov edx, dword ptr [ecx + field_98a8]        # 004d654c
    shl edx, 0x4                                 # 004d6552
    mov ecx, dword ptr [ebp - local_4]           # 004d6555
    mov dword ptr [ecx + edx + field_9760], eax  # 004d6558
    jmp.d32 L_004d63e3                           # 004d655f
L_004d6564:
    # block 0x004d6564: entered by jmp at 0x004d6311; jge at 0x004d6402, 34 instruction(s), ends with ret
    mov edx, dword ptr [ebp - local_4]           # 004d6564
    mov eax, dword ptr [edx + field_950e]        # 004d6567
    add eax, 0x35                                # 004d656d
    mov ecx, dword ptr [ebp - local_4]           # 004d6570
    add ecx, 0x9704                              # 004d6573
    mov edx, dword ptr [eax]                     # 004d6579
    mov dword ptr [ecx], edx                     # 004d657b
    mov edx, dword ptr [eax + field_4]           # 004d657d
    mov dword ptr [ecx + field_4], edx           # 004d6580
    mov edx, dword ptr [eax + field_8]           # 004d6583
    mov dword ptr [ecx + field_8], edx           # 004d6586
    mov eax, dword ptr [eax + field_c]           # 004d6589
    mov dword ptr [ecx + field_c], eax           # 004d658c
    mov ecx, dword ptr [ebp - local_4]           # 004d658f
    mov dword ptr [ecx + field_9714], 0x0        # 004d6592
    mov edx, dword ptr [ebp - local_4]           # 004d659c
    mov dword ptr [edx + field_9718], 0x0        # 004d659f
    movsx eax, word ptr [0x63988b]               # 004d65a9
    mov ecx, dword ptr [ebp - local_4]           # 004d65b0
    mov edx, dword ptr [ecx + field_9714]        # 004d65b3
    lea eax, [edx + eax - field_minus_1]         # 004d65b9
    mov ecx, dword ptr [ebp - local_4]           # 004d65bd
    mov dword ptr [ecx + field_971c], eax        # 004d65c0
    movsx edx, word ptr [0x63988d]               # 004d65c6
    mov eax, dword ptr [ebp - local_4]           # 004d65cd
    mov ecx, dword ptr [eax + field_9718]        # 004d65d0
    lea edx, [ecx + edx - field_minus_1]         # 004d65d6
    mov eax, dword ptr [ebp - local_4]           # 004d65da
    mov dword ptr [eax + field_9720], edx        # 004d65dd
    pop edi                                      # 004d65e3
    pop esi                                      # 004d65e4
    {load} mov esp, ebp                          # 004d65e5
    pop ebp                                      # 004d65e7
    ret                                          # 004d65e8

