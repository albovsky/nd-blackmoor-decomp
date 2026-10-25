# FUN_00431b5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00431b5a
# extent:       0x00431b5a-0x00432cf2 (4504 code bytes)
# span:         0x00431b5a-0x00432d1a (code 4504, tables 40, padding 0)
# sha256:       0df235b861dda4651771b5ef377bd24d3296eda04f08db4077f6145f6419c4e1
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00431b5a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_1, field_1c2, field_1f3, field_224, field_255, field_286, field_2b7, field_5fd, field_5ff, field_601, field_603, field_605 and 11 more; [ecx + n] field_1f3, field_224, field_629, field_655, field_71d, field_721, field_729, field_733; [edx + n] field_2c7, field_5e3, field_5e5, field_5e7, field_5e9, field_5eb, field_5ef, field_5f3, field_5f7, field_5f9, field_5fb, field_627 and 5 more
# callees:      calls FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, FUN_004fb2e3, FUN_00448d11, FUN_004fba69, FUN_004f6334, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 912 instruction(s), 55 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1f3, 0x1f3  # offset +0x1f3
.equ field_224, 0x224  # offset +0x224
.equ field_255, 0x255  # offset +0x255
.equ field_286, 0x286  # offset +0x286
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_2c7, 0x2c7  # offset +0x2c7
.equ field_5e3, 0x5e3  # offset +0x5e3
.equ field_5e5, 0x5e5  # offset +0x5e5
.equ field_5e7, 0x5e7  # offset +0x5e7
.equ field_5e9, 0x5e9  # offset +0x5e9
.equ field_5eb, 0x5eb  # offset +0x5eb
.equ field_5ef, 0x5ef  # offset +0x5ef
.equ field_5f3, 0x5f3  # offset +0x5f3
.equ field_5f7, 0x5f7  # offset +0x5f7
.equ field_5f9, 0x5f9  # offset +0x5f9
.equ field_5fb, 0x5fb  # offset +0x5fb
.equ field_5fd, 0x5fd  # offset +0x5fd
.equ field_5ff, 0x5ff  # offset +0x5ff
.equ field_601, 0x601  # offset +0x601
.equ field_603, 0x603  # offset +0x603
.equ field_605, 0x605  # offset +0x605
.equ field_609, 0x609  # offset +0x609
.equ field_60d, 0x60d  # offset +0x60d
.equ field_611, 0x611  # offset +0x611
.equ field_613, 0x613  # offset +0x613
.equ field_615, 0x615  # offset +0x615
.equ field_627, 0x627  # offset +0x627
.equ field_629, 0x629  # offset +0x629
.equ field_634, 0x634  # offset +0x634
.equ field_655, 0x655  # offset +0x655
.equ field_71d, 0x71d  # offset +0x71d
.equ field_71f, 0x71f  # offset +0x71f
.equ field_721, 0x721  # offset +0x721
.equ field_723, 0x723  # offset +0x723
.equ field_725, 0x725  # offset +0x725
.equ field_729, 0x729  # offset +0x729
.equ field_72d, 0x72d  # offset +0x72d
.equ field_731, 0x731  # offset +0x731
.equ field_733, 0x733  # offset +0x733
.equ field_735, 0x735  # offset +0x735

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00431b5a - 0x401000
.globl FUN_00431b5a
FUN_00431b5a:
    # block 0x00431b5a: entry, 11 instruction(s), ends with je to 0x00431b94 (forward)
    push ebp                                     # 00431b5a
    {load} mov ebp, esp                          # 00431b5b
    sub esp, 0x2c                                # 00431b5d
    push esi                                     # 00431b60
    push edi                                     # 00431b61
    movsx eax, word ptr [ebp + arg_8]            # 00431b62
    imul eax, eax, 0x8d                          # 00431b66
    mov ecx, dword ptr [eax + 0x5bb632]          # 00431b6c
    mov dword ptr [ebp - local_24], ecx          # 00431b72
    cmp dword ptr [ebp - local_24], 0x0          # 00431b75
    je.d8 L_00431b94                             # 00431b79
    # block 0x00431b7b: entered by fall-through of je at 0x00431b79, 2 instruction(s), ends with je to 0x00431d46 (forward)
    cmp dword ptr [ebp - local_24], 0x1          # 00431b7b
    je.d32 L_00431d46                            # 00431b7f
    # block 0x00431b85: entered by fall-through of je at 0x00431b7f, 2 instruction(s), ends with je to 0x00432755 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 00431b85
    je.d32 L_00432755                            # 00431b89
    # block 0x00431b8f: entered by fall-through of je at 0x00431b89, 1 instruction(s), ends with forward jump to 0x00432cec
    jmp.d32 L_00432cec                           # 00431b8f
L_00431b94:
    # block 0x00431b94: entered by je at 0x00431b79, 13 instruction(s), ends with forward jump to 0x00431c00
    mov byte ptr [0x5b51f6], 0x1                 # 00431b94
    mov dword ptr [0x5bb1ca], 0x1                # 00431b9b
    mov word ptr [0x5b51f7], 0xffff              # 00431ba5
    mov word ptr [0x5b51ec], 0x7                 # 00431bae
    mov dword ptr [0x5b51f0], 0x0                # 00431bb7
    mov word ptr [0x5b51f4], 0xffff              # 00431bc1
    mov dx, word ptr [ebp + arg_8]               # 00431bca
    mov word ptr [0x5b51fb], dx                  # 00431bce
    mov byte ptr [0x5b51f9], 0x0                 # 00431bd5
    mov byte ptr [0x5b51fa], 0x0                 # 00431bdc
    mov word ptr [0x5b51ee], 0x0                 # 00431be3
    mov word ptr [ebp - local_8], 0x0            # 00431bec
    jmp.d8 L_00431c00                            # 00431bf2
L_00431bf4:
    # block 0x00431bf4: entered by jmp at 0x00431c18, 3 instruction(s), falls into the block at 0x00431c00
    mov ax, word ptr [ebp - local_8]             # 00431bf4
    .insn 0x66, 0x05, 0x0001{:u16}               # 00431bf8
    mov word ptr [ebp - local_8], ax             # 00431bfc
L_00431c00:
    # block 0x00431c00: entered by jmp at 0x00431bf2, 3 instruction(s), ends with jge to 0x00431c1a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00431c00
    cmp ecx, 0xc                                 # 00431c04
    jge.d8 L_00431c1a                            # 00431c07
    # block 0x00431c09: entered by fall-through of jge at 0x00431c07, 3 instruction(s), ends with backward jump to 0x00431bf4
    movsx edx, word ptr [ebp - local_8]          # 00431c09
    mov dword ptr [4*edx + 0x5b5203], 0x0        # 00431c0d
    jmp.d8 L_00431bf4                            # 00431c18
L_00431c1a:
    # block 0x00431c1a: entered by jge at 0x00431c07, 26 instruction(s), calls FUN_004c2dfb, FUN_004c2790, ends with je to 0x00431cf8 (forward)
    push 0x5d03df                                # 00431c1a
    mov ecx, 0x5cf659                            # 00431c1f
    call FUN_004c2dfb                            # 00431c24
    push 0x545cf8                                # 00431c29
    push 0x6                                     # 00431c2e
    movsx eax, word ptr [ebp + arg_8]            # 00431c30
    imul eax, eax, 0x8d                          # 00431c34
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431c3a
    push ecx                                     # 00431c40
    push 0x545d10                                # 00431c41
    mov ecx, 0x5cf659                            # 00431c46
    call FUN_004c2790                            # 00431c4b
    mov dword ptr [0x5d03df], eax                # 00431c50
    mov edx, dword ptr [0x5d03df]                # 00431c55
    mov dword ptr [0x5d1b61], edx                # 00431c5b
    mov dword ptr [0x5d1b6d], 0x1                # 00431c61
    mov dword ptr [0x5b51ff], 0x0                # 00431c6b
    mov edi, 0x545d18                            # 00431c75
    movsx eax, word ptr [ebp + arg_8]            # 00431c7a
    imul eax, eax, 0x8d                          # 00431c7e
    mov esi, dword ptr [eax + 0x5bb5e5]          # 00431c84
    add esi, 0x234                               # 00431c8a
    mov ecx, 0x9                                 # 00431c90
    {load} xor edx, edx                          # 00431c95
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00431c97
    je.d8 L_00431cf8                             # 00431c99
    # block 0x00431c9b: entered by fall-through of je at 0x00431c99, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00431cf8
    movsx eax, word ptr [ebp + arg_8]            # 00431c9b
    imul eax, eax, 0x8d                          # 00431c9f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431ca5
    add ecx, 0x234                               # 00431cab
    push ecx                                     # 00431cb1
    mov ecx, 0x5c3a67                            # 00431cb2
    call FUN_004fb77a                            # 00431cb7
    movsx edx, word ptr [ebp + arg_8]            # 00431cbc
    imul edx, edx, 0x8d                          # 00431cc0
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431cc6
    mov cx, word ptr [eax + field_255]           # 00431ccc
    push ecx                                     # 00431cd3
    mov ecx, 0x5c3a67                            # 00431cd4
    call FUN_004fb2e3                            # 00431cd9
    movsx edx, word ptr [ebp + arg_8]            # 00431cde
    imul edx, edx, 0x8d                          # 00431ce2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431ce8
    add eax, 0x234                               # 00431cee
    mov dword ptr [0x5b51ff], eax                # 00431cf3
L_00431cf8:
    # block 0x00431cf8: entered by je at 0x00431c99, 16 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00432cec
    push 0x0                                     # 00431cf8
    push -0x1                                    # 00431cfa
    movsx ecx, word ptr [ebp + arg_8]            # 00431cfc
    imul ecx, ecx, 0x8d                          # 00431d00
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431d06
    add edx, 0x453                               # 00431d0c
    push edx                                     # 00431d12
    mov eax, dword ptr [0x5d03b3]                # 00431d13
    push eax                                     # 00431d18
    mov ecx, 0x619a05                            # 00431d19
    call FUN_00448d11                            # 00431d1e
    mov dword ptr [0x5b5233], 0x0                # 00431d23
    movsx ecx, word ptr [ebp + arg_8]            # 00431d2d
    imul ecx, ecx, 0x8d                          # 00431d31
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00431d37
    jmp.d32 L_00432cec                           # 00431d41
L_00431d46:
    # block 0x00431d46: entered by je at 0x00431b7f, 4 instruction(s), ends with ja to 0x00432750 (forward)
    mov edx, dword ptr [0x5b5233]                # 00431d46
    mov dword ptr [ebp - local_28], edx          # 00431d4c
    cmp dword ptr [ebp - local_28], 0x9          # 00431d4f
    ja.d32 L_00432750                            # 00431d53
    # block 0x00431d59: entered by fall-through of ja at 0x00431d53, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x432cf2]
    mov eax, dword ptr [ebp - local_28]          # 00431d59
    jmp dword ptr [4*eax + SWTAB_00432cf2_VA]    # 00431d5c
L_00431d63:
    # block 0x00431d63: entered by switch case, 3 instruction(s), ends with je to 0x00431da3 (forward)
    movsx ecx, word ptr [0x5b51f7]               # 00431d63
    cmp ecx, -0x1                                # 00431d6a
    je.d8 L_00431da3                             # 00431d6d
    # block 0x00431d6f: entered by fall-through of je at 0x00431d6d, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x00431da3
    movsx edx, word ptr [ebp + arg_8]            # 00431d6f
    imul edx, edx, 0x8d                          # 00431d73
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431d79
    add eax, 0x234                               # 00431d7f
    push eax                                     # 00431d84
    mov ecx, 0x5c3a67                            # 00431d85
    call FUN_004fba69                            # 00431d8a
    mov dword ptr [0x5b51ff], 0x0                # 00431d8f
    mov dword ptr [0x5b5233], 0x1                # 00431d99
L_00431da3:
    # block 0x00431da3: entered by je at 0x00431d6d; switch case, 3 instruction(s), ends with je to 0x00431f5e (forward)
    movsx ecx, word ptr [0x5b51f7]               # 00431da3
    cmp ecx, -0x1                                # 00431daa
    je.d32 L_00431f5e                            # 00431dad
    # block 0x00431db3: entered by fall-through of je at 0x00431dad, 5 instruction(s), ends with je to 0x00431f50 (forward)
    movsx edx, word ptr [0x5b51f7]               # 00431db3
    mov eax, dword ptr [4*edx + 0x5b5203]        # 00431dba
    mov dword ptr [ebp - local_2c], eax          # 00431dc1
    cmp dword ptr [ebp - local_2c], 0x0          # 00431dc4
    je.d32 L_00431f50                            # 00431dc8
    # block 0x00431dce: entered by fall-through of je at 0x00431dc8, 2 instruction(s), ends with je to 0x00431de3 (forward)
    cmp dword ptr [ebp - local_2c], 0x1          # 00431dce
    je.d8 L_00431de3                             # 00431dd2
    # block 0x00431dd4: entered by fall-through of je at 0x00431dd2, 2 instruction(s), ends with je to 0x00431ee5 (forward)
    cmp dword ptr [ebp - local_2c], 0x2          # 00431dd4
    je.d32 L_00431ee5                            # 00431dd8
    # block 0x00431dde: entered by fall-through of je at 0x00431dd8, 1 instruction(s), ends with forward jump to 0x00431f59
    jmp.d32 L_00431f59                           # 00431dde
L_00431de3:
    # block 0x00431de3: entered by je at 0x00431dd2, 34 instruction(s), ends with je to 0x00431ed1 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00431de3
    imul ecx, ecx, 0x8d                          # 00431de7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431ded
    movsx eax, word ptr [0x5b51f7]               # 00431df3
    imul eax, eax, 0x21                          # 00431dfa
    lea ecx, [edx + eax + field_2c7]             # 00431dfd
    {load} mov edi, ecx                          # 00431e04
    movsx edx, word ptr [ebp + arg_8]            # 00431e06
    imul edx, edx, 0x8d                          # 00431e0a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431e10
    add eax, 0x1d2                               # 00431e16
    {load} mov edx, eax                          # 00431e1b
    or ecx, -0x1                                 # 00431e1d
    {load} xor eax, eax                          # 00431e20
    repne scasb al, byte ptr es:[edi]            # 00431e22
    not ecx                                      # 00431e24
    {load} sub edi, ecx                          # 00431e26
    {load} mov esi, edi                          # 00431e28
    {load} mov eax, ecx                          # 00431e2a
    {load} mov edi, edx                          # 00431e2c
    shr ecx, 0x2                                 # 00431e2e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00431e31
    {load} mov ecx, eax                          # 00431e33
    and ecx, 0x3                                 # 00431e35
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00431e38
    mov edi, 0x545d24                            # 00431e3a
    movsx ecx, word ptr [ebp + arg_8]            # 00431e3f
    imul ecx, ecx, 0x8d                          # 00431e43
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 00431e49
    add esi, 0x1d2                               # 00431e4f
    mov ecx, 0x9                                 # 00431e55
    {load} xor edx, edx                          # 00431e5a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00431e5c
    je.d8 L_00431ed1                             # 00431e5e
    # block 0x00431e60: entered by fall-through of je at 0x00431e5e, 22 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00431ee3
    movsx eax, word ptr [ebp + arg_8]            # 00431e60
    imul eax, eax, 0x8d                          # 00431e64
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431e6a
    add ecx, 0x1d2                               # 00431e70
    push ecx                                     # 00431e76
    mov ecx, 0x5c3a67                            # 00431e77
    call FUN_004fb77a                            # 00431e7c
    movsx edx, word ptr [ebp + arg_8]            # 00431e81
    imul edx, edx, 0x8d                          # 00431e85
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431e8b
    mov cx, word ptr [eax + field_1f3]           # 00431e91
    push ecx                                     # 00431e98
    mov ecx, 0x5c3a67                            # 00431e99
    call FUN_004fb2e3                            # 00431e9e
    movsx edx, word ptr [ebp + arg_8]            # 00431ea3
    imul edx, edx, 0x8d                          # 00431ea7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431ead
    add eax, 0x1d2                               # 00431eb3
    mov dword ptr [0x5b51ff], eax                # 00431eb8
    movsx ecx, word ptr [0x5b51f7]               # 00431ebd
    mov dword ptr [4*ecx + 0x5b5203], 0x2        # 00431ec4
    jmp.d8 L_00431ee3                            # 00431ecf
L_00431ed1:
    # block 0x00431ed1: entered by je at 0x00431e5e, 2 instruction(s), falls into the block at 0x00431ee3
    movsx edx, word ptr [0x5b51f7]               # 00431ed1
    mov dword ptr [4*edx + 0x5b5203], 0x0        # 00431ed8
L_00431ee3:
    # block 0x00431ee3: entered by jmp at 0x00431ecf, 1 instruction(s), ends with forward jump to 0x00431f59
    jmp.d8 L_00431f59                            # 00431ee3
L_00431ee5:
    # block 0x00431ee5: entered by je at 0x00431dd8, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x00431f4e (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00431ee5
    imul eax, eax, 0x8d                          # 00431ee9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431eef
    movsx edx, word ptr [ecx + field_1f3]        # 00431ef5
    mov dword ptr [ebp - local_10], edx          # 00431efc
    mov eax, dword ptr [ebp - local_10]          # 00431eff
    push eax                                     # 00431f02
    mov ecx, 0x5cf1eb                            # 00431f03
    call FUN_004f6334                            # 00431f08
    test eax, eax                                # 00431f0d
    jne.d8 L_00431f4e                            # 00431f0f
    # block 0x00431f11: entered by fall-through of jne at 0x00431f0f, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x00431f4e
    movsx ecx, word ptr [ebp + arg_8]            # 00431f11
    imul ecx, ecx, 0x8d                          # 00431f15
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431f1b
    add edx, 0x1d2                               # 00431f21
    push edx                                     # 00431f27
    mov ecx, 0x5c3a67                            # 00431f28
    call FUN_004fba69                            # 00431f2d
    mov dword ptr [0x5b51ff], 0x0                # 00431f32
    movsx eax, word ptr [0x5b51f7]               # 00431f3c
    mov dword ptr [4*eax + 0x5b5203], 0x0        # 00431f43
L_00431f4e:
    # block 0x00431f4e: entered by jne at 0x00431f0f, 1 instruction(s), ends with forward jump to 0x00431f59
    jmp.d8 L_00431f59                            # 00431f4e
L_00431f50:
    # block 0x00431f50: entered by je at 0x00431dc8, 1 instruction(s), falls into the block at 0x00431f59
    mov word ptr [0x5b51f7], 0xffff              # 00431f50
L_00431f59:
    # block 0x00431f59: entered by jmp at 0x00431dde; jmp at 0x00431ee3; jmp at 0x00431f4e, 1 instruction(s), ends with forward jump to 0x004320e2
    jmp.d32 L_004320e2                           # 00431f59
L_00431f5e:
    # block 0x00431f5e: entered by je at 0x00431dad, 3 instruction(s), ends with jle to 0x00432085 (forward)
    movsx ecx, word ptr [0x5b51ee]               # 00431f5e
    test ecx, ecx                                # 00431f65
    jle.d32 L_00432085                           # 00431f67
    # block 0x00431f6d: entered by fall-through of jle at 0x00431f67, 2 instruction(s), ends with jne to 0x00432085 (forward)
    cmp dword ptr [0x5b51f0], 0x0                # 00431f6d
    jne.d32 L_00432085                           # 00431f74
    # block 0x00431f7a: entered by fall-through of jne at 0x00431f74, 2 instruction(s), ends with forward jump to 0x00431f8e
    mov word ptr [ebp - local_8], 0x0            # 00431f7a
    jmp.d8 L_00431f8e                            # 00431f80
L_00431f82:
    # block 0x00431f82: entered by jmp at 0x00432080, 3 instruction(s), falls into the block at 0x00431f8e
    mov dx, word ptr [ebp - local_8]             # 00431f82
    add dx, 0x1                                  # 00431f86
    mov word ptr [ebp - local_8], dx             # 00431f8a
L_00431f8e:
    # block 0x00431f8e: entered by jmp at 0x00431f80, 7 instruction(s), ends with jge to 0x00432085 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00431f8e
    movsx ecx, word ptr [ebp + arg_8]            # 00431f92
    imul ecx, ecx, 0x8d                          # 00431f96
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431f9c
    movsx ecx, word ptr [edx + field_627]        # 00431fa2
    {load} cmp eax, ecx                          # 00431fa9
    jge.d32 L_00432085                           # 00431fab
    # block 0x00431fb1: entered by fall-through of jge at 0x00431fab, 2 instruction(s), ends with forward jump to 0x00431fc5
    mov word ptr [ebp - local_4], 0x0            # 00431fb1
    jmp.d8 L_00431fc5                            # 00431fb7
L_00431fb9:
    # block 0x00431fb9: entered by jmp at 0x0043207b, 3 instruction(s), falls into the block at 0x00431fc5
    mov dx, word ptr [ebp - local_4]             # 00431fb9
    add dx, 0x1                                  # 00431fbd
    mov word ptr [ebp - local_4], dx             # 00431fc1
L_00431fc5:
    # block 0x00431fc5: entered by jmp at 0x00431fb7, 3 instruction(s), ends with jge to 0x00432080 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00431fc5
    cmp eax, 0x7                                 # 00431fc9
    jge.d32 L_00432080                           # 00431fcc
    # block 0x00431fd2: entered by fall-through of jge at 0x00431fcc, 14 instruction(s), ends with je to 0x0043201d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00431fd2
    imul ecx, ecx, 0x8d                          # 00431fd6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431fdc
    movsx eax, word ptr [ebp - local_8]          # 00431fe2
    imul eax, eax, 0x10e                         # 00431fe6
    lea ecx, [edx + eax + field_629]             # 00431fec
    movsx edx, word ptr [ebp - local_4]          # 00431ff3
    {load} xor eax, eax                          # 00431ff7
    mov al, byte ptr [ecx + edx]                 # 00431ff9
    movsx ecx, word ptr [ebp - local_4]          # 00431ffc
    {load} xor edx, edx                          # 00432000
    mov dl, byte ptr [ecx + 0x5b51e1]            # 00432002
    {load} cmp eax, edx                          # 00432008
    je.d8 L_0043201d                             # 0043200a
    # block 0x0043200c: entered by fall-through of je at 0x0043200a, 3 instruction(s), ends with forward jump to 0x0043207b
    mov word ptr [0x5b51ec], 0x7                 # 0043200c
    mov word ptr [ebp - local_4], 0x7            # 00432015
    jmp.d8 L_0043207b                            # 0043201b
L_0043201d:
    # block 0x0043201d: entered by je at 0x0043200a, 11 instruction(s), ends with jne to 0x0043207b (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0043201d
    imul eax, eax, 0x8d                          # 00432021
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432027
    movsx edx, word ptr [ebp - local_8]          # 0043202d
    imul edx, edx, 0x10e                         # 00432031
    lea eax, [ecx + edx + field_629]             # 00432037
    movsx ecx, word ptr [ebp - local_4]          # 0043203e
    {load} xor edx, edx                          # 00432042
    mov dl, byte ptr [eax + ecx + field_1]       # 00432044
    cmp edx, 0xa                                 # 00432048
    jne.d8 L_0043207b                            # 0043204b
    # block 0x0043204d: entered by fall-through of jne at 0x0043204b, 9 instruction(s), falls into the block at 0x0043207b
    movsx eax, word ptr [ebp - local_4]          # 0043204d
    add eax, 0x1                                 # 00432051
    mov word ptr [0x5b51ec], ax                  # 00432054
    mov word ptr [ebp - local_4], 0x7            # 0043205a
    movsx ecx, word ptr [ebp + arg_8]            # 00432060
    imul ecx, ecx, 0x8d                          # 00432064
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043206a
    mov ax, word ptr [edx + field_627]           # 00432070
    mov word ptr [ebp - local_8], ax             # 00432077
L_0043207b:
    # block 0x0043207b: entered by jmp at 0x0043201b; jne at 0x0043204b, 1 instruction(s), ends with backward jump to 0x00431fb9
    jmp.d32 L_00431fb9                           # 0043207b
L_00432080:
    # block 0x00432080: entered by jge at 0x00431fcc, 1 instruction(s), ends with backward jump to 0x00431f82
    jmp.d32 L_00431f82                           # 00432080
L_00432085:
    # block 0x00432085: entered by jle at 0x00431f67; jne at 0x00431f74; jge at 0x00431fab, 2 instruction(s), ends with jne to 0x004320a0 (forward)
    cmp dword ptr [0x5b51f0], 0x0                # 00432085
    jne.d8 L_004320a0                            # 0043208c
    # block 0x0043208e: entered by fall-through of jne at 0x0043208c, 4 instruction(s), ends with jge to 0x004320b5 (forward)
    movsx ecx, word ptr [0x5b51ee]               # 0043208e
    movsx edx, word ptr [0x5b51ec]               # 00432095
    {load} cmp ecx, edx                          # 0043209c
    jge.d8 L_004320b5                            # 0043209e
L_004320a0:
    # block 0x004320a0: entered by jne at 0x0043208c; fall-through of jge at 0x0043209e, 2 instruction(s), ends with jne to 0x004320e2 (forward)
    cmp dword ptr [0x5b51f0], 0x1                # 004320a0
    jne.d8 L_004320e2                            # 004320a7
    # block 0x004320a9: entered by fall-through of jne at 0x004320a7, 3 instruction(s), ends with jl to 0x004320e2 (forward)
    movsx eax, word ptr [0x5b51ee]               # 004320a9
    cmp eax, 0xb                                 # 004320b0
    jl.d8 L_004320e2                             # 004320b3
L_004320b5:
    # block 0x004320b5: entered by jge at 0x0043209e; fall-through of jl at 0x004320b3, 2 instruction(s), ends with je to 0x004320d8 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004320b5
    je.d8 L_004320d8                             # 004320bc
    # block 0x004320be: entered by fall-through of je at 0x004320bc, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x004320d8
    push 0x0                                     # 004320be
    push -0x1                                    # 004320c0
    push 0x545d30                                # 004320c2
    mov ecx, dword ptr [0x5d03b3]                # 004320c7
    push ecx                                     # 004320cd
    mov ecx, 0x619a05                            # 004320ce
    call FUN_00448d11                            # 004320d3
L_004320d8:
    # block 0x004320d8: entered by je at 0x004320bc, 1 instruction(s), falls into the block at 0x004320e2
    mov dword ptr [0x5b5233], 0x2                # 004320d8
L_004320e2:
    # block 0x004320e2: entered by jmp at 0x00431f59; jne at 0x004320a7; jl at 0x004320b3, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 004320e2
L_004320e7:
    # block 0x004320e7: entered by switch case, 9 instruction(s), ends with je to 0x00432178 (forward)
    mov edi, 0x545d44                            # 004320e7
    movsx edx, word ptr [ebp + arg_8]            # 004320ec
    imul edx, edx, 0x8d                          # 004320f0
    mov esi, dword ptr [edx + 0x5bb5e5]          # 004320f6
    add esi, 0x203                               # 004320fc
    mov ecx, 0x9                                 # 00432102
    {load} xor eax, eax                          # 00432107
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00432109
    je.d8 L_00432178                             # 0043210b
    # block 0x0043210d: entered by fall-through of je at 0x0043210b, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00432182
    movsx ecx, word ptr [ebp + arg_8]            # 0043210d
    imul ecx, ecx, 0x8d                          # 00432111
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432117
    add edx, 0x203                               # 0043211d
    push edx                                     # 00432123
    mov ecx, 0x5c3a67                            # 00432124
    call FUN_004fb77a                            # 00432129
    movsx eax, word ptr [ebp + arg_8]            # 0043212e
    imul eax, eax, 0x8d                          # 00432132
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432138
    mov dx, word ptr [ecx + field_224]           # 0043213e
    push edx                                     # 00432145
    mov ecx, 0x5c3a67                            # 00432146
    call FUN_004fb2e3                            # 0043214b
    movsx eax, word ptr [ebp + arg_8]            # 00432150
    imul eax, eax, 0x8d                          # 00432154
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043215a
    add ecx, 0x203                               # 00432160
    mov dword ptr [0x5b51ff], ecx                # 00432166
    mov dword ptr [0x5b5233], 0x3                # 0043216c
    jmp.d8 L_00432182                            # 00432176
L_00432178:
    # block 0x00432178: entered by je at 0x0043210b, 1 instruction(s), falls into the block at 0x00432182
    mov dword ptr [0x5b5233], 0x4                # 00432178
L_00432182:
    # block 0x00432182: entered by jmp at 0x00432176, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 00432182
L_00432187:
    # block 0x00432187: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x004321e8 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00432187
    imul edx, edx, 0x8d                          # 0043218b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432191
    movsx ecx, word ptr [eax + field_224]        # 00432197
    mov dword ptr [ebp - local_14], ecx          # 0043219e
    mov edx, dword ptr [ebp - local_14]          # 004321a1
    push edx                                     # 004321a4
    mov ecx, 0x5cf1eb                            # 004321a5
    call FUN_004f6334                            # 004321aa
    test eax, eax                                # 004321af
    jne.d8 L_004321e8                            # 004321b1
    # block 0x004321b3: entered by fall-through of jne at 0x004321b1, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004321e8
    movsx eax, word ptr [ebp + arg_8]            # 004321b3
    imul eax, eax, 0x8d                          # 004321b7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004321bd
    add ecx, 0x203                               # 004321c3
    push ecx                                     # 004321c9
    mov ecx, 0x5c3a67                            # 004321ca
    call FUN_004fba69                            # 004321cf
    mov dword ptr [0x5b51ff], 0x0                # 004321d4
    mov dword ptr [0x5b5233], 0x4                # 004321de
L_004321e8:
    # block 0x004321e8: entered by jne at 0x004321b1, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 004321e8
L_004321ed:
    # block 0x004321ed: entered by switch case, 3 instruction(s), ends with forward jump to 0x00432208
    mov dword ptr [ebp - local_c], 0x1           # 004321ed
    mov word ptr [ebp - local_8], 0x0            # 004321f4
    jmp.d8 L_00432208                            # 004321fa
L_004321fc:
    # block 0x004321fc: entered by jmp at 0x0043230f, 3 instruction(s), falls into the block at 0x00432208
    mov dx, word ptr [ebp - local_8]             # 004321fc
    add dx, 0x1                                  # 00432200
    mov word ptr [ebp - local_8], dx             # 00432204
L_00432208:
    # block 0x00432208: entered by jmp at 0x004321fa, 7 instruction(s), ends with jge to 0x00432314 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00432208
    movsx ecx, word ptr [ebp + arg_8]            # 0043220c
    imul ecx, ecx, 0x8d                          # 00432210
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432216
    movsx ecx, word ptr [edx + field_627]        # 0043221c
    {load} cmp eax, ecx                          # 00432223
    jge.d32 L_00432314                           # 00432225
    # block 0x0043222b: entered by fall-through of jge at 0x00432225, 3 instruction(s), ends with jne to 0x004322a5 (forward)
    mov dword ptr [ebp - local_c], 0x0           # 0043222b
    cmp dword ptr [0x5b51f0], 0x0                # 00432232
    jne.d8 L_004322a5                            # 00432239
    # block 0x0043223b: entered by fall-through of jne at 0x00432239, 2 instruction(s), ends with forward jump to 0x0043224f
    mov word ptr [ebp - local_4], 0x0            # 0043223b
    jmp.d8 L_0043224f                            # 00432241
L_00432243:
    # block 0x00432243: entered by jmp at 0x004322a1, 3 instruction(s), falls into the block at 0x0043224f
    mov dx, word ptr [ebp - local_4]             # 00432243
    add dx, 0x1                                  # 00432247
    mov word ptr [ebp - local_4], dx             # 0043224b
L_0043224f:
    # block 0x0043224f: entered by jmp at 0x00432241, 4 instruction(s), ends with jge to 0x004322a3 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0043224f
    movsx ecx, word ptr [0x5b51ec]               # 00432253
    {load} cmp eax, ecx                          # 0043225a
    jge.d8 L_004322a3                            # 0043225c
    # block 0x0043225e: entered by fall-through of jge at 0x0043225c, 14 instruction(s), ends with je to 0x004322a1 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0043225e
    imul edx, edx, 0x8d                          # 00432262
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432268
    movsx ecx, word ptr [ebp - local_8]          # 0043226e
    imul ecx, ecx, 0x10e                         # 00432272
    lea edx, [eax + ecx + field_629]             # 00432278
    movsx eax, word ptr [ebp - local_4]          # 0043227f
    {load} xor ecx, ecx                          # 00432283
    mov cl, byte ptr [edx + eax]                 # 00432285
    movsx edx, word ptr [ebp - local_4]          # 00432288
    {load} xor eax, eax                          # 0043228c
    mov al, byte ptr [edx + 0x5b51e1]            # 0043228e
    {load} cmp ecx, eax                          # 00432294
    je.d8 L_004322a1                             # 00432296
    # block 0x00432298: entered by fall-through of je at 0x00432296, 2 instruction(s), ends with forward jump to 0x004322a3
    mov dword ptr [ebp - local_c], 0x1           # 00432298
    jmp.d8 L_004322a3                            # 0043229f
L_004322a1:
    # block 0x004322a1: entered by je at 0x00432296, 1 instruction(s), ends with backward jump to 0x00432243
    jmp.d8 L_00432243                            # 004322a1
L_004322a3:
    # block 0x004322a3: entered by jge at 0x0043225c; jmp at 0x0043229f, 1 instruction(s), ends with forward jump to 0x00432307
    jmp.d8 L_00432307                            # 004322a3
L_004322a5:
    # block 0x004322a5: entered by jne at 0x00432239, 2 instruction(s), ends with forward jump to 0x004322b9
    mov word ptr [ebp - local_4], 0x0            # 004322a5
    jmp.d8 L_004322b9                            # 004322ab
L_004322ad:
    # block 0x004322ad: entered by jmp at 0x00432305, 3 instruction(s), falls into the block at 0x004322b9
    mov cx, word ptr [ebp - local_4]             # 004322ad
    add cx, 0x1                                  # 004322b1
    mov word ptr [ebp - local_4], cx             # 004322b5
L_004322b9:
    # block 0x004322b9: entered by jmp at 0x004322ab, 3 instruction(s), ends with jge to 0x00432307 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004322b9
    cmp edx, 0xb                                 # 004322bd
    jge.d8 L_00432307                            # 004322c0
    # block 0x004322c2: entered by fall-through of jge at 0x004322c0, 14 instruction(s), ends with je to 0x00432305 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004322c2
    imul eax, eax, 0x8d                          # 004322c6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004322cc
    movsx edx, word ptr [ebp - local_8]          # 004322d2
    imul edx, edx, 0x10e                         # 004322d6
    lea eax, [ecx + edx + field_629]             # 004322dc
    movsx ecx, word ptr [ebp - local_4]          # 004322e3
    {load} xor edx, edx                          # 004322e7
    mov dl, byte ptr [eax + ecx]                 # 004322e9
    movsx eax, word ptr [ebp - local_4]          # 004322ec
    {load} xor ecx, ecx                          # 004322f0
    mov cl, byte ptr [eax + 0x5b51e1]            # 004322f2
    {load} cmp edx, ecx                          # 004322f8
    je.d8 L_00432305                             # 004322fa
    # block 0x004322fc: entered by fall-through of je at 0x004322fa, 2 instruction(s), ends with forward jump to 0x00432307
    mov dword ptr [ebp - local_c], 0x1           # 004322fc
    jmp.d8 L_00432307                            # 00432303
L_00432305:
    # block 0x00432305: entered by je at 0x004322fa, 1 instruction(s), ends with backward jump to 0x004322ad
    jmp.d8 L_004322ad                            # 00432305
L_00432307:
    # block 0x00432307: entered by jmp at 0x004322a3; jge at 0x004322c0; jmp at 0x00432303, 2 instruction(s), ends with jne to 0x0043230f (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00432307
    jne.d8 L_0043230f                            # 0043230b
    # block 0x0043230d: entered by fall-through of jne at 0x0043230b, 1 instruction(s), ends with forward jump to 0x00432314
    jmp.d8 L_00432314                            # 0043230d
L_0043230f:
    # block 0x0043230f: entered by jne at 0x0043230b, 1 instruction(s), ends with backward jump to 0x004321fc
    jmp.d32 L_004321fc                           # 0043230f
L_00432314:
    # block 0x00432314: entered by jge at 0x00432225; jmp at 0x0043230d, 2 instruction(s), ends with jne to 0x00432466 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00432314
    jne.d32 L_00432466                           # 00432318
    # block 0x0043231e: entered by fall-through of jne at 0x00432318, 4 instruction(s), ends with je to 0x00432369 (forward)
    mov dx, word ptr [ebp - local_8]             # 0043231e
    mov word ptr [0x5b51f4], dx                  # 00432322
    cmp dword ptr [0x5bb202], 0x0                # 00432329
    je.d8 L_00432369                             # 00432330
    # block 0x00432332: entered by fall-through of je at 0x00432330, 13 instruction(s), calls FUN_00448d11, falls into the block at 0x00432369
    push 0x0                                     # 00432332
    push -0x1                                    # 00432334
    movsx eax, word ptr [ebp + arg_8]            # 00432336
    imul eax, eax, 0x8d                          # 0043233a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432340
    movsx edx, word ptr [ebp - local_8]          # 00432346
    imul edx, edx, 0x10e                         # 0043234a
    lea eax, [ecx + edx + field_655]             # 00432350
    push eax                                     # 00432357
    mov ecx, dword ptr [0x5d03b3]                # 00432358
    push ecx                                     # 0043235e
    mov ecx, 0x619a05                            # 0043235f
    call FUN_00448d11                            # 00432364
L_00432369:
    # block 0x00432369: entered by je at 0x00432330, 34 instruction(s), ends with je to 0x00432450 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00432369
    imul edx, edx, 0x8d                          # 0043236d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432373
    movsx ecx, word ptr [ebp - local_8]          # 00432379
    imul ecx, ecx, 0x10e                         # 0043237d
    lea edx, [eax + ecx + field_634]             # 00432383
    {load} mov edi, edx                          # 0043238a
    movsx eax, word ptr [ebp + arg_8]            # 0043238c
    imul eax, eax, 0x8d                          # 00432390
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432396
    add ecx, 0x1a1                               # 0043239c
    {load} mov edx, ecx                          # 004323a2
    or ecx, -0x1                                 # 004323a4
    {load} xor eax, eax                          # 004323a7
    repne scasb al, byte ptr es:[edi]            # 004323a9
    not ecx                                      # 004323ab
    {load} sub edi, ecx                          # 004323ad
    {load} mov esi, edi                          # 004323af
    {load} mov eax, ecx                          # 004323b1
    {load} mov edi, edx                          # 004323b3
    shr ecx, 0x2                                 # 004323b5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004323b8
    {load} mov ecx, eax                          # 004323ba
    and ecx, 0x3                                 # 004323bc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004323bf
    mov edi, 0x545d50                            # 004323c1
    movsx ecx, word ptr [ebp + arg_8]            # 004323c6
    imul ecx, ecx, 0x8d                          # 004323ca
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 004323d0
    add esi, 0x1a1                               # 004323d6
    mov ecx, 0x9                                 # 004323dc
    {load} xor edx, edx                          # 004323e1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004323e3
    je.d8 L_00432450                             # 004323e5
    # block 0x004323e7: entered by fall-through of je at 0x004323e5, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00432464
    movsx eax, word ptr [ebp + arg_8]            # 004323e7
    imul eax, eax, 0x8d                          # 004323eb
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004323f1
    add ecx, 0x1a1                               # 004323f7
    push ecx                                     # 004323fd
    mov ecx, 0x5c3a67                            # 004323fe
    call FUN_004fb77a                            # 00432403
    movsx edx, word ptr [ebp + arg_8]            # 00432408
    imul edx, edx, 0x8d                          # 0043240c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432412
    mov cx, word ptr [eax + field_1c2]           # 00432418
    push ecx                                     # 0043241f
    mov ecx, 0x5c3a67                            # 00432420
    call FUN_004fb2e3                            # 00432425
    movsx edx, word ptr [ebp + arg_8]            # 0043242a
    imul edx, edx, 0x8d                          # 0043242e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432434
    add eax, 0x1a1                               # 0043243a
    mov dword ptr [0x5b51ff], eax                # 0043243f
    mov dword ptr [0x5b5233], 0x5                # 00432444
    jmp.d8 L_00432464                            # 0043244e
L_00432450:
    # block 0x00432450: entered by je at 0x004323e5, 3 instruction(s), falls into the block at 0x00432464
    movsx ecx, word ptr [ebp + arg_8]            # 00432450
    imul ecx, ecx, 0x8d                          # 00432454
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0043245a
L_00432464:
    # block 0x00432464: entered by jmp at 0x0043244e, 1 instruction(s), ends with forward jump to 0x00432470
    jmp.d8 L_00432470                            # 00432464
L_00432466:
    # block 0x00432466: entered by jne at 0x00432318, 1 instruction(s), falls into the block at 0x00432470
    mov dword ptr [0x5b5233], 0x6                # 00432466
L_00432470:
    # block 0x00432470: entered by jmp at 0x00432464, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 00432470
L_00432475:
    # block 0x00432475: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x004324e0 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00432475
    imul edx, edx, 0x8d                          # 00432479
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043247f
    movsx ecx, word ptr [eax + field_1c2]        # 00432485
    mov dword ptr [ebp - local_18], ecx          # 0043248c
    mov edx, dword ptr [ebp - local_18]          # 0043248f
    push edx                                     # 00432492
    mov ecx, 0x5cf1eb                            # 00432493
    call FUN_004f6334                            # 00432498
    test eax, eax                                # 0043249d
    jne.d8 L_004324e0                            # 0043249f
    # block 0x004324a1: entered by fall-through of jne at 0x0043249f, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x004324e0
    movsx eax, word ptr [ebp + arg_8]            # 004324a1
    imul eax, eax, 0x8d                          # 004324a5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004324ab
    add ecx, 0x1a1                               # 004324b1
    push ecx                                     # 004324b7
    mov ecx, 0x5c3a67                            # 004324b8
    call FUN_004fba69                            # 004324bd
    mov dword ptr [0x5b51ff], 0x0                # 004324c2
    movsx edx, word ptr [ebp + arg_8]            # 004324cc
    imul edx, edx, 0x8d                          # 004324d0
    mov dword ptr [edx + 0x5bb632], 0x2          # 004324d6
L_004324e0:
    # block 0x004324e0: entered by jne at 0x0043249f, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 004324e0
L_004324e5:
    # block 0x004324e5: entered by switch case, 2 instruction(s), ends with je to 0x0043251a (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004324e5
    je.d8 L_0043251a                             # 004324ec
    # block 0x004324ee: entered by fall-through of je at 0x004324ec, 11 instruction(s), calls FUN_00448d11, falls into the block at 0x0043251a
    push 0x0                                     # 004324ee
    push -0x1                                    # 004324f0
    movsx eax, word ptr [ebp + arg_8]            # 004324f2
    imul eax, eax, 0x8d                          # 004324f6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004324fc
    add ecx, 0x51b                               # 00432502
    push ecx                                     # 00432508
    mov edx, dword ptr [0x5d03b3]                # 00432509
    push edx                                     # 0043250f
    mov ecx, 0x619a05                            # 00432510
    call FUN_00448d11                            # 00432515
L_0043251a:
    # block 0x0043251a: entered by je at 0x004324ec, 9 instruction(s), ends with je to 0x004325a9 (forward)
    mov edi, 0x545d5c                            # 0043251a
    movsx eax, word ptr [ebp + arg_8]            # 0043251f
    imul eax, eax, 0x8d                          # 00432523
    mov esi, dword ptr [eax + 0x5bb5e5]          # 00432529
    add esi, 0x265                               # 0043252f
    mov ecx, 0x9                                 # 00432535
    {load} xor edx, edx                          # 0043253a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043253c
    je.d8 L_004325a9                             # 0043253e
    # block 0x00432540: entered by fall-through of je at 0x0043253e, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004325c4
    movsx eax, word ptr [ebp + arg_8]            # 00432540
    imul eax, eax, 0x8d                          # 00432544
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043254a
    add ecx, 0x265                               # 00432550
    push ecx                                     # 00432556
    mov ecx, 0x5c3a67                            # 00432557
    call FUN_004fb77a                            # 0043255c
    movsx edx, word ptr [ebp + arg_8]            # 00432561
    imul edx, edx, 0x8d                          # 00432565
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043256b
    mov cx, word ptr [eax + field_286]           # 00432571
    push ecx                                     # 00432578
    mov ecx, 0x5c3a67                            # 00432579
    call FUN_004fb2e3                            # 0043257e
    movsx edx, word ptr [ebp + arg_8]            # 00432583
    imul edx, edx, 0x8d                          # 00432587
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043258d
    add eax, 0x265                               # 00432593
    mov dword ptr [0x5b51ff], eax                # 00432598
    mov dword ptr [0x5b5233], 0x7                # 0043259d
    jmp.d8 L_004325c4                            # 004325a7
L_004325a9:
    # block 0x004325a9: entered by je at 0x0043253e, 4 instruction(s), falls into the block at 0x004325c4
    mov byte ptr [0x5b51fa], 0x1                 # 004325a9
    movsx ecx, word ptr [ebp + arg_8]            # 004325b0
    imul ecx, ecx, 0x8d                          # 004325b4
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004325ba
L_004325c4:
    # block 0x004325c4: entered by jmp at 0x004325a7, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 004325c4
L_004325c9:
    # block 0x004325c9: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x0043263b (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004325c9
    imul edx, edx, 0x8d                          # 004325cd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004325d3
    movsx ecx, word ptr [eax + field_286]        # 004325d9
    mov dword ptr [ebp - local_1c], ecx          # 004325e0
    mov edx, dword ptr [ebp - local_1c]          # 004325e3
    push edx                                     # 004325e6
    mov ecx, 0x5cf1eb                            # 004325e7
    call FUN_004f6334                            # 004325ec
    test eax, eax                                # 004325f1
    jne.d8 L_0043263b                            # 004325f3
    # block 0x004325f5: entered by fall-through of jne at 0x004325f3, 12 instruction(s), calls FUN_004fba69, falls into the block at 0x0043263b
    movsx eax, word ptr [ebp + arg_8]            # 004325f5
    imul eax, eax, 0x8d                          # 004325f9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004325ff
    add ecx, 0x265                               # 00432605
    push ecx                                     # 0043260b
    mov ecx, 0x5c3a67                            # 0043260c
    call FUN_004fba69                            # 00432611
    mov dword ptr [0x5b51ff], 0x0                # 00432616
    mov byte ptr [0x5b51fa], 0x1                 # 00432620
    movsx edx, word ptr [ebp + arg_8]            # 00432627
    imul edx, edx, 0x8d                          # 0043262b
    mov dword ptr [edx + 0x5bb632], 0x2          # 00432631
L_0043263b:
    # block 0x0043263b: entered by jne at 0x004325f3, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d32 L_00432750                           # 0043263b
L_00432640:
    # block 0x00432640: entered by switch case, 9 instruction(s), ends with je to 0x004326cf (forward)
    mov edi, 0x545d68                            # 00432640
    movsx eax, word ptr [ebp + arg_8]            # 00432645
    imul eax, eax, 0x8d                          # 00432649
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043264f
    add esi, 0x296                               # 00432655
    mov ecx, 0x9                                 # 0043265b
    {load} xor edx, edx                          # 00432660
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00432662
    je.d8 L_004326cf                             # 00432664
    # block 0x00432666: entered by fall-through of je at 0x00432664, 21 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004326e3
    movsx eax, word ptr [ebp + arg_8]            # 00432666
    imul eax, eax, 0x8d                          # 0043266a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432670
    add ecx, 0x296                               # 00432676
    push ecx                                     # 0043267c
    mov ecx, 0x5c3a67                            # 0043267d
    call FUN_004fb77a                            # 00432682
    movsx edx, word ptr [ebp + arg_8]            # 00432687
    imul edx, edx, 0x8d                          # 0043268b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432691
    mov cx, word ptr [eax + field_2b7]           # 00432697
    push ecx                                     # 0043269e
    mov ecx, 0x5c3a67                            # 0043269f
    call FUN_004fb2e3                            # 004326a4
    movsx edx, word ptr [ebp + arg_8]            # 004326a9
    imul edx, edx, 0x8d                          # 004326ad
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004326b3
    add eax, 0x296                               # 004326b9
    mov dword ptr [0x5b51ff], eax                # 004326be
    mov dword ptr [0x5b5233], 0x9                # 004326c3
    jmp.d8 L_004326e3                            # 004326cd
L_004326cf:
    # block 0x004326cf: entered by je at 0x00432664, 3 instruction(s), falls into the block at 0x004326e3
    movsx ecx, word ptr [ebp + arg_8]            # 004326cf
    imul ecx, ecx, 0x8d                          # 004326d3
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004326d9
L_004326e3:
    # block 0x004326e3: entered by jmp at 0x004326cd, 1 instruction(s), ends with forward jump to 0x00432750
    jmp.d8 L_00432750                            # 004326e3
L_004326e5:
    # block 0x004326e5: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x00432750 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004326e5
    imul edx, edx, 0x8d                          # 004326e9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004326ef
    movsx ecx, word ptr [eax + field_2b7]        # 004326f5
    mov dword ptr [ebp - local_20], ecx          # 004326fc
    mov edx, dword ptr [ebp - local_20]          # 004326ff
    push edx                                     # 00432702
    mov ecx, 0x5cf1eb                            # 00432703
    call FUN_004f6334                            # 00432708
    test eax, eax                                # 0043270d
    jne.d8 L_00432750                            # 0043270f
    # block 0x00432711: entered by fall-through of jne at 0x0043270f, 11 instruction(s), calls FUN_004fba69, falls into the block at 0x00432750
    movsx eax, word ptr [ebp + arg_8]            # 00432711
    imul eax, eax, 0x8d                          # 00432715
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043271b
    add ecx, 0x296                               # 00432721
    push ecx                                     # 00432727
    mov ecx, 0x5c3a67                            # 00432728
    call FUN_004fba69                            # 0043272d
    mov dword ptr [0x5b51ff], 0x0                # 00432732
    movsx edx, word ptr [ebp + arg_8]            # 0043273c
    imul edx, edx, 0x8d                          # 00432740
    mov dword ptr [edx + 0x5bb632], 0x2          # 00432746
L_00432750:
    # block 0x00432750: entered by ja at 0x00431d53; jmp at 0x004320e2; jmp at 0x00432182; jmp at 0x004321e8; more, 1 instruction(s), ends with forward jump to 0x00432cec
    jmp.d32 L_00432cec                           # 00432750
L_00432755:
    # block 0x00432755: entered by je at 0x00431b89, 8 instruction(s), calls FUN_004c2dfb, ends with je to 0x00432798 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00432755
    mov byte ptr [0x5b51f6], 0x0                 # 0043275f
    push 0x5d03df                                # 00432766
    mov ecx, 0x5cf659                            # 0043276b
    call FUN_004c2dfb                            # 00432770
    mov dword ptr [0x5d1b6d], 0x0                # 00432775
    cmp dword ptr [0x5b51ff], 0x0                # 0043277f
    je.d8 L_00432798                             # 00432786
    # block 0x00432788: entered by fall-through of je at 0x00432786, 4 instruction(s), calls FUN_004fba69, falls into the block at 0x00432798
    mov eax, dword ptr [0x5b51ff]                # 00432788
    push eax                                     # 0043278d
    mov ecx, 0x5c3a67                            # 0043278e
    call FUN_004fba69                            # 00432793
L_00432798:
    # block 0x00432798: entered by je at 0x00432786, 4 instruction(s), ends with je to 0x00432928 (forward)
    {load} xor ecx, ecx                          # 00432798
    mov cl, byte ptr [0x5b51f9]                  # 0043279a
    test ecx, ecx                                # 004327a0
    je.d32 L_00432928                            # 004327a2
    # block 0x004327a8: entered by fall-through of je at 0x004327a2, 6 instruction(s), ends with je to 0x004328d2 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004327a8
    imul edx, edx, 0x8d                          # 004327ac
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004327b2
    movsx ecx, word ptr [eax + field_5fd]        # 004327b8
    cmp ecx, 0x270f                              # 004327bf
    je.d32 L_004328d2                            # 004327c5
    # block 0x004327cb: entered by fall-through of je at 0x004327c5, 41 instruction(s), ends with jne to 0x004328be (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004327cb
    imul edx, edx, 0x8d                          # 004327cf
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004327d5
    movsx ecx, word ptr [eax + field_5fd]        # 004327db
    mov dword ptr [0x5bb57b], ecx                # 004327e2
    movsx edx, word ptr [ebp + arg_8]            # 004327e8
    imul edx, edx, 0x8d                          # 004327ec
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004327f2
    mov cx, word ptr [eax + field_5ff]           # 004327f8
    mov word ptr [0x5bb599], cx                  # 004327ff
    movsx edx, word ptr [ebp + arg_8]            # 00432806
    imul edx, edx, 0x8d                          # 0043280a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432810
    mov cx, word ptr [eax + field_601]           # 00432816
    mov word ptr [0x5bb595], cx                  # 0043281d
    movsx edx, word ptr [ebp + arg_8]            # 00432824
    imul edx, edx, 0x8d                          # 00432828
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043282e
    mov cx, word ptr [eax + field_603]           # 00432834
    mov word ptr [0x5c39ff], cx                  # 0043283b
    movsx edx, word ptr [ebp + arg_8]            # 00432842
    imul edx, edx, 0x8d                          # 00432846
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043284c
    mov ecx, dword ptr [eax + field_605]         # 00432852
    mov dword ptr [0x5bb59b], ecx                # 00432858
    movsx edx, word ptr [ebp + arg_8]            # 0043285e
    imul edx, edx, 0x8d                          # 00432862
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432868
    mov ecx, dword ptr [eax + field_609]         # 0043286e
    mov dword ptr [0x5bb59f], ecx                # 00432874
    movsx edx, word ptr [ebp + arg_8]            # 0043287a
    imul edx, edx, 0x8d                          # 0043287e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432884
    mov ecx, dword ptr [eax + field_60d]         # 0043288a
    mov dword ptr [0x5bb5a3], ecx                # 00432890
    movsx edx, word ptr [ebp + arg_8]            # 00432896
    imul edx, edx, 0x8d                          # 0043289a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004328a0
    movsx ecx, word ptr [eax + field_611]        # 004328a6
    cmp ecx, 0x1                                 # 004328ad
    jne.d8 L_004328be                            # 004328b0
    # block 0x004328b2: entered by fall-through of jne at 0x004328b0, 2 instruction(s), ends with forward jump to 0x004328c8
    mov dword ptr [0x5bb1ca], 0x0                # 004328b2
    jmp.d8 L_004328c8                            # 004328bc
L_004328be:
    # block 0x004328be: entered by jne at 0x004328b0, 1 instruction(s), falls into the block at 0x004328c8
    mov dword ptr [0x5bb1ca], 0x1                # 004328be
L_004328c8:
    # block 0x004328c8: entered by jmp at 0x004328bc, 1 instruction(s), falls into the block at 0x004328d2
    mov dword ptr [0x583999], 0x4                # 004328c8
L_004328d2:
    # block 0x004328d2: entered by je at 0x004327c5, 6 instruction(s), ends with je to 0x00432923 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004328d2
    imul edx, edx, 0x8d                          # 004328d6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004328dc
    movsx ecx, word ptr [eax + field_613]        # 004328e2
    cmp ecx, -0x1                                # 004328e9
    je.d8 L_00432923                             # 004328ec
    # block 0x004328ee: entered by fall-through of je at 0x004328ec, 9 instruction(s), falls into the block at 0x00432923
    movsx edx, word ptr [ebp + arg_8]            # 004328ee
    imul edx, edx, 0x8d                          # 004328f2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004328f8
    movsx ecx, word ptr [eax + field_615]        # 004328fe
    movsx edx, word ptr [ebp + arg_8]            # 00432905
    imul edx, edx, 0x8d                          # 00432909
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043290f
    movsx edx, word ptr [eax + field_613]        # 00432915
    mov dword ptr [4*edx + 0x585801], ecx        # 0043291c
L_00432923:
    # block 0x00432923: entered by je at 0x004328ec, 1 instruction(s), ends with forward jump to 0x00432cdf
    jmp.d32 L_00432cdf                           # 00432923
L_00432928:
    # block 0x00432928: entered by je at 0x004327a2, 4 instruction(s), ends with je to 0x00432aaf (forward)
    {load} xor eax, eax                          # 00432928
    mov al, byte ptr [0x5b51fa]                  # 0043292a
    test eax, eax                                # 0043292f
    je.d32 L_00432aaf                            # 00432931
    # block 0x00432937: entered by fall-through of je at 0x00432931, 6 instruction(s), ends with je to 0x00432a59 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00432937
    imul ecx, ecx, 0x8d                          # 0043293b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432941
    movsx eax, word ptr [edx + field_5e3]        # 00432947
    cmp eax, 0x270f                              # 0043294e
    je.d32 L_00432a59                            # 00432953
    # block 0x00432959: entered by fall-through of je at 0x00432953, 41 instruction(s), ends with jne to 0x00432a45 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00432959
    imul ecx, ecx, 0x8d                          # 0043295d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432963
    movsx eax, word ptr [edx + field_5e3]        # 00432969
    mov dword ptr [0x5bb57b], eax                # 00432970
    movsx ecx, word ptr [ebp + arg_8]            # 00432975
    imul ecx, ecx, 0x8d                          # 00432979
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043297f
    mov ax, word ptr [edx + field_5e5]           # 00432985
    mov word ptr [0x5bb599], ax                  # 0043298c
    movsx ecx, word ptr [ebp + arg_8]            # 00432992
    imul ecx, ecx, 0x8d                          # 00432996
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043299c
    mov ax, word ptr [edx + field_5e7]           # 004329a2
    mov word ptr [0x5bb595], ax                  # 004329a9
    movsx ecx, word ptr [ebp + arg_8]            # 004329af
    imul ecx, ecx, 0x8d                          # 004329b3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004329b9
    mov ax, word ptr [edx + field_5e9]           # 004329bf
    mov word ptr [0x5c39ff], ax                  # 004329c6
    movsx ecx, word ptr [ebp + arg_8]            # 004329cc
    imul ecx, ecx, 0x8d                          # 004329d0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004329d6
    mov eax, dword ptr [edx + field_5eb]         # 004329dc
    mov dword ptr [0x5bb59b], eax                # 004329e2
    movsx ecx, word ptr [ebp + arg_8]            # 004329e7
    imul ecx, ecx, 0x8d                          # 004329eb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004329f1
    mov eax, dword ptr [edx + field_5ef]         # 004329f7
    mov dword ptr [0x5bb59f], eax                # 004329fd
    movsx ecx, word ptr [ebp + arg_8]            # 00432a02
    imul ecx, ecx, 0x8d                          # 00432a06
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432a0c
    mov eax, dword ptr [edx + field_5f3]         # 00432a12
    mov dword ptr [0x5bb5a3], eax                # 00432a18
    movsx ecx, word ptr [ebp + arg_8]            # 00432a1d
    imul ecx, ecx, 0x8d                          # 00432a21
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432a27
    movsx eax, word ptr [edx + field_5f7]        # 00432a2d
    cmp eax, 0x1                                 # 00432a34
    jne.d8 L_00432a45                            # 00432a37
    # block 0x00432a39: entered by fall-through of jne at 0x00432a37, 2 instruction(s), ends with forward jump to 0x00432a4f
    mov dword ptr [0x5bb1ca], 0x0                # 00432a39
    jmp.d8 L_00432a4f                            # 00432a43
L_00432a45:
    # block 0x00432a45: entered by jne at 0x00432a37, 1 instruction(s), falls into the block at 0x00432a4f
    mov dword ptr [0x5bb1ca], 0x1                # 00432a45
L_00432a4f:
    # block 0x00432a4f: entered by jmp at 0x00432a43, 1 instruction(s), falls into the block at 0x00432a59
    mov dword ptr [0x583999], 0x4                # 00432a4f
L_00432a59:
    # block 0x00432a59: entered by je at 0x00432953, 6 instruction(s), ends with je to 0x00432aaa (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00432a59
    imul ecx, ecx, 0x8d                          # 00432a5d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432a63
    movsx eax, word ptr [edx + field_5f9]        # 00432a69
    cmp eax, -0x1                                # 00432a70
    je.d8 L_00432aaa                             # 00432a73
    # block 0x00432a75: entered by fall-through of je at 0x00432a73, 9 instruction(s), falls into the block at 0x00432aaa
    movsx ecx, word ptr [ebp + arg_8]            # 00432a75
    imul ecx, ecx, 0x8d                          # 00432a79
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432a7f
    movsx eax, word ptr [edx + field_5fb]        # 00432a85
    movsx ecx, word ptr [ebp + arg_8]            # 00432a8c
    imul ecx, ecx, 0x8d                          # 00432a90
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432a96
    movsx ecx, word ptr [edx + field_5f9]        # 00432a9c
    mov dword ptr [4*ecx + 0x585801], eax        # 00432aa3
L_00432aaa:
    # block 0x00432aaa: entered by je at 0x00432a73, 1 instruction(s), ends with forward jump to 0x00432cdf
    jmp.d32 L_00432cdf                           # 00432aaa
L_00432aaf:
    # block 0x00432aaf: entered by je at 0x00432931, 3 instruction(s), ends with je to 0x00432cdf (forward)
    movsx edx, word ptr [0x5b51f4]               # 00432aaf
    cmp edx, -0x1                                # 00432ab6
    je.d32 L_00432cdf                            # 00432ab9
    # block 0x00432abf: entered by fall-through of je at 0x00432ab9, 8 instruction(s), ends with je to 0x00432c64 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00432abf
    imul eax, eax, 0x8d                          # 00432ac3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432ac9
    movsx edx, word ptr [0x5b51f4]               # 00432acf
    imul edx, edx, 0x10e                         # 00432ad6
    movsx eax, word ptr [ecx + edx + field_71d]  # 00432adc
    cmp eax, 0x270f                              # 00432ae4
    je.d32 L_00432c64                            # 00432ae9
    # block 0x00432aef: entered by fall-through of je at 0x00432ae9, 57 instruction(s), ends with jne to 0x00432c50 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00432aef
    imul ecx, ecx, 0x8d                          # 00432af3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432af9
    movsx eax, word ptr [0x5b51f4]               # 00432aff
    imul eax, eax, 0x10e                         # 00432b06
    movsx ecx, word ptr [edx + eax + field_71d]  # 00432b0c
    mov dword ptr [0x5bb57b], ecx                # 00432b14
    movsx edx, word ptr [ebp + arg_8]            # 00432b1a
    imul edx, edx, 0x8d                          # 00432b1e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432b24
    movsx ecx, word ptr [0x5b51f4]               # 00432b2a
    imul ecx, ecx, 0x10e                         # 00432b31
    mov dx, word ptr [eax + ecx + field_71f]     # 00432b37
    mov word ptr [0x5bb599], dx                  # 00432b3f
    movsx eax, word ptr [ebp + arg_8]            # 00432b46
    imul eax, eax, 0x8d                          # 00432b4a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432b50
    movsx edx, word ptr [0x5b51f4]               # 00432b56
    imul edx, edx, 0x10e                         # 00432b5d
    mov ax, word ptr [ecx + edx + field_721]     # 00432b63
    mov word ptr [0x5bb595], ax                  # 00432b6b
    movsx ecx, word ptr [ebp + arg_8]            # 00432b71
    imul ecx, ecx, 0x8d                          # 00432b75
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432b7b
    movsx eax, word ptr [0x5b51f4]               # 00432b81
    imul eax, eax, 0x10e                         # 00432b88
    mov cx, word ptr [edx + eax + field_723]     # 00432b8e
    mov word ptr [0x5c39ff], cx                  # 00432b96
    movsx edx, word ptr [ebp + arg_8]            # 00432b9d
    imul edx, edx, 0x8d                          # 00432ba1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432ba7
    movsx ecx, word ptr [0x5b51f4]               # 00432bad
    imul ecx, ecx, 0x10e                         # 00432bb4
    mov edx, dword ptr [eax + ecx + field_725]   # 00432bba
    mov dword ptr [0x5bb59b], edx                # 00432bc1
    movsx eax, word ptr [ebp + arg_8]            # 00432bc7
    imul eax, eax, 0x8d                          # 00432bcb
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432bd1
    movsx edx, word ptr [0x5b51f4]               # 00432bd7
    imul edx, edx, 0x10e                         # 00432bde
    mov eax, dword ptr [ecx + edx + field_729]   # 00432be4
    mov dword ptr [0x5bb59f], eax                # 00432beb
    movsx ecx, word ptr [ebp + arg_8]            # 00432bf0
    imul ecx, ecx, 0x8d                          # 00432bf4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432bfa
    movsx eax, word ptr [0x5b51f4]               # 00432c00
    imul eax, eax, 0x10e                         # 00432c07
    mov ecx, dword ptr [edx + eax + field_72d]   # 00432c0d
    mov dword ptr [0x5bb5a3], ecx                # 00432c14
    movsx edx, word ptr [ebp + arg_8]            # 00432c1a
    imul edx, edx, 0x8d                          # 00432c1e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432c24
    movsx ecx, word ptr [0x5b51f4]               # 00432c2a
    imul ecx, ecx, 0x10e                         # 00432c31
    movsx edx, word ptr [eax + ecx + field_731]  # 00432c37
    cmp edx, 0x1                                 # 00432c3f
    jne.d8 L_00432c50                            # 00432c42
    # block 0x00432c44: entered by fall-through of jne at 0x00432c42, 2 instruction(s), ends with forward jump to 0x00432c5a
    mov dword ptr [0x5bb1ca], 0x0                # 00432c44
    jmp.d8 L_00432c5a                            # 00432c4e
L_00432c50:
    # block 0x00432c50: entered by jne at 0x00432c42, 1 instruction(s), falls into the block at 0x00432c5a
    mov dword ptr [0x5bb1ca], 0x1                # 00432c50
L_00432c5a:
    # block 0x00432c5a: entered by jmp at 0x00432c4e, 1 instruction(s), falls into the block at 0x00432c64
    mov dword ptr [0x583999], 0x4                # 00432c5a
L_00432c64:
    # block 0x00432c64: entered by je at 0x00432ae9, 8 instruction(s), ends with je to 0x00432cdf (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00432c64
    imul eax, eax, 0x8d                          # 00432c68
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00432c6e
    movsx edx, word ptr [0x5b51f4]               # 00432c74
    imul edx, edx, 0x10e                         # 00432c7b
    movsx eax, word ptr [ecx + edx + field_733]  # 00432c81
    cmp eax, -0x1                                # 00432c89
    je.d8 L_00432cdf                             # 00432c8c
    # block 0x00432c8e: entered by fall-through of je at 0x00432c8c, 13 instruction(s), falls into the block at 0x00432cdf
    movsx ecx, word ptr [ebp + arg_8]            # 00432c8e
    imul ecx, ecx, 0x8d                          # 00432c92
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00432c98
    movsx eax, word ptr [0x5b51f4]               # 00432c9e
    imul eax, eax, 0x10e                         # 00432ca5
    movsx ecx, word ptr [edx + eax + field_735]  # 00432cab
    movsx edx, word ptr [ebp + arg_8]            # 00432cb3
    imul edx, edx, 0x8d                          # 00432cb7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00432cbd
    movsx edx, word ptr [0x5b51f4]               # 00432cc3
    imul edx, edx, 0x10e                         # 00432cca
    movsx eax, word ptr [eax + edx + field_733]  # 00432cd0
    mov dword ptr [4*eax + 0x585801], ecx        # 00432cd8
L_00432cdf:
    # block 0x00432cdf: entered by jmp at 0x00432923; jmp at 0x00432aaa; je at 0x00432ab9; je at 0x00432c8c, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00432cec
    mov cx, word ptr [ebp + arg_8]               # 00432cdf
    push ecx                                     # 00432ce3
    call FUN_0042ba3a                            # 00432ce4
    add esp, 0x4                                 # 00432ce9
L_00432cec:
    # block 0x00432cec: entered by jmp at 0x00431b8f; jmp at 0x00431d41; jmp at 0x00432750, 5 instruction(s), ends with ret
    pop edi                                      # 00432cec
    pop esi                                      # 00432ced
    {load} mov esp, ebp                          # 00432cee
    pop ebp                                      # 00432cf0
    ret                                          # 00432cf1

# --- data items (not part of the function) -------------------------
.org 0x00432cf2 - 0x401000
SWTAB_00432cf2:  # 10 case address(es)
    .long L_00431d63 - .text + 0x401000
    .long L_00431da3 - .text + 0x401000
    .long L_004320e7 - .text + 0x401000
    .long L_00432187 - .text + 0x401000
    .long L_004321ed - .text + 0x401000
    .long L_00432475 - .text + 0x401000
    .long L_004324e5 - .text + 0x401000
    .long L_004325c9 - .text + 0x401000
    .long L_00432640 - .text + 0x401000
    .long L_004326e5 - .text + 0x401000
.set SWTAB_00432cf2_VA, SWTAB_00432cf2 - .text + 0x401000

