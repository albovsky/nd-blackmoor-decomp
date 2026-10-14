# FUN_004f5b50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f5b50
# extent:       0x004f5b50-0x004f5e35 (741 code bytes)
# span:         0x004f5b50-0x004f5e35 (code 741, tables 0, padding 0)
# sha256:       157262bbb9905bacfac1cabd6964914a7db6690ee32abf7c386175170ece5e1c
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ local_10, 0x10  # [ebp - 0x10]
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_20, 0x20  # [ebp - 0x20]
.equ local_24, 0x24  # [ebp - 0x24]
.equ local_28, 0x28  # [ebp - 0x28]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]
.equ arg_10, 0x10  # [ebp + 0x10]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fdc70, .text + (0x004fdc70 - 0x401000)
.set FUN_004fe2d0, .text + (0x004fe2d0 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f5b50 - 0x401000
.globl FUN_004f5b50
FUN_004f5b50:
    # block 0x004f5b50: <unfilled>
    push ebp                                     # 004f5b50
    {load} mov ebp, esp                          # 004f5b51
    sub esp, 0x28                                # 004f5b53
    mov dword ptr [ebp - local_28], ecx          # 004f5b56
    mov eax, dword ptr [ebp - local_28]          # 004f5b59
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f5b5c
    mov ecx, dword ptr [ebp + arg_8]             # 004f5b66
    imul ecx, ecx, 0x5bb                         # 004f5b69
    mov edx, dword ptr [ebp - local_28]          # 004f5b6f
    mov eax, dword ptr [edx + 0x3ce]             # 004f5b72
    {load} add eax, ecx                          # 004f5b78
    mov dword ptr [ebp - local_c], eax           # 004f5b7a
    mov ecx, dword ptr [ebp - local_c]           # 004f5b7d
    add ecx, 0x18a                               # 004f5b80
    mov dword ptr [ebp - local_4], ecx           # 004f5b86
    mov edx, dword ptr [ebp - local_c]           # 004f5b89
    movsx eax, word ptr [edx + 0x126]            # 004f5b8c
    cmp eax, 0x2                                 # 004f5b93
    jne.d32 L_004f5d32                           # 004f5b96
    # block 0x004f5b9c: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004f5b9c
    imul ecx, ecx, 0x5bb                         # 004f5b9f
    mov edx, dword ptr [ebp - local_28]          # 004f5ba5
    mov eax, dword ptr [edx + 0x3ce]             # 004f5ba8
    lea ecx, [eax + ecx + 0x2f1]                 # 004f5bae
    mov dword ptr [ebp - local_10], ecx          # 004f5bb5
    mov dword ptr [ebp - local_24], 0x0          # 004f5bb8
    mov dword ptr [ebp - local_14], 0x1          # 004f5bbf
    mov dword ptr [ebp - local_1c], 0x0          # 004f5bc6
    mov dword ptr [ebp - local_18], 0x1          # 004f5bcd
    mov dword ptr [ebp - local_20], 0x2          # 004f5bd4
    mov edx, dword ptr [ebp - local_c]           # 004f5bdb
    {load} xor eax, eax                          # 004f5bde
    mov ax, word ptr [edx + 0x2ed]               # 004f5be0
    cmp eax, 0x8                                 # 004f5be7
    jne.d8 L_004f5bfa                            # 004f5bea
    # block 0x004f5bec: <unfilled>
    mov dword ptr [ebp - local_18], 0x0          # 004f5bec
    mov dword ptr [ebp - local_20], 0x1          # 004f5bf3
L_004f5bfa:
    # block 0x004f5bfa: <unfilled>
    movsx ecx, word ptr [0x63a4cd]               # 004f5bfa
    cmp ecx, 0x2                                 # 004f5c01
    jne.d8 L_004f5c29                            # 004f5c04
    # block 0x004f5c06: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004f5c06
    push edx                                     # 004f5c09
    push 0x55e63c                                # 004f5c0a
    push 0x63888b                                # 004f5c0f
    call FUN_0050ca3e                            # 004f5c14
    add esp, 0xc                                 # 004f5c19
    push 0x63888b                                # 004f5c1c
    call FUN_0044a2b7                            # 004f5c21
    add esp, 0x4                                 # 004f5c26
L_004f5c29:
    # block 0x004f5c29: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 004f5c29
    cmp eax, dword ptr [ebp + arg_10]            # 004f5c2c
    jge.d32 L_004f5cf4                           # 004f5c2f
    # block 0x004f5c35: <unfilled>
    cmp dword ptr [ebp - local_14], 0x0          # 004f5c35
    je.d32 L_004f5cf4                            # 004f5c39
    # block 0x004f5c3f: <unfilled>
    lea ecx, [ebp - local_24]                    # 004f5c3f
    push ecx                                     # 004f5c42
    mov edx, dword ptr [ebp - local_18]          # 004f5c43
    push edx                                     # 004f5c46
    mov eax, dword ptr [ebp - local_20]          # 004f5c47
    push eax                                     # 004f5c4a
    push 0x0                                     # 004f5c4b
    mov ecx, dword ptr [ebp + arg_10]            # 004f5c4d
    sub ecx, dword ptr [ebp - local_1c]          # 004f5c50
    push ecx                                     # 004f5c53
    mov edx, dword ptr [ebp + arg_c]             # 004f5c54
    add edx, dword ptr [ebp - local_1c]          # 004f5c57
    push edx                                     # 004f5c5a
    mov eax, dword ptr [ebp - local_10]          # 004f5c5b
    push eax                                     # 004f5c5e
    call FUN_004fe2d0                            # 004f5c5f
    add esp, 0x1c                                # 004f5c64
    mov dword ptr [ebp - local_14], eax          # 004f5c67
    cmp dword ptr [ebp - local_14], 0x0          # 004f5c6a
    jl.d8 L_004f5c76                             # 004f5c6e
    # block 0x004f5c70: <unfilled>
    cmp dword ptr [ebp - local_24], 0x0          # 004f5c70
    je.d8 L_004f5cd0                             # 004f5c74
L_004f5c76:
    # block 0x004f5c76: <unfilled>
    movsx ecx, word ptr [0x63a4cd]               # 004f5c76
    test ecx, ecx                                # 004f5c7d
    je.d8 L_004f5cbb                             # 004f5c7f
    # block 0x004f5c81: <unfilled>
    mov edx, dword ptr [ebp - local_14]          # 004f5c81
    push edx                                     # 004f5c84
    mov eax, dword ptr [ebp + arg_8]             # 004f5c85
    imul eax, eax, 0x5bb                         # 004f5c88
    mov ecx, dword ptr [ebp - local_28]          # 004f5c8e
    mov edx, dword ptr [ecx + 0x3ce]             # 004f5c91
    lea eax, [edx + eax + 0x4]                   # 004f5c97
    push eax                                     # 004f5c9b
    push 0x55e680                                # 004f5c9c
    push 0x63888b                                # 004f5ca1
    call FUN_0050ca3e                            # 004f5ca6
    add esp, 0x10                                # 004f5cab
    push 0x63888b                                # 004f5cae
    call FUN_0044a2b7                            # 004f5cb3
    add esp, 0x4                                 # 004f5cb8
L_004f5cbb:
    # block 0x004f5cbb: <unfilled>
    mov ecx, dword ptr [ebp - local_28]          # 004f5cbb
    mov dword ptr [ecx + 0x3c2], 0x3ec           # 004f5cbe
    or eax, -0x1                                 # 004f5cc8
    jmp.d32 L_004f5e2f                           # 004f5ccb
L_004f5cd0:
    # block 0x004f5cd0: <unfilled>
    cmp dword ptr [ebp - local_14], 0x0          # 004f5cd0
    jne.d8 L_004f5ce6                            # 004f5cd4
    # block 0x004f5cd6: <unfilled>
    push 0x0                                     # 004f5cd6
    push 0x0                                     # 004f5cd8
    mov edx, dword ptr [ebp - local_10]          # 004f5cda
    push edx                                     # 004f5cdd
    call FUN_004fdc70                            # 004f5cde
    add esp, 0xc                                 # 004f5ce3
L_004f5ce6:
    # block 0x004f5ce6: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 004f5ce6
    add eax, dword ptr [ebp - local_14]          # 004f5ce9
    mov dword ptr [ebp - local_1c], eax          # 004f5cec
    jmp.d32 L_004f5c29                           # 004f5cef
L_004f5cf4:
    # block 0x004f5cf4: <unfilled>
    mov ecx, dword ptr [ebp - local_1c]          # 004f5cf4
    mov dword ptr [ebp - local_8], ecx           # 004f5cf7
    movsx edx, word ptr [0x63a4cd]               # 004f5cfa
    cmp edx, 0x2                                 # 004f5d01
    jne.d8 L_004f5d2d                            # 004f5d04
    # block 0x004f5d06: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 004f5d06
    push eax                                     # 004f5d09
    mov ecx, dword ptr [ebp + arg_8]             # 004f5d0a
    push ecx                                     # 004f5d0d
    push 0x55e6c8                                # 004f5d0e
    push 0x63888b                                # 004f5d13
    call FUN_0050ca3e                            # 004f5d18
    add esp, 0x10                                # 004f5d1d
    push 0x63888b                                # 004f5d20
    call FUN_0044a2b7                            # 004f5d25
    add esp, 0x4                                 # 004f5d2a
L_004f5d2d:
    # block 0x004f5d2d: <unfilled>
    jmp.d32 L_004f5e2c                           # 004f5d2d
L_004f5d32:
    # block 0x004f5d32: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004f5d32
    movsx eax, word ptr [edx + 0x126]            # 004f5d35
    cmp eax, 0x1                                 # 004f5d3c
    jne.d32 L_004f5e01                           # 004f5d3f
    # block 0x004f5d45: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 004f5d45
    mov edx, dword ptr [ecx + 0x156]             # 004f5d48
    push edx                                     # 004f5d4e
    mov eax, dword ptr [ebp + arg_10]            # 004f5d4f
    push eax                                     # 004f5d52
    push 0x1                                     # 004f5d53
    mov ecx, dword ptr [ebp + arg_c]             # 004f5d55
    push ecx                                     # 004f5d58
    call FUN_0050cf61                            # 004f5d59
    add esp, 0x10                                # 004f5d5e
    mov dword ptr [ebp - local_8], eax           # 004f5d61
    mov edx, dword ptr [ebp - local_8]           # 004f5d64
    cmp edx, dword ptr [ebp + arg_10]            # 004f5d67
    je.d32 L_004f5dff                            # 004f5d6a
    # block 0x004f5d70: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f5d70
    mov ecx, dword ptr [eax + 0x156]             # 004f5d73
    mov edx, dword ptr [ecx + 0xc]               # 004f5d79
    and edx, 0x20                                # 004f5d7c
    test edx, edx                                # 004f5d7f
    jne.d8 L_004f5d96                            # 004f5d81
    # block 0x004f5d83: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f5d83
    mov ecx, dword ptr [eax + 0x156]             # 004f5d86
    mov edx, dword ptr [ecx + 0xc]               # 004f5d8c
    and edx, 0x10                                # 004f5d8f
    test edx, edx                                # 004f5d92
    jne.d8 L_004f5de9                            # 004f5d94
L_004f5d96:
    # block 0x004f5d96: <unfilled>
    movsx eax, word ptr [0x63a4cd]               # 004f5d96
    test eax, eax                                # 004f5d9d
    je.d8 L_004f5dd7                             # 004f5d9f
    # block 0x004f5da1: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004f5da1
    imul ecx, ecx, 0x5bb                         # 004f5da4
    mov edx, dword ptr [ebp - local_28]          # 004f5daa
    mov eax, dword ptr [edx + 0x3ce]             # 004f5dad
    lea ecx, [eax + ecx + 0x4]                   # 004f5db3
    push ecx                                     # 004f5db7
    push 0x55e718                                # 004f5db8
    push 0x63888b                                # 004f5dbd
    call FUN_0050ca3e                            # 004f5dc2
    add esp, 0xc                                 # 004f5dc7
    push 0x63888b                                # 004f5dca
    call FUN_0044a2b7                            # 004f5dcf
    add esp, 0x4                                 # 004f5dd4
L_004f5dd7:
    # block 0x004f5dd7: <unfilled>
    mov edx, dword ptr [ebp - local_28]          # 004f5dd7
    mov dword ptr [edx + 0x3c2], 0x3ec           # 004f5dda
    or eax, -0x1                                 # 004f5de4
    jmp.d8 L_004f5e2f                            # 004f5de7
L_004f5de9:
    # block 0x004f5de9: <unfilled>
    push 0x0                                     # 004f5de9
    push 0x1e                                    # 004f5deb
    mov eax, dword ptr [ebp - local_c]           # 004f5ded
    mov ecx, dword ptr [eax + 0x156]             # 004f5df0
    push ecx                                     # 004f5df6
    call FUN_0050ce2b                            # 004f5df7
    add esp, 0xc                                 # 004f5dfc
L_004f5dff:
    # block 0x004f5dff: <unfilled>
    jmp.d8 L_004f5e2c                            # 004f5dff
L_004f5e01:
    # block 0x004f5e01: <unfilled>
    movsx edx, word ptr [0x63a4cd]               # 004f5e01
    test edx, edx                                # 004f5e08
    je.d8 L_004f5e1a                             # 004f5e0a
    # block 0x004f5e0c: <unfilled>
    push 0x0                                     # 004f5e0c
    push 0x0                                     # 004f5e0e
    push 0x55e754                                # 004f5e10
    call FUN_0052139c                            # 004f5e15
L_004f5e1a:
    # block 0x004f5e1a: <unfilled>
    mov eax, dword ptr [ebp - local_28]          # 004f5e1a
    mov dword ptr [eax + 0x3c2], 0x3f9           # 004f5e1d
    or eax, -0x1                                 # 004f5e27
    jmp.d8 L_004f5e2f                            # 004f5e2a
L_004f5e2c:
    # block 0x004f5e2c: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004f5e2c
L_004f5e2f:
    # block 0x004f5e2f: <unfilled>
    {load} mov esp, ebp                          # 004f5e2f
    pop ebp                                      # 004f5e31
    ret 0xc                                      # 004f5e32
