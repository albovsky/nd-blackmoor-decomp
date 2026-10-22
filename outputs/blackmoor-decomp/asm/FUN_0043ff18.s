# FUN_0043ff18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ff18
# extent:       0x0043ff18-0x00440dfc (3812 code bytes)
# span:         0x0043ff18-0x00440dfc (code 3812, tables 0, padding 0)
# sha256:       7ad65087481542ef80cfaef2b87ef47f54858efce2296fb666a2fc03c750c369
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ff18
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 890 instruction(s), 55 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_3e, 0x3e  # offset -0x3e
.equ local_1ce, 0x1ce  # offset -0x1ce
.equ local_1d4, 0x1d4  # offset -0x1d4

# --- external targets -----------------------------------------------
.set FUN_0041fa11, .text + (0x0041fa11 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)

.org 0x0043ff18 - 0x401000
.globl FUN_0043ff18
FUN_0043ff18:
    # block 0x0043ff18: entry, 7 instruction(s), ends with jne to 0x0043ffc9 (forward)
    push ebp                                     # 0043ff18
    {load} mov ebp, esp                          # 0043ff19
    sub esp, 0x1d4                               # 0043ff1b
    push esi                                     # 0043ff21
    push edi                                     # 0043ff22
    cmp dword ptr [0x583c29], 0x1                # 0043ff23
    jne.d32 L_0043ffc9                           # 0043ff2a
    # block 0x0043ff30: entered by fall-through of jne at 0x0043ff2a, 2 instruction(s), ends with jne to 0x0043ffc9 (forward)
    cmp dword ptr [0x586d59], 0x0                # 0043ff30
    jne.d32 L_0043ffc9                           # 0043ff37
    # block 0x0043ff3d: entered by fall-through of jne at 0x0043ff37, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0043ffc9
    push 0x5479e8                                # 0043ff3d
    push 0x63a638                                # 0043ff42
    lea eax, [ebp - local_1ce]                   # 0043ff47
    push eax                                     # 0043ff4d
    call FUN_0043f210                            # 0043ff4e
    add esp, 0xc                                 # 0043ff53
    mov edi, 0x5479f0                            # 0043ff56
    lea edx, [ebp - local_3e]                    # 0043ff5b
    or ecx, -0x1                                 # 0043ff5e
    {load} xor eax, eax                          # 0043ff61
    repne scasb al, byte ptr es:[edi]            # 0043ff63
    not ecx                                      # 0043ff65
    {load} sub edi, ecx                          # 0043ff67
    {load} mov esi, edi                          # 0043ff69
    {load} mov eax, ecx                          # 0043ff6b
    {load} mov edi, edx                          # 0043ff6d
    shr ecx, 0x2                                 # 0043ff6f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043ff72
    {load} mov ecx, eax                          # 0043ff74
    and ecx, 0x3                                 # 0043ff76
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043ff79
    mov word ptr [ebp - local_1c], 0x4dd         # 0043ff7b
    mov word ptr [ebp - local_1a], 0x0           # 0043ff81
    mov word ptr [ebp - local_18], 0x0           # 0043ff87
    mov word ptr [ebp - local_16], 0x1           # 0043ff8d
    mov word ptr [ebp - local_8], 0xffff         # 0043ff93
    mov byte ptr [ebp - local_6], 0x0            # 0043ff99
    mov word ptr [ebp - local_5], 0x2            # 0043ff9d
    mov dword ptr [ebp - local_14], 0x0          # 0043ffa3
    mov dword ptr [ebp - local_10], 0x0          # 0043ffaa
    mov dword ptr [ebp - local_c], 0x1           # 0043ffb1
    lea ecx, [ebp - local_1d4]                   # 0043ffb8
    push ecx                                     # 0043ffbe
    mov ecx, 0x6177e8                            # 0043ffbf
    call FUN_0041fa11                            # 0043ffc4
L_0043ffc9:
    # block 0x0043ffc9: entered by jne at 0x0043ff2a; jne at 0x0043ff37, 2 instruction(s), ends with jne to 0x0044006f (forward)
    cmp dword ptr [0x586f59], 0x1                # 0043ffc9
    jne.d32 L_0044006f                           # 0043ffd0
    # block 0x0043ffd6: entered by fall-through of jne at 0x0043ffd0, 2 instruction(s), ends with jne to 0x0044006f (forward)
    cmp dword ptr [0x586df1], 0x0                # 0043ffd6
    jne.d32 L_0044006f                           # 0043ffdd
    # block 0x0043ffe3: entered by fall-through of jne at 0x0043ffdd, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044006f
    push 0x5479f8                                # 0043ffe3
    push 0x63a63c                                # 0043ffe8
    lea edx, [ebp - local_1ce]                   # 0043ffed
    push edx                                     # 0043fff3
    call FUN_0043f210                            # 0043fff4
    add esp, 0xc                                 # 0043fff9
    mov edi, 0x547a00                            # 0043fffc
    lea edx, [ebp - local_3e]                    # 00440001
    or ecx, -0x1                                 # 00440004
    {load} xor eax, eax                          # 00440007
    repne scasb al, byte ptr es:[edi]            # 00440009
    not ecx                                      # 0044000b
    {load} sub edi, ecx                          # 0044000d
    {load} mov esi, edi                          # 0044000f
    {load} mov eax, ecx                          # 00440011
    {load} mov edi, edx                          # 00440013
    shr ecx, 0x2                                 # 00440015
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440018
    {load} mov ecx, eax                          # 0044001a
    and ecx, 0x3                                 # 0044001c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044001f
    mov word ptr [ebp - local_1c], 0x4e2         # 00440021
    mov word ptr [ebp - local_1a], 0x0           # 00440027
    mov word ptr [ebp - local_18], 0x0           # 0044002d
    mov word ptr [ebp - local_16], 0x1           # 00440033
    mov word ptr [ebp - local_8], 0xffff         # 00440039
    mov byte ptr [ebp - local_6], 0x0            # 0044003f
    mov word ptr [ebp - local_5], 0x2            # 00440043
    mov dword ptr [ebp - local_14], 0x0          # 00440049
    mov dword ptr [ebp - local_10], 0x0          # 00440050
    mov dword ptr [ebp - local_c], 0x1           # 00440057
    lea ecx, [ebp - local_1d4]                   # 0044005e
    push ecx                                     # 00440064
    mov ecx, 0x6177e8                            # 00440065
    call FUN_0041fa11                            # 0044006a
L_0044006f:
    # block 0x0044006f: entered by jne at 0x0043ffd0; jne at 0x0043ffdd, 2 instruction(s), ends with jne to 0x00440115 (forward)
    cmp dword ptr [0x586e6d], 0x1                # 0044006f
    jne.d32 L_00440115                           # 00440076
    # block 0x0044007c: entered by fall-through of jne at 0x00440076, 2 instruction(s), ends with jne to 0x00440115 (forward)
    cmp dword ptr [0x586df5], 0x0                # 0044007c
    jne.d32 L_00440115                           # 00440083
    # block 0x00440089: entered by fall-through of jne at 0x00440083, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440115
    push 0x547a08                                # 00440089
    push 0x63a640                                # 0044008e
    lea edx, [ebp - local_1ce]                   # 00440093
    push edx                                     # 00440099
    call FUN_0043f210                            # 0044009a
    add esp, 0xc                                 # 0044009f
    mov edi, 0x547a10                            # 004400a2
    lea edx, [ebp - local_3e]                    # 004400a7
    or ecx, -0x1                                 # 004400aa
    {load} xor eax, eax                          # 004400ad
    repne scasb al, byte ptr es:[edi]            # 004400af
    not ecx                                      # 004400b1
    {load} sub edi, ecx                          # 004400b3
    {load} mov esi, edi                          # 004400b5
    {load} mov eax, ecx                          # 004400b7
    {load} mov edi, edx                          # 004400b9
    shr ecx, 0x2                                 # 004400bb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004400be
    {load} mov ecx, eax                          # 004400c0
    and ecx, 0x3                                 # 004400c2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004400c5
    mov word ptr [ebp - local_1c], 0x4e9         # 004400c7
    mov word ptr [ebp - local_1a], 0x0           # 004400cd
    mov word ptr [ebp - local_18], 0x0           # 004400d3
    mov word ptr [ebp - local_16], 0x1           # 004400d9
    mov word ptr [ebp - local_8], 0xffff         # 004400df
    mov byte ptr [ebp - local_6], 0x0            # 004400e5
    mov word ptr [ebp - local_5], 0x2            # 004400e9
    mov dword ptr [ebp - local_14], 0x0          # 004400ef
    mov dword ptr [ebp - local_10], 0x0          # 004400f6
    mov dword ptr [ebp - local_c], 0x1           # 004400fd
    lea ecx, [ebp - local_1d4]                   # 00440104
    push ecx                                     # 0044010a
    mov ecx, 0x6177e8                            # 0044010b
    call FUN_0041fa11                            # 00440110
L_00440115:
    # block 0x00440115: entered by jne at 0x00440076; jne at 0x00440083, 2 instruction(s), ends with jne to 0x004401d5 (forward)
    cmp dword ptr [0x5876c1], 0x1                # 00440115
    jne.d32 L_004401d5                           # 0044011c
    # block 0x00440122: entered by fall-through of jne at 0x0044011c, 2 instruction(s), ends with jne to 0x004401d5 (forward)
    cmp dword ptr [0x5874b9], 0x1                # 00440122
    jne.d32 L_004401d5                           # 00440129
    # block 0x0044012f: entered by fall-through of jne at 0x00440129, 2 instruction(s), ends with jne to 0x004401d5 (forward)
    cmp dword ptr [0x586ffd], 0x0                # 0044012f
    jne.d32 L_004401d5                           # 00440136
    # block 0x0044013c: entered by fall-through of jne at 0x00440136, 2 instruction(s), ends with jne to 0x004401d5 (forward)
    cmp dword ptr [0x586cd5], 0x0                # 0044013c
    jne.d32 L_004401d5                           # 00440143
    # block 0x00440149: entered by fall-through of jne at 0x00440143, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004401d5
    push 0x547a18                                # 00440149
    push 0x63a644                                # 0044014e
    lea edx, [ebp - local_1ce]                   # 00440153
    push edx                                     # 00440159
    call FUN_0043f210                            # 0044015a
    add esp, 0xc                                 # 0044015f
    mov edi, 0x547a20                            # 00440162
    lea edx, [ebp - local_3e]                    # 00440167
    or ecx, -0x1                                 # 0044016a
    {load} xor eax, eax                          # 0044016d
    repne scasb al, byte ptr es:[edi]            # 0044016f
    not ecx                                      # 00440171
    {load} sub edi, ecx                          # 00440173
    {load} mov esi, edi                          # 00440175
    {load} mov eax, ecx                          # 00440177
    {load} mov edi, edx                          # 00440179
    shr ecx, 0x2                                 # 0044017b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044017e
    {load} mov ecx, eax                          # 00440180
    and ecx, 0x3                                 # 00440182
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440185
    mov word ptr [ebp - local_1c], 0x4ee         # 00440187
    mov word ptr [ebp - local_1a], 0x0           # 0044018d
    mov word ptr [ebp - local_18], 0x0           # 00440193
    mov word ptr [ebp - local_16], 0x1           # 00440199
    mov word ptr [ebp - local_8], 0xffff         # 0044019f
    mov byte ptr [ebp - local_6], 0x0            # 004401a5
    mov word ptr [ebp - local_5], 0x2            # 004401a9
    mov dword ptr [ebp - local_14], 0x0          # 004401af
    mov dword ptr [ebp - local_10], 0x0          # 004401b6
    mov dword ptr [ebp - local_c], 0x1           # 004401bd
    lea ecx, [ebp - local_1d4]                   # 004401c4
    push ecx                                     # 004401ca
    mov ecx, 0x6177e8                            # 004401cb
    call FUN_0041fa11                            # 004401d0
L_004401d5:
    # block 0x004401d5: entered by jne at 0x0044011c; jne at 0x00440129; jne at 0x00440136; jne at 0x00440143, 2 instruction(s), ends with jne to 0x00440288 (forward)
    cmp dword ptr [0x586df5], 0x1                # 004401d5
    jne.d32 L_00440288                           # 004401dc
    # block 0x004401e2: entered by fall-through of jne at 0x004401dc, 2 instruction(s), ends with jne to 0x00440288 (forward)
    cmp dword ptr [0x583bf1], 0x0                # 004401e2
    jne.d32 L_00440288                           # 004401e9
    # block 0x004401ef: entered by fall-through of jne at 0x004401e9, 2 instruction(s), ends with jne to 0x00440288 (forward)
    cmp dword ptr [0x587829], 0x1                # 004401ef
    jne.d32 L_00440288                           # 004401f6
    # block 0x004401fc: entered by fall-through of jne at 0x004401f6, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440288
    push 0x547a28                                # 004401fc
    push 0x63a648                                # 00440201
    lea edx, [ebp - local_1ce]                   # 00440206
    push edx                                     # 0044020c
    call FUN_0043f210                            # 0044020d
    add esp, 0xc                                 # 00440212
    mov edi, 0x547a30                            # 00440215
    lea edx, [ebp - local_3e]                    # 0044021a
    or ecx, -0x1                                 # 0044021d
    {load} xor eax, eax                          # 00440220
    repne scasb al, byte ptr es:[edi]            # 00440222
    not ecx                                      # 00440224
    {load} sub edi, ecx                          # 00440226
    {load} mov esi, edi                          # 00440228
    {load} mov eax, ecx                          # 0044022a
    {load} mov edi, edx                          # 0044022c
    shr ecx, 0x2                                 # 0044022e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440231
    {load} mov ecx, eax                          # 00440233
    and ecx, 0x3                                 # 00440235
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440238
    mov word ptr [ebp - local_1c], 0x4ef         # 0044023a
    mov word ptr [ebp - local_1a], 0x0           # 00440240
    mov word ptr [ebp - local_18], 0x0           # 00440246
    mov word ptr [ebp - local_16], 0x1           # 0044024c
    mov word ptr [ebp - local_8], 0xffff         # 00440252
    mov byte ptr [ebp - local_6], 0x0            # 00440258
    mov word ptr [ebp - local_5], 0x2            # 0044025c
    mov dword ptr [ebp - local_14], 0x0          # 00440262
    mov dword ptr [ebp - local_10], 0x0          # 00440269
    mov dword ptr [ebp - local_c], 0x1           # 00440270
    lea ecx, [ebp - local_1d4]                   # 00440277
    push ecx                                     # 0044027d
    mov ecx, 0x6177e8                            # 0044027e
    call FUN_0041fa11                            # 00440283
L_00440288:
    # block 0x00440288: entered by jne at 0x004401dc; jne at 0x004401e9; jne at 0x004401f6, 2 instruction(s), ends with jne to 0x00440321 (forward)
    cmp dword ptr [0x586cd1], 0x0                # 00440288
    jne.d32 L_00440321                           # 0044028f
    # block 0x00440295: entered by fall-through of jne at 0x0044028f, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440321
    push 0x547a38                                # 00440295
    push 0x63a64c                                # 0044029a
    lea edx, [ebp - local_1ce]                   # 0044029f
    push edx                                     # 004402a5
    call FUN_0043f210                            # 004402a6
    add esp, 0xc                                 # 004402ab
    mov edi, 0x547a40                            # 004402ae
    lea edx, [ebp - local_3e]                    # 004402b3
    or ecx, -0x1                                 # 004402b6
    {load} xor eax, eax                          # 004402b9
    repne scasb al, byte ptr es:[edi]            # 004402bb
    not ecx                                      # 004402bd
    {load} sub edi, ecx                          # 004402bf
    {load} mov esi, edi                          # 004402c1
    {load} mov eax, ecx                          # 004402c3
    {load} mov edi, edx                          # 004402c5
    shr ecx, 0x2                                 # 004402c7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004402ca
    {load} mov ecx, eax                          # 004402cc
    and ecx, 0x3                                 # 004402ce
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004402d1
    mov word ptr [ebp - local_1c], 0x4f1         # 004402d3
    mov word ptr [ebp - local_1a], 0x0           # 004402d9
    mov word ptr [ebp - local_18], 0x0           # 004402df
    mov word ptr [ebp - local_16], 0x1           # 004402e5
    mov word ptr [ebp - local_8], 0xffff         # 004402eb
    mov byte ptr [ebp - local_6], 0x0            # 004402f1
    mov word ptr [ebp - local_5], 0x2            # 004402f5
    mov dword ptr [ebp - local_14], 0x0          # 004402fb
    mov dword ptr [ebp - local_10], 0x0          # 00440302
    mov dword ptr [ebp - local_c], 0x1           # 00440309
    lea ecx, [ebp - local_1d4]                   # 00440310
    push ecx                                     # 00440316
    mov ecx, 0x6177e8                            # 00440317
    call FUN_0041fa11                            # 0044031c
L_00440321:
    # block 0x00440321: entered by jne at 0x0044028f, 2 instruction(s), ends with jne to 0x004403ba (forward)
    cmp dword ptr [0x58707d], 0x1                # 00440321
    jne.d32 L_004403ba                           # 00440328
    # block 0x0044032e: entered by fall-through of jne at 0x00440328, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004403ba
    push 0x547a48                                # 0044032e
    push 0x63a650                                # 00440333
    lea edx, [ebp - local_1ce]                   # 00440338
    push edx                                     # 0044033e
    call FUN_0043f210                            # 0044033f
    add esp, 0xc                                 # 00440344
    mov edi, 0x547a50                            # 00440347
    lea edx, [ebp - local_3e]                    # 0044034c
    or ecx, -0x1                                 # 0044034f
    {load} xor eax, eax                          # 00440352
    repne scasb al, byte ptr es:[edi]            # 00440354
    not ecx                                      # 00440356
    {load} sub edi, ecx                          # 00440358
    {load} mov esi, edi                          # 0044035a
    {load} mov eax, ecx                          # 0044035c
    {load} mov edi, edx                          # 0044035e
    shr ecx, 0x2                                 # 00440360
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440363
    {load} mov ecx, eax                          # 00440365
    and ecx, 0x3                                 # 00440367
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044036a
    mov word ptr [ebp - local_1c], 0x4f4         # 0044036c
    mov word ptr [ebp - local_1a], 0x0           # 00440372
    mov word ptr [ebp - local_18], 0x0           # 00440378
    mov word ptr [ebp - local_16], 0x1           # 0044037e
    mov word ptr [ebp - local_8], 0xffff         # 00440384
    mov byte ptr [ebp - local_6], 0x0            # 0044038a
    mov word ptr [ebp - local_5], 0x2            # 0044038e
    mov dword ptr [ebp - local_14], 0x0          # 00440394
    mov dword ptr [ebp - local_10], 0x0          # 0044039b
    mov dword ptr [ebp - local_c], 0x1           # 004403a2
    lea ecx, [ebp - local_1d4]                   # 004403a9
    push ecx                                     # 004403af
    mov ecx, 0x6177e8                            # 004403b0
    call FUN_0041fa11                            # 004403b5
L_004403ba:
    # block 0x004403ba: entered by jne at 0x00440328, 2 instruction(s), ends with jne to 0x0044047a (forward)
    cmp dword ptr [0x586df5], 0x1                # 004403ba
    jne.d32 L_0044047a                           # 004403c1
    # block 0x004403c7: entered by fall-through of jne at 0x004403c1, 2 instruction(s), ends with jne to 0x0044047a (forward)
    cmp dword ptr [0x5876cd], 0x1                # 004403c7
    jne.d32 L_0044047a                           # 004403ce
    # block 0x004403d4: entered by fall-through of jne at 0x004403ce, 2 instruction(s), ends with jne to 0x0044047a (forward)
    cmp dword ptr [0x587735], 0x0                # 004403d4
    jne.d32 L_0044047a                           # 004403db
    # block 0x004403e1: entered by fall-through of jne at 0x004403db, 2 instruction(s), ends with jne to 0x0044047a (forward)
    cmp dword ptr [0x586cc5], 0x0                # 004403e1
    jne.d32 L_0044047a                           # 004403e8
    # block 0x004403ee: entered by fall-through of jne at 0x004403e8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044047a
    push 0x547a58                                # 004403ee
    push 0x63a654                                # 004403f3
    lea edx, [ebp - local_1ce]                   # 004403f8
    push edx                                     # 004403fe
    call FUN_0043f210                            # 004403ff
    add esp, 0xc                                 # 00440404
    mov edi, 0x547a60                            # 00440407
    lea edx, [ebp - local_3e]                    # 0044040c
    or ecx, -0x1                                 # 0044040f
    {load} xor eax, eax                          # 00440412
    repne scasb al, byte ptr es:[edi]            # 00440414
    not ecx                                      # 00440416
    {load} sub edi, ecx                          # 00440418
    {load} mov esi, edi                          # 0044041a
    {load} mov eax, ecx                          # 0044041c
    {load} mov edi, edx                          # 0044041e
    shr ecx, 0x2                                 # 00440420
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440423
    {load} mov ecx, eax                          # 00440425
    and ecx, 0x3                                 # 00440427
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044042a
    mov word ptr [ebp - local_1c], 0x4f5         # 0044042c
    mov word ptr [ebp - local_1a], 0x0           # 00440432
    mov word ptr [ebp - local_18], 0x0           # 00440438
    mov word ptr [ebp - local_16], 0x1           # 0044043e
    mov word ptr [ebp - local_8], 0xffff         # 00440444
    mov byte ptr [ebp - local_6], 0x0            # 0044044a
    mov word ptr [ebp - local_5], 0x2            # 0044044e
    mov dword ptr [ebp - local_14], 0x0          # 00440454
    mov dword ptr [ebp - local_10], 0x0          # 0044045b
    mov dword ptr [ebp - local_c], 0x1           # 00440462
    lea ecx, [ebp - local_1d4]                   # 00440469
    push ecx                                     # 0044046f
    mov ecx, 0x6177e8                            # 00440470
    call FUN_0041fa11                            # 00440475
L_0044047a:
    # block 0x0044047a: entered by jne at 0x004403c1; jne at 0x004403ce; jne at 0x004403db; jne at 0x004403e8, 2 instruction(s), ends with jne to 0x00440520 (forward)
    cmp dword ptr [0x5872a1], 0x1                # 0044047a
    jne.d32 L_00440520                           # 00440481
    # block 0x00440487: entered by fall-through of jne at 0x00440481, 2 instruction(s), ends with jne to 0x00440520 (forward)
    cmp dword ptr [0x586e59], 0x0                # 00440487
    jne.d32 L_00440520                           # 0044048e
    # block 0x00440494: entered by fall-through of jne at 0x0044048e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440520
    push 0x547a68                                # 00440494
    push 0x63a658                                # 00440499
    lea edx, [ebp - local_1ce]                   # 0044049e
    push edx                                     # 004404a4
    call FUN_0043f210                            # 004404a5
    add esp, 0xc                                 # 004404aa
    mov edi, 0x547a70                            # 004404ad
    lea edx, [ebp - local_3e]                    # 004404b2
    or ecx, -0x1                                 # 004404b5
    {load} xor eax, eax                          # 004404b8
    repne scasb al, byte ptr es:[edi]            # 004404ba
    not ecx                                      # 004404bc
    {load} sub edi, ecx                          # 004404be
    {load} mov esi, edi                          # 004404c0
    {load} mov eax, ecx                          # 004404c2
    {load} mov edi, edx                          # 004404c4
    shr ecx, 0x2                                 # 004404c6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004404c9
    {load} mov ecx, eax                          # 004404cb
    and ecx, 0x3                                 # 004404cd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004404d0
    mov word ptr [ebp - local_1c], 0x4f6         # 004404d2
    mov word ptr [ebp - local_1a], 0x0           # 004404d8
    mov word ptr [ebp - local_18], 0x0           # 004404de
    mov word ptr [ebp - local_16], 0x1           # 004404e4
    mov word ptr [ebp - local_8], 0xffff         # 004404ea
    mov byte ptr [ebp - local_6], 0x0            # 004404f0
    mov word ptr [ebp - local_5], 0x2            # 004404f4
    mov dword ptr [ebp - local_14], 0x0          # 004404fa
    mov dword ptr [ebp - local_10], 0x0          # 00440501
    mov dword ptr [ebp - local_c], 0x1           # 00440508
    lea ecx, [ebp - local_1d4]                   # 0044050f
    push ecx                                     # 00440515
    mov ecx, 0x6177e8                            # 00440516
    call FUN_0041fa11                            # 0044051b
L_00440520:
    # block 0x00440520: entered by jne at 0x00440481; jne at 0x0044048e, 2 instruction(s), ends with jne to 0x004405c6 (forward)
    cmp dword ptr [0x5875c5], 0x1                # 00440520
    jne.d32 L_004405c6                           # 00440527
    # block 0x0044052d: entered by fall-through of jne at 0x00440527, 2 instruction(s), ends with jne to 0x004405c6 (forward)
    cmp dword ptr [0x586e41], 0x0                # 0044052d
    jne.d32 L_004405c6                           # 00440534
    # block 0x0044053a: entered by fall-through of jne at 0x00440534, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004405c6
    push 0x547a78                                # 0044053a
    push 0x63a65c                                # 0044053f
    lea edx, [ebp - local_1ce]                   # 00440544
    push edx                                     # 0044054a
    call FUN_0043f210                            # 0044054b
    add esp, 0xc                                 # 00440550
    mov edi, 0x547a80                            # 00440553
    lea edx, [ebp - local_3e]                    # 00440558
    or ecx, -0x1                                 # 0044055b
    {load} xor eax, eax                          # 0044055e
    repne scasb al, byte ptr es:[edi]            # 00440560
    not ecx                                      # 00440562
    {load} sub edi, ecx                          # 00440564
    {load} mov esi, edi                          # 00440566
    {load} mov eax, ecx                          # 00440568
    {load} mov edi, edx                          # 0044056a
    shr ecx, 0x2                                 # 0044056c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044056f
    {load} mov ecx, eax                          # 00440571
    and ecx, 0x3                                 # 00440573
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440576
    mov word ptr [ebp - local_1c], 0x4f7         # 00440578
    mov word ptr [ebp - local_1a], 0x0           # 0044057e
    mov word ptr [ebp - local_18], 0x0           # 00440584
    mov word ptr [ebp - local_16], 0x1           # 0044058a
    mov word ptr [ebp - local_8], 0xffff         # 00440590
    mov byte ptr [ebp - local_6], 0x0            # 00440596
    mov word ptr [ebp - local_5], 0x2            # 0044059a
    mov dword ptr [ebp - local_14], 0x0          # 004405a0
    mov dword ptr [ebp - local_10], 0x0          # 004405a7
    mov dword ptr [ebp - local_c], 0x1           # 004405ae
    lea ecx, [ebp - local_1d4]                   # 004405b5
    push ecx                                     # 004405bb
    mov ecx, 0x6177e8                            # 004405bc
    call FUN_0041fa11                            # 004405c1
L_004405c6:
    # block 0x004405c6: entered by jne at 0x00440527; jne at 0x00440534, 2 instruction(s), ends with jne to 0x0044066c (forward)
    cmp dword ptr [0x586e41], 0x1                # 004405c6
    jne.d32 L_0044066c                           # 004405cd
    # block 0x004405d3: entered by fall-through of jne at 0x004405cd, 2 instruction(s), ends with jne to 0x0044066c (forward)
    cmp dword ptr [0x5876f1], 0x0                # 004405d3
    jne.d32 L_0044066c                           # 004405da
    # block 0x004405e0: entered by fall-through of jne at 0x004405da, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044066c
    push 0x547a88                                # 004405e0
    push 0x63a660                                # 004405e5
    lea edx, [ebp - local_1ce]                   # 004405ea
    push edx                                     # 004405f0
    call FUN_0043f210                            # 004405f1
    add esp, 0xc                                 # 004405f6
    mov edi, 0x547a90                            # 004405f9
    lea edx, [ebp - local_3e]                    # 004405fe
    or ecx, -0x1                                 # 00440601
    {load} xor eax, eax                          # 00440604
    repne scasb al, byte ptr es:[edi]            # 00440606
    not ecx                                      # 00440608
    {load} sub edi, ecx                          # 0044060a
    {load} mov esi, edi                          # 0044060c
    {load} mov eax, ecx                          # 0044060e
    {load} mov edi, edx                          # 00440610
    shr ecx, 0x2                                 # 00440612
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440615
    {load} mov ecx, eax                          # 00440617
    and ecx, 0x3                                 # 00440619
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044061c
    mov word ptr [ebp - local_1c], 0x4fa         # 0044061e
    mov word ptr [ebp - local_1a], 0x0           # 00440624
    mov word ptr [ebp - local_18], 0x0           # 0044062a
    mov word ptr [ebp - local_16], 0x1           # 00440630
    mov word ptr [ebp - local_8], 0xffff         # 00440636
    mov byte ptr [ebp - local_6], 0x0            # 0044063c
    mov word ptr [ebp - local_5], 0x2            # 00440640
    mov dword ptr [ebp - local_14], 0x0          # 00440646
    mov dword ptr [ebp - local_10], 0x0          # 0044064d
    mov dword ptr [ebp - local_c], 0x1           # 00440654
    lea ecx, [ebp - local_1d4]                   # 0044065b
    push ecx                                     # 00440661
    mov ecx, 0x6177e8                            # 00440662
    call FUN_0041fa11                            # 00440667
L_0044066c:
    # block 0x0044066c: entered by jne at 0x004405cd; jne at 0x004405da, 2 instruction(s), ends with jne to 0x0044071f (forward)
    cmp dword ptr [0x587855], 0x1                # 0044066c
    jne.d32 L_0044071f                           # 00440673
    # block 0x00440679: entered by fall-through of jne at 0x00440673, 2 instruction(s), ends with jne to 0x0044071f (forward)
    cmp dword ptr [0x587705], 0x0                # 00440679
    jne.d32 L_0044071f                           # 00440680
    # block 0x00440686: entered by fall-through of jne at 0x00440680, 2 instruction(s), ends with jne to 0x0044071f (forward)
    cmp dword ptr [0x586da5], 0x0                # 00440686
    jne.d32 L_0044071f                           # 0044068d
    # block 0x00440693: entered by fall-through of jne at 0x0044068d, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044071f
    push 0x547a98                                # 00440693
    push 0x63a664                                # 00440698
    lea edx, [ebp - local_1ce]                   # 0044069d
    push edx                                     # 004406a3
    call FUN_0043f210                            # 004406a4
    add esp, 0xc                                 # 004406a9
    mov edi, 0x547aa0                            # 004406ac
    lea edx, [ebp - local_3e]                    # 004406b1
    or ecx, -0x1                                 # 004406b4
    {load} xor eax, eax                          # 004406b7
    repne scasb al, byte ptr es:[edi]            # 004406b9
    not ecx                                      # 004406bb
    {load} sub edi, ecx                          # 004406bd
    {load} mov esi, edi                          # 004406bf
    {load} mov eax, ecx                          # 004406c1
    {load} mov edi, edx                          # 004406c3
    shr ecx, 0x2                                 # 004406c5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004406c8
    {load} mov ecx, eax                          # 004406ca
    and ecx, 0x3                                 # 004406cc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004406cf
    mov word ptr [ebp - local_1c], 0x4fb         # 004406d1
    mov word ptr [ebp - local_1a], 0x0           # 004406d7
    mov word ptr [ebp - local_18], 0x0           # 004406dd
    mov word ptr [ebp - local_16], 0x1           # 004406e3
    mov word ptr [ebp - local_8], 0xffff         # 004406e9
    mov byte ptr [ebp - local_6], 0x0            # 004406ef
    mov word ptr [ebp - local_5], 0x2            # 004406f3
    mov dword ptr [ebp - local_14], 0x0          # 004406f9
    mov dword ptr [ebp - local_10], 0x0          # 00440700
    mov dword ptr [ebp - local_c], 0x1           # 00440707
    lea ecx, [ebp - local_1d4]                   # 0044070e
    push ecx                                     # 00440714
    mov ecx, 0x6177e8                            # 00440715
    call FUN_0041fa11                            # 0044071a
L_0044071f:
    # block 0x0044071f: entered by jne at 0x00440673; jne at 0x00440680; jne at 0x0044068d, 2 instruction(s), ends with jne to 0x004407df (forward)
    cmp dword ptr [0x586e2d], 0x0                # 0044071f
    jne.d32 L_004407df                           # 00440726
    # block 0x0044072c: entered by fall-through of jne at 0x00440726, 2 instruction(s), ends with jne to 0x004407df (forward)
    cmp dword ptr [0x587855], 0x1                # 0044072c
    jne.d32 L_004407df                           # 00440733
    # block 0x00440739: entered by fall-through of jne at 0x00440733, 2 instruction(s), ends with jne to 0x004407df (forward)
    cmp dword ptr [0x586da5], 0x1                # 00440739
    jne.d32 L_004407df                           # 00440740
    # block 0x00440746: entered by fall-through of jne at 0x00440740, 2 instruction(s), ends with jne to 0x004407df (forward)
    cmp dword ptr [0x587705], 0x0                # 00440746
    jne.d32 L_004407df                           # 0044074d
    # block 0x00440753: entered by fall-through of jne at 0x0044074d, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004407df
    push 0x547aa8                                # 00440753
    push 0x63a668                                # 00440758
    lea edx, [ebp - local_1ce]                   # 0044075d
    push edx                                     # 00440763
    call FUN_0043f210                            # 00440764
    add esp, 0xc                                 # 00440769
    mov edi, 0x547ab0                            # 0044076c
    lea edx, [ebp - local_3e]                    # 00440771
    or ecx, -0x1                                 # 00440774
    {load} xor eax, eax                          # 00440777
    repne scasb al, byte ptr es:[edi]            # 00440779
    not ecx                                      # 0044077b
    {load} sub edi, ecx                          # 0044077d
    {load} mov esi, edi                          # 0044077f
    {load} mov eax, ecx                          # 00440781
    {load} mov edi, edx                          # 00440783
    shr ecx, 0x2                                 # 00440785
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440788
    {load} mov ecx, eax                          # 0044078a
    and ecx, 0x3                                 # 0044078c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044078f
    mov word ptr [ebp - local_1c], 0x511         # 00440791
    mov word ptr [ebp - local_1a], 0x0           # 00440797
    mov word ptr [ebp - local_18], 0x0           # 0044079d
    mov word ptr [ebp - local_16], 0x1           # 004407a3
    mov word ptr [ebp - local_8], 0xffff         # 004407a9
    mov byte ptr [ebp - local_6], 0x0            # 004407af
    mov word ptr [ebp - local_5], 0x2            # 004407b3
    mov dword ptr [ebp - local_14], 0x0          # 004407b9
    mov dword ptr [ebp - local_10], 0x0          # 004407c0
    mov dword ptr [ebp - local_c], 0x1           # 004407c7
    lea ecx, [ebp - local_1d4]                   # 004407ce
    push ecx                                     # 004407d4
    mov ecx, 0x6177e8                            # 004407d5
    call FUN_0041fa11                            # 004407da
L_004407df:
    # block 0x004407df: entered by jne at 0x00440726; jne at 0x00440733; jne at 0x00440740; jne at 0x0044074d, 2 instruction(s), ends with jne to 0x00440892 (forward)
    cmp dword ptr [0x58747d], 0x1                # 004407df
    jne.d32 L_00440892                           # 004407e6
    # block 0x004407ec: entered by fall-through of jne at 0x004407e6, 2 instruction(s), ends with jne to 0x00440892 (forward)
    cmp dword ptr [0x587699], 0x0                # 004407ec
    jne.d32 L_00440892                           # 004407f3
    # block 0x004407f9: entered by fall-through of jne at 0x004407f3, 2 instruction(s), ends with jne to 0x00440892 (forward)
    cmp dword ptr [0x586c91], 0x0                # 004407f9
    jne.d32 L_00440892                           # 00440800
    # block 0x00440806: entered by fall-through of jne at 0x00440800, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440892
    push 0x547ab8                                # 00440806
    push 0x63a66c                                # 0044080b
    lea edx, [ebp - local_1ce]                   # 00440810
    push edx                                     # 00440816
    call FUN_0043f210                            # 00440817
    add esp, 0xc                                 # 0044081c
    mov edi, 0x547ac0                            # 0044081f
    lea edx, [ebp - local_3e]                    # 00440824
    or ecx, -0x1                                 # 00440827
    {load} xor eax, eax                          # 0044082a
    repne scasb al, byte ptr es:[edi]            # 0044082c
    not ecx                                      # 0044082e
    {load} sub edi, ecx                          # 00440830
    {load} mov esi, edi                          # 00440832
    {load} mov eax, ecx                          # 00440834
    {load} mov edi, edx                          # 00440836
    shr ecx, 0x2                                 # 00440838
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044083b
    {load} mov ecx, eax                          # 0044083d
    and ecx, 0x3                                 # 0044083f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440842
    mov word ptr [ebp - local_1c], 0x4fd         # 00440844
    mov word ptr [ebp - local_1a], 0x0           # 0044084a
    mov word ptr [ebp - local_18], 0x0           # 00440850
    mov word ptr [ebp - local_16], 0x1           # 00440856
    mov word ptr [ebp - local_8], 0xffff         # 0044085c
    mov byte ptr [ebp - local_6], 0x0            # 00440862
    mov word ptr [ebp - local_5], 0x2            # 00440866
    mov dword ptr [ebp - local_14], 0x0          # 0044086c
    mov dword ptr [ebp - local_10], 0x0          # 00440873
    mov dword ptr [ebp - local_c], 0x1           # 0044087a
    lea ecx, [ebp - local_1d4]                   # 00440881
    push ecx                                     # 00440887
    mov ecx, 0x6177e8                            # 00440888
    call FUN_0041fa11                            # 0044088d
L_00440892:
    # block 0x00440892: entered by jne at 0x004407e6; jne at 0x004407f3; jne at 0x00440800, 2 instruction(s), ends with jne to 0x00440945 (forward)
    cmp dword ptr [0x586eed], 0x1                # 00440892
    jne.d32 L_00440945                           # 00440899
    # block 0x0044089f: entered by fall-through of jne at 0x00440899, 2 instruction(s), ends with jne to 0x00440945 (forward)
    cmp dword ptr [0x5873b9], 0x0                # 0044089f
    jne.d32 L_00440945                           # 004408a6
    # block 0x004408ac: entered by fall-through of jne at 0x004408a6, 2 instruction(s), ends with jne to 0x00440945 (forward)
    cmp dword ptr [0x586dad], 0x0                # 004408ac
    jne.d32 L_00440945                           # 004408b3
    # block 0x004408b9: entered by fall-through of jne at 0x004408b3, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440945
    push 0x547ac8                                # 004408b9
    push 0x63a670                                # 004408be
    lea edx, [ebp - local_1ce]                   # 004408c3
    push edx                                     # 004408c9
    call FUN_0043f210                            # 004408ca
    add esp, 0xc                                 # 004408cf
    mov edi, 0x547ad0                            # 004408d2
    lea edx, [ebp - local_3e]                    # 004408d7
    or ecx, -0x1                                 # 004408da
    {load} xor eax, eax                          # 004408dd
    repne scasb al, byte ptr es:[edi]            # 004408df
    not ecx                                      # 004408e1
    {load} sub edi, ecx                          # 004408e3
    {load} mov esi, edi                          # 004408e5
    {load} mov eax, ecx                          # 004408e7
    {load} mov edi, edx                          # 004408e9
    shr ecx, 0x2                                 # 004408eb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004408ee
    {load} mov ecx, eax                          # 004408f0
    and ecx, 0x3                                 # 004408f2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004408f5
    mov word ptr [ebp - local_1c], 0x4fe         # 004408f7
    mov word ptr [ebp - local_1a], 0x0           # 004408fd
    mov word ptr [ebp - local_18], 0x0           # 00440903
    mov word ptr [ebp - local_16], 0x1           # 00440909
    mov word ptr [ebp - local_8], 0xffff         # 0044090f
    mov byte ptr [ebp - local_6], 0x0            # 00440915
    mov word ptr [ebp - local_5], 0x2            # 00440919
    mov dword ptr [ebp - local_14], 0x0          # 0044091f
    mov dword ptr [ebp - local_10], 0x0          # 00440926
    mov dword ptr [ebp - local_c], 0x1           # 0044092d
    lea ecx, [ebp - local_1d4]                   # 00440934
    push ecx                                     # 0044093a
    mov ecx, 0x6177e8                            # 0044093b
    call FUN_0041fa11                            # 00440940
L_00440945:
    # block 0x00440945: entered by jne at 0x00440899; jne at 0x004408a6; jne at 0x004408b3, 2 instruction(s), ends with jne to 0x004409de (forward)
    cmp dword ptr [0x586d9d], 0x0                # 00440945
    jne.d32 L_004409de                           # 0044094c
    # block 0x00440952: entered by fall-through of jne at 0x0044094c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004409de
    push 0x547ad8                                # 00440952
    push 0x63a674                                # 00440957
    lea edx, [ebp - local_1ce]                   # 0044095c
    push edx                                     # 00440962
    call FUN_0043f210                            # 00440963
    add esp, 0xc                                 # 00440968
    mov edi, 0x547ae0                            # 0044096b
    lea edx, [ebp - local_3e]                    # 00440970
    or ecx, -0x1                                 # 00440973
    {load} xor eax, eax                          # 00440976
    repne scasb al, byte ptr es:[edi]            # 00440978
    not ecx                                      # 0044097a
    {load} sub edi, ecx                          # 0044097c
    {load} mov esi, edi                          # 0044097e
    {load} mov eax, ecx                          # 00440980
    {load} mov edi, edx                          # 00440982
    shr ecx, 0x2                                 # 00440984
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440987
    {load} mov ecx, eax                          # 00440989
    and ecx, 0x3                                 # 0044098b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044098e
    mov word ptr [ebp - local_1c], 0x4ff         # 00440990
    mov word ptr [ebp - local_1a], 0x0           # 00440996
    mov word ptr [ebp - local_18], 0x0           # 0044099c
    mov word ptr [ebp - local_16], 0x1           # 004409a2
    mov word ptr [ebp - local_8], 0xffff         # 004409a8
    mov byte ptr [ebp - local_6], 0x0            # 004409ae
    mov word ptr [ebp - local_5], 0x2            # 004409b2
    mov dword ptr [ebp - local_14], 0x0          # 004409b8
    mov dword ptr [ebp - local_10], 0x0          # 004409bf
    mov dword ptr [ebp - local_c], 0x1           # 004409c6
    lea ecx, [ebp - local_1d4]                   # 004409cd
    push ecx                                     # 004409d3
    mov ecx, 0x6177e8                            # 004409d4
    call FUN_0041fa11                            # 004409d9
L_004409de:
    # block 0x004409de: entered by jne at 0x0044094c, 2 instruction(s), ends with jne to 0x00440a84 (forward)
    cmp dword ptr [0x587525], 0x1                # 004409de
    jne.d32 L_00440a84                           # 004409e5
    # block 0x004409eb: entered by fall-through of jne at 0x004409e5, 2 instruction(s), ends with jne to 0x00440a84 (forward)
    cmp dword ptr [0x586d15], 0x0                # 004409eb
    jne.d32 L_00440a84                           # 004409f2
    # block 0x004409f8: entered by fall-through of jne at 0x004409f2, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440a84
    push 0x547ae8                                # 004409f8
    push 0x63a678                                # 004409fd
    lea edx, [ebp - local_1ce]                   # 00440a02
    push edx                                     # 00440a08
    call FUN_0043f210                            # 00440a09
    add esp, 0xc                                 # 00440a0e
    mov edi, 0x547af0                            # 00440a11
    lea edx, [ebp - local_3e]                    # 00440a16
    or ecx, -0x1                                 # 00440a19
    {load} xor eax, eax                          # 00440a1c
    repne scasb al, byte ptr es:[edi]            # 00440a1e
    not ecx                                      # 00440a20
    {load} sub edi, ecx                          # 00440a22
    {load} mov esi, edi                          # 00440a24
    {load} mov eax, ecx                          # 00440a26
    {load} mov edi, edx                          # 00440a28
    shr ecx, 0x2                                 # 00440a2a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440a2d
    {load} mov ecx, eax                          # 00440a2f
    and ecx, 0x3                                 # 00440a31
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440a34
    mov word ptr [ebp - local_1c], 0x500         # 00440a36
    mov word ptr [ebp - local_1a], 0x0           # 00440a3c
    mov word ptr [ebp - local_18], 0x0           # 00440a42
    mov word ptr [ebp - local_16], 0x1           # 00440a48
    mov word ptr [ebp - local_8], 0xffff         # 00440a4e
    mov byte ptr [ebp - local_6], 0x0            # 00440a54
    mov word ptr [ebp - local_5], 0x2            # 00440a58
    mov dword ptr [ebp - local_14], 0x0          # 00440a5e
    mov dword ptr [ebp - local_10], 0x0          # 00440a65
    mov dword ptr [ebp - local_c], 0x1           # 00440a6c
    lea ecx, [ebp - local_1d4]                   # 00440a73
    push ecx                                     # 00440a79
    mov ecx, 0x6177e8                            # 00440a7a
    call FUN_0041fa11                            # 00440a7f
L_00440a84:
    # block 0x00440a84: entered by jne at 0x004409e5; jne at 0x004409f2, 2 instruction(s), ends with jne to 0x00440b44 (forward)
    cmp dword ptr [0x587525], 0x1                # 00440a84
    jne.d32 L_00440b44                           # 00440a8b
    # block 0x00440a91: entered by fall-through of jne at 0x00440a8b, 2 instruction(s), ends with jne to 0x00440b44 (forward)
    cmp dword ptr [0x586d15], 0x1                # 00440a91
    jne.d32 L_00440b44                           # 00440a98
    # block 0x00440a9e: entered by fall-through of jne at 0x00440a98, 2 instruction(s), ends with jne to 0x00440b44 (forward)
    cmp dword ptr [0x583be9], 0x1                # 00440a9e
    jne.d32 L_00440b44                           # 00440aa5
    # block 0x00440aab: entered by fall-through of jne at 0x00440aa5, 2 instruction(s), ends with jne to 0x00440b44 (forward)
    cmp dword ptr [0x583c09], 0x0                # 00440aab
    jne.d32 L_00440b44                           # 00440ab2
    # block 0x00440ab8: entered by fall-through of jne at 0x00440ab2, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440b44
    push 0x547af8                                # 00440ab8
    push 0x63a67c                                # 00440abd
    lea edx, [ebp - local_1ce]                   # 00440ac2
    push edx                                     # 00440ac8
    call FUN_0043f210                            # 00440ac9
    add esp, 0xc                                 # 00440ace
    mov edi, 0x547b00                            # 00440ad1
    lea edx, [ebp - local_3e]                    # 00440ad6
    or ecx, -0x1                                 # 00440ad9
    {load} xor eax, eax                          # 00440adc
    repne scasb al, byte ptr es:[edi]            # 00440ade
    not ecx                                      # 00440ae0
    {load} sub edi, ecx                          # 00440ae2
    {load} mov esi, edi                          # 00440ae4
    {load} mov eax, ecx                          # 00440ae6
    {load} mov edi, edx                          # 00440ae8
    shr ecx, 0x2                                 # 00440aea
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440aed
    {load} mov ecx, eax                          # 00440aef
    and ecx, 0x3                                 # 00440af1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440af4
    mov word ptr [ebp - local_1c], 0x502         # 00440af6
    mov word ptr [ebp - local_1a], 0x0           # 00440afc
    mov word ptr [ebp - local_18], 0x0           # 00440b02
    mov word ptr [ebp - local_16], 0x1           # 00440b08
    mov word ptr [ebp - local_8], 0xffff         # 00440b0e
    mov byte ptr [ebp - local_6], 0x0            # 00440b14
    mov word ptr [ebp - local_5], 0x2            # 00440b18
    mov dword ptr [ebp - local_14], 0x0          # 00440b1e
    mov dword ptr [ebp - local_10], 0x0          # 00440b25
    mov dword ptr [ebp - local_c], 0x1           # 00440b2c
    lea ecx, [ebp - local_1d4]                   # 00440b33
    push ecx                                     # 00440b39
    mov ecx, 0x6177e8                            # 00440b3a
    call FUN_0041fa11                            # 00440b3f
L_00440b44:
    # block 0x00440b44: entered by jne at 0x00440a8b; jne at 0x00440a98; jne at 0x00440aa5; jne at 0x00440ab2, 2 instruction(s), ends with jne to 0x00440bea (forward)
    cmp dword ptr [0x587661], 0x1                # 00440b44
    jne.d32 L_00440bea                           # 00440b4b
    # block 0x00440b51: entered by fall-through of jne at 0x00440b4b, 2 instruction(s), ends with jne to 0x00440bea (forward)
    cmp dword ptr [0x586e19], 0x0                # 00440b51
    jne.d32 L_00440bea                           # 00440b58
    # block 0x00440b5e: entered by fall-through of jne at 0x00440b58, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440bea
    push 0x547b08                                # 00440b5e
    push 0x63a680                                # 00440b63
    lea edx, [ebp - local_1ce]                   # 00440b68
    push edx                                     # 00440b6e
    call FUN_0043f210                            # 00440b6f
    add esp, 0xc                                 # 00440b74
    mov edi, 0x547b10                            # 00440b77
    lea edx, [ebp - local_3e]                    # 00440b7c
    or ecx, -0x1                                 # 00440b7f
    {load} xor eax, eax                          # 00440b82
    repne scasb al, byte ptr es:[edi]            # 00440b84
    not ecx                                      # 00440b86
    {load} sub edi, ecx                          # 00440b88
    {load} mov esi, edi                          # 00440b8a
    {load} mov eax, ecx                          # 00440b8c
    {load} mov edi, edx                          # 00440b8e
    shr ecx, 0x2                                 # 00440b90
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440b93
    {load} mov ecx, eax                          # 00440b95
    and ecx, 0x3                                 # 00440b97
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440b9a
    mov word ptr [ebp - local_1c], 0x503         # 00440b9c
    mov word ptr [ebp - local_1a], 0x0           # 00440ba2
    mov word ptr [ebp - local_18], 0x0           # 00440ba8
    mov word ptr [ebp - local_16], 0x1           # 00440bae
    mov word ptr [ebp - local_8], 0xffff         # 00440bb4
    mov byte ptr [ebp - local_6], 0x0            # 00440bba
    mov word ptr [ebp - local_5], 0x2            # 00440bbe
    mov dword ptr [ebp - local_14], 0x0          # 00440bc4
    mov dword ptr [ebp - local_10], 0x0          # 00440bcb
    mov dword ptr [ebp - local_c], 0x1           # 00440bd2
    lea ecx, [ebp - local_1d4]                   # 00440bd9
    push ecx                                     # 00440bdf
    mov ecx, 0x6177e8                            # 00440be0
    call FUN_0041fa11                            # 00440be5
L_00440bea:
    # block 0x00440bea: entered by jne at 0x00440b4b; jne at 0x00440b58, 2 instruction(s), ends with jne to 0x00440c9d (forward)
    cmp dword ptr [0x58751d], 0x1                # 00440bea
    jne.d32 L_00440c9d                           # 00440bf1
    # block 0x00440bf7: entered by fall-through of jne at 0x00440bf1, 2 instruction(s), ends with jne to 0x00440c9d (forward)
    cmp dword ptr [0x586f51], 0x1                # 00440bf7
    jne.d32 L_00440c9d                           # 00440bfe
    # block 0x00440c04: entered by fall-through of jne at 0x00440bfe, 2 instruction(s), ends with jne to 0x00440c9d (forward)
    cmp dword ptr [0x586de1], 0x0                # 00440c04
    jne.d32 L_00440c9d                           # 00440c0b
    # block 0x00440c11: entered by fall-through of jne at 0x00440c0b, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440c9d
    push 0x547b18                                # 00440c11
    push 0x63a684                                # 00440c16
    lea edx, [ebp - local_1ce]                   # 00440c1b
    push edx                                     # 00440c21
    call FUN_0043f210                            # 00440c22
    add esp, 0xc                                 # 00440c27
    mov edi, 0x547b20                            # 00440c2a
    lea edx, [ebp - local_3e]                    # 00440c2f
    or ecx, -0x1                                 # 00440c32
    {load} xor eax, eax                          # 00440c35
    repne scasb al, byte ptr es:[edi]            # 00440c37
    not ecx                                      # 00440c39
    {load} sub edi, ecx                          # 00440c3b
    {load} mov esi, edi                          # 00440c3d
    {load} mov eax, ecx                          # 00440c3f
    {load} mov edi, edx                          # 00440c41
    shr ecx, 0x2                                 # 00440c43
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440c46
    {load} mov ecx, eax                          # 00440c48
    and ecx, 0x3                                 # 00440c4a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440c4d
    mov word ptr [ebp - local_1c], 0x508         # 00440c4f
    mov word ptr [ebp - local_1a], 0x0           # 00440c55
    mov word ptr [ebp - local_18], 0x0           # 00440c5b
    mov word ptr [ebp - local_16], 0x1           # 00440c61
    mov word ptr [ebp - local_8], 0xffff         # 00440c67
    mov byte ptr [ebp - local_6], 0x0            # 00440c6d
    mov word ptr [ebp - local_5], 0x2            # 00440c71
    mov dword ptr [ebp - local_14], 0x0          # 00440c77
    mov dword ptr [ebp - local_10], 0x0          # 00440c7e
    mov dword ptr [ebp - local_c], 0x1           # 00440c85
    lea ecx, [ebp - local_1d4]                   # 00440c8c
    push ecx                                     # 00440c92
    mov ecx, 0x6177e8                            # 00440c93
    call FUN_0041fa11                            # 00440c98
L_00440c9d:
    # block 0x00440c9d: entered by jne at 0x00440bf1; jne at 0x00440bfe; jne at 0x00440c0b, 2 instruction(s), ends with jne to 0x00440d43 (forward)
    cmp dword ptr [0x586b69], 0x1                # 00440c9d
    jne.d32 L_00440d43                           # 00440ca4
    # block 0x00440caa: entered by fall-through of jne at 0x00440ca4, 2 instruction(s), ends with jne to 0x00440d43 (forward)
    cmp dword ptr [0x586ddd], 0x0                # 00440caa
    jne.d32 L_00440d43                           # 00440cb1
    # block 0x00440cb7: entered by fall-through of jne at 0x00440cb1, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440d43
    push 0x547b28                                # 00440cb7
    push 0x63a688                                # 00440cbc
    lea edx, [ebp - local_1ce]                   # 00440cc1
    push edx                                     # 00440cc7
    call FUN_0043f210                            # 00440cc8
    add esp, 0xc                                 # 00440ccd
    mov edi, 0x547b30                            # 00440cd0
    lea edx, [ebp - local_3e]                    # 00440cd5
    or ecx, -0x1                                 # 00440cd8
    {load} xor eax, eax                          # 00440cdb
    repne scasb al, byte ptr es:[edi]            # 00440cdd
    not ecx                                      # 00440cdf
    {load} sub edi, ecx                          # 00440ce1
    {load} mov esi, edi                          # 00440ce3
    {load} mov eax, ecx                          # 00440ce5
    {load} mov edi, edx                          # 00440ce7
    shr ecx, 0x2                                 # 00440ce9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440cec
    {load} mov ecx, eax                          # 00440cee
    and ecx, 0x3                                 # 00440cf0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440cf3
    mov word ptr [ebp - local_1c], 0x13bf        # 00440cf5
    mov word ptr [ebp - local_1a], 0x0           # 00440cfb
    mov word ptr [ebp - local_18], 0x0           # 00440d01
    mov word ptr [ebp - local_16], 0x1           # 00440d07
    mov word ptr [ebp - local_8], 0xffff         # 00440d0d
    mov byte ptr [ebp - local_6], 0x0            # 00440d13
    mov word ptr [ebp - local_5], 0x2            # 00440d17
    mov dword ptr [ebp - local_14], 0x0          # 00440d1d
    mov dword ptr [ebp - local_10], 0x0          # 00440d24
    mov dword ptr [ebp - local_c], 0x1           # 00440d2b
    lea ecx, [ebp - local_1d4]                   # 00440d32
    push ecx                                     # 00440d38
    mov ecx, 0x6177e8                            # 00440d39
    call FUN_0041fa11                            # 00440d3e
L_00440d43:
    # block 0x00440d43: entered by jne at 0x00440ca4; jne at 0x00440cb1, 2 instruction(s), ends with jne to 0x00440df6 (forward)
    cmp dword ptr [0x587609], 0x1                # 00440d43
    jne.d32 L_00440df6                           # 00440d4a
    # block 0x00440d50: entered by fall-through of jne at 0x00440d4a, 2 instruction(s), ends with jne to 0x00440df6 (forward)
    cmp dword ptr [0x587279], 0x0                # 00440d50
    jne.d32 L_00440df6                           # 00440d57
    # block 0x00440d5d: entered by fall-through of jne at 0x00440d57, 2 instruction(s), ends with jne to 0x00440df6 (forward)
    cmp dword ptr [0x586ded], 0x0                # 00440d5d
    jne.d32 L_00440df6                           # 00440d64
    # block 0x00440d6a: entered by fall-through of jne at 0x00440d64, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440df6
    push 0x547b38                                # 00440d6a
    push 0x63a68c                                # 00440d6f
    lea edx, [ebp - local_1ce]                   # 00440d74
    push edx                                     # 00440d7a
    call FUN_0043f210                            # 00440d7b
    add esp, 0xc                                 # 00440d80
    mov edi, 0x547b40                            # 00440d83
    lea edx, [ebp - local_3e]                    # 00440d88
    or ecx, -0x1                                 # 00440d8b
    {load} xor eax, eax                          # 00440d8e
    repne scasb al, byte ptr es:[edi]            # 00440d90
    not ecx                                      # 00440d92
    {load} sub edi, ecx                          # 00440d94
    {load} mov esi, edi                          # 00440d96
    {load} mov eax, ecx                          # 00440d98
    {load} mov edi, edx                          # 00440d9a
    shr ecx, 0x2                                 # 00440d9c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440d9f
    {load} mov ecx, eax                          # 00440da1
    and ecx, 0x3                                 # 00440da3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440da6
    mov word ptr [ebp - local_1c], 0x13c0        # 00440da8
    mov word ptr [ebp - local_1a], 0x0           # 00440dae
    mov word ptr [ebp - local_18], 0x0           # 00440db4
    mov word ptr [ebp - local_16], 0x1           # 00440dba
    mov word ptr [ebp - local_8], 0xffff         # 00440dc0
    mov byte ptr [ebp - local_6], 0x0            # 00440dc6
    mov word ptr [ebp - local_5], 0x2            # 00440dca
    mov dword ptr [ebp - local_14], 0x0          # 00440dd0
    mov dword ptr [ebp - local_10], 0x0          # 00440dd7
    mov dword ptr [ebp - local_c], 0x1           # 00440dde
    lea ecx, [ebp - local_1d4]                   # 00440de5
    push ecx                                     # 00440deb
    mov ecx, 0x6177e8                            # 00440dec
    call FUN_0041fa11                            # 00440df1
L_00440df6:
    # block 0x00440df6: entered by jne at 0x00440d4a; jne at 0x00440d57; jne at 0x00440d64, 5 instruction(s), ends with ret
    pop edi                                      # 00440df6
    pop esi                                      # 00440df7
    {load} mov esp, ebp                          # 00440df8
    pop ebp                                      # 00440dfa
    ret                                          # 00440dfb

