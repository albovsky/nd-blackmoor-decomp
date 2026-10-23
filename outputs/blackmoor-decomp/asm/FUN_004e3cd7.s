# FUN_004e3cd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3cd7
# extent:       0x004e3cd7-0x004e3ede (519 code bytes)
# span:         0x004e3cd7-0x004e3ede (code 519, tables 0, padding 0)
# sha256:       036c8b5dc8c259148942cdf91beccc1996176bfa4363d1190a2c7537ea567281
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e3cd7
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_b5, local_b7, local_d8, local_da, local_dc, local_de, local_e0, local_e2, local_e4, local_e6, local_e8, local_ec and 1 more
# fields:       [eax + n] field_c, field_140c, field_4530, field_53c7, field_53d3; [ecx + n] field_4, field_53cb, field_5408, field_65d0; [edx + n] field_8, field_53cf
# callees:      calls FUN_00423259, FUN_00413187
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 121 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_b5, 0xb5  # offset -0xb5
.equ local_b7, 0xb7  # offset -0xb7
.equ local_d8, 0xd8  # offset -0xd8
.equ local_da, 0xda  # offset -0xda
.equ local_dc, 0xdc  # offset -0xdc
.equ local_de, 0xde  # offset -0xde
.equ local_e0, 0xe0  # offset -0xe0
.equ local_e2, 0xe2  # offset -0xe2
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e6, 0xe6  # offset -0xe6
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_140c, 0x140c  # offset +0x140c
.equ field_4530, 0x4530  # offset +0x4530
.equ field_53c7, 0x53c7  # offset +0x53c7
.equ field_53cb, 0x53cb  # offset +0x53cb
.equ field_53cf, 0x53cf  # offset +0x53cf
.equ field_53d3, 0x53d3  # offset +0x53d3
.equ field_5408, 0x5408  # offset +0x5408
.equ field_65d0, 0x65d0  # offset +0x65d0

# --- external targets -----------------------------------------------
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)

.org 0x004e3cd7 - 0x401000
.globl FUN_004e3cd7
FUN_004e3cd7:
    # block 0x004e3cd7: entry, 33 instruction(s), calls FUN_00423259, ends with je to 0x004e3e59 (forward)
    push ebp                                     # 004e3cd7
    {load} mov ebp, esp                          # 004e3cd8
    sub esp, 0xf0                                # 004e3cda
    push esi                                     # 004e3ce0
    push edi                                     # 004e3ce1
    mov dword ptr [ebp - local_f0], ecx          # 004e3ce2
    mov ecx, 0x39                                # 004e3ce8
    {load} xor eax, eax                          # 004e3ced
    lea edi, [ebp - local_e8]                    # 004e3cef
    rep stosd dword ptr es:[edi], eax            # 004e3cf5
    stosw word ptr es:[edi], ax                  # 004e3cf7
    stosb byte ptr es:[edi], al                  # 004e3cf9
    mov word ptr [ebp - local_e8], 0x2           # 004e3cfa
    mov word ptr [ebp - local_e6], 0x2           # 004e3d03
    mov eax, dword ptr [ebp - local_f0]          # 004e3d0c
    mov cx, word ptr [eax + field_140c]          # 004e3d12
    mov word ptr [ebp - local_e4], cx            # 004e3d19
    mov word ptr [ebp - local_e2], 0x0           # 004e3d20
    mov word ptr [ebp - local_e0], 0x0           # 004e3d29
    mov word ptr [ebp - local_de], 0x0           # 004e3d32
    mov edx, dword ptr [ebp + arg_8]             # 004e3d3b
    mov eax, dword ptr [ebp + arg_8]             # 004e3d3e
    mov ecx, dword ptr [edx + field_8]           # 004e3d41
    sub ecx, dword ptr [eax]                     # 004e3d44
    mov word ptr [ebp - local_dc], cx            # 004e3d46
    mov word ptr [ebp - local_da], 0x5dc         # 004e3d4d
    mov edx, dword ptr [ebp + arg_c]             # 004e3d56
    push edx                                     # 004e3d59
    mov ecx, 0x619a6b                            # 004e3d5a
    call FUN_00423259                            # 004e3d5f
    mov dword ptr [ebp - local_ec], eax          # 004e3d64
    cmp dword ptr [ebp - local_ec], 0x0          # 004e3d6a
    je.d32 L_004e3e59                            # 004e3d71
    # block 0x004e3d77: entered by fall-through of je at 0x004e3d71, 8 instruction(s), ends with ja to 0x004e3e59 (forward)
    mov edi, dword ptr [ebp - local_ec]          # 004e3d77
    or ecx, -0x1                                 # 004e3d7d
    {load} xor eax, eax                          # 004e3d80
    repne scasb al, byte ptr es:[edi]            # 004e3d82
    not ecx                                      # 004e3d84
    add ecx, -0x1                                # 004e3d86
    cmp ecx, 0x9c40                              # 004e3d89
    ja.d32 L_004e3e59                            # 004e3d8f
    # block 0x004e3d95: entered by fall-through of ja at 0x004e3d8f, 3 instruction(s), ends with jne to 0x004e3e3b (forward)
    mov eax, dword ptr [ebp - local_f0]          # 004e3d95
    cmp dword ptr [eax + field_4530], 0xc        # 004e3d9b
    jne.d32 L_004e3e3b                           # 004e3da2
    # block 0x004e3da8: entered by fall-through of jne at 0x004e3da2, 37 instruction(s), falls into the block at 0x004e3e3b
    mov ecx, dword ptr [ebp - local_f0]          # 004e3da8
    add ecx, 0x54be                              # 004e3dae
    {load} mov edi, ecx                          # 004e3db4
    lea edx, [ebp - local_d8]                    # 004e3db6
    or ecx, -0x1                                 # 004e3dbc
    {load} xor eax, eax                          # 004e3dbf
    repne scasb al, byte ptr es:[edi]            # 004e3dc1
    not ecx                                      # 004e3dc3
    {load} sub edi, ecx                          # 004e3dc5
    {load} mov esi, edi                          # 004e3dc7
    {load} mov eax, ecx                          # 004e3dc9
    {load} mov edi, edx                          # 004e3dcb
    shr ecx, 0x2                                 # 004e3dcd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3dd0
    {load} mov ecx, eax                          # 004e3dd2
    and ecx, 0x3                                 # 004e3dd4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e3dd7
    mov ecx, dword ptr [ebp - local_f0]          # 004e3dd9
    mov dx, word ptr [ecx + field_5408]          # 004e3ddf
    mov word ptr [ebp - local_b7], dx            # 004e3de6
    movsx ecx, word ptr [ebp - local_b7]         # 004e3ded
    imul ecx, ecx, 0x12                          # 004e3df4
    mov esi, dword ptr [ebp - local_f0]          # 004e3df7
    add esi, 0x540a                              # 004e3dfd
    lea edi, [ebp - local_b5]                    # 004e3e03
    {load} mov eax, ecx                          # 004e3e09
    shr ecx, 0x2                                 # 004e3e0b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3e0e
    {load} mov ecx, eax                          # 004e3e10
    and ecx, 0x3                                 # 004e3e12
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e3e15
    mov ecx, dword ptr [ebp - local_f0]          # 004e3e17
    movsx edx, word ptr [ecx + field_5408]       # 004e3e1d
    imul edx, edx, 0x12c                         # 004e3e24
    mov ax, word ptr [ebp - local_da]            # 004e3e2a
    {load} add ax, dx                            # 004e3e31
    mov word ptr [ebp - local_da], ax            # 004e3e34
L_004e3e3b:
    # block 0x004e3e3b: entered by jne at 0x004e3da2, 9 instruction(s), calls FUN_00413187, ends with forward jump to 0x004e3e73
    push 0x0                                     # 004e3e3b
    push 0x0                                     # 004e3e3d
    mov ecx, dword ptr [ebp - local_ec]          # 004e3e3f
    push ecx                                     # 004e3e45
    lea edx, [ebp - local_e8]                    # 004e3e46
    push edx                                     # 004e3e4c
    mov ecx, 0x619a41                            # 004e3e4d
    call FUN_00413187                            # 004e3e52
    jmp.d8 L_004e3e73                            # 004e3e57
L_004e3e59:
    # block 0x004e3e59: entered by je at 0x004e3d71; ja at 0x004e3d8f, 7 instruction(s), calls FUN_00413187, falls into the block at 0x004e3e73
    push 0x0                                     # 004e3e59
    push 0x0                                     # 004e3e5b
    push 0x63a9ec                                # 004e3e5d
    lea eax, [ebp - local_e8]                    # 004e3e62
    push eax                                     # 004e3e68
    mov ecx, 0x619a41                            # 004e3e69
    call FUN_00413187                            # 004e3e6e
L_004e3e73:
    # block 0x004e3e73: entered by jmp at 0x004e3e57, 24 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - local_f0]          # 004e3e73
    mov dx, word ptr [0x619a5b]                  # 004e3e79
    mov word ptr [ecx + field_65d0], dx          # 004e3e80
    mov eax, dword ptr [ebp - local_f0]          # 004e3e87
    mov dword ptr [eax + field_53c7], 0x0        # 004e3e8d
    mov ecx, dword ptr [ebp - local_f0]          # 004e3e97
    mov dword ptr [ecx + field_53cb], 0x0        # 004e3e9d
    mov edx, dword ptr [ebp + arg_8]             # 004e3ea7
    mov eax, dword ptr [ebp + arg_8]             # 004e3eaa
    mov ecx, dword ptr [edx + field_8]           # 004e3ead
    sub ecx, dword ptr [eax]                     # 004e3eb0
    mov edx, dword ptr [ebp - local_f0]          # 004e3eb2
    mov dword ptr [edx + field_53cf], ecx        # 004e3eb8
    mov eax, dword ptr [ebp + arg_8]             # 004e3ebe
    mov ecx, dword ptr [ebp + arg_8]             # 004e3ec1
    mov edx, dword ptr [eax + field_c]           # 004e3ec4
    sub edx, dword ptr [ecx + field_4]           # 004e3ec7
    mov eax, dword ptr [ebp - local_f0]          # 004e3eca
    mov dword ptr [eax + field_53d3], edx        # 004e3ed0
    pop edi                                      # 004e3ed6
    pop esi                                      # 004e3ed7
    {load} mov esp, ebp                          # 004e3ed8
    pop ebp                                      # 004e3eda
    ret 0x8                                      # 004e3edb

