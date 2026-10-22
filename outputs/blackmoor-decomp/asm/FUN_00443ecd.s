# FUN_00443ecd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00443ecd
# extent:       0x00443ecd-0x0044423f (882 code bytes)
# span:         0x00443ecd-0x0044423f (code 882, tables 0, padding 0)
# sha256:       29032a5e2c6978afed7763440f9e77e214f5fbd5fc0669b29bed76ff4613b5ba
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00443ecd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bf4d_lifted (function ledger class candidate_port; also m443ecd_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 211 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00443ecd - 0x401000
.globl FUN_00443ecd
FUN_00443ecd:
    # block 0x00443ecd: entry, 7 instruction(s), ends with jne to 0x00443f71 (forward)
    push ebp                                     # 00443ecd
    {load} mov ebp, esp                          # 00443ece
    sub esp, 0x1d4                               # 00443ed0
    push esi                                     # 00443ed6
    push edi                                     # 00443ed7
    cmp dword ptr [0x5869e5], 0x0                # 00443ed8
    jne.d32 L_00443f71                           # 00443edf
    # block 0x00443ee5: entered by fall-through of jne at 0x00443edf, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00443f71
    push 0x547fd8                                # 00443ee5
    push 0x63a7b4                                # 00443eea
    lea eax, [ebp - local_1ce]                   # 00443eef
    push eax                                     # 00443ef5
    call FUN_0043f210                            # 00443ef6
    add esp, 0xc                                 # 00443efb
    mov edi, 0x547fe0                            # 00443efe
    lea edx, [ebp - local_3e]                    # 00443f03
    or ecx, -0x1                                 # 00443f06
    {load} xor eax, eax                          # 00443f09
    repne scasb al, byte ptr es:[edi]            # 00443f0b
    not ecx                                      # 00443f0d
    {load} sub edi, ecx                          # 00443f0f
    {load} mov esi, edi                          # 00443f11
    {load} mov eax, ecx                          # 00443f13
    {load} mov edi, edx                          # 00443f15
    shr ecx, 0x2                                 # 00443f17
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443f1a
    {load} mov ecx, eax                          # 00443f1c
    and ecx, 0x3                                 # 00443f1e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443f21
    mov word ptr [ebp - local_1c], 0x7b6         # 00443f23
    mov word ptr [ebp - local_1a], 0x0           # 00443f29
    mov word ptr [ebp - local_18], 0x0           # 00443f2f
    mov word ptr [ebp - local_16], 0x1           # 00443f35
    mov word ptr [ebp - local_8], 0xffff         # 00443f3b
    mov byte ptr [ebp - local_6], 0x0            # 00443f41
    mov word ptr [ebp - local_5], 0x2            # 00443f45
    mov dword ptr [ebp - local_14], 0x0          # 00443f4b
    mov dword ptr [ebp - local_10], 0x0          # 00443f52
    mov dword ptr [ebp - local_c], 0x1           # 00443f59
    lea ecx, [ebp - local_1d4]                   # 00443f60
    push ecx                                     # 00443f66
    mov ecx, 0x6177e8                            # 00443f67
    call FUN_0041fa11                            # 00443f6c
L_00443f71:
    # block 0x00443f71: entered by jne at 0x00443edf, 2 instruction(s), ends with jne to 0x00444017 (forward)
    cmp dword ptr [0x5869e5], 0x1                # 00443f71
    jne.d32 L_00444017                           # 00443f78
    # block 0x00443f7e: entered by fall-through of jne at 0x00443f78, 2 instruction(s), ends with jne to 0x00444017 (forward)
    cmp dword ptr [0x5869e1], 0x0                # 00443f7e
    jne.d32 L_00444017                           # 00443f85
    # block 0x00443f8b: entered by fall-through of jne at 0x00443f85, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444017
    push 0x547fe8                                # 00443f8b
    push 0x63a7b8                                # 00443f90
    lea edx, [ebp - local_1ce]                   # 00443f95
    push edx                                     # 00443f9b
    call FUN_0043f210                            # 00443f9c
    add esp, 0xc                                 # 00443fa1
    mov edi, 0x547ff0                            # 00443fa4
    lea edx, [ebp - local_3e]                    # 00443fa9
    or ecx, -0x1                                 # 00443fac
    {load} xor eax, eax                          # 00443faf
    repne scasb al, byte ptr es:[edi]            # 00443fb1
    not ecx                                      # 00443fb3
    {load} sub edi, ecx                          # 00443fb5
    {load} mov esi, edi                          # 00443fb7
    {load} mov eax, ecx                          # 00443fb9
    {load} mov edi, edx                          # 00443fbb
    shr ecx, 0x2                                 # 00443fbd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00443fc0
    {load} mov ecx, eax                          # 00443fc2
    and ecx, 0x3                                 # 00443fc4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00443fc7
    mov word ptr [ebp - local_1c], 0x7bd         # 00443fc9
    mov word ptr [ebp - local_1a], 0x0           # 00443fcf
    mov word ptr [ebp - local_18], 0x0           # 00443fd5
    mov word ptr [ebp - local_16], 0x1           # 00443fdb
    mov word ptr [ebp - local_8], 0xffff         # 00443fe1
    mov byte ptr [ebp - local_6], 0x0            # 00443fe7
    mov word ptr [ebp - local_5], 0x2            # 00443feb
    mov dword ptr [ebp - local_14], 0x0          # 00443ff1
    mov dword ptr [ebp - local_10], 0x0          # 00443ff8
    mov dword ptr [ebp - local_c], 0x1           # 00443fff
    lea ecx, [ebp - local_1d4]                   # 00444006
    push ecx                                     # 0044400c
    mov ecx, 0x6177e8                            # 0044400d
    call FUN_0041fa11                            # 00444012
L_00444017:
    # block 0x00444017: entered by jne at 0x00443f78; jne at 0x00443f85, 2 instruction(s), ends with jne to 0x004440ca (forward)
    cmp dword ptr [0x5869e1], 0x1                # 00444017
    jne.d32 L_004440ca                           # 0044401e
    # block 0x00444024: entered by fall-through of jne at 0x0044401e, 2 instruction(s), ends with jne to 0x004440ca (forward)
    cmp dword ptr [0x586f59], 0x1                # 00444024
    jne.d32 L_004440ca                           # 0044402b
    # block 0x00444031: entered by fall-through of jne at 0x0044402b, 2 instruction(s), ends with jne to 0x004440ca (forward)
    cmp dword ptr [0x5869d5], 0x0                # 00444031
    jne.d32 L_004440ca                           # 00444038
    # block 0x0044403e: entered by fall-through of jne at 0x00444038, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004440ca
    push 0x547ff8                                # 0044403e
    push 0x63a7bc                                # 00444043
    lea edx, [ebp - local_1ce]                   # 00444048
    push edx                                     # 0044404e
    call FUN_0043f210                            # 0044404f
    add esp, 0xc                                 # 00444054
    mov edi, 0x548000                            # 00444057
    lea edx, [ebp - local_3e]                    # 0044405c
    or ecx, -0x1                                 # 0044405f
    {load} xor eax, eax                          # 00444062
    repne scasb al, byte ptr es:[edi]            # 00444064
    not ecx                                      # 00444066
    {load} sub edi, ecx                          # 00444068
    {load} mov esi, edi                          # 0044406a
    {load} mov eax, ecx                          # 0044406c
    {load} mov edi, edx                          # 0044406e
    shr ecx, 0x2                                 # 00444070
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00444073
    {load} mov ecx, eax                          # 00444075
    and ecx, 0x3                                 # 00444077
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044407a
    mov word ptr [ebp - local_1c], 0x7c0         # 0044407c
    mov word ptr [ebp - local_1a], 0x0           # 00444082
    mov word ptr [ebp - local_18], 0x0           # 00444088
    mov word ptr [ebp - local_16], 0x1           # 0044408e
    mov word ptr [ebp - local_8], 0xffff         # 00444094
    mov byte ptr [ebp - local_6], 0x0            # 0044409a
    mov word ptr [ebp - local_5], 0x2            # 0044409e
    mov dword ptr [ebp - local_14], 0x0          # 004440a4
    mov dword ptr [ebp - local_10], 0x0          # 004440ab
    mov dword ptr [ebp - local_c], 0x1           # 004440b2
    lea ecx, [ebp - local_1d4]                   # 004440b9
    push ecx                                     # 004440bf
    mov ecx, 0x6177e8                            # 004440c0
    call FUN_0041fa11                            # 004440c5
L_004440ca:
    # block 0x004440ca: entered by jne at 0x0044401e; jne at 0x0044402b; jne at 0x00444038, 2 instruction(s), ends with jne to 0x00444186 (forward)
    cmp dword ptr [0x5869e5], 0x1                # 004440ca
    jne.d32 L_00444186                           # 004440d1
    # block 0x004440d7: entered by fall-through of jne at 0x004440d1, 2 instruction(s), ends with je to 0x004440ed (forward)
    cmp dword ptr [0x587079], 0x1                # 004440d7
    je.d8 L_004440ed                             # 004440de
    # block 0x004440e0: entered by fall-through of je at 0x004440de, 2 instruction(s), ends with jne to 0x00444186 (forward)
    cmp dword ptr [0x587129], 0x1                # 004440e0
    jne.d32 L_00444186                           # 004440e7
L_004440ed:
    # block 0x004440ed: entered by je at 0x004440de; fall-through of jne at 0x004440e7, 2 instruction(s), ends with jne to 0x00444186 (forward)
    cmp dword ptr [0x5869d1], 0x0                # 004440ed
    jne.d32 L_00444186                           # 004440f4
    # block 0x004440fa: entered by fall-through of jne at 0x004440f4, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444186
    push 0x548008                                # 004440fa
    push 0x63a7c0                                # 004440ff
    lea edx, [ebp - local_1ce]                   # 00444104
    push edx                                     # 0044410a
    call FUN_0043f210                            # 0044410b
    add esp, 0xc                                 # 00444110
    mov edi, 0x548010                            # 00444113
    lea edx, [ebp - local_3e]                    # 00444118
    or ecx, -0x1                                 # 0044411b
    {load} xor eax, eax                          # 0044411e
    repne scasb al, byte ptr es:[edi]            # 00444120
    not ecx                                      # 00444122
    {load} sub edi, ecx                          # 00444124
    {load} mov esi, edi                          # 00444126
    {load} mov eax, ecx                          # 00444128
    {load} mov edi, edx                          # 0044412a
    shr ecx, 0x2                                 # 0044412c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044412f
    {load} mov ecx, eax                          # 00444131
    and ecx, 0x3                                 # 00444133
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00444136
    mov word ptr [ebp - local_1c], 0x7c2         # 00444138
    mov word ptr [ebp - local_1a], 0x0           # 0044413e
    mov word ptr [ebp - local_18], 0x0           # 00444144
    mov word ptr [ebp - local_16], 0x1           # 0044414a
    mov word ptr [ebp - local_8], 0xffff         # 00444150
    mov byte ptr [ebp - local_6], 0x0            # 00444156
    mov word ptr [ebp - local_5], 0x2            # 0044415a
    mov dword ptr [ebp - local_14], 0x0          # 00444160
    mov dword ptr [ebp - local_10], 0x0          # 00444167
    mov dword ptr [ebp - local_c], 0x1           # 0044416e
    lea ecx, [ebp - local_1d4]                   # 00444175
    push ecx                                     # 0044417b
    mov ecx, 0x6177e8                            # 0044417c
    call FUN_0041fa11                            # 00444181
L_00444186:
    # block 0x00444186: entered by jne at 0x004440d1; jne at 0x004440e7; jne at 0x004440f4, 2 instruction(s), ends with jne to 0x00444239 (forward)
    cmp dword ptr [0x5869e5], 0x1                # 00444186
    jne.d32 L_00444239                           # 0044418d
    # block 0x00444193: entered by fall-through of jne at 0x0044418d, 2 instruction(s), ends with jne to 0x00444239 (forward)
    cmp dword ptr [0x587561], 0x1                # 00444193
    jne.d32 L_00444239                           # 0044419a
    # block 0x004441a0: entered by fall-through of jne at 0x0044419a, 2 instruction(s), ends with jne to 0x00444239 (forward)
    cmp dword ptr [0x5869d9], 0x0                # 004441a0
    jne.d32 L_00444239                           # 004441a7
    # block 0x004441ad: entered by fall-through of jne at 0x004441a7, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00444239
    push 0x548018                                # 004441ad
    push 0x63a7c4                                # 004441b2
    lea edx, [ebp - local_1ce]                   # 004441b7
    push edx                                     # 004441bd
    call FUN_0043f210                            # 004441be
    add esp, 0xc                                 # 004441c3
    mov edi, 0x548020                            # 004441c6
    lea edx, [ebp - local_3e]                    # 004441cb
    or ecx, -0x1                                 # 004441ce
    {load} xor eax, eax                          # 004441d1
    repne scasb al, byte ptr es:[edi]            # 004441d3
    not ecx                                      # 004441d5
    {load} sub edi, ecx                          # 004441d7
    {load} mov esi, edi                          # 004441d9
    {load} mov eax, ecx                          # 004441db
    {load} mov edi, edx                          # 004441dd
    shr ecx, 0x2                                 # 004441df
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004441e2
    {load} mov ecx, eax                          # 004441e4
    and ecx, 0x3                                 # 004441e6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004441e9
    mov word ptr [ebp - local_1c], 0x7c4         # 004441eb
    mov word ptr [ebp - local_1a], 0x0           # 004441f1
    mov word ptr [ebp - local_18], 0x0           # 004441f7
    mov word ptr [ebp - local_16], 0x1           # 004441fd
    mov word ptr [ebp - local_8], 0xffff         # 00444203
    mov byte ptr [ebp - local_6], 0x0            # 00444209
    mov word ptr [ebp - local_5], 0x2            # 0044420d
    mov dword ptr [ebp - local_14], 0x0          # 00444213
    mov dword ptr [ebp - local_10], 0x0          # 0044421a
    mov dword ptr [ebp - local_c], 0x1           # 00444221
    lea ecx, [ebp - local_1d4]                   # 00444228
    push ecx                                     # 0044422e
    mov ecx, 0x6177e8                            # 0044422f
    call FUN_0041fa11                            # 00444234
L_00444239:
    # block 0x00444239: entered by jne at 0x0044418d; jne at 0x0044419a; jne at 0x004441a7, 5 instruction(s), ends with ret
    pop edi                                      # 00444239
    pop esi                                      # 0044423a
    {load} mov esp, ebp                          # 0044423b
    pop ebp                                      # 0044423d
    ret                                          # 0044423e

