# FUN_004e3ade
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3ade
# extent:       0x004e3ade-0x004e3cd7 (505 code bytes)
# span:         0x004e3ade-0x004e3cd7 (code 505, tables 0, padding 0)
# sha256:       3b96fd07fc25e587bfdc11567ce71b08cb809ab3db46cd1bd4ca41c131aad072
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         sort_phone_records
# naming:       native port src/action_ui.c:sort_phone_records (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Static sort_phone_records. Oracle compares the 12 real BOOT rows (4 distinct ASCII names) byte for byte; prefix, high-bit and case ties are native-test only. ASCII normalization only; native rejects unterminated names.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_2c, local_30, local_34, local_48, local_4c, local_60, local_64, local_68, local_6c, local_6d, local_6e, local_74 and 1 more
# fields:       [ecx + n] field_1; [edx + n] field_1
# callees:      calls FUN_0050d0bc
# track-n:      outputs/blackmoor-decomp/src/action_ui.c:sort_phone_records (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 154 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_6d, 0x6d  # offset -0x6d
.equ local_6e, 0x6e  # offset -0x6e
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ field_1, 0x1  # offset +0x1

# --- external targets -----------------------------------------------
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)

.org 0x004e3ade - 0x401000
.globl FUN_004e3ade
FUN_004e3ade:
    # block 0x004e3ade: entry, 7 instruction(s), falls into the block at 0x004e3af0
    push ebp                                     # 004e3ade
    {load} mov ebp, esp                          # 004e3adf
    sub esp, 0x78                                # 004e3ae1
    push esi                                     # 004e3ae4
    push edi                                     # 004e3ae5
    mov dword ptr [ebp - local_64], ecx          # 004e3ae6
    mov dword ptr [ebp - local_4c], 0x1          # 004e3ae9
L_004e3af0:
    # block 0x004e3af0: entered by jmp at 0x004e3ccc, 2 instruction(s), ends with je to 0x004e3cd1 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 004e3af0
    je.d32 L_004e3cd1                            # 004e3af4
    # block 0x004e3afa: entered by fall-through of je at 0x004e3af4, 3 instruction(s), ends with forward jump to 0x004e3b15
    mov dword ptr [ebp - local_4c], 0x0          # 004e3afa
    mov word ptr [ebp - local_34], 0x0           # 004e3b01
    jmp.d8 L_004e3b15                            # 004e3b07
L_004e3b09:
    # block 0x004e3b09: entered by jmp at 0x004e3cc7, 3 instruction(s), falls into the block at 0x004e3b15
    mov ax, word ptr [ebp - local_34]            # 004e3b09
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e3b0d
    mov word ptr [ebp - local_34], ax            # 004e3b11
L_004e3b15:
    # block 0x004e3b15: entered by jmp at 0x004e3b07, 5 instruction(s), ends with jge to 0x004e3ccc (forward)
    movsx ecx, word ptr [ebp - local_34]         # 004e3b15
    movsx edx, word ptr [0x5a1e5c]               # 004e3b19
    sub edx, 0x1                                 # 004e3b20
    {load} cmp ecx, edx                          # 004e3b23
    jge.d32 L_004e3ccc                           # 004e3b25
    # block 0x004e3b2b: entered by fall-through of jge at 0x004e3b25, 49 instruction(s), calls FUN_0050d0bc, falls into the block at 0x004e3baf
    movsx eax, word ptr [ebp - local_34]         # 004e3b2b
    imul eax, eax, 0x29                          # 004e3b2f
    add eax, 0x5a1e6f                            # 004e3b32
    {load} mov edi, eax                          # 004e3b37
    lea edx, [ebp - local_48]                    # 004e3b39
    or ecx, -0x1                                 # 004e3b3c
    {load} xor eax, eax                          # 004e3b3f
    repne scasb al, byte ptr es:[edi]            # 004e3b41
    not ecx                                      # 004e3b43
    {load} sub edi, ecx                          # 004e3b45
    {load} mov esi, edi                          # 004e3b47
    {load} mov eax, ecx                          # 004e3b49
    {load} mov edi, edx                          # 004e3b4b
    shr ecx, 0x2                                 # 004e3b4d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3b50
    {load} mov ecx, eax                          # 004e3b52
    and ecx, 0x3                                 # 004e3b54
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e3b57
    movsx ecx, word ptr [ebp - local_34]         # 004e3b59
    add ecx, 0x1                                 # 004e3b5d
    imul ecx, ecx, 0x29                          # 004e3b60
    add ecx, 0x5a1e6f                            # 004e3b63
    {load} mov edi, ecx                          # 004e3b69
    lea edx, [ebp - local_60]                    # 004e3b6b
    or ecx, -0x1                                 # 004e3b6e
    {load} xor eax, eax                          # 004e3b71
    repne scasb al, byte ptr es:[edi]            # 004e3b73
    not ecx                                      # 004e3b75
    {load} sub edi, ecx                          # 004e3b77
    {load} mov esi, edi                          # 004e3b79
    {load} mov eax, ecx                          # 004e3b7b
    {load} mov edi, edx                          # 004e3b7d
    shr ecx, 0x2                                 # 004e3b7f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3b82
    {load} mov ecx, eax                          # 004e3b84
    and ecx, 0x3                                 # 004e3b86
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e3b89
    lea ecx, [ebp - local_48]                    # 004e3b8b
    push ecx                                     # 004e3b8e
    call FUN_0050d0bc                            # 004e3b8f
    add esp, 0x4                                 # 004e3b94
    lea edx, [ebp - local_60]                    # 004e3b97
    push edx                                     # 004e3b9a
    call FUN_0050d0bc                            # 004e3b9b
    add esp, 0x4                                 # 004e3ba0
    lea eax, [ebp - local_60]                    # 004e3ba3
    mov dword ptr [ebp - local_68], eax          # 004e3ba6
    lea ecx, [ebp - local_48]                    # 004e3ba9
    mov dword ptr [ebp - local_6c], ecx          # 004e3bac
L_004e3baf:
    # block 0x004e3baf: entered by jne at 0x004e3be1, 6 instruction(s), ends with jne to 0x004e3bec (forward)
    mov edx, dword ptr [ebp - local_6c]          # 004e3baf
    mov al, byte ptr [edx]                       # 004e3bb2
    mov byte ptr [ebp - local_6d], al            # 004e3bb4
    mov ecx, dword ptr [ebp - local_68]          # 004e3bb7
    cmp al, byte ptr [ecx]                       # 004e3bba
    jne.d8 L_004e3bec                            # 004e3bbc
    # block 0x004e3bbe: entered by fall-through of jne at 0x004e3bbc, 2 instruction(s), ends with je to 0x004e3be3 (forward)
    cmp byte ptr [ebp - local_6d], 0x0           # 004e3bbe
    je.d8 L_004e3be3                             # 004e3bc2
    # block 0x004e3bc4: entered by fall-through of je at 0x004e3bc2, 6 instruction(s), ends with jne to 0x004e3bec (forward)
    mov edx, dword ptr [ebp - local_6c]          # 004e3bc4
    mov al, byte ptr [edx + field_1]             # 004e3bc7
    mov byte ptr [ebp - local_6e], al            # 004e3bca
    mov ecx, dword ptr [ebp - local_68]          # 004e3bcd
    cmp al, byte ptr [ecx + field_1]             # 004e3bd0
    jne.d8 L_004e3bec                            # 004e3bd3
    # block 0x004e3bd5: entered by fall-through of jne at 0x004e3bd3, 4 instruction(s), ends with jne to 0x004e3baf (backward)
    add dword ptr [ebp - local_6c], 0x2          # 004e3bd5
    add dword ptr [ebp - local_68], 0x2          # 004e3bd9
    cmp byte ptr [ebp - local_6e], 0x0           # 004e3bdd
    jne.d8 L_004e3baf                            # 004e3be1
L_004e3be3:
    # block 0x004e3be3: entered by je at 0x004e3bc2; fall-through of jne at 0x004e3be1, 2 instruction(s), ends with forward jump to 0x004e3bf4
    mov dword ptr [ebp - local_74], 0x0          # 004e3be3
    jmp.d8 L_004e3bf4                            # 004e3bea
L_004e3bec:
    # block 0x004e3bec: entered by jne at 0x004e3bbc; jne at 0x004e3bd3, 3 instruction(s), falls into the block at 0x004e3bf4
    {load} sbb edx, edx                          # 004e3bec
    sbb edx, -0x1                                # 004e3bee
    mov dword ptr [ebp - local_74], edx          # 004e3bf1
L_004e3bf4:
    # block 0x004e3bf4: entered by jmp at 0x004e3bea, 4 instruction(s), ends with je to 0x004e3cc7 (forward)
    mov eax, dword ptr [ebp - local_74]          # 004e3bf4
    mov dword ptr [ebp - local_78], eax          # 004e3bf7
    cmp dword ptr [ebp - local_78], 0x0          # 004e3bfa
    je.d32 L_004e3cc7                            # 004e3bfe
    # block 0x004e3c04: entered by fall-through of je at 0x004e3bfe, 2 instruction(s), ends with forward jump to 0x004e3c18
    mov word ptr [ebp - local_30], 0x0           # 004e3c04
    jmp.d8 L_004e3c18                            # 004e3c0a
L_004e3c0c:
    # block 0x004e3c0c: entered by jmp at 0x004e3cc2, 3 instruction(s), falls into the block at 0x004e3c18
    mov cx, word ptr [ebp - local_30]            # 004e3c0c
    add cx, 0x1                                  # 004e3c10
    mov word ptr [ebp - local_30], cx            # 004e3c14
L_004e3c18:
    # block 0x004e3c18: entered by jmp at 0x004e3c0a, 3 instruction(s), ends with jge to 0x004e3cc7 (forward)
    movsx edx, word ptr [ebp - local_30]         # 004e3c18
    cmp edx, 0x14                                # 004e3c1c
    jge.d32 L_004e3cc7                           # 004e3c1f
    # block 0x004e3c25: entered by fall-through of jge at 0x004e3c1f, 2 instruction(s), ends with jne to 0x004e3cc7 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 004e3c25
    jne.d32 L_004e3cc7                           # 004e3c29
    # block 0x004e3c2f: entered by fall-through of jne at 0x004e3c29, 6 instruction(s), ends with jge to 0x004e3ca6 (forward)
    movsx eax, word ptr [ebp - local_30]         # 004e3c2f
    movsx ecx, byte ptr [ebp + eax - local_60]   # 004e3c33
    movsx edx, word ptr [ebp - local_30]         # 004e3c38
    movsx eax, byte ptr [ebp + edx - local_48]   # 004e3c3c
    {load} cmp ecx, eax                          # 004e3c41
    jge.d8 L_004e3ca6                            # 004e3c43
    # block 0x004e3c45: entered by fall-through of jge at 0x004e3c43, 27 instruction(s), ends with forward jump to 0x004e3cc2
    movsx esi, word ptr [ebp - local_34]         # 004e3c45
    imul esi, esi, 0x29                          # 004e3c49
    add esi, 0x5a1e62                            # 004e3c4c
    mov ecx, 0xa                                 # 004e3c52
    lea edi, [ebp - local_2c]                    # 004e3c57
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3c5a
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e3c5c
    movsx esi, word ptr [ebp - local_34]         # 004e3c5d
    add esi, 0x1                                 # 004e3c61
    imul esi, esi, 0x29                          # 004e3c64
    add esi, 0x5a1e62                            # 004e3c67
    movsx edi, word ptr [ebp - local_34]         # 004e3c6d
    imul edi, edi, 0x29                          # 004e3c71
    add edi, 0x5a1e62                            # 004e3c74
    mov ecx, 0xa                                 # 004e3c7a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3c7f
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e3c81
    movsx edi, word ptr [ebp - local_34]         # 004e3c82
    add edi, 0x1                                 # 004e3c86
    imul edi, edi, 0x29                          # 004e3c89
    add edi, 0x5a1e62                            # 004e3c8c
    mov ecx, 0xa                                 # 004e3c92
    lea esi, [ebp - local_2c]                    # 004e3c97
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3c9a
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e3c9c
    mov dword ptr [ebp - local_4c], 0x1          # 004e3c9d
    jmp.d8 L_004e3cc2                            # 004e3ca4
L_004e3ca6:
    # block 0x004e3ca6: entered by jge at 0x004e3c43, 6 instruction(s), ends with jle to 0x004e3cc2 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 004e3ca6
    movsx edx, byte ptr [ebp + ecx - local_60]   # 004e3caa
    movsx eax, word ptr [ebp - local_30]         # 004e3caf
    movsx ecx, byte ptr [ebp + eax - local_48]   # 004e3cb3
    {load} cmp edx, ecx                          # 004e3cb8
    jle.d8 L_004e3cc2                            # 004e3cba
    # block 0x004e3cbc: entered by fall-through of jle at 0x004e3cba, 1 instruction(s), falls into the block at 0x004e3cc2
    mov word ptr [ebp - local_30], 0x14          # 004e3cbc
L_004e3cc2:
    # block 0x004e3cc2: entered by jmp at 0x004e3ca4; jle at 0x004e3cba, 1 instruction(s), ends with backward jump to 0x004e3c0c
    jmp.d32 L_004e3c0c                           # 004e3cc2
L_004e3cc7:
    # block 0x004e3cc7: entered by je at 0x004e3bfe; jge at 0x004e3c1f; jne at 0x004e3c29, 1 instruction(s), ends with backward jump to 0x004e3b09
    jmp.d32 L_004e3b09                           # 004e3cc7
L_004e3ccc:
    # block 0x004e3ccc: entered by jge at 0x004e3b25, 1 instruction(s), ends with backward jump to 0x004e3af0
    jmp.d32 L_004e3af0                           # 004e3ccc
L_004e3cd1:
    # block 0x004e3cd1: entered by je at 0x004e3af4, 5 instruction(s), ends with ret
    pop edi                                      # 004e3cd1
    pop esi                                      # 004e3cd2
    {load} mov esp, ebp                          # 004e3cd3
    pop ebp                                      # 004e3cd5
    ret                                          # 004e3cd6

