# FUN_00415aea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415aea
# extent:       0x00415aea-0x00415db9 (719 code bytes)
# span:         0x00415aea-0x00415db9 (code 719, tables 0, padding 0)
# sha256:       786b0a43aead5b0b452cfe21e344ccd30cc7253c52f293e4a287255f661732f1
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m415aea_lifted
# naming:       native port src/original_methods_fl40.c:m415aea_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 201/201 instructions executed, 14/14 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_103c, local_1040 and 6 more
# fields:       [eax + n] field_21, field_2d, field_39; [ecx + n] field_2
# callees:      calls FUN_0050c920
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m415aea_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 201 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_103c, 0x103c  # offset -0x103c
.equ local_1040, 0x1040  # offset -0x1040
.equ local_1044, 0x1044  # offset -0x1044
.equ local_1048, 0x1048  # offset -0x1048
.equ local_104c, 0x104c  # offset -0x104c
.equ local_1050, 0x1050  # offset -0x1050
.equ local_1054, 0x1054  # offset -0x1054
.equ local_1058, 0x1058  # offset -0x1058
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_2d, 0x2d  # offset +0x2d
.equ field_39, 0x39  # offset +0x39

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00415aea - 0x401000
.globl FUN_00415aea
FUN_00415aea:
    # block 0x00415aea: entry, 41 instruction(s), calls FUN_0050c920, falls into the block at 0x00415b95
    push ebp                                     # 00415aea
    {load} mov ebp, esp                          # 00415aeb
    mov eax, 0x1058                              # 00415aed
    call FUN_0050c920                            # 00415af2
    push edi                                     # 00415af7
    mov dword ptr [ebp - local_1058], ecx        # 00415af8
    mov eax, dword ptr [ebp + arg_8]             # 00415afe
    mov ecx, dword ptr [eax + field_39]          # 00415b01
    mov dword ptr [ebp - local_1050], ecx        # 00415b04
    movsx edx, word ptr [ebp + arg_c]            # 00415b0a
    imul edx, edx, 0x13                          # 00415b0e
    mov eax, dword ptr [ebp + arg_8]             # 00415b11
    mov ecx, dword ptr [eax + field_21]          # 00415b14
    mov eax, dword ptr [ebp + arg_8]             # 00415b17
    mov eax, dword ptr [eax + field_2d]          # 00415b1a
    add eax, dword ptr [ecx + edx + field_2]     # 00415b1d
    mov dword ptr [ebp - local_1c], eax          # 00415b21
    mov ecx, dword ptr [ebp + arg_10]            # 00415b24
    mov dword ptr [ebp - local_1054], ecx        # 00415b27
    lea edx, [ebp - local_103c]                  # 00415b2d
    mov dword ptr [ebp - local_14], edx          # 00415b33
    mov byte ptr [ebp - local_10], 0x0           # 00415b36
    mov dword ptr [ebp - local_18], 0x0          # 00415b3a
    mov dword ptr [ebp - local_24], 0xffffffff   # 00415b41
    mov dword ptr [ebp - local_1048], 0x1000     # 00415b48
    mov dword ptr [ebp - local_c], 0x12          # 00415b52
    mov dword ptr [ebp - local_20], 0x2          # 00415b59
    mov ecx, dword ptr [ebp - local_1048]        # 00415b60
    sub ecx, dword ptr [ebp - local_c]           # 00415b66
    mov eax, 0x20202020                          # 00415b69
    lea edi, [ebp - local_103c]                  # 00415b6e
    {load} mov edx, ecx                          # 00415b74
    shr ecx, 0x2                                 # 00415b76
    rep stosd dword ptr es:[edi], eax            # 00415b79
    {load} mov ecx, edx                          # 00415b7b
    and ecx, 0x3                                 # 00415b7d
    rep stosb byte ptr es:[edi], al              # 00415b80
    mov eax, dword ptr [ebp - local_1048]        # 00415b82
    sub eax, dword ptr [ebp - local_c]           # 00415b88
    mov dword ptr [ebp - local_8], eax           # 00415b8b
    mov dword ptr [ebp - local_4], 0x0           # 00415b8e
L_00415b95:
    # block 0x00415b95: entered by jmp at 0x00415dad, 7 instruction(s), ends with jne to 0x00415bee (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00415b95
    shr ecx                                      # 00415b98
    mov dword ptr [ebp - local_4], ecx           # 00415b9a
    mov edx, dword ptr [ebp - local_4]           # 00415b9d
    and edx, 0x100                               # 00415ba0
    test edx, edx                                # 00415ba6
    jne.d8 L_00415bee                            # 00415ba8
    # block 0x00415baa: entered by fall-through of jne at 0x00415ba8, 6 instruction(s), ends with jne to 0x00415bc3 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00415baa
    add eax, 0x1                                 # 00415bad
    mov dword ptr [ebp - local_24], eax          # 00415bb0
    mov ecx, dword ptr [ebp - local_24]          # 00415bb3
    cmp ecx, dword ptr [ebp - local_1050]        # 00415bb6
    jne.d8 L_00415bc3                            # 00415bbc
    # block 0x00415bbe: entered by fall-through of jne at 0x00415bbc, 1 instruction(s), ends with forward jump to 0x00415db2
    jmp.d32 L_00415db2                           # 00415bbe
L_00415bc3:
    # block 0x00415bc3: entered by jne at 0x00415bbc, 14 instruction(s), falls into the block at 0x00415bee
    mov edx, dword ptr [ebp - local_1c]          # 00415bc3
    add edx, dword ptr [ebp - local_24]          # 00415bc6
    mov al, byte ptr [edx]                       # 00415bc9
    mov byte ptr [ebp - local_28], al            # 00415bcb
    mov cl, byte ptr [ebp - local_28]            # 00415bce
    sub cl, byte ptr [ebp - local_10]            # 00415bd1
    mov byte ptr [ebp - local_28], cl            # 00415bd4
    mov dl, byte ptr [ebp - local_10]            # 00415bd7
    add dl, 0x1                                  # 00415bda
    mov byte ptr [ebp - local_10], dl            # 00415bdd
    mov eax, dword ptr [ebp - local_28]          # 00415be0
    and eax, 0xff                                # 00415be3
    or ah, -0x1                                  # 00415be8
    mov dword ptr [ebp - local_4], eax           # 00415beb
L_00415bee:
    # block 0x00415bee: entered by jne at 0x00415ba8, 4 instruction(s), ends with je to 0x00415c6f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00415bee
    and ecx, 0x1                                 # 00415bf1
    test ecx, ecx                                # 00415bf4
    je.d8 L_00415c6f                             # 00415bf6
    # block 0x00415bf8: entered by fall-through of je at 0x00415bf6, 6 instruction(s), ends with jne to 0x00415c11 (forward)
    mov edx, dword ptr [ebp - local_24]          # 00415bf8
    add edx, 0x1                                 # 00415bfb
    mov dword ptr [ebp - local_24], edx          # 00415bfe
    mov eax, dword ptr [ebp - local_24]          # 00415c01
    cmp eax, dword ptr [ebp - local_1050]        # 00415c04
    jne.d8 L_00415c11                            # 00415c0a
    # block 0x00415c0c: entered by fall-through of jne at 0x00415c0a, 1 instruction(s), ends with forward jump to 0x00415db2
    jmp.d32 L_00415db2                           # 00415c0c
L_00415c11:
    # block 0x00415c11: entered by jne at 0x00415c0a, 30 instruction(s), ends with forward jump to 0x00415dad
    mov ecx, dword ptr [ebp - local_1c]          # 00415c11
    add ecx, dword ptr [ebp - local_24]          # 00415c14
    mov dl, byte ptr [ecx]                       # 00415c17
    mov byte ptr [ebp - local_28], dl            # 00415c19
    mov al, byte ptr [ebp - local_28]            # 00415c1c
    sub al, byte ptr [ebp - local_10]            # 00415c1f
    mov byte ptr [ebp - local_28], al            # 00415c22
    mov cl, byte ptr [ebp - local_10]            # 00415c25
    add cl, 0x1                                  # 00415c28
    mov byte ptr [ebp - local_10], cl            # 00415c2b
    mov edx, dword ptr [ebp - local_1054]        # 00415c2e
    add edx, dword ptr [ebp - local_18]          # 00415c34
    mov al, byte ptr [ebp - local_28]            # 00415c37
    mov byte ptr [edx], al                       # 00415c3a
    mov ecx, dword ptr [ebp - local_18]          # 00415c3c
    add ecx, 0x1                                 # 00415c3f
    mov dword ptr [ebp - local_18], ecx          # 00415c42
    mov edx, dword ptr [ebp - local_14]          # 00415c45
    add edx, dword ptr [ebp - local_8]           # 00415c48
    mov al, byte ptr [ebp - local_28]            # 00415c4b
    mov byte ptr [edx], al                       # 00415c4e
    mov ecx, dword ptr [ebp - local_8]           # 00415c50
    add ecx, 0x1                                 # 00415c53
    mov dword ptr [ebp - local_8], ecx           # 00415c56
    mov edx, dword ptr [ebp - local_1048]        # 00415c59
    sub edx, 0x1                                 # 00415c5f
    mov eax, dword ptr [ebp - local_8]           # 00415c62
    {load} and eax, edx                          # 00415c65
    mov dword ptr [ebp - local_8], eax           # 00415c67
    jmp.d32 L_00415dad                           # 00415c6a
L_00415c6f:
    # block 0x00415c6f: entered by je at 0x00415bf6, 6 instruction(s), ends with jne to 0x00415c88 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00415c6f
    add ecx, 0x1                                 # 00415c72
    mov dword ptr [ebp - local_24], ecx          # 00415c75
    mov edx, dword ptr [ebp - local_24]          # 00415c78
    cmp edx, dword ptr [ebp - local_1050]        # 00415c7b
    jne.d8 L_00415c88                            # 00415c81
    # block 0x00415c83: entered by fall-through of jne at 0x00415c81, 1 instruction(s), ends with forward jump to 0x00415db2
    jmp.d32 L_00415db2                           # 00415c83
L_00415c88:
    # block 0x00415c88: entered by jne at 0x00415c81, 19 instruction(s), ends with jne to 0x00415ccc (forward)
    mov eax, dword ptr [ebp - local_1c]          # 00415c88
    add eax, dword ptr [ebp - local_24]          # 00415c8b
    mov cl, byte ptr [eax]                       # 00415c8e
    mov byte ptr [ebp - local_28], cl            # 00415c90
    mov dl, byte ptr [ebp - local_28]            # 00415c93
    sub dl, byte ptr [ebp - local_10]            # 00415c96
    mov byte ptr [ebp - local_28], dl            # 00415c99
    mov al, byte ptr [ebp - local_10]            # 00415c9c
    add al, 0x1                                  # 00415c9f
    mov byte ptr [ebp - local_10], al            # 00415ca1
    mov ecx, dword ptr [ebp - local_28]          # 00415ca4
    and ecx, 0xff                                # 00415ca7
    mov dword ptr [ebp - local_1040], ecx        # 00415cad
    mov edx, dword ptr [ebp - local_24]          # 00415cb3
    add edx, 0x1                                 # 00415cb6
    mov dword ptr [ebp - local_24], edx          # 00415cb9
    mov eax, dword ptr [ebp - local_24]          # 00415cbc
    cmp eax, dword ptr [ebp - local_1050]        # 00415cbf
    jne.d8 L_00415ccc                            # 00415cc5
    # block 0x00415cc7: entered by fall-through of jne at 0x00415cc5, 1 instruction(s), ends with forward jump to 0x00415db2
    jmp.d32 L_00415db2                           # 00415cc7
L_00415ccc:
    # block 0x00415ccc: entered by jne at 0x00415cc5, 25 instruction(s), ends with forward jump to 0x00415d41
    mov ecx, dword ptr [ebp - local_1c]          # 00415ccc
    add ecx, dword ptr [ebp - local_24]          # 00415ccf
    mov dl, byte ptr [ecx]                       # 00415cd2
    mov byte ptr [ebp - local_28], dl            # 00415cd4
    mov al, byte ptr [ebp - local_28]            # 00415cd7
    sub al, byte ptr [ebp - local_10]            # 00415cda
    mov byte ptr [ebp - local_28], al            # 00415cdd
    mov cl, byte ptr [ebp - local_10]            # 00415ce0
    add cl, 0x1                                  # 00415ce3
    mov byte ptr [ebp - local_10], cl            # 00415ce6
    mov edx, dword ptr [ebp - local_28]          # 00415ce9
    and edx, 0xff                                # 00415cec
    mov dword ptr [ebp - local_1044], edx        # 00415cf2
    mov eax, dword ptr [ebp - local_1044]        # 00415cf8
    and eax, 0xf0                                # 00415cfe
    shl eax, 0x4                                 # 00415d03
    mov ecx, dword ptr [ebp - local_1040]        # 00415d06
    {load} or ecx, eax                           # 00415d0c
    mov dword ptr [ebp - local_1040], ecx        # 00415d0e
    mov edx, dword ptr [ebp - local_1044]        # 00415d14
    and edx, 0xf                                 # 00415d1a
    add edx, dword ptr [ebp - local_20]          # 00415d1d
    mov dword ptr [ebp - local_1044], edx        # 00415d20
    mov dword ptr [ebp - local_104c], 0x0        # 00415d26
    jmp.d8 L_00415d41                            # 00415d30
L_00415d32:
    # block 0x00415d32: entered by jmp at 0x00415dab, 3 instruction(s), falls into the block at 0x00415d41
    mov eax, dword ptr [ebp - local_104c]        # 00415d32
    add eax, 0x1                                 # 00415d38
    mov dword ptr [ebp - local_104c], eax        # 00415d3b
L_00415d41:
    # block 0x00415d41: entered by jmp at 0x00415d30, 3 instruction(s), ends with ja to 0x00415dad (forward)
    mov ecx, dword ptr [ebp - local_104c]        # 00415d41
    cmp ecx, dword ptr [ebp - local_1044]        # 00415d47
    ja.d8 L_00415dad                             # 00415d4d
    # block 0x00415d4f: entered by fall-through of ja at 0x00415d4d, 28 instruction(s), ends with backward jump to 0x00415d32
    mov edx, dword ptr [ebp - local_1040]        # 00415d4f
    add edx, dword ptr [ebp - local_104c]        # 00415d55
    mov eax, dword ptr [ebp - local_1048]        # 00415d5b
    sub eax, 0x1                                 # 00415d61
    {load} and edx, eax                          # 00415d64
    mov ecx, dword ptr [ebp - local_14]          # 00415d66
    mov dl, byte ptr [ecx + edx]                 # 00415d69
    mov byte ptr [ebp - local_28], dl            # 00415d6c
    mov eax, dword ptr [ebp - local_1054]        # 00415d6f
    add eax, dword ptr [ebp - local_18]          # 00415d75
    mov cl, byte ptr [ebp - local_28]            # 00415d78
    mov byte ptr [eax], cl                       # 00415d7b
    mov edx, dword ptr [ebp - local_18]          # 00415d7d
    add edx, 0x1                                 # 00415d80
    mov dword ptr [ebp - local_18], edx          # 00415d83
    mov eax, dword ptr [ebp - local_14]          # 00415d86
    add eax, dword ptr [ebp - local_8]           # 00415d89
    mov cl, byte ptr [ebp - local_28]            # 00415d8c
    mov byte ptr [eax], cl                       # 00415d8f
    mov edx, dword ptr [ebp - local_8]           # 00415d91
    add edx, 0x1                                 # 00415d94
    mov dword ptr [ebp - local_8], edx           # 00415d97
    mov eax, dword ptr [ebp - local_1048]        # 00415d9a
    sub eax, 0x1                                 # 00415da0
    mov ecx, dword ptr [ebp - local_8]           # 00415da3
    {load} and ecx, eax                          # 00415da6
    mov dword ptr [ebp - local_8], ecx           # 00415da8
    jmp.d8 L_00415d32                            # 00415dab
L_00415dad:
    # block 0x00415dad: entered by jmp at 0x00415c6a; ja at 0x00415d4d, 1 instruction(s), ends with backward jump to 0x00415b95
    jmp.d32 L_00415b95                           # 00415dad
L_00415db2:
    # block 0x00415db2: entered by jmp at 0x00415bbe; jmp at 0x00415c0c; jmp at 0x00415c83; jmp at 0x00415cc7, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 00415db2
    {load} mov esp, ebp                          # 00415db3
    pop ebp                                      # 00415db5
    ret 0xc                                      # 00415db6

