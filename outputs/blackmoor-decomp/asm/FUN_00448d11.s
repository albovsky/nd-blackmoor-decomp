# FUN_00448d11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448d11
# extent:       0x00448d11-0x00449732 (2593 code bytes)
# span:         0x00448d11-0x00449770 (code 2593, tables 57, padding 5)
# sha256:       3ed26954bac96938c48dfeb74c9f534625016da93a46d7aa8b27fe8f1b5cd751
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00448d11
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       35 ebp-relative slot(s): local_4, local_6, local_8, local_c, local_10, local_14, local_18, local_1c, local_38, local_3c, local_40, local_44 and 23 more
# fields:       [eax + n] field_10, field_2c, field_2e, field_32, field_34; [ecx + n] field_2c, field_32, field_34; [edi + n] field_minus_1; [edx + n] field_2c, field_2e, field_34, field_38
# callees:      calls FUN_0050c920, FUN_004de2d8, FUN_004c46d1, FUN_004c924d, FUN_0050d8e0, FUN_0044887c, FUN_004c9340, FUN_0050cb1b, FUN_004c92c5, FUN_004d3836, FUN_0052139c, FUN_004c97b4, FUN_004e1157
# track-n:      outputs/blackmoor-decomp/src/action_family_51.c:action_family_51_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 647 instruction(s), 25 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_13d4, 0x13d4  # offset -0x13d4
.equ local_13d8, 0x13d8  # offset -0x13d8
.equ local_13dc, 0x13dc  # offset -0x13dc
.equ local_13e0, 0x13e0  # offset -0x13e0
.equ local_13e4, 0x13e4  # offset -0x13e4
.equ local_13e8, 0x13e8  # offset -0x13e8
.equ local_13ec, 0x13ec  # offset -0x13ec
.equ local_13f0, 0x13f0  # offset -0x13f0
.equ local_13f4, 0x13f4  # offset -0x13f4
.equ local_13f8, 0x13f8  # offset -0x13f8
.equ local_13fc, 0x13fc  # offset -0x13fc
.equ local_1400, 0x1400  # offset -0x1400
.equ local_1404, 0x1404  # offset -0x1404
.equ local_1408, 0x1408  # offset -0x1408
.equ local_140c, 0x140c  # offset -0x140c
.equ local_1410, 0x1410  # offset -0x1410
.equ local_1414, 0x1414  # offset -0x1414
.equ local_1418, 0x1418  # offset -0x1418
.equ local_141c, 0x141c  # offset -0x141c
.equ local_1420, 0x1420  # offset -0x1420
.equ local_1424, 0x1424  # offset -0x1424
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0044887c, .text + (0x0044887c - 0x401000)
.set FUN_004c46d1, .text + (0x004c46d1 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004c9340, .text + (0x004c9340 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_004de2d8, .text + (0x004de2d8 - 0x401000)
.set FUN_004e1157, .text + (0x004e1157 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00448d11 - 0x401000
.globl FUN_00448d11
FUN_00448d11:
    # block 0x00448d11: entry, 32 instruction(s), calls FUN_0050c920, ends with je to 0x00448dd3 (forward)
    push ebp                                     # 00448d11
    {load} mov ebp, esp                          # 00448d12
    mov eax, 0x1424                              # 00448d14
    call FUN_0050c920                            # 00448d19
    push ebx                                     # 00448d1e
    push esi                                     # 00448d1f
    push edi                                     # 00448d20
    mov dword ptr [ebp - local_141c], ecx        # 00448d21
    mov word ptr [ebp - local_3c], 0x0           # 00448d27
    mov byte ptr [ebp - local_1418], 0x0         # 00448d2d
    mov dword ptr [ebp - local_1c], 0x0          # 00448d34
    mov dword ptr [ebp - local_13ec], 0x0        # 00448d3b
    mov dword ptr [ebp - local_13d8], 0x0        # 00448d45
    mov dword ptr [ebp - local_44], 0x0          # 00448d4f
    mov dword ptr [ebp - local_13e8], 0x0        # 00448d56
    mov word ptr [ebp - local_1408], 0x0         # 00448d60
    mov dword ptr [ebp - local_1404], 0x0        # 00448d69
    mov eax, dword ptr [ebp - local_141c]        # 00448d73
    mov dword ptr [eax + field_10], 0x0          # 00448d79
    mov cx, word ptr [0x5b0a64]                  # 00448d80
    mov word ptr [ebp - local_13e0], cx          # 00448d87
    mov edx, dword ptr [ebp - local_141c]        # 00448d8e
    mov dword ptr [edx + field_2e], 0x0          # 00448d94
    mov eax, dword ptr [ebp - local_141c]        # 00448d9b
    mov word ptr [eax + field_32], 0x0           # 00448da1
    mov ecx, dword ptr [ebp - local_141c]        # 00448da7
    mov dword ptr [ecx + field_34], 0x0          # 00448dad
    mov edx, dword ptr [ebp - local_141c]        # 00448db4
    mov dword ptr [edx + field_38], 0x0          # 00448dba
    movsx eax, word ptr [ebp + arg_10]           # 00448dc1
    cmp eax, -0x1                                # 00448dc5
    je.d8 L_00448dd3                             # 00448dc8
    # block 0x00448dca: entered by fall-through of je at 0x00448dc8, 3 instruction(s), ends with jne to 0x00448dde (forward)
    movsx ecx, word ptr [ebp + arg_10]           # 00448dca
    cmp ecx, -0x2                                # 00448dce
    jne.d8 L_00448dde                            # 00448dd1
L_00448dd3:
    # block 0x00448dd3: entered by je at 0x00448dc8; fall-through of jne at 0x00448dd1, 2 instruction(s), ends with forward jump to 0x00448de9
    mov word ptr [ebp - local_13e4], 0x9         # 00448dd3
    jmp.d8 L_00448de9                            # 00448ddc
L_00448dde:
    # block 0x00448dde: entered by jne at 0x00448dd1, 2 instruction(s), falls into the block at 0x00448de9
    mov dx, word ptr [ebp + arg_10]              # 00448dde
    mov word ptr [ebp - local_13e4], dx          # 00448de2
L_00448de9:
    # block 0x00448de9: entered by jmp at 0x00448ddc, 3 instruction(s), ends with jne to 0x00448e5d (forward)
    movsx eax, word ptr [ebp + arg_10]           # 00448de9
    cmp eax, -0x2                                # 00448ded
    jne.d8 L_00448e5d                            # 00448df0
    # block 0x00448df2: entered by fall-through of jne at 0x00448df0, 20 instruction(s), ends with forward jump to 0x00448ed9
    mov byte ptr [ebp - local_1418], 0x1         # 00448df2
    mov cx, word ptr [0x5b0a32]                  # 00448df9
    mov word ptr [ebp - local_18], cx            # 00448e00
    mov edx, dword ptr [ebp - local_141c]        # 00448e04
    mov ax, word ptr [0x5b0a36]                  # 00448e0a
    mov word ptr [edx + field_2c], ax            # 00448e10
    mov ecx, dword ptr [ebp - local_141c]        # 00448e14
    mov dx, word ptr [ecx + field_2c]            # 00448e1a
    mov word ptr [ebp - local_4], dx             # 00448e1e
    movsx eax, word ptr [0x5b0a34]               # 00448e22
    mov ecx, dword ptr [0x5b0a2e]                # 00448e29
    {load} sub ecx, eax                          # 00448e2f
    mov word ptr [ebp - local_1410], cx          # 00448e31
    movsx edx, word ptr [0x5b0a38]               # 00448e38
    mov eax, dword ptr [0x5b0a2a]                # 00448e3f
    {load} sub eax, edx                          # 00448e44
    mov word ptr [ebp - local_13f0], ax          # 00448e46
    mov cx, word ptr [ebp - local_13f0]          # 00448e4d
    mov word ptr [ebp - local_140c], cx          # 00448e54
    jmp.d8 L_00448ed9                            # 00448e5b
L_00448e5d:
    # block 0x00448e5d: entered by jne at 0x00448df0, 23 instruction(s), ends with jne to 0x00448ed9 (forward)
    mov dx, word ptr [0x5b0a5a]                  # 00448e5d
    mov word ptr [ebp - local_18], dx            # 00448e64
    mov eax, dword ptr [ebp - local_141c]        # 00448e68
    mov cx, word ptr [0x5b0a5e]                  # 00448e6e
    mov word ptr [eax + field_2c], cx            # 00448e75
    mov edx, dword ptr [ebp - local_141c]        # 00448e79
    mov ax, word ptr [edx + field_2c]            # 00448e7f
    mov word ptr [ebp - local_4], ax             # 00448e83
    mov ecx, dword ptr [0x5b0a46]                # 00448e87
    sub ecx, dword ptr [0x5b0a3e]                # 00448e8d
    add ecx, 0x4                                 # 00448e93
    mov word ptr [ebp - local_1410], cx          # 00448e96
    movsx edx, word ptr [0x5b0a60]               # 00448e9d
    mov eax, dword ptr [0x5b0a52]                # 00448ea4
    {load} sub eax, edx                          # 00448ea9
    mov word ptr [ebp - local_13f0], ax          # 00448eab
    movsx ecx, word ptr [ebp - local_13f0]       # 00448eb2
    movsx edx, word ptr [ebp - local_4]          # 00448eb9
    {load} sub ecx, edx                          # 00448ebd
    add ecx, 0x1                                 # 00448ebf
    mov word ptr [ebp - local_140c], cx          # 00448ec2
    cmp dword ptr [ebp + arg_14], 0x0            # 00448ec9
    jne.d8 L_00448ed9                            # 00448ecd
    # block 0x00448ecf: entered by fall-through of jne at 0x00448ecd, 1 instruction(s), falls into the block at 0x00448ed9
    mov dword ptr [0x5b1602], 0x0                # 00448ecf
L_00448ed9:
    # block 0x00448ed9: entered by jmp at 0x00448e5b; jne at 0x00448ecd, 4 instruction(s), ends with je to 0x00448eee (forward)
    {load} xor eax, eax                          # 00448ed9
    mov al, byte ptr [0x5a161f]                  # 00448edb
    test eax, eax                                # 00448ee0
    je.d8 L_00448eee                             # 00448ee2
    # block 0x00448ee4: entered by fall-through of je at 0x00448ee2, 2 instruction(s), calls FUN_004de2d8, falls into the block at 0x00448eee
    mov ecx, 0x61f864                            # 00448ee4
    call FUN_004de2d8                            # 00448ee9
L_00448eee:
    # block 0x00448eee: entered by je at 0x00448ee2, 26 instruction(s), ends with jne to 0x00448f72 (forward)
    mov ecx, 0x4e2                               # 00448eee
    {load} xor eax, eax                          # 00448ef3
    lea edi, [ebp - local_13d4]                  # 00448ef5
    rep stosd dword ptr es:[edi], eax            # 00448efb
    mov ecx, 0x6                                 # 00448efd
    {load} xor eax, eax                          # 00448f02
    lea edi, [ebp - local_38]                    # 00448f04
    rep stosd dword ptr es:[edi], eax            # 00448f07
    stosb byte ptr es:[edi], al                  # 00448f09
    {load} xor ecx, ecx                          # 00448f0a
    mov dword ptr [ebp - local_14], ecx          # 00448f0c
    mov dword ptr [ebp - local_10], ecx          # 00448f0f
    mov dword ptr [ebp - local_c], ecx           # 00448f12
    mov word ptr [ebp - local_8], cx             # 00448f15
    mov byte ptr [ebp - local_6], cl             # 00448f19
    movsx ecx, word ptr [0x5b0a6a]               # 00448f1c
    mov eax, 0x20202020                          # 00448f23
    lea edi, [ebp - local_14]                    # 00448f28
    {load} mov edx, ecx                          # 00448f2b
    shr ecx, 0x2                                 # 00448f2d
    rep stosd dword ptr es:[edi], eax            # 00448f30
    {load} mov ecx, edx                          # 00448f32
    and ecx, 0x3                                 # 00448f34
    rep stosb byte ptr es:[edi], al              # 00448f37
    cmp dword ptr [ebp + arg_14], 0x0            # 00448f39
    jne.d8 L_00448f72                            # 00448f3d
    # block 0x00448f3f: entered by fall-through of jne at 0x00448f3d, 3 instruction(s), ends with jne to 0x00448f5e (forward)
    movsx eax, word ptr [ebp + arg_10]           # 00448f3f
    cmp eax, -0x1                                # 00448f43
    jne.d8 L_00448f5e                            # 00448f46
    # block 0x00448f48: entered by fall-through of jne at 0x00448f46, 8 instruction(s), calls FUN_004c46d1, ends with forward jump to 0x00448f72
    push 0x0                                     # 00448f48
    push 0x1f                                    # 00448f4a
    push 0x0                                     # 00448f4c
    mov ecx, dword ptr [ebp + arg_8]             # 00448f4e
    push ecx                                     # 00448f51
    mov ecx, 0x5cf659                            # 00448f52
    call FUN_004c46d1                            # 00448f57
    jmp.d8 L_00448f72                            # 00448f5c
L_00448f5e:
    # block 0x00448f5e: entered by jne at 0x00448f46, 7 instruction(s), calls FUN_004c46d1, falls into the block at 0x00448f72
    push 0x0                                     # 00448f5e
    push 0x0                                     # 00448f60
    push 0x0                                     # 00448f62
    mov edx, dword ptr [ebp + arg_8]             # 00448f64
    push edx                                     # 00448f67
    mov ecx, 0x5cf659                            # 00448f68
    call FUN_004c46d1                            # 00448f6d
L_00448f72:
    # block 0x00448f72: entered by jne at 0x00448f3d; jmp at 0x00448f5c, 11 instruction(s), calls FUN_004c924d, FUN_0050d8e0, ends with jne to 0x00448fac (forward)
    mov ax, word ptr [ebp - local_13e4]          # 00448f72
    push eax                                     # 00448f79
    mov ecx, 0x5cf659                            # 00448f7a
    call FUN_004c924d                            # 00448f7f
    push 0x5487e4                                # 00448f84
    mov ecx, dword ptr [ebp + arg_c]             # 00448f89
    push ecx                                     # 00448f8c
    call FUN_0050d8e0                            # 00448f8d
    add esp, 0x8                                 # 00448f92
    test eax, eax                                # 00448f95
    jne.d8 L_00448fac                            # 00448f97
    # block 0x00448f99: entered by fall-through of jne at 0x00448f97, 6 instruction(s), falls into the block at 0x00448fac
    mov edi, dword ptr [ebp + arg_c]             # 00448f99
    or ecx, -0x1                                 # 00448f9c
    {load} xor eax, eax                          # 00448f9f
    repne scasb al, byte ptr es:[edi]            # 00448fa1
    mov edx, dword ptr [0x5487e8]                # 00448fa3
    mov dword ptr [edi - field_minus_1], edx     # 00448fa9
L_00448fac:
    # block 0x00448fac: entered by jne at 0x00448f97, 11 instruction(s), ends with forward jump to 0x00448fe5
    mov eax, dword ptr [ebp + arg_c]             # 00448fac
    mov dword ptr [ebp - local_40], eax          # 00448faf
    mov edi, dword ptr [ebp - local_40]          # 00448fb2
    or ecx, -0x1                                 # 00448fb5
    {load} xor eax, eax                          # 00448fb8
    repne scasb al, byte ptr es:[edi]            # 00448fba
    not ecx                                      # 00448fbc
    add ecx, -0x1                                # 00448fbe
    mov word ptr [ebp - local_13dc], cx          # 00448fc1
    mov word ptr [ebp - local_48], 0x0           # 00448fc8
    jmp.d8 L_00448fe5                            # 00448fce
L_00448fd0:
    # block 0x00448fd0: entered by jmp at 0x0044963b, 6 instruction(s), falls into the block at 0x00448fe5
    mov cx, word ptr [ebp - local_48]            # 00448fd0
    add cx, 0x1                                  # 00448fd4
    mov word ptr [ebp - local_48], cx            # 00448fd8
    mov edx, dword ptr [ebp - local_40]          # 00448fdc
    add edx, 0x1                                 # 00448fdf
    mov dword ptr [ebp - local_40], edx          # 00448fe2
L_00448fe5:
    # block 0x00448fe5: entered by jmp at 0x00448fce, 5 instruction(s), ends with je to 0x00449010 (forward)
    mov eax, dword ptr [ebp - local_40]          # 00448fe5
    mov cl, byte ptr [eax]                       # 00448fe8
    mov byte ptr [ebp - local_1420], cl          # 00448fea
    cmp byte ptr [ebp - local_1420], 0x0         # 00448ff0
    je.d8 L_00449010                             # 00448ff7
    # block 0x00448ff9: entered by fall-through of je at 0x00448ff7, 2 instruction(s), ends with je to 0x00449015 (forward)
    cmp byte ptr [ebp - local_1420], 0x3c        # 00448ff9
    je.d8 L_00449015                             # 00449000
    # block 0x00449002: entered by fall-through of je at 0x00449000, 2 instruction(s), ends with je to 0x0044902e (forward)
    cmp byte ptr [ebp - local_1420], 0x3e        # 00449002
    je.d8 L_0044902e                             # 00449009
    # block 0x0044900b: entered by fall-through of je at 0x00449009, 1 instruction(s), ends with forward jump to 0x004495c3
    jmp.d32 L_004495c3                           # 0044900b
L_00449010:
    # block 0x00449010: entered by je at 0x00448ff7, 1 instruction(s), ends with forward jump to 0x00449633
    jmp.d32 L_00449633                           # 00449010
L_00449015:
    # block 0x00449015: entered by je at 0x00449000, 3 instruction(s), ends with forward jump to 0x00449633
    mov dword ptr [ebp - local_13ec], 0x1        # 00449015
    mov dword ptr [ebp - local_13d8], 0x0        # 0044901f
    jmp.d32 L_00449633                           # 00449029
L_0044902e:
    # block 0x0044902e: entered by je at 0x00449009, 8 instruction(s), ends with ja to 0x004495b4 (forward)
    mov dword ptr [ebp - local_13ec], 0x0        # 0044902e
    movsx edx, byte ptr [ebp - local_4c]         # 00449038
    mov dword ptr [ebp - local_1424], edx        # 0044903c
    mov eax, dword ptr [ebp - local_1424]        # 00449042
    sub eax, 0x63                                # 00449048
    mov dword ptr [ebp - local_1424], eax        # 0044904b
    cmp dword ptr [ebp - local_1424], 0x14       # 00449051
    ja.d32 L_004495b4                            # 00449058
    # block 0x0044905e: entered by fall-through of ja at 0x00449058, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x449732]
    mov edx, dword ptr [ebp - local_1424]        # 0044905e
    {load} xor ecx, ecx                          # 00449064
    mov cl, byte ptr [edx + IDXTAB_00449756_VA]  # 00449066
    jmp dword ptr [4*ecx + SWTAB_00449732_VA]    # 0044906c
L_00449073:
    # block 0x00449073: entered by switch case, 3 instruction(s), ends with jne to 0x004490df (forward)
    mov eax, dword ptr [ebp - local_141c]        # 00449073
    cmp dword ptr [eax + field_34], 0x0          # 00449079
    jne.d8 L_004490df                            # 0044907d
    # block 0x0044907f: entered by fall-through of jne at 0x0044907d, 29 instruction(s), calls FUN_0044887c, ends with forward jump to 0x0044913d
    mov ecx, dword ptr [ebp + arg_14]            # 0044907f
    push ecx                                     # 00449082
    mov dl, byte ptr [ebp - local_1418]          # 00449083
    push edx                                     # 00449089
    mov eax, dword ptr [ebp + arg_8]             # 0044908a
    push eax                                     # 0044908d
    mov cx, word ptr [ebp - local_13e0]          # 0044908e
    push ecx                                     # 00449095
    lea edx, [ebp - local_3c]                    # 00449096
    push edx                                     # 00449099
    lea eax, [ebp - local_4]                     # 0044909a
    push eax                                     # 0044909d
    mov cx, word ptr [ebp - local_140c]          # 0044909e
    push ecx                                     # 004490a5
    mov dx, word ptr [ebp - local_1410]          # 004490a6
    push edx                                     # 004490ad
    lea eax, [ebp - local_18]                    # 004490ae
    push eax                                     # 004490b1
    lea ecx, [ebp - local_44]                    # 004490b2
    push ecx                                     # 004490b5
    mov dx, word ptr [ebp - local_13e4]          # 004490b6
    push edx                                     # 004490bd
    lea eax, [ebp - local_13d4]                  # 004490be
    push eax                                     # 004490c4
    mov ecx, dword ptr [ebp - local_141c]        # 004490c5
    call FUN_0044887c                            # 004490cb
    mov ecx, dword ptr [ebp - local_141c]        # 004490d0
    mov dword ptr [ecx + field_34], 0x1          # 004490d6
    jmp.d8 L_0044913d                            # 004490dd
L_004490df:
    # block 0x004490df: entered by jne at 0x0044907d, 28 instruction(s), calls FUN_0044887c, falls into the block at 0x0044913d
    mov edx, dword ptr [ebp + arg_14]            # 004490df
    push edx                                     # 004490e2
    mov al, byte ptr [ebp - local_1418]          # 004490e3
    push eax                                     # 004490e9
    mov ecx, dword ptr [ebp + arg_8]             # 004490ea
    push ecx                                     # 004490ed
    mov dx, word ptr [ebp - local_13e0]          # 004490ee
    push edx                                     # 004490f5
    lea eax, [ebp - local_3c]                    # 004490f6
    push eax                                     # 004490f9
    lea ecx, [ebp - local_4]                     # 004490fa
    push ecx                                     # 004490fd
    mov dx, word ptr [ebp - local_140c]          # 004490fe
    push edx                                     # 00449105
    mov ax, word ptr [ebp - local_1410]          # 00449106
    push eax                                     # 0044910d
    lea ecx, [ebp - local_18]                    # 0044910e
    push ecx                                     # 00449111
    lea edx, [ebp - local_44]                    # 00449112
    push edx                                     # 00449115
    mov ax, word ptr [ebp - local_13e4]          # 00449116
    push eax                                     # 0044911d
    lea ecx, [ebp - local_13d4]                  # 0044911e
    push ecx                                     # 00449124
    mov ecx, dword ptr [ebp - local_141c]        # 00449125
    call FUN_0044887c                            # 0044912b
    mov edx, dword ptr [ebp - local_141c]        # 00449130
    mov dword ptr [edx + field_34], 0x0          # 00449136
L_0044913d:
    # block 0x0044913d: entered by jmp at 0x004490dd, 1 instruction(s), ends with forward jump to 0x004495b4
    jmp.d32 L_004495b4                           # 0044913d
L_00449142:
    # block 0x00449142: entered by switch case, 3 instruction(s), ends with jne to 0x004492ee (forward)
    mov eax, dword ptr [ebp - local_141c]        # 00449142
    cmp dword ptr [eax + field_2e], 0x0          # 00449148
    jne.d32 L_004492ee                           # 0044914c
    # block 0x00449152: entered by fall-through of jne at 0x0044914c, 82 instruction(s), calls FUN_004c9340, FUN_0044887c, ends with forward jump to 0x0044934c
    movsx ecx, word ptr [ebp - local_13e4]       # 00449152
    imul ecx, ecx, 0x7f3                         # 00449159
    movsx edx, word ptr [ecx + 0x5a4c77]         # 0044915f
    mov dword ptr [ebp - local_1414], edx        # 00449166
    movsx eax, word ptr [ebp - local_13e4]       # 0044916c
    imul eax, eax, 0x7f3                         # 00449173
    mov ecx, dword ptr [ebp - local_1414]        # 00449179
    shl ecx, 0x4                                 # 0044917f
    movsx edx, word ptr [ebp - local_13e4]       # 00449182
    imul edx, edx, 0x7f3                         # 00449189
    movsx esi, word ptr [ebp - local_13e0]       # 0044918f
    mov eax, dword ptr [eax + ecx + 0x5a4ceb]    # 00449196
    add eax, dword ptr [edx + 8*esi + 0x5a4c67]  # 0044919d
    mov dword ptr [ebp - local_13fc], eax        # 004491a4
    movsx ecx, word ptr [ebp - local_13e4]       # 004491aa
    imul ecx, ecx, 0x7f3                         # 004491b1
    mov edx, dword ptr [ebp - local_1414]        # 004491b7
    shl edx, 0x4                                 # 004491bd
    movsx eax, word ptr [ebp - local_13e4]       # 004491c0
    imul eax, eax, 0x7f3                         # 004491c7
    movsx esi, word ptr [ebp - local_13e0]       # 004491cd
    mov ecx, dword ptr [ecx + edx + 0x5a4cf3]    # 004491d4
    add ecx, dword ptr [eax + 8*esi + 0x5a4c67]  # 004491db
    mov dword ptr [ebp - local_13f4], ecx        # 004491e2
    movsx edx, word ptr [ebp - local_13e4]       # 004491e8
    imul edx, edx, 0x7f3                         # 004491ef
    mov eax, dword ptr [ebp - local_1414]        # 004491f5
    shl eax, 0x4                                 # 004491fb
    movsx ecx, word ptr [ebp - local_13e4]       # 004491fe
    imul ecx, ecx, 0x7f3                         # 00449205
    movsx esi, word ptr [ebp - local_13e0]       # 0044920b
    mov edx, dword ptr [edx + eax + 0x5a4ce7]    # 00449212
    add edx, dword ptr [ecx + 8*esi + 0x5a4c63]  # 00449219
    mov dword ptr [ebp - local_1400], edx        # 00449220
    movsx eax, word ptr [ebp - local_13e4]       # 00449226
    imul eax, eax, 0x7f3                         # 0044922d
    mov ecx, dword ptr [ebp - local_1414]        # 00449233
    shl ecx, 0x4                                 # 00449239
    movsx edx, word ptr [ebp - local_13e4]       # 0044923c
    imul edx, edx, 0x7f3                         # 00449243
    movsx esi, word ptr [ebp - local_13e0]       # 00449249
    mov eax, dword ptr [eax + ecx + 0x5a4cef]    # 00449250
    add eax, dword ptr [edx + 8*esi + 0x5a4c63]  # 00449257
    mov dword ptr [ebp - local_13f8], eax        # 0044925e
    lea ecx, [ebp - local_1400]                  # 00449264
    push ecx                                     # 0044926a
    movsx edx, word ptr [ebp - local_13e4]       # 0044926b
    mov eax, dword ptr [4*edx + 0x5d032f]        # 00449272
    push eax                                     # 00449279
    mov ecx, 0x5cf659                            # 0044927a
    call FUN_004c9340                            # 0044927f
    mov ecx, dword ptr [ebp - local_141c]        # 00449284
    mov word ptr [ecx + field_32], ax            # 0044928a
    mov edx, dword ptr [ebp + arg_14]            # 0044928e
    push edx                                     # 00449291
    mov al, byte ptr [ebp - local_1418]          # 00449292
    push eax                                     # 00449298
    mov ecx, dword ptr [ebp + arg_8]             # 00449299
    push ecx                                     # 0044929c
    mov dx, word ptr [ebp - local_13e0]          # 0044929d
    push edx                                     # 004492a4
    lea eax, [ebp - local_3c]                    # 004492a5
    push eax                                     # 004492a8
    lea ecx, [ebp - local_4]                     # 004492a9
    push ecx                                     # 004492ac
    mov dx, word ptr [ebp - local_140c]          # 004492ad
    push edx                                     # 004492b4
    mov ax, word ptr [ebp - local_1410]          # 004492b5
    push eax                                     # 004492bc
    lea ecx, [ebp - local_18]                    # 004492bd
    push ecx                                     # 004492c0
    lea edx, [ebp - local_44]                    # 004492c1
    push edx                                     # 004492c4
    mov ax, word ptr [ebp - local_13e4]          # 004492c5
    push eax                                     # 004492cc
    lea ecx, [ebp - local_13d4]                  # 004492cd
    push ecx                                     # 004492d3
    mov ecx, dword ptr [ebp - local_141c]        # 004492d4
    call FUN_0044887c                            # 004492da
    mov edx, dword ptr [ebp - local_141c]        # 004492df
    mov dword ptr [edx + field_2e], 0x1          # 004492e5
    jmp.d8 L_0044934c                            # 004492ec
L_004492ee:
    # block 0x004492ee: entered by jne at 0x0044914c, 28 instruction(s), calls FUN_0044887c, falls into the block at 0x0044934c
    mov eax, dword ptr [ebp + arg_14]            # 004492ee
    push eax                                     # 004492f1
    mov cl, byte ptr [ebp - local_1418]          # 004492f2
    push ecx                                     # 004492f8
    mov edx, dword ptr [ebp + arg_8]             # 004492f9
    push edx                                     # 004492fc
    mov ax, word ptr [ebp - local_13e0]          # 004492fd
    push eax                                     # 00449304
    lea ecx, [ebp - local_3c]                    # 00449305
    push ecx                                     # 00449308
    lea edx, [ebp - local_4]                     # 00449309
    push edx                                     # 0044930c
    mov ax, word ptr [ebp - local_140c]          # 0044930d
    push eax                                     # 00449314
    mov cx, word ptr [ebp - local_1410]          # 00449315
    push ecx                                     # 0044931c
    lea edx, [ebp - local_18]                    # 0044931d
    push edx                                     # 00449320
    lea eax, [ebp - local_44]                    # 00449321
    push eax                                     # 00449324
    mov cx, word ptr [ebp - local_13e4]          # 00449325
    push ecx                                     # 0044932c
    lea edx, [ebp - local_13d4]                  # 0044932d
    push edx                                     # 00449333
    mov ecx, dword ptr [ebp - local_141c]        # 00449334
    call FUN_0044887c                            # 0044933a
    mov eax, dword ptr [ebp - local_141c]        # 0044933f
    mov dword ptr [eax + field_2e], 0x0          # 00449345
L_0044934c:
    # block 0x0044934c: entered by jmp at 0x004492ec, 1 instruction(s), ends with forward jump to 0x004495b4
    jmp.d32 L_004495b4                           # 0044934c
L_00449351:
    # block 0x00449351: entered by switch case, 32 instruction(s), calls FUN_0044887c, FUN_0050cb1b, ends with forward jump to 0x004495b4
    mov ecx, dword ptr [ebp + arg_14]            # 00449351
    push ecx                                     # 00449354
    mov dl, byte ptr [ebp - local_1418]          # 00449355
    push edx                                     # 0044935b
    mov eax, dword ptr [ebp + arg_8]             # 0044935c
    push eax                                     # 0044935f
    mov cx, word ptr [ebp - local_13e0]          # 00449360
    push ecx                                     # 00449367
    lea edx, [ebp - local_3c]                    # 00449368
    push edx                                     # 0044936b
    lea eax, [ebp - local_4]                     # 0044936c
    push eax                                     # 0044936f
    mov cx, word ptr [ebp - local_140c]          # 00449370
    push ecx                                     # 00449377
    mov dx, word ptr [ebp - local_1410]          # 00449378
    push edx                                     # 0044937f
    lea eax, [ebp - local_18]                    # 00449380
    push eax                                     # 00449383
    lea ecx, [ebp - local_44]                    # 00449384
    push ecx                                     # 00449387
    mov dx, word ptr [ebp - local_13e4]          # 00449388
    push edx                                     # 0044938f
    lea eax, [ebp - local_13d4]                  # 00449390
    push eax                                     # 00449396
    mov ecx, dword ptr [ebp - local_141c]        # 00449397
    call FUN_0044887c                            # 0044939d
    lea ecx, [ebp - local_38]                    # 004493a2
    push ecx                                     # 004493a5
    call FUN_0050cb1b                            # 004493a6
    add esp, 0x4                                 # 004493ab
    mov word ptr [ebp - local_13e0], ax          # 004493ae
    jmp.d32 L_004495b4                           # 004493b5
L_004493ba:
    # block 0x004493ba: entered by switch case, 2 instruction(s), ends with forward jump to 0x004495b4
    mov dword ptr [ebp - local_1c], 0x1          # 004493ba
    jmp.d32 L_004495b4                           # 004493c1
L_004493c6:
    # block 0x004493c6: entered by switch case, 40 instruction(s), calls FUN_0044887c, FUN_004c92c5, FUN_0050cb1b, FUN_004c924d, ends with forward jump to 0x004495b4
    mov edx, dword ptr [ebp + arg_14]            # 004493c6
    push edx                                     # 004493c9
    mov al, byte ptr [ebp - local_1418]          # 004493ca
    push eax                                     # 004493d0
    mov ecx, dword ptr [ebp + arg_8]             # 004493d1
    push ecx                                     # 004493d4
    mov dx, word ptr [ebp - local_13e0]          # 004493d5
    push edx                                     # 004493dc
    lea eax, [ebp - local_3c]                    # 004493dd
    push eax                                     # 004493e0
    lea ecx, [ebp - local_4]                     # 004493e1
    push ecx                                     # 004493e4
    mov dx, word ptr [ebp - local_140c]          # 004493e5
    push edx                                     # 004493ec
    mov ax, word ptr [ebp - local_1410]          # 004493ed
    push eax                                     # 004493f4
    lea ecx, [ebp - local_18]                    # 004493f5
    push ecx                                     # 004493f8
    lea edx, [ebp - local_44]                    # 004493f9
    push edx                                     # 004493fc
    mov ax, word ptr [ebp - local_13e4]          # 004493fd
    push eax                                     # 00449404
    lea ecx, [ebp - local_13d4]                  # 00449405
    push ecx                                     # 0044940b
    mov ecx, dword ptr [ebp - local_141c]        # 0044940c
    call FUN_0044887c                            # 00449412
    mov dx, word ptr [ebp - local_13e4]          # 00449417
    push edx                                     # 0044941e
    mov ecx, 0x5cf659                            # 0044941f
    call FUN_004c92c5                            # 00449424
    lea eax, [ebp - local_38]                    # 00449429
    push eax                                     # 0044942c
    call FUN_0050cb1b                            # 0044942d
    add esp, 0x4                                 # 00449432
    mov word ptr [ebp - local_13e4], ax          # 00449435
    mov cx, word ptr [ebp - local_13e4]          # 0044943c
    push ecx                                     # 00449443
    mov ecx, 0x5cf659                            # 00449444
    call FUN_004c924d                            # 00449449
    jmp.d32 L_004495b4                           # 0044944e
L_00449453:
    # block 0x00449453: entered by switch case, 33 instruction(s), calls FUN_0044887c, ends with jne to 0x004494cf (forward)
    mov edx, dword ptr [ebp + arg_14]            # 00449453
    push edx                                     # 00449456
    mov al, byte ptr [ebp - local_1418]          # 00449457
    push eax                                     # 0044945d
    mov ecx, dword ptr [ebp + arg_8]             # 0044945e
    push ecx                                     # 00449461
    mov dx, word ptr [ebp - local_13e0]          # 00449462
    push edx                                     # 00449469
    lea eax, [ebp - local_3c]                    # 0044946a
    push eax                                     # 0044946d
    lea ecx, [ebp - local_4]                     # 0044946e
    push ecx                                     # 00449471
    mov dx, word ptr [ebp - local_140c]          # 00449472
    push edx                                     # 00449479
    mov ax, word ptr [ebp - local_1410]          # 0044947a
    push eax                                     # 00449481
    lea ecx, [ebp - local_18]                    # 00449482
    push ecx                                     # 00449485
    lea edx, [ebp - local_44]                    # 00449486
    push edx                                     # 00449489
    mov ax, word ptr [ebp - local_13e4]          # 0044948a
    push eax                                     # 00449491
    lea ecx, [ebp - local_13d4]                  # 00449492
    push ecx                                     # 00449498
    mov ecx, dword ptr [ebp - local_141c]        # 00449499
    call FUN_0044887c                            # 0044949f
    mov edx, dword ptr [ebp - local_141c]        # 004494a4
    mov ax, word ptr [edx + field_2c]            # 004494aa
    mov word ptr [ebp - local_4], ax             # 004494ae
    mov dword ptr [ebp - local_44], 0x1          # 004494b2
    movsx ecx, byte ptr [ebp - local_4c]         # 004494b9
    cmp ecx, 0x77                                # 004494bd
    jne.d8 L_004494cf                            # 004494c0
    # block 0x004494c2: entered by fall-through of jne at 0x004494c0, 2 instruction(s), falls into the block at 0x004494cf
    mov edx, dword ptr [ebp - local_141c]        # 004494c2
    mov dword ptr [edx + field_38], 0x1          # 004494c8
L_004494cf:
    # block 0x004494cf: entered by jne at 0x004494c0, 1 instruction(s), ends with forward jump to 0x004495b4
    jmp.d32 L_004495b4                           # 004494cf
L_004494d4:
    # block 0x004494d4: entered by switch case, 47 instruction(s), calls FUN_004d3836, FUN_0044887c, ends with forward jump to 0x004495b4
    movsx esi, word ptr [ebp - local_140c]       # 004494d4
    movsx eax, word ptr [ebp - local_13e4]       # 004494db
    imul eax, eax, 0x1d0                         # 004494e2
    add eax, 0x5adb3a                            # 004494e8
    push eax                                     # 004494ed
    movsx ecx, word ptr [ebp - local_13e4]       # 004494ee
    imul ecx, ecx, 0x7f3                         # 004494f5
    add ecx, 0x5a4c24                            # 004494fb
    push ecx                                     # 00449501
    lea edx, [ebp - local_13d4]                  # 00449502
    push edx                                     # 00449508
    call FUN_004d3836                            # 00449509
    add esp, 0xc                                 # 0044950e
    movsx eax, ax                                # 00449511
    {load} sub esi, eax                          # 00449514
    mov word ptr [ebp - local_4], si             # 00449516
    mov ecx, dword ptr [ebp + arg_14]            # 0044951a
    push ecx                                     # 0044951d
    mov dl, byte ptr [ebp - local_1418]          # 0044951e
    push edx                                     # 00449524
    mov eax, dword ptr [ebp + arg_8]             # 00449525
    push eax                                     # 00449528
    mov cx, word ptr [ebp - local_13e0]          # 00449529
    push ecx                                     # 00449530
    lea edx, [ebp - local_3c]                    # 00449531
    push edx                                     # 00449534
    lea eax, [ebp - local_4]                     # 00449535
    push eax                                     # 00449538
    mov cx, word ptr [ebp - local_140c]          # 00449539
    push ecx                                     # 00449540
    mov dx, word ptr [ebp - local_1410]          # 00449541
    push edx                                     # 00449548
    lea eax, [ebp - local_18]                    # 00449549
    push eax                                     # 0044954c
    lea ecx, [ebp - local_44]                    # 0044954d
    push ecx                                     # 00449550
    mov dx, word ptr [ebp - local_13e4]          # 00449551
    push edx                                     # 00449558
    lea eax, [ebp - local_13d4]                  # 00449559
    push eax                                     # 0044955f
    mov ecx, dword ptr [ebp - local_141c]        # 00449560
    call FUN_0044887c                            # 00449566
    mov ecx, dword ptr [ebp - local_141c]        # 0044956b
    mov dx, word ptr [ecx + field_2c]            # 00449571
    mov word ptr [ebp - local_4], dx             # 00449575
    mov dword ptr [ebp - local_44], 0x1          # 00449579
    jmp.d8 L_004495b4                            # 00449580
L_00449582:
    # block 0x00449582: entered by switch case, 20 instruction(s), falls into the block at 0x004495b4
    lea edi, [ebp - local_14]                    # 00449582
    lea edx, [ebp - local_13d4]                  # 00449585
    or ecx, -0x1                                 # 0044958b
    {load} xor eax, eax                          # 0044958e
    repne scasb al, byte ptr es:[edi]            # 00449590
    not ecx                                      # 00449592
    {load} sub edi, ecx                          # 00449594
    {load} mov esi, edi                          # 00449596
    {load} mov ebx, ecx                          # 00449598
    {load} mov edi, edx                          # 0044959a
    or ecx, -0x1                                 # 0044959c
    {load} xor eax, eax                          # 0044959f
    repne scasb al, byte ptr es:[edi]            # 004495a1
    add edi, -0x1                                # 004495a3
    {load} mov ecx, ebx                          # 004495a6
    shr ecx, 0x2                                 # 004495a8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004495ab
    {load} mov ecx, ebx                          # 004495ad
    and ecx, 0x3                                 # 004495af
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004495b2
L_004495b4:
    # block 0x004495b4: entered by ja at 0x00449058; jmp at 0x0044913d; jmp at 0x0044934c; jmp at 0x004493b5; more, 6 instruction(s), ends with forward jump to 0x00449633
    mov ecx, 0x6                                 # 004495b4
    {load} xor eax, eax                          # 004495b9
    lea edi, [ebp - local_38]                    # 004495bb
    rep stosd dword ptr es:[edi], eax            # 004495be
    stosb byte ptr es:[edi], al                  # 004495c0
    jmp.d8 L_00449633                            # 004495c1
L_004495c3:
    # block 0x004495c3: entered by jmp at 0x0044900b, 2 instruction(s), ends with je to 0x004495e9 (forward)
    cmp dword ptr [ebp - local_13ec], 0x0        # 004495c3
    je.d8 L_004495e9                             # 004495ca
    # block 0x004495cc: entered by fall-through of je at 0x004495ca, 2 instruction(s), ends with jne to 0x004495e9 (forward)
    cmp dword ptr [ebp - local_13d8], 0x0        # 004495cc
    jne.d8 L_004495e9                            # 004495d3
    # block 0x004495d5: entered by fall-through of jne at 0x004495d3, 5 instruction(s), ends with forward jump to 0x00449633
    mov eax, dword ptr [ebp - local_40]          # 004495d5
    mov cl, byte ptr [eax]                       # 004495d8
    mov byte ptr [ebp - local_4c], cl            # 004495da
    mov dword ptr [ebp - local_13d8], 0x1        # 004495dd
    jmp.d8 L_00449633                            # 004495e7
L_004495e9:
    # block 0x004495e9: entered by je at 0x004495ca; jne at 0x004495d3, 2 instruction(s), ends with je to 0x00449615 (forward)
    cmp dword ptr [ebp - local_13ec], 0x0        # 004495e9
    je.d8 L_00449615                             # 004495f0
    # block 0x004495f2: entered by fall-through of je at 0x004495f0, 2 instruction(s), ends with je to 0x00449615 (forward)
    cmp dword ptr [ebp - local_13d8], 0x0        # 004495f2
    je.d8 L_00449615                             # 004495f9
    # block 0x004495fb: entered by fall-through of je at 0x004495f9, 10 instruction(s), ends with forward jump to 0x00449633
    lea edi, [ebp - local_38]                    # 004495fb
    or ecx, -0x1                                 # 004495fe
    {load} xor eax, eax                          # 00449601
    repne scasb al, byte ptr es:[edi]            # 00449603
    not ecx                                      # 00449605
    add ecx, -0x1                                # 00449607
    mov edx, dword ptr [ebp - local_40]          # 0044960a
    mov al, byte ptr [edx]                       # 0044960d
    mov byte ptr [ebp + ecx - local_38], al      # 0044960f
    jmp.d8 L_00449633                            # 00449613
L_00449615:
    # block 0x00449615: entered by je at 0x004495f0; je at 0x004495f9, 9 instruction(s), falls into the block at 0x00449633
    lea edi, [ebp - local_13d4]                  # 00449615
    or ecx, -0x1                                 # 0044961b
    {load} xor eax, eax                          # 0044961e
    repne scasb al, byte ptr es:[edi]            # 00449620
    not ecx                                      # 00449622
    add ecx, -0x1                                # 00449624
    mov edx, dword ptr [ebp - local_40]          # 00449627
    mov al, byte ptr [edx]                       # 0044962a
    mov byte ptr [ebp + ecx - local_13d4], al    # 0044962c
L_00449633:
    # block 0x00449633: entered by jmp at 0x00449010; jmp at 0x00449029; jmp at 0x004495c1; jmp at 0x004495e7; more, 2 instruction(s), ends with jne to 0x0044963b (forward)
    cmp dword ptr [ebp - local_1c], 0x1          # 00449633
    jne.d8 L_0044963b                            # 00449637
    # block 0x00449639: entered by fall-through of jne at 0x00449637, 1 instruction(s), ends with forward jump to 0x00449640
    jmp.d8 L_00449640                            # 00449639
L_0044963b:
    # block 0x0044963b: entered by jne at 0x00449637, 1 instruction(s), ends with backward jump to 0x00448fd0
    jmp.d32 L_00448fd0                           # 0044963b
L_00449640:
    # block 0x00449640: entered by jmp at 0x00449639, 2 instruction(s), ends with jne to 0x00449713 (forward)
    cmp dword ptr [ebp + arg_14], 0x0            # 00449640
    jne.d32 L_00449713                           # 00449644
    # block 0x0044964a: entered by fall-through of jne at 0x00449644, 3 instruction(s), ends with jne to 0x004496ff (forward)
    movsx ecx, word ptr [ebp + arg_10]           # 0044964a
    cmp ecx, -0x2                                # 0044964e
    jne.d32 L_004496ff                           # 00449651
    # block 0x00449657: entered by fall-through of jne at 0x00449651, 9 instruction(s), ends with jl to 0x0044969c (forward)
    movsx edx, word ptr [0x5b0a34]               # 00449657
    imul edx, edx, 0x3                           # 0044965e
    mov ax, word ptr [ebp - local_18]            # 00449661
    {load} add ax, dx                            # 00449665
    mov word ptr [ebp - local_18], ax            # 00449668
    movsx ecx, word ptr [ebp - local_18]         # 0044966c
    movsx edx, word ptr [ebp - local_1410]       # 00449670
    {load} cmp ecx, edx                          # 00449677
    jl.d8 L_0044969c                             # 00449679
    # block 0x0044967b: entered by fall-through of jl at 0x00449679, 8 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x00449729
    push 0x0                                     # 0044967b
    push 0x0                                     # 0044967d
    push 0x5487ec                                # 0044967f
    call FUN_0052139c                            # 00449684
    mov ecx, 0x5cf659                            # 00449689
    call FUN_004c97b4                            # 0044968e
    mov ax, word ptr [ebp - local_3c]            # 00449693
    jmp.d32 L_00449729                           # 00449697
L_0044969c:
    # block 0x0044969c: entered by jl at 0x00449679, 5 instruction(s), ends with jle to 0x004496d6 (forward)
    movsx eax, word ptr [ebp - local_18]         # 0044969c
    mov ecx, dword ptr [0x5b0a26]                # 004496a0
    add ecx, dword ptr [0x5b0a1e]                # 004496a6
    {load} cmp eax, ecx                          # 004496ac
    jle.d8 L_004496d6                            # 004496ae
    # block 0x004496b0: entered by fall-through of jle at 0x004496ae, 9 instruction(s), ends with forward jump to 0x004496df
    movsx edx, word ptr [ebp - local_18]         # 004496b0
    sub edx, dword ptr [0x5b0a26]                # 004496b4
    add edx, 0x1                                 # 004496ba
    mov eax, dword ptr [0x5b0a1e]                # 004496bd
    sub eax, dword ptr [0x5b0a16]                # 004496c2
    add eax, 0x1                                 # 004496c8
    {load} sub edx, eax                          # 004496cb
    mov word ptr [0x5b0a7c], dx                  # 004496cd
    jmp.d8 L_004496df                            # 004496d4
L_004496d6:
    # block 0x004496d6: entered by jle at 0x004496ae, 1 instruction(s), falls into the block at 0x004496df
    mov word ptr [0x5b0a7c], 0x1                 # 004496d6
L_004496df:
    # block 0x004496df: entered by jmp at 0x004496d4, 3 instruction(s), ends with jg to 0x004496f3 (forward)
    movsx ecx, word ptr [0x5b0a7c]               # 004496df
    test ecx, ecx                                # 004496e6
    jg.d8 L_004496f3                             # 004496e8
    # block 0x004496ea: entered by fall-through of jg at 0x004496e8, 1 instruction(s), falls into the block at 0x004496f3
    mov word ptr [0x5b0a7c], 0x1                 # 004496ea
L_004496f3:
    # block 0x004496f3: entered by jg at 0x004496e8, 2 instruction(s), ends with forward jump to 0x00449713
    mov dword ptr [0x5b15d6], 0x1                # 004496f3
    jmp.d8 L_00449713                            # 004496fd
L_004496ff:
    # block 0x004496ff: entered by jne at 0x00449651, 3 instruction(s), calls FUN_004e1157, falls into the block at 0x00449713
    mov dword ptr [0x5b1606], 0x1                # 004496ff
    mov ecx, 0x570508                            # 00449709
    call FUN_004e1157                            # 0044970e
L_00449713:
    # block 0x00449713: entered by jne at 0x00449644; jmp at 0x004496fd, 5 instruction(s), calls FUN_004c92c5, falls into the block at 0x00449729
    mov dx, word ptr [ebp - local_13e4]          # 00449713
    push edx                                     # 0044971a
    mov ecx, 0x5cf659                            # 0044971b
    call FUN_004c92c5                            # 00449720
    mov ax, word ptr [ebp - local_3c]            # 00449725
L_00449729:
    # block 0x00449729: entered by jmp at 0x00449697, 6 instruction(s), ends with ret 0x10
    pop edi                                      # 00449729
    pop esi                                      # 0044972a
    pop ebx                                      # 0044972b
    {load} mov esp, ebp                          # 0044972c
    pop ebp                                      # 0044972e
    ret 0x10                                     # 0044972f

# --- data items (not part of the function) -------------------------
.org 0x00449732 - 0x401000
SWTAB_00449732:  # 9 case address(es)
    .long L_00449351 - .text + 0x401000
    .long L_004493ba - .text + 0x401000
    .long L_004493c6 - .text + 0x401000
    .long L_00449073 - .text + 0x401000
    .long L_00449453 - .text + 0x401000
    .long L_004494d4 - .text + 0x401000
    .long L_00449582 - .text + 0x401000
    .long L_00449142 - .text + 0x401000
    .long L_004495b4 - .text + 0x401000
.org 0x00449756 - 0x401000
IDXTAB_00449756:  # index table of FUN_00448d11 for the switch jump at 0x0044906c (21 byte(s))
    .byte 0, 8, 1, 2, 8, 8, 8, 8, 8, 3, 8, 4, 8, 8, 8, 5
    .byte 8, 6, 7, 8, 4
.org 0x0044976b - 0x401000
PAD_0044976b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc
.set SWTAB_00449732_VA, SWTAB_00449732 - .text + 0x401000
.set IDXTAB_00449756_VA, IDXTAB_00449756 - .text + 0x401000

