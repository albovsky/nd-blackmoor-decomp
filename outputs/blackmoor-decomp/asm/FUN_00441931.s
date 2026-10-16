# FUN_00441931
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00441931
# extent:       0x00441931-0x00441d74 (1091 code bytes)
# span:         0x00441931-0x00441d74 (code 1091, tables 0, padding 0)
# sha256:       dc2698928b27dca711040dabe3a436c761d3efcef3c9430d4612fd352b57b8d2
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00441931
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 256 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00441931 - 0x401000
.globl FUN_00441931
FUN_00441931:
    # block 0x00441931: entry, 7 instruction(s), ends with jne to 0x004419ef (forward)
    push ebp                                     # 00441931
    {load} mov ebp, esp                          # 00441932
    sub esp, 0x1d4                               # 00441934
    push esi                                     # 0044193a
    push edi                                     # 0044193b
    cmp dword ptr [0x586f59], 0x1                # 0044193c
    jne.d32 L_004419ef                           # 00441943
    # block 0x00441949: entered by fall-through of jne at 0x00441943, 2 instruction(s), ends with jne to 0x004419ef (forward)
    cmp dword ptr [0x586f55], 0x0                # 00441949
    jne.d32 L_004419ef                           # 00441950
    # block 0x00441956: entered by fall-through of jne at 0x00441950, 2 instruction(s), ends with jne to 0x004419ef (forward)
    cmp dword ptr [0x586f69], 0x0                # 00441956
    jne.d32 L_004419ef                           # 0044195d
    # block 0x00441963: entered by fall-through of jne at 0x0044195d, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004419ef
    push 0x547c58                                # 00441963
    push 0x63a6d4                                # 00441968
    lea eax, [ebp - local_1ce]                   # 0044196d
    push eax                                     # 00441973
    call FUN_0043f210                            # 00441974
    add esp, 0xc                                 # 00441979
    mov edi, 0x547c60                            # 0044197c
    lea edx, [ebp - local_3e]                    # 00441981
    or ecx, -0x1                                 # 00441984
    {load} xor eax, eax                          # 00441987
    repne scasb al, byte ptr es:[edi]            # 00441989
    not ecx                                      # 0044198b
    {load} sub edi, ecx                          # 0044198d
    {load} mov esi, edi                          # 0044198f
    {load} mov eax, ecx                          # 00441991
    {load} mov edi, edx                          # 00441993
    shr ecx, 0x2                                 # 00441995
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441998
    {load} mov ecx, eax                          # 0044199a
    and ecx, 0x3                                 # 0044199c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044199f
    mov word ptr [ebp - local_1c], 0x47e         # 004419a1
    mov word ptr [ebp - local_1a], 0x0           # 004419a7
    mov word ptr [ebp - local_18], 0x0           # 004419ad
    mov word ptr [ebp - local_16], 0x1           # 004419b3
    mov word ptr [ebp - local_8], 0xffff         # 004419b9
    mov byte ptr [ebp - local_6], 0x0            # 004419bf
    mov word ptr [ebp - local_5], 0x2            # 004419c3
    mov dword ptr [ebp - local_14], 0x0          # 004419c9
    mov dword ptr [ebp - local_10], 0x0          # 004419d0
    mov dword ptr [ebp - local_c], 0x1           # 004419d7
    lea ecx, [ebp - local_1d4]                   # 004419de
    push ecx                                     # 004419e4
    mov ecx, 0x6177e8                            # 004419e5
    call FUN_0041fa11                            # 004419ea
L_004419ef:
    # block 0x004419ef: entered by jne at 0x00441943; jne at 0x00441950; jne at 0x0044195d, 2 instruction(s), ends with jne to 0x00441aaf (forward)
    cmp dword ptr [0x5873e9], 0x1                # 004419ef
    jne.d32 L_00441aaf                           # 004419f6
    # block 0x004419fc: entered by fall-through of jne at 0x004419f6, 2 instruction(s), ends with jne to 0x00441aaf (forward)
    cmp dword ptr [0x586f55], 0x0                # 004419fc
    jne.d32 L_00441aaf                           # 00441a03
    # block 0x00441a09: entered by fall-through of jne at 0x00441a03, 2 instruction(s), ends with jne to 0x00441aaf (forward)
    cmp dword ptr [0x586f75], 0x0                # 00441a09
    jne.d32 L_00441aaf                           # 00441a10
    # block 0x00441a16: entered by fall-through of jne at 0x00441a10, 2 instruction(s), ends with jne to 0x00441aaf (forward)
    cmp dword ptr [0x586f6d], 0x0                # 00441a16
    jne.d32 L_00441aaf                           # 00441a1d
    # block 0x00441a23: entered by fall-through of jne at 0x00441a1d, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441aaf
    push 0x547c68                                # 00441a23
    push 0x63a6d8                                # 00441a28
    lea edx, [ebp - local_1ce]                   # 00441a2d
    push edx                                     # 00441a33
    call FUN_0043f210                            # 00441a34
    add esp, 0xc                                 # 00441a39
    mov edi, 0x547c70                            # 00441a3c
    lea edx, [ebp - local_3e]                    # 00441a41
    or ecx, -0x1                                 # 00441a44
    {load} xor eax, eax                          # 00441a47
    repne scasb al, byte ptr es:[edi]            # 00441a49
    not ecx                                      # 00441a4b
    {load} sub edi, ecx                          # 00441a4d
    {load} mov esi, edi                          # 00441a4f
    {load} mov eax, ecx                          # 00441a51
    {load} mov edi, edx                          # 00441a53
    shr ecx, 0x2                                 # 00441a55
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441a58
    {load} mov ecx, eax                          # 00441a5a
    and ecx, 0x3                                 # 00441a5c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441a5f
    mov word ptr [ebp - local_1c], 0x47f         # 00441a61
    mov word ptr [ebp - local_1a], 0x0           # 00441a67
    mov word ptr [ebp - local_18], 0x0           # 00441a6d
    mov word ptr [ebp - local_16], 0x1           # 00441a73
    mov word ptr [ebp - local_8], 0xffff         # 00441a79
    mov byte ptr [ebp - local_6], 0x0            # 00441a7f
    mov word ptr [ebp - local_5], 0x2            # 00441a83
    mov dword ptr [ebp - local_14], 0x0          # 00441a89
    mov dword ptr [ebp - local_10], 0x0          # 00441a90
    mov dword ptr [ebp - local_c], 0x1           # 00441a97
    lea ecx, [ebp - local_1d4]                   # 00441a9e
    push ecx                                     # 00441aa4
    mov ecx, 0x6177e8                            # 00441aa5
    call FUN_0041fa11                            # 00441aaa
L_00441aaf:
    # block 0x00441aaf: entered by jne at 0x004419f6; jne at 0x00441a03; jne at 0x00441a10; jne at 0x00441a1d, 2 instruction(s), ends with jne to 0x00441b62 (forward)
    cmp dword ptr [0x58707d], 0x1                # 00441aaf
    jne.d32 L_00441b62                           # 00441ab6
    # block 0x00441abc: entered by fall-through of jne at 0x00441ab6, 2 instruction(s), ends with jne to 0x00441b62 (forward)
    cmp dword ptr [0x586f55], 0x0                # 00441abc
    jne.d32 L_00441b62                           # 00441ac3
    # block 0x00441ac9: entered by fall-through of jne at 0x00441ac3, 2 instruction(s), ends with jne to 0x00441b62 (forward)
    cmp dword ptr [0x586f65], 0x0                # 00441ac9
    jne.d32 L_00441b62                           # 00441ad0
    # block 0x00441ad6: entered by fall-through of jne at 0x00441ad0, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441b62
    push 0x547c78                                # 00441ad6
    push 0x63a6dc                                # 00441adb
    lea edx, [ebp - local_1ce]                   # 00441ae0
    push edx                                     # 00441ae6
    call FUN_0043f210                            # 00441ae7
    add esp, 0xc                                 # 00441aec
    mov edi, 0x547c80                            # 00441aef
    lea edx, [ebp - local_3e]                    # 00441af4
    or ecx, -0x1                                 # 00441af7
    {load} xor eax, eax                          # 00441afa
    repne scasb al, byte ptr es:[edi]            # 00441afc
    not ecx                                      # 00441afe
    {load} sub edi, ecx                          # 00441b00
    {load} mov esi, edi                          # 00441b02
    {load} mov eax, ecx                          # 00441b04
    {load} mov edi, edx                          # 00441b06
    shr ecx, 0x2                                 # 00441b08
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441b0b
    {load} mov ecx, eax                          # 00441b0d
    and ecx, 0x3                                 # 00441b0f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441b12
    mov word ptr [ebp - local_1c], 0x480         # 00441b14
    mov word ptr [ebp - local_1a], 0x0           # 00441b1a
    mov word ptr [ebp - local_18], 0x0           # 00441b20
    mov word ptr [ebp - local_16], 0x1           # 00441b26
    mov word ptr [ebp - local_8], 0xffff         # 00441b2c
    mov byte ptr [ebp - local_6], 0x0            # 00441b32
    mov word ptr [ebp - local_5], 0x2            # 00441b36
    mov dword ptr [ebp - local_14], 0x0          # 00441b3c
    mov dword ptr [ebp - local_10], 0x0          # 00441b43
    mov dword ptr [ebp - local_c], 0x1           # 00441b4a
    lea ecx, [ebp - local_1d4]                   # 00441b51
    push ecx                                     # 00441b57
    mov ecx, 0x6177e8                            # 00441b58
    call FUN_0041fa11                            # 00441b5d
L_00441b62:
    # block 0x00441b62: entered by jne at 0x00441ab6; jne at 0x00441ac3; jne at 0x00441ad0, 2 instruction(s), ends with jne to 0x00441c15 (forward)
    cmp dword ptr [0x587661], 0x1                # 00441b62
    jne.d32 L_00441c15                           # 00441b69
    # block 0x00441b6f: entered by fall-through of jne at 0x00441b69, 2 instruction(s), ends with jne to 0x00441c15 (forward)
    cmp dword ptr [0x586f55], 0x0                # 00441b6f
    jne.d32 L_00441c15                           # 00441b76
    # block 0x00441b7c: entered by fall-through of jne at 0x00441b76, 2 instruction(s), ends with jne to 0x00441c15 (forward)
    cmp dword ptr [0x586f5d], 0x0                # 00441b7c
    jne.d32 L_00441c15                           # 00441b83
    # block 0x00441b89: entered by fall-through of jne at 0x00441b83, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441c15
    push 0x547c88                                # 00441b89
    push 0x63a6e0                                # 00441b8e
    lea edx, [ebp - local_1ce]                   # 00441b93
    push edx                                     # 00441b99
    call FUN_0043f210                            # 00441b9a
    add esp, 0xc                                 # 00441b9f
    mov edi, 0x547c90                            # 00441ba2
    lea edx, [ebp - local_3e]                    # 00441ba7
    or ecx, -0x1                                 # 00441baa
    {load} xor eax, eax                          # 00441bad
    repne scasb al, byte ptr es:[edi]            # 00441baf
    not ecx                                      # 00441bb1
    {load} sub edi, ecx                          # 00441bb3
    {load} mov esi, edi                          # 00441bb5
    {load} mov eax, ecx                          # 00441bb7
    {load} mov edi, edx                          # 00441bb9
    shr ecx, 0x2                                 # 00441bbb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441bbe
    {load} mov ecx, eax                          # 00441bc0
    and ecx, 0x3                                 # 00441bc2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441bc5
    mov word ptr [ebp - local_1c], 0x485         # 00441bc7
    mov word ptr [ebp - local_1a], 0x0           # 00441bcd
    mov word ptr [ebp - local_18], 0x0           # 00441bd3
    mov word ptr [ebp - local_16], 0x1           # 00441bd9
    mov word ptr [ebp - local_8], 0xffff         # 00441bdf
    mov byte ptr [ebp - local_6], 0x0            # 00441be5
    mov word ptr [ebp - local_5], 0x2            # 00441be9
    mov dword ptr [ebp - local_14], 0x0          # 00441bef
    mov dword ptr [ebp - local_10], 0x0          # 00441bf6
    mov dword ptr [ebp - local_c], 0x1           # 00441bfd
    lea ecx, [ebp - local_1d4]                   # 00441c04
    push ecx                                     # 00441c0a
    mov ecx, 0x6177e8                            # 00441c0b
    call FUN_0041fa11                            # 00441c10
L_00441c15:
    # block 0x00441c15: entered by jne at 0x00441b69; jne at 0x00441b76; jne at 0x00441b83, 2 instruction(s), ends with jne to 0x00441cbb (forward)
    cmp dword ptr [0x587561], 0x1                # 00441c15
    jne.d32 L_00441cbb                           # 00441c1c
    # block 0x00441c22: entered by fall-through of jne at 0x00441c1c, 2 instruction(s), ends with jne to 0x00441cbb (forward)
    cmp dword ptr [0x586f55], 0x0                # 00441c22
    jne.d32 L_00441cbb                           # 00441c29
    # block 0x00441c2f: entered by fall-through of jne at 0x00441c29, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441cbb
    push 0x547c98                                # 00441c2f
    push 0x63a6e4                                # 00441c34
    lea edx, [ebp - local_1ce]                   # 00441c39
    push edx                                     # 00441c3f
    call FUN_0043f210                            # 00441c40
    add esp, 0xc                                 # 00441c45
    mov edi, 0x547ca0                            # 00441c48
    lea edx, [ebp - local_3e]                    # 00441c4d
    or ecx, -0x1                                 # 00441c50
    {load} xor eax, eax                          # 00441c53
    repne scasb al, byte ptr es:[edi]            # 00441c55
    not ecx                                      # 00441c57
    {load} sub edi, ecx                          # 00441c59
    {load} mov esi, edi                          # 00441c5b
    {load} mov eax, ecx                          # 00441c5d
    {load} mov edi, edx                          # 00441c5f
    shr ecx, 0x2                                 # 00441c61
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441c64
    {load} mov ecx, eax                          # 00441c66
    and ecx, 0x3                                 # 00441c68
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441c6b
    mov word ptr [ebp - local_1c], 0x487         # 00441c6d
    mov word ptr [ebp - local_1a], 0x0           # 00441c73
    mov word ptr [ebp - local_18], 0x0           # 00441c79
    mov word ptr [ebp - local_16], 0x1           # 00441c7f
    mov word ptr [ebp - local_8], 0xffff         # 00441c85
    mov byte ptr [ebp - local_6], 0x0            # 00441c8b
    mov word ptr [ebp - local_5], 0x2            # 00441c8f
    mov dword ptr [ebp - local_14], 0x0          # 00441c95
    mov dword ptr [ebp - local_10], 0x0          # 00441c9c
    mov dword ptr [ebp - local_c], 0x1           # 00441ca3
    lea ecx, [ebp - local_1d4]                   # 00441caa
    push ecx                                     # 00441cb0
    mov ecx, 0x6177e8                            # 00441cb1
    call FUN_0041fa11                            # 00441cb6
L_00441cbb:
    # block 0x00441cbb: entered by jne at 0x00441c1c; jne at 0x00441c29, 2 instruction(s), ends with jne to 0x00441d6e (forward)
    cmp dword ptr [0x583c0d], 0x1                # 00441cbb
    jne.d32 L_00441d6e                           # 00441cc2
    # block 0x00441cc8: entered by fall-through of jne at 0x00441cc2, 2 instruction(s), ends with jne to 0x00441d6e (forward)
    cmp dword ptr [0x586f55], 0x0                # 00441cc8
    jne.d32 L_00441d6e                           # 00441ccf
    # block 0x00441cd5: entered by fall-through of jne at 0x00441ccf, 2 instruction(s), ends with jne to 0x00441d6e (forward)
    cmp dword ptr [0x586f71], 0x0                # 00441cd5
    jne.d32 L_00441d6e                           # 00441cdc
    # block 0x00441ce2: entered by fall-through of jne at 0x00441cdc, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441d6e
    push 0x547ca8                                # 00441ce2
    push 0x63a6e8                                # 00441ce7
    lea edx, [ebp - local_1ce]                   # 00441cec
    push edx                                     # 00441cf2
    call FUN_0043f210                            # 00441cf3
    add esp, 0xc                                 # 00441cf8
    mov edi, 0x547cb0                            # 00441cfb
    lea edx, [ebp - local_3e]                    # 00441d00
    or ecx, -0x1                                 # 00441d03
    {load} xor eax, eax                          # 00441d06
    repne scasb al, byte ptr es:[edi]            # 00441d08
    not ecx                                      # 00441d0a
    {load} sub edi, ecx                          # 00441d0c
    {load} mov esi, edi                          # 00441d0e
    {load} mov eax, ecx                          # 00441d10
    {load} mov edi, edx                          # 00441d12
    shr ecx, 0x2                                 # 00441d14
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00441d17
    {load} mov ecx, eax                          # 00441d19
    and ecx, 0x3                                 # 00441d1b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441d1e
    mov word ptr [ebp - local_1c], 0x48e         # 00441d20
    mov word ptr [ebp - local_1a], 0x0           # 00441d26
    mov word ptr [ebp - local_18], 0x0           # 00441d2c
    mov word ptr [ebp - local_16], 0x1           # 00441d32
    mov word ptr [ebp - local_8], 0xffff         # 00441d38
    mov byte ptr [ebp - local_6], 0x0            # 00441d3e
    mov word ptr [ebp - local_5], 0x2            # 00441d42
    mov dword ptr [ebp - local_14], 0x0          # 00441d48
    mov dword ptr [ebp - local_10], 0x0          # 00441d4f
    mov dword ptr [ebp - local_c], 0x1           # 00441d56
    lea ecx, [ebp - local_1d4]                   # 00441d5d
    push ecx                                     # 00441d63
    mov ecx, 0x6177e8                            # 00441d64
    call FUN_0041fa11                            # 00441d69
L_00441d6e:
    # block 0x00441d6e: entered by jne at 0x00441cc2; jne at 0x00441ccf; jne at 0x00441cdc, 5 instruction(s), ends with ret
    pop edi                                      # 00441d6e
    pop esi                                      # 00441d6f
    {load} mov esp, ebp                          # 00441d70
    pop ebp                                      # 00441d72
    ret                                          # 00441d73

