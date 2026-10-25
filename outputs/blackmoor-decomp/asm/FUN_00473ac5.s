# FUN_00473ac5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473ac5
# extent:       0x00473ac5-0x00473e8a (965 code bytes)
# span:         0x00473ac5-0x00473e8a (code 965, tables 0, padding 0)
# sha256:       be06b227457ca20bb66a65c8ef2464082cca76673827cdb62a4ebea678442e00
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00473ac5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_c, field_b6, field_ba, field_361, field_365, field_3e5, field_3f1, field_3f5, field_3f9, field_40d and 2 more; [ecx + n] field_361, field_365, field_369, field_36d, field_3d5, field_3e1, field_3ed, field_3f1, field_3f9, field_411, field_415, field_minus_1; [edx + n] field_4, field_8, field_c, field_365, field_3d9, field_3ed, field_3f5, field_3f9, field_40d, field_411, field_415
# callees:      calls USER32.dll!CopyRect, KERNEL32.dll!GetTickCount, FUN_0044bebb, FUN_0044c0e6, FUN_0044bf4b, FUN_0050ce04, FUN_00473e8a, USER32.dll!EqualRect
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m473651_lifted (function ledger class candidate_port; also m473ac5_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 255 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_361, 0x361  # offset +0x361
.equ field_365, 0x365  # offset +0x365
.equ field_369, 0x369  # offset +0x369
.equ field_36d, 0x36d  # offset +0x36d
.equ field_3d5, 0x3d5  # offset +0x3d5
.equ field_3d9, 0x3d9  # offset +0x3d9
.equ field_3e1, 0x3e1  # offset +0x3e1
.equ field_3e5, 0x3e5  # offset +0x3e5
.equ field_3ed, 0x3ed  # offset +0x3ed
.equ field_3f1, 0x3f1  # offset +0x3f1
.equ field_3f5, 0x3f5  # offset +0x3f5
.equ field_3f9, 0x3f9  # offset +0x3f9
.equ field_40d, 0x40d  # offset +0x40d
.equ field_411, 0x411  # offset +0x411
.equ field_415, 0x415  # offset +0x415

# --- external targets -----------------------------------------------
.set FUN_0044bebb, .text + (0x0044bebb - 0x401000)
.set FUN_0044bf4b, .text + (0x0044bf4b - 0x401000)
.set FUN_0044c0e6, .text + (0x0044c0e6 - 0x401000)
.set FUN_00473e8a, .text + (0x00473e8a - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00473ac5 - 0x401000
.globl FUN_00473ac5
FUN_00473ac5:
    # block 0x00473ac5: entry, 68 instruction(s), calls USER32.dll!CopyRect, KERNEL32.dll!GetTickCount, FUN_0044bebb, FUN_0044c0e6, ends with je to 0x00473c1a (forward)
    push ebp                                     # 00473ac5
    {load} mov ebp, esp                          # 00473ac6
    sub esp, 0x28                                # 00473ac8
    mov dword ptr [ebp - local_18], ecx          # 00473acb
    mov eax, dword ptr [0x5a4bce]                # 00473ace
    mov dword ptr [ebp - local_4], eax           # 00473ad3
    mov ecx, dword ptr [ebp - local_4]           # 00473ad6
    shl ecx, 0x4                                 # 00473ad9
    add ecx, 0x5a4b5e                            # 00473adc
    push ecx                                     # 00473ae2
    lea edx, [ebp - local_14]                    # 00473ae3
    push edx                                     # 00473ae6
    call dword ptr [0x52a4ac]                    # 00473ae7
    call dword ptr [0x52a23c]                    # 00473aed
    mov dword ptr [0x63a874], eax                # 00473af3
    mov eax, dword ptr [ebp - local_4]           # 00473af8
    mov ecx, dword ptr [0x63a874]                # 00473afb
    sub ecx, dword ptr [4*eax + 0x63a864]        # 00473b01
    mov dword ptr [0x63a860], ecx                # 00473b08
    mov edx, dword ptr [ebp - local_4]           # 00473b0e
    mov eax, dword ptr [0x63a874]                # 00473b11
    mov dword ptr [4*edx + 0x63a864], eax        # 00473b16
    mov ecx, dword ptr [ebp - local_18]          # 00473b1d
    add ecx, 0x3d5                               # 00473b20
    push ecx                                     # 00473b26
    mov ecx, 0x61f860                            # 00473b27
    call FUN_0044bebb                            # 00473b2c
    mov edx, dword ptr [ebp - local_18]          # 00473b31
    add edx, 0x3e1                               # 00473b34
    push edx                                     # 00473b3a
    mov ecx, 0x61f860                            # 00473b3b
    call FUN_0044bebb                            # 00473b40
    mov eax, dword ptr [ebp - local_18]          # 00473b45
    add eax, 0x3ed                               # 00473b48
    push eax                                     # 00473b4d
    mov ecx, 0x61f860                            # 00473b4e
    call FUN_0044bebb                            # 00473b53
    fild dword ptr [ebp - local_14]              # 00473b58
    mov ecx, dword ptr [ebp - local_18]          # 00473b5b
    fstp dword ptr [ecx + field_3d5]             # 00473b5e
    fild dword ptr [ebp - local_10]              # 00473b64
    mov edx, dword ptr [ebp - local_18]          # 00473b67
    fstp dword ptr [edx + field_3d9]             # 00473b6a
    mov eax, dword ptr [ebp - local_18]          # 00473b70
    fild dword ptr [eax + field_361]             # 00473b73
    mov ecx, dword ptr [ebp - local_18]          # 00473b79
    fstp dword ptr [ecx + field_3e1]             # 00473b7c
    mov edx, dword ptr [ebp - local_18]          # 00473b82
    fild dword ptr [edx + field_365]             # 00473b85
    mov eax, dword ptr [ebp - local_18]          # 00473b8b
    fstp dword ptr [eax + field_3e5]             # 00473b8e
    mov ecx, dword ptr [ebp - local_18]          # 00473b94
    add ecx, 0x3ed                               # 00473b97
    push ecx                                     # 00473b9d
    mov edx, dword ptr [ebp - local_18]          # 00473b9e
    add edx, 0x3d5                               # 00473ba1
    push edx                                     # 00473ba7
    mov eax, dword ptr [ebp - local_18]          # 00473ba8
    add eax, 0x3e1                               # 00473bab
    push eax                                     # 00473bb0
    mov ecx, 0x61f860                            # 00473bb1
    call FUN_0044c0e6                            # 00473bb6
    mov ecx, dword ptr [ebp - local_18]          # 00473bbb
    fld dword ptr [ecx + field_3ed]              # 00473bbe
    fcomp dword ptr [0x52d450]                   # 00473bc4
    fnstsw ax                                    # 00473bca
    test ah, 0x1                                 # 00473bcc
    je.d8 L_00473c1a                             # 00473bcf
    # block 0x00473bd1: entered by fall-through of je at 0x00473bcf, 6 instruction(s), ends with jne to 0x00473c1a (forward)
    mov edx, dword ptr [ebp - local_18]          # 00473bd1
    fld dword ptr [edx + field_3ed]              # 00473bd4
    fcomp dword ptr [0x52d44c]                   # 00473bda
    fnstsw ax                                    # 00473be0
    test ah, 0x41                                # 00473be2
    jne.d8 L_00473c1a                            # 00473be5
    # block 0x00473be7: entered by fall-through of jne at 0x00473be5, 6 instruction(s), ends with je to 0x00473c1a (forward)
    mov eax, dword ptr [ebp - local_18]          # 00473be7
    fld dword ptr [eax + field_3f1]              # 00473bea
    fcomp dword ptr [0x52d450]                   # 00473bf0
    fnstsw ax                                    # 00473bf6
    test ah, 0x1                                 # 00473bf8
    je.d8 L_00473c1a                             # 00473bfb
    # block 0x00473bfd: entered by fall-through of je at 0x00473bfb, 6 instruction(s), ends with jne to 0x00473c1a (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00473bfd
    fld dword ptr [ecx + field_3f1]              # 00473c00
    fcomp dword ptr [0x52d44c]                   # 00473c06
    fnstsw ax                                    # 00473c0c
    test ah, 0x41                                # 00473c0e
    jne.d8 L_00473c1a                            # 00473c11
    # block 0x00473c13: entered by fall-through of jne at 0x00473c11, 2 instruction(s), ends with forward jump to 0x00473e86
    {load} xor eax, eax                          # 00473c13
    jmp.d32 L_00473e86                           # 00473c15
L_00473c1a:
    # block 0x00473c1a: entered by je at 0x00473bcf; jne at 0x00473be5; je at 0x00473bfb; jne at 0x00473c11, 22 instruction(s), calls FUN_0044bf4b, ends with jne to 0x00473c7e (forward)
    mov edx, dword ptr [ebp - local_18]          # 00473c1a
    add edx, 0x3ed                               # 00473c1d
    push edx                                     # 00473c23
    mov ecx, 0x61f860                            # 00473c24
    call FUN_0044bf4b                            # 00473c29
    mov eax, dword ptr [0x63a860]                # 00473c2e
    mov dword ptr [ebp - local_20], eax          # 00473c33
    mov dword ptr [ebp - local_1c], 0x0          # 00473c36
    fild qword ptr [ebp - local_20]              # 00473c3d
    fstp dword ptr [ebp - local_24]              # 00473c40
    fld dword ptr [0x63a878]                     # 00473c43
    fmul dword ptr [ebp - local_24]              # 00473c49
    mov ecx, dword ptr [ebp - local_18]          # 00473c4c
    fstp dword ptr [ecx + field_3f9]             # 00473c4f
    mov edx, dword ptr [ebp - local_18]          # 00473c55
    fld dword ptr [edx + field_3f9]              # 00473c58
    mov eax, dword ptr [ebp - local_18]          # 00473c5e
    fld dword ptr [eax + field_3f5]              # 00473c61
    fcompp                                       # 00473c67
    fnstsw ax                                    # 00473c69
    test ah, 0x41                                # 00473c6b
    jne.d8 L_00473c7e                            # 00473c6e
    # block 0x00473c70: entered by fall-through of jne at 0x00473c6e, 4 instruction(s), ends with forward jump to 0x00473c8a
    mov ecx, dword ptr [ebp - local_18]          # 00473c70
    fld dword ptr [ecx + field_3f9]              # 00473c73
    fstp dword ptr [ebp - local_28]              # 00473c79
    jmp.d8 L_00473c8a                            # 00473c7c
L_00473c7e:
    # block 0x00473c7e: entered by jne at 0x00473c6e, 3 instruction(s), falls into the block at 0x00473c8a
    mov edx, dword ptr [ebp - local_18]          # 00473c7e
    fld dword ptr [edx + field_3f5]              # 00473c81
    fstp dword ptr [ebp - local_28]              # 00473c87
L_00473c8a:
    # block 0x00473c8a: entered by jmp at 0x00473c7c, 9 instruction(s), ends with je to 0x00473cb3 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00473c8a
    mov ecx, dword ptr [ebp - local_28]          # 00473c8d
    mov dword ptr [eax + field_3f9], ecx         # 00473c90
    mov edx, dword ptr [ebp - local_18]          # 00473c96
    fld dword ptr [edx + field_3f9]              # 00473c99
    fcomp dword ptr [0x52cbf4]                   # 00473c9f
    fnstsw ax                                    # 00473ca5
    test ah, 0x1                                 # 00473ca7
    je.d8 L_00473cb3                             # 00473caa
    # block 0x00473cac: entered by fall-through of je at 0x00473caa, 2 instruction(s), ends with forward jump to 0x00473e86
    {load} xor eax, eax                          # 00473cac
    jmp.d32 L_00473e86                           # 00473cae
L_00473cb3:
    # block 0x00473cb3: entered by je at 0x00473caa, 29 instruction(s), ends with forward jump to 0x00473d2d
    mov eax, dword ptr [ebp - local_18]          # 00473cb3
    add eax, 0x361                               # 00473cb6
    mov ecx, dword ptr [ebp - local_14]          # 00473cbb
    mov dword ptr [eax], ecx                     # 00473cbe
    mov edx, dword ptr [ebp - local_10]          # 00473cc0
    mov dword ptr [eax + field_4], edx           # 00473cc3
    mov ecx, dword ptr [ebp - local_c]           # 00473cc6
    mov dword ptr [eax + field_8], ecx           # 00473cc9
    mov edx, dword ptr [ebp - local_8]           # 00473ccc
    mov dword ptr [eax + field_c], edx           # 00473ccf
    mov eax, dword ptr [ebp - local_18]          # 00473cd2
    add eax, 0x3fd                               # 00473cd5
    mov ecx, dword ptr [ebp - local_14]          # 00473cda
    mov dword ptr [eax], ecx                     # 00473cdd
    mov edx, dword ptr [ebp - local_10]          # 00473cdf
    mov dword ptr [eax + field_4], edx           # 00473ce2
    mov ecx, dword ptr [ebp - local_c]           # 00473ce5
    mov dword ptr [eax + field_8], ecx           # 00473ce8
    mov edx, dword ptr [ebp - local_8]           # 00473ceb
    mov dword ptr [eax + field_c], edx           # 00473cee
    fild dword ptr [ebp - local_14]              # 00473cf1
    mov eax, dword ptr [ebp - local_18]          # 00473cf4
    fstp dword ptr [eax + field_40d]             # 00473cf7
    fild dword ptr [ebp - local_10]              # 00473cfd
    mov ecx, dword ptr [ebp - local_18]          # 00473d00
    fstp dword ptr [ecx + field_411]             # 00473d03
    mov edx, dword ptr [ebp - local_18]          # 00473d09
    mov dword ptr [edx + field_415], 0x0         # 00473d0c
    jmp.d8 L_00473d2d                            # 00473d16
L_00473d18:
    # block 0x00473d18: entered by jmp at 0x00473e39, 5 instruction(s), falls into the block at 0x00473d2d
    mov eax, dword ptr [ebp - local_18]          # 00473d18
    mov ecx, dword ptr [eax + field_415]         # 00473d1b
    add ecx, 0x1                                 # 00473d21
    mov edx, dword ptr [ebp - local_18]          # 00473d24
    mov dword ptr [edx + field_415], ecx         # 00473d27
L_00473d2d:
    # block 0x00473d2d: entered by jmp at 0x00473d16, 6 instruction(s), calls FUN_0050ce04, ends with jg to 0x00473e3e (forward)
    mov eax, dword ptr [ebp - local_18]          # 00473d2d
    fld dword ptr [eax + field_3f9]              # 00473d30
    call FUN_0050ce04                            # 00473d36
    mov ecx, dword ptr [ebp - local_18]          # 00473d3b
    cmp dword ptr [ecx + field_415], eax         # 00473d3e
    jg.d32 L_00473e3e                            # 00473d44
    # block 0x00473d4a: entered by fall-through of jg at 0x00473d44, 59 instruction(s), calls FUN_0050ce04, FUN_00473e8a, ends with je to 0x00473e39 (forward)
    mov edx, dword ptr [ebp - local_18]          # 00473d4a
    add edx, 0x361                               # 00473d4d
    mov eax, dword ptr [ebp - local_18]          # 00473d53
    add eax, 0x3fd                               # 00473d56
    mov ecx, dword ptr [edx]                     # 00473d5b
    mov dword ptr [eax], ecx                     # 00473d5d
    mov ecx, dword ptr [edx + field_4]           # 00473d5f
    mov dword ptr [eax + field_4], ecx           # 00473d62
    mov ecx, dword ptr [edx + field_8]           # 00473d65
    mov dword ptr [eax + field_8], ecx           # 00473d68
    mov edx, dword ptr [edx + field_c]           # 00473d6b
    mov dword ptr [eax + field_c], edx           # 00473d6e
    mov eax, dword ptr [ebp - local_18]          # 00473d71
    mov ecx, dword ptr [ebp - local_18]          # 00473d74
    fld dword ptr [eax + field_40d]              # 00473d77
    fadd dword ptr [ecx + field_3ed]             # 00473d7d
    mov edx, dword ptr [ebp - local_18]          # 00473d83
    fstp dword ptr [edx + field_40d]             # 00473d86
    mov eax, dword ptr [ebp - local_18]          # 00473d8c
    mov ecx, dword ptr [ebp - local_18]          # 00473d8f
    fld dword ptr [eax + field_411]              # 00473d92
    fadd dword ptr [ecx + field_3f1]             # 00473d98
    mov edx, dword ptr [ebp - local_18]          # 00473d9e
    fstp dword ptr [edx + field_411]             # 00473da1
    mov eax, dword ptr [ebp - local_18]          # 00473da7
    fld dword ptr [eax + field_40d]              # 00473daa
    call FUN_0050ce04                            # 00473db0
    mov ecx, dword ptr [ebp - local_18]          # 00473db5
    mov dword ptr [ecx + field_361], eax         # 00473db8
    mov edx, dword ptr [ebp - local_18]          # 00473dbe
    fld dword ptr [edx + field_411]              # 00473dc1
    call FUN_0050ce04                            # 00473dc7
    mov ecx, dword ptr [ebp - local_18]          # 00473dcc
    mov dword ptr [ecx + field_365], eax         # 00473dcf
    mov edx, dword ptr [ebp - local_4]           # 00473dd5
    imul edx, edx, 0x38                          # 00473dd8
    mov eax, dword ptr [ebp - local_18]          # 00473ddb
    mov ecx, dword ptr [eax + field_361]         # 00473dde
    mov eax, dword ptr [ebp - local_18]          # 00473de4
    mov edx, dword ptr [eax + edx + field_b6]    # 00473de7
    lea eax, [ecx + edx - field_minus_1]         # 00473dee
    mov ecx, dword ptr [ebp - local_18]          # 00473df2
    mov dword ptr [ecx + field_369], eax         # 00473df5
    mov edx, dword ptr [ebp - local_4]           # 00473dfb
    imul edx, edx, 0x38                          # 00473dfe
    mov eax, dword ptr [ebp - local_18]          # 00473e01
    mov ecx, dword ptr [eax + field_365]         # 00473e04
    mov eax, dword ptr [ebp - local_18]          # 00473e0a
    mov edx, dword ptr [eax + edx + field_ba]    # 00473e0d
    lea eax, [ecx + edx - field_minus_1]         # 00473e14
    mov ecx, dword ptr [ebp - local_18]          # 00473e18
    mov dword ptr [ecx + field_36d], eax         # 00473e1b
    mov edx, dword ptr [ebp - local_18]          # 00473e21
    add edx, 0x361                               # 00473e24
    push edx                                     # 00473e2a
    mov ecx, dword ptr [ebp - local_18]          # 00473e2b
    call FUN_00473e8a                            # 00473e2e
    test eax, eax                                # 00473e33
    je.d8 L_00473e39                             # 00473e35
    # block 0x00473e37: entered by fall-through of je at 0x00473e35, 1 instruction(s), ends with forward jump to 0x00473e3e
    jmp.d8 L_00473e3e                            # 00473e37
L_00473e39:
    # block 0x00473e39: entered by je at 0x00473e35, 1 instruction(s), ends with backward jump to 0x00473d18
    jmp.d32 L_00473d18                           # 00473e39
L_00473e3e:
    # block 0x00473e3e: entered by jg at 0x00473d44; jmp at 0x00473e37, 8 instruction(s), calls USER32.dll!EqualRect, ends with je to 0x00473e5a (forward)
    lea eax, [ebp - local_14]                    # 00473e3e
    push eax                                     # 00473e41
    mov ecx, dword ptr [ebp - local_18]          # 00473e42
    add ecx, 0x3fd                               # 00473e45
    push ecx                                     # 00473e4b
    call dword ptr [0x52a4b0]                    # 00473e4c
    test eax, eax                                # 00473e52
    je.d8 L_00473e5a                             # 00473e54
    # block 0x00473e56: entered by fall-through of je at 0x00473e54, 2 instruction(s), ends with forward jump to 0x00473e86
    {load} xor eax, eax                          # 00473e56
    jmp.d8 L_00473e86                            # 00473e58
L_00473e5a:
    # block 0x00473e5a: entered by je at 0x00473e54, 13 instruction(s), falls into the block at 0x00473e86
    mov edx, dword ptr [ebp - local_18]          # 00473e5a
    add edx, 0x3fd                               # 00473e5d
    mov eax, dword ptr [ebp - local_18]          # 00473e63
    add eax, 0x361                               # 00473e66
    mov ecx, dword ptr [edx]                     # 00473e6b
    mov dword ptr [eax], ecx                     # 00473e6d
    mov ecx, dword ptr [edx + field_4]           # 00473e6f
    mov dword ptr [eax + field_4], ecx           # 00473e72
    mov ecx, dword ptr [edx + field_8]           # 00473e75
    mov dword ptr [eax + field_8], ecx           # 00473e78
    mov edx, dword ptr [edx + field_c]           # 00473e7b
    mov dword ptr [eax + field_c], edx           # 00473e7e
    mov eax, 0x1                                 # 00473e81
L_00473e86:
    # block 0x00473e86: entered by jmp at 0x00473c15; jmp at 0x00473cae; jmp at 0x00473e58, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00473e86
    pop ebp                                      # 00473e88
    ret                                          # 00473e89

