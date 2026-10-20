# FUN_00411b16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00411b16
# extent:       0x00411b16-0x00411f24 (1038 code bytes)
# span:         0x00411b16-0x00411f24 (code 1038, tables 0, padding 0)
# sha256:       5afbf0368df06c3056a379c32ae48ab96910e2ca7adcf40164b0949f492bafe9
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_d8_record_builder
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_44_runtime.h:17 says "0x411b16 builds the 0xd8 record"
# name-note:    Builds the 0xd8 record from the 0x44 object and the link table the text writer left.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_c, field_4c, field_50, field_134, field_15e; [ecx + n] field_4, field_8, field_c, field_e, field_42, field_15e, field_162, field_1eb, field_102a; [edx + n] field_2, field_4, field_8, field_c, field_15e, field_102e; [esi + n] field_160
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_005193ca, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/action_family_44_runtime.h:a44_build_record (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 286 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ field_42, 0x42  # offset +0x42
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_134, 0x134  # offset +0x134
.equ field_15e, 0x15e  # offset +0x15e
.equ field_160, 0x160  # offset +0x160
.equ field_162, 0x162  # offset +0x162
.equ field_1eb, 0x1eb  # offset +0x1eb
.equ field_102a, 0x102a  # offset +0x102a
.equ field_102e, 0x102e  # offset +0x102e

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00411b16 - 0x401000
.globl FUN_00411b16
FUN_00411b16:
    # block 0x00411b16: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00411b7d (forward)
    push ebp                                     # 00411b16
    {load} mov ebp, esp                          # 00411b17
    sub esp, 0x28                                # 00411b19
    push ebx                                     # 00411b1c
    push esi                                     # 00411b1d
    push edi                                     # 00411b1e
    mov dword ptr [ebp - local_28], ecx          # 00411b1f
    push 0x868                                   # 00411b22
    call FUN_0051dc43                            # 00411b27
    add esp, 0x4                                 # 00411b2c
    mov dword ptr [ebp - local_18], eax          # 00411b2f
    mov eax, dword ptr [ebp - local_18]          # 00411b32
    mov dword ptr [ebp - local_14], eax          # 00411b35
    cmp dword ptr [ebp - local_14], 0x0          # 00411b38
    jne.d8 L_00411b7d                            # 00411b3c
    # block 0x00411b3e: entered by fall-through of jne at 0x00411b3c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411b7d
    movsx ecx, word ptr [0x5c39e3]               # 00411b3e
    push ecx                                     # 00411b45
    mov edx, dword ptr [0x5bb57b]                # 00411b46
    push edx                                     # 00411b4c
    push 0x541484                                # 00411b4d
    push 0x63888b                                # 00411b52
    call FUN_0050ca3e                            # 00411b57
    add esp, 0x10                                # 00411b5c
    push 0x63888b                                # 00411b5f
    push 0x5414d0                                # 00411b64
    mov ecx, 0x583979                            # 00411b69
    call FUN_0042639d                            # 00411b6e
    mov ecx, 0x5cf659                            # 00411b73
    call FUN_004c97b4                            # 00411b78
L_00411b7d:
    # block 0x00411b7d: entered by jne at 0x00411b3c, 130 instruction(s), calls FUN_005193ca, ends with je to 0x00411de3 (forward)
    mov ecx, 0x21a                               # 00411b7d
    {load} xor eax, eax                          # 00411b82
    mov edi, dword ptr [ebp - local_14]          # 00411b84
    rep stosd dword ptr es:[edi], eax            # 00411b87
    mov edi, 0x5414ec                            # 00411b89
    mov edx, dword ptr [ebp - local_14]          # 00411b8e
    or ecx, -0x1                                 # 00411b91
    {load} xor eax, eax                          # 00411b94
    repne scasb al, byte ptr es:[edi]            # 00411b96
    not ecx                                      # 00411b98
    {load} sub edi, ecx                          # 00411b9a
    {load} mov esi, edi                          # 00411b9c
    {load} mov eax, ecx                          # 00411b9e
    {load} mov edi, edx                          # 00411ba0
    shr ecx, 0x2                                 # 00411ba2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411ba5
    {load} mov ecx, eax                          # 00411ba7
    and ecx, 0x3                                 # 00411ba9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411bac
    push 0xa                                     # 00411bae
    lea ecx, [ebp - local_c]                     # 00411bb0
    push ecx                                     # 00411bb3
    mov edx, dword ptr [ebp + arg_8]             # 00411bb4
    movsx eax, word ptr [edx + field_2]          # 00411bb7
    sub eax, 0x2                                 # 00411bbb
    push eax                                     # 00411bbe
    call FUN_005193ca                            # 00411bbf
    add esp, 0xc                                 # 00411bc4
    lea edi, [ebp - local_c]                     # 00411bc7
    mov edx, dword ptr [ebp - local_14]          # 00411bca
    or ecx, -0x1                                 # 00411bcd
    {load} xor eax, eax                          # 00411bd0
    repne scasb al, byte ptr es:[edi]            # 00411bd2
    not ecx                                      # 00411bd4
    {load} sub edi, ecx                          # 00411bd6
    {load} mov esi, edi                          # 00411bd8
    {load} mov ebx, ecx                          # 00411bda
    {load} mov edi, edx                          # 00411bdc
    or ecx, -0x1                                 # 00411bde
    {load} xor eax, eax                          # 00411be1
    repne scasb al, byte ptr es:[edi]            # 00411be3
    add edi, -0x1                                # 00411be5
    {load} mov ecx, ebx                          # 00411be8
    shr ecx, 0x2                                 # 00411bea
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411bed
    {load} mov ecx, ebx                          # 00411bef
    and ecx, 0x3                                 # 00411bf1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411bf4
    mov eax, dword ptr [ebp + arg_8]             # 00411bf6
    add eax, 0xea                                # 00411bf9
    {load} mov edi, eax                          # 00411bfe
    mov ecx, dword ptr [ebp - local_14]          # 00411c00
    add ecx, 0x21                                # 00411c03
    {load} mov edx, ecx                          # 00411c06
    or ecx, -0x1                                 # 00411c08
    {load} xor eax, eax                          # 00411c0b
    repne scasb al, byte ptr es:[edi]            # 00411c0d
    not ecx                                      # 00411c0f
    {load} sub edi, ecx                          # 00411c11
    {load} mov esi, edi                          # 00411c13
    {load} mov eax, ecx                          # 00411c15
    {load} mov edi, edx                          # 00411c17
    shr ecx, 0x2                                 # 00411c19
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411c1c
    {load} mov ecx, eax                          # 00411c1e
    and ecx, 0x3                                 # 00411c20
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411c23
    mov ecx, dword ptr [ebp - local_14]          # 00411c25
    mov edx, dword ptr [ebp + arg_8]             # 00411c28
    mov ax, word ptr [edx]                       # 00411c2b
    mov word ptr [ecx + field_42], ax            # 00411c2e
    mov ecx, dword ptr [ebp + arg_8]             # 00411c32
    movsx edx, word ptr [ecx + field_e]          # 00411c35
    mov eax, dword ptr [ebp - local_14]          # 00411c39
    mov dword ptr [eax + field_50], edx          # 00411c3c
    mov ecx, dword ptr [ebp + arg_8]             # 00411c3f
    movsx edx, word ptr [ecx + field_c]          # 00411c42
    mov eax, dword ptr [ebp - local_14]          # 00411c46
    mov dword ptr [eax + field_4c], edx          # 00411c49
    mov ecx, dword ptr [ebp + arg_8]             # 00411c4c
    add ecx, 0x10b                               # 00411c4f
    mov edx, dword ptr [ebp - local_14]          # 00411c55
    add edx, 0x54                                # 00411c58
    mov eax, dword ptr [ecx]                     # 00411c5b
    mov dword ptr [edx], eax                     # 00411c5d
    mov eax, dword ptr [ecx + field_4]           # 00411c5f
    mov dword ptr [edx + field_4], eax           # 00411c62
    mov eax, dword ptr [ecx + field_8]           # 00411c65
    mov dword ptr [edx + field_8], eax           # 00411c68
    mov ecx, dword ptr [ecx + field_c]           # 00411c6b
    mov dword ptr [edx + field_c], ecx           # 00411c6e
    mov edx, dword ptr [ebp + arg_8]             # 00411c71
    add edx, 0x11b                               # 00411c74
    mov eax, dword ptr [ebp - local_14]          # 00411c7a
    add eax, 0x64                                # 00411c7d
    mov ecx, dword ptr [edx]                     # 00411c80
    mov dword ptr [eax], ecx                     # 00411c82
    mov ecx, dword ptr [edx + field_4]           # 00411c84
    mov dword ptr [eax + field_4], ecx           # 00411c87
    mov ecx, dword ptr [edx + field_8]           # 00411c8a
    mov dword ptr [eax + field_8], ecx           # 00411c8d
    mov edx, dword ptr [edx + field_c]           # 00411c90
    mov dword ptr [eax + field_c], edx           # 00411c93
    mov esi, dword ptr [ebp + arg_8]             # 00411c96
    add esi, 0x12b                               # 00411c99
    mov edi, dword ptr [ebp - local_14]          # 00411c9f
    add edi, 0x74                                # 00411ca2
    mov ecx, 0x10                                # 00411ca5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411caa
    mov esi, dword ptr [ebp + arg_8]             # 00411cac
    add esi, 0x16b                               # 00411caf
    mov edi, dword ptr [ebp - local_14]          # 00411cb5
    add edi, 0xb4                                # 00411cb8
    mov ecx, 0x10                                # 00411cbe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411cc3
    mov esi, dword ptr [ebp + arg_8]             # 00411cc5
    add esi, 0x1ab                               # 00411cc8
    mov edi, dword ptr [ebp - local_14]          # 00411cce
    add edi, 0xf4                                # 00411cd1
    mov ecx, 0x10                                # 00411cd7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411cdc
    mov eax, dword ptr [ebp - local_14]          # 00411cde
    mov ecx, dword ptr [ebp + arg_8]             # 00411ce1
    mov dl, byte ptr [ecx + field_1eb]           # 00411ce4
    mov byte ptr [eax + field_134], dl           # 00411cea
    mov eax, dword ptr [ebp - local_14]          # 00411cf0
    mov word ptr [eax + field_15e], 0x0          # 00411cf3
    mov ecx, dword ptr [ebp - local_28]          # 00411cfc
    cmp dword ptr [ecx + field_102a], 0x0        # 00411cff
    je.d32 L_00411de3                            # 00411d06
    # block 0x00411d0c: entered by fall-through of je at 0x00411d06, 2 instruction(s), ends with forward jump to 0x00411d20
    mov word ptr [ebp - local_4], 0x0            # 00411d0c
    jmp.d8 L_00411d20                            # 00411d12
L_00411d14:
    # block 0x00411d14: entered by jmp at 0x00411dde, 3 instruction(s), falls into the block at 0x00411d20
    mov dx, word ptr [ebp - local_4]             # 00411d14
    add dx, 0x1                                  # 00411d18
    mov word ptr [ebp - local_4], dx             # 00411d1c
L_00411d20:
    # block 0x00411d20: entered by jmp at 0x00411d12, 5 instruction(s), ends with jge to 0x00411de3 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00411d20
    movsx ecx, word ptr [ebp + arg_10]           # 00411d24
    movsx edx, word ptr [2*ecx + 0x59fbdb]       # 00411d28
    {load} cmp eax, edx                          # 00411d30
    jge.d32 L_00411de3                           # 00411d32
    # block 0x00411d38: entered by fall-through of jge at 0x00411d32, 6 instruction(s), ends with je to 0x00411dde (forward)
    movsx eax, word ptr [ebp + arg_10]           # 00411d38
    imul eax, eax, 0x320                         # 00411d3c
    movsx ecx, word ptr [ebp - local_4]          # 00411d42
    movsx edx, word ptr [eax + 2*ecx + 0x59fbe1] # 00411d46
    cmp edx, 0x270f                              # 00411d4e
    je.d32 L_00411dde                            # 00411d54
    # block 0x00411d5a: entered by fall-through of je at 0x00411d54, 31 instruction(s), falls into the block at 0x00411dde
    movsx eax, word ptr [ebp + arg_10]           # 00411d5a
    imul eax, eax, 0x320                         # 00411d5e
    movsx ecx, word ptr [ebp - local_4]          # 00411d64
    mov edx, dword ptr [ebp - local_14]          # 00411d68
    movsx edx, word ptr [edx + field_15e]        # 00411d6b
    imul edx, edx, 0x12                          # 00411d72
    mov esi, dword ptr [ebp - local_14]          # 00411d75
    mov ax, word ptr [eax + 2*ecx + 0x59fbe1]    # 00411d78
    mov word ptr [esi + edx + field_160], ax     # 00411d80
    movsx ecx, word ptr [ebp - local_4]          # 00411d88
    shl ecx, 0x4                                 # 00411d8c
    mov edx, dword ptr [ebp - local_28]          # 00411d8f
    lea eax, [edx + ecx + field_102e]            # 00411d92
    mov ecx, dword ptr [ebp - local_14]          # 00411d99
    movsx edx, word ptr [ecx + field_15e]        # 00411d9c
    imul edx, edx, 0x12                          # 00411da3
    mov ecx, dword ptr [ebp - local_14]          # 00411da6
    lea edx, [ecx + edx + field_162]             # 00411da9
    mov ecx, dword ptr [eax]                     # 00411db0
    mov dword ptr [edx], ecx                     # 00411db2
    mov ecx, dword ptr [eax + field_4]           # 00411db4
    mov dword ptr [edx + field_4], ecx           # 00411db7
    mov ecx, dword ptr [eax + field_8]           # 00411dba
    mov dword ptr [edx + field_8], ecx           # 00411dbd
    mov eax, dword ptr [eax + field_c]           # 00411dc0
    mov dword ptr [edx + field_c], eax           # 00411dc3
    mov ecx, dword ptr [ebp - local_14]          # 00411dc6
    mov dx, word ptr [ecx + field_15e]           # 00411dc9
    add dx, 0x1                                  # 00411dd0
    mov eax, dword ptr [ebp - local_14]          # 00411dd4
    mov word ptr [eax + field_15e], dx           # 00411dd7
L_00411dde:
    # block 0x00411dde: entered by je at 0x00411d54, 1 instruction(s), ends with backward jump to 0x00411d14
    jmp.d32 L_00411d14                           # 00411dde
L_00411de3:
    # block 0x00411de3: entered by je at 0x00411d06; jge at 0x00411d32, 30 instruction(s), calls FUN_0051dc6c, FUN_0051dc43, ends with jne to 0x00411e9d (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00411de3
    imul ecx, ecx, 0x8d                          # 00411de7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00411ded
    mov dword ptr [ebp - local_1c], edx          # 00411df3
    mov eax, dword ptr [ebp - local_1c]          # 00411df6
    push eax                                     # 00411df9
    call FUN_0051dc6c                            # 00411dfa
    add esp, 0x4                                 # 00411dff
    movsx ecx, word ptr [ebp + arg_c]            # 00411e02
    imul ecx, ecx, 0x8d                          # 00411e06
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 00411e0c
    mov edx, dword ptr [ebp - local_14]          # 00411e16
    movsx eax, word ptr [edx + field_15e]        # 00411e19
    mov ecx, 0x64                                # 00411e20
    {load} sub ecx, eax                          # 00411e25
    imul ecx, ecx, 0x12                          # 00411e27
    mov edx, 0x868                               # 00411e2a
    {load} sub edx, ecx                          # 00411e2f
    mov word ptr [ebp - local_10], dx            # 00411e31
    movsx eax, word ptr [ebp - local_10]         # 00411e35
    push eax                                     # 00411e39
    call FUN_0051dc43                            # 00411e3a
    add esp, 0x4                                 # 00411e3f
    mov dword ptr [ebp - local_20], eax          # 00411e42
    movsx ecx, word ptr [ebp + arg_c]            # 00411e45
    imul ecx, ecx, 0x8d                          # 00411e49
    mov edx, dword ptr [ebp - local_20]          # 00411e4f
    mov dword ptr [ecx + 0x5bb5e5], edx          # 00411e52
    cmp dword ptr [ebp - local_20], 0x0          # 00411e58
    jne.d8 L_00411e9d                            # 00411e5c
    # block 0x00411e5e: entered by fall-through of jne at 0x00411e5c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411e9d
    movsx eax, word ptr [0x5c39e3]               # 00411e5e
    push eax                                     # 00411e65
    mov ecx, dword ptr [0x5bb57b]                # 00411e66
    push ecx                                     # 00411e6c
    push 0x5414fc                                # 00411e6d
    push 0x63888b                                # 00411e72
    call FUN_0050ca3e                            # 00411e77
    add esp, 0x10                                # 00411e7c
    push 0x63888b                                # 00411e7f
    push 0x541548                                # 00411e84
    mov ecx, 0x583979                            # 00411e89
    call FUN_0042639d                            # 00411e8e
    mov ecx, 0x5cf659                            # 00411e93
    call FUN_004c97b4                            # 00411e98
L_00411e9d:
    # block 0x00411e9d: entered by jne at 0x00411e5c, 35 instruction(s), calls FUN_0051dc6c, ends with ret 0xc
    movsx ecx, word ptr [ebp - local_10]         # 00411e9d
    mov esi, dword ptr [ebp - local_14]          # 00411ea1
    movsx edx, word ptr [ebp + arg_c]            # 00411ea4
    imul edx, edx, 0x8d                          # 00411ea8
    mov edi, dword ptr [edx + 0x5bb5e5]          # 00411eae
    {load} mov eax, ecx                          # 00411eb4
    shr ecx, 0x2                                 # 00411eb6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411eb9
    {load} mov ecx, eax                          # 00411ebb
    and ecx, 0x3                                 # 00411ebd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411ec0
    movsx ecx, word ptr [ebp + arg_c]            # 00411ec2
    imul ecx, ecx, 0x8d                          # 00411ec6
    mov byte ptr [ecx + 0x5bb625], 0x0           # 00411ecc
    movsx edx, word ptr [ebp + arg_c]            # 00411ed3
    imul edx, edx, 0x8d                          # 00411ed7
    mov byte ptr [edx + 0x5bb5e3], -0x28         # 00411edd
    movsx eax, word ptr [ebp + arg_c]            # 00411ee4
    imul eax, eax, 0x8d                          # 00411ee8
    mov byte ptr [eax + 0x5bb5e4], 0x1           # 00411eee
    movsx ecx, word ptr [ebp + arg_c]            # 00411ef5
    imul ecx, ecx, 0x8d                          # 00411ef9
    mov dword ptr [ecx + 0x5bb632], 0x0          # 00411eff
    mov edx, dword ptr [ebp - local_14]          # 00411f09
    mov dword ptr [ebp - local_24], edx          # 00411f0c
    mov eax, dword ptr [ebp - local_24]          # 00411f0f
    push eax                                     # 00411f12
    call FUN_0051dc6c                            # 00411f13
    add esp, 0x4                                 # 00411f18
    pop edi                                      # 00411f1b
    pop esi                                      # 00411f1c
    pop ebx                                      # 00411f1d
    {load} mov esp, ebp                          # 00411f1e
    pop ebp                                      # 00411f20
    ret 0xc                                      # 00411f21

