# FUN_0049c889
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c889
# extent:       0x0049c889-0x0049cf80 (1783 code bytes)
# span:         0x0049c889-0x0049cf80 (code 1783, tables 0, padding 0)
# sha256:       04750a52dfbfe4f0b2f7b3d1d7116f3dcb64c2200de7d876e0632d07a36f0d20
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049c889
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 4 more
# fields:       [eax + n] field_1, field_1c, field_20, field_24, field_294, field_dd8, field_de0, field_df4, field_e00, field_e08, field_e0c, field_e2c and 3 more; [ecx + n] field_1c, field_20, field_24, field_dd8, field_ddc, field_de4, field_df4, field_e00, field_e04, field_e30, field_e40; [edx + n] field_1, field_1c, field_20, field_24, field_dd8, field_ddc, field_dec, field_e04, field_e08, field_e0c, field_e30, field_e34 and 5 more
# callees:      calls FUN_0049c68a, FUN_0051dc43, FUN_0052139c, FUN_004c97b4, FUN_0049cf80, FUN_004a14c6, FUN_0049d1be, FUN_0049d55d, FUN_004a0c7f, FUN_004a0cea, FUN_0049d755, FUN_0049d039, FUN_004a10f1, FUN_004a0d73
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 513 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_294, 0x294  # offset +0x294
.equ field_dd8, 0xdd8  # offset +0xdd8
.equ field_ddc, 0xddc  # offset +0xddc
.equ field_de0, 0xde0  # offset +0xde0
.equ field_de4, 0xde4  # offset +0xde4
.equ field_dec, 0xdec  # offset +0xdec
.equ field_df4, 0xdf4  # offset +0xdf4
.equ field_e00, 0xe00  # offset +0xe00
.equ field_e04, 0xe04  # offset +0xe04
.equ field_e08, 0xe08  # offset +0xe08
.equ field_e0c, 0xe0c  # offset +0xe0c
.equ field_e2c, 0xe2c  # offset +0xe2c
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e34, 0xe34  # offset +0xe34
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e40, 0xe40  # offset +0xe40
.equ field_e44, 0xe44  # offset +0xe44
.equ field_e48, 0xe48  # offset +0xe48

# --- external targets -----------------------------------------------
.set FUN_0049c68a, .text + (0x0049c68a - 0x401000)
.set FUN_0049cf80, .text + (0x0049cf80 - 0x401000)
.set FUN_0049d039, .text + (0x0049d039 - 0x401000)
.set FUN_0049d1be, .text + (0x0049d1be - 0x401000)
.set FUN_0049d55d, .text + (0x0049d55d - 0x401000)
.set FUN_0049d755, .text + (0x0049d755 - 0x401000)
.set FUN_004a0c7f, .text + (0x004a0c7f - 0x401000)
.set FUN_004a0cea, .text + (0x004a0cea - 0x401000)
.set FUN_004a0d73, .text + (0x004a0d73 - 0x401000)
.set FUN_004a10f1, .text + (0x004a10f1 - 0x401000)
.set FUN_004a14c6, .text + (0x004a14c6 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049c889 - 0x401000
.globl FUN_0049c889
FUN_0049c889:
    # block 0x0049c889: entry, 143 instruction(s), calls FUN_0049c68a, ends with forward jump to 0x0049ca77
    push ebp                                     # 0049c889
    {load} mov ebp, esp                          # 0049c88a
    sub esp, 0x40                                # 0049c88c
    push edi                                     # 0049c88f
    mov dword ptr [ebp - local_3c], ecx          # 0049c890
    mov ecx, dword ptr [ebp - local_3c]          # 0049c893
    call FUN_0049c68a                            # 0049c896
    mov eax, dword ptr [ebp - local_3c]          # 0049c89b
    mov ecx, dword ptr [ebp + arg_10]            # 0049c89e
    mov dword ptr [eax + field_e0c], ecx         # 0049c8a1
    mov edx, dword ptr [ebp - local_3c]          # 0049c8a7
    mov eax, dword ptr [ebp + arg_8]             # 0049c8aa
    mov dword ptr [edx + field_dd8], eax         # 0049c8ad
    mov ecx, dword ptr [ebp - local_3c]          # 0049c8b3
    mov edx, dword ptr [ebp + arg_c]             # 0049c8b6
    mov dword ptr [ecx + field_ddc], edx         # 0049c8b9
    mov eax, dword ptr [ebp - local_3c]          # 0049c8bf
    mov ecx, dword ptr [ebp - local_3c]          # 0049c8c2
    mov edx, dword ptr [eax + field_dd8]         # 0049c8c5
    imul edx, dword ptr [ecx + field_ddc]        # 0049c8cb
    mov eax, dword ptr [ebp - local_3c]          # 0049c8d2
    mov dword ptr [eax + field_df4], edx         # 0049c8d5
    mov ecx, dword ptr [ebp - local_3c]          # 0049c8db
    mov edx, dword ptr [ecx + field_dd8]         # 0049c8de
    lea eax, [edx + edx + field_1]               # 0049c8e4
    mov ecx, dword ptr [ebp - local_3c]          # 0049c8e8
    mov dword ptr [ecx + field_e00], eax         # 0049c8eb
    mov edx, dword ptr [ebp - local_3c]          # 0049c8f1
    mov eax, dword ptr [edx + field_ddc]         # 0049c8f4
    lea ecx, [eax + eax + field_1]               # 0049c8fa
    mov edx, dword ptr [ebp - local_3c]          # 0049c8fe
    mov dword ptr [edx + field_e04], ecx         # 0049c901
    mov eax, dword ptr [ebp - local_3c]          # 0049c907
    mov ecx, dword ptr [ebp - local_3c]          # 0049c90a
    mov edx, dword ptr [eax + field_e00]         # 0049c90d
    imul edx, dword ptr [ecx + field_e04]        # 0049c913
    mov eax, dword ptr [ebp - local_3c]          # 0049c91a
    mov dword ptr [eax + field_e08], edx         # 0049c91d
    mov ecx, dword ptr [ebp - local_3c]          # 0049c923
    mov edx, dword ptr [ecx + field_e00]         # 0049c926
    shl edx                                      # 0049c92c
    mov eax, dword ptr [ebp - local_3c]          # 0049c92e
    mov dword ptr [eax + field_1c], edx          # 0049c931
    mov ecx, dword ptr [ebp - local_3c]          # 0049c934
    mov edx, dword ptr [ecx + field_e04]         # 0049c937
    shl edx                                      # 0049c93d
    mov eax, dword ptr [ebp - local_3c]          # 0049c93f
    mov dword ptr [eax + field_20], edx          # 0049c942
    mov ecx, dword ptr [ebp - local_3c]          # 0049c945
    mov edx, dword ptr [ebp - local_3c]          # 0049c948
    mov eax, dword ptr [ecx + field_1c]          # 0049c94b
    imul eax, dword ptr [edx + field_20]         # 0049c94e
    mov ecx, dword ptr [ebp - local_3c]          # 0049c952
    mov dword ptr [ecx + field_24], eax          # 0049c955
    mov edx, dword ptr [ebp - local_3c]          # 0049c958
    fild dword ptr [edx + field_24]              # 0049c95b
    fstp dword ptr [ebp - local_40]              # 0049c95e
    fld dword ptr [ebp - local_40]               # 0049c961
    fdiv dword ptr [0x52dc18]                    # 0049c964
    mov eax, dword ptr [ebp - local_3c]          # 0049c96a
    fstp dword ptr [eax + field_e2c]             # 0049c96d
    mov ecx, dword ptr [0x6329d9]                # 0049c973
    shl ecx, 0x2                                 # 0049c979
    {load} xor eax, eax                          # 0049c97c
    mov edi, dword ptr [0x6329e1]                # 0049c97e
    {load} mov edx, ecx                          # 0049c984
    shr ecx, 0x2                                 # 0049c986
    rep stosd dword ptr es:[edi], eax            # 0049c989
    {load} mov ecx, edx                          # 0049c98b
    and ecx, 0x3                                 # 0049c98d
    rep stosb byte ptr es:[edi], al              # 0049c990
    mov ecx, dword ptr [0x6329d9]                # 0049c992
    shl ecx                                      # 0049c998
    {load} xor eax, eax                          # 0049c99a
    mov edi, dword ptr [0x6329e5]                # 0049c99c
    {load} mov edx, ecx                          # 0049c9a2
    shr ecx, 0x2                                 # 0049c9a4
    rep stosd dword ptr es:[edi], eax            # 0049c9a7
    {load} mov ecx, edx                          # 0049c9a9
    and ecx, 0x3                                 # 0049c9ab
    rep stosb byte ptr es:[edi], al              # 0049c9ae
    mov ecx, dword ptr [0x6329d9]                # 0049c9b0
    shl ecx                                      # 0049c9b6
    {load} xor eax, eax                          # 0049c9b8
    mov edi, dword ptr [0x6329e9]                # 0049c9ba
    {load} mov edx, ecx                          # 0049c9c0
    shr ecx, 0x2                                 # 0049c9c2
    rep stosd dword ptr es:[edi], eax            # 0049c9c5
    {load} mov ecx, edx                          # 0049c9c7
    and ecx, 0x3                                 # 0049c9c9
    rep stosb byte ptr es:[edi], al              # 0049c9cc
    mov ecx, dword ptr [0x6329d9]                # 0049c9ce
    shl ecx, 0x2                                 # 0049c9d4
    {load} xor eax, eax                          # 0049c9d7
    mov edi, dword ptr [0x6329ed]                # 0049c9d9
    {load} mov edx, ecx                          # 0049c9df
    shr ecx, 0x2                                 # 0049c9e1
    rep stosd dword ptr es:[edi], eax            # 0049c9e4
    {load} mov ecx, edx                          # 0049c9e6
    and ecx, 0x3                                 # 0049c9e8
    rep stosb byte ptr es:[edi], al              # 0049c9eb
    mov ecx, dword ptr [0x6329d9]                # 0049c9ed
    shl ecx                                      # 0049c9f3
    {load} xor eax, eax                          # 0049c9f5
    mov edi, dword ptr [0x6329f1]                # 0049c9f7
    {load} mov edx, ecx                          # 0049c9fd
    shr ecx, 0x2                                 # 0049c9ff
    rep stosd dword ptr es:[edi], eax            # 0049ca02
    {load} mov ecx, edx                          # 0049ca04
    and ecx, 0x3                                 # 0049ca06
    rep stosb byte ptr es:[edi], al              # 0049ca09
    mov ecx, dword ptr [0x6329d9]                # 0049ca0b
    shl ecx                                      # 0049ca11
    {load} xor eax, eax                          # 0049ca13
    mov edi, dword ptr [0x6329f5]                # 0049ca15
    {load} mov edx, ecx                          # 0049ca1b
    shr ecx, 0x2                                 # 0049ca1d
    rep stosd dword ptr es:[edi], eax            # 0049ca20
    {load} mov ecx, edx                          # 0049ca22
    and ecx, 0x3                                 # 0049ca24
    rep stosb byte ptr es:[edi], al              # 0049ca27
    mov ecx, dword ptr [0x6329d9]                # 0049ca29
    shl ecx                                      # 0049ca2f
    {load} xor eax, eax                          # 0049ca31
    mov edi, dword ptr [0x6329f9]                # 0049ca33
    {load} mov edx, ecx                          # 0049ca39
    shr ecx, 0x2                                 # 0049ca3b
    rep stosd dword ptr es:[edi], eax            # 0049ca3e
    {load} mov ecx, edx                          # 0049ca40
    and ecx, 0x3                                 # 0049ca42
    rep stosb byte ptr es:[edi], al              # 0049ca45
    mov ecx, dword ptr [0x6329d9]                # 0049ca47
    shl ecx                                      # 0049ca4d
    {load} xor eax, eax                          # 0049ca4f
    mov edi, dword ptr [0x6329fd]                # 0049ca51
    {load} mov edx, ecx                          # 0049ca57
    shr ecx, 0x2                                 # 0049ca59
    rep stosd dword ptr es:[edi], eax            # 0049ca5c
    {load} mov ecx, edx                          # 0049ca5e
    and ecx, 0x3                                 # 0049ca60
    rep stosb byte ptr es:[edi], al              # 0049ca63
    mov dword ptr [ebp - local_8], 0x0           # 0049ca65
    jmp.d8 L_0049ca77                            # 0049ca6c
L_0049ca6e:
    # block 0x0049ca6e: entered by jmp at 0x0049cac5, 3 instruction(s), falls into the block at 0x0049ca77
    mov eax, dword ptr [ebp - local_8]           # 0049ca6e
    add eax, 0x1                                 # 0049ca71
    mov dword ptr [ebp - local_8], eax           # 0049ca74
L_0049ca77:
    # block 0x0049ca77: entered by jmp at 0x0049ca6c, 2 instruction(s), ends with jge to 0x0049cac7 (forward)
    cmp dword ptr [ebp - local_8], 0xa6          # 0049ca77
    jge.d8 L_0049cac7                            # 0049ca7e
    # block 0x0049ca80: entered by fall-through of jge at 0x0049ca7e, 2 instruction(s), ends with forward jump to 0x0049ca92
    mov dword ptr [ebp - local_4], 0x0           # 0049ca80
    jmp.d8 L_0049ca92                            # 0049ca87
L_0049ca89:
    # block 0x0049ca89: entered by jmp at 0x0049cac3, 3 instruction(s), falls into the block at 0x0049ca92
    mov ecx, dword ptr [ebp - local_4]           # 0049ca89
    add ecx, 0x1                                 # 0049ca8c
    mov dword ptr [ebp - local_4], ecx           # 0049ca8f
L_0049ca92:
    # block 0x0049ca92: entered by jmp at 0x0049ca87, 2 instruction(s), ends with jge to 0x0049cac5 (forward)
    cmp dword ptr [ebp - local_4], 0xa6          # 0049ca92
    jge.d8 L_0049cac5                            # 0049ca99
    # block 0x0049ca9b: entered by fall-through of jge at 0x0049ca99, 10 instruction(s), ends with backward jump to 0x0049ca89
    mov edx, dword ptr [ebp - local_3c]          # 0049ca9b
    mov eax, dword ptr [0x6329d5]                # 0049ca9e
    imul eax, dword ptr [edx + field_e0c]        # 0049caa3
    mov ecx, dword ptr [ebp - local_8]           # 0049caaa
    imul ecx, ecx, 0xa6                          # 0049caad
    mov edx, dword ptr [0x632a01]                # 0049cab3
    lea ecx, [edx + 2*ecx]                       # 0049cab9
    mov edx, dword ptr [ebp - local_4]           # 0049cabc
    mov word ptr [ecx + 2*edx], ax               # 0049cabf
    jmp.d8 L_0049ca89                            # 0049cac3
L_0049cac5:
    # block 0x0049cac5: entered by jge at 0x0049ca99, 1 instruction(s), ends with backward jump to 0x0049ca6e
    jmp.d8 L_0049ca6e                            # 0049cac5
L_0049cac7:
    # block 0x0049cac7: entered by jge at 0x0049ca7e, 2 instruction(s), ends with forward jump to 0x0049cad9
    mov dword ptr [ebp - local_c], 0x0           # 0049cac7
    jmp.d8 L_0049cad9                            # 0049cace
L_0049cad0:
    # block 0x0049cad0: entered by jmp at 0x0049cb5a, 3 instruction(s), falls into the block at 0x0049cad9
    mov eax, dword ptr [ebp - local_c]           # 0049cad0
    add eax, 0x1                                 # 0049cad3
    mov dword ptr [ebp - local_c], eax           # 0049cad6
L_0049cad9:
    # block 0x0049cad9: entered by jmp at 0x0049cace, 2 instruction(s), ends with jge to 0x0049cb5f (forward)
    cmp dword ptr [ebp - local_c], 0xa6          # 0049cad9
    jge.d8 L_0049cb5f                            # 0049cae0
    # block 0x0049cae2: entered by fall-through of jge at 0x0049cae0, 2 instruction(s), ends with je to 0x0049caf1 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 0049cae2
    je.d8 L_0049caf1                             # 0049cae6
    # block 0x0049cae8: entered by fall-through of je at 0x0049cae6, 2 instruction(s), ends with jne to 0x0049cb2b (forward)
    cmp dword ptr [ebp - local_c], 0xa5          # 0049cae8
    jne.d8 L_0049cb2b                            # 0049caef
L_0049caf1:
    # block 0x0049caf1: entered by je at 0x0049cae6; fall-through of jne at 0x0049caef, 2 instruction(s), ends with forward jump to 0x0049cb03
    mov dword ptr [ebp - local_10], 0x0          # 0049caf1
    jmp.d8 L_0049cb03                            # 0049caf8
L_0049cafa:
    # block 0x0049cafa: entered by jmp at 0x0049cb27, 3 instruction(s), falls into the block at 0x0049cb03
    mov ecx, dword ptr [ebp - local_10]          # 0049cafa
    add ecx, 0x1                                 # 0049cafd
    mov dword ptr [ebp - local_10], ecx          # 0049cb00
L_0049cb03:
    # block 0x0049cb03: entered by jmp at 0x0049caf8, 2 instruction(s), ends with jge to 0x0049cb29 (forward)
    cmp dword ptr [ebp - local_10], 0xa6         # 0049cb03
    jge.d8 L_0049cb29                            # 0049cb0a
    # block 0x0049cb0c: entered by fall-through of jge at 0x0049cb0a, 7 instruction(s), ends with backward jump to 0x0049cafa
    mov edx, dword ptr [ebp - local_c]           # 0049cb0c
    imul edx, edx, 0xa6                          # 0049cb0f
    mov eax, dword ptr [0x6329e1]                # 0049cb15
    lea ecx, [eax + 4*edx]                       # 0049cb1a
    mov edx, dword ptr [ebp - local_10]          # 0049cb1d
    mov dword ptr [ecx + 4*edx], 0x1010101       # 0049cb20
    jmp.d8 L_0049cafa                            # 0049cb27
L_0049cb29:
    # block 0x0049cb29: entered by jge at 0x0049cb0a, 1 instruction(s), ends with forward jump to 0x0049cb5a
    jmp.d8 L_0049cb5a                            # 0049cb29
L_0049cb2b:
    # block 0x0049cb2b: entered by jne at 0x0049caef, 8 instruction(s), falls into the block at 0x0049cb5a
    mov eax, dword ptr [ebp - local_c]           # 0049cb2b
    imul eax, eax, 0xa6                          # 0049cb2e
    mov ecx, dword ptr [0x6329e1]                # 0049cb34
    mov dword ptr [ecx + 4*eax], 0x1010101       # 0049cb3a
    mov edx, dword ptr [ebp - local_c]           # 0049cb41
    imul edx, edx, 0xa6                          # 0049cb44
    mov eax, dword ptr [0x6329e1]                # 0049cb4a
    mov dword ptr [eax + 4*edx + field_294], 0x1010101 # 0049cb4f
L_0049cb5a:
    # block 0x0049cb5a: entered by jmp at 0x0049cb29, 1 instruction(s), ends with backward jump to 0x0049cad0
    jmp.d32 L_0049cad0                           # 0049cb5a
L_0049cb5f:
    # block 0x0049cb5f: entered by jge at 0x0049cae0, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cba0 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049cb5f
    mov edx, dword ptr [ecx + field_df4]         # 0049cb62
    shl edx                                      # 0049cb68
    push edx                                     # 0049cb6a
    call FUN_0051dc43                            # 0049cb6b
    add esp, 0x4                                 # 0049cb70
    mov dword ptr [ebp - local_14], eax          # 0049cb73
    mov eax, dword ptr [ebp - local_3c]          # 0049cb76
    mov ecx, dword ptr [ebp - local_14]          # 0049cb79
    mov dword ptr [eax + field_de0], ecx         # 0049cb7c
    cmp dword ptr [ebp - local_14], 0x0          # 0049cb82
    jne.d8 L_0049cba0                            # 0049cb86
    # block 0x0049cb88: entered by fall-through of jne at 0x0049cb86, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cba0
    push 0x0                                     # 0049cb88
    push 0x0                                     # 0049cb8a
    push 0x54fa0c                                # 0049cb8c
    call FUN_0052139c                            # 0049cb91
    mov ecx, 0x5cf659                            # 0049cb96
    call FUN_004c97b4                            # 0049cb9b
L_0049cba0:
    # block 0x0049cba0: entered by jne at 0x0049cb86, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cbdf (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0049cba0
    mov eax, dword ptr [edx + field_e08]         # 0049cba3
    push eax                                     # 0049cba9
    call FUN_0051dc43                            # 0049cbaa
    add esp, 0x4                                 # 0049cbaf
    mov dword ptr [ebp - local_18], eax          # 0049cbb2
    mov ecx, dword ptr [ebp - local_3c]          # 0049cbb5
    mov edx, dword ptr [ebp - local_18]          # 0049cbb8
    mov dword ptr [ecx + field_de4], edx         # 0049cbbb
    cmp dword ptr [ebp - local_18], 0x0          # 0049cbc1
    jne.d8 L_0049cbdf                            # 0049cbc5
    # block 0x0049cbc7: entered by fall-through of jne at 0x0049cbc5, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cbdf
    push 0x0                                     # 0049cbc7
    push 0x0                                     # 0049cbc9
    push 0x54fa60                                # 0049cbcb
    call FUN_0052139c                            # 0049cbd0
    mov ecx, 0x5cf659                            # 0049cbd5
    call FUN_004c97b4                            # 0049cbda
L_0049cbdf:
    # block 0x0049cbdf: entered by jne at 0x0049cbc5, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cc21 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0049cbdf
    mov ecx, dword ptr [eax + field_df4]         # 0049cbe2
    shl ecx, 0x3                                 # 0049cbe8
    push ecx                                     # 0049cbeb
    call FUN_0051dc43                            # 0049cbec
    add esp, 0x4                                 # 0049cbf1
    mov dword ptr [ebp - local_1c], eax          # 0049cbf4
    mov edx, dword ptr [ebp - local_3c]          # 0049cbf7
    mov eax, dword ptr [ebp - local_1c]          # 0049cbfa
    mov dword ptr [edx + field_dec], eax         # 0049cbfd
    cmp dword ptr [ebp - local_1c], 0x0          # 0049cc03
    jne.d8 L_0049cc21                            # 0049cc07
    # block 0x0049cc09: entered by fall-through of jne at 0x0049cc07, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cc21
    push 0x0                                     # 0049cc09
    push 0x0                                     # 0049cc0b
    push 0x54fab4                                # 0049cc0d
    call FUN_0052139c                            # 0049cc12
    mov ecx, 0x5cf659                            # 0049cc17
    call FUN_004c97b4                            # 0049cc1c
L_0049cc21:
    # block 0x0049cc21: entered by jne at 0x0049cc07, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cc60 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049cc21
    mov edx, dword ptr [ecx + field_24]          # 0049cc24
    shl edx, 0x2                                 # 0049cc27
    push edx                                     # 0049cc2a
    call FUN_0051dc43                            # 0049cc2b
    add esp, 0x4                                 # 0049cc30
    mov dword ptr [ebp - local_20], eax          # 0049cc33
    mov eax, dword ptr [ebp - local_3c]          # 0049cc36
    mov ecx, dword ptr [ebp - local_20]          # 0049cc39
    mov dword ptr [eax + field_e38], ecx         # 0049cc3c
    cmp dword ptr [ebp - local_20], 0x0          # 0049cc42
    jne.d8 L_0049cc60                            # 0049cc46
    # block 0x0049cc48: entered by fall-through of jne at 0x0049cc46, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cc60
    push 0x0                                     # 0049cc48
    push 0x0                                     # 0049cc4a
    push 0x54fb0c                                # 0049cc4c
    call FUN_0052139c                            # 0049cc51
    mov ecx, 0x5cf659                            # 0049cc56
    call FUN_004c97b4                            # 0049cc5b
L_0049cc60:
    # block 0x0049cc60: entered by jne at 0x0049cc46, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cc9e (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0049cc60
    mov eax, dword ptr [edx + field_24]          # 0049cc63
    shl eax                                      # 0049cc66
    push eax                                     # 0049cc68
    call FUN_0051dc43                            # 0049cc69
    add esp, 0x4                                 # 0049cc6e
    mov dword ptr [ebp - local_24], eax          # 0049cc71
    mov ecx, dword ptr [ebp - local_3c]          # 0049cc74
    mov edx, dword ptr [ebp - local_24]          # 0049cc77
    mov dword ptr [ecx + field_e30], edx         # 0049cc7a
    cmp dword ptr [ebp - local_24], 0x0          # 0049cc80
    jne.d8 L_0049cc9e                            # 0049cc84
    # block 0x0049cc86: entered by fall-through of jne at 0x0049cc84, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cc9e
    push 0x0                                     # 0049cc86
    push 0x0                                     # 0049cc88
    push 0x54fb68                                # 0049cc8a
    call FUN_0052139c                            # 0049cc8f
    mov ecx, 0x5cf659                            # 0049cc94
    call FUN_004c97b4                            # 0049cc99
L_0049cc9e:
    # block 0x0049cc9e: entered by jne at 0x0049cc84, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049ccdc (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0049cc9e
    mov ecx, dword ptr [eax + field_24]          # 0049cca1
    shl ecx                                      # 0049cca4
    push ecx                                     # 0049cca6
    call FUN_0051dc43                            # 0049cca7
    add esp, 0x4                                 # 0049ccac
    mov dword ptr [ebp - local_28], eax          # 0049ccaf
    mov edx, dword ptr [ebp - local_3c]          # 0049ccb2
    mov eax, dword ptr [ebp - local_28]          # 0049ccb5
    mov dword ptr [edx + field_e34], eax         # 0049ccb8
    cmp dword ptr [ebp - local_28], 0x0          # 0049ccbe
    jne.d8 L_0049ccdc                            # 0049ccc2
    # block 0x0049ccc4: entered by fall-through of jne at 0x0049ccc2, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049ccdc
    push 0x0                                     # 0049ccc4
    push 0x0                                     # 0049ccc6
    push 0x54fbc4                                # 0049ccc8
    call FUN_0052139c                            # 0049cccd
    mov ecx, 0x5cf659                            # 0049ccd2
    call FUN_004c97b4                            # 0049ccd7
L_0049ccdc:
    # block 0x0049ccdc: entered by jne at 0x0049ccc2, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cd1b (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049ccdc
    mov edx, dword ptr [ecx + field_24]          # 0049ccdf
    shl edx, 0x2                                 # 0049cce2
    push edx                                     # 0049cce5
    call FUN_0051dc43                            # 0049cce6
    add esp, 0x4                                 # 0049cceb
    mov dword ptr [ebp - local_2c], eax          # 0049ccee
    mov eax, dword ptr [ebp - local_3c]          # 0049ccf1
    mov ecx, dword ptr [ebp - local_2c]          # 0049ccf4
    mov dword ptr [eax + field_e3c], ecx         # 0049ccf7
    cmp dword ptr [ebp - local_2c], 0x0          # 0049ccfd
    jne.d8 L_0049cd1b                            # 0049cd01
    # block 0x0049cd03: entered by fall-through of jne at 0x0049cd01, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cd1b
    push 0x0                                     # 0049cd03
    push 0x0                                     # 0049cd05
    push 0x54fc24                                # 0049cd07
    call FUN_0052139c                            # 0049cd0c
    mov ecx, 0x5cf659                            # 0049cd11
    call FUN_004c97b4                            # 0049cd16
L_0049cd1b:
    # block 0x0049cd1b: entered by jne at 0x0049cd01, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cd59 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0049cd1b
    mov eax, dword ptr [edx + field_24]          # 0049cd1e
    shl eax                                      # 0049cd21
    push eax                                     # 0049cd23
    call FUN_0051dc43                            # 0049cd24
    add esp, 0x4                                 # 0049cd29
    mov dword ptr [ebp - local_30], eax          # 0049cd2c
    mov ecx, dword ptr [ebp - local_3c]          # 0049cd2f
    mov edx, dword ptr [ebp - local_30]          # 0049cd32
    mov dword ptr [ecx + field_e40], edx         # 0049cd35
    cmp dword ptr [ebp - local_30], 0x0          # 0049cd3b
    jne.d8 L_0049cd59                            # 0049cd3f
    # block 0x0049cd41: entered by fall-through of jne at 0x0049cd3f, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cd59
    push 0x0                                     # 0049cd41
    push 0x0                                     # 0049cd43
    push 0x54fc80                                # 0049cd45
    call FUN_0052139c                            # 0049cd4a
    mov ecx, 0x5cf659                            # 0049cd4f
    call FUN_004c97b4                            # 0049cd54
L_0049cd59:
    # block 0x0049cd59: entered by jne at 0x0049cd3f, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cd97 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0049cd59
    mov ecx, dword ptr [eax + field_24]          # 0049cd5c
    shl ecx                                      # 0049cd5f
    push ecx                                     # 0049cd61
    call FUN_0051dc43                            # 0049cd62
    add esp, 0x4                                 # 0049cd67
    mov dword ptr [ebp - local_34], eax          # 0049cd6a
    mov edx, dword ptr [ebp - local_3c]          # 0049cd6d
    mov eax, dword ptr [ebp - local_34]          # 0049cd70
    mov dword ptr [edx + field_e44], eax         # 0049cd73
    cmp dword ptr [ebp - local_34], 0x0          # 0049cd79
    jne.d8 L_0049cd97                            # 0049cd7d
    # block 0x0049cd7f: entered by fall-through of jne at 0x0049cd7d, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cd97
    push 0x0                                     # 0049cd7f
    push 0x0                                     # 0049cd81
    push 0x54fce0                                # 0049cd83
    call FUN_0052139c                            # 0049cd88
    mov ecx, 0x5cf659                            # 0049cd8d
    call FUN_004c97b4                            # 0049cd92
L_0049cd97:
    # block 0x0049cd97: entered by jne at 0x0049cd7d, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049cdd5 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049cd97
    mov edx, dword ptr [ecx + field_24]          # 0049cd9a
    shl edx                                      # 0049cd9d
    push edx                                     # 0049cd9f
    call FUN_0051dc43                            # 0049cda0
    add esp, 0x4                                 # 0049cda5
    mov dword ptr [ebp - local_38], eax          # 0049cda8
    mov eax, dword ptr [ebp - local_3c]          # 0049cdab
    mov ecx, dword ptr [ebp - local_38]          # 0049cdae
    mov dword ptr [eax + field_e48], ecx         # 0049cdb1
    cmp dword ptr [ebp - local_38], 0x0          # 0049cdb7
    jne.d8 L_0049cdd5                            # 0049cdbb
    # block 0x0049cdbd: entered by fall-through of jne at 0x0049cdbb, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049cdd5
    push 0x0                                     # 0049cdbd
    push 0x0                                     # 0049cdbf
    push 0x54fd48                                # 0049cdc1
    call FUN_0052139c                            # 0049cdc6
    mov ecx, 0x5cf659                            # 0049cdcb
    call FUN_004c97b4                            # 0049cdd0
L_0049cdd5:
    # block 0x0049cdd5: entered by jne at 0x0049cdbb, 74 instruction(s), ends with forward jump to 0x0049ceaf
    mov edx, dword ptr [ebp - local_3c]          # 0049cdd5
    mov ecx, dword ptr [edx + field_24]          # 0049cdd8
    shl ecx, 0x2                                 # 0049cddb
    {load} xor eax, eax                          # 0049cdde
    mov edx, dword ptr [ebp - local_3c]          # 0049cde0
    mov edi, dword ptr [edx + field_e38]         # 0049cde3
    {load} mov edx, ecx                          # 0049cde9
    shr ecx, 0x2                                 # 0049cdeb
    rep stosd dword ptr es:[edi], eax            # 0049cdee
    {load} mov ecx, edx                          # 0049cdf0
    and ecx, 0x3                                 # 0049cdf2
    rep stosb byte ptr es:[edi], al              # 0049cdf5
    mov eax, dword ptr [ebp - local_3c]          # 0049cdf7
    mov ecx, dword ptr [eax + field_24]          # 0049cdfa
    shl ecx                                      # 0049cdfd
    {load} xor eax, eax                          # 0049cdff
    mov edx, dword ptr [ebp - local_3c]          # 0049ce01
    mov edi, dword ptr [edx + field_e30]         # 0049ce04
    {load} mov edx, ecx                          # 0049ce0a
    shr ecx, 0x2                                 # 0049ce0c
    rep stosd dword ptr es:[edi], eax            # 0049ce0f
    {load} mov ecx, edx                          # 0049ce11
    and ecx, 0x3                                 # 0049ce13
    rep stosb byte ptr es:[edi], al              # 0049ce16
    mov eax, dword ptr [ebp - local_3c]          # 0049ce18
    mov ecx, dword ptr [eax + field_24]          # 0049ce1b
    shl ecx                                      # 0049ce1e
    {load} xor eax, eax                          # 0049ce20
    mov edx, dword ptr [ebp - local_3c]          # 0049ce22
    mov edi, dword ptr [edx + field_e34]         # 0049ce25
    {load} mov edx, ecx                          # 0049ce2b
    shr ecx, 0x2                                 # 0049ce2d
    rep stosd dword ptr es:[edi], eax            # 0049ce30
    {load} mov ecx, edx                          # 0049ce32
    and ecx, 0x3                                 # 0049ce34
    rep stosb byte ptr es:[edi], al              # 0049ce37
    mov eax, dword ptr [ebp - local_3c]          # 0049ce39
    mov ecx, dword ptr [eax + field_24]          # 0049ce3c
    shl ecx, 0x2                                 # 0049ce3f
    {load} xor eax, eax                          # 0049ce42
    mov edx, dword ptr [ebp - local_3c]          # 0049ce44
    mov edi, dword ptr [edx + field_e3c]         # 0049ce47
    {load} mov edx, ecx                          # 0049ce4d
    shr ecx, 0x2                                 # 0049ce4f
    rep stosd dword ptr es:[edi], eax            # 0049ce52
    {load} mov ecx, edx                          # 0049ce54
    and ecx, 0x3                                 # 0049ce56
    rep stosb byte ptr es:[edi], al              # 0049ce59
    mov eax, dword ptr [ebp - local_3c]          # 0049ce5b
    mov ecx, dword ptr [eax + field_24]          # 0049ce5e
    shl ecx                                      # 0049ce61
    {load} xor eax, eax                          # 0049ce63
    mov edx, dword ptr [ebp - local_3c]          # 0049ce65
    mov edi, dword ptr [edx + field_e40]         # 0049ce68
    {load} mov edx, ecx                          # 0049ce6e
    shr ecx, 0x2                                 # 0049ce70
    rep stosd dword ptr es:[edi], eax            # 0049ce73
    {load} mov ecx, edx                          # 0049ce75
    and ecx, 0x3                                 # 0049ce77
    rep stosb byte ptr es:[edi], al              # 0049ce7a
    mov eax, dword ptr [ebp - local_3c]          # 0049ce7c
    mov ecx, dword ptr [eax + field_24]          # 0049ce7f
    shl ecx                                      # 0049ce82
    {load} xor eax, eax                          # 0049ce84
    mov edx, dword ptr [ebp - local_3c]          # 0049ce86
    mov edi, dword ptr [edx + field_e44]         # 0049ce89
    {load} mov edx, ecx                          # 0049ce8f
    shr ecx, 0x2                                 # 0049ce91
    rep stosd dword ptr es:[edi], eax            # 0049ce94
    {load} mov ecx, edx                          # 0049ce96
    and ecx, 0x3                                 # 0049ce98
    rep stosb byte ptr es:[edi], al              # 0049ce9b
    mov dword ptr [ebp - local_8], 0x0           # 0049ce9d
    jmp.d8 L_0049ceaf                            # 0049cea4
L_0049cea6:
    # block 0x0049cea6: entered by jmp at 0x0049cf06, 3 instruction(s), falls into the block at 0x0049ceaf
    mov eax, dword ptr [ebp - local_8]           # 0049cea6
    add eax, 0x1                                 # 0049cea9
    mov dword ptr [ebp - local_8], eax           # 0049ceac
L_0049ceaf:
    # block 0x0049ceaf: entered by jmp at 0x0049cea4, 4 instruction(s), ends with jge to 0x0049cf08 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049ceaf
    mov edx, dword ptr [ebp - local_8]           # 0049ceb2
    cmp edx, dword ptr [ecx + field_20]          # 0049ceb5
    jge.d8 L_0049cf08                            # 0049ceb8
    # block 0x0049ceba: entered by fall-through of jge at 0x0049ceb8, 2 instruction(s), ends with forward jump to 0x0049cecc
    mov dword ptr [ebp - local_4], 0x0           # 0049ceba
    jmp.d8 L_0049cecc                            # 0049cec1
L_0049cec3:
    # block 0x0049cec3: entered by jmp at 0x0049cf04, 3 instruction(s), falls into the block at 0x0049cecc
    mov eax, dword ptr [ebp - local_4]           # 0049cec3
    add eax, 0x1                                 # 0049cec6
    mov dword ptr [ebp - local_4], eax           # 0049cec9
L_0049cecc:
    # block 0x0049cecc: entered by jmp at 0x0049cec1, 4 instruction(s), ends with jge to 0x0049cf06 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0049cecc
    mov edx, dword ptr [ebp - local_4]           # 0049cecf
    cmp edx, dword ptr [ecx + field_1c]          # 0049ced2
    jge.d8 L_0049cf06                            # 0049ced5
    # block 0x0049ced7: entered by fall-through of jge at 0x0049ced5, 12 instruction(s), ends with backward jump to 0x0049cec3
    mov eax, dword ptr [ebp - local_3c]          # 0049ced7
    mov ecx, dword ptr [0x6329d5]                # 0049ceda
    imul ecx, dword ptr [eax + field_e0c]        # 0049cee0
    mov edx, dword ptr [ebp - local_3c]          # 0049cee7
    mov eax, dword ptr [ebp - local_8]           # 0049ceea
    imul eax, dword ptr [edx + field_1c]         # 0049ceed
    mov edx, dword ptr [ebp - local_3c]          # 0049cef1
    mov edx, dword ptr [edx + field_e48]         # 0049cef4
    lea eax, [edx + 2*eax]                       # 0049cefa
    mov edx, dword ptr [ebp - local_4]           # 0049cefd
    mov word ptr [eax + 2*edx], cx               # 0049cf00
    jmp.d8 L_0049cec3                            # 0049cf04
L_0049cf06:
    # block 0x0049cf06: entered by jge at 0x0049ced5, 1 instruction(s), ends with backward jump to 0x0049cea6
    jmp.d8 L_0049cea6                            # 0049cf06
L_0049cf08:
    # block 0x0049cf08: entered by jge at 0x0049ceb8, 30 instruction(s), calls FUN_0049cf80, FUN_004a14c6, FUN_0049d1be, FUN_0049d55d, FUN_004a0c7f, FUN_004a0cea, FUN_0049d755,..., ends with ret 0xc
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf08
    call FUN_0049cf80                            # 0049cf0b
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf10
    call FUN_004a14c6                            # 0049cf13
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf18
    call FUN_0049d1be                            # 0049cf1b
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf20
    call FUN_0049d55d                            # 0049cf23
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf28
    call FUN_004a0c7f                            # 0049cf2b
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf30
    call FUN_004a0cea                            # 0049cf33
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf38
    call FUN_0049d755                            # 0049cf3b
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf40
    call FUN_0049d039                            # 0049cf43
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf48
    call FUN_004a10f1                            # 0049cf4b
    mov eax, dword ptr [ebp - local_3c]          # 0049cf50
    mov ecx, dword ptr [eax + field_e0c]         # 0049cf53
    mov dword ptr [0x6329c1], ecx                # 0049cf59
    mov dword ptr [0x6329c5], 0x40b00000         # 0049cf5f
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf69
    call FUN_004a0d73                            # 0049cf6c
    mov ecx, dword ptr [ebp - local_3c]          # 0049cf71
    call FUN_0049c68a                            # 0049cf74
    pop edi                                      # 0049cf79
    {load} mov esp, ebp                          # 0049cf7a
    pop ebp                                      # 0049cf7c
    ret 0xc                                      # 0049cf7d

