# FUN_00507340
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507340
# extent:       0x00507340-0x005076f8 (952 code bytes)
# span:         0x00507340-0x00507700 (code 952, tables 0, padding 8)
# sha256:       852233d10390e6901810d36e42d404be5d49860e82d131c0dee16cdcf4acbfe9
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507340
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_38
# fields:       [eax + n] field_4, field_64, field_minus_400; [ebx + n] field_444, field_484, field_888, field_minus_4, field_minus_400; [ecx + n] field_4, field_18, field_1c, field_30, field_320, field_404, field_520; [edx + n] field_4, field_c, field_14, field_30, field_34, field_320, field_404; [esi + n] field_18, field_1c, field_20, field_24, field_40
# callees:      calls FUN_0050c920, FUN_005055c0, FUN_00505260; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 345 instruction(s), 26 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_38, 0x38  # offset -0x38
.equ field_minus_400, 0x400  # offset -0x400
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_40, 0x40  # offset +0x40
.equ field_64, 0x64  # offset +0x64
.equ field_320, 0x320  # offset +0x320
.equ field_404, 0x404  # offset +0x404
.equ field_444, 0x444  # offset +0x444
.equ field_484, 0x484  # offset +0x484
.equ field_520, 0x520  # offset +0x520
.equ field_888, 0x888  # offset +0x888

# --- external targets -----------------------------------------------
.set FUN_00505260, .text + (0x00505260 - 0x401000)
.set FUN_005055c0, .text + (0x005055c0 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00507340 - 0x401000
.globl FUN_00507340
FUN_00507340:
    # block 0x00507340: entry, 44 instruction(s), calls FUN_0050c920, ends with jle to 0x00507459 (forward)
    push ebp                                     # 00507340
    {load} mov ebp, esp                          # 00507341
    sub esp, 0x2c                                # 00507343
    push ebx                                     # 00507346
    push esi                                     # 00507347
    mov esi, dword ptr [ebp + arg_8]             # 00507348
    push edi                                     # 0050734b
    mov eax, dword ptr [esi + field_40]          # 0050734c
    mov ecx, dword ptr [eax + field_4]           # 0050734f
    mov eax, dword ptr [eax + field_64]          # 00507352
    mov dword ptr [ebp - local_8], eax           # 00507355
    mov eax, dword ptr [esi + field_1c]          # 00507358
    mov edx, dword ptr [ecx + field_1c]          # 0050735b
    mov dword ptr [ebp + arg_8], ecx             # 0050735e
    mov dword ptr [ebp - local_10], edx          # 00507361
    mov edx, dword ptr [edx + 4*eax]             # 00507364
    mov dword ptr [esi + field_24], edx          # 00507367
    mov edi, dword ptr [ecx + field_4]           # 0050736a
    mov dword ptr [ebp - local_1c], edx          # 0050736d
    lea ebx, [4*edi]                             # 00507370
    {load} mov eax, ebx                          # 00507377
    add eax, 0x3                                 # 00507379
    and al, -0x4                                 # 0050737c
    call FUN_0050c920                            # 0050737e
    {load} mov eax, ebx                          # 00507383
    mov dword ptr [ebp - local_24], esp          # 00507385
    add eax, 0x3                                 # 00507388
    and al, -0x4                                 # 0050738b
    call FUN_0050c920                            # 0050738d
    {load} mov eax, ebx                          # 00507392
    mov dword ptr [ebp - local_20], esp          # 00507394
    add eax, 0x3                                 # 00507397
    and al, -0x4                                 # 0050739a
    call FUN_0050c920                            # 0050739c
    {load} mov eax, ebx                          # 005073a1
    mov dword ptr [ebp - local_c], esp           # 005073a3
    add eax, 0x3                                 # 005073a6
    and al, -0x4                                 # 005073a9
    call FUN_0050c920                            # 005073ab
    {load} mov eax, esp                          # 005073b0
    {load} xor ebx, ebx                          # 005073b2
    test edi, edi                                # 005073b4
    mov dword ptr [ebp - local_2c], eax          # 005073b6
    jle.d32 L_00507459                           # 005073b9
    # block 0x005073bf: entered by fall-through of jle at 0x005073b9, 12 instruction(s), ends with forward jump to 0x005073e3
    mov ecx, dword ptr [ebp - local_1c]          # 005073bf
    mov edx, dword ptr [ebp + arg_c]             # 005073c2
    mov edi, dword ptr [ebp - local_c]           # 005073c5
    add edx, 0x4                                 # 005073c8
    shl ecx, 0x2                                 # 005073cb
    shr ecx                                      # 005073ce
    {load} sub eax, edi                          # 005073d0
    mov dword ptr [ebp - local_28], ecx          # 005073d2
    mov dword ptr [ebp - local_14], edi          # 005073d5
    mov dword ptr [ebp - local_4], edx           # 005073d8
    mov dword ptr [ebp - local_18], eax          # 005073db
    jmp.d8 L_005073e3                            # 005073de
L_005073e0:
    # block 0x005073e0: entered by jl at 0x00507457, 1 instruction(s), falls into the block at 0x005073e3
    mov edi, dword ptr [ebp - local_14]          # 005073e0
L_005073e3:
    # block 0x005073e3: entered by jmp at 0x005073de, 41 instruction(s), calls indirect dword ptr [edx + 0x14], ends with jl to 0x005073e0 (backward)
    mov eax, dword ptr [ebp - local_4]           # 005073e3
    mov ecx, dword ptr [ebp + arg_c]             # 005073e6
    mov edx, dword ptr [ebp - local_10]          # 005073e9
    mov eax, dword ptr [eax]                     # 005073ec
    mov eax, dword ptr [ecx + 4*eax + field_404] # 005073ee
    mov ecx, dword ptr [edx + 4*eax + field_320] # 005073f5
    mov edx, dword ptr [4*ecx + 0x5669e0]        # 005073fc
    mov ecx, dword ptr [ebp - local_8]           # 00507403
    mov ecx, dword ptr [ecx + field_30]          # 00507406
    mov eax, dword ptr [ecx + 4*eax]             # 00507409
    push eax                                     # 0050740c
    push esi                                     # 0050740d
    call dword ptr [edx + field_14]              # 0050740e
    mov ecx, dword ptr [ebp - local_18]          # 00507411
    add esp, 0x8                                 # 00507414
    {load} xor edx, edx                          # 00507417
    test eax, eax                                # 00507419
    setne dl                                     # 0050741b
    mov dword ptr [ecx + edi], eax               # 0050741e
    mov ecx, dword ptr [ebp - local_28]          # 00507421
    mov dword ptr [edi], edx                     # 00507424
    mov edx, dword ptr [esi]                     # 00507426
    {load} xor eax, eax                          # 00507428
    mov edi, dword ptr [edx + 4*ebx]             # 0050742a
    {load} mov edx, ecx                          # 0050742d
    shr ecx, 0x2                                 # 0050742f
    rep stosd dword ptr es:[edi], eax            # 00507432
    {load} mov ecx, edx                          # 00507434
    mov edx, dword ptr [ebp - local_14]          # 00507436
    and ecx, 0x3                                 # 00507439
    inc ebx                                      # 0050743c
    rep stosb byte ptr es:[edi], al              # 0050743d
    mov edi, dword ptr [ebp - local_4]           # 0050743f
    mov eax, 0x4                                 # 00507442
    {load} add edi, eax                          # 00507447
    {load} add edx, eax                          # 00507449
    mov eax, dword ptr [ebp + arg_8]             # 0050744b
    mov dword ptr [ebp - local_4], edi           # 0050744e
    mov dword ptr [ebp - local_14], edx          # 00507451
    cmp ebx, dword ptr [eax + field_4]           # 00507454
    jl.d8 L_005073e0                             # 00507457
L_00507459:
    # block 0x00507459: entered by jle at 0x005073b9; fall-through of jl at 0x00507457, 5 instruction(s), ends with jle to 0x005074b1 (forward)
    mov ebx, dword ptr [ebp + arg_c]             # 00507459
    mov dword ptr [ebp - local_4], 0x0           # 0050745c
    mov eax, dword ptr [ebx + field_484]         # 00507463
    test eax, eax                                # 00507469
    jle.d8 L_005074b1                            # 0050746b
    # block 0x0050746d: entered by fall-through of jle at 0x0050746b, 1 instruction(s), falls into the block at 0x00507473
    lea eax, [ebx + field_888]                   # 0050746d
L_00507473:
    # block 0x00507473: entered by jl at 0x005074af, 6 instruction(s), ends with jne to 0x0050748e (forward)
    mov edx, dword ptr [eax - field_minus_400]   # 00507473
    mov ecx, dword ptr [ebp - local_c]           # 00507479
    mov edi, dword ptr [ecx + 4*edx]             # 0050747c
    lea edx, [ecx + 4*edx]                       # 0050747f
    test edi, edi                                # 00507482
    jne.d8 L_0050748e                            # 00507484
    # block 0x00507486: entered by fall-through of jne at 0x00507484, 3 instruction(s), ends with je to 0x0050749d (forward)
    mov edi, dword ptr [eax]                     # 00507486
    cmp dword ptr [ecx + 4*edi], 0x0             # 00507488
    je.d8 L_0050749d                             # 0050748c
L_0050748e:
    # block 0x0050748e: entered by jne at 0x00507484; fall-through of je at 0x0050748c, 3 instruction(s), falls into the block at 0x0050749d
    mov dword ptr [edx], 0x1                     # 0050748e
    mov edx, dword ptr [eax]                     # 00507494
    mov dword ptr [ecx + 4*edx], 0x1             # 00507496
L_0050749d:
    # block 0x0050749d: entered by je at 0x0050748c, 7 instruction(s), ends with jl to 0x00507473 (backward)
    mov ecx, dword ptr [ebp - local_4]           # 0050749d
    mov edx, dword ptr [ebx + field_484]         # 005074a0
    inc ecx                                      # 005074a6
    add eax, 0x4                                 # 005074a7
    {load} cmp ecx, edx                          # 005074aa
    mov dword ptr [ebp - local_4], ecx           # 005074ac
    jl.d8 L_00507473                             # 005074af
L_005074b1:
    # block 0x005074b1: entered by jle at 0x0050746b; fall-through of jl at 0x005074af, 4 instruction(s), ends with jle to 0x00507570 (forward)
    mov eax, dword ptr [ebx]                     # 005074b1
    mov dword ptr [ebp - local_4], 0x0           # 005074b3
    test eax, eax                                # 005074ba
    jle.d32 L_00507570                           # 005074bc
    # block 0x005074c2: entered by fall-through of jle at 0x005074bc, 2 instruction(s), falls into the block at 0x005074cb
    lea eax, [ebx + field_444]                   # 005074c2
    mov dword ptr [ebp - local_18], eax          # 005074c8
L_005074cb:
    # block 0x005074cb: entered by jl at 0x0050756a, 6 instruction(s), ends with jle to 0x00507526 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 005074cb
    {load} xor edi, edi                          # 005074ce
    {load} xor ecx, ecx                          # 005074d0
    mov eax, dword ptr [edx + field_4]           # 005074d2
    test eax, eax                                # 005074d5
    jle.d8 L_00507526                            # 005074d7
    # block 0x005074d9: entered by fall-through of jle at 0x005074d7, 6 instruction(s), falls into the block at 0x005074ea
    mov eax, dword ptr [ebp - local_20]          # 005074d9
    mov edx, dword ptr [ebp - local_24]          # 005074dc
    add ebx, 0x4                                 # 005074df
    {load} sub edx, eax                          # 005074e2
    mov dword ptr [ebp - local_14], ebx          # 005074e4
    mov dword ptr [ebp - local_28], edx          # 005074e7
L_005074ea:
    # block 0x005074ea: entered by jl at 0x00507521, 4 instruction(s), ends with jne to 0x00507511 (forward)
    mov ebx, dword ptr [ebp - local_14]          # 005074ea
    mov edx, dword ptr [ebp - local_4]           # 005074ed
    cmp dword ptr [ebx], edx                     # 005074f0
    jne.d8 L_00507511                            # 005074f2
    # block 0x005074f4: entered by fall-through of jne at 0x005074f2, 11 instruction(s), falls into the block at 0x00507511
    mov ebx, dword ptr [ebp - local_c]           # 005074f4
    {load} xor edx, edx                          # 005074f7
    cmp dword ptr [ebx + 4*ecx], edx             # 005074f9
    mov ebx, dword ptr [ebp - local_28]          # 005074fc
    setne dl                                     # 005074ff
    mov dword ptr [eax], edx                     # 00507502
    mov edx, dword ptr [esi]                     # 00507504
    inc edi                                      # 00507506
    add eax, 0x4                                 # 00507507
    mov edx, dword ptr [edx + 4*ecx]             # 0050750a
    mov dword ptr [ebx + eax - field_minus_4], edx # 0050750d
L_00507511:
    # block 0x00507511: entered by jne at 0x005074f2, 7 instruction(s), ends with jl to 0x005074ea (backward)
    mov edx, dword ptr [ebp - local_14]          # 00507511
    inc ecx                                      # 00507514
    add edx, 0x4                                 # 00507515
    mov dword ptr [ebp - local_14], edx          # 00507518
    mov edx, dword ptr [ebp + arg_8]             # 0050751b
    cmp ecx, dword ptr [edx + field_4]           # 0050751e
    jl.d8 L_005074ea                             # 00507521
    # block 0x00507523: entered by fall-through of jl at 0x00507521, 1 instruction(s), falls into the block at 0x00507526
    mov ebx, dword ptr [ebp + arg_c]             # 00507523
L_00507526:
    # block 0x00507526: entered by jle at 0x005074d7, 26 instruction(s), calls indirect dword ptr [ecx + 0x1c], ends with jl to 0x005074cb (backward)
    mov eax, dword ptr [ebp - local_18]          # 00507526
    mov ecx, dword ptr [ebp - local_10]          # 00507529
    push edi                                     # 0050752c
    mov eax, dword ptr [eax]                     # 0050752d
    mov edx, dword ptr [ecx + 4*eax + field_520] # 0050752f
    mov ecx, dword ptr [4*edx + 0x5669e8]        # 00507536
    mov edx, dword ptr [ebp - local_20]          # 0050753d
    push edx                                     # 00507540
    mov edx, dword ptr [ebp - local_24]          # 00507541
    push edx                                     # 00507544
    mov edx, dword ptr [ebp - local_8]           # 00507545
    mov edx, dword ptr [edx + field_34]          # 00507548
    mov eax, dword ptr [edx + 4*eax]             # 0050754b
    push eax                                     # 0050754e
    push esi                                     # 0050754f
    call dword ptr [ecx + field_1c]              # 00507550
    mov eax, dword ptr [ebp - local_4]           # 00507553
    mov edx, dword ptr [ebp - local_18]          # 00507556
    mov ecx, dword ptr [ebx]                     # 00507559
    add esp, 0x14                                # 0050755b
    inc eax                                      # 0050755e
    add edx, 0x4                                 # 0050755f
    {load} cmp eax, ecx                          # 00507562
    mov dword ptr [ebp - local_4], eax           # 00507564
    mov dword ptr [ebp - local_18], edx          # 00507567
    jl.d32 L_005074cb                            # 0050756a
L_00507570:
    # block 0x00507570: entered by jle at 0x005074bc; fall-through of jl at 0x0050756a, 3 instruction(s), ends with js to 0x00507611 (forward)
    mov ecx, dword ptr [ebx + field_484]         # 00507570
    dec ecx                                      # 00507576
    js.d32 L_00507611                            # 00507577
    # block 0x0050757d: entered by fall-through of js at 0x00507577, 8 instruction(s), falls into the block at 0x00507592
    mov eax, dword ptr [ebp - local_1c]          # 0050757d
    lea ebx, [ebx + 4*ecx + field_888]           # 00507580
    cdq                                          # 00507587
    {load} sub eax, edx                          # 00507588
    {load} mov edi, eax                          # 0050758a
    sar edi                                      # 0050758c
    inc ecx                                      # 0050758e
    mov dword ptr [ebp - local_20], ecx          # 0050758f
L_00507592:
    # block 0x00507592: entered by jne at 0x0050760f, 7 instruction(s), ends with jle to 0x00507605 (forward)
    mov eax, dword ptr [esi]                     # 00507592
    mov ecx, dword ptr [ebx - field_minus_400]   # 00507594
    mov edx, dword ptr [ebx]                     # 0050759a
    mov ecx, dword ptr [eax + 4*ecx]             # 0050759c
    mov eax, dword ptr [eax + 4*edx]             # 0050759f
    test edi, edi                                # 005075a2
    jle.d8 L_00507605                            # 005075a4
    # block 0x005075a6: entered by fall-through of jle at 0x005075a4, 3 instruction(s), falls into the block at 0x005075ad
    {load} mov edx, eax                          # 005075a6
    mov dword ptr [ebp - local_24], edi          # 005075a8
    {load} sub edx, ecx                          # 005075ab
L_005075ad:
    # block 0x005075ad: entered by jne at 0x00507603, 9 instruction(s), ends with jne to 0x005075e0 (forward)
    fld dword ptr [ecx]                          # 005075ad
    fld dword ptr [edx + ecx]                    # 005075af
    fld st(1)                                    # 005075b2
    fcomp dword ptr [0x52db78]                   # 005075b4
    fnstsw ax                                    # 005075ba
    fcom dword ptr [0x52db78]                    # 005075bc
    test ah, 0x41                                # 005075c2
    fnstsw ax                                    # 005075c5
    jne.d8 L_005075e0                            # 005075c7
    # block 0x005075c9: entered by fall-through of jne at 0x005075c7, 2 instruction(s), ends with jne to 0x005075d7 (forward)
    test ah, 0x41                                # 005075c9
    jne.d8 L_005075d7                            # 005075cc
    # block 0x005075ce: entered by fall-through of jne at 0x005075cc, 4 instruction(s), ends with forward jump to 0x005075f7
    fxch st(1)                                   # 005075ce
    fsub st, st(1)                               # 005075d0
    fstp dword ptr [edx + ecx]                   # 005075d2
    jmp.d8 L_005075f7                            # 005075d5
L_005075d7:
    # block 0x005075d7: entered by jne at 0x005075cc, 4 instruction(s), ends with forward jump to 0x005075f5
    fld st(1)                                    # 005075d7
    fstp dword ptr [edx + ecx]                   # 005075d9
    fadd st, st(1)                               # 005075dc
    jmp.d8 L_005075f5                            # 005075de
L_005075e0:
    # block 0x005075e0: entered by jne at 0x005075c7, 2 instruction(s), ends with jne to 0x005075ec (forward)
    test ah, 0x41                                # 005075e0
    jne.d8 L_005075ec                            # 005075e3
    # block 0x005075e5: entered by fall-through of jne at 0x005075e3, 3 instruction(s), ends with forward jump to 0x005075f7
    fadd st, st(1)                               # 005075e5
    fstp dword ptr [edx + ecx]                   # 005075e7
    jmp.d8 L_005075f7                            # 005075ea
L_005075ec:
    # block 0x005075ec: entered by jne at 0x005075e3, 4 instruction(s), falls into the block at 0x005075f5
    fld st(1)                                    # 005075ec
    fstp dword ptr [edx + ecx]                   # 005075ee
    fxch st(1)                                   # 005075f1
    fsub st, st(1)                               # 005075f3
L_005075f5:
    # block 0x005075f5: entered by jmp at 0x005075de, 1 instruction(s), falls into the block at 0x005075f7
    fstp dword ptr [ecx]                         # 005075f5
L_005075f7:
    # block 0x005075f7: entered by jmp at 0x005075d5; jmp at 0x005075ea, 6 instruction(s), ends with jne to 0x005075ad (backward)
    mov eax, dword ptr [ebp - local_24]          # 005075f7
    add ecx, 0x4                                 # 005075fa
    dec eax                                      # 005075fd
    fstp st(0)                                   # 005075fe
    mov dword ptr [ebp - local_24], eax          # 00507600
    jne.d8 L_005075ad                            # 00507603
L_00507605:
    # block 0x00507605: entered by jle at 0x005075a4; fall-through of jne at 0x00507603, 5 instruction(s), ends with jne to 0x00507592 (backward)
    mov eax, dword ptr [ebp - local_20]          # 00507605
    sub ebx, 0x4                                 # 00507608
    dec eax                                      # 0050760b
    mov dword ptr [ebp - local_20], eax          # 0050760c
    jne.d8 L_00507592                            # 0050760f
L_00507611:
    # block 0x00507611: entered by js at 0x00507577; fall-through of jne at 0x0050760f, 5 instruction(s), ends with jle to 0x0050766a (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00507611
    {load} xor ebx, ebx                          # 00507614
    mov ecx, dword ptr [eax + field_4]           # 00507616
    test ecx, ecx                                # 00507619
    jle.d8 L_0050766a                            # 0050761b
    # block 0x0050761d: entered by fall-through of jle at 0x0050761b, 2 instruction(s), falls into the block at 0x00507623
    mov ecx, dword ptr [ebp + arg_c]             # 0050761d
    lea edi, [ecx + field_4]                     # 00507620
L_00507623:
    # block 0x00507623: entered by jl at 0x00507668, 24 instruction(s), calls indirect dword ptr [ecx + 0x18], ends with jl to 0x00507623 (backward)
    mov eax, dword ptr [edi]                     # 00507623
    mov edx, dword ptr [ebp + arg_c]             # 00507625
    mov ecx, dword ptr [ebp - local_10]          # 00507628
    mov eax, dword ptr [edx + 4*eax + field_404] # 0050762b
    mov edx, dword ptr [ecx + 4*eax + field_320] # 00507632
    mov ecx, dword ptr [4*edx + 0x5669e0]        # 00507639
    mov edx, dword ptr [esi]                     # 00507640
    mov edx, dword ptr [edx + 4*ebx]             # 00507642
    push edx                                     # 00507645
    mov edx, dword ptr [ebp - local_2c]          # 00507646
    mov edx, dword ptr [edx + 4*ebx]             # 00507649
    push edx                                     # 0050764c
    mov edx, dword ptr [ebp - local_8]           # 0050764d
    mov edx, dword ptr [edx + field_30]          # 00507650
    mov eax, dword ptr [edx + 4*eax]             # 00507653
    push eax                                     # 00507656
    push esi                                     # 00507657
    call dword ptr [ecx + field_18]              # 00507658
    mov ecx, dword ptr [ebp + arg_8]             # 0050765b
    add esp, 0x10                                # 0050765e
    inc ebx                                      # 00507661
    add edi, 0x4                                 # 00507662
    cmp ebx, dword ptr [ecx + field_4]           # 00507665
    jl.d8 L_00507623                             # 00507668
L_0050766a:
    # block 0x0050766a: entered by jle at 0x0050761b; fall-through of jl at 0x00507668, 5 instruction(s), ends with jle to 0x0050769b (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0050766a
    {load} xor edi, edi                          # 0050766d
    mov eax, dword ptr [edx + field_4]           # 0050766f
    test eax, eax                                # 00507672
    jle.d8 L_0050769b                            # 00507674
L_00507676:
    # block 0x00507676: entered by jl at 0x00507699; fall-through of jle at 0x00507674, 15 instruction(s), calls FUN_005055c0, ends with jl to 0x00507676 (backward)
    mov eax, dword ptr [esi]                     # 00507676
    mov ecx, dword ptr [esi + field_1c]          # 00507678
    mov edx, dword ptr [ebp - local_8]           # 0050767b
    mov eax, dword ptr [eax + 4*edi]             # 0050767e
    push eax                                     # 00507681
    push eax                                     # 00507682
    mov eax, dword ptr [edx + 4*ecx + field_c]   # 00507683
    mov ecx, dword ptr [eax]                     # 00507687
    push ecx                                     # 00507689
    call FUN_005055c0                            # 0050768a
    mov edx, dword ptr [ebp + arg_8]             # 0050768f
    add esp, 0xc                                 # 00507692
    inc edi                                      # 00507695
    cmp edi, dword ptr [edx + field_4]           # 00507696
    jl.d8 L_00507676                             # 00507699
L_0050769b:
    # block 0x0050769b: entered by jle at 0x00507674; fall-through of jl at 0x00507699, 5 instruction(s), ends with jle to 0x005076ec (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0050769b
    {load} xor ebx, ebx                          # 0050769e
    mov ecx, dword ptr [eax + field_4]           # 005076a0
    test ecx, ecx                                # 005076a3
    jle.d8 L_005076ec                            # 005076a5
L_005076a7:
    # block 0x005076a7: entered by jl at 0x005076ea; fall-through of jle at 0x005076a5, 6 instruction(s), ends with je to 0x005076d8 (forward)
    mov edx, dword ptr [ebp - local_c]           # 005076a7
    mov ecx, dword ptr [esi]                     # 005076aa
    mov eax, dword ptr [edx + 4*ebx]             # 005076ac
    mov edi, dword ptr [ecx + 4*ebx]             # 005076af
    test eax, eax                                # 005076b2
    je.d8 L_005076d8                             # 005076b4
    # block 0x005076b6: entered by fall-through of je at 0x005076b4, 15 instruction(s), calls FUN_00505260, ends with forward jump to 0x005076e3
    mov eax, dword ptr [esi + field_20]          # 005076b6
    mov ecx, dword ptr [esi + field_1c]          # 005076b9
    mov edx, dword ptr [esi + field_18]          # 005076bc
    push eax                                     # 005076bf
    mov eax, dword ptr [ebp - local_10]          # 005076c0
    push ecx                                     # 005076c3
    mov ecx, dword ptr [ebp - local_8]           # 005076c4
    push edx                                     # 005076c7
    add ecx, 0x4                                 # 005076c8
    push eax                                     # 005076cb
    push ecx                                     # 005076cc
    push edi                                     # 005076cd
    call FUN_00505260                            # 005076ce
    add esp, 0x18                                # 005076d3
    jmp.d8 L_005076e3                            # 005076d6
L_005076d8:
    # block 0x005076d8: entered by je at 0x005076b4, 3 instruction(s), ends with jle to 0x005076e3 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 005076d8
    test ecx, ecx                                # 005076db
    jle.d8 L_005076e3                            # 005076dd
    # block 0x005076df: entered by fall-through of jle at 0x005076dd, 2 instruction(s), falls into the block at 0x005076e3
    {load} xor eax, eax                          # 005076df
    rep stosd dword ptr es:[edi], eax            # 005076e1
L_005076e3:
    # block 0x005076e3: entered by jmp at 0x005076d6; jle at 0x005076dd, 4 instruction(s), ends with jl to 0x005076a7 (backward)
    mov edx, dword ptr [ebp + arg_8]             # 005076e3
    inc ebx                                      # 005076e6
    cmp ebx, dword ptr [edx + field_4]           # 005076e7
    jl.d8 L_005076a7                             # 005076ea
L_005076ec:
    # block 0x005076ec: entered by jle at 0x005076a5; fall-through of jl at 0x005076ea, 8 instruction(s), ends with ret
    lea esp, [ebp - local_38]                    # 005076ec
    {load} xor eax, eax                          # 005076ef
    pop edi                                      # 005076f1
    pop esi                                      # 005076f2
    pop ebx                                      # 005076f3
    {load} mov esp, ebp                          # 005076f4
    pop ebp                                      # 005076f6
    ret                                          # 005076f7

# --- data items (not part of the function) -------------------------
.org 0x005076f8 - 0x401000
PAD_005076f8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

