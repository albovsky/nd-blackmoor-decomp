# FUN_004f9d18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9d18
# extent:       0x004f9d18-0x004f9f92 (634 code bytes)
# span:         0x004f9d18-0x004f9f92 (code 634, tables 0, padding 0)
# sha256:       e6b5ce83fa56db93dd5d42e806728dcab3d9039a9efc0d1cd35cfea32d562901
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_init_random_linear_motion
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f9d18.c.txt, not original source) refers to the data labelled s_CDirectSound__InitRandomLinearMo_0055f4a0
# name-note:    Sets up random linear motion of a channel 3D source: distance, target offset, per-step increments and timer; logs CDirectSound::InitRandomLinearMotion.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_3c, field_40, field_48, field_54, field_64, field_2a3, field_2ab; [ecx + n] field_18, field_1c, field_20, field_24, field_28, field_38, field_44, field_5c, field_60, field_64, field_68, field_2a7 and 2 more; [edx + n] field_14, field_20, field_28, field_44, field_48, field_4c, field_5c, field_68, field_2a3, field_2a7; [esi + n] field_1c, field_24
# callees:      calls KERNEL32.dll!GetTickCount, FUN_0050df94, FUN_004f9f92, FUN_004fa127, FUN_004f8f94, FUN_004f9040, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 199 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ arg_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_54, 0x54  # offset +0x54
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004f9f92, .text + (0x004f9f92 - 0x401000)
.set FUN_004fa127, .text + (0x004fa127 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)

.org 0x004f9d18 - 0x401000
.globl FUN_004f9d18
FUN_004f9d18:
    # block 0x004f9d18: entry, 60 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0050df94, FUN_004f9f92, falls into the block at 0x004f9dcd
    push ebp                                     # 004f9d18
    {load} mov ebp, esp                          # 004f9d19
    sub esp, 0x38                                # 004f9d1b
    push esi                                     # 004f9d1e
    mov dword ptr [ebp - local_20], ecx          # 004f9d1f
    mov eax, dword ptr [ebp + arg_8]             # 004f9d22
    imul eax, eax, 0x5bb                         # 004f9d25
    mov ecx, dword ptr [ebp - local_20]          # 004f9d2b
    mov edx, dword ptr [ecx + field_3ce]         # 004f9d2e
    {load} add edx, eax                          # 004f9d34
    mov dword ptr [ebp - local_1c], edx          # 004f9d36
    mov eax, dword ptr [ebp - local_1c]          # 004f9d39
    add eax, 0x19e                               # 004f9d3c
    mov dword ptr [ebp - local_4], eax           # 004f9d41
    call dword ptr [0x52a23c]                    # 004f9d44
    mov dword ptr [ebp - local_18], eax          # 004f9d4a
    mov ecx, dword ptr [ebp - local_4]           # 004f9d4d
    mov edx, dword ptr [ebp - local_4]           # 004f9d50
    mov eax, dword ptr [ecx + field_18]          # 004f9d53
    sub eax, dword ptr [edx + field_14]          # 004f9d56
    mov ecx, dword ptr [ebp - local_4]           # 004f9d59
    mov edx, dword ptr [ebp - local_4]           # 004f9d5c
    mov ecx, dword ptr [ecx + field_18]          # 004f9d5f
    sub ecx, dword ptr [edx + field_14]          # 004f9d62
    imul eax, ecx                                # 004f9d65
    mov edx, dword ptr [ebp - local_4]           # 004f9d68
    mov ecx, dword ptr [ebp - local_4]           # 004f9d6b
    mov edx, dword ptr [edx + field_20]          # 004f9d6e
    sub edx, dword ptr [ecx + field_1c]          # 004f9d71
    mov ecx, dword ptr [ebp - local_4]           # 004f9d74
    mov esi, dword ptr [ebp - local_4]           # 004f9d77
    mov ecx, dword ptr [ecx + field_20]          # 004f9d7a
    sub ecx, dword ptr [esi + field_1c]          # 004f9d7d
    imul edx, ecx                                # 004f9d80
    {load} add eax, edx                          # 004f9d83
    mov edx, dword ptr [ebp - local_4]           # 004f9d85
    mov ecx, dword ptr [ebp - local_4]           # 004f9d88
    mov edx, dword ptr [edx + field_28]          # 004f9d8b
    sub edx, dword ptr [ecx + field_24]          # 004f9d8e
    mov ecx, dword ptr [ebp - local_4]           # 004f9d91
    mov esi, dword ptr [ebp - local_4]           # 004f9d94
    mov ecx, dword ptr [ecx + field_28]          # 004f9d97
    sub ecx, dword ptr [esi + field_24]          # 004f9d9a
    imul edx, ecx                                # 004f9d9d
    {load} add eax, edx                          # 004f9da0
    mov dword ptr [ebp - local_24], eax          # 004f9da2
    fild dword ptr [ebp - local_24]              # 004f9da5
    fstp qword ptr [ebp - local_2c]              # 004f9da8
    mov edx, dword ptr [ebp - local_28]          # 004f9dab
    push edx                                     # 004f9dae
    mov eax, dword ptr [ebp - local_2c]          # 004f9daf
    push eax                                     # 004f9db2
    call FUN_0050df94                            # 004f9db3
    add esp, 0x8                                 # 004f9db8
    mov ecx, dword ptr [ebp - local_4]           # 004f9dbb
    fstp dword ptr [ecx + field_5c]              # 004f9dbe
    mov edx, dword ptr [ebp + arg_8]             # 004f9dc1
    push edx                                     # 004f9dc4
    mov ecx, dword ptr [ebp - local_20]          # 004f9dc5
    call FUN_004f9f92                            # 004f9dc8
L_004f9dcd:
    # block 0x004f9dcd: entered by je at 0x004f9e56, 42 instruction(s), calls FUN_004fa127, FUN_0050df94, ends with je to 0x004f9dcd (backward)
    lea eax, [ebp - local_10]                    # 004f9dcd
    push eax                                     # 004f9dd0
    mov ecx, dword ptr [ebp + arg_8]             # 004f9dd1
    push ecx                                     # 004f9dd4
    mov ecx, dword ptr [ebp - local_20]          # 004f9dd5
    call FUN_004fa127                            # 004f9dd8
    mov edx, dword ptr [ebp - local_1c]          # 004f9ddd
    fld dword ptr [edx + field_2a3]              # 004f9de0
    fsub dword ptr [ebp - local_10]              # 004f9de6
    mov eax, dword ptr [ebp - local_1c]          # 004f9de9
    fld dword ptr [eax + field_2a3]              # 004f9dec
    fsub dword ptr [ebp - local_10]              # 004f9df2
    fmulp st(1), st                              # 004f9df5
    mov ecx, dword ptr [ebp - local_1c]          # 004f9df7
    fld dword ptr [ecx + field_2a7]              # 004f9dfa
    fsub dword ptr [ebp - local_c]               # 004f9e00
    mov edx, dword ptr [ebp - local_1c]          # 004f9e03
    fld dword ptr [edx + field_2a7]              # 004f9e06
    fsub dword ptr [ebp - local_c]               # 004f9e0c
    fmulp st(1), st                              # 004f9e0f
    faddp st(1), st                              # 004f9e11
    mov eax, dword ptr [ebp - local_1c]          # 004f9e13
    fld dword ptr [eax + field_2ab]              # 004f9e16
    fsub dword ptr [ebp - local_8]               # 004f9e1c
    mov ecx, dword ptr [ebp - local_1c]          # 004f9e1f
    fld dword ptr [ecx + field_2ab]              # 004f9e22
    fsub dword ptr [ebp - local_8]               # 004f9e28
    fmulp st(1), st                              # 004f9e2b
    faddp st(1), st                              # 004f9e2d
    sub esp, 0x8                                 # 004f9e2f
    fstp qword ptr [esp]                         # 004f9e32
    call FUN_0050df94                            # 004f9e35
    add esp, 0x8                                 # 004f9e3a
    fstp dword ptr [ebp - local_14]              # 004f9e3d
    fld dword ptr [ebp - local_14]               # 004f9e40
    mov edx, dword ptr [ebp - local_4]           # 004f9e43
    fld dword ptr [edx + field_5c]               # 004f9e46
    fdiv qword ptr [0x52c678]                    # 004f9e49
    fcompp                                       # 004f9e4f
    fnstsw ax                                    # 004f9e51
    test ah, 0x41                                # 004f9e53
    je.d32 L_004f9dcd                            # 004f9e56
    # block 0x004f9e5c: entered by fall-through of je at 0x004f9e56, 60 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f9f8b (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004f9e5c
    fld dword ptr [ebp - local_10]               # 004f9e5f
    fsub dword ptr [eax + field_2a3]             # 004f9e62
    mov ecx, dword ptr [ebp - local_4]           # 004f9e68
    fstp dword ptr [ecx + field_60]              # 004f9e6b
    mov edx, dword ptr [ebp - local_1c]          # 004f9e6e
    fld dword ptr [ebp - local_c]                # 004f9e71
    fsub dword ptr [edx + field_2a7]             # 004f9e74
    mov eax, dword ptr [ebp - local_4]           # 004f9e7a
    fstp dword ptr [eax + field_64]              # 004f9e7d
    mov ecx, dword ptr [ebp - local_1c]          # 004f9e80
    fld dword ptr [ebp - local_8]                # 004f9e83
    fsub dword ptr [ecx + field_2ab]             # 004f9e86
    mov edx, dword ptr [ebp - local_4]           # 004f9e8c
    fstp dword ptr [edx + field_68]              # 004f9e8f
    mov eax, dword ptr [ebp - local_4]           # 004f9e92
    fild dword ptr [eax + field_3c]              # 004f9e95
    fstp dword ptr [ebp - local_30]              # 004f9e98
    mov ecx, dword ptr [ebp - local_4]           # 004f9e9b
    fld dword ptr [ecx + field_60]               # 004f9e9e
    fdiv dword ptr [ebp - local_30]              # 004f9ea1
    mov edx, dword ptr [ebp - local_4]           # 004f9ea4
    fstp dword ptr [edx + field_44]              # 004f9ea7
    mov eax, dword ptr [ebp - local_4]           # 004f9eaa
    fild dword ptr [eax + field_3c]              # 004f9ead
    fstp dword ptr [ebp - local_34]              # 004f9eb0
    mov ecx, dword ptr [ebp - local_4]           # 004f9eb3
    fld dword ptr [ecx + field_64]               # 004f9eb6
    fdiv dword ptr [ebp - local_34]              # 004f9eb9
    mov edx, dword ptr [ebp - local_4]           # 004f9ebc
    fstp dword ptr [edx + field_48]              # 004f9ebf
    mov eax, dword ptr [ebp - local_4]           # 004f9ec2
    fild dword ptr [eax + field_3c]              # 004f9ec5
    fstp dword ptr [ebp - local_38]              # 004f9ec8
    mov ecx, dword ptr [ebp - local_4]           # 004f9ecb
    fld dword ptr [ecx + field_68]               # 004f9ece
    fdiv dword ptr [ebp - local_38]              # 004f9ed1
    mov edx, dword ptr [ebp - local_4]           # 004f9ed4
    fstp dword ptr [edx + field_4c]              # 004f9ed7
    mov eax, dword ptr [ebp - local_4]           # 004f9eda
    mov dword ptr [eax + field_54], 0x0          # 004f9edd
    mov ecx, dword ptr [ebp - local_4]           # 004f9ee4
    mov edx, dword ptr [ebp - local_18]          # 004f9ee7
    add edx, dword ptr [ecx + field_38]          # 004f9eea
    mov eax, dword ptr [ebp - local_4]           # 004f9eed
    mov dword ptr [eax + field_40], edx          # 004f9ef0
    mov ecx, dword ptr [ebp + arg_8]             # 004f9ef3
    push ecx                                     # 004f9ef6
    mov ecx, dword ptr [ebp - local_20]          # 004f9ef7
    call FUN_004f8f94                            # 004f9efa
    mov edx, dword ptr [ebp - local_1c]          # 004f9eff
    add edx, 0x2a3                               # 004f9f02
    push edx                                     # 004f9f08
    mov eax, dword ptr [ebp + arg_8]             # 004f9f09
    push eax                                     # 004f9f0c
    mov ecx, dword ptr [ebp - local_20]          # 004f9f0d
    call FUN_004f9040                            # 004f9f10
    movsx ecx, word ptr [0x63a4cd]               # 004f9f15
    test ecx, ecx                                # 004f9f1c
    je.d8 L_004f9f8b                             # 004f9f1e
    # block 0x004f9f20: entered by fall-through of je at 0x004f9f1e, 33 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9f8b
    mov edx, dword ptr [ebp - local_4]           # 004f9f20
    fld dword ptr [edx + field_4c]               # 004f9f23
    sub esp, 0x8                                 # 004f9f26
    fstp qword ptr [esp]                         # 004f9f29
    mov eax, dword ptr [ebp - local_4]           # 004f9f2c
    fld dword ptr [eax + field_48]               # 004f9f2f
    sub esp, 0x8                                 # 004f9f32
    fstp qword ptr [esp]                         # 004f9f35
    mov ecx, dword ptr [ebp - local_4]           # 004f9f38
    fld dword ptr [ecx + field_44]               # 004f9f3b
    sub esp, 0x8                                 # 004f9f3e
    fstp qword ptr [esp]                         # 004f9f41
    mov edx, dword ptr [ebp - local_4]           # 004f9f44
    fld dword ptr [edx + field_68]               # 004f9f47
    sub esp, 0x8                                 # 004f9f4a
    fstp qword ptr [esp]                         # 004f9f4d
    mov eax, dword ptr [ebp - local_4]           # 004f9f50
    fld dword ptr [eax + field_64]               # 004f9f53
    sub esp, 0x8                                 # 004f9f56
    fstp qword ptr [esp]                         # 004f9f59
    mov ecx, dword ptr [ebp - local_4]           # 004f9f5c
    fld dword ptr [ecx + field_60]               # 004f9f5f
    sub esp, 0x8                                 # 004f9f62
    fstp qword ptr [esp]                         # 004f9f65
    mov edx, dword ptr [ebp + arg_8]             # 004f9f68
    push edx                                     # 004f9f6b
    push 0x55f4a0                                # 004f9f6c
    push 0x63888b                                # 004f9f71
    call FUN_0050ca3e                            # 004f9f76
    add esp, 0x3c                                # 004f9f7b
    push 0x63888b                                # 004f9f7e
    call FUN_0044a2b7                            # 004f9f83
    add esp, 0x4                                 # 004f9f88
L_004f9f8b:
    # block 0x004f9f8b: entered by je at 0x004f9f1e, 4 instruction(s), ends with ret 0x4
    pop esi                                      # 004f9f8b
    {load} mov esp, ebp                          # 004f9f8c
    pop ebp                                      # 004f9f8e
    ret 0x4                                      # 004f9f8f

