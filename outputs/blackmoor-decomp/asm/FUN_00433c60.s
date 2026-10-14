# FUN_00433c60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433c60
# extent:       0x00433c60-0x00433e63 (515 code bytes)
# span:         0x00433c60-0x00433e63 (code 515, tables 0, padding 0)
# sha256:       1edc11b57e82217f79e36fdb7cd5355260af533d04eaf9b2818d2878b7cde0ca
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_00418e52, .text + (0x00418e52 - 0x401000)
.set FUN_00433eaa, .text + (0x00433eaa - 0x401000)
.set FUN_00434025, .text + (0x00434025 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00433c60 - 0x401000
.globl FUN_00433c60
FUN_00433c60:
    # block 0x00433c60: <unfilled>
    push ebp                                     # 00433c60
    {load} mov ebp, esp                          # 00433c61
    sub esp, 0x8                                 # 00433c63
    push esi                                     # 00433c66
    push edi                                     # 00433c67
    mov dword ptr [ebp - local_8], ecx           # 00433c68
    mov eax, dword ptr [ebp - local_8]           # 00433c6b
    mov dword ptr [eax], 0x52c7b8                # 00433c6e
    mov edi, dword ptr [ebp + arg_8]             # 00433c74
    mov ecx, dword ptr [ebp - local_8]           # 00433c77
    add ecx, 0x1014                              # 00433c7a
    {load} mov edx, ecx                          # 00433c80
    or ecx, -0x1                                 # 00433c82
    {load} xor eax, eax                          # 00433c85
    repne scasb al, byte ptr es:[edi]            # 00433c87
    not ecx                                      # 00433c89
    {load} sub edi, ecx                          # 00433c8b
    {load} mov esi, edi                          # 00433c8d
    {load} mov eax, ecx                          # 00433c8f
    {load} mov edi, edx                          # 00433c91
    shr ecx, 0x2                                 # 00433c93
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00433c96
    {load} mov ecx, eax                          # 00433c98
    and ecx, 0x3                                 # 00433c9a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00433c9d
    mov ecx, dword ptr [ebp - local_8]           # 00433c9f
    mov dword ptr [ecx + 0x1010], 0x0            # 00433ca2
    mov edx, dword ptr [ebp - local_8]           # 00433cac
    mov dword ptr [edx + 0x100c], 0x0            # 00433caf
    mov eax, dword ptr [ebp - local_8]           # 00433cb9
    mov dword ptr [eax + 0x1008], 0x0            # 00433cbc
    mov ecx, dword ptr [ebp - local_8]           # 00433cc6
    mov dword ptr [ecx + 0x1118], 0x0            # 00433cc9
    mov edx, dword ptr [ebp - local_8]           # 00433cd3
    mov dword ptr [edx + 0x111c], 0x0            # 00433cd6
    mov eax, dword ptr [ebp - local_8]           # 00433ce0
    mov dword ptr [eax + 0x1120], 0x0            # 00433ce3
    mov ecx, dword ptr [ebp - local_8]           # 00433ced
    mov dword ptr [ecx + 0x1124], 0x0            # 00433cf0
    mov edx, dword ptr [ebp - local_8]           # 00433cfa
    mov dword ptr [edx + 0x1128], 0x0            # 00433cfd
    mov eax, dword ptr [ebp - local_8]           # 00433d07
    mov dword ptr [eax + 0x112c], 0x0            # 00433d0a
    mov ecx, dword ptr [ebp - local_8]           # 00433d14
    mov byte ptr [ecx + 0x1130], 0x0             # 00433d17
    mov edx, dword ptr [ebp - local_8]           # 00433d1e
    mov byte ptr [edx + 0x1136], 0x0             # 00433d21
    mov eax, dword ptr [ebp - local_8]           # 00433d28
    mov dword ptr [eax + 0x113c], 0x0            # 00433d2b
    mov ecx, dword ptr [ebp - local_8]           # 00433d35
    mov dword ptr [ecx + 0x1140], 0x0            # 00433d38
    mov edx, dword ptr [ebp - local_8]           # 00433d42
    mov dword ptr [edx + 0x5f64], 0x0            # 00433d45
    mov eax, dword ptr [ebp - local_8]           # 00433d4f
    mov dword ptr [eax + 0x5f68], 0x0            # 00433d52
    mov dword ptr [ebp - local_4], 0x0           # 00433d5c
    jmp.d8 L_00433d6e                            # 00433d63
L_00433d65:
    # block 0x00433d65: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 00433d65
    add ecx, 0x1                                 # 00433d68
    mov dword ptr [ebp - local_4], ecx           # 00433d6b
L_00433d6e:
    # block 0x00433d6e: <unfilled>
    cmp dword ptr [ebp - local_4], 0x3e8         # 00433d6e
    jge.d8 L_00433d8a                            # 00433d75
    # block 0x00433d77: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 00433d77
    mov eax, dword ptr [ebp - local_8]           # 00433d7a
    mov dword ptr [eax + 4*edx + 0x4fc4], 0x0    # 00433d7d
    jmp.d8 L_00433d65                            # 00433d88
L_00433d8a:
    # block 0x00433d8a: <unfilled>
    cmp dword ptr [0x5bb1de], 0x0                # 00433d8a
    je.d8 L_00433dc1                             # 00433d91
    # block 0x00433d93: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 00433d93
    add ecx, 0x1124                              # 00433d96
    push ecx                                     # 00433d9c
    mov edx, dword ptr [ebp - local_8]           # 00433d9d
    add edx, 0x1014                              # 00433da0
    push edx                                     # 00433da6
    push 0x545de0                                # 00433da7
    mov ecx, 0x5d2f31                            # 00433dac
    call FUN_00418e52                            # 00433db1
    mov ecx, dword ptr [ebp - local_8]           # 00433db6
    mov dword ptr [ecx + 0x1118], eax            # 00433db9
    jmp.d8 L_00433dec                            # 00433dbf
L_00433dc1:
    # block 0x00433dc1: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00433dc1
    add edx, 0x1124                              # 00433dc4
    push edx                                     # 00433dca
    mov eax, dword ptr [ebp - local_8]           # 00433dcb
    add eax, 0x1014                              # 00433dce
    push eax                                     # 00433dd3
    push 0x545dec                                # 00433dd4
    mov ecx, 0x5d2f31                            # 00433dd9
    call FUN_00418e52                            # 00433dde
    mov ecx, dword ptr [ebp - local_8]           # 00433de3
    mov dword ptr [ecx + 0x1118], eax            # 00433de6
L_00433dec:
    # block 0x00433dec: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00433dec
    cmp dword ptr [edx + 0x1118], 0x0            # 00433def
    je.d8 L_00433e04                             # 00433df6
    # block 0x00433df8: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00433df8
    cmp dword ptr [eax + 0x1124], 0x0            # 00433dfb
    jne.d8 L_00433e48                            # 00433e02
L_00433e04:
    # block 0x00433e04: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 00433e04
    add ecx, 0x1014                              # 00433e07
    push ecx                                     # 00433e0d
    push 0x545df4                                # 00433e0e
    mov edx, dword ptr [ebp - local_8]           # 00433e13
    add edx, 0x8                                 # 00433e16
    push edx                                     # 00433e19
    call FUN_0050ca3e                            # 00433e1a
    add esp, 0xc                                 # 00433e1f
    push 0x0                                     # 00433e22
    push 0x0                                     # 00433e24
    mov eax, dword ptr [ebp - local_8]           # 00433e26
    add eax, 0x8                                 # 00433e29
    push eax                                     # 00433e2c
    call FUN_0052139c                            # 00433e2d
    mov dword ptr [0x63a58a], 0x2                # 00433e32
    mov ecx, 0x5cf659                            # 00433e3c
    call FUN_004c97b4                            # 00433e41
    jmp.d8 L_00433e58                            # 00433e46
L_00433e48:
    # block 0x00433e48: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 00433e48
    call FUN_00433eaa                            # 00433e4b
    mov ecx, dword ptr [ebp - local_8]           # 00433e50
    call FUN_00434025                            # 00433e53
L_00433e58:
    # block 0x00433e58: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00433e58
    pop edi                                      # 00433e5b
    pop esi                                      # 00433e5c
    {load} mov esp, ebp                          # 00433e5d
    pop ebp                                      # 00433e5f
    ret 0x4                                      # 00433e60
