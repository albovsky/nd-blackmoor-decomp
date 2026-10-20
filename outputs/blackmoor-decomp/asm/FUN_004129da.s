# FUN_004129da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004129da
# extent:       0x004129da-0x00412cb9 (735 code bytes)
# span:         0x004129da-0x00412cb9 (code 735, tables 0, padding 0)
# sha256:       f9295070c1e9528fcaaebf31e52d0e4023033e4253cce2df8298d47da28b4d95
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004129da
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_1d, local_1e, local_24, local_28
# fields:       [eax + n] field_1; [edx + n] field_1
# callees:      calls FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 200 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_1d, 0x1d  # offset -0x1d
.equ local_1e, 0x1e  # offset -0x1e
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x004129da - 0x401000
.globl FUN_004129da
FUN_004129da:
    # block 0x004129da: entry, 17 instruction(s), ends with forward jump to 0x00412a20
    push ebp                                     # 004129da
    {load} mov ebp, esp                          # 004129db
    sub esp, 0x28                                # 004129dd
    push esi                                     # 004129e0
    push edi                                     # 004129e1
    mov dword ptr [ebp - local_14], ecx          # 004129e2
    movsx eax, word ptr [ebp + arg_8]            # 004129e5
    imul eax, eax, 0x8d                          # 004129e9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004129ef
    mov dword ptr [ebp - local_c], ecx           # 004129f5
    mov dword ptr [ebp - local_8], 0x0           # 004129f8
    mov edx, dword ptr [ebp - local_c]           # 004129ff
    movsx eax, word ptr [edx]                    # 00412a02
    sub eax, 0x3                                 # 00412a05
    mov word ptr [ebp - local_10], ax            # 00412a08
    mov word ptr [ebp - local_4], 0x0            # 00412a0c
    jmp.d8 L_00412a20                            # 00412a12
L_00412a14:
    # block 0x00412a14: entered by jmp at 0x00412c9f, 3 instruction(s), falls into the block at 0x00412a20
    mov cx, word ptr [ebp - local_4]             # 00412a14
    add cx, 0x1                                  # 00412a18
    mov word ptr [ebp - local_4], cx             # 00412a1c
L_00412a20:
    # block 0x00412a20: entered by jmp at 0x00412a12, 5 instruction(s), ends with jge to 0x00412ca4 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00412a20
    movsx eax, word ptr [ebp - local_10]         # 00412a24
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 00412a28
    {load} cmp edx, ecx                          # 00412a30
    jge.d32 L_00412ca4                           # 00412a32
    # block 0x00412a38: entered by fall-through of jge at 0x00412a32, 9 instruction(s), falls into the block at 0x00412a5c
    mov edx, dword ptr [ebp - local_c]           # 00412a38
    add edx, 0x2                                 # 00412a3b
    mov dword ptr [ebp - local_18], edx          # 00412a3e
    movsx eax, word ptr [ebp - local_10]         # 00412a41
    imul eax, eax, 0x3390                        # 00412a45
    movsx ecx, word ptr [ebp - local_4]          # 00412a4b
    imul ecx, ecx, 0x21                          # 00412a4f
    lea edx, [eax + ecx + 0x5957cb]              # 00412a52
    mov dword ptr [ebp - local_1c], edx          # 00412a59
L_00412a5c:
    # block 0x00412a5c: entered by jne at 0x00412a8e, 6 instruction(s), ends with jne to 0x00412a99 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00412a5c
    mov cl, byte ptr [eax]                       # 00412a5f
    mov byte ptr [ebp - local_1d], cl            # 00412a61
    mov edx, dword ptr [ebp - local_18]          # 00412a64
    cmp cl, byte ptr [edx]                       # 00412a67
    jne.d8 L_00412a99                            # 00412a69
    # block 0x00412a6b: entered by fall-through of jne at 0x00412a69, 2 instruction(s), ends with je to 0x00412a90 (forward)
    cmp byte ptr [ebp - local_1d], 0x0           # 00412a6b
    je.d8 L_00412a90                             # 00412a6f
    # block 0x00412a71: entered by fall-through of je at 0x00412a6f, 6 instruction(s), ends with jne to 0x00412a99 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00412a71
    mov cl, byte ptr [eax + field_1]             # 00412a74
    mov byte ptr [ebp - local_1e], cl            # 00412a77
    mov edx, dword ptr [ebp - local_18]          # 00412a7a
    cmp cl, byte ptr [edx + field_1]             # 00412a7d
    jne.d8 L_00412a99                            # 00412a80
    # block 0x00412a82: entered by fall-through of jne at 0x00412a80, 4 instruction(s), ends with jne to 0x00412a5c (backward)
    add dword ptr [ebp - local_1c], 0x2          # 00412a82
    add dword ptr [ebp - local_18], 0x2          # 00412a86
    cmp byte ptr [ebp - local_1e], 0x0           # 00412a8a
    jne.d8 L_00412a5c                            # 00412a8e
L_00412a90:
    # block 0x00412a90: entered by je at 0x00412a6f; fall-through of jne at 0x00412a8e, 2 instruction(s), ends with forward jump to 0x00412aa1
    mov dword ptr [ebp - local_24], 0x0          # 00412a90
    jmp.d8 L_00412aa1                            # 00412a97
L_00412a99:
    # block 0x00412a99: entered by jne at 0x00412a69; jne at 0x00412a80, 3 instruction(s), falls into the block at 0x00412aa1
    {load} sbb eax, eax                          # 00412a99
    sbb eax, -0x1                                # 00412a9b
    mov dword ptr [ebp - local_24], eax          # 00412a9e
L_00412aa1:
    # block 0x00412aa1: entered by jmp at 0x00412a97, 4 instruction(s), ends with jne to 0x00412bb7 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00412aa1
    mov dword ptr [ebp - local_28], ecx          # 00412aa4
    cmp dword ptr [ebp - local_28], 0x0          # 00412aa7
    jne.d32 L_00412bb7                           # 00412aab
    # block 0x00412ab1: entered by fall-through of jne at 0x00412aab, 3 instruction(s), ends with jne to 0x00412b11 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00412ab1
    cmp edx, 0x190                               # 00412ab5
    jne.d8 L_00412b11                            # 00412abb
    # block 0x00412abd: entered by fall-through of jne at 0x00412abb, 24 instruction(s), ends with forward jump to 0x00412b8f
    mov edi, 0x56913c                            # 00412abd
    movsx eax, word ptr [ebp - local_10]         # 00412ac2
    imul eax, eax, 0x3390                        # 00412ac6
    movsx ecx, word ptr [ebp - local_4]          # 00412acc
    imul ecx, ecx, 0x21                          # 00412ad0
    lea edx, [eax + ecx + 0x5957cb]              # 00412ad3
    or ecx, -0x1                                 # 00412ada
    {load} xor eax, eax                          # 00412add
    repne scasb al, byte ptr es:[edi]            # 00412adf
    not ecx                                      # 00412ae1
    {load} sub edi, ecx                          # 00412ae3
    {load} mov esi, edi                          # 00412ae5
    {load} mov eax, ecx                          # 00412ae7
    {load} mov edi, edx                          # 00412ae9
    shr ecx, 0x2                                 # 00412aeb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412aee
    {load} mov ecx, eax                          # 00412af0
    and ecx, 0x3                                 # 00412af2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412af5
    movsx ecx, word ptr [ebp - local_10]         # 00412af7
    imul ecx, ecx, 0x320                         # 00412afb
    movsx edx, word ptr [ebp - local_4]          # 00412b01
    mov word ptr [ecx + 2*edx + 0x59f27b], 0x0   # 00412b05
    jmp.d8 L_00412b8f                            # 00412b0f
L_00412b11:
    # block 0x00412b11: entered by jne at 0x00412abb, 33 instruction(s), falls into the block at 0x00412b8f
    movsx eax, word ptr [ebp - local_10]         # 00412b11
    imul eax, eax, 0x3390                        # 00412b15
    movsx ecx, word ptr [ebp - local_4]          # 00412b1b
    add ecx, 0x1                                 # 00412b1f
    imul ecx, ecx, 0x21                          # 00412b22
    lea edx, [eax + ecx + 0x5957cb]              # 00412b25
    {load} mov edi, edx                          # 00412b2c
    movsx eax, word ptr [ebp - local_10]         # 00412b2e
    imul eax, eax, 0x3390                        # 00412b32
    movsx ecx, word ptr [ebp - local_4]          # 00412b38
    imul ecx, ecx, 0x21                          # 00412b3c
    lea edx, [eax + ecx + 0x5957cb]              # 00412b3f
    or ecx, -0x1                                 # 00412b46
    {load} xor eax, eax                          # 00412b49
    repne scasb al, byte ptr es:[edi]            # 00412b4b
    not ecx                                      # 00412b4d
    {load} sub edi, ecx                          # 00412b4f
    {load} mov esi, edi                          # 00412b51
    {load} mov eax, ecx                          # 00412b53
    {load} mov edi, edx                          # 00412b55
    shr ecx, 0x2                                 # 00412b57
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412b5a
    {load} mov ecx, eax                          # 00412b5c
    and ecx, 0x3                                 # 00412b5e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412b61
    movsx ecx, word ptr [ebp - local_10]         # 00412b63
    imul ecx, ecx, 0x320                         # 00412b67
    movsx edx, word ptr [ebp - local_4]          # 00412b6d
    movsx eax, word ptr [ebp - local_10]         # 00412b71
    imul eax, eax, 0x320                         # 00412b75
    movsx esi, word ptr [ebp - local_4]          # 00412b7b
    mov cx, word ptr [ecx + 2*edx + 0x59f27d]    # 00412b7f
    mov word ptr [eax + 2*esi + 0x59f27b], cx    # 00412b87
L_00412b8f:
    # block 0x00412b8f: entered by jmp at 0x00412b0f, 7 instruction(s), ends with forward jump to 0x00412c9f
    movsx edx, word ptr [ebp - local_10]         # 00412b8f
    mov ax, word ptr [2*edx + 0x59fbdb]          # 00412b93
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00412b9b
    movsx ecx, word ptr [ebp - local_10]         # 00412b9f
    mov word ptr [2*ecx + 0x59fbdb], ax          # 00412ba3
    mov dword ptr [ebp - local_8], 0x1           # 00412bab
    jmp.d32 L_00412c9f                           # 00412bb2
L_00412bb7:
    # block 0x00412bb7: entered by jne at 0x00412aab, 2 instruction(s), ends with je to 0x00412c9f (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00412bb7
    je.d32 L_00412c9f                            # 00412bbb
    # block 0x00412bc1: entered by fall-through of je at 0x00412bbb, 3 instruction(s), ends with jne to 0x00412c21 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00412bc1
    cmp edx, 0x190                               # 00412bc5
    jne.d8 L_00412c21                            # 00412bcb
    # block 0x00412bcd: entered by fall-through of jne at 0x00412bcb, 24 instruction(s), ends with forward jump to 0x00412c9f
    mov edi, 0x569140                            # 00412bcd
    movsx eax, word ptr [ebp - local_10]         # 00412bd2
    imul eax, eax, 0x3390                        # 00412bd6
    movsx ecx, word ptr [ebp - local_4]          # 00412bdc
    imul ecx, ecx, 0x21                          # 00412be0
    lea edx, [eax + ecx + 0x5957cb]              # 00412be3
    or ecx, -0x1                                 # 00412bea
    {load} xor eax, eax                          # 00412bed
    repne scasb al, byte ptr es:[edi]            # 00412bef
    not ecx                                      # 00412bf1
    {load} sub edi, ecx                          # 00412bf3
    {load} mov esi, edi                          # 00412bf5
    {load} mov eax, ecx                          # 00412bf7
    {load} mov edi, edx                          # 00412bf9
    shr ecx, 0x2                                 # 00412bfb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412bfe
    {load} mov ecx, eax                          # 00412c00
    and ecx, 0x3                                 # 00412c02
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412c05
    movsx ecx, word ptr [ebp - local_10]         # 00412c07
    imul ecx, ecx, 0x320                         # 00412c0b
    movsx edx, word ptr [ebp - local_4]          # 00412c11
    mov word ptr [ecx + 2*edx + 0x59f27b], 0x0   # 00412c15
    jmp.d8 L_00412c9f                            # 00412c1f
L_00412c21:
    # block 0x00412c21: entered by jne at 0x00412bcb, 33 instruction(s), falls into the block at 0x00412c9f
    movsx eax, word ptr [ebp - local_10]         # 00412c21
    imul eax, eax, 0x3390                        # 00412c25
    movsx ecx, word ptr [ebp - local_4]          # 00412c2b
    add ecx, 0x1                                 # 00412c2f
    imul ecx, ecx, 0x21                          # 00412c32
    lea edx, [eax + ecx + 0x5957cb]              # 00412c35
    {load} mov edi, edx                          # 00412c3c
    movsx eax, word ptr [ebp - local_10]         # 00412c3e
    imul eax, eax, 0x3390                        # 00412c42
    movsx ecx, word ptr [ebp - local_4]          # 00412c48
    imul ecx, ecx, 0x21                          # 00412c4c
    lea edx, [eax + ecx + 0x5957cb]              # 00412c4f
    or ecx, -0x1                                 # 00412c56
    {load} xor eax, eax                          # 00412c59
    repne scasb al, byte ptr es:[edi]            # 00412c5b
    not ecx                                      # 00412c5d
    {load} sub edi, ecx                          # 00412c5f
    {load} mov esi, edi                          # 00412c61
    {load} mov eax, ecx                          # 00412c63
    {load} mov edi, edx                          # 00412c65
    shr ecx, 0x2                                 # 00412c67
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412c6a
    {load} mov ecx, eax                          # 00412c6c
    and ecx, 0x3                                 # 00412c6e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412c71
    movsx ecx, word ptr [ebp - local_10]         # 00412c73
    imul ecx, ecx, 0x320                         # 00412c77
    movsx edx, word ptr [ebp - local_4]          # 00412c7d
    movsx eax, word ptr [ebp - local_10]         # 00412c81
    imul eax, eax, 0x320                         # 00412c85
    movsx esi, word ptr [ebp - local_4]          # 00412c8b
    mov cx, word ptr [ecx + 2*edx + 0x59f27d]    # 00412c8f
    mov word ptr [eax + 2*esi + 0x59f27b], cx    # 00412c97
L_00412c9f:
    # block 0x00412c9f: entered by jmp at 0x00412bb2; je at 0x00412bbb; jmp at 0x00412c1f, 1 instruction(s), ends with backward jump to 0x00412a14
    jmp.d32 L_00412a14                           # 00412c9f
L_00412ca4:
    # block 0x00412ca4: entered by jge at 0x00412a32, 9 instruction(s), calls FUN_0042ba3a, ends with ret 0x4
    mov dx, word ptr [ebp + arg_8]               # 00412ca4
    push edx                                     # 00412ca8
    call FUN_0042ba3a                            # 00412ca9
    add esp, 0x4                                 # 00412cae
    pop edi                                      # 00412cb1
    pop esi                                      # 00412cb2
    {load} mov esp, ebp                          # 00412cb3
    pop ebp                                      # 00412cb5
    ret 0x4                                      # 00412cb6

