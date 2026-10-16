# FUN_004a8d28
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a8d28
# extent:       0x004a8d28-0x004a9b1b (3571 code bytes)
# span:         0x004a8d28-0x004a9b1b (code 3571, tables 0, padding 0)
# sha256:       fde81b24361edb29ec082202230cfbf48d4e2d27446d06e7ba17f3101855525b
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a8d28
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       15 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 3 more
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_20, field_43, field_45, field_2cd, field_2d9, field_36d, field_36f, field_371 and 19 more; [ecx + n] field_2, field_4, field_8, field_c, field_1c, field_1e, field_43, field_45, field_49, field_55, field_59, field_2d1 and 18 more; [edx + n] field_2, field_4, field_1c, field_1e, field_20, field_42, field_43, field_45, field_4b, field_4d, field_51, field_2d5 and 14 more; [esi + n] field_c26
# callees:      calls FUN_004e8d96, FUN_004a7ddc, FUN_0050cd50, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004a7df9, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004a7d1d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 878 instruction(s), 36 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_42, 0x42  # offset +0x42
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_55, 0x55  # offset +0x55
.equ field_59, 0x59  # offset +0x59
.equ field_2cd, 0x2cd  # offset +0x2cd
.equ field_2d1, 0x2d1  # offset +0x2d1
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_2d9, 0x2d9  # offset +0x2d9
.equ field_36d, 0x36d  # offset +0x36d
.equ field_36f, 0x36f  # offset +0x36f
.equ field_371, 0x371  # offset +0x371
.equ field_373, 0x373  # offset +0x373
.equ field_3d7, 0x3d7  # offset +0x3d7
.equ field_3d9, 0x3d9  # offset +0x3d9
.equ field_3db, 0x3db  # offset +0x3db
.equ field_3dd, 0x3dd  # offset +0x3dd
.equ field_3df, 0x3df  # offset +0x3df
.equ field_3e3, 0x3e3  # offset +0x3e3
.equ field_3e7, 0x3e7  # offset +0x3e7
.equ field_3eb, 0x3eb  # offset +0x3eb
.equ field_3ed, 0x3ed  # offset +0x3ed
.equ field_3ef, 0x3ef  # offset +0x3ef
.equ field_411, 0x411  # offset +0x411
.equ field_421, 0x421  # offset +0x421
.equ field_423, 0x423  # offset +0x423
.equ field_425, 0x425  # offset +0x425
.equ field_427, 0x427  # offset +0x427
.equ field_429, 0x429  # offset +0x429
.equ field_42d, 0x42d  # offset +0x42d
.equ field_431, 0x431  # offset +0x431
.equ field_435, 0x435  # offset +0x435
.equ field_437, 0x437  # offset +0x437
.equ field_439, 0x439  # offset +0x439
.equ field_530, 0x530  # offset +0x530
.equ field_a40, 0xa40  # offset +0xa40
.equ field_c26, 0xc26  # offset +0xc26
.equ field_e6a, 0xe6a  # offset +0xe6a
.equ field_e6e, 0xe6e  # offset +0xe6e
.equ field_e72, 0xe72  # offset +0xe72
.equ field_e7e, 0xe7e  # offset +0xe7e
.equ field_e7f, 0xe7f  # offset +0xe7f
.equ field_e83, 0xe83  # offset +0xe83
.equ field_e94, 0xe94  # offset +0xe94
.equ field_13a4, 0x13a4  # offset +0x13a4
.equ field_13a6, 0x13a6  # offset +0x13a6
.equ field_13a8, 0x13a8  # offset +0x13a8
.equ field_13aa, 0x13aa  # offset +0x13aa
.equ field_13ac, 0x13ac  # offset +0x13ac

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004a7d1d, .text + (0x004a7d1d - 0x401000)
.set FUN_004a7ddc, .text + (0x004a7ddc - 0x401000)
.set FUN_004a7df9, .text + (0x004a7df9 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004a8d28 - 0x401000
.globl FUN_004a8d28
FUN_004a8d28:
    # block 0x004a8d28: entry, 16 instruction(s), ends with je to 0x004a8d78 (forward)
    push ebp                                     # 004a8d28
    {load} mov ebp, esp                          # 004a8d29
    sub esp, 0x3c                                # 004a8d2b
    push esi                                     # 004a8d2e
    push edi                                     # 004a8d2f
    mov dword ptr [ebp - local_34], ecx          # 004a8d30
    movsx eax, word ptr [ebp + arg_8]            # 004a8d33
    imul eax, eax, 0x8d                          # 004a8d37
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a8d3d
    mov dword ptr [ebp - local_24], ecx          # 004a8d43
    movsx edx, word ptr [ebp + arg_8]            # 004a8d46
    imul edx, edx, 0x8d                          # 004a8d4a
    mov eax, dword ptr [edx + 0x5bb632]          # 004a8d50
    mov dword ptr [ebp - local_38], eax          # 004a8d56
    cmp dword ptr [ebp - local_38], 0x0          # 004a8d59
    je.d8 L_004a8d78                             # 004a8d5d
    # block 0x004a8d5f: entered by fall-through of je at 0x004a8d5d, 2 instruction(s), ends with je to 0x004a97df (forward)
    cmp dword ptr [ebp - local_38], 0x1          # 004a8d5f
    je.d32 L_004a97df                            # 004a8d63
    # block 0x004a8d69: entered by fall-through of je at 0x004a8d63, 2 instruction(s), ends with je to 0x004a98b3 (forward)
    cmp dword ptr [ebp - local_38], 0x2          # 004a8d69
    je.d32 L_004a98b3                            # 004a8d6d
    # block 0x004a8d73: entered by fall-through of je at 0x004a8d6d, 1 instruction(s), ends with forward jump to 0x004a9b13
    jmp.d32 L_004a9b13                           # 004a8d73
L_004a8d78:
    # block 0x004a8d78: entered by je at 0x004a8d5d, 11 instruction(s), calls FUN_004e8d96, ends with je to 0x004a8e02 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004a8d78
    mov dx, word ptr [ebp + arg_8]               # 004a8d7b
    mov word ptr [ecx + field_1e], dx            # 004a8d7f
    mov eax, dword ptr [ebp - local_34]          # 004a8d83
    mov dword ptr [eax + field_e72], 0x1         # 004a8d86
    mov dword ptr [0x5bb1ca], 0x1                # 004a8d90
    mov ecx, 0x571442                            # 004a8d9a
    call FUN_004e8d96                            # 004a8d9f
    movsx ecx, word ptr [0x5a110b]               # 004a8da4
    test ecx, ecx                                # 004a8dab
    je.d8 L_004a8e02                             # 004a8dad
    # block 0x004a8daf: entered by fall-through of je at 0x004a8dad, 5 instruction(s), ends with je to 0x004a8e02 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a8daf
    {load} xor eax, eax                          # 004a8db2
    mov al, byte ptr [edx + field_42]            # 004a8db4
    test eax, eax                                # 004a8db7
    je.d8 L_004a8e02                             # 004a8db9
    # block 0x004a8dbb: entered by fall-through of je at 0x004a8db9, 3 instruction(s), ends with je to 0x004a8dd4 (forward)
    movsx ecx, word ptr [0x5a110d]               # 004a8dbb
    cmp dword ptr [0x5bb57b], ecx                # 004a8dc2
    je.d8 L_004a8dd4                             # 004a8dc8
    # block 0x004a8dca: entered by fall-through of je at 0x004a8dc8, 3 instruction(s), calls FUN_004a7ddc, ends with forward jump to 0x004a8e02
    mov ecx, dword ptr [ebp - local_34]          # 004a8dca
    call FUN_004a7ddc                            # 004a8dcd
    jmp.d8 L_004a8e02                            # 004a8dd2
L_004a8dd4:
    # block 0x004a8dd4: entered by je at 0x004a8dc8, 12 instruction(s), falls into the block at 0x004a8e02
    mov edi, dword ptr [ebp - local_34]          # 004a8dd4
    add edi, 0xa40                               # 004a8dd7
    mov ecx, 0x79                                # 004a8ddd
    mov esi, 0x5a110f                            # 004a8de2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a8de7
    movsw word ptr es:[edi], word ptr [esi]      # 004a8de9
    mov edi, dword ptr [ebp - local_34]          # 004a8deb
    add edi, 0xc26                               # 004a8dee
    mov ecx, 0x79                                # 004a8df4
    mov esi, 0x5a12f5                            # 004a8df9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a8dfe
    movsw word ptr es:[edi], word ptr [esi]      # 004a8e00
L_004a8e02:
    # block 0x004a8e02: entered by je at 0x004a8dad; je at 0x004a8db9; jmp at 0x004a8dd2, 3 instruction(s), ends with jne to 0x004a91d5 (forward)
    movsx edx, word ptr [0x5a110b]               # 004a8e02
    test edx, edx                                # 004a8e09
    jne.d32 L_004a91d5                           # 004a8e0b
    # block 0x004a8e11: entered by fall-through of jne at 0x004a8e0b, 9 instruction(s), ends with forward jump to 0x004a8e3a
    mov eax, dword ptr [ebp - local_24]          # 004a8e11
    movsx eax, word ptr [eax + field_45]         # 004a8e14
    mov ecx, dword ptr [ebp - local_24]          # 004a8e18
    movsx ecx, word ptr [ecx + field_49]         # 004a8e1b
    cdq                                          # 004a8e1f
    idiv ecx                                     # 004a8e20
    mov word ptr [ebp - local_28], ax            # 004a8e22
    mov word ptr [ebp - local_14], 0x0           # 004a8e26
    jmp.d8 L_004a8e3a                            # 004a8e2c
L_004a8e2e:
    # block 0x004a8e2e: entered by jmp at 0x004a905d, 3 instruction(s), falls into the block at 0x004a8e3a
    mov dx, word ptr [ebp - local_14]            # 004a8e2e
    add dx, 0x1                                  # 004a8e32
    mov word ptr [ebp - local_14], dx            # 004a8e36
L_004a8e3a:
    # block 0x004a8e3a: entered by jmp at 0x004a8e2c, 5 instruction(s), ends with jge to 0x004a9062 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004a8e3a
    mov ecx, dword ptr [ebp - local_24]          # 004a8e3e
    movsx edx, word ptr [ecx + field_43]         # 004a8e41
    {load} cmp eax, edx                          # 004a8e45
    jge.d32 L_004a9062                           # 004a8e47
    # block 0x004a8e4d: entered by fall-through of jge at 0x004a8e47, 2 instruction(s), ends with forward jump to 0x004a8e61
    mov word ptr [ebp - local_20], 0x0           # 004a8e4d
    jmp.d8 L_004a8e61                            # 004a8e53
L_004a8e55:
    # block 0x004a8e55: entered by jmp at 0x004a9058, 3 instruction(s), falls into the block at 0x004a8e61
    mov ax, word ptr [ebp - local_20]            # 004a8e55
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a8e59
    mov word ptr [ebp - local_20], ax            # 004a8e5d
L_004a8e61:
    # block 0x004a8e61: entered by jmp at 0x004a8e53, 5 instruction(s), ends with jge to 0x004a905d (forward)
    movsx ecx, word ptr [ebp - local_20]         # 004a8e61
    mov edx, dword ptr [ebp - local_24]          # 004a8e65
    movsx eax, word ptr [edx + field_45]         # 004a8e68
    {load} cmp ecx, eax                          # 004a8e6c
    jge.d32 L_004a905d                           # 004a8e6e
    # block 0x004a8e74: entered by fall-through of jge at 0x004a8e6e, 45 instruction(s), calls FUN_0050cd50, ends with jle to 0x004a9058 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a8e74
    imul ecx, ecx, 0x36                          # 004a8e78
    mov edx, dword ptr [ebp - local_34]          # 004a8e7b
    lea eax, [edx + ecx + field_c26]             # 004a8e7e
    movsx ecx, word ptr [ebp - local_20]         # 004a8e85
    imul ecx, ecx, 0x6                           # 004a8e89
    mov dx, word ptr [ebp - local_14]            # 004a8e8c
    mov word ptr [eax + ecx], dx                 # 004a8e90
    movsx eax, word ptr [ebp - local_20]         # 004a8e94
    movsx ecx, word ptr [ebp - local_28]         # 004a8e98
    cdq                                          # 004a8e9c
    idiv ecx                                     # 004a8e9d
    movsx edx, word ptr [ebp - local_14]         # 004a8e9f
    imul edx, edx, 0x36                          # 004a8ea3
    mov ecx, dword ptr [ebp - local_34]          # 004a8ea6
    lea edx, [ecx + edx + field_c26]             # 004a8ea9
    movsx ecx, word ptr [ebp - local_20]         # 004a8eb0
    imul ecx, ecx, 0x6                           # 004a8eb4
    mov word ptr [edx + ecx + field_2], ax       # 004a8eb7
    call FUN_0050cd50                            # 004a8ebc
    mov edx, dword ptr [ebp - local_24]          # 004a8ec1
    movsx ecx, word ptr [edx + field_4b]         # 004a8ec4
    cdq                                          # 004a8ec8
    idiv ecx                                     # 004a8ec9
    movsx eax, word ptr [ebp - local_14]         # 004a8ecb
    imul eax, eax, 0x36                          # 004a8ecf
    mov ecx, dword ptr [ebp - local_34]          # 004a8ed2
    lea eax, [ecx + eax + field_c26]             # 004a8ed5
    movsx ecx, word ptr [ebp - local_20]         # 004a8edc
    imul ecx, ecx, 0x6                           # 004a8ee0
    mov word ptr [eax + ecx + field_4], dx       # 004a8ee3
    movsx edx, word ptr [ebp - local_14]         # 004a8ee8
    imul edx, edx, 0x36                          # 004a8eec
    mov eax, dword ptr [ebp - local_34]          # 004a8eef
    lea ecx, [eax + edx + field_c26]             # 004a8ef2
    movsx edx, word ptr [ebp - local_20]         # 004a8ef9
    imul edx, edx, 0x6                           # 004a8efd
    movsx eax, word ptr [ecx + edx + field_2]    # 004a8f00
    movsx ecx, word ptr [ebp - local_28]         # 004a8f05
    imul eax, ecx                                # 004a8f09
    mov word ptr [ebp - local_8], ax             # 004a8f0c
    movsx edx, word ptr [ebp - local_20]         # 004a8f10
    movsx eax, word ptr [ebp - local_8]          # 004a8f14
    {load} cmp edx, eax                          # 004a8f18
    jle.d32 L_004a9058                           # 004a8f1a
    # block 0x004a8f20: entered by fall-through of jle at 0x004a8f1a, 17 instruction(s), ends with jge to 0x004a9058 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a8f20
    imul ecx, ecx, 0x36                          # 004a8f24
    mov edx, dword ptr [ebp - local_34]          # 004a8f27
    lea eax, [edx + ecx + field_c26]             # 004a8f2a
    movsx ecx, word ptr [ebp - local_20]         # 004a8f31
    imul ecx, ecx, 0x6                           # 004a8f35
    movsx edx, word ptr [eax + ecx + field_4]    # 004a8f38
    movsx eax, word ptr [ebp - local_14]         # 004a8f3d
    imul eax, eax, 0x36                          # 004a8f41
    mov ecx, dword ptr [ebp - local_34]          # 004a8f44
    lea eax, [ecx + eax + field_c26]             # 004a8f47
    movsx ecx, word ptr [ebp - local_20]         # 004a8f4e
    sub ecx, 0x1                                 # 004a8f52
    imul ecx, ecx, 0x6                           # 004a8f55
    movsx eax, word ptr [eax + ecx + field_4]    # 004a8f58
    {load} cmp edx, eax                          # 004a8f5d
    jge.d32 L_004a9058                           # 004a8f5f
    # block 0x004a8f65: entered by fall-through of jge at 0x004a8f5f, 3 instruction(s), falls into the block at 0x004a8f70
    movsx ecx, word ptr [ebp - local_20]         # 004a8f65
    sub ecx, 0x1                                 # 004a8f69
    mov word ptr [ebp - local_1c], cx            # 004a8f6c
L_004a8f70:
    # block 0x004a8f70: entered by jmp at 0x004a9053, 4 instruction(s), ends with jl to 0x004a9058 (forward)
    movsx edx, word ptr [ebp - local_1c]         # 004a8f70
    movsx eax, word ptr [ebp - local_8]          # 004a8f74
    {load} cmp edx, eax                          # 004a8f78
    jl.d32 L_004a9058                            # 004a8f7a
    # block 0x004a8f80: entered by fall-through of jl at 0x004a8f7a, 17 instruction(s), ends with jge to 0x004a9058 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a8f80
    imul ecx, ecx, 0x36                          # 004a8f84
    mov edx, dword ptr [ebp - local_34]          # 004a8f87
    lea eax, [edx + ecx + field_c26]             # 004a8f8a
    movsx ecx, word ptr [ebp - local_1c]         # 004a8f91
    add ecx, 0x1                                 # 004a8f95
    imul ecx, ecx, 0x6                           # 004a8f98
    movsx edx, word ptr [eax + ecx + field_4]    # 004a8f9b
    movsx eax, word ptr [ebp - local_14]         # 004a8fa0
    imul eax, eax, 0x36                          # 004a8fa4
    mov ecx, dword ptr [ebp - local_34]          # 004a8fa7
    lea eax, [ecx + eax + field_c26]             # 004a8faa
    movsx ecx, word ptr [ebp - local_1c]         # 004a8fb1
    imul ecx, ecx, 0x6                           # 004a8fb5
    movsx eax, word ptr [eax + ecx + field_4]    # 004a8fb8
    {load} cmp edx, eax                          # 004a8fbd
    jge.d32 L_004a9058                           # 004a8fbf
    # block 0x004a8fc5: entered by fall-through of jge at 0x004a8fbf, 36 instruction(s), ends with backward jump to 0x004a8f70
    movsx ecx, word ptr [ebp - local_14]         # 004a8fc5
    imul ecx, ecx, 0x36                          # 004a8fc9
    mov edx, dword ptr [ebp - local_34]          # 004a8fcc
    lea eax, [edx + ecx + field_c26]             # 004a8fcf
    movsx ecx, word ptr [ebp - local_1c]         # 004a8fd6
    imul ecx, ecx, 0x6                           # 004a8fda
    mov dx, word ptr [eax + ecx + field_4]       # 004a8fdd
    mov word ptr [ebp - local_18], dx            # 004a8fe2
    movsx eax, word ptr [ebp - local_14]         # 004a8fe6
    imul eax, eax, 0x36                          # 004a8fea
    mov ecx, dword ptr [ebp - local_34]          # 004a8fed
    lea edx, [ecx + eax + field_c26]             # 004a8ff0
    movsx eax, word ptr [ebp - local_1c]         # 004a8ff7
    add eax, 0x1                                 # 004a8ffb
    imul eax, eax, 0x6                           # 004a8ffe
    movsx ecx, word ptr [ebp - local_14]         # 004a9001
    imul ecx, ecx, 0x36                          # 004a9005
    mov esi, dword ptr [ebp - local_34]          # 004a9008
    lea ecx, [esi + ecx + field_c26]             # 004a900b
    movsx esi, word ptr [ebp - local_1c]         # 004a9012
    imul esi, esi, 0x6                           # 004a9016
    mov dx, word ptr [edx + eax + field_4]       # 004a9019
    mov word ptr [ecx + esi + field_4], dx       # 004a901e
    movsx eax, word ptr [ebp - local_14]         # 004a9023
    imul eax, eax, 0x36                          # 004a9027
    mov ecx, dword ptr [ebp - local_34]          # 004a902a
    lea edx, [ecx + eax + field_c26]             # 004a902d
    movsx eax, word ptr [ebp - local_1c]         # 004a9034
    add eax, 0x1                                 # 004a9038
    imul eax, eax, 0x6                           # 004a903b
    mov cx, word ptr [ebp - local_18]            # 004a903e
    mov word ptr [edx + eax + field_4], cx       # 004a9042
    mov dx, word ptr [ebp - local_1c]            # 004a9047
    sub dx, 0x1                                  # 004a904b
    mov word ptr [ebp - local_1c], dx            # 004a904f
    jmp.d32 L_004a8f70                           # 004a9053
L_004a9058:
    # block 0x004a9058: entered by jle at 0x004a8f1a; jge at 0x004a8f5f; jl at 0x004a8f7a; jge at 0x004a8fbf, 1 instruction(s), ends with backward jump to 0x004a8e55
    jmp.d32 L_004a8e55                           # 004a9058
L_004a905d:
    # block 0x004a905d: entered by jge at 0x004a8e6e, 1 instruction(s), ends with backward jump to 0x004a8e2e
    jmp.d32 L_004a8e2e                           # 004a905d
L_004a9062:
    # block 0x004a9062: entered by jge at 0x004a8e47, 8 instruction(s), ends with forward jump to 0x004a9089
    mov ecx, 0x14                                # 004a9062
    {load} xor eax, eax                          # 004a9067
    mov edi, dword ptr [ebp - local_34]          # 004a9069
    add edi, 0x13ac                              # 004a906c
    rep stosd dword ptr es:[edi], eax            # 004a9072
    stosb byte ptr es:[edi], al                  # 004a9074
    mov word ptr [ebp - local_14], 0x0           # 004a9075
    jmp.d8 L_004a9089                            # 004a907b
L_004a907d:
    # block 0x004a907d: entered by jmp at 0x004a918d, 3 instruction(s), falls into the block at 0x004a9089
    mov ax, word ptr [ebp - local_14]            # 004a907d
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a9081
    mov word ptr [ebp - local_14], ax            # 004a9085
L_004a9089:
    # block 0x004a9089: entered by jmp at 0x004a907b, 5 instruction(s), ends with jge to 0x004a9192 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a9089
    mov edx, dword ptr [ebp - local_24]          # 004a908d
    movsx eax, word ptr [edx + field_43]         # 004a9090
    {load} cmp ecx, eax                          # 004a9094
    jge.d32 L_004a9192                           # 004a9096
    # block 0x004a909c: entered by fall-through of jge at 0x004a9096, 2 instruction(s), ends with forward jump to 0x004a90b0
    mov word ptr [ebp - local_20], 0x0           # 004a909c
    jmp.d8 L_004a90b0                            # 004a90a2
L_004a90a4:
    # block 0x004a90a4: entered by jmp at 0x004a9188, 3 instruction(s), falls into the block at 0x004a90b0
    mov cx, word ptr [ebp - local_20]            # 004a90a4
    add cx, 0x1                                  # 004a90a8
    mov word ptr [ebp - local_20], cx            # 004a90ac
L_004a90b0:
    # block 0x004a90b0: entered by jmp at 0x004a90a2, 5 instruction(s), ends with jge to 0x004a918d (forward)
    movsx edx, word ptr [ebp - local_20]         # 004a90b0
    mov eax, dword ptr [ebp - local_24]          # 004a90b4
    movsx ecx, word ptr [eax + field_45]         # 004a90b7
    {load} cmp edx, ecx                          # 004a90bb
    jge.d32 L_004a918d                           # 004a90bd
    # block 0x004a90c3: entered by fall-through of jge at 0x004a90bd, 12 instruction(s), calls FUN_0050cd50, falls into the block at 0x004a90e9
    call FUN_0050cd50                            # 004a90c3
    mov edx, dword ptr [ebp - local_24]          # 004a90c8
    movsx ecx, word ptr [edx + field_43]         # 004a90cb
    cdq                                          # 004a90cf
    idiv ecx                                     # 004a90d0
    mov word ptr [ebp - local_10], dx            # 004a90d2
    call FUN_0050cd50                            # 004a90d6
    mov edx, dword ptr [ebp - local_24]          # 004a90db
    movsx ecx, word ptr [edx + field_45]         # 004a90de
    cdq                                          # 004a90e2
    idiv ecx                                     # 004a90e3
    mov word ptr [ebp - local_4], dx             # 004a90e5
L_004a90e9:
    # block 0x004a90e9: entered by jmp at 0x004a912d, 9 instruction(s), ends with je to 0x004a912f (forward)
    movsx edx, word ptr [ebp - local_10]         # 004a90e9
    imul edx, edx, 0x9                           # 004a90ed
    mov eax, dword ptr [ebp - local_34]          # 004a90f0
    lea ecx, [eax + edx + field_13ac]            # 004a90f3
    movsx edx, word ptr [ebp - local_4]          # 004a90fa
    {load} xor eax, eax                          # 004a90fe
    mov al, byte ptr [ecx + edx]                 # 004a9100
    test eax, eax                                # 004a9103
    je.d8 L_004a912f                             # 004a9105
    # block 0x004a9107: entered by fall-through of je at 0x004a9105, 13 instruction(s), calls FUN_0050cd50, ends with backward jump to 0x004a90e9
    call FUN_0050cd50                            # 004a9107
    mov ecx, dword ptr [ebp - local_24]          # 004a910c
    movsx ecx, word ptr [ecx + field_43]         # 004a910f
    cdq                                          # 004a9113
    idiv ecx                                     # 004a9114
    mov word ptr [ebp - local_10], dx            # 004a9116
    call FUN_0050cd50                            # 004a911a
    mov edx, dword ptr [ebp - local_24]          # 004a911f
    movsx ecx, word ptr [edx + field_45]         # 004a9122
    cdq                                          # 004a9126
    idiv ecx                                     # 004a9127
    mov word ptr [ebp - local_4], dx             # 004a9129
    jmp.d8 L_004a90e9                            # 004a912d
L_004a912f:
    # block 0x004a912f: entered by je at 0x004a9105, 25 instruction(s), ends with backward jump to 0x004a90a4
    movsx edx, word ptr [ebp - local_10]         # 004a912f
    imul edx, edx, 0x36                          # 004a9133
    mov eax, dword ptr [ebp - local_34]          # 004a9136
    lea ecx, [eax + edx + field_c26]             # 004a9139
    movsx edx, word ptr [ebp - local_4]          # 004a9140
    imul edx, edx, 0x6                           # 004a9144
    {load} add ecx, edx                          # 004a9147
    movsx eax, word ptr [ebp - local_14]         # 004a9149
    imul eax, eax, 0x36                          # 004a914d
    mov edx, dword ptr [ebp - local_34]          # 004a9150
    lea eax, [edx + eax + field_a40]             # 004a9153
    movsx edx, word ptr [ebp - local_20]         # 004a915a
    imul edx, edx, 0x6                           # 004a915e
    {load} add eax, edx                          # 004a9161
    mov edx, dword ptr [ecx]                     # 004a9163
    mov dword ptr [eax], edx                     # 004a9165
    mov cx, word ptr [ecx + field_4]             # 004a9167
    mov word ptr [eax + field_4], cx             # 004a916b
    movsx edx, word ptr [ebp - local_10]         # 004a916f
    imul edx, edx, 0x9                           # 004a9173
    mov eax, dword ptr [ebp - local_34]          # 004a9176
    lea ecx, [eax + edx + field_13ac]            # 004a9179
    movsx edx, word ptr [ebp - local_4]          # 004a9180
    mov byte ptr [ecx + edx], 0x1                # 004a9184
    jmp.d32 L_004a90a4                           # 004a9188
L_004a918d:
    # block 0x004a918d: entered by jge at 0x004a90bd, 1 instruction(s), ends with backward jump to 0x004a907d
    jmp.d32 L_004a907d                           # 004a918d
L_004a9192:
    # block 0x004a9192: entered by jge at 0x004a9096, 15 instruction(s), falls into the block at 0x004a91d5
    mov esi, dword ptr [ebp - local_34]          # 004a9192
    add esi, 0xa40                               # 004a9195
    mov ecx, 0x79                                # 004a919b
    mov edi, 0x5a110f                            # 004a91a0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a91a5
    movsw word ptr es:[edi], word ptr [esi]      # 004a91a7
    mov esi, dword ptr [ebp - local_34]          # 004a91a9
    add esi, 0xc26                               # 004a91ac
    mov ecx, 0x79                                # 004a91b2
    mov edi, 0x5a12f5                            # 004a91b7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a91bc
    movsw word ptr es:[edi], word ptr [esi]      # 004a91be
    mov ax, word ptr [0x5bb57b]                  # 004a91c0
    mov word ptr [0x5a110d], ax                  # 004a91c6
    mov word ptr [0x5a110b], 0x1                 # 004a91cc
L_004a91d5:
    # block 0x004a91d5: entered by jne at 0x004a8e0b, 12 instruction(s), ends with forward jump to 0x004a9209
    mov ecx, dword ptr [ebp - local_24]          # 004a91d5
    mov edx, dword ptr [ebp - local_24]          # 004a91d8
    mov eax, dword ptr [ecx + field_55]          # 004a91db
    sub eax, dword ptr [edx + field_4d]          # 004a91de
    mov word ptr [ebp - local_c], ax             # 004a91e1
    mov ecx, dword ptr [ebp - local_24]          # 004a91e5
    mov edx, dword ptr [ebp - local_24]          # 004a91e8
    mov eax, dword ptr [ecx + field_59]          # 004a91eb
    sub eax, dword ptr [edx + field_51]          # 004a91ee
    mov word ptr [ebp - local_2c], ax            # 004a91f1
    mov word ptr [ebp - local_14], 0x0           # 004a91f5
    jmp.d8 L_004a9209                            # 004a91fb
L_004a91fd:
    # block 0x004a91fd: entered by jmp at 0x004a957f, 3 instruction(s), falls into the block at 0x004a9209
    mov cx, word ptr [ebp - local_14]            # 004a91fd
    add cx, 0x1                                  # 004a9201
    mov word ptr [ebp - local_14], cx            # 004a9205
L_004a9209:
    # block 0x004a9209: entered by jmp at 0x004a91fb, 5 instruction(s), ends with jge to 0x004a9584 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004a9209
    mov eax, dword ptr [ebp - local_24]          # 004a920d
    movsx ecx, word ptr [eax + field_43]         # 004a9210
    {load} cmp edx, ecx                          # 004a9214
    jge.d32 L_004a9584                           # 004a9216
    # block 0x004a921c: entered by fall-through of jge at 0x004a9216, 2 instruction(s), ends with forward jump to 0x004a9230
    mov word ptr [ebp - local_20], 0x0           # 004a921c
    jmp.d8 L_004a9230                            # 004a9222
L_004a9224:
    # block 0x004a9224: entered by jmp at 0x004a957a, 3 instruction(s), falls into the block at 0x004a9230
    mov dx, word ptr [ebp - local_20]            # 004a9224
    add dx, 0x1                                  # 004a9228
    mov word ptr [ebp - local_20], dx            # 004a922c
L_004a9230:
    # block 0x004a9230: entered by jmp at 0x004a9222, 5 instruction(s), ends with jge to 0x004a957f (forward)
    movsx eax, word ptr [ebp - local_20]         # 004a9230
    mov ecx, dword ptr [ebp - local_24]          # 004a9234
    movsx edx, word ptr [ecx + field_45]         # 004a9237
    {load} cmp eax, edx                          # 004a923b
    jge.d32 L_004a957f                           # 004a923d
    # block 0x004a9243: entered by fall-through of jge at 0x004a923d, 207 instruction(s), ends with backward jump to 0x004a9224
    mov eax, dword ptr [ebp - local_24]          # 004a9243
    movsx ecx, word ptr [eax + field_36f]        # 004a9246
    movsx edx, word ptr [ebp - local_14]         # 004a924d
    mov eax, dword ptr [ebp - local_24]          # 004a9251
    movsx eax, word ptr [eax + field_371]        # 004a9254
    movsx esi, word ptr [ebp - local_2c]         # 004a925b
    {load} add eax, esi                          # 004a925f
    imul edx, eax                                # 004a9261
    {load} add ecx, edx                          # 004a9264
    movsx edx, word ptr [ebp - local_14]         # 004a9266
    imul edx, edx, 0x90                          # 004a926a
    mov eax, dword ptr [ebp - local_34]          # 004a9270
    lea edx, [eax + edx + field_530]             # 004a9273
    movsx eax, word ptr [ebp - local_20]         # 004a927a
    shl eax, 0x4                                 # 004a927e
    mov dword ptr [edx + eax + field_4], ecx     # 004a9281
    movsx ecx, word ptr [ebp - local_14]         # 004a9285
    imul ecx, ecx, 0x90                          # 004a9289
    mov edx, dword ptr [ebp - local_34]          # 004a928f
    lea eax, [edx + ecx + field_530]             # 004a9292
    movsx ecx, word ptr [ebp - local_20]         # 004a9299
    shl ecx, 0x4                                 # 004a929d
    movsx edx, word ptr [ebp - local_2c]         # 004a92a0
    mov eax, dword ptr [eax + ecx + field_4]     # 004a92a4
    {load} add eax, edx                          # 004a92a8
    movsx ecx, word ptr [ebp - local_14]         # 004a92aa
    imul ecx, ecx, 0x90                          # 004a92ae
    mov edx, dword ptr [ebp - local_34]          # 004a92b4
    lea ecx, [edx + ecx + field_530]             # 004a92b7
    movsx edx, word ptr [ebp - local_20]         # 004a92be
    shl edx, 0x4                                 # 004a92c2
    mov dword ptr [ecx + edx + field_c], eax     # 004a92c5
    mov eax, dword ptr [ebp - local_24]          # 004a92c9
    movsx ecx, word ptr [eax + field_36d]        # 004a92cc
    movsx edx, word ptr [ebp - local_20]         # 004a92d3
    mov eax, dword ptr [ebp - local_24]          # 004a92d7
    movsx eax, word ptr [eax + field_373]        # 004a92da
    movsx esi, word ptr [ebp - local_c]          # 004a92e1
    {load} add eax, esi                          # 004a92e5
    imul edx, eax                                # 004a92e7
    {load} add ecx, edx                          # 004a92ea
    movsx edx, word ptr [ebp - local_14]         # 004a92ec
    imul edx, edx, 0x90                          # 004a92f0
    mov eax, dword ptr [ebp - local_34]          # 004a92f6
    lea edx, [eax + edx + field_530]             # 004a92f9
    movsx eax, word ptr [ebp - local_20]         # 004a9300
    shl eax, 0x4                                 # 004a9304
    mov dword ptr [edx + eax], ecx               # 004a9307
    movsx ecx, word ptr [ebp - local_14]         # 004a930a
    imul ecx, ecx, 0x90                          # 004a930e
    mov edx, dword ptr [ebp - local_34]          # 004a9314
    lea eax, [edx + ecx + field_530]             # 004a9317
    movsx ecx, word ptr [ebp - local_20]         # 004a931e
    shl ecx, 0x4                                 # 004a9322
    movsx edx, word ptr [ebp - local_c]          # 004a9325
    mov eax, dword ptr [eax + ecx]               # 004a9329
    {load} add eax, edx                          # 004a932c
    movsx ecx, word ptr [ebp - local_14]         # 004a932e
    imul ecx, ecx, 0x90                          # 004a9332
    mov edx, dword ptr [ebp - local_34]          # 004a9338
    lea ecx, [edx + ecx + field_530]             # 004a933b
    movsx edx, word ptr [ebp - local_20]         # 004a9342
    shl edx, 0x4                                 # 004a9346
    mov dword ptr [ecx + edx + field_8], eax     # 004a9349
    movsx eax, word ptr [ebp - local_14]         # 004a934d
    imul eax, eax, 0x90                          # 004a9351
    mov ecx, dword ptr [ebp - local_34]          # 004a9357
    lea edx, [ecx + eax + field_530]             # 004a935a
    movsx eax, word ptr [ebp - local_20]         # 004a9361
    shl eax, 0x4                                 # 004a9365
    mov ecx, dword ptr [edx + eax + field_4]     # 004a9368
    add ecx, dword ptr [0x58318a]                # 004a936c
    movsx edx, word ptr [ebp - local_14]         # 004a9372
    imul edx, edx, 0x90                          # 004a9376
    mov eax, dword ptr [ebp - local_34]          # 004a937c
    lea edx, [eax + edx + field_20]              # 004a937f
    movsx eax, word ptr [ebp - local_20]         # 004a9383
    shl eax, 0x4                                 # 004a9387
    mov dword ptr [edx + eax + field_4], ecx     # 004a938a
    movsx ecx, word ptr [ebp - local_14]         # 004a938e
    imul ecx, ecx, 0x90                          # 004a9392
    mov edx, dword ptr [ebp - local_34]          # 004a9398
    lea eax, [edx + ecx + field_20]              # 004a939b
    movsx ecx, word ptr [ebp - local_20]         # 004a939f
    shl ecx, 0x4                                 # 004a93a3
    movsx edx, word ptr [ebp - local_2c]         # 004a93a6
    mov eax, dword ptr [eax + ecx + field_4]     # 004a93aa
    {load} add eax, edx                          # 004a93ae
    movsx ecx, word ptr [ebp - local_14]         # 004a93b0
    imul ecx, ecx, 0x90                          # 004a93b4
    mov edx, dword ptr [ebp - local_34]          # 004a93ba
    lea ecx, [edx + ecx + field_20]              # 004a93bd
    movsx edx, word ptr [ebp - local_20]         # 004a93c1
    shl edx, 0x4                                 # 004a93c5
    mov dword ptr [ecx + edx + field_c], eax     # 004a93c8
    movsx eax, word ptr [ebp - local_14]         # 004a93cc
    imul eax, eax, 0x90                          # 004a93d0
    mov ecx, dword ptr [ebp - local_34]          # 004a93d6
    lea edx, [ecx + eax + field_530]             # 004a93d9
    movsx eax, word ptr [ebp - local_20]         # 004a93e0
    shl eax, 0x4                                 # 004a93e4
    mov ecx, dword ptr [edx + eax]               # 004a93e7
    add ecx, dword ptr [0x583186]                # 004a93ea
    movsx edx, word ptr [ebp - local_14]         # 004a93f0
    imul edx, edx, 0x90                          # 004a93f4
    mov eax, dword ptr [ebp - local_34]          # 004a93fa
    lea edx, [eax + edx + field_20]              # 004a93fd
    movsx eax, word ptr [ebp - local_20]         # 004a9401
    shl eax, 0x4                                 # 004a9405
    mov dword ptr [edx + eax], ecx               # 004a9408
    movsx ecx, word ptr [ebp - local_14]         # 004a940b
    imul ecx, ecx, 0x90                          # 004a940f
    mov edx, dword ptr [ebp - local_34]          # 004a9415
    lea eax, [edx + ecx + field_20]              # 004a9418
    movsx ecx, word ptr [ebp - local_20]         # 004a941c
    shl ecx, 0x4                                 # 004a9420
    movsx edx, word ptr [ebp - local_c]          # 004a9423
    mov eax, dword ptr [eax + ecx]               # 004a9427
    {load} add eax, edx                          # 004a942a
    movsx ecx, word ptr [ebp - local_14]         # 004a942c
    imul ecx, ecx, 0x90                          # 004a9430
    mov edx, dword ptr [ebp - local_34]          # 004a9436
    lea ecx, [edx + ecx + field_20]              # 004a9439
    movsx edx, word ptr [ebp - local_20]         # 004a943d
    shl edx, 0x4                                 # 004a9441
    mov dword ptr [ecx + edx + field_8], eax     # 004a9444
    movsx eax, word ptr [ebp - local_14]         # 004a9448
    imul eax, eax, 0x90                          # 004a944c
    mov ecx, dword ptr [ebp - local_34]          # 004a9452
    lea ecx, [ecx + eax + field_530]             # 004a9455
    movsx esi, word ptr [ebp - local_20]         # 004a945c
    shl esi, 0x4                                 # 004a9460
    movsx eax, word ptr [ebp - local_2c]         # 004a9463
    cdq                                          # 004a9467
    and edx, 0x3                                 # 004a9468
    {load} add eax, edx                          # 004a946b
    sar eax, 0x2                                 # 004a946d
    mov edx, dword ptr [ecx + esi + field_4]     # 004a9470
    {load} add edx, eax                          # 004a9474
    movsx eax, word ptr [ebp - local_14]         # 004a9476
    imul eax, eax, 0x90                          # 004a947a
    mov ecx, dword ptr [ebp - local_34]          # 004a9480
    lea eax, [ecx + eax + field_e94]             # 004a9483
    movsx ecx, word ptr [ebp - local_20]         # 004a948a
    shl ecx, 0x4                                 # 004a948e
    mov dword ptr [eax + ecx + field_4], edx     # 004a9491
    movsx edx, word ptr [ebp - local_14]         # 004a9495
    imul edx, edx, 0x90                          # 004a9499
    mov eax, dword ptr [ebp - local_34]          # 004a949f
    lea ecx, [eax + edx + field_530]             # 004a94a2
    movsx esi, word ptr [ebp - local_20]         # 004a94a9
    shl esi, 0x4                                 # 004a94ad
    movsx eax, word ptr [ebp - local_2c]         # 004a94b0
    cdq                                          # 004a94b4
    and edx, 0x3                                 # 004a94b5
    {load} add eax, edx                          # 004a94b8
    sar eax, 0x2                                 # 004a94ba
    mov edx, dword ptr [ecx + esi + field_c]     # 004a94bd
    {load} sub edx, eax                          # 004a94c1
    movsx eax, word ptr [ebp - local_14]         # 004a94c3
    imul eax, eax, 0x90                          # 004a94c7
    mov ecx, dword ptr [ebp - local_34]          # 004a94cd
    lea eax, [ecx + eax + field_e94]             # 004a94d0
    movsx ecx, word ptr [ebp - local_20]         # 004a94d7
    shl ecx, 0x4                                 # 004a94db
    mov dword ptr [eax + ecx + field_c], edx     # 004a94de
    movsx edx, word ptr [ebp - local_14]         # 004a94e2
    imul edx, edx, 0x90                          # 004a94e6
    mov eax, dword ptr [ebp - local_34]          # 004a94ec
    lea ecx, [eax + edx + field_530]             # 004a94ef
    movsx esi, word ptr [ebp - local_20]         # 004a94f6
    shl esi, 0x4                                 # 004a94fa
    movsx eax, word ptr [ebp - local_c]          # 004a94fd
    cdq                                          # 004a9501
    and edx, 0x3                                 # 004a9502
    {load} add eax, edx                          # 004a9505
    sar eax, 0x2                                 # 004a9507
    mov edx, dword ptr [ecx + esi]               # 004a950a
    {load} add edx, eax                          # 004a950d
    movsx eax, word ptr [ebp - local_14]         # 004a950f
    imul eax, eax, 0x90                          # 004a9513
    mov ecx, dword ptr [ebp - local_34]          # 004a9519
    lea eax, [ecx + eax + field_e94]             # 004a951c
    movsx ecx, word ptr [ebp - local_20]         # 004a9523
    shl ecx, 0x4                                 # 004a9527
    mov dword ptr [eax + ecx], edx               # 004a952a
    movsx edx, word ptr [ebp - local_14]         # 004a952d
    imul edx, edx, 0x90                          # 004a9531
    mov eax, dword ptr [ebp - local_34]          # 004a9537
    lea ecx, [eax + edx + field_530]             # 004a953a
    movsx esi, word ptr [ebp - local_20]         # 004a9541
    shl esi, 0x4                                 # 004a9545
    movsx eax, word ptr [ebp - local_c]          # 004a9548
    cdq                                          # 004a954c
    and edx, 0x3                                 # 004a954d
    {load} add eax, edx                          # 004a9550
    sar eax, 0x2                                 # 004a9552
    mov edx, dword ptr [ecx + esi + field_8]     # 004a9555
    {load} sub edx, eax                          # 004a9559
    movsx eax, word ptr [ebp - local_14]         # 004a955b
    imul eax, eax, 0x90                          # 004a955f
    mov ecx, dword ptr [ebp - local_34]          # 004a9565
    lea eax, [ecx + eax + field_e94]             # 004a9568
    movsx ecx, word ptr [ebp - local_20]         # 004a956f
    shl ecx, 0x4                                 # 004a9573
    mov dword ptr [eax + ecx + field_8], edx     # 004a9576
    jmp.d32 L_004a9224                           # 004a957a
L_004a957f:
    # block 0x004a957f: entered by jge at 0x004a923d, 1 instruction(s), ends with backward jump to 0x004a91fd
    jmp.d32 L_004a91fd                           # 004a957f
L_004a9584:
    # block 0x004a9584: entered by jge at 0x004a9216, 79 instruction(s), calls FUN_004d39f9, ends with jne to 0x004a96f6 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a9584
    mov eax, dword ptr [ebp - local_24]          # 004a9587
    mov ecx, dword ptr [edx + field_2d5]         # 004a958a
    sub ecx, dword ptr [eax + field_2cd]         # 004a9590
    mov edx, dword ptr [ebp - local_34]          # 004a9596
    mov word ptr [edx + field_13a4], cx          # 004a9599
    mov eax, dword ptr [ebp - local_24]          # 004a95a0
    mov ecx, dword ptr [ebp - local_24]          # 004a95a3
    mov edx, dword ptr [eax + field_2d9]         # 004a95a6
    sub edx, dword ptr [ecx + field_2d1]         # 004a95ac
    mov eax, dword ptr [ebp - local_34]          # 004a95b2
    mov word ptr [eax + field_13a6], dx          # 004a95b5
    mov ecx, dword ptr [ebp - local_34]          # 004a95bc
    movsx edx, word ptr [ecx + field_13a4]       # 004a95bf
    sar edx                                      # 004a95c6
    mov eax, dword ptr [ebp - local_34]          # 004a95c8
    mov word ptr [eax + field_13a8], dx          # 004a95cb
    mov ecx, dword ptr [ebp - local_34]          # 004a95d2
    movsx edx, word ptr [ecx + field_13a6]       # 004a95d5
    sar edx                                      # 004a95dc
    mov eax, dword ptr [ebp - local_34]          # 004a95de
    mov word ptr [eax + field_13aa], dx          # 004a95e1
    call FUN_004d39f9                            # 004a95e8
    mov ecx, dword ptr [ebp - local_34]          # 004a95ed
    mov word ptr [ecx + field_1c], ax            # 004a95f0
    mov edx, dword ptr [ebp - local_34]          # 004a95f4
    movsx eax, word ptr [edx + field_1c]         # 004a95f7
    imul eax, eax, 0x4a                          # 004a95fb
    mov dword ptr [eax + 0x5d1591], 0xa          # 004a95fe
    mov ecx, dword ptr [ebp - local_34]          # 004a9608
    movsx edx, word ptr [ecx + field_1c]         # 004a960b
    imul edx, edx, 0x4a                          # 004a960f
    mov dword ptr [edx + 0x5d1595], 0x4a9b2b     # 004a9612
    mov eax, dword ptr [ebp - local_34]          # 004a961c
    movsx ecx, word ptr [eax + field_1c]         # 004a961f
    imul ecx, ecx, 0x4a                          # 004a9623
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004a9626
    mov edx, dword ptr [ebp - local_34]          # 004a9630
    movsx eax, word ptr [edx + field_1c]         # 004a9633
    imul eax, eax, 0x4a                          # 004a9637
    mov dword ptr [eax + 0x5d159d], 0x0          # 004a963a
    mov ecx, dword ptr [ebp - local_34]          # 004a9644
    movsx edx, word ptr [ecx + field_1c]         # 004a9647
    imul edx, edx, 0x4a                          # 004a964b
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004a964e
    mov eax, dword ptr [ebp - local_34]          # 004a9658
    movsx ecx, word ptr [eax + field_1c]         # 004a965b
    imul ecx, ecx, 0x4a                          # 004a965f
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a9662
    mov edx, dword ptr [ebp - local_34]          # 004a966c
    movsx eax, word ptr [edx + field_1c]         # 004a966f
    imul eax, eax, 0x4a                          # 004a9673
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004a9676
    mov ecx, dword ptr [ebp - local_34]          # 004a9680
    movsx edx, word ptr [ecx + field_1c]         # 004a9683
    imul edx, edx, 0x4a                          # 004a9687
    mov word ptr [edx + 0x5d15ad], 0x0           # 004a968a
    mov edi, 0x550bc4                            # 004a9693
    mov eax, dword ptr [ebp - local_34]          # 004a9698
    movsx ecx, word ptr [eax + field_1c]         # 004a969b
    imul ecx, ecx, 0x4a                          # 004a969f
    add ecx, 0x5d15b3                            # 004a96a2
    {load} mov edx, ecx                          # 004a96a8
    or ecx, -0x1                                 # 004a96aa
    {load} xor eax, eax                          # 004a96ad
    repne scasb al, byte ptr es:[edi]            # 004a96af
    not ecx                                      # 004a96b1
    {load} sub edi, ecx                          # 004a96b3
    {load} mov esi, edi                          # 004a96b5
    {load} mov eax, ecx                          # 004a96b7
    {load} mov edi, edx                          # 004a96b9
    shr ecx, 0x2                                 # 004a96bb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a96be
    {load} mov ecx, eax                          # 004a96c0
    and ecx, 0x3                                 # 004a96c2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a96c5
    mov ecx, dword ptr [ebp - local_34]          # 004a96c7
    cmp dword ptr [ecx + field_e6a], 0x0         # 004a96ca
    jne.d8 L_004a96f6                            # 004a96d1
    # block 0x004a96d3: entered by fall-through of jne at 0x004a96d1, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004a96f6
    push 0x550bdc                                # 004a96d3
    push 0x6                                     # 004a96d8
    mov edx, dword ptr [ebp - local_24]          # 004a96da
    push edx                                     # 004a96dd
    push 0x550bf0                                # 004a96de
    mov ecx, 0x5cf659                            # 004a96e3
    call FUN_004c2790                            # 004a96e8
    mov ecx, dword ptr [ebp - local_34]          # 004a96ed
    mov dword ptr [ecx + field_e6a], eax         # 004a96f0
L_004a96f6:
    # block 0x004a96f6: entered by jne at 0x004a96d1, 3 instruction(s), ends with jne to 0x004a9728 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004a96f6
    cmp dword ptr [edx + field_e6e], 0x0         # 004a96f9
    jne.d8 L_004a9728                            # 004a9700
    # block 0x004a9702: entered by fall-through of jne at 0x004a9700, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004a9728
    push 0x550bf8                                # 004a9702
    push 0x6                                     # 004a9707
    mov eax, dword ptr [ebp - local_24]          # 004a9709
    add eax, 0x21                                # 004a970c
    push eax                                     # 004a970f
    push 0x550c14                                # 004a9710
    mov ecx, 0x5cf659                            # 004a9715
    call FUN_004c2790                            # 004a971a
    mov ecx, dword ptr [ebp - local_34]          # 004a971f
    mov dword ptr [ecx + field_e6e], eax         # 004a9722
L_004a9728:
    # block 0x004a9728: entered by jne at 0x004a9700, 13 instruction(s), ends with je to 0x004a976e (forward)
    mov edx, dword ptr [ebp - local_34]          # 004a9728
    movsx eax, word ptr [edx + field_1c]         # 004a972b
    imul eax, eax, 0x4a                          # 004a972f
    mov ecx, dword ptr [ebp - local_34]          # 004a9732
    mov edx, dword ptr [ecx + field_e6a]         # 004a9735
    mov dword ptr [eax + 0x5d1599], edx          # 004a973b
    mov edi, 0x550c1c                            # 004a9741
    mov esi, dword ptr [ebp - local_24]          # 004a9746
    add esi, 0x375                               # 004a9749
    mov ecx, 0x9                                 # 004a974f
    {load} xor eax, eax                          # 004a9754
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a9756
    je.d8 L_004a976e                             # 004a9758
    # block 0x004a975a: entered by fall-through of je at 0x004a9758, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a976e
    mov ecx, dword ptr [ebp - local_24]          # 004a975a
    add ecx, 0x375                               # 004a975d
    push ecx                                     # 004a9763
    mov ecx, 0x5c3a67                            # 004a9764
    call FUN_004fb77a                            # 004a9769
L_004a976e:
    # block 0x004a976e: entered by je at 0x004a9758, 7 instruction(s), ends with je to 0x004a979a (forward)
    mov edi, 0x550c28                            # 004a976e
    mov esi, dword ptr [ebp - local_24]          # 004a9773
    add esi, 0x3a6                               # 004a9776
    mov ecx, 0x9                                 # 004a977c
    {load} xor edx, edx                          # 004a9781
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a9783
    je.d8 L_004a979a                             # 004a9785
    # block 0x004a9787: entered by fall-through of je at 0x004a9785, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a979a
    mov eax, dword ptr [ebp - local_24]          # 004a9787
    add eax, 0x3a6                               # 004a978a
    push eax                                     # 004a978f
    mov ecx, 0x5c3a67                            # 004a9790
    call FUN_004fb77a                            # 004a9795
L_004a979a:
    # block 0x004a979a: entered by je at 0x004a9785, 13 instruction(s), calls FUN_004a7df9, ends with forward jump to 0x004a9b13
    mov ecx, dword ptr [ebp - local_34]          # 004a979a
    call FUN_004a7df9                            # 004a979d
    mov ecx, dword ptr [ebp - local_34]          # 004a97a2
    mov byte ptr [ecx + field_e83], 0x0          # 004a97a5
    mov edx, dword ptr [ebp - local_34]          # 004a97ac
    mov byte ptr [edx + field_e7e], 0x0          # 004a97af
    mov eax, dword ptr [ebp - local_34]          # 004a97b6
    mov dword ptr [eax + field_e7f], 0x0         # 004a97b9
    mov ecx, dword ptr [ebp - local_34]          # 004a97c3
    movsx edx, word ptr [ecx + field_1e]         # 004a97c6
    imul edx, edx, 0x8d                          # 004a97ca
    mov dword ptr [edx + 0x5bb632], 0x1          # 004a97d0
    jmp.d32 L_004a9b13                           # 004a97da
L_004a97df:
    # block 0x004a97df: entered by je at 0x004a8d63, 5 instruction(s), ends with je to 0x004a9865 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004a97df
    mov ecx, dword ptr [eax + field_e7f]         # 004a97e2
    mov dword ptr [ebp - local_3c], ecx          # 004a97e8
    cmp dword ptr [ebp - local_3c], 0x1          # 004a97eb
    je.d8 L_004a9865                             # 004a97ef
    # block 0x004a97f1: entered by fall-through of je at 0x004a97ef, 2 instruction(s), ends with je to 0x004a97fc (forward)
    cmp dword ptr [ebp - local_3c], 0x2          # 004a97f1
    je.d8 L_004a97fc                             # 004a97f5
    # block 0x004a97f7: entered by fall-through of je at 0x004a97f5, 1 instruction(s), ends with forward jump to 0x004a98ae
    jmp.d32 L_004a98ae                           # 004a97f7
L_004a97fc:
    # block 0x004a97fc: entered by je at 0x004a97f5, 7 instruction(s), ends with je to 0x004a984c (forward)
    mov edi, 0x550c34                            # 004a97fc
    mov esi, dword ptr [ebp - local_24]          # 004a9801
    add esi, 0x3f0                               # 004a9804
    mov ecx, 0x9                                 # 004a980a
    {load} xor edx, edx                          # 004a980f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a9811
    je.d8 L_004a984c                             # 004a9813
    # block 0x004a9815: entered by fall-through of je at 0x004a9813, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a9863
    mov eax, dword ptr [ebp - local_24]          # 004a9815
    add eax, 0x3f0                               # 004a9818
    push eax                                     # 004a981d
    mov ecx, 0x5c3a67                            # 004a981e
    call FUN_004fb77a                            # 004a9823
    mov ecx, dword ptr [ebp - local_24]          # 004a9828
    mov dx, word ptr [ecx + field_411]           # 004a982b
    push edx                                     # 004a9832
    mov ecx, 0x5c3a67                            # 004a9833
    call FUN_004fb2e3                            # 004a9838
    mov eax, dword ptr [ebp - local_34]          # 004a983d
    mov dword ptr [eax + field_e7f], 0x1         # 004a9840
    jmp.d8 L_004a9863                            # 004a984a
L_004a984c:
    # block 0x004a984c: entered by je at 0x004a9813, 4 instruction(s), falls into the block at 0x004a9863
    mov ecx, dword ptr [ebp - local_34]          # 004a984c
    movsx edx, word ptr [ecx + field_1e]         # 004a984f
    imul edx, edx, 0x8d                          # 004a9853
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a9859
L_004a9863:
    # block 0x004a9863: entered by jmp at 0x004a984a, 1 instruction(s), ends with forward jump to 0x004a98ae
    jmp.d8 L_004a98ae                            # 004a9863
L_004a9865:
    # block 0x004a9865: entered by je at 0x004a97ef, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a98ae (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a9865
    movsx ecx, word ptr [eax + field_411]        # 004a9868
    mov dword ptr [ebp - local_30], ecx          # 004a986f
    mov edx, dword ptr [ebp - local_30]          # 004a9872
    push edx                                     # 004a9875
    mov ecx, 0x5cf1eb                            # 004a9876
    call FUN_004f6334                            # 004a987b
    test eax, eax                                # 004a9880
    jne.d8 L_004a98ae                            # 004a9882
    # block 0x004a9884: entered by fall-through of jne at 0x004a9882, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004a98ae
    mov eax, dword ptr [ebp - local_24]          # 004a9884
    add eax, 0x3f0                               # 004a9887
    push eax                                     # 004a988c
    mov ecx, 0x5c3a67                            # 004a988d
    call FUN_004fba69                            # 004a9892
    mov ecx, dword ptr [ebp - local_34]          # 004a9897
    movsx edx, word ptr [ecx + field_1e]         # 004a989a
    imul edx, edx, 0x8d                          # 004a989e
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a98a4
L_004a98ae:
    # block 0x004a98ae: entered by jmp at 0x004a97f7; jmp at 0x004a9863; jne at 0x004a9882, 1 instruction(s), ends with forward jump to 0x004a9b13
    jmp.d32 L_004a9b13                           # 004a98ae
L_004a98b3:
    # block 0x004a98b3: entered by je at 0x004a8d6d, 8 instruction(s), ends with je to 0x004a98ea (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004a98b3
    mov edi, 0x550c40                            # 004a98bd
    mov esi, dword ptr [ebp - local_24]          # 004a98c2
    add esi, 0x375                               # 004a98c5
    mov ecx, 0x9                                 # 004a98cb
    {load} xor eax, eax                          # 004a98d0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a98d2
    je.d8 L_004a98ea                             # 004a98d4
    # block 0x004a98d6: entered by fall-through of je at 0x004a98d4, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a98ea
    mov ecx, dword ptr [ebp - local_24]          # 004a98d6
    add ecx, 0x375                               # 004a98d9
    push ecx                                     # 004a98df
    mov ecx, 0x5c3a67                            # 004a98e0
    call FUN_004fba69                            # 004a98e5
L_004a98ea:
    # block 0x004a98ea: entered by je at 0x004a98d4, 7 instruction(s), ends with je to 0x004a9916 (forward)
    mov edi, 0x550c4c                            # 004a98ea
    mov esi, dword ptr [ebp - local_24]          # 004a98ef
    add esi, 0x3a6                               # 004a98f2
    mov ecx, 0x9                                 # 004a98f8
    {load} xor edx, edx                          # 004a98fd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a98ff
    je.d8 L_004a9916                             # 004a9901
    # block 0x004a9903: entered by fall-through of je at 0x004a9901, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a9916
    mov eax, dword ptr [ebp - local_24]          # 004a9903
    add eax, 0x3a6                               # 004a9906
    push eax                                     # 004a990b
    mov ecx, 0x5c3a67                            # 004a990c
    call FUN_004fba69                            # 004a9911
L_004a9916:
    # block 0x004a9916: entered by je at 0x004a9901, 5 instruction(s), ends with je to 0x004a9a0b (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004a9916
    {load} xor edx, edx                          # 004a9919
    mov dl, byte ptr [ecx + field_e7e]           # 004a991b
    test edx, edx                                # 004a9921
    je.d32 L_004a9a0b                            # 004a9923
    # block 0x004a9929: entered by fall-through of je at 0x004a9923, 4 instruction(s), ends with je to 0x004a99db (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a9929
    movsx ecx, word ptr [eax + field_421]        # 004a992c
    cmp ecx, 0x270f                              # 004a9933
    je.d32 L_004a99db                            # 004a9939
    # block 0x004a993f: entered by fall-through of je at 0x004a9939, 25 instruction(s), ends with jne to 0x004a99c7 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a993f
    movsx eax, word ptr [edx + field_421]        # 004a9942
    mov dword ptr [0x5bb57b], eax                # 004a9949
    mov ecx, dword ptr [ebp - local_24]          # 004a994e
    mov dx, word ptr [ecx + field_423]           # 004a9951
    mov word ptr [0x5bb599], dx                  # 004a9958
    mov eax, dword ptr [ebp - local_24]          # 004a995f
    mov cx, word ptr [eax + field_425]           # 004a9962
    mov word ptr [0x5bb595], cx                  # 004a9969
    mov edx, dword ptr [ebp - local_24]          # 004a9970
    mov ax, word ptr [edx + field_427]           # 004a9973
    mov word ptr [0x5c39ff], ax                  # 004a997a
    mov ecx, dword ptr [ebp - local_24]          # 004a9980
    mov edx, dword ptr [ecx + field_429]         # 004a9983
    mov dword ptr [0x5bb59b], edx                # 004a9989
    mov eax, dword ptr [ebp - local_24]          # 004a998f
    mov ecx, dword ptr [eax + field_42d]         # 004a9992
    mov dword ptr [0x5bb59f], ecx                # 004a9998
    mov edx, dword ptr [ebp - local_24]          # 004a999e
    mov eax, dword ptr [edx + field_431]         # 004a99a1
    mov dword ptr [0x5bb5a3], eax                # 004a99a7
    mov ecx, dword ptr [ebp - local_24]          # 004a99ac
    movsx edx, word ptr [ecx + field_435]        # 004a99af
    cmp edx, 0x1                                 # 004a99b6
    jne.d8 L_004a99c7                            # 004a99b9
    # block 0x004a99bb: entered by fall-through of jne at 0x004a99b9, 2 instruction(s), ends with forward jump to 0x004a99d1
    mov dword ptr [0x5bb1ca], 0x0                # 004a99bb
    jmp.d8 L_004a99d1                            # 004a99c5
L_004a99c7:
    # block 0x004a99c7: entered by jne at 0x004a99b9, 1 instruction(s), falls into the block at 0x004a99d1
    mov dword ptr [0x5bb1ca], 0x1                # 004a99c7
L_004a99d1:
    # block 0x004a99d1: entered by jmp at 0x004a99c5, 1 instruction(s), falls into the block at 0x004a99db
    mov dword ptr [0x583999], 0x4                # 004a99d1
L_004a99db:
    # block 0x004a99db: entered by je at 0x004a9939, 4 instruction(s), ends with je to 0x004a9a06 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a99db
    movsx ecx, word ptr [eax + field_437]        # 004a99de
    cmp ecx, -0x1                                # 004a99e5
    je.d8 L_004a9a06                             # 004a99e8
    # block 0x004a99ea: entered by fall-through of je at 0x004a99e8, 6 instruction(s), falls into the block at 0x004a9a06
    mov edx, dword ptr [ebp - local_24]          # 004a99ea
    {load} xor eax, eax                          # 004a99ed
    mov al, byte ptr [edx + field_439]           # 004a99ef
    mov ecx, dword ptr [ebp - local_24]          # 004a99f5
    movsx edx, word ptr [ecx + field_437]        # 004a99f8
    mov dword ptr [4*edx + 0x585801], eax        # 004a99ff
L_004a9a06:
    # block 0x004a9a06: entered by je at 0x004a99e8, 1 instruction(s), ends with forward jump to 0x004a9afb
    jmp.d32 L_004a9afb                           # 004a9a06
L_004a9a0b:
    # block 0x004a9a0b: entered by je at 0x004a9923, 5 instruction(s), ends with je to 0x004a9afb (forward)
    mov eax, dword ptr [ebp - local_34]          # 004a9a0b
    {load} xor ecx, ecx                          # 004a9a0e
    mov cl, byte ptr [eax + field_e83]           # 004a9a10
    test ecx, ecx                                # 004a9a16
    je.d32 L_004a9afb                            # 004a9a18
    # block 0x004a9a1e: entered by fall-through of je at 0x004a9a18, 4 instruction(s), ends with je to 0x004a9ad0 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a9a1e
    movsx eax, word ptr [edx + field_3d7]        # 004a9a21
    cmp eax, 0x270f                              # 004a9a28
    je.d32 L_004a9ad0                            # 004a9a2d
    # block 0x004a9a33: entered by fall-through of je at 0x004a9a2d, 25 instruction(s), ends with jne to 0x004a9abc (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004a9a33
    movsx edx, word ptr [ecx + field_3d7]        # 004a9a36
    mov dword ptr [0x5bb57b], edx                # 004a9a3d
    mov eax, dword ptr [ebp - local_24]          # 004a9a43
    mov cx, word ptr [eax + field_3d9]           # 004a9a46
    mov word ptr [0x5bb599], cx                  # 004a9a4d
    mov edx, dword ptr [ebp - local_24]          # 004a9a54
    mov ax, word ptr [edx + field_3db]           # 004a9a57
    mov word ptr [0x5bb595], ax                  # 004a9a5e
    mov ecx, dword ptr [ebp - local_24]          # 004a9a64
    mov dx, word ptr [ecx + field_3dd]           # 004a9a67
    mov word ptr [0x5c39ff], dx                  # 004a9a6e
    mov eax, dword ptr [ebp - local_24]          # 004a9a75
    mov ecx, dword ptr [eax + field_3df]         # 004a9a78
    mov dword ptr [0x5bb59b], ecx                # 004a9a7e
    mov edx, dword ptr [ebp - local_24]          # 004a9a84
    mov eax, dword ptr [edx + field_3e3]         # 004a9a87
    mov dword ptr [0x5bb59f], eax                # 004a9a8d
    mov ecx, dword ptr [ebp - local_24]          # 004a9a92
    mov edx, dword ptr [ecx + field_3e7]         # 004a9a95
    mov dword ptr [0x5bb5a3], edx                # 004a9a9b
    mov eax, dword ptr [ebp - local_24]          # 004a9aa1
    movsx ecx, word ptr [eax + field_3eb]        # 004a9aa4
    cmp ecx, 0x1                                 # 004a9aab
    jne.d8 L_004a9abc                            # 004a9aae
    # block 0x004a9ab0: entered by fall-through of jne at 0x004a9aae, 2 instruction(s), ends with forward jump to 0x004a9ac6
    mov dword ptr [0x5bb1ca], 0x0                # 004a9ab0
    jmp.d8 L_004a9ac6                            # 004a9aba
L_004a9abc:
    # block 0x004a9abc: entered by jne at 0x004a9aae, 1 instruction(s), falls into the block at 0x004a9ac6
    mov dword ptr [0x5bb1ca], 0x1                # 004a9abc
L_004a9ac6:
    # block 0x004a9ac6: entered by jmp at 0x004a9aba, 1 instruction(s), falls into the block at 0x004a9ad0
    mov dword ptr [0x583999], 0x4                # 004a9ac6
L_004a9ad0:
    # block 0x004a9ad0: entered by je at 0x004a9a2d, 4 instruction(s), ends with je to 0x004a9afb (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a9ad0
    movsx eax, word ptr [edx + field_3ed]        # 004a9ad3
    cmp eax, -0x1                                # 004a9ada
    je.d8 L_004a9afb                             # 004a9add
    # block 0x004a9adf: entered by fall-through of je at 0x004a9add, 6 instruction(s), falls into the block at 0x004a9afb
    mov ecx, dword ptr [ebp - local_24]          # 004a9adf
    {load} xor edx, edx                          # 004a9ae2
    mov dl, byte ptr [ecx + field_3ef]           # 004a9ae4
    mov eax, dword ptr [ebp - local_24]          # 004a9aea
    movsx ecx, word ptr [eax + field_3ed]        # 004a9aed
    mov dword ptr [4*ecx + 0x585801], edx        # 004a9af4
L_004a9afb:
    # block 0x004a9afb: entered by jmp at 0x004a9a06; je at 0x004a9a18; je at 0x004a9add, 7 instruction(s), calls FUN_0042ba3a, FUN_004a7d1d, falls into the block at 0x004a9b13
    mov edx, dword ptr [ebp - local_34]          # 004a9afb
    mov ax, word ptr [edx + field_1e]            # 004a9afe
    push eax                                     # 004a9b02
    call FUN_0042ba3a                            # 004a9b03
    add esp, 0x4                                 # 004a9b08
    mov ecx, dword ptr [ebp - local_34]          # 004a9b0b
    call FUN_004a7d1d                            # 004a9b0e
L_004a9b13:
    # block 0x004a9b13: entered by jmp at 0x004a8d73; jmp at 0x004a97da; jmp at 0x004a98ae, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004a9b13
    pop esi                                      # 004a9b14
    {load} mov esp, ebp                          # 004a9b15
    pop ebp                                      # 004a9b17
    ret 0x4                                      # 004a9b18

