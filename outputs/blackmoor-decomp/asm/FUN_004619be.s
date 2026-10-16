# FUN_004619be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004619be
# extent:       0x004619be-0x00461d3b (893 code bytes)
# span:         0x004619be-0x00461d4b (code 893, tables 16, padding 0)
# sha256:       17463e0de44c4dd3e4459cb9eb6023564a4df4a641fa2021bf76aed69f60c2a9
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004619be
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_57, field_5b, field_5d; [ecx + n] field_22, field_24, field_59, field_5b, field_5d; [edx + n] field_39, field_57, field_5b, field_5d
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 228 instruction(s), 22 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_39, 0x39  # offset +0x39
.equ field_57, 0x57  # offset +0x57
.equ field_59, 0x59  # offset +0x59
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d

# --- external targets -----------------------------------------------

.org 0x004619be - 0x401000
.globl FUN_004619be
FUN_004619be:
    # block 0x004619be: entry, 21 instruction(s), ends with ja to 0x00461d11 (forward)
    push ebp                                     # 004619be
    {load} mov ebp, esp                          # 004619bf
    sub esp, 0x10                                # 004619c1
    mov dword ptr [ebp - local_c], ecx           # 004619c4
    mov eax, dword ptr [ebp - local_c]           # 004619c7
    movsx ecx, word ptr [eax + field_1e]         # 004619ca
    imul ecx, ecx, 0x8d                          # 004619ce
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004619d4
    mov dword ptr [ebp - local_8], edx           # 004619da
    mov dword ptr [ebp - local_4], 0x1           # 004619dd
    mov eax, dword ptr [ebp - local_c]           # 004619e4
    mov cx, word ptr [ebp + arg_8]               # 004619e7
    mov word ptr [eax + field_57], cx            # 004619eb
    mov edx, dword ptr [ebp - local_c]           # 004619ef
    movsx eax, word ptr [edx + field_57]         # 004619f2
    mov dword ptr [ebp - local_10], eax          # 004619f6
    mov ecx, dword ptr [ebp - local_10]          # 004619f9
    sub ecx, 0x10                                # 004619fc
    mov dword ptr [ebp - local_10], ecx          # 004619ff
    cmp dword ptr [ebp - local_10], 0x3          # 00461a02
    ja.d32 L_00461d11                            # 00461a06
    # block 0x00461a0c: entered by fall-through of ja at 0x00461a06, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x461d3b]
    mov edx, dword ptr [ebp - local_10]          # 00461a0c
    jmp dword ptr [4*edx + SWTAB_00461d3b_VA]    # 00461a0f
L_00461a16:
    # block 0x00461a16: entered by switch case, 4 instruction(s), ends with jne to 0x00461a2d (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461a16
    movsx ecx, word ptr [eax + field_5d]         # 00461a19
    test ecx, ecx                                # 00461a1d
    jne.d8 L_00461a2d                            # 00461a1f
    # block 0x00461a21: entered by fall-through of jne at 0x00461a1f, 2 instruction(s), ends with forward jump to 0x00461acc
    mov dword ptr [ebp - local_4], 0x0           # 00461a21
    jmp.d32 L_00461acc                           # 00461a28
L_00461a2d:
    # block 0x00461a2d: entered by jne at 0x00461a1f, 9 instruction(s), ends with je to 0x00461ac5 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461a2d
    movsx eax, word ptr [edx + field_5b]         # 00461a30
    imul eax, eax, 0x140                         # 00461a34
    mov ecx, dword ptr [ebp - local_c]           # 00461a3a
    movsx edx, word ptr [ecx + field_5d]         # 00461a3d
    imul edx, edx, 0x28                          # 00461a41
    movsx eax, word ptr [eax + edx + 0x594dd9]   # 00461a44
    cmp eax, 0x10                                # 00461a4c
    je.d8 L_00461ac5                             # 00461a4f
    # block 0x00461a51: entered by fall-through of je at 0x00461a4f, 10 instruction(s), ends with je to 0x00461ac5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00461a51
    movsx edx, word ptr [ecx + field_5b]         # 00461a54
    imul edx, edx, 0x140                         # 00461a58
    mov eax, dword ptr [ebp - local_c]           # 00461a5e
    movsx ecx, word ptr [eax + field_5d]         # 00461a61
    sub ecx, 0x1                                 # 00461a65
    imul ecx, ecx, 0x28                          # 00461a68
    movsx edx, word ptr [edx + ecx + 0x594dd9]   # 00461a6b
    cmp edx, 0x13                                # 00461a73
    je.d8 L_00461ac5                             # 00461a76
    # block 0x00461a78: entered by fall-through of je at 0x00461a76, 10 instruction(s), ends with jne to 0x00461ac5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461a78
    movsx ecx, word ptr [eax + field_5b]         # 00461a7b
    imul ecx, ecx, 0x140                         # 00461a7f
    mov edx, dword ptr [ebp - local_c]           # 00461a85
    movsx eax, word ptr [edx + field_5d]         # 00461a88
    sub eax, 0x1                                 # 00461a8c
    imul eax, eax, 0x28                          # 00461a8f
    movsx ecx, word ptr [ecx + eax + 0x594ddb]   # 00461a92
    test ecx, ecx                                # 00461a9a
    jne.d8 L_00461ac5                            # 00461a9c
    # block 0x00461a9e: entered by fall-through of jne at 0x00461a9c, 10 instruction(s), ends with jne to 0x00461acc (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461a9e
    movsx eax, word ptr [edx + field_5b]         # 00461aa1
    imul eax, eax, 0x140                         # 00461aa5
    mov ecx, dword ptr [ebp - local_c]           # 00461aab
    movsx edx, word ptr [ecx + field_5d]         # 00461aae
    sub edx, 0x1                                 # 00461ab2
    imul edx, edx, 0x28                          # 00461ab5
    movsx eax, word ptr [eax + edx + 0x594dd9]   # 00461ab8
    cmp eax, 0x14                                # 00461ac0
    jne.d8 L_00461acc                            # 00461ac3
L_00461ac5:
    # block 0x00461ac5: entered by je at 0x00461a4f; je at 0x00461a76; jne at 0x00461a9c; fall-through of jne at 0x00461ac3, 1 instruction(s), falls into the block at 0x00461acc
    mov dword ptr [ebp - local_4], 0x0           # 00461ac5
L_00461acc:
    # block 0x00461acc: entered by jmp at 0x00461a28; jne at 0x00461ac3, 1 instruction(s), ends with forward jump to 0x00461d11
    jmp.d32 L_00461d11                           # 00461acc
L_00461ad1:
    # block 0x00461ad1: entered by switch case, 4 instruction(s), ends with jne to 0x00461ae8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00461ad1
    movsx edx, word ptr [ecx + field_5b]         # 00461ad4
    test edx, edx                                # 00461ad8
    jne.d8 L_00461ae8                            # 00461ada
    # block 0x00461adc: entered by fall-through of jne at 0x00461ada, 2 instruction(s), ends with forward jump to 0x00461b87
    mov dword ptr [ebp - local_4], 0x0           # 00461adc
    jmp.d32 L_00461b87                           # 00461ae3
L_00461ae8:
    # block 0x00461ae8: entered by jne at 0x00461ada, 9 instruction(s), ends with je to 0x00461b80 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461ae8
    movsx ecx, word ptr [eax + field_5b]         # 00461aeb
    imul ecx, ecx, 0x140                         # 00461aef
    mov edx, dword ptr [ebp - local_c]           # 00461af5
    movsx eax, word ptr [edx + field_5d]         # 00461af8
    imul eax, eax, 0x28                          # 00461afc
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461aff
    cmp ecx, 0x11                                # 00461b07
    je.d8 L_00461b80                             # 00461b0a
    # block 0x00461b0c: entered by fall-through of je at 0x00461b0a, 10 instruction(s), ends with je to 0x00461b80 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461b0c
    movsx eax, word ptr [edx + field_5b]         # 00461b0f
    sub eax, 0x1                                 # 00461b13
    imul eax, eax, 0x140                         # 00461b16
    mov ecx, dword ptr [ebp - local_c]           # 00461b1c
    movsx edx, word ptr [ecx + field_5d]         # 00461b1f
    imul edx, edx, 0x28                          # 00461b23
    movsx eax, word ptr [eax + edx + 0x594dd9]   # 00461b26
    cmp eax, 0x12                                # 00461b2e
    je.d8 L_00461b80                             # 00461b31
    # block 0x00461b33: entered by fall-through of je at 0x00461b31, 10 instruction(s), ends with jne to 0x00461b80 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00461b33
    movsx edx, word ptr [ecx + field_5b]         # 00461b36
    sub edx, 0x1                                 # 00461b3a
    imul edx, edx, 0x140                         # 00461b3d
    mov eax, dword ptr [ebp - local_c]           # 00461b43
    movsx ecx, word ptr [eax + field_5d]         # 00461b46
    imul ecx, ecx, 0x28                          # 00461b4a
    movsx edx, word ptr [edx + ecx + 0x594ddb]   # 00461b4d
    test edx, edx                                # 00461b55
    jne.d8 L_00461b80                            # 00461b57
    # block 0x00461b59: entered by fall-through of jne at 0x00461b57, 10 instruction(s), ends with jne to 0x00461b87 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461b59
    movsx ecx, word ptr [eax + field_5b]         # 00461b5c
    sub ecx, 0x1                                 # 00461b60
    imul ecx, ecx, 0x140                         # 00461b63
    mov edx, dword ptr [ebp - local_c]           # 00461b69
    movsx eax, word ptr [edx + field_5d]         # 00461b6c
    imul eax, eax, 0x28                          # 00461b70
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461b73
    cmp ecx, 0x14                                # 00461b7b
    jne.d8 L_00461b87                            # 00461b7e
L_00461b80:
    # block 0x00461b80: entered by je at 0x00461b0a; je at 0x00461b31; jne at 0x00461b57; fall-through of jne at 0x00461b7e, 1 instruction(s), falls into the block at 0x00461b87
    mov dword ptr [ebp - local_4], 0x0           # 00461b80
L_00461b87:
    # block 0x00461b87: entered by jmp at 0x00461ae3; jne at 0x00461b7e, 1 instruction(s), ends with forward jump to 0x00461d11
    jmp.d32 L_00461d11                           # 00461b87
L_00461b8c:
    # block 0x00461b8c: entered by switch case, 7 instruction(s), ends with jne to 0x00461bad (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461b8c
    movsx eax, word ptr [edx + field_5b]         # 00461b8f
    mov ecx, dword ptr [ebp - local_8]           # 00461b93
    movsx edx, word ptr [ecx + field_22]         # 00461b96
    sub edx, 0x1                                 # 00461b9a
    {load} cmp eax, edx                          # 00461b9d
    jne.d8 L_00461bad                            # 00461b9f
    # block 0x00461ba1: entered by fall-through of jne at 0x00461b9f, 2 instruction(s), ends with forward jump to 0x00461c4c
    mov dword ptr [ebp - local_4], 0x0           # 00461ba1
    jmp.d32 L_00461c4c                           # 00461ba8
L_00461bad:
    # block 0x00461bad: entered by jne at 0x00461b9f, 9 instruction(s), ends with je to 0x00461c45 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461bad
    movsx ecx, word ptr [eax + field_5b]         # 00461bb0
    imul ecx, ecx, 0x140                         # 00461bb4
    mov edx, dword ptr [ebp - local_c]           # 00461bba
    movsx eax, word ptr [edx + field_5d]         # 00461bbd
    imul eax, eax, 0x28                          # 00461bc1
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461bc4
    cmp ecx, 0x12                                # 00461bcc
    je.d8 L_00461c45                             # 00461bcf
    # block 0x00461bd1: entered by fall-through of je at 0x00461bcf, 10 instruction(s), ends with je to 0x00461c45 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461bd1
    movsx eax, word ptr [edx + field_5b]         # 00461bd4
    add eax, 0x1                                 # 00461bd8
    imul eax, eax, 0x140                         # 00461bdb
    mov ecx, dword ptr [ebp - local_c]           # 00461be1
    movsx edx, word ptr [ecx + field_5d]         # 00461be4
    imul edx, edx, 0x28                          # 00461be8
    movsx eax, word ptr [eax + edx + 0x594dd9]   # 00461beb
    cmp eax, 0x11                                # 00461bf3
    je.d8 L_00461c45                             # 00461bf6
    # block 0x00461bf8: entered by fall-through of je at 0x00461bf6, 10 instruction(s), ends with jne to 0x00461c45 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00461bf8
    movsx edx, word ptr [ecx + field_5b]         # 00461bfb
    add edx, 0x1                                 # 00461bff
    imul edx, edx, 0x140                         # 00461c02
    mov eax, dword ptr [ebp - local_c]           # 00461c08
    movsx ecx, word ptr [eax + field_5d]         # 00461c0b
    imul ecx, ecx, 0x28                          # 00461c0f
    movsx edx, word ptr [edx + ecx + 0x594ddb]   # 00461c12
    test edx, edx                                # 00461c1a
    jne.d8 L_00461c45                            # 00461c1c
    # block 0x00461c1e: entered by fall-through of jne at 0x00461c1c, 10 instruction(s), ends with jne to 0x00461c4c (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461c1e
    movsx ecx, word ptr [eax + field_5b]         # 00461c21
    add ecx, 0x1                                 # 00461c25
    imul ecx, ecx, 0x140                         # 00461c28
    mov edx, dword ptr [ebp - local_c]           # 00461c2e
    movsx eax, word ptr [edx + field_5d]         # 00461c31
    imul eax, eax, 0x28                          # 00461c35
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461c38
    cmp ecx, 0x14                                # 00461c40
    jne.d8 L_00461c4c                            # 00461c43
L_00461c45:
    # block 0x00461c45: entered by je at 0x00461bcf; je at 0x00461bf6; jne at 0x00461c1c; fall-through of jne at 0x00461c43, 1 instruction(s), falls into the block at 0x00461c4c
    mov dword ptr [ebp - local_4], 0x0           # 00461c45
L_00461c4c:
    # block 0x00461c4c: entered by jmp at 0x00461ba8; jne at 0x00461c43, 1 instruction(s), ends with forward jump to 0x00461d11
    jmp.d32 L_00461d11                           # 00461c4c
L_00461c51:
    # block 0x00461c51: entered by switch case, 7 instruction(s), ends with jne to 0x00461c72 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461c51
    movsx eax, word ptr [edx + field_5d]         # 00461c54
    mov ecx, dword ptr [ebp - local_8]           # 00461c58
    movsx edx, word ptr [ecx + field_24]         # 00461c5b
    sub edx, 0x1                                 # 00461c5f
    {load} cmp eax, edx                          # 00461c62
    jne.d8 L_00461c72                            # 00461c64
    # block 0x00461c66: entered by fall-through of jne at 0x00461c64, 2 instruction(s), ends with forward jump to 0x00461d11
    mov dword ptr [ebp - local_4], 0x0           # 00461c66
    jmp.d32 L_00461d11                           # 00461c6d
L_00461c72:
    # block 0x00461c72: entered by jne at 0x00461c64, 9 instruction(s), ends with je to 0x00461d0a (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461c72
    movsx ecx, word ptr [eax + field_5b]         # 00461c75
    imul ecx, ecx, 0x140                         # 00461c79
    mov edx, dword ptr [ebp - local_c]           # 00461c7f
    movsx eax, word ptr [edx + field_5d]         # 00461c82
    imul eax, eax, 0x28                          # 00461c86
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461c89
    cmp ecx, 0x13                                # 00461c91
    je.d8 L_00461d0a                             # 00461c94
    # block 0x00461c96: entered by fall-through of je at 0x00461c94, 10 instruction(s), ends with je to 0x00461d0a (forward)
    mov edx, dword ptr [ebp - local_c]           # 00461c96
    movsx eax, word ptr [edx + field_5b]         # 00461c99
    imul eax, eax, 0x140                         # 00461c9d
    mov ecx, dword ptr [ebp - local_c]           # 00461ca3
    movsx edx, word ptr [ecx + field_5d]         # 00461ca6
    add edx, 0x1                                 # 00461caa
    imul edx, edx, 0x28                          # 00461cad
    movsx eax, word ptr [eax + edx + 0x594dd9]   # 00461cb0
    cmp eax, 0x10                                # 00461cb8
    je.d8 L_00461d0a                             # 00461cbb
    # block 0x00461cbd: entered by fall-through of je at 0x00461cbb, 10 instruction(s), ends with jne to 0x00461d0a (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00461cbd
    movsx edx, word ptr [ecx + field_5b]         # 00461cc0
    imul edx, edx, 0x140                         # 00461cc4
    mov eax, dword ptr [ebp - local_c]           # 00461cca
    movsx ecx, word ptr [eax + field_5d]         # 00461ccd
    add ecx, 0x1                                 # 00461cd1
    imul ecx, ecx, 0x28                          # 00461cd4
    movsx edx, word ptr [edx + ecx + 0x594ddb]   # 00461cd7
    test edx, edx                                # 00461cdf
    jne.d8 L_00461d0a                            # 00461ce1
    # block 0x00461ce3: entered by fall-through of jne at 0x00461ce1, 10 instruction(s), ends with jne to 0x00461d11 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00461ce3
    movsx ecx, word ptr [eax + field_5b]         # 00461ce6
    imul ecx, ecx, 0x140                         # 00461cea
    mov edx, dword ptr [ebp - local_c]           # 00461cf0
    movsx eax, word ptr [edx + field_5d]         # 00461cf3
    add eax, 0x1                                 # 00461cf7
    imul eax, eax, 0x28                          # 00461cfa
    movsx ecx, word ptr [ecx + eax + 0x594dd9]   # 00461cfd
    cmp ecx, 0x14                                # 00461d05
    jne.d8 L_00461d11                            # 00461d08
L_00461d0a:
    # block 0x00461d0a: entered by je at 0x00461c94; je at 0x00461cbb; jne at 0x00461ce1; fall-through of jne at 0x00461d08, 1 instruction(s), falls into the block at 0x00461d11
    mov dword ptr [ebp - local_4], 0x0           # 00461d0a
L_00461d11:
    # block 0x00461d11: entered by ja at 0x00461a06; jmp at 0x00461acc; jmp at 0x00461b87; jmp at 0x00461c4c; more, 2 instruction(s), ends with jne to 0x00461d32 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00461d11
    jne.d8 L_00461d32                            # 00461d15
    # block 0x00461d17: entered by fall-through of jne at 0x00461d15, 6 instruction(s), falls into the block at 0x00461d32
    mov edx, dword ptr [ebp - local_c]           # 00461d17
    mov word ptr [edx + field_39], 0x0           # 00461d1a
    mov eax, dword ptr [ebp - local_c]           # 00461d20
    mov word ptr [eax + field_57], 0x0           # 00461d23
    mov ecx, dword ptr [ebp - local_c]           # 00461d29
    mov word ptr [ecx + field_59], 0x0           # 00461d2c
L_00461d32:
    # block 0x00461d32: entered by jne at 0x00461d15, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00461d32
    {load} mov esp, ebp                          # 00461d35
    pop ebp                                      # 00461d37
    ret 0x4                                      # 00461d38

# --- data items (not part of the function) -------------------------
.org 0x00461d3b - 0x401000
SWTAB_00461d3b:  # 4 case address(es)
    .long L_00461a16 - .text + 0x401000
    .long L_00461ad1 - .text + 0x401000
    .long L_00461b8c - .text + 0x401000
    .long L_00461c51 - .text + 0x401000
.set SWTAB_00461d3b_VA, SWTAB_00461d3b - .text + 0x401000

