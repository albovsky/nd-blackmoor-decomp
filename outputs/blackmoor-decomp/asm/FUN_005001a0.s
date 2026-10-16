# FUN_005001a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005001a0
# extent:       0x005001a0-0x0050091d (1917 code bytes)
# span:         0x005001a0-0x00500920 (code 1917, tables 0, padding 3)
# sha256:       b16bf2abbcf8a7857495ba9e3db5337bbf7acb72c33a3ac5fcbd2621a83f34d0
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005001a0
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_108, local_728 and 4 more
# fields:       [eax + n] field_e0, field_1c0; [ecx + n] field_1, field_minus_4; [esi + n] field_4, field_8, field_e4, field_minus_e0
# callees:      calls FUN_0050c920, FUN_0050ea90, FUN_00500980, FUN_00500950, FUN_00500920, FUN_0050e19e, FUN_0050ce04, FUN_0050e30f
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 620 instruction(s), 57 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_minus_e0, 0xe0  # offset -0xe0
.equ local_108, 0x108  # offset -0x108
.equ local_728, 0x728  # offset -0x728
.equ local_808, 0x808  # offset -0x808
.equ local_7e2c, 0x7e2c  # offset -0x7e2c
.equ local_7f08, 0x7f08  # offset -0x7f08
.equ local_7f14, 0x7f14  # offset -0x7f14
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_1c0, 0x1c0  # offset +0x1c0

# --- external targets -----------------------------------------------
.set FUN_00500920, .text + (0x00500920 - 0x401000)
.set FUN_00500950, .text + (0x00500950 - 0x401000)
.set FUN_00500980, .text + (0x00500980 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050e30f, .text + (0x0050e30f - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x005001a0 - 0x401000
.globl FUN_005001a0
FUN_005001a0:
    # block 0x005001a0: entry, 27 instruction(s), calls FUN_0050c920, FUN_0050ea90, falls into the block at 0x005001fc
    push ebp                                     # 005001a0
    {load} mov ebp, esp                          # 005001a1
    mov eax, 0x7f08                              # 005001a3
    call FUN_0050c920                            # 005001a8
    mov eax, dword ptr [ebp + arg_10]            # 005001ad
    push ebx                                     # 005001b0
    shl eax, 0x2                                 # 005001b1
    add eax, 0x3                                 # 005001b4
    push esi                                     # 005001b7
    push edi                                     # 005001b8
    and al, -0x4                                 # 005001b9
    call FUN_0050c920                            # 005001bb
    mov dword ptr [ebp - local_18], esp          # 005001c0
    push 0x44                                    # 005001c3
    call FUN_0050ea90                            # 005001c5
    mov edx, dword ptr [ebp + arg_8]             # 005001ca
    add esp, 0x4                                 # 005001cd
    mov dword ptr [ebp - local_8], eax           # 005001d0
    mov ecx, 0x1dc0                              # 005001d3
    {load} xor eax, eax                          # 005001d8
    lea edi, [ebp - local_7f08]                  # 005001da
    rep stosd dword ptr es:[edi], eax            # 005001e0
    lea ecx, [ebp - local_7f08]                  # 005001e2
    mov dword ptr [ebp - local_c], edx           # 005001e8
    mov dword ptr [ebp - local_4], ecx           # 005001eb
    mov dword ptr [ebp - local_10], 0x560bd8     # 005001ee
    mov dword ptr [ebp - local_14], 0x560a78     # 005001f5
L_005001fc:
    # block 0x005001fc: entered by jl at 0x0050040a, 3 instruction(s), falls into the block at 0x0050020a
    mov esi, dword ptr [ebp - local_14]          # 005001fc
    lea edi, [ebp - local_108]                   # 005001ff
    mov ebx, 0x38                                # 00500205
L_0050020a:
    # block 0x0050020a: entered by jne at 0x00500252, 3 instruction(s), falls into the block at 0x00500217
    fld dword ptr [0x52e5f0]                     # 0050020a
    {load} mov ecx, esi                          # 00500210
    mov edx, 0x4                                 # 00500212
L_00500217:
    # block 0x00500217: entered by jne at 0x00500247, 2 instruction(s), ends with jge to 0x0050022e (forward)
    cmp ecx, 0x560bd8                            # 00500217
    jge.d8 L_0050022e                            # 0050021d
    # block 0x0050021f: entered by fall-through of jge at 0x0050021d, 4 instruction(s), ends with jne to 0x00500243 (forward)
    fcom dword ptr [ecx]                         # 0050021f
    fnstsw ax                                    # 00500221
    test ah, 0x41                                # 00500223
    jne.d8 L_00500243                            # 00500226
    # block 0x00500228: entered by fall-through of jne at 0x00500226, 3 instruction(s), ends with forward jump to 0x00500243
    fstp st(0)                                   # 00500228
    fld dword ptr [ecx]                          # 0050022a
    jmp.d8 L_00500243                            # 0050022c
L_0050022e:
    # block 0x0050022e: entered by jge at 0x0050021d, 4 instruction(s), ends with jne to 0x00500243 (forward)
    fcom dword ptr [0x560bd4]                    # 0050022e
    fnstsw ax                                    # 00500234
    test ah, 0x41                                # 00500236
    jne.d8 L_00500243                            # 00500239
    # block 0x0050023b: entered by fall-through of jne at 0x00500239, 2 instruction(s), falls into the block at 0x00500243
    fstp st(0)                                   # 0050023b
    fld dword ptr [0x560bd4]                     # 0050023d
L_00500243:
    # block 0x00500243: entered by jne at 0x00500226; jmp at 0x0050022c; jne at 0x00500239, 3 instruction(s), ends with jne to 0x00500217 (backward)
    add ecx, 0x4                                 # 00500243
    dec edx                                      # 00500246
    jne.d8 L_00500217                            # 00500247
    # block 0x00500249: entered by fall-through of jne at 0x00500247, 5 instruction(s), ends with jne to 0x0050020a (backward)
    fstp dword ptr [edi]                         # 00500249
    add esi, 0x4                                 # 0050024b
    add edi, 0x4                                 # 0050024e
    dec ebx                                      # 00500251
    jne.d8 L_0050020a                            # 00500252
    # block 0x00500254: entered by fall-through of jne at 0x00500252, 17 instruction(s), falls into the block at 0x0050028d
    mov eax, dword ptr [ebp - local_4]           # 00500254
    mov edx, dword ptr [ebp - local_10]          # 00500257
    mov ecx, 0x150                               # 0050025a
    {load} mov esi, edx                          # 0050025f
    lea edi, [eax + field_1c0]                   # 00500261
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00500267
    mov ecx, 0x38                                # 00500269
    {load} mov esi, edx                          # 0050026e
    {load} mov edi, eax                          # 00500270
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00500272
    lea edi, [eax + field_e0]                    # 00500274
    mov ecx, 0x38                                # 0050027a
    {load} mov esi, edx                          # 0050027f
    mov dword ptr [ebp - local_28], edi          # 00500281
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00500284
    {load} mov ecx, eax                          # 00500286
    mov edi, 0x8                                 # 00500288
L_0050028d:
    # block 0x0050028d: entered by jne at 0x00500301, 1 instruction(s), falls into the block at 0x00500292
    mov esi, 0x10                                # 0050028d
L_00500292:
    # block 0x00500292: entered by jg at 0x005002fb, 12 instruction(s), ends with je to 0x005002ca (forward)
    {load} mov eax, esi                          # 00500292
    cdq                                          # 00500294
    {load} xor eax, edx                          # 00500295
    {load} sub eax, edx                          # 00500297
    mov dword ptr [ebp + arg_8], eax             # 00500299
    fild dword ptr [ebp + arg_8]                 # 0050029c
    fmul dword ptr [ebp + arg_18]                # 0050029f
    fadd dword ptr [ebp + arg_14]                # 005002a2
    fcom qword ptr [0x52c7b0]                    # 005002a5
    fnstsw ax                                    # 005002ab
    test ah, 0x1                                 # 005002ad
    je.d8 L_005002ca                             # 005002b0
    # block 0x005002b2: entered by fall-through of je at 0x005002b0, 5 instruction(s), ends with jne to 0x005002ca (forward)
    fld dword ptr [ebp + arg_14]                 # 005002b2
    fcomp dword ptr [0x52db78]                   # 005002b5
    fnstsw ax                                    # 005002bb
    test ah, 0x41                                # 005002bd
    jne.d8 L_005002ca                            # 005002c0
    # block 0x005002c2: entered by fall-through of jne at 0x005002c0, 2 instruction(s), falls into the block at 0x005002ca
    fstp st(0)                                   # 005002c2
    fld dword ptr [0x52db78]                     # 005002c4
L_005002ca:
    # block 0x005002ca: entered by je at 0x005002b0; jne at 0x005002c0, 4 instruction(s), ends with jne to 0x005002ef (forward)
    fcom qword ptr [0x52c7b0]                    # 005002ca
    fnstsw ax                                    # 005002d0
    test ah, 0x41                                # 005002d2
    jne.d8 L_005002ef                            # 005002d5
    # block 0x005002d7: entered by fall-through of jne at 0x005002d5, 5 instruction(s), ends with je to 0x005002ef (forward)
    fld dword ptr [ebp + arg_14]                 # 005002d7
    fcomp dword ptr [0x52db78]                   # 005002da
    fnstsw ax                                    # 005002e0
    test ah, 0x1                                 # 005002e2
    je.d8 L_005002ef                             # 005002e5
    # block 0x005002e7: entered by fall-through of je at 0x005002e5, 2 instruction(s), falls into the block at 0x005002ef
    fstp st(0)                                   # 005002e7
    fld dword ptr [0x52db78]                     # 005002e9
L_005002ef:
    # block 0x005002ef: entered by jne at 0x005002d5; je at 0x005002e5, 6 instruction(s), ends with jg to 0x00500292 (backward)
    fadd dword ptr [ecx]                         # 005002ef
    add ecx, 0x4                                 # 005002f1
    dec esi                                      # 005002f4
    cmp esi, -0x28                               # 005002f5
    fstp dword ptr [ecx - field_minus_4]         # 005002f8
    jg.d8 L_00500292                             # 005002fb
    # block 0x005002fd: entered by fall-through of jg at 0x005002fb, 3 instruction(s), ends with jne to 0x0050028d (backward)
    dec edi                                      # 005002fd
    mov dword ptr [ebp - local_20], ecx          # 005002fe
    jne.d8 L_0050028d                            # 00500301
    # block 0x00500303: entered by fall-through of jne at 0x00500301, 4 instruction(s), falls into the block at 0x00500316
    mov eax, dword ptr [ebp - local_4]           # 00500303
    mov dword ptr [ebp + arg_8], 0x0             # 00500306
    lea ebx, [ebp - local_808]                   # 0050030d
    mov dword ptr [ebp - local_4], eax           # 00500313
L_00500316:
    # block 0x00500316: entered by jl at 0x005003a7, 4 instruction(s), ends with jl to 0x00500328 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00500316
    mov dword ptr [ebp - local_1c], 0x2          # 00500319
    cmp eax, 0x2                                 # 00500320
    jl.d8 L_00500328                             # 00500323
    # block 0x00500325: entered by fall-through of jl at 0x00500323, 1 instruction(s), falls into the block at 0x00500328
    mov dword ptr [ebp - local_1c], eax          # 00500325
L_00500328:
    # block 0x00500328: entered by jl at 0x00500323, 37 instruction(s), calls FUN_00500980, FUN_00500950, ends with jl to 0x00500316 (backward)
    mov ecx, dword ptr [ebp - local_c]           # 00500328
    mov edx, dword ptr [ebp - local_4]           # 0050032b
    push ecx                                     # 0050032e
    fld dword ptr [ecx]                          # 0050032f
    fadd qword ptr [0x52c680]                    # 00500331
    fild dword ptr [ebp - local_1c]              # 00500337
    fmul qword ptr [0x52e208]                    # 0050033a
    fsubp st(1), st                              # 00500340
    fsub qword ptr [0x52e5e8]                    # 00500342
    fstp dword ptr [esp]                         # 00500348
    push edx                                     # 0050034b
    call FUN_00500980                            # 0050034c
    fild dword ptr [ebp + arg_8]                 # 00500351
    add esp, 0x4                                 # 00500354
    mov ecx, 0x38                                # 00500357
    lea esi, [ebp - local_108]                   # 0050035c
    {load} mov edi, ebx                          # 00500362
    fmul dword ptr [0x52db5c]                    # 00500364
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0050036a
    fsubr qword ptr [0x52c680]                   # 0050036c
    fsub qword ptr [0x52e5e8]                    # 00500372
    fstp dword ptr [esp]                         # 00500378
    push ebx                                     # 0050037b
    call FUN_00500980                            # 0050037c
    mov esi, dword ptr [ebp - local_4]           # 00500381
    push esi                                     # 00500384
    push ebx                                     # 00500385
    call FUN_00500950                            # 00500386
    mov eax, dword ptr [ebp + arg_8]             # 0050038b
    add esp, 0x10                                # 0050038e
    inc eax                                      # 00500391
    add esi, 0xe0                                # 00500392
    add ebx, 0xe0                                # 00500398
    cmp eax, 0x8                                 # 0050039e
    mov dword ptr [ebp + arg_8], eax             # 005003a1
    mov dword ptr [ebp - local_4], esi           # 005003a4
    jl.d32 L_00500316                            # 005003a7
    # block 0x005003ad: entered by fall-through of jl at 0x005003a7, 3 instruction(s), falls into the block at 0x005003bb
    mov edi, dword ptr [ebp - local_28]          # 005003ad
    lea esi, [ebp - local_728]                   # 005003b0
    mov ebx, 0x7                                 # 005003b6
L_005003bb:
    # block 0x005003bb: entered by jne at 0x005003df, 12 instruction(s), calls FUN_00500920, ends with jne to 0x005003bb (backward)
    lea eax, [esi - field_minus_e0]              # 005003bb
    push eax                                     # 005003c1
    push esi                                     # 005003c2
    call FUN_00500920                            # 005003c3
    push esi                                     # 005003c8
    push edi                                     # 005003c9
    call FUN_00500920                            # 005003ca
    add esp, 0x10                                # 005003cf
    add esi, 0xe0                                # 005003d2
    add edi, 0xe0                                # 005003d8
    dec ebx                                      # 005003de
    jne.d8 L_005003bb                            # 005003df
    # block 0x005003e1: entered by fall-through of jne at 0x005003df, 13 instruction(s), ends with jl to 0x005001fc (backward)
    mov eax, dword ptr [ebp - local_14]          # 005003e1
    mov edi, dword ptr [ebp - local_10]          # 005003e4
    mov edx, dword ptr [ebp - local_c]           # 005003e7
    mov ecx, dword ptr [ebp - local_20]          # 005003ea
    add eax, 0x10                                # 005003ed
    add edi, 0x540                               # 005003f0
    add edx, 0x4                                 # 005003f6
    cmp eax, 0x560b88                            # 005003f9
    mov dword ptr [ebp - local_10], edi          # 005003fe
    mov dword ptr [ebp - local_14], eax          # 00500401
    mov dword ptr [ebp - local_c], edx           # 00500404
    mov dword ptr [ebp - local_4], ecx           # 00500407
    jl.d32 L_005001fc                            # 0050040a
    # block 0x00500410: entered by fall-through of jl at 0x0050040a, 1 instruction(s), falls into the block at 0x00500417
    mov dword ptr [ebp + arg_14], 0x0            # 00500410
L_00500417:
    # block 0x00500417: entered by jl at 0x00500907, 59 instruction(s), calls FUN_0050ea90, FUN_0050e19e, FUN_0050ce04, FUN_0050e30f, ends with jle to 0x005004d7 (forward)
    push 0x20                                    # 00500417
    call FUN_0050ea90                            # 00500419
    fild dword ptr [ebp + arg_14]                # 0050041e
    mov edx, dword ptr [ebp - local_8]           # 00500421
    mov ebx, dword ptr [ebp + arg_14]            # 00500424
    push ecx                                     # 00500427
    fmul qword ptr [0x52cac0]                    # 00500428
    mov dword ptr [edx + 4*ebx], eax             # 0050042e
    fst qword ptr [ebp - local_24]               # 00500431
    fadd qword ptr [0x52e5c0]                    # 00500434
    fmul qword ptr [0x52e5b0]                    # 0050043a
    fldl2e                                       # 00500440
    fmulp st(1), st                              # 00500442
    fld st(0)                                    # 00500444
    frndint                                      # 00500446
    fxch st(1)                                   # 00500448
    fsub st, st(1)                               # 0050044a
    f2xm1                                        # 0050044c
    fld1                                         # 0050044e
    faddp st(1), st                              # 00500450
    fscale                                       # 00500452
    fstp st(1)                                   # 00500454
    fdiv dword ptr [ebp + arg_c]                 # 00500456
    fstp qword ptr [esp]                         # 00500459
    call FUN_0050e19e                            # 0050045c
    call FUN_0050ce04                            # 00500461
    {load} mov edi, eax                          # 00500466
    mov dword ptr [ebp + arg_8], edi             # 00500468
    fild dword ptr [ebp + arg_8]                 # 0050046b
    fmul dword ptr [ebp + arg_c]                 # 0050046e
    fadd dword ptr [0x52cbf4]                    # 00500471
    fldln2                                       # 00500477
    fxch st(1)                                   # 00500479
    fyl2x                                        # 0050047b
    fmul qword ptr [0x52e5c8]                    # 0050047d
    fsub qword ptr [0x52e5c0]                    # 00500483
    .insn 0xdc, 0xc0                             # 00500489
    fstp qword ptr [esp]                         # 0050048b
    call FUN_0050e30f                            # 0050048e
    call FUN_0050ce04                            # 00500493
    inc edi                                      # 00500498
    {load} mov esi, eax                          # 00500499
    mov dword ptr [ebp + arg_8], edi             # 0050049b
    mov dword ptr [ebp - local_c], esi           # 0050049e
    fild dword ptr [ebp + arg_8]                 # 005004a1
    fmul dword ptr [ebp + arg_c]                 # 005004a4
    fldln2                                       # 005004a7
    fxch st(1)                                   # 005004a9
    fyl2x                                        # 005004ab
    fmul qword ptr [0x52e5c8]                    # 005004ad
    fsub qword ptr [0x52e5c0]                    # 005004b3
    .insn 0xdc, 0xc0                             # 005004b9
    fstp qword ptr [esp]                         # 005004bb
    call FUN_0050e19e                            # 005004be
    add esp, 0x8                                 # 005004c3
    call FUN_0050ce04                            # 005004c6
    {load} cmp esi, ebx                          # 005004cb
    mov dword ptr [ebp - local_4], eax           # 005004cd
    jle.d8 L_005004d7                            # 005004d0
    # block 0x005004d2: entered by fall-through of jle at 0x005004d0, 2 instruction(s), falls into the block at 0x005004d7
    {load} mov esi, ebx                          # 005004d2
    mov dword ptr [ebp - local_c], esi           # 005004d4
L_005004d7:
    # block 0x005004d7: entered by jle at 0x005004d0, 3 instruction(s), ends with jge to 0x005004e0 (forward)
    {load} xor ebx, ebx                          # 005004d7
    {load} cmp esi, ebx                          # 005004d9
    jge.d8 L_005004e0                            # 005004db
    # block 0x005004dd: entered by fall-through of jge at 0x005004db, 1 instruction(s), falls into the block at 0x005004e0
    mov dword ptr [ebp - local_c], ebx           # 005004dd
L_005004e0:
    # block 0x005004e0: entered by jge at 0x005004db, 2 instruction(s), ends with jl to 0x005004ec (forward)
    cmp eax, 0x11                                # 005004e0
    jl.d8 L_005004ec                             # 005004e3
    # block 0x005004e5: entered by fall-through of jl at 0x005004e3, 1 instruction(s), falls into the block at 0x005004ec
    mov dword ptr [ebp - local_4], 0x10          # 005004e5
L_005004ec:
    # block 0x005004ec: entered by jl at 0x005004e3, 1 instruction(s), falls into the block at 0x005004ef
    mov dword ptr [ebp - local_1c], ebx          # 005004ec
L_005004ef:
    # block 0x005004ef: entered by jl at 0x005008f7, 10 instruction(s), calls FUN_0050ea90, ends with jle to 0x00500519 (forward)
    push 0xe8                                    # 005004ef
    call FUN_0050ea90                            # 005004f4
    mov ecx, dword ptr [ebp - local_8]           # 005004f9
    mov edx, dword ptr [ebp + arg_14]            # 005004fc
    add esp, 0x4                                 # 005004ff
    mov ecx, dword ptr [ecx + 4*edx]             # 00500502
    mov dword ptr [ecx + 4*ebx], eax             # 00500505
    mov ecx, dword ptr [ebp + arg_10]            # 00500508
    test ecx, ecx                                # 0050050b
    jle.d8 L_00500519                            # 0050050d
    # block 0x0050050f: entered by fall-through of jle at 0x0050050d, 3 instruction(s), falls into the block at 0x00500519
    mov edi, dword ptr [ebp - local_18]          # 0050050f
    mov eax, 0x4479c000                          # 00500512
    rep stosd dword ptr es:[edi], eax            # 00500517
L_00500519:
    # block 0x00500519: entered by jle at 0x0050050d, 5 instruction(s), ends with jg to 0x00500697 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00500519
    mov ecx, dword ptr [ebp - local_4]           # 0050051c
    {load} cmp eax, ecx                          # 0050051f
    mov dword ptr [ebp + arg_18], eax            # 00500521
    jg.d32 L_00500697                            # 00500524
    # block 0x0050052a: entered by fall-through of jg at 0x00500524, 10 instruction(s), falls into the block at 0x00500552
    lea eax, [ebx + 8*eax]                       # 0050052a
    lea ecx, [8*eax]                             # 0050052d
    lea edx, [8*eax]                             # 00500534
    {load} sub ecx, eax                          # 0050053b
    {load} sub edx, eax                          # 0050053d
    shl ecx, 0x3                                 # 0050053f
    shl edx, 0x5                                 # 00500542
    mov dword ptr [ebp - local_14], ecx          # 00500545
    lea eax, [ebp + edx - local_7e2c]            # 00500548
    mov dword ptr [ebp - local_10], eax          # 0050054f
L_00500552:
    # block 0x00500552: entered by jle at 0x0050068e, 4 instruction(s), falls into the block at 0x00500560
    fild dword ptr [ebp + arg_18]                # 00500552
    {load} xor esi, esi                          # 00500555
    mov dword ptr [ebp + arg_8], esi             # 00500557
    fmul qword ptr [0x52cac0]                    # 0050055a
L_00500560:
    # block 0x00500560: entered by jl at 0x0050063e, 41 instruction(s), calls FUN_0050ce04, ends with jge to 0x005005dd (forward)
    fild dword ptr [ebp + arg_8]                 # 00500560
    fmul qword ptr [0x52e5b8]                    # 00500563
    fadd st, st(1)                               # 00500569
    fld st(0)                                    # 0050056b
    fsub qword ptr [0x52e5e0]                    # 0050056d
    fadd qword ptr [0x52e5c0]                    # 00500573
    fmul qword ptr [0x52e5b0]                    # 00500579
    fldl2e                                       # 0050057f
    fmulp st(1), st                              # 00500581
    fld st(0)                                    # 00500583
    frndint                                      # 00500585
    fxch st(1)                                   # 00500587
    fsub st, st(1)                               # 00500589
    f2xm1                                        # 0050058b
    fld1                                         # 0050058d
    faddp st(1), st                              # 0050058f
    fscale                                       # 00500591
    fstp st(1)                                   # 00500593
    fdiv dword ptr [ebp + arg_c]                 # 00500595
    call FUN_0050ce04                            # 00500598
    fsub qword ptr [0x52e5d8]                    # 0050059d
    {load} mov edi, eax                          # 005005a3
    fadd qword ptr [0x52e5c0]                    # 005005a5
    fmul qword ptr [0x52e5b0]                    # 005005ab
    fldl2e                                       # 005005b1
    fmulp st(1), st                              # 005005b3
    fld st(0)                                    # 005005b5
    frndint                                      # 005005b7
    fxch st(1)                                   # 005005b9
    fsub st, st(1)                               # 005005bb
    f2xm1                                        # 005005bd
    fld1                                         # 005005bf
    faddp st(1), st                              # 005005c1
    fscale                                       # 005005c3
    fstp st(1)                                   # 005005c5
    fdiv dword ptr [ebp + arg_c]                 # 005005c7
    fadd qword ptr [0x52c598]                    # 005005ca
    call FUN_0050ce04                            # 005005d0
    test edi, edi                                # 005005d5
    {load} mov ebx, eax                          # 005005d7
    jge.d8 L_005005dd                            # 005005d9
    # block 0x005005db: entered by fall-through of jge at 0x005005d9, 1 instruction(s), falls into the block at 0x005005dd
    {load} xor edi, edi                          # 005005db
L_005005dd:
    # block 0x005005dd: entered by jge at 0x005005d9, 3 instruction(s), ends with jle to 0x005005e6 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 005005dd
    {load} cmp edi, edx                          # 005005e0
    jle.d8 L_005005e6                            # 005005e2
    # block 0x005005e4: entered by fall-through of jle at 0x005005e2, 1 instruction(s), falls into the block at 0x005005e6
    {load} mov edi, edx                          # 005005e4
L_005005e6:
    # block 0x005005e6: entered by jle at 0x005005e2, 2 instruction(s), ends with jge to 0x005005ec (forward)
    {load} cmp edi, esi                          # 005005e6
    jge.d8 L_005005ec                            # 005005e8
    # block 0x005005ea: entered by fall-through of jge at 0x005005e8, 1 instruction(s), falls into the block at 0x005005ec
    {load} mov esi, edi                          # 005005ea
L_005005ec:
    # block 0x005005ec: entered by jge at 0x005005e8, 2 instruction(s), ends with jge to 0x005005f2 (forward)
    test ebx, ebx                                # 005005ec
    jge.d8 L_005005f2                            # 005005ee
    # block 0x005005f0: entered by fall-through of jge at 0x005005ee, 1 instruction(s), falls into the block at 0x005005f2
    {load} xor ebx, ebx                          # 005005f0
L_005005f2:
    # block 0x005005f2: entered by jge at 0x005005ee, 2 instruction(s), ends with jle to 0x005005f8 (forward)
    {load} cmp ebx, edx                          # 005005f2
    jle.d8 L_005005f8                            # 005005f4
    # block 0x005005f6: entered by fall-through of jle at 0x005005f4, 1 instruction(s), falls into the block at 0x005005f8
    {load} mov ebx, edx                          # 005005f6
L_005005f8:
    # block 0x005005f8: entered by jle at 0x005005f4, 2 instruction(s), ends with jge to 0x00500634 (forward)
    {load} cmp esi, ebx                          # 005005f8
    jge.d8 L_00500634                            # 005005fa
    # block 0x005005fc: entered by fall-through of jge at 0x005005fa, 2 instruction(s), falls into the block at 0x00500602
    mov ecx, dword ptr [ebp - local_18]          # 005005fc
    lea ecx, [ecx + 4*esi]                       # 005005ff
L_00500602:
    # block 0x00500602: entered by jl at 0x00500632, 2 instruction(s), ends with jge to 0x00500634 (forward)
    {load} cmp esi, edx                          # 00500602
    jge.d8 L_00500634                            # 00500604
    # block 0x00500606: entered by fall-through of jge at 0x00500604, 9 instruction(s), ends with jne to 0x00500629 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00500606
    mov eax, dword ptr [ebp + arg_8]             # 00500609
    fld dword ptr [ecx]                          # 0050060c
    {load} add edx, eax                          # 0050060e
    fcomp dword ptr [ebp + 4*edx - local_7f08]   # 00500610
    lea edx, [ebp + 4*edx - local_7f08]          # 00500617
    fnstsw ax                                    # 0050061e
    test ah, 0x41                                # 00500620
    jne.d8 L_00500629                            # 00500623
    # block 0x00500625: entered by fall-through of jne at 0x00500623, 2 instruction(s), falls into the block at 0x00500629
    mov edx, dword ptr [edx]                     # 00500625
    mov dword ptr [ecx], edx                     # 00500627
L_00500629:
    # block 0x00500629: entered by jne at 0x00500623, 5 instruction(s), ends with jl to 0x00500602 (backward)
    mov edx, dword ptr [ebp + arg_10]            # 00500629
    inc esi                                      # 0050062c
    add ecx, 0x4                                 # 0050062d
    {load} cmp esi, ebx                          # 00500630
    jl.d8 L_00500602                             # 00500632
L_00500634:
    # block 0x00500634: entered by jge at 0x005005fa; jge at 0x00500604; fall-through of jl at 0x00500632, 5 instruction(s), ends with jl to 0x00500560 (backward)
    mov eax, dword ptr [ebp + arg_8]             # 00500634
    inc eax                                      # 00500637
    cmp eax, 0x38                                # 00500638
    mov dword ptr [ebp + arg_8], eax             # 0050063b
    jl.d32 L_00500560                            # 0050063e
    # block 0x00500644: entered by fall-through of jl at 0x0050063e, 3 instruction(s), ends with jge to 0x0050066a (forward)
    {load} cmp esi, edx                          # 00500644
    fstp st(0)                                   # 00500646
    jge.d8 L_0050066a                            # 00500648
    # block 0x0050064a: entered by fall-through of jge at 0x00500648, 3 instruction(s), falls into the block at 0x00500652
    mov eax, dword ptr [ebp - local_18]          # 0050064a
    {load} sub edx, esi                          # 0050064d
    lea ecx, [eax + 4*esi]                       # 0050064f
L_00500652:
    # block 0x00500652: entered by jne at 0x00500668, 6 instruction(s), ends with jne to 0x00500664 (forward)
    mov esi, dword ptr [ebp - local_10]          # 00500652
    fld dword ptr [ecx]                          # 00500655
    fcomp dword ptr [esi]                        # 00500657
    fnstsw ax                                    # 00500659
    test ah, 0x41                                # 0050065b
    jne.d8 L_00500664                            # 0050065e
    # block 0x00500660: entered by fall-through of jne at 0x0050065e, 2 instruction(s), falls into the block at 0x00500664
    mov eax, dword ptr [esi]                     # 00500660
    mov dword ptr [ecx], eax                     # 00500662
L_00500664:
    # block 0x00500664: entered by jne at 0x0050065e, 3 instruction(s), ends with jne to 0x00500652 (backward)
    add ecx, 0x4                                 # 00500664
    dec edx                                      # 00500667
    jne.d8 L_00500652                            # 00500668
L_0050066a:
    # block 0x0050066a: entered by jge at 0x00500648; fall-through of jne at 0x00500668, 12 instruction(s), ends with jle to 0x00500552 (backward)
    mov eax, dword ptr [ebp + arg_18]            # 0050066a
    mov esi, dword ptr [ebp - local_14]          # 0050066d
    mov edx, dword ptr [ebp - local_10]          # 00500670
    mov ecx, dword ptr [ebp - local_4]           # 00500673
    inc eax                                      # 00500676
    add esi, 0x1c0                               # 00500677
    add edx, 0x700                               # 0050067d
    {load} cmp eax, ecx                          # 00500683
    mov dword ptr [ebp + arg_18], eax            # 00500685
    mov dword ptr [ebp - local_14], esi          # 00500688
    mov dword ptr [ebp - local_10], edx          # 0050068b
    jle.d32 L_00500552                           # 0050068e
    # block 0x00500694: entered by fall-through of jle at 0x0050068e, 1 instruction(s), falls into the block at 0x00500697
    mov ebx, dword ptr [ebp - local_1c]          # 00500694
L_00500697:
    # block 0x00500697: entered by jg at 0x00500524, 4 instruction(s), ends with jge to 0x005007eb (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 00500697
    lea eax, [ecx + field_1]                     # 0050069a
    cmp eax, 0x11                                # 0050069d
    jge.d32 L_005007eb                           # 005006a0
    # block 0x005006a6: entered by fall-through of jge at 0x005006a0, 2 instruction(s), falls into the block at 0x005006ab
    {load} xor esi, esi                          # 005006a6
    mov dword ptr [ebp + arg_8], esi             # 005006a8
L_005006ab:
    # block 0x005006ab: entered by jl at 0x005007a5, 41 instruction(s), calls FUN_0050ce04, ends with jge to 0x0050072a (forward)
    fild dword ptr [ebp + arg_8]                 # 005006ab
    fmul qword ptr [0x52e5b8]                    # 005006ae
    fadd qword ptr [ebp - local_24]              # 005006b4
    fld st(0)                                    # 005006b7
    fsub qword ptr [0x52e5e0]                    # 005006b9
    fadd qword ptr [0x52e5c0]                    # 005006bf
    fmul qword ptr [0x52e5b0]                    # 005006c5
    fldl2e                                       # 005006cb
    fmulp st(1), st                              # 005006cd
    fld st(0)                                    # 005006cf
    frndint                                      # 005006d1
    fxch st(1)                                   # 005006d3
    fsub st, st(1)                               # 005006d5
    f2xm1                                        # 005006d7
    fld1                                         # 005006d9
    faddp st(1), st                              # 005006db
    fscale                                       # 005006dd
    fstp st(1)                                   # 005006df
    fdiv dword ptr [ebp + arg_c]                 # 005006e1
    call FUN_0050ce04                            # 005006e4
    fsub qword ptr [0x52e5d8]                    # 005006e9
    {load} mov edi, eax                          # 005006ef
    fadd qword ptr [0x52e5c0]                    # 005006f1
    fmul qword ptr [0x52e5b0]                    # 005006f7
    fldl2e                                       # 005006fd
    fmulp st(1), st                              # 005006ff
    fld st(0)                                    # 00500701
    frndint                                      # 00500703
    fxch st(1)                                   # 00500705
    fsub st, st(1)                               # 00500707
    f2xm1                                        # 00500709
    fld1                                         # 0050070b
    faddp st(1), st                              # 0050070d
    fscale                                       # 0050070f
    fstp st(1)                                   # 00500711
    fdiv dword ptr [ebp + arg_c]                 # 00500713
    fadd qword ptr [0x52c598]                    # 00500716
    call FUN_0050ce04                            # 0050071c
    test edi, edi                                # 00500721
    mov dword ptr [ebp + arg_18], eax            # 00500723
    jge.d8 L_0050072a                            # 00500726
    # block 0x00500728: entered by fall-through of jge at 0x00500726, 1 instruction(s), falls into the block at 0x0050072a
    {load} xor edi, edi                          # 00500728
L_0050072a:
    # block 0x0050072a: entered by jge at 0x00500726, 3 instruction(s), ends with jle to 0x00500733 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0050072a
    {load} cmp edi, ecx                          # 0050072d
    jle.d8 L_00500733                            # 0050072f
    # block 0x00500731: entered by fall-through of jle at 0x0050072f, 1 instruction(s), falls into the block at 0x00500733
    {load} mov edi, ecx                          # 00500731
L_00500733:
    # block 0x00500733: entered by jle at 0x0050072f, 2 instruction(s), ends with jge to 0x00500739 (forward)
    {load} cmp edi, esi                          # 00500733
    jge.d8 L_00500739                            # 00500735
    # block 0x00500737: entered by fall-through of jge at 0x00500735, 1 instruction(s), falls into the block at 0x00500739
    {load} mov esi, edi                          # 00500737
L_00500739:
    # block 0x00500739: entered by jge at 0x00500735, 3 instruction(s), ends with jge to 0x00500745 (forward)
    mov eax, dword ptr [ebp + arg_18]            # 00500739
    test eax, eax                                # 0050073c
    jge.d8 L_00500745                            # 0050073e
    # block 0x00500740: entered by fall-through of jge at 0x0050073e, 2 instruction(s), falls into the block at 0x00500745
    {load} xor eax, eax                          # 00500740
    mov dword ptr [ebp + arg_18], eax            # 00500742
L_00500745:
    # block 0x00500745: entered by jge at 0x0050073e, 2 instruction(s), ends with jle to 0x0050074e (forward)
    {load} cmp eax, ecx                          # 00500745
    jle.d8 L_0050074e                            # 00500747
    # block 0x00500749: entered by fall-through of jle at 0x00500747, 2 instruction(s), falls into the block at 0x0050074e
    {load} mov eax, ecx                          # 00500749
    mov dword ptr [ebp + arg_18], eax            # 0050074b
L_0050074e:
    # block 0x0050074e: entered by jle at 0x00500747, 2 instruction(s), ends with jge to 0x0050079b (forward)
    {load} cmp esi, eax                          # 0050074e
    jge.d8 L_0050079b                            # 00500750
    # block 0x00500752: entered by fall-through of jge at 0x00500750, 2 instruction(s), falls into the block at 0x00500758
    mov edx, dword ptr [ebp - local_18]          # 00500752
    lea edx, [edx + 4*esi]                       # 00500755
L_00500758:
    # block 0x00500758: entered by jl at 0x00500799, 2 instruction(s), ends with jge to 0x0050079b (forward)
    {load} cmp esi, ecx                          # 00500758
    jge.d8 L_0050079b                            # 0050075a
    # block 0x0050075c: entered by fall-through of jge at 0x0050075a, 13 instruction(s), ends with jne to 0x0050078d (forward)
    mov eax, dword ptr [ebp + arg_14]            # 0050075c
    inc eax                                      # 0050075f
    fld dword ptr [edx]                          # 00500760
    lea eax, [ebx + 8*eax]                       # 00500762
    lea ecx, [8*eax]                             # 00500765
    {load} sub ecx, eax                          # 0050076c
    mov eax, dword ptr [ebp + arg_8]             # 0050076e
    lea ecx, [eax + 8*ecx]                       # 00500771
    fcomp dword ptr [ebp + 4*ecx - local_7f08]   # 00500774
    lea ecx, [ebp + 4*ecx - local_7f08]          # 0050077b
    fnstsw ax                                    # 00500782
    test ah, 0x41                                # 00500784
    jne.d8 L_0050078d                            # 00500787
    # block 0x00500789: entered by fall-through of jne at 0x00500787, 2 instruction(s), falls into the block at 0x0050078d
    mov eax, dword ptr [ecx]                     # 00500789
    mov dword ptr [edx], eax                     # 0050078b
L_0050078d:
    # block 0x0050078d: entered by jne at 0x00500787, 6 instruction(s), ends with jl to 0x00500758 (backward)
    mov eax, dword ptr [ebp + arg_18]            # 0050078d
    mov ecx, dword ptr [ebp + arg_10]            # 00500790
    inc esi                                      # 00500793
    add edx, 0x4                                 # 00500794
    {load} cmp esi, eax                          # 00500797
    jl.d8 L_00500758                             # 00500799
L_0050079b:
    # block 0x0050079b: entered by jge at 0x00500750; jge at 0x0050075a; fall-through of jl at 0x00500799, 5 instruction(s), ends with jl to 0x005006ab (backward)
    mov eax, dword ptr [ebp + arg_8]             # 0050079b
    inc eax                                      # 0050079e
    cmp eax, 0x38                                # 0050079f
    mov dword ptr [ebp + arg_8], eax             # 005007a2
    jl.d32 L_005006ab                            # 005007a5
    # block 0x005007ab: entered by fall-through of jl at 0x005007a5, 2 instruction(s), ends with jge to 0x005007eb (forward)
    {load} cmp esi, ecx                          # 005007ab
    jge.d8 L_005007eb                            # 005007ad
    # block 0x005007af: entered by fall-through of jge at 0x005007ad, 11 instruction(s), falls into the block at 0x005007d6
    mov ecx, dword ptr [ebp + arg_14]            # 005007af
    lea eax, [ecx + field_1]                     # 005007b2
    mov ecx, dword ptr [ebp + arg_10]            # 005007b5
    lea eax, [ebx + 8*eax]                       # 005007b8
    lea edx, [8*eax]                             # 005007bb
    {load} sub edx, eax                          # 005007c2
    mov eax, dword ptr [ebp - local_18]          # 005007c4
    shl edx, 0x5                                 # 005007c7
    {load} sub ecx, esi                          # 005007ca
    lea edi, [ebp + edx - local_7e2c]            # 005007cc
    lea edx, [eax + 4*esi]                       # 005007d3
L_005007d6:
    # block 0x005007d6: entered by jne at 0x005007e9, 5 instruction(s), ends with jne to 0x005007e5 (forward)
    fld dword ptr [edx]                          # 005007d6
    fcomp dword ptr [edi]                        # 005007d8
    fnstsw ax                                    # 005007da
    test ah, 0x41                                # 005007dc
    jne.d8 L_005007e5                            # 005007df
    # block 0x005007e1: entered by fall-through of jne at 0x005007df, 2 instruction(s), falls into the block at 0x005007e5
    mov eax, dword ptr [edi]                     # 005007e1
    mov dword ptr [edx], eax                     # 005007e3
L_005007e5:
    # block 0x005007e5: entered by jne at 0x005007df, 3 instruction(s), ends with jne to 0x005007d6 (backward)
    add edx, 0x4                                 # 005007e5
    dec ecx                                      # 005007e8
    jne.d8 L_005007d6                            # 005007e9
L_005007eb:
    # block 0x005007eb: entered by jge at 0x005006a0; jge at 0x005007ad; fall-through of jne at 0x005007e9, 3 instruction(s), falls into the block at 0x005007fa
    mov edi, dword ptr [ebp + arg_14]            # 005007eb
    mov dword ptr [ebp + arg_8], 0x0             # 005007ee
    mov esi, 0x8                                 # 005007f5
L_005007fa:
    # block 0x005007fa: entered by jl at 0x00500881, 21 instruction(s), calls FUN_0050ce04, ends with jge to 0x0050084c (forward)
    fild dword ptr [ebp + arg_8]                 # 005007fa
    fmul qword ptr [0x52e5b8]                    # 005007fd
    fadd qword ptr [ebp - local_24]              # 00500803
    fsub qword ptr [0x52c678]                    # 00500806
    fadd qword ptr [0x52e5c0]                    # 0050080c
    fmul qword ptr [0x52e5b0]                    # 00500812
    fldl2e                                       # 00500818
    fmulp st(1), st                              # 0050081a
    fld st(0)                                    # 0050081c
    frndint                                      # 0050081e
    fxch st(1)                                   # 00500820
    fsub st, st(1)                               # 00500822
    f2xm1                                        # 00500824
    fld1                                         # 00500826
    faddp st(1), st                              # 00500828
    fscale                                       # 0050082a
    fstp st(1)                                   # 0050082c
    fdiv dword ptr [ebp + arg_c]                 # 0050082e
    call FUN_0050ce04                            # 00500831
    test eax, eax                                # 00500836
    jge.d8 L_0050084c                            # 00500838
    # block 0x0050083a: entered by fall-through of jge at 0x00500838, 5 instruction(s), ends with forward jump to 0x00500871
    mov ecx, dword ptr [ebp - local_8]           # 0050083a
    mov edx, dword ptr [ecx + 4*edi]             # 0050083d
    mov eax, dword ptr [edx + 4*ebx]             # 00500840
    mov dword ptr [eax + esi], 0xc479c000        # 00500843
    jmp.d8 L_00500871                            # 0050084a
L_0050084c:
    # block 0x0050084c: entered by jge at 0x00500838, 5 instruction(s), ends with jl to 0x00500865 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0050084c
    {load} cmp eax, ecx                          # 0050084f
    mov ecx, dword ptr [ebp - local_8]           # 00500851
    mov edx, dword ptr [ecx + 4*edi]             # 00500854
    jl.d8 L_00500865                             # 00500857
    # block 0x00500859: entered by fall-through of jl at 0x00500857, 3 instruction(s), ends with forward jump to 0x00500871
    mov eax, dword ptr [edx + 4*ebx]             # 00500859
    mov dword ptr [eax + esi], 0xc479c000        # 0050085c
    jmp.d8 L_00500871                            # 00500863
L_00500865:
    # block 0x00500865: entered by jl at 0x00500857, 4 instruction(s), falls into the block at 0x00500871
    mov ecx, dword ptr [edx + 4*ebx]             # 00500865
    mov edx, dword ptr [ebp - local_18]          # 00500868
    mov eax, dword ptr [edx + 4*eax]             # 0050086b
    mov dword ptr [ecx + esi], eax               # 0050086e
L_00500871:
    # block 0x00500871: entered by jmp at 0x0050084a; jmp at 0x00500863, 6 instruction(s), ends with jl to 0x005007fa (backward)
    mov edx, dword ptr [ebp + arg_8]             # 00500871
    add esi, 0x4                                 # 00500874
    inc edx                                      # 00500877
    cmp esi, 0xe8                                # 00500878
    mov dword ptr [ebp + arg_8], edx             # 0050087e
    jl.d32 L_005007fa                            # 00500881
    # block 0x00500887: entered by fall-through of jl at 0x00500881, 6 instruction(s), falls into the block at 0x00500898
    mov edx, dword ptr [ebp - local_8]           # 00500887
    {load} xor ecx, ecx                          # 0050088a
    mov dword ptr [ebp + arg_8], ecx             # 0050088c
    mov eax, dword ptr [edx + 4*edi]             # 0050088f
    mov esi, dword ptr [eax + 4*ebx]             # 00500892
    lea edx, [esi + field_8]                     # 00500895
L_00500898:
    # block 0x00500898: entered by jl at 0x005008ae, 5 instruction(s), ends with je to 0x005008b0 (forward)
    fld dword ptr [edx]                          # 00500898
    fcomp dword ptr [0x52e5d4]                   # 0050089a
    fnstsw ax                                    # 005008a0
    test ah, 0x41                                # 005008a2
    je.d8 L_005008b0                             # 005008a5
    # block 0x005008a7: entered by fall-through of je at 0x005008a5, 4 instruction(s), ends with jl to 0x00500898 (backward)
    inc ecx                                      # 005008a7
    add edx, 0x4                                 # 005008a8
    cmp ecx, 0x10                                # 005008ab
    jl.d8 L_00500898                             # 005008ae
L_005008b0:
    # block 0x005008b0: entered by je at 0x005008a5; fall-through of jl at 0x005008ae, 9 instruction(s), falls into the block at 0x005008cf
    mov edx, dword ptr [ebp - local_8]           # 005008b0
    mov dword ptr [ebp + arg_8], ecx             # 005008b3
    fild dword ptr [ebp + arg_8]                 # 005008b6
    mov ecx, 0x37                                # 005008b9
    mov dword ptr [ebp + arg_8], ecx             # 005008be
    fstp dword ptr [esi]                         # 005008c1
    mov eax, dword ptr [edx + 4*edi]             # 005008c3
    mov esi, dword ptr [eax + 4*ebx]             # 005008c6
    lea edx, [esi + field_e4]                    # 005008c9
L_005008cf:
    # block 0x005008cf: entered by jg at 0x005008e5, 5 instruction(s), ends with je to 0x005008e7 (forward)
    fld dword ptr [edx]                          # 005008cf
    fcomp dword ptr [0x52e5d4]                   # 005008d1
    fnstsw ax                                    # 005008d7
    test ah, 0x41                                # 005008d9
    je.d8 L_005008e7                             # 005008dc
    # block 0x005008de: entered by fall-through of je at 0x005008dc, 4 instruction(s), ends with jg to 0x005008cf (backward)
    dec ecx                                      # 005008de
    sub edx, 0x4                                 # 005008df
    cmp ecx, 0x11                                # 005008e2
    jg.d8 L_005008cf                             # 005008e5
L_005008e7:
    # block 0x005008e7: entered by je at 0x005008dc; fall-through of jg at 0x005008e5, 7 instruction(s), ends with jl to 0x005004ef (backward)
    mov dword ptr [ebp + arg_8], ecx             # 005008e7
    inc ebx                                      # 005008ea
    fild dword ptr [ebp + arg_8]                 # 005008eb
    cmp ebx, 0x8                                 # 005008ee
    mov dword ptr [ebp - local_1c], ebx          # 005008f1
    fstp dword ptr [esi + field_4]               # 005008f4
    jl.d32 L_005004ef                            # 005008f7
    # block 0x005008fd: entered by fall-through of jl at 0x005008f7, 5 instruction(s), ends with jl to 0x00500417 (backward)
    mov eax, dword ptr [ebp + arg_14]            # 005008fd
    inc eax                                      # 00500900
    cmp eax, 0x11                                # 00500901
    mov dword ptr [ebp + arg_14], eax            # 00500904
    jl.d32 L_00500417                            # 00500907
    # block 0x0050090d: entered by fall-through of jl at 0x00500907, 8 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 0050090d
    lea esp, [ebp - local_7f14]                  # 00500910
    pop edi                                      # 00500916
    pop esi                                      # 00500917
    pop ebx                                      # 00500918
    {load} mov esp, ebp                          # 00500919
    pop ebp                                      # 0050091b
    ret                                          # 0050091c

# --- data items (not part of the function) -------------------------
.org 0x0050091d - 0x401000
PAD_0050091d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

