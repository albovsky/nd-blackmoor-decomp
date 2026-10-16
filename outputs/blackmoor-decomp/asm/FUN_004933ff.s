# FUN_004933ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004933ff
# extent:       0x004933ff-0x004939d6 (1495 code bytes)
# span:         0x004933ff-0x004939e6 (code 1495, tables 16, padding 0)
# sha256:       43d9e2fb3aa1c6f084fd7dfb172367a4389849dbf34f00ef38b3f803d3da9944
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004933ff
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       24 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 12 more
# fields:       [eax + n] field_4, field_8, field_23, field_2b, field_3431; [ecx + n] field_4, field_8, field_2f31; [edx + n] field_4, field_8, field_2d, field_2491, field_3ed1
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0050ce04, FUN_0052139c, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 453 instruction(s), 19 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2491, 0x2491  # offset +0x2491
.equ field_2f31, 0x2f31  # offset +0x2f31
.equ field_3431, 0x3431  # offset +0x3431
.equ field_3ed1, 0x3ed1  # offset +0x3ed1

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004933ff - 0x401000
.globl FUN_004933ff
FUN_004933ff:
    # block 0x004933ff: entry, 22 instruction(s), calls FUN_0051dc43, ends with jne to 0x00493472 (forward)
    push ebp                                     # 004933ff
    {load} mov ebp, esp                          # 00493400
    sub esp, 0x60                                # 00493402
    push edi                                     # 00493405
    mov dword ptr [ebp - local_50], ecx          # 00493406
    mov eax, dword ptr [ebp + arg_8]             # 00493409
    movsx ecx, word ptr [eax + field_2b]         # 0049340c
    mov edx, dword ptr [ebp + arg_8]             # 00493410
    movsx eax, word ptr [edx + field_2d]         # 00493413
    imul ecx, eax                                # 00493417
    mov dword ptr [ebp - local_8], ecx           # 0049341a
    mov dword ptr [ebp - local_28], 0x0          # 0049341d
    mov ecx, dword ptr [ebp - local_8]           # 00493424
    imul ecx, ecx, 0xc                           # 00493427
    push ecx                                     # 0049342a
    call FUN_0051dc43                            # 0049342b
    add esp, 0x4                                 # 00493430
    mov dword ptr [ebp - local_34], eax          # 00493433
    mov edx, dword ptr [ebp - local_34]          # 00493436
    mov dword ptr [ebp - local_28], edx          # 00493439
    cmp dword ptr [ebp - local_28], 0x0          # 0049343c
    jne.d8 L_00493472                            # 00493440
    # block 0x00493442: entered by fall-through of jne at 0x00493440, 10 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00493472
    push 0x54f5b8                                # 00493442
    push 0x63888b                                # 00493447
    call FUN_0050ca3e                            # 0049344c
    add esp, 0x8                                 # 00493451
    push 0x63888b                                # 00493454
    push 0x54f618                                # 00493459
    mov ecx, 0x583979                            # 0049345e
    call FUN_0042639d                            # 00493463
    mov ecx, 0x5cf659                            # 00493468
    call FUN_004c97b4                            # 0049346d
L_00493472:
    # block 0x00493472: entered by jne at 0x00493440, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x004934e0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00493472
    imul ecx, ecx, 0xc                           # 00493475
    {load} xor eax, eax                          # 00493478
    mov edi, dword ptr [ebp - local_28]          # 0049347a
    {load} mov edx, ecx                          # 0049347d
    shr ecx, 0x2                                 # 0049347f
    rep stosd dword ptr es:[edi], eax            # 00493482
    {load} mov ecx, edx                          # 00493484
    and ecx, 0x3                                 # 00493486
    rep stosb byte ptr es:[edi], al              # 00493489
    mov dword ptr [ebp - local_14], 0x0          # 0049348b
    mov eax, dword ptr [ebp - local_8]           # 00493492
    imul eax, eax, 0xc                           # 00493495
    push eax                                     # 00493498
    call FUN_0051dc43                            # 00493499
    add esp, 0x4                                 # 0049349e
    mov dword ptr [ebp - local_38], eax          # 004934a1
    mov ecx, dword ptr [ebp - local_38]          # 004934a4
    mov dword ptr [ebp - local_14], ecx          # 004934a7
    cmp dword ptr [ebp - local_14], 0x0          # 004934aa
    jne.d8 L_004934e0                            # 004934ae
    # block 0x004934b0: entered by fall-through of jne at 0x004934ae, 10 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004934e0
    push 0x54f634                                # 004934b0
    push 0x63888b                                # 004934b5
    call FUN_0050ca3e                            # 004934ba
    add esp, 0x8                                 # 004934bf
    push 0x63888b                                # 004934c2
    push 0x54f690                                # 004934c7
    mov ecx, 0x583979                            # 004934cc
    call FUN_0042639d                            # 004934d1
    mov ecx, 0x5cf659                            # 004934d6
    call FUN_004c97b4                            # 004934db
L_004934e0:
    # block 0x004934e0: entered by jne at 0x004934ae, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049354e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004934e0
    imul ecx, ecx, 0xc                           # 004934e3
    {load} xor eax, eax                          # 004934e6
    mov edi, dword ptr [ebp - local_14]          # 004934e8
    {load} mov edx, ecx                          # 004934eb
    shr ecx, 0x2                                 # 004934ed
    rep stosd dword ptr es:[edi], eax            # 004934f0
    {load} mov ecx, edx                          # 004934f2
    and ecx, 0x3                                 # 004934f4
    rep stosb byte ptr es:[edi], al              # 004934f7
    mov dword ptr [ebp - local_30], 0x0          # 004934f9
    mov eax, dword ptr [ebp - local_8]           # 00493500
    imul eax, eax, 0xc                           # 00493503
    push eax                                     # 00493506
    call FUN_0051dc43                            # 00493507
    add esp, 0x4                                 # 0049350c
    mov dword ptr [ebp - local_3c], eax          # 0049350f
    mov ecx, dword ptr [ebp - local_3c]          # 00493512
    mov dword ptr [ebp - local_30], ecx          # 00493515
    cmp dword ptr [ebp - local_30], 0x0          # 00493518
    jne.d8 L_0049354e                            # 0049351c
    # block 0x0049351e: entered by fall-through of jne at 0x0049351c, 10 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0049354e
    push 0x54f6ac                                # 0049351e
    push 0x63888b                                # 00493523
    call FUN_0050ca3e                            # 00493528
    add esp, 0x8                                 # 0049352d
    push 0x63888b                                # 00493530
    push 0x54f70c                                # 00493535
    mov ecx, 0x583979                            # 0049353a
    call FUN_0042639d                            # 0049353f
    mov ecx, 0x5cf659                            # 00493544
    call FUN_004c97b4                            # 00493549
L_0049354e:
    # block 0x0049354e: entered by jne at 0x0049351c, 13 instruction(s), ends with forward jump to 0x00493589
    mov ecx, dword ptr [ebp - local_8]           # 0049354e
    imul ecx, ecx, 0xc                           # 00493551
    {load} xor eax, eax                          # 00493554
    mov edi, dword ptr [ebp - local_30]          # 00493556
    {load} mov edx, ecx                          # 00493559
    shr ecx, 0x2                                 # 0049355b
    rep stosd dword ptr es:[edi], eax            # 0049355e
    {load} mov ecx, edx                          # 00493560
    and ecx, 0x3                                 # 00493562
    rep stosb byte ptr es:[edi], al              # 00493565
    mov dword ptr [ebp - local_18], 0x0          # 00493567
    mov dword ptr [ebp - local_c], 0x0           # 0049356e
    jmp.d8 L_00493589                            # 00493575
L_00493577:
    # block 0x00493577: entered by jmp at 0x004936c8, 6 instruction(s), falls into the block at 0x00493589
    mov eax, dword ptr [ebp - local_18]          # 00493577
    add eax, 0x1                                 # 0049357a
    mov dword ptr [ebp - local_18], eax          # 0049357d
    mov ecx, dword ptr [ebp - local_c]           # 00493580
    add ecx, 0x2                                 # 00493583
    mov dword ptr [ebp - local_c], ecx           # 00493586
L_00493589:
    # block 0x00493589: entered by jmp at 0x00493575, 3 instruction(s), ends with jge to 0x004936cd (forward)
    mov edx, dword ptr [ebp - local_18]          # 00493589
    cmp edx, dword ptr [ebp - local_8]           # 0049358c
    jge.d32 L_004936cd                           # 0049358f
    # block 0x00493595: entered by fall-through of jge at 0x0049358f, 49 instruction(s), ends with je to 0x00493645 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00493595
    mov ecx, dword ptr [eax]                     # 00493598
    mov edx, dword ptr [ebp - local_c]           # 0049359a
    {load} xor eax, eax                          # 0049359d
    mov ax, word ptr [ecx + edx]                 # 0049359f
    mov dword ptr [ebp - local_4], eax           # 004935a3
    mov ecx, dword ptr [ebp - local_18]          # 004935a6
    imul ecx, ecx, 0xc                           # 004935a9
    mov edx, dword ptr [ebp - local_28]          # 004935ac
    {load} add edx, ecx                          # 004935af
    mov dword ptr [ebp - local_24], edx          # 004935b1
    mov eax, dword ptr [ebp - local_18]          # 004935b4
    imul eax, eax, 0xc                           # 004935b7
    mov ecx, dword ptr [ebp - local_30]          # 004935ba
    {load} add ecx, eax                          # 004935bd
    mov dword ptr [ebp - local_10], ecx          # 004935bf
    {load} xor edx, edx                          # 004935c2
    mov dl, byte ptr [0x5d2f1b]                  # 004935c4
    {load} mov ecx, edx                          # 004935ca
    mov eax, dword ptr [ebp - local_4]           # 004935cc
    sar eax, cl                                  # 004935cf
    {load} xor ecx, ecx                          # 004935d1
    mov cl, byte ptr [0x5d2f1f]                  # 004935d3
    {load} and eax, ecx                          # 004935d9
    mov edx, dword ptr [ebp - local_24]          # 004935db
    mov dword ptr [edx], eax                     # 004935de
    {load} xor eax, eax                          # 004935e0
    mov al, byte ptr [0x5d2f1a]                  # 004935e2
    {load} mov ecx, eax                          # 004935e7
    mov edx, dword ptr [ebp - local_4]           # 004935e9
    sar edx, cl                                  # 004935ec
    {load} xor eax, eax                          # 004935ee
    mov al, byte ptr [0x5d2f1e]                  # 004935f0
    {load} and edx, eax                          # 004935f5
    mov ecx, dword ptr [ebp - local_24]          # 004935f7
    mov dword ptr [ecx + field_4], edx           # 004935fa
    {load} xor edx, edx                          # 004935fd
    mov dl, byte ptr [0x5d2f19]                  # 004935ff
    {load} mov ecx, edx                          # 00493605
    mov eax, dword ptr [ebp - local_4]           # 00493607
    sar eax, cl                                  # 0049360a
    {load} xor ecx, ecx                          # 0049360c
    mov cl, byte ptr [0x5d2f1d]                  # 0049360e
    {load} and eax, ecx                          # 00493614
    mov edx, dword ptr [ebp - local_24]          # 00493616
    mov dword ptr [edx + field_8], eax           # 00493619
    mov eax, dword ptr [ebp - local_24]          # 0049361c
    cmp dword ptr [eax], 0x0                     # 0049361f
    je.d8 L_00493645                             # 00493622
    # block 0x00493624: entered by fall-through of je at 0x00493622, 9 instruction(s), calls FUN_0050ce04, falls into the block at 0x00493645
    mov ecx, dword ptr [ebp - local_24]          # 00493624
    fild dword ptr [ecx]                         # 00493627
    fstp dword ptr [ebp - local_54]              # 00493629
    fld dword ptr [ebp - local_54]               # 0049362c
    fdiv dword ptr [0x52db58]                    # 0049362f
    fmul dword ptr [0x52db54]                    # 00493635
    call FUN_0050ce04                            # 0049363b
    mov edx, dword ptr [ebp - local_10]          # 00493640
    mov dword ptr [edx], eax                     # 00493643
L_00493645:
    # block 0x00493645: entered by je at 0x00493622, 3 instruction(s), ends with je to 0x00493671 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00493645
    cmp dword ptr [eax + field_4], 0x0           # 00493648
    je.d8 L_00493671                             # 0049364c
    # block 0x0049364e: entered by fall-through of je at 0x0049364c, 9 instruction(s), calls FUN_0050ce04, falls into the block at 0x00493671
    mov ecx, dword ptr [ebp - local_24]          # 0049364e
    fild dword ptr [ecx + field_4]               # 00493651
    fstp dword ptr [ebp - local_58]              # 00493654
    fld dword ptr [ebp - local_58]               # 00493657
    fdiv dword ptr [0x52db58]                    # 0049365a
    fmul dword ptr [0x52db54]                    # 00493660
    call FUN_0050ce04                            # 00493666
    mov edx, dword ptr [ebp - local_10]          # 0049366b
    mov dword ptr [edx + field_4], eax           # 0049366e
L_00493671:
    # block 0x00493671: entered by je at 0x0049364c, 3 instruction(s), ends with je to 0x0049369d (forward)
    mov eax, dword ptr [ebp - local_24]          # 00493671
    cmp dword ptr [eax + field_8], 0x0           # 00493674
    je.d8 L_0049369d                             # 00493678
    # block 0x0049367a: entered by fall-through of je at 0x00493678, 9 instruction(s), calls FUN_0050ce04, falls into the block at 0x0049369d
    mov ecx, dword ptr [ebp - local_24]          # 0049367a
    fild dword ptr [ecx + field_8]               # 0049367d
    fstp dword ptr [ebp - local_5c]              # 00493680
    fld dword ptr [ebp - local_5c]               # 00493683
    fdiv dword ptr [0x52db58]                    # 00493686
    fmul dword ptr [0x52db54]                    # 0049368c
    call FUN_0050ce04                            # 00493692
    mov edx, dword ptr [ebp - local_10]          # 00493697
    mov dword ptr [edx + field_8], eax           # 0049369a
L_0049369d:
    # block 0x0049369d: entered by je at 0x00493678, 16 instruction(s), ends with backward jump to 0x00493577
    mov eax, dword ptr [ebp - local_24]          # 0049369d
    mov ecx, dword ptr [eax]                     # 004936a0
    shl ecx, 0x10                                # 004936a2
    mov edx, dword ptr [ebp - local_24]          # 004936a5
    mov dword ptr [edx], ecx                     # 004936a8
    mov eax, dword ptr [ebp - local_24]          # 004936aa
    mov ecx, dword ptr [eax + field_4]           # 004936ad
    shl ecx, 0x10                                # 004936b0
    mov edx, dword ptr [ebp - local_24]          # 004936b3
    mov dword ptr [edx + field_4], ecx           # 004936b6
    mov eax, dword ptr [ebp - local_24]          # 004936b9
    mov ecx, dword ptr [eax + field_8]           # 004936bc
    shl ecx, 0x10                                # 004936bf
    mov edx, dword ptr [ebp - local_24]          # 004936c2
    mov dword ptr [edx + field_8], ecx           # 004936c5
    jmp.d32 L_00493577                           # 004936c8
L_004936cd:
    # block 0x004936cd: entered by jge at 0x0049358f, 2 instruction(s), ends with forward jump to 0x004936df
    mov dword ptr [ebp - local_1c], 0x1          # 004936cd
    jmp.d8 L_004936df                            # 004936d4
L_004936d6:
    # block 0x004936d6: entered by jmp at 0x00493994, 3 instruction(s), falls into the block at 0x004936df
    mov eax, dword ptr [ebp - local_1c]          # 004936d6
    add eax, 0x1                                 # 004936d9
    mov dword ptr [ebp - local_1c], eax          # 004936dc
L_004936df:
    # block 0x004936df: entered by jmp at 0x004936d4, 2 instruction(s), ends with jge to 0x00493999 (forward)
    cmp dword ptr [ebp - local_1c], 0x8          # 004936df
    jge.d32 L_00493999                           # 004936e3
    # block 0x004936e9: entered by fall-through of jge at 0x004936e3, 3 instruction(s), ends with forward jump to 0x0049370b
    mov dword ptr [ebp - local_18], 0x0          # 004936e9
    mov dword ptr [ebp - local_c], 0x0           # 004936f0
    jmp.d8 L_0049370b                            # 004936f7
L_004936f9:
    # block 0x004936f9: entered by jmp at 0x00493857, 6 instruction(s), falls into the block at 0x0049370b
    mov ecx, dword ptr [ebp - local_18]          # 004936f9
    add ecx, 0x1                                 # 004936fc
    mov dword ptr [ebp - local_18], ecx          # 004936ff
    mov edx, dword ptr [ebp - local_c]           # 00493702
    add edx, 0x2                                 # 00493705
    mov dword ptr [ebp - local_c], edx           # 00493708
L_0049370b:
    # block 0x0049370b: entered by jmp at 0x004936f7, 3 instruction(s), ends with jge to 0x0049385c (forward)
    mov eax, dword ptr [ebp - local_18]          # 0049370b
    cmp eax, dword ptr [ebp - local_8]           # 0049370e
    jge.d32 L_0049385c                           # 00493711
    # block 0x00493717: entered by fall-through of jge at 0x00493711, 25 instruction(s), ends with je to 0x00493793 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00493717
    mov edx, dword ptr [ecx]                     # 0049371a
    mov eax, dword ptr [ebp - local_c]           # 0049371c
    {load} xor ecx, ecx                          # 0049371f
    mov cx, word ptr [edx + eax]                 # 00493721
    mov dword ptr [ebp - local_4], ecx           # 00493725
    mov edx, dword ptr [ebp - local_18]          # 00493728
    imul edx, edx, 0xc                           # 0049372b
    mov eax, dword ptr [ebp - local_28]          # 0049372e
    {load} add eax, edx                          # 00493731
    mov dword ptr [ebp - local_24], eax          # 00493733
    mov ecx, dword ptr [ebp - local_18]          # 00493736
    imul ecx, ecx, 0xc                           # 00493739
    mov edx, dword ptr [ebp - local_30]          # 0049373c
    {load} add edx, ecx                          # 0049373f
    mov dword ptr [ebp - local_10], edx          # 00493741
    mov eax, dword ptr [ebp - local_18]          # 00493744
    imul eax, eax, 0xc                           # 00493747
    mov ecx, dword ptr [ebp - local_14]          # 0049374a
    {load} add ecx, eax                          # 0049374d
    mov dword ptr [ebp - local_2c], ecx          # 0049374f
    {load} xor edx, edx                          # 00493752
    mov dx, word ptr [0x5d2f29]                  # 00493754
    cmp dword ptr [ebp - local_4], edx           # 0049375b
    je.d8 L_00493793                             # 0049375e
    # block 0x00493760: entered by fall-through of je at 0x0049375e, 18 instruction(s), falls into the block at 0x00493793
    mov eax, dword ptr [ebp - local_24]          # 00493760
    mov ecx, dword ptr [ebp - local_10]          # 00493763
    mov edx, dword ptr [eax]                     # 00493766
    sub edx, dword ptr [ecx]                     # 00493768
    mov eax, dword ptr [ebp - local_24]          # 0049376a
    mov dword ptr [eax], edx                     # 0049376d
    mov ecx, dword ptr [ebp - local_24]          # 0049376f
    mov edx, dword ptr [ebp - local_10]          # 00493772
    mov eax, dword ptr [ecx + field_4]           # 00493775
    sub eax, dword ptr [edx + field_4]           # 00493778
    mov ecx, dword ptr [ebp - local_24]          # 0049377b
    mov dword ptr [ecx + field_4], eax           # 0049377e
    mov edx, dword ptr [ebp - local_24]          # 00493781
    mov eax, dword ptr [ebp - local_10]          # 00493784
    mov ecx, dword ptr [edx + field_8]           # 00493787
    sub ecx, dword ptr [eax + field_8]           # 0049378a
    mov edx, dword ptr [ebp - local_24]          # 0049378d
    mov dword ptr [edx + field_8], ecx           # 00493790
L_00493793:
    # block 0x00493793: entered by je at 0x0049375e, 35 instruction(s), ends with jg to 0x00493808 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00493793
    mov ecx, dword ptr [eax]                     # 00493796
    sar ecx, 0x10                                # 00493798
    mov edx, dword ptr [ebp - local_2c]          # 0049379b
    mov dword ptr [edx], ecx                     # 0049379e
    mov eax, dword ptr [ebp - local_24]          # 004937a0
    mov ecx, dword ptr [eax + field_4]           # 004937a3
    sar ecx, 0x10                                # 004937a6
    mov edx, dword ptr [ebp - local_2c]          # 004937a9
    mov dword ptr [edx + field_4], ecx           # 004937ac
    mov eax, dword ptr [ebp - local_24]          # 004937af
    mov ecx, dword ptr [eax + field_8]           # 004937b2
    sar ecx, 0x10                                # 004937b5
    mov edx, dword ptr [ebp - local_2c]          # 004937b8
    mov dword ptr [edx + field_8], ecx           # 004937bb
    mov eax, dword ptr [ebp - local_2c]          # 004937be
    mov ecx, dword ptr [eax]                     # 004937c1
    and ecx, 0xffff                              # 004937c3
    mov edx, dword ptr [ebp - local_2c]          # 004937c9
    mov dword ptr [edx], ecx                     # 004937cc
    mov eax, dword ptr [ebp - local_2c]          # 004937ce
    mov ecx, dword ptr [eax + field_4]           # 004937d1
    and ecx, 0xffff                              # 004937d4
    mov edx, dword ptr [ebp - local_2c]          # 004937da
    mov dword ptr [edx + field_4], ecx           # 004937dd
    mov eax, dword ptr [ebp - local_2c]          # 004937e0
    mov ecx, dword ptr [eax + field_8]           # 004937e3
    and ecx, 0xffff                              # 004937e6
    mov edx, dword ptr [ebp - local_2c]          # 004937ec
    mov dword ptr [edx + field_8], ecx           # 004937ef
    {load} xor eax, eax                          # 004937f2
    mov al, byte ptr [0x5d2f1f]                  # 004937f4
    mov ecx, dword ptr [ebp - local_2c]          # 004937f9
    cmp dword ptr [ecx], eax                     # 004937fc
    jg.d8 L_00493808                             # 004937fe
    # block 0x00493800: entered by fall-through of jg at 0x004937fe, 3 instruction(s), ends with jge to 0x00493811 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 00493800
    cmp dword ptr [edx], 0x0                     # 00493803
    jge.d8 L_00493811                            # 00493806
L_00493808:
    # block 0x00493808: entered by jg at 0x004937fe; fall-through of jge at 0x00493806, 2 instruction(s), falls into the block at 0x00493811
    mov eax, dword ptr [ebp - local_2c]          # 00493808
    mov dword ptr [eax], 0x0                     # 0049380b
L_00493811:
    # block 0x00493811: entered by jge at 0x00493806, 5 instruction(s), ends with jg to 0x0049382a (forward)
    {load} xor ecx, ecx                          # 00493811
    mov cl, byte ptr [0x5d2f1e]                  # 00493813
    mov edx, dword ptr [ebp - local_2c]          # 00493819
    cmp dword ptr [edx + field_4], ecx           # 0049381c
    jg.d8 L_0049382a                             # 0049381f
    # block 0x00493821: entered by fall-through of jg at 0x0049381f, 3 instruction(s), ends with jge to 0x00493834 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 00493821
    cmp dword ptr [eax + field_4], 0x0           # 00493824
    jge.d8 L_00493834                            # 00493828
L_0049382a:
    # block 0x0049382a: entered by jg at 0x0049381f; fall-through of jge at 0x00493828, 2 instruction(s), falls into the block at 0x00493834
    mov ecx, dword ptr [ebp - local_2c]          # 0049382a
    mov dword ptr [ecx + field_4], 0x0           # 0049382d
L_00493834:
    # block 0x00493834: entered by jge at 0x00493828, 5 instruction(s), ends with jg to 0x0049384d (forward)
    {load} xor edx, edx                          # 00493834
    mov dl, byte ptr [0x5d2f1d]                  # 00493836
    mov eax, dword ptr [ebp - local_2c]          # 0049383c
    cmp dword ptr [eax + field_8], edx           # 0049383f
    jg.d8 L_0049384d                             # 00493842
    # block 0x00493844: entered by fall-through of jg at 0x00493842, 3 instruction(s), ends with jge to 0x00493857 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 00493844
    cmp dword ptr [ecx + field_8], 0x0           # 00493847
    jge.d8 L_00493857                            # 0049384b
L_0049384d:
    # block 0x0049384d: entered by jg at 0x00493842; fall-through of jge at 0x0049384b, 2 instruction(s), falls into the block at 0x00493857
    mov edx, dword ptr [ebp - local_2c]          # 0049384d
    mov dword ptr [edx + field_8], 0x0           # 00493850
L_00493857:
    # block 0x00493857: entered by jge at 0x0049384b, 1 instruction(s), ends with backward jump to 0x004936f9
    jmp.d32 L_004936f9                           # 00493857
L_0049385c:
    # block 0x0049385c: entered by jge at 0x00493711, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x00493892 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0049385c
    mov ecx, dword ptr [eax + field_23]          # 0049385f
    push ecx                                     # 00493862
    call FUN_0051dc43                            # 00493863
    add esp, 0x4                                 # 00493868
    mov dword ptr [ebp - local_40], eax          # 0049386b
    mov edx, dword ptr [ebp - local_40]          # 0049386e
    mov dword ptr [ebp - local_20], edx          # 00493871
    cmp dword ptr [ebp - local_20], 0x0          # 00493874
    jne.d8 L_00493892                            # 00493878
    # block 0x0049387a: entered by fall-through of jne at 0x00493878, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00493892
    push 0x0                                     # 0049387a
    push 0x0                                     # 0049387c
    push 0x54f728                                # 0049387e
    call FUN_0052139c                            # 00493883
    mov ecx, 0x5cf659                            # 00493888
    call FUN_004c97b4                            # 0049388d
L_00493892:
    # block 0x00493892: entered by jne at 0x00493878, 3 instruction(s), ends with forward jump to 0x004938b4
    mov dword ptr [ebp - local_18], 0x0          # 00493892
    mov dword ptr [ebp - local_c], 0x0           # 00493899
    jmp.d8 L_004938b4                            # 004938a0
L_004938a2:
    # block 0x004938a2: entered by jmp at 0x00493909, 6 instruction(s), falls into the block at 0x004938b4
    mov eax, dword ptr [ebp - local_18]          # 004938a2
    add eax, 0x1                                 # 004938a5
    mov dword ptr [ebp - local_18], eax          # 004938a8
    mov ecx, dword ptr [ebp - local_c]           # 004938ab
    add ecx, 0x2                                 # 004938ae
    mov dword ptr [ebp - local_c], ecx           # 004938b1
L_004938b4:
    # block 0x004938b4: entered by jmp at 0x004938a0, 3 instruction(s), ends with jge to 0x0049390b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004938b4
    cmp edx, dword ptr [ebp - local_8]           # 004938b7
    jge.d8 L_0049390b                            # 004938ba
    # block 0x004938bc: entered by fall-through of jge at 0x004938ba, 28 instruction(s), ends with backward jump to 0x004938a2
    mov eax, dword ptr [ebp - local_18]          # 004938bc
    imul eax, eax, 0xc                           # 004938bf
    mov ecx, dword ptr [ebp - local_14]          # 004938c2
    {load} add ecx, eax                          # 004938c5
    mov dword ptr [ebp - local_2c], ecx          # 004938c7
    {load} xor edx, edx                          # 004938ca
    mov dl, byte ptr [0x5d2f1b]                  # 004938cc
    {load} mov ecx, edx                          # 004938d2
    mov eax, dword ptr [ebp - local_2c]          # 004938d4
    mov edx, dword ptr [eax]                     # 004938d7
    shl edx, cl                                  # 004938d9
    {load} xor eax, eax                          # 004938db
    mov al, byte ptr [0x5d2f1a]                  # 004938dd
    {load} mov ecx, eax                          # 004938e2
    mov eax, dword ptr [ebp - local_2c]          # 004938e4
    mov eax, dword ptr [eax + field_4]           # 004938e7
    shl eax, cl                                  # 004938ea
    {load} or edx, eax                           # 004938ec
    {load} xor ecx, ecx                          # 004938ee
    mov cl, byte ptr [0x5d2f19]                  # 004938f0
    mov eax, dword ptr [ebp - local_2c]          # 004938f6
    mov eax, dword ptr [eax + field_8]           # 004938f9
    shl eax, cl                                  # 004938fc
    {load} or edx, eax                           # 004938fe
    mov ecx, dword ptr [ebp - local_20]          # 00493900
    add ecx, dword ptr [ebp - local_c]           # 00493903
    mov word ptr [ecx], dx                       # 00493906
    jmp.d8 L_004938a2                            # 00493909
L_0049390b:
    # block 0x0049390b: entered by jge at 0x004938ba, 4 instruction(s), ends with ja to 0x00493994 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 0049390b
    mov dword ptr [ebp - local_60], edx          # 0049390e
    cmp dword ptr [ebp - local_60], 0x3          # 00493911
    ja.d8 L_00493994                             # 00493915
    # block 0x00493917: entered by fall-through of ja at 0x00493915, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4939d6]
    mov eax, dword ptr [ebp - local_60]          # 00493917
    jmp dword ptr [4*eax + SWTAB_004939d6_VA]    # 0049391a
L_00493921:
    # block 0x00493921: entered by switch case, 8 instruction(s), ends with forward jump to 0x00493994
    mov ecx, dword ptr [ebp - local_1c]          # 00493921
    imul ecx, ecx, 0x154                         # 00493924
    mov edx, dword ptr [ebp - local_50]          # 0049392a
    lea eax, [edx + ecx + field_2491]            # 0049392d
    mov ecx, dword ptr [ebp + arg_10]            # 00493934
    mov edx, dword ptr [ebp - local_20]          # 00493937
    mov dword ptr [eax + 4*ecx], edx             # 0049393a
    jmp.d8 L_00493994                            # 0049393d
L_0049393f:
    # block 0x0049393f: entered by switch case, 8 instruction(s), ends with forward jump to 0x00493994
    mov eax, dword ptr [ebp - local_1c]          # 0049393f
    imul eax, eax, 0xa0                          # 00493942
    mov ecx, dword ptr [ebp - local_50]          # 00493948
    lea edx, [ecx + eax + field_2f31]            # 0049394b
    mov eax, dword ptr [ebp + arg_10]            # 00493952
    mov ecx, dword ptr [ebp - local_20]          # 00493955
    mov dword ptr [edx + 4*eax], ecx             # 00493958
    jmp.d8 L_00493994                            # 0049395b
L_0049395d:
    # block 0x0049395d: entered by switch case, 8 instruction(s), ends with forward jump to 0x00493994
    mov edx, dword ptr [ebp - local_1c]          # 0049395d
    imul edx, edx, 0x154                         # 00493960
    mov eax, dword ptr [ebp - local_50]          # 00493966
    lea ecx, [eax + edx + field_3431]            # 00493969
    mov edx, dword ptr [ebp + arg_10]            # 00493970
    mov eax, dword ptr [ebp - local_20]          # 00493973
    mov dword ptr [ecx + 4*edx], eax             # 00493976
    jmp.d8 L_00493994                            # 00493979
L_0049397b:
    # block 0x0049397b: entered by switch case, 7 instruction(s), falls into the block at 0x00493994
    mov ecx, dword ptr [ebp - local_1c]          # 0049397b
    imul ecx, ecx, 0x64                          # 0049397e
    mov edx, dword ptr [ebp - local_50]          # 00493981
    lea eax, [edx + ecx + field_3ed1]            # 00493984
    mov ecx, dword ptr [ebp + arg_10]            # 0049398b
    mov edx, dword ptr [ebp - local_20]          # 0049398e
    mov dword ptr [eax + 4*ecx], edx             # 00493991
L_00493994:
    # block 0x00493994: entered by ja at 0x00493915; jmp at 0x0049393d; jmp at 0x0049395b; jmp at 0x00493979, 1 instruction(s), ends with backward jump to 0x004936d6
    jmp.d32 L_004936d6                           # 00493994
L_00493999:
    # block 0x00493999: entered by jge at 0x004936e3, 22 instruction(s), calls FUN_0051dc6c, ends with ret 0xc
    mov eax, dword ptr [ebp - local_28]          # 00493999
    mov dword ptr [ebp - local_44], eax          # 0049399c
    mov ecx, dword ptr [ebp - local_44]          # 0049399f
    push ecx                                     # 004939a2
    call FUN_0051dc6c                            # 004939a3
    add esp, 0x4                                 # 004939a8
    mov edx, dword ptr [ebp - local_14]          # 004939ab
    mov dword ptr [ebp - local_48], edx          # 004939ae
    mov eax, dword ptr [ebp - local_48]          # 004939b1
    push eax                                     # 004939b4
    call FUN_0051dc6c                            # 004939b5
    add esp, 0x4                                 # 004939ba
    mov ecx, dword ptr [ebp - local_30]          # 004939bd
    mov dword ptr [ebp - local_4c], ecx          # 004939c0
    mov edx, dword ptr [ebp - local_4c]          # 004939c3
    push edx                                     # 004939c6
    call FUN_0051dc6c                            # 004939c7
    add esp, 0x4                                 # 004939cc
    pop edi                                      # 004939cf
    {load} mov esp, ebp                          # 004939d0
    pop ebp                                      # 004939d2
    ret 0xc                                      # 004939d3

# --- data items (not part of the function) -------------------------
.org 0x004939d6 - 0x401000
SWTAB_004939d6:  # 4 case address(es)
    .long L_00493921 - .text + 0x401000
    .long L_0049393f - .text + 0x401000
    .long L_0049397b - .text + 0x401000
    .long L_0049395d - .text + 0x401000
.set SWTAB_004939d6_VA, SWTAB_004939d6 - .text + 0x401000

