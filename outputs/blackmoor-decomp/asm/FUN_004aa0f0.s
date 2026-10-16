# FUN_004aa0f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aa0f0
# extent:       0x004aa0f0-0x004aa3d2 (738 code bytes)
# span:         0x004aa0f0-0x004aa3d2 (code 738, tables 0, padding 0)
# sha256:       e69b56ff071b5f658e0f4fefdf6168cd0c6185728f01cd074a4197ec71836ab5
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aa0f0
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_21, field_23, field_2b, field_45, field_eb, field_ef, field_109, field_10d, field_111, field_115; [ecx + n] field_25, field_e7, field_f7, field_245, field_249, field_24d, field_251; [edx + n] field_23, field_f3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 154 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_2b, 0x2b  # offset +0x2b
.equ field_45, 0x45  # offset +0x45
.equ field_e7, 0xe7  # offset +0xe7
.equ field_eb, 0xeb  # offset +0xeb
.equ field_ef, 0xef  # offset +0xef
.equ field_f3, 0xf3  # offset +0xf3
.equ field_f7, 0xf7  # offset +0xf7
.equ field_109, 0x109  # offset +0x109
.equ field_10d, 0x10d  # offset +0x10d
.equ field_111, 0x111  # offset +0x111
.equ field_115, 0x115  # offset +0x115
.equ field_245, 0x245  # offset +0x245
.equ field_249, 0x249  # offset +0x249
.equ field_24d, 0x24d  # offset +0x24d
.equ field_251, 0x251  # offset +0x251

# --- external targets -----------------------------------------------

.org 0x004aa0f0 - 0x401000
.globl FUN_004aa0f0
FUN_004aa0f0:
    # block 0x004aa0f0: entry, 14 instruction(s), ends with je to 0x004aa3ca (forward)
    push ebp                                     # 004aa0f0
    {load} mov ebp, esp                          # 004aa0f1
    sub esp, 0xc                                 # 004aa0f3
    mov dword ptr [ebp - local_c], ecx           # 004aa0f6
    mov eax, dword ptr [ebp - local_c]           # 004aa0f9
    movsx ecx, word ptr [eax + field_21]         # 004aa0fc
    imul ecx, ecx, 0x8d                          # 004aa100
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004aa106
    mov dword ptr [ebp - local_8], edx           # 004aa10c
    mov eax, dword ptr [ebp - local_c]           # 004aa10f
    {load} xor ecx, ecx                          # 004aa112
    mov cl, byte ptr [eax + field_45]            # 004aa114
    test ecx, ecx                                # 004aa117
    je.d32 L_004aa3ca                            # 004aa119
    # block 0x004aa11f: entered by fall-through of je at 0x004aa119, 4 instruction(s), ends with jl to 0x004aa1bb (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004aa11f
    mov eax, dword ptr [ebp - local_8]           # 004aa123
    cmp edx, dword ptr [eax + field_eb]          # 004aa126
    jl.d32 L_004aa1bb                            # 004aa12c
    # block 0x004aa132: entered by fall-through of jl at 0x004aa12c, 4 instruction(s), ends with jg to 0x004aa1bb (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004aa132
    mov edx, dword ptr [ebp - local_8]           # 004aa136
    cmp ecx, dword ptr [edx + field_f3]          # 004aa139
    jg.d8 L_004aa1bb                             # 004aa13f
    # block 0x004aa141: entered by fall-through of jg at 0x004aa13f, 4 instruction(s), ends with jl to 0x004aa1bb (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004aa141
    mov ecx, dword ptr [ebp - local_8]           # 004aa145
    cmp eax, dword ptr [ecx + field_e7]          # 004aa148
    jl.d8 L_004aa1bb                             # 004aa14e
    # block 0x004aa150: entered by fall-through of jl at 0x004aa14e, 4 instruction(s), ends with jg to 0x004aa1bb (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004aa150
    mov eax, dword ptr [ebp - local_8]           # 004aa154
    cmp edx, dword ptr [eax + field_ef]          # 004aa157
    jg.d8 L_004aa1bb                             # 004aa15d
    # block 0x004aa15f: entered by fall-through of jg at 0x004aa15d, 14 instruction(s), ends with forward jump to 0x004aa3cc
    mov dword ptr [0x5b44f0], 0x9                # 004aa15f
    mov dword ptr [0x5b44f4], 0x1                # 004aa169
    mov ecx, dword ptr [0x5d0377]                # 004aa173
    mov dword ptr [0x5d162d], ecx                # 004aa179
    mov edx, dword ptr [0x5b44f0]                # 004aa17f
    shl edx, 0x5                                 # 004aa185
    mov eax, dword ptr [0x5b44f4]                # 004aa188
    shl eax, 0x4                                 # 004aa18d
    lea ecx, [edx + eax + 0x5b160c]              # 004aa190
    mov dword ptr [0x5d1631], ecx                # 004aa197
    mov dword ptr [0x5d1639], 0x1                # 004aa19d
    mov dword ptr [0x5c39e5], 0x2771             # 004aa1a7
    mov eax, 0x1                                 # 004aa1b1
    jmp.d32 L_004aa3cc                           # 004aa1b6
L_004aa1bb:
    # block 0x004aa1bb: entered by jl at 0x004aa12c; jg at 0x004aa13f; jl at 0x004aa14e; jg at 0x004aa15d, 2 instruction(s), ends with forward jump to 0x004aa1cf
    mov word ptr [ebp - local_4], 0x0            # 004aa1bb
    jmp.d8 L_004aa1cf                            # 004aa1c1
L_004aa1c3:
    # block 0x004aa1c3: entered by jmp at 0x004aa3c5, 3 instruction(s), falls into the block at 0x004aa1cf
    mov dx, word ptr [ebp - local_4]             # 004aa1c3
    add dx, 0x1                                  # 004aa1c7
    mov word ptr [ebp - local_4], dx             # 004aa1cb
L_004aa1cf:
    # block 0x004aa1cf: entered by jmp at 0x004aa1c1, 5 instruction(s), ends with jge to 0x004aa3ca (forward)
    movsx eax, word ptr [ebp - local_4]          # 004aa1cf
    mov ecx, dword ptr [ebp - local_8]           # 004aa1d3
    movsx edx, word ptr [ecx + field_f7]         # 004aa1d6
    {load} cmp eax, edx                          # 004aa1dd
    jge.d32 L_004aa3ca                           # 004aa1df
    # block 0x004aa1e5: entered by fall-through of jge at 0x004aa1df, 5 instruction(s), ends with je to 0x004aa2e4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004aa1e5
    {load} xor ecx, ecx                          # 004aa1e8
    mov cl, byte ptr [eax + field_2b]            # 004aa1ea
    test ecx, ecx                                # 004aa1ed
    je.d32 L_004aa2e4                            # 004aa1ef
    # block 0x004aa1f5: entered by fall-through of je at 0x004aa1ef, 5 instruction(s), ends with jne to 0x004aa2e4 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004aa1f5
    {load} xor eax, eax                          # 004aa1f9
    mov al, byte ptr [edx + 0x630a60]            # 004aa1fb
    test eax, eax                                # 004aa201
    jne.d32 L_004aa2e4                           # 004aa203
    # block 0x004aa209: entered by fall-through of jne at 0x004aa203, 6 instruction(s), ends with jl to 0x004aa2e4 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004aa209
    movsx edx, word ptr [ebp - local_4]          # 004aa20d
    imul edx, edx, 0x15c                         # 004aa211
    mov eax, dword ptr [ebp - local_8]           # 004aa217
    cmp ecx, dword ptr [eax + edx + field_10d]   # 004aa21a
    jl.d32 L_004aa2e4                            # 004aa221
    # block 0x004aa227: entered by fall-through of jl at 0x004aa221, 6 instruction(s), ends with jg to 0x004aa2e4 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004aa227
    movsx edx, word ptr [ebp - local_4]          # 004aa22b
    imul edx, edx, 0x15c                         # 004aa22f
    mov eax, dword ptr [ebp - local_8]           # 004aa235
    cmp ecx, dword ptr [eax + edx + field_115]   # 004aa238
    jg.d32 L_004aa2e4                            # 004aa23f
    # block 0x004aa245: entered by fall-through of jg at 0x004aa23f, 6 instruction(s), ends with jl to 0x004aa2e4 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004aa245
    movsx edx, word ptr [ebp - local_4]          # 004aa249
    imul edx, edx, 0x15c                         # 004aa24d
    mov eax, dword ptr [ebp - local_8]           # 004aa253
    cmp ecx, dword ptr [eax + edx + field_109]   # 004aa256
    jl.d32 L_004aa2e4                            # 004aa25d
    # block 0x004aa263: entered by fall-through of jl at 0x004aa25d, 6 instruction(s), ends with jg to 0x004aa2e4 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004aa263
    movsx edx, word ptr [ebp - local_4]          # 004aa267
    imul edx, edx, 0x15c                         # 004aa26b
    mov eax, dword ptr [ebp - local_8]           # 004aa271
    cmp ecx, dword ptr [eax + edx + field_111]   # 004aa274
    jg.d8 L_004aa2e4                             # 004aa27b
    # block 0x004aa27d: entered by fall-through of jg at 0x004aa27b, 17 instruction(s), ends with forward jump to 0x004aa3cc
    mov dword ptr [0x5b44f0], 0x16               # 004aa27d
    mov dword ptr [0x5b44f4], 0x1                # 004aa287
    mov ecx, dword ptr [0x5d0377]                # 004aa291
    mov dword ptr [0x5d162d], ecx                # 004aa297
    mov edx, dword ptr [0x5b44f0]                # 004aa29d
    shl edx, 0x5                                 # 004aa2a3
    mov eax, dword ptr [0x5b44f4]                # 004aa2a6
    shl eax, 0x4                                 # 004aa2ab
    lea ecx, [edx + eax + 0x5b160c]              # 004aa2ae
    mov dword ptr [0x5d1631], ecx                # 004aa2b5
    mov dword ptr [0x5d1639], 0x1                # 004aa2bb
    mov dword ptr [0x5c39e5], 0x276f             # 004aa2c5
    mov edx, dword ptr [ebp - local_c]           # 004aa2cf
    mov ax, word ptr [ebp - local_4]             # 004aa2d2
    mov word ptr [edx + field_23], ax            # 004aa2d6
    mov eax, 0x1                                 # 004aa2da
    jmp.d32 L_004aa3cc                           # 004aa2df
L_004aa2e4:
    # block 0x004aa2e4: entered by je at 0x004aa1ef; jne at 0x004aa203; jl at 0x004aa221; jg at 0x004aa23f; more, 3 instruction(s), ends with je to 0x004aa3c5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004aa2e4
    cmp dword ptr [ecx + field_25], 0x2          # 004aa2e7
    je.d32 L_004aa3c5                            # 004aa2eb
    # block 0x004aa2f1: entered by fall-through of je at 0x004aa2eb, 6 instruction(s), ends with jl to 0x004aa3c5 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004aa2f1
    movsx eax, word ptr [ebp - local_4]          # 004aa2f5
    imul eax, eax, 0x15c                         # 004aa2f9
    mov ecx, dword ptr [ebp - local_8]           # 004aa2ff
    cmp edx, dword ptr [ecx + eax + field_249]   # 004aa302
    jl.d32 L_004aa3c5                            # 004aa309
    # block 0x004aa30f: entered by fall-through of jl at 0x004aa309, 6 instruction(s), ends with jg to 0x004aa3c5 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004aa30f
    movsx eax, word ptr [ebp - local_4]          # 004aa313
    imul eax, eax, 0x15c                         # 004aa317
    mov ecx, dword ptr [ebp - local_8]           # 004aa31d
    cmp edx, dword ptr [ecx + eax + field_251]   # 004aa320
    jg.d32 L_004aa3c5                            # 004aa327
    # block 0x004aa32d: entered by fall-through of jg at 0x004aa327, 6 instruction(s), ends with jl to 0x004aa3c5 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004aa32d
    movsx eax, word ptr [ebp - local_4]          # 004aa331
    imul eax, eax, 0x15c                         # 004aa335
    mov ecx, dword ptr [ebp - local_8]           # 004aa33b
    cmp edx, dword ptr [ecx + eax + field_245]   # 004aa33e
    jl.d8 L_004aa3c5                             # 004aa345
    # block 0x004aa347: entered by fall-through of jl at 0x004aa345, 6 instruction(s), ends with jg to 0x004aa3c5 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004aa347
    movsx eax, word ptr [ebp - local_4]          # 004aa34b
    imul eax, eax, 0x15c                         # 004aa34f
    mov ecx, dword ptr [ebp - local_8]           # 004aa355
    cmp edx, dword ptr [ecx + eax + field_24d]   # 004aa358
    jg.d8 L_004aa3c5                             # 004aa35f
    # block 0x004aa361: entered by fall-through of jg at 0x004aa35f, 17 instruction(s), ends with forward jump to 0x004aa3cc
    mov dword ptr [0x5b44f0], 0x16               # 004aa361
    mov dword ptr [0x5b44f4], 0x1                # 004aa36b
    mov edx, dword ptr [0x5d0377]                # 004aa375
    mov dword ptr [0x5d162d], edx                # 004aa37b
    mov eax, dword ptr [0x5b44f0]                # 004aa381
    shl eax, 0x5                                 # 004aa386
    mov ecx, dword ptr [0x5b44f4]                # 004aa389
    shl ecx, 0x4                                 # 004aa38f
    lea edx, [eax + ecx + 0x5b160c]              # 004aa392
    mov dword ptr [0x5d1631], edx                # 004aa399
    mov dword ptr [0x5d1639], 0x1                # 004aa39f
    mov dword ptr [0x5c39e5], 0x2770             # 004aa3a9
    mov eax, dword ptr [ebp - local_c]           # 004aa3b3
    mov cx, word ptr [ebp - local_4]             # 004aa3b6
    mov word ptr [eax + field_23], cx            # 004aa3ba
    mov eax, 0x1                                 # 004aa3be
    jmp.d8 L_004aa3cc                            # 004aa3c3
L_004aa3c5:
    # block 0x004aa3c5: entered by je at 0x004aa2eb; jl at 0x004aa309; jg at 0x004aa327; jl at 0x004aa345; jg at 0x004aa35f, 1 instruction(s), ends with backward jump to 0x004aa1c3
    jmp.d32 L_004aa1c3                           # 004aa3c5
L_004aa3ca:
    # block 0x004aa3ca: entered by je at 0x004aa119; jge at 0x004aa1df, 1 instruction(s), falls into the block at 0x004aa3cc
    {load} xor eax, eax                          # 004aa3ca
L_004aa3cc:
    # block 0x004aa3cc: entered by jmp at 0x004aa1b6; jmp at 0x004aa2df; jmp at 0x004aa3c3, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004aa3cc
    pop ebp                                      # 004aa3ce
    ret 0x8                                      # 004aa3cf

