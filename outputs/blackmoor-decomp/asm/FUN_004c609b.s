# FUN_004c609b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c609b
# extent:       0x004c609b-0x004c62f0 (597 code bytes)
# span:         0x004c609b-0x004c62f0 (code 597, tables 0, padding 0)
# sha256:       9bcc465f06870a143bfcbbf58890abd61e9e44a2a3841f2040cfcf7d055fb58b
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c609b
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       17 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_68, local_7c, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 5 more
# fields:       [eax + n] field_4, field_c; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c, field_38d0
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m422a0a_draw_marked (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 173 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_38d0, 0x38d0  # offset +0x38d0

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c609b - 0x401000
.globl FUN_004c609b
FUN_004c609b:
    # block 0x004c609b: entry, 7 instruction(s), ends with je to 0x004c6195 (forward)
    push ebp                                     # 004c609b
    {load} mov ebp, esp                          # 004c609c
    sub esp, 0x1ac                               # 004c609e
    mov dword ptr [ebp - local_1ac], ecx         # 004c60a4
    movsx eax, word ptr [0x63a4cd]               # 004c60aa
    test eax, eax                                # 004c60b1
    je.d32 L_004c6195                            # 004c60b3
    # block 0x004c60b9: entered by fall-through of je at 0x004c60b3, 23 instruction(s), ends with jne to 0x004c6127 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c60b9
    mov edx, dword ptr [ebp + arg_10]            # 004c60bc
    mov eax, dword ptr [ecx + field_8]           # 004c60bf
    sub eax, dword ptr [edx]                     # 004c60c2
    mov dword ptr [ebp - local_1a8], eax         # 004c60c4
    mov ecx, dword ptr [ebp + arg_10]            # 004c60ca
    mov edx, dword ptr [ebp + arg_10]            # 004c60cd
    mov eax, dword ptr [ecx + field_c]           # 004c60d0
    sub eax, dword ptr [edx + field_4]           # 004c60d3
    mov dword ptr [ebp - local_1a4], eax         # 004c60d6
    mov ecx, dword ptr [ebp + arg_14]            # 004c60dc
    mov edx, dword ptr [ebp + arg_14]            # 004c60df
    mov eax, dword ptr [ecx + field_8]           # 004c60e2
    sub eax, dword ptr [edx]                     # 004c60e5
    mov dword ptr [ebp - local_a0], eax          # 004c60e7
    mov ecx, dword ptr [ebp + arg_14]            # 004c60ed
    mov edx, dword ptr [ebp + arg_14]            # 004c60f0
    mov eax, dword ptr [ecx + field_c]           # 004c60f3
    sub eax, dword ptr [edx + field_4]           # 004c60f6
    mov dword ptr [ebp - local_1a0], eax         # 004c60f9
    mov ecx, dword ptr [ebp - local_1a8]         # 004c60ff
    cmp ecx, dword ptr [ebp - local_a0]          # 004c6105
    jne.d8 L_004c6127                            # 004c610b
    # block 0x004c610d: entered by fall-through of jne at 0x004c610b, 3 instruction(s), ends with jne to 0x004c6127 (forward)
    mov edx, dword ptr [ebp - local_1a4]         # 004c610d
    cmp edx, dword ptr [ebp - local_1a0]         # 004c6113
    jne.d8 L_004c6127                            # 004c6119
    # block 0x004c611b: entered by fall-through of jne at 0x004c6119, 2 instruction(s), ends with je to 0x004c6127 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c611b
    je.d8 L_004c6127                             # 004c611f
    # block 0x004c6121: entered by fall-through of je at 0x004c611f, 2 instruction(s), ends with jne to 0x004c6195 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c6121
    jne.d8 L_004c6195                            # 004c6125
L_004c6127:
    # block 0x004c6127: entered by jne at 0x004c610b; jne at 0x004c6119; je at 0x004c611f; fall-through of jne at 0x004c6125, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c62ea
    mov eax, dword ptr [ebp + arg_14]            # 004c6127
    mov ecx, dword ptr [eax + field_c]           # 004c612a
    push ecx                                     # 004c612d
    mov edx, dword ptr [ebp + arg_14]            # 004c612e
    mov eax, dword ptr [edx + field_8]           # 004c6131
    push eax                                     # 004c6134
    mov ecx, dword ptr [ebp + arg_14]            # 004c6135
    mov edx, dword ptr [ecx + field_4]           # 004c6138
    push edx                                     # 004c613b
    mov eax, dword ptr [ebp + arg_14]            # 004c613c
    mov ecx, dword ptr [eax]                     # 004c613f
    push ecx                                     # 004c6141
    mov edx, dword ptr [ebp + arg_10]            # 004c6142
    mov eax, dword ptr [edx + field_c]           # 004c6145
    push eax                                     # 004c6148
    mov ecx, dword ptr [ebp + arg_10]            # 004c6149
    mov edx, dword ptr [ecx + field_8]           # 004c614c
    push edx                                     # 004c614f
    mov eax, dword ptr [ebp + arg_10]            # 004c6150
    mov ecx, dword ptr [eax + field_4]           # 004c6153
    push ecx                                     # 004c6156
    mov edx, dword ptr [ebp + arg_10]            # 004c6157
    mov eax, dword ptr [edx]                     # 004c615a
    push eax                                     # 004c615c
    mov ecx, dword ptr [ebp + arg_1c]            # 004c615d
    push ecx                                     # 004c6160
    push 0x554e50                                # 004c6161
    lea edx, [ebp - local_19c]                   # 004c6166
    push edx                                     # 004c616c
    call FUN_0050ca3e                            # 004c616d
    add esp, 0x2c                                # 004c6172
    push 0x0                                     # 004c6175
    push 0x0                                     # 004c6177
    lea eax, [ebp - local_19c]                   # 004c6179
    push eax                                     # 004c617f
    call FUN_0052139c                            # 004c6180
    mov ecx, dword ptr [ebp - local_1ac]         # 004c6185
    call FUN_004c97b4                            # 004c618b
    jmp.d32 L_004c62ea                           # 004c6190
L_004c6195:
    # block 0x004c6195: entered by je at 0x004c60b3; jne at 0x004c6125, 42 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c6232
    push 0x20                                    # 004c6195
    mov ecx, dword ptr [ebp + arg_1c]            # 004c6197
    push ecx                                     # 004c619a
    lea edx, [ebp - local_8c]                    # 004c619b
    push edx                                     # 004c61a1
    mov eax, dword ptr [ebp + arg_14]            # 004c61a2
    push eax                                     # 004c61a5
    mov ecx, dword ptr [ebp + arg_c]             # 004c61a6
    push ecx                                     # 004c61a9
    mov ecx, dword ptr [ebp - local_1ac]         # 004c61aa
    call FUN_004c4067                            # 004c61b0
    mov edx, dword ptr [ebp - local_7c]          # 004c61b5
    mov dword ptr [ebp - local_9c], edx          # 004c61b8
    mov eax, dword ptr [ebp + arg_10]            # 004c61be
    mov ecx, dword ptr [eax + field_4]           # 004c61c1
    imul ecx, dword ptr [ebp + arg_18]           # 004c61c4
    mov edx, dword ptr [ebp + arg_8]             # 004c61c8
    {load} add edx, ecx                          # 004c61cb
    movsx eax, word ptr [0x639895]               # 004c61cd
    mov ecx, dword ptr [ebp + arg_10]            # 004c61d4
    mov ecx, dword ptr [ecx]                     # 004c61d7
    imul ecx, eax                                # 004c61d9
    {load} add edx, ecx                          # 004c61dc
    mov dword ptr [ebp - local_8], edx           # 004c61de
    mov edx, dword ptr [ebp + arg_10]            # 004c61e1
    mov eax, dword ptr [ebp + arg_10]            # 004c61e4
    mov ecx, dword ptr [edx + field_c]           # 004c61e7
    sub ecx, dword ptr [eax + field_4]           # 004c61ea
    add ecx, 0x1                                 # 004c61ed
    mov dword ptr [ebp - local_90], ecx          # 004c61f0
    mov edx, dword ptr [ebp + arg_10]            # 004c61f6
    mov eax, dword ptr [ebp + arg_10]            # 004c61f9
    mov ecx, dword ptr [edx + field_8]           # 004c61fc
    sub ecx, dword ptr [eax]                     # 004c61ff
    add ecx, 0x1                                 # 004c6201
    movsx edx, word ptr [0x639895]               # 004c6204
    imul ecx, edx                                # 004c620b
    mov dword ptr [ebp - local_c], ecx           # 004c620e
    mov eax, dword ptr [ebp - local_68]          # 004c6211
    mov dword ptr [ebp - local_4], eax           # 004c6214
    mov dword ptr [ebp - local_94], 0x0          # 004c6217
    jmp.d8 L_004c6232                            # 004c6221
L_004c6223:
    # block 0x004c6223: entered by jmp at 0x004c62b0, 3 instruction(s), falls into the block at 0x004c6232
    mov ecx, dword ptr [ebp - local_94]          # 004c6223
    add ecx, 0x1                                 # 004c6229
    mov dword ptr [ebp - local_94], ecx          # 004c622c
L_004c6232:
    # block 0x004c6232: entered by jmp at 0x004c6221, 3 instruction(s), ends with jge to 0x004c62b5 (forward)
    mov edx, dword ptr [ebp - local_94]          # 004c6232
    cmp edx, dword ptr [ebp - local_90]          # 004c6238
    jge.d8 L_004c62b5                            # 004c623e
    # block 0x004c6240: entered by fall-through of jge at 0x004c623e, 2 instruction(s), ends with forward jump to 0x004c6252
    mov dword ptr [ebp - local_10], 0x0          # 004c6240
    jmp.d8 L_004c6252                            # 004c6247
L_004c6249:
    # block 0x004c6249: entered by jmp at 0x004c6299, 3 instruction(s), falls into the block at 0x004c6252
    mov eax, dword ptr [ebp - local_10]          # 004c6249
    add eax, 0x2                                 # 004c624c
    mov dword ptr [ebp - local_10], eax          # 004c624f
L_004c6252:
    # block 0x004c6252: entered by jmp at 0x004c6247, 3 instruction(s), ends with jge to 0x004c629b (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004c6252
    cmp ecx, dword ptr [ebp - local_c]           # 004c6255
    jge.d8 L_004c629b                            # 004c6258
    # block 0x004c625a: entered by fall-through of jge at 0x004c6258, 11 instruction(s), ends with je to 0x004c6299 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c625a
    add edx, dword ptr [ebp - local_10]          # 004c625d
    mov ax, word ptr [edx]                       # 004c6260
    mov word ptr [ebp - local_98], ax            # 004c6263
    mov ecx, dword ptr [ebp - local_98]          # 004c626a
    and ecx, 0xffff                              # 004c6270
    mov edx, dword ptr [ebp - local_1ac]         # 004c6276
    {load} xor eax, eax                          # 004c627c
    mov ax, word ptr [edx + field_38d0]          # 004c627e
    {load} cmp ecx, eax                          # 004c6285
    je.d8 L_004c6299                             # 004c6287
    # block 0x004c6289: entered by fall-through of je at 0x004c6287, 4 instruction(s), falls into the block at 0x004c6299
    mov ecx, dword ptr [ebp - local_4]           # 004c6289
    add ecx, dword ptr [ebp - local_10]          # 004c628c
    mov dx, word ptr [ebp - local_98]            # 004c628f
    mov word ptr [ecx], dx                       # 004c6296
L_004c6299:
    # block 0x004c6299: entered by je at 0x004c6287, 1 instruction(s), ends with backward jump to 0x004c6249
    jmp.d8 L_004c6249                            # 004c6299
L_004c629b:
    # block 0x004c629b: entered by jge at 0x004c6258, 7 instruction(s), ends with backward jump to 0x004c6223
    mov eax, dword ptr [ebp - local_8]           # 004c629b
    add eax, dword ptr [ebp + arg_18]            # 004c629e
    mov dword ptr [ebp - local_8], eax           # 004c62a1
    mov ecx, dword ptr [ebp - local_4]           # 004c62a4
    add ecx, dword ptr [ebp - local_9c]          # 004c62a7
    mov dword ptr [ebp - local_4], ecx           # 004c62ad
    jmp.d32 L_004c6223                           # 004c62b0
L_004c62b5:
    # block 0x004c62b5: entered by jge at 0x004c623e, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c62ea (forward)
    push 0x554ef8                                # 004c62b5
    mov edx, dword ptr [ebp + arg_14]            # 004c62ba
    push edx                                     # 004c62bd
    mov eax, dword ptr [ebp + arg_c]             # 004c62be
    push eax                                     # 004c62c1
    mov ecx, dword ptr [ebp - local_1ac]         # 004c62c2
    call FUN_004c4202                            # 004c62c8
    mov ecx, dword ptr [ebp - local_1ac]         # 004c62cd
    mov edx, dword ptr [ebp + arg_c]             # 004c62d3
    cmp edx, dword ptr [ecx + field_c]           # 004c62d6
    jne.d8 L_004c62ea                            # 004c62d9
    # block 0x004c62db: entered by fall-through of jne at 0x004c62d9, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c62ea
    mov eax, dword ptr [ebp + arg_14]            # 004c62db
    push eax                                     # 004c62de
    mov ecx, dword ptr [ebp - local_1ac]         # 004c62df
    call FUN_004c952f                            # 004c62e5
L_004c62ea:
    # block 0x004c62ea: entered by jmp at 0x004c6190; jne at 0x004c62d9, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004c62ea
    pop ebp                                      # 004c62ec
    ret 0x18                                     # 004c62ed

