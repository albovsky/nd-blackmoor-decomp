# FUN_004c5b3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c5b3a
# extent:       0x004c5b3a-0x004c5d4b (529 code bytes)
# span:         0x004c5b3a-0x004c5d4b (code 529, tables 0, padding 0)
# sha256:       d7cb8e7864115f36b6b300d69c93dd9b85a9f7741eb7bcc20e69787a6b63737c
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c5b3a_copy_keyed
# naming:       native port src/original_methods_fl30b.c:m4c5b3a_copy_keyed (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Colour-keyed word copy between two surface descriptors, size-equality report under the debug word; all instructions and jump directions run; a null descriptor is a native rejection. See fl30b-handoff.md.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       15 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_124, local_128 and 3 more
# fields:       [eax + n] field_4, field_8, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c, field_2f, field_38d0
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30b.c:m4c5b3a_copy_keyed (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 166 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f
.equ field_38d0, 0x38d0  # offset +0x38d0

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c5b3a - 0x401000
.globl FUN_004c5b3a
FUN_004c5b3a:
    # block 0x004c5b3a: entry, 7 instruction(s), ends with je to 0x004c5c2e (forward)
    push ebp                                     # 004c5b3a
    {load} mov ebp, esp                          # 004c5b3b
    sub esp, 0x134                               # 004c5b3d
    mov dword ptr [ebp - local_134], ecx         # 004c5b43
    movsx eax, word ptr [0x63a4cd]               # 004c5b49
    test eax, eax                                # 004c5b50
    je.d32 L_004c5c2e                            # 004c5b52
    # block 0x004c5b58: entered by fall-through of je at 0x004c5b52, 23 instruction(s), ends with jne to 0x004c5bc0 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c5b58
    mov edx, dword ptr [ebp + arg_10]            # 004c5b5b
    mov eax, dword ptr [ecx + field_8]           # 004c5b5e
    sub eax, dword ptr [edx]                     # 004c5b61
    mov dword ptr [ebp - local_130], eax         # 004c5b63
    mov ecx, dword ptr [ebp + arg_10]            # 004c5b69
    mov edx, dword ptr [ebp + arg_10]            # 004c5b6c
    mov eax, dword ptr [ecx + field_c]           # 004c5b6f
    sub eax, dword ptr [edx + field_4]           # 004c5b72
    mov dword ptr [ebp - local_12c], eax         # 004c5b75
    mov ecx, dword ptr [ebp + arg_14]            # 004c5b7b
    mov edx, dword ptr [ebp + arg_14]            # 004c5b7e
    mov eax, dword ptr [ecx + field_8]           # 004c5b81
    sub eax, dword ptr [edx]                     # 004c5b84
    mov dword ptr [ebp - local_28], eax          # 004c5b86
    mov ecx, dword ptr [ebp + arg_14]            # 004c5b89
    mov edx, dword ptr [ebp + arg_14]            # 004c5b8c
    mov eax, dword ptr [ecx + field_c]           # 004c5b8f
    sub eax, dword ptr [edx + field_4]           # 004c5b92
    mov dword ptr [ebp - local_128], eax         # 004c5b95
    mov ecx, dword ptr [ebp - local_130]         # 004c5b9b
    cmp ecx, dword ptr [ebp - local_28]          # 004c5ba1
    jne.d8 L_004c5bc0                            # 004c5ba4
    # block 0x004c5ba6: entered by fall-through of jne at 0x004c5ba4, 3 instruction(s), ends with jne to 0x004c5bc0 (forward)
    mov edx, dword ptr [ebp - local_12c]         # 004c5ba6
    cmp edx, dword ptr [ebp - local_128]         # 004c5bac
    jne.d8 L_004c5bc0                            # 004c5bb2
    # block 0x004c5bb4: entered by fall-through of jne at 0x004c5bb2, 2 instruction(s), ends with je to 0x004c5bc0 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c5bb4
    je.d8 L_004c5bc0                             # 004c5bb8
    # block 0x004c5bba: entered by fall-through of je at 0x004c5bb8, 2 instruction(s), ends with jne to 0x004c5c2e (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c5bba
    jne.d8 L_004c5c2e                            # 004c5bbe
L_004c5bc0:
    # block 0x004c5bc0: entered by jne at 0x004c5ba4; jne at 0x004c5bb2; je at 0x004c5bb8; fall-through of jne at 0x004c5bbe, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c5d45
    mov eax, dword ptr [ebp + arg_14]            # 004c5bc0
    mov ecx, dword ptr [eax + field_c]           # 004c5bc3
    push ecx                                     # 004c5bc6
    mov edx, dword ptr [ebp + arg_14]            # 004c5bc7
    mov eax, dword ptr [edx + field_8]           # 004c5bca
    push eax                                     # 004c5bcd
    mov ecx, dword ptr [ebp + arg_14]            # 004c5bce
    mov edx, dword ptr [ecx + field_4]           # 004c5bd1
    push edx                                     # 004c5bd4
    mov eax, dword ptr [ebp + arg_14]            # 004c5bd5
    mov ecx, dword ptr [eax]                     # 004c5bd8
    push ecx                                     # 004c5bda
    mov edx, dword ptr [ebp + arg_10]            # 004c5bdb
    mov eax, dword ptr [edx + field_c]           # 004c5bde
    push eax                                     # 004c5be1
    mov ecx, dword ptr [ebp + arg_10]            # 004c5be2
    mov edx, dword ptr [ecx + field_8]           # 004c5be5
    push edx                                     # 004c5be8
    mov eax, dword ptr [ebp + arg_10]            # 004c5be9
    mov ecx, dword ptr [eax + field_4]           # 004c5bec
    push ecx                                     # 004c5bef
    mov edx, dword ptr [ebp + arg_10]            # 004c5bf0
    mov eax, dword ptr [edx]                     # 004c5bf3
    push eax                                     # 004c5bf5
    mov ecx, dword ptr [ebp + arg_18]            # 004c5bf6
    push ecx                                     # 004c5bf9
    push 0x554be8                                # 004c5bfa
    lea edx, [ebp - local_124]                   # 004c5bff
    push edx                                     # 004c5c05
    call FUN_0050ca3e                            # 004c5c06
    add esp, 0x2c                                # 004c5c0b
    push 0x0                                     # 004c5c0e
    push 0x0                                     # 004c5c10
    lea eax, [ebp - local_124]                   # 004c5c12
    push eax                                     # 004c5c18
    call FUN_0052139c                            # 004c5c19
    mov ecx, dword ptr [ebp - local_134]         # 004c5c1e
    call FUN_004c97b4                            # 004c5c24
    jmp.d32 L_004c5d45                           # 004c5c29
L_004c5c2e:
    # block 0x004c5c2e: entered by je at 0x004c5b52; jne at 0x004c5bbe, 50 instruction(s), ends with forward jump to 0x004c5cd7
    mov ecx, dword ptr [ebp + arg_8]             # 004c5c2e
    movsx edx, word ptr [ecx + field_2f]         # 004c5c31
    mov dword ptr [ebp - local_18], edx          # 004c5c35
    mov eax, dword ptr [ebp + arg_c]             # 004c5c38
    movsx ecx, word ptr [eax + field_2f]         # 004c5c3b
    mov dword ptr [ebp - local_10], ecx          # 004c5c3f
    mov edx, dword ptr [ebp + arg_8]             # 004c5c42
    movsx eax, word ptr [edx + field_2f]         # 004c5c45
    mov ecx, dword ptr [ebp + arg_10]            # 004c5c49
    mov edx, dword ptr [ecx + field_4]           # 004c5c4c
    imul edx, eax                                # 004c5c4f
    mov eax, dword ptr [ebp + arg_8]             # 004c5c52
    mov ecx, dword ptr [eax]                     # 004c5c55
    {load} add ecx, edx                          # 004c5c57
    movsx edx, word ptr [0x639895]               # 004c5c59
    mov eax, dword ptr [ebp + arg_10]            # 004c5c60
    mov eax, dword ptr [eax]                     # 004c5c63
    imul eax, edx                                # 004c5c65
    {load} add ecx, eax                          # 004c5c68
    mov dword ptr [ebp - local_4], ecx           # 004c5c6a
    mov ecx, dword ptr [ebp + arg_c]             # 004c5c6d
    movsx edx, word ptr [ecx + field_2f]         # 004c5c70
    mov eax, dword ptr [ebp + arg_14]            # 004c5c74
    mov ecx, dword ptr [eax + field_4]           # 004c5c77
    imul ecx, edx                                # 004c5c7a
    mov edx, dword ptr [ebp + arg_c]             # 004c5c7d
    mov eax, dword ptr [edx]                     # 004c5c80
    {load} add eax, ecx                          # 004c5c82
    movsx ecx, word ptr [0x639895]               # 004c5c84
    mov edx, dword ptr [ebp + arg_14]            # 004c5c8b
    mov edx, dword ptr [edx]                     # 004c5c8e
    imul edx, ecx                                # 004c5c90
    {load} add eax, edx                          # 004c5c93
    mov dword ptr [ebp - local_c], eax           # 004c5c95
    mov eax, dword ptr [ebp + arg_10]            # 004c5c98
    mov ecx, dword ptr [ebp + arg_10]            # 004c5c9b
    mov edx, dword ptr [eax + field_c]           # 004c5c9e
    sub edx, dword ptr [ecx + field_4]           # 004c5ca1
    add edx, 0x1                                 # 004c5ca4
    mov dword ptr [ebp - local_1c], edx          # 004c5ca7
    mov eax, dword ptr [ebp + arg_10]            # 004c5caa
    mov ecx, dword ptr [ebp + arg_10]            # 004c5cad
    mov edx, dword ptr [eax + field_8]           # 004c5cb0
    sub edx, dword ptr [ecx]                     # 004c5cb3
    add edx, 0x1                                 # 004c5cb5
    movsx eax, word ptr [0x639895]               # 004c5cb8
    imul edx, eax                                # 004c5cbf
    mov dword ptr [ebp - local_8], edx           # 004c5cc2
    mov dword ptr [ebp - local_20], 0x0          # 004c5cc5
    jmp.d8 L_004c5cd7                            # 004c5ccc
L_004c5cce:
    # block 0x004c5cce: entered by jmp at 0x004c5d43, 3 instruction(s), falls into the block at 0x004c5cd7
    mov ecx, dword ptr [ebp - local_20]          # 004c5cce
    add ecx, 0x1                                 # 004c5cd1
    mov dword ptr [ebp - local_20], ecx          # 004c5cd4
L_004c5cd7:
    # block 0x004c5cd7: entered by jmp at 0x004c5ccc, 3 instruction(s), ends with jge to 0x004c5d45 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004c5cd7
    cmp edx, dword ptr [ebp - local_1c]          # 004c5cda
    jge.d8 L_004c5d45                            # 004c5cdd
    # block 0x004c5cdf: entered by fall-through of jge at 0x004c5cdd, 2 instruction(s), ends with forward jump to 0x004c5cf1
    mov dword ptr [ebp - local_14], 0x0          # 004c5cdf
    jmp.d8 L_004c5cf1                            # 004c5ce6
L_004c5ce8:
    # block 0x004c5ce8: entered by jmp at 0x004c5d2f, 3 instruction(s), falls into the block at 0x004c5cf1
    mov eax, dword ptr [ebp - local_14]          # 004c5ce8
    add eax, 0x2                                 # 004c5ceb
    mov dword ptr [ebp - local_14], eax          # 004c5cee
L_004c5cf1:
    # block 0x004c5cf1: entered by jmp at 0x004c5ce6, 3 instruction(s), ends with jge to 0x004c5d31 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004c5cf1
    cmp ecx, dword ptr [ebp - local_8]           # 004c5cf4
    jge.d8 L_004c5d31                            # 004c5cf7
    # block 0x004c5cf9: entered by fall-through of jge at 0x004c5cf7, 11 instruction(s), ends with je to 0x004c5d2f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c5cf9
    add edx, dword ptr [ebp - local_14]          # 004c5cfc
    mov ax, word ptr [edx]                       # 004c5cff
    mov word ptr [ebp - local_24], ax            # 004c5d02
    mov ecx, dword ptr [ebp - local_24]          # 004c5d06
    and ecx, 0xffff                              # 004c5d09
    mov edx, dword ptr [ebp - local_134]         # 004c5d0f
    {load} xor eax, eax                          # 004c5d15
    mov ax, word ptr [edx + field_38d0]          # 004c5d17
    {load} cmp ecx, eax                          # 004c5d1e
    je.d8 L_004c5d2f                             # 004c5d20
    # block 0x004c5d22: entered by fall-through of je at 0x004c5d20, 4 instruction(s), falls into the block at 0x004c5d2f
    mov ecx, dword ptr [ebp - local_c]           # 004c5d22
    add ecx, dword ptr [ebp - local_14]          # 004c5d25
    mov dx, word ptr [ebp - local_24]            # 004c5d28
    mov word ptr [ecx], dx                       # 004c5d2c
L_004c5d2f:
    # block 0x004c5d2f: entered by je at 0x004c5d20, 1 instruction(s), ends with backward jump to 0x004c5ce8
    jmp.d8 L_004c5ce8                            # 004c5d2f
L_004c5d31:
    # block 0x004c5d31: entered by jge at 0x004c5cf7, 7 instruction(s), ends with backward jump to 0x004c5cce
    mov eax, dword ptr [ebp - local_4]           # 004c5d31
    add eax, dword ptr [ebp - local_18]          # 004c5d34
    mov dword ptr [ebp - local_4], eax           # 004c5d37
    mov ecx, dword ptr [ebp - local_c]           # 004c5d3a
    add ecx, dword ptr [ebp - local_10]          # 004c5d3d
    mov dword ptr [ebp - local_c], ecx           # 004c5d40
    jmp.d8 L_004c5cce                            # 004c5d43
L_004c5d45:
    # block 0x004c5d45: entered by jmp at 0x004c5c29; jge at 0x004c5cdd, 3 instruction(s), ends with ret 0x14
    {load} mov esp, ebp                          # 004c5d45
    pop ebp                                      # 004c5d47
    ret 0x14                                     # 004c5d48

