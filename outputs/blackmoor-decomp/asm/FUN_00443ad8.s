# FUN_00443ad8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00443ad8
# extent:       0x00443ad8-0x00443ecd (1013 code bytes)
# span:         0x00443ad8-0x00443ecd (code 1013, tables 0, padding 0)
# sha256:       003d1c006f2bce0f6cb419255632b51a43106ad64a1cb6242be7d16c45a5d52a
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00443ad8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bf4d_lifted (function ledger class candidate_port; also m443ad8_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 244 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00443ad8 - 0x401000
.globl FUN_00443ad8
FUN_00443ad8:
    # block 0x00443ad8: entry, 7 instruction(s), ends with jne to 0x00443b89 (forward)
    push ebp                                     # 00443ad8
    {load} mov ebp, esp                          # 00443ad9
    sub esp, 0x1d4                               # 00443adb
    push esi                                     # 00443ae1
    push edi                                     # 00443ae2
    cmp dword ptr [0x586e21], 0x0                # 00443ae3
    jne.d32 L_00443b89                           # 00443aea
    # block 0x00443af0: entered by fall-through of jne at 0x00443aea, 2 instruction(s), ends with jne to 0x00443b89 (forward)
    cmp dword ptr [0x587129], 0x0                # 00443af0
    jne.d32 L_00443b89                           # 00443af7
    # block 0x00443afd: entered by fall-through of jne at 0x00443af7, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443b89
    push 0x547f78                                # 00443afd
    push 0x63a79c                                # 00443b02
    lea eax, [ebp - local_1ce]                   # 00443b07
    push eax                                     # 00443b0d
    call FUN_0043f210                            # 00443b0e
    add esp, 0xc                                 # 00443b13
    mov edi, 0x547f80                            # 00443b16
    lea edx, [ebp - local_3e]                    # 00443b1b
    or ecx, -0x1                                 # 00443b1e
    {load} xor eax, eax                          # 00443b21
    repne scasb al, byte ptr es:[edi]            # 00443b23
    not ecx                                      # 00443b25
    {load} sub edi, ecx                          # 00443b27
    {load} mov esi, edi                          # 00443b29
    {load} mov eax, ecx                          # 00443b2b
    {load} mov edi, edx                          # 00443b2d
    shr ecx, 0x2                                 # 00443b2f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443b32
    {load} mov ecx, eax                          # 00443b34
    and ecx, 0x3                                 # 00443b36
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443b39
    mov word ptr [ebp - local_1c], 0x672         # 00443b3b
    mov word ptr [ebp - local_1a], 0x0           # 00443b41
    mov word ptr [ebp - local_18], 0x0           # 00443b47
    mov word ptr [ebp - local_16], 0x1           # 00443b4d
    mov word ptr [ebp - local_8], 0xffff         # 00443b53
    mov byte ptr [ebp - local_6], 0x0            # 00443b59
    mov word ptr [ebp - local_5], 0x2            # 00443b5d
    mov dword ptr [ebp - local_14], 0x0          # 00443b63
    mov dword ptr [ebp - local_10], 0x0          # 00443b6a
    mov dword ptr [ebp - local_c], 0x1           # 00443b71
    lea ecx, [ebp - local_1d4]                   # 00443b78
    push ecx                                     # 00443b7e
    mov ecx, 0x6177e8                            # 00443b7f
    call FUN_0041fa11                            # 00443b84
L_00443b89:
    # block 0x00443b89: entered by jne at 0x00443aea; jne at 0x00443af7, 2 instruction(s), ends with jne to 0x00443c3c (forward)
    cmp dword ptr [0x586f69], 0x1                # 00443b89
    jne.d32 L_00443c3c                           # 00443b90
    # block 0x00443b96: entered by fall-through of jne at 0x00443b90, 2 instruction(s), ends with jne to 0x00443c3c (forward)
    cmp dword ptr [0x587559], 0x0                # 00443b96
    jne.d32 L_00443c3c                           # 00443b9d
    # block 0x00443ba3: entered by fall-through of jne at 0x00443b9d, 2 instruction(s), ends with jne to 0x00443c3c (forward)
    cmp dword ptr [0x587125], 0x0                # 00443ba3
    jne.d32 L_00443c3c                           # 00443baa
    # block 0x00443bb0: entered by fall-through of jne at 0x00443baa, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443c3c
    push 0x547f88                                # 00443bb0
    push 0x63a7a0                                # 00443bb5
    lea edx, [ebp - local_1ce]                   # 00443bba
    push edx                                     # 00443bc0
    call FUN_0043f210                            # 00443bc1
    add esp, 0xc                                 # 00443bc6
    mov edi, 0x547f90                            # 00443bc9
    lea edx, [ebp - local_3e]                    # 00443bce
    or ecx, -0x1                                 # 00443bd1
    {load} xor eax, eax                          # 00443bd4
    repne scasb al, byte ptr es:[edi]            # 00443bd6
    not ecx                                      # 00443bd8
    {load} sub edi, ecx                          # 00443bda
    {load} mov esi, edi                          # 00443bdc
    {load} mov eax, ecx                          # 00443bde
    {load} mov edi, edx                          # 00443be0
    shr ecx, 0x2                                 # 00443be2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443be5
    {load} mov ecx, eax                          # 00443be7
    and ecx, 0x3                                 # 00443be9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443bec
    mov word ptr [ebp - local_1c], 0x675         # 00443bee
    mov word ptr [ebp - local_1a], 0x0           # 00443bf4
    mov word ptr [ebp - local_18], 0x0           # 00443bfa
    mov word ptr [ebp - local_16], 0x1           # 00443c00
    mov word ptr [ebp - local_8], 0xffff         # 00443c06
    mov byte ptr [ebp - local_6], 0x0            # 00443c0c
    mov word ptr [ebp - local_5], 0x2            # 00443c10
    mov dword ptr [ebp - local_14], 0x0          # 00443c16
    mov dword ptr [ebp - local_10], 0x0          # 00443c1d
    mov dword ptr [ebp - local_c], 0x1           # 00443c24
    lea ecx, [ebp - local_1d4]                   # 00443c2b
    push ecx                                     # 00443c31
    mov ecx, 0x6177e8                            # 00443c32
    call FUN_0041fa11                            # 00443c37
L_00443c3c:
    # block 0x00443c3c: entered by jne at 0x00443b90; jne at 0x00443b9d; jne at 0x00443baa, 2 instruction(s), ends with jne to 0x00443cd5 (forward)
    cmp dword ptr [0x587105], 0x0                # 00443c3c
    jne.d32 L_00443cd5                           # 00443c43
    # block 0x00443c49: entered by fall-through of jne at 0x00443c43, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443cd5
    push 0x547f98                                # 00443c49
    push 0x63a7a4                                # 00443c4e
    lea edx, [ebp - local_1ce]                   # 00443c53
    push edx                                     # 00443c59
    call FUN_0043f210                            # 00443c5a
    add esp, 0xc                                 # 00443c5f
    mov edi, 0x547fa0                            # 00443c62
    lea edx, [ebp - local_3e]                    # 00443c67
    or ecx, -0x1                                 # 00443c6a
    {load} xor eax, eax                          # 00443c6d
    repne scasb al, byte ptr es:[edi]            # 00443c6f
    not ecx                                      # 00443c71
    {load} sub edi, ecx                          # 00443c73
    {load} mov esi, edi                          # 00443c75
    {load} mov eax, ecx                          # 00443c77
    {load} mov edi, edx                          # 00443c79
    shr ecx, 0x2                                 # 00443c7b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443c7e
    {load} mov ecx, eax                          # 00443c80
    and ecx, 0x3                                 # 00443c82
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443c85
    mov word ptr [ebp - local_1c], 0x677         # 00443c87
    mov word ptr [ebp - local_1a], 0x0           # 00443c8d
    mov word ptr [ebp - local_18], 0x0           # 00443c93
    mov word ptr [ebp - local_16], 0x1           # 00443c99
    mov word ptr [ebp - local_8], 0xffff         # 00443c9f
    mov byte ptr [ebp - local_6], 0x0            # 00443ca5
    mov word ptr [ebp - local_5], 0x2            # 00443ca9
    mov dword ptr [ebp - local_14], 0x0          # 00443caf
    mov dword ptr [ebp - local_10], 0x0          # 00443cb6
    mov dword ptr [ebp - local_c], 0x1           # 00443cbd
    lea ecx, [ebp - local_1d4]                   # 00443cc4
    push ecx                                     # 00443cca
    mov ecx, 0x6177e8                            # 00443ccb
    call FUN_0041fa11                            # 00443cd0
L_00443cd5:
    # block 0x00443cd5: entered by jne at 0x00443c43, 2 instruction(s), ends with jne to 0x00443d7b (forward)
    cmp dword ptr [0x586b69], 0x1                # 00443cd5
    jne.d32 L_00443d7b                           # 00443cdc
    # block 0x00443ce2: entered by fall-through of jne at 0x00443cdc, 2 instruction(s), ends with jne to 0x00443d7b (forward)
    cmp dword ptr [0x587119], 0x0                # 00443ce2
    jne.d32 L_00443d7b                           # 00443ce9
    # block 0x00443cef: entered by fall-through of jne at 0x00443ce9, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443d7b
    push 0x547fa8                                # 00443cef
    push 0x63a7a8                                # 00443cf4
    lea edx, [ebp - local_1ce]                   # 00443cf9
    push edx                                     # 00443cff
    call FUN_0043f210                            # 00443d00
    add esp, 0xc                                 # 00443d05
    mov edi, 0x547fb0                            # 00443d08
    lea edx, [ebp - local_3e]                    # 00443d0d
    or ecx, -0x1                                 # 00443d10
    {load} xor eax, eax                          # 00443d13
    repne scasb al, byte ptr es:[edi]            # 00443d15
    not ecx                                      # 00443d17
    {load} sub edi, ecx                          # 00443d19
    {load} mov esi, edi                          # 00443d1b
    {load} mov eax, ecx                          # 00443d1d
    {load} mov edi, edx                          # 00443d1f
    shr ecx, 0x2                                 # 00443d21
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443d24
    {load} mov ecx, eax                          # 00443d26
    and ecx, 0x3                                 # 00443d28
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443d2b
    mov word ptr [ebp - local_1c], 0x678         # 00443d2d
    mov word ptr [ebp - local_1a], 0x0           # 00443d33
    mov word ptr [ebp - local_18], 0x0           # 00443d39
    mov word ptr [ebp - local_16], 0x1           # 00443d3f
    mov word ptr [ebp - local_8], 0xffff         # 00443d45
    mov byte ptr [ebp - local_6], 0x0            # 00443d4b
    mov word ptr [ebp - local_5], 0x2            # 00443d4f
    mov dword ptr [ebp - local_14], 0x0          # 00443d55
    mov dword ptr [ebp - local_10], 0x0          # 00443d5c
    mov dword ptr [ebp - local_c], 0x1           # 00443d63
    lea ecx, [ebp - local_1d4]                   # 00443d6a
    push ecx                                     # 00443d70
    mov ecx, 0x6177e8                            # 00443d71
    call FUN_0041fa11                            # 00443d76
L_00443d7b:
    # block 0x00443d7b: entered by jne at 0x00443cdc; jne at 0x00443ce9, 2 instruction(s), ends with jne to 0x00443e21 (forward)
    cmp dword ptr [0x586f55], 0x1                # 00443d7b
    jne.d32 L_00443e21                           # 00443d82
    # block 0x00443d88: entered by fall-through of jne at 0x00443d82, 2 instruction(s), ends with jne to 0x00443e21 (forward)
    cmp dword ptr [0x58712d], 0x0                # 00443d88
    jne.d32 L_00443e21                           # 00443d8f
    # block 0x00443d95: entered by fall-through of jne at 0x00443d8f, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443e21
    push 0x547fb8                                # 00443d95
    push 0x63a7ac                                # 00443d9a
    lea edx, [ebp - local_1ce]                   # 00443d9f
    push edx                                     # 00443da5
    call FUN_0043f210                            # 00443da6
    add esp, 0xc                                 # 00443dab
    mov edi, 0x547fc0                            # 00443dae
    lea edx, [ebp - local_3e]                    # 00443db3
    or ecx, -0x1                                 # 00443db6
    {load} xor eax, eax                          # 00443db9
    repne scasb al, byte ptr es:[edi]            # 00443dbb
    not ecx                                      # 00443dbd
    {load} sub edi, ecx                          # 00443dbf
    {load} mov esi, edi                          # 00443dc1
    {load} mov eax, ecx                          # 00443dc3
    {load} mov edi, edx                          # 00443dc5
    shr ecx, 0x2                                 # 00443dc7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443dca
    {load} mov ecx, eax                          # 00443dcc
    and ecx, 0x3                                 # 00443dce
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443dd1
    mov word ptr [ebp - local_1c], 0x67a         # 00443dd3
    mov word ptr [ebp - local_1a], 0x0           # 00443dd9
    mov word ptr [ebp - local_18], 0x0           # 00443ddf
    mov word ptr [ebp - local_16], 0x1           # 00443de5
    mov word ptr [ebp - local_8], 0xffff         # 00443deb
    mov byte ptr [ebp - local_6], 0x0            # 00443df1
    mov word ptr [ebp - local_5], 0x2            # 00443df5
    mov dword ptr [ebp - local_14], 0x0          # 00443dfb
    mov dword ptr [ebp - local_10], 0x0          # 00443e02
    mov dword ptr [ebp - local_c], 0x1           # 00443e09
    lea ecx, [ebp - local_1d4]                   # 00443e10
    push ecx                                     # 00443e16
    mov ecx, 0x6177e8                            # 00443e17
    call FUN_0041fa11                            # 00443e1c
L_00443e21:
    # block 0x00443e21: entered by jne at 0x00443d82; jne at 0x00443d8f, 2 instruction(s), ends with jne to 0x00443ec7 (forward)
    cmp dword ptr [0x587779], 0x1                # 00443e21
    jne.d32 L_00443ec7                           # 00443e28
    # block 0x00443e2e: entered by fall-through of jne at 0x00443e28, 2 instruction(s), ends with jne to 0x00443ec7 (forward)
    cmp dword ptr [0x587115], 0x0                # 00443e2e
    jne.d32 L_00443ec7                           # 00443e35
    # block 0x00443e3b: entered by fall-through of jne at 0x00443e35, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443ec7
    push 0x547fc8                                # 00443e3b
    push 0x63a7b0                                # 00443e40
    lea edx, [ebp - local_1ce]                   # 00443e45
    push edx                                     # 00443e4b
    call FUN_0043f210                            # 00443e4c
    add esp, 0xc                                 # 00443e51
    mov edi, 0x547fd0                            # 00443e54
    lea edx, [ebp - local_3e]                    # 00443e59
    or ecx, -0x1                                 # 00443e5c
    {load} xor eax, eax                          # 00443e5f
    repne scasb al, byte ptr es:[edi]            # 00443e61
    not ecx                                      # 00443e63
    {load} sub edi, ecx                          # 00443e65
    {load} mov esi, edi                          # 00443e67
    {load} mov eax, ecx                          # 00443e69
    {load} mov edi, edx                          # 00443e6b
    shr ecx, 0x2                                 # 00443e6d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443e70
    {load} mov ecx, eax                          # 00443e72
    and ecx, 0x3                                 # 00443e74
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443e77
    mov word ptr [ebp - local_1c], 0x67e         # 00443e79
    mov word ptr [ebp - local_1a], 0x0           # 00443e7f
    mov word ptr [ebp - local_18], 0x0           # 00443e85
    mov word ptr [ebp - local_16], 0x1           # 00443e8b
    mov word ptr [ebp - local_8], 0xffff         # 00443e91
    mov byte ptr [ebp - local_6], 0x0            # 00443e97
    mov word ptr [ebp - local_5], 0x2            # 00443e9b
    mov dword ptr [ebp - local_14], 0x0          # 00443ea1
    mov dword ptr [ebp - local_10], 0x0          # 00443ea8
    mov dword ptr [ebp - local_c], 0x1           # 00443eaf
    lea ecx, [ebp - local_1d4]                   # 00443eb6
    push ecx                                     # 00443ebc
    mov ecx, 0x6177e8                            # 00443ebd
    call FUN_0041fa11                            # 00443ec2
L_00443ec7:
    # block 0x00443ec7: entered by jne at 0x00443e28; jne at 0x00443e35, 5 instruction(s), ends with ret
    pop edi                                      # 00443ec7
    pop esi                                      # 00443ec8
    {load} mov esp, ebp                          # 00443ec9
    pop ebp                                      # 00443ecb
    ret                                          # 00443ecc

