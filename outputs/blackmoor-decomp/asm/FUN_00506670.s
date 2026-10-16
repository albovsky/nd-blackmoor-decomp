# FUN_00506670
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506670
# extent:       0x00506670-0x005067b5 (325 code bytes)
# span:         0x00506670-0x005067c0 (code 325, tables 0, padding 11)
# sha256:       03c2a08b0109c2fc98ef5f210b2a219e7eaf8bec9dad2a0848af105bc8f32933
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506670
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_minus_40, field_minus_400; [ecx + n] field_4; [edi + n] field_4, field_444, field_484, field_888; [edx + n] field_4; [esp + n] stk_14, stk_18, stk_20, stk_24
# callees:      calls FUN_0050bc80, FUN_004ff2f0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 128 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005067c0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_40, 0x40  # offset -0x40
.equ field_minus_400, 0x400  # offset -0x400
.equ field_4, 0x4  # offset +0x4
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_444, 0x444  # offset +0x444
.equ field_484, 0x484  # offset +0x484
.equ field_888, 0x888  # offset +0x888

# --- external targets -----------------------------------------------
.set FUN_004ff2f0, .text + (0x004ff2f0 - 0x401000)
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x00506670 - 0x401000
.globl FUN_00506670
FUN_00506670:
    # block 0x00506670: entry, 8 instruction(s), ends with jle to 0x0050669c (forward)
    push ebx                                     # 00506670
    push ebp                                     # 00506671
    push esi                                     # 00506672
    push edi                                     # 00506673
    mov edi, dword ptr [esp + stk_18]            # 00506674
    push 0x1                                     # 00506678
    cmp dword ptr [edi], 0x1                     # 0050667a
    jle.d8 L_0050669c                            # 0050667d
    # block 0x0050667f: entered by fall-through of jle at 0x0050667d, 12 instruction(s), calls FUN_0050bc80, ends with forward jump to 0x005066ab
    mov esi, dword ptr [esp + stk_20]            # 0050667f
    push 0x1                                     # 00506683
    push esi                                     # 00506685
    call FUN_0050bc80                            # 00506686
    mov eax, dword ptr [edi]                     # 0050668b
    push 0x4                                     # 0050668d
    dec eax                                      # 0050668f
    push eax                                     # 00506690
    push esi                                     # 00506691
    call FUN_0050bc80                            # 00506692
    add esp, 0x18                                # 00506697
    jmp.d8 L_005066ab                            # 0050669a
L_0050669c:
    # block 0x0050669c: entered by jle at 0x0050667d, 5 instruction(s), calls FUN_0050bc80, falls into the block at 0x005066ab
    mov esi, dword ptr [esp + stk_20]            # 0050669c
    push 0x0                                     # 005066a0
    push esi                                     # 005066a2
    call FUN_0050bc80                            # 005066a3
    add esp, 0xc                                 # 005066a8
L_005066ab:
    # block 0x005066ab: entered by jmp at 0x0050669a, 4 instruction(s), ends with jle to 0x00506729 (forward)
    mov eax, dword ptr [edi + field_484]         # 005066ab
    push 0x1                                     # 005066b1
    test eax, eax                                # 005066b3
    jle.d8 L_00506729                            # 005066b5
    # block 0x005066b7: entered by fall-through of jle at 0x005066b5, 14 instruction(s), calls FUN_0050bc80, ends with jle to 0x00506734 (forward)
    push 0x1                                     # 005066b7
    push esi                                     # 005066b9
    call FUN_0050bc80                            # 005066ba
    mov ecx, dword ptr [edi + field_484]         # 005066bf
    push 0x8                                     # 005066c5
    dec ecx                                      # 005066c7
    push ecx                                     # 005066c8
    push esi                                     # 005066c9
    call FUN_0050bc80                            # 005066ca
    mov eax, dword ptr [edi + field_484]         # 005066cf
    add esp, 0x18                                # 005066d5
    {load} xor ebp, ebp                          # 005066d8
    test eax, eax                                # 005066da
    jle.d8 L_00506734                            # 005066dc
    # block 0x005066de: entered by fall-through of jle at 0x005066dc, 1 instruction(s), falls into the block at 0x005066e4
    lea ebx, [edi + field_888]                   # 005066de
L_005066e4:
    # block 0x005066e4: entered by jl at 0x00506725, 24 instruction(s), calls FUN_004ff2f0, FUN_0050bc80, ends with jl to 0x005066e4 (backward)
    mov edx, dword ptr [esp + stk_14]            # 005066e4
    mov eax, dword ptr [edx + field_4]           # 005066e8
    push eax                                     # 005066eb
    call FUN_004ff2f0                            # 005066ec
    mov ecx, dword ptr [ebx - field_minus_400]   # 005066f1
    push eax                                     # 005066f7
    push ecx                                     # 005066f8
    push esi                                     # 005066f9
    call FUN_0050bc80                            # 005066fa
    mov edx, dword ptr [esp + stk_24]            # 005066ff
    mov eax, dword ptr [edx + field_4]           # 00506703
    push eax                                     # 00506706
    call FUN_004ff2f0                            # 00506707
    mov ecx, dword ptr [ebx]                     # 0050670c
    push eax                                     # 0050670e
    push ecx                                     # 0050670f
    push esi                                     # 00506710
    call FUN_0050bc80                            # 00506711
    mov eax, dword ptr [edi + field_484]         # 00506716
    add esp, 0x20                                # 0050671c
    inc ebp                                      # 0050671f
    add ebx, 0x4                                 # 00506720
    {load} cmp ebp, eax                          # 00506723
    jl.d8 L_005066e4                             # 00506725
    # block 0x00506727: entered by fall-through of jl at 0x00506725, 1 instruction(s), ends with forward jump to 0x00506734
    jmp.d8 L_00506734                            # 00506727
L_00506729:
    # block 0x00506729: entered by jle at 0x005066b5, 4 instruction(s), calls FUN_0050bc80, falls into the block at 0x00506734
    push 0x0                                     # 00506729
    push esi                                     # 0050672b
    call FUN_0050bc80                            # 0050672c
    add esp, 0xc                                 # 00506731
L_00506734:
    # block 0x00506734: entered by jle at 0x005066dc; jmp at 0x00506727, 8 instruction(s), calls FUN_0050bc80, ends with jle to 0x00506774 (forward)
    push 0x2                                     # 00506734
    push 0x0                                     # 00506736
    push esi                                     # 00506738
    call FUN_0050bc80                            # 00506739
    mov eax, dword ptr [edi]                     # 0050673e
    add esp, 0xc                                 # 00506740
    cmp eax, 0x1                                 # 00506743
    jle.d8 L_00506774                            # 00506746
    # block 0x00506748: entered by fall-through of jle at 0x00506746, 5 instruction(s), ends with jle to 0x00506774 (forward)
    mov edx, dword ptr [esp + stk_14]            # 00506748
    {load} xor ebx, ebx                          # 0050674c
    mov eax, dword ptr [edx + field_4]           # 0050674e
    test eax, eax                                # 00506751
    jle.d8 L_00506774                            # 00506753
    # block 0x00506755: entered by fall-through of jle at 0x00506753, 1 instruction(s), falls into the block at 0x00506758
    lea ebp, [edi + field_4]                     # 00506755
L_00506758:
    # block 0x00506758: entered by jl at 0x00506772, 11 instruction(s), calls FUN_0050bc80, ends with jl to 0x00506758 (backward)
    {disp8} mov eax, dword ptr [ebp]             # 00506758
    push 0x4                                     # 0050675b
    push eax                                     # 0050675d
    push esi                                     # 0050675e
    call FUN_0050bc80                            # 0050675f
    mov ecx, dword ptr [esp + stk_20]            # 00506764
    add esp, 0xc                                 # 00506768
    inc ebx                                      # 0050676b
    add ebp, 0x4                                 # 0050676c
    cmp ebx, dword ptr [ecx + field_4]           # 0050676f
    jl.d8 L_00506758                             # 00506772
L_00506774:
    # block 0x00506774: entered by jle at 0x00506746; jle at 0x00506753; fall-through of jl at 0x00506772, 4 instruction(s), ends with jle to 0x005067b0 (forward)
    mov eax, dword ptr [edi]                     # 00506774
    {load} xor ebp, ebp                          # 00506776
    test eax, eax                                # 00506778
    jle.d8 L_005067b0                            # 0050677a
    # block 0x0050677c: entered by fall-through of jle at 0x0050677a, 1 instruction(s), falls into the block at 0x00506782
    lea ebx, [edi + field_444]                   # 0050677c
L_00506782:
    # block 0x00506782: entered by jl at 0x005067ae, 20 instruction(s), calls FUN_0050bc80, ends with jl to 0x00506782 (backward)
    push 0x8                                     # 00506782
    push 0x0                                     # 00506784
    push esi                                     # 00506786
    call FUN_0050bc80                            # 00506787
    mov edx, dword ptr [ebx - field_minus_40]    # 0050678c
    push 0x8                                     # 0050678f
    push edx                                     # 00506791
    push esi                                     # 00506792
    call FUN_0050bc80                            # 00506793
    mov eax, dword ptr [ebx]                     # 00506798
    push 0x8                                     # 0050679a
    push eax                                     # 0050679c
    push esi                                     # 0050679d
    call FUN_0050bc80                            # 0050679e
    mov eax, dword ptr [edi]                     # 005067a3
    add esp, 0x24                                # 005067a5
    inc ebp                                      # 005067a8
    add ebx, 0x4                                 # 005067a9
    {load} cmp ebp, eax                          # 005067ac
    jl.d8 L_00506782                             # 005067ae
L_005067b0:
    # block 0x005067b0: entered by jle at 0x0050677a; fall-through of jl at 0x005067ae, 5 instruction(s), ends with ret
    pop edi                                      # 005067b0
    pop esi                                      # 005067b1
    pop ebp                                      # 005067b2
    pop ebx                                      # 005067b3
    ret                                          # 005067b4

# --- data items (not part of the function) -------------------------
.org 0x005067b5 - 0x401000
PAD_005067b5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

