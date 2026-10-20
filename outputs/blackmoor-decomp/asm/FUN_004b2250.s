# FUN_004b2250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b2250
# extent:       0x004b2250-0x004b2917 (1735 code bytes)
# span:         0x004b2250-0x004b2917 (code 1735, tables 0, padding 0)
# sha256:       26f1244dce9db10223e966d308bf6ad442563eb9a316bb54e9c8cc93862c0f54
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b2250_hit_test
# naming:       native port src/original_methods_fl25d.c:m4b2250_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b2250_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25d-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_1a, field_23, field_28, field_41, field_43, field_18e, field_378, field_1515, field_1531; [ecx + n] field_1c, field_20, field_21, field_24, field_28, field_3f, field_43, field_5f, field_6b, field_17d, field_19a, field_370 and 2 more; [edx + n] field_18, field_1a, field_1c, field_1e, field_21, field_23, field_24, field_43, field_67, field_17d, field_192, field_196 and 3 more
# callees:      calls FUN_004afec1, FUN_004b2917
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25d.c:m4b2250_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 476 instruction(s), 43 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_3f, 0x3f  # offset +0x3f
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_5f, 0x5f  # offset +0x5f
.equ field_67, 0x67  # offset +0x67
.equ field_6b, 0x6b  # offset +0x6b
.equ field_17d, 0x17d  # offset +0x17d
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_196, 0x196  # offset +0x196
.equ field_19a, 0x19a  # offset +0x19a
.equ field_36c, 0x36c  # offset +0x36c
.equ field_370, 0x370  # offset +0x370
.equ field_374, 0x374  # offset +0x374
.equ field_378, 0x378  # offset +0x378
.equ field_1515, 0x1515  # offset +0x1515
.equ field_1529, 0x1529  # offset +0x1529
.equ field_152d, 0x152d  # offset +0x152d
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1533, 0x1533  # offset +0x1533

# --- external targets -----------------------------------------------
.set FUN_004afec1, .text + (0x004afec1 - 0x401000)
.set FUN_004b2917, .text + (0x004b2917 - 0x401000)

.org 0x004b2250 - 0x401000
.globl FUN_004b2250
FUN_004b2250:
    # block 0x004b2250: entry, 10 instruction(s), ends with je to 0x004b290d (forward)
    push ebp                                     # 004b2250
    {load} mov ebp, esp                          # 004b2251
    sub esp, 0x20                                # 004b2253
    push esi                                     # 004b2256
    mov dword ptr [ebp - local_20], ecx          # 004b2257
    mov dword ptr [ebp - local_8], 0x0           # 004b225a
    mov word ptr [ebp - local_4], 0x0            # 004b2261
    mov eax, dword ptr [ebp - local_20]          # 004b2267
    cmp dword ptr [eax + field_1515], 0x0        # 004b226a
    je.d32 L_004b290d                            # 004b2271
    # block 0x004b2277: entered by fall-through of je at 0x004b2271, 3 instruction(s), ends with je to 0x004b290d (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b2277
    cmp dword ptr [ecx + field_24], 0x2          # 004b227a
    je.d32 L_004b290d                            # 004b227e
    # block 0x004b2284: entered by fall-through of je at 0x004b227e, 3 instruction(s), ends with je to 0x004b290d (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b2284
    cmp dword ptr [edx + field_24], 0x1          # 004b2287
    je.d32 L_004b290d                            # 004b228b
    # block 0x004b2291: entered by fall-through of je at 0x004b228b, 19 instruction(s), ends with jg to 0x004b2301 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b2291
    add eax, dword ptr [0x583186]                # 004b2295
    mov dword ptr [ebp - local_1c], eax          # 004b229b
    movsx ecx, word ptr [ebp + arg_c]            # 004b229e
    add ecx, dword ptr [0x58318a]                # 004b22a2
    mov dword ptr [ebp - local_18], ecx          # 004b22a8
    mov edx, dword ptr [ebp - local_20]          # 004b22ab
    movsx eax, word ptr [edx + field_1e]         # 004b22ae
    imul eax, eax, 0x8d                          # 004b22b2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b22b8
    mov dword ptr [ebp - local_14], ecx          # 004b22be
    mov edx, dword ptr [ebp - local_14]          # 004b22c1
    movsx eax, word ptr [edx + field_21]         # 004b22c4
    sub eax, 0x1                                 # 004b22c8
    imul eax, eax, 0x1e4                         # 004b22cb
    mov ecx, dword ptr [ebp - local_20]          # 004b22d1
    mov edx, dword ptr [ebp - local_18]          # 004b22d4
    cmp edx, dword ptr [ecx + eax + field_6b]    # 004b22d7
    jg.d8 L_004b2301                             # 004b22db
    # block 0x004b22dd: entered by fall-through of jg at 0x004b22db, 8 instruction(s), ends with jg to 0x004b2301 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004b22dd
    movsx ecx, word ptr [eax + field_23]         # 004b22e0
    sub ecx, 0x1                                 # 004b22e4
    imul ecx, ecx, 0x2c                          # 004b22e7
    mov edx, dword ptr [ebp - local_20]          # 004b22ea
    mov eax, dword ptr [ebp - local_1c]          # 004b22ed
    cmp eax, dword ptr [edx + ecx + field_67]    # 004b22f0
    jg.d8 L_004b2301                             # 004b22f4
    # block 0x004b22f6: entered by fall-through of jg at 0x004b22f4, 4 instruction(s), ends with jge to 0x004b2319 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b22f6
    mov edx, dword ptr [ebp - local_1c]          # 004b22f9
    cmp edx, dword ptr [ecx + field_5f]          # 004b22fc
    jge.d8 L_004b2319                            # 004b22ff
L_004b2301:
    # block 0x004b2301: entered by jg at 0x004b22db; jg at 0x004b22f4; fall-through of jge at 0x004b22ff, 4 instruction(s), falls into the block at 0x004b2319
    mov eax, dword ptr [ebp - local_20]          # 004b2301
    mov word ptr [eax + field_1531], 0x0         # 004b2304
    mov ecx, dword ptr [ebp - local_20]          # 004b230d
    mov word ptr [ecx + field_1533], 0x0         # 004b2310
L_004b2319:
    # block 0x004b2319: entered by jge at 0x004b22ff, 2 instruction(s), ends with forward jump to 0x004b232d
    mov word ptr [ebp - local_c], 0x0            # 004b2319
    jmp.d8 L_004b232d                            # 004b231f
L_004b2321:
    # block 0x004b2321: entered by jmp at 0x004b2848, 3 instruction(s), falls into the block at 0x004b232d
    mov dx, word ptr [ebp - local_c]             # 004b2321
    add dx, 0x1                                  # 004b2325
    mov word ptr [ebp - local_c], dx             # 004b2329
L_004b232d:
    # block 0x004b232d: entered by jmp at 0x004b231f, 5 instruction(s), ends with jge to 0x004b284d (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b232d
    mov ecx, dword ptr [ebp - local_14]          # 004b2331
    movsx edx, word ptr [ecx + field_21]         # 004b2334
    {load} cmp eax, edx                          # 004b2338
    jge.d32 L_004b284d                           # 004b233a
    # block 0x004b2340: entered by fall-through of jge at 0x004b233a, 2 instruction(s), ends with forward jump to 0x004b2354
    mov word ptr [ebp - local_10], 0x0           # 004b2340
    jmp.d8 L_004b2354                            # 004b2346
L_004b2348:
    # block 0x004b2348: entered by jmp at 0x004b2843, 3 instruction(s), falls into the block at 0x004b2354
    mov ax, word ptr [ebp - local_10]            # 004b2348
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b234c
    mov word ptr [ebp - local_10], ax            # 004b2350
L_004b2354:
    # block 0x004b2354: entered by jmp at 0x004b2346, 5 instruction(s), ends with jge to 0x004b2848 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004b2354
    mov edx, dword ptr [ebp - local_14]          # 004b2358
    movsx eax, word ptr [edx + field_23]         # 004b235b
    {load} cmp ecx, eax                          # 004b235f
    jge.d32 L_004b2848                           # 004b2361
    # block 0x004b2367: entered by fall-through of jge at 0x004b2361, 9 instruction(s), ends with je to 0x004b2727 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b2367
    imul ecx, ecx, 0x1e4                         # 004b236b
    mov edx, dword ptr [ebp - local_20]          # 004b2371
    lea eax, [edx + ecx + field_43]              # 004b2374
    movsx ecx, word ptr [ebp - local_10]         # 004b2378
    imul ecx, ecx, 0x2c                          # 004b237c
    movsx edx, word ptr [eax + ecx + field_1a]   # 004b237f
    test edx, edx                                # 004b2384
    je.d32 L_004b2727                            # 004b2386
    # block 0x004b238c: entered by fall-through of je at 0x004b2386, 9 instruction(s), ends with jne to 0x004b2727 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b238c
    imul eax, eax, 0x1e4                         # 004b2390
    mov ecx, dword ptr [ebp - local_20]          # 004b2396
    lea edx, [ecx + eax + field_43]              # 004b2399
    movsx eax, word ptr [ebp - local_10]         # 004b239d
    imul eax, eax, 0x2c                          # 004b23a1
    movsx ecx, word ptr [edx + eax + field_18]   # 004b23a4
    cmp ecx, 0x5                                 # 004b23a9
    jne.d32 L_004b2727                           # 004b23ac
    # block 0x004b23b2: entered by fall-through of jne at 0x004b23ac, 9 instruction(s), ends with jl to 0x004b248b (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b23b2
    imul edx, edx, 0x1e4                         # 004b23b6
    mov eax, dword ptr [ebp - local_20]          # 004b23bc
    lea ecx, [eax + edx + field_43]              # 004b23bf
    movsx edx, word ptr [ebp - local_10]         # 004b23c3
    imul edx, edx, 0x2c                          # 004b23c7
    mov eax, dword ptr [ebp - local_18]          # 004b23ca
    cmp eax, dword ptr [ecx + edx + field_20]    # 004b23cd
    jl.d32 L_004b248b                            # 004b23d1
    # block 0x004b23d7: entered by fall-through of jl at 0x004b23d1, 16 instruction(s), ends with jg to 0x004b248b (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b23d7
    imul ecx, ecx, 0x1e4                         # 004b23db
    mov edx, dword ptr [ebp - local_20]          # 004b23e1
    lea ecx, [edx + ecx + field_43]              # 004b23e4
    movsx esi, word ptr [ebp - local_10]         # 004b23e8
    imul esi, esi, 0x2c                          # 004b23ec
    mov edx, dword ptr [ebp - local_20]          # 004b23ef
    mov eax, dword ptr [edx + field_152d]        # 004b23f2
    cdq                                          # 004b23f8
    and edx, 0x3                                 # 004b23f9
    {load} add eax, edx                          # 004b23fc
    sar eax, 0x2                                 # 004b23fe
    mov ecx, dword ptr [ecx + esi + field_20]    # 004b2401
    {load} add ecx, eax                          # 004b2405
    cmp dword ptr [ebp - local_18], ecx          # 004b2407
    jg.d8 L_004b248b                             # 004b240a
    # block 0x004b240c: entered by fall-through of jg at 0x004b240a, 16 instruction(s), ends with jl to 0x004b248b (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b240c
    imul edx, edx, 0x1e4                         # 004b2410
    mov eax, dword ptr [ebp - local_20]          # 004b2416
    lea ecx, [eax + edx + field_43]              # 004b2419
    movsx esi, word ptr [ebp - local_10]         # 004b241d
    imul esi, esi, 0x2c                          # 004b2421
    mov edx, dword ptr [ebp - local_20]          # 004b2424
    mov eax, dword ptr [edx + field_1529]        # 004b2427
    cdq                                          # 004b242d
    and edx, 0x3                                 # 004b242e
    {load} add eax, edx                          # 004b2431
    sar eax, 0x2                                 # 004b2433
    mov ecx, dword ptr [ecx + esi + field_1c]    # 004b2436
    {load} add ecx, eax                          # 004b243a
    cmp dword ptr [ebp - local_1c], ecx          # 004b243c
    jl.d8 L_004b248b                             # 004b243f
    # block 0x004b2441: entered by fall-through of jl at 0x004b243f, 17 instruction(s), ends with jg to 0x004b248b (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b2441
    imul edx, edx, 0x1e4                         # 004b2445
    mov eax, dword ptr [ebp - local_20]          # 004b244b
    lea ecx, [eax + edx + field_43]              # 004b244e
    movsx esi, word ptr [ebp - local_10]         # 004b2452
    add esi, 0x1                                 # 004b2456
    imul esi, esi, 0x2c                          # 004b2459
    mov edx, dword ptr [ebp - local_20]          # 004b245c
    mov eax, dword ptr [edx + field_1529]        # 004b245f
    cdq                                          # 004b2465
    and edx, 0x3                                 # 004b2466
    {load} add eax, edx                          # 004b2469
    sar eax, 0x2                                 # 004b246b
    mov ecx, dword ptr [ecx + esi + field_24]    # 004b246e
    {load} sub ecx, eax                          # 004b2472
    cmp dword ptr [ebp - local_1c], ecx          # 004b2474
    jg.d8 L_004b248b                             # 004b2477
    # block 0x004b2479: entered by fall-through of jg at 0x004b2477, 4 instruction(s), falls into the block at 0x004b248b
    mov word ptr [ebp - local_4], 0x2795         # 004b2479
    mov dx, word ptr [ebp - local_10]            # 004b247f
    add dx, 0x1                                  # 004b2483
    mov word ptr [ebp - local_10], dx            # 004b2487
L_004b248b:
    # block 0x004b248b: entered by jl at 0x004b23d1; jg at 0x004b240a; jl at 0x004b243f; jg at 0x004b2477, 17 instruction(s), ends with jl to 0x004b256a (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b248b
    add eax, 0x1                                 # 004b248f
    imul eax, eax, 0x1e4                         # 004b2492
    mov ecx, dword ptr [ebp - local_20]          # 004b2498
    lea ecx, [ecx + eax + field_43]              # 004b249b
    movsx esi, word ptr [ebp - local_10]         # 004b249f
    imul esi, esi, 0x2c                          # 004b24a3
    mov edx, dword ptr [ebp - local_20]          # 004b24a6
    mov eax, dword ptr [edx + field_152d]        # 004b24a9
    cdq                                          # 004b24af
    and edx, 0x3                                 # 004b24b0
    {load} add eax, edx                          # 004b24b3
    sar eax, 0x2                                 # 004b24b5
    mov ecx, dword ptr [ecx + esi + field_28]    # 004b24b8
    {load} sub ecx, eax                          # 004b24bc
    cmp dword ptr [ebp - local_18], ecx          # 004b24be
    jl.d32 L_004b256a                            # 004b24c1
    # block 0x004b24c7: entered by fall-through of jl at 0x004b24c1, 10 instruction(s), ends with jg to 0x004b256a (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b24c7
    add edx, 0x1                                 # 004b24cb
    imul edx, edx, 0x1e4                         # 004b24ce
    mov eax, dword ptr [ebp - local_20]          # 004b24d4
    lea ecx, [eax + edx + field_43]              # 004b24d7
    movsx edx, word ptr [ebp - local_10]         # 004b24db
    imul edx, edx, 0x2c                          # 004b24df
    mov eax, dword ptr [ebp - local_18]          # 004b24e2
    cmp eax, dword ptr [ecx + edx + field_28]    # 004b24e5
    jg.d8 L_004b256a                             # 004b24e9
    # block 0x004b24eb: entered by fall-through of jg at 0x004b24e9, 16 instruction(s), ends with jl to 0x004b256a (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b24eb
    imul ecx, ecx, 0x1e4                         # 004b24ef
    mov edx, dword ptr [ebp - local_20]          # 004b24f5
    lea ecx, [edx + ecx + field_43]              # 004b24f8
    movsx esi, word ptr [ebp - local_10]         # 004b24fc
    imul esi, esi, 0x2c                          # 004b2500
    mov edx, dword ptr [ebp - local_20]          # 004b2503
    mov eax, dword ptr [edx + field_1529]        # 004b2506
    cdq                                          # 004b250c
    and edx, 0x3                                 # 004b250d
    {load} add eax, edx                          # 004b2510
    sar eax, 0x2                                 # 004b2512
    mov ecx, dword ptr [ecx + esi + field_1c]    # 004b2515
    {load} add ecx, eax                          # 004b2519
    cmp dword ptr [ebp - local_1c], ecx          # 004b251b
    jl.d8 L_004b256a                             # 004b251e
    # block 0x004b2520: entered by fall-through of jl at 0x004b251e, 17 instruction(s), ends with jg to 0x004b256a (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b2520
    imul edx, edx, 0x1e4                         # 004b2524
    mov eax, dword ptr [ebp - local_20]          # 004b252a
    lea ecx, [eax + edx + field_43]              # 004b252d
    movsx esi, word ptr [ebp - local_10]         # 004b2531
    add esi, 0x1                                 # 004b2535
    imul esi, esi, 0x2c                          # 004b2538
    mov edx, dword ptr [ebp - local_20]          # 004b253b
    mov eax, dword ptr [edx + field_1529]        # 004b253e
    cdq                                          # 004b2544
    and edx, 0x3                                 # 004b2545
    {load} add eax, edx                          # 004b2548
    sar eax, 0x2                                 # 004b254a
    mov ecx, dword ptr [ecx + esi + field_24]    # 004b254d
    {load} sub ecx, eax                          # 004b2551
    cmp dword ptr [ebp - local_1c], ecx          # 004b2553
    jg.d8 L_004b256a                             # 004b2556
    # block 0x004b2558: entered by fall-through of jg at 0x004b2556, 4 instruction(s), falls into the block at 0x004b256a
    mov word ptr [ebp - local_4], 0x2796         # 004b2558
    mov dx, word ptr [ebp - local_c]             # 004b255e
    add dx, 0x1                                  # 004b2562
    mov word ptr [ebp - local_c], dx             # 004b2566
L_004b256a:
    # block 0x004b256a: entered by jl at 0x004b24c1; jg at 0x004b24e9; jl at 0x004b251e; jg at 0x004b2556, 16 instruction(s), ends with jl to 0x004b2637 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b256a
    imul eax, eax, 0x1e4                         # 004b256e
    mov ecx, dword ptr [ebp - local_20]          # 004b2574
    lea ecx, [ecx + eax + field_43]              # 004b2577
    movsx esi, word ptr [ebp - local_10]         # 004b257b
    imul esi, esi, 0x2c                          # 004b257f
    mov edx, dword ptr [ebp - local_20]          # 004b2582
    mov eax, dword ptr [edx + field_152d]        # 004b2585
    cdq                                          # 004b258b
    and edx, 0x3                                 # 004b258c
    {load} add eax, edx                          # 004b258f
    sar eax, 0x2                                 # 004b2591
    mov ecx, dword ptr [ecx + esi + field_20]    # 004b2594
    {load} add ecx, eax                          # 004b2598
    cmp dword ptr [ebp - local_18], ecx          # 004b259a
    jl.d32 L_004b2637                            # 004b259d
    # block 0x004b25a3: entered by fall-through of jl at 0x004b259d, 17 instruction(s), ends with jg to 0x004b2637 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b25a3
    add edx, 0x1                                 # 004b25a7
    imul edx, edx, 0x1e4                         # 004b25aa
    mov eax, dword ptr [ebp - local_20]          # 004b25b0
    lea ecx, [eax + edx + field_43]              # 004b25b3
    movsx esi, word ptr [ebp - local_10]         # 004b25b7
    imul esi, esi, 0x2c                          # 004b25bb
    mov edx, dword ptr [ebp - local_20]          # 004b25be
    mov eax, dword ptr [edx + field_152d]        # 004b25c1
    cdq                                          # 004b25c7
    and edx, 0x3                                 # 004b25c8
    {load} add eax, edx                          # 004b25cb
    sar eax, 0x2                                 # 004b25cd
    mov ecx, dword ptr [ecx + esi + field_28]    # 004b25d0
    {load} sub ecx, eax                          # 004b25d4
    cmp dword ptr [ebp - local_18], ecx          # 004b25d6
    jg.d8 L_004b2637                             # 004b25d9
    # block 0x004b25db: entered by fall-through of jg at 0x004b25d9, 9 instruction(s), ends with jl to 0x004b2637 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b25db
    imul edx, edx, 0x1e4                         # 004b25df
    mov eax, dword ptr [ebp - local_20]          # 004b25e5
    lea ecx, [eax + edx + field_43]              # 004b25e8
    movsx edx, word ptr [ebp - local_10]         # 004b25ec
    imul edx, edx, 0x2c                          # 004b25f0
    mov eax, dword ptr [ebp - local_1c]          # 004b25f3
    cmp eax, dword ptr [ecx + edx + field_1c]    # 004b25f6
    jl.d8 L_004b2637                             # 004b25fa
    # block 0x004b25fc: entered by fall-through of jl at 0x004b25fa, 16 instruction(s), ends with jg to 0x004b2637 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b25fc
    imul ecx, ecx, 0x1e4                         # 004b2600
    mov edx, dword ptr [ebp - local_20]          # 004b2606
    lea ecx, [edx + ecx + field_43]              # 004b2609
    movsx esi, word ptr [ebp - local_10]         # 004b260d
    imul esi, esi, 0x2c                          # 004b2611
    mov edx, dword ptr [ebp - local_20]          # 004b2614
    mov eax, dword ptr [edx + field_1529]        # 004b2617
    cdq                                          # 004b261d
    and edx, 0x3                                 # 004b261e
    {load} add eax, edx                          # 004b2621
    sar eax, 0x2                                 # 004b2623
    mov ecx, dword ptr [ecx + esi + field_1c]    # 004b2626
    {load} add ecx, eax                          # 004b262a
    cmp dword ptr [ebp - local_1c], ecx          # 004b262c
    jg.d8 L_004b2637                             # 004b262f
    # block 0x004b2631: entered by fall-through of jg at 0x004b262f, 1 instruction(s), falls into the block at 0x004b2637
    mov word ptr [ebp - local_4], 0x2794         # 004b2631
L_004b2637:
    # block 0x004b2637: entered by jl at 0x004b259d; jg at 0x004b25d9; jl at 0x004b25fa; jg at 0x004b262f, 16 instruction(s), ends with jl to 0x004b2722 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b2637
    imul edx, edx, 0x1e4                         # 004b263b
    mov eax, dword ptr [ebp - local_20]          # 004b2641
    lea ecx, [eax + edx + field_43]              # 004b2644
    movsx esi, word ptr [ebp - local_10]         # 004b2648
    imul esi, esi, 0x2c                          # 004b264c
    mov edx, dword ptr [ebp - local_20]          # 004b264f
    mov eax, dword ptr [edx + field_152d]        # 004b2652
    cdq                                          # 004b2658
    and edx, 0x3                                 # 004b2659
    {load} add eax, edx                          # 004b265c
    sar eax, 0x2                                 # 004b265e
    mov ecx, dword ptr [ecx + esi + field_20]    # 004b2661
    {load} add ecx, eax                          # 004b2665
    cmp dword ptr [ebp - local_18], ecx          # 004b2667
    jl.d32 L_004b2722                            # 004b266a
    # block 0x004b2670: entered by fall-through of jl at 0x004b266a, 17 instruction(s), ends with jg to 0x004b2722 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b2670
    add edx, 0x1                                 # 004b2674
    imul edx, edx, 0x1e4                         # 004b2677
    mov eax, dword ptr [ebp - local_20]          # 004b267d
    lea ecx, [eax + edx + field_43]              # 004b2680
    movsx esi, word ptr [ebp - local_10]         # 004b2684
    imul esi, esi, 0x2c                          # 004b2688
    mov edx, dword ptr [ebp - local_20]          # 004b268b
    mov eax, dword ptr [edx + field_152d]        # 004b268e
    cdq                                          # 004b2694
    and edx, 0x3                                 # 004b2695
    {load} add eax, edx                          # 004b2698
    sar eax, 0x2                                 # 004b269a
    mov ecx, dword ptr [ecx + esi + field_28]    # 004b269d
    {load} sub ecx, eax                          # 004b26a1
    cmp dword ptr [ebp - local_18], ecx          # 004b26a3
    jg.d8 L_004b2722                             # 004b26a6
    # block 0x004b26a8: entered by fall-through of jg at 0x004b26a6, 17 instruction(s), ends with jl to 0x004b2722 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b26a8
    imul edx, edx, 0x1e4                         # 004b26ac
    mov eax, dword ptr [ebp - local_20]          # 004b26b2
    lea ecx, [eax + edx + field_43]              # 004b26b5
    movsx esi, word ptr [ebp - local_10]         # 004b26b9
    add esi, 0x1                                 # 004b26bd
    imul esi, esi, 0x2c                          # 004b26c0
    mov edx, dword ptr [ebp - local_20]          # 004b26c3
    mov eax, dword ptr [edx + field_1529]        # 004b26c6
    cdq                                          # 004b26cc
    and edx, 0x3                                 # 004b26cd
    {load} add eax, edx                          # 004b26d0
    sar eax, 0x2                                 # 004b26d2
    mov ecx, dword ptr [ecx + esi + field_24]    # 004b26d5
    {load} sub ecx, eax                          # 004b26d9
    cmp dword ptr [ebp - local_1c], ecx          # 004b26db
    jl.d8 L_004b2722                             # 004b26de
    # block 0x004b26e0: entered by fall-through of jl at 0x004b26de, 10 instruction(s), ends with jg to 0x004b2722 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b26e0
    imul edx, edx, 0x1e4                         # 004b26e4
    mov eax, dword ptr [ebp - local_20]          # 004b26ea
    lea ecx, [eax + edx + field_43]              # 004b26ed
    movsx edx, word ptr [ebp - local_10]         # 004b26f1
    add edx, 0x1                                 # 004b26f5
    imul edx, edx, 0x2c                          # 004b26f8
    mov eax, dword ptr [ebp - local_1c]          # 004b26fb
    cmp eax, dword ptr [ecx + edx + field_24]    # 004b26fe
    jg.d8 L_004b2722                             # 004b2702
    # block 0x004b2704: entered by fall-through of jg at 0x004b2702, 7 instruction(s), falls into the block at 0x004b2722
    mov word ptr [ebp - local_4], 0x2797         # 004b2704
    mov cx, word ptr [ebp - local_10]            # 004b270a
    add cx, 0x1                                  # 004b270e
    mov word ptr [ebp - local_10], cx            # 004b2712
    mov dx, word ptr [ebp - local_c]             # 004b2716
    add dx, 0x1                                  # 004b271a
    mov word ptr [ebp - local_c], dx             # 004b271e
L_004b2722:
    # block 0x004b2722: entered by jl at 0x004b266a; jg at 0x004b26a6; jl at 0x004b26de; jg at 0x004b2702, 1 instruction(s), ends with forward jump to 0x004b27f5
    jmp.d32 L_004b27f5                           # 004b2722
L_004b2727:
    # block 0x004b2727: entered by je at 0x004b2386; jne at 0x004b23ac, 9 instruction(s), ends with je to 0x004b27f5 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b2727
    imul eax, eax, 0x1e4                         # 004b272b
    mov ecx, dword ptr [ebp - local_20]          # 004b2731
    lea edx, [ecx + eax + field_43]              # 004b2734
    movsx eax, word ptr [ebp - local_10]         # 004b2738
    imul eax, eax, 0x2c                          # 004b273c
    movsx ecx, word ptr [edx + eax + field_1a]   # 004b273f
    test ecx, ecx                                # 004b2744
    je.d32 L_004b27f5                            # 004b2746
    # block 0x004b274c: entered by fall-through of je at 0x004b2746, 9 instruction(s), ends with jl to 0x004b27f5 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b274c
    imul edx, edx, 0x1e4                         # 004b2750
    mov eax, dword ptr [ebp - local_20]          # 004b2756
    lea ecx, [eax + edx + field_43]              # 004b2759
    movsx edx, word ptr [ebp - local_10]         # 004b275d
    imul edx, edx, 0x2c                          # 004b2761
    mov eax, dword ptr [ebp - local_18]          # 004b2764
    cmp eax, dword ptr [ecx + edx + field_20]    # 004b2767
    jl.d32 L_004b27f5                            # 004b276b
    # block 0x004b2771: entered by fall-through of jl at 0x004b276b, 9 instruction(s), ends with jg to 0x004b27f5 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b2771
    imul ecx, ecx, 0x1e4                         # 004b2775
    mov edx, dword ptr [ebp - local_20]          # 004b277b
    lea eax, [edx + ecx + field_43]              # 004b277e
    movsx ecx, word ptr [ebp - local_10]         # 004b2782
    imul ecx, ecx, 0x2c                          # 004b2786
    mov edx, dword ptr [ebp - local_18]          # 004b2789
    cmp edx, dword ptr [eax + ecx + field_28]    # 004b278c
    jg.d8 L_004b27f5                             # 004b2790
    # block 0x004b2792: entered by fall-through of jg at 0x004b2790, 9 instruction(s), ends with jl to 0x004b27f5 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b2792
    imul eax, eax, 0x1e4                         # 004b2796
    mov ecx, dword ptr [ebp - local_20]          # 004b279c
    lea edx, [ecx + eax + field_43]              # 004b279f
    movsx eax, word ptr [ebp - local_10]         # 004b27a3
    imul eax, eax, 0x2c                          # 004b27a7
    mov ecx, dword ptr [ebp - local_1c]          # 004b27aa
    cmp ecx, dword ptr [edx + eax + field_1c]    # 004b27ad
    jl.d8 L_004b27f5                             # 004b27b1
    # block 0x004b27b3: entered by fall-through of jl at 0x004b27b1, 9 instruction(s), ends with jg to 0x004b27f5 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b27b3
    imul edx, edx, 0x1e4                         # 004b27b7
    mov eax, dword ptr [ebp - local_20]          # 004b27bd
    lea ecx, [eax + edx + field_43]              # 004b27c0
    movsx edx, word ptr [ebp - local_10]         # 004b27c4
    imul edx, edx, 0x2c                          # 004b27c8
    mov eax, dword ptr [ebp - local_1c]          # 004b27cb
    cmp eax, dword ptr [ecx + edx + field_24]    # 004b27ce
    jg.d8 L_004b27f5                             # 004b27d2
    # block 0x004b27d4: entered by fall-through of jg at 0x004b27d2, 8 instruction(s), falls into the block at 0x004b27f5
    movsx ecx, word ptr [ebp - local_c]          # 004b27d4
    imul ecx, ecx, 0x1e4                         # 004b27d8
    mov edx, dword ptr [ebp - local_20]          # 004b27de
    lea eax, [edx + ecx + field_43]              # 004b27e1
    movsx ecx, word ptr [ebp - local_10]         # 004b27e5
    imul ecx, ecx, 0x2c                          # 004b27e9
    mov dx, word ptr [eax + ecx + field_1a]      # 004b27ec
    mov word ptr [ebp - local_4], dx             # 004b27f1
L_004b27f5:
    # block 0x004b27f5: entered by jmp at 0x004b2722; je at 0x004b2746; jl at 0x004b276b; jg at 0x004b2790; more, 3 instruction(s), ends with je to 0x004b2843 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b27f5
    test eax, eax                                # 004b27f9
    je.d8 L_004b2843                             # 004b27fb
    # block 0x004b27fd: entered by fall-through of je at 0x004b27fb, 12 instruction(s), calls FUN_004afec1, ends with jne to 0x004b283c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b27fd
    mov dx, word ptr [ebp - local_c]             # 004b2800
    mov word ptr [ecx + field_3f], dx            # 004b2804
    mov eax, dword ptr [ebp - local_20]          # 004b2808
    mov cx, word ptr [ebp - local_10]            # 004b280b
    mov word ptr [eax + field_41], cx            # 004b280f
    mov dx, word ptr [ebp - local_4]             # 004b2813
    push edx                                     # 004b2817
    mov ecx, dword ptr [ebp - local_20]          # 004b2818
    call FUN_004afec1                            # 004b281b
    cmp eax, 0x1                                 # 004b2820
    jne.d8 L_004b283c                            # 004b2823
    # block 0x004b2825: entered by fall-through of jne at 0x004b2823, 6 instruction(s), calls FUN_004b2917, ends with forward jump to 0x004b2910
    mov ax, word ptr [ebp - local_4]             # 004b2825
    push eax                                     # 004b2829
    mov ecx, dword ptr [ebp - local_20]          # 004b282a
    call FUN_004b2917                            # 004b282d
    mov eax, 0x1                                 # 004b2832
    jmp.d32 L_004b2910                           # 004b2837
L_004b283c:
    # block 0x004b283c: entered by jne at 0x004b2823, 2 instruction(s), ends with forward jump to 0x004b2910
    {load} xor eax, eax                          # 004b283c
    jmp.d32 L_004b2910                           # 004b283e
L_004b2843:
    # block 0x004b2843: entered by je at 0x004b27fb, 1 instruction(s), ends with backward jump to 0x004b2348
    jmp.d32 L_004b2348                           # 004b2843
L_004b2848:
    # block 0x004b2848: entered by jge at 0x004b2361, 1 instruction(s), ends with backward jump to 0x004b2321
    jmp.d32 L_004b2321                           # 004b2848
L_004b284d:
    # block 0x004b284d: entered by jge at 0x004b233a, 5 instruction(s), ends with jne to 0x004b28ae (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004b284d
    {load} xor edx, edx                          # 004b2850
    mov dl, byte ptr [ecx + field_17d]           # 004b2852
    test edx, edx                                # 004b2858
    jne.d8 L_004b28ae                            # 004b285a
    # block 0x004b285c: entered by fall-through of jne at 0x004b285a, 4 instruction(s), ends with jl to 0x004b28ae (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b285c
    mov ecx, dword ptr [ebp - local_14]          # 004b2860
    cmp eax, dword ptr [ecx + field_370]         # 004b2863
    jl.d8 L_004b28ae                             # 004b2869
    # block 0x004b286b: entered by fall-through of jl at 0x004b2869, 4 instruction(s), ends with jg to 0x004b28ae (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004b286b
    mov eax, dword ptr [ebp - local_14]          # 004b286f
    cmp edx, dword ptr [eax + field_378]         # 004b2872
    jg.d8 L_004b28ae                             # 004b2878
    # block 0x004b287a: entered by fall-through of jg at 0x004b2878, 4 instruction(s), ends with jl to 0x004b28ae (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b287a
    mov edx, dword ptr [ebp - local_14]          # 004b287e
    cmp ecx, dword ptr [edx + field_36c]         # 004b2881
    jl.d8 L_004b28ae                             # 004b2887
    # block 0x004b2889: entered by fall-through of jl at 0x004b2887, 4 instruction(s), ends with jg to 0x004b28ae (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b2889
    mov ecx, dword ptr [ebp - local_14]          # 004b288d
    cmp eax, dword ptr [ecx + field_374]         # 004b2890
    jg.d8 L_004b28ae                             # 004b2896
    # block 0x004b2898: entered by fall-through of jg at 0x004b2896, 5 instruction(s), calls FUN_004b2917, ends with forward jump to 0x004b290d
    push 0x2793                                  # 004b2898
    mov ecx, dword ptr [ebp - local_20]          # 004b289d
    call FUN_004b2917                            # 004b28a0
    mov dword ptr [ebp - local_8], 0x1           # 004b28a5
    jmp.d8 L_004b290d                            # 004b28ac
L_004b28ae:
    # block 0x004b28ae: entered by jne at 0x004b285a; jl at 0x004b2869; jg at 0x004b2878; jl at 0x004b2887; jg at 0x004b2896, 5 instruction(s), ends with je to 0x004b290d (forward)
    mov edx, dword ptr [ebp - local_14]          # 004b28ae
    {load} xor eax, eax                          # 004b28b1
    mov al, byte ptr [edx + field_17d]           # 004b28b3
    test eax, eax                                # 004b28b9
    je.d8 L_004b290d                             # 004b28bb
    # block 0x004b28bd: entered by fall-through of je at 0x004b28bb, 4 instruction(s), ends with jl to 0x004b290d (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b28bd
    mov edx, dword ptr [ebp - local_14]          # 004b28c1
    cmp ecx, dword ptr [edx + field_192]         # 004b28c4
    jl.d8 L_004b290d                             # 004b28ca
    # block 0x004b28cc: entered by fall-through of jl at 0x004b28ca, 4 instruction(s), ends with jg to 0x004b290d (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b28cc
    mov ecx, dword ptr [ebp - local_14]          # 004b28d0
    cmp eax, dword ptr [ecx + field_19a]         # 004b28d3
    jg.d8 L_004b290d                             # 004b28d9
    # block 0x004b28db: entered by fall-through of jg at 0x004b28d9, 4 instruction(s), ends with jl to 0x004b290d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004b28db
    mov eax, dword ptr [ebp - local_14]          # 004b28df
    cmp edx, dword ptr [eax + field_18e]         # 004b28e2
    jl.d8 L_004b290d                             # 004b28e8
    # block 0x004b28ea: entered by fall-through of jl at 0x004b28e8, 4 instruction(s), ends with jg to 0x004b290d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b28ea
    mov edx, dword ptr [ebp - local_14]          # 004b28ee
    cmp ecx, dword ptr [edx + field_196]         # 004b28f1
    jg.d8 L_004b290d                             # 004b28f7
    # block 0x004b28f9: entered by fall-through of jg at 0x004b28f7, 4 instruction(s), calls FUN_004b2917, falls into the block at 0x004b290d
    push 0x2792                                  # 004b28f9
    mov ecx, dword ptr [ebp - local_20]          # 004b28fe
    call FUN_004b2917                            # 004b2901
    mov dword ptr [ebp - local_8], 0x1           # 004b2906
L_004b290d:
    # block 0x004b290d: entered by je at 0x004b2271; je at 0x004b227e; je at 0x004b228b; jmp at 0x004b28ac; more, 1 instruction(s), falls into the block at 0x004b2910
    mov eax, dword ptr [ebp - local_8]           # 004b290d
L_004b2910:
    # block 0x004b2910: entered by jmp at 0x004b2837; jmp at 0x004b283e, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 004b2910
    {load} mov esp, ebp                          # 004b2911
    pop ebp                                      # 004b2913
    ret 0x8                                      # 004b2914

