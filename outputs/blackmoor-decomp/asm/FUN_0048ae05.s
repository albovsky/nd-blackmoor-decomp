# FUN_0048ae05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ae05
# extent:       0x0048ae05-0x0048b720 (2331 code bytes)
# span:         0x0048ae05-0x0048b720 (code 2331, tables 0, padding 0)
# sha256:       6119a5cd343592000cc5b0c5055da02eb009e42771f9cd2302e54e086ee1f09b
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048ae05
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 1 more
# fields:       [eax + n] field_1c, field_1e, field_21, field_23, field_44, field_4e, field_52, field_c4, field_fe, field_192, field_1aa, field_1af and 11 more; [ecx + n] field_1c, field_1e, field_20, field_21, field_2e, field_44, field_4e, field_5e, field_d0, field_f6, field_fa, field_192 and 13 more; [edx + n] field_1c, field_1e, field_21, field_24, field_42, field_4a, field_56, field_5a, field_c8, field_cc, field_f2, field_1b6 and 9 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_0050cd50, FUN_00427a40, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_0048a7e5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 583 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_2e, 0x2e  # offset +0x2e
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_c4, 0xc4  # offset +0xc4
.equ field_c8, 0xc8  # offset +0xc8
.equ field_cc, 0xcc  # offset +0xcc
.equ field_d0, 0xd0  # offset +0xd0
.equ field_f2, 0xf2  # offset +0xf2
.equ field_f6, 0xf6  # offset +0xf6
.equ field_fa, 0xfa  # offset +0xfa
.equ field_fe, 0xfe  # offset +0xfe
.equ field_192, 0x192  # offset +0x192
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2b0, 0x2b0  # offset +0x2b0
.equ field_3a8, 0x3a8  # offset +0x3a8
.equ field_3aa, 0x3aa  # offset +0x3aa
.equ field_3ac, 0x3ac  # offset +0x3ac
.equ field_3ae, 0x3ae  # offset +0x3ae
.equ field_3b0, 0x3b0  # offset +0x3b0
.equ field_3b4, 0x3b4  # offset +0x3b4
.equ field_3b8, 0x3b8  # offset +0x3b8
.equ field_3bc, 0x3bc  # offset +0x3bc
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c0, 0x3c0  # offset +0x3c0
.equ field_3e2, 0x3e2  # offset +0x3e2
.equ field_3f2, 0x3f2  # offset +0x3f2
.equ field_3f4, 0x3f4  # offset +0x3f4
.equ field_3f6, 0x3f6  # offset +0x3f6
.equ field_3f8, 0x3f8  # offset +0x3f8
.equ field_3fa, 0x3fa  # offset +0x3fa
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_402, 0x402  # offset +0x402
.equ field_406, 0x406  # offset +0x406
.equ field_408, 0x408  # offset +0x408
.equ field_40a, 0x40a  # offset +0x40a

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0048a7e5, .text + (0x0048a7e5 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0048ae05 - 0x401000
.globl FUN_0048ae05
FUN_0048ae05:
    # block 0x0048ae05: entry, 16 instruction(s), ends with je to 0x0048ae55 (forward)
    push ebp                                     # 0048ae05
    {load} mov ebp, esp                          # 0048ae06
    sub esp, 0x34                                # 0048ae08
    push esi                                     # 0048ae0b
    push edi                                     # 0048ae0c
    mov dword ptr [ebp - local_20], ecx          # 0048ae0d
    movsx eax, word ptr [ebp + arg_8]            # 0048ae10
    imul eax, eax, 0x8d                          # 0048ae14
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048ae1a
    mov dword ptr [ebp - local_c], ecx           # 0048ae20
    movsx edx, word ptr [ebp + arg_8]            # 0048ae23
    imul edx, edx, 0x8d                          # 0048ae27
    mov eax, dword ptr [edx + 0x5bb632]          # 0048ae2d
    mov dword ptr [ebp - local_24], eax          # 0048ae33
    cmp dword ptr [ebp - local_24], 0x0          # 0048ae36
    je.d8 L_0048ae55                             # 0048ae3a
    # block 0x0048ae3c: entered by fall-through of je at 0x0048ae3a, 2 instruction(s), ends with je to 0x0048b3af (forward)
    cmp dword ptr [ebp - local_24], 0x1          # 0048ae3c
    je.d32 L_0048b3af                            # 0048ae40
    # block 0x0048ae46: entered by fall-through of je at 0x0048ae40, 2 instruction(s), ends with je to 0x0048b4b8 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 0048ae46
    je.d32 L_0048b4b8                            # 0048ae4a
    # block 0x0048ae50: entered by fall-through of je at 0x0048ae4a, 1 instruction(s), ends with forward jump to 0x0048b718
    jmp.d32 L_0048b718                           # 0048ae50
L_0048ae55:
    # block 0x0048ae55: entered by je at 0x0048ae3a, 10 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x0048ae93
    mov ecx, dword ptr [ebp - local_20]          # 0048ae55
    mov dx, word ptr [ebp + arg_8]               # 0048ae58
    mov word ptr [ecx + field_1e], dx            # 0048ae5c
    mov eax, dword ptr [ebp - local_20]          # 0048ae60
    mov dword ptr [eax + field_1aa], 0x1         # 0048ae63
    mov dword ptr [0x5bb1ca], 0x1                # 0048ae6d
    mov ecx, 0x571442                            # 0048ae77
    call FUN_004e8d96                            # 0048ae7c
    mov dword ptr [ebp - local_8], 0x0           # 0048ae81
    jmp.d8 L_0048ae93                            # 0048ae88
L_0048ae8a:
    # block 0x0048ae8a: entered by jmp at 0x0048afc8, 3 instruction(s), falls into the block at 0x0048ae93
    mov ecx, dword ptr [ebp - local_8]           # 0048ae8a
    add ecx, 0x1                                 # 0048ae8d
    mov dword ptr [ebp - local_8], ecx           # 0048ae90
L_0048ae93:
    # block 0x0048ae93: entered by jmp at 0x0048ae88, 5 instruction(s), ends with jge to 0x0048afcd (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048ae93
    {load} xor eax, eax                          # 0048ae96
    mov al, byte ptr [edx + field_21]            # 0048ae98
    cmp dword ptr [ebp - local_8], eax           # 0048ae9b
    jge.d32 L_0048afcd                           # 0048ae9e
    # block 0x0048aea4: entered by fall-through of jge at 0x0048ae9e, 73 instruction(s), ends with backward jump to 0x0048ae8a
    mov ecx, dword ptr [ebp - local_8]           # 0048aea4
    shl ecx, 0x4                                 # 0048aea7
    mov edx, dword ptr [ebp - local_c]           # 0048aeaa
    mov eax, dword ptr [edx + ecx + field_c8]    # 0048aead
    add eax, dword ptr [0x58318a]                # 0048aeb4
    mov ecx, dword ptr [ebp - local_8]           # 0048aeba
    shl ecx, 0x4                                 # 0048aebd
    mov edx, dword ptr [ebp - local_20]          # 0048aec0
    mov dword ptr [edx + ecx + field_56], eax    # 0048aec3
    mov eax, dword ptr [ebp - local_8]           # 0048aec7
    shl eax, 0x4                                 # 0048aeca
    mov ecx, dword ptr [ebp - local_c]           # 0048aecd
    mov edx, dword ptr [ecx + eax + field_d0]    # 0048aed0
    add edx, dword ptr [0x58318a]                # 0048aed7
    mov eax, dword ptr [ebp - local_8]           # 0048aedd
    shl eax, 0x4                                 # 0048aee0
    mov ecx, dword ptr [ebp - local_20]          # 0048aee3
    mov dword ptr [ecx + eax + field_5e], edx    # 0048aee6
    mov edx, dword ptr [ebp - local_8]           # 0048aeea
    shl edx, 0x4                                 # 0048aeed
    mov eax, dword ptr [ebp - local_c]           # 0048aef0
    mov ecx, dword ptr [eax + edx + field_c4]    # 0048aef3
    add ecx, dword ptr [0x583186]                # 0048aefa
    mov edx, dword ptr [ebp - local_8]           # 0048af00
    shl edx, 0x4                                 # 0048af03
    mov eax, dword ptr [ebp - local_20]          # 0048af06
    mov dword ptr [eax + edx + field_52], ecx    # 0048af09
    mov ecx, dword ptr [ebp - local_8]           # 0048af0d
    shl ecx, 0x4                                 # 0048af10
    mov edx, dword ptr [ebp - local_c]           # 0048af13
    mov eax, dword ptr [edx + ecx + field_cc]    # 0048af16
    add eax, dword ptr [0x583186]                # 0048af1d
    mov ecx, dword ptr [ebp - local_8]           # 0048af23
    shl ecx, 0x4                                 # 0048af26
    mov edx, dword ptr [ebp - local_20]          # 0048af29
    mov dword ptr [edx + ecx + field_5a], eax    # 0048af2c
    mov eax, dword ptr [ebp - local_8]           # 0048af30
    shl eax, 0x4                                 # 0048af33
    mov ecx, dword ptr [ebp - local_c]           # 0048af36
    mov edx, dword ptr [ecx + eax + field_2a8]   # 0048af39
    add edx, dword ptr [0x58318a]                # 0048af40
    mov eax, dword ptr [ebp - local_8]           # 0048af46
    shl eax, 0x4                                 # 0048af49
    mov ecx, dword ptr [ebp - local_20]          # 0048af4c
    mov dword ptr [ecx + eax + field_f6], edx    # 0048af4f
    mov edx, dword ptr [ebp - local_8]           # 0048af56
    shl edx, 0x4                                 # 0048af59
    mov eax, dword ptr [ebp - local_c]           # 0048af5c
    mov ecx, dword ptr [eax + edx + field_2b0]   # 0048af5f
    add ecx, dword ptr [0x58318a]                # 0048af66
    mov edx, dword ptr [ebp - local_8]           # 0048af6c
    shl edx, 0x4                                 # 0048af6f
    mov eax, dword ptr [ebp - local_20]          # 0048af72
    mov dword ptr [eax + edx + field_fe], ecx    # 0048af75
    mov ecx, dword ptr [ebp - local_8]           # 0048af7c
    shl ecx, 0x4                                 # 0048af7f
    mov edx, dword ptr [ebp - local_c]           # 0048af82
    mov eax, dword ptr [edx + ecx + field_2a4]   # 0048af85
    add eax, dword ptr [0x583186]                # 0048af8c
    mov ecx, dword ptr [ebp - local_8]           # 0048af92
    shl ecx, 0x4                                 # 0048af95
    mov edx, dword ptr [ebp - local_20]          # 0048af98
    mov dword ptr [edx + ecx + field_f2], eax    # 0048af9b
    mov eax, dword ptr [ebp - local_8]           # 0048afa2
    shl eax, 0x4                                 # 0048afa5
    mov ecx, dword ptr [ebp - local_c]           # 0048afa8
    mov edx, dword ptr [ecx + eax + field_2ac]   # 0048afab
    add edx, dword ptr [0x583186]                # 0048afb2
    mov eax, dword ptr [ebp - local_8]           # 0048afb8
    shl eax, 0x4                                 # 0048afbb
    mov ecx, dword ptr [ebp - local_20]          # 0048afbe
    mov dword ptr [ecx + eax + field_fa], edx    # 0048afc1
    jmp.d32 L_0048ae8a                           # 0048afc8
L_0048afcd:
    # block 0x0048afcd: entered by jge at 0x0048ae9e, 56 instruction(s), calls FUN_004d39f9, ends with jne to 0x0048b0d3 (forward)
    call FUN_004d39f9                            # 0048afcd
    mov edx, dword ptr [ebp - local_20]          # 0048afd2
    mov word ptr [edx + field_1c], ax            # 0048afd5
    mov eax, dword ptr [ebp - local_20]          # 0048afd9
    movsx ecx, word ptr [eax + field_1c]         # 0048afdc
    imul ecx, ecx, 0x4a                          # 0048afe0
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0048afe3
    mov edx, dword ptr [ebp - local_20]          # 0048afed
    movsx eax, word ptr [edx + field_1c]         # 0048aff0
    imul eax, eax, 0x4a                          # 0048aff4
    mov dword ptr [eax + 0x5d1595], 0x48b730     # 0048aff7
    mov ecx, dword ptr [ebp - local_20]          # 0048b001
    movsx edx, word ptr [ecx + field_1c]         # 0048b004
    imul edx, edx, 0x4a                          # 0048b008
    mov dword ptr [edx + 0x5d1599], 0x0          # 0048b00b
    mov eax, dword ptr [ebp - local_20]          # 0048b015
    movsx ecx, word ptr [eax + field_1c]         # 0048b018
    imul ecx, ecx, 0x4a                          # 0048b01c
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0048b01f
    mov edx, dword ptr [ebp - local_20]          # 0048b029
    movsx eax, word ptr [edx + field_1c]         # 0048b02c
    imul eax, eax, 0x4a                          # 0048b030
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0048b033
    mov ecx, dword ptr [ebp - local_20]          # 0048b03d
    movsx edx, word ptr [ecx + field_1c]         # 0048b040
    imul edx, edx, 0x4a                          # 0048b044
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0048b047
    mov eax, dword ptr [ebp - local_20]          # 0048b051
    movsx ecx, word ptr [eax + field_1c]         # 0048b054
    imul ecx, ecx, 0x4a                          # 0048b058
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 0048b05b
    mov edx, dword ptr [ebp - local_20]          # 0048b065
    movsx eax, word ptr [edx + field_1c]         # 0048b068
    imul eax, eax, 0x4a                          # 0048b06c
    mov word ptr [eax + 0x5d15ad], 0x0           # 0048b06f
    mov edi, 0x54e37c                            # 0048b078
    mov ecx, dword ptr [ebp - local_20]          # 0048b07d
    movsx edx, word ptr [ecx + field_1c]         # 0048b080
    imul edx, edx, 0x4a                          # 0048b084
    add edx, 0x5d15b3                            # 0048b087
    or ecx, -0x1                                 # 0048b08d
    {load} xor eax, eax                          # 0048b090
    repne scasb al, byte ptr es:[edi]            # 0048b092
    not ecx                                      # 0048b094
    {load} sub edi, ecx                          # 0048b096
    {load} mov esi, edi                          # 0048b098
    {load} mov eax, ecx                          # 0048b09a
    {load} mov edi, edx                          # 0048b09c
    shr ecx, 0x2                                 # 0048b09e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048b0a1
    {load} mov ecx, eax                          # 0048b0a3
    and ecx, 0x3                                 # 0048b0a5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048b0a8
    mov ecx, dword ptr [ebp - local_20]          # 0048b0aa
    cmp dword ptr [ecx + field_20], 0x0          # 0048b0ad
    jne.d8 L_0048b0d3                            # 0048b0b1
    # block 0x0048b0b3: entered by fall-through of jne at 0x0048b0b1, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0048b0d3
    push 0x54e39c                                # 0048b0b3
    push 0x6                                     # 0048b0b8
    mov edx, dword ptr [ebp - local_c]           # 0048b0ba
    push edx                                     # 0048b0bd
    push 0x54e3bc                                # 0048b0be
    mov ecx, 0x5cf659                            # 0048b0c3
    call FUN_004c2790                            # 0048b0c8
    mov ecx, dword ptr [ebp - local_20]          # 0048b0cd
    mov dword ptr [ecx + field_20], eax          # 0048b0d0
L_0048b0d3:
    # block 0x0048b0d3: entered by jne at 0x0048b0b1, 13 instruction(s), ends with je to 0x0048b116 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0048b0d3
    movsx eax, word ptr [edx + field_1c]         # 0048b0d6
    imul eax, eax, 0x4a                          # 0048b0da
    mov ecx, dword ptr [ebp - local_20]          # 0048b0dd
    mov edx, dword ptr [ecx + field_20]          # 0048b0e0
    mov dword ptr [eax + 0x5d1599], edx          # 0048b0e3
    mov edi, 0x54e3c4                            # 0048b0e9
    mov esi, dword ptr [ebp - local_c]           # 0048b0ee
    add esi, 0x344                               # 0048b0f1
    mov ecx, 0x9                                 # 0048b0f7
    {load} xor eax, eax                          # 0048b0fc
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048b0fe
    je.d8 L_0048b116                             # 0048b100
    # block 0x0048b102: entered by fall-through of je at 0x0048b100, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0048b116
    mov ecx, dword ptr [ebp - local_c]           # 0048b102
    add ecx, 0x344                               # 0048b105
    push ecx                                     # 0048b10b
    mov ecx, 0x5c3a67                            # 0048b10c
    call FUN_004fb77a                            # 0048b111
L_0048b116:
    # block 0x0048b116: entered by je at 0x0048b100, 7 instruction(s), ends with je to 0x0048b142 (forward)
    mov edi, 0x54e3d0                            # 0048b116
    mov esi, dword ptr [ebp - local_c]           # 0048b11b
    add esi, 0x375                               # 0048b11e
    mov ecx, 0x9                                 # 0048b124
    {load} xor edx, edx                          # 0048b129
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048b12b
    je.d8 L_0048b142                             # 0048b12d
    # block 0x0048b12f: entered by fall-through of je at 0x0048b12d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0048b142
    mov eax, dword ptr [ebp - local_c]           # 0048b12f
    add eax, 0x375                               # 0048b132
    push eax                                     # 0048b137
    mov ecx, 0x5c3a67                            # 0048b138
    call FUN_004fb77a                            # 0048b13d
L_0048b142:
    # block 0x0048b142: entered by je at 0x0048b12d, 6 instruction(s), ends with forward jump to 0x0048b161
    or ecx, -0x1                                 # 0048b142
    mov dword ptr [ebp - local_18], ecx          # 0048b145
    mov dword ptr [ebp - local_14], ecx          # 0048b148
    mov word ptr [ebp - local_10], cx            # 0048b14b
    mov dword ptr [ebp - local_8], 0x0           # 0048b14f
    jmp.d8 L_0048b161                            # 0048b156
L_0048b158:
    # block 0x0048b158: entered by jmp at 0x0048b1f2, 3 instruction(s), falls into the block at 0x0048b161
    mov edx, dword ptr [ebp - local_8]           # 0048b158
    add edx, 0x1                                 # 0048b15b
    mov dword ptr [ebp - local_8], edx           # 0048b15e
L_0048b161:
    # block 0x0048b161: entered by jmp at 0x0048b156, 5 instruction(s), ends with jge to 0x0048b1f7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b161
    {load} xor ecx, ecx                          # 0048b164
    mov cl, byte ptr [eax + field_21]            # 0048b166
    cmp dword ptr [ebp - local_8], ecx           # 0048b169
    jge.d32 L_0048b1f7                           # 0048b16c
    # block 0x0048b172: entered by fall-through of jge at 0x0048b16c, 7 instruction(s), calls FUN_0050cd50, falls into the block at 0x0048b186
    call FUN_0050cd50                            # 0048b172
    mov edx, dword ptr [ebp - local_c]           # 0048b177
    {load} xor ecx, ecx                          # 0048b17a
    mov cl, byte ptr [edx + field_21]            # 0048b17c
    cdq                                          # 0048b17f
    idiv ecx                                     # 0048b180
    mov word ptr [ebp - local_4], dx             # 0048b182
L_0048b186:
    # block 0x0048b186: entered by jmp at 0x0048b1aa, 4 instruction(s), ends with je to 0x0048b1ac (forward)
    movsx edx, word ptr [ebp - local_4]          # 0048b186
    movsx eax, byte ptr [ebp + edx - local_18]   # 0048b18a
    cmp eax, -0x1                                # 0048b18f
    je.d8 L_0048b1ac                             # 0048b192
    # block 0x0048b194: entered by fall-through of je at 0x0048b192, 9 instruction(s), calls FUN_0050cd50, ends with backward jump to 0x0048b186
    call FUN_0050cd50                            # 0048b194
    mov ecx, dword ptr [ebp - local_c]           # 0048b199
    {load} xor edx, edx                          # 0048b19c
    mov dl, byte ptr [ecx + field_21]            # 0048b19e
    {load} mov ecx, edx                          # 0048b1a1
    cdq                                          # 0048b1a3
    idiv ecx                                     # 0048b1a4
    mov word ptr [ebp - local_4], dx             # 0048b1a6
    jmp.d8 L_0048b186                            # 0048b1aa
L_0048b1ac:
    # block 0x0048b1ac: entered by je at 0x0048b192, 9 instruction(s), ends with je to 0x0048b1d9 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0048b1ac
    mov byte ptr [ebp + edx - local_18], 0x1     # 0048b1b0
    mov eax, dword ptr [ebp - local_8]           # 0048b1b5
    mov ecx, dword ptr [ebp - local_20]          # 0048b1b8
    mov dx, word ptr [ebp - local_4]             # 0048b1bb
    mov word ptr [ecx + 2*eax + field_1ba], dx   # 0048b1bf
    mov eax, 0x1                                 # 0048b1c7
    test eax, eax                                # 0048b1cc
    je.d8 L_0048b1d9                             # 0048b1ce
    # block 0x0048b1d0: entered by fall-through of je at 0x0048b1ce, 2 instruction(s), ends with forward jump to 0x0048b1f2
    mov dword ptr [ebp - local_28], 0x0          # 0048b1d0
    jmp.d8 L_0048b1f2                            # 0048b1d7
L_0048b1d9:
    # block 0x0048b1d9: entered by je at 0x0048b1ce, 8 instruction(s), calls FUN_00427a40, falls into the block at 0x0048b1f2
    movsx ecx, word ptr [ebp - local_4]          # 0048b1d9
    push ecx                                     # 0048b1dd
    mov edx, dword ptr [ebp - local_8]           # 0048b1de
    push edx                                     # 0048b1e1
    push 0x54e3dc                                # 0048b1e2
    call FUN_00427a40                            # 0048b1e7
    add esp, 0xc                                 # 0048b1ec
    mov dword ptr [ebp - local_28], eax          # 0048b1ef
L_0048b1f2:
    # block 0x0048b1f2: entered by jmp at 0x0048b1d7, 1 instruction(s), ends with backward jump to 0x0048b158
    jmp.d32 L_0048b158                           # 0048b1f2
L_0048b1f7:
    # block 0x0048b1f7: entered by jge at 0x0048b16c, 5 instruction(s), ends with jne to 0x0048b266 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b1f7
    {load} xor ecx, ecx                          # 0048b1fa
    mov cl, byte ptr [eax + field_23]            # 0048b1fc
    cmp ecx, 0x3                                 # 0048b1ff
    jne.d8 L_0048b266                            # 0048b202
    # block 0x0048b204: entered by fall-through of jne at 0x0048b202, 2 instruction(s), ends with forward jump to 0x0048b216
    mov dword ptr [ebp - local_8], 0x0           # 0048b204
    jmp.d8 L_0048b216                            # 0048b20b
L_0048b20d:
    # block 0x0048b20d: entered by jmp at 0x0048b25f, 3 instruction(s), falls into the block at 0x0048b216
    mov edx, dword ptr [ebp - local_8]           # 0048b20d
    add edx, 0x1                                 # 0048b210
    mov dword ptr [ebp - local_8], edx           # 0048b213
L_0048b216:
    # block 0x0048b216: entered by jmp at 0x0048b20b, 5 instruction(s), ends with jge to 0x0048b261 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b216
    {load} xor ecx, ecx                          # 0048b219
    mov cl, byte ptr [eax + field_21]            # 0048b21b
    cmp dword ptr [ebp - local_8], ecx           # 0048b21e
    jge.d8 L_0048b261                            # 0048b221
    # block 0x0048b223: entered by fall-through of jge at 0x0048b221, 7 instruction(s), ends with je to 0x0048b247 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0048b223
    mov eax, dword ptr [ebp - local_20]          # 0048b226
    mov cx, word ptr [ebp - local_8]             # 0048b229
    mov word ptr [eax + 2*edx + field_192], cx   # 0048b22d
    mov edx, 0x1                                 # 0048b235
    test edx, edx                                # 0048b23a
    je.d8 L_0048b247                             # 0048b23c
    # block 0x0048b23e: entered by fall-through of je at 0x0048b23c, 2 instruction(s), ends with forward jump to 0x0048b25f
    mov dword ptr [ebp - local_2c], 0x0          # 0048b23e
    jmp.d8 L_0048b25f                            # 0048b245
L_0048b247:
    # block 0x0048b247: entered by je at 0x0048b23c, 8 instruction(s), calls FUN_00427a40, falls into the block at 0x0048b25f
    mov eax, dword ptr [ebp - local_8]           # 0048b247
    push eax                                     # 0048b24a
    mov ecx, dword ptr [ebp - local_8]           # 0048b24b
    push ecx                                     # 0048b24e
    push 0x54e3f8                                # 0048b24f
    call FUN_00427a40                            # 0048b254
    add esp, 0xc                                 # 0048b259
    mov dword ptr [ebp - local_2c], eax          # 0048b25c
L_0048b25f:
    # block 0x0048b25f: entered by jmp at 0x0048b245, 1 instruction(s), ends with backward jump to 0x0048b20d
    jmp.d8 L_0048b20d                            # 0048b25f
L_0048b261:
    # block 0x0048b261: entered by jge at 0x0048b221, 1 instruction(s), ends with forward jump to 0x0048b31d
    jmp.d32 L_0048b31d                           # 0048b261
L_0048b266:
    # block 0x0048b266: entered by jne at 0x0048b202, 6 instruction(s), ends with forward jump to 0x0048b285
    or edx, -0x1                                 # 0048b266
    mov dword ptr [ebp - local_18], edx          # 0048b269
    mov dword ptr [ebp - local_14], edx          # 0048b26c
    mov word ptr [ebp - local_10], dx            # 0048b26f
    mov dword ptr [ebp - local_8], 0x0           # 0048b273
    jmp.d8 L_0048b285                            # 0048b27a
L_0048b27c:
    # block 0x0048b27c: entered by jmp at 0x0048b318, 3 instruction(s), falls into the block at 0x0048b285
    mov eax, dword ptr [ebp - local_8]           # 0048b27c
    add eax, 0x1                                 # 0048b27f
    mov dword ptr [ebp - local_8], eax           # 0048b282
L_0048b285:
    # block 0x0048b285: entered by jmp at 0x0048b27a, 5 instruction(s), ends with jge to 0x0048b31d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048b285
    {load} xor edx, edx                          # 0048b288
    mov dl, byte ptr [ecx + field_21]            # 0048b28a
    cmp dword ptr [ebp - local_8], edx           # 0048b28d
    jge.d32 L_0048b31d                           # 0048b290
    # block 0x0048b296: entered by fall-through of jge at 0x0048b290, 8 instruction(s), calls FUN_0050cd50, falls into the block at 0x0048b2ac
    call FUN_0050cd50                            # 0048b296
    mov ecx, dword ptr [ebp - local_c]           # 0048b29b
    {load} xor edx, edx                          # 0048b29e
    mov dl, byte ptr [ecx + field_21]            # 0048b2a0
    {load} mov ecx, edx                          # 0048b2a3
    cdq                                          # 0048b2a5
    idiv ecx                                     # 0048b2a6
    mov word ptr [ebp - local_4], dx             # 0048b2a8
L_0048b2ac:
    # block 0x0048b2ac: entered by jmp at 0x0048b2d0, 4 instruction(s), ends with je to 0x0048b2d2 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0048b2ac
    movsx eax, byte ptr [ebp + edx - local_18]   # 0048b2b0
    cmp eax, -0x1                                # 0048b2b5
    je.d8 L_0048b2d2                             # 0048b2b8
    # block 0x0048b2ba: entered by fall-through of je at 0x0048b2b8, 9 instruction(s), calls FUN_0050cd50, ends with backward jump to 0x0048b2ac
    call FUN_0050cd50                            # 0048b2ba
    mov ecx, dword ptr [ebp - local_c]           # 0048b2bf
    {load} xor edx, edx                          # 0048b2c2
    mov dl, byte ptr [ecx + field_21]            # 0048b2c4
    {load} mov ecx, edx                          # 0048b2c7
    cdq                                          # 0048b2c9
    idiv ecx                                     # 0048b2ca
    mov word ptr [ebp - local_4], dx             # 0048b2cc
    jmp.d8 L_0048b2ac                            # 0048b2d0
L_0048b2d2:
    # block 0x0048b2d2: entered by je at 0x0048b2b8, 9 instruction(s), ends with je to 0x0048b2ff (forward)
    movsx edx, word ptr [ebp - local_4]          # 0048b2d2
    mov byte ptr [ebp + edx - local_18], 0x1     # 0048b2d6
    mov eax, dword ptr [ebp - local_8]           # 0048b2db
    mov ecx, dword ptr [ebp - local_20]          # 0048b2de
    mov dx, word ptr [ebp - local_4]             # 0048b2e1
    mov word ptr [ecx + 2*eax + field_192], dx   # 0048b2e5
    mov eax, 0x1                                 # 0048b2ed
    test eax, eax                                # 0048b2f2
    je.d8 L_0048b2ff                             # 0048b2f4
    # block 0x0048b2f6: entered by fall-through of je at 0x0048b2f4, 2 instruction(s), ends with forward jump to 0x0048b318
    mov dword ptr [ebp - local_30], 0x0          # 0048b2f6
    jmp.d8 L_0048b318                            # 0048b2fd
L_0048b2ff:
    # block 0x0048b2ff: entered by je at 0x0048b2f4, 8 instruction(s), calls FUN_00427a40, falls into the block at 0x0048b318
    movsx ecx, word ptr [ebp - local_4]          # 0048b2ff
    push ecx                                     # 0048b303
    mov edx, dword ptr [ebp - local_8]           # 0048b304
    push edx                                     # 0048b307
    push 0x54e414                                # 0048b308
    call FUN_00427a40                            # 0048b30d
    add esp, 0xc                                 # 0048b312
    mov dword ptr [ebp - local_30], eax          # 0048b315
L_0048b318:
    # block 0x0048b318: entered by jmp at 0x0048b2fd, 1 instruction(s), ends with backward jump to 0x0048b27c
    jmp.d32 L_0048b27c                           # 0048b318
L_0048b31d:
    # block 0x0048b31d: entered by jmp at 0x0048b261; jge at 0x0048b290, 18 instruction(s), ends with forward jump to 0x0048b384
    mov eax, dword ptr [ebp - local_20]          # 0048b31d
    mov byte ptr [eax + field_1af], 0x0          # 0048b320
    mov ecx, dword ptr [ebp - local_20]          # 0048b327
    mov byte ptr [ecx + field_1ae], 0x0          # 0048b32a
    mov edx, dword ptr [ebp - local_20]          # 0048b331
    mov word ptr [edx + field_42], 0x0           # 0048b334
    mov eax, dword ptr [ebp - local_20]          # 0048b33a
    mov dword ptr [eax + field_44], 0x0          # 0048b33d
    mov ecx, dword ptr [ebp - local_20]          # 0048b344
    mov dword ptr [ecx + field_4e], 0x1          # 0048b347
    mov edx, dword ptr [ebp - local_20]          # 0048b34e
    mov dword ptr [edx + field_1b6], 0x0         # 0048b351
    mov eax, dword ptr [ebp - local_20]          # 0048b35b
    movsx ecx, word ptr [eax + field_1e]         # 0048b35e
    imul ecx, ecx, 0x8d                          # 0048b362
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0048b368
    mov dword ptr [ebp - local_8], 0x0           # 0048b372
    jmp.d8 L_0048b384                            # 0048b379
L_0048b37b:
    # block 0x0048b37b: entered by jmp at 0x0048b3a8, 3 instruction(s), falls into the block at 0x0048b384
    mov edx, dword ptr [ebp - local_8]           # 0048b37b
    add edx, 0x1                                 # 0048b37e
    mov dword ptr [ebp - local_8], edx           # 0048b381
L_0048b384:
    # block 0x0048b384: entered by jmp at 0x0048b379, 5 instruction(s), ends with jge to 0x0048b3aa (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b384
    {load} xor ecx, ecx                          # 0048b387
    mov cl, byte ptr [eax + field_21]            # 0048b389
    cmp dword ptr [ebp - local_8], ecx           # 0048b38c
    jge.d8 L_0048b3aa                            # 0048b38f
    # block 0x0048b391: entered by fall-through of jge at 0x0048b38f, 7 instruction(s), ends with backward jump to 0x0048b37b
    mov edx, dword ptr [ebp - local_20]          # 0048b391
    add edx, dword ptr [ebp - local_8]           # 0048b394
    mov byte ptr [edx + field_24], 0x0           # 0048b397
    mov eax, dword ptr [ebp - local_8]           # 0048b39b
    mov ecx, dword ptr [ebp - local_20]          # 0048b39e
    mov word ptr [ecx + 2*eax + field_2e], 0xffff # 0048b3a1
    jmp.d8 L_0048b37b                            # 0048b3a8
L_0048b3aa:
    # block 0x0048b3aa: entered by jge at 0x0048b38f, 1 instruction(s), ends with forward jump to 0x0048b718
    jmp.d32 L_0048b718                           # 0048b3aa
L_0048b3af:
    # block 0x0048b3af: entered by je at 0x0048ae40, 5 instruction(s), ends with je to 0x0048b3d6 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0048b3af
    mov eax, dword ptr [edx + field_1b6]         # 0048b3b2
    mov dword ptr [ebp - local_34], eax          # 0048b3b8
    cmp dword ptr [ebp - local_34], 0x0          # 0048b3bb
    je.d8 L_0048b3d6                             # 0048b3bf
    # block 0x0048b3c1: entered by fall-through of je at 0x0048b3bf, 2 instruction(s), ends with je to 0x0048b401 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 0048b3c1
    je.d8 L_0048b401                             # 0048b3c5
    # block 0x0048b3c7: entered by fall-through of je at 0x0048b3c5, 2 instruction(s), ends with je to 0x0048b46a (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 0048b3c7
    je.d32 L_0048b46a                            # 0048b3cb
    # block 0x0048b3d1: entered by fall-through of je at 0x0048b3cb, 1 instruction(s), ends with forward jump to 0x0048b4b3
    jmp.d32 L_0048b4b3                           # 0048b3d1
L_0048b3d6:
    # block 0x0048b3d6: entered by je at 0x0048b3bf, 3 instruction(s), ends with je to 0x0048b3fc (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0048b3d6
    cmp dword ptr [ecx + field_44], 0x0          # 0048b3d9
    je.d8 L_0048b3fc                             # 0048b3dd
    # block 0x0048b3df: entered by fall-through of je at 0x0048b3dd, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0048b3fc (forward)
    call dword ptr [0x52a23c]                    # 0048b3df
    mov edx, dword ptr [ebp - local_20]          # 0048b3e5
    cmp eax, dword ptr [edx + field_4a]          # 0048b3e8
    jbe.d8 L_0048b3fc                            # 0048b3eb
    # block 0x0048b3ed: entered by fall-through of jbe at 0x0048b3eb, 3 instruction(s), ends with forward jump to 0x0048b4b3
    mov eax, dword ptr [ebp - local_20]          # 0048b3ed
    mov dword ptr [eax + field_4e], 0x1          # 0048b3f0
    jmp.d32 L_0048b4b3                           # 0048b3f7
L_0048b3fc:
    # block 0x0048b3fc: entered by je at 0x0048b3dd; jbe at 0x0048b3eb, 1 instruction(s), ends with forward jump to 0x0048b4b3
    jmp.d32 L_0048b4b3                           # 0048b3fc
L_0048b401:
    # block 0x0048b401: entered by je at 0x0048b3c5, 7 instruction(s), ends with je to 0x0048b451 (forward)
    mov edi, 0x54e430                            # 0048b401
    mov esi, dword ptr [ebp - local_c]           # 0048b406
    add esi, 0x3c1                               # 0048b409
    mov ecx, 0x9                                 # 0048b40f
    {load} xor edx, edx                          # 0048b414
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048b416
    je.d8 L_0048b451                             # 0048b418
    # block 0x0048b41a: entered by fall-through of je at 0x0048b418, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0048b468
    mov eax, dword ptr [ebp - local_c]           # 0048b41a
    add eax, 0x3c1                               # 0048b41d
    push eax                                     # 0048b422
    mov ecx, 0x5c3a67                            # 0048b423
    call FUN_004fb77a                            # 0048b428
    mov ecx, dword ptr [ebp - local_c]           # 0048b42d
    mov dx, word ptr [ecx + field_3e2]           # 0048b430
    push edx                                     # 0048b437
    mov ecx, 0x5c3a67                            # 0048b438
    call FUN_004fb2e3                            # 0048b43d
    mov eax, dword ptr [ebp - local_20]          # 0048b442
    mov dword ptr [eax + field_1b6], 0x2         # 0048b445
    jmp.d8 L_0048b468                            # 0048b44f
L_0048b451:
    # block 0x0048b451: entered by je at 0x0048b418, 4 instruction(s), falls into the block at 0x0048b468
    mov ecx, dword ptr [ebp - local_20]          # 0048b451
    movsx edx, word ptr [ecx + field_1e]         # 0048b454
    imul edx, edx, 0x8d                          # 0048b458
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048b45e
L_0048b468:
    # block 0x0048b468: entered by jmp at 0x0048b44f, 1 instruction(s), ends with forward jump to 0x0048b4b3
    jmp.d8 L_0048b4b3                            # 0048b468
L_0048b46a:
    # block 0x0048b46a: entered by je at 0x0048b3cb, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048b4b3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b46a
    movsx ecx, word ptr [eax + field_3e2]        # 0048b46d
    mov dword ptr [ebp - local_1c], ecx          # 0048b474
    mov edx, dword ptr [ebp - local_1c]          # 0048b477
    push edx                                     # 0048b47a
    mov ecx, 0x5cf1eb                            # 0048b47b
    call FUN_004f6334                            # 0048b480
    test eax, eax                                # 0048b485
    jne.d8 L_0048b4b3                            # 0048b487
    # block 0x0048b489: entered by fall-through of jne at 0x0048b487, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0048b4b3
    mov eax, dword ptr [ebp - local_c]           # 0048b489
    add eax, 0x3c1                               # 0048b48c
    push eax                                     # 0048b491
    mov ecx, 0x5c3a67                            # 0048b492
    call FUN_004fba69                            # 0048b497
    mov ecx, dword ptr [ebp - local_20]          # 0048b49c
    movsx edx, word ptr [ecx + field_1e]         # 0048b49f
    imul edx, edx, 0x8d                          # 0048b4a3
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048b4a9
L_0048b4b3:
    # block 0x0048b4b3: entered by jmp at 0x0048b3d1; jmp at 0x0048b3f7; jmp at 0x0048b3fc; jmp at 0x0048b468; more, 1 instruction(s), ends with forward jump to 0x0048b718
    jmp.d32 L_0048b718                           # 0048b4b3
L_0048b4b8:
    # block 0x0048b4b8: entered by je at 0x0048ae4a, 8 instruction(s), ends with je to 0x0048b4ef (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0048b4b8
    mov edi, 0x54e43c                            # 0048b4c2
    mov esi, dword ptr [ebp - local_c]           # 0048b4c7
    add esi, 0x344                               # 0048b4ca
    mov ecx, 0x9                                 # 0048b4d0
    {load} xor eax, eax                          # 0048b4d5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048b4d7
    je.d8 L_0048b4ef                             # 0048b4d9
    # block 0x0048b4db: entered by fall-through of je at 0x0048b4d9, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0048b4ef
    mov ecx, dword ptr [ebp - local_c]           # 0048b4db
    add ecx, 0x344                               # 0048b4de
    push ecx                                     # 0048b4e4
    mov ecx, 0x5c3a67                            # 0048b4e5
    call FUN_004fba69                            # 0048b4ea
L_0048b4ef:
    # block 0x0048b4ef: entered by je at 0x0048b4d9, 7 instruction(s), ends with je to 0x0048b51b (forward)
    mov edi, 0x54e448                            # 0048b4ef
    mov esi, dword ptr [ebp - local_c]           # 0048b4f4
    add esi, 0x375                               # 0048b4f7
    mov ecx, 0x9                                 # 0048b4fd
    {load} xor edx, edx                          # 0048b502
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048b504
    je.d8 L_0048b51b                             # 0048b506
    # block 0x0048b508: entered by fall-through of je at 0x0048b506, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0048b51b
    mov eax, dword ptr [ebp - local_c]           # 0048b508
    add eax, 0x375                               # 0048b50b
    push eax                                     # 0048b510
    mov ecx, 0x5c3a67                            # 0048b511
    call FUN_004fba69                            # 0048b516
L_0048b51b:
    # block 0x0048b51b: entered by je at 0x0048b506, 5 instruction(s), ends with je to 0x0048b610 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0048b51b
    {load} xor edx, edx                          # 0048b51e
    mov dl, byte ptr [ecx + field_1ae]           # 0048b520
    test edx, edx                                # 0048b526
    je.d32 L_0048b610                            # 0048b528
    # block 0x0048b52e: entered by fall-through of je at 0x0048b528, 4 instruction(s), ends with je to 0x0048b5e0 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b52e
    movsx ecx, word ptr [eax + field_3f2]        # 0048b531
    cmp ecx, 0x270f                              # 0048b538
    je.d32 L_0048b5e0                            # 0048b53e
    # block 0x0048b544: entered by fall-through of je at 0x0048b53e, 25 instruction(s), ends with jne to 0x0048b5cc (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048b544
    movsx eax, word ptr [edx + field_3f2]        # 0048b547
    mov dword ptr [0x5bb57b], eax                # 0048b54e
    mov ecx, dword ptr [ebp - local_c]           # 0048b553
    mov dx, word ptr [ecx + field_3f4]           # 0048b556
    mov word ptr [0x5bb599], dx                  # 0048b55d
    mov eax, dword ptr [ebp - local_c]           # 0048b564
    mov cx, word ptr [eax + field_3f6]           # 0048b567
    mov word ptr [0x5bb595], cx                  # 0048b56e
    mov edx, dword ptr [ebp - local_c]           # 0048b575
    mov ax, word ptr [edx + field_3f8]           # 0048b578
    mov word ptr [0x5c39ff], ax                  # 0048b57f
    mov ecx, dword ptr [ebp - local_c]           # 0048b585
    mov edx, dword ptr [ecx + field_3fa]         # 0048b588
    mov dword ptr [0x5bb59b], edx                # 0048b58e
    mov eax, dword ptr [ebp - local_c]           # 0048b594
    mov ecx, dword ptr [eax + field_3fe]         # 0048b597
    mov dword ptr [0x5bb59f], ecx                # 0048b59d
    mov edx, dword ptr [ebp - local_c]           # 0048b5a3
    mov eax, dword ptr [edx + field_402]         # 0048b5a6
    mov dword ptr [0x5bb5a3], eax                # 0048b5ac
    mov ecx, dword ptr [ebp - local_c]           # 0048b5b1
    movsx edx, word ptr [ecx + field_406]        # 0048b5b4
    cmp edx, 0x1                                 # 0048b5bb
    jne.d8 L_0048b5cc                            # 0048b5be
    # block 0x0048b5c0: entered by fall-through of jne at 0x0048b5be, 2 instruction(s), ends with forward jump to 0x0048b5d6
    mov dword ptr [0x5bb1ca], 0x0                # 0048b5c0
    jmp.d8 L_0048b5d6                            # 0048b5ca
L_0048b5cc:
    # block 0x0048b5cc: entered by jne at 0x0048b5be, 1 instruction(s), falls into the block at 0x0048b5d6
    mov dword ptr [0x5bb1ca], 0x1                # 0048b5cc
L_0048b5d6:
    # block 0x0048b5d6: entered by jmp at 0x0048b5ca, 1 instruction(s), falls into the block at 0x0048b5e0
    mov dword ptr [0x583999], 0x4                # 0048b5d6
L_0048b5e0:
    # block 0x0048b5e0: entered by je at 0x0048b53e, 4 instruction(s), ends with je to 0x0048b60b (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b5e0
    movsx ecx, word ptr [eax + field_408]        # 0048b5e3
    cmp ecx, -0x1                                # 0048b5ea
    je.d8 L_0048b60b                             # 0048b5ed
    # block 0x0048b5ef: entered by fall-through of je at 0x0048b5ed, 6 instruction(s), falls into the block at 0x0048b60b
    mov edx, dword ptr [ebp - local_c]           # 0048b5ef
    {load} xor eax, eax                          # 0048b5f2
    mov al, byte ptr [edx + field_40a]           # 0048b5f4
    mov ecx, dword ptr [ebp - local_c]           # 0048b5fa
    movsx edx, word ptr [ecx + field_408]        # 0048b5fd
    mov dword ptr [4*edx + 0x585801], eax        # 0048b604
L_0048b60b:
    # block 0x0048b60b: entered by je at 0x0048b5ed, 1 instruction(s), ends with forward jump to 0x0048b700
    jmp.d32 L_0048b700                           # 0048b60b
L_0048b610:
    # block 0x0048b610: entered by je at 0x0048b528, 5 instruction(s), ends with je to 0x0048b700 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0048b610
    {load} xor ecx, ecx                          # 0048b613
    mov cl, byte ptr [eax + field_1af]           # 0048b615
    test ecx, ecx                                # 0048b61b
    je.d32 L_0048b700                            # 0048b61d
    # block 0x0048b623: entered by fall-through of je at 0x0048b61d, 4 instruction(s), ends with je to 0x0048b6d5 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048b623
    movsx eax, word ptr [edx + field_3a8]        # 0048b626
    cmp eax, 0x270f                              # 0048b62d
    je.d32 L_0048b6d5                            # 0048b632
    # block 0x0048b638: entered by fall-through of je at 0x0048b632, 25 instruction(s), ends with jne to 0x0048b6c1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048b638
    movsx edx, word ptr [ecx + field_3a8]        # 0048b63b
    mov dword ptr [0x5bb57b], edx                # 0048b642
    mov eax, dword ptr [ebp - local_c]           # 0048b648
    mov cx, word ptr [eax + field_3aa]           # 0048b64b
    mov word ptr [0x5bb599], cx                  # 0048b652
    mov edx, dword ptr [ebp - local_c]           # 0048b659
    mov ax, word ptr [edx + field_3ac]           # 0048b65c
    mov word ptr [0x5bb595], ax                  # 0048b663
    mov ecx, dword ptr [ebp - local_c]           # 0048b669
    mov dx, word ptr [ecx + field_3ae]           # 0048b66c
    mov word ptr [0x5c39ff], dx                  # 0048b673
    mov eax, dword ptr [ebp - local_c]           # 0048b67a
    mov ecx, dword ptr [eax + field_3b0]         # 0048b67d
    mov dword ptr [0x5bb59b], ecx                # 0048b683
    mov edx, dword ptr [ebp - local_c]           # 0048b689
    mov eax, dword ptr [edx + field_3b4]         # 0048b68c
    mov dword ptr [0x5bb59f], eax                # 0048b692
    mov ecx, dword ptr [ebp - local_c]           # 0048b697
    mov edx, dword ptr [ecx + field_3b8]         # 0048b69a
    mov dword ptr [0x5bb5a3], edx                # 0048b6a0
    mov eax, dword ptr [ebp - local_c]           # 0048b6a6
    movsx ecx, word ptr [eax + field_3bc]        # 0048b6a9
    cmp ecx, 0x1                                 # 0048b6b0
    jne.d8 L_0048b6c1                            # 0048b6b3
    # block 0x0048b6b5: entered by fall-through of jne at 0x0048b6b3, 2 instruction(s), ends with forward jump to 0x0048b6cb
    mov dword ptr [0x5bb1ca], 0x0                # 0048b6b5
    jmp.d8 L_0048b6cb                            # 0048b6bf
L_0048b6c1:
    # block 0x0048b6c1: entered by jne at 0x0048b6b3, 1 instruction(s), falls into the block at 0x0048b6cb
    mov dword ptr [0x5bb1ca], 0x1                # 0048b6c1
L_0048b6cb:
    # block 0x0048b6cb: entered by jmp at 0x0048b6bf, 1 instruction(s), falls into the block at 0x0048b6d5
    mov dword ptr [0x583999], 0x4                # 0048b6cb
L_0048b6d5:
    # block 0x0048b6d5: entered by je at 0x0048b632, 4 instruction(s), ends with je to 0x0048b700 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048b6d5
    movsx eax, word ptr [edx + field_3be]        # 0048b6d8
    cmp eax, -0x1                                # 0048b6df
    je.d8 L_0048b700                             # 0048b6e2
    # block 0x0048b6e4: entered by fall-through of je at 0x0048b6e2, 6 instruction(s), falls into the block at 0x0048b700
    mov ecx, dword ptr [ebp - local_c]           # 0048b6e4
    {load} xor edx, edx                          # 0048b6e7
    mov dl, byte ptr [ecx + field_3c0]           # 0048b6e9
    mov eax, dword ptr [ebp - local_c]           # 0048b6ef
    movsx ecx, word ptr [eax + field_3be]        # 0048b6f2
    mov dword ptr [4*ecx + 0x585801], edx        # 0048b6f9
L_0048b700:
    # block 0x0048b700: entered by jmp at 0x0048b60b; je at 0x0048b61d; je at 0x0048b6e2, 7 instruction(s), calls FUN_0042ba3a, FUN_0048a7e5, falls into the block at 0x0048b718
    mov edx, dword ptr [ebp - local_20]          # 0048b700
    mov ax, word ptr [edx + field_1e]            # 0048b703
    push eax                                     # 0048b707
    call FUN_0042ba3a                            # 0048b708
    add esp, 0x4                                 # 0048b70d
    mov ecx, dword ptr [ebp - local_20]          # 0048b710
    call FUN_0048a7e5                            # 0048b713
L_0048b718:
    # block 0x0048b718: entered by jmp at 0x0048ae50; jmp at 0x0048b3aa; jmp at 0x0048b4b3, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0048b718
    pop esi                                      # 0048b719
    {load} mov esp, ebp                          # 0048b71a
    pop ebp                                      # 0048b71c
    ret 0x4                                      # 0048b71d

