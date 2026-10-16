# FUN_004b01e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b01e8
# extent:       0x004b01e8-0x004b059e (950 code bytes)
# span:         0x004b01e8-0x004b05ae (code 950, tables 16, padding 0)
# sha256:       7d6c957cd612554cbf9a194375060ea3be67c560b9999348a53eb64f50ae9c54
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b01e8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_1e, field_25, field_29, field_3b, field_43, field_1a8, field_1529, field_152d and 1 more; [ecx + n] field_4, field_8, field_c, field_10, field_1531, field_1533; [edx + n] field_4, field_8, field_c, field_27, field_43, field_1a8, field_1535; [esi + n] field_43
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 250 instruction(s), 3 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_3b, 0x3b  # offset +0x3b
.equ field_43, 0x43  # offset +0x43
.equ field_1a8, 0x1a8  # offset +0x1a8
.equ field_1529, 0x1529  # offset +0x1529
.equ field_152d, 0x152d  # offset +0x152d
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1533, 0x1533  # offset +0x1533
.equ field_1535, 0x1535  # offset +0x1535

# --- external targets -----------------------------------------------

.org 0x004b01e8 - 0x401000
.globl FUN_004b01e8
FUN_004b01e8:
    # block 0x004b01e8: entry, 26 instruction(s), ends with jne to 0x004b0257 (forward)
    push ebp                                     # 004b01e8
    {load} mov ebp, esp                          # 004b01e9
    sub esp, 0x18                                # 004b01eb
    push esi                                     # 004b01ee
    push edi                                     # 004b01ef
    mov dword ptr [ebp - local_14], ecx          # 004b01f0
    mov eax, dword ptr [ebp - local_14]          # 004b01f3
    movsx ecx, word ptr [eax + field_1e]         # 004b01f6
    imul ecx, ecx, 0x8d                          # 004b01fa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b0200
    mov dword ptr [ebp - local_c], edx           # 004b0206
    mov eax, dword ptr [ebp - local_c]           # 004b0209
    mov cx, word ptr [eax + field_25]            # 004b020c
    mov word ptr [ebp - local_8], cx             # 004b0210
    mov edx, dword ptr [ebp - local_c]           # 004b0214
    mov ax, word ptr [edx + field_27]            # 004b0217
    mov word ptr [ebp - local_4], ax             # 004b021b
    mov dword ptr [ebp - local_10], 0x0          # 004b021f
    mov ecx, dword ptr [ebp - local_14]          # 004b0226
    mov edx, dword ptr [ebp - local_14]          # 004b0229
    mov ax, word ptr [edx + field_1535]          # 004b022c
    mov word ptr [ecx + field_1531], ax          # 004b0233
    mov ecx, dword ptr [ebp - local_14]          # 004b023a
    movsx edx, word ptr [ecx + field_1531]       # 004b023d
    cmp edx, 0x2797                              # 004b0244
    jne.d8 L_004b0257                            # 004b024a
    # block 0x004b024c: entered by fall-through of jne at 0x004b024a, 3 instruction(s), falls into the block at 0x004b0257
    movsx eax, word ptr [ebp - local_4]          # 004b024c
    sub eax, 0x1                                 # 004b0250
    mov word ptr [ebp - local_4], ax             # 004b0253
L_004b0257:
    # block 0x004b0257: entered by jne at 0x004b024a, 27 instruction(s), ends with ja to 0x004b0554 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004b0257
    imul ecx, ecx, 0x1e4                         # 004b025b
    mov edx, dword ptr [ebp - local_14]          # 004b0261
    lea eax, [edx + ecx + field_43]              # 004b0264
    movsx ecx, word ptr [ebp - local_4]          # 004b0268
    imul ecx, ecx, 0x2c                          # 004b026c
    lea edx, [eax + ecx + field_4]               # 004b026f
    mov eax, dword ptr [ebp - local_14]          # 004b0273
    add eax, 0x29                                # 004b0276
    mov ecx, dword ptr [edx]                     # 004b0279
    mov dword ptr [eax], ecx                     # 004b027b
    mov ecx, dword ptr [edx + field_4]           # 004b027d
    mov dword ptr [eax + field_4], ecx           # 004b0280
    mov ecx, dword ptr [edx + field_8]           # 004b0283
    mov dword ptr [eax + field_8], ecx           # 004b0286
    mov edx, dword ptr [edx + field_c]           # 004b0289
    mov dword ptr [eax + field_c], edx           # 004b028c
    mov eax, dword ptr [ebp - local_14]          # 004b028f
    mov dword ptr [eax + field_3b], 0x1          # 004b0292
    mov ecx, dword ptr [ebp - local_14]          # 004b0299
    movsx edx, word ptr [ecx + field_1531]       # 004b029c
    mov dword ptr [ebp - local_18], edx          # 004b02a3
    mov eax, dword ptr [ebp - local_18]          # 004b02a6
    sub eax, 0x2794                              # 004b02a9
    mov dword ptr [ebp - local_18], eax          # 004b02ae
    cmp dword ptr [ebp - local_18], 0x3          # 004b02b1
    ja.d32 L_004b0554                            # 004b02b5
    # block 0x004b02bb: entered by fall-through of ja at 0x004b02b5, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4b059e]
    mov ecx, dword ptr [ebp - local_18]          # 004b02bb
    jmp dword ptr [4*ecx + SWTAB_004b059e_VA]    # 004b02be
L_004b02c5:
    # block 0x004b02c5: entered by switch case, 43 instruction(s), ends with forward jump to 0x004b0554
    movsx edx, word ptr [ebp - local_8]          # 004b02c5
    imul edx, edx, 0x1e4                         # 004b02c9
    mov eax, dword ptr [ebp - local_14]          # 004b02cf
    lea ecx, [eax + edx + field_43]              # 004b02d2
    movsx esi, word ptr [ebp - local_4]          # 004b02d6
    imul esi, esi, 0x2c                          # 004b02da
    mov edx, dword ptr [ebp - local_c]           # 004b02dd
    movsx edi, word ptr [edx + field_1a8]        # 004b02e0
    mov eax, dword ptr [ebp - local_14]          # 004b02e7
    mov eax, dword ptr [eax + field_1529]        # 004b02ea
    cdq                                          # 004b02f0
    idiv edi                                     # 004b02f1
    mov ecx, dword ptr [ecx + esi + field_4]     # 004b02f3
    {load} sub ecx, eax                          # 004b02f7
    movsx edx, word ptr [ebp - local_4]          # 004b02f9
    imul edx, edx, 0x2c                          # 004b02fd
    movsx eax, word ptr [ebp - local_8]          # 004b0300
    imul eax, eax, 0x1e4                         # 004b0304
    mov esi, dword ptr [ebp - local_14]          # 004b030a
    lea eax, [esi + eax + field_43]              # 004b030d
    mov dword ptr [eax + edx + field_4], ecx     # 004b0311
    movsx ecx, word ptr [ebp - local_8]          # 004b0315
    imul ecx, ecx, 0x1e4                         # 004b0319
    mov edx, dword ptr [ebp - local_14]          # 004b031f
    lea ecx, [edx + ecx + field_43]              # 004b0322
    movsx esi, word ptr [ebp - local_4]          # 004b0326
    imul esi, esi, 0x2c                          # 004b032a
    mov edx, dword ptr [ebp - local_c]           # 004b032d
    movsx edi, word ptr [edx + field_1a8]        # 004b0330
    mov eax, dword ptr [ebp - local_14]          # 004b0337
    mov eax, dword ptr [eax + field_1529]        # 004b033a
    cdq                                          # 004b0340
    idiv edi                                     # 004b0341
    mov ecx, dword ptr [ecx + esi + field_c]     # 004b0343
    {load} sub ecx, eax                          # 004b0347
    movsx edx, word ptr [ebp - local_4]          # 004b0349
    imul edx, edx, 0x2c                          # 004b034d
    movsx eax, word ptr [ebp - local_8]          # 004b0350
    imul eax, eax, 0x1e4                         # 004b0354
    mov esi, dword ptr [ebp - local_14]          # 004b035a
    lea eax, [esi + eax + field_43]              # 004b035d
    mov dword ptr [eax + edx + field_c], ecx     # 004b0361
    jmp.d32 L_004b0554                           # 004b0365
L_004b036a:
    # block 0x004b036a: entered by switch case, 43 instruction(s), ends with forward jump to 0x004b0554
    movsx ecx, word ptr [ebp - local_8]          # 004b036a
    imul ecx, ecx, 0x1e4                         # 004b036e
    mov edx, dword ptr [ebp - local_14]          # 004b0374
    lea ecx, [edx + ecx + field_43]              # 004b0377
    movsx esi, word ptr [ebp - local_4]          # 004b037b
    imul esi, esi, 0x2c                          # 004b037f
    mov edx, dword ptr [ebp - local_c]           # 004b0382
    movsx edi, word ptr [edx + field_1a8]        # 004b0385
    mov eax, dword ptr [ebp - local_14]          # 004b038c
    mov eax, dword ptr [eax + field_152d]        # 004b038f
    cdq                                          # 004b0395
    idiv edi                                     # 004b0396
    mov ecx, dword ptr [ecx + esi + field_8]     # 004b0398
    {load} sub ecx, eax                          # 004b039c
    movsx edx, word ptr [ebp - local_4]          # 004b039e
    imul edx, edx, 0x2c                          # 004b03a2
    movsx eax, word ptr [ebp - local_8]          # 004b03a5
    imul eax, eax, 0x1e4                         # 004b03a9
    mov esi, dword ptr [ebp - local_14]          # 004b03af
    lea eax, [esi + eax + field_43]              # 004b03b2
    mov dword ptr [eax + edx + field_8], ecx     # 004b03b6
    movsx ecx, word ptr [ebp - local_8]          # 004b03ba
    imul ecx, ecx, 0x1e4                         # 004b03be
    mov edx, dword ptr [ebp - local_14]          # 004b03c4
    lea ecx, [edx + ecx + field_43]              # 004b03c7
    movsx esi, word ptr [ebp - local_4]          # 004b03cb
    imul esi, esi, 0x2c                          # 004b03cf
    mov edx, dword ptr [ebp - local_c]           # 004b03d2
    movsx edi, word ptr [edx + field_1a8]        # 004b03d5
    mov eax, dword ptr [ebp - local_14]          # 004b03dc
    mov eax, dword ptr [eax + field_152d]        # 004b03df
    cdq                                          # 004b03e5
    idiv edi                                     # 004b03e6
    mov ecx, dword ptr [ecx + esi + field_10]    # 004b03e8
    {load} sub ecx, eax                          # 004b03ec
    movsx edx, word ptr [ebp - local_4]          # 004b03ee
    imul edx, edx, 0x2c                          # 004b03f2
    movsx eax, word ptr [ebp - local_8]          # 004b03f5
    imul eax, eax, 0x1e4                         # 004b03f9
    mov esi, dword ptr [ebp - local_14]          # 004b03ff
    lea eax, [esi + eax + field_43]              # 004b0402
    mov dword ptr [eax + edx + field_10], ecx    # 004b0406
    jmp.d32 L_004b0554                           # 004b040a
L_004b040f:
    # block 0x004b040f: entered by switch case, 43 instruction(s), ends with forward jump to 0x004b0554
    movsx ecx, word ptr [ebp - local_8]          # 004b040f
    imul ecx, ecx, 0x1e4                         # 004b0413
    mov edx, dword ptr [ebp - local_14]          # 004b0419
    lea ecx, [edx + ecx + field_43]              # 004b041c
    movsx esi, word ptr [ebp - local_4]          # 004b0420
    imul esi, esi, 0x2c                          # 004b0424
    mov edx, dword ptr [ebp - local_c]           # 004b0427
    movsx edi, word ptr [edx + field_1a8]        # 004b042a
    mov eax, dword ptr [ebp - local_14]          # 004b0431
    mov eax, dword ptr [eax + field_152d]        # 004b0434
    cdq                                          # 004b043a
    idiv edi                                     # 004b043b
    mov ecx, dword ptr [ecx + esi + field_8]     # 004b043d
    {load} add ecx, eax                          # 004b0441
    movsx edx, word ptr [ebp - local_4]          # 004b0443
    imul edx, edx, 0x2c                          # 004b0447
    movsx eax, word ptr [ebp - local_8]          # 004b044a
    imul eax, eax, 0x1e4                         # 004b044e
    mov esi, dword ptr [ebp - local_14]          # 004b0454
    lea eax, [esi + eax + field_43]              # 004b0457
    mov dword ptr [eax + edx + field_8], ecx     # 004b045b
    movsx ecx, word ptr [ebp - local_8]          # 004b045f
    imul ecx, ecx, 0x1e4                         # 004b0463
    mov edx, dword ptr [ebp - local_14]          # 004b0469
    lea ecx, [edx + ecx + field_43]              # 004b046c
    movsx esi, word ptr [ebp - local_4]          # 004b0470
    imul esi, esi, 0x2c                          # 004b0474
    mov edx, dword ptr [ebp - local_c]           # 004b0477
    movsx edi, word ptr [edx + field_1a8]        # 004b047a
    mov eax, dword ptr [ebp - local_14]          # 004b0481
    mov eax, dword ptr [eax + field_152d]        # 004b0484
    cdq                                          # 004b048a
    idiv edi                                     # 004b048b
    mov ecx, dword ptr [ecx + esi + field_10]    # 004b048d
    {load} add ecx, eax                          # 004b0491
    movsx edx, word ptr [ebp - local_4]          # 004b0493
    imul edx, edx, 0x2c                          # 004b0497
    movsx eax, word ptr [ebp - local_8]          # 004b049a
    imul eax, eax, 0x1e4                         # 004b049e
    mov esi, dword ptr [ebp - local_14]          # 004b04a4
    lea eax, [esi + eax + field_43]              # 004b04a7
    mov dword ptr [eax + edx + field_10], ecx    # 004b04ab
    jmp.d32 L_004b0554                           # 004b04af
L_004b04b4:
    # block 0x004b04b4: entered by switch case, 42 instruction(s), falls into the block at 0x004b0554
    movsx ecx, word ptr [ebp - local_8]          # 004b04b4
    imul ecx, ecx, 0x1e4                         # 004b04b8
    mov edx, dword ptr [ebp - local_14]          # 004b04be
    lea ecx, [edx + ecx + field_43]              # 004b04c1
    movsx esi, word ptr [ebp - local_4]          # 004b04c5
    imul esi, esi, 0x2c                          # 004b04c9
    mov edx, dword ptr [ebp - local_c]           # 004b04cc
    movsx edi, word ptr [edx + field_1a8]        # 004b04cf
    mov eax, dword ptr [ebp - local_14]          # 004b04d6
    mov eax, dword ptr [eax + field_1529]        # 004b04d9
    cdq                                          # 004b04df
    idiv edi                                     # 004b04e0
    mov ecx, dword ptr [ecx + esi + field_4]     # 004b04e2
    {load} add ecx, eax                          # 004b04e6
    movsx edx, word ptr [ebp - local_4]          # 004b04e8
    imul edx, edx, 0x2c                          # 004b04ec
    movsx eax, word ptr [ebp - local_8]          # 004b04ef
    imul eax, eax, 0x1e4                         # 004b04f3
    mov esi, dword ptr [ebp - local_14]          # 004b04f9
    lea eax, [esi + eax + field_43]              # 004b04fc
    mov dword ptr [eax + edx + field_4], ecx     # 004b0500
    movsx ecx, word ptr [ebp - local_8]          # 004b0504
    imul ecx, ecx, 0x1e4                         # 004b0508
    mov edx, dword ptr [ebp - local_14]          # 004b050e
    lea ecx, [edx + ecx + field_43]              # 004b0511
    movsx esi, word ptr [ebp - local_4]          # 004b0515
    imul esi, esi, 0x2c                          # 004b0519
    mov edx, dword ptr [ebp - local_c]           # 004b051c
    movsx edi, word ptr [edx + field_1a8]        # 004b051f
    mov eax, dword ptr [ebp - local_14]          # 004b0526
    mov eax, dword ptr [eax + field_1529]        # 004b0529
    cdq                                          # 004b052f
    idiv edi                                     # 004b0530
    mov ecx, dword ptr [ecx + esi + field_c]     # 004b0532
    {load} add ecx, eax                          # 004b0536
    movsx edx, word ptr [ebp - local_4]          # 004b0538
    imul edx, edx, 0x2c                          # 004b053c
    movsx eax, word ptr [ebp - local_8]          # 004b053f
    imul eax, eax, 0x1e4                         # 004b0543
    mov esi, dword ptr [ebp - local_14]          # 004b0549
    lea eax, [esi + eax + field_43]              # 004b054c
    mov dword ptr [eax + edx + field_c], ecx     # 004b0550
L_004b0554:
    # block 0x004b0554: entered by ja at 0x004b02b5; jmp at 0x004b0365; jmp at 0x004b040a; jmp at 0x004b04af, 14 instruction(s), ends with jl to 0x004b0595 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004b0554
    mov dx, word ptr [ecx + field_1533]          # 004b0557
    add dx, 0x1                                  # 004b055e
    mov eax, dword ptr [ebp - local_14]          # 004b0562
    mov word ptr [eax + field_1533], dx          # 004b0565
    mov ecx, dword ptr [ebp - local_14]          # 004b056c
    movsx edx, word ptr [ecx + field_1533]       # 004b056f
    mov eax, dword ptr [ebp - local_c]           # 004b0576
    movsx ecx, word ptr [eax + field_1a8]        # 004b0579
    mov eax, dword ptr [ebp - local_c]           # 004b0580
    movsx eax, word ptr [eax + field_29]         # 004b0583
    imul ecx, eax                                # 004b0587
    {load} cmp edx, ecx                          # 004b058a
    jl.d8 L_004b0595                             # 004b058c
    # block 0x004b058e: entered by fall-through of jl at 0x004b058c, 1 instruction(s), falls into the block at 0x004b0595
    mov dword ptr [ebp - local_10], 0x1          # 004b058e
L_004b0595:
    # block 0x004b0595: entered by jl at 0x004b058c, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_10]          # 004b0595
    pop edi                                      # 004b0598
    pop esi                                      # 004b0599
    {load} mov esp, ebp                          # 004b059a
    pop ebp                                      # 004b059c
    ret                                          # 004b059d

# --- data items (not part of the function) -------------------------
.org 0x004b059e - 0x401000
SWTAB_004b059e:  # 4 case address(es)
    .long L_004b02c5 - .text + 0x401000
    .long L_004b036a - .text + 0x401000
    .long L_004b040f - .text + 0x401000
    .long L_004b04b4 - .text + 0x401000
.set SWTAB_004b059e_VA, SWTAB_004b059e - .text + 0x401000

