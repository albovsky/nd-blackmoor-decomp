# FUN_00516be5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516be5
# extent:       0x00516be5-0x00516d51 (364 code bytes)
# span:         0x00516be5-0x00516d51 (code 364, tables 0, padding 0)
# sha256:       ac4bce6789334fee22ce37080d99a8f1a426503b82faf491ac48588d73aadc4a
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516be5
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_9, local_c, local_18
# fields:       [eax + n] field_2, field_6, field_a; [ecx + n] field_4; [edi + n] field_4, field_8, field_c, field_10, field_14
# callees:      calls FUN_00516b3d, FUN_00516b31, FUN_00516b16, FUN_00516a8a, FUN_00516b58
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 138 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_9, 0x9  # offset -0x9
.equ local_c, 0xc  # offset -0xc
.equ local_18, 0x18  # offset -0x18
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00516a8a, .text + (0x00516a8a - 0x401000)
.set FUN_00516b16, .text + (0x00516b16 - 0x401000)
.set FUN_00516b31, .text + (0x00516b31 - 0x401000)
.set FUN_00516b3d, .text + (0x00516b3d - 0x401000)
.set FUN_00516b58, .text + (0x00516b58 - 0x401000)

.org 0x00516be5 - 0x401000
.globl FUN_00516be5
FUN_00516be5:
    # block 0x00516be5: entry, 23 instruction(s), ends with jne to 0x00516c52 (forward)
    push ebp                                     # 00516be5
    {load} mov ebp, esp                          # 00516be6
    sub esp, 0x18                                # 00516be8
    mov eax, dword ptr [ebp + arg_8]             # 00516beb
    push ebx                                     # 00516bee
    push esi                                     # 00516bef
    push edi                                     # 00516bf0
    movzx ecx, word ptr [eax + field_a]          # 00516bf1
    {load} mov ebx, ecx                          # 00516bf5
    and ecx, 0x8000                              # 00516bf7
    mov dword ptr [ebp + arg_8], ecx             # 00516bfd
    mov ecx, dword ptr [eax + field_6]           # 00516c00
    mov dword ptr [ebp - local_c], ecx           # 00516c03
    mov ecx, dword ptr [eax + field_2]           # 00516c06
    movzx eax, word ptr [eax]                    # 00516c09
    mov edi, dword ptr [ebp + arg_10]            # 00516c0c
    and ebx, 0x7fff                              # 00516c0f
    sub ebx, 0x3fff                              # 00516c15
    mov dword ptr [ebp - local_8], ecx           # 00516c1b
    shl eax, 0x10                                # 00516c1e
    cmp ebx, 0xffffc001                          # 00516c21
    mov dword ptr [ebp - local_4], eax           # 00516c27
    jne.d8 L_00516c52                            # 00516c2a
    # block 0x00516c2c: entered by fall-through of jne at 0x00516c2a, 7 instruction(s), calls FUN_00516b3d, ends with jne to 0x00516d11 (forward)
    lea eax, [ebp - local_c]                     # 00516c2c
    {load} xor esi, esi                          # 00516c2f
    push eax                                     # 00516c31
    call FUN_00516b3d                            # 00516c32
    test eax, eax                                # 00516c37
    pop ecx                                      # 00516c39
    jne.d32 L_00516d11                           # 00516c3a
    # block 0x00516c40: entered by fall-through of jne at 0x00516c3a, 4 instruction(s), calls FUN_00516b31, falls into the block at 0x00516c4a
    lea eax, [ebp - local_c]                     # 00516c40
    push eax                                     # 00516c43
    call FUN_00516b31                            # 00516c44
    pop ecx                                      # 00516c49
L_00516c4a:
    # block 0x00516c4a: entered by jmp at 0x00516cc9, 1 instruction(s), falls into the block at 0x00516c4c
    push 0x2                                     # 00516c4a
L_00516c4c:
    # block 0x00516c4c: entered by jmp at 0x00516cf5, 2 instruction(s), ends with forward jump to 0x00516d13
    pop eax                                      # 00516c4c
    jmp.d32 L_00516d13                           # 00516c4d
L_00516c52:
    # block 0x00516c52: entered by jne at 0x00516c2a, 12 instruction(s), calls FUN_00516b16, FUN_00516a8a, ends with je to 0x00516c73 (forward)
    lea eax, [ebp - local_c]                     # 00516c52
    push eax                                     # 00516c55
    lea eax, [ebp - local_18]                    # 00516c56
    push eax                                     # 00516c59
    call FUN_00516b16                            # 00516c5a
    push dword ptr [edi + field_8]               # 00516c5f
    lea eax, [ebp - local_c]                     # 00516c62
    push eax                                     # 00516c65
    call FUN_00516a8a                            # 00516c66
    add esp, 0x10                                # 00516c6b
    test eax, eax                                # 00516c6e
    je.d8 L_00516c73                             # 00516c70
    # block 0x00516c72: entered by fall-through of je at 0x00516c70, 1 instruction(s), falls into the block at 0x00516c73
    inc ebx                                      # 00516c72
L_00516c73:
    # block 0x00516c73: entered by je at 0x00516c70, 5 instruction(s), ends with jge to 0x00516c8b (forward)
    mov eax, dword ptr [edi + field_4]           # 00516c73
    {load} mov ecx, eax                          # 00516c76
    sub ecx, dword ptr [edi + field_8]           # 00516c78
    {load} cmp ebx, ecx                          # 00516c7b
    jge.d8 L_00516c8b                            # 00516c7d
    # block 0x00516c7f: entered by fall-through of jge at 0x00516c7d, 5 instruction(s), calls FUN_00516b31, ends with forward jump to 0x00516cc7
    lea eax, [ebp - local_c]                     # 00516c7f
    push eax                                     # 00516c82
    call FUN_00516b31                            # 00516c83
    pop ecx                                      # 00516c88
    jmp.d8 L_00516cc7                            # 00516c89
L_00516c8b:
    # block 0x00516c8b: entered by jge at 0x00516c7d, 2 instruction(s), ends with jg to 0x00516cce (forward)
    {load} cmp ebx, eax                          # 00516c8b
    jg.d8 L_00516cce                             # 00516c8d
    # block 0x00516c8f: entered by fall-through of jg at 0x00516c8d, 22 instruction(s), calls FUN_00516b16, FUN_00516b58, FUN_00516a8a, falls into the block at 0x00516cc7
    {load} sub eax, ebx                          # 00516c8f
    {load} mov esi, eax                          # 00516c91
    lea eax, [ebp - local_18]                    # 00516c93
    push eax                                     # 00516c96
    lea eax, [ebp - local_c]                     # 00516c97
    push eax                                     # 00516c9a
    call FUN_00516b16                            # 00516c9b
    lea eax, [ebp - local_c]                     # 00516ca0
    push esi                                     # 00516ca3
    push eax                                     # 00516ca4
    call FUN_00516b58                            # 00516ca5
    push dword ptr [edi + field_8]               # 00516caa
    lea eax, [ebp - local_c]                     # 00516cad
    push eax                                     # 00516cb0
    call FUN_00516a8a                            # 00516cb1
    mov eax, dword ptr [edi + field_c]           # 00516cb6
    inc eax                                      # 00516cb9
    push eax                                     # 00516cba
    lea eax, [ebp - local_c]                     # 00516cbb
    push eax                                     # 00516cbe
    call FUN_00516b58                            # 00516cbf
    add esp, 0x20                                # 00516cc4
L_00516cc7:
    # block 0x00516cc7: entered by jmp at 0x00516c89, 2 instruction(s), ends with backward jump to 0x00516c4a
    {load} xor esi, esi                          # 00516cc7
    jmp.d32 L_00516c4a                           # 00516cc9
L_00516cce:
    # block 0x00516cce: entered by jg at 0x00516c8d, 2 instruction(s), ends with jl to 0x00516cfa (forward)
    cmp ebx, dword ptr [edi]                     # 00516cce
    jl.d8 L_00516cfa                             # 00516cd0
    # block 0x00516cd2: entered by fall-through of jl at 0x00516cd0, 13 instruction(s), calls FUN_00516b31, FUN_00516b58, ends with backward jump to 0x00516c4c
    lea eax, [ebp - local_c]                     # 00516cd2
    push eax                                     # 00516cd5
    call FUN_00516b31                            # 00516cd6
    push dword ptr [edi + field_c]               # 00516cdb
    or byte ptr [ebp - local_9], -0x80           # 00516cde
    lea eax, [ebp - local_c]                     # 00516ce2
    push eax                                     # 00516ce5
    call FUN_00516b58                            # 00516ce6
    mov esi, dword ptr [edi + field_14]          # 00516ceb
    add esp, 0xc                                 # 00516cee
    add esi, dword ptr [edi]                     # 00516cf1
    push 0x1                                     # 00516cf3
    jmp.d32 L_00516c4c                           # 00516cf5
L_00516cfa:
    # block 0x00516cfa: entered by jl at 0x00516cd0, 9 instruction(s), calls FUN_00516b58, falls into the block at 0x00516d11
    push dword ptr [edi + field_c]               # 00516cfa
    mov esi, dword ptr [edi + field_14]          # 00516cfd
    and byte ptr [ebp - local_9], 0x7f           # 00516d00
    lea eax, [ebp - local_c]                     # 00516d04
    push eax                                     # 00516d07
    {load} add esi, ebx                          # 00516d08
    call FUN_00516b58                            # 00516d0a
    pop ecx                                      # 00516d0f
    pop ecx                                      # 00516d10
L_00516d11:
    # block 0x00516d11: entered by jne at 0x00516c3a, 1 instruction(s), falls into the block at 0x00516d13
    {load} xor eax, eax                          # 00516d11
L_00516d13:
    # block 0x00516d13: entered by jmp at 0x00516c4d, 13 instruction(s), ends with jne to 0x00516d42 (forward)
    push 0x1f                                    # 00516d13
    pop ecx                                      # 00516d15
    sub ecx, dword ptr [edi + field_c]           # 00516d16
    mov edi, dword ptr [edi + field_10]          # 00516d19
    shl esi, cl                                  # 00516d1c
    mov ecx, dword ptr [ebp + arg_8]             # 00516d1e
    neg ecx                                      # 00516d21
    {load} sbb ecx, ecx                          # 00516d23
    and ecx, 0x80000000                          # 00516d25
    {load} or esi, ecx                           # 00516d2b
    or esi, dword ptr [ebp - local_c]            # 00516d2d
    cmp edi, 0x40                                # 00516d30
    jne.d8 L_00516d42                            # 00516d33
    # block 0x00516d35: entered by fall-through of jne at 0x00516d33, 5 instruction(s), ends with forward jump to 0x00516d4c
    mov ecx, dword ptr [ebp + arg_c]             # 00516d35
    mov edx, dword ptr [ebp - local_8]           # 00516d38
    mov dword ptr [ecx + field_4], esi           # 00516d3b
    mov dword ptr [ecx], edx                     # 00516d3e
    jmp.d8 L_00516d4c                            # 00516d40
L_00516d42:
    # block 0x00516d42: entered by jne at 0x00516d33, 2 instruction(s), ends with jne to 0x00516d4c (forward)
    cmp edi, 0x20                                # 00516d42
    jne.d8 L_00516d4c                            # 00516d45
    # block 0x00516d47: entered by fall-through of jne at 0x00516d45, 2 instruction(s), falls into the block at 0x00516d4c
    mov ecx, dword ptr [ebp + arg_c]             # 00516d47
    mov dword ptr [ecx], esi                     # 00516d4a
L_00516d4c:
    # block 0x00516d4c: entered by jmp at 0x00516d40; jne at 0x00516d45, 5 instruction(s), ends with ret
    pop edi                                      # 00516d4c
    pop esi                                      # 00516d4d
    pop ebx                                      # 00516d4e
    leave                                        # 00516d4f
    ret                                          # 00516d50

