# FUN_004ff590
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff590
# extent:       0x004ff590-0x004ff99f (1039 code bytes)
# span:         0x004ff590-0x004ff9a0 (code 1039, tables 0, padding 1)
# sha256:       82f9a2c7888ce939072a740ae02f125f2f57dfd2386e2e5daace3b0ab772fcde
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ff590
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c, field_minus_4; [ebx + n] field_4; [ecx + n] field_4, field_8, field_14, field_18, field_20, field_24, field_28, field_2c, field_30, field_34, field_38, field_3c and 9 more; [edi + n] field_1c, field_2c, field_30, field_34, field_38, field_3c, field_58, field_5c, field_60, field_64; [edx + n] field_4, field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_3c, stk_40
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 386 instruction(s), 38 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ stk_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ stk_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x004ff590 - 0x401000
.globl FUN_004ff590
FUN_004ff590:
    # block 0x004ff590: entry, 14 instruction(s), ends with jne to 0x004ff5c0 (forward)
    sub esp, 0x28                                # 004ff590
    mov ecx, dword ptr [esp + stk_2c]            # 004ff593
    push ebx                                     # 004ff597
    push ebp                                     # 004ff598
    push esi                                     # 004ff599
    mov eax, dword ptr [ecx + field_4]           # 004ff59a
    push edi                                     # 004ff59d
    mov edi, dword ptr [esp + stk_40]            # 004ff59e
    {load} xor ebp, ebp                          # 004ff5a2
    mov ebx, dword ptr [eax + field_1c]          # 004ff5a4
    {load} cmp edi, ebp                          # 004ff5a7
    mov dword ptr [esp + stk_28], eax            # 004ff5a9
    mov dword ptr [esp + stk_1c], ebx            # 004ff5ad
    jne.d8 L_004ff5c0                            # 004ff5b1
    # block 0x004ff5b3: entered by fall-through of jne at 0x004ff5b1, 7 instruction(s), ends with ret
    pop edi                                      # 004ff5b3
    pop esi                                      # 004ff5b4
    pop ebp                                      # 004ff5b5
    mov eax, 0xffffff7d                          # 004ff5b6
    pop ebx                                      # 004ff5bb
    add esp, 0x28                                # 004ff5bc
    ret                                          # 004ff5bf
L_004ff5c0:
    # block 0x004ff5c0: entered by jne at 0x004ff5b1, 4 instruction(s), ends with jle to 0x004ff5de (forward)
    mov eax, dword ptr [ecx + field_18]          # 004ff5c0
    mov edx, dword ptr [ecx + field_14]          # 004ff5c3
    {load} cmp edx, eax                          # 004ff5c6
    jle.d8 L_004ff5de                            # 004ff5c8
    # block 0x004ff5ca: entered by fall-through of jle at 0x004ff5c8, 3 instruction(s), ends with je to 0x004ff5e1 (forward)
    or esi, -0x1                                 # 004ff5ca
    {load} cmp eax, esi                          # 004ff5cd
    je.d8 L_004ff5e1                             # 004ff5cf
    # block 0x004ff5d1: entered by fall-through of je at 0x004ff5cf, 7 instruction(s), ends with ret
    pop edi                                      # 004ff5d1
    pop esi                                      # 004ff5d2
    pop ebp                                      # 004ff5d3
    mov eax, 0xffffff7d                          # 004ff5d4
    pop ebx                                      # 004ff5d9
    add esp, 0x28                                # 004ff5da
    ret                                          # 004ff5dd
L_004ff5de:
    # block 0x004ff5de: entered by jle at 0x004ff5c8, 1 instruction(s), falls into the block at 0x004ff5e1
    or esi, -0x1                                 # 004ff5de
L_004ff5e1:
    # block 0x004ff5e1: entered by je at 0x004ff5cf, 11 instruction(s), ends with jne to 0x004ff605 (forward)
    mov eax, dword ptr [ecx + field_28]          # 004ff5e1
    mov dword ptr [ecx + field_24], eax          # 004ff5e4
    mov edx, dword ptr [edi + field_1c]          # 004ff5e7
    mov eax, dword ptr [ecx + field_3c]          # 004ff5ea
    mov dword ptr [ecx + field_28], edx          # 004ff5ed
    mov edx, dword ptr [ecx + field_40]          # 004ff5f0
    add eax, 0x1                                 # 004ff5f3
    mov dword ptr [ecx + field_2c], esi          # 004ff5f6
    {load} adc edx, ebp                          # 004ff5f9
    cmp eax, dword ptr [edi + field_38]          # 004ff5fb
    jne.d8 L_004ff605                            # 004ff5fe
    # block 0x004ff600: entered by fall-through of jne at 0x004ff5fe, 2 instruction(s), ends with je to 0x004ff60b (forward)
    cmp edx, dword ptr [edi + field_3c]          # 004ff600
    je.d8 L_004ff60b                             # 004ff603
L_004ff605:
    # block 0x004ff605: entered by jne at 0x004ff5fe; fall-through of je at 0x004ff603, 2 instruction(s), falls into the block at 0x004ff60b
    mov dword ptr [ecx + field_34], esi          # 004ff605
    mov dword ptr [ecx + field_38], esi          # 004ff608
L_004ff60b:
    # block 0x004ff60b: entered by je at 0x004ff603, 7 instruction(s), ends with je to 0x004ff8c2 (forward)
    mov eax, dword ptr [edi + field_38]          # 004ff60b
    mov dword ptr [ecx + field_3c], eax          # 004ff60e
    mov edx, dword ptr [edi + field_3c]          # 004ff611
    mov dword ptr [ecx + field_40], edx          # 004ff614
    mov eax, dword ptr [edi]                     # 004ff617
    {load} cmp eax, ebp                          # 004ff619
    je.d32 L_004ff8c2                            # 004ff61b
    # block 0x004ff621: entered by fall-through of je at 0x004ff61b, 44 instruction(s), ends with je to 0x004ff696 (forward)
    mov eax, dword ptr [ecx + field_28]          # 004ff621
    mov eax, dword ptr [ebx + 4*eax]             # 004ff624
    cdq                                          # 004ff627
    {load} sub eax, edx                          # 004ff628
    sar eax                                      # 004ff62a
    mov dword ptr [esp + stk_24], eax            # 004ff62c
    mov eax, dword ptr [ebx]                     # 004ff630
    cdq                                          # 004ff632
    {load} sub eax, edx                          # 004ff633
    {load} mov esi, eax                          # 004ff635
    mov eax, dword ptr [ebx + field_4]           # 004ff637
    cdq                                          # 004ff63a
    {load} sub eax, edx                          # 004ff63b
    {load} mov ebx, eax                          # 004ff63d
    mov eax, dword ptr [edi + field_58]          # 004ff63f
    cdq                                          # 004ff642
    sar esi                                      # 004ff643
    sar ebx                                      # 004ff645
    add dword ptr [ecx + field_44], eax          # 004ff647
    mov eax, dword ptr [ecx + field_48]          # 004ff64a
    mov dword ptr [esp + stk_3c], ebx            # 004ff64d
    {load} adc eax, edx                          # 004ff651
    mov dword ptr [ecx + field_48], eax          # 004ff653
    mov eax, dword ptr [edi + field_5c]          # 004ff656
    cdq                                          # 004ff659
    add dword ptr [ecx + field_4c], eax          # 004ff65a
    mov eax, dword ptr [ecx + field_50]          # 004ff65d
    {load} adc eax, edx                          # 004ff660
    mov dword ptr [ecx + field_50], eax          # 004ff662
    mov eax, dword ptr [edi + field_60]          # 004ff665
    cdq                                          # 004ff668
    add dword ptr [ecx + field_54], eax          # 004ff669
    mov eax, dword ptr [ecx + field_58]          # 004ff66c
    {load} adc eax, edx                          # 004ff66f
    mov dword ptr [ecx + field_58], eax          # 004ff671
    mov eax, dword ptr [edi + field_64]          # 004ff674
    cdq                                          # 004ff677
    add dword ptr [ecx + field_5c], eax          # 004ff678
    mov eax, dword ptr [ecx + field_60]          # 004ff67b
    {load} adc eax, edx                          # 004ff67e
    mov dword ptr [ecx + field_60], eax          # 004ff680
    mov eax, dword ptr [ecx + field_30]          # 004ff683
    {load} cmp eax, ebp                          # 004ff686
    je.d8 L_004ff696                             # 004ff688
    # block 0x004ff68a: entered by fall-through of je at 0x004ff688, 4 instruction(s), ends with forward jump to 0x004ff6a0
    {load} xor eax, eax                          # 004ff68a
    mov dword ptr [esp + stk_18], ebx            # 004ff68c
    mov dword ptr [esp + stk_40], eax            # 004ff690
    jmp.d8 L_004ff6a0                            # 004ff694
L_004ff696:
    # block 0x004ff696: entered by je at 0x004ff688, 3 instruction(s), falls into the block at 0x004ff6a0
    mov dword ptr [esp + stk_18], ebp            # 004ff696
    mov dword ptr [esp + stk_40], ebx            # 004ff69a
    {load} mov eax, ebx                          # 004ff69e
L_004ff6a0:
    # block 0x004ff6a0: entered by jmp at 0x004ff694, 4 instruction(s), ends with jle to 0x004ff846 (forward)
    mov edx, dword ptr [esp + stk_28]            # 004ff6a0
    mov dword ptr [esp + stk_14], ebp            # 004ff6a4
    cmp dword ptr [edx + field_4], 0x0           # 004ff6a8
    jle.d32 L_004ff846                           # 004ff6ac
L_004ff6b2:
    # block 0x004ff6b2: entered by jl at 0x004ff840; fall-through of jle at 0x004ff6ac, 4 instruction(s), ends with je to 0x004ff749 (forward)
    mov edx, dword ptr [ecx + field_24]          # 004ff6b2
    test edx, edx                                # 004ff6b5
    mov edx, dword ptr [ecx + field_28]          # 004ff6b7
    je.d32 L_004ff749                            # 004ff6ba
    # block 0x004ff6c0: entered by fall-through of je at 0x004ff6ba, 2 instruction(s), ends with je to 0x004ff704 (forward)
    test edx, edx                                # 004ff6c0
    je.d8 L_004ff704                             # 004ff6c2
    # block 0x004ff6c4: entered by fall-through of je at 0x004ff6c2, 7 instruction(s), ends with jle to 0x004ff7e2 (forward)
    mov edx, dword ptr [ecx + field_8]           # 004ff6c4
    test ebx, ebx                                # 004ff6c7
    mov edx, dword ptr [edx + 4*ebp]             # 004ff6c9
    lea eax, [edx + 4*eax]                       # 004ff6cc
    mov edx, dword ptr [edi]                     # 004ff6cf
    mov edx, dword ptr [edx + 4*ebp]             # 004ff6d1
    jle.d32 L_004ff7e2                           # 004ff6d4
    # block 0x004ff6da: entered by fall-through of jle at 0x004ff6d4, 4 instruction(s), falls into the block at 0x004ff6e8
    mov ebx, dword ptr [esp + stk_3c]            # 004ff6da
    {load} sub edx, eax                          # 004ff6de
    mov dword ptr [esp + stk_20], edx            # 004ff6e0
    mov dword ptr [esp + stk_14], ebx            # 004ff6e4
L_004ff6e8:
    # block 0x004ff6e8: entered by jne at 0x004ff6fd, 7 instruction(s), ends with jne to 0x004ff6e8 (backward)
    mov edx, dword ptr [esp + stk_20]            # 004ff6e8
    add eax, 0x4                                 # 004ff6ec
    fld dword ptr [edx + eax - field_minus_4]    # 004ff6ef
    fadd dword ptr [eax - field_minus_4]         # 004ff6f3
    dec dword ptr [esp + stk_14]                 # 004ff6f6
    fstp dword ptr [eax - field_minus_4]         # 004ff6fa
    jne.d8 L_004ff6e8                            # 004ff6fd
    # block 0x004ff6ff: entered by fall-through of jne at 0x004ff6fd, 1 instruction(s), ends with forward jump to 0x004ff7e2
    jmp.d32 L_004ff7e2                           # 004ff6ff
L_004ff704:
    # block 0x004ff704: entered by je at 0x004ff6c2, 19 instruction(s), ends with jle to 0x004ff7de (forward)
    {load} mov eax, ebx                          # 004ff704
    cdq                                          # 004ff706
    {load} sub eax, edx                          # 004ff707
    {load} mov ebx, eax                          # 004ff709
    {load} mov eax, esi                          # 004ff70b
    cdq                                          # 004ff70d
    {load} sub eax, edx                          # 004ff70e
    sar ebx                                      # 004ff710
    sar eax                                      # 004ff712
    {load} sub ebx, eax                          # 004ff714
    mov eax, dword ptr [esp + stk_40]            # 004ff716
    {load} add ebx, eax                          # 004ff71a
    mov eax, dword ptr [ecx + field_8]           # 004ff71c
    test esi, esi                                # 004ff71f
    mov edx, dword ptr [eax + 4*ebp]             # 004ff721
    lea eax, [edx + 4*ebx]                       # 004ff724
    mov edx, dword ptr [edi]                     # 004ff727
    mov edx, dword ptr [edx + 4*ebp]             # 004ff729
    jle.d32 L_004ff7de                           # 004ff72c
    # block 0x004ff732: entered by fall-through of jle at 0x004ff72c, 2 instruction(s), falls into the block at 0x004ff736
    {load} sub edx, eax                          # 004ff732
    {load} mov ebx, esi                          # 004ff734
L_004ff736:
    # block 0x004ff736: entered by jne at 0x004ff742, 6 instruction(s), ends with jne to 0x004ff736 (backward)
    fld dword ptr [edx + eax]                    # 004ff736
    fadd dword ptr [eax]                         # 004ff739
    add eax, 0x4                                 # 004ff73b
    dec ebx                                      # 004ff73e
    fstp dword ptr [eax - field_minus_4]         # 004ff73f
    jne.d8 L_004ff736                            # 004ff742
    # block 0x004ff744: entered by fall-through of jne at 0x004ff742, 1 instruction(s), ends with forward jump to 0x004ff7de
    jmp.d32 L_004ff7de                           # 004ff744
L_004ff749:
    # block 0x004ff749: entered by je at 0x004ff6ba, 5 instruction(s), ends with je to 0x004ff868 (forward)
    test edx, edx                                # 004ff749
    mov edx, dword ptr [ecx + field_8]           # 004ff74b
    mov edx, dword ptr [edx + 4*ebp]             # 004ff74e
    lea eax, [edx + 4*eax]                       # 004ff751
    je.d32 L_004ff868                            # 004ff754
    # block 0x004ff75a: entered by fall-through of je at 0x004ff754, 20 instruction(s), ends with jle to 0x004ff7b8 (forward)
    mov dword ptr [esp + stk_10], eax            # 004ff75a
    {load} mov eax, ebx                          # 004ff75e
    cdq                                          # 004ff760
    {load} sub eax, edx                          # 004ff761
    {load} mov ebx, eax                          # 004ff763
    {load} mov eax, esi                          # 004ff765
    cdq                                          # 004ff767
    sar ebx                                      # 004ff768
    {load} sub eax, edx                          # 004ff76a
    {load} mov edx, ebx                          # 004ff76c
    sar eax                                      # 004ff76e
    mov dword ptr [esp + stk_34], eax            # 004ff770
    {load} sub edx, eax                          # 004ff774
    mov eax, dword ptr [edi]                     # 004ff776
    mov eax, dword ptr [eax + 4*ebp]             # 004ff778
    lea ebp, [eax + 4*edx]                       # 004ff77b
    {load} xor eax, eax                          # 004ff77e
    test esi, esi                                # 004ff780
    mov dword ptr [esp + stk_30], ebp            # 004ff782
    jle.d8 L_004ff7b8                            # 004ff786
    # block 0x004ff788: entered by fall-through of jle at 0x004ff786, 6 instruction(s), ends with forward jump to 0x004ff79e
    mov edx, dword ptr [esp + stk_10]            # 004ff788
    mov dword ptr [esp + stk_20], esi            # 004ff78c
    {load} sub ebp, edx                          # 004ff790
    {load} mov eax, esi                          # 004ff792
    mov dword ptr [esp + stk_2c], ebp            # 004ff794
    jmp.d8 L_004ff79e                            # 004ff798
L_004ff79a:
    # block 0x004ff79a: entered by jne at 0x004ff7b2, 1 instruction(s), falls into the block at 0x004ff79e
    mov ebp, dword ptr [esp + stk_2c]            # 004ff79a
L_004ff79e:
    # block 0x004ff79e: entered by jmp at 0x004ff798, 8 instruction(s), ends with jne to 0x004ff79a (backward)
    fld dword ptr [edx + ebp]                    # 004ff79e
    fadd dword ptr [edx]                         # 004ff7a1
    mov ebp, dword ptr [esp + stk_20]            # 004ff7a3
    add edx, 0x4                                 # 004ff7a7
    dec ebp                                      # 004ff7aa
    mov dword ptr [esp + stk_20], ebp            # 004ff7ab
    fstp dword ptr [edx - field_minus_4]         # 004ff7af
    jne.d8 L_004ff79a                            # 004ff7b2
    # block 0x004ff7b4: entered by fall-through of jne at 0x004ff7b2, 1 instruction(s), falls into the block at 0x004ff7b8
    mov ebp, dword ptr [esp + stk_30]            # 004ff7b4
L_004ff7b8:
    # block 0x004ff7b8: entered by jle at 0x004ff786, 4 instruction(s), ends with jge to 0x004ff7da (forward)
    mov edx, dword ptr [esp + stk_34]            # 004ff7b8
    {load} add ebx, edx                          # 004ff7bc
    {load} cmp eax, ebx                          # 004ff7be
    jge.d8 L_004ff7da                            # 004ff7c0
    # block 0x004ff7c2: entered by fall-through of jge at 0x004ff7c0, 4 instruction(s), falls into the block at 0x004ff7cf
    mov edx, dword ptr [esp + stk_10]            # 004ff7c2
    sub ebp, dword ptr [esp + stk_10]            # 004ff7c6
    {load} sub ebx, eax                          # 004ff7ca
    lea edx, [edx + 4*eax]                       # 004ff7cc
L_004ff7cf:
    # block 0x004ff7cf: entered by jne at 0x004ff7d8, 5 instruction(s), ends with jne to 0x004ff7cf (backward)
    mov eax, dword ptr [edx + ebp]               # 004ff7cf
    mov dword ptr [edx], eax                     # 004ff7d2
    add edx, 0x4                                 # 004ff7d4
    dec ebx                                      # 004ff7d7
    jne.d8 L_004ff7cf                            # 004ff7d8
L_004ff7da:
    # block 0x004ff7da: entered by jge at 0x004ff7c0; fall-through of jne at 0x004ff7d8, 1 instruction(s), falls into the block at 0x004ff7de
    mov ebp, dword ptr [esp + stk_14]            # 004ff7da
L_004ff7de:
    # block 0x004ff7de: entered by jle at 0x004ff72c; jmp at 0x004ff744; jmp at 0x004ff887, 1 instruction(s), falls into the block at 0x004ff7e2
    mov ebx, dword ptr [esp + stk_3c]            # 004ff7de
L_004ff7e2:
    # block 0x004ff7e2: entered by jle at 0x004ff6d4; jmp at 0x004ff6ff; jle at 0x004ff86f, 11 instruction(s), ends with jle to 0x004ff82e (forward)
    mov eax, dword ptr [ecx + field_8]           # 004ff7e2
    mov edx, dword ptr [eax + 4*ebp]             # 004ff7e5
    mov eax, dword ptr [esp + stk_18]            # 004ff7e8
    lea edx, [edx + 4*eax]                       # 004ff7ec
    mov eax, dword ptr [edi]                     # 004ff7ef
    mov dword ptr [esp + stk_20], edx            # 004ff7f1
    mov edx, dword ptr [eax + 4*ebp]             # 004ff7f5
    mov eax, dword ptr [esp + stk_24]            # 004ff7f8
    test eax, eax                                # 004ff7fc
    lea edx, [edx + 4*eax]                       # 004ff7fe
    jle.d8 L_004ff82e                            # 004ff801
    # block 0x004ff803: entered by fall-through of jle at 0x004ff801, 5 instruction(s), falls into the block at 0x004ff815
    mov eax, dword ptr [esp + stk_20]            # 004ff803
    {load} sub edx, eax                          # 004ff807
    mov dword ptr [esp + stk_34], edx            # 004ff809
    mov edx, dword ptr [esp + stk_24]            # 004ff80d
    mov dword ptr [esp + stk_20], edx            # 004ff811
L_004ff815:
    # block 0x004ff815: entered by jne at 0x004ff82c, 8 instruction(s), ends with jne to 0x004ff815 (backward)
    mov edx, dword ptr [esp + stk_34]            # 004ff815
    add eax, 0x4                                 # 004ff819
    mov edx, dword ptr [edx + eax - field_minus_4] # 004ff81c
    mov dword ptr [eax - field_minus_4], edx     # 004ff820
    mov edx, dword ptr [esp + stk_20]            # 004ff823
    dec edx                                      # 004ff827
    mov dword ptr [esp + stk_20], edx            # 004ff828
    jne.d8 L_004ff815                            # 004ff82c
L_004ff82e:
    # block 0x004ff82e: entered by jle at 0x004ff801; fall-through of jne at 0x004ff82c, 7 instruction(s), ends with jl to 0x004ff6b2 (backward)
    mov eax, dword ptr [esp + stk_28]            # 004ff82e
    inc ebp                                      # 004ff832
    mov dword ptr [esp + stk_14], ebp            # 004ff833
    mov edx, dword ptr [eax + field_4]           # 004ff837
    mov eax, dword ptr [esp + stk_40]            # 004ff83a
    {load} cmp ebp, edx                          # 004ff83e
    jl.d32 L_004ff6b2                            # 004ff840
L_004ff846:
    # block 0x004ff846: entered by jle at 0x004ff6ac; fall-through of jl at 0x004ff840, 9 instruction(s), ends with jne to 0x004ff88c (forward)
    mov edx, dword ptr [ecx + field_30]          # 004ff846
    neg edx                                      # 004ff849
    {load} sbb edx, edx                          # 004ff84b
    not edx                                      # 004ff84d
    {load} and edx, ebx                          # 004ff84f
    mov dword ptr [ecx + field_30], edx          # 004ff851
    mov edx, dword ptr [ecx + field_18]          # 004ff854
    cmp edx, -0x1                                # 004ff857
    jne.d8 L_004ff88c                            # 004ff85a
    # block 0x004ff85c: entered by fall-through of jne at 0x004ff85a, 4 instruction(s), ends with forward jump to 0x004ff8be
    mov eax, dword ptr [esp + stk_18]            # 004ff85c
    mov dword ptr [ecx + field_18], eax          # 004ff860
    mov dword ptr [ecx + field_14], eax          # 004ff863
    jmp.d8 L_004ff8be                            # 004ff866
L_004ff868:
    # block 0x004ff868: entered by je at 0x004ff754, 4 instruction(s), ends with jle to 0x004ff7e2 (backward)
    mov edx, dword ptr [edi]                     # 004ff868
    test esi, esi                                # 004ff86a
    mov edx, dword ptr [edx + 4*ebp]             # 004ff86c
    jle.d32 L_004ff7e2                           # 004ff86f
    # block 0x004ff875: entered by fall-through of jle at 0x004ff86f, 2 instruction(s), falls into the block at 0x004ff879
    {load} sub edx, eax                          # 004ff875
    {load} mov ebx, esi                          # 004ff877
L_004ff879:
    # block 0x004ff879: entered by jne at 0x004ff885, 6 instruction(s), ends with jne to 0x004ff879 (backward)
    fld dword ptr [edx + eax]                    # 004ff879
    fadd dword ptr [eax]                         # 004ff87c
    add eax, 0x4                                 # 004ff87e
    dec ebx                                      # 004ff881
    fstp dword ptr [eax - field_minus_4]         # 004ff882
    jne.d8 L_004ff879                            # 004ff885
    # block 0x004ff887: entered by fall-through of jne at 0x004ff885, 1 instruction(s), ends with backward jump to 0x004ff7de
    jmp.d32 L_004ff7de                           # 004ff887
L_004ff88c:
    # block 0x004ff88c: entered by jne at 0x004ff85a, 19 instruction(s), falls into the block at 0x004ff8be
    mov esi, dword ptr [esp + stk_1c]            # 004ff88c
    mov dword ptr [ecx + field_18], eax          # 004ff890
    mov eax, dword ptr [ecx + field_28]          # 004ff893
    mov eax, dword ptr [esi + 4*eax]             # 004ff896
    cdq                                          # 004ff899
    and edx, 0x3                                 # 004ff89a
    {load} add eax, edx                          # 004ff89d
    mov edx, dword ptr [ecx + field_24]          # 004ff89f
    {load} mov ebx, eax                          # 004ff8a2
    mov eax, dword ptr [esi + 4*edx]             # 004ff8a4
    cdq                                          # 004ff8a7
    and edx, 0x3                                 # 004ff8a8
    {load} add edx, eax                          # 004ff8ab
    mov eax, dword ptr [esp + stk_40]            # 004ff8ad
    sar ebx, 0x2                                 # 004ff8b1
    sar edx, 0x2                                 # 004ff8b4
    {load} add eax, ebx                          # 004ff8b7
    {load} add edx, eax                          # 004ff8b9
    mov dword ptr [ecx + field_14], edx          # 004ff8bb
L_004ff8be:
    # block 0x004ff8be: entered by jmp at 0x004ff866, 1 instruction(s), falls into the block at 0x004ff8c2
    mov ebx, dword ptr [esp + stk_1c]            # 004ff8be
L_004ff8c2:
    # block 0x004ff8c2: entered by je at 0x004ff61b, 6 instruction(s), ends with jne to 0x004ff8ec (forward)
    mov esi, dword ptr [ecx + field_34]          # 004ff8c2
    mov ebp, dword ptr [ecx + field_38]          # 004ff8c5
    {load} mov eax, esi                          # 004ff8c8
    {load} and eax, ebp                          # 004ff8ca
    cmp eax, -0x1                                # 004ff8cc
    jne.d8 L_004ff8ec                            # 004ff8cf
    # block 0x004ff8d1: entered by fall-through of jne at 0x004ff8cf, 6 instruction(s), ends with je to 0x004ff987 (forward)
    mov eax, dword ptr [edi + field_30]          # 004ff8d1
    mov edx, dword ptr [edi + field_34]          # 004ff8d4
    {load} mov esi, eax                          # 004ff8d7
    {load} and esi, edx                          # 004ff8d9
    cmp esi, -0x1                                # 004ff8db
    je.d32 L_004ff987                            # 004ff8de
    # block 0x004ff8e4: entered by fall-through of je at 0x004ff8de, 2 instruction(s), ends with forward jump to 0x004ff984
    mov dword ptr [ecx + field_34], eax          # 004ff8e4
    jmp.d32 L_004ff984                           # 004ff8e7
L_004ff8ec:
    # block 0x004ff8ec: entered by jne at 0x004ff8cf, 26 instruction(s), ends with je to 0x004ff987 (forward)
    mov edx, dword ptr [ecx + field_28]          # 004ff8ec
    mov eax, dword ptr [ebx + 4*edx]             # 004ff8ef
    cdq                                          # 004ff8f2
    and edx, 0x3                                 # 004ff8f3
    {load} add edx, eax                          # 004ff8f6
    mov eax, dword ptr [ecx + field_24]          # 004ff8f8
    sar edx, 0x2                                 # 004ff8fb
    mov eax, dword ptr [ebx + 4*eax]             # 004ff8fe
    mov dword ptr [esp + stk_3c], edx            # 004ff901
    cdq                                          # 004ff905
    and edx, 0x3                                 # 004ff906
    {load} add eax, edx                          # 004ff909
    mov edx, dword ptr [esp + stk_3c]            # 004ff90b
    sar eax, 0x2                                 # 004ff90f
    {load} add eax, edx                          # 004ff912
    cdq                                          # 004ff914
    {load} add eax, esi                          # 004ff915
    {load} adc edx, ebp                          # 004ff917
    mov dword ptr [ecx + field_34], eax          # 004ff919
    mov dword ptr [ecx + field_38], edx          # 004ff91c
    mov eax, dword ptr [edi + field_30]          # 004ff91f
    mov edx, dword ptr [edi + field_34]          # 004ff922
    {load} mov esi, eax                          # 004ff925
    {load} and esi, edx                          # 004ff927
    cmp esi, -0x1                                # 004ff929
    je.d8 L_004ff987                             # 004ff92c
    # block 0x004ff92e: entered by fall-through of je at 0x004ff92c, 4 instruction(s), ends with jne to 0x004ff93c (forward)
    mov esi, dword ptr [ecx + field_34]          # 004ff92e
    mov ebx, dword ptr [ecx + field_38]          # 004ff931
    {load} cmp esi, eax                          # 004ff934
    jne.d8 L_004ff93c                            # 004ff936
    # block 0x004ff938: entered by fall-through of jne at 0x004ff936, 2 instruction(s), ends with je to 0x004ff987 (forward)
    {load} cmp ebx, edx                          # 004ff938
    je.d8 L_004ff987                             # 004ff93a
L_004ff93c:
    # block 0x004ff93c: entered by jne at 0x004ff936; fall-through of je at 0x004ff93a, 2 instruction(s), ends with jl to 0x004ff97b (forward)
    {load} cmp ebx, edx                          # 004ff93c
    jl.d8 L_004ff97b                             # 004ff93e
    # block 0x004ff940: entered by fall-through of jl at 0x004ff93e, 1 instruction(s), ends with jg to 0x004ff946 (forward)
    jg.d8 L_004ff946                             # 004ff940
    # block 0x004ff942: entered by fall-through of jg at 0x004ff940, 2 instruction(s), ends with jbe to 0x004ff97b (forward)
    {load} cmp esi, eax                          # 004ff942
    jbe.d8 L_004ff97b                            # 004ff944
L_004ff946:
    # block 0x004ff946: entered by jg at 0x004ff940; fall-through of jbe at 0x004ff944, 6 instruction(s), ends with je to 0x004ff95a (forward)
    mov eax, dword ptr [ecx + field_34]          # 004ff946
    mov esi, dword ptr [edi + field_30]          # 004ff949
    mov edx, dword ptr [edi + field_2c]          # 004ff94c
    {load} sub eax, esi                          # 004ff94f
    test edx, edx                                # 004ff951
    je.d8 L_004ff95a                             # 004ff953
    # block 0x004ff955: entered by fall-through of je at 0x004ff953, 2 instruction(s), ends with forward jump to 0x004ff97b
    sub dword ptr [ecx + field_14], eax          # 004ff955
    jmp.d8 L_004ff97b                            # 004ff958
L_004ff95a:
    # block 0x004ff95a: entered by je at 0x004ff953, 2 instruction(s), ends with jne to 0x004ff97b (forward)
    cmp dword ptr [edi + field_38], 0x1          # 004ff95a
    jne.d8 L_004ff97b                            # 004ff95e
    # block 0x004ff960: entered by fall-through of jne at 0x004ff95e, 3 instruction(s), ends with jne to 0x004ff97b (forward)
    mov edx, dword ptr [edi + field_3c]          # 004ff960
    test edx, edx                                # 004ff963
    jne.d8 L_004ff97b                            # 004ff965
    # block 0x004ff967: entered by fall-through of jne at 0x004ff965, 7 instruction(s), ends with jle to 0x004ff97b (forward)
    mov ebx, dword ptr [ecx + field_18]          # 004ff967
    {load} add ebx, eax                          # 004ff96a
    mov eax, dword ptr [ecx + field_14]          # 004ff96c
    {load} mov edx, ebx                          # 004ff96f
    mov dword ptr [ecx + field_18], ebx          # 004ff971
    {load} cmp edx, eax                          # 004ff974
    jle.d8 L_004ff97b                            # 004ff976
    # block 0x004ff978: entered by fall-through of jle at 0x004ff976, 1 instruction(s), falls into the block at 0x004ff97b
    mov dword ptr [ecx + field_18], eax          # 004ff978
L_004ff97b:
    # block 0x004ff97b: entered by jl at 0x004ff93e; jbe at 0x004ff944; jmp at 0x004ff958; jne at 0x004ff95e; more, 3 instruction(s), falls into the block at 0x004ff984
    mov eax, dword ptr [edi + field_30]          # 004ff97b
    mov dword ptr [ecx + field_34], eax          # 004ff97e
    mov edx, dword ptr [edi + field_34]          # 004ff981
L_004ff984:
    # block 0x004ff984: entered by jmp at 0x004ff8e7, 1 instruction(s), falls into the block at 0x004ff987
    mov dword ptr [ecx + field_38], edx          # 004ff984
L_004ff987:
    # block 0x004ff987: entered by je at 0x004ff8de; je at 0x004ff92c; je at 0x004ff93a, 3 instruction(s), ends with je to 0x004ff995 (forward)
    mov eax, dword ptr [edi + field_2c]          # 004ff987
    test eax, eax                                # 004ff98a
    je.d8 L_004ff995                             # 004ff98c
    # block 0x004ff98e: entered by fall-through of je at 0x004ff98c, 1 instruction(s), falls into the block at 0x004ff995
    mov dword ptr [ecx + field_20], 0x1          # 004ff98e
L_004ff995:
    # block 0x004ff995: entered by je at 0x004ff98c, 7 instruction(s), ends with ret
    pop edi                                      # 004ff995
    pop esi                                      # 004ff996
    pop ebp                                      # 004ff997
    {load} xor eax, eax                          # 004ff998
    pop ebx                                      # 004ff99a
    add esp, 0x28                                # 004ff99b
    ret                                          # 004ff99e

# --- data items (not part of the function) -------------------------
.org 0x004ff99f - 0x401000
PAD_004ff99f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

