# FUN_004a2180
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a2180
# extent:       0x004a2180-0x004a3593 (5139 code bytes)
# span:         0x004a2180-0x004a35c7 (code 5139, tables 52, padding 0)
# sha256:       0eaee176e1b708317d0cffea3c26e3ab9cf1f4fb2ce4da5a6cebd0a6b0714240
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a2180
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       24 ebp-relative slot(s): local_4, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34, local_38, local_3c and 12 more
# fields:       [eax + n] field_6, field_e, field_1c, field_1e, field_20, field_24, field_2c, field_30, field_37, field_49, field_4c, field_50 and 22 more; [ecx + n] field_a, field_e, field_1c, field_1e, field_20, field_24, field_34, field_49, field_4b, field_4c, field_50, field_54 and 15 more; [edx + n] field_2, field_4, field_6, field_8, field_c, field_10, field_12, field_1c, field_1e, field_20, field_24, field_28 and 46 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004fb77a, FUN_004c924d, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050cd50, KERNEL32.dll!GetTickCount, FUN_00448d11, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_004d3836, FUN_004a2069, FUN_0050d0bc and 6 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1325 instruction(s), 64 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_37, 0x37  # offset +0x37
.equ field_38, 0x38  # offset +0x38
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_59, 0x59  # offset +0x59
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_80, 0x80  # offset +0x80
.equ field_99, 0x99  # offset +0x99
.equ field_a1, 0xa1  # offset +0xa1
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ab, 0xab  # offset +0xab
.equ field_ad, 0xad  # offset +0xad
.equ field_af, 0xaf  # offset +0xaf
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b5, 0xb5  # offset +0xb5
.equ field_b9, 0xb9  # offset +0xb9
.equ field_bd, 0xbd  # offset +0xbd
.equ field_bf, 0xbf  # offset +0xbf
.equ field_c1, 0xc1  # offset +0xc1
.equ field_e3, 0xe3  # offset +0xe3
.equ field_f3, 0xf3  # offset +0xf3
.equ field_f5, 0xf5  # offset +0xf5
.equ field_f7, 0xf7  # offset +0xf7
.equ field_f9, 0xf9  # offset +0xf9
.equ field_fb, 0xfb  # offset +0xfb
.equ field_ff, 0xff  # offset +0xff
.equ field_103, 0x103  # offset +0x103
.equ field_107, 0x107  # offset +0x107
.equ field_109, 0x109  # offset +0x109
.equ field_10b, 0x10b  # offset +0x10b
.equ field_12d, 0x12d  # offset +0x12d
.equ field_14f, 0x14f  # offset +0x14f
.equ field_151, 0x151  # offset +0x151
.equ field_153, 0x153  # offset +0x153
.equ field_155, 0x155  # offset +0x155
.equ field_157, 0x157  # offset +0x157
.equ field_159, 0x159  # offset +0x159
.equ field_15d, 0x15d  # offset +0x15d
.equ field_161, 0x161  # offset +0x161
.equ field_165, 0x165  # offset +0x165
.equ field_167, 0x167  # offset +0x167
.equ field_169, 0x169  # offset +0x169
.equ field_16a, 0x16a  # offset +0x16a
.equ field_18b, 0x18b  # offset +0x18b
.equ field_19b, 0x19b  # offset +0x19b
.equ field_19d, 0x19d  # offset +0x19d
.equ field_19f, 0x19f  # offset +0x19f
.equ field_1a1, 0x1a1  # offset +0x1a1
.equ field_1a3, 0x1a3  # offset +0x1a3
.equ field_1a7, 0x1a7  # offset +0x1a7
.equ field_1ab, 0x1ab  # offset +0x1ab
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b1, 0x1b1  # offset +0x1b1
.equ field_1b3, 0x1b3  # offset +0x1b3
.equ field_1b4, 0x1b4  # offset +0x1b4
.equ field_1d5, 0x1d5  # offset +0x1d5

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004a1cb1, .text + (0x004a1cb1 - 0x401000)
.set FUN_004a1d14, .text + (0x004a1d14 - 0x401000)
.set FUN_004a1fd1, .text + (0x004a1fd1 - 0x401000)
.set FUN_004a2069, .text + (0x004a2069 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a2180 - 0x401000
.globl FUN_004a2180
FUN_004a2180:
    # block 0x004a2180: entry, 12 instruction(s), ends with je to 0x004a21bd (forward)
    push ebp                                     # 004a2180
    {load} mov ebp, esp                          # 004a2181
    sub esp, 0x6c                                # 004a2183
    push esi                                     # 004a2186
    push edi                                     # 004a2187
    mov dword ptr [ebp - local_5c], ecx          # 004a2188
    movsx eax, word ptr [ebp + arg_8]            # 004a218b
    imul eax, eax, 0x8d                          # 004a218f
    mov ecx, dword ptr [eax + 0x5bb632]          # 004a2195
    mov dword ptr [ebp - local_60], ecx          # 004a219b
    cmp dword ptr [ebp - local_60], 0x0          # 004a219e
    je.d8 L_004a21bd                             # 004a21a2
    # block 0x004a21a4: entered by fall-through of je at 0x004a21a2, 2 instruction(s), ends with je to 0x004a2629 (forward)
    cmp dword ptr [ebp - local_60], 0x1          # 004a21a4
    je.d32 L_004a2629                            # 004a21a8
    # block 0x004a21ae: entered by fall-through of je at 0x004a21a8, 2 instruction(s), ends with je to 0x004a2f2b (forward)
    cmp dword ptr [ebp - local_60], 0x2          # 004a21ae
    je.d32 L_004a2f2b                            # 004a21b2
    # block 0x004a21b8: entered by fall-through of je at 0x004a21b2, 1 instruction(s), ends with forward jump to 0x004a358b
    jmp.d32 L_004a358b                           # 004a21b8
L_004a21bd:
    # block 0x004a21bd: entered by je at 0x004a21a2, 22 instruction(s), calls FUN_004e8d96, ends with jne to 0x004a2234 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a21bd
    mov ax, word ptr [ebp + arg_8]               # 004a21c0
    mov word ptr [edx + field_1e], ax            # 004a21c4
    mov ecx, dword ptr [ebp - local_5c]          # 004a21c8
    movsx edx, word ptr [ecx + field_1e]         # 004a21cb
    imul edx, edx, 0x8d                          # 004a21cf
    mov eax, dword ptr [ebp - local_5c]          # 004a21d5
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004a21d8
    mov dword ptr [eax + field_20], ecx          # 004a21de
    mov edx, dword ptr [ebp - local_5c]          # 004a21e1
    mov eax, dword ptr [edx + field_20]          # 004a21e4
    add eax, 0x153                               # 004a21e7
    mov ecx, dword ptr [ebp - local_5c]          # 004a21ec
    mov dword ptr [ecx + field_24], eax          # 004a21ef
    mov edx, dword ptr [ebp - local_5c]          # 004a21f2
    mov dword ptr [edx + field_60], 0x1          # 004a21f5
    mov dword ptr [0x5bb1ca], 0x1                # 004a21fc
    mov ecx, 0x571442                            # 004a2206
    call FUN_004e8d96                            # 004a220b
    movsx eax, word ptr [0x594d80]               # 004a2210
    test eax, eax                                # 004a2217
    jne.d8 L_004a2234                            # 004a2219
    # block 0x004a221b: entered by fall-through of jne at 0x004a2219, 6 instruction(s), falls into the block at 0x004a2234
    mov ecx, 0xb                                 # 004a221b
    or eax, -0x1                                 # 004a2220
    mov edi, 0x594d82                            # 004a2223
    rep stosd dword ptr es:[edi], eax            # 004a2228
    stosb byte ptr es:[edi], al                  # 004a222a
    mov word ptr [0x594d80], 0x1                 # 004a222b
L_004a2234:
    # block 0x004a2234: entered by jne at 0x004a2219, 94 instruction(s), calls FUN_004d39f9, ends with je to 0x004a23aa (forward)
    {load} xor ecx, ecx                          # 004a2234
    mov edx, dword ptr [ebp - local_5c]          # 004a2236
    add edx, 0x38                                # 004a2239
    mov dword ptr [edx], ecx                     # 004a223c
    mov dword ptr [edx + field_4], ecx           # 004a223e
    mov dword ptr [edx + field_8], ecx           # 004a2241
    mov dword ptr [edx + field_c], ecx           # 004a2244
    mov byte ptr [edx + field_10], cl            # 004a2247
    mov eax, dword ptr [ebp - local_5c]          # 004a224a
    mov ecx, dword ptr [eax + field_20]          # 004a224d
    mov edx, dword ptr [ecx + field_a]           # 004a2250
    add edx, dword ptr [0x58318a]                # 004a2253
    mov eax, dword ptr [ebp - local_5c]          # 004a2259
    mov dword ptr [eax + field_2c], edx          # 004a225c
    mov ecx, dword ptr [ebp - local_5c]          # 004a225f
    mov edx, dword ptr [ecx + field_20]          # 004a2262
    mov eax, dword ptr [edx + field_12]          # 004a2265
    add eax, dword ptr [0x58318a]                # 004a2268
    mov ecx, dword ptr [ebp - local_5c]          # 004a226e
    mov dword ptr [ecx + field_34], eax          # 004a2271
    mov edx, dword ptr [ebp - local_5c]          # 004a2274
    mov eax, dword ptr [edx + field_20]          # 004a2277
    mov ecx, dword ptr [eax + field_6]           # 004a227a
    add ecx, dword ptr [0x583186]                # 004a227d
    mov edx, dword ptr [ebp - local_5c]          # 004a2283
    mov dword ptr [edx + field_28], ecx          # 004a2286
    mov eax, dword ptr [ebp - local_5c]          # 004a2289
    mov ecx, dword ptr [eax + field_20]          # 004a228c
    mov edx, dword ptr [ecx + field_e]           # 004a228f
    add edx, dword ptr [0x583186]                # 004a2292
    mov eax, dword ptr [ebp - local_5c]          # 004a2298
    mov dword ptr [eax + field_30], edx          # 004a229b
    call FUN_004d39f9                            # 004a229e
    mov ecx, dword ptr [ebp - local_5c]          # 004a22a3
    mov word ptr [ecx + field_1c], ax            # 004a22a6
    mov edx, dword ptr [ebp - local_5c]          # 004a22aa
    movsx eax, word ptr [edx + field_1c]         # 004a22ad
    imul eax, eax, 0x4a                          # 004a22b1
    mov dword ptr [eax + 0x5d1591], 0xa          # 004a22b4
    mov ecx, dword ptr [ebp - local_5c]          # 004a22be
    movsx edx, word ptr [ecx + field_1c]         # 004a22c1
    imul edx, edx, 0x4a                          # 004a22c5
    mov dword ptr [edx + 0x5d1595], 0x4a35d7     # 004a22c8
    mov eax, dword ptr [ebp - local_5c]          # 004a22d2
    movsx ecx, word ptr [eax + field_1c]         # 004a22d5
    imul ecx, ecx, 0x4a                          # 004a22d9
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004a22dc
    mov edx, dword ptr [ebp - local_5c]          # 004a22e6
    movsx eax, word ptr [edx + field_1c]         # 004a22e9
    imul eax, eax, 0x4a                          # 004a22ed
    mov dword ptr [eax + 0x5d159d], 0x0          # 004a22f0
    mov ecx, dword ptr [ebp - local_5c]          # 004a22fa
    movsx edx, word ptr [ecx + field_1c]         # 004a22fd
    imul edx, edx, 0x4a                          # 004a2301
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004a2304
    mov eax, dword ptr [ebp - local_5c]          # 004a230e
    movsx ecx, word ptr [eax + field_1c]         # 004a2311
    imul ecx, ecx, 0x4a                          # 004a2315
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a2318
    mov edx, dword ptr [ebp - local_5c]          # 004a2322
    movsx eax, word ptr [edx + field_1c]         # 004a2325
    imul eax, eax, 0x4a                          # 004a2329
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004a232c
    mov ecx, dword ptr [ebp - local_5c]          # 004a2336
    movsx edx, word ptr [ecx + field_1c]         # 004a2339
    imul edx, edx, 0x4a                          # 004a233d
    mov word ptr [edx + 0x5d15ad], 0x0           # 004a2340
    mov edi, 0x550354                            # 004a2349
    mov eax, dword ptr [ebp - local_5c]          # 004a234e
    movsx ecx, word ptr [eax + field_1c]         # 004a2351
    imul ecx, ecx, 0x4a                          # 004a2355
    add ecx, 0x5d15b3                            # 004a2358
    {load} mov edx, ecx                          # 004a235e
    or ecx, -0x1                                 # 004a2360
    {load} xor eax, eax                          # 004a2363
    repne scasb al, byte ptr es:[edi]            # 004a2365
    not ecx                                      # 004a2367
    {load} sub edi, ecx                          # 004a2369
    {load} mov esi, edi                          # 004a236b
    {load} mov eax, ecx                          # 004a236d
    {load} mov edi, edx                          # 004a236f
    shr ecx, 0x2                                 # 004a2371
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a2374
    {load} mov ecx, eax                          # 004a2376
    and ecx, 0x3                                 # 004a2378
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a237b
    mov edi, 0x55036c                            # 004a237d
    mov ecx, dword ptr [ebp - local_5c]          # 004a2382
    mov esi, dword ptr [ecx + field_20]          # 004a2385
    add esi, 0x16                                # 004a2388
    mov ecx, 0x9                                 # 004a238b
    {load} xor edx, edx                          # 004a2390
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2392
    je.d8 L_004a23aa                             # 004a2394
    # block 0x004a2396: entered by fall-through of je at 0x004a2394, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a23aa
    mov eax, dword ptr [ebp - local_5c]          # 004a2396
    mov ecx, dword ptr [eax + field_20]          # 004a2399
    add ecx, 0x16                                # 004a239c
    push ecx                                     # 004a239f
    mov ecx, 0x5c3a67                            # 004a23a0
    call FUN_004fb77a                            # 004a23a5
L_004a23aa:
    # block 0x004a23aa: entered by je at 0x004a2394, 8 instruction(s), ends with je to 0x004a23d7 (forward)
    mov edi, 0x550378                            # 004a23aa
    mov edx, dword ptr [ebp - local_5c]          # 004a23af
    mov esi, dword ptr [edx + field_20]          # 004a23b2
    add esi, 0x47                                # 004a23b5
    mov ecx, 0x9                                 # 004a23b8
    {load} xor eax, eax                          # 004a23bd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a23bf
    je.d8 L_004a23d7                             # 004a23c1
    # block 0x004a23c3: entered by fall-through of je at 0x004a23c1, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a23d7
    mov ecx, dword ptr [ebp - local_5c]          # 004a23c3
    mov edx, dword ptr [ecx + field_20]          # 004a23c6
    add edx, 0x47                                # 004a23c9
    push edx                                     # 004a23cc
    mov ecx, 0x5c3a67                            # 004a23cd
    call FUN_004fb77a                            # 004a23d2
L_004a23d7:
    # block 0x004a23d7: entered by je at 0x004a23c1, 8 instruction(s), ends with je to 0x004a2404 (forward)
    mov edi, 0x550384                            # 004a23d7
    mov eax, dword ptr [ebp - local_5c]          # 004a23dc
    mov esi, dword ptr [eax + field_20]          # 004a23df
    add esi, 0x78                                # 004a23e2
    mov ecx, 0x9                                 # 004a23e5
    {load} xor edx, edx                          # 004a23ea
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a23ec
    je.d8 L_004a2404                             # 004a23ee
    # block 0x004a23f0: entered by fall-through of je at 0x004a23ee, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a2404
    mov eax, dword ptr [ebp - local_5c]          # 004a23f0
    mov ecx, dword ptr [eax + field_20]          # 004a23f3
    add ecx, 0x78                                # 004a23f6
    push ecx                                     # 004a23f9
    mov ecx, 0x5c3a67                            # 004a23fa
    call FUN_004fb77a                            # 004a23ff
L_004a2404:
    # block 0x004a2404: entered by je at 0x004a23ee, 13 instruction(s), calls FUN_004c924d, ends with forward jump to 0x004a243c
    mov edx, dword ptr [ebp - local_5c]          # 004a2404
    mov eax, dword ptr [edx + field_20]          # 004a2407
    mov cx, word ptr [eax]                       # 004a240a
    push ecx                                     # 004a240d
    mov ecx, 0x5cf659                            # 004a240e
    call FUN_004c924d                            # 004a2413
    mov edx, dword ptr [ebp - local_5c]          # 004a2418
    mov word ptr [edx + field_49], 0xffff        # 004a241b
    mov eax, dword ptr [ebp - local_5c]          # 004a2421
    mov ecx, dword ptr [eax + field_20]          # 004a2424
    movsx edx, word ptr [ecx + field_14f]        # 004a2427
    mov dword ptr [ebp - local_2c], edx          # 004a242e
    jmp.d8 L_004a243c                            # 004a2431
L_004a2433:
    # block 0x004a2433: entered by jmp at 0x004a2491, 3 instruction(s), falls into the block at 0x004a243c
    mov eax, dword ptr [ebp - local_2c]          # 004a2433
    add eax, 0x1                                 # 004a2436
    mov dword ptr [ebp - local_2c], eax          # 004a2439
L_004a243c:
    # block 0x004a243c: entered by jmp at 0x004a2431, 9 instruction(s), ends with jge to 0x004a2493 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a243c
    mov edx, dword ptr [ecx + field_20]          # 004a243f
    movsx eax, word ptr [edx + field_14f]        # 004a2442
    mov ecx, dword ptr [ebp - local_5c]          # 004a2449
    mov edx, dword ptr [ecx + field_20]          # 004a244c
    movsx ecx, word ptr [edx + field_151]        # 004a244f
    {load} add eax, ecx                          # 004a2456
    cmp dword ptr [ebp - local_2c], eax          # 004a2458
    jge.d8 L_004a2493                            # 004a245b
    # block 0x004a245d: entered by fall-through of jge at 0x004a245b, 6 instruction(s), ends with jne to 0x004a2491 (forward)
    movsx edx, word ptr [0x58c94f]               # 004a245d
    imul edx, edx, 0xf                           # 004a2464
    mov eax, dword ptr [ebp - local_2c]          # 004a2467
    movsx ecx, byte ptr [edx + eax + 0x594d82]   # 004a246a
    test ecx, ecx                                # 004a2472
    jne.d8 L_004a2491                            # 004a2474
    # block 0x004a2476: entered by fall-through of jne at 0x004a2474, 8 instruction(s), ends with forward jump to 0x004a2493
    mov edx, dword ptr [ebp - local_5c]          # 004a2476
    mov eax, dword ptr [edx + field_20]          # 004a2479
    movsx ecx, word ptr [eax + field_14f]        # 004a247c
    mov edx, dword ptr [ebp - local_2c]          # 004a2483
    {load} sub edx, ecx                          # 004a2486
    mov eax, dword ptr [ebp - local_5c]          # 004a2488
    mov word ptr [eax + field_49], dx            # 004a248b
    jmp.d8 L_004a2493                            # 004a248f
L_004a2491:
    # block 0x004a2491: entered by jne at 0x004a2474, 1 instruction(s), ends with backward jump to 0x004a2433
    jmp.d8 L_004a2433                            # 004a2491
L_004a2493:
    # block 0x004a2493: entered by jge at 0x004a245b; jmp at 0x004a248f, 4 instruction(s), ends with jne to 0x004a2574 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2493
    movsx edx, word ptr [ecx + field_49]         # 004a2496
    cmp edx, -0x1                                # 004a249a
    jne.d32 L_004a2574                           # 004a249d
    # block 0x004a24a3: entered by fall-through of jne at 0x004a249d, 6 instruction(s), ends with forward jump to 0x004a24c5
    mov dword ptr [ebp - local_34], 0x0          # 004a24a3
    mov eax, dword ptr [ebp - local_5c]          # 004a24aa
    mov ecx, dword ptr [eax + field_20]          # 004a24ad
    movsx edx, word ptr [ecx + field_14f]        # 004a24b0
    mov dword ptr [ebp - local_2c], edx          # 004a24b7
    jmp.d8 L_004a24c5                            # 004a24ba
L_004a24bc:
    # block 0x004a24bc: entered by jmp at 0x004a2522, 3 instruction(s), falls into the block at 0x004a24c5
    mov eax, dword ptr [ebp - local_2c]          # 004a24bc
    add eax, 0x1                                 # 004a24bf
    mov dword ptr [ebp - local_2c], eax          # 004a24c2
L_004a24c5:
    # block 0x004a24c5: entered by jmp at 0x004a24ba, 9 instruction(s), ends with jge to 0x004a2524 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a24c5
    mov edx, dword ptr [ecx + field_20]          # 004a24c8
    movsx eax, word ptr [edx + field_14f]        # 004a24cb
    mov ecx, dword ptr [ebp - local_5c]          # 004a24d2
    mov edx, dword ptr [ecx + field_20]          # 004a24d5
    movsx ecx, word ptr [edx + field_151]        # 004a24d8
    {load} add eax, ecx                          # 004a24df
    cmp dword ptr [ebp - local_2c], eax          # 004a24e1
    jge.d8 L_004a2524                            # 004a24e4
    # block 0x004a24e6: entered by fall-through of jge at 0x004a24e4, 6 instruction(s), ends with jne to 0x004a2522 (forward)
    movsx edx, word ptr [0x58c94f]               # 004a24e6
    imul edx, edx, 0xf                           # 004a24ed
    mov eax, dword ptr [ebp - local_2c]          # 004a24f0
    movsx ecx, byte ptr [edx + eax + 0x594d82]   # 004a24f3
    cmp ecx, -0x1                                # 004a24fb
    jne.d8 L_004a2522                            # 004a24fe
    # block 0x004a2500: entered by fall-through of jne at 0x004a24fe, 10 instruction(s), falls into the block at 0x004a2522
    mov edx, dword ptr [ebp - local_5c]          # 004a2500
    mov eax, dword ptr [edx + field_20]          # 004a2503
    movsx ecx, word ptr [eax + field_14f]        # 004a2506
    mov edx, dword ptr [ebp - local_2c]          # 004a250d
    {load} sub edx, ecx                          # 004a2510
    mov eax, dword ptr [ebp - local_34]          # 004a2512
    mov byte ptr [ebp + eax - local_14], dl      # 004a2515
    mov ecx, dword ptr [ebp - local_34]          # 004a2519
    add ecx, 0x1                                 # 004a251c
    mov dword ptr [ebp - local_34], ecx          # 004a251f
L_004a2522:
    # block 0x004a2522: entered by jne at 0x004a24fe, 1 instruction(s), ends with backward jump to 0x004a24bc
    jmp.d8 L_004a24bc                            # 004a2522
L_004a2524:
    # block 0x004a2524: entered by jge at 0x004a24e4, 2 instruction(s), ends with jne to 0x004a2558 (forward)
    cmp dword ptr [ebp - local_34], 0x0          # 004a2524
    jne.d8 L_004a2558                            # 004a2528
    # block 0x004a252a: entered by fall-through of jne at 0x004a2528, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a2558
    mov edx, dword ptr [ebp - local_34]          # 004a252a
    push edx                                     # 004a252d
    push 0x550390                                # 004a252e
    push 0x63888b                                # 004a2533
    call FUN_0050ca3e                            # 004a2538
    add esp, 0xc                                 # 004a253d
    push 0x0                                     # 004a2540
    push 0x0                                     # 004a2542
    push 0x63888b                                # 004a2544
    call FUN_0052139c                            # 004a2549
    mov ecx, 0x5cf659                            # 004a254e
    call FUN_004c97b4                            # 004a2553
L_004a2558:
    # block 0x004a2558: entered by jne at 0x004a2528, 8 instruction(s), calls FUN_0050cd50, falls into the block at 0x004a2574
    call FUN_0050cd50                            # 004a2558
    cdq                                          # 004a255d
    idiv dword ptr [ebp - local_34]              # 004a255e
    mov dword ptr [ebp - local_4], edx           # 004a2561
    mov eax, dword ptr [ebp - local_4]           # 004a2564
    movsx cx, byte ptr [ebp + eax - local_14]    # 004a2567
    mov edx, dword ptr [ebp - local_5c]          # 004a256d
    mov word ptr [edx + field_49], cx            # 004a2570
L_004a2574:
    # block 0x004a2574: entered by jne at 0x004a249d, 4 instruction(s), ends with jge to 0x004a25b1 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a2574
    movsx ecx, word ptr [eax + field_49]         # 004a2577
    test ecx, ecx                                # 004a257b
    jge.d8 L_004a25b1                            # 004a257d
    # block 0x004a257f: entered by fall-through of jge at 0x004a257d, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a25b1
    mov edx, dword ptr [ebp - local_5c]          # 004a257f
    movsx eax, word ptr [edx + field_49]         # 004a2582
    push eax                                     # 004a2586
    push 0x5503ec                                # 004a2587
    push 0x63888b                                # 004a258c
    call FUN_0050ca3e                            # 004a2591
    add esp, 0xc                                 # 004a2596
    push 0x0                                     # 004a2599
    push 0x0                                     # 004a259b
    push 0x63888b                                # 004a259d
    call FUN_0052139c                            # 004a25a2
    mov ecx, 0x5cf659                            # 004a25a7
    call FUN_004c97b4                            # 004a25ac
L_004a25b1:
    # block 0x004a25b1: entered by jge at 0x004a257d, 28 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004a358b
    call dword ptr [0x52a23c]                    # 004a25b1
    mov ecx, dword ptr [ebp - local_5c]          # 004a25b7
    mov edx, dword ptr [ecx + field_20]          # 004a25ba
    movsx ecx, word ptr [edx + field_4]          # 004a25bd
    {load} add eax, ecx                          # 004a25c1
    mov edx, dword ptr [ebp - local_5c]          # 004a25c3
    mov dword ptr [edx + field_64], eax          # 004a25c6
    mov eax, dword ptr [ebp - local_5c]          # 004a25c9
    mov byte ptr [eax + field_58], 0x0           # 004a25cc
    mov ecx, dword ptr [ebp - local_5c]          # 004a25d0
    mov byte ptr [ecx + field_59], 0x0           # 004a25d3
    mov edx, dword ptr [ebp - local_5c]          # 004a25d7
    mov byte ptr [edx + field_5a], 0x0           # 004a25da
    mov eax, dword ptr [ebp - local_5c]          # 004a25de
    mov dword ptr [eax + field_5b], 0x0          # 004a25e1
    mov ecx, dword ptr [ebp - local_5c]          # 004a25e8
    mov byte ptr [ecx + field_4b], 0x0           # 004a25eb
    mov edx, dword ptr [ebp - local_5c]          # 004a25ef
    mov dword ptr [edx + field_4c], 0x0          # 004a25f2
    mov eax, dword ptr [ebp - local_5c]          # 004a25f9
    mov dword ptr [eax + field_50], 0x0          # 004a25fc
    mov ecx, dword ptr [ebp - local_5c]          # 004a2603
    mov dword ptr [ecx + field_54], 0x0          # 004a2606
    mov edx, dword ptr [ebp - local_5c]          # 004a260d
    movsx eax, word ptr [edx + field_1e]         # 004a2610
    imul eax, eax, 0x8d                          # 004a2614
    mov dword ptr [eax + 0x5bb632], 0x1          # 004a261a
    jmp.d32 L_004a358b                           # 004a2624
L_004a2629:
    # block 0x004a2629: entered by je at 0x004a21a8, 5 instruction(s), ends with ja to 0x004a2f26 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2629
    mov edx, dword ptr [ecx + field_4c]          # 004a262c
    mov dword ptr [ebp - local_64], edx          # 004a262f
    cmp dword ptr [ebp - local_64], 0x8          # 004a2632
    ja.d32 L_004a2f26                            # 004a2636
    # block 0x004a263c: entered by fall-through of ja at 0x004a2636, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4a3593]
    mov eax, dword ptr [ebp - local_64]          # 004a263c
    jmp dword ptr [4*eax + SWTAB_004a3593_VA]    # 004a263f
L_004a2646:
    # block 0x004a2646: entered by switch case, 5 instruction(s), ends with ja to 0x004a2b67 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2646
    mov edx, dword ptr [ecx + field_50]          # 004a2649
    mov dword ptr [ebp - local_68], edx          # 004a264c
    cmp dword ptr [ebp - local_68], 0x3          # 004a264f
    ja.d32 L_004a2b67                            # 004a2653
    # block 0x004a2659: entered by fall-through of ja at 0x004a2653, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4a35b7]
    mov eax, dword ptr [ebp - local_68]          # 004a2659
    jmp dword ptr [4*eax + SWTAB_004a35b7_VA]    # 004a265c
L_004a2663:
    # block 0x004a2663: entered by switch case, 27 instruction(s), calls FUN_00448d11, ends with je to 0x004a2718 (forward)
    push 0x0                                     # 004a2663
    mov ecx, dword ptr [ebp - local_5c]          # 004a2665
    mov edx, dword ptr [ecx + field_20]          # 004a2668
    mov ax, word ptr [edx + field_2]             # 004a266b
    push eax                                     # 004a266f
    mov ecx, dword ptr [ebp - local_5c]          # 004a2670
    movsx edx, word ptr [ecx + field_49]         # 004a2673
    imul edx, edx, 0x1e5                         # 004a2677
    mov eax, dword ptr [ebp - local_5c]          # 004a267d
    mov ecx, dword ptr [eax + field_24]          # 004a2680
    {load} add ecx, edx                          # 004a2683
    push ecx                                     # 004a2685
    mov edx, dword ptr [0x5d03b3]                # 004a2686
    push edx                                     # 004a268c
    mov ecx, 0x619a05                            # 004a268d
    call FUN_00448d11                            # 004a2692
    mov edi, 0x550450                            # 004a2697
    mov eax, dword ptr [ebp - local_5c]          # 004a269c
    movsx ecx, word ptr [eax + field_49]         # 004a269f
    imul ecx, ecx, 0x1e5                         # 004a26a3
    mov edx, dword ptr [ebp - local_5c]          # 004a26a9
    mov eax, dword ptr [edx + field_24]          # 004a26ac
    lea esi, [eax + ecx + field_80]              # 004a26af
    mov ecx, 0x9                                 # 004a26b6
    {load} xor edx, edx                          # 004a26bb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a26bd
    je.d8 L_004a2718                             # 004a26bf
    # block 0x004a26c1: entered by fall-through of je at 0x004a26bf, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a2722
    mov eax, dword ptr [ebp - local_5c]          # 004a26c1
    movsx ecx, word ptr [eax + field_49]         # 004a26c4
    imul ecx, ecx, 0x1e5                         # 004a26c8
    mov edx, dword ptr [ebp - local_5c]          # 004a26ce
    mov eax, dword ptr [edx + field_24]          # 004a26d1
    lea ecx, [eax + ecx + field_80]              # 004a26d4
    push ecx                                     # 004a26db
    mov ecx, 0x5c3a67                            # 004a26dc
    call FUN_004fb77a                            # 004a26e1
    mov edx, dword ptr [ebp - local_5c]          # 004a26e6
    movsx eax, word ptr [edx + field_49]         # 004a26e9
    imul eax, eax, 0x1e5                         # 004a26ed
    mov ecx, dword ptr [ebp - local_5c]          # 004a26f3
    mov edx, dword ptr [ecx + field_24]          # 004a26f6
    mov ax, word ptr [edx + eax + field_a1]      # 004a26f9
    push eax                                     # 004a2701
    mov ecx, 0x5c3a67                            # 004a2702
    call FUN_004fb2e3                            # 004a2707
    mov ecx, dword ptr [ebp - local_5c]          # 004a270c
    mov dword ptr [ecx + field_50], 0x1          # 004a270f
    jmp.d8 L_004a2722                            # 004a2716
L_004a2718:
    # block 0x004a2718: entered by je at 0x004a26bf, 2 instruction(s), falls into the block at 0x004a2722
    mov edx, dword ptr [ebp - local_5c]          # 004a2718
    mov dword ptr [edx + field_50], 0x2          # 004a271b
L_004a2722:
    # block 0x004a2722: entered by jmp at 0x004a2716, 1 instruction(s), ends with forward jump to 0x004a2b67
    jmp.d32 L_004a2b67                           # 004a2722
L_004a2727:
    # block 0x004a2727: entered by switch case, 13 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2786 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a2727
    movsx ecx, word ptr [eax + field_49]         # 004a272a
    imul ecx, ecx, 0x1e5                         # 004a272e
    mov edx, dword ptr [ebp - local_5c]          # 004a2734
    mov eax, dword ptr [edx + field_24]          # 004a2737
    movsx ecx, word ptr [eax + ecx + field_a1]   # 004a273a
    mov dword ptr [ebp - local_38], ecx          # 004a2742
    mov edx, dword ptr [ebp - local_38]          # 004a2745
    push edx                                     # 004a2748
    mov ecx, 0x5cf1eb                            # 004a2749
    call FUN_004f6334                            # 004a274e
    test eax, eax                                # 004a2753
    jne.d8 L_004a2786                            # 004a2755
    # block 0x004a2757: entered by fall-through of jne at 0x004a2755, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2786
    mov eax, dword ptr [ebp - local_5c]          # 004a2757
    movsx ecx, word ptr [eax + field_49]         # 004a275a
    imul ecx, ecx, 0x1e5                         # 004a275e
    mov edx, dword ptr [ebp - local_5c]          # 004a2764
    mov eax, dword ptr [edx + field_24]          # 004a2767
    lea ecx, [eax + ecx + field_80]              # 004a276a
    push ecx                                     # 004a2771
    mov ecx, 0x5c3a67                            # 004a2772
    call FUN_004fba69                            # 004a2777
    mov edx, dword ptr [ebp - local_5c]          # 004a277c
    mov dword ptr [edx + field_50], 0x2          # 004a277f
L_004a2786:
    # block 0x004a2786: entered by jne at 0x004a2755, 1 instruction(s), ends with forward jump to 0x004a2b67
    jmp.d32 L_004a2b67                           # 004a2786
L_004a278b:
    # block 0x004a278b: entered by switch case, 3 instruction(s), ends with je to 0x004a2996 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a278b
    cmp dword ptr [eax + field_5b], 0x0          # 004a278e
    je.d32 L_004a2996                            # 004a2792
    # block 0x004a2798: entered by fall-through of je at 0x004a2792, 9 instruction(s), ends with jbe to 0x004a27e7 (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a2798
    add edi, 0x38                                # 004a279b
    or ecx, -0x1                                 # 004a279e
    {load} xor eax, eax                          # 004a27a1
    repne scasb al, byte ptr es:[edi]            # 004a27a3
    not ecx                                      # 004a27a5
    add ecx, -0x1                                # 004a27a7
    test ecx, ecx                                # 004a27aa
    jbe.d8 L_004a27e7                            # 004a27ac
    # block 0x004a27ae: entered by fall-through of jbe at 0x004a27ac, 11 instruction(s), ends with jne to 0x004a27e7 (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a27ae
    add edi, 0x38                                # 004a27b1
    or ecx, -0x1                                 # 004a27b4
    {load} xor eax, eax                          # 004a27b7
    repne scasb al, byte ptr es:[edi]            # 004a27b9
    not ecx                                      # 004a27bb
    add ecx, -0x1                                # 004a27bd
    mov edx, dword ptr [ebp - local_5c]          # 004a27c0
    movsx eax, byte ptr [edx + ecx + field_37]   # 004a27c3
    cmp eax, 0x2d                                # 004a27c8
    jne.d8 L_004a27e7                            # 004a27cb
    # block 0x004a27cd: entered by fall-through of jne at 0x004a27cb, 9 instruction(s), falls into the block at 0x004a27e7
    mov edi, dword ptr [ebp - local_5c]          # 004a27cd
    add edi, 0x38                                # 004a27d0
    or ecx, -0x1                                 # 004a27d3
    {load} xor eax, eax                          # 004a27d6
    repne scasb al, byte ptr es:[edi]            # 004a27d8
    not ecx                                      # 004a27da
    add ecx, -0x1                                # 004a27dc
    mov edx, dword ptr [ebp - local_5c]          # 004a27df
    mov byte ptr [edx + ecx + field_37], 0x0     # 004a27e2
L_004a27e7:
    # block 0x004a27e7: entered by jbe at 0x004a27ac; jne at 0x004a27cb, 5 instruction(s), ends with je to 0x004a2801 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a27e7
    mov cl, byte ptr [eax + field_5f]            # 004a27ea
    mov byte ptr [ebp - local_6c], cl            # 004a27ed
    cmp byte ptr [ebp - local_6c], 0x8           # 004a27f0
    je.d8 L_004a2801                             # 004a27f4
    # block 0x004a27f6: entered by fall-through of je at 0x004a27f4, 2 instruction(s), ends with je to 0x004a286a (forward)
    cmp byte ptr [ebp - local_6c], 0xd           # 004a27f6
    je.d8 L_004a286a                             # 004a27fa
    # block 0x004a27fc: entered by fall-through of je at 0x004a27fa, 1 instruction(s), ends with forward jump to 0x004a28c9
    jmp.d32 L_004a28c9                           # 004a27fc
L_004a2801:
    # block 0x004a2801: entered by je at 0x004a27f4, 9 instruction(s), ends with jbe to 0x004a2865 (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a2801
    add edi, 0x38                                # 004a2804
    or ecx, -0x1                                 # 004a2807
    {load} xor eax, eax                          # 004a280a
    repne scasb al, byte ptr es:[edi]            # 004a280c
    not ecx                                      # 004a280e
    add ecx, -0x1                                # 004a2810
    test ecx, ecx                                # 004a2813
    jbe.d8 L_004a2865                            # 004a2815
    # block 0x004a2817: entered by fall-through of jbe at 0x004a2815, 19 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2865 (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a2817
    add edi, 0x38                                # 004a281a
    or ecx, -0x1                                 # 004a281d
    {load} xor eax, eax                          # 004a2820
    repne scasb al, byte ptr es:[edi]            # 004a2822
    not ecx                                      # 004a2824
    add ecx, -0x1                                # 004a2826
    mov edx, dword ptr [ebp - local_5c]          # 004a2829
    mov byte ptr [edx + ecx + field_37], 0x0     # 004a282c
    mov eax, dword ptr [ebp - local_5c]          # 004a2831
    mov ecx, dword ptr [eax + field_20]          # 004a2834
    movsx edx, word ptr [ecx + field_68]         # 004a2837
    mov dword ptr [ebp - local_3c], edx          # 004a283b
    mov eax, dword ptr [ebp - local_3c]          # 004a283e
    push eax                                     # 004a2841
    mov ecx, 0x5cf1eb                            # 004a2842
    call FUN_004f6334                            # 004a2847
    test eax, eax                                # 004a284c
    jne.d8 L_004a2865                            # 004a284e
    # block 0x004a2850: entered by fall-through of jne at 0x004a284e, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a2865
    mov ecx, dword ptr [ebp - local_5c]          # 004a2850
    mov edx, dword ptr [ecx + field_20]          # 004a2853
    mov ax, word ptr [edx + field_68]            # 004a2856
    push eax                                     # 004a285a
    mov ecx, 0x5c3a67                            # 004a285b
    call FUN_004fb2e3                            # 004a2860
L_004a2865:
    # block 0x004a2865: entered by jbe at 0x004a2815; jne at 0x004a284e, 1 instruction(s), ends with forward jump to 0x004a298c
    jmp.d32 L_004a298c                           # 004a2865
L_004a286a:
    # block 0x004a286a: entered by je at 0x004a27fa, 9 instruction(s), ends with jbe to 0x004a28c4 (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a286a
    add edi, 0x38                                # 004a286d
    or ecx, -0x1                                 # 004a2870
    {load} xor eax, eax                          # 004a2873
    repne scasb al, byte ptr es:[edi]            # 004a2875
    not ecx                                      # 004a2877
    add ecx, -0x1                                # 004a2879
    test ecx, ecx                                # 004a287c
    jbe.d8 L_004a28c4                            # 004a287e
    # block 0x004a2880: entered by fall-through of jbe at 0x004a287e, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x004a28c4 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2880
    mov dword ptr [ecx + field_50], 0x3          # 004a2883
    mov edx, dword ptr [ebp - local_5c]          # 004a288a
    mov eax, dword ptr [edx + field_20]          # 004a288d
    movsx ecx, word ptr [eax + field_99]         # 004a2890
    mov dword ptr [ebp - local_40], ecx          # 004a2897
    mov edx, dword ptr [ebp - local_40]          # 004a289a
    push edx                                     # 004a289d
    mov ecx, 0x5cf1eb                            # 004a289e
    call FUN_004f6334                            # 004a28a3
    test eax, eax                                # 004a28a8
    jne.d8 L_004a28c4                            # 004a28aa
    # block 0x004a28ac: entered by fall-through of jne at 0x004a28aa, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a28c4
    mov eax, dword ptr [ebp - local_5c]          # 004a28ac
    mov ecx, dword ptr [eax + field_20]          # 004a28af
    mov dx, word ptr [ecx + field_99]            # 004a28b2
    push edx                                     # 004a28b9
    mov ecx, 0x5c3a67                            # 004a28ba
    call FUN_004fb2e3                            # 004a28bf
L_004a28c4:
    # block 0x004a28c4: entered by jbe at 0x004a287e; jne at 0x004a28aa, 1 instruction(s), ends with forward jump to 0x004a298c
    jmp.d32 L_004a298c                           # 004a28c4
L_004a28c9:
    # block 0x004a28c9: entered by jmp at 0x004a27fc, 9 instruction(s), ends with jae to 0x004a298c (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a28c9
    add edi, 0x38                                # 004a28cc
    or ecx, -0x1                                 # 004a28cf
    {load} xor eax, eax                          # 004a28d2
    repne scasb al, byte ptr es:[edi]            # 004a28d4
    not ecx                                      # 004a28d6
    inc ecx                                      # 004a28d8
    cmp ecx, 0x11                                # 004a28d9
    jae.d32 L_004a298c                           # 004a28dc
    # block 0x004a28e2: entered by fall-through of jae at 0x004a28dc, 27 instruction(s), calls FUN_004d3836, ends with jge to 0x004a298c (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a28e2
    mov ecx, dword ptr [eax + field_20]          # 004a28e5
    movsx edx, word ptr [ecx]                    # 004a28e8
    imul edx, edx, 0x1d0                         # 004a28eb
    add edx, 0x5adb3a                            # 004a28f1
    push edx                                     # 004a28f7
    mov eax, dword ptr [ebp - local_5c]          # 004a28f8
    mov ecx, dword ptr [eax + field_20]          # 004a28fb
    movsx edx, word ptr [ecx]                    # 004a28fe
    imul edx, edx, 0x7f3                         # 004a2901
    add edx, 0x5a4c24                            # 004a2907
    push edx                                     # 004a290d
    mov eax, dword ptr [ebp - local_5c]          # 004a290e
    add eax, 0x38                                # 004a2911
    push eax                                     # 004a2914
    call FUN_004d3836                            # 004a2915
    add esp, 0xc                                 # 004a291a
    movsx ecx, ax                                # 004a291d
    mov edx, dword ptr [ebp - local_5c]          # 004a2920
    mov eax, dword ptr [edx + field_20]          # 004a2923
    mov edx, dword ptr [ebp - local_5c]          # 004a2926
    mov edx, dword ptr [edx + field_20]          # 004a2929
    mov eax, dword ptr [eax + field_e]           # 004a292c
    sub eax, dword ptr [edx + field_6]           # 004a292f
    sub eax, 0x14                                # 004a2932
    {load} cmp ecx, eax                          # 004a2935
    jge.d8 L_004a298c                            # 004a2937
    # block 0x004a2939: entered by fall-through of jge at 0x004a2937, 21 instruction(s), calls FUN_004f6334, ends with jne to 0x004a298c (forward)
    mov edi, dword ptr [ebp - local_5c]          # 004a2939
    add edi, 0x38                                # 004a293c
    or ecx, -0x1                                 # 004a293f
    {load} xor eax, eax                          # 004a2942
    repne scasb al, byte ptr es:[edi]            # 004a2944
    not ecx                                      # 004a2946
    add ecx, -0x1                                # 004a2948
    mov edx, dword ptr [ebp - local_5c]          # 004a294b
    mov eax, dword ptr [ebp - local_5c]          # 004a294e
    mov al, byte ptr [eax + field_5f]            # 004a2951
    mov byte ptr [edx + ecx + field_38], al      # 004a2954
    mov ecx, dword ptr [ebp - local_5c]          # 004a2958
    mov edx, dword ptr [ecx + field_20]          # 004a295b
    movsx eax, word ptr [edx + field_37]         # 004a295e
    mov dword ptr [ebp - local_44], eax          # 004a2962
    mov ecx, dword ptr [ebp - local_44]          # 004a2965
    push ecx                                     # 004a2968
    mov ecx, 0x5cf1eb                            # 004a2969
    call FUN_004f6334                            # 004a296e
    test eax, eax                                # 004a2973
    jne.d8 L_004a298c                            # 004a2975
    # block 0x004a2977: entered by fall-through of jne at 0x004a2975, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a298c
    mov edx, dword ptr [ebp - local_5c]          # 004a2977
    mov eax, dword ptr [edx + field_20]          # 004a297a
    mov cx, word ptr [eax + field_37]            # 004a297d
    push ecx                                     # 004a2981
    mov ecx, 0x5c3a67                            # 004a2982
    call FUN_004fb2e3                            # 004a2987
L_004a298c:
    # block 0x004a298c: entered by jmp at 0x004a2865; jmp at 0x004a28c4; jae at 0x004a28dc; jge at 0x004a2937; more, 2 instruction(s), falls into the block at 0x004a2996
    mov edx, dword ptr [ebp - local_5c]          # 004a298c
    mov dword ptr [edx + field_5b], 0x0          # 004a298f
L_004a2996:
    # block 0x004a2996: entered by je at 0x004a2792, 3 instruction(s), ends with jne to 0x004a29a7 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a2996
    cmp dword ptr [eax + field_50], 0x2          # 004a2999
    jne.d8 L_004a29a7                            # 004a299d
    # block 0x004a299f: entered by fall-through of jne at 0x004a299d, 2 instruction(s), calls FUN_004a2069, falls into the block at 0x004a29a7
    mov ecx, dword ptr [ebp - local_5c]          # 004a299f
    call FUN_004a2069                            # 004a29a2
L_004a29a7:
    # block 0x004a29a7: entered by jne at 0x004a299d, 1 instruction(s), ends with forward jump to 0x004a2b67
    jmp.d32 L_004a2b67                           # 004a29a7
L_004a29ac:
    # block 0x004a29ac: entered by switch case, 10 instruction(s), calls FUN_004f6334, ends with je to 0x004a29d3 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a29ac
    mov edx, dword ptr [ecx + field_20]          # 004a29af
    movsx eax, word ptr [edx + field_99]         # 004a29b2
    mov dword ptr [ebp - local_48], eax          # 004a29b9
    mov ecx, dword ptr [ebp - local_48]          # 004a29bc
    push ecx                                     # 004a29bf
    mov ecx, 0x5cf1eb                            # 004a29c0
    call FUN_004f6334                            # 004a29c5
    test eax, eax                                # 004a29ca
    je.d8 L_004a29d3                             # 004a29cc
    # block 0x004a29ce: entered by fall-through of je at 0x004a29cc, 1 instruction(s), ends with forward jump to 0x004a2b67
    jmp.d32 L_004a2b67                           # 004a29ce
L_004a29d3:
    # block 0x004a29d3: entered by je at 0x004a29cc, 30 instruction(s), calls FUN_0050d0bc, ends with forward jump to 0x004a2a31
    {load} xor edx, edx                          # 004a29d3
    mov dword ptr [ebp - local_28], edx          # 004a29d5
    mov dword ptr [ebp - local_24], edx          # 004a29d8
    mov dword ptr [ebp - local_20], edx          # 004a29db
    mov dword ptr [ebp - local_1c], edx          # 004a29de
    mov byte ptr [ebp - local_18], dl            # 004a29e1
    mov eax, dword ptr [ebp - local_5c]          # 004a29e4
    add eax, 0x38                                # 004a29e7
    {load} mov edi, eax                          # 004a29ea
    lea edx, [ebp - local_28]                    # 004a29ec
    or ecx, -0x1                                 # 004a29ef
    {load} xor eax, eax                          # 004a29f2
    repne scasb al, byte ptr es:[edi]            # 004a29f4
    not ecx                                      # 004a29f6
    {load} sub edi, ecx                          # 004a29f8
    {load} mov esi, edi                          # 004a29fa
    {load} mov eax, ecx                          # 004a29fc
    {load} mov edi, edx                          # 004a29fe
    shr ecx, 0x2                                 # 004a2a00
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a2a03
    {load} mov ecx, eax                          # 004a2a05
    and ecx, 0x3                                 # 004a2a07
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a2a0a
    lea ecx, [ebp - local_28]                    # 004a2a0c
    push ecx                                     # 004a2a0f
    call FUN_0050d0bc                            # 004a2a10
    add esp, 0x4                                 # 004a2a15
    mov dword ptr [ebp - local_30], 0x0          # 004a2a18
    mov dword ptr [ebp - local_2c], 0x0          # 004a2a1f
    jmp.d8 L_004a2a31                            # 004a2a26
L_004a2a28:
    # block 0x004a2a28: entered by jmp at 0x004a2ad4, 3 instruction(s), falls into the block at 0x004a2a31
    mov edx, dword ptr [ebp - local_2c]          # 004a2a28
    add edx, 0x1                                 # 004a2a2b
    mov dword ptr [ebp - local_2c], edx          # 004a2a2e
L_004a2a31:
    # block 0x004a2a31: entered by jmp at 0x004a2a26, 2 instruction(s), ends with jge to 0x004a2ad9 (forward)
    cmp dword ptr [ebp - local_2c], 0x8          # 004a2a31
    jge.d32 L_004a2ad9                           # 004a2a35
    # block 0x004a2a3b: entered by fall-through of jge at 0x004a2a35, 16 instruction(s), ends with jbe to 0x004a2ad4 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a2a3b
    movsx ecx, word ptr [eax + field_49]         # 004a2a3e
    imul ecx, ecx, 0x1e5                         # 004a2a42
    mov edx, dword ptr [ebp - local_5c]          # 004a2a48
    mov eax, dword ptr [edx + field_24]          # 004a2a4b
    {load} add eax, ecx                          # 004a2a4e
    mov ecx, dword ptr [ebp - local_2c]          # 004a2a50
    imul ecx, ecx, 0x14                          # 004a2a53
    lea edi, [eax + ecx + field_b1]              # 004a2a56
    or ecx, -0x1                                 # 004a2a5d
    {load} xor eax, eax                          # 004a2a60
    repne scasb al, byte ptr es:[edi]            # 004a2a62
    not ecx                                      # 004a2a64
    add ecx, -0x1                                # 004a2a66
    test ecx, ecx                                # 004a2a69
    jbe.d8 L_004a2ad4                            # 004a2a6b
    # block 0x004a2a6d: entered by fall-through of jbe at 0x004a2a6b, 28 instruction(s), calls FUN_0050d0bc, FUN_0050d8e0, ends with je to 0x004a2ad4 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a2a6d
    movsx eax, word ptr [edx + field_49]         # 004a2a70
    imul eax, eax, 0x1e5                         # 004a2a74
    mov ecx, dword ptr [ebp - local_5c]          # 004a2a7a
    mov edx, dword ptr [ecx + field_24]          # 004a2a7d
    {load} add edx, eax                          # 004a2a80
    mov eax, dword ptr [ebp - local_2c]          # 004a2a82
    imul eax, eax, 0x14                          # 004a2a85
    lea ecx, [edx + eax + field_b1]              # 004a2a88
    push ecx                                     # 004a2a8f
    call FUN_0050d0bc                            # 004a2a90
    add esp, 0x4                                 # 004a2a95
    mov edx, dword ptr [ebp - local_5c]          # 004a2a98
    movsx eax, word ptr [edx + field_49]         # 004a2a9b
    imul eax, eax, 0x1e5                         # 004a2a9f
    mov ecx, dword ptr [ebp - local_5c]          # 004a2aa5
    mov edx, dword ptr [ecx + field_24]          # 004a2aa8
    {load} add edx, eax                          # 004a2aab
    mov eax, dword ptr [ebp - local_2c]          # 004a2aad
    imul eax, eax, 0x14                          # 004a2ab0
    lea ecx, [edx + eax + field_b1]              # 004a2ab3
    push ecx                                     # 004a2aba
    lea edx, [ebp - local_28]                    # 004a2abb
    push edx                                     # 004a2abe
    call FUN_0050d8e0                            # 004a2abf
    add esp, 0x8                                 # 004a2ac4
    test eax, eax                                # 004a2ac7
    je.d8 L_004a2ad4                             # 004a2ac9
    # block 0x004a2acb: entered by fall-through of je at 0x004a2ac9, 2 instruction(s), ends with forward jump to 0x004a2ad9
    mov dword ptr [ebp - local_30], 0x1          # 004a2acb
    jmp.d8 L_004a2ad9                            # 004a2ad2
L_004a2ad4:
    # block 0x004a2ad4: entered by jbe at 0x004a2a6b; je at 0x004a2ac9, 1 instruction(s), ends with backward jump to 0x004a2a28
    jmp.d32 L_004a2a28                           # 004a2ad4
L_004a2ad9:
    # block 0x004a2ad9: entered by jge at 0x004a2a35; jmp at 0x004a2ad2, 2 instruction(s), ends with je to 0x004a2b2e (forward)
    cmp dword ptr [ebp - local_30], 0x0          # 004a2ad9
    je.d8 L_004a2b2e                             # 004a2add
    # block 0x004a2adf: entered by fall-through of je at 0x004a2add, 16 instruction(s), calls FUN_004a1fd1, ends with jne to 0x004a2b2c (forward)
    movsx eax, word ptr [0x58c94f]               # 004a2adf
    imul eax, eax, 0xf                           # 004a2ae6
    mov ecx, dword ptr [ebp - local_5c]          # 004a2ae9
    movsx edx, word ptr [ecx + field_49]         # 004a2aec
    mov ecx, dword ptr [ebp - local_5c]          # 004a2af0
    mov ecx, dword ptr [ecx + field_20]          # 004a2af3
    movsx ecx, word ptr [ecx + field_14f]        # 004a2af6
    {load} add edx, ecx                          # 004a2afd
    mov byte ptr [eax + edx + 0x594d82], 0x1     # 004a2aff
    mov ecx, dword ptr [ebp - local_5c]          # 004a2b07
    call FUN_004a1fd1                            # 004a2b0a
    mov edx, dword ptr [ebp - local_5c]          # 004a2b0f
    {load} xor eax, eax                          # 004a2b12
    mov al, byte ptr [edx + field_58]            # 004a2b14
    test eax, eax                                # 004a2b17
    jne.d8 L_004a2b2c                            # 004a2b19
    # block 0x004a2b1b: entered by fall-through of jne at 0x004a2b19, 4 instruction(s), falls into the block at 0x004a2b2c
    mov ecx, dword ptr [ebp - local_5c]          # 004a2b1b
    mov byte ptr [ecx + field_59], 0x1           # 004a2b1e
    mov edx, dword ptr [ebp - local_5c]          # 004a2b22
    mov dword ptr [edx + field_4c], 0x5          # 004a2b25
L_004a2b2c:
    # block 0x004a2b2c: entered by jne at 0x004a2b19, 1 instruction(s), ends with forward jump to 0x004a2b67
    jmp.d8 L_004a2b67                            # 004a2b2c
L_004a2b2e:
    # block 0x004a2b2e: entered by je at 0x004a2add, 13 instruction(s), falls into the block at 0x004a2b67
    movsx eax, word ptr [0x58c94f]               # 004a2b2e
    imul eax, eax, 0xf                           # 004a2b35
    mov ecx, dword ptr [ebp - local_5c]          # 004a2b38
    movsx edx, word ptr [ecx + field_49]         # 004a2b3b
    mov ecx, dword ptr [ebp - local_5c]          # 004a2b3f
    mov ecx, dword ptr [ecx + field_20]          # 004a2b42
    movsx ecx, word ptr [ecx + field_14f]        # 004a2b45
    {load} add edx, ecx                          # 004a2b4c
    mov byte ptr [eax + edx + 0x594d82], 0x0     # 004a2b4e
    mov edx, dword ptr [ebp - local_5c]          # 004a2b56
    mov byte ptr [edx + field_5a], 0x1           # 004a2b59
    mov eax, dword ptr [ebp - local_5c]          # 004a2b5d
    mov dword ptr [eax + field_4c], 0x6          # 004a2b60
L_004a2b67:
    # block 0x004a2b67: entered by ja at 0x004a2653; jmp at 0x004a2722; jmp at 0x004a2786; jmp at 0x004a29a7; more, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2b67
L_004a2b6c:
    # block 0x004a2b6c: entered by switch case, 16 instruction(s), ends with je to 0x004a2bd9 (forward)
    {load} xor ecx, ecx                          # 004a2b6c
    mov edx, dword ptr [ebp - local_5c]          # 004a2b6e
    add edx, 0x38                                # 004a2b71
    mov dword ptr [edx], ecx                     # 004a2b74
    mov dword ptr [edx + field_4], ecx           # 004a2b76
    mov dword ptr [edx + field_8], ecx           # 004a2b79
    mov dword ptr [edx + field_c], ecx           # 004a2b7c
    mov byte ptr [edx + field_10], cl            # 004a2b7f
    mov edi, 0x55045c                            # 004a2b82
    mov eax, dword ptr [ebp - local_5c]          # 004a2b87
    mov esi, dword ptr [eax + field_20]          # 004a2b8a
    add esi, 0x10c                               # 004a2b8d
    mov ecx, 0x9                                 # 004a2b93
    {load} xor edx, edx                          # 004a2b98
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2b9a
    je.d8 L_004a2bd9                             # 004a2b9c
    # block 0x004a2b9e: entered by fall-through of je at 0x004a2b9c, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a2bf0
    mov eax, dword ptr [ebp - local_5c]          # 004a2b9e
    mov ecx, dword ptr [eax + field_20]          # 004a2ba1
    add ecx, 0x10c                               # 004a2ba4
    push ecx                                     # 004a2baa
    mov ecx, 0x5c3a67                            # 004a2bab
    call FUN_004fb77a                            # 004a2bb0
    mov edx, dword ptr [ebp - local_5c]          # 004a2bb5
    mov eax, dword ptr [edx + field_20]          # 004a2bb8
    mov cx, word ptr [eax + field_12d]           # 004a2bbb
    push ecx                                     # 004a2bc2
    mov ecx, 0x5c3a67                            # 004a2bc3
    call FUN_004fb2e3                            # 004a2bc8
    mov edx, dword ptr [ebp - local_5c]          # 004a2bcd
    mov dword ptr [edx + field_4c], 0x2          # 004a2bd0
    jmp.d8 L_004a2bf0                            # 004a2bd7
L_004a2bd9:
    # block 0x004a2bd9: entered by je at 0x004a2b9c, 4 instruction(s), falls into the block at 0x004a2bf0
    mov eax, dword ptr [ebp - local_5c]          # 004a2bd9
    movsx ecx, word ptr [eax + field_1e]         # 004a2bdc
    imul ecx, ecx, 0x8d                          # 004a2be0
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004a2be6
L_004a2bf0:
    # block 0x004a2bf0: entered by jmp at 0x004a2bd7, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2bf0
L_004a2bf5:
    # block 0x004a2bf5: entered by switch case, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2c45 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a2bf5
    mov eax, dword ptr [edx + field_20]          # 004a2bf8
    movsx ecx, word ptr [eax + field_12d]        # 004a2bfb
    mov dword ptr [ebp - local_4c], ecx          # 004a2c02
    mov edx, dword ptr [ebp - local_4c]          # 004a2c05
    push edx                                     # 004a2c08
    mov ecx, 0x5cf1eb                            # 004a2c09
    call FUN_004f6334                            # 004a2c0e
    test eax, eax                                # 004a2c13
    jne.d8 L_004a2c45                            # 004a2c15
    # block 0x004a2c17: entered by fall-through of jne at 0x004a2c15, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2c45
    mov eax, dword ptr [ebp - local_5c]          # 004a2c17
    mov ecx, dword ptr [eax + field_20]          # 004a2c1a
    add ecx, 0x10c                               # 004a2c1d
    push ecx                                     # 004a2c23
    mov ecx, 0x5c3a67                            # 004a2c24
    call FUN_004fba69                            # 004a2c29
    mov edx, dword ptr [ebp - local_5c]          # 004a2c2e
    movsx eax, word ptr [edx + field_1e]         # 004a2c31
    imul eax, eax, 0x8d                          # 004a2c35
    mov dword ptr [eax + 0x5bb632], 0x2          # 004a2c3b
L_004a2c45:
    # block 0x004a2c45: entered by jne at 0x004a2c15, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2c45
L_004a2c4a:
    # block 0x004a2c4a: entered by switch case, 11 instruction(s), ends with je to 0x004a2ccb (forward)
    mov edi, 0x550468                            # 004a2c4a
    mov ecx, dword ptr [ebp - local_5c]          # 004a2c4f
    movsx edx, word ptr [ecx + field_49]         # 004a2c52
    imul edx, edx, 0x1e5                         # 004a2c56
    mov eax, dword ptr [ebp - local_5c]          # 004a2c5c
    mov ecx, dword ptr [eax + field_24]          # 004a2c5f
    lea esi, [ecx + edx + field_1b4]             # 004a2c62
    mov ecx, 0x9                                 # 004a2c69
    {load} xor edx, edx                          # 004a2c6e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2c70
    je.d8 L_004a2ccb                             # 004a2c72
    # block 0x004a2c74: entered by fall-through of je at 0x004a2c72, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a2ce2
    mov eax, dword ptr [ebp - local_5c]          # 004a2c74
    movsx ecx, word ptr [eax + field_49]         # 004a2c77
    imul ecx, ecx, 0x1e5                         # 004a2c7b
    mov edx, dword ptr [ebp - local_5c]          # 004a2c81
    mov eax, dword ptr [edx + field_24]          # 004a2c84
    lea ecx, [eax + ecx + field_1b4]             # 004a2c87
    push ecx                                     # 004a2c8e
    mov ecx, 0x5c3a67                            # 004a2c8f
    call FUN_004fb77a                            # 004a2c94
    mov edx, dword ptr [ebp - local_5c]          # 004a2c99
    movsx eax, word ptr [edx + field_49]         # 004a2c9c
    imul eax, eax, 0x1e5                         # 004a2ca0
    mov ecx, dword ptr [ebp - local_5c]          # 004a2ca6
    mov edx, dword ptr [ecx + field_24]          # 004a2ca9
    mov ax, word ptr [edx + eax + field_1d5]     # 004a2cac
    push eax                                     # 004a2cb4
    mov ecx, 0x5c3a67                            # 004a2cb5
    call FUN_004fb2e3                            # 004a2cba
    mov ecx, dword ptr [ebp - local_5c]          # 004a2cbf
    mov dword ptr [ecx + field_4c], 0x7          # 004a2cc2
    jmp.d8 L_004a2ce2                            # 004a2cc9
L_004a2ccb:
    # block 0x004a2ccb: entered by je at 0x004a2c72, 4 instruction(s), falls into the block at 0x004a2ce2
    mov edx, dword ptr [ebp - local_5c]          # 004a2ccb
    movsx eax, word ptr [edx + field_1e]         # 004a2cce
    imul eax, eax, 0x8d                          # 004a2cd2
    mov dword ptr [eax + 0x5bb632], 0x2          # 004a2cd8
L_004a2ce2:
    # block 0x004a2ce2: entered by jmp at 0x004a2cc9, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2ce2
L_004a2ce7:
    # block 0x004a2ce7: entered by switch case, 13 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2d53 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2ce7
    movsx edx, word ptr [ecx + field_49]         # 004a2cea
    imul edx, edx, 0x1e5                         # 004a2cee
    mov eax, dword ptr [ebp - local_5c]          # 004a2cf4
    mov ecx, dword ptr [eax + field_24]          # 004a2cf7
    movsx edx, word ptr [ecx + edx + field_1d5]  # 004a2cfa
    mov dword ptr [ebp - local_50], edx          # 004a2d02
    mov eax, dword ptr [ebp - local_50]          # 004a2d05
    push eax                                     # 004a2d08
    mov ecx, 0x5cf1eb                            # 004a2d09
    call FUN_004f6334                            # 004a2d0e
    test eax, eax                                # 004a2d13
    jne.d8 L_004a2d53                            # 004a2d15
    # block 0x004a2d17: entered by fall-through of jne at 0x004a2d15, 13 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2d53
    mov ecx, dword ptr [ebp - local_5c]          # 004a2d17
    movsx edx, word ptr [ecx + field_49]         # 004a2d1a
    imul edx, edx, 0x1e5                         # 004a2d1e
    mov eax, dword ptr [ebp - local_5c]          # 004a2d24
    mov ecx, dword ptr [eax + field_24]          # 004a2d27
    lea edx, [ecx + edx + field_1b4]             # 004a2d2a
    push edx                                     # 004a2d31
    mov ecx, 0x5c3a67                            # 004a2d32
    call FUN_004fba69                            # 004a2d37
    mov eax, dword ptr [ebp - local_5c]          # 004a2d3c
    movsx ecx, word ptr [eax + field_1e]         # 004a2d3f
    imul ecx, ecx, 0x8d                          # 004a2d43
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004a2d49
L_004a2d53:
    # block 0x004a2d53: entered by jne at 0x004a2d15, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2d53
L_004a2d58:
    # block 0x004a2d58: entered by switch case, 11 instruction(s), ends with je to 0x004a2dd9 (forward)
    mov edi, 0x550474                            # 004a2d58
    mov edx, dword ptr [ebp - local_5c]          # 004a2d5d
    movsx eax, word ptr [edx + field_49]         # 004a2d60
    imul eax, eax, 0x1e5                         # 004a2d64
    mov ecx, dword ptr [ebp - local_5c]          # 004a2d6a
    mov edx, dword ptr [ecx + field_24]          # 004a2d6d
    lea esi, [edx + eax + field_16a]             # 004a2d70
    mov ecx, 0x9                                 # 004a2d77
    {load} xor eax, eax                          # 004a2d7c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2d7e
    je.d8 L_004a2dd9                             # 004a2d80
    # block 0x004a2d82: entered by fall-through of je at 0x004a2d80, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a2df0
    mov ecx, dword ptr [ebp - local_5c]          # 004a2d82
    movsx edx, word ptr [ecx + field_49]         # 004a2d85
    imul edx, edx, 0x1e5                         # 004a2d89
    mov eax, dword ptr [ebp - local_5c]          # 004a2d8f
    mov ecx, dword ptr [eax + field_24]          # 004a2d92
    lea edx, [ecx + edx + field_16a]             # 004a2d95
    push edx                                     # 004a2d9c
    mov ecx, 0x5c3a67                            # 004a2d9d
    call FUN_004fb77a                            # 004a2da2
    mov eax, dword ptr [ebp - local_5c]          # 004a2da7
    movsx ecx, word ptr [eax + field_49]         # 004a2daa
    imul ecx, ecx, 0x1e5                         # 004a2dae
    mov edx, dword ptr [ebp - local_5c]          # 004a2db4
    mov eax, dword ptr [edx + field_24]          # 004a2db7
    mov cx, word ptr [eax + ecx + field_18b]     # 004a2dba
    push ecx                                     # 004a2dc2
    mov ecx, 0x5c3a67                            # 004a2dc3
    call FUN_004fb2e3                            # 004a2dc8
    mov edx, dword ptr [ebp - local_5c]          # 004a2dcd
    mov dword ptr [edx + field_4c], 0x8          # 004a2dd0
    jmp.d8 L_004a2df0                            # 004a2dd7
L_004a2dd9:
    # block 0x004a2dd9: entered by je at 0x004a2d80, 4 instruction(s), falls into the block at 0x004a2df0
    mov eax, dword ptr [ebp - local_5c]          # 004a2dd9
    movsx ecx, word ptr [eax + field_1e]         # 004a2ddc
    imul ecx, ecx, 0x8d                          # 004a2de0
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004a2de6
L_004a2df0:
    # block 0x004a2df0: entered by jmp at 0x004a2dd7, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2df0
L_004a2df5:
    # block 0x004a2df5: entered by switch case, 13 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2e61 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a2df5
    movsx eax, word ptr [edx + field_49]         # 004a2df8
    imul eax, eax, 0x1e5                         # 004a2dfc
    mov ecx, dword ptr [ebp - local_5c]          # 004a2e02
    mov edx, dword ptr [ecx + field_24]          # 004a2e05
    movsx eax, word ptr [edx + eax + field_18b]  # 004a2e08
    mov dword ptr [ebp - local_54], eax          # 004a2e10
    mov ecx, dword ptr [ebp - local_54]          # 004a2e13
    push ecx                                     # 004a2e16
    mov ecx, 0x5cf1eb                            # 004a2e17
    call FUN_004f6334                            # 004a2e1c
    test eax, eax                                # 004a2e21
    jne.d8 L_004a2e61                            # 004a2e23
    # block 0x004a2e25: entered by fall-through of jne at 0x004a2e23, 13 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2e61
    mov edx, dword ptr [ebp - local_5c]          # 004a2e25
    movsx eax, word ptr [edx + field_49]         # 004a2e28
    imul eax, eax, 0x1e5                         # 004a2e2c
    mov ecx, dword ptr [ebp - local_5c]          # 004a2e32
    mov edx, dword ptr [ecx + field_24]          # 004a2e35
    lea eax, [edx + eax + field_16a]             # 004a2e38
    push eax                                     # 004a2e3f
    mov ecx, 0x5c3a67                            # 004a2e40
    call FUN_004fba69                            # 004a2e45
    mov ecx, dword ptr [ebp - local_5c]          # 004a2e4a
    movsx edx, word ptr [ecx + field_1e]         # 004a2e4d
    imul edx, edx, 0x8d                          # 004a2e51
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a2e57
L_004a2e61:
    # block 0x004a2e61: entered by jne at 0x004a2e23, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d32 L_004a2f26                           # 004a2e61
L_004a2e66:
    # block 0x004a2e66: entered by switch case, 8 instruction(s), ends with je to 0x004a2ebd (forward)
    mov edi, 0x550480                            # 004a2e66
    mov eax, dword ptr [ebp - local_5c]          # 004a2e6b
    mov esi, dword ptr [eax + field_20]          # 004a2e6e
    add esi, 0xc2                                # 004a2e71
    mov ecx, 0x9                                 # 004a2e77
    {load} xor edx, edx                          # 004a2e7c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2e7e
    je.d8 L_004a2ebd                             # 004a2e80
    # block 0x004a2e82: entered by fall-through of je at 0x004a2e80, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a2ed4
    mov eax, dword ptr [ebp - local_5c]          # 004a2e82
    mov ecx, dword ptr [eax + field_20]          # 004a2e85
    add ecx, 0xc2                                # 004a2e88
    push ecx                                     # 004a2e8e
    mov ecx, 0x5c3a67                            # 004a2e8f
    call FUN_004fb77a                            # 004a2e94
    mov edx, dword ptr [ebp - local_5c]          # 004a2e99
    mov eax, dword ptr [edx + field_20]          # 004a2e9c
    mov cx, word ptr [eax + field_e3]            # 004a2e9f
    push ecx                                     # 004a2ea6
    mov ecx, 0x5c3a67                            # 004a2ea7
    call FUN_004fb2e3                            # 004a2eac
    mov edx, dword ptr [ebp - local_5c]          # 004a2eb1
    mov dword ptr [edx + field_4c], 0x1          # 004a2eb4
    jmp.d8 L_004a2ed4                            # 004a2ebb
L_004a2ebd:
    # block 0x004a2ebd: entered by je at 0x004a2e80, 4 instruction(s), falls into the block at 0x004a2ed4
    mov eax, dword ptr [ebp - local_5c]          # 004a2ebd
    movsx ecx, word ptr [eax + field_1e]         # 004a2ec0
    imul ecx, ecx, 0x8d                          # 004a2ec4
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004a2eca
L_004a2ed4:
    # block 0x004a2ed4: entered by jmp at 0x004a2ebb, 1 instruction(s), ends with forward jump to 0x004a2f26
    jmp.d8 L_004a2f26                            # 004a2ed4
L_004a2ed6:
    # block 0x004a2ed6: entered by switch case, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x004a2f26 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a2ed6
    mov eax, dword ptr [edx + field_20]          # 004a2ed9
    movsx ecx, word ptr [eax + field_e3]         # 004a2edc
    mov dword ptr [ebp - local_58], ecx          # 004a2ee3
    mov edx, dword ptr [ebp - local_58]          # 004a2ee6
    push edx                                     # 004a2ee9
    mov ecx, 0x5cf1eb                            # 004a2eea
    call FUN_004f6334                            # 004a2eef
    test eax, eax                                # 004a2ef4
    jne.d8 L_004a2f26                            # 004a2ef6
    # block 0x004a2ef8: entered by fall-through of jne at 0x004a2ef6, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2f26
    mov eax, dword ptr [ebp - local_5c]          # 004a2ef8
    mov ecx, dword ptr [eax + field_20]          # 004a2efb
    add ecx, 0xc2                                # 004a2efe
    push ecx                                     # 004a2f04
    mov ecx, 0x5c3a67                            # 004a2f05
    call FUN_004fba69                            # 004a2f0a
    mov edx, dword ptr [ebp - local_5c]          # 004a2f0f
    movsx eax, word ptr [edx + field_1e]         # 004a2f12
    imul eax, eax, 0x8d                          # 004a2f16
    mov dword ptr [eax + 0x5bb632], 0x2          # 004a2f1c
L_004a2f26:
    # block 0x004a2f26: entered by ja at 0x004a2636; jmp at 0x004a2b67; jmp at 0x004a2bf0; jmp at 0x004a2c45; more, 1 instruction(s), ends with forward jump to 0x004a358b
    jmp.d32 L_004a358b                           # 004a2f26
L_004a2f2b:
    # block 0x004a2f2b: entered by je at 0x004a21b2, 15 instruction(s), calls FUN_004c92c5, ends with je to 0x004a2f76 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004a2f2b
    mov ecx, dword ptr [ebp - local_5c]          # 004a2f35
    mov edx, dword ptr [ecx + field_20]          # 004a2f38
    mov ax, word ptr [edx]                       # 004a2f3b
    push eax                                     # 004a2f3e
    mov ecx, 0x5cf659                            # 004a2f3f
    call FUN_004c92c5                            # 004a2f44
    mov edi, 0x55048c                            # 004a2f49
    mov ecx, dword ptr [ebp - local_5c]          # 004a2f4e
    mov esi, dword ptr [ecx + field_20]          # 004a2f51
    add esi, 0x16                                # 004a2f54
    mov ecx, 0x9                                 # 004a2f57
    {load} xor edx, edx                          # 004a2f5c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2f5e
    je.d8 L_004a2f76                             # 004a2f60
    # block 0x004a2f62: entered by fall-through of je at 0x004a2f60, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2f76
    mov eax, dword ptr [ebp - local_5c]          # 004a2f62
    mov ecx, dword ptr [eax + field_20]          # 004a2f65
    add ecx, 0x16                                # 004a2f68
    push ecx                                     # 004a2f6b
    mov ecx, 0x5c3a67                            # 004a2f6c
    call FUN_004fba69                            # 004a2f71
L_004a2f76:
    # block 0x004a2f76: entered by je at 0x004a2f60, 8 instruction(s), ends with je to 0x004a2fa3 (forward)
    mov edi, 0x550498                            # 004a2f76
    mov edx, dword ptr [ebp - local_5c]          # 004a2f7b
    mov esi, dword ptr [edx + field_20]          # 004a2f7e
    add esi, 0x47                                # 004a2f81
    mov ecx, 0x9                                 # 004a2f84
    {load} xor eax, eax                          # 004a2f89
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2f8b
    je.d8 L_004a2fa3                             # 004a2f8d
    # block 0x004a2f8f: entered by fall-through of je at 0x004a2f8d, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2fa3
    mov ecx, dword ptr [ebp - local_5c]          # 004a2f8f
    mov edx, dword ptr [ecx + field_20]          # 004a2f92
    add edx, 0x47                                # 004a2f95
    push edx                                     # 004a2f98
    mov ecx, 0x5c3a67                            # 004a2f99
    call FUN_004fba69                            # 004a2f9e
L_004a2fa3:
    # block 0x004a2fa3: entered by je at 0x004a2f8d, 8 instruction(s), ends with je to 0x004a2fd0 (forward)
    mov edi, 0x5504a4                            # 004a2fa3
    mov eax, dword ptr [ebp - local_5c]          # 004a2fa8
    mov esi, dword ptr [eax + field_20]          # 004a2fab
    add esi, 0x78                                # 004a2fae
    mov ecx, 0x9                                 # 004a2fb1
    {load} xor edx, edx                          # 004a2fb6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a2fb8
    je.d8 L_004a2fd0                             # 004a2fba
    # block 0x004a2fbc: entered by fall-through of je at 0x004a2fba, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004a2fd0
    mov eax, dword ptr [ebp - local_5c]          # 004a2fbc
    mov ecx, dword ptr [eax + field_20]          # 004a2fbf
    add ecx, 0x78                                # 004a2fc2
    push ecx                                     # 004a2fc5
    mov ecx, 0x5c3a67                            # 004a2fc6
    call FUN_004fba69                            # 004a2fcb
L_004a2fd0:
    # block 0x004a2fd0: entered by je at 0x004a2fba, 5 instruction(s), ends with je to 0x004a30e1 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a2fd0
    {load} xor eax, eax                          # 004a2fd3
    mov al, byte ptr [edx + field_4b]            # 004a2fd5
    test eax, eax                                # 004a2fd8
    je.d32 L_004a30e1                            # 004a2fda
    # block 0x004a2fe0: entered by fall-through of je at 0x004a2fda, 5 instruction(s), ends with je to 0x004a30a8 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2fe0
    mov edx, dword ptr [ecx + field_20]          # 004a2fe3
    movsx eax, word ptr [edx + field_f3]         # 004a2fe6
    cmp eax, 0x270f                              # 004a2fed
    je.d32 L_004a30a8                            # 004a2ff2
    # block 0x004a2ff8: entered by fall-through of je at 0x004a2ff2, 33 instruction(s), ends with jne to 0x004a3094 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a2ff8
    mov edx, dword ptr [ecx + field_20]          # 004a2ffb
    movsx eax, word ptr [edx + field_f3]         # 004a2ffe
    mov dword ptr [0x5bb57b], eax                # 004a3005
    mov ecx, dword ptr [ebp - local_5c]          # 004a300a
    mov edx, dword ptr [ecx + field_20]          # 004a300d
    mov ax, word ptr [edx + field_f5]            # 004a3010
    mov word ptr [0x5bb599], ax                  # 004a3017
    mov ecx, dword ptr [ebp - local_5c]          # 004a301d
    mov edx, dword ptr [ecx + field_20]          # 004a3020
    mov ax, word ptr [edx + field_f7]            # 004a3023
    mov word ptr [0x5bb595], ax                  # 004a302a
    mov ecx, dword ptr [ebp - local_5c]          # 004a3030
    mov edx, dword ptr [ecx + field_20]          # 004a3033
    mov ax, word ptr [edx + field_f9]            # 004a3036
    mov word ptr [0x5c39ff], ax                  # 004a303d
    mov ecx, dword ptr [ebp - local_5c]          # 004a3043
    mov edx, dword ptr [ecx + field_20]          # 004a3046
    mov eax, dword ptr [edx + field_fb]          # 004a3049
    mov dword ptr [0x5bb59b], eax                # 004a304f
    mov ecx, dword ptr [ebp - local_5c]          # 004a3054
    mov edx, dword ptr [ecx + field_20]          # 004a3057
    mov eax, dword ptr [edx + field_ff]          # 004a305a
    mov dword ptr [0x5bb59f], eax                # 004a3060
    mov ecx, dword ptr [ebp - local_5c]          # 004a3065
    mov edx, dword ptr [ecx + field_20]          # 004a3068
    mov eax, dword ptr [edx + field_103]         # 004a306b
    mov dword ptr [0x5bb5a3], eax                # 004a3071
    mov ecx, dword ptr [ebp - local_5c]          # 004a3076
    mov edx, dword ptr [ecx + field_20]          # 004a3079
    movsx eax, word ptr [edx + field_107]        # 004a307c
    cmp eax, 0x1                                 # 004a3083
    jne.d8 L_004a3094                            # 004a3086
    # block 0x004a3088: entered by fall-through of jne at 0x004a3086, 2 instruction(s), ends with forward jump to 0x004a309e
    mov dword ptr [0x5bb1ca], 0x0                # 004a3088
    jmp.d8 L_004a309e                            # 004a3092
L_004a3094:
    # block 0x004a3094: entered by jne at 0x004a3086, 1 instruction(s), falls into the block at 0x004a309e
    mov dword ptr [0x5bb1ca], 0x1                # 004a3094
L_004a309e:
    # block 0x004a309e: entered by jmp at 0x004a3092, 1 instruction(s), falls into the block at 0x004a30a8
    mov dword ptr [0x583999], 0x4                # 004a309e
L_004a30a8:
    # block 0x004a30a8: entered by je at 0x004a2ff2, 5 instruction(s), ends with je to 0x004a30dc (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a30a8
    mov edx, dword ptr [ecx + field_20]          # 004a30ab
    movsx eax, word ptr [edx + field_109]        # 004a30ae
    cmp eax, -0x1                                # 004a30b5
    je.d8 L_004a30dc                             # 004a30b8
    # block 0x004a30ba: entered by fall-through of je at 0x004a30b8, 8 instruction(s), falls into the block at 0x004a30dc
    mov ecx, dword ptr [ebp - local_5c]          # 004a30ba
    mov edx, dword ptr [ecx + field_20]          # 004a30bd
    {load} xor eax, eax                          # 004a30c0
    mov al, byte ptr [edx + field_10b]           # 004a30c2
    mov ecx, dword ptr [ebp - local_5c]          # 004a30c8
    mov edx, dword ptr [ecx + field_20]          # 004a30cb
    movsx ecx, word ptr [edx + field_109]        # 004a30ce
    mov dword ptr [4*ecx + 0x585801], eax        # 004a30d5
L_004a30dc:
    # block 0x004a30dc: entered by je at 0x004a30b8, 1 instruction(s), ends with forward jump to 0x004a3573
    jmp.d32 L_004a3573                           # 004a30dc
L_004a30e1:
    # block 0x004a30e1: entered by je at 0x004a2fda, 5 instruction(s), ends with je to 0x004a31fa (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a30e1
    {load} xor eax, eax                          # 004a30e4
    mov al, byte ptr [edx + field_58]            # 004a30e6
    test eax, eax                                # 004a30e9
    je.d32 L_004a31fa                            # 004a30eb
    # block 0x004a30f1: entered by fall-through of je at 0x004a30eb, 7 instruction(s), calls FUN_004a1d14, ends with je to 0x004a31c1 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a30f1
    call FUN_004a1d14                            # 004a30f4
    mov ecx, dword ptr [ebp - local_5c]          # 004a30f9
    mov edx, dword ptr [ecx + field_20]          # 004a30fc
    movsx eax, word ptr [edx + field_a9]         # 004a30ff
    cmp eax, 0x270f                              # 004a3106
    je.d32 L_004a31c1                            # 004a310b
    # block 0x004a3111: entered by fall-through of je at 0x004a310b, 33 instruction(s), ends with jne to 0x004a31ad (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a3111
    mov edx, dword ptr [ecx + field_20]          # 004a3114
    movsx eax, word ptr [edx + field_a9]         # 004a3117
    mov dword ptr [0x5bb57b], eax                # 004a311e
    mov ecx, dword ptr [ebp - local_5c]          # 004a3123
    mov edx, dword ptr [ecx + field_20]          # 004a3126
    mov ax, word ptr [edx + field_ab]            # 004a3129
    mov word ptr [0x5bb599], ax                  # 004a3130
    mov ecx, dword ptr [ebp - local_5c]          # 004a3136
    mov edx, dword ptr [ecx + field_20]          # 004a3139
    mov ax, word ptr [edx + field_ad]            # 004a313c
    mov word ptr [0x5bb595], ax                  # 004a3143
    mov ecx, dword ptr [ebp - local_5c]          # 004a3149
    mov edx, dword ptr [ecx + field_20]          # 004a314c
    mov ax, word ptr [edx + field_af]            # 004a314f
    mov word ptr [0x5c39ff], ax                  # 004a3156
    mov ecx, dword ptr [ebp - local_5c]          # 004a315c
    mov edx, dword ptr [ecx + field_20]          # 004a315f
    mov eax, dword ptr [edx + field_b1]          # 004a3162
    mov dword ptr [0x5bb59b], eax                # 004a3168
    mov ecx, dword ptr [ebp - local_5c]          # 004a316d
    mov edx, dword ptr [ecx + field_20]          # 004a3170
    mov eax, dword ptr [edx + field_b5]          # 004a3173
    mov dword ptr [0x5bb59f], eax                # 004a3179
    mov ecx, dword ptr [ebp - local_5c]          # 004a317e
    mov edx, dword ptr [ecx + field_20]          # 004a3181
    mov eax, dword ptr [edx + field_b9]          # 004a3184
    mov dword ptr [0x5bb5a3], eax                # 004a318a
    mov ecx, dword ptr [ebp - local_5c]          # 004a318f
    mov edx, dword ptr [ecx + field_20]          # 004a3192
    movsx eax, word ptr [edx + field_bd]         # 004a3195
    cmp eax, 0x1                                 # 004a319c
    jne.d8 L_004a31ad                            # 004a319f
    # block 0x004a31a1: entered by fall-through of jne at 0x004a319f, 2 instruction(s), ends with forward jump to 0x004a31b7
    mov dword ptr [0x5bb1ca], 0x0                # 004a31a1
    jmp.d8 L_004a31b7                            # 004a31ab
L_004a31ad:
    # block 0x004a31ad: entered by jne at 0x004a319f, 1 instruction(s), falls into the block at 0x004a31b7
    mov dword ptr [0x5bb1ca], 0x1                # 004a31ad
L_004a31b7:
    # block 0x004a31b7: entered by jmp at 0x004a31ab, 1 instruction(s), falls into the block at 0x004a31c1
    mov dword ptr [0x583999], 0x4                # 004a31b7
L_004a31c1:
    # block 0x004a31c1: entered by je at 0x004a310b, 5 instruction(s), ends with je to 0x004a31f5 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a31c1
    mov edx, dword ptr [ecx + field_20]          # 004a31c4
    movsx eax, word ptr [edx + field_bf]         # 004a31c7
    cmp eax, -0x1                                # 004a31ce
    je.d8 L_004a31f5                             # 004a31d1
    # block 0x004a31d3: entered by fall-through of je at 0x004a31d1, 8 instruction(s), falls into the block at 0x004a31f5
    mov ecx, dword ptr [ebp - local_5c]          # 004a31d3
    mov edx, dword ptr [ecx + field_20]          # 004a31d6
    {load} xor eax, eax                          # 004a31d9
    mov al, byte ptr [edx + field_c1]            # 004a31db
    mov ecx, dword ptr [ebp - local_5c]          # 004a31e1
    mov edx, dword ptr [ecx + field_20]          # 004a31e4
    movsx ecx, word ptr [edx + field_bf]         # 004a31e7
    mov dword ptr [4*ecx + 0x585801], eax        # 004a31ee
L_004a31f5:
    # block 0x004a31f5: entered by je at 0x004a31d1, 1 instruction(s), ends with forward jump to 0x004a3573
    jmp.d32 L_004a3573                           # 004a31f5
L_004a31fa:
    # block 0x004a31fa: entered by je at 0x004a30eb, 5 instruction(s), ends with je to 0x004a33b9 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a31fa
    {load} xor eax, eax                          # 004a31fd
    mov al, byte ptr [edx + field_59]            # 004a31ff
    test eax, eax                                # 004a3202
    je.d32 L_004a33b9                            # 004a3204
    # block 0x004a320a: entered by fall-through of je at 0x004a3204, 8 instruction(s), ends with je to 0x004a3356 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a320a
    movsx edx, word ptr [ecx + field_49]         # 004a320d
    imul edx, edx, 0x1e5                         # 004a3211
    mov eax, dword ptr [ebp - local_5c]          # 004a3217
    mov ecx, dword ptr [eax + field_24]          # 004a321a
    movsx edx, word ptr [ecx + edx + field_19b]  # 004a321d
    cmp edx, 0x270f                              # 004a3225
    je.d32 L_004a3356                            # 004a322b
    # block 0x004a3231: entered by fall-through of je at 0x004a322b, 57 instruction(s), ends with jne to 0x004a3342 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a3231
    movsx ecx, word ptr [eax + field_49]         # 004a3234
    imul ecx, ecx, 0x1e5                         # 004a3238
    mov edx, dword ptr [ebp - local_5c]          # 004a323e
    mov eax, dword ptr [edx + field_24]          # 004a3241
    movsx ecx, word ptr [eax + ecx + field_19b]  # 004a3244
    mov dword ptr [0x5bb57b], ecx                # 004a324c
    mov edx, dword ptr [ebp - local_5c]          # 004a3252
    movsx eax, word ptr [edx + field_49]         # 004a3255
    imul eax, eax, 0x1e5                         # 004a3259
    mov ecx, dword ptr [ebp - local_5c]          # 004a325f
    mov edx, dword ptr [ecx + field_24]          # 004a3262
    mov ax, word ptr [edx + eax + field_19d]     # 004a3265
    mov word ptr [0x5bb599], ax                  # 004a326d
    mov ecx, dword ptr [ebp - local_5c]          # 004a3273
    movsx edx, word ptr [ecx + field_49]         # 004a3276
    imul edx, edx, 0x1e5                         # 004a327a
    mov eax, dword ptr [ebp - local_5c]          # 004a3280
    mov ecx, dword ptr [eax + field_24]          # 004a3283
    mov dx, word ptr [ecx + edx + field_19f]     # 004a3286
    mov word ptr [0x5bb595], dx                  # 004a328e
    mov eax, dword ptr [ebp - local_5c]          # 004a3295
    movsx ecx, word ptr [eax + field_49]         # 004a3298
    imul ecx, ecx, 0x1e5                         # 004a329c
    mov edx, dword ptr [ebp - local_5c]          # 004a32a2
    mov eax, dword ptr [edx + field_24]          # 004a32a5
    mov cx, word ptr [eax + ecx + field_1a1]     # 004a32a8
    mov word ptr [0x5c39ff], cx                  # 004a32b0
    mov edx, dword ptr [ebp - local_5c]          # 004a32b7
    movsx eax, word ptr [edx + field_49]         # 004a32ba
    imul eax, eax, 0x1e5                         # 004a32be
    mov ecx, dword ptr [ebp - local_5c]          # 004a32c4
    mov edx, dword ptr [ecx + field_24]          # 004a32c7
    mov eax, dword ptr [edx + eax + field_1a3]   # 004a32ca
    mov dword ptr [0x5bb59b], eax                # 004a32d1
    mov ecx, dword ptr [ebp - local_5c]          # 004a32d6
    movsx edx, word ptr [ecx + field_49]         # 004a32d9
    imul edx, edx, 0x1e5                         # 004a32dd
    mov eax, dword ptr [ebp - local_5c]          # 004a32e3
    mov ecx, dword ptr [eax + field_24]          # 004a32e6
    mov edx, dword ptr [ecx + edx + field_1a7]   # 004a32e9
    mov dword ptr [0x5bb59f], edx                # 004a32f0
    mov eax, dword ptr [ebp - local_5c]          # 004a32f6
    movsx ecx, word ptr [eax + field_49]         # 004a32f9
    imul ecx, ecx, 0x1e5                         # 004a32fd
    mov edx, dword ptr [ebp - local_5c]          # 004a3303
    mov eax, dword ptr [edx + field_24]          # 004a3306
    mov ecx, dword ptr [eax + ecx + field_1ab]   # 004a3309
    mov dword ptr [0x5bb5a3], ecx                # 004a3310
    mov edx, dword ptr [ebp - local_5c]          # 004a3316
    movsx eax, word ptr [edx + field_49]         # 004a3319
    imul eax, eax, 0x1e5                         # 004a331d
    mov ecx, dword ptr [ebp - local_5c]          # 004a3323
    mov edx, dword ptr [ecx + field_24]          # 004a3326
    movsx eax, word ptr [edx + eax + field_1af]  # 004a3329
    cmp eax, 0x1                                 # 004a3331
    jne.d8 L_004a3342                            # 004a3334
    # block 0x004a3336: entered by fall-through of jne at 0x004a3334, 2 instruction(s), ends with forward jump to 0x004a334c
    mov dword ptr [0x5bb1ca], 0x0                # 004a3336
    jmp.d8 L_004a334c                            # 004a3340
L_004a3342:
    # block 0x004a3342: entered by jne at 0x004a3334, 1 instruction(s), falls into the block at 0x004a334c
    mov dword ptr [0x5bb1ca], 0x1                # 004a3342
L_004a334c:
    # block 0x004a334c: entered by jmp at 0x004a3340, 1 instruction(s), falls into the block at 0x004a3356
    mov dword ptr [0x583999], 0x4                # 004a334c
L_004a3356:
    # block 0x004a3356: entered by je at 0x004a322b, 8 instruction(s), ends with je to 0x004a33b4 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a3356
    movsx edx, word ptr [ecx + field_49]         # 004a3359
    imul edx, edx, 0x1e5                         # 004a335d
    mov eax, dword ptr [ebp - local_5c]          # 004a3363
    mov ecx, dword ptr [eax + field_24]          # 004a3366
    movsx edx, word ptr [ecx + edx + field_1b1]  # 004a3369
    cmp edx, -0x1                                # 004a3371
    je.d8 L_004a33b4                             # 004a3374
    # block 0x004a3376: entered by fall-through of je at 0x004a3374, 14 instruction(s), falls into the block at 0x004a33b4
    mov eax, dword ptr [ebp - local_5c]          # 004a3376
    movsx ecx, word ptr [eax + field_49]         # 004a3379
    imul ecx, ecx, 0x1e5                         # 004a337d
    mov edx, dword ptr [ebp - local_5c]          # 004a3383
    mov eax, dword ptr [edx + field_24]          # 004a3386
    {load} xor edx, edx                          # 004a3389
    mov dl, byte ptr [eax + ecx + field_1b3]     # 004a338b
    mov eax, dword ptr [ebp - local_5c]          # 004a3392
    movsx ecx, word ptr [eax + field_49]         # 004a3395
    imul ecx, ecx, 0x1e5                         # 004a3399
    mov eax, dword ptr [ebp - local_5c]          # 004a339f
    mov eax, dword ptr [eax + field_24]          # 004a33a2
    movsx ecx, word ptr [eax + ecx + field_1b1]  # 004a33a5
    mov dword ptr [4*ecx + 0x585801], edx        # 004a33ad
L_004a33b4:
    # block 0x004a33b4: entered by je at 0x004a3374, 1 instruction(s), ends with forward jump to 0x004a3573
    jmp.d32 L_004a3573                           # 004a33b4
L_004a33b9:
    # block 0x004a33b9: entered by je at 0x004a3204, 5 instruction(s), ends with je to 0x004a3573 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 004a33b9
    {load} xor eax, eax                          # 004a33bc
    mov al, byte ptr [edx + field_5a]            # 004a33be
    test eax, eax                                # 004a33c1
    je.d32 L_004a3573                            # 004a33c3
    # block 0x004a33c9: entered by fall-through of je at 0x004a33c3, 8 instruction(s), ends with je to 0x004a3515 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a33c9
    movsx edx, word ptr [ecx + field_49]         # 004a33cc
    imul edx, edx, 0x1e5                         # 004a33d0
    mov eax, dword ptr [ebp - local_5c]          # 004a33d6
    mov ecx, dword ptr [eax + field_24]          # 004a33d9
    movsx edx, word ptr [ecx + edx + field_151]  # 004a33dc
    cmp edx, 0x270f                              # 004a33e4
    je.d32 L_004a3515                            # 004a33ea
    # block 0x004a33f0: entered by fall-through of je at 0x004a33ea, 57 instruction(s), ends with jne to 0x004a3501 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 004a33f0
    movsx ecx, word ptr [eax + field_49]         # 004a33f3
    imul ecx, ecx, 0x1e5                         # 004a33f7
    mov edx, dword ptr [ebp - local_5c]          # 004a33fd
    mov eax, dword ptr [edx + field_24]          # 004a3400
    movsx ecx, word ptr [eax + ecx + field_151]  # 004a3403
    mov dword ptr [0x5bb57b], ecx                # 004a340b
    mov edx, dword ptr [ebp - local_5c]          # 004a3411
    movsx eax, word ptr [edx + field_49]         # 004a3414
    imul eax, eax, 0x1e5                         # 004a3418
    mov ecx, dword ptr [ebp - local_5c]          # 004a341e
    mov edx, dword ptr [ecx + field_24]          # 004a3421
    mov ax, word ptr [edx + eax + field_153]     # 004a3424
    mov word ptr [0x5bb599], ax                  # 004a342c
    mov ecx, dword ptr [ebp - local_5c]          # 004a3432
    movsx edx, word ptr [ecx + field_49]         # 004a3435
    imul edx, edx, 0x1e5                         # 004a3439
    mov eax, dword ptr [ebp - local_5c]          # 004a343f
    mov ecx, dword ptr [eax + field_24]          # 004a3442
    mov dx, word ptr [ecx + edx + field_155]     # 004a3445
    mov word ptr [0x5bb595], dx                  # 004a344d
    mov eax, dword ptr [ebp - local_5c]          # 004a3454
    movsx ecx, word ptr [eax + field_49]         # 004a3457
    imul ecx, ecx, 0x1e5                         # 004a345b
    mov edx, dword ptr [ebp - local_5c]          # 004a3461
    mov eax, dword ptr [edx + field_24]          # 004a3464
    mov cx, word ptr [eax + ecx + field_157]     # 004a3467
    mov word ptr [0x5c39ff], cx                  # 004a346f
    mov edx, dword ptr [ebp - local_5c]          # 004a3476
    movsx eax, word ptr [edx + field_49]         # 004a3479
    imul eax, eax, 0x1e5                         # 004a347d
    mov ecx, dword ptr [ebp - local_5c]          # 004a3483
    mov edx, dword ptr [ecx + field_24]          # 004a3486
    mov eax, dword ptr [edx + eax + field_159]   # 004a3489
    mov dword ptr [0x5bb59b], eax                # 004a3490
    mov ecx, dword ptr [ebp - local_5c]          # 004a3495
    movsx edx, word ptr [ecx + field_49]         # 004a3498
    imul edx, edx, 0x1e5                         # 004a349c
    mov eax, dword ptr [ebp - local_5c]          # 004a34a2
    mov ecx, dword ptr [eax + field_24]          # 004a34a5
    mov edx, dword ptr [ecx + edx + field_15d]   # 004a34a8
    mov dword ptr [0x5bb59f], edx                # 004a34af
    mov eax, dword ptr [ebp - local_5c]          # 004a34b5
    movsx ecx, word ptr [eax + field_49]         # 004a34b8
    imul ecx, ecx, 0x1e5                         # 004a34bc
    mov edx, dword ptr [ebp - local_5c]          # 004a34c2
    mov eax, dword ptr [edx + field_24]          # 004a34c5
    mov ecx, dword ptr [eax + ecx + field_161]   # 004a34c8
    mov dword ptr [0x5bb5a3], ecx                # 004a34cf
    mov edx, dword ptr [ebp - local_5c]          # 004a34d5
    movsx eax, word ptr [edx + field_49]         # 004a34d8
    imul eax, eax, 0x1e5                         # 004a34dc
    mov ecx, dword ptr [ebp - local_5c]          # 004a34e2
    mov edx, dword ptr [ecx + field_24]          # 004a34e5
    movsx eax, word ptr [edx + eax + field_165]  # 004a34e8
    cmp eax, 0x1                                 # 004a34f0
    jne.d8 L_004a3501                            # 004a34f3
    # block 0x004a34f5: entered by fall-through of jne at 0x004a34f3, 2 instruction(s), ends with forward jump to 0x004a350b
    mov dword ptr [0x5bb1ca], 0x0                # 004a34f5
    jmp.d8 L_004a350b                            # 004a34ff
L_004a3501:
    # block 0x004a3501: entered by jne at 0x004a34f3, 1 instruction(s), falls into the block at 0x004a350b
    mov dword ptr [0x5bb1ca], 0x1                # 004a3501
L_004a350b:
    # block 0x004a350b: entered by jmp at 0x004a34ff, 1 instruction(s), falls into the block at 0x004a3515
    mov dword ptr [0x583999], 0x4                # 004a350b
L_004a3515:
    # block 0x004a3515: entered by je at 0x004a33ea, 8 instruction(s), ends with je to 0x004a3573 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 004a3515
    movsx edx, word ptr [ecx + field_49]         # 004a3518
    imul edx, edx, 0x1e5                         # 004a351c
    mov eax, dword ptr [ebp - local_5c]          # 004a3522
    mov ecx, dword ptr [eax + field_24]          # 004a3525
    movsx edx, word ptr [ecx + edx + field_167]  # 004a3528
    cmp edx, -0x1                                # 004a3530
    je.d8 L_004a3573                             # 004a3533
    # block 0x004a3535: entered by fall-through of je at 0x004a3533, 14 instruction(s), falls into the block at 0x004a3573
    mov eax, dword ptr [ebp - local_5c]          # 004a3535
    movsx ecx, word ptr [eax + field_49]         # 004a3538
    imul ecx, ecx, 0x1e5                         # 004a353c
    mov edx, dword ptr [ebp - local_5c]          # 004a3542
    mov eax, dword ptr [edx + field_24]          # 004a3545
    {load} xor edx, edx                          # 004a3548
    mov dl, byte ptr [eax + ecx + field_169]     # 004a354a
    mov eax, dword ptr [ebp - local_5c]          # 004a3551
    movsx ecx, word ptr [eax + field_49]         # 004a3554
    imul ecx, ecx, 0x1e5                         # 004a3558
    mov eax, dword ptr [ebp - local_5c]          # 004a355e
    mov eax, dword ptr [eax + field_24]          # 004a3561
    movsx ecx, word ptr [eax + ecx + field_167]  # 004a3564
    mov dword ptr [4*ecx + 0x585801], edx        # 004a356c
L_004a3573:
    # block 0x004a3573: entered by jmp at 0x004a30dc; jmp at 0x004a31f5; jmp at 0x004a33b4; je at 0x004a33c3; more, 7 instruction(s), calls FUN_0042ba3a, FUN_004a1cb1, falls into the block at 0x004a358b
    mov edx, dword ptr [ebp - local_5c]          # 004a3573
    mov ax, word ptr [edx + field_1e]            # 004a3576
    push eax                                     # 004a357a
    call FUN_0042ba3a                            # 004a357b
    add esp, 0x4                                 # 004a3580
    mov ecx, dword ptr [ebp - local_5c]          # 004a3583
    call FUN_004a1cb1                            # 004a3586
L_004a358b:
    # block 0x004a358b: entered by jmp at 0x004a21b8; jmp at 0x004a2624; jmp at 0x004a2f26, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004a358b
    pop esi                                      # 004a358c
    {load} mov esp, ebp                          # 004a358d
    pop ebp                                      # 004a358f
    ret 0x4                                      # 004a3590

# --- data items (not part of the function) -------------------------
.org 0x004a3593 - 0x401000
SWTAB_004a3593:  # 9 case address(es)
    .long L_004a2646 - .text + 0x401000
    .long L_004a2ed6 - .text + 0x401000
    .long L_004a2bf5 - .text + 0x401000
    .long L_004a2b6c - .text + 0x401000
    .long L_004a2e66 - .text + 0x401000
    .long L_004a2c4a - .text + 0x401000
    .long L_004a2d58 - .text + 0x401000
    .long L_004a2ce7 - .text + 0x401000
    .long L_004a2df5 - .text + 0x401000
.org 0x004a35b7 - 0x401000
SWTAB_004a35b7:  # 4 case address(es)
    .long L_004a2663 - .text + 0x401000
    .long L_004a2727 - .text + 0x401000
    .long L_004a278b - .text + 0x401000
    .long L_004a29ac - .text + 0x401000
.set SWTAB_004a3593_VA, SWTAB_004a3593 - .text + 0x401000
.set SWTAB_004a35b7_VA, SWTAB_004a35b7 - .text + 0x401000

