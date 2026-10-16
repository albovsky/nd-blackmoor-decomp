# FUN_004b4a68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b4a68
# extent:       0x004b4a68-0x004b5838 (3536 code bytes)
# span:         0x004b4a68-0x004b5838 (code 3536, tables 0, padding 0)
# sha256:       bfab10c4787a3de7b149cbc962b9793f9f4f6b498ac821fef3a9974fcfa05b7a
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b4a68
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_4, field_8, field_1c, field_27, field_119, field_71e, field_720, field_724, field_726, field_728, field_72a, field_74c and 12 more; [ecx + n] field_4, field_8, field_c, field_1c, field_119, field_71c, field_720, field_722, field_726, field_728, field_72a, field_74e and 13 more; [edx + n] field_c, field_1c, field_21, field_119, field_71c, field_71e, field_722, field_724, field_726, field_728, field_72a, field_752 and 13 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004dadff, FUN_004b4676, FUN_004b4913, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004b3d4d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 742 instruction(s), 41 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_21, 0x21  # offset +0x21
.equ field_27, 0x27  # offset +0x27
.equ field_119, 0x119  # offset +0x119
.equ field_71c, 0x71c  # offset +0x71c
.equ field_71e, 0x71e  # offset +0x71e
.equ field_720, 0x720  # offset +0x720
.equ field_722, 0x722  # offset +0x722
.equ field_724, 0x724  # offset +0x724
.equ field_726, 0x726  # offset +0x726
.equ field_728, 0x728  # offset +0x728
.equ field_72a, 0x72a  # offset +0x72a
.equ field_74c, 0x74c  # offset +0x74c
.equ field_74e, 0x74e  # offset +0x74e
.equ field_750, 0x750  # offset +0x750
.equ field_752, 0x752  # offset +0x752
.equ field_754, 0x754  # offset +0x754
.equ field_758, 0x758  # offset +0x758
.equ field_76e, 0x76e  # offset +0x76e
.equ field_772, 0x772  # offset +0x772
.equ field_776, 0x776  # offset +0x776
.equ field_77a, 0x77a  # offset +0x77a
.equ field_77e, 0x77e  # offset +0x77e
.equ field_83b, 0x83b  # offset +0x83b
.equ field_83d, 0x83d  # offset +0x83d
.equ field_83f, 0x83f  # offset +0x83f
.equ field_841, 0x841  # offset +0x841
.equ field_843, 0x843  # offset +0x843
.equ field_847, 0x847  # offset +0x847
.equ field_84b, 0x84b  # offset +0x84b
.equ field_84f, 0x84f  # offset +0x84f
.equ field_872, 0x872  # offset +0x872
.equ field_882, 0x882  # offset +0x882
.equ field_884, 0x884  # offset +0x884
.equ field_885, 0x885  # offset +0x885
.equ field_887, 0x887  # offset +0x887
.equ field_889, 0x889  # offset +0x889
.equ field_88b, 0x88b  # offset +0x88b
.equ field_88d, 0x88d  # offset +0x88d
.equ field_891, 0x891  # offset +0x891
.equ field_895, 0x895  # offset +0x895
.equ field_899, 0x899  # offset +0x899
.equ field_89b, 0x89b  # offset +0x89b
.equ field_89d, 0x89d  # offset +0x89d

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004b3d4d, .text + (0x004b3d4d - 0x401000)
.set FUN_004b4676, .text + (0x004b4676 - 0x401000)
.set FUN_004b4913, .text + (0x004b4913 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004b4a68 - 0x401000
.globl FUN_004b4a68
FUN_004b4a68:
    # block 0x004b4a68: entry, 12 instruction(s), ends with je to 0x004b4aa5 (forward)
    push ebp                                     # 004b4a68
    {load} mov ebp, esp                          # 004b4a69
    sub esp, 0x24                                # 004b4a6b
    push esi                                     # 004b4a6e
    push edi                                     # 004b4a6f
    mov dword ptr [ebp - local_18], ecx          # 004b4a70
    movsx eax, word ptr [ebp + arg_8]            # 004b4a73
    imul eax, eax, 0x8d                          # 004b4a77
    mov ecx, dword ptr [eax + 0x5bb632]          # 004b4a7d
    mov dword ptr [ebp - local_1c], ecx          # 004b4a83
    cmp dword ptr [ebp - local_1c], 0x0          # 004b4a86
    je.d8 L_004b4aa5                             # 004b4a8a
    # block 0x004b4a8c: entered by fall-through of je at 0x004b4a8a, 2 instruction(s), ends with je to 0x004b502a (forward)
    cmp dword ptr [ebp - local_1c], 0x1          # 004b4a8c
    je.d32 L_004b502a                            # 004b4a90
    # block 0x004b4a96: entered by fall-through of je at 0x004b4a90, 2 instruction(s), ends with je to 0x004b540c (forward)
    cmp dword ptr [ebp - local_1c], 0x2          # 004b4a96
    je.d32 L_004b540c                            # 004b4a9a
    # block 0x004b4aa0: entered by fall-through of je at 0x004b4a9a, 1 instruction(s), ends with forward jump to 0x004b5830
    jmp.d32 L_004b5830                           # 004b4aa0
L_004b4aa5:
    # block 0x004b4aa5: entered by je at 0x004b4a8a, 11 instruction(s), calls FUN_004e8d96, ends with jne to 0x004b4bc2 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b4aa5
    mov dword ptr [edx + field_76e], 0x1         # 004b4aa8
    mov dword ptr [0x5bb1ca], 0x1                # 004b4ab2
    mov eax, dword ptr [ebp - local_18]          # 004b4abc
    mov cx, word ptr [ebp + arg_8]               # 004b4abf
    mov word ptr [eax + field_728], cx           # 004b4ac3
    mov ecx, 0x571442                            # 004b4aca
    call FUN_004e8d96                            # 004b4acf
    movsx edx, word ptr [0x5919fc]               # 004b4ad4
    test edx, edx                                # 004b4adb
    jne.d32 L_004b4bc2                           # 004b4add
    # block 0x004b4ae3: entered by fall-through of jne at 0x004b4add, 9 instruction(s), ends with forward jump to 0x004b4b20
    mov eax, dword ptr [ebp - local_18]          # 004b4ae3
    movsx ecx, word ptr [eax + field_728]        # 004b4ae6
    imul ecx, ecx, 0x8d                          # 004b4aed
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b4af3
    movsx eax, word ptr [0x58c94f]               # 004b4af9
    mov cx, word ptr [edx + 2*eax + field_21]    # 004b4b00
    mov word ptr [0x591a22], cx                  # 004b4b05
    mov word ptr [ebp - local_4], 0x0            # 004b4b0c
    jmp.d8 L_004b4b20                            # 004b4b12
L_004b4b14:
    # block 0x004b4b14: entered by jmp at 0x004b4bb4, 3 instruction(s), falls into the block at 0x004b4b20
    mov dx, word ptr [ebp - local_4]             # 004b4b14
    add dx, 0x1                                  # 004b4b18
    mov word ptr [ebp - local_4], dx             # 004b4b1c
L_004b4b20:
    # block 0x004b4b20: entered by jmp at 0x004b4b12, 3 instruction(s), ends with jge to 0x004b4bb9 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b4b20
    cmp eax, 0x3                                 # 004b4b24
    jge.d32 L_004b4bb9                           # 004b4b27
    # block 0x004b4b2d: entered by fall-through of jge at 0x004b4b27, 3 instruction(s), ends with forward jump to 0x004b4b53
    mov word ptr [ebp - local_8], 0x0            # 004b4b2d
    mov word ptr [ebp - local_10], 0x0           # 004b4b33
    jmp.d8 L_004b4b53                            # 004b4b39
L_004b4b3b:
    # block 0x004b4b3b: entered by jmp at 0x004b4bb2, 6 instruction(s), falls into the block at 0x004b4b53
    mov cx, word ptr [ebp - local_8]             # 004b4b3b
    add cx, 0x1                                  # 004b4b3f
    mov word ptr [ebp - local_8], cx             # 004b4b43
    mov dx, word ptr [ebp - local_10]            # 004b4b47
    add dx, 0x1                                  # 004b4b4b
    mov word ptr [ebp - local_10], dx            # 004b4b4f
L_004b4b53:
    # block 0x004b4b53: entered by jmp at 0x004b4b39, 4 instruction(s), ends with jge to 0x004b4bb4 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b4b53
    movsx ecx, word ptr [0x591a22]               # 004b4b57
    {load} cmp eax, ecx                          # 004b4b5e
    jge.d8 L_004b4bb4                            # 004b4b60
    # block 0x004b4b62: entered by fall-through of jge at 0x004b4b60, 8 instruction(s), ends with jne to 0x004b4b9d (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b4b62
    mov eax, dword ptr [ebp - local_18]          # 004b4b66
    movsx ecx, word ptr [eax + field_728]        # 004b4b69
    imul ecx, ecx, 0x8d                          # 004b4b70
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 004b4b76
    movsx ecx, word ptr [eax + field_27]         # 004b4b7c
    {load} cmp edx, ecx                          # 004b4b80
    jne.d8 L_004b4b9d                            # 004b4b82
    # block 0x004b4b84: entered by fall-through of jne at 0x004b4b82, 6 instruction(s), ends with forward jump to 0x004b4bb2
    movsx edx, word ptr [ebp - local_4]          # 004b4b84
    imul edx, edx, 0xc                           # 004b4b88
    movsx eax, word ptr [ebp - local_8]          # 004b4b8b
    mov cx, word ptr [ebp - local_10]            # 004b4b8f
    mov word ptr [edx + 2*eax + 0x5919fe], cx    # 004b4b93
    jmp.d8 L_004b4bb2                            # 004b4b9b
L_004b4b9d:
    # block 0x004b4b9d: entered by jne at 0x004b4b82, 4 instruction(s), falls into the block at 0x004b4bb2
    movsx edx, word ptr [ebp - local_4]          # 004b4b9d
    imul edx, edx, 0xc                           # 004b4ba1
    movsx eax, word ptr [ebp - local_8]          # 004b4ba4
    mov word ptr [edx + 2*eax + 0x5919fe], 0xffff # 004b4ba8
L_004b4bb2:
    # block 0x004b4bb2: entered by jmp at 0x004b4b9b, 1 instruction(s), ends with backward jump to 0x004b4b3b
    jmp.d8 L_004b4b3b                            # 004b4bb2
L_004b4bb4:
    # block 0x004b4bb4: entered by jge at 0x004b4b60, 1 instruction(s), ends with backward jump to 0x004b4b14
    jmp.d32 L_004b4b14                           # 004b4bb4
L_004b4bb9:
    # block 0x004b4bb9: entered by jge at 0x004b4b27, 1 instruction(s), falls into the block at 0x004b4bc2
    mov word ptr [0x5919fc], 0x1                 # 004b4bb9
L_004b4bc2:
    # block 0x004b4bc2: entered by jne at 0x004b4add, 2 instruction(s), ends with forward jump to 0x004b4bd6
    mov word ptr [ebp - local_10], 0x0           # 004b4bc2
    jmp.d8 L_004b4bd6                            # 004b4bc8
L_004b4bca:
    # block 0x004b4bca: entered by jmp at 0x004b4dcb, 3 instruction(s), falls into the block at 0x004b4bd6
    mov cx, word ptr [ebp - local_10]            # 004b4bca
    add cx, 0x1                                  # 004b4bce
    mov word ptr [ebp - local_10], cx            # 004b4bd2
L_004b4bd6:
    # block 0x004b4bd6: entered by jmp at 0x004b4bc8, 4 instruction(s), ends with jge to 0x004b4dd0 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004b4bd6
    movsx eax, word ptr [0x591a22]               # 004b4bda
    {load} cmp edx, eax                          # 004b4be1
    jge.d32 L_004b4dd0                           # 004b4be3
    # block 0x004b4be9: entered by fall-through of jge at 0x004b4be3, 2 instruction(s), ends with forward jump to 0x004b4bfd
    mov word ptr [ebp - local_4], 0x0            # 004b4be9
    jmp.d8 L_004b4bfd                            # 004b4bef
L_004b4bf1:
    # block 0x004b4bf1: entered by jmp at 0x004b4dc6, 3 instruction(s), falls into the block at 0x004b4bfd
    mov cx, word ptr [ebp - local_4]             # 004b4bf1
    add cx, 0x1                                  # 004b4bf5
    mov word ptr [ebp - local_4], cx             # 004b4bf9
L_004b4bfd:
    # block 0x004b4bfd: entered by jmp at 0x004b4bef, 3 instruction(s), ends with jge to 0x004b4dcb (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b4bfd
    cmp edx, 0x3                                 # 004b4c01
    jge.d32 L_004b4dcb                           # 004b4c04
    # block 0x004b4c0a: entered by fall-through of jge at 0x004b4c04, 2 instruction(s), ends with forward jump to 0x004b4c1e
    mov word ptr [ebp - local_8], 0x0            # 004b4c0a
    jmp.d8 L_004b4c1e                            # 004b4c10
L_004b4c12:
    # block 0x004b4c12: entered by jmp at 0x004b4dc1, 3 instruction(s), falls into the block at 0x004b4c1e
    mov ax, word ptr [ebp - local_8]             # 004b4c12
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b4c16
    mov word ptr [ebp - local_8], ax             # 004b4c1a
L_004b4c1e:
    # block 0x004b4c1e: entered by jmp at 0x004b4c10, 3 instruction(s), ends with jge to 0x004b4dc6 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004b4c1e
    cmp ecx, 0x6                                 # 004b4c22
    jge.d32 L_004b4dc6                           # 004b4c25
    # block 0x004b4c2b: entered by fall-through of jge at 0x004b4c25, 97 instruction(s), ends with backward jump to 0x004b4c12
    mov edx, dword ptr [ebp - local_18]          # 004b4c2b
    movsx eax, word ptr [edx + field_728]        # 004b4c2e
    imul eax, eax, 0x8d                          # 004b4c35
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b4c3b
    movsx edx, word ptr [ebp - local_10]         # 004b4c41
    imul edx, edx, 0x120                         # 004b4c45
    lea eax, [ecx + edx + field_119]             # 004b4c4b
    movsx ecx, word ptr [ebp - local_4]          # 004b4c52
    imul ecx, ecx, 0x60                          # 004b4c56
    {load} add eax, ecx                          # 004b4c59
    movsx edx, word ptr [ebp - local_8]          # 004b4c5b
    shl edx, 0x4                                 # 004b4c5f
    mov eax, dword ptr [eax + edx + field_4]     # 004b4c62
    add eax, dword ptr [0x58318a]                # 004b4c66
    movsx ecx, word ptr [ebp - local_10]         # 004b4c6c
    imul ecx, ecx, 0x120                         # 004b4c70
    mov edx, dword ptr [ebp - local_18]          # 004b4c76
    lea ecx, [edx + ecx + field_1c]              # 004b4c79
    movsx edx, word ptr [ebp - local_4]          # 004b4c7d
    imul edx, edx, 0x60                          # 004b4c81
    {load} add ecx, edx                          # 004b4c84
    movsx edx, word ptr [ebp - local_8]          # 004b4c86
    shl edx, 0x4                                 # 004b4c8a
    mov dword ptr [ecx + edx + field_4], eax     # 004b4c8d
    mov eax, dword ptr [ebp - local_18]          # 004b4c91
    movsx ecx, word ptr [eax + field_728]        # 004b4c94
    imul ecx, ecx, 0x8d                          # 004b4c9b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b4ca1
    movsx eax, word ptr [ebp - local_10]         # 004b4ca7
    imul eax, eax, 0x120                         # 004b4cab
    lea ecx, [edx + eax + field_119]             # 004b4cb1
    movsx edx, word ptr [ebp - local_4]          # 004b4cb8
    imul edx, edx, 0x60                          # 004b4cbc
    {load} add ecx, edx                          # 004b4cbf
    movsx eax, word ptr [ebp - local_8]          # 004b4cc1
    shl eax, 0x4                                 # 004b4cc5
    mov ecx, dword ptr [ecx + eax + field_c]     # 004b4cc8
    add ecx, dword ptr [0x58318a]                # 004b4ccc
    movsx edx, word ptr [ebp - local_10]         # 004b4cd2
    imul edx, edx, 0x120                         # 004b4cd6
    mov eax, dword ptr [ebp - local_18]          # 004b4cdc
    lea edx, [eax + edx + field_1c]              # 004b4cdf
    movsx eax, word ptr [ebp - local_4]          # 004b4ce3
    imul eax, eax, 0x60                          # 004b4ce7
    {load} add edx, eax                          # 004b4cea
    movsx eax, word ptr [ebp - local_8]          # 004b4cec
    shl eax, 0x4                                 # 004b4cf0
    mov dword ptr [edx + eax + field_c], ecx     # 004b4cf3
    mov ecx, dword ptr [ebp - local_18]          # 004b4cf7
    movsx edx, word ptr [ecx + field_728]        # 004b4cfa
    imul edx, edx, 0x8d                          # 004b4d01
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b4d07
    movsx ecx, word ptr [ebp - local_10]         # 004b4d0d
    imul ecx, ecx, 0x120                         # 004b4d11
    lea edx, [eax + ecx + field_119]             # 004b4d17
    movsx eax, word ptr [ebp - local_4]          # 004b4d1e
    imul eax, eax, 0x60                          # 004b4d22
    {load} add edx, eax                          # 004b4d25
    movsx ecx, word ptr [ebp - local_8]          # 004b4d27
    shl ecx, 0x4                                 # 004b4d2b
    mov edx, dword ptr [edx + ecx]               # 004b4d2e
    add edx, dword ptr [0x583186]                # 004b4d31
    movsx eax, word ptr [ebp - local_10]         # 004b4d37
    imul eax, eax, 0x120                         # 004b4d3b
    mov ecx, dword ptr [ebp - local_18]          # 004b4d41
    lea eax, [ecx + eax + field_1c]              # 004b4d44
    movsx ecx, word ptr [ebp - local_4]          # 004b4d48
    imul ecx, ecx, 0x60                          # 004b4d4c
    {load} add eax, ecx                          # 004b4d4f
    movsx ecx, word ptr [ebp - local_8]          # 004b4d51
    shl ecx, 0x4                                 # 004b4d55
    mov dword ptr [eax + ecx], edx               # 004b4d58
    mov edx, dword ptr [ebp - local_18]          # 004b4d5b
    movsx eax, word ptr [edx + field_728]        # 004b4d5e
    imul eax, eax, 0x8d                          # 004b4d65
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b4d6b
    movsx edx, word ptr [ebp - local_10]         # 004b4d71
    imul edx, edx, 0x120                         # 004b4d75
    lea eax, [ecx + edx + field_119]             # 004b4d7b
    movsx ecx, word ptr [ebp - local_4]          # 004b4d82
    imul ecx, ecx, 0x60                          # 004b4d86
    {load} add eax, ecx                          # 004b4d89
    movsx edx, word ptr [ebp - local_8]          # 004b4d8b
    shl edx, 0x4                                 # 004b4d8f
    mov eax, dword ptr [eax + edx + field_8]     # 004b4d92
    add eax, dword ptr [0x583186]                # 004b4d96
    movsx ecx, word ptr [ebp - local_10]         # 004b4d9c
    imul ecx, ecx, 0x120                         # 004b4da0
    mov edx, dword ptr [ebp - local_18]          # 004b4da6
    lea ecx, [edx + ecx + field_1c]              # 004b4da9
    movsx edx, word ptr [ebp - local_4]          # 004b4dad
    imul edx, edx, 0x60                          # 004b4db1
    {load} add ecx, edx                          # 004b4db4
    movsx edx, word ptr [ebp - local_8]          # 004b4db6
    shl edx, 0x4                                 # 004b4dba
    mov dword ptr [ecx + edx + field_8], eax     # 004b4dbd
    jmp.d32 L_004b4c12                           # 004b4dc1
L_004b4dc6:
    # block 0x004b4dc6: entered by jge at 0x004b4c25, 1 instruction(s), ends with backward jump to 0x004b4bf1
    jmp.d32 L_004b4bf1                           # 004b4dc6
L_004b4dcb:
    # block 0x004b4dcb: entered by jge at 0x004b4c04, 1 instruction(s), ends with backward jump to 0x004b4bca
    jmp.d32 L_004b4bca                           # 004b4dcb
L_004b4dd0:
    # block 0x004b4dd0: entered by jge at 0x004b4be3, 6 instruction(s), calls FUN_004d39f9, ends with jne to 0x004b4e21 (forward)
    call FUN_004d39f9                            # 004b4dd0
    mov ecx, dword ptr [ebp - local_18]          # 004b4dd5
    mov word ptr [ecx + field_726], ax           # 004b4dd8
    mov edx, dword ptr [ebp - local_18]          # 004b4ddf
    cmp dword ptr [edx + field_754], 0x0         # 004b4de2
    jne.d8 L_004b4e21                            # 004b4de9
    # block 0x004b4deb: entered by fall-through of jne at 0x004b4de9, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x004b4e21
    push 0x551958                                # 004b4deb
    push 0x6                                     # 004b4df0
    mov eax, dword ptr [ebp - local_18]          # 004b4df2
    movsx ecx, word ptr [eax + field_728]        # 004b4df5
    imul ecx, ecx, 0x8d                          # 004b4dfc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b4e02
    push edx                                     # 004b4e08
    push 0x55196c                                # 004b4e09
    mov ecx, 0x5cf659                            # 004b4e0e
    call FUN_004c2790                            # 004b4e13
    mov ecx, dword ptr [ebp - local_18]          # 004b4e18
    mov dword ptr [ecx + field_754], eax         # 004b4e1b
L_004b4e21:
    # block 0x004b4e21: entered by jne at 0x004b4de9, 102 instruction(s), calls FUN_004fb77a, ends with forward jump to 0x004b5830
    mov edx, dword ptr [ebp - local_18]          # 004b4e21
    movsx eax, word ptr [edx + field_726]        # 004b4e24
    imul eax, eax, 0x4a                          # 004b4e2b
    mov dword ptr [eax + 0x5d1591], 0xa          # 004b4e2e
    mov ecx, dword ptr [ebp - local_18]          # 004b4e38
    movsx edx, word ptr [ecx + field_726]        # 004b4e3b
    imul edx, edx, 0x4a                          # 004b4e42
    mov dword ptr [edx + 0x5d1595], 0x4b5848     # 004b4e45
    mov eax, dword ptr [ebp - local_18]          # 004b4e4f
    movsx ecx, word ptr [eax + field_726]        # 004b4e52
    imul ecx, ecx, 0x4a                          # 004b4e59
    mov edx, dword ptr [ebp - local_18]          # 004b4e5c
    mov eax, dword ptr [edx + field_754]         # 004b4e5f
    mov dword ptr [ecx + 0x5d1599], eax          # 004b4e65
    mov ecx, dword ptr [ebp - local_18]          # 004b4e6b
    movsx edx, word ptr [ecx + field_726]        # 004b4e6e
    imul edx, edx, 0x4a                          # 004b4e75
    mov dword ptr [edx + 0x5d159d], 0x0          # 004b4e78
    mov eax, dword ptr [ebp - local_18]          # 004b4e82
    movsx ecx, word ptr [eax + field_726]        # 004b4e85
    imul ecx, ecx, 0x4a                          # 004b4e8c
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 004b4e8f
    mov edx, dword ptr [ebp - local_18]          # 004b4e99
    movsx eax, word ptr [edx + field_726]        # 004b4e9c
    imul eax, eax, 0x4a                          # 004b4ea3
    mov dword ptr [eax + 0x5d15a5], 0x1          # 004b4ea6
    mov ecx, dword ptr [ebp - local_18]          # 004b4eb0
    movsx edx, word ptr [ecx + field_726]        # 004b4eb3
    imul edx, edx, 0x4a                          # 004b4eba
    mov dword ptr [edx + 0x5d15a9], 0x1          # 004b4ebd
    mov eax, dword ptr [ebp - local_18]          # 004b4ec7
    movsx ecx, word ptr [eax + field_726]        # 004b4eca
    imul ecx, ecx, 0x4a                          # 004b4ed1
    mov word ptr [ecx + 0x5d15ad], 0x0           # 004b4ed4
    mov edi, 0x551974                            # 004b4edd
    mov edx, dword ptr [ebp - local_18]          # 004b4ee2
    movsx eax, word ptr [edx + field_726]        # 004b4ee5
    imul eax, eax, 0x4a                          # 004b4eec
    add eax, 0x5d15b3                            # 004b4eef
    {load} mov edx, eax                          # 004b4ef4
    or ecx, -0x1                                 # 004b4ef6
    {load} xor eax, eax                          # 004b4ef9
    repne scasb al, byte ptr es:[edi]            # 004b4efb
    not ecx                                      # 004b4efd
    {load} sub edi, ecx                          # 004b4eff
    {load} mov esi, edi                          # 004b4f01
    {load} mov eax, ecx                          # 004b4f03
    {load} mov edi, edx                          # 004b4f05
    shr ecx, 0x2                                 # 004b4f07
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b4f0a
    {load} mov ecx, eax                          # 004b4f0c
    and ecx, 0x3                                 # 004b4f0e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004b4f11
    mov ecx, dword ptr [ebp - local_18]          # 004b4f13
    movsx edx, word ptr [ecx + field_728]        # 004b4f16
    imul edx, edx, 0x8d                          # 004b4f1d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b4f23
    add eax, 0x7d9                               # 004b4f29
    push eax                                     # 004b4f2e
    mov ecx, 0x5c3a67                            # 004b4f2f
    call FUN_004fb77a                            # 004b4f34
    mov ecx, dword ptr [ebp - local_18]          # 004b4f39
    movsx edx, word ptr [ecx + field_728]        # 004b4f3c
    imul edx, edx, 0x8d                          # 004b4f43
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b4f49
    add eax, 0x80a                               # 004b4f4f
    push eax                                     # 004b4f54
    mov ecx, 0x5c3a67                            # 004b4f55
    call FUN_004fb77a                            # 004b4f5a
    mov ecx, dword ptr [ebp - local_18]          # 004b4f5f
    mov word ptr [ecx + field_71c], 0xffff       # 004b4f62
    mov edx, dword ptr [ebp - local_18]          # 004b4f6b
    mov word ptr [edx + field_72a], 0xffff       # 004b4f6e
    mov eax, dword ptr [ebp - local_18]          # 004b4f77
    mov word ptr [eax + field_71e], 0x0          # 004b4f7a
    mov ecx, dword ptr [ebp - local_18]          # 004b4f83
    mov word ptr [ecx + field_720], 0x0          # 004b4f86
    mov edx, dword ptr [ebp - local_18]          # 004b4f8f
    mov word ptr [edx + field_722], 0x0          # 004b4f92
    mov eax, dword ptr [ebp - local_18]          # 004b4f9b
    mov word ptr [eax + field_724], 0x0          # 004b4f9e
    mov ecx, dword ptr [ebp - local_18]          # 004b4fa7
    mov word ptr [ecx + field_750], 0x0          # 004b4faa
    mov edx, dword ptr [ebp - local_18]          # 004b4fb3
    mov word ptr [edx + field_752], 0x0          # 004b4fb6
    mov eax, dword ptr [ebp - local_18]          # 004b4fbf
    mov word ptr [eax + field_74c], 0x0          # 004b4fc2
    mov ecx, dword ptr [ebp - local_18]          # 004b4fcb
    mov word ptr [ecx + field_74e], 0x0          # 004b4fce
    mov edx, dword ptr [ebp - local_18]          # 004b4fd7
    mov dword ptr [edx + field_77a], 0x0         # 004b4fda
    mov eax, dword ptr [ebp - local_18]          # 004b4fe4
    mov dword ptr [eax + field_77e], 0x0         # 004b4fe7
    mov ecx, dword ptr [ebp - local_18]          # 004b4ff1
    mov dword ptr [ecx + field_772], 0x0         # 004b4ff4
    mov edx, dword ptr [ebp - local_18]          # 004b4ffe
    mov dword ptr [edx + field_776], 0x0         # 004b5001
    mov eax, dword ptr [ebp - local_18]          # 004b500b
    movsx ecx, word ptr [eax + field_728]        # 004b500e
    imul ecx, ecx, 0x8d                          # 004b5015
    mov dword ptr [ecx + 0x5bb632], 0x1          # 004b501b
    jmp.d32 L_004b5830                           # 004b5025
L_004b502a:
    # block 0x004b502a: entered by je at 0x004b4a90, 5 instruction(s), ends with je to 0x004b5055 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b502a
    mov eax, dword ptr [edx + field_772]         # 004b502d
    mov dword ptr [ebp - local_20], eax          # 004b5033
    cmp dword ptr [ebp - local_20], 0x0          # 004b5036
    je.d8 L_004b5055                             # 004b503a
    # block 0x004b503c: entered by fall-through of je at 0x004b503a, 2 instruction(s), ends with je to 0x004b52f0 (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 004b503c
    je.d32 L_004b52f0                            # 004b5040
    # block 0x004b5046: entered by fall-through of je at 0x004b5040, 2 instruction(s), ends with je to 0x004b5395 (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 004b5046
    je.d32 L_004b5395                            # 004b504a
    # block 0x004b5050: entered by fall-through of je at 0x004b504a, 1 instruction(s), ends with forward jump to 0x004b5407
    jmp.d32 L_004b5407                           # 004b5050
L_004b5055:
    # block 0x004b5055: entered by je at 0x004b503a, 7 instruction(s), calls FUN_004dadff, ends with je to 0x004b5086 (forward)
    mov ecx, 0x5830a6                            # 004b5055
    call FUN_004dadff                            # 004b505a
    mov ecx, dword ptr [ebp - local_18]          # 004b505f
    mov edx, dword ptr [ecx + field_776]         # 004b5062
    mov dword ptr [ebp - local_24], edx          # 004b5068
    cmp dword ptr [ebp - local_24], 0x0          # 004b506b
    je.d8 L_004b5086                             # 004b506f
    # block 0x004b5071: entered by fall-through of je at 0x004b506f, 2 instruction(s), ends with je to 0x004b50ee (forward)
    cmp dword ptr [ebp - local_24], 0x1          # 004b5071
    je.d8 L_004b50ee                             # 004b5075
    # block 0x004b5077: entered by fall-through of je at 0x004b5075, 2 instruction(s), ends with je to 0x004b5266 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 004b5077
    je.d32 L_004b5266                            # 004b507b
    # block 0x004b5081: entered by fall-through of je at 0x004b507b, 1 instruction(s), ends with forward jump to 0x004b52eb
    jmp.d32 L_004b52eb                           # 004b5081
L_004b5086:
    # block 0x004b5086: entered by je at 0x004b506f, 2 instruction(s), ends with jne to 0x004b50e9 (forward)
    cmp dword ptr [0x5c39e5], 0x2738             # 004b5086
    jne.d8 L_004b50e9                            # 004b5090
    # block 0x004b5092: entered by fall-through of jne at 0x004b5090, 4 instruction(s), ends with jl to 0x004b50e9 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b5092
    movsx ecx, word ptr [eax + field_758]        # 004b5095
    test ecx, ecx                                # 004b509c
    jl.d8 L_004b50e9                             # 004b509e
    # block 0x004b50a0: entered by fall-through of jl at 0x004b509e, 4 instruction(s), ends with jge to 0x004b50e9 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b50a0
    movsx eax, word ptr [edx + field_758]        # 004b50a3
    cmp eax, 0x3                                 # 004b50aa
    jge.d8 L_004b50e9                            # 004b50ad
    # block 0x004b50af: entered by fall-through of jge at 0x004b50ad, 4 instruction(s), ends with jne to 0x004b50e9 (forward)
    {load} xor ecx, ecx                          # 004b50af
    mov cl, byte ptr [0x58321d]                  # 004b50b1
    cmp ecx, 0x1                                 # 004b50b7
    jne.d8 L_004b50e9                            # 004b50ba
    # block 0x004b50bc: entered by fall-through of jne at 0x004b50ba, 8 instruction(s), calls FUN_004b4676, ends with je to 0x004b50e9 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b50bc
    mov eax, dword ptr [ebp - local_18]          # 004b50bf
    mov cx, word ptr [eax + field_758]           # 004b50c2
    mov word ptr [edx + field_72a], cx           # 004b50c9
    mov ecx, dword ptr [ebp - local_18]          # 004b50d0
    call FUN_004b4676                            # 004b50d3
    test eax, eax                                # 004b50d8
    je.d8 L_004b50e9                             # 004b50da
    # block 0x004b50dc: entered by fall-through of je at 0x004b50da, 2 instruction(s), falls into the block at 0x004b50e9
    mov edx, dword ptr [ebp - local_18]          # 004b50dc
    mov dword ptr [edx + field_776], 0x1         # 004b50df
L_004b50e9:
    # block 0x004b50e9: entered by jne at 0x004b5090; jl at 0x004b509e; jge at 0x004b50ad; jne at 0x004b50ba; more, 1 instruction(s), ends with forward jump to 0x004b52eb
    jmp.d32 L_004b52eb                           # 004b50e9
L_004b50ee:
    # block 0x004b50ee: entered by je at 0x004b5075, 4 instruction(s), ends with jne to 0x004b5261 (forward)
    {load} xor eax, eax                          # 004b50ee
    mov al, byte ptr [0x58321d]                  # 004b50f0
    test eax, eax                                # 004b50f5
    jne.d32 L_004b5261                           # 004b50f7
    # block 0x004b50fd: entered by fall-through of jne at 0x004b50f7, 4 instruction(s), ends with jl to 0x004b5236 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b50fd
    movsx edx, word ptr [ecx + field_758]        # 004b5100
    test edx, edx                                # 004b5107
    jl.d32 L_004b5236                            # 004b5109
    # block 0x004b510f: entered by fall-through of jl at 0x004b5109, 4 instruction(s), ends with jge to 0x004b5236 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b510f
    movsx ecx, word ptr [eax + field_758]        # 004b5112
    cmp ecx, 0x3                                 # 004b5119
    jge.d32 L_004b5236                           # 004b511c
    # block 0x004b5122: entered by fall-through of jge at 0x004b511c, 6 instruction(s), ends with jne to 0x004b516c (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b5122
    movsx eax, word ptr [edx + field_758]        # 004b5125
    mov ecx, dword ptr [ebp - local_18]          # 004b512c
    movsx edx, word ptr [ecx + field_72a]        # 004b512f
    {load} cmp eax, edx                          # 004b5136
    jne.d8 L_004b516c                            # 004b5138
    # block 0x004b513a: entered by fall-through of jne at 0x004b5138, 4 instruction(s), ends with je to 0x004b516c (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b513a
    movsx ecx, word ptr [eax + field_72a]        # 004b513d
    cmp ecx, -0x1                                # 004b5144
    je.d8 L_004b516c                             # 004b5147
    # block 0x004b5149: entered by fall-through of je at 0x004b5147, 9 instruction(s), calls FUN_004b4913, ends with forward jump to 0x004b5234
    mov edx, dword ptr [ebp - local_18]          # 004b5149
    mov ax, word ptr [edx + field_72a]           # 004b514c
    push eax                                     # 004b5153
    mov ecx, dword ptr [ebp - local_18]          # 004b5154
    mov dx, word ptr [ecx + field_71c]           # 004b5157
    push edx                                     # 004b515e
    mov ecx, dword ptr [ebp - local_18]          # 004b515f
    call FUN_004b4913                            # 004b5162
    jmp.d32 L_004b5234                           # 004b5167
L_004b516c:
    # block 0x004b516c: entered by jne at 0x004b5138; je at 0x004b5147, 4 instruction(s), ends with forward jump to 0x004b5188
    movsx eax, word ptr [0x591a22]               # 004b516c
    sub eax, 0x1                                 # 004b5173
    mov word ptr [ebp - local_8], ax             # 004b5176
    jmp.d8 L_004b5188                            # 004b517a
L_004b517c:
    # block 0x004b517c: entered by jmp at 0x004b5208, 3 instruction(s), falls into the block at 0x004b5188
    mov cx, word ptr [ebp - local_8]             # 004b517c
    sub cx, 0x1                                  # 004b5180
    mov word ptr [ebp - local_8], cx             # 004b5184
L_004b5188:
    # block 0x004b5188: entered by jmp at 0x004b517a, 3 instruction(s), ends with jl to 0x004b520d (forward)
    movsx edx, word ptr [ebp - local_8]          # 004b5188
    test edx, edx                                # 004b518c
    jl.d8 L_004b520d                             # 004b518e
    # block 0x004b5190: entered by fall-through of jl at 0x004b518e, 9 instruction(s), ends with je to 0x004b5208 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b5190
    movsx ecx, word ptr [eax + field_758]        # 004b5193
    imul ecx, ecx, 0xc                           # 004b519a
    movsx edx, word ptr [ebp - local_8]          # 004b519d
    mov ax, word ptr [ecx + 2*edx + 0x5919fe]    # 004b51a1
    mov word ptr [ebp - local_c], ax             # 004b51a9
    movsx ecx, word ptr [ebp - local_c]          # 004b51ad
    cmp ecx, -0x1                                # 004b51b1
    je.d8 L_004b5208                             # 004b51b4
    # block 0x004b51b6: entered by fall-through of je at 0x004b51b4, 5 instruction(s), ends with jle to 0x004b51e8 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b51b6
    movsx eax, word ptr [edx + field_71c]        # 004b51b9
    movsx ecx, word ptr [ebp - local_c]          # 004b51c0
    {load} cmp eax, ecx                          # 004b51c4
    jle.d8 L_004b51e8                            # 004b51c6
    # block 0x004b51c8: entered by fall-through of jle at 0x004b51c6, 9 instruction(s), calls FUN_004b4913, ends with forward jump to 0x004b5206
    mov edx, dword ptr [ebp - local_18]          # 004b51c8
    mov ax, word ptr [edx + field_758]           # 004b51cb
    push eax                                     # 004b51d2
    mov ecx, dword ptr [ebp - local_18]          # 004b51d3
    mov dx, word ptr [ecx + field_71c]           # 004b51d6
    push edx                                     # 004b51dd
    mov ecx, dword ptr [ebp - local_18]          # 004b51de
    call FUN_004b4913                            # 004b51e1
    jmp.d8 L_004b5206                            # 004b51e6
L_004b51e8:
    # block 0x004b51e8: entered by jle at 0x004b51c6, 8 instruction(s), calls FUN_004b4913, falls into the block at 0x004b5206
    mov eax, dword ptr [ebp - local_18]          # 004b51e8
    mov cx, word ptr [eax + field_72a]           # 004b51eb
    push ecx                                     # 004b51f2
    mov edx, dword ptr [ebp - local_18]          # 004b51f3
    mov ax, word ptr [edx + field_71c]           # 004b51f6
    push eax                                     # 004b51fd
    mov ecx, dword ptr [ebp - local_18]          # 004b51fe
    call FUN_004b4913                            # 004b5201
L_004b5206:
    # block 0x004b5206: entered by jmp at 0x004b51e6, 1 instruction(s), ends with forward jump to 0x004b520d
    jmp.d8 L_004b520d                            # 004b5206
L_004b5208:
    # block 0x004b5208: entered by je at 0x004b51b4, 1 instruction(s), ends with backward jump to 0x004b517c
    jmp.d32 L_004b517c                           # 004b5208
L_004b520d:
    # block 0x004b520d: entered by jl at 0x004b518e; jmp at 0x004b5206, 3 instruction(s), ends with jne to 0x004b5234 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004b520d
    cmp ecx, -0x1                                # 004b5211
    jne.d8 L_004b5234                            # 004b5214
    # block 0x004b5216: entered by fall-through of jne at 0x004b5214, 8 instruction(s), calls FUN_004b4913, falls into the block at 0x004b5234
    mov edx, dword ptr [ebp - local_18]          # 004b5216
    mov ax, word ptr [edx + field_758]           # 004b5219
    push eax                                     # 004b5220
    mov ecx, dword ptr [ebp - local_18]          # 004b5221
    mov dx, word ptr [ecx + field_71c]           # 004b5224
    push edx                                     # 004b522b
    mov ecx, dword ptr [ebp - local_18]          # 004b522c
    call FUN_004b4913                            # 004b522f
L_004b5234:
    # block 0x004b5234: entered by jmp at 0x004b5167; jne at 0x004b5214, 1 instruction(s), ends with forward jump to 0x004b5254
    jmp.d8 L_004b5254                            # 004b5234
L_004b5236:
    # block 0x004b5236: entered by jl at 0x004b5109; jge at 0x004b511c, 8 instruction(s), calls FUN_004b4913, falls into the block at 0x004b5254
    mov eax, dword ptr [ebp - local_18]          # 004b5236
    mov cx, word ptr [eax + field_72a]           # 004b5239
    push ecx                                     # 004b5240
    mov edx, dword ptr [ebp - local_18]          # 004b5241
    mov ax, word ptr [edx + field_71c]           # 004b5244
    push eax                                     # 004b524b
    mov ecx, dword ptr [ebp - local_18]          # 004b524c
    call FUN_004b4913                            # 004b524f
L_004b5254:
    # block 0x004b5254: entered by jmp at 0x004b5234, 2 instruction(s), falls into the block at 0x004b5261
    mov ecx, dword ptr [ebp - local_18]          # 004b5254
    mov dword ptr [ecx + field_776], 0x2         # 004b5257
L_004b5261:
    # block 0x004b5261: entered by jne at 0x004b50f7, 1 instruction(s), ends with forward jump to 0x004b52eb
    jmp.d32 L_004b52eb                           # 004b5261
L_004b5266:
    # block 0x004b5266: entered by je at 0x004b507b, 22 instruction(s), falls into the block at 0x004b52eb
    mov edx, dword ptr [ebp - local_18]          # 004b5266
    mov word ptr [edx + field_71c], 0xffff       # 004b5269
    mov eax, dword ptr [ebp - local_18]          # 004b5272
    mov word ptr [eax + field_72a], 0xffff       # 004b5275
    mov ecx, dword ptr [ebp - local_18]          # 004b527e
    mov word ptr [ecx + field_750], 0x0          # 004b5281
    mov edx, dword ptr [ebp - local_18]          # 004b528a
    mov word ptr [edx + field_752], 0x0          # 004b528d
    mov eax, dword ptr [ebp - local_18]          # 004b5296
    mov word ptr [eax + field_74c], 0x0          # 004b5299
    mov ecx, dword ptr [ebp - local_18]          # 004b52a2
    mov word ptr [ecx + field_74e], 0x0          # 004b52a5
    mov edx, dword ptr [ebp - local_18]          # 004b52ae
    mov word ptr [edx + field_71e], 0x0          # 004b52b1
    mov eax, dword ptr [ebp - local_18]          # 004b52ba
    mov word ptr [eax + field_720], 0x0          # 004b52bd
    mov ecx, dword ptr [ebp - local_18]          # 004b52c6
    mov word ptr [ecx + field_722], 0x0          # 004b52c9
    mov edx, dword ptr [ebp - local_18]          # 004b52d2
    mov word ptr [edx + field_724], 0x0          # 004b52d5
    mov eax, dword ptr [ebp - local_18]          # 004b52de
    mov dword ptr [eax + field_776], 0x0         # 004b52e1
L_004b52eb:
    # block 0x004b52eb: entered by jmp at 0x004b5081; jmp at 0x004b50e9; jmp at 0x004b5261, 1 instruction(s), ends with forward jump to 0x004b5407
    jmp.d32 L_004b5407                           # 004b52eb
L_004b52f0:
    # block 0x004b52f0: entered by je at 0x004b5040, 10 instruction(s), ends with je to 0x004b5379 (forward)
    mov edi, 0x551984                            # 004b52f0
    mov ecx, dword ptr [ebp - local_18]          # 004b52f5
    movsx edx, word ptr [ecx + field_728]        # 004b52f8
    imul edx, edx, 0x8d                          # 004b52ff
    mov esi, dword ptr [edx + 0x5bb5e5]          # 004b5305
    add esi, 0x851                               # 004b530b
    mov ecx, 0x9                                 # 004b5311
    {load} xor eax, eax                          # 004b5316
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b5318
    je.d8 L_004b5379                             # 004b531a
    # block 0x004b531c: entered by fall-through of je at 0x004b531a, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004b5393
    mov ecx, dword ptr [ebp - local_18]          # 004b531c
    movsx edx, word ptr [ecx + field_728]        # 004b531f
    imul edx, edx, 0x8d                          # 004b5326
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b532c
    add eax, 0x851                               # 004b5332
    push eax                                     # 004b5337
    mov ecx, 0x5c3a67                            # 004b5338
    call FUN_004fb77a                            # 004b533d
    mov ecx, dword ptr [ebp - local_18]          # 004b5342
    movsx edx, word ptr [ecx + field_728]        # 004b5345
    imul edx, edx, 0x8d                          # 004b534c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b5352
    mov cx, word ptr [eax + field_872]           # 004b5358
    push ecx                                     # 004b535f
    mov ecx, 0x5c3a67                            # 004b5360
    call FUN_004fb2e3                            # 004b5365
    mov edx, dword ptr [ebp - local_18]          # 004b536a
    mov dword ptr [edx + field_772], 0x2         # 004b536d
    jmp.d8 L_004b5393                            # 004b5377
L_004b5379:
    # block 0x004b5379: entered by je at 0x004b531a, 4 instruction(s), falls into the block at 0x004b5393
    mov eax, dword ptr [ebp - local_18]          # 004b5379
    movsx ecx, word ptr [eax + field_728]        # 004b537c
    imul ecx, ecx, 0x8d                          # 004b5383
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004b5389
L_004b5393:
    # block 0x004b5393: entered by jmp at 0x004b5377, 1 instruction(s), ends with forward jump to 0x004b5407
    jmp.d8 L_004b5407                            # 004b5393
L_004b5395:
    # block 0x004b5395: entered by je at 0x004b504a, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x004b5407 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b5395
    movsx eax, word ptr [edx + field_728]        # 004b5398
    imul eax, eax, 0x8d                          # 004b539f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b53a5
    movsx edx, word ptr [ecx + field_872]        # 004b53ab
    mov dword ptr [ebp - local_14], edx          # 004b53b2
    mov eax, dword ptr [ebp - local_14]          # 004b53b5
    push eax                                     # 004b53b8
    mov ecx, 0x5cf1eb                            # 004b53b9
    call FUN_004f6334                            # 004b53be
    test eax, eax                                # 004b53c3
    jne.d8 L_004b5407                            # 004b53c5
    # block 0x004b53c7: entered by fall-through of jne at 0x004b53c5, 12 instruction(s), calls FUN_004fba69, falls into the block at 0x004b5407
    mov ecx, dword ptr [ebp - local_18]          # 004b53c7
    movsx edx, word ptr [ecx + field_728]        # 004b53ca
    imul edx, edx, 0x8d                          # 004b53d1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b53d7
    add eax, 0x851                               # 004b53dd
    push eax                                     # 004b53e2
    mov ecx, 0x5c3a67                            # 004b53e3
    call FUN_004fba69                            # 004b53e8
    mov ecx, dword ptr [ebp - local_18]          # 004b53ed
    movsx edx, word ptr [ecx + field_728]        # 004b53f0
    imul edx, edx, 0x8d                          # 004b53f7
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b53fd
L_004b5407:
    # block 0x004b5407: entered by jmp at 0x004b5050; jmp at 0x004b52eb; jmp at 0x004b5393; jne at 0x004b53c5, 1 instruction(s), ends with forward jump to 0x004b5830
    jmp.d32 L_004b5830                           # 004b5407
L_004b540c:
    # block 0x004b540c: entered by je at 0x004b4a9a, 20 instruction(s), calls FUN_004fba69, ends with je to 0x004b563b (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004b540c
    mov eax, dword ptr [ebp - local_18]          # 004b5416
    movsx ecx, word ptr [eax + field_728]        # 004b5419
    imul ecx, ecx, 0x8d                          # 004b5420
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b5426
    add edx, 0x7d9                               # 004b542c
    push edx                                     # 004b5432
    mov ecx, 0x5c3a67                            # 004b5433
    call FUN_004fba69                            # 004b5438
    mov eax, dword ptr [ebp - local_18]          # 004b543d
    movsx ecx, word ptr [eax + field_728]        # 004b5440
    imul ecx, ecx, 0x8d                          # 004b5447
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b544d
    add edx, 0x80a                               # 004b5453
    push edx                                     # 004b5459
    mov ecx, 0x5c3a67                            # 004b545a
    call FUN_004fba69                            # 004b545f
    mov eax, dword ptr [ebp - local_18]          # 004b5464
    cmp dword ptr [eax + field_77e], 0x0         # 004b5467
    je.d32 L_004b563b                            # 004b546e
    # block 0x004b5474: entered by fall-through of je at 0x004b546e, 7 instruction(s), ends with je to 0x004b55d2 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b5474
    movsx edx, word ptr [ecx + field_728]        # 004b5477
    imul edx, edx, 0x8d                          # 004b547e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b5484
    movsx ecx, word ptr [eax + field_885]        # 004b548a
    cmp ecx, 0x270f                              # 004b5491
    je.d32 L_004b55d2                            # 004b5497
    # block 0x004b549d: entered by fall-through of je at 0x004b5497, 49 instruction(s), ends with jne to 0x004b55be (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b549d
    movsx eax, word ptr [edx + field_728]        # 004b54a0
    imul eax, eax, 0x8d                          # 004b54a7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b54ad
    movsx edx, word ptr [ecx + field_885]        # 004b54b3
    mov dword ptr [0x5bb57b], edx                # 004b54ba
    mov eax, dword ptr [ebp - local_18]          # 004b54c0
    movsx ecx, word ptr [eax + field_728]        # 004b54c3
    imul ecx, ecx, 0x8d                          # 004b54ca
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b54d0
    mov ax, word ptr [edx + field_887]           # 004b54d6
    mov word ptr [0x5bb599], ax                  # 004b54dd
    mov ecx, dword ptr [ebp - local_18]          # 004b54e3
    movsx edx, word ptr [ecx + field_728]        # 004b54e6
    imul edx, edx, 0x8d                          # 004b54ed
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b54f3
    mov cx, word ptr [eax + field_889]           # 004b54f9
    mov word ptr [0x5bb595], cx                  # 004b5500
    mov edx, dword ptr [ebp - local_18]          # 004b5507
    movsx eax, word ptr [edx + field_728]        # 004b550a
    imul eax, eax, 0x8d                          # 004b5511
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b5517
    mov dx, word ptr [ecx + field_88b]           # 004b551d
    mov word ptr [0x5c39ff], dx                  # 004b5524
    mov eax, dword ptr [ebp - local_18]          # 004b552b
    movsx ecx, word ptr [eax + field_728]        # 004b552e
    imul ecx, ecx, 0x8d                          # 004b5535
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b553b
    mov eax, dword ptr [edx + field_88d]         # 004b5541
    mov dword ptr [0x5bb59b], eax                # 004b5547
    mov ecx, dword ptr [ebp - local_18]          # 004b554c
    movsx edx, word ptr [ecx + field_728]        # 004b554f
    imul edx, edx, 0x8d                          # 004b5556
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b555c
    mov ecx, dword ptr [eax + field_891]         # 004b5562
    mov dword ptr [0x5bb59f], ecx                # 004b5568
    mov edx, dword ptr [ebp - local_18]          # 004b556e
    movsx eax, word ptr [edx + field_728]        # 004b5571
    imul eax, eax, 0x8d                          # 004b5578
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b557e
    mov edx, dword ptr [ecx + field_895]         # 004b5584
    mov dword ptr [0x5bb5a3], edx                # 004b558a
    mov eax, dword ptr [ebp - local_18]          # 004b5590
    movsx ecx, word ptr [eax + field_728]        # 004b5593
    imul ecx, ecx, 0x8d                          # 004b559a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b55a0
    movsx eax, word ptr [edx + field_899]        # 004b55a6
    cmp eax, 0x1                                 # 004b55ad
    jne.d8 L_004b55be                            # 004b55b0
    # block 0x004b55b2: entered by fall-through of jne at 0x004b55b0, 2 instruction(s), ends with forward jump to 0x004b55c8
    mov dword ptr [0x5bb1ca], 0x0                # 004b55b2
    jmp.d8 L_004b55c8                            # 004b55bc
L_004b55be:
    # block 0x004b55be: entered by jne at 0x004b55b0, 1 instruction(s), falls into the block at 0x004b55c8
    mov dword ptr [0x5bb1ca], 0x1                # 004b55be
L_004b55c8:
    # block 0x004b55c8: entered by jmp at 0x004b55bc, 1 instruction(s), falls into the block at 0x004b55d2
    mov dword ptr [0x583999], 0x4                # 004b55c8
L_004b55d2:
    # block 0x004b55d2: entered by je at 0x004b5497, 7 instruction(s), ends with je to 0x004b5636 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b55d2
    movsx edx, word ptr [ecx + field_728]        # 004b55d5
    imul edx, edx, 0x8d                          # 004b55dc
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b55e2
    movsx ecx, word ptr [eax + field_89b]        # 004b55e8
    cmp ecx, -0x1                                # 004b55ef
    je.d8 L_004b5636                             # 004b55f2
    # block 0x004b55f4: entered by fall-through of je at 0x004b55f2, 12 instruction(s), falls into the block at 0x004b5636
    mov edx, dword ptr [ebp - local_18]          # 004b55f4
    movsx eax, word ptr [edx + field_728]        # 004b55f7
    imul eax, eax, 0x8d                          # 004b55fe
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b5604
    {load} xor edx, edx                          # 004b560a
    mov dl, byte ptr [ecx + field_89d]           # 004b560c
    mov eax, dword ptr [ebp - local_18]          # 004b5612
    movsx ecx, word ptr [eax + field_728]        # 004b5615
    imul ecx, ecx, 0x8d                          # 004b561c
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 004b5622
    movsx ecx, word ptr [eax + field_89b]        # 004b5628
    mov dword ptr [4*ecx + 0x585801], edx        # 004b562f
L_004b5636:
    # block 0x004b5636: entered by je at 0x004b55f2, 1 instruction(s), ends with forward jump to 0x004b5815
    jmp.d32 L_004b5815                           # 004b5636
L_004b563b:
    # block 0x004b563b: entered by je at 0x004b546e, 3 instruction(s), ends with je to 0x004b5815 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b563b
    cmp dword ptr [edx + field_77a], 0x0         # 004b563e
    je.d32 L_004b5815                            # 004b5645
    # block 0x004b564b: entered by fall-through of je at 0x004b5645, 8 instruction(s), ends with je to 0x004b57b1 (forward)
    mov word ptr [0x5919fc], 0x0                 # 004b564b
    mov eax, dword ptr [ebp - local_18]          # 004b5654
    movsx ecx, word ptr [eax + field_728]        # 004b5657
    imul ecx, ecx, 0x8d                          # 004b565e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b5664
    movsx eax, word ptr [edx + field_83b]        # 004b566a
    cmp eax, 0x270f                              # 004b5671
    je.d32 L_004b57b1                            # 004b5676
    # block 0x004b567c: entered by fall-through of je at 0x004b5676, 49 instruction(s), ends with jne to 0x004b579d (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b567c
    movsx edx, word ptr [ecx + field_728]        # 004b567f
    imul edx, edx, 0x8d                          # 004b5686
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b568c
    movsx ecx, word ptr [eax + field_83b]        # 004b5692
    mov dword ptr [0x5bb57b], ecx                # 004b5699
    mov edx, dword ptr [ebp - local_18]          # 004b569f
    movsx eax, word ptr [edx + field_728]        # 004b56a2
    imul eax, eax, 0x8d                          # 004b56a9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b56af
    mov dx, word ptr [ecx + field_83d]           # 004b56b5
    mov word ptr [0x5bb599], dx                  # 004b56bc
    mov eax, dword ptr [ebp - local_18]          # 004b56c3
    movsx ecx, word ptr [eax + field_728]        # 004b56c6
    imul ecx, ecx, 0x8d                          # 004b56cd
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b56d3
    mov ax, word ptr [edx + field_83f]           # 004b56d9
    mov word ptr [0x5bb595], ax                  # 004b56e0
    mov ecx, dword ptr [ebp - local_18]          # 004b56e6
    movsx edx, word ptr [ecx + field_728]        # 004b56e9
    imul edx, edx, 0x8d                          # 004b56f0
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b56f6
    mov cx, word ptr [eax + field_841]           # 004b56fc
    mov word ptr [0x5c39ff], cx                  # 004b5703
    mov edx, dword ptr [ebp - local_18]          # 004b570a
    movsx eax, word ptr [edx + field_728]        # 004b570d
    imul eax, eax, 0x8d                          # 004b5714
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b571a
    mov edx, dword ptr [ecx + field_843]         # 004b5720
    mov dword ptr [0x5bb59b], edx                # 004b5726
    mov eax, dword ptr [ebp - local_18]          # 004b572c
    movsx ecx, word ptr [eax + field_728]        # 004b572f
    imul ecx, ecx, 0x8d                          # 004b5736
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b573c
    mov eax, dword ptr [edx + field_847]         # 004b5742
    mov dword ptr [0x5bb59f], eax                # 004b5748
    mov ecx, dword ptr [ebp - local_18]          # 004b574d
    movsx edx, word ptr [ecx + field_728]        # 004b5750
    imul edx, edx, 0x8d                          # 004b5757
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b575d
    mov ecx, dword ptr [eax + field_84b]         # 004b5763
    mov dword ptr [0x5bb5a3], ecx                # 004b5769
    mov edx, dword ptr [ebp - local_18]          # 004b576f
    movsx eax, word ptr [edx + field_728]        # 004b5772
    imul eax, eax, 0x8d                          # 004b5779
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b577f
    movsx edx, word ptr [ecx + field_84f]        # 004b5785
    cmp edx, 0x1                                 # 004b578c
    jne.d8 L_004b579d                            # 004b578f
    # block 0x004b5791: entered by fall-through of jne at 0x004b578f, 2 instruction(s), ends with forward jump to 0x004b57a7
    mov dword ptr [0x5bb1ca], 0x0                # 004b5791
    jmp.d8 L_004b57a7                            # 004b579b
L_004b579d:
    # block 0x004b579d: entered by jne at 0x004b578f, 1 instruction(s), falls into the block at 0x004b57a7
    mov dword ptr [0x5bb1ca], 0x1                # 004b579d
L_004b57a7:
    # block 0x004b57a7: entered by jmp at 0x004b579b, 1 instruction(s), falls into the block at 0x004b57b1
    mov dword ptr [0x583999], 0x4                # 004b57a7
L_004b57b1:
    # block 0x004b57b1: entered by je at 0x004b5676, 7 instruction(s), ends with je to 0x004b5815 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b57b1
    movsx ecx, word ptr [eax + field_728]        # 004b57b4
    imul ecx, ecx, 0x8d                          # 004b57bb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b57c1
    movsx eax, word ptr [edx + field_882]        # 004b57c7
    cmp eax, -0x1                                # 004b57ce
    je.d8 L_004b5815                             # 004b57d1
    # block 0x004b57d3: entered by fall-through of je at 0x004b57d1, 12 instruction(s), falls into the block at 0x004b5815
    mov ecx, dword ptr [ebp - local_18]          # 004b57d3
    movsx edx, word ptr [ecx + field_728]        # 004b57d6
    imul edx, edx, 0x8d                          # 004b57dd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b57e3
    {load} xor ecx, ecx                          # 004b57e9
    mov cl, byte ptr [eax + field_884]           # 004b57eb
    mov edx, dword ptr [ebp - local_18]          # 004b57f1
    movsx eax, word ptr [edx + field_728]        # 004b57f4
    imul eax, eax, 0x8d                          # 004b57fb
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004b5801
    movsx eax, word ptr [edx + field_882]        # 004b5807
    mov dword ptr [4*eax + 0x585801], ecx        # 004b580e
L_004b5815:
    # block 0x004b5815: entered by jmp at 0x004b5636; je at 0x004b5645; je at 0x004b57d1, 7 instruction(s), calls FUN_0042ba3a, FUN_004b3d4d, falls into the block at 0x004b5830
    mov ecx, dword ptr [ebp - local_18]          # 004b5815
    mov dx, word ptr [ecx + field_728]           # 004b5818
    push edx                                     # 004b581f
    call FUN_0042ba3a                            # 004b5820
    add esp, 0x4                                 # 004b5825
    mov ecx, dword ptr [ebp - local_18]          # 004b5828
    call FUN_004b3d4d                            # 004b582b
L_004b5830:
    # block 0x004b5830: entered by jmp at 0x004b4aa0; jmp at 0x004b5025; jmp at 0x004b5407, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b5830
    pop esi                                      # 004b5831
    {load} mov esp, ebp                          # 004b5832
    pop ebp                                      # 004b5834
    ret 0x4                                      # 004b5835

