# FUN_00455cc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455cc3
# extent:       0x00455cc3-0x004564f6 (2099 code bytes)
# span:         0x00455cc3-0x00456506 (code 2099, tables 16, padding 0)
# sha256:       ae24c746ae4caefc874f87ea94a454da022bf26281dab87ab1cc6148249710e9
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00455cc3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_1e, field_2a, field_8e, field_150, field_155, field_159, field_172, field_803 and 8 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_26, field_2a, field_2e, field_8c, field_154, field_155 and 10 more; [edx + n] field_4, field_8, field_c, field_1c, field_21, field_32, field_36, field_38, field_8a, field_d9, field_155, field_159 and 12 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fba69, FUN_0042ad27, FUN_004fb2e3, FUN_00448d11, FUN_0042ba3a, FUN_00454de6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 502 instruction(s), 31 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_38, 0x38  # offset +0x38
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_8e, 0x8e  # offset +0x8e
.equ field_d9, 0xd9  # offset +0xd9
.equ field_150, 0x150  # offset +0x150
.equ field_154, 0x154  # offset +0x154
.equ field_155, 0x155  # offset +0x155
.equ field_159, 0x159  # offset +0x159
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_7e2, 0x7e2  # offset +0x7e2
.equ field_803, 0x803  # offset +0x803
.equ field_bc6, 0xbc6  # offset +0xbc6
.equ field_bc8, 0xbc8  # offset +0xbc8
.equ field_bca, 0xbca  # offset +0xbca
.equ field_bcc, 0xbcc  # offset +0xbcc
.equ field_bce, 0xbce  # offset +0xbce
.equ field_bd2, 0xbd2  # offset +0xbd2
.equ field_bd6, 0xbd6  # offset +0xbd6
.equ field_bda, 0xbda  # offset +0xbda
.equ field_bdc, 0xbdc  # offset +0xbdc
.equ field_bde, 0xbde  # offset +0xbde
.equ field_c00, 0xc00  # offset +0xc00
.equ field_cd8, 0xcd8  # offset +0xcd8
.equ field_cda, 0xcda  # offset +0xcda
.equ field_cdc, 0xcdc  # offset +0xcdc
.equ field_cde, 0xcde  # offset +0xcde
.equ field_ce0, 0xce0  # offset +0xce0
.equ field_ce4, 0xce4  # offset +0xce4
.equ field_ce8, 0xce8  # offset +0xce8
.equ field_cec, 0xcec  # offset +0xcec
.equ field_cee, 0xcee  # offset +0xcee
.equ field_cf0, 0xcf0  # offset +0xcf0

# --- external targets -----------------------------------------------
.set FUN_0042ad27, .text + (0x0042ad27 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_00454de6, .text + (0x00454de6 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00455cc3 - 0x401000
.globl FUN_00455cc3
FUN_00455cc3:
    # block 0x00455cc3: entry, 16 instruction(s), ends with je to 0x00455d13 (forward)
    push ebp                                     # 00455cc3
    {load} mov ebp, esp                          # 00455cc4
    sub esp, 0x1c                                # 00455cc6
    push esi                                     # 00455cc9
    push edi                                     # 00455cca
    mov dword ptr [ebp - local_14], ecx          # 00455ccb
    movsx eax, word ptr [ebp + arg_8]            # 00455cce
    imul eax, eax, 0x8d                          # 00455cd2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00455cd8
    mov dword ptr [ebp - local_4], ecx           # 00455cde
    movsx edx, word ptr [ebp + arg_8]            # 00455ce1
    imul edx, edx, 0x8d                          # 00455ce5
    mov eax, dword ptr [edx + 0x5bb632]          # 00455ceb
    mov dword ptr [ebp - local_18], eax          # 00455cf1
    cmp dword ptr [ebp - local_18], 0x0          # 00455cf4
    je.d8 L_00455d13                             # 00455cf8
    # block 0x00455cfa: entered by fall-through of je at 0x00455cf8, 2 instruction(s), ends with je to 0x00456037 (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 00455cfa
    je.d32 L_00456037                            # 00455cfe
    # block 0x00455d04: entered by fall-through of je at 0x00455cfe, 2 instruction(s), ends with je to 0x004561ea (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 00455d04
    je.d32 L_004561ea                            # 00455d08
    # block 0x00455d0e: entered by fall-through of je at 0x00455d08, 1 instruction(s), ends with forward jump to 0x004564ee
    jmp.d32 L_004564ee                           # 00455d0e
L_00455d13:
    # block 0x00455d13: entered by je at 0x00455cf8, 78 instruction(s), calls FUN_004e8d96, ends with jne to 0x00455e8f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00455d13
    mov dx, word ptr [ebp + arg_8]               # 00455d16
    mov word ptr [ecx + field_1e], dx            # 00455d1a
    mov eax, dword ptr [ebp - local_14]          # 00455d1e
    mov dword ptr [eax + field_150], 0x1         # 00455d21
    mov dword ptr [0x5bb1ca], 0x1                # 00455d2b
    mov ecx, 0x571442                            # 00455d35
    call FUN_004e8d96                            # 00455d3a
    mov ecx, dword ptr [ebp - local_14]          # 00455d3f
    mov dword ptr [ecx + field_2a], 0x0          # 00455d42
    mov edx, dword ptr [ebp - local_14]          # 00455d49
    mov word ptr [edx + field_36], 0xffff        # 00455d4c
    mov eax, dword ptr [ebp - local_14]          # 00455d52
    mov dword ptr [eax + field_2a], 0x0          # 00455d55
    mov ecx, dword ptr [ebp - local_14]          # 00455d5c
    mov dword ptr [ecx + field_2e], 0x0          # 00455d5f
    mov edx, dword ptr [ebp - local_14]          # 00455d66
    mov dword ptr [edx + field_32], 0x0          # 00455d69
    mov eax, dword ptr [ebp - local_14]          # 00455d70
    mov byte ptr [eax + field_159], 0x0          # 00455d73
    mov ecx, dword ptr [ebp - local_14]          # 00455d7a
    mov byte ptr [ecx + field_154], 0x0          # 00455d7d
    mov edx, dword ptr [ebp - local_14]          # 00455d84
    mov dword ptr [edx + field_155], 0x0         # 00455d87
    mov eax, dword ptr [ebp - local_14]          # 00455d91
    movsx ecx, word ptr [eax + field_1e]         # 00455d94
    imul ecx, ecx, 0x8d                          # 00455d98
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00455d9e
    mov edx, dword ptr [ebp - local_14]          # 00455da8
    mov word ptr [edx + field_38], 0xffff        # 00455dab
    {load} xor eax, eax                          # 00455db1
    mov ecx, dword ptr [ebp - local_14]          # 00455db3
    add ecx, 0x3a                                # 00455db6
    mov dword ptr [ecx], eax                     # 00455db9
    mov dword ptr [ecx + field_4], eax           # 00455dbb
    mov dword ptr [ecx + field_8], eax           # 00455dbe
    mov dword ptr [ecx + field_c], eax           # 00455dc1
    {load} xor edx, edx                          # 00455dc4
    mov eax, dword ptr [ebp - local_14]          # 00455dc6
    add eax, 0x4a                                # 00455dc9
    mov dword ptr [eax], edx                     # 00455dcc
    mov dword ptr [eax + field_4], edx           # 00455dce
    mov dword ptr [eax + field_8], edx           # 00455dd1
    mov dword ptr [eax + field_c], edx           # 00455dd4
    {load} xor ecx, ecx                          # 00455dd7
    mov edx, dword ptr [ebp - local_14]          # 00455dd9
    add edx, 0x5a                                # 00455ddc
    mov dword ptr [edx], ecx                     # 00455ddf
    mov dword ptr [edx + field_4], ecx           # 00455de1
    mov dword ptr [edx + field_8], ecx           # 00455de4
    mov dword ptr [edx + field_c], ecx           # 00455de7
    {load} xor eax, eax                          # 00455dea
    mov ecx, dword ptr [ebp - local_14]          # 00455dec
    add ecx, 0x6a                                # 00455def
    mov dword ptr [ecx], eax                     # 00455df2
    mov dword ptr [ecx + field_4], eax           # 00455df4
    mov dword ptr [ecx + field_8], eax           # 00455df7
    mov dword ptr [ecx + field_c], eax           # 00455dfa
    {load} xor edx, edx                          # 00455dfd
    mov eax, dword ptr [ebp - local_14]          # 00455dff
    add eax, 0x15a                               # 00455e02
    mov dword ptr [eax], edx                     # 00455e07
    mov dword ptr [eax + field_4], edx           # 00455e09
    mov dword ptr [eax + field_8], edx           # 00455e0c
    mov dword ptr [eax + field_c], edx           # 00455e0f
    mov ecx, dword ptr [ebp - local_14]          # 00455e12
    mov dword ptr [ecx + field_26], 0x1          # 00455e15
    mov edx, dword ptr [ebp - local_14]          # 00455e1c
    mov word ptr [edx + field_8a], 0x0           # 00455e1f
    mov eax, dword ptr [ebp - local_14]          # 00455e28
    mov word ptr [eax + field_8e], 0xffff        # 00455e2b
    mov ecx, dword ptr [ebp - local_14]          # 00455e34
    mov word ptr [ecx + field_8c], 0x1           # 00455e37
    mov edx, dword ptr [ebp - local_14]          # 00455e40
    mov dword ptr [edx + field_16e], 0x0         # 00455e43
    movsx eax, word ptr [0x5a0541]               # 00455e4d
    cmp eax, 0x1                                 # 00455e54
    jne.d8 L_00455e8f                            # 00455e57
    # block 0x00455e59: entered by fall-through of jne at 0x00455e57, 2 instruction(s), ends with forward jump to 0x00455e6b
    mov dword ptr [ebp - local_8], 0x0           # 00455e59
    jmp.d8 L_00455e6b                            # 00455e60
L_00455e62:
    # block 0x00455e62: entered by jmp at 0x00455e8d, 3 instruction(s), falls into the block at 0x00455e6b
    mov ecx, dword ptr [ebp - local_8]           # 00455e62
    add ecx, 0x1                                 # 00455e65
    mov dword ptr [ebp - local_8], ecx           # 00455e68
L_00455e6b:
    # block 0x00455e6b: entered by jmp at 0x00455e60, 4 instruction(s), ends with jge to 0x00455e8f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00455e6b
    movsx eax, word ptr [edx + field_21]         # 00455e6e
    cmp dword ptr [ebp - local_8], eax           # 00455e72
    jge.d8 L_00455e8f                            # 00455e75
    # block 0x00455e77: entered by fall-through of jge at 0x00455e75, 5 instruction(s), ends with backward jump to 0x00455e62
    mov ecx, dword ptr [ebp - local_8]           # 00455e77
    imul ecx, ecx, 0x96                          # 00455e7a
    mov edx, dword ptr [ebp - local_4]           # 00455e80
    mov word ptr [edx + ecx + field_d9], 0x1     # 00455e83
    jmp.d8 L_00455e62                            # 00455e8d
L_00455e8f:
    # block 0x00455e8f: entered by jne at 0x00455e57; jge at 0x00455e75, 57 instruction(s), calls FUN_004d39f9, ends with jne to 0x00455f97 (forward)
    call FUN_004d39f9                            # 00455e8f
    mov ecx, dword ptr [ebp - local_14]          # 00455e94
    mov word ptr [ecx + field_1c], ax            # 00455e97
    mov edx, dword ptr [ebp - local_14]          # 00455e9b
    movsx eax, word ptr [edx + field_1c]         # 00455e9e
    imul eax, eax, 0x4a                          # 00455ea2
    mov dword ptr [eax + 0x5d1591], 0xa          # 00455ea5
    mov ecx, dword ptr [ebp - local_14]          # 00455eaf
    movsx edx, word ptr [ecx + field_1c]         # 00455eb2
    imul edx, edx, 0x4a                          # 00455eb6
    mov dword ptr [edx + 0x5d1595], 0x456516     # 00455eb9
    mov eax, dword ptr [ebp - local_14]          # 00455ec3
    movsx ecx, word ptr [eax + field_1c]         # 00455ec6
    imul ecx, ecx, 0x4a                          # 00455eca
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00455ecd
    mov edx, dword ptr [ebp - local_14]          # 00455ed7
    movsx eax, word ptr [edx + field_1c]         # 00455eda
    imul eax, eax, 0x4a                          # 00455ede
    mov dword ptr [eax + 0x5d159d], 0x0          # 00455ee1
    mov ecx, dword ptr [ebp - local_14]          # 00455eeb
    movsx edx, word ptr [ecx + field_1c]         # 00455eee
    imul edx, edx, 0x4a                          # 00455ef2
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00455ef5
    mov eax, dword ptr [ebp - local_14]          # 00455eff
    movsx ecx, word ptr [eax + field_1c]         # 00455f02
    imul ecx, ecx, 0x4a                          # 00455f06
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00455f09
    mov edx, dword ptr [ebp - local_14]          # 00455f13
    movsx eax, word ptr [edx + field_1c]         # 00455f16
    imul eax, eax, 0x4a                          # 00455f1a
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00455f1d
    mov ecx, dword ptr [ebp - local_14]          # 00455f27
    movsx edx, word ptr [ecx + field_1c]         # 00455f2a
    imul edx, edx, 0x4a                          # 00455f2e
    mov word ptr [edx + 0x5d15ad], 0x0           # 00455f31
    mov edi, 0x54a068                            # 00455f3a
    mov eax, dword ptr [ebp - local_14]          # 00455f3f
    movsx ecx, word ptr [eax + field_1c]         # 00455f42
    imul ecx, ecx, 0x4a                          # 00455f46
    add ecx, 0x5d15b3                            # 00455f49
    {load} mov edx, ecx                          # 00455f4f
    or ecx, -0x1                                 # 00455f51
    {load} xor eax, eax                          # 00455f54
    repne scasb al, byte ptr es:[edi]            # 00455f56
    not ecx                                      # 00455f58
    {load} sub edi, ecx                          # 00455f5a
    {load} mov esi, edi                          # 00455f5c
    {load} mov eax, ecx                          # 00455f5e
    {load} mov edi, edx                          # 00455f60
    shr ecx, 0x2                                 # 00455f62
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00455f65
    {load} mov ecx, eax                          # 00455f67
    and ecx, 0x3                                 # 00455f69
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00455f6c
    mov ecx, dword ptr [ebp - local_14]          # 00455f6e
    cmp dword ptr [ecx + field_20], 0x0          # 00455f71
    jne.d8 L_00455f97                            # 00455f75
    # block 0x00455f77: entered by fall-through of jne at 0x00455f75, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00455f97
    push 0x54a084                                # 00455f77
    push 0x6                                     # 00455f7c
    mov edx, dword ptr [ebp - local_4]           # 00455f7e
    push edx                                     # 00455f81
    push 0x54a09c                                # 00455f82
    mov ecx, 0x5cf659                            # 00455f87
    call FUN_004c2790                            # 00455f8c
    mov ecx, dword ptr [ebp - local_14]          # 00455f91
    mov dword ptr [ecx + field_20], eax          # 00455f94
L_00455f97:
    # block 0x00455f97: entered by jne at 0x00455f75, 13 instruction(s), ends with je to 0x00455fda (forward)
    mov edx, dword ptr [ebp - local_14]          # 00455f97
    movsx eax, word ptr [edx + field_1c]         # 00455f9a
    imul eax, eax, 0x4a                          # 00455f9e
    mov ecx, dword ptr [ebp - local_14]          # 00455fa1
    mov edx, dword ptr [ecx + field_20]          # 00455fa4
    mov dword ptr [eax + 0x5d1599], edx          # 00455fa7
    mov edi, 0x54a0a4                            # 00455fad
    mov esi, dword ptr [ebp - local_4]           # 00455fb2
    add esi, 0x77e                               # 00455fb5
    mov ecx, 0x9                                 # 00455fbb
    {load} xor eax, eax                          # 00455fc0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455fc2
    je.d8 L_00455fda                             # 00455fc4
    # block 0x00455fc6: entered by fall-through of je at 0x00455fc4, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00455fda
    mov ecx, dword ptr [ebp - local_4]           # 00455fc6
    add ecx, 0x77e                               # 00455fc9
    push ecx                                     # 00455fcf
    mov ecx, 0x5c3a67                            # 00455fd0
    call FUN_004fb77a                            # 00455fd5
L_00455fda:
    # block 0x00455fda: entered by je at 0x00455fc4, 7 instruction(s), ends with je to 0x00456006 (forward)
    mov edi, 0x54a0b0                            # 00455fda
    mov esi, dword ptr [ebp - local_4]           # 00455fdf
    add esi, 0x7af                               # 00455fe2
    mov ecx, 0x9                                 # 00455fe8
    {load} xor edx, edx                          # 00455fed
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455fef
    je.d8 L_00456006                             # 00455ff1
    # block 0x00455ff3: entered by fall-through of je at 0x00455ff1, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00456006
    mov eax, dword ptr [ebp - local_4]           # 00455ff3
    add eax, 0x7af                               # 00455ff6
    push eax                                     # 00455ffb
    mov ecx, 0x5c3a67                            # 00455ffc
    call FUN_004fb77a                            # 00456001
L_00456006:
    # block 0x00456006: entered by je at 0x00455ff1, 7 instruction(s), ends with je to 0x00456032 (forward)
    mov edi, 0x54a0bc                            # 00456006
    mov esi, dword ptr [ebp - local_4]           # 0045600b
    add esi, 0x74d                               # 0045600e
    mov ecx, 0x9                                 # 00456014
    {load} xor edx, edx                          # 00456019
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045601b
    je.d8 L_00456032                             # 0045601d
    # block 0x0045601f: entered by fall-through of je at 0x0045601d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00456032
    mov eax, dword ptr [ebp - local_4]           # 0045601f
    add eax, 0x74d                               # 00456022
    push eax                                     # 00456027
    mov ecx, 0x5c3a67                            # 00456028
    call FUN_004fb77a                            # 0045602d
L_00456032:
    # block 0x00456032: entered by je at 0x0045601d, 1 instruction(s), ends with forward jump to 0x004564ee
    jmp.d32 L_004564ee                           # 00456032
L_00456037:
    # block 0x00456037: entered by je at 0x00455cfe, 8 instruction(s), ends with ja to 0x004561e5 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00456037
    mov edx, dword ptr [ecx + field_155]         # 0045603a
    mov dword ptr [ebp - local_1c], edx          # 00456040
    mov eax, dword ptr [ebp - local_1c]          # 00456043
    sub eax, 0x1                                 # 00456046
    mov dword ptr [ebp - local_1c], eax          # 00456049
    cmp dword ptr [ebp - local_1c], 0x3          # 0045604c
    ja.d32 L_004561e5                            # 00456050
    # block 0x00456056: entered by fall-through of ja at 0x00456050, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4564f6]
    mov ecx, dword ptr [ebp - local_1c]          # 00456056
    jmp dword ptr [4*ecx + SWTAB_004564f6_VA]    # 00456059
L_00456060:
    # block 0x00456060: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045607e (forward)
    call dword ptr [0x52a23c]                    # 00456060
    mov edx, dword ptr [ebp - local_14]          # 00456066
    cmp eax, dword ptr [edx + field_16e]         # 00456069
    jb.d8 L_0045607e                             # 0045606f
    # block 0x00456071: entered by fall-through of jb at 0x0045606f, 2 instruction(s), falls into the block at 0x0045607e
    mov eax, dword ptr [ebp - local_14]          # 00456071
    mov dword ptr [eax + field_155], 0x0         # 00456074
L_0045607e:
    # block 0x0045607e: entered by jb at 0x0045606f, 1 instruction(s), ends with forward jump to 0x004561e5
    jmp.d32 L_004561e5                           # 0045607e
L_00456083:
    # block 0x00456083: entered by switch case, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x004560ed (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00456083
    movsx edx, word ptr [ecx + field_172]        # 00456086
    imul edx, edx, 0x31                          # 0045608d
    mov eax, dword ptr [ebp - local_4]           # 00456090
    movsx ecx, word ptr [eax + edx + field_803]  # 00456093
    mov dword ptr [ebp - local_c], ecx           # 0045609b
    mov edx, dword ptr [ebp - local_c]           # 0045609e
    push edx                                     # 004560a1
    mov ecx, 0x5cf1eb                            # 004560a2
    call FUN_004f6334                            # 004560a7
    test eax, eax                                # 004560ac
    jne.d8 L_004560ed                            # 004560ae
    # block 0x004560b0: entered by fall-through of jne at 0x004560ae, 10 instruction(s), calls FUN_004fba69, ends with je to 0x004560e0 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004560b0
    movsx ecx, word ptr [eax + field_172]        # 004560b3
    imul ecx, ecx, 0x31                          # 004560ba
    mov edx, dword ptr [ebp - local_4]           # 004560bd
    lea eax, [edx + ecx + field_7e2]             # 004560c0
    push eax                                     # 004560c7
    mov ecx, 0x5c3a67                            # 004560c8
    call FUN_004fba69                            # 004560cd
    cmp dword ptr [0x5bb202], 0x0                # 004560d2
    je.d8 L_004560e0                             # 004560d9
    # block 0x004560db: entered by fall-through of je at 0x004560d9, 1 instruction(s), calls FUN_0042ad27, falls into the block at 0x004560e0
    call FUN_0042ad27                            # 004560db
L_004560e0:
    # block 0x004560e0: entered by je at 0x004560d9, 2 instruction(s), falls into the block at 0x004560ed
    mov ecx, dword ptr [ebp - local_14]          # 004560e0
    mov dword ptr [ecx + field_155], 0x0         # 004560e3
L_004560ed:
    # block 0x004560ed: entered by jne at 0x004560ae, 1 instruction(s), ends with forward jump to 0x004561e5
    jmp.d32 L_004561e5                           # 004560ed
L_004560f2:
    # block 0x004560f2: entered by switch case, 7 instruction(s), ends with je to 0x00456182 (forward)
    mov edi, 0x54a0c8                            # 004560f2
    mov esi, dword ptr [ebp - local_4]           # 004560f7
    add esi, 0xbdf                               # 004560fa
    mov ecx, 0x9                                 # 00456100
    {load} xor edx, edx                          # 00456105
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00456107
    je.d8 L_00456182                             # 00456109
    # block 0x0045610b: entered by fall-through of je at 0x00456109, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00456173 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045610b
    add eax, 0xbdf                               # 0045610e
    push eax                                     # 00456113
    mov ecx, 0x5c3a67                            # 00456114
    call FUN_004fb77a                            # 00456119
    mov ecx, dword ptr [ebp - local_4]           # 0045611e
    mov dx, word ptr [ecx + field_c00]           # 00456121
    push edx                                     # 00456128
    mov ecx, 0x5c3a67                            # 00456129
    call FUN_004fb2e3                            # 0045612e
    cmp dword ptr [0x5bb202], 0x0                # 00456133
    je.d8 L_00456173                             # 0045613a
    # block 0x0045613c: entered by fall-through of je at 0x0045613a, 9 instruction(s), ends with jbe to 0x00456173 (forward)
    mov edi, dword ptr [ebp - local_4]           # 0045613c
    add edi, 0xc10                               # 0045613f
    or ecx, -0x1                                 # 00456145
    {load} xor eax, eax                          # 00456148
    repne scasb al, byte ptr es:[edi]            # 0045614a
    not ecx                                      # 0045614c
    add ecx, -0x1                                # 0045614e
    test ecx, ecx                                # 00456151
    jbe.d8 L_00456173                            # 00456153
    # block 0x00456155: entered by fall-through of jbe at 0x00456153, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x00456173
    push 0x0                                     # 00456155
    push -0x1                                    # 00456157
    mov eax, dword ptr [ebp - local_4]           # 00456159
    add eax, 0xc10                               # 0045615c
    push eax                                     # 00456161
    mov ecx, dword ptr [0x5d03b3]                # 00456162
    push ecx                                     # 00456168
    mov ecx, 0x619a05                            # 00456169
    call FUN_00448d11                            # 0045616e
L_00456173:
    # block 0x00456173: entered by je at 0x0045613a; jbe at 0x00456153, 3 instruction(s), ends with forward jump to 0x00456199
    mov edx, dword ptr [ebp - local_14]          # 00456173
    mov dword ptr [edx + field_155], 0x3         # 00456176
    jmp.d8 L_00456199                            # 00456180
L_00456182:
    # block 0x00456182: entered by je at 0x00456109, 4 instruction(s), falls into the block at 0x00456199
    mov eax, dword ptr [ebp - local_14]          # 00456182
    movsx ecx, word ptr [eax + field_1e]         # 00456185
    imul ecx, ecx, 0x8d                          # 00456189
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0045618f
L_00456199:
    # block 0x00456199: entered by jmp at 0x00456180, 1 instruction(s), ends with forward jump to 0x004561e5
    jmp.d8 L_004561e5                            # 00456199
L_0045619b:
    # block 0x0045619b: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004561e5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045619b
    movsx eax, word ptr [edx + field_c00]        # 0045619e
    mov dword ptr [ebp - local_10], eax          # 004561a5
    mov ecx, dword ptr [ebp - local_10]          # 004561a8
    push ecx                                     # 004561ab
    mov ecx, 0x5cf1eb                            # 004561ac
    call FUN_004f6334                            # 004561b1
    test eax, eax                                # 004561b6
    jne.d8 L_004561e5                            # 004561b8
    # block 0x004561ba: entered by fall-through of jne at 0x004561b8, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004561e5
    mov edx, dword ptr [ebp - local_4]           # 004561ba
    add edx, 0xbdf                               # 004561bd
    push edx                                     # 004561c3
    mov ecx, 0x5c3a67                            # 004561c4
    call FUN_004fba69                            # 004561c9
    mov eax, dword ptr [ebp - local_14]          # 004561ce
    movsx ecx, word ptr [eax + field_1e]         # 004561d1
    imul ecx, ecx, 0x8d                          # 004561d5
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004561db
L_004561e5:
    # block 0x004561e5: entered by ja at 0x00456050; jmp at 0x0045607e; jmp at 0x004560ed; jmp at 0x00456199; more, 1 instruction(s), ends with forward jump to 0x004564ee
    jmp.d32 L_004564ee                           # 004561e5
L_004561ea:
    # block 0x004561ea: entered by je at 0x00455d08, 8 instruction(s), ends with je to 0x00456220 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004561ea
    mov edi, 0x54a0d4                            # 004561f4
    mov esi, dword ptr [ebp - local_4]           # 004561f9
    add esi, 0x77e                               # 004561fc
    mov ecx, 0x9                                 # 00456202
    {load} xor edx, edx                          # 00456207
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00456209
    je.d8 L_00456220                             # 0045620b
    # block 0x0045620d: entered by fall-through of je at 0x0045620b, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00456220
    mov eax, dword ptr [ebp - local_4]           # 0045620d
    add eax, 0x77e                               # 00456210
    push eax                                     # 00456215
    mov ecx, 0x5c3a67                            # 00456216
    call FUN_004fba69                            # 0045621b
L_00456220:
    # block 0x00456220: entered by je at 0x0045620b, 7 instruction(s), ends with je to 0x0045624c (forward)
    mov edi, 0x54a0e0                            # 00456220
    mov esi, dword ptr [ebp - local_4]           # 00456225
    add esi, 0x7af                               # 00456228
    mov ecx, 0x9                                 # 0045622e
    {load} xor edx, edx                          # 00456233
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00456235
    je.d8 L_0045624c                             # 00456237
    # block 0x00456239: entered by fall-through of je at 0x00456237, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0045624c
    mov eax, dword ptr [ebp - local_4]           # 00456239
    add eax, 0x7af                               # 0045623c
    push eax                                     # 00456241
    mov ecx, 0x5c3a67                            # 00456242
    call FUN_004fba69                            # 00456247
L_0045624c:
    # block 0x0045624c: entered by je at 0x00456237, 5 instruction(s), ends with je to 0x0045636e (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0045624c
    {load} xor edx, edx                          # 0045624f
    mov dl, byte ptr [ecx + field_154]           # 00456251
    test edx, edx                                # 00456257
    je.d32 L_0045636e                            # 00456259
    # block 0x0045625f: entered by fall-through of je at 0x00456259, 4 instruction(s), ends with je to 0x00456311 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045625f
    movsx ecx, word ptr [eax + field_cd8]        # 00456262
    cmp ecx, 0x270f                              # 00456269
    je.d32 L_00456311                            # 0045626f
    # block 0x00456275: entered by fall-through of je at 0x0045626f, 25 instruction(s), ends with jne to 0x004562fd (forward)
    mov edx, dword ptr [ebp - local_4]           # 00456275
    movsx eax, word ptr [edx + field_cd8]        # 00456278
    mov dword ptr [0x5bb57b], eax                # 0045627f
    mov ecx, dword ptr [ebp - local_4]           # 00456284
    mov dx, word ptr [ecx + field_cda]           # 00456287
    mov word ptr [0x5bb599], dx                  # 0045628e
    mov eax, dword ptr [ebp - local_4]           # 00456295
    mov cx, word ptr [eax + field_cdc]           # 00456298
    mov word ptr [0x5bb595], cx                  # 0045629f
    mov edx, dword ptr [ebp - local_4]           # 004562a6
    mov ax, word ptr [edx + field_cde]           # 004562a9
    mov word ptr [0x5c39ff], ax                  # 004562b0
    mov ecx, dword ptr [ebp - local_4]           # 004562b6
    mov edx, dword ptr [ecx + field_ce0]         # 004562b9
    mov dword ptr [0x5bb59b], edx                # 004562bf
    mov eax, dword ptr [ebp - local_4]           # 004562c5
    mov ecx, dword ptr [eax + field_ce4]         # 004562c8
    mov dword ptr [0x5bb59f], ecx                # 004562ce
    mov edx, dword ptr [ebp - local_4]           # 004562d4
    mov eax, dword ptr [edx + field_ce8]         # 004562d7
    mov dword ptr [0x5bb5a3], eax                # 004562dd
    mov ecx, dword ptr [ebp - local_4]           # 004562e2
    movsx edx, word ptr [ecx + field_cec]        # 004562e5
    cmp edx, 0x1                                 # 004562ec
    jne.d8 L_004562fd                            # 004562ef
    # block 0x004562f1: entered by fall-through of jne at 0x004562ef, 2 instruction(s), ends with forward jump to 0x00456307
    mov dword ptr [0x5bb1ca], 0x0                # 004562f1
    jmp.d8 L_00456307                            # 004562fb
L_004562fd:
    # block 0x004562fd: entered by jne at 0x004562ef, 1 instruction(s), falls into the block at 0x00456307
    mov dword ptr [0x5bb1ca], 0x1                # 004562fd
L_00456307:
    # block 0x00456307: entered by jmp at 0x004562fb, 1 instruction(s), falls into the block at 0x00456311
    mov dword ptr [0x583999], 0x4                # 00456307
L_00456311:
    # block 0x00456311: entered by je at 0x0045626f, 7 instruction(s), ends with je to 0x0045633e (forward)
    mov edi, 0x54a0ec                            # 00456311
    mov esi, dword ptr [ebp - local_4]           # 00456316
    add esi, 0x74d                               # 00456319
    mov ecx, 0x9                                 # 0045631f
    {load} xor eax, eax                          # 00456324
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00456326
    je.d8 L_0045633e                             # 00456328
    # block 0x0045632a: entered by fall-through of je at 0x00456328, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0045633e
    mov ecx, dword ptr [ebp - local_4]           # 0045632a
    add ecx, 0x74d                               # 0045632d
    push ecx                                     # 00456333
    mov ecx, 0x5c3a67                            # 00456334
    call FUN_004fba69                            # 00456339
L_0045633e:
    # block 0x0045633e: entered by je at 0x00456328, 4 instruction(s), ends with je to 0x00456369 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045633e
    movsx eax, word ptr [edx + field_cee]        # 00456341
    cmp eax, -0x1                                # 00456348
    je.d8 L_00456369                             # 0045634b
    # block 0x0045634d: entered by fall-through of je at 0x0045634b, 6 instruction(s), falls into the block at 0x00456369
    mov ecx, dword ptr [ebp - local_4]           # 0045634d
    {load} xor edx, edx                          # 00456350
    mov dl, byte ptr [ecx + field_cf0]           # 00456352
    mov eax, dword ptr [ebp - local_4]           # 00456358
    movsx ecx, word ptr [eax + field_cee]        # 0045635b
    mov dword ptr [4*ecx + 0x585801], edx        # 00456362
L_00456369:
    # block 0x00456369: entered by je at 0x0045634b, 1 instruction(s), ends with forward jump to 0x004564ba
    jmp.d32 L_004564ba                           # 00456369
L_0045636e:
    # block 0x0045636e: entered by je at 0x00456259, 5 instruction(s), ends with je to 0x004564ba (forward)
    mov edx, dword ptr [ebp - local_14]          # 0045636e
    {load} xor eax, eax                          # 00456371
    mov al, byte ptr [edx + field_159]           # 00456373
    test eax, eax                                # 00456379
    je.d32 L_004564ba                            # 0045637b
    # block 0x00456381: entered by fall-through of je at 0x0045637b, 5 instruction(s), ends with je to 0x0045646b (forward)
    mov word ptr [0x5a0541], 0x1                 # 00456381
    mov ecx, dword ptr [ebp - local_4]           # 0045638a
    movsx edx, word ptr [ecx + field_bc6]        # 0045638d
    cmp edx, 0x270f                              # 00456394
    je.d32 L_0045646b                            # 0045639a
    # block 0x004563a0: entered by fall-through of je at 0x0045639a, 25 instruction(s), ends with jne to 0x00456429 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004563a0
    movsx ecx, word ptr [eax + field_bc6]        # 004563a3
    mov dword ptr [0x5bb57b], ecx                # 004563aa
    mov edx, dword ptr [ebp - local_4]           # 004563b0
    mov ax, word ptr [edx + field_bc8]           # 004563b3
    mov word ptr [0x5bb599], ax                  # 004563ba
    mov ecx, dword ptr [ebp - local_4]           # 004563c0
    mov dx, word ptr [ecx + field_bca]           # 004563c3
    mov word ptr [0x5bb595], dx                  # 004563ca
    mov eax, dword ptr [ebp - local_4]           # 004563d1
    mov cx, word ptr [eax + field_bcc]           # 004563d4
    mov word ptr [0x5c39ff], cx                  # 004563db
    mov edx, dword ptr [ebp - local_4]           # 004563e2
    mov eax, dword ptr [edx + field_bce]         # 004563e5
    mov dword ptr [0x5bb59b], eax                # 004563eb
    mov ecx, dword ptr [ebp - local_4]           # 004563f0
    mov edx, dword ptr [ecx + field_bd2]         # 004563f3
    mov dword ptr [0x5bb59f], edx                # 004563f9
    mov eax, dword ptr [ebp - local_4]           # 004563ff
    mov ecx, dword ptr [eax + field_bd6]         # 00456402
    mov dword ptr [0x5bb5a3], ecx                # 00456408
    mov edx, dword ptr [ebp - local_4]           # 0045640e
    movsx eax, word ptr [edx + field_bda]        # 00456411
    cmp eax, 0x1                                 # 00456418
    jne.d8 L_00456429                            # 0045641b
    # block 0x0045641d: entered by fall-through of jne at 0x0045641b, 2 instruction(s), ends with forward jump to 0x00456433
    mov dword ptr [0x5bb1ca], 0x0                # 0045641d
    jmp.d8 L_00456433                            # 00456427
L_00456429:
    # block 0x00456429: entered by jne at 0x0045641b, 1 instruction(s), falls into the block at 0x00456433
    mov dword ptr [0x5bb1ca], 0x1                # 00456429
L_00456433:
    # block 0x00456433: entered by jmp at 0x00456427, 8 instruction(s), ends with je to 0x00456469 (forward)
    mov dword ptr [0x583999], 0x4                # 00456433
    mov edi, 0x54a0f8                            # 0045643d
    mov esi, dword ptr [ebp - local_4]           # 00456442
    add esi, 0x74d                               # 00456445
    mov ecx, 0x9                                 # 0045644b
    {load} xor edx, edx                          # 00456450
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00456452
    je.d8 L_00456469                             # 00456454
    # block 0x00456456: entered by fall-through of je at 0x00456454, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00456469
    mov eax, dword ptr [ebp - local_4]           # 00456456
    add eax, 0x74d                               # 00456459
    push eax                                     # 0045645e
    mov ecx, 0x5c3a67                            # 0045645f
    call FUN_004fba69                            # 00456464
L_00456469:
    # block 0x00456469: entered by je at 0x00456454, 1 instruction(s), ends with forward jump to 0x0045648f
    jmp.d8 L_0045648f                            # 00456469
L_0045646b:
    # block 0x0045646b: entered by je at 0x0045639a, 6 instruction(s), falls into the block at 0x0045648f
    mov ecx, dword ptr [ebp - local_14]          # 0045646b
    movsx edx, word ptr [ecx + field_1e]         # 0045646e
    imul edx, edx, 0x8d                          # 00456472
    mov dword ptr [edx + 0x5bb632], 0x1          # 00456478
    mov eax, dword ptr [ebp - local_14]          # 00456482
    mov dword ptr [eax + field_155], 0x0         # 00456485
L_0045648f:
    # block 0x0045648f: entered by jmp at 0x00456469, 4 instruction(s), ends with je to 0x004564ba (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045648f
    movsx edx, word ptr [ecx + field_bdc]        # 00456492
    cmp edx, -0x1                                # 00456499
    je.d8 L_004564ba                             # 0045649c
    # block 0x0045649e: entered by fall-through of je at 0x0045649c, 6 instruction(s), falls into the block at 0x004564ba
    mov eax, dword ptr [ebp - local_4]           # 0045649e
    {load} xor ecx, ecx                          # 004564a1
    mov cl, byte ptr [eax + field_bde]           # 004564a3
    mov edx, dword ptr [ebp - local_4]           # 004564a9
    movsx eax, word ptr [edx + field_bdc]        # 004564ac
    mov dword ptr [4*eax + 0x585801], ecx        # 004564b3
L_004564ba:
    # block 0x004564ba: entered by jmp at 0x00456369; je at 0x0045637b; je at 0x0045649c, 3 instruction(s), ends with je to 0x004564d6 (forward)
    movsx ecx, word ptr [0x5a0541]               # 004564ba
    test ecx, ecx                                # 004564c1
    je.d8 L_004564d6                             # 004564c3
    # block 0x004564c5: entered by fall-through of je at 0x004564c3, 4 instruction(s), ends with je to 0x004564ee (forward)
    mov edx, dword ptr [ebp - local_4]           # 004564c5
    movsx eax, word ptr [edx + field_bc6]        # 004564c8
    cmp eax, 0x270f                              # 004564cf
    je.d8 L_004564ee                             # 004564d4
L_004564d6:
    # block 0x004564d6: entered by je at 0x004564c3; fall-through of je at 0x004564d4, 7 instruction(s), calls FUN_0042ba3a, FUN_00454de6, falls into the block at 0x004564ee
    mov ecx, dword ptr [ebp - local_14]          # 004564d6
    mov dx, word ptr [ecx + field_1e]            # 004564d9
    push edx                                     # 004564dd
    call FUN_0042ba3a                            # 004564de
    add esp, 0x4                                 # 004564e3
    mov ecx, dword ptr [ebp - local_14]          # 004564e6
    call FUN_00454de6                            # 004564e9
L_004564ee:
    # block 0x004564ee: entered by jmp at 0x00455d0e; jmp at 0x00456032; jmp at 0x004561e5; je at 0x004564d4, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004564ee
    pop esi                                      # 004564ef
    {load} mov esp, ebp                          # 004564f0
    pop ebp                                      # 004564f2
    ret 0x4                                      # 004564f3

# --- data items (not part of the function) -------------------------
.org 0x004564f6 - 0x401000
SWTAB_004564f6:  # 4 case address(es)
    .long L_00456060 - .text + 0x401000
    .long L_00456083 - .text + 0x401000
    .long L_0045619b - .text + 0x401000
    .long L_004560f2 - .text + 0x401000
.set SWTAB_004564f6_VA, SWTAB_004564f6 - .text + 0x401000

