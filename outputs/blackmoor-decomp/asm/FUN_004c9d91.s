# FUN_004c9d91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9d91
# extent:       0x004c9d91-0x004ca5b6 (2085 code bytes)
# span:         0x004c9d91-0x004ca5b6 (code 2085, tables 0, padding 0)
# sha256:       eb26950469f47313c2d2762b5c317f12f19fb5d0c77feccea62e3aff67f68ac8
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c9d91
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_300, field_30c, field_c4e, field_e82, field_1758, field_175c, field_1760, field_1f24, field_1f28, field_1f30 and 1 more; [ecx + n] field_184, field_304, field_30c, field_31c, field_c4a, field_c4e, field_1758, field_175c, field_1760, field_1f24, field_1f28, field_1f30 and 1 more; [edx + n] field_300, field_304, field_380, field_c4a, field_e82, field_1758, field_175c, field_1760, field_1f24, field_1f28, field_1f30
# callees:      calls FUN_004c9b66, FUN_0050ca3e, FUN_0044a2b7, FUN_004fcec4, FUN_004264e8, FUN_004ca92e, FUN_004c9cdd, FUN_004c9c10, FUN_004c9ca0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 475 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_184, 0x184  # offset +0x184
.equ field_300, 0x300  # offset +0x300
.equ field_304, 0x304  # offset +0x304
.equ field_30c, 0x30c  # offset +0x30c
.equ field_31c, 0x31c  # offset +0x31c
.equ field_380, 0x380  # offset +0x380
.equ field_c4a, 0xc4a  # offset +0xc4a
.equ field_c4e, 0xc4e  # offset +0xc4e
.equ field_e82, 0xe82  # offset +0xe82
.equ field_1758, 0x1758  # offset +0x1758
.equ field_175c, 0x175c  # offset +0x175c
.equ field_1760, 0x1760  # offset +0x1760
.equ field_1f24, 0x1f24  # offset +0x1f24
.equ field_1f28, 0x1f28  # offset +0x1f28
.equ field_1f30, 0x1f30  # offset +0x1f30
.equ field_1f34, 0x1f34  # offset +0x1f34

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c9b66, .text + (0x004c9b66 - 0x401000)
.set FUN_004c9c10, .text + (0x004c9c10 - 0x401000)
.set FUN_004c9ca0, .text + (0x004c9ca0 - 0x401000)
.set FUN_004c9cdd, .text + (0x004c9cdd - 0x401000)
.set FUN_004ca92e, .text + (0x004ca92e - 0x401000)
.set FUN_004fcec4, .text + (0x004fcec4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c9d91 - 0x401000
.globl FUN_004c9d91
FUN_004c9d91:
    # block 0x004c9d91: entry, 20 instruction(s), ends with je to 0x004c9dfa (forward)
    push ebp                                     # 004c9d91
    {load} mov ebp, esp                          # 004c9d92
    sub esp, 0x28                                # 004c9d94
    push esi                                     # 004c9d97
    push edi                                     # 004c9d98
    mov dword ptr [ebp - local_20], ecx          # 004c9d99
    mov eax, dword ptr [ebp - local_20]          # 004c9d9c
    mov dword ptr [eax + field_1f34], 0x0        # 004c9d9f
    mov ecx, dword ptr [ebp - local_20]          # 004c9da9
    mov edx, dword ptr [ecx + field_1f24]        # 004c9dac
    mov dword ptr [edx + field_175c], 0xffffffff # 004c9db2
    mov eax, dword ptr [ebp - local_20]          # 004c9dbc
    mov ecx, dword ptr [eax + field_1f24]        # 004c9dbf
    mov dword ptr [ecx + field_1760], 0xffffffff # 004c9dc5
    mov edx, dword ptr [ebp - local_20]          # 004c9dcf
    mov eax, dword ptr [edx + field_1f24]        # 004c9dd2
    mov dword ptr [eax + field_1758], 0x0        # 004c9dd8
    mov ecx, dword ptr [ebp - local_20]          # 004c9de2
    cmp dword ptr [ecx + field_1f30], 0x2        # 004c9de5
    je.d8 L_004c9dfa                             # 004c9dec
    # block 0x004c9dee: entered by fall-through of je at 0x004c9dec, 3 instruction(s), ends with jne to 0x004c9e02 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004c9dee
    cmp dword ptr [edx + field_1f30], 0x3        # 004c9df1
    jne.d8 L_004c9e02                            # 004c9df8
L_004c9dfa:
    # block 0x004c9dfa: entered by je at 0x004c9dec; fall-through of jne at 0x004c9df8, 2 instruction(s), calls FUN_004c9b66, falls into the block at 0x004c9e02
    mov ecx, dword ptr [ebp - local_20]          # 004c9dfa
    call FUN_004c9b66                            # 004c9dfd
L_004c9e02:
    # block 0x004c9e02: entered by jne at 0x004c9df8, 3 instruction(s), ends with jne to 0x004c9f5c (forward)
    mov eax, dword ptr [ebp - local_20]          # 004c9e02
    cmp dword ptr [eax + field_1f30], 0x2        # 004c9e05
    jne.d32 L_004c9f5c                           # 004c9e0c
    # block 0x004c9e12: entered by fall-through of jne at 0x004c9e0c, 3 instruction(s), ends with je to 0x004c9f5c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004c9e12
    cmp dword ptr [ecx + field_1f34], 0x0        # 004c9e15
    je.d32 L_004c9f5c                            # 004c9e1c
    # block 0x004c9e22: entered by fall-through of je at 0x004c9e1c, 53 instruction(s), ends with je to 0x004c9f52 (forward)
    mov ecx, 0x5d9                               # 004c9e22
    mov edx, dword ptr [ebp - local_20]          # 004c9e27
    mov esi, dword ptr [edx + field_1f28]        # 004c9e2a
    mov eax, dword ptr [ebp - local_20]          # 004c9e30
    mov edi, dword ptr [eax + field_1f24]        # 004c9e33
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c9e39
    mov ecx, dword ptr [ebp - local_20]          # 004c9e3b
    mov edx, dword ptr [ecx + field_1f24]        # 004c9e3e
    mov eax, dword ptr [edx + field_1760]        # 004c9e44
    shl eax, 0x6                                 # 004c9e4a
    mov cx, word ptr [eax + 0x552bf0]            # 004c9e4d
    mov word ptr [0x63988b], cx                  # 004c9e54
    mov edx, dword ptr [ebp - local_20]          # 004c9e5b
    mov eax, dword ptr [edx + field_1f24]        # 004c9e5e
    mov ecx, dword ptr [eax + field_1760]        # 004c9e64
    shl ecx, 0x6                                 # 004c9e6a
    mov dx, word ptr [ecx + 0x552bf4]            # 004c9e6d
    mov word ptr [0x63988d], dx                  # 004c9e74
    mov eax, dword ptr [ebp - local_20]          # 004c9e7b
    mov ecx, dword ptr [eax + field_1f24]        # 004c9e7e
    mov edx, dword ptr [ecx + field_1760]        # 004c9e84
    shl edx, 0x6                                 # 004c9e8a
    mov ax, word ptr [edx + 0x552bec]            # 004c9e8d
    mov word ptr [0x639893], ax                  # 004c9e94
    movsx eax, word ptr [0x639893]               # 004c9e9a
    cdq                                          # 004c9ea1
    and edx, 0x7                                 # 004c9ea2
    {load} add eax, edx                          # 004c9ea5
    sar eax, 0x3                                 # 004c9ea7
    mov word ptr [0x639895], ax                  # 004c9eaa
    mov word ptr [0x63988f], 0x0                 # 004c9eb0
    mov word ptr [0x639891], 0x0                 # 004c9eb9
    mov ecx, dword ptr [ebp - local_20]          # 004c9ec2
    mov edx, dword ptr [ecx + field_1f24]        # 004c9ec5
    mov eax, dword ptr [edx + field_175c]        # 004c9ecb
    imul eax, eax, 0x3e4                         # 004c9ed1
    mov ecx, dword ptr [ebp - local_20]          # 004c9ed7
    mov edx, dword ptr [ecx + field_1f24]        # 004c9eda
    mov ecx, dword ptr [ebp - local_20]          # 004c9ee0
    mov edx, dword ptr [edx + eax + field_300]   # 004c9ee3
    mov dword ptr [ecx + field_c4a], edx         # 004c9eea
    mov eax, dword ptr [ebp - local_20]          # 004c9ef0
    mov ecx, dword ptr [eax + field_1f24]        # 004c9ef3
    mov edx, dword ptr [ecx + field_175c]        # 004c9ef9
    imul edx, edx, 0x3e4                         # 004c9eff
    mov eax, dword ptr [ebp - local_20]          # 004c9f05
    mov ecx, dword ptr [eax + field_1f24]        # 004c9f08
    mov eax, dword ptr [ebp - local_20]          # 004c9f0e
    mov ecx, dword ptr [ecx + edx + field_304]   # 004c9f11
    mov dword ptr [eax + field_c4e], ecx         # 004c9f18
    movsx edx, word ptr [0x63a4cd]               # 004c9f1e
    test edx, edx                                # 004c9f25
    je.d8 L_004c9f52                             # 004c9f27
    # block 0x004c9f29: entered by fall-through of je at 0x004c9f27, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c9f52
    push 0x557cec                                # 004c9f29
    push 0x557cf4                                # 004c9f2e
    push 0x557cfc                                # 004c9f33
    push 0x63888b                                # 004c9f38
    call FUN_0050ca3e                            # 004c9f3d
    add esp, 0x10                                # 004c9f42
    push 0x63888b                                # 004c9f45
    call FUN_0044a2b7                            # 004c9f4a
    add esp, 0x4                                 # 004c9f4f
L_004c9f52:
    # block 0x004c9f52: entered by je at 0x004c9f27, 2 instruction(s), ends with forward jump to 0x004ca5b0
    mov eax, 0x1                                 # 004c9f52
    jmp.d32 L_004ca5b0                           # 004c9f57
L_004c9f5c:
    # block 0x004c9f5c: entered by jne at 0x004c9e0c; je at 0x004c9e1c, 11 instruction(s), calls FUN_004fcec4, ends with jge to 0x004c9f9d (forward)
    push 0x3                                     # 004c9f5c
    mov eax, dword ptr [ebp - local_20]          # 004c9f5e
    mov ecx, dword ptr [eax + field_1f24]        # 004c9f61
    push ecx                                     # 004c9f67
    push 0x4ca5b6                                # 004c9f68
    call FUN_004fcec4                            # 004c9f6d
    mov edx, dword ptr [ebp - local_20]          # 004c9f72
    mov dword ptr [edx + field_e82], eax         # 004c9f75
    mov eax, dword ptr [ebp - local_20]          # 004c9f7b
    cmp dword ptr [eax + field_e82], 0x0         # 004c9f7e
    jge.d8 L_004c9f9d                            # 004c9f85
    # block 0x004c9f87: entered by fall-through of jge at 0x004c9f85, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ca5b0
    push 0x557d58                                # 004c9f87
    mov ecx, 0x583979                            # 004c9f8c
    call FUN_004264e8                            # 004c9f91
    {load} xor eax, eax                          # 004c9f96
    jmp.d32 L_004ca5b0                           # 004c9f98
L_004c9f9d:
    # block 0x004c9f9d: entered by jge at 0x004c9f85, 4 instruction(s), ends with jne to 0x004c9fc5 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004c9f9d
    mov edx, dword ptr [ecx + field_1f24]        # 004c9fa0
    cmp dword ptr [edx + field_1758], 0x0        # 004c9fa6
    jne.d8 L_004c9fc5                            # 004c9fad
    # block 0x004c9faf: entered by fall-through of jne at 0x004c9fad, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ca5b0
    push 0x557ddc                                # 004c9faf
    mov ecx, 0x583979                            # 004c9fb4
    call FUN_004264e8                            # 004c9fb9
    {load} xor eax, eax                          # 004c9fbe
    jmp.d32 L_004ca5b0                           # 004c9fc0
L_004c9fc5:
    # block 0x004c9fc5: entered by jne at 0x004c9fad, 3 instruction(s), ends with je to 0x004ca1ff (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c9fc5
    test eax, eax                                # 004c9fcc
    je.d32 L_004ca1ff                            # 004c9fce
    # block 0x004c9fd4: entered by fall-through of je at 0x004c9fce, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with forward jump to 0x004ca015
    mov ecx, dword ptr [ebp - local_20]          # 004c9fd4
    mov edx, dword ptr [ecx + field_1f24]        # 004c9fd7
    mov eax, dword ptr [edx + field_1758]        # 004c9fdd
    push eax                                     # 004c9fe3
    push 0x557e60                                # 004c9fe4
    push 0x63888b                                # 004c9fe9
    call FUN_0050ca3e                            # 004c9fee
    add esp, 0xc                                 # 004c9ff3
    push 0x63888b                                # 004c9ff6
    call FUN_0044a2b7                            # 004c9ffb
    add esp, 0x4                                 # 004ca000
    mov dword ptr [ebp - local_8], 0x0           # 004ca003
    jmp.d8 L_004ca015                            # 004ca00a
L_004ca00c:
    # block 0x004ca00c: entered by jmp at 0x004ca1fa, 3 instruction(s), falls into the block at 0x004ca015
    mov ecx, dword ptr [ebp - local_8]           # 004ca00c
    add ecx, 0x1                                 # 004ca00f
    mov dword ptr [ebp - local_8], ecx           # 004ca012
L_004ca015:
    # block 0x004ca015: entered by jmp at 0x004ca00a, 5 instruction(s), ends with jge to 0x004ca1ff (forward)
    mov edx, dword ptr [ebp - local_20]          # 004ca015
    mov eax, dword ptr [edx + field_1f24]        # 004ca018
    mov ecx, dword ptr [ebp - local_8]           # 004ca01e
    cmp ecx, dword ptr [eax + field_1758]        # 004ca021
    jge.d32 L_004ca1ff                           # 004ca027
    # block 0x004ca02d: entered by fall-through of jge at 0x004ca027, 110 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_004ca92e, ends with backward jump to 0x004ca00c
    mov edx, dword ptr [ebp - local_8]           # 004ca02d
    push edx                                     # 004ca030
    push 0x557e9c                                # 004ca031
    push 0x63888b                                # 004ca036
    call FUN_0050ca3e                            # 004ca03b
    add esp, 0xc                                 # 004ca040
    push 0x63888b                                # 004ca043
    call FUN_0044a2b7                            # 004ca048
    add esp, 0x4                                 # 004ca04d
    mov eax, dword ptr [ebp - local_8]           # 004ca050
    imul eax, eax, 0x3e4                         # 004ca053
    mov ecx, dword ptr [ebp - local_20]          # 004ca059
    mov edx, dword ptr [ecx + field_1f24]        # 004ca05c
    mov eax, dword ptr [edx + eax]               # 004ca062
    push eax                                     # 004ca065
    push 0x557eb4                                # 004ca066
    push 0x63888b                                # 004ca06b
    call FUN_0050ca3e                            # 004ca070
    add esp, 0xc                                 # 004ca075
    push 0x63888b                                # 004ca078
    call FUN_0044a2b7                            # 004ca07d
    add esp, 0x4                                 # 004ca082
    mov ecx, dword ptr [ebp - local_8]           # 004ca085
    imul ecx, ecx, 0x3e4                         # 004ca088
    mov edx, dword ptr [ebp - local_20]          # 004ca08e
    mov eax, dword ptr [edx + field_1f24]        # 004ca091
    mov ecx, dword ptr [eax + ecx + field_4]     # 004ca097
    push ecx                                     # 004ca09b
    push 0x557ed4                                # 004ca09c
    push 0x63888b                                # 004ca0a1
    call FUN_0050ca3e                            # 004ca0a6
    add esp, 0xc                                 # 004ca0ab
    push 0x63888b                                # 004ca0ae
    call FUN_0044a2b7                            # 004ca0b3
    add esp, 0x4                                 # 004ca0b8
    mov edx, dword ptr [ebp - local_8]           # 004ca0bb
    imul edx, edx, 0x3e4                         # 004ca0be
    mov eax, dword ptr [ebp - local_20]          # 004ca0c4
    mov ecx, dword ptr [eax + field_1f24]        # 004ca0c7
    lea edx, [ecx + edx + field_31c]             # 004ca0cd
    push edx                                     # 004ca0d4
    push 0x557ef8                                # 004ca0d5
    push 0x63888b                                # 004ca0da
    call FUN_0050ca3e                            # 004ca0df
    add esp, 0xc                                 # 004ca0e4
    push 0x63888b                                # 004ca0e7
    call FUN_0044a2b7                            # 004ca0ec
    add esp, 0x4                                 # 004ca0f1
    mov eax, dword ptr [ebp - local_8]           # 004ca0f4
    imul eax, eax, 0x3e4                         # 004ca0f7
    mov ecx, dword ptr [ebp - local_20]          # 004ca0fd
    mov edx, dword ptr [ecx + field_1f24]        # 004ca100
    lea eax, [edx + eax + field_380]             # 004ca106
    push eax                                     # 004ca10d
    push 0x557f14                                # 004ca10e
    push 0x63888b                                # 004ca113
    call FUN_0050ca3e                            # 004ca118
    add esp, 0xc                                 # 004ca11d
    push 0x63888b                                # 004ca120
    call FUN_0044a2b7                            # 004ca125
    add esp, 0x4                                 # 004ca12a
    push 0x557f28                                # 004ca12d
    call FUN_0044a2b7                            # 004ca132
    add esp, 0x4                                 # 004ca137
    mov ecx, dword ptr [ebp - local_8]           # 004ca13a
    imul ecx, ecx, 0x3e4                         # 004ca13d
    mov edx, dword ptr [ebp - local_20]          # 004ca143
    mov eax, dword ptr [edx + field_1f24]        # 004ca146
    lea ecx, [eax + ecx + field_8]               # 004ca14c
    push ecx                                     # 004ca150
    mov ecx, dword ptr [ebp - local_20]          # 004ca151
    call FUN_004ca92e                            # 004ca154
    push 0x557f3c                                # 004ca159
    call FUN_0044a2b7                            # 004ca15e
    add esp, 0x4                                 # 004ca163
    mov edx, dword ptr [ebp - local_8]           # 004ca166
    imul edx, edx, 0x3e4                         # 004ca169
    mov eax, dword ptr [ebp - local_20]          # 004ca16f
    mov ecx, dword ptr [eax + field_1f24]        # 004ca172
    lea edx, [ecx + edx + field_184]             # 004ca178
    push edx                                     # 004ca17f
    mov ecx, dword ptr [ebp - local_20]          # 004ca180
    call FUN_004ca92e                            # 004ca183
    mov eax, dword ptr [ebp - local_8]           # 004ca188
    imul eax, eax, 0x3e4                         # 004ca18b
    mov ecx, dword ptr [ebp - local_20]          # 004ca191
    mov edx, dword ptr [ecx + field_1f24]        # 004ca194
    mov eax, dword ptr [edx + eax + field_304]   # 004ca19a
    push eax                                     # 004ca1a1
    push 0x557f50                                # 004ca1a2
    push 0x63888b                                # 004ca1a7
    call FUN_0050ca3e                            # 004ca1ac
    add esp, 0xc                                 # 004ca1b1
    push 0x63888b                                # 004ca1b4
    call FUN_0044a2b7                            # 004ca1b9
    add esp, 0x4                                 # 004ca1be
    mov ecx, dword ptr [ebp - local_8]           # 004ca1c1
    imul ecx, ecx, 0x3e4                         # 004ca1c4
    mov edx, dword ptr [ebp - local_20]          # 004ca1ca
    mov eax, dword ptr [edx + field_1f24]        # 004ca1cd
    mov ecx, dword ptr [eax + ecx + field_300]   # 004ca1d3
    push ecx                                     # 004ca1da
    push 0x557f6c                                # 004ca1db
    push 0x63888b                                # 004ca1e0
    call FUN_0050ca3e                            # 004ca1e5
    add esp, 0xc                                 # 004ca1ea
    push 0x63888b                                # 004ca1ed
    call FUN_0044a2b7                            # 004ca1f2
    add esp, 0x4                                 # 004ca1f7
    jmp.d32 L_004ca00c                           # 004ca1fa
L_004ca1ff:
    # block 0x004ca1ff: entered by je at 0x004c9fce; jge at 0x004ca027, 4 instruction(s), ends with jne to 0x004ca37f (forward)
    mov dword ptr [ebp - local_c], 0x1           # 004ca1ff
    mov edx, dword ptr [ebp - local_20]          # 004ca206
    cmp dword ptr [edx + field_1f30], 0x3        # 004ca209
    jne.d32 L_004ca37f                           # 004ca210
    # block 0x004ca216: entered by fall-through of jne at 0x004ca210, 3 instruction(s), ends with je to 0x004ca37f (forward)
    mov eax, dword ptr [ebp - local_20]          # 004ca216
    cmp dword ptr [eax + field_1f34], 0x0        # 004ca219
    je.d32 L_004ca37f                            # 004ca220
    # block 0x004ca226: entered by fall-through of je at 0x004ca220, 7 instruction(s), ends with jne to 0x004ca37f (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004ca226
    mov edx, dword ptr [ecx + field_1f24]        # 004ca229
    mov eax, dword ptr [ebp - local_20]          # 004ca22f
    mov ecx, dword ptr [eax + field_1f28]        # 004ca232
    mov edx, dword ptr [edx + field_1758]        # 004ca238
    cmp edx, dword ptr [ecx + field_1758]        # 004ca23e
    jne.d32 L_004ca37f                           # 004ca244
    # block 0x004ca24a: entered by fall-through of jne at 0x004ca244, 3 instruction(s), ends with forward jump to 0x004ca263
    mov dword ptr [ebp - local_14], 0x1          # 004ca24a
    mov dword ptr [ebp - local_8], 0x0           # 004ca251
    jmp.d8 L_004ca263                            # 004ca258
L_004ca25a:
    # block 0x004ca25a: entered by jmp at 0x004ca2e7, 3 instruction(s), falls into the block at 0x004ca263
    mov eax, dword ptr [ebp - local_8]           # 004ca25a
    add eax, 0x1                                 # 004ca25d
    mov dword ptr [ebp - local_8], eax           # 004ca260
L_004ca263:
    # block 0x004ca263: entered by jmp at 0x004ca258, 5 instruction(s), ends with jge to 0x004ca2ec (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004ca263
    mov edx, dword ptr [ecx + field_1f24]        # 004ca266
    mov eax, dword ptr [ebp - local_8]           # 004ca26c
    cmp eax, dword ptr [edx + field_1758]        # 004ca26f
    jge.d8 L_004ca2ec                            # 004ca275
    # block 0x004ca277: entered by fall-through of jge at 0x004ca275, 19 instruction(s), ends with je to 0x004ca2cb (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ca277
    imul ecx, ecx, 0x3e4                         # 004ca27a
    mov edx, dword ptr [ebp - local_20]          # 004ca280
    mov eax, dword ptr [edx + field_1f28]        # 004ca283
    lea ecx, [eax + ecx + field_30c]             # 004ca289
    mov dword ptr [ebp - local_1c], ecx          # 004ca290
    mov edx, dword ptr [ebp - local_8]           # 004ca293
    imul edx, edx, 0x3e4                         # 004ca296
    mov eax, dword ptr [ebp - local_20]          # 004ca29c
    mov ecx, dword ptr [eax + field_1f24]        # 004ca29f
    lea edx, [ecx + edx + field_30c]             # 004ca2a5
    mov dword ptr [ebp - local_18], edx          # 004ca2ac
    mov ecx, 0x10                                # 004ca2af
    mov edi, dword ptr [ebp - local_1c]          # 004ca2b4
    mov esi, dword ptr [ebp - local_18]          # 004ca2b7
    {load} xor eax, eax                          # 004ca2ba
    mov dword ptr [ebp - local_24], eax          # 004ca2bc
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ca2bf
    je.d8 L_004ca2cb                             # 004ca2c1
    # block 0x004ca2c3: entered by fall-through of je at 0x004ca2c1, 3 instruction(s), falls into the block at 0x004ca2cb
    {load} sbb ecx, ecx                          # 004ca2c3
    sbb ecx, -0x1                                # 004ca2c5
    mov dword ptr [ebp - local_24], ecx          # 004ca2c8
L_004ca2cb:
    # block 0x004ca2cb: entered by je at 0x004ca2c1, 7 instruction(s), ends with jne to 0x004ca2e7 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004ca2cb
    mov dword ptr [ebp - local_28], edx          # 004ca2ce
    {load} xor eax, eax                          # 004ca2d1
    cmp dword ptr [ebp - local_28], 0x0          # 004ca2d3
    sete al                                      # 004ca2d7
    test eax, eax                                # 004ca2da
    jne.d8 L_004ca2e7                            # 004ca2dc
    # block 0x004ca2de: entered by fall-through of jne at 0x004ca2dc, 2 instruction(s), ends with forward jump to 0x004ca2ec
    mov dword ptr [ebp - local_14], 0x0          # 004ca2de
    jmp.d8 L_004ca2ec                            # 004ca2e5
L_004ca2e7:
    # block 0x004ca2e7: entered by jne at 0x004ca2dc, 1 instruction(s), ends with backward jump to 0x004ca25a
    jmp.d32 L_004ca25a                           # 004ca2e7
L_004ca2ec:
    # block 0x004ca2ec: entered by jge at 0x004ca275; jmp at 0x004ca2e5, 2 instruction(s), ends with je to 0x004ca37f (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 004ca2ec
    je.d32 L_004ca37f                            # 004ca2f0
    # block 0x004ca2f6: entered by fall-through of je at 0x004ca2f0, 12 instruction(s), ends with jl to 0x004ca32c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004ca2f6
    mov edx, dword ptr [ecx + field_1f28]        # 004ca2f9
    mov eax, dword ptr [edx + field_175c]        # 004ca2ff
    mov dword ptr [ebp - local_4], eax           # 004ca305
    mov ecx, dword ptr [ebp - local_4]           # 004ca308
    add ecx, 0x1                                 # 004ca30b
    mov dword ptr [ebp - local_4], ecx           # 004ca30e
    mov edx, dword ptr [ebp - local_20]          # 004ca311
    mov eax, dword ptr [edx + field_1f24]        # 004ca314
    mov ecx, dword ptr [ebp - local_4]           # 004ca31a
    cmp ecx, dword ptr [eax + field_1758]        # 004ca31d
    jl.d8 L_004ca32c                             # 004ca323
    # block 0x004ca325: entered by fall-through of jl at 0x004ca323, 1 instruction(s), falls into the block at 0x004ca32c
    mov dword ptr [ebp - local_4], 0x0           # 004ca325
L_004ca32c:
    # block 0x004ca32c: entered by jl at 0x004ca323, 8 instruction(s), ends with je to 0x004ca37f (forward)
    mov edx, dword ptr [ebp - local_20]          # 004ca32c
    mov eax, dword ptr [edx + field_1f24]        # 004ca32f
    mov ecx, dword ptr [ebp - local_4]           # 004ca335
    mov dword ptr [eax + field_175c], ecx        # 004ca338
    mov dword ptr [ebp - local_c], 0x0           # 004ca33e
    movsx edx, word ptr [0x63a4cd]               # 004ca345
    test edx, edx                                # 004ca34c
    je.d8 L_004ca37f                             # 004ca34e
    # block 0x004ca350: entered by fall-through of je at 0x004ca34e, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca37f
    mov eax, dword ptr [ebp - local_20]          # 004ca350
    mov ecx, dword ptr [eax + field_1f24]        # 004ca353
    mov edx, dword ptr [ecx + field_175c]        # 004ca359
    push edx                                     # 004ca35f
    push 0x557f90                                # 004ca360
    push 0x63888b                                # 004ca365
    call FUN_0050ca3e                            # 004ca36a
    add esp, 0xc                                 # 004ca36f
    push 0x63888b                                # 004ca372
    call FUN_0044a2b7                            # 004ca377
    add esp, 0x4                                 # 004ca37c
L_004ca37f:
    # block 0x004ca37f: entered by jne at 0x004ca210; je at 0x004ca220; jne at 0x004ca244; je at 0x004ca2f0; je at 0x004ca34e, 2 instruction(s), ends with je to 0x004ca3b1 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004ca37f
    je.d8 L_004ca3b1                             # 004ca383
    # block 0x004ca385: entered by fall-through of je at 0x004ca383, 7 instruction(s), calls FUN_004c9cdd, ends with jne to 0x004ca3b1 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004ca385
    mov ecx, dword ptr [eax + field_1f24]        # 004ca388
    push ecx                                     # 004ca38e
    mov ecx, dword ptr [ebp - local_20]          # 004ca38f
    call FUN_004c9cdd                            # 004ca392
    test eax, eax                                # 004ca397
    jne.d8 L_004ca3b1                            # 004ca399
    # block 0x004ca39b: entered by fall-through of jne at 0x004ca399, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ca5b0
    push 0x557fec                                # 004ca39b
    mov ecx, 0x583979                            # 004ca3a0
    call FUN_004264e8                            # 004ca3a5
    {load} xor eax, eax                          # 004ca3aa
    jmp.d32 L_004ca5b0                           # 004ca3ac
L_004ca3b1:
    # block 0x004ca3b1: entered by je at 0x004ca383; jne at 0x004ca399, 4 instruction(s), ends with jne to 0x004ca3d9 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004ca3b1
    mov eax, dword ptr [edx + field_1f24]        # 004ca3b4
    cmp dword ptr [eax + field_175c], -0x1       # 004ca3ba
    jne.d8 L_004ca3d9                            # 004ca3c1
    # block 0x004ca3c3: entered by fall-through of jne at 0x004ca3c1, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ca5b0
    push 0x558058                                # 004ca3c3
    mov ecx, 0x583979                            # 004ca3c8
    call FUN_004264e8                            # 004ca3cd
    {load} xor eax, eax                          # 004ca3d2
    jmp.d32 L_004ca5b0                           # 004ca3d4
L_004ca3d9:
    # block 0x004ca3d9: entered by jne at 0x004ca3c1, 3 instruction(s), ends with je to 0x004ca413 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004ca3d9
    test ecx, ecx                                # 004ca3e0
    je.d8 L_004ca413                             # 004ca3e2
    # block 0x004ca3e4: entered by fall-through of je at 0x004ca3e2, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca413
    mov edx, dword ptr [ebp - local_20]          # 004ca3e4
    mov eax, dword ptr [edx + field_1f24]        # 004ca3e7
    mov ecx, dword ptr [eax + field_175c]        # 004ca3ed
    push ecx                                     # 004ca3f3
    push 0x5580a0                                # 004ca3f4
    push 0x63888b                                # 004ca3f9
    call FUN_0050ca3e                            # 004ca3fe
    add esp, 0xc                                 # 004ca403
    push 0x63888b                                # 004ca406
    call FUN_0044a2b7                            # 004ca40b
    add esp, 0x4                                 # 004ca410
L_004ca413:
    # block 0x004ca413: entered by je at 0x004ca3e2, 12 instruction(s), ends with je to 0x004ca454 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004ca413
    mov eax, dword ptr [edx + field_1f24]        # 004ca416
    mov ecx, dword ptr [eax + field_175c]        # 004ca41c
    imul ecx, ecx, 0x3e4                         # 004ca422
    mov edx, dword ptr [ebp - local_20]          # 004ca428
    mov eax, dword ptr [edx + field_1f24]        # 004ca42b
    mov ecx, dword ptr [eax + ecx]               # 004ca431
    mov dword ptr [ebp - local_10], ecx          # 004ca434
    mov edx, dword ptr [ebp - local_10]          # 004ca437
    and edx, 0x1                                 # 004ca43a
    test edx, edx                                # 004ca43d
    je.d8 L_004ca454                             # 004ca43f
    # block 0x004ca441: entered by fall-through of je at 0x004ca43f, 3 instruction(s), falls into the block at 0x004ca454
    mov eax, dword ptr [ebp - local_20]          # 004ca441
    mov ecx, dword ptr [eax + field_1f24]        # 004ca444
    mov dword ptr [ecx + field_1760], 0x0        # 004ca44a
L_004ca454:
    # block 0x004ca454: entered by je at 0x004ca43f, 4 instruction(s), ends with jne to 0x004ca47c (forward)
    mov edx, dword ptr [ebp - local_20]          # 004ca454
    mov eax, dword ptr [edx + field_1f24]        # 004ca457
    cmp dword ptr [eax + field_1760], -0x1       # 004ca45d
    jne.d8 L_004ca47c                            # 004ca464
    # block 0x004ca466: entered by fall-through of jne at 0x004ca464, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ca5b0
    push 0x5580d8                                # 004ca466
    mov ecx, 0x583979                            # 004ca46b
    call FUN_004264e8                            # 004ca470
    {load} xor eax, eax                          # 004ca475
    jmp.d32 L_004ca5b0                           # 004ca477
L_004ca47c:
    # block 0x004ca47c: entered by jne at 0x004ca464, 3 instruction(s), ends with je to 0x004ca4b6 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004ca47c
    test ecx, ecx                                # 004ca483
    je.d8 L_004ca4b6                             # 004ca485
    # block 0x004ca487: entered by fall-through of je at 0x004ca485, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca4b6
    mov edx, dword ptr [ebp - local_20]          # 004ca487
    mov eax, dword ptr [edx + field_1f24]        # 004ca48a
    mov ecx, dword ptr [eax + field_1760]        # 004ca490
    push ecx                                     # 004ca496
    push 0x558128                                # 004ca497
    push 0x63888b                                # 004ca49c
    call FUN_0050ca3e                            # 004ca4a1
    add esp, 0xc                                 # 004ca4a6
    push 0x63888b                                # 004ca4a9
    call FUN_0044a2b7                            # 004ca4ae
    add esp, 0x4                                 # 004ca4b3
L_004ca4b6:
    # block 0x004ca4b6: entered by je at 0x004ca485, 50 instruction(s), calls FUN_004c9c10, FUN_004c9ca0, falls into the block at 0x004ca5b0
    mov edx, dword ptr [ebp - local_20]          # 004ca4b6
    mov eax, dword ptr [edx + field_1f24]        # 004ca4b9
    mov ecx, dword ptr [eax + field_1760]        # 004ca4bf
    shl ecx, 0x6                                 # 004ca4c5
    mov dx, word ptr [ecx + 0x552bf0]            # 004ca4c8
    mov word ptr [0x63988b], dx                  # 004ca4cf
    mov eax, dword ptr [ebp - local_20]          # 004ca4d6
    mov ecx, dword ptr [eax + field_1f24]        # 004ca4d9
    mov edx, dword ptr [ecx + field_1760]        # 004ca4df
    shl edx, 0x6                                 # 004ca4e5
    mov ax, word ptr [edx + 0x552bf4]            # 004ca4e8
    mov word ptr [0x63988d], ax                  # 004ca4ef
    mov ecx, dword ptr [ebp - local_20]          # 004ca4f5
    mov edx, dword ptr [ecx + field_1f24]        # 004ca4f8
    mov eax, dword ptr [edx + field_1760]        # 004ca4fe
    shl eax, 0x6                                 # 004ca504
    mov cx, word ptr [eax + 0x552bec]            # 004ca507
    mov word ptr [0x639893], cx                  # 004ca50e
    movsx eax, word ptr [0x639893]               # 004ca515
    cdq                                          # 004ca51c
    and edx, 0x7                                 # 004ca51d
    {load} add eax, edx                          # 004ca520
    sar eax, 0x3                                 # 004ca522
    mov word ptr [0x639895], ax                  # 004ca525
    mov word ptr [0x63988f], 0x0                 # 004ca52b
    mov word ptr [0x639891], 0x0                 # 004ca534
    mov edx, dword ptr [ebp - local_20]          # 004ca53d
    mov eax, dword ptr [edx + field_1f24]        # 004ca540
    mov ecx, dword ptr [eax + field_175c]        # 004ca546
    imul ecx, ecx, 0x3e4                         # 004ca54c
    mov edx, dword ptr [ebp - local_20]          # 004ca552
    mov eax, dword ptr [edx + field_1f24]        # 004ca555
    mov edx, dword ptr [ebp - local_20]          # 004ca55b
    mov eax, dword ptr [eax + ecx + field_300]   # 004ca55e
    mov dword ptr [edx + field_c4a], eax         # 004ca565
    mov ecx, dword ptr [ebp - local_20]          # 004ca56b
    mov edx, dword ptr [ecx + field_1f24]        # 004ca56e
    mov eax, dword ptr [edx + field_175c]        # 004ca574
    imul eax, eax, 0x3e4                         # 004ca57a
    mov ecx, dword ptr [ebp - local_20]          # 004ca580
    mov edx, dword ptr [ecx + field_1f24]        # 004ca583
    mov ecx, dword ptr [ebp - local_20]          # 004ca589
    mov edx, dword ptr [edx + eax + field_304]   # 004ca58c
    mov dword ptr [ecx + field_c4e], edx         # 004ca593
    mov ecx, dword ptr [ebp - local_20]          # 004ca599
    call FUN_004c9c10                            # 004ca59c
    push 0x0                                     # 004ca5a1
    mov ecx, dword ptr [ebp - local_20]          # 004ca5a3
    call FUN_004c9ca0                            # 004ca5a6
    mov eax, 0x1                                 # 004ca5ab
L_004ca5b0:
    # block 0x004ca5b0: entered by jmp at 0x004c9f57; jmp at 0x004c9f98; jmp at 0x004c9fc0; jmp at 0x004ca3ac; more, 5 instruction(s), ends with ret
    pop edi                                      # 004ca5b0
    pop esi                                      # 004ca5b1
    {load} mov esp, ebp                          # 004ca5b2
    pop ebp                                      # 004ca5b4
    ret                                          # 004ca5b5

