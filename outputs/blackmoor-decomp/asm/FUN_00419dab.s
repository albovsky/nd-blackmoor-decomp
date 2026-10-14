# FUN_00419dab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00419dab
# extent:       0x00419dab-0x0041a102 (855 code bytes)
# span:         0x00419dab-0x0041a102 (code 855, tables 0, padding 0)
# sha256:       744f3f364fa132f0bd49276edfc20e369bae15fe827ed9ee8f3156e0fc00e108
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
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
.equ local_64, 0x64  # [ebp - 0x64]
.equ local_68, 0x68  # [ebp - 0x68]
.equ local_6c, 0x6c  # [ebp - 0x6c]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0041a2e9, .text + (0x0041a2e9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0050d1f0, .text + (0x0050d1f0 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00419dab - 0x401000
.globl FUN_00419dab
FUN_00419dab:
    # block 0x00419dab: <unfilled>
    push ebp                                     # 00419dab
    {load} mov ebp, esp                          # 00419dac
    sub esp, 0x6c                                # 00419dae
    push esi                                     # 00419db1
    push edi                                     # 00419db2
    mov dword ptr [ebp - local_6c], ecx          # 00419db3
    mov ecx, dword ptr [ebp - local_6c]          # 00419db6
    call FUN_0041a2e9                            # 00419db9
    mov ecx, dword ptr [ebp - local_6c]          # 00419dbe
    mov word ptr [ecx + 0x571], ax               # 00419dc1
    mov edx, dword ptr [ebp - local_6c]          # 00419dc8
    movsx eax, word ptr [edx + 0x571]            # 00419dcb
    cmp eax, -0x1                                # 00419dd2
    jne.d8 L_00419dfc                            # 00419dd5
    # block 0x00419dd7: <unfilled>
    push 0x542f30                                # 00419dd7
    push 0x63888b                                # 00419ddc
    call FUN_0050ca3e                            # 00419de1
    add esp, 0x8                                 # 00419de6
    push 0x0                                     # 00419de9
    push 0x0                                     # 00419deb
    push 0x63888b                                # 00419ded
    call FUN_0052139c                            # 00419df2
    jmp.d32 L_0041a0f8                           # 00419df7
L_00419dfc:
    # block 0x00419dfc: <unfilled>
    mov ecx, dword ptr [ebp - local_6c]          # 00419dfc
    movsx edx, word ptr [ecx + 0x571]            # 00419dff
    imul edx, edx, 0x84d                         # 00419e06
    mov eax, dword ptr [ebp - local_6c]          # 00419e0c
    lea ecx, [eax + edx + 0x57f]                 # 00419e0f
    mov edx, dword ptr [ebp - local_6c]          # 00419e16
    mov dword ptr [edx + 0x57b], ecx             # 00419e19
    mov eax, dword ptr [ebp - local_6c]          # 00419e1f
    add eax, 0x21f                               # 00419e22
    push eax                                     # 00419e27
    mov ecx, dword ptr [ebp - local_6c]          # 00419e28
    add ecx, 0x11f                               # 00419e2b
    push ecx                                     # 00419e31
    mov edx, dword ptr [ebp - local_6c]          # 00419e32
    add edx, 0x1f                                # 00419e35
    push edx                                     # 00419e38
    mov eax, dword ptr [ebp - local_6c]          # 00419e39
    add eax, 0x1c                                # 00419e3c
    push eax                                     # 00419e3f
    mov ecx, dword ptr [ebp + arg_8]             # 00419e40
    push ecx                                     # 00419e43
    call FUN_0050d1f0                            # 00419e44
    add esp, 0x14                                # 00419e49
    mov edx, dword ptr [ebp - local_6c]          # 00419e4c
    add edx, 0x11f                               # 00419e4f
    push edx                                     # 00419e55
    call FUN_0050d0bc                            # 00419e56
    add esp, 0x4                                 # 00419e5b
    mov edi, dword ptr [ebp - local_6c]          # 00419e5e
    add edi, 0x11f                               # 00419e61
    or ecx, -0x1                                 # 00419e67
    {load} xor eax, eax                          # 00419e6a
    repne scasb al, byte ptr es:[edi]            # 00419e6c
    not ecx                                      # 00419e6e
    add ecx, -0x1                                # 00419e70
    cmp ecx, 0x20                                # 00419e73
    jbe.d8 L_00419ea6                            # 00419e76
    # block 0x00419e78: <unfilled>
    mov eax, dword ptr [ebp - local_6c]          # 00419e78
    add eax, 0x11f                               # 00419e7b
    push eax                                     # 00419e80
    push 0x542f6c                                # 00419e81
    push 0x63888b                                # 00419e86
    call FUN_0050ca3e                            # 00419e8b
    add esp, 0xc                                 # 00419e90
    push 0x0                                     # 00419e93
    push 0x0                                     # 00419e95
    push 0x63888b                                # 00419e97
    call FUN_0052139c                            # 00419e9c
    jmp.d32 L_0041a0f6                           # 00419ea1
L_00419ea6:
    # block 0x00419ea6: <unfilled>
    mov ecx, dword ptr [ebp - local_6c]          # 00419ea6
    add ecx, 0x11f                               # 00419ea9
    {load} mov edi, ecx                          # 00419eaf
    mov edx, dword ptr [ebp - local_6c]          # 00419eb1
    mov edx, dword ptr [edx + 0x57b]             # 00419eb4
    or ecx, -0x1                                 # 00419eba
    {load} xor eax, eax                          # 00419ebd
    repne scasb al, byte ptr es:[edi]            # 00419ebf
    not ecx                                      # 00419ec1
    {load} sub edi, ecx                          # 00419ec3
    {load} mov esi, edi                          # 00419ec5
    {load} mov eax, ecx                          # 00419ec7
    {load} mov edi, edx                          # 00419ec9
    shr ecx, 0x2                                 # 00419ecb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00419ece
    {load} mov ecx, eax                          # 00419ed0
    and ecx, 0x3                                 # 00419ed2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00419ed5
    push 0x542f8c                                # 00419ed7
    mov ecx, dword ptr [ebp + arg_8]             # 00419edc
    push ecx                                     # 00419edf
    call FUN_0050d0a9                            # 00419ee0
    add esp, 0x8                                 # 00419ee5
    mov edx, dword ptr [ebp - local_6c]          # 00419ee8
    mov ecx, dword ptr [edx + 0x57b]             # 00419eeb
    mov dword ptr [ecx + 0x845], eax             # 00419ef1
    mov edx, dword ptr [ebp - local_6c]          # 00419ef7
    mov eax, dword ptr [edx + 0x57b]             # 00419efa
    cmp dword ptr [eax + 0x845], 0x0             # 00419f00
    jne.d8 L_00419f55                            # 00419f07
    # block 0x00419f09: <unfilled>
    mov edi, dword ptr [ebp + arg_8]             # 00419f09
    lea edx, [ebp - local_64]                    # 00419f0c
    or ecx, -0x1                                 # 00419f0f
    {load} xor eax, eax                          # 00419f12
    repne scasb al, byte ptr es:[edi]            # 00419f14
    not ecx                                      # 00419f16
    {load} sub edi, ecx                          # 00419f18
    {load} mov esi, edi                          # 00419f1a
    {load} mov eax, ecx                          # 00419f1c
    {load} mov edi, edx                          # 00419f1e
    shr ecx, 0x2                                 # 00419f20
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00419f23
    {load} mov ecx, eax                          # 00419f25
    and ecx, 0x3                                 # 00419f27
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00419f2a
    lea ecx, [ebp - local_64]                    # 00419f2c
    push ecx                                     # 00419f2f
    push 0x542f90                                # 00419f30
    push 0x63888b                                # 00419f35
    call FUN_0050ca3e                            # 00419f3a
    add esp, 0xc                                 # 00419f3f
    push 0x0                                     # 00419f42
    push 0x0                                     # 00419f44
    push 0x63888b                                # 00419f46
    call FUN_0052139c                            # 00419f4b
    jmp.d32 L_0041a0f4                           # 00419f50
L_00419f55:
    # block 0x00419f55: <unfilled>
    mov edx, dword ptr [ebp - local_6c]          # 00419f55
    mov eax, dword ptr [edx + 0x57b]             # 00419f58
    mov ecx, dword ptr [eax + 0x845]             # 00419f5e
    push ecx                                     # 00419f64
    push 0x1                                     # 00419f65
    push 0x20                                    # 00419f67
    mov edx, dword ptr [ebp - local_6c]          # 00419f69
    mov eax, dword ptr [edx + 0x57b]             # 00419f6c
    add eax, 0x21                                # 00419f72
    push eax                                     # 00419f75
    call FUN_0050cf61                            # 00419f76
    add esp, 0x10                                # 00419f7b
    cmp eax, 0x1                                 # 00419f7e
    je.d8 L_00419f96                             # 00419f81
    # block 0x00419f83: <unfilled>
    push 0x0                                     # 00419f83
    push 0x0                                     # 00419f85
    push 0x542fdc                                # 00419f87
    call FUN_0052139c                            # 00419f8c
    jmp.d32 L_0041a0f2                           # 00419f91
L_00419f96:
    # block 0x00419f96: <unfilled>
    mov edi, 0x54301c                            # 00419f96
    mov ecx, dword ptr [ebp - local_6c]          # 00419f9b
    mov esi, dword ptr [ecx + 0x57b]             # 00419f9e
    add esi, 0x21                                # 00419fa4
    mov ecx, 0x14                                # 00419fa7
    {load} xor edx, edx                          # 00419fac
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00419fae
    jne.d8 L_00419fda                            # 00419fb0
    # block 0x00419fb2: <unfilled>
    mov eax, dword ptr [ebp - local_6c]          # 00419fb2
    mov ecx, dword ptr [eax + 0x57b]             # 00419fb5
    {load} xor edx, edx                          # 00419fbb
    mov dx, word ptr [ecx + 0x39]                # 00419fbd
    cmp edx, 0x2                                 # 00419fc1
    jne.d8 L_00419fda                            # 00419fc4
    # block 0x00419fc6: <unfilled>
    mov eax, dword ptr [ebp - local_6c]          # 00419fc6
    mov ecx, dword ptr [eax + 0x57b]             # 00419fc9
    {load} xor edx, edx                          # 00419fcf
    mov dx, word ptr [ecx + 0x3b]                # 00419fd1
    cmp edx, 0x1                                 # 00419fd5
    je.d8 L_00419fed                             # 00419fd8
L_00419fda:
    # block 0x00419fda: <unfilled>
    push 0x0                                     # 00419fda
    push 0x0                                     # 00419fdc
    push 0x543030                                # 00419fde
    call FUN_0052139c                            # 00419fe3
    jmp.d32 L_0041a0f0                           # 00419fe8
L_00419fed:
    # block 0x00419fed: <unfilled>
    mov eax, dword ptr [ebp - local_6c]          # 00419fed
    mov ecx, dword ptr [eax + 0x57b]             # 00419ff0
    mov edx, dword ptr [ecx + 0x845]             # 00419ff6
    push edx                                     # 00419ffc
    push 0x1                                     # 00419ffd
    push 0x800                                   # 00419fff
    mov eax, dword ptr [ebp - local_6c]          # 0041a004
    mov ecx, dword ptr [eax + 0x57b]             # 0041a007
    add ecx, 0x45                                # 0041a00d
    push ecx                                     # 0041a010
    call FUN_0050cf61                            # 0041a011
    add esp, 0x10                                # 0041a016
    cmp eax, 0x1                                 # 0041a019
    je.d8 L_0041a031                             # 0041a01c
    # block 0x0041a01e: <unfilled>
    push 0x0                                     # 0041a01e
    push 0x0                                     # 0041a020
    push 0x543084                                # 0041a022
    call FUN_0052139c                            # 0041a027
    jmp.d32 L_0041a0ee                           # 0041a02c
L_0041a031:
    # block 0x0041a031: <unfilled>
    mov edx, dword ptr [ebp - local_6c]          # 0041a031
    mov eax, dword ptr [edx + 0x57b]             # 0041a034
    movsx ecx, word ptr [eax + 0x3d]             # 0041a03a
    imul ecx, ecx, 0x5e                          # 0041a03e
    push ecx                                     # 0041a041
    call FUN_0051dc43                            # 0041a042
    add esp, 0x4                                 # 0041a047
    mov dword ptr [ebp - local_68], eax          # 0041a04a
    mov edx, dword ptr [ebp - local_6c]          # 0041a04d
    mov eax, dword ptr [edx + 0x57b]             # 0041a050
    mov ecx, dword ptr [ebp - local_68]          # 0041a056
    mov dword ptr [eax + 0x41], ecx              # 0041a059
    cmp dword ptr [ebp - local_68], 0x0          # 0041a05c
    jne.d8 L_0041a072                            # 0041a060
    # block 0x0041a062: <unfilled>
    push 0x0                                     # 0041a062
    push 0x0                                     # 0041a064
    push 0x5430c8                                # 0041a066
    call FUN_0052139c                            # 0041a06b
    jmp.d8 L_0041a0ec                            # 0041a070
L_0041a072:
    # block 0x0041a072: <unfilled>
    mov edx, dword ptr [ebp - local_6c]          # 0041a072
    mov eax, dword ptr [edx + 0x57b]             # 0041a075
    mov ecx, dword ptr [eax + 0x845]             # 0041a07b
    push ecx                                     # 0041a081
    push 0x1                                     # 0041a082
    mov edx, dword ptr [ebp - local_6c]          # 0041a084
    mov eax, dword ptr [edx + 0x57b]             # 0041a087
    movsx ecx, word ptr [eax + 0x3d]             # 0041a08d
    imul ecx, ecx, 0x5e                          # 0041a091
    push ecx                                     # 0041a094
    mov edx, dword ptr [ebp - local_6c]          # 0041a095
    mov eax, dword ptr [edx + 0x57b]             # 0041a098
    mov ecx, dword ptr [eax + 0x41]              # 0041a09e
    push ecx                                     # 0041a0a1
    call FUN_0050cf61                            # 0041a0a2
    add esp, 0x10                                # 0041a0a7
    cmp eax, 0x1                                 # 0041a0aa
    je.d8 L_0041a0bf                             # 0041a0ad
    # block 0x0041a0af: <unfilled>
    push 0x0                                     # 0041a0af
    push 0x0                                     # 0041a0b1
    push 0x543110                                # 0041a0b3
    call FUN_0052139c                            # 0041a0b8
    jmp.d8 L_0041a0ea                            # 0041a0bd
L_0041a0bf:
    # block 0x0041a0bf: <unfilled>
    mov edx, dword ptr [ebp - local_6c]          # 0041a0bf
    mov eax, dword ptr [edx + 0x57b]             # 0041a0c2
    mov dword ptr [eax + 0x849], 0x1             # 0041a0c8
    jmp.d8 L_0041a0fa                            # 0041a0d2
L_0041a0d4:
    # block 0x0041a0d4: <unfilled>
    mov dword ptr [0x63a58a], 0x3                # 0041a0d4
    mov ecx, 0x5cf659                            # 0041a0de
    call FUN_004c97b4                            # 0041a0e3
    jmp.d8 L_0041a0fa                            # 0041a0e8
L_0041a0ea:
    # block 0x0041a0ea: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0ea
L_0041a0ec:
    # block 0x0041a0ec: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0ec
L_0041a0ee:
    # block 0x0041a0ee: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0ee
L_0041a0f0:
    # block 0x0041a0f0: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0f0
L_0041a0f2:
    # block 0x0041a0f2: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0f2
L_0041a0f4:
    # block 0x0041a0f4: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0f4
L_0041a0f6:
    # block 0x0041a0f6: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0f6
L_0041a0f8:
    # block 0x0041a0f8: <unfilled>
    jmp.d8 L_0041a0d4                            # 0041a0f8
L_0041a0fa:
    # block 0x0041a0fa: <unfilled>
    pop edi                                      # 0041a0fa
    pop esi                                      # 0041a0fb
    {load} mov esp, ebp                          # 0041a0fc
    pop ebp                                      # 0041a0fe
    ret 0x4                                      # 0041a0ff
