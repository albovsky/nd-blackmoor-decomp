# FUN_00480b34
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00480b34
# extent:       0x00480b34-0x00480e02 (718 code bytes)
# span:         0x00480b34-0x00480e02 (code 718, tables 0, padding 0)
# sha256:       dd337888e31ab3ac16f302b7fcefbfdd65fe4ac77c9a63d2dbdec752b26bd7f4
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00480b34
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_43, field_e9, field_ea, field_7a0, field_8e0, field_a13, field_13a2, field_13ca, field_1443; [ecx + n] field_43, field_47, field_ea, field_eb, field_7a0, field_8de, field_a11, field_13a2, field_13ce, field_1443; [edx + n] field_1e, field_43, field_45, field_5e, field_8de, field_a11
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 197 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_47, 0x47  # offset +0x47
.equ field_5e, 0x5e  # offset +0x5e
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ea, 0xea  # offset +0xea
.equ field_eb, 0xeb  # offset +0xeb
.equ field_7a0, 0x7a0  # offset +0x7a0
.equ field_8de, 0x8de  # offset +0x8de
.equ field_8e0, 0x8e0  # offset +0x8e0
.equ field_a11, 0xa11  # offset +0xa11
.equ field_a13, 0xa13  # offset +0xa13
.equ field_13a2, 0x13a2  # offset +0x13a2
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13ce, 0x13ce  # offset +0x13ce
.equ field_1443, 0x1443  # offset +0x1443

# --- external targets -----------------------------------------------

.org 0x00480b34 - 0x401000
.globl FUN_00480b34
FUN_00480b34:
    # block 0x00480b34: entry, 30 instruction(s), ends with forward jump to 0x00480bb9
    push ebp                                     # 00480b34
    {load} mov ebp, esp                          # 00480b35
    sub esp, 0xc                                 # 00480b37
    push ebx                                     # 00480b3a
    push esi                                     # 00480b3b
    push edi                                     # 00480b3c
    mov dword ptr [ebp - local_c], ecx           # 00480b3d
    mov eax, dword ptr [ebp - local_c]           # 00480b40
    movsx ecx, word ptr [eax + field_1e]         # 00480b43
    imul ecx, ecx, 0x8d                          # 00480b47
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00480b4d
    mov dword ptr [ebp - local_4], edx           # 00480b53
    mov eax, dword ptr [ebp - local_c]           # 00480b56
    mov word ptr [eax + field_1443], 0x0         # 00480b59
    mov dword ptr [0x5a055d], 0x1                # 00480b62
    mov esi, dword ptr [ebp - local_c]           # 00480b6c
    add esi, 0x7b4                               # 00480b6f
    mov ecx, 0x2e4                               # 00480b75
    mov edi, 0x5a0577                            # 00480b7a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00480b7f
    mov esi, dword ptr [ebp - local_c]           # 00480b81
    add esi, 0x7a0                               # 00480b84
    mov ecx, 0x5                                 # 00480b8a
    mov edi, 0x5a0563                            # 00480b8f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00480b94
    mov ecx, dword ptr [ebp - local_c]           # 00480b96
    mov dx, word ptr [ecx + field_13a2]          # 00480b99
    mov word ptr [0x5a1107], dx                  # 00480ba0
    mov dword ptr [ebp - local_8], 0x0           # 00480ba7
    jmp.d8 L_00480bb9                            # 00480bae
L_00480bb0:
    # block 0x00480bb0: entered by jmp at 0x00480c1f, 3 instruction(s), falls into the block at 0x00480bb9
    mov eax, dword ptr [ebp - local_8]           # 00480bb0
    add eax, 0x1                                 # 00480bb3
    mov dword ptr [ebp - local_8], eax           # 00480bb6
L_00480bb9:
    # block 0x00480bb9: entered by jmp at 0x00480bae, 4 instruction(s), ends with jge to 0x00480c21 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480bb9
    movsx edx, word ptr [ecx + field_43]         # 00480bbc
    cmp dword ptr [ebp - local_8], edx           # 00480bc0
    jge.d8 L_00480c21                            # 00480bc3
    # block 0x00480bc5: entered by fall-through of jge at 0x00480bc3, 6 instruction(s), ends with jl to 0x00480c1f (forward)
    mov eax, dword ptr [ebp - local_c]           # 00480bc5
    add eax, dword ptr [ebp - local_8]           # 00480bc8
    {load} xor ecx, ecx                          # 00480bcb
    mov cl, byte ptr [eax + field_7a0]           # 00480bcd
    cmp ecx, 0x1                                 # 00480bd3
    jl.d8 L_00480c1f                             # 00480bd6
    # block 0x00480bd8: entered by fall-through of jl at 0x00480bd6, 7 instruction(s), ends with je to 0x00480bfb (forward)
    mov edx, dword ptr [ebp - local_8]           # 00480bd8
    imul edx, edx, 0x53                          # 00480bdb
    mov eax, dword ptr [ebp - local_4]           # 00480bde
    {load} xor ecx, ecx                          # 00480be1
    mov cl, byte ptr [eax + edx + field_e9]      # 00480be3
    test ecx, ecx                                # 00480bea
    je.d8 L_00480bfb                             # 00480bec
    # block 0x00480bee: entered by fall-through of je at 0x00480bec, 5 instruction(s), ends with jne to 0x00480c1f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00480bee
    {load} xor eax, eax                          # 00480bf1
    mov al, byte ptr [edx + field_5e]            # 00480bf3
    cmp eax, 0x2                                 # 00480bf6
    jne.d8 L_00480c1f                            # 00480bf9
L_00480bfb:
    # block 0x00480bfb: entered by je at 0x00480bec; fall-through of jne at 0x00480bf9, 9 instruction(s), falls into the block at 0x00480c1f
    mov ecx, dword ptr [ebp - local_c]           # 00480bfb
    movsx edx, word ptr [ecx + field_1443]       # 00480bfe
    mov eax, dword ptr [ebp - local_c]           # 00480c05
    add eax, dword ptr [ebp - local_8]           # 00480c08
    {load} xor ecx, ecx                          # 00480c0b
    mov cl, byte ptr [eax + field_7a0]           # 00480c0d
    {load} add edx, ecx                          # 00480c13
    mov eax, dword ptr [ebp - local_c]           # 00480c15
    mov word ptr [eax + field_1443], dx          # 00480c18
L_00480c1f:
    # block 0x00480c1f: entered by jl at 0x00480bd6; jne at 0x00480bf9, 1 instruction(s), ends with backward jump to 0x00480bb0
    jmp.d8 L_00480bb0                            # 00480c1f
L_00480c21:
    # block 0x00480c21: entered by jge at 0x00480bc3, 19 instruction(s), ends with jl to 0x00480d59 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00480c21
    movsx edx, word ptr [ecx + field_1443]       # 00480c24
    mov eax, dword ptr [ebp - local_c]           # 00480c2b
    movsx ecx, word ptr [eax + field_13a2]       # 00480c2e
    {load} add edx, ecx                          # 00480c35
    mov eax, dword ptr [ebp - local_4]           # 00480c37
    movsx ecx, word ptr [eax + field_43]         # 00480c3a
    {load} sub edx, ecx                          # 00480c3e
    mov eax, dword ptr [ebp - local_c]           # 00480c40
    mov word ptr [eax + field_1443], dx          # 00480c43
    mov ecx, dword ptr [ebp - local_c]           # 00480c4a
    mov dx, word ptr [ecx + field_1443]          # 00480c4d
    mov word ptr [0x5a1109], dx                  # 00480c54
    mov eax, dword ptr [ebp - local_c]           # 00480c5b
    movsx ecx, word ptr [eax + field_1443]       # 00480c5e
    mov edx, dword ptr [ebp - local_4]           # 00480c65
    movsx eax, word ptr [edx + field_45]         # 00480c68
    {load} cmp ecx, eax                          # 00480c6c
    jl.d32 L_00480d59                            # 00480c6e
    # block 0x00480c74: entered by fall-through of jl at 0x00480c6e, 4 instruction(s), ends with je to 0x00480c9f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480c74
    movsx edx, word ptr [ecx + field_a11]        # 00480c77
    cmp edx, -0x1                                # 00480c7e
    je.d8 L_00480c9f                             # 00480c81
    # block 0x00480c83: entered by fall-through of je at 0x00480c81, 6 instruction(s), falls into the block at 0x00480c9f
    mov eax, dword ptr [ebp - local_4]           # 00480c83
    {load} xor ecx, ecx                          # 00480c86
    mov cl, byte ptr [eax + field_a13]           # 00480c88
    mov edx, dword ptr [ebp - local_4]           # 00480c8e
    movsx eax, word ptr [edx + field_a11]        # 00480c91
    mov dword ptr [4*eax + 0x585801], ecx        # 00480c98
L_00480c9f:
    # block 0x00480c9f: entered by je at 0x00480c81, 4 instruction(s), ends with je to 0x00480ccf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480c9f
    movsx edx, word ptr [ecx + field_8de]        # 00480ca2
    cmp edx, -0x1                                # 00480ca9
    je.d8 L_00480ccf                             # 00480cac
    # block 0x00480cae: entered by fall-through of je at 0x00480cac, 9 instruction(s), falls into the block at 0x00480ccf
    mov eax, dword ptr [ebp - local_4]           # 00480cae
    {load} xor ecx, ecx                          # 00480cb1
    mov cl, byte ptr [eax + field_8e0]           # 00480cb3
    neg ecx                                      # 00480cb9
    {load} sbb ecx, ecx                          # 00480cbb
    inc ecx                                      # 00480cbd
    mov edx, dword ptr [ebp - local_4]           # 00480cbe
    movsx eax, word ptr [edx + field_8de]        # 00480cc1
    mov dword ptr [4*eax + 0x585801], ecx        # 00480cc8
L_00480ccf:
    # block 0x00480ccf: entered by je at 0x00480cac, 2 instruction(s), ends with forward jump to 0x00480ce1
    mov dword ptr [ebp - local_8], 0x0           # 00480ccf
    jmp.d8 L_00480ce1                            # 00480cd6
L_00480cd8:
    # block 0x00480cd8: entered by jmp at 0x00480d55, 3 instruction(s), falls into the block at 0x00480ce1
    mov ecx, dword ptr [ebp - local_8]           # 00480cd8
    add ecx, 0x1                                 # 00480cdb
    mov dword ptr [ebp - local_8], ecx           # 00480cde
L_00480ce1:
    # block 0x00480ce1: entered by jmp at 0x00480cd6, 4 instruction(s), ends with jge to 0x00480d57 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00480ce1
    movsx eax, word ptr [edx + field_43]         # 00480ce4
    cmp dword ptr [ebp - local_8], eax           # 00480ce8
    jge.d8 L_00480d57                            # 00480ceb
    # block 0x00480ced: entered by fall-through of jge at 0x00480ceb, 6 instruction(s), ends with jl to 0x00480d16 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00480ced
    add ecx, dword ptr [ebp - local_8]           # 00480cf0
    {load} xor edx, edx                          # 00480cf3
    mov dl, byte ptr [ecx + field_7a0]           # 00480cf5
    cmp edx, 0x1                                 # 00480cfb
    jl.d8 L_00480d16                             # 00480cfe
    # block 0x00480d00: entered by fall-through of jl at 0x00480cfe, 7 instruction(s), ends with jne to 0x00480d50 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00480d00
    imul eax, eax, 0x53                          # 00480d03
    mov ecx, dword ptr [ebp - local_4]           # 00480d06
    {load} xor edx, edx                          # 00480d09
    mov dl, byte ptr [ecx + eax + field_eb]      # 00480d0b
    test edx, edx                                # 00480d12
    jne.d8 L_00480d50                            # 00480d14
L_00480d16:
    # block 0x00480d16: entered by jl at 0x00480cfe; fall-through of jne at 0x00480d14, 7 instruction(s), ends with jle to 0x00480d55 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00480d16
    imul eax, eax, 0x53                          # 00480d19
    mov ecx, dword ptr [ebp - local_4]           # 00480d1c
    {load} xor edx, edx                          # 00480d1f
    mov dl, byte ptr [ecx + eax + field_ea]      # 00480d21
    test edx, edx                                # 00480d28
    jle.d8 L_00480d55                            # 00480d2a
    # block 0x00480d2c: entered by fall-through of jle at 0x00480d2a, 11 instruction(s), ends with je to 0x00480d55 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00480d2c
    add eax, dword ptr [ebp - local_8]           # 00480d2f
    {load} xor ecx, ecx                          # 00480d32
    mov cl, byte ptr [eax + field_7a0]           # 00480d34
    mov edx, dword ptr [ebp - local_8]           # 00480d3a
    imul edx, edx, 0x53                          # 00480d3d
    mov eax, dword ptr [ebp - local_4]           # 00480d40
    {load} xor ebx, ebx                          # 00480d43
    mov bl, byte ptr [eax + edx + field_ea]      # 00480d45
    {load} cmp ecx, ebx                          # 00480d4c
    je.d8 L_00480d55                             # 00480d4e
L_00480d50:
    # block 0x00480d50: entered by jne at 0x00480d14; fall-through of je at 0x00480d4e, 1 instruction(s), ends with forward jump to 0x00480dfb
    jmp.d32 L_00480dfb                           # 00480d50
L_00480d55:
    # block 0x00480d55: entered by jle at 0x00480d2a; je at 0x00480d4e, 1 instruction(s), ends with backward jump to 0x00480cd8
    jmp.d8 L_00480cd8                            # 00480d55
L_00480d57:
    # block 0x00480d57: entered by jge at 0x00480ceb, 1 instruction(s), ends with forward jump to 0x00480d8b
    jmp.d8 L_00480d8b                            # 00480d57
L_00480d59:
    # block 0x00480d59: entered by jl at 0x00480c6e, 4 instruction(s), ends with je to 0x00480d89 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480d59
    movsx edx, word ptr [ecx + field_a11]        # 00480d5c
    cmp edx, -0x1                                # 00480d63
    je.d8 L_00480d89                             # 00480d66
    # block 0x00480d68: entered by fall-through of je at 0x00480d66, 9 instruction(s), falls into the block at 0x00480d89
    mov eax, dword ptr [ebp - local_4]           # 00480d68
    {load} xor ecx, ecx                          # 00480d6b
    mov cl, byte ptr [eax + field_a13]           # 00480d6d
    neg ecx                                      # 00480d73
    {load} sbb ecx, ecx                          # 00480d75
    inc ecx                                      # 00480d77
    mov edx, dword ptr [ebp - local_4]           # 00480d78
    movsx eax, word ptr [edx + field_a11]        # 00480d7b
    mov dword ptr [4*eax + 0x585801], ecx        # 00480d82
L_00480d89:
    # block 0x00480d89: entered by je at 0x00480d66, 1 instruction(s), ends with forward jump to 0x00480dfb
    jmp.d8 L_00480dfb                            # 00480d89
L_00480d8b:
    # block 0x00480d8b: entered by jmp at 0x00480d57, 4 instruction(s), ends with je to 0x00480db6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480d8b
    movsx edx, word ptr [ecx + field_8de]        # 00480d8e
    cmp edx, -0x1                                # 00480d95
    je.d8 L_00480db6                             # 00480d98
    # block 0x00480d9a: entered by fall-through of je at 0x00480d98, 6 instruction(s), falls into the block at 0x00480db6
    mov eax, dword ptr [ebp - local_4]           # 00480d9a
    {load} xor ecx, ecx                          # 00480d9d
    mov cl, byte ptr [eax + field_8e0]           # 00480d9f
    mov edx, dword ptr [ebp - local_4]           # 00480da5
    movsx eax, word ptr [edx + field_8de]        # 00480da8
    mov dword ptr [4*eax + 0x585801], ecx        # 00480daf
L_00480db6:
    # block 0x00480db6: entered by je at 0x00480d98, 5 instruction(s), ends with je to 0x00480ddb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00480db6
    {load} xor edx, edx                          # 00480db9
    mov dl, byte ptr [ecx + field_47]            # 00480dbb
    test edx, edx                                # 00480dbe
    je.d8 L_00480ddb                             # 00480dc0
    # block 0x00480dc2: entered by fall-through of je at 0x00480dc0, 5 instruction(s), ends with forward jump to 0x00480dfb
    mov eax, dword ptr [ebp - local_c]           # 00480dc2
    mov dword ptr [eax + field_13ca], 0x6        # 00480dc5
    mov ecx, dword ptr [ebp - local_c]           # 00480dcf
    mov byte ptr [ecx + field_13ce], 0x1         # 00480dd2
    jmp.d8 L_00480dfb                            # 00480dd9
L_00480ddb:
    # block 0x00480ddb: entered by je at 0x00480dc0, 5 instruction(s), ends with jne to 0x00480dfb (forward)
    mov edx, dword ptr [ebp - local_c]           # 00480ddb
    movsx eax, word ptr [edx + field_1e]         # 00480dde
    imul eax, eax, 0x8d                          # 00480de2
    cmp dword ptr [eax + 0x5bb632], 0x2          # 00480de8
    jne.d8 L_00480dfb                            # 00480def
    # block 0x00480df1: entered by fall-through of jne at 0x00480def, 2 instruction(s), falls into the block at 0x00480dfb
    mov ecx, dword ptr [ebp - local_c]           # 00480df1
    mov byte ptr [ecx + field_13ce], 0x1         # 00480df4
L_00480dfb:
    # block 0x00480dfb: entered by jmp at 0x00480d50; jmp at 0x00480d89; jmp at 0x00480dd9; jne at 0x00480def, 6 instruction(s), ends with ret
    pop edi                                      # 00480dfb
    pop esi                                      # 00480dfc
    pop ebx                                      # 00480dfd
    {load} mov esp, ebp                          # 00480dfe
    pop ebp                                      # 00480e00
    ret                                          # 00480e01

