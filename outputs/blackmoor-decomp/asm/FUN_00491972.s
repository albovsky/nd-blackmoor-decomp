# FUN_00491972
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00491972
# extent:       0x00491972-0x00491db2 (1088 code bytes)
# span:         0x00491972-0x00491db2 (code 1088, tables 0, padding 0)
# sha256:       11438fb5e7b1a8f9d13e151e3899d3258061ee788c573b5b74a2373530c2808b
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00491972
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1f3b, field_1f47, field_1f4b, field_41f1, field_4345, field_43e5, field_50e9, field_50ed, field_50ee, field_50ef, field_50f0, field_50f2; [ecx + n] field_1f3b, field_1f67, field_41f1, field_4345, field_50e9, field_50ed, field_50ee, field_50ef, field_50f0, field_50f1; [edx + n] field_1f4f, field_41f1, field_4345, field_4539, field_50ed, field_50ee, field_50ef, field_50f1, field_50f2
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 282 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_1f3b, 0x1f3b  # offset +0x1f3b
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f4b, 0x1f4b  # offset +0x1f4b
.equ field_1f4f, 0x1f4f  # offset +0x1f4f
.equ field_1f67, 0x1f67  # offset +0x1f67
.equ field_41f1, 0x41f1  # offset +0x41f1
.equ field_4345, 0x4345  # offset +0x4345
.equ field_43e5, 0x43e5  # offset +0x43e5
.equ field_4539, 0x4539  # offset +0x4539
.equ field_50e9, 0x50e9  # offset +0x50e9
.equ field_50ed, 0x50ed  # offset +0x50ed
.equ field_50ee, 0x50ee  # offset +0x50ee
.equ field_50ef, 0x50ef  # offset +0x50ef
.equ field_50f0, 0x50f0  # offset +0x50f0
.equ field_50f1, 0x50f1  # offset +0x50f1
.equ field_50f2, 0x50f2  # offset +0x50f2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00491972 - 0x401000
.globl FUN_00491972
FUN_00491972:
    # block 0x00491972: entry, 27 instruction(s), ends with forward jump to 0x004919d6
    push ebp                                     # 00491972
    {load} mov ebp, esp                          # 00491973
    sub esp, 0x18                                # 00491975
    push edi                                     # 00491978
    mov dword ptr [ebp - local_18], ecx          # 00491979
    mov ecx, 0x55                                # 0049197c
    {load} xor eax, eax                          # 00491981
    mov edi, dword ptr [ebp - local_18]          # 00491983
    add edi, 0x41f1                              # 00491986
    rep stosd dword ptr es:[edi], eax            # 0049198c
    mov ecx, 0x28                                # 0049198e
    {load} xor eax, eax                          # 00491993
    mov edi, dword ptr [ebp - local_18]          # 00491995
    add edi, 0x4345                              # 00491998
    rep stosd dword ptr es:[edi], eax            # 0049199e
    mov ecx, 0x55                                # 004919a0
    {load} xor eax, eax                          # 004919a5
    mov edi, dword ptr [ebp - local_18]          # 004919a7
    add edi, 0x43e5                              # 004919aa
    rep stosd dword ptr es:[edi], eax            # 004919b0
    mov ecx, 0x19                                # 004919b2
    {load} xor eax, eax                          # 004919b7
    mov edi, dword ptr [ebp - local_18]          # 004919b9
    add edi, 0x4539                              # 004919bc
    rep stosd dword ptr es:[edi], eax            # 004919c2
    mov dword ptr [ebp - local_c], 0x0           # 004919c4
    jmp.d8 L_004919d6                            # 004919cb
L_004919cd:
    # block 0x004919cd: entered by jmp at 0x00491da4, 3 instruction(s), falls into the block at 0x004919d6
    mov eax, dword ptr [ebp - local_c]           # 004919cd
    add eax, 0x1                                 # 004919d0
    mov dword ptr [ebp - local_c], eax           # 004919d3
L_004919d6:
    # block 0x004919d6: entered by jmp at 0x004919cb, 2 instruction(s), ends with jge to 0x00491da9 (forward)
    cmp dword ptr [ebp - local_c], 0xa6          # 004919d6
    jge.d32 L_00491da9                           # 004919dd
    # block 0x004919e3: entered by fall-through of jge at 0x004919dd, 2 instruction(s), ends with forward jump to 0x004919f5
    mov dword ptr [ebp - local_10], 0x0          # 004919e3
    jmp.d8 L_004919f5                            # 004919ea
L_004919ec:
    # block 0x004919ec: entered by jmp at 0x00491d9f, 3 instruction(s), falls into the block at 0x004919f5
    mov ecx, dword ptr [ebp - local_10]          # 004919ec
    add ecx, 0x1                                 # 004919ef
    mov dword ptr [ebp - local_10], ecx          # 004919f2
L_004919f5:
    # block 0x004919f5: entered by jmp at 0x004919ea, 2 instruction(s), ends with jge to 0x00491da4 (forward)
    cmp dword ptr [ebp - local_10], 0xa6         # 004919f5
    jge.d32 L_00491da4                           # 004919fc
    # block 0x00491a02: entered by fall-through of jge at 0x004919fc, 12 instruction(s), ends with jne to 0x00491a37 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00491a02
    imul edx, edx, 0xa6                          # 00491a05
    mov eax, dword ptr [ebp - local_18]          # 00491a0b
    mov ecx, dword ptr [eax + field_1f47]        # 00491a0e
    lea edx, [ecx + 4*edx]                       # 00491a14
    mov eax, dword ptr [ebp - local_18]          # 00491a17
    mov ecx, dword ptr [ebp - local_10]          # 00491a1a
    mov edx, dword ptr [edx + 4*ecx]             # 00491a1d
    mov dword ptr [eax + field_50e9], edx        # 00491a20
    mov eax, dword ptr [ebp - local_18]          # 00491a26
    cmp dword ptr [eax + field_50e9], 0x0        # 00491a29
    jne.d8 L_00491a37                            # 00491a30
    # block 0x00491a32: entered by fall-through of jne at 0x00491a30, 1 instruction(s), ends with forward jump to 0x00491dab
    jmp.d32 L_00491dab                           # 00491a32
L_00491a37:
    # block 0x00491a37: entered by jne at 0x00491a30, 22 instruction(s), ends with je to 0x00491ab6 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00491a37
    mov edx, dword ptr [ecx + field_50e9]        # 00491a3a
    and edx, 0xff                                # 00491a40
    mov eax, dword ptr [ebp - local_18]          # 00491a46
    mov byte ptr [eax + field_50ed], dl          # 00491a49
    mov ecx, dword ptr [ebp - local_18]          # 00491a4f
    mov edx, dword ptr [ecx + field_50e9]        # 00491a52
    sar edx, 0x8                                 # 00491a58
    and edx, 0xff                                # 00491a5b
    mov eax, dword ptr [ebp - local_18]          # 00491a61
    mov byte ptr [eax + field_50ee], dl          # 00491a64
    mov ecx, dword ptr [ebp - local_18]          # 00491a6a
    mov edx, dword ptr [ecx + field_50e9]        # 00491a6d
    sar edx, 0x10                                # 00491a73
    and edx, 0xff                                # 00491a76
    mov eax, dword ptr [ebp - local_18]          # 00491a7c
    mov byte ptr [eax + field_50ef], dl          # 00491a7f
    mov ecx, dword ptr [ebp - local_18]          # 00491a85
    {load} xor edx, edx                          # 00491a88
    mov dl, byte ptr [ecx + field_50ed]          # 00491a8a
    test edx, edx                                # 00491a90
    je.d8 L_00491ab6                             # 00491a92
    # block 0x00491a94: entered by fall-through of je at 0x00491a92, 5 instruction(s), ends with je to 0x00491ab6 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00491a94
    {load} xor ecx, ecx                          # 00491a97
    mov cl, byte ptr [eax + field_50ee]          # 00491a99
    test ecx, ecx                                # 00491a9f
    je.d8 L_00491ab6                             # 00491aa1
    # block 0x00491aa3: entered by fall-through of je at 0x00491aa1, 5 instruction(s), ends with jne to 0x00491ba6 (forward)
    mov edx, dword ptr [ebp - local_18]          # 00491aa3
    {load} xor eax, eax                          # 00491aa6
    mov al, byte ptr [edx + field_50ef]          # 00491aa8
    test eax, eax                                # 00491aae
    jne.d32 L_00491ba6                           # 00491ab0
L_00491ab6:
    # block 0x00491ab6: entered by je at 0x00491a92; je at 0x00491aa1; fall-through of jne at 0x00491ab0, 5 instruction(s), ends with jne to 0x00491ba6 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00491ab6
    mov edx, dword ptr [ecx + field_50e9]        # 00491ab9
    and edx, 0x10000000                          # 00491abf
    test edx, edx                                # 00491ac5
    jne.d32 L_00491ba6                           # 00491ac7
    # block 0x00491acd: entered by fall-through of jne at 0x00491ac7, 13 instruction(s), ends with jne to 0x00491b09 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00491acd
    imul eax, eax, 0xa6                          # 00491ad0
    mov ecx, dword ptr [ebp - local_18]          # 00491ad6
    mov edx, dword ptr [ecx + field_1f67]        # 00491ad9
    lea eax, [edx + 2*eax]                       # 00491adf
    mov ecx, dword ptr [ebp - local_10]          # 00491ae2
    mov dx, word ptr [eax + 2*ecx]               # 00491ae5
    mov word ptr [ebp - local_14], dx            # 00491ae9
    mov eax, dword ptr [ebp - local_18]          # 00491aed
    {load} xor ecx, ecx                          # 00491af0
    mov cl, byte ptr [eax + field_50ed]          # 00491af2
    test ecx, ecx                                # 00491af8
    jne.d8 L_00491b09                            # 00491afa
    # block 0x00491afc: entered by fall-through of jne at 0x00491afa, 4 instruction(s), ends with jg to 0x00491b52 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00491afc
    and edx, 0xffff                              # 00491aff
    test edx, edx                                # 00491b05
    jg.d8 L_00491b52                             # 00491b07
L_00491b09:
    # block 0x00491b09: entered by jne at 0x00491afa; fall-through of jg at 0x00491b07, 5 instruction(s), ends with jne to 0x00491b2c (forward)
    mov eax, dword ptr [ebp - local_18]          # 00491b09
    {load} xor ecx, ecx                          # 00491b0c
    mov cl, byte ptr [eax + field_50ee]          # 00491b0e
    test ecx, ecx                                # 00491b14
    jne.d8 L_00491b2c                            # 00491b16
    # block 0x00491b18: entered by fall-through of jne at 0x00491b16, 5 instruction(s), ends with jg to 0x00491b52 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00491b18
    and edx, 0xffff                              # 00491b1b
    mov eax, dword ptr [ebp - local_18]          # 00491b21
    cmp edx, dword ptr [eax + field_1f3b]        # 00491b24
    jg.d8 L_00491b52                             # 00491b2a
L_00491b2c:
    # block 0x00491b2c: entered by jne at 0x00491b16; fall-through of jg at 0x00491b2a, 5 instruction(s), ends with jne to 0x00491ba6 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00491b2c
    {load} xor edx, edx                          # 00491b2f
    mov dl, byte ptr [ecx + field_50ef]          # 00491b31
    test edx, edx                                # 00491b37
    jne.d8 L_00491ba6                            # 00491b39
    # block 0x00491b3b: entered by fall-through of jne at 0x00491b39, 7 instruction(s), ends with jle to 0x00491ba6 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00491b3b
    and eax, 0xffff                              # 00491b3e
    mov ecx, dword ptr [ebp - local_18]          # 00491b43
    mov edx, dword ptr [ecx + field_1f3b]        # 00491b46
    shl edx                                      # 00491b4c
    {load} cmp eax, edx                          # 00491b4e
    jle.d8 L_00491ba6                            # 00491b50
L_00491b52:
    # block 0x00491b52: entered by jg at 0x00491b07; jg at 0x00491b2a; fall-through of jle at 0x00491b50, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00491b9c (forward)
    mov eax, dword ptr [ebp - local_18]          # 00491b52
    mov ecx, dword ptr [eax + field_50e9]        # 00491b55
    push ecx                                     # 00491b5b
    mov edx, dword ptr [ebp - local_10]          # 00491b5c
    push edx                                     # 00491b5f
    mov eax, dword ptr [ebp - local_c]           # 00491b60
    push eax                                     # 00491b63
    push 0x54eeb4                                # 00491b64
    push 0x63888b                                # 00491b69
    call FUN_0050ca3e                            # 00491b6e
    add esp, 0x14                                # 00491b73
    push 0x0                                     # 00491b76
    push 0x0                                     # 00491b78
    push 0x63888b                                # 00491b7a
    call FUN_0052139c                            # 00491b7f
    movsx ecx, word ptr [0x63a4cd]               # 00491b84
    test ecx, ecx                                # 00491b8b
    je.d8 L_00491b9c                             # 00491b8d
    # block 0x00491b8f: entered by fall-through of je at 0x00491b8d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00491b9c
    push 0x63888b                                # 00491b8f
    call FUN_0044a2b7                            # 00491b94
    add esp, 0x4                                 # 00491b99
L_00491b9c:
    # block 0x00491b9c: entered by je at 0x00491b8d, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x00491ba6
    mov ecx, 0x5cf659                            # 00491b9c
    call FUN_004c97b4                            # 00491ba1
L_00491ba6:
    # block 0x00491ba6: entered by jne at 0x00491ab0; jne at 0x00491ac7; jne at 0x00491b39; jle at 0x00491b50, 6 instruction(s), ends with je to 0x00491c2e (forward)
    mov edx, dword ptr [ebp - local_18]          # 00491ba6
    {load} xor eax, eax                          # 00491ba9
    mov al, byte ptr [edx + field_50ed]          # 00491bab
    and eax, 0x7f                                # 00491bb1
    test eax, eax                                # 00491bb4
    je.d8 L_00491c2e                             # 00491bb6
    # block 0x00491bb8: entered by fall-through of je at 0x00491bb6, 16 instruction(s), ends with jne to 0x00491c15 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00491bb8
    {load} xor edx, edx                          # 00491bbb
    mov dl, byte ptr [ecx + field_50ed]          # 00491bbd
    and edx, 0x80                                # 00491bc3
    mov eax, dword ptr [ebp - local_18]          # 00491bc9
    mov byte ptr [eax + field_50f0], dl          # 00491bcc
    mov ecx, dword ptr [ebp - local_18]          # 00491bd2
    mov dl, byte ptr [ecx + field_50ed]          # 00491bd5
    and dl, 0x7f                                 # 00491bdb
    mov eax, dword ptr [ebp - local_18]          # 00491bde
    mov byte ptr [eax + field_50ed], dl          # 00491be1
    mov ecx, dword ptr [ebp - local_18]          # 00491be7
    {load} xor edx, edx                          # 00491bea
    mov dl, byte ptr [ecx + field_50f0]          # 00491bec
    cmp edx, 0x80                                # 00491bf2
    jne.d8 L_00491c15                            # 00491bf8
    # block 0x00491bfa: entered by fall-through of jne at 0x00491bf8, 6 instruction(s), ends with forward jump to 0x00491c2e
    mov eax, dword ptr [ebp - local_18]          # 00491bfa
    {load} xor ecx, ecx                          # 00491bfd
    mov cl, byte ptr [eax + field_50ed]          # 00491bff
    mov edx, dword ptr [ebp - local_18]          # 00491c05
    mov dword ptr [edx + 4*ecx + field_4345], 0x1 # 00491c08
    jmp.d8 L_00491c2e                            # 00491c13
L_00491c15:
    # block 0x00491c15: entered by jne at 0x00491bf8, 5 instruction(s), falls into the block at 0x00491c2e
    mov eax, dword ptr [ebp - local_18]          # 00491c15
    {load} xor ecx, ecx                          # 00491c18
    mov cl, byte ptr [eax + field_50ed]          # 00491c1a
    mov edx, dword ptr [ebp - local_18]          # 00491c20
    mov dword ptr [edx + 4*ecx + field_41f1], 0x1 # 00491c23
L_00491c2e:
    # block 0x00491c2e: entered by je at 0x00491bb6; jmp at 0x00491c13, 6 instruction(s), ends with je to 0x00491cb3 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00491c2e
    {load} xor ecx, ecx                          # 00491c31
    mov cl, byte ptr [eax + field_50ee]          # 00491c33
    and ecx, 0x7f                                # 00491c39
    test ecx, ecx                                # 00491c3c
    je.d8 L_00491cb3                             # 00491c3e
    # block 0x00491c40: entered by fall-through of je at 0x00491c3e, 16 instruction(s), ends with jne to 0x00491c9a (forward)
    mov edx, dword ptr [ebp - local_18]          # 00491c40
    {load} xor eax, eax                          # 00491c43
    mov al, byte ptr [edx + field_50ee]          # 00491c45
    and eax, 0x80                                # 00491c4b
    mov ecx, dword ptr [ebp - local_18]          # 00491c50
    mov byte ptr [ecx + field_50f1], al          # 00491c53
    mov edx, dword ptr [ebp - local_18]          # 00491c59
    mov al, byte ptr [edx + field_50ee]          # 00491c5c
    and al, 0x7f                                 # 00491c62
    mov ecx, dword ptr [ebp - local_18]          # 00491c64
    mov byte ptr [ecx + field_50ee], al          # 00491c67
    mov edx, dword ptr [ebp - local_18]          # 00491c6d
    {load} xor eax, eax                          # 00491c70
    mov al, byte ptr [edx + field_50f1]          # 00491c72
    cmp eax, 0x80                                # 00491c78
    jne.d8 L_00491c9a                            # 00491c7d
    # block 0x00491c7f: entered by fall-through of jne at 0x00491c7d, 6 instruction(s), ends with forward jump to 0x00491cb3
    mov ecx, dword ptr [ebp - local_18]          # 00491c7f
    {load} xor edx, edx                          # 00491c82
    mov dl, byte ptr [ecx + field_50ee]          # 00491c84
    mov eax, dword ptr [ebp - local_18]          # 00491c8a
    mov dword ptr [eax + 4*edx + field_4345], 0x1 # 00491c8d
    jmp.d8 L_00491cb3                            # 00491c98
L_00491c9a:
    # block 0x00491c9a: entered by jne at 0x00491c7d, 5 instruction(s), falls into the block at 0x00491cb3
    mov ecx, dword ptr [ebp - local_18]          # 00491c9a
    {load} xor edx, edx                          # 00491c9d
    mov dl, byte ptr [ecx + field_50ee]          # 00491c9f
    mov eax, dword ptr [ebp - local_18]          # 00491ca5
    mov dword ptr [eax + 4*edx + field_41f1], 0x1 # 00491ca8
L_00491cb3:
    # block 0x00491cb3: entered by je at 0x00491c3e; jmp at 0x00491c98, 6 instruction(s), ends with je to 0x00491d3b (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00491cb3
    {load} xor edx, edx                          # 00491cb6
    mov dl, byte ptr [ecx + field_50ef]          # 00491cb8
    and edx, 0x7f                                # 00491cbe
    test edx, edx                                # 00491cc1
    je.d8 L_00491d3b                             # 00491cc3
    # block 0x00491cc5: entered by fall-through of je at 0x00491cc3, 16 instruction(s), ends with jne to 0x00491d22 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00491cc5
    {load} xor ecx, ecx                          # 00491cc8
    mov cl, byte ptr [eax + field_50ef]          # 00491cca
    and ecx, 0x80                                # 00491cd0
    mov edx, dword ptr [ebp - local_18]          # 00491cd6
    mov byte ptr [edx + field_50f2], cl          # 00491cd9
    mov eax, dword ptr [ebp - local_18]          # 00491cdf
    mov cl, byte ptr [eax + field_50ef]          # 00491ce2
    and cl, 0x7f                                 # 00491ce8
    mov edx, dword ptr [ebp - local_18]          # 00491ceb
    mov byte ptr [edx + field_50ef], cl          # 00491cee
    mov eax, dword ptr [ebp - local_18]          # 00491cf4
    {load} xor ecx, ecx                          # 00491cf7
    mov cl, byte ptr [eax + field_50f2]          # 00491cf9
    cmp ecx, 0x80                                # 00491cff
    jne.d8 L_00491d22                            # 00491d05
    # block 0x00491d07: entered by fall-through of jne at 0x00491d05, 6 instruction(s), ends with forward jump to 0x00491d3b
    mov edx, dword ptr [ebp - local_18]          # 00491d07
    {load} xor eax, eax                          # 00491d0a
    mov al, byte ptr [edx + field_50ef]          # 00491d0c
    mov ecx, dword ptr [ebp - local_18]          # 00491d12
    mov dword ptr [ecx + 4*eax + field_4345], 0x1 # 00491d15
    jmp.d8 L_00491d3b                            # 00491d20
L_00491d22:
    # block 0x00491d22: entered by jne at 0x00491d05, 5 instruction(s), falls into the block at 0x00491d3b
    mov edx, dword ptr [ebp - local_18]          # 00491d22
    {load} xor eax, eax                          # 00491d25
    mov al, byte ptr [edx + field_50ef]          # 00491d27
    mov ecx, dword ptr [ebp - local_18]          # 00491d2d
    mov dword ptr [ecx + 4*eax + field_41f1], 0x1 # 00491d30
L_00491d3b:
    # block 0x00491d3b: entered by je at 0x00491cc3; jmp at 0x00491d20; jmp at 0x00491dab, 25 instruction(s), ends with backward jump to 0x004919ec
    mov edx, dword ptr [ebp - local_c]           # 00491d3b
    imul edx, edx, 0xa6                          # 00491d3e
    mov eax, dword ptr [ebp - local_18]          # 00491d44
    mov ecx, dword ptr [eax + field_1f4b]        # 00491d47
    lea edx, [ecx + 2*edx]                       # 00491d4d
    mov eax, dword ptr [ebp - local_10]          # 00491d50
    {load} xor ecx, ecx                          # 00491d53
    mov cx, word ptr [edx + 2*eax]               # 00491d55
    mov dword ptr [ebp - local_8], ecx           # 00491d59
    mov edx, dword ptr [ebp - local_8]           # 00491d5c
    mov eax, dword ptr [ebp - local_18]          # 00491d5f
    mov dword ptr [eax + 4*edx + field_43e5], 0x1 # 00491d62
    mov ecx, dword ptr [ebp - local_c]           # 00491d6d
    imul ecx, ecx, 0xa6                          # 00491d70
    mov edx, dword ptr [ebp - local_18]          # 00491d76
    mov eax, dword ptr [edx + field_1f4f]        # 00491d79
    lea ecx, [eax + 2*ecx]                       # 00491d7f
    mov edx, dword ptr [ebp - local_10]          # 00491d82
    {load} xor eax, eax                          # 00491d85
    mov ax, word ptr [ecx + 2*edx]               # 00491d87
    mov dword ptr [ebp - local_4], eax           # 00491d8b
    mov ecx, dword ptr [ebp - local_4]           # 00491d8e
    mov edx, dword ptr [ebp - local_18]          # 00491d91
    mov dword ptr [edx + 4*ecx + field_4539], 0x1 # 00491d94
    jmp.d32 L_004919ec                           # 00491d9f
L_00491da4:
    # block 0x00491da4: entered by jge at 0x004919fc, 1 instruction(s), ends with backward jump to 0x004919cd
    jmp.d32 L_004919cd                           # 00491da4
L_00491da9:
    # block 0x00491da9: entered by jge at 0x004919dd, 1 instruction(s), ends with forward jump to 0x00491dad
    jmp.d8 L_00491dad                            # 00491da9
L_00491dab:
    # block 0x00491dab: entered by jmp at 0x00491a32, 1 instruction(s), ends with backward jump to 0x00491d3b
    jmp.d8 L_00491d3b                            # 00491dab
L_00491dad:
    # block 0x00491dad: entered by jmp at 0x00491da9, 4 instruction(s), ends with ret
    pop edi                                      # 00491dad
    {load} mov esp, ebp                          # 00491dae
    pop ebp                                      # 00491db0
    ret                                          # 00491db1

