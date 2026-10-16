# FUN_00416af3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416af3
# extent:       0x00416af3-0x00416e59 (870 code bytes)
# span:         0x00416af3-0x00416e60 (code 870, tables 0, padding 7)
# sha256:       2e2c814e0d0a04dba791a8384526042d502c7f0ac9b2d934a3f5923cb864fd9d
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00416af3
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 1 more
# fields:       [eax + n] field_1, field_5, field_7, field_a; [ecx + n] field_2, field_3, field_5, field_7; [edx + n] field_1, field_2, field_3, field_5, field_7, field_e
# callees:      calls FUN_0043ef77, FUN_004c7314
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:convert_span (function ledger class candidate_port; also decode_commands; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 295 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_5, 0x5  # offset +0x5
.equ field_7, 0x7  # offset +0x7
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0043ef77, .text + (0x0043ef77 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)

.org 0x00416af3 - 0x401000
.globl FUN_00416af3
FUN_00416af3:
    # block 0x00416af3: entry, 15 instruction(s), ends with je to 0x00416b2c (forward)
    push ebp                                     # 00416af3
    {load} mov ebp, esp                          # 00416af4
    sub esp, 0x34                                # 00416af6
    push esi                                     # 00416af9
    push edi                                     # 00416afa
    mov dword ptr [ebp - local_28], ecx          # 00416afb
    mov dword ptr [ebp - local_10], 0x0          # 00416afe
    mov eax, dword ptr [ebp + arg_8]             # 00416b05
    mov ecx, dword ptr [eax + field_a]           # 00416b08
    mov dword ptr [ebp - local_18], ecx          # 00416b0b
    mov edx, dword ptr [ebp + arg_8]             # 00416b0e
    mov al, byte ptr [edx + field_e]             # 00416b11
    mov byte ptr [ebp - local_2c], al            # 00416b14
    cmp byte ptr [ebp - local_2c], 0x1           # 00416b17
    je.d8 L_00416b2c                             # 00416b1b
    # block 0x00416b1d: entered by fall-through of je at 0x00416b1b, 2 instruction(s), ends with je to 0x00416c8b (forward)
    cmp byte ptr [ebp - local_2c], 0x2           # 00416b1d
    je.d32 L_00416c8b                            # 00416b21
    # block 0x00416b27: entered by fall-through of je at 0x00416b21, 1 instruction(s), ends with forward jump to 0x00416e51
    jmp.d32 L_00416e51                           # 00416b27
L_00416b2c:
    # block 0x00416b2c: entered by je at 0x00416b1b; jmp at 0x00416c6f, 3 instruction(s), ends with jge to 0x00416c74 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00416b2c
    cmp ecx, dword ptr [ebp - local_18]          # 00416b2f
    jge.d32 L_00416c74                           # 00416b32
    # block 0x00416b38: entered by fall-through of jge at 0x00416b32, 8 instruction(s), ends with je to 0x00416c26 (forward)
    mov edx, dword ptr [ebp + arg_14]            # 00416b38
    add edx, dword ptr [ebp - local_10]          # 00416b3b
    mov al, byte ptr [edx]                       # 00416b3e
    mov byte ptr [ebp - local_8], al             # 00416b40
    mov cl, byte ptr [ebp - local_8]             # 00416b43
    mov byte ptr [ebp - local_30], cl            # 00416b46
    cmp byte ptr [ebp - local_30], 0x20          # 00416b49
    je.d32 L_00416c26                            # 00416b4d
    # block 0x00416b53: entered by fall-through of je at 0x00416b4d, 2 instruction(s), ends with je to 0x00416b64 (forward)
    cmp byte ptr [ebp - local_30], 0x40          # 00416b53
    je.d8 L_00416b64                             # 00416b57
    # block 0x00416b59: entered by fall-through of je at 0x00416b57, 2 instruction(s), ends with je to 0x00416ba1 (forward)
    cmp byte ptr [ebp - local_30], -0x80         # 00416b59
    je.d8 L_00416ba1                             # 00416b5d
    # block 0x00416b5f: entered by fall-through of je at 0x00416b5d, 1 instruction(s), ends with forward jump to 0x00416c6f
    jmp.d32 L_00416c6f                           # 00416b5f
L_00416b64:
    # block 0x00416b64: entered by je at 0x00416b57, 20 instruction(s), calls FUN_0043ef77, ends with forward jump to 0x00416c6f
    mov edx, dword ptr [ebp + arg_14]            # 00416b64
    add edx, dword ptr [ebp - local_10]          # 00416b67
    mov dword ptr [ebp - local_24], edx          # 00416b6a
    mov eax, dword ptr [ebp - local_10]          # 00416b6d
    add eax, 0xb                                 # 00416b70
    mov dword ptr [ebp - local_10], eax          # 00416b73
    mov ecx, dword ptr [ebp - local_24]          # 00416b76
    mov edx, dword ptr [ecx + field_7]           # 00416b79
    push edx                                     # 00416b7c
    mov eax, dword ptr [ebp - local_24]          # 00416b7d
    mov cx, word ptr [eax + field_1]             # 00416b80
    push ecx                                     # 00416b84
    mov edx, dword ptr [ebp - local_24]          # 00416b85
    mov eax, dword ptr [edx + field_3]           # 00416b88
    mov ecx, dword ptr [ebp + arg_c]             # 00416b8b
    lea edx, [ecx + 2*eax]                       # 00416b8e
    push edx                                     # 00416b91
    mov ecx, 0x5d2f2d                            # 00416b92
    call FUN_0043ef77                            # 00416b97
    jmp.d32 L_00416c6f                           # 00416b9c
L_00416ba1:
    # block 0x00416ba1: entered by je at 0x00416b5d, 17 instruction(s), ends with forward jump to 0x00416bdf
    mov eax, dword ptr [ebp + arg_14]            # 00416ba1
    add eax, dword ptr [ebp - local_10]          # 00416ba4
    mov dword ptr [ebp - local_4], eax           # 00416ba7
    mov ecx, dword ptr [ebp - local_10]          # 00416baa
    add ecx, 0x6                                 # 00416bad
    mov dword ptr [ebp - local_10], ecx          # 00416bb0
    mov edx, dword ptr [ebp + arg_14]            # 00416bb3
    add edx, dword ptr [ebp - local_10]          # 00416bb6
    mov dword ptr [ebp - local_14], edx          # 00416bb9
    mov eax, dword ptr [ebp - local_4]           # 00416bbc
    {load} xor ecx, ecx                          # 00416bbf
    mov cl, byte ptr [eax + field_1]             # 00416bc1
    mov edx, dword ptr [ebp - local_10]          # 00416bc4
    lea eax, [edx + 2*ecx]                       # 00416bc7
    mov dword ptr [ebp - local_10], eax          # 00416bca
    mov dword ptr [ebp - local_1c], 0x0          # 00416bcd
    jmp.d8 L_00416bdf                            # 00416bd4
L_00416bd6:
    # block 0x00416bd6: entered by jmp at 0x00416c22, 3 instruction(s), falls into the block at 0x00416bdf
    mov ecx, dword ptr [ebp - local_1c]          # 00416bd6
    add ecx, 0x1                                 # 00416bd9
    mov dword ptr [ebp - local_1c], ecx          # 00416bdc
L_00416bdf:
    # block 0x00416bdf: entered by jmp at 0x00416bd4, 4 instruction(s), ends with jge to 0x00416c24 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00416bdf
    mov eax, dword ptr [ebp - local_1c]          # 00416be2
    cmp eax, dword ptr [edx + field_2]           # 00416be5
    jge.d8 L_00416c24                            # 00416be8
    # block 0x00416bea: entered by fall-through of jge at 0x00416be8, 22 instruction(s), ends with backward jump to 0x00416bd6
    mov ecx, dword ptr [ebp + arg_14]            # 00416bea
    add ecx, dword ptr [ebp - local_10]          # 00416bed
    mov edx, dword ptr [ecx]                     # 00416bf0
    mov dword ptr [ebp - local_20], edx          # 00416bf2
    mov eax, dword ptr [ebp - local_4]           # 00416bf5
    {load} xor ecx, ecx                          # 00416bf8
    mov cl, byte ptr [eax + field_1]             # 00416bfa
    shl ecx                                      # 00416bfd
    mov esi, dword ptr [ebp - local_14]          # 00416bff
    mov edx, dword ptr [ebp - local_20]          # 00416c02
    mov eax, dword ptr [ebp + arg_c]             # 00416c05
    lea edi, [eax + 2*edx]                       # 00416c08
    {load} mov edx, ecx                          # 00416c0b
    shr ecx, 0x2                                 # 00416c0d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416c10
    {load} mov ecx, edx                          # 00416c12
    and ecx, 0x3                                 # 00416c14
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416c17
    mov eax, dword ptr [ebp - local_10]          # 00416c19
    add eax, 0x4                                 # 00416c1c
    mov dword ptr [ebp - local_10], eax          # 00416c1f
    jmp.d8 L_00416bd6                            # 00416c22
L_00416c24:
    # block 0x00416c24: entered by jge at 0x00416be8, 1 instruction(s), ends with forward jump to 0x00416c6f
    jmp.d8 L_00416c6f                            # 00416c24
L_00416c26:
    # block 0x00416c26: entered by je at 0x00416b4d, 26 instruction(s), falls into the block at 0x00416c6f
    mov ecx, dword ptr [ebp + arg_14]            # 00416c26
    add ecx, dword ptr [ebp - local_10]          # 00416c29
    mov dword ptr [ebp - local_c], ecx           # 00416c2c
    mov edx, dword ptr [ebp - local_10]          # 00416c2f
    add edx, 0x9                                 # 00416c32
    mov dword ptr [ebp - local_10], edx          # 00416c35
    mov eax, dword ptr [ebp - local_c]           # 00416c38
    mov ecx, dword ptr [eax + field_5]           # 00416c3b
    shl ecx                                      # 00416c3e
    mov esi, dword ptr [ebp + arg_14]            # 00416c40
    add esi, dword ptr [ebp - local_10]          # 00416c43
    mov edx, dword ptr [ebp - local_c]           # 00416c46
    mov eax, dword ptr [edx + field_1]           # 00416c49
    mov edx, dword ptr [ebp + arg_c]             # 00416c4c
    lea edi, [edx + 2*eax]                       # 00416c4f
    {load} mov eax, ecx                          # 00416c52
    shr ecx, 0x2                                 # 00416c54
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416c57
    {load} mov ecx, eax                          # 00416c59
    and ecx, 0x3                                 # 00416c5b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416c5e
    mov ecx, dword ptr [ebp - local_c]           # 00416c60
    mov edx, dword ptr [ecx + field_5]           # 00416c63
    mov eax, dword ptr [ebp - local_10]          # 00416c66
    lea ecx, [eax + 2*edx]                       # 00416c69
    mov dword ptr [ebp - local_10], ecx          # 00416c6c
L_00416c6f:
    # block 0x00416c6f: entered by jmp at 0x00416b5f; jmp at 0x00416b9c; jmp at 0x00416c24, 1 instruction(s), ends with backward jump to 0x00416b2c
    jmp.d32 L_00416b2c                           # 00416c6f
L_00416c74:
    # block 0x00416c74: entered by jge at 0x00416b32, 7 instruction(s), calls FUN_004c7314, ends with forward jump to 0x00416e51
    mov edx, dword ptr [ebp + arg_10]            # 00416c74
    push edx                                     # 00416c77
    mov eax, dword ptr [ebp + arg_c]             # 00416c78
    push eax                                     # 00416c7b
    mov ecx, 0x5cf659                            # 00416c7c
    call FUN_004c7314                            # 00416c81
    jmp.d32 L_00416e51                           # 00416c86
L_00416c8b:
    # block 0x00416c8b: entered by je at 0x00416b21, 2 instruction(s), ends with jne to 0x00416ca8 (forward)
    cmp dword ptr [ebp + arg_1c], 0x0            # 00416c8b
    jne.d8 L_00416ca8                            # 00416c8f
    # block 0x00416c91: entered by fall-through of jne at 0x00416c8f, 9 instruction(s), falls into the block at 0x00416ca8
    mov ecx, dword ptr [ebp + arg_10]            # 00416c91
    mov esi, dword ptr [ebp + arg_18]            # 00416c94
    mov edi, dword ptr [ebp + arg_c]             # 00416c97
    {load} mov edx, ecx                          # 00416c9a
    shr ecx, 0x2                                 # 00416c9c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416c9f
    {load} mov ecx, edx                          # 00416ca1
    and ecx, 0x3                                 # 00416ca3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416ca6
L_00416ca8:
    # block 0x00416ca8: entered by jne at 0x00416c8f; jmp at 0x00416e4c, 3 instruction(s), ends with jge to 0x00416e51 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00416ca8
    cmp eax, dword ptr [ebp - local_18]          # 00416cab
    jge.d32 L_00416e51                           # 00416cae
    # block 0x00416cb4: entered by fall-through of jge at 0x00416cae, 8 instruction(s), ends with je to 0x00416de3 (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 00416cb4
    add ecx, dword ptr [ebp - local_10]          # 00416cb7
    mov dl, byte ptr [ecx]                       # 00416cba
    mov byte ptr [ebp - local_8], dl             # 00416cbc
    mov al, byte ptr [ebp - local_8]             # 00416cbf
    mov byte ptr [ebp - local_34], al            # 00416cc2
    cmp byte ptr [ebp - local_34], 0x20          # 00416cc5
    je.d32 L_00416de3                            # 00416cc9
    # block 0x00416ccf: entered by fall-through of je at 0x00416cc9, 2 instruction(s), ends with je to 0x00416ce0 (forward)
    cmp byte ptr [ebp - local_34], 0x40          # 00416ccf
    je.d8 L_00416ce0                             # 00416cd3
    # block 0x00416cd5: entered by fall-through of je at 0x00416cd3, 2 instruction(s), ends with je to 0x00416d3d (forward)
    cmp byte ptr [ebp - local_34], -0x80         # 00416cd5
    je.d8 L_00416d3d                             # 00416cd9
    # block 0x00416cdb: entered by fall-through of je at 0x00416cd9, 1 instruction(s), ends with forward jump to 0x00416e4c
    jmp.d32 L_00416e4c                           # 00416cdb
L_00416ce0:
    # block 0x00416ce0: entered by je at 0x00416cd3, 31 instruction(s), calls FUN_0043ef77, FUN_004c7314, ends with forward jump to 0x00416e4c
    mov ecx, dword ptr [ebp + arg_14]            # 00416ce0
    add ecx, dword ptr [ebp - local_10]          # 00416ce3
    mov dword ptr [ebp - local_24], ecx          # 00416ce6
    mov edx, dword ptr [ebp - local_10]          # 00416ce9
    add edx, 0xb                                 # 00416cec
    mov dword ptr [ebp - local_10], edx          # 00416cef
    mov eax, dword ptr [ebp - local_24]          # 00416cf2
    mov ecx, dword ptr [eax + field_7]           # 00416cf5
    push ecx                                     # 00416cf8
    mov edx, dword ptr [ebp - local_24]          # 00416cf9
    mov ax, word ptr [edx + field_1]             # 00416cfc
    push eax                                     # 00416d00
    mov ecx, dword ptr [ebp - local_24]          # 00416d01
    mov edx, dword ptr [ecx + field_3]           # 00416d04
    mov eax, dword ptr [ebp + arg_c]             # 00416d07
    lea ecx, [eax + 2*edx]                       # 00416d0a
    push ecx                                     # 00416d0d
    mov ecx, 0x5d2f2d                            # 00416d0e
    call FUN_0043ef77                            # 00416d13
    mov edx, dword ptr [ebp - local_24]          # 00416d18
    mov eax, dword ptr [edx + field_7]           # 00416d1b
    shl eax                                      # 00416d1e
    push eax                                     # 00416d20
    mov ecx, dword ptr [ebp - local_24]          # 00416d21
    mov edx, dword ptr [ecx + field_3]           # 00416d24
    mov eax, dword ptr [ebp + arg_c]             # 00416d27
    lea ecx, [eax + 2*edx]                       # 00416d2a
    push ecx                                     # 00416d2d
    mov ecx, 0x5cf659                            # 00416d2e
    call FUN_004c7314                            # 00416d33
    jmp.d32 L_00416e4c                           # 00416d38
L_00416d3d:
    # block 0x00416d3d: entered by je at 0x00416cd9, 17 instruction(s), ends with forward jump to 0x00416d7b
    mov edx, dword ptr [ebp + arg_14]            # 00416d3d
    add edx, dword ptr [ebp - local_10]          # 00416d40
    mov dword ptr [ebp - local_4], edx           # 00416d43
    mov eax, dword ptr [ebp - local_10]          # 00416d46
    add eax, 0x6                                 # 00416d49
    mov dword ptr [ebp - local_10], eax          # 00416d4c
    mov ecx, dword ptr [ebp + arg_14]            # 00416d4f
    add ecx, dword ptr [ebp - local_10]          # 00416d52
    mov dword ptr [ebp - local_14], ecx          # 00416d55
    mov edx, dword ptr [ebp - local_4]           # 00416d58
    {load} xor eax, eax                          # 00416d5b
    mov al, byte ptr [edx + field_1]             # 00416d5d
    mov ecx, dword ptr [ebp - local_10]          # 00416d60
    lea edx, [ecx + 2*eax]                       # 00416d63
    mov dword ptr [ebp - local_10], edx          # 00416d66
    mov dword ptr [ebp - local_1c], 0x0          # 00416d69
    jmp.d8 L_00416d7b                            # 00416d70
L_00416d72:
    # block 0x00416d72: entered by jmp at 0x00416ddf, 3 instruction(s), falls into the block at 0x00416d7b
    mov eax, dword ptr [ebp - local_1c]          # 00416d72
    add eax, 0x1                                 # 00416d75
    mov dword ptr [ebp - local_1c], eax          # 00416d78
L_00416d7b:
    # block 0x00416d7b: entered by jmp at 0x00416d70, 4 instruction(s), ends with jge to 0x00416de1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00416d7b
    mov edx, dword ptr [ebp - local_1c]          # 00416d7e
    cmp edx, dword ptr [ecx + field_2]           # 00416d81
    jge.d8 L_00416de1                            # 00416d84
    # block 0x00416d86: entered by fall-through of jge at 0x00416d84, 34 instruction(s), calls FUN_004c7314, ends with backward jump to 0x00416d72
    mov eax, dword ptr [ebp + arg_14]            # 00416d86
    add eax, dword ptr [ebp - local_10]          # 00416d89
    mov ecx, dword ptr [eax]                     # 00416d8c
    mov dword ptr [ebp - local_20], ecx          # 00416d8e
    mov edx, dword ptr [ebp - local_4]           # 00416d91
    {load} xor eax, eax                          # 00416d94
    mov al, byte ptr [edx + field_1]             # 00416d96
    {load} mov ecx, eax                          # 00416d99
    shl ecx                                      # 00416d9b
    mov esi, dword ptr [ebp - local_14]          # 00416d9d
    mov edx, dword ptr [ebp - local_20]          # 00416da0
    mov eax, dword ptr [ebp + arg_c]             # 00416da3
    lea edi, [eax + 2*edx]                       # 00416da6
    {load} mov edx, ecx                          # 00416da9
    shr ecx, 0x2                                 # 00416dab
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416dae
    {load} mov ecx, edx                          # 00416db0
    and ecx, 0x3                                 # 00416db2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416db5
    mov eax, dword ptr [ebp - local_4]           # 00416db7
    {load} xor ecx, ecx                          # 00416dba
    mov cl, byte ptr [eax + field_1]             # 00416dbc
    shl ecx                                      # 00416dbf
    push ecx                                     # 00416dc1
    mov edx, dword ptr [ebp - local_20]          # 00416dc2
    mov eax, dword ptr [ebp + arg_c]             # 00416dc5
    lea ecx, [eax + 2*edx]                       # 00416dc8
    push ecx                                     # 00416dcb
    mov ecx, 0x5cf659                            # 00416dcc
    call FUN_004c7314                            # 00416dd1
    mov edx, dword ptr [ebp - local_10]          # 00416dd6
    add edx, 0x4                                 # 00416dd9
    mov dword ptr [ebp - local_10], edx          # 00416ddc
    jmp.d8 L_00416d72                            # 00416ddf
L_00416de1:
    # block 0x00416de1: entered by jge at 0x00416d84, 1 instruction(s), ends with forward jump to 0x00416e4c
    jmp.d8 L_00416e4c                            # 00416de1
L_00416de3:
    # block 0x00416de3: entered by je at 0x00416cc9, 37 instruction(s), calls FUN_004c7314, falls into the block at 0x00416e4c
    mov eax, dword ptr [ebp + arg_14]            # 00416de3
    add eax, dword ptr [ebp - local_10]          # 00416de6
    mov dword ptr [ebp - local_c], eax           # 00416de9
    mov ecx, dword ptr [ebp - local_10]          # 00416dec
    add ecx, 0x9                                 # 00416def
    mov dword ptr [ebp - local_10], ecx          # 00416df2
    mov edx, dword ptr [ebp - local_c]           # 00416df5
    mov ecx, dword ptr [edx + field_5]           # 00416df8
    shl ecx                                      # 00416dfb
    mov esi, dword ptr [ebp + arg_14]            # 00416dfd
    add esi, dword ptr [ebp - local_10]          # 00416e00
    mov eax, dword ptr [ebp - local_c]           # 00416e03
    mov edx, dword ptr [eax + field_1]           # 00416e06
    mov eax, dword ptr [ebp + arg_c]             # 00416e09
    lea edi, [eax + 2*edx]                       # 00416e0c
    {load} mov edx, ecx                          # 00416e0f
    shr ecx, 0x2                                 # 00416e11
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416e14
    {load} mov ecx, edx                          # 00416e16
    and ecx, 0x3                                 # 00416e18
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416e1b
    mov eax, dword ptr [ebp - local_c]           # 00416e1d
    mov ecx, dword ptr [eax + field_5]           # 00416e20
    shl ecx                                      # 00416e23
    push ecx                                     # 00416e25
    mov edx, dword ptr [ebp - local_c]           # 00416e26
    mov eax, dword ptr [edx + field_1]           # 00416e29
    mov ecx, dword ptr [ebp + arg_c]             # 00416e2c
    lea edx, [ecx + 2*eax]                       # 00416e2f
    push edx                                     # 00416e32
    mov ecx, 0x5cf659                            # 00416e33
    call FUN_004c7314                            # 00416e38
    mov eax, dword ptr [ebp - local_c]           # 00416e3d
    mov ecx, dword ptr [eax + field_5]           # 00416e40
    mov edx, dword ptr [ebp - local_10]          # 00416e43
    lea eax, [edx + 2*ecx]                       # 00416e46
    mov dword ptr [ebp - local_10], eax          # 00416e49
L_00416e4c:
    # block 0x00416e4c: entered by jmp at 0x00416cdb; jmp at 0x00416d38; jmp at 0x00416de1, 1 instruction(s), ends with backward jump to 0x00416ca8
    jmp.d32 L_00416ca8                           # 00416e4c
L_00416e51:
    # block 0x00416e51: entered by jmp at 0x00416b27; jmp at 0x00416c86; jge at 0x00416cae, 5 instruction(s), ends with ret 0x18
    pop edi                                      # 00416e51
    pop esi                                      # 00416e52
    {load} mov esp, ebp                          # 00416e53
    pop ebp                                      # 00416e55
    ret 0x18                                     # 00416e56

# --- data items (not part of the function) -------------------------
.org 0x00416e59 - 0x401000
PAD_00416e59:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

