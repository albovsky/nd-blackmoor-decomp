# FUN_0041a216
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a216
# extent:       0x0041a216-0x0041a2e9 (211 code bytes)
# span:         0x0041a216-0x0041a2e9 (code 211, tables 0, padding 0)
# sha256:       2f55d19e3d539375c4e3b812659dd79b5eeaa012f53f1976027713ee7f13edb2
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a216_lifted
# naming:       native port src/original_methods_fl40.c:m41a216_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 9 seeds; oracle 69/69 instructions, 14/14 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_11, local_12, local_18, local_1c
# fields:       [eax + n] field_1; [ecx + n] field_1, field_57f
# callees:      calls FUN_0050d0bc
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41a216_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_11, 0x11  # offset -0x11
.equ local_12, 0x12  # offset -0x12
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_57f, 0x57f  # offset +0x57f

# --- external targets -----------------------------------------------
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)

.org 0x0041a216 - 0x401000
.globl FUN_0041a216
FUN_0041a216:
    # block 0x0041a216: entry, 13 instruction(s), ends with jne to 0x0041a23c (forward)
    push ebp                                     # 0041a216
    {load} mov ebp, esp                          # 0041a217
    sub esp, 0x1c                                # 0041a219
    push edi                                     # 0041a21c
    mov dword ptr [ebp - local_8], ecx           # 0041a21d
    mov edi, dword ptr [ebp + arg_8]             # 0041a220
    or ecx, -0x1                                 # 0041a223
    {load} xor eax, eax                          # 0041a226
    repne scasb al, byte ptr es:[edi]            # 0041a228
    not ecx                                      # 0041a22a
    add ecx, -0x1                                # 0041a22c
    test ecx, ecx                                # 0041a22f
    jne.d8 L_0041a23c                            # 0041a231
    # block 0x0041a233: entered by fall-through of jne at 0x0041a231, 2 instruction(s), ends with forward jump to 0x0041a2e2
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041a233
    jmp.d32 L_0041a2e2                           # 0041a237
L_0041a23c:
    # block 0x0041a23c: entered by jne at 0x0041a231, 6 instruction(s), calls FUN_0050d0bc, ends with forward jump to 0x0041a25c
    mov eax, dword ptr [ebp + arg_8]             # 0041a23c
    push eax                                     # 0041a23f
    call FUN_0050d0bc                            # 0041a240
    add esp, 0x4                                 # 0041a245
    mov word ptr [ebp - local_4], 0x0            # 0041a248
    jmp.d8 L_0041a25c                            # 0041a24e
L_0041a250:
    # block 0x0041a250: entered by jmp at 0x0041a2d9, 3 instruction(s), falls into the block at 0x0041a25c
    mov cx, word ptr [ebp - local_4]             # 0041a250
    add cx, 0x1                                  # 0041a254
    mov word ptr [ebp - local_4], cx             # 0041a258
L_0041a25c:
    # block 0x0041a25c: entered by jmp at 0x0041a24e, 3 instruction(s), ends with jge to 0x0041a2de (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041a25c
    cmp edx, 0x1e                                # 0041a260
    jge.d8 L_0041a2de                            # 0041a263
    # block 0x0041a265: entered by fall-through of jge at 0x0041a263, 7 instruction(s), falls into the block at 0x0041a282
    movsx eax, word ptr [ebp - local_4]          # 0041a265
    imul eax, eax, 0x84d                         # 0041a269
    mov ecx, dword ptr [ebp - local_8]           # 0041a26f
    lea edx, [ecx + eax + field_57f]             # 0041a272
    mov dword ptr [ebp - local_c], edx           # 0041a279
    mov eax, dword ptr [ebp + arg_8]             # 0041a27c
    mov dword ptr [ebp - local_10], eax          # 0041a27f
L_0041a282:
    # block 0x0041a282: entered by jne at 0x0041a2b4, 6 instruction(s), ends with jne to 0x0041a2bf (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0041a282
    mov dl, byte ptr [ecx]                       # 0041a285
    mov byte ptr [ebp - local_11], dl            # 0041a287
    mov eax, dword ptr [ebp - local_c]           # 0041a28a
    cmp dl, byte ptr [eax]                       # 0041a28d
    jne.d8 L_0041a2bf                            # 0041a28f
    # block 0x0041a291: entered by fall-through of jne at 0x0041a28f, 2 instruction(s), ends with je to 0x0041a2b6 (forward)
    cmp byte ptr [ebp - local_11], 0x0           # 0041a291
    je.d8 L_0041a2b6                             # 0041a295
    # block 0x0041a297: entered by fall-through of je at 0x0041a295, 6 instruction(s), ends with jne to 0x0041a2bf (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0041a297
    mov dl, byte ptr [ecx + field_1]             # 0041a29a
    mov byte ptr [ebp - local_12], dl            # 0041a29d
    mov eax, dword ptr [ebp - local_c]           # 0041a2a0
    cmp dl, byte ptr [eax + field_1]             # 0041a2a3
    jne.d8 L_0041a2bf                            # 0041a2a6
    # block 0x0041a2a8: entered by fall-through of jne at 0x0041a2a6, 4 instruction(s), ends with jne to 0x0041a282 (backward)
    add dword ptr [ebp - local_10], 0x2          # 0041a2a8
    add dword ptr [ebp - local_c], 0x2           # 0041a2ac
    cmp byte ptr [ebp - local_12], 0x0           # 0041a2b0
    jne.d8 L_0041a282                            # 0041a2b4
L_0041a2b6:
    # block 0x0041a2b6: entered by je at 0x0041a295; fall-through of jne at 0x0041a2b4, 2 instruction(s), ends with forward jump to 0x0041a2c7
    mov dword ptr [ebp - local_18], 0x0          # 0041a2b6
    jmp.d8 L_0041a2c7                            # 0041a2bd
L_0041a2bf:
    # block 0x0041a2bf: entered by jne at 0x0041a28f; jne at 0x0041a2a6, 3 instruction(s), falls into the block at 0x0041a2c7
    {load} sbb ecx, ecx                          # 0041a2bf
    sbb ecx, -0x1                                # 0041a2c1
    mov dword ptr [ebp - local_18], ecx          # 0041a2c4
L_0041a2c7:
    # block 0x0041a2c7: entered by jmp at 0x0041a2bd, 4 instruction(s), ends with jne to 0x0041a2d9 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0041a2c7
    mov dword ptr [ebp - local_1c], edx          # 0041a2ca
    cmp dword ptr [ebp - local_1c], 0x0          # 0041a2cd
    jne.d8 L_0041a2d9                            # 0041a2d1
    # block 0x0041a2d3: entered by fall-through of jne at 0x0041a2d1, 2 instruction(s), ends with forward jump to 0x0041a2e2
    mov ax, word ptr [ebp - local_4]             # 0041a2d3
    jmp.d8 L_0041a2e2                            # 0041a2d7
L_0041a2d9:
    # block 0x0041a2d9: entered by jne at 0x0041a2d1, 1 instruction(s), ends with backward jump to 0x0041a250
    jmp.d32 L_0041a250                           # 0041a2d9
L_0041a2de:
    # block 0x0041a2de: entered by jge at 0x0041a263, 1 instruction(s), falls into the block at 0x0041a2e2
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041a2de
L_0041a2e2:
    # block 0x0041a2e2: entered by jmp at 0x0041a237; jmp at 0x0041a2d7, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0041a2e2
    {load} mov esp, ebp                          # 0041a2e3
    pop ebp                                      # 0041a2e5
    ret 0x4                                      # 0041a2e6

