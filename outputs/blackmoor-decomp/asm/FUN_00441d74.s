# FUN_00441d74
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00441d74
# extent:       0x00441d74-0x00443ad8 (7524 code bytes)
# span:         0x00441d74-0x00443ad8 (code 7524, tables 0, padding 0)
# sha256:       8d53dfea528e77c9e7c4b96bd1d8e55bedd37e0c8c879c573d62ea3b1251bbe0
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00441d74
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1761 instruction(s), 105 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00441d74 - 0x401000
.globl FUN_00441d74
FUN_00441d74:
    # block 0x00441d74: entry, 7 instruction(s), ends with jne to 0x00441e25 (forward)
    push ebp                                     # 00441d74
    {load} mov ebp, esp                          # 00441d75
    sub esp, 0x1d4                               # 00441d77
    push esi                                     # 00441d7d
    push edi                                     # 00441d7e
    cmp dword ptr [0x5874b1], 0x1                # 00441d7f
    jne.d32 L_00441e25                           # 00441d86
    # block 0x00441d8c: entered by fall-through of jne at 0x00441d86, 2 instruction(s), ends with jne to 0x00441e25 (forward)
    cmp dword ptr [0x586eed], 0x0                # 00441d8c
    jne.d32 L_00441e25                           # 00441d93
    # block 0x00441d99: entered by fall-through of jne at 0x00441d93, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441e25
    push 0x547cb8                                # 00441d99
    push 0x63a6ec                                # 00441d9e
    lea eax, [ebp - local_1ce]                   # 00441da3
    push eax                                     # 00441da9
    call FUN_0043f210                            # 00441daa
    add esp, 0xc                                 # 00441daf
    mov edi, 0x547cc0                            # 00441db2
    lea edx, [ebp - local_3e]                    # 00441db7
    or ecx, -0x1                                 # 00441dba
    {load} xor eax, eax                          # 00441dbd
    repne scasb al, byte ptr es:[edi]            # 00441dbf
    not ecx                                      # 00441dc1
    {load} sub edi, ecx                          # 00441dc3
    {load} mov esi, edi                          # 00441dc5
    {load} mov eax, ecx                          # 00441dc7
    {load} mov edi, edx                          # 00441dc9
    shr ecx, 0x2                                 # 00441dcb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441dce
    {load} mov ecx, eax                          # 00441dd0
    and ecx, 0x3                                 # 00441dd2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441dd5
    mov word ptr [ebp - local_1c], 0x610         # 00441dd7
    mov word ptr [ebp - local_1a], 0x0           # 00441ddd
    mov word ptr [ebp - local_18], 0x0           # 00441de3
    mov word ptr [ebp - local_16], 0x1           # 00441de9
    mov word ptr [ebp - local_8], 0xffff         # 00441def
    mov byte ptr [ebp - local_6], 0x0            # 00441df5
    mov word ptr [ebp - local_5], 0x2            # 00441df9
    mov dword ptr [ebp - local_14], 0x0          # 00441dff
    mov dword ptr [ebp - local_10], 0x0          # 00441e06
    mov dword ptr [ebp - local_c], 0x1           # 00441e0d
    lea ecx, [ebp - local_1d4]                   # 00441e14
    push ecx                                     # 00441e1a
    mov ecx, 0x6177e8                            # 00441e1b
    call FUN_0041fa11                            # 00441e20
L_00441e25:
    # block 0x00441e25: entered by jne at 0x00441d86; jne at 0x00441d93, 2 instruction(s), ends with jne to 0x00441ecb (forward)
    cmp dword ptr [0x586fd9], 0x1                # 00441e25
    jne.d32 L_00441ecb                           # 00441e2c
    # block 0x00441e32: entered by fall-through of jne at 0x00441e2c, 2 instruction(s), ends with jne to 0x00441ecb (forward)
    cmp dword ptr [0x5873b9], 0x0                # 00441e32
    jne.d32 L_00441ecb                           # 00441e39
    # block 0x00441e3f: entered by fall-through of jne at 0x00441e39, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441ecb
    push 0x547cc8                                # 00441e3f
    push 0x63a6f0                                # 00441e44
    lea edx, [ebp - local_1ce]                   # 00441e49
    push edx                                     # 00441e4f
    call FUN_0043f210                            # 00441e50
    add esp, 0xc                                 # 00441e55
    mov edi, 0x547cd0                            # 00441e58
    lea edx, [ebp - local_3e]                    # 00441e5d
    or ecx, -0x1                                 # 00441e60
    {load} xor eax, eax                          # 00441e63
    repne scasb al, byte ptr es:[edi]            # 00441e65
    not ecx                                      # 00441e67
    {load} sub edi, ecx                          # 00441e69
    {load} mov esi, edi                          # 00441e6b
    {load} mov eax, ecx                          # 00441e6d
    {load} mov edi, edx                          # 00441e6f
    shr ecx, 0x2                                 # 00441e71
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441e74
    {load} mov ecx, eax                          # 00441e76
    and ecx, 0x3                                 # 00441e78
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441e7b
    mov word ptr [ebp - local_1c], 0x614         # 00441e7d
    mov word ptr [ebp - local_1a], 0x0           # 00441e83
    mov word ptr [ebp - local_18], 0x0           # 00441e89
    mov word ptr [ebp - local_16], 0x1           # 00441e8f
    mov word ptr [ebp - local_8], 0xffff         # 00441e95
    mov byte ptr [ebp - local_6], 0x0            # 00441e9b
    mov word ptr [ebp - local_5], 0x2            # 00441e9f
    mov dword ptr [ebp - local_14], 0x0          # 00441ea5
    mov dword ptr [ebp - local_10], 0x0          # 00441eac
    mov dword ptr [ebp - local_c], 0x1           # 00441eb3
    lea ecx, [ebp - local_1d4]                   # 00441eba
    push ecx                                     # 00441ec0
    mov ecx, 0x6177e8                            # 00441ec1
    call FUN_0041fa11                            # 00441ec6
L_00441ecb:
    # block 0x00441ecb: entered by jne at 0x00441e2c; jne at 0x00441e39, 2 instruction(s), ends with jne to 0x00441f8b (forward)
    cmp dword ptr [0x587631], 0x1                # 00441ecb
    jne.d32 L_00441f8b                           # 00441ed2
    # block 0x00441ed8: entered by fall-through of jne at 0x00441ed2, 2 instruction(s), ends with jne to 0x00441f8b (forward)
    cmp dword ptr [0x5876bd], 0x0                # 00441ed8
    jne.d32 L_00441f8b                           # 00441edf
    # block 0x00441ee5: entered by fall-through of jne at 0x00441edf, 2 instruction(s), ends with jne to 0x00441f8b (forward)
    cmp dword ptr [0x586e9d], 0x0                # 00441ee5
    jne.d32 L_00441f8b                           # 00441eec
    # block 0x00441ef2: entered by fall-through of jne at 0x00441eec, 2 instruction(s), ends with jne to 0x00441f8b (forward)
    cmp dword ptr [0x586f3d], 0x0                # 00441ef2
    jne.d32 L_00441f8b                           # 00441ef9
    # block 0x00441eff: entered by fall-through of jne at 0x00441ef9, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441f8b
    push 0x547cd8                                # 00441eff
    push 0x63a6f4                                # 00441f04
    lea edx, [ebp - local_1ce]                   # 00441f09
    push edx                                     # 00441f0f
    call FUN_0043f210                            # 00441f10
    add esp, 0xc                                 # 00441f15
    mov edi, 0x547ce0                            # 00441f18
    lea edx, [ebp - local_3e]                    # 00441f1d
    or ecx, -0x1                                 # 00441f20
    {load} xor eax, eax                          # 00441f23
    repne scasb al, byte ptr es:[edi]            # 00441f25
    not ecx                                      # 00441f27
    {load} sub edi, ecx                          # 00441f29
    {load} mov esi, edi                          # 00441f2b
    {load} mov eax, ecx                          # 00441f2d
    {load} mov edi, edx                          # 00441f2f
    shr ecx, 0x2                                 # 00441f31
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441f34
    {load} mov ecx, eax                          # 00441f36
    and ecx, 0x3                                 # 00441f38
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441f3b
    mov word ptr [ebp - local_1c], 0x617         # 00441f3d
    mov word ptr [ebp - local_1a], 0x0           # 00441f43
    mov word ptr [ebp - local_18], 0x0           # 00441f49
    mov word ptr [ebp - local_16], 0x1           # 00441f4f
    mov word ptr [ebp - local_8], 0xffff         # 00441f55
    mov byte ptr [ebp - local_6], 0x0            # 00441f5b
    mov word ptr [ebp - local_5], 0x2            # 00441f5f
    mov dword ptr [ebp - local_14], 0x0          # 00441f65
    mov dword ptr [ebp - local_10], 0x0          # 00441f6c
    mov dword ptr [ebp - local_c], 0x1           # 00441f73
    lea ecx, [ebp - local_1d4]                   # 00441f7a
    push ecx                                     # 00441f80
    mov ecx, 0x6177e8                            # 00441f81
    call FUN_0041fa11                            # 00441f86
L_00441f8b:
    # block 0x00441f8b: entered by jne at 0x00441ed2; jne at 0x00441edf; jne at 0x00441eec; jne at 0x00441ef9, 2 instruction(s), ends with jne to 0x0044203a (forward)
    cmp dword ptr [0x586f3d], 0x1                # 00441f8b
    jne.d32 L_0044203a                           # 00441f92
    # block 0x00441f98: entered by fall-through of jne at 0x00441f92, 2 instruction(s), ends with je to 0x00441fae (forward)
    cmp dword ptr [0x583bd5], 0x1                # 00441f98
    je.d8 L_00441fae                             # 00441f9f
    # block 0x00441fa1: entered by fall-through of je at 0x00441f9f, 2 instruction(s), ends with jne to 0x0044203a (forward)
    cmp dword ptr [0x583bd9], 0x1                # 00441fa1
    jne.d32 L_0044203a                           # 00441fa8
L_00441fae:
    # block 0x00441fae: entered by je at 0x00441f9f; fall-through of jne at 0x00441fa8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044203a
    push 0x547ce8                                # 00441fae
    push 0x63a6f8                                # 00441fb3
    lea edx, [ebp - local_1ce]                   # 00441fb8
    push edx                                     # 00441fbe
    call FUN_0043f210                            # 00441fbf
    add esp, 0xc                                 # 00441fc4
    mov edi, 0x547cf0                            # 00441fc7
    lea edx, [ebp - local_3e]                    # 00441fcc
    or ecx, -0x1                                 # 00441fcf
    {load} xor eax, eax                          # 00441fd2
    repne scasb al, byte ptr es:[edi]            # 00441fd4
    not ecx                                      # 00441fd6
    {load} sub edi, ecx                          # 00441fd8
    {load} mov esi, edi                          # 00441fda
    {load} mov eax, ecx                          # 00441fdc
    {load} mov edi, edx                          # 00441fde
    shr ecx, 0x2                                 # 00441fe0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441fe3
    {load} mov ecx, eax                          # 00441fe5
    and ecx, 0x3                                 # 00441fe7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441fea
    mov word ptr [ebp - local_1c], 0x621         # 00441fec
    mov word ptr [ebp - local_1a], 0x0           # 00441ff2
    mov word ptr [ebp - local_18], 0x0           # 00441ff8
    mov word ptr [ebp - local_16], 0x1           # 00441ffe
    mov word ptr [ebp - local_8], 0xffff         # 00442004
    mov byte ptr [ebp - local_6], 0x0            # 0044200a
    mov word ptr [ebp - local_5], 0x2            # 0044200e
    mov dword ptr [ebp - local_14], 0x0          # 00442014
    mov dword ptr [ebp - local_10], 0x0          # 0044201b
    mov dword ptr [ebp - local_c], 0x1           # 00442022
    lea ecx, [ebp - local_1d4]                   # 00442029
    push ecx                                     # 0044202f
    mov ecx, 0x6177e8                            # 00442030
    call FUN_0041fa11                            # 00442035
L_0044203a:
    # block 0x0044203a: entered by jne at 0x00441f92; jne at 0x00441fa8, 2 instruction(s), ends with jne to 0x004420fa (forward)
    cmp dword ptr [0x5874ad], 0x1                # 0044203a
    jne.d32 L_004420fa                           # 00442041
    # block 0x00442047: entered by fall-through of jne at 0x00442041, 2 instruction(s), ends with jne to 0x004420fa (forward)
    cmp dword ptr [0x5876b9], 0x0                # 00442047
    jne.d32 L_004420fa                           # 0044204e
    # block 0x00442054: entered by fall-through of jne at 0x0044204e, 2 instruction(s), ends with jne to 0x004420fa (forward)
    cmp dword ptr [0x586e99], 0x0                # 00442054
    jne.d32 L_004420fa                           # 0044205b
    # block 0x00442061: entered by fall-through of jne at 0x0044205b, 2 instruction(s), ends with jne to 0x004420fa (forward)
    cmp dword ptr [0x586f3d], 0x0                # 00442061
    jne.d32 L_004420fa                           # 00442068
    # block 0x0044206e: entered by fall-through of jne at 0x00442068, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004420fa
    push 0x547cf8                                # 0044206e
    push 0x63a6fc                                # 00442073
    lea edx, [ebp - local_1ce]                   # 00442078
    push edx                                     # 0044207e
    call FUN_0043f210                            # 0044207f
    add esp, 0xc                                 # 00442084
    mov edi, 0x547d00                            # 00442087
    lea edx, [ebp - local_3e]                    # 0044208c
    or ecx, -0x1                                 # 0044208f
    {load} xor eax, eax                          # 00442092
    repne scasb al, byte ptr es:[edi]            # 00442094
    not ecx                                      # 00442096
    {load} sub edi, ecx                          # 00442098
    {load} mov esi, edi                          # 0044209a
    {load} mov eax, ecx                          # 0044209c
    {load} mov edi, edx                          # 0044209e
    shr ecx, 0x2                                 # 004420a0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004420a3
    {load} mov ecx, eax                          # 004420a5
    and ecx, 0x3                                 # 004420a7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004420aa
    mov word ptr [ebp - local_1c], 0x618         # 004420ac
    mov word ptr [ebp - local_1a], 0x0           # 004420b2
    mov word ptr [ebp - local_18], 0x0           # 004420b8
    mov word ptr [ebp - local_16], 0x1           # 004420be
    mov word ptr [ebp - local_8], 0xffff         # 004420c4
    mov byte ptr [ebp - local_6], 0x0            # 004420ca
    mov word ptr [ebp - local_5], 0x2            # 004420ce
    mov dword ptr [ebp - local_14], 0x0          # 004420d4
    mov dword ptr [ebp - local_10], 0x0          # 004420db
    mov dword ptr [ebp - local_c], 0x1           # 004420e2
    lea ecx, [ebp - local_1d4]                   # 004420e9
    push ecx                                     # 004420ef
    mov ecx, 0x6177e8                            # 004420f0
    call FUN_0041fa11                            # 004420f5
L_004420fa:
    # block 0x004420fa: entered by jne at 0x00442041; jne at 0x0044204e; jne at 0x0044205b; jne at 0x00442068, 2 instruction(s), ends with jne to 0x004421ba (forward)
    cmp dword ptr [0x587565], 0x1                # 004420fa
    jne.d32 L_004421ba                           # 00442101
    # block 0x00442107: entered by fall-through of jne at 0x00442101, 2 instruction(s), ends with jne to 0x004421ba (forward)
    cmp dword ptr [0x5876e5], 0x0                # 00442107
    jne.d32 L_004421ba                           # 0044210e
    # block 0x00442114: entered by fall-through of jne at 0x0044210e, 2 instruction(s), ends with jne to 0x004421ba (forward)
    cmp dword ptr [0x586ec9], 0x0                # 00442114
    jne.d32 L_004421ba                           # 0044211b
    # block 0x00442121: entered by fall-through of jne at 0x0044211b, 2 instruction(s), ends with jne to 0x004421ba (forward)
    cmp dword ptr [0x586f3d], 0x0                # 00442121
    jne.d32 L_004421ba                           # 00442128
    # block 0x0044212e: entered by fall-through of jne at 0x00442128, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004421ba
    push 0x547d08                                # 0044212e
    push 0x63a700                                # 00442133
    lea edx, [ebp - local_1ce]                   # 00442138
    push edx                                     # 0044213e
    call FUN_0043f210                            # 0044213f
    add esp, 0xc                                 # 00442144
    mov edi, 0x547d10                            # 00442147
    lea edx, [ebp - local_3e]                    # 0044214c
    or ecx, -0x1                                 # 0044214f
    {load} xor eax, eax                          # 00442152
    repne scasb al, byte ptr es:[edi]            # 00442154
    not ecx                                      # 00442156
    {load} sub edi, ecx                          # 00442158
    {load} mov esi, edi                          # 0044215a
    {load} mov eax, ecx                          # 0044215c
    {load} mov edi, edx                          # 0044215e
    shr ecx, 0x2                                 # 00442160
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442163
    {load} mov ecx, eax                          # 00442165
    and ecx, 0x3                                 # 00442167
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044216a
    mov word ptr [ebp - local_1c], 0x619         # 0044216c
    mov word ptr [ebp - local_1a], 0x0           # 00442172
    mov word ptr [ebp - local_18], 0x0           # 00442178
    mov word ptr [ebp - local_16], 0x1           # 0044217e
    mov word ptr [ebp - local_8], 0xffff         # 00442184
    mov byte ptr [ebp - local_6], 0x0            # 0044218a
    mov word ptr [ebp - local_5], 0x2            # 0044218e
    mov dword ptr [ebp - local_14], 0x0          # 00442194
    mov dword ptr [ebp - local_10], 0x0          # 0044219b
    mov dword ptr [ebp - local_c], 0x1           # 004421a2
    lea ecx, [ebp - local_1d4]                   # 004421a9
    push ecx                                     # 004421af
    mov ecx, 0x6177e8                            # 004421b0
    call FUN_0041fa11                            # 004421b5
L_004421ba:
    # block 0x004421ba: entered by jne at 0x00442101; jne at 0x0044210e; jne at 0x0044211b; jne at 0x00442128, 2 instruction(s), ends with jne to 0x0044227a (forward)
    cmp dword ptr [0x5874a1], 0x1                # 004421ba
    jne.d32 L_0044227a                           # 004421c1
    # block 0x004421c7: entered by fall-through of jne at 0x004421c1, 2 instruction(s), ends with jne to 0x0044227a (forward)
    cmp dword ptr [0x5876ed], 0x0                # 004421c7
    jne.d32 L_0044227a                           # 004421ce
    # block 0x004421d4: entered by fall-through of jne at 0x004421ce, 2 instruction(s), ends with jne to 0x0044227a (forward)
    cmp dword ptr [0x586ed5], 0x0                # 004421d4
    jne.d32 L_0044227a                           # 004421db
    # block 0x004421e1: entered by fall-through of jne at 0x004421db, 2 instruction(s), ends with jne to 0x0044227a (forward)
    cmp dword ptr [0x586f3d], 0x0                # 004421e1
    jne.d32 L_0044227a                           # 004421e8
    # block 0x004421ee: entered by fall-through of jne at 0x004421e8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044227a
    push 0x547d18                                # 004421ee
    push 0x63a704                                # 004421f3
    lea edx, [ebp - local_1ce]                   # 004421f8
    push edx                                     # 004421fe
    call FUN_0043f210                            # 004421ff
    add esp, 0xc                                 # 00442204
    mov edi, 0x547d20                            # 00442207
    lea edx, [ebp - local_3e]                    # 0044220c
    or ecx, -0x1                                 # 0044220f
    {load} xor eax, eax                          # 00442212
    repne scasb al, byte ptr es:[edi]            # 00442214
    not ecx                                      # 00442216
    {load} sub edi, ecx                          # 00442218
    {load} mov esi, edi                          # 0044221a
    {load} mov eax, ecx                          # 0044221c
    {load} mov edi, edx                          # 0044221e
    shr ecx, 0x2                                 # 00442220
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442223
    {load} mov ecx, eax                          # 00442225
    and ecx, 0x3                                 # 00442227
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044222a
    mov word ptr [ebp - local_1c], 0x61a         # 0044222c
    mov word ptr [ebp - local_1a], 0x0           # 00442232
    mov word ptr [ebp - local_18], 0x0           # 00442238
    mov word ptr [ebp - local_16], 0x1           # 0044223e
    mov word ptr [ebp - local_8], 0xffff         # 00442244
    mov byte ptr [ebp - local_6], 0x0            # 0044224a
    mov word ptr [ebp - local_5], 0x2            # 0044224e
    mov dword ptr [ebp - local_14], 0x0          # 00442254
    mov dword ptr [ebp - local_10], 0x0          # 0044225b
    mov dword ptr [ebp - local_c], 0x1           # 00442262
    lea ecx, [ebp - local_1d4]                   # 00442269
    push ecx                                     # 0044226f
    mov ecx, 0x6177e8                            # 00442270
    call FUN_0041fa11                            # 00442275
L_0044227a:
    # block 0x0044227a: entered by jne at 0x004421c1; jne at 0x004421ce; jne at 0x004421db; jne at 0x004421e8, 3 instruction(s), ends with jne to 0x00442349 (forward)
    movsx edx, word ptr [0x58c94f]               # 0044227a
    test edx, edx                                # 00442281
    jne.d32 L_00442349                           # 00442283
    # block 0x00442289: entered by fall-through of jne at 0x00442283, 2 instruction(s), ends with jne to 0x00442349 (forward)
    cmp dword ptr [0x58720d], 0x1                # 00442289
    jne.d32 L_00442349                           # 00442290
    # block 0x00442296: entered by fall-through of jne at 0x00442290, 2 instruction(s), ends with jne to 0x00442349 (forward)
    cmp dword ptr [0x586ed9], 0x0                # 00442296
    jne.d32 L_00442349                           # 0044229d
    # block 0x004422a3: entered by fall-through of jne at 0x0044229d, 2 instruction(s), ends with jne to 0x00442349 (forward)
    cmp dword ptr [0x586ebd], 0x0                # 004422a3
    jne.d32 L_00442349                           # 004422aa
    # block 0x004422b0: entered by fall-through of jne at 0x004422aa, 2 instruction(s), ends with jne to 0x00442349 (forward)
    cmp dword ptr [0x586ecd], 0x0                # 004422b0
    jne.d32 L_00442349                           # 004422b7
    # block 0x004422bd: entered by fall-through of jne at 0x004422b7, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442349
    push 0x547d28                                # 004422bd
    push 0x63a708                                # 004422c2
    lea eax, [ebp - local_1ce]                   # 004422c7
    push eax                                     # 004422cd
    call FUN_0043f210                            # 004422ce
    add esp, 0xc                                 # 004422d3
    mov edi, 0x547d30                            # 004422d6
    lea edx, [ebp - local_3e]                    # 004422db
    or ecx, -0x1                                 # 004422de
    {load} xor eax, eax                          # 004422e1
    repne scasb al, byte ptr es:[edi]            # 004422e3
    not ecx                                      # 004422e5
    {load} sub edi, ecx                          # 004422e7
    {load} mov esi, edi                          # 004422e9
    {load} mov eax, ecx                          # 004422eb
    {load} mov edi, edx                          # 004422ed
    shr ecx, 0x2                                 # 004422ef
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004422f2
    {load} mov ecx, eax                          # 004422f4
    and ecx, 0x3                                 # 004422f6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004422f9
    mov word ptr [ebp - local_1c], 0x13c4        # 004422fb
    mov word ptr [ebp - local_1a], 0x0           # 00442301
    mov word ptr [ebp - local_18], 0x0           # 00442307
    mov word ptr [ebp - local_16], 0x1           # 0044230d
    mov word ptr [ebp - local_8], 0xffff         # 00442313
    mov byte ptr [ebp - local_6], 0x0            # 00442319
    mov word ptr [ebp - local_5], 0x2            # 0044231d
    mov dword ptr [ebp - local_14], 0x0          # 00442323
    mov dword ptr [ebp - local_10], 0x0          # 0044232a
    mov dword ptr [ebp - local_c], 0x1           # 00442331
    lea ecx, [ebp - local_1d4]                   # 00442338
    push ecx                                     # 0044233e
    mov ecx, 0x6177e8                            # 0044233f
    call FUN_0041fa11                            # 00442344
L_00442349:
    # block 0x00442349: entered by jne at 0x00442283; jne at 0x00442290; jne at 0x0044229d; jne at 0x004422aa; more, 2 instruction(s), ends with jne to 0x004423fc (forward)
    cmp dword ptr [0x586ebd], 0x1                # 00442349
    jne.d32 L_004423fc                           # 00442350
    # block 0x00442356: entered by fall-through of jne at 0x00442350, 2 instruction(s), ends with jne to 0x004423fc (forward)
    cmp dword ptr [0x586ed9], 0x0                # 00442356
    jne.d32 L_004423fc                           # 0044235d
    # block 0x00442363: entered by fall-through of jne at 0x0044235d, 2 instruction(s), ends with jne to 0x004423fc (forward)
    cmp dword ptr [0x58720d], 0x1                # 00442363
    jne.d32 L_004423fc                           # 0044236a
    # block 0x00442370: entered by fall-through of jne at 0x0044236a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004423fc
    push 0x547d38                                # 00442370
    push 0x63a70c                                # 00442375
    lea edx, [ebp - local_1ce]                   # 0044237a
    push edx                                     # 00442380
    call FUN_0043f210                            # 00442381
    add esp, 0xc                                 # 00442386
    mov edi, 0x547d40                            # 00442389
    lea edx, [ebp - local_3e]                    # 0044238e
    or ecx, -0x1                                 # 00442391
    {load} xor eax, eax                          # 00442394
    repne scasb al, byte ptr es:[edi]            # 00442396
    not ecx                                      # 00442398
    {load} sub edi, ecx                          # 0044239a
    {load} mov esi, edi                          # 0044239c
    {load} mov eax, ecx                          # 0044239e
    {load} mov edi, edx                          # 004423a0
    shr ecx, 0x2                                 # 004423a2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004423a5
    {load} mov ecx, eax                          # 004423a7
    and ecx, 0x3                                 # 004423a9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004423ac
    mov word ptr [ebp - local_1c], 0x13c5        # 004423ae
    mov word ptr [ebp - local_1a], 0x0           # 004423b4
    mov word ptr [ebp - local_18], 0x0           # 004423ba
    mov word ptr [ebp - local_16], 0x1           # 004423c0
    mov word ptr [ebp - local_8], 0xffff         # 004423c6
    mov byte ptr [ebp - local_6], 0x0            # 004423cc
    mov word ptr [ebp - local_5], 0x2            # 004423d0
    mov dword ptr [ebp - local_14], 0x0          # 004423d6
    mov dword ptr [ebp - local_10], 0x0          # 004423dd
    mov dword ptr [ebp - local_c], 0x1           # 004423e4
    lea ecx, [ebp - local_1d4]                   # 004423eb
    push ecx                                     # 004423f1
    mov ecx, 0x6177e8                            # 004423f2
    call FUN_0041fa11                            # 004423f7
L_004423fc:
    # block 0x004423fc: entered by jne at 0x00442350; jne at 0x0044235d; jne at 0x0044236a, 2 instruction(s), ends with jne to 0x004424a2 (forward)
    cmp dword ptr [0x586bfd], 0x1                # 004423fc
    jne.d32 L_004424a2                           # 00442403
    # block 0x00442409: entered by fall-through of jne at 0x00442403, 2 instruction(s), ends with jne to 0x004424a2 (forward)
    cmp dword ptr [0x586ef9], 0x0                # 00442409
    jne.d32 L_004424a2                           # 00442410
    # block 0x00442416: entered by fall-through of jne at 0x00442410, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004424a2
    push 0x547d48                                # 00442416
    push 0x63a710                                # 0044241b
    lea edx, [ebp - local_1ce]                   # 00442420
    push edx                                     # 00442426
    call FUN_0043f210                            # 00442427
    add esp, 0xc                                 # 0044242c
    mov edi, 0x547d50                            # 0044242f
    lea edx, [ebp - local_3e]                    # 00442434
    or ecx, -0x1                                 # 00442437
    {load} xor eax, eax                          # 0044243a
    repne scasb al, byte ptr es:[edi]            # 0044243c
    not ecx                                      # 0044243e
    {load} sub edi, ecx                          # 00442440
    {load} mov esi, edi                          # 00442442
    {load} mov eax, ecx                          # 00442444
    {load} mov edi, edx                          # 00442446
    shr ecx, 0x2                                 # 00442448
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044244b
    {load} mov ecx, eax                          # 0044244d
    and ecx, 0x3                                 # 0044244f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442452
    mov word ptr [ebp - local_1c], 0x138b        # 00442454
    mov word ptr [ebp - local_1a], 0x0           # 0044245a
    mov word ptr [ebp - local_18], 0x0           # 00442460
    mov word ptr [ebp - local_16], 0x1           # 00442466
    mov word ptr [ebp - local_8], 0xffff         # 0044246c
    mov byte ptr [ebp - local_6], 0x0            # 00442472
    mov word ptr [ebp - local_5], 0x2            # 00442476
    mov dword ptr [ebp - local_14], 0x0          # 0044247c
    mov dword ptr [ebp - local_10], 0x0          # 00442483
    mov dword ptr [ebp - local_c], 0x1           # 0044248a
    lea ecx, [ebp - local_1d4]                   # 00442491
    push ecx                                     # 00442497
    mov ecx, 0x6177e8                            # 00442498
    call FUN_0041fa11                            # 0044249d
L_004424a2:
    # block 0x004424a2: entered by jne at 0x00442403; jne at 0x00442410, 2 instruction(s), ends with jne to 0x00442548 (forward)
    cmp dword ptr [0x586be9], 0x1                # 004424a2
    jne.d32 L_00442548                           # 004424a9
    # block 0x004424af: entered by fall-through of jne at 0x004424a9, 2 instruction(s), ends with jne to 0x00442548 (forward)
    cmp dword ptr [0x586efd], 0x0                # 004424af
    jne.d32 L_00442548                           # 004424b6
    # block 0x004424bc: entered by fall-through of jne at 0x004424b6, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442548
    push 0x547d58                                # 004424bc
    push 0x63a714                                # 004424c1
    lea edx, [ebp - local_1ce]                   # 004424c6
    push edx                                     # 004424cc
    call FUN_0043f210                            # 004424cd
    add esp, 0xc                                 # 004424d2
    mov edi, 0x547d60                            # 004424d5
    lea edx, [ebp - local_3e]                    # 004424da
    or ecx, -0x1                                 # 004424dd
    {load} xor eax, eax                          # 004424e0
    repne scasb al, byte ptr es:[edi]            # 004424e2
    not ecx                                      # 004424e4
    {load} sub edi, ecx                          # 004424e6
    {load} mov esi, edi                          # 004424e8
    {load} mov eax, ecx                          # 004424ea
    {load} mov edi, edx                          # 004424ec
    shr ecx, 0x2                                 # 004424ee
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004424f1
    {load} mov ecx, eax                          # 004424f3
    and ecx, 0x3                                 # 004424f5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004424f8
    mov word ptr [ebp - local_1c], 0x138c        # 004424fa
    mov word ptr [ebp - local_1a], 0x0           # 00442500
    mov word ptr [ebp - local_18], 0x0           # 00442506
    mov word ptr [ebp - local_16], 0x1           # 0044250c
    mov word ptr [ebp - local_8], 0xffff         # 00442512
    mov byte ptr [ebp - local_6], 0x0            # 00442518
    mov word ptr [ebp - local_5], 0x2            # 0044251c
    mov dword ptr [ebp - local_14], 0x0          # 00442522
    mov dword ptr [ebp - local_10], 0x0          # 00442529
    mov dword ptr [ebp - local_c], 0x1           # 00442530
    lea ecx, [ebp - local_1d4]                   # 00442537
    push ecx                                     # 0044253d
    mov ecx, 0x6177e8                            # 0044253e
    call FUN_0041fa11                            # 00442543
L_00442548:
    # block 0x00442548: entered by jne at 0x004424a9; jne at 0x004424b6, 2 instruction(s), ends with jne to 0x004425ee (forward)
    cmp dword ptr [0x586c0d], 0x1                # 00442548
    jne.d32 L_004425ee                           # 0044254f
    # block 0x00442555: entered by fall-through of jne at 0x0044254f, 2 instruction(s), ends with jne to 0x004425ee (forward)
    cmp dword ptr [0x586f09], 0x0                # 00442555
    jne.d32 L_004425ee                           # 0044255c
    # block 0x00442562: entered by fall-through of jne at 0x0044255c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004425ee
    push 0x547d68                                # 00442562
    push 0x63a718                                # 00442567
    lea edx, [ebp - local_1ce]                   # 0044256c
    push edx                                     # 00442572
    call FUN_0043f210                            # 00442573
    add esp, 0xc                                 # 00442578
    mov edi, 0x547d70                            # 0044257b
    lea edx, [ebp - local_3e]                    # 00442580
    or ecx, -0x1                                 # 00442583
    {load} xor eax, eax                          # 00442586
    repne scasb al, byte ptr es:[edi]            # 00442588
    not ecx                                      # 0044258a
    {load} sub edi, ecx                          # 0044258c
    {load} mov esi, edi                          # 0044258e
    {load} mov eax, ecx                          # 00442590
    {load} mov edi, edx                          # 00442592
    shr ecx, 0x2                                 # 00442594
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442597
    {load} mov ecx, eax                          # 00442599
    and ecx, 0x3                                 # 0044259b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044259e
    mov word ptr [ebp - local_1c], 0x138d        # 004425a0
    mov word ptr [ebp - local_1a], 0x0           # 004425a6
    mov word ptr [ebp - local_18], 0x0           # 004425ac
    mov word ptr [ebp - local_16], 0x1           # 004425b2
    mov word ptr [ebp - local_8], 0xffff         # 004425b8
    mov byte ptr [ebp - local_6], 0x0            # 004425be
    mov word ptr [ebp - local_5], 0x2            # 004425c2
    mov dword ptr [ebp - local_14], 0x0          # 004425c8
    mov dword ptr [ebp - local_10], 0x0          # 004425cf
    mov dword ptr [ebp - local_c], 0x1           # 004425d6
    lea ecx, [ebp - local_1d4]                   # 004425dd
    push ecx                                     # 004425e3
    mov ecx, 0x6177e8                            # 004425e4
    call FUN_0041fa11                            # 004425e9
L_004425ee:
    # block 0x004425ee: entered by jne at 0x0044254f; jne at 0x0044255c, 2 instruction(s), ends with jne to 0x00442694 (forward)
    cmp dword ptr [0x586c41], 0x1                # 004425ee
    jne.d32 L_00442694                           # 004425f5
    # block 0x004425fb: entered by fall-through of jne at 0x004425f5, 2 instruction(s), ends with jne to 0x00442694 (forward)
    cmp dword ptr [0x586f45], 0x0                # 004425fb
    jne.d32 L_00442694                           # 00442602
    # block 0x00442608: entered by fall-through of jne at 0x00442602, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442694
    push 0x547d78                                # 00442608
    push 0x63a71c                                # 0044260d
    lea edx, [ebp - local_1ce]                   # 00442612
    push edx                                     # 00442618
    call FUN_0043f210                            # 00442619
    add esp, 0xc                                 # 0044261e
    mov edi, 0x547d80                            # 00442621
    lea edx, [ebp - local_3e]                    # 00442626
    or ecx, -0x1                                 # 00442629
    {load} xor eax, eax                          # 0044262c
    repne scasb al, byte ptr es:[edi]            # 0044262e
    not ecx                                      # 00442630
    {load} sub edi, ecx                          # 00442632
    {load} mov esi, edi                          # 00442634
    {load} mov eax, ecx                          # 00442636
    {load} mov edi, edx                          # 00442638
    shr ecx, 0x2                                 # 0044263a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044263d
    {load} mov ecx, eax                          # 0044263f
    and ecx, 0x3                                 # 00442641
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442644
    mov word ptr [ebp - local_1c], 0x138e        # 00442646
    mov word ptr [ebp - local_1a], 0x0           # 0044264c
    mov word ptr [ebp - local_18], 0x0           # 00442652
    mov word ptr [ebp - local_16], 0x1           # 00442658
    mov word ptr [ebp - local_8], 0xffff         # 0044265e
    mov byte ptr [ebp - local_6], 0x0            # 00442664
    mov word ptr [ebp - local_5], 0x2            # 00442668
    mov dword ptr [ebp - local_14], 0x0          # 0044266e
    mov dword ptr [ebp - local_10], 0x0          # 00442675
    mov dword ptr [ebp - local_c], 0x1           # 0044267c
    lea ecx, [ebp - local_1d4]                   # 00442683
    push ecx                                     # 00442689
    mov ecx, 0x6177e8                            # 0044268a
    call FUN_0041fa11                            # 0044268f
L_00442694:
    # block 0x00442694: entered by jne at 0x004425f5; jne at 0x00442602, 2 instruction(s), ends with jne to 0x0044273a (forward)
    cmp dword ptr [0x586c31], 0x1                # 00442694
    jne.d32 L_0044273a                           # 0044269b
    # block 0x004426a1: entered by fall-through of jne at 0x0044269b, 2 instruction(s), ends with jne to 0x0044273a (forward)
    cmp dword ptr [0x586ed1], 0x0                # 004426a1
    jne.d32 L_0044273a                           # 004426a8
    # block 0x004426ae: entered by fall-through of jne at 0x004426a8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044273a
    push 0x547d88                                # 004426ae
    push 0x63a720                                # 004426b3
    lea edx, [ebp - local_1ce]                   # 004426b8
    push edx                                     # 004426be
    call FUN_0043f210                            # 004426bf
    add esp, 0xc                                 # 004426c4
    mov edi, 0x547d90                            # 004426c7
    lea edx, [ebp - local_3e]                    # 004426cc
    or ecx, -0x1                                 # 004426cf
    {load} xor eax, eax                          # 004426d2
    repne scasb al, byte ptr es:[edi]            # 004426d4
    not ecx                                      # 004426d6
    {load} sub edi, ecx                          # 004426d8
    {load} mov esi, edi                          # 004426da
    {load} mov eax, ecx                          # 004426dc
    {load} mov edi, edx                          # 004426de
    shr ecx, 0x2                                 # 004426e0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004426e3
    {load} mov ecx, eax                          # 004426e5
    and ecx, 0x3                                 # 004426e7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004426ea
    mov word ptr [ebp - local_1c], 0x138f        # 004426ec
    mov word ptr [ebp - local_1a], 0x0           # 004426f2
    mov word ptr [ebp - local_18], 0x0           # 004426f8
    mov word ptr [ebp - local_16], 0x1           # 004426fe
    mov word ptr [ebp - local_8], 0xffff         # 00442704
    mov byte ptr [ebp - local_6], 0x0            # 0044270a
    mov word ptr [ebp - local_5], 0x2            # 0044270e
    mov dword ptr [ebp - local_14], 0x0          # 00442714
    mov dword ptr [ebp - local_10], 0x0          # 0044271b
    mov dword ptr [ebp - local_c], 0x1           # 00442722
    lea ecx, [ebp - local_1d4]                   # 00442729
    push ecx                                     # 0044272f
    mov ecx, 0x6177e8                            # 00442730
    call FUN_0041fa11                            # 00442735
L_0044273a:
    # block 0x0044273a: entered by jne at 0x0044269b; jne at 0x004426a8, 2 instruction(s), ends with jne to 0x004427e0 (forward)
    cmp dword ptr [0x586bd1], 0x1                # 0044273a
    jne.d32 L_004427e0                           # 00442741
    # block 0x00442747: entered by fall-through of jne at 0x00442741, 2 instruction(s), ends with jne to 0x004427e0 (forward)
    cmp dword ptr [0x586ea9], 0x0                # 00442747
    jne.d32 L_004427e0                           # 0044274e
    # block 0x00442754: entered by fall-through of jne at 0x0044274e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004427e0
    push 0x547d98                                # 00442754
    push 0x63a724                                # 00442759
    lea edx, [ebp - local_1ce]                   # 0044275e
    push edx                                     # 00442764
    call FUN_0043f210                            # 00442765
    add esp, 0xc                                 # 0044276a
    mov edi, 0x547da0                            # 0044276d
    lea edx, [ebp - local_3e]                    # 00442772
    or ecx, -0x1                                 # 00442775
    {load} xor eax, eax                          # 00442778
    repne scasb al, byte ptr es:[edi]            # 0044277a
    not ecx                                      # 0044277c
    {load} sub edi, ecx                          # 0044277e
    {load} mov esi, edi                          # 00442780
    {load} mov eax, ecx                          # 00442782
    {load} mov edi, edx                          # 00442784
    shr ecx, 0x2                                 # 00442786
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442789
    {load} mov ecx, eax                          # 0044278b
    and ecx, 0x3                                 # 0044278d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442790
    mov word ptr [ebp - local_1c], 0x1390        # 00442792
    mov word ptr [ebp - local_1a], 0x0           # 00442798
    mov word ptr [ebp - local_18], 0x0           # 0044279e
    mov word ptr [ebp - local_16], 0x1           # 004427a4
    mov word ptr [ebp - local_8], 0xffff         # 004427aa
    mov byte ptr [ebp - local_6], 0x0            # 004427b0
    mov word ptr [ebp - local_5], 0x2            # 004427b4
    mov dword ptr [ebp - local_14], 0x0          # 004427ba
    mov dword ptr [ebp - local_10], 0x0          # 004427c1
    mov dword ptr [ebp - local_c], 0x1           # 004427c8
    lea ecx, [ebp - local_1d4]                   # 004427cf
    push ecx                                     # 004427d5
    mov ecx, 0x6177e8                            # 004427d6
    call FUN_0041fa11                            # 004427db
L_004427e0:
    # block 0x004427e0: entered by jne at 0x00442741; jne at 0x0044274e, 2 instruction(s), ends with jne to 0x00442886 (forward)
    cmp dword ptr [0x586c09], 0x1                # 004427e0
    jne.d32 L_00442886                           # 004427e7
    # block 0x004427ed: entered by fall-through of jne at 0x004427e7, 2 instruction(s), ends with jne to 0x00442886 (forward)
    cmp dword ptr [0x586f05], 0x0                # 004427ed
    jne.d32 L_00442886                           # 004427f4
    # block 0x004427fa: entered by fall-through of jne at 0x004427f4, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442886
    push 0x547da8                                # 004427fa
    push 0x63a728                                # 004427ff
    lea edx, [ebp - local_1ce]                   # 00442804
    push edx                                     # 0044280a
    call FUN_0043f210                            # 0044280b
    add esp, 0xc                                 # 00442810
    mov edi, 0x547db0                            # 00442813
    lea edx, [ebp - local_3e]                    # 00442818
    or ecx, -0x1                                 # 0044281b
    {load} xor eax, eax                          # 0044281e
    repne scasb al, byte ptr es:[edi]            # 00442820
    not ecx                                      # 00442822
    {load} sub edi, ecx                          # 00442824
    {load} mov esi, edi                          # 00442826
    {load} mov eax, ecx                          # 00442828
    {load} mov edi, edx                          # 0044282a
    shr ecx, 0x2                                 # 0044282c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044282f
    {load} mov ecx, eax                          # 00442831
    and ecx, 0x3                                 # 00442833
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442836
    mov word ptr [ebp - local_1c], 0x1391        # 00442838
    mov word ptr [ebp - local_1a], 0x0           # 0044283e
    mov word ptr [ebp - local_18], 0x0           # 00442844
    mov word ptr [ebp - local_16], 0x1           # 0044284a
    mov word ptr [ebp - local_8], 0xffff         # 00442850
    mov byte ptr [ebp - local_6], 0x0            # 00442856
    mov word ptr [ebp - local_5], 0x2            # 0044285a
    mov dword ptr [ebp - local_14], 0x0          # 00442860
    mov dword ptr [ebp - local_10], 0x0          # 00442867
    mov dword ptr [ebp - local_c], 0x1           # 0044286e
    lea ecx, [ebp - local_1d4]                   # 00442875
    push ecx                                     # 0044287b
    mov ecx, 0x6177e8                            # 0044287c
    call FUN_0041fa11                            # 00442881
L_00442886:
    # block 0x00442886: entered by jne at 0x004427e7; jne at 0x004427f4, 2 instruction(s), ends with jne to 0x0044292c (forward)
    cmp dword ptr [0x586be5], 0x1                # 00442886
    jne.d32 L_0044292c                           # 0044288d
    # block 0x00442893: entered by fall-through of jne at 0x0044288d, 2 instruction(s), ends with jne to 0x0044292c (forward)
    cmp dword ptr [0x586ec5], 0x0                # 00442893
    jne.d32 L_0044292c                           # 0044289a
    # block 0x004428a0: entered by fall-through of jne at 0x0044289a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044292c
    push 0x547db8                                # 004428a0
    push 0x63a72c                                # 004428a5
    lea edx, [ebp - local_1ce]                   # 004428aa
    push edx                                     # 004428b0
    call FUN_0043f210                            # 004428b1
    add esp, 0xc                                 # 004428b6
    mov edi, 0x547dc0                            # 004428b9
    lea edx, [ebp - local_3e]                    # 004428be
    or ecx, -0x1                                 # 004428c1
    {load} xor eax, eax                          # 004428c4
    repne scasb al, byte ptr es:[edi]            # 004428c6
    not ecx                                      # 004428c8
    {load} sub edi, ecx                          # 004428ca
    {load} mov esi, edi                          # 004428cc
    {load} mov eax, ecx                          # 004428ce
    {load} mov edi, edx                          # 004428d0
    shr ecx, 0x2                                 # 004428d2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004428d5
    {load} mov ecx, eax                          # 004428d7
    and ecx, 0x3                                 # 004428d9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004428dc
    mov word ptr [ebp - local_1c], 0x1392        # 004428de
    mov word ptr [ebp - local_1a], 0x0           # 004428e4
    mov word ptr [ebp - local_18], 0x0           # 004428ea
    mov word ptr [ebp - local_16], 0x1           # 004428f0
    mov word ptr [ebp - local_8], 0xffff         # 004428f6
    mov byte ptr [ebp - local_6], 0x0            # 004428fc
    mov word ptr [ebp - local_5], 0x2            # 00442900
    mov dword ptr [ebp - local_14], 0x0          # 00442906
    mov dword ptr [ebp - local_10], 0x0          # 0044290d
    mov dword ptr [ebp - local_c], 0x1           # 00442914
    lea ecx, [ebp - local_1d4]                   # 0044291b
    push ecx                                     # 00442921
    mov ecx, 0x6177e8                            # 00442922
    call FUN_0041fa11                            # 00442927
L_0044292c:
    # block 0x0044292c: entered by jne at 0x0044288d; jne at 0x0044289a, 2 instruction(s), ends with jne to 0x004429d2 (forward)
    cmp dword ptr [0x586c25], 0x1                # 0044292c
    jne.d32 L_004429d2                           # 00442933
    # block 0x00442939: entered by fall-through of jne at 0x00442933, 2 instruction(s), ends with jne to 0x004429d2 (forward)
    cmp dword ptr [0x586edd], 0x0                # 00442939
    jne.d32 L_004429d2                           # 00442940
    # block 0x00442946: entered by fall-through of jne at 0x00442940, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004429d2
    push 0x547dc8                                # 00442946
    push 0x63a730                                # 0044294b
    lea edx, [ebp - local_1ce]                   # 00442950
    push edx                                     # 00442956
    call FUN_0043f210                            # 00442957
    add esp, 0xc                                 # 0044295c
    mov edi, 0x547dd0                            # 0044295f
    lea edx, [ebp - local_3e]                    # 00442964
    or ecx, -0x1                                 # 00442967
    {load} xor eax, eax                          # 0044296a
    repne scasb al, byte ptr es:[edi]            # 0044296c
    not ecx                                      # 0044296e
    {load} sub edi, ecx                          # 00442970
    {load} mov esi, edi                          # 00442972
    {load} mov eax, ecx                          # 00442974
    {load} mov edi, edx                          # 00442976
    shr ecx, 0x2                                 # 00442978
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044297b
    {load} mov ecx, eax                          # 0044297d
    and ecx, 0x3                                 # 0044297f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442982
    mov word ptr [ebp - local_1c], 0x1393        # 00442984
    mov word ptr [ebp - local_1a], 0x0           # 0044298a
    mov word ptr [ebp - local_18], 0x0           # 00442990
    mov word ptr [ebp - local_16], 0x1           # 00442996
    mov word ptr [ebp - local_8], 0xffff         # 0044299c
    mov byte ptr [ebp - local_6], 0x0            # 004429a2
    mov word ptr [ebp - local_5], 0x2            # 004429a6
    mov dword ptr [ebp - local_14], 0x0          # 004429ac
    mov dword ptr [ebp - local_10], 0x0          # 004429b3
    mov dword ptr [ebp - local_c], 0x1           # 004429ba
    lea ecx, [ebp - local_1d4]                   # 004429c1
    push ecx                                     # 004429c7
    mov ecx, 0x6177e8                            # 004429c8
    call FUN_0041fa11                            # 004429cd
L_004429d2:
    # block 0x004429d2: entered by jne at 0x00442933; jne at 0x00442940, 2 instruction(s), ends with jne to 0x00442a78 (forward)
    cmp dword ptr [0x586c01], 0x1                # 004429d2
    jne.d32 L_00442a78                           # 004429d9
    # block 0x004429df: entered by fall-through of jne at 0x004429d9, 2 instruction(s), ends with jne to 0x00442a78 (forward)
    cmp dword ptr [0x586edd], 0x0                # 004429df
    jne.d32 L_00442a78                           # 004429e6
    # block 0x004429ec: entered by fall-through of jne at 0x004429e6, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442a78
    push 0x547dd8                                # 004429ec
    push 0x63a734                                # 004429f1
    lea edx, [ebp - local_1ce]                   # 004429f6
    push edx                                     # 004429fc
    call FUN_0043f210                            # 004429fd
    add esp, 0xc                                 # 00442a02
    mov edi, 0x547de0                            # 00442a05
    lea edx, [ebp - local_3e]                    # 00442a0a
    or ecx, -0x1                                 # 00442a0d
    {load} xor eax, eax                          # 00442a10
    repne scasb al, byte ptr es:[edi]            # 00442a12
    not ecx                                      # 00442a14
    {load} sub edi, ecx                          # 00442a16
    {load} mov esi, edi                          # 00442a18
    {load} mov eax, ecx                          # 00442a1a
    {load} mov edi, edx                          # 00442a1c
    shr ecx, 0x2                                 # 00442a1e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442a21
    {load} mov ecx, eax                          # 00442a23
    and ecx, 0x3                                 # 00442a25
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442a28
    mov word ptr [ebp - local_1c], 0x1394        # 00442a2a
    mov word ptr [ebp - local_1a], 0x0           # 00442a30
    mov word ptr [ebp - local_18], 0x0           # 00442a36
    mov word ptr [ebp - local_16], 0x1           # 00442a3c
    mov word ptr [ebp - local_8], 0xffff         # 00442a42
    mov byte ptr [ebp - local_6], 0x0            # 00442a48
    mov word ptr [ebp - local_5], 0x2            # 00442a4c
    mov dword ptr [ebp - local_14], 0x0          # 00442a52
    mov dword ptr [ebp - local_10], 0x0          # 00442a59
    mov dword ptr [ebp - local_c], 0x1           # 00442a60
    lea ecx, [ebp - local_1d4]                   # 00442a67
    push ecx                                     # 00442a6d
    mov ecx, 0x6177e8                            # 00442a6e
    call FUN_0041fa11                            # 00442a73
L_00442a78:
    # block 0x00442a78: entered by jne at 0x004429d9; jne at 0x004429e6, 2 instruction(s), ends with jne to 0x00442b1e (forward)
    cmp dword ptr [0x586c19], 0x1                # 00442a78
    jne.d32 L_00442b1e                           # 00442a7f
    # block 0x00442a85: entered by fall-through of jne at 0x00442a7f, 2 instruction(s), ends with jne to 0x00442b1e (forward)
    cmp dword ptr [0x586edd], 0x0                # 00442a85
    jne.d32 L_00442b1e                           # 00442a8c
    # block 0x00442a92: entered by fall-through of jne at 0x00442a8c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442b1e
    push 0x547de8                                # 00442a92
    push 0x63a738                                # 00442a97
    lea edx, [ebp - local_1ce]                   # 00442a9c
    push edx                                     # 00442aa2
    call FUN_0043f210                            # 00442aa3
    add esp, 0xc                                 # 00442aa8
    mov edi, 0x547df0                            # 00442aab
    lea edx, [ebp - local_3e]                    # 00442ab0
    or ecx, -0x1                                 # 00442ab3
    {load} xor eax, eax                          # 00442ab6
    repne scasb al, byte ptr es:[edi]            # 00442ab8
    not ecx                                      # 00442aba
    {load} sub edi, ecx                          # 00442abc
    {load} mov esi, edi                          # 00442abe
    {load} mov eax, ecx                          # 00442ac0
    {load} mov edi, edx                          # 00442ac2
    shr ecx, 0x2                                 # 00442ac4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442ac7
    {load} mov ecx, eax                          # 00442ac9
    and ecx, 0x3                                 # 00442acb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442ace
    mov word ptr [ebp - local_1c], 0x1395        # 00442ad0
    mov word ptr [ebp - local_1a], 0x0           # 00442ad6
    mov word ptr [ebp - local_18], 0x0           # 00442adc
    mov word ptr [ebp - local_16], 0x1           # 00442ae2
    mov word ptr [ebp - local_8], 0xffff         # 00442ae8
    mov byte ptr [ebp - local_6], 0x0            # 00442aee
    mov word ptr [ebp - local_5], 0x2            # 00442af2
    mov dword ptr [ebp - local_14], 0x0          # 00442af8
    mov dword ptr [ebp - local_10], 0x0          # 00442aff
    mov dword ptr [ebp - local_c], 0x1           # 00442b06
    lea ecx, [ebp - local_1d4]                   # 00442b0d
    push ecx                                     # 00442b13
    mov ecx, 0x6177e8                            # 00442b14
    call FUN_0041fa11                            # 00442b19
L_00442b1e:
    # block 0x00442b1e: entered by jne at 0x00442a7f; jne at 0x00442a8c, 2 instruction(s), ends with jne to 0x00442bc4 (forward)
    cmp dword ptr [0x586c35], 0x1                # 00442b1e
    jne.d32 L_00442bc4                           # 00442b25
    # block 0x00442b2b: entered by fall-through of jne at 0x00442b25, 2 instruction(s), ends with jne to 0x00442bc4 (forward)
    cmp dword ptr [0x586edd], 0x0                # 00442b2b
    jne.d32 L_00442bc4                           # 00442b32
    # block 0x00442b38: entered by fall-through of jne at 0x00442b32, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442bc4
    push 0x547df8                                # 00442b38
    push 0x63a73c                                # 00442b3d
    lea edx, [ebp - local_1ce]                   # 00442b42
    push edx                                     # 00442b48
    call FUN_0043f210                            # 00442b49
    add esp, 0xc                                 # 00442b4e
    mov edi, 0x547e00                            # 00442b51
    lea edx, [ebp - local_3e]                    # 00442b56
    or ecx, -0x1                                 # 00442b59
    {load} xor eax, eax                          # 00442b5c
    repne scasb al, byte ptr es:[edi]            # 00442b5e
    not ecx                                      # 00442b60
    {load} sub edi, ecx                          # 00442b62
    {load} mov esi, edi                          # 00442b64
    {load} mov eax, ecx                          # 00442b66
    {load} mov edi, edx                          # 00442b68
    shr ecx, 0x2                                 # 00442b6a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442b6d
    {load} mov ecx, eax                          # 00442b6f
    and ecx, 0x3                                 # 00442b71
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442b74
    mov word ptr [ebp - local_1c], 0x1396        # 00442b76
    mov word ptr [ebp - local_1a], 0x0           # 00442b7c
    mov word ptr [ebp - local_18], 0x0           # 00442b82
    mov word ptr [ebp - local_16], 0x1           # 00442b88
    mov word ptr [ebp - local_8], 0xffff         # 00442b8e
    mov byte ptr [ebp - local_6], 0x0            # 00442b94
    mov word ptr [ebp - local_5], 0x2            # 00442b98
    mov dword ptr [ebp - local_14], 0x0          # 00442b9e
    mov dword ptr [ebp - local_10], 0x0          # 00442ba5
    mov dword ptr [ebp - local_c], 0x1           # 00442bac
    lea ecx, [ebp - local_1d4]                   # 00442bb3
    push ecx                                     # 00442bb9
    mov ecx, 0x6177e8                            # 00442bba
    call FUN_0041fa11                            # 00442bbf
L_00442bc4:
    # block 0x00442bc4: entered by jne at 0x00442b25; jne at 0x00442b32, 2 instruction(s), ends with jne to 0x00442c6a (forward)
    cmp dword ptr [0x586bf9], 0x1                # 00442bc4
    jne.d32 L_00442c6a                           # 00442bcb
    # block 0x00442bd1: entered by fall-through of jne at 0x00442bcb, 2 instruction(s), ends with jne to 0x00442c6a (forward)
    cmp dword ptr [0x586edd], 0x0                # 00442bd1
    jne.d32 L_00442c6a                           # 00442bd8
    # block 0x00442bde: entered by fall-through of jne at 0x00442bd8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442c6a
    push 0x547e08                                # 00442bde
    push 0x63a740                                # 00442be3
    lea edx, [ebp - local_1ce]                   # 00442be8
    push edx                                     # 00442bee
    call FUN_0043f210                            # 00442bef
    add esp, 0xc                                 # 00442bf4
    mov edi, 0x547e10                            # 00442bf7
    lea edx, [ebp - local_3e]                    # 00442bfc
    or ecx, -0x1                                 # 00442bff
    {load} xor eax, eax                          # 00442c02
    repne scasb al, byte ptr es:[edi]            # 00442c04
    not ecx                                      # 00442c06
    {load} sub edi, ecx                          # 00442c08
    {load} mov esi, edi                          # 00442c0a
    {load} mov eax, ecx                          # 00442c0c
    {load} mov edi, edx                          # 00442c0e
    shr ecx, 0x2                                 # 00442c10
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442c13
    {load} mov ecx, eax                          # 00442c15
    and ecx, 0x3                                 # 00442c17
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442c1a
    mov word ptr [ebp - local_1c], 0x1397        # 00442c1c
    mov word ptr [ebp - local_1a], 0x0           # 00442c22
    mov word ptr [ebp - local_18], 0x0           # 00442c28
    mov word ptr [ebp - local_16], 0x1           # 00442c2e
    mov word ptr [ebp - local_8], 0xffff         # 00442c34
    mov byte ptr [ebp - local_6], 0x0            # 00442c3a
    mov word ptr [ebp - local_5], 0x2            # 00442c3e
    mov dword ptr [ebp - local_14], 0x0          # 00442c44
    mov dword ptr [ebp - local_10], 0x0          # 00442c4b
    mov dword ptr [ebp - local_c], 0x1           # 00442c52
    lea ecx, [ebp - local_1d4]                   # 00442c59
    push ecx                                     # 00442c5f
    mov ecx, 0x6177e8                            # 00442c60
    call FUN_0041fa11                            # 00442c65
L_00442c6a:
    # block 0x00442c6a: entered by jne at 0x00442bcb; jne at 0x00442bd8, 2 instruction(s), ends with jne to 0x00442d10 (forward)
    cmp dword ptr [0x586bf1], 0x1                # 00442c6a
    jne.d32 L_00442d10                           # 00442c71
    # block 0x00442c77: entered by fall-through of jne at 0x00442c71, 2 instruction(s), ends with jne to 0x00442d10 (forward)
    cmp dword ptr [0x586edd], 0x0                # 00442c77
    jne.d32 L_00442d10                           # 00442c7e
    # block 0x00442c84: entered by fall-through of jne at 0x00442c7e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442d10
    push 0x547e18                                # 00442c84
    push 0x63a744                                # 00442c89
    lea edx, [ebp - local_1ce]                   # 00442c8e
    push edx                                     # 00442c94
    call FUN_0043f210                            # 00442c95
    add esp, 0xc                                 # 00442c9a
    mov edi, 0x547e20                            # 00442c9d
    lea edx, [ebp - local_3e]                    # 00442ca2
    or ecx, -0x1                                 # 00442ca5
    {load} xor eax, eax                          # 00442ca8
    repne scasb al, byte ptr es:[edi]            # 00442caa
    not ecx                                      # 00442cac
    {load} sub edi, ecx                          # 00442cae
    {load} mov esi, edi                          # 00442cb0
    {load} mov eax, ecx                          # 00442cb2
    {load} mov edi, edx                          # 00442cb4
    shr ecx, 0x2                                 # 00442cb6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442cb9
    {load} mov ecx, eax                          # 00442cbb
    and ecx, 0x3                                 # 00442cbd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442cc0
    mov word ptr [ebp - local_1c], 0x1398        # 00442cc2
    mov word ptr [ebp - local_1a], 0x0           # 00442cc8
    mov word ptr [ebp - local_18], 0x0           # 00442cce
    mov word ptr [ebp - local_16], 0x1           # 00442cd4
    mov word ptr [ebp - local_8], 0xffff         # 00442cda
    mov byte ptr [ebp - local_6], 0x0            # 00442ce0
    mov word ptr [ebp - local_5], 0x2            # 00442ce4
    mov dword ptr [ebp - local_14], 0x0          # 00442cea
    mov dword ptr [ebp - local_10], 0x0          # 00442cf1
    mov dword ptr [ebp - local_c], 0x1           # 00442cf8
    lea ecx, [ebp - local_1d4]                   # 00442cff
    push ecx                                     # 00442d05
    mov ecx, 0x6177e8                            # 00442d06
    call FUN_0041fa11                            # 00442d0b
L_00442d10:
    # block 0x00442d10: entered by jne at 0x00442c71; jne at 0x00442c7e, 2 instruction(s), ends with jne to 0x00442db6 (forward)
    cmp dword ptr [0x586bc9], 0x1                # 00442d10
    jne.d32 L_00442db6                           # 00442d17
    # block 0x00442d1d: entered by fall-through of jne at 0x00442d17, 2 instruction(s), ends with jne to 0x00442db6 (forward)
    cmp dword ptr [0x586e95], 0x0                # 00442d1d
    jne.d32 L_00442db6                           # 00442d24
    # block 0x00442d2a: entered by fall-through of jne at 0x00442d24, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442db6
    push 0x547e28                                # 00442d2a
    push 0x63a748                                # 00442d2f
    lea edx, [ebp - local_1ce]                   # 00442d34
    push edx                                     # 00442d3a
    call FUN_0043f210                            # 00442d3b
    add esp, 0xc                                 # 00442d40
    mov edi, 0x547e30                            # 00442d43
    lea edx, [ebp - local_3e]                    # 00442d48
    or ecx, -0x1                                 # 00442d4b
    {load} xor eax, eax                          # 00442d4e
    repne scasb al, byte ptr es:[edi]            # 00442d50
    not ecx                                      # 00442d52
    {load} sub edi, ecx                          # 00442d54
    {load} mov esi, edi                          # 00442d56
    {load} mov eax, ecx                          # 00442d58
    {load} mov edi, edx                          # 00442d5a
    shr ecx, 0x2                                 # 00442d5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442d5f
    {load} mov ecx, eax                          # 00442d61
    and ecx, 0x3                                 # 00442d63
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442d66
    mov word ptr [ebp - local_1c], 0x1399        # 00442d68
    mov word ptr [ebp - local_1a], 0x0           # 00442d6e
    mov word ptr [ebp - local_18], 0x0           # 00442d74
    mov word ptr [ebp - local_16], 0x1           # 00442d7a
    mov word ptr [ebp - local_8], 0xffff         # 00442d80
    mov byte ptr [ebp - local_6], 0x0            # 00442d86
    mov word ptr [ebp - local_5], 0x2            # 00442d8a
    mov dword ptr [ebp - local_14], 0x0          # 00442d90
    mov dword ptr [ebp - local_10], 0x0          # 00442d97
    mov dword ptr [ebp - local_c], 0x1           # 00442d9e
    lea ecx, [ebp - local_1d4]                   # 00442da5
    push ecx                                     # 00442dab
    mov ecx, 0x6177e8                            # 00442dac
    call FUN_0041fa11                            # 00442db1
L_00442db6:
    # block 0x00442db6: entered by jne at 0x00442d17; jne at 0x00442d24, 2 instruction(s), ends with jne to 0x00442e5c (forward)
    cmp dword ptr [0x586c39], 0x1                # 00442db6
    jne.d32 L_00442e5c                           # 00442dbd
    # block 0x00442dc3: entered by fall-through of jne at 0x00442dbd, 2 instruction(s), ends with jne to 0x00442e5c (forward)
    cmp dword ptr [0x586f39], 0x0                # 00442dc3
    jne.d32 L_00442e5c                           # 00442dca
    # block 0x00442dd0: entered by fall-through of jne at 0x00442dca, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442e5c
    push 0x547e38                                # 00442dd0
    push 0x63a74c                                # 00442dd5
    lea edx, [ebp - local_1ce]                   # 00442dda
    push edx                                     # 00442de0
    call FUN_0043f210                            # 00442de1
    add esp, 0xc                                 # 00442de6
    mov edi, 0x547e40                            # 00442de9
    lea edx, [ebp - local_3e]                    # 00442dee
    or ecx, -0x1                                 # 00442df1
    {load} xor eax, eax                          # 00442df4
    repne scasb al, byte ptr es:[edi]            # 00442df6
    not ecx                                      # 00442df8
    {load} sub edi, ecx                          # 00442dfa
    {load} mov esi, edi                          # 00442dfc
    {load} mov eax, ecx                          # 00442dfe
    {load} mov edi, edx                          # 00442e00
    shr ecx, 0x2                                 # 00442e02
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442e05
    {load} mov ecx, eax                          # 00442e07
    and ecx, 0x3                                 # 00442e09
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442e0c
    mov word ptr [ebp - local_1c], 0x139a        # 00442e0e
    mov word ptr [ebp - local_1a], 0x0           # 00442e14
    mov word ptr [ebp - local_18], 0x0           # 00442e1a
    mov word ptr [ebp - local_16], 0x1           # 00442e20
    mov word ptr [ebp - local_8], 0xffff         # 00442e26
    mov byte ptr [ebp - local_6], 0x0            # 00442e2c
    mov word ptr [ebp - local_5], 0x2            # 00442e30
    mov dword ptr [ebp - local_14], 0x0          # 00442e36
    mov dword ptr [ebp - local_10], 0x0          # 00442e3d
    mov dword ptr [ebp - local_c], 0x1           # 00442e44
    lea ecx, [ebp - local_1d4]                   # 00442e4b
    push ecx                                     # 00442e51
    mov ecx, 0x6177e8                            # 00442e52
    call FUN_0041fa11                            # 00442e57
L_00442e5c:
    # block 0x00442e5c: entered by jne at 0x00442dbd; jne at 0x00442dca, 2 instruction(s), ends with jne to 0x00442f02 (forward)
    cmp dword ptr [0x586be1], 0x1                # 00442e5c
    jne.d32 L_00442f02                           # 00442e63
    # block 0x00442e69: entered by fall-through of jne at 0x00442e63, 2 instruction(s), ends with jne to 0x00442f02 (forward)
    cmp dword ptr [0x586ec1], 0x0                # 00442e69
    jne.d32 L_00442f02                           # 00442e70
    # block 0x00442e76: entered by fall-through of jne at 0x00442e70, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442f02
    push 0x547e48                                # 00442e76
    push 0x63a750                                # 00442e7b
    lea edx, [ebp - local_1ce]                   # 00442e80
    push edx                                     # 00442e86
    call FUN_0043f210                            # 00442e87
    add esp, 0xc                                 # 00442e8c
    mov edi, 0x547e50                            # 00442e8f
    lea edx, [ebp - local_3e]                    # 00442e94
    or ecx, -0x1                                 # 00442e97
    {load} xor eax, eax                          # 00442e9a
    repne scasb al, byte ptr es:[edi]            # 00442e9c
    not ecx                                      # 00442e9e
    {load} sub edi, ecx                          # 00442ea0
    {load} mov esi, edi                          # 00442ea2
    {load} mov eax, ecx                          # 00442ea4
    {load} mov edi, edx                          # 00442ea6
    shr ecx, 0x2                                 # 00442ea8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442eab
    {load} mov ecx, eax                          # 00442ead
    and ecx, 0x3                                 # 00442eaf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442eb2
    mov word ptr [ebp - local_1c], 0x139b        # 00442eb4
    mov word ptr [ebp - local_1a], 0x0           # 00442eba
    mov word ptr [ebp - local_18], 0x0           # 00442ec0
    mov word ptr [ebp - local_16], 0x1           # 00442ec6
    mov word ptr [ebp - local_8], 0xffff         # 00442ecc
    mov byte ptr [ebp - local_6], 0x0            # 00442ed2
    mov word ptr [ebp - local_5], 0x2            # 00442ed6
    mov dword ptr [ebp - local_14], 0x0          # 00442edc
    mov dword ptr [ebp - local_10], 0x0          # 00442ee3
    mov dword ptr [ebp - local_c], 0x1           # 00442eea
    lea ecx, [ebp - local_1d4]                   # 00442ef1
    push ecx                                     # 00442ef7
    mov ecx, 0x6177e8                            # 00442ef8
    call FUN_0041fa11                            # 00442efd
L_00442f02:
    # block 0x00442f02: entered by jne at 0x00442e63; jne at 0x00442e70, 2 instruction(s), ends with jne to 0x00442fa8 (forward)
    cmp dword ptr [0x586bd9], 0x1                # 00442f02
    jne.d32 L_00442fa8                           # 00442f09
    # block 0x00442f0f: entered by fall-through of jne at 0x00442f09, 2 instruction(s), ends with jne to 0x00442fa8 (forward)
    cmp dword ptr [0x586eb5], 0x0                # 00442f0f
    jne.d32 L_00442fa8                           # 00442f16
    # block 0x00442f1c: entered by fall-through of jne at 0x00442f16, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00442fa8
    push 0x547e58                                # 00442f1c
    push 0x63a754                                # 00442f21
    lea edx, [ebp - local_1ce]                   # 00442f26
    push edx                                     # 00442f2c
    call FUN_0043f210                            # 00442f2d
    add esp, 0xc                                 # 00442f32
    mov edi, 0x547e60                            # 00442f35
    lea edx, [ebp - local_3e]                    # 00442f3a
    or ecx, -0x1                                 # 00442f3d
    {load} xor eax, eax                          # 00442f40
    repne scasb al, byte ptr es:[edi]            # 00442f42
    not ecx                                      # 00442f44
    {load} sub edi, ecx                          # 00442f46
    {load} mov esi, edi                          # 00442f48
    {load} mov eax, ecx                          # 00442f4a
    {load} mov edi, edx                          # 00442f4c
    shr ecx, 0x2                                 # 00442f4e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442f51
    {load} mov ecx, eax                          # 00442f53
    and ecx, 0x3                                 # 00442f55
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442f58
    mov word ptr [ebp - local_1c], 0x139c        # 00442f5a
    mov word ptr [ebp - local_1a], 0x0           # 00442f60
    mov word ptr [ebp - local_18], 0x0           # 00442f66
    mov word ptr [ebp - local_16], 0x1           # 00442f6c
    mov word ptr [ebp - local_8], 0xffff         # 00442f72
    mov byte ptr [ebp - local_6], 0x0            # 00442f78
    mov word ptr [ebp - local_5], 0x2            # 00442f7c
    mov dword ptr [ebp - local_14], 0x0          # 00442f82
    mov dword ptr [ebp - local_10], 0x0          # 00442f89
    mov dword ptr [ebp - local_c], 0x1           # 00442f90
    lea ecx, [ebp - local_1d4]                   # 00442f97
    push ecx                                     # 00442f9d
    mov ecx, 0x6177e8                            # 00442f9e
    call FUN_0041fa11                            # 00442fa3
L_00442fa8:
    # block 0x00442fa8: entered by jne at 0x00442f09; jne at 0x00442f16, 2 instruction(s), ends with jne to 0x0044304e (forward)
    cmp dword ptr [0x586c05], 0x1                # 00442fa8
    jne.d32 L_0044304e                           # 00442faf
    # block 0x00442fb5: entered by fall-through of jne at 0x00442faf, 2 instruction(s), ends with jne to 0x0044304e (forward)
    cmp dword ptr [0x586f01], 0x0                # 00442fb5
    jne.d32 L_0044304e                           # 00442fbc
    # block 0x00442fc2: entered by fall-through of jne at 0x00442fbc, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044304e
    push 0x547e68                                # 00442fc2
    push 0x63a758                                # 00442fc7
    lea edx, [ebp - local_1ce]                   # 00442fcc
    push edx                                     # 00442fd2
    call FUN_0043f210                            # 00442fd3
    add esp, 0xc                                 # 00442fd8
    mov edi, 0x547e70                            # 00442fdb
    lea edx, [ebp - local_3e]                    # 00442fe0
    or ecx, -0x1                                 # 00442fe3
    {load} xor eax, eax                          # 00442fe6
    repne scasb al, byte ptr es:[edi]            # 00442fe8
    not ecx                                      # 00442fea
    {load} sub edi, ecx                          # 00442fec
    {load} mov esi, edi                          # 00442fee
    {load} mov eax, ecx                          # 00442ff0
    {load} mov edi, edx                          # 00442ff2
    shr ecx, 0x2                                 # 00442ff4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00442ff7
    {load} mov ecx, eax                          # 00442ff9
    and ecx, 0x3                                 # 00442ffb
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00442ffe
    mov word ptr [ebp - local_1c], 0x139d        # 00443000
    mov word ptr [ebp - local_1a], 0x0           # 00443006
    mov word ptr [ebp - local_18], 0x0           # 0044300c
    mov word ptr [ebp - local_16], 0x1           # 00443012
    mov word ptr [ebp - local_8], 0xffff         # 00443018
    mov byte ptr [ebp - local_6], 0x0            # 0044301e
    mov word ptr [ebp - local_5], 0x2            # 00443022
    mov dword ptr [ebp - local_14], 0x0          # 00443028
    mov dword ptr [ebp - local_10], 0x0          # 0044302f
    mov dword ptr [ebp - local_c], 0x1           # 00443036
    lea ecx, [ebp - local_1d4]                   # 0044303d
    push ecx                                     # 00443043
    mov ecx, 0x6177e8                            # 00443044
    call FUN_0041fa11                            # 00443049
L_0044304e:
    # block 0x0044304e: entered by jne at 0x00442faf; jne at 0x00442fbc, 2 instruction(s), ends with jne to 0x004430f4 (forward)
    cmp dword ptr [0x586bd5], 0x1                # 0044304e
    jne.d32 L_004430f4                           # 00443055
    # block 0x0044305b: entered by fall-through of jne at 0x00443055, 2 instruction(s), ends with jne to 0x004430f4 (forward)
    cmp dword ptr [0x586ead], 0x0                # 0044305b
    jne.d32 L_004430f4                           # 00443062
    # block 0x00443068: entered by fall-through of jne at 0x00443062, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004430f4
    push 0x547e78                                # 00443068
    push 0x63a75c                                # 0044306d
    lea edx, [ebp - local_1ce]                   # 00443072
    push edx                                     # 00443078
    call FUN_0043f210                            # 00443079
    add esp, 0xc                                 # 0044307e
    mov edi, 0x547e80                            # 00443081
    lea edx, [ebp - local_3e]                    # 00443086
    or ecx, -0x1                                 # 00443089
    {load} xor eax, eax                          # 0044308c
    repne scasb al, byte ptr es:[edi]            # 0044308e
    not ecx                                      # 00443090
    {load} sub edi, ecx                          # 00443092
    {load} mov esi, edi                          # 00443094
    {load} mov eax, ecx                          # 00443096
    {load} mov edi, edx                          # 00443098
    shr ecx, 0x2                                 # 0044309a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044309d
    {load} mov ecx, eax                          # 0044309f
    and ecx, 0x3                                 # 004430a1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004430a4
    mov word ptr [ebp - local_1c], 0x139e        # 004430a6
    mov word ptr [ebp - local_1a], 0x0           # 004430ac
    mov word ptr [ebp - local_18], 0x0           # 004430b2
    mov word ptr [ebp - local_16], 0x1           # 004430b8
    mov word ptr [ebp - local_8], 0xffff         # 004430be
    mov byte ptr [ebp - local_6], 0x0            # 004430c4
    mov word ptr [ebp - local_5], 0x2            # 004430c8
    mov dword ptr [ebp - local_14], 0x0          # 004430ce
    mov dword ptr [ebp - local_10], 0x0          # 004430d5
    mov dword ptr [ebp - local_c], 0x1           # 004430dc
    lea ecx, [ebp - local_1d4]                   # 004430e3
    push ecx                                     # 004430e9
    mov ecx, 0x6177e8                            # 004430ea
    call FUN_0041fa11                            # 004430ef
L_004430f4:
    # block 0x004430f4: entered by jne at 0x00443055; jne at 0x00443062, 2 instruction(s), ends with jne to 0x0044319a (forward)
    cmp dword ptr [0x586c21], 0x1                # 004430f4
    jne.d32 L_0044319a                           # 004430fb
    # block 0x00443101: entered by fall-through of jne at 0x004430fb, 2 instruction(s), ends with jne to 0x0044319a (forward)
    cmp dword ptr [0x586f29], 0x0                # 00443101
    jne.d32 L_0044319a                           # 00443108
    # block 0x0044310e: entered by fall-through of jne at 0x00443108, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044319a
    push 0x547e88                                # 0044310e
    push 0x63a760                                # 00443113
    lea edx, [ebp - local_1ce]                   # 00443118
    push edx                                     # 0044311e
    call FUN_0043f210                            # 0044311f
    add esp, 0xc                                 # 00443124
    mov edi, 0x547e90                            # 00443127
    lea edx, [ebp - local_3e]                    # 0044312c
    or ecx, -0x1                                 # 0044312f
    {load} xor eax, eax                          # 00443132
    repne scasb al, byte ptr es:[edi]            # 00443134
    not ecx                                      # 00443136
    {load} sub edi, ecx                          # 00443138
    {load} mov esi, edi                          # 0044313a
    {load} mov eax, ecx                          # 0044313c
    {load} mov edi, edx                          # 0044313e
    shr ecx, 0x2                                 # 00443140
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443143
    {load} mov ecx, eax                          # 00443145
    and ecx, 0x3                                 # 00443147
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044314a
    mov word ptr [ebp - local_1c], 0x139f        # 0044314c
    mov word ptr [ebp - local_1a], 0x0           # 00443152
    mov word ptr [ebp - local_18], 0x0           # 00443158
    mov word ptr [ebp - local_16], 0x1           # 0044315e
    mov word ptr [ebp - local_8], 0xffff         # 00443164
    mov byte ptr [ebp - local_6], 0x0            # 0044316a
    mov word ptr [ebp - local_5], 0x2            # 0044316e
    mov dword ptr [ebp - local_14], 0x0          # 00443174
    mov dword ptr [ebp - local_10], 0x0          # 0044317b
    mov dword ptr [ebp - local_c], 0x1           # 00443182
    lea ecx, [ebp - local_1d4]                   # 00443189
    push ecx                                     # 0044318f
    mov ecx, 0x6177e8                            # 00443190
    call FUN_0041fa11                            # 00443195
L_0044319a:
    # block 0x0044319a: entered by jne at 0x004430fb; jne at 0x00443108, 2 instruction(s), ends with jne to 0x00443240 (forward)
    cmp dword ptr [0x586c2d], 0x1                # 0044319a
    jne.d32 L_00443240                           # 004431a1
    # block 0x004431a7: entered by fall-through of jne at 0x004431a1, 2 instruction(s), ends with jne to 0x00443240 (forward)
    cmp dword ptr [0x586f35], 0x0                # 004431a7
    jne.d32 L_00443240                           # 004431ae
    # block 0x004431b4: entered by fall-through of jne at 0x004431ae, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443240
    push 0x547e98                                # 004431b4
    push 0x63a764                                # 004431b9
    lea edx, [ebp - local_1ce]                   # 004431be
    push edx                                     # 004431c4
    call FUN_0043f210                            # 004431c5
    add esp, 0xc                                 # 004431ca
    mov edi, 0x547ea0                            # 004431cd
    lea edx, [ebp - local_3e]                    # 004431d2
    or ecx, -0x1                                 # 004431d5
    {load} xor eax, eax                          # 004431d8
    repne scasb al, byte ptr es:[edi]            # 004431da
    not ecx                                      # 004431dc
    {load} sub edi, ecx                          # 004431de
    {load} mov esi, edi                          # 004431e0
    {load} mov eax, ecx                          # 004431e2
    {load} mov edi, edx                          # 004431e4
    shr ecx, 0x2                                 # 004431e6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004431e9
    {load} mov ecx, eax                          # 004431eb
    and ecx, 0x3                                 # 004431ed
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004431f0
    mov word ptr [ebp - local_1c], 0x13a0        # 004431f2
    mov word ptr [ebp - local_1a], 0x0           # 004431f8
    mov word ptr [ebp - local_18], 0x0           # 004431fe
    mov word ptr [ebp - local_16], 0x1           # 00443204
    mov word ptr [ebp - local_8], 0xffff         # 0044320a
    mov byte ptr [ebp - local_6], 0x0            # 00443210
    mov word ptr [ebp - local_5], 0x2            # 00443214
    mov dword ptr [ebp - local_14], 0x0          # 0044321a
    mov dword ptr [ebp - local_10], 0x0          # 00443221
    mov dword ptr [ebp - local_c], 0x1           # 00443228
    lea ecx, [ebp - local_1d4]                   # 0044322f
    push ecx                                     # 00443235
    mov ecx, 0x6177e8                            # 00443236
    call FUN_0041fa11                            # 0044323b
L_00443240:
    # block 0x00443240: entered by jne at 0x004431a1; jne at 0x004431ae, 2 instruction(s), ends with jne to 0x004432e6 (forward)
    cmp dword ptr [0x586bc1], 0x1                # 00443240
    jne.d32 L_004432e6                           # 00443247
    # block 0x0044324d: entered by fall-through of jne at 0x00443247, 2 instruction(s), ends with jne to 0x004432e6 (forward)
    cmp dword ptr [0x586e85], 0x0                # 0044324d
    jne.d32 L_004432e6                           # 00443254
    # block 0x0044325a: entered by fall-through of jne at 0x00443254, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004432e6
    push 0x547ea8                                # 0044325a
    push 0x63a768                                # 0044325f
    lea edx, [ebp - local_1ce]                   # 00443264
    push edx                                     # 0044326a
    call FUN_0043f210                            # 0044326b
    add esp, 0xc                                 # 00443270
    mov edi, 0x547eb0                            # 00443273
    lea edx, [ebp - local_3e]                    # 00443278
    or ecx, -0x1                                 # 0044327b
    {load} xor eax, eax                          # 0044327e
    repne scasb al, byte ptr es:[edi]            # 00443280
    not ecx                                      # 00443282
    {load} sub edi, ecx                          # 00443284
    {load} mov esi, edi                          # 00443286
    {load} mov eax, ecx                          # 00443288
    {load} mov edi, edx                          # 0044328a
    shr ecx, 0x2                                 # 0044328c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044328f
    {load} mov ecx, eax                          # 00443291
    and ecx, 0x3                                 # 00443293
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443296
    mov word ptr [ebp - local_1c], 0x13a1        # 00443298
    mov word ptr [ebp - local_1a], 0x0           # 0044329e
    mov word ptr [ebp - local_18], 0x0           # 004432a4
    mov word ptr [ebp - local_16], 0x1           # 004432aa
    mov word ptr [ebp - local_8], 0xffff         # 004432b0
    mov byte ptr [ebp - local_6], 0x0            # 004432b6
    mov word ptr [ebp - local_5], 0x2            # 004432ba
    mov dword ptr [ebp - local_14], 0x0          # 004432c0
    mov dword ptr [ebp - local_10], 0x0          # 004432c7
    mov dword ptr [ebp - local_c], 0x1           # 004432ce
    lea ecx, [ebp - local_1d4]                   # 004432d5
    push ecx                                     # 004432db
    mov ecx, 0x6177e8                            # 004432dc
    call FUN_0041fa11                            # 004432e1
L_004432e6:
    # block 0x004432e6: entered by jne at 0x00443247; jne at 0x00443254, 2 instruction(s), ends with jne to 0x0044338c (forward)
    cmp dword ptr [0x586bc5], 0x1                # 004432e6
    jne.d32 L_0044338c                           # 004432ed
    # block 0x004432f3: entered by fall-through of jne at 0x004432ed, 2 instruction(s), ends with jne to 0x0044338c (forward)
    cmp dword ptr [0x586e91], 0x0                # 004432f3
    jne.d32 L_0044338c                           # 004432fa
    # block 0x00443300: entered by fall-through of jne at 0x004432fa, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044338c
    push 0x547eb8                                # 00443300
    push 0x63a76c                                # 00443305
    lea edx, [ebp - local_1ce]                   # 0044330a
    push edx                                     # 00443310
    call FUN_0043f210                            # 00443311
    add esp, 0xc                                 # 00443316
    mov edi, 0x547ec0                            # 00443319
    lea edx, [ebp - local_3e]                    # 0044331e
    or ecx, -0x1                                 # 00443321
    {load} xor eax, eax                          # 00443324
    repne scasb al, byte ptr es:[edi]            # 00443326
    not ecx                                      # 00443328
    {load} sub edi, ecx                          # 0044332a
    {load} mov esi, edi                          # 0044332c
    {load} mov eax, ecx                          # 0044332e
    {load} mov edi, edx                          # 00443330
    shr ecx, 0x2                                 # 00443332
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443335
    {load} mov ecx, eax                          # 00443337
    and ecx, 0x3                                 # 00443339
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044333c
    mov word ptr [ebp - local_1c], 0x13a2        # 0044333e
    mov word ptr [ebp - local_1a], 0x0           # 00443344
    mov word ptr [ebp - local_18], 0x0           # 0044334a
    mov word ptr [ebp - local_16], 0x1           # 00443350
    mov word ptr [ebp - local_8], 0xffff         # 00443356
    mov byte ptr [ebp - local_6], 0x0            # 0044335c
    mov word ptr [ebp - local_5], 0x2            # 00443360
    mov dword ptr [ebp - local_14], 0x0          # 00443366
    mov dword ptr [ebp - local_10], 0x0          # 0044336d
    mov dword ptr [ebp - local_c], 0x1           # 00443374
    lea ecx, [ebp - local_1d4]                   # 0044337b
    push ecx                                     # 00443381
    mov ecx, 0x6177e8                            # 00443382
    call FUN_0041fa11                            # 00443387
L_0044338c:
    # block 0x0044338c: entered by jne at 0x004432ed; jne at 0x004432fa, 2 instruction(s), ends with jne to 0x00443432 (forward)
    cmp dword ptr [0x586bdd], 0x1                # 0044338c
    jne.d32 L_00443432                           # 00443393
    # block 0x00443399: entered by fall-through of jne at 0x00443393, 2 instruction(s), ends with jne to 0x00443432 (forward)
    cmp dword ptr [0x586eb9], 0x0                # 00443399
    jne.d32 L_00443432                           # 004433a0
    # block 0x004433a6: entered by fall-through of jne at 0x004433a0, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443432
    push 0x547ec8                                # 004433a6
    push 0x63a770                                # 004433ab
    lea edx, [ebp - local_1ce]                   # 004433b0
    push edx                                     # 004433b6
    call FUN_0043f210                            # 004433b7
    add esp, 0xc                                 # 004433bc
    mov edi, 0x547ed0                            # 004433bf
    lea edx, [ebp - local_3e]                    # 004433c4
    or ecx, -0x1                                 # 004433c7
    {load} xor eax, eax                          # 004433ca
    repne scasb al, byte ptr es:[edi]            # 004433cc
    not ecx                                      # 004433ce
    {load} sub edi, ecx                          # 004433d0
    {load} mov esi, edi                          # 004433d2
    {load} mov eax, ecx                          # 004433d4
    {load} mov edi, edx                          # 004433d6
    shr ecx, 0x2                                 # 004433d8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004433db
    {load} mov ecx, eax                          # 004433dd
    and ecx, 0x3                                 # 004433df
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004433e2
    mov word ptr [ebp - local_1c], 0x13a4        # 004433e4
    mov word ptr [ebp - local_1a], 0x0           # 004433ea
    mov word ptr [ebp - local_18], 0x0           # 004433f0
    mov word ptr [ebp - local_16], 0x1           # 004433f6
    mov word ptr [ebp - local_8], 0xffff         # 004433fc
    mov byte ptr [ebp - local_6], 0x0            # 00443402
    mov word ptr [ebp - local_5], 0x2            # 00443406
    mov dword ptr [ebp - local_14], 0x0          # 0044340c
    mov dword ptr [ebp - local_10], 0x0          # 00443413
    mov dword ptr [ebp - local_c], 0x1           # 0044341a
    lea ecx, [ebp - local_1d4]                   # 00443421
    push ecx                                     # 00443427
    mov ecx, 0x6177e8                            # 00443428
    call FUN_0041fa11                            # 0044342d
L_00443432:
    # block 0x00443432: entered by jne at 0x00443393; jne at 0x004433a0, 2 instruction(s), ends with jne to 0x004434d8 (forward)
    cmp dword ptr [0x586bf5], 0x1                # 00443432
    jne.d32 L_004434d8                           # 00443439
    # block 0x0044343f: entered by fall-through of jne at 0x00443439, 2 instruction(s), ends with jne to 0x004434d8 (forward)
    cmp dword ptr [0x586ef1], 0x0                # 0044343f
    jne.d32 L_004434d8                           # 00443446
    # block 0x0044344c: entered by fall-through of jne at 0x00443446, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004434d8
    push 0x547ed8                                # 0044344c
    push 0x63a774                                # 00443451
    lea edx, [ebp - local_1ce]                   # 00443456
    push edx                                     # 0044345c
    call FUN_0043f210                            # 0044345d
    add esp, 0xc                                 # 00443462
    mov edi, 0x547ee0                            # 00443465
    lea edx, [ebp - local_3e]                    # 0044346a
    or ecx, -0x1                                 # 0044346d
    {load} xor eax, eax                          # 00443470
    repne scasb al, byte ptr es:[edi]            # 00443472
    not ecx                                      # 00443474
    {load} sub edi, ecx                          # 00443476
    {load} mov esi, edi                          # 00443478
    {load} mov eax, ecx                          # 0044347a
    {load} mov edi, edx                          # 0044347c
    shr ecx, 0x2                                 # 0044347e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443481
    {load} mov ecx, eax                          # 00443483
    and ecx, 0x3                                 # 00443485
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443488
    mov word ptr [ebp - local_1c], 0x13a5        # 0044348a
    mov word ptr [ebp - local_1a], 0x0           # 00443490
    mov word ptr [ebp - local_18], 0x0           # 00443496
    mov word ptr [ebp - local_16], 0x1           # 0044349c
    mov word ptr [ebp - local_8], 0xffff         # 004434a2
    mov byte ptr [ebp - local_6], 0x0            # 004434a8
    mov word ptr [ebp - local_5], 0x2            # 004434ac
    mov dword ptr [ebp - local_14], 0x0          # 004434b2
    mov dword ptr [ebp - local_10], 0x0          # 004434b9
    mov dword ptr [ebp - local_c], 0x1           # 004434c0
    lea ecx, [ebp - local_1d4]                   # 004434c7
    push ecx                                     # 004434cd
    mov ecx, 0x6177e8                            # 004434ce
    call FUN_0041fa11                            # 004434d3
L_004434d8:
    # block 0x004434d8: entered by jne at 0x00443439; jne at 0x00443446, 2 instruction(s), ends with jne to 0x0044357e (forward)
    cmp dword ptr [0x586c11], 0x1                # 004434d8
    jne.d32 L_0044357e                           # 004434df
    # block 0x004434e5: entered by fall-through of jne at 0x004434df, 2 instruction(s), ends with jne to 0x0044357e (forward)
    cmp dword ptr [0x586f15], 0x0                # 004434e5
    jne.d32 L_0044357e                           # 004434ec
    # block 0x004434f2: entered by fall-through of jne at 0x004434ec, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044357e
    push 0x547ee8                                # 004434f2
    push 0x63a778                                # 004434f7
    lea edx, [ebp - local_1ce]                   # 004434fc
    push edx                                     # 00443502
    call FUN_0043f210                            # 00443503
    add esp, 0xc                                 # 00443508
    mov edi, 0x547ef0                            # 0044350b
    lea edx, [ebp - local_3e]                    # 00443510
    or ecx, -0x1                                 # 00443513
    {load} xor eax, eax                          # 00443516
    repne scasb al, byte ptr es:[edi]            # 00443518
    not ecx                                      # 0044351a
    {load} sub edi, ecx                          # 0044351c
    {load} mov esi, edi                          # 0044351e
    {load} mov eax, ecx                          # 00443520
    {load} mov edi, edx                          # 00443522
    shr ecx, 0x2                                 # 00443524
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443527
    {load} mov ecx, eax                          # 00443529
    and ecx, 0x3                                 # 0044352b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044352e
    mov word ptr [ebp - local_1c], 0x13a6        # 00443530
    mov word ptr [ebp - local_1a], 0x0           # 00443536
    mov word ptr [ebp - local_18], 0x0           # 0044353c
    mov word ptr [ebp - local_16], 0x1           # 00443542
    mov word ptr [ebp - local_8], 0xffff         # 00443548
    mov byte ptr [ebp - local_6], 0x0            # 0044354e
    mov word ptr [ebp - local_5], 0x2            # 00443552
    mov dword ptr [ebp - local_14], 0x0          # 00443558
    mov dword ptr [ebp - local_10], 0x0          # 0044355f
    mov dword ptr [ebp - local_c], 0x1           # 00443566
    lea ecx, [ebp - local_1d4]                   # 0044356d
    push ecx                                     # 00443573
    mov ecx, 0x6177e8                            # 00443574
    call FUN_0041fa11                            # 00443579
L_0044357e:
    # block 0x0044357e: entered by jne at 0x004434df; jne at 0x004434ec, 2 instruction(s), ends with jne to 0x00443624 (forward)
    cmp dword ptr [0x586c15], 0x1                # 0044357e
    jne.d32 L_00443624                           # 00443585
    # block 0x0044358b: entered by fall-through of jne at 0x00443585, 2 instruction(s), ends with jne to 0x00443624 (forward)
    cmp dword ptr [0x586f15], 0x0                # 0044358b
    jne.d32 L_00443624                           # 00443592
    # block 0x00443598: entered by fall-through of jne at 0x00443592, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443624
    push 0x547ef8                                # 00443598
    push 0x63a77c                                # 0044359d
    lea edx, [ebp - local_1ce]                   # 004435a2
    push edx                                     # 004435a8
    call FUN_0043f210                            # 004435a9
    add esp, 0xc                                 # 004435ae
    mov edi, 0x547f00                            # 004435b1
    lea edx, [ebp - local_3e]                    # 004435b6
    or ecx, -0x1                                 # 004435b9
    {load} xor eax, eax                          # 004435bc
    repne scasb al, byte ptr es:[edi]            # 004435be
    not ecx                                      # 004435c0
    {load} sub edi, ecx                          # 004435c2
    {load} mov esi, edi                          # 004435c4
    {load} mov eax, ecx                          # 004435c6
    {load} mov edi, edx                          # 004435c8
    shr ecx, 0x2                                 # 004435ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004435cd
    {load} mov ecx, eax                          # 004435cf
    and ecx, 0x3                                 # 004435d1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004435d4
    mov word ptr [ebp - local_1c], 0x13a7        # 004435d6
    mov word ptr [ebp - local_1a], 0x0           # 004435dc
    mov word ptr [ebp - local_18], 0x0           # 004435e2
    mov word ptr [ebp - local_16], 0x1           # 004435e8
    mov word ptr [ebp - local_8], 0xffff         # 004435ee
    mov byte ptr [ebp - local_6], 0x0            # 004435f4
    mov word ptr [ebp - local_5], 0x2            # 004435f8
    mov dword ptr [ebp - local_14], 0x0          # 004435fe
    mov dword ptr [ebp - local_10], 0x0          # 00443605
    mov dword ptr [ebp - local_c], 0x1           # 0044360c
    lea ecx, [ebp - local_1d4]                   # 00443613
    push ecx                                     # 00443619
    mov ecx, 0x6177e8                            # 0044361a
    call FUN_0041fa11                            # 0044361f
L_00443624:
    # block 0x00443624: entered by jne at 0x00443585; jne at 0x00443592, 2 instruction(s), ends with jne to 0x004436ca (forward)
    cmp dword ptr [0x586c3d], 0x1                # 00443624
    jne.d32 L_004436ca                           # 0044362b
    # block 0x00443631: entered by fall-through of jne at 0x0044362b, 2 instruction(s), ends with jne to 0x004436ca (forward)
    cmp dword ptr [0x586f41], 0x0                # 00443631
    jne.d32 L_004436ca                           # 00443638
    # block 0x0044363e: entered by fall-through of jne at 0x00443638, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004436ca
    push 0x547f08                                # 0044363e
    push 0x63a780                                # 00443643
    lea edx, [ebp - local_1ce]                   # 00443648
    push edx                                     # 0044364e
    call FUN_0043f210                            # 0044364f
    add esp, 0xc                                 # 00443654
    mov edi, 0x547f10                            # 00443657
    lea edx, [ebp - local_3e]                    # 0044365c
    or ecx, -0x1                                 # 0044365f
    {load} xor eax, eax                          # 00443662
    repne scasb al, byte ptr es:[edi]            # 00443664
    not ecx                                      # 00443666
    {load} sub edi, ecx                          # 00443668
    {load} mov esi, edi                          # 0044366a
    {load} mov eax, ecx                          # 0044366c
    {load} mov edi, edx                          # 0044366e
    shr ecx, 0x2                                 # 00443670
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443673
    {load} mov ecx, eax                          # 00443675
    and ecx, 0x3                                 # 00443677
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044367a
    mov word ptr [ebp - local_1c], 0x13a8        # 0044367c
    mov word ptr [ebp - local_1a], 0x0           # 00443682
    mov word ptr [ebp - local_18], 0x0           # 00443688
    mov word ptr [ebp - local_16], 0x1           # 0044368e
    mov word ptr [ebp - local_8], 0xffff         # 00443694
    mov byte ptr [ebp - local_6], 0x0            # 0044369a
    mov word ptr [ebp - local_5], 0x2            # 0044369e
    mov dword ptr [ebp - local_14], 0x0          # 004436a4
    mov dword ptr [ebp - local_10], 0x0          # 004436ab
    mov dword ptr [ebp - local_c], 0x1           # 004436b2
    lea ecx, [ebp - local_1d4]                   # 004436b9
    push ecx                                     # 004436bf
    mov ecx, 0x6177e8                            # 004436c0
    call FUN_0041fa11                            # 004436c5
L_004436ca:
    # block 0x004436ca: entered by jne at 0x0044362b; jne at 0x00443638, 2 instruction(s), ends with jne to 0x00443770 (forward)
    cmp dword ptr [0x586bcd], 0x1                # 004436ca
    jne.d32 L_00443770                           # 004436d1
    # block 0x004436d7: entered by fall-through of jne at 0x004436d1, 2 instruction(s), ends with jne to 0x00443770 (forward)
    cmp dword ptr [0x586ea5], 0x0                # 004436d7
    jne.d32 L_00443770                           # 004436de
    # block 0x004436e4: entered by fall-through of jne at 0x004436de, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443770
    push 0x547f18                                # 004436e4
    push 0x63a784                                # 004436e9
    lea edx, [ebp - local_1ce]                   # 004436ee
    push edx                                     # 004436f4
    call FUN_0043f210                            # 004436f5
    add esp, 0xc                                 # 004436fa
    mov edi, 0x547f20                            # 004436fd
    lea edx, [ebp - local_3e]                    # 00443702
    or ecx, -0x1                                 # 00443705
    {load} xor eax, eax                          # 00443708
    repne scasb al, byte ptr es:[edi]            # 0044370a
    not ecx                                      # 0044370c
    {load} sub edi, ecx                          # 0044370e
    {load} mov esi, edi                          # 00443710
    {load} mov eax, ecx                          # 00443712
    {load} mov edi, edx                          # 00443714
    shr ecx, 0x2                                 # 00443716
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443719
    {load} mov ecx, eax                          # 0044371b
    and ecx, 0x3                                 # 0044371d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443720
    mov word ptr [ebp - local_1c], 0x13a9        # 00443722
    mov word ptr [ebp - local_1a], 0x0           # 00443728
    mov word ptr [ebp - local_18], 0x0           # 0044372e
    mov word ptr [ebp - local_16], 0x1           # 00443734
    mov word ptr [ebp - local_8], 0xffff         # 0044373a
    mov byte ptr [ebp - local_6], 0x0            # 00443740
    mov word ptr [ebp - local_5], 0x2            # 00443744
    mov dword ptr [ebp - local_14], 0x0          # 0044374a
    mov dword ptr [ebp - local_10], 0x0          # 00443751
    mov dword ptr [ebp - local_c], 0x1           # 00443758
    lea ecx, [ebp - local_1d4]                   # 0044375f
    push ecx                                     # 00443765
    mov ecx, 0x6177e8                            # 00443766
    call FUN_0041fa11                            # 0044376b
L_00443770:
    # block 0x00443770: entered by jne at 0x004436d1; jne at 0x004436de, 2 instruction(s), ends with jne to 0x00443816 (forward)
    cmp dword ptr [0x586bed], 0x1                # 00443770
    jne.d32 L_00443816                           # 00443777
    # block 0x0044377d: entered by fall-through of jne at 0x00443777, 2 instruction(s), ends with jne to 0x00443816 (forward)
    cmp dword ptr [0x586ee9], 0x0                # 0044377d
    jne.d32 L_00443816                           # 00443784
    # block 0x0044378a: entered by fall-through of jne at 0x00443784, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443816
    push 0x547f28                                # 0044378a
    push 0x63a788                                # 0044378f
    lea edx, [ebp - local_1ce]                   # 00443794
    push edx                                     # 0044379a
    call FUN_0043f210                            # 0044379b
    add esp, 0xc                                 # 004437a0
    mov edi, 0x547f30                            # 004437a3
    lea edx, [ebp - local_3e]                    # 004437a8
    or ecx, -0x1                                 # 004437ab
    {load} xor eax, eax                          # 004437ae
    repne scasb al, byte ptr es:[edi]            # 004437b0
    not ecx                                      # 004437b2
    {load} sub edi, ecx                          # 004437b4
    {load} mov esi, edi                          # 004437b6
    {load} mov eax, ecx                          # 004437b8
    {load} mov edi, edx                          # 004437ba
    shr ecx, 0x2                                 # 004437bc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004437bf
    {load} mov ecx, eax                          # 004437c1
    and ecx, 0x3                                 # 004437c3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004437c6
    mov word ptr [ebp - local_1c], 0x13aa        # 004437c8
    mov word ptr [ebp - local_1a], 0x0           # 004437ce
    mov word ptr [ebp - local_18], 0x0           # 004437d4
    mov word ptr [ebp - local_16], 0x1           # 004437da
    mov word ptr [ebp - local_8], 0xffff         # 004437e0
    mov byte ptr [ebp - local_6], 0x0            # 004437e6
    mov word ptr [ebp - local_5], 0x2            # 004437ea
    mov dword ptr [ebp - local_14], 0x0          # 004437f0
    mov dword ptr [ebp - local_10], 0x0          # 004437f7
    mov dword ptr [ebp - local_c], 0x1           # 004437fe
    lea ecx, [ebp - local_1d4]                   # 00443805
    push ecx                                     # 0044380b
    mov ecx, 0x6177e8                            # 0044380c
    call FUN_0041fa11                            # 00443811
L_00443816:
    # block 0x00443816: entered by jne at 0x00443777; jne at 0x00443784, 2 instruction(s), ends with jne to 0x004438bc (forward)
    cmp dword ptr [0x586bbd], 0x1                # 00443816
    jne.d32 L_004438bc                           # 0044381d
    # block 0x00443823: entered by fall-through of jne at 0x0044381d, 2 instruction(s), ends with jne to 0x004438bc (forward)
    cmp dword ptr [0x586e81], 0x0                # 00443823
    jne.d32 L_004438bc                           # 0044382a
    # block 0x00443830: entered by fall-through of jne at 0x0044382a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004438bc
    push 0x547f38                                # 00443830
    push 0x63a78c                                # 00443835
    lea edx, [ebp - local_1ce]                   # 0044383a
    push edx                                     # 00443840
    call FUN_0043f210                            # 00443841
    add esp, 0xc                                 # 00443846
    mov edi, 0x547f40                            # 00443849
    lea edx, [ebp - local_3e]                    # 0044384e
    or ecx, -0x1                                 # 00443851
    {load} xor eax, eax                          # 00443854
    repne scasb al, byte ptr es:[edi]            # 00443856
    not ecx                                      # 00443858
    {load} sub edi, ecx                          # 0044385a
    {load} mov esi, edi                          # 0044385c
    {load} mov eax, ecx                          # 0044385e
    {load} mov edi, edx                          # 00443860
    shr ecx, 0x2                                 # 00443862
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443865
    {load} mov ecx, eax                          # 00443867
    and ecx, 0x3                                 # 00443869
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044386c
    mov word ptr [ebp - local_1c], 0x13ab        # 0044386e
    mov word ptr [ebp - local_1a], 0x0           # 00443874
    mov word ptr [ebp - local_18], 0x0           # 0044387a
    mov word ptr [ebp - local_16], 0x1           # 00443880
    mov word ptr [ebp - local_8], 0xffff         # 00443886
    mov byte ptr [ebp - local_6], 0x0            # 0044388c
    mov word ptr [ebp - local_5], 0x2            # 00443890
    mov dword ptr [ebp - local_14], 0x0          # 00443896
    mov dword ptr [ebp - local_10], 0x0          # 0044389d
    mov dword ptr [ebp - local_c], 0x1           # 004438a4
    lea ecx, [ebp - local_1d4]                   # 004438ab
    push ecx                                     # 004438b1
    mov ecx, 0x6177e8                            # 004438b2
    call FUN_0041fa11                            # 004438b7
L_004438bc:
    # block 0x004438bc: entered by jne at 0x0044381d; jne at 0x0044382a, 2 instruction(s), ends with jne to 0x00443962 (forward)
    cmp dword ptr [0x586c29], 0x1                # 004438bc
    jne.d32 L_00443962                           # 004438c3
    # block 0x004438c9: entered by fall-through of jne at 0x004438c3, 2 instruction(s), ends with jne to 0x00443962 (forward)
    cmp dword ptr [0x586f2d], 0x0                # 004438c9
    jne.d32 L_00443962                           # 004438d0
    # block 0x004438d6: entered by fall-through of jne at 0x004438d0, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443962
    push 0x547f48                                # 004438d6
    push 0x63a790                                # 004438db
    lea edx, [ebp - local_1ce]                   # 004438e0
    push edx                                     # 004438e6
    call FUN_0043f210                            # 004438e7
    add esp, 0xc                                 # 004438ec
    mov edi, 0x547f50                            # 004438ef
    lea edx, [ebp - local_3e]                    # 004438f4
    or ecx, -0x1                                 # 004438f7
    {load} xor eax, eax                          # 004438fa
    repne scasb al, byte ptr es:[edi]            # 004438fc
    not ecx                                      # 004438fe
    {load} sub edi, ecx                          # 00443900
    {load} mov esi, edi                          # 00443902
    {load} mov eax, ecx                          # 00443904
    {load} mov edi, edx                          # 00443906
    shr ecx, 0x2                                 # 00443908
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044390b
    {load} mov ecx, eax                          # 0044390d
    and ecx, 0x3                                 # 0044390f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443912
    mov word ptr [ebp - local_1c], 0x13af        # 00443914
    mov word ptr [ebp - local_1a], 0x0           # 0044391a
    mov word ptr [ebp - local_18], 0x0           # 00443920
    mov word ptr [ebp - local_16], 0x1           # 00443926
    mov word ptr [ebp - local_8], 0xffff         # 0044392c
    mov byte ptr [ebp - local_6], 0x0            # 00443932
    mov word ptr [ebp - local_5], 0x2            # 00443936
    mov dword ptr [ebp - local_14], 0x0          # 0044393c
    mov dword ptr [ebp - local_10], 0x0          # 00443943
    mov dword ptr [ebp - local_c], 0x1           # 0044394a
    lea ecx, [ebp - local_1d4]                   # 00443951
    push ecx                                     # 00443957
    mov ecx, 0x6177e8                            # 00443958
    call FUN_0041fa11                            # 0044395d
L_00443962:
    # block 0x00443962: entered by jne at 0x004438c3; jne at 0x004438d0, 2 instruction(s), ends with je to 0x00443993 (forward)
    cmp dword ptr [0x587599], 0x1                # 00443962
    je.d8 L_00443993                             # 00443969
    # block 0x0044396b: entered by fall-through of je at 0x00443969, 2 instruction(s), ends with je to 0x00443993 (forward)
    cmp dword ptr [0x5874cd], 0x1                # 0044396b
    je.d8 L_00443993                             # 00443972
    # block 0x00443974: entered by fall-through of je at 0x00443972, 2 instruction(s), ends with je to 0x00443993 (forward)
    cmp dword ptr [0x587685], 0x1                # 00443974
    je.d8 L_00443993                             # 0044397b
    # block 0x0044397d: entered by fall-through of je at 0x0044397b, 2 instruction(s), ends with je to 0x00443993 (forward)
    cmp dword ptr [0x587675], 0x1                # 0044397d
    je.d8 L_00443993                             # 00443984
    # block 0x00443986: entered by fall-through of je at 0x00443984, 2 instruction(s), ends with jne to 0x00443a2c (forward)
    cmp dword ptr [0x5874a9], 0x1                # 00443986
    jne.d32 L_00443a2c                           # 0044398d
L_00443993:
    # block 0x00443993: entered by je at 0x00443969; je at 0x00443972; je at 0x0044397b; je at 0x00443984; more, 2 instruction(s), ends with jne to 0x00443a2c (forward)
    cmp dword ptr [0x586ee1], 0x0                # 00443993
    jne.d32 L_00443a2c                           # 0044399a
    # block 0x004439a0: entered by fall-through of jne at 0x0044399a, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443a2c
    push 0x547f58                                # 004439a0
    push 0x63a794                                # 004439a5
    lea edx, [ebp - local_1ce]                   # 004439aa
    push edx                                     # 004439b0
    call FUN_0043f210                            # 004439b1
    add esp, 0xc                                 # 004439b6
    mov edi, 0x547f60                            # 004439b9
    lea edx, [ebp - local_3e]                    # 004439be
    or ecx, -0x1                                 # 004439c1
    {load} xor eax, eax                          # 004439c4
    repne scasb al, byte ptr es:[edi]            # 004439c6
    not ecx                                      # 004439c8
    {load} sub edi, ecx                          # 004439ca
    {load} mov esi, edi                          # 004439cc
    {load} mov eax, ecx                          # 004439ce
    {load} mov edi, edx                          # 004439d0
    shr ecx, 0x2                                 # 004439d2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004439d5
    {load} mov ecx, eax                          # 004439d7
    and ecx, 0x3                                 # 004439d9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004439dc
    mov word ptr [ebp - local_1c], 0x13ad        # 004439de
    mov word ptr [ebp - local_1a], 0x0           # 004439e4
    mov word ptr [ebp - local_18], 0x0           # 004439ea
    mov word ptr [ebp - local_16], 0x1           # 004439f0
    mov word ptr [ebp - local_8], 0xffff         # 004439f6
    mov byte ptr [ebp - local_6], 0x0            # 004439fc
    mov word ptr [ebp - local_5], 0x2            # 00443a00
    mov dword ptr [ebp - local_14], 0x0          # 00443a06
    mov dword ptr [ebp - local_10], 0x0          # 00443a0d
    mov dword ptr [ebp - local_c], 0x1           # 00443a14
    lea ecx, [ebp - local_1d4]                   # 00443a1b
    push ecx                                     # 00443a21
    mov ecx, 0x6177e8                            # 00443a22
    call FUN_0041fa11                            # 00443a27
L_00443a2c:
    # block 0x00443a2c: entered by jne at 0x0044398d; jne at 0x0044399a, 2 instruction(s), ends with jne to 0x00443ad2 (forward)
    cmp dword ptr [0x586c1d], 0x1                # 00443a2c
    jne.d32 L_00443ad2                           # 00443a33
    # block 0x00443a39: entered by fall-through of jne at 0x00443a33, 2 instruction(s), ends with jne to 0x00443ad2 (forward)
    cmp dword ptr [0x586f25], 0x0                # 00443a39
    jne.d32 L_00443ad2                           # 00443a40
    # block 0x00443a46: entered by fall-through of jne at 0x00443a40, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443ad2
    push 0x547f68                                # 00443a46
    push 0x63a798                                # 00443a4b
    lea edx, [ebp - local_1ce]                   # 00443a50
    push edx                                     # 00443a56
    call FUN_0043f210                            # 00443a57
    add esp, 0xc                                 # 00443a5c
    mov edi, 0x547f70                            # 00443a5f
    lea edx, [ebp - local_3e]                    # 00443a64
    or ecx, -0x1                                 # 00443a67
    {load} xor eax, eax                          # 00443a6a
    repne scasb al, byte ptr es:[edi]            # 00443a6c
    not ecx                                      # 00443a6e
    {load} sub edi, ecx                          # 00443a70
    {load} mov esi, edi                          # 00443a72
    {load} mov eax, ecx                          # 00443a74
    {load} mov edi, edx                          # 00443a76
    shr ecx, 0x2                                 # 00443a78
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443a7b
    {load} mov ecx, eax                          # 00443a7d
    and ecx, 0x3                                 # 00443a7f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443a82
    mov word ptr [ebp - local_1c], 0x13af        # 00443a84
    mov word ptr [ebp - local_1a], 0x0           # 00443a8a
    mov word ptr [ebp - local_18], 0x0           # 00443a90
    mov word ptr [ebp - local_16], 0x1           # 00443a96
    mov word ptr [ebp - local_8], 0xffff         # 00443a9c
    mov byte ptr [ebp - local_6], 0x0            # 00443aa2
    mov word ptr [ebp - local_5], 0x2            # 00443aa6
    mov dword ptr [ebp - local_14], 0x0          # 00443aac
    mov dword ptr [ebp - local_10], 0x0          # 00443ab3
    mov dword ptr [ebp - local_c], 0x1           # 00443aba
    lea ecx, [ebp - local_1d4]                   # 00443ac1
    push ecx                                     # 00443ac7
    mov ecx, 0x6177e8                            # 00443ac8
    call FUN_0041fa11                            # 00443acd
L_00443ad2:
    # block 0x00443ad2: entered by jne at 0x00443a33; jne at 0x00443a40, 5 instruction(s), ends with ret
    pop edi                                      # 00443ad2
    pop esi                                      # 00443ad3
    {load} mov esp, ebp                          # 00443ad4
    pop ebp                                      # 00443ad6
    ret                                          # 00443ad7

