# FUN_00463b10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463b10
# extent:       0x00463b10-0x00463ed0 (960 code bytes)
# span:         0x00463b10-0x00463f00 (code 960, tables 40, padding 8)
# sha256:       a06f0fdb31728a16e9cc6e9edee12ad3aca58f276229b4171ee36fb097eba3fa
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463b10_draw_grid
# naming:       native port src/original_methods_fl20c.c:m463b10_draw_grid (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m463b10_draw_grid. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 960 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_170, field_230; [ecx + n] field_22, field_178; [edx + n] field_24, field_d0, field_238; [esi + n] field_170
# callees:      calls FUN_004c5d4b, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20c.c:m463b10_draw_grid (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 229 instruction(s), 10 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_d0, 0xd0  # offset +0xd0
.equ field_170, 0x170  # offset +0x170
.equ field_178, 0x178  # offset +0x178
.equ field_230, 0x230  # offset +0x230
.equ field_238, 0x238  # offset +0x238

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00463b10 - 0x401000
.globl FUN_00463b10
FUN_00463b10:
    # block 0x00463b10: entry, 10 instruction(s), ends with forward jump to 0x00463b41
    push ebp                                     # 00463b10
    {load} mov ebp, esp                          # 00463b11
    sub esp, 0x20                                # 00463b13
    push esi                                     # 00463b16
    movsx eax, word ptr [0x61d797]               # 00463b17
    imul eax, eax, 0x8d                          # 00463b1e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00463b24
    mov dword ptr [ebp - local_8], ecx           # 00463b2a
    mov word ptr [ebp - local_4], 0x0            # 00463b2d
    jmp.d8 L_00463b41                            # 00463b33
L_00463b35:
    # block 0x00463b35: entered by jmp at 0x00463ec6, 3 instruction(s), falls into the block at 0x00463b41
    mov dx, word ptr [ebp - local_4]             # 00463b35
    add dx, 0x1                                  # 00463b39
    mov word ptr [ebp - local_4], dx             # 00463b3d
L_00463b41:
    # block 0x00463b41: entered by jmp at 0x00463b33, 5 instruction(s), ends with jge to 0x00463ecb (forward)
    movsx eax, word ptr [ebp - local_4]          # 00463b41
    mov ecx, dword ptr [ebp - local_8]           # 00463b45
    movsx edx, word ptr [ecx + field_22]         # 00463b48
    {load} cmp eax, edx                          # 00463b4c
    jge.d32 L_00463ecb                           # 00463b4e
    # block 0x00463b54: entered by fall-through of jge at 0x00463b4e, 2 instruction(s), ends with forward jump to 0x00463b68
    mov word ptr [ebp - local_c], 0x0            # 00463b54
    jmp.d8 L_00463b68                            # 00463b5a
L_00463b5c:
    # block 0x00463b5c: entered by jmp at 0x00463ec1, 3 instruction(s), falls into the block at 0x00463b68
    mov ax, word ptr [ebp - local_c]             # 00463b5c
    .insn 0x66, 0x05, 0x0001{:u16}               # 00463b60
    mov word ptr [ebp - local_c], ax             # 00463b64
L_00463b68:
    # block 0x00463b68: entered by jmp at 0x00463b5a, 5 instruction(s), ends with jge to 0x00463ec6 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00463b68
    mov edx, dword ptr [ebp - local_8]           # 00463b6c
    movsx eax, word ptr [edx + field_24]         # 00463b6f
    {load} cmp ecx, eax                          # 00463b73
    jge.d32 L_00463ec6                           # 00463b75
    # block 0x00463b7b: entered by fall-through of jge at 0x00463b75, 6 instruction(s), ends with je to 0x00463ec1 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00463b7b
    imul ecx, ecx, 0x140                         # 00463b7f
    movsx edx, word ptr [ebp - local_c]          # 00463b85
    imul edx, edx, 0x28                          # 00463b89
    cmp dword ptr [ecx + edx + 0x594db5], 0x0    # 00463b8c
    je.d32 L_00463ec1                            # 00463b94
    # block 0x00463b9a: entered by fall-through of je at 0x00463b94, 11 instruction(s), ends with ja to 0x00463d9c (forward)
    movsx eax, word ptr [ebp - local_4]          # 00463b9a
    imul eax, eax, 0x140                         # 00463b9e
    movsx ecx, word ptr [ebp - local_c]          # 00463ba4
    imul ecx, ecx, 0x28                          # 00463ba8
    movsx edx, word ptr [eax + ecx + 0x594dd9]   # 00463bab
    mov dword ptr [ebp - local_20], edx          # 00463bb3
    mov eax, dword ptr [ebp - local_20]          # 00463bb6
    sub eax, 0x1                                 # 00463bb9
    mov dword ptr [ebp - local_20], eax          # 00463bbc
    cmp dword ptr [ebp - local_20], 0x13         # 00463bbf
    ja.d32 L_00463d9c                            # 00463bc3
    # block 0x00463bc9: entered by fall-through of ja at 0x00463bc3, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x463ed0]
    mov edx, dword ptr [ebp - local_20]          # 00463bc9
    {load} xor ecx, ecx                          # 00463bcc
    mov cl, byte ptr [edx + IDXTAB_00463ee4_VA]  # 00463bce
    jmp dword ptr [4*ecx + SWTAB_00463ed0_VA]    # 00463bd4
L_00463bdb:
    # block 0x00463bdb: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00463d9c
    push 0x54b210                                # 00463bdb
    movsx eax, word ptr [ebp - local_4]          # 00463be0
    imul eax, eax, 0x140                         # 00463be4
    movsx ecx, word ptr [ebp - local_c]          # 00463bea
    imul ecx, ecx, 0x28                          # 00463bee
    lea edx, [eax + ecx + 0x594db9]              # 00463bf1
    push edx                                     # 00463bf8
    mov eax, dword ptr [ebp - local_8]           # 00463bf9
    add eax, 0x210                               # 00463bfc
    push eax                                     # 00463c01
    mov ecx, dword ptr [0x5cf665]                # 00463c02
    push ecx                                     # 00463c08
    movsx edx, word ptr [0x61d795]               # 00463c09
    imul edx, edx, 0x4a                          # 00463c10
    mov eax, dword ptr [edx + 0x5d1599]          # 00463c13
    push eax                                     # 00463c19
    mov ecx, 0x5cf659                            # 00463c1a
    call FUN_004c5d4b                            # 00463c1f
    jmp.d32 L_00463d9c                           # 00463c24
L_00463c29:
    # block 0x00463c29: entered by switch case, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00463d9c
    push 0x54b22c                                # 00463c29
    movsx ecx, word ptr [ebp - local_4]          # 00463c2e
    imul ecx, ecx, 0x140                         # 00463c32
    movsx edx, word ptr [ebp - local_c]          # 00463c38
    imul edx, edx, 0x28                          # 00463c3c
    lea eax, [ecx + edx + 0x594db9]              # 00463c3f
    push eax                                     # 00463c46
    mov ecx, dword ptr [ebp - local_8]           # 00463c47
    add ecx, 0x220                               # 00463c4a
    push ecx                                     # 00463c50
    mov edx, dword ptr [0x5cf665]                # 00463c51
    push edx                                     # 00463c57
    movsx eax, word ptr [0x61d795]               # 00463c58
    imul eax, eax, 0x4a                          # 00463c5f
    mov ecx, dword ptr [eax + 0x5d1599]          # 00463c62
    push ecx                                     # 00463c68
    mov ecx, 0x5cf659                            # 00463c69
    call FUN_004c5d4b                            # 00463c6e
    jmp.d32 L_00463d9c                           # 00463c73
L_00463c78:
    # block 0x00463c78: entered by switch case, 6 instruction(s), ends with je to 0x00463cd7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00463c78
    mov eax, dword ptr [ebp - local_8]           # 00463c7b
    mov ecx, dword ptr [edx + field_238]         # 00463c7e
    sub ecx, dword ptr [eax + field_230]         # 00463c84
    test ecx, ecx                                # 00463c8a
    je.d8 L_00463cd7                             # 00463c8c
    # block 0x00463c8e: entered by fall-through of je at 0x00463c8c, 18 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00463cd7
    push 0x54b248                                # 00463c8e
    movsx edx, word ptr [ebp - local_4]          # 00463c93
    imul edx, edx, 0x140                         # 00463c97
    movsx eax, word ptr [ebp - local_c]          # 00463c9d
    imul eax, eax, 0x28                          # 00463ca1
    lea ecx, [edx + eax + 0x594db9]              # 00463ca4
    push ecx                                     # 00463cab
    mov edx, dword ptr [ebp - local_8]           # 00463cac
    add edx, 0x230                               # 00463caf
    push edx                                     # 00463cb5
    mov eax, dword ptr [0x5cf665]                # 00463cb6
    push eax                                     # 00463cbb
    movsx ecx, word ptr [0x61d795]               # 00463cbc
    imul ecx, ecx, 0x4a                          # 00463cc3
    mov edx, dword ptr [ecx + 0x5d1599]          # 00463cc6
    push edx                                     # 00463ccc
    mov ecx, 0x5cf659                            # 00463ccd
    call FUN_004c5d4b                            # 00463cd2
L_00463cd7:
    # block 0x00463cd7: entered by je at 0x00463c8c, 1 instruction(s), ends with forward jump to 0x00463d9c
    jmp.d32 L_00463d9c                           # 00463cd7
L_00463cdc:
    # block 0x00463cdc: entered by switch case, 20 instruction(s), ends with je to 0x00463d9c (forward)
    movsx eax, word ptr [ebp - local_4]          # 00463cdc
    imul eax, eax, 0x140                         # 00463ce0
    movsx ecx, word ptr [ebp - local_c]          # 00463ce6
    imul ecx, ecx, 0x28                          # 00463cea
    movsx edx, word ptr [eax + ecx + 0x594dd9]   # 00463ced
    sub edx, 0x1                                 # 00463cf5
    shl edx, 0x4                                 # 00463cf8
    movsx eax, word ptr [ebp - local_4]          # 00463cfb
    imul eax, eax, 0x140                         # 00463cff
    movsx ecx, word ptr [ebp - local_c]          # 00463d05
    imul ecx, ecx, 0x28                          # 00463d09
    movsx eax, word ptr [eax + ecx + 0x594dd9]   # 00463d0c
    sub eax, 0x1                                 # 00463d14
    shl eax, 0x4                                 # 00463d17
    mov ecx, dword ptr [ebp - local_8]           # 00463d1a
    mov esi, dword ptr [ebp - local_8]           # 00463d1d
    mov edx, dword ptr [ecx + edx + field_178]   # 00463d20
    sub edx, dword ptr [esi + eax + field_170]   # 00463d27
    test edx, edx                                # 00463d2e
    je.d8 L_00463d9c                             # 00463d30
    # block 0x00463d32: entered by fall-through of je at 0x00463d30, 25 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00463d9c
    push 0x54b264                                # 00463d32
    movsx eax, word ptr [ebp - local_4]          # 00463d37
    imul eax, eax, 0x140                         # 00463d3b
    movsx ecx, word ptr [ebp - local_c]          # 00463d41
    imul ecx, ecx, 0x28                          # 00463d45
    lea edx, [eax + ecx + 0x594db9]              # 00463d48
    push edx                                     # 00463d4f
    movsx eax, word ptr [ebp - local_4]          # 00463d50
    imul eax, eax, 0x140                         # 00463d54
    movsx ecx, word ptr [ebp - local_c]          # 00463d5a
    imul ecx, ecx, 0x28                          # 00463d5e
    movsx edx, word ptr [eax + ecx + 0x594dd9]   # 00463d61
    sub edx, 0x1                                 # 00463d69
    shl edx, 0x4                                 # 00463d6c
    mov eax, dword ptr [ebp - local_8]           # 00463d6f
    lea ecx, [eax + edx + field_170]             # 00463d72
    push ecx                                     # 00463d79
    mov edx, dword ptr [0x5cf665]                # 00463d7a
    push edx                                     # 00463d80
    movsx eax, word ptr [0x61d795]               # 00463d81
    imul eax, eax, 0x4a                          # 00463d88
    mov ecx, dword ptr [eax + 0x5d1599]          # 00463d8b
    push ecx                                     # 00463d91
    mov ecx, 0x5cf659                            # 00463d92
    call FUN_004c5d4b                            # 00463d97
L_00463d9c:
    # block 0x00463d9c: entered by ja at 0x00463bc3; jmp at 0x00463c24; jmp at 0x00463c73; jmp at 0x00463cd7; more, 7 instruction(s), ends with je to 0x00463ec1 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00463d9c
    imul edx, edx, 0x140                         # 00463da0
    movsx eax, word ptr [ebp - local_c]          # 00463da6
    imul eax, eax, 0x28                          # 00463daa
    movsx ecx, word ptr [edx + eax + 0x594ddb]   # 00463dad
    test ecx, ecx                                # 00463db5
    je.d32 L_00463ec1                            # 00463db7
    # block 0x00463dbd: entered by fall-through of je at 0x00463db7, 2 instruction(s), ends with je to 0x00463dd3 (forward)
    cmp dword ptr [0x61d79d], 0x2                # 00463dbd
    je.d8 L_00463dd3                             # 00463dc4
    # block 0x00463dc6: entered by fall-through of je at 0x00463dc4, 2 instruction(s), ends with jne to 0x00463e57 (forward)
    cmp dword ptr [0x61d7b4], 0x1                # 00463dc6
    jne.d32 L_00463e57                           # 00463dcd
L_00463dd3:
    # block 0x00463dd3: entered by je at 0x00463dc4; fall-through of jne at 0x00463dcd, 8 instruction(s), ends with jne to 0x00463e57 (forward)
    movsx edx, word ptr [0x61d7b2]               # 00463dd3
    movsx eax, word ptr [ebp - local_4]          # 00463dda
    imul eax, eax, 0x140                         # 00463dde
    movsx ecx, word ptr [ebp - local_c]          # 00463de4
    imul ecx, ecx, 0x28                          # 00463de8
    movsx eax, word ptr [eax + ecx + 0x594ddb]   # 00463deb
    {load} cmp edx, eax                          # 00463df3
    jne.d8 L_00463e57                            # 00463df5
    # block 0x00463df7: entered by fall-through of jne at 0x00463df5, 22 instruction(s), calls FUN_004c5377, falls into the block at 0x00463e57
    mov ecx, dword ptr [0x61d7a6]                # 00463df7
    sub ecx, dword ptr [0x58318a]                # 00463dfd
    mov dword ptr [ebp - local_18], ecx          # 00463e03
    mov edx, dword ptr [0x61d7ae]                # 00463e06
    sub edx, dword ptr [0x58318a]                # 00463e0c
    mov dword ptr [ebp - local_10], edx          # 00463e12
    mov eax, dword ptr [0x61d7a2]                # 00463e15
    sub eax, dword ptr [0x583186]                # 00463e1a
    mov dword ptr [ebp - local_1c], eax          # 00463e20
    mov ecx, dword ptr [0x61d7aa]                # 00463e23
    sub ecx, dword ptr [0x583186]                # 00463e29
    mov dword ptr [ebp - local_14], ecx          # 00463e2f
    push 0x54b284                                # 00463e32
    push 0x61d7a2                                # 00463e37
    lea edx, [ebp - local_1c]                    # 00463e3c
    push edx                                     # 00463e3f
    mov eax, dword ptr [0x5cf665]                # 00463e40
    push eax                                     # 00463e45
    mov ecx, dword ptr [0x5d15e3]                # 00463e46
    push ecx                                     # 00463e4c
    mov ecx, 0x5cf659                            # 00463e4d
    call FUN_004c5377                            # 00463e52
L_00463e57:
    # block 0x00463e57: entered by jne at 0x00463dcd; jne at 0x00463df5, 25 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00463ec1
    push 0x54b298                                # 00463e57
    movsx edx, word ptr [ebp - local_4]          # 00463e5c
    imul edx, edx, 0x140                         # 00463e60
    movsx eax, word ptr [ebp - local_c]          # 00463e66
    imul eax, eax, 0x28                          # 00463e6a
    lea ecx, [edx + eax + 0x594dc9]              # 00463e6d
    push ecx                                     # 00463e74
    movsx edx, word ptr [ebp - local_4]          # 00463e75
    imul edx, edx, 0x140                         # 00463e79
    movsx eax, word ptr [ebp - local_c]          # 00463e7f
    imul eax, eax, 0x28                          # 00463e83
    movsx ecx, word ptr [edx + eax + 0x594ddb]   # 00463e86
    sub ecx, 0x1                                 # 00463e8e
    shl ecx, 0x4                                 # 00463e91
    mov edx, dword ptr [ebp - local_8]           # 00463e94
    lea eax, [edx + ecx + field_d0]              # 00463e97
    push eax                                     # 00463e9e
    mov ecx, dword ptr [0x5cf665]                # 00463e9f
    push ecx                                     # 00463ea5
    movsx edx, word ptr [0x61d795]               # 00463ea6
    imul edx, edx, 0x4a                          # 00463ead
    mov eax, dword ptr [edx + 0x5d1599]          # 00463eb0
    push eax                                     # 00463eb6
    mov ecx, 0x5cf659                            # 00463eb7
    call FUN_004c5d4b                            # 00463ebc
L_00463ec1:
    # block 0x00463ec1: entered by je at 0x00463b94; je at 0x00463db7, 1 instruction(s), ends with backward jump to 0x00463b5c
    jmp.d32 L_00463b5c                           # 00463ec1
L_00463ec6:
    # block 0x00463ec6: entered by jge at 0x00463b75, 1 instruction(s), ends with backward jump to 0x00463b35
    jmp.d32 L_00463b35                           # 00463ec6
L_00463ecb:
    # block 0x00463ecb: entered by jge at 0x00463b4e, 4 instruction(s), ends with ret
    pop esi                                      # 00463ecb
    {load} mov esp, ebp                          # 00463ecc
    pop ebp                                      # 00463ece
    ret                                          # 00463ecf

# --- data items (not part of the function) -------------------------
.org 0x00463ed0 - 0x401000
SWTAB_00463ed0:  # 5 case address(es)
    .long L_00463cdc - .text + 0x401000
    .long L_00463bdb - .text + 0x401000
    .long L_00463c29 - .text + 0x401000
    .long L_00463c78 - .text + 0x401000
    .long L_00463d9c - .text + 0x401000
.org 0x00463ee4 - 0x401000
IDXTAB_00463ee4:  # index table of FUN_00463b10 for the switch jump at 0x00463bd4 (20 byte(s))
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 1
    .byte 2, 2, 1, 3
.org 0x00463ef8 - 0x401000
PAD_00463ef8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc
.set SWTAB_00463ed0_VA, SWTAB_00463ed0 - .text + 0x401000
.set IDXTAB_00463ee4_VA, IDXTAB_00463ee4 - .text + 0x401000

