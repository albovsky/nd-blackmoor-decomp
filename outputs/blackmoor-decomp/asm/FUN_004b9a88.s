# FUN_004b9a88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b9a88
# extent:       0x004b9a88-0x004b9dcb (835 code bytes)
# span:         0x004b9a88-0x004b9dd0 (code 835, tables 0, padding 5)
# sha256:       da4c03d95c272fc477d8d99515b34b9ed493a769f7a671bc09fa074d43efa57b
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b9a88_draw_slots
# naming:       native port src/original_methods_fl20c.c:m4b9a88_draw_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b9a88_draw_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 835 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       7 ebp-relative slot(s): local_4, local_7, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_41d, field_421, field_425; [ecx + n] field_41d, field_429; [edx + n] field_173, field_421, field_425, field_429
# callees:      calls FUN_004c5d4b, FUN_004d2c20, FUN_004b8e42, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_af5_alloc_slot (function ledger class native_oracle_verified; also native_af5_draw, native_caption_finish_tick; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 208 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_7, 0x7  # offset -0x7
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_173, 0x173  # offset +0x173
.equ field_41d, 0x41d  # offset +0x41d
.equ field_421, 0x421  # offset +0x421
.equ field_425, 0x425  # offset +0x425
.equ field_429, 0x429  # offset +0x429

# --- external targets -----------------------------------------------
.set FUN_004b8e42, .text + (0x004b8e42 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)

.org 0x004b9a88 - 0x401000
.globl FUN_004b9a88
FUN_004b9a88:
    # block 0x004b9a88: entry, 5 instruction(s), ends with jne to 0x004b9a9c (forward)
    push ebp                                     # 004b9a88
    {load} mov ebp, esp                          # 004b9a89
    sub esp, 0x18                                # 004b9a8b
    cmp dword ptr [0x61ee82], 0x0                # 004b9a8e
    jne.d8 L_004b9a9c                            # 004b9a95
    # block 0x004b9a97: entered by fall-through of jne at 0x004b9a95, 1 instruction(s), ends with forward jump to 0x004b9dc7
    jmp.d32 L_004b9dc7                           # 004b9a97
L_004b9a9c:
    # block 0x004b9a9c: entered by jne at 0x004b9a95, 2 instruction(s), ends with jne to 0x004b9ca2 (forward)
    cmp dword ptr [0x61ee8e], 0x0                # 004b9a9c
    jne.d32 L_004b9ca2                           # 004b9aa3
    # block 0x004b9aa9: entered by fall-through of jne at 0x004b9aa3, 2 instruction(s), ends with forward jump to 0x004b9abd
    mov word ptr [ebp - local_4], 0x0            # 004b9aa9
    jmp.d8 L_004b9abd                            # 004b9aaf
L_004b9ab1:
    # block 0x004b9ab1: entered by jmp at 0x004b9c98, 3 instruction(s), falls into the block at 0x004b9abd
    mov ax, word ptr [ebp - local_4]             # 004b9ab1
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b9ab5
    mov word ptr [ebp - local_4], ax             # 004b9ab9
L_004b9abd:
    # block 0x004b9abd: entered by jmp at 0x004b9aaf, 5 instruction(s), ends with jge to 0x004b9c9d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b9abd
    mov edx, dword ptr [0x61ee76]                # 004b9ac1
    movsx eax, word ptr [edx + field_173]        # 004b9ac7
    {load} cmp ecx, eax                          # 004b9ace
    jge.d32 L_004b9c9d                           # 004b9ad0
    # block 0x004b9ad6: entered by fall-through of jge at 0x004b9ad0, 4 instruction(s), ends with jne to 0x004b9b88 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b9ad6
    imul ecx, ecx, 0x37                          # 004b9ada
    cmp dword ptr [ecx + 0x61eeeb], 0x1          # 004b9add
    jne.d32 L_004b9b88                           # 004b9ae4
    # block 0x004b9aea: entered by fall-through of jne at 0x004b9ae4, 42 instruction(s), calls FUN_004c5d4b, FUN_004d2c20, ends with forward jump to 0x004b9c98
    push 0x551e54                                # 004b9aea
    movsx edx, word ptr [ebp - local_4]          # 004b9aef
    imul edx, edx, 0x37                          # 004b9af3
    add edx, 0x61eec8                            # 004b9af6
    push edx                                     # 004b9afc
    movsx eax, word ptr [ebp - local_4]          # 004b9afd
    imul eax, eax, 0x37                          # 004b9b01
    add eax, 0x61eeb8                            # 004b9b04
    push eax                                     # 004b9b09
    mov ecx, dword ptr [0x5cf665]                # 004b9b0a
    push ecx                                     # 004b9b10
    movsx edx, word ptr [0x61ee72]               # 004b9b11
    imul edx, edx, 0x4a                          # 004b9b18
    mov eax, dword ptr [edx + 0x5d1599]          # 004b9b1b
    push eax                                     # 004b9b21
    mov ecx, 0x5cf659                            # 004b9b22
    call FUN_004c5d4b                            # 004b9b27
    movsx ecx, word ptr [ebp - local_4]          # 004b9b2c
    imul ecx, ecx, 0x37                          # 004b9b30
    mov dl, byte ptr [ecx + 0x61eed8]            # 004b9b33
    mov byte ptr [ebp - local_8], dl             # 004b9b39
    mov byte ptr [ebp - local_7], 0x0            # 004b9b3c
    push 0x0                                     # 004b9b40
    mov eax, dword ptr [0x5cf665]                # 004b9b42
    push eax                                     # 004b9b47
    mov ecx, dword ptr [0x5d0357]                # 004b9b48
    push ecx                                     # 004b9b4e
    movsx edx, word ptr [ebp - local_4]          # 004b9b4f
    imul edx, edx, 0x37                          # 004b9b53
    mov ax, word ptr [edx + 0x61eedd]            # 004b9b56
    push eax                                     # 004b9b5d
    movsx ecx, word ptr [ebp - local_4]          # 004b9b5e
    imul ecx, ecx, 0x37                          # 004b9b62
    mov dx, word ptr [ecx + 0x61eed9]            # 004b9b65
    push edx                                     # 004b9b6c
    push 0x5aed5a                                # 004b9b6d
    push 0x5a9ba2                                # 004b9b72
    lea eax, [ebp - local_8]                     # 004b9b77
    push eax                                     # 004b9b7a
    call FUN_004d2c20                            # 004b9b7b
    add esp, 0x20                                # 004b9b80
    jmp.d32 L_004b9c98                           # 004b9b83
L_004b9b88:
    # block 0x004b9b88: entered by jne at 0x004b9ae4, 4 instruction(s), ends with jne to 0x004b9bec (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b9b88
    imul ecx, ecx, 0x37                          # 004b9b8c
    cmp dword ptr [ecx + 0x61eeeb], 0x2          # 004b9b8f
    jne.d8 L_004b9bec                            # 004b9b96
    # block 0x004b9b98: entered by fall-through of jne at 0x004b9b96, 21 instruction(s), calls FUN_004c5d4b, FUN_004b8e42, ends with forward jump to 0x004b9c98
    push 0x551e6c                                # 004b9b98
    movsx edx, word ptr [ebp - local_4]          # 004b9b9d
    imul edx, edx, 0x37                          # 004b9ba1
    add edx, 0x61eec8                            # 004b9ba4
    push edx                                     # 004b9baa
    mov eax, dword ptr [0x61ee76]                # 004b9bab
    add eax, 0x163                               # 004b9bb0
    push eax                                     # 004b9bb5
    mov ecx, dword ptr [0x5cf665]                # 004b9bb6
    push ecx                                     # 004b9bbc
    movsx edx, word ptr [0x61ee72]               # 004b9bbd
    imul edx, edx, 0x4a                          # 004b9bc4
    mov eax, dword ptr [edx + 0x5d1599]          # 004b9bc7
    push eax                                     # 004b9bcd
    mov ecx, 0x5cf659                            # 004b9bce
    call FUN_004c5d4b                            # 004b9bd3
    mov cx, word ptr [ebp - local_4]             # 004b9bd8
    push ecx                                     # 004b9bdc
    mov ecx, 0x61ee6e                            # 004b9bdd
    call FUN_004b8e42                            # 004b9be2
    jmp.d32 L_004b9c98                           # 004b9be7
L_004b9bec:
    # block 0x004b9bec: entered by jne at 0x004b9b96, 4 instruction(s), ends with jne to 0x004b9c98 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b9bec
    imul edx, edx, 0x37                          # 004b9bf0
    cmp dword ptr [edx + 0x61eeeb], 0x3          # 004b9bf3
    jne.d32 L_004b9c98                           # 004b9bfa
    # block 0x004b9c00: entered by fall-through of jne at 0x004b9bfa, 36 instruction(s), calls FUN_004c5377, falls into the block at 0x004b9c98
    movsx eax, word ptr [ebp - local_4]          # 004b9c00
    imul eax, eax, 0x37                          # 004b9c04
    mov ecx, dword ptr [eax + 0x61eecc]          # 004b9c07
    sub ecx, dword ptr [0x58318a]                # 004b9c0d
    mov dword ptr [ebp - local_14], ecx          # 004b9c13
    movsx edx, word ptr [ebp - local_4]          # 004b9c16
    imul edx, edx, 0x37                          # 004b9c1a
    mov eax, dword ptr [edx + 0x61eed4]          # 004b9c1d
    sub eax, dword ptr [0x58318a]                # 004b9c23
    mov dword ptr [ebp - local_c], eax           # 004b9c29
    movsx ecx, word ptr [ebp - local_4]          # 004b9c2c
    imul ecx, ecx, 0x37                          # 004b9c30
    mov edx, dword ptr [ecx + 0x61eec8]          # 004b9c33
    sub edx, dword ptr [0x583186]                # 004b9c39
    mov dword ptr [ebp - local_18], edx          # 004b9c3f
    movsx eax, word ptr [ebp - local_4]          # 004b9c42
    imul eax, eax, 0x37                          # 004b9c46
    mov ecx, dword ptr [eax + 0x61eed0]          # 004b9c49
    sub ecx, dword ptr [0x583186]                # 004b9c4f
    mov dword ptr [ebp - local_10], ecx          # 004b9c55
    push 0x551e84                                # 004b9c58
    movsx edx, word ptr [ebp - local_4]          # 004b9c5d
    imul edx, edx, 0x37                          # 004b9c61
    add edx, 0x61eec8                            # 004b9c64
    push edx                                     # 004b9c6a
    lea eax, [ebp - local_18]                    # 004b9c6b
    push eax                                     # 004b9c6e
    mov ecx, dword ptr [0x5cf665]                # 004b9c6f
    push ecx                                     # 004b9c75
    mov edx, dword ptr [0x5d15e3]                # 004b9c76
    push edx                                     # 004b9c7c
    mov ecx, 0x5cf659                            # 004b9c7d
    call FUN_004c5377                            # 004b9c82
    movsx eax, word ptr [ebp - local_4]          # 004b9c87
    imul eax, eax, 0x37                          # 004b9c8b
    mov dword ptr [eax + 0x61eeeb], 0x0          # 004b9c8e
L_004b9c98:
    # block 0x004b9c98: entered by jmp at 0x004b9b83; jmp at 0x004b9be7; jne at 0x004b9bfa, 1 instruction(s), ends with backward jump to 0x004b9ab1
    jmp.d32 L_004b9ab1                           # 004b9c98
L_004b9c9d:
    # block 0x004b9c9d: entered by jge at 0x004b9ad0, 1 instruction(s), ends with forward jump to 0x004b9dc7
    jmp.d32 L_004b9dc7                           # 004b9c9d
L_004b9ca2:
    # block 0x004b9ca2: entered by jne at 0x004b9aa3, 2 instruction(s), ends with je to 0x004b9cdc (forward)
    cmp dword ptr [0x61eea2], 0x0                # 004b9ca2
    je.d8 L_004b9cdc                             # 004b9ca9
    # block 0x004b9cab: entered by fall-through of je at 0x004b9ca9, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004b9cdc
    push 0x551ea0                                # 004b9cab
    push 0x583186                                # 004b9cb0
    push 0x583196                                # 004b9cb5
    mov ecx, dword ptr [0x5cf665]                # 004b9cba
    push ecx                                     # 004b9cc0
    mov edx, dword ptr [0x5d15e3]                # 004b9cc1
    push edx                                     # 004b9cc7
    mov ecx, 0x5cf659                            # 004b9cc8
    call FUN_004c5377                            # 004b9ccd
    mov dword ptr [0x61eea2], 0x0                # 004b9cd2
L_004b9cdc:
    # block 0x004b9cdc: entered by je at 0x004b9ca9, 62 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004b9dc7
    mov eax, dword ptr [0x58318e]                # 004b9cdc
    sub eax, dword ptr [0x583186]                # 004b9ce1
    cdq                                          # 004b9ce7
    {load} sub eax, edx                          # 004b9ce8
    sar eax                                      # 004b9cea
    mov ecx, dword ptr [0x583186]                # 004b9cec
    {load} add ecx, eax                          # 004b9cf2
    mov edx, dword ptr [0x61ee76]                # 004b9cf4
    mov eax, dword ptr [0x61ee76]                # 004b9cfa
    mov edx, dword ptr [edx + field_425]         # 004b9cff
    sub edx, dword ptr [eax + field_41d]         # 004b9d05
    {load} mov eax, edx                          # 004b9d0b
    cdq                                          # 004b9d0d
    {load} sub eax, edx                          # 004b9d0e
    sar eax                                      # 004b9d10
    {load} sub ecx, eax                          # 004b9d12
    mov dword ptr [ebp - local_18], ecx          # 004b9d14
    mov eax, dword ptr [0x583192]                # 004b9d17
    sub eax, dword ptr [0x58318a]                # 004b9d1c
    cdq                                          # 004b9d22
    {load} sub eax, edx                          # 004b9d23
    sar eax                                      # 004b9d25
    mov ecx, dword ptr [0x58318a]                # 004b9d27
    {load} add ecx, eax                          # 004b9d2d
    mov edx, dword ptr [0x61ee76]                # 004b9d2f
    mov eax, dword ptr [0x61ee76]                # 004b9d35
    mov edx, dword ptr [edx + field_429]         # 004b9d3a
    sub edx, dword ptr [eax + field_421]         # 004b9d40
    {load} mov eax, edx                          # 004b9d46
    cdq                                          # 004b9d48
    {load} sub eax, edx                          # 004b9d49
    sar eax                                      # 004b9d4b
    {load} sub ecx, eax                          # 004b9d4d
    mov dword ptr [ebp - local_14], ecx          # 004b9d4f
    mov eax, dword ptr [0x61ee76]                # 004b9d52
    mov ecx, dword ptr [0x61ee76]                # 004b9d57
    mov edx, dword ptr [eax + field_425]         # 004b9d5d
    sub edx, dword ptr [ecx + field_41d]         # 004b9d63
    mov eax, dword ptr [ebp - local_18]          # 004b9d69
    {load} add eax, edx                          # 004b9d6c
    mov dword ptr [ebp - local_10], eax          # 004b9d6e
    mov ecx, dword ptr [0x61ee76]                # 004b9d71
    mov edx, dword ptr [0x61ee76]                # 004b9d77
    mov eax, dword ptr [ecx + field_429]         # 004b9d7d
    sub eax, dword ptr [edx + field_421]         # 004b9d83
    mov ecx, dword ptr [ebp - local_14]          # 004b9d89
    {load} add ecx, eax                          # 004b9d8c
    mov dword ptr [ebp - local_c], ecx           # 004b9d8e
    push 0x551ec0                                # 004b9d91
    lea edx, [ebp - local_18]                    # 004b9d96
    push edx                                     # 004b9d99
    mov eax, dword ptr [0x61ee76]                # 004b9d9a
    add eax, 0x41d                               # 004b9d9f
    push eax                                     # 004b9da4
    mov ecx, dword ptr [0x5cf665]                # 004b9da5
    push ecx                                     # 004b9dab
    movsx edx, word ptr [0x61ee72]               # 004b9dac
    imul edx, edx, 0x4a                          # 004b9db3
    mov eax, dword ptr [edx + 0x5d1599]          # 004b9db6
    push eax                                     # 004b9dbc
    mov ecx, 0x5cf659                            # 004b9dbd
    call FUN_004c5d4b                            # 004b9dc2
L_004b9dc7:
    # block 0x004b9dc7: entered by jmp at 0x004b9a97; jmp at 0x004b9c9d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b9dc7
    pop ebp                                      # 004b9dc9
    ret                                          # 004b9dca

# --- data items (not part of the function) -------------------------
.org 0x004b9dcb - 0x401000
PAD_004b9dcb:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

