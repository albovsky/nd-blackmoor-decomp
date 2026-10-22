# FUN_00426d0f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426d0f
# extent:       0x00426d0f-0x004270de (975 code bytes)
# span:         0x00426d0f-0x004270de (code 975, tables 0, padding 0)
# sha256:       73b37428b53dd15a145804cc0ce7944c6621470155baa3d53b10096110428881
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00426d0f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_ca151, field_ca155, field_ca16d; [ecx + n] field_ca155, field_ca159, field_ca15d, field_ca16d; [edi + n] field_minus_1; [edx + n] field_ca149, field_ca14d, field_ca159, field_ca15d, field_ca16d
# callees:      calls FUN_004270de, FUN_00516530, FUN_004271cd, FUN_0050cb1b, FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 243 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_ca149, 0xca149  # offset +0xca149
.equ field_ca14d, 0xca14d  # offset +0xca14d
.equ field_ca151, 0xca151  # offset +0xca151
.equ field_ca155, 0xca155  # offset +0xca155
.equ field_ca159, 0xca159  # offset +0xca159
.equ field_ca15d, 0xca15d  # offset +0xca15d
.equ field_ca16d, 0xca16d  # offset +0xca16d

# --- external targets -----------------------------------------------
.set FUN_004270de, .text + (0x004270de - 0x401000)
.set FUN_004271cd, .text + (0x004271cd - 0x401000)
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x00426d0f - 0x401000
.globl FUN_00426d0f
FUN_00426d0f:
    # block 0x00426d0f: entry, 8 instruction(s), calls FUN_004270de, falls into the block at 0x00426d24
    push ebp                                     # 00426d0f
    {load} mov ebp, esp                          # 00426d10
    sub esp, 0x18                                # 00426d12
    push edi                                     # 00426d15
    mov dword ptr [ebp - local_8], ecx           # 00426d16
    mov ecx, dword ptr [ebp - local_8]           # 00426d19
    call FUN_004270de                            # 00426d1c
    mov dword ptr [ebp - local_4], eax           # 00426d21
L_00426d24:
    # block 0x00426d24: entered by jmp at 0x004270d4, 2 instruction(s), ends with je to 0x004270d9 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00426d24
    je.d32 L_004270d9                            # 00426d28
    # block 0x00426d2e: entered by fall-through of je at 0x00426d28, 8 instruction(s), calls FUN_00516530, ends with jne to 0x00426e26 (forward)
    push 0x545548                                # 00426d2e
    mov eax, dword ptr [ebp - local_8]           # 00426d33
    add eax, 0xca171                             # 00426d36
    push eax                                     # 00426d3b
    call FUN_00516530                            # 00426d3c
    add esp, 0x8                                 # 00426d41
    test eax, eax                                # 00426d44
    jne.d32 L_00426e26                           # 00426d46
    # block 0x00426d4c: entered by fall-through of jne at 0x00426d46, 3 instruction(s), ends with je to 0x00426e26 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426d4c
    cmp dword ptr [ecx + field_ca16d], 0x0       # 00426d4f
    je.d32 L_00426e26                            # 00426d56
    # block 0x00426d5c: entered by fall-through of je at 0x00426d56, 4 instruction(s), calls FUN_004271cd, ends with je to 0x00426e21 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426d5c
    call FUN_004271cd                            # 00426d5f
    test eax, eax                                # 00426d64
    je.d32 L_00426e21                            # 00426d66
    # block 0x00426d6c: entered by fall-through of je at 0x00426d66, 3 instruction(s), ends with jne to 0x00426e21 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00426d6c
    cmp dword ptr [edx + field_ca16d], 0x0       # 00426d6f
    jne.d32 L_00426e21                           # 00426d76
    # block 0x00426d7c: entered by fall-through of jne at 0x00426d76, 16 instruction(s), calls FUN_0050cb1b, ends with je to 0x00426e21 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00426d7c
    add eax, 0xca171                             # 00426d7f
    push eax                                     # 00426d84
    call FUN_0050cb1b                            # 00426d85
    add esp, 0x4                                 # 00426d8a
    mov ecx, dword ptr [ebp - local_8]           # 00426d8d
    mov dword ptr [ecx + field_ca155], eax       # 00426d90
    mov edx, dword ptr [ebp - local_8]           # 00426d96
    mov eax, dword ptr [ebp - local_8]           # 00426d99
    mov ecx, dword ptr [eax + field_ca155]       # 00426d9c
    mov dword ptr [edx + field_ca159], ecx       # 00426da2
    mov edx, dword ptr [ebp - local_8]           # 00426da8
    mov dword ptr [edx + field_ca149], 0x1       # 00426dab
    movsx eax, word ptr [0x63a4cd]               # 00426db5
    test eax, eax                                # 00426dbc
    je.d8 L_00426e21                             # 00426dbe
    # block 0x00426dc0: entered by fall-through of je at 0x00426dbe, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x00426e11 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426dc0
    mov edx, dword ptr [ecx + field_ca155]       # 00426dc3
    push edx                                     # 00426dc9
    push 0x54554c                                # 00426dca
    push 0x63888b                                # 00426dcf
    call FUN_0050ca3e                            # 00426dd4
    add esp, 0xc                                 # 00426dd9
    push 0x63888b                                # 00426ddc
    call FUN_0044a2b7                            # 00426de1
    add esp, 0x4                                 # 00426de6
    mov edi, 0x63888b                            # 00426de9
    or ecx, -0x1                                 # 00426dee
    {load} xor eax, eax                          # 00426df1
    repne scasb al, byte ptr es:[edi]            # 00426df3
    mov ax, word ptr [0x545578]                  # 00426df5
    mov word ptr [edi - field_minus_1], ax       # 00426dfb
    mov ecx, 0x1                                 # 00426dff
    test ecx, ecx                                # 00426e04
    je.d8 L_00426e11                             # 00426e06
    # block 0x00426e08: entered by fall-through of je at 0x00426e06, 2 instruction(s), ends with forward jump to 0x00426e21
    mov dword ptr [ebp - local_c], 0x0           # 00426e08
    jmp.d8 L_00426e21                            # 00426e0f
L_00426e11:
    # block 0x00426e11: entered by je at 0x00426e06, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x00426e21
    push 0x63888b                                # 00426e11
    call FUN_00427a40                            # 00426e16
    add esp, 0x4                                 # 00426e1b
    mov dword ptr [ebp - local_c], eax           # 00426e1e
L_00426e21:
    # block 0x00426e21: entered by je at 0x00426d66; jne at 0x00426d76; je at 0x00426dbe; jmp at 0x00426e0f, 1 instruction(s), ends with forward jump to 0x004270c9
    jmp.d32 L_004270c9                           # 00426e21
L_00426e26:
    # block 0x00426e26: entered by jne at 0x00426d46; je at 0x00426d56, 8 instruction(s), calls FUN_00516530, ends with jne to 0x00426f53 (forward)
    push 0x54557c                                # 00426e26
    mov edx, dword ptr [ebp - local_8]           # 00426e2b
    add edx, 0xca171                             # 00426e2e
    push edx                                     # 00426e34
    call FUN_00516530                            # 00426e35
    add esp, 0x8                                 # 00426e3a
    test eax, eax                                # 00426e3d
    jne.d32 L_00426f53                           # 00426e3f
    # block 0x00426e45: entered by fall-through of jne at 0x00426e3f, 3 instruction(s), ends with je to 0x00426f53 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00426e45
    cmp dword ptr [eax + field_ca16d], 0x0       # 00426e48
    je.d32 L_00426f53                            # 00426e4f
    # block 0x00426e55: entered by fall-through of je at 0x00426e4f, 4 instruction(s), calls FUN_004271cd, ends with je to 0x00426f4e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426e55
    call FUN_004271cd                            # 00426e58
    test eax, eax                                # 00426e5d
    je.d32 L_00426f4e                            # 00426e5f
    # block 0x00426e65: entered by fall-through of je at 0x00426e5f, 3 instruction(s), ends with jne to 0x00426f4e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426e65
    cmp dword ptr [ecx + field_ca16d], 0x0       # 00426e68
    jne.d32 L_00426f4e                           # 00426e6f
    # block 0x00426e75: entered by fall-through of jne at 0x00426e6f, 11 instruction(s), calls FUN_0050cb1b, FUN_004271cd, ends with je to 0x00426f4e (forward)
    mov edx, dword ptr [ebp - local_8]           # 00426e75
    add edx, 0xca171                             # 00426e78
    push edx                                     # 00426e7e
    call FUN_0050cb1b                            # 00426e7f
    add esp, 0x4                                 # 00426e84
    mov ecx, dword ptr [ebp - local_8]           # 00426e87
    mov dword ptr [ecx + field_ca155], eax       # 00426e8a
    mov ecx, dword ptr [ebp - local_8]           # 00426e90
    call FUN_004271cd                            # 00426e93
    test eax, eax                                # 00426e98
    je.d32 L_00426f4e                            # 00426e9a
    # block 0x00426ea0: entered by fall-through of je at 0x00426e9a, 3 instruction(s), ends with jne to 0x00426f4e (forward)
    mov edx, dword ptr [ebp - local_8]           # 00426ea0
    cmp dword ptr [edx + field_ca16d], 0x0       # 00426ea3
    jne.d32 L_00426f4e                           # 00426eaa
    # block 0x00426eb0: entered by fall-through of jne at 0x00426eaa, 12 instruction(s), calls FUN_0050cb1b, ends with je to 0x00426f4e (forward)
    mov eax, dword ptr [ebp - local_8]           # 00426eb0
    add eax, 0xca171                             # 00426eb3
    push eax                                     # 00426eb8
    call FUN_0050cb1b                            # 00426eb9
    add esp, 0x4                                 # 00426ebe
    mov ecx, dword ptr [ebp - local_8]           # 00426ec1
    mov dword ptr [ecx + field_ca159], eax       # 00426ec4
    mov edx, dword ptr [ebp - local_8]           # 00426eca
    mov dword ptr [edx + field_ca14d], 0x1       # 00426ecd
    movsx eax, word ptr [0x63a4cd]               # 00426ed7
    test eax, eax                                # 00426ede
    je.d8 L_00426f4e                             # 00426ee0
    # block 0x00426ee2: entered by fall-through of je at 0x00426ee0, 22 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x00426f3e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00426ee2
    mov edx, dword ptr [ecx + field_ca159]       # 00426ee5
    push edx                                     # 00426eeb
    mov eax, dword ptr [ebp - local_8]           # 00426eec
    mov ecx, dword ptr [eax + field_ca155]       # 00426eef
    push ecx                                     # 00426ef5
    push 0x545580                                # 00426ef6
    push 0x63888b                                # 00426efb
    call FUN_0050ca3e                            # 00426f00
    add esp, 0x10                                # 00426f05
    push 0x63888b                                # 00426f08
    call FUN_0044a2b7                            # 00426f0d
    add esp, 0x4                                 # 00426f12
    mov edi, 0x63888b                            # 00426f15
    or ecx, -0x1                                 # 00426f1a
    {load} xor eax, eax                          # 00426f1d
    repne scasb al, byte ptr es:[edi]            # 00426f1f
    mov dx, word ptr [0x5455bc]                  # 00426f21
    mov word ptr [edi - field_minus_1], dx       # 00426f28
    mov eax, 0x1                                 # 00426f2c
    test eax, eax                                # 00426f31
    je.d8 L_00426f3e                             # 00426f33
    # block 0x00426f35: entered by fall-through of je at 0x00426f33, 2 instruction(s), ends with forward jump to 0x00426f4e
    mov dword ptr [ebp - local_10], 0x0          # 00426f35
    jmp.d8 L_00426f4e                            # 00426f3c
L_00426f3e:
    # block 0x00426f3e: entered by je at 0x00426f33, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x00426f4e
    push 0x63888b                                # 00426f3e
    call FUN_00427a40                            # 00426f43
    add esp, 0x4                                 # 00426f48
    mov dword ptr [ebp - local_10], eax          # 00426f4b
L_00426f4e:
    # block 0x00426f4e: entered by je at 0x00426e5f; jne at 0x00426e6f; je at 0x00426e9a; jne at 0x00426eaa; more, 1 instruction(s), ends with forward jump to 0x004270c9
    jmp.d32 L_004270c9                           # 00426f4e
L_00426f53:
    # block 0x00426f53: entered by jne at 0x00426e3f; je at 0x00426e4f, 8 instruction(s), calls FUN_00516530, ends with jne to 0x00426ff3 (forward)
    push 0x5455c0                                # 00426f53
    mov ecx, dword ptr [ebp - local_8]           # 00426f58
    add ecx, 0xca171                             # 00426f5b
    push ecx                                     # 00426f61
    call FUN_00516530                            # 00426f62
    add esp, 0x8                                 # 00426f67
    test eax, eax                                # 00426f6a
    jne.d32 L_00426ff3                           # 00426f6c
    # block 0x00426f72: entered by fall-through of jne at 0x00426f6c, 3 instruction(s), ends with je to 0x00426ff3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00426f72
    cmp dword ptr [edx + field_ca16d], 0x0       # 00426f75
    je.d8 L_00426ff3                             # 00426f7c
    # block 0x00426f7e: entered by fall-through of je at 0x00426f7c, 5 instruction(s), ends with je to 0x00426fee (forward)
    mov eax, dword ptr [ebp - local_8]           # 00426f7e
    mov dword ptr [eax + field_ca151], 0x1       # 00426f81
    movsx ecx, word ptr [0x63a4cd]               # 00426f8b
    test ecx, ecx                                # 00426f92
    je.d8 L_00426fee                             # 00426f94
    # block 0x00426f96: entered by fall-through of je at 0x00426f94, 16 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x00426fde (forward)
    push 0x5455c4                                # 00426f96
    push 0x63888b                                # 00426f9b
    call FUN_0050ca3e                            # 00426fa0
    add esp, 0x8                                 # 00426fa5
    push 0x63888b                                # 00426fa8
    call FUN_0044a2b7                            # 00426fad
    add esp, 0x4                                 # 00426fb2
    mov edi, 0x63888b                            # 00426fb5
    or ecx, -0x1                                 # 00426fba
    {load} xor eax, eax                          # 00426fbd
    repne scasb al, byte ptr es:[edi]            # 00426fbf
    mov dx, word ptr [0x5455f0]                  # 00426fc1
    mov word ptr [edi - field_minus_1], dx       # 00426fc8
    mov eax, 0x1                                 # 00426fcc
    test eax, eax                                # 00426fd1
    je.d8 L_00426fde                             # 00426fd3
    # block 0x00426fd5: entered by fall-through of je at 0x00426fd3, 2 instruction(s), ends with forward jump to 0x00426fee
    mov dword ptr [ebp - local_14], 0x0          # 00426fd5
    jmp.d8 L_00426fee                            # 00426fdc
L_00426fde:
    # block 0x00426fde: entered by je at 0x00426fd3, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x00426fee
    push 0x63888b                                # 00426fde
    call FUN_00427a40                            # 00426fe3
    add esp, 0x4                                 # 00426fe8
    mov dword ptr [ebp - local_14], eax          # 00426feb
L_00426fee:
    # block 0x00426fee: entered by je at 0x00426f94; jmp at 0x00426fdc, 1 instruction(s), ends with forward jump to 0x004270c9
    jmp.d32 L_004270c9                           # 00426fee
L_00426ff3:
    # block 0x00426ff3: entered by jne at 0x00426f6c; je at 0x00426f7c, 8 instruction(s), calls FUN_00516530, ends with jne to 0x004270c9 (forward)
    push 0x5455f4                                # 00426ff3
    mov ecx, dword ptr [ebp - local_8]           # 00426ff8
    add ecx, 0xca171                             # 00426ffb
    push ecx                                     # 00427001
    call FUN_00516530                            # 00427002
    add esp, 0x8                                 # 00427007
    test eax, eax                                # 0042700a
    jne.d32 L_004270c9                           # 0042700c
    # block 0x00427012: entered by fall-through of jne at 0x0042700c, 3 instruction(s), ends with je to 0x004270c9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00427012
    cmp dword ptr [edx + field_ca16d], 0x0       # 00427015
    je.d32 L_004270c9                            # 0042701c
    # block 0x00427022: entered by fall-through of je at 0x0042701c, 4 instruction(s), calls FUN_004271cd, ends with je to 0x004270c9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00427022
    call FUN_004271cd                            # 00427025
    test eax, eax                                # 0042702a
    je.d32 L_004270c9                            # 0042702c
    # block 0x00427032: entered by fall-through of je at 0x0042702c, 3 instruction(s), ends with jne to 0x004270c9 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00427032
    cmp dword ptr [eax + field_ca16d], 0x0       # 00427035
    jne.d32 L_004270c9                           # 0042703c
    # block 0x00427042: entered by fall-through of jne at 0x0042703c, 10 instruction(s), calls FUN_0050cb1b, ends with je to 0x004270c9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00427042
    add ecx, 0xca171                             # 00427045
    push ecx                                     # 0042704b
    call FUN_0050cb1b                            # 0042704c
    add esp, 0x4                                 # 00427051
    mov edx, dword ptr [ebp - local_8]           # 00427054
    mov dword ptr [edx + field_ca15d], eax       # 00427057
    movsx eax, word ptr [0x63a4cd]               # 0042705d
    test eax, eax                                # 00427064
    je.d8 L_004270c9                             # 00427066
    # block 0x00427068: entered by fall-through of je at 0x00427066, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004270b9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00427068
    mov edx, dword ptr [ecx + field_ca15d]       # 0042706b
    push edx                                     # 00427071
    push 0x5455f8                                # 00427072
    push 0x63888b                                # 00427077
    call FUN_0050ca3e                            # 0042707c
    add esp, 0xc                                 # 00427081
    push 0x63888b                                # 00427084
    call FUN_0044a2b7                            # 00427089
    add esp, 0x4                                 # 0042708e
    mov edi, 0x63888b                            # 00427091
    or ecx, -0x1                                 # 00427096
    {load} xor eax, eax                          # 00427099
    repne scasb al, byte ptr es:[edi]            # 0042709b
    mov ax, word ptr [0x54562c]                  # 0042709d
    mov word ptr [edi - field_minus_1], ax       # 004270a3
    mov ecx, 0x1                                 # 004270a7
    test ecx, ecx                                # 004270ac
    je.d8 L_004270b9                             # 004270ae
    # block 0x004270b0: entered by fall-through of je at 0x004270ae, 2 instruction(s), ends with forward jump to 0x004270c9
    mov dword ptr [ebp - local_18], 0x0          # 004270b0
    jmp.d8 L_004270c9                            # 004270b7
L_004270b9:
    # block 0x004270b9: entered by je at 0x004270ae, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004270c9
    push 0x63888b                                # 004270b9
    call FUN_00427a40                            # 004270be
    add esp, 0x4                                 # 004270c3
    mov dword ptr [ebp - local_18], eax          # 004270c6
L_004270c9:
    # block 0x004270c9: entered by jmp at 0x00426e21; jmp at 0x00426f4e; jmp at 0x00426fee; jne at 0x0042700c; more, 4 instruction(s), calls FUN_004271cd, ends with backward jump to 0x00426d24
    mov ecx, dword ptr [ebp - local_8]           # 004270c9
    call FUN_004271cd                            # 004270cc
    mov dword ptr [ebp - local_4], eax           # 004270d1
    jmp.d32 L_00426d24                           # 004270d4
L_004270d9:
    # block 0x004270d9: entered by je at 0x00426d28, 4 instruction(s), ends with ret
    pop edi                                      # 004270d9
    {load} mov esp, ebp                          # 004270da
    pop ebp                                      # 004270dc
    ret                                          # 004270dd

