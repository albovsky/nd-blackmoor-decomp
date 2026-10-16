# FUN_00478a2c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478a2c
# extent:       0x00478a2c-0x00478e6b (1087 code bytes)
# span:         0x00478a2c-0x00478e7b (code 1087, tables 16, padding 0)
# sha256:       e191bbb71b7178af89d078be018288d9df36f95e8a89ead81eddbac3ccfb6212
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478a2c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_1c2, field_1590, field_1596, field_159c; [ecx + n] field_4, field_8, field_c, field_158e, field_1594, field_159a, field_159c; [edx + n] field_4, field_8, field_c, field_28, field_1c2, field_1586, field_158a, field_1592, field_1598, field_159c
# callees:      calls FUN_00479cd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 289 instruction(s), 12 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_28, 0x28  # offset +0x28
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1586, 0x1586  # offset +0x1586
.equ field_158a, 0x158a  # offset +0x158a
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590
.equ field_1592, 0x1592  # offset +0x1592
.equ field_1594, 0x1594  # offset +0x1594
.equ field_1596, 0x1596  # offset +0x1596
.equ field_1598, 0x1598  # offset +0x1598
.equ field_159a, 0x159a  # offset +0x159a
.equ field_159c, 0x159c  # offset +0x159c

# --- external targets -----------------------------------------------
.set FUN_00479cd7, .text + (0x00479cd7 - 0x401000)

.org 0x00478a2c - 0x401000
.globl FUN_00478a2c
FUN_00478a2c:
    # block 0x00478a2c: entry, 13 instruction(s), ends with je to 0x00478aab (forward)
    push ebp                                     # 00478a2c
    {load} mov ebp, esp                          # 00478a2d
    sub esp, 0x30                                # 00478a2f
    mov dword ptr [ebp - local_24], ecx          # 00478a32
    mov eax, dword ptr [ebp - local_24]          # 00478a35
    movsx ecx, word ptr [eax + field_1e]         # 00478a38
    imul ecx, ecx, 0x8d                          # 00478a3c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00478a42
    mov dword ptr [ebp - local_20], edx          # 00478a48
    movsx eax, word ptr [ebp + arg_8]            # 00478a4b
    mov dword ptr [ebp - local_28], eax          # 00478a4f
    cmp dword ptr [ebp - local_28], 0x1          # 00478a52
    je.d8 L_00478aab                             # 00478a56
    # block 0x00478a58: entered by fall-through of je at 0x00478a56, 2 instruction(s), ends with je to 0x00478ae9 (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 00478a58
    je.d32 L_00478ae9                            # 00478a5c
    # block 0x00478a62: entered by fall-through of je at 0x00478a5c, 2 instruction(s), ends with je to 0x00478a6d (forward)
    cmp dword ptr [ebp - local_28], 0x3          # 00478a62
    je.d8 L_00478a6d                             # 00478a66
    # block 0x00478a68: entered by fall-through of je at 0x00478a66, 1 instruction(s), ends with forward jump to 0x00478b24
    jmp.d32 L_00478b24                           # 00478a68
L_00478a6d:
    # block 0x00478a6d: entered by je at 0x00478a66, 17 instruction(s), ends with forward jump to 0x00478b24
    mov ecx, dword ptr [ebp - local_24]          # 00478a6d
    add ecx, 0x1536                              # 00478a70
    mov edx, dword ptr [ecx]                     # 00478a76
    mov dword ptr [ebp - local_14], edx          # 00478a78
    mov eax, dword ptr [ecx + field_4]           # 00478a7b
    mov dword ptr [ebp - local_10], eax          # 00478a7e
    mov edx, dword ptr [ecx + field_8]           # 00478a81
    mov dword ptr [ebp - local_c], edx           # 00478a84
    mov eax, dword ptr [ecx + field_c]           # 00478a87
    mov dword ptr [ebp - local_8], eax           # 00478a8a
    mov ecx, dword ptr [ebp - local_24]          # 00478a8d
    mov dx, word ptr [ecx + field_158e]          # 00478a90
    mov word ptr [ebp - local_1c], dx            # 00478a97
    mov eax, dword ptr [ebp - local_24]          # 00478a9b
    mov cx, word ptr [eax + field_1590]          # 00478a9e
    mov word ptr [ebp - local_18], cx            # 00478aa5
    jmp.d8 L_00478b24                            # 00478aa9
L_00478aab:
    # block 0x00478aab: entered by je at 0x00478a56, 17 instruction(s), ends with forward jump to 0x00478b24
    mov edx, dword ptr [ebp - local_24]          # 00478aab
    add edx, 0x1546                              # 00478aae
    mov eax, dword ptr [edx]                     # 00478ab4
    mov dword ptr [ebp - local_14], eax          # 00478ab6
    mov ecx, dword ptr [edx + field_4]           # 00478ab9
    mov dword ptr [ebp - local_10], ecx          # 00478abc
    mov eax, dword ptr [edx + field_8]           # 00478abf
    mov dword ptr [ebp - local_c], eax           # 00478ac2
    mov ecx, dword ptr [edx + field_c]           # 00478ac5
    mov dword ptr [ebp - local_8], ecx           # 00478ac8
    mov edx, dword ptr [ebp - local_24]          # 00478acb
    mov ax, word ptr [edx + field_1592]          # 00478ace
    mov word ptr [ebp - local_1c], ax            # 00478ad5
    mov ecx, dword ptr [ebp - local_24]          # 00478ad9
    mov dx, word ptr [ecx + field_1594]          # 00478adc
    mov word ptr [ebp - local_18], dx            # 00478ae3
    jmp.d8 L_00478b24                            # 00478ae7
L_00478ae9:
    # block 0x00478ae9: entered by je at 0x00478a5c, 16 instruction(s), falls into the block at 0x00478b24
    mov eax, dword ptr [ebp - local_24]          # 00478ae9
    add eax, 0x1556                              # 00478aec
    mov ecx, dword ptr [eax]                     # 00478af1
    mov dword ptr [ebp - local_14], ecx          # 00478af3
    mov edx, dword ptr [eax + field_4]           # 00478af6
    mov dword ptr [ebp - local_10], edx          # 00478af9
    mov ecx, dword ptr [eax + field_8]           # 00478afc
    mov dword ptr [ebp - local_c], ecx           # 00478aff
    mov edx, dword ptr [eax + field_c]           # 00478b02
    mov dword ptr [ebp - local_8], edx           # 00478b05
    mov eax, dword ptr [ebp - local_24]          # 00478b08
    mov cx, word ptr [eax + field_1596]          # 00478b0b
    mov word ptr [ebp - local_1c], cx            # 00478b12
    mov edx, dword ptr [ebp - local_24]          # 00478b16
    mov ax, word ptr [edx + field_1598]          # 00478b19
    mov word ptr [ebp - local_18], ax            # 00478b20
L_00478b24:
    # block 0x00478b24: entered by jmp at 0x00478a68; jmp at 0x00478aa9; jmp at 0x00478ae7, 18 instruction(s), ends with ja to 0x00478d1e (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00478b24
    add ecx, 0x1566                              # 00478b27
    mov edx, dword ptr [ebp - local_14]          # 00478b2d
    mov dword ptr [ecx], edx                     # 00478b30
    mov eax, dword ptr [ebp - local_10]          # 00478b32
    mov dword ptr [ecx + field_4], eax           # 00478b35
    mov edx, dword ptr [ebp - local_c]           # 00478b38
    mov dword ptr [ecx + field_8], edx           # 00478b3b
    mov eax, dword ptr [ebp - local_8]           # 00478b3e
    mov dword ptr [ecx + field_c], eax           # 00478b41
    mov ecx, dword ptr [ebp - local_24]          # 00478b44
    movsx edx, word ptr [ecx + field_159a]       # 00478b47
    mov dword ptr [ebp - local_2c], edx          # 00478b4e
    mov eax, dword ptr [ebp - local_2c]          # 00478b51
    sub eax, 0x1                                 # 00478b54
    mov dword ptr [ebp - local_2c], eax          # 00478b57
    cmp dword ptr [ebp - local_2c], 0x3          # 00478b5a
    ja.d32 L_00478d1e                            # 00478b5e
    # block 0x00478b64: entered by fall-through of ja at 0x00478b5e, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x478e6b]
    mov ecx, dword ptr [ebp - local_2c]          # 00478b64
    jmp dword ptr [4*ecx + SWTAB_00478e6b_VA]    # 00478b67
L_00478b6e:
    # block 0x00478b6e: entered by switch case, 24 instruction(s), ends with jne to 0x00478bd7 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00478b6e
    movsx ecx, word ptr [edx + field_1c2]        # 00478b71
    mov edx, dword ptr [ebp - local_24]          # 00478b78
    mov eax, dword ptr [edx + field_1586]        # 00478b7b
    cdq                                          # 00478b81
    idiv ecx                                     # 00478b82
    mov ecx, dword ptr [ebp - local_14]          # 00478b84
    {load} sub ecx, eax                          # 00478b87
    mov dword ptr [ebp - local_14], ecx          # 00478b89
    mov edx, dword ptr [ebp - local_24]          # 00478b8c
    mov eax, dword ptr [ebp - local_14]          # 00478b8f
    add eax, dword ptr [edx + field_1586]        # 00478b92
    mov dword ptr [ebp - local_c], eax           # 00478b98
    mov ecx, dword ptr [ebp - local_24]          # 00478b9b
    mov dx, word ptr [ecx + field_159c]          # 00478b9e
    add dx, 0x1                                  # 00478ba5
    mov eax, dword ptr [ebp - local_24]          # 00478ba9
    mov word ptr [eax + field_159c], dx          # 00478bac
    mov ecx, dword ptr [ebp - local_24]          # 00478bb3
    movsx edx, word ptr [ecx + field_159c]       # 00478bb6
    mov eax, dword ptr [ebp - local_20]          # 00478bbd
    movsx ecx, word ptr [eax + field_1c2]        # 00478bc0
    {load} cmp edx, ecx                          # 00478bc7
    jne.d8 L_00478bd7                            # 00478bc9
    # block 0x00478bcb: entered by fall-through of jne at 0x00478bc9, 3 instruction(s), falls into the block at 0x00478bd7
    mov dx, word ptr [ebp - local_1c]            # 00478bcb
    sub dx, 0x1                                  # 00478bcf
    mov word ptr [ebp - local_1c], dx            # 00478bd3
L_00478bd7:
    # block 0x00478bd7: entered by jne at 0x00478bc9, 1 instruction(s), ends with forward jump to 0x00478d1e
    jmp.d32 L_00478d1e                           # 00478bd7
L_00478bdc:
    # block 0x00478bdc: entered by switch case, 24 instruction(s), ends with jne to 0x00478c45 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00478bdc
    movsx ecx, word ptr [eax + field_1c2]        # 00478bdf
    mov edx, dword ptr [ebp - local_24]          # 00478be6
    mov eax, dword ptr [edx + field_158a]        # 00478be9
    cdq                                          # 00478bef
    idiv ecx                                     # 00478bf0
    mov ecx, dword ptr [ebp - local_10]          # 00478bf2
    {load} sub ecx, eax                          # 00478bf5
    mov dword ptr [ebp - local_10], ecx          # 00478bf7
    mov edx, dword ptr [ebp - local_24]          # 00478bfa
    mov eax, dword ptr [ebp - local_10]          # 00478bfd
    add eax, dword ptr [edx + field_158a]        # 00478c00
    mov dword ptr [ebp - local_8], eax           # 00478c06
    mov ecx, dword ptr [ebp - local_24]          # 00478c09
    mov dx, word ptr [ecx + field_159c]          # 00478c0c
    add dx, 0x1                                  # 00478c13
    mov eax, dword ptr [ebp - local_24]          # 00478c17
    mov word ptr [eax + field_159c], dx          # 00478c1a
    mov ecx, dword ptr [ebp - local_24]          # 00478c21
    movsx edx, word ptr [ecx + field_159c]       # 00478c24
    mov eax, dword ptr [ebp - local_20]          # 00478c2b
    movsx ecx, word ptr [eax + field_1c2]        # 00478c2e
    {load} cmp edx, ecx                          # 00478c35
    jne.d8 L_00478c45                            # 00478c37
    # block 0x00478c39: entered by fall-through of jne at 0x00478c37, 3 instruction(s), falls into the block at 0x00478c45
    mov dx, word ptr [ebp - local_18]            # 00478c39
    sub dx, 0x1                                  # 00478c3d
    mov word ptr [ebp - local_18], dx            # 00478c41
L_00478c45:
    # block 0x00478c45: entered by jne at 0x00478c37, 1 instruction(s), ends with forward jump to 0x00478d1e
    jmp.d32 L_00478d1e                           # 00478c45
L_00478c4a:
    # block 0x00478c4a: entered by switch case, 24 instruction(s), ends with jne to 0x00478cb3 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00478c4a
    movsx ecx, word ptr [eax + field_1c2]        # 00478c4d
    mov edx, dword ptr [ebp - local_24]          # 00478c54
    mov eax, dword ptr [edx + field_158a]        # 00478c57
    cdq                                          # 00478c5d
    idiv ecx                                     # 00478c5e
    mov ecx, dword ptr [ebp - local_10]          # 00478c60
    {load} add ecx, eax                          # 00478c63
    mov dword ptr [ebp - local_10], ecx          # 00478c65
    mov edx, dword ptr [ebp - local_24]          # 00478c68
    mov eax, dword ptr [ebp - local_10]          # 00478c6b
    add eax, dword ptr [edx + field_158a]        # 00478c6e
    mov dword ptr [ebp - local_8], eax           # 00478c74
    mov ecx, dword ptr [ebp - local_24]          # 00478c77
    mov dx, word ptr [ecx + field_159c]          # 00478c7a
    add dx, 0x1                                  # 00478c81
    mov eax, dword ptr [ebp - local_24]          # 00478c85
    mov word ptr [eax + field_159c], dx          # 00478c88
    mov ecx, dword ptr [ebp - local_24]          # 00478c8f
    movsx edx, word ptr [ecx + field_159c]       # 00478c92
    mov eax, dword ptr [ebp - local_20]          # 00478c99
    movsx ecx, word ptr [eax + field_1c2]        # 00478c9c
    {load} cmp edx, ecx                          # 00478ca3
    jne.d8 L_00478cb3                            # 00478ca5
    # block 0x00478ca7: entered by fall-through of jne at 0x00478ca5, 3 instruction(s), falls into the block at 0x00478cb3
    mov dx, word ptr [ebp - local_18]            # 00478ca7
    add dx, 0x1                                  # 00478cab
    mov word ptr [ebp - local_18], dx            # 00478caf
L_00478cb3:
    # block 0x00478cb3: entered by jne at 0x00478ca5, 1 instruction(s), ends with forward jump to 0x00478d1e
    jmp.d8 L_00478d1e                            # 00478cb3
L_00478cb5:
    # block 0x00478cb5: entered by switch case, 24 instruction(s), ends with jne to 0x00478d1e (forward)
    mov eax, dword ptr [ebp - local_20]          # 00478cb5
    movsx ecx, word ptr [eax + field_1c2]        # 00478cb8
    mov edx, dword ptr [ebp - local_24]          # 00478cbf
    mov eax, dword ptr [edx + field_1586]        # 00478cc2
    cdq                                          # 00478cc8
    idiv ecx                                     # 00478cc9
    mov ecx, dword ptr [ebp - local_14]          # 00478ccb
    {load} add ecx, eax                          # 00478cce
    mov dword ptr [ebp - local_14], ecx          # 00478cd0
    mov edx, dword ptr [ebp - local_24]          # 00478cd3
    mov eax, dword ptr [ebp - local_14]          # 00478cd6
    add eax, dword ptr [edx + field_1586]        # 00478cd9
    mov dword ptr [ebp - local_c], eax           # 00478cdf
    mov ecx, dword ptr [ebp - local_24]          # 00478ce2
    mov dx, word ptr [ecx + field_159c]          # 00478ce5
    add dx, 0x1                                  # 00478cec
    mov eax, dword ptr [ebp - local_24]          # 00478cf0
    mov word ptr [eax + field_159c], dx          # 00478cf3
    mov ecx, dword ptr [ebp - local_24]          # 00478cfa
    movsx edx, word ptr [ecx + field_159c]       # 00478cfd
    mov eax, dword ptr [ebp - local_20]          # 00478d04
    movsx ecx, word ptr [eax + field_1c2]        # 00478d07
    {load} cmp edx, ecx                          # 00478d0e
    jne.d8 L_00478d1e                            # 00478d10
    # block 0x00478d12: entered by fall-through of jne at 0x00478d10, 3 instruction(s), falls into the block at 0x00478d1e
    mov dx, word ptr [ebp - local_1c]            # 00478d12
    add dx, 0x1                                  # 00478d16
    mov word ptr [ebp - local_1c], dx            # 00478d1a
L_00478d1e:
    # block 0x00478d1e: entered by ja at 0x00478b5e; jmp at 0x00478bd7; jmp at 0x00478c45; jmp at 0x00478cb3; more, 6 instruction(s), ends with jl to 0x00478d82 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00478d1e
    movsx ecx, word ptr [eax + field_159c]       # 00478d21
    mov edx, dword ptr [ebp - local_20]          # 00478d28
    movsx eax, word ptr [edx + field_1c2]        # 00478d2b
    {load} cmp ecx, eax                          # 00478d32
    jl.d8 L_00478d82                             # 00478d34
    # block 0x00478d36: entered by fall-through of jl at 0x00478d34, 20 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00478d89
    movsx ecx, word ptr [ebp - local_18]         # 00478d36
    imul ecx, ecx, 0x2a0                         # 00478d3a
    mov edx, dword ptr [ebp - local_24]          # 00478d40
    lea eax, [edx + ecx + field_28]              # 00478d43
    movsx ecx, word ptr [ebp - local_1c]         # 00478d47
    imul ecx, ecx, 0x54                          # 00478d4b
    mov dword ptr [eax + ecx], 0x1               # 00478d4e
    lea edx, [ebp - local_14]                    # 00478d55
    push edx                                     # 00478d58
    push 0x0                                     # 00478d59
    mov ax, word ptr [ebp - local_1c]            # 00478d5b
    push eax                                     # 00478d5f
    mov cx, word ptr [ebp - local_18]            # 00478d60
    push ecx                                     # 00478d64
    mov ecx, dword ptr [ebp - local_24]          # 00478d65
    call FUN_00479cd7                            # 00478d68
    mov edx, dword ptr [ebp - local_24]          # 00478d6d
    mov word ptr [edx + field_159c], 0x0         # 00478d70
    mov dword ptr [ebp - local_4], 0x1           # 00478d79
    jmp.d8 L_00478d89                            # 00478d80
L_00478d82:
    # block 0x00478d82: entered by jl at 0x00478d34, 1 instruction(s), falls into the block at 0x00478d89
    mov dword ptr [ebp - local_4], 0x0           # 00478d82
L_00478d89:
    # block 0x00478d89: entered by jmp at 0x00478d80, 4 instruction(s), ends with je to 0x00478de9 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00478d89
    mov dword ptr [ebp - local_30], eax          # 00478d8d
    cmp dword ptr [ebp - local_30], 0x1          # 00478d90
    je.d8 L_00478de9                             # 00478d94
    # block 0x00478d96: entered by fall-through of je at 0x00478d94, 2 instruction(s), ends with je to 0x00478e27 (forward)
    cmp dword ptr [ebp - local_30], 0x2          # 00478d96
    je.d32 L_00478e27                            # 00478d9a
    # block 0x00478da0: entered by fall-through of je at 0x00478d9a, 2 instruction(s), ends with je to 0x00478dab (forward)
    cmp dword ptr [ebp - local_30], 0x3          # 00478da0
    je.d8 L_00478dab                             # 00478da4
    # block 0x00478da6: entered by fall-through of je at 0x00478da4, 1 instruction(s), ends with forward jump to 0x00478e62
    jmp.d32 L_00478e62                           # 00478da6
L_00478dab:
    # block 0x00478dab: entered by je at 0x00478da4, 17 instruction(s), ends with forward jump to 0x00478e62
    mov ecx, dword ptr [ebp - local_24]          # 00478dab
    add ecx, 0x1536                              # 00478dae
    mov edx, dword ptr [ebp - local_14]          # 00478db4
    mov dword ptr [ecx], edx                     # 00478db7
    mov eax, dword ptr [ebp - local_10]          # 00478db9
    mov dword ptr [ecx + field_4], eax           # 00478dbc
    mov edx, dword ptr [ebp - local_c]           # 00478dbf
    mov dword ptr [ecx + field_8], edx           # 00478dc2
    mov eax, dword ptr [ebp - local_8]           # 00478dc5
    mov dword ptr [ecx + field_c], eax           # 00478dc8
    mov ecx, dword ptr [ebp - local_24]          # 00478dcb
    mov dx, word ptr [ebp - local_1c]            # 00478dce
    mov word ptr [ecx + field_158e], dx          # 00478dd2
    mov eax, dword ptr [ebp - local_24]          # 00478dd9
    mov cx, word ptr [ebp - local_18]            # 00478ddc
    mov word ptr [eax + field_1590], cx          # 00478de0
    jmp.d8 L_00478e62                            # 00478de7
L_00478de9:
    # block 0x00478de9: entered by je at 0x00478d94, 17 instruction(s), ends with forward jump to 0x00478e62
    mov edx, dword ptr [ebp - local_24]          # 00478de9
    add edx, 0x1546                              # 00478dec
    mov eax, dword ptr [ebp - local_14]          # 00478df2
    mov dword ptr [edx], eax                     # 00478df5
    mov ecx, dword ptr [ebp - local_10]          # 00478df7
    mov dword ptr [edx + field_4], ecx           # 00478dfa
    mov eax, dword ptr [ebp - local_c]           # 00478dfd
    mov dword ptr [edx + field_8], eax           # 00478e00
    mov ecx, dword ptr [ebp - local_8]           # 00478e03
    mov dword ptr [edx + field_c], ecx           # 00478e06
    mov edx, dword ptr [ebp - local_24]          # 00478e09
    mov ax, word ptr [ebp - local_1c]            # 00478e0c
    mov word ptr [edx + field_1592], ax          # 00478e10
    mov ecx, dword ptr [ebp - local_24]          # 00478e17
    mov dx, word ptr [ebp - local_18]            # 00478e1a
    mov word ptr [ecx + field_1594], dx          # 00478e1e
    jmp.d8 L_00478e62                            # 00478e25
L_00478e27:
    # block 0x00478e27: entered by je at 0x00478d9a, 16 instruction(s), falls into the block at 0x00478e62
    mov eax, dword ptr [ebp - local_24]          # 00478e27
    add eax, 0x1556                              # 00478e2a
    mov ecx, dword ptr [ebp - local_14]          # 00478e2f
    mov dword ptr [eax], ecx                     # 00478e32
    mov edx, dword ptr [ebp - local_10]          # 00478e34
    mov dword ptr [eax + field_4], edx           # 00478e37
    mov ecx, dword ptr [ebp - local_c]           # 00478e3a
    mov dword ptr [eax + field_8], ecx           # 00478e3d
    mov edx, dword ptr [ebp - local_8]           # 00478e40
    mov dword ptr [eax + field_c], edx           # 00478e43
    mov eax, dword ptr [ebp - local_24]          # 00478e46
    mov cx, word ptr [ebp - local_1c]            # 00478e49
    mov word ptr [eax + field_1596], cx          # 00478e4d
    mov edx, dword ptr [ebp - local_24]          # 00478e54
    mov ax, word ptr [ebp - local_18]            # 00478e57
    mov word ptr [edx + field_1598], ax          # 00478e5b
L_00478e62:
    # block 0x00478e62: entered by jmp at 0x00478da6; jmp at 0x00478de7; jmp at 0x00478e25, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00478e62
    {load} mov esp, ebp                          # 00478e65
    pop ebp                                      # 00478e67
    ret 0x4                                      # 00478e68

# --- data items (not part of the function) -------------------------
.org 0x00478e6b - 0x401000
SWTAB_00478e6b:  # 4 case address(es)
    .long L_00478bdc - .text + 0x401000
    .long L_00478cb5 - .text + 0x401000
    .long L_00478c4a - .text + 0x401000
    .long L_00478b6e - .text + 0x401000
.set SWTAB_00478e6b_VA, SWTAB_00478e6b - .text + 0x401000

