# FUN_004c7070
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7070
# extent:       0x004c7070-0x004c71f9 (393 code bytes)
# span:         0x004c7070-0x004c71f9 (code 393, tables 0, padding 0)
# sha256:       e552c5024eccec8c520207f55e12e611a1909c7a3171c0357bbe85f6b6620cc9
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c7070_rotate_image
# naming:       native port src/original_methods_fl33a.c:m4c7070_rotate_image (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Copies the image through a 0x51dc43 buffer, rotates it by word (columns, last row first), swaps the width and height words and frees the buffer; the allocator-failure report is taken too; 121/121, 6/6.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 4 more
# fields:       [eax + n] field_23, field_2b, field_2f; [ecx + n] field_2d; [edx + n] field_23, field_2b, field_31
# callees:      calls FUN_0051dc43, FUN_0042639d, FUN_004c97b4, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33a.c:m4c7070_rotate_image (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 121 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_40, 0x40  # offset -0x40
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_23, 0x23  # offset +0x23
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c7070 - 0x401000
.globl FUN_004c7070
FUN_004c7070:
    # block 0x004c7070: entry, 44 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c7124 (forward)
    push ebp                                     # 004c7070
    {load} mov ebp, esp                          # 004c7071
    sub esp, 0x40                                # 004c7073
    push esi                                     # 004c7076
    push edi                                     # 004c7077
    mov dword ptr [ebp - local_40], ecx          # 004c7078
    mov dword ptr [ebp - local_1c], 0x0          # 004c707b
    mov eax, dword ptr [ebp + arg_8]             # 004c7082
    mov ecx, dword ptr [eax]                     # 004c7085
    mov dword ptr [ebp - local_2c], ecx          # 004c7087
    mov edx, dword ptr [ebp + arg_8]             # 004c708a
    mov ax, word ptr [edx + field_2b]            # 004c708d
    mov word ptr [ebp - local_18], ax            # 004c7091
    mov ecx, dword ptr [ebp + arg_8]             # 004c7095
    mov dx, word ptr [ecx + field_2d]            # 004c7098
    mov word ptr [ebp - local_c], dx             # 004c709c
    mov eax, dword ptr [ebp + arg_8]             # 004c70a0
    mov cx, word ptr [eax + field_2f]            # 004c70a3
    mov word ptr [ebp - local_8], cx             # 004c70a7
    mov edx, dword ptr [ebp + arg_8]             # 004c70ab
    mov ax, word ptr [edx + field_31]            # 004c70ae
    mov word ptr [ebp - local_34], ax            # 004c70b2
    mov ecx, dword ptr [ebp + arg_8]             # 004c70b6
    mov dx, word ptr [ecx + field_2d]            # 004c70b9
    mov word ptr [ebp - local_24], dx            # 004c70bd
    mov eax, dword ptr [ebp + arg_8]             # 004c70c1
    mov cx, word ptr [eax + field_2b]            # 004c70c4
    mov word ptr [ebp - local_14], cx            # 004c70c8
    movsx edx, word ptr [ebp - local_24]         # 004c70cc
    movsx eax, word ptr [0x639895]               # 004c70d0
    imul edx, eax                                # 004c70d7
    mov word ptr [ebp - local_20], dx            # 004c70da
    mov cx, word ptr [ebp - local_14]            # 004c70de
    mov word ptr [ebp - local_10], cx            # 004c70e2
    mov edx, dword ptr [ebp + arg_8]             # 004c70e6
    mov eax, dword ptr [edx + field_23]          # 004c70e9
    push eax                                     # 004c70ec
    call FUN_0051dc43                            # 004c70ed
    add esp, 0x4                                 # 004c70f2
    mov dword ptr [ebp - local_38], eax          # 004c70f5
    mov ecx, dword ptr [ebp - local_38]          # 004c70f8
    mov dword ptr [ebp - local_1c], ecx          # 004c70fb
    cmp dword ptr [ebp - local_1c], 0x0          # 004c70fe
    jne.d8 L_004c7124                            # 004c7102
    # block 0x004c7104: entered by fall-through of jne at 0x004c7102, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c71f1
    mov edx, dword ptr [ebp + arg_c]             # 004c7104
    push edx                                     # 004c7107
    push 0x5552e8                                # 004c7108
    mov ecx, 0x583979                            # 004c710d
    call FUN_0042639d                            # 004c7112
    mov ecx, dword ptr [ebp - local_40]          # 004c7117
    call FUN_004c97b4                            # 004c711a
    jmp.d32 L_004c71f1                           # 004c711f
L_004c7124:
    # block 0x004c7124: entered by jne at 0x004c7102, 14 instruction(s), ends with forward jump to 0x004c7159
    mov eax, dword ptr [ebp + arg_8]             # 004c7124
    mov ecx, dword ptr [eax + field_23]          # 004c7127
    mov edx, dword ptr [ebp + arg_8]             # 004c712a
    mov esi, dword ptr [edx]                     # 004c712d
    mov edi, dword ptr [ebp - local_1c]          # 004c712f
    {load} mov eax, ecx                          # 004c7132
    shr ecx, 0x2                                 # 004c7134
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c7137
    {load} mov ecx, eax                          # 004c7139
    and ecx, 0x3                                 # 004c713b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c713e
    mov dword ptr [ebp - local_4], 0x0           # 004c7140
    mov dword ptr [ebp - local_28], 0x0          # 004c7147
    jmp.d8 L_004c7159                            # 004c714e
L_004c7150:
    # block 0x004c7150: entered by jmp at 0x004c71b1, 3 instruction(s), falls into the block at 0x004c7159
    mov ecx, dword ptr [ebp - local_28]          # 004c7150
    add ecx, 0x1                                 # 004c7153
    mov dword ptr [ebp - local_28], ecx          # 004c7156
L_004c7159:
    # block 0x004c7159: entered by jmp at 0x004c714e, 3 instruction(s), ends with jge to 0x004c71b3 (forward)
    movsx edx, word ptr [ebp - local_18]         # 004c7159
    cmp dword ptr [ebp - local_28], edx          # 004c715d
    jge.d8 L_004c71b3                            # 004c7160
    # block 0x004c7162: entered by fall-through of jge at 0x004c7160, 4 instruction(s), ends with forward jump to 0x004c7180
    movsx eax, word ptr [ebp - local_c]          # 004c7162
    sub eax, 0x1                                 # 004c7166
    mov dword ptr [ebp - local_30], eax          # 004c7169
    jmp.d8 L_004c7180                            # 004c716c
L_004c716e:
    # block 0x004c716e: entered by jmp at 0x004c71af, 6 instruction(s), falls into the block at 0x004c7180
    mov ecx, dword ptr [ebp - local_30]          # 004c716e
    sub ecx, 0x1                                 # 004c7171
    mov dword ptr [ebp - local_30], ecx          # 004c7174
    mov edx, dword ptr [ebp - local_4]           # 004c7177
    add edx, 0x2                                 # 004c717a
    mov dword ptr [ebp - local_4], edx           # 004c717d
L_004c7180:
    # block 0x004c7180: entered by jmp at 0x004c716c, 2 instruction(s), ends with jl to 0x004c71b1 (forward)
    cmp dword ptr [ebp - local_30], 0x0          # 004c7180
    jl.d8 L_004c71b1                             # 004c7184
    # block 0x004c7186: entered by fall-through of jl at 0x004c7184, 13 instruction(s), ends with backward jump to 0x004c716e
    movsx eax, word ptr [ebp - local_8]          # 004c7186
    mov ecx, dword ptr [ebp - local_30]          # 004c718a
    imul ecx, eax                                # 004c718d
    mov edx, dword ptr [ebp - local_1c]          # 004c7190
    {load} add edx, ecx                          # 004c7193
    movsx eax, word ptr [0x639895]               # 004c7195
    mov ecx, dword ptr [ebp - local_28]          # 004c719c
    imul ecx, eax                                # 004c719f
    mov eax, dword ptr [ebp - local_2c]          # 004c71a2
    add eax, dword ptr [ebp - local_4]           # 004c71a5
    mov cx, word ptr [edx + ecx]                 # 004c71a8
    mov word ptr [eax], cx                       # 004c71ac
    jmp.d8 L_004c716e                            # 004c71af
L_004c71b1:
    # block 0x004c71b1: entered by jl at 0x004c7184, 1 instruction(s), ends with backward jump to 0x004c7150
    jmp.d8 L_004c7150                            # 004c71b1
L_004c71b3:
    # block 0x004c71b3: entered by jge at 0x004c7160, 18 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c71f1
    mov edx, dword ptr [ebp + arg_8]             # 004c71b3
    mov ax, word ptr [ebp - local_24]            # 004c71b6
    mov word ptr [edx + field_2b], ax            # 004c71ba
    mov ecx, dword ptr [ebp + arg_8]             # 004c71be
    mov dx, word ptr [ebp - local_14]            # 004c71c1
    mov word ptr [ecx + field_2d], dx            # 004c71c5
    mov eax, dword ptr [ebp + arg_8]             # 004c71c9
    mov cx, word ptr [ebp - local_20]            # 004c71cc
    mov word ptr [eax + field_2f], cx            # 004c71d0
    mov edx, dword ptr [ebp + arg_8]             # 004c71d4
    mov ax, word ptr [ebp - local_10]            # 004c71d7
    mov word ptr [edx + field_31], ax            # 004c71db
    mov ecx, dword ptr [ebp - local_1c]          # 004c71df
    mov dword ptr [ebp - local_3c], ecx          # 004c71e2
    mov edx, dword ptr [ebp - local_3c]          # 004c71e5
    push edx                                     # 004c71e8
    call FUN_0051dc6c                            # 004c71e9
    add esp, 0x4                                 # 004c71ee
L_004c71f1:
    # block 0x004c71f1: entered by jmp at 0x004c711f, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004c71f1
    pop esi                                      # 004c71f2
    {load} mov esp, ebp                          # 004c71f3
    pop ebp                                      # 004c71f5
    ret 0x8                                      # 004c71f6

