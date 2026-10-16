# FUN_0051852e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051852e
# extent:       0x0051852e-0x00518734 (518 code bytes)
# span:         0x0051852e-0x00518734 (code 518, tables 0, padding 0)
# sha256:       82d0c7732675d9d98a123833e0cbeada44596b1a6c7587e8bb2c17ae1b220a9c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xd92)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051852e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_10, stk_14, stk_16, stk_18, stk_1c, stk_28, stk_2c, stk_2e, stk_30, stk_34, stk_38 and 1 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 142 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518734
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_16, 0x16  # offset +0x16
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_2e, 0x2e  # offset +0x2e
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------

.org 0x0051852e - 0x401000
.globl FUN_0051852e
FUN_0051852e:
    # block 0x0051852e: entry, 7 instruction(s), ends with jne to 0x005186c8 (forward)
    push eax                                     # 0051852e
    push ebx                                     # 0051852f
    push ecx                                     # 00518530
    mov eax, dword ptr [esp + stk_16]            # 00518531
    xor eax, 0x700                               # 00518535
    test eax, 0x700                              # 0051853a
    jne.d32 L_005186c8                           # 0051853f
    # block 0x00518545: entered by fall-through of jne at 0x0051853f, 4 instruction(s), ends with je to 0x005186c8 (forward)
    shr eax, 0xb                                 # 00518545
    and eax, 0xf                                 # 00518548
    cmp byte ptr [eax + 0x568cec], 0x0           # 0051854b
    je.d32 L_005186c8                            # 00518552
    # block 0x00518558: entered by fall-through of je at 0x00518552, 4 instruction(s), ends with je to 0x005186c8 (forward)
    mov eax, dword ptr [esp + stk_16]            # 00518558
    and eax, 0x7fff0000                          # 0051855c
    cmp eax, 0x7fff0000                          # 00518561
    je.d32 L_005186c8                            # 00518566
    # block 0x0051856c: entered by fall-through of je at 0x00518566, 3 instruction(s), ends with je to 0x005186c8 (forward)
    mov eax, dword ptr [esp + stk_2e]            # 0051856c
    and eax, 0x7fff0000                          # 00518570
    je.d32 L_005186c8                            # 00518575
    # block 0x0051857b: entered by fall-through of je at 0x00518575, 2 instruction(s), ends with je to 0x005186c8 (forward)
    cmp eax, 0x7fff0000                          # 0051857b
    je.d32 L_005186c8                            # 00518580
    # block 0x00518586: entered by fall-through of je at 0x00518580, 3 instruction(s), ends with jne to 0x005186c8 (forward)
    mov eax, dword ptr [esp + stk_2c]            # 00518586
    {load} add eax, eax                          # 0051858a
    jne.d32 L_005186c8                           # 0051858c
    # block 0x00518592: entered by fall-through of jne at 0x0051858c, 3 instruction(s), ends with jne to 0x005186c8 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00518592
    {load} add eax, eax                          # 00518596
    jne.d32 L_005186c8                           # 00518598
    # block 0x0051859e: entered by fall-through of jne at 0x00518598, 7 instruction(s), ends with ja to 0x00518616 (forward)
    mov eax, dword ptr [esp + stk_18]            # 0051859e
    and eax, 0x7fff                              # 005185a2
    add eax, 0x3f                                # 005185a7
    mov ebx, dword ptr [esp + stk_30]            # 005185aa
    and ebx, 0x7fff                              # 005185ae
    {load} sub ebx, eax                          # 005185b4
    ja.d8 L_00518616                             # 005185b6
L_005185b8:
    # block 0x005185b8: entered by jmp at 0x00518614; fall-through of ja at 0x005185b6, 7 instruction(s), ends with js to 0x005186c8 (forward)
    mov eax, dword ptr [esp + stk_18]            # 005185b8
    and eax, 0x7fff                              # 005185bc
    add eax, 0xa                                 # 005185c1
    mov ebx, dword ptr [esp + stk_30]            # 005185c4
    and ebx, 0x7fff                              # 005185c8
    {load} sub ebx, eax                          # 005185ce
    js.d32 L_005186c8                            # 005185d0
    # block 0x005185d6: entered by fall-through of js at 0x005185d0, 20 instruction(s), ends with backward jump to 0x005185b8
    fld tbyte ptr [esp + stk_28]                 # 005185d6
    mov eax, dword ptr [esp + stk_18]            # 005185da
    mov ebx, dword ptr [esp + stk_30]            # 005185de
    and ebx, 0x7fff                              # 005185e2
    {load} mov ecx, ebx                          # 005185e8
    {load} sub ebx, eax                          # 005185ea
    and ebx, 0x7                                 # 005185ec
    or ebx, 0x4                                  # 005185ef
    {load} sub ecx, ebx                          # 005185f2
    {load} mov ebx, eax                          # 005185f4
    and ebx, 0x8000                              # 005185f6
    {load} or ecx, ebx                           # 005185fc
    mov dword ptr [esp + stk_18], ecx            # 005185fe
    fld tbyte ptr [esp + stk_10]                 # 00518602
    mov dword ptr [esp + stk_18], eax            # 00518606
    fxch st(1)                                   # 0051860a
    fprem                                        # 0051860c
    fstp tbyte ptr [esp + stk_28]                # 0051860e
    fstp st(0)                                   # 00518612
    jmp.d8 L_005185b8                            # 00518614
L_00518616:
    # block 0x00518616: entered by ja at 0x005185b6, 2 instruction(s), ends with jne to 0x00518626 (forward)
    test ebx, 0x2                                # 00518616
    jne.d8 L_00518626                            # 0051861c
    # block 0x0051861e: entered by fall-through of jne at 0x0051861c, 2 instruction(s), falls into the block at 0x00518626
    fld tbyte ptr [esp + stk_10]                 # 0051861e
    fstp tbyte ptr [esp + stk_1c]                # 00518622
L_00518626:
    # block 0x00518626: entered by jne at 0x0051861c, 24 instruction(s), falls into the block at 0x00518680
    fnstcw word ptr [esp + stk_34]               # 00518626
    mov eax, dword ptr [esp + stk_34]            # 0051862a
    or eax, 0x33f                                # 0051862e
    mov dword ptr [esp + stk_38], eax            # 00518633
    fldcw word ptr [esp + stk_38]                # 00518637
    mov eax, dword ptr [esp + stk_18]            # 0051863b
    and eax, 0x7fff                              # 0051863f
    mov ebx, dword ptr [esp + stk_30]            # 00518644
    and ebx, 0x7fff                              # 00518648
    {load} sub ebx, eax                          # 0051864e
    and ebx, 0x3f                                # 00518650
    or ebx, 0x20                                 # 00518653
    add ebx, 0x1                                 # 00518656
    {load} mov ecx, ebx                          # 00518659
    mov eax, dword ptr [esp + stk_18]            # 0051865b
    mov ebx, dword ptr [esp + stk_30]            # 0051865f
    and ebx, 0x7fff                              # 00518663
    and eax, 0x8000                              # 00518669
    {load} or ebx, eax                           # 0051866e
    mov dword ptr [esp + stk_18], ebx            # 00518670
    fld tbyte ptr [esp + stk_10]                 # 00518674
    fabs                                         # 00518678
    fld tbyte ptr [esp + stk_28]                 # 0051867a
    fabs                                         # 0051867e
L_00518680:
    # block 0x00518680: entered by jne at 0x0051869a, 4 instruction(s), ends with jne to 0x0051868d (forward)
    fcom st(1)                                   # 00518680
    fnstsw ax                                    # 00518682
    and eax, 0x100                               # 00518684
    jne.d8 L_0051868d                            # 00518689
    # block 0x0051868b: entered by fall-through of jne at 0x00518689, 1 instruction(s), falls into the block at 0x0051868d
    fsub st, st(1)                               # 0051868b
L_0051868d:
    # block 0x0051868d: entered by jne at 0x00518689, 5 instruction(s), ends with jne to 0x00518680 (backward)
    fxch st(1)                                   # 0051868d
    fmul qword ptr [0x568d1c]                    # 0051868f
    fxch st(1)                                   # 00518695
    sub ecx, 0x1                                 # 00518697
    jne.d8 L_00518680                            # 0051869a
    # block 0x0051869c: entered by fall-through of jne at 0x0051869a, 11 instruction(s), ends with je to 0x005186d2 (forward)
    mov ebx, dword ptr [esp + stk_30]            # 0051869c
    fstp tbyte ptr [esp + stk_28]                # 005186a0
    fstp st(0)                                   # 005186a4
    fld tbyte ptr [esp + stk_1c]                 # 005186a6
    fld tbyte ptr [0x568d24]                     # 005186aa
    fprem1                                       # 005186b0
    fstp st(0)                                   # 005186b2
    fld tbyte ptr [esp + stk_28]                 # 005186b4
    fldcw word ptr [esp + stk_34]                # 005186b8
    and ebx, 0x8000                              # 005186bc
    je.d8 L_005186d2                             # 005186c2
    # block 0x005186c4: entered by fall-through of je at 0x005186c2, 2 instruction(s), ends with forward jump to 0x005186d2
    fchs                                         # 005186c4
    jmp.d8 L_005186d2                            # 005186c6
L_005186c8:
    # block 0x005186c8: entered by jne at 0x0051853f; je at 0x00518552; je at 0x00518566; je at 0x00518575; more, 3 instruction(s), falls into the block at 0x005186d2
    fld tbyte ptr [esp + stk_10]                 # 005186c8
    fld tbyte ptr [esp + stk_28]                 # 005186cc
    fprem1                                       # 005186d0
L_005186d2:
    # block 0x005186d2: entered by je at 0x005186c2; jmp at 0x005186c6, 2 instruction(s), ends with je to 0x00518730 (forward)
    test edx, 0x3                                # 005186d2
    je.d8 L_00518730                             # 005186d8
    # block 0x005186da: entered by fall-through of je at 0x005186d8, 3 instruction(s), ends with je to 0x00518705 (forward)
    fnstsw word ptr [esp + stk_3c]               # 005186da
    test edx, 0x1                                # 005186de
    je.d8 L_00518705                             # 005186e4
    # block 0x005186e6: entered by fall-through of je at 0x005186e4, 7 instruction(s), falls into the block at 0x00518705
    fnstcw word ptr [esp + stk_34]               # 005186e6
    mov eax, dword ptr [esp + stk_34]            # 005186ea
    or eax, 0x300                                # 005186ee
    mov dword ptr [esp + stk_38], eax            # 005186f3
    fldcw word ptr [esp + stk_38]                # 005186f7
    fmul qword ptr [0x568d0c]                    # 005186fb
    fldcw word ptr [esp + stk_34]                # 00518701
L_00518705:
    # block 0x00518705: entered by je at 0x005186e4, 12 instruction(s), falls into the block at 0x00518730
    mov eax, dword ptr [esp + stk_3c]            # 00518705
    fxch st(1)                                   # 00518709
    fstp st(0)                                   # 0051870b
    fld tbyte ptr [esp + stk_1c]                 # 0051870d
    fxch st(1)                                   # 00518711
    and eax, 0x4300                              # 00518713
    sub esp, 0x1c                                # 00518718
    fnstenv [esp]                                # 0051871b
    and dword ptr [esp + stk_4], 0xbcff          # 0051871e
    or dword ptr [esp + stk_4], eax              # 00518726
    fldenv [esp]                                 # 0051872a
    add esp, 0x1c                                # 0051872d
L_00518730:
    # block 0x00518730: entered by je at 0x005186d8, 4 instruction(s), ends with ret
    pop ecx                                      # 00518730
    pop ebx                                      # 00518731
    pop eax                                      # 00518732
    ret                                          # 00518733

