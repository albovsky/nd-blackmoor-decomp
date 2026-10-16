# FUN_004899ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004899ca
# extent:       0x004899ca-0x0048a3cb (2561 code bytes)
# span:         0x004899ca-0x0048a3cb (code 2561, tables 0, padding 0)
# sha256:       24525b7f7229a0202c810a031853f6a88ee033ac1e07b4d3c58bb87c755b1d66
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004899ca
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_2c, local_50, local_54, local_58, local_5c, local_60, local_64, local_68, local_6c, local_70 and 6 more
# fields:       [eax + n] field_1c, field_20, field_21, field_25, field_28, field_29, field_2d, field_2f, field_33, field_35, field_3d, field_3f and 15 more; [ecx + n] field_1, field_1c, field_20, field_27, field_28, field_2d, field_2f, field_33, field_35, field_37, field_51, field_9a and 5 more; [edx + n] field_1, field_1c, field_20, field_29, field_2c, field_2d, field_2f, field_31, field_35, field_39, field_3b, field_51 and 8 more
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, FUN_004c97b4, FUN_004fb77a, FUN_004fb2e3, FUN_004d36ed, FUN_0050d0bc, FUN_004c948f, FUN_004c2790, FUN_004d39f9, FUN_0050ce04, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/action_family_36_runtime.c:overlay36_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 665 instruction(s), 48 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_2c, 0x2c  # offset -0x2c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_71, 0x71  # offset -0x71
.equ local_72, 0x72  # offset -0x72
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_29, 0x29  # offset +0x29
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_37, 0x37  # offset +0x37
.equ field_39, 0x39  # offset +0x39
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3d, 0x3d  # offset +0x3d
.equ field_3f, 0x3f  # offset +0x3f
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_9a, 0x9a  # offset +0x9a
.equ field_aa, 0xaa  # offset +0xaa
.equ field_cc, 0xcc  # offset +0xcc
.equ field_6ec, 0x6ec  # offset +0x6ec
.equ field_aa2, 0xaa2  # offset +0xaa2
.equ field_aa4, 0xaa4  # offset +0xaa4
.equ field_aa6, 0xaa6  # offset +0xaa6
.equ field_aaa, 0xaaa  # offset +0xaaa
.equ field_aae, 0xaae  # offset +0xaae
.equ field_ab0, 0xab0  # offset +0xab0
.equ field_ab2, 0xab2  # offset +0xab2
.equ field_ab6, 0xab6  # offset +0xab6

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c948f, .text + (0x004c948f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004899ca - 0x401000
.globl FUN_004899ca
FUN_004899ca:
    # block 0x004899ca: entry, 21 instruction(s), ends with je to 0x00489a2c (forward)
    push ebp                                     # 004899ca
    {load} mov ebp, esp                          # 004899cb
    sub esp, 0x84                                # 004899cd
    push esi                                     # 004899d3
    push edi                                     # 004899d4
    mov dword ptr [ebp - local_64], ecx          # 004899d5
    movsx eax, word ptr [ebp + arg_8]            # 004899d8
    imul eax, eax, 0x8d                          # 004899dc
    mov ecx, dword ptr [ebp - local_64]          # 004899e2
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004899e5
    mov dword ptr [ecx + field_1c], edx          # 004899eb
    mov eax, dword ptr [ebp - local_64]          # 004899ee
    mov ecx, dword ptr [ebp - local_64]          # 004899f1
    mov edx, dword ptr [ecx + field_1c]          # 004899f4
    mov dword ptr [eax + field_20], edx          # 004899f7
    movsx eax, word ptr [ebp + arg_8]            # 004899fa
    imul eax, eax, 0x8d                          # 004899fe
    mov ecx, dword ptr [eax + 0x5bb632]          # 00489a04
    mov dword ptr [ebp - local_68], ecx          # 00489a0a
    cmp dword ptr [ebp - local_68], 0x0          # 00489a0d
    je.d8 L_00489a2c                             # 00489a11
    # block 0x00489a13: entered by fall-through of je at 0x00489a11, 2 instruction(s), ends with je to 0x00489fa5 (forward)
    cmp dword ptr [ebp - local_68], 0x1          # 00489a13
    je.d32 L_00489fa5                            # 00489a17
    # block 0x00489a1d: entered by fall-through of je at 0x00489a17, 2 instruction(s), ends with je to 0x0048a27e (forward)
    cmp dword ptr [ebp - local_68], 0x2          # 00489a1d
    je.d32 L_0048a27e                            # 00489a21
    # block 0x00489a27: entered by fall-through of je at 0x00489a21, 1 instruction(s), ends with forward jump to 0x0048a3c3
    jmp.d32 L_0048a3c3                           # 00489a27
L_00489a2c:
    # block 0x00489a2c: entered by je at 0x00489a11, 23 instruction(s), ends with jl to 0x00489ae4 (forward)
    mov edx, dword ptr [ebp - local_64]          # 00489a2c
    mov eax, dword ptr [edx + field_1c]          # 00489a2f
    mov cx, word ptr [ebp + arg_8]               # 00489a32
    mov word ptr [eax + field_ab0], cx           # 00489a36
    mov edx, dword ptr [ebp - local_64]          # 00489a3d
    mov eax, dword ptr [edx + field_1c]          # 00489a40
    mov word ptr [eax + field_aa2], 0xffff       # 00489a43
    mov ecx, dword ptr [ebp - local_64]          # 00489a4c
    mov edx, dword ptr [ecx + field_1c]          # 00489a4f
    mov word ptr [edx + field_aa4], 0xffff       # 00489a52
    mov eax, dword ptr [ebp - local_64]          # 00489a5b
    mov ecx, dword ptr [eax + field_1c]          # 00489a5e
    mov dword ptr [ecx + field_aaa], 0x0         # 00489a61
    mov edx, dword ptr [ebp - local_64]          # 00489a6b
    mov eax, dword ptr [edx + field_1c]          # 00489a6e
    mov word ptr [eax + field_aae], 0x0          # 00489a71
    mov dword ptr [ebp - local_54], 0x0          # 00489a7a
    mov ecx, dword ptr [ebp - local_64]          # 00489a81
    mov edx, dword ptr [ecx + field_1c]          # 00489a84
    mov dword ptr [edx + field_ab2], 0x1         # 00489a87
    mov eax, dword ptr [ebp - local_64]          # 00489a91
    cmp dword ptr [eax + field_cc], 0x28         # 00489a94
    jl.d8 L_00489ae4                             # 00489a9b
    # block 0x00489a9d: entered by fall-through of jl at 0x00489a9b, 9 instruction(s), calls FUN_0050ca3e, ends with je to 0x00489acc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00489a9d
    push ecx                                     # 00489aa1
    push 0x54e0e4                                # 00489aa2
    push 0x63888b                                # 00489aa7
    call FUN_0050ca3e                            # 00489aac
    add esp, 0xc                                 # 00489ab1
    movsx edx, word ptr [0x63a4cd]               # 00489ab4
    test edx, edx                                # 00489abb
    je.d8 L_00489acc                             # 00489abd
    # block 0x00489abf: entered by fall-through of je at 0x00489abd, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00489acc
    push 0x63888b                                # 00489abf
    call FUN_0044a2b7                            # 00489ac4
    add esp, 0x4                                 # 00489ac9
L_00489acc:
    # block 0x00489acc: entered by je at 0x00489abd, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00489ae4
    push 0x0                                     # 00489acc
    push 0x0                                     # 00489ace
    push 0x63888b                                # 00489ad0
    call FUN_0052139c                            # 00489ad5
    mov ecx, 0x5cf659                            # 00489ada
    call FUN_004c97b4                            # 00489adf
L_00489ae4:
    # block 0x00489ae4: entered by jl at 0x00489a9b, 19 instruction(s), ends with je to 0x00489b54 (forward)
    mov eax, dword ptr [ebp - local_64]          # 00489ae4
    mov ecx, dword ptr [eax + field_cc]          # 00489ae7
    mov edx, dword ptr [ebp - local_64]          # 00489aed
    mov eax, dword ptr [ebp - local_64]          # 00489af0
    mov eax, dword ptr [eax + field_1c]          # 00489af3
    mov dword ptr [edx + 4*ecx + field_2c], eax  # 00489af6
    mov ecx, dword ptr [ebp - local_64]          # 00489afa
    mov edx, dword ptr [ecx + field_cc]          # 00489afd
    add edx, 0x1                                 # 00489b03
    mov eax, dword ptr [ebp - local_64]          # 00489b06
    mov dword ptr [eax + field_cc], edx          # 00489b09
    mov edi, 0x54e148                            # 00489b0f
    mov ecx, dword ptr [ebp - local_64]          # 00489b14
    mov esi, dword ptr [ecx + field_20]          # 00489b17
    add esi, 0x79                                # 00489b1a
    mov ecx, 0x9                                 # 00489b1d
    {load} xor edx, edx                          # 00489b22
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00489b24
    je.d8 L_00489b54                             # 00489b26
    # block 0x00489b28: entered by fall-through of je at 0x00489b26, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00489b54
    mov eax, dword ptr [ebp - local_64]          # 00489b28
    mov ecx, dword ptr [eax + field_20]          # 00489b2b
    add ecx, 0x79                                # 00489b2e
    push ecx                                     # 00489b31
    mov ecx, 0x5c3a67                            # 00489b32
    call FUN_004fb77a                            # 00489b37
    mov edx, dword ptr [ebp - local_64]          # 00489b3c
    mov eax, dword ptr [edx + field_20]          # 00489b3f
    mov cx, word ptr [eax + field_9a]            # 00489b42
    push ecx                                     # 00489b49
    mov ecx, 0x5c3a67                            # 00489b4a
    call FUN_004fb2e3                            # 00489b4f
L_00489b54:
    # block 0x00489b54: entered by je at 0x00489b26, 7 instruction(s), calls FUN_004d36ed, ends with forward jump to 0x00489b8b
    mov dword ptr [0x5bb1ca], 0x1                # 00489b54
    call FUN_004d36ed                            # 00489b5e
    movsx edx, word ptr [ebp + arg_8]            # 00489b63
    imul edx, edx, 0x8d                          # 00489b67
    mov dword ptr [edx + 0x5bb626], 0x0          # 00489b6d
    mov word ptr [ebp - local_8], 0x18           # 00489b77
    jmp.d8 L_00489b8b                            # 00489b7d
L_00489b7f:
    # block 0x00489b7f: entered by jmp at 0x00489cf7, 3 instruction(s), falls into the block at 0x00489b8b
    mov ax, word ptr [ebp - local_8]             # 00489b7f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00489b83
    mov word ptr [ebp - local_8], ax             # 00489b87
L_00489b8b:
    # block 0x00489b8b: entered by jmp at 0x00489b7d, 3 instruction(s), ends with jg to 0x00489cfc (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00489b8b
    cmp ecx, 0x3f                                # 00489b8f
    jg.d32 L_00489cfc                            # 00489b92
    # block 0x00489b98: entered by fall-through of jg at 0x00489b92, 4 instruction(s), ends with je to 0x00489cf7 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00489b98
    imul edx, edx, 0x4a                          # 00489b9c
    cmp dword ptr [edx + 0x5d15a9], 0x0          # 00489b9f
    je.d32 L_00489cf7                            # 00489ba6
    # block 0x00489bac: entered by fall-through of je at 0x00489ba6, 8 instruction(s), ends with jne to 0x00489cf7 (forward)
    mov edi, 0x54e154                            # 00489bac
    movsx esi, word ptr [ebp - local_8]          # 00489bb1
    imul esi, esi, 0x4a                          # 00489bb5
    add esi, 0x5d15b3                            # 00489bb8
    mov ecx, 0x10                                # 00489bbe
    {load} xor eax, eax                          # 00489bc3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00489bc5
    jne.d32 L_00489cf7                           # 00489bc7
    # block 0x00489bcd: entered by fall-through of jne at 0x00489bc7, 27 instruction(s), calls FUN_0050d0bc, falls into the block at 0x00489c20
    mov ecx, dword ptr [ebp - local_64]          # 00489bcd
    mov esi, dword ptr [ecx + field_1c]          # 00489bd0
    mov ecx, 0x8                                 # 00489bd3
    lea edi, [ebp - local_50]                    # 00489bd8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489bdb
    movsb byte ptr es:[edi], byte ptr [esi]      # 00489bdd
    movsx edx, word ptr [ebp - local_8]          # 00489bde
    imul edx, edx, 0x4a                          # 00489be2
    mov eax, dword ptr [edx + 0x5d15af]          # 00489be5
    mov dword ptr [ebp - local_5c], eax          # 00489beb
    mov ecx, 0x8                                 # 00489bee
    mov esi, dword ptr [ebp - local_5c]          # 00489bf3
    lea edi, [ebp - local_2c]                    # 00489bf6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489bf9
    movsb byte ptr es:[edi], byte ptr [esi]      # 00489bfb
    lea ecx, [ebp - local_50]                    # 00489bfc
    push ecx                                     # 00489bff
    call FUN_0050d0bc                            # 00489c00
    add esp, 0x4                                 # 00489c05
    lea edx, [ebp - local_2c]                    # 00489c08
    push edx                                     # 00489c0b
    call FUN_0050d0bc                            # 00489c0c
    add esp, 0x4                                 # 00489c11
    lea eax, [ebp - local_50]                    # 00489c14
    mov dword ptr [ebp - local_6c], eax          # 00489c17
    lea ecx, [ebp - local_2c]                    # 00489c1a
    mov dword ptr [ebp - local_70], ecx          # 00489c1d
L_00489c20:
    # block 0x00489c20: entered by jne at 0x00489c52, 6 instruction(s), ends with jne to 0x00489c5d (forward)
    mov edx, dword ptr [ebp - local_70]          # 00489c20
    mov al, byte ptr [edx]                       # 00489c23
    mov byte ptr [ebp - local_71], al            # 00489c25
    mov ecx, dword ptr [ebp - local_6c]          # 00489c28
    cmp al, byte ptr [ecx]                       # 00489c2b
    jne.d8 L_00489c5d                            # 00489c2d
    # block 0x00489c2f: entered by fall-through of jne at 0x00489c2d, 2 instruction(s), ends with je to 0x00489c54 (forward)
    cmp byte ptr [ebp - local_71], 0x0           # 00489c2f
    je.d8 L_00489c54                             # 00489c33
    # block 0x00489c35: entered by fall-through of je at 0x00489c33, 6 instruction(s), ends with jne to 0x00489c5d (forward)
    mov edx, dword ptr [ebp - local_70]          # 00489c35
    mov al, byte ptr [edx + field_1]             # 00489c38
    mov byte ptr [ebp - local_72], al            # 00489c3b
    mov ecx, dword ptr [ebp - local_6c]          # 00489c3e
    cmp al, byte ptr [ecx + field_1]             # 00489c41
    jne.d8 L_00489c5d                            # 00489c44
    # block 0x00489c46: entered by fall-through of jne at 0x00489c44, 4 instruction(s), ends with jne to 0x00489c20 (backward)
    add dword ptr [ebp - local_70], 0x2          # 00489c46
    add dword ptr [ebp - local_6c], 0x2          # 00489c4a
    cmp byte ptr [ebp - local_72], 0x0           # 00489c4e
    jne.d8 L_00489c20                            # 00489c52
L_00489c54:
    # block 0x00489c54: entered by je at 0x00489c33; fall-through of jne at 0x00489c52, 2 instruction(s), ends with forward jump to 0x00489c65
    mov dword ptr [ebp - local_78], 0x0          # 00489c54
    jmp.d8 L_00489c65                            # 00489c5b
L_00489c5d:
    # block 0x00489c5d: entered by jne at 0x00489c2d; jne at 0x00489c44, 3 instruction(s), falls into the block at 0x00489c65
    {load} sbb edx, edx                          # 00489c5d
    sbb edx, -0x1                                # 00489c5f
    mov dword ptr [ebp - local_78], edx          # 00489c62
L_00489c65:
    # block 0x00489c65: entered by jmp at 0x00489c5b, 4 instruction(s), ends with jne to 0x00489cf7 (forward)
    mov eax, dword ptr [ebp - local_78]          # 00489c65
    mov dword ptr [ebp - local_7c], eax          # 00489c68
    cmp dword ptr [ebp - local_7c], 0x0          # 00489c6b
    jne.d32 L_00489cf7                           # 00489c6f
    # block 0x00489c75: entered by fall-through of jne at 0x00489c6f, 2 instruction(s), ends with forward jump to 0x00489c89
    mov word ptr [ebp - local_4], 0x0            # 00489c75
    jmp.d8 L_00489c89                            # 00489c7b
L_00489c7d:
    # block 0x00489c7d: entered by jmp at 0x00489cf5, 3 instruction(s), falls into the block at 0x00489c89
    mov cx, word ptr [ebp - local_4]             # 00489c7d
    add cx, 0x1                                  # 00489c81
    mov word ptr [ebp - local_4], cx             # 00489c85
L_00489c89:
    # block 0x00489c89: entered by jmp at 0x00489c7b, 3 instruction(s), ends with jge to 0x00489cf7 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00489c89
    cmp edx, 0x18                                # 00489c8d
    jge.d8 L_00489cf7                            # 00489c90
    # block 0x00489c92: entered by fall-through of jge at 0x00489c90, 3 instruction(s), ends with je to 0x00489cf5 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00489c92
    cmp dword ptr [4*eax + 0x5d02cb], 0x0        # 00489c96
    je.d8 L_00489cf5                             # 00489c9e
    # block 0x00489ca0: entered by fall-through of je at 0x00489c9e, 6 instruction(s), ends with jne to 0x00489cf5 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00489ca0
    movsx edx, word ptr [ebp - local_8]          # 00489ca4
    imul edx, edx, 0x4a                          # 00489ca8
    mov eax, dword ptr [4*ecx + 0x5d02cb]        # 00489cab
    cmp eax, dword ptr [edx + 0x5d1599]          # 00489cb2
    jne.d8 L_00489cf5                            # 00489cb8
    # block 0x00489cba: entered by fall-through of jne at 0x00489cb8, 12 instruction(s), falls into the block at 0x00489cf5
    mov dword ptr [ebp - local_54], 0x1          # 00489cba
    movsx ecx, word ptr [ebp - local_4]          # 00489cc1
    mov edx, dword ptr [ebp - local_64]          # 00489cc5
    mov eax, dword ptr [edx + field_1c]          # 00489cc8
    mov ecx, dword ptr [4*ecx + 0x5d02cb]        # 00489ccb
    mov dword ptr [eax + field_ab6], ecx         # 00489cd2
    mov edx, dword ptr [ebp - local_64]          # 00489cd8
    mov eax, dword ptr [edx + field_1c]          # 00489cdb
    mov cx, word ptr [ebp - local_4]             # 00489cde
    mov word ptr [eax + field_aa4], cx           # 00489ce2
    mov word ptr [ebp - local_8], 0x40           # 00489ce9
    mov word ptr [ebp - local_4], 0x19           # 00489cef
L_00489cf5:
    # block 0x00489cf5: entered by je at 0x00489c9e; jne at 0x00489cb8, 1 instruction(s), ends with backward jump to 0x00489c7d
    jmp.d8 L_00489c7d                            # 00489cf5
L_00489cf7:
    # block 0x00489cf7: entered by je at 0x00489ba6; jne at 0x00489bc7; jne at 0x00489c6f; jge at 0x00489c90, 1 instruction(s), ends with backward jump to 0x00489b7f
    jmp.d32 L_00489b7f                           # 00489cf7
L_00489cfc:
    # block 0x00489cfc: entered by jg at 0x00489b92, 2 instruction(s), ends with jne to 0x00489de9 (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 00489cfc
    jne.d32 L_00489de9                           # 00489d00
    # block 0x00489d06: entered by fall-through of jne at 0x00489d00, 7 instruction(s), ends with jne to 0x00489d32 (forward)
    mov edi, 0x54e164                            # 00489d06
    mov edx, dword ptr [ebp - local_64]          # 00489d0b
    mov esi, dword ptr [edx + field_20]          # 00489d0e
    mov ecx, 0xe                                 # 00489d11
    {load} xor eax, eax                          # 00489d16
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00489d18
    jne.d8 L_00489d32                            # 00489d1a
    # block 0x00489d1c: entered by fall-through of jne at 0x00489d1a, 5 instruction(s), ends with forward jump to 0x00489de9
    mov ecx, dword ptr [ebp - local_64]          # 00489d1c
    mov edx, dword ptr [ecx + field_1c]          # 00489d1f
    mov eax, dword ptr [0x5d0397]                # 00489d22
    mov dword ptr [edx + field_ab6], eax         # 00489d27
    jmp.d32 L_00489de9                           # 00489d2d
L_00489d32:
    # block 0x00489d32: entered by jne at 0x00489d1a, 7 instruction(s), ends with jne to 0x00489d5f (forward)
    mov edi, 0x54e174                            # 00489d32
    mov ecx, dword ptr [ebp - local_64]          # 00489d37
    mov esi, dword ptr [ecx + field_20]          # 00489d3a
    mov ecx, 0xe                                 # 00489d3d
    {load} xor edx, edx                          # 00489d42
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00489d44
    jne.d8 L_00489d5f                            # 00489d46
    # block 0x00489d48: entered by fall-through of jne at 0x00489d46, 5 instruction(s), ends with forward jump to 0x00489de9
    mov eax, dword ptr [ebp - local_64]          # 00489d48
    mov ecx, dword ptr [eax + field_1c]          # 00489d4b
    mov edx, dword ptr [0x5d039b]                # 00489d4e
    mov dword ptr [ecx + field_ab6], edx         # 00489d54
    jmp.d32 L_00489de9                           # 00489d5a
L_00489d5f:
    # block 0x00489d5f: entered by jne at 0x00489d46, 7 instruction(s), ends with jne to 0x00489d89 (forward)
    mov edi, 0x54e184                            # 00489d5f
    mov eax, dword ptr [ebp - local_64]          # 00489d64
    mov esi, dword ptr [eax + field_20]          # 00489d67
    mov ecx, 0xe                                 # 00489d6a
    {load} xor edx, edx                          # 00489d6f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00489d71
    jne.d8 L_00489d89                            # 00489d73
    # block 0x00489d75: entered by fall-through of jne at 0x00489d73, 5 instruction(s), ends with forward jump to 0x00489de9
    mov eax, dword ptr [ebp - local_64]          # 00489d75
    mov ecx, dword ptr [eax + field_1c]          # 00489d78
    mov edx, dword ptr [0x5d039f]                # 00489d7b
    mov dword ptr [ecx + field_ab6], edx         # 00489d81
    jmp.d8 L_00489de9                            # 00489d87
L_00489d89:
    # block 0x00489d89: entered by jne at 0x00489d73, 23 instruction(s), calls FUN_004c948f, FUN_004c2790, falls into the block at 0x00489de9
    mov ecx, 0x5cf659                            # 00489d89
    call FUN_004c948f                            # 00489d8e
    mov ecx, dword ptr [ebp - local_64]          # 00489d93
    mov edx, dword ptr [ecx + field_1c]          # 00489d96
    mov word ptr [edx + field_aa4], ax           # 00489d99
    push 0x54e194                                # 00489da0
    push 0x6                                     # 00489da5
    mov eax, dword ptr [ebp - local_64]          # 00489da7
    mov ecx, dword ptr [eax + field_20]          # 00489daa
    push ecx                                     # 00489dad
    push 0x54e1b8                                # 00489dae
    mov ecx, 0x5cf659                            # 00489db3
    call FUN_004c2790                            # 00489db8
    mov edx, dword ptr [ebp - local_64]          # 00489dbd
    mov ecx, dword ptr [edx + field_1c]          # 00489dc0
    mov dword ptr [ecx + field_ab6], eax         # 00489dc3
    mov edx, dword ptr [ebp - local_64]          # 00489dc9
    mov eax, dword ptr [edx + field_1c]          # 00489dcc
    mov ecx, dword ptr [ebp - local_64]          # 00489dcf
    mov edx, dword ptr [ecx + field_1c]          # 00489dd2
    movsx ecx, word ptr [edx + field_aa4]        # 00489dd5
    mov edx, dword ptr [eax + field_ab6]         # 00489ddc
    mov dword ptr [4*ecx + 0x5d02cb], edx        # 00489de2
L_00489de9:
    # block 0x00489de9: entered by jne at 0x00489d00; jmp at 0x00489d2d; jmp at 0x00489d5a; jmp at 0x00489d87, 77 instruction(s), calls FUN_004d39f9, ends with jne to 0x00489f91 (forward)
    call FUN_004d39f9                            # 00489de9
    mov ecx, dword ptr [ebp - local_64]          # 00489dee
    mov edx, dword ptr [ecx + field_1c]          # 00489df1
    mov word ptr [edx + field_aa2], ax           # 00489df4
    mov eax, dword ptr [ebp - local_64]          # 00489dfb
    mov ecx, dword ptr [eax + field_20]          # 00489dfe
    movsx edx, word ptr [ecx + field_27]         # 00489e01
    mov eax, dword ptr [ebp - local_64]          # 00489e05
    mov ecx, dword ptr [eax + field_1c]          # 00489e08
    movsx eax, word ptr [ecx + field_aa2]        # 00489e0b
    imul eax, eax, 0x4a                          # 00489e12
    mov dword ptr [eax + 0x5d1591], edx          # 00489e15
    mov ecx, dword ptr [ebp - local_64]          # 00489e1b
    mov edx, dword ptr [ecx + field_1c]          # 00489e1e
    movsx eax, word ptr [edx + field_aa2]        # 00489e21
    imul eax, eax, 0x4a                          # 00489e28
    mov dword ptr [eax + 0x5d1595], 0x48a3db     # 00489e2b
    mov ecx, dword ptr [ebp - local_64]          # 00489e35
    mov edx, dword ptr [ecx + field_1c]          # 00489e38
    mov eax, dword ptr [ebp - local_64]          # 00489e3b
    mov ecx, dword ptr [eax + field_1c]          # 00489e3e
    movsx eax, word ptr [ecx + field_aa2]        # 00489e41
    imul eax, eax, 0x4a                          # 00489e48
    mov ecx, dword ptr [edx + field_ab6]         # 00489e4b
    mov dword ptr [eax + 0x5d1599], ecx          # 00489e51
    mov edx, dword ptr [ebp - local_64]          # 00489e57
    mov eax, dword ptr [edx + field_1c]          # 00489e5a
    movsx ecx, word ptr [eax + field_aa2]        # 00489e5d
    imul ecx, ecx, 0x4a                          # 00489e64
    mov dword ptr [ecx + 0x5d159d], 0x0          # 00489e67
    mov edx, dword ptr [ebp - local_64]          # 00489e71
    mov eax, dword ptr [edx + field_1c]          # 00489e74
    movsx ecx, word ptr [eax + field_aa2]        # 00489e77
    imul ecx, ecx, 0x4a                          # 00489e7e
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 00489e81
    mov edx, dword ptr [ebp - local_64]          # 00489e8b
    mov eax, dword ptr [edx + field_1c]          # 00489e8e
    movsx ecx, word ptr [eax + field_aa2]        # 00489e91
    imul ecx, ecx, 0x4a                          # 00489e98
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00489e9b
    mov edx, dword ptr [ebp - local_64]          # 00489ea5
    mov eax, dword ptr [edx + field_1c]          # 00489ea8
    movsx ecx, word ptr [eax + field_aa2]        # 00489eab
    imul ecx, ecx, 0x4a                          # 00489eb2
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 00489eb5
    mov edx, dword ptr [ebp - local_64]          # 00489ebf
    mov eax, dword ptr [edx + field_1c]          # 00489ec2
    movsx ecx, word ptr [eax + field_aa2]        # 00489ec5
    imul ecx, ecx, 0x4a                          # 00489ecc
    mov edx, dword ptr [ebp - local_64]          # 00489ecf
    mov eax, dword ptr [edx + field_1c]          # 00489ed2
    mov dword ptr [ecx + 0x5d15af], eax          # 00489ed5
    mov edi, 0x54e1c0                            # 00489edb
    mov ecx, dword ptr [ebp - local_64]          # 00489ee0
    mov edx, dword ptr [ecx + field_1c]          # 00489ee3
    movsx eax, word ptr [edx + field_aa2]        # 00489ee6
    imul eax, eax, 0x4a                          # 00489eed
    add eax, 0x5d15b3                            # 00489ef0
    {load} mov edx, eax                          # 00489ef5
    or ecx, -0x1                                 # 00489ef7
    {load} xor eax, eax                          # 00489efa
    repne scasb al, byte ptr es:[edi]            # 00489efc
    not ecx                                      # 00489efe
    {load} sub edi, ecx                          # 00489f00
    {load} mov esi, edi                          # 00489f02
    {load} mov eax, ecx                          # 00489f04
    {load} mov edi, edx                          # 00489f06
    shr ecx, 0x2                                 # 00489f08
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489f0b
    {load} mov ecx, eax                          # 00489f0d
    and ecx, 0x3                                 # 00489f0f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00489f12
    mov ecx, dword ptr [ebp - local_64]          # 00489f14
    mov edx, dword ptr [ecx + field_20]          # 00489f17
    movsx eax, word ptr [edx + field_29]         # 00489f1a
    cmp eax, 0x2                                 # 00489f1e
    jne.d8 L_00489f91                            # 00489f21
    # block 0x00489f23: entered by fall-through of jne at 0x00489f21, 26 instruction(s), calls FUN_0050ce04, KERNEL32.dll!GetTickCount, falls into the block at 0x00489f91
    mov ecx, dword ptr [ebp - local_64]          # 00489f23
    mov edx, dword ptr [ecx + field_20]          # 00489f26
    mov eax, dword ptr [ebp - local_64]          # 00489f29
    mov ecx, dword ptr [eax + field_1c]          # 00489f2c
    mov dx, word ptr [edx + field_31]            # 00489f2f
    mov word ptr [ecx + field_aae], dx           # 00489f33
    mov eax, dword ptr [ebp - local_64]          # 00489f3a
    mov ecx, dword ptr [eax + field_20]          # 00489f3d
    movsx edx, word ptr [ecx + field_37]         # 00489f40
    mov dword ptr [ebp - local_80], edx          # 00489f44
    fild dword ptr [ebp - local_80]              # 00489f47
    fstp dword ptr [ebp - local_84]              # 00489f4a
    fld dword ptr [ebp - local_84]               # 00489f50
    fdivr qword ptr [0x52c598]                   # 00489f56
    fmul qword ptr [0x52c590]                    # 00489f5c
    call FUN_0050ce04                            # 00489f62
    mov ecx, dword ptr [ebp - local_64]          # 00489f67
    mov edx, dword ptr [ecx + field_1c]          # 00489f6a
    mov dword ptr [edx + field_aa6], eax         # 00489f6d
    call dword ptr [0x52a23c]                    # 00489f73
    mov ecx, dword ptr [ebp - local_64]          # 00489f79
    mov edx, dword ptr [ecx + field_1c]          # 00489f7c
    add eax, dword ptr [edx + field_aa6]         # 00489f7f
    mov ecx, dword ptr [ebp - local_64]          # 00489f85
    mov edx, dword ptr [ecx + field_1c]          # 00489f88
    mov dword ptr [edx + field_aaa], eax         # 00489f8b
L_00489f91:
    # block 0x00489f91: entered by jne at 0x00489f21, 3 instruction(s), falls into the block at 0x00489fa5
    movsx eax, word ptr [ebp + arg_8]            # 00489f91
    imul eax, eax, 0x8d                          # 00489f95
    mov dword ptr [eax + 0x5bb632], 0x1          # 00489f9b
L_00489fa5:
    # block 0x00489fa5: entered by je at 0x00489a17, 5 instruction(s), ends with je to 0x00489fd5 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 00489fa5
    mov edx, dword ptr [ecx + field_20]          # 00489fa8
    movsx eax, word ptr [edx + field_39]         # 00489fab
    cmp eax, -0x1                                # 00489faf
    je.d8 L_00489fd5                             # 00489fb2
    # block 0x00489fb4: entered by fall-through of je at 0x00489fb2, 8 instruction(s), ends with je to 0x0048a0b2 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 00489fb4
    mov edx, dword ptr [ecx + field_20]          # 00489fb7
    movsx eax, word ptr [edx + field_39]         # 00489fba
    mov ecx, dword ptr [ebp - local_64]          # 00489fbe
    mov edx, dword ptr [ecx + field_20]          # 00489fc1
    movsx ecx, word ptr [edx + field_3b]         # 00489fc4
    cmp dword ptr [4*eax + 0x585801], ecx        # 00489fc8
    je.d32 L_0048a0b2                            # 00489fcf
L_00489fd5:
    # block 0x00489fd5: entered by je at 0x00489fb2; fall-through of je at 0x00489fcf, 5 instruction(s), ends with jne to 0x0048a0cb (forward)
    mov edx, dword ptr [ebp - local_64]          # 00489fd5
    mov eax, dword ptr [edx + field_20]          # 00489fd8
    movsx ecx, word ptr [eax + field_29]         # 00489fdb
    cmp ecx, 0x2                                 # 00489fdf
    jne.d32 L_0048a0cb                           # 00489fe2
    # block 0x00489fe8: entered by fall-through of jne at 0x00489fe2, 8 instruction(s), ends with jne to 0x0048a021 (forward)
    mov edx, dword ptr [ebp - local_64]          # 00489fe8
    mov eax, dword ptr [edx + field_1c]          # 00489feb
    movsx ecx, word ptr [eax + field_aae]        # 00489fee
    mov edx, dword ptr [ebp - local_64]          # 00489ff5
    mov eax, dword ptr [edx + field_20]          # 00489ff8
    movsx edx, word ptr [eax + field_35]         # 00489ffb
    {load} cmp ecx, edx                          # 00489fff
    jne.d8 L_0048a021                            # 0048a001
    # block 0x0048a003: entered by fall-through of jne at 0x0048a001, 5 instruction(s), ends with jne to 0x0048a021 (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a003
    mov ecx, dword ptr [eax + field_20]          # 0048a006
    movsx edx, word ptr [ecx + field_2d]         # 0048a009
    cmp edx, 0x1                                 # 0048a00d
    jne.d8 L_0048a021                            # 0048a010
    # block 0x0048a012: entered by fall-through of jne at 0x0048a010, 5 instruction(s), ends with je to 0x0048a05e (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a012
    mov ecx, dword ptr [eax + field_20]          # 0048a015
    movsx edx, word ptr [ecx + field_2f]         # 0048a018
    cmp edx, 0x1                                 # 0048a01c
    je.d8 L_0048a05e                             # 0048a01f
L_0048a021:
    # block 0x0048a021: entered by jne at 0x0048a001; jne at 0x0048a010; fall-through of je at 0x0048a01f, 8 instruction(s), ends with jne to 0x0048a0cb (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a021
    mov ecx, dword ptr [eax + field_1c]          # 0048a024
    movsx edx, word ptr [ecx + field_aae]        # 0048a027
    mov eax, dword ptr [ebp - local_64]          # 0048a02e
    mov ecx, dword ptr [eax + field_20]          # 0048a031
    movsx eax, word ptr [ecx + field_33]         # 0048a034
    {load} cmp edx, eax                          # 0048a038
    jne.d32 L_0048a0cb                           # 0048a03a
    # block 0x0048a040: entered by fall-through of jne at 0x0048a03a, 5 instruction(s), ends with jne to 0x0048a0cb (forward)
    mov ecx, dword ptr [ebp - local_64]          # 0048a040
    mov edx, dword ptr [ecx + field_20]          # 0048a043
    movsx eax, word ptr [edx + field_2d]         # 0048a046
    cmp eax, 0x2                                 # 0048a04a
    jne.d8 L_0048a0cb                            # 0048a04d
    # block 0x0048a04f: entered by fall-through of jne at 0x0048a04d, 5 instruction(s), ends with jne to 0x0048a0cb (forward)
    mov ecx, dword ptr [ebp - local_64]          # 0048a04f
    mov edx, dword ptr [ecx + field_20]          # 0048a052
    movsx eax, word ptr [edx + field_2f]         # 0048a055
    cmp eax, 0x1                                 # 0048a059
    jne.d8 L_0048a0cb                            # 0048a05c
L_0048a05e:
    # block 0x0048a05e: entered by je at 0x0048a01f; fall-through of jne at 0x0048a05c, 8 instruction(s), ends with je to 0x0048a099 (forward)
    mov edi, 0x54e1d0                            # 0048a05e
    mov ecx, dword ptr [ebp - local_64]          # 0048a063
    mov esi, dword ptr [ecx + field_20]          # 0048a066
    add esi, 0x79                                # 0048a069
    mov ecx, 0x9                                 # 0048a06c
    {load} xor edx, edx                          # 0048a071
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048a073
    je.d8 L_0048a099                             # 0048a075
    # block 0x0048a077: entered by fall-through of je at 0x0048a075, 10 instruction(s), calls FUN_004f6334, ends with je to 0x0048a0b2 (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a077
    mov ecx, dword ptr [eax + field_20]          # 0048a07a
    movsx edx, word ptr [ecx + field_9a]         # 0048a07d
    mov dword ptr [ebp - local_60], edx          # 0048a084
    mov eax, dword ptr [ebp - local_60]          # 0048a087
    push eax                                     # 0048a08a
    mov ecx, 0x5cf1eb                            # 0048a08b
    call FUN_004f6334                            # 0048a090
    test eax, eax                                # 0048a095
    je.d8 L_0048a0b2                             # 0048a097
L_0048a099:
    # block 0x0048a099: entered by je at 0x0048a075; fall-through of je at 0x0048a097, 8 instruction(s), ends with jne to 0x0048a0cb (forward)
    mov edi, 0x54e1dc                            # 0048a099
    mov ecx, dword ptr [ebp - local_64]          # 0048a09e
    mov esi, dword ptr [ecx + field_20]          # 0048a0a1
    add esi, 0x79                                # 0048a0a4
    mov ecx, 0x9                                 # 0048a0a7
    {load} xor edx, edx                          # 0048a0ac
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048a0ae
    jne.d8 L_0048a0cb                            # 0048a0b0
L_0048a0b2:
    # block 0x0048a0b2: entered by je at 0x00489fcf; je at 0x0048a097; fall-through of jne at 0x0048a0b0, 4 instruction(s), ends with forward jump to 0x0048a3c3
    movsx eax, word ptr [ebp + arg_8]            # 0048a0b2
    imul eax, eax, 0x8d                          # 0048a0b6
    mov dword ptr [eax + 0x5bb632], 0x2          # 0048a0bc
    jmp.d32 L_0048a3c3                           # 0048a0c6
L_0048a0cb:
    # block 0x0048a0cb: entered by jne at 0x00489fe2; jne at 0x0048a03a; jne at 0x0048a04d; jne at 0x0048a05c; more, 5 instruction(s), ends with jne to 0x0048a279 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 0048a0cb
    mov edx, dword ptr [ecx + field_20]          # 0048a0ce
    movsx eax, word ptr [edx + field_29]         # 0048a0d1
    cmp eax, 0x2                                 # 0048a0d5
    jne.d32 L_0048a279                           # 0048a0d8
    # block 0x0048a0de: entered by fall-through of jne at 0x0048a0d8, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0048a0fe
    call dword ptr [0x52a23c]                    # 0048a0de
    mov ecx, dword ptr [ebp - local_64]          # 0048a0e4
    mov dword ptr [ecx + field_28], eax          # 0048a0e7
    mov word ptr [ebp - local_58], 0x0           # 0048a0ea
    jmp.d8 L_0048a0fe                            # 0048a0f0
L_0048a0f2:
    # block 0x0048a0f2: entered by jmp at 0x0048a274, 3 instruction(s), falls into the block at 0x0048a0fe
    mov dx, word ptr [ebp - local_58]            # 0048a0f2
    add dx, 0x1                                  # 0048a0f6
    mov word ptr [ebp - local_58], dx            # 0048a0fa
L_0048a0fe:
    # block 0x0048a0fe: entered by jmp at 0x0048a0f0, 6 instruction(s), ends with jge to 0x0048a279 (forward)
    movsx eax, word ptr [ebp - local_58]         # 0048a0fe
    mov ecx, dword ptr [ebp - local_64]          # 0048a102
    mov edx, dword ptr [ecx + field_20]          # 0048a105
    movsx ecx, word ptr [edx + field_aa]         # 0048a108
    {load} cmp eax, ecx                          # 0048a10f
    jge.d32 L_0048a279                           # 0048a111
    # block 0x0048a117: entered by fall-through of jge at 0x0048a111, 8 instruction(s), ends with jne to 0x0048a274 (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a117
    mov eax, dword ptr [edx + field_1c]          # 0048a11a
    movsx ecx, word ptr [ebp - local_58]         # 0048a11d
    imul ecx, ecx, 0x26                          # 0048a121
    movsx edx, word ptr [eax + ecx + field_6ec]  # 0048a124
    movsx eax, word ptr [0x5bb50b]               # 0048a12c
    {load} cmp edx, eax                          # 0048a133
    jne.d32 L_0048a274                           # 0048a135
    # block 0x0048a13b: entered by fall-through of jne at 0x0048a135, 6 instruction(s), ends with jb to 0x0048a272 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 0048a13b
    mov edx, dword ptr [ecx + field_1c]          # 0048a13e
    mov eax, dword ptr [ebp - local_64]          # 0048a141
    mov ecx, dword ptr [eax + field_28]          # 0048a144
    cmp ecx, dword ptr [edx + field_aaa]         # 0048a147
    jb.d32 L_0048a272                            # 0048a14d
    # block 0x0048a153: entered by fall-through of jb at 0x0048a14d, 13 instruction(s), ends with jne to 0x0048a1fa (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a153
    mov eax, dword ptr [edx + field_1c]          # 0048a156
    mov ecx, dword ptr [ebp - local_64]          # 0048a159
    mov edx, dword ptr [ecx + field_28]          # 0048a15c
    add edx, dword ptr [eax + field_aa6]         # 0048a15f
    mov eax, dword ptr [ebp - local_64]          # 0048a165
    mov ecx, dword ptr [eax + field_1c]          # 0048a168
    mov dword ptr [ecx + field_aaa], edx         # 0048a16b
    mov edx, dword ptr [ebp - local_64]          # 0048a171
    mov eax, dword ptr [edx + field_20]          # 0048a174
    movsx ecx, word ptr [eax + field_2d]         # 0048a177
    cmp ecx, 0x1                                 # 0048a17b
    jne.d8 L_0048a1fa                            # 0048a17e
    # block 0x0048a180: entered by fall-through of jne at 0x0048a17e, 15 instruction(s), ends with jle to 0x0048a1f8 (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a180
    mov eax, dword ptr [edx + field_1c]          # 0048a183
    mov cx, word ptr [eax + field_aae]           # 0048a186
    add cx, 0x1                                  # 0048a18d
    mov edx, dword ptr [ebp - local_64]          # 0048a191
    mov eax, dword ptr [edx + field_1c]          # 0048a194
    mov word ptr [eax + field_aae], cx           # 0048a197
    mov ecx, dword ptr [ebp - local_64]          # 0048a19e
    mov edx, dword ptr [ecx + field_1c]          # 0048a1a1
    movsx eax, word ptr [edx + field_aae]        # 0048a1a4
    mov ecx, dword ptr [ebp - local_64]          # 0048a1ab
    mov edx, dword ptr [ecx + field_20]          # 0048a1ae
    movsx ecx, word ptr [edx + field_35]         # 0048a1b1
    {load} cmp eax, ecx                          # 0048a1b5
    jle.d8 L_0048a1f8                            # 0048a1b7
    # block 0x0048a1b9: entered by fall-through of jle at 0x0048a1b7, 5 instruction(s), ends with jne to 0x0048a1e1 (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a1b9
    mov eax, dword ptr [edx + field_20]          # 0048a1bc
    movsx ecx, word ptr [eax + field_2f]         # 0048a1bf
    cmp ecx, 0x2                                 # 0048a1c3
    jne.d8 L_0048a1e1                            # 0048a1c6
    # block 0x0048a1c8: entered by fall-through of jne at 0x0048a1c6, 7 instruction(s), ends with forward jump to 0x0048a1f8
    mov edx, dword ptr [ebp - local_64]          # 0048a1c8
    mov eax, dword ptr [edx + field_20]          # 0048a1cb
    mov ecx, dword ptr [ebp - local_64]          # 0048a1ce
    mov edx, dword ptr [ecx + field_1c]          # 0048a1d1
    mov ax, word ptr [eax + field_33]            # 0048a1d4
    mov word ptr [edx + field_aae], ax           # 0048a1d8
    jmp.d8 L_0048a1f8                            # 0048a1df
L_0048a1e1:
    # block 0x0048a1e1: entered by jne at 0x0048a1c6, 6 instruction(s), falls into the block at 0x0048a1f8
    mov ecx, dword ptr [ebp - local_64]          # 0048a1e1
    mov edx, dword ptr [ecx + field_20]          # 0048a1e4
    mov eax, dword ptr [ebp - local_64]          # 0048a1e7
    mov ecx, dword ptr [eax + field_1c]          # 0048a1ea
    mov dx, word ptr [edx + field_35]            # 0048a1ed
    mov word ptr [ecx + field_aae], dx           # 0048a1f1
L_0048a1f8:
    # block 0x0048a1f8: entered by jle at 0x0048a1b7; jmp at 0x0048a1df, 1 instruction(s), ends with forward jump to 0x0048a272
    jmp.d8 L_0048a272                            # 0048a1f8
L_0048a1fa:
    # block 0x0048a1fa: entered by jne at 0x0048a17e, 15 instruction(s), ends with jge to 0x0048a272 (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a1fa
    mov ecx, dword ptr [eax + field_1c]          # 0048a1fd
    mov dx, word ptr [ecx + field_aae]           # 0048a200
    sub dx, 0x1                                  # 0048a207
    mov eax, dword ptr [ebp - local_64]          # 0048a20b
    mov ecx, dword ptr [eax + field_1c]          # 0048a20e
    mov word ptr [ecx + field_aae], dx           # 0048a211
    mov edx, dword ptr [ebp - local_64]          # 0048a218
    mov eax, dword ptr [edx + field_1c]          # 0048a21b
    movsx ecx, word ptr [eax + field_aae]        # 0048a21e
    mov edx, dword ptr [ebp - local_64]          # 0048a225
    mov eax, dword ptr [edx + field_20]          # 0048a228
    movsx edx, word ptr [eax + field_33]         # 0048a22b
    {load} cmp ecx, edx                          # 0048a22f
    jge.d8 L_0048a272                            # 0048a231
    # block 0x0048a233: entered by fall-through of jge at 0x0048a231, 5 instruction(s), ends with jne to 0x0048a25b (forward)
    mov eax, dword ptr [ebp - local_64]          # 0048a233
    mov ecx, dword ptr [eax + field_20]          # 0048a236
    movsx edx, word ptr [ecx + field_2f]         # 0048a239
    cmp edx, 0x2                                 # 0048a23d
    jne.d8 L_0048a25b                            # 0048a240
    # block 0x0048a242: entered by fall-through of jne at 0x0048a240, 7 instruction(s), ends with forward jump to 0x0048a272
    mov eax, dword ptr [ebp - local_64]          # 0048a242
    mov ecx, dword ptr [eax + field_20]          # 0048a245
    mov edx, dword ptr [ebp - local_64]          # 0048a248
    mov eax, dword ptr [edx + field_1c]          # 0048a24b
    mov cx, word ptr [ecx + field_35]            # 0048a24e
    mov word ptr [eax + field_aae], cx           # 0048a252
    jmp.d8 L_0048a272                            # 0048a259
L_0048a25b:
    # block 0x0048a25b: entered by jne at 0x0048a240, 6 instruction(s), falls into the block at 0x0048a272
    mov edx, dword ptr [ebp - local_64]          # 0048a25b
    mov eax, dword ptr [edx + field_20]          # 0048a25e
    mov ecx, dword ptr [ebp - local_64]          # 0048a261
    mov edx, dword ptr [ecx + field_1c]          # 0048a264
    mov ax, word ptr [eax + field_33]            # 0048a267
    mov word ptr [edx + field_aae], ax           # 0048a26b
L_0048a272:
    # block 0x0048a272: entered by jb at 0x0048a14d; jmp at 0x0048a1f8; jge at 0x0048a231; jmp at 0x0048a259, 1 instruction(s), ends with forward jump to 0x0048a279
    jmp.d8 L_0048a279                            # 0048a272
L_0048a274:
    # block 0x0048a274: entered by jne at 0x0048a135, 1 instruction(s), ends with backward jump to 0x0048a0f2
    jmp.d32 L_0048a0f2                           # 0048a274
L_0048a279:
    # block 0x0048a279: entered by jne at 0x0048a0d8; jge at 0x0048a111; jmp at 0x0048a272, 1 instruction(s), ends with forward jump to 0x0048a3c3
    jmp.d32 L_0048a3c3                           # 0048a279
L_0048a27e:
    # block 0x0048a27e: entered by je at 0x00489a21, 8 instruction(s), ends with je to 0x0048a2ab (forward)
    mov edi, 0x54e1e8                            # 0048a27e
    mov ecx, dword ptr [ebp - local_64]          # 0048a283
    mov esi, dword ptr [ecx + field_20]          # 0048a286
    add esi, 0x79                                # 0048a289
    mov ecx, 0x9                                 # 0048a28c
    {load} xor edx, edx                          # 0048a291
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048a293
    je.d8 L_0048a2ab                             # 0048a295
    # block 0x0048a297: entered by fall-through of je at 0x0048a295, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x0048a2ab
    mov eax, dword ptr [ebp - local_64]          # 0048a297
    mov ecx, dword ptr [eax + field_20]          # 0048a29a
    add ecx, 0x79                                # 0048a29d
    push ecx                                     # 0048a2a0
    mov ecx, 0x5c3a67                            # 0048a2a1
    call FUN_004fba69                            # 0048a2a6
L_0048a2ab:
    # block 0x0048a2ab: entered by je at 0x0048a295, 2 instruction(s), ends with forward jump to 0x0048a2bf
    mov word ptr [ebp - local_8], 0x0            # 0048a2ab
    jmp.d8 L_0048a2bf                            # 0048a2b1
L_0048a2b3:
    # block 0x0048a2b3: entered by jmp at 0x0048a301, 3 instruction(s), falls into the block at 0x0048a2bf
    mov dx, word ptr [ebp - local_8]             # 0048a2b3
    add dx, 0x1                                  # 0048a2b7
    mov word ptr [ebp - local_8], dx             # 0048a2bb
L_0048a2bf:
    # block 0x0048a2bf: entered by jmp at 0x0048a2b1, 3 instruction(s), ends with jge to 0x0048a303 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048a2bf
    cmp eax, 0xa                                 # 0048a2c3
    jge.d8 L_0048a303                            # 0048a2c6
    # block 0x0048a2c8: entered by fall-through of jge at 0x0048a2c6, 6 instruction(s), ends with je to 0x0048a301 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 0048a2c8
    mov edx, dword ptr [ecx + field_20]          # 0048a2cb
    movsx eax, word ptr [ebp - local_8]          # 0048a2ce
    movsx ecx, word ptr [edx + 4*eax + field_51] # 0048a2d2
    cmp ecx, -0x1                                # 0048a2d7
    je.d8 L_0048a301                             # 0048a2da
    # block 0x0048a2dc: entered by fall-through of je at 0x0048a2da, 9 instruction(s), falls into the block at 0x0048a301
    mov edx, dword ptr [ebp - local_64]          # 0048a2dc
    mov eax, dword ptr [edx + field_20]          # 0048a2df
    movsx ecx, word ptr [ebp - local_8]          # 0048a2e2
    movsx edx, word ptr [eax + 4*ecx + field_53] # 0048a2e6
    mov eax, dword ptr [ebp - local_64]          # 0048a2eb
    mov ecx, dword ptr [eax + field_20]          # 0048a2ee
    movsx eax, word ptr [ebp - local_8]          # 0048a2f1
    movsx ecx, word ptr [ecx + 4*eax + field_51] # 0048a2f5
    mov dword ptr [4*ecx + 0x585801], edx        # 0048a2fa
L_0048a301:
    # block 0x0048a301: entered by je at 0x0048a2da, 1 instruction(s), ends with backward jump to 0x0048a2b3
    jmp.d8 L_0048a2b3                            # 0048a301
L_0048a303:
    # block 0x0048a303: entered by jge at 0x0048a2c6, 5 instruction(s), ends with jne to 0x0048a38c (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a303
    mov eax, dword ptr [edx + field_20]          # 0048a306
    movsx ecx, word ptr [eax + field_25]         # 0048a309
    cmp ecx, 0x1                                 # 0048a30d
    jne.d8 L_0048a38c                            # 0048a310
    # block 0x0048a312: entered by fall-through of jne at 0x0048a310, 29 instruction(s), falls into the block at 0x0048a38c
    mov edx, dword ptr [ebp - local_64]          # 0048a312
    mov eax, dword ptr [edx + field_20]          # 0048a315
    movsx ecx, word ptr [eax + field_3d]         # 0048a318
    mov dword ptr [0x5bb57b], ecx                # 0048a31c
    mov edx, dword ptr [ebp - local_64]          # 0048a322
    mov eax, dword ptr [edx + field_20]          # 0048a325
    mov cx, word ptr [eax + field_3f]            # 0048a328
    mov word ptr [0x5bb599], cx                  # 0048a32c
    mov edx, dword ptr [ebp - local_64]          # 0048a333
    mov eax, dword ptr [edx + field_20]          # 0048a336
    mov cx, word ptr [eax + field_41]            # 0048a339
    mov word ptr [0x5bb595], cx                  # 0048a33d
    mov edx, dword ptr [ebp - local_64]          # 0048a344
    mov eax, dword ptr [edx + field_20]          # 0048a347
    mov cx, word ptr [eax + field_43]            # 0048a34a
    mov word ptr [0x5c39ff], cx                  # 0048a34e
    mov edx, dword ptr [ebp - local_64]          # 0048a355
    mov eax, dword ptr [edx + field_20]          # 0048a358
    mov ecx, dword ptr [eax + field_45]          # 0048a35b
    mov dword ptr [0x5bb59b], ecx                # 0048a35e
    mov edx, dword ptr [ebp - local_64]          # 0048a364
    mov eax, dword ptr [edx + field_20]          # 0048a367
    mov ecx, dword ptr [eax + field_49]          # 0048a36a
    mov dword ptr [0x5bb59f], ecx                # 0048a36d
    mov edx, dword ptr [ebp - local_64]          # 0048a373
    mov eax, dword ptr [edx + field_20]          # 0048a376
    mov ecx, dword ptr [eax + field_4d]          # 0048a379
    mov dword ptr [0x5bb5a3], ecx                # 0048a37c
    mov dword ptr [0x583999], 0x4                # 0048a382
L_0048a38c:
    # block 0x0048a38c: entered by jne at 0x0048a310, 5 instruction(s), ends with jne to 0x0048a3a7 (forward)
    mov edx, dword ptr [ebp - local_64]          # 0048a38c
    mov eax, dword ptr [edx + field_20]          # 0048a38f
    movsx ecx, word ptr [eax + field_21]         # 0048a392
    cmp ecx, 0x1                                 # 0048a396
    jne.d8 L_0048a3a7                            # 0048a399
    # block 0x0048a39b: entered by fall-through of jne at 0x0048a399, 2 instruction(s), ends with forward jump to 0x0048a3b1
    mov dword ptr [0x5bb1ca], 0x0                # 0048a39b
    jmp.d8 L_0048a3b1                            # 0048a3a5
L_0048a3a7:
    # block 0x0048a3a7: entered by jne at 0x0048a399, 1 instruction(s), falls into the block at 0x0048a3b1
    mov dword ptr [0x5bb1ca], 0x1                # 0048a3a7
L_0048a3b1:
    # block 0x0048a3b1: entered by jmp at 0x0048a3a5, 5 instruction(s), calls FUN_004d36ed, FUN_0042ba3a, falls into the block at 0x0048a3c3
    call FUN_004d36ed                            # 0048a3b1
    mov dx, word ptr [ebp + arg_8]               # 0048a3b6
    push edx                                     # 0048a3ba
    call FUN_0042ba3a                            # 0048a3bb
    add esp, 0x4                                 # 0048a3c0
L_0048a3c3:
    # block 0x0048a3c3: entered by jmp at 0x00489a27; jmp at 0x0048a0c6; jmp at 0x0048a279, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0048a3c3
    pop esi                                      # 0048a3c4
    {load} mov esp, ebp                          # 0048a3c5
    pop ebp                                      # 0048a3c7
    ret 0x4                                      # 0048a3c8

