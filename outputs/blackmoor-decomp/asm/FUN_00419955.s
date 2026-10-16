# FUN_00419955
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00419955
# extent:       0x00419955-0x00419dab (1110 code bytes)
# span:         0x00419955-0x00419dab (code 1110, tables 0, padding 0)
# sha256:       b9cc554f015e26aced1920f1728388c270c90ad32fb5489db2f2bea1b579a6e8
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00419955
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_23, field_51, field_59, field_571, field_577, field_57f, field_5c0, field_845; [ecx + n] field_51, field_59, field_5d, field_571, field_577; [edx + n] field_51, field_59, field_571, field_577, field_57b
# callees:      calls FUN_0041a216, FUN_0050ca3e, FUN_0052139c, FUN_0051dc43, FUN_0050ce2b, FUN_0050cf61, FUN_0041b6e2, FUN_004c7314, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 319 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_23, 0x23  # offset +0x23
.equ field_51, 0x51  # offset +0x51
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_571, 0x571  # offset +0x571
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_845, 0x845  # offset +0x845

# --- external targets -----------------------------------------------
.set FUN_0041a216, .text + (0x0041a216 - 0x401000)
.set FUN_0041b6e2, .text + (0x0041b6e2 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00419955 - 0x401000
.globl FUN_00419955
FUN_00419955:
    # block 0x00419955: entry, 16 instruction(s), calls FUN_0041a216, ends with jne to 0x004199c3 (forward)
    push ebp                                     # 00419955
    {load} mov ebp, esp                          # 00419956
    sub esp, 0x2c                                # 00419958
    mov dword ptr [ebp - local_28], ecx          # 0041995b
    mov dword ptr [ebp - local_8], 0x0           # 0041995e
    mov dword ptr [ebp - local_4], 0x0           # 00419965
    mov eax, dword ptr [ebp + arg_8]             # 0041996c
    push eax                                     # 0041996f
    mov ecx, dword ptr [ebp - local_28]          # 00419970
    call FUN_0041a216                            # 00419973
    mov ecx, dword ptr [ebp - local_28]          # 00419978
    mov word ptr [ecx + field_571], ax           # 0041997b
    mov edx, dword ptr [ebp - local_28]          # 00419982
    movsx eax, word ptr [edx + field_571]        # 00419985
    cmp eax, -0x1                                # 0041998c
    jne.d8 L_004199c3                            # 0041998f
    # block 0x00419991: entered by fall-through of jne at 0x0041998f, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419da3
    mov ecx, dword ptr [ebp + arg_8]             # 00419991
    push ecx                                     # 00419994
    push 0x542de4                                # 00419995
    mov edx, dword ptr [ebp - local_28]          # 0041999a
    add edx, 0x31f                               # 0041999d
    push edx                                     # 004199a3
    call FUN_0050ca3e                            # 004199a4
    add esp, 0xc                                 # 004199a9
    push 0x0                                     # 004199ac
    push 0x0                                     # 004199ae
    mov eax, dword ptr [ebp - local_28]          # 004199b0
    add eax, 0x31f                               # 004199b3
    push eax                                     # 004199b8
    call FUN_0052139c                            # 004199b9
    jmp.d32 L_00419da3                           # 004199be
L_004199c3:
    # block 0x004199c3: entered by jne at 0x0041998f, 22 instruction(s), ends with je to 0x00419a35 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004199c3
    movsx edx, word ptr [ecx + field_571]        # 004199c6
    imul edx, edx, 0x84d                         # 004199cd
    mov eax, dword ptr [ebp - local_28]          # 004199d3
    lea ecx, [eax + edx + field_57f]             # 004199d6
    mov edx, dword ptr [ebp - local_28]          # 004199dd
    mov dword ptr [edx + field_57b], ecx         # 004199e0
    mov eax, dword ptr [ebp - local_28]          # 004199e6
    movsx ecx, word ptr [eax + field_571]        # 004199e9
    imul ecx, ecx, 0x84d                         # 004199f0
    mov edx, dword ptr [ebp - local_28]          # 004199f6
    mov eax, dword ptr [ebp - local_28]          # 004199f9
    mov ecx, dword ptr [eax + ecx + field_5c0]   # 004199fc
    mov dword ptr [edx + field_577], ecx         # 00419a03
    movsx edx, word ptr [ebp + arg_c]            # 00419a09
    imul edx, edx, 0x5e                          # 00419a0d
    mov eax, dword ptr [ebp - local_28]          # 00419a10
    mov ecx, dword ptr [eax + field_577]         # 00419a13
    mov dl, byte ptr [ecx + edx + field_5d]      # 00419a19
    mov byte ptr [ebp - local_2c], dl            # 00419a1d
    cmp byte ptr [ebp - local_2c], 0x2           # 00419a20
    je.d8 L_00419a35                             # 00419a24
    # block 0x00419a26: entered by fall-through of je at 0x00419a24, 2 instruction(s), ends with je to 0x00419bc4 (forward)
    cmp byte ptr [ebp - local_2c], 0x3           # 00419a26
    je.d32 L_00419bc4                            # 00419a2a
    # block 0x00419a30: entered by fall-through of je at 0x00419a2a, 1 instruction(s), ends with forward jump to 0x00419d2d
    jmp.d32 L_00419d2d                           # 00419a30
L_00419a35:
    # block 0x00419a35: entered by je at 0x00419a24, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00419a74 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00419a35
    imul eax, eax, 0x5e                          # 00419a39
    mov ecx, dword ptr [ebp - local_28]          # 00419a3c
    mov edx, dword ptr [ecx + field_577]         # 00419a3f
    mov eax, dword ptr [edx + eax + field_59]    # 00419a45
    push eax                                     # 00419a49
    call FUN_0051dc43                            # 00419a4a
    add esp, 0x4                                 # 00419a4f
    mov dword ptr [ebp - local_c], eax           # 00419a52
    mov ecx, dword ptr [ebp - local_c]           # 00419a55
    mov dword ptr [ebp - local_4], ecx           # 00419a58
    cmp dword ptr [ebp - local_4], 0x0           # 00419a5b
    jne.d8 L_00419a74                            # 00419a5f
    # block 0x00419a61: entered by fall-through of jne at 0x00419a5f, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419da1
    push 0x0                                     # 00419a61
    push 0x0                                     # 00419a63
    push 0x542e20                                # 00419a65
    call FUN_0052139c                            # 00419a6a
    jmp.d32 L_00419da1                           # 00419a6f
L_00419a74:
    # block 0x00419a74: entered by jne at 0x00419a5f, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00419ab3 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00419a74
    imul edx, edx, 0x5e                          # 00419a78
    mov eax, dword ptr [ebp - local_28]          # 00419a7b
    mov ecx, dword ptr [eax + field_577]         # 00419a7e
    mov edx, dword ptr [ecx + edx + field_51]    # 00419a84
    push edx                                     # 00419a88
    call FUN_0051dc43                            # 00419a89
    add esp, 0x4                                 # 00419a8e
    mov dword ptr [ebp - local_10], eax          # 00419a91
    mov eax, dword ptr [ebp - local_10]          # 00419a94
    mov dword ptr [ebp - local_8], eax           # 00419a97
    cmp dword ptr [ebp - local_8], 0x0           # 00419a9a
    jne.d8 L_00419ab3                            # 00419a9e
    # block 0x00419aa0: entered by fall-through of jne at 0x00419a9e, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419d9f
    push 0x0                                     # 00419aa0
    push 0x0                                     # 00419aa2
    push 0x542e54                                # 00419aa4
    call FUN_0052139c                            # 00419aa9
    jmp.d32 L_00419d9f                           # 00419aae
L_00419ab3:
    # block 0x00419ab3: entered by jne at 0x00419a9e, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00419b5c (forward)
    push 0x0                                     # 00419ab3
    movsx ecx, word ptr [ebp + arg_c]            # 00419ab5
    imul ecx, ecx, 0x5e                          # 00419ab9
    mov edx, dword ptr [ebp - local_28]          # 00419abc
    mov eax, dword ptr [edx + field_577]         # 00419abf
    mov ecx, dword ptr [eax + ecx + field_23]    # 00419ac5
    push ecx                                     # 00419ac9
    mov edx, dword ptr [ebp - local_28]          # 00419aca
    mov eax, dword ptr [edx + field_57b]         # 00419acd
    mov ecx, dword ptr [eax + field_845]         # 00419ad3
    push ecx                                     # 00419ad9
    call FUN_0050ce2b                            # 00419ada
    add esp, 0xc                                 # 00419adf
    mov edx, dword ptr [ebp - local_28]          # 00419ae2
    mov eax, dword ptr [edx + field_57b]         # 00419ae5
    mov ecx, dword ptr [eax + field_845]         # 00419aeb
    push ecx                                     # 00419af1
    push 0x1                                     # 00419af2
    movsx edx, word ptr [ebp + arg_c]            # 00419af4
    imul edx, edx, 0x5e                          # 00419af8
    mov eax, dword ptr [ebp - local_28]          # 00419afb
    mov ecx, dword ptr [eax + field_577]         # 00419afe
    mov edx, dword ptr [ecx + edx + field_59]    # 00419b04
    push edx                                     # 00419b08
    mov eax, dword ptr [ebp - local_4]           # 00419b09
    push eax                                     # 00419b0c
    call FUN_0050cf61                            # 00419b0d
    add esp, 0x10                                # 00419b12
    cmp eax, 0x1                                 # 00419b15
    je.d8 L_00419b5c                             # 00419b18
    # block 0x00419b1a: entered by fall-through of je at 0x00419b18, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419d9d
    movsx ecx, word ptr [ebp + arg_c]            # 00419b1a
    imul ecx, ecx, 0x5e                          # 00419b1e
    mov edx, dword ptr [ebp - local_28]          # 00419b21
    mov eax, dword ptr [edx + field_577]         # 00419b24
    {load} add eax, ecx                          # 00419b2a
    push eax                                     # 00419b2c
    push 0x542e84                                # 00419b2d
    mov ecx, dword ptr [ebp - local_28]          # 00419b32
    add ecx, 0x31f                               # 00419b35
    push ecx                                     # 00419b3b
    call FUN_0050ca3e                            # 00419b3c
    add esp, 0xc                                 # 00419b41
    push 0x0                                     # 00419b44
    push 0x0                                     # 00419b46
    mov edx, dword ptr [ebp - local_28]          # 00419b48
    add edx, 0x31f                               # 00419b4b
    push edx                                     # 00419b51
    call FUN_0052139c                            # 00419b52
    jmp.d32 L_00419d9d                           # 00419b57
L_00419b5c:
    # block 0x00419b5c: entered by je at 0x00419b18, 30 instruction(s), calls FUN_0041b6e2, FUN_004c7314, ends with forward jump to 0x00419d9b
    movsx eax, word ptr [ebp + arg_c]            # 00419b5c
    imul eax, eax, 0x5e                          # 00419b60
    mov ecx, dword ptr [ebp - local_28]          # 00419b63
    mov edx, dword ptr [ecx + field_577]         # 00419b66
    mov eax, dword ptr [edx + eax + field_51]    # 00419b6c
    push eax                                     # 00419b70
    movsx ecx, word ptr [ebp + arg_c]            # 00419b71
    imul ecx, ecx, 0x5e                          # 00419b75
    mov edx, dword ptr [ebp - local_28]          # 00419b78
    mov eax, dword ptr [edx + field_577]         # 00419b7b
    mov ecx, dword ptr [eax + ecx + field_59]    # 00419b81
    push ecx                                     # 00419b85
    mov edx, dword ptr [ebp - local_8]           # 00419b86
    push edx                                     # 00419b89
    mov eax, dword ptr [ebp - local_4]           # 00419b8a
    push eax                                     # 00419b8d
    mov ecx, dword ptr [ebp - local_28]          # 00419b8e
    add ecx, 0x51f                               # 00419b91
    call FUN_0041b6e2                            # 00419b97
    movsx ecx, word ptr [ebp + arg_c]            # 00419b9c
    imul ecx, ecx, 0x5e                          # 00419ba0
    mov edx, dword ptr [ebp - local_28]          # 00419ba3
    mov eax, dword ptr [edx + field_577]         # 00419ba6
    mov ecx, dword ptr [eax + ecx + field_51]    # 00419bac
    push ecx                                     # 00419bb0
    mov edx, dword ptr [ebp - local_8]           # 00419bb1
    push edx                                     # 00419bb4
    mov ecx, 0x5cf659                            # 00419bb5
    call FUN_004c7314                            # 00419bba
    jmp.d32 L_00419d9b                           # 00419bbf
L_00419bc4:
    # block 0x00419bc4: entered by je at 0x00419a2a, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00419c03 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00419bc4
    imul eax, eax, 0x5e                          # 00419bc8
    mov ecx, dword ptr [ebp - local_28]          # 00419bcb
    mov edx, dword ptr [ecx + field_577]         # 00419bce
    mov eax, dword ptr [edx + eax + field_59]    # 00419bd4
    push eax                                     # 00419bd8
    call FUN_0051dc43                            # 00419bd9
    add esp, 0x4                                 # 00419bde
    mov dword ptr [ebp - local_14], eax          # 00419be1
    mov ecx, dword ptr [ebp - local_14]          # 00419be4
    mov dword ptr [ebp - local_4], ecx           # 00419be7
    cmp dword ptr [ebp - local_4], 0x0           # 00419bea
    jne.d8 L_00419c03                            # 00419bee
    # block 0x00419bf0: entered by fall-through of jne at 0x00419bee, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419d99
    push 0x0                                     # 00419bf0
    push 0x0                                     # 00419bf2
    push 0x542ea8                                # 00419bf4
    call FUN_0052139c                            # 00419bf9
    jmp.d32 L_00419d99                           # 00419bfe
L_00419c03:
    # block 0x00419c03: entered by jne at 0x00419bee, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00419c42 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00419c03
    imul edx, edx, 0x5e                          # 00419c07
    mov eax, dword ptr [ebp - local_28]          # 00419c0a
    mov ecx, dword ptr [eax + field_577]         # 00419c0d
    mov edx, dword ptr [ecx + edx + field_51]    # 00419c13
    push edx                                     # 00419c17
    call FUN_0051dc43                            # 00419c18
    add esp, 0x4                                 # 00419c1d
    mov dword ptr [ebp - local_18], eax          # 00419c20
    mov eax, dword ptr [ebp - local_18]          # 00419c23
    mov dword ptr [ebp - local_8], eax           # 00419c26
    cmp dword ptr [ebp - local_8], 0x0           # 00419c29
    jne.d8 L_00419c42                            # 00419c2d
    # block 0x00419c2f: entered by fall-through of jne at 0x00419c2d, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419d97
    push 0x0                                     # 00419c2f
    push 0x0                                     # 00419c31
    push 0x542edc                                # 00419c33
    call FUN_0052139c                            # 00419c38
    jmp.d32 L_00419d97                           # 00419c3d
L_00419c42:
    # block 0x00419c42: entered by jne at 0x00419c2d, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00419ceb (forward)
    push 0x0                                     # 00419c42
    movsx ecx, word ptr [ebp + arg_c]            # 00419c44
    imul ecx, ecx, 0x5e                          # 00419c48
    mov edx, dword ptr [ebp - local_28]          # 00419c4b
    mov eax, dword ptr [edx + field_577]         # 00419c4e
    mov ecx, dword ptr [eax + ecx + field_23]    # 00419c54
    push ecx                                     # 00419c58
    mov edx, dword ptr [ebp - local_28]          # 00419c59
    mov eax, dword ptr [edx + field_57b]         # 00419c5c
    mov ecx, dword ptr [eax + field_845]         # 00419c62
    push ecx                                     # 00419c68
    call FUN_0050ce2b                            # 00419c69
    add esp, 0xc                                 # 00419c6e
    mov edx, dword ptr [ebp - local_28]          # 00419c71
    mov eax, dword ptr [edx + field_57b]         # 00419c74
    mov ecx, dword ptr [eax + field_845]         # 00419c7a
    push ecx                                     # 00419c80
    push 0x1                                     # 00419c81
    movsx edx, word ptr [ebp + arg_c]            # 00419c83
    imul edx, edx, 0x5e                          # 00419c87
    mov eax, dword ptr [ebp - local_28]          # 00419c8a
    mov ecx, dword ptr [eax + field_577]         # 00419c8d
    mov edx, dword ptr [ecx + edx + field_59]    # 00419c93
    push edx                                     # 00419c97
    mov eax, dword ptr [ebp - local_4]           # 00419c98
    push eax                                     # 00419c9b
    call FUN_0050cf61                            # 00419c9c
    add esp, 0x10                                # 00419ca1
    cmp eax, 0x1                                 # 00419ca4
    je.d8 L_00419ceb                             # 00419ca7
    # block 0x00419ca9: entered by fall-through of je at 0x00419ca7, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419d95
    movsx ecx, word ptr [ebp + arg_c]            # 00419ca9
    imul ecx, ecx, 0x5e                          # 00419cad
    mov edx, dword ptr [ebp - local_28]          # 00419cb0
    mov eax, dword ptr [edx + field_577]         # 00419cb3
    {load} add eax, ecx                          # 00419cb9
    push eax                                     # 00419cbb
    push 0x542f0c                                # 00419cbc
    mov ecx, dword ptr [ebp - local_28]          # 00419cc1
    add ecx, 0x31f                               # 00419cc4
    push ecx                                     # 00419cca
    call FUN_0050ca3e                            # 00419ccb
    add esp, 0xc                                 # 00419cd0
    push 0x0                                     # 00419cd3
    push 0x0                                     # 00419cd5
    mov edx, dword ptr [ebp - local_28]          # 00419cd7
    add edx, 0x31f                               # 00419cda
    push edx                                     # 00419ce0
    call FUN_0052139c                            # 00419ce1
    jmp.d32 L_00419d95                           # 00419ce6
L_00419ceb:
    # block 0x00419ceb: entered by je at 0x00419ca7, 20 instruction(s), calls FUN_0041b6e2, ends with forward jump to 0x00419d93
    movsx eax, word ptr [ebp + arg_c]            # 00419ceb
    imul eax, eax, 0x5e                          # 00419cef
    mov ecx, dword ptr [ebp - local_28]          # 00419cf2
    mov edx, dword ptr [ecx + field_577]         # 00419cf5
    mov eax, dword ptr [edx + eax + field_51]    # 00419cfb
    push eax                                     # 00419cff
    movsx ecx, word ptr [ebp + arg_c]            # 00419d00
    imul ecx, ecx, 0x5e                          # 00419d04
    mov edx, dword ptr [ebp - local_28]          # 00419d07
    mov eax, dword ptr [edx + field_577]         # 00419d0a
    mov ecx, dword ptr [eax + ecx + field_59]    # 00419d10
    push ecx                                     # 00419d14
    mov edx, dword ptr [ebp - local_8]           # 00419d15
    push edx                                     # 00419d18
    mov eax, dword ptr [ebp - local_4]           # 00419d19
    push eax                                     # 00419d1c
    mov ecx, dword ptr [ebp - local_28]          # 00419d1d
    add ecx, 0x51f                               # 00419d20
    call FUN_0041b6e2                            # 00419d26
    jmp.d8 L_00419d93                            # 00419d2b
L_00419d2d:
    # block 0x00419d2d: entered by jmp at 0x00419a30; jmp at 0x00419d93; jmp at 0x00419d9b, 2 instruction(s), ends with je to 0x00419d4c (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00419d2d
    je.d8 L_00419d4c                             # 00419d31
    # block 0x00419d33: entered by fall-through of je at 0x00419d31, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00419d4c
    mov ecx, dword ptr [ebp - local_4]           # 00419d33
    mov dword ptr [ebp - local_1c], ecx          # 00419d36
    mov edx, dword ptr [ebp - local_1c]          # 00419d39
    push edx                                     # 00419d3c
    call FUN_0051dc6c                            # 00419d3d
    add esp, 0x4                                 # 00419d42
    mov dword ptr [ebp - local_4], 0x0           # 00419d45
L_00419d4c:
    # block 0x00419d4c: entered by je at 0x00419d31, 2 instruction(s), ends with forward jump to 0x00419da5
    mov eax, dword ptr [ebp - local_8]           # 00419d4c
    jmp.d8 L_00419da5                            # 00419d4f
L_00419d51:
    # block 0x00419d51: entered by jmp at 0x00419d95; jmp at 0x00419d97; jmp at 0x00419d99; jmp at 0x00419d9d; more, 2 instruction(s), ends with je to 0x00419d70 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00419d51
    je.d8 L_00419d70                             # 00419d55
    # block 0x00419d57: entered by fall-through of je at 0x00419d55, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00419d70
    mov eax, dword ptr [ebp - local_8]           # 00419d57
    mov dword ptr [ebp - local_20], eax          # 00419d5a
    mov ecx, dword ptr [ebp - local_20]          # 00419d5d
    push ecx                                     # 00419d60
    call FUN_0051dc6c                            # 00419d61
    add esp, 0x4                                 # 00419d66
    mov dword ptr [ebp - local_8], 0x0           # 00419d69
L_00419d70:
    # block 0x00419d70: entered by je at 0x00419d55, 2 instruction(s), ends with je to 0x00419d8f (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00419d70
    je.d8 L_00419d8f                             # 00419d74
    # block 0x00419d76: entered by fall-through of je at 0x00419d74, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00419d8f
    mov edx, dword ptr [ebp - local_4]           # 00419d76
    mov dword ptr [ebp - local_24], edx          # 00419d79
    mov eax, dword ptr [ebp - local_24]          # 00419d7c
    push eax                                     # 00419d7f
    call FUN_0051dc6c                            # 00419d80
    add esp, 0x4                                 # 00419d85
    mov dword ptr [ebp - local_4], 0x0           # 00419d88
L_00419d8f:
    # block 0x00419d8f: entered by je at 0x00419d74, 2 instruction(s), ends with forward jump to 0x00419da5
    {load} xor eax, eax                          # 00419d8f
    jmp.d8 L_00419da5                            # 00419d91
L_00419d93:
    # block 0x00419d93: entered by jmp at 0x00419d2b, 1 instruction(s), ends with backward jump to 0x00419d2d
    jmp.d8 L_00419d2d                            # 00419d93
L_00419d95:
    # block 0x00419d95: entered by jmp at 0x00419ce6, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419d95
L_00419d97:
    # block 0x00419d97: entered by jmp at 0x00419c3d, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419d97
L_00419d99:
    # block 0x00419d99: entered by jmp at 0x00419bfe, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419d99
L_00419d9b:
    # block 0x00419d9b: entered by jmp at 0x00419bbf, 1 instruction(s), ends with backward jump to 0x00419d2d
    jmp.d8 L_00419d2d                            # 00419d9b
L_00419d9d:
    # block 0x00419d9d: entered by jmp at 0x00419b57, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419d9d
L_00419d9f:
    # block 0x00419d9f: entered by jmp at 0x00419aae, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419d9f
L_00419da1:
    # block 0x00419da1: entered by jmp at 0x00419a6f, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419da1
L_00419da3:
    # block 0x00419da3: entered by jmp at 0x004199be, 1 instruction(s), ends with backward jump to 0x00419d51
    jmp.d8 L_00419d51                            # 00419da3
L_00419da5:
    # block 0x00419da5: entered by jmp at 0x00419d4f; jmp at 0x00419d91, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00419da5
    pop ebp                                      # 00419da7
    ret 0x8                                      # 00419da8

