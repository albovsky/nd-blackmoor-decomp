# FUN_004f7c36
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f7c36
# extent:       0x004f7c36-0x004f7e93 (605 code bytes)
# span:         0x004f7c36-0x004f7e93 (code 605, tables 0, padding 0)
# sha256:       5cc739dc954a9c40c864efa9df9f09fe56a4c733ba935088191f5d8227c5c738
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f7c36
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_258, field_260, field_27c, field_3c2, field_3da, field_3e8, field_3ec, field_3f4; [ecx + n] field_258, field_260, field_280, field_3d6, field_3da, field_3ec, field_3f0; [edx + n] field_25c, field_284, field_3e8, field_3f0, field_3f4
# callees:      calls FUN_004f709c, FUN_004f88de, FUN_004f875f, FUN_004ccb50, FUN_004ccc81, FUN_004f8a17, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_8, 0x8  # offset +0x8
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_27c, 0x27c  # offset +0x27c
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3d6, 0x3d6  # offset +0x3d6
.equ field_3da, 0x3da  # offset +0x3da
.equ field_3e8, 0x3e8  # offset +0x3e8
.equ field_3ec, 0x3ec  # offset +0x3ec
.equ field_3f0, 0x3f0  # offset +0x3f0
.equ field_3f4, 0x3f4  # offset +0x3f4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ccb50, .text + (0x004ccb50 - 0x401000)
.set FUN_004ccc81, .text + (0x004ccc81 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f875f, .text + (0x004f875f - 0x401000)
.set FUN_004f88de, .text + (0x004f88de - 0x401000)
.set FUN_004f8a17, .text + (0x004f8a17 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f7c36 - 0x401000
.globl FUN_004f7c36
FUN_004f7c36:
    # block 0x004f7c36: entry, 10 instruction(s), calls FUN_004f709c, ends with jne to 0x004f7c5d (forward)
    push ebp                                     # 004f7c36
    {load} mov ebp, esp                          # 004f7c37
    sub esp, 0x38                                # 004f7c39
    mov dword ptr [ebp - local_c], ecx           # 004f7c3c
    mov eax, dword ptr [ebp - local_c]           # 004f7c3f
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f7c42
    mov ecx, dword ptr [ebp - local_c]           # 004f7c4c
    call FUN_004f709c                            # 004f7c4f
    test eax, eax                                # 004f7c54
    jne.d8 L_004f7c5d                            # 004f7c56
    # block 0x004f7c58: entered by fall-through of jne at 0x004f7c56, 1 instruction(s), ends with forward jump to 0x004f7e8d
    jmp.d32 L_004f7e8d                           # 004f7c58
L_004f7c5d:
    # block 0x004f7c5d: entered by jne at 0x004f7c56, 3 instruction(s), ends with jne to 0x004f7c6e (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f7c5d
    cmp dword ptr [ecx + field_3d6], 0x0         # 004f7c60
    jne.d8 L_004f7c6e                            # 004f7c67
    # block 0x004f7c69: entered by fall-through of jne at 0x004f7c67, 1 instruction(s), ends with forward jump to 0x004f7e8d
    jmp.d32 L_004f7e8d                           # 004f7c69
L_004f7c6e:
    # block 0x004f7c6e: entered by jne at 0x004f7c67, 5 instruction(s), ends with jne to 0x004f7d17 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004f7c6e
    mov eax, dword ptr [ebp - local_c]           # 004f7c72
    movsx ecx, word ptr [eax + field_3da]        # 004f7c75
    {load} cmp edx, ecx                          # 004f7c7c
    jne.d32 L_004f7d17                           # 004f7c7e
    # block 0x004f7c84: entered by fall-through of jne at 0x004f7c7e, 44 instruction(s), calls FUN_004f88de, FUN_004f875f, ends with forward jump to 0x004f7e8d
    mov edx, dword ptr [ebp - local_c]           # 004f7c84
    mov eax, dword ptr [edx + field_284]         # 004f7c87
    push eax                                     # 004f7c8d
    mov ecx, dword ptr [ebp - local_c]           # 004f7c8e
    mov edx, dword ptr [ecx + field_280]         # 004f7c91
    push edx                                     # 004f7c97
    mov eax, dword ptr [ebp - local_c]           # 004f7c98
    mov ecx, dword ptr [eax + field_27c]         # 004f7c9b
    push ecx                                     # 004f7ca1
    mov edx, dword ptr [ebp - local_c]           # 004f7ca2
    fild dword ptr [edx + field_3f0]             # 004f7ca5
    fstp dword ptr [ebp - local_10]              # 004f7cab
    mov eax, dword ptr [ebp - local_10]          # 004f7cae
    push eax                                     # 004f7cb1
    mov ecx, dword ptr [ebp - local_c]           # 004f7cb2
    fild dword ptr [ecx + field_3ec]             # 004f7cb5
    fstp dword ptr [ebp - local_14]              # 004f7cbb
    mov edx, dword ptr [ebp - local_14]          # 004f7cbe
    push edx                                     # 004f7cc1
    mov eax, dword ptr [ebp - local_c]           # 004f7cc2
    fild dword ptr [eax + field_3e8]             # 004f7cc5
    fstp dword ptr [ebp - local_18]              # 004f7ccb
    mov ecx, dword ptr [ebp - local_18]          # 004f7cce
    push ecx                                     # 004f7cd1
    mov ecx, dword ptr [ebp - local_c]           # 004f7cd2
    call FUN_004f88de                            # 004f7cd5
    mov edx, dword ptr [ebp - local_c]           # 004f7cda
    fild dword ptr [edx + field_3f0]             # 004f7cdd
    fstp dword ptr [ebp - local_1c]              # 004f7ce3
    mov eax, dword ptr [ebp - local_1c]          # 004f7ce6
    push eax                                     # 004f7ce9
    mov ecx, dword ptr [ebp - local_c]           # 004f7cea
    fild dword ptr [ecx + field_3ec]             # 004f7ced
    fstp dword ptr [ebp - local_20]              # 004f7cf3
    mov edx, dword ptr [ebp - local_20]          # 004f7cf6
    push edx                                     # 004f7cf9
    mov eax, dword ptr [ebp - local_c]           # 004f7cfa
    fild dword ptr [eax + field_3e8]             # 004f7cfd
    fstp dword ptr [ebp - local_24]              # 004f7d03
    mov ecx, dword ptr [ebp - local_24]          # 004f7d06
    push ecx                                     # 004f7d09
    mov ecx, dword ptr [ebp - local_c]           # 004f7d0a
    call FUN_004f875f                            # 004f7d0d
    jmp.d32 L_004f7e8d                           # 004f7d12
L_004f7d17:
    # block 0x004f7d17: entered by jne at 0x004f7c7e, 5 instruction(s), ends with jle to 0x004f7d63 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004f7d17
    mov eax, dword ptr [ebp - local_c]           # 004f7d1b
    movsx ecx, word ptr [eax + field_3da]        # 004f7d1e
    {load} cmp edx, ecx                          # 004f7d25
    jle.d8 L_004f7d63                            # 004f7d27
    # block 0x004f7d29: entered by fall-through of jle at 0x004f7d27, 15 instruction(s), ends with forward jump to 0x004f7d8c
    movsx edx, word ptr [ebp + arg_8]            # 004f7d29
    mov eax, dword ptr [ebp - local_c]           # 004f7d2d
    movsx ecx, word ptr [eax + field_3da]        # 004f7d30
    {load} sub edx, ecx                          # 004f7d37
    mov word ptr [ebp - local_4], dx             # 004f7d39
    movsx edx, word ptr [ebp - local_4]          # 004f7d3d
    mov eax, dword ptr [ebp - local_c]           # 004f7d41
    movsx ecx, word ptr [eax + field_3f4]        # 004f7d44
    imul edx, ecx                                # 004f7d4b
    mov word ptr [ebp - local_8], dx             # 004f7d4e
    movsx edx, word ptr [ebp - local_8]          # 004f7d52
    mov eax, 0x168                               # 004f7d56
    {load} sub eax, edx                          # 004f7d5b
    mov word ptr [ebp - local_8], ax             # 004f7d5d
    jmp.d8 L_004f7d8c                            # 004f7d61
L_004f7d63:
    # block 0x004f7d63: entered by jle at 0x004f7d27, 10 instruction(s), falls into the block at 0x004f7d8c
    mov ecx, dword ptr [ebp - local_c]           # 004f7d63
    movsx edx, word ptr [ecx + field_3da]        # 004f7d66
    movsx eax, word ptr [ebp + arg_8]            # 004f7d6d
    {load} sub edx, eax                          # 004f7d71
    mov word ptr [ebp - local_4], dx             # 004f7d73
    movsx ecx, word ptr [ebp - local_4]          # 004f7d77
    mov edx, dword ptr [ebp - local_c]           # 004f7d7b
    movsx eax, word ptr [edx + field_3f4]        # 004f7d7e
    imul ecx, eax                                # 004f7d85
    mov word ptr [ebp - local_8], cx             # 004f7d88
L_004f7d8c:
    # block 0x004f7d8c: entered by jmp at 0x004f7d61, 50 instruction(s), calls FUN_004ccb50, FUN_004ccc81, FUN_004f8a17, FUN_004f875f, ends with je to 0x004f7e8d (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004f7d8c
    mov dword ptr [ebp - local_28], ecx          # 004f7d90
    fild dword ptr [ebp - local_28]              # 004f7d93
    fstp dword ptr [ebp - local_2c]              # 004f7d96
    mov edx, dword ptr [ebp - local_2c]          # 004f7d99
    push edx                                     # 004f7d9c
    mov eax, dword ptr [ebp - local_c]           # 004f7d9d
    add eax, 0x3f6                               # 004f7da0
    push eax                                     # 004f7da5
    mov ecx, 0x630a7e                            # 004f7da6
    call FUN_004ccb50                            # 004f7dab
    mov ecx, dword ptr [ebp - local_c]           # 004f7db0
    fild dword ptr [ecx + field_3f0]             # 004f7db3
    fstp dword ptr [ebp - local_30]              # 004f7db9
    mov edx, dword ptr [ebp - local_30]          # 004f7dbc
    push edx                                     # 004f7dbf
    mov eax, dword ptr [ebp - local_c]           # 004f7dc0
    fild dword ptr [eax + field_3ec]             # 004f7dc3
    fstp dword ptr [ebp - local_34]              # 004f7dc9
    mov ecx, dword ptr [ebp - local_34]          # 004f7dcc
    push ecx                                     # 004f7dcf
    mov edx, dword ptr [ebp - local_c]           # 004f7dd0
    fild dword ptr [edx + field_3e8]             # 004f7dd3
    fstp dword ptr [ebp - local_38]              # 004f7dd9
    mov eax, dword ptr [ebp - local_38]          # 004f7ddc
    push eax                                     # 004f7ddf
    mov ecx, dword ptr [ebp - local_c]           # 004f7de0
    add ecx, 0x258                               # 004f7de3
    push ecx                                     # 004f7de9
    mov edx, dword ptr [ebp - local_c]           # 004f7dea
    add edx, 0x3f6                               # 004f7ded
    push edx                                     # 004f7df3
    mov ecx, 0x630a7e                            # 004f7df4
    call FUN_004ccc81                            # 004f7df9
    mov ecx, dword ptr [ebp - local_c]           # 004f7dfe
    call FUN_004f8a17                            # 004f7e01
    mov eax, dword ptr [ebp - local_c]           # 004f7e06
    mov ecx, dword ptr [eax + field_260]         # 004f7e09
    push ecx                                     # 004f7e0f
    mov edx, dword ptr [ebp - local_c]           # 004f7e10
    mov eax, dword ptr [edx + field_25c]         # 004f7e13
    push eax                                     # 004f7e19
    mov ecx, dword ptr [ebp - local_c]           # 004f7e1a
    mov edx, dword ptr [ecx + field_258]         # 004f7e1d
    push edx                                     # 004f7e23
    mov ecx, dword ptr [ebp - local_c]           # 004f7e24
    call FUN_004f875f                            # 004f7e27
    movsx eax, word ptr [0x63a4cd]               # 004f7e2c
    test eax, eax                                # 004f7e33
    je.d8 L_004f7e8d                             # 004f7e35
    # block 0x004f7e37: entered by fall-through of je at 0x004f7e35, 23 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f7e8d
    mov ecx, dword ptr [ebp - local_c]           # 004f7e37
    fld dword ptr [ecx + field_260]              # 004f7e3a
    sub esp, 0x8                                 # 004f7e40
    fstp qword ptr [esp]                         # 004f7e43
    mov edx, dword ptr [ebp - local_c]           # 004f7e46
    fld dword ptr [edx + field_25c]              # 004f7e49
    sub esp, 0x8                                 # 004f7e4f
    fstp qword ptr [esp]                         # 004f7e52
    mov eax, dword ptr [ebp - local_c]           # 004f7e55
    fld dword ptr [eax + field_258]              # 004f7e58
    sub esp, 0x8                                 # 004f7e5e
    fstp qword ptr [esp]                         # 004f7e61
    movsx ecx, word ptr [ebp - local_8]          # 004f7e64
    push ecx                                     # 004f7e68
    movsx edx, word ptr [ebp + arg_8]            # 004f7e69
    push edx                                     # 004f7e6d
    push 0x55ecc4                                # 004f7e6e
    push 0x63888b                                # 004f7e73
    call FUN_0050ca3e                            # 004f7e78
    add esp, 0x28                                # 004f7e7d
    push 0x63888b                                # 004f7e80
    call FUN_0044a2b7                            # 004f7e85
    add esp, 0x4                                 # 004f7e8a
L_004f7e8d:
    # block 0x004f7e8d: entered by jmp at 0x004f7c58; jmp at 0x004f7c69; jmp at 0x004f7d12; je at 0x004f7e35, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f7e8d
    pop ebp                                      # 004f7e8f
    ret 0x4                                      # 004f7e90

