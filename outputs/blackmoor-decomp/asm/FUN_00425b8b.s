# FUN_00425b8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00425b8b
# extent:       0x00425b8b-0x00425f25 (922 code bytes)
# span:         0x00425b8b-0x00425f25 (code 922, tables 0, padding 0)
# sha256:       55245dbef96ea237003e0fa71725c0924644e4e5dea4160a61bd6816f05bd782
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00425b8b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_104, local_108, local_10c, local_18c, local_190
# fields:       [eax + n] field_c, field_16, field_44, field_610; [ecx + n] field_4, field_8, field_c, field_16, field_38, field_44; [edx + n] field_8
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_00425f25, FUN_0042356d, FUN_00425b8b, FUN_004235fd, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 246 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_18c, 0x18c  # offset -0x18c
.equ local_190, 0x190  # offset -0x190
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_16, 0x16  # offset +0x16
.equ field_38, 0x38  # offset +0x38
.equ field_44, 0x44  # offset +0x44
.equ field_610, 0x610  # offset +0x610

# --- external targets -----------------------------------------------
.set FUN_0042356d, .text + (0x0042356d - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_00425f25, .text + (0x00425f25 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00425b8b - 0x401000
.globl FUN_00425b8b
FUN_00425b8b:
L_00425b8b:
    # block 0x00425b8b: entry, 10 instruction(s), ends with jne to 0x00425c01 (forward)
    push ebp                                     # 00425b8b
    {load} mov ebp, esp                          # 00425b8c
    sub esp, 0x190                               # 00425b8e
    push ebx                                     # 00425b94
    push esi                                     # 00425b95
    push edi                                     # 00425b96
    mov dword ptr [ebp - local_190], ecx         # 00425b97
    mov eax, dword ptr [ebp - local_190]         # 00425b9d
    cmp dword ptr [eax + field_610], 0x0         # 00425ba3
    jne.d8 L_00425c01                            # 00425baa
    # block 0x00425bac: entered by fall-through of jne at 0x00425baa, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00425c01
    push 0x545254                                # 00425bac
    push 0x63888b                                # 00425bb1
    call FUN_0050ca3e                            # 00425bb6
    add esp, 0x8                                 # 00425bbb
    push 0x63888b                                # 00425bbe
    call FUN_0044a2b7                            # 00425bc3
    add esp, 0x4                                 # 00425bc8
    mov ecx, dword ptr [ebp + arg_8]             # 00425bcb
    mov edx, dword ptr [ecx + field_8]           # 00425bce
    push edx                                     # 00425bd1
    push 0x545270                                # 00425bd2
    push 0x63888b                                # 00425bd7
    call FUN_0050ca3e                            # 00425bdc
    add esp, 0xc                                 # 00425be1
    push 0x63888b                                # 00425be4
    call FUN_0044a2b7                            # 00425be9
    add esp, 0x4                                 # 00425bee
    mov eax, dword ptr [ebp - local_190]         # 00425bf1
    mov dword ptr [eax + field_610], 0x1         # 00425bf7
L_00425c01:
    # block 0x00425c01: entered by jne at 0x00425baa, 4 instruction(s), falls into the block at 0x00425c17
    mov ecx, dword ptr [ebp + arg_8]             # 00425c01
    mov edx, dword ptr [ecx + field_4]           # 00425c04
    mov dword ptr [ebp - local_108], edx         # 00425c07
    mov dword ptr [ebp - local_10c], 0x0         # 00425c0d
L_00425c17:
    # block 0x00425c17: entered by jmp at 0x00425ee1, 2 instruction(s), ends with jne to 0x00425ee6 (forward)
    cmp dword ptr [ebp - local_10c], 0x0         # 00425c17
    jne.d32 L_00425ee6                           # 00425c1e
    # block 0x00425c24: entered by fall-through of jne at 0x00425c1e, 3 instruction(s), ends with jne to 0x00425ce7 (forward)
    mov eax, dword ptr [ebp - local_108]         # 00425c24
    cmp dword ptr [eax], 0x2                     # 00425c2a
    jne.d32 L_00425ce7                           # 00425c2d
    # block 0x00425c33: entered by fall-through of jne at 0x00425c2d, 47 instruction(s), calls FUN_00425f25, FUN_0050ca3e, FUN_0044a2b7, ends with jne to 0x00425ce2 (forward)
    mov ecx, dword ptr [0x544420]                # 00425c33
    push ecx                                     # 00425c39
    lea edx, [ebp - local_104]                   # 00425c3a
    push edx                                     # 00425c40
    mov ecx, dword ptr [ebp - local_190]         # 00425c41
    call FUN_00425f25                            # 00425c47
    mov eax, dword ptr [ebp - local_108]         # 00425c4c
    movsx ecx, word ptr [eax + field_16]         # 00425c52
    mov edx, dword ptr [4*ecx + 0x5443e0]        # 00425c56
    push edx                                     # 00425c5d
    mov eax, dword ptr [ebp - local_108]         # 00425c5e
    mov ecx, dword ptr [eax + field_c]           # 00425c64
    push ecx                                     # 00425c67
    push 0x54528c                                # 00425c68
    lea edx, [ebp - local_18c]                   # 00425c6d
    push edx                                     # 00425c73
    call FUN_0050ca3e                            # 00425c74
    add esp, 0x10                                # 00425c79
    lea edi, [ebp - local_18c]                   # 00425c7c
    lea edx, [ebp - local_104]                   # 00425c82
    or ecx, -0x1                                 # 00425c88
    {load} xor eax, eax                          # 00425c8b
    repne scasb al, byte ptr es:[edi]            # 00425c8d
    not ecx                                      # 00425c8f
    {load} sub edi, ecx                          # 00425c91
    {load} mov esi, edi                          # 00425c93
    {load} mov ebx, ecx                          # 00425c95
    {load} mov edi, edx                          # 00425c97
    or ecx, -0x1                                 # 00425c99
    {load} xor eax, eax                          # 00425c9c
    repne scasb al, byte ptr es:[edi]            # 00425c9e
    add edi, -0x1                                # 00425ca0
    {load} mov ecx, ebx                          # 00425ca3
    shr ecx, 0x2                                 # 00425ca5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00425ca8
    {load} mov ecx, ebx                          # 00425caa
    and ecx, 0x3                                 # 00425cac
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00425caf
    lea eax, [ebp - local_104]                   # 00425cb1
    push eax                                     # 00425cb7
    call FUN_0044a2b7                            # 00425cb8
    add esp, 0x4                                 # 00425cbd
    mov ecx, dword ptr [ebp - local_108]         # 00425cc0
    mov edx, dword ptr [ecx + field_38]          # 00425cc6
    mov dword ptr [ebp - local_108], edx         # 00425cc9
    cmp dword ptr [ebp - local_108], 0x0         # 00425ccf
    jne.d8 L_00425ce2                            # 00425cd6
    # block 0x00425cd8: entered by fall-through of jne at 0x00425cd6, 1 instruction(s), falls into the block at 0x00425ce2
    mov dword ptr [ebp - local_10c], 0x1         # 00425cd8
L_00425ce2:
    # block 0x00425ce2: entered by jne at 0x00425cd6, 1 instruction(s), ends with forward jump to 0x00425ee1
    jmp.d32 L_00425ee1                           # 00425ce2
L_00425ce7:
    # block 0x00425ce7: entered by jne at 0x00425c2d, 3 instruction(s), ends with jne to 0x00425ee1 (forward)
    mov eax, dword ptr [ebp - local_108]         # 00425ce7
    cmp dword ptr [eax], 0x1                     # 00425ced
    jne.d32 L_00425ee1                           # 00425cf0
    # block 0x00425cf6: entered by fall-through of jne at 0x00425cf0, 68 instruction(s), calls FUN_00425f25, FUN_0050ca3e, FUN_0044a2b7, FUN_0042356d, FUN_00425b8b, FUN_004235fd, ends with je to 0x00425ecd (forward)
    mov ecx, dword ptr [0x544420]                # 00425cf6
    push ecx                                     # 00425cfc
    lea edx, [ebp - local_104]                   # 00425cfd
    push edx                                     # 00425d03
    mov ecx, dword ptr [ebp - local_190]         # 00425d04
    call FUN_00425f25                            # 00425d0a
    mov eax, dword ptr [ebp - local_108]         # 00425d0f
    movsx ecx, word ptr [eax + field_16]         # 00425d15
    mov edx, dword ptr [4*ecx + 0x5443e0]        # 00425d19
    push edx                                     # 00425d20
    mov eax, dword ptr [ebp - local_108]         # 00425d21
    mov ecx, dword ptr [eax + field_44]          # 00425d27
    mov edx, dword ptr [ecx + field_8]           # 00425d2a
    push edx                                     # 00425d2d
    mov eax, dword ptr [ebp - local_108]         # 00425d2e
    mov ecx, dword ptr [eax + field_c]           # 00425d34
    push ecx                                     # 00425d37
    push 0x54529c                                # 00425d38
    lea edx, [ebp - local_18c]                   # 00425d3d
    push edx                                     # 00425d43
    call FUN_0050ca3e                            # 00425d44
    add esp, 0x14                                # 00425d49
    lea edi, [ebp - local_18c]                   # 00425d4c
    lea edx, [ebp - local_104]                   # 00425d52
    or ecx, -0x1                                 # 00425d58
    {load} xor eax, eax                          # 00425d5b
    repne scasb al, byte ptr es:[edi]            # 00425d5d
    not ecx                                      # 00425d5f
    {load} sub edi, ecx                          # 00425d61
    {load} mov esi, edi                          # 00425d63
    {load} mov ebx, ecx                          # 00425d65
    {load} mov edi, edx                          # 00425d67
    or ecx, -0x1                                 # 00425d69
    {load} xor eax, eax                          # 00425d6c
    repne scasb al, byte ptr es:[edi]            # 00425d6e
    add edi, -0x1                                # 00425d70
    {load} mov ecx, ebx                          # 00425d73
    shr ecx, 0x2                                 # 00425d75
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00425d78
    {load} mov ecx, ebx                          # 00425d7a
    and ecx, 0x3                                 # 00425d7c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00425d7f
    lea eax, [ebp - local_104]                   # 00425d81
    push eax                                     # 00425d87
    call FUN_0044a2b7                            # 00425d88
    add esp, 0x4                                 # 00425d8d
    mov ecx, dword ptr [0x544420]                # 00425d90
    add ecx, 0x1                                 # 00425d96
    mov dword ptr [0x544420], ecx                # 00425d99
    mov edx, dword ptr [ebp - local_108]         # 00425d9f
    push edx                                     # 00425da5
    mov eax, dword ptr [ebp + arg_8]             # 00425da6
    push eax                                     # 00425da9
    mov ecx, dword ptr [ebp - local_190]         # 00425daa
    call FUN_0042356d                            # 00425db0
    mov ecx, dword ptr [ebp - local_108]         # 00425db5
    mov edx, dword ptr [ecx + field_44]          # 00425dbb
    push edx                                     # 00425dbe
    mov ecx, dword ptr [ebp - local_190]         # 00425dbf
    call L_00425b8b                              # 00425dc5
    mov ecx, dword ptr [ebp - local_190]         # 00425dca
    call FUN_004235fd                            # 00425dd0
    mov dword ptr [ebp - local_4], eax           # 00425dd5
    mov eax, dword ptr [0x544420]                # 00425dd8
    sub eax, 0x1                                 # 00425ddd
    mov dword ptr [0x544420], eax                # 00425de0
    cmp dword ptr [ebp - local_4], 0x0           # 00425de5
    je.d32 L_00425ecd                            # 00425de9
    # block 0x00425def: entered by fall-through of je at 0x00425de9, 57 instruction(s), calls FUN_00425f25, FUN_0050ca3e, FUN_0044a2b7, ends with jne to 0x00425ec1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00425def
    mov edx, dword ptr [ecx + field_8]           # 00425df2
    mov dword ptr [ebp - local_108], edx         # 00425df5
    mov eax, dword ptr [ebp - local_4]           # 00425dfb
    mov ecx, dword ptr [eax]                     # 00425dfe
    mov dword ptr [ebp + arg_8], ecx             # 00425e00
    mov edx, dword ptr [0x544420]                # 00425e03
    push edx                                     # 00425e09
    lea eax, [ebp - local_104]                   # 00425e0a
    push eax                                     # 00425e10
    mov ecx, dword ptr [ebp - local_190]         # 00425e11
    call FUN_00425f25                            # 00425e17
    mov ecx, dword ptr [ebp - local_108]         # 00425e1c
    movsx edx, word ptr [ecx + field_16]         # 00425e22
    mov eax, dword ptr [4*edx + 0x5443e0]        # 00425e26
    push eax                                     # 00425e2d
    mov ecx, dword ptr [ebp - local_108]         # 00425e2e
    mov edx, dword ptr [ecx + field_44]          # 00425e34
    mov eax, dword ptr [edx + field_8]           # 00425e37
    push eax                                     # 00425e3a
    mov ecx, dword ptr [ebp - local_108]         # 00425e3b
    mov edx, dword ptr [ecx + field_c]           # 00425e41
    push edx                                     # 00425e44
    push 0x5452c4                                # 00425e45
    lea eax, [ebp - local_18c]                   # 00425e4a
    push eax                                     # 00425e50
    call FUN_0050ca3e                            # 00425e51
    add esp, 0x14                                # 00425e56
    lea edi, [ebp - local_18c]                   # 00425e59
    lea edx, [ebp - local_104]                   # 00425e5f
    or ecx, -0x1                                 # 00425e65
    {load} xor eax, eax                          # 00425e68
    repne scasb al, byte ptr es:[edi]            # 00425e6a
    not ecx                                      # 00425e6c
    {load} sub edi, ecx                          # 00425e6e
    {load} mov esi, edi                          # 00425e70
    {load} mov ebx, ecx                          # 00425e72
    {load} mov edi, edx                          # 00425e74
    or ecx, -0x1                                 # 00425e76
    {load} xor eax, eax                          # 00425e79
    repne scasb al, byte ptr es:[edi]            # 00425e7b
    add edi, -0x1                                # 00425e7d
    {load} mov ecx, ebx                          # 00425e80
    shr ecx, 0x2                                 # 00425e82
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00425e85
    {load} mov ecx, ebx                          # 00425e87
    and ecx, 0x3                                 # 00425e89
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00425e8c
    lea eax, [ebp - local_104]                   # 00425e8e
    push eax                                     # 00425e94
    call FUN_0044a2b7                            # 00425e95
    add esp, 0x4                                 # 00425e9a
    mov ecx, dword ptr [ebp - local_108]         # 00425e9d
    mov edx, dword ptr [ecx + field_38]          # 00425ea3
    mov dword ptr [ebp - local_108], edx         # 00425ea6
    cmp dword ptr [ebp - local_108], 0x0         # 00425eac
    jne.d8 L_00425ec1                            # 00425eb3
    # block 0x00425eb5: entered by fall-through of jne at 0x00425eb3, 2 instruction(s), ends with forward jump to 0x00425ecb
    mov dword ptr [ebp - local_10c], 0x1         # 00425eb5
    jmp.d8 L_00425ecb                            # 00425ebf
L_00425ec1:
    # block 0x00425ec1: entered by jne at 0x00425eb3, 1 instruction(s), falls into the block at 0x00425ecb
    mov dword ptr [ebp - local_10c], 0x0         # 00425ec1
L_00425ecb:
    # block 0x00425ecb: entered by jmp at 0x00425ebf, 1 instruction(s), ends with forward jump to 0x00425ee1
    jmp.d8 L_00425ee1                            # 00425ecb
L_00425ecd:
    # block 0x00425ecd: entered by je at 0x00425de9, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425f1a
    push 0x5452ec                                # 00425ecd
    push 0x63888b                                # 00425ed2
    call FUN_0050ca3e                            # 00425ed7
    add esp, 0x8                                 # 00425edc
    jmp.d8 L_00425f1a                            # 00425edf
L_00425ee1:
    # block 0x00425ee1: entered by jmp at 0x00425ce2; jne at 0x00425cf0; jmp at 0x00425ecb, 1 instruction(s), ends with backward jump to 0x00425c17
    jmp.d32 L_00425c17                           # 00425ee1
L_00425ee6:
    # block 0x00425ee6: entered by jne at 0x00425c1e, 1 instruction(s), ends with forward jump to 0x00425f1c
    jmp.d8 L_00425f1c                            # 00425ee6
L_00425ee8:
    # block 0x00425ee8: entered by jmp at 0x00425f1a, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00425f0e (forward)
    push 0x0                                     # 00425ee8
    push 0x0                                     # 00425eea
    push 0x63888b                                # 00425eec
    call FUN_0052139c                            # 00425ef1
    movsx eax, word ptr [0x63a4cd]               # 00425ef6
    test eax, eax                                # 00425efd
    je.d8 L_00425f0e                             # 00425eff
    # block 0x00425f01: entered by fall-through of je at 0x00425eff, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00425f0e
    push 0x63888b                                # 00425f01
    call FUN_0044a2b7                            # 00425f06
    add esp, 0x4                                 # 00425f0b
L_00425f0e:
    # block 0x00425f0e: entered by je at 0x00425eff, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00425f1c
    mov ecx, 0x5cf659                            # 00425f0e
    call FUN_004c97b4                            # 00425f13
    jmp.d8 L_00425f1c                            # 00425f18
L_00425f1a:
    # block 0x00425f1a: entered by jmp at 0x00425edf, 1 instruction(s), ends with backward jump to 0x00425ee8
    jmp.d8 L_00425ee8                            # 00425f1a
L_00425f1c:
    # block 0x00425f1c: entered by jmp at 0x00425ee6; jmp at 0x00425f18, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 00425f1c
    pop esi                                      # 00425f1d
    pop ebx                                      # 00425f1e
    {load} mov esp, ebp                          # 00425f1f
    pop ebp                                      # 00425f21
    ret 0x4                                      # 00425f22

