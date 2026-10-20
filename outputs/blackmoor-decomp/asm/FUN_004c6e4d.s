# FUN_004c6e4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c6e4d
# extent:       0x004c6e4d-0x004c7070 (547 code bytes)
# span:         0x004c6e4d-0x004c7070 (code 547, tables 0, padding 0)
# sha256:       464027a3ff89368274c669f6366d8bfd8d7f77c492bd4aa3cf8b4e7b85ab6482
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_df_blt_half_turn_no_trans
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c6e4d.c.txt, not original source) refers to the data labelled s_ERROR___DFBltRotate180NoTrans_____0055523c
# name-note:    Copies a rectangle into the destination rotated by 180 degrees pixel by pixel; the size check reports the DFBltRotate180NoTrans error.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_120, local_124, local_128 and 2 more
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x004c6e4d - 0x401000
.globl FUN_004c6e4d
FUN_004c6e4d:
    # block 0x004c6e4d: entry, 8 instruction(s), ends with je to 0x004c6f42 (forward)
    push ebp                                     # 004c6e4d
    {load} mov ebp, esp                          # 004c6e4e
    sub esp, 0x130                               # 004c6e50
    push esi                                     # 004c6e56
    mov dword ptr [ebp - local_130], ecx         # 004c6e57
    movsx eax, word ptr [0x63a4cd]               # 004c6e5d
    test eax, eax                                # 004c6e64
    je.d32 L_004c6f42                            # 004c6e66
    # block 0x004c6e6c: entered by fall-through of je at 0x004c6e66, 23 instruction(s), ends with jne to 0x004c6ed4 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c6e6c
    mov edx, dword ptr [ebp + arg_10]            # 004c6e6f
    mov eax, dword ptr [ecx + field_8]           # 004c6e72
    sub eax, dword ptr [edx]                     # 004c6e75
    mov dword ptr [ebp - local_12c], eax         # 004c6e77
    mov ecx, dword ptr [ebp + arg_10]            # 004c6e7d
    mov edx, dword ptr [ebp + arg_10]            # 004c6e80
    mov eax, dword ptr [ecx + field_c]           # 004c6e83
    sub eax, dword ptr [edx + field_4]           # 004c6e86
    mov dword ptr [ebp - local_128], eax         # 004c6e89
    mov ecx, dword ptr [ebp + arg_14]            # 004c6e8f
    mov edx, dword ptr [ebp + arg_14]            # 004c6e92
    mov eax, dword ptr [ecx + field_8]           # 004c6e95
    sub eax, dword ptr [edx]                     # 004c6e98
    mov dword ptr [ebp - local_24], eax          # 004c6e9a
    mov ecx, dword ptr [ebp + arg_14]            # 004c6e9d
    mov edx, dword ptr [ebp + arg_14]            # 004c6ea0
    mov eax, dword ptr [ecx + field_c]           # 004c6ea3
    sub eax, dword ptr [edx + field_4]           # 004c6ea6
    mov dword ptr [ebp - local_124], eax         # 004c6ea9
    mov ecx, dword ptr [ebp - local_12c]         # 004c6eaf
    cmp ecx, dword ptr [ebp - local_24]          # 004c6eb5
    jne.d8 L_004c6ed4                            # 004c6eb8
    # block 0x004c6eba: entered by fall-through of jne at 0x004c6eb8, 3 instruction(s), ends with jne to 0x004c6ed4 (forward)
    mov edx, dword ptr [ebp - local_128]         # 004c6eba
    cmp edx, dword ptr [ebp - local_124]         # 004c6ec0
    jne.d8 L_004c6ed4                            # 004c6ec6
    # block 0x004c6ec8: entered by fall-through of jne at 0x004c6ec6, 2 instruction(s), ends with je to 0x004c6ed4 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c6ec8
    je.d8 L_004c6ed4                             # 004c6ecc
    # block 0x004c6ece: entered by fall-through of je at 0x004c6ecc, 2 instruction(s), ends with jne to 0x004c6f42 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c6ece
    jne.d8 L_004c6f42                            # 004c6ed2
L_004c6ed4:
    # block 0x004c6ed4: entered by jne at 0x004c6eb8; jne at 0x004c6ec6; je at 0x004c6ecc; fall-through of jne at 0x004c6ed2, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c7069
    mov eax, dword ptr [ebp + arg_14]            # 004c6ed4
    mov ecx, dword ptr [eax + field_c]           # 004c6ed7
    push ecx                                     # 004c6eda
    mov edx, dword ptr [ebp + arg_14]            # 004c6edb
    mov eax, dword ptr [edx + field_8]           # 004c6ede
    push eax                                     # 004c6ee1
    mov ecx, dword ptr [ebp + arg_14]            # 004c6ee2
    mov edx, dword ptr [ecx + field_4]           # 004c6ee5
    push edx                                     # 004c6ee8
    mov eax, dword ptr [ebp + arg_14]            # 004c6ee9
    mov ecx, dword ptr [eax]                     # 004c6eec
    push ecx                                     # 004c6eee
    mov edx, dword ptr [ebp + arg_10]            # 004c6eef
    mov eax, dword ptr [edx + field_c]           # 004c6ef2
    push eax                                     # 004c6ef5
    mov ecx, dword ptr [ebp + arg_10]            # 004c6ef6
    mov edx, dword ptr [ecx + field_8]           # 004c6ef9
    push edx                                     # 004c6efc
    mov eax, dword ptr [ebp + arg_10]            # 004c6efd
    mov ecx, dword ptr [eax + field_4]           # 004c6f00
    push ecx                                     # 004c6f03
    mov edx, dword ptr [ebp + arg_10]            # 004c6f04
    mov eax, dword ptr [edx]                     # 004c6f07
    push eax                                     # 004c6f09
    mov ecx, dword ptr [ebp + arg_18]            # 004c6f0a
    push ecx                                     # 004c6f0d
    push 0x55523c                                # 004c6f0e
    lea edx, [ebp - local_120]                   # 004c6f13
    push edx                                     # 004c6f19
    call FUN_0050ca3e                            # 004c6f1a
    add esp, 0x2c                                # 004c6f1f
    push 0x0                                     # 004c6f22
    push 0x0                                     # 004c6f24
    lea eax, [ebp - local_120]                   # 004c6f26
    push eax                                     # 004c6f2c
    call FUN_0052139c                            # 004c6f2d
    mov ecx, dword ptr [ebp - local_130]         # 004c6f32
    call FUN_004c97b4                            # 004c6f38
    jmp.d32 L_004c7069                           # 004c6f3d
L_004c6f42:
    # block 0x004c6f42: entered by je at 0x004c6e66; jne at 0x004c6ed2, 52 instruction(s), ends with forward jump to 0x004c6fea
    mov ecx, dword ptr [ebp + arg_8]             # 004c6f42
    movsx edx, word ptr [ecx + field_2f]         # 004c6f45
    mov eax, dword ptr [ebp + arg_10]            # 004c6f49
    mov ecx, dword ptr [eax + field_4]           # 004c6f4c
    imul ecx, edx                                # 004c6f4f
    mov edx, dword ptr [ebp + arg_8]             # 004c6f52
    mov eax, dword ptr [edx]                     # 004c6f55
    {load} add eax, ecx                          # 004c6f57
    movsx ecx, word ptr [0x639895]               # 004c6f59
    mov edx, dword ptr [ebp + arg_10]            # 004c6f60
    mov edx, dword ptr [edx]                     # 004c6f63
    imul edx, ecx                                # 004c6f65
    {load} add eax, edx                          # 004c6f68
    mov dword ptr [ebp - local_4], eax           # 004c6f6a
    mov eax, dword ptr [ebp + arg_c]             # 004c6f6d
    movsx ecx, word ptr [eax + field_2f]         # 004c6f70
    mov edx, dword ptr [ebp + arg_14]            # 004c6f74
    mov eax, dword ptr [edx + field_4]           # 004c6f77
    imul eax, ecx                                # 004c6f7a
    mov ecx, dword ptr [ebp + arg_c]             # 004c6f7d
    mov edx, dword ptr [ecx]                     # 004c6f80
    {load} add edx, eax                          # 004c6f82
    movsx eax, word ptr [0x639895]               # 004c6f84
    mov ecx, dword ptr [ebp + arg_14]            # 004c6f8b
    mov ecx, dword ptr [ecx]                     # 004c6f8e
    imul ecx, eax                                # 004c6f90
    {load} add edx, ecx                          # 004c6f93
    mov dword ptr [ebp - local_c], edx           # 004c6f95
    mov edx, dword ptr [ebp + arg_10]            # 004c6f98
    mov eax, dword ptr [ebp + arg_10]            # 004c6f9b
    mov ecx, dword ptr [edx + field_c]           # 004c6f9e
    sub ecx, dword ptr [eax + field_4]           # 004c6fa1
    add ecx, 0x1                                 # 004c6fa4
    mov dword ptr [ebp - local_10], ecx          # 004c6fa7
    mov edx, dword ptr [ebp + arg_10]            # 004c6faa
    mov eax, dword ptr [ebp + arg_10]            # 004c6fad
    mov ecx, dword ptr [edx + field_8]           # 004c6fb0
    sub ecx, dword ptr [eax]                     # 004c6fb3
    add ecx, 0x1                                 # 004c6fb5
    mov dword ptr [ebp - local_14], ecx          # 004c6fb8
    mov edx, dword ptr [ebp + arg_10]            # 004c6fbb
    mov eax, dword ptr [ebp + arg_10]            # 004c6fbe
    mov ecx, dword ptr [edx + field_8]           # 004c6fc1
    sub ecx, dword ptr [eax]                     # 004c6fc4
    add ecx, 0x1                                 # 004c6fc6
    movsx edx, word ptr [0x639895]               # 004c6fc9
    imul ecx, edx                                # 004c6fd0
    mov dword ptr [ebp - local_8], ecx           # 004c6fd3
    mov eax, dword ptr [ebp - local_10]          # 004c6fd6
    sub eax, 0x1                                 # 004c6fd9
    mov dword ptr [ebp - local_20], eax          # 004c6fdc
    jmp.d8 L_004c6fea                            # 004c6fdf
L_004c6fe1:
    # block 0x004c6fe1: entered by jmp at 0x004c7064, 3 instruction(s), falls into the block at 0x004c6fea
    mov ecx, dword ptr [ebp - local_20]          # 004c6fe1
    sub ecx, 0x1                                 # 004c6fe4
    mov dword ptr [ebp - local_20], ecx          # 004c6fe7
L_004c6fea:
    # block 0x004c6fea: entered by jmp at 0x004c6fdf, 2 instruction(s), ends with jl to 0x004c7069 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004c6fea
    jl.d8 L_004c7069                             # 004c6fee
    # block 0x004c6ff0: entered by fall-through of jl at 0x004c6fee, 5 instruction(s), ends with forward jump to 0x004c7014
    mov dword ptr [ebp - local_18], 0x0          # 004c6ff0
    mov edx, dword ptr [ebp - local_14]          # 004c6ff7
    sub edx, 0x1                                 # 004c6ffa
    mov dword ptr [ebp - local_1c], edx          # 004c6ffd
    jmp.d8 L_004c7014                            # 004c7000
L_004c7002:
    # block 0x004c7002: entered by jmp at 0x004c7053, 6 instruction(s), falls into the block at 0x004c7014
    mov eax, dword ptr [ebp - local_18]          # 004c7002
    add eax, 0x1                                 # 004c7005
    mov dword ptr [ebp - local_18], eax          # 004c7008
    mov ecx, dword ptr [ebp - local_1c]          # 004c700b
    sub ecx, 0x1                                 # 004c700e
    mov dword ptr [ebp - local_1c], ecx          # 004c7011
L_004c7014:
    # block 0x004c7014: entered by jmp at 0x004c7000, 3 instruction(s), ends with jge to 0x004c7055 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004c7014
    cmp edx, dword ptr [ebp - local_14]          # 004c7017
    jge.d8 L_004c7055                            # 004c701a
    # block 0x004c701c: entered by fall-through of jge at 0x004c701a, 16 instruction(s), ends with backward jump to 0x004c7002
    mov eax, dword ptr [ebp + arg_8]             # 004c701c
    movsx ecx, word ptr [eax + field_2f]         # 004c701f
    mov edx, dword ptr [ebp - local_20]          # 004c7023
    imul edx, ecx                                # 004c7026
    mov eax, dword ptr [ebp - local_4]           # 004c7029
    {load} add eax, edx                          # 004c702c
    movsx ecx, word ptr [0x639895]               # 004c702e
    mov edx, dword ptr [ebp - local_1c]          # 004c7035
    imul edx, ecx                                # 004c7038
    movsx ecx, word ptr [0x639895]               # 004c703b
    mov esi, dword ptr [ebp - local_18]          # 004c7042
    imul esi, ecx                                # 004c7045
    mov ecx, dword ptr [ebp - local_c]           # 004c7048
    mov dx, word ptr [eax + edx]                 # 004c704b
    mov word ptr [ecx + esi], dx                 # 004c704f
    jmp.d8 L_004c7002                            # 004c7053
L_004c7055:
    # block 0x004c7055: entered by jge at 0x004c701a, 6 instruction(s), ends with backward jump to 0x004c6fe1
    mov eax, dword ptr [ebp + arg_c]             # 004c7055
    movsx ecx, word ptr [eax + field_2f]         # 004c7058
    mov edx, dword ptr [ebp - local_c]           # 004c705c
    {load} add edx, ecx                          # 004c705f
    mov dword ptr [ebp - local_c], edx           # 004c7061
    jmp.d32 L_004c6fe1                           # 004c7064
L_004c7069:
    # block 0x004c7069: entered by jmp at 0x004c6f3d; jl at 0x004c6fee, 4 instruction(s), ends with ret 0x14
    pop esi                                      # 004c7069
    {load} mov esp, ebp                          # 004c706a
    pop ebp                                      # 004c706c
    ret 0x14                                     # 004c706d

