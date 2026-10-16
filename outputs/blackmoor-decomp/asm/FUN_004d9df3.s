# FUN_004d9df3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9df3
# extent:       0x004d9df3-0x004da430 (1597 code bytes)
# span:         0x004d9df3-0x004da430 (code 1597, tables 0, padding 0)
# sha256:       89093cfd34cf38df23c468dd8be135b70e1498c58ea6873e77698001861b0f47
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d9df3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_8
# fields:       [eax + n] field_4, field_minus_1; [ecx + n] field_minus_1
# callees:      calls FUN_0044a2b7, FUN_00425fc0, FUN_004dad60, FUN_004d7ea4, FUN_0043da93, FUN_004c2790, FUN_004dae88, FUN_004daeb5, FUN_0043dbd5, FUN_004d812e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 316 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_0043da93, .text + (0x0043da93 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d7ea4, .text + (0x004d7ea4 - 0x401000)
.set FUN_004d812e, .text + (0x004d812e - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004d9df3 - 0x401000
.globl FUN_004d9df3
FUN_004d9df3:
    # block 0x004d9df3: entry, 8 instruction(s), ends with je to 0x004d9e13 (forward)
    push ebp                                     # 004d9df3
    {load} mov ebp, esp                          # 004d9df4
    sub esp, 0x8                                 # 004d9df6
    push esi                                     # 004d9df9
    push edi                                     # 004d9dfa
    movsx eax, word ptr [0x63a4cd]               # 004d9dfb
    test eax, eax                                # 004d9e02
    je.d8 L_004d9e13                             # 004d9e04
    # block 0x004d9e06: entered by fall-through of je at 0x004d9e04, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004d9e13
    push 0x55ac20                                # 004d9e06
    call FUN_0044a2b7                            # 004d9e0b
    add esp, 0x4                                 # 004d9e10
L_004d9e13:
    # block 0x004d9e13: entered by je at 0x004d9e04, 4 instruction(s), ends with je to 0x004d9e2b (forward)
    {load} xor ecx, ecx                          # 004d9e13
    mov cl, byte ptr [0x58320d]                  # 004d9e15
    test ecx, ecx                                # 004d9e1b
    je.d8 L_004d9e2b                             # 004d9e1d
    # block 0x004d9e1f: entered by fall-through of je at 0x004d9e1d, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004d9e2b
    mov byte ptr [0x58320d], 0x0                 # 004d9e1f
    call FUN_00425fc0                            # 004d9e26
L_004d9e2b:
    # block 0x004d9e2b: entered by je at 0x004d9e1d, 10 instruction(s), calls FUN_004dad60, ends with je to 0x004d9e86 (forward)
    mov ecx, 0x5830a6                            # 004d9e2b
    call FUN_004dad60                            # 004d9e30
    mov dword ptr [0x5aff79], 0x0                # 004d9e35
    mov dword ptr [0x5aff7d], 0x0                # 004d9e3f
    mov dword ptr [0x5aff81], 0x0                # 004d9e49
    mov dword ptr [0x5aff8d], 0x0                # 004d9e53
    mov dword ptr [0x5aff91], 0x0                # 004d9e5d
    mov dword ptr [0x5aff95], 0x0                # 004d9e67
    cmp dword ptr [0x5bb1e2], 0x0                # 004d9e71
    je.d8 L_004d9e86                             # 004d9e78
    # block 0x004d9e7a: entered by fall-through of je at 0x004d9e78, 2 instruction(s), ends with forward jump to 0x004d9e90
    mov dword ptr [0x5aff85], 0x0                # 004d9e7a
    jmp.d8 L_004d9e90                            # 004d9e84
L_004d9e86:
    # block 0x004d9e86: entered by je at 0x004d9e78, 1 instruction(s), falls into the block at 0x004d9e90
    mov dword ptr [0x5aff85], 0x1                # 004d9e86
L_004d9e90:
    # block 0x004d9e90: entered by jmp at 0x004d9e84, 5 instruction(s), calls FUN_004d7ea4, ends with je to 0x004d9eaf (forward)
    push 0x55ac50                                # 004d9e90
    mov ecx, 0x5e2e70                            # 004d9e95
    call FUN_004d7ea4                            # 004d9e9a
    test eax, eax                                # 004d9e9f
    je.d8 L_004d9eaf                             # 004d9ea1
    # block 0x004d9ea3: entered by fall-through of je at 0x004d9ea1, 2 instruction(s), ends with forward jump to 0x004d9eb9
    mov dword ptr [0x5aff89], 0x0                # 004d9ea3
    jmp.d8 L_004d9eb9                            # 004d9ead
L_004d9eaf:
    # block 0x004d9eaf: entered by je at 0x004d9ea1, 1 instruction(s), falls into the block at 0x004d9eb9
    mov dword ptr [0x5aff89], 0x1                # 004d9eaf
L_004d9eb9:
    # block 0x004d9eb9: entered by jmp at 0x004d9ead, 5 instruction(s), calls FUN_0043da93, ends with je to 0x004d9f3b (forward)
    mov dword ptr [0x5830d6], 0x0                # 004d9eb9
    call FUN_0043da93                            # 004d9ec3
    mov dword ptr [0x5d17f5], 0x0                # 004d9ec8
    cmp dword ptr [0x5aff4d], 0x4                # 004d9ed2
    je.d8 L_004d9f3b                             # 004d9ed9
    # block 0x004d9edb: entered by fall-through of je at 0x004d9ed9, 2 instruction(s), ends with jne to 0x004d9f04 (forward)
    cmp dword ptr [0x5d037b], 0x0                # 004d9edb
    jne.d8 L_004d9f04                            # 004d9ee2
    # block 0x004d9ee4: entered by fall-through of jne at 0x004d9ee2, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004d9f04
    push 0x55ac60                                # 004d9ee4
    push 0x6                                     # 004d9ee9
    push 0x5afcce                                # 004d9eeb
    push 0x55ac78                                # 004d9ef0
    mov ecx, 0x5cf659                            # 004d9ef5
    call FUN_004c2790                            # 004d9efa
    mov dword ptr [0x5d037b], eax                # 004d9eff
L_004d9f04:
    # block 0x004d9f04: entered by jne at 0x004d9ee2, 2 instruction(s), ends with jne to 0x004d9f2d (forward)
    cmp dword ptr [0x5d0377], 0x0                # 004d9f04
    jne.d8 L_004d9f2d                            # 004d9f0b
    # block 0x004d9f0d: entered by fall-through of jne at 0x004d9f0b, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004d9f2d
    push 0x55ac80                                # 004d9f0d
    push 0x6                                     # 004d9f12
    push 0x5b06aa                                # 004d9f14
    push 0x55ac94                                # 004d9f19
    mov ecx, 0x5cf659                            # 004d9f1e
    call FUN_004c2790                            # 004d9f23
    mov dword ptr [0x5d0377], eax                # 004d9f28
L_004d9f2d:
    # block 0x004d9f2d: entered by jne at 0x004d9f0b, 4 instruction(s), calls FUN_004dae88, falls into the block at 0x004d9f3b
    push 0x0                                     # 004d9f2d
    push 0x0                                     # 004d9f2f
    mov ecx, 0x5830a6                            # 004d9f31
    call FUN_004dae88                            # 004d9f36
L_004d9f3b:
    # block 0x004d9f3b: entered by je at 0x004d9ed9, 18 instruction(s), calls FUN_004daeb5, ends with jl to 0x004d9fbb (forward)
    mov dword ptr [0x5b44f0], 0x4                # 004d9f3b
    mov dword ptr [0x5b44f4], 0x1                # 004d9f45
    lea edx, [ebp - local_8]                     # 004d9f4f
    push edx                                     # 004d9f52
    mov ecx, 0x5830a6                            # 004d9f53
    call FUN_004daeb5                            # 004d9f58
    mov ecx, dword ptr [eax]                     # 004d9f5d
    mov edx, dword ptr [eax + field_4]           # 004d9f5f
    mov dword ptr [0x5830e2], ecx                # 004d9f62
    mov dword ptr [0x5830e6], edx                # 004d9f68
    movsx eax, word ptr [0x63988b]               # 004d9f6e
    mov ecx, dword ptr [0x5b44f4]                # 004d9f75
    shl ecx, 0x2                                 # 004d9f7b
    mov edx, dword ptr [0x5b44f0]                # 004d9f7e
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3790] # 004d9f84
    {load} sub eax, ecx                          # 004d9f8c
    cmp dword ptr [0x5830e2], eax                # 004d9f8e
    jl.d8 L_004d9fbb                             # 004d9f94
    # block 0x004d9f96: entered by fall-through of jl at 0x004d9f94, 7 instruction(s), falls into the block at 0x004d9fbb
    movsx edx, word ptr [0x63988b]               # 004d9f96
    mov eax, dword ptr [0x5b44f4]                # 004d9f9d
    shl eax, 0x2                                 # 004d9fa2
    mov ecx, dword ptr [0x5b44f0]                # 004d9fa5
    movsx eax, word ptr [eax + 8*ecx + 0x5b3790] # 004d9fab
    {load} sub edx, eax                          # 004d9fb3
    mov dword ptr [0x5830e2], edx                # 004d9fb5
L_004d9fbb:
    # block 0x004d9fbb: entered by jl at 0x004d9f94, 8 instruction(s), ends with jl to 0x004da007 (forward)
    movsx ecx, word ptr [0x63988d]               # 004d9fbb
    mov edx, dword ptr [0x5b44f4]                # 004d9fc2
    shl edx, 0x2                                 # 004d9fc8
    mov eax, dword ptr [0x5b44f0]                # 004d9fcb
    movsx edx, word ptr [edx + 8*eax + 0x5b3792] # 004d9fd0
    {load} sub ecx, edx                          # 004d9fd8
    cmp dword ptr [0x5830e6], ecx                # 004d9fda
    jl.d8 L_004da007                             # 004d9fe0
    # block 0x004d9fe2: entered by fall-through of jl at 0x004d9fe0, 7 instruction(s), falls into the block at 0x004da007
    movsx eax, word ptr [0x63988d]               # 004d9fe2
    mov ecx, dword ptr [0x5b44f4]                # 004d9fe9
    shl ecx, 0x2                                 # 004d9fef
    mov edx, dword ptr [0x5b44f0]                # 004d9ff2
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004d9ff8
    {load} sub eax, ecx                          # 004da000
    mov dword ptr [0x5830e6], eax                # 004da002
L_004da007:
    # block 0x004da007: entered by jl at 0x004d9fe0, 192 instruction(s), calls FUN_004dae88, FUN_0043dbd5, ends with je to 0x004da408 (forward)
    mov edx, dword ptr [0x5830e6]                # 004da007
    mov dword ptr [0x583106], edx                # 004da00d
    mov eax, dword ptr [0x583106]                # 004da013
    mov dword ptr [0x5830f6], eax                # 004da018
    mov ecx, dword ptr [0x5b44f4]                # 004da01d
    shl ecx, 0x2                                 # 004da023
    mov edx, dword ptr [0x5b44f0]                # 004da026
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004da02c
    mov ecx, dword ptr [0x583106]                # 004da034
    lea edx, [ecx + eax - field_minus_1]         # 004da03a
    mov dword ptr [0x58310e], edx                # 004da03e
    mov eax, dword ptr [0x58310e]                # 004da044
    mov dword ptr [0x5830fe], eax                # 004da049
    mov ecx, dword ptr [0x5830e2]                # 004da04e
    mov dword ptr [0x583102], ecx                # 004da054
    mov edx, dword ptr [0x583102]                # 004da05a
    mov dword ptr [0x5830f2], edx                # 004da060
    mov eax, dword ptr [0x5b44f4]                # 004da066
    shl eax, 0x2                                 # 004da06b
    mov ecx, dword ptr [0x5b44f0]                # 004da06e
    movsx edx, word ptr [eax + 8*ecx + 0x5b3790] # 004da074
    mov eax, dword ptr [0x583102]                # 004da07c
    lea ecx, [eax + edx - field_minus_1]         # 004da081
    mov dword ptr [0x58310a], ecx                # 004da085
    mov edx, dword ptr [0x58310a]                # 004da08b
    mov dword ptr [0x5830fa], edx                # 004da091
    mov eax, dword ptr [0x5830e6]                # 004da097
    push eax                                     # 004da09c
    mov ecx, dword ptr [0x5830e2]                # 004da09d
    push ecx                                     # 004da0a3
    mov ecx, 0x5830a6                            # 004da0a4
    call FUN_004dae88                            # 004da0a9
    mov edx, dword ptr [0x5830e2]                # 004da0ae
    mov dword ptr [0x5830ea], edx                # 004da0b4
    mov eax, dword ptr [0x5830e6]                # 004da0ba
    mov dword ptr [0x5830ee], eax                # 004da0bf
    mov dword ptr [0x5d2a17], 0x1                # 004da0c4
    mov dword ptr [0x5d2a1b], 0x4d0abc           # 004da0ce
    mov ecx, dword ptr [0x5d037b]                # 004da0d8
    mov dword ptr [0x5d2a1f], ecx                # 004da0de
    mov dword ptr [0x5d2a23], 0x5afcf5           # 004da0e4
    mov dword ptr [0x5d2a27], 0x5afcf5           # 004da0ee
    mov dword ptr [0x5d2a2b], 0x1                # 004da0f8
    mov dword ptr [0x5d2a2f], 0x1                # 004da102
    mov word ptr [0x5d2a33], 0x0                 # 004da10c
    mov edi, 0x55ac9c                            # 004da115
    mov edx, 0x5d2a39                            # 004da11a
    or ecx, -0x1                                 # 004da11f
    {load} xor eax, eax                          # 004da122
    repne scasb al, byte ptr es:[edi]            # 004da124
    not ecx                                      # 004da126
    {load} sub edi, ecx                          # 004da128
    {load} mov esi, edi                          # 004da12a
    {load} mov eax, ecx                          # 004da12c
    {load} mov edi, edx                          # 004da12e
    shr ecx, 0x2                                 # 004da130
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da133
    {load} mov ecx, eax                          # 004da135
    and ecx, 0x3                                 # 004da137
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da13a
    mov dword ptr [0x5d2a61], 0x14               # 004da13c
    mov dword ptr [0x5d2a65], 0x0                # 004da146
    mov ecx, dword ptr [0x5d0377]                # 004da150
    mov dword ptr [0x5d2a69], ecx                # 004da156
    mov edx, dword ptr [0x5b44f0]                # 004da15c
    shl edx, 0x5                                 # 004da162
    mov eax, dword ptr [0x5b44f4]                # 004da165
    shl eax, 0x4                                 # 004da16a
    lea ecx, [edx + eax + 0x5b160c]              # 004da16d
    mov dword ptr [0x5d2a6d], ecx                # 004da174
    mov dword ptr [0x5d2a71], 0x583102           # 004da17a
    mov dword ptr [0x5d2a75], 0x1                # 004da184
    mov dword ptr [0x5d2a79], 0x1                # 004da18e
    mov word ptr [0x5d2a7d], 0x2                 # 004da198
    mov edi, 0x55aca8                            # 004da1a1
    mov edx, 0x5d2a83                            # 004da1a6
    or ecx, -0x1                                 # 004da1ab
    {load} xor eax, eax                          # 004da1ae
    repne scasb al, byte ptr es:[edi]            # 004da1b0
    not ecx                                      # 004da1b2
    {load} sub edi, ecx                          # 004da1b4
    {load} mov esi, edi                          # 004da1b6
    {load} mov eax, ecx                          # 004da1b8
    {load} mov edi, edx                          # 004da1ba
    shr ecx, 0x2                                 # 004da1bc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da1bf
    {load} mov ecx, eax                          # 004da1c1
    and ecx, 0x3                                 # 004da1c3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da1c6
    mov dword ptr [0x5d2aab], 0x2                # 004da1c8
    mov dword ptr [0x5d2aaf], 0x0                # 004da1d2
    mov ecx, dword ptr [0x5d037b]                # 004da1dc
    mov dword ptr [0x5d2ab3], ecx                # 004da1e2
    mov dword ptr [0x5d2ab7], 0x5830f2           # 004da1e8
    mov dword ptr [0x5d2abb], 0x5830f2           # 004da1f2
    mov dword ptr [0x5d2abf], 0x0                # 004da1fc
    mov dword ptr [0x5d2ac3], 0x1                # 004da206
    mov word ptr [0x5d2ac7], 0x1                 # 004da210
    mov edi, 0x55acbc                            # 004da219
    mov edx, 0x5d2acd                            # 004da21e
    or ecx, -0x1                                 # 004da223
    {load} xor eax, eax                          # 004da226
    repne scasb al, byte ptr es:[edi]            # 004da228
    not ecx                                      # 004da22a
    {load} sub edi, ecx                          # 004da22c
    {load} mov esi, edi                          # 004da22e
    {load} mov eax, ecx                          # 004da230
    {load} mov edi, edx                          # 004da232
    shr ecx, 0x2                                 # 004da234
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da237
    {load} mov ecx, eax                          # 004da239
    and ecx, 0x3                                 # 004da23b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da23e
    mov dword ptr [0x5d2af5], 0x8                # 004da240
    mov dword ptr [0x5d2af9], 0x0                # 004da24a
    mov ecx, dword ptr [0x5d037b]                # 004da254
    mov dword ptr [0x5d2afd], ecx                # 004da25a
    mov dword ptr [0x5d2b01], 0x5aff59           # 004da260
    mov dword ptr [0x5d2b05], 0x5aff69           # 004da26a
    mov dword ptr [0x5d2b09], 0x0                # 004da274
    mov dword ptr [0x5d2b0d], 0x1                # 004da27e
    mov word ptr [0x5d2b11], 0x1                 # 004da288
    mov edi, 0x55acd0                            # 004da291
    mov edx, 0x5d2b17                            # 004da296
    or ecx, -0x1                                 # 004da29b
    {load} xor eax, eax                          # 004da29e
    repne scasb al, byte ptr es:[edi]            # 004da2a0
    not ecx                                      # 004da2a2
    {load} sub edi, ecx                          # 004da2a4
    {load} mov esi, edi                          # 004da2a6
    {load} mov eax, ecx                          # 004da2a8
    {load} mov edi, edx                          # 004da2aa
    shr ecx, 0x2                                 # 004da2ac
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da2af
    {load} mov ecx, eax                          # 004da2b1
    and ecx, 0x3                                 # 004da2b3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da2b6
    mov dword ptr [0x5d2b89], 0x5                # 004da2b8
    mov dword ptr [0x5d2b8d], 0x4d0afc           # 004da2c2
    mov ecx, dword ptr [0x5d037b]                # 004da2cc
    mov dword ptr [0x5d2b91], ecx                # 004da2d2
    mov dword ptr [0x5d2b95], 0x0                # 004da2d8
    mov dword ptr [0x5d2b99], 0x0                # 004da2e2
    mov dword ptr [0x5d2b9d], 0x1                # 004da2ec
    mov dword ptr [0x5d2ba1], 0x1                # 004da2f6
    mov word ptr [0x5d2ba5], 0x0                 # 004da300
    mov edi, 0x55ace8                            # 004da309
    mov edx, 0x5d2bab                            # 004da30e
    or ecx, -0x1                                 # 004da313
    {load} xor eax, eax                          # 004da316
    repne scasb al, byte ptr es:[edi]            # 004da318
    not ecx                                      # 004da31a
    {load} sub edi, ecx                          # 004da31c
    {load} mov esi, edi                          # 004da31e
    {load} mov eax, ecx                          # 004da320
    {load} mov edi, edx                          # 004da322
    shr ecx, 0x2                                 # 004da324
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da327
    {load} mov ecx, eax                          # 004da329
    and ecx, 0x3                                 # 004da32b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da32e
    mov dword ptr [0x5d2b3f], 0x4                # 004da330
    mov dword ptr [0x5d2b43], 0x4d0b68           # 004da33a
    mov ecx, dword ptr [0x5d037b]                # 004da344
    mov dword ptr [0x5d2b47], ecx                # 004da34a
    mov dword ptr [0x5d2b4b], 0x0                # 004da350
    mov dword ptr [0x5d2b4f], 0x0                # 004da35a
    mov dword ptr [0x5d2b53], 0x0                # 004da364
    mov dword ptr [0x5d2b57], 0x1                # 004da36e
    mov word ptr [0x5d2b5b], 0x0                 # 004da378
    mov edi, 0x55ad04                            # 004da381
    mov edx, 0x5d2b61                            # 004da386
    or ecx, -0x1                                 # 004da38b
    {load} xor eax, eax                          # 004da38e
    repne scasb al, byte ptr es:[edi]            # 004da390
    not ecx                                      # 004da392
    {load} sub edi, ecx                          # 004da394
    {load} mov esi, edi                          # 004da396
    {load} mov eax, ecx                          # 004da398
    {load} mov edi, edx                          # 004da39a
    shr ecx, 0x2                                 # 004da39c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004da39f
    {load} mov ecx, eax                          # 004da3a1
    and ecx, 0x3                                 # 004da3a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004da3a6
    call FUN_0043dbd5                            # 004da3a8
    mov dword ptr [0x5aff4d], 0x0                # 004da3ad
    mov dword ptr [0x5aff51], 0x0                # 004da3b7
    mov word ptr [0x5aff55], 0xffff              # 004da3c1
    mov word ptr [0x5aff57], 0xffff              # 004da3ca
    cmp dword ptr [0x5bb1de], 0x0                # 004da3d3
    je.d8 L_004da408                             # 004da3da
    # block 0x004da3dc: entered by fall-through of je at 0x004da3da, 2 instruction(s), ends with je to 0x004da3fe (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004da3dc
    je.d8 L_004da3fe                             # 004da3e3
    # block 0x004da3e5: entered by fall-through of je at 0x004da3e3, 4 instruction(s), calls FUN_004d812e, falls into the block at 0x004da3fe
    push 0x55ad20                                # 004da3e5
    mov ecx, 0x5e2e70                            # 004da3ea
    call FUN_004d812e                            # 004da3ef
    mov dword ptr [0x583981], 0x6                # 004da3f4
L_004da3fe:
    # block 0x004da3fe: entered by je at 0x004da3e3, 1 instruction(s), falls into the block at 0x004da408
    mov dword ptr [0x5bb1de], 0x0                # 004da3fe
L_004da408:
    # block 0x004da408: entered by je at 0x004da3da, 4 instruction(s), ends with je to 0x004da42a (forward)
    mov dword ptr [0x5839a1], 0x1                # 004da408
    movsx ecx, word ptr [0x63a4cd]               # 004da412
    test ecx, ecx                                # 004da419
    je.d8 L_004da42a                             # 004da41b
    # block 0x004da41d: entered by fall-through of je at 0x004da41b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004da42a
    push 0x55ad30                                # 004da41d
    call FUN_0044a2b7                            # 004da422
    add esp, 0x4                                 # 004da427
L_004da42a:
    # block 0x004da42a: entered by je at 0x004da41b, 5 instruction(s), ends with ret
    pop edi                                      # 004da42a
    pop esi                                      # 004da42b
    {load} mov esp, ebp                          # 004da42c
    pop ebp                                      # 004da42e
    ret                                          # 004da42f

