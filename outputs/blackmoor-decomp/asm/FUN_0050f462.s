# FUN_0050f462
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f462
# extent:       0x0050f462-0x0050f635 (467 code bytes)
# span:         0x0050f462-0x0050f635 (code 467, tables 0, padding 0)
# sha256:       ff051aecd058e325072a339453c4b1b08a380e8a4ccc43ca46d3362169bebeb3
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f462
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_8; [esp + n] stk_8, stk_c, stk_e, stk_f, stk_10, stk_14, stk_16, stk_17
# callees:      calls FUN_00513c35, FUN_00513c65, FUN_00513c20, tail jump LOC_00513d09, FUN_00513bc0, FUN_00515b32, FUN_0050f635, tail jump FUN_00513cbe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 127 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050f635
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_e, 0xe  # offset +0xe
.equ stk_f, 0xf  # offset +0xf
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_16, 0x16  # offset +0x16
.equ stk_17, 0x17  # offset +0x17

# --- external targets -----------------------------------------------
.set FUN_0050f635, .text + (0x0050f635 - 0x401000)
.set FUN_00513bc0, .text + (0x00513bc0 - 0x401000)
.set FUN_00513c20, .text + (0x00513c20 - 0x401000)
.set FUN_00513c35, .text + (0x00513c35 - 0x401000)
.set FUN_00513c65, .text + (0x00513c65 - 0x401000)
.set FUN_00513cbe, .text + (0x00513cbe - 0x401000)
.set LOC_00513d09, .text + (0x00513d09 - 0x401000)
.set FUN_00515b32, .text + (0x00515b32 - 0x401000)

.org 0x0050f462 - 0x401000
.globl FUN_0050f462
FUN_0050f462:
    # block 0x0050f462: entry, 6 instruction(s), ends with je to 0x0050f476 (forward)
    {load} mov ecx, eax                          # 0050f462
    push eax                                     # 0050f464
    wait                                         # 0050f465
    fnstcw word ptr [esp]                        # 0050f466
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050f469
    je.d8 L_0050f476                             # 0050f46f
    # block 0x0050f471: entered by fall-through of je at 0x0050f46f, 1 instruction(s), calls FUN_00513c35, falls into the block at 0x0050f476
    call FUN_00513c35                            # 0050f471
L_0050f476:
    # block 0x0050f476: entered by je at 0x0050f46f, 4 instruction(s), ends with je to 0x0050f529 (forward)
    and ecx, 0x7ff00000                          # 0050f476
    lea edx, [esp + stk_8]                       # 0050f47c
    cmp ecx, 0x7ff00000                          # 0050f480
    je.d32 L_0050f529                            # 0050f486
    # block 0x0050f48c: entered by fall-through of je at 0x0050f486, 2 instruction(s), calls FUN_00513c65, ends with je to 0x0050f525 (forward)
    call FUN_00513c65                            # 0050f48c
    je.d32 L_0050f525                            # 0050f491
    # block 0x0050f497: entered by fall-through of je at 0x0050f491, 2 instruction(s), ends with je to 0x0050f598 (forward)
    test eax, 0x7ff00000                         # 0050f497
    je.d32 L_0050f598                            # 0050f49c
L_0050f4a2:
    # block 0x0050f4a2: entered by jne at 0x0050f5a5; fall-through of je at 0x0050f49c, 3 instruction(s), ends with jne to 0x0050f610 (forward)
    mov cl, byte ptr [esp + stk_f]               # 0050f4a2
    and cl, -0x80                                # 0050f4a6
    jne.d32 L_0050f610                           # 0050f4a9
L_0050f4af:
    # block 0x0050f4af: entered by jne at 0x0050f61b; fall-through of jne at 0x0050f4a9, 4 instruction(s), calls FUN_00513c20, ends with jne to 0x0050f4bd (forward)
    fyl2x                                        # 0050f4af
    call FUN_00513c20                            # 0050f4b1
    cmp cl, 0x1                                  # 0050f4b6
    jne.d8 L_0050f4bd                            # 0050f4b9
    # block 0x0050f4bb: entered by fall-through of jne at 0x0050f4b9, 1 instruction(s), falls into the block at 0x0050f4bd
    fchs                                         # 0050f4bb
L_0050f4bd:
    # block 0x0050f4bd: entered by jne at 0x0050f4b9, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050f4bd
    jne.d32 FUN_00513cbe                         # 0050f4c4
    # block 0x0050f4ca: entered by fall-through of jne at 0x0050f4c4, 3 instruction(s), ends with forward jump to 0x00513d09
    lea ecx, [0x567ff8]                          # 0050f4ca
    mov edx, 0x1d                                # 0050f4d0
    jmp.d32 LOC_00513d09                         # 0050f4d5
L_0050f4da:
    # block 0x0050f4da: entered by jmp at 0x0050f513; jmp at 0x0050f523; jmp at 0x0050f593; jmp at 0x0050f5df; more, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050f4da
    jne.d32 FUN_00513cbe                         # 0050f4e1
    # block 0x0050f4e7: entered by fall-through of jne at 0x0050f4e1, 5 instruction(s), calls FUN_00513bc0, ends with ret
    lea ecx, [0x567ff8]                          # 0050f4e7
    mov edx, 0x1d                                # 0050f4ed
    call FUN_00513bc0                            # 0050f4f2
    pop edx                                      # 0050f4f7
    ret                                          # 0050f4f8
L_0050f4f9:
    # block 0x0050f4f9: entered by jne at 0x0050f534, 4 instruction(s), calls FUN_00513c65, ends with jne to 0x0050f50c (forward)
    lea edx, [esp + stk_8]                       # 0050f4f9
    call FUN_00513c65                            # 0050f4fd
    test byte ptr [esp + stk_16], 0x8            # 0050f502
    jne.d8 L_0050f50c                            # 0050f507
    # block 0x0050f509: entered by fall-through of jne at 0x0050f507, 2 instruction(s), ends with forward jump to 0x0050f53f
    inc ecx                                      # 0050f509
    jmp.d8 L_0050f53f                            # 0050f50a
L_0050f50c:
    # block 0x0050f50c: entered by jne at 0x0050f507; jne at 0x0050f51a, 3 instruction(s), ends with backward jump to 0x0050f4da
    faddp st(1), st                              # 0050f50c
    mov eax, 0x1                                 # 0050f50e
    jmp.d8 L_0050f4da                            # 0050f513
L_0050f515:
    # block 0x0050f515: entered by jne at 0x0050f55b, 2 instruction(s), ends with jne to 0x0050f50c (backward)
    test byte ptr [esp + stk_e], 0x8             # 0050f515
    jne.d8 L_0050f50c                            # 0050f51a
L_0050f51c:
    # block 0x0050f51c: entered by jne at 0x0050f55f; fall-through of jne at 0x0050f51a, 3 instruction(s), ends with backward jump to 0x0050f4da
    faddp st(1), st                              # 0050f51c
    mov eax, 0x7                                 # 0050f51e
    jmp.d8 L_0050f4da                            # 0050f523
L_0050f525:
    # block 0x0050f525: entered by je at 0x0050f491, 2 instruction(s), ends with forward jump to 0x0050f53f
    {load} xor ecx, ecx                          # 0050f525
    jmp.d8 L_0050f53f                            # 0050f527
L_0050f529:
    # block 0x0050f529: entered by je at 0x0050f486, 4 instruction(s), ends with jne to 0x0050f4f9 (backward)
    {load} xor ecx, ecx                          # 0050f529
    and eax, 0xfffff                             # 0050f52b
    or eax, dword ptr [esp + stk_10]             # 0050f530
    jne.d8 L_0050f4f9                            # 0050f534
    # block 0x0050f536: entered by fall-through of jne at 0x0050f534, 2 instruction(s), calls FUN_00513c65, falls into the block at 0x0050f53f
    lea edx, [esp + stk_8]                       # 0050f536
    call FUN_00513c65                            # 0050f53a
L_0050f53f:
    # block 0x0050f53f: entered by jmp at 0x0050f50a; jmp at 0x0050f527, 6 instruction(s), ends with jne to 0x0050f55d (forward)
    mov eax, dword ptr [esp + stk_c]             # 0050f53f
    {load} mov edx, eax                          # 0050f543
    and eax, 0x7ff00000                          # 0050f545
    and edx, 0xfffff                             # 0050f54a
    cmp eax, 0x7ff00000                          # 0050f550
    jne.d8 L_0050f55d                            # 0050f555
    # block 0x0050f557: entered by fall-through of jne at 0x0050f555, 2 instruction(s), ends with jne to 0x0050f515 (backward)
    or edx, dword ptr [esp + stk_8]              # 0050f557
    jne.d8 L_0050f515                            # 0050f55b
L_0050f55d:
    # block 0x0050f55d: entered by jne at 0x0050f555; fall-through of jne at 0x0050f55b, 2 instruction(s), ends with jne to 0x0050f51c (backward)
    test ecx, ecx                                # 0050f55d
    jne.d8 L_0050f51c                            # 0050f55f
    # block 0x0050f561: entered by fall-through of jne at 0x0050f55f, 16 instruction(s), calls FUN_00515b32, ends with je to 0x00513cbe (forward)
    sub esp, 0x74                                # 0050f561
    {load} mov ecx, esp                          # 0050f564
    push ecx                                     # 0050f566
    sub esp, 0x10                                # 0050f567
    fstp qword ptr [esp]                         # 0050f56a
    fstp qword ptr [esp + stk_8]                 # 0050f56d
    wait                                         # 0050f571
    fnsave [ecx + field_8]                       # 0050f572
    call FUN_00515b32                            # 0050f575
    add esp, 0x10                                # 0050f57a
    pop ecx                                      # 0050f57d
    frstor [ecx + field_8]                       # 0050f57e
    fld qword ptr [ecx]                          # 0050f581
    add esp, 0x74                                # 0050f583
    test eax, eax                                # 0050f586
    je.d32 FUN_00513cbe                          # 0050f588
    # block 0x0050f58e: entered by fall-through of je at 0x0050f588, 2 instruction(s), ends with backward jump to 0x0050f4da
    mov eax, 0x1                                 # 0050f58e
    jmp.d32 L_0050f4da                           # 0050f593
L_0050f598:
    # block 0x0050f598: entered by je at 0x0050f49c, 4 instruction(s), ends with jne to 0x0050f4a2 (backward)
    mov eax, dword ptr [esp + stk_c]             # 0050f598
    and eax, 0xfffff                             # 0050f59c
    or eax, dword ptr [esp + stk_8]              # 0050f5a1
    jne.d32 L_0050f4a2                           # 0050f5a5
    # block 0x0050f5ab: entered by fall-through of jne at 0x0050f5a5, 4 instruction(s), ends with je to 0x0050f5f5 (forward)
    fstp st(0)                                   # 0050f5ab
    mov eax, dword ptr [esp + stk_14]            # 0050f5ad
    test eax, 0x7ff00000                         # 0050f5b1
    je.d8 L_0050f5f5                             # 0050f5b6
    # block 0x0050f5b8: entered by fall-through of je at 0x0050f5b6, 5 instruction(s), calls FUN_0050f635, ends with je to 0x0050f5e4 (forward)
    call FUN_0050f635                            # 0050f5b8
    mov ch, byte ptr [esp + stk_f]               # 0050f5bd
    shr ch, 0x7                                  # 0050f5c1
    test dword ptr [esp + stk_17], 0x80          # 0050f5c4
    je.d8 L_0050f5e4                             # 0050f5cc
    # block 0x0050f5ce: entered by fall-through of je at 0x0050f5cc, 3 instruction(s), ends with je to 0x0050f5da (forward)
    fld tbyte ptr [0x5688b0]                     # 0050f5ce
    test ch, cl                                  # 0050f5d4
    je.d8 L_0050f5da                             # 0050f5d6
    # block 0x0050f5d8: entered by fall-through of je at 0x0050f5d6, 1 instruction(s), falls into the block at 0x0050f5da
    fchs                                         # 0050f5d8
L_0050f5da:
    # block 0x0050f5da: entered by je at 0x0050f5d6, 2 instruction(s), ends with backward jump to 0x0050f4da
    mov eax, 0x2                                 # 0050f5da
    jmp.d32 L_0050f4da                           # 0050f5df
L_0050f5e4:
    # block 0x0050f5e4: entered by je at 0x0050f5cc, 3 instruction(s), ends with je to 0x00513cbe (forward)
    fldz                                         # 0050f5e4
    test ch, cl                                  # 0050f5e6
    je.d32 FUN_00513cbe                          # 0050f5e8
    # block 0x0050f5ee: entered by fall-through of je at 0x0050f5e8, 2 instruction(s), ends with forward jump to 0x00513cbe
    fchs                                         # 0050f5ee
    jmp.d32 FUN_00513cbe                         # 0050f5f0
L_0050f5f5:
    # block 0x0050f5f5: entered by je at 0x0050f5b6, 4 instruction(s), ends with jne to 0x0050f609 (forward)
    fstp st(0)                                   # 0050f5f5
    and eax, 0xfffff                             # 0050f5f7
    or eax, dword ptr [esp + stk_10]             # 0050f5fc
    jne.d8 L_0050f609                            # 0050f600
    # block 0x0050f602: entered by fall-through of jne at 0x0050f600, 2 instruction(s), ends with forward jump to 0x00513cbe
    fld1                                         # 0050f602
    jmp.d32 FUN_00513cbe                         # 0050f604
L_0050f609:
    # block 0x0050f609: entered by jne at 0x0050f600, 2 instruction(s), ends with forward jump to 0x00513cbe
    fldz                                         # 0050f609
    jmp.d32 FUN_00513cbe                         # 0050f60b
L_0050f610:
    # block 0x0050f610: entered by jne at 0x0050f4a9, 5 instruction(s), calls FUN_0050f635, ends with jne to 0x0050f4af (backward)
    fld st(1)                                    # 0050f610
    call FUN_0050f635                            # 0050f612
    fchs                                         # 0050f617
    test cl, cl                                  # 0050f619
    jne.d32 L_0050f4af                           # 0050f61b
    # block 0x0050f621: entered by fall-through of jne at 0x0050f61b, 5 instruction(s), ends with backward jump to 0x0050f4da
    fstp st(0)                                   # 0050f621
    fstp st(0)                                   # 0050f623
    fld tbyte ptr [0x568910]                     # 0050f625
    mov eax, 0x1                                 # 0050f62b
    jmp.d32 L_0050f4da                           # 0050f630

