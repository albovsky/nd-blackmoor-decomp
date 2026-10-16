# FUN_00417b04
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00417b04
# extent:       0x00417b04-0x004181c6 (1730 code bytes)
# span:         0x00417b04-0x004181c6 (code 1730, tables 0, padding 0)
# sha256:       010c16644f54c3eb868f712f8d0eb8d44ed6dd8fa844264902153670177bc437
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00417b04
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       17 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 5 more
# fields:       [eax + n] field_1, field_4, field_8, field_c, field_23, field_27, field_2b, field_2d, field_2f, field_31, field_51, field_59 and 4 more; [ecx + n] field_1, field_4, field_8, field_c, field_29, field_49, field_4b, field_4d, field_51, field_59, field_573, field_577 and 1 more; [edx + n] field_4, field_8, field_c, field_23, field_27, field_39, field_51, field_59, field_577, field_57b, field_5c0, field_5c4 and 1 more
# callees:      calls FUN_0050d0bc, FUN_0050ca3e, FUN_0052139c, FUN_0041a19c, FUN_0051dc43, FUN_0050ce2b, FUN_0050cf61, FUN_0041b6e2, FUN_004c7314, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 506 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_31, 0x31  # offset -0x31
.equ local_32, 0x32  # offset -0x32
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_39, 0x39  # offset +0x39
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_573, 0x573  # offset +0x573
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_5c4, 0x5c4  # offset +0x5c4
.equ field_845, 0x845  # offset +0x845

# --- external targets -----------------------------------------------
.set FUN_0041a19c, .text + (0x0041a19c - 0x401000)
.set FUN_0041b6e2, .text + (0x0041b6e2 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00417b04 - 0x401000
.globl FUN_00417b04
FUN_00417b04:
    # block 0x00417b04: entry, 14 instruction(s), calls FUN_0050d0bc, ends with je to 0x00417b5e (forward)
    push ebp                                     # 00417b04
    {load} mov ebp, esp                          # 00417b05
    sub esp, 0x40                                # 00417b07
    push edi                                     # 00417b0a
    mov dword ptr [ebp - local_28], ecx          # 00417b0b
    mov dword ptr [ebp - local_4], 0x0           # 00417b0e
    mov eax, dword ptr [ebp + arg_c]             # 00417b15
    push eax                                     # 00417b18
    call FUN_0050d0bc                            # 00417b19
    add esp, 0x4                                 # 00417b1e
    mov dword ptr [ebp + arg_c], eax             # 00417b21
    mov ecx, dword ptr [ebp + arg_10]            # 00417b24
    cmp dword ptr [ecx], 0x0                     # 00417b27
    je.d8 L_00417b5e                             # 00417b2a
    # block 0x00417b2c: entered by fall-through of je at 0x00417b2a, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x004181bd
    mov edx, dword ptr [ebp + arg_c]             # 00417b2c
    push edx                                     # 00417b2f
    push 0x5424cc                                # 00417b30
    mov eax, dword ptr [ebp - local_28]          # 00417b35
    add eax, 0x31f                               # 00417b38
    push eax                                     # 00417b3d
    call FUN_0050ca3e                            # 00417b3e
    add esp, 0xc                                 # 00417b43
    push 0x0                                     # 00417b46
    push 0x0                                     # 00417b48
    mov ecx, dword ptr [ebp - local_28]          # 00417b4a
    add ecx, 0x31f                               # 00417b4d
    push ecx                                     # 00417b53
    call FUN_0052139c                            # 00417b54
    jmp.d32 L_004181bd                           # 00417b59
L_00417b5e:
    # block 0x00417b5e: entered by je at 0x00417b2a, 31 instruction(s), calls FUN_0041a19c, ends with jne to 0x00417c15 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00417b5e
    imul edx, edx, 0x84d                         # 00417b62
    mov eax, dword ptr [ebp - local_28]          # 00417b68
    lea ecx, [eax + edx + field_57f]             # 00417b6b
    mov edx, dword ptr [ebp - local_28]          # 00417b72
    mov dword ptr [edx + field_57b], ecx         # 00417b75
    movsx eax, word ptr [ebp + arg_8]            # 00417b7b
    imul eax, eax, 0x84d                         # 00417b7f
    mov ecx, dword ptr [ebp - local_28]          # 00417b85
    mov edx, dword ptr [ebp - local_28]          # 00417b88
    mov eax, dword ptr [edx + eax + field_5c0]   # 00417b8b
    mov dword ptr [ecx + field_577], eax         # 00417b92
    movsx ecx, word ptr [ebp + arg_8]            # 00417b98
    imul ecx, ecx, 0x84d                         # 00417b9c
    mov edx, dword ptr [ebp - local_28]          # 00417ba2
    lea eax, [edx + ecx + field_5c4]             # 00417ba5
    mov ecx, dword ptr [ebp - local_28]          # 00417bac
    mov dword ptr [ecx + field_573], eax         # 00417baf
    mov edx, dword ptr [ebp + arg_c]             # 00417bb5
    push edx                                     # 00417bb8
    mov ecx, dword ptr [ebp - local_28]          # 00417bb9
    call FUN_0041a19c                            # 00417bbc
    mov word ptr [ebp - local_8], ax             # 00417bc1
    movsx eax, word ptr [ebp - local_8]          # 00417bc5
    mov ecx, dword ptr [ebp - local_28]          # 00417bc9
    mov edx, dword ptr [ecx + field_573]         # 00417bcc
    mov ax, word ptr [edx + 2*eax]               # 00417bd2
    mov word ptr [ebp - local_c], ax             # 00417bd6
    movsx ecx, word ptr [ebp - local_c]          # 00417bda
    cmp ecx, -0x1                                # 00417bde
    jne.d8 L_00417c15                            # 00417be1
    # block 0x00417be3: entered by fall-through of jne at 0x00417be1, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x004181bb
    mov edx, dword ptr [ebp + arg_c]             # 00417be3
    push edx                                     # 00417be6
    push 0x54253c                                # 00417be7
    mov eax, dword ptr [ebp - local_28]          # 00417bec
    add eax, 0x31f                               # 00417bef
    push eax                                     # 00417bf4
    call FUN_0050ca3e                            # 00417bf5
    add esp, 0xc                                 # 00417bfa
    push 0x0                                     # 00417bfd
    push 0x0                                     # 00417bff
    mov ecx, dword ptr [ebp - local_28]          # 00417c01
    add ecx, 0x31f                               # 00417c04
    push ecx                                     # 00417c0a
    call FUN_0052139c                            # 00417c0b
    jmp.d32 L_004181bb                           # 00417c10
L_00417c15:
    # block 0x00417c15: entered by jne at 0x00417be1; jmp at 0x00417ce6, 3 instruction(s), ends with je to 0x00417ceb (forward)
    mov edx, 0x1                                 # 00417c15
    test edx, edx                                # 00417c1a
    je.d32 L_00417ceb                            # 00417c1c
    # block 0x00417c22: entered by fall-through of je at 0x00417c1c, 8 instruction(s), falls into the block at 0x00417c3d
    mov eax, dword ptr [ebp + arg_c]             # 00417c22
    mov dword ptr [ebp - local_2c], eax          # 00417c25
    movsx ecx, word ptr [ebp - local_c]          # 00417c28
    imul ecx, ecx, 0x5e                          # 00417c2c
    mov edx, dword ptr [ebp - local_28]          # 00417c2f
    mov eax, dword ptr [edx + field_577]         # 00417c32
    {load} add eax, ecx                          # 00417c38
    mov dword ptr [ebp - local_30], eax          # 00417c3a
L_00417c3d:
    # block 0x00417c3d: entered by jne at 0x00417c6f, 6 instruction(s), ends with jne to 0x00417c7a (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00417c3d
    mov dl, byte ptr [ecx]                       # 00417c40
    mov byte ptr [ebp - local_31], dl            # 00417c42
    mov eax, dword ptr [ebp - local_2c]          # 00417c45
    cmp dl, byte ptr [eax]                       # 00417c48
    jne.d8 L_00417c7a                            # 00417c4a
    # block 0x00417c4c: entered by fall-through of jne at 0x00417c4a, 2 instruction(s), ends with je to 0x00417c71 (forward)
    cmp byte ptr [ebp - local_31], 0x0           # 00417c4c
    je.d8 L_00417c71                             # 00417c50
    # block 0x00417c52: entered by fall-through of je at 0x00417c50, 6 instruction(s), ends with jne to 0x00417c7a (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00417c52
    mov dl, byte ptr [ecx + field_1]             # 00417c55
    mov byte ptr [ebp - local_32], dl            # 00417c58
    mov eax, dword ptr [ebp - local_2c]          # 00417c5b
    cmp dl, byte ptr [eax + field_1]             # 00417c5e
    jne.d8 L_00417c7a                            # 00417c61
    # block 0x00417c63: entered by fall-through of jne at 0x00417c61, 4 instruction(s), ends with jne to 0x00417c3d (backward)
    add dword ptr [ebp - local_30], 0x2          # 00417c63
    add dword ptr [ebp - local_2c], 0x2          # 00417c67
    cmp byte ptr [ebp - local_32], 0x0           # 00417c6b
    jne.d8 L_00417c3d                            # 00417c6f
L_00417c71:
    # block 0x00417c71: entered by je at 0x00417c50; fall-through of jne at 0x00417c6f, 2 instruction(s), ends with forward jump to 0x00417c82
    mov dword ptr [ebp - local_38], 0x0          # 00417c71
    jmp.d8 L_00417c82                            # 00417c78
L_00417c7a:
    # block 0x00417c7a: entered by jne at 0x00417c4a; jne at 0x00417c61, 3 instruction(s), falls into the block at 0x00417c82
    {load} sbb ecx, ecx                          # 00417c7a
    sbb ecx, -0x1                                # 00417c7c
    mov dword ptr [ebp - local_38], ecx          # 00417c7f
L_00417c82:
    # block 0x00417c82: entered by jmp at 0x00417c78, 4 instruction(s), ends with je to 0x00417ce4 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00417c82
    mov dword ptr [ebp - local_3c], edx          # 00417c85
    cmp dword ptr [ebp - local_3c], 0x0          # 00417c88
    je.d8 L_00417ce4                             # 00417c8c
    # block 0x00417c8e: entered by fall-through of je at 0x00417c8c, 9 instruction(s), ends with jne to 0x00417ce2 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00417c8e
    imul eax, eax, 0x5e                          # 00417c92
    mov ecx, dword ptr [ebp - local_28]          # 00417c95
    mov edx, dword ptr [ecx + field_577]         # 00417c98
    mov ax, word ptr [edx + eax + field_27]      # 00417c9e
    mov word ptr [ebp - local_c], ax             # 00417ca3
    movsx ecx, word ptr [ebp - local_c]          # 00417ca7
    cmp ecx, -0x1                                # 00417cab
    jne.d8 L_00417ce2                            # 00417cae
    # block 0x00417cb0: entered by fall-through of jne at 0x00417cae, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x004181b9
    mov edx, dword ptr [ebp + arg_c]             # 00417cb0
    push edx                                     # 00417cb3
    push 0x54256c                                # 00417cb4
    mov eax, dword ptr [ebp - local_28]          # 00417cb9
    add eax, 0x31f                               # 00417cbc
    push eax                                     # 00417cc1
    call FUN_0050ca3e                            # 00417cc2
    add esp, 0xc                                 # 00417cc7
    push 0x0                                     # 00417cca
    push 0x0                                     # 00417ccc
    mov ecx, dword ptr [ebp - local_28]          # 00417cce
    add ecx, 0x31f                               # 00417cd1
    push ecx                                     # 00417cd7
    call FUN_0052139c                            # 00417cd8
    jmp.d32 L_004181b9                           # 00417cdd
L_00417ce2:
    # block 0x00417ce2: entered by jne at 0x00417cae, 1 instruction(s), ends with forward jump to 0x00417ce6
    jmp.d8 L_00417ce6                            # 00417ce2
L_00417ce4:
    # block 0x00417ce4: entered by je at 0x00417c8c, 1 instruction(s), ends with forward jump to 0x00417ceb
    jmp.d8 L_00417ceb                            # 00417ce4
L_00417ce6:
    # block 0x00417ce6: entered by jmp at 0x00417ce2, 1 instruction(s), ends with backward jump to 0x00417c15
    jmp.d32 L_00417c15                           # 00417ce6
L_00417ceb:
    # block 0x00417ceb: entered by je at 0x00417c1c; jmp at 0x00417ce4, 66 instruction(s), ends with je to 0x00417de7 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00417ceb
    imul edx, edx, 0x5e                          # 00417cef
    mov eax, dword ptr [ebp - local_28]          # 00417cf2
    mov ecx, dword ptr [eax + field_577]         # 00417cf5
    mov eax, dword ptr [ebp + arg_10]            # 00417cfb
    mov cx, word ptr [ecx + edx + field_49]      # 00417cfe
    mov word ptr [eax + field_2b], cx            # 00417d03
    movsx edx, word ptr [ebp - local_c]          # 00417d07
    imul edx, edx, 0x5e                          # 00417d0b
    mov eax, dword ptr [ebp - local_28]          # 00417d0e
    mov ecx, dword ptr [eax + field_577]         # 00417d11
    mov eax, dword ptr [ebp + arg_10]            # 00417d17
    mov cx, word ptr [ecx + edx + field_4d]      # 00417d1a
    mov word ptr [eax + field_2d], cx            # 00417d1f
    movsx edx, word ptr [ebp - local_c]          # 00417d23
    imul edx, edx, 0x5e                          # 00417d27
    mov eax, dword ptr [ebp - local_28]          # 00417d2a
    mov ecx, dword ptr [eax + field_577]         # 00417d2d
    mov eax, dword ptr [ebp + arg_10]            # 00417d33
    mov cx, word ptr [ecx + edx + field_4b]      # 00417d36
    mov word ptr [eax + field_2f], cx            # 00417d3b
    movsx edx, word ptr [ebp - local_c]          # 00417d3f
    imul edx, edx, 0x5e                          # 00417d43
    mov eax, dword ptr [ebp - local_28]          # 00417d46
    mov ecx, dword ptr [eax + field_577]         # 00417d49
    mov eax, dword ptr [ebp + arg_10]            # 00417d4f
    mov cx, word ptr [ecx + edx + field_4d]      # 00417d52
    mov word ptr [eax + field_31], cx            # 00417d57
    movsx edx, word ptr [ebp - local_c]          # 00417d5b
    imul edx, edx, 0x5e                          # 00417d5f
    mov eax, dword ptr [ebp - local_28]          # 00417d62
    mov ecx, dword ptr [eax + field_577]         # 00417d65
    lea edx, [ecx + edx + field_29]              # 00417d6b
    mov eax, dword ptr [ebp + arg_10]            # 00417d6f
    add eax, 0x35                                # 00417d72
    mov ecx, dword ptr [edx]                     # 00417d75
    mov dword ptr [eax], ecx                     # 00417d77
    mov ecx, dword ptr [edx + field_4]           # 00417d79
    mov dword ptr [eax + field_4], ecx           # 00417d7c
    mov ecx, dword ptr [edx + field_8]           # 00417d7f
    mov dword ptr [eax + field_8], ecx           # 00417d82
    mov edx, dword ptr [edx + field_c]           # 00417d85
    mov dword ptr [eax + field_c], edx           # 00417d88
    movsx eax, word ptr [ebp - local_c]          # 00417d8b
    imul eax, eax, 0x5e                          # 00417d8f
    mov ecx, dword ptr [ebp - local_28]          # 00417d92
    mov edx, dword ptr [ecx + field_577]         # 00417d95
    lea eax, [edx + eax + field_39]              # 00417d9b
    mov ecx, dword ptr [ebp + arg_10]            # 00417d9f
    add ecx, 0x45                                # 00417da2
    mov edx, dword ptr [eax]                     # 00417da5
    mov dword ptr [ecx], edx                     # 00417da7
    mov edx, dword ptr [eax + field_4]           # 00417da9
    mov dword ptr [ecx + field_4], edx           # 00417dac
    mov edx, dword ptr [eax + field_8]           # 00417daf
    mov dword ptr [ecx + field_8], edx           # 00417db2
    mov eax, dword ptr [eax + field_c]           # 00417db5
    mov dword ptr [ecx + field_c], eax           # 00417db8
    movsx ecx, word ptr [ebp - local_c]          # 00417dbb
    imul ecx, ecx, 0x5e                          # 00417dbf
    mov edx, dword ptr [ebp - local_28]          # 00417dc2
    mov eax, dword ptr [edx + field_577]         # 00417dc5
    mov cl, byte ptr [eax + ecx + field_5d]      # 00417dcb
    mov byte ptr [ebp - local_40], cl            # 00417dcf
    cmp byte ptr [ebp - local_40], 0x2           # 00417dd2
    je.d8 L_00417de7                             # 00417dd6
    # block 0x00417dd8: entered by fall-through of je at 0x00417dd6, 2 instruction(s), ends with je to 0x00417fb3 (forward)
    cmp byte ptr [ebp - local_40], 0x3           # 00417dd8
    je.d32 L_00417fb3                            # 00417ddc
    # block 0x00417de2: entered by fall-through of je at 0x00417ddc, 1 instruction(s), ends with forward jump to 0x00418156
    jmp.d32 L_00418156                           # 00417de2
L_00417de7:
    # block 0x00417de7: entered by je at 0x00417dd6, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417e26 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00417de7
    imul edx, edx, 0x5e                          # 00417deb
    mov eax, dword ptr [ebp - local_28]          # 00417dee
    mov ecx, dword ptr [eax + field_577]         # 00417df1
    mov edx, dword ptr [ecx + edx + field_59]    # 00417df7
    push edx                                     # 00417dfb
    call FUN_0051dc43                            # 00417dfc
    add esp, 0x4                                 # 00417e01
    mov dword ptr [ebp - local_10], eax          # 00417e04
    mov eax, dword ptr [ebp - local_10]          # 00417e07
    mov dword ptr [ebp - local_4], eax           # 00417e0a
    cmp dword ptr [ebp - local_4], 0x0           # 00417e0d
    jne.d8 L_00417e26                            # 00417e11
    # block 0x00417e13: entered by fall-through of jne at 0x00417e11, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004181b7
    push 0x0                                     # 00417e13
    push 0x0                                     # 00417e15
    push 0x54259c                                # 00417e17
    call FUN_0052139c                            # 00417e1c
    jmp.d32 L_004181b7                           # 00417e21
L_00417e26:
    # block 0x00417e26: entered by jne at 0x00417e11, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417e67 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00417e26
    imul ecx, ecx, 0x5e                          # 00417e2a
    mov edx, dword ptr [ebp - local_28]          # 00417e2d
    mov eax, dword ptr [edx + field_577]         # 00417e30
    mov ecx, dword ptr [eax + ecx + field_51]    # 00417e36
    push ecx                                     # 00417e3a
    call FUN_0051dc43                            # 00417e3b
    add esp, 0x4                                 # 00417e40
    mov dword ptr [ebp - local_14], eax          # 00417e43
    mov edx, dword ptr [ebp + arg_10]            # 00417e46
    mov eax, dword ptr [ebp - local_14]          # 00417e49
    mov dword ptr [edx], eax                     # 00417e4c
    cmp dword ptr [ebp - local_14], 0x0          # 00417e4e
    jne.d8 L_00417e67                            # 00417e52
    # block 0x00417e54: entered by fall-through of jne at 0x00417e52, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004181b5
    push 0x0                                     # 00417e54
    push 0x0                                     # 00417e56
    push 0x5425d0                                # 00417e58
    call FUN_0052139c                            # 00417e5d
    jmp.d32 L_004181b5                           # 00417e62
L_00417e67:
    # block 0x00417e67: entered by jne at 0x00417e52, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00417f10 (forward)
    push 0x0                                     # 00417e67
    movsx ecx, word ptr [ebp - local_c]          # 00417e69
    imul ecx, ecx, 0x5e                          # 00417e6d
    mov edx, dword ptr [ebp - local_28]          # 00417e70
    mov eax, dword ptr [edx + field_577]         # 00417e73
    mov ecx, dword ptr [eax + ecx + field_23]    # 00417e79
    push ecx                                     # 00417e7d
    mov edx, dword ptr [ebp - local_28]          # 00417e7e
    mov eax, dword ptr [edx + field_57b]         # 00417e81
    mov ecx, dword ptr [eax + field_845]         # 00417e87
    push ecx                                     # 00417e8d
    call FUN_0050ce2b                            # 00417e8e
    add esp, 0xc                                 # 00417e93
    mov edx, dword ptr [ebp - local_28]          # 00417e96
    mov eax, dword ptr [edx + field_57b]         # 00417e99
    mov ecx, dword ptr [eax + field_845]         # 00417e9f
    push ecx                                     # 00417ea5
    push 0x1                                     # 00417ea6
    movsx edx, word ptr [ebp - local_c]          # 00417ea8
    imul edx, edx, 0x5e                          # 00417eac
    mov eax, dword ptr [ebp - local_28]          # 00417eaf
    mov ecx, dword ptr [eax + field_577]         # 00417eb2
    mov edx, dword ptr [ecx + edx + field_59]    # 00417eb8
    push edx                                     # 00417ebc
    mov eax, dword ptr [ebp - local_4]           # 00417ebd
    push eax                                     # 00417ec0
    call FUN_0050cf61                            # 00417ec1
    add esp, 0x10                                # 00417ec6
    cmp eax, 0x1                                 # 00417ec9
    je.d8 L_00417f10                             # 00417ecc
    # block 0x00417ece: entered by fall-through of je at 0x00417ecc, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x004181b3
    movsx ecx, word ptr [ebp - local_c]          # 00417ece
    imul ecx, ecx, 0x5e                          # 00417ed2
    mov edx, dword ptr [ebp - local_28]          # 00417ed5
    mov eax, dword ptr [edx + field_577]         # 00417ed8
    {load} add eax, ecx                          # 00417ede
    push eax                                     # 00417ee0
    push 0x542608                                # 00417ee1
    mov ecx, dword ptr [ebp - local_28]          # 00417ee6
    add ecx, 0x31f                               # 00417ee9
    push ecx                                     # 00417eef
    call FUN_0050ca3e                            # 00417ef0
    add esp, 0xc                                 # 00417ef5
    push 0x0                                     # 00417ef8
    push 0x0                                     # 00417efa
    mov edx, dword ptr [ebp - local_28]          # 00417efc
    add edx, 0x31f                               # 00417eff
    push edx                                     # 00417f05
    call FUN_0052139c                            # 00417f06
    jmp.d32 L_004181b3                           # 00417f0b
L_00417f10:
    # block 0x00417f10: entered by je at 0x00417ecc, 47 instruction(s), calls FUN_0041b6e2, FUN_004c7314, ends with forward jump to 0x004181b1
    movsx eax, word ptr [ebp - local_c]          # 00417f10
    imul eax, eax, 0x5e                          # 00417f14
    mov ecx, dword ptr [ebp - local_28]          # 00417f17
    mov edx, dword ptr [ecx + field_577]         # 00417f1a
    mov eax, dword ptr [edx + eax + field_51]    # 00417f20
    push eax                                     # 00417f24
    movsx ecx, word ptr [ebp - local_c]          # 00417f25
    imul ecx, ecx, 0x5e                          # 00417f29
    mov edx, dword ptr [ebp - local_28]          # 00417f2c
    mov eax, dword ptr [edx + field_577]         # 00417f2f
    mov ecx, dword ptr [eax + ecx + field_59]    # 00417f35
    push ecx                                     # 00417f39
    mov edx, dword ptr [ebp + arg_10]            # 00417f3a
    mov eax, dword ptr [edx]                     # 00417f3d
    push eax                                     # 00417f3f
    mov ecx, dword ptr [ebp - local_4]           # 00417f40
    push ecx                                     # 00417f43
    mov ecx, dword ptr [ebp - local_28]          # 00417f44
    add ecx, 0x51f                               # 00417f47
    call FUN_0041b6e2                            # 00417f4d
    movsx edx, word ptr [ebp - local_c]          # 00417f52
    imul edx, edx, 0x5e                          # 00417f56
    mov eax, dword ptr [ebp - local_28]          # 00417f59
    mov ecx, dword ptr [eax + field_577]         # 00417f5c
    mov edx, dword ptr [ecx + edx + field_51]    # 00417f62
    push edx                                     # 00417f66
    mov eax, dword ptr [ebp + arg_10]            # 00417f67
    mov ecx, dword ptr [eax]                     # 00417f6a
    push ecx                                     # 00417f6c
    mov ecx, 0x5cf659                            # 00417f6d
    call FUN_004c7314                            # 00417f72
    movsx edx, word ptr [ebp - local_c]          # 00417f77
    imul edx, edx, 0x5e                          # 00417f7b
    mov eax, dword ptr [ebp - local_28]          # 00417f7e
    mov ecx, dword ptr [eax + field_577]         # 00417f81
    mov eax, dword ptr [ebp + arg_10]            # 00417f87
    mov ecx, dword ptr [ecx + edx + field_51]    # 00417f8a
    mov dword ptr [eax + field_23], ecx          # 00417f8e
    movsx edx, word ptr [ebp - local_c]          # 00417f91
    imul edx, edx, 0x5e                          # 00417f95
    mov eax, dword ptr [ebp - local_28]          # 00417f98
    mov ecx, dword ptr [eax + field_577]         # 00417f9b
    mov edx, dword ptr [ecx + edx + field_51]    # 00417fa1
    add edx, 0x59                                # 00417fa5
    mov eax, dword ptr [ebp + arg_10]            # 00417fa8
    mov dword ptr [eax + field_27], edx          # 00417fab
    jmp.d32 L_004181b1                           # 00417fae
L_00417fb3:
    # block 0x00417fb3: entered by je at 0x00417ddc, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417ff2 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00417fb3
    imul ecx, ecx, 0x5e                          # 00417fb7
    mov edx, dword ptr [ebp - local_28]          # 00417fba
    mov eax, dword ptr [edx + field_577]         # 00417fbd
    mov ecx, dword ptr [eax + ecx + field_59]    # 00417fc3
    push ecx                                     # 00417fc7
    call FUN_0051dc43                            # 00417fc8
    add esp, 0x4                                 # 00417fcd
    mov dword ptr [ebp - local_18], eax          # 00417fd0
    mov edx, dword ptr [ebp - local_18]          # 00417fd3
    mov dword ptr [ebp - local_4], edx           # 00417fd6
    cmp dword ptr [ebp - local_4], 0x0           # 00417fd9
    jne.d8 L_00417ff2                            # 00417fdd
    # block 0x00417fdf: entered by fall-through of jne at 0x00417fdd, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004181af
    push 0x0                                     # 00417fdf
    push 0x0                                     # 00417fe1
    push 0x54262c                                # 00417fe3
    call FUN_0052139c                            # 00417fe8
    jmp.d32 L_004181af                           # 00417fed
L_00417ff2:
    # block 0x00417ff2: entered by jne at 0x00417fdd, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418033 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00417ff2
    imul eax, eax, 0x5e                          # 00417ff6
    mov ecx, dword ptr [ebp - local_28]          # 00417ff9
    mov edx, dword ptr [ecx + field_577]         # 00417ffc
    mov eax, dword ptr [edx + eax + field_51]    # 00418002
    push eax                                     # 00418006
    call FUN_0051dc43                            # 00418007
    add esp, 0x4                                 # 0041800c
    mov dword ptr [ebp - local_1c], eax          # 0041800f
    mov ecx, dword ptr [ebp + arg_10]            # 00418012
    mov edx, dword ptr [ebp - local_1c]          # 00418015
    mov dword ptr [ecx], edx                     # 00418018
    cmp dword ptr [ebp - local_1c], 0x0          # 0041801a
    jne.d8 L_00418033                            # 0041801e
    # block 0x00418020: entered by fall-through of jne at 0x0041801e, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004181ad
    push 0x0                                     # 00418020
    push 0x0                                     # 00418022
    push 0x542660                                # 00418024
    call FUN_0052139c                            # 00418029
    jmp.d32 L_004181ad                           # 0041802e
L_00418033:
    # block 0x00418033: entered by jne at 0x0041801e, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x004180db (forward)
    push 0x0                                     # 00418033
    movsx eax, word ptr [ebp - local_c]          # 00418035
    imul eax, eax, 0x5e                          # 00418039
    mov ecx, dword ptr [ebp - local_28]          # 0041803c
    mov edx, dword ptr [ecx + field_577]         # 0041803f
    mov eax, dword ptr [edx + eax + field_23]    # 00418045
    push eax                                     # 00418049
    mov ecx, dword ptr [ebp - local_28]          # 0041804a
    mov edx, dword ptr [ecx + field_57b]         # 0041804d
    mov eax, dword ptr [edx + field_845]         # 00418053
    push eax                                     # 00418059
    call FUN_0050ce2b                            # 0041805a
    add esp, 0xc                                 # 0041805f
    mov ecx, dword ptr [ebp - local_28]          # 00418062
    mov edx, dword ptr [ecx + field_57b]         # 00418065
    mov eax, dword ptr [edx + field_845]         # 0041806b
    push eax                                     # 00418071
    push 0x1                                     # 00418072
    movsx ecx, word ptr [ebp - local_c]          # 00418074
    imul ecx, ecx, 0x5e                          # 00418078
    mov edx, dword ptr [ebp - local_28]          # 0041807b
    mov eax, dword ptr [edx + field_577]         # 0041807e
    mov ecx, dword ptr [eax + ecx + field_59]    # 00418084
    push ecx                                     # 00418088
    mov edx, dword ptr [ebp - local_4]           # 00418089
    push edx                                     # 0041808c
    call FUN_0050cf61                            # 0041808d
    add esp, 0x10                                # 00418092
    cmp eax, 0x1                                 # 00418095
    je.d8 L_004180db                             # 00418098
    # block 0x0041809a: entered by fall-through of je at 0x00418098, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x004181ab
    movsx eax, word ptr [ebp - local_c]          # 0041809a
    imul eax, eax, 0x5e                          # 0041809e
    mov ecx, dword ptr [ebp - local_28]          # 004180a1
    mov edx, dword ptr [ecx + field_577]         # 004180a4
    {load} add edx, eax                          # 004180aa
    push edx                                     # 004180ac
    push 0x542698                                # 004180ad
    mov eax, dword ptr [ebp - local_28]          # 004180b2
    add eax, 0x31f                               # 004180b5
    push eax                                     # 004180ba
    call FUN_0050ca3e                            # 004180bb
    add esp, 0xc                                 # 004180c0
    push 0x0                                     # 004180c3
    push 0x0                                     # 004180c5
    mov ecx, dword ptr [ebp - local_28]          # 004180c7
    add ecx, 0x31f                               # 004180ca
    push ecx                                     # 004180d0
    call FUN_0052139c                            # 004180d1
    jmp.d32 L_004181ab                           # 004180d6
L_004180db:
    # block 0x004180db: entered by je at 0x00418098, 36 instruction(s), calls FUN_0041b6e2, ends with forward jump to 0x004181a9
    movsx edx, word ptr [ebp - local_c]          # 004180db
    imul edx, edx, 0x5e                          # 004180df
    mov eax, dword ptr [ebp - local_28]          # 004180e2
    mov ecx, dword ptr [eax + field_577]         # 004180e5
    mov edx, dword ptr [ecx + edx + field_51]    # 004180eb
    push edx                                     # 004180ef
    movsx eax, word ptr [ebp - local_c]          # 004180f0
    imul eax, eax, 0x5e                          # 004180f4
    mov ecx, dword ptr [ebp - local_28]          # 004180f7
    mov edx, dword ptr [ecx + field_577]         # 004180fa
    mov eax, dword ptr [edx + eax + field_59]    # 00418100
    push eax                                     # 00418104
    mov ecx, dword ptr [ebp + arg_10]            # 00418105
    mov edx, dword ptr [ecx]                     # 00418108
    push edx                                     # 0041810a
    mov eax, dword ptr [ebp - local_4]           # 0041810b
    push eax                                     # 0041810e
    mov ecx, dword ptr [ebp - local_28]          # 0041810f
    add ecx, 0x51f                               # 00418112
    call FUN_0041b6e2                            # 00418118
    movsx ecx, word ptr [ebp - local_c]          # 0041811d
    imul ecx, ecx, 0x5e                          # 00418121
    mov edx, dword ptr [ebp - local_28]          # 00418124
    mov eax, dword ptr [edx + field_577]         # 00418127
    mov edx, dword ptr [ebp + arg_10]            # 0041812d
    mov eax, dword ptr [eax + ecx + field_51]    # 00418130
    mov dword ptr [edx + field_23], eax          # 00418134
    movsx ecx, word ptr [ebp - local_c]          # 00418137
    imul ecx, ecx, 0x5e                          # 0041813b
    mov edx, dword ptr [ebp - local_28]          # 0041813e
    mov eax, dword ptr [edx + field_577]         # 00418141
    mov ecx, dword ptr [eax + ecx + field_51]    # 00418147
    add ecx, 0x59                                # 0041814b
    mov edx, dword ptr [ebp + arg_10]            # 0041814e
    mov dword ptr [edx + field_27], ecx          # 00418151
    jmp.d8 L_004181a9                            # 00418154
L_00418156:
    # block 0x00418156: entered by jmp at 0x00417de2; jmp at 0x004181ab; jmp at 0x004181ad; jmp at 0x004181af; more, 3 instruction(s), ends with je to 0x0041817b (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00418156
    cmp dword ptr [eax], 0x0                     # 00418159
    je.d8 L_0041817b                             # 0041815c
    # block 0x0041815e: entered by fall-through of je at 0x0041815c, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041817b
    mov ecx, dword ptr [ebp + arg_10]            # 0041815e
    mov edx, dword ptr [ecx]                     # 00418161
    mov dword ptr [ebp - local_20], edx          # 00418163
    mov eax, dword ptr [ebp - local_20]          # 00418166
    push eax                                     # 00418169
    call FUN_0051dc6c                            # 0041816a
    add esp, 0x4                                 # 0041816f
    mov ecx, dword ptr [ebp + arg_10]            # 00418172
    mov dword ptr [ecx], 0x0                     # 00418175
L_0041817b:
    # block 0x0041817b: entered by je at 0x0041815c, 5 instruction(s), falls into the block at 0x00418188
    mov ecx, 0x16                                # 0041817b
    {load} xor eax, eax                          # 00418180
    mov edi, dword ptr [ebp + arg_10]            # 00418182
    rep stosd dword ptr es:[edi], eax            # 00418185
    stosb byte ptr es:[edi], al                  # 00418187
L_00418188:
    # block 0x00418188: entered by jmp at 0x004181a9; jmp at 0x004181b1, 2 instruction(s), ends with je to 0x004181a7 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00418188
    je.d8 L_004181a7                             # 0041818c
    # block 0x0041818e: entered by fall-through of je at 0x0041818c, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004181a7
    mov edx, dword ptr [ebp - local_4]           # 0041818e
    mov dword ptr [ebp - local_24], edx          # 00418191
    mov eax, dword ptr [ebp - local_24]          # 00418194
    push eax                                     # 00418197
    call FUN_0051dc6c                            # 00418198
    add esp, 0x4                                 # 0041819d
    mov dword ptr [ebp - local_4], 0x0           # 004181a0
L_004181a7:
    # block 0x004181a7: entered by je at 0x0041818c, 1 instruction(s), ends with forward jump to 0x004181bf
    jmp.d8 L_004181bf                            # 004181a7
L_004181a9:
    # block 0x004181a9: entered by jmp at 0x00418154, 1 instruction(s), ends with backward jump to 0x00418188
    jmp.d8 L_00418188                            # 004181a9
L_004181ab:
    # block 0x004181ab: entered by jmp at 0x004180d6, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181ab
L_004181ad:
    # block 0x004181ad: entered by jmp at 0x0041802e, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181ad
L_004181af:
    # block 0x004181af: entered by jmp at 0x00417fed, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181af
L_004181b1:
    # block 0x004181b1: entered by jmp at 0x00417fae, 1 instruction(s), ends with backward jump to 0x00418188
    jmp.d8 L_00418188                            # 004181b1
L_004181b3:
    # block 0x004181b3: entered by jmp at 0x00417f0b, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181b3
L_004181b5:
    # block 0x004181b5: entered by jmp at 0x00417e62, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181b5
L_004181b7:
    # block 0x004181b7: entered by jmp at 0x00417e21, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181b7
L_004181b9:
    # block 0x004181b9: entered by jmp at 0x00417cdd, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181b9
L_004181bb:
    # block 0x004181bb: entered by jmp at 0x00417c10, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181bb
L_004181bd:
    # block 0x004181bd: entered by jmp at 0x00417b59, 1 instruction(s), ends with backward jump to 0x00418156
    jmp.d8 L_00418156                            # 004181bd
L_004181bf:
    # block 0x004181bf: entered by jmp at 0x004181a7, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 004181bf
    {load} mov esp, ebp                          # 004181c0
    pop ebp                                      # 004181c2
    ret 0xc                                      # 004181c3

