# FUN_004c5d4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c5d4b
# extent:       0x004c5d4b-0x004c609b (848 code bytes)
# span:         0x004c5d4b-0x004c609b (code 848, tables 0, padding 0)
# sha256:       cfb7385d2efeb3e0fe986eb4812d22f3447e4b1134ff5086a655a0ccc10d5379
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c5d4b_lifted
# naming:       native port src/original_methods_fl41.c:m4c5d4b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 22 seeds; oracle: 260/260 instructions, 20/20 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_68, local_7c, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 6 more
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c, field_38d0; [edx + n] field_4, field_8, field_c, field_2f
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4c5d4b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 260 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_68, 0x68  # offset -0x68
.equ local_7c, 0x7c  # offset -0x7c
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f
.equ field_38d0, 0x38d0  # offset +0x38d0

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c5d4b - 0x401000
.globl FUN_004c5d4b
FUN_004c5d4b:
    # block 0x004c5d4b: entry, 7 instruction(s), ends with je to 0x004c5f29 (forward)
    push ebp                                     # 004c5d4b
    {load} mov ebp, esp                          # 004c5d4c
    sub esp, 0x1b0                               # 004c5d4e
    mov dword ptr [ebp - local_1b0], ecx         # 004c5d54
    movsx eax, word ptr [0x63a4cd]               # 004c5d5a
    test eax, eax                                # 004c5d61
    je.d32 L_004c5f29                            # 004c5d63
    # block 0x004c5d69: entered by fall-through of je at 0x004c5d63, 23 instruction(s), ends with jne to 0x004c5dcb (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c5d69
    mov edx, dword ptr [ebp + arg_10]            # 004c5d6c
    mov eax, dword ptr [ecx + field_8]           # 004c5d6f
    sub eax, dword ptr [edx]                     # 004c5d72
    mov dword ptr [ebp - local_1ac], eax         # 004c5d74
    mov ecx, dword ptr [ebp + arg_10]            # 004c5d7a
    mov edx, dword ptr [ebp + arg_10]            # 004c5d7d
    mov eax, dword ptr [ecx + field_c]           # 004c5d80
    sub eax, dword ptr [edx + field_4]           # 004c5d83
    mov dword ptr [ebp - local_1a8], eax         # 004c5d86
    mov ecx, dword ptr [ebp + arg_14]            # 004c5d8c
    mov edx, dword ptr [ebp + arg_14]            # 004c5d8f
    mov eax, dword ptr [ecx + field_8]           # 004c5d92
    sub eax, dword ptr [edx]                     # 004c5d95
    mov dword ptr [ebp - local_a4], eax          # 004c5d97
    mov ecx, dword ptr [ebp + arg_14]            # 004c5d9d
    mov edx, dword ptr [ebp + arg_14]            # 004c5da0
    mov eax, dword ptr [ecx + field_c]           # 004c5da3
    sub eax, dword ptr [edx + field_4]           # 004c5da6
    mov dword ptr [ebp - local_1a4], eax         # 004c5da9
    mov ecx, dword ptr [ebp - local_1ac]         # 004c5daf
    cmp ecx, dword ptr [ebp - local_a4]          # 004c5db5
    jne.d8 L_004c5dcb                            # 004c5dbb
    # block 0x004c5dbd: entered by fall-through of jne at 0x004c5dbb, 3 instruction(s), ends with je to 0x004c5e39 (forward)
    mov edx, dword ptr [ebp - local_1a8]         # 004c5dbd
    cmp edx, dword ptr [ebp - local_1a4]         # 004c5dc3
    je.d8 L_004c5e39                             # 004c5dc9
L_004c5dcb:
    # block 0x004c5dcb: entered by jne at 0x004c5dbb; fall-through of je at 0x004c5dc9, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6095
    mov eax, dword ptr [ebp + arg_14]            # 004c5dcb
    mov ecx, dword ptr [eax + field_c]           # 004c5dce
    push ecx                                     # 004c5dd1
    mov edx, dword ptr [ebp + arg_14]            # 004c5dd2
    mov eax, dword ptr [edx + field_8]           # 004c5dd5
    push eax                                     # 004c5dd8
    mov ecx, dword ptr [ebp + arg_14]            # 004c5dd9
    mov edx, dword ptr [ecx + field_4]           # 004c5ddc
    push edx                                     # 004c5ddf
    mov eax, dword ptr [ebp + arg_14]            # 004c5de0
    mov ecx, dword ptr [eax]                     # 004c5de3
    push ecx                                     # 004c5de5
    mov edx, dword ptr [ebp + arg_10]            # 004c5de6
    mov eax, dword ptr [edx + field_c]           # 004c5de9
    push eax                                     # 004c5dec
    mov ecx, dword ptr [ebp + arg_10]            # 004c5ded
    mov edx, dword ptr [ecx + field_8]           # 004c5df0
    push edx                                     # 004c5df3
    mov eax, dword ptr [ebp + arg_10]            # 004c5df4
    mov ecx, dword ptr [eax + field_4]           # 004c5df7
    push ecx                                     # 004c5dfa
    mov edx, dword ptr [ebp + arg_10]            # 004c5dfb
    mov eax, dword ptr [edx]                     # 004c5dfe
    push eax                                     # 004c5e00
    mov ecx, dword ptr [ebp + arg_18]            # 004c5e01
    push ecx                                     # 004c5e04
    push 0x554c90                                # 004c5e05
    lea edx, [ebp - local_1a0]                   # 004c5e0a
    push edx                                     # 004c5e10
    call FUN_0050ca3e                            # 004c5e11
    add esp, 0x2c                                # 004c5e16
    push 0x0                                     # 004c5e19
    push 0x0                                     # 004c5e1b
    lea eax, [ebp - local_1a0]                   # 004c5e1d
    push eax                                     # 004c5e23
    call FUN_0052139c                            # 004c5e24
    mov ecx, dword ptr [ebp - local_1b0]         # 004c5e29
    call FUN_004c97b4                            # 004c5e2f
    jmp.d32 L_004c6095                           # 004c5e34
L_004c5e39:
    # block 0x004c5e39: entered by je at 0x004c5dc9, 2 instruction(s), ends with je to 0x004c5e45 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c5e39
    je.d8 L_004c5e45                             # 004c5e3d
    # block 0x004c5e3f: entered by fall-through of je at 0x004c5e3d, 2 instruction(s), ends with jne to 0x004c5eb3 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c5e3f
    jne.d8 L_004c5eb3                            # 004c5e43
L_004c5e45:
    # block 0x004c5e45: entered by je at 0x004c5e3d; fall-through of jne at 0x004c5e43, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6095
    mov ecx, dword ptr [ebp + arg_14]            # 004c5e45
    mov edx, dword ptr [ecx + field_c]           # 004c5e48
    push edx                                     # 004c5e4b
    mov eax, dword ptr [ebp + arg_14]            # 004c5e4c
    mov ecx, dword ptr [eax + field_8]           # 004c5e4f
    push ecx                                     # 004c5e52
    mov edx, dword ptr [ebp + arg_14]            # 004c5e53
    mov eax, dword ptr [edx + field_4]           # 004c5e56
    push eax                                     # 004c5e59
    mov ecx, dword ptr [ebp + arg_14]            # 004c5e5a
    mov edx, dword ptr [ecx]                     # 004c5e5d
    push edx                                     # 004c5e5f
    mov eax, dword ptr [ebp + arg_10]            # 004c5e60
    mov ecx, dword ptr [eax + field_c]           # 004c5e63
    push ecx                                     # 004c5e66
    mov edx, dword ptr [ebp + arg_10]            # 004c5e67
    mov eax, dword ptr [edx + field_8]           # 004c5e6a
    push eax                                     # 004c5e6d
    mov ecx, dword ptr [ebp + arg_10]            # 004c5e6e
    mov edx, dword ptr [ecx + field_4]           # 004c5e71
    push edx                                     # 004c5e74
    mov eax, dword ptr [ebp + arg_10]            # 004c5e75
    mov ecx, dword ptr [eax]                     # 004c5e78
    push ecx                                     # 004c5e7a
    mov edx, dword ptr [ebp + arg_18]            # 004c5e7b
    push edx                                     # 004c5e7e
    push 0x554d24                                # 004c5e7f
    lea eax, [ebp - local_1a0]                   # 004c5e84
    push eax                                     # 004c5e8a
    call FUN_0050ca3e                            # 004c5e8b
    add esp, 0x2c                                # 004c5e90
    push 0x0                                     # 004c5e93
    push 0x0                                     # 004c5e95
    lea ecx, [ebp - local_1a0]                   # 004c5e97
    push ecx                                     # 004c5e9d
    call FUN_0052139c                            # 004c5e9e
    mov ecx, dword ptr [ebp - local_1b0]         # 004c5ea3
    call FUN_004c97b4                            # 004c5ea9
    jmp.d32 L_004c6095                           # 004c5eae
L_004c5eb3:
    # block 0x004c5eb3: entered by jne at 0x004c5e43, 3 instruction(s), ends with jne to 0x004c5f29 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004c5eb3
    cmp dword ptr [edx], 0x0                     # 004c5eb6
    jne.d8 L_004c5f29                            # 004c5eb9
    # block 0x004c5ebb: entered by fall-through of jne at 0x004c5eb9, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6095
    mov eax, dword ptr [ebp + arg_14]            # 004c5ebb
    mov ecx, dword ptr [eax + field_c]           # 004c5ebe
    push ecx                                     # 004c5ec1
    mov edx, dword ptr [ebp + arg_14]            # 004c5ec2
    mov eax, dword ptr [edx + field_8]           # 004c5ec5
    push eax                                     # 004c5ec8
    mov ecx, dword ptr [ebp + arg_14]            # 004c5ec9
    mov edx, dword ptr [ecx + field_4]           # 004c5ecc
    push edx                                     # 004c5ecf
    mov eax, dword ptr [ebp + arg_14]            # 004c5ed0
    mov ecx, dword ptr [eax]                     # 004c5ed3
    push ecx                                     # 004c5ed5
    mov edx, dword ptr [ebp + arg_10]            # 004c5ed6
    mov eax, dword ptr [edx + field_c]           # 004c5ed9
    push eax                                     # 004c5edc
    mov ecx, dword ptr [ebp + arg_10]            # 004c5edd
    mov edx, dword ptr [ecx + field_8]           # 004c5ee0
    push edx                                     # 004c5ee3
    mov eax, dword ptr [ebp + arg_10]            # 004c5ee4
    mov ecx, dword ptr [eax + field_4]           # 004c5ee7
    push ecx                                     # 004c5eea
    mov edx, dword ptr [ebp + arg_10]            # 004c5eeb
    mov eax, dword ptr [edx]                     # 004c5eee
    push eax                                     # 004c5ef0
    mov ecx, dword ptr [ebp + arg_18]            # 004c5ef1
    push ecx                                     # 004c5ef4
    push 0x554da0                                # 004c5ef5
    lea edx, [ebp - local_1a0]                   # 004c5efa
    push edx                                     # 004c5f00
    call FUN_0050ca3e                            # 004c5f01
    add esp, 0x2c                                # 004c5f06
    push 0x0                                     # 004c5f09
    push 0x0                                     # 004c5f0b
    lea eax, [ebp - local_1a0]                   # 004c5f0d
    push eax                                     # 004c5f13
    call FUN_0052139c                            # 004c5f14
    mov ecx, dword ptr [ebp - local_1b0]         # 004c5f19
    call FUN_004c97b4                            # 004c5f1f
    jmp.d32 L_004c6095                           # 004c5f24
L_004c5f29:
    # block 0x004c5f29: entered by je at 0x004c5d63; jne at 0x004c5eb9, 48 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c5fdb
    push 0x20                                    # 004c5f29
    mov ecx, dword ptr [ebp + arg_18]            # 004c5f2b
    push ecx                                     # 004c5f2e
    lea edx, [ebp - local_8c]                    # 004c5f2f
    push edx                                     # 004c5f35
    mov eax, dword ptr [ebp + arg_14]            # 004c5f36
    push eax                                     # 004c5f39
    mov ecx, dword ptr [ebp + arg_c]             # 004c5f3a
    push ecx                                     # 004c5f3d
    mov ecx, dword ptr [ebp - local_1b0]         # 004c5f3e
    call FUN_004c4067                            # 004c5f44
    mov edx, dword ptr [ebp + arg_8]             # 004c5f49
    movsx eax, word ptr [edx + field_2f]         # 004c5f4c
    mov dword ptr [ebp - local_94], eax          # 004c5f50
    mov ecx, dword ptr [ebp - local_7c]          # 004c5f56
    mov dword ptr [ebp - local_9c], ecx          # 004c5f59
    mov edx, dword ptr [ebp + arg_8]             # 004c5f5f
    movsx eax, word ptr [edx + field_2f]         # 004c5f62
    mov ecx, dword ptr [ebp + arg_10]            # 004c5f66
    mov edx, dword ptr [ecx + field_4]           # 004c5f69
    imul edx, eax                                # 004c5f6c
    mov eax, dword ptr [ebp + arg_8]             # 004c5f6f
    mov ecx, dword ptr [eax]                     # 004c5f72
    {load} add ecx, edx                          # 004c5f74
    movsx edx, word ptr [0x639895]               # 004c5f76
    mov eax, dword ptr [ebp + arg_10]            # 004c5f7d
    mov eax, dword ptr [eax]                     # 004c5f80
    imul eax, edx                                # 004c5f82
    {load} add ecx, eax                          # 004c5f85
    mov dword ptr [ebp - local_4], ecx           # 004c5f87
    mov ecx, dword ptr [ebp + arg_10]            # 004c5f8a
    mov edx, dword ptr [ebp + arg_10]            # 004c5f8d
    mov eax, dword ptr [ecx + field_c]           # 004c5f90
    sub eax, dword ptr [edx + field_4]           # 004c5f93
    add eax, 0x1                                 # 004c5f96
    mov dword ptr [ebp - local_90], eax          # 004c5f99
    mov ecx, dword ptr [ebp + arg_10]            # 004c5f9f
    mov edx, dword ptr [ebp + arg_10]            # 004c5fa2
    mov eax, dword ptr [ecx + field_8]           # 004c5fa5
    sub eax, dword ptr [edx]                     # 004c5fa8
    add eax, 0x1                                 # 004c5faa
    movsx ecx, word ptr [0x639895]               # 004c5fad
    imul eax, ecx                                # 004c5fb4
    mov dword ptr [ebp - local_c], eax           # 004c5fb7
    mov edx, dword ptr [ebp - local_68]          # 004c5fba
    mov dword ptr [ebp - local_8], edx           # 004c5fbd
    mov dword ptr [ebp - local_98], 0x0          # 004c5fc0
    jmp.d8 L_004c5fdb                            # 004c5fca
L_004c5fcc:
    # block 0x004c5fcc: entered by jmp at 0x004c605b, 3 instruction(s), falls into the block at 0x004c5fdb
    mov eax, dword ptr [ebp - local_98]          # 004c5fcc
    add eax, 0x1                                 # 004c5fd2
    mov dword ptr [ebp - local_98], eax          # 004c5fd5
L_004c5fdb:
    # block 0x004c5fdb: entered by jmp at 0x004c5fca, 3 instruction(s), ends with jge to 0x004c6060 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 004c5fdb
    cmp ecx, dword ptr [ebp - local_90]          # 004c5fe1
    jge.d8 L_004c6060                            # 004c5fe7
    # block 0x004c5fe9: entered by fall-through of jge at 0x004c5fe7, 2 instruction(s), ends with forward jump to 0x004c5ffb
    mov dword ptr [ebp - local_10], 0x0          # 004c5fe9
    jmp.d8 L_004c5ffb                            # 004c5ff0
L_004c5ff2:
    # block 0x004c5ff2: entered by jmp at 0x004c6041, 3 instruction(s), falls into the block at 0x004c5ffb
    mov edx, dword ptr [ebp - local_10]          # 004c5ff2
    add edx, 0x2                                 # 004c5ff5
    mov dword ptr [ebp - local_10], edx          # 004c5ff8
L_004c5ffb:
    # block 0x004c5ffb: entered by jmp at 0x004c5ff0, 3 instruction(s), ends with jge to 0x004c6043 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004c5ffb
    cmp eax, dword ptr [ebp - local_c]           # 004c5ffe
    jge.d8 L_004c6043                            # 004c6001
    # block 0x004c6003: entered by fall-through of jge at 0x004c6001, 11 instruction(s), ends with je to 0x004c6041 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c6003
    add ecx, dword ptr [ebp - local_10]          # 004c6006
    mov dx, word ptr [ecx]                       # 004c6009
    mov word ptr [ebp - local_a0], dx            # 004c600c
    mov eax, dword ptr [ebp - local_a0]          # 004c6013
    and eax, 0xffff                              # 004c6019
    mov ecx, dword ptr [ebp - local_1b0]         # 004c601e
    {load} xor edx, edx                          # 004c6024
    mov dx, word ptr [ecx + field_38d0]          # 004c6026
    {load} cmp eax, edx                          # 004c602d
    je.d8 L_004c6041                             # 004c602f
    # block 0x004c6031: entered by fall-through of je at 0x004c602f, 4 instruction(s), falls into the block at 0x004c6041
    mov eax, dword ptr [ebp - local_8]           # 004c6031
    add eax, dword ptr [ebp - local_10]          # 004c6034
    mov cx, word ptr [ebp - local_a0]            # 004c6037
    mov word ptr [eax], cx                       # 004c603e
L_004c6041:
    # block 0x004c6041: entered by je at 0x004c602f, 1 instruction(s), ends with backward jump to 0x004c5ff2
    jmp.d8 L_004c5ff2                            # 004c6041
L_004c6043:
    # block 0x004c6043: entered by jge at 0x004c6001, 7 instruction(s), ends with backward jump to 0x004c5fcc
    mov edx, dword ptr [ebp - local_4]           # 004c6043
    add edx, dword ptr [ebp - local_94]          # 004c6046
    mov dword ptr [ebp - local_4], edx           # 004c604c
    mov eax, dword ptr [ebp - local_8]           # 004c604f
    add eax, dword ptr [ebp - local_9c]          # 004c6052
    mov dword ptr [ebp - local_8], eax           # 004c6058
    jmp.d32 L_004c5fcc                           # 004c605b
L_004c6060:
    # block 0x004c6060: entered by jge at 0x004c5fe7, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c6095 (forward)
    push 0x554e24                                # 004c6060
    mov ecx, dword ptr [ebp + arg_14]            # 004c6065
    push ecx                                     # 004c6068
    mov edx, dword ptr [ebp + arg_c]             # 004c6069
    push edx                                     # 004c606c
    mov ecx, dword ptr [ebp - local_1b0]         # 004c606d
    call FUN_004c4202                            # 004c6073
    mov eax, dword ptr [ebp - local_1b0]         # 004c6078
    mov ecx, dword ptr [ebp + arg_c]             # 004c607e
    cmp ecx, dword ptr [eax + field_c]           # 004c6081
    jne.d8 L_004c6095                            # 004c6084
    # block 0x004c6086: entered by fall-through of jne at 0x004c6084, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c6095
    mov edx, dword ptr [ebp + arg_14]            # 004c6086
    push edx                                     # 004c6089
    mov ecx, dword ptr [ebp - local_1b0]         # 004c608a
    call FUN_004c952f                            # 004c6090
L_004c6095:
    # block 0x004c6095: entered by jmp at 0x004c5e34; jmp at 0x004c5eae; jmp at 0x004c5f24; jne at 0x004c6084, 3 instruction(s), ends with ret 0x14
    {load} mov esp, ebp                          # 004c6095
    pop ebp                                      # 004c6097
    ret 0x14                                     # 004c6098

