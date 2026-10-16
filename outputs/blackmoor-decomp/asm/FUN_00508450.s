# FUN_00508450
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508450
# extent:       0x00508450-0x0050867a (554 code bytes)
# span:         0x00508450-0x00508680 (code 554, tables 0, padding 6)
# sha256:       8f5f693e8096b4c0bbf0ef3db3a4cdba1d9f1cb8cab3ee827304f98dfce3fd05
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508450
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_614; [ecx + n] field_28; [edi + n] field_minus_100; [edx + n] field_minus_1; [esi + n] field_4, field_8, field_c; [esp + n] stk_c, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38 and 3 more
# callees:      calls FUN_004fee30, FUN_0050e19e, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 177 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508680
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_100, 0x100  # offset -0x100
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ field_614, 0x614  # offset +0x614

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)

.org 0x00508450 - 0x401000
.globl FUN_00508450
FUN_00508450:
    # block 0x00508450: entry, 33 instruction(s), calls FUN_004fee30, ends with jle to 0x0050850b (forward)
    push ebp                                     # 00508450
    {load} mov ebp, esp                          # 00508451
    and esp, -0x8                                # 00508453
    sub esp, 0x3c                                # 00508456
    mov eax, dword ptr [ebp + arg_c]             # 00508459
    push ebx                                     # 0050845c
    push esi                                     # 0050845d
    push edi                                     # 0050845e
    mov esi, dword ptr [eax]                     # 0050845f
    mov ebx, dword ptr [ebp + arg_14]            # 00508461
    mov dword ptr [esp + stk_2c], esi            # 00508464
    mov ecx, dword ptr [esi + field_c]           # 00508468
    mov eax, dword ptr [esi + field_4]           # 0050846b
    mov edi, dword ptr [esi + field_8]           # 0050846e
    mov dword ptr [esp + stk_3c], ecx            # 00508471
    mov ecx, dword ptr [esi]                     # 00508475
    mov dword ptr [esp + stk_10], edi            # 00508477
    {load} sub eax, ecx                          # 0050847b
    cdq                                          # 0050847d
    idiv edi                                     # 0050847e
    lea edx, [4*ebx]                             # 00508480
    push edx                                     # 00508487
    mov dword ptr [esp + stk_18], eax            # 00508488
    mov eax, dword ptr [ebp + arg_8]             # 0050848c
    push eax                                     # 0050848f
    call FUN_004fee30                            # 00508490
    fild dword ptr [esp + stk_18]                # 00508495
    add esp, 0x8                                 # 00508499
    mov dword ptr [esp + stk_30], eax            # 0050849c
    test ebx, ebx                                # 005084a0
    fdivr qword ptr [0x52c680]                   # 005084a2
    fstp dword ptr [esp + stk_38]                # 005084a8
    jle.d8 L_0050850b                            # 005084ac
    # block 0x005084ae: entered by fall-through of jle at 0x005084ac, 2 instruction(s), falls into the block at 0x005084b6
    mov dword ptr [esp + stk_c], eax             # 005084ae
    mov dword ptr [esp + stk_24], ebx            # 005084b2
L_005084b6:
    # block 0x005084b6: entered by jne at 0x00508501, 26 instruction(s), calls FUN_004fee30, ends with jne to 0x005084b6 (backward)
    mov ecx, dword ptr [esp + stk_14]            # 005084b6
    mov edx, dword ptr [ebp + arg_8]             # 005084ba
    lea eax, [4*ecx]                             # 005084bd
    push eax                                     # 005084c4
    push edx                                     # 005084c5
    call FUN_004fee30                            # 005084c6
    mov ecx, dword ptr [esp + stk_1c]            # 005084cb
    {load} mov edi, eax                          # 005084cf
    mov eax, dword ptr [esp + stk_14]            # 005084d1
    add esp, 0x8                                 # 005084d5
    shl ecx, 0x2                                 # 005084d8
    {load} mov edx, ecx                          # 005084db
    mov dword ptr [eax], edi                     # 005084dd
    {load} xor eax, eax                          # 005084df
    shr ecx, 0x2                                 # 005084e1
    rep stosd dword ptr es:[edi], eax            # 005084e4
    {load} mov ecx, edx                          # 005084e6
    and ecx, 0x3                                 # 005084e8
    rep stosb byte ptr es:[edi], al              # 005084eb
    mov ecx, dword ptr [esp + stk_c]             # 005084ed
    mov eax, dword ptr [esp + stk_24]            # 005084f1
    add ecx, 0x4                                 # 005084f5
    dec eax                                      # 005084f8
    mov dword ptr [esp + stk_c], ecx             # 005084f9
    mov dword ptr [esp + stk_24], eax            # 005084fd
    jne.d8 L_005084b6                            # 00508501
    # block 0x00508503: entered by fall-through of jne at 0x00508501, 2 instruction(s), falls into the block at 0x0050850b
    mov eax, dword ptr [esp + stk_30]            # 00508503
    mov edi, dword ptr [esp + stk_10]            # 00508507
L_0050850b:
    # block 0x0050850b: entered by jle at 0x005084ac, 5 instruction(s), ends with jle to 0x0050866d (forward)
    mov edx, dword ptr [esp + stk_14]            # 0050850b
    {load} xor ecx, ecx                          # 0050850f
    {load} cmp edx, ecx                          # 00508511
    mov dword ptr [esp + stk_20], ecx            # 00508513
    jle.d32 L_0050866d                           # 00508517
    # block 0x0050851d: entered by fall-through of jle at 0x00508517, 1 instruction(s), falls into the block at 0x00508521
    mov dword ptr [esp + stk_24], ecx            # 0050851d
L_00508521:
    # block 0x00508521: entered by jl at 0x00508667, 6 instruction(s), ends with jle to 0x0050864e (forward)
    mov edx, dword ptr [esi]                     # 00508521
    mov ecx, dword ptr [esp + stk_24]            # 00508523
    {load} add edx, ecx                          # 00508527
    test ebx, ebx                                # 00508529
    mov dword ptr [esp + stk_34], edx            # 0050852b
    jle.d32 L_0050864e                           # 0050852f
    # block 0x00508535: entered by fall-through of jle at 0x0050852f, 6 instruction(s), ends with forward jump to 0x00508550
    mov ecx, dword ptr [ebp + arg_10]            # 00508535
    mov dword ptr [esp + stk_28], ebx            # 00508538
    {load} sub eax, ecx                          # 0050853c
    mov dword ptr [esp + stk_1c], ecx            # 0050853e
    mov dword ptr [esp + stk_44], eax            # 00508542
    jmp.d8 L_00508550                            # 00508546
L_00508548:
    # block 0x00508548: entered by jne at 0x00508639, 2 instruction(s), falls into the block at 0x00508550
    mov edi, dword ptr [esp + stk_10]            # 00508548
    mov edx, dword ptr [esp + stk_34]            # 0050854c
L_00508550:
    # block 0x00508550: entered by jmp at 0x00508546, 4 instruction(s), ends with jle to 0x005085b2 (forward)
    test edi, edi                                # 00508550
    mov dword ptr [esp + stk_18], 0x0            # 00508552
    mov dword ptr [esp + stk_c], 0x0             # 0050855a
    jle.d8 L_005085b2                            # 00508562
    # block 0x00508564: entered by fall-through of jle at 0x00508562, 1 instruction(s), falls into the block at 0x0050856b
    lea esi, [4*edx]                             # 00508564
L_0050856b:
    # block 0x0050856b: entered by jne at 0x005085b0, 10 instruction(s), ends with je to 0x0050858c (forward)
    mov eax, dword ptr [esp + stk_1c]            # 0050856b
    mov ecx, dword ptr [eax]                     # 0050856f
    {load} add ecx, esi                          # 00508571
    fld dword ptr [ecx]                          # 00508573
    fabs                                         # 00508575
    fld dword ptr [esp + stk_18]                 # 00508577
    fcompp                                       # 0050857b
    fnstsw ax                                    # 0050857d
    test ah, 0x1                                 # 0050857f
    je.d8 L_0050858c                             # 00508582
    # block 0x00508584: entered by fall-through of je at 0x00508582, 3 instruction(s), falls into the block at 0x0050858c
    fld dword ptr [ecx]                          # 00508584
    fabs                                         # 00508586
    fstp dword ptr [esp + stk_18]                # 00508588
L_0050858c:
    # block 0x0050858c: entered by je at 0x00508582, 12 instruction(s), calls FUN_0050e19e, ends with jne to 0x0050856b (backward)
    fld dword ptr [ecx]                          # 0050858c
    fadd dword ptr [0x52cd14]                    # 0050858e
    sub esp, 0x8                                 # 00508594
    fstp qword ptr [esp]                         # 00508597
    call FUN_0050e19e                            # 0050859a
    fabs                                         # 0050859f
    fadd dword ptr [esp + stk_14]                # 005085a1
    add esp, 0x8                                 # 005085a5
    add esi, 0x4                                 # 005085a8
    dec edi                                      # 005085ab
    fstp dword ptr [esp + stk_c]                 # 005085ac
    jne.d8 L_0050856b                            # 005085b0
L_005085b2:
    # block 0x005085b2: entered by jle at 0x00508562; fall-through of jne at 0x005085b0, 8 instruction(s), ends with jle to 0x00508617 (forward)
    fld dword ptr [esp + stk_c]                  # 005085b2
    mov edx, dword ptr [esp + stk_3c]            # 005085b6
    {load} xor esi, esi                          # 005085ba
    fmul dword ptr [esp + stk_38]                # 005085bc
    lea ebx, [edx - field_minus_1]               # 005085c0
    test ebx, ebx                                # 005085c3
    fstp dword ptr [esp + stk_c]                 # 005085c5
    jle.d8 L_00508617                            # 005085c9
    # block 0x005085cb: entered by fall-through of jle at 0x005085c9, 2 instruction(s), falls into the block at 0x005085d5
    mov eax, dword ptr [esp + stk_2c]            # 005085cb
    lea edi, [eax + field_614]                   # 005085cf
L_005085d5:
    # block 0x005085d5: entered by jl at 0x00508615, 5 instruction(s), ends with je to 0x0050860f (forward)
    fld dword ptr [esp + stk_18]                 # 005085d5
    fcomp dword ptr [edi - field_minus_100]      # 005085d9
    fnstsw ax                                    # 005085df
    test ah, 0x41                                # 005085e1
    je.d8 L_0050860f                             # 005085e4
    # block 0x005085e6: entered by fall-through of je at 0x005085e4, 5 instruction(s), ends with jne to 0x00508617 (forward)
    fld dword ptr [edi]                          # 005085e6
    fcomp dword ptr [0x52db78]                   # 005085e8
    fnstsw ax                                    # 005085ee
    test ah, 0x1                                 # 005085f0
    jne.d8 L_00508617                            # 005085f3
    # block 0x005085f5: entered by fall-through of jne at 0x005085f3, 8 instruction(s), calls FUN_0050ce04, ends with jne to 0x00508617 (forward)
    fld dword ptr [esp + stk_c]                  # 005085f5
    call FUN_0050ce04                            # 005085f9
    mov dword ptr [esp + stk_40], eax            # 005085fe
    fild dword ptr [esp + stk_40]                # 00508602
    fcomp dword ptr [edi]                        # 00508606
    fnstsw ax                                    # 00508608
    test ah, 0x1                                 # 0050860a
    jne.d8 L_00508617                            # 0050860d
L_0050860f:
    # block 0x0050860f: entered by je at 0x005085e4; fall-through of jne at 0x0050860d, 4 instruction(s), ends with jl to 0x005085d5 (backward)
    inc esi                                      # 0050860f
    add edi, 0x4                                 # 00508610
    {load} cmp esi, ebx                          # 00508613
    jl.d8 L_005085d5                             # 00508615
L_00508617:
    # block 0x00508617: entered by jle at 0x005085c9; jne at 0x005085f3; jne at 0x0050860d; fall-through of jl at 0x00508615, 11 instruction(s), ends with jne to 0x00508548 (backward)
    mov ecx, dword ptr [esp + stk_44]            # 00508617
    mov eax, dword ptr [esp + stk_1c]            # 0050861b
    mov edx, dword ptr [ecx + eax]               # 0050861f
    mov ecx, dword ptr [esp + stk_20]            # 00508622
    add eax, 0x4                                 # 00508626
    mov dword ptr [esp + stk_1c], eax            # 00508629
    mov eax, dword ptr [esp + stk_28]            # 0050862d
    dec eax                                      # 00508631
    mov dword ptr [edx + 4*ecx], esi             # 00508632
    mov dword ptr [esp + stk_28], eax            # 00508635
    jne.d32 L_00508548                           # 00508639
    # block 0x0050863f: entered by fall-through of jne at 0x00508639, 4 instruction(s), falls into the block at 0x0050864e
    mov esi, dword ptr [esp + stk_2c]            # 0050863f
    mov ebx, dword ptr [ebp + arg_14]            # 00508643
    mov eax, dword ptr [esp + stk_30]            # 00508646
    mov edi, dword ptr [esp + stk_10]            # 0050864a
L_0050864e:
    # block 0x0050864e: entered by jle at 0x0050852f, 9 instruction(s), ends with jl to 0x00508521 (backward)
    mov edx, dword ptr [esp + stk_24]            # 0050864e
    mov ecx, dword ptr [esp + stk_20]            # 00508652
    {load} add edx, edi                          # 00508656
    inc ecx                                      # 00508658
    mov dword ptr [esp + stk_24], edx            # 00508659
    mov edx, dword ptr [esp + stk_14]            # 0050865d
    {load} cmp ecx, edx                          # 00508661
    mov dword ptr [esp + stk_20], ecx            # 00508663
    jl.d32 L_00508521                            # 00508667
L_0050866d:
    # block 0x0050866d: entered by jle at 0x00508517; fall-through of jl at 0x00508667, 8 instruction(s), ends with ret
    mov ecx, dword ptr [ebp + arg_c]             # 0050866d
    pop edi                                      # 00508670
    pop esi                                      # 00508671
    pop ebx                                      # 00508672
    inc dword ptr [ecx + field_28]               # 00508673
    {load} mov esp, ebp                          # 00508676
    pop ebp                                      # 00508678
    ret                                          # 00508679

# --- data items (not part of the function) -------------------------
.org 0x0050867a - 0x401000
PAD_0050867a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

