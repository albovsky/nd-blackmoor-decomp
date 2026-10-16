# FUN_0050ab90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ab90
# extent:       0x0050ab90-0x0050accc (316 code bytes)
# span:         0x0050ab90-0x0050acd0 (code 316, tables 0, padding 4)
# sha256:       64cc91db737c94b0c13934715d9dc4201a35fad7d580b2994b81561861e91667
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050a9c0 (+0x1d0)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ab90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_b20, field_minus_4; [ebp + n] field_4, field_14, field_minus_4; [ecx + n] field_4, field_1c; [edi + n] field_4, field_40; [edx + n] field_4; [esi + n] field_c, field_10, field_14, field_18; [esp + n] stk_c, stk_14, stk_18, stk_1c, stk_24; [scaled index + n] field_4
# callees:      calls FUN_0050be60, FUN_005023e0, FUN_004fee30, FUN_00503760
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 117 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_24, 0x24  # offset +0x24
.equ field_40, 0x40  # offset +0x40
.equ field_b20, 0xb20  # offset +0xb20

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_005023e0, .text + (0x005023e0 - 0x401000)
.set FUN_00503760, .text + (0x00503760 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x0050ab90 - 0x401000
.globl FUN_0050ab90
FUN_0050ab90:
    # block 0x0050ab90: entry, 17 instruction(s), calls FUN_0050be60, ends with jle to 0x0050acc4 (forward)
    push ecx                                     # 0050ab90
    push ebx                                     # 0050ab91
    push ebp                                     # 0050ab92
    mov ebp, dword ptr [esp + stk_14]            # 0050ab93
    push esi                                     # 0050ab97
    push edi                                     # 0050ab98
    mov edi, dword ptr [esp + stk_18]            # 0050ab99
    mov esi, dword ptr [ebp + field_14]          # 0050ab9d
    lea ebx, [edi + field_4]                     # 0050aba0
    mov eax, dword ptr [esi + field_c]           # 0050aba3
    push eax                                     # 0050aba6
    push ebx                                     # 0050aba7
    call FUN_0050be60                            # 0050aba8
    add esp, 0x8                                 # 0050abad
    mov dword ptr [esp + stk_18], eax            # 0050abb0
    test eax, eax                                # 0050abb4
    jle.d32 L_0050acc4                           # 0050abb6
    # block 0x0050abbc: entered by fall-through of jle at 0x0050abb6, 18 instruction(s), calls FUN_005023e0, FUN_0050be60, ends with je to 0x0050acc4 (forward)
    mov ecx, dword ptr [esi + field_c]           # 0050abbc
    mov edx, 0x1                                 # 0050abbf
    fild dword ptr [esp + stk_18]                # 0050abc4
    shl edx, cl                                  # 0050abc8
    mov eax, dword ptr [esi + field_14]          # 0050abca
    push eax                                     # 0050abcd
    dec edx                                      # 0050abce
    mov dword ptr [esp + stk_1c], edx            # 0050abcf
    fidiv dword ptr [esp + stk_1c]               # 0050abd3
    fimul dword ptr [esi + field_10]             # 0050abd7
    fstp dword ptr [esp + stk_14]                # 0050abda
    call FUN_005023e0                            # 0050abde
    push eax                                     # 0050abe3
    push ebx                                     # 0050abe4
    call FUN_0050be60                            # 0050abe5
    add esp, 0xc                                 # 0050abea
    cmp eax, -0x1                                # 0050abed
    je.d32 L_0050acc4                            # 0050abf0
    # block 0x0050abf6: entered by fall-through of je at 0x0050abf0, 2 instruction(s), ends with jge to 0x0050acc4 (forward)
    cmp eax, dword ptr [esi + field_14]          # 0050abf6
    jge.d32 L_0050acc4                           # 0050abf9
    # block 0x0050abff: entered by fall-through of jge at 0x0050abf9, 23 instruction(s), calls FUN_004fee30, ends with jle to 0x0050ac6f (forward)
    mov eax, dword ptr [esi + 4*eax + field_18]  # 0050abff
    mov dword ptr [esp + stk_18], 0x0            # 0050ac03
    lea ecx, [eax + 4*eax]                       # 0050ac0b
    lea edx, [eax + 2*ecx]                       # 0050ac0e
    mov eax, dword ptr [edi + field_40]          # 0050ac11
    mov ecx, dword ptr [eax + field_4]           # 0050ac14
    mov eax, dword ptr [ecx + field_1c]          # 0050ac17
    mov ecx, dword ptr [eax + field_b20]         # 0050ac1a
    mov eax, dword ptr [ecx + 4*edx]             # 0050ac20
    lea esi, [ecx + 4*edx]                       # 0050ac23
    mov edx, dword ptr [ebp + field_4]           # 0050ac26
    {load} add edx, eax                          # 0050ac29
    lea eax, [4*edx + field_4]                   # 0050ac2b
    push eax                                     # 0050ac32
    push edi                                     # 0050ac33
    call FUN_004fee30                            # 0050ac34
    mov ecx, dword ptr [esp + stk_24]            # 0050ac39
    {load} mov ebp, eax                          # 0050ac3d
    add esp, 0x8                                 # 0050ac3f
    {load} xor edi, edi                          # 0050ac42
    mov eax, dword ptr [ecx + field_4]           # 0050ac44
    test eax, eax                                # 0050ac47
    jle.d8 L_0050ac6f                            # 0050ac49
L_0050ac4b:
    # block 0x0050ac4b: entered by jl at 0x0050ac6d; fall-through of jle at 0x0050ac49, 10 instruction(s), calls FUN_00503760, ends with je to 0x0050acc4 (forward)
    mov edx, dword ptr [esi]                     # 0050ac4b
    {disp8} lea eax, [ebp + 4*edi]               # 0050ac4d
    push edx                                     # 0050ac51
    push ebx                                     # 0050ac52
    push eax                                     # 0050ac53
    push esi                                     # 0050ac54
    call FUN_00503760                            # 0050ac55
    add esp, 0x10                                # 0050ac5a
    cmp eax, -0x1                                # 0050ac5d
    je.d8 L_0050acc4                             # 0050ac60
    # block 0x0050ac62: entered by fall-through of je at 0x0050ac60, 5 instruction(s), ends with jl to 0x0050ac4b (backward)
    mov ecx, dword ptr [esi]                     # 0050ac62
    {load} add edi, ecx                          # 0050ac64
    mov ecx, dword ptr [esp + stk_1c]            # 0050ac66
    cmp edi, dword ptr [ecx + field_4]           # 0050ac6a
    jl.d8 L_0050ac4b                             # 0050ac6d
L_0050ac6f:
    # block 0x0050ac6f: entered by jle at 0x0050ac49; fall-through of jl at 0x0050ac6d, 5 instruction(s), ends with jle to 0x0050acad (forward)
    mov eax, dword ptr [esp + stk_1c]            # 0050ac6f
    {load} xor edx, edx                          # 0050ac73
    mov ecx, dword ptr [eax + field_4]           # 0050ac75
    test ecx, ecx                                # 0050ac78
    jle.d8 L_0050acad                            # 0050ac7a
L_0050ac7c:
    # block 0x0050ac7c: entered by jl at 0x0050acab; fall-through of jle at 0x0050ac7a, 4 instruction(s), ends with jle to 0x0050ac9a (forward)
    mov eax, dword ptr [esi]                     # 0050ac7c
    {load} xor ecx, ecx                          # 0050ac7e
    test eax, eax                                # 0050ac80
    jle.d8 L_0050ac9a                            # 0050ac82
    # block 0x0050ac84: entered by fall-through of jle at 0x0050ac82, 1 instruction(s), falls into the block at 0x0050ac88
    {disp8} lea eax, [ebp + 4*edx]               # 0050ac84
L_0050ac88:
    # block 0x0050ac88: entered by jl at 0x0050ac98, 8 instruction(s), ends with jl to 0x0050ac88 (backward)
    fld dword ptr [esp + stk_18]                 # 0050ac88
    fadd dword ptr [eax]                         # 0050ac8c
    inc ecx                                      # 0050ac8e
    inc edx                                      # 0050ac8f
    add eax, 0x4                                 # 0050ac90
    fstp dword ptr [eax - field_minus_4]         # 0050ac93
    cmp ecx, dword ptr [esi]                     # 0050ac96
    jl.d8 L_0050ac88                             # 0050ac98
L_0050ac9a:
    # block 0x0050ac9a: entered by jle at 0x0050ac82; fall-through of jl at 0x0050ac98, 6 instruction(s), ends with jl to 0x0050ac7c (backward)
    mov ecx, dword ptr [esp + stk_1c]            # 0050ac9a
    fld dword ptr [ebp + 4*edx - field_minus_4]  # 0050ac9e
    mov eax, dword ptr [ecx + field_4]           # 0050aca2
    fstp dword ptr [esp + stk_18]                # 0050aca5
    {load} cmp edx, eax                          # 0050aca9
    jl.d8 L_0050ac7c                             # 0050acab
L_0050acad:
    # block 0x0050acad: entered by jle at 0x0050ac7a; fall-through of jl at 0x0050acab, 11 instruction(s), ends with ret
    mov edx, dword ptr [esp + stk_1c]            # 0050acad
    pop edi                                      # 0050acb1
    fld dword ptr [esp + stk_c]                  # 0050acb2
    mov eax, dword ptr [edx + field_4]           # 0050acb6
    pop esi                                      # 0050acb9
    {disp8} fstp dword ptr [ebp + 4*eax]         # 0050acba
    {load} mov eax, ebp                          # 0050acbe
    pop ebp                                      # 0050acc0
    pop ebx                                      # 0050acc1
    pop ecx                                      # 0050acc2
    ret                                          # 0050acc3
L_0050acc4:
    # block 0x0050acc4: entered by jle at 0x0050abb6; je at 0x0050abf0; jge at 0x0050abf9; je at 0x0050ac60, 7 instruction(s), ends with ret
    pop edi                                      # 0050acc4
    pop esi                                      # 0050acc5
    pop ebp                                      # 0050acc6
    {load} xor eax, eax                          # 0050acc7
    pop ebx                                      # 0050acc9
    pop ecx                                      # 0050acca
    ret                                          # 0050accb

# --- data items (not part of the function) -------------------------
.org 0x0050accc - 0x401000
PAD_0050accc:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

