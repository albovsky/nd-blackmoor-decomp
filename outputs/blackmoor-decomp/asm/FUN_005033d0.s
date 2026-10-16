# FUN_005033d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005033d0
# extent:       0x005033d0-0x00503740 (880 code bytes)
# span:         0x005033d0-0x00503760 (code 880, tables 32, padding 0)
# sha256:       3bac0ced680998ade8609541f1bbd07efbcf10000effbcbfde5c6d7f9c79e08b
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005031d0 (+0x200)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005033d0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_1, field_minus_4; [ebp + n] field_minus_1; [ebx + n] field_8, field_10, field_14, field_1c, field_20, field_24, field_28; [ecx + n] field_14, field_minus_1; [edx + n] field_1c; [esi + n] field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28
# callees:      calls FUN_0050bd80, FUN_0050be30, FUN_00502da0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 322 instruction(s), 28 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050bd80, .text + (0x0050bd80 - 0x401000)
.set FUN_0050be30, .text + (0x0050be30 - 0x401000)

.org 0x005033d0 - 0x401000
.globl FUN_005033d0
FUN_005033d0:
    # block 0x005033d0: entry, 9 instruction(s), ends with jle to 0x00503553 (forward)
    sub esp, 0x8                                 # 005033d0
    push ebx                                     # 005033d3
    mov ebx, dword ptr [esp + stk_10]            # 005033d4
    push ebp                                     # 005033d8
    push esi                                     # 005033d9
    mov eax, dword ptr [ebx]                     # 005033da
    push edi                                     # 005033dc
    cmp eax, 0x8                                 # 005033dd
    jle.d32 L_00503553                           # 005033e0
    # block 0x005033e6: entered by fall-through of jle at 0x005033e0, 5 instruction(s), ends with jle to 0x00503736 (forward)
    mov eax, dword ptr [esp + stk_28]            # 005033e6
    {load} xor edi, edi                          # 005033ea
    test eax, eax                                # 005033ec
    mov dword ptr [esp + stk_10], edi            # 005033ee
    jle.d32 L_00503736                           # 005033f2
L_005033f8:
    # block 0x005033f8: entered by jmp at 0x00503535; fall-through of jle at 0x005033f2, 10 instruction(s), calls FUN_0050bd80, ends with jl to 0x00503454 (forward)
    mov ecx, dword ptr [ebx + field_24]          # 005033f8
    mov esi, dword ptr [esp + stk_24]            # 005033fb
    mov eax, dword ptr [ebx + field_28]          # 005033ff
    push ecx                                     # 00503402
    push esi                                     # 00503403
    mov dword ptr [esp + stk_24], eax            # 00503404
    call FUN_0050bd80                            # 00503408
    add esp, 0x8                                 # 0050340d
    test eax, eax                                # 00503410
    jl.d8 L_00503454                             # 00503412
    # block 0x00503414: entered by fall-through of jl at 0x00503412, 4 instruction(s), ends with je to 0x0050343a (forward)
    mov edx, dword ptr [ebx + field_20]          # 00503414
    mov ebp, dword ptr [edx + 4*eax]             # 00503417
    test ebp, 0x80000000                         # 0050341a
    je.d8 L_0050343a                             # 00503420
    # block 0x00503422: entered by fall-through of je at 0x00503420, 7 instruction(s), ends with forward jump to 0x00503459
    mov edi, dword ptr [ebx + field_8]           # 00503422
    {load} mov esi, ebp                          # 00503425
    sar esi, 0xf                                 # 00503427
    and ebp, 0x7fff                              # 0050342a
    and esi, 0x7fff                              # 00503430
    {load} sub edi, ebp                          # 00503436
    jmp.d8 L_00503459                            # 00503438
L_0050343a:
    # block 0x0050343a: entered by je at 0x00503420, 8 instruction(s), calls FUN_0050be30, ends with forward jump to 0x005034f1
    mov eax, dword ptr [ebx + field_1c]          # 0050343a
    movsx ecx, byte ptr [eax + ebp - field_minus_1] # 0050343d
    push ecx                                     # 00503442
    push esi                                     # 00503443
    call FUN_0050be30                            # 00503444
    add esp, 0x8                                 # 00503449
    lea esi, [ebp - field_minus_1]               # 0050344c
    jmp.d32 L_005034f1                           # 0050344f
L_00503454:
    # block 0x00503454: entered by jl at 0x00503412, 2 instruction(s), falls into the block at 0x00503459
    mov edi, dword ptr [ebx + field_8]           # 00503454
    {load} xor esi, esi                          # 00503457
L_00503459:
    # block 0x00503459: entered by jmp at 0x00503438, 8 instruction(s), calls FUN_0050bd80, ends with jge to 0x00503499 (forward)
    mov ebp, dword ptr [esp + stk_1c]            # 00503459
    mov edx, dword ptr [esp + stk_24]            # 0050345d
    push ebp                                     # 00503461
    push edx                                     # 00503462
    call FUN_0050bd80                            # 00503463
    add esp, 0x8                                 # 00503468
    test eax, eax                                # 0050346b
    jge.d8 L_00503499                            # 0050346d
L_0050346f:
    # block 0x0050346f: entered by jl at 0x00503485; fall-through of jge at 0x0050346d, 2 instruction(s), ends with jle to 0x0050348d (forward)
    cmp ebp, 0x1                                 # 0050346f
    jle.d8 L_0050348d                            # 00503472
    # block 0x00503474: entered by fall-through of jle at 0x00503472, 8 instruction(s), calls FUN_0050bd80, ends with jl to 0x0050346f (backward)
    mov eax, dword ptr [esp + stk_24]            # 00503474
    dec ebp                                      # 00503478
    push ebp                                     # 00503479
    push eax                                     # 0050347a
    call FUN_0050bd80                            # 0050347b
    add esp, 0x8                                 # 00503480
    test eax, eax                                # 00503483
    jl.d8 L_0050346f                             # 00503485
    # block 0x00503487: entered by fall-through of jl at 0x00503485, 2 instruction(s), ends with forward jump to 0x00503499
    mov dword ptr [esp + stk_1c], ebp            # 00503487
    jmp.d8 L_00503499                            # 0050348b
L_0050348d:
    # block 0x0050348d: entered by jle at 0x00503472, 3 instruction(s), ends with jl to 0x0050372b (forward)
    test eax, eax                                # 0050348d
    mov dword ptr [esp + stk_1c], ebp            # 0050348f
    jl.d32 L_0050372b                            # 00503493
L_00503499:
    # block 0x00503499: entered by jge at 0x0050346d; jmp at 0x0050348b; fall-through of jl at 0x00503493, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x005034d4 (forward)
    push eax                                     # 00503499
    call FUN_00502da0                            # 0050349a
    {load} mov edx, edi                          # 0050349f
    add esp, 0x4                                 # 005034a1
    {load} sub edx, esi                          # 005034a4
    cmp edx, 0x1                                 # 005034a6
    jle.d8 L_005034d4                            # 005034a9
L_005034ab:
    # block 0x005034ab: entered by jg at 0x005034ce; fall-through of jle at 0x005034a9, 16 instruction(s), ends with jg to 0x005034ab (backward)
    mov ecx, dword ptr [ebx + field_14]          # 005034ab
    sar edx                                      # 005034ae
    lea ebp, [edx + esi]                         # 005034b0
    cmp eax, dword ptr [ecx + 4*ebp]             # 005034b3
    {load} sbb ecx, ecx                          # 005034b6
    neg ecx                                      # 005034b8
    lea ebp, [ecx - field_minus_1]               # 005034ba
    neg ecx                                      # 005034bd
    {load} and ecx, edx                          # 005034bf
    {load} and ebp, edx                          # 005034c1
    {load} sub edi, ecx                          # 005034c3
    {load} add esi, ebp                          # 005034c5
    {load} mov edx, edi                          # 005034c7
    {load} sub edx, esi                          # 005034c9
    cmp edx, 0x1                                 # 005034cb
    jg.d8 L_005034ab                             # 005034ce
    # block 0x005034d0: entered by fall-through of jg at 0x005034ce, 1 instruction(s), falls into the block at 0x005034d4
    mov ebp, dword ptr [esp + stk_1c]            # 005034d0
L_005034d4:
    # block 0x005034d4: entered by jle at 0x005034a9, 4 instruction(s), ends with jg to 0x0050353a (forward)
    mov ecx, dword ptr [ebx + field_1c]          # 005034d4
    movsx eax, byte ptr [ecx + esi]              # 005034d7
    {load} cmp eax, ebp                          # 005034db
    jg.d8 L_0050353a                             # 005034dd
    # block 0x005034df: entered by fall-through of jg at 0x005034dd, 6 instruction(s), calls FUN_0050be30, falls into the block at 0x005034f1
    mov edx, dword ptr [esp + stk_24]            # 005034df
    push eax                                     # 005034e3
    push edx                                     # 005034e4
    call FUN_0050be30                            # 005034e5
    mov edi, dword ptr [esp + stk_18]            # 005034ea
    add esp, 0x8                                 # 005034ee
L_005034f1:
    # block 0x005034f1: entered by jmp at 0x0050344f, 2 instruction(s), ends with je to 0x0050372b (forward)
    cmp esi, -0x1                                # 005034f1
    je.d32 L_0050372b                            # 005034f4
    # block 0x005034fa: entered by fall-through of je at 0x005034f4, 8 instruction(s), ends with jle to 0x0050352b (forward)
    mov eax, dword ptr [ebx]                     # 005034fa
    mov edx, dword ptr [ebx + field_10]          # 005034fc
    {load} mov ecx, eax                          # 005034ff
    imul ecx, esi                                # 00503501
    lea ecx, [edx + 4*ecx]                       # 00503504
    {load} xor edx, edx                          # 00503507
    test eax, eax                                # 00503509
    jle.d8 L_0050352b                            # 0050350b
    # block 0x0050350d: entered by fall-through of jle at 0x0050350b, 2 instruction(s), falls into the block at 0x00503514
    mov eax, dword ptr [esp + stk_20]            # 0050350d
    lea eax, [eax + 4*edi]                       # 00503511
L_00503514:
    # block 0x00503514: entered by jl at 0x00503525, 9 instruction(s), ends with jl to 0x00503514 (backward)
    fld dword ptr [ecx]                          # 00503514
    fadd dword ptr [eax]                         # 00503516
    inc edx                                      # 00503518
    add ecx, 0x4                                 # 00503519
    inc edi                                      # 0050351c
    add eax, 0x4                                 # 0050351d
    fstp dword ptr [eax - field_minus_4]         # 00503520
    cmp edx, dword ptr [ebx]                     # 00503523
    jl.d8 L_00503514                             # 00503525
    # block 0x00503527: entered by fall-through of jl at 0x00503525, 1 instruction(s), falls into the block at 0x0050352b
    mov dword ptr [esp + stk_10], edi            # 00503527
L_0050352b:
    # block 0x0050352b: entered by jle at 0x0050350b, 2 instruction(s), ends with jge to 0x00503736 (forward)
    cmp edi, dword ptr [esp + stk_28]            # 0050352b
    jge.d32 L_00503736                           # 0050352f
    # block 0x00503535: entered by fall-through of jge at 0x0050352f, 1 instruction(s), ends with backward jump to 0x005033f8
    jmp.d32 L_005033f8                           # 00503535
L_0050353a:
    # block 0x0050353a: entered by jg at 0x005034dd, 12 instruction(s), calls FUN_0050be30, ends with ret
    mov ecx, dword ptr [esp + stk_24]            # 0050353a
    push ebp                                     # 0050353e
    push ecx                                     # 0050353f
    call FUN_0050be30                            # 00503540
    add esp, 0x8                                 # 00503545
    or eax, -0x1                                 # 00503548
    pop edi                                      # 0050354b
    pop esi                                      # 0050354c
    pop ebp                                      # 0050354d
    pop ebx                                      # 0050354e
    add esp, 0x8                                 # 0050354f
    ret                                          # 00503552
L_00503553:
    # block 0x00503553: entered by jle at 0x005033e0, 5 instruction(s), ends with jle to 0x00503736 (forward)
    mov eax, dword ptr [esp + stk_28]            # 00503553
    {load} xor edi, edi                          # 00503557
    test eax, eax                                # 00503559
    mov dword ptr [esp + stk_10], edi            # 0050355b
    jle.d32 L_00503736                           # 0050355f
    # block 0x00503565: entered by fall-through of jle at 0x0050355f, 1 instruction(s), falls into the block at 0x00503569
    mov esi, dword ptr [esp + stk_20]            # 00503565
L_00503569:
    # block 0x00503569: entered by jmp at 0x00503718, 10 instruction(s), calls FUN_0050bd80, ends with jl to 0x005035c7 (forward)
    mov eax, dword ptr [ebx + field_24]          # 00503569
    mov ecx, dword ptr [esp + stk_24]            # 0050356c
    mov edx, dword ptr [ebx + field_28]          # 00503570
    push eax                                     # 00503573
    push ecx                                     # 00503574
    mov dword ptr [esp + stk_28], edx            # 00503575
    call FUN_0050bd80                            # 00503579
    add esp, 0x8                                 # 0050357e
    test eax, eax                                # 00503581
    jl.d8 L_005035c7                             # 00503583
    # block 0x00503585: entered by fall-through of jl at 0x00503583, 4 instruction(s), ends with je to 0x005035ab (forward)
    mov edx, dword ptr [ebx + field_20]          # 00503585
    mov ebp, dword ptr [edx + 4*eax]             # 00503588
    test ebp, 0x80000000                         # 0050358b
    je.d8 L_005035ab                             # 00503591
    # block 0x00503593: entered by fall-through of je at 0x00503591, 7 instruction(s), ends with forward jump to 0x005035cc
    mov ebx, dword ptr [ebx + field_8]           # 00503593
    {load} mov edi, ebp                          # 00503596
    sar edi, 0xf                                 # 00503598
    and ebp, 0x7fff                              # 0050359b
    and edi, 0x7fff                              # 005035a1
    {load} sub ebx, ebp                          # 005035a7
    jmp.d8 L_005035cc                            # 005035a9
L_005035ab:
    # block 0x005035ab: entered by je at 0x00503591, 9 instruction(s), calls FUN_0050be30, ends with forward jump to 0x0050367f
    mov eax, dword ptr [ebx + field_1c]          # 005035ab
    mov edx, dword ptr [esp + stk_24]            # 005035ae
    movsx ecx, byte ptr [eax + ebp - field_minus_1] # 005035b2
    push ecx                                     # 005035b7
    push edx                                     # 005035b8
    call FUN_0050be30                            # 005035b9
    add esp, 0x8                                 # 005035be
    dec ebp                                      # 005035c1
    jmp.d32 L_0050367f                           # 005035c2
L_005035c7:
    # block 0x005035c7: entered by jl at 0x00503583, 2 instruction(s), falls into the block at 0x005035cc
    mov ebx, dword ptr [ebx + field_8]           # 005035c7
    {load} xor edi, edi                          # 005035ca
L_005035cc:
    # block 0x005035cc: entered by jmp at 0x005035a9, 8 instruction(s), calls FUN_0050bd80, ends with jge to 0x0050360c (forward)
    mov ebp, dword ptr [esp + stk_20]            # 005035cc
    mov eax, dword ptr [esp + stk_24]            # 005035d0
    push ebp                                     # 005035d4
    push eax                                     # 005035d5
    call FUN_0050bd80                            # 005035d6
    add esp, 0x8                                 # 005035db
    test eax, eax                                # 005035de
    jge.d8 L_0050360c                            # 005035e0
L_005035e2:
    # block 0x005035e2: entered by jl at 0x005035f8; fall-through of jge at 0x005035e0, 2 instruction(s), ends with jle to 0x00503600 (forward)
    cmp ebp, 0x1                                 # 005035e2
    jle.d8 L_00503600                            # 005035e5
    # block 0x005035e7: entered by fall-through of jle at 0x005035e5, 8 instruction(s), calls FUN_0050bd80, ends with jl to 0x005035e2 (backward)
    mov ecx, dword ptr [esp + stk_24]            # 005035e7
    dec ebp                                      # 005035eb
    push ebp                                     # 005035ec
    push ecx                                     # 005035ed
    call FUN_0050bd80                            # 005035ee
    add esp, 0x8                                 # 005035f3
    test eax, eax                                # 005035f6
    jl.d8 L_005035e2                             # 005035f8
    # block 0x005035fa: entered by fall-through of jl at 0x005035f8, 2 instruction(s), ends with forward jump to 0x0050360c
    mov dword ptr [esp + stk_20], ebp            # 005035fa
    jmp.d8 L_0050360c                            # 005035fe
L_00503600:
    # block 0x00503600: entered by jle at 0x005035e5, 3 instruction(s), ends with jl to 0x0050372b (forward)
    test eax, eax                                # 00503600
    mov dword ptr [esp + stk_20], ebp            # 00503602
    jl.d32 L_0050372b                            # 00503606
L_0050360c:
    # block 0x0050360c: entered by jge at 0x005035e0; jmp at 0x005035fe; fall-through of jl at 0x00503606, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x00503654 (forward)
    push eax                                     # 0050360c
    call FUN_00502da0                            # 0050360d
    {load} mov edx, ebx                          # 00503612
    add esp, 0x4                                 # 00503614
    {load} sub edx, edi                          # 00503617
    cmp edx, 0x1                                 # 00503619
    jle.d8 L_00503654                            # 0050361c
    # block 0x0050361e: entered by fall-through of jle at 0x0050361c, 3 instruction(s), falls into the block at 0x00503629
    mov ecx, dword ptr [esp + stk_1c]            # 0050361e
    mov ecx, dword ptr [ecx + field_14]          # 00503622
    mov dword ptr [esp + stk_14], ecx            # 00503625
L_00503629:
    # block 0x00503629: entered by jg at 0x0050364e, 16 instruction(s), ends with jg to 0x00503629 (backward)
    mov ebp, dword ptr [esp + stk_14]            # 00503629
    sar edx                                      # 0050362d
    lea ecx, [edx + edi]                         # 0050362f
    {disp8} cmp eax, dword ptr [ebp + 4*ecx]     # 00503632
    {load} sbb ecx, ecx                          # 00503636
    neg ecx                                      # 00503638
    lea ebp, [ecx - field_minus_1]               # 0050363a
    neg ecx                                      # 0050363d
    {load} and ecx, edx                          # 0050363f
    {load} and ebp, edx                          # 00503641
    {load} sub ebx, ecx                          # 00503643
    {load} add edi, ebp                          # 00503645
    {load} mov edx, ebx                          # 00503647
    {load} sub edx, edi                          # 00503649
    cmp edx, 0x1                                 # 0050364b
    jg.d8 L_00503629                             # 0050364e
    # block 0x00503650: entered by fall-through of jg at 0x0050364e, 1 instruction(s), falls into the block at 0x00503654
    mov ebp, dword ptr [esp + stk_20]            # 00503650
L_00503654:
    # block 0x00503654: entered by jle at 0x0050361c, 5 instruction(s), ends with jg to 0x0050371d (forward)
    mov edx, dword ptr [esp + stk_1c]            # 00503654
    mov eax, dword ptr [edx + field_1c]          # 00503658
    movsx eax, byte ptr [eax + edi]              # 0050365b
    {load} cmp eax, ebp                          # 0050365f
    jg.d32 L_0050371d                            # 00503661
    # block 0x00503667: entered by fall-through of jg at 0x00503661, 8 instruction(s), calls FUN_0050be30, falls into the block at 0x0050367f
    mov ecx, dword ptr [esp + stk_24]            # 00503667
    push eax                                     # 0050366b
    push ecx                                     # 0050366c
    call FUN_0050be30                            # 0050366d
    mov ebx, dword ptr [esp + stk_24]            # 00503672
    {load} mov ebp, edi                          # 00503676
    mov edi, dword ptr [esp + stk_18]            # 00503678
    add esp, 0x8                                 # 0050367c
L_0050367f:
    # block 0x0050367f: entered by jmp at 0x005035c2, 2 instruction(s), ends with je to 0x0050372b (forward)
    cmp ebp, -0x1                                # 0050367f
    je.d32 L_0050372b                            # 00503682
    # block 0x00503688: entered by fall-through of je at 0x00503682, 9 instruction(s), ends with ja to 0x00503712 (forward)
    mov edx, dword ptr [ebx]                     # 00503688
    mov ecx, dword ptr [ebx + field_10]          # 0050368a
    {load} mov eax, edx                          # 0050368d
    imul eax, ebp                                # 0050368f
    lea ecx, [ecx + 4*eax]                       # 00503692
    {load} xor eax, eax                          # 00503695
    dec edx                                      # 00503697
    cmp edx, 0x7                                 # 00503698
    ja.d8 L_00503712                             # 0050369b
    # block 0x0050369d: entered by fall-through of ja at 0x0050369b, 1 instruction(s), ends with indirect jump dword ptr [4*edx + 0x503740]
    jmp dword ptr [4*edx + SWTAB_00503740_VA]    # 0050369d
L_005036a4:
    # block 0x005036a4: entered by switch case, 6 instruction(s), falls into the block at 0x005036b4
    fld dword ptr [ecx]                          # 005036a4
    fadd dword ptr [esi]                         # 005036a6
    inc edi                                      # 005036a8
    mov eax, 0x1                                 # 005036a9
    add esi, 0x4                                 # 005036ae
    fstp dword ptr [esi - field_minus_4]         # 005036b1
L_005036b4:
    # block 0x005036b4: entered by switch case, 6 instruction(s), falls into the block at 0x005036c1
    fld dword ptr [ecx + 4*eax]                  # 005036b4
    fadd dword ptr [esi]                         # 005036b7
    inc eax                                      # 005036b9
    inc edi                                      # 005036ba
    add esi, 0x4                                 # 005036bb
    fstp dword ptr [esi - field_minus_4]         # 005036be
L_005036c1:
    # block 0x005036c1: entered by switch case, 6 instruction(s), falls into the block at 0x005036ce
    fld dword ptr [ecx + 4*eax]                  # 005036c1
    fadd dword ptr [esi]                         # 005036c4
    inc eax                                      # 005036c6
    inc edi                                      # 005036c7
    add esi, 0x4                                 # 005036c8
    fstp dword ptr [esi - field_minus_4]         # 005036cb
L_005036ce:
    # block 0x005036ce: entered by switch case, 6 instruction(s), falls into the block at 0x005036db
    fld dword ptr [ecx + 4*eax]                  # 005036ce
    fadd dword ptr [esi]                         # 005036d1
    inc eax                                      # 005036d3
    inc edi                                      # 005036d4
    add esi, 0x4                                 # 005036d5
    fstp dword ptr [esi - field_minus_4]         # 005036d8
L_005036db:
    # block 0x005036db: entered by switch case, 6 instruction(s), falls into the block at 0x005036e8
    fld dword ptr [ecx + 4*eax]                  # 005036db
    fadd dword ptr [esi]                         # 005036de
    inc eax                                      # 005036e0
    inc edi                                      # 005036e1
    add esi, 0x4                                 # 005036e2
    fstp dword ptr [esi - field_minus_4]         # 005036e5
L_005036e8:
    # block 0x005036e8: entered by switch case, 6 instruction(s), falls into the block at 0x005036f5
    fld dword ptr [ecx + 4*eax]                  # 005036e8
    fadd dword ptr [esi]                         # 005036eb
    inc eax                                      # 005036ed
    inc edi                                      # 005036ee
    add esi, 0x4                                 # 005036ef
    fstp dword ptr [esi - field_minus_4]         # 005036f2
L_005036f5:
    # block 0x005036f5: entered by switch case, 6 instruction(s), falls into the block at 0x00503702
    fld dword ptr [ecx + 4*eax]                  # 005036f5
    fadd dword ptr [esi]                         # 005036f8
    inc eax                                      # 005036fa
    inc edi                                      # 005036fb
    add esi, 0x4                                 # 005036fc
    fstp dword ptr [esi - field_minus_4]         # 005036ff
L_00503702:
    # block 0x00503702: entered by switch case, 6 instruction(s), falls into the block at 0x00503712
    fld dword ptr [ecx + 4*eax]                  # 00503702
    fadd dword ptr [esi]                         # 00503705
    inc edi                                      # 00503707
    add esi, 0x4                                 # 00503708
    mov dword ptr [esp + stk_10], edi            # 0050370b
    fstp dword ptr [esi - field_minus_4]         # 0050370f
L_00503712:
    # block 0x00503712: entered by ja at 0x0050369b, 2 instruction(s), ends with jge to 0x00503736 (forward)
    cmp edi, dword ptr [esp + stk_28]            # 00503712
    jge.d8 L_00503736                            # 00503716
    # block 0x00503718: entered by fall-through of jge at 0x00503716, 1 instruction(s), ends with backward jump to 0x00503569
    jmp.d32 L_00503569                           # 00503718
L_0050371d:
    # block 0x0050371d: entered by jg at 0x00503661, 5 instruction(s), calls FUN_0050be30, falls into the block at 0x0050372b
    mov edx, dword ptr [esp + stk_24]            # 0050371d
    push ebp                                     # 00503721
    push edx                                     # 00503722
    call FUN_0050be30                            # 00503723
    add esp, 0x8                                 # 00503728
L_0050372b:
    # block 0x0050372b: entered by jl at 0x00503493; je at 0x005034f4; jl at 0x00503606; je at 0x00503682, 7 instruction(s), ends with ret
    pop edi                                      # 0050372b
    pop esi                                      # 0050372c
    pop ebp                                      # 0050372d
    or eax, -0x1                                 # 0050372e
    pop ebx                                      # 00503731
    add esp, 0x8                                 # 00503732
    ret                                          # 00503735
L_00503736:
    # block 0x00503736: entered by jle at 0x005033f2; jge at 0x0050352f; jle at 0x0050355f; jge at 0x00503716, 7 instruction(s), ends with ret
    pop edi                                      # 00503736
    pop esi                                      # 00503737
    pop ebp                                      # 00503738
    {load} xor eax, eax                          # 00503739
    pop ebx                                      # 0050373b
    add esp, 0x8                                 # 0050373c
    ret                                          # 0050373f

# --- data items (not part of the function) -------------------------
.org 0x00503740 - 0x401000
SWTAB_00503740:  # 8 case address(es)
    .long L_00503702 - .text + 0x401000
    .long L_005036f5 - .text + 0x401000
    .long L_005036e8 - .text + 0x401000
    .long L_005036db - .text + 0x401000
    .long L_005036ce - .text + 0x401000
    .long L_005036c1 - .text + 0x401000
    .long L_005036b4 - .text + 0x401000
    .long L_005036a4 - .text + 0x401000
.set SWTAB_00503740_VA, SWTAB_00503740 - .text + 0x401000

