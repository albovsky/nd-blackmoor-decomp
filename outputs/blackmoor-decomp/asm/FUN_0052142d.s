# FUN_0052142d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052142d
# extent:       0x0052142d-0x005214c9 (156 code bytes)
# span:         0x0052142d-0x005214c9 (code 156, tables 0, padding 0)
# sha256:       25f6af7e24ec16691b2b4edd931f0bf6e8ffa63ad98067bc14fea9afd4ef3b18
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052142d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [esp + n] stk_c, stk_18
# callees:      calls FUN_005214c9, FUN_0050c193, USER32.dll!GetLastActivePopup, USER32.dll!IsWindowEnabled, USER32.dll!EnableWindow, USER32.dll!GetWindowLongA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_005214c9, .text + (0x005214c9 - 0x401000)

.org 0x0052142d - 0x401000
.globl FUN_0052142d
FUN_0052142d:
    # block 0x0052142d: entry, 9 instruction(s), ends with jne to 0x005214a6 (forward)
    push ebx                                     # 0052142d
    mov ebx, dword ptr [0x52a3dc]                # 0052142e
    push ebp                                     # 00521434
    mov ebp, dword ptr [esp + stk_c]             # 00521435
    push esi                                     # 00521439
    push edi                                     # 0052143a
    test ebp, ebp                                # 0052143b
    {load} mov esi, ebp                          # 0052143d
    jne.d8 L_005214a6                            # 0052143f
    # block 0x00521441: entered by fall-through of jne at 0x0052143f, 3 instruction(s), calls FUN_005214c9, ends with jne to 0x0052149f (forward)
    call FUN_005214c9                            # 00521441
    test eax, eax                                # 00521446
    jne.d8 L_0052149f                            # 00521448
    # block 0x0052144a: entered by fall-through of jne at 0x00521448, 3 instruction(s), calls FUN_0050c193, ends with jne to 0x0052149f (forward)
    call FUN_0050c193                            # 0052144a
    test eax, eax                                # 0052144f
    jne.d8 L_0052149f                            # 00521451
    # block 0x00521453: entered by fall-through of jne at 0x00521451, 1 instruction(s), falls into the block at 0x00521455
    {load} xor esi, esi                          # 00521453
L_00521455:
    # block 0x00521455: entered by je at 0x005214a4; je at 0x005214b4, 4 instruction(s), ends with je to 0x00521466 (forward)
    test esi, esi                                # 00521455
    {load} mov edi, esi                          # 00521457
    {load} mov eax, esi                          # 00521459
    je.d8 L_00521466                             # 0052145b
L_0052145d:
    # block 0x0052145d: entered by jne at 0x00521464; fall-through of je at 0x0052145b, 5 instruction(s), calls indirect ebx, ends with jne to 0x0052145d (backward)
    push eax                                     # 0052145d
    {load} mov edi, eax                          # 0052145e
    call ebx                                     # 00521460
    test eax, eax                                # 00521462
    jne.d8 L_0052145d                            # 00521464
L_00521466:
    # block 0x00521466: entered by je at 0x0052145b; fall-through of jne at 0x00521464, 2 instruction(s), ends with jne to 0x00521477 (forward)
    test ebp, ebp                                # 00521466
    jne.d8 L_00521477                            # 00521468
    # block 0x0052146a: entered by fall-through of jne at 0x00521468, 2 instruction(s), ends with je to 0x00521477 (forward)
    test esi, esi                                # 0052146a
    je.d8 L_00521477                             # 0052146c
    # block 0x0052146e: entered by fall-through of je at 0x0052146c, 3 instruction(s), calls USER32.dll!GetLastActivePopup, falls into the block at 0x00521477
    push esi                                     # 0052146e
    call dword ptr [0x52a444]                    # 0052146f
    {load} mov esi, eax                          # 00521475
L_00521477:
    # block 0x00521477: entered by jne at 0x00521468; je at 0x0052146c, 3 instruction(s), ends with je to 0x005214c0 (forward)
    mov ebx, dword ptr [esp + stk_18]            # 00521477
    test ebx, ebx                                # 0052147b
    je.d8 L_005214c0                             # 0052147d
    # block 0x0052147f: entered by fall-through of je at 0x0052147d, 2 instruction(s), ends with je to 0x005214bd (forward)
    test edi, edi                                # 0052147f
    je.d8 L_005214bd                             # 00521481
    # block 0x00521483: entered by fall-through of je at 0x00521481, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x005214bd (forward)
    push edi                                     # 00521483
    call dword ptr [0x52a330]                    # 00521484
    test eax, eax                                # 0052148a
    je.d8 L_005214bd                             # 0052148c
    # block 0x0052148e: entered by fall-through of je at 0x0052148c, 2 instruction(s), ends with je to 0x005214bd (forward)
    {load} cmp edi, esi                          # 0052148e
    je.d8 L_005214bd                             # 00521490
    # block 0x00521492: entered by fall-through of je at 0x00521490, 5 instruction(s), calls USER32.dll!EnableWindow, ends with forward jump to 0x005214c0
    push 0x0                                     # 00521492
    push edi                                     # 00521494
    mov dword ptr [ebx], edi                     # 00521495
    call dword ptr [0x52a4d0]                    # 00521497
    jmp.d8 L_005214c0                            # 0052149d
L_0052149f:
    # block 0x0052149f: entered by jne at 0x00521448; jne at 0x00521451, 1 instruction(s), falls into the block at 0x005214a2
    mov esi, dword ptr [eax + field_1c]          # 0052149f
L_005214a2:
    # block 0x005214a2: entered by jmp at 0x005214bb, 2 instruction(s), ends with je to 0x00521455 (backward)
    test esi, esi                                # 005214a2
    je.d8 L_00521455                             # 005214a4
L_005214a6:
    # block 0x005214a6: entered by jne at 0x0052143f; fall-through of je at 0x005214a4, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x00521455 (backward)
    push -0x10                                   # 005214a6
    push esi                                     # 005214a8
    call dword ptr [0x52a454]                    # 005214a9
    test eax, 0x40000000                         # 005214af
    je.d8 L_00521455                             # 005214b4
    # block 0x005214b6: entered by fall-through of je at 0x005214b4, 4 instruction(s), calls indirect ebx, ends with backward jump to 0x005214a2
    push esi                                     # 005214b6
    call ebx                                     # 005214b7
    {load} mov esi, eax                          # 005214b9
    jmp.d8 L_005214a2                            # 005214bb
L_005214bd:
    # block 0x005214bd: entered by je at 0x00521481; je at 0x0052148c; je at 0x00521490, 1 instruction(s), falls into the block at 0x005214c0
    and dword ptr [ebx], 0x0                     # 005214bd
L_005214c0:
    # block 0x005214c0: entered by je at 0x0052147d; jmp at 0x0052149d, 6 instruction(s), ends with ret 0x8
    {load} mov eax, esi                          # 005214c0
    pop edi                                      # 005214c2
    pop esi                                      # 005214c3
    pop ebp                                      # 005214c4
    pop ebx                                      # 005214c5
    ret 0x8                                      # 005214c6

