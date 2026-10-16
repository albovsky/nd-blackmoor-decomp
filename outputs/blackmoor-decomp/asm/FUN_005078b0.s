# FUN_005078b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005078b0
# extent:       0x005078b0-0x005079e7 (311 code bytes)
# span:         0x005078b0-0x005079f0 (code 311, tables 0, padding 9)
# sha256:       0b774d3048898be07faeca5a63c31d2c4b9ce733b12e3fd6631b27af17f68f0f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507890 (+0x20)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005078b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ecx + n] field_18; [esi + n] field_4, field_8, field_c, field_10, field_14, field_114; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28
# callees:      calls FUN_0050e97e, FUN_0050be60, FUN_00507890, FUN_00507700
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 121 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005079f0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_114, 0x114  # offset +0x114

# --- external targets -----------------------------------------------
.set FUN_00507700, .text + (0x00507700 - 0x401000)
.set FUN_00507890, .text + (0x00507890 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x005078b0 - 0x401000
.globl FUN_005078b0
FUN_005078b0:
    # block 0x005078b0: entry, 42 instruction(s), calls FUN_0050e97e, FUN_0050be60, ends with jle to 0x0050797a (forward)
    sub esp, 0x8                                 # 005078b0
    push ebx                                     # 005078b3
    push ebp                                     # 005078b4
    push esi                                     # 005078b5
    push edi                                     # 005078b6
    {load} xor ebx, ebx                          # 005078b7
    push 0x714                                   # 005078b9
    push 0x1                                     # 005078be
    mov dword ptr [esp + stk_18], ebx            # 005078c0
    call FUN_0050e97e                            # 005078c4
    mov edi, dword ptr [esp + stk_28]            # 005078c9
    {load} mov esi, eax                          # 005078cd
    mov eax, dword ptr [esp + stk_24]            # 005078cf
    push 0x18                                    # 005078d3
    push edi                                     # 005078d5
    mov ecx, dword ptr [eax + field_1c]          # 005078d6
    mov dword ptr [esp + stk_24], ecx            # 005078d9
    call FUN_0050be60                            # 005078dd
    push 0x18                                    # 005078e2
    push edi                                     # 005078e4
    mov dword ptr [esi], eax                     # 005078e5
    call FUN_0050be60                            # 005078e7
    push 0x18                                    # 005078ec
    push edi                                     # 005078ee
    mov dword ptr [esi + field_4], eax           # 005078ef
    call FUN_0050be60                            # 005078f2
    inc eax                                      # 005078f7
    push 0x6                                     # 005078f8
    push edi                                     # 005078fa
    mov dword ptr [esi + field_8], eax           # 005078fb
    call FUN_0050be60                            # 005078fe
    inc eax                                      # 00507903
    push 0x8                                     # 00507904
    push edi                                     # 00507906
    mov dword ptr [esi + field_c], eax           # 00507907
    call FUN_0050be60                            # 0050790a
    mov dword ptr [esi + field_10], eax          # 0050790f
    mov eax, dword ptr [esi + field_c]           # 00507912
    add esp, 0x30                                # 00507915
    {load} xor ebp, ebp                          # 00507918
    test eax, eax                                # 0050791a
    jle.d8 L_0050797a                            # 0050791c
    # block 0x0050791e: entered by fall-through of jle at 0x0050791c, 2 instruction(s), falls into the block at 0x00507925
    lea edx, [esi + field_14]                    # 0050791e
    mov dword ptr [esp + stk_1c], edx            # 00507921
L_00507925:
    # block 0x00507925: entered by jl at 0x00507978, 10 instruction(s), calls FUN_0050be60, ends with je to 0x0050794e (forward)
    push 0x3                                     # 00507925
    push edi                                     # 00507927
    call FUN_0050be60                            # 00507928
    push 0x1                                     # 0050792d
    push edi                                     # 0050792f
    {load} mov ebx, eax                          # 00507930
    call FUN_0050be60                            # 00507932
    add esp, 0x10                                # 00507937
    test eax, eax                                # 0050793a
    je.d8 L_0050794e                             # 0050793c
    # block 0x0050793e: entered by fall-through of je at 0x0050793c, 6 instruction(s), calls FUN_0050be60, falls into the block at 0x0050794e
    push 0x5                                     # 0050793e
    push edi                                     # 00507940
    call FUN_0050be60                            # 00507941
    shl eax, 0x3                                 # 00507946
    add esp, 0x8                                 # 00507949
    {load} or ebx, eax                           # 0050794c
L_0050794e:
    # block 0x0050794e: entered by je at 0x0050793c, 15 instruction(s), calls FUN_00507890, ends with jl to 0x00507925 (backward)
    mov eax, dword ptr [esp + stk_1c]            # 0050794e
    push ebx                                     # 00507952
    mov dword ptr [eax], ebx                     # 00507953
    call FUN_00507890                            # 00507955
    mov ebx, dword ptr [esp + stk_14]            # 0050795a
    mov ecx, dword ptr [esp + stk_20]            # 0050795e
    add esp, 0x4                                 # 00507962
    {load} add ebx, eax                          # 00507965
    mov eax, dword ptr [esi + field_c]           # 00507967
    inc ebp                                      # 0050796a
    add ecx, 0x4                                 # 0050796b
    {load} cmp ebp, eax                          # 0050796e
    mov dword ptr [esp + stk_10], ebx            # 00507970
    mov dword ptr [esp + stk_1c], ecx            # 00507974
    jl.d8 L_00507925                             # 00507978
L_0050797a:
    # block 0x0050797a: entered by jle at 0x0050791c; fall-through of jl at 0x00507978, 2 instruction(s), ends with jle to 0x005079a4 (forward)
    test ebx, ebx                                # 0050797a
    jle.d8 L_005079a4                            # 0050797c
    # block 0x0050797e: entered by fall-through of jle at 0x0050797c, 2 instruction(s), falls into the block at 0x00507988
    lea ebp, [esi + field_114]                   # 0050797e
    mov dword ptr [esp + stk_1c], ebx            # 00507984
L_00507988:
    # block 0x00507988: entered by jne at 0x005079a2, 10 instruction(s), calls FUN_0050be60, ends with jne to 0x00507988 (backward)
    push 0x8                                     # 00507988
    push edi                                     # 0050798a
    call FUN_0050be60                            # 0050798b
    {disp8} mov dword ptr [ebp], eax             # 00507990
    mov eax, dword ptr [esp + stk_24]            # 00507993
    add esp, 0x8                                 # 00507997
    add ebp, 0x4                                 # 0050799a
    dec eax                                      # 0050799d
    mov dword ptr [esp + stk_1c], eax            # 0050799e
    jne.d8 L_00507988                            # 005079a2
L_005079a4:
    # block 0x005079a4: entered by jle at 0x0050797c; fall-through of jne at 0x005079a2, 5 instruction(s), ends with jge to 0x005079d4 (forward)
    mov ecx, dword ptr [esp + stk_14]            # 005079a4
    mov eax, dword ptr [esi + field_10]          # 005079a8
    mov edx, dword ptr [ecx + field_18]          # 005079ab
    {load} cmp eax, edx                          # 005079ae
    jge.d8 L_005079d4                            # 005079b0
    # block 0x005079b2: entered by fall-through of jge at 0x005079b0, 3 instruction(s), ends with jle to 0x005079ca (forward)
    {load} xor eax, eax                          # 005079b2
    test ebx, ebx                                # 005079b4
    jle.d8 L_005079ca                            # 005079b6
    # block 0x005079b8: entered by fall-through of jle at 0x005079b6, 1 instruction(s), falls into the block at 0x005079be
    lea ecx, [esi + field_114]                   # 005079b8
L_005079be:
    # block 0x005079be: entered by jl at 0x005079c8, 2 instruction(s), ends with jge to 0x005079d4 (forward)
    cmp dword ptr [ecx], edx                     # 005079be
    jge.d8 L_005079d4                            # 005079c0
    # block 0x005079c2: entered by fall-through of jge at 0x005079c0, 4 instruction(s), ends with jl to 0x005079be (backward)
    inc eax                                      # 005079c2
    add ecx, 0x4                                 # 005079c3
    {load} cmp eax, ebx                          # 005079c6
    jl.d8 L_005079be                             # 005079c8
L_005079ca:
    # block 0x005079ca: entered by jle at 0x005079b6; fall-through of jl at 0x005079c8, 7 instruction(s), ends with ret
    {load} mov eax, esi                          # 005079ca
    pop edi                                      # 005079cc
    pop esi                                      # 005079cd
    pop ebp                                      # 005079ce
    pop ebx                                      # 005079cf
    add esp, 0x8                                 # 005079d0
    ret                                          # 005079d3
L_005079d4:
    # block 0x005079d4: entered by jge at 0x005079b0; jge at 0x005079c0, 10 instruction(s), calls FUN_00507700, ends with ret
    push esi                                     # 005079d4
    call FUN_00507700                            # 005079d5
    add esp, 0x4                                 # 005079da
    {load} xor eax, eax                          # 005079dd
    pop edi                                      # 005079df
    pop esi                                      # 005079e0
    pop ebp                                      # 005079e1
    pop ebx                                      # 005079e2
    add esp, 0x8                                 # 005079e3
    ret                                          # 005079e6

# --- data items (not part of the function) -------------------------
.org 0x005079e7 - 0x401000
PAD_005079e7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

