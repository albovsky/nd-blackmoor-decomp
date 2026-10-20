# FUN_004c6c2a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c6c2a
# extent:       0x004c6c2a-0x004c6e4d (547 code bytes)
# span:         0x004c6c2a-0x004c6e4d (code 547, tables 0, padding 0)
# sha256:       988eba78b086c69fe7f19337320f8cca2f2e11416ad416bac2f9db2c30f9b02f
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_df_blt_rotate90_no_trans
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c6c2a.c.txt, not original source) refers to the data labelled s_ERROR___DFBltRotate90NoTrans_____00555190
# name-note:    Copies a rectangle into the destination rotated by 90 degrees pixel by pixel; the size check reports the DFBltRotate90NoTrans error.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_120, local_124, local_128 and 2 more
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 173 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c6c2a - 0x401000
.globl FUN_004c6c2a
FUN_004c6c2a:
    # block 0x004c6c2a: entry, 8 instruction(s), ends with je to 0x004c6d1f (forward)
    push ebp                                     # 004c6c2a
    {load} mov ebp, esp                          # 004c6c2b
    sub esp, 0x130                               # 004c6c2d
    push esi                                     # 004c6c33
    mov dword ptr [ebp - local_130], ecx         # 004c6c34
    movsx eax, word ptr [0x63a4cd]               # 004c6c3a
    test eax, eax                                # 004c6c41
    je.d32 L_004c6d1f                            # 004c6c43
    # block 0x004c6c49: entered by fall-through of je at 0x004c6c43, 23 instruction(s), ends with jne to 0x004c6cb1 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c6c49
    mov edx, dword ptr [ebp + arg_10]            # 004c6c4c
    mov eax, dword ptr [ecx + field_8]           # 004c6c4f
    sub eax, dword ptr [edx]                     # 004c6c52
    mov dword ptr [ebp - local_12c], eax         # 004c6c54
    mov ecx, dword ptr [ebp + arg_10]            # 004c6c5a
    mov edx, dword ptr [ebp + arg_10]            # 004c6c5d
    mov eax, dword ptr [ecx + field_c]           # 004c6c60
    sub eax, dword ptr [edx + field_4]           # 004c6c63
    mov dword ptr [ebp - local_128], eax         # 004c6c66
    mov ecx, dword ptr [ebp + arg_14]            # 004c6c6c
    mov edx, dword ptr [ebp + arg_14]            # 004c6c6f
    mov eax, dword ptr [ecx + field_8]           # 004c6c72
    sub eax, dword ptr [edx]                     # 004c6c75
    mov dword ptr [ebp - local_24], eax          # 004c6c77
    mov ecx, dword ptr [ebp + arg_14]            # 004c6c7a
    mov edx, dword ptr [ebp + arg_14]            # 004c6c7d
    mov eax, dword ptr [ecx + field_c]           # 004c6c80
    sub eax, dword ptr [edx + field_4]           # 004c6c83
    mov dword ptr [ebp - local_124], eax         # 004c6c86
    mov ecx, dword ptr [ebp - local_12c]         # 004c6c8c
    cmp ecx, dword ptr [ebp - local_24]          # 004c6c92
    jne.d8 L_004c6cb1                            # 004c6c95
    # block 0x004c6c97: entered by fall-through of jne at 0x004c6c95, 3 instruction(s), ends with jne to 0x004c6cb1 (forward)
    mov edx, dword ptr [ebp - local_128]         # 004c6c97
    cmp edx, dword ptr [ebp - local_124]         # 004c6c9d
    jne.d8 L_004c6cb1                            # 004c6ca3
    # block 0x004c6ca5: entered by fall-through of jne at 0x004c6ca3, 2 instruction(s), ends with je to 0x004c6cb1 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c6ca5
    je.d8 L_004c6cb1                             # 004c6ca9
    # block 0x004c6cab: entered by fall-through of je at 0x004c6ca9, 2 instruction(s), ends with jne to 0x004c6d1f (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c6cab
    jne.d8 L_004c6d1f                            # 004c6caf
L_004c6cb1:
    # block 0x004c6cb1: entered by jne at 0x004c6c95; jne at 0x004c6ca3; je at 0x004c6ca9; fall-through of jne at 0x004c6caf, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6e46
    mov eax, dword ptr [ebp + arg_14]            # 004c6cb1
    mov ecx, dword ptr [eax + field_c]           # 004c6cb4
    push ecx                                     # 004c6cb7
    mov edx, dword ptr [ebp + arg_14]            # 004c6cb8
    mov eax, dword ptr [edx + field_8]           # 004c6cbb
    push eax                                     # 004c6cbe
    mov ecx, dword ptr [ebp + arg_14]            # 004c6cbf
    mov edx, dword ptr [ecx + field_4]           # 004c6cc2
    push edx                                     # 004c6cc5
    mov eax, dword ptr [ebp + arg_14]            # 004c6cc6
    mov ecx, dword ptr [eax]                     # 004c6cc9
    push ecx                                     # 004c6ccb
    mov edx, dword ptr [ebp + arg_10]            # 004c6ccc
    mov eax, dword ptr [edx + field_c]           # 004c6ccf
    push eax                                     # 004c6cd2
    mov ecx, dword ptr [ebp + arg_10]            # 004c6cd3
    mov edx, dword ptr [ecx + field_8]           # 004c6cd6
    push edx                                     # 004c6cd9
    mov eax, dword ptr [ebp + arg_10]            # 004c6cda
    mov ecx, dword ptr [eax + field_4]           # 004c6cdd
    push ecx                                     # 004c6ce0
    mov edx, dword ptr [ebp + arg_10]            # 004c6ce1
    mov eax, dword ptr [edx]                     # 004c6ce4
    push eax                                     # 004c6ce6
    mov ecx, dword ptr [ebp + arg_18]            # 004c6ce7
    push ecx                                     # 004c6cea
    push 0x555190                                # 004c6ceb
    lea edx, [ebp - local_120]                   # 004c6cf0
    push edx                                     # 004c6cf6
    call FUN_0050ca3e                            # 004c6cf7
    add esp, 0x2c                                # 004c6cfc
    push 0x0                                     # 004c6cff
    push 0x0                                     # 004c6d01
    lea eax, [ebp - local_120]                   # 004c6d03
    push eax                                     # 004c6d09
    call FUN_0052139c                            # 004c6d0a
    mov ecx, dword ptr [ebp - local_130]         # 004c6d0f
    call FUN_004c97b4                            # 004c6d15
    jmp.d32 L_004c6e46                           # 004c6d1a
L_004c6d1f:
    # block 0x004c6d1f: entered by je at 0x004c6c43; jne at 0x004c6caf, 50 instruction(s), ends with forward jump to 0x004c6dc5
    mov ecx, dword ptr [ebp + arg_8]             # 004c6d1f
    movsx edx, word ptr [ecx + field_2f]         # 004c6d22
    mov eax, dword ptr [ebp + arg_10]            # 004c6d26
    mov ecx, dword ptr [eax + field_4]           # 004c6d29
    imul ecx, edx                                # 004c6d2c
    mov edx, dword ptr [ebp + arg_8]             # 004c6d2f
    mov eax, dword ptr [edx]                     # 004c6d32
    {load} add eax, ecx                          # 004c6d34
    movsx ecx, word ptr [0x639895]               # 004c6d36
    mov edx, dword ptr [ebp + arg_10]            # 004c6d3d
    mov edx, dword ptr [edx]                     # 004c6d40
    imul edx, ecx                                # 004c6d42
    {load} add eax, edx                          # 004c6d45
    mov dword ptr [ebp - local_4], eax           # 004c6d47
    mov eax, dword ptr [ebp + arg_c]             # 004c6d4a
    movsx ecx, word ptr [eax + field_2f]         # 004c6d4d
    mov edx, dword ptr [ebp + arg_14]            # 004c6d51
    mov eax, dword ptr [edx + field_4]           # 004c6d54
    imul eax, ecx                                # 004c6d57
    mov ecx, dword ptr [ebp + arg_c]             # 004c6d5a
    mov edx, dword ptr [ecx]                     # 004c6d5d
    {load} add edx, eax                          # 004c6d5f
    movsx eax, word ptr [0x639895]               # 004c6d61
    mov ecx, dword ptr [ebp + arg_14]            # 004c6d68
    mov ecx, dword ptr [ecx]                     # 004c6d6b
    imul ecx, eax                                # 004c6d6d
    {load} add edx, ecx                          # 004c6d70
    mov dword ptr [ebp - local_c], edx           # 004c6d72
    mov edx, dword ptr [ebp + arg_10]            # 004c6d75
    mov eax, dword ptr [ebp + arg_10]            # 004c6d78
    mov ecx, dword ptr [edx + field_c]           # 004c6d7b
    sub ecx, dword ptr [eax + field_4]           # 004c6d7e
    add ecx, 0x1                                 # 004c6d81
    mov dword ptr [ebp - local_10], ecx          # 004c6d84
    mov edx, dword ptr [ebp + arg_10]            # 004c6d87
    mov eax, dword ptr [ebp + arg_10]            # 004c6d8a
    mov ecx, dword ptr [edx + field_8]           # 004c6d8d
    sub ecx, dword ptr [eax]                     # 004c6d90
    add ecx, 0x1                                 # 004c6d92
    mov dword ptr [ebp - local_14], ecx          # 004c6d95
    mov edx, dword ptr [ebp + arg_10]            # 004c6d98
    mov eax, dword ptr [ebp + arg_10]            # 004c6d9b
    mov ecx, dword ptr [edx + field_8]           # 004c6d9e
    sub ecx, dword ptr [eax]                     # 004c6da1
    add ecx, 0x1                                 # 004c6da3
    movsx edx, word ptr [0x639895]               # 004c6da6
    imul ecx, edx                                # 004c6dad
    mov dword ptr [ebp - local_8], ecx           # 004c6db0
    mov dword ptr [ebp - local_1c], 0x0          # 004c6db3
    jmp.d8 L_004c6dc5                            # 004c6dba
L_004c6dbc:
    # block 0x004c6dbc: entered by jmp at 0x004c6e41, 3 instruction(s), falls into the block at 0x004c6dc5
    mov eax, dword ptr [ebp - local_1c]          # 004c6dbc
    add eax, 0x1                                 # 004c6dbf
    mov dword ptr [ebp - local_1c], eax          # 004c6dc2
L_004c6dc5:
    # block 0x004c6dc5: entered by jmp at 0x004c6dba, 3 instruction(s), ends with jge to 0x004c6e46 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c6dc5
    cmp ecx, dword ptr [ebp - local_14]          # 004c6dc8
    jge.d8 L_004c6e46                            # 004c6dcb
    # block 0x004c6dcd: entered by fall-through of jge at 0x004c6dcb, 5 instruction(s), ends with forward jump to 0x004c6df1
    mov dword ptr [ebp - local_18], 0x0          # 004c6dcd
    mov edx, dword ptr [ebp - local_10]          # 004c6dd4
    sub edx, 0x1                                 # 004c6dd7
    mov dword ptr [ebp - local_20], edx          # 004c6dda
    jmp.d8 L_004c6df1                            # 004c6ddd
L_004c6ddf:
    # block 0x004c6ddf: entered by jmp at 0x004c6e30, 6 instruction(s), falls into the block at 0x004c6df1
    mov eax, dword ptr [ebp - local_18]          # 004c6ddf
    add eax, 0x1                                 # 004c6de2
    mov dword ptr [ebp - local_18], eax          # 004c6de5
    mov ecx, dword ptr [ebp - local_20]          # 004c6de8
    sub ecx, 0x1                                 # 004c6deb
    mov dword ptr [ebp - local_20], ecx          # 004c6dee
L_004c6df1:
    # block 0x004c6df1: entered by jmp at 0x004c6ddd, 3 instruction(s), ends with jge to 0x004c6e32 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004c6df1
    cmp edx, dword ptr [ebp - local_14]          # 004c6df4
    jge.d8 L_004c6e32                            # 004c6df7
    # block 0x004c6df9: entered by fall-through of jge at 0x004c6df7, 16 instruction(s), ends with backward jump to 0x004c6ddf
    mov eax, dword ptr [ebp + arg_8]             # 004c6df9
    movsx ecx, word ptr [eax + field_2f]         # 004c6dfc
    mov edx, dword ptr [ebp - local_20]          # 004c6e00
    imul edx, ecx                                # 004c6e03
    mov eax, dword ptr [ebp - local_4]           # 004c6e06
    {load} add eax, edx                          # 004c6e09
    movsx ecx, word ptr [0x639895]               # 004c6e0b
    mov edx, dword ptr [ebp - local_1c]          # 004c6e12
    imul edx, ecx                                # 004c6e15
    movsx ecx, word ptr [0x639895]               # 004c6e18
    mov esi, dword ptr [ebp - local_18]          # 004c6e1f
    imul esi, ecx                                # 004c6e22
    mov ecx, dword ptr [ebp - local_c]           # 004c6e25
    mov dx, word ptr [eax + edx]                 # 004c6e28
    mov word ptr [ecx + esi], dx                 # 004c6e2c
    jmp.d8 L_004c6ddf                            # 004c6e30
L_004c6e32:
    # block 0x004c6e32: entered by jge at 0x004c6df7, 6 instruction(s), ends with backward jump to 0x004c6dbc
    mov eax, dword ptr [ebp + arg_c]             # 004c6e32
    movsx ecx, word ptr [eax + field_2f]         # 004c6e35
    mov edx, dword ptr [ebp - local_c]           # 004c6e39
    {load} add edx, ecx                          # 004c6e3c
    mov dword ptr [ebp - local_c], edx           # 004c6e3e
    jmp.d32 L_004c6dbc                           # 004c6e41
L_004c6e46:
    # block 0x004c6e46: entered by jmp at 0x004c6d1a; jge at 0x004c6dcb, 4 instruction(s), ends with ret 0x14
    pop esi                                      # 004c6e46
    {load} mov esp, ebp                          # 004c6e47
    pop ebp                                      # 004c6e49
    ret 0x14                                     # 004c6e4a

