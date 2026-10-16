# FUN_004d812e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d812e
# extent:       0x004d812e-0x004d8618 (1258 code bytes)
# span:         0x004d812e-0x004d8618 (code 1258, tables 0, padding 0)
# sha256:       912d9e9add015da68393b25df2f8d7bb5fc13a9bc68c2e13dbed786786786f09
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d812e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_d, local_e, local_14, local_18, local_1c, local_20, local_21, local_22, local_28 and 7 more
# fields:       [eax + n] field_1, field_445, field_98a8, field_98ac; [ecx + n] field_98a8, field_98ac; [edx + n] field_1, field_98a8, field_98ac
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0042639d, FUN_004c97b4, FUN_0050cf61, FUN_0050cee4, FUN_004381f4, FUN_0043dbe3, FUN_00423c2b, FUN_004d3b95, FUN_00447c1c, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 329 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_d, 0xd  # offset -0xd
.equ local_e, 0xe  # offset -0xe
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_21, 0x21  # offset -0x21
.equ local_22, 0x22  # offset -0x22
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_35, 0x35  # offset -0x35
.equ local_36, 0x36  # offset -0x36
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_445, 0x445  # offset +0x445
.equ field_98a8, 0x98a8  # offset +0x98a8
.equ field_98ac, 0x98ac  # offset +0x98ac

# --- external targets -----------------------------------------------
.set FUN_00423c2b, .text + (0x00423c2b - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004381f4, .text + (0x004381f4 - 0x401000)
.set FUN_0043dbe3, .text + (0x0043dbe3 - 0x401000)
.set FUN_00447c1c, .text + (0x00447c1c - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d3b95, .text + (0x004d3b95 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x004d812e - 0x401000
.globl FUN_004d812e
FUN_004d812e:
    # block 0x004d812e: entry, 12 instruction(s), ends with jne to 0x004d817f (forward)
    push ebp                                     # 004d812e
    {load} mov ebp, esp                          # 004d812f
    sub esp, 0x40                                # 004d8131
    push esi                                     # 004d8134
    push edi                                     # 004d8135
    mov dword ptr [ebp - local_4], ecx           # 004d8136
    mov edi, 0x55a838                            # 004d8139
    mov esi, dword ptr [ebp + arg_8]             # 004d813e
    mov ecx, 0xe                                 # 004d8141
    {load} xor eax, eax                          # 004d8146
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d8148
    jne.d8 L_004d817f                            # 004d814a
    # block 0x004d814c: entered by fall-through of jne at 0x004d814a, 19 instruction(s), ends with forward jump to 0x004d81cf
    mov ecx, dword ptr [ebp - local_4]           # 004d814c
    add ecx, 0x29b                               # 004d814f
    {load} mov edi, ecx                          # 004d8155
    mov edx, dword ptr [ebp - local_4]           # 004d8157
    add edx, 0x333c2                             # 004d815a
    or ecx, -0x1                                 # 004d8160
    {load} xor eax, eax                          # 004d8163
    repne scasb al, byte ptr es:[edi]            # 004d8165
    not ecx                                      # 004d8167
    {load} sub edi, ecx                          # 004d8169
    {load} mov esi, edi                          # 004d816b
    {load} mov eax, ecx                          # 004d816d
    {load} mov edi, edx                          # 004d816f
    shr ecx, 0x2                                 # 004d8171
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d8174
    {load} mov ecx, eax                          # 004d8176
    and ecx, 0x3                                 # 004d8178
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d817b
    jmp.d8 L_004d81cf                            # 004d817d
L_004d817f:
    # block 0x004d817f: entered by jne at 0x004d814a, 32 instruction(s), falls into the block at 0x004d81cf
    mov edi, dword ptr [ebp + arg_8]             # 004d817f
    mov ecx, dword ptr [ebp - local_4]           # 004d8182
    add ecx, 0x333c2                             # 004d8185
    {load} mov edx, ecx                          # 004d818b
    or ecx, -0x1                                 # 004d818d
    {load} xor eax, eax                          # 004d8190
    repne scasb al, byte ptr es:[edi]            # 004d8192
    not ecx                                      # 004d8194
    {load} sub edi, ecx                          # 004d8196
    {load} mov esi, edi                          # 004d8198
    {load} mov eax, ecx                          # 004d819a
    {load} mov edi, edx                          # 004d819c
    shr ecx, 0x2                                 # 004d819e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d81a1
    {load} mov ecx, eax                          # 004d81a3
    and ecx, 0x3                                 # 004d81a5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d81a8
    mov edi, dword ptr [ebp + arg_8]             # 004d81aa
    mov edx, 0x63a565                            # 004d81ad
    or ecx, -0x1                                 # 004d81b2
    {load} xor eax, eax                          # 004d81b5
    repne scasb al, byte ptr es:[edi]            # 004d81b7
    not ecx                                      # 004d81b9
    {load} sub edi, ecx                          # 004d81bb
    {load} mov esi, edi                          # 004d81bd
    {load} mov eax, ecx                          # 004d81bf
    {load} mov edi, edx                          # 004d81c1
    shr ecx, 0x2                                 # 004d81c3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d81c6
    {load} mov ecx, eax                          # 004d81c8
    and ecx, 0x3                                 # 004d81ca
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d81cd
L_004d81cf:
    # block 0x004d81cf: entered by jmp at 0x004d817d, 33 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004d8273 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d81cf
    add ecx, 0x2af                               # 004d81d2
    push ecx                                     # 004d81d8
    push 0x55a848                                # 004d81d9
    mov edx, dword ptr [ebp - local_4]           # 004d81de
    add edx, 0x333e3                             # 004d81e1
    push edx                                     # 004d81e7
    call FUN_0050ca3e                            # 004d81e8
    add esp, 0xc                                 # 004d81ed
    mov eax, dword ptr [ebp - local_4]           # 004d81f0
    add eax, 0x333e3                             # 004d81f3
    push eax                                     # 004d81f8
    mov ecx, dword ptr [ebp - local_4]           # 004d81f9
    add ecx, 0x333c2                             # 004d81fc
    push ecx                                     # 004d8202
    push 0x63a3c9                                # 004d8203
    push 0x63a9b0                                # 004d8208
    mov edx, dword ptr [ebp - local_4]           # 004d820d
    add edx, 0x333e8                             # 004d8210
    push edx                                     # 004d8216
    call FUN_0050cd72                            # 004d8217
    add esp, 0x14                                # 004d821c
    push 0x55a84c                                # 004d821f
    mov eax, dword ptr [ebp - local_4]           # 004d8224
    add eax, 0x333e8                             # 004d8227
    push eax                                     # 004d822c
    call FUN_0050d0a9                            # 004d822d
    add esp, 0x8                                 # 004d8232
    mov ecx, dword ptr [ebp - local_4]           # 004d8235
    mov dword ptr [ecx + field_98ac], eax        # 004d8238
    mov edx, dword ptr [ebp - local_4]           # 004d823e
    cmp dword ptr [edx + field_98ac], 0x0        # 004d8241
    jne.d8 L_004d8273                            # 004d8248
    # block 0x004d824a: entered by fall-through of jne at 0x004d8248, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d8610
    mov eax, dword ptr [ebp - local_4]           # 004d824a
    add eax, 0x333e8                             # 004d824d
    push eax                                     # 004d8252
    push 0x55a850                                # 004d8253
    mov ecx, 0x583979                            # 004d8258
    call FUN_0042639d                            # 004d825d
    mov ecx, 0x5cf659                            # 004d8262
    call FUN_004c97b4                            # 004d8267
    {load} xor eax, eax                          # 004d826c
    jmp.d32 L_004d8610                           # 004d826e
L_004d8273:
    # block 0x004d8273: entered by jne at 0x004d8248, 12 instruction(s), calls FUN_0050cf61, ends with je to 0x004d82c4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d8273
    mov edx, dword ptr [ecx + field_98ac]        # 004d8276
    push edx                                     # 004d827c
    push 0x1                                     # 004d827d
    push 0x29b12                                 # 004d827f
    mov eax, dword ptr [ebp - local_4]           # 004d8284
    add eax, 0x98b0                              # 004d8287
    push eax                                     # 004d828c
    call FUN_0050cf61                            # 004d828d
    add esp, 0x10                                # 004d8292
    cmp eax, 0x1                                 # 004d8295
    je.d8 L_004d82c4                             # 004d8298
    # block 0x004d829a: entered by fall-through of je at 0x004d8298, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d8610
    mov ecx, dword ptr [ebp - local_4]           # 004d829a
    add ecx, 0x333e8                             # 004d829d
    push ecx                                     # 004d82a3
    push 0x55a868                                # 004d82a4
    mov ecx, 0x583979                            # 004d82a9
    call FUN_0042639d                            # 004d82ae
    mov ecx, 0x5cf659                            # 004d82b3
    call FUN_004c97b4                            # 004d82b8
    {load} xor eax, eax                          # 004d82bd
    jmp.d32 L_004d8610                           # 004d82bf
L_004d82c4:
    # block 0x004d82c4: entered by je at 0x004d8298, 4 instruction(s), falls into the block at 0x004d82d7
    mov dword ptr [ebp - local_8], 0x5b0113      # 004d82c4
    mov edx, dword ptr [ebp - local_4]           # 004d82cb
    add edx, 0x98b0                              # 004d82ce
    mov dword ptr [ebp - local_c], edx           # 004d82d4
L_004d82d7:
    # block 0x004d82d7: entered by jne at 0x004d8309, 6 instruction(s), ends with jne to 0x004d8314 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d82d7
    mov cl, byte ptr [eax]                       # 004d82da
    mov byte ptr [ebp - local_d], cl             # 004d82dc
    mov edx, dword ptr [ebp - local_8]           # 004d82df
    cmp cl, byte ptr [edx]                       # 004d82e2
    jne.d8 L_004d8314                            # 004d82e4
    # block 0x004d82e6: entered by fall-through of jne at 0x004d82e4, 2 instruction(s), ends with je to 0x004d830b (forward)
    cmp byte ptr [ebp - local_d], 0x0            # 004d82e6
    je.d8 L_004d830b                             # 004d82ea
    # block 0x004d82ec: entered by fall-through of je at 0x004d82ea, 6 instruction(s), ends with jne to 0x004d8314 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d82ec
    mov cl, byte ptr [eax + field_1]             # 004d82ef
    mov byte ptr [ebp - local_e], cl             # 004d82f2
    mov edx, dword ptr [ebp - local_8]           # 004d82f5
    cmp cl, byte ptr [edx + field_1]             # 004d82f8
    jne.d8 L_004d8314                            # 004d82fb
    # block 0x004d82fd: entered by fall-through of jne at 0x004d82fb, 4 instruction(s), ends with jne to 0x004d82d7 (backward)
    add dword ptr [ebp - local_c], 0x2           # 004d82fd
    add dword ptr [ebp - local_8], 0x2           # 004d8301
    cmp byte ptr [ebp - local_e], 0x0            # 004d8305
    jne.d8 L_004d82d7                            # 004d8309
L_004d830b:
    # block 0x004d830b: entered by je at 0x004d82ea; fall-through of jne at 0x004d8309, 2 instruction(s), ends with forward jump to 0x004d831c
    mov dword ptr [ebp - local_14], 0x0          # 004d830b
    jmp.d8 L_004d831c                            # 004d8312
L_004d8314:
    # block 0x004d8314: entered by jne at 0x004d82e4; jne at 0x004d82fb, 3 instruction(s), falls into the block at 0x004d831c
    {load} sbb eax, eax                          # 004d8314
    sbb eax, -0x1                                # 004d8316
    mov dword ptr [ebp - local_14], eax          # 004d8319
L_004d831c:
    # block 0x004d831c: entered by jmp at 0x004d8312, 4 instruction(s), ends with jne to 0x004d83f4 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004d831c
    mov dword ptr [ebp - local_18], ecx          # 004d831f
    cmp dword ptr [ebp - local_18], 0x0          # 004d8322
    jne.d32 L_004d83f4                           # 004d8326
    # block 0x004d832c: entered by fall-through of jne at 0x004d8326, 4 instruction(s), falls into the block at 0x004d833f
    mov dword ptr [ebp - local_1c], 0x5b0131     # 004d832c
    mov edx, dword ptr [ebp - local_4]           # 004d8333
    add edx, 0x98ce                              # 004d8336
    mov dword ptr [ebp - local_20], edx          # 004d833c
L_004d833f:
    # block 0x004d833f: entered by jne at 0x004d8371, 6 instruction(s), ends with jne to 0x004d837c (forward)
    mov eax, dword ptr [ebp - local_20]          # 004d833f
    mov cl, byte ptr [eax]                       # 004d8342
    mov byte ptr [ebp - local_21], cl            # 004d8344
    mov edx, dword ptr [ebp - local_1c]          # 004d8347
    cmp cl, byte ptr [edx]                       # 004d834a
    jne.d8 L_004d837c                            # 004d834c
    # block 0x004d834e: entered by fall-through of jne at 0x004d834c, 2 instruction(s), ends with je to 0x004d8373 (forward)
    cmp byte ptr [ebp - local_21], 0x0           # 004d834e
    je.d8 L_004d8373                             # 004d8352
    # block 0x004d8354: entered by fall-through of je at 0x004d8352, 6 instruction(s), ends with jne to 0x004d837c (forward)
    mov eax, dword ptr [ebp - local_20]          # 004d8354
    mov cl, byte ptr [eax + field_1]             # 004d8357
    mov byte ptr [ebp - local_22], cl            # 004d835a
    mov edx, dword ptr [ebp - local_1c]          # 004d835d
    cmp cl, byte ptr [edx + field_1]             # 004d8360
    jne.d8 L_004d837c                            # 004d8363
    # block 0x004d8365: entered by fall-through of jne at 0x004d8363, 4 instruction(s), ends with jne to 0x004d833f (backward)
    add dword ptr [ebp - local_20], 0x2          # 004d8365
    add dword ptr [ebp - local_1c], 0x2          # 004d8369
    cmp byte ptr [ebp - local_22], 0x0           # 004d836d
    jne.d8 L_004d833f                            # 004d8371
L_004d8373:
    # block 0x004d8373: entered by je at 0x004d8352; fall-through of jne at 0x004d8371, 2 instruction(s), ends with forward jump to 0x004d8384
    mov dword ptr [ebp - local_28], 0x0          # 004d8373
    jmp.d8 L_004d8384                            # 004d837a
L_004d837c:
    # block 0x004d837c: entered by jne at 0x004d834c; jne at 0x004d8363, 3 instruction(s), falls into the block at 0x004d8384
    {load} sbb eax, eax                          # 004d837c
    sbb eax, -0x1                                # 004d837e
    mov dword ptr [ebp - local_28], eax          # 004d8381
L_004d8384:
    # block 0x004d8384: entered by jmp at 0x004d837a, 4 instruction(s), ends with jne to 0x004d83f4 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004d8384
    mov dword ptr [ebp - local_2c], ecx          # 004d8387
    cmp dword ptr [ebp - local_2c], 0x0          # 004d838a
    jne.d8 L_004d83f4                            # 004d838e
    # block 0x004d8390: entered by fall-through of jne at 0x004d838e, 4 instruction(s), falls into the block at 0x004d83a3
    mov dword ptr [ebp - local_30], 0x5b014f     # 004d8390
    mov edx, dword ptr [ebp - local_4]           # 004d8397
    add edx, 0x98ec                              # 004d839a
    mov dword ptr [ebp - local_34], edx          # 004d83a0
L_004d83a3:
    # block 0x004d83a3: entered by jne at 0x004d83d5, 6 instruction(s), ends with jne to 0x004d83e0 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d83a3
    mov cl, byte ptr [eax]                       # 004d83a6
    mov byte ptr [ebp - local_35], cl            # 004d83a8
    mov edx, dword ptr [ebp - local_30]          # 004d83ab
    cmp cl, byte ptr [edx]                       # 004d83ae
    jne.d8 L_004d83e0                            # 004d83b0
    # block 0x004d83b2: entered by fall-through of jne at 0x004d83b0, 2 instruction(s), ends with je to 0x004d83d7 (forward)
    cmp byte ptr [ebp - local_35], 0x0           # 004d83b2
    je.d8 L_004d83d7                             # 004d83b6
    # block 0x004d83b8: entered by fall-through of je at 0x004d83b6, 6 instruction(s), ends with jne to 0x004d83e0 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004d83b8
    mov cl, byte ptr [eax + field_1]             # 004d83bb
    mov byte ptr [ebp - local_36], cl            # 004d83be
    mov edx, dword ptr [ebp - local_30]          # 004d83c1
    cmp cl, byte ptr [edx + field_1]             # 004d83c4
    jne.d8 L_004d83e0                            # 004d83c7
    # block 0x004d83c9: entered by fall-through of jne at 0x004d83c7, 4 instruction(s), ends with jne to 0x004d83a3 (backward)
    add dword ptr [ebp - local_34], 0x2          # 004d83c9
    add dword ptr [ebp - local_30], 0x2          # 004d83cd
    cmp byte ptr [ebp - local_36], 0x0           # 004d83d1
    jne.d8 L_004d83a3                            # 004d83d5
L_004d83d7:
    # block 0x004d83d7: entered by je at 0x004d83b6; fall-through of jne at 0x004d83d5, 2 instruction(s), ends with forward jump to 0x004d83e8
    mov dword ptr [ebp - local_3c], 0x0          # 004d83d7
    jmp.d8 L_004d83e8                            # 004d83de
L_004d83e0:
    # block 0x004d83e0: entered by jne at 0x004d83b0; jne at 0x004d83c7, 3 instruction(s), falls into the block at 0x004d83e8
    {load} sbb eax, eax                          # 004d83e0
    sbb eax, -0x1                                # 004d83e2
    mov dword ptr [ebp - local_3c], eax          # 004d83e5
L_004d83e8:
    # block 0x004d83e8: entered by jmp at 0x004d83de, 4 instruction(s), ends with je to 0x004d841e (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004d83e8
    mov dword ptr [ebp - local_40], ecx          # 004d83eb
    cmp dword ptr [ebp - local_40], 0x0          # 004d83ee
    je.d8 L_004d841e                             # 004d83f2
L_004d83f4:
    # block 0x004d83f4: entered by jne at 0x004d8326; jne at 0x004d838e; fall-through of je at 0x004d83f2, 10 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d8610
    mov edx, dword ptr [ebp - local_4]           # 004d83f4
    add edx, 0x333e8                             # 004d83f7
    push edx                                     # 004d83fd
    push 0x55a880                                # 004d83fe
    mov ecx, 0x583979                            # 004d8403
    call FUN_0042639d                            # 004d8408
    mov ecx, 0x5cf659                            # 004d840d
    call FUN_004c97b4                            # 004d8412
    {load} xor eax, eax                          # 004d8417
    jmp.d32 L_004d8610                           # 004d8419
L_004d841e:
    # block 0x004d841e: entered by je at 0x004d83f2, 7 instruction(s), calls FUN_0050cee4, ends with jne to 0x004d8440 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d841e
    mov ecx, dword ptr [eax + field_98ac]        # 004d8421
    push ecx                                     # 004d8427
    call FUN_0050cee4                            # 004d8428
    add esp, 0x4                                 # 004d842d
    cmp dword ptr [0x583999], 0x0                # 004d8430
    jne.d8 L_004d8440                            # 004d8437
    # block 0x004d8439: entered by fall-through of jne at 0x004d8437, 2 instruction(s), calls FUN_004381f4, ends with forward jump to 0x004d844a
    call FUN_004381f4                            # 004d8439
    jmp.d8 L_004d844a                            # 004d843e
L_004d8440:
    # block 0x004d8440: entered by jne at 0x004d8437, 3 instruction(s), calls FUN_0043dbe3, falls into the block at 0x004d844a
    push 0x0                                     # 004d8440
    call FUN_0043dbe3                            # 004d8442
    add esp, 0x4                                 # 004d8447
L_004d844a:
    # block 0x004d844a: entered by jmp at 0x004d843e, 24 instruction(s), ends with forward jump to 0x004d84e9
    mov ecx, 0x84a4                              # 004d844a
    mov esi, dword ptr [ebp - local_4]           # 004d844f
    add esi, 0x9912                              # 004d8452
    mov edi, 0x58397d                            # 004d8458
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d845d
    movsw word ptr es:[edi], word ptr [esi]      # 004d845f
    movsb byte ptr es:[edi], byte ptr [esi]      # 004d8461
    mov ecx, 0x2207                              # 004d8462
    mov esi, dword ptr [ebp - local_4]           # 004d8467
    add esi, 0x2aba5                             # 004d846a
    mov edi, 0x5bb22e                            # 004d8470
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d8475
    movsb byte ptr es:[edi], byte ptr [esi]      # 004d8477
    mov dword ptr [0x5bb2f4], 0x0                # 004d8478
    mov dword ptr [0x5bb308], 0x0                # 004d8482
    mov byte ptr [0x5bb320], 0x0                 # 004d848c
    mov dword ptr [0x5bb300], 0x0                # 004d8493
    mov dword ptr [0x5bb2f8], 0x0                # 004d849d
    mov dword ptr [0x5bb2fc], 0x0                # 004d84a7
    mov dword ptr [0x5bb4db], 0x0                # 004d84b1
    mov dword ptr [0x5bb4df], 0x0                # 004d84bb
    mov edx, dword ptr [ebp - local_4]           # 004d84c5
    mov dword ptr [edx + field_98a8], 0x0        # 004d84c8
    jmp.d8 L_004d84e9                            # 004d84d2
L_004d84d4:
    # block 0x004d84d4: entered by jmp at 0x004d8559, 5 instruction(s), falls into the block at 0x004d84e9
    mov eax, dword ptr [ebp - local_4]           # 004d84d4
    mov ecx, dword ptr [eax + field_98a8]        # 004d84d7
    add ecx, 0x1                                 # 004d84dd
    mov edx, dword ptr [ebp - local_4]           # 004d84e0
    mov dword ptr [edx + field_98a8], ecx        # 004d84e3
L_004d84e9:
    # block 0x004d84e9: entered by jmp at 0x004d84d2, 3 instruction(s), ends with jge to 0x004d855e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d84e9
    cmp dword ptr [eax + field_98a8], 0xf0       # 004d84ec
    jge.d8 L_004d855e                            # 004d84f6
    # block 0x004d84f8: entered by fall-through of jge at 0x004d84f6, 17 instruction(s), ends with backward jump to 0x004d84d4
    mov ecx, dword ptr [ebp - local_4]           # 004d84f8
    mov edx, dword ptr [ecx + field_98a8]        # 004d84fb
    imul edx, edx, 0x8d                          # 004d8501
    mov byte ptr [edx + 0x5bb5e3], 0x0           # 004d8507
    mov eax, dword ptr [ebp - local_4]           # 004d850e
    mov ecx, dword ptr [eax + field_98a8]        # 004d8511
    imul ecx, ecx, 0x8d                          # 004d8517
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 004d851d
    mov edx, dword ptr [ebp - local_4]           # 004d8527
    mov eax, dword ptr [edx + field_98a8]        # 004d852a
    imul eax, eax, 0x8d                          # 004d8530
    mov dword ptr [eax + 0x5bb638], 0x1          # 004d8536
    mov ecx, dword ptr [ebp - local_4]           # 004d8540
    mov edx, dword ptr [ecx + field_98a8]        # 004d8543
    imul edx, edx, 0x8d                          # 004d8549
    mov dword ptr [edx + 0x5bb63c], 0x0          # 004d854f
    jmp.d32 L_004d84d4                           # 004d8559
L_004d855e:
    # block 0x004d855e: entered by jge at 0x004d84f6, 5 instruction(s), calls FUN_00423c2b, ends with forward jump to 0x004d858c
    mov ecx, 0x63786d                            # 004d855e
    call FUN_00423c2b                            # 004d8563
    mov eax, dword ptr [ebp - local_4]           # 004d8568
    mov dword ptr [eax + field_98a8], 0x0        # 004d856b
    jmp.d8 L_004d858c                            # 004d8575
L_004d8577:
    # block 0x004d8577: entered by jmp at 0x004d85bf, 5 instruction(s), falls into the block at 0x004d858c
    mov ecx, dword ptr [ebp - local_4]           # 004d8577
    mov edx, dword ptr [ecx + field_98a8]        # 004d857a
    add edx, 0x1                                 # 004d8580
    mov eax, dword ptr [ebp - local_4]           # 004d8583
    mov dword ptr [eax + field_98a8], edx        # 004d8586
L_004d858c:
    # block 0x004d858c: entered by jmp at 0x004d8575, 3 instruction(s), ends with jge to 0x004d85c1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d858c
    cmp dword ptr [ecx + field_98a8], 0x19       # 004d858f
    jge.d8 L_004d85c1                            # 004d8596
    # block 0x004d8598: entered by fall-through of jge at 0x004d8596, 7 instruction(s), ends with backward jump to 0x004d8577
    mov edx, dword ptr [ebp - local_4]           # 004d8598
    mov eax, dword ptr [edx + field_98a8]        # 004d859b
    mov dword ptr [4*eax + 0x5bb445], 0x0        # 004d85a1
    mov ecx, dword ptr [ebp - local_4]           # 004d85ac
    mov edx, dword ptr [ecx + field_98a8]        # 004d85af
    mov word ptr [2*edx + 0x5bb4a9], 0x0         # 004d85b5
    jmp.d8 L_004d8577                            # 004d85bf
L_004d85c1:
    # block 0x004d85c1: entered by jge at 0x004d8596, 12 instruction(s), calls FUN_004d3b95, FUN_00447c1c, KERNEL32.dll!GetTickCount, falls into the block at 0x004d8610
    mov ecx, 0x61c387                            # 004d85c1
    call FUN_004d3b95                            # 004d85c6
    mov ecx, 0x6198d7                            # 004d85cb
    call FUN_00447c1c                            # 004d85d0
    mov dword ptr [0x583999], 0x4                # 004d85d5
    mov dword ptr [0x583981], 0xe                # 004d85df
    call dword ptr [0x52a23c]                    # 004d85e9
    mov dword ptr [0x585d33], eax                # 004d85ef
    mov eax, dword ptr [ebp - local_4]           # 004d85f4
    mov dword ptr [eax + field_445], 0x1         # 004d85f7
    mov dword ptr [0x5bb1e2], 0x1                # 004d8601
    mov eax, 0x1                                 # 004d860b
L_004d8610:
    # block 0x004d8610: entered by jmp at 0x004d826e; jmp at 0x004d82bf; jmp at 0x004d8419, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004d8610
    pop esi                                      # 004d8611
    {load} mov esp, ebp                          # 004d8612
    pop ebp                                      # 004d8614
    ret 0x4                                      # 004d8615

