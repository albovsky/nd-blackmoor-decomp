# FUN_0041546f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041546f
# extent:       0x0041546f-0x004156ea (635 code bytes)
# span:         0x0041546f-0x004156ea (code 635, tables 0, padding 0)
# sha256:       b7227d5c8ca51e11a2b396ca50653d775a9320b6978860a551ace9bb524a3336
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041546f
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_e, field_21, field_41, field_45, field_17a, field_1c2; [ecx + n] field_a, field_e, field_35, field_39, field_3d, field_45; [edx + n] field_6, field_a, field_e, field_21, field_35, field_3d, field_45
# callees:      calls FUN_0050ca3e, FUN_004159db, FUN_004c7314, FUN_004150af, FUN_00416af3, FUN_0051dc6c, FUN_00415011, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:avf_decode_single (function ledger class native_tests_only; also is_empty; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 213 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_21, 0x21  # offset +0x21
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_17a, 0x17a  # offset +0x17a
.equ field_1c2, 0x1c2  # offset +0x1c2

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_004150af, .text + (0x004150af - 0x401000)
.set FUN_004159db, .text + (0x004159db - 0x401000)
.set FUN_00416af3, .text + (0x00416af3 - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041546f - 0x401000
.globl FUN_0041546f
FUN_0041546f:
    # block 0x0041546f: entry, 7 instruction(s), ends with jne to 0x004154a1 (forward)
    push ebp                                     # 0041546f
    {load} mov ebp, esp                          # 00415470
    sub esp, 0x20                                # 00415472
    mov dword ptr [ebp - local_20], ecx          # 00415475
    mov eax, dword ptr [ebp + arg_8]             # 00415478
    cmp dword ptr [eax + field_21], 0x0          # 0041547b
    jne.d8 L_004154a1                            # 0041547f
    # block 0x00415481: entered by fall-through of jne at 0x0041547f, 10 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004156e2
    mov ecx, dword ptr [ebp + arg_8]             # 00415481
    add ecx, 0x4d                                # 00415484
    push ecx                                     # 00415487
    push 0x541be0                                # 00415488
    mov edx, dword ptr [ebp - local_20]          # 0041548d
    add edx, 0x1c                                # 00415490
    push edx                                     # 00415493
    call FUN_0050ca3e                            # 00415494
    add esp, 0xc                                 # 00415499
    jmp.d32 L_004156e2                           # 0041549c
L_004154a1:
    # block 0x004154a1: entered by jne at 0x0041547f, 27 instruction(s), ends with jne to 0x00415533 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004154a1
    movsx ecx, word ptr [eax + field_1c2]        # 004154a4
    mov dword ptr [ebp - local_10], ecx          # 004154ab
    mov edx, dword ptr [ebp + arg_8]             # 004154ae
    add edx, 0x182                               # 004154b1
    mov dword ptr [ebp - local_8], edx           # 004154b7
    mov eax, dword ptr [ebp + arg_8]             # 004154ba
    mov ecx, dword ptr [eax + field_17a]         # 004154bd
    mov dword ptr [ebp - local_18], ecx          # 004154c3
    mov edx, dword ptr [ebp + arg_8]             # 004154c6
    mov dword ptr [ebp - local_4], edx           # 004154c9
    mov eax, dword ptr [ebp - local_4]           # 004154cc
    add eax, 0x4d                                # 004154cf
    mov dword ptr [ebp - local_14], eax          # 004154d2
    mov ecx, dword ptr [ebp - local_10]          # 004154d5
    imul ecx, ecx, 0x13                          # 004154d8
    mov edx, dword ptr [ebp - local_4]           # 004154db
    mov eax, dword ptr [edx + field_21]          # 004154de
    {load} add eax, ecx                          # 004154e1
    mov dword ptr [ebp - local_c], eax           # 004154e3
    mov ecx, dword ptr [ebp - local_8]           # 004154e6
    mov word ptr [ecx], 0x0                      # 004154e9
    mov edx, dword ptr [ebp - local_c]           # 004154ee
    {load} xor eax, eax                          # 004154f1
    mov al, byte ptr [edx + field_e]             # 004154f3
    cmp eax, 0x2                                 # 004154f6
    jne.d8 L_00415533                            # 004154f9
    # block 0x004154fb: entered by fall-through of jne at 0x004154f9, 3 instruction(s), ends with je to 0x00415512 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004154fb
    cmp dword ptr [ecx + field_45], -0x1         # 004154fe
    je.d8 L_00415512                             # 00415502
    # block 0x00415504: entered by fall-through of je at 0x00415502, 5 instruction(s), ends with je to 0x00415533 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00415504
    sub edx, 0x1                                 # 00415507
    mov eax, dword ptr [ebp - local_4]           # 0041550a
    cmp dword ptr [eax + field_45], edx          # 0041550d
    je.d8 L_00415533                             # 00415510
L_00415512:
    # block 0x00415512: entered by je at 0x00415502; fall-through of je at 0x00415510, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004156e0
    mov ecx, dword ptr [ebp - local_14]          # 00415512
    push ecx                                     # 00415515
    mov edx, dword ptr [ebp - local_10]          # 00415516
    push edx                                     # 00415519
    push 0x541c30                                # 0041551a
    mov eax, dword ptr [ebp - local_20]          # 0041551f
    add eax, 0x1c                                # 00415522
    push eax                                     # 00415525
    call FUN_0050ca3e                            # 00415526
    add esp, 0x10                                # 0041552b
    jmp.d32 L_004156e0                           # 0041552e
L_00415533:
    # block 0x00415533: entered by jne at 0x004154f9; je at 0x00415510, 3 instruction(s), ends with jne to 0x00415562 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00415533
    cmp dword ptr [ecx + field_a], 0x0           # 00415536
    jne.d8 L_00415562                            # 0041553a
    # block 0x0041553c: entered by fall-through of jne at 0x0041553a, 3 instruction(s), ends with jne to 0x00415562 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0041553c
    cmp dword ptr [edx + field_6], 0x0           # 0041553f
    jne.d8 L_00415562                            # 00415543
    # block 0x00415545: entered by fall-through of jne at 0x00415543, 9 instruction(s), ends with forward jump to 0x004156e4
    mov eax, dword ptr [ebp - local_8]           # 00415545
    mov cx, word ptr [eax]                       # 00415548
    or cl, 0xc                                   # 0041554b
    mov edx, dword ptr [ebp - local_8]           # 0041554e
    mov word ptr [edx], cx                       # 00415551
    mov eax, dword ptr [ebp - local_4]           # 00415554
    mov ecx, dword ptr [ebp - local_10]          # 00415557
    mov dword ptr [eax + field_45], ecx          # 0041555a
    jmp.d32 L_004156e4                           # 0041555d
L_00415562:
    # block 0x00415562: entered by jne at 0x0041553a; jne at 0x00415543, 5 instruction(s), ends with jne to 0x004155d1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00415562
    {load} xor eax, eax                          # 00415565
    mov al, byte ptr [edx + field_e]             # 00415567
    test eax, eax                                # 0041556a
    jne.d8 L_004155d1                            # 0041556c
    # block 0x0041556e: entered by fall-through of jne at 0x0041556c, 33 instruction(s), calls FUN_004159db, FUN_004c7314, ends with forward jump to 0x004156e4
    mov ecx, dword ptr [ebp - local_4]           # 0041556e
    mov edx, dword ptr [ebp - local_c]           # 00415571
    mov eax, dword ptr [edx + field_a]           # 00415574
    mov dword ptr [ecx + field_3d], eax          # 00415577
    mov ecx, dword ptr [ebp - local_4]           # 0041557a
    mov edx, dword ptr [ebp - local_c]           # 0041557d
    mov eax, dword ptr [edx + field_6]           # 00415580
    mov dword ptr [ecx + field_39], eax          # 00415583
    mov ecx, dword ptr [ebp - local_4]           # 00415586
    mov edx, dword ptr [ebp - local_18]          # 00415589
    mov dword ptr [ecx + field_35], edx          # 0041558c
    mov ax, word ptr [ebp - local_10]            # 0041558f
    push eax                                     # 00415593
    mov ecx, dword ptr [ebp - local_4]           # 00415594
    push ecx                                     # 00415597
    mov ecx, dword ptr [ebp - local_20]          # 00415598
    call FUN_004159db                            # 0041559b
    mov edx, dword ptr [ebp - local_4]           # 004155a0
    mov eax, dword ptr [edx + field_3d]          # 004155a3
    push eax                                     # 004155a6
    mov ecx, dword ptr [ebp - local_18]          # 004155a7
    push ecx                                     # 004155aa
    mov ecx, 0x5cf659                            # 004155ab
    call FUN_004c7314                            # 004155b0
    mov edx, dword ptr [ebp - local_8]           # 004155b5
    mov ax, word ptr [edx]                       # 004155b8
    or al, 0x1                                   # 004155bb
    mov ecx, dword ptr [ebp - local_8]           # 004155bd
    mov word ptr [ecx], ax                       # 004155c0
    mov edx, dword ptr [ebp - local_4]           # 004155c3
    mov eax, dword ptr [ebp - local_10]          # 004155c6
    mov dword ptr [edx + field_45], eax          # 004155c9
    jmp.d32 L_004156e4                           # 004155cc
L_004155d1:
    # block 0x004155d1: entered by jne at 0x0041556c, 37 instruction(s), calls FUN_004150af, FUN_004159db, FUN_00416af3, ends with jne to 0x00415646 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004155d1
    mov edx, dword ptr [ebp - local_c]           # 004155d4
    mov eax, dword ptr [edx + field_a]           # 004155d7
    mov dword ptr [ecx + field_3d], eax          # 004155da
    mov ecx, dword ptr [ebp - local_4]           # 004155dd
    mov edx, dword ptr [ebp - local_c]           # 004155e0
    mov eax, dword ptr [edx + field_6]           # 004155e3
    mov dword ptr [ecx + field_39], eax          # 004155e6
    mov ecx, dword ptr [ebp - local_4]           # 004155e9
    push ecx                                     # 004155ec
    mov ecx, dword ptr [ebp - local_20]          # 004155ed
    call FUN_004150af                            # 004155f0
    mov dx, word ptr [ebp - local_10]            # 004155f5
    push edx                                     # 004155f9
    mov eax, dword ptr [ebp - local_4]           # 004155fa
    push eax                                     # 004155fd
    mov ecx, dword ptr [ebp - local_20]          # 004155fe
    call FUN_004159db                            # 00415601
    push 0x1                                     # 00415606
    push 0x0                                     # 00415608
    mov ecx, dword ptr [ebp - local_4]           # 0041560a
    mov edx, dword ptr [ecx + field_35]          # 0041560d
    push edx                                     # 00415610
    mov eax, dword ptr [ebp - local_4]           # 00415611
    mov ecx, dword ptr [eax + field_41]          # 00415614
    push ecx                                     # 00415617
    mov edx, dword ptr [ebp - local_18]          # 00415618
    push edx                                     # 0041561b
    mov eax, dword ptr [ebp - local_c]           # 0041561c
    push eax                                     # 0041561f
    mov ecx, dword ptr [ebp - local_20]          # 00415620
    call FUN_00416af3                            # 00415623
    mov ecx, dword ptr [ebp - local_c]           # 00415628
    {load} xor edx, edx                          # 0041562b
    mov dl, byte ptr [ecx + field_e]             # 0041562d
    cmp edx, 0x1                                 # 00415630
    jne.d8 L_00415646                            # 00415633
    # block 0x00415635: entered by fall-through of jne at 0x00415633, 6 instruction(s), ends with forward jump to 0x00415681
    mov eax, dword ptr [ebp - local_8]           # 00415635
    mov cx, word ptr [eax]                       # 00415638
    or cl, 0x2                                   # 0041563b
    mov edx, dword ptr [ebp - local_8]           # 0041563e
    mov word ptr [edx], cx                       # 00415641
    jmp.d8 L_00415681                            # 00415644
L_00415646:
    # block 0x00415646: entered by jne at 0x00415633, 5 instruction(s), ends with jne to 0x00415663 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00415646
    {load} xor ecx, ecx                          # 00415649
    mov cl, byte ptr [eax + field_e]             # 0041564b
    cmp ecx, 0x2                                 # 0041564e
    jne.d8 L_00415663                            # 00415651
    # block 0x00415653: entered by fall-through of jne at 0x00415651, 6 instruction(s), ends with forward jump to 0x00415681
    mov edx, dword ptr [ebp - local_8]           # 00415653
    mov ax, word ptr [edx]                       # 00415656
    or al, 0x4                                   # 00415659
    mov ecx, dword ptr [ebp - local_8]           # 0041565b
    mov word ptr [ecx], ax                       # 0041565e
    jmp.d8 L_00415681                            # 00415661
L_00415663:
    # block 0x00415663: entered by jne at 0x00415651, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004156de
    mov edx, dword ptr [ebp - local_14]          # 00415663
    push edx                                     # 00415666
    mov eax, dword ptr [ebp - local_10]          # 00415667
    push eax                                     # 0041566a
    push 0x541c88                                # 0041566b
    mov ecx, dword ptr [ebp - local_20]          # 00415670
    add ecx, 0x1c                                # 00415673
    push ecx                                     # 00415676
    call FUN_0050ca3e                            # 00415677
    add esp, 0x10                                # 0041567c
    jmp.d8 L_004156de                            # 0041567f
L_00415681:
    # block 0x00415681: entered by jmp at 0x00415644; jmp at 0x00415661, 13 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x004156e4
    mov edx, dword ptr [ebp - local_4]           # 00415681
    mov eax, dword ptr [edx + field_35]          # 00415684
    mov dword ptr [ebp - local_1c], eax          # 00415687
    mov ecx, dword ptr [ebp - local_1c]          # 0041568a
    push ecx                                     # 0041568d
    call FUN_0051dc6c                            # 0041568e
    add esp, 0x4                                 # 00415693
    mov edx, dword ptr [ebp - local_4]           # 00415696
    mov dword ptr [edx + field_35], 0x0          # 00415699
    mov eax, dword ptr [ebp - local_4]           # 004156a0
    mov ecx, dword ptr [ebp - local_10]          # 004156a3
    mov dword ptr [eax + field_45], ecx          # 004156a6
    jmp.d8 L_004156e4                            # 004156a9
L_004156ab:
    # block 0x004156ab: entered by jmp at 0x004156de; jmp at 0x004156e0; jmp at 0x004156e2, 13 instruction(s), calls FUN_00415011, FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004156e4
    mov edx, dword ptr [ebp - local_4]           # 004156ab
    push edx                                     # 004156ae
    mov ecx, dword ptr [ebp - local_20]          # 004156af
    call FUN_00415011                            # 004156b2
    mov eax, dword ptr [ebp - local_20]          # 004156b7
    add eax, 0x1c                                # 004156ba
    push eax                                     # 004156bd
    mov ecx, 0x583979                            # 004156be
    call FUN_004264e8                            # 004156c3
    mov dword ptr [0x63a58a], 0x4                # 004156c8
    mov ecx, 0x5cf659                            # 004156d2
    call FUN_004c97b4                            # 004156d7
    jmp.d8 L_004156e4                            # 004156dc
L_004156de:
    # block 0x004156de: entered by jmp at 0x0041567f, 1 instruction(s), ends with backward jump to 0x004156ab
    jmp.d8 L_004156ab                            # 004156de
L_004156e0:
    # block 0x004156e0: entered by jmp at 0x0041552e, 1 instruction(s), ends with backward jump to 0x004156ab
    jmp.d8 L_004156ab                            # 004156e0
L_004156e2:
    # block 0x004156e2: entered by jmp at 0x0041549c, 1 instruction(s), ends with backward jump to 0x004156ab
    jmp.d8 L_004156ab                            # 004156e2
L_004156e4:
    # block 0x004156e4: entered by jmp at 0x0041555d; jmp at 0x004155cc; jmp at 0x004156a9; jmp at 0x004156dc, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004156e4
    pop ebp                                      # 004156e6
    ret 0x4                                      # 004156e7

