# FUN_004a6c61
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6c61
# extent:       0x004a6c61-0x004a7970 (3343 code bytes)
# span:         0x004a6c61-0x004a7994 (code 3343, tables 36, padding 0)
# sha256:       93a07af050a444c694c473fed7b9f7d9a36600fb666595c5b9cbb3355bb9f97e
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a6c61
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_20, field_21, field_25, field_29, field_2a, field_2c, field_2d, field_2e and 33 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_21, field_29, field_2a, field_2c, field_2d, field_2e and 32 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_21, field_29, field_2a, field_2c, field_2d, field_2e and 15 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004a6bde, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004a63dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 900 instruction(s), 56 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_63, 0x63  # offset +0x63
.equ field_64, 0x64  # offset +0x64
.equ field_65, 0x65  # offset +0x65
.equ field_66, 0x66  # offset +0x66
.equ field_68, 0x68  # offset +0x68
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6c, 0x6c  # offset +0x6c
.equ field_6e, 0x6e  # offset +0x6e
.equ field_70, 0x70  # offset +0x70
.equ field_72, 0x72  # offset +0x72
.equ field_74, 0x74  # offset +0x74
.equ field_76, 0x76  # offset +0x76
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_86, 0x86  # offset +0x86
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8b, 0x8b  # offset +0x8b
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1da, 0x1da  # offset +0x1da
.equ field_1de, 0x1de  # offset +0x1de
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_1f6, 0x1f6  # offset +0x1f6
.equ field_296, 0x296  # offset +0x296
.equ field_352, 0x352  # offset +0x352
.equ field_362, 0x362  # offset +0x362
.equ field_364, 0x364  # offset +0x364
.equ field_366, 0x366  # offset +0x366
.equ field_368, 0x368  # offset +0x368
.equ field_36a, 0x36a  # offset +0x36a
.equ field_36e, 0x36e  # offset +0x36e
.equ field_372, 0x372  # offset +0x372
.equ field_376, 0x376  # offset +0x376
.equ field_378, 0x378  # offset +0x378
.equ field_37a, 0x37a  # offset +0x37a
.equ field_37b, 0x37b  # offset +0x37b
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3ae, 0x3ae  # offset +0x3ae
.equ field_3b0, 0x3b0  # offset +0x3b0
.equ field_3b2, 0x3b2  # offset +0x3b2
.equ field_3b4, 0x3b4  # offset +0x3b4
.equ field_3b6, 0x3b6  # offset +0x3b6
.equ field_3ba, 0x3ba  # offset +0x3ba
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3c4, 0x3c4  # offset +0x3c4
.equ field_3c6, 0x3c6  # offset +0x3c6

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004a63dc, .text + (0x004a63dc - 0x401000)
.set FUN_004a6bde, .text + (0x004a6bde - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004a6c61 - 0x401000
.globl FUN_004a6c61
FUN_004a6c61:
    # block 0x004a6c61: entry, 16 instruction(s), ends with je to 0x004a6cb1 (forward)
    push ebp                                     # 004a6c61
    {load} mov ebp, esp                          # 004a6c62
    sub esp, 0x18                                # 004a6c64
    push esi                                     # 004a6c67
    push edi                                     # 004a6c68
    mov dword ptr [ebp - local_10], ecx          # 004a6c69
    movsx eax, word ptr [ebp + arg_8]            # 004a6c6c
    imul eax, eax, 0x8d                          # 004a6c70
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a6c76
    mov dword ptr [ebp - local_4], ecx           # 004a6c7c
    movsx edx, word ptr [ebp + arg_8]            # 004a6c7f
    imul edx, edx, 0x8d                          # 004a6c83
    mov eax, dword ptr [edx + 0x5bb632]          # 004a6c89
    mov dword ptr [ebp - local_14], eax          # 004a6c8f
    cmp dword ptr [ebp - local_14], 0x0          # 004a6c92
    je.d8 L_004a6cb1                             # 004a6c96
    # block 0x004a6c98: entered by fall-through of je at 0x004a6c96, 2 instruction(s), ends with je to 0x004a7098 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 004a6c98
    je.d32 L_004a7098                            # 004a6c9c
    # block 0x004a6ca2: entered by fall-through of je at 0x004a6c9c, 2 instruction(s), ends with je to 0x004a76dc (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 004a6ca2
    je.d32 L_004a76dc                            # 004a6ca6
    # block 0x004a6cac: entered by fall-through of je at 0x004a6ca6, 1 instruction(s), ends with forward jump to 0x004a7968
    jmp.d32 L_004a7968                           # 004a6cac
L_004a6cb1:
    # block 0x004a6cb1: entered by je at 0x004a6c96, 83 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x004a6e2c (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a6cb1
    mov dx, word ptr [ebp + arg_8]               # 004a6cb4
    mov word ptr [ecx + field_1e], dx            # 004a6cb8
    mov eax, dword ptr [ebp - local_10]          # 004a6cbc
    mov dword ptr [eax + field_86], 0x1          # 004a6cbf
    mov ecx, dword ptr [ebp - local_10]          # 004a6cc9
    mov byte ptr [ecx + field_20], 0x0           # 004a6ccc
    mov edx, dword ptr [ebp - local_10]          # 004a6cd0
    mov byte ptr [edx + field_8b], 0x0           # 004a6cd3
    mov eax, dword ptr [ebp - local_10]          # 004a6cda
    mov byte ptr [eax + field_8a], 0x0           # 004a6cdd
    mov dword ptr [0x5bb1ca], 0x1                # 004a6ce4
    mov ecx, dword ptr [ebp - local_10]          # 004a6cee
    mov word ptr [ecx + field_2e], 0x0           # 004a6cf1
    {load} xor edx, edx                          # 004a6cf7
    mov eax, dword ptr [ebp - local_10]          # 004a6cf9
    add eax, 0x94                                # 004a6cfc
    mov dword ptr [eax], edx                     # 004a6d01
    mov dword ptr [eax + field_4], edx           # 004a6d03
    mov word ptr [eax + field_8], dx             # 004a6d06
    mov ecx, dword ptr [ebp - local_10]          # 004a6d0a
    mov byte ptr [ecx + field_29], 0x0           # 004a6d0d
    mov edx, dword ptr [ebp - local_10]          # 004a6d11
    mov word ptr [edx + field_2a], 0x0           # 004a6d14
    mov ecx, 0x571442                            # 004a6d1a
    call FUN_004e8d96                            # 004a6d1f
    call FUN_004d39f9                            # 004a6d24
    mov ecx, dword ptr [ebp - local_10]          # 004a6d29
    mov word ptr [ecx + field_1c], ax            # 004a6d2c
    mov edx, dword ptr [ebp - local_10]          # 004a6d30
    movsx eax, word ptr [edx + field_1c]         # 004a6d33
    imul eax, eax, 0x4a                          # 004a6d37
    mov dword ptr [eax + 0x5d1591], 0xa          # 004a6d3a
    mov ecx, dword ptr [ebp - local_10]          # 004a6d44
    movsx edx, word ptr [ecx + field_1c]         # 004a6d47
    imul edx, edx, 0x4a                          # 004a6d4b
    mov dword ptr [edx + 0x5d1595], 0x4a7a29     # 004a6d4e
    mov eax, dword ptr [ebp - local_10]          # 004a6d58
    movsx ecx, word ptr [eax + field_1c]         # 004a6d5b
    imul ecx, ecx, 0x4a                          # 004a6d5f
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004a6d62
    mov edx, dword ptr [ebp - local_10]          # 004a6d6c
    movsx eax, word ptr [edx + field_1c]         # 004a6d6f
    imul eax, eax, 0x4a                          # 004a6d73
    mov dword ptr [eax + 0x5d159d], 0x0          # 004a6d76
    mov ecx, dword ptr [ebp - local_10]          # 004a6d80
    movsx edx, word ptr [ecx + field_1c]         # 004a6d83
    imul edx, edx, 0x4a                          # 004a6d87
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004a6d8a
    mov eax, dword ptr [ebp - local_10]          # 004a6d94
    movsx ecx, word ptr [eax + field_1c]         # 004a6d97
    imul ecx, ecx, 0x4a                          # 004a6d9b
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a6d9e
    mov edx, dword ptr [ebp - local_10]          # 004a6da8
    movsx eax, word ptr [edx + field_1c]         # 004a6dab
    imul eax, eax, 0x4a                          # 004a6daf
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004a6db2
    mov ecx, dword ptr [ebp - local_10]          # 004a6dbc
    movsx edx, word ptr [ecx + field_1c]         # 004a6dbf
    imul edx, edx, 0x4a                          # 004a6dc3
    mov word ptr [edx + 0x5d15ad], 0x0           # 004a6dc6
    mov edi, 0x550970                            # 004a6dcf
    mov eax, dword ptr [ebp - local_10]          # 004a6dd4
    movsx ecx, word ptr [eax + field_1c]         # 004a6dd7
    imul ecx, ecx, 0x4a                          # 004a6ddb
    add ecx, 0x5d15b3                            # 004a6dde
    {load} mov edx, ecx                          # 004a6de4
    or ecx, -0x1                                 # 004a6de6
    {load} xor eax, eax                          # 004a6de9
    repne scasb al, byte ptr es:[edi]            # 004a6deb
    not ecx                                      # 004a6ded
    {load} sub edi, ecx                          # 004a6def
    {load} mov esi, edi                          # 004a6df1
    {load} mov eax, ecx                          # 004a6df3
    {load} mov edi, edx                          # 004a6df5
    shr ecx, 0x2                                 # 004a6df7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a6dfa
    {load} mov ecx, eax                          # 004a6dfc
    and ecx, 0x3                                 # 004a6dfe
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a6e01
    mov ecx, dword ptr [ebp - local_10]          # 004a6e03
    cmp dword ptr [ecx + field_34], 0x0          # 004a6e06
    jne.d8 L_004a6e2c                            # 004a6e0a
    # block 0x004a6e0c: entered by fall-through of jne at 0x004a6e0a, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004a6e2c
    push 0x55098c                                # 004a6e0c
    push 0x6                                     # 004a6e11
    mov edx, dword ptr [ebp - local_4]           # 004a6e13
    push edx                                     # 004a6e16
    push 0x5509a8                                # 004a6e17
    mov ecx, 0x5cf659                            # 004a6e1c
    call FUN_004c2790                            # 004a6e21
    mov ecx, dword ptr [ebp - local_10]          # 004a6e26
    mov dword ptr [ecx + field_34], eax          # 004a6e29
L_004a6e2c:
    # block 0x004a6e2c: entered by jne at 0x004a6e0a, 9 instruction(s), ends with jne to 0x004a6e4b (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a6e2c
    add edi, 0x21                                # 004a6e2f
    or ecx, -0x1                                 # 004a6e32
    {load} xor eax, eax                          # 004a6e35
    repne scasb al, byte ptr es:[edi]            # 004a6e37
    not ecx                                      # 004a6e39
    add ecx, -0x1                                # 004a6e3b
    test ecx, ecx                                # 004a6e3e
    jne.d8 L_004a6e4b                            # 004a6e40
    # block 0x004a6e42: entered by fall-through of jne at 0x004a6e40, 3 instruction(s), ends with forward jump to 0x004a6e7e
    mov edx, dword ptr [ebp - local_10]          # 004a6e42
    mov byte ptr [edx + field_2d], 0x1           # 004a6e45
    jmp.d8 L_004a6e7e                            # 004a6e49
L_004a6e4b:
    # block 0x004a6e4b: entered by jne at 0x004a6e40, 3 instruction(s), ends with jne to 0x004a6e7e (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a6e4b
    cmp dword ptr [eax + field_38], 0x0          # 004a6e4e
    jne.d8 L_004a6e7e                            # 004a6e52
    # block 0x004a6e54: entered by fall-through of jne at 0x004a6e52, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x004a6e7e
    push 0x5509b0                                # 004a6e54
    push 0x6                                     # 004a6e59
    mov ecx, dword ptr [ebp - local_4]           # 004a6e5b
    add ecx, 0x21                                # 004a6e5e
    push ecx                                     # 004a6e61
    push 0x5509cc                                # 004a6e62
    mov ecx, 0x5cf659                            # 004a6e67
    call FUN_004c2790                            # 004a6e6c
    mov edx, dword ptr [ebp - local_10]          # 004a6e71
    mov dword ptr [edx + field_38], eax          # 004a6e74
    mov eax, dword ptr [ebp - local_10]          # 004a6e77
    mov byte ptr [eax + field_2d], 0x0           # 004a6e7a
L_004a6e7e:
    # block 0x004a6e7e: entered by jmp at 0x004a6e49; jne at 0x004a6e52, 9 instruction(s), ends with jne to 0x004a6e9d (forward)
    mov edi, dword ptr [ebp - local_4]           # 004a6e7e
    add edi, 0x42                                # 004a6e81
    or ecx, -0x1                                 # 004a6e84
    {load} xor eax, eax                          # 004a6e87
    repne scasb al, byte ptr es:[edi]            # 004a6e89
    not ecx                                      # 004a6e8b
    add ecx, -0x1                                # 004a6e8d
    test ecx, ecx                                # 004a6e90
    jne.d8 L_004a6e9d                            # 004a6e92
    # block 0x004a6e94: entered by fall-through of jne at 0x004a6e92, 3 instruction(s), ends with forward jump to 0x004a6ed0
    mov ecx, dword ptr [ebp - local_10]          # 004a6e94
    mov byte ptr [ecx + field_2c], 0x0           # 004a6e97
    jmp.d8 L_004a6ed0                            # 004a6e9b
L_004a6e9d:
    # block 0x004a6e9d: entered by jne at 0x004a6e92, 3 instruction(s), ends with jne to 0x004a6ed0 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a6e9d
    cmp dword ptr [edx + field_3c], 0x0          # 004a6ea0
    jne.d8 L_004a6ed0                            # 004a6ea4
    # block 0x004a6ea6: entered by fall-through of jne at 0x004a6ea4, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x004a6ed0
    push 0x5509d4                                # 004a6ea6
    push 0x6                                     # 004a6eab
    mov eax, dword ptr [ebp - local_4]           # 004a6ead
    add eax, 0x42                                # 004a6eb0
    push eax                                     # 004a6eb3
    push 0x5509f4                                # 004a6eb4
    mov ecx, 0x5cf659                            # 004a6eb9
    call FUN_004c2790                            # 004a6ebe
    mov ecx, dword ptr [ebp - local_10]          # 004a6ec3
    mov dword ptr [ecx + field_3c], eax          # 004a6ec6
    mov edx, dword ptr [ebp - local_10]          # 004a6ec9
    mov byte ptr [edx + field_2c], 0x1           # 004a6ecc
L_004a6ed0:
    # block 0x004a6ed0: entered by jmp at 0x004a6e9b; jne at 0x004a6ea4, 23 instruction(s), ends with je to 0x004a6f2a (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a6ed0
    mov ecx, dword ptr [ebp - local_10]          # 004a6ed3
    mov edx, dword ptr [ecx + field_34]          # 004a6ed6
    mov dword ptr [eax + field_30], edx          # 004a6ed9
    mov eax, dword ptr [ebp - local_4]           # 004a6edc
    add eax, 0x76                                # 004a6edf
    mov ecx, dword ptr [ebp - local_10]          # 004a6ee2
    add ecx, 0x40                                # 004a6ee5
    mov edx, dword ptr [eax]                     # 004a6ee8
    mov dword ptr [ecx], edx                     # 004a6eea
    mov edx, dword ptr [eax + field_4]           # 004a6eec
    mov dword ptr [ecx + field_4], edx           # 004a6eef
    mov edx, dword ptr [eax + field_8]           # 004a6ef2
    mov dword ptr [ecx + field_8], edx           # 004a6ef5
    mov eax, dword ptr [eax + field_c]           # 004a6ef8
    mov dword ptr [ecx + field_c], eax           # 004a6efb
    mov edi, 0x5509fc                            # 004a6efe
    mov esi, dword ptr [ebp - local_4]           # 004a6f03
    add esi, 0x300                               # 004a6f06
    mov ecx, 0x9                                 # 004a6f0c
    {load} xor edx, edx                          # 004a6f11
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a6f13
    je.d8 L_004a6f2a                             # 004a6f15
    # block 0x004a6f17: entered by fall-through of je at 0x004a6f15, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a6f2a
    mov eax, dword ptr [ebp - local_4]           # 004a6f17
    add eax, 0x300                               # 004a6f1a
    push eax                                     # 004a6f1f
    mov ecx, 0x5c3a67                            # 004a6f20
    call FUN_004fb77a                            # 004a6f25
L_004a6f2a:
    # block 0x004a6f2a: entered by je at 0x004a6f15, 7 instruction(s), ends with je to 0x004a6f56 (forward)
    mov edi, 0x550a08                            # 004a6f2a
    mov esi, dword ptr [ebp - local_4]           # 004a6f2f
    add esi, 0x2cf                               # 004a6f32
    mov ecx, 0x9                                 # 004a6f38
    {load} xor edx, edx                          # 004a6f3d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a6f3f
    je.d8 L_004a6f56                             # 004a6f41
    # block 0x004a6f43: entered by fall-through of je at 0x004a6f41, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a6f56
    mov eax, dword ptr [ebp - local_4]           # 004a6f43
    add eax, 0x2cf                               # 004a6f46
    push eax                                     # 004a6f4b
    mov ecx, 0x5c3a67                            # 004a6f4c
    call FUN_004fb77a                            # 004a6f51
L_004a6f56:
    # block 0x004a6f56: entered by je at 0x004a6f41, 7 instruction(s), ends with je to 0x004a6f82 (forward)
    mov edi, 0x550a14                            # 004a6f56
    mov esi, dword ptr [ebp - local_4]           # 004a6f5b
    add esi, 0x331                               # 004a6f5e
    mov ecx, 0x9                                 # 004a6f64
    {load} xor edx, edx                          # 004a6f69
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a6f6b
    je.d8 L_004a6f82                             # 004a6f6d
    # block 0x004a6f6f: entered by fall-through of je at 0x004a6f6d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a6f82
    mov eax, dword ptr [ebp - local_4]           # 004a6f6f
    add eax, 0x331                               # 004a6f72
    push eax                                     # 004a6f77
    mov ecx, 0x5c3a67                            # 004a6f78
    call FUN_004fb77a                            # 004a6f7d
L_004a6f82:
    # block 0x004a6f82: entered by je at 0x004a6f6d, 67 instruction(s), ends with forward jump to 0x004a7968
    mov ecx, dword ptr [ebp - local_4]           # 004a6f82
    mov edx, dword ptr [ecx + field_6a]          # 004a6f85
    add edx, dword ptr [0x58318a]                # 004a6f88
    mov eax, dword ptr [ebp - local_10]          # 004a6f8e
    mov dword ptr [eax + field_54], edx          # 004a6f91
    mov ecx, dword ptr [ebp - local_4]           # 004a6f94
    mov edx, dword ptr [ecx + field_72]          # 004a6f97
    add edx, dword ptr [0x58318a]                # 004a6f9a
    mov eax, dword ptr [ebp - local_10]          # 004a6fa0
    mov dword ptr [eax + field_5c], edx          # 004a6fa3
    mov ecx, dword ptr [ebp - local_4]           # 004a6fa6
    mov edx, dword ptr [ecx + field_66]          # 004a6fa9
    add edx, dword ptr [0x583186]                # 004a6fac
    mov eax, dword ptr [ebp - local_10]          # 004a6fb2
    mov dword ptr [eax + field_50], edx          # 004a6fb5
    mov ecx, dword ptr [ebp - local_4]           # 004a6fb8
    mov edx, dword ptr [ecx + field_6e]          # 004a6fbb
    add edx, dword ptr [0x583186]                # 004a6fbe
    mov eax, dword ptr [ebp - local_10]          # 004a6fc4
    mov dword ptr [eax + field_58], edx          # 004a6fc7
    mov ecx, dword ptr [ebp - local_4]           # 004a6fca
    mov edx, dword ptr [ecx + field_1ba]         # 004a6fcd
    add edx, dword ptr [0x58318a]                # 004a6fd3
    mov eax, dword ptr [ebp - local_10]          # 004a6fd9
    mov dword ptr [eax + field_64], edx          # 004a6fdc
    mov ecx, dword ptr [ebp - local_4]           # 004a6fdf
    mov edx, dword ptr [ecx + field_1c2]         # 004a6fe2
    add edx, dword ptr [0x58318a]                # 004a6fe8
    mov eax, dword ptr [ebp - local_10]          # 004a6fee
    mov dword ptr [eax + field_6c], edx          # 004a6ff1
    mov ecx, dword ptr [ebp - local_4]           # 004a6ff4
    mov edx, dword ptr [ecx + field_1b6]         # 004a6ff7
    add edx, dword ptr [0x583186]                # 004a6ffd
    mov eax, dword ptr [ebp - local_10]          # 004a7003
    mov dword ptr [eax + field_60], edx          # 004a7006
    mov ecx, dword ptr [ebp - local_4]           # 004a7009
    mov edx, dword ptr [ecx + field_1be]         # 004a700c
    add edx, dword ptr [0x583186]                # 004a7012
    mov eax, dword ptr [ebp - local_10]          # 004a7018
    mov dword ptr [eax + field_68], edx          # 004a701b
    mov ecx, dword ptr [ebp - local_4]           # 004a701e
    mov edx, dword ptr [ecx + field_1da]         # 004a7021
    add edx, dword ptr [0x58318a]                # 004a7027
    mov eax, dword ptr [ebp - local_10]          # 004a702d
    mov dword ptr [eax + field_74], edx          # 004a7030
    mov ecx, dword ptr [ebp - local_4]           # 004a7033
    mov edx, dword ptr [ecx + field_1e2]         # 004a7036
    add edx, dword ptr [0x58318a]                # 004a703c
    mov eax, dword ptr [ebp - local_10]          # 004a7042
    mov dword ptr [eax + field_7c], edx          # 004a7045
    mov ecx, dword ptr [ebp - local_4]           # 004a7048
    mov edx, dword ptr [ecx + field_1d6]         # 004a704b
    add edx, dword ptr [0x583186]                # 004a7051
    mov eax, dword ptr [ebp - local_10]          # 004a7057
    mov dword ptr [eax + field_70], edx          # 004a705a
    mov ecx, dword ptr [ebp - local_4]           # 004a705d
    mov edx, dword ptr [ecx + field_1de]         # 004a7060
    add edx, dword ptr [0x583186]                # 004a7066
    mov eax, dword ptr [ebp - local_10]          # 004a706c
    mov dword ptr [eax + field_78], edx          # 004a706f
    mov ecx, dword ptr [ebp - local_10]          # 004a7072
    mov dword ptr [ecx + field_21], 0x0          # 004a7075
    mov edx, dword ptr [ebp - local_10]          # 004a707c
    movsx eax, word ptr [edx + field_1e]         # 004a707f
    imul eax, eax, 0x8d                          # 004a7083
    mov dword ptr [eax + 0x5bb632], 0x1          # 004a7089
    jmp.d32 L_004a7968                           # 004a7093
L_004a7098:
    # block 0x004a7098: entered by je at 0x004a6c9c, 5 instruction(s), ends with ja to 0x004a76d7 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a7098
    mov edx, dword ptr [ecx + field_21]          # 004a709b
    mov dword ptr [ebp - local_18], edx          # 004a709e
    cmp dword ptr [ebp - local_18], 0x8          # 004a70a1
    ja.d32 L_004a76d7                            # 004a70a5
    # block 0x004a70ab: entered by fall-through of ja at 0x004a70a5, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4a7970]
    mov eax, dword ptr [ebp - local_18]          # 004a70ab
    jmp dword ptr [4*eax + SWTAB_004a7970_VA]    # 004a70ae
L_004a70b5:
    # block 0x004a70b5: entered by switch case, 3 instruction(s), calls FUN_004a6bde, ends with forward jump to 0x004a76d7
    mov ecx, dword ptr [ebp - local_10]          # 004a70b5
    call FUN_004a6bde                            # 004a70b8
    jmp.d32 L_004a76d7                           # 004a70bd
L_004a70c2:
    # block 0x004a70c2: entered by switch case, 4 instruction(s), ends with jle to 0x004a7135 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a70c2
    movsx edx, word ptr [ecx + field_80]         # 004a70c5
    cmp edx, 0x2                                 # 004a70cc
    jle.d8 L_004a7135                            # 004a70cf
    # block 0x004a70d1: entered by fall-through of jle at 0x004a70cf, 11 instruction(s), ends with jl to 0x004a711f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a70d1
    mov cx, word ptr [eax + field_2e]            # 004a70d4
    add cx, 0x1                                  # 004a70d8
    mov edx, dword ptr [ebp - local_10]          # 004a70dc
    mov word ptr [edx + field_2e], cx            # 004a70df
    mov eax, dword ptr [ebp - local_10]          # 004a70e3
    movsx ecx, word ptr [eax + field_2e]         # 004a70e6
    mov edx, dword ptr [ebp - local_4]           # 004a70ea
    movsx eax, word ptr [edx + field_63]         # 004a70ed
    {load} cmp ecx, eax                          # 004a70f1
    jl.d8 L_004a711f                             # 004a70f3
    # block 0x004a70f5: entered by fall-through of jl at 0x004a70f3, 5 instruction(s), ends with jne to 0x004a710d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a70f5
    {load} xor edx, edx                          # 004a70f8
    mov dl, byte ptr [ecx + field_65]            # 004a70fa
    cmp edx, 0x1                                 # 004a70fd
    jne.d8 L_004a710d                            # 004a7100
    # block 0x004a7102: entered by fall-through of jne at 0x004a7100, 3 instruction(s), ends with forward jump to 0x004a711f
    mov eax, dword ptr [ebp - local_10]          # 004a7102
    mov word ptr [eax + field_2e], 0x0           # 004a7105
    jmp.d8 L_004a711f                            # 004a710b
L_004a710d:
    # block 0x004a710d: entered by jne at 0x004a7100, 5 instruction(s), falls into the block at 0x004a711f
    mov ecx, dword ptr [ebp - local_10]          # 004a710d
    mov dx, word ptr [ecx + field_2e]            # 004a7110
    sub dx, 0x1                                  # 004a7114
    mov eax, dword ptr [ebp - local_10]          # 004a7118
    mov word ptr [eax + field_2e], dx            # 004a711b
L_004a711f:
    # block 0x004a711f: entered by jl at 0x004a70f3; jmp at 0x004a710b, 5 instruction(s), ends with forward jump to 0x004a76d7
    mov ecx, dword ptr [ebp - local_10]          # 004a711f
    mov dword ptr [ecx + field_21], 0x0          # 004a7122
    mov edx, dword ptr [ebp - local_10]          # 004a7129
    mov byte ptr [edx + field_20], 0x0           # 004a712c
    jmp.d32 L_004a76d7                           # 004a7130
L_004a7135:
    # block 0x004a7135: entered by jle at 0x004a70cf, 7 instruction(s), ends with je to 0x004a716d (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7135
    mov byte ptr [eax + field_20], 0x1           # 004a7138
    mov ecx, dword ptr [ebp - local_10]          # 004a713c
    {load} xor edx, edx                          # 004a713f
    mov dl, byte ptr [ecx + field_2d]            # 004a7141
    test edx, edx                                # 004a7144
    je.d8 L_004a716d                             # 004a7146
    # block 0x004a7148: entered by fall-through of je at 0x004a7146, 8 instruction(s), ends with jl to 0x004a716b (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7148
    movsx ecx, word ptr [eax + field_2e]         # 004a714b
    add ecx, 0x1                                 # 004a714f
    mov dword ptr [ebp - local_8], ecx           # 004a7152
    mov edx, dword ptr [ebp - local_4]           # 004a7155
    movsx eax, word ptr [edx + field_63]         # 004a7158
    cmp dword ptr [ebp - local_8], eax           # 004a715c
    jl.d8 L_004a716b                             # 004a715f
    # block 0x004a7161: entered by fall-through of jl at 0x004a715f, 3 instruction(s), falls into the block at 0x004a716b
    mov ecx, dword ptr [ebp - local_10]          # 004a7161
    movsx edx, word ptr [ecx + field_2e]         # 004a7164
    mov dword ptr [ebp - local_8], edx           # 004a7168
L_004a716b:
    # block 0x004a716b: entered by jl at 0x004a715f, 1 instruction(s), ends with forward jump to 0x004a71c1
    jmp.d8 L_004a71c1                            # 004a716b
L_004a716d:
    # block 0x004a716d: entered by je at 0x004a7146, 9 instruction(s), ends with jge to 0x004a7192 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a716d
    movsx ecx, word ptr [eax + field_2e]         # 004a7170
    mov edx, dword ptr [ebp - local_4]           # 004a7174
    movsx eax, word ptr [edx + field_63]         # 004a7177
    cdq                                          # 004a717b
    {load} sub eax, edx                          # 004a717c
    sar eax                                      # 004a717e
    {load} cmp ecx, eax                          # 004a7180
    jge.d8 L_004a7192                            # 004a7182
    # block 0x004a7184: entered by fall-through of jge at 0x004a7182, 5 instruction(s), ends with forward jump to 0x004a719e
    mov eax, dword ptr [ebp - local_10]          # 004a7184
    mov ecx, dword ptr [ebp - local_10]          # 004a7187
    mov edx, dword ptr [ecx + field_38]          # 004a718a
    mov dword ptr [eax + field_30], edx          # 004a718d
    jmp.d8 L_004a719e                            # 004a7190
L_004a7192:
    # block 0x004a7192: entered by jge at 0x004a7182, 4 instruction(s), falls into the block at 0x004a719e
    mov eax, dword ptr [ebp - local_10]          # 004a7192
    mov ecx, dword ptr [ebp - local_10]          # 004a7195
    mov edx, dword ptr [ecx + field_34]          # 004a7198
    mov dword ptr [eax + field_30], edx          # 004a719b
L_004a719e:
    # block 0x004a719e: entered by jmp at 0x004a7190, 11 instruction(s), falls into the block at 0x004a71c1
    mov eax, dword ptr [ebp - local_4]           # 004a719e
    movsx ecx, word ptr [eax + field_63]         # 004a71a1
    shl ecx                                      # 004a71a5
    mov edx, dword ptr [ebp - local_10]          # 004a71a7
    movsx eax, word ptr [edx + field_2e]         # 004a71aa
    shl eax                                      # 004a71ae
    {load} sub ecx, eax                          # 004a71b0
    mov edx, dword ptr [ebp - local_10]          # 004a71b2
    movsx eax, word ptr [edx + field_80]         # 004a71b5
    {load} sub ecx, eax                          # 004a71bc
    mov dword ptr [ebp - local_8], ecx           # 004a71be
L_004a71c1:
    # block 0x004a71c1: entered by jmp at 0x004a716b, 18 instruction(s), ends with jne to 0x004a7203 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a71c1
    shl ecx, 0x4                                 # 004a71c4
    mov edx, dword ptr [ebp - local_4]           # 004a71c7
    lea eax, [edx + ecx + field_76]              # 004a71ca
    mov ecx, dword ptr [ebp - local_10]          # 004a71ce
    add ecx, 0x40                                # 004a71d1
    mov edx, dword ptr [eax]                     # 004a71d4
    mov dword ptr [ecx], edx                     # 004a71d6
    mov edx, dword ptr [eax + field_4]           # 004a71d8
    mov dword ptr [ecx + field_4], edx           # 004a71db
    mov edx, dword ptr [eax + field_8]           # 004a71de
    mov dword ptr [ecx + field_8], edx           # 004a71e1
    mov eax, dword ptr [eax + field_c]           # 004a71e4
    mov dword ptr [ecx + field_c], eax           # 004a71e7
    mov ecx, dword ptr [ebp - local_10]          # 004a71ea
    movsx edx, word ptr [ecx + field_80]         # 004a71ed
    cmp edx, 0x1                                 # 004a71f4
    jne.d8 L_004a7203                            # 004a71f7
    # block 0x004a71f9: entered by fall-through of jne at 0x004a71f7, 2 instruction(s), falls into the block at 0x004a7203
    mov eax, dword ptr [ebp - local_10]          # 004a71f9
    mov dword ptr [eax + field_21], 0x6          # 004a71fc
L_004a7203:
    # block 0x004a7203: entered by jne at 0x004a71f7, 6 instruction(s), ends with forward jump to 0x004a76d7
    mov ecx, dword ptr [ebp - local_10]          # 004a7203
    mov dx, word ptr [ecx + field_80]            # 004a7206
    add dx, 0x1                                  # 004a720d
    mov eax, dword ptr [ebp - local_10]          # 004a7211
    mov word ptr [eax + field_80], dx            # 004a7214
    jmp.d32 L_004a76d7                           # 004a721b
L_004a7220:
    # block 0x004a7220: entered by switch case, 4 instruction(s), ends with jle to 0x004a72a7 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a7220
    movsx edx, word ptr [ecx + field_80]         # 004a7223
    cmp edx, 0x2                                 # 004a722a
    jle.d8 L_004a72a7                            # 004a722d
    # block 0x004a722f: entered by fall-through of jle at 0x004a722d, 5 instruction(s), ends with jne to 0x004a7266 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a722f
    {load} xor ecx, ecx                          # 004a7232
    mov cl, byte ptr [eax + field_65]            # 004a7234
    test ecx, ecx                                # 004a7237
    jne.d8 L_004a7266                            # 004a7239
    # block 0x004a723b: entered by fall-through of jne at 0x004a7239, 10 instruction(s), ends with jge to 0x004a7264 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a723b
    mov ax, word ptr [edx + field_2e]            # 004a723e
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004a7242
    mov ecx, dword ptr [ebp - local_10]          # 004a7246
    mov word ptr [ecx + field_2e], ax            # 004a7249
    mov edx, dword ptr [ebp - local_10]          # 004a724d
    movsx eax, word ptr [edx + field_2e]         # 004a7250
    sub eax, 0x1                                 # 004a7254
    test eax, eax                                # 004a7257
    jge.d8 L_004a7264                            # 004a7259
    # block 0x004a725b: entered by fall-through of jge at 0x004a7259, 2 instruction(s), falls into the block at 0x004a7264
    mov ecx, dword ptr [ebp - local_10]          # 004a725b
    mov word ptr [ecx + field_2e], 0x0           # 004a725e
L_004a7264:
    # block 0x004a7264: entered by jge at 0x004a7259, 1 instruction(s), ends with forward jump to 0x004a7291
    jmp.d8 L_004a7291                            # 004a7264
L_004a7266:
    # block 0x004a7266: entered by jne at 0x004a7239, 4 instruction(s), ends with jne to 0x004a727f (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a7266
    movsx eax, word ptr [edx + field_2e]         # 004a7269
    test eax, eax                                # 004a726d
    jne.d8 L_004a727f                            # 004a726f
    # block 0x004a7271: entered by fall-through of jne at 0x004a726f, 4 instruction(s), falls into the block at 0x004a727f
    mov ecx, dword ptr [ebp - local_10]          # 004a7271
    mov edx, dword ptr [ebp - local_4]           # 004a7274
    mov ax, word ptr [edx + field_63]            # 004a7277
    mov word ptr [ecx + field_2e], ax            # 004a727b
L_004a727f:
    # block 0x004a727f: entered by jne at 0x004a726f, 5 instruction(s), falls into the block at 0x004a7291
    mov ecx, dword ptr [ebp - local_10]          # 004a727f
    mov dx, word ptr [ecx + field_2e]            # 004a7282
    sub dx, 0x1                                  # 004a7286
    mov eax, dword ptr [ebp - local_10]          # 004a728a
    mov word ptr [eax + field_2e], dx            # 004a728d
L_004a7291:
    # block 0x004a7291: entered by jmp at 0x004a7264, 5 instruction(s), ends with forward jump to 0x004a76d7
    mov ecx, dword ptr [ebp - local_10]          # 004a7291
    mov dword ptr [ecx + field_21], 0x0          # 004a7294
    mov edx, dword ptr [ebp - local_10]          # 004a729b
    mov byte ptr [edx + field_20], 0x0           # 004a729e
    jmp.d32 L_004a76d7                           # 004a72a2
L_004a72a7:
    # block 0x004a72a7: entered by jle at 0x004a722d, 7 instruction(s), ends with je to 0x004a72d9 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a72a7
    mov byte ptr [eax + field_20], 0x1           # 004a72aa
    mov ecx, dword ptr [ebp - local_10]          # 004a72ae
    {load} xor edx, edx                          # 004a72b1
    mov dl, byte ptr [ecx + field_2d]            # 004a72b3
    test edx, edx                                # 004a72b6
    je.d8 L_004a72d9                             # 004a72b8
    # block 0x004a72ba: entered by fall-through of je at 0x004a72b8, 6 instruction(s), ends with jge to 0x004a72d4 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a72ba
    movsx ecx, word ptr [eax + field_2e]         # 004a72bd
    sub ecx, 0x1                                 # 004a72c1
    mov dword ptr [ebp - local_8], ecx           # 004a72c4
    cmp dword ptr [ebp - local_8], 0x0           # 004a72c7
    jge.d8 L_004a72d4                            # 004a72cb
    # block 0x004a72cd: entered by fall-through of jge at 0x004a72cb, 1 instruction(s), falls into the block at 0x004a72d4
    mov dword ptr [ebp - local_8], 0x0           # 004a72cd
L_004a72d4:
    # block 0x004a72d4: entered by jge at 0x004a72cb, 1 instruction(s), ends with forward jump to 0x004a73c4
    jmp.d32 L_004a73c4                           # 004a72d4
L_004a72d9:
    # block 0x004a72d9: entered by je at 0x004a72b8, 4 instruction(s), ends with je to 0x004a72fb (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a72d9
    movsx eax, word ptr [edx + field_2e]         # 004a72dc
    test eax, eax                                # 004a72e0
    je.d8 L_004a72fb                             # 004a72e2
    # block 0x004a72e4: entered by fall-through of je at 0x004a72e2, 9 instruction(s), ends with jle to 0x004a7340 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a72e4
    movsx ecx, word ptr [ecx + field_2e]         # 004a72e7
    mov edx, dword ptr [ebp - local_4]           # 004a72eb
    movsx eax, word ptr [edx + field_63]         # 004a72ee
    cdq                                          # 004a72f2
    {load} sub eax, edx                          # 004a72f3
    sar eax                                      # 004a72f5
    {load} cmp ecx, eax                          # 004a72f7
    jle.d8 L_004a7340                            # 004a72f9
L_004a72fb:
    # block 0x004a72fb: entered by je at 0x004a72e2; fall-through of jle at 0x004a72f9, 10 instruction(s), ends with jne to 0x004a7332 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a72fb
    movsx ecx, word ptr [eax + field_2e]         # 004a72fe
    mov edx, dword ptr [ebp - local_4]           # 004a7302
    movsx eax, word ptr [edx + field_63]         # 004a7305
    cdq                                          # 004a7309
    {load} sub eax, edx                          # 004a730a
    sar eax                                      # 004a730c
    add eax, 0x1                                 # 004a730e
    {load} cmp ecx, eax                          # 004a7311
    jne.d8 L_004a7332                            # 004a7313
    # block 0x004a7315: entered by fall-through of jne at 0x004a7313, 4 instruction(s), ends with jne to 0x004a7332 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7315
    movsx ecx, word ptr [eax + field_80]         # 004a7318
    cmp ecx, 0x2                                 # 004a731f
    jne.d8 L_004a7332                            # 004a7322
    # block 0x004a7324: entered by fall-through of jne at 0x004a7322, 5 instruction(s), ends with forward jump to 0x004a733e
    mov edx, dword ptr [ebp - local_10]          # 004a7324
    mov eax, dword ptr [ebp - local_10]          # 004a7327
    mov ecx, dword ptr [eax + field_38]          # 004a732a
    mov dword ptr [edx + field_30], ecx          # 004a732d
    jmp.d8 L_004a733e                            # 004a7330
L_004a7332:
    # block 0x004a7332: entered by jne at 0x004a7313; jne at 0x004a7322, 4 instruction(s), falls into the block at 0x004a733e
    mov edx, dword ptr [ebp - local_10]          # 004a7332
    mov eax, dword ptr [ebp - local_10]          # 004a7335
    mov ecx, dword ptr [eax + field_34]          # 004a7338
    mov dword ptr [edx + field_30], ecx          # 004a733b
L_004a733e:
    # block 0x004a733e: entered by jmp at 0x004a7330, 1 instruction(s), ends with forward jump to 0x004a7375
    jmp.d8 L_004a7375                            # 004a733e
L_004a7340:
    # block 0x004a7340: entered by jle at 0x004a72f9, 4 instruction(s), ends with jne to 0x004a7369 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a7340
    movsx eax, word ptr [edx + field_2e]         # 004a7343
    cmp eax, 0x1                                 # 004a7347
    jne.d8 L_004a7369                            # 004a734a
    # block 0x004a734c: entered by fall-through of jne at 0x004a734a, 4 instruction(s), ends with jne to 0x004a7369 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a734c
    movsx edx, word ptr [ecx + field_80]         # 004a734f
    cmp edx, 0x2                                 # 004a7356
    jne.d8 L_004a7369                            # 004a7359
    # block 0x004a735b: entered by fall-through of jne at 0x004a7359, 5 instruction(s), ends with forward jump to 0x004a7375
    mov eax, dword ptr [ebp - local_10]          # 004a735b
    mov ecx, dword ptr [ebp - local_10]          # 004a735e
    mov edx, dword ptr [ecx + field_34]          # 004a7361
    mov dword ptr [eax + field_30], edx          # 004a7364
    jmp.d8 L_004a7375                            # 004a7367
L_004a7369:
    # block 0x004a7369: entered by jne at 0x004a734a; jne at 0x004a7359, 4 instruction(s), falls into the block at 0x004a7375
    mov eax, dword ptr [ebp - local_10]          # 004a7369
    mov ecx, dword ptr [ebp - local_10]          # 004a736c
    mov edx, dword ptr [ecx + field_38]          # 004a736f
    mov dword ptr [eax + field_30], edx          # 004a7372
L_004a7375:
    # block 0x004a7375: entered by jmp at 0x004a733e; jmp at 0x004a7367, 14 instruction(s), ends with jne to 0x004a73a9 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7375
    movsx ecx, word ptr [eax + field_2e]         # 004a7378
    shl ecx                                      # 004a737c
    mov edx, 0x14                                # 004a737e
    {load} sub edx, ecx                          # 004a7383
    mov eax, dword ptr [ebp - local_10]          # 004a7385
    movsx ecx, word ptr [eax + field_80]         # 004a7388
    {load} add edx, ecx                          # 004a738f
    mov dword ptr [ebp - local_8], edx           # 004a7391
    mov edx, dword ptr [ebp - local_4]           # 004a7394
    movsx eax, word ptr [edx + field_63]         # 004a7397
    shl eax                                      # 004a739b
    cmp dword ptr [ebp - local_8], eax           # 004a739d
    jne.d8 L_004a73a9                            # 004a73a0
    # block 0x004a73a2: entered by fall-through of jne at 0x004a73a0, 1 instruction(s), falls into the block at 0x004a73a9
    mov dword ptr [ebp - local_8], 0x0           # 004a73a2
L_004a73a9:
    # block 0x004a73a9: entered by jne at 0x004a73a0, 5 instruction(s), ends with jle to 0x004a73c4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a73a9
    movsx edx, word ptr [ecx + field_63]         # 004a73ac
    shl edx                                      # 004a73b0
    cmp dword ptr [ebp - local_8], edx           # 004a73b2
    jle.d8 L_004a73c4                            # 004a73b5
    # block 0x004a73b7: entered by fall-through of jle at 0x004a73b5, 3 instruction(s), falls into the block at 0x004a73c4
    mov eax, dword ptr [ebp - local_10]          # 004a73b7
    movsx ecx, word ptr [eax + field_80]         # 004a73ba
    mov dword ptr [ebp - local_8], ecx           # 004a73c1
L_004a73c4:
    # block 0x004a73c4: entered by jmp at 0x004a72d4; jle at 0x004a73b5, 18 instruction(s), ends with jne to 0x004a7406 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004a73c4
    shl edx, 0x4                                 # 004a73c7
    mov eax, dword ptr [ebp - local_4]           # 004a73ca
    lea ecx, [eax + edx + field_76]              # 004a73cd
    mov edx, dword ptr [ebp - local_10]          # 004a73d1
    add edx, 0x40                                # 004a73d4
    mov eax, dword ptr [ecx]                     # 004a73d7
    mov dword ptr [edx], eax                     # 004a73d9
    mov eax, dword ptr [ecx + field_4]           # 004a73db
    mov dword ptr [edx + field_4], eax           # 004a73de
    mov eax, dword ptr [ecx + field_8]           # 004a73e1
    mov dword ptr [edx + field_8], eax           # 004a73e4
    mov ecx, dword ptr [ecx + field_c]           # 004a73e7
    mov dword ptr [edx + field_c], ecx           # 004a73ea
    mov edx, dword ptr [ebp - local_10]          # 004a73ed
    movsx eax, word ptr [edx + field_80]         # 004a73f0
    cmp eax, 0x1                                 # 004a73f7
    jne.d8 L_004a7406                            # 004a73fa
    # block 0x004a73fc: entered by fall-through of jne at 0x004a73fa, 2 instruction(s), falls into the block at 0x004a7406
    mov ecx, dword ptr [ebp - local_10]          # 004a73fc
    mov dword ptr [ecx + field_21], 0x6          # 004a73ff
L_004a7406:
    # block 0x004a7406: entered by jne at 0x004a73fa, 6 instruction(s), ends with forward jump to 0x004a76d7
    mov edx, dword ptr [ebp - local_10]          # 004a7406
    mov ax, word ptr [edx + field_80]            # 004a7409
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a7410
    mov ecx, dword ptr [ebp - local_10]          # 004a7414
    mov word ptr [ecx + field_80], ax            # 004a7417
    jmp.d32 L_004a76d7                           # 004a741e
L_004a7423:
    # block 0x004a7423: entered by switch case, 7 instruction(s), ends with jne to 0x004a7449 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a7423
    mov byte ptr [edx + field_20], 0x1           # 004a7426
    mov eax, dword ptr [ebp - local_10]          # 004a742a
    {load} xor ecx, ecx                          # 004a742d
    mov cl, byte ptr [eax + field_29]            # 004a742f
    test ecx, ecx                                # 004a7432
    jne.d8 L_004a7449                            # 004a7434
    # block 0x004a7436: entered by fall-through of jne at 0x004a7434, 5 instruction(s), ends with forward jump to 0x004a745a
    mov edx, dword ptr [ebp - local_10]          # 004a7436
    mov dword ptr [edx + field_21], 0x6          # 004a7439
    mov eax, dword ptr [ebp - local_10]          # 004a7440
    mov byte ptr [eax + field_29], 0x1           # 004a7443
    jmp.d8 L_004a745a                            # 004a7447
L_004a7449:
    # block 0x004a7449: entered by jne at 0x004a7434, 4 instruction(s), falls into the block at 0x004a745a
    mov ecx, dword ptr [ebp - local_10]          # 004a7449
    mov dword ptr [ecx + field_21], 0x0          # 004a744c
    mov edx, dword ptr [ebp - local_10]          # 004a7453
    mov byte ptr [edx + field_29], 0x0           # 004a7456
L_004a745a:
    # block 0x004a745a: entered by jmp at 0x004a7447, 1 instruction(s), ends with forward jump to 0x004a76d7
    jmp.d32 L_004a76d7                           # 004a745a
L_004a745f:
    # block 0x004a745f: entered by switch case, 7 instruction(s), ends with jne to 0x004a74ac (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a745f
    mov byte ptr [eax + field_20], 0x1           # 004a7462
    mov ecx, dword ptr [ebp - local_10]          # 004a7466
    {load} xor edx, edx                          # 004a7469
    mov dl, byte ptr [ecx + field_29]            # 004a746b
    cmp edx, 0x1                                 # 004a746e
    jne.d8 L_004a74ac                            # 004a7471
    # block 0x004a7473: entered by fall-through of jne at 0x004a7471, 4 instruction(s), ends with jne to 0x004a74ac (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7473
    movsx ecx, word ptr [eax + field_2a]         # 004a7476
    test ecx, ecx                                # 004a747a
    jne.d8 L_004a74ac                            # 004a747c
    # block 0x004a747e: entered by fall-through of jne at 0x004a747c, 7 instruction(s), ends with je to 0x004a74ac (forward)
    mov edi, 0x550a20                            # 004a747e
    mov esi, dword ptr [ebp - local_4]           # 004a7483
    add esi, 0x331                               # 004a7486
    mov ecx, 0x9                                 # 004a748c
    {load} xor edx, edx                          # 004a7491
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a7493
    je.d8 L_004a74ac                             # 004a7495
    # block 0x004a7497: entered by fall-through of je at 0x004a7495, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a74ac
    mov eax, dword ptr [ebp - local_4]           # 004a7497
    mov cx, word ptr [eax + field_352]           # 004a749a
    push ecx                                     # 004a74a1
    mov ecx, 0x5c3a67                            # 004a74a2
    call FUN_004fb2e3                            # 004a74a7
L_004a74ac:
    # block 0x004a74ac: entered by jne at 0x004a7471; jne at 0x004a747c; je at 0x004a7495, 5 instruction(s), ends with jne to 0x004a74ce (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a74ac
    {load} xor eax, eax                          # 004a74af
    mov al, byte ptr [edx + field_29]            # 004a74b1
    test eax, eax                                # 004a74b4
    jne.d8 L_004a74ce                            # 004a74b6
    # block 0x004a74b8: entered by fall-through of jne at 0x004a74b6, 5 instruction(s), ends with forward jump to 0x004a75b9
    mov ecx, dword ptr [ebp - local_10]          # 004a74b8
    mov dword ptr [ecx + field_21], 0x6          # 004a74bb
    mov edx, dword ptr [ebp - local_10]          # 004a74c2
    mov byte ptr [edx + field_29], 0x1           # 004a74c5
    jmp.d32 L_004a75b9                           # 004a74c9
L_004a74ce:
    # block 0x004a74ce: entered by jne at 0x004a74b6, 5 instruction(s), ends with je to 0x004a754d (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a74ce
    {load} xor ecx, ecx                          # 004a74d1
    mov cl, byte ptr [eax + field_2c]            # 004a74d3
    test ecx, ecx                                # 004a74d6
    je.d8 L_004a754d                             # 004a74d8
    # block 0x004a74da: entered by fall-through of je at 0x004a74d8, 8 instruction(s), ends with jge to 0x004a754d (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a74da
    movsx eax, word ptr [edx + field_2a]         # 004a74dd
    mov ecx, dword ptr [ebp - local_4]           # 004a74e1
    movsx edx, word ptr [ecx + field_296]        # 004a74e4
    shl edx                                      # 004a74eb
    imul edx, edx, 0xa                           # 004a74ed
    {load} cmp eax, edx                          # 004a74f0
    jge.d8 L_004a754d                            # 004a74f2
    # block 0x004a74f4: entered by fall-through of jge at 0x004a74f2, 28 instruction(s), ends with forward jump to 0x004a75b9
    mov eax, dword ptr [ebp - local_10]          # 004a74f4
    mov byte ptr [eax + field_20], 0x1           # 004a74f7
    mov ecx, dword ptr [ebp - local_10]          # 004a74fb
    movsx eax, word ptr [ecx + field_2a]         # 004a74fe
    cdq                                          # 004a7502
    mov ecx, 0xa                                 # 004a7503
    idiv ecx                                     # 004a7508
    mov dword ptr [ebp - local_8], edx           # 004a750a
    mov edx, dword ptr [ebp - local_8]           # 004a750d
    shl edx, 0x4                                 # 004a7510
    mov eax, dword ptr [ebp - local_4]           # 004a7513
    lea ecx, [eax + edx + field_1f6]             # 004a7516
    mov edx, dword ptr [ebp - local_10]          # 004a751d
    add edx, 0x40                                # 004a7520
    mov eax, dword ptr [ecx]                     # 004a7523
    mov dword ptr [edx], eax                     # 004a7525
    mov eax, dword ptr [ecx + field_4]           # 004a7527
    mov dword ptr [edx + field_4], eax           # 004a752a
    mov eax, dword ptr [ecx + field_8]           # 004a752d
    mov dword ptr [edx + field_8], eax           # 004a7530
    mov ecx, dword ptr [ecx + field_c]           # 004a7533
    mov dword ptr [edx + field_c], ecx           # 004a7536
    mov edx, dword ptr [ebp - local_10]          # 004a7539
    mov ax, word ptr [edx + field_2a]            # 004a753c
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a7540
    mov ecx, dword ptr [ebp - local_10]          # 004a7544
    mov word ptr [ecx + field_2a], ax            # 004a7547
    jmp.d8 L_004a75b9                            # 004a754b
L_004a754d:
    # block 0x004a754d: entered by je at 0x004a74d8; jge at 0x004a74f2, 32 instruction(s), falls into the block at 0x004a75b9
    mov edx, dword ptr [ebp - local_10]          # 004a754d
    mov byte ptr [edx + field_29], 0x0           # 004a7550
    mov eax, dword ptr [ebp - local_10]          # 004a7554
    mov byte ptr [eax + field_20], 0x1           # 004a7557
    mov ecx, dword ptr [ebp - local_10]          # 004a755b
    mov word ptr [ecx + field_2e], 0x0           # 004a755e
    mov edx, dword ptr [ebp - local_10]          # 004a7564
    mov word ptr [edx + field_2a], 0x0           # 004a7567
    {load} xor eax, eax                          # 004a756d
    mov ecx, dword ptr [ebp - local_10]          # 004a756f
    add ecx, 0x94                                # 004a7572
    mov dword ptr [ecx], eax                     # 004a7578
    mov dword ptr [ecx + field_4], eax           # 004a757a
    mov word ptr [ecx + field_8], ax             # 004a757d
    mov edx, dword ptr [ebp - local_10]          # 004a7581
    mov eax, dword ptr [ebp - local_10]          # 004a7584
    mov ecx, dword ptr [eax + field_34]          # 004a7587
    mov dword ptr [edx + field_30], ecx          # 004a758a
    mov edx, dword ptr [ebp - local_4]           # 004a758d
    add edx, 0x76                                # 004a7590
    mov eax, dword ptr [ebp - local_10]          # 004a7593
    add eax, 0x40                                # 004a7596
    mov ecx, dword ptr [edx]                     # 004a7599
    mov dword ptr [eax], ecx                     # 004a759b
    mov ecx, dword ptr [edx + field_4]           # 004a759d
    mov dword ptr [eax + field_4], ecx           # 004a75a0
    mov ecx, dword ptr [edx + field_8]           # 004a75a3
    mov dword ptr [eax + field_8], ecx           # 004a75a6
    mov edx, dword ptr [edx + field_c]           # 004a75a9
    mov dword ptr [eax + field_c], edx           # 004a75ac
    mov eax, dword ptr [ebp - local_10]          # 004a75af
    mov dword ptr [eax + field_21], 0x0          # 004a75b2
L_004a75b9:
    # block 0x004a75b9: entered by jmp at 0x004a74c9; jmp at 0x004a754b, 1 instruction(s), ends with forward jump to 0x004a76d7
    jmp.d32 L_004a76d7                           # 004a75b9
L_004a75be:
    # block 0x004a75be: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004a75e2 (forward)
    call dword ptr [0x52a23c]                    # 004a75be
    mov ecx, dword ptr [ebp - local_10]          # 004a75c4
    cmp eax, dword ptr [ecx + field_90]          # 004a75c7
    jb.d8 L_004a75e2                             # 004a75cd
    # block 0x004a75cf: entered by fall-through of jb at 0x004a75cd, 6 instruction(s), falls into the block at 0x004a75e2
    mov edx, dword ptr [ebp - local_10]          # 004a75cf
    mov eax, dword ptr [ebp - local_10]          # 004a75d2
    mov ecx, dword ptr [eax + field_25]          # 004a75d5
    mov dword ptr [edx + field_21], ecx          # 004a75d8
    mov edx, dword ptr [ebp - local_10]          # 004a75db
    mov byte ptr [edx + field_20], 0x1           # 004a75de
L_004a75e2:
    # block 0x004a75e2: entered by jb at 0x004a75cd, 1 instruction(s), ends with forward jump to 0x004a76d7
    jmp.d32 L_004a76d7                           # 004a75e2
L_004a75e7:
    # block 0x004a75e7: entered by switch case, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004a76d7
    call dword ptr [0x52a23c]                    # 004a75e7
    mov ecx, dword ptr [ebp - local_4]           # 004a75ed
    movsx edx, word ptr [ecx + field_37b]        # 004a75f0
    imul edx, edx, 0x3e8                         # 004a75f7
    {load} add eax, edx                          # 004a75fd
    mov ecx, dword ptr [ebp - local_10]          # 004a75ff
    mov dword ptr [ecx + field_8c], eax          # 004a7602
    mov edx, dword ptr [ebp - local_10]          # 004a7608
    mov dword ptr [edx + field_21], 0x7          # 004a760b
    jmp.d32 L_004a76d7                           # 004a7612
L_004a7617:
    # block 0x004a7617: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004a768c (forward)
    call dword ptr [0x52a23c]                    # 004a7617
    mov ecx, dword ptr [ebp - local_10]          # 004a761d
    cmp eax, dword ptr [ecx + field_8c]          # 004a7620
    jb.d8 L_004a768c                             # 004a7626
    # block 0x004a7628: entered by fall-through of jb at 0x004a7626, 7 instruction(s), ends with je to 0x004a7675 (forward)
    mov edi, 0x550a2c                            # 004a7628
    mov esi, dword ptr [ebp - local_4]           # 004a762d
    add esi, 0x37d                               # 004a7630
    mov ecx, 0x9                                 # 004a7636
    {load} xor edx, edx                          # 004a763b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a763d
    je.d8 L_004a7675                             # 004a763f
    # block 0x004a7641: entered by fall-through of je at 0x004a763f, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a768c
    mov eax, dword ptr [ebp - local_4]           # 004a7641
    add eax, 0x37d                               # 004a7644
    push eax                                     # 004a7649
    mov ecx, 0x5c3a67                            # 004a764a
    call FUN_004fb77a                            # 004a764f
    mov ecx, dword ptr [ebp - local_4]           # 004a7654
    mov dx, word ptr [ecx + field_39e]           # 004a7657
    push edx                                     # 004a765e
    mov ecx, 0x5c3a67                            # 004a765f
    call FUN_004fb2e3                            # 004a7664
    mov eax, dword ptr [ebp - local_10]          # 004a7669
    mov dword ptr [eax + field_21], 0x8          # 004a766c
    jmp.d8 L_004a768c                            # 004a7673
L_004a7675:
    # block 0x004a7675: entered by je at 0x004a763f, 4 instruction(s), falls into the block at 0x004a768c
    mov ecx, dword ptr [ebp - local_10]          # 004a7675
    movsx edx, word ptr [ecx + field_1e]         # 004a7678
    imul edx, edx, 0x8d                          # 004a767c
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a7682
L_004a768c:
    # block 0x004a768c: entered by jb at 0x004a7626; jmp at 0x004a7673, 1 instruction(s), ends with forward jump to 0x004a76d7
    jmp.d8 L_004a76d7                            # 004a768c
L_004a768e:
    # block 0x004a768e: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a76d7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a768e
    movsx ecx, word ptr [eax + field_39e]        # 004a7691
    mov dword ptr [ebp - local_c], ecx           # 004a7698
    mov edx, dword ptr [ebp - local_c]           # 004a769b
    push edx                                     # 004a769e
    mov ecx, 0x5cf1eb                            # 004a769f
    call FUN_004f6334                            # 004a76a4
    test eax, eax                                # 004a76a9
    jne.d8 L_004a76d7                            # 004a76ab
    # block 0x004a76ad: entered by fall-through of jne at 0x004a76ab, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004a76d7
    mov eax, dword ptr [ebp - local_4]           # 004a76ad
    add eax, 0x37d                               # 004a76b0
    push eax                                     # 004a76b5
    mov ecx, 0x5c3a67                            # 004a76b6
    call FUN_004fba69                            # 004a76bb
    mov ecx, dword ptr [ebp - local_10]          # 004a76c0
    movsx edx, word ptr [ecx + field_1e]         # 004a76c3
    imul edx, edx, 0x8d                          # 004a76c7
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a76cd
L_004a76d7:
    # block 0x004a76d7: entered by ja at 0x004a70a5; jmp at 0x004a70bd; jmp at 0x004a7130; jmp at 0x004a721b; more, 1 instruction(s), ends with forward jump to 0x004a7968
    jmp.d32 L_004a7968                           # 004a76d7
L_004a76dc:
    # block 0x004a76dc: entered by je at 0x004a6ca6, 8 instruction(s), ends with je to 0x004a7713 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004a76dc
    mov edi, 0x550a38                            # 004a76e6
    mov esi, dword ptr [ebp - local_4]           # 004a76eb
    add esi, 0x300                               # 004a76ee
    mov ecx, 0x9                                 # 004a76f4
    {load} xor eax, eax                          # 004a76f9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a76fb
    je.d8 L_004a7713                             # 004a76fd
    # block 0x004a76ff: entered by fall-through of je at 0x004a76fd, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a7713
    mov ecx, dword ptr [ebp - local_4]           # 004a76ff
    add ecx, 0x300                               # 004a7702
    push ecx                                     # 004a7708
    mov ecx, 0x5c3a67                            # 004a7709
    call FUN_004fba69                            # 004a770e
L_004a7713:
    # block 0x004a7713: entered by je at 0x004a76fd, 7 instruction(s), ends with je to 0x004a773f (forward)
    mov edi, 0x550a44                            # 004a7713
    mov esi, dword ptr [ebp - local_4]           # 004a7718
    add esi, 0x2cf                               # 004a771b
    mov ecx, 0x9                                 # 004a7721
    {load} xor edx, edx                          # 004a7726
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a7728
    je.d8 L_004a773f                             # 004a772a
    # block 0x004a772c: entered by fall-through of je at 0x004a772a, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a773f
    mov eax, dword ptr [ebp - local_4]           # 004a772c
    add eax, 0x2cf                               # 004a772f
    push eax                                     # 004a7734
    mov ecx, 0x5c3a67                            # 004a7735
    call FUN_004fba69                            # 004a773a
L_004a773f:
    # block 0x004a773f: entered by je at 0x004a772a, 7 instruction(s), ends with je to 0x004a776b (forward)
    mov edi, 0x550a50                            # 004a773f
    mov esi, dword ptr [ebp - local_4]           # 004a7744
    add esi, 0x331                               # 004a7747
    mov ecx, 0x9                                 # 004a774d
    {load} xor edx, edx                          # 004a7752
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a7754
    je.d8 L_004a776b                             # 004a7756
    # block 0x004a7758: entered by fall-through of je at 0x004a7756, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a776b
    mov eax, dword ptr [ebp - local_4]           # 004a7758
    add eax, 0x331                               # 004a775b
    push eax                                     # 004a7760
    mov ecx, 0x5c3a67                            # 004a7761
    call FUN_004fba69                            # 004a7766
L_004a776b:
    # block 0x004a776b: entered by je at 0x004a7756, 5 instruction(s), ends with je to 0x004a7860 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a776b
    {load} xor edx, edx                          # 004a776e
    mov dl, byte ptr [ecx + field_8a]            # 004a7770
    test edx, edx                                # 004a7776
    je.d32 L_004a7860                            # 004a7778
    # block 0x004a777e: entered by fall-through of je at 0x004a7778, 4 instruction(s), ends with je to 0x004a7830 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a777e
    movsx ecx, word ptr [eax + field_3ae]        # 004a7781
    cmp ecx, 0x270f                              # 004a7788
    je.d32 L_004a7830                            # 004a778e
    # block 0x004a7794: entered by fall-through of je at 0x004a778e, 25 instruction(s), ends with jne to 0x004a781c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a7794
    movsx eax, word ptr [edx + field_3ae]        # 004a7797
    mov dword ptr [0x5bb57b], eax                # 004a779e
    mov ecx, dword ptr [ebp - local_4]           # 004a77a3
    mov dx, word ptr [ecx + field_3b0]           # 004a77a6
    mov word ptr [0x5bb599], dx                  # 004a77ad
    mov eax, dword ptr [ebp - local_4]           # 004a77b4
    mov cx, word ptr [eax + field_3b2]           # 004a77b7
    mov word ptr [0x5bb595], cx                  # 004a77be
    mov edx, dword ptr [ebp - local_4]           # 004a77c5
    mov ax, word ptr [edx + field_3b4]           # 004a77c8
    mov word ptr [0x5c39ff], ax                  # 004a77cf
    mov ecx, dword ptr [ebp - local_4]           # 004a77d5
    mov edx, dword ptr [ecx + field_3b6]         # 004a77d8
    mov dword ptr [0x5bb59b], edx                # 004a77de
    mov eax, dword ptr [ebp - local_4]           # 004a77e4
    mov ecx, dword ptr [eax + field_3ba]         # 004a77e7
    mov dword ptr [0x5bb59f], ecx                # 004a77ed
    mov edx, dword ptr [ebp - local_4]           # 004a77f3
    mov eax, dword ptr [edx + field_3be]         # 004a77f6
    mov dword ptr [0x5bb5a3], eax                # 004a77fc
    mov ecx, dword ptr [ebp - local_4]           # 004a7801
    movsx edx, word ptr [ecx + field_3c2]        # 004a7804
    cmp edx, 0x1                                 # 004a780b
    jne.d8 L_004a781c                            # 004a780e
    # block 0x004a7810: entered by fall-through of jne at 0x004a780e, 2 instruction(s), ends with forward jump to 0x004a7826
    mov dword ptr [0x5bb1ca], 0x0                # 004a7810
    jmp.d8 L_004a7826                            # 004a781a
L_004a781c:
    # block 0x004a781c: entered by jne at 0x004a780e, 1 instruction(s), falls into the block at 0x004a7826
    mov dword ptr [0x5bb1ca], 0x1                # 004a781c
L_004a7826:
    # block 0x004a7826: entered by jmp at 0x004a781a, 1 instruction(s), falls into the block at 0x004a7830
    mov dword ptr [0x583999], 0x4                # 004a7826
L_004a7830:
    # block 0x004a7830: entered by je at 0x004a778e, 4 instruction(s), ends with je to 0x004a785b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a7830
    movsx ecx, word ptr [eax + field_3c4]        # 004a7833
    cmp ecx, -0x1                                # 004a783a
    je.d8 L_004a785b                             # 004a783d
    # block 0x004a783f: entered by fall-through of je at 0x004a783d, 6 instruction(s), falls into the block at 0x004a785b
    mov edx, dword ptr [ebp - local_4]           # 004a783f
    {load} xor eax, eax                          # 004a7842
    mov al, byte ptr [edx + field_3c6]           # 004a7844
    mov ecx, dword ptr [ebp - local_4]           # 004a784a
    movsx edx, word ptr [ecx + field_3c4]        # 004a784d
    mov dword ptr [4*edx + 0x585801], eax        # 004a7854
L_004a785b:
    # block 0x004a785b: entered by je at 0x004a783d, 1 instruction(s), ends with forward jump to 0x004a7950
    jmp.d32 L_004a7950                           # 004a785b
L_004a7860:
    # block 0x004a7860: entered by je at 0x004a7778, 5 instruction(s), ends with je to 0x004a7950 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a7860
    {load} xor ecx, ecx                          # 004a7863
    mov cl, byte ptr [eax + field_8b]            # 004a7865
    test ecx, ecx                                # 004a786b
    je.d32 L_004a7950                            # 004a786d
    # block 0x004a7873: entered by fall-through of je at 0x004a786d, 4 instruction(s), ends with je to 0x004a7925 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a7873
    movsx eax, word ptr [edx + field_362]        # 004a7876
    cmp eax, 0x270f                              # 004a787d
    je.d32 L_004a7925                            # 004a7882
    # block 0x004a7888: entered by fall-through of je at 0x004a7882, 25 instruction(s), ends with jne to 0x004a7911 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a7888
    movsx edx, word ptr [ecx + field_362]        # 004a788b
    mov dword ptr [0x5bb57b], edx                # 004a7892
    mov eax, dword ptr [ebp - local_4]           # 004a7898
    mov cx, word ptr [eax + field_364]           # 004a789b
    mov word ptr [0x5bb599], cx                  # 004a78a2
    mov edx, dword ptr [ebp - local_4]           # 004a78a9
    mov ax, word ptr [edx + field_366]           # 004a78ac
    mov word ptr [0x5bb595], ax                  # 004a78b3
    mov ecx, dword ptr [ebp - local_4]           # 004a78b9
    mov dx, word ptr [ecx + field_368]           # 004a78bc
    mov word ptr [0x5c39ff], dx                  # 004a78c3
    mov eax, dword ptr [ebp - local_4]           # 004a78ca
    mov ecx, dword ptr [eax + field_36a]         # 004a78cd
    mov dword ptr [0x5bb59b], ecx                # 004a78d3
    mov edx, dword ptr [ebp - local_4]           # 004a78d9
    mov eax, dword ptr [edx + field_36e]         # 004a78dc
    mov dword ptr [0x5bb59f], eax                # 004a78e2
    mov ecx, dword ptr [ebp - local_4]           # 004a78e7
    mov edx, dword ptr [ecx + field_372]         # 004a78ea
    mov dword ptr [0x5bb5a3], edx                # 004a78f0
    mov eax, dword ptr [ebp - local_4]           # 004a78f6
    movsx ecx, word ptr [eax + field_376]        # 004a78f9
    cmp ecx, 0x1                                 # 004a7900
    jne.d8 L_004a7911                            # 004a7903
    # block 0x004a7905: entered by fall-through of jne at 0x004a7903, 2 instruction(s), ends with forward jump to 0x004a791b
    mov dword ptr [0x5bb1ca], 0x0                # 004a7905
    jmp.d8 L_004a791b                            # 004a790f
L_004a7911:
    # block 0x004a7911: entered by jne at 0x004a7903, 1 instruction(s), falls into the block at 0x004a791b
    mov dword ptr [0x5bb1ca], 0x1                # 004a7911
L_004a791b:
    # block 0x004a791b: entered by jmp at 0x004a790f, 1 instruction(s), falls into the block at 0x004a7925
    mov dword ptr [0x583999], 0x4                # 004a791b
L_004a7925:
    # block 0x004a7925: entered by je at 0x004a7882, 4 instruction(s), ends with je to 0x004a7950 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a7925
    movsx eax, word ptr [edx + field_378]        # 004a7928
    cmp eax, -0x1                                # 004a792f
    je.d8 L_004a7950                             # 004a7932
    # block 0x004a7934: entered by fall-through of je at 0x004a7932, 6 instruction(s), falls into the block at 0x004a7950
    mov ecx, dword ptr [ebp - local_4]           # 004a7934
    {load} xor edx, edx                          # 004a7937
    mov dl, byte ptr [ecx + field_37a]           # 004a7939
    mov eax, dword ptr [ebp - local_4]           # 004a793f
    movsx ecx, word ptr [eax + field_378]        # 004a7942
    mov dword ptr [4*ecx + 0x585801], edx        # 004a7949
L_004a7950:
    # block 0x004a7950: entered by jmp at 0x004a785b; je at 0x004a786d; je at 0x004a7932, 7 instruction(s), calls FUN_0042ba3a, FUN_004a63dc, falls into the block at 0x004a7968
    mov edx, dword ptr [ebp - local_10]          # 004a7950
    mov ax, word ptr [edx + field_1e]            # 004a7953
    push eax                                     # 004a7957
    call FUN_0042ba3a                            # 004a7958
    add esp, 0x4                                 # 004a795d
    mov ecx, dword ptr [ebp - local_10]          # 004a7960
    call FUN_004a63dc                            # 004a7963
L_004a7968:
    # block 0x004a7968: entered by jmp at 0x004a6cac; jmp at 0x004a7093; jmp at 0x004a76d7, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004a7968
    pop esi                                      # 004a7969
    {load} mov esp, ebp                          # 004a796a
    pop ebp                                      # 004a796c
    ret 0x4                                      # 004a796d

# --- data items (not part of the function) -------------------------
.org 0x004a7970 - 0x401000
SWTAB_004a7970:  # 9 case address(es)
    .long L_004a70b5 - .text + 0x401000
    .long L_004a745f - .text + 0x401000
    .long L_004a7220 - .text + 0x401000
    .long L_004a70c2 - .text + 0x401000
    .long L_004a7423 - .text + 0x401000
    .long L_004a75e7 - .text + 0x401000
    .long L_004a75be - .text + 0x401000
    .long L_004a7617 - .text + 0x401000
    .long L_004a768e - .text + 0x401000
.set SWTAB_004a7970_VA, SWTAB_004a7970 - .text + 0x401000

