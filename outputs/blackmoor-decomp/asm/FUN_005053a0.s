# FUN_005053a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005053a0
# extent:       0x005053a0-0x00505575 (469 code bytes)
# span:         0x005053a0-0x00505580 (code 469, tables 0, padding 11)
# sha256:       3d41663be3f7b49d0125b0a7fab9bc672df19cae7850f26d3abbaca6b00662c4
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005053a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4, field_minus_8; [ebp + n] field_minus_4, field_minus_8; [ecx + n] field_4, field_8, field_c, field_minus_4, field_minus_8; [edi + n] field_minus_4, field_minus_8; [edx + n] field_10; [esi + n] field_minus_1, field_minus_2; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_24, stk_28, stk_30
# callees:      calls FUN_0050ea90, FUN_0050e19e, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 161 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x005053a0 - 0x401000
.globl FUN_005053a0
FUN_005053a0:
    # block 0x005053a0: entry, 46 instruction(s), calls FUN_0050ea90, FUN_0050e19e, FUN_0050ce04, ends with jle to 0x005054a0 (forward)
    sub esp, 0x10                                # 005053a0
    push ebx                                     # 005053a3
    push ebp                                     # 005053a4
    push esi                                     # 005053a5
    push edi                                     # 005053a6
    mov edi, dword ptr [esp + stk_28]            # 005053a7
    {load} mov eax, edi                          # 005053ab
    cdq                                          # 005053ad
    and edx, 0x3                                 # 005053ae
    {load} add eax, edx                          # 005053b1
    {load} mov esi, eax                          # 005053b3
    sar esi, 0x2                                 # 005053b5
    lea eax, [4*esi]                             # 005053b8
    push eax                                     # 005053bf
    call FUN_0050ea90                            # 005053c0
    lea ecx, [esi + edi]                         # 005053c5
    mov dword ptr [esp + stk_1c], eax            # 005053c8
    shl ecx, 0x2                                 # 005053cc
    push ecx                                     # 005053cf
    call FUN_0050ea90                            # 005053d0
    fild dword ptr [esp + stk_30]                # 005053d5
    {load} mov ebx, edi                          # 005053d9
    {load} mov ebp, eax                          # 005053db
    sar ebx                                      # 005053dd
    fst dword ptr [esp + stk_30]                 # 005053df
    fldln2                                       # 005053e3
    fxch st(1)                                   # 005053e5
    fyl2x                                        # 005053e7
    fldln2                                       # 005053e9
    fld qword ptr [0x52c678]                     # 005053eb
    fyl2x                                        # 005053f1
    fdivp st(1), st                              # 005053f3
    fadd qword ptr [0x52cac0]                    # 005053f5
    fstp qword ptr [esp]                         # 005053fb
    call FUN_0050e19e                            # 005053fe
    add esp, 0x8                                 # 00505403
    call FUN_0050ce04                            # 00505406
    mov ecx, dword ptr [esp + stk_24]            # 0050540b
    mov edx, dword ptr [esp + stk_18]            # 0050540f
    test esi, esi                                # 00505413
    mov dword ptr [esp + stk_1c], eax            # 00505415
    mov dword ptr [ecx + field_4], eax           # 00505419
    mov dword ptr [ecx], edi                     # 0050541c
    mov dword ptr [ecx + field_8], ebp           # 0050541e
    mov dword ptr [ecx + field_c], edx           # 00505421
    jle.d8 L_005054a0                            # 00505424
    # block 0x00505426: entered by fall-through of jle at 0x00505424, 10 instruction(s), falls into the block at 0x00505457
    fld dword ptr [0x52e624]                     # 00505426
    fdiv dword ptr [esp + stk_28]                # 0050542c
    lea eax, [edi + edi]                         # 00505430
    mov dword ptr [esp + stk_10], 0x0            # 00505433
    mov dword ptr [esp + stk_14], eax            # 0050543b
    {load} mov eax, ebp                          # 0050543f
    {disp8} lea ecx, [ebp + 4*ebx]               # 00505441
    fild dword ptr [esp + stk_14]                # 00505445
    mov dword ptr [esp + stk_14], 0x1            # 00505449
    fdivr dword ptr [0x52e624]                   # 00505451
L_00505457:
    # block 0x00505457: entered by jne at 0x0050549a, 25 instruction(s), ends with jne to 0x00505457 (backward)
    fild dword ptr [esp + stk_10]                # 00505457
    mov edx, dword ptr [esp + stk_10]            # 0050545b
    mov ebx, dword ptr [esp + stk_14]            # 0050545f
    add edx, 0x4                                 # 00505463
    add eax, 0x8                                 # 00505466
    fmul st, st(2)                               # 00505469
    add ecx, 0x8                                 # 0050546b
    add ebx, 0x2                                 # 0050546e
    dec esi                                      # 00505471
    mov dword ptr [esp + stk_10], edx            # 00505472
    fld st(0)                                    # 00505476
    fcos                                         # 00505478
    fstp dword ptr [eax - field_minus_8]         # 0050547a
    fsin                                         # 0050547d
    fchs                                         # 0050547f
    fstp dword ptr [eax - field_minus_4]         # 00505481
    fild dword ptr [esp + stk_14]                # 00505484
    mov dword ptr [esp + stk_14], ebx            # 00505488
    fmul st, st(1)                               # 0050548c
    fld st(0)                                    # 0050548e
    fcos                                         # 00505490
    fstp dword ptr [ecx - field_minus_8]         # 00505492
    fsin                                         # 00505495
    fstp dword ptr [ecx - field_minus_4]         # 00505497
    jne.d8 L_00505457                            # 0050549a
    # block 0x0050549c: entered by fall-through of jne at 0x0050549a, 2 instruction(s), falls into the block at 0x005054a0
    fstp st(0)                                   # 0050549c
    fstp st(0)                                   # 0050549e
L_005054a0:
    # block 0x005054a0: entered by jle at 0x00505424, 8 instruction(s), ends with jle to 0x005054fc (forward)
    {load} mov eax, edi                          # 005054a0
    cdq                                          # 005054a2
    and edx, 0x7                                 # 005054a3
    {load} add edx, eax                          # 005054a6
    sar edx, 0x3                                 # 005054a8
    test edx, edx                                # 005054ab
    mov dword ptr [esp + stk_10], edx            # 005054ad
    jle.d8 L_005054fc                            # 005054b1
    # block 0x005054b3: entered by fall-through of jle at 0x005054b1, 5 instruction(s), falls into the block at 0x005054cb
    fld dword ptr [0x52e624]                     # 005054b3
    fdiv dword ptr [esp + stk_28]                # 005054b9
    mov dword ptr [esp + stk_14], 0x2            # 005054bd
    {disp8} lea edi, [ebp + 4*edi]               # 005054c5
    {load} mov ecx, edx                          # 005054c9
L_005054cb:
    # block 0x005054cb: entered by jne at 0x005054f8, 15 instruction(s), ends with jne to 0x005054cb (backward)
    fild dword ptr [esp + stk_14]                # 005054cb
    mov ebx, dword ptr [esp + stk_14]            # 005054cf
    add edi, 0x8                                 # 005054d3
    add ebx, 0x4                                 # 005054d6
    dec ecx                                      # 005054d9
    fmul st, st(1)                               # 005054da
    mov dword ptr [esp + stk_14], ebx            # 005054dc
    fld st(0)                                    # 005054e0
    fcos                                         # 005054e2
    fmul qword ptr [0x52cac0]                    # 005054e4
    fstp dword ptr [edi - field_minus_8]         # 005054ea
    fsin                                         # 005054ed
    fmul qword ptr [0x52e630]                    # 005054ef
    fstp dword ptr [edi - field_minus_4]         # 005054f5
    jne.d8 L_005054cb                            # 005054f8
    # block 0x005054fa: entered by fall-through of jne at 0x005054f8, 1 instruction(s), falls into the block at 0x005054fc
    fstp st(0)                                   # 005054fa
L_005054fc:
    # block 0x005054fc: entered by jle at 0x005054b1, 11 instruction(s), ends with jle to 0x0050555c (forward)
    mov esi, dword ptr [esp + stk_1c]            # 005054fc
    mov eax, 0x1                                 # 00505500
    {load} xor ebx, ebx                          # 00505505
    lea ecx, [esi - field_minus_1]               # 00505507
    shl eax, cl                                  # 0050550a
    lea ecx, [esi - field_minus_2]               # 0050550c
    mov esi, 0x1                                 # 0050550f
    shl esi, cl                                  # 00505514
    dec eax                                      # 00505516
    test edx, edx                                # 00505517
    jle.d8 L_0050555c                            # 00505519
    # block 0x0050551b: entered by fall-through of jle at 0x00505519, 2 instruction(s), falls into the block at 0x00505523
    mov ebp, dword ptr [esp + stk_18]            # 0050551b
    mov dword ptr [esp + stk_1c], esi            # 0050551f
L_00505523:
    # block 0x00505523: entered by jl at 0x0050555a, 4 instruction(s), ends with je to 0x00505547 (forward)
    {load} xor edi, edi                          # 00505523
    {load} xor ecx, ecx                          # 00505525
    test esi, esi                                # 00505527
    je.d8 L_00505547                             # 00505529
    # block 0x0050552b: entered by fall-through of je at 0x00505529, 1 instruction(s), falls into the block at 0x0050552d
    {load} mov edx, esi                          # 0050552b
L_0050552d:
    # block 0x0050552d: entered by jne at 0x00505541, 2 instruction(s), ends with je to 0x0050553a (forward)
    test ebx, edx                                # 0050552d
    je.d8 L_0050553a                             # 0050552f
    # block 0x00505531: entered by fall-through of je at 0x0050552f, 3 instruction(s), falls into the block at 0x0050553a
    mov edx, 0x1                                 # 00505531
    shl edx, cl                                  # 00505536
    {load} or edi, edx                           # 00505538
L_0050553a:
    # block 0x0050553a: entered by je at 0x0050552f, 5 instruction(s), ends with jne to 0x0050552d (backward)
    inc ecx                                      # 0050553a
    {load} mov edx, esi                          # 0050553b
    sar edx, cl                                  # 0050553d
    test edx, edx                                # 0050553f
    jne.d8 L_0050552d                            # 00505541
    # block 0x00505543: entered by fall-through of jne at 0x00505541, 1 instruction(s), falls into the block at 0x00505547
    mov edx, dword ptr [esp + stk_10]            # 00505543
L_00505547:
    # block 0x00505547: entered by je at 0x00505529, 10 instruction(s), ends with jl to 0x00505523 (backward)
    {load} mov ecx, edi                          # 00505547
    add ebp, 0x8                                 # 00505549
    not ecx                                      # 0050554c
    {load} and ecx, eax                          # 0050554e
    dec ecx                                      # 00505550
    inc ebx                                      # 00505551
    mov dword ptr [ebp - field_minus_8], ecx     # 00505552
    mov dword ptr [ebp - field_minus_4], edi     # 00505555
    {load} cmp ebx, edx                          # 00505558
    jl.d8 L_00505523                             # 0050555a
L_0050555c:
    # block 0x0050555c: entered by jle at 0x00505519; fall-through of jl at 0x0050555a, 10 instruction(s), ends with ret
    fld dword ptr [0x52e628]                     # 0050555c
    fdiv dword ptr [esp + stk_28]                # 00505562
    mov edx, dword ptr [esp + stk_24]            # 00505566
    pop edi                                      # 0050556a
    pop esi                                      # 0050556b
    pop ebp                                      # 0050556c
    pop ebx                                      # 0050556d
    fstp dword ptr [edx + field_10]              # 0050556e
    add esp, 0x10                                # 00505571
    ret                                          # 00505574

# --- data items (not part of the function) -------------------------
.org 0x00505575 - 0x401000
PAD_00505575:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

