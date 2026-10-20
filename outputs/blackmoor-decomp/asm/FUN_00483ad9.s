# FUN_00483ad9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483ad9
# extent:       0x00483ad9-0x00483e48 (879 code bytes)
# span:         0x00483ad9-0x00483e50 (code 879, tables 0, padding 8)
# sha256:       17e10c70a0b672d34a65c4f4fed7c5ce7e60ced287fc226d6d5ccc1e0ff02b60
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_new_phone_puzzle_renderer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/483ad9.c.txt, not original source) refers to the data labelled s_Cell_Phone_dialing_message_0054d990, s_NEW_PHONE_redraw_buttons_0054d9f4
# name-note:    Redraws the cell phone puzzle: dialing message, init animation, dial digits and button redraws through FUN_004c5377.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_26, local_28, local_2c and 1 more
# fields:       [eax + n] field_22, field_4b, field_fc, field_23e, field_242, field_246, field_24a; [ecx + n] field_22, field_23e, field_88b; [edx + n] field_21, field_22, field_fe, field_3a4
# callees:      calls FUN_004c5377, FUN_005193ca, FUN_004d2c20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 235 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_26, 0x26  # offset -0x26
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_4b, 0x4b  # offset +0x4b
.equ field_fc, 0xfc  # offset +0xfc
.equ field_fe, 0xfe  # offset +0xfe
.equ field_23e, 0x23e  # offset +0x23e
.equ field_242, 0x242  # offset +0x242
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a
.equ field_3a4, 0x3a4  # offset +0x3a4
.equ field_88b, 0x88b  # offset +0x88b

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x00483ad9 - 0x401000
.globl FUN_00483ad9
FUN_00483ad9:
    # block 0x00483ad9: entry, 12 instruction(s), ends with je to 0x00483cef (forward)
    push ebp                                     # 00483ad9
    {load} mov ebp, esp                          # 00483ada
    sub esp, 0x30                                # 00483adc
    movsx eax, word ptr [0x624d30]               # 00483adf
    imul eax, eax, 0x8d                          # 00483ae6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00483aec
    mov dword ptr [ebp - local_4], ecx           # 00483af2
    mov edx, dword ptr [ebp - local_4]           # 00483af5
    {load} xor eax, eax                          # 00483af8
    mov al, byte ptr [edx + field_21]            # 00483afa
    test eax, eax                                # 00483afd
    je.d32 L_00483cef                            # 00483aff
    # block 0x00483b05: entered by fall-through of je at 0x00483aff, 4 instruction(s), ends with je to 0x00483b49 (forward)
    {load} xor ecx, ecx                          # 00483b05
    mov cl, byte ptr [0x624d90]                  # 00483b07
    test ecx, ecx                                # 00483b0d
    je.d8 L_00483b49                             # 00483b0f
    # block 0x00483b11: entered by fall-through of je at 0x00483b0f, 14 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483cef
    push 0x54d960                                # 00483b11
    push 0x624d91                                # 00483b16
    movsx edx, word ptr [0x624d8e]               # 00483b1b
    shl edx, 0x4                                 # 00483b22
    mov eax, dword ptr [ebp - local_4]           # 00483b25
    lea ecx, [eax + edx + field_4b]              # 00483b28
    push ecx                                     # 00483b2c
    mov edx, dword ptr [0x5cf665]                # 00483b2d
    push edx                                     # 00483b33
    mov eax, dword ptr [0x624d36]                # 00483b34
    push eax                                     # 00483b39
    mov ecx, 0x5cf659                            # 00483b3a
    call FUN_004c5377                            # 00483b3f
    jmp.d32 L_00483cef                           # 00483b44
L_00483b49:
    # block 0x00483b49: entered by je at 0x00483b0f, 4 instruction(s), ends with je to 0x00483b8c (forward)
    {load} xor ecx, ecx                          # 00483b49
    mov cl, byte ptr [0x624da6]                  # 00483b4b
    test ecx, ecx                                # 00483b51
    je.d8 L_00483b8c                             # 00483b53
    # block 0x00483b55: entered by fall-through of je at 0x00483b53, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483cef
    push 0x54d978                                # 00483b55
    push 0x624d91                                # 00483b5a
    mov edx, dword ptr [ebp - local_4]           # 00483b5f
    add edx, 0xeb                                # 00483b62
    push edx                                     # 00483b68
    mov eax, dword ptr [0x5cf665]                # 00483b69
    push eax                                     # 00483b6e
    mov ecx, dword ptr [0x5d15e3]                # 00483b6f
    push ecx                                     # 00483b75
    mov ecx, 0x5cf659                            # 00483b76
    call FUN_004c5377                            # 00483b7b
    mov byte ptr [0x624da6], 0x0                 # 00483b80
    jmp.d32 L_00483cef                           # 00483b87
L_00483b8c:
    # block 0x00483b8c: entered by je at 0x00483b53, 2 instruction(s), ends with je to 0x00483b9e (forward)
    cmp dword ptr [0x624d8a], 0x2                # 00483b8c
    je.d8 L_00483b9e                             # 00483b93
    # block 0x00483b95: entered by fall-through of je at 0x00483b93, 2 instruction(s), ends with jne to 0x00483bce (forward)
    cmp dword ptr [0x624d8a], 0x3                # 00483b95
    jne.d8 L_00483bce                            # 00483b9c
L_00483b9e:
    # block 0x00483b9e: entered by je at 0x00483b93; fall-through of jne at 0x00483b9c, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483cef
    push 0x54d990                                # 00483b9e
    push 0x624d91                                # 00483ba3
    mov edx, dword ptr [ebp - local_4]           # 00483ba8
    add edx, 0x3a6                               # 00483bab
    push edx                                     # 00483bb1
    mov eax, dword ptr [0x5cf665]                # 00483bb2
    push eax                                     # 00483bb7
    mov ecx, dword ptr [0x624d32]                # 00483bb8
    push ecx                                     # 00483bbe
    mov ecx, 0x5cf659                            # 00483bbf
    call FUN_004c5377                            # 00483bc4
    jmp.d32 L_00483cef                           # 00483bc9
L_00483bce:
    # block 0x00483bce: entered by jne at 0x00483b9c, 4 instruction(s), ends with je to 0x00483c15 (forward)
    {load} xor edx, edx                          # 00483bce
    mov dl, byte ptr [0x624da3]                  # 00483bd0
    test edx, edx                                # 00483bd6
    je.d8 L_00483c15                             # 00483bd8
    # block 0x00483bda: entered by fall-through of je at 0x00483bd8, 14 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483cef
    push 0x54d9ac                                # 00483bda
    push 0x624d91                                # 00483bdf
    movsx eax, word ptr [0x624da1]               # 00483be4
    imul eax, eax, 0x37                          # 00483beb
    mov ecx, dword ptr [ebp - local_4]           # 00483bee
    lea edx, [ecx + eax + field_88b]             # 00483bf1
    push edx                                     # 00483bf8
    mov eax, dword ptr [0x5cf665]                # 00483bf9
    push eax                                     # 00483bfe
    mov ecx, dword ptr [0x624d32]                # 00483bff
    push ecx                                     # 00483c05
    mov ecx, 0x5cf659                            # 00483c06
    call FUN_004c5377                            # 00483c0b
    jmp.d32 L_00483cef                           # 00483c10
L_00483c15:
    # block 0x00483c15: entered by je at 0x00483bd8, 3 instruction(s), ends with jle to 0x00483cef (forward)
    movsx edx, word ptr [0x624da4]               # 00483c15
    test edx, edx                                # 00483c1c
    jle.d32 L_00483cef                           # 00483c1e
    # block 0x00483c24: entered by fall-through of jle at 0x00483c1e, 13 instruction(s), ends with forward jump to 0x00483c60
    mov eax, dword ptr [0x624d95]                # 00483c24
    add eax, 0x14                                # 00483c29
    mov word ptr [ebp - local_20], ax            # 00483c2c
    mov ecx, dword ptr [0x624d91]                # 00483c30
    add ecx, 0x14                                # 00483c36
    mov word ptr [ebp - local_1c], cx            # 00483c39
    {load} xor edx, edx                          # 00483c3d
    mov dword ptr [ebp - local_30], edx          # 00483c3f
    mov dword ptr [ebp - local_2c], edx          # 00483c42
    mov word ptr [ebp - local_28], dx            # 00483c45
    mov byte ptr [ebp - local_26], dl            # 00483c49
    mov word ptr [ebp - local_24], 0x0           # 00483c4c
    jmp.d8 L_00483c60                            # 00483c52
L_00483c54:
    # block 0x00483c54: entered by jmp at 0x00483c98, 3 instruction(s), falls into the block at 0x00483c60
    mov ax, word ptr [ebp - local_24]            # 00483c54
    .insn 0x66, 0x05, 0x0001{:u16}               # 00483c58
    mov word ptr [ebp - local_24], ax            # 00483c5c
L_00483c60:
    # block 0x00483c60: entered by jmp at 0x00483c52, 3 instruction(s), ends with jge to 0x00483c9a (forward)
    movsx ecx, word ptr [ebp - local_24]         # 00483c60
    cmp ecx, 0xb                                 # 00483c64
    jge.d8 L_00483c9a                            # 00483c67
    # block 0x00483c69: entered by fall-through of jge at 0x00483c67, 4 instruction(s), ends with jge to 0x00483c9a (forward)
    movsx edx, word ptr [ebp - local_24]         # 00483c69
    movsx eax, word ptr [0x624da4]               # 00483c6d
    {load} cmp edx, eax                          # 00483c74
    jge.d8 L_00483c9a                            # 00483c76
    # block 0x00483c78: entered by fall-through of jge at 0x00483c76, 11 instruction(s), calls FUN_005193ca, ends with backward jump to 0x00483c54
    push 0xa                                     # 00483c78
    movsx ecx, word ptr [ebp - local_24]         # 00483c7a
    lea edx, [ebp + ecx - local_30]              # 00483c7e
    push edx                                     # 00483c82
    movsx eax, word ptr [ebp - local_24]         # 00483c83
    {load} xor ecx, ecx                          # 00483c87
    mov cl, byte ptr [eax + 0x624da7]            # 00483c89
    push ecx                                     # 00483c8f
    call FUN_005193ca                            # 00483c90
    add esp, 0xc                                 # 00483c95
    jmp.d8 L_00483c54                            # 00483c98
L_00483c9a:
    # block 0x00483c9a: entered by jge at 0x00483c67; jge at 0x00483c76, 25 instruction(s), calls FUN_004d2c20, falls into the block at 0x00483cef
    push 0x0                                     # 00483c9a
    mov edx, dword ptr [0x5cf665]                # 00483c9c
    push edx                                     # 00483ca2
    mov eax, dword ptr [ebp - local_4]           # 00483ca3
    movsx ecx, word ptr [eax + field_22]         # 00483ca6
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 00483caa
    push edx                                     # 00483cb1
    mov ax, word ptr [ebp - local_20]            # 00483cb2
    push eax                                     # 00483cb6
    mov cx, word ptr [ebp - local_1c]            # 00483cb7
    push ecx                                     # 00483cbb
    mov edx, dword ptr [ebp - local_4]           # 00483cbc
    movsx eax, word ptr [edx + field_22]         # 00483cbf
    imul eax, eax, 0x1d0                         # 00483cc3
    add eax, 0x5adb3a                            # 00483cc9
    push eax                                     # 00483cce
    mov ecx, dword ptr [ebp - local_4]           # 00483ccf
    movsx edx, word ptr [ecx + field_22]         # 00483cd2
    imul edx, edx, 0x7f3                         # 00483cd6
    add edx, 0x5a4c24                            # 00483cdc
    push edx                                     # 00483ce2
    lea eax, [ebp - local_30]                    # 00483ce3
    push eax                                     # 00483ce6
    call FUN_004d2c20                            # 00483ce7
    add esp, 0x20                                # 00483cec
L_00483cef:
    # block 0x00483cef: entered by je at 0x00483aff; jmp at 0x00483b44; jmp at 0x00483b87; jmp at 0x00483bc9; more, 2 instruction(s), ends with forward jump to 0x00483d03
    mov word ptr [ebp - local_8], 0x0            # 00483cef
    jmp.d8 L_00483d03                            # 00483cf5
L_00483cf7:
    # block 0x00483cf7: entered by jmp at 0x00483e3f, 3 instruction(s), falls into the block at 0x00483d03
    mov cx, word ptr [ebp - local_8]             # 00483cf7
    add cx, 0x1                                  # 00483cfb
    mov word ptr [ebp - local_8], cx             # 00483cff
L_00483d03:
    # block 0x00483d03: entered by jmp at 0x00483cf5, 5 instruction(s), ends with jge to 0x00483e44 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00483d03
    mov eax, dword ptr [ebp - local_4]           # 00483d07
    movsx ecx, word ptr [eax + field_fc]         # 00483d0a
    {load} cmp edx, ecx                          # 00483d11
    jge.d32 L_00483e44                           # 00483d13
    # block 0x00483d19: entered by fall-through of jge at 0x00483d13, 27 instruction(s), ends with je to 0x00483dc4 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00483d19
    shl edx, 0x4                                 # 00483d1d
    mov eax, dword ptr [ebp - local_4]           # 00483d20
    mov ecx, dword ptr [eax + edx + field_242]   # 00483d23
    add ecx, dword ptr [0x58318a]                # 00483d2a
    mov dword ptr [ebp - local_14], ecx          # 00483d30
    movsx edx, word ptr [ebp - local_8]          # 00483d33
    shl edx, 0x4                                 # 00483d37
    mov eax, dword ptr [ebp - local_4]           # 00483d3a
    mov ecx, dword ptr [eax + edx + field_24a]   # 00483d3d
    add ecx, dword ptr [0x58318a]                # 00483d44
    mov dword ptr [ebp - local_c], ecx           # 00483d4a
    movsx edx, word ptr [ebp - local_8]          # 00483d4d
    shl edx, 0x4                                 # 00483d51
    mov eax, dword ptr [ebp - local_4]           # 00483d54
    mov ecx, dword ptr [eax + edx + field_23e]   # 00483d57
    add ecx, dword ptr [0x583186]                # 00483d5e
    mov dword ptr [ebp - local_18], ecx          # 00483d64
    movsx edx, word ptr [ebp - local_8]          # 00483d67
    shl edx, 0x4                                 # 00483d6b
    mov eax, dword ptr [ebp - local_4]           # 00483d6e
    mov ecx, dword ptr [eax + edx + field_246]   # 00483d71
    add ecx, dword ptr [0x583186]                # 00483d78
    mov dword ptr [ebp - local_10], ecx          # 00483d7e
    movsx edx, word ptr [ebp - local_8]          # 00483d81
    cmp dword ptr [4*edx + 0x624d3a], 0x0        # 00483d85
    je.d8 L_00483dc4                             # 00483d8d
    # block 0x00483d8f: entered by fall-through of je at 0x00483d8d, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483e3f
    push 0x54d9c4                                # 00483d8f
    lea eax, [ebp - local_18]                    # 00483d94
    push eax                                     # 00483d97
    movsx ecx, word ptr [ebp - local_8]          # 00483d98
    shl ecx, 0x4                                 # 00483d9c
    mov edx, dword ptr [ebp - local_4]           # 00483d9f
    lea eax, [edx + ecx + field_fe]              # 00483da2
    push eax                                     # 00483da9
    mov ecx, dword ptr [0x5cf665]                # 00483daa
    push ecx                                     # 00483db0
    mov edx, dword ptr [0x624d32]                # 00483db1
    push edx                                     # 00483db7
    mov ecx, 0x5cf659                            # 00483db8
    call FUN_004c5377                            # 00483dbd
    jmp.d8 L_00483e3f                            # 00483dc2
L_00483dc4:
    # block 0x00483dc4: entered by je at 0x00483d8d, 4 instruction(s), ends with je to 0x00483e0d (forward)
    {load} xor eax, eax                          # 00483dc4
    mov al, byte ptr [0x624da3]                  # 00483dc6
    test eax, eax                                # 00483dcb
    je.d8 L_00483e0d                             # 00483dcd
    # block 0x00483dcf: entered by fall-through of je at 0x00483dcd, 5 instruction(s), ends with jne to 0x00483e0d (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00483dcf
    mov edx, dword ptr [ebp - local_4]           # 00483dd3
    movsx eax, word ptr [edx + field_3a4]        # 00483dd6
    {load} cmp ecx, eax                          # 00483ddd
    jne.d8 L_00483e0d                            # 00483ddf
    # block 0x00483de1: entered by fall-through of jne at 0x00483ddf, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00483e3f
    push 0x54d9dc                                # 00483de1
    lea ecx, [ebp - local_18]                    # 00483de6
    push ecx                                     # 00483de9
    mov edx, dword ptr [ebp - local_4]           # 00483dea
    add edx, 0x37e                               # 00483ded
    push edx                                     # 00483df3
    mov eax, dword ptr [0x5cf665]                # 00483df4
    push eax                                     # 00483df9
    mov ecx, dword ptr [0x624d32]                # 00483dfa
    push ecx                                     # 00483e00
    mov ecx, 0x5cf659                            # 00483e01
    call FUN_004c5377                            # 00483e06
    jmp.d8 L_00483e3f                            # 00483e0b
L_00483e0d:
    # block 0x00483e0d: entered by je at 0x00483dcd; jne at 0x00483ddf, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x00483e3f
    push 0x54d9f4                                # 00483e0d
    lea edx, [ebp - local_18]                    # 00483e12
    push edx                                     # 00483e15
    movsx eax, word ptr [ebp - local_8]          # 00483e16
    shl eax, 0x4                                 # 00483e1a
    mov ecx, dword ptr [ebp - local_4]           # 00483e1d
    lea edx, [ecx + eax + field_23e]             # 00483e20
    push edx                                     # 00483e27
    mov eax, dword ptr [0x5cf665]                # 00483e28
    push eax                                     # 00483e2d
    mov ecx, dword ptr [0x5d15e3]                # 00483e2e
    push ecx                                     # 00483e34
    mov ecx, 0x5cf659                            # 00483e35
    call FUN_004c5377                            # 00483e3a
L_00483e3f:
    # block 0x00483e3f: entered by jmp at 0x00483dc2; jmp at 0x00483e0b, 1 instruction(s), ends with backward jump to 0x00483cf7
    jmp.d32 L_00483cf7                           # 00483e3f
L_00483e44:
    # block 0x00483e44: entered by jge at 0x00483d13, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00483e44
    pop ebp                                      # 00483e46
    ret                                          # 00483e47

# --- data items (not part of the function) -------------------------
.org 0x00483e48 - 0x401000
PAD_00483e48:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

