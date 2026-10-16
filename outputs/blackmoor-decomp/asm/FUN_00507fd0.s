# FUN_00507fd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507fd0
# extent:       0x00507fd0-0x0050817c (428 code bytes)
# span:         0x00507fd0-0x00508180 (code 428, tables 0, padding 4)
# sha256:       76fe6a71892da4bc478f15f0594169cf8f86f3bde01f1db150359a4977684fd2
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507fd0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_c, field_10, field_minus_4; [ebp + n] field_minus_4; [ebx + n] field_4, field_8, field_c; [ecx + n] field_8, field_28; [edi + n] field_minus_4; [edx + n] field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_2c, stk_30
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 152 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x00507fd0 - 0x401000
.globl FUN_00507fd0
FUN_00507fd0:
    # block 0x00507fd0: entry, 15 instruction(s), ends with jle to 0x005080ae (forward)
    sub esp, 0x18                                # 00507fd0
    mov eax, dword ptr [esp + stk_1c]            # 00507fd3
    push ebx                                     # 00507fd7
    push ebp                                     # 00507fd8
    push esi                                     # 00507fd9
    mov edx, dword ptr [eax]                     # 00507fda
    mov ecx, dword ptr [eax + field_c]           # 00507fdc
    {load} xor esi, esi                          # 00507fdf
    push edi                                     # 00507fe1
    mov ebx, dword ptr [ecx + field_28]          # 00507fe2
    mov dword ptr [esp + stk_18], edx            # 00507fe5
    test edx, edx                                # 00507fe9
    mov dword ptr [esp + stk_10], esi            # 00507feb
    mov dword ptr [esp + stk_24], ecx            # 00507fef
    jle.d32 L_005080ae                           # 00507ff3
    # block 0x00507ff9: entered by fall-through of jle at 0x00507ff3, 8 instruction(s), ends with forward jump to 0x00508015
    mov ecx, dword ptr [ebx + field_c]           # 00507ff9
    mov eax, dword ptr [esp + stk_30]            # 00507ffc
    mov edi, dword ptr [ebx]                     # 00508000
    mov dword ptr [esp + stk_1c], edx            # 00508002
    sar ecx                                      # 00508006
    mov dword ptr [esp + stk_20], ecx            # 00508008
    lea ebp, [eax + 4*edx]                       # 0050800c
    jmp.d8 L_00508015                            # 0050800f
L_00508011:
    # block 0x00508011: entered by jne at 0x0050809e, 1 instruction(s), falls into the block at 0x00508015
    mov ecx, dword ptr [esp + stk_20]            # 00508011
L_00508015:
    # block 0x00508015: entered by jmp at 0x0050800f, 8 instruction(s), ends with je to 0x0050805c (forward)
    mov eax, dword ptr [ebp - field_minus_4]     # 00508015
    sub ebp, 0x4                                 # 00508018
    mov dword ptr [esp + stk_14], eax            # 0050801b
    fld dword ptr [esp + stk_14]                 # 0050801f
    fcomp dword ptr [edi + 4*ecx]                # 00508023
    fnstsw ax                                    # 00508026
    test ah, 0x1                                 # 00508028
    je.d8 L_0050805c                             # 0050802b
    # block 0x0050802d: entered by fall-through of je at 0x0050802b, 5 instruction(s), ends with je to 0x00508081 (forward)
    fld dword ptr [esp + stk_14]                 # 0050802d
    fcomp dword ptr [edi + 4*ecx - field_minus_4] # 00508031
    fnstsw ax                                    # 00508035
    test ah, 0x1                                 # 00508037
    je.d8 L_00508081                             # 0050803a
    # block 0x0050803c: entered by fall-through of je at 0x0050803a, 3 instruction(s), ends with jle to 0x00508081 (forward)
    dec ecx                                      # 0050803c
    test ecx, ecx                                # 0050803d
    jle.d8 L_00508081                            # 0050803f
    # block 0x00508041: entered by fall-through of jle at 0x0050803f, 1 instruction(s), falls into the block at 0x00508045
    lea edx, [edi + 4*ecx - field_minus_4]       # 00508041
L_00508045:
    # block 0x00508045: entered by jg at 0x00508058, 5 instruction(s), ends with je to 0x0050807d (forward)
    fld dword ptr [esp + stk_14]                 # 00508045
    fcomp dword ptr [edx]                        # 00508049
    fnstsw ax                                    # 0050804b
    test ah, 0x1                                 # 0050804d
    je.d8 L_0050807d                             # 00508050
    # block 0x00508052: entered by fall-through of je at 0x00508050, 4 instruction(s), ends with jg to 0x00508045 (backward)
    dec ecx                                      # 00508052
    sub edx, 0x4                                 # 00508053
    test ecx, ecx                                # 00508056
    jg.d8 L_00508045                             # 00508058
    # block 0x0050805a: entered by fall-through of jg at 0x00508058, 1 instruction(s), ends with forward jump to 0x0050807d
    jmp.d8 L_0050807d                            # 0050805a
L_0050805c:
    # block 0x0050805c: entered by je at 0x0050802b, 5 instruction(s), ends with jge to 0x00508081 (forward)
    mov esi, dword ptr [ebx + field_c]           # 0050805c
    inc ecx                                      # 0050805f
    dec esi                                      # 00508060
    {load} cmp ecx, esi                          # 00508061
    jge.d8 L_00508081                            # 00508063
    # block 0x00508065: entered by fall-through of jge at 0x00508063, 1 instruction(s), falls into the block at 0x00508068
    lea edx, [edi + 4*ecx]                       # 00508065
L_00508068:
    # block 0x00508068: entered by jl at 0x0050807b, 5 instruction(s), ends with jne to 0x0050807d (forward)
    fld dword ptr [esp + stk_14]                 # 00508068
    fcomp dword ptr [edx]                        # 0050806c
    fnstsw ax                                    # 0050806e
    test ah, 0x1                                 # 00508070
    jne.d8 L_0050807d                            # 00508073
    # block 0x00508075: entered by fall-through of jne at 0x00508073, 4 instruction(s), ends with jl to 0x00508068 (backward)
    inc ecx                                      # 00508075
    add edx, 0x4                                 # 00508076
    {load} cmp ecx, esi                          # 00508079
    jl.d8 L_00508068                             # 0050807b
L_0050807d:
    # block 0x0050807d: entered by je at 0x00508050; jmp at 0x0050805a; jne at 0x00508073; fall-through of jl at 0x0050807b, 1 instruction(s), falls into the block at 0x00508081
    mov edx, dword ptr [esp + stk_18]            # 0050807d
L_00508081:
    # block 0x00508081: entered by je at 0x0050803a; jle at 0x0050803f; jge at 0x00508063, 10 instruction(s), ends with jne to 0x00508011 (backward)
    mov esi, dword ptr [ebx + field_8]           # 00508081
    mov eax, dword ptr [ebx + field_4]           # 00508084
    imul esi, dword ptr [esp + stk_10]           # 00508087
    mov ecx, dword ptr [eax + 4*ecx]             # 0050808c
    mov eax, dword ptr [esp + stk_1c]            # 0050808f
    {load} add ecx, esi                          # 00508093
    dec eax                                      # 00508095
    mov dword ptr [esp + stk_10], ecx            # 00508096
    mov dword ptr [esp + stk_1c], eax            # 0050809a
    jne.d32 L_00508011                           # 0050809e
    # block 0x005080a4: entered by fall-through of jne at 0x0050809e, 3 instruction(s), falls into the block at 0x005080ae
    mov eax, dword ptr [esp + stk_2c]            # 005080a4
    {load} mov esi, ecx                          # 005080a8
    mov ecx, dword ptr [esp + stk_24]            # 005080aa
L_005080ae:
    # block 0x005080ae: entered by jle at 0x00507ff3, 3 instruction(s), ends with jg to 0x00508142 (forward)
    mov edi, dword ptr [ecx + field_8]           # 005080ae
    cmp dword ptr [edi + 4*esi], 0x0             # 005080b1
    jg.d32 L_00508142                            # 005080b5
    # block 0x005080bb: entered by fall-through of jg at 0x005080b5, 7 instruction(s), ends with jle to 0x00508176 (forward)
    mov ebx, dword ptr [eax + field_4]           # 005080bb
    mov esi, dword ptr [eax + field_10]          # 005080be
    {load} xor edi, edi                          # 005080c1
    mov dword ptr [esp + stk_1c], 0x0            # 005080c3
    test ebx, ebx                                # 005080cb
    mov dword ptr [esp + stk_10], 0xffffffff     # 005080cd
    jle.d32 L_00508176                           # 005080d5
    # block 0x005080db: entered by fall-through of jle at 0x005080d5, 1 instruction(s), falls into the block at 0x005080de
    mov ebp, dword ptr [ecx + field_8]           # 005080db
L_005080de:
    # block 0x005080de: entered by jl at 0x00508138, 2 instruction(s), ends with jle to 0x0050812f (forward)
    {disp8} cmp dword ptr [ebp], 0x0             # 005080de
    jle.d8 L_0050812f                            # 005080e2
    # block 0x005080e4: entered by fall-through of jle at 0x005080e2, 3 instruction(s), ends with jle to 0x00508111 (forward)
    fld dword ptr [0x52db78]                     # 005080e4
    test edx, edx                                # 005080ea
    jle.d8 L_00508111                            # 005080ec
    # block 0x005080ee: entered by fall-through of jle at 0x005080ec, 4 instruction(s), falls into the block at 0x005080fa
    mov eax, dword ptr [esp + stk_30]            # 005080ee
    mov edx, dword ptr [esp + stk_18]            # 005080f2
    {load} mov ecx, esi                          # 005080f6
    {load} sub ecx, eax                          # 005080f8
L_005080fa:
    # block 0x005080fa: entered by jne at 0x0050810b, 9 instruction(s), ends with jne to 0x005080fa (backward)
    fld dword ptr [ecx + eax]                    # 005080fa
    fsub dword ptr [eax]                         # 005080fd
    add eax, 0x4                                 # 005080ff
    dec edx                                      # 00508102
    fld st(0)                                    # 00508103
    fmul st, st(1)                               # 00508105
    faddp st(2), st                              # 00508107
    fstp st(0)                                   # 00508109
    jne.d8 L_005080fa                            # 0050810b
    # block 0x0050810d: entered by fall-through of jne at 0x0050810b, 1 instruction(s), falls into the block at 0x00508111
    mov edx, dword ptr [esp + stk_18]            # 0050810d
L_00508111:
    # block 0x00508111: entered by jle at 0x005080ec, 2 instruction(s), ends with je to 0x00508123 (forward)
    cmp dword ptr [esp + stk_10], -0x1           # 00508111
    je.d8 L_00508123                             # 00508116
    # block 0x00508118: entered by fall-through of je at 0x00508116, 4 instruction(s), ends with je to 0x0050812d (forward)
    fcom dword ptr [esp + stk_1c]                # 00508118
    fnstsw ax                                    # 0050811c
    test ah, 0x1                                 # 0050811e
    je.d8 L_0050812d                             # 00508121
L_00508123:
    # block 0x00508123: entered by je at 0x00508116; fall-through of je at 0x00508121, 3 instruction(s), ends with forward jump to 0x0050812f
    fstp dword ptr [esp + stk_1c]                # 00508123
    mov dword ptr [esp + stk_10], edi            # 00508127
    jmp.d8 L_0050812f                            # 0050812b
L_0050812d:
    # block 0x0050812d: entered by je at 0x00508121, 1 instruction(s), falls into the block at 0x0050812f
    fstp st(0)                                   # 0050812d
L_0050812f:
    # block 0x0050812f: entered by jle at 0x005080e2; jmp at 0x0050812b, 5 instruction(s), ends with jl to 0x005080de (backward)
    add esi, 0x4                                 # 0050812f
    inc edi                                      # 00508132
    add ebp, 0x4                                 # 00508133
    {load} cmp edi, ebx                          # 00508136
    jl.d8 L_005080de                             # 00508138
    # block 0x0050813a: entered by fall-through of jl at 0x00508138, 2 instruction(s), falls into the block at 0x00508142
    mov esi, dword ptr [esp + stk_10]            # 0050813a
    mov eax, dword ptr [esp + stk_2c]            # 0050813e
L_00508142:
    # block 0x00508142: entered by jg at 0x005080b5; jmp at 0x0050817a, 6 instruction(s), ends with jle to 0x0050816c (forward)
    {load} mov ecx, esi                          # 00508142
    mov eax, dword ptr [eax + field_10]          # 00508144
    imul ecx, edx                                # 00508147
    test edx, edx                                # 0050814a
    lea eax, [eax + 4*ecx]                       # 0050814c
    jle.d8 L_0050816c                            # 0050814f
    # block 0x00508151: entered by fall-through of jle at 0x0050814f, 1 instruction(s), falls into the block at 0x00508153
    {load} mov ecx, edx                          # 00508151
L_00508153:
    # block 0x00508153: entered by jne at 0x0050816a, 9 instruction(s), ends with jne to 0x00508153 (backward)
    mov edx, dword ptr [esp + stk_30]            # 00508153
    add eax, 0x4                                 # 00508157
    fld dword ptr [edx]                          # 0050815a
    fsub dword ptr [eax - field_minus_4]         # 0050815c
    add edx, 0x4                                 # 0050815f
    dec ecx                                      # 00508162
    mov dword ptr [esp + stk_30], edx            # 00508163
    fstp dword ptr [edx - field_minus_4]         # 00508167
    jne.d8 L_00508153                            # 0050816a
L_0050816c:
    # block 0x0050816c: entered by jle at 0x0050814f; fall-through of jne at 0x0050816a, 7 instruction(s), ends with ret
    {load} mov eax, esi                          # 0050816c
    pop edi                                      # 0050816e
    pop esi                                      # 0050816f
    pop ebp                                      # 00508170
    pop ebx                                      # 00508171
    add esp, 0x18                                # 00508172
    ret                                          # 00508175
L_00508176:
    # block 0x00508176: entered by jle at 0x005080d5, 2 instruction(s), ends with backward jump to 0x00508142
    mov esi, dword ptr [esp + stk_10]            # 00508176
    jmp.d8 L_00508142                            # 0050817a

# --- data items (not part of the function) -------------------------
.org 0x0050817c - 0x401000
PAD_0050817c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

