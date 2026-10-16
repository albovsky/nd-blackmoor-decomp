# FUN_004c0d3f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0d3f
# extent:       0x004c0d3f-0x004c0f22 (483 code bytes)
# span:         0x004c0d3f-0x004c0f30 (code 483, tables 0, padding 14)
# sha256:       e10971c1f334b24602d98cc5235ddc5b7bc25eba3b5cc8d645184558382ccf69
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0d3f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_4, field_8, field_c, field_172; [ecx + n] field_4, field_8, field_c, field_176, field_1cc; [edx + n] field_4, field_8, field_c, field_176
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 143 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_172, 0x172  # offset +0x172
.equ field_176, 0x176  # offset +0x176
.equ field_1cc, 0x1cc  # offset +0x1cc

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004c0d3f - 0x401000
.globl FUN_004c0d3f
FUN_004c0d3f:
    # block 0x004c0d3f: entry, 9 instruction(s), ends with je to 0x004c0db7 (forward)
    push ebp                                     # 004c0d3f
    {load} mov ebp, esp                          # 004c0d40
    sub esp, 0x30                                # 004c0d42
    mov dword ptr [ebp - local_4], 0x637fd7      # 004c0d45
    mov dword ptr [ebp - local_8], 0x6381ad      # 004c0d4c
    mov dword ptr [ebp - local_20], 0x6381bd     # 004c0d53
    mov dword ptr [ebp - local_1c], 0x583122     # 004c0d5a
    cmp dword ptr [0x6381e5], 0x0                # 004c0d61
    je.d8 L_004c0db7                             # 004c0d68
    # block 0x004c0d6a: entered by fall-through of je at 0x004c0d68, 14 instruction(s), calls FUN_004c5377, ends with jne to 0x004c0db2 (forward)
    mov dword ptr [0x6381e5], 0x0                # 004c0d6a
    push 0x552b7c                                # 004c0d74
    mov eax, dword ptr [0x5d19f7]                # 004c0d79
    push eax                                     # 004c0d7e
    mov ecx, dword ptr [0x5d19f3]                # 004c0d7f
    push ecx                                     # 004c0d85
    mov edx, dword ptr [0x5cf665]                # 004c0d86
    push edx                                     # 004c0d8c
    mov eax, dword ptr [0x5d19ef]                # 004c0d8d
    push eax                                     # 004c0d92
    mov ecx, 0x5cf659                            # 004c0d93
    call FUN_004c5377                            # 004c0d98
    cmp dword ptr [0x6381ed], 0x0                # 004c0d9d
    jne.d8 L_004c0db2                            # 004c0da4
    # block 0x004c0da6: entered by fall-through of jne at 0x004c0da4, 2 instruction(s), falls into the block at 0x004c0db2
    mov ecx, dword ptr [ebp - local_4]           # 004c0da6
    mov word ptr [ecx + field_1cc], 0x0          # 004c0da9
L_004c0db2:
    # block 0x004c0db2: entered by jne at 0x004c0da4, 1 instruction(s), ends with forward jump to 0x004c0f1e
    jmp.d32 L_004c0f1e                           # 004c0db2
L_004c0db7:
    # block 0x004c0db7: entered by je at 0x004c0d68, 2 instruction(s), ends with je to 0x004c0f1e (forward)
    cmp dword ptr [0x6381e9], 0x0                # 004c0db7
    je.d32 L_004c0f1e                            # 004c0dbe
    # block 0x004c0dc4: entered by fall-through of je at 0x004c0dbe, 3 instruction(s), ends with jne to 0x004c0ddc (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0dc4
    cmp dword ptr [edx + field_176], 0x0         # 004c0dc7
    jne.d8 L_004c0ddc                            # 004c0dce
    # block 0x004c0dd0: entered by fall-through of jne at 0x004c0dce, 3 instruction(s), ends with je to 0x004c0dec (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0dd0
    cmp dword ptr [eax + field_172], 0x1         # 004c0dd3
    je.d8 L_004c0dec                             # 004c0dda
L_004c0ddc:
    # block 0x004c0ddc: entered by jne at 0x004c0dce; fall-through of je at 0x004c0dda, 3 instruction(s), ends with jne to 0x004c0f1e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c0ddc
    cmp dword ptr [ecx + field_176], 0x1         # 004c0ddf
    jne.d32 L_004c0f1e                           # 004c0de6
L_004c0dec:
    # block 0x004c0dec: entered by je at 0x004c0dda; fall-through of jne at 0x004c0de6, 5 instruction(s), ends with jg to 0x004c0f1e (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0dec
    mov eax, dword ptr [ebp - local_20]          # 004c0def
    mov ecx, dword ptr [edx]                     # 004c0df2
    cmp ecx, dword ptr [eax + field_8]           # 004c0df4
    jg.d32 L_004c0f1e                            # 004c0df7
    # block 0x004c0dfd: entered by fall-through of jg at 0x004c0df7, 5 instruction(s), ends with jl to 0x004c0f1e (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0dfd
    mov eax, dword ptr [ebp - local_20]          # 004c0e00
    mov ecx, dword ptr [edx + field_8]           # 004c0e03
    cmp ecx, dword ptr [eax]                     # 004c0e06
    jl.d32 L_004c0f1e                            # 004c0e08
    # block 0x004c0e0e: entered by fall-through of jl at 0x004c0e08, 5 instruction(s), ends with jg to 0x004c0f1e (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0e0e
    mov eax, dword ptr [ebp - local_20]          # 004c0e11
    mov ecx, dword ptr [edx + field_4]           # 004c0e14
    cmp ecx, dword ptr [eax + field_c]           # 004c0e17
    jg.d32 L_004c0f1e                            # 004c0e1a
    # block 0x004c0e20: entered by fall-through of jg at 0x004c0e1a, 5 instruction(s), ends with jl to 0x004c0f1e (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0e20
    mov eax, dword ptr [ebp - local_20]          # 004c0e23
    mov ecx, dword ptr [edx + field_c]           # 004c0e26
    cmp ecx, dword ptr [eax + field_4]           # 004c0e29
    jl.d32 L_004c0f1e                            # 004c0e2c
    # block 0x004c0e32: entered by fall-through of jl at 0x004c0e2c, 5 instruction(s), ends with jge to 0x004c0e48 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0e32
    mov eax, dword ptr [ebp - local_20]          # 004c0e35
    mov ecx, dword ptr [edx]                     # 004c0e38
    cmp ecx, dword ptr [eax]                     # 004c0e3a
    jge.d8 L_004c0e48                            # 004c0e3c
    # block 0x004c0e3e: entered by fall-through of jge at 0x004c0e3c, 4 instruction(s), ends with forward jump to 0x004c0e50
    mov edx, dword ptr [ebp - local_20]          # 004c0e3e
    mov eax, dword ptr [edx]                     # 004c0e41
    mov dword ptr [ebp - local_30], eax          # 004c0e43
    jmp.d8 L_004c0e50                            # 004c0e46
L_004c0e48:
    # block 0x004c0e48: entered by jge at 0x004c0e3c, 3 instruction(s), falls into the block at 0x004c0e50
    mov ecx, dword ptr [ebp - local_1c]          # 004c0e48
    mov edx, dword ptr [ecx]                     # 004c0e4b
    mov dword ptr [ebp - local_30], edx          # 004c0e4d
L_004c0e50:
    # block 0x004c0e50: entered by jmp at 0x004c0e46, 5 instruction(s), ends with jle to 0x004c0e69 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c0e50
    mov ecx, dword ptr [ebp - local_20]          # 004c0e53
    mov edx, dword ptr [eax + field_8]           # 004c0e56
    cmp edx, dword ptr [ecx + field_8]           # 004c0e59
    jle.d8 L_004c0e69                            # 004c0e5c
    # block 0x004c0e5e: entered by fall-through of jle at 0x004c0e5c, 4 instruction(s), ends with forward jump to 0x004c0e72
    mov eax, dword ptr [ebp - local_20]          # 004c0e5e
    mov ecx, dword ptr [eax + field_8]           # 004c0e61
    mov dword ptr [ebp - local_28], ecx          # 004c0e64
    jmp.d8 L_004c0e72                            # 004c0e67
L_004c0e69:
    # block 0x004c0e69: entered by jle at 0x004c0e5c, 3 instruction(s), falls into the block at 0x004c0e72
    mov edx, dword ptr [ebp - local_1c]          # 004c0e69
    mov eax, dword ptr [edx + field_8]           # 004c0e6c
    mov dword ptr [ebp - local_28], eax          # 004c0e6f
L_004c0e72:
    # block 0x004c0e72: entered by jmp at 0x004c0e67, 5 instruction(s), ends with jge to 0x004c0e8b (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c0e72
    mov edx, dword ptr [ebp - local_20]          # 004c0e75
    mov eax, dword ptr [ecx + field_4]           # 004c0e78
    cmp eax, dword ptr [edx + field_4]           # 004c0e7b
    jge.d8 L_004c0e8b                            # 004c0e7e
    # block 0x004c0e80: entered by fall-through of jge at 0x004c0e7e, 4 instruction(s), ends with forward jump to 0x004c0e94
    mov ecx, dword ptr [ebp - local_20]          # 004c0e80
    mov edx, dword ptr [ecx + field_4]           # 004c0e83
    mov dword ptr [ebp - local_2c], edx          # 004c0e86
    jmp.d8 L_004c0e94                            # 004c0e89
L_004c0e8b:
    # block 0x004c0e8b: entered by jge at 0x004c0e7e, 3 instruction(s), falls into the block at 0x004c0e94
    mov eax, dword ptr [ebp - local_1c]          # 004c0e8b
    mov ecx, dword ptr [eax + field_4]           # 004c0e8e
    mov dword ptr [ebp - local_2c], ecx          # 004c0e91
L_004c0e94:
    # block 0x004c0e94: entered by jmp at 0x004c0e89, 5 instruction(s), ends with jle to 0x004c0ead (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c0e94
    mov eax, dword ptr [ebp - local_20]          # 004c0e97
    mov ecx, dword ptr [edx + field_c]           # 004c0e9a
    cmp ecx, dword ptr [eax + field_c]           # 004c0e9d
    jle.d8 L_004c0ead                            # 004c0ea0
    # block 0x004c0ea2: entered by fall-through of jle at 0x004c0ea0, 4 instruction(s), ends with forward jump to 0x004c0eb6
    mov edx, dword ptr [ebp - local_20]          # 004c0ea2
    mov eax, dword ptr [edx + field_c]           # 004c0ea5
    mov dword ptr [ebp - local_24], eax          # 004c0ea8
    jmp.d8 L_004c0eb6                            # 004c0eab
L_004c0ead:
    # block 0x004c0ead: entered by jle at 0x004c0ea0, 3 instruction(s), falls into the block at 0x004c0eb6
    mov ecx, dword ptr [ebp - local_1c]          # 004c0ead
    mov edx, dword ptr [ecx + field_c]           # 004c0eb0
    mov dword ptr [ebp - local_24], edx          # 004c0eb3
L_004c0eb6:
    # block 0x004c0eb6: entered by jmp at 0x004c0eab, 35 instruction(s), calls FUN_004c5377, falls into the block at 0x004c0f1e
    mov eax, dword ptr [ebp - local_20]          # 004c0eb6
    mov ecx, dword ptr [ebp - local_30]          # 004c0eb9
    sub ecx, dword ptr [eax]                     # 004c0ebc
    mov edx, dword ptr [ebp - local_8]           # 004c0ebe
    add ecx, dword ptr [edx]                     # 004c0ec1
    mov dword ptr [ebp - local_18], ecx          # 004c0ec3
    mov eax, dword ptr [ebp - local_20]          # 004c0ec6
    mov ecx, dword ptr [ebp - local_28]          # 004c0ec9
    sub ecx, dword ptr [eax]                     # 004c0ecc
    mov edx, dword ptr [ebp - local_8]           # 004c0ece
    add ecx, dword ptr [edx]                     # 004c0ed1
    mov dword ptr [ebp - local_10], ecx          # 004c0ed3
    mov eax, dword ptr [ebp - local_20]          # 004c0ed6
    mov ecx, dword ptr [ebp - local_2c]          # 004c0ed9
    sub ecx, dword ptr [eax + field_4]           # 004c0edc
    mov edx, dword ptr [ebp - local_8]           # 004c0edf
    add ecx, dword ptr [edx + field_4]           # 004c0ee2
    mov dword ptr [ebp - local_14], ecx          # 004c0ee5
    mov eax, dword ptr [ebp - local_20]          # 004c0ee8
    mov ecx, dword ptr [ebp - local_24]          # 004c0eeb
    sub ecx, dword ptr [eax + field_4]           # 004c0eee
    mov edx, dword ptr [ebp - local_8]           # 004c0ef1
    add ecx, dword ptr [edx + field_4]           # 004c0ef4
    mov dword ptr [ebp - local_c], ecx           # 004c0ef7
    push 0x552b90                                # 004c0efa
    lea eax, [ebp - local_30]                    # 004c0eff
    push eax                                     # 004c0f02
    lea ecx, [ebp - local_18]                    # 004c0f03
    push ecx                                     # 004c0f06
    mov edx, dword ptr [0x5cf665]                # 004c0f07
    push edx                                     # 004c0f0d
    mov eax, dword ptr [0x5d19ef]                # 004c0f0e
    push eax                                     # 004c0f13
    mov ecx, 0x5cf659                            # 004c0f14
    call FUN_004c5377                            # 004c0f19
L_004c0f1e:
    # block 0x004c0f1e: entered by jmp at 0x004c0db2; je at 0x004c0dbe; jne at 0x004c0de6; jg at 0x004c0df7; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c0f1e
    pop ebp                                      # 004c0f20
    ret                                          # 004c0f21

# --- data items (not part of the function) -------------------------
.org 0x004c0f22 - 0x401000
PAD_004c0f22:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

