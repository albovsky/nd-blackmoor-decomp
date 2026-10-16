# FUN_00518d76
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518d76
# extent:       0x00518d76-0x00519009 (659 code bytes)
# span:         0x00518d76-0x00519009 (code 659, tables 0, padding 0)
# sha256:       23d498e487b8fbce0af26be5e6895f15860c09f9b90bc45b611e4b4021cb488d
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518d76
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       18 ebp-relative slot(s): local_4, local_5, local_6, local_a, local_e, local_10, local_11, local_12, local_13, local_14, local_15, local_16 and 6 more
# fields:       [eax + n] field_4, field_minus_1; [ebx + n] field_2, field_3, field_4, field_5; [edi + n] field_1
# callees:      calls FUN_005128b0, FUN_00519229, FUN_00519009, FUN_00518c54, FUN_00518c82, FUN_00518bf6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 232 instruction(s), 30 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_a, 0xa  # offset -0xa
.equ local_e, 0xe  # offset -0xe
.equ local_10, 0x10  # offset -0x10
.equ local_11, 0x11  # offset -0x11
.equ local_12, 0x12  # offset -0x12
.equ local_13, 0x13  # offset -0x13
.equ local_14, 0x14  # offset -0x14
.equ local_15, 0x15  # offset -0x15
.equ local_16, 0x16  # offset -0x16
.equ local_17, 0x17  # offset -0x17
.equ local_18, 0x18  # offset -0x18
.equ local_19, 0x19  # offset -0x19
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1b, 0x1b  # offset -0x1b
.equ local_1c, 0x1c  # offset -0x1c
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_00518bf6, .text + (0x00518bf6 - 0x401000)
.set FUN_00518c54, .text + (0x00518c54 - 0x401000)
.set FUN_00518c82, .text + (0x00518c82 - 0x401000)
.set FUN_00519009, .text + (0x00519009 - 0x401000)
.set FUN_00519229, .text + (0x00519229 - 0x401000)

.org 0x00518d76 - 0x401000
.globl FUN_00518d76
FUN_00518d76:
    # block 0x00518d76: entry, 28 instruction(s), ends with je to 0x00518dd8 (forward)
    push ebp                                     # 00518d76
    {load} mov ebp, esp                          # 00518d77
    sub esp, 0x1c                                # 00518d79
    mov eax, dword ptr [ebp + arg_10]            # 00518d7c
    push ebx                                     # 00518d7f
    mov ebx, dword ptr [ebp + arg_1c]            # 00518d80
    push esi                                     # 00518d83
    {load} mov ecx, eax                          # 00518d84
    mov esi, 0x7fff                              # 00518d86
    and ecx, 0x8000                              # 00518d8b
    {load} and eax, esi                          # 00518d91
    test cx, cx                                  # 00518d93
    push edi                                     # 00518d96
    mov byte ptr [ebp - local_1c], -0x34         # 00518d97
    mov byte ptr [ebp - local_1b], -0x34         # 00518d9b
    mov byte ptr [ebp - local_1a], -0x34         # 00518d9f
    mov byte ptr [ebp - local_19], -0x34         # 00518da3
    mov byte ptr [ebp - local_18], -0x34         # 00518da7
    mov byte ptr [ebp - local_17], -0x34         # 00518dab
    mov byte ptr [ebp - local_16], -0x34         # 00518daf
    mov byte ptr [ebp - local_15], -0x34         # 00518db3
    mov byte ptr [ebp - local_14], -0x34         # 00518db7
    mov byte ptr [ebp - local_13], -0x34         # 00518dbb
    mov byte ptr [ebp - local_12], -0x5          # 00518dbf
    mov byte ptr [ebp - local_11], 0x3f          # 00518dc3
    mov dword ptr [ebp - local_4], 0x1           # 00518dc7
    {load} mov edx, eax                          # 00518dce
    je.d8 L_00518dd8                             # 00518dd0
    # block 0x00518dd2: entered by fall-through of je at 0x00518dd0, 2 instruction(s), ends with forward jump to 0x00518ddc
    mov byte ptr [ebx + field_2], 0x2d           # 00518dd2
    jmp.d8 L_00518ddc                            # 00518dd6
L_00518dd8:
    # block 0x00518dd8: entered by je at 0x00518dd0, 1 instruction(s), falls into the block at 0x00518ddc
    mov byte ptr [ebx + field_2], 0x20           # 00518dd8
L_00518ddc:
    # block 0x00518ddc: entered by jmp at 0x00518dd6, 3 instruction(s), ends with jne to 0x00518e02 (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00518ddc
    test dx, dx                                  # 00518ddf
    jne.d8 L_00518e02                            # 00518de2
    # block 0x00518de4: entered by fall-through of jne at 0x00518de2, 2 instruction(s), ends with jne to 0x00518e02 (forward)
    test edi, edi                                # 00518de4
    jne.d8 L_00518e02                            # 00518de6
    # block 0x00518de8: entered by fall-through of jne at 0x00518de6, 2 instruction(s), ends with jne to 0x00518e02 (forward)
    cmp dword ptr [ebp + arg_8], edi             # 00518de8
    jne.d8 L_00518e02                            # 00518deb
L_00518ded:
    # block 0x00518ded: entered by jmp at 0x00518ef7; fall-through of jne at 0x00518deb, 5 instruction(s), ends with forward jump to 0x00519000
    and word ptr [ebx], 0x0                      # 00518ded
    mov byte ptr [ebx + field_2], 0x20           # 00518df1
    mov byte ptr [ebx + field_3], 0x1            # 00518df5
    mov byte ptr [ebx + field_4], 0x30           # 00518df9
    jmp.d32 L_00519000                           # 00518dfd
L_00518e02:
    # block 0x00518e02: entered by jne at 0x00518de2; jne at 0x00518de6; jne at 0x00518deb, 2 instruction(s), ends with jne to 0x00518e81 (forward)
    {load} cmp dx, si                            # 00518e02
    jne.d8 L_00518e81                            # 00518e05
    # block 0x00518e07: entered by fall-through of jne at 0x00518e05, 4 instruction(s), ends with jne to 0x00518e1b (forward)
    mov eax, 0x80000000                          # 00518e07
    mov word ptr [ebx], 0x1                      # 00518e0c
    {load} cmp edi, eax                          # 00518e11
    jne.d8 L_00518e1b                            # 00518e13
    # block 0x00518e15: entered by fall-through of jne at 0x00518e13, 2 instruction(s), ends with je to 0x00518e2a (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00518e15
    je.d8 L_00518e2a                             # 00518e19
L_00518e1b:
    # block 0x00518e1b: entered by jne at 0x00518e13; fall-through of je at 0x00518e19, 2 instruction(s), ends with jne to 0x00518e2a (forward)
    test edi, 0x40000000                         # 00518e1b
    jne.d8 L_00518e2a                            # 00518e21
    # block 0x00518e23: entered by fall-through of jne at 0x00518e21, 2 instruction(s), ends with forward jump to 0x00518e70
    push 0x5309cc                                # 00518e23
    jmp.d8 L_00518e70                            # 00518e28
L_00518e2a:
    # block 0x00518e2a: entered by je at 0x00518e19; jne at 0x00518e21, 2 instruction(s), ends with je to 0x00518e44 (forward)
    test cx, cx                                  # 00518e2a
    je.d8 L_00518e44                             # 00518e2d
    # block 0x00518e2f: entered by fall-through of je at 0x00518e2d, 2 instruction(s), ends with jne to 0x00518e44 (forward)
    cmp edi, 0xc0000000                          # 00518e2f
    jne.d8 L_00518e44                            # 00518e35
    # block 0x00518e37: entered by fall-through of jne at 0x00518e35, 2 instruction(s), ends with jne to 0x00518e6b (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00518e37
    jne.d8 L_00518e6b                            # 00518e3b
    # block 0x00518e3d: entered by fall-through of jne at 0x00518e3b, 2 instruction(s), ends with forward jump to 0x00518e53
    push 0x5309c4                                # 00518e3d
    jmp.d8 L_00518e53                            # 00518e42
L_00518e44:
    # block 0x00518e44: entered by je at 0x00518e2d; jne at 0x00518e35, 2 instruction(s), ends with jne to 0x00518e6b (forward)
    {load} cmp edi, eax                          # 00518e44
    jne.d8 L_00518e6b                            # 00518e46
    # block 0x00518e48: entered by fall-through of jne at 0x00518e46, 2 instruction(s), ends with jne to 0x00518e6b (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00518e48
    jne.d8 L_00518e6b                            # 00518e4c
    # block 0x00518e4e: entered by fall-through of jne at 0x00518e4c, 1 instruction(s), falls into the block at 0x00518e53
    push 0x5309bc                                # 00518e4e
L_00518e53:
    # block 0x00518e53: entered by jmp at 0x00518e42, 6 instruction(s), calls FUN_005128b0, falls into the block at 0x00518e62
    lea eax, [ebx + field_4]                     # 00518e53
    push eax                                     # 00518e56
    call FUN_005128b0                            # 00518e57
    pop ecx                                      # 00518e5c
    mov byte ptr [ebx + field_3], 0x5            # 00518e5d
    pop ecx                                      # 00518e61
L_00518e62:
    # block 0x00518e62: entered by jmp at 0x00518e7f, 2 instruction(s), ends with forward jump to 0x00518fd9
    and dword ptr [ebp - local_4], 0x0           # 00518e62
    jmp.d32 L_00518fd9                           # 00518e66
L_00518e6b:
    # block 0x00518e6b: entered by jne at 0x00518e3b; jne at 0x00518e46; jne at 0x00518e4c, 1 instruction(s), falls into the block at 0x00518e70
    push 0x5309b4                                # 00518e6b
L_00518e70:
    # block 0x00518e70: entered by jmp at 0x00518e28, 7 instruction(s), calls FUN_005128b0, ends with backward jump to 0x00518e62
    lea eax, [ebx + field_4]                     # 00518e70
    push eax                                     # 00518e73
    call FUN_005128b0                            # 00518e74
    pop ecx                                      # 00518e79
    mov byte ptr [ebx + field_3], 0x6            # 00518e7a
    pop ecx                                      # 00518e7e
    jmp.d8 L_00518e62                            # 00518e7f
L_00518e81:
    # block 0x00518e81: entered by jne at 0x00518e05, 25 instruction(s), calls FUN_00519229, ends with jb to 0x00518ee2 (forward)
    movzx eax, dx                                # 00518e81
    {load} mov ecx, edi                          # 00518e84
    {load} mov esi, eax                          # 00518e86
    shr ecx, 0x18                                # 00518e88
    imul eax, eax, 0x4d10                        # 00518e8b
    shr esi, 0x8                                 # 00518e91
    and word ptr [ebp - local_10], 0x0           # 00518e94
    push 0x1                                     # 00518e99
    lea ecx, [esi + 2*ecx]                       # 00518e9b
    mov word ptr [ebp - local_6], dx             # 00518e9e
    imul ecx, ecx, 0x4d                          # 00518ea2
    mov dword ptr [ebp - local_a], edi           # 00518ea5
    lea esi, [ecx + eax - 0x134312f4]            # 00518ea8
    mov eax, dword ptr [ebp + arg_8]             # 00518eaf
    sar esi, 0x10                                # 00518eb2
    mov dword ptr [ebp - local_e], eax           # 00518eb5
    movsx eax, si                                # 00518eb8
    neg eax                                      # 00518ebb
    push eax                                     # 00518ebd
    lea eax, [ebp - local_10]                    # 00518ebe
    push eax                                     # 00518ec1
    call FUN_00519229                            # 00518ec2
    add esp, 0xc                                 # 00518ec7
    .insn 0x6681/7, dword ptr [ebp - local_6], 16383{:s16} # 00518eca
    jb.d8 L_00518ee2                             # 00518ed0
    # block 0x00518ed2: entered by fall-through of jb at 0x00518ed0, 8 instruction(s), calls FUN_00519009, falls into the block at 0x00518ee2
    lea eax, [ebp - local_1c]                    # 00518ed2
    inc esi                                      # 00518ed5
    push eax                                     # 00518ed6
    lea eax, [ebp - local_10]                    # 00518ed7
    push eax                                     # 00518eda
    call FUN_00519009                            # 00518edb
    pop ecx                                      # 00518ee0
    pop ecx                                      # 00518ee1
L_00518ee2:
    # block 0x00518ee2: entered by jb at 0x00518ed0, 3 instruction(s), ends with je to 0x00518efc (forward)
    test byte ptr [ebp + arg_18], 0x1            # 00518ee2
    mov word ptr [ebx], si                       # 00518ee6
    je.d8 L_00518efc                             # 00518ee9
    # block 0x00518eeb: entered by fall-through of je at 0x00518ee9, 5 instruction(s), ends with jg to 0x00518eff (forward)
    mov edi, dword ptr [ebp + arg_14]            # 00518eeb
    movsx eax, si                                # 00518eee
    {load} add edi, eax                          # 00518ef1
    test edi, edi                                # 00518ef3
    jg.d8 L_00518eff                             # 00518ef5
    # block 0x00518ef7: entered by fall-through of jg at 0x00518ef5, 1 instruction(s), ends with backward jump to 0x00518ded
    jmp.d32 L_00518ded                           # 00518ef7
L_00518efc:
    # block 0x00518efc: entered by je at 0x00518ee9, 1 instruction(s), falls into the block at 0x00518eff
    mov edi, dword ptr [ebp + arg_14]            # 00518efc
L_00518eff:
    # block 0x00518eff: entered by jg at 0x00518ef5, 2 instruction(s), ends with jle to 0x00518f07 (forward)
    cmp edi, 0x15                                # 00518eff
    jle.d8 L_00518f07                            # 00518f02
    # block 0x00518f04: entered by fall-through of jle at 0x00518f02, 2 instruction(s), falls into the block at 0x00518f07
    push 0x15                                    # 00518f04
    pop edi                                      # 00518f06
L_00518f07:
    # block 0x00518f07: entered by jle at 0x00518f02, 4 instruction(s), falls into the block at 0x00518f1d
    movzx esi, word ptr [ebp - local_6]          # 00518f07
    sub esi, 0x3ffe                              # 00518f0b
    and word ptr [ebp - local_6], 0x0            # 00518f11
    mov dword ptr [ebp + arg_1c], 0x8            # 00518f16
L_00518f1d:
    # block 0x00518f1d: entered by jne at 0x00518f2a, 6 instruction(s), calls FUN_00518c54, ends with jne to 0x00518f1d (backward)
    lea eax, [ebp - local_10]                    # 00518f1d
    push eax                                     # 00518f20
    call FUN_00518c54                            # 00518f21
    dec dword ptr [ebp + arg_1c]                 # 00518f26
    pop ecx                                      # 00518f29
    jne.d8 L_00518f1d                            # 00518f2a
    # block 0x00518f2c: entered by fall-through of jne at 0x00518f2a, 2 instruction(s), ends with jge to 0x00518f47 (forward)
    test esi, esi                                # 00518f2c
    jge.d8 L_00518f47                            # 00518f2e
    # block 0x00518f30: entered by fall-through of jge at 0x00518f2e, 3 instruction(s), ends with jle to 0x00518f47 (forward)
    neg esi                                      # 00518f30
    and esi, 0xff                                # 00518f32
    jle.d8 L_00518f47                            # 00518f38
L_00518f3a:
    # block 0x00518f3a: entered by jne at 0x00518f45; fall-through of jle at 0x00518f38, 6 instruction(s), calls FUN_00518c82, ends with jne to 0x00518f3a (backward)
    lea eax, [ebp - local_10]                    # 00518f3a
    push eax                                     # 00518f3d
    call FUN_00518c82                            # 00518f3e
    dec esi                                      # 00518f43
    pop ecx                                      # 00518f44
    jne.d8 L_00518f3a                            # 00518f45
L_00518f47:
    # block 0x00518f47: entered by jge at 0x00518f2e; jle at 0x00518f38; fall-through of jne at 0x00518f45, 5 instruction(s), ends with jle to 0x00518fa4 (forward)
    lea ecx, [edi + field_1]                     # 00518f47
    lea eax, [ebx + field_4]                     # 00518f4a
    test ecx, ecx                                # 00518f4d
    mov dword ptr [ebp + arg_1c], eax            # 00518f4f
    jle.d8 L_00518fa4                            # 00518f52
    # block 0x00518f54: entered by fall-through of jle at 0x00518f52, 1 instruction(s), falls into the block at 0x00518f57
    mov dword ptr [ebp + arg_14], ecx            # 00518f54
L_00518f57:
    # block 0x00518f57: entered by jne at 0x00518f9f, 28 instruction(s), calls FUN_00518c54, FUN_00518bf6, ends with jne to 0x00518f57 (backward)
    lea esi, [ebp - local_10]                    # 00518f57
    lea edi, [ebp + arg_8]                       # 00518f5a
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518f5d
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518f5e
    lea eax, [ebp - local_10]                    # 00518f5f
    push eax                                     # 00518f62
    movsd dword ptr es:[edi], dword ptr [esi]    # 00518f63
    call FUN_00518c54                            # 00518f64
    lea eax, [ebp - local_10]                    # 00518f69
    push eax                                     # 00518f6c
    call FUN_00518c54                            # 00518f6d
    lea eax, [ebp + arg_8]                       # 00518f72
    push eax                                     # 00518f75
    lea eax, [ebp - local_10]                    # 00518f76
    push eax                                     # 00518f79
    call FUN_00518bf6                            # 00518f7a
    lea eax, [ebp - local_10]                    # 00518f7f
    push eax                                     # 00518f82
    call FUN_00518c54                            # 00518f83
    mov al, byte ptr [ebp - local_5]             # 00518f88
    mov ecx, dword ptr [ebp + arg_1c]            # 00518f8b
    and byte ptr [ebp - local_5], 0x0            # 00518f8e
    add esp, 0x14                                # 00518f92
    add al, 0x30                                 # 00518f95
    inc dword ptr [ebp + arg_1c]                 # 00518f97
    dec dword ptr [ebp + arg_14]                 # 00518f9a
    mov byte ptr [ecx], al                       # 00518f9d
    jne.d8 L_00518f57                            # 00518f9f
    # block 0x00518fa1: entered by fall-through of jne at 0x00518f9f, 1 instruction(s), falls into the block at 0x00518fa4
    mov eax, dword ptr [ebp + arg_1c]            # 00518fa1
L_00518fa4:
    # block 0x00518fa4: entered by jle at 0x00518f52, 6 instruction(s), ends with jl to 0x00518fe1 (forward)
    mov cl, byte ptr [eax - field_minus_1]       # 00518fa4
    dec eax                                      # 00518fa7
    dec eax                                      # 00518fa8
    cmp cl, 0x35                                 # 00518fa9
    lea ecx, [ebx + field_4]                     # 00518fac
    jl.d8 L_00518fe1                             # 00518faf
L_00518fb1:
    # block 0x00518fb1: entered by jmp at 0x00518fbe; fall-through of jl at 0x00518faf, 2 instruction(s), ends with jb to 0x00518fc4 (forward)
    {load} cmp eax, ecx                          # 00518fb1
    jb.d8 L_00518fc4                             # 00518fb3
    # block 0x00518fb5: entered by fall-through of jb at 0x00518fb3, 2 instruction(s), ends with jne to 0x00518fc0 (forward)
    cmp byte ptr [eax], 0x39                     # 00518fb5
    jne.d8 L_00518fc0                            # 00518fb8
    # block 0x00518fba: entered by fall-through of jne at 0x00518fb8, 3 instruction(s), ends with backward jump to 0x00518fb1
    mov byte ptr [eax], 0x30                     # 00518fba
    dec eax                                      # 00518fbd
    jmp.d8 L_00518fb1                            # 00518fbe
L_00518fc0:
    # block 0x00518fc0: entered by jne at 0x00518fb8, 2 instruction(s), ends with jae to 0x00518fc8 (forward)
    {load} cmp eax, ecx                          # 00518fc0
    jae.d8 L_00518fc8                            # 00518fc2
L_00518fc4:
    # block 0x00518fc4: entered by jb at 0x00518fb3; fall-through of jae at 0x00518fc2, 2 instruction(s), falls into the block at 0x00518fc8
    inc eax                                      # 00518fc4
    inc word ptr [ebx]                           # 00518fc5
L_00518fc8:
    # block 0x00518fc8: entered by jae at 0x00518fc2, 1 instruction(s), falls into the block at 0x00518fca
    inc byte ptr [eax]                           # 00518fc8
L_00518fca:
    # block 0x00518fca: entered by jae at 0x00518fef, 5 instruction(s), falls into the block at 0x00518fd9
    {load} sub al, bl                            # 00518fca
    sub al, 0x3                                  # 00518fcc
    mov byte ptr [ebx + field_3], al             # 00518fce
    movsx eax, al                                # 00518fd1
    and byte ptr [eax + ebx + field_4], 0x0      # 00518fd4
L_00518fd9:
    # block 0x00518fd9: entered by jmp at 0x00518e66, 1 instruction(s), falls into the block at 0x00518fdc
    mov eax, dword ptr [ebp - local_4]           # 00518fd9
L_00518fdc:
    # block 0x00518fdc: entered by jmp at 0x00519007, 5 instruction(s), ends with ret
    pop edi                                      # 00518fdc
    pop esi                                      # 00518fdd
    pop ebx                                      # 00518fde
    leave                                        # 00518fdf
    ret                                          # 00518fe0
L_00518fe1:
    # block 0x00518fe1: entered by jl at 0x00518faf; jmp at 0x00518feb, 2 instruction(s), ends with jb to 0x00518ff1 (forward)
    {load} cmp eax, ecx                          # 00518fe1
    jb.d8 L_00518ff1                             # 00518fe3
    # block 0x00518fe5: entered by fall-through of jb at 0x00518fe3, 2 instruction(s), ends with jne to 0x00518fed (forward)
    cmp byte ptr [eax], 0x30                     # 00518fe5
    jne.d8 L_00518fed                            # 00518fe8
    # block 0x00518fea: entered by fall-through of jne at 0x00518fe8, 2 instruction(s), ends with backward jump to 0x00518fe1
    dec eax                                      # 00518fea
    jmp.d8 L_00518fe1                            # 00518feb
L_00518fed:
    # block 0x00518fed: entered by jne at 0x00518fe8, 2 instruction(s), ends with jae to 0x00518fca (backward)
    {load} cmp eax, ecx                          # 00518fed
    jae.d8 L_00518fca                            # 00518fef
L_00518ff1:
    # block 0x00518ff1: entered by jb at 0x00518fe3; fall-through of jae at 0x00518fef, 4 instruction(s), falls into the block at 0x00519000
    and word ptr [ebx], 0x0                      # 00518ff1
    mov byte ptr [ebx + field_2], 0x20           # 00518ff5
    mov byte ptr [ebx + field_3], 0x1            # 00518ff9
    mov byte ptr [ecx], 0x30                     # 00518ffd
L_00519000:
    # block 0x00519000: entered by jmp at 0x00518dfd, 4 instruction(s), ends with backward jump to 0x00518fdc
    and byte ptr [ebx + field_5], 0x0            # 00519000
    push 0x1                                     # 00519004
    pop eax                                      # 00519006
    jmp.d8 L_00518fdc                            # 00519007

