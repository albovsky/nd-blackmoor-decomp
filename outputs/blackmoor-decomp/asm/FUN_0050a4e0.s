# FUN_0050a4e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a4e0
# extent:       0x0050a4e0-0x0050a7c7 (743 code bytes)
# span:         0x0050a4e0-0x0050a7d0 (code 743, tables 0, padding 9)
# sha256:       5bceb008f05a61141550452e7a5f85c50d0fc4e5c328717774108ffdbaa46125
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050a450 (+0x90)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a4e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_4, field_8, field_40; [ebx + n] field_30c, field_504, field_50c, field_510; [ecx + n] field_1c; [edi + n] field_4, field_80, field_c0, field_100, field_344, field_34c; [edx + n] field_b20; [esi + n] field_fc; [esp + n] stk_10, stk_14, stk_18, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c; [scaled index + n] field_50
# callees:      calls FUN_0050be60, FUN_004fee30, FUN_0050a440, FUN_005030a0, FUN_005096c0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 232 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050a7d0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_80, 0x80  # offset +0x80
.equ field_c0, 0xc0  # offset +0xc0
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ field_30c, 0x30c  # offset +0x30c
.equ field_344, 0x344  # offset +0x344
.equ field_34c, 0x34c  # offset +0x34c
.equ field_504, 0x504  # offset +0x504
.equ field_50c, 0x50c  # offset +0x50c
.equ field_510, 0x510  # offset +0x510
.equ field_b20, 0xb20  # offset +0xb20
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_005030a0, .text + (0x005030a0 - 0x401000)
.set FUN_005096c0, .text + (0x005096c0 - 0x401000)
.set FUN_0050a440, .text + (0x0050a440 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x0050a4e0 - 0x401000
.globl FUN_0050a4e0
FUN_0050a4e0:
    # block 0x0050a4e0: entry, 21 instruction(s), calls FUN_0050be60, ends with jne to 0x0050a7bd (forward)
    sub esp, 0x24                                # 0050a4e0
    push ebx                                     # 0050a4e3
    push ebp                                     # 0050a4e4
    mov ebp, dword ptr [esp + stk_30]            # 0050a4e5
    mov ebx, dword ptr [esp + stk_34]            # 0050a4e9
    push esi                                     # 0050a4ed
    push edi                                     # 0050a4ee
    mov eax, dword ptr [ebp + field_40]          # 0050a4ef
    mov edi, dword ptr [ebx + field_510]         # 0050a4f2
    lea esi, [ebp + field_4]                     # 0050a4f8
    push 0x1                                     # 0050a4fb
    mov ecx, dword ptr [eax + field_4]           # 0050a4fd
    push esi                                     # 0050a500
    mov dword ptr [esp + stk_20], esi            # 0050a501
    mov edx, dword ptr [ecx + field_1c]          # 0050a505
    mov eax, dword ptr [edx + field_b20]         # 0050a508
    mov dword ptr [esp + stk_24], eax            # 0050a50e
    call FUN_0050be60                            # 0050a512
    add esp, 0x8                                 # 0050a517
    cmp eax, 0x1                                 # 0050a51a
    jne.d32 L_0050a7bd                           # 0050a51d
    # block 0x0050a523: entered by fall-through of jne at 0x0050a51d, 30 instruction(s), calls FUN_004fee30, FUN_0050a440, FUN_0050be60, ends with jle to 0x0050a699 (forward)
    mov ecx, dword ptr [ebx + field_504]         # 0050a523
    shl ecx, 0x2                                 # 0050a529
    push ecx                                     # 0050a52c
    push ebp                                     # 0050a52d
    call FUN_004fee30                            # 0050a52e
    mov edx, dword ptr [ebx + field_50c]         # 0050a533
    {load} mov ebp, eax                          # 0050a539
    dec edx                                      # 0050a53b
    mov dword ptr [esp + stk_34], ebp            # 0050a53c
    push edx                                     # 0050a540
    call FUN_0050a440                            # 0050a541
    push eax                                     # 0050a546
    push esi                                     # 0050a547
    call FUN_0050be60                            # 0050a548
    {disp8} mov dword ptr [ebp], eax             # 0050a54d
    mov eax, dword ptr [ebx + field_50c]         # 0050a550
    dec eax                                      # 0050a556
    push eax                                     # 0050a557
    call FUN_0050a440                            # 0050a558
    push eax                                     # 0050a55d
    push esi                                     # 0050a55e
    call FUN_0050be60                            # 0050a55f
    mov dword ptr [ebp + field_4], eax           # 0050a564
    mov ecx, dword ptr [edi]                     # 0050a567
    add esp, 0x20                                # 0050a569
    mov eax, 0x2                                 # 0050a56c
    test ecx, ecx                                # 0050a571
    mov dword ptr [esp + stk_38], 0x0            # 0050a573
    mov dword ptr [esp + stk_10], eax            # 0050a57b
    jle.d32 L_0050a699                           # 0050a57f
    # block 0x0050a585: entered by fall-through of jle at 0x0050a57f, 2 instruction(s), falls into the block at 0x0050a58c
    lea ecx, [edi + field_4]                     # 0050a585
    mov dword ptr [esp + stk_14], ecx            # 0050a588
L_0050a58c:
    # block 0x0050a58c: entered by jl at 0x0050a686, 11 instruction(s), ends with je to 0x0050a5ea (forward)
    mov edx, dword ptr [esp + stk_14]            # 0050a58c
    mov ebp, 0x1                                 # 0050a590
    {load} xor ebx, ebx                          # 0050a595
    mov esi, dword ptr [edx]                     # 0050a597
    mov ecx, dword ptr [edi + 4*esi + field_c0]  # 0050a599
    mov edx, dword ptr [edi + 4*esi + field_80]  # 0050a5a0
    shl ebp, cl                                  # 0050a5a7
    test ecx, ecx                                # 0050a5a9
    mov dword ptr [esp + stk_20], edx            # 0050a5ab
    mov dword ptr [esp + stk_24], ecx            # 0050a5af
    je.d8 L_0050a5ea                             # 0050a5b3
    # block 0x0050a5b5: entered by fall-through of je at 0x0050a5b3, 13 instruction(s), calls FUN_005030a0, ends with je to 0x0050a7bd (forward)
    mov eax, dword ptr [esp + stk_18]            # 0050a5b5
    push eax                                     # 0050a5b9
    mov eax, dword ptr [edi + 4*esi + field_100] # 0050a5ba
    lea ecx, [eax + 4*eax]                       # 0050a5c1
    lea edx, [eax + 2*ecx]                       # 0050a5c4
    mov eax, dword ptr [esp + stk_20]            # 0050a5c7
    lea ecx, [eax + 4*edx]                       # 0050a5cb
    push ecx                                     # 0050a5ce
    call FUN_005030a0                            # 0050a5cf
    {load} mov ebx, eax                          # 0050a5d4
    add esp, 0x8                                 # 0050a5d6
    cmp ebx, -0x1                                # 0050a5d9
    je.d32 L_0050a7bd                            # 0050a5dc
    # block 0x0050a5e2: entered by fall-through of je at 0x0050a5dc, 2 instruction(s), falls into the block at 0x0050a5ea
    mov edx, dword ptr [esp + stk_20]            # 0050a5e2
    mov ecx, dword ptr [esp + stk_24]            # 0050a5e6
L_0050a5ea:
    # block 0x0050a5ea: entered by je at 0x0050a5b3, 3 instruction(s), ends with jle to 0x0050a664 (forward)
    test edx, edx                                # 0050a5ea
    mov dword ptr [esp + stk_28], 0x0            # 0050a5ec
    jle.d8 L_0050a664                            # 0050a5f4
    # block 0x0050a5f6: entered by fall-through of jle at 0x0050a5f4, 6 instruction(s), falls into the block at 0x0050a60d
    mov eax, dword ptr [esp + stk_2c]            # 0050a5f6
    dec ebp                                      # 0050a5fa
    mov dword ptr [esp + stk_30], ebp            # 0050a5fb
    lea ebp, [8*esi + field_50]                  # 0050a5ff
    mov esi, dword ptr [esp + stk_10]            # 0050a606
    lea esi, [eax + 4*esi]                       # 0050a60a
L_0050a60d:
    # block 0x0050a60d: entered by jl at 0x0050a662, 7 instruction(s), ends with jl to 0x0050a64e (forward)
    mov eax, dword ptr [esp + stk_30]            # 0050a60d
    {load} and eax, ebx                          # 0050a611
    {load} add eax, ebp                          # 0050a613
    sar ebx, cl                                  # 0050a615
    mov eax, dword ptr [edi + 4*eax]             # 0050a617
    test eax, eax                                # 0050a61a
    jl.d8 L_0050a64e                             # 0050a61c
    # block 0x0050a61e: entered by fall-through of jl at 0x0050a61c, 12 instruction(s), calls FUN_005030a0, ends with je to 0x0050a7bd (forward)
    mov ecx, dword ptr [esp + stk_18]            # 0050a61e
    lea edx, [eax + 4*eax]                       # 0050a622
    push ecx                                     # 0050a625
    mov ecx, dword ptr [esp + stk_20]            # 0050a626
    lea eax, [eax + 2*edx]                       # 0050a62a
    lea edx, [ecx + 4*eax]                       # 0050a62d
    push edx                                     # 0050a630
    call FUN_005030a0                            # 0050a631
    add esp, 0x8                                 # 0050a636
    cmp eax, -0x1                                # 0050a639
    mov dword ptr [esi], eax                     # 0050a63c
    je.d32 L_0050a7bd                            # 0050a63e
    # block 0x0050a644: entered by fall-through of je at 0x0050a63e, 3 instruction(s), ends with forward jump to 0x0050a654
    mov edx, dword ptr [esp + stk_20]            # 0050a644
    mov ecx, dword ptr [esp + stk_24]            # 0050a648
    jmp.d8 L_0050a654                            # 0050a64c
L_0050a64e:
    # block 0x0050a64e: entered by jl at 0x0050a61c, 1 instruction(s), falls into the block at 0x0050a654
    mov dword ptr [esi], 0x0                     # 0050a64e
L_0050a654:
    # block 0x0050a654: entered by jmp at 0x0050a64c, 6 instruction(s), ends with jl to 0x0050a60d (backward)
    mov eax, dword ptr [esp + stk_28]            # 0050a654
    add esi, 0x4                                 # 0050a658
    inc eax                                      # 0050a65b
    {load} cmp eax, edx                          # 0050a65c
    mov dword ptr [esp + stk_28], eax            # 0050a65e
    jl.d8 L_0050a60d                             # 0050a662
L_0050a664:
    # block 0x0050a664: entered by jle at 0x0050a5f4; fall-through of jl at 0x0050a662, 12 instruction(s), ends with jl to 0x0050a58c (backward)
    mov ebx, dword ptr [esp + stk_10]            # 0050a664
    mov eax, dword ptr [esp + stk_38]            # 0050a668
    mov ecx, dword ptr [edi]                     # 0050a66c
    {load} add ebx, edx                          # 0050a66e
    mov edx, dword ptr [esp + stk_14]            # 0050a670
    inc eax                                      # 0050a674
    add edx, 0x4                                 # 0050a675
    {load} cmp eax, ecx                          # 0050a678
    mov dword ptr [esp + stk_10], ebx            # 0050a67a
    mov dword ptr [esp + stk_38], eax            # 0050a67e
    mov dword ptr [esp + stk_14], edx            # 0050a682
    jl.d32 L_0050a58c                            # 0050a686
    # block 0x0050a68c: entered by fall-through of jl at 0x0050a686, 3 instruction(s), falls into the block at 0x0050a699
    mov ebx, dword ptr [esp + stk_3c]            # 0050a68c
    mov ebp, dword ptr [esp + stk_2c]            # 0050a690
    mov eax, 0x2                                 # 0050a694
L_0050a699:
    # block 0x0050a699: entered by jle at 0x0050a57f, 4 instruction(s), ends with jle to 0x0050a7b3 (forward)
    mov ecx, dword ptr [ebx + field_504]         # 0050a699
    mov dword ptr [esp + stk_38], eax            # 0050a69f
    {load} cmp ecx, eax                          # 0050a6a3
    jle.d32 L_0050a7b3                           # 0050a6a5
    # block 0x0050a6ab: entered by fall-through of jle at 0x0050a6a5, 5 instruction(s), falls into the block at 0x0050a6c2
    lea eax, [ebp + field_8]                     # 0050a6ab
    lea ecx, [edi + field_34c]                   # 0050a6ae
    mov dword ptr [esp + stk_3c], eax            # 0050a6b4
    lea esi, [ebx + field_30c]                   # 0050a6b8
    mov dword ptr [esp + stk_14], ecx            # 0050a6be
L_0050a6c2:
    # block 0x0050a6c2: entered by jl at 0x0050a7ad, 20 instruction(s), calls FUN_005096c0, ends with jl to 0x0050a707 (forward)
    mov edx, dword ptr [esp + stk_14]            # 0050a6c2
    mov eax, dword ptr [esi]                     # 0050a6c6
    mov ecx, dword ptr [esi + field_fc]          # 0050a6c8
    mov edx, dword ptr [edx]                     # 0050a6ce
    push edx                                     # 0050a6d0
    {disp8} mov edx, dword ptr [ebp + 4*eax]     # 0050a6d1
    mov eax, dword ptr [edi + 4*eax + field_344] # 0050a6d5
    push edx                                     # 0050a6dc
    {disp8} mov edx, dword ptr [ebp + 4*ecx]     # 0050a6dd
    mov ecx, dword ptr [edi + 4*ecx + field_344] # 0050a6e1
    push edx                                     # 0050a6e8
    push eax                                     # 0050a6e9
    push ecx                                     # 0050a6ea
    call FUN_005096c0                            # 0050a6eb
    mov ecx, dword ptr [ebx + field_50c]         # 0050a6f0
    add esp, 0x14                                # 0050a6f6
    {load} sub ecx, eax                          # 0050a6f9
    {load} cmp ecx, eax                          # 0050a6fb
    mov dword ptr [esp + stk_2c], ecx            # 0050a6fd
    jl.d8 L_0050a707                             # 0050a701
    # block 0x0050a703: entered by fall-through of jl at 0x0050a701, 1 instruction(s), falls into the block at 0x0050a707
    mov dword ptr [esp + stk_2c], eax            # 0050a703
L_0050a707:
    # block 0x0050a707: entered by jl at 0x0050a701, 5 instruction(s), ends with je to 0x0050a778 (forward)
    mov edx, dword ptr [esp + stk_3c]            # 0050a707
    mov edx, dword ptr [edx]                     # 0050a70b
    test edx, edx                                # 0050a70d
    mov dword ptr [esp + stk_10], edx            # 0050a70f
    je.d8 L_0050a778                             # 0050a713
    # block 0x0050a715: entered by fall-through of je at 0x0050a713, 4 instruction(s), ends with jl to 0x0050a734 (forward)
    mov edx, dword ptr [esp + stk_2c]            # 0050a715
    {load} add edx, edx                          # 0050a719
    cmp dword ptr [esp + stk_10], edx            # 0050a71b
    jl.d8 L_0050a734                             # 0050a71f
    # block 0x0050a721: entered by fall-through of jl at 0x0050a71f, 2 instruction(s), ends with jle to 0x0050a72d (forward)
    {load} cmp ecx, eax                          # 0050a721
    jle.d8 L_0050a72d                            # 0050a723
    # block 0x0050a725: entered by fall-through of jle at 0x0050a723, 3 instruction(s), ends with forward jump to 0x0050a746
    mov ecx, dword ptr [esp + stk_10]            # 0050a725
    {load} sub ecx, eax                          # 0050a729
    jmp.d8 L_0050a746                            # 0050a72b
L_0050a72d:
    # block 0x0050a72d: entered by jle at 0x0050a723, 3 instruction(s), ends with forward jump to 0x0050a746
    sub ecx, dword ptr [esp + stk_10]            # 0050a72d
    dec ecx                                      # 0050a731
    jmp.d8 L_0050a746                            # 0050a732
L_0050a734:
    # block 0x0050a734: entered by jl at 0x0050a71f, 3 instruction(s), ends with je to 0x0050a744 (forward)
    mov ecx, dword ptr [esp + stk_10]            # 0050a734
    test cl, 0x1                                 # 0050a738
    je.d8 L_0050a744                             # 0050a73b
    # block 0x0050a73d: entered by fall-through of je at 0x0050a73b, 4 instruction(s), ends with forward jump to 0x0050a746
    inc ecx                                      # 0050a73d
    sar ecx                                      # 0050a73e
    neg ecx                                      # 0050a740
    jmp.d8 L_0050a746                            # 0050a742
L_0050a744:
    # block 0x0050a744: entered by je at 0x0050a73b, 1 instruction(s), falls into the block at 0x0050a746
    sar ecx                                      # 0050a744
L_0050a746:
    # block 0x0050a746: entered by jmp at 0x0050a72b; jmp at 0x0050a732; jmp at 0x0050a742, 14 instruction(s), ends with forward jump to 0x0050a781
    {load} add ecx, eax                          # 0050a746
    mov eax, dword ptr [esp + stk_3c]            # 0050a748
    mov dword ptr [eax], ecx                     # 0050a74c
    mov ecx, dword ptr [esi + field_fc]          # 0050a74e
    {disp8} mov edx, dword ptr [ebp + 4*ecx]     # 0050a754
    {disp8} lea eax, [ebp + 4*ecx]               # 0050a758
    and edx, 0x7fff                              # 0050a75c
    mov dword ptr [eax], edx                     # 0050a762
    mov edx, dword ptr [esi]                     # 0050a764
    {disp8} mov ecx, dword ptr [ebp + 4*edx]     # 0050a766
    {disp8} lea eax, [ebp + 4*edx]               # 0050a76a
    and ecx, 0x7fff                              # 0050a76e
    mov dword ptr [eax], ecx                     # 0050a774
    jmp.d8 L_0050a781                            # 0050a776
L_0050a778:
    # block 0x0050a778: entered by je at 0x0050a713, 3 instruction(s), falls into the block at 0x0050a781
    mov ecx, dword ptr [esp + stk_3c]            # 0050a778
    or ah, -0x80                                 # 0050a77c
    mov dword ptr [ecx], eax                     # 0050a77f
L_0050a781:
    # block 0x0050a781: entered by jmp at 0x0050a776, 14 instruction(s), ends with jl to 0x0050a6c2 (backward)
    mov edx, dword ptr [esp + stk_14]            # 0050a781
    mov eax, dword ptr [esp + stk_38]            # 0050a785
    mov ecx, 0x4                                 # 0050a789
    inc eax                                      # 0050a78e
    {load} add edx, ecx                          # 0050a78f
    {load} add esi, ecx                          # 0050a791
    mov dword ptr [esp + stk_14], edx            # 0050a793
    mov edx, dword ptr [esp + stk_3c]            # 0050a797
    {load} add edx, ecx                          # 0050a79b
    mov ecx, dword ptr [ebx + field_504]         # 0050a79d
    {load} cmp eax, ecx                          # 0050a7a3
    mov dword ptr [esp + stk_38], eax            # 0050a7a5
    mov dword ptr [esp + stk_3c], edx            # 0050a7a9
    jl.d32 L_0050a6c2                            # 0050a7ad
L_0050a7b3:
    # block 0x0050a7b3: entered by jle at 0x0050a6a5; fall-through of jl at 0x0050a7ad, 7 instruction(s), ends with ret
    pop edi                                      # 0050a7b3
    {load} mov eax, ebp                          # 0050a7b4
    pop esi                                      # 0050a7b6
    pop ebp                                      # 0050a7b7
    pop ebx                                      # 0050a7b8
    add esp, 0x24                                # 0050a7b9
    ret                                          # 0050a7bc
L_0050a7bd:
    # block 0x0050a7bd: entered by jne at 0x0050a51d; je at 0x0050a5dc; je at 0x0050a63e, 7 instruction(s), ends with ret
    pop edi                                      # 0050a7bd
    pop esi                                      # 0050a7be
    pop ebp                                      # 0050a7bf
    {load} xor eax, eax                          # 0050a7c0
    pop ebx                                      # 0050a7c2
    add esp, 0x24                                # 0050a7c3
    ret                                          # 0050a7c6

# --- data items (not part of the function) -------------------------
.org 0x0050a7c7 - 0x401000
PAD_0050a7c7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

