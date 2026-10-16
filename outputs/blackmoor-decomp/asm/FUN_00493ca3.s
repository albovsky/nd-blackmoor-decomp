# FUN_00493ca3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493ca3
# extent:       0x00493ca3-0x00494cbc (4121 code bytes)
# span:         0x00493ca3-0x00494ccc (code 4121, tables 16, padding 0)
# sha256:       49bb2d1034ddfb7bb2ea8f7abb9fa75cd377f48b62ea483c45f45b8f2a5b9e50
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00493ca3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       49 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 37 more
# fields:       [eax + n] field_4, field_1ef3, field_1ef7, field_1efb, field_1eff, field_1f03, field_1f53, field_200b, field_2013, field_4769, field_47b5, field_47b9 and 14 more; [ecx + n] field_1ef3, field_1ef7, field_1efb, field_1eff, field_1f03, field_1f47, field_1f53, field_2003, field_200b, field_200f, field_2013, field_4769 and 11 more; [edx + n] field_1ef3, field_1ef7, field_1efb, field_1eff, field_1f03, field_1f43, field_1f53, field_2003, field_2007, field_200f, field_2013, field_47b5 and 13 more
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004dae66, FUN_0050ce04, FUN_004dae77, FUN_004959ea, FUN_00493c34
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1021 instruction(s), 89 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ field_4, 0x4  # offset +0x4
.equ field_1ef3, 0x1ef3  # offset +0x1ef3
.equ field_1ef7, 0x1ef7  # offset +0x1ef7
.equ field_1efb, 0x1efb  # offset +0x1efb
.equ field_1eff, 0x1eff  # offset +0x1eff
.equ field_1f03, 0x1f03  # offset +0x1f03
.equ field_1f43, 0x1f43  # offset +0x1f43
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f53, 0x1f53  # offset +0x1f53
.equ field_2003, 0x2003  # offset +0x2003
.equ field_2007, 0x2007  # offset +0x2007
.equ field_200b, 0x200b  # offset +0x200b
.equ field_200f, 0x200f  # offset +0x200f
.equ field_2013, 0x2013  # offset +0x2013
.equ field_4769, 0x4769  # offset +0x4769
.equ field_47b5, 0x47b5  # offset +0x47b5
.equ field_47b9, 0x47b9  # offset +0x47b9
.equ field_47bd, 0x47bd  # offset +0x47bd
.equ field_47c1, 0x47c1  # offset +0x47c1
.equ field_47c5, 0x47c5  # offset +0x47c5
.equ field_47c9, 0x47c9  # offset +0x47c9
.equ field_47cd, 0x47cd  # offset +0x47cd
.equ field_47d1, 0x47d1  # offset +0x47d1
.equ field_47f5, 0x47f5  # offset +0x47f5
.equ field_47f9, 0x47f9  # offset +0x47f9
.equ field_47fd, 0x47fd  # offset +0x47fd
.equ field_4801, 0x4801  # offset +0x4801
.equ field_4805, 0x4805  # offset +0x4805
.equ field_4809, 0x4809  # offset +0x4809
.equ field_480d, 0x480d  # offset +0x480d
.equ field_4811, 0x4811  # offset +0x4811
.equ field_4815, 0x4815  # offset +0x4815
.equ field_4819, 0x4819  # offset +0x4819
.equ field_481d, 0x481d  # offset +0x481d

# --- external targets -----------------------------------------------
.set FUN_00493c34, .text + (0x00493c34 - 0x401000)
.set FUN_004959ea, .text + (0x004959ea - 0x401000)
.set FUN_004dae66, .text + (0x004dae66 - 0x401000)
.set FUN_004dae77, .text + (0x004dae77 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00493ca3 - 0x401000
.globl FUN_00493ca3
FUN_00493ca3:
    # block 0x00493ca3: entry, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x00493ce0 (forward)
    push ebp                                     # 00493ca3
    {load} mov ebp, esp                          # 00493ca4
    sub esp, 0xc4                                # 00493ca6
    mov dword ptr [ebp - local_60], ecx          # 00493cac
    call dword ptr [0x52a23c]                    # 00493caf
    mov dword ptr [ebp - local_48], eax          # 00493cb5
    {load} xor eax, eax                          # 00493cb8
    mov al, byte ptr [0x63a8c4]                  # 00493cba
    and eax, 0x1                                 # 00493cbf
    test eax, eax                                # 00493cc2
    jne.d8 L_00493ce0                            # 00493cc4
    # block 0x00493cc6: entered by fall-through of jne at 0x00493cc4, 5 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00493ce0
    mov cl, byte ptr [0x63a8c4]                  # 00493cc6
    or cl, 0x1                                   # 00493ccc
    mov byte ptr [0x63a8c4], cl                  # 00493ccf
    call dword ptr [0x52a23c]                    # 00493cd5
    mov dword ptr [0x63a8c0], eax                # 00493cdb
L_00493ce0:
    # block 0x00493ce0: entered by jne at 0x00493cc4, 9 instruction(s), ends with je to 0x00493e20 (forward)
    mov edx, dword ptr [ebp - local_48]          # 00493ce0
    sub edx, dword ptr [0x63a8c0]                # 00493ce3
    imul edx, edx, 0x3e8                         # 00493ce9
    mov dword ptr [ebp - local_50], edx          # 00493cef
    mov eax, dword ptr [ebp - local_48]          # 00493cf2
    mov dword ptr [0x63a8c0], eax                # 00493cf5
    mov ecx, dword ptr [ebp - local_60]          # 00493cfa
    cmp dword ptr [ecx + field_200b], 0x0        # 00493cfd
    je.d32 L_00493e20                            # 00493d04
    # block 0x00493d0a: entered by fall-through of je at 0x00493d04, 4 instruction(s), ends with jne to 0x00493d25 (forward)
    {load} xor edx, edx                          # 00493d0a
    mov dl, byte ptr [0x58321d]                  # 00493d0c
    test edx, edx                                # 00493d12
    jne.d8 L_00493d25                            # 00493d14
    # block 0x00493d16: entered by fall-through of jne at 0x00493d14, 4 instruction(s), ends with je to 0x00493e20 (forward)
    {load} xor eax, eax                          # 00493d16
    mov al, byte ptr [0x58321e]                  # 00493d18
    test eax, eax                                # 00493d1d
    je.d32 L_00493e20                            # 00493d1f
L_00493d25:
    # block 0x00493d25: entered by jne at 0x00493d14; fall-through of je at 0x00493d1f, 5 instruction(s), calls FUN_004dae66, ends with jge to 0x00493da2 (forward)
    mov ecx, 0x5830a6                            # 00493d25
    call FUN_004dae66                            # 00493d2a
    mov ecx, dword ptr [ebp - local_60]          # 00493d2f
    cmp eax, dword ptr [ecx + field_2003]        # 00493d32
    jge.d8 L_00493da2                            # 00493d38
    # block 0x00493d3a: entered by fall-through of jge at 0x00493d38, 20 instruction(s), calls FUN_004dae66, FUN_0050ce04, ends with jge to 0x00493da2 (forward)
    mov ecx, 0x5830a6                            # 00493d3a
    call FUN_004dae66                            # 00493d3f
    mov edx, dword ptr [ebp - local_60]          # 00493d44
    mov ecx, dword ptr [edx + field_2003]        # 00493d47
    {load} sub ecx, eax                          # 00493d4d
    mov dword ptr [ebp - local_64], ecx          # 00493d4f
    fild dword ptr [ebp - local_64]              # 00493d52
    fstp dword ptr [ebp - local_68]              # 00493d55
    fld dword ptr [ebp - local_68]               # 00493d58
    fmul dword ptr [0x52db68]                    # 00493d5b
    call FUN_0050ce04                            # 00493d61
    mov dword ptr [ebp - local_28], eax          # 00493d66
    mov edx, dword ptr [ebp - local_60]          # 00493d69
    mov eax, dword ptr [edx + field_1ef3]        # 00493d6c
    sub eax, dword ptr [ebp - local_28]          # 00493d72
    mov ecx, dword ptr [ebp - local_60]          # 00493d75
    mov dword ptr [ecx + field_1ef3], eax        # 00493d78
    mov edx, dword ptr [ebp - local_60]          # 00493d7e
    cmp dword ptr [edx + field_1ef3], 0x0        # 00493d81
    jge.d8 L_00493da2                            # 00493d88
    # block 0x00493d8a: entered by fall-through of jge at 0x00493d88, 5 instruction(s), falls into the block at 0x00493da2
    mov eax, dword ptr [ebp - local_60]          # 00493d8a
    mov ecx, dword ptr [eax + field_1ef3]        # 00493d8d
    add ecx, 0x1000                              # 00493d93
    mov edx, dword ptr [ebp - local_60]          # 00493d99
    mov dword ptr [edx + field_1ef3], ecx        # 00493d9c
L_00493da2:
    # block 0x00493da2: entered by jge at 0x00493d38; jge at 0x00493d88, 5 instruction(s), calls FUN_004dae66, ends with jle to 0x00493e20 (forward)
    mov ecx, 0x5830a6                            # 00493da2
    call FUN_004dae66                            # 00493da7
    mov ecx, dword ptr [ebp - local_60]          # 00493dac
    cmp eax, dword ptr [ecx + field_2003]        # 00493daf
    jle.d8 L_00493e20                            # 00493db5
    # block 0x00493db7: entered by fall-through of jle at 0x00493db5, 19 instruction(s), calls FUN_004dae66, FUN_0050ce04, ends with jle to 0x00493e20 (forward)
    mov ecx, 0x5830a6                            # 00493db7
    call FUN_004dae66                            # 00493dbc
    mov edx, dword ptr [ebp - local_60]          # 00493dc1
    sub eax, dword ptr [edx + field_2003]        # 00493dc4
    mov dword ptr [ebp - local_6c], eax          # 00493dca
    fild dword ptr [ebp - local_6c]              # 00493dcd
    fstp dword ptr [ebp - local_70]              # 00493dd0
    fld dword ptr [ebp - local_70]               # 00493dd3
    fmul dword ptr [0x52db68]                    # 00493dd6
    call FUN_0050ce04                            # 00493ddc
    mov dword ptr [ebp - local_28], eax          # 00493de1
    mov eax, dword ptr [ebp - local_60]          # 00493de4
    mov ecx, dword ptr [eax + field_1ef3]        # 00493de7
    add ecx, dword ptr [ebp - local_28]          # 00493ded
    mov edx, dword ptr [ebp - local_60]          # 00493df0
    mov dword ptr [edx + field_1ef3], ecx        # 00493df3
    mov eax, dword ptr [ebp - local_60]          # 00493df9
    cmp dword ptr [eax + field_1ef3], 0xfff      # 00493dfc
    jle.d8 L_00493e20                            # 00493e06
    # block 0x00493e08: entered by fall-through of jle at 0x00493e06, 5 instruction(s), falls into the block at 0x00493e20
    mov ecx, dword ptr [ebp - local_60]          # 00493e08
    mov edx, dword ptr [ecx + field_1ef3]        # 00493e0b
    sub edx, 0x1000                              # 00493e11
    mov eax, dword ptr [ebp - local_60]          # 00493e17
    mov dword ptr [eax + field_1ef3], edx        # 00493e1a
L_00493e20:
    # block 0x00493e20: entered by je at 0x00493d04; je at 0x00493d1f; jle at 0x00493db5; jle at 0x00493e06, 30 instruction(s), calls FUN_004dae66, FUN_004dae77, ends with je to 0x00493ef4 (forward)
    mov ecx, 0x5830a6                            # 00493e20
    call FUN_004dae66                            # 00493e25
    mov ecx, dword ptr [ebp - local_60]          # 00493e2a
    mov dword ptr [ecx + field_2003], eax        # 00493e2d
    mov ecx, 0x5830a6                            # 00493e33
    call FUN_004dae77                            # 00493e38
    mov edx, dword ptr [ebp - local_60]          # 00493e3d
    mov dword ptr [edx + field_2007], eax        # 00493e40
    mov eax, dword ptr [ebp - local_50]          # 00493e46
    mov dword ptr [ebp - local_78], eax          # 00493e49
    mov dword ptr [ebp - local_74], 0x0          # 00493e4c
    fild qword ptr [ebp - local_78]              # 00493e53
    fstp dword ptr [ebp - local_7c]              # 00493e56
    mov ecx, dword ptr [ebp - local_60]          # 00493e59
    fld dword ptr [ebp - local_7c]               # 00493e5c
    fmul dword ptr [ecx + field_4819]            # 00493e5f
    fstp dword ptr [ebp - local_14]              # 00493e65
    mov edx, dword ptr [ebp - local_50]          # 00493e68
    mov dword ptr [ebp - local_84], edx          # 00493e6b
    mov dword ptr [ebp - local_80], 0x0          # 00493e71
    fild qword ptr [ebp - local_84]              # 00493e78
    fstp dword ptr [ebp - local_88]              # 00493e7e
    mov eax, dword ptr [ebp - local_60]          # 00493e84
    fld dword ptr [ebp - local_88]               # 00493e87
    fmul dword ptr [eax + field_4815]            # 00493e8d
    fstp dword ptr [ebp - local_3c]              # 00493e93
    {load} xor ecx, ecx                          # 00493e96
    mov cl, byte ptr [0x583216]                  # 00493e98
    test ecx, ecx                                # 00493e9e
    je.d8 L_00493ef4                             # 00493ea0
    # block 0x00493ea2: entered by fall-through of je at 0x00493ea0, 11 instruction(s), calls FUN_0050ce04, ends with jle to 0x00493eef (forward)
    mov edx, dword ptr [ebp - local_60]          # 00493ea2
    fild dword ptr [edx + field_1ef3]            # 00493ea5
    fstp dword ptr [ebp - local_8c]              # 00493eab
    fld dword ptr [ebp - local_8c]               # 00493eb1
    fadd dword ptr [ebp - local_14]              # 00493eb7
    call FUN_0050ce04                            # 00493eba
    mov ecx, dword ptr [ebp - local_60]          # 00493ebf
    mov dword ptr [ecx + field_1ef3], eax        # 00493ec2
    mov edx, dword ptr [ebp - local_60]          # 00493ec8
    cmp dword ptr [edx + field_1ef3], 0xfff      # 00493ecb
    jle.d8 L_00493eef                            # 00493ed5
    # block 0x00493ed7: entered by fall-through of jle at 0x00493ed5, 5 instruction(s), falls into the block at 0x00493eef
    mov eax, dword ptr [ebp - local_60]          # 00493ed7
    mov ecx, dword ptr [eax + field_1ef3]        # 00493eda
    sub ecx, 0x1000                              # 00493ee0
    mov edx, dword ptr [ebp - local_60]          # 00493ee6
    mov dword ptr [edx + field_1ef3], ecx        # 00493ee9
L_00493eef:
    # block 0x00493eef: entered by jle at 0x00493ed5, 1 instruction(s), ends with forward jump to 0x00494002
    jmp.d32 L_00494002                           # 00493eef
L_00493ef4:
    # block 0x00493ef4: entered by je at 0x00493ea0, 4 instruction(s), ends with je to 0x00493f4e (forward)
    {load} xor eax, eax                          # 00493ef4
    mov al, byte ptr [0x583215]                  # 00493ef6
    test eax, eax                                # 00493efb
    je.d8 L_00493f4e                             # 00493efd
    # block 0x00493eff: entered by fall-through of je at 0x00493efd, 11 instruction(s), calls FUN_0050ce04, ends with jge to 0x00493f49 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00493eff
    fild dword ptr [ecx + field_1ef3]            # 00493f02
    fstp dword ptr [ebp - local_90]              # 00493f08
    fld dword ptr [ebp - local_90]               # 00493f0e
    fsub dword ptr [ebp - local_14]              # 00493f14
    call FUN_0050ce04                            # 00493f17
    mov edx, dword ptr [ebp - local_60]          # 00493f1c
    mov dword ptr [edx + field_1ef3], eax        # 00493f1f
    mov eax, dword ptr [ebp - local_60]          # 00493f25
    cmp dword ptr [eax + field_1ef3], 0x0        # 00493f28
    jge.d8 L_00493f49                            # 00493f2f
    # block 0x00493f31: entered by fall-through of jge at 0x00493f2f, 5 instruction(s), falls into the block at 0x00493f49
    mov ecx, dword ptr [ebp - local_60]          # 00493f31
    mov edx, dword ptr [ecx + field_1ef3]        # 00493f34
    add edx, 0x1000                              # 00493f3a
    mov eax, dword ptr [ebp - local_60]          # 00493f40
    mov dword ptr [eax + field_1ef3], edx        # 00493f43
L_00493f49:
    # block 0x00493f49: entered by jge at 0x00493f2f, 1 instruction(s), ends with forward jump to 0x00494002
    jmp.d32 L_00494002                           # 00493f49
L_00493f4e:
    # block 0x00493f4e: entered by je at 0x00493efd, 4 instruction(s), ends with je to 0x00493fab (forward)
    {load} xor ecx, ecx                          # 00493f4e
    mov cl, byte ptr [0x583228]                  # 00493f50
    test ecx, ecx                                # 00493f56
    je.d8 L_00493fab                             # 00493f58
    # block 0x00493f5a: entered by fall-through of je at 0x00493f58, 12 instruction(s), calls FUN_0050ce04, ends with jle to 0x00493fa9 (forward)
    mov edx, dword ptr [ebp - local_60]          # 00493f5a
    fild dword ptr [edx + field_1ef3]            # 00493f5d
    fstp dword ptr [ebp - local_94]              # 00493f63
    fld dword ptr [ebp - local_14]               # 00493f69
    .insn 0xdc, 0xc0                             # 00493f6c
    fadd dword ptr [ebp - local_94]              # 00493f6e
    call FUN_0050ce04                            # 00493f74
    mov ecx, dword ptr [ebp - local_60]          # 00493f79
    mov dword ptr [ecx + field_1ef3], eax        # 00493f7c
    mov edx, dword ptr [ebp - local_60]          # 00493f82
    cmp dword ptr [edx + field_1ef3], 0xfff      # 00493f85
    jle.d8 L_00493fa9                            # 00493f8f
    # block 0x00493f91: entered by fall-through of jle at 0x00493f8f, 5 instruction(s), falls into the block at 0x00493fa9
    mov eax, dword ptr [ebp - local_60]          # 00493f91
    mov ecx, dword ptr [eax + field_1ef3]        # 00493f94
    sub ecx, 0x1000                              # 00493f9a
    mov edx, dword ptr [ebp - local_60]          # 00493fa0
    mov dword ptr [edx + field_1ef3], ecx        # 00493fa3
L_00493fa9:
    # block 0x00493fa9: entered by jle at 0x00493f8f, 1 instruction(s), ends with forward jump to 0x00494002
    jmp.d8 L_00494002                            # 00493fa9
L_00493fab:
    # block 0x00493fab: entered by je at 0x00493f58, 4 instruction(s), ends with je to 0x00494002 (forward)
    {load} xor eax, eax                          # 00493fab
    mov al, byte ptr [0x583227]                  # 00493fad
    test eax, eax                                # 00493fb2
    je.d8 L_00494002                             # 00493fb4
    # block 0x00493fb6: entered by fall-through of je at 0x00493fb4, 12 instruction(s), calls FUN_0050ce04, ends with jge to 0x00494002 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00493fb6
    fild dword ptr [ecx + field_1ef3]            # 00493fb9
    fstp dword ptr [ebp - local_98]              # 00493fbf
    fld dword ptr [ebp - local_14]               # 00493fc5
    .insn 0xdc, 0xc0                             # 00493fc8
    fsubr dword ptr [ebp - local_98]             # 00493fca
    call FUN_0050ce04                            # 00493fd0
    mov edx, dword ptr [ebp - local_60]          # 00493fd5
    mov dword ptr [edx + field_1ef3], eax        # 00493fd8
    mov eax, dword ptr [ebp - local_60]          # 00493fde
    cmp dword ptr [eax + field_1ef3], 0x0        # 00493fe1
    jge.d8 L_00494002                            # 00493fe8
    # block 0x00493fea: entered by fall-through of jge at 0x00493fe8, 5 instruction(s), falls into the block at 0x00494002
    mov ecx, dword ptr [ebp - local_60]          # 00493fea
    mov edx, dword ptr [ecx + field_1ef3]        # 00493fed
    add edx, 0x1000                              # 00493ff3
    mov eax, dword ptr [ebp - local_60]          # 00493ff9
    mov dword ptr [eax + field_1ef3], edx        # 00493ffc
L_00494002:
    # block 0x00494002: entered by jmp at 0x00493eef; jmp at 0x00493f49; jmp at 0x00493fa9; je at 0x00493fb4; more, 8 instruction(s), ends with jne to 0x00494041 (forward)
    mov dword ptr [ebp - local_5c], 0x0          # 00494002
    mov dword ptr [ebp - local_58], 0x0          # 00494009
    mov ecx, dword ptr [ebp - local_60]          # 00494010
    mov dword ptr [ecx + field_4769], 0x0        # 00494013
    {load} xor edx, edx                          # 0049401d
    mov dl, byte ptr [0x583213]                  # 0049401f
    test edx, edx                                # 00494025
    jne.d8 L_00494041                            # 00494027
    # block 0x00494029: entered by fall-through of jne at 0x00494027, 3 instruction(s), ends with je to 0x004940ae (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494029
    cmp dword ptr [eax + field_200b], 0x0        # 0049402c
    je.d8 L_004940ae                             # 00494033
    # block 0x00494035: entered by fall-through of je at 0x00494033, 4 instruction(s), ends with je to 0x004940ae (forward)
    {load} xor ecx, ecx                          # 00494035
    mov cl, byte ptr [0x58321d]                  # 00494037
    test ecx, ecx                                # 0049403d
    je.d8 L_004940ae                             # 0049403f
L_00494041:
    # block 0x00494041: entered by jne at 0x00494027; fall-through of je at 0x0049403f, 26 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004944e4
    mov edx, dword ptr [ebp - local_60]          # 00494041
    mov eax, dword ptr [edx + field_1ef3]        # 00494044
    and eax, 0xfff                               # 0049404a
    mov ecx, dword ptr [ebp - local_60]          # 0049404f
    mov edx, dword ptr [ecx + field_2013]        # 00494052
    fld dword ptr [edx + 4*eax]                  # 00494058
    fmul dword ptr [ebp - local_3c]              # 0049405b
    call FUN_0050ce04                            # 0049405e
    mov ecx, dword ptr [ebp - local_60]          # 00494063
    mov edx, dword ptr [ecx + field_1ef7]        # 00494066
    {load} sub edx, eax                          # 0049406c
    mov dword ptr [ebp - local_4], edx           # 0049406e
    mov eax, dword ptr [ebp - local_60]          # 00494071
    mov ecx, dword ptr [eax + field_1ef3]        # 00494074
    and ecx, 0xfff                               # 0049407a
    mov edx, dword ptr [ebp - local_60]          # 00494080
    mov eax, dword ptr [edx + field_200f]        # 00494083
    fld dword ptr [eax + 4*ecx]                  # 00494089
    fmul dword ptr [ebp - local_3c]              # 0049408c
    call FUN_0050ce04                            # 0049408f
    mov ecx, dword ptr [ebp - local_60]          # 00494094
    mov edx, dword ptr [ecx + field_1efb]        # 00494097
    {load} add edx, eax                          # 0049409d
    mov dword ptr [ebp - local_34], edx          # 0049409f
    mov dword ptr [ebp - local_5c], 0x1          # 004940a2
    jmp.d32 L_004944e4                           # 004940a9
L_004940ae:
    # block 0x004940ae: entered by je at 0x00494033; je at 0x0049403f, 4 instruction(s), ends with jne to 0x004940d1 (forward)
    {load} xor eax, eax                          # 004940ae
    mov al, byte ptr [0x583214]                  # 004940b0
    test eax, eax                                # 004940b5
    jne.d8 L_004940d1                            # 004940b7
    # block 0x004940b9: entered by fall-through of jne at 0x004940b7, 3 instruction(s), ends with je to 0x0049413f (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004940b9
    cmp dword ptr [ecx + field_200b], 0x0        # 004940bc
    je.d8 L_0049413f                             # 004940c3
    # block 0x004940c5: entered by fall-through of je at 0x004940c3, 4 instruction(s), ends with je to 0x0049413f (forward)
    {load} xor edx, edx                          # 004940c5
    mov dl, byte ptr [0x58321e]                  # 004940c7
    test edx, edx                                # 004940cd
    je.d8 L_0049413f                             # 004940cf
L_004940d1:
    # block 0x004940d1: entered by jne at 0x004940b7; fall-through of je at 0x004940cf, 26 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004944e4
    mov eax, dword ptr [ebp - local_60]          # 004940d1
    mov ecx, dword ptr [eax + field_1ef3]        # 004940d4
    and ecx, 0xfff                               # 004940da
    mov edx, dword ptr [ebp - local_60]          # 004940e0
    mov eax, dword ptr [edx + field_2013]        # 004940e3
    fld dword ptr [eax + 4*ecx]                  # 004940e9
    fmul dword ptr [ebp - local_3c]              # 004940ec
    call FUN_0050ce04                            # 004940ef
    mov ecx, dword ptr [ebp - local_60]          # 004940f4
    mov edx, dword ptr [ecx + field_1ef7]        # 004940f7
    {load} add edx, eax                          # 004940fd
    mov dword ptr [ebp - local_4], edx           # 004940ff
    mov eax, dword ptr [ebp - local_60]          # 00494102
    mov ecx, dword ptr [eax + field_1ef3]        # 00494105
    and ecx, 0xfff                               # 0049410b
    mov edx, dword ptr [ebp - local_60]          # 00494111
    mov eax, dword ptr [edx + field_200f]        # 00494114
    fld dword ptr [eax + 4*ecx]                  # 0049411a
    fmul dword ptr [ebp - local_3c]              # 0049411d
    call FUN_0050ce04                            # 00494120
    mov ecx, dword ptr [ebp - local_60]          # 00494125
    mov edx, dword ptr [ecx + field_1efb]        # 00494128
    {load} sub edx, eax                          # 0049412e
    mov dword ptr [ebp - local_34], edx          # 00494130
    mov dword ptr [ebp - local_5c], 0x1          # 00494133
    jmp.d32 L_004944e4                           # 0049413a
L_0049413f:
    # block 0x0049413f: entered by je at 0x004940c3; je at 0x004940cf, 4 instruction(s), ends with je to 0x004941bb (forward)
    {load} xor eax, eax                          # 0049413f
    mov al, byte ptr [0x583225]                  # 00494141
    test eax, eax                                # 00494146
    je.d8 L_004941bb                             # 00494148
    # block 0x0049414a: entered by fall-through of je at 0x00494148, 28 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004944e4
    mov ecx, dword ptr [ebp - local_60]          # 0049414a
    mov edx, dword ptr [ecx + field_1ef3]        # 0049414d
    and edx, 0xfff                               # 00494153
    mov eax, dword ptr [ebp - local_60]          # 00494159
    mov ecx, dword ptr [eax + field_2013]        # 0049415c
    fld dword ptr [ecx + 4*edx]                  # 00494162
    fmul dword ptr [ebp - local_3c]              # 00494165
    .insn 0xdc, 0xc0                             # 00494168
    call FUN_0050ce04                            # 0049416a
    mov edx, dword ptr [ebp - local_60]          # 0049416f
    mov ecx, dword ptr [edx + field_1ef7]        # 00494172
    {load} sub ecx, eax                          # 00494178
    mov dword ptr [ebp - local_4], ecx           # 0049417a
    mov edx, dword ptr [ebp - local_60]          # 0049417d
    mov eax, dword ptr [edx + field_1ef3]        # 00494180
    and eax, 0xfff                               # 00494186
    mov ecx, dword ptr [ebp - local_60]          # 0049418b
    mov edx, dword ptr [ecx + field_200f]        # 0049418e
    fld dword ptr [edx + 4*eax]                  # 00494194
    fmul dword ptr [ebp - local_3c]              # 00494197
    .insn 0xdc, 0xc0                             # 0049419a
    call FUN_0050ce04                            # 0049419c
    mov ecx, dword ptr [ebp - local_60]          # 004941a1
    mov edx, dword ptr [ecx + field_1efb]        # 004941a4
    {load} add edx, eax                          # 004941aa
    mov dword ptr [ebp - local_34], edx          # 004941ac
    mov dword ptr [ebp - local_5c], 0x1          # 004941af
    jmp.d32 L_004944e4                           # 004941b6
L_004941bb:
    # block 0x004941bb: entered by je at 0x00494148, 4 instruction(s), ends with je to 0x00494237 (forward)
    {load} xor eax, eax                          # 004941bb
    mov al, byte ptr [0x583226]                  # 004941bd
    test eax, eax                                # 004941c2
    je.d8 L_00494237                             # 004941c4
    # block 0x004941c6: entered by fall-through of je at 0x004941c4, 28 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004944e4
    mov ecx, dword ptr [ebp - local_60]          # 004941c6
    mov edx, dword ptr [ecx + field_1ef3]        # 004941c9
    and edx, 0xfff                               # 004941cf
    mov eax, dword ptr [ebp - local_60]          # 004941d5
    mov ecx, dword ptr [eax + field_2013]        # 004941d8
    fld dword ptr [ecx + 4*edx]                  # 004941de
    fmul dword ptr [ebp - local_3c]              # 004941e1
    .insn 0xdc, 0xc0                             # 004941e4
    call FUN_0050ce04                            # 004941e6
    mov edx, dword ptr [ebp - local_60]          # 004941eb
    mov ecx, dword ptr [edx + field_1ef7]        # 004941ee
    {load} add ecx, eax                          # 004941f4
    mov dword ptr [ebp - local_4], ecx           # 004941f6
    mov edx, dword ptr [ebp - local_60]          # 004941f9
    mov eax, dword ptr [edx + field_1ef3]        # 004941fc
    and eax, 0xfff                               # 00494202
    mov ecx, dword ptr [ebp - local_60]          # 00494207
    mov edx, dword ptr [ecx + field_200f]        # 0049420a
    fld dword ptr [edx + 4*eax]                  # 00494210
    fmul dword ptr [ebp - local_3c]              # 00494213
    .insn 0xdc, 0xc0                             # 00494216
    call FUN_0050ce04                            # 00494218
    mov ecx, dword ptr [ebp - local_60]          # 0049421d
    mov edx, dword ptr [ecx + field_1efb]        # 00494220
    {load} sub edx, eax                          # 00494226
    mov dword ptr [ebp - local_34], edx          # 00494228
    mov dword ptr [ebp - local_5c], 0x1          # 0049422b
    jmp.d32 L_004944e4                           # 00494232
L_00494237:
    # block 0x00494237: entered by je at 0x004941c4, 12 instruction(s), ends with jne to 0x00494406 (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494237
    mov ecx, dword ptr [eax + field_1eff]        # 0049423a
    imul ecx, ecx, 0xa6                          # 00494240
    mov edx, dword ptr [ebp - local_60]          # 00494246
    mov eax, dword ptr [edx + field_1f53]        # 00494249
    lea ecx, [eax + 4*ecx]                       # 0049424f
    mov edx, dword ptr [ebp - local_60]          # 00494252
    mov eax, dword ptr [edx + field_1f03]        # 00494255
    mov ecx, dword ptr [ecx + 4*eax]             # 0049425b
    and ecx, 0xff                                # 0049425e
    cmp ecx, 0x3                                 # 00494264
    jne.d32 L_00494406                           # 00494267
    # block 0x0049426d: entered by fall-through of jne at 0x00494267, 16 instruction(s), ends with je to 0x004942d4 (forward)
    mov edx, dword ptr [ebp - local_60]          # 0049426d
    mov eax, dword ptr [edx + field_1eff]        # 00494270
    imul eax, eax, 0xa6                          # 00494276
    mov ecx, dword ptr [ebp - local_60]          # 0049427c
    mov edx, dword ptr [ecx + field_1f53]        # 0049427f
    lea eax, [edx + 4*eax]                       # 00494285
    mov ecx, dword ptr [ebp - local_60]          # 00494288
    mov edx, dword ptr [ecx + field_1f03]        # 0049428b
    mov eax, dword ptr [eax + 4*edx]             # 00494291
    shr eax, 0x1c                                # 00494294
    and eax, 0xf                                 # 00494297
    mov byte ptr [ebp - local_1c], al            # 0049429a
    mov ecx, dword ptr [ebp - local_1c]          # 0049429d
    and ecx, 0xff                                # 004942a0
    test ecx, ecx                                # 004942a6
    je.d8 L_004942d4                             # 004942a8
    # block 0x004942aa: entered by fall-through of je at 0x004942a8, 4 instruction(s), ends with je to 0x00494406 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004942aa
    and edx, 0xff                                # 004942ad
    test edx, edx                                # 004942b3
    je.d32 L_00494406                            # 004942b5
    # block 0x004942bb: entered by fall-through of je at 0x004942b5, 7 instruction(s), calls FUN_004959ea, ends with je to 0x00494406 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004942bb
    and eax, 0xff                                # 004942be
    push eax                                     # 004942c3
    mov ecx, dword ptr [ebp - local_60]          # 004942c4
    call FUN_004959ea                            # 004942c7
    test eax, eax                                # 004942cc
    je.d32 L_00494406                            # 004942ce
L_004942d4:
    # block 0x004942d4: entered by je at 0x004942a8; fall-through of je at 0x004942ce, 17 instruction(s), ends with ja to 0x004943f4 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004942d4
    mov edx, dword ptr [ecx + field_1eff]        # 004942d7
    imul edx, edx, 0xa6                          # 004942dd
    mov eax, dword ptr [ebp - local_60]          # 004942e3
    mov ecx, dword ptr [eax + field_1f53]        # 004942e6
    lea edx, [ecx + 4*edx]                       # 004942ec
    mov eax, dword ptr [ebp - local_60]          # 004942ef
    mov ecx, dword ptr [eax + field_1f03]        # 004942f2
    mov edx, dword ptr [edx + 4*ecx]             # 004942f8
    shr edx, 0x8                                 # 004942fb
    and edx, 0xff                                # 004942fe
    mov byte ptr [ebp - local_8], dl             # 00494304
    mov eax, dword ptr [ebp - local_8]           # 00494307
    and eax, 0xff                                # 0049430a
    mov dword ptr [ebp - local_9c], eax          # 0049430f
    cmp dword ptr [ebp - local_9c], 0x3          # 00494315
    ja.d32 L_004943f4                            # 0049431c
    # block 0x00494322: entered by fall-through of ja at 0x0049431c, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x494cbc]
    mov ecx, dword ptr [ebp - local_9c]          # 00494322
    jmp dword ptr [4*ecx + SWTAB_00494cbc_VA]    # 00494328
L_0049432f:
    # block 0x0049432f: entered by switch case, 12 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004943f4
    fld dword ptr [ebp - local_3c]               # 0049432f
    fmul qword ptr [0x52db60]                    # 00494332
    call FUN_0050ce04                            # 00494338
    mov edx, dword ptr [ebp - local_60]          # 0049433d
    mov ecx, dword ptr [edx + field_1ef7]        # 00494340
    {load} add ecx, eax                          # 00494346
    mov dword ptr [ebp - local_4], ecx           # 00494348
    mov edx, dword ptr [ebp - local_60]          # 0049434b
    mov eax, dword ptr [edx + field_1efb]        # 0049434e
    mov dword ptr [ebp - local_34], eax          # 00494354
    mov dword ptr [ebp - local_5c], 0x1          # 00494357
    jmp.d32 L_004943f4                           # 0049435e
L_00494363:
    # block 0x00494363: entered by switch case, 12 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004943f4
    mov ecx, dword ptr [ebp - local_60]          # 00494363
    mov edx, dword ptr [ecx + field_1ef7]        # 00494366
    mov dword ptr [ebp - local_4], edx           # 0049436c
    fld dword ptr [ebp - local_3c]               # 0049436f
    fmul qword ptr [0x52db60]                    # 00494372
    call FUN_0050ce04                            # 00494378
    mov ecx, dword ptr [ebp - local_60]          # 0049437d
    mov edx, dword ptr [ecx + field_1efb]        # 00494380
    {load} add edx, eax                          # 00494386
    mov dword ptr [ebp - local_34], edx          # 00494388
    mov dword ptr [ebp - local_5c], 0x1          # 0049438b
    jmp.d8 L_004943f4                            # 00494392
L_00494394:
    # block 0x00494394: entered by switch case, 12 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004943f4
    fld dword ptr [ebp - local_3c]               # 00494394
    fmul qword ptr [0x52db60]                    # 00494397
    call FUN_0050ce04                            # 0049439d
    mov ecx, dword ptr [ebp - local_60]          # 004943a2
    mov edx, dword ptr [ecx + field_1ef7]        # 004943a5
    {load} sub edx, eax                          # 004943ab
    mov dword ptr [ebp - local_4], edx           # 004943ad
    mov eax, dword ptr [ebp - local_60]          # 004943b0
    mov ecx, dword ptr [eax + field_1efb]        # 004943b3
    mov dword ptr [ebp - local_34], ecx          # 004943b9
    mov dword ptr [ebp - local_5c], 0x1          # 004943bc
    jmp.d8 L_004943f4                            # 004943c3
L_004943c5:
    # block 0x004943c5: entered by switch case, 11 instruction(s), calls FUN_0050ce04, falls into the block at 0x004943f4
    mov edx, dword ptr [ebp - local_60]          # 004943c5
    mov eax, dword ptr [edx + field_1ef7]        # 004943c8
    mov dword ptr [ebp - local_4], eax           # 004943ce
    fld dword ptr [ebp - local_3c]               # 004943d1
    fmul qword ptr [0x52db60]                    # 004943d4
    call FUN_0050ce04                            # 004943da
    mov ecx, dword ptr [ebp - local_60]          # 004943df
    mov edx, dword ptr [ecx + field_1efb]        # 004943e2
    {load} sub edx, eax                          # 004943e8
    mov dword ptr [ebp - local_34], edx          # 004943ea
    mov dword ptr [ebp - local_5c], 0x1          # 004943ed
L_004943f4:
    # block 0x004943f4: entered by ja at 0x0049431c; jmp at 0x0049435e; jmp at 0x00494392; jmp at 0x004943c3, 3 instruction(s), ends with forward jump to 0x004944e4
    mov eax, dword ptr [ebp - local_60]          # 004943f4
    mov dword ptr [eax + field_4769], 0x1        # 004943f7
    jmp.d32 L_004944e4                           # 00494401
L_00494406:
    # block 0x00494406: entered by jne at 0x00494267; je at 0x004942b5; je at 0x004942ce, 4 instruction(s), ends with jae to 0x004944e4 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00494406
    mov edx, dword ptr [ecx + field_481d]        # 00494409
    cmp edx, dword ptr [ebp - local_48]          # 0049440f
    jae.d32 L_004944e4                           # 00494412
    # block 0x00494418: entered by fall-through of jae at 0x00494412, 3 instruction(s), ends with jle to 0x004944e4 (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494418
    cmp dword ptr [eax + field_47cd], 0x0        # 0049441b
    jle.d32 L_004944e4                           # 00494422
    # block 0x00494428: entered by fall-through of jle at 0x00494422, 43 instruction(s), falls into the block at 0x004944e4
    mov ecx, dword ptr [ebp - local_60]          # 00494428
    mov edx, dword ptr [ebp - local_60]          # 0049442b
    mov eax, dword ptr [ecx + field_47bd]        # 0049442e
    sub eax, dword ptr [edx + field_47c5]        # 00494434
    mov ecx, dword ptr [ebp - local_60]          # 0049443a
    mov dword ptr [ecx + field_47bd], eax        # 0049443d
    mov edx, dword ptr [ebp - local_60]          # 00494443
    mov eax, dword ptr [edx + field_47bd]        # 00494446
    sar eax, 0x10                                # 0049444c
    mov ecx, dword ptr [ebp - local_60]          # 0049444f
    mov dword ptr [ecx + field_47b5], eax        # 00494452
    mov edx, dword ptr [ebp - local_60]          # 00494458
    mov eax, dword ptr [ebp - local_60]          # 0049445b
    mov ecx, dword ptr [edx + field_47c1]        # 0049445e
    sub ecx, dword ptr [eax + field_47c9]        # 00494464
    mov edx, dword ptr [ebp - local_60]          # 0049446a
    mov dword ptr [edx + field_47c1], ecx        # 0049446d
    mov eax, dword ptr [ebp - local_60]          # 00494473
    mov ecx, dword ptr [eax + field_47c1]        # 00494476
    sar ecx, 0x10                                # 0049447c
    mov edx, dword ptr [ebp - local_60]          # 0049447f
    mov dword ptr [edx + field_47b9], ecx        # 00494482
    mov eax, dword ptr [ebp - local_60]          # 00494488
    mov ecx, dword ptr [eax + field_1ef7]        # 0049448b
    mov edx, dword ptr [ebp - local_60]          # 00494491
    add ecx, dword ptr [edx + field_47b5]        # 00494494
    mov dword ptr [ebp - local_4], ecx           # 0049449a
    mov eax, dword ptr [ebp - local_60]          # 0049449d
    mov ecx, dword ptr [eax + field_1efb]        # 004944a0
    mov edx, dword ptr [ebp - local_60]          # 004944a6
    add ecx, dword ptr [edx + field_47b9]        # 004944a9
    mov dword ptr [ebp - local_34], ecx          # 004944af
    mov dword ptr [ebp - local_5c], 0x1          # 004944b2
    mov eax, dword ptr [ebp - local_48]          # 004944b9
    add eax, 0x28                                # 004944bc
    mov ecx, dword ptr [ebp - local_60]          # 004944bf
    mov dword ptr [ecx + field_481d], eax        # 004944c2
    mov dword ptr [ebp - local_58], 0x1          # 004944c8
    mov edx, dword ptr [ebp - local_60]          # 004944cf
    mov eax, dword ptr [edx + field_47cd]        # 004944d2
    sub eax, 0x1                                 # 004944d8
    mov ecx, dword ptr [ebp - local_60]          # 004944db
    mov dword ptr [ecx + field_47cd], eax        # 004944de
L_004944e4:
    # block 0x004944e4: entered by jmp at 0x004940a9; jmp at 0x0049413a; jmp at 0x004941b6; jmp at 0x00494232; more, 2 instruction(s), ends with je to 0x0049483e (forward)
    cmp dword ptr [ebp - local_5c], 0x0          # 004944e4
    je.d32 L_0049483e                            # 004944e8
    # block 0x004944ee: entered by fall-through of je at 0x004944e8, 4 instruction(s), ends with jle to 0x00494507 (forward)
    mov edx, dword ptr [ebp - local_60]          # 004944ee
    mov eax, dword ptr [ebp - local_4]           # 004944f1
    cmp eax, dword ptr [edx + field_480d]        # 004944f4
    jle.d8 L_00494507                            # 004944fa
    # block 0x004944fc: entered by fall-through of jle at 0x004944fa, 3 instruction(s), ends with forward jump to 0x00494516
    mov ecx, dword ptr [ebp - local_4]           # 004944fc
    mov dword ptr [ebp - local_a0], ecx          # 004944ff
    jmp.d8 L_00494516                            # 00494505
L_00494507:
    # block 0x00494507: entered by jle at 0x004944fa, 3 instruction(s), falls into the block at 0x00494516
    mov edx, dword ptr [ebp - local_60]          # 00494507
    mov eax, dword ptr [edx + field_480d]        # 0049450a
    mov dword ptr [ebp - local_a0], eax          # 00494510
L_00494516:
    # block 0x00494516: entered by jmp at 0x00494505, 6 instruction(s), ends with jge to 0x00494538 (forward)
    mov ecx, dword ptr [ebp - local_a0]          # 00494516
    mov dword ptr [ebp - local_4], ecx           # 0049451c
    mov edx, dword ptr [ebp - local_60]          # 0049451f
    mov eax, dword ptr [ebp - local_4]           # 00494522
    cmp eax, dword ptr [edx + field_4805]        # 00494525
    jge.d8 L_00494538                            # 0049452b
    # block 0x0049452d: entered by fall-through of jge at 0x0049452b, 3 instruction(s), ends with forward jump to 0x00494547
    mov ecx, dword ptr [ebp - local_4]           # 0049452d
    mov dword ptr [ebp - local_a4], ecx          # 00494530
    jmp.d8 L_00494547                            # 00494536
L_00494538:
    # block 0x00494538: entered by jge at 0x0049452b, 3 instruction(s), falls into the block at 0x00494547
    mov edx, dword ptr [ebp - local_60]          # 00494538
    mov eax, dword ptr [edx + field_4805]        # 0049453b
    mov dword ptr [ebp - local_a4], eax          # 00494541
L_00494547:
    # block 0x00494547: entered by jmp at 0x00494536, 6 instruction(s), ends with jle to 0x00494569 (forward)
    mov ecx, dword ptr [ebp - local_a4]          # 00494547
    mov dword ptr [ebp - local_4], ecx           # 0049454d
    mov edx, dword ptr [ebp - local_60]          # 00494550
    mov eax, dword ptr [ebp - local_34]          # 00494553
    cmp eax, dword ptr [edx + field_4811]        # 00494556
    jle.d8 L_00494569                            # 0049455c
    # block 0x0049455e: entered by fall-through of jle at 0x0049455c, 3 instruction(s), ends with forward jump to 0x00494578
    mov ecx, dword ptr [ebp - local_34]          # 0049455e
    mov dword ptr [ebp - local_a8], ecx          # 00494561
    jmp.d8 L_00494578                            # 00494567
L_00494569:
    # block 0x00494569: entered by jle at 0x0049455c, 3 instruction(s), falls into the block at 0x00494578
    mov edx, dword ptr [ebp - local_60]          # 00494569
    mov eax, dword ptr [edx + field_4811]        # 0049456c
    mov dword ptr [ebp - local_a8], eax          # 00494572
L_00494578:
    # block 0x00494578: entered by jmp at 0x00494567, 6 instruction(s), ends with jge to 0x0049459a (forward)
    mov ecx, dword ptr [ebp - local_a8]          # 00494578
    mov dword ptr [ebp - local_34], ecx          # 0049457e
    mov edx, dword ptr [ebp - local_60]          # 00494581
    mov eax, dword ptr [ebp - local_34]          # 00494584
    cmp eax, dword ptr [edx + field_4809]        # 00494587
    jge.d8 L_0049459a                            # 0049458d
    # block 0x0049458f: entered by fall-through of jge at 0x0049458d, 3 instruction(s), ends with forward jump to 0x004945a9
    mov ecx, dword ptr [ebp - local_34]          # 0049458f
    mov dword ptr [ebp - local_ac], ecx          # 00494592
    jmp.d8 L_004945a9                            # 00494598
L_0049459a:
    # block 0x0049459a: entered by jge at 0x0049458d, 3 instruction(s), falls into the block at 0x004945a9
    mov edx, dword ptr [ebp - local_60]          # 0049459a
    mov eax, dword ptr [edx + field_4809]        # 0049459d
    mov dword ptr [ebp - local_ac], eax          # 004945a3
L_004945a9:
    # block 0x004945a9: entered by jmp at 0x00494598, 21 instruction(s), ends with jne to 0x0049483e (forward)
    mov ecx, dword ptr [ebp - local_ac]          # 004945a9
    mov dword ptr [ebp - local_34], ecx          # 004945af
    mov edx, dword ptr [ebp - local_60]          # 004945b2
    mov eax, dword ptr [ebp - local_4]           # 004945b5
    mov ecx, dword ptr [edx + field_47d1]        # 004945b8
    sar eax, cl                                  # 004945be
    mov dword ptr [ebp - local_18], eax          # 004945c0
    mov ecx, dword ptr [ebp - local_60]          # 004945c3
    mov edx, dword ptr [ebp - local_34]          # 004945c6
    mov ecx, dword ptr [ecx + field_47d1]        # 004945c9
    sar edx, cl                                  # 004945cf
    mov dword ptr [ebp - local_44], edx          # 004945d1
    mov eax, dword ptr [ebp - local_4]           # 004945d4
    and eax, 0x7f                                # 004945d7
    mov dword ptr [ebp - local_24], eax          # 004945da
    mov ecx, dword ptr [ebp - local_34]          # 004945dd
    and ecx, 0x7f                                # 004945e0
    mov dword ptr [ebp - local_10], ecx          # 004945e3
    mov edx, dword ptr [ebp - local_60]          # 004945e6
    cmp dword ptr [edx + field_1f43], 0x0        # 004945e9
    jne.d32 L_0049483e                           # 004945f0
    # block 0x004945f6: entered by fall-through of jne at 0x004945f0, 74 instruction(s), ends with je to 0x00494711 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004945f6
    imul eax, eax, 0xa6                          # 004945f9
    mov ecx, dword ptr [ebp - local_60]          # 004945ff
    mov edx, dword ptr [ecx + field_1f47]        # 00494602
    lea eax, [edx + 4*eax]                       # 00494608
    mov ecx, dword ptr [ebp - local_44]          # 0049460b
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049460e
    mov dword ptr [ebp - local_20], edx          # 00494612
    mov eax, dword ptr [ebp - local_18]          # 00494615
    sub eax, 0x1                                 # 00494618
    imul eax, eax, 0xa6                          # 0049461b
    mov ecx, dword ptr [ebp - local_60]          # 00494621
    mov edx, dword ptr [ecx + field_1f47]        # 00494624
    lea eax, [edx + 4*eax]                       # 0049462a
    mov ecx, dword ptr [ebp - local_44]          # 0049462d
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 00494630
    mov dword ptr [ebp - local_30], edx          # 00494634
    mov eax, dword ptr [ebp - local_18]          # 00494637
    sub eax, 0x1                                 # 0049463a
    imul eax, eax, 0xa6                          # 0049463d
    mov ecx, dword ptr [ebp - local_60]          # 00494643
    mov edx, dword ptr [ecx + field_1f47]        # 00494646
    lea eax, [edx + 4*eax]                       # 0049464c
    mov ecx, dword ptr [ebp - local_44]          # 0049464f
    mov edx, dword ptr [eax + 4*ecx]             # 00494652
    mov dword ptr [ebp - local_2c], edx          # 00494655
    mov eax, dword ptr [ebp - local_18]          # 00494658
    sub eax, 0x1                                 # 0049465b
    imul eax, eax, 0xa6                          # 0049465e
    mov ecx, dword ptr [ebp - local_60]          # 00494664
    mov edx, dword ptr [ecx + field_1f47]        # 00494667
    lea eax, [edx + 4*eax]                       # 0049466d
    mov ecx, dword ptr [ebp - local_44]          # 00494670
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 00494673
    mov dword ptr [ebp - local_38], edx          # 00494677
    mov eax, dword ptr [ebp - local_18]          # 0049467a
    imul eax, eax, 0xa6                          # 0049467d
    mov ecx, dword ptr [ebp - local_60]          # 00494683
    mov edx, dword ptr [ecx + field_1f47]        # 00494686
    lea eax, [edx + 4*eax]                       # 0049468c
    mov ecx, dword ptr [ebp - local_44]          # 0049468f
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 00494692
    mov dword ptr [ebp - local_40], edx          # 00494696
    mov eax, dword ptr [ebp - local_18]          # 00494699
    add eax, 0x1                                 # 0049469c
    imul eax, eax, 0xa6                          # 0049469f
    mov ecx, dword ptr [ebp - local_60]          # 004946a5
    mov edx, dword ptr [ecx + field_1f47]        # 004946a8
    lea eax, [edx + 4*eax]                       # 004946ae
    mov ecx, dword ptr [ebp - local_44]          # 004946b1
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 004946b4
    mov dword ptr [ebp - local_4c], edx          # 004946b8
    mov eax, dword ptr [ebp - local_18]          # 004946bb
    add eax, 0x1                                 # 004946be
    imul eax, eax, 0xa6                          # 004946c1
    mov ecx, dword ptr [ebp - local_60]          # 004946c7
    mov edx, dword ptr [ecx + field_1f47]        # 004946ca
    lea eax, [edx + 4*eax]                       # 004946d0
    mov ecx, dword ptr [ebp - local_44]          # 004946d3
    mov edx, dword ptr [eax + 4*ecx]             # 004946d6
    mov dword ptr [ebp - local_54], edx          # 004946d9
    mov eax, dword ptr [ebp - local_18]          # 004946dc
    add eax, 0x1                                 # 004946df
    imul eax, eax, 0xa6                          # 004946e2
    mov ecx, dword ptr [ebp - local_60]          # 004946e8
    mov edx, dword ptr [ecx + field_1f47]        # 004946eb
    lea eax, [edx + 4*eax]                       # 004946f1
    mov ecx, dword ptr [ebp - local_44]          # 004946f4
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 004946f7
    mov dword ptr [ebp - local_c], edx           # 004946fb
    mov eax, dword ptr [ebp - local_20]          # 004946fe
    and eax, 0x8000000                           # 00494701
    test eax, eax                                # 00494706
    je.d8 L_00494711                             # 00494708
    # block 0x0049470a: entered by fall-through of je at 0x00494708, 1 instruction(s), falls into the block at 0x00494711
    mov dword ptr [ebp - local_20], 0x0          # 0049470a
L_00494711:
    # block 0x00494711: entered by je at 0x00494708, 4 instruction(s), ends with je to 0x00494725 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00494711
    and ecx, 0x8000000                           # 00494714
    test ecx, ecx                                # 0049471a
    je.d8 L_00494725                             # 0049471c
    # block 0x0049471e: entered by fall-through of je at 0x0049471c, 1 instruction(s), falls into the block at 0x00494725
    mov dword ptr [ebp - local_30], 0x0          # 0049471e
L_00494725:
    # block 0x00494725: entered by je at 0x0049471c, 4 instruction(s), ends with je to 0x00494739 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 00494725
    and edx, 0x8000000                           # 00494728
    test edx, edx                                # 0049472e
    je.d8 L_00494739                             # 00494730
    # block 0x00494732: entered by fall-through of je at 0x00494730, 1 instruction(s), falls into the block at 0x00494739
    mov dword ptr [ebp - local_2c], 0x0          # 00494732
L_00494739:
    # block 0x00494739: entered by je at 0x00494730, 4 instruction(s), ends with je to 0x0049474c (forward)
    mov eax, dword ptr [ebp - local_38]          # 00494739
    and eax, 0x8000000                           # 0049473c
    test eax, eax                                # 00494741
    je.d8 L_0049474c                             # 00494743
    # block 0x00494745: entered by fall-through of je at 0x00494743, 1 instruction(s), falls into the block at 0x0049474c
    mov dword ptr [ebp - local_38], 0x0          # 00494745
L_0049474c:
    # block 0x0049474c: entered by je at 0x00494743, 4 instruction(s), ends with je to 0x00494760 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 0049474c
    and ecx, 0x8000000                           # 0049474f
    test ecx, ecx                                # 00494755
    je.d8 L_00494760                             # 00494757
    # block 0x00494759: entered by fall-through of je at 0x00494757, 1 instruction(s), falls into the block at 0x00494760
    mov dword ptr [ebp - local_40], 0x0          # 00494759
L_00494760:
    # block 0x00494760: entered by je at 0x00494757, 4 instruction(s), ends with je to 0x00494774 (forward)
    mov edx, dword ptr [ebp - local_4c]          # 00494760
    and edx, 0x8000000                           # 00494763
    test edx, edx                                # 00494769
    je.d8 L_00494774                             # 0049476b
    # block 0x0049476d: entered by fall-through of je at 0x0049476b, 1 instruction(s), falls into the block at 0x00494774
    mov dword ptr [ebp - local_4c], 0x0          # 0049476d
L_00494774:
    # block 0x00494774: entered by je at 0x0049476b, 4 instruction(s), ends with je to 0x00494787 (forward)
    mov eax, dword ptr [ebp - local_54]          # 00494774
    and eax, 0x8000000                           # 00494777
    test eax, eax                                # 0049477c
    je.d8 L_00494787                             # 0049477e
    # block 0x00494780: entered by fall-through of je at 0x0049477e, 1 instruction(s), falls into the block at 0x00494787
    mov dword ptr [ebp - local_54], 0x0          # 00494780
L_00494787:
    # block 0x00494787: entered by je at 0x0049477e, 4 instruction(s), ends with je to 0x0049479b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00494787
    and ecx, 0x8000000                           # 0049478a
    test ecx, ecx                                # 00494790
    je.d8 L_0049479b                             # 00494792
    # block 0x00494794: entered by fall-through of je at 0x00494792, 1 instruction(s), falls into the block at 0x0049479b
    mov dword ptr [ebp - local_c], 0x0           # 00494794
L_0049479b:
    # block 0x0049479b: entered by je at 0x00494792, 2 instruction(s), ends with je to 0x004947c4 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 0049479b
    je.d8 L_004947c4                             # 0049479f
    # block 0x004947a1: entered by fall-through of je at 0x0049479f, 4 instruction(s), ends with jle to 0x004947c4 (forward)
    mov edx, dword ptr [ebp - local_60]          # 004947a1
    mov eax, dword ptr [ebp - local_10]          # 004947a4
    cmp eax, dword ptr [edx + field_47f9]        # 004947a7
    jle.d8 L_004947c4                            # 004947ad
    # block 0x004947af: entered by fall-through of jle at 0x004947ad, 5 instruction(s), falls into the block at 0x004947c4
    mov ecx, dword ptr [ebp - local_34]          # 004947af
    and ecx, 0xff80                              # 004947b2
    mov edx, dword ptr [ebp - local_60]          # 004947b8
    add ecx, dword ptr [edx + field_47f9]        # 004947bb
    mov dword ptr [ebp - local_34], ecx          # 004947c1
L_004947c4:
    # block 0x004947c4: entered by je at 0x0049479f; jle at 0x004947ad, 2 instruction(s), ends with je to 0x004947ed (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 004947c4
    je.d8 L_004947ed                             # 004947c8
    # block 0x004947ca: entered by fall-through of je at 0x004947c8, 4 instruction(s), ends with jge to 0x004947ed (forward)
    mov eax, dword ptr [ebp - local_60]          # 004947ca
    mov ecx, dword ptr [ebp - local_10]          # 004947cd
    cmp ecx, dword ptr [eax + field_47f5]        # 004947d0
    jge.d8 L_004947ed                            # 004947d6
    # block 0x004947d8: entered by fall-through of jge at 0x004947d6, 5 instruction(s), falls into the block at 0x004947ed
    mov edx, dword ptr [ebp - local_34]          # 004947d8
    and edx, 0xff80                              # 004947db
    mov eax, dword ptr [ebp - local_60]          # 004947e1
    add edx, dword ptr [eax + field_47f5]        # 004947e4
    mov dword ptr [ebp - local_34], edx          # 004947ea
L_004947ed:
    # block 0x004947ed: entered by je at 0x004947c8; jge at 0x004947d6, 2 instruction(s), ends with je to 0x00494815 (forward)
    cmp dword ptr [ebp - local_2c], 0x0          # 004947ed
    je.d8 L_00494815                             # 004947f1
    # block 0x004947f3: entered by fall-through of je at 0x004947f1, 4 instruction(s), ends with jge to 0x00494815 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004947f3
    mov edx, dword ptr [ebp - local_24]          # 004947f6
    cmp edx, dword ptr [ecx + field_47f5]        # 004947f9
    jge.d8 L_00494815                            # 004947ff
    # block 0x00494801: entered by fall-through of jge at 0x004947ff, 5 instruction(s), falls into the block at 0x00494815
    mov eax, dword ptr [ebp - local_4]           # 00494801
    and eax, 0xff80                              # 00494804
    mov ecx, dword ptr [ebp - local_60]          # 00494809
    add eax, dword ptr [ecx + field_47f5]        # 0049480c
    mov dword ptr [ebp - local_4], eax           # 00494812
L_00494815:
    # block 0x00494815: entered by je at 0x004947f1; jge at 0x004947ff, 2 instruction(s), ends with je to 0x0049483e (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 00494815
    je.d8 L_0049483e                             # 00494819
    # block 0x0049481b: entered by fall-through of je at 0x00494819, 4 instruction(s), ends with jle to 0x0049483e (forward)
    mov edx, dword ptr [ebp - local_60]          # 0049481b
    mov eax, dword ptr [ebp - local_24]          # 0049481e
    cmp eax, dword ptr [edx + field_47f9]        # 00494821
    jle.d8 L_0049483e                            # 00494827
    # block 0x00494829: entered by fall-through of jle at 0x00494827, 5 instruction(s), falls into the block at 0x0049483e
    mov ecx, dword ptr [ebp - local_4]           # 00494829
    and ecx, 0xff80                              # 0049482c
    mov edx, dword ptr [ebp - local_60]          # 00494832
    add ecx, dword ptr [edx + field_47f9]        # 00494835
    mov dword ptr [ebp - local_4], ecx           # 0049483b
L_0049483e:
    # block 0x0049483e: entered by je at 0x004944e8; jne at 0x004945f0; je at 0x00494819; jle at 0x00494827, 2 instruction(s), ends with je to 0x00494bb6 (forward)
    cmp dword ptr [ebp - local_5c], 0x0          # 0049483e
    je.d32 L_00494bb6                            # 00494842
    # block 0x00494848: entered by fall-through of je at 0x00494842, 4 instruction(s), ends with jle to 0x00494861 (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494848
    mov ecx, dword ptr [ebp - local_4]           # 0049484b
    cmp ecx, dword ptr [eax + field_480d]        # 0049484e
    jle.d8 L_00494861                            # 00494854
    # block 0x00494856: entered by fall-through of jle at 0x00494854, 3 instruction(s), ends with forward jump to 0x00494870
    mov edx, dword ptr [ebp - local_4]           # 00494856
    mov dword ptr [ebp - local_b0], edx          # 00494859
    jmp.d8 L_00494870                            # 0049485f
L_00494861:
    # block 0x00494861: entered by jle at 0x00494854, 3 instruction(s), falls into the block at 0x00494870
    mov eax, dword ptr [ebp - local_60]          # 00494861
    mov ecx, dword ptr [eax + field_480d]        # 00494864
    mov dword ptr [ebp - local_b0], ecx          # 0049486a
L_00494870:
    # block 0x00494870: entered by jmp at 0x0049485f, 6 instruction(s), ends with jge to 0x00494892 (forward)
    mov edx, dword ptr [ebp - local_b0]          # 00494870
    mov dword ptr [ebp - local_4], edx           # 00494876
    mov eax, dword ptr [ebp - local_60]          # 00494879
    mov ecx, dword ptr [ebp - local_4]           # 0049487c
    cmp ecx, dword ptr [eax + field_4805]        # 0049487f
    jge.d8 L_00494892                            # 00494885
    # block 0x00494887: entered by fall-through of jge at 0x00494885, 3 instruction(s), ends with forward jump to 0x004948a1
    mov edx, dword ptr [ebp - local_4]           # 00494887
    mov dword ptr [ebp - local_b4], edx          # 0049488a
    jmp.d8 L_004948a1                            # 00494890
L_00494892:
    # block 0x00494892: entered by jge at 0x00494885, 3 instruction(s), falls into the block at 0x004948a1
    mov eax, dword ptr [ebp - local_60]          # 00494892
    mov ecx, dword ptr [eax + field_4805]        # 00494895
    mov dword ptr [ebp - local_b4], ecx          # 0049489b
L_004948a1:
    # block 0x004948a1: entered by jmp at 0x00494890, 6 instruction(s), ends with jle to 0x004948c3 (forward)
    mov edx, dword ptr [ebp - local_b4]          # 004948a1
    mov dword ptr [ebp - local_4], edx           # 004948a7
    mov eax, dword ptr [ebp - local_60]          # 004948aa
    mov ecx, dword ptr [ebp - local_34]          # 004948ad
    cmp ecx, dword ptr [eax + field_4811]        # 004948b0
    jle.d8 L_004948c3                            # 004948b6
    # block 0x004948b8: entered by fall-through of jle at 0x004948b6, 3 instruction(s), ends with forward jump to 0x004948d2
    mov edx, dword ptr [ebp - local_34]          # 004948b8
    mov dword ptr [ebp - local_b8], edx          # 004948bb
    jmp.d8 L_004948d2                            # 004948c1
L_004948c3:
    # block 0x004948c3: entered by jle at 0x004948b6, 3 instruction(s), falls into the block at 0x004948d2
    mov eax, dword ptr [ebp - local_60]          # 004948c3
    mov ecx, dword ptr [eax + field_4811]        # 004948c6
    mov dword ptr [ebp - local_b8], ecx          # 004948cc
L_004948d2:
    # block 0x004948d2: entered by jmp at 0x004948c1, 6 instruction(s), ends with jge to 0x004948f4 (forward)
    mov edx, dword ptr [ebp - local_b8]          # 004948d2
    mov dword ptr [ebp - local_34], edx          # 004948d8
    mov eax, dword ptr [ebp - local_60]          # 004948db
    mov ecx, dword ptr [ebp - local_34]          # 004948de
    cmp ecx, dword ptr [eax + field_4809]        # 004948e1
    jge.d8 L_004948f4                            # 004948e7
    # block 0x004948e9: entered by fall-through of jge at 0x004948e7, 3 instruction(s), ends with forward jump to 0x00494903
    mov edx, dword ptr [ebp - local_34]          # 004948e9
    mov dword ptr [ebp - local_bc], edx          # 004948ec
    jmp.d8 L_00494903                            # 004948f2
L_004948f4:
    # block 0x004948f4: entered by jge at 0x004948e7, 3 instruction(s), falls into the block at 0x00494903
    mov eax, dword ptr [ebp - local_60]          # 004948f4
    mov ecx, dword ptr [eax + field_4809]        # 004948f7
    mov dword ptr [ebp - local_bc], ecx          # 004948fd
L_00494903:
    # block 0x00494903: entered by jmp at 0x004948f2, 21 instruction(s), ends with jne to 0x00494bb6 (forward)
    mov edx, dword ptr [ebp - local_bc]          # 00494903
    mov dword ptr [ebp - local_34], edx          # 00494909
    mov eax, dword ptr [ebp - local_60]          # 0049490c
    mov edx, dword ptr [ebp - local_4]           # 0049490f
    mov ecx, dword ptr [eax + field_47d1]        # 00494912
    sar edx, cl                                  # 00494918
    mov dword ptr [ebp - local_18], edx          # 0049491a
    mov eax, dword ptr [ebp - local_60]          # 0049491d
    mov edx, dword ptr [ebp - local_34]          # 00494920
    mov ecx, dword ptr [eax + field_47d1]        # 00494923
    sar edx, cl                                  # 00494929
    mov dword ptr [ebp - local_44], edx          # 0049492b
    mov eax, dword ptr [ebp - local_4]           # 0049492e
    and eax, 0x7f                                # 00494931
    mov dword ptr [ebp - local_24], eax          # 00494934
    mov ecx, dword ptr [ebp - local_34]          # 00494937
    and ecx, 0x7f                                # 0049493a
    mov dword ptr [ebp - local_10], ecx          # 0049493d
    mov edx, dword ptr [ebp - local_60]          # 00494940
    cmp dword ptr [edx + field_1f43], 0x0        # 00494943
    jne.d32 L_00494bb6                           # 0049494a
    # block 0x00494950: entered by fall-through of jne at 0x0049494a, 74 instruction(s), ends with je to 0x00494a6b (forward)
    mov eax, dword ptr [ebp - local_18]          # 00494950
    imul eax, eax, 0xa6                          # 00494953
    mov ecx, dword ptr [ebp - local_60]          # 00494959
    mov edx, dword ptr [ecx + field_1f47]        # 0049495c
    lea eax, [edx + 4*eax]                       # 00494962
    mov ecx, dword ptr [ebp - local_44]          # 00494965
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 00494968
    mov dword ptr [ebp - local_20], edx          # 0049496c
    mov eax, dword ptr [ebp - local_18]          # 0049496f
    sub eax, 0x1                                 # 00494972
    imul eax, eax, 0xa6                          # 00494975
    mov ecx, dword ptr [ebp - local_60]          # 0049497b
    mov edx, dword ptr [ecx + field_1f47]        # 0049497e
    lea eax, [edx + 4*eax]                       # 00494984
    mov ecx, dword ptr [ebp - local_44]          # 00494987
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049498a
    mov dword ptr [ebp - local_30], edx          # 0049498e
    mov eax, dword ptr [ebp - local_18]          # 00494991
    sub eax, 0x1                                 # 00494994
    imul eax, eax, 0xa6                          # 00494997
    mov ecx, dword ptr [ebp - local_60]          # 0049499d
    mov edx, dword ptr [ecx + field_1f47]        # 004949a0
    lea eax, [edx + 4*eax]                       # 004949a6
    mov ecx, dword ptr [ebp - local_44]          # 004949a9
    mov edx, dword ptr [eax + 4*ecx]             # 004949ac
    mov dword ptr [ebp - local_2c], edx          # 004949af
    mov eax, dword ptr [ebp - local_18]          # 004949b2
    sub eax, 0x1                                 # 004949b5
    imul eax, eax, 0xa6                          # 004949b8
    mov ecx, dword ptr [ebp - local_60]          # 004949be
    mov edx, dword ptr [ecx + field_1f47]        # 004949c1
    lea eax, [edx + 4*eax]                       # 004949c7
    mov ecx, dword ptr [ebp - local_44]          # 004949ca
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 004949cd
    mov dword ptr [ebp - local_38], edx          # 004949d1
    mov eax, dword ptr [ebp - local_18]          # 004949d4
    imul eax, eax, 0xa6                          # 004949d7
    mov ecx, dword ptr [ebp - local_60]          # 004949dd
    mov edx, dword ptr [ecx + field_1f47]        # 004949e0
    lea eax, [edx + 4*eax]                       # 004949e6
    mov ecx, dword ptr [ebp - local_44]          # 004949e9
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 004949ec
    mov dword ptr [ebp - local_40], edx          # 004949f0
    mov eax, dword ptr [ebp - local_18]          # 004949f3
    add eax, 0x1                                 # 004949f6
    imul eax, eax, 0xa6                          # 004949f9
    mov ecx, dword ptr [ebp - local_60]          # 004949ff
    mov edx, dword ptr [ecx + field_1f47]        # 00494a02
    lea eax, [edx + 4*eax]                       # 00494a08
    mov ecx, dword ptr [ebp - local_44]          # 00494a0b
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 00494a0e
    mov dword ptr [ebp - local_4c], edx          # 00494a12
    mov eax, dword ptr [ebp - local_18]          # 00494a15
    add eax, 0x1                                 # 00494a18
    imul eax, eax, 0xa6                          # 00494a1b
    mov ecx, dword ptr [ebp - local_60]          # 00494a21
    mov edx, dword ptr [ecx + field_1f47]        # 00494a24
    lea eax, [edx + 4*eax]                       # 00494a2a
    mov ecx, dword ptr [ebp - local_44]          # 00494a2d
    mov edx, dword ptr [eax + 4*ecx]             # 00494a30
    mov dword ptr [ebp - local_54], edx          # 00494a33
    mov eax, dword ptr [ebp - local_18]          # 00494a36
    add eax, 0x1                                 # 00494a39
    imul eax, eax, 0xa6                          # 00494a3c
    mov ecx, dword ptr [ebp - local_60]          # 00494a42
    mov edx, dword ptr [ecx + field_1f47]        # 00494a45
    lea eax, [edx + 4*eax]                       # 00494a4b
    mov ecx, dword ptr [ebp - local_44]          # 00494a4e
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 00494a51
    mov dword ptr [ebp - local_c], edx           # 00494a55
    mov eax, dword ptr [ebp - local_20]          # 00494a58
    and eax, 0x8000000                           # 00494a5b
    test eax, eax                                # 00494a60
    je.d8 L_00494a6b                             # 00494a62
    # block 0x00494a64: entered by fall-through of je at 0x00494a62, 1 instruction(s), falls into the block at 0x00494a6b
    mov dword ptr [ebp - local_20], 0x0          # 00494a64
L_00494a6b:
    # block 0x00494a6b: entered by je at 0x00494a62, 4 instruction(s), ends with je to 0x00494a7f (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00494a6b
    and ecx, 0x8000000                           # 00494a6e
    test ecx, ecx                                # 00494a74
    je.d8 L_00494a7f                             # 00494a76
    # block 0x00494a78: entered by fall-through of je at 0x00494a76, 1 instruction(s), falls into the block at 0x00494a7f
    mov dword ptr [ebp - local_30], 0x0          # 00494a78
L_00494a7f:
    # block 0x00494a7f: entered by je at 0x00494a76, 4 instruction(s), ends with je to 0x00494a93 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 00494a7f
    and edx, 0x8000000                           # 00494a82
    test edx, edx                                # 00494a88
    je.d8 L_00494a93                             # 00494a8a
    # block 0x00494a8c: entered by fall-through of je at 0x00494a8a, 1 instruction(s), falls into the block at 0x00494a93
    mov dword ptr [ebp - local_2c], 0x0          # 00494a8c
L_00494a93:
    # block 0x00494a93: entered by je at 0x00494a8a, 4 instruction(s), ends with je to 0x00494aa6 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00494a93
    and eax, 0x8000000                           # 00494a96
    test eax, eax                                # 00494a9b
    je.d8 L_00494aa6                             # 00494a9d
    # block 0x00494a9f: entered by fall-through of je at 0x00494a9d, 1 instruction(s), falls into the block at 0x00494aa6
    mov dword ptr [ebp - local_38], 0x0          # 00494a9f
L_00494aa6:
    # block 0x00494aa6: entered by je at 0x00494a9d, 4 instruction(s), ends with je to 0x00494aba (forward)
    mov ecx, dword ptr [ebp - local_40]          # 00494aa6
    and ecx, 0x8000000                           # 00494aa9
    test ecx, ecx                                # 00494aaf
    je.d8 L_00494aba                             # 00494ab1
    # block 0x00494ab3: entered by fall-through of je at 0x00494ab1, 1 instruction(s), falls into the block at 0x00494aba
    mov dword ptr [ebp - local_40], 0x0          # 00494ab3
L_00494aba:
    # block 0x00494aba: entered by je at 0x00494ab1, 4 instruction(s), ends with je to 0x00494ace (forward)
    mov edx, dword ptr [ebp - local_4c]          # 00494aba
    and edx, 0x8000000                           # 00494abd
    test edx, edx                                # 00494ac3
    je.d8 L_00494ace                             # 00494ac5
    # block 0x00494ac7: entered by fall-through of je at 0x00494ac5, 1 instruction(s), falls into the block at 0x00494ace
    mov dword ptr [ebp - local_4c], 0x0          # 00494ac7
L_00494ace:
    # block 0x00494ace: entered by je at 0x00494ac5, 4 instruction(s), ends with je to 0x00494ae1 (forward)
    mov eax, dword ptr [ebp - local_54]          # 00494ace
    and eax, 0x8000000                           # 00494ad1
    test eax, eax                                # 00494ad6
    je.d8 L_00494ae1                             # 00494ad8
    # block 0x00494ada: entered by fall-through of je at 0x00494ad8, 1 instruction(s), falls into the block at 0x00494ae1
    mov dword ptr [ebp - local_54], 0x0          # 00494ada
L_00494ae1:
    # block 0x00494ae1: entered by je at 0x00494ad8, 4 instruction(s), ends with je to 0x00494af5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00494ae1
    and ecx, 0x8000000                           # 00494ae4
    test ecx, ecx                                # 00494aea
    je.d8 L_00494af5                             # 00494aec
    # block 0x00494aee: entered by fall-through of je at 0x00494aec, 1 instruction(s), falls into the block at 0x00494af5
    mov dword ptr [ebp - local_c], 0x0           # 00494aee
L_00494af5:
    # block 0x00494af5: entered by je at 0x00494aec, 2 instruction(s), ends with je to 0x00494b27 (forward)
    cmp dword ptr [ebp - local_30], 0x0          # 00494af5
    je.d8 L_00494b27                             # 00494af9
    # block 0x00494afb: entered by fall-through of je at 0x00494af9, 2 instruction(s), ends with jne to 0x00494b27 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 00494afb
    jne.d8 L_00494b27                            # 00494aff
    # block 0x00494b01: entered by fall-through of jne at 0x00494aff, 2 instruction(s), ends with jne to 0x00494b27 (forward)
    cmp dword ptr [ebp - local_2c], 0x0          # 00494b01
    jne.d8 L_00494b27                            # 00494b05
    # block 0x00494b07: entered by fall-through of jne at 0x00494b05, 4 instruction(s), ends with jle to 0x00494b27 (forward)
    mov edx, dword ptr [ebp - local_60]          # 00494b07
    mov eax, dword ptr [ebp - local_10]          # 00494b0a
    cmp eax, dword ptr [edx + field_4801]        # 00494b0d
    jle.d8 L_00494b27                            # 00494b13
    # block 0x00494b15: entered by fall-through of jle at 0x00494b13, 4 instruction(s), ends with jl to 0x00494bb1 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00494b15
    mov edx, dword ptr [ebp - local_24]          # 00494b18
    cmp edx, dword ptr [ecx + field_47fd]        # 00494b1b
    jl.d32 L_00494bb1                            # 00494b21
L_00494b27:
    # block 0x00494b27: entered by je at 0x00494af9; jne at 0x00494aff; jne at 0x00494b05; jle at 0x00494b13; more, 2 instruction(s), ends with je to 0x00494b55 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00494b27
    je.d8 L_00494b55                             # 00494b2b
    # block 0x00494b2d: entered by fall-through of je at 0x00494b2b, 2 instruction(s), ends with jne to 0x00494b55 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 00494b2d
    jne.d8 L_00494b55                            # 00494b31
    # block 0x00494b33: entered by fall-through of jne at 0x00494b31, 2 instruction(s), ends with jne to 0x00494b55 (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 00494b33
    jne.d8 L_00494b55                            # 00494b37
    # block 0x00494b39: entered by fall-through of jne at 0x00494b37, 4 instruction(s), ends with jle to 0x00494b55 (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494b39
    mov ecx, dword ptr [ebp - local_10]          # 00494b3c
    cmp ecx, dword ptr [eax + field_4801]        # 00494b3f
    jle.d8 L_00494b55                            # 00494b45
    # block 0x00494b47: entered by fall-through of jle at 0x00494b45, 4 instruction(s), ends with jg to 0x00494bb1 (forward)
    mov edx, dword ptr [ebp - local_60]          # 00494b47
    mov eax, dword ptr [ebp - local_24]          # 00494b4a
    cmp eax, dword ptr [edx + field_4801]        # 00494b4d
    jg.d8 L_00494bb1                             # 00494b53
L_00494b55:
    # block 0x00494b55: entered by je at 0x00494b2b; jne at 0x00494b31; jne at 0x00494b37; jle at 0x00494b45; more, 2 instruction(s), ends with je to 0x00494b83 (forward)
    cmp dword ptr [ebp - local_38], 0x0          # 00494b55
    je.d8 L_00494b83                             # 00494b59
    # block 0x00494b5b: entered by fall-through of je at 0x00494b59, 2 instruction(s), ends with jne to 0x00494b83 (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 00494b5b
    jne.d8 L_00494b83                            # 00494b5f
    # block 0x00494b61: entered by fall-through of jne at 0x00494b5f, 2 instruction(s), ends with jne to 0x00494b83 (forward)
    cmp dword ptr [ebp - local_2c], 0x0          # 00494b61
    jne.d8 L_00494b83                            # 00494b65
    # block 0x00494b67: entered by fall-through of jne at 0x00494b65, 4 instruction(s), ends with jge to 0x00494b83 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00494b67
    mov edx, dword ptr [ebp - local_10]          # 00494b6a
    cmp edx, dword ptr [ecx + field_47fd]        # 00494b6d
    jge.d8 L_00494b83                            # 00494b73
    # block 0x00494b75: entered by fall-through of jge at 0x00494b73, 4 instruction(s), ends with jl to 0x00494bb1 (forward)
    mov eax, dword ptr [ebp - local_60]          # 00494b75
    mov ecx, dword ptr [ebp - local_24]          # 00494b78
    cmp ecx, dword ptr [eax + field_47fd]        # 00494b7b
    jl.d8 L_00494bb1                             # 00494b81
L_00494b83:
    # block 0x00494b83: entered by je at 0x00494b59; jne at 0x00494b5f; jne at 0x00494b65; jge at 0x00494b73; more, 2 instruction(s), ends with je to 0x00494bb6 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 00494b83
    je.d8 L_00494bb6                             # 00494b87
    # block 0x00494b89: entered by fall-through of je at 0x00494b87, 2 instruction(s), ends with jne to 0x00494bb6 (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 00494b89
    jne.d8 L_00494bb6                            # 00494b8d
    # block 0x00494b8f: entered by fall-through of jne at 0x00494b8d, 2 instruction(s), ends with jne to 0x00494bb6 (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 00494b8f
    jne.d8 L_00494bb6                            # 00494b93
    # block 0x00494b95: entered by fall-through of jne at 0x00494b93, 4 instruction(s), ends with jge to 0x00494bb6 (forward)
    mov edx, dword ptr [ebp - local_60]          # 00494b95
    mov eax, dword ptr [ebp - local_10]          # 00494b98
    cmp eax, dword ptr [edx + field_47fd]        # 00494b9b
    jge.d8 L_00494bb6                            # 00494ba1
    # block 0x00494ba3: entered by fall-through of jge at 0x00494ba1, 4 instruction(s), ends with jle to 0x00494bb6 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 00494ba3
    mov edx, dword ptr [ebp - local_24]          # 00494ba6
    cmp edx, dword ptr [ecx + field_4801]        # 00494ba9
    jle.d8 L_00494bb6                            # 00494baf
L_00494bb1:
    # block 0x00494bb1: entered by jl at 0x00494b21; jg at 0x00494b53; jl at 0x00494b81; fall-through of jle at 0x00494baf, 1 instruction(s), ends with forward jump to 0x00494cb8
    jmp.d32 L_00494cb8                           # 00494bb1
L_00494bb6:
    # block 0x00494bb6: entered by je at 0x00494842; jne at 0x0049494a; je at 0x00494b87; jne at 0x00494b8d; more, 2 instruction(s), ends with je to 0x00494cb8 (forward)
    cmp dword ptr [ebp - local_5c], 0x0          # 00494bb6
    je.d32 L_00494cb8                            # 00494bba
    # block 0x00494bc0: entered by fall-through of je at 0x00494bba, 2 instruction(s), ends with jne to 0x00494c98 (forward)
    cmp dword ptr [ebp - local_58], 0x0          # 00494bc0
    jne.d32 L_00494c98                           # 00494bc4
    # block 0x00494bca: entered by fall-through of jne at 0x00494bc4, 44 instruction(s), calls FUN_0050ce04, falls into the block at 0x00494c98
    mov eax, dword ptr [ebp - local_60]          # 00494bca
    mov ecx, dword ptr [ebp - local_4]           # 00494bcd
    sub ecx, dword ptr [eax + field_1ef7]        # 00494bd0
    mov edx, dword ptr [ebp - local_60]          # 00494bd6
    mov dword ptr [edx + field_47b5], ecx        # 00494bd9
    mov eax, dword ptr [ebp - local_60]          # 00494bdf
    mov ecx, dword ptr [ebp - local_34]          # 00494be2
    sub ecx, dword ptr [eax + field_1efb]        # 00494be5
    mov edx, dword ptr [ebp - local_60]          # 00494beb
    mov dword ptr [edx + field_47b9], ecx        # 00494bee
    mov eax, dword ptr [ebp - local_60]          # 00494bf4
    mov ecx, dword ptr [eax + field_47b5]        # 00494bf7
    shl ecx, 0x10                                # 00494bfd
    mov edx, dword ptr [ebp - local_60]          # 00494c00
    mov dword ptr [edx + field_47bd], ecx        # 00494c03
    mov eax, dword ptr [ebp - local_60]          # 00494c09
    mov ecx, dword ptr [eax + field_47b9]        # 00494c0c
    shl ecx, 0x10                                # 00494c12
    mov edx, dword ptr [ebp - local_60]          # 00494c15
    mov dword ptr [edx + field_47c1], ecx        # 00494c18
    mov eax, dword ptr [ebp - local_60]          # 00494c1e
    fild dword ptr [eax + field_47b5]            # 00494c21
    fstp dword ptr [ebp - local_c0]              # 00494c27
    fld dword ptr [ebp - local_c0]               # 00494c2d
    fdiv dword ptr [0x52db5c]                    # 00494c33
    fmul dword ptr [0x52db54]                    # 00494c39
    call FUN_0050ce04                            # 00494c3f
    mov ecx, dword ptr [ebp - local_60]          # 00494c44
    mov dword ptr [ecx + field_47c5], eax        # 00494c47
    mov edx, dword ptr [ebp - local_60]          # 00494c4d
    fild dword ptr [edx + field_47b9]            # 00494c50
    fstp dword ptr [ebp - local_c4]              # 00494c56
    fld dword ptr [ebp - local_c4]               # 00494c5c
    fdiv dword ptr [0x52db5c]                    # 00494c62
    fmul dword ptr [0x52db54]                    # 00494c68
    call FUN_0050ce04                            # 00494c6e
    mov ecx, dword ptr [ebp - local_60]          # 00494c73
    mov dword ptr [ecx + field_47c9], eax        # 00494c76
    mov edx, dword ptr [ebp - local_48]          # 00494c7c
    add edx, 0x28                                # 00494c7f
    mov eax, dword ptr [ebp - local_60]          # 00494c82
    mov dword ptr [eax + field_481d], edx        # 00494c85
    mov ecx, dword ptr [ebp - local_60]          # 00494c8b
    mov dword ptr [ecx + field_47cd], 0xa        # 00494c8e
L_00494c98:
    # block 0x00494c98: entered by jne at 0x00494bc4, 8 instruction(s), calls FUN_00493c34, falls into the block at 0x00494cb8
    mov edx, dword ptr [ebp - local_60]          # 00494c98
    mov eax, dword ptr [ebp - local_4]           # 00494c9b
    mov dword ptr [edx + field_1ef7], eax        # 00494c9e
    mov ecx, dword ptr [ebp - local_60]          # 00494ca4
    mov edx, dword ptr [ebp - local_34]          # 00494ca7
    mov dword ptr [ecx + field_1efb], edx        # 00494caa
    mov ecx, dword ptr [ebp - local_60]          # 00494cb0
    call FUN_00493c34                            # 00494cb3
L_00494cb8:
    # block 0x00494cb8: entered by jmp at 0x00494bb1; je at 0x00494bba, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00494cb8
    pop ebp                                      # 00494cba
    ret                                          # 00494cbb

# --- data items (not part of the function) -------------------------
.org 0x00494cbc - 0x401000
SWTAB_00494cbc:  # 4 case address(es)
    .long L_0049432f - .text + 0x401000
    .long L_00494363 - .text + 0x401000
    .long L_00494394 - .text + 0x401000
    .long L_004943c5 - .text + 0x401000
.set SWTAB_00494cbc_VA, SWTAB_00494cbc - .text + 0x401000

