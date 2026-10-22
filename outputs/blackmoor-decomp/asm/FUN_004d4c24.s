# FUN_004d4c24
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4c24
# extent:       0x004d4c24-0x004d51b8 (1428 code bytes)
# span:         0x004d4c24-0x004d51c0 (code 1428, tables 0, padding 8)
# sha256:       998f4b6b8816a3909962475456af3b0a4e3ed4df93e50cac444325898ee06b53
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d4c24
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_4; [edx + n] field_minus_1
# callees:      calls FUN_004daeb5, FUN_004dae88, FUN_004dad60, FUN_004daef1, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_0043dbd5, FUN_004db870, FUN_0052139c, FUN_004c97b4, FUN_004c2dfb, FUN_004cf7e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 287 instruction(s), 26 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cf7e0, .text + (0x004cf7e0 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004daef1, .text + (0x004daef1 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004d4c24 - 0x401000
.globl FUN_004d4c24
FUN_004d4c24:
    # block 0x004d4c24: entry, 7 instruction(s), ends with je to 0x004d4c51 (forward)
    push ebp                                     # 004d4c24
    {load} mov ebp, esp                          # 004d4c25
    sub esp, 0x30                                # 004d4c27
    mov eax, dword ptr [0x5b0006]                # 004d4c2a
    mov dword ptr [ebp - local_24], eax          # 004d4c2f
    cmp dword ptr [ebp - local_24], 0x0          # 004d4c32
    je.d8 L_004d4c51                             # 004d4c36
    # block 0x004d4c38: entered by fall-through of je at 0x004d4c36, 2 instruction(s), ends with je to 0x004d50c0 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 004d4c38
    je.d32 L_004d50c0                            # 004d4c3c
    # block 0x004d4c42: entered by fall-through of je at 0x004d4c3c, 2 instruction(s), ends with je to 0x004d50ed (forward)
    cmp dword ptr [ebp - local_24], 0x3          # 004d4c42
    je.d32 L_004d50ed                            # 004d4c46
    # block 0x004d4c4c: entered by fall-through of je at 0x004d4c46, 1 instruction(s), ends with forward jump to 0x004d51a7
    jmp.d32 L_004d51a7                           # 004d4c4c
L_004d4c51:
    # block 0x004d4c51: entered by je at 0x004d4c36, 19 instruction(s), calls FUN_004daeb5, ends with jne to 0x004d4cb6 (forward)
    lea ecx, [ebp - local_18]                    # 004d4c51
    push ecx                                     # 004d4c54
    mov ecx, 0x5830a6                            # 004d4c55
    call FUN_004daeb5                            # 004d4c5a
    mov edx, dword ptr [eax]                     # 004d4c5f
    mov eax, dword ptr [eax + field_4]           # 004d4c61
    mov dword ptr [0x5830e2], edx                # 004d4c64
    mov dword ptr [0x5830e6], eax                # 004d4c6a
    mov ecx, dword ptr [0x5830e2]                # 004d4c6f
    mov dword ptr [0x5c3a53], ecx                # 004d4c75
    mov edx, dword ptr [0x5830e6]                # 004d4c7b
    mov dword ptr [0x5c3a57], edx                # 004d4c81
    mov eax, dword ptr [0x5830ea]                # 004d4c87
    mov dword ptr [ebp - local_20], eax          # 004d4c8c
    mov ecx, dword ptr [0x5830ee]                # 004d4c8f
    mov dword ptr [ebp - local_1c], ecx          # 004d4c95
    mov edx, dword ptr [0x5830e2]                # 004d4c98
    cmp edx, dword ptr [ebp - local_20]          # 004d4c9e
    jne.d8 L_004d4cb6                            # 004d4ca1
    # block 0x004d4ca3: entered by fall-through of jne at 0x004d4ca1, 3 instruction(s), ends with jne to 0x004d4cb6 (forward)
    mov eax, dword ptr [0x5830e6]                # 004d4ca3
    cmp eax, dword ptr [ebp - local_1c]          # 004d4ca8
    jne.d8 L_004d4cb6                            # 004d4cab
    # block 0x004d4cad: entered by fall-through of jne at 0x004d4cab, 2 instruction(s), ends with forward jump to 0x004d4cbd
    mov dword ptr [ebp - local_28], 0x0          # 004d4cad
    jmp.d8 L_004d4cbd                            # 004d4cb4
L_004d4cb6:
    # block 0x004d4cb6: entered by jne at 0x004d4ca1; jne at 0x004d4cab, 1 instruction(s), falls into the block at 0x004d4cbd
    mov dword ptr [ebp - local_28], 0x1          # 004d4cb6
L_004d4cbd:
    # block 0x004d4cbd: entered by jmp at 0x004d4cb4, 2 instruction(s), ends with je to 0x004d4e4b (forward)
    cmp dword ptr [ebp - local_28], 0x0          # 004d4cbd
    je.d32 L_004d4e4b                            # 004d4cc1
    # block 0x004d4cc7: entered by fall-through of je at 0x004d4cc1, 2 instruction(s), ends with jne to 0x004d4e4b (forward)
    cmp dword ptr [0x5830da], 0x0                # 004d4cc7
    jne.d32 L_004d4e4b                           # 004d4cce
    # block 0x004d4cd4: entered by fall-through of jne at 0x004d4cce, 16 instruction(s), ends with jle to 0x004d4d4e (forward)
    mov ecx, dword ptr [0x583106]                # 004d4cd4
    mov dword ptr [0x5830f6], ecx                # 004d4cda
    mov edx, dword ptr [0x58310e]                # 004d4ce0
    mov dword ptr [0x5830fe], edx                # 004d4ce6
    mov eax, dword ptr [0x583102]                # 004d4cec
    mov dword ptr [0x5830f2], eax                # 004d4cf1
    mov ecx, dword ptr [0x58310a]                # 004d4cf6
    mov dword ptr [0x5830fa], ecx                # 004d4cfc
    movsx edx, word ptr [0x63988b]               # 004d4d02
    mov eax, dword ptr [0x5b44f4]                # 004d4d09
    shl eax, 0x2                                 # 004d4d0e
    mov ecx, dword ptr [0x5b44f0]                # 004d4d11
    movsx eax, word ptr [eax + 8*ecx + 0x5b3790] # 004d4d17
    {load} sub edx, eax                          # 004d4d1f
    cmp dword ptr [0x5830e2], edx                # 004d4d21
    jle.d8 L_004d4d4e                            # 004d4d27
    # block 0x004d4d29: entered by fall-through of jle at 0x004d4d27, 7 instruction(s), falls into the block at 0x004d4d4e
    movsx ecx, word ptr [0x63988b]               # 004d4d29
    mov edx, dword ptr [0x5b44f4]                # 004d4d30
    shl edx, 0x2                                 # 004d4d36
    mov eax, dword ptr [0x5b44f0]                # 004d4d39
    movsx edx, word ptr [edx + 8*eax + 0x5b3790] # 004d4d3e
    {load} sub ecx, edx                          # 004d4d46
    mov dword ptr [0x5830e2], ecx                # 004d4d48
L_004d4d4e:
    # block 0x004d4d4e: entered by jle at 0x004d4d27, 8 instruction(s), ends with jle to 0x004d4d9b (forward)
    movsx eax, word ptr [0x63988d]               # 004d4d4e
    mov ecx, dword ptr [0x5b44f4]                # 004d4d55
    shl ecx, 0x2                                 # 004d4d5b
    mov edx, dword ptr [0x5b44f0]                # 004d4d5e
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004d4d64
    {load} sub eax, ecx                          # 004d4d6c
    cmp dword ptr [0x5830e6], eax                # 004d4d6e
    jle.d8 L_004d4d9b                            # 004d4d74
    # block 0x004d4d76: entered by fall-through of jle at 0x004d4d74, 7 instruction(s), falls into the block at 0x004d4d9b
    movsx edx, word ptr [0x63988d]               # 004d4d76
    mov eax, dword ptr [0x5b44f4]                # 004d4d7d
    shl eax, 0x2                                 # 004d4d82
    mov ecx, dword ptr [0x5b44f0]                # 004d4d85
    movsx eax, word ptr [eax + 8*ecx + 0x5b3792] # 004d4d8b
    {load} sub edx, eax                          # 004d4d93
    mov dword ptr [0x5830e6], edx                # 004d4d95
L_004d4d9b:
    # block 0x004d4d9b: entered by jle at 0x004d4d74, 32 instruction(s), calls FUN_004dae88, ends with forward jump to 0x004d4e68
    mov ecx, dword ptr [0x5830e6]                # 004d4d9b
    mov dword ptr [0x583106], ecx                # 004d4da1
    mov edx, dword ptr [0x5b44f4]                # 004d4da7
    shl edx, 0x2                                 # 004d4dad
    mov eax, dword ptr [0x5b44f0]                # 004d4db0
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004d4db5
    mov edx, dword ptr [0x583106]                # 004d4dbd
    lea eax, [edx + ecx - field_minus_1]         # 004d4dc3
    mov dword ptr [0x58310e], eax                # 004d4dc7
    mov ecx, dword ptr [0x5830e2]                # 004d4dcc
    mov dword ptr [0x583102], ecx                # 004d4dd2
    mov edx, dword ptr [0x5b44f4]                # 004d4dd8
    shl edx, 0x2                                 # 004d4dde
    mov eax, dword ptr [0x5b44f0]                # 004d4de1
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004d4de6
    mov edx, dword ptr [0x583102]                # 004d4dee
    lea eax, [edx + ecx - field_minus_1]         # 004d4df4
    mov dword ptr [0x58310a], eax                # 004d4df8
    mov ecx, dword ptr [0x5830e6]                # 004d4dfd
    push ecx                                     # 004d4e03
    mov edx, dword ptr [0x5830e2]                # 004d4e04
    push edx                                     # 004d4e0a
    mov ecx, 0x5830a6                            # 004d4e0b
    call FUN_004dae88                            # 004d4e10
    mov dword ptr [0x63a994], 0x0                # 004d4e15
    mov dword ptr [0x5830da], 0x1                # 004d4e1f
    mov dword ptr [0x5d2c7b], 0x1                # 004d4e29
    mov eax, dword ptr [0x5830e2]                # 004d4e33
    mov dword ptr [0x5830ea], eax                # 004d4e38
    mov ecx, dword ptr [0x5830e6]                # 004d4e3d
    mov dword ptr [0x5830ee], ecx                # 004d4e43
    jmp.d8 L_004d4e68                            # 004d4e49
L_004d4e4b:
    # block 0x004d4e4b: entered by je at 0x004d4cc1; jne at 0x004d4cce, 2 instruction(s), ends with je to 0x004d4e68 (forward)
    cmp dword ptr [0x5830da], 0x0                # 004d4e4b
    je.d8 L_004d4e68                             # 004d4e52
    # block 0x004d4e54: entered by fall-through of je at 0x004d4e52, 2 instruction(s), falls into the block at 0x004d4e68
    mov dword ptr [0x5830da], 0x0                # 004d4e54
    mov dword ptr [0x5d2c7b], 0x0                # 004d4e5e
L_004d4e68:
    # block 0x004d4e68: entered by jmp at 0x004d4e49; je at 0x004d4e52, 3 instruction(s), ends with je to 0x004d4e89 (forward)
    movsx edx, word ptr [0x5b0010]               # 004d4e68
    cmp edx, -0x1                                # 004d4e6f
    je.d8 L_004d4e89                             # 004d4e72
    # block 0x004d4e74: entered by fall-through of je at 0x004d4e72, 3 instruction(s), ends with forward jump to 0x004d4e93
    mov dword ptr [0x5d2d0f], 0x1                # 004d4e74
    mov word ptr [0x5b0010], 0xffff              # 004d4e7e
    jmp.d8 L_004d4e93                            # 004d4e87
L_004d4e89:
    # block 0x004d4e89: entered by je at 0x004d4e72, 1 instruction(s), falls into the block at 0x004d4e93
    mov dword ptr [0x5d2d0f], 0x0                # 004d4e89
L_004d4e93:
    # block 0x004d4e93: entered by jmp at 0x004d4e87, 15 instruction(s), ends with forward jump to 0x004d4eec
    mov dword ptr [ebp - local_8], 0x0           # 004d4e93
    mov eax, dword ptr [0x5b44f0]                # 004d4e9a
    shl eax, 0x4                                 # 004d4e9f
    mov ecx, dword ptr [0x5b44f4]                # 004d4ea2
    mov edx, dword ptr [0x583106]                # 004d4ea8
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004d4eae
    mov word ptr [ebp - local_4], dx             # 004d4eb5
    mov eax, dword ptr [0x5b44f0]                # 004d4eb9
    shl eax, 0x4                                 # 004d4ebe
    mov ecx, dword ptr [0x5b44f4]                # 004d4ec1
    mov edx, dword ptr [0x583102]                # 004d4ec7
    add edx, dword ptr [eax + 8*ecx + 0x5b30cc]  # 004d4ecd
    mov word ptr [ebp - local_10], dx            # 004d4ed4
    mov word ptr [ebp - local_c], 0x0            # 004d4ed8
    jmp.d8 L_004d4eec                            # 004d4ede
L_004d4ee0:
    # block 0x004d4ee0: entered by jmp at 0x004d50a6, 3 instruction(s), falls into the block at 0x004d4eec
    mov ax, word ptr [ebp - local_c]             # 004d4ee0
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d4ee4
    mov word ptr [ebp - local_c], ax             # 004d4ee8
L_004d4eec:
    # block 0x004d4eec: entered by jmp at 0x004d4ede, 3 instruction(s), ends with jge to 0x004d50ab (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004d4eec
    cmp ecx, 0x1                                 # 004d4ef0
    jge.d32 L_004d50ab                           # 004d4ef3
    # block 0x004d4ef9: entered by fall-through of jge at 0x004d4ef3, 5 instruction(s), ends with jl to 0x004d50a6 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004d4ef9
    movsx eax, word ptr [ebp - local_c]          # 004d4efd
    shl eax, 0x4                                 # 004d4f01
    cmp edx, dword ptr [eax + 0x5affd6]          # 004d4f04
    jl.d32 L_004d50a6                            # 004d4f0a
    # block 0x004d4f10: entered by fall-through of jl at 0x004d4f0a, 5 instruction(s), ends with jg to 0x004d50a6 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d4f10
    movsx edx, word ptr [ebp - local_c]          # 004d4f14
    shl edx, 0x4                                 # 004d4f18
    cmp ecx, dword ptr [edx + 0x5affde]          # 004d4f1b
    jg.d32 L_004d50a6                            # 004d4f21
    # block 0x004d4f27: entered by fall-through of jg at 0x004d4f21, 5 instruction(s), ends with jl to 0x004d50a6 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004d4f27
    movsx ecx, word ptr [ebp - local_c]          # 004d4f2b
    shl ecx, 0x4                                 # 004d4f2f
    cmp eax, dword ptr [ecx + 0x5affd2]          # 004d4f32
    jl.d32 L_004d50a6                            # 004d4f38
    # block 0x004d4f3e: entered by fall-through of jl at 0x004d4f38, 5 instruction(s), ends with jg to 0x004d50a6 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004d4f3e
    movsx eax, word ptr [ebp - local_c]          # 004d4f42
    shl eax, 0x4                                 # 004d4f46
    cmp edx, dword ptr [eax + 0x5affda]          # 004d4f49
    jg.d32 L_004d50a6                            # 004d4f4f
    # block 0x004d4f55: entered by fall-through of jg at 0x004d4f4f, 3 instruction(s), ends with jne to 0x004d50a6 (forward)
    movsx ecx, word ptr [0x5b000e]               # 004d4f55
    cmp ecx, -0x1                                # 004d4f5c
    jne.d32 L_004d50a6                           # 004d4f5f
    # block 0x004d4f65: entered by fall-through of jne at 0x004d4f5f, 8 instruction(s), ends with je to 0x004d4f9a (forward)
    mov dword ptr [ebp - local_8], 0x1           # 004d4f65
    mov dx, word ptr [ebp - local_c]             # 004d4f6c
    mov word ptr [0x5b0010], dx                  # 004d4f70
    mov dword ptr [0x5d2d0f], 0x1                # 004d4f77
    mov eax, dword ptr [0x5b000a]                # 004d4f81
    mov dword ptr [ebp - local_2c], eax          # 004d4f86
    cmp dword ptr [ebp - local_2c], 0x0          # 004d4f89
    je.d8 L_004d4f9a                             # 004d4f8d
    # block 0x004d4f8f: entered by fall-through of je at 0x004d4f8d, 2 instruction(s), ends with je to 0x004d4fb3 (forward)
    cmp dword ptr [ebp - local_2c], 0x1          # 004d4f8f
    je.d8 L_004d4fb3                             # 004d4f93
    # block 0x004d4f95: entered by fall-through of je at 0x004d4f93, 1 instruction(s), ends with forward jump to 0x004d50a4
    jmp.d32 L_004d50a4                           # 004d4f95
L_004d4f9a:
    # block 0x004d4f9a: entered by je at 0x004d4f8d, 4 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004d50a4
    mov ecx, 0x5830a6                            # 004d4f9a
    call FUN_004dad60                            # 004d4f9f
    mov dword ptr [0x5b000a], 0x1                # 004d4fa4
    jmp.d32 L_004d50a4                           # 004d4fae
L_004d4fb3:
    # block 0x004d4fb3: entered by je at 0x004d4f93, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004d50a4 (forward)
    mov ecx, 0x5830a6                            # 004d4fb3
    call FUN_004daef1                            # 004d4fb8
    cmp eax, 0x2                                 # 004d4fbd
    jne.d32 L_004d50a4                           # 004d4fc0
    # block 0x004d4fc6: entered by fall-through of jne at 0x004d4fc0, 45 instruction(s), calls FUN_004dad60, KERNEL32.dll!GetTickCount, FUN_004fb2e3, falls into the block at 0x004d50a4
    mov cx, word ptr [ebp - local_c]             # 004d4fc6
    mov word ptr [0x5b000e], cx                  # 004d4fca
    mov ecx, 0x5830a6                            # 004d4fd1
    call FUN_004dad60                            # 004d4fd6
    movsx edx, word ptr [ebp - local_c]          # 004d4fdb
    shl edx, 0x4                                 # 004d4fdf
    mov eax, dword ptr [edx + 0x5affe6]          # 004d4fe2
    mov dword ptr [0x5b0016], eax                # 004d4fe8
    movsx ecx, word ptr [ebp - local_c]          # 004d4fed
    shl ecx, 0x4                                 # 004d4ff1
    mov edx, dword ptr [ecx + 0x5affee]          # 004d4ff4
    mov dword ptr [0x5b001e], edx                # 004d4ffa
    movsx eax, word ptr [ebp - local_c]          # 004d5000
    shl eax, 0x4                                 # 004d5004
    mov ecx, dword ptr [eax + 0x5affe2]          # 004d5007
    mov dword ptr [0x5b0012], ecx                # 004d500d
    movsx edx, word ptr [ebp - local_c]          # 004d5013
    shl edx, 0x4                                 # 004d5017
    mov eax, dword ptr [edx + 0x5affea]          # 004d501a
    mov dword ptr [0x5b001a], eax                # 004d5020
    movsx ecx, word ptr [ebp - local_c]          # 004d5025
    shl ecx, 0x4                                 # 004d5029
    mov edx, dword ptr [ecx + 0x5affd6]          # 004d502c
    mov dword ptr [0x5b0026], edx                # 004d5032
    movsx eax, word ptr [ebp - local_c]          # 004d5038
    shl eax, 0x4                                 # 004d503c
    mov ecx, dword ptr [eax + 0x5affde]          # 004d503f
    mov dword ptr [0x5b002e], ecx                # 004d5045
    movsx edx, word ptr [ebp - local_c]          # 004d504b
    shl edx, 0x4                                 # 004d504f
    mov eax, dword ptr [edx + 0x5affd2]          # 004d5052
    mov dword ptr [0x5b0022], eax                # 004d5058
    movsx ecx, word ptr [ebp - local_c]          # 004d505d
    shl ecx, 0x4                                 # 004d5061
    mov edx, dword ptr [ecx + 0x5affda]          # 004d5064
    mov dword ptr [0x5b002a], edx                # 004d506a
    call dword ptr [0x52a23c]                    # 004d5070
    movsx ecx, word ptr [0x5b0282]               # 004d5076
    {load} add eax, ecx                          # 004d507d
    mov dword ptr [0x5b0002], eax                # 004d507f
    push 0x17                                    # 004d5084
    mov ecx, 0x5c3a67                            # 004d5086
    call FUN_004fb2e3                            # 004d508b
    mov dword ptr [0x5d2cc5], 0x1                # 004d5090
    mov dword ptr [0x5b0006], 0x2                # 004d509a
L_004d50a4:
    # block 0x004d50a4: entered by jmp at 0x004d4f95; jmp at 0x004d4fae; jne at 0x004d4fc0, 1 instruction(s), ends with forward jump to 0x004d50ab
    jmp.d8 L_004d50ab                            # 004d50a4
L_004d50a6:
    # block 0x004d50a6: entered by jl at 0x004d4f0a; jg at 0x004d4f21; jl at 0x004d4f38; jg at 0x004d4f4f; jne at 0x004d4f5f, 1 instruction(s), ends with backward jump to 0x004d4ee0
    jmp.d32 L_004d4ee0                           # 004d50a6
L_004d50ab:
    # block 0x004d50ab: entered by jge at 0x004d4ef3; jmp at 0x004d50a4, 2 instruction(s), ends with jne to 0x004d50bb (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004d50ab
    jne.d8 L_004d50bb                            # 004d50af
    # block 0x004d50b1: entered by fall-through of jne at 0x004d50af, 1 instruction(s), falls into the block at 0x004d50bb
    mov dword ptr [0x5b000a], 0x0                # 004d50b1
L_004d50bb:
    # block 0x004d50bb: entered by jne at 0x004d50af, 1 instruction(s), ends with forward jump to 0x004d51a7
    jmp.d32 L_004d51a7                           # 004d50bb
L_004d50c0:
    # block 0x004d50c0: entered by je at 0x004d4c3c, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d50e8 (forward)
    call dword ptr [0x52a23c]                    # 004d50c0
    cmp eax, dword ptr [0x5b0002]                # 004d50c6
    jbe.d8 L_004d50e8                            # 004d50cc
    # block 0x004d50ce: entered by fall-through of jbe at 0x004d50cc, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004d50e8 (forward)
    push 0x17                                    # 004d50ce
    mov ecx, 0x5cf1eb                            # 004d50d0
    call FUN_004f6334                            # 004d50d5
    test eax, eax                                # 004d50da
    jne.d8 L_004d50e8                            # 004d50dc
    # block 0x004d50de: entered by fall-through of jne at 0x004d50dc, 1 instruction(s), falls into the block at 0x004d50e8
    mov dword ptr [0x5b0006], 0x3                # 004d50de
L_004d50e8:
    # block 0x004d50e8: entered by jbe at 0x004d50cc; jne at 0x004d50dc, 1 instruction(s), ends with forward jump to 0x004d51a7
    jmp.d32 L_004d51a7                           # 004d50e8
L_004d50ed:
    # block 0x004d50ed: entered by je at 0x004d4c46, 6 instruction(s), calls FUN_004dad60, ends with je to 0x004d5109 (forward)
    mov ecx, 0x5830a6                            # 004d50ed
    call FUN_004dad60                            # 004d50f2
    movsx edx, word ptr [0x5b000e]               # 004d50f7
    mov dword ptr [ebp - local_30], edx          # 004d50fe
    cmp dword ptr [ebp - local_30], 0x0          # 004d5101
    je.d8 L_004d5109                             # 004d5105
    # block 0x004d5107: entered by fall-through of je at 0x004d5105, 1 instruction(s), ends with forward jump to 0x004d5142
    jmp.d8 L_004d5142                            # 004d5107
L_004d5109:
    # block 0x004d5109: entered by je at 0x004d5105, 5 instruction(s), calls FUN_0043dbd5, ends with jne to 0x004d512d (forward)
    mov eax, dword ptr [0x583985]                # 004d5109
    mov dword ptr [0x583981], eax                # 004d510e
    call FUN_0043dbd5                            # 004d5113
    cmp dword ptr [0x583985], 0x6                # 004d5118
    jne.d8 L_004d512d                            # 004d511f
    # block 0x004d5121: entered by fall-through of jne at 0x004d511f, 2 instruction(s), ends with forward jump to 0x004d5140
    mov dword ptr [0x5839a1], 0x0                # 004d5121
    jmp.d8 L_004d5140                            # 004d512b
L_004d512d:
    # block 0x004d512d: entered by jne at 0x004d511f, 2 instruction(s), ends with jne to 0x004d5140 (forward)
    cmp dword ptr [0x583985], 0xe                # 004d512d
    jne.d8 L_004d5140                            # 004d5134
    # block 0x004d5136: entered by fall-through of jne at 0x004d5134, 2 instruction(s), calls FUN_004db870, falls into the block at 0x004d5140
    mov ecx, 0x5830ce                            # 004d5136
    call FUN_004db870                            # 004d513b
L_004d5140:
    # block 0x004d5140: entered by jmp at 0x004d512b; jne at 0x004d5134, 1 instruction(s), ends with forward jump to 0x004d515a
    jmp.d8 L_004d515a                            # 004d5140
L_004d5142:
    # block 0x004d5142: entered by jmp at 0x004d5107, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d515a
    push 0x0                                     # 004d5142
    push 0x0                                     # 004d5144
    push 0x55a634                                # 004d5146
    call FUN_0052139c                            # 004d514b
    mov ecx, 0x5cf659                            # 004d5150
    call FUN_004c97b4                            # 004d5155
L_004d515a:
    # block 0x004d515a: entered by jmp at 0x004d5140, 10 instruction(s), calls FUN_004c2dfb, ends with forward jump to 0x004d51b4
    mov dword ptr [0x583985], 0xa                # 004d515a
    mov dword ptr [0x5d2be7], 0x0                # 004d5164
    mov dword ptr [0x5d2c31], 0x0                # 004d516e
    mov dword ptr [0x5d2c7b], 0x0                # 004d5178
    mov dword ptr [0x5d2cc5], 0x0                # 004d5182
    mov dword ptr [0x5d2d0f], 0x0                # 004d518c
    push 0x5d037f                                # 004d5196
    mov ecx, 0x5cf659                            # 004d519b
    call FUN_004c2dfb                            # 004d51a0
    jmp.d8 L_004d51b4                            # 004d51a5
L_004d51a7:
    # block 0x004d51a7: entered by jmp at 0x004d4c4c; jmp at 0x004d50bb; jmp at 0x004d50e8, 3 instruction(s), calls FUN_004cf7e0, falls into the block at 0x004d51b4
    push 0x55a5a4                                # 004d51a7
    call FUN_004cf7e0                            # 004d51ac
    add esp, 0x4                                 # 004d51b1
L_004d51b4:
    # block 0x004d51b4: entered by jmp at 0x004d51a5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d51b4
    pop ebp                                      # 004d51b6
    ret                                          # 004d51b7

# --- data items (not part of the function) -------------------------
.org 0x004d51b8 - 0x401000
PAD_004d51b8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

