# FUN_0044499c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044499c
# extent:       0x0044499c-0x0044512a (1934 code bytes)
# span:         0x0044499c-0x0044512a (code 1934, tables 0, padding 0)
# sha256:       9f869a30532045fcf8f543c9af7816a9a266944f3111f68a62e14bd9bab856d8
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044499c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bf4d_lifted (function ledger class candidate_port; also m44499c_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 453 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0044499c - 0x401000
.globl FUN_0044499c
FUN_0044499c:
    # block 0x0044499c: entry, 7 instruction(s), ends with jne to 0x00444a5a (forward)
    push ebp                                     # 0044499c
    {load} mov ebp, esp                          # 0044499d
    sub esp, 0x1d4                               # 0044499f
    push esi                                     # 004449a5
    push edi                                     # 004449a6
    cmp dword ptr [0x58708d], 0x1                # 004449a7
    jne.d32 L_00444a5a                           # 004449ae
    # block 0x004449b4: entered by fall-through of jne at 0x004449ae, 2 instruction(s), ends with jne to 0x00444a5a (forward)
    cmp dword ptr [0x587105], 0x1                # 004449b4
    jne.d32 L_00444a5a                           # 004449bb
    # block 0x004449c1: entered by fall-through of jne at 0x004449bb, 2 instruction(s), ends with jne to 0x00444a5a (forward)
    cmp dword ptr [0x586c4d], 0x0                # 004449c1
    jne.d32 L_00444a5a                           # 004449c8
    # block 0x004449ce: entered by fall-through of jne at 0x004449c8, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444a5a
    push 0x5480c8                                # 004449ce
    push 0x63a7f0                                # 004449d3
    lea eax, [ebp - local_1ce]                   # 004449d8
    push eax                                     # 004449de
    call FUN_0043f210                            # 004449df
    add esp, 0xc                                 # 004449e4
    mov edi, 0x5480d0                            # 004449e7
    lea edx, [ebp - local_3e]                    # 004449ec
    or ecx, -0x1                                 # 004449ef
    {load} xor eax, eax                          # 004449f2
    repne scasb al, byte ptr es:[edi]            # 004449f4
    not ecx                                      # 004449f6
    {load} sub edi, ecx                          # 004449f8
    {load} mov esi, edi                          # 004449fa
    {load} mov eax, ecx                          # 004449fc
    {load} mov edi, edx                          # 004449fe
    shr ecx, 0x2                                 # 00444a00
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444a03
    {load} mov ecx, eax                          # 00444a05
    and ecx, 0x3                                 # 00444a07
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444a0a
    mov word ptr [ebp - local_1c], 0x72e         # 00444a0c
    mov word ptr [ebp - local_1a], 0x0           # 00444a12
    mov word ptr [ebp - local_18], 0x0           # 00444a18
    mov word ptr [ebp - local_16], 0x1           # 00444a1e
    mov word ptr [ebp - local_8], 0xffff         # 00444a24
    mov byte ptr [ebp - local_6], 0x0            # 00444a2a
    mov word ptr [ebp - local_5], 0x2            # 00444a2e
    mov dword ptr [ebp - local_14], 0x0          # 00444a34
    mov dword ptr [ebp - local_10], 0x0          # 00444a3b
    mov dword ptr [ebp - local_c], 0x1           # 00444a42
    lea ecx, [ebp - local_1d4]                   # 00444a49
    push ecx                                     # 00444a4f
    mov ecx, 0x6177e8                            # 00444a50
    call FUN_0041fa11                            # 00444a55
L_00444a5a:
    # block 0x00444a5a: entered by jne at 0x004449ae; jne at 0x004449bb; jne at 0x004449c8, 2 instruction(s), ends with jne to 0x00444b00 (forward)
    cmp dword ptr [0x58707d], 0x1                # 00444a5a
    jne.d32 L_00444b00                           # 00444a61
    # block 0x00444a67: entered by fall-through of jne at 0x00444a61, 2 instruction(s), ends with jne to 0x00444b00 (forward)
    cmp dword ptr [0x586c59], 0x0                # 00444a67
    jne.d32 L_00444b00                           # 00444a6e
    # block 0x00444a74: entered by fall-through of jne at 0x00444a6e, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444b00
    push 0x5480d8                                # 00444a74
    push 0x63a7f4                                # 00444a79
    lea edx, [ebp - local_1ce]                   # 00444a7e
    push edx                                     # 00444a84
    call FUN_0043f210                            # 00444a85
    add esp, 0xc                                 # 00444a8a
    mov edi, 0x5480e0                            # 00444a8d
    lea edx, [ebp - local_3e]                    # 00444a92
    or ecx, -0x1                                 # 00444a95
    {load} xor eax, eax                          # 00444a98
    repne scasb al, byte ptr es:[edi]            # 00444a9a
    not ecx                                      # 00444a9c
    {load} sub edi, ecx                          # 00444a9e
    {load} mov esi, edi                          # 00444aa0
    {load} mov eax, ecx                          # 00444aa2
    {load} mov edi, edx                          # 00444aa4
    shr ecx, 0x2                                 # 00444aa6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444aa9
    {load} mov ecx, eax                          # 00444aab
    and ecx, 0x3                                 # 00444aad
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444ab0
    mov word ptr [ebp - local_1c], 0x733         # 00444ab2
    mov word ptr [ebp - local_1a], 0x0           # 00444ab8
    mov word ptr [ebp - local_18], 0x0           # 00444abe
    mov word ptr [ebp - local_16], 0x1           # 00444ac4
    mov word ptr [ebp - local_8], 0xffff         # 00444aca
    mov byte ptr [ebp - local_6], 0x0            # 00444ad0
    mov word ptr [ebp - local_5], 0x2            # 00444ad4
    mov dword ptr [ebp - local_14], 0x0          # 00444ada
    mov dword ptr [ebp - local_10], 0x0          # 00444ae1
    mov dword ptr [ebp - local_c], 0x1           # 00444ae8
    lea ecx, [ebp - local_1d4]                   # 00444aef
    push ecx                                     # 00444af5
    mov ecx, 0x6177e8                            # 00444af6
    call FUN_0041fa11                            # 00444afb
L_00444b00:
    # block 0x00444b00: entered by jne at 0x00444a61; jne at 0x00444a6e, 2 instruction(s), ends with jne to 0x00444ba6 (forward)
    cmp dword ptr [0x586f51], 0x1                # 00444b00
    jne.d32 L_00444ba6                           # 00444b07
    # block 0x00444b0d: entered by fall-through of jne at 0x00444b07, 2 instruction(s), ends with jne to 0x00444ba6 (forward)
    cmp dword ptr [0x586c5d], 0x0                # 00444b0d
    jne.d32 L_00444ba6                           # 00444b14
    # block 0x00444b1a: entered by fall-through of jne at 0x00444b14, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444ba6
    push 0x5480e8                                # 00444b1a
    push 0x63a7f8                                # 00444b1f
    lea edx, [ebp - local_1ce]                   # 00444b24
    push edx                                     # 00444b2a
    call FUN_0043f210                            # 00444b2b
    add esp, 0xc                                 # 00444b30
    mov edi, 0x5480f0                            # 00444b33
    lea edx, [ebp - local_3e]                    # 00444b38
    or ecx, -0x1                                 # 00444b3b
    {load} xor eax, eax                          # 00444b3e
    repne scasb al, byte ptr es:[edi]            # 00444b40
    not ecx                                      # 00444b42
    {load} sub edi, ecx                          # 00444b44
    {load} mov esi, edi                          # 00444b46
    {load} mov eax, ecx                          # 00444b48
    {load} mov edi, edx                          # 00444b4a
    shr ecx, 0x2                                 # 00444b4c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444b4f
    {load} mov ecx, eax                          # 00444b51
    and ecx, 0x3                                 # 00444b53
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444b56
    mov word ptr [ebp - local_1c], 0x736         # 00444b58
    mov word ptr [ebp - local_1a], 0x0           # 00444b5e
    mov word ptr [ebp - local_18], 0x0           # 00444b64
    mov word ptr [ebp - local_16], 0x1           # 00444b6a
    mov word ptr [ebp - local_8], 0xffff         # 00444b70
    mov byte ptr [ebp - local_6], 0x0            # 00444b76
    mov word ptr [ebp - local_5], 0x2            # 00444b7a
    mov dword ptr [ebp - local_14], 0x0          # 00444b80
    mov dword ptr [ebp - local_10], 0x0          # 00444b87
    mov dword ptr [ebp - local_c], 0x1           # 00444b8e
    lea ecx, [ebp - local_1d4]                   # 00444b95
    push ecx                                     # 00444b9b
    mov ecx, 0x6177e8                            # 00444b9c
    call FUN_0041fa11                            # 00444ba1
L_00444ba6:
    # block 0x00444ba6: entered by jne at 0x00444b07; jne at 0x00444b14, 2 instruction(s), ends with jne to 0x00444c4c (forward)
    cmp dword ptr [0x587855], 0x1                # 00444ba6
    jne.d32 L_00444c4c                           # 00444bad
    # block 0x00444bb3: entered by fall-through of jne at 0x00444bad, 2 instruction(s), ends with jne to 0x00444c4c (forward)
    cmp dword ptr [0x586c55], 0x0                # 00444bb3
    jne.d32 L_00444c4c                           # 00444bba
    # block 0x00444bc0: entered by fall-through of jne at 0x00444bba, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444c4c
    push 0x5480f8                                # 00444bc0
    push 0x63a7fc                                # 00444bc5
    lea edx, [ebp - local_1ce]                   # 00444bca
    push edx                                     # 00444bd0
    call FUN_0043f210                            # 00444bd1
    add esp, 0xc                                 # 00444bd6
    mov edi, 0x548100                            # 00444bd9
    lea edx, [ebp - local_3e]                    # 00444bde
    or ecx, -0x1                                 # 00444be1
    {load} xor eax, eax                          # 00444be4
    repne scasb al, byte ptr es:[edi]            # 00444be6
    not ecx                                      # 00444be8
    {load} sub edi, ecx                          # 00444bea
    {load} mov esi, edi                          # 00444bec
    {load} mov eax, ecx                          # 00444bee
    {load} mov edi, edx                          # 00444bf0
    shr ecx, 0x2                                 # 00444bf2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444bf5
    {load} mov ecx, eax                          # 00444bf7
    and ecx, 0x3                                 # 00444bf9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444bfc
    mov word ptr [ebp - local_1c], 0x73a         # 00444bfe
    mov word ptr [ebp - local_1a], 0x0           # 00444c04
    mov word ptr [ebp - local_18], 0x0           # 00444c0a
    mov word ptr [ebp - local_16], 0x1           # 00444c10
    mov word ptr [ebp - local_8], 0xffff         # 00444c16
    mov byte ptr [ebp - local_6], 0x0            # 00444c1c
    mov word ptr [ebp - local_5], 0x2            # 00444c20
    mov dword ptr [ebp - local_14], 0x0          # 00444c26
    mov dword ptr [ebp - local_10], 0x0          # 00444c2d
    mov dword ptr [ebp - local_c], 0x1           # 00444c34
    lea ecx, [ebp - local_1d4]                   # 00444c3b
    push ecx                                     # 00444c41
    mov ecx, 0x6177e8                            # 00444c42
    call FUN_0041fa11                            # 00444c47
L_00444c4c:
    # block 0x00444c4c: entered by jne at 0x00444bad; jne at 0x00444bba, 2 instruction(s), ends with jne to 0x00444cf2 (forward)
    cmp dword ptr [0x58706d], 0x1                # 00444c4c
    jne.d32 L_00444cf2                           # 00444c53
    # block 0x00444c59: entered by fall-through of jne at 0x00444c53, 2 instruction(s), ends with jne to 0x00444cf2 (forward)
    cmp dword ptr [0x586c51], 0x0                # 00444c59
    jne.d32 L_00444cf2                           # 00444c60
    # block 0x00444c66: entered by fall-through of jne at 0x00444c60, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444cf2
    push 0x548108                                # 00444c66
    push 0x63a800                                # 00444c6b
    lea edx, [ebp - local_1ce]                   # 00444c70
    push edx                                     # 00444c76
    call FUN_0043f210                            # 00444c77
    add esp, 0xc                                 # 00444c7c
    mov edi, 0x548110                            # 00444c7f
    lea edx, [ebp - local_3e]                    # 00444c84
    or ecx, -0x1                                 # 00444c87
    {load} xor eax, eax                          # 00444c8a
    repne scasb al, byte ptr es:[edi]            # 00444c8c
    not ecx                                      # 00444c8e
    {load} sub edi, ecx                          # 00444c90
    {load} mov esi, edi                          # 00444c92
    {load} mov eax, ecx                          # 00444c94
    {load} mov edi, edx                          # 00444c96
    shr ecx, 0x2                                 # 00444c98
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444c9b
    {load} mov ecx, eax                          # 00444c9d
    and ecx, 0x3                                 # 00444c9f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444ca2
    mov word ptr [ebp - local_1c], 0x73d         # 00444ca4
    mov word ptr [ebp - local_1a], 0x0           # 00444caa
    mov word ptr [ebp - local_18], 0x0           # 00444cb0
    mov word ptr [ebp - local_16], 0x1           # 00444cb6
    mov word ptr [ebp - local_8], 0xffff         # 00444cbc
    mov byte ptr [ebp - local_6], 0x0            # 00444cc2
    mov word ptr [ebp - local_5], 0x2            # 00444cc6
    mov dword ptr [ebp - local_14], 0x0          # 00444ccc
    mov dword ptr [ebp - local_10], 0x0          # 00444cd3
    mov dword ptr [ebp - local_c], 0x1           # 00444cda
    lea ecx, [ebp - local_1d4]                   # 00444ce1
    push ecx                                     # 00444ce7
    mov ecx, 0x6177e8                            # 00444ce8
    call FUN_0041fa11                            # 00444ced
L_00444cf2:
    # block 0x00444cf2: entered by jne at 0x00444c53; jne at 0x00444c60, 2 instruction(s), ends with jne to 0x00444d98 (forward)
    cmp dword ptr [0x583c0d], 0x1                # 00444cf2
    jne.d32 L_00444d98                           # 00444cf9
    # block 0x00444cff: entered by fall-through of jne at 0x00444cf9, 2 instruction(s), ends with jne to 0x00444d98 (forward)
    cmp dword ptr [0x586c6d], 0x0                # 00444cff
    jne.d32 L_00444d98                           # 00444d06
    # block 0x00444d0c: entered by fall-through of jne at 0x00444d06, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444d98
    push 0x548118                                # 00444d0c
    push 0x63a804                                # 00444d11
    lea edx, [ebp - local_1ce]                   # 00444d16
    push edx                                     # 00444d1c
    call FUN_0043f210                            # 00444d1d
    add esp, 0xc                                 # 00444d22
    mov edi, 0x548120                            # 00444d25
    lea edx, [ebp - local_3e]                    # 00444d2a
    or ecx, -0x1                                 # 00444d2d
    {load} xor eax, eax                          # 00444d30
    repne scasb al, byte ptr es:[edi]            # 00444d32
    not ecx                                      # 00444d34
    {load} sub edi, ecx                          # 00444d36
    {load} mov esi, edi                          # 00444d38
    {load} mov eax, ecx                          # 00444d3a
    {load} mov edi, edx                          # 00444d3c
    shr ecx, 0x2                                 # 00444d3e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444d41
    {load} mov ecx, eax                          # 00444d43
    and ecx, 0x3                                 # 00444d45
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444d48
    mov word ptr [ebp - local_1c], 0x741         # 00444d4a
    mov word ptr [ebp - local_1a], 0x0           # 00444d50
    mov word ptr [ebp - local_18], 0x0           # 00444d56
    mov word ptr [ebp - local_16], 0x1           # 00444d5c
    mov word ptr [ebp - local_8], 0xffff         # 00444d62
    mov byte ptr [ebp - local_6], 0x0            # 00444d68
    mov word ptr [ebp - local_5], 0x2            # 00444d6c
    mov dword ptr [ebp - local_14], 0x0          # 00444d72
    mov dword ptr [ebp - local_10], 0x0          # 00444d79
    mov dword ptr [ebp - local_c], 0x1           # 00444d80
    lea ecx, [ebp - local_1d4]                   # 00444d87
    push ecx                                     # 00444d8d
    mov ecx, 0x6177e8                            # 00444d8e
    call FUN_0041fa11                            # 00444d93
L_00444d98:
    # block 0x00444d98: entered by jne at 0x00444cf9; jne at 0x00444d06, 2 instruction(s), ends with jne to 0x00444e4b (forward)
    cmp dword ptr [0x586f59], 0x1                # 00444d98
    jne.d32 L_00444e4b                           # 00444d9f
    # block 0x00444da5: entered by fall-through of jne at 0x00444d9f, 2 instruction(s), ends with jne to 0x00444e4b (forward)
    cmp dword ptr [0x587235], 0x1                # 00444da5
    jne.d32 L_00444e4b                           # 00444dac
    # block 0x00444db2: entered by fall-through of jne at 0x00444dac, 2 instruction(s), ends with jne to 0x00444e4b (forward)
    cmp dword ptr [0x586c45], 0x0                # 00444db2
    jne.d32 L_00444e4b                           # 00444db9
    # block 0x00444dbf: entered by fall-through of jne at 0x00444db9, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444e4b
    push 0x548128                                # 00444dbf
    push 0x63a808                                # 00444dc4
    lea edx, [ebp - local_1ce]                   # 00444dc9
    push edx                                     # 00444dcf
    call FUN_0043f210                            # 00444dd0
    add esp, 0xc                                 # 00444dd5
    mov edi, 0x548130                            # 00444dd8
    lea edx, [ebp - local_3e]                    # 00444ddd
    or ecx, -0x1                                 # 00444de0
    {load} xor eax, eax                          # 00444de3
    repne scasb al, byte ptr es:[edi]            # 00444de5
    not ecx                                      # 00444de7
    {load} sub edi, ecx                          # 00444de9
    {load} mov esi, edi                          # 00444deb
    {load} mov eax, ecx                          # 00444ded
    {load} mov edi, edx                          # 00444def
    shr ecx, 0x2                                 # 00444df1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444df4
    {load} mov ecx, eax                          # 00444df6
    and ecx, 0x3                                 # 00444df8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444dfb
    mov word ptr [ebp - local_1c], 0x744         # 00444dfd
    mov word ptr [ebp - local_1a], 0x0           # 00444e03
    mov word ptr [ebp - local_18], 0x0           # 00444e09
    mov word ptr [ebp - local_16], 0x1           # 00444e0f
    mov word ptr [ebp - local_8], 0xffff         # 00444e15
    mov byte ptr [ebp - local_6], 0x0            # 00444e1b
    mov word ptr [ebp - local_5], 0x2            # 00444e1f
    mov dword ptr [ebp - local_14], 0x0          # 00444e25
    mov dword ptr [ebp - local_10], 0x0          # 00444e2c
    mov dword ptr [ebp - local_c], 0x1           # 00444e33
    lea ecx, [ebp - local_1d4]                   # 00444e3a
    push ecx                                     # 00444e40
    mov ecx, 0x6177e8                            # 00444e41
    call FUN_0041fa11                            # 00444e46
L_00444e4b:
    # block 0x00444e4b: entered by jne at 0x00444d9f; jne at 0x00444dac; jne at 0x00444db9, 2 instruction(s), ends with jne to 0x00444efe (forward)
    cmp dword ptr [0x587591], 0x1                # 00444e4b
    jne.d32 L_00444efe                           # 00444e52
    # block 0x00444e58: entered by fall-through of jne at 0x00444e52, 2 instruction(s), ends with jne to 0x00444efe (forward)
    cmp dword ptr [0x58773d], 0x0                # 00444e58
    jne.d32 L_00444efe                           # 00444e5f
    # block 0x00444e65: entered by fall-through of jne at 0x00444e5f, 2 instruction(s), ends with jne to 0x00444efe (forward)
    cmp dword ptr [0x586c49], 0x0                # 00444e65
    jne.d32 L_00444efe                           # 00444e6c
    # block 0x00444e72: entered by fall-through of jne at 0x00444e6c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444efe
    push 0x548138                                # 00444e72
    push 0x63a80c                                # 00444e77
    lea edx, [ebp - local_1ce]                   # 00444e7c
    push edx                                     # 00444e82
    call FUN_0043f210                            # 00444e83
    add esp, 0xc                                 # 00444e88
    mov edi, 0x548140                            # 00444e8b
    lea edx, [ebp - local_3e]                    # 00444e90
    or ecx, -0x1                                 # 00444e93
    {load} xor eax, eax                          # 00444e96
    repne scasb al, byte ptr es:[edi]            # 00444e98
    not ecx                                      # 00444e9a
    {load} sub edi, ecx                          # 00444e9c
    {load} mov esi, edi                          # 00444e9e
    {load} mov eax, ecx                          # 00444ea0
    {load} mov edi, edx                          # 00444ea2
    shr ecx, 0x2                                 # 00444ea4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444ea7
    {load} mov ecx, eax                          # 00444ea9
    and ecx, 0x3                                 # 00444eab
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444eae
    mov word ptr [ebp - local_1c], 0x749         # 00444eb0
    mov word ptr [ebp - local_1a], 0x0           # 00444eb6
    mov word ptr [ebp - local_18], 0x0           # 00444ebc
    mov word ptr [ebp - local_16], 0x1           # 00444ec2
    mov word ptr [ebp - local_8], 0xffff         # 00444ec8
    mov byte ptr [ebp - local_6], 0x0            # 00444ece
    mov word ptr [ebp - local_5], 0x2            # 00444ed2
    mov dword ptr [ebp - local_14], 0x0          # 00444ed8
    mov dword ptr [ebp - local_10], 0x0          # 00444edf
    mov dword ptr [ebp - local_c], 0x1           # 00444ee6
    lea ecx, [ebp - local_1d4]                   # 00444eed
    push ecx                                     # 00444ef3
    mov ecx, 0x6177e8                            # 00444ef4
    call FUN_0041fa11                            # 00444ef9
L_00444efe:
    # block 0x00444efe: entered by jne at 0x00444e52; jne at 0x00444e5f; jne at 0x00444e6c, 2 instruction(s), ends with jne to 0x00444fbe (forward)
    cmp dword ptr [0x583c0d], 0x1                # 00444efe
    jne.d32 L_00444fbe                           # 00444f05
    # block 0x00444f0b: entered by fall-through of jne at 0x00444f05, 2 instruction(s), ends with jne to 0x00444fbe (forward)
    cmp dword ptr [0x586c6d], 0x1                # 00444f0b
    jne.d32 L_00444fbe                           # 00444f12
    # block 0x00444f18: entered by fall-through of jne at 0x00444f12, 2 instruction(s), ends with jne to 0x00444fbe (forward)
    cmp dword ptr [0x586e09], 0x1                # 00444f18
    jne.d32 L_00444fbe                           # 00444f1f
    # block 0x00444f25: entered by fall-through of jne at 0x00444f1f, 2 instruction(s), ends with jne to 0x00444fbe (forward)
    cmp dword ptr [0x586c61], 0x0                # 00444f25
    jne.d32 L_00444fbe                           # 00444f2c
    # block 0x00444f32: entered by fall-through of jne at 0x00444f2c, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444fbe
    push 0x548148                                # 00444f32
    push 0x63a810                                # 00444f37
    lea edx, [ebp - local_1ce]                   # 00444f3c
    push edx                                     # 00444f42
    call FUN_0043f210                            # 00444f43
    add esp, 0xc                                 # 00444f48
    mov edi, 0x548150                            # 00444f4b
    lea edx, [ebp - local_3e]                    # 00444f50
    or ecx, -0x1                                 # 00444f53
    {load} xor eax, eax                          # 00444f56
    repne scasb al, byte ptr es:[edi]            # 00444f58
    not ecx                                      # 00444f5a
    {load} sub edi, ecx                          # 00444f5c
    {load} mov esi, edi                          # 00444f5e
    {load} mov eax, ecx                          # 00444f60
    {load} mov edi, edx                          # 00444f62
    shr ecx, 0x2                                 # 00444f64
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444f67
    {load} mov ecx, eax                          # 00444f69
    and ecx, 0x3                                 # 00444f6b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444f6e
    mov word ptr [ebp - local_1c], 0x74b         # 00444f70
    mov word ptr [ebp - local_1a], 0x0           # 00444f76
    mov word ptr [ebp - local_18], 0x0           # 00444f7c
    mov word ptr [ebp - local_16], 0x1           # 00444f82
    mov word ptr [ebp - local_8], 0xffff         # 00444f88
    mov byte ptr [ebp - local_6], 0x0            # 00444f8e
    mov word ptr [ebp - local_5], 0x2            # 00444f92
    mov dword ptr [ebp - local_14], 0x0          # 00444f98
    mov dword ptr [ebp - local_10], 0x0          # 00444f9f
    mov dword ptr [ebp - local_c], 0x1           # 00444fa6
    lea ecx, [ebp - local_1d4]                   # 00444fad
    push ecx                                     # 00444fb3
    mov ecx, 0x6177e8                            # 00444fb4
    call FUN_0041fa11                            # 00444fb9
L_00444fbe:
    # block 0x00444fbe: entered by jne at 0x00444f05; jne at 0x00444f12; jne at 0x00444f1f; jne at 0x00444f2c, 2 instruction(s), ends with jne to 0x0044507e (forward)
    cmp dword ptr [0x583c0d], 0x1                # 00444fbe
    jne.d32 L_0044507e                           # 00444fc5
    # block 0x00444fcb: entered by fall-through of jne at 0x00444fc5, 2 instruction(s), ends with jne to 0x0044507e (forward)
    cmp dword ptr [0x586c6d], 0x1                # 00444fcb
    jne.d32 L_0044507e                           # 00444fd2
    # block 0x00444fd8: entered by fall-through of jne at 0x00444fd2, 2 instruction(s), ends with jne to 0x0044507e (forward)
    cmp dword ptr [0x586e09], 0x0                # 00444fd8
    jne.d32 L_0044507e                           # 00444fdf
    # block 0x00444fe5: entered by fall-through of jne at 0x00444fdf, 2 instruction(s), ends with jne to 0x0044507e (forward)
    cmp dword ptr [0x586c61], 0x0                # 00444fe5
    jne.d32 L_0044507e                           # 00444fec
    # block 0x00444ff2: entered by fall-through of jne at 0x00444fec, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044507e
    push 0x548158                                # 00444ff2
    push 0x63a814                                # 00444ff7
    lea edx, [ebp - local_1ce]                   # 00444ffc
    push edx                                     # 00445002
    call FUN_0043f210                            # 00445003
    add esp, 0xc                                 # 00445008
    mov edi, 0x548160                            # 0044500b
    lea edx, [ebp - local_3e]                    # 00445010
    or ecx, -0x1                                 # 00445013
    {load} xor eax, eax                          # 00445016
    repne scasb al, byte ptr es:[edi]            # 00445018
    not ecx                                      # 0044501a
    {load} sub edi, ecx                          # 0044501c
    {load} mov esi, edi                          # 0044501e
    {load} mov eax, ecx                          # 00445020
    {load} mov edi, edx                          # 00445022
    shr ecx, 0x2                                 # 00445024
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445027
    {load} mov ecx, eax                          # 00445029
    and ecx, 0x3                                 # 0044502b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044502e
    mov word ptr [ebp - local_1c], 0x74c         # 00445030
    mov word ptr [ebp - local_1a], 0x0           # 00445036
    mov word ptr [ebp - local_18], 0x0           # 0044503c
    mov word ptr [ebp - local_16], 0x1           # 00445042
    mov word ptr [ebp - local_8], 0xffff         # 00445048
    mov byte ptr [ebp - local_6], 0x0            # 0044504e
    mov word ptr [ebp - local_5], 0x2            # 00445052
    mov dword ptr [ebp - local_14], 0x0          # 00445058
    mov dword ptr [ebp - local_10], 0x0          # 0044505f
    mov dword ptr [ebp - local_c], 0x1           # 00445066
    lea ecx, [ebp - local_1d4]                   # 0044506d
    push ecx                                     # 00445073
    mov ecx, 0x6177e8                            # 00445074
    call FUN_0041fa11                            # 00445079
L_0044507e:
    # block 0x0044507e: entered by jne at 0x00444fc5; jne at 0x00444fd2; jne at 0x00444fdf; jne at 0x00444fec, 2 instruction(s), ends with jne to 0x00445124 (forward)
    cmp dword ptr [0x587655], 0x1                # 0044507e
    jne.d32 L_00445124                           # 00445085
    # block 0x0044508b: entered by fall-through of jne at 0x00445085, 2 instruction(s), ends with jne to 0x00445124 (forward)
    cmp dword ptr [0x586c69], 0x0                # 0044508b
    jne.d32 L_00445124                           # 00445092
    # block 0x00445098: entered by fall-through of jne at 0x00445092, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00445124
    push 0x548168                                # 00445098
    push 0x63a818                                # 0044509d
    lea edx, [ebp - local_1ce]                   # 004450a2
    push edx                                     # 004450a8
    call FUN_0043f210                            # 004450a9
    add esp, 0xc                                 # 004450ae
    mov edi, 0x548170                            # 004450b1
    lea edx, [ebp - local_3e]                    # 004450b6
    or ecx, -0x1                                 # 004450b9
    {load} xor eax, eax                          # 004450bc
    repne scasb al, byte ptr es:[edi]            # 004450be
    not ecx                                      # 004450c0
    {load} sub edi, ecx                          # 004450c2
    {load} mov esi, edi                          # 004450c4
    {load} mov eax, ecx                          # 004450c6
    {load} mov edi, edx                          # 004450c8
    shr ecx, 0x2                                 # 004450ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004450cd
    {load} mov ecx, eax                          # 004450cf
    and ecx, 0x3                                 # 004450d1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004450d4
    mov word ptr [ebp - local_1c], 0x74f         # 004450d6
    mov word ptr [ebp - local_1a], 0x0           # 004450dc
    mov word ptr [ebp - local_18], 0x0           # 004450e2
    mov word ptr [ebp - local_16], 0x1           # 004450e8
    mov word ptr [ebp - local_8], 0xffff         # 004450ee
    mov byte ptr [ebp - local_6], 0x0            # 004450f4
    mov word ptr [ebp - local_5], 0x2            # 004450f8
    mov dword ptr [ebp - local_14], 0x0          # 004450fe
    mov dword ptr [ebp - local_10], 0x0          # 00445105
    mov dword ptr [ebp - local_c], 0x1           # 0044510c
    lea ecx, [ebp - local_1d4]                   # 00445113
    push ecx                                     # 00445119
    mov ecx, 0x6177e8                            # 0044511a
    call FUN_0041fa11                            # 0044511f
L_00445124:
    # block 0x00445124: entered by jne at 0x00445085; jne at 0x00445092, 5 instruction(s), ends with ret
    pop edi                                      # 00445124
    pop esi                                      # 00445125
    {load} mov esp, ebp                          # 00445126
    pop ebp                                      # 00445128
    ret                                          # 00445129

