# FUN_00506180
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506180
# extent:       0x00506180-0x00506600 (1152 code bytes)
# span:         0x00506180-0x00506600 (code 1152, tables 0, padding 0)
# sha256:       86b9e2a2cad2f65f574b2d8d01eb33f1f95bd0eab045189817a712fdc0ba9d4f
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506180
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_2c
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24, field_minus_4, field_minus_8; [ebx + n] field_4, field_8, field_minus_20; [ecx + n] field_4, field_8, field_minus_4, field_minus_8, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_1c; [edi + n] field_1, field_4, field_8, field_c, field_10, field_minus_4, field_minus_8; [edx + n] field_4, field_8, field_c, field_10, field_14, field_20, field_24, field_minus_4, field_minus_8, field_minus_c, field_minus_10, field_minus_1c and 1 more; [esi + n] field_4, field_8, field_c, field_minus_4
# callees:      calls FUN_0050c920, FUN_00506060, FUN_00505ad0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 433 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_minus_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_minus_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_minus_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_minus_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_minus_20, 0x20  # offset -0x20
.equ local_2c, 0x2c  # offset -0x2c
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_00505ad0, .text + (0x00505ad0 - 0x401000)
.set FUN_00506060, .text + (0x00506060 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00506180 - 0x401000
.globl FUN_00506180
FUN_00506180:
    # block 0x00506180: entry, 35 instruction(s), calls FUN_0050c920, ends with jle to 0x00506231 (forward)
    push ebp                                     # 00506180
    {load} mov ebp, esp                          # 00506181
    sub esp, 0x20                                # 00506183
    mov eax, dword ptr [ebp + arg_8]             # 00506186
    push ebx                                     # 00506189
    push esi                                     # 0050618a
    push edi                                     # 0050618b
    mov eax, dword ptr [eax]                     # 0050618c
    {load} mov esi, eax                          # 0050618e
    {load} mov ebx, eax                          # 00506190
    {load} mov edi, eax                          # 00506192
    shl eax, 0x2                                 # 00506194
    mov dword ptr [ebp - local_18], eax          # 00506197
    add eax, 0x3                                 # 0050619a
    sar ebx, 0x2                                 # 0050619d
    and al, -0x4                                 # 005061a0
    mov dword ptr [ebp - local_20], ebx          # 005061a2
    sar esi                                      # 005061a5
    sar edi, 0x3                                 # 005061a7
    call FUN_0050c920                            # 005061aa
    mov edx, dword ptr [ebp + arg_c]             # 005061af
    {load} mov ecx, esp                          # 005061b2
    lea eax, [4*esi]                             # 005061b4
    mov dword ptr [ebp - local_14], ecx          # 005061bb
    {load} add ecx, eax                          # 005061be
    {load} add ebx, esi                          # 005061c0
    mov dword ptr [ebp - local_4], ecx           # 005061c2
    mov dword ptr [ebp - local_1c], eax          # 005061c5
    lea ecx, [edx + 4*ebx]                       # 005061c8
    mov edx, dword ptr [ebp + arg_8]             # 005061cb
    mov dword ptr [ebp - local_8], 0x0           # 005061ce
    add eax, dword ptr [edx + field_8]           # 005061d5
    lea ebx, [ecx + field_4]                     # 005061d8
    test edi, edi                                # 005061db
    jle.d8 L_00506231                            # 005061dd
    # block 0x005061df: entered by fall-through of jle at 0x005061dd, 7 instruction(s), falls into the block at 0x005061f2
    mov edx, dword ptr [ebp - local_4]           # 005061df
    mov dword ptr [ebp - local_c], edx           # 005061e2
    lea edx, [edi + field_1]                     # 005061e5
    shr edx                                      # 005061e8
    mov dword ptr [ebp - local_10], edx          # 005061ea
    {load} add edx, edx                          # 005061ed
    mov dword ptr [ebp - local_8], edx           # 005061ef
L_005061f2:
    # block 0x005061f2: entered by jne at 0x0050622f, 25 instruction(s), ends with jne to 0x005061f2 (backward)
    fld dword ptr [ecx - field_minus_8]          # 005061f2
    fadd dword ptr [ebx]                         # 005061f5
    fld dword ptr [ebx + field_8]                # 005061f7
    sub ecx, 0x10                                # 005061fa
    sub eax, 0x8                                 # 005061fd
    mov edx, dword ptr [ebp - local_c]           # 00506200
    add ebx, 0x10                                # 00506203
    fadd dword ptr [ecx]                         # 00506206
    add edx, 0x8                                 # 00506208
    mov dword ptr [ebp - local_c], edx           # 0050620b
    fld st(0)                                    # 0050620e
    fmul dword ptr [eax + field_4]               # 00506210
    fld st(2)                                    # 00506213
    fmul dword ptr [eax]                         # 00506215
    faddp st(1), st                              # 00506217
    fstp dword ptr [edx - field_minus_8]         # 00506219
    fmul dword ptr [eax]                         # 0050621c
    fxch st(1)                                   # 0050621e
    fmul dword ptr [eax + field_4]               # 00506220
    fsubp st(1), st                              # 00506223
    fstp dword ptr [edx - field_minus_4]         # 00506225
    mov edx, dword ptr [ebp - local_10]          # 00506228
    dec edx                                      # 0050622b
    mov dword ptr [ebp - local_10], edx          # 0050622c
    jne.d8 L_005061f2                            # 0050622f
L_00506231:
    # block 0x00506231: entered by jle at 0x005061dd; fall-through of jne at 0x0050622f, 8 instruction(s), ends with jge to 0x00506293 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00506231
    {load} mov ebx, esi                          # 00506234
    {load} sub ebx, edi                          # 00506236
    mov edi, dword ptr [ebp - local_8]           # 00506238
    add edx, 0x4                                 # 0050623b
    {load} cmp edi, ebx                          # 0050623e
    mov dword ptr [ebp - local_10], ebx          # 00506240
    jge.d8 L_00506293                            # 00506243
    # block 0x00506245: entered by fall-through of jge at 0x00506243, 10 instruction(s), falls into the block at 0x0050625f
    mov ebx, dword ptr [ebp - local_4]           # 00506245
    lea ebx, [ebx + 4*edi]                       # 00506248
    mov dword ptr [ebp - local_c], ebx           # 0050624b
    mov ebx, dword ptr [ebp - local_10]          # 0050624e
    {load} sub ebx, edi                          # 00506251
    inc ebx                                      # 00506253
    shr ebx                                      # 00506254
    lea edi, [edi + 2*ebx]                       # 00506256
    mov dword ptr [ebp - local_8], edi           # 00506259
    mov edi, dword ptr [ebp - local_c]           # 0050625c
L_0050625f:
    # block 0x0050625f: entered by jne at 0x00506291, 21 instruction(s), ends with jne to 0x0050625f (backward)
    fld dword ptr [ecx - field_minus_8]          # 0050625f
    fsub dword ptr [edx]                         # 00506262
    fld dword ptr [ecx - field_minus_10]         # 00506264
    sub ecx, 0x10                                # 00506267
    sub eax, 0x8                                 # 0050626a
    fsub dword ptr [edx + field_8]               # 0050626d
    add edx, 0x10                                # 00506270
    add edi, 0x8                                 # 00506273
    dec ebx                                      # 00506276
    fld st(0)                                    # 00506277
    fmul dword ptr [eax + field_4]               # 00506279
    fld st(2)                                    # 0050627c
    fmul dword ptr [eax]                         # 0050627e
    faddp st(1), st                              # 00506280
    fstp dword ptr [edi - field_minus_8]         # 00506282
    fmul dword ptr [eax]                         # 00506285
    fxch st(1)                                   # 00506287
    fmul dword ptr [eax + field_4]               # 00506289
    fsubp st(1), st                              # 0050628c
    fstp dword ptr [edi - field_minus_4]         # 0050628e
    jne.d8 L_0050625f                            # 00506291
L_00506293:
    # block 0x00506293: entered by jge at 0x00506243; fall-through of jne at 0x00506291, 7 instruction(s), ends with jge to 0x005062ea (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00506293
    mov edi, dword ptr [ebp + arg_c]             # 00506296
    mov ebx, dword ptr [ebp - local_4]           # 00506299
    {load} add edi, ecx                          # 0050629c
    mov ecx, dword ptr [ebp - local_8]           # 0050629e
    {load} cmp ecx, esi                          # 005062a1
    jge.d8 L_005062ea                            # 005062a3
    # block 0x005062a5: entered by fall-through of jge at 0x005062a3, 5 instruction(s), falls into the block at 0x005062b0
    lea ecx, [ebx + 4*ecx]                       # 005062a5
    {load} mov ebx, esi                          # 005062a8
    sub ebx, dword ptr [ebp - local_8]           # 005062aa
    inc ebx                                      # 005062ad
    shr ebx                                      # 005062ae
L_005062b0:
    # block 0x005062b0: entered by jne at 0x005062e5, 23 instruction(s), ends with jne to 0x005062b0 (backward)
    fld dword ptr [edi - field_minus_8]          # 005062b0
    sub edi, 0x10                                # 005062b3
    sub eax, 0x8                                 # 005062b6
    fchs                                         # 005062b9
    fsub dword ptr [edx]                         # 005062bb
    fld dword ptr [edi]                          # 005062bd
    fchs                                         # 005062bf
    fsub dword ptr [edx + field_8]               # 005062c1
    add edx, 0x10                                # 005062c4
    add ecx, 0x8                                 # 005062c7
    dec ebx                                      # 005062ca
    fld st(0)                                    # 005062cb
    fmul dword ptr [eax + field_4]               # 005062cd
    fld st(2)                                    # 005062d0
    fmul dword ptr [eax]                         # 005062d2
    faddp st(1), st                              # 005062d4
    fstp dword ptr [ecx - field_minus_8]         # 005062d6
    fmul dword ptr [eax]                         # 005062d9
    fxch st(1)                                   # 005062db
    fmul dword ptr [eax + field_4]               # 005062dd
    fsubp st(1), st                              # 005062e0
    fstp dword ptr [ecx - field_minus_4]         # 005062e2
    jne.d8 L_005062b0                            # 005062e5
    # block 0x005062e7: entered by fall-through of jne at 0x005062e5, 1 instruction(s), falls into the block at 0x005062ea
    mov ebx, dword ptr [ebp - local_4]           # 005062e7
L_005062ea:
    # block 0x005062ea: entered by jge at 0x005062a3, 8 instruction(s), ends with jle to 0x0050640f (forward)
    mov edx, dword ptr [ebp + arg_8]             # 005062ea
    mov eax, dword ptr [edx + field_4]           # 005062ed
    mov edi, dword ptr [edx + field_8]           # 005062f0
    sub eax, 0x6                                 # 005062f3
    mov dword ptr [ebp - local_8], edi           # 005062f6
    test eax, eax                                # 005062f9
    mov dword ptr [ebp + arg_c], eax             # 005062fb
    jle.d32 L_0050640f                           # 005062fe
    # block 0x00506304: entered by fall-through of jle at 0x005062fe, 7 instruction(s), falls into the block at 0x00506317
    {load} mov ecx, esi                          # 00506304
    lea edx, [edi + field_10]                    # 00506306
    sar ecx                                      # 00506309
    {load} mov edi, esi                          # 0050630b
    lea eax, [ebx + 4*ecx - field_minus_20]      # 0050630d
    {load} sub edi, ecx                          # 00506311
    lea ecx, [eax + 4*edi + field_1c]            # 00506313
L_00506317:
    # block 0x00506317: entered by jae at 0x00506403, 89 instruction(s), ends with jae to 0x00506317 (backward)
    fld dword ptr [ecx - field_minus_4]          # 00506317
    fsub dword ptr [eax + field_18]              # 0050631a
    fld dword ptr [ecx]                          # 0050631d
    fsub dword ptr [eax + field_1c]              # 0050631f
    fld dword ptr [eax + field_18]               # 00506322
    fadd dword ptr [ecx - field_minus_4]         # 00506325
    fstp dword ptr [ecx - field_minus_4]         # 00506328
    fld dword ptr [eax + field_1c]               # 0050632b
    fadd dword ptr [ecx]                         # 0050632e
    fstp dword ptr [ecx]                         # 00506330
    fld st(1)                                    # 00506332
    fmul dword ptr [edx - field_minus_10]        # 00506334
    fld st(1)                                    # 00506337
    fmul dword ptr [edx - field_minus_c]         # 00506339
    faddp st(1), st                              # 0050633c
    fstp dword ptr [eax + field_18]              # 0050633e
    fmul dword ptr [edx - field_minus_10]        # 00506341
    fxch st(1)                                   # 00506344
    fmul dword ptr [edx - field_minus_c]         # 00506346
    fsubp st(1), st                              # 00506349
    fstp dword ptr [eax + field_1c]              # 0050634b
    fld dword ptr [ecx - field_minus_c]          # 0050634e
    fsub dword ptr [eax + field_10]              # 00506351
    fld dword ptr [ecx - field_minus_8]          # 00506354
    fsub dword ptr [eax + field_14]              # 00506357
    fld dword ptr [eax + field_10]               # 0050635a
    fadd dword ptr [ecx - field_minus_c]         # 0050635d
    fstp dword ptr [ecx - field_minus_c]         # 00506360
    fld dword ptr [ecx - field_minus_8]          # 00506363
    fadd dword ptr [eax + field_14]              # 00506366
    fstp dword ptr [ecx - field_minus_8]         # 00506369
    fld st(0)                                    # 0050636c
    fmul dword ptr [edx + field_4]               # 0050636e
    fld st(2)                                    # 00506371
    fmul dword ptr [edx]                         # 00506373
    faddp st(1), st                              # 00506375
    fstp dword ptr [eax + field_10]              # 00506377
    fmul dword ptr [edx]                         # 0050637a
    fxch st(1)                                   # 0050637c
    fmul dword ptr [edx + field_4]               # 0050637e
    fsubp st(1), st                              # 00506381
    fstp dword ptr [eax + field_14]              # 00506383
    fld dword ptr [ecx - field_minus_14]         # 00506386
    fsub dword ptr [eax + field_8]               # 00506389
    fld dword ptr [ecx - field_minus_10]         # 0050638c
    fsub dword ptr [eax + field_c]               # 0050638f
    fld dword ptr [eax + field_8]                # 00506392
    fadd dword ptr [ecx - field_minus_14]        # 00506395
    fstp dword ptr [ecx - field_minus_14]        # 00506398
    fld dword ptr [eax + field_c]                # 0050639b
    fadd dword ptr [ecx - field_minus_10]        # 0050639e
    fstp dword ptr [ecx - field_minus_10]        # 005063a1
    fld st(0)                                    # 005063a4
    fmul dword ptr [edx + field_14]              # 005063a6
    fld st(2)                                    # 005063a9
    fmul dword ptr [edx + field_10]              # 005063ab
    faddp st(1), st                              # 005063ae
    fstp dword ptr [eax + field_8]               # 005063b0
    fmul dword ptr [edx + field_10]              # 005063b3
    fxch st(1)                                   # 005063b6
    fmul dword ptr [edx + field_14]              # 005063b8
    fsubp st(1), st                              # 005063bb
    fstp dword ptr [eax + field_c]               # 005063bd
    fld dword ptr [ecx - field_minus_1c]         # 005063c0
    fsub dword ptr [eax]                         # 005063c3
    fld dword ptr [ecx - field_minus_18]         # 005063c5
    fsub dword ptr [eax + field_4]               # 005063c8
    fld dword ptr [ecx - field_minus_1c]         # 005063cb
    fadd dword ptr [eax]                         # 005063ce
    fstp dword ptr [ecx - field_minus_1c]        # 005063d0
    fld dword ptr [eax + field_4]                # 005063d3
    fadd dword ptr [ecx - field_minus_18]        # 005063d6
    fstp dword ptr [ecx - field_minus_18]        # 005063d9
    fld st(0)                                    # 005063dc
    fmul dword ptr [edx + field_24]              # 005063de
    fld st(2)                                    # 005063e1
    fmul dword ptr [edx + field_20]              # 005063e3
    sub eax, 0x20                                # 005063e6
    sub ecx, 0x20                                # 005063e9
    add edx, 0x40                                # 005063ec
    {load} cmp eax, ebx                          # 005063ef
    faddp st(1), st                              # 005063f1
    fstp dword ptr [eax + field_20]              # 005063f3
    fmul dword ptr [edx - field_minus_20]        # 005063f6
    fxch st(1)                                   # 005063f9
    fmul dword ptr [edx - field_minus_1c]        # 005063fb
    fsubp st(1), st                              # 005063fe
    fstp dword ptr [eax + field_24]              # 00506400
    jae.d32 L_00506317                           # 00506403
    # block 0x00506409: entered by fall-through of jae at 0x00506403, 2 instruction(s), falls into the block at 0x0050640f
    mov edx, dword ptr [ebp + arg_8]             # 00506409
    mov eax, dword ptr [ebp + arg_c]             # 0050640c
L_0050640f:
    # block 0x0050640f: entered by jle at 0x005062fe, 5 instruction(s), ends with jle to 0x00506477 (forward)
    dec eax                                      # 0050640f
    mov ecx, 0x1                                 # 00506410
    test eax, eax                                # 00506415
    mov dword ptr [ebp - local_10], ecx          # 00506417
    jle.d8 L_00506477                            # 0050641a
    # block 0x0050641c: entered by fall-through of jle at 0x0050641a, 1 instruction(s), falls into the block at 0x0050641f
    mov dword ptr [ebp - local_c], eax           # 0050641c
L_0050641f:
    # block 0x0050641f: entered by jne at 0x00506472, 4 instruction(s), ends with jle to 0x00506467 (forward)
    mov edx, 0x1                                 # 0050641f
    shl edx, cl                                  # 00506424
    test edx, edx                                # 00506426
    jle.d8 L_00506467                            # 00506428
    # block 0x0050642a: entered by fall-through of jle at 0x00506428, 7 instruction(s), ends with forward jump to 0x00506440
    mov eax, 0x4                                 # 0050642a
    {load} mov edi, esi                          # 0050642f
    shl eax, cl                                  # 00506431
    sar edi, cl                                  # 00506433
    mov dword ptr [ebp + arg_c], edx             # 00506435
    mov dword ptr [ebp - local_18], eax          # 00506438
    jmp.d8 L_00506440                            # 0050643b
L_0050643d:
    # block 0x0050643d: entered by jne at 0x0050645f, 1 instruction(s), falls into the block at 0x00506440
    mov eax, dword ptr [ebp - local_18]          # 0050643d
L_00506440:
    # block 0x00506440: entered by jmp at 0x0050643b, 13 instruction(s), calls FUN_00506060, ends with jne to 0x0050643d (backward)
    mov edx, dword ptr [ebp - local_8]           # 00506440
    push eax                                     # 00506443
    push edi                                     # 00506444
    push ebx                                     # 00506445
    push edx                                     # 00506446
    call FUN_00506060                            # 00506447
    lea eax, [4*edi]                             # 0050644c
    add esp, 0x10                                # 00506453
    {load} add ebx, eax                          # 00506456
    mov eax, dword ptr [ebp + arg_c]             # 00506458
    dec eax                                      # 0050645b
    mov dword ptr [ebp + arg_c], eax             # 0050645c
    jne.d8 L_0050643d                            # 0050645f
    # block 0x00506461: entered by fall-through of jne at 0x0050645f, 2 instruction(s), falls into the block at 0x00506467
    mov ecx, dword ptr [ebp - local_10]          # 00506461
    mov ebx, dword ptr [ebp - local_4]           # 00506464
L_00506467:
    # block 0x00506467: entered by jle at 0x00506428, 6 instruction(s), ends with jne to 0x0050641f (backward)
    mov eax, dword ptr [ebp - local_c]           # 00506467
    inc ecx                                      # 0050646a
    dec eax                                      # 0050646b
    mov dword ptr [ebp - local_10], ecx          # 0050646c
    mov dword ptr [ebp - local_c], eax           # 0050646f
    jne.d8 L_0050641f                            # 00506472
    # block 0x00506474: entered by fall-through of jne at 0x00506472, 1 instruction(s), falls into the block at 0x00506477
    mov edx, dword ptr [ebp + arg_8]             # 00506474
L_00506477:
    # block 0x00506477: entered by jle at 0x0050641a, 2 instruction(s), ends with jle to 0x00506496 (forward)
    test esi, esi                                # 00506477
    jle.d8 L_00506496                            # 00506479
    # block 0x0050647b: entered by fall-through of jle at 0x00506479, 2 instruction(s), falls into the block at 0x00506481
    add esi, 0x1f                                # 0050647b
    shr esi, 0x5                                 # 0050647e
L_00506481:
    # block 0x00506481: entered by jne at 0x00506491, 6 instruction(s), calls FUN_00505ad0, ends with jne to 0x00506481 (backward)
    push ebx                                     # 00506481
    call FUN_00505ad0                            # 00506482
    add esp, 0x4                                 # 00506487
    add ebx, 0x80                                # 0050648a
    dec esi                                      # 00506490
    jne.d8 L_00506481                            # 00506491
    # block 0x00506493: entered by fall-through of jne at 0x00506491, 1 instruction(s), falls into the block at 0x00506496
    mov edx, dword ptr [ebp + arg_8]             # 00506493
L_00506496:
    # block 0x00506496: entered by jle at 0x00506479, 12 instruction(s), ends with forward jump to 0x005064b9
    mov eax, dword ptr [edx]                     # 00506496
    mov esi, dword ptr [edx + field_c]           # 00506498
    mov ecx, dword ptr [ebp - local_14]          # 0050649b
    mov edx, dword ptr [edx + field_8]           # 0050649e
    {load} mov edi, eax                          # 005064a1
    sar edi                                      # 005064a3
    lea eax, [edx + 4*eax]                       # 005064a5
    lea edx, [ecx + field_8]                     # 005064a8
    lea edi, [ecx + 4*edi]                       # 005064ab
    mov dword ptr [ebp - local_10], edi          # 005064ae
    lea ecx, [edi + field_c]                     # 005064b1
    jmp.d8 L_005064b9                            # 005064b4
L_005064b6:
    # block 0x005064b6: entered by jb at 0x0050659f, 1 instruction(s), falls into the block at 0x005064b9
    mov edi, dword ptr [ebp - local_10]          # 005064b6
L_005064b9:
    # block 0x005064b9: entered by jmp at 0x005064b4, 83 instruction(s), ends with jb to 0x005064b6 (backward)
    mov ebx, dword ptr [esi]                     # 005064b9
    sub ecx, 0x10                                # 005064bb
    lea ebx, [edi + 4*ebx]                       # 005064be
    mov dword ptr [ebp + arg_c], ebx             # 005064c1
    mov ebx, dword ptr [esi + field_4]           # 005064c4
    lea edi, [edi + 4*ebx]                       # 005064c7
    mov ebx, dword ptr [ebp + arg_c]             # 005064ca
    fld dword ptr [ebx + field_4]                # 005064cd
    fsub dword ptr [edi + field_4]               # 005064d0
    fld dword ptr [edi]                          # 005064d3
    fadd dword ptr [ebx]                         # 005064d5
    fld st(1)                                    # 005064d7
    fmul dword ptr [eax + field_4]               # 005064d9
    fld st(1)                                    # 005064dc
    fmul dword ptr [eax]                         # 005064de
    faddp st(1), st                              # 005064e0
    fstp dword ptr [ebp + arg_c]                 # 005064e2
    fmul dword ptr [eax + field_4]               # 005064e5
    fxch st(1)                                   # 005064e8
    fmul dword ptr [eax]                         # 005064ea
    fsubp st(1), st                              # 005064ec
    fld dword ptr [edi + field_4]                # 005064ee
    fadd dword ptr [ebx + field_4]               # 005064f1
    fmul dword ptr [0x52cd14]                    # 005064f4
    fld dword ptr [ebx]                          # 005064fa
    fsub dword ptr [edi]                         # 005064fc
    mov edi, dword ptr [ebp - local_10]          # 005064fe
    fmul dword ptr [0x52cd14]                    # 00506501
    fstp dword ptr [ebp - local_8]               # 00506507
    fld dword ptr [ebp + arg_c]                  # 0050650a
    fadd st, st(1)                               # 0050650d
    fstp dword ptr [edx - field_minus_8]         # 0050650f
    fsub dword ptr [ebp + arg_c]                 # 00506512
    fstp dword ptr [ecx - field_minus_4]         # 00506515
    fld st(0)                                    # 00506518
    fadd dword ptr [ebp - local_8]               # 0050651a
    fstp dword ptr [edx - field_minus_4]         # 0050651d
    fsub dword ptr [ebp - local_8]               # 00506520
    fstp dword ptr [ecx]                         # 00506523
    mov ebx, dword ptr [esi + field_8]           # 00506525
    lea ebx, [edi + 4*ebx]                       # 00506528
    mov dword ptr [ebp + arg_c], ebx             # 0050652b
    mov ebx, dword ptr [esi + field_c]           # 0050652e
    lea edi, [edi + 4*ebx]                       # 00506531
    mov ebx, dword ptr [ebp + arg_c]             # 00506534
    fld dword ptr [ebx + field_4]                # 00506537
    fsub dword ptr [edi + field_4]               # 0050653a
    fld dword ptr [edi]                          # 0050653d
    fadd dword ptr [ebx]                         # 0050653f
    fld st(0)                                    # 00506541
    fmul dword ptr [eax + field_8]               # 00506543
    fld st(2)                                    # 00506546
    fmul dword ptr [eax + field_c]               # 00506548
    faddp st(1), st                              # 0050654b
    fstp dword ptr [ebp + arg_c]                 # 0050654d
    fmul dword ptr [eax + field_c]               # 00506550
    fxch st(1)                                   # 00506553
    fmul dword ptr [eax + field_8]               # 00506555
    fsubp st(1), st                              # 00506558
    fld dword ptr [edi + field_4]                # 0050655a
    fadd dword ptr [ebx + field_4]               # 0050655d
    fmul dword ptr [0x52cd14]                    # 00506560
    fld dword ptr [ebx]                          # 00506566
    fsub dword ptr [edi]                         # 00506568
    fmul dword ptr [0x52cd14]                    # 0050656a
    fstp dword ptr [ebp - local_8]               # 00506570
    fld dword ptr [ebp + arg_c]                  # 00506573
    fadd st, st(1)                               # 00506576
    fstp dword ptr [edx]                         # 00506578
    fsub dword ptr [ebp + arg_c]                 # 0050657a
    add edx, 0x10                                # 0050657d
    lea edi, [ecx - field_minus_c]               # 00506580
    add eax, 0x10                                # 00506583
    add esi, 0x10                                # 00506586
    lea ebx, [edx - field_minus_8]               # 00506589
    fstp dword ptr [ecx - field_minus_c]         # 0050658c
    {load} cmp ebx, edi                          # 0050658f
    fld st(0)                                    # 00506591
    fadd dword ptr [ebp - local_8]               # 00506593
    fstp dword ptr [edx - field_minus_c]         # 00506596
    fsub dword ptr [ebp - local_8]               # 00506599
    fstp dword ptr [ecx - field_minus_8]         # 0050659c
    jb.d32 L_005064b6                            # 0050659f
    # block 0x005065a5: entered by fall-through of jb at 0x0050659f, 10 instruction(s), ends with jle to 0x005065f6 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 005065a5
    mov ecx, dword ptr [ebp - local_1c]          # 005065a8
    mov esi, dword ptr [ebp + arg_10]            # 005065ab
    mov ebx, dword ptr [ebp - local_20]          # 005065ae
    mov edx, dword ptr [edi + field_8]           # 005065b1
    {load} mov eax, ecx                          # 005065b4
    {load} add eax, edx                          # 005065b6
    lea edx, [ecx + esi]                         # 005065b8
    test ebx, ebx                                # 005065bb
    jle.d8 L_005065f6                            # 005065bd
    # block 0x005065bf: entered by fall-through of jle at 0x005065bd, 1 instruction(s), falls into the block at 0x005065c2
    mov ecx, dword ptr [ebp - local_14]          # 005065bf
L_005065c2:
    # block 0x005065c2: entered by jne at 0x005065f4, 20 instruction(s), ends with jne to 0x005065c2 (backward)
    fld dword ptr [eax]                          # 005065c2
    fmul dword ptr [ecx]                         # 005065c4
    fld dword ptr [eax + field_4]                # 005065c6
    fmul dword ptr [ecx + field_4]               # 005065c9
    sub edx, 0x4                                 # 005065cc
    add ecx, 0x8                                 # 005065cf
    add eax, 0x8                                 # 005065d2
    add esi, 0x4                                 # 005065d5
    faddp st(1), st                              # 005065d8
    dec ebx                                      # 005065da
    fmul dword ptr [edi + field_10]              # 005065db
    fstp dword ptr [esi - field_minus_4]         # 005065de
    fld dword ptr [eax - field_minus_4]          # 005065e1
    fmul dword ptr [ecx - field_minus_8]         # 005065e4
    fld dword ptr [eax - field_minus_8]          # 005065e7
    fmul dword ptr [ecx - field_minus_4]         # 005065ea
    fsubp st(1), st                              # 005065ed
    fmul dword ptr [edi + field_10]              # 005065ef
    fstp dword ptr [edx]                         # 005065f2
    jne.d8 L_005065c2                            # 005065f4
L_005065f6:
    # block 0x005065f6: entered by jle at 0x005065bd; fall-through of jne at 0x005065f4, 7 instruction(s), ends with ret
    lea esp, [ebp - local_2c]                    # 005065f6
    pop edi                                      # 005065f9
    pop esi                                      # 005065fa
    pop ebx                                      # 005065fb
    {load} mov esp, ebp                          # 005065fc
    pop ebp                                      # 005065fe
    ret                                          # 005065ff

