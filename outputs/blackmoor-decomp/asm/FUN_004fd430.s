# FUN_004fd430
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd430
# extent:       0x004fd430-0x004fd529 (249 code bytes)
# span:         0x004fd430-0x004fd530 (code 249, tables 0, padding 7)
# sha256:       e4f5e589a2c53a1854cd733d3f768aeb351985f4900f60ac4fb03ecb15643091
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd430
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c, field_10, field_14, field_5c, field_2b2, field_2ba; [esp + n] stk_10, stk_14, stk_18, stk_20, stk_24, stk_28, stk_2c
# callees:      calls FUN_004fd530, FUN_0050b260, FUN_004fd690, FUN_004fd8b0, FUN_004fdc70; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 112 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ field_5c, 0x5c  # offset +0x5c
.equ field_2b2, 0x2b2  # offset +0x2b2
.equ field_2ba, 0x2ba  # offset +0x2ba

# --- external targets -----------------------------------------------
.set FUN_004fd530, .text + (0x004fd530 - 0x401000)
.set FUN_004fd690, .text + (0x004fd690 - 0x401000)
.set FUN_004fd8b0, .text + (0x004fd8b0 - 0x401000)
.set FUN_004fdc70, .text + (0x004fdc70 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)

.org 0x004fd430 - 0x401000
.globl FUN_004fd430
FUN_004fd430:
    # block 0x004fd430: entry, 35 instruction(s), calls indirect dword ptr [esi + 0x2b2], indirect dword ptr [esi + 0x2ba], FUN_004fd530, ends with jg to 0x004fd49a (forward)
    sub esp, 0x18                                # 004fd430
    push ebx                                     # 004fd433
    push ebp                                     # 004fd434
    push esi                                     # 004fd435
    mov esi, dword ptr [esp + stk_28]            # 004fd436
    push edi                                     # 004fd43a
    push 0x2                                     # 004fd43b
    mov edx, dword ptr [esi]                     # 004fd43d
    mov eax, dword ptr [esi + field_8]           # 004fd43f
    mov ecx, dword ptr [esi + field_c]           # 004fd442
    mov ebp, dword ptr [esi + field_5c]          # 004fd445
    push 0x0                                     # 004fd448
    push 0x0                                     # 004fd44a
    push edx                                     # 004fd44c
    mov dword ptr [esp + stk_20], eax            # 004fd44d
    mov dword ptr [esp + stk_24], ecx            # 004fd451
    call dword ptr [esi + field_2b2]             # 004fd455
    mov eax, dword ptr [esi]                     # 004fd45b
    push eax                                     # 004fd45d
    call dword ptr [esi + field_2ba]             # 004fd45e
    cdq                                          # 004fd464
    mov dword ptr [esi + field_10], eax          # 004fd465
    mov dword ptr [esi + field_14], edx          # 004fd468
    mov ecx, dword ptr [esi + field_10]          # 004fd46b
    lea eax, [esp + stk_2c]                      # 004fd46e
    push eax                                     # 004fd472
    mov dword ptr [esi + field_8], ecx           # 004fd473
    push esi                                     # 004fd476
    mov dword ptr [esi + field_c], edx           # 004fd477
    call FUN_004fd530                            # 004fd47a
    {load} mov edi, edx                          # 004fd47f
    add esp, 0x1c                                # 004fd481
    test edi, edi                                # 004fd484
    {load} mov ebx, eax                          # 004fd486
    jg.d8 L_004fd49a                             # 004fd488
    # block 0x004fd48a: entered by fall-through of jg at 0x004fd488, 1 instruction(s), ends with jl to 0x004fd490 (forward)
    jl.d8 L_004fd490                             # 004fd48a
    # block 0x004fd48c: entered by fall-through of jl at 0x004fd48a, 2 instruction(s), ends with jae to 0x004fd49a (forward)
    test ebx, ebx                                # 004fd48c
    jae.d8 L_004fd49a                            # 004fd48e
L_004fd490:
    # block 0x004fd490: entered by jl at 0x004fd48a; fall-through of jae at 0x004fd48e, 7 instruction(s), ends with ret
    pop edi                                      # 004fd490
    pop esi                                      # 004fd491
    {load} mov eax, ebx                          # 004fd492
    pop ebp                                      # 004fd494
    pop ebx                                      # 004fd495
    add esp, 0x18                                # 004fd496
    ret                                          # 004fd499
L_004fd49a:
    # block 0x004fd49a: entered by jg at 0x004fd488; jae at 0x004fd48e, 8 instruction(s), calls FUN_0050b260, ends with je to 0x004fd4d8 (forward)
    lea ecx, [esp + stk_18]                      # 004fd49a
    push ecx                                     # 004fd49e
    call FUN_0050b260                            # 004fd49f
    add esp, 0x4                                 # 004fd4a4
    {load} cmp eax, ebp                          # 004fd4a7
    push 0x0                                     # 004fd4a9
    push ebp                                     # 004fd4ab
    je.d8 L_004fd4d8                             # 004fd4ac
    # block 0x004fd4ae: entered by fall-through of je at 0x004fd4ac, 13 instruction(s), calls FUN_004fd690, ends with jge to 0x004fd504 (forward)
    add ebx, 0x1                                 # 004fd4ae
    adc edi, 0x0                                 # 004fd4b1
    push edi                                     # 004fd4b4
    push ebx                                     # 004fd4b5
    push 0x0                                     # 004fd4b6
    push 0x0                                     # 004fd4b8
    push 0x0                                     # 004fd4ba
    push 0x0                                     # 004fd4bc
    push esi                                     # 004fd4be
    call FUN_004fd690                            # 004fd4bf
    add esp, 0x24                                # 004fd4c4
    test eax, eax                                # 004fd4c7
    jge.d8 L_004fd504                            # 004fd4c9
    # block 0x004fd4cb: entered by fall-through of jge at 0x004fd4c9, 7 instruction(s), ends with ret
    pop edi                                      # 004fd4cb
    pop esi                                      # 004fd4cc
    pop ebp                                      # 004fd4cd
    mov eax, 0xffffff80                          # 004fd4ce
    pop ebx                                      # 004fd4d3
    add esp, 0x18                                # 004fd4d4
    ret                                          # 004fd4d7
L_004fd4d8:
    # block 0x004fd4d8: entered by je at 0x004fd4ac, 15 instruction(s), calls FUN_004fd690, ends with je to 0x004fd504 (forward)
    {load} mov edx, ebx                          # 004fd4d8
    {load} mov eax, edi                          # 004fd4da
    add edx, 0x1                                 # 004fd4dc
    adc eax, 0x0                                 # 004fd4df
    push eax                                     # 004fd4e2
    push edx                                     # 004fd4e3
    push edi                                     # 004fd4e4
    push ebx                                     # 004fd4e5
    push 0x0                                     # 004fd4e6
    push 0x0                                     # 004fd4e8
    push esi                                     # 004fd4ea
    call FUN_004fd690                            # 004fd4eb
    add esp, 0x24                                # 004fd4f0
    test eax, eax                                # 004fd4f3
    je.d8 L_004fd504                             # 004fd4f5
    # block 0x004fd4f7: entered by fall-through of je at 0x004fd4f5, 7 instruction(s), ends with ret
    pop edi                                      # 004fd4f7
    pop esi                                      # 004fd4f8
    pop ebp                                      # 004fd4f9
    mov eax, 0xffffff80                          # 004fd4fa
    pop ebx                                      # 004fd4ff
    add esp, 0x18                                # 004fd500
    ret                                          # 004fd503
L_004fd504:
    # block 0x004fd504: entered by jge at 0x004fd4c9; je at 0x004fd4f5, 17 instruction(s), calls FUN_004fd8b0, FUN_004fdc70, ends with ret
    mov ecx, dword ptr [esp + stk_14]            # 004fd504
    mov edx, dword ptr [esp + stk_10]            # 004fd508
    push ecx                                     # 004fd50c
    push edx                                     # 004fd50d
    push esi                                     # 004fd50e
    call FUN_004fd8b0                            # 004fd50f
    push 0x0                                     # 004fd514
    push 0x0                                     # 004fd516
    push esi                                     # 004fd518
    call FUN_004fdc70                            # 004fd519
    add esp, 0x18                                # 004fd51e
    pop edi                                      # 004fd521
    pop esi                                      # 004fd522
    pop ebp                                      # 004fd523
    pop ebx                                      # 004fd524
    add esp, 0x18                                # 004fd525
    ret                                          # 004fd528

# --- data items (not part of the function) -------------------------
.org 0x004fd529 - 0x401000
PAD_004fd529:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

