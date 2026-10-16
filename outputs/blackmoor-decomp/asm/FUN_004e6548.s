# FUN_004e6548
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e6548
# extent:       0x004e6548-0x004e6658 (272 code bytes)
# span:         0x004e6548-0x004e6658 (code 272, tables 0, padding 0)
# sha256:       08d1e0d17ff336c8d6a9300441f64b79367d224895239d767970e308ccf2830a
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e6548
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_5, local_6, local_7, local_8, local_c
# fields:       [ecx + n] field_1095; [edx + n] field_1099
# callees:      calls FUN_005193ca, FUN_004d2c20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_7, 0x7  # offset -0x7
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_1095, 0x1095  # offset +0x1095
.equ field_1099, 0x1099  # offset +0x1099

# --- external targets -----------------------------------------------
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x004e6548 - 0x401000
.globl FUN_004e6548
FUN_004e6548:
    # block 0x004e6548: entry, 24 instruction(s), ends with jge to 0x004e65a0 (forward)
    push ebp                                     # 004e6548
    {load} mov ebp, esp                          # 004e6549
    sub esp, 0xc                                 # 004e654b
    push esi                                     # 004e654e
    push edi                                     # 004e654f
    mov dword ptr [ebp - local_c], ecx           # 004e6550
    mov edi, 0x63a9f0                            # 004e6553
    lea edx, [ebp - local_8]                     # 004e6558
    or ecx, -0x1                                 # 004e655b
    {load} xor eax, eax                          # 004e655e
    repne scasb al, byte ptr es:[edi]            # 004e6560
    not ecx                                      # 004e6562
    {load} sub edi, ecx                          # 004e6564
    {load} mov esi, edi                          # 004e6566
    {load} mov eax, ecx                          # 004e6568
    {load} mov edi, edx                          # 004e656a
    shr ecx, 0x2                                 # 004e656c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e656f
    {load} mov ecx, eax                          # 004e6571
    and ecx, 0x3                                 # 004e6573
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e6576
    movsx ecx, word ptr [0x585d51]               # 004e6578
    cmp ecx, 0xa                                 # 004e657f
    jge.d8 L_004e65a0                            # 004e6582
    # block 0x004e6584: entered by fall-through of jge at 0x004e6582, 9 instruction(s), calls FUN_005193ca, ends with forward jump to 0x004e65b6
    mov byte ptr [ebp - local_8], 0x20           # 004e6584
    push 0xa                                     # 004e6588
    lea edx, [ebp - local_7]                     # 004e658a
    push edx                                     # 004e658d
    movsx eax, word ptr [0x585d51]               # 004e658e
    push eax                                     # 004e6595
    call FUN_005193ca                            # 004e6596
    add esp, 0xc                                 # 004e659b
    jmp.d8 L_004e65b6                            # 004e659e
L_004e65a0:
    # block 0x004e65a0: entered by jge at 0x004e6582, 7 instruction(s), calls FUN_005193ca, falls into the block at 0x004e65b6
    push 0xa                                     # 004e65a0
    lea ecx, [ebp - local_8]                     # 004e65a2
    push ecx                                     # 004e65a5
    movsx edx, word ptr [0x585d51]               # 004e65a6
    push edx                                     # 004e65ad
    call FUN_005193ca                            # 004e65ae
    add esp, 0xc                                 # 004e65b3
L_004e65b6:
    # block 0x004e65b6: entered by jmp at 0x004e659e, 4 instruction(s), ends with jge to 0x004e65e2 (forward)
    mov byte ptr [ebp - local_6], 0x3a           # 004e65b6
    movsx eax, word ptr [0x585d4f]               # 004e65ba
    cmp eax, 0xa                                 # 004e65c1
    jge.d8 L_004e65e2                            # 004e65c4
    # block 0x004e65c6: entered by fall-through of jge at 0x004e65c4, 9 instruction(s), calls FUN_005193ca, ends with forward jump to 0x004e65f8
    mov byte ptr [ebp - local_5], 0x30           # 004e65c6
    push 0xa                                     # 004e65ca
    lea ecx, [ebp - local_4]                     # 004e65cc
    push ecx                                     # 004e65cf
    movsx edx, word ptr [0x585d4f]               # 004e65d0
    push edx                                     # 004e65d7
    call FUN_005193ca                            # 004e65d8
    add esp, 0xc                                 # 004e65dd
    jmp.d8 L_004e65f8                            # 004e65e0
L_004e65e2:
    # block 0x004e65e2: entered by jge at 0x004e65c4, 7 instruction(s), calls FUN_005193ca, falls into the block at 0x004e65f8
    push 0xa                                     # 004e65e2
    lea eax, [ebp - local_5]                     # 004e65e4
    push eax                                     # 004e65e7
    movsx ecx, word ptr [0x585d4f]               # 004e65e8
    push ecx                                     # 004e65ef
    call FUN_005193ca                            # 004e65f0
    add esp, 0xc                                 # 004e65f5
L_004e65f8:
    # block 0x004e65f8: entered by jmp at 0x004e65e0, 29 instruction(s), calls FUN_004d2c20, ends with ret 0x4
    push 0x0                                     # 004e65f8
    mov edx, dword ptr [0x5cf665]                # 004e65fa
    push edx                                     # 004e6600
    movsx eax, word ptr [ebp + arg_8]            # 004e6601
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004e6605
    push ecx                                     # 004e660c
    mov edx, dword ptr [ebp - local_c]           # 004e660d
    mov ax, word ptr [edx + field_1099]          # 004e6610
    push eax                                     # 004e6617
    mov ecx, dword ptr [ebp - local_c]           # 004e6618
    mov dx, word ptr [ecx + field_1095]          # 004e661b
    push edx                                     # 004e6622
    movsx eax, word ptr [ebp + arg_8]            # 004e6623
    imul eax, eax, 0x1d0                         # 004e6627
    add eax, 0x5adb3a                            # 004e662d
    push eax                                     # 004e6632
    movsx ecx, word ptr [ebp + arg_8]            # 004e6633
    imul ecx, ecx, 0x7f3                         # 004e6637
    add ecx, 0x5a4c24                            # 004e663d
    push ecx                                     # 004e6643
    lea edx, [ebp - local_8]                     # 004e6644
    push edx                                     # 004e6647
    call FUN_004d2c20                            # 004e6648
    add esp, 0x20                                # 004e664d
    pop edi                                      # 004e6650
    pop esi                                      # 004e6651
    {load} mov esp, ebp                          # 004e6652
    pop ebp                                      # 004e6654
    ret 0x4                                      # 004e6655

