# FUN_00476a25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00476a25
# extent:       0x00476a25-0x004778b3 (3726 code bytes)
# span:         0x00476a25-0x004778cf (code 3726, tables 28, padding 0)
# sha256:       e7e73174dd10aa88f20160663f336233b622625df492f0e3a5be92f35fc61186
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00476a25
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_2, field_4, field_8, field_c, field_20, field_28, field_2c, field_30, field_44, field_238, field_63e, field_640 and 24 more; [ecx + n] field_2, field_4, field_8, field_c, field_1c, field_20, field_22, field_24, field_2c, field_25f, field_63e, field_640 and 25 more; [edx + n] field_1c, field_20, field_22, field_28, field_2c, field_30, field_42, field_58, field_23a, field_63e, field_77d, field_783 and 19 more
# callees:      calls FUN_004e8d96, FUN_00475a1e, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_0050ca3e, FUN_0044a2b7, FUN_004763b3, FUN_004f6334, FUN_004fb2e3, FUN_004fba69, FUN_004c92c5, FUN_0042ba3a, FUN_00475885
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 969 instruction(s), 53 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_38, 0x38  # offset -0x38
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_58, 0x58  # offset +0x58
.equ field_238, 0x238  # offset +0x238
.equ field_23a, 0x23a  # offset +0x23a
.equ field_25f, 0x25f  # offset +0x25f
.equ field_63e, 0x63e  # offset +0x63e
.equ field_640, 0x640  # offset +0x640
.equ field_6e8, 0x6e8  # offset +0x6e8
.equ field_70b, 0x70b  # offset +0x70b
.equ field_77d, 0x77d  # offset +0x77d
.equ field_77f, 0x77f  # offset +0x77f
.equ field_781, 0x781  # offset +0x781
.equ field_783, 0x783  # offset +0x783
.equ field_785, 0x785  # offset +0x785
.equ field_789, 0x789  # offset +0x789
.equ field_78d, 0x78d  # offset +0x78d
.equ field_791, 0x791  # offset +0x791
.equ field_793, 0x793  # offset +0x793
.equ field_795, 0x795  # offset +0x795
.equ field_796, 0x796  # offset +0x796
.equ field_7b9, 0x7b9  # offset +0x7b9
.equ field_7c9, 0x7c9  # offset +0x7c9
.equ field_7cb, 0x7cb  # offset +0x7cb
.equ field_7cd, 0x7cd  # offset +0x7cd
.equ field_7cf, 0x7cf  # offset +0x7cf
.equ field_7d1, 0x7d1  # offset +0x7d1
.equ field_7d5, 0x7d5  # offset +0x7d5
.equ field_7d9, 0x7d9  # offset +0x7d9
.equ field_7dd, 0x7dd  # offset +0x7dd
.equ field_7df, 0x7df  # offset +0x7df
.equ field_7e1, 0x7e1  # offset +0x7e1
.equ field_800, 0x800  # offset +0x800
.equ field_801, 0x801  # offset +0x801
.equ field_802, 0x802  # offset +0x802
.equ field_803, 0x803  # offset +0x803
.equ field_898, 0x898  # offset +0x898
.equ field_899, 0x899  # offset +0x899
.equ field_89a, 0x89a  # offset +0x89a
.equ field_89e, 0x89e  # offset +0x89e
.equ field_8a2, 0x8a2  # offset +0x8a2
.equ field_8a6, 0x8a6  # offset +0x8a6
.equ field_8aa, 0x8aa  # offset +0x8aa
.equ field_8ae, 0x8ae  # offset +0x8ae
.equ field_8b2, 0x8b2  # offset +0x8b2
.equ field_8b6, 0x8b6  # offset +0x8b6
.equ field_8c2, 0x8c2  # offset +0x8c2
.equ field_8c6, 0x8c6  # offset +0x8c6
.equ field_8ca, 0x8ca  # offset +0x8ca
.equ field_8d6, 0x8d6  # offset +0x8d6
.equ field_8d7, 0x8d7  # offset +0x8d7
.equ field_8d8, 0x8d8  # offset +0x8d8
.equ field_8d9, 0x8d9  # offset +0x8d9

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_00475885, .text + (0x00475885 - 0x401000)
.set FUN_00475a1e, .text + (0x00475a1e - 0x401000)
.set FUN_004763b3, .text + (0x004763b3 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00476a25 - 0x401000
.globl FUN_00476a25
FUN_00476a25:
    # block 0x00476a25: entry, 16 instruction(s), ends with je to 0x00476a75 (forward)
    push ebp                                     # 00476a25
    {load} mov ebp, esp                          # 00476a26
    sub esp, 0x38                                # 00476a28
    push esi                                     # 00476a2b
    push edi                                     # 00476a2c
    mov dword ptr [ebp - local_30], ecx          # 00476a2d
    movsx eax, word ptr [ebp + arg_8]            # 00476a30
    imul eax, eax, 0x8d                          # 00476a34
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00476a3a
    mov dword ptr [ebp - local_4], ecx           # 00476a40
    movsx edx, word ptr [ebp + arg_8]            # 00476a43
    imul edx, edx, 0x8d                          # 00476a47
    mov eax, dword ptr [edx + 0x5bb632]          # 00476a4d
    mov dword ptr [ebp - local_34], eax          # 00476a53
    cmp dword ptr [ebp - local_34], 0x0          # 00476a56
    je.d8 L_00476a75                             # 00476a5a
    # block 0x00476a5c: entered by fall-through of je at 0x00476a5a, 2 instruction(s), ends with je to 0x00476e16 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 00476a5c
    je.d32 L_00476e16                            # 00476a60
    # block 0x00476a66: entered by fall-through of je at 0x00476a60, 2 instruction(s), ends with je to 0x00477604 (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 00476a66
    je.d32 L_00477604                            # 00476a6a
    # block 0x00476a70: entered by fall-through of je at 0x00476a6a, 1 instruction(s), ends with forward jump to 0x004778ab
    jmp.d32 L_004778ab                           # 00476a70
L_00476a75:
    # block 0x00476a75: entered by je at 0x00476a5a, 70 instruction(s), calls FUN_004e8d96, FUN_00475a1e, FUN_004d39f9, ends with jne to 0x00476bb7 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00476a75
    mov dx, word ptr [ebp + arg_8]               # 00476a78
    mov word ptr [ecx + field_22], dx            # 00476a7c
    mov eax, dword ptr [ebp - local_30]          # 00476a80
    mov dword ptr [eax + field_89a], 0x1         # 00476a83
    mov dword ptr [0x5bb1ca], 0x1                # 00476a8d
    mov ecx, 0x571442                            # 00476a97
    call FUN_004e8d96                            # 00476a9c
    push 0x0                                     # 00476aa1
    push 0x0                                     # 00476aa3
    push 0x1                                     # 00476aa5
    mov ecx, dword ptr [ebp - local_30]          # 00476aa7
    call FUN_00475a1e                            # 00476aaa
    call FUN_004d39f9                            # 00476aaf
    mov ecx, dword ptr [ebp - local_30]          # 00476ab4
    mov word ptr [ecx + field_20], ax            # 00476ab7
    mov edx, dword ptr [ebp - local_30]          # 00476abb
    movsx eax, word ptr [edx + field_20]         # 00476abe
    imul eax, eax, 0x4a                          # 00476ac2
    mov dword ptr [eax + 0x5d1591], 0xa          # 00476ac5
    mov ecx, dword ptr [ebp - local_30]          # 00476acf
    movsx edx, word ptr [ecx + field_20]         # 00476ad2
    imul edx, edx, 0x4a                          # 00476ad6
    mov dword ptr [edx + 0x5d1595], 0x4778df     # 00476ad9
    mov eax, dword ptr [ebp - local_30]          # 00476ae3
    movsx ecx, word ptr [eax + field_20]         # 00476ae6
    imul ecx, ecx, 0x4a                          # 00476aea
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00476aed
    mov edx, dword ptr [ebp - local_30]          # 00476af7
    movsx eax, word ptr [edx + field_20]         # 00476afa
    imul eax, eax, 0x4a                          # 00476afe
    mov dword ptr [eax + 0x5d159d], 0x0          # 00476b01
    mov ecx, dword ptr [ebp - local_30]          # 00476b0b
    movsx edx, word ptr [ecx + field_20]         # 00476b0e
    imul edx, edx, 0x4a                          # 00476b12
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00476b15
    mov eax, dword ptr [ebp - local_30]          # 00476b1f
    movsx ecx, word ptr [eax + field_20]         # 00476b22
    imul ecx, ecx, 0x4a                          # 00476b26
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00476b29
    mov edx, dword ptr [ebp - local_30]          # 00476b33
    movsx eax, word ptr [edx + field_20]         # 00476b36
    imul eax, eax, 0x4a                          # 00476b3a
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00476b3d
    mov ecx, dword ptr [ebp - local_30]          # 00476b47
    movsx edx, word ptr [ecx + field_20]         # 00476b4a
    imul edx, edx, 0x4a                          # 00476b4e
    mov word ptr [edx + 0x5d15ad], 0x0           # 00476b51
    mov edi, 0x54c8a0                            # 00476b5a
    mov eax, dword ptr [ebp - local_30]          # 00476b5f
    movsx ecx, word ptr [eax + field_20]         # 00476b62
    imul ecx, ecx, 0x4a                          # 00476b66
    add ecx, 0x5d15b3                            # 00476b69
    {load} mov edx, ecx                          # 00476b6f
    or ecx, -0x1                                 # 00476b71
    {load} xor eax, eax                          # 00476b74
    repne scasb al, byte ptr es:[edi]            # 00476b76
    not ecx                                      # 00476b78
    {load} sub edi, ecx                          # 00476b7a
    {load} mov esi, edi                          # 00476b7c
    {load} mov eax, ecx                          # 00476b7e
    {load} mov edi, edx                          # 00476b80
    shr ecx, 0x2                                 # 00476b82
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00476b85
    {load} mov ecx, eax                          # 00476b87
    and ecx, 0x3                                 # 00476b89
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00476b8c
    mov ecx, dword ptr [ebp - local_30]          # 00476b8e
    cmp dword ptr [ecx + field_24], 0x0          # 00476b91
    jne.d8 L_00476bb7                            # 00476b95
    # block 0x00476b97: entered by fall-through of jne at 0x00476b95, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00476bb7
    push 0x54c8b8                                # 00476b97
    push 0x6                                     # 00476b9c
    mov edx, dword ptr [ebp - local_4]           # 00476b9e
    push edx                                     # 00476ba1
    push 0x54c8d0                                # 00476ba2
    mov ecx, 0x5cf659                            # 00476ba7
    call FUN_004c2790                            # 00476bac
    mov ecx, dword ptr [ebp - local_30]          # 00476bb1
    mov dword ptr [ecx + field_24], eax          # 00476bb4
L_00476bb7:
    # block 0x00476bb7: entered by jne at 0x00476b95, 9 instruction(s), ends with jne to 0x00476c0f (forward)
    mov edx, dword ptr [ebp - local_30]          # 00476bb7
    movsx eax, word ptr [edx + field_20]         # 00476bba
    imul eax, eax, 0x4a                          # 00476bbe
    mov ecx, dword ptr [ebp - local_30]          # 00476bc1
    mov edx, dword ptr [ecx + field_24]          # 00476bc4
    mov dword ptr [eax + 0x5d1599], edx          # 00476bc7
    mov eax, dword ptr [ebp - local_30]          # 00476bcd
    cmp dword ptr [eax + field_28], 0x0          # 00476bd0
    jne.d8 L_00476c0f                            # 00476bd4
    # block 0x00476bd6: entered by fall-through of jne at 0x00476bd4, 9 instruction(s), ends with je to 0x00476c0f (forward)
    mov edi, dword ptr [ebp - local_4]           # 00476bd6
    add edi, 0x21                                # 00476bd9
    or ecx, -0x1                                 # 00476bdc
    {load} xor eax, eax                          # 00476bdf
    repne scasb al, byte ptr es:[edi]            # 00476be1
    not ecx                                      # 00476be3
    add ecx, -0x1                                # 00476be5
    test ecx, ecx                                # 00476be8
    je.d8 L_00476c0f                             # 00476bea
    # block 0x00476bec: entered by fall-through of je at 0x00476bea, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x00476c0f
    push 0x54c8d8                                # 00476bec
    push 0x6                                     # 00476bf1
    mov ecx, dword ptr [ebp - local_4]           # 00476bf3
    add ecx, 0x21                                # 00476bf6
    push ecx                                     # 00476bf9
    push 0x54c8e8                                # 00476bfa
    mov ecx, 0x5cf659                            # 00476bff
    call FUN_004c2790                            # 00476c04
    mov edx, dword ptr [ebp - local_30]          # 00476c09
    mov dword ptr [edx + field_28], eax          # 00476c0c
L_00476c0f:
    # block 0x00476c0f: entered by jne at 0x00476bd4; je at 0x00476bea, 7 instruction(s), ends with je to 0x00476c3c (forward)
    mov edi, 0x54c8f0                            # 00476c0f
    mov esi, dword ptr [ebp - local_4]           # 00476c14
    add esi, 0x6ea                               # 00476c17
    mov ecx, 0x9                                 # 00476c1d
    {load} xor eax, eax                          # 00476c22
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00476c24
    je.d8 L_00476c3c                             # 00476c26
    # block 0x00476c28: entered by fall-through of je at 0x00476c26, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00476c3c
    mov ecx, dword ptr [ebp - local_4]           # 00476c28
    add ecx, 0x6ea                               # 00476c2b
    push ecx                                     # 00476c31
    mov ecx, 0x5c3a67                            # 00476c32
    call FUN_004fb77a                            # 00476c37
L_00476c3c:
    # block 0x00476c3c: entered by je at 0x00476c26, 7 instruction(s), ends with je to 0x00476c68 (forward)
    mov edi, 0x54c8fc                            # 00476c3c
    mov esi, dword ptr [ebp - local_4]           # 00476c41
    add esi, 0x71b                               # 00476c44
    mov ecx, 0x9                                 # 00476c4a
    {load} xor edx, edx                          # 00476c4f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00476c51
    je.d8 L_00476c68                             # 00476c53
    # block 0x00476c55: entered by fall-through of je at 0x00476c53, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00476c68
    mov eax, dword ptr [ebp - local_4]           # 00476c55
    add eax, 0x71b                               # 00476c58
    push eax                                     # 00476c5d
    mov ecx, 0x5c3a67                            # 00476c5e
    call FUN_004fb77a                            # 00476c63
L_00476c68:
    # block 0x00476c68: entered by je at 0x00476c53, 7 instruction(s), ends with je to 0x00476c94 (forward)
    mov edi, 0x54c908                            # 00476c68
    mov esi, dword ptr [ebp - local_4]           # 00476c6d
    add esi, 0x74c                               # 00476c70
    mov ecx, 0x9                                 # 00476c76
    {load} xor edx, edx                          # 00476c7b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00476c7d
    je.d8 L_00476c94                             # 00476c7f
    # block 0x00476c81: entered by fall-through of je at 0x00476c7f, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00476c94
    mov eax, dword ptr [ebp - local_4]           # 00476c81
    add eax, 0x74c                               # 00476c84
    push eax                                     # 00476c89
    mov ecx, 0x5c3a67                            # 00476c8a
    call FUN_004fb77a                            # 00476c8f
L_00476c94:
    # block 0x00476c94: entered by je at 0x00476c7f, 102 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0050ca3e, ends with forward jump to 0x004778ab
    mov ecx, dword ptr [ebp - local_30]          # 00476c94
    mov dword ptr [ecx + field_8b6], 0x1         # 00476c97
    mov edx, dword ptr [ebp - local_30]          # 00476ca1
    mov byte ptr [edx + field_8d8], 0x0          # 00476ca4
    mov eax, dword ptr [ebp - local_30]          # 00476cab
    mov byte ptr [eax + field_8d9], 0x0          # 00476cae
    mov ecx, dword ptr [ebp - local_30]          # 00476cb5
    mov byte ptr [ecx + field_800], 0x0          # 00476cb8
    mov edx, dword ptr [ebp - local_30]          # 00476cbf
    mov byte ptr [edx + field_803], 0x1          # 00476cc2
    mov eax, dword ptr [ebp - local_30]          # 00476cc9
    mov byte ptr [eax + field_801], 0x0          # 00476ccc
    mov ecx, dword ptr [ebp - local_30]          # 00476cd3
    mov byte ptr [ecx + field_802], 0x0          # 00476cd6
    mov edx, dword ptr [ebp - local_30]          # 00476cdd
    mov byte ptr [edx + field_8d6], 0x0          # 00476ce0
    mov eax, dword ptr [ebp - local_30]          # 00476ce7
    mov byte ptr [eax + field_8d7], 0x0          # 00476cea
    mov ecx, dword ptr [ebp - local_30]          # 00476cf1
    mov byte ptr [ecx + field_898], 0x0          # 00476cf4
    mov edx, dword ptr [ebp - local_30]          # 00476cfb
    mov byte ptr [edx + field_899], 0x0          # 00476cfe
    mov eax, dword ptr [ebp - local_30]          # 00476d05
    mov dword ptr [eax + field_8c2], 0x0         # 00476d08
    mov ecx, dword ptr [ebp - local_4]           # 00476d12
    movsx esi, word ptr [ecx + field_63e]        # 00476d15
    imul esi, esi, 0x3e8                         # 00476d1c
    call dword ptr [0x52a23c]                    # 00476d22
    {load} add esi, eax                          # 00476d28
    mov edx, dword ptr [ebp - local_30]          # 00476d2a
    mov dword ptr [edx + field_8c6], esi         # 00476d2d
    mov edi, 0x54c914                            # 00476d33
    mov eax, dword ptr [ebp - local_30]          # 00476d38
    add eax, 0x835                               # 00476d3b
    {load} mov edx, eax                          # 00476d40
    or ecx, -0x1                                 # 00476d42
    {load} xor eax, eax                          # 00476d45
    repne scasb al, byte ptr es:[edi]            # 00476d47
    not ecx                                      # 00476d49
    {load} sub edi, ecx                          # 00476d4b
    {load} mov esi, edi                          # 00476d4d
    {load} mov eax, ecx                          # 00476d4f
    {load} mov edi, edx                          # 00476d51
    shr ecx, 0x2                                 # 00476d53
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00476d56
    {load} mov ecx, eax                          # 00476d58
    and ecx, 0x3                                 # 00476d5a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00476d5d
    mov edi, 0x63a87c                            # 00476d5f
    mov ecx, dword ptr [ebp - local_30]          # 00476d64
    add ecx, 0x856                               # 00476d67
    {load} mov edx, ecx                          # 00476d6d
    or ecx, -0x1                                 # 00476d6f
    {load} xor eax, eax                          # 00476d72
    repne scasb al, byte ptr es:[edi]            # 00476d74
    not ecx                                      # 00476d76
    {load} sub edi, ecx                          # 00476d78
    {load} mov esi, edi                          # 00476d7a
    {load} mov eax, ecx                          # 00476d7c
    {load} mov edi, edx                          # 00476d7e
    shr ecx, 0x2                                 # 00476d80
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00476d83
    {load} mov ecx, eax                          # 00476d85
    and ecx, 0x3                                 # 00476d87
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00476d8a
    mov edi, 0x63a880                            # 00476d8c
    mov ecx, dword ptr [ebp - local_30]          # 00476d91
    add ecx, 0x804                               # 00476d94
    {load} mov edx, ecx                          # 00476d9a
    or ecx, -0x1                                 # 00476d9c
    {load} xor eax, eax                          # 00476d9f
    repne scasb al, byte ptr es:[edi]            # 00476da1
    not ecx                                      # 00476da3
    {load} sub edi, ecx                          # 00476da5
    {load} mov esi, edi                          # 00476da7
    {load} mov eax, ecx                          # 00476da9
    {load} mov edi, edx                          # 00476dab
    shr ecx, 0x2                                 # 00476dad
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00476db0
    {load} mov ecx, eax                          # 00476db2
    and ecx, 0x3                                 # 00476db4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00476db7
    mov ecx, dword ptr [ebp - local_4]           # 00476db9
    mov edx, dword ptr [ecx + field_640]         # 00476dbc
    push edx                                     # 00476dc2
    push 0x54c918                                # 00476dc3
    mov eax, dword ptr [ebp - local_30]          # 00476dc8
    add eax, 0x877                               # 00476dcb
    push eax                                     # 00476dd0
    call FUN_0050ca3e                            # 00476dd1
    add esp, 0xc                                 # 00476dd6
    mov ecx, dword ptr [ebp - local_30]          # 00476dd9
    mov dword ptr [ecx + field_1c], 0x0          # 00476ddc
    mov edx, dword ptr [ebp - local_30]          # 00476de3
    mov dword ptr [edx + field_89e], 0x0         # 00476de6
    mov eax, dword ptr [ebp - local_30]          # 00476df0
    mov dword ptr [eax + field_2c], 0x0          # 00476df3
    mov ecx, dword ptr [ebp - local_30]          # 00476dfa
    movsx edx, word ptr [ecx + field_22]         # 00476dfd
    imul edx, edx, 0x8d                          # 00476e01
    mov dword ptr [edx + 0x5bb632], 0x1          # 00476e07
    jmp.d32 L_004778ab                           # 00476e11
L_00476e16:
    # block 0x00476e16: entered by je at 0x00476a60, 5 instruction(s), ends with ja to 0x004775ff (forward)
    mov eax, dword ptr [ebp - local_30]          # 00476e16
    mov ecx, dword ptr [eax + field_2c]          # 00476e19
    mov dword ptr [ebp - local_38], ecx          # 00476e1c
    cmp dword ptr [ebp - local_38], 0x6          # 00476e1f
    ja.d32 L_004775ff                            # 00476e23
    # block 0x00476e29: entered by fall-through of ja at 0x00476e23, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4778b3]
    mov edx, dword ptr [ebp - local_38]          # 00476e29
    jmp dword ptr [4*edx + SWTAB_004778b3_VA]    # 00476e2c
L_00476e33:
    # block 0x00476e33: entered by switch case, 5 instruction(s), ends with je to 0x00476f7d (forward)
    mov eax, dword ptr [ebp - local_30]          # 00476e33
    {load} xor ecx, ecx                          # 00476e36
    mov cl, byte ptr [eax + field_8d8]           # 00476e38
    test ecx, ecx                                # 00476e3e
    je.d32 L_00476f7d                            # 00476e40
    # block 0x00476e46: entered by fall-through of je at 0x00476e40, 3 instruction(s), ends with je to 0x00476e5e (forward)
    movsx edx, word ptr [0x63a4cd]               # 00476e46
    test edx, edx                                # 00476e4d
    je.d8 L_00476e5e                             # 00476e4f
    # block 0x00476e51: entered by fall-through of je at 0x00476e4f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00476e5e
    push 0x54c91c                                # 00476e51
    call FUN_0044a2b7                            # 00476e56
    add esp, 0x4                                 # 00476e5b
L_00476e5e:
    # block 0x00476e5e: entered by je at 0x00476e4f, 12 instruction(s), calls FUN_004763b3, ends with jne to 0x00476e99 (forward)
    mov eax, dword ptr [ebp - local_30]          # 00476e5e
    mov ecx, dword ptr [eax + field_8aa]         # 00476e61
    push ecx                                     # 00476e67
    mov edx, dword ptr [eax + field_8a6]         # 00476e68
    push edx                                     # 00476e6e
    mov ecx, dword ptr [ebp - local_30]          # 00476e6f
    call FUN_004763b3                            # 00476e72
    mov eax, dword ptr [ebp - local_30]          # 00476e77
    {load} xor ecx, ecx                          # 00476e7a
    mov cl, byte ptr [eax + field_8d6]           # 00476e7c
    test ecx, ecx                                # 00476e82
    jne.d8 L_00476e99                            # 00476e84
    # block 0x00476e86: entered by fall-through of jne at 0x00476e84, 5 instruction(s), ends with je to 0x00476f6e (forward)
    mov edx, dword ptr [ebp - local_30]          # 00476e86
    {load} xor eax, eax                          # 00476e89
    mov al, byte ptr [edx + field_8d7]           # 00476e8b
    test eax, eax                                # 00476e91
    je.d32 L_00476f6e                            # 00476e93
L_00476e99:
    # block 0x00476e99: entered by jne at 0x00476e84; fall-through of je at 0x00476e93, 59 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00476f6e
    mov ecx, dword ptr [ebp - local_30]          # 00476e99
    mov dword ptr [ecx + field_2c], 0x2          # 00476e9c
    call dword ptr [0x52a23c]                    # 00476ea3
    add eax, 0x320                               # 00476ea9
    mov edx, dword ptr [ebp - local_30]          # 00476eae
    mov dword ptr [edx + field_8a2], eax         # 00476eb1
    mov eax, dword ptr [ebp - local_30]          # 00476eb7
    mov ecx, dword ptr [eax + field_8aa]         # 00476eba
    imul ecx, ecx, 0xc8                          # 00476ec0
    mov edx, dword ptr [ebp - local_30]          # 00476ec6
    lea eax, [edx + ecx + field_30]              # 00476ec9
    mov ecx, dword ptr [ebp - local_30]          # 00476ecd
    mov edx, dword ptr [ecx + field_8a6]         # 00476ed0
    imul edx, edx, 0x14                          # 00476ed6
    movsx eax, word ptr [eax + edx + field_2]    # 00476ed9
    imul eax, eax, 0x21                          # 00476ede
    mov ecx, dword ptr [ebp - local_4]           # 00476ee1
    lea edx, [ecx + eax + field_25f]             # 00476ee4
    {load} mov edi, edx                          # 00476eeb
    mov eax, dword ptr [ebp - local_30]          # 00476eed
    add eax, 0x804                               # 00476ef0
    {load} mov edx, eax                          # 00476ef5
    or ecx, -0x1                                 # 00476ef7
    {load} xor eax, eax                          # 00476efa
    repne scasb al, byte ptr es:[edi]            # 00476efc
    not ecx                                      # 00476efe
    {load} sub edi, ecx                          # 00476f00
    {load} mov esi, edi                          # 00476f02
    {load} mov eax, ecx                          # 00476f04
    {load} mov edi, edx                          # 00476f06
    shr ecx, 0x2                                 # 00476f08
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00476f0b
    {load} mov ecx, eax                          # 00476f0d
    and ecx, 0x3                                 # 00476f0f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00476f12
    mov ecx, dword ptr [ebp - local_30]          # 00476f14
    mov edx, dword ptr [ecx + field_8aa]         # 00476f17
    imul edx, edx, 0xc8                          # 00476f1d
    mov eax, dword ptr [ebp - local_30]          # 00476f23
    lea ecx, [eax + edx + field_30]              # 00476f26
    mov edx, dword ptr [ebp - local_30]          # 00476f2a
    mov eax, dword ptr [edx + field_8a6]         # 00476f2d
    imul eax, eax, 0x14                          # 00476f33
    movsx ecx, word ptr [ecx + eax + field_2]    # 00476f36
    shl ecx, 0x4                                 # 00476f3b
    mov edx, dword ptr [ebp - local_4]           # 00476f3e
    lea eax, [edx + ecx + field_58]              # 00476f41
    mov ecx, dword ptr [ebp - local_30]          # 00476f45
    add ecx, 0x825                               # 00476f48
    mov edx, dword ptr [eax]                     # 00476f4e
    mov dword ptr [ecx], edx                     # 00476f50
    mov edx, dword ptr [eax + field_4]           # 00476f52
    mov dword ptr [ecx + field_4], edx           # 00476f55
    mov edx, dword ptr [eax + field_8]           # 00476f58
    mov dword ptr [ecx + field_8], edx           # 00476f5b
    mov eax, dword ptr [eax + field_c]           # 00476f5e
    mov dword ptr [ecx + field_c], eax           # 00476f61
    mov ecx, dword ptr [ebp - local_30]          # 00476f64
    mov byte ptr [ecx + field_800], 0x1          # 00476f67
L_00476f6e:
    # block 0x00476f6e: entered by je at 0x00476e93, 3 instruction(s), ends with forward jump to 0x004771dc
    mov edx, dword ptr [ebp - local_30]          # 00476f6e
    mov byte ptr [edx + field_8d8], 0x0          # 00476f71
    jmp.d32 L_004771dc                           # 00476f78
L_00476f7d:
    # block 0x00476f7d: entered by je at 0x00476e40, 5 instruction(s), ends with je to 0x004770c7 (forward)
    mov eax, dword ptr [ebp - local_30]          # 00476f7d
    {load} xor ecx, ecx                          # 00476f80
    mov cl, byte ptr [eax + field_8d9]           # 00476f82
    test ecx, ecx                                # 00476f88
    je.d32 L_004770c7                            # 00476f8a
    # block 0x00476f90: entered by fall-through of je at 0x00476f8a, 3 instruction(s), ends with je to 0x00476fa8 (forward)
    movsx edx, word ptr [0x63a4cd]               # 00476f90
    test edx, edx                                # 00476f97
    je.d8 L_00476fa8                             # 00476f99
    # block 0x00476f9b: entered by fall-through of je at 0x00476f99, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00476fa8
    push 0x54c938                                # 00476f9b
    call FUN_0044a2b7                            # 00476fa0
    add esp, 0x4                                 # 00476fa5
L_00476fa8:
    # block 0x00476fa8: entered by je at 0x00476f99, 12 instruction(s), calls FUN_004763b3, ends with jne to 0x00476fe3 (forward)
    mov eax, dword ptr [ebp - local_30]          # 00476fa8
    mov ecx, dword ptr [eax + field_8b2]         # 00476fab
    push ecx                                     # 00476fb1
    mov edx, dword ptr [eax + field_8ae]         # 00476fb2
    push edx                                     # 00476fb8
    mov ecx, dword ptr [ebp - local_30]          # 00476fb9
    call FUN_004763b3                            # 00476fbc
    mov eax, dword ptr [ebp - local_30]          # 00476fc1
    {load} xor ecx, ecx                          # 00476fc4
    mov cl, byte ptr [eax + field_8d6]           # 00476fc6
    test ecx, ecx                                # 00476fcc
    jne.d8 L_00476fe3                            # 00476fce
    # block 0x00476fd0: entered by fall-through of jne at 0x00476fce, 5 instruction(s), ends with je to 0x004770b8 (forward)
    mov edx, dword ptr [ebp - local_30]          # 00476fd0
    {load} xor eax, eax                          # 00476fd3
    mov al, byte ptr [edx + field_8d7]           # 00476fd5
    test eax, eax                                # 00476fdb
    je.d32 L_004770b8                            # 00476fdd
L_00476fe3:
    # block 0x00476fe3: entered by jne at 0x00476fce; fall-through of je at 0x00476fdd, 59 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004770b8
    mov ecx, dword ptr [ebp - local_30]          # 00476fe3
    mov dword ptr [ecx + field_2c], 0x2          # 00476fe6
    call dword ptr [0x52a23c]                    # 00476fed
    add eax, 0x320                               # 00476ff3
    mov edx, dword ptr [ebp - local_30]          # 00476ff8
    mov dword ptr [edx + field_8a2], eax         # 00476ffb
    mov eax, dword ptr [ebp - local_30]          # 00477001
    mov ecx, dword ptr [eax + field_8b2]         # 00477004
    imul ecx, ecx, 0xc8                          # 0047700a
    mov edx, dword ptr [ebp - local_30]          # 00477010
    lea eax, [edx + ecx + field_30]              # 00477013
    mov ecx, dword ptr [ebp - local_30]          # 00477017
    mov edx, dword ptr [ecx + field_8ae]         # 0047701a
    imul edx, edx, 0x14                          # 00477020
    movsx eax, word ptr [eax + edx + field_2]    # 00477023
    imul eax, eax, 0x21                          # 00477028
    mov ecx, dword ptr [ebp - local_4]           # 0047702b
    lea edx, [ecx + eax + field_25f]             # 0047702e
    {load} mov edi, edx                          # 00477035
    mov eax, dword ptr [ebp - local_30]          # 00477037
    add eax, 0x804                               # 0047703a
    {load} mov edx, eax                          # 0047703f
    or ecx, -0x1                                 # 00477041
    {load} xor eax, eax                          # 00477044
    repne scasb al, byte ptr es:[edi]            # 00477046
    not ecx                                      # 00477048
    {load} sub edi, ecx                          # 0047704a
    {load} mov esi, edi                          # 0047704c
    {load} mov eax, ecx                          # 0047704e
    {load} mov edi, edx                          # 00477050
    shr ecx, 0x2                                 # 00477052
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00477055
    {load} mov ecx, eax                          # 00477057
    and ecx, 0x3                                 # 00477059
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047705c
    mov ecx, dword ptr [ebp - local_30]          # 0047705e
    mov edx, dword ptr [ecx + field_8b2]         # 00477061
    imul edx, edx, 0xc8                          # 00477067
    mov eax, dword ptr [ebp - local_30]          # 0047706d
    lea ecx, [eax + edx + field_30]              # 00477070
    mov edx, dword ptr [ebp - local_30]          # 00477074
    mov eax, dword ptr [edx + field_8ae]         # 00477077
    imul eax, eax, 0x14                          # 0047707d
    movsx ecx, word ptr [ecx + eax + field_2]    # 00477080
    shl ecx, 0x4                                 # 00477085
    mov edx, dword ptr [ebp - local_4]           # 00477088
    lea eax, [edx + ecx + field_58]              # 0047708b
    mov ecx, dword ptr [ebp - local_30]          # 0047708f
    add ecx, 0x825                               # 00477092
    mov edx, dword ptr [eax]                     # 00477098
    mov dword ptr [ecx], edx                     # 0047709a
    mov edx, dword ptr [eax + field_4]           # 0047709c
    mov dword ptr [ecx + field_4], edx           # 0047709f
    mov edx, dword ptr [eax + field_8]           # 004770a2
    mov dword ptr [ecx + field_8], edx           # 004770a5
    mov eax, dword ptr [eax + field_c]           # 004770a8
    mov dword ptr [ecx + field_c], eax           # 004770ab
    mov ecx, dword ptr [ebp - local_30]          # 004770ae
    mov byte ptr [ecx + field_800], 0x1          # 004770b1
L_004770b8:
    # block 0x004770b8: entered by je at 0x00476fdd, 3 instruction(s), ends with forward jump to 0x004771dc
    mov edx, dword ptr [ebp - local_30]          # 004770b8
    mov byte ptr [edx + field_8d9], 0x0          # 004770bb
    jmp.d32 L_004771dc                           # 004770c2
L_004770c7:
    # block 0x004770c7: entered by je at 0x00476f8a, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0047712c (forward)
    call dword ptr [0x52a23c]                    # 004770c7
    mov ecx, dword ptr [ebp - local_30]          # 004770cd
    mov edx, dword ptr [ecx + field_8c6]         # 004770d0
    {load} sub edx, eax                          # 004770d6
    mov dword ptr [ebp - local_1c], edx          # 004770d8
    mov eax, dword ptr [ebp - local_4]           # 004770db
    movsx ecx, word ptr [eax + field_63e]        # 004770de
    test ecx, ecx                                # 004770e5
    je.d8 L_0047712c                             # 004770e7
    # block 0x004770e9: entered by fall-through of je at 0x004770e7, 22 instruction(s), calls FUN_0050ca3e, falls into the block at 0x0047712c
    mov eax, dword ptr [ebp - local_1c]          # 004770e9
    {load} xor edx, edx                          # 004770ec
    mov ecx, 0x3e8                               # 004770ee
    div ecx                                      # 004770f3
    {load} xor edx, edx                          # 004770f5
    mov ecx, 0x3c                                # 004770f7
    div ecx                                      # 004770fc
    push edx                                     # 004770fe
    mov eax, dword ptr [ebp - local_1c]          # 004770ff
    {load} xor edx, edx                          # 00477102
    mov ecx, 0xea60                              # 00477104
    div ecx                                      # 00477109
    {load} xor edx, edx                          # 0047710b
    mov ecx, 0x3c                                # 0047710d
    div ecx                                      # 00477112
    push edx                                     # 00477114
    push 0x54c954                                # 00477115
    mov edx, dword ptr [ebp - local_30]          # 0047711a
    add edx, 0x856                               # 0047711d
    push edx                                     # 00477123
    call FUN_0050ca3e                            # 00477124
    add esp, 0x10                                # 00477129
L_0047712c:
    # block 0x0047712c: entered by je at 0x004770e7, 4 instruction(s), ends with jle to 0x00477143 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047712c
    movsx ecx, word ptr [eax + field_63e]        # 0047712f
    test ecx, ecx                                # 00477136
    jle.d8 L_00477143                            # 00477138
    # block 0x0047713a: entered by fall-through of jle at 0x00477138, 2 instruction(s), ends with jb to 0x0047715b (forward)
    cmp dword ptr [ebp - local_1c], 0x1f4        # 0047713a
    jb.d8 L_0047715b                             # 00477141
L_00477143:
    # block 0x00477143: entered by jle at 0x00477138; fall-through of jb at 0x00477141, 5 instruction(s), ends with jl to 0x004771dc (forward)
    mov edx, dword ptr [ebp - local_30]          # 00477143
    mov eax, dword ptr [ebp - local_4]           # 00477146
    mov ecx, dword ptr [edx + field_8c2]         # 00477149
    cmp ecx, dword ptr [eax + field_640]         # 0047714f
    jl.d32 L_004771dc                            # 00477155
L_0047715b:
    # block 0x0047715b: entered by jb at 0x00477141; fall-through of jl at 0x00477155, 7 instruction(s), ends with jl to 0x004771b1 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047715b
    mov dword ptr [edx + field_2c], 0x1          # 0047715e
    mov eax, dword ptr [ebp - local_30]          # 00477165
    mov ecx, dword ptr [ebp - local_4]           # 00477168
    mov edx, dword ptr [eax + field_8c2]         # 0047716b
    cmp edx, dword ptr [ecx + field_640]         # 00477171
    jl.d8 L_004771b1                             # 00477177
    # block 0x00477179: entered by fall-through of jl at 0x00477177, 20 instruction(s), ends with forward jump to 0x004771dc
    mov edi, 0x54c960                            # 00477179
    mov eax, dword ptr [ebp - local_30]          # 0047717e
    add eax, 0x856                               # 00477181
    {load} mov edx, eax                          # 00477186
    or ecx, -0x1                                 # 00477188
    {load} xor eax, eax                          # 0047718b
    repne scasb al, byte ptr es:[edi]            # 0047718d
    not ecx                                      # 0047718f
    {load} sub edi, ecx                          # 00477191
    {load} mov esi, edi                          # 00477193
    {load} mov eax, ecx                          # 00477195
    {load} mov edi, edx                          # 00477197
    shr ecx, 0x2                                 # 00477199
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047719c
    {load} mov ecx, eax                          # 0047719e
    and ecx, 0x3                                 # 004771a0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004771a3
    mov ecx, dword ptr [ebp - local_30]          # 004771a5
    mov dword ptr [ecx + field_1c], 0x1          # 004771a8
    jmp.d8 L_004771dc                            # 004771af
L_004771b1:
    # block 0x004771b1: entered by jl at 0x00477177, 16 instruction(s), falls into the block at 0x004771dc
    mov edi, 0x54c968                            # 004771b1
    mov edx, dword ptr [ebp - local_30]          # 004771b6
    add edx, 0x856                               # 004771b9
    or ecx, -0x1                                 # 004771bf
    {load} xor eax, eax                          # 004771c2
    repne scasb al, byte ptr es:[edi]            # 004771c4
    not ecx                                      # 004771c6
    {load} sub edi, ecx                          # 004771c8
    {load} mov esi, edi                          # 004771ca
    {load} mov eax, ecx                          # 004771cc
    {load} mov edi, edx                          # 004771ce
    shr ecx, 0x2                                 # 004771d0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004771d3
    {load} mov ecx, eax                          # 004771d5
    and ecx, 0x3                                 # 004771d7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004771da
L_004771dc:
    # block 0x004771dc: entered by jmp at 0x00476f78; jmp at 0x004770c2; jl at 0x00477155; jmp at 0x004771af, 1 instruction(s), ends with forward jump to 0x004775ff
    jmp.d32 L_004775ff                           # 004771dc
L_004771e1:
    # block 0x004771e1: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0047721e (forward)
    call dword ptr [0x52a23c]                    # 004771e1
    mov ecx, dword ptr [ebp - local_30]          # 004771e7
    cmp eax, dword ptr [ecx + field_8ca]         # 004771ea
    jb.d8 L_0047721e                             # 004771f0
    # block 0x004771f2: entered by fall-through of jb at 0x004771f0, 11 instruction(s), calls FUN_00475a1e, falls into the block at 0x0047721e
    push 0x0                                     # 004771f2
    push 0x0                                     # 004771f4
    push 0x1                                     # 004771f6
    mov ecx, dword ptr [ebp - local_30]          # 004771f8
    call FUN_00475a1e                            # 004771fb
    mov edx, dword ptr [ebp - local_30]          # 00477200
    mov byte ptr [edx + field_898], 0x0          # 00477203
    mov eax, dword ptr [ebp - local_30]          # 0047720a
    mov byte ptr [eax + field_899], 0x1          # 0047720d
    mov ecx, dword ptr [ebp - local_30]          # 00477214
    mov dword ptr [ecx + field_2c], 0x0          # 00477217
L_0047721e:
    # block 0x0047721e: entered by jb at 0x004771f0, 1 instruction(s), ends with forward jump to 0x004775ff
    jmp.d32 L_004775ff                           # 0047721e
L_00477223:
    # block 0x00477223: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00477325 (forward)
    call dword ptr [0x52a23c]                    # 00477223
    mov edx, dword ptr [ebp - local_30]          # 00477229
    cmp eax, dword ptr [edx + field_8a2]         # 0047722c
    jb.d32 L_00477325                            # 00477232
    # block 0x00477238: entered by fall-through of jb at 0x00477232, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00477325 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00477238
    movsx ecx, word ptr [eax + field_70b]        # 0047723b
    mov dword ptr [ebp - local_20], ecx          # 00477242
    mov edx, dword ptr [ebp - local_20]          # 00477245
    push edx                                     # 00477248
    mov ecx, 0x5cf1eb                            # 00477249
    call FUN_004f6334                            # 0047724e
    test eax, eax                                # 00477253
    jne.d32 L_00477325                           # 00477255
    # block 0x0047725b: entered by fall-through of jne at 0x00477255, 25 instruction(s), ends with forward jump to 0x004772ba
    mov eax, dword ptr [ebp - local_30]          # 0047725b
    mov dword ptr [eax + field_2c], 0x0          # 0047725e
    mov edi, 0x63a884                            # 00477265
    mov ecx, dword ptr [ebp - local_30]          # 0047726a
    add ecx, 0x804                               # 0047726d
    {load} mov edx, ecx                          # 00477273
    or ecx, -0x1                                 # 00477275
    {load} xor eax, eax                          # 00477278
    repne scasb al, byte ptr es:[edi]            # 0047727a
    not ecx                                      # 0047727c
    {load} sub edi, ecx                          # 0047727e
    {load} mov esi, edi                          # 00477280
    {load} mov eax, ecx                          # 00477282
    {load} mov edi, edx                          # 00477284
    shr ecx, 0x2                                 # 00477286
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00477289
    {load} mov ecx, eax                          # 0047728b
    and ecx, 0x3                                 # 0047728d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00477290
    mov ecx, dword ptr [ebp - local_30]          # 00477292
    mov byte ptr [ecx + field_800], 0x0          # 00477295
    mov edx, dword ptr [ebp - local_30]          # 0047729c
    mov byte ptr [edx + field_803], 0x1          # 0047729f
    mov word ptr [ebp - local_8], 0x0            # 004772a6
    jmp.d8 L_004772ba                            # 004772ac
L_004772ae:
    # block 0x004772ae: entered by jmp at 0x00477321, 3 instruction(s), falls into the block at 0x004772ba
    mov ax, word ptr [ebp - local_8]             # 004772ae
    .insn 0x66, 0x05, 0x0001{:u16}               # 004772b2
    mov word ptr [ebp - local_8], ax             # 004772b6
L_004772ba:
    # block 0x004772ba: entered by jmp at 0x004772ac, 5 instruction(s), ends with jge to 0x00477323 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004772ba
    mov edx, dword ptr [ebp - local_4]           # 004772be
    movsx eax, word ptr [edx + field_42]         # 004772c1
    {load} cmp ecx, eax                          # 004772c5
    jge.d8 L_00477323                            # 004772c7
    # block 0x004772c9: entered by fall-through of jge at 0x004772c7, 2 instruction(s), ends with forward jump to 0x004772dd
    mov word ptr [ebp - local_14], 0x0           # 004772c9
    jmp.d8 L_004772dd                            # 004772cf
L_004772d1:
    # block 0x004772d1: entered by jmp at 0x0047731f, 3 instruction(s), falls into the block at 0x004772dd
    mov cx, word ptr [ebp - local_14]            # 004772d1
    add cx, 0x1                                  # 004772d5
    mov word ptr [ebp - local_14], cx            # 004772d9
L_004772dd:
    # block 0x004772dd: entered by jmp at 0x004772cf, 5 instruction(s), ends with jge to 0x00477321 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004772dd
    mov eax, dword ptr [ebp - local_4]           # 004772e1
    movsx ecx, word ptr [eax + field_44]         # 004772e4
    {load} cmp edx, ecx                          # 004772e8
    jge.d8 L_00477321                            # 004772ea
    # block 0x004772ec: entered by fall-through of jge at 0x004772ea, 8 instruction(s), ends with jne to 0x0047731f (forward)
    movsx edx, word ptr [ebp - local_8]          # 004772ec
    imul edx, edx, 0xc8                          # 004772f0
    movsx eax, word ptr [ebp - local_14]         # 004772f6
    imul eax, eax, 0x14                          # 004772fa
    {load} xor ecx, ecx                          # 004772fd
    mov cl, byte ptr [edx + eax + 0x622fd3]      # 004772ff
    cmp ecx, 0x1                                 # 00477306
    jne.d8 L_0047731f                            # 00477309
    # block 0x0047730b: entered by fall-through of jne at 0x00477309, 7 instruction(s), calls FUN_00475a1e, falls into the block at 0x0047731f
    mov dx, word ptr [ebp - local_14]            # 0047730b
    push edx                                     # 0047730f
    mov ax, word ptr [ebp - local_8]             # 00477310
    push eax                                     # 00477314
    push 0x0                                     # 00477315
    mov ecx, dword ptr [ebp - local_30]          # 00477317
    call FUN_00475a1e                            # 0047731a
L_0047731f:
    # block 0x0047731f: entered by jne at 0x00477309, 1 instruction(s), ends with backward jump to 0x004772d1
    jmp.d8 L_004772d1                            # 0047731f
L_00477321:
    # block 0x00477321: entered by jge at 0x004772ea, 1 instruction(s), ends with backward jump to 0x004772ae
    jmp.d8 L_004772ae                            # 00477321
L_00477323:
    # block 0x00477323: entered by jge at 0x004772c7, 1 instruction(s), ends with forward jump to 0x00477391
    jmp.d8 L_00477391                            # 00477323
L_00477325:
    # block 0x00477325: entered by jb at 0x00477232; jne at 0x00477255, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00477391 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00477325
    movsx edx, word ptr [ecx + field_70b]        # 00477328
    mov dword ptr [ebp - local_24], edx          # 0047732f
    mov eax, dword ptr [ebp - local_24]          # 00477332
    push eax                                     # 00477335
    mov ecx, 0x5cf1eb                            # 00477336
    call FUN_004f6334                            # 0047733b
    test eax, eax                                # 00477340
    jne.d8 L_00477391                            # 00477342
    # block 0x00477344: entered by fall-through of jne at 0x00477342, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00477391 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00477344
    movsx edx, word ptr [ecx + field_70b]        # 00477347
    mov dword ptr [ebp - local_28], edx          # 0047734e
    mov eax, dword ptr [ebp - local_28]          # 00477351
    push eax                                     # 00477354
    mov ecx, 0x5cf1eb                            # 00477355
    call FUN_004f6334                            # 0047735a
    test eax, eax                                # 0047735f
    jne.d8 L_00477391                            # 00477361
    # block 0x00477363: entered by fall-through of jne at 0x00477361, 7 instruction(s), ends with je to 0x00477391 (forward)
    mov edi, 0x54c970                            # 00477363
    mov esi, dword ptr [ebp - local_4]           # 00477368
    add esi, 0x6ea                               # 0047736b
    mov ecx, 0x9                                 # 00477371
    {load} xor edx, edx                          # 00477376
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477378
    je.d8 L_00477391                             # 0047737a
    # block 0x0047737c: entered by fall-through of je at 0x0047737a, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00477391
    mov eax, dword ptr [ebp - local_4]           # 0047737c
    mov cx, word ptr [eax + field_70b]           # 0047737f
    push ecx                                     # 00477386
    mov ecx, 0x5c3a67                            # 00477387
    call FUN_004fb2e3                            # 0047738c
L_00477391:
    # block 0x00477391: entered by jmp at 0x00477323; jne at 0x00477342; jne at 0x00477361; je at 0x0047737a, 1 instruction(s), ends with forward jump to 0x004775ff
    jmp.d32 L_004775ff                           # 00477391
L_00477396:
    # block 0x00477396: entered by switch case, 7 instruction(s), ends with je to 0x004773d7 (forward)
    mov edi, 0x54c97c                            # 00477396
    mov esi, dword ptr [ebp - local_4]           # 0047739b
    add esi, 0x798                               # 0047739e
    mov ecx, 0x9                                 # 004773a4
    {load} xor edx, edx                          # 004773a9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004773ab
    je.d8 L_004773d7                             # 004773ad
    # block 0x004773af: entered by fall-through of je at 0x004773ad, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004773d7
    mov eax, dword ptr [ebp - local_4]           # 004773af
    add eax, 0x798                               # 004773b2
    push eax                                     # 004773b7
    mov ecx, 0x5c3a67                            # 004773b8
    call FUN_004fb77a                            # 004773bd
    mov ecx, dword ptr [ebp - local_4]           # 004773c2
    mov dx, word ptr [ecx + field_7b9]           # 004773c5
    push edx                                     # 004773cc
    mov ecx, 0x5c3a67                            # 004773cd
    call FUN_004fb2e3                            # 004773d2
L_004773d7:
    # block 0x004773d7: entered by je at 0x004773ad, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004775ff
    call dword ptr [0x52a23c]                    # 004773d7
    mov ecx, dword ptr [ebp - local_4]           # 004773dd
    movsx edx, word ptr [ecx + field_796]        # 004773e0
    imul edx, edx, 0x3e8                         # 004773e7
    {load} add eax, edx                          # 004773ed
    mov ecx, dword ptr [ebp - local_30]          # 004773ef
    mov dword ptr [ecx + field_8a2], eax         # 004773f2
    mov edx, dword ptr [ebp - local_30]          # 004773f8
    mov dword ptr [edx + field_2c], 0x5          # 004773fb
    jmp.d32 L_004775ff                           # 00477402
L_00477407:
    # block 0x00477407: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00477422 (forward)
    call dword ptr [0x52a23c]                    # 00477407
    mov ecx, dword ptr [ebp - local_30]          # 0047740d
    cmp eax, dword ptr [ecx + field_8a2]         # 00477410
    jb.d8 L_00477422                             # 00477416
    # block 0x00477418: entered by fall-through of jb at 0x00477416, 2 instruction(s), falls into the block at 0x00477422
    mov edx, dword ptr [ebp - local_30]          # 00477418
    mov dword ptr [edx + field_2c], 0x4          # 0047741b
L_00477422:
    # block 0x00477422: entered by jb at 0x00477416, 1 instruction(s), ends with forward jump to 0x004775ff
    jmp.d32 L_004775ff                           # 00477422
L_00477427:
    # block 0x00477427: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00477459 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00477427
    movsx ecx, word ptr [eax + field_7b9]        # 0047742a
    mov dword ptr [ebp - local_2c], ecx          # 00477431
    mov edx, dword ptr [ebp - local_2c]          # 00477434
    push edx                                     # 00477437
    mov ecx, 0x5cf1eb                            # 00477438
    call FUN_004f6334                            # 0047743d
    test eax, eax                                # 00477442
    jne.d8 L_00477459                            # 00477444
    # block 0x00477446: entered by fall-through of jne at 0x00477444, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00477459
    mov eax, dword ptr [ebp - local_4]           # 00477446
    add eax, 0x798                               # 00477449
    push eax                                     # 0047744e
    mov ecx, 0x5c3a67                            # 0047744f
    call FUN_004fba69                            # 00477454
L_00477459:
    # block 0x00477459: entered by jne at 0x00477444, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004775ff
    call dword ptr [0x52a23c]                    # 00477459
    mov ecx, dword ptr [ebp - local_4]           # 0047745f
    movsx edx, word ptr [ecx + field_6e8]        # 00477462
    imul edx, edx, 0x3e8                         # 00477469
    {load} add eax, edx                          # 0047746f
    mov ecx, dword ptr [ebp - local_30]          # 00477471
    mov dword ptr [ecx + field_8a2], eax         # 00477474
    mov edx, dword ptr [ebp - local_30]          # 0047747a
    mov dword ptr [edx + field_2c], 0x6          # 0047747d
    mov eax, dword ptr [ebp - local_30]          # 00477484
    mov byte ptr [eax + field_802], 0x1          # 00477487
    jmp.d32 L_004775ff                           # 0047748e
L_00477493:
    # block 0x00477493: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004775d1 (forward)
    call dword ptr [0x52a23c]                    # 00477493
    mov ecx, dword ptr [ebp - local_30]          # 00477499
    cmp eax, dword ptr [ecx + field_8a2]         # 0047749c
    jb.d32 L_004775d1                            # 004774a2
    # block 0x004774a8: entered by fall-through of jb at 0x004774a2, 5 instruction(s), ends with forward jump to 0x004774c8
    mov edx, dword ptr [ebp - local_30]          # 004774a8
    mov eax, dword ptr [edx + field_8c2]         # 004774ab
    mov dword ptr [ebp - local_10], eax          # 004774b1
    mov word ptr [ebp - local_c], 0x0            # 004774b4
    jmp.d8 L_004774c8                            # 004774ba
L_004774bc:
    # block 0x004774bc: entered by jmp at 0x0047750d, 3 instruction(s), falls into the block at 0x004774c8
    mov cx, word ptr [ebp - local_c]             # 004774bc
    add cx, 0x1                                  # 004774c0
    mov word ptr [ebp - local_c], cx             # 004774c4
L_004774c8:
    # block 0x004774c8: entered by jmp at 0x004774ba, 3 instruction(s), ends with jge to 0x0047750f (forward)
    movsx edx, word ptr [ebp - local_c]          # 004774c8
    cmp edx, 0x5                                 # 004774cc
    jge.d8 L_0047750f                            # 004774cf
    # block 0x004774d1: entered by fall-through of jge at 0x004774cf, 4 instruction(s), ends with jle to 0x0047750d (forward)
    movsx eax, word ptr [ebp - local_c]          # 004774d1
    mov ecx, dword ptr [ebp - local_10]          # 004774d5
    cmp ecx, dword ptr [4*eax + 0x5a0549]        # 004774d8
    jle.d8 L_0047750d                            # 004774df
    # block 0x004774e1: entered by fall-through of jle at 0x004774df, 10 instruction(s), falls into the block at 0x0047750d
    movsx edx, word ptr [ebp - local_c]          # 004774e1
    mov eax, dword ptr [4*edx + 0x5a0549]        # 004774e5
    mov dword ptr [ebp - local_18], eax          # 004774ec
    movsx ecx, word ptr [ebp - local_c]          # 004774ef
    mov edx, dword ptr [ebp - local_10]          # 004774f3
    mov dword ptr [4*ecx + 0x5a0549], edx        # 004774f6
    mov eax, dword ptr [ebp - local_18]          # 004774fd
    mov dword ptr [ebp - local_10], eax          # 00477500
    mov ecx, dword ptr [ebp - local_30]          # 00477503
    mov byte ptr [ecx + field_802], 0x1          # 00477506
L_0047750d:
    # block 0x0047750d: entered by jle at 0x004774df, 1 instruction(s), ends with backward jump to 0x004774bc
    jmp.d8 L_004774bc                            # 0047750d
L_0047750f:
    # block 0x0047750f: entered by jge at 0x004774cf, 3 instruction(s), ends with jne to 0x004775ba (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047750f
    cmp dword ptr [edx + field_1c], 0x0          # 00477512
    jne.d32 L_004775ba                           # 00477516
    # block 0x0047751c: entered by fall-through of jne at 0x00477516, 48 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004775d1
    mov eax, dword ptr [ebp - local_30]          # 0047751c
    mov dword ptr [eax + field_2c], 0x0          # 0047751f
    mov ecx, dword ptr [ebp - local_30]          # 00477526
    mov dword ptr [ecx + field_8c2], 0x0         # 00477529
    mov edx, dword ptr [ebp - local_4]           # 00477533
    movsx esi, word ptr [edx + field_63e]        # 00477536
    imul esi, esi, 0x3e8                         # 0047753d
    call dword ptr [0x52a23c]                    # 00477543
    {load} add esi, eax                          # 00477549
    mov eax, dword ptr [ebp - local_30]          # 0047754b
    mov dword ptr [eax + field_8c6], esi         # 0047754e
    mov edi, 0x54c988                            # 00477554
    mov ecx, dword ptr [ebp - local_30]          # 00477559
    add ecx, 0x835                               # 0047755c
    {load} mov edx, ecx                          # 00477562
    or ecx, -0x1                                 # 00477564
    {load} xor eax, eax                          # 00477567
    repne scasb al, byte ptr es:[edi]            # 00477569
    not ecx                                      # 0047756b
    {load} sub edi, ecx                          # 0047756d
    {load} mov esi, edi                          # 0047756f
    {load} mov eax, ecx                          # 00477571
    {load} mov edi, edx                          # 00477573
    shr ecx, 0x2                                 # 00477575
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00477578
    {load} mov ecx, eax                          # 0047757a
    and ecx, 0x3                                 # 0047757c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047757f
    mov edi, 0x63a888                            # 00477581
    mov ecx, dword ptr [ebp - local_30]          # 00477586
    add ecx, 0x856                               # 00477589
    {load} mov edx, ecx                          # 0047758f
    or ecx, -0x1                                 # 00477591
    {load} xor eax, eax                          # 00477594
    repne scasb al, byte ptr es:[edi]            # 00477596
    not ecx                                      # 00477598
    {load} sub edi, ecx                          # 0047759a
    {load} mov esi, edi                          # 0047759c
    {load} mov eax, ecx                          # 0047759e
    {load} mov edi, edx                          # 004775a0
    shr ecx, 0x2                                 # 004775a2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004775a5
    {load} mov ecx, eax                          # 004775a7
    and ecx, 0x3                                 # 004775a9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004775ac
    mov ecx, dword ptr [ebp - local_30]          # 004775ae
    mov byte ptr [ecx + field_802], 0x1          # 004775b1
    jmp.d8 L_004775d1                            # 004775b8
L_004775ba:
    # block 0x004775ba: entered by jne at 0x00477516, 4 instruction(s), falls into the block at 0x004775d1
    mov edx, dword ptr [ebp - local_30]          # 004775ba
    movsx eax, word ptr [edx + field_22]         # 004775bd
    imul eax, eax, 0x8d                          # 004775c1
    mov dword ptr [eax + 0x5bb632], 0x2          # 004775c7
L_004775d1:
    # block 0x004775d1: entered by jb at 0x004774a2; jmp at 0x004775b8, 3 instruction(s), ends with je to 0x004775ff (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004775d1
    cmp dword ptr [ecx + field_1c], 0x0          # 004775d4
    je.d8 L_004775ff                             # 004775d8
    # block 0x004775da: entered by fall-through of je at 0x004775d8, 4 instruction(s), ends with jne to 0x004775ff (forward)
    mov edx, dword ptr [ebp - local_4]           # 004775da
    movsx eax, word ptr [edx + field_63e]        # 004775dd
    test eax, eax                                # 004775e4
    jne.d8 L_004775ff                            # 004775e6
    # block 0x004775e8: entered by fall-through of jne at 0x004775e6, 4 instruction(s), falls into the block at 0x004775ff
    mov ecx, dword ptr [ebp - local_30]          # 004775e8
    movsx edx, word ptr [ecx + field_22]         # 004775eb
    imul edx, edx, 0x8d                          # 004775ef
    mov dword ptr [edx + 0x5bb632], 0x2          # 004775f5
L_004775ff:
    # block 0x004775ff: entered by ja at 0x00476e23; jmp at 0x004771dc; jmp at 0x0047721e; jmp at 0x00477391; more, 1 instruction(s), ends with forward jump to 0x004778ab
    jmp.d32 L_004778ab                           # 004775ff
L_00477604:
    # block 0x00477604: entered by je at 0x00476a6a, 8 instruction(s), ends with je to 0x0047763b (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00477604
    mov edi, 0x54c98c                            # 0047760e
    mov esi, dword ptr [ebp - local_4]           # 00477613
    add esi, 0x6ea                               # 00477616
    mov ecx, 0x9                                 # 0047761c
    {load} xor eax, eax                          # 00477621
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477623
    je.d8 L_0047763b                             # 00477625
    # block 0x00477627: entered by fall-through of je at 0x00477625, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047763b
    mov ecx, dword ptr [ebp - local_4]           # 00477627
    add ecx, 0x6ea                               # 0047762a
    push ecx                                     # 00477630
    mov ecx, 0x5c3a67                            # 00477631
    call FUN_004fba69                            # 00477636
L_0047763b:
    # block 0x0047763b: entered by je at 0x00477625, 7 instruction(s), ends with je to 0x00477667 (forward)
    mov edi, 0x54c998                            # 0047763b
    mov esi, dword ptr [ebp - local_4]           # 00477640
    add esi, 0x71b                               # 00477643
    mov ecx, 0x9                                 # 00477649
    {load} xor edx, edx                          # 0047764e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477650
    je.d8 L_00477667                             # 00477652
    # block 0x00477654: entered by fall-through of je at 0x00477652, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00477667
    mov eax, dword ptr [ebp - local_4]           # 00477654
    add eax, 0x71b                               # 00477657
    push eax                                     # 0047765c
    mov ecx, 0x5c3a67                            # 0047765d
    call FUN_004fba69                            # 00477662
L_00477667:
    # block 0x00477667: entered by je at 0x00477652, 7 instruction(s), ends with je to 0x00477693 (forward)
    mov edi, 0x54c9a4                            # 00477667
    mov esi, dword ptr [ebp - local_4]           # 0047766c
    add esi, 0x74c                               # 0047766f
    mov ecx, 0x9                                 # 00477675
    {load} xor edx, edx                          # 0047767a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047767c
    je.d8 L_00477693                             # 0047767e
    # block 0x00477680: entered by fall-through of je at 0x0047767e, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00477693
    mov eax, dword ptr [ebp - local_4]           # 00477680
    add eax, 0x74c                               # 00477683
    push eax                                     # 00477688
    mov ecx, 0x5c3a67                            # 00477689
    call FUN_004fba69                            # 0047768e
L_00477693:
    # block 0x00477693: entered by je at 0x0047767e, 3 instruction(s), ends with je to 0x00477785 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00477693
    cmp dword ptr [ecx + field_89e], 0x0         # 00477696
    je.d32 L_00477785                            # 0047769d
    # block 0x004776a3: entered by fall-through of je at 0x0047769d, 4 instruction(s), ends with je to 0x00477755 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004776a3
    movsx eax, word ptr [edx + field_7c9]        # 004776a6
    cmp eax, 0x270f                              # 004776ad
    je.d32 L_00477755                            # 004776b2
    # block 0x004776b8: entered by fall-through of je at 0x004776b2, 25 instruction(s), ends with jne to 0x00477741 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004776b8
    movsx edx, word ptr [ecx + field_7c9]        # 004776bb
    mov dword ptr [0x5bb57b], edx                # 004776c2
    mov eax, dword ptr [ebp - local_4]           # 004776c8
    mov cx, word ptr [eax + field_7cb]           # 004776cb
    mov word ptr [0x5bb599], cx                  # 004776d2
    mov edx, dword ptr [ebp - local_4]           # 004776d9
    mov ax, word ptr [edx + field_7cd]           # 004776dc
    mov word ptr [0x5bb595], ax                  # 004776e3
    mov ecx, dword ptr [ebp - local_4]           # 004776e9
    mov dx, word ptr [ecx + field_7cf]           # 004776ec
    mov word ptr [0x5c39ff], dx                  # 004776f3
    mov eax, dword ptr [ebp - local_4]           # 004776fa
    mov ecx, dword ptr [eax + field_7d1]         # 004776fd
    mov dword ptr [0x5bb59b], ecx                # 00477703
    mov edx, dword ptr [ebp - local_4]           # 00477709
    mov eax, dword ptr [edx + field_7d5]         # 0047770c
    mov dword ptr [0x5bb59f], eax                # 00477712
    mov ecx, dword ptr [ebp - local_4]           # 00477717
    mov edx, dword ptr [ecx + field_7d9]         # 0047771a
    mov dword ptr [0x5bb5a3], edx                # 00477720
    mov eax, dword ptr [ebp - local_4]           # 00477726
    movsx ecx, word ptr [eax + field_7dd]        # 00477729
    cmp ecx, 0x1                                 # 00477730
    jne.d8 L_00477741                            # 00477733
    # block 0x00477735: entered by fall-through of jne at 0x00477733, 2 instruction(s), ends with forward jump to 0x0047774b
    mov dword ptr [0x5bb1ca], 0x0                # 00477735
    jmp.d8 L_0047774b                            # 0047773f
L_00477741:
    # block 0x00477741: entered by jne at 0x00477733, 1 instruction(s), falls into the block at 0x0047774b
    mov dword ptr [0x5bb1ca], 0x1                # 00477741
L_0047774b:
    # block 0x0047774b: entered by jmp at 0x0047773f, 1 instruction(s), falls into the block at 0x00477755
    mov dword ptr [0x583999], 0x4                # 0047774b
L_00477755:
    # block 0x00477755: entered by je at 0x004776b2, 4 instruction(s), ends with je to 0x00477780 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00477755
    movsx eax, word ptr [edx + field_7df]        # 00477758
    cmp eax, -0x1                                # 0047775f
    je.d8 L_00477780                             # 00477762
    # block 0x00477764: entered by fall-through of je at 0x00477762, 6 instruction(s), falls into the block at 0x00477780
    mov ecx, dword ptr [ebp - local_4]           # 00477764
    {load} xor edx, edx                          # 00477767
    mov dl, byte ptr [ecx + field_7e1]           # 00477769
    mov eax, dword ptr [ebp - local_4]           # 0047776f
    movsx ecx, word ptr [eax + field_7df]        # 00477772
    mov dword ptr [4*ecx + 0x585801], edx        # 00477779
L_00477780:
    # block 0x00477780: entered by je at 0x00477762, 1 instruction(s), ends with forward jump to 0x0047786f
    jmp.d32 L_0047786f                           # 00477780
L_00477785:
    # block 0x00477785: entered by je at 0x0047769d, 3 instruction(s), ends with je to 0x0047786f (forward)
    mov edx, dword ptr [ebp - local_30]          # 00477785
    cmp dword ptr [edx + field_1c], 0x0          # 00477788
    je.d32 L_0047786f                            # 0047778c
    # block 0x00477792: entered by fall-through of je at 0x0047778c, 4 instruction(s), ends with je to 0x00477844 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00477792
    movsx ecx, word ptr [eax + field_77d]        # 00477795
    cmp ecx, 0x270f                              # 0047779c
    je.d32 L_00477844                            # 004777a2
    # block 0x004777a8: entered by fall-through of je at 0x004777a2, 25 instruction(s), ends with jne to 0x00477830 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004777a8
    movsx eax, word ptr [edx + field_77d]        # 004777ab
    mov dword ptr [0x5bb57b], eax                # 004777b2
    mov ecx, dword ptr [ebp - local_4]           # 004777b7
    mov dx, word ptr [ecx + field_77f]           # 004777ba
    mov word ptr [0x5bb599], dx                  # 004777c1
    mov eax, dword ptr [ebp - local_4]           # 004777c8
    mov cx, word ptr [eax + field_781]           # 004777cb
    mov word ptr [0x5bb595], cx                  # 004777d2
    mov edx, dword ptr [ebp - local_4]           # 004777d9
    mov ax, word ptr [edx + field_783]           # 004777dc
    mov word ptr [0x5c39ff], ax                  # 004777e3
    mov ecx, dword ptr [ebp - local_4]           # 004777e9
    mov edx, dword ptr [ecx + field_785]         # 004777ec
    mov dword ptr [0x5bb59b], edx                # 004777f2
    mov eax, dword ptr [ebp - local_4]           # 004777f8
    mov ecx, dword ptr [eax + field_789]         # 004777fb
    mov dword ptr [0x5bb59f], ecx                # 00477801
    mov edx, dword ptr [ebp - local_4]           # 00477807
    mov eax, dword ptr [edx + field_78d]         # 0047780a
    mov dword ptr [0x5bb5a3], eax                # 00477810
    mov ecx, dword ptr [ebp - local_4]           # 00477815
    movsx edx, word ptr [ecx + field_791]        # 00477818
    cmp edx, 0x1                                 # 0047781f
    jne.d8 L_00477830                            # 00477822
    # block 0x00477824: entered by fall-through of jne at 0x00477822, 2 instruction(s), ends with forward jump to 0x0047783a
    mov dword ptr [0x5bb1ca], 0x0                # 00477824
    jmp.d8 L_0047783a                            # 0047782e
L_00477830:
    # block 0x00477830: entered by jne at 0x00477822, 1 instruction(s), falls into the block at 0x0047783a
    mov dword ptr [0x5bb1ca], 0x1                # 00477830
L_0047783a:
    # block 0x0047783a: entered by jmp at 0x0047782e, 1 instruction(s), falls into the block at 0x00477844
    mov dword ptr [0x583999], 0x4                # 0047783a
L_00477844:
    # block 0x00477844: entered by je at 0x004777a2, 4 instruction(s), ends with je to 0x0047786f (forward)
    mov eax, dword ptr [ebp - local_4]           # 00477844
    movsx ecx, word ptr [eax + field_793]        # 00477847
    cmp ecx, -0x1                                # 0047784e
    je.d8 L_0047786f                             # 00477851
    # block 0x00477853: entered by fall-through of je at 0x00477851, 6 instruction(s), falls into the block at 0x0047786f
    mov edx, dword ptr [ebp - local_4]           # 00477853
    {load} xor eax, eax                          # 00477856
    mov al, byte ptr [edx + field_795]           # 00477858
    mov ecx, dword ptr [ebp - local_4]           # 0047785e
    movsx edx, word ptr [ecx + field_793]        # 00477861
    mov dword ptr [4*edx + 0x585801], eax        # 00477868
L_0047786f:
    # block 0x0047786f: entered by jmp at 0x00477780; je at 0x0047778c; je at 0x00477851, 5 instruction(s), ends with je to 0x00477893 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047786f
    {load} xor ecx, ecx                          # 00477872
    mov cl, byte ptr [eax + field_238]           # 00477874
    test ecx, ecx                                # 0047787a
    je.d8 L_00477893                             # 0047787c
    # block 0x0047787e: entered by fall-through of je at 0x0047787c, 5 instruction(s), calls FUN_004c92c5, falls into the block at 0x00477893
    mov edx, dword ptr [ebp - local_4]           # 0047787e
    mov ax, word ptr [edx + field_23a]           # 00477881
    push eax                                     # 00477888
    mov ecx, 0x5cf659                            # 00477889
    call FUN_004c92c5                            # 0047788e
L_00477893:
    # block 0x00477893: entered by je at 0x0047787c, 7 instruction(s), calls FUN_0042ba3a, FUN_00475885, falls into the block at 0x004778ab
    mov ecx, dword ptr [ebp - local_30]          # 00477893
    mov dx, word ptr [ecx + field_22]            # 00477896
    push edx                                     # 0047789a
    call FUN_0042ba3a                            # 0047789b
    add esp, 0x4                                 # 004778a0
    mov ecx, dword ptr [ebp - local_30]          # 004778a3
    call FUN_00475885                            # 004778a6
L_004778ab:
    # block 0x004778ab: entered by jmp at 0x00476a70; jmp at 0x00476e11; jmp at 0x004775ff, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004778ab
    pop esi                                      # 004778ac
    {load} mov esp, ebp                          # 004778ad
    pop ebp                                      # 004778af
    ret 0x4                                      # 004778b0

# --- data items (not part of the function) -------------------------
.org 0x004778b3 - 0x401000
SWTAB_004778b3:  # 7 case address(es)
    .long L_00476e33 - .text + 0x401000
    .long L_00477396 - .text + 0x401000
    .long L_00477223 - .text + 0x401000
    .long L_004771e1 - .text + 0x401000
    .long L_00477427 - .text + 0x401000
    .long L_00477407 - .text + 0x401000
    .long L_00477493 - .text + 0x401000
.set SWTAB_004778b3_VA, SWTAB_004778b3 - .text + 0x401000

