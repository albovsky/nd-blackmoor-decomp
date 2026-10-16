# FUN_005152b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005152b9
# extent:       0x005152b9-0x005155c2 (777 code bytes)
# span:         0x005152b9-0x005155c2 (code 777, tables 0, padding 0)
# sha256:       5b99d84a68d281d065e0ebf69b2ca2bca61dbf050677aebb99d17803b3f1068e
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005152b9
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_b; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_17, field_44, field_c4; [ebx + n] field_4, field_8, field_10; [ecx + n] field_1, field_4, field_8, field_84, field_144, field_minus_4; [edi + n] field_minus_20; [edx + n] field_4, field_8, field_minus_4; [esi + n] field_1, field_4, field_minus_20
# callees:      calls FUN_005155c2, FUN_00515673
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 275 instruction(s), 37 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_minus_20, 0x20  # offset -0x20
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_b, 0xb  # offset +0xb
.equ field_10, 0x10  # offset +0x10
.equ field_17, 0x17  # offset +0x17
.equ field_44, 0x44  # offset +0x44
.equ field_84, 0x84  # offset +0x84
.equ field_c4, 0xc4  # offset +0xc4
.equ field_144, 0x144  # offset +0x144

# --- external targets -----------------------------------------------
.set FUN_005155c2, .text + (0x005155c2 - 0x401000)
.set FUN_00515673, .text + (0x00515673 - 0x401000)

.org 0x005152b9 - 0x401000
.globl FUN_005152b9
FUN_005152b9:
    # block 0x005152b9: entry, 19 instruction(s), ends with jge to 0x005152f9 (forward)
    push ebp                                     # 005152b9
    {load} mov ebp, esp                          # 005152ba
    sub esp, 0x14                                # 005152bc
    mov eax, dword ptr [0x63cdd0]                # 005152bf
    mov edx, dword ptr [0x63cdd4]                # 005152c4
    push ebx                                     # 005152ca
    push esi                                     # 005152cb
    lea eax, [eax + 4*eax]                       # 005152cc
    push edi                                     # 005152cf
    lea edi, [edx + 4*eax]                       # 005152d0
    mov eax, dword ptr [ebp + arg_8]             # 005152d3
    mov dword ptr [ebp - local_4], edi           # 005152d6
    lea ecx, [eax + field_17]                    # 005152d9
    and ecx, -0x10                               # 005152dc
    mov dword ptr [ebp - local_10], ecx          # 005152df
    sar ecx, 0x4                                 # 005152e2
    dec ecx                                      # 005152e5
    cmp ecx, 0x20                                # 005152e6
    jge.d8 L_005152f9                            # 005152e9
    # block 0x005152eb: entered by fall-through of jge at 0x005152e9, 5 instruction(s), ends with forward jump to 0x00515309
    or esi, -0x1                                 # 005152eb
    shr esi, cl                                  # 005152ee
    or dword ptr [ebp - local_8], -0x1           # 005152f0
    mov dword ptr [ebp - local_c], esi           # 005152f4
    jmp.d8 L_00515309                            # 005152f7
L_005152f9:
    # block 0x005152f9: entered by jge at 0x005152e9, 6 instruction(s), falls into the block at 0x00515309
    add ecx, -0x20                               # 005152f9
    or eax, -0x1                                 # 005152fc
    {load} xor esi, esi                          # 005152ff
    shr eax, cl                                  # 00515301
    mov dword ptr [ebp - local_c], esi           # 00515303
    mov dword ptr [ebp - local_8], eax           # 00515306
L_00515309:
    # block 0x00515309: entered by jmp at 0x005152f7, 5 instruction(s), ends with jae to 0x00515330 (forward)
    mov eax, dword ptr [0x63cdc8]                # 00515309
    {load} mov ebx, eax                          # 0051530e
    {load} cmp ebx, edi                          # 00515310
    mov dword ptr [ebp + arg_8], ebx             # 00515312
    jae.d8 L_00515330                            # 00515315
L_00515317:
    # block 0x00515317: entered by jb at 0x0051532e; fall-through of jae at 0x00515315, 6 instruction(s), ends with jne to 0x00515330 (forward)
    mov ecx, dword ptr [ebx + field_4]           # 00515317
    mov edi, dword ptr [ebx]                     # 0051531a
    and ecx, dword ptr [ebp - local_8]           # 0051531c
    {load} and edi, esi                          # 0051531f
    {load} or ecx, edi                           # 00515321
    jne.d8 L_00515330                            # 00515323
    # block 0x00515325: entered by fall-through of jne at 0x00515323, 4 instruction(s), ends with jb to 0x00515317 (backward)
    add ebx, 0x14                                # 00515325
    cmp ebx, dword ptr [ebp - local_4]           # 00515328
    mov dword ptr [ebp + arg_8], ebx             # 0051532b
    jb.d8 L_00515317                             # 0051532e
L_00515330:
    # block 0x00515330: entered by jae at 0x00515315; jne at 0x00515323; fall-through of jb at 0x0051532e, 2 instruction(s), ends with jne to 0x005153ae (forward)
    cmp ebx, dword ptr [ebp - local_4]           # 00515330
    jne.d8 L_005153ae                            # 00515333
    # block 0x00515335: entered by fall-through of jne at 0x00515333, 1 instruction(s), falls into the block at 0x00515337
    {load} mov ebx, edx                          # 00515335
L_00515337:
    # block 0x00515337: entered by jmp at 0x0051534f, 3 instruction(s), ends with jae to 0x00515353 (forward)
    {load} cmp ebx, eax                          # 00515337
    mov dword ptr [ebp + arg_8], ebx             # 00515339
    jae.d8 L_00515353                            # 0051533c
    # block 0x0051533e: entered by fall-through of jae at 0x0051533c, 6 instruction(s), ends with jne to 0x00515351 (forward)
    mov ecx, dword ptr [ebx + field_4]           # 0051533e
    mov edi, dword ptr [ebx]                     # 00515341
    and ecx, dword ptr [ebp - local_8]           # 00515343
    {load} and edi, esi                          # 00515346
    {load} or ecx, edi                           # 00515348
    jne.d8 L_00515351                            # 0051534a
    # block 0x0051534c: entered by fall-through of jne at 0x0051534a, 2 instruction(s), ends with backward jump to 0x00515337
    add ebx, 0x14                                # 0051534c
    jmp.d8 L_00515337                            # 0051534f
L_00515351:
    # block 0x00515351: entered by jne at 0x0051534a, 1 instruction(s), falls into the block at 0x00515353
    {load} cmp ebx, eax                          # 00515351
L_00515353:
    # block 0x00515353: entered by jae at 0x0051533c, 1 instruction(s), ends with jne to 0x005153ae (forward)
    jne.d8 L_005153ae                            # 00515353
L_00515355:
    # block 0x00515355: entered by jmp at 0x00515366; fall-through of jne at 0x00515353, 2 instruction(s), ends with jae to 0x0051536b (forward)
    cmp ebx, dword ptr [ebp - local_4]           # 00515355
    jae.d8 L_0051536b                            # 00515358
    # block 0x0051535a: entered by fall-through of jae at 0x00515358, 2 instruction(s), ends with jne to 0x00515368 (forward)
    cmp dword ptr [ebx + field_8], 0x0           # 0051535a
    jne.d8 L_00515368                            # 0051535e
    # block 0x00515360: entered by fall-through of jne at 0x0051535e, 3 instruction(s), ends with backward jump to 0x00515355
    add ebx, 0x14                                # 00515360
    mov dword ptr [ebp + arg_8], ebx             # 00515363
    jmp.d8 L_00515355                            # 00515366
L_00515368:
    # block 0x00515368: entered by jne at 0x0051535e, 1 instruction(s), falls into the block at 0x0051536b
    cmp ebx, dword ptr [ebp - local_4]           # 00515368
L_0051536b:
    # block 0x0051536b: entered by jae at 0x00515358, 1 instruction(s), ends with jne to 0x00515393 (forward)
    jne.d8 L_00515393                            # 0051536b
    # block 0x0051536d: entered by fall-through of jne at 0x0051536b, 1 instruction(s), falls into the block at 0x0051536f
    {load} mov ebx, edx                          # 0051536d
L_0051536f:
    # block 0x0051536f: entered by jmp at 0x0051537f, 3 instruction(s), ends with jae to 0x00515383 (forward)
    {load} cmp ebx, eax                          # 0051536f
    mov dword ptr [ebp + arg_8], ebx             # 00515371
    jae.d8 L_00515383                            # 00515374
    # block 0x00515376: entered by fall-through of jae at 0x00515374, 2 instruction(s), ends with jne to 0x00515381 (forward)
    cmp dword ptr [ebx + field_8], 0x0           # 00515376
    jne.d8 L_00515381                            # 0051537a
    # block 0x0051537c: entered by fall-through of jne at 0x0051537a, 2 instruction(s), ends with backward jump to 0x0051536f
    add ebx, 0x14                                # 0051537c
    jmp.d8 L_0051536f                            # 0051537f
L_00515381:
    # block 0x00515381: entered by jne at 0x0051537a, 1 instruction(s), falls into the block at 0x00515383
    {load} cmp ebx, eax                          # 00515381
L_00515383:
    # block 0x00515383: entered by jae at 0x00515374, 1 instruction(s), ends with jne to 0x00515393 (forward)
    jne.d8 L_00515393                            # 00515383
    # block 0x00515385: entered by fall-through of jne at 0x00515383, 5 instruction(s), calls FUN_005155c2, ends with je to 0x005153a7 (forward)
    call FUN_005155c2                            # 00515385
    {load} mov ebx, eax                          # 0051538a
    test ebx, ebx                                # 0051538c
    mov dword ptr [ebp + arg_8], ebx             # 0051538e
    je.d8 L_005153a7                             # 00515391
L_00515393:
    # block 0x00515393: entered by jne at 0x0051536b; jne at 0x00515383; fall-through of je at 0x00515391, 8 instruction(s), calls FUN_00515673, ends with jne to 0x005153ae (forward)
    push ebx                                     # 00515393
    call FUN_00515673                            # 00515394
    pop ecx                                      # 00515399
    mov ecx, dword ptr [ebx + field_10]          # 0051539a
    mov dword ptr [ecx], eax                     # 0051539d
    mov eax, dword ptr [ebx + field_10]          # 0051539f
    cmp dword ptr [eax], -0x1                    # 005153a2
    jne.d8 L_005153ae                            # 005153a5
L_005153a7:
    # block 0x005153a7: entered by je at 0x00515391; fall-through of jne at 0x005153a5, 2 instruction(s), ends with forward jump to 0x005155bd
    {load} xor eax, eax                          # 005153a7
    jmp.d32 L_005155bd                           # 005153a9
L_005153ae:
    # block 0x005153ae: entered by jne at 0x00515333; jne at 0x00515353; jne at 0x005153a5, 6 instruction(s), ends with je to 0x005153d5 (forward)
    mov dword ptr [0x63cdc8], ebx                # 005153ae
    mov eax, dword ptr [ebx + field_10]          # 005153b4
    mov edx, dword ptr [eax]                     # 005153b7
    cmp edx, -0x1                                # 005153b9
    mov dword ptr [ebp - local_4], edx           # 005153bc
    je.d8 L_005153d5                             # 005153bf
    # block 0x005153c1: entered by fall-through of je at 0x005153bf, 6 instruction(s), ends with jne to 0x0051540c (forward)
    mov ecx, dword ptr [eax + 4*edx + field_c4]  # 005153c1
    mov edi, dword ptr [eax + 4*edx + field_44]  # 005153c8
    and ecx, dword ptr [ebp - local_8]           # 005153cc
    {load} and edi, esi                          # 005153cf
    {load} or ecx, edi                           # 005153d1
    jne.d8 L_0051540c                            # 005153d3
L_005153d5:
    # block 0x005153d5: entered by je at 0x005153bf; fall-through of jne at 0x005153d3, 9 instruction(s), ends with jne to 0x00515409 (forward)
    mov edx, dword ptr [eax + field_c4]          # 005153d5
    mov esi, dword ptr [eax + field_44]          # 005153db
    and edx, dword ptr [ebp - local_8]           # 005153de
    and esi, dword ptr [ebp - local_c]           # 005153e1
    and dword ptr [ebp - local_4], 0x0           # 005153e4
    lea ecx, [eax + field_44]                    # 005153e8
    {load} or edx, esi                           # 005153eb
    mov esi, dword ptr [ebp - local_c]           # 005153ed
    jne.d8 L_00515409                            # 005153f0
L_005153f2:
    # block 0x005153f2: entered by je at 0x00515407; fall-through of jne at 0x005153f0, 8 instruction(s), ends with je to 0x005153f2 (backward)
    mov edx, dword ptr [ecx + field_84]          # 005153f2
    inc dword ptr [ebp - local_4]                # 005153f8
    and edx, dword ptr [ebp - local_8]           # 005153fb
    add ecx, 0x4                                 # 005153fe
    {load} mov edi, esi                          # 00515401
    and edi, dword ptr [ecx]                     # 00515403
    {load} or edx, edi                           # 00515405
    je.d8 L_005153f2                             # 00515407
L_00515409:
    # block 0x00515409: entered by jne at 0x005153f0; fall-through of je at 0x00515407, 1 instruction(s), falls into the block at 0x0051540c
    mov edx, dword ptr [ebp - local_4]           # 00515409
L_0051540c:
    # block 0x0051540c: entered by jne at 0x005153d3, 8 instruction(s), ends with jne to 0x00515435 (forward)
    {load} mov ecx, edx                          # 0051540c
    {load} xor edi, edi                          # 0051540e
    imul ecx, ecx, 0x204                         # 00515410
    lea ecx, [ecx + eax + field_144]             # 00515416
    mov dword ptr [ebp - local_c], ecx           # 0051541d
    mov ecx, dword ptr [eax + 4*edx + field_44]  # 00515420
    {load} and ecx, esi                          # 00515424
    jne.d8 L_00515435                            # 00515426
    # block 0x00515428: entered by fall-through of jne at 0x00515426, 4 instruction(s), falls into the block at 0x00515435
    mov ecx, dword ptr [eax + 4*edx + field_c4]  # 00515428
    push 0x20                                    # 0051542f
    and ecx, dword ptr [ebp - local_8]           # 00515431
    pop edi                                      # 00515434
L_00515435:
    # block 0x00515435: entered by jne at 0x00515426; jmp at 0x0051543c, 2 instruction(s), ends with jl to 0x0051543e (forward)
    test ecx, ecx                                # 00515435
    jl.d8 L_0051543e                             # 00515437
    # block 0x00515439: entered by fall-through of jl at 0x00515437, 3 instruction(s), ends with backward jump to 0x00515435
    shl ecx                                      # 00515439
    inc edi                                      # 0051543b
    jmp.d8 L_00515435                            # 0051543c
L_0051543e:
    # block 0x0051543e: entered by jl at 0x00515437, 10 instruction(s), ends with jle to 0x0051545b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0051543e
    mov edx, dword ptr [ecx + 8*edi + field_4]   # 00515441
    mov ecx, dword ptr [edx]                     # 00515445
    sub ecx, dword ptr [ebp - local_10]          # 00515447
    {load} mov esi, ecx                          # 0051544a
    mov dword ptr [ebp - local_8], ecx           # 0051544c
    sar esi, 0x4                                 # 0051544f
    dec esi                                      # 00515452
    cmp esi, 0x3f                                # 00515453
    jle.d8 L_0051545b                            # 00515456
    # block 0x00515458: entered by fall-through of jle at 0x00515456, 2 instruction(s), falls into the block at 0x0051545b
    push 0x3f                                    # 00515458
    pop esi                                      # 0051545a
L_0051545b:
    # block 0x0051545b: entered by jle at 0x00515456, 2 instruction(s), ends with je to 0x00515570 (forward)
    {load} cmp esi, edi                          # 0051545b
    je.d32 L_00515570                            # 0051545d
    # block 0x00515463: entered by fall-through of je at 0x0051545d, 3 instruction(s), ends with jne to 0x005154cc (forward)
    mov ecx, dword ptr [edx + field_4]           # 00515463
    cmp ecx, dword ptr [edx + field_8]           # 00515466
    jne.d8 L_005154cc                            # 00515469
    # block 0x0051546b: entered by fall-through of jne at 0x00515469, 2 instruction(s), ends with jge to 0x0051549b (forward)
    cmp edi, 0x20                                # 0051546b
    jge.d8 L_0051549b                            # 0051546e
    # block 0x00515470: entered by fall-through of jge at 0x0051546e, 11 instruction(s), ends with jne to 0x005154c9 (forward)
    mov ebx, 0x80000000                          # 00515470
    {load} mov ecx, edi                          # 00515475
    shr ebx, cl                                  # 00515477
    mov ecx, dword ptr [ebp - local_4]           # 00515479
    lea edi, [eax + edi + field_4]               # 0051547c
    not ebx                                      # 00515480
    mov dword ptr [ebp - local_14], ebx          # 00515482
    and ebx, dword ptr [eax + 4*ecx + field_44]  # 00515485
    mov dword ptr [eax + 4*ecx + field_44], ebx  # 00515489
    dec byte ptr [edi]                           # 0051548d
    jne.d8 L_005154c9                            # 0051548f
    # block 0x00515491: entered by fall-through of jne at 0x0051548f, 4 instruction(s), ends with forward jump to 0x005154cc
    mov ebx, dword ptr [ebp + arg_8]             # 00515491
    mov ecx, dword ptr [ebp - local_14]          # 00515494
    and dword ptr [ebx], ecx                     # 00515497
    jmp.d8 L_005154cc                            # 00515499
L_0051549b:
    # block 0x0051549b: entered by jge at 0x0051546e, 11 instruction(s), ends with jne to 0x005154c9 (forward)
    lea ecx, [edi - field_minus_20]              # 0051549b
    mov ebx, 0x80000000                          # 0051549e
    shr ebx, cl                                  # 005154a3
    mov ecx, dword ptr [ebp - local_4]           # 005154a5
    lea edi, [eax + edi + field_4]               # 005154a8
    lea ecx, [eax + 4*ecx + field_c4]            # 005154ac
    not ebx                                      # 005154b3
    and dword ptr [ecx], ebx                     # 005154b5
    dec byte ptr [edi]                           # 005154b7
    mov dword ptr [ebp - local_14], ebx          # 005154b9
    jne.d8 L_005154c9                            # 005154bc
    # block 0x005154be: entered by fall-through of jne at 0x005154bc, 4 instruction(s), ends with forward jump to 0x005154cc
    mov ebx, dword ptr [ebp + arg_8]             # 005154be
    mov ecx, dword ptr [ebp - local_14]          # 005154c1
    and dword ptr [ebx + field_4], ecx           # 005154c4
    jmp.d8 L_005154cc                            # 005154c7
L_005154c9:
    # block 0x005154c9: entered by jne at 0x0051548f; jne at 0x005154bc, 1 instruction(s), falls into the block at 0x005154cc
    mov ebx, dword ptr [ebp + arg_8]             # 005154c9
L_005154cc:
    # block 0x005154cc: entered by jne at 0x00515469; jmp at 0x00515499; jmp at 0x005154c7, 8 instruction(s), ends with je to 0x0051557c (forward)
    mov ecx, dword ptr [edx + field_8]           # 005154cc
    mov edi, dword ptr [edx + field_4]           # 005154cf
    cmp dword ptr [ebp - local_8], 0x0           # 005154d2
    mov dword ptr [ecx + field_4], edi           # 005154d6
    mov ecx, dword ptr [edx + field_4]           # 005154d9
    mov edi, dword ptr [edx + field_8]           # 005154dc
    mov dword ptr [ecx + field_8], edi           # 005154df
    je.d32 L_0051557c                            # 005154e2
    # block 0x005154e8: entered by fall-through of je at 0x005154e2, 11 instruction(s), ends with jne to 0x0051556d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 005154e8
    mov edi, dword ptr [ecx + 8*esi + field_4]   # 005154eb
    lea ecx, [ecx + 8*esi]                       # 005154ef
    mov dword ptr [edx + field_4], edi           # 005154f2
    mov dword ptr [edx + field_8], ecx           # 005154f5
    mov dword ptr [ecx + field_4], edx           # 005154f8
    mov ecx, dword ptr [edx + field_4]           # 005154fb
    mov dword ptr [ecx + field_8], edx           # 005154fe
    mov ecx, dword ptr [edx + field_4]           # 00515501
    cmp ecx, dword ptr [edx + field_8]           # 00515504
    jne.d8 L_0051556d                            # 00515507
    # block 0x00515509: entered by fall-through of jne at 0x00515507, 4 instruction(s), ends with jge to 0x0051553e (forward)
    mov cl, byte ptr [esi + eax + field_4]       # 00515509
    cmp esi, 0x20                                # 0051550d
    mov byte ptr [ebp + arg_b], cl               # 00515510
    jge.d8 L_0051553e                            # 00515513
    # block 0x00515515: entered by fall-through of jge at 0x00515513, 4 instruction(s), ends with jne to 0x0051552c (forward)
    inc cl                                       # 00515515
    cmp byte ptr [ebp + arg_b], 0x0              # 00515517
    mov byte ptr [esi + eax + field_4], cl       # 0051551b
    jne.d8 L_0051552c                            # 0051551f
    # block 0x00515521: entered by fall-through of jne at 0x0051551f, 4 instruction(s), falls into the block at 0x0051552c
    mov edi, 0x80000000                          # 00515521
    {load} mov ecx, esi                          # 00515526
    shr edi, cl                                  # 00515528
    or dword ptr [ebx], edi                      # 0051552a
L_0051552c:
    # block 0x0051552c: entered by jne at 0x0051551f, 6 instruction(s), ends with forward jump to 0x0051556d
    mov edi, 0x80000000                          # 0051552c
    {load} mov ecx, esi                          # 00515531
    shr edi, cl                                  # 00515533
    mov ecx, dword ptr [ebp - local_4]           # 00515535
    or dword ptr [eax + 4*ecx + field_44], edi   # 00515538
    jmp.d8 L_0051556d                            # 0051553c
L_0051553e:
    # block 0x0051553e: entered by jge at 0x00515513, 4 instruction(s), ends with jne to 0x00515557 (forward)
    inc cl                                       # 0051553e
    cmp byte ptr [ebp + arg_b], 0x0              # 00515540
    mov byte ptr [esi + eax + field_4], cl       # 00515544
    jne.d8 L_00515557                            # 00515548
    # block 0x0051554a: entered by fall-through of jne at 0x00515548, 4 instruction(s), falls into the block at 0x00515557
    lea ecx, [esi - field_minus_20]              # 0051554a
    mov edi, 0x80000000                          # 0051554d
    shr edi, cl                                  # 00515552
    or dword ptr [ebx + field_4], edi            # 00515554
L_00515557:
    # block 0x00515557: entered by jne at 0x00515548, 6 instruction(s), falls into the block at 0x0051556d
    mov ecx, dword ptr [ebp - local_4]           # 00515557
    lea edi, [eax + 4*ecx + field_c4]            # 0051555a
    lea ecx, [esi - field_minus_20]              # 00515561
    mov esi, 0x80000000                          # 00515564
    shr esi, cl                                  # 00515569
    or dword ptr [edi], esi                      # 0051556b
L_0051556d:
    # block 0x0051556d: entered by jne at 0x00515507; jmp at 0x0051553c, 1 instruction(s), falls into the block at 0x00515570
    mov ecx, dword ptr [ebp - local_8]           # 0051556d
L_00515570:
    # block 0x00515570: entered by je at 0x0051545d, 2 instruction(s), ends with je to 0x0051557f (forward)
    test ecx, ecx                                # 00515570
    je.d8 L_0051557f                             # 00515572
    # block 0x00515574: entered by fall-through of je at 0x00515572, 3 instruction(s), ends with forward jump to 0x0051557f
    mov dword ptr [edx], ecx                     # 00515574
    mov dword ptr [ecx + edx - field_minus_4], ecx # 00515576
    jmp.d8 L_0051557f                            # 0051557a
L_0051557c:
    # block 0x0051557c: entered by je at 0x005154e2, 1 instruction(s), falls into the block at 0x0051557f
    mov ecx, dword ptr [ebp - local_8]           # 0051557c
L_0051557f:
    # block 0x0051557f: entered by je at 0x00515572; jmp at 0x0051557a, 11 instruction(s), ends with jne to 0x005155b5 (forward)
    mov esi, dword ptr [ebp - local_10]          # 0051557f
    {load} add edx, ecx                          # 00515582
    lea ecx, [esi + field_1]                     # 00515584
    mov dword ptr [edx], ecx                     # 00515587
    mov dword ptr [edx + esi - field_minus_4], ecx # 00515589
    mov esi, dword ptr [ebp - local_c]           # 0051558d
    mov ecx, dword ptr [esi]                     # 00515590
    test ecx, ecx                                # 00515592
    lea edi, [ecx + field_1]                     # 00515594
    mov dword ptr [esi], edi                     # 00515597
    jne.d8 L_005155b5                            # 00515599
    # block 0x0051559b: entered by fall-through of jne at 0x00515599, 2 instruction(s), ends with jne to 0x005155b5 (forward)
    cmp ebx, dword ptr [0x63cdcc]                # 0051559b
    jne.d8 L_005155b5                            # 005155a1
    # block 0x005155a3: entered by fall-through of jne at 0x005155a1, 3 instruction(s), ends with jne to 0x005155b5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 005155a3
    cmp ecx, dword ptr [0x63cdc4]                # 005155a6
    jne.d8 L_005155b5                            # 005155ac
    # block 0x005155ae: entered by fall-through of jne at 0x005155ac, 1 instruction(s), falls into the block at 0x005155b5
    and dword ptr [0x63cdcc], 0x0                # 005155ae
L_005155b5:
    # block 0x005155b5: entered by jne at 0x00515599; jne at 0x005155a1; jne at 0x005155ac, 3 instruction(s), falls into the block at 0x005155bd
    mov ecx, dword ptr [ebp - local_4]           # 005155b5
    mov dword ptr [eax], ecx                     # 005155b8
    lea eax, [edx + field_4]                     # 005155ba
L_005155bd:
    # block 0x005155bd: entered by jmp at 0x005153a9, 5 instruction(s), ends with ret
    pop edi                                      # 005155bd
    pop esi                                      # 005155be
    pop ebx                                      # 005155bf
    leave                                        # 005155c0
    ret                                          # 005155c1

