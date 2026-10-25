# FUN_004a8bf2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a8bf2
# extent:       0x004a8bf2-0x004a8d28 (310 code bytes)
# span:         0x004a8bf2-0x004a8d28 (code 310, tables 0, padding 0)
# sha256:       2d49ccb5ba9d3c83406ad6686f281d24de8c72323df3c6b7abfc478d537f41e6
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a8bf2_lifted
# naming:       native port src/original_methods_fl41.c:m4a8bf2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 33 seeds; oracle: 85/85 instructions, 10/10 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_c26, field_e83; [ecx + n] field_43, field_a40, field_e7f; [edx + n] field_2, field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a8bf2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 85 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_43, 0x43  # offset +0x43
.equ field_a40, 0xa40  # offset +0xa40
.equ field_c26, 0xc26  # offset +0xc26
.equ field_e7f, 0xe7f  # offset +0xe7f
.equ field_e83, 0xe83  # offset +0xe83

# --- external targets -----------------------------------------------

.org 0x004a8bf2 - 0x401000
.globl FUN_004a8bf2
FUN_004a8bf2:
    # block 0x004a8bf2: entry, 11 instruction(s), ends with forward jump to 0x004a8c23
    push ebp                                     # 004a8bf2
    {load} mov ebp, esp                          # 004a8bf3
    sub esp, 0x10                                # 004a8bf5
    mov dword ptr [ebp - local_10], ecx          # 004a8bf8
    mov eax, dword ptr [ebp - local_10]          # 004a8bfb
    movsx ecx, word ptr [eax + field_1e]         # 004a8bfe
    imul ecx, ecx, 0x8d                          # 004a8c02
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a8c08
    mov dword ptr [ebp - local_c], edx           # 004a8c0e
    mov dword ptr [ebp - local_4], 0x0           # 004a8c11
    jmp.d8 L_004a8c23                            # 004a8c18
L_004a8c1a:
    # block 0x004a8c1a: entered by jmp at 0x004a8d08, 3 instruction(s), falls into the block at 0x004a8c23
    mov eax, dword ptr [ebp - local_4]           # 004a8c1a
    add eax, 0x1                                 # 004a8c1d
    mov dword ptr [ebp - local_4], eax           # 004a8c20
L_004a8c23:
    # block 0x004a8c23: entered by jmp at 0x004a8c18, 4 instruction(s), ends with jge to 0x004a8d0d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a8c23
    movsx edx, word ptr [ecx + field_43]         # 004a8c26
    cmp dword ptr [ebp - local_4], edx           # 004a8c2a
    jge.d32 L_004a8d0d                           # 004a8c2d
    # block 0x004a8c33: entered by fall-through of jge at 0x004a8c2d, 2 instruction(s), ends with forward jump to 0x004a8c45
    mov dword ptr [ebp - local_8], 0x0           # 004a8c33
    jmp.d8 L_004a8c45                            # 004a8c3a
L_004a8c3c:
    # block 0x004a8c3c: entered by jmp at 0x004a8d03, 3 instruction(s), falls into the block at 0x004a8c45
    mov eax, dword ptr [ebp - local_8]           # 004a8c3c
    add eax, 0x1                                 # 004a8c3f
    mov dword ptr [ebp - local_8], eax           # 004a8c42
L_004a8c45:
    # block 0x004a8c45: entered by jmp at 0x004a8c3a, 4 instruction(s), ends with jge to 0x004a8d08 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a8c45
    movsx edx, word ptr [ecx + field_43]         # 004a8c48
    cmp dword ptr [ebp - local_8], edx           # 004a8c4c
    jge.d32 L_004a8d08                           # 004a8c4f
    # block 0x004a8c55: entered by fall-through of jge at 0x004a8c4f, 16 instruction(s), ends with jne to 0x004a8d01 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a8c55
    imul eax, eax, 0x36                          # 004a8c58
    mov ecx, dword ptr [ebp - local_10]          # 004a8c5b
    lea edx, [ecx + eax + field_a40]             # 004a8c5e
    mov eax, dword ptr [ebp - local_8]           # 004a8c65
    imul eax, eax, 0x6                           # 004a8c68
    movsx ecx, word ptr [edx + eax]              # 004a8c6b
    mov edx, dword ptr [ebp - local_4]           # 004a8c6f
    imul edx, edx, 0x36                          # 004a8c72
    mov eax, dword ptr [ebp - local_10]          # 004a8c75
    lea edx, [eax + edx + field_c26]             # 004a8c78
    mov eax, dword ptr [ebp - local_8]           # 004a8c7f
    imul eax, eax, 0x6                           # 004a8c82
    movsx edx, word ptr [edx + eax]              # 004a8c85
    {load} cmp ecx, edx                          # 004a8c89
    jne.d8 L_004a8d01                            # 004a8c8b
    # block 0x004a8c8d: entered by fall-through of jne at 0x004a8c8b, 16 instruction(s), ends with jne to 0x004a8d01 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a8c8d
    imul eax, eax, 0x36                          # 004a8c90
    mov ecx, dword ptr [ebp - local_10]          # 004a8c93
    lea edx, [ecx + eax + field_a40]             # 004a8c96
    mov eax, dword ptr [ebp - local_8]           # 004a8c9d
    imul eax, eax, 0x6                           # 004a8ca0
    movsx ecx, word ptr [edx + eax + field_2]    # 004a8ca3
    mov edx, dword ptr [ebp - local_4]           # 004a8ca8
    imul edx, edx, 0x36                          # 004a8cab
    mov eax, dword ptr [ebp - local_10]          # 004a8cae
    lea edx, [eax + edx + field_c26]             # 004a8cb1
    mov eax, dword ptr [ebp - local_8]           # 004a8cb8
    imul eax, eax, 0x6                           # 004a8cbb
    movsx edx, word ptr [edx + eax + field_2]    # 004a8cbe
    {load} cmp ecx, edx                          # 004a8cc3
    jne.d8 L_004a8d01                            # 004a8cc5
    # block 0x004a8cc7: entered by fall-through of jne at 0x004a8cc5, 16 instruction(s), ends with je to 0x004a8d03 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a8cc7
    imul eax, eax, 0x36                          # 004a8cca
    mov ecx, dword ptr [ebp - local_10]          # 004a8ccd
    lea edx, [ecx + eax + field_a40]             # 004a8cd0
    mov eax, dword ptr [ebp - local_8]           # 004a8cd7
    imul eax, eax, 0x6                           # 004a8cda
    movsx ecx, word ptr [edx + eax + field_4]    # 004a8cdd
    mov edx, dword ptr [ebp - local_4]           # 004a8ce2
    imul edx, edx, 0x36                          # 004a8ce5
    mov eax, dword ptr [ebp - local_10]          # 004a8ce8
    lea edx, [eax + edx + field_c26]             # 004a8ceb
    mov eax, dword ptr [ebp - local_8]           # 004a8cf2
    imul eax, eax, 0x6                           # 004a8cf5
    movsx edx, word ptr [edx + eax + field_4]    # 004a8cf8
    {load} cmp ecx, edx                          # 004a8cfd
    je.d8 L_004a8d03                             # 004a8cff
L_004a8d01:
    # block 0x004a8d01: entered by jne at 0x004a8c8b; jne at 0x004a8cc5; fall-through of je at 0x004a8cff, 1 instruction(s), ends with forward jump to 0x004a8d24
    jmp.d8 L_004a8d24                            # 004a8d01
L_004a8d03:
    # block 0x004a8d03: entered by je at 0x004a8cff, 1 instruction(s), ends with backward jump to 0x004a8c3c
    jmp.d32 L_004a8c3c                           # 004a8d03
L_004a8d08:
    # block 0x004a8d08: entered by jge at 0x004a8c4f, 1 instruction(s), ends with backward jump to 0x004a8c1a
    jmp.d32 L_004a8c1a                           # 004a8d08
L_004a8d0d:
    # block 0x004a8d0d: entered by jge at 0x004a8c2d, 4 instruction(s), falls into the block at 0x004a8d24
    mov eax, dword ptr [ebp - local_10]          # 004a8d0d
    mov byte ptr [eax + field_e83], 0x1          # 004a8d10
    mov ecx, dword ptr [ebp - local_10]          # 004a8d17
    mov dword ptr [ecx + field_e7f], 0x2         # 004a8d1a
L_004a8d24:
    # block 0x004a8d24: entered by jmp at 0x004a8d01, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a8d24
    pop ebp                                      # 004a8d26
    ret                                          # 004a8d27

