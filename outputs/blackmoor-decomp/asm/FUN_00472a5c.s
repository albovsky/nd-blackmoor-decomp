# FUN_00472a5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472a5c
# extent:       0x00472a5c-0x00472ec7 (1131 code bytes)
# span:         0x00472a5c-0x00472ed0 (code 1131, tables 0, padding 9)
# sha256:       b614004b9480ec3fff30d1c0a0d4e04b77d02c5631a6ed1047eff696043beb2e
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00472a5c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_35, field_41, field_10e; [ecx + n] field_39, field_3d, field_41, field_1ae, field_1fe; [edx + n] field_21, field_35, field_39, field_3d, field_15e, field_162, field_166, field_16a, field_1fe, field_202, field_206, field_20a; [esi + n] field_162, field_202
# callees:      calls FUN_004c5d4b, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 289 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_21, 0x21  # offset +0x21
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_10e, 0x10e  # offset +0x10e
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1fe, 0x1fe  # offset +0x1fe
.equ field_202, 0x202  # offset +0x202
.equ field_206, 0x206  # offset +0x206
.equ field_20a, 0x20a  # offset +0x20a

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00472a5c - 0x401000
.globl FUN_00472a5c
FUN_00472a5c:
    # block 0x00472a5c: entry, 12 instruction(s), ends with je to 0x00472ec2 (forward)
    push ebp                                     # 00472a5c
    {load} mov ebp, esp                          # 00472a5d
    sub esp, 0x18                                # 00472a5f
    push esi                                     # 00472a62
    movsx eax, word ptr [0x6245a4]               # 00472a63
    imul eax, eax, 0x8d                          # 00472a6a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00472a70
    mov dword ptr [ebp - local_4], ecx           # 00472a76
    {load} xor edx, edx                          # 00472a79
    mov dl, byte ptr [0x62457c]                  # 00472a7b
    test edx, edx                                # 00472a81
    je.d32 L_00472ec2                            # 00472a83
    # block 0x00472a89: entered by fall-through of je at 0x00472a83, 2 instruction(s), ends with forward jump to 0x00472a9d
    mov word ptr [ebp - local_8], 0x0            # 00472a89
    jmp.d8 L_00472a9d                            # 00472a8f
L_00472a91:
    # block 0x00472a91: entered by jmp at 0x00472b80, 3 instruction(s), falls into the block at 0x00472a9d
    mov ax, word ptr [ebp - local_8]             # 00472a91
    .insn 0x66, 0x05, 0x0001{:u16}               # 00472a95
    mov word ptr [ebp - local_8], ax             # 00472a99
L_00472a9d:
    # block 0x00472a9d: entered by jmp at 0x00472a8f, 5 instruction(s), ends with jge to 0x00472b85 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00472a9d
    mov edx, dword ptr [ebp - local_4]           # 00472aa1
    movsx eax, word ptr [edx + field_21]         # 00472aa4
    {load} cmp ecx, eax                          # 00472aa8
    jge.d32 L_00472b85                           # 00472aaa
    # block 0x00472ab0: entered by fall-through of jge at 0x00472aaa, 25 instruction(s), ends with je to 0x00472b52 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00472ab0
    shl ecx, 0x4                                 # 00472ab4
    mov edx, dword ptr [ecx + 0x623edc]          # 00472ab7
    add edx, dword ptr [0x58318a]                # 00472abd
    mov dword ptr [ebp - local_14], edx          # 00472ac3
    movsx eax, word ptr [ebp - local_8]          # 00472ac6
    shl eax, 0x4                                 # 00472aca
    mov ecx, dword ptr [eax + 0x623ee4]          # 00472acd
    add ecx, dword ptr [0x58318a]                # 00472ad3
    mov dword ptr [ebp - local_c], ecx           # 00472ad9
    movsx edx, word ptr [ebp - local_8]          # 00472adc
    shl edx, 0x4                                 # 00472ae0
    mov eax, dword ptr [edx + 0x623ed8]          # 00472ae3
    add eax, dword ptr [0x583186]                # 00472ae9
    mov dword ptr [ebp - local_18], eax          # 00472aef
    movsx ecx, word ptr [ebp - local_8]          # 00472af2
    shl ecx, 0x4                                 # 00472af6
    mov edx, dword ptr [ecx + 0x623ee0]          # 00472af9
    add edx, dword ptr [0x583186]                # 00472aff
    mov dword ptr [ebp - local_10], edx          # 00472b05
    movsx eax, word ptr [ebp - local_8]          # 00472b08
    {load} xor ecx, ecx                          # 00472b0c
    mov cl, byte ptr [eax + 0x624518]            # 00472b0e
    test ecx, ecx                                # 00472b14
    je.d8 L_00472b52                             # 00472b16
    # block 0x00472b18: entered by fall-through of je at 0x00472b16, 16 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00472b80
    push 0x54c4f4                                # 00472b18
    lea edx, [ebp - local_18]                    # 00472b1d
    push edx                                     # 00472b20
    movsx eax, word ptr [ebp - local_8]          # 00472b21
    shl eax, 0x4                                 # 00472b25
    add eax, 0x623898                            # 00472b28
    push eax                                     # 00472b2d
    mov ecx, dword ptr [0x5cf665]                # 00472b2e
    push ecx                                     # 00472b34
    movsx edx, word ptr [0x6245b4]               # 00472b35
    imul edx, edx, 0x4a                          # 00472b3c
    mov eax, dword ptr [edx + 0x5d1599]          # 00472b3f
    push eax                                     # 00472b45
    mov ecx, 0x5cf659                            # 00472b46
    call FUN_004c5d4b                            # 00472b4b
    jmp.d8 L_00472b80                            # 00472b50
L_00472b52:
    # block 0x00472b52: entered by je at 0x00472b16, 13 instruction(s), calls FUN_004c5377, falls into the block at 0x00472b80
    push 0x54c508                                # 00472b52
    lea ecx, [ebp - local_18]                    # 00472b57
    push ecx                                     # 00472b5a
    movsx edx, word ptr [ebp - local_8]          # 00472b5b
    shl edx, 0x4                                 # 00472b5f
    add edx, 0x623ed8                            # 00472b62
    push edx                                     # 00472b68
    mov eax, dword ptr [0x5cf665]                # 00472b69
    push eax                                     # 00472b6e
    mov ecx, dword ptr [0x5d15e3]                # 00472b6f
    push ecx                                     # 00472b75
    mov ecx, 0x5cf659                            # 00472b76
    call FUN_004c5377                            # 00472b7b
L_00472b80:
    # block 0x00472b80: entered by jmp at 0x00472b50, 1 instruction(s), ends with backward jump to 0x00472a91
    jmp.d32 L_00472a91                           # 00472b80
L_00472b85:
    # block 0x00472b85: entered by jge at 0x00472aaa, 4 instruction(s), ends with jne to 0x00472ddd (forward)
    {load} xor edx, edx                          # 00472b85
    mov dl, byte ptr [0x6245b9]                  # 00472b87
    test edx, edx                                # 00472b8d
    jne.d32 L_00472ddd                           # 00472b8f
    # block 0x00472b95: entered by fall-through of jne at 0x00472b8f, 2 instruction(s), ends with forward jump to 0x00472ba9
    mov word ptr [ebp - local_8], 0x0            # 00472b95
    jmp.d8 L_00472ba9                            # 00472b9b
L_00472b9d:
    # block 0x00472b9d: entered by jmp at 0x00472c8b, 3 instruction(s), falls into the block at 0x00472ba9
    mov ax, word ptr [ebp - local_8]             # 00472b9d
    .insn 0x66, 0x05, 0x0001{:u16}               # 00472ba1
    mov word ptr [ebp - local_8], ax             # 00472ba5
L_00472ba9:
    # block 0x00472ba9: entered by jmp at 0x00472b9b, 4 instruction(s), ends with jge to 0x00472c90 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00472ba9
    movsx edx, word ptr [0x5957b7]               # 00472bad
    {load} cmp ecx, edx                          # 00472bb4
    jge.d32 L_00472c90                           # 00472bb6
    # block 0x00472bbc: entered by fall-through of jge at 0x00472bb6, 10 instruction(s), ends with je to 0x00472c8b (forward)
    movsx eax, word ptr [ebp - local_8]          # 00472bbc
    shl eax, 0x4                                 # 00472bc0
    movsx ecx, word ptr [ebp - local_8]          # 00472bc3
    shl ecx, 0x4                                 # 00472bc7
    mov edx, dword ptr [ebp - local_4]           # 00472bca
    mov esi, dword ptr [ebp - local_4]           # 00472bcd
    mov eax, dword ptr [edx + eax + field_16a]   # 00472bd0
    sub eax, dword ptr [esi + ecx + field_162]   # 00472bd7
    test eax, eax                                # 00472bde
    je.d32 L_00472c8b                            # 00472be0
    # block 0x00472be6: entered by fall-through of je at 0x00472be0, 40 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00472c8b
    movsx ecx, word ptr [ebp - local_8]          # 00472be6
    shl ecx, 0x4                                 # 00472bea
    mov edx, dword ptr [ebp - local_4]           # 00472bed
    mov eax, dword ptr [edx + ecx + field_162]   # 00472bf0
    add eax, dword ptr [0x58318a]                # 00472bf7
    mov dword ptr [ebp - local_14], eax          # 00472bfd
    movsx ecx, word ptr [ebp - local_8]          # 00472c00
    shl ecx, 0x4                                 # 00472c04
    mov edx, dword ptr [ebp - local_4]           # 00472c07
    mov eax, dword ptr [edx + ecx + field_16a]   # 00472c0a
    add eax, dword ptr [0x58318a]                # 00472c11
    mov dword ptr [ebp - local_c], eax           # 00472c17
    movsx ecx, word ptr [ebp - local_8]          # 00472c1a
    shl ecx, 0x4                                 # 00472c1e
    mov edx, dword ptr [ebp - local_4]           # 00472c21
    mov eax, dword ptr [edx + ecx + field_15e]   # 00472c24
    add eax, dword ptr [0x583186]                # 00472c2b
    mov dword ptr [ebp - local_18], eax          # 00472c31
    movsx ecx, word ptr [ebp - local_8]          # 00472c34
    shl ecx, 0x4                                 # 00472c38
    mov edx, dword ptr [ebp - local_4]           # 00472c3b
    mov eax, dword ptr [edx + ecx + field_166]   # 00472c3e
    add eax, dword ptr [0x583186]                # 00472c45
    mov dword ptr [ebp - local_10], eax          # 00472c4b
    push 0x54c524                                # 00472c4e
    lea ecx, [ebp - local_18]                    # 00472c53
    push ecx                                     # 00472c56
    movsx edx, word ptr [ebp - local_8]          # 00472c57
    shl edx, 0x4                                 # 00472c5b
    mov eax, dword ptr [ebp - local_4]           # 00472c5e
    lea ecx, [eax + edx + field_10e]             # 00472c61
    push ecx                                     # 00472c68
    mov edx, dword ptr [0x5cf665]                # 00472c69
    push edx                                     # 00472c6f
    movsx eax, word ptr [0x6245b4]               # 00472c70
    imul eax, eax, 0x4a                          # 00472c77
    mov ecx, dword ptr [eax + 0x5d1599]          # 00472c7a
    push ecx                                     # 00472c80
    mov ecx, 0x5cf659                            # 00472c81
    call FUN_004c5d4b                            # 00472c86
L_00472c8b:
    # block 0x00472c8b: entered by je at 0x00472be0, 1 instruction(s), ends with backward jump to 0x00472b9d
    jmp.d32 L_00472b9d                           # 00472c8b
L_00472c90:
    # block 0x00472c90: entered by jge at 0x00472bb6, 3 instruction(s), ends with jle to 0x00472ddd (forward)
    movsx edx, word ptr [0x5957b7]               # 00472c90
    test edx, edx                                # 00472c97
    jle.d32 L_00472ddd                           # 00472c99
    # block 0x00472c9f: entered by fall-through of jle at 0x00472c99, 12 instruction(s), ends with je to 0x00472ddd (forward)
    movsx eax, word ptr [0x5957b7]               # 00472c9f
    sub eax, 0x1                                 # 00472ca6
    shl eax, 0x4                                 # 00472ca9
    movsx ecx, word ptr [0x5957b7]               # 00472cac
    sub ecx, 0x1                                 # 00472cb3
    shl ecx, 0x4                                 # 00472cb6
    mov edx, dword ptr [ebp - local_4]           # 00472cb9
    mov esi, dword ptr [ebp - local_4]           # 00472cbc
    mov eax, dword ptr [edx + eax + field_20a]   # 00472cbf
    sub eax, dword ptr [esi + ecx + field_202]   # 00472cc6
    test eax, eax                                # 00472ccd
    je.d32 L_00472ddd                            # 00472ccf
    # block 0x00472cd5: entered by fall-through of je at 0x00472ccf, 32 instruction(s), ends with je to 0x00472d9b (forward)
    movsx ecx, word ptr [0x5957b7]               # 00472cd5
    sub ecx, 0x1                                 # 00472cdc
    shl ecx, 0x4                                 # 00472cdf
    mov edx, dword ptr [ebp - local_4]           # 00472ce2
    mov eax, dword ptr [edx + ecx + field_202]   # 00472ce5
    add eax, dword ptr [0x58318a]                # 00472cec
    mov dword ptr [ebp - local_14], eax          # 00472cf2
    movsx ecx, word ptr [0x5957b7]               # 00472cf5
    sub ecx, 0x1                                 # 00472cfc
    shl ecx, 0x4                                 # 00472cff
    mov edx, dword ptr [ebp - local_4]           # 00472d02
    mov eax, dword ptr [edx + ecx + field_20a]   # 00472d05
    add eax, dword ptr [0x58318a]                # 00472d0c
    mov dword ptr [ebp - local_c], eax           # 00472d12
    movsx ecx, word ptr [0x5957b7]               # 00472d15
    sub ecx, 0x1                                 # 00472d1c
    shl ecx, 0x4                                 # 00472d1f
    mov edx, dword ptr [ebp - local_4]           # 00472d22
    mov eax, dword ptr [edx + ecx + field_1fe]   # 00472d25
    add eax, dword ptr [0x583186]                # 00472d2c
    mov dword ptr [ebp - local_18], eax          # 00472d32
    movsx ecx, word ptr [0x5957b7]               # 00472d35
    sub ecx, 0x1                                 # 00472d3c
    shl ecx, 0x4                                 # 00472d3f
    mov edx, dword ptr [ebp - local_4]           # 00472d42
    mov eax, dword ptr [edx + ecx + field_206]   # 00472d45
    add eax, dword ptr [0x583186]                # 00472d4c
    mov dword ptr [ebp - local_10], eax          # 00472d52
    {load} xor ecx, ecx                          # 00472d55
    mov cl, byte ptr [0x6245b8]                  # 00472d57
    test ecx, ecx                                # 00472d5d
    je.d8 L_00472d9b                             # 00472d5f
    # block 0x00472d61: entered by fall-through of je at 0x00472d5f, 16 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00472ddd
    push 0x54c538                                # 00472d61
    lea edx, [ebp - local_18]                    # 00472d66
    push edx                                     # 00472d69
    movsx eax, word ptr [0x5957b7]               # 00472d6a
    sub eax, 0x1                                 # 00472d71
    shl eax, 0x4                                 # 00472d74
    mov ecx, dword ptr [ebp - local_4]           # 00472d77
    lea edx, [ecx + eax + field_1fe]             # 00472d7a
    push edx                                     # 00472d81
    mov eax, dword ptr [0x5cf665]                # 00472d82
    push eax                                     # 00472d87
    mov ecx, dword ptr [0x5d15e3]                # 00472d88
    push ecx                                     # 00472d8e
    mov ecx, 0x5cf659                            # 00472d8f
    call FUN_004c5d4b                            # 00472d94
    jmp.d8 L_00472ddd                            # 00472d99
L_00472d9b:
    # block 0x00472d9b: entered by je at 0x00472d5f, 17 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00472ddd
    push 0x54c54c                                # 00472d9b
    lea edx, [ebp - local_18]                    # 00472da0
    push edx                                     # 00472da3
    movsx eax, word ptr [0x5957b7]               # 00472da4
    sub eax, 0x1                                 # 00472dab
    shl eax, 0x4                                 # 00472dae
    mov ecx, dword ptr [ebp - local_4]           # 00472db1
    lea edx, [ecx + eax + field_1ae]             # 00472db4
    push edx                                     # 00472dbb
    mov eax, dword ptr [0x5cf665]                # 00472dbc
    push eax                                     # 00472dc1
    movsx ecx, word ptr [0x6245b4]               # 00472dc2
    imul ecx, ecx, 0x4a                          # 00472dc9
    mov edx, dword ptr [ecx + 0x5d1599]          # 00472dcc
    push edx                                     # 00472dd2
    mov ecx, 0x5cf659                            # 00472dd3
    call FUN_004c5d4b                            # 00472dd8
L_00472ddd:
    # block 0x00472ddd: entered by jne at 0x00472b8f; jle at 0x00472c99; je at 0x00472ccf; jmp at 0x00472d99, 4 instruction(s), ends with je to 0x00472e5f (forward)
    {load} xor eax, eax                          # 00472ddd
    mov al, byte ptr [0x6245b6]                  # 00472ddf
    test eax, eax                                # 00472de4
    je.d8 L_00472e5f                             # 00472de6
    # block 0x00472de8: entered by fall-through of je at 0x00472de6, 32 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00472ec2
    mov ecx, dword ptr [ebp - local_4]           # 00472de8
    mov edx, dword ptr [ecx + field_39]          # 00472deb
    add edx, dword ptr [0x58318a]                # 00472dee
    mov dword ptr [ebp - local_14], edx          # 00472df4
    mov eax, dword ptr [ebp - local_4]           # 00472df7
    mov ecx, dword ptr [eax + field_41]          # 00472dfa
    add ecx, dword ptr [0x58318a]                # 00472dfd
    mov dword ptr [ebp - local_c], ecx           # 00472e03
    mov edx, dword ptr [ebp - local_4]           # 00472e06
    mov eax, dword ptr [edx + field_35]          # 00472e09
    add eax, dword ptr [0x583186]                # 00472e0c
    mov dword ptr [ebp - local_18], eax          # 00472e12
    mov ecx, dword ptr [ebp - local_4]           # 00472e15
    mov edx, dword ptr [ecx + field_3d]          # 00472e18
    add edx, dword ptr [0x583186]                # 00472e1b
    mov dword ptr [ebp - local_10], edx          # 00472e21
    push 0x54c560                                # 00472e24
    lea eax, [ebp - local_18]                    # 00472e29
    push eax                                     # 00472e2c
    mov ecx, dword ptr [ebp - local_4]           # 00472e2d
    add ecx, 0x25                                # 00472e30
    push ecx                                     # 00472e33
    mov edx, dword ptr [0x5cf665]                # 00472e34
    push edx                                     # 00472e3a
    movsx eax, word ptr [0x6245b4]               # 00472e3b
    imul eax, eax, 0x4a                          # 00472e42
    mov ecx, dword ptr [eax + 0x5d1599]          # 00472e45
    push ecx                                     # 00472e4b
    mov ecx, 0x5cf659                            # 00472e4c
    call FUN_004c5d4b                            # 00472e51
    mov byte ptr [0x6245b7], 0x1                 # 00472e56
    jmp.d8 L_00472ec2                            # 00472e5d
L_00472e5f:
    # block 0x00472e5f: entered by je at 0x00472de6, 28 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00472ec2
    mov edx, dword ptr [ebp - local_4]           # 00472e5f
    mov eax, dword ptr [edx + field_39]          # 00472e62
    add eax, dword ptr [0x58318a]                # 00472e65
    mov dword ptr [ebp - local_14], eax          # 00472e6b
    mov ecx, dword ptr [ebp - local_4]           # 00472e6e
    mov edx, dword ptr [ecx + field_41]          # 00472e71
    add edx, dword ptr [0x58318a]                # 00472e74
    mov dword ptr [ebp - local_c], edx           # 00472e7a
    mov eax, dword ptr [ebp - local_4]           # 00472e7d
    mov ecx, dword ptr [eax + field_35]          # 00472e80
    add ecx, dword ptr [0x583186]                # 00472e83
    mov dword ptr [ebp - local_18], ecx          # 00472e89
    mov edx, dword ptr [ebp - local_4]           # 00472e8c
    mov eax, dword ptr [edx + field_3d]          # 00472e8f
    add eax, dword ptr [0x583186]                # 00472e92
    mov dword ptr [ebp - local_10], eax          # 00472e98
    push 0x54c57c                                # 00472e9b
    lea ecx, [ebp - local_18]                    # 00472ea0
    push ecx                                     # 00472ea3
    mov edx, dword ptr [ebp - local_4]           # 00472ea4
    add edx, 0x35                                # 00472ea7
    push edx                                     # 00472eaa
    mov eax, dword ptr [0x5cf665]                # 00472eab
    push eax                                     # 00472eb0
    mov ecx, dword ptr [0x5d15e3]                # 00472eb1
    push ecx                                     # 00472eb7
    mov ecx, 0x5cf659                            # 00472eb8
    call FUN_004c5d4b                            # 00472ebd
L_00472ec2:
    # block 0x00472ec2: entered by je at 0x00472a83; jmp at 0x00472e5d, 4 instruction(s), ends with ret
    pop esi                                      # 00472ec2
    {load} mov esp, ebp                          # 00472ec3
    pop ebp                                      # 00472ec5
    ret                                          # 00472ec6

# --- data items (not part of the function) -------------------------
.org 0x00472ec7 - 0x401000
PAD_00472ec7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

