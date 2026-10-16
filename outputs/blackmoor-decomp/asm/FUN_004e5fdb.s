# FUN_004e5fdb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e5fdb
# extent:       0x004e5fdb-0x004e652c (1361 code bytes)
# span:         0x004e5fdb-0x004e6548 (code 1361, tables 28, padding 0)
# sha256:       bf5aff5c7d927a07cbe5a98f11f4cabe1efa19e4df9d910bc36e4113a9e0bb01
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e5fdb
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_218, local_21c, local_220
# fields:       [eax + n] field_1325, field_1329, field_1482, field_4d7d, field_4d89, field_53bd, field_53bf, field_65d6; [ecx + n] field_1, field_20, field_6ce, field_131d, field_1321, field_4d7d, field_4d89; [edx + n] field_6ce, field_4d89, field_53bd
# callees:      calls FUN_004d2c20, FUN_00423259, FUN_0050d8e0, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 365 instruction(s), 16 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_218, 0x218  # offset -0x218
.equ local_21c, 0x21c  # offset -0x21c
.equ local_220, 0x220  # offset -0x220
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_20, 0x20  # offset +0x20
.equ field_6ce, 0x6ce  # offset +0x6ce
.equ field_131d, 0x131d  # offset +0x131d
.equ field_1321, 0x1321  # offset +0x1321
.equ field_1325, 0x1325  # offset +0x1325
.equ field_1329, 0x1329  # offset +0x1329
.equ field_1482, 0x1482  # offset +0x1482
.equ field_4d7d, 0x4d7d  # offset +0x4d7d
.equ field_4d89, 0x4d89  # offset +0x4d89
.equ field_53bd, 0x53bd  # offset +0x53bd
.equ field_53bf, 0x53bf  # offset +0x53bf
.equ field_65d6, 0x65d6  # offset +0x65d6

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)

.org 0x004e5fdb - 0x401000
.globl FUN_004e5fdb
FUN_004e5fdb:
    # block 0x004e5fdb: entry, 13 instruction(s), ends with ja to 0x004e6524 (forward)
    push ebp                                     # 004e5fdb
    {load} mov ebp, esp                          # 004e5fdc
    sub esp, 0x220                               # 004e5fde
    push esi                                     # 004e5fe4
    push edi                                     # 004e5fe5
    mov dword ptr [ebp - local_21c], ecx         # 004e5fe6
    movsx eax, word ptr [ebp + arg_8]            # 004e5fec
    mov dword ptr [ebp - local_220], eax         # 004e5ff0
    mov ecx, dword ptr [ebp - local_220]         # 004e5ff6
    sub ecx, 0x9                                 # 004e5ffc
    mov dword ptr [ebp - local_220], ecx         # 004e5fff
    cmp dword ptr [ebp - local_220], 0x6         # 004e6005
    ja.d32 L_004e6524                            # 004e600c
    # block 0x004e6012: entered by fall-through of ja at 0x004e600c, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e652c]
    mov edx, dword ptr [ebp - local_220]         # 004e6012
    jmp dword ptr [4*edx + SWTAB_004e652c_VA]    # 004e6018
L_004e601f:
    # block 0x004e601f: entered by switch case, 3 instruction(s), ends with forward jump to 0x004e6035
    mov ax, word ptr [ebp + arg_c]               # 004e601f
    mov word ptr [ebp - local_1c], ax            # 004e6023
    jmp.d8 L_004e6035                            # 004e6027
L_004e6029:
    # block 0x004e6029: entered by jmp at 0x004e60df, 3 instruction(s), falls into the block at 0x004e6035
    mov cx, word ptr [ebp - local_1c]            # 004e6029
    add cx, 0x1                                  # 004e602d
    mov word ptr [ebp - local_1c], cx            # 004e6031
L_004e6035:
    # block 0x004e6035: entered by jmp at 0x004e6027, 7 instruction(s), ends with jge to 0x004e60e4 (forward)
    movsx edx, word ptr [ebp - local_1c]         # 004e6035
    mov eax, dword ptr [ebp - local_21c]         # 004e6039
    movsx ecx, word ptr [eax + field_53bd]       # 004e603f
    movsx eax, word ptr [ebp + arg_c]            # 004e6046
    {load} add ecx, eax                          # 004e604a
    {load} cmp edx, ecx                          # 004e604c
    jge.d32 L_004e60e4                           # 004e604e
    # block 0x004e6054: entered by fall-through of jge at 0x004e604e, 36 instruction(s), calls FUN_004d2c20, ends with backward jump to 0x004e6029
    push 0x0                                     # 004e6054
    mov ecx, dword ptr [0x5cf665]                # 004e6056
    push ecx                                     # 004e605c
    movsx edx, word ptr [ebp + arg_10]           # 004e605d
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004e6061
    push eax                                     # 004e6068
    movsx ecx, word ptr [ebp - local_1c]         # 004e6069
    movsx edx, word ptr [ebp + arg_c]            # 004e606d
    {load} sub ecx, edx                          # 004e6071
    shl ecx, 0x4                                 # 004e6073
    mov eax, dword ptr [ebp - local_21c]         # 004e6076
    mov cx, word ptr [eax + ecx + field_4d89]    # 004e607c
    push ecx                                     # 004e6084
    movsx edx, word ptr [ebp - local_1c]         # 004e6085
    movsx eax, word ptr [ebp + arg_c]            # 004e6089
    {load} sub edx, eax                          # 004e608d
    shl edx, 0x4                                 # 004e608f
    mov ecx, dword ptr [ebp - local_21c]         # 004e6092
    mov dx, word ptr [ecx + edx + field_4d7d]    # 004e6098
    push edx                                     # 004e60a0
    movsx eax, word ptr [ebp + arg_10]           # 004e60a1
    imul eax, eax, 0x1d0                         # 004e60a5
    add eax, 0x5adb3a                            # 004e60ab
    push eax                                     # 004e60b0
    movsx ecx, word ptr [ebp + arg_10]           # 004e60b1
    imul ecx, ecx, 0x7f3                         # 004e60b5
    add ecx, 0x5a4c24                            # 004e60bb
    push ecx                                     # 004e60c1
    movsx edx, word ptr [ebp - local_1c]         # 004e60c2
    imul edx, edx, 0x29                          # 004e60c6
    mov eax, dword ptr [ebp - local_21c]         # 004e60c9
    lea ecx, [eax + edx + field_1482]            # 004e60cf
    push ecx                                     # 004e60d6
    call FUN_004d2c20                            # 004e60d7
    add esp, 0x20                                # 004e60dc
    jmp.d32 L_004e6029                           # 004e60df
L_004e60e4:
    # block 0x004e60e4: entered by jge at 0x004e604e, 1 instruction(s), ends with forward jump to 0x004e6524
    jmp.d32 L_004e6524                           # 004e60e4
L_004e60e9:
    # block 0x004e60e9: entered by switch case, 3 instruction(s), ends with forward jump to 0x004e60ff
    mov dx, word ptr [ebp + arg_c]               # 004e60e9
    mov word ptr [ebp - local_1c], dx            # 004e60ed
    jmp.d8 L_004e60ff                            # 004e60f1
L_004e60f3:
    # block 0x004e60f3: entered by jmp at 0x004e6267, 3 instruction(s), falls into the block at 0x004e60ff
    mov ax, word ptr [ebp - local_1c]            # 004e60f3
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e60f7
    mov word ptr [ebp - local_1c], ax            # 004e60fb
L_004e60ff:
    # block 0x004e60ff: entered by jmp at 0x004e60f1, 7 instruction(s), ends with jge to 0x004e626c (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 004e60ff
    mov edx, dword ptr [ebp - local_21c]         # 004e6103
    movsx eax, word ptr [edx + field_53bd]       # 004e6109
    movsx edx, word ptr [ebp + arg_c]            # 004e6110
    {load} add eax, edx                          # 004e6114
    {load} cmp ecx, eax                          # 004e6116
    jge.d32 L_004e626c                           # 004e6118
    # block 0x004e611e: entered by fall-through of jge at 0x004e6118, 9 instruction(s), calls FUN_00423259, ends with je to 0x004e6267 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 004e611e
    imul eax, eax, 0x29                          # 004e6122
    add eax, 0x5a434c                            # 004e6125
    push eax                                     # 004e612a
    mov ecx, 0x619a6b                            # 004e612b
    call FUN_00423259                            # 004e6130
    mov dword ptr [ebp - local_20], eax          # 004e6135
    cmp dword ptr [ebp - local_20], 0x0          # 004e6138
    je.d32 L_004e6267                            # 004e613c
    # block 0x004e6142: entered by fall-through of je at 0x004e613c, 8 instruction(s), ends with ja to 0x004e6267 (forward)
    mov edi, dword ptr [ebp - local_20]          # 004e6142
    or ecx, -0x1                                 # 004e6145
    {load} xor eax, eax                          # 004e6148
    repne scasb al, byte ptr es:[edi]            # 004e614a
    not ecx                                      # 004e614c
    add ecx, -0x1                                # 004e614e
    cmp ecx, 0x9c40                              # 004e6151
    ja.d32 L_004e6267                            # 004e6157
    # block 0x004e615d: entered by fall-through of ja at 0x004e6157, 8 instruction(s), ends with jbe to 0x004e6178 (forward)
    mov edi, dword ptr [ebp - local_20]          # 004e615d
    or ecx, -0x1                                 # 004e6160
    {load} xor eax, eax                          # 004e6163
    repne scasb al, byte ptr es:[edi]            # 004e6165
    not ecx                                      # 004e6167
    add ecx, -0x1                                # 004e6169
    cmp ecx, 0x20                                # 004e616c
    jbe.d8 L_004e6178                            # 004e616f
    # block 0x004e6171: entered by fall-through of jbe at 0x004e616f, 2 instruction(s), falls into the block at 0x004e6178
    mov ecx, dword ptr [ebp - local_20]          # 004e6171
    mov byte ptr [ecx + field_20], 0x0           # 004e6174
L_004e6178:
    # block 0x004e6178: entered by jbe at 0x004e616f, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x004e61c4 (forward)
    push 0x55c1ac                                # 004e6178
    mov edx, dword ptr [ebp - local_20]          # 004e617d
    push edx                                     # 004e6180
    call FUN_0050d8e0                            # 004e6181
    add esp, 0x8                                 # 004e6186
    test eax, eax                                # 004e6189
    je.d8 L_004e61c4                             # 004e618b
    # block 0x004e618d: entered by fall-through of je at 0x004e618b, 19 instruction(s), ends with forward jump to 0x004e61ea
    mov ecx, 0x7d                                # 004e618d
    {load} xor eax, eax                          # 004e6192
    lea edi, [ebp - local_218]                   # 004e6194
    rep stosd dword ptr es:[edi], eax            # 004e619a
    mov edi, dword ptr [ebp - local_20]          # 004e619c
    or ecx, -0x1                                 # 004e619f
    {load} xor eax, eax                          # 004e61a2
    repne scasb al, byte ptr es:[edi]            # 004e61a4
    not ecx                                      # 004e61a6
    add ecx, -0x4                                # 004e61a8
    mov esi, dword ptr [ebp - local_20]          # 004e61ab
    lea edi, [ebp - local_218]                   # 004e61ae
    {load} mov eax, ecx                          # 004e61b4
    shr ecx, 0x2                                 # 004e61b6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e61b9
    {load} mov ecx, eax                          # 004e61bb
    and ecx, 0x3                                 # 004e61bd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e61c0
    jmp.d8 L_004e61ea                            # 004e61c2
L_004e61c4:
    # block 0x004e61c4: entered by je at 0x004e618b, 15 instruction(s), falls into the block at 0x004e61ea
    mov edi, dword ptr [ebp - local_20]          # 004e61c4
    lea edx, [ebp - local_218]                   # 004e61c7
    or ecx, -0x1                                 # 004e61cd
    {load} xor eax, eax                          # 004e61d0
    repne scasb al, byte ptr es:[edi]            # 004e61d2
    not ecx                                      # 004e61d4
    {load} sub edi, ecx                          # 004e61d6
    {load} mov esi, edi                          # 004e61d8
    {load} mov eax, ecx                          # 004e61da
    {load} mov edi, edx                          # 004e61dc
    shr ecx, 0x2                                 # 004e61de
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e61e1
    {load} mov ecx, eax                          # 004e61e3
    and ecx, 0x3                                 # 004e61e5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e61e8
L_004e61ea:
    # block 0x004e61ea: entered by jmp at 0x004e61c2, 32 instruction(s), calls FUN_004d2c20, falls into the block at 0x004e6267
    push 0x0                                     # 004e61ea
    mov ecx, dword ptr [0x5cf665]                # 004e61ec
    push ecx                                     # 004e61f2
    movsx edx, word ptr [ebp + arg_10]           # 004e61f3
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004e61f7
    push eax                                     # 004e61fe
    movsx ecx, word ptr [ebp - local_1c]         # 004e61ff
    movsx edx, word ptr [ebp + arg_c]            # 004e6203
    {load} sub ecx, edx                          # 004e6207
    shl ecx, 0x4                                 # 004e6209
    mov eax, dword ptr [ebp - local_21c]         # 004e620c
    mov cx, word ptr [eax + ecx + field_4d89]    # 004e6212
    push ecx                                     # 004e621a
    movsx edx, word ptr [ebp - local_1c]         # 004e621b
    movsx eax, word ptr [ebp + arg_c]            # 004e621f
    {load} sub edx, eax                          # 004e6223
    shl edx, 0x4                                 # 004e6225
    mov ecx, dword ptr [ebp - local_21c]         # 004e6228
    mov dx, word ptr [ecx + edx + field_4d7d]    # 004e622e
    push edx                                     # 004e6236
    movsx eax, word ptr [ebp + arg_10]           # 004e6237
    imul eax, eax, 0x1d0                         # 004e623b
    add eax, 0x5adb3a                            # 004e6241
    push eax                                     # 004e6246
    movsx ecx, word ptr [ebp + arg_10]           # 004e6247
    imul ecx, ecx, 0x7f3                         # 004e624b
    add ecx, 0x5a4c24                            # 004e6251
    push ecx                                     # 004e6257
    lea edx, [ebp - local_218]                   # 004e6258
    push edx                                     # 004e625e
    call FUN_004d2c20                            # 004e625f
    add esp, 0x20                                # 004e6264
L_004e6267:
    # block 0x004e6267: entered by je at 0x004e613c; ja at 0x004e6157, 1 instruction(s), ends with backward jump to 0x004e60f3
    jmp.d32 L_004e60f3                           # 004e6267
L_004e626c:
    # block 0x004e626c: entered by jge at 0x004e6118, 1 instruction(s), ends with forward jump to 0x004e6524
    jmp.d32 L_004e6524                           # 004e626c
L_004e6271:
    # block 0x004e6271: entered by switch case, 14 instruction(s), ends with forward jump to 0x004e62c5
    mov eax, dword ptr [ebp - local_21c]         # 004e6271
    mov ecx, dword ptr [ebp - local_21c]         # 004e6277
    mov edx, dword ptr [eax + field_1329]        # 004e627d
    sub edx, dword ptr [ecx + field_1321]        # 004e6283
    mov word ptr [ebp - local_8], dx             # 004e6289
    mov eax, dword ptr [ebp - local_21c]         # 004e628d
    mov ecx, dword ptr [ebp - local_21c]         # 004e6293
    mov edx, dword ptr [eax + field_1325]        # 004e6299
    sub edx, dword ptr [ecx + field_131d]        # 004e629f
    mov word ptr [ebp - local_4], dx             # 004e62a5
    mov word ptr [ebp - local_24], 0x0           # 004e62a9
    mov ax, word ptr [ebp + arg_c]               # 004e62af
    mov word ptr [ebp - local_1c], ax            # 004e62b3
    jmp.d8 L_004e62c5                            # 004e62b7
L_004e62b9:
    # block 0x004e62b9: entered by jmp at 0x004e651f, 3 instruction(s), falls into the block at 0x004e62c5
    mov cx, word ptr [ebp - local_1c]            # 004e62b9
    add cx, 0x1                                  # 004e62bd
    mov word ptr [ebp - local_1c], cx            # 004e62c1
L_004e62c5:
    # block 0x004e62c5: entered by jmp at 0x004e62b7, 10 instruction(s), ends with jge to 0x004e6524 (forward)
    movsx edx, word ptr [ebp - local_1c]         # 004e62c5
    mov eax, dword ptr [ebp - local_21c]         # 004e62c9
    movsx ecx, word ptr [eax + field_53bd]       # 004e62cf
    movsx eax, word ptr [ebp + arg_c]            # 004e62d6
    {load} add ecx, eax                          # 004e62da
    mov eax, dword ptr [ebp - local_21c]         # 004e62dc
    movsx eax, word ptr [eax + field_65d6]       # 004e62e2
    {load} add ecx, eax                          # 004e62e9
    {load} cmp edx, ecx                          # 004e62eb
    jge.d32 L_004e6524                           # 004e62ed
    # block 0x004e62f3: entered by fall-through of jge at 0x004e62ed, 2 instruction(s), ends with je to 0x004e631d (forward)
    cmp dword ptr [0x5a1e58], 0x0                # 004e62f3
    je.d8 L_004e631d                             # 004e62fa
    # block 0x004e62fc: entered by fall-through of je at 0x004e62fa, 2 instruction(s), ends with je to 0x004e651f (forward)
    cmp dword ptr [0x5a1e58], 0x0                # 004e62fc
    je.d32 L_004e651f                            # 004e6303
    # block 0x004e6309: entered by fall-through of je at 0x004e6303, 4 instruction(s), ends with je to 0x004e651f (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 004e6309
    imul ecx, ecx, 0x4a                          # 004e630d
    cmp dword ptr [ecx + 0x5a26aa], 0x0          # 004e6310
    je.d32 L_004e651f                            # 004e6317
L_004e631d:
    # block 0x004e631d: entered by je at 0x004e62fa; fall-through of je at 0x004e6317, 9 instruction(s), calls FUN_00423259, ends with je to 0x004e651f (forward)
    movsx edx, word ptr [ebp - local_1c]         # 004e631d
    imul edx, edx, 0x4a                          # 004e6321
    add edx, 0x5a2664                            # 004e6324
    push edx                                     # 004e632a
    mov ecx, 0x619a6b                            # 004e632b
    call FUN_00423259                            # 004e6330
    mov dword ptr [ebp - local_20], eax          # 004e6335
    cmp dword ptr [ebp - local_20], 0x0          # 004e6338
    je.d32 L_004e651f                            # 004e633c
    # block 0x004e6342: entered by fall-through of je at 0x004e633c, 8 instruction(s), ends with ja to 0x004e651f (forward)
    mov edi, dword ptr [ebp - local_20]          # 004e6342
    or ecx, -0x1                                 # 004e6345
    {load} xor eax, eax                          # 004e6348
    repne scasb al, byte ptr es:[edi]            # 004e634a
    not ecx                                      # 004e634c
    add ecx, -0x1                                # 004e634e
    cmp ecx, 0x9c40                              # 004e6351
    ja.d32 L_004e651f                            # 004e6357
    # block 0x004e635d: entered by fall-through of ja at 0x004e6357, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x004e63a9 (forward)
    push 0x55c1b0                                # 004e635d
    mov eax, dword ptr [ebp - local_20]          # 004e6362
    push eax                                     # 004e6365
    call FUN_0050d8e0                            # 004e6366
    add esp, 0x8                                 # 004e636b
    test eax, eax                                # 004e636e
    je.d8 L_004e63a9                             # 004e6370
    # block 0x004e6372: entered by fall-through of je at 0x004e6370, 19 instruction(s), ends with forward jump to 0x004e63cf
    mov ecx, 0x7d                                # 004e6372
    {load} xor eax, eax                          # 004e6377
    lea edi, [ebp - local_218]                   # 004e6379
    rep stosd dword ptr es:[edi], eax            # 004e637f
    mov edi, dword ptr [ebp - local_20]          # 004e6381
    or ecx, -0x1                                 # 004e6384
    {load} xor eax, eax                          # 004e6387
    repne scasb al, byte ptr es:[edi]            # 004e6389
    not ecx                                      # 004e638b
    add ecx, -0x4                                # 004e638d
    mov esi, dword ptr [ebp - local_20]          # 004e6390
    lea edi, [ebp - local_218]                   # 004e6393
    {load} mov edx, ecx                          # 004e6399
    shr ecx, 0x2                                 # 004e639b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e639e
    {load} mov ecx, edx                          # 004e63a0
    and ecx, 0x3                                 # 004e63a2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e63a5
    jmp.d8 L_004e63cf                            # 004e63a7
L_004e63a9:
    # block 0x004e63a9: entered by je at 0x004e6370, 15 instruction(s), falls into the block at 0x004e63cf
    mov edi, dword ptr [ebp - local_20]          # 004e63a9
    lea edx, [ebp - local_218]                   # 004e63ac
    or ecx, -0x1                                 # 004e63b2
    {load} xor eax, eax                          # 004e63b5
    repne scasb al, byte ptr es:[edi]            # 004e63b7
    not ecx                                      # 004e63b9
    {load} sub edi, ecx                          # 004e63bb
    {load} mov esi, edi                          # 004e63bd
    {load} mov eax, ecx                          # 004e63bf
    {load} mov edi, edx                          # 004e63c1
    shr ecx, 0x2                                 # 004e63c3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e63c6
    {load} mov ecx, eax                          # 004e63c8
    and ecx, 0x3                                 # 004e63ca
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e63cd
L_004e63cf:
    # block 0x004e63cf: entered by jmp at 0x004e63a7, 51 instruction(s), calls FUN_004d2c20, ends with jne to 0x004e64e0 (forward)
    push 0x0                                     # 004e63cf
    mov ecx, dword ptr [0x5cf665]                # 004e63d1
    push ecx                                     # 004e63d7
    movsx edx, word ptr [ebp + arg_10]           # 004e63d8
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004e63dc
    push eax                                     # 004e63e3
    movsx ecx, word ptr [ebp - local_24]         # 004e63e4
    shl ecx, 0x4                                 # 004e63e8
    mov edx, dword ptr [ebp - local_21c]         # 004e63eb
    mov ax, word ptr [edx + ecx + field_4d89]    # 004e63f1
    push eax                                     # 004e63f9
    movsx ecx, word ptr [ebp - local_24]         # 004e63fa
    shl ecx, 0x4                                 # 004e63fe
    movsx edx, word ptr [ebp - local_4]          # 004e6401
    mov eax, dword ptr [ebp - local_21c]         # 004e6405
    mov ecx, dword ptr [eax + ecx + field_4d7d]  # 004e640b
    lea edx, [ecx + edx + field_1]               # 004e6412
    push edx                                     # 004e6416
    movsx eax, word ptr [ebp + arg_10]           # 004e6417
    imul eax, eax, 0x1d0                         # 004e641b
    add eax, 0x5adb3a                            # 004e6421
    push eax                                     # 004e6426
    movsx ecx, word ptr [ebp + arg_10]           # 004e6427
    imul ecx, ecx, 0x7f3                         # 004e642b
    add ecx, 0x5a4c24                            # 004e6431
    push ecx                                     # 004e6437
    lea edx, [ebp - local_218]                   # 004e6438
    push edx                                     # 004e643e
    call FUN_004d2c20                            # 004e643f
    add esp, 0x20                                # 004e6444
    movsx eax, word ptr [ebp - local_24]         # 004e6447
    shl eax, 0x4                                 # 004e644b
    mov ecx, dword ptr [ebp - local_21c]         # 004e644e
    mov edx, dword ptr [ecx + eax + field_4d89]  # 004e6454
    mov dword ptr [ebp - local_c], edx           # 004e645b
    movsx eax, word ptr [ebp - local_8]          # 004e645e
    mov ecx, dword ptr [ebp - local_c]           # 004e6462
    {load} sub ecx, eax                          # 004e6465
    mov dword ptr [ebp - local_14], ecx          # 004e6467
    movsx edx, word ptr [ebp - local_24]         # 004e646a
    shl edx, 0x4                                 # 004e646e
    mov eax, dword ptr [ebp - local_21c]         # 004e6471
    mov ecx, dword ptr [eax + edx + field_4d7d]  # 004e6477
    mov dword ptr [ebp - local_18], ecx          # 004e647e
    movsx edx, word ptr [ebp - local_4]          # 004e6481
    mov eax, dword ptr [ebp - local_18]          # 004e6485
    {load} add eax, edx                          # 004e6488
    mov dword ptr [ebp - local_10], eax          # 004e648a
    movsx ecx, word ptr [ebp + arg_8]            # 004e648d
    cmp ecx, 0xf                                 # 004e6491
    jne.d8 L_004e64e0                            # 004e6494
    # block 0x004e6496: entered by fall-through of jne at 0x004e6494, 5 instruction(s), ends with jne to 0x004e64e0 (forward)
    movsx edx, word ptr [ebp - local_24]         # 004e6496
    mov eax, dword ptr [ebp - local_21c]         # 004e649a
    movsx ecx, word ptr [eax + field_53bf]       # 004e64a0
    {load} cmp edx, ecx                          # 004e64a7
    jne.d8 L_004e64e0                            # 004e64a9
    # block 0x004e64ab: entered by fall-through of jne at 0x004e64a9, 14 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e6513
    push 0x55c1b4                                # 004e64ab
    lea edx, [ebp - local_18]                    # 004e64b0
    push edx                                     # 004e64b3
    mov eax, dword ptr [ebp - local_21c]         # 004e64b4
    add eax, 0x132d                              # 004e64ba
    push eax                                     # 004e64bf
    mov ecx, dword ptr [0x5cf665]                # 004e64c0
    push ecx                                     # 004e64c6
    mov edx, dword ptr [ebp - local_21c]         # 004e64c7
    mov eax, dword ptr [edx + field_6ce]         # 004e64cd
    push eax                                     # 004e64d3
    mov ecx, 0x5cf659                            # 004e64d4
    call FUN_004c5377                            # 004e64d9
    jmp.d8 L_004e6513                            # 004e64de
L_004e64e0:
    # block 0x004e64e0: entered by jne at 0x004e6494; jne at 0x004e64a9, 13 instruction(s), calls FUN_004c5377, falls into the block at 0x004e6513
    push 0x55c1c0                                # 004e64e0
    lea ecx, [ebp - local_18]                    # 004e64e5
    push ecx                                     # 004e64e8
    mov edx, dword ptr [ebp - local_21c]         # 004e64e9
    add edx, 0x131d                              # 004e64ef
    push edx                                     # 004e64f5
    mov eax, dword ptr [0x5cf665]                # 004e64f6
    push eax                                     # 004e64fb
    mov ecx, dword ptr [ebp - local_21c]         # 004e64fc
    mov edx, dword ptr [ecx + field_6ce]         # 004e6502
    push edx                                     # 004e6508
    mov ecx, 0x5cf659                            # 004e6509
    call FUN_004c5377                            # 004e650e
L_004e6513:
    # block 0x004e6513: entered by jmp at 0x004e64de, 3 instruction(s), falls into the block at 0x004e651f
    mov ax, word ptr [ebp - local_24]            # 004e6513
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e6517
    mov word ptr [ebp - local_24], ax            # 004e651b
L_004e651f:
    # block 0x004e651f: entered by je at 0x004e6303; je at 0x004e6317; je at 0x004e633c; ja at 0x004e6357, 1 instruction(s), ends with backward jump to 0x004e62b9
    jmp.d32 L_004e62b9                           # 004e651f
L_004e6524:
    # block 0x004e6524: entered by ja at 0x004e600c; jmp at 0x004e60e4; jmp at 0x004e626c; jge at 0x004e62ed; switch case, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004e6524
    pop esi                                      # 004e6525
    {load} mov esp, ebp                          # 004e6526
    pop ebp                                      # 004e6528
    ret 0xc                                      # 004e6529

# --- data items (not part of the function) -------------------------
.org 0x004e652c - 0x401000
SWTAB_004e652c:  # 7 case address(es)
    .long L_004e601f - .text + 0x401000
    .long L_004e6524 - .text + 0x401000
    .long L_004e6524 - .text + 0x401000
    .long L_004e6524 - .text + 0x401000
    .long L_004e60e9 - .text + 0x401000
    .long L_004e6271 - .text + 0x401000
    .long L_004e6271 - .text + 0x401000
.set SWTAB_004e652c_VA, SWTAB_004e652c - .text + 0x401000

