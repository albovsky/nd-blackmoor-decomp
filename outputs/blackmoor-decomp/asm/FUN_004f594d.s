# FUN_004f594d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f594d
# extent:       0x004f594d-0x004f5b50 (515 code bytes)
# span:         0x004f594d-0x004f5b50 (code 515, tables 0, padding 0)
# sha256:       3264f3b418f03b14486222be8c6dca01dbc559b6506f57bfb8fb67bcc1e34b69
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f594d_read_checked
# naming:       native port src/original_methods_fl33b.c:m4f594d_read_checked (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Checked block read: fills a local 7 dword struct, calls 0x4f5e95, 0x4f5b50 (again for the remainder), pads the rest with 0x80 or 0 and calls 0x4f5e35; sets status 0x405 to 0x407 on each failure.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34
# fields:       [eax + n] field_c, field_28f, field_2ed, field_3c2; [ecx + n] field_130, field_15e, field_28f, field_3c2, field_3ce; [edx + n] field_10, field_28f, field_3c2
# callees:      calls FUN_004f5e95, FUN_004f5e35, FUN_004f5b50
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33b.c:m4f594d_read_checked (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 155 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_130, 0x130  # offset +0x130
.equ field_15e, 0x15e  # offset +0x15e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_2ed, 0x2ed  # offset +0x2ed
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f5b50, .text + (0x004f5b50 - 0x401000)
.set FUN_004f5e35, .text + (0x004f5e35 - 0x401000)
.set FUN_004f5e95, .text + (0x004f5e95 - 0x401000)

.org 0x004f594d - 0x401000
.globl FUN_004f594d
FUN_004f594d:
    # block 0x004f594d: entry, 20 instruction(s), ends with jne to 0x004f59a2 (forward)
    push ebp                                     # 004f594d
    {load} mov ebp, esp                          # 004f594e
    sub esp, 0x34                                # 004f5950
    push edi                                     # 004f5953
    mov dword ptr [ebp - local_34], ecx          # 004f5954
    mov dword ptr [ebp - local_4], 0x0           # 004f5957
    mov dword ptr [ebp - local_28], 0x1          # 004f595e
    mov eax, dword ptr [ebp + arg_8]             # 004f5965
    imul eax, eax, 0x5bb                         # 004f5968
    mov ecx, dword ptr [ebp - local_34]          # 004f596e
    mov edx, dword ptr [ecx + field_3ce]         # 004f5971
    {load} add edx, eax                          # 004f5977
    mov dword ptr [ebp - local_2c], edx          # 004f5979
    mov eax, dword ptr [ebp - local_2c]          # 004f597c
    add eax, 0x18a                               # 004f597f
    mov dword ptr [ebp - local_8], eax           # 004f5984
    mov ecx, dword ptr [ebp - local_2c]          # 004f5987
    mov edx, dword ptr [ebp + arg_10]            # 004f598a
    cmp edx, dword ptr [ecx + field_15e]         # 004f598d
    jne.d8 L_004f59a2                            # 004f5993
    # block 0x004f5995: entered by fall-through of jne at 0x004f5993, 2 instruction(s), ends with jne to 0x004f59a2 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004f5995
    jne.d8 L_004f59a2                            # 004f5999
    # block 0x004f599b: entered by fall-through of jne at 0x004f5999, 1 instruction(s), falls into the block at 0x004f59a2
    mov dword ptr [ebp - local_4], 0x2           # 004f599b
L_004f59a2:
    # block 0x004f59a2: entered by jne at 0x004f5993; jne at 0x004f5999, 19 instruction(s), calls FUN_004f5e95, ends with jne to 0x004f59ee (forward)
    mov ecx, 0x7                                 # 004f59a2
    {load} xor eax, eax                          # 004f59a7
    lea edi, [ebp - local_24]                    # 004f59a9
    rep stosd dword ptr es:[edi], eax            # 004f59ac
    mov eax, dword ptr [ebp + arg_c]             # 004f59ae
    mov dword ptr [ebp - local_24], eax          # 004f59b1
    mov ecx, dword ptr [ebp + arg_10]            # 004f59b4
    mov dword ptr [ebp - local_20], ecx          # 004f59b7
    mov edx, dword ptr [ebp - local_4]           # 004f59ba
    mov dword ptr [ebp - local_c], edx           # 004f59bd
    lea eax, [ebp - local_24]                    # 004f59c0
    push eax                                     # 004f59c3
    mov ecx, dword ptr [ebp - local_2c]          # 004f59c4
    mov edx, dword ptr [ecx + field_28f]         # 004f59c7
    push edx                                     # 004f59cd
    mov ecx, dword ptr [ebp - local_34]          # 004f59ce
    call FUN_004f5e95                            # 004f59d1
    test eax, eax                                # 004f59d6
    jne.d8 L_004f59ee                            # 004f59d8
    # block 0x004f59da: entered by fall-through of jne at 0x004f59d8, 4 instruction(s), ends with forward jump to 0x004f5b49
    mov eax, dword ptr [ebp - local_34]          # 004f59da
    mov dword ptr [eax + field_3c2], 0x405       # 004f59dd
    {load} xor eax, eax                          # 004f59e7
    jmp.d32 L_004f5b49                           # 004f59e9
L_004f59ee:
    # block 0x004f59ee: entered by jne at 0x004f59d8, 3 instruction(s), ends with jne to 0x004f59fc (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004f59ee
    cmp ecx, dword ptr [ebp + arg_10]            # 004f59f1
    jne.d8 L_004f59fc                            # 004f59f4
    # block 0x004f59f6: entered by fall-through of jne at 0x004f59f4, 2 instruction(s), ends with je to 0x004f5a26 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 004f59f6
    je.d8 L_004f5a26                             # 004f59fa
L_004f59fc:
    # block 0x004f59fc: entered by jne at 0x004f59f4; fall-through of je at 0x004f59fa, 11 instruction(s), calls FUN_004f5e35, ends with forward jump to 0x004f5b49
    lea edx, [ebp - local_24]                    # 004f59fc
    push edx                                     # 004f59ff
    mov eax, dword ptr [ebp - local_2c]          # 004f5a00
    mov ecx, dword ptr [eax + field_28f]         # 004f5a03
    push ecx                                     # 004f5a09
    mov ecx, dword ptr [ebp - local_34]          # 004f5a0a
    call FUN_004f5e35                            # 004f5a0d
    mov edx, dword ptr [ebp - local_34]          # 004f5a12
    mov dword ptr [edx + field_3c2], 0x406       # 004f5a15
    {load} xor eax, eax                          # 004f5a1f
    jmp.d32 L_004f5b49                           # 004f5a21
L_004f5a26:
    # block 0x004f5a26: entered by je at 0x004f59fa, 11 instruction(s), calls FUN_004f5b50, ends with jge to 0x004f5a4f (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004f5a26
    push eax                                     # 004f5a29
    mov ecx, dword ptr [ebp - local_1c]          # 004f5a2a
    push ecx                                     # 004f5a2d
    mov edx, dword ptr [ebp + arg_8]             # 004f5a2e
    push edx                                     # 004f5a31
    mov ecx, dword ptr [ebp - local_34]          # 004f5a32
    call FUN_004f5b50                            # 004f5a35
    mov dword ptr [ebp - local_30], eax          # 004f5a3a
    cmp dword ptr [ebp - local_30], 0x0          # 004f5a3d
    jge.d8 L_004f5a4f                            # 004f5a41
    # block 0x004f5a43: entered by fall-through of jge at 0x004f5a41, 2 instruction(s), ends with forward jump to 0x004f5b18
    mov dword ptr [ebp - local_28], 0x0          # 004f5a43
    jmp.d32 L_004f5b18                           # 004f5a4a
L_004f5a4f:
    # block 0x004f5a4f: entered by jge at 0x004f5a41, 3 instruction(s), ends with jge to 0x004f5b18 (forward)
    mov eax, dword ptr [ebp - local_30]          # 004f5a4f
    cmp eax, dword ptr [ebp + arg_10]            # 004f5a52
    jge.d32 L_004f5b18                           # 004f5a55
    # block 0x004f5a5b: entered by fall-through of jge at 0x004f5a55, 3 instruction(s), ends with jne to 0x004f5ab7 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004f5a5b
    cmp dword ptr [ecx + field_130], 0x0         # 004f5a5e
    jne.d8 L_004f5ab7                            # 004f5a65
    # block 0x004f5a67: entered by fall-through of jne at 0x004f5a65, 15 instruction(s), calls FUN_004f5b50, ends with jge to 0x004f5a99 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 004f5a67
    sub edx, dword ptr [ebp - local_30]          # 004f5a6a
    mov dword ptr [ebp + arg_10], edx            # 004f5a6d
    mov eax, dword ptr [ebp + arg_10]            # 004f5a70
    push eax                                     # 004f5a73
    mov ecx, dword ptr [ebp - local_1c]          # 004f5a74
    add ecx, dword ptr [ebp - local_30]          # 004f5a77
    push ecx                                     # 004f5a7a
    mov edx, dword ptr [ebp + arg_8]             # 004f5a7b
    push edx                                     # 004f5a7e
    mov ecx, dword ptr [ebp - local_34]          # 004f5a7f
    call FUN_004f5b50                            # 004f5a82
    mov dword ptr [ebp - local_30], eax          # 004f5a87
    cmp dword ptr [ebp - local_30], 0x0          # 004f5a8a
    jge.d8 L_004f5a99                            # 004f5a8e
    # block 0x004f5a90: entered by fall-through of jge at 0x004f5a8e, 2 instruction(s), ends with forward jump to 0x004f5ab5
    mov dword ptr [ebp - local_28], 0x0          # 004f5a90
    jmp.d8 L_004f5ab5                            # 004f5a97
L_004f5a99:
    # block 0x004f5a99: entered by jge at 0x004f5a8e, 3 instruction(s), ends with jge to 0x004f5ab5 (forward)
    mov eax, dword ptr [ebp - local_30]          # 004f5a99
    cmp eax, dword ptr [ebp + arg_10]            # 004f5a9c
    jge.d8 L_004f5ab5                            # 004f5a9f
    # block 0x004f5aa1: entered by fall-through of jge at 0x004f5a9f, 3 instruction(s), falls into the block at 0x004f5ab5
    mov ecx, dword ptr [ebp - local_34]          # 004f5aa1
    mov dword ptr [ecx + field_3c2], 0x3ec       # 004f5aa4
    mov dword ptr [ebp - local_28], 0x0          # 004f5aae
L_004f5ab5:
    # block 0x004f5ab5: entered by jmp at 0x004f5a97; jge at 0x004f5a9f, 1 instruction(s), ends with forward jump to 0x004f5b18
    jmp.d8 L_004f5b18                            # 004f5ab5
L_004f5ab7:
    # block 0x004f5ab7: entered by jne at 0x004f5a65, 3 instruction(s), ends with je to 0x004f5b18 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f5ab7
    cmp dword ptr [edx + field_10], -0x1         # 004f5aba
    je.d8 L_004f5b18                             # 004f5abe
    # block 0x004f5ac0: entered by fall-through of je at 0x004f5abe, 5 instruction(s), ends with jne to 0x004f5af2 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 004f5ac0
    {load} xor ecx, ecx                          # 004f5ac3
    mov cx, word ptr [eax + field_2ed]           # 004f5ac5
    cmp ecx, 0x8                                 # 004f5acc
    jne.d8 L_004f5af2                            # 004f5acf
    # block 0x004f5ad1: entered by fall-through of jne at 0x004f5acf, 12 instruction(s), ends with forward jump to 0x004f5b0e
    mov ecx, dword ptr [ebp + arg_10]            # 004f5ad1
    sub ecx, dword ptr [ebp - local_30]          # 004f5ad4
    mov eax, 0x80808080                          # 004f5ad7
    mov edi, dword ptr [ebp - local_1c]          # 004f5adc
    add edi, dword ptr [ebp - local_30]          # 004f5adf
    {load} mov edx, ecx                          # 004f5ae2
    shr ecx, 0x2                                 # 004f5ae4
    rep stosd dword ptr es:[edi], eax            # 004f5ae7
    {load} mov ecx, edx                          # 004f5ae9
    and ecx, 0x3                                 # 004f5aeb
    rep stosb byte ptr es:[edi], al              # 004f5aee
    jmp.d8 L_004f5b0e                            # 004f5af0
L_004f5af2:
    # block 0x004f5af2: entered by jne at 0x004f5acf, 11 instruction(s), falls into the block at 0x004f5b0e
    mov ecx, dword ptr [ebp + arg_10]            # 004f5af2
    sub ecx, dword ptr [ebp - local_30]          # 004f5af5
    {load} xor eax, eax                          # 004f5af8
    mov edi, dword ptr [ebp - local_1c]          # 004f5afa
    add edi, dword ptr [ebp - local_30]          # 004f5afd
    {load} mov edx, ecx                          # 004f5b00
    shr ecx, 0x2                                 # 004f5b02
    rep stosd dword ptr es:[edi], eax            # 004f5b05
    {load} mov ecx, edx                          # 004f5b07
    and ecx, 0x3                                 # 004f5b09
    rep stosb byte ptr es:[edi], al              # 004f5b0c
L_004f5b0e:
    # block 0x004f5b0e: entered by jmp at 0x004f5af0, 2 instruction(s), falls into the block at 0x004f5b18
    mov eax, dword ptr [ebp - local_8]           # 004f5b0e
    mov dword ptr [eax + field_c], 0x1           # 004f5b11
L_004f5b18:
    # block 0x004f5b18: entered by jmp at 0x004f5a4a; jge at 0x004f5a55; jmp at 0x004f5ab5; je at 0x004f5abe, 9 instruction(s), calls FUN_004f5e35, ends with jne to 0x004f5b46 (forward)
    lea ecx, [ebp - local_24]                    # 004f5b18
    push ecx                                     # 004f5b1b
    mov edx, dword ptr [ebp - local_2c]          # 004f5b1c
    mov eax, dword ptr [edx + field_28f]         # 004f5b1f
    push eax                                     # 004f5b25
    mov ecx, dword ptr [ebp - local_34]          # 004f5b26
    call FUN_004f5e35                            # 004f5b29
    test eax, eax                                # 004f5b2e
    jne.d8 L_004f5b46                            # 004f5b30
    # block 0x004f5b32: entered by fall-through of jne at 0x004f5b30, 3 instruction(s), falls into the block at 0x004f5b46
    mov ecx, dword ptr [ebp - local_34]          # 004f5b32
    mov dword ptr [ecx + field_3c2], 0x407       # 004f5b35
    mov dword ptr [ebp - local_28], 0x0          # 004f5b3f
L_004f5b46:
    # block 0x004f5b46: entered by jne at 0x004f5b30, 1 instruction(s), falls into the block at 0x004f5b49
    mov eax, dword ptr [ebp - local_28]          # 004f5b46
L_004f5b49:
    # block 0x004f5b49: entered by jmp at 0x004f59e9; jmp at 0x004f5a21, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 004f5b49
    {load} mov esp, ebp                          # 004f5b4a
    pop ebp                                      # 004f5b4c
    ret 0xc                                      # 004f5b4d

