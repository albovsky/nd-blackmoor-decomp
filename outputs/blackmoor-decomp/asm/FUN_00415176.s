# FUN_00415176
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415176
# extent:       0x00415176-0x0041546f (761 code bytes)
# span:         0x00415176-0x0041546f (code 761, tables 0, padding 0)
# sha256:       16cf22fcaddba79a33737a292cb5930fc1a2cb32111e82b8e939d9c56ccf60d0
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         avf_get_chunk
# naming:       native port src/avf_decoder.c:avf_get_chunk (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the note is the acceptance note, a statement about the native port
# name-note:    Chunk fetch (key, then deltas). Fatal paths are status returns, buffers passed in, 0x4c7314 is the convert hook, extra native rejections of truncated input. Oracle not run whole.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_6, field_21, field_31, field_35, field_3d, field_49; [ecx + n] field_e, field_21, field_31, field_35, field_39, field_3d, field_41, field_45, field_49; [edx + n] field_6, field_a, field_e, field_35, field_41, field_45, field_49
# callees:      calls FUN_0050ca3e, FUN_004150af, FUN_004159db, FUN_004c7314, FUN_0051dc43, FUN_00416af3, FUN_0051dc6c, FUN_00415011, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:avf_get_chunk (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 258 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_21, 0x21  # offset +0x21
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_004150af, .text + (0x004150af - 0x401000)
.set FUN_004159db, .text + (0x004159db - 0x401000)
.set FUN_00416af3, .text + (0x00416af3 - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00415176 - 0x401000
.globl FUN_00415176
FUN_00415176:
    # block 0x00415176: entry, 7 instruction(s), ends with jne to 0x004151a8 (forward)
    push ebp                                     # 00415176
    {load} mov ebp, esp                          # 00415177
    sub esp, 0x10                                # 00415179
    mov dword ptr [ebp - local_10], ecx          # 0041517c
    mov eax, dword ptr [ebp + arg_8]             # 0041517f
    cmp dword ptr [eax + field_21], 0x0          # 00415182
    jne.d8 L_004151a8                            # 00415186
    # block 0x00415188: entered by fall-through of jne at 0x00415186, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00415467
    mov ecx, dword ptr [ebp + arg_8]             # 00415188
    add ecx, 0x4d                                # 0041518b
    push ecx                                     # 0041518e
    push 0x541aa8                                # 0041518f
    mov edx, dword ptr [ebp - local_10]          # 00415194
    add edx, 0x1c                                # 00415197
    push edx                                     # 0041519a
    call FUN_0050ca3e                            # 0041519b
    add esp, 0xc                                 # 004151a0
    jmp.d32 L_00415467                           # 004151a3
L_004151a8:
    # block 0x004151a8: entered by jne at 0x00415186, 8 instruction(s), ends with je to 0x004151db (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004151a8
    imul eax, eax, 0x13                          # 004151ac
    mov ecx, dword ptr [ebp + arg_8]             # 004151af
    mov edx, dword ptr [ecx + field_21]          # 004151b2
    {load} add edx, eax                          # 004151b5
    mov dword ptr [ebp - local_4], edx           # 004151b7
    cmp dword ptr [ebp + arg_14], 0x0            # 004151ba
    je.d8 L_004151db                             # 004151be
    # block 0x004151c0: entered by fall-through of je at 0x004151be, 3 instruction(s), ends with je to 0x004151db (forward)
    movsx eax, word ptr [ebp + arg_18]           # 004151c0
    test eax, eax                                # 004151c4
    je.d8 L_004151db                             # 004151c6
    # block 0x004151c8: entered by fall-through of je at 0x004151c6, 6 instruction(s), falls into the block at 0x004151db
    mov ecx, dword ptr [ebp + arg_8]             # 004151c8
    mov edx, dword ptr [ebp + arg_14]            # 004151cb
    mov dword ptr [ecx + field_49], edx          # 004151ce
    movsx eax, word ptr [ebp + arg_18]           # 004151d1
    mov ecx, dword ptr [ebp + arg_8]             # 004151d5
    mov dword ptr [ecx + field_45], eax          # 004151d8
L_004151db:
    # block 0x004151db: entered by je at 0x004151be; je at 0x004151c6, 5 instruction(s), ends with jne to 0x0041522e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004151db
    {load} xor eax, eax                          # 004151de
    mov al, byte ptr [edx + field_e]             # 004151e0
    cmp eax, 0x2                                 # 004151e3
    jne.d8 L_0041522e                            # 004151e6
    # block 0x004151e8: entered by fall-through of jne at 0x004151e6, 3 instruction(s), ends with je to 0x00415209 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004151e8
    cmp dword ptr [ecx + field_45], -0x1         # 004151eb
    je.d8 L_00415209                             # 004151ef
    # block 0x004151f1: entered by fall-through of je at 0x004151ef, 3 instruction(s), ends with je to 0x00415209 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004151f1
    cmp dword ptr [edx + field_49], 0x0          # 004151f4
    je.d8 L_00415209                             # 004151f8
    # block 0x004151fa: entered by fall-through of je at 0x004151f8, 5 instruction(s), ends with je to 0x0041522e (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004151fa
    sub eax, 0x1                                 # 004151fe
    mov ecx, dword ptr [ebp + arg_8]             # 00415201
    cmp dword ptr [ecx + field_45], eax          # 00415204
    je.d8 L_0041522e                             # 00415207
L_00415209:
    # block 0x00415209: entered by je at 0x004151ef; je at 0x004151f8; fall-through of je at 0x00415207, 12 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00415465
    mov edx, dword ptr [ebp + arg_8]             # 00415209
    add edx, 0x4d                                # 0041520c
    push edx                                     # 0041520f
    movsx eax, word ptr [ebp + arg_c]            # 00415210
    push eax                                     # 00415214
    push 0x541aec                                # 00415215
    mov ecx, dword ptr [ebp - local_10]          # 0041521a
    add ecx, 0x1c                                # 0041521d
    push ecx                                     # 00415220
    call FUN_0050ca3e                            # 00415221
    add esp, 0x10                                # 00415226
    jmp.d32 L_00415465                           # 00415229
L_0041522e:
    # block 0x0041522e: entered by jne at 0x004151e6; je at 0x00415207, 3 instruction(s), ends with jne to 0x0041526a (forward)
    mov edx, dword ptr [ebp - local_4]           # 0041522e
    cmp dword ptr [edx + field_a], 0x0           # 00415231
    jne.d8 L_0041526a                            # 00415235
    # block 0x00415237: entered by fall-through of jne at 0x00415235, 3 instruction(s), ends with jne to 0x0041526a (forward)
    mov eax, dword ptr [ebp - local_4]           # 00415237
    cmp dword ptr [eax + field_6], 0x0           # 0041523a
    jne.d8 L_0041526a                            # 0041523e
    # block 0x00415240: entered by fall-through of jne at 0x0041523e, 2 instruction(s), ends with je to 0x00415255 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 00415240
    je.d8 L_00415255                             # 00415244
    # block 0x00415246: entered by fall-through of je at 0x00415244, 5 instruction(s), falls into the block at 0x00415255
    mov ecx, dword ptr [ebp + arg_10]            # 00415246
    mov dx, word ptr [ecx]                       # 00415249
    or dl, 0xc                                   # 0041524c
    mov eax, dword ptr [ebp + arg_10]            # 0041524f
    mov word ptr [eax], dx                       # 00415252
L_00415255:
    # block 0x00415255: entered by je at 0x00415244, 6 instruction(s), ends with forward jump to 0x00415469
    movsx ecx, word ptr [ebp + arg_c]            # 00415255
    mov edx, dword ptr [ebp + arg_8]             # 00415259
    mov dword ptr [edx + field_45], ecx          # 0041525c
    mov eax, dword ptr [ebp + arg_8]             # 0041525f
    mov eax, dword ptr [eax + field_49]          # 00415262
    jmp.d32 L_00415469                           # 00415265
L_0041526a:
    # block 0x0041526a: entered by jne at 0x00415235; jne at 0x0041523e, 23 instruction(s), calls FUN_004150af, FUN_004159db, ends with jne to 0x004152f9 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041526a
    mov edx, dword ptr [ebp - local_4]           # 0041526d
    mov eax, dword ptr [edx + field_a]           # 00415270
    mov dword ptr [ecx + field_3d], eax          # 00415273
    mov ecx, dword ptr [ebp + arg_8]             # 00415276
    mov edx, dword ptr [ebp - local_4]           # 00415279
    mov eax, dword ptr [edx + field_6]           # 0041527c
    mov dword ptr [ecx + field_39], eax          # 0041527f
    mov ecx, dword ptr [ebp + arg_8]             # 00415282
    push ecx                                     # 00415285
    mov ecx, dword ptr [ebp - local_10]          # 00415286
    call FUN_004150af                            # 00415289
    mov dx, word ptr [ebp + arg_c]               # 0041528e
    push edx                                     # 00415292
    mov eax, dword ptr [ebp + arg_8]             # 00415293
    push eax                                     # 00415296
    mov ecx, dword ptr [ebp - local_10]          # 00415297
    call FUN_004159db                            # 0041529a
    mov ecx, dword ptr [ebp - local_4]           # 0041529f
    {load} xor edx, edx                          # 004152a2
    mov dl, byte ptr [ecx + field_e]             # 004152a4
    test edx, edx                                # 004152a7
    jne.d8 L_004152f9                            # 004152a9
    # block 0x004152ab: entered by fall-through of jne at 0x004152a9, 10 instruction(s), calls FUN_004c7314, ends with je to 0x004152d8 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004152ab
    mov ecx, dword ptr [eax + field_3d]          # 004152ae
    push ecx                                     # 004152b1
    mov edx, dword ptr [ebp + arg_8]             # 004152b2
    mov eax, dword ptr [edx + field_35]          # 004152b5
    push eax                                     # 004152b8
    mov ecx, 0x5cf659                            # 004152b9
    call FUN_004c7314                            # 004152be
    cmp dword ptr [ebp + arg_10], 0x0            # 004152c3
    je.d8 L_004152d8                             # 004152c7
    # block 0x004152c9: entered by fall-through of je at 0x004152c7, 5 instruction(s), falls into the block at 0x004152d8
    mov ecx, dword ptr [ebp + arg_10]            # 004152c9
    mov dx, word ptr [ecx]                       # 004152cc
    or dl, 0x1                                   # 004152cf
    mov eax, dword ptr [ebp + arg_10]            # 004152d2
    mov word ptr [eax], dx                       # 004152d5
L_004152d8:
    # block 0x004152d8: entered by je at 0x004152c7, 10 instruction(s), ends with forward jump to 0x00415469
    movsx ecx, word ptr [ebp + arg_c]            # 004152d8
    mov edx, dword ptr [ebp + arg_8]             # 004152dc
    mov dword ptr [edx + field_45], ecx          # 004152df
    mov eax, dword ptr [ebp + arg_8]             # 004152e2
    mov ecx, dword ptr [ebp + arg_8]             # 004152e5
    mov edx, dword ptr [ecx + field_35]          # 004152e8
    mov dword ptr [eax + field_49], edx          # 004152eb
    mov eax, dword ptr [ebp + arg_8]             # 004152ee
    mov eax, dword ptr [eax + field_35]          # 004152f1
    jmp.d32 L_00415469                           # 004152f4
L_004152f9:
    # block 0x004152f9: entered by jne at 0x004152a9, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041533a (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004152f9
    mov edx, dword ptr [ecx + field_41]          # 004152fc
    push edx                                     # 004152ff
    call FUN_0051dc43                            # 00415300
    add esp, 0x4                                 # 00415305
    mov dword ptr [ebp - local_8], eax           # 00415308
    mov eax, dword ptr [ebp + arg_8]             # 0041530b
    mov ecx, dword ptr [ebp - local_8]           # 0041530e
    mov dword ptr [eax + field_31], ecx          # 00415311
    cmp dword ptr [ebp - local_8], 0x0           # 00415314
    jne.d8 L_0041533a                            # 00415318
    # block 0x0041531a: entered by fall-through of jne at 0x00415318, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00415463
    mov edx, dword ptr [ebp + arg_8]             # 0041531a
    add edx, 0x4d                                # 0041531d
    push edx                                     # 00415320
    push 0x541b38                                # 00415321
    mov eax, dword ptr [ebp - local_10]          # 00415326
    add eax, 0x1c                                # 00415329
    push eax                                     # 0041532c
    call FUN_0050ca3e                            # 0041532d
    add esp, 0xc                                 # 00415332
    jmp.d32 L_00415463                           # 00415335
L_0041533a:
    # block 0x0041533a: entered by jne at 0x00415318, 5 instruction(s), ends with jne to 0x00415383 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0041533a
    {load} xor edx, edx                          # 0041533d
    mov dl, byte ptr [ecx + field_e]             # 0041533f
    cmp edx, 0x1                                 # 00415342
    jne.d8 L_00415383                            # 00415345
    # block 0x00415347: entered by fall-through of jne at 0x00415345, 2 instruction(s), ends with je to 0x0041535c (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 00415347
    je.d8 L_0041535c                             # 0041534b
    # block 0x0041534d: entered by fall-through of je at 0x0041534b, 5 instruction(s), falls into the block at 0x0041535c
    mov eax, dword ptr [ebp + arg_10]            # 0041534d
    mov cx, word ptr [eax]                       # 00415350
    or cl, 0x2                                   # 00415353
    mov edx, dword ptr [ebp + arg_10]            # 00415356
    mov word ptr [edx], cx                       # 00415359
L_0041535c:
    # block 0x0041535c: entered by je at 0x0041534b, 16 instruction(s), calls FUN_00416af3, ends with forward jump to 0x004153f3
    push 0x0                                     # 0041535c
    push 0x0                                     # 0041535e
    mov eax, dword ptr [ebp + arg_8]             # 00415360
    mov ecx, dword ptr [eax + field_35]          # 00415363
    push ecx                                     # 00415366
    mov edx, dword ptr [ebp + arg_8]             # 00415367
    mov eax, dword ptr [edx + field_41]          # 0041536a
    push eax                                     # 0041536d
    mov ecx, dword ptr [ebp + arg_8]             # 0041536e
    mov edx, dword ptr [ecx + field_31]          # 00415371
    push edx                                     # 00415374
    mov eax, dword ptr [ebp - local_4]           # 00415375
    push eax                                     # 00415378
    mov ecx, dword ptr [ebp - local_10]          # 00415379
    call FUN_00416af3                            # 0041537c
    jmp.d8 L_004153f3                            # 00415381
L_00415383:
    # block 0x00415383: entered by jne at 0x00415345, 5 instruction(s), ends with jne to 0x004153d1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00415383
    {load} xor edx, edx                          # 00415386
    mov dl, byte ptr [ecx + field_e]             # 00415388
    cmp edx, 0x2                                 # 0041538b
    jne.d8 L_004153d1                            # 0041538e
    # block 0x00415390: entered by fall-through of jne at 0x0041538e, 2 instruction(s), ends with je to 0x004153a5 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 00415390
    je.d8 L_004153a5                             # 00415394
    # block 0x00415396: entered by fall-through of je at 0x00415394, 5 instruction(s), falls into the block at 0x004153a5
    mov eax, dword ptr [ebp + arg_10]            # 00415396
    mov cx, word ptr [eax]                       # 00415399
    or cl, 0x4                                   # 0041539c
    mov edx, dword ptr [ebp + arg_10]            # 0041539f
    mov word ptr [edx], cx                       # 004153a2
L_004153a5:
    # block 0x004153a5: entered by je at 0x00415394, 18 instruction(s), calls FUN_00416af3, ends with forward jump to 0x004153f3
    push 0x0                                     # 004153a5
    mov eax, dword ptr [ebp + arg_8]             # 004153a7
    mov ecx, dword ptr [eax + field_49]          # 004153aa
    push ecx                                     # 004153ad
    mov edx, dword ptr [ebp + arg_8]             # 004153ae
    mov eax, dword ptr [edx + field_35]          # 004153b1
    push eax                                     # 004153b4
    mov ecx, dword ptr [ebp + arg_8]             # 004153b5
    mov edx, dword ptr [ecx + field_41]          # 004153b8
    push edx                                     # 004153bb
    mov eax, dword ptr [ebp + arg_8]             # 004153bc
    mov ecx, dword ptr [eax + field_31]          # 004153bf
    push ecx                                     # 004153c2
    mov edx, dword ptr [ebp - local_4]           # 004153c3
    push edx                                     # 004153c6
    mov ecx, dword ptr [ebp - local_10]          # 004153c7
    call FUN_00416af3                            # 004153ca
    jmp.d8 L_004153f3                            # 004153cf
L_004153d1:
    # block 0x004153d1: entered by jne at 0x0041538e, 12 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00415461
    mov eax, dword ptr [ebp + arg_8]             # 004153d1
    add eax, 0x4d                                # 004153d4
    push eax                                     # 004153d7
    movsx ecx, word ptr [ebp + arg_c]            # 004153d8
    push ecx                                     # 004153dc
    push 0x541b98                                # 004153dd
    mov edx, dword ptr [ebp - local_10]          # 004153e2
    add edx, 0x1c                                # 004153e5
    push edx                                     # 004153e8
    call FUN_0050ca3e                            # 004153e9
    add esp, 0x10                                # 004153ee
    jmp.d8 L_00415461                            # 004153f1
L_004153f3:
    # block 0x004153f3: entered by jmp at 0x00415381; jmp at 0x004153cf, 19 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x00415469
    mov eax, dword ptr [ebp + arg_8]             # 004153f3
    mov ecx, dword ptr [eax + field_35]          # 004153f6
    mov dword ptr [ebp - local_c], ecx           # 004153f9
    mov edx, dword ptr [ebp - local_c]           # 004153fc
    push edx                                     # 004153ff
    call FUN_0051dc6c                            # 00415400
    add esp, 0x4                                 # 00415405
    mov eax, dword ptr [ebp + arg_8]             # 00415408
    mov dword ptr [eax + field_35], 0x0          # 0041540b
    movsx ecx, word ptr [ebp + arg_c]            # 00415412
    mov edx, dword ptr [ebp + arg_8]             # 00415416
    mov dword ptr [edx + field_45], ecx          # 00415419
    mov eax, dword ptr [ebp + arg_8]             # 0041541c
    mov ecx, dword ptr [ebp + arg_8]             # 0041541f
    mov edx, dword ptr [ecx + field_31]          # 00415422
    mov dword ptr [eax + field_49], edx          # 00415425
    mov eax, dword ptr [ebp + arg_8]             # 00415428
    mov eax, dword ptr [eax + field_31]          # 0041542b
    jmp.d8 L_00415469                            # 0041542e
L_00415430:
    # block 0x00415430: entered by jmp at 0x00415461; jmp at 0x00415463; jmp at 0x00415465; jmp at 0x00415467, 12 instruction(s), calls FUN_00415011, FUN_004264e8, FUN_004c97b4, falls into the block at 0x00415461
    mov ecx, dword ptr [ebp + arg_8]             # 00415430
    push ecx                                     # 00415433
    mov ecx, dword ptr [ebp - local_10]          # 00415434
    call FUN_00415011                            # 00415437
    mov edx, dword ptr [ebp - local_10]          # 0041543c
    add edx, 0x1c                                # 0041543f
    push edx                                     # 00415442
    mov ecx, 0x583979                            # 00415443
    call FUN_004264e8                            # 00415448
    mov dword ptr [0x63a58a], 0x4                # 0041544d
    mov ecx, 0x5cf659                            # 00415457
    call FUN_004c97b4                            # 0041545c
L_00415461:
    # block 0x00415461: entered by jmp at 0x004153f1, 1 instruction(s), ends with backward jump to 0x00415430
    jmp.d8 L_00415430                            # 00415461
L_00415463:
    # block 0x00415463: entered by jmp at 0x00415335, 1 instruction(s), ends with backward jump to 0x00415430
    jmp.d8 L_00415430                            # 00415463
L_00415465:
    # block 0x00415465: entered by jmp at 0x00415229, 1 instruction(s), ends with backward jump to 0x00415430
    jmp.d8 L_00415430                            # 00415465
L_00415467:
    # block 0x00415467: entered by jmp at 0x004151a3, 1 instruction(s), ends with backward jump to 0x00415430
    jmp.d8 L_00415430                            # 00415467
L_00415469:
    # block 0x00415469: entered by jmp at 0x00415265; jmp at 0x004152f4; jmp at 0x0041542e, 3 instruction(s), ends with ret 0x14
    {load} mov esp, ebp                          # 00415469
    pop ebp                                      # 0041546b
    ret 0x14                                     # 0041546c

