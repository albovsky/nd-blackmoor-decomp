# FUN_00502440
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502440
# extent:       0x00502440-0x005025bf (383 code bytes)
# span:         0x00502440-0x005025c0 (code 383, tables 0, padding 1)
# sha256:       40f507f0259866d4bf126ce2822c5c3b5107541aaf29188be30c42482d791867
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502440
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_a0, stk_a4, stk_a8, stk_ac
# callees:      calls FUN_0050ea90, FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 142 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_a0, 0xa0  # offset +0xa0
.equ stk_a4, 0xa4  # offset +0xa4
.equ stk_a8, 0xa8  # offset +0xa8
.equ stk_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x00502440 - 0x401000
.globl FUN_00502440
FUN_00502440:
    # block 0x00502440: entry, 10 instruction(s), ends with jne to 0x00502460 (forward)
    sub esp, 0x90                                # 00502440
    push ebx                                     # 00502446
    push ebp                                     # 00502447
    mov ebp, dword ptr [esp + stk_a0]            # 00502448
    push esi                                     # 0050244f
    mov esi, dword ptr [esp + stk_a8]            # 00502450
    push edi                                     # 00502457
    test esi, esi                                # 00502458
    {load} mov eax, esi                          # 0050245a
    jne.d8 L_00502460                            # 0050245c
    # block 0x0050245e: entered by fall-through of jne at 0x0050245c, 1 instruction(s), falls into the block at 0x00502460
    {load} mov eax, ebp                          # 0050245e
L_00502460:
    # block 0x00502460: entered by jne at 0x0050245c, 13 instruction(s), calls FUN_0050ea90, ends with jle to 0x00502598 (forward)
    shl eax, 0x2                                 # 00502460
    push eax                                     # 00502463
    call FUN_0050ea90                            # 00502464
    {load} mov edx, eax                          # 00502469
    add esp, 0x4                                 # 0050246b
    mov ecx, 0x21                                # 0050246e
    {load} xor eax, eax                          # 00502473
    lea edi, [esp + stk_1c]                      # 00502475
    mov dword ptr [esp + stk_14], edx            # 00502479
    test ebp, ebp                                # 0050247d
    rep stosd dword ptr es:[edi], eax            # 0050247f
    mov dword ptr [esp + stk_10], eax            # 00502481
    jle.d32 L_00502598                           # 00502485
    # block 0x0050248b: entered by fall-through of jle at 0x00502485, 4 instruction(s), ends with forward jump to 0x005024a1
    mov ecx, dword ptr [esp + stk_a4]            # 0050248b
    {load} mov edi, edx                          # 00502492
    mov dword ptr [esp + stk_18], ecx            # 00502494
    jmp.d8 L_005024a1                            # 00502498
L_0050249a:
    # block 0x0050249a: entered by jl at 0x0050253b, 1 instruction(s), falls into the block at 0x005024a1
    mov esi, dword ptr [esp + stk_ac]            # 0050249a
L_005024a1:
    # block 0x005024a1: entered by jmp at 0x00502498, 4 instruction(s), ends with jle to 0x0050251e (forward)
    mov edx, dword ptr [esp + stk_18]            # 005024a1
    mov ecx, dword ptr [edx]                     # 005024a5
    test ecx, ecx                                # 005024a7
    jle.d8 L_0050251e                            # 005024a9
    # block 0x005024ab: entered by fall-through of jle at 0x005024a9, 4 instruction(s), ends with jge to 0x005024c4 (forward)
    mov esi, dword ptr [esp + 4*ecx + stk_1c]    # 005024ab
    lea eax, [esp + 4*ecx + stk_1c]              # 005024af
    cmp ecx, 0x20                                # 005024b3
    jge.d8 L_005024c4                            # 005024b6
    # block 0x005024b8: entered by fall-through of jge at 0x005024b6, 4 instruction(s), ends with jne to 0x005025a5 (forward)
    {load} mov edx, esi                          # 005024b8
    shr edx, cl                                  # 005024ba
    test edx, edx                                # 005024bc
    jne.d32 L_005025a5                           # 005024be
L_005024c4:
    # block 0x005024c4: entered by jge at 0x005024b6; fall-through of jne at 0x005024be, 3 instruction(s), falls into the block at 0x005024cb
    mov dword ptr [edi], esi                     # 005024c4
    add edi, 0x4                                 # 005024c6
    {load} mov edx, ecx                          # 005024c9
L_005024cb:
    # block 0x005024cb: entered by jg at 0x005024db, 3 instruction(s), ends with jne to 0x005024df (forward)
    mov ebx, dword ptr [eax]                     # 005024cb
    test bl, 0x1                                 # 005024cd
    jne.d8 L_005024df                            # 005024d0
    # block 0x005024d2: entered by fall-through of jne at 0x005024d0, 6 instruction(s), ends with jg to 0x005024cb (backward)
    inc ebx                                      # 005024d2
    dec edx                                      # 005024d3
    mov dword ptr [eax], ebx                     # 005024d4
    sub eax, 0x4                                 # 005024d6
    test edx, edx                                # 005024d9
    jg.d8 L_005024cb                             # 005024db
    # block 0x005024dd: entered by fall-through of jg at 0x005024db, 1 instruction(s), ends with forward jump to 0x005024f6
    jmp.d8 L_005024f6                            # 005024dd
L_005024df:
    # block 0x005024df: entered by jne at 0x005024d0, 2 instruction(s), ends with jne to 0x005024ea (forward)
    cmp edx, 0x1                                 # 005024df
    jne.d8 L_005024ea                            # 005024e2
    # block 0x005024e4: entered by fall-through of jne at 0x005024e2, 2 instruction(s), ends with forward jump to 0x005024f6
    inc dword ptr [esp + stk_20]                 # 005024e4
    jmp.d8 L_005024f6                            # 005024e8
L_005024ea:
    # block 0x005024ea: entered by jne at 0x005024e2, 4 instruction(s), falls into the block at 0x005024f6
    lea eax, [esp + 4*edx + stk_1c]              # 005024ea
    mov edx, dword ptr [esp + 4*edx + stk_18]    # 005024ee
    shl edx                                      # 005024f2
    mov dword ptr [eax], edx                     # 005024f4
L_005024f6:
    # block 0x005024f6: entered by jmp at 0x005024dd; jmp at 0x005024e8, 3 instruction(s), ends with jge to 0x00502525 (forward)
    inc ecx                                      # 005024f6
    cmp ecx, 0x21                                # 005024f7
    jge.d8 L_00502525                            # 005024fa
    # block 0x005024fc: entered by fall-through of jge at 0x005024fa, 1 instruction(s), falls into the block at 0x00502500
    lea eax, [esp + 4*ecx + stk_1c]              # 005024fc
L_00502500:
    # block 0x00502500: entered by jl at 0x0050251a, 5 instruction(s), ends with jne to 0x00502525 (forward)
    mov edx, dword ptr [eax]                     # 00502500
    {load} mov ebx, edx                          # 00502502
    shr ebx                                      # 00502504
    {load} cmp ebx, esi                          # 00502506
    jne.d8 L_00502525                            # 00502508
    # block 0x0050250a: entered by fall-through of jne at 0x00502508, 8 instruction(s), ends with jl to 0x00502500 (backward)
    {load} mov esi, edx                          # 0050250a
    mov edx, dword ptr [eax - field_minus_4]     # 0050250c
    shl edx                                      # 0050250f
    mov dword ptr [eax], edx                     # 00502511
    inc ecx                                      # 00502513
    add eax, 0x4                                 # 00502514
    cmp ecx, 0x21                                # 00502517
    jl.d8 L_00502500                             # 0050251a
    # block 0x0050251c: entered by fall-through of jl at 0x0050251a, 1 instruction(s), ends with forward jump to 0x00502525
    jmp.d8 L_00502525                            # 0050251c
L_0050251e:
    # block 0x0050251e: entered by jle at 0x005024a9, 2 instruction(s), ends with jne to 0x00502525 (forward)
    test esi, esi                                # 0050251e
    jne.d8 L_00502525                            # 00502520
    # block 0x00502522: entered by fall-through of jne at 0x00502520, 1 instruction(s), falls into the block at 0x00502525
    add edi, 0x4                                 # 00502522
L_00502525:
    # block 0x00502525: entered by jge at 0x005024fa; jne at 0x00502508; jmp at 0x0050251c; jne at 0x00502520, 8 instruction(s), ends with jl to 0x0050249a (backward)
    mov eax, dword ptr [esp + stk_10]            # 00502525
    mov edx, dword ptr [esp + stk_18]            # 00502529
    inc eax                                      # 0050252d
    add edx, 0x4                                 # 0050252e
    {load} cmp eax, ebp                          # 00502531
    mov dword ptr [esp + stk_10], eax            # 00502533
    mov dword ptr [esp + stk_18], edx            # 00502537
    jl.d32 L_0050249a                            # 0050253b
    # block 0x00502541: entered by fall-through of jl at 0x0050253b, 3 instruction(s), ends with jle to 0x00502598 (forward)
    mov edx, dword ptr [esp + stk_14]            # 00502541
    test ebp, ebp                                # 00502545
    jle.d8 L_00502598                            # 00502547
    # block 0x00502549: entered by fall-through of jle at 0x00502547, 3 instruction(s), falls into the block at 0x00502556
    mov ebx, dword ptr [esp + stk_a4]            # 00502549
    {load} mov edi, edx                          # 00502550
    mov dword ptr [esp + stk_10], ebp            # 00502552
L_00502556:
    # block 0x00502556: entered by jne at 0x00502592, 5 instruction(s), ends with jle to 0x00502572 (forward)
    mov edx, dword ptr [ebx]                     # 00502556
    {load} xor eax, eax                          # 00502558
    {load} xor ecx, ecx                          # 0050255a
    test edx, edx                                # 0050255c
    jle.d8 L_00502572                            # 0050255e
    # block 0x00502560: entered by fall-through of jle at 0x0050255e, 1 instruction(s), falls into the block at 0x00502562
    mov esi, dword ptr [edi]                     # 00502560
L_00502562:
    # block 0x00502562: entered by jl at 0x00502570, 8 instruction(s), ends with jl to 0x00502562 (backward)
    {load} mov ebp, esi                          # 00502562
    {load} add eax, eax                          # 00502564
    shr ebp, cl                                  # 00502566
    and ebp, 0x1                                 # 00502568
    {load} or eax, ebp                           # 0050256b
    inc ecx                                      # 0050256d
    {load} cmp ecx, edx                          # 0050256e
    jl.d8 L_00502562                             # 00502570
L_00502572:
    # block 0x00502572: entered by jle at 0x0050255e; fall-through of jl at 0x00502570, 3 instruction(s), ends with je to 0x00502581 (forward)
    mov ecx, dword ptr [esp + stk_ac]            # 00502572
    test ecx, ecx                                # 00502579
    je.d8 L_00502581                             # 0050257b
    # block 0x0050257d: entered by fall-through of je at 0x0050257b, 2 instruction(s), ends with je to 0x00502586 (forward)
    test edx, edx                                # 0050257d
    je.d8 L_00502586                             # 0050257f
L_00502581:
    # block 0x00502581: entered by je at 0x0050257b; fall-through of je at 0x0050257f, 2 instruction(s), falls into the block at 0x00502586
    mov dword ptr [edi], eax                     # 00502581
    add edi, 0x4                                 # 00502583
L_00502586:
    # block 0x00502586: entered by je at 0x0050257f, 5 instruction(s), ends with jne to 0x00502556 (backward)
    mov eax, dword ptr [esp + stk_10]            # 00502586
    add ebx, 0x4                                 # 0050258a
    dec eax                                      # 0050258d
    mov dword ptr [esp + stk_10], eax            # 0050258e
    jne.d8 L_00502556                            # 00502592
    # block 0x00502594: entered by fall-through of jne at 0x00502592, 1 instruction(s), falls into the block at 0x00502598
    mov edx, dword ptr [esp + stk_14]            # 00502594
L_00502598:
    # block 0x00502598: entered by jle at 0x00502485; jle at 0x00502547, 7 instruction(s), ends with ret
    pop edi                                      # 00502598
    pop esi                                      # 00502599
    pop ebp                                      # 0050259a
    {load} mov eax, edx                          # 0050259b
    pop ebx                                      # 0050259d
    add esp, 0x90                                # 0050259e
    ret                                          # 005025a4
L_005025a5:
    # block 0x005025a5: entered by jne at 0x005024be, 11 instruction(s), calls FUN_0050e936, ends with ret
    mov eax, dword ptr [esp + stk_14]            # 005025a5
    push eax                                     # 005025a9
    call FUN_0050e936                            # 005025aa
    add esp, 0x4                                 # 005025af
    {load} xor eax, eax                          # 005025b2
    pop edi                                      # 005025b4
    pop esi                                      # 005025b5
    pop ebp                                      # 005025b6
    pop ebx                                      # 005025b7
    add esp, 0x90                                # 005025b8
    ret                                          # 005025be

# --- data items (not part of the function) -------------------------
.org 0x005025bf - 0x401000
PAD_005025bf:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

