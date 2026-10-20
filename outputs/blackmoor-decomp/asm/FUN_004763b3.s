# FUN_004763b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004763b3
# extent:       0x004763b3-0x00476a25 (1650 code bytes)
# span:         0x004763b3-0x00476a25 (code 1650, tables 0, padding 0)
# sha256:       435160cbfa29318b25157a320bab8b028604360d76dcc24e3ac8a61ec90439dc
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_match_puzzle_check_for_match
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_e4_runtime.c:268 says "0x4763b3: the runs through the piece at (col, row)."
# name-note:    CheckForMatch(col, row): finds the runs through the piece at a cell in the Match puzzle.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1, field_2, field_22, field_30, field_644, field_656, field_658, field_65e, field_801, field_8c2, field_8c6, field_8ce and 4 more; [ecx + n] field_1, field_2, field_30, field_44, field_65a, field_65c, field_65e, field_8c2, field_8c6, field_8ce, field_8d0, field_8d2 and 2 more; [edx + n] field_2, field_30, field_42, field_644, field_656, field_658, field_65a, field_65c, field_801, field_8c2, field_8c6, field_8ce and 3 more
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 408 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_22, 0x22  # offset +0x22
.equ field_30, 0x30  # offset +0x30
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_644, 0x644  # offset +0x644
.equ field_656, 0x656  # offset +0x656
.equ field_658, 0x658  # offset +0x658
.equ field_65a, 0x65a  # offset +0x65a
.equ field_65c, 0x65c  # offset +0x65c
.equ field_65e, 0x65e  # offset +0x65e
.equ field_801, 0x801  # offset +0x801
.equ field_8c2, 0x8c2  # offset +0x8c2
.equ field_8c6, 0x8c6  # offset +0x8c6
.equ field_8ce, 0x8ce  # offset +0x8ce
.equ field_8d0, 0x8d0  # offset +0x8d0
.equ field_8d2, 0x8d2  # offset +0x8d2
.equ field_8d4, 0x8d4  # offset +0x8d4
.equ field_8d6, 0x8d6  # offset +0x8d6
.equ field_8d7, 0x8d7  # offset +0x8d7

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004763b3 - 0x401000
.globl FUN_004763b3
FUN_004763b3:
    # block 0x004763b3: entry, 12 instruction(s), ends with je to 0x00476404 (forward)
    push ebp                                     # 004763b3
    {load} mov ebp, esp                          # 004763b4
    sub esp, 0x14                                # 004763b6
    mov dword ptr [ebp - local_14], ecx          # 004763b9
    mov eax, dword ptr [ebp - local_14]          # 004763bc
    movsx ecx, word ptr [eax + field_22]         # 004763bf
    imul ecx, ecx, 0x8d                          # 004763c3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004763c9
    mov dword ptr [ebp - local_4], edx           # 004763cf
    movsx eax, word ptr [0x63a4cd]               # 004763d2
    test eax, eax                                # 004763d9
    je.d8 L_00476404                             # 004763db
    # block 0x004763dd: entered by fall-through of je at 0x004763db, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00476404
    mov ecx, dword ptr [ebp + arg_8]             # 004763dd
    push ecx                                     # 004763e0
    mov edx, dword ptr [ebp + arg_c]             # 004763e1
    push edx                                     # 004763e4
    push 0x54c868                                # 004763e5
    push 0x63888b                                # 004763ea
    call FUN_0050ca3e                            # 004763ef
    add esp, 0x10                                # 004763f4
    push 0x63888b                                # 004763f7
    call FUN_0044a2b7                            # 004763fc
    add esp, 0x4                                 # 00476401
L_00476404:
    # block 0x00476404: entered by je at 0x004763db, 16 instruction(s), falls into the block at 0x00476449
    mov eax, dword ptr [ebp - local_14]          # 00476404
    mov byte ptr [eax + field_8d6], 0x0          # 00476407
    mov ecx, dword ptr [ebp - local_14]          # 0047640e
    mov byte ptr [ecx + field_8d7], 0x0          # 00476411
    mov edx, dword ptr [ebp + arg_c]             # 00476418
    imul edx, edx, 0xc8                          # 0047641b
    mov eax, dword ptr [ebp - local_14]          # 00476421
    lea ecx, [eax + edx + field_30]              # 00476424
    mov edx, dword ptr [ebp + arg_8]             # 00476428
    imul edx, edx, 0x14                          # 0047642b
    mov ax, word ptr [ecx + edx + field_2]       # 0047642e
    mov word ptr [ebp - local_c], ax             # 00476433
    mov ecx, dword ptr [ebp - local_14]          # 00476437
    mov dx, word ptr [ebp + arg_c]               # 0047643a
    mov word ptr [ecx + field_8ce], dx           # 0047643e
    mov byte ptr [ebp - local_10], 0x1           # 00476445
L_00476449:
    # block 0x00476449: entered by jmp at 0x004764c7, 4 instruction(s), ends with je to 0x004764c9 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00476449
    and eax, 0xff                                # 0047644c
    test eax, eax                                # 00476451
    je.d8 L_004764c9                             # 00476453
    # block 0x00476455: entered by fall-through of je at 0x00476453, 4 instruction(s), ends with jne to 0x00476469 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00476455
    movsx edx, word ptr [ecx + field_8ce]        # 00476458
    test edx, edx                                # 0047645f
    jne.d8 L_00476469                            # 00476461
    # block 0x00476463: entered by fall-through of jne at 0x00476461, 2 instruction(s), ends with forward jump to 0x004764c7
    mov byte ptr [ebp - local_10], 0x0           # 00476463
    jmp.d8 L_004764c7                            # 00476467
L_00476469:
    # block 0x00476469: entered by jne at 0x00476461, 16 instruction(s), ends with je to 0x004764c7 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00476469
    mov cx, word ptr [eax + field_8ce]           # 0047646c
    sub cx, 0x1                                  # 00476473
    mov edx, dword ptr [ebp - local_14]          # 00476477
    mov word ptr [edx + field_8ce], cx           # 0047647a
    movsx eax, word ptr [ebp - local_c]          # 00476481
    mov ecx, dword ptr [ebp - local_14]          # 00476485
    movsx edx, word ptr [ecx + field_8ce]        # 00476488
    imul edx, edx, 0xc8                          # 0047648f
    mov ecx, dword ptr [ebp - local_14]          # 00476495
    lea edx, [ecx + edx + field_30]              # 00476498
    mov ecx, dword ptr [ebp + arg_8]             # 0047649c
    imul ecx, ecx, 0x14                          # 0047649f
    movsx edx, word ptr [edx + ecx + field_2]    # 004764a2
    {load} cmp eax, edx                          # 004764a7
    je.d8 L_004764c7                             # 004764a9
    # block 0x004764ab: entered by fall-through of je at 0x004764a9, 6 instruction(s), falls into the block at 0x004764c7
    mov byte ptr [ebp - local_10], 0x0           # 004764ab
    mov eax, dword ptr [ebp - local_14]          # 004764af
    mov cx, word ptr [eax + field_8ce]           # 004764b2
    add cx, 0x1                                  # 004764b9
    mov edx, dword ptr [ebp - local_14]          # 004764bd
    mov word ptr [edx + field_8ce], cx           # 004764c0
L_004764c7:
    # block 0x004764c7: entered by jmp at 0x00476467; je at 0x004764a9, 1 instruction(s), ends with backward jump to 0x00476449
    jmp.d8 L_00476449                            # 004764c7
L_004764c9:
    # block 0x004764c9: entered by je at 0x00476453, 4 instruction(s), falls into the block at 0x004764db
    mov eax, dword ptr [ebp - local_14]          # 004764c9
    mov cx, word ptr [ebp + arg_c]               # 004764cc
    mov word ptr [eax + field_8d0], cx           # 004764d0
    mov byte ptr [ebp - local_10], 0x1           # 004764d7
L_004764db:
    # block 0x004764db: entered by jmp at 0x00476568, 4 instruction(s), ends with je to 0x0047656d (forward)
    mov edx, dword ptr [ebp - local_10]          # 004764db
    and edx, 0xff                                # 004764de
    test edx, edx                                # 004764e4
    je.d32 L_0047656d                            # 004764e6
    # block 0x004764ec: entered by fall-through of je at 0x004764e6, 7 instruction(s), ends with jne to 0x0047650a (forward)
    mov eax, dword ptr [ebp - local_14]          # 004764ec
    movsx ecx, word ptr [eax + field_8d0]        # 004764ef
    mov edx, dword ptr [ebp - local_4]           # 004764f6
    movsx eax, word ptr [edx + field_42]         # 004764f9
    sub eax, 0x1                                 # 004764fd
    {load} cmp ecx, eax                          # 00476500
    jne.d8 L_0047650a                            # 00476502
    # block 0x00476504: entered by fall-through of jne at 0x00476502, 2 instruction(s), ends with forward jump to 0x00476568
    mov byte ptr [ebp - local_10], 0x0           # 00476504
    jmp.d8 L_00476568                            # 00476508
L_0047650a:
    # block 0x0047650a: entered by jne at 0x00476502, 16 instruction(s), ends with je to 0x00476568 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0047650a
    mov dx, word ptr [ecx + field_8d0]           # 0047650d
    add dx, 0x1                                  # 00476514
    mov eax, dword ptr [ebp - local_14]          # 00476518
    mov word ptr [eax + field_8d0], dx           # 0047651b
    movsx ecx, word ptr [ebp - local_c]          # 00476522
    mov edx, dword ptr [ebp - local_14]          # 00476526
    movsx eax, word ptr [edx + field_8d0]        # 00476529
    imul eax, eax, 0xc8                          # 00476530
    mov edx, dword ptr [ebp - local_14]          # 00476536
    lea eax, [edx + eax + field_30]              # 00476539
    mov edx, dword ptr [ebp + arg_8]             # 0047653d
    imul edx, edx, 0x14                          # 00476540
    movsx eax, word ptr [eax + edx + field_2]    # 00476543
    {load} cmp ecx, eax                          # 00476548
    je.d8 L_00476568                             # 0047654a
    # block 0x0047654c: entered by fall-through of je at 0x0047654a, 6 instruction(s), falls into the block at 0x00476568
    mov byte ptr [ebp - local_10], 0x0           # 0047654c
    mov ecx, dword ptr [ebp - local_14]          # 00476550
    mov dx, word ptr [ecx + field_8d0]           # 00476553
    sub dx, 0x1                                  # 0047655a
    mov eax, dword ptr [ebp - local_14]          # 0047655e
    mov word ptr [eax + field_8d0], dx           # 00476561
L_00476568:
    # block 0x00476568: entered by jmp at 0x00476508; je at 0x0047654a, 1 instruction(s), ends with backward jump to 0x004764db
    jmp.d32 L_004764db                           # 00476568
L_0047656d:
    # block 0x0047656d: entered by je at 0x004764e6, 4 instruction(s), falls into the block at 0x0047657f
    mov ecx, dword ptr [ebp - local_14]          # 0047656d
    mov dx, word ptr [ebp + arg_8]               # 00476570
    mov word ptr [ecx + field_8d2], dx           # 00476574
    mov byte ptr [ebp - local_10], 0x1           # 0047657b
L_0047657f:
    # block 0x0047657f: entered by jmp at 0x004765fd, 4 instruction(s), ends with je to 0x004765ff (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047657f
    and eax, 0xff                                # 00476582
    test eax, eax                                # 00476587
    je.d8 L_004765ff                             # 00476589
    # block 0x0047658b: entered by fall-through of je at 0x00476589, 4 instruction(s), ends with jne to 0x0047659f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0047658b
    movsx edx, word ptr [ecx + field_8d2]        # 0047658e
    test edx, edx                                # 00476595
    jne.d8 L_0047659f                            # 00476597
    # block 0x00476599: entered by fall-through of jne at 0x00476597, 2 instruction(s), ends with forward jump to 0x004765fd
    mov byte ptr [ebp - local_10], 0x0           # 00476599
    jmp.d8 L_004765fd                            # 0047659d
L_0047659f:
    # block 0x0047659f: entered by jne at 0x00476597, 16 instruction(s), ends with je to 0x004765fd (forward)
    mov eax, dword ptr [ebp - local_14]          # 0047659f
    mov cx, word ptr [eax + field_8d2]           # 004765a2
    sub cx, 0x1                                  # 004765a9
    mov edx, dword ptr [ebp - local_14]          # 004765ad
    mov word ptr [edx + field_8d2], cx           # 004765b0
    movsx eax, word ptr [ebp - local_c]          # 004765b7
    mov ecx, dword ptr [ebp + arg_c]             # 004765bb
    imul ecx, ecx, 0xc8                          # 004765be
    mov edx, dword ptr [ebp - local_14]          # 004765c4
    lea ecx, [edx + ecx + field_30]              # 004765c7
    mov edx, dword ptr [ebp - local_14]          # 004765cb
    movsx edx, word ptr [edx + field_8d2]        # 004765ce
    imul edx, edx, 0x14                          # 004765d5
    movsx ecx, word ptr [ecx + edx + field_2]    # 004765d8
    {load} cmp eax, ecx                          # 004765dd
    je.d8 L_004765fd                             # 004765df
    # block 0x004765e1: entered by fall-through of je at 0x004765df, 6 instruction(s), falls into the block at 0x004765fd
    mov byte ptr [ebp - local_10], 0x0           # 004765e1
    mov edx, dword ptr [ebp - local_14]          # 004765e5
    mov ax, word ptr [edx + field_8d2]           # 004765e8
    .insn 0x66, 0x05, 0x0001{:u16}               # 004765ef
    mov ecx, dword ptr [ebp - local_14]          # 004765f3
    mov word ptr [ecx + field_8d2], ax           # 004765f6
L_004765fd:
    # block 0x004765fd: entered by jmp at 0x0047659d; je at 0x004765df, 1 instruction(s), ends with backward jump to 0x0047657f
    jmp.d8 L_0047657f                            # 004765fd
L_004765ff:
    # block 0x004765ff: entered by je at 0x00476589, 4 instruction(s), falls into the block at 0x00476611
    mov edx, dword ptr [ebp - local_14]          # 004765ff
    mov ax, word ptr [ebp + arg_8]               # 00476602
    mov word ptr [edx + field_8d4], ax           # 00476606
    mov byte ptr [ebp - local_10], 0x1           # 0047660d
L_00476611:
    # block 0x00476611: entered by jmp at 0x0047669e, 4 instruction(s), ends with je to 0x004766a3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00476611
    and ecx, 0xff                                # 00476614
    test ecx, ecx                                # 0047661a
    je.d32 L_004766a3                            # 0047661c
    # block 0x00476622: entered by fall-through of je at 0x0047661c, 7 instruction(s), ends with jne to 0x00476640 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00476622
    movsx eax, word ptr [edx + field_8d4]        # 00476625
    mov ecx, dword ptr [ebp - local_4]           # 0047662c
    movsx edx, word ptr [ecx + field_44]         # 0047662f
    sub edx, 0x1                                 # 00476633
    {load} cmp eax, edx                          # 00476636
    jne.d8 L_00476640                            # 00476638
    # block 0x0047663a: entered by fall-through of jne at 0x00476638, 2 instruction(s), ends with forward jump to 0x0047669e
    mov byte ptr [ebp - local_10], 0x0           # 0047663a
    jmp.d8 L_0047669e                            # 0047663e
L_00476640:
    # block 0x00476640: entered by jne at 0x00476638, 16 instruction(s), ends with je to 0x0047669e (forward)
    mov eax, dword ptr [ebp - local_14]          # 00476640
    mov cx, word ptr [eax + field_8d4]           # 00476643
    add cx, 0x1                                  # 0047664a
    mov edx, dword ptr [ebp - local_14]          # 0047664e
    mov word ptr [edx + field_8d4], cx           # 00476651
    movsx eax, word ptr [ebp - local_c]          # 00476658
    mov ecx, dword ptr [ebp + arg_c]             # 0047665c
    imul ecx, ecx, 0xc8                          # 0047665f
    mov edx, dword ptr [ebp - local_14]          # 00476665
    lea ecx, [edx + ecx + field_30]              # 00476668
    mov edx, dword ptr [ebp - local_14]          # 0047666c
    movsx edx, word ptr [edx + field_8d4]        # 0047666f
    imul edx, edx, 0x14                          # 00476676
    movsx ecx, word ptr [ecx + edx + field_2]    # 00476679
    {load} cmp eax, ecx                          # 0047667e
    je.d8 L_0047669e                             # 00476680
    # block 0x00476682: entered by fall-through of je at 0x00476680, 6 instruction(s), falls into the block at 0x0047669e
    mov byte ptr [ebp - local_10], 0x0           # 00476682
    mov edx, dword ptr [ebp - local_14]          # 00476686
    mov ax, word ptr [edx + field_8d4]           # 00476689
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00476690
    mov ecx, dword ptr [ebp - local_14]          # 00476694
    mov word ptr [ecx + field_8d4], ax           # 00476697
L_0047669e:
    # block 0x0047669e: entered by jmp at 0x0047663e; je at 0x00476680, 1 instruction(s), ends with backward jump to 0x00476611
    jmp.d32 L_00476611                           # 0047669e
L_004766a3:
    # block 0x004766a3: entered by je at 0x0047661c, 7 instruction(s), ends with jl to 0x00476861 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004766a3
    movsx eax, word ptr [edx + field_8d0]        # 004766a6
    mov ecx, dword ptr [ebp - local_14]          # 004766ad
    movsx edx, word ptr [ecx + field_8ce]        # 004766b0
    {load} sub eax, edx                          # 004766b7
    cmp eax, 0x2                                 # 004766b9
    jl.d32 L_00476861                            # 004766bc
    # block 0x004766c2: entered by fall-through of jl at 0x004766bc, 6 instruction(s), ends with forward jump to 0x004766e8
    mov eax, dword ptr [ebp - local_14]          # 004766c2
    mov byte ptr [eax + field_8d6], 0x1          # 004766c5
    mov ecx, dword ptr [ebp - local_14]          # 004766cc
    mov dx, word ptr [ecx + field_8ce]           # 004766cf
    mov word ptr [ebp - local_8], dx             # 004766d6
    jmp.d8 L_004766e8                            # 004766da
L_004766dc:
    # block 0x004766dc: entered by jmp at 0x00476734, 3 instruction(s), falls into the block at 0x004766e8
    mov ax, word ptr [ebp - local_8]             # 004766dc
    .insn 0x66, 0x05, 0x0001{:u16}               # 004766e0
    mov word ptr [ebp - local_8], ax             # 004766e4
L_004766e8:
    # block 0x004766e8: entered by jmp at 0x004766da, 5 instruction(s), ends with jg to 0x00476736 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004766e8
    mov edx, dword ptr [ebp - local_14]          # 004766ec
    movsx eax, word ptr [edx + field_8d0]        # 004766ef
    {load} cmp ecx, eax                          # 004766f6
    jg.d8 L_00476736                             # 004766f8
    # block 0x004766fa: entered by fall-through of jg at 0x004766f8, 15 instruction(s), ends with backward jump to 0x004766dc
    movsx ecx, word ptr [ebp - local_8]          # 004766fa
    imul ecx, ecx, 0xc8                          # 004766fe
    mov edx, dword ptr [ebp - local_14]          # 00476704
    lea eax, [edx + ecx + field_30]              # 00476707
    mov ecx, dword ptr [ebp + arg_8]             # 0047670b
    imul ecx, ecx, 0x14                          # 0047670e
    mov byte ptr [eax + ecx + field_1], 0x1      # 00476711
    mov edx, dword ptr [ebp - local_4]           # 00476716
    movsx eax, word ptr [edx + field_644]        # 00476719
    mov ecx, dword ptr [ebp - local_14]          # 00476720
    mov edx, dword ptr [ecx + field_8c2]         # 00476723
    {load} add edx, eax                          # 00476729
    mov eax, dword ptr [ebp - local_14]          # 0047672b
    mov dword ptr [eax + field_8c2], edx         # 0047672e
    jmp.d8 L_004766dc                            # 00476734
L_00476736:
    # block 0x00476736: entered by jg at 0x004766f8, 7 instruction(s), ends with jne to 0x0047677a (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00476736
    movsx edx, word ptr [ecx + field_8d4]        # 00476739
    mov eax, dword ptr [ebp - local_14]          # 00476740
    movsx ecx, word ptr [eax + field_8d2]        # 00476743
    {load} sub edx, ecx                          # 0047674a
    cmp edx, 0x2                                 # 0047674c
    jne.d8 L_0047677a                            # 0047674f
    # block 0x00476751: entered by fall-through of jne at 0x0047674f, 9 instruction(s), ends with forward jump to 0x00476836
    mov edx, dword ptr [ebp - local_4]           # 00476751
    movsx eax, word ptr [edx + field_656]        # 00476754
    imul eax, eax, 0x3e8                         # 0047675b
    mov ecx, dword ptr [ebp - local_14]          # 00476761
    mov edx, dword ptr [ecx + field_8c6]         # 00476764
    {load} add edx, eax                          # 0047676a
    mov eax, dword ptr [ebp - local_14]          # 0047676c
    mov dword ptr [eax + field_8c6], edx         # 0047676f
    jmp.d32 L_00476836                           # 00476775
L_0047677a:
    # block 0x0047677a: entered by jne at 0x0047674f, 7 instruction(s), ends with jne to 0x004767d9 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0047677a
    movsx edx, word ptr [ecx + field_8d0]        # 0047677d
    mov eax, dword ptr [ebp - local_14]          # 00476784
    movsx ecx, word ptr [eax + field_8ce]        # 00476787
    {load} sub edx, ecx                          # 0047678e
    cmp edx, 0x3                                 # 00476790
    jne.d8 L_004767d9                            # 00476793
    # block 0x00476795: entered by fall-through of jne at 0x00476793, 16 instruction(s), ends with forward jump to 0x00476836
    mov edx, dword ptr [ebp - local_4]           # 00476795
    movsx eax, word ptr [edx + field_658]        # 00476798
    mov ecx, dword ptr [ebp - local_14]          # 0047679f
    mov edx, dword ptr [ecx + field_8c2]         # 004767a2
    {load} add edx, eax                          # 004767a8
    mov eax, dword ptr [ebp - local_14]          # 004767aa
    mov dword ptr [eax + field_8c2], edx         # 004767ad
    mov ecx, dword ptr [ebp - local_4]           # 004767b3
    movsx edx, word ptr [ecx + field_65a]        # 004767b6
    imul edx, edx, 0x3e8                         # 004767bd
    mov eax, dword ptr [ebp - local_14]          # 004767c3
    mov ecx, dword ptr [eax + field_8c6]         # 004767c6
    {load} add ecx, edx                          # 004767cc
    mov edx, dword ptr [ebp - local_14]          # 004767ce
    mov dword ptr [edx + field_8c6], ecx         # 004767d1
    jmp.d8 L_00476836                            # 004767d7
L_004767d9:
    # block 0x004767d9: entered by jne at 0x00476793, 7 instruction(s), ends with jne to 0x00476836 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004767d9
    movsx ecx, word ptr [eax + field_8d0]        # 004767dc
    mov edx, dword ptr [ebp - local_14]          # 004767e3
    movsx eax, word ptr [edx + field_8ce]        # 004767e6
    {load} sub ecx, eax                          # 004767ed
    cmp ecx, 0x4                                 # 004767ef
    jne.d8 L_00476836                            # 004767f2
    # block 0x004767f4: entered by fall-through of jne at 0x004767f2, 15 instruction(s), falls into the block at 0x00476836
    mov ecx, dword ptr [ebp - local_4]           # 004767f4
    movsx edx, word ptr [ecx + field_65c]        # 004767f7
    mov eax, dword ptr [ebp - local_14]          # 004767fe
    mov ecx, dword ptr [eax + field_8c2]         # 00476801
    {load} add ecx, edx                          # 00476807
    mov edx, dword ptr [ebp - local_14]          # 00476809
    mov dword ptr [edx + field_8c2], ecx         # 0047680c
    mov eax, dword ptr [ebp - local_4]           # 00476812
    movsx ecx, word ptr [eax + field_65e]        # 00476815
    imul ecx, ecx, 0x3e8                         # 0047681c
    mov edx, dword ptr [ebp - local_14]          # 00476822
    mov eax, dword ptr [edx + field_8c6]         # 00476825
    {load} add eax, ecx                          # 0047682b
    mov ecx, dword ptr [ebp - local_14]          # 0047682d
    mov dword ptr [ecx + field_8c6], eax         # 00476830
L_00476836:
    # block 0x00476836: entered by jmp at 0x00476775; jmp at 0x004767d7; jne at 0x004767f2, 11 instruction(s), calls FUN_0050ca3e, falls into the block at 0x00476861
    mov edx, dword ptr [ebp - local_14]          # 00476836
    mov eax, dword ptr [edx + field_8c2]         # 00476839
    push eax                                     # 0047683f
    push 0x54c898                                # 00476840
    mov ecx, dword ptr [ebp - local_14]          # 00476845
    add ecx, 0x835                               # 00476848
    push ecx                                     # 0047684e
    call FUN_0050ca3e                            # 0047684f
    add esp, 0xc                                 # 00476854
    mov edx, dword ptr [ebp - local_14]          # 00476857
    mov byte ptr [edx + field_801], 0x1          # 0047685a
L_00476861:
    # block 0x00476861: entered by jl at 0x004766bc, 7 instruction(s), ends with jl to 0x00476a1f (forward)
    mov eax, dword ptr [ebp - local_14]          # 00476861
    movsx ecx, word ptr [eax + field_8d4]        # 00476864
    mov edx, dword ptr [ebp - local_14]          # 0047686b
    movsx eax, word ptr [edx + field_8d2]        # 0047686e
    {load} sub ecx, eax                          # 00476875
    cmp ecx, 0x2                                 # 00476877
    jl.d32 L_00476a1f                            # 0047687a
    # block 0x00476880: entered by fall-through of jl at 0x0047687a, 6 instruction(s), ends with forward jump to 0x004768a6
    mov ecx, dword ptr [ebp - local_14]          # 00476880
    mov byte ptr [ecx + field_8d7], 0x1          # 00476883
    mov edx, dword ptr [ebp - local_14]          # 0047688a
    mov ax, word ptr [edx + field_8d2]           # 0047688d
    mov word ptr [ebp - local_8], ax             # 00476894
    jmp.d8 L_004768a6                            # 00476898
L_0047689a:
    # block 0x0047689a: entered by jmp at 0x004768f2, 3 instruction(s), falls into the block at 0x004768a6
    mov cx, word ptr [ebp - local_8]             # 0047689a
    add cx, 0x1                                  # 0047689e
    mov word ptr [ebp - local_8], cx             # 004768a2
L_004768a6:
    # block 0x004768a6: entered by jmp at 0x00476898, 5 instruction(s), ends with jg to 0x004768f4 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004768a6
    mov eax, dword ptr [ebp - local_14]          # 004768aa
    movsx ecx, word ptr [eax + field_8d4]        # 004768ad
    {load} cmp edx, ecx                          # 004768b4
    jg.d8 L_004768f4                             # 004768b6
    # block 0x004768b8: entered by fall-through of jg at 0x004768b6, 15 instruction(s), ends with backward jump to 0x0047689a
    mov edx, dword ptr [ebp + arg_c]             # 004768b8
    imul edx, edx, 0xc8                          # 004768bb
    mov eax, dword ptr [ebp - local_14]          # 004768c1
    lea ecx, [eax + edx + field_30]              # 004768c4
    movsx edx, word ptr [ebp - local_8]          # 004768c8
    imul edx, edx, 0x14                          # 004768cc
    mov byte ptr [ecx + edx + field_1], 0x1      # 004768cf
    mov eax, dword ptr [ebp - local_4]           # 004768d4
    movsx ecx, word ptr [eax + field_644]        # 004768d7
    mov edx, dword ptr [ebp - local_14]          # 004768de
    mov eax, dword ptr [edx + field_8c2]         # 004768e1
    {load} add eax, ecx                          # 004768e7
    mov ecx, dword ptr [ebp - local_14]          # 004768e9
    mov dword ptr [ecx + field_8c2], eax         # 004768ec
    jmp.d8 L_0047689a                            # 004768f2
L_004768f4:
    # block 0x004768f4: entered by jg at 0x004768b6, 7 instruction(s), ends with jne to 0x00476938 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004768f4
    movsx eax, word ptr [edx + field_8d4]        # 004768f7
    mov ecx, dword ptr [ebp - local_14]          # 004768fe
    movsx edx, word ptr [ecx + field_8d2]        # 00476901
    {load} sub eax, edx                          # 00476908
    cmp eax, 0x2                                 # 0047690a
    jne.d8 L_00476938                            # 0047690d
    # block 0x0047690f: entered by fall-through of jne at 0x0047690d, 9 instruction(s), ends with forward jump to 0x004769f4
    mov eax, dword ptr [ebp - local_4]           # 0047690f
    movsx ecx, word ptr [eax + field_656]        # 00476912
    imul ecx, ecx, 0x3e8                         # 00476919
    mov edx, dword ptr [ebp - local_14]          # 0047691f
    mov eax, dword ptr [edx + field_8c6]         # 00476922
    {load} add eax, ecx                          # 00476928
    mov ecx, dword ptr [ebp - local_14]          # 0047692a
    mov dword ptr [ecx + field_8c6], eax         # 0047692d
    jmp.d32 L_004769f4                           # 00476933
L_00476938:
    # block 0x00476938: entered by jne at 0x0047690d, 7 instruction(s), ends with jne to 0x00476997 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00476938
    movsx eax, word ptr [edx + field_8d4]        # 0047693b
    mov ecx, dword ptr [ebp - local_14]          # 00476942
    movsx edx, word ptr [ecx + field_8d2]        # 00476945
    {load} sub eax, edx                          # 0047694c
    cmp eax, 0x3                                 # 0047694e
    jne.d8 L_00476997                            # 00476951
    # block 0x00476953: entered by fall-through of jne at 0x00476951, 16 instruction(s), ends with forward jump to 0x004769f4
    mov eax, dword ptr [ebp - local_4]           # 00476953
    movsx ecx, word ptr [eax + field_658]        # 00476956
    mov edx, dword ptr [ebp - local_14]          # 0047695d
    mov eax, dword ptr [edx + field_8c2]         # 00476960
    {load} add eax, ecx                          # 00476966
    mov ecx, dword ptr [ebp - local_14]          # 00476968
    mov dword ptr [ecx + field_8c2], eax         # 0047696b
    mov edx, dword ptr [ebp - local_4]           # 00476971
    movsx eax, word ptr [edx + field_65a]        # 00476974
    imul eax, eax, 0x3e8                         # 0047697b
    mov ecx, dword ptr [ebp - local_14]          # 00476981
    mov edx, dword ptr [ecx + field_8c6]         # 00476984
    {load} add edx, eax                          # 0047698a
    mov eax, dword ptr [ebp - local_14]          # 0047698c
    mov dword ptr [eax + field_8c6], edx         # 0047698f
    jmp.d8 L_004769f4                            # 00476995
L_00476997:
    # block 0x00476997: entered by jne at 0x00476951, 7 instruction(s), ends with jne to 0x004769f4 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00476997
    movsx edx, word ptr [ecx + field_8d4]        # 0047699a
    mov eax, dword ptr [ebp - local_14]          # 004769a1
    movsx ecx, word ptr [eax + field_8d2]        # 004769a4
    {load} sub edx, ecx                          # 004769ab
    cmp edx, 0x4                                 # 004769ad
    jne.d8 L_004769f4                            # 004769b0
    # block 0x004769b2: entered by fall-through of jne at 0x004769b0, 15 instruction(s), falls into the block at 0x004769f4
    mov edx, dword ptr [ebp - local_4]           # 004769b2
    movsx eax, word ptr [edx + field_65c]        # 004769b5
    mov ecx, dword ptr [ebp - local_14]          # 004769bc
    mov edx, dword ptr [ecx + field_8c2]         # 004769bf
    {load} add edx, eax                          # 004769c5
    mov eax, dword ptr [ebp - local_14]          # 004769c7
    mov dword ptr [eax + field_8c2], edx         # 004769ca
    mov ecx, dword ptr [ebp - local_4]           # 004769d0
    movsx edx, word ptr [ecx + field_65e]        # 004769d3
    imul edx, edx, 0x3e8                         # 004769da
    mov eax, dword ptr [ebp - local_14]          # 004769e0
    mov ecx, dword ptr [eax + field_8c6]         # 004769e3
    {load} add ecx, edx                          # 004769e9
    mov edx, dword ptr [ebp - local_14]          # 004769eb
    mov dword ptr [edx + field_8c6], ecx         # 004769ee
L_004769f4:
    # block 0x004769f4: entered by jmp at 0x00476933; jmp at 0x00476995; jne at 0x004769b0, 11 instruction(s), calls FUN_0050ca3e, falls into the block at 0x00476a1f
    mov eax, dword ptr [ebp - local_14]          # 004769f4
    mov ecx, dword ptr [eax + field_8c2]         # 004769f7
    push ecx                                     # 004769fd
    push 0x54c89c                                # 004769fe
    mov edx, dword ptr [ebp - local_14]          # 00476a03
    add edx, 0x835                               # 00476a06
    push edx                                     # 00476a0c
    call FUN_0050ca3e                            # 00476a0d
    add esp, 0xc                                 # 00476a12
    mov eax, dword ptr [ebp - local_14]          # 00476a15
    mov byte ptr [eax + field_801], 0x1          # 00476a18
L_00476a1f:
    # block 0x00476a1f: entered by jl at 0x0047687a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00476a1f
    pop ebp                                      # 00476a21
    ret 0x8                                      # 00476a22

