# FUN_0041a336
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a336
# extent:       0x0041a336-0x0041a471 (315 code bytes)
# span:         0x0041a336-0x0041a480 (code 315, tables 0, padding 15)
# sha256:       c97a6ea1890c3dcc2eeaf1ab46d429874d476e12af461679055da2c2880ab48a
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a336_lifted
# naming:       native port src/original_methods_fl40.c:m41a336_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 75/75 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_45, field_5c0, field_dc4; [ecx + n] field_57f, field_5c0, field_dc8; [edx + n] field_57f, field_dc4; [esi + n] field_5a0
# callees:      calls FUN_0051dc6c, FUN_0050cee4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41a336_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_45, 0x45  # offset +0x45
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5a0, 0x5a0  # offset +0x5a0
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_dc4, 0xdc4  # offset +0xdc4
.equ field_dc8, 0xdc8  # offset +0xdc8

# --- external targets -----------------------------------------------
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041a336 - 0x401000
.globl FUN_0041a336
FUN_0041a336:
    # block 0x0041a336: entry, 22 instruction(s), ends with je to 0x0041a3c5 (forward)
    push ebp                                     # 0041a336
    {load} mov ebp, esp                          # 0041a337
    sub esp, 0xc                                 # 0041a339
    push esi                                     # 0041a33c
    push edi                                     # 0041a33d
    mov dword ptr [ebp - local_c], ecx           # 0041a33e
    movsx eax, word ptr [ebp + arg_8]            # 0041a341
    imul eax, eax, 0x84d                         # 0041a345
    mov ecx, dword ptr [ebp - local_c]           # 0041a34b
    mov byte ptr [ecx + eax + field_57f], 0x0    # 0041a34e
    mov ecx, 0x8                                 # 0041a356
    {load} xor eax, eax                          # 0041a35b
    movsx edx, word ptr [ebp + arg_8]            # 0041a35d
    imul edx, edx, 0x84d                         # 0041a361
    mov esi, dword ptr [ebp - local_c]           # 0041a367
    lea edi, [esi + edx + field_5a0]             # 0041a36a
    rep stosd dword ptr es:[edi], eax            # 0041a371
    movsx eax, word ptr [ebp + arg_8]            # 0041a373
    imul eax, eax, 0x84d                         # 0041a377
    mov ecx, dword ptr [ebp - local_c]           # 0041a37d
    cmp dword ptr [ecx + eax + field_5c0], 0x0   # 0041a380
    je.d8 L_0041a3c5                             # 0041a388
    # block 0x0041a38a: entered by fall-through of je at 0x0041a388, 13 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041a3c5
    movsx edx, word ptr [ebp + arg_8]            # 0041a38a
    imul edx, edx, 0x84d                         # 0041a38e
    mov eax, dword ptr [ebp - local_c]           # 0041a394
    mov ecx, dword ptr [eax + edx + field_5c0]   # 0041a397
    mov dword ptr [ebp - local_8], ecx           # 0041a39e
    mov edx, dword ptr [ebp - local_8]           # 0041a3a1
    push edx                                     # 0041a3a4
    call FUN_0051dc6c                            # 0041a3a5
    add esp, 0x4                                 # 0041a3aa
    movsx eax, word ptr [ebp + arg_8]            # 0041a3ad
    imul eax, eax, 0x84d                         # 0041a3b1
    mov ecx, dword ptr [ebp - local_c]           # 0041a3b7
    mov dword ptr [ecx + eax + field_5c0], 0x0   # 0041a3ba
L_0041a3c5:
    # block 0x0041a3c5: entered by je at 0x0041a388, 2 instruction(s), ends with forward jump to 0x0041a3d9
    mov word ptr [ebp - local_4], 0x0            # 0041a3c5
    jmp.d8 L_0041a3d9                            # 0041a3cb
L_0041a3cd:
    # block 0x0041a3cd: entered by jmp at 0x0041a403, 3 instruction(s), falls into the block at 0x0041a3d9
    mov dx, word ptr [ebp - local_4]             # 0041a3cd
    add dx, 0x1                                  # 0041a3d1
    mov word ptr [ebp - local_4], dx             # 0041a3d5
L_0041a3d9:
    # block 0x0041a3d9: entered by jmp at 0x0041a3cb, 3 instruction(s), ends with jge to 0x0041a405 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041a3d9
    cmp eax, 0x400                               # 0041a3dd
    jge.d8 L_0041a405                            # 0041a3e2
    # block 0x0041a3e4: entered by fall-through of jge at 0x0041a3e2, 7 instruction(s), ends with backward jump to 0x0041a3cd
    movsx ecx, word ptr [ebp + arg_8]            # 0041a3e4
    imul ecx, ecx, 0x84d                         # 0041a3e8
    mov edx, dword ptr [ebp - local_c]           # 0041a3ee
    lea eax, [edx + ecx + field_57f]             # 0041a3f1
    movsx ecx, word ptr [ebp - local_4]          # 0041a3f8
    mov word ptr [eax + 2*ecx + field_45], 0xffff # 0041a3fc
    jmp.d8 L_0041a3cd                            # 0041a403
L_0041a405:
    # block 0x0041a405: entered by jge at 0x0041a3e2, 5 instruction(s), ends with je to 0x0041a451 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0041a405
    imul edx, edx, 0x84d                         # 0041a409
    mov eax, dword ptr [ebp - local_c]           # 0041a40f
    cmp dword ptr [eax + edx + field_dc4], 0x0   # 0041a412
    je.d8 L_0041a451                             # 0041a41a
    # block 0x0041a41c: entered by fall-through of je at 0x0041a41a, 11 instruction(s), calls FUN_0050cee4, falls into the block at 0x0041a451
    movsx ecx, word ptr [ebp + arg_8]            # 0041a41c
    imul ecx, ecx, 0x84d                         # 0041a420
    mov edx, dword ptr [ebp - local_c]           # 0041a426
    mov eax, dword ptr [edx + ecx + field_dc4]   # 0041a429
    push eax                                     # 0041a430
    call FUN_0050cee4                            # 0041a431
    add esp, 0x4                                 # 0041a436
    movsx ecx, word ptr [ebp + arg_8]            # 0041a439
    imul ecx, ecx, 0x84d                         # 0041a43d
    mov edx, dword ptr [ebp - local_c]           # 0041a443
    mov dword ptr [edx + ecx + field_dc4], 0x0   # 0041a446
L_0041a451:
    # block 0x0041a451: entered by je at 0x0041a41a, 9 instruction(s), ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 0041a451
    imul eax, eax, 0x84d                         # 0041a455
    mov ecx, dword ptr [ebp - local_c]           # 0041a45b
    mov dword ptr [ecx + eax + field_dc8], 0x0   # 0041a45e
    pop edi                                      # 0041a469
    pop esi                                      # 0041a46a
    {load} mov esp, ebp                          # 0041a46b
    pop ebp                                      # 0041a46d
    ret 0x4                                      # 0041a46e

# --- data items (not part of the function) -------------------------
.org 0x0041a471 - 0x401000
PAD_0041a471:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

