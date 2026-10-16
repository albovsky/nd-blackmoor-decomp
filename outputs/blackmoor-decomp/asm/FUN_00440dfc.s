# FUN_00440dfc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00440dfc
# extent:       0x00440dfc-0x004416a2 (2214 code bytes)
# span:         0x00440dfc-0x004416a2 (code 2214, tables 0, padding 0)
# sha256:       2e3044fc2bb752d80c67b958e942a3e65e260b104a0e09dda771507c3e2a2075
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00440dfc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 523 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00440dfc - 0x401000
.globl FUN_00440dfc
FUN_00440dfc:
    # block 0x00440dfc: entry, 7 instruction(s), ends with jne to 0x00440ead (forward)
    push ebp                                     # 00440dfc
    {load} mov ebp, esp                          # 00440dfd
    sub esp, 0x1d4                               # 00440dff
    push esi                                     # 00440e05
    push edi                                     # 00440e06
    cmp dword ptr [0x587095], 0x1                # 00440e07
    jne.d32 L_00440ead                           # 00440e0e
    # block 0x00440e14: entered by fall-through of jne at 0x00440e0e, 2 instruction(s), ends with jne to 0x00440ead (forward)
    cmp dword ptr [0x587295], 0x0                # 00440e14
    jne.d32 L_00440ead                           # 00440e1b
    # block 0x00440e21: entered by fall-through of jne at 0x00440e1b, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440ead
    push 0x547b48                                # 00440e21
    push 0x63a690                                # 00440e26
    lea eax, [ebp - local_1ce]                   # 00440e2b
    push eax                                     # 00440e31
    call FUN_0043f210                            # 00440e32
    add esp, 0xc                                 # 00440e37
    mov edi, 0x547b50                            # 00440e3a
    lea edx, [ebp - local_3e]                    # 00440e3f
    or ecx, -0x1                                 # 00440e42
    {load} xor eax, eax                          # 00440e45
    repne scasb al, byte ptr es:[edi]            # 00440e47
    not ecx                                      # 00440e49
    {load} sub edi, ecx                          # 00440e4b
    {load} mov esi, edi                          # 00440e4d
    {load} mov eax, ecx                          # 00440e4f
    {load} mov edi, edx                          # 00440e51
    shr ecx, 0x2                                 # 00440e53
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440e56
    {load} mov ecx, eax                          # 00440e58
    and ecx, 0x3                                 # 00440e5a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440e5d
    mov word ptr [ebp - local_1c], 0x51a         # 00440e5f
    mov word ptr [ebp - local_1a], 0x0           # 00440e65
    mov word ptr [ebp - local_18], 0x0           # 00440e6b
    mov word ptr [ebp - local_16], 0x1           # 00440e71
    mov word ptr [ebp - local_8], 0xffff         # 00440e77
    mov byte ptr [ebp - local_6], 0x0            # 00440e7d
    mov word ptr [ebp - local_5], 0x2            # 00440e81
    mov dword ptr [ebp - local_14], 0x0          # 00440e87
    mov dword ptr [ebp - local_10], 0x0          # 00440e8e
    mov dword ptr [ebp - local_c], 0x1           # 00440e95
    lea ecx, [ebp - local_1d4]                   # 00440e9c
    push ecx                                     # 00440ea2
    mov ecx, 0x6177e8                            # 00440ea3
    call FUN_0041fa11                            # 00440ea8
L_00440ead:
    # block 0x00440ead: entered by jne at 0x00440e0e; jne at 0x00440e1b, 2 instruction(s), ends with jne to 0x00440f53 (forward)
    cmp dword ptr [0x587549], 0x1                # 00440ead
    jne.d32 L_00440f53                           # 00440eb4
    # block 0x00440eba: entered by fall-through of jne at 0x00440eb4, 2 instruction(s), ends with jne to 0x00440f53 (forward)
    cmp dword ptr [0x58728d], 0x0                # 00440eba
    jne.d32 L_00440f53                           # 00440ec1
    # block 0x00440ec7: entered by fall-through of jne at 0x00440ec1, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440f53
    push 0x547b58                                # 00440ec7
    push 0x63a694                                # 00440ecc
    lea edx, [ebp - local_1ce]                   # 00440ed1
    push edx                                     # 00440ed7
    call FUN_0043f210                            # 00440ed8
    add esp, 0xc                                 # 00440edd
    mov edi, 0x547b60                            # 00440ee0
    lea edx, [ebp - local_3e]                    # 00440ee5
    or ecx, -0x1                                 # 00440ee8
    {load} xor eax, eax                          # 00440eeb
    repne scasb al, byte ptr es:[edi]            # 00440eed
    not ecx                                      # 00440eef
    {load} sub edi, ecx                          # 00440ef1
    {load} mov esi, edi                          # 00440ef3
    {load} mov eax, ecx                          # 00440ef5
    {load} mov edi, edx                          # 00440ef7
    shr ecx, 0x2                                 # 00440ef9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440efc
    {load} mov ecx, eax                          # 00440efe
    and ecx, 0x3                                 # 00440f00
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440f03
    mov word ptr [ebp - local_1c], 0x521         # 00440f05
    mov word ptr [ebp - local_1a], 0x0           # 00440f0b
    mov word ptr [ebp - local_18], 0x0           # 00440f11
    mov word ptr [ebp - local_16], 0x1           # 00440f17
    mov word ptr [ebp - local_8], 0xffff         # 00440f1d
    mov byte ptr [ebp - local_6], 0x0            # 00440f23
    mov word ptr [ebp - local_5], 0x2            # 00440f27
    mov dword ptr [ebp - local_14], 0x0          # 00440f2d
    mov dword ptr [ebp - local_10], 0x0          # 00440f34
    mov dword ptr [ebp - local_c], 0x1           # 00440f3b
    lea ecx, [ebp - local_1d4]                   # 00440f42
    push ecx                                     # 00440f48
    mov ecx, 0x6177e8                            # 00440f49
    call FUN_0041fa11                            # 00440f4e
L_00440f53:
    # block 0x00440f53: entered by jne at 0x00440eb4; jne at 0x00440ec1, 2 instruction(s), ends with jne to 0x00440ff9 (forward)
    cmp dword ptr [0x587095], 0x1                # 00440f53
    jne.d32 L_00440ff9                           # 00440f5a
    # block 0x00440f60: entered by fall-through of jne at 0x00440f5a, 2 instruction(s), ends with jne to 0x00440ff9 (forward)
    cmp dword ptr [0x5872a1], 0x0                # 00440f60
    jne.d32 L_00440ff9                           # 00440f67
    # block 0x00440f6d: entered by fall-through of jne at 0x00440f67, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00440ff9
    push 0x547b68                                # 00440f6d
    push 0x63a698                                # 00440f72
    lea edx, [ebp - local_1ce]                   # 00440f77
    push edx                                     # 00440f7d
    call FUN_0043f210                            # 00440f7e
    add esp, 0xc                                 # 00440f83
    mov edi, 0x547b70                            # 00440f86
    lea edx, [ebp - local_3e]                    # 00440f8b
    or ecx, -0x1                                 # 00440f8e
    {load} xor eax, eax                          # 00440f91
    repne scasb al, byte ptr es:[edi]            # 00440f93
    not ecx                                      # 00440f95
    {load} sub edi, ecx                          # 00440f97
    {load} mov esi, edi                          # 00440f99
    {load} mov eax, ecx                          # 00440f9b
    {load} mov edi, edx                          # 00440f9d
    shr ecx, 0x2                                 # 00440f9f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00440fa2
    {load} mov ecx, eax                          # 00440fa4
    and ecx, 0x3                                 # 00440fa6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00440fa9
    mov word ptr [ebp - local_1c], 0x523         # 00440fab
    mov word ptr [ebp - local_1a], 0x0           # 00440fb1
    mov word ptr [ebp - local_18], 0x0           # 00440fb7
    mov word ptr [ebp - local_16], 0x1           # 00440fbd
    mov word ptr [ebp - local_8], 0xffff         # 00440fc3
    mov byte ptr [ebp - local_6], 0x0            # 00440fc9
    mov word ptr [ebp - local_5], 0x2            # 00440fcd
    mov dword ptr [ebp - local_14], 0x0          # 00440fd3
    mov dword ptr [ebp - local_10], 0x0          # 00440fda
    mov dword ptr [ebp - local_c], 0x1           # 00440fe1
    lea ecx, [ebp - local_1d4]                   # 00440fe8
    push ecx                                     # 00440fee
    mov ecx, 0x6177e8                            # 00440fef
    call FUN_0041fa11                            # 00440ff4
L_00440ff9:
    # block 0x00440ff9: entered by jne at 0x00440f5a; jne at 0x00440f67, 2 instruction(s), ends with jne to 0x0044109f (forward)
    cmp dword ptr [0x587295], 0x1                # 00440ff9
    jne.d32 L_0044109f                           # 00441000
    # block 0x00441006: entered by fall-through of jne at 0x00441000, 2 instruction(s), ends with jne to 0x0044109f (forward)
    cmp dword ptr [0x587235], 0x0                # 00441006
    jne.d32 L_0044109f                           # 0044100d
    # block 0x00441013: entered by fall-through of jne at 0x0044100d, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044109f
    push 0x547b78                                # 00441013
    push 0x63a69c                                # 00441018
    lea edx, [ebp - local_1ce]                   # 0044101d
    push edx                                     # 00441023
    call FUN_0043f210                            # 00441024
    add esp, 0xc                                 # 00441029
    mov edi, 0x547b80                            # 0044102c
    lea edx, [ebp - local_3e]                    # 00441031
    or ecx, -0x1                                 # 00441034
    {load} xor eax, eax                          # 00441037
    repne scasb al, byte ptr es:[edi]            # 00441039
    not ecx                                      # 0044103b
    {load} sub edi, ecx                          # 0044103d
    {load} mov esi, edi                          # 0044103f
    {load} mov eax, ecx                          # 00441041
    {load} mov edi, edx                          # 00441043
    shr ecx, 0x2                                 # 00441045
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441048
    {load} mov ecx, eax                          # 0044104a
    and ecx, 0x3                                 # 0044104c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044104f
    mov word ptr [ebp - local_1c], 0x525         # 00441051
    mov word ptr [ebp - local_1a], 0x0           # 00441057
    mov word ptr [ebp - local_18], 0x0           # 0044105d
    mov word ptr [ebp - local_16], 0x1           # 00441063
    mov word ptr [ebp - local_8], 0xffff         # 00441069
    mov byte ptr [ebp - local_6], 0x0            # 0044106f
    mov word ptr [ebp - local_5], 0x2            # 00441073
    mov dword ptr [ebp - local_14], 0x0          # 00441079
    mov dword ptr [ebp - local_10], 0x0          # 00441080
    mov dword ptr [ebp - local_c], 0x1           # 00441087
    lea ecx, [ebp - local_1d4]                   # 0044108e
    push ecx                                     # 00441094
    mov ecx, 0x6177e8                            # 00441095
    call FUN_0041fa11                            # 0044109a
L_0044109f:
    # block 0x0044109f: entered by jne at 0x00441000; jne at 0x0044100d, 2 instruction(s), ends with jne to 0x00441145 (forward)
    cmp dword ptr [0x587095], 0x1                # 0044109f
    jne.d32 L_00441145                           # 004410a6
    # block 0x004410ac: entered by fall-through of jne at 0x004410a6, 2 instruction(s), ends with jne to 0x00441145 (forward)
    cmp dword ptr [0x587235], 0x0                # 004410ac
    jne.d32 L_00441145                           # 004410b3
    # block 0x004410b9: entered by fall-through of jne at 0x004410b3, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441145
    push 0x547b88                                # 004410b9
    push 0x63a6a0                                # 004410be
    lea edx, [ebp - local_1ce]                   # 004410c3
    push edx                                     # 004410c9
    call FUN_0043f210                            # 004410ca
    add esp, 0xc                                 # 004410cf
    mov edi, 0x547b90                            # 004410d2
    lea edx, [ebp - local_3e]                    # 004410d7
    or ecx, -0x1                                 # 004410da
    {load} xor eax, eax                          # 004410dd
    repne scasb al, byte ptr es:[edi]            # 004410df
    not ecx                                      # 004410e1
    {load} sub edi, ecx                          # 004410e3
    {load} mov esi, edi                          # 004410e5
    {load} mov eax, ecx                          # 004410e7
    {load} mov edi, edx                          # 004410e9
    shr ecx, 0x2                                 # 004410eb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004410ee
    {load} mov ecx, eax                          # 004410f0
    and ecx, 0x3                                 # 004410f2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004410f5
    mov word ptr [ebp - local_1c], 0x546         # 004410f7
    mov word ptr [ebp - local_1a], 0x0           # 004410fd
    mov word ptr [ebp - local_18], 0x0           # 00441103
    mov word ptr [ebp - local_16], 0x1           # 00441109
    mov word ptr [ebp - local_8], 0xffff         # 0044110f
    mov byte ptr [ebp - local_6], 0x0            # 00441115
    mov word ptr [ebp - local_5], 0x2            # 00441119
    mov dword ptr [ebp - local_14], 0x0          # 0044111f
    mov dword ptr [ebp - local_10], 0x0          # 00441126
    mov dword ptr [ebp - local_c], 0x1           # 0044112d
    lea ecx, [ebp - local_1d4]                   # 00441134
    push ecx                                     # 0044113a
    mov ecx, 0x6177e8                            # 0044113b
    call FUN_0041fa11                            # 00441140
L_00441145:
    # block 0x00441145: entered by jne at 0x004410a6; jne at 0x004410b3, 2 instruction(s), ends with jne to 0x004411eb (forward)
    cmp dword ptr [0x58763d], 0x1                # 00441145
    jne.d32 L_004411eb                           # 0044114c
    # block 0x00441152: entered by fall-through of jne at 0x0044114c, 2 instruction(s), ends with jne to 0x004411eb (forward)
    cmp dword ptr [0x587289], 0x0                # 00441152
    jne.d32 L_004411eb                           # 00441159
    # block 0x0044115f: entered by fall-through of jne at 0x00441159, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004411eb
    push 0x547b98                                # 0044115f
    push 0x63a6a4                                # 00441164
    lea edx, [ebp - local_1ce]                   # 00441169
    push edx                                     # 0044116f
    call FUN_0043f210                            # 00441170
    add esp, 0xc                                 # 00441175
    mov edi, 0x547ba0                            # 00441178
    lea edx, [ebp - local_3e]                    # 0044117d
    or ecx, -0x1                                 # 00441180
    {load} xor eax, eax                          # 00441183
    repne scasb al, byte ptr es:[edi]            # 00441185
    not ecx                                      # 00441187
    {load} sub edi, ecx                          # 00441189
    {load} mov esi, edi                          # 0044118b
    {load} mov eax, ecx                          # 0044118d
    {load} mov edi, edx                          # 0044118f
    shr ecx, 0x2                                 # 00441191
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441194
    {load} mov ecx, eax                          # 00441196
    and ecx, 0x3                                 # 00441198
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044119b
    mov word ptr [ebp - local_1c], 0x548         # 0044119d
    mov word ptr [ebp - local_1a], 0x0           # 004411a3
    mov word ptr [ebp - local_18], 0x0           # 004411a9
    mov word ptr [ebp - local_16], 0x1           # 004411af
    mov word ptr [ebp - local_8], 0xffff         # 004411b5
    mov byte ptr [ebp - local_6], 0x0            # 004411bb
    mov word ptr [ebp - local_5], 0x2            # 004411bf
    mov dword ptr [ebp - local_14], 0x0          # 004411c5
    mov dword ptr [ebp - local_10], 0x0          # 004411cc
    mov dword ptr [ebp - local_c], 0x1           # 004411d3
    lea ecx, [ebp - local_1d4]                   # 004411da
    push ecx                                     # 004411e0
    mov ecx, 0x6177e8                            # 004411e1
    call FUN_0041fa11                            # 004411e6
L_004411eb:
    # block 0x004411eb: entered by jne at 0x0044114c; jne at 0x00441159, 2 instruction(s), ends with jne to 0x0044129e (forward)
    cmp dword ptr [0x58751d], 0x1                # 004411eb
    jne.d32 L_0044129e                           # 004411f2
    # block 0x004411f8: entered by fall-through of jne at 0x004411f2, 2 instruction(s), ends with jne to 0x0044129e (forward)
    cmp dword ptr [0x587839], 0x1                # 004411f8
    jne.d32 L_0044129e                           # 004411ff
    # block 0x00441205: entered by fall-through of jne at 0x004411ff, 2 instruction(s), ends with jne to 0x0044129e (forward)
    cmp dword ptr [0x58723d], 0x0                # 00441205
    jne.d32 L_0044129e                           # 0044120c
    # block 0x00441212: entered by fall-through of jne at 0x0044120c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044129e
    push 0x547ba8                                # 00441212
    push 0x63a6a8                                # 00441217
    lea edx, [ebp - local_1ce]                   # 0044121c
    push edx                                     # 00441222
    call FUN_0043f210                            # 00441223
    add esp, 0xc                                 # 00441228
    mov edi, 0x547bb0                            # 0044122b
    lea edx, [ebp - local_3e]                    # 00441230
    or ecx, -0x1                                 # 00441233
    {load} xor eax, eax                          # 00441236
    repne scasb al, byte ptr es:[edi]            # 00441238
    not ecx                                      # 0044123a
    {load} sub edi, ecx                          # 0044123c
    {load} mov esi, edi                          # 0044123e
    {load} mov eax, ecx                          # 00441240
    {load} mov edi, edx                          # 00441242
    shr ecx, 0x2                                 # 00441244
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441247
    {load} mov ecx, eax                          # 00441249
    and ecx, 0x3                                 # 0044124b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044124e
    mov word ptr [ebp - local_1c], 0x549         # 00441250
    mov word ptr [ebp - local_1a], 0x0           # 00441256
    mov word ptr [ebp - local_18], 0x0           # 0044125c
    mov word ptr [ebp - local_16], 0x1           # 00441262
    mov word ptr [ebp - local_8], 0xffff         # 00441268
    mov byte ptr [ebp - local_6], 0x0            # 0044126e
    mov word ptr [ebp - local_5], 0x2            # 00441272
    mov dword ptr [ebp - local_14], 0x0          # 00441278
    mov dword ptr [ebp - local_10], 0x0          # 0044127f
    mov dword ptr [ebp - local_c], 0x1           # 00441286
    lea ecx, [ebp - local_1d4]                   # 0044128d
    push ecx                                     # 00441293
    mov ecx, 0x6177e8                            # 00441294
    call FUN_0041fa11                            # 00441299
L_0044129e:
    # block 0x0044129e: entered by jne at 0x004411f2; jne at 0x004411ff; jne at 0x0044120c, 2 instruction(s), ends with jne to 0x00441344 (forward)
    cmp dword ptr [0x58725d], 0x1                # 0044129e
    jne.d32 L_00441344                           # 004412a5
    # block 0x004412ab: entered by fall-through of jne at 0x004412a5, 2 instruction(s), ends with jne to 0x00441344 (forward)
    cmp dword ptr [0x587779], 0x0                # 004412ab
    jne.d32 L_00441344                           # 004412b2
    # block 0x004412b8: entered by fall-through of jne at 0x004412b2, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441344
    push 0x547bb8                                # 004412b8
    push 0x63a6ac                                # 004412bd
    lea edx, [ebp - local_1ce]                   # 004412c2
    push edx                                     # 004412c8
    call FUN_0043f210                            # 004412c9
    add esp, 0xc                                 # 004412ce
    mov edi, 0x547bc0                            # 004412d1
    lea edx, [ebp - local_3e]                    # 004412d6
    or ecx, -0x1                                 # 004412d9
    {load} xor eax, eax                          # 004412dc
    repne scasb al, byte ptr es:[edi]            # 004412de
    not ecx                                      # 004412e0
    {load} sub edi, ecx                          # 004412e2
    {load} mov esi, edi                          # 004412e4
    {load} mov eax, ecx                          # 004412e6
    {load} mov edi, edx                          # 004412e8
    shr ecx, 0x2                                 # 004412ea
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004412ed
    {load} mov ecx, eax                          # 004412ef
    and ecx, 0x3                                 # 004412f1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004412f4
    mov word ptr [ebp - local_1c], 0x555         # 004412f6
    mov word ptr [ebp - local_1a], 0x0           # 004412fc
    mov word ptr [ebp - local_18], 0x0           # 00441302
    mov word ptr [ebp - local_16], 0x1           # 00441308
    mov word ptr [ebp - local_8], 0xffff         # 0044130e
    mov byte ptr [ebp - local_6], 0x0            # 00441314
    mov word ptr [ebp - local_5], 0x2            # 00441318
    mov dword ptr [ebp - local_14], 0x0          # 0044131e
    mov dword ptr [ebp - local_10], 0x0          # 00441325
    mov dword ptr [ebp - local_c], 0x1           # 0044132c
    lea ecx, [ebp - local_1d4]                   # 00441333
    push ecx                                     # 00441339
    mov ecx, 0x6177e8                            # 0044133a
    call FUN_0041fa11                            # 0044133f
L_00441344:
    # block 0x00441344: entered by jne at 0x004412a5; jne at 0x004412b2, 2 instruction(s), ends with jne to 0x004413f7 (forward)
    cmp dword ptr [0x58725d], 0x1                # 00441344
    jne.d32 L_004413f7                           # 0044134b
    # block 0x00441351: entered by fall-through of jne at 0x0044134b, 2 instruction(s), ends with jne to 0x004413f7 (forward)
    cmp dword ptr [0x587645], 0x1                # 00441351
    jne.d32 L_004413f7                           # 00441358
    # block 0x0044135e: entered by fall-through of jne at 0x00441358, 2 instruction(s), ends with jne to 0x004413f7 (forward)
    cmp dword ptr [0x587255], 0x0                # 0044135e
    jne.d32 L_004413f7                           # 00441365
    # block 0x0044136b: entered by fall-through of jne at 0x00441365, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004413f7
    push 0x547bc8                                # 0044136b
    push 0x63a6b0                                # 00441370
    lea edx, [ebp - local_1ce]                   # 00441375
    push edx                                     # 0044137b
    call FUN_0043f210                            # 0044137c
    add esp, 0xc                                 # 00441381
    mov edi, 0x547bd0                            # 00441384
    lea edx, [ebp - local_3e]                    # 00441389
    or ecx, -0x1                                 # 0044138c
    {load} xor eax, eax                          # 0044138f
    repne scasb al, byte ptr es:[edi]            # 00441391
    not ecx                                      # 00441393
    {load} sub edi, ecx                          # 00441395
    {load} mov esi, edi                          # 00441397
    {load} mov eax, ecx                          # 00441399
    {load} mov edi, edx                          # 0044139b
    shr ecx, 0x2                                 # 0044139d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004413a0
    {load} mov ecx, eax                          # 004413a2
    and ecx, 0x3                                 # 004413a4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004413a7
    mov word ptr [ebp - local_1c], 0x557         # 004413a9
    mov word ptr [ebp - local_1a], 0x0           # 004413af
    mov word ptr [ebp - local_18], 0x0           # 004413b5
    mov word ptr [ebp - local_16], 0x1           # 004413bb
    mov word ptr [ebp - local_8], 0xffff         # 004413c1
    mov byte ptr [ebp - local_6], 0x0            # 004413c7
    mov word ptr [ebp - local_5], 0x2            # 004413cb
    mov dword ptr [ebp - local_14], 0x0          # 004413d1
    mov dword ptr [ebp - local_10], 0x0          # 004413d8
    mov dword ptr [ebp - local_c], 0x1           # 004413df
    lea ecx, [ebp - local_1d4]                   # 004413e6
    push ecx                                     # 004413ec
    mov ecx, 0x6177e8                            # 004413ed
    call FUN_0041fa11                            # 004413f2
L_004413f7:
    # block 0x004413f7: entered by jne at 0x0044134b; jne at 0x00441358; jne at 0x00441365, 2 instruction(s), ends with jne to 0x004414aa (forward)
    cmp dword ptr [0x587665], 0x1                # 004413f7
    jne.d32 L_004414aa                           # 004413fe
    # block 0x00441404: entered by fall-through of jne at 0x004413fe, 2 instruction(s), ends with jne to 0x004414aa (forward)
    cmp dword ptr [0x58774d], 0x0                # 00441404
    jne.d32 L_004414aa                           # 0044140b
    # block 0x00441411: entered by fall-through of jne at 0x0044140b, 2 instruction(s), ends with jne to 0x004414aa (forward)
    cmp dword ptr [0x587291], 0x0                # 00441411
    jne.d32 L_004414aa                           # 00441418
    # block 0x0044141e: entered by fall-through of jne at 0x00441418, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004414aa
    push 0x547bd8                                # 0044141e
    push 0x63a6b4                                # 00441423
    lea edx, [ebp - local_1ce]                   # 00441428
    push edx                                     # 0044142e
    call FUN_0043f210                            # 0044142f
    add esp, 0xc                                 # 00441434
    mov edi, 0x547be0                            # 00441437
    lea edx, [ebp - local_3e]                    # 0044143c
    or ecx, -0x1                                 # 0044143f
    {load} xor eax, eax                          # 00441442
    repne scasb al, byte ptr es:[edi]            # 00441444
    not ecx                                      # 00441446
    {load} sub edi, ecx                          # 00441448
    {load} mov esi, edi                          # 0044144a
    {load} mov eax, ecx                          # 0044144c
    {load} mov edi, edx                          # 0044144e
    shr ecx, 0x2                                 # 00441450
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441453
    {load} mov ecx, eax                          # 00441455
    and ecx, 0x3                                 # 00441457
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044145a
    mov word ptr [ebp - local_1c], 0x55a         # 0044145c
    mov word ptr [ebp - local_1a], 0x0           # 00441462
    mov word ptr [ebp - local_18], 0x0           # 00441468
    mov word ptr [ebp - local_16], 0x1           # 0044146e
    mov word ptr [ebp - local_8], 0xffff         # 00441474
    mov byte ptr [ebp - local_6], 0x0            # 0044147a
    mov word ptr [ebp - local_5], 0x2            # 0044147e
    mov dword ptr [ebp - local_14], 0x0          # 00441484
    mov dword ptr [ebp - local_10], 0x0          # 0044148b
    mov dword ptr [ebp - local_c], 0x1           # 00441492
    lea ecx, [ebp - local_1d4]                   # 00441499
    push ecx                                     # 0044149f
    mov ecx, 0x6177e8                            # 004414a0
    call FUN_0041fa11                            # 004414a5
L_004414aa:
    # block 0x004414aa: entered by jne at 0x004413fe; jne at 0x0044140b; jne at 0x00441418, 2 instruction(s), ends with jne to 0x00441550 (forward)
    cmp dword ptr [0x587609], 0x1                # 004414aa
    jne.d32 L_00441550                           # 004414b1
    # block 0x004414b7: entered by fall-through of jne at 0x004414b1, 2 instruction(s), ends with jne to 0x00441550 (forward)
    cmp dword ptr [0x587279], 0x0                # 004414b7
    jne.d32 L_00441550                           # 004414be
    # block 0x004414c4: entered by fall-through of jne at 0x004414be, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441550
    push 0x547be8                                # 004414c4
    push 0x63a6b8                                # 004414c9
    lea edx, [ebp - local_1ce]                   # 004414ce
    push edx                                     # 004414d4
    call FUN_0043f210                            # 004414d5
    add esp, 0xc                                 # 004414da
    mov edi, 0x547bf0                            # 004414dd
    lea edx, [ebp - local_3e]                    # 004414e2
    or ecx, -0x1                                 # 004414e5
    {load} xor eax, eax                          # 004414e8
    repne scasb al, byte ptr es:[edi]            # 004414ea
    not ecx                                      # 004414ec
    {load} sub edi, ecx                          # 004414ee
    {load} mov esi, edi                          # 004414f0
    {load} mov eax, ecx                          # 004414f2
    {load} mov edi, edx                          # 004414f4
    shr ecx, 0x2                                 # 004414f6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004414f9
    {load} mov ecx, eax                          # 004414fb
    and ecx, 0x3                                 # 004414fd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441500
    mov word ptr [ebp - local_1c], 0x55b         # 00441502
    mov word ptr [ebp - local_1a], 0x0           # 00441508
    mov word ptr [ebp - local_18], 0x0           # 0044150e
    mov word ptr [ebp - local_16], 0x1           # 00441514
    mov word ptr [ebp - local_8], 0xffff         # 0044151a
    mov byte ptr [ebp - local_6], 0x0            # 00441520
    mov word ptr [ebp - local_5], 0x2            # 00441524
    mov dword ptr [ebp - local_14], 0x0          # 0044152a
    mov dword ptr [ebp - local_10], 0x0          # 00441531
    mov dword ptr [ebp - local_c], 0x1           # 00441538
    lea ecx, [ebp - local_1d4]                   # 0044153f
    push ecx                                     # 00441545
    mov ecx, 0x6177e8                            # 00441546
    call FUN_0041fa11                            # 0044154b
L_00441550:
    # block 0x00441550: entered by jne at 0x004414b1; jne at 0x004414be, 2 instruction(s), ends with jne to 0x004415f6 (forward)
    cmp dword ptr [0x5875b5], 0x1                # 00441550
    jne.d32 L_004415f6                           # 00441557
    # block 0x0044155d: entered by fall-through of jne at 0x00441557, 2 instruction(s), ends with jne to 0x004415f6 (forward)
    cmp dword ptr [0x587269], 0x0                # 0044155d
    jne.d32 L_004415f6                           # 00441564
    # block 0x0044156a: entered by fall-through of jne at 0x00441564, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004415f6
    push 0x547bf8                                # 0044156a
    push 0x63a6bc                                # 0044156f
    lea edx, [ebp - local_1ce]                   # 00441574
    push edx                                     # 0044157a
    call FUN_0043f210                            # 0044157b
    add esp, 0xc                                 # 00441580
    mov edi, 0x547c00                            # 00441583
    lea edx, [ebp - local_3e]                    # 00441588
    or ecx, -0x1                                 # 0044158b
    {load} xor eax, eax                          # 0044158e
    repne scasb al, byte ptr es:[edi]            # 00441590
    not ecx                                      # 00441592
    {load} sub edi, ecx                          # 00441594
    {load} mov esi, edi                          # 00441596
    {load} mov eax, ecx                          # 00441598
    {load} mov edi, edx                          # 0044159a
    shr ecx, 0x2                                 # 0044159c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044159f
    {load} mov ecx, eax                          # 004415a1
    and ecx, 0x3                                 # 004415a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004415a6
    mov word ptr [ebp - local_1c], 0x55c         # 004415a8
    mov word ptr [ebp - local_1a], 0x0           # 004415ae
    mov word ptr [ebp - local_18], 0x0           # 004415b4
    mov word ptr [ebp - local_16], 0x1           # 004415ba
    mov word ptr [ebp - local_8], 0xffff         # 004415c0
    mov byte ptr [ebp - local_6], 0x0            # 004415c6
    mov word ptr [ebp - local_5], 0x2            # 004415ca
    mov dword ptr [ebp - local_14], 0x0          # 004415d0
    mov dword ptr [ebp - local_10], 0x0          # 004415d7
    mov dword ptr [ebp - local_c], 0x1           # 004415de
    lea ecx, [ebp - local_1d4]                   # 004415e5
    push ecx                                     # 004415eb
    mov ecx, 0x6177e8                            # 004415ec
    call FUN_0041fa11                            # 004415f1
L_004415f6:
    # block 0x004415f6: entered by jne at 0x00441557; jne at 0x00441564, 2 instruction(s), ends with jne to 0x0044169c (forward)
    cmp dword ptr [0x58706d], 0x1                # 004415f6
    jne.d32 L_0044169c                           # 004415fd
    # block 0x00441603: entered by fall-through of jne at 0x004415fd, 2 instruction(s), ends with jne to 0x0044169c (forward)
    cmp dword ptr [0x58724d], 0x0                # 00441603
    jne.d32 L_0044169c                           # 0044160a
    # block 0x00441610: entered by fall-through of jne at 0x0044160a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044169c
    push 0x547c08                                # 00441610
    push 0x63a6c0                                # 00441615
    lea edx, [ebp - local_1ce]                   # 0044161a
    push edx                                     # 00441620
    call FUN_0043f210                            # 00441621
    add esp, 0xc                                 # 00441626
    mov edi, 0x547c10                            # 00441629
    lea edx, [ebp - local_3e]                    # 0044162e
    or ecx, -0x1                                 # 00441631
    {load} xor eax, eax                          # 00441634
    repne scasb al, byte ptr es:[edi]            # 00441636
    not ecx                                      # 00441638
    {load} sub edi, ecx                          # 0044163a
    {load} mov esi, edi                          # 0044163c
    {load} mov eax, ecx                          # 0044163e
    {load} mov edi, edx                          # 00441640
    shr ecx, 0x2                                 # 00441642
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441645
    {load} mov ecx, eax                          # 00441647
    and ecx, 0x3                                 # 00441649
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044164c
    mov word ptr [ebp - local_1c], 0x55d         # 0044164e
    mov word ptr [ebp - local_1a], 0x0           # 00441654
    mov word ptr [ebp - local_18], 0x0           # 0044165a
    mov word ptr [ebp - local_16], 0x1           # 00441660
    mov word ptr [ebp - local_8], 0xffff         # 00441666
    mov byte ptr [ebp - local_6], 0x0            # 0044166c
    mov word ptr [ebp - local_5], 0x2            # 00441670
    mov dword ptr [ebp - local_14], 0x0          # 00441676
    mov dword ptr [ebp - local_10], 0x0          # 0044167d
    mov dword ptr [ebp - local_c], 0x1           # 00441684
    lea ecx, [ebp - local_1d4]                   # 0044168b
    push ecx                                     # 00441691
    mov ecx, 0x6177e8                            # 00441692
    call FUN_0041fa11                            # 00441697
L_0044169c:
    # block 0x0044169c: entered by jne at 0x004415fd; jne at 0x0044160a, 5 instruction(s), ends with ret
    pop edi                                      # 0044169c
    pop esi                                      # 0044169d
    {load} mov esp, ebp                          # 0044169e
    pop ebp                                      # 004416a0
    ret                                          # 004416a1

