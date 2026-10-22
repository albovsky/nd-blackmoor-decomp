# FUN_004090ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004090ab
# extent:       0x004090ab-0x0040a209 (4446 code bytes)
# span:         0x004090ab-0x0040a209 (code 4446, tables 0, padding 0)
# sha256:       3de509524bffdb7811d7fe6a0deceae59ed907ed9b02789956b265ad1c520141
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004090ab
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d58b, FUN_005193ca, FUN_0050ca3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1421 instruction(s), 40 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)
.set FUN_0051d58b, .text + (0x0051d58b - 0x401000)

.org 0x004090ab - 0x401000
.globl FUN_004090ab
FUN_004090ab:
    # block 0x004090ab: entry, 9 instruction(s), ends with jne to 0x004090fd (forward)
    push ebp                                     # 004090ab
    {load} mov ebp, esp                          # 004090ac
    sub esp, 0x18                                # 004090ae
    push esi                                     # 004090b1
    push edi                                     # 004090b2
    mov dword ptr [ebp - local_18], ecx          # 004090b3
    movsx eax, word ptr [0x5ec2d6]               # 004090b6
    cmp eax, 0x270f                              # 004090bd
    jne.d8 L_004090fd                            # 004090c2
    # block 0x004090c4: entered by fall-through of jne at 0x004090c2, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409122
    mov edi, 0x53eb90                            # 004090c4
    lea edx, [ebp - local_14]                    # 004090c9
    or ecx, -0x1                                 # 004090cc
    {load} xor eax, eax                          # 004090cf
    repne scasb al, byte ptr es:[edi]            # 004090d1
    not ecx                                      # 004090d3
    {load} sub edi, ecx                          # 004090d5
    {load} mov esi, edi                          # 004090d7
    {load} mov eax, ecx                          # 004090d9
    {load} mov edi, edx                          # 004090db
    shr ecx, 0x2                                 # 004090dd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004090e0
    {load} mov ecx, eax                          # 004090e2
    and ecx, 0x3                                 # 004090e4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004090e7
    lea ecx, [ebp - local_14]                    # 004090e9
    push ecx                                     # 004090ec
    mov ecx, dword ptr [ebp - local_18]          # 004090ed
    add ecx, 0x8c                                # 004090f0
    call FUN_0051d58b                            # 004090f6
    jmp.d8 L_00409122                            # 004090fb
L_004090fd:
    # block 0x004090fd: entered by jne at 0x004090c2, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409122
    push 0xa                                     # 004090fd
    lea edx, [ebp - local_14]                    # 004090ff
    push edx                                     # 00409102
    movsx eax, word ptr [0x5ec2d6]               # 00409103
    push eax                                     # 0040910a
    call FUN_005193ca                            # 0040910b
    add esp, 0xc                                 # 00409110
    push eax                                     # 00409113
    mov ecx, dword ptr [ebp - local_18]          # 00409114
    add ecx, 0x8c                                # 00409117
    call FUN_0051d58b                            # 0040911d
L_00409122:
    # block 0x00409122: entered by jmp at 0x004090fb, 3 instruction(s), ends with jne to 0x0040916a (forward)
    movsx ecx, word ptr [0x5ec2d8]               # 00409122
    cmp ecx, 0x270f                              # 00409129
    jne.d8 L_0040916a                            # 0040912f
    # block 0x00409131: entered by fall-through of jne at 0x0040912f, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040918f
    mov edi, 0x53eb94                            # 00409131
    lea edx, [ebp - local_14]                    # 00409136
    or ecx, -0x1                                 # 00409139
    {load} xor eax, eax                          # 0040913c
    repne scasb al, byte ptr es:[edi]            # 0040913e
    not ecx                                      # 00409140
    {load} sub edi, ecx                          # 00409142
    {load} mov esi, edi                          # 00409144
    {load} mov eax, ecx                          # 00409146
    {load} mov edi, edx                          # 00409148
    shr ecx, 0x2                                 # 0040914a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040914d
    {load} mov ecx, eax                          # 0040914f
    and ecx, 0x3                                 # 00409151
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409154
    lea ecx, [ebp - local_14]                    # 00409156
    push ecx                                     # 00409159
    mov ecx, dword ptr [ebp - local_18]          # 0040915a
    add ecx, 0xcc                                # 0040915d
    call FUN_0051d58b                            # 00409163
    jmp.d8 L_0040918f                            # 00409168
L_0040916a:
    # block 0x0040916a: entered by jne at 0x0040912f, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x0040918f
    push 0xa                                     # 0040916a
    lea edx, [ebp - local_14]                    # 0040916c
    push edx                                     # 0040916f
    movsx eax, word ptr [0x5ec2d8]               # 00409170
    push eax                                     # 00409177
    call FUN_005193ca                            # 00409178
    add esp, 0xc                                 # 0040917d
    push eax                                     # 00409180
    mov ecx, dword ptr [ebp - local_18]          # 00409181
    add ecx, 0xcc                                # 00409184
    call FUN_0051d58b                            # 0040918a
L_0040918f:
    # block 0x0040918f: entered by jmp at 0x00409168, 3 instruction(s), ends with jne to 0x004091d7 (forward)
    movsx ecx, word ptr [0x5ec2da]               # 0040918f
    cmp ecx, 0x270f                              # 00409196
    jne.d8 L_004091d7                            # 0040919c
    # block 0x0040919e: entered by fall-through of jne at 0x0040919c, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004091fc
    mov edi, 0x53eb98                            # 0040919e
    lea edx, [ebp - local_14]                    # 004091a3
    or ecx, -0x1                                 # 004091a6
    {load} xor eax, eax                          # 004091a9
    repne scasb al, byte ptr es:[edi]            # 004091ab
    not ecx                                      # 004091ad
    {load} sub edi, ecx                          # 004091af
    {load} mov esi, edi                          # 004091b1
    {load} mov eax, ecx                          # 004091b3
    {load} mov edi, edx                          # 004091b5
    shr ecx, 0x2                                 # 004091b7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004091ba
    {load} mov ecx, eax                          # 004091bc
    and ecx, 0x3                                 # 004091be
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004091c1
    lea ecx, [ebp - local_14]                    # 004091c3
    push ecx                                     # 004091c6
    mov ecx, dword ptr [ebp - local_18]          # 004091c7
    add ecx, 0x10c                               # 004091ca
    call FUN_0051d58b                            # 004091d0
    jmp.d8 L_004091fc                            # 004091d5
L_004091d7:
    # block 0x004091d7: entered by jne at 0x0040919c, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004091fc
    push 0xa                                     # 004091d7
    lea edx, [ebp - local_14]                    # 004091d9
    push edx                                     # 004091dc
    movsx eax, word ptr [0x5ec2da]               # 004091dd
    push eax                                     # 004091e4
    call FUN_005193ca                            # 004091e5
    add esp, 0xc                                 # 004091ea
    push eax                                     # 004091ed
    mov ecx, dword ptr [ebp - local_18]          # 004091ee
    add ecx, 0x10c                               # 004091f1
    call FUN_0051d58b                            # 004091f7
L_004091fc:
    # block 0x004091fc: entered by jmp at 0x004091d5, 3 instruction(s), ends with jne to 0x00409244 (forward)
    movsx ecx, word ptr [0x5ec2dc]               # 004091fc
    cmp ecx, 0x270f                              # 00409203
    jne.d8 L_00409244                            # 00409209
    # block 0x0040920b: entered by fall-through of jne at 0x00409209, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409269
    mov edi, 0x53eb9c                            # 0040920b
    lea edx, [ebp - local_14]                    # 00409210
    or ecx, -0x1                                 # 00409213
    {load} xor eax, eax                          # 00409216
    repne scasb al, byte ptr es:[edi]            # 00409218
    not ecx                                      # 0040921a
    {load} sub edi, ecx                          # 0040921c
    {load} mov esi, edi                          # 0040921e
    {load} mov eax, ecx                          # 00409220
    {load} mov edi, edx                          # 00409222
    shr ecx, 0x2                                 # 00409224
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409227
    {load} mov ecx, eax                          # 00409229
    and ecx, 0x3                                 # 0040922b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040922e
    lea ecx, [ebp - local_14]                    # 00409230
    push ecx                                     # 00409233
    mov ecx, dword ptr [ebp - local_18]          # 00409234
    add ecx, 0x14c                               # 00409237
    call FUN_0051d58b                            # 0040923d
    jmp.d8 L_00409269                            # 00409242
L_00409244:
    # block 0x00409244: entered by jne at 0x00409209, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409269
    push 0xa                                     # 00409244
    lea edx, [ebp - local_14]                    # 00409246
    push edx                                     # 00409249
    movsx eax, word ptr [0x5ec2dc]               # 0040924a
    push eax                                     # 00409251
    call FUN_005193ca                            # 00409252
    add esp, 0xc                                 # 00409257
    push eax                                     # 0040925a
    mov ecx, dword ptr [ebp - local_18]          # 0040925b
    add ecx, 0x14c                               # 0040925e
    call FUN_0051d58b                            # 00409264
L_00409269:
    # block 0x00409269: entered by jmp at 0x00409242, 3 instruction(s), ends with jne to 0x004092b1 (forward)
    movsx ecx, word ptr [0x5ec2de]               # 00409269
    cmp ecx, 0x270f                              # 00409270
    jne.d8 L_004092b1                            # 00409276
    # block 0x00409278: entered by fall-through of jne at 0x00409276, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004092d6
    mov edi, 0x53eba0                            # 00409278
    lea edx, [ebp - local_14]                    # 0040927d
    or ecx, -0x1                                 # 00409280
    {load} xor eax, eax                          # 00409283
    repne scasb al, byte ptr es:[edi]            # 00409285
    not ecx                                      # 00409287
    {load} sub edi, ecx                          # 00409289
    {load} mov esi, edi                          # 0040928b
    {load} mov eax, ecx                          # 0040928d
    {load} mov edi, edx                          # 0040928f
    shr ecx, 0x2                                 # 00409291
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409294
    {load} mov ecx, eax                          # 00409296
    and ecx, 0x3                                 # 00409298
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040929b
    lea ecx, [ebp - local_14]                    # 0040929d
    push ecx                                     # 004092a0
    mov ecx, dword ptr [ebp - local_18]          # 004092a1
    add ecx, 0x18c                               # 004092a4
    call FUN_0051d58b                            # 004092aa
    jmp.d8 L_004092d6                            # 004092af
L_004092b1:
    # block 0x004092b1: entered by jne at 0x00409276, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004092d6
    push 0xa                                     # 004092b1
    lea edx, [ebp - local_14]                    # 004092b3
    push edx                                     # 004092b6
    movsx eax, word ptr [0x5ec2de]               # 004092b7
    push eax                                     # 004092be
    call FUN_005193ca                            # 004092bf
    add esp, 0xc                                 # 004092c4
    push eax                                     # 004092c7
    mov ecx, dword ptr [ebp - local_18]          # 004092c8
    add ecx, 0x18c                               # 004092cb
    call FUN_0051d58b                            # 004092d1
L_004092d6:
    # block 0x004092d6: entered by jmp at 0x004092af, 3 instruction(s), ends with jne to 0x0040931e (forward)
    movsx ecx, word ptr [0x5ec2e0]               # 004092d6
    cmp ecx, 0x270f                              # 004092dd
    jne.d8 L_0040931e                            # 004092e3
    # block 0x004092e5: entered by fall-through of jne at 0x004092e3, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409343
    mov edi, 0x53eba4                            # 004092e5
    lea edx, [ebp - local_14]                    # 004092ea
    or ecx, -0x1                                 # 004092ed
    {load} xor eax, eax                          # 004092f0
    repne scasb al, byte ptr es:[edi]            # 004092f2
    not ecx                                      # 004092f4
    {load} sub edi, ecx                          # 004092f6
    {load} mov esi, edi                          # 004092f8
    {load} mov eax, ecx                          # 004092fa
    {load} mov edi, edx                          # 004092fc
    shr ecx, 0x2                                 # 004092fe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409301
    {load} mov ecx, eax                          # 00409303
    and ecx, 0x3                                 # 00409305
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409308
    lea ecx, [ebp - local_14]                    # 0040930a
    push ecx                                     # 0040930d
    mov ecx, dword ptr [ebp - local_18]          # 0040930e
    add ecx, 0x1cc                               # 00409311
    call FUN_0051d58b                            # 00409317
    jmp.d8 L_00409343                            # 0040931c
L_0040931e:
    # block 0x0040931e: entered by jne at 0x004092e3, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409343
    push 0xa                                     # 0040931e
    lea edx, [ebp - local_14]                    # 00409320
    push edx                                     # 00409323
    movsx eax, word ptr [0x5ec2e0]               # 00409324
    push eax                                     # 0040932b
    call FUN_005193ca                            # 0040932c
    add esp, 0xc                                 # 00409331
    push eax                                     # 00409334
    mov ecx, dword ptr [ebp - local_18]          # 00409335
    add ecx, 0x1cc                               # 00409338
    call FUN_0051d58b                            # 0040933e
L_00409343:
    # block 0x00409343: entered by jmp at 0x0040931c, 3 instruction(s), ends with jne to 0x0040938b (forward)
    movsx ecx, word ptr [0x5ec2e2]               # 00409343
    cmp ecx, 0x270f                              # 0040934a
    jne.d8 L_0040938b                            # 00409350
    # block 0x00409352: entered by fall-through of jne at 0x00409350, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004093b0
    mov edi, 0x53eba8                            # 00409352
    lea edx, [ebp - local_14]                    # 00409357
    or ecx, -0x1                                 # 0040935a
    {load} xor eax, eax                          # 0040935d
    repne scasb al, byte ptr es:[edi]            # 0040935f
    not ecx                                      # 00409361
    {load} sub edi, ecx                          # 00409363
    {load} mov esi, edi                          # 00409365
    {load} mov eax, ecx                          # 00409367
    {load} mov edi, edx                          # 00409369
    shr ecx, 0x2                                 # 0040936b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040936e
    {load} mov ecx, eax                          # 00409370
    and ecx, 0x3                                 # 00409372
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409375
    lea ecx, [ebp - local_14]                    # 00409377
    push ecx                                     # 0040937a
    mov ecx, dword ptr [ebp - local_18]          # 0040937b
    add ecx, 0x20c                               # 0040937e
    call FUN_0051d58b                            # 00409384
    jmp.d8 L_004093b0                            # 00409389
L_0040938b:
    # block 0x0040938b: entered by jne at 0x00409350, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004093b0
    push 0xa                                     # 0040938b
    lea edx, [ebp - local_14]                    # 0040938d
    push edx                                     # 00409390
    movsx eax, word ptr [0x5ec2e2]               # 00409391
    push eax                                     # 00409398
    call FUN_005193ca                            # 00409399
    add esp, 0xc                                 # 0040939e
    push eax                                     # 004093a1
    mov ecx, dword ptr [ebp - local_18]          # 004093a2
    add ecx, 0x20c                               # 004093a5
    call FUN_0051d58b                            # 004093ab
L_004093b0:
    # block 0x004093b0: entered by jmp at 0x00409389, 3 instruction(s), ends with jne to 0x004093f8 (forward)
    movsx ecx, word ptr [0x5ec2e4]               # 004093b0
    cmp ecx, 0x270f                              # 004093b7
    jne.d8 L_004093f8                            # 004093bd
    # block 0x004093bf: entered by fall-through of jne at 0x004093bd, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040941d
    mov edi, 0x53ebac                            # 004093bf
    lea edx, [ebp - local_14]                    # 004093c4
    or ecx, -0x1                                 # 004093c7
    {load} xor eax, eax                          # 004093ca
    repne scasb al, byte ptr es:[edi]            # 004093cc
    not ecx                                      # 004093ce
    {load} sub edi, ecx                          # 004093d0
    {load} mov esi, edi                          # 004093d2
    {load} mov eax, ecx                          # 004093d4
    {load} mov edi, edx                          # 004093d6
    shr ecx, 0x2                                 # 004093d8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004093db
    {load} mov ecx, eax                          # 004093dd
    and ecx, 0x3                                 # 004093df
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004093e2
    lea ecx, [ebp - local_14]                    # 004093e4
    push ecx                                     # 004093e7
    mov ecx, dword ptr [ebp - local_18]          # 004093e8
    add ecx, 0x24c                               # 004093eb
    call FUN_0051d58b                            # 004093f1
    jmp.d8 L_0040941d                            # 004093f6
L_004093f8:
    # block 0x004093f8: entered by jne at 0x004093bd, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x0040941d
    push 0xa                                     # 004093f8
    lea edx, [ebp - local_14]                    # 004093fa
    push edx                                     # 004093fd
    movsx eax, word ptr [0x5ec2e4]               # 004093fe
    push eax                                     # 00409405
    call FUN_005193ca                            # 00409406
    add esp, 0xc                                 # 0040940b
    push eax                                     # 0040940e
    mov ecx, dword ptr [ebp - local_18]          # 0040940f
    add ecx, 0x24c                               # 00409412
    call FUN_0051d58b                            # 00409418
L_0040941d:
    # block 0x0040941d: entered by jmp at 0x004093f6, 3 instruction(s), ends with jne to 0x00409465 (forward)
    movsx ecx, word ptr [0x5ec2e6]               # 0040941d
    cmp ecx, 0x270f                              # 00409424
    jne.d8 L_00409465                            # 0040942a
    # block 0x0040942c: entered by fall-through of jne at 0x0040942a, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040948a
    mov edi, 0x53ebb0                            # 0040942c
    lea edx, [ebp - local_14]                    # 00409431
    or ecx, -0x1                                 # 00409434
    {load} xor eax, eax                          # 00409437
    repne scasb al, byte ptr es:[edi]            # 00409439
    not ecx                                      # 0040943b
    {load} sub edi, ecx                          # 0040943d
    {load} mov esi, edi                          # 0040943f
    {load} mov eax, ecx                          # 00409441
    {load} mov edi, edx                          # 00409443
    shr ecx, 0x2                                 # 00409445
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409448
    {load} mov ecx, eax                          # 0040944a
    and ecx, 0x3                                 # 0040944c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040944f
    lea ecx, [ebp - local_14]                    # 00409451
    push ecx                                     # 00409454
    mov ecx, dword ptr [ebp - local_18]          # 00409455
    add ecx, 0x28c                               # 00409458
    call FUN_0051d58b                            # 0040945e
    jmp.d8 L_0040948a                            # 00409463
L_00409465:
    # block 0x00409465: entered by jne at 0x0040942a, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x0040948a
    push 0xa                                     # 00409465
    lea edx, [ebp - local_14]                    # 00409467
    push edx                                     # 0040946a
    movsx eax, word ptr [0x5ec2e6]               # 0040946b
    push eax                                     # 00409472
    call FUN_005193ca                            # 00409473
    add esp, 0xc                                 # 00409478
    push eax                                     # 0040947b
    mov ecx, dword ptr [ebp - local_18]          # 0040947c
    add ecx, 0x28c                               # 0040947f
    call FUN_0051d58b                            # 00409485
L_0040948a:
    # block 0x0040948a: entered by jmp at 0x00409463, 3 instruction(s), ends with jne to 0x004094d2 (forward)
    movsx ecx, word ptr [0x5ec2e8]               # 0040948a
    cmp ecx, 0x270f                              # 00409491
    jne.d8 L_004094d2                            # 00409497
    # block 0x00409499: entered by fall-through of jne at 0x00409497, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004094f7
    mov edi, 0x53ebb4                            # 00409499
    lea edx, [ebp - local_14]                    # 0040949e
    or ecx, -0x1                                 # 004094a1
    {load} xor eax, eax                          # 004094a4
    repne scasb al, byte ptr es:[edi]            # 004094a6
    not ecx                                      # 004094a8
    {load} sub edi, ecx                          # 004094aa
    {load} mov esi, edi                          # 004094ac
    {load} mov eax, ecx                          # 004094ae
    {load} mov edi, edx                          # 004094b0
    shr ecx, 0x2                                 # 004094b2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004094b5
    {load} mov ecx, eax                          # 004094b7
    and ecx, 0x3                                 # 004094b9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004094bc
    lea ecx, [ebp - local_14]                    # 004094be
    push ecx                                     # 004094c1
    mov ecx, dword ptr [ebp - local_18]          # 004094c2
    add ecx, 0x2cc                               # 004094c5
    call FUN_0051d58b                            # 004094cb
    jmp.d8 L_004094f7                            # 004094d0
L_004094d2:
    # block 0x004094d2: entered by jne at 0x00409497, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004094f7
    push 0xa                                     # 004094d2
    lea edx, [ebp - local_14]                    # 004094d4
    push edx                                     # 004094d7
    movsx eax, word ptr [0x5ec2e8]               # 004094d8
    push eax                                     # 004094df
    call FUN_005193ca                            # 004094e0
    add esp, 0xc                                 # 004094e5
    push eax                                     # 004094e8
    mov ecx, dword ptr [ebp - local_18]          # 004094e9
    add ecx, 0x2cc                               # 004094ec
    call FUN_0051d58b                            # 004094f2
L_004094f7:
    # block 0x004094f7: entered by jmp at 0x004094d0, 3 instruction(s), ends with jne to 0x0040953f (forward)
    movsx ecx, word ptr [0x5ec2ea]               # 004094f7
    cmp ecx, 0x270f                              # 004094fe
    jne.d8 L_0040953f                            # 00409504
    # block 0x00409506: entered by fall-through of jne at 0x00409504, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409564
    mov edi, 0x53ebb8                            # 00409506
    lea edx, [ebp - local_14]                    # 0040950b
    or ecx, -0x1                                 # 0040950e
    {load} xor eax, eax                          # 00409511
    repne scasb al, byte ptr es:[edi]            # 00409513
    not ecx                                      # 00409515
    {load} sub edi, ecx                          # 00409517
    {load} mov esi, edi                          # 00409519
    {load} mov eax, ecx                          # 0040951b
    {load} mov edi, edx                          # 0040951d
    shr ecx, 0x2                                 # 0040951f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409522
    {load} mov ecx, eax                          # 00409524
    and ecx, 0x3                                 # 00409526
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409529
    lea ecx, [ebp - local_14]                    # 0040952b
    push ecx                                     # 0040952e
    mov ecx, dword ptr [ebp - local_18]          # 0040952f
    add ecx, 0x30c                               # 00409532
    call FUN_0051d58b                            # 00409538
    jmp.d8 L_00409564                            # 0040953d
L_0040953f:
    # block 0x0040953f: entered by jne at 0x00409504, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409564
    push 0xa                                     # 0040953f
    lea edx, [ebp - local_14]                    # 00409541
    push edx                                     # 00409544
    movsx eax, word ptr [0x5ec2ea]               # 00409545
    push eax                                     # 0040954c
    call FUN_005193ca                            # 0040954d
    add esp, 0xc                                 # 00409552
    push eax                                     # 00409555
    mov ecx, dword ptr [ebp - local_18]          # 00409556
    add ecx, 0x30c                               # 00409559
    call FUN_0051d58b                            # 0040955f
L_00409564:
    # block 0x00409564: entered by jmp at 0x0040953d, 3 instruction(s), ends with jne to 0x004095ac (forward)
    movsx ecx, word ptr [0x5ec2ec]               # 00409564
    cmp ecx, 0x270f                              # 0040956b
    jne.d8 L_004095ac                            # 00409571
    # block 0x00409573: entered by fall-through of jne at 0x00409571, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004095d1
    mov edi, 0x53ebbc                            # 00409573
    lea edx, [ebp - local_14]                    # 00409578
    or ecx, -0x1                                 # 0040957b
    {load} xor eax, eax                          # 0040957e
    repne scasb al, byte ptr es:[edi]            # 00409580
    not ecx                                      # 00409582
    {load} sub edi, ecx                          # 00409584
    {load} mov esi, edi                          # 00409586
    {load} mov eax, ecx                          # 00409588
    {load} mov edi, edx                          # 0040958a
    shr ecx, 0x2                                 # 0040958c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040958f
    {load} mov ecx, eax                          # 00409591
    and ecx, 0x3                                 # 00409593
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409596
    lea ecx, [ebp - local_14]                    # 00409598
    push ecx                                     # 0040959b
    mov ecx, dword ptr [ebp - local_18]          # 0040959c
    add ecx, 0x34c                               # 0040959f
    call FUN_0051d58b                            # 004095a5
    jmp.d8 L_004095d1                            # 004095aa
L_004095ac:
    # block 0x004095ac: entered by jne at 0x00409571, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004095d1
    push 0xa                                     # 004095ac
    lea edx, [ebp - local_14]                    # 004095ae
    push edx                                     # 004095b1
    movsx eax, word ptr [0x5ec2ec]               # 004095b2
    push eax                                     # 004095b9
    call FUN_005193ca                            # 004095ba
    add esp, 0xc                                 # 004095bf
    push eax                                     # 004095c2
    mov ecx, dword ptr [ebp - local_18]          # 004095c3
    add ecx, 0x34c                               # 004095c6
    call FUN_0051d58b                            # 004095cc
L_004095d1:
    # block 0x004095d1: entered by jmp at 0x004095aa, 3 instruction(s), ends with jne to 0x00409619 (forward)
    movsx ecx, word ptr [0x5ec2ee]               # 004095d1
    cmp ecx, 0x270f                              # 004095d8
    jne.d8 L_00409619                            # 004095de
    # block 0x004095e0: entered by fall-through of jne at 0x004095de, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040963e
    mov edi, 0x53ebc0                            # 004095e0
    lea edx, [ebp - local_14]                    # 004095e5
    or ecx, -0x1                                 # 004095e8
    {load} xor eax, eax                          # 004095eb
    repne scasb al, byte ptr es:[edi]            # 004095ed
    not ecx                                      # 004095ef
    {load} sub edi, ecx                          # 004095f1
    {load} mov esi, edi                          # 004095f3
    {load} mov eax, ecx                          # 004095f5
    {load} mov edi, edx                          # 004095f7
    shr ecx, 0x2                                 # 004095f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004095fc
    {load} mov ecx, eax                          # 004095fe
    and ecx, 0x3                                 # 00409600
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409603
    lea ecx, [ebp - local_14]                    # 00409605
    push ecx                                     # 00409608
    mov ecx, dword ptr [ebp - local_18]          # 00409609
    add ecx, 0x38c                               # 0040960c
    call FUN_0051d58b                            # 00409612
    jmp.d8 L_0040963e                            # 00409617
L_00409619:
    # block 0x00409619: entered by jne at 0x004095de, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x0040963e
    push 0xa                                     # 00409619
    lea edx, [ebp - local_14]                    # 0040961b
    push edx                                     # 0040961e
    movsx eax, word ptr [0x5ec2ee]               # 0040961f
    push eax                                     # 00409626
    call FUN_005193ca                            # 00409627
    add esp, 0xc                                 # 0040962c
    push eax                                     # 0040962f
    mov ecx, dword ptr [ebp - local_18]          # 00409630
    add ecx, 0x38c                               # 00409633
    call FUN_0051d58b                            # 00409639
L_0040963e:
    # block 0x0040963e: entered by jmp at 0x00409617, 3 instruction(s), ends with jne to 0x00409686 (forward)
    movsx ecx, word ptr [0x5ec2f0]               # 0040963e
    cmp ecx, 0x270f                              # 00409645
    jne.d8 L_00409686                            # 0040964b
    # block 0x0040964d: entered by fall-through of jne at 0x0040964b, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004096ab
    mov edi, 0x53ebc4                            # 0040964d
    lea edx, [ebp - local_14]                    # 00409652
    or ecx, -0x1                                 # 00409655
    {load} xor eax, eax                          # 00409658
    repne scasb al, byte ptr es:[edi]            # 0040965a
    not ecx                                      # 0040965c
    {load} sub edi, ecx                          # 0040965e
    {load} mov esi, edi                          # 00409660
    {load} mov eax, ecx                          # 00409662
    {load} mov edi, edx                          # 00409664
    shr ecx, 0x2                                 # 00409666
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409669
    {load} mov ecx, eax                          # 0040966b
    and ecx, 0x3                                 # 0040966d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409670
    lea ecx, [ebp - local_14]                    # 00409672
    push ecx                                     # 00409675
    mov ecx, dword ptr [ebp - local_18]          # 00409676
    add ecx, 0x3cc                               # 00409679
    call FUN_0051d58b                            # 0040967f
    jmp.d8 L_004096ab                            # 00409684
L_00409686:
    # block 0x00409686: entered by jne at 0x0040964b, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004096ab
    push 0xa                                     # 00409686
    lea edx, [ebp - local_14]                    # 00409688
    push edx                                     # 0040968b
    movsx eax, word ptr [0x5ec2f0]               # 0040968c
    push eax                                     # 00409693
    call FUN_005193ca                            # 00409694
    add esp, 0xc                                 # 00409699
    push eax                                     # 0040969c
    mov ecx, dword ptr [ebp - local_18]          # 0040969d
    add ecx, 0x3cc                               # 004096a0
    call FUN_0051d58b                            # 004096a6
L_004096ab:
    # block 0x004096ab: entered by jmp at 0x00409684, 3 instruction(s), ends with jne to 0x004096f3 (forward)
    movsx ecx, word ptr [0x5ec2f2]               # 004096ab
    cmp ecx, 0x270f                              # 004096b2
    jne.d8 L_004096f3                            # 004096b8
    # block 0x004096ba: entered by fall-through of jne at 0x004096b8, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409718
    mov edi, 0x53ebc8                            # 004096ba
    lea edx, [ebp - local_14]                    # 004096bf
    or ecx, -0x1                                 # 004096c2
    {load} xor eax, eax                          # 004096c5
    repne scasb al, byte ptr es:[edi]            # 004096c7
    not ecx                                      # 004096c9
    {load} sub edi, ecx                          # 004096cb
    {load} mov esi, edi                          # 004096cd
    {load} mov eax, ecx                          # 004096cf
    {load} mov edi, edx                          # 004096d1
    shr ecx, 0x2                                 # 004096d3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004096d6
    {load} mov ecx, eax                          # 004096d8
    and ecx, 0x3                                 # 004096da
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004096dd
    lea ecx, [ebp - local_14]                    # 004096df
    push ecx                                     # 004096e2
    mov ecx, dword ptr [ebp - local_18]          # 004096e3
    add ecx, 0x40c                               # 004096e6
    call FUN_0051d58b                            # 004096ec
    jmp.d8 L_00409718                            # 004096f1
L_004096f3:
    # block 0x004096f3: entered by jne at 0x004096b8, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409718
    push 0xa                                     # 004096f3
    lea edx, [ebp - local_14]                    # 004096f5
    push edx                                     # 004096f8
    movsx eax, word ptr [0x5ec2f2]               # 004096f9
    push eax                                     # 00409700
    call FUN_005193ca                            # 00409701
    add esp, 0xc                                 # 00409706
    push eax                                     # 00409709
    mov ecx, dword ptr [ebp - local_18]          # 0040970a
    add ecx, 0x40c                               # 0040970d
    call FUN_0051d58b                            # 00409713
L_00409718:
    # block 0x00409718: entered by jmp at 0x004096f1, 3 instruction(s), ends with jne to 0x00409760 (forward)
    movsx ecx, word ptr [0x5ec2f4]               # 00409718
    cmp ecx, 0x270f                              # 0040971f
    jne.d8 L_00409760                            # 00409725
    # block 0x00409727: entered by fall-through of jne at 0x00409725, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409785
    mov edi, 0x53ebcc                            # 00409727
    lea edx, [ebp - local_14]                    # 0040972c
    or ecx, -0x1                                 # 0040972f
    {load} xor eax, eax                          # 00409732
    repne scasb al, byte ptr es:[edi]            # 00409734
    not ecx                                      # 00409736
    {load} sub edi, ecx                          # 00409738
    {load} mov esi, edi                          # 0040973a
    {load} mov eax, ecx                          # 0040973c
    {load} mov edi, edx                          # 0040973e
    shr ecx, 0x2                                 # 00409740
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409743
    {load} mov ecx, eax                          # 00409745
    and ecx, 0x3                                 # 00409747
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040974a
    lea ecx, [ebp - local_14]                    # 0040974c
    push ecx                                     # 0040974f
    mov ecx, dword ptr [ebp - local_18]          # 00409750
    add ecx, 0x44c                               # 00409753
    call FUN_0051d58b                            # 00409759
    jmp.d8 L_00409785                            # 0040975e
L_00409760:
    # block 0x00409760: entered by jne at 0x00409725, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409785
    push 0xa                                     # 00409760
    lea edx, [ebp - local_14]                    # 00409762
    push edx                                     # 00409765
    movsx eax, word ptr [0x5ec2f4]               # 00409766
    push eax                                     # 0040976d
    call FUN_005193ca                            # 0040976e
    add esp, 0xc                                 # 00409773
    push eax                                     # 00409776
    mov ecx, dword ptr [ebp - local_18]          # 00409777
    add ecx, 0x44c                               # 0040977a
    call FUN_0051d58b                            # 00409780
L_00409785:
    # block 0x00409785: entered by jmp at 0x0040975e, 3 instruction(s), ends with jne to 0x004097cd (forward)
    movsx ecx, word ptr [0x5ec2f6]               # 00409785
    cmp ecx, 0x270f                              # 0040978c
    jne.d8 L_004097cd                            # 00409792
    # block 0x00409794: entered by fall-through of jne at 0x00409792, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004097f2
    mov edi, 0x53ebd0                            # 00409794
    lea edx, [ebp - local_14]                    # 00409799
    or ecx, -0x1                                 # 0040979c
    {load} xor eax, eax                          # 0040979f
    repne scasb al, byte ptr es:[edi]            # 004097a1
    not ecx                                      # 004097a3
    {load} sub edi, ecx                          # 004097a5
    {load} mov esi, edi                          # 004097a7
    {load} mov eax, ecx                          # 004097a9
    {load} mov edi, edx                          # 004097ab
    shr ecx, 0x2                                 # 004097ad
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004097b0
    {load} mov ecx, eax                          # 004097b2
    and ecx, 0x3                                 # 004097b4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004097b7
    lea ecx, [ebp - local_14]                    # 004097b9
    push ecx                                     # 004097bc
    mov ecx, dword ptr [ebp - local_18]          # 004097bd
    add ecx, 0x48c                               # 004097c0
    call FUN_0051d58b                            # 004097c6
    jmp.d8 L_004097f2                            # 004097cb
L_004097cd:
    # block 0x004097cd: entered by jne at 0x00409792, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004097f2
    push 0xa                                     # 004097cd
    lea edx, [ebp - local_14]                    # 004097cf
    push edx                                     # 004097d2
    movsx eax, word ptr [0x5ec2f6]               # 004097d3
    push eax                                     # 004097da
    call FUN_005193ca                            # 004097db
    add esp, 0xc                                 # 004097e0
    push eax                                     # 004097e3
    mov ecx, dword ptr [ebp - local_18]          # 004097e4
    add ecx, 0x48c                               # 004097e7
    call FUN_0051d58b                            # 004097ed
L_004097f2:
    # block 0x004097f2: entered by jmp at 0x004097cb, 3 instruction(s), ends with jne to 0x0040983a (forward)
    movsx ecx, word ptr [0x5ec2f8]               # 004097f2
    cmp ecx, 0x270f                              # 004097f9
    jne.d8 L_0040983a                            # 004097ff
    # block 0x00409801: entered by fall-through of jne at 0x004097ff, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040985f
    mov edi, 0x53ebd4                            # 00409801
    lea edx, [ebp - local_14]                    # 00409806
    or ecx, -0x1                                 # 00409809
    {load} xor eax, eax                          # 0040980c
    repne scasb al, byte ptr es:[edi]            # 0040980e
    not ecx                                      # 00409810
    {load} sub edi, ecx                          # 00409812
    {load} mov esi, edi                          # 00409814
    {load} mov eax, ecx                          # 00409816
    {load} mov edi, edx                          # 00409818
    shr ecx, 0x2                                 # 0040981a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040981d
    {load} mov ecx, eax                          # 0040981f
    and ecx, 0x3                                 # 00409821
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409824
    lea ecx, [ebp - local_14]                    # 00409826
    push ecx                                     # 00409829
    mov ecx, dword ptr [ebp - local_18]          # 0040982a
    add ecx, 0x4cc                               # 0040982d
    call FUN_0051d58b                            # 00409833
    jmp.d8 L_0040985f                            # 00409838
L_0040983a:
    # block 0x0040983a: entered by jne at 0x004097ff, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x0040985f
    push 0xa                                     # 0040983a
    lea edx, [ebp - local_14]                    # 0040983c
    push edx                                     # 0040983f
    movsx eax, word ptr [0x5ec2f8]               # 00409840
    push eax                                     # 00409847
    call FUN_005193ca                            # 00409848
    add esp, 0xc                                 # 0040984d
    push eax                                     # 00409850
    mov ecx, dword ptr [ebp - local_18]          # 00409851
    add ecx, 0x4cc                               # 00409854
    call FUN_0051d58b                            # 0040985a
L_0040985f:
    # block 0x0040985f: entered by jmp at 0x00409838, 3 instruction(s), ends with jne to 0x004098a7 (forward)
    movsx ecx, word ptr [0x5ec2fa]               # 0040985f
    cmp ecx, 0x270f                              # 00409866
    jne.d8 L_004098a7                            # 0040986c
    # block 0x0040986e: entered by fall-through of jne at 0x0040986c, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004098cc
    mov edi, 0x53ebd8                            # 0040986e
    lea edx, [ebp - local_14]                    # 00409873
    or ecx, -0x1                                 # 00409876
    {load} xor eax, eax                          # 00409879
    repne scasb al, byte ptr es:[edi]            # 0040987b
    not ecx                                      # 0040987d
    {load} sub edi, ecx                          # 0040987f
    {load} mov esi, edi                          # 00409881
    {load} mov eax, ecx                          # 00409883
    {load} mov edi, edx                          # 00409885
    shr ecx, 0x2                                 # 00409887
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040988a
    {load} mov ecx, eax                          # 0040988c
    and ecx, 0x3                                 # 0040988e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409891
    lea ecx, [ebp - local_14]                    # 00409893
    push ecx                                     # 00409896
    mov ecx, dword ptr [ebp - local_18]          # 00409897
    add ecx, 0x50c                               # 0040989a
    call FUN_0051d58b                            # 004098a0
    jmp.d8 L_004098cc                            # 004098a5
L_004098a7:
    # block 0x004098a7: entered by jne at 0x0040986c, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004098cc
    push 0xa                                     # 004098a7
    lea edx, [ebp - local_14]                    # 004098a9
    push edx                                     # 004098ac
    movsx eax, word ptr [0x5ec2fa]               # 004098ad
    push eax                                     # 004098b4
    call FUN_005193ca                            # 004098b5
    add esp, 0xc                                 # 004098ba
    push eax                                     # 004098bd
    mov ecx, dword ptr [ebp - local_18]          # 004098be
    add ecx, 0x50c                               # 004098c1
    call FUN_0051d58b                            # 004098c7
L_004098cc:
    # block 0x004098cc: entered by jmp at 0x004098a5, 3 instruction(s), ends with jne to 0x00409914 (forward)
    movsx ecx, word ptr [0x5ec2fc]               # 004098cc
    cmp ecx, 0x270f                              # 004098d3
    jne.d8 L_00409914                            # 004098d9
    # block 0x004098db: entered by fall-through of jne at 0x004098d9, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409939
    mov edi, 0x53ebdc                            # 004098db
    lea edx, [ebp - local_14]                    # 004098e0
    or ecx, -0x1                                 # 004098e3
    {load} xor eax, eax                          # 004098e6
    repne scasb al, byte ptr es:[edi]            # 004098e8
    not ecx                                      # 004098ea
    {load} sub edi, ecx                          # 004098ec
    {load} mov esi, edi                          # 004098ee
    {load} mov eax, ecx                          # 004098f0
    {load} mov edi, edx                          # 004098f2
    shr ecx, 0x2                                 # 004098f4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004098f7
    {load} mov ecx, eax                          # 004098f9
    and ecx, 0x3                                 # 004098fb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004098fe
    lea ecx, [ebp - local_14]                    # 00409900
    push ecx                                     # 00409903
    mov ecx, dword ptr [ebp - local_18]          # 00409904
    add ecx, 0x54c                               # 00409907
    call FUN_0051d58b                            # 0040990d
    jmp.d8 L_00409939                            # 00409912
L_00409914:
    # block 0x00409914: entered by jne at 0x004098d9, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409939
    push 0xa                                     # 00409914
    lea edx, [ebp - local_14]                    # 00409916
    push edx                                     # 00409919
    movsx eax, word ptr [0x5ec2fc]               # 0040991a
    push eax                                     # 00409921
    call FUN_005193ca                            # 00409922
    add esp, 0xc                                 # 00409927
    push eax                                     # 0040992a
    mov ecx, dword ptr [ebp - local_18]          # 0040992b
    add ecx, 0x54c                               # 0040992e
    call FUN_0051d58b                            # 00409934
L_00409939:
    # block 0x00409939: entered by jmp at 0x00409912, 3 instruction(s), ends with jne to 0x00409981 (forward)
    movsx ecx, word ptr [0x5ec2fe]               # 00409939
    cmp ecx, 0x270f                              # 00409940
    jne.d8 L_00409981                            # 00409946
    # block 0x00409948: entered by fall-through of jne at 0x00409946, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x004099a6
    mov edi, 0x53ebe0                            # 00409948
    lea edx, [ebp - local_14]                    # 0040994d
    or ecx, -0x1                                 # 00409950
    {load} xor eax, eax                          # 00409953
    repne scasb al, byte ptr es:[edi]            # 00409955
    not ecx                                      # 00409957
    {load} sub edi, ecx                          # 00409959
    {load} mov esi, edi                          # 0040995b
    {load} mov eax, ecx                          # 0040995d
    {load} mov edi, edx                          # 0040995f
    shr ecx, 0x2                                 # 00409961
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409964
    {load} mov ecx, eax                          # 00409966
    and ecx, 0x3                                 # 00409968
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040996b
    lea ecx, [ebp - local_14]                    # 0040996d
    push ecx                                     # 00409970
    mov ecx, dword ptr [ebp - local_18]          # 00409971
    add ecx, 0x58c                               # 00409974
    call FUN_0051d58b                            # 0040997a
    jmp.d8 L_004099a6                            # 0040997f
L_00409981:
    # block 0x00409981: entered by jne at 0x00409946, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x004099a6
    push 0xa                                     # 00409981
    lea edx, [ebp - local_14]                    # 00409983
    push edx                                     # 00409986
    movsx eax, word ptr [0x5ec2fe]               # 00409987
    push eax                                     # 0040998e
    call FUN_005193ca                            # 0040998f
    add esp, 0xc                                 # 00409994
    push eax                                     # 00409997
    mov ecx, dword ptr [ebp - local_18]          # 00409998
    add ecx, 0x58c                               # 0040999b
    call FUN_0051d58b                            # 004099a1
L_004099a6:
    # block 0x004099a6: entered by jmp at 0x0040997f, 3 instruction(s), ends with jne to 0x004099ee (forward)
    movsx ecx, word ptr [0x5ec300]               # 004099a6
    cmp ecx, 0x270f                              # 004099ad
    jne.d8 L_004099ee                            # 004099b3
    # block 0x004099b5: entered by fall-through of jne at 0x004099b3, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409a13
    mov edi, 0x53ebe4                            # 004099b5
    lea edx, [ebp - local_14]                    # 004099ba
    or ecx, -0x1                                 # 004099bd
    {load} xor eax, eax                          # 004099c0
    repne scasb al, byte ptr es:[edi]            # 004099c2
    not ecx                                      # 004099c4
    {load} sub edi, ecx                          # 004099c6
    {load} mov esi, edi                          # 004099c8
    {load} mov eax, ecx                          # 004099ca
    {load} mov edi, edx                          # 004099cc
    shr ecx, 0x2                                 # 004099ce
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004099d1
    {load} mov ecx, eax                          # 004099d3
    and ecx, 0x3                                 # 004099d5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004099d8
    lea ecx, [ebp - local_14]                    # 004099da
    push ecx                                     # 004099dd
    mov ecx, dword ptr [ebp - local_18]          # 004099de
    add ecx, 0x5cc                               # 004099e1
    call FUN_0051d58b                            # 004099e7
    jmp.d8 L_00409a13                            # 004099ec
L_004099ee:
    # block 0x004099ee: entered by jne at 0x004099b3, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409a13
    push 0xa                                     # 004099ee
    lea edx, [ebp - local_14]                    # 004099f0
    push edx                                     # 004099f3
    movsx eax, word ptr [0x5ec300]               # 004099f4
    push eax                                     # 004099fb
    call FUN_005193ca                            # 004099fc
    add esp, 0xc                                 # 00409a01
    push eax                                     # 00409a04
    mov ecx, dword ptr [ebp - local_18]          # 00409a05
    add ecx, 0x5cc                               # 00409a08
    call FUN_0051d58b                            # 00409a0e
L_00409a13:
    # block 0x00409a13: entered by jmp at 0x004099ec, 3 instruction(s), ends with jne to 0x00409a5b (forward)
    movsx ecx, word ptr [0x5ec302]               # 00409a13
    cmp ecx, 0x270f                              # 00409a1a
    jne.d8 L_00409a5b                            # 00409a20
    # block 0x00409a22: entered by fall-through of jne at 0x00409a20, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409a80
    mov edi, 0x53ebe8                            # 00409a22
    lea edx, [ebp - local_14]                    # 00409a27
    or ecx, -0x1                                 # 00409a2a
    {load} xor eax, eax                          # 00409a2d
    repne scasb al, byte ptr es:[edi]            # 00409a2f
    not ecx                                      # 00409a31
    {load} sub edi, ecx                          # 00409a33
    {load} mov esi, edi                          # 00409a35
    {load} mov eax, ecx                          # 00409a37
    {load} mov edi, edx                          # 00409a39
    shr ecx, 0x2                                 # 00409a3b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409a3e
    {load} mov ecx, eax                          # 00409a40
    and ecx, 0x3                                 # 00409a42
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409a45
    lea ecx, [ebp - local_14]                    # 00409a47
    push ecx                                     # 00409a4a
    mov ecx, dword ptr [ebp - local_18]          # 00409a4b
    add ecx, 0x60c                               # 00409a4e
    call FUN_0051d58b                            # 00409a54
    jmp.d8 L_00409a80                            # 00409a59
L_00409a5b:
    # block 0x00409a5b: entered by jne at 0x00409a20, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409a80
    push 0xa                                     # 00409a5b
    lea edx, [ebp - local_14]                    # 00409a5d
    push edx                                     # 00409a60
    movsx eax, word ptr [0x5ec302]               # 00409a61
    push eax                                     # 00409a68
    call FUN_005193ca                            # 00409a69
    add esp, 0xc                                 # 00409a6e
    push eax                                     # 00409a71
    mov ecx, dword ptr [ebp - local_18]          # 00409a72
    add ecx, 0x60c                               # 00409a75
    call FUN_0051d58b                            # 00409a7b
L_00409a80:
    # block 0x00409a80: entered by jmp at 0x00409a59, 3 instruction(s), ends with jne to 0x00409ac8 (forward)
    movsx ecx, word ptr [0x5ec304]               # 00409a80
    cmp ecx, 0x270f                              # 00409a87
    jne.d8 L_00409ac8                            # 00409a8d
    # block 0x00409a8f: entered by fall-through of jne at 0x00409a8d, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409aed
    mov edi, 0x53ebec                            # 00409a8f
    lea edx, [ebp - local_14]                    # 00409a94
    or ecx, -0x1                                 # 00409a97
    {load} xor eax, eax                          # 00409a9a
    repne scasb al, byte ptr es:[edi]            # 00409a9c
    not ecx                                      # 00409a9e
    {load} sub edi, ecx                          # 00409aa0
    {load} mov esi, edi                          # 00409aa2
    {load} mov eax, ecx                          # 00409aa4
    {load} mov edi, edx                          # 00409aa6
    shr ecx, 0x2                                 # 00409aa8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409aab
    {load} mov ecx, eax                          # 00409aad
    and ecx, 0x3                                 # 00409aaf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409ab2
    lea ecx, [ebp - local_14]                    # 00409ab4
    push ecx                                     # 00409ab7
    mov ecx, dword ptr [ebp - local_18]          # 00409ab8
    add ecx, 0x64c                               # 00409abb
    call FUN_0051d58b                            # 00409ac1
    jmp.d8 L_00409aed                            # 00409ac6
L_00409ac8:
    # block 0x00409ac8: entered by jne at 0x00409a8d, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409aed
    push 0xa                                     # 00409ac8
    lea edx, [ebp - local_14]                    # 00409aca
    push edx                                     # 00409acd
    movsx eax, word ptr [0x5ec304]               # 00409ace
    push eax                                     # 00409ad5
    call FUN_005193ca                            # 00409ad6
    add esp, 0xc                                 # 00409adb
    push eax                                     # 00409ade
    mov ecx, dword ptr [ebp - local_18]          # 00409adf
    add ecx, 0x64c                               # 00409ae2
    call FUN_0051d58b                            # 00409ae8
L_00409aed:
    # block 0x00409aed: entered by jmp at 0x00409ac6, 3 instruction(s), ends with jne to 0x00409b35 (forward)
    movsx ecx, word ptr [0x5ec306]               # 00409aed
    cmp ecx, 0x270f                              # 00409af4
    jne.d8 L_00409b35                            # 00409afa
    # block 0x00409afc: entered by fall-through of jne at 0x00409afa, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409b5a
    mov edi, 0x53ebf0                            # 00409afc
    lea edx, [ebp - local_14]                    # 00409b01
    or ecx, -0x1                                 # 00409b04
    {load} xor eax, eax                          # 00409b07
    repne scasb al, byte ptr es:[edi]            # 00409b09
    not ecx                                      # 00409b0b
    {load} sub edi, ecx                          # 00409b0d
    {load} mov esi, edi                          # 00409b0f
    {load} mov eax, ecx                          # 00409b11
    {load} mov edi, edx                          # 00409b13
    shr ecx, 0x2                                 # 00409b15
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409b18
    {load} mov ecx, eax                          # 00409b1a
    and ecx, 0x3                                 # 00409b1c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409b1f
    lea ecx, [ebp - local_14]                    # 00409b21
    push ecx                                     # 00409b24
    mov ecx, dword ptr [ebp - local_18]          # 00409b25
    add ecx, 0x68c                               # 00409b28
    call FUN_0051d58b                            # 00409b2e
    jmp.d8 L_00409b5a                            # 00409b33
L_00409b35:
    # block 0x00409b35: entered by jne at 0x00409afa, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409b5a
    push 0xa                                     # 00409b35
    lea edx, [ebp - local_14]                    # 00409b37
    push edx                                     # 00409b3a
    movsx eax, word ptr [0x5ec306]               # 00409b3b
    push eax                                     # 00409b42
    call FUN_005193ca                            # 00409b43
    add esp, 0xc                                 # 00409b48
    push eax                                     # 00409b4b
    mov ecx, dword ptr [ebp - local_18]          # 00409b4c
    add ecx, 0x68c                               # 00409b4f
    call FUN_0051d58b                            # 00409b55
L_00409b5a:
    # block 0x00409b5a: entered by jmp at 0x00409b33, 3 instruction(s), ends with jne to 0x00409ba2 (forward)
    movsx ecx, word ptr [0x5ec308]               # 00409b5a
    cmp ecx, 0x270f                              # 00409b61
    jne.d8 L_00409ba2                            # 00409b67
    # block 0x00409b69: entered by fall-through of jne at 0x00409b67, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409bc7
    mov edi, 0x53ebf4                            # 00409b69
    lea edx, [ebp - local_14]                    # 00409b6e
    or ecx, -0x1                                 # 00409b71
    {load} xor eax, eax                          # 00409b74
    repne scasb al, byte ptr es:[edi]            # 00409b76
    not ecx                                      # 00409b78
    {load} sub edi, ecx                          # 00409b7a
    {load} mov esi, edi                          # 00409b7c
    {load} mov eax, ecx                          # 00409b7e
    {load} mov edi, edx                          # 00409b80
    shr ecx, 0x2                                 # 00409b82
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409b85
    {load} mov ecx, eax                          # 00409b87
    and ecx, 0x3                                 # 00409b89
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409b8c
    lea ecx, [ebp - local_14]                    # 00409b8e
    push ecx                                     # 00409b91
    mov ecx, dword ptr [ebp - local_18]          # 00409b92
    add ecx, 0x6cc                               # 00409b95
    call FUN_0051d58b                            # 00409b9b
    jmp.d8 L_00409bc7                            # 00409ba0
L_00409ba2:
    # block 0x00409ba2: entered by jne at 0x00409b67, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409bc7
    push 0xa                                     # 00409ba2
    lea edx, [ebp - local_14]                    # 00409ba4
    push edx                                     # 00409ba7
    movsx eax, word ptr [0x5ec308]               # 00409ba8
    push eax                                     # 00409baf
    call FUN_005193ca                            # 00409bb0
    add esp, 0xc                                 # 00409bb5
    push eax                                     # 00409bb8
    mov ecx, dword ptr [ebp - local_18]          # 00409bb9
    add ecx, 0x6cc                               # 00409bbc
    call FUN_0051d58b                            # 00409bc2
L_00409bc7:
    # block 0x00409bc7: entered by jmp at 0x00409ba0, 3 instruction(s), ends with jne to 0x00409c0f (forward)
    movsx ecx, word ptr [0x5ec30a]               # 00409bc7
    cmp ecx, 0x270f                              # 00409bce
    jne.d8 L_00409c0f                            # 00409bd4
    # block 0x00409bd6: entered by fall-through of jne at 0x00409bd4, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409c34
    mov edi, 0x53ebf8                            # 00409bd6
    lea edx, [ebp - local_14]                    # 00409bdb
    or ecx, -0x1                                 # 00409bde
    {load} xor eax, eax                          # 00409be1
    repne scasb al, byte ptr es:[edi]            # 00409be3
    not ecx                                      # 00409be5
    {load} sub edi, ecx                          # 00409be7
    {load} mov esi, edi                          # 00409be9
    {load} mov eax, ecx                          # 00409beb
    {load} mov edi, edx                          # 00409bed
    shr ecx, 0x2                                 # 00409bef
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409bf2
    {load} mov ecx, eax                          # 00409bf4
    and ecx, 0x3                                 # 00409bf6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409bf9
    lea ecx, [ebp - local_14]                    # 00409bfb
    push ecx                                     # 00409bfe
    mov ecx, dword ptr [ebp - local_18]          # 00409bff
    add ecx, 0x70c                               # 00409c02
    call FUN_0051d58b                            # 00409c08
    jmp.d8 L_00409c34                            # 00409c0d
L_00409c0f:
    # block 0x00409c0f: entered by jne at 0x00409bd4, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409c34
    push 0xa                                     # 00409c0f
    lea edx, [ebp - local_14]                    # 00409c11
    push edx                                     # 00409c14
    movsx eax, word ptr [0x5ec30a]               # 00409c15
    push eax                                     # 00409c1c
    call FUN_005193ca                            # 00409c1d
    add esp, 0xc                                 # 00409c22
    push eax                                     # 00409c25
    mov ecx, dword ptr [ebp - local_18]          # 00409c26
    add ecx, 0x70c                               # 00409c29
    call FUN_0051d58b                            # 00409c2f
L_00409c34:
    # block 0x00409c34: entered by jmp at 0x00409c0d, 3 instruction(s), ends with jne to 0x00409c7c (forward)
    movsx ecx, word ptr [0x5ec30c]               # 00409c34
    cmp ecx, 0x270f                              # 00409c3b
    jne.d8 L_00409c7c                            # 00409c41
    # block 0x00409c43: entered by fall-through of jne at 0x00409c41, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409ca1
    mov edi, 0x53ebfc                            # 00409c43
    lea edx, [ebp - local_14]                    # 00409c48
    or ecx, -0x1                                 # 00409c4b
    {load} xor eax, eax                          # 00409c4e
    repne scasb al, byte ptr es:[edi]            # 00409c50
    not ecx                                      # 00409c52
    {load} sub edi, ecx                          # 00409c54
    {load} mov esi, edi                          # 00409c56
    {load} mov eax, ecx                          # 00409c58
    {load} mov edi, edx                          # 00409c5a
    shr ecx, 0x2                                 # 00409c5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409c5f
    {load} mov ecx, eax                          # 00409c61
    and ecx, 0x3                                 # 00409c63
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409c66
    lea ecx, [ebp - local_14]                    # 00409c68
    push ecx                                     # 00409c6b
    mov ecx, dword ptr [ebp - local_18]          # 00409c6c
    add ecx, 0x74c                               # 00409c6f
    call FUN_0051d58b                            # 00409c75
    jmp.d8 L_00409ca1                            # 00409c7a
L_00409c7c:
    # block 0x00409c7c: entered by jne at 0x00409c41, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409ca1
    push 0xa                                     # 00409c7c
    lea edx, [ebp - local_14]                    # 00409c7e
    push edx                                     # 00409c81
    movsx eax, word ptr [0x5ec30c]               # 00409c82
    push eax                                     # 00409c89
    call FUN_005193ca                            # 00409c8a
    add esp, 0xc                                 # 00409c8f
    push eax                                     # 00409c92
    mov ecx, dword ptr [ebp - local_18]          # 00409c93
    add ecx, 0x74c                               # 00409c96
    call FUN_0051d58b                            # 00409c9c
L_00409ca1:
    # block 0x00409ca1: entered by jmp at 0x00409c7a, 3 instruction(s), ends with jne to 0x00409ce9 (forward)
    movsx ecx, word ptr [0x5ec30e]               # 00409ca1
    cmp ecx, 0x270f                              # 00409ca8
    jne.d8 L_00409ce9                            # 00409cae
    # block 0x00409cb0: entered by fall-through of jne at 0x00409cae, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409d0e
    mov edi, 0x53ec00                            # 00409cb0
    lea edx, [ebp - local_14]                    # 00409cb5
    or ecx, -0x1                                 # 00409cb8
    {load} xor eax, eax                          # 00409cbb
    repne scasb al, byte ptr es:[edi]            # 00409cbd
    not ecx                                      # 00409cbf
    {load} sub edi, ecx                          # 00409cc1
    {load} mov esi, edi                          # 00409cc3
    {load} mov eax, ecx                          # 00409cc5
    {load} mov edi, edx                          # 00409cc7
    shr ecx, 0x2                                 # 00409cc9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409ccc
    {load} mov ecx, eax                          # 00409cce
    and ecx, 0x3                                 # 00409cd0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409cd3
    lea ecx, [ebp - local_14]                    # 00409cd5
    push ecx                                     # 00409cd8
    mov ecx, dword ptr [ebp - local_18]          # 00409cd9
    add ecx, 0x78c                               # 00409cdc
    call FUN_0051d58b                            # 00409ce2
    jmp.d8 L_00409d0e                            # 00409ce7
L_00409ce9:
    # block 0x00409ce9: entered by jne at 0x00409cae, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409d0e
    push 0xa                                     # 00409ce9
    lea edx, [ebp - local_14]                    # 00409ceb
    push edx                                     # 00409cee
    movsx eax, word ptr [0x5ec30e]               # 00409cef
    push eax                                     # 00409cf6
    call FUN_005193ca                            # 00409cf7
    add esp, 0xc                                 # 00409cfc
    push eax                                     # 00409cff
    mov ecx, dword ptr [ebp - local_18]          # 00409d00
    add ecx, 0x78c                               # 00409d03
    call FUN_0051d58b                            # 00409d09
L_00409d0e:
    # block 0x00409d0e: entered by jmp at 0x00409ce7, 3 instruction(s), ends with jne to 0x00409d56 (forward)
    movsx ecx, word ptr [0x5ec310]               # 00409d0e
    cmp ecx, 0x270f                              # 00409d15
    jne.d8 L_00409d56                            # 00409d1b
    # block 0x00409d1d: entered by fall-through of jne at 0x00409d1b, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409d7b
    mov edi, 0x53ec04                            # 00409d1d
    lea edx, [ebp - local_14]                    # 00409d22
    or ecx, -0x1                                 # 00409d25
    {load} xor eax, eax                          # 00409d28
    repne scasb al, byte ptr es:[edi]            # 00409d2a
    not ecx                                      # 00409d2c
    {load} sub edi, ecx                          # 00409d2e
    {load} mov esi, edi                          # 00409d30
    {load} mov eax, ecx                          # 00409d32
    {load} mov edi, edx                          # 00409d34
    shr ecx, 0x2                                 # 00409d36
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409d39
    {load} mov ecx, eax                          # 00409d3b
    and ecx, 0x3                                 # 00409d3d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409d40
    lea ecx, [ebp - local_14]                    # 00409d42
    push ecx                                     # 00409d45
    mov ecx, dword ptr [ebp - local_18]          # 00409d46
    add ecx, 0x7cc                               # 00409d49
    call FUN_0051d58b                            # 00409d4f
    jmp.d8 L_00409d7b                            # 00409d54
L_00409d56:
    # block 0x00409d56: entered by jne at 0x00409d1b, 11 instruction(s), calls FUN_005193ca, FUN_0051d58b, falls into the block at 0x00409d7b
    push 0xa                                     # 00409d56
    lea edx, [ebp - local_14]                    # 00409d58
    push edx                                     # 00409d5b
    movsx eax, word ptr [0x5ec310]               # 00409d5c
    push eax                                     # 00409d63
    call FUN_005193ca                            # 00409d64
    add esp, 0xc                                 # 00409d69
    push eax                                     # 00409d6c
    mov ecx, dword ptr [ebp - local_18]          # 00409d6d
    add ecx, 0x7cc                               # 00409d70
    call FUN_0051d58b                            # 00409d76
L_00409d7b:
    # block 0x00409d7b: entered by jmp at 0x00409d54, 2 instruction(s), ends with jne to 0x00409dc0 (forward)
    cmp dword ptr [0x5ec312], 0x461c3c00         # 00409d7b
    jne.d8 L_00409dc0                            # 00409d85
    # block 0x00409d87: entered by fall-through of jne at 0x00409d85, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409def
    mov edi, 0x53ec08                            # 00409d87
    lea edx, [ebp - local_14]                    # 00409d8c
    or ecx, -0x1                                 # 00409d8f
    {load} xor eax, eax                          # 00409d92
    repne scasb al, byte ptr es:[edi]            # 00409d94
    not ecx                                      # 00409d96
    {load} sub edi, ecx                          # 00409d98
    {load} mov esi, edi                          # 00409d9a
    {load} mov eax, ecx                          # 00409d9c
    {load} mov edi, edx                          # 00409d9e
    shr ecx, 0x2                                 # 00409da0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409da3
    {load} mov ecx, eax                          # 00409da5
    and ecx, 0x3                                 # 00409da7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409daa
    lea ecx, [ebp - local_14]                    # 00409dac
    push ecx                                     # 00409daf
    mov ecx, dword ptr [ebp - local_18]          # 00409db0
    add ecx, 0x80c                               # 00409db3
    call FUN_0051d58b                            # 00409db9
    jmp.d8 L_00409def                            # 00409dbe
L_00409dc0:
    # block 0x00409dc0: entered by jne at 0x00409d85, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x00409def
    fld dword ptr [0x5ec312]                     # 00409dc0
    sub esp, 0x8                                 # 00409dc6
    fstp qword ptr [esp]                         # 00409dc9
    push 0x53ec0c                                # 00409dcc
    lea edx, [ebp - local_14]                    # 00409dd1
    push edx                                     # 00409dd4
    call FUN_0050ca3e                            # 00409dd5
    add esp, 0x10                                # 00409dda
    lea eax, [ebp - local_14]                    # 00409ddd
    push eax                                     # 00409de0
    mov ecx, dword ptr [ebp - local_18]          # 00409de1
    add ecx, 0x80c                               # 00409de4
    call FUN_0051d58b                            # 00409dea
L_00409def:
    # block 0x00409def: entered by jmp at 0x00409dbe, 2 instruction(s), ends with jne to 0x00409e34 (forward)
    cmp dword ptr [0x5ec316], 0x461c3c00         # 00409def
    jne.d8 L_00409e34                            # 00409df9
    # block 0x00409dfb: entered by fall-through of jne at 0x00409df9, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409e63
    mov edi, 0x53ec10                            # 00409dfb
    lea edx, [ebp - local_14]                    # 00409e00
    or ecx, -0x1                                 # 00409e03
    {load} xor eax, eax                          # 00409e06
    repne scasb al, byte ptr es:[edi]            # 00409e08
    not ecx                                      # 00409e0a
    {load} sub edi, ecx                          # 00409e0c
    {load} mov esi, edi                          # 00409e0e
    {load} mov eax, ecx                          # 00409e10
    {load} mov edi, edx                          # 00409e12
    shr ecx, 0x2                                 # 00409e14
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409e17
    {load} mov ecx, eax                          # 00409e19
    and ecx, 0x3                                 # 00409e1b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409e1e
    lea ecx, [ebp - local_14]                    # 00409e20
    push ecx                                     # 00409e23
    mov ecx, dword ptr [ebp - local_18]          # 00409e24
    add ecx, 0x84c                               # 00409e27
    call FUN_0051d58b                            # 00409e2d
    jmp.d8 L_00409e63                            # 00409e32
L_00409e34:
    # block 0x00409e34: entered by jne at 0x00409df9, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x00409e63
    fld dword ptr [0x5ec316]                     # 00409e34
    sub esp, 0x8                                 # 00409e3a
    fstp qword ptr [esp]                         # 00409e3d
    push 0x53ec14                                # 00409e40
    lea edx, [ebp - local_14]                    # 00409e45
    push edx                                     # 00409e48
    call FUN_0050ca3e                            # 00409e49
    add esp, 0x10                                # 00409e4e
    lea eax, [ebp - local_14]                    # 00409e51
    push eax                                     # 00409e54
    mov ecx, dword ptr [ebp - local_18]          # 00409e55
    add ecx, 0x84c                               # 00409e58
    call FUN_0051d58b                            # 00409e5e
L_00409e63:
    # block 0x00409e63: entered by jmp at 0x00409e32, 2 instruction(s), ends with jne to 0x00409ea8 (forward)
    cmp dword ptr [0x5ec31a], 0x461c3c00         # 00409e63
    jne.d8 L_00409ea8                            # 00409e6d
    # block 0x00409e6f: entered by fall-through of jne at 0x00409e6d, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409ed7
    mov edi, 0x53ec18                            # 00409e6f
    lea edx, [ebp - local_14]                    # 00409e74
    or ecx, -0x1                                 # 00409e77
    {load} xor eax, eax                          # 00409e7a
    repne scasb al, byte ptr es:[edi]            # 00409e7c
    not ecx                                      # 00409e7e
    {load} sub edi, ecx                          # 00409e80
    {load} mov esi, edi                          # 00409e82
    {load} mov eax, ecx                          # 00409e84
    {load} mov edi, edx                          # 00409e86
    shr ecx, 0x2                                 # 00409e88
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409e8b
    {load} mov ecx, eax                          # 00409e8d
    and ecx, 0x3                                 # 00409e8f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409e92
    lea ecx, [ebp - local_14]                    # 00409e94
    push ecx                                     # 00409e97
    mov ecx, dword ptr [ebp - local_18]          # 00409e98
    add ecx, 0x88c                               # 00409e9b
    call FUN_0051d58b                            # 00409ea1
    jmp.d8 L_00409ed7                            # 00409ea6
L_00409ea8:
    # block 0x00409ea8: entered by jne at 0x00409e6d, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x00409ed7
    fld dword ptr [0x5ec31a]                     # 00409ea8
    sub esp, 0x8                                 # 00409eae
    fstp qword ptr [esp]                         # 00409eb1
    push 0x53ec1c                                # 00409eb4
    lea edx, [ebp - local_14]                    # 00409eb9
    push edx                                     # 00409ebc
    call FUN_0050ca3e                            # 00409ebd
    add esp, 0x10                                # 00409ec2
    lea eax, [ebp - local_14]                    # 00409ec5
    push eax                                     # 00409ec8
    mov ecx, dword ptr [ebp - local_18]          # 00409ec9
    add ecx, 0x88c                               # 00409ecc
    call FUN_0051d58b                            # 00409ed2
L_00409ed7:
    # block 0x00409ed7: entered by jmp at 0x00409ea6, 2 instruction(s), ends with jne to 0x00409f1c (forward)
    cmp dword ptr [0x5ec31e], 0x461c3c00         # 00409ed7
    jne.d8 L_00409f1c                            # 00409ee1
    # block 0x00409ee3: entered by fall-through of jne at 0x00409ee1, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409f4b
    mov edi, 0x53ec20                            # 00409ee3
    lea edx, [ebp - local_14]                    # 00409ee8
    or ecx, -0x1                                 # 00409eeb
    {load} xor eax, eax                          # 00409eee
    repne scasb al, byte ptr es:[edi]            # 00409ef0
    not ecx                                      # 00409ef2
    {load} sub edi, ecx                          # 00409ef4
    {load} mov esi, edi                          # 00409ef6
    {load} mov eax, ecx                          # 00409ef8
    {load} mov edi, edx                          # 00409efa
    shr ecx, 0x2                                 # 00409efc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409eff
    {load} mov ecx, eax                          # 00409f01
    and ecx, 0x3                                 # 00409f03
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409f06
    lea ecx, [ebp - local_14]                    # 00409f08
    push ecx                                     # 00409f0b
    mov ecx, dword ptr [ebp - local_18]          # 00409f0c
    add ecx, 0x8cc                               # 00409f0f
    call FUN_0051d58b                            # 00409f15
    jmp.d8 L_00409f4b                            # 00409f1a
L_00409f1c:
    # block 0x00409f1c: entered by jne at 0x00409ee1, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x00409f4b
    fld dword ptr [0x5ec31e]                     # 00409f1c
    sub esp, 0x8                                 # 00409f22
    fstp qword ptr [esp]                         # 00409f25
    push 0x53ec24                                # 00409f28
    lea edx, [ebp - local_14]                    # 00409f2d
    push edx                                     # 00409f30
    call FUN_0050ca3e                            # 00409f31
    add esp, 0x10                                # 00409f36
    lea eax, [ebp - local_14]                    # 00409f39
    push eax                                     # 00409f3c
    mov ecx, dword ptr [ebp - local_18]          # 00409f3d
    add ecx, 0x8cc                               # 00409f40
    call FUN_0051d58b                            # 00409f46
L_00409f4b:
    # block 0x00409f4b: entered by jmp at 0x00409f1a, 2 instruction(s), ends with jne to 0x00409f90 (forward)
    cmp dword ptr [0x5ec322], 0x461c3c00         # 00409f4b
    jne.d8 L_00409f90                            # 00409f55
    # block 0x00409f57: entered by fall-through of jne at 0x00409f55, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x00409fbf
    mov edi, 0x53ec28                            # 00409f57
    lea edx, [ebp - local_14]                    # 00409f5c
    or ecx, -0x1                                 # 00409f5f
    {load} xor eax, eax                          # 00409f62
    repne scasb al, byte ptr es:[edi]            # 00409f64
    not ecx                                      # 00409f66
    {load} sub edi, ecx                          # 00409f68
    {load} mov esi, edi                          # 00409f6a
    {load} mov eax, ecx                          # 00409f6c
    {load} mov edi, edx                          # 00409f6e
    shr ecx, 0x2                                 # 00409f70
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409f73
    {load} mov ecx, eax                          # 00409f75
    and ecx, 0x3                                 # 00409f77
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409f7a
    lea ecx, [ebp - local_14]                    # 00409f7c
    push ecx                                     # 00409f7f
    mov ecx, dword ptr [ebp - local_18]          # 00409f80
    add ecx, 0x90c                               # 00409f83
    call FUN_0051d58b                            # 00409f89
    jmp.d8 L_00409fbf                            # 00409f8e
L_00409f90:
    # block 0x00409f90: entered by jne at 0x00409f55, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x00409fbf
    fld dword ptr [0x5ec322]                     # 00409f90
    sub esp, 0x8                                 # 00409f96
    fstp qword ptr [esp]                         # 00409f99
    push 0x53ec2c                                # 00409f9c
    lea edx, [ebp - local_14]                    # 00409fa1
    push edx                                     # 00409fa4
    call FUN_0050ca3e                            # 00409fa5
    add esp, 0x10                                # 00409faa
    lea eax, [ebp - local_14]                    # 00409fad
    push eax                                     # 00409fb0
    mov ecx, dword ptr [ebp - local_18]          # 00409fb1
    add ecx, 0x90c                               # 00409fb4
    call FUN_0051d58b                            # 00409fba
L_00409fbf:
    # block 0x00409fbf: entered by jmp at 0x00409f8e, 2 instruction(s), ends with jne to 0x0040a004 (forward)
    cmp dword ptr [0x5ec326], 0x461c3c00         # 00409fbf
    jne.d8 L_0040a004                            # 00409fc9
    # block 0x00409fcb: entered by fall-through of jne at 0x00409fc9, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040a033
    mov edi, 0x53ec30                            # 00409fcb
    lea edx, [ebp - local_14]                    # 00409fd0
    or ecx, -0x1                                 # 00409fd3
    {load} xor eax, eax                          # 00409fd6
    repne scasb al, byte ptr es:[edi]            # 00409fd8
    not ecx                                      # 00409fda
    {load} sub edi, ecx                          # 00409fdc
    {load} mov esi, edi                          # 00409fde
    {load} mov eax, ecx                          # 00409fe0
    {load} mov edi, edx                          # 00409fe2
    shr ecx, 0x2                                 # 00409fe4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00409fe7
    {load} mov ecx, eax                          # 00409fe9
    and ecx, 0x3                                 # 00409feb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00409fee
    lea ecx, [ebp - local_14]                    # 00409ff0
    push ecx                                     # 00409ff3
    mov ecx, dword ptr [ebp - local_18]          # 00409ff4
    add ecx, 0x94c                               # 00409ff7
    call FUN_0051d58b                            # 00409ffd
    jmp.d8 L_0040a033                            # 0040a002
L_0040a004:
    # block 0x0040a004: entered by jne at 0x00409fc9, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x0040a033
    fld dword ptr [0x5ec326]                     # 0040a004
    sub esp, 0x8                                 # 0040a00a
    fstp qword ptr [esp]                         # 0040a00d
    push 0x53ec34                                # 0040a010
    lea edx, [ebp - local_14]                    # 0040a015
    push edx                                     # 0040a018
    call FUN_0050ca3e                            # 0040a019
    add esp, 0x10                                # 0040a01e
    lea eax, [ebp - local_14]                    # 0040a021
    push eax                                     # 0040a024
    mov ecx, dword ptr [ebp - local_18]          # 0040a025
    add ecx, 0x94c                               # 0040a028
    call FUN_0051d58b                            # 0040a02e
L_0040a033:
    # block 0x0040a033: entered by jmp at 0x0040a002, 2 instruction(s), ends with jne to 0x0040a078 (forward)
    cmp dword ptr [0x5ec32a], 0x461c3c00         # 0040a033
    jne.d8 L_0040a078                            # 0040a03d
    # block 0x0040a03f: entered by fall-through of jne at 0x0040a03d, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040a0a7
    mov edi, 0x53ec38                            # 0040a03f
    lea edx, [ebp - local_14]                    # 0040a044
    or ecx, -0x1                                 # 0040a047
    {load} xor eax, eax                          # 0040a04a
    repne scasb al, byte ptr es:[edi]            # 0040a04c
    not ecx                                      # 0040a04e
    {load} sub edi, ecx                          # 0040a050
    {load} mov esi, edi                          # 0040a052
    {load} mov eax, ecx                          # 0040a054
    {load} mov edi, edx                          # 0040a056
    shr ecx, 0x2                                 # 0040a058
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040a05b
    {load} mov ecx, eax                          # 0040a05d
    and ecx, 0x3                                 # 0040a05f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040a062
    lea ecx, [ebp - local_14]                    # 0040a064
    push ecx                                     # 0040a067
    mov ecx, dword ptr [ebp - local_18]          # 0040a068
    add ecx, 0x98c                               # 0040a06b
    call FUN_0051d58b                            # 0040a071
    jmp.d8 L_0040a0a7                            # 0040a076
L_0040a078:
    # block 0x0040a078: entered by jne at 0x0040a03d, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x0040a0a7
    fld dword ptr [0x5ec32a]                     # 0040a078
    sub esp, 0x8                                 # 0040a07e
    fstp qword ptr [esp]                         # 0040a081
    push 0x53ec3c                                # 0040a084
    lea edx, [ebp - local_14]                    # 0040a089
    push edx                                     # 0040a08c
    call FUN_0050ca3e                            # 0040a08d
    add esp, 0x10                                # 0040a092
    lea eax, [ebp - local_14]                    # 0040a095
    push eax                                     # 0040a098
    mov ecx, dword ptr [ebp - local_18]          # 0040a099
    add ecx, 0x98c                               # 0040a09c
    call FUN_0051d58b                            # 0040a0a2
L_0040a0a7:
    # block 0x0040a0a7: entered by jmp at 0x0040a076, 2 instruction(s), ends with jne to 0x0040a0ec (forward)
    cmp dword ptr [0x5ec32e], 0x461c3c00         # 0040a0a7
    jne.d8 L_0040a0ec                            # 0040a0b1
    # block 0x0040a0b3: entered by fall-through of jne at 0x0040a0b1, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040a11b
    mov edi, 0x53ec40                            # 0040a0b3
    lea edx, [ebp - local_14]                    # 0040a0b8
    or ecx, -0x1                                 # 0040a0bb
    {load} xor eax, eax                          # 0040a0be
    repne scasb al, byte ptr es:[edi]            # 0040a0c0
    not ecx                                      # 0040a0c2
    {load} sub edi, ecx                          # 0040a0c4
    {load} mov esi, edi                          # 0040a0c6
    {load} mov eax, ecx                          # 0040a0c8
    {load} mov edi, edx                          # 0040a0ca
    shr ecx, 0x2                                 # 0040a0cc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040a0cf
    {load} mov ecx, eax                          # 0040a0d1
    and ecx, 0x3                                 # 0040a0d3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040a0d6
    lea ecx, [ebp - local_14]                    # 0040a0d8
    push ecx                                     # 0040a0db
    mov ecx, dword ptr [ebp - local_18]          # 0040a0dc
    add ecx, 0x9cc                               # 0040a0df
    call FUN_0051d58b                            # 0040a0e5
    jmp.d8 L_0040a11b                            # 0040a0ea
L_0040a0ec:
    # block 0x0040a0ec: entered by jne at 0x0040a0b1, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x0040a11b
    fld dword ptr [0x5ec32e]                     # 0040a0ec
    sub esp, 0x8                                 # 0040a0f2
    fstp qword ptr [esp]                         # 0040a0f5
    push 0x53ec44                                # 0040a0f8
    lea edx, [ebp - local_14]                    # 0040a0fd
    push edx                                     # 0040a100
    call FUN_0050ca3e                            # 0040a101
    add esp, 0x10                                # 0040a106
    lea eax, [ebp - local_14]                    # 0040a109
    push eax                                     # 0040a10c
    mov ecx, dword ptr [ebp - local_18]          # 0040a10d
    add ecx, 0x9cc                               # 0040a110
    call FUN_0051d58b                            # 0040a116
L_0040a11b:
    # block 0x0040a11b: entered by jmp at 0x0040a0ea, 2 instruction(s), ends with jne to 0x0040a160 (forward)
    cmp dword ptr [0x5ec332], 0x461c3c00         # 0040a11b
    jne.d8 L_0040a160                            # 0040a125
    # block 0x0040a127: entered by fall-through of jne at 0x0040a125, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040a18f
    mov edi, 0x53ec48                            # 0040a127
    lea edx, [ebp - local_14]                    # 0040a12c
    or ecx, -0x1                                 # 0040a12f
    {load} xor eax, eax                          # 0040a132
    repne scasb al, byte ptr es:[edi]            # 0040a134
    not ecx                                      # 0040a136
    {load} sub edi, ecx                          # 0040a138
    {load} mov esi, edi                          # 0040a13a
    {load} mov eax, ecx                          # 0040a13c
    {load} mov edi, edx                          # 0040a13e
    shr ecx, 0x2                                 # 0040a140
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040a143
    {load} mov ecx, eax                          # 0040a145
    and ecx, 0x3                                 # 0040a147
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040a14a
    lea ecx, [ebp - local_14]                    # 0040a14c
    push ecx                                     # 0040a14f
    mov ecx, dword ptr [ebp - local_18]          # 0040a150
    add ecx, 0xa0c                               # 0040a153
    call FUN_0051d58b                            # 0040a159
    jmp.d8 L_0040a18f                            # 0040a15e
L_0040a160:
    # block 0x0040a160: entered by jne at 0x0040a125, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x0040a18f
    fld dword ptr [0x5ec332]                     # 0040a160
    sub esp, 0x8                                 # 0040a166
    fstp qword ptr [esp]                         # 0040a169
    push 0x53ec4c                                # 0040a16c
    lea edx, [ebp - local_14]                    # 0040a171
    push edx                                     # 0040a174
    call FUN_0050ca3e                            # 0040a175
    add esp, 0x10                                # 0040a17a
    lea eax, [ebp - local_14]                    # 0040a17d
    push eax                                     # 0040a180
    mov ecx, dword ptr [ebp - local_18]          # 0040a181
    add ecx, 0xa0c                               # 0040a184
    call FUN_0051d58b                            # 0040a18a
L_0040a18f:
    # block 0x0040a18f: entered by jmp at 0x0040a15e, 2 instruction(s), ends with jne to 0x0040a1d4 (forward)
    cmp dword ptr [0x5ec336], 0x461c3c00         # 0040a18f
    jne.d8 L_0040a1d4                            # 0040a199
    # block 0x0040a19b: entered by fall-through of jne at 0x0040a199, 21 instruction(s), calls FUN_0051d58b, ends with forward jump to 0x0040a203
    mov edi, 0x53ec50                            # 0040a19b
    lea edx, [ebp - local_14]                    # 0040a1a0
    or ecx, -0x1                                 # 0040a1a3
    {load} xor eax, eax                          # 0040a1a6
    repne scasb al, byte ptr es:[edi]            # 0040a1a8
    not ecx                                      # 0040a1aa
    {load} sub edi, ecx                          # 0040a1ac
    {load} mov esi, edi                          # 0040a1ae
    {load} mov eax, ecx                          # 0040a1b0
    {load} mov edi, edx                          # 0040a1b2
    shr ecx, 0x2                                 # 0040a1b4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0040a1b7
    {load} mov ecx, eax                          # 0040a1b9
    and ecx, 0x3                                 # 0040a1bb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0040a1be
    lea ecx, [ebp - local_14]                    # 0040a1c0
    push ecx                                     # 0040a1c3
    mov ecx, dword ptr [ebp - local_18]          # 0040a1c4
    add ecx, 0xa4c                               # 0040a1c7
    call FUN_0051d58b                            # 0040a1cd
    jmp.d8 L_0040a203                            # 0040a1d2
L_0040a1d4:
    # block 0x0040a1d4: entered by jne at 0x0040a199, 13 instruction(s), calls FUN_0050ca3e, FUN_0051d58b, falls into the block at 0x0040a203
    fld dword ptr [0x5ec336]                     # 0040a1d4
    sub esp, 0x8                                 # 0040a1da
    fstp qword ptr [esp]                         # 0040a1dd
    push 0x53ec54                                # 0040a1e0
    lea edx, [ebp - local_14]                    # 0040a1e5
    push edx                                     # 0040a1e8
    call FUN_0050ca3e                            # 0040a1e9
    add esp, 0x10                                # 0040a1ee
    lea eax, [ebp - local_14]                    # 0040a1f1
    push eax                                     # 0040a1f4
    mov ecx, dword ptr [ebp - local_18]          # 0040a1f5
    add ecx, 0xa4c                               # 0040a1f8
    call FUN_0051d58b                            # 0040a1fe
L_0040a203:
    # block 0x0040a203: entered by jmp at 0x0040a1d2, 5 instruction(s), ends with ret
    pop edi                                      # 0040a203
    pop esi                                      # 0040a204
    {load} mov esp, ebp                          # 0040a205
    pop ebp                                      # 0040a207
    ret                                          # 0040a208

