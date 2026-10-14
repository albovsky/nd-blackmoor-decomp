# FUN_00423da2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423da2
# extent:       0x00423da2-0x00423f57 (437 code bytes)
# span:         0x00423da2-0x00423f57 (code 437, tables 0, padding 0)
# sha256:       10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0042356d, .text + (0x0042356d - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00423da2 - 0x401000
.globl FUN_00423da2
FUN_00423da2:
L_00423da2:
    # block 0x00423da2: <unfilled>
    push ebp                                     # 00423da2
    {load} mov ebp, esp                          # 00423da3
    sub esp, 0x10                                # 00423da5
    mov dword ptr [ebp - local_10], ecx          # 00423da8
    cmp dword ptr [ebp + arg_8], 0x0             # 00423dab
    jne.d8 L_00423db6                            # 00423daf
    # block 0x00423db1: <unfilled>
    jmp.d32 L_00423f51                           # 00423db1
L_00423db6:
    # block 0x00423db6: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 00423db6
    mov ecx, dword ptr [eax + 0x4]               # 00423db9
    mov dword ptr [ebp - local_8], ecx           # 00423dbc
    cmp dword ptr [ebp - local_8], 0x0           # 00423dbf
    jne.d8 L_00423dca                            # 00423dc3
    # block 0x00423dc5: <unfilled>
    jmp.d32 L_00423f51                           # 00423dc5
L_00423dca:
    # block 0x00423dca: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 00423dca
L_00423dd1:
    # block 0x00423dd1: <unfilled>
    cmp dword ptr [ebp - local_c], 0x0           # 00423dd1
    jne.d32 L_00423f1b                           # 00423dd5
    # block 0x00423ddb: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00423ddb
    cmp dword ptr [edx], 0x2                     # 00423dde
    jne.d8 L_00423e43                            # 00423de1
    # block 0x00423de3: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00423de3
    mov dword ptr [eax + 0x4], 0x0               # 00423de6
    mov ecx, dword ptr [ebp - local_8]           # 00423ded
    mov dword ptr [ecx + 0x2c], 0x0              # 00423df0
    movsx edx, word ptr [0x63a4cd]               # 00423df7
    test edx, edx                                # 00423dfe
    je.d8 L_00423e28                             # 00423e00
    # block 0x00423e02: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00423e02
    mov ecx, dword ptr [eax + 0xc]               # 00423e05
    push ecx                                     # 00423e08
    push 0x5448bc                                # 00423e09
    push 0x63888b                                # 00423e0e
    call FUN_0050ca3e                            # 00423e13
    add esp, 0xc                                 # 00423e18
    push 0x63888b                                # 00423e1b
    call FUN_0044a2b7                            # 00423e20
    add esp, 0x4                                 # 00423e25
L_00423e28:
    # block 0x00423e28: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00423e28
    mov eax, dword ptr [edx + 0x38]              # 00423e2b
    mov dword ptr [ebp - local_8], eax           # 00423e2e
    cmp dword ptr [ebp - local_8], 0x0           # 00423e31
    jne.d8 L_00423e3e                            # 00423e35
    # block 0x00423e37: <unfilled>
    mov dword ptr [ebp - local_c], 0x1           # 00423e37
L_00423e3e:
    # block 0x00423e3e: <unfilled>
    jmp.d32 L_00423f16                           # 00423e3e
L_00423e43:
    # block 0x00423e43: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 00423e43
    cmp dword ptr [ecx], 0x1                     # 00423e46
    jne.d32 L_00423f16                           # 00423e49
    # block 0x00423e4f: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00423e4f
    mov dword ptr [edx + 0x4], 0x0               # 00423e52
    mov eax, dword ptr [ebp - local_8]           # 00423e59
    mov ecx, dword ptr [eax + 0x44]              # 00423e5c
    mov dword ptr [ecx], 0x0                     # 00423e5f
    movsx edx, word ptr [0x63a4cd]               # 00423e65
    test edx, edx                                # 00423e6c
    je.d8 L_00423ea0                             # 00423e6e
    # block 0x00423e70: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00423e70
    mov ecx, dword ptr [eax + 0x44]              # 00423e73
    mov edx, dword ptr [ecx + 0x8]               # 00423e76
    push edx                                     # 00423e79
    mov eax, dword ptr [ebp - local_8]           # 00423e7a
    mov ecx, dword ptr [eax + 0xc]               # 00423e7d
    push ecx                                     # 00423e80
    push 0x5448e8                                # 00423e81
    push 0x63888b                                # 00423e86
    call FUN_0050ca3e                            # 00423e8b
    add esp, 0x10                                # 00423e90
    push 0x63888b                                # 00423e93
    call FUN_0044a2b7                            # 00423e98
    add esp, 0x4                                 # 00423e9d
L_00423ea0:
    # block 0x00423ea0: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00423ea0
    push edx                                     # 00423ea3
    mov eax, dword ptr [ebp + arg_8]             # 00423ea4
    push eax                                     # 00423ea7
    mov ecx, dword ptr [ebp - local_10]          # 00423ea8
    call FUN_0042356d                            # 00423eab
    mov ecx, dword ptr [ebp - local_8]           # 00423eb0
    mov edx, dword ptr [ecx + 0x44]              # 00423eb3
    push edx                                     # 00423eb6
    mov ecx, dword ptr [ebp - local_10]          # 00423eb7
    call L_00423da2                              # 00423eba
    mov ecx, dword ptr [ebp - local_10]          # 00423ebf
    call FUN_004235fd                            # 00423ec2
    mov dword ptr [ebp - local_4], eax           # 00423ec7
    cmp dword ptr [ebp - local_4], 0x0           # 00423eca
    je.d8 L_00423f02                             # 00423ece
    # block 0x00423ed0: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 00423ed0
    mov ecx, dword ptr [eax + 0x8]               # 00423ed3
    mov dword ptr [ebp - local_8], ecx           # 00423ed6
    mov edx, dword ptr [ebp - local_4]           # 00423ed9
    mov eax, dword ptr [edx]                     # 00423edc
    mov dword ptr [ebp + arg_8], eax             # 00423ede
    mov ecx, dword ptr [ebp - local_8]           # 00423ee1
    mov edx, dword ptr [ecx + 0x38]              # 00423ee4
    mov dword ptr [ebp - local_8], edx           # 00423ee7
    cmp dword ptr [ebp - local_8], 0x0           # 00423eea
    jne.d8 L_00423ef9                            # 00423eee
    # block 0x00423ef0: <unfilled>
    mov dword ptr [ebp - local_c], 0x1           # 00423ef0
    jmp.d8 L_00423f00                            # 00423ef7
L_00423ef9:
    # block 0x00423ef9: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 00423ef9
L_00423f00:
    # block 0x00423f00: <unfilled>
    jmp.d8 L_00423f16                            # 00423f00
L_00423f02:
    # block 0x00423f02: <unfilled>
    push 0x544924                                # 00423f02
    push 0x63888b                                # 00423f07
    call FUN_0050ca3e                            # 00423f0c
    add esp, 0x8                                 # 00423f11
    jmp.d8 L_00423f4f                            # 00423f14
L_00423f16:
    # block 0x00423f16: <unfilled>
    jmp.d32 L_00423dd1                           # 00423f16
L_00423f1b:
    # block 0x00423f1b: <unfilled>
    jmp.d8 L_00423f51                            # 00423f1b
L_00423f1d:
    # block 0x00423f1d: <unfilled>
    push 0x0                                     # 00423f1d
    push 0x0                                     # 00423f1f
    push 0x63888b                                # 00423f21
    call FUN_0052139c                            # 00423f26
    movsx eax, word ptr [0x63a4cd]               # 00423f2b
    test eax, eax                                # 00423f32
    je.d8 L_00423f43                             # 00423f34
    # block 0x00423f36: <unfilled>
    push 0x63888b                                # 00423f36
    call FUN_0044a2b7                            # 00423f3b
    add esp, 0x4                                 # 00423f40
L_00423f43:
    # block 0x00423f43: <unfilled>
    mov ecx, 0x5cf659                            # 00423f43
    call FUN_004c97b4                            # 00423f48
    jmp.d8 L_00423f51                            # 00423f4d
L_00423f4f:
    # block 0x00423f4f: <unfilled>
    jmp.d8 L_00423f1d                            # 00423f4f
L_00423f51:
    # block 0x00423f51: <unfilled>
    {load} mov esp, ebp                          # 00423f51
    pop ebp                                      # 00423f53
    ret 0x4                                      # 00423f54
