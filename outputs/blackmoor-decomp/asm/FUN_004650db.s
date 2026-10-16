# FUN_004650db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004650db
# extent:       0x004650db-0x004657d7 (1788 code bytes)
# span:         0x004650db-0x004657d7 (code 1788, tables 0, padding 0)
# sha256:       5f03cb9b69059bf778dcdbb1bd00eaeadc07c57c6f28e8d6d562fdaf534e73ae
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004650db
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_1e, field_26, field_2a, field_8a, field_b8, field_c1, field_3d0, field_3d8 and 5 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_2a, field_2e, field_8a, field_8c, field_bc, field_bd and 11 more; [edx + n] field_4, field_8, field_c, field_10, field_1c, field_1e, field_32, field_36, field_38, field_8a, field_bd, field_d6 and 10 more
# callees:      calls FUN_004e8d96, FUN_004641bb, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_00464076
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 426 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_38, 0x38  # offset +0x38
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_bd, 0xbd  # offset +0xbd
.equ field_c1, 0xc1  # offset +0xc1
.equ field_d6, 0xd6  # offset +0xd6
.equ field_331, 0x331  # offset +0x331
.equ field_3c6, 0x3c6  # offset +0x3c6
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d0, 0x3d0  # offset +0x3d0
.equ field_3d2, 0x3d2  # offset +0x3d2
.equ field_3d4, 0x3d4  # offset +0x3d4
.equ field_3d8, 0x3d8  # offset +0x3d8
.equ field_3dc, 0x3dc  # offset +0x3dc
.equ field_3e0, 0x3e0  # offset +0x3e0
.equ field_3e2, 0x3e2  # offset +0x3e2
.equ field_3e4, 0x3e4  # offset +0x3e4
.equ field_406, 0x406  # offset +0x406
.equ field_416, 0x416  # offset +0x416
.equ field_418, 0x418  # offset +0x418
.equ field_41a, 0x41a  # offset +0x41a
.equ field_41c, 0x41c  # offset +0x41c
.equ field_41e, 0x41e  # offset +0x41e
.equ field_422, 0x422  # offset +0x422
.equ field_426, 0x426  # offset +0x426
.equ field_42a, 0x42a  # offset +0x42a
.equ field_42c, 0x42c  # offset +0x42c
.equ field_42e, 0x42e  # offset +0x42e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00464076, .text + (0x00464076 - 0x401000)
.set FUN_004641bb, .text + (0x004641bb - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004650db - 0x401000
.globl FUN_004650db
FUN_004650db:
    # block 0x004650db: entry, 16 instruction(s), ends with je to 0x0046512b (forward)
    push ebp                                     # 004650db
    {load} mov ebp, esp                          # 004650dc
    sub esp, 0x14                                # 004650de
    push esi                                     # 004650e1
    push edi                                     # 004650e2
    mov dword ptr [ebp - local_c], ecx           # 004650e3
    movsx eax, word ptr [ebp + arg_8]            # 004650e6
    imul eax, eax, 0x8d                          # 004650ea
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004650f0
    mov dword ptr [ebp - local_4], ecx           # 004650f6
    movsx edx, word ptr [ebp + arg_8]            # 004650f9
    imul edx, edx, 0x8d                          # 004650fd
    mov eax, dword ptr [edx + 0x5bb632]          # 00465103
    mov dword ptr [ebp - local_10], eax          # 00465109
    cmp dword ptr [ebp - local_10], 0x0          # 0046510c
    je.d8 L_0046512b                             # 00465110
    # block 0x00465112: entered by fall-through of je at 0x00465110, 2 instruction(s), ends with je to 0x0046542b (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 00465112
    je.d32 L_0046542b                            # 00465116
    # block 0x0046511c: entered by fall-through of je at 0x00465116, 2 instruction(s), ends with je to 0x0046552e (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0046511c
    je.d32 L_0046552e                            # 00465120
    # block 0x00465126: entered by fall-through of je at 0x00465120, 1 instruction(s), ends with forward jump to 0x004657cf
    jmp.d32 L_004657cf                           # 00465126
L_0046512b:
    # block 0x0046512b: entered by je at 0x00465110, 142 instruction(s), calls FUN_004e8d96, FUN_004641bb, FUN_004d39f9, ends with jne to 0x0046538b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046512b
    mov dx, word ptr [ebp + arg_8]               # 0046512e
    mov word ptr [ecx + field_1e], dx            # 00465132
    mov eax, dword ptr [ebp - local_c]           # 00465136
    mov dword ptr [eax + field_b8], 0x1          # 00465139
    mov dword ptr [0x5bb1ca], 0x1                # 00465143
    mov ecx, 0x571442                            # 0046514d
    call FUN_004e8d96                            # 00465152
    mov ecx, dword ptr [ebp - local_c]           # 00465157
    mov dword ptr [ecx + field_2a], 0x0          # 0046515a
    mov edx, dword ptr [ebp - local_c]           # 00465161
    mov word ptr [edx + field_36], 0xffff        # 00465164
    mov eax, dword ptr [ebp - local_c]           # 0046516a
    mov dword ptr [eax + field_2a], 0x0          # 0046516d
    mov ecx, dword ptr [ebp - local_c]           # 00465174
    mov dword ptr [ecx + field_2e], 0x0          # 00465177
    mov edx, dword ptr [ebp - local_c]           # 0046517e
    mov dword ptr [edx + field_32], 0x0          # 00465181
    mov eax, dword ptr [ebp - local_c]           # 00465188
    mov byte ptr [eax + field_c1], 0x0           # 0046518b
    mov ecx, dword ptr [ebp - local_c]           # 00465192
    mov byte ptr [ecx + field_bc], 0x0           # 00465195
    mov edx, dword ptr [ebp - local_c]           # 0046519c
    mov dword ptr [edx + field_bd], 0x0          # 0046519f
    mov eax, dword ptr [ebp - local_c]           # 004651a9
    movsx ecx, word ptr [eax + field_1e]         # 004651ac
    imul ecx, ecx, 0x8d                          # 004651b0
    mov dword ptr [ecx + 0x5bb632], 0x1          # 004651b6
    mov edx, dword ptr [ebp - local_c]           # 004651c0
    mov word ptr [edx + field_38], 0xffff        # 004651c3
    {load} xor eax, eax                          # 004651c9
    mov ecx, dword ptr [ebp - local_c]           # 004651cb
    add ecx, 0x3a                                # 004651ce
    mov dword ptr [ecx], eax                     # 004651d1
    mov dword ptr [ecx + field_4], eax           # 004651d3
    mov dword ptr [ecx + field_8], eax           # 004651d6
    mov dword ptr [ecx + field_c], eax           # 004651d9
    {load} xor edx, edx                          # 004651dc
    mov eax, dword ptr [ebp - local_c]           # 004651de
    add eax, 0x4a                                # 004651e1
    mov dword ptr [eax], edx                     # 004651e4
    mov dword ptr [eax + field_4], edx           # 004651e6
    mov dword ptr [eax + field_8], edx           # 004651e9
    mov dword ptr [eax + field_c], edx           # 004651ec
    {load} xor ecx, ecx                          # 004651ef
    mov edx, dword ptr [ebp - local_c]           # 004651f1
    add edx, 0x5a                                # 004651f4
    mov dword ptr [edx], ecx                     # 004651f7
    mov dword ptr [edx + field_4], ecx           # 004651f9
    mov dword ptr [edx + field_8], ecx           # 004651fc
    mov dword ptr [edx + field_c], ecx           # 004651ff
    {load} xor eax, eax                          # 00465202
    mov ecx, dword ptr [ebp - local_c]           # 00465204
    add ecx, 0x6a                                # 00465207
    mov dword ptr [ecx], eax                     # 0046520a
    mov dword ptr [ecx + field_4], eax           # 0046520c
    mov dword ptr [ecx + field_8], eax           # 0046520f
    mov dword ptr [ecx + field_c], eax           # 00465212
    {load} xor edx, edx                          # 00465215
    mov eax, dword ptr [ebp - local_c]           # 00465217
    add eax, 0xc2                                # 0046521a
    mov dword ptr [eax], edx                     # 0046521f
    mov dword ptr [eax + field_4], edx           # 00465221
    mov dword ptr [eax + field_8], edx           # 00465224
    mov dword ptr [eax + field_c], edx           # 00465227
    {load} xor ecx, ecx                          # 0046522a
    mov edx, dword ptr [ebp - local_c]           # 0046522c
    add edx, 0x94                                # 0046522f
    mov dword ptr [edx], ecx                     # 00465235
    mov dword ptr [edx + field_4], ecx           # 00465237
    mov dword ptr [edx + field_8], ecx           # 0046523a
    mov dword ptr [edx + field_c], ecx           # 0046523d
    mov dword ptr [edx + field_10], ecx          # 00465240
    mov eax, dword ptr [ebp - local_c]           # 00465243
    mov dword ptr [eax + field_26], 0x1          # 00465246
    mov ecx, dword ptr [ebp - local_c]           # 0046524d
    mov edx, dword ptr [ebp - local_4]           # 00465250
    mov ax, word ptr [edx + field_331]           # 00465253
    mov word ptr [ecx + field_8a], ax            # 0046525a
    mov ecx, dword ptr [ebp - local_c]           # 00465261
    mov dword ptr [ecx + field_8c], 0x1          # 00465264
    mov ecx, dword ptr [ebp - local_c]           # 0046526e
    call FUN_004641bb                            # 00465271
    mov edx, dword ptr [ebp - local_c]           # 00465276
    mov dword ptr [edx + field_d6], 0x0          # 00465279
    call FUN_004d39f9                            # 00465283
    mov ecx, dword ptr [ebp - local_c]           # 00465288
    mov word ptr [ecx + field_1c], ax            # 0046528b
    mov edx, dword ptr [ebp - local_c]           # 0046528f
    movsx eax, word ptr [edx + field_1c]         # 00465292
    imul eax, eax, 0x4a                          # 00465296
    mov dword ptr [eax + 0x5d1591], 0xa          # 00465299
    mov ecx, dword ptr [ebp - local_c]           # 004652a3
    movsx edx, word ptr [ecx + field_1c]         # 004652a6
    imul edx, edx, 0x4a                          # 004652aa
    mov dword ptr [edx + 0x5d1595], 0x4657e7     # 004652ad
    mov eax, dword ptr [ebp - local_c]           # 004652b7
    movsx ecx, word ptr [eax + field_1c]         # 004652ba
    imul ecx, ecx, 0x4a                          # 004652be
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004652c1
    mov edx, dword ptr [ebp - local_c]           # 004652cb
    movsx eax, word ptr [edx + field_1c]         # 004652ce
    imul eax, eax, 0x4a                          # 004652d2
    mov dword ptr [eax + 0x5d159d], 0x0          # 004652d5
    mov ecx, dword ptr [ebp - local_c]           # 004652df
    movsx edx, word ptr [ecx + field_1c]         # 004652e2
    imul edx, edx, 0x4a                          # 004652e6
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004652e9
    mov eax, dword ptr [ebp - local_c]           # 004652f3
    movsx ecx, word ptr [eax + field_1c]         # 004652f6
    imul ecx, ecx, 0x4a                          # 004652fa
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004652fd
    mov edx, dword ptr [ebp - local_c]           # 00465307
    movsx eax, word ptr [edx + field_1c]         # 0046530a
    imul eax, eax, 0x4a                          # 0046530e
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00465311
    mov ecx, dword ptr [ebp - local_c]           # 0046531b
    movsx edx, word ptr [ecx + field_1c]         # 0046531e
    imul edx, edx, 0x4a                          # 00465322
    mov word ptr [edx + 0x5d15ad], 0x0           # 00465325
    mov edi, 0x54b35c                            # 0046532e
    mov eax, dword ptr [ebp - local_c]           # 00465333
    movsx ecx, word ptr [eax + field_1c]         # 00465336
    imul ecx, ecx, 0x4a                          # 0046533a
    add ecx, 0x5d15b3                            # 0046533d
    {load} mov edx, ecx                          # 00465343
    or ecx, -0x1                                 # 00465345
    {load} xor eax, eax                          # 00465348
    repne scasb al, byte ptr es:[edi]            # 0046534a
    not ecx                                      # 0046534c
    {load} sub edi, ecx                          # 0046534e
    {load} mov esi, edi                          # 00465350
    {load} mov eax, ecx                          # 00465352
    {load} mov edi, edx                          # 00465354
    shr ecx, 0x2                                 # 00465356
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00465359
    {load} mov ecx, eax                          # 0046535b
    and ecx, 0x3                                 # 0046535d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00465360
    mov ecx, dword ptr [ebp - local_c]           # 00465362
    cmp dword ptr [ecx + field_20], 0x0          # 00465365
    jne.d8 L_0046538b                            # 00465369
    # block 0x0046536b: entered by fall-through of jne at 0x00465369, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0046538b
    push 0x54b374                                # 0046536b
    push 0x6                                     # 00465370
    mov edx, dword ptr [ebp - local_4]           # 00465372
    push edx                                     # 00465375
    push 0x54b38c                                # 00465376
    mov ecx, 0x5cf659                            # 0046537b
    call FUN_004c2790                            # 00465380
    mov ecx, dword ptr [ebp - local_c]           # 00465385
    mov dword ptr [ecx + field_20], eax          # 00465388
L_0046538b:
    # block 0x0046538b: entered by jne at 0x00465369, 13 instruction(s), ends with je to 0x004653ce (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046538b
    movsx eax, word ptr [edx + field_1c]         # 0046538e
    imul eax, eax, 0x4a                          # 00465392
    mov ecx, dword ptr [ebp - local_c]           # 00465395
    mov edx, dword ptr [ecx + field_20]          # 00465398
    mov dword ptr [eax + 0x5d1599], edx          # 0046539b
    mov edi, 0x54b394                            # 004653a1
    mov esi, dword ptr [ebp - local_4]           # 004653a6
    add esi, 0x364                               # 004653a9
    mov ecx, 0x9                                 # 004653af
    {load} xor eax, eax                          # 004653b4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004653b6
    je.d8 L_004653ce                             # 004653b8
    # block 0x004653ba: entered by fall-through of je at 0x004653b8, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004653ce
    mov ecx, dword ptr [ebp - local_4]           # 004653ba
    add ecx, 0x364                               # 004653bd
    push ecx                                     # 004653c3
    mov ecx, 0x5c3a67                            # 004653c4
    call FUN_004fb77a                            # 004653c9
L_004653ce:
    # block 0x004653ce: entered by je at 0x004653b8, 7 instruction(s), ends with je to 0x004653fa (forward)
    mov edi, 0x54b3a0                            # 004653ce
    mov esi, dword ptr [ebp - local_4]           # 004653d3
    add esi, 0x395                               # 004653d6
    mov ecx, 0x9                                 # 004653dc
    {load} xor edx, edx                          # 004653e1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004653e3
    je.d8 L_004653fa                             # 004653e5
    # block 0x004653e7: entered by fall-through of je at 0x004653e5, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004653fa
    mov eax, dword ptr [ebp - local_4]           # 004653e7
    add eax, 0x395                               # 004653ea
    push eax                                     # 004653ef
    mov ecx, 0x5c3a67                            # 004653f0
    call FUN_004fb77a                            # 004653f5
L_004653fa:
    # block 0x004653fa: entered by je at 0x004653e5, 7 instruction(s), ends with je to 0x00465426 (forward)
    mov edi, 0x54b3ac                            # 004653fa
    mov esi, dword ptr [ebp - local_4]           # 004653ff
    add esi, 0x333                               # 00465402
    mov ecx, 0x9                                 # 00465408
    {load} xor edx, edx                          # 0046540d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046540f
    je.d8 L_00465426                             # 00465411
    # block 0x00465413: entered by fall-through of je at 0x00465411, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00465426
    mov eax, dword ptr [ebp - local_4]           # 00465413
    add eax, 0x333                               # 00465416
    push eax                                     # 0046541b
    mov ecx, 0x5c3a67                            # 0046541c
    call FUN_004fb77a                            # 00465421
L_00465426:
    # block 0x00465426: entered by je at 0x00465411, 1 instruction(s), ends with forward jump to 0x004657cf
    jmp.d32 L_004657cf                           # 00465426
L_0046542b:
    # block 0x0046542b: entered by je at 0x00465116, 5 instruction(s), ends with je to 0x00465452 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046542b
    mov edx, dword ptr [ecx + field_bd]          # 0046542e
    mov dword ptr [ebp - local_14], edx          # 00465434
    cmp dword ptr [ebp - local_14], 0x1          # 00465437
    je.d8 L_00465452                             # 0046543b
    # block 0x0046543d: entered by fall-through of je at 0x0046543b, 2 instruction(s), ends with je to 0x004654df (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 0046543d
    je.d32 L_004654df                            # 00465441
    # block 0x00465447: entered by fall-through of je at 0x00465441, 2 instruction(s), ends with je to 0x00465475 (forward)
    cmp dword ptr [ebp - local_14], 0x3          # 00465447
    je.d8 L_00465475                             # 0046544b
    # block 0x0046544d: entered by fall-through of je at 0x0046544b, 1 instruction(s), ends with forward jump to 0x00465529
    jmp.d32 L_00465529                           # 0046544d
L_00465452:
    # block 0x00465452: entered by je at 0x0046543b, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00465470 (forward)
    call dword ptr [0x52a23c]                    # 00465452
    mov ecx, dword ptr [ebp - local_c]           # 00465458
    cmp eax, dword ptr [ecx + field_d6]          # 0046545b
    jb.d8 L_00465470                             # 00465461
    # block 0x00465463: entered by fall-through of jb at 0x00465461, 2 instruction(s), falls into the block at 0x00465470
    mov edx, dword ptr [ebp - local_c]           # 00465463
    mov dword ptr [edx + field_bd], 0x0          # 00465466
L_00465470:
    # block 0x00465470: entered by jb at 0x00465461, 1 instruction(s), ends with forward jump to 0x00465529
    jmp.d32 L_00465529                           # 00465470
L_00465475:
    # block 0x00465475: entered by je at 0x0046544b, 7 instruction(s), ends with je to 0x004654c6 (forward)
    mov edi, 0x54b3b8                            # 00465475
    mov esi, dword ptr [ebp - local_4]           # 0046547a
    add esi, 0x3e5                               # 0046547d
    mov ecx, 0x9                                 # 00465483
    {load} xor eax, eax                          # 00465488
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046548a
    je.d8 L_004654c6                             # 0046548c
    # block 0x0046548e: entered by fall-through of je at 0x0046548c, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004654dd
    mov ecx, dword ptr [ebp - local_4]           # 0046548e
    add ecx, 0x3e5                               # 00465491
    push ecx                                     # 00465497
    mov ecx, 0x5c3a67                            # 00465498
    call FUN_004fb77a                            # 0046549d
    mov edx, dword ptr [ebp - local_4]           # 004654a2
    mov ax, word ptr [edx + field_406]           # 004654a5
    push eax                                     # 004654ac
    mov ecx, 0x5c3a67                            # 004654ad
    call FUN_004fb2e3                            # 004654b2
    mov ecx, dword ptr [ebp - local_c]           # 004654b7
    mov dword ptr [ecx + field_bd], 0x2          # 004654ba
    jmp.d8 L_004654dd                            # 004654c4
L_004654c6:
    # block 0x004654c6: entered by je at 0x0046548c, 4 instruction(s), falls into the block at 0x004654dd
    mov edx, dword ptr [ebp - local_c]           # 004654c6
    movsx eax, word ptr [edx + field_1e]         # 004654c9
    imul eax, eax, 0x8d                          # 004654cd
    mov dword ptr [eax + 0x5bb632], 0x2          # 004654d3
L_004654dd:
    # block 0x004654dd: entered by jmp at 0x004654c4, 1 instruction(s), ends with forward jump to 0x00465529
    jmp.d8 L_00465529                            # 004654dd
L_004654df:
    # block 0x004654df: entered by je at 0x00465441, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00465529 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004654df
    movsx edx, word ptr [ecx + field_406]        # 004654e2
    mov dword ptr [ebp - local_8], edx           # 004654e9
    mov eax, dword ptr [ebp - local_8]           # 004654ec
    push eax                                     # 004654ef
    mov ecx, 0x5cf1eb                            # 004654f0
    call FUN_004f6334                            # 004654f5
    test eax, eax                                # 004654fa
    jne.d8 L_00465529                            # 004654fc
    # block 0x004654fe: entered by fall-through of jne at 0x004654fc, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x00465529
    mov ecx, dword ptr [ebp - local_4]           # 004654fe
    add ecx, 0x3e5                               # 00465501
    push ecx                                     # 00465507
    mov ecx, 0x5c3a67                            # 00465508
    call FUN_004fba69                            # 0046550d
    mov edx, dword ptr [ebp - local_c]           # 00465512
    movsx eax, word ptr [edx + field_1e]         # 00465515
    imul eax, eax, 0x8d                          # 00465519
    mov dword ptr [eax + 0x5bb632], 0x2          # 0046551f
L_00465529:
    # block 0x00465529: entered by jmp at 0x0046544d; jmp at 0x00465470; jmp at 0x004654dd; jne at 0x004654fc, 1 instruction(s), ends with forward jump to 0x004657cf
    jmp.d32 L_004657cf                           # 00465529
L_0046552e:
    # block 0x0046552e: entered by je at 0x00465120, 8 instruction(s), ends with je to 0x00465564 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0046552e
    mov edi, 0x54b3c4                            # 00465538
    mov esi, dword ptr [ebp - local_4]           # 0046553d
    add esi, 0x364                               # 00465540
    mov ecx, 0x9                                 # 00465546
    {load} xor edx, edx                          # 0046554b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046554d
    je.d8 L_00465564                             # 0046554f
    # block 0x00465551: entered by fall-through of je at 0x0046554f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00465564
    mov eax, dword ptr [ebp - local_4]           # 00465551
    add eax, 0x364                               # 00465554
    push eax                                     # 00465559
    mov ecx, 0x5c3a67                            # 0046555a
    call FUN_004fba69                            # 0046555f
L_00465564:
    # block 0x00465564: entered by je at 0x0046554f, 7 instruction(s), ends with je to 0x00465590 (forward)
    mov edi, 0x54b3d0                            # 00465564
    mov esi, dword ptr [ebp - local_4]           # 00465569
    add esi, 0x395                               # 0046556c
    mov ecx, 0x9                                 # 00465572
    {load} xor edx, edx                          # 00465577
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00465579
    je.d8 L_00465590                             # 0046557b
    # block 0x0046557d: entered by fall-through of je at 0x0046557b, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00465590
    mov eax, dword ptr [ebp - local_4]           # 0046557d
    add eax, 0x395                               # 00465580
    push eax                                     # 00465585
    mov ecx, 0x5c3a67                            # 00465586
    call FUN_004fba69                            # 0046558b
L_00465590:
    # block 0x00465590: entered by je at 0x0046557b, 7 instruction(s), ends with je to 0x004655bc (forward)
    mov edi, 0x54b3dc                            # 00465590
    mov esi, dword ptr [ebp - local_4]           # 00465595
    add esi, 0x333                               # 00465598
    mov ecx, 0x9                                 # 0046559e
    {load} xor edx, edx                          # 004655a3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004655a5
    je.d8 L_004655bc                             # 004655a7
    # block 0x004655a9: entered by fall-through of je at 0x004655a7, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004655bc
    mov eax, dword ptr [ebp - local_4]           # 004655a9
    add eax, 0x333                               # 004655ac
    push eax                                     # 004655b1
    mov ecx, 0x5c3a67                            # 004655b2
    call FUN_004fba69                            # 004655b7
L_004655bc:
    # block 0x004655bc: entered by je at 0x004655a7, 5 instruction(s), ends with je to 0x004656b1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004655bc
    {load} xor edx, edx                          # 004655bf
    mov dl, byte ptr [ecx + field_bc]            # 004655c1
    test edx, edx                                # 004655c7
    je.d32 L_004656b1                            # 004655c9
    # block 0x004655cf: entered by fall-through of je at 0x004655c9, 4 instruction(s), ends with je to 0x00465681 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004655cf
    movsx ecx, word ptr [eax + field_416]        # 004655d2
    cmp ecx, 0x270f                              # 004655d9
    je.d32 L_00465681                            # 004655df
    # block 0x004655e5: entered by fall-through of je at 0x004655df, 25 instruction(s), ends with jne to 0x0046566d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004655e5
    movsx eax, word ptr [edx + field_416]        # 004655e8
    mov dword ptr [0x5bb57b], eax                # 004655ef
    mov ecx, dword ptr [ebp - local_4]           # 004655f4
    mov dx, word ptr [ecx + field_418]           # 004655f7
    mov word ptr [0x5bb599], dx                  # 004655fe
    mov eax, dword ptr [ebp - local_4]           # 00465605
    mov cx, word ptr [eax + field_41a]           # 00465608
    mov word ptr [0x5bb595], cx                  # 0046560f
    mov edx, dword ptr [ebp - local_4]           # 00465616
    mov ax, word ptr [edx + field_41c]           # 00465619
    mov word ptr [0x5c39ff], ax                  # 00465620
    mov ecx, dword ptr [ebp - local_4]           # 00465626
    mov edx, dword ptr [ecx + field_41e]         # 00465629
    mov dword ptr [0x5bb59b], edx                # 0046562f
    mov eax, dword ptr [ebp - local_4]           # 00465635
    mov ecx, dword ptr [eax + field_422]         # 00465638
    mov dword ptr [0x5bb59f], ecx                # 0046563e
    mov edx, dword ptr [ebp - local_4]           # 00465644
    mov eax, dword ptr [edx + field_426]         # 00465647
    mov dword ptr [0x5bb5a3], eax                # 0046564d
    mov ecx, dword ptr [ebp - local_4]           # 00465652
    movsx edx, word ptr [ecx + field_42a]        # 00465655
    cmp edx, 0x1                                 # 0046565c
    jne.d8 L_0046566d                            # 0046565f
    # block 0x00465661: entered by fall-through of jne at 0x0046565f, 2 instruction(s), ends with forward jump to 0x00465677
    mov dword ptr [0x5bb1ca], 0x0                # 00465661
    jmp.d8 L_00465677                            # 0046566b
L_0046566d:
    # block 0x0046566d: entered by jne at 0x0046565f, 1 instruction(s), falls into the block at 0x00465677
    mov dword ptr [0x5bb1ca], 0x1                # 0046566d
L_00465677:
    # block 0x00465677: entered by jmp at 0x0046566b, 1 instruction(s), falls into the block at 0x00465681
    mov dword ptr [0x583999], 0x4                # 00465677
L_00465681:
    # block 0x00465681: entered by je at 0x004655df, 4 instruction(s), ends with je to 0x004656ac (forward)
    mov eax, dword ptr [ebp - local_4]           # 00465681
    movsx ecx, word ptr [eax + field_42c]        # 00465684
    cmp ecx, -0x1                                # 0046568b
    je.d8 L_004656ac                             # 0046568e
    # block 0x00465690: entered by fall-through of je at 0x0046568e, 6 instruction(s), falls into the block at 0x004656ac
    mov edx, dword ptr [ebp - local_4]           # 00465690
    {load} xor eax, eax                          # 00465693
    mov al, byte ptr [edx + field_42e]           # 00465695
    mov ecx, dword ptr [ebp - local_4]           # 0046569b
    movsx edx, word ptr [ecx + field_42c]        # 0046569e
    mov dword ptr [4*edx + 0x585801], eax        # 004656a5
L_004656ac:
    # block 0x004656ac: entered by je at 0x0046568e, 1 instruction(s), ends with forward jump to 0x004657b7
    jmp.d32 L_004657b7                           # 004656ac
L_004656b1:
    # block 0x004656b1: entered by je at 0x004655c9, 5 instruction(s), ends with je to 0x004657b7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004656b1
    {load} xor ecx, ecx                          # 004656b4
    mov cl, byte ptr [eax + field_c1]            # 004656b6
    test ecx, ecx                                # 004656bc
    je.d32 L_004657b7                            # 004656be
    # block 0x004656c4: entered by fall-through of je at 0x004656be, 6 instruction(s), ends with je to 0x0046578c (forward)
    mov edx, dword ptr [ebp - local_c]           # 004656c4
    movsx eax, word ptr [edx + field_8a]         # 004656c7
    mov ecx, dword ptr [ebp - local_4]           # 004656ce
    movsx edx, word ptr [ecx + 2*eax + field_3c6] # 004656d1
    cmp edx, 0x270f                              # 004656d9
    je.d32 L_0046578c                            # 004656df
    # block 0x004656e5: entered by fall-through of je at 0x004656df, 27 instruction(s), ends with jne to 0x00465778 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004656e5
    movsx ecx, word ptr [eax + field_8a]         # 004656e8
    mov edx, dword ptr [ebp - local_4]           # 004656ef
    movsx eax, word ptr [edx + 2*ecx + field_3c6] # 004656f2
    mov dword ptr [0x5bb57b], eax                # 004656fa
    mov ecx, dword ptr [ebp - local_4]           # 004656ff
    mov dx, word ptr [ecx + field_3ce]           # 00465702
    mov word ptr [0x5bb599], dx                  # 00465709
    mov eax, dword ptr [ebp - local_4]           # 00465710
    mov cx, word ptr [eax + field_3d0]           # 00465713
    mov word ptr [0x5bb595], cx                  # 0046571a
    mov edx, dword ptr [ebp - local_4]           # 00465721
    mov ax, word ptr [edx + field_3d2]           # 00465724
    mov word ptr [0x5c39ff], ax                  # 0046572b
    mov ecx, dword ptr [ebp - local_4]           # 00465731
    mov edx, dword ptr [ecx + field_3d4]         # 00465734
    mov dword ptr [0x5bb59b], edx                # 0046573a
    mov eax, dword ptr [ebp - local_4]           # 00465740
    mov ecx, dword ptr [eax + field_3d8]         # 00465743
    mov dword ptr [0x5bb59f], ecx                # 00465749
    mov edx, dword ptr [ebp - local_4]           # 0046574f
    mov eax, dword ptr [edx + field_3dc]         # 00465752
    mov dword ptr [0x5bb5a3], eax                # 00465758
    mov ecx, dword ptr [ebp - local_4]           # 0046575d
    movsx edx, word ptr [ecx + field_3e0]        # 00465760
    cmp edx, 0x1                                 # 00465767
    jne.d8 L_00465778                            # 0046576a
    # block 0x0046576c: entered by fall-through of jne at 0x0046576a, 2 instruction(s), ends with forward jump to 0x00465782
    mov dword ptr [0x5bb1ca], 0x0                # 0046576c
    jmp.d8 L_00465782                            # 00465776
L_00465778:
    # block 0x00465778: entered by jne at 0x0046576a, 1 instruction(s), falls into the block at 0x00465782
    mov dword ptr [0x5bb1ca], 0x1                # 00465778
L_00465782:
    # block 0x00465782: entered by jmp at 0x00465776, 1 instruction(s), falls into the block at 0x0046578c
    mov dword ptr [0x583999], 0x4                # 00465782
L_0046578c:
    # block 0x0046578c: entered by je at 0x004656df, 4 instruction(s), ends with je to 0x004657b7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046578c
    movsx ecx, word ptr [eax + field_3e2]        # 0046578f
    cmp ecx, -0x1                                # 00465796
    je.d8 L_004657b7                             # 00465799
    # block 0x0046579b: entered by fall-through of je at 0x00465799, 6 instruction(s), falls into the block at 0x004657b7
    mov edx, dword ptr [ebp - local_4]           # 0046579b
    {load} xor eax, eax                          # 0046579e
    mov al, byte ptr [edx + field_3e4]           # 004657a0
    mov ecx, dword ptr [ebp - local_4]           # 004657a6
    movsx edx, word ptr [ecx + field_3e2]        # 004657a9
    mov dword ptr [4*edx + 0x585801], eax        # 004657b0
L_004657b7:
    # block 0x004657b7: entered by jmp at 0x004656ac; je at 0x004656be; je at 0x00465799, 7 instruction(s), calls FUN_0042ba3a, FUN_00464076, falls into the block at 0x004657cf
    mov eax, dword ptr [ebp - local_c]           # 004657b7
    mov cx, word ptr [eax + field_1e]            # 004657ba
    push ecx                                     # 004657be
    call FUN_0042ba3a                            # 004657bf
    add esp, 0x4                                 # 004657c4
    mov ecx, dword ptr [ebp - local_c]           # 004657c7
    call FUN_00464076                            # 004657ca
L_004657cf:
    # block 0x004657cf: entered by jmp at 0x00465126; jmp at 0x00465426; jmp at 0x00465529, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004657cf
    pop esi                                      # 004657d0
    {load} mov esp, ebp                          # 004657d1
    pop ebp                                      # 004657d3
    ret 0x4                                      # 004657d4

