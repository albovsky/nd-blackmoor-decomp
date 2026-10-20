# FUN_004b7563
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7563
# extent:       0x004b7563-0x004b777d (538 code bytes)
# span:         0x004b7563-0x004b777d (code 538, tables 0, padding 0)
# sha256:       7788f82c4d9db6c817a0523690e4a30bc7392d9e20a4840404ab5e1589be7db2
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7563_click_27bf_27c1
# naming:       native port src/original_methods_fl24b.c:m4b7563_click_27bf_27c1 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b7563_click_27bf_27c1 (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 440 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_21, field_23, field_25, field_26, field_31, field_33, field_35, field_310; [ecx + n] field_21, field_23, field_25, field_31, field_33, field_36, field_341; [edx + n] field_21, field_25, field_31, field_33, field_3b
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m4b7563_click_27bf_27c1 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 150 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_3b, 0x3b  # offset +0x3b
.equ field_310, 0x310  # offset +0x310
.equ field_341, 0x341  # offset +0x341

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004b7563 - 0x401000
.globl FUN_004b7563
FUN_004b7563:
    # block 0x004b7563: entry, 16 instruction(s), ends with je to 0x004b7777 (forward)
    push ebp                                     # 004b7563
    {load} mov ebp, esp                          # 004b7564
    sub esp, 0x8                                 # 004b7566
    push esi                                     # 004b7569
    push edi                                     # 004b756a
    mov dword ptr [ebp - local_8], ecx           # 004b756b
    mov eax, dword ptr [ebp - local_8]           # 004b756e
    movsx ecx, word ptr [eax + field_21]         # 004b7571
    imul ecx, ecx, 0x8d                          # 004b7575
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b757b
    mov dword ptr [ebp - local_4], edx           # 004b7581
    mov eax, dword ptr [ebp - local_8]           # 004b7584
    {load} xor ecx, ecx                          # 004b7587
    mov cl, byte ptr [eax + field_35]            # 004b7589
    test ecx, ecx                                # 004b758c
    je.d32 L_004b7777                            # 004b758e
    # block 0x004b7594: entered by fall-through of je at 0x004b758e, 5 instruction(s), ends with jne to 0x004b7777 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b7594
    {load} xor eax, eax                          # 004b7597
    mov al, byte ptr [edx + field_3b]            # 004b7599
    test eax, eax                                # 004b759c
    jne.d32 L_004b7777                           # 004b759e
    # block 0x004b75a4: entered by fall-through of jne at 0x004b759e, 3 instruction(s), ends with jne to 0x004b7777 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b75a4
    cmp dword ptr [ecx + field_25], 0x0          # 004b75a7
    jne.d32 L_004b7777                           # 004b75ab
    # block 0x004b75b1: entered by fall-through of jne at 0x004b75ab, 5 instruction(s), ends with jne to 0x004b7777 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b75b1
    movsx eax, word ptr [edx + field_21]         # 004b75b4
    imul eax, eax, 0x8d                          # 004b75b8
    cmp dword ptr [eax + 0x5bb632], 0x1          # 004b75be
    jne.d32 L_004b7777                           # 004b75c5
    # block 0x004b75cb: entered by fall-through of jne at 0x004b75c5, 2 instruction(s), ends with jne to 0x004b768c (forward)
    cmp dword ptr [0x5c39e5], 0x27bf             # 004b75cb
    jne.d32 L_004b768c                           # 004b75d5
    # block 0x004b75db: entered by fall-through of jne at 0x004b75d5, 5 instruction(s), ends with je to 0x004b7619 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b75db
    {load} xor edx, edx                          # 004b75de
    mov dl, byte ptr [ecx + field_25]            # 004b75e0
    test edx, edx                                # 004b75e3
    je.d8 L_004b7619                             # 004b75e5
    # block 0x004b75e7: entered by fall-through of je at 0x004b75e5, 4 instruction(s), ends with jle to 0x004b7606 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b75e7
    movsx ecx, word ptr [eax + field_31]         # 004b75ea
    test ecx, ecx                                # 004b75ee
    jle.d8 L_004b7606                            # 004b75f0
    # block 0x004b75f2: entered by fall-through of jle at 0x004b75f0, 6 instruction(s), ends with forward jump to 0x004b7617
    mov edx, dword ptr [ebp - local_8]           # 004b75f2
    mov ax, word ptr [edx + field_31]            # 004b75f5
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004b75f9
    mov ecx, dword ptr [ebp - local_8]           # 004b75fd
    mov word ptr [ecx + field_31], ax            # 004b7600
    jmp.d8 L_004b7617                            # 004b7604
L_004b7606:
    # block 0x004b7606: entered by jle at 0x004b75f0, 5 instruction(s), falls into the block at 0x004b7617
    mov edx, dword ptr [ebp - local_4]           # 004b7606
    movsx eax, word ptr [edx + field_21]         # 004b7609
    sub eax, 0x1                                 # 004b760d
    mov ecx, dword ptr [ebp - local_8]           # 004b7610
    mov word ptr [ecx + field_31], ax            # 004b7613
L_004b7617:
    # block 0x004b7617: entered by jmp at 0x004b7604, 1 instruction(s), ends with forward jump to 0x004b764b
    jmp.d8 L_004b764b                            # 004b7617
L_004b7619:
    # block 0x004b7619: entered by je at 0x004b75e5, 7 instruction(s), ends with jge to 0x004b7642 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b7619
    movsx eax, word ptr [edx + field_31]         # 004b761c
    mov ecx, dword ptr [ebp - local_4]           # 004b7620
    movsx edx, word ptr [ecx + field_21]         # 004b7623
    sub edx, 0x1                                 # 004b7627
    {load} cmp eax, edx                          # 004b762a
    jge.d8 L_004b7642                            # 004b762c
    # block 0x004b762e: entered by fall-through of jge at 0x004b762c, 6 instruction(s), ends with forward jump to 0x004b764b
    mov eax, dword ptr [ebp - local_8]           # 004b762e
    mov cx, word ptr [eax + field_31]            # 004b7631
    add cx, 0x1                                  # 004b7635
    mov edx, dword ptr [ebp - local_8]           # 004b7639
    mov word ptr [edx + field_31], cx            # 004b763c
    jmp.d8 L_004b764b                            # 004b7640
L_004b7642:
    # block 0x004b7642: entered by jge at 0x004b762c, 2 instruction(s), falls into the block at 0x004b764b
    mov eax, dword ptr [ebp - local_8]           # 004b7642
    mov word ptr [eax + field_31], 0x0           # 004b7645
L_004b764b:
    # block 0x004b764b: entered by jmp at 0x004b7617; jmp at 0x004b7640, 2 instruction(s), ends with je to 0x004b7682 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004b764b
    je.d8 L_004b7682                             # 004b7652
    # block 0x004b7654: entered by fall-through of je at 0x004b7652, 7 instruction(s), ends with je to 0x004b7682 (forward)
    mov edi, 0x551c54                            # 004b7654
    mov esi, dword ptr [ebp - local_4]           # 004b7659
    add esi, 0x2ef                               # 004b765c
    mov ecx, 0x9                                 # 004b7662
    {load} xor edx, edx                          # 004b7667
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7669
    je.d8 L_004b7682                             # 004b766b
    # block 0x004b766d: entered by fall-through of je at 0x004b766b, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b7682
    mov eax, dword ptr [ebp - local_4]           # 004b766d
    mov cx, word ptr [eax + field_310]           # 004b7670
    push ecx                                     # 004b7677
    mov ecx, 0x5c3a67                            # 004b7678
    call FUN_004fb2e3                            # 004b767d
L_004b7682:
    # block 0x004b7682: entered by je at 0x004b7652; je at 0x004b766b, 2 instruction(s), falls into the block at 0x004b768c
    mov edx, dword ptr [ebp - local_8]           # 004b7682
    mov dword ptr [edx + field_25], 0x2          # 004b7685
L_004b768c:
    # block 0x004b768c: entered by jne at 0x004b75d5, 2 instruction(s), ends with jne to 0x004b774d (forward)
    cmp dword ptr [0x5c39e5], 0x27c0             # 004b768c
    jne.d32 L_004b774d                           # 004b7696
    # block 0x004b769c: entered by fall-through of jne at 0x004b7696, 5 instruction(s), ends with je to 0x004b76da (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b769c
    {load} xor ecx, ecx                          # 004b769f
    mov cl, byte ptr [eax + field_26]            # 004b76a1
    test ecx, ecx                                # 004b76a4
    je.d8 L_004b76da                             # 004b76a6
    # block 0x004b76a8: entered by fall-through of je at 0x004b76a6, 4 instruction(s), ends with jle to 0x004b76c7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b76a8
    movsx eax, word ptr [edx + field_33]         # 004b76ab
    test eax, eax                                # 004b76af
    jle.d8 L_004b76c7                            # 004b76b1
    # block 0x004b76b3: entered by fall-through of jle at 0x004b76b1, 6 instruction(s), ends with forward jump to 0x004b76d8
    mov ecx, dword ptr [ebp - local_8]           # 004b76b3
    mov dx, word ptr [ecx + field_33]            # 004b76b6
    sub dx, 0x1                                  # 004b76ba
    mov eax, dword ptr [ebp - local_8]           # 004b76be
    mov word ptr [eax + field_33], dx            # 004b76c1
    jmp.d8 L_004b76d8                            # 004b76c5
L_004b76c7:
    # block 0x004b76c7: entered by jle at 0x004b76b1, 5 instruction(s), falls into the block at 0x004b76d8
    mov ecx, dword ptr [ebp - local_4]           # 004b76c7
    movsx edx, word ptr [ecx + field_23]         # 004b76ca
    sub edx, 0x1                                 # 004b76ce
    mov eax, dword ptr [ebp - local_8]           # 004b76d1
    mov word ptr [eax + field_33], dx            # 004b76d4
L_004b76d8:
    # block 0x004b76d8: entered by jmp at 0x004b76c5, 1 instruction(s), ends with forward jump to 0x004b770c
    jmp.d8 L_004b770c                            # 004b76d8
L_004b76da:
    # block 0x004b76da: entered by je at 0x004b76a6, 7 instruction(s), ends with jge to 0x004b7703 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b76da
    movsx edx, word ptr [ecx + field_33]         # 004b76dd
    mov eax, dword ptr [ebp - local_4]           # 004b76e1
    movsx ecx, word ptr [eax + field_23]         # 004b76e4
    sub ecx, 0x1                                 # 004b76e8
    {load} cmp edx, ecx                          # 004b76eb
    jge.d8 L_004b7703                            # 004b76ed
    # block 0x004b76ef: entered by fall-through of jge at 0x004b76ed, 6 instruction(s), ends with forward jump to 0x004b770c
    mov edx, dword ptr [ebp - local_8]           # 004b76ef
    mov ax, word ptr [edx + field_33]            # 004b76f2
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b76f6
    mov ecx, dword ptr [ebp - local_8]           # 004b76fa
    mov word ptr [ecx + field_33], ax            # 004b76fd
    jmp.d8 L_004b770c                            # 004b7701
L_004b7703:
    # block 0x004b7703: entered by jge at 0x004b76ed, 2 instruction(s), falls into the block at 0x004b770c
    mov edx, dword ptr [ebp - local_8]           # 004b7703
    mov word ptr [edx + field_33], 0x0           # 004b7706
L_004b770c:
    # block 0x004b770c: entered by jmp at 0x004b76d8; jmp at 0x004b7701, 2 instruction(s), ends with je to 0x004b7743 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004b770c
    je.d8 L_004b7743                             # 004b7713
    # block 0x004b7715: entered by fall-through of je at 0x004b7713, 7 instruction(s), ends with je to 0x004b7743 (forward)
    mov edi, 0x551c60                            # 004b7715
    mov esi, dword ptr [ebp - local_4]           # 004b771a
    add esi, 0x320                               # 004b771d
    mov ecx, 0x9                                 # 004b7723
    {load} xor eax, eax                          # 004b7728
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b772a
    je.d8 L_004b7743                             # 004b772c
    # block 0x004b772e: entered by fall-through of je at 0x004b772c, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b7743
    mov ecx, dword ptr [ebp - local_4]           # 004b772e
    mov dx, word ptr [ecx + field_341]           # 004b7731
    push edx                                     # 004b7738
    mov ecx, 0x5c3a67                            # 004b7739
    call FUN_004fb2e3                            # 004b773e
L_004b7743:
    # block 0x004b7743: entered by je at 0x004b7713; je at 0x004b772c, 2 instruction(s), falls into the block at 0x004b774d
    mov eax, dword ptr [ebp - local_8]           # 004b7743
    mov dword ptr [eax + field_25], 0x2          # 004b7746
L_004b774d:
    # block 0x004b774d: entered by jne at 0x004b7696, 2 instruction(s), ends with jne to 0x004b7777 (forward)
    cmp dword ptr [0x5c39e5], 0x27c1             # 004b774d
    jne.d8 L_004b7777                            # 004b7757
    # block 0x004b7759: entered by fall-through of jne at 0x004b7757, 6 instruction(s), falls into the block at 0x004b7777
    mov ecx, dword ptr [ebp - local_8]           # 004b7759
    mov byte ptr [ecx + field_36], 0x1           # 004b775c
    mov edx, dword ptr [ebp - local_8]           # 004b7760
    movsx eax, word ptr [edx + field_21]         # 004b7763
    imul eax, eax, 0x8d                          # 004b7767
    mov dword ptr [eax + 0x5bb632], 0x2          # 004b776d
L_004b7777:
    # block 0x004b7777: entered by je at 0x004b758e; jne at 0x004b759e; jne at 0x004b75ab; jne at 0x004b75c5; more, 5 instruction(s), ends with ret
    pop edi                                      # 004b7777
    pop esi                                      # 004b7778
    {load} mov esp, ebp                          # 004b7779
    pop ebp                                      # 004b777b
    ret                                          # 004b777c

