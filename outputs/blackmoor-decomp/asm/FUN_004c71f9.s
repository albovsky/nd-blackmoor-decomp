# FUN_004c71f9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c71f9
# extent:       0x004c71f9-0x004c7314 (283 code bytes)
# span:         0x004c71f9-0x004c7314 (code 283, tables 0, padding 0)
# sha256:       d8985d260e399e9da6f1956ec9a258c595ead5e3f9d25c241521fea26173e7a8
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c71f9_lifted
# naming:       native port src/original_methods_fl41.c:m4c71f9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 93/93 instructions, 6/6 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0042639d, FUN_004c97b4, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4c71f9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 93 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c71f9 - 0x401000
.globl FUN_004c71f9
FUN_004c71f9:
    # block 0x004c71f9: entry, 26 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c7268 (forward)
    push ebp                                     # 004c71f9
    {load} mov ebp, esp                          # 004c71fa
    sub esp, 0x28                                # 004c71fc
    push esi                                     # 004c71ff
    push edi                                     # 004c7200
    mov dword ptr [ebp - local_28], ecx          # 004c7201
    mov dword ptr [ebp - local_8], 0x0           # 004c7204
    mov eax, dword ptr [ebp + arg_c]             # 004c720b
    mov cx, word ptr [eax]                       # 004c720e
    mov word ptr [ebp - local_4], cx             # 004c7211
    mov edx, dword ptr [ebp + arg_10]            # 004c7215
    mov ax, word ptr [edx]                       # 004c7218
    mov word ptr [ebp - local_c], ax             # 004c721b
    movsx ecx, word ptr [ebp - local_4]          # 004c721f
    movsx edx, word ptr [ebp - local_c]          # 004c7223
    imul ecx, edx                                # 004c7227
    mov dword ptr [ebp - local_1c], ecx          # 004c722a
    mov eax, dword ptr [ebp - local_1c]          # 004c722d
    push eax                                     # 004c7230
    call FUN_0051dc43                            # 004c7231
    add esp, 0x4                                 # 004c7236
    mov dword ptr [ebp - local_20], eax          # 004c7239
    mov ecx, dword ptr [ebp - local_20]          # 004c723c
    mov dword ptr [ebp - local_8], ecx           # 004c723f
    cmp dword ptr [ebp - local_8], 0x0           # 004c7242
    jne.d8 L_004c7268                            # 004c7246
    # block 0x004c7248: entered by fall-through of jne at 0x004c7246, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c730c
    mov edx, dword ptr [ebp + arg_14]            # 004c7248
    push edx                                     # 004c724b
    push 0x555348                                # 004c724c
    mov ecx, 0x583979                            # 004c7251
    call FUN_0042639d                            # 004c7256
    mov ecx, dword ptr [ebp - local_28]          # 004c725b
    call FUN_004c97b4                            # 004c725e
    jmp.d32 L_004c730c                           # 004c7263
L_004c7268:
    # block 0x004c7268: entered by jne at 0x004c7246, 12 instruction(s), ends with forward jump to 0x004c7298
    mov ecx, dword ptr [ebp - local_1c]          # 004c7268
    mov esi, dword ptr [ebp + arg_8]             # 004c726b
    mov edi, dword ptr [ebp - local_8]           # 004c726e
    {load} mov eax, ecx                          # 004c7271
    shr ecx, 0x2                                 # 004c7273
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c7276
    {load} mov ecx, eax                          # 004c7278
    and ecx, 0x3                                 # 004c727a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c727d
    mov dword ptr [ebp - local_18], 0x0          # 004c727f
    mov dword ptr [ebp - local_10], 0x0          # 004c7286
    jmp.d8 L_004c7298                            # 004c728d
L_004c728f:
    # block 0x004c728f: entered by jmp at 0x004c72e4, 3 instruction(s), falls into the block at 0x004c7298
    mov ecx, dword ptr [ebp - local_10]          # 004c728f
    add ecx, 0x1                                 # 004c7292
    mov dword ptr [ebp - local_10], ecx          # 004c7295
L_004c7298:
    # block 0x004c7298: entered by jmp at 0x004c728d, 3 instruction(s), ends with jge to 0x004c72e6 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004c7298
    cmp dword ptr [ebp - local_10], edx          # 004c729c
    jge.d8 L_004c72e6                            # 004c729f
    # block 0x004c72a1: entered by fall-through of jge at 0x004c729f, 4 instruction(s), ends with forward jump to 0x004c72bf
    movsx eax, word ptr [ebp - local_c]          # 004c72a1
    sub eax, 0x1                                 # 004c72a5
    mov dword ptr [ebp - local_14], eax          # 004c72a8
    jmp.d8 L_004c72bf                            # 004c72ab
L_004c72ad:
    # block 0x004c72ad: entered by jmp at 0x004c72e2, 6 instruction(s), falls into the block at 0x004c72bf
    mov ecx, dword ptr [ebp - local_14]          # 004c72ad
    sub ecx, 0x1                                 # 004c72b0
    mov dword ptr [ebp - local_14], ecx          # 004c72b3
    mov edx, dword ptr [ebp - local_18]          # 004c72b6
    add edx, 0x1                                 # 004c72b9
    mov dword ptr [ebp - local_18], edx          # 004c72bc
L_004c72bf:
    # block 0x004c72bf: entered by jmp at 0x004c72ab, 2 instruction(s), ends with jl to 0x004c72e4 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 004c72bf
    jl.d8 L_004c72e4                             # 004c72c3
    # block 0x004c72c5: entered by fall-through of jl at 0x004c72c3, 11 instruction(s), ends with backward jump to 0x004c72ad
    movsx eax, word ptr [ebp - local_4]          # 004c72c5
    mov ecx, dword ptr [ebp - local_14]          # 004c72c9
    imul ecx, eax                                # 004c72cc
    mov edx, dword ptr [ebp - local_8]           # 004c72cf
    {load} add edx, ecx                          # 004c72d2
    mov eax, dword ptr [ebp + arg_8]             # 004c72d4
    add eax, dword ptr [ebp - local_18]          # 004c72d7
    mov ecx, dword ptr [ebp - local_10]          # 004c72da
    mov dl, byte ptr [edx + ecx]                 # 004c72dd
    mov byte ptr [eax], dl                       # 004c72e0
    jmp.d8 L_004c72ad                            # 004c72e2
L_004c72e4:
    # block 0x004c72e4: entered by jl at 0x004c72c3, 1 instruction(s), ends with backward jump to 0x004c728f
    jmp.d8 L_004c728f                            # 004c72e4
L_004c72e6:
    # block 0x004c72e6: entered by jge at 0x004c729f, 12 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c730c
    mov eax, dword ptr [ebp + arg_c]             # 004c72e6
    mov cx, word ptr [ebp - local_c]             # 004c72e9
    mov word ptr [eax], cx                       # 004c72ed
    mov edx, dword ptr [ebp + arg_10]            # 004c72f0
    mov ax, word ptr [ebp - local_4]             # 004c72f3
    mov word ptr [edx], ax                       # 004c72f7
    mov ecx, dword ptr [ebp - local_8]           # 004c72fa
    mov dword ptr [ebp - local_24], ecx          # 004c72fd
    mov edx, dword ptr [ebp - local_24]          # 004c7300
    push edx                                     # 004c7303
    call FUN_0051dc6c                            # 004c7304
    add esp, 0x4                                 # 004c7309
L_004c730c:
    # block 0x004c730c: entered by jmp at 0x004c7263, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004c730c
    pop esi                                      # 004c730d
    {load} mov esp, ebp                          # 004c730e
    pop ebp                                      # 004c7310
    ret 0x10                                     # 004c7311

