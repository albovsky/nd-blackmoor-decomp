# FUN_004fd530
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd530
# extent:       0x004fd530-0x004fd642 (274 code bytes)
# span:         0x004fd530-0x004fd650 (code 274, tables 0, padding 14)
# sha256:       749bf6cde7d6c121dfde42fa89130f2d8b1b32ac6290dd7f27b6afae1634097b
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd530
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c; [esp + n] stk_10, stk_14, stk_1c, stk_20, stk_30, stk_34
# callees:      calls FUN_004fd650, FUN_004fd2b0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 116 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fd650, .text + (0x004fd650 - 0x401000)

.org 0x004fd530 - 0x401000
.globl FUN_004fd530
FUN_004fd530:
    # block 0x004fd530: entry, 13 instruction(s), ends with forward jump to 0x004fd556
    sub esp, 0x10                                # 004fd530
    push ebx                                     # 004fd533
    push ebp                                     # 004fd534
    push esi                                     # 004fd535
    mov esi, dword ptr [esp + stk_20]            # 004fd536
    or ebp, -0x1                                 # 004fd53a
    push edi                                     # 004fd53d
    mov ecx, dword ptr [esi + field_8]           # 004fd53e
    mov eax, dword ptr [esi + field_c]           # 004fd541
    {load} mov ebx, ecx                          # 004fd544
    {load} mov edi, eax                          # 004fd546
    mov dword ptr [esp + stk_1c], ebp            # 004fd548
    jmp.d8 L_004fd556                            # 004fd54c
L_004fd54e:
    # block 0x004fd54e: entered by je at 0x004fd5e7, 2 instruction(s), falls into the block at 0x004fd556
    mov ecx, dword ptr [esp + stk_10]            # 004fd54e
    mov eax, dword ptr [esp + stk_14]            # 004fd552
L_004fd556:
    # block 0x004fd556: entered by jmp at 0x004fd54c, 7 instruction(s), ends with jg to 0x004fd57f (forward)
    add ecx, 0xffffdecc                          # 004fd556
    adc eax, -0x1                                # 004fd55c
    {load} xor edx, edx                          # 004fd55f
    {load} cmp eax, edx                          # 004fd561
    mov dword ptr [esp + stk_10], ecx            # 004fd563
    mov dword ptr [esp + stk_14], eax            # 004fd567
    jg.d8 L_004fd57f                             # 004fd56b
    # block 0x004fd56d: entered by fall-through of jg at 0x004fd56b, 1 instruction(s), ends with jl to 0x004fd573 (forward)
    jl.d8 L_004fd573                             # 004fd56d
    # block 0x004fd56f: entered by fall-through of jl at 0x004fd56d, 2 instruction(s), ends with jae to 0x004fd57f (forward)
    {load} cmp ecx, edx                          # 004fd56f
    jae.d8 L_004fd57f                            # 004fd571
L_004fd573:
    # block 0x004fd573: entered by jl at 0x004fd56d; fall-through of jae at 0x004fd571, 4 instruction(s), falls into the block at 0x004fd57f
    mov dword ptr [esp + stk_10], edx            # 004fd573
    mov dword ptr [esp + stk_14], edx            # 004fd577
    {load} mov ecx, edx                          # 004fd57b
    {load} mov eax, edx                          # 004fd57d
L_004fd57f:
    # block 0x004fd57f: entered by jg at 0x004fd56b; jae at 0x004fd571, 9 instruction(s), calls FUN_004fd650, ends with jg to 0x004fd5dc (forward)
    push eax                                     # 004fd57f
    push ecx                                     # 004fd580
    push esi                                     # 004fd581
    call FUN_004fd650                            # 004fd582
    mov eax, dword ptr [esi + field_c]           # 004fd587
    mov ecx, dword ptr [esi + field_8]           # 004fd58a
    add esp, 0xc                                 # 004fd58d
    {load} cmp eax, edi                          # 004fd590
    jg.d8 L_004fd5dc                             # 004fd592
    # block 0x004fd594: entered by fall-through of jg at 0x004fd592, 1 instruction(s), ends with jl to 0x004fd59a (forward)
    jl.d8 L_004fd59a                             # 004fd594
    # block 0x004fd596: entered by fall-through of jl at 0x004fd594, 2 instruction(s), ends with jae to 0x004fd5dc (forward)
    {load} cmp ecx, ebx                          # 004fd596
    jae.d8 L_004fd5dc                            # 004fd598
L_004fd59a:
    # block 0x004fd59a: entered by jl at 0x004fd594; jl at 0x004fd5d4; jb at 0x004fd5da; fall-through of jae at 0x004fd598, 13 instruction(s), calls FUN_004fd2b0, ends with jne to 0x004fd5bc (forward)
    {load} mov edx, ebx                          # 004fd59a
    {load} sub edx, ecx                          # 004fd59c
    {load} mov ecx, edi                          # 004fd59e
    {load} sbb ecx, eax                          # 004fd5a0
    push ecx                                     # 004fd5a2
    push edx                                     # 004fd5a3
    mov edx, dword ptr [esp + stk_30]            # 004fd5a4
    push edx                                     # 004fd5a8
    push esi                                     # 004fd5a9
    call FUN_004fd2b0                            # 004fd5aa
    add esp, 0x10                                # 004fd5af
    cmp eax, -0x80                               # 004fd5b2
    jne.d8 L_004fd5bc                            # 004fd5b5
    # block 0x004fd5b7: entered by fall-through of jne at 0x004fd5b5, 2 instruction(s), ends with je to 0x004fd626 (forward)
    cmp edx, -0x1                                # 004fd5b7
    je.d8 L_004fd626                             # 004fd5ba
L_004fd5bc:
    # block 0x004fd5bc: entered by jne at 0x004fd5b5; fall-through of je at 0x004fd5ba, 2 instruction(s), ends with jl to 0x004fd5dc (forward)
    test edx, edx                                # 004fd5bc
    jl.d8 L_004fd5dc                             # 004fd5be
    # block 0x004fd5c0: entered by fall-through of jl at 0x004fd5be, 1 instruction(s), ends with jg to 0x004fd5c6 (forward)
    jg.d8 L_004fd5c6                             # 004fd5c0
    # block 0x004fd5c2: entered by fall-through of jg at 0x004fd5c0, 2 instruction(s), ends with jb to 0x004fd5dc (forward)
    test eax, eax                                # 004fd5c2
    jb.d8 L_004fd5dc                             # 004fd5c4
L_004fd5c6:
    # block 0x004fd5c6: entered by jg at 0x004fd5c0; fall-through of jb at 0x004fd5c4, 6 instruction(s), ends with jl to 0x004fd59a (backward)
    mov ecx, dword ptr [esi + field_8]           # 004fd5c6
    {load} mov ebp, eax                          # 004fd5c9
    mov eax, dword ptr [esi + field_c]           # 004fd5cb
    mov dword ptr [esp + stk_1c], edx            # 004fd5ce
    {load} cmp eax, edi                          # 004fd5d2
    jl.d8 L_004fd59a                             # 004fd5d4
    # block 0x004fd5d6: entered by fall-through of jl at 0x004fd5d4, 1 instruction(s), ends with jg to 0x004fd5dc (forward)
    jg.d8 L_004fd5dc                             # 004fd5d6
    # block 0x004fd5d8: entered by fall-through of jg at 0x004fd5d6, 2 instruction(s), ends with jb to 0x004fd59a (backward)
    {load} cmp ecx, ebx                          # 004fd5d8
    jb.d8 L_004fd59a                             # 004fd5da
L_004fd5dc:
    # block 0x004fd5dc: entered by jg at 0x004fd592; jae at 0x004fd598; jl at 0x004fd5be; jb at 0x004fd5c4; more, 5 instruction(s), ends with je to 0x004fd54e (backward)
    mov edx, dword ptr [esp + stk_1c]            # 004fd5dc
    {load} mov eax, ebp                          # 004fd5e0
    {load} and eax, edx                          # 004fd5e2
    cmp eax, -0x1                                # 004fd5e4
    je.d32 L_004fd54e                            # 004fd5e7
    # block 0x004fd5ed: entered by fall-through of je at 0x004fd5e7, 14 instruction(s), calls FUN_004fd650, FUN_004fd2b0, ends with jg to 0x004fd636 (forward)
    {load} mov edi, edx                          # 004fd5ed
    push edi                                     # 004fd5ef
    push ebp                                     # 004fd5f0
    push esi                                     # 004fd5f1
    call FUN_004fd650                            # 004fd5f2
    mov ecx, dword ptr [esp + stk_34]            # 004fd5f7
    push 0x0                                     # 004fd5fb
    push 0x2134                                  # 004fd5fd
    push ecx                                     # 004fd602
    push esi                                     # 004fd603
    call FUN_004fd2b0                            # 004fd604
    add esp, 0x1c                                # 004fd609
    test edx, edx                                # 004fd60c
    jg.d8 L_004fd636                             # 004fd60e
    # block 0x004fd610: entered by fall-through of jg at 0x004fd60e, 1 instruction(s), ends with jl to 0x004fd616 (forward)
    jl.d8 L_004fd616                             # 004fd610
    # block 0x004fd612: entered by fall-through of jl at 0x004fd610, 2 instruction(s), ends with jae to 0x004fd636 (forward)
    test eax, eax                                # 004fd612
    jae.d8 L_004fd636                            # 004fd614
L_004fd616:
    # block 0x004fd616: entered by jl at 0x004fd610; fall-through of jae at 0x004fd614, 8 instruction(s), ends with ret
    pop edi                                      # 004fd616
    pop esi                                      # 004fd617
    pop ebp                                      # 004fd618
    mov eax, 0xffffff7f                          # 004fd619
    or edx, -0x1                                 # 004fd61e
    pop ebx                                      # 004fd621
    add esp, 0x10                                # 004fd622
    ret                                          # 004fd625
L_004fd626:
    # block 0x004fd626: entered by je at 0x004fd5ba, 8 instruction(s), ends with ret
    pop edi                                      # 004fd626
    pop esi                                      # 004fd627
    pop ebp                                      # 004fd628
    mov eax, 0xffffff80                          # 004fd629
    or edx, -0x1                                 # 004fd62e
    pop ebx                                      # 004fd631
    add esp, 0x10                                # 004fd632
    ret                                          # 004fd635
L_004fd636:
    # block 0x004fd636: entered by jg at 0x004fd60e; jae at 0x004fd614, 8 instruction(s), ends with ret
    {load} mov edx, edi                          # 004fd636
    pop edi                                      # 004fd638
    {load} mov eax, ebp                          # 004fd639
    pop esi                                      # 004fd63b
    pop ebp                                      # 004fd63c
    pop ebx                                      # 004fd63d
    add esp, 0x10                                # 004fd63e
    ret                                          # 004fd641

# --- data items (not part of the function) -------------------------
.org 0x004fd642 - 0x401000
PAD_004fd642:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

