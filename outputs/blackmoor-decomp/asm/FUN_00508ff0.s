# FUN_00508ff0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508ff0
# extent:       0x00508ff0-0x005091f2 (514 code bytes)
# span:         0x00508ff0-0x00509210 (code 514, tables 16, padding 14)
# sha256:       2238e3226f3cc2b5451221202e19e780c4f43f5750765ea138f269b1c598cf38
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508bc0 (+0x430)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508ff0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_fc, field_104, field_minus_4; [ebp + n] field_104, field_208, field_30c, field_504, field_508, field_50c, field_510; [ecx + n] field_minus_4; [edi + n] field_4, field_80, field_340, field_344, field_348; [edx + n] field_minus_2; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_34, stk_138, stk_140
# callees:      calls FUN_0050e97e, FUN_0050f085
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 155 instruction(s), 19 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00509210
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ field_80, 0x80  # offset +0x80
.equ field_fc, 0xfc  # offset +0xfc
.equ field_104, 0x104  # offset +0x104
.equ stk_138, 0x138  # offset +0x138
.equ stk_140, 0x140  # offset +0x140
.equ field_208, 0x208  # offset +0x208
.equ field_30c, 0x30c  # offset +0x30c
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_348, 0x348  # offset +0x348
.equ field_504, 0x504  # offset +0x504
.equ field_508, 0x508  # offset +0x508
.equ field_50c, 0x50c  # offset +0x50c
.equ field_510, 0x510  # offset +0x510

# --- external targets -----------------------------------------------
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050f085, .text + (0x0050f085 - 0x401000)

.org 0x00508ff0 - 0x401000
.globl FUN_00508ff0
FUN_00508ff0:
    # block 0x00508ff0: entry, 19 instruction(s), calls FUN_0050e97e, ends with jle to 0x00509044 (forward)
    sub esp, 0x120                               # 00508ff0
    push ebx                                     # 00508ff6
    push ebp                                     # 00508ff7
    push esi                                     # 00508ff8
    push edi                                     # 00508ff9
    push 0x520                                   # 00508ffa
    push 0x1                                     # 00508fff
    call FUN_0050e97e                            # 00509001
    mov edi, dword ptr [esp + stk_140]           # 00509006
    {load} mov ebp, eax                          # 0050900d
    add esp, 0x8                                 # 0050900f
    {load} xor esi, esi                          # 00509012
    mov dword ptr [ebp + field_510], edi         # 00509014
    mov eax, dword ptr [edi + field_348]         # 0050901a
    mov dword ptr [ebp + field_508], eax         # 00509020
    mov ecx, dword ptr [edi]                     # 00509026
    test ecx, ecx                                # 00509028
    mov dword ptr [esp + stk_24], ebp            # 0050902a
    jle.d8 L_00509044                            # 0050902e
    # block 0x00509030: entered by fall-through of jle at 0x0050902e, 1 instruction(s), falls into the block at 0x00509033
    lea eax, [edi + field_4]                     # 00509030
L_00509033:
    # block 0x00509033: entered by jne at 0x00509042, 6 instruction(s), ends with jne to 0x00509033 (backward)
    mov edx, dword ptr [eax]                     # 00509033
    add eax, 0x4                                 # 00509035
    mov ebx, dword ptr [edi + 4*edx + field_80]  # 00509038
    {load} add esi, ebx                          # 0050903f
    dec ecx                                      # 00509041
    jne.d8 L_00509033                            # 00509042
L_00509044:
    # block 0x00509044: entered by jle at 0x0050902e; fall-through of jne at 0x00509042, 4 instruction(s), ends with jle to 0x00509068 (forward)
    add esi, 0x2                                 # 00509044
    test esi, esi                                # 00509047
    mov dword ptr [ebp + field_504], esi         # 00509049
    jle.d8 L_00509068                            # 0050904f
    # block 0x00509051: entered by fall-through of jle at 0x0050904f, 3 instruction(s), falls into the block at 0x0050905d
    lea ecx, [esp + stk_2c]                      # 00509051
    lea eax, [edi + field_344]                   # 00509055
    {load} mov edx, esi                          # 0050905b
L_0050905d:
    # block 0x0050905d: entered by jne at 0x00509066, 5 instruction(s), ends with jne to 0x0050905d (backward)
    mov dword ptr [ecx], eax                     # 0050905d
    add eax, 0x4                                 # 0050905f
    add ecx, 0x4                                 # 00509062
    dec edx                                      # 00509065
    jne.d8 L_0050905d                            # 00509066
L_00509068:
    # block 0x00509068: entered by jle at 0x0050904f; fall-through of jne at 0x00509066, 9 instruction(s), calls FUN_0050f085, ends with jle to 0x005090a6 (forward)
    push 0x509210                                # 00509068
    push 0x4                                     # 0050906d
    lea eax, [esp + stk_34]                      # 0050906f
    push esi                                     # 00509073
    push eax                                     # 00509074
    call FUN_0050f085                            # 00509075
    add esp, 0x10                                # 0050907a
    test esi, esi                                # 0050907d
    jle.d8 L_005090a6                            # 0050907f
    # block 0x00509081: entered by fall-through of jle at 0x0050907f, 3 instruction(s), falls into the block at 0x0050908d
    lea eax, [esp + stk_2c]                      # 00509081
    lea ecx, [ebp + field_104]                   # 00509085
    {load} mov edx, esi                          # 0050908b
L_0050908d:
    # block 0x0050908d: entered by jne at 0x005090a4, 9 instruction(s), ends with jne to 0x0050908d (backward)
    mov ebx, dword ptr [eax]                     # 0050908d
    add eax, 0x4                                 # 0050908f
    {load} sub ebx, edi                          # 00509092
    add ecx, 0x4                                 # 00509094
    sub ebx, 0x344                               # 00509097
    sar ebx, 0x2                                 # 0050909d
    mov dword ptr [ecx - field_minus_4], ebx     # 005090a0
    dec edx                                      # 005090a3
    jne.d8 L_0050908d                            # 005090a4
L_005090a6:
    # block 0x005090a6: entered by jle at 0x0050907f; fall-through of jne at 0x005090a4, 3 instruction(s), ends with jle to 0x005090e1 (forward)
    {load} xor eax, eax                          # 005090a6
    test esi, esi                                # 005090a8
    jle.d8 L_005090e1                            # 005090aa
    # block 0x005090ac: entered by fall-through of jle at 0x005090aa, 1 instruction(s), falls into the block at 0x005090b2
    lea ecx, [ebp + field_104]                   # 005090ac
L_005090b2:
    # block 0x005090b2: entered by jl at 0x005090c1, 6 instruction(s), ends with jl to 0x005090b2 (backward)
    mov edx, dword ptr [ecx]                     # 005090b2
    add ecx, 0x4                                 # 005090b4
    mov dword ptr [ebp + 4*edx + field_208], eax # 005090b7
    inc eax                                      # 005090be
    {load} cmp eax, esi                          # 005090bf
    jl.d8 L_005090b2                             # 005090c1
    # block 0x005090c3: entered by fall-through of jl at 0x005090c1, 2 instruction(s), ends with jle to 0x005090e1 (forward)
    test esi, esi                                # 005090c3
    jle.d8 L_005090e1                            # 005090c5
    # block 0x005090c7: entered by fall-through of jle at 0x005090c5, 2 instruction(s), falls into the block at 0x005090cb
    {load} mov eax, ebp                          # 005090c7
    {load} mov ecx, esi                          # 005090c9
L_005090cb:
    # block 0x005090cb: entered by jne at 0x005090df, 6 instruction(s), ends with jne to 0x005090cb (backward)
    mov edx, dword ptr [eax + field_104]         # 005090cb
    add eax, 0x4                                 # 005090d1
    dec ecx                                      # 005090d4
    mov edx, dword ptr [edi + 4*edx + field_344] # 005090d5
    mov dword ptr [eax - field_minus_4], edx     # 005090dc
    jne.d8 L_005090cb                            # 005090df
L_005090e1:
    # block 0x005090e1: entered by jle at 0x005090aa; jle at 0x005090c5; fall-through of jne at 0x005090df, 4 instruction(s), ends with ja to 0x00509122 (forward)
    mov eax, dword ptr [edi + field_340]         # 005090e1
    dec eax                                      # 005090e7
    cmp eax, 0x3                                 # 005090e8
    ja.d8 L_00509122                             # 005090eb
    # block 0x005090ed: entered by fall-through of ja at 0x005090eb, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x5091f4]
    jmp dword ptr [4*eax + SWTAB_005091f4_VA]    # 005090ed
L_005090f4:
    # block 0x005090f4: entered by switch case, 2 instruction(s), ends with forward jump to 0x00509122
    mov dword ptr [ebp + field_50c], 0x100       # 005090f4
    jmp.d8 L_00509122                            # 005090fe
L_00509100:
    # block 0x00509100: entered by switch case, 2 instruction(s), ends with forward jump to 0x00509122
    mov dword ptr [ebp + field_50c], 0x80        # 00509100
    jmp.d8 L_00509122                            # 0050910a
L_0050910c:
    # block 0x0050910c: entered by switch case, 2 instruction(s), ends with forward jump to 0x00509122
    mov dword ptr [ebp + field_50c], 0x56        # 0050910c
    jmp.d8 L_00509122                            # 00509116
L_00509118:
    # block 0x00509118: entered by switch case, 1 instruction(s), falls into the block at 0x00509122
    mov dword ptr [ebp + field_50c], 0x40        # 00509118
L_00509122:
    # block 0x00509122: entered by ja at 0x005090eb; jmp at 0x005090fe; jmp at 0x0050910a; jmp at 0x00509116, 4 instruction(s), ends with jle to 0x005091e5 (forward)
    add esi, -0x2                                # 00509122
    test esi, esi                                # 00509125
    mov dword ptr [esp + stk_28], esi            # 00509127
    jle.d32 L_005091e5                           # 0050912b
    # block 0x00509131: entered by fall-through of jle at 0x0050912b, 5 instruction(s), falls into the block at 0x0050914a
    lea eax, [ebp + field_30c]                   # 00509131
    add edi, 0x34c                               # 00509137
    mov edx, 0x2                                 # 0050913d
    mov dword ptr [esp + stk_20], eax            # 00509142
    mov dword ptr [esp + stk_14], edi            # 00509146
L_0050914a:
    # block 0x0050914a: entered by jl at 0x005091df, 11 instruction(s), ends with jle to 0x005091bb (forward)
    mov ecx, dword ptr [ebp + field_508]         # 0050914a
    {load} xor ebx, ebx                          # 00509150
    mov dword ptr [esp + stk_18], ecx            # 00509152
    mov ecx, dword ptr [esp + stk_14]            # 00509156
    {load} xor esi, esi                          # 0050915a
    mov edi, 0x1                                 # 0050915c
    mov ecx, dword ptr [ecx]                     # 00509161
    mov dword ptr [esp + stk_1c], ecx            # 00509163
    {load} xor ecx, ecx                          # 00509167
    test edx, edx                                # 00509169
    jle.d8 L_005091bb                            # 0050916b
    # block 0x0050916d: entered by fall-through of jle at 0x0050916b, 3 instruction(s), falls into the block at 0x0050917d
    mov eax, dword ptr [esp + stk_138]           # 0050916d
    add eax, 0x344                               # 00509174
    mov dword ptr [esp + stk_10], eax            # 00509179
L_0050917d:
    # block 0x0050917d: entered by jl at 0x005091b1, 4 instruction(s), ends with jle to 0x00509191 (forward)
    mov eax, dword ptr [esp + stk_10]            # 0050917d
    mov eax, dword ptr [eax]                     # 00509181
    {load} cmp eax, esi                          # 00509183
    jle.d8 L_00509191                            # 00509185
    # block 0x00509187: entered by fall-through of jle at 0x00509185, 2 instruction(s), ends with jge to 0x00509191 (forward)
    cmp eax, dword ptr [esp + stk_1c]            # 00509187
    jge.d8 L_00509191                            # 0050918b
    # block 0x0050918d: entered by fall-through of jge at 0x0050918b, 2 instruction(s), falls into the block at 0x00509191
    {load} mov ebx, ecx                          # 0050918d
    {load} mov esi, eax                          # 0050918f
L_00509191:
    # block 0x00509191: entered by jle at 0x00509185; jge at 0x0050918b, 2 instruction(s), ends with jge to 0x005091a3 (forward)
    cmp eax, dword ptr [esp + stk_18]            # 00509191
    jge.d8 L_005091a3                            # 00509195
    # block 0x00509197: entered by fall-through of jge at 0x00509195, 2 instruction(s), ends with jle to 0x005091a3 (forward)
    cmp eax, dword ptr [esp + stk_1c]            # 00509197
    jle.d8 L_005091a3                            # 0050919b
    # block 0x0050919d: entered by fall-through of jle at 0x0050919b, 2 instruction(s), falls into the block at 0x005091a3
    {load} mov edi, ecx                          # 0050919d
    mov dword ptr [esp + stk_18], eax            # 0050919f
L_005091a3:
    # block 0x005091a3: entered by jge at 0x00509195; jle at 0x0050919b, 6 instruction(s), ends with jl to 0x0050917d (backward)
    mov ebp, dword ptr [esp + stk_10]            # 005091a3
    inc ecx                                      # 005091a7
    add ebp, 0x4                                 # 005091a8
    {load} cmp ecx, edx                          # 005091ab
    mov dword ptr [esp + stk_10], ebp            # 005091ad
    jl.d8 L_0050917d                             # 005091b1
    # block 0x005091b3: entered by fall-through of jl at 0x005091b1, 2 instruction(s), falls into the block at 0x005091bb
    mov ebp, dword ptr [esp + stk_24]            # 005091b3
    mov eax, dword ptr [esp + stk_20]            # 005091b7
L_005091bb:
    # block 0x005091bb: entered by jle at 0x0050916b, 12 instruction(s), ends with jl to 0x0050914a (backward)
    mov ecx, dword ptr [esp + stk_14]            # 005091bb
    mov esi, dword ptr [esp + stk_28]            # 005091bf
    mov dword ptr [eax + field_fc], ebx          # 005091c3
    mov dword ptr [eax], edi                     # 005091c9
    add ecx, 0x4                                 # 005091cb
    add eax, 0x4                                 # 005091ce
    inc edx                                      # 005091d1
    mov dword ptr [esp + stk_14], ecx            # 005091d2
    mov dword ptr [esp + stk_20], eax            # 005091d6
    lea ecx, [edx - field_minus_2]               # 005091da
    {load} cmp ecx, esi                          # 005091dd
    jl.d32 L_0050914a                            # 005091df
L_005091e5:
    # block 0x005091e5: entered by jle at 0x0050912b; fall-through of jl at 0x005091df, 7 instruction(s), ends with ret
    pop edi                                      # 005091e5
    {load} mov eax, ebp                          # 005091e6
    pop esi                                      # 005091e8
    pop ebp                                      # 005091e9
    pop ebx                                      # 005091ea
    add esp, 0x120                               # 005091eb
    ret                                          # 005091f1

# --- data items (not part of the function) -------------------------
.org 0x005091f2 - 0x401000
PAD_005091f2:  # 2 byte(s) of alignment instructions
    {load} mov edi, edi
.org 0x005091f4 - 0x401000
SWTAB_005091f4:  # 4 case address(es)
    .long L_005090f4 - .text + 0x401000
    .long L_00509100 - .text + 0x401000
    .long L_0050910c - .text + 0x401000
    .long L_00509118 - .text + 0x401000
.org 0x00509204 - 0x401000
PAD_00509204:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90
.set SWTAB_005091f4_VA, SWTAB_005091f4 - .text + 0x401000

