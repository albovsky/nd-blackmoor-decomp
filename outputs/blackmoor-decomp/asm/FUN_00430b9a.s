# FUN_00430b9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00430b9a
# extent:       0x00430b9a-0x00430ca0 (262 code bytes)
# span:         0x00430b9a-0x00430ca0 (code 262, tables 0, padding 0)
# sha256:       1062465ed2fa1c5cbac28b60f89c804f84922be461b36ca40ce355d49c59809d
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         blink
# naming:       native port src/action_family_76_runtime.c:blink (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    Cursor blink matches statement by statement. The cited test is a summary corpus; the differential evidence is action_family_76_runtime_original_oracle.py, which runs 0x430b9a and compares the state image and tick sequence.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_minus_1; [edx + n] field_2, field_minus_1
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00430b9a - 0x401000
.globl FUN_00430b9a
FUN_00430b9a:
    # block 0x00430b9a: entry, 8 instruction(s), ends with je to 0x00430bb8 (forward)
    push ebp                                     # 00430b9a
    {load} mov ebp, esp                          # 00430b9b
    push ecx                                     # 00430b9d
    push edi                                     # 00430b9e
    mov eax, dword ptr [0x5b61b8]                # 00430b9f
    mov dword ptr [ebp - local_4], eax           # 00430ba4
    cmp dword ptr [ebp - local_4], 0x0           # 00430ba7
    je.d8 L_00430bb8                             # 00430bab
    # block 0x00430bad: entered by fall-through of je at 0x00430bab, 2 instruction(s), ends with je to 0x00430c07 (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 00430bad
    je.d8 L_00430c07                             # 00430bb1
    # block 0x00430bb3: entered by fall-through of je at 0x00430bb1, 1 instruction(s), ends with forward jump to 0x00430c4d
    jmp.d32 L_00430c4d                           # 00430bb3
L_00430bb8:
    # block 0x00430bb8: entered by je at 0x00430bab, 8 instruction(s), ends with jne to 0x00430bd3 (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00430bb8
    or ecx, -0x1                                 # 00430bbb
    {load} xor eax, eax                          # 00430bbe
    repne scasb al, byte ptr es:[edi]            # 00430bc0
    not ecx                                      # 00430bc2
    add ecx, -0x1                                # 00430bc4
    test ecx, ecx                                # 00430bc7
    jne.d8 L_00430bd3                            # 00430bc9
    # block 0x00430bcb: entered by fall-through of jne at 0x00430bc9, 3 instruction(s), ends with forward jump to 0x00430c05
    mov ecx, dword ptr [ebp + arg_c]             # 00430bcb
    mov byte ptr [ecx], 0x2d                     # 00430bce
    jmp.d8 L_00430c05                            # 00430bd1
L_00430bd3:
    # block 0x00430bd3: entered by jne at 0x00430bc9, 10 instruction(s), ends with je to 0x00430c05 (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00430bd3
    or ecx, -0x1                                 # 00430bd6
    {load} xor eax, eax                          # 00430bd9
    repne scasb al, byte ptr es:[edi]            # 00430bdb
    not ecx                                      # 00430bdd
    add ecx, -0x1                                # 00430bdf
    mov edx, dword ptr [ebp + arg_c]             # 00430be2
    movsx eax, byte ptr [edx + ecx - field_minus_1] # 00430be5
    cmp eax, 0x2d                                # 00430bea
    je.d8 L_00430c05                             # 00430bed
    # block 0x00430bef: entered by fall-through of je at 0x00430bed, 8 instruction(s), falls into the block at 0x00430c05
    mov edi, dword ptr [ebp + arg_c]             # 00430bef
    or ecx, -0x1                                 # 00430bf2
    {load} xor eax, eax                          # 00430bf5
    repne scasb al, byte ptr es:[edi]            # 00430bf7
    not ecx                                      # 00430bf9
    add ecx, -0x1                                # 00430bfb
    mov edx, dword ptr [ebp + arg_c]             # 00430bfe
    mov byte ptr [edx + ecx], 0x2d               # 00430c01
L_00430c05:
    # block 0x00430c05: entered by jmp at 0x00430bd1; je at 0x00430bed, 1 instruction(s), ends with forward jump to 0x00430c4d
    jmp.d8 L_00430c4d                            # 00430c05
L_00430c07:
    # block 0x00430c07: entered by je at 0x00430bb1, 8 instruction(s), ends with jbe to 0x00430c4d (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00430c07
    or ecx, -0x1                                 # 00430c0a
    {load} xor eax, eax                          # 00430c0d
    repne scasb al, byte ptr es:[edi]            # 00430c0f
    not ecx                                      # 00430c11
    add ecx, -0x1                                # 00430c13
    test ecx, ecx                                # 00430c16
    jbe.d8 L_00430c4d                            # 00430c18
    # block 0x00430c1a: entered by fall-through of jbe at 0x00430c18, 10 instruction(s), ends with jne to 0x00430c4d (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00430c1a
    or ecx, -0x1                                 # 00430c1d
    {load} xor eax, eax                          # 00430c20
    repne scasb al, byte ptr es:[edi]            # 00430c22
    not ecx                                      # 00430c24
    add ecx, -0x1                                # 00430c26
    mov eax, dword ptr [ebp + arg_c]             # 00430c29
    movsx ecx, byte ptr [eax + ecx - field_minus_1] # 00430c2c
    cmp ecx, 0x2d                                # 00430c31
    jne.d8 L_00430c4d                            # 00430c34
    # block 0x00430c36: entered by fall-through of jne at 0x00430c34, 8 instruction(s), falls into the block at 0x00430c4d
    mov edi, dword ptr [ebp + arg_c]             # 00430c36
    or ecx, -0x1                                 # 00430c39
    {load} xor eax, eax                          # 00430c3c
    repne scasb al, byte ptr es:[edi]            # 00430c3e
    not ecx                                      # 00430c40
    add ecx, -0x1                                # 00430c42
    mov edx, dword ptr [ebp + arg_c]             # 00430c45
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 00430c48
L_00430c4d:
    # block 0x00430c4d: entered by jmp at 0x00430bb3; jmp at 0x00430c05; jbe at 0x00430c18; jne at 0x00430c34, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00430c9b (forward)
    call dword ptr [0x52a23c]                    # 00430c4d
    cmp eax, dword ptr [0x5b61bd]                # 00430c53
    jb.d8 L_00430c9b                             # 00430c59
    # block 0x00430c5b: entered by fall-through of jb at 0x00430c59, 2 instruction(s), ends with jne to 0x00430c70 (forward)
    cmp dword ptr [0x5b61b8], 0x0                # 00430c5b
    jne.d8 L_00430c70                            # 00430c62
    # block 0x00430c64: entered by fall-through of jne at 0x00430c62, 2 instruction(s), ends with forward jump to 0x00430c7a
    mov dword ptr [0x5b61b8], 0x1                # 00430c64
    jmp.d8 L_00430c7a                            # 00430c6e
L_00430c70:
    # block 0x00430c70: entered by jne at 0x00430c62, 1 instruction(s), falls into the block at 0x00430c7a
    mov dword ptr [0x5b61b8], 0x0                # 00430c70
L_00430c7a:
    # block 0x00430c7a: entered by jmp at 0x00430c6e, 7 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00430c9b
    call dword ptr [0x52a23c]                    # 00430c7a
    movsx ecx, word ptr [ebp + arg_8]            # 00430c80
    imul ecx, ecx, 0x8d                          # 00430c84
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430c8a
    movsx ecx, word ptr [edx + field_2]          # 00430c90
    {load} add eax, ecx                          # 00430c94
    mov dword ptr [0x5b61bd], eax                # 00430c96
L_00430c9b:
    # block 0x00430c9b: entered by jb at 0x00430c59, 4 instruction(s), ends with ret
    pop edi                                      # 00430c9b
    {load} mov esp, ebp                          # 00430c9c
    pop ebp                                      # 00430c9e
    ret                                          # 00430c9f

