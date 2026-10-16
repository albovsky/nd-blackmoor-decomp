# FUN_004fdfd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdfd0
# extent:       0x004fdfd0-0x004fe28a (698 code bytes)
# span:         0x004fdfd0-0x004fe290 (code 698, tables 0, padding 6)
# sha256:       1a1c2bcc9d94842d43981a7fedccf334cb7c88d93f0d87417036ec071d053bc8
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdfd0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [edi + n] field_4, field_c, field_10, field_14; [esi + n] field_4, field_34, field_40, field_44, field_48, field_4c, field_50, field_54, field_58, field_5c, field_60, field_64 and 4 more; [esp + n] stk_10, stk_14, stk_20, stk_40, stk_44, stk_48, stk_4c, stk_58
# callees:      calls FUN_0050ba70, FUN_004ffa30, FUN_004fd2b0, FUN_0050b260, FUN_004fdf40, FUN_004fe700, FUN_004fe660, FUN_0050ba50, FUN_004fd160, FUN_004fdf80, FUN_0050b6f0, FUN_004ff9a0, FUN_004ff590
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 258 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34
.equ stk_40, 0x40  # offset +0x40
.equ field_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ field_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ field_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ stk_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_6c, 0x6c  # offset +0x6c
.equ field_74, 0x74  # offset +0x74
.equ field_1da, 0x1da  # offset +0x1da
.equ field_242, 0x242  # offset +0x242

# --- external targets -----------------------------------------------
.set FUN_004fd160, .text + (0x004fd160 - 0x401000)
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fdf40, .text + (0x004fdf40 - 0x401000)
.set FUN_004fdf80, .text + (0x004fdf80 - 0x401000)
.set FUN_004fe660, .text + (0x004fe660 - 0x401000)
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_004ff590, .text + (0x004ff590 - 0x401000)
.set FUN_004ff9a0, .text + (0x004ff9a0 - 0x401000)
.set FUN_004ffa30, .text + (0x004ffa30 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050b6f0, .text + (0x0050b6f0 - 0x401000)
.set FUN_0050ba50, .text + (0x0050ba50 - 0x401000)
.set FUN_0050ba70, .text + (0x0050ba70 - 0x401000)

.org 0x004fdfd0 - 0x401000
.globl FUN_004fdfd0
FUN_004fdfd0:
    # block 0x004fdfd0: entry, 6 instruction(s), falls into the block at 0x004fdfdb
    sub esp, 0x30                                # 004fdfd0
    push ebx                                     # 004fdfd3
    push ebp                                     # 004fdfd4
    push esi                                     # 004fdfd5
    mov esi, dword ptr [esp + stk_40]            # 004fdfd6
    push edi                                     # 004fdfda
L_004fdfdb:
    # block 0x004fdfdb: entered by jmp at 0x004fe163, 2 instruction(s), ends with jne to 0x004fe02f (forward)
    cmp dword ptr [esi + field_58], 0x4          # 004fdfdb
    jne.d8 L_004fe02f                            # 004fdfdf
L_004fdfe1:
    # block 0x004fdfe1: entered by jmp at 0x004fe02d; fall-through of jne at 0x004fdfdf, 3 instruction(s), ends with jne to 0x004fdfed (forward)
    mov edi, dword ptr [esp + stk_48]            # 004fdfe1
    test edi, edi                                # 004fdfe5
    jne.d8 L_004fdfed                            # 004fdfe7
    # block 0x004fdfe9: entered by fall-through of jne at 0x004fdfe7, 1 instruction(s), falls into the block at 0x004fdfed
    lea edi, [esp + stk_20]                      # 004fdfe9
L_004fdfed:
    # block 0x004fdfed: entered by jne at 0x004fdfe7, 8 instruction(s), calls FUN_0050ba70, ends with je to 0x004fe168 (forward)
    lea eax, [esi + field_74]                    # 004fdfed
    push edi                                     # 004fdff0
    push eax                                     # 004fdff1
    call FUN_0050ba70                            # 004fdff2
    add esp, 0x8                                 # 004fdff7
    cmp eax, -0x1                                # 004fdffa
    mov dword ptr [esp + stk_48], 0x0            # 004fdffd
    je.d32 L_004fe168                            # 004fe005
    # block 0x004fe00b: entered by fall-through of je at 0x004fe005, 2 instruction(s), ends with jle to 0x004fe02f (forward)
    test eax, eax                                # 004fe00b
    jle.d8 L_004fe02f                            # 004fe00d
    # block 0x004fe00f: entered by fall-through of jle at 0x004fe00d, 9 instruction(s), calls FUN_004ffa30, ends with je to 0x004fe175 (forward)
    mov ebx, dword ptr [edi + field_10]          # 004fe00f
    mov ebp, dword ptr [edi + field_14]          # 004fe012
    lea eax, [esi + field_242]                   # 004fe015
    push edi                                     # 004fe01b
    push eax                                     # 004fe01c
    call FUN_004ffa30                            # 004fe01d
    add esp, 0x8                                 # 004fe022
    test eax, eax                                # 004fe025
    je.d32 L_004fe175                            # 004fe027
    # block 0x004fe02d: entered by fall-through of je at 0x004fe027, 1 instruction(s), ends with backward jump to 0x004fdfe1
    jmp.d8 L_004fdfe1                            # 004fe02d
L_004fe02f:
    # block 0x004fe02f: entered by jne at 0x004fdfdf; jle at 0x004fe00d, 2 instruction(s), ends with jl to 0x004fe0c3 (forward)
    cmp dword ptr [esi + field_58], 0x2          # 004fe02f
    jl.d32 L_004fe0c3                            # 004fe033
    # block 0x004fe039: entered by fall-through of jl at 0x004fe033, 3 instruction(s), ends with je to 0x004fe266 (forward)
    mov eax, dword ptr [esp + stk_4c]            # 004fe039
    test eax, eax                                # 004fe03d
    je.d32 L_004fe266                            # 004fe03f
    # block 0x004fe045: entered by fall-through of je at 0x004fe03f, 9 instruction(s), calls FUN_004fd2b0, ends with jl to 0x004fe270 (forward)
    push -0x1                                    # 004fe045
    lea ecx, [esp + stk_14]                      # 004fe047
    push -0x1                                    # 004fe04b
    push ecx                                     # 004fe04d
    push esi                                     # 004fe04e
    call FUN_004fd2b0                            # 004fe04f
    add esp, 0x10                                # 004fe054
    test edx, edx                                # 004fe057
    jl.d32 L_004fe270                            # 004fe059
    # block 0x004fe05f: entered by fall-through of jl at 0x004fe059, 1 instruction(s), ends with jg to 0x004fe069 (forward)
    jg.d8 L_004fe069                             # 004fe05f
    # block 0x004fe061: entered by fall-through of jg at 0x004fe05f, 2 instruction(s), ends with jb to 0x004fe270 (forward)
    test eax, eax                                # 004fe061
    jb.d32 L_004fe270                            # 004fe063
L_004fe069:
    # block 0x004fe069: entered by jg at 0x004fe05f; fall-through of jb at 0x004fe063, 9 instruction(s), ends with jne to 0x004fe0c3 (forward)
    mov edx, dword ptr [esp + stk_14]            # 004fe069
    lea eax, [8*edx]                             # 004fe06d
    mov dword ptr [esp + stk_44], eax            # 004fe074
    mov eax, dword ptr [esi + field_58]          # 004fe078
    fild dword ptr [esp + stk_44]                # 004fe07b
    cmp eax, 0x4                                 # 004fe07f
    fadd qword ptr [esi + field_64]              # 004fe082
    fstp qword ptr [esi + field_64]              # 004fe085
    jne.d8 L_004fe0c3                            # 004fe088
    # block 0x004fe08a: entered by fall-through of jne at 0x004fe088, 7 instruction(s), calls FUN_0050b260, ends with je to 0x004fe0c3 (forward)
    lea ecx, [esp + stk_10]                      # 004fe08a
    push ecx                                     # 004fe08e
    call FUN_0050b260                            # 004fe08f
    mov ecx, dword ptr [esi + field_5c]          # 004fe094
    add esp, 0x4                                 # 004fe097
    {load} cmp ecx, eax                          # 004fe09a
    je.d8 L_004fe0c3                             # 004fe09c
    # block 0x004fe09e: entered by fall-through of je at 0x004fe09c, 6 instruction(s), calls FUN_004fdf40, ends with jne to 0x004fe0c3 (forward)
    push esi                                     # 004fe09e
    call FUN_004fdf40                            # 004fe09f
    mov eax, dword ptr [esi + field_4]           # 004fe0a4
    add esp, 0x4                                 # 004fe0a7
    test eax, eax                                # 004fe0aa
    jne.d8 L_004fe0c3                            # 004fe0ac
    # block 0x004fe0ae: entered by fall-through of jne at 0x004fe0ac, 7 instruction(s), calls FUN_004fe700, FUN_004fe660, falls into the block at 0x004fe0c3
    mov edx, dword ptr [esi + field_48]          # 004fe0ae
    push edx                                     # 004fe0b1
    call FUN_004fe700                            # 004fe0b2
    mov eax, dword ptr [esi + field_4c]          # 004fe0b7
    push eax                                     # 004fe0ba
    call FUN_004fe660                            # 004fe0bb
    add esp, 0x8                                 # 004fe0c0
L_004fe0c3:
    # block 0x004fe0c3: entered by jl at 0x004fe033; jne at 0x004fe088; je at 0x004fe09c; jne at 0x004fe0ac, 3 instruction(s), ends with je to 0x004fe152 (forward)
    mov eax, dword ptr [esi + field_58]          # 004fe0c3
    cmp eax, 0x4                                 # 004fe0c6
    je.d32 L_004fe152                            # 004fe0c9
    # block 0x004fe0cf: entered by fall-through of je at 0x004fe0c9, 2 instruction(s), ends with jge to 0x004fe149 (forward)
    cmp eax, 0x3                                 # 004fe0cf
    jge.d8 L_004fe149                            # 004fe0d2
    # block 0x004fe0d4: entered by fall-through of jge at 0x004fe0d2, 3 instruction(s), ends with je to 0x004fe124 (forward)
    mov eax, dword ptr [esi + field_4]           # 004fe0d4
    test eax, eax                                # 004fe0d7
    je.d8 L_004fe124                             # 004fe0d9
    # block 0x004fe0db: entered by fall-through of je at 0x004fe0d9, 9 instruction(s), calls FUN_0050b260, ends with jle to 0x004fe103 (forward)
    lea ecx, [esp + stk_10]                      # 004fe0db
    push ecx                                     # 004fe0df
    call FUN_0050b260                            # 004fe0e0
    mov edx, dword ptr [esi + field_34]          # 004fe0e5
    add esp, 0x4                                 # 004fe0e8
    {load} xor ecx, ecx                          # 004fe0eb
    mov dword ptr [esi + field_5c], eax          # 004fe0ed
    test edx, edx                                # 004fe0f0
    jle.d8 L_004fe103                            # 004fe0f2
    # block 0x004fe0f4: entered by fall-through of jle at 0x004fe0f2, 1 instruction(s), falls into the block at 0x004fe0f7
    mov edi, dword ptr [esi + field_40]          # 004fe0f4
L_004fe0f7:
    # block 0x004fe0f7: entered by jl at 0x004fe101, 2 instruction(s), ends with je to 0x004fe103 (forward)
    cmp dword ptr [edi], eax                     # 004fe0f7
    je.d8 L_004fe103                             # 004fe0f9
    # block 0x004fe0fb: entered by fall-through of je at 0x004fe0f9, 4 instruction(s), ends with jl to 0x004fe0f7 (backward)
    inc ecx                                      # 004fe0fb
    add edi, 0x4                                 # 004fe0fc
    {load} cmp ecx, edx                          # 004fe0ff
    jl.d8 L_004fe0f7                             # 004fe101
L_004fe103:
    # block 0x004fe103: entered by jle at 0x004fe0f2; je at 0x004fe0f9; fall-through of jl at 0x004fe101, 2 instruction(s), ends with je to 0x004fe27d (forward)
    {load} cmp ecx, edx                          # 004fe103
    je.d32 L_004fe27d                            # 004fe105
    # block 0x004fe10b: entered by fall-through of je at 0x004fe105, 8 instruction(s), calls FUN_0050ba50, ends with forward jump to 0x004fe149
    lea edx, [esi + field_74]                    # 004fe10b
    push eax                                     # 004fe10e
    push edx                                     # 004fe10f
    mov dword ptr [esi + field_60], ecx          # 004fe110
    call FUN_0050ba50                            # 004fe113
    add esp, 0x8                                 # 004fe118
    mov dword ptr [esi + field_58], 0x3          # 004fe11b
    jmp.d8 L_004fe149                            # 004fe122
L_004fe124:
    # block 0x004fe124: entered by je at 0x004fe0d9, 13 instruction(s), calls FUN_004fd160, ends with jne to 0x004fe282 (forward)
    mov edx, dword ptr [esi + field_4c]          # 004fe124
    lea eax, [esp + stk_10]                      # 004fe127
    lea ecx, [esi + field_5c]                    # 004fe12b
    push eax                                     # 004fe12e
    mov eax, dword ptr [esi + field_48]          # 004fe12f
    push ecx                                     # 004fe132
    push edx                                     # 004fe133
    push eax                                     # 004fe134
    push esi                                     # 004fe135
    call FUN_004fd160                            # 004fe136
    add esp, 0x14                                # 004fe13b
    test eax, eax                                # 004fe13e
    jne.d32 L_004fe282                           # 004fe140
    # block 0x004fe146: entered by fall-through of jne at 0x004fe140, 1 instruction(s), falls into the block at 0x004fe149
    inc dword ptr [esi + field_60]               # 004fe146
L_004fe149:
    # block 0x004fe149: entered by jge at 0x004fe0d2; jmp at 0x004fe122, 3 instruction(s), calls FUN_004fdf80, falls into the block at 0x004fe152
    push esi                                     # 004fe149
    call FUN_004fdf80                            # 004fe14a
    add esp, 0x4                                 # 004fe14f
L_004fe152:
    # block 0x004fe152: entered by je at 0x004fe0c9, 7 instruction(s), calls FUN_0050b6f0, ends with backward jump to 0x004fdfdb
    lea ecx, [esp + stk_10]                      # 004fe152
    lea edx, [esi + field_74]                    # 004fe156
    push ecx                                     # 004fe159
    push edx                                     # 004fe15a
    call FUN_0050b6f0                            # 004fe15b
    add esp, 0x8                                 # 004fe160
    jmp.d32 L_004fdfdb                           # 004fe163
L_004fe168:
    # block 0x004fe168: entered by je at 0x004fe005, 7 instruction(s), ends with ret
    pop edi                                      # 004fe168
    pop esi                                      # 004fe169
    pop ebp                                      # 004fe16a
    mov eax, 0xfffffffd                          # 004fe16b
    pop ebx                                      # 004fe170
    add esp, 0x30                                # 004fe171
    ret                                          # 004fe174
L_004fe175:
    # block 0x004fe175: entered by je at 0x004fe027, 7 instruction(s), calls FUN_004ff9a0, ends with je to 0x004fe197 (forward)
    lea eax, [esi + field_1da]                   # 004fe175
    push 0x0                                     # 004fe17b
    push eax                                     # 004fe17d
    call FUN_004ff9a0                            # 004fe17e
    add esp, 0x8                                 # 004fe183
    test eax, eax                                # 004fe186
    je.d8 L_004fe197                             # 004fe188
    # block 0x004fe18a: entered by fall-through of je at 0x004fe188, 7 instruction(s), ends with ret
    pop edi                                      # 004fe18a
    pop esi                                      # 004fe18b
    pop ebp                                      # 004fe18c
    mov eax, 0xffffff7f                          # 004fe18d
    pop ebx                                      # 004fe192
    add esp, 0x30                                # 004fe193
    ret                                          # 004fe196
L_004fe197:
    # block 0x004fe197: entered by je at 0x004fe188, 24 instruction(s), calls FUN_004ff590, FUN_004ff9a0, ends with je to 0x004fe259 (forward)
    lea eax, [esi + field_242]                   # 004fe197
    push eax                                     # 004fe19d
    lea eax, [esi + field_1da]                   # 004fe19e
    push eax                                     # 004fe1a4
    call FUN_004ff590                            # 004fe1a5
    lea eax, [esi + field_1da]                   # 004fe1aa
    push 0x0                                     # 004fe1b0
    push eax                                     # 004fe1b2
    call FUN_004ff9a0                            # 004fe1b3
    mov dword ptr [esp + stk_58], eax            # 004fe1b8
    {load} mov edx, ebx                          # 004fe1bc
    fild dword ptr [esp + stk_58]                # 004fe1be
    {load} and edx, ebp                          # 004fe1c2
    add esp, 0x10                                # 004fe1c4
    fadd qword ptr [esi + field_6c]              # 004fe1c7
    fstp qword ptr [esi + field_6c]              # 004fe1ca
    mov ecx, dword ptr [edi + field_4]           # 004fe1cd
    shl ecx, 0x3                                 # 004fe1d0
    mov dword ptr [esp + stk_48], ecx            # 004fe1d3
    cmp edx, -0x1                                # 004fe1d7
    fild dword ptr [esp + stk_48]                # 004fe1da
    fadd qword ptr [esi + field_64]              # 004fe1de
    fstp qword ptr [esi + field_64]              # 004fe1e1
    je.d8 L_004fe259                             # 004fe1e4
    # block 0x004fe1e6: entered by fall-through of je at 0x004fe1e4, 3 instruction(s), ends with jne to 0x004fe259 (forward)
    mov eax, dword ptr [edi + field_c]           # 004fe1e6
    test eax, eax                                # 004fe1e9
    jne.d8 L_004fe259                            # 004fe1eb
    # block 0x004fe1ed: entered by fall-through of jne at 0x004fe1eb, 3 instruction(s), ends with je to 0x004fe1f9 (forward)
    mov eax, dword ptr [esi + field_4]           # 004fe1ed
    test eax, eax                                # 004fe1f0
    je.d8 L_004fe1f9                             # 004fe1f2
    # block 0x004fe1f4: entered by fall-through of je at 0x004fe1f2, 2 instruction(s), ends with forward jump to 0x004fe1fb
    mov edi, dword ptr [esi + field_60]          # 004fe1f4
    jmp.d8 L_004fe1fb                            # 004fe1f7
L_004fe1f9:
    # block 0x004fe1f9: entered by je at 0x004fe1f2, 1 instruction(s), falls into the block at 0x004fe1fb
    {load} xor edi, edi                          # 004fe1f9
L_004fe1fb:
    # block 0x004fe1fb: entered by jmp at 0x004fe1f7, 2 instruction(s), ends with je to 0x004fe216 (forward)
    test eax, eax                                # 004fe1fb
    je.d8 L_004fe216                             # 004fe1fd
    # block 0x004fe1ff: entered by fall-through of je at 0x004fe1fd, 2 instruction(s), ends with jle to 0x004fe216 (forward)
    test edi, edi                                # 004fe1ff
    jle.d8 L_004fe216                            # 004fe201
    # block 0x004fe203: entered by fall-through of jle at 0x004fe201, 8 instruction(s), falls into the block at 0x004fe216
    mov ecx, dword ptr [esi + field_44]          # 004fe203
    {load} mov eax, edi                          # 004fe206
    shl eax, 0x4                                 # 004fe208
    {load} add eax, ecx                          # 004fe20b
    mov ecx, dword ptr [eax]                     # 004fe20d
    {load} sub ebx, ecx                          # 004fe20f
    mov edx, dword ptr [eax + field_4]           # 004fe211
    {load} sbb ebp, edx                          # 004fe214
L_004fe216:
    # block 0x004fe216: entered by je at 0x004fe1fd; jle at 0x004fe201, 2 instruction(s), ends with jg to 0x004fe224 (forward)
    test ebp, ebp                                # 004fe216
    jg.d8 L_004fe224                             # 004fe218
    # block 0x004fe21a: entered by fall-through of jg at 0x004fe218, 1 instruction(s), ends with jl to 0x004fe220 (forward)
    jl.d8 L_004fe220                             # 004fe21a
    # block 0x004fe21c: entered by fall-through of jl at 0x004fe21a, 2 instruction(s), ends with jae to 0x004fe224 (forward)
    test ebx, ebx                                # 004fe21c
    jae.d8 L_004fe224                            # 004fe21e
L_004fe220:
    # block 0x004fe220: entered by jl at 0x004fe21a; fall-through of jae at 0x004fe21e, 2 instruction(s), falls into the block at 0x004fe224
    {load} xor ebx, ebx                          # 004fe220
    {load} xor ebp, ebp                          # 004fe222
L_004fe224:
    # block 0x004fe224: entered by jg at 0x004fe218; jae at 0x004fe21e, 10 instruction(s), calls FUN_004ff9a0, ends with jle to 0x004fe253 (forward)
    lea eax, [esi + field_1da]                   # 004fe224
    push 0x0                                     # 004fe22a
    push eax                                     # 004fe22c
    call FUN_004ff9a0                            # 004fe22d
    cdq                                          # 004fe232
    add esp, 0x8                                 # 004fe233
    {load} sub ebx, eax                          # 004fe236
    {load} sbb ebp, edx                          # 004fe238
    test edi, edi                                # 004fe23a
    jle.d8 L_004fe253                            # 004fe23c
    # block 0x004fe23e: entered by fall-through of jle at 0x004fe23c, 2 instruction(s), falls into the block at 0x004fe244
    mov eax, dword ptr [esi + field_44]          # 004fe23e
    add eax, 0x8                                 # 004fe241
L_004fe244:
    # block 0x004fe244: entered by jne at 0x004fe251, 7 instruction(s), ends with jne to 0x004fe244 (backward)
    mov ecx, dword ptr [eax]                     # 004fe244
    mov edx, dword ptr [eax + field_4]           # 004fe246
    {load} add ebx, ecx                          # 004fe249
    {load} adc ebp, edx                          # 004fe24b
    add eax, 0x10                                # 004fe24d
    dec edi                                      # 004fe250
    jne.d8 L_004fe244                            # 004fe251
L_004fe253:
    # block 0x004fe253: entered by jle at 0x004fe23c; fall-through of jne at 0x004fe251, 2 instruction(s), falls into the block at 0x004fe259
    mov dword ptr [esi + field_50], ebx          # 004fe253
    mov dword ptr [esi + field_54], ebp          # 004fe256
L_004fe259:
    # block 0x004fe259: entered by je at 0x004fe1e4; jne at 0x004fe1eb, 7 instruction(s), ends with ret
    pop edi                                      # 004fe259
    pop esi                                      # 004fe25a
    pop ebp                                      # 004fe25b
    mov eax, 0x1                                 # 004fe25c
    pop ebx                                      # 004fe261
    add esp, 0x30                                # 004fe262
    ret                                          # 004fe265
L_004fe266:
    # block 0x004fe266: entered by je at 0x004fe03f, 7 instruction(s), ends with ret
    pop edi                                      # 004fe266
    pop esi                                      # 004fe267
    pop ebp                                      # 004fe268
    {load} xor eax, eax                          # 004fe269
    pop ebx                                      # 004fe26b
    add esp, 0x30                                # 004fe26c
    ret                                          # 004fe26f
L_004fe270:
    # block 0x004fe270: entered by jl at 0x004fe059; jb at 0x004fe063, 7 instruction(s), ends with ret
    pop edi                                      # 004fe270
    pop esi                                      # 004fe271
    pop ebp                                      # 004fe272
    mov eax, 0xfffffffe                          # 004fe273
    pop ebx                                      # 004fe278
    add esp, 0x30                                # 004fe279
    ret                                          # 004fe27c
L_004fe27d:
    # block 0x004fe27d: entered by je at 0x004fe105, 1 instruction(s), falls into the block at 0x004fe282
    mov eax, 0xffffff77                          # 004fe27d
L_004fe282:
    # block 0x004fe282: entered by jne at 0x004fe140, 6 instruction(s), ends with ret
    pop edi                                      # 004fe282
    pop esi                                      # 004fe283
    pop ebp                                      # 004fe284
    pop ebx                                      # 004fe285
    add esp, 0x30                                # 004fe286
    ret                                          # 004fe289

# --- data items (not part of the function) -------------------------
.org 0x004fe28a - 0x401000
PAD_004fe28a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

