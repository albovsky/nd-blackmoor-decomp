# FUN_00500bb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500bb0
# extent:       0x00500bb0-0x005011a8 (1528 code bytes)
# span:         0x00500bb0-0x005011b0 (code 1528, tables 0, padding 8)
# sha256:       e1c7089ced0a1a5339de3319e4108d79a42b6ba372c0407a3dfa0a1488d6bb67
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500bb0
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       15 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 3 more
# fields:       [eax + n] field_minus_4; [ecx + n] field_minus_4; [edx + n] field_minus_4; [scaled index + n] field_4
# callees:      calls FUN_0050c920
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 537 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
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
.equ local_44, 0x44  # offset -0x44
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00500bb0 - 0x401000
.globl FUN_00500bb0
FUN_00500bb0:
    # block 0x00500bb0: entry, 45 instruction(s), calls FUN_0050c920, ends with jle to 0x00500d06 (forward)
    push ebp                                     # 00500bb0
    {load} mov ebp, esp                          # 00500bb1
    sub esp, 0x38                                # 00500bb3
    mov eax, dword ptr [ebp + arg_8]             # 00500bb6
    push ebx                                     # 00500bb9
    push esi                                     # 00500bba
    push edi                                     # 00500bbb
    lea ebx, [4*eax + field_4]                   # 00500bbc
    {load} mov eax, ebx                          # 00500bc3
    add eax, 0x3                                 # 00500bc5
    and al, -0x4                                 # 00500bc8
    call FUN_0050c920                            # 00500bca
    {load} mov eax, ebx                          # 00500bcf
    {load} mov esi, esp                          # 00500bd1
    add eax, 0x3                                 # 00500bd3
    and al, -0x4                                 # 00500bd6
    call FUN_0050c920                            # 00500bd8
    {load} mov eax, ebx                          # 00500bdd
    {load} mov edi, esp                          # 00500bdf
    add eax, 0x3                                 # 00500be1
    and al, -0x4                                 # 00500be4
    call FUN_0050c920                            # 00500be6
    mov ecx, dword ptr [ebp + arg_8]             # 00500beb
    {load} mov ebx, esp                          # 00500bee
    lea eax, [4*ecx + field_4]                   # 00500bf0
    add eax, 0x3                                 # 00500bf7
    and al, -0x4                                 # 00500bfa
    call FUN_0050c920                            # 00500bfc
    mov edx, dword ptr [ebp + arg_8]             # 00500c01
    mov dword ptr [ebp - local_10], esp          # 00500c04
    lea eax, [4*edx + field_4]                   # 00500c07
    add eax, 0x3                                 # 00500c0e
    and al, -0x4                                 # 00500c11
    call FUN_0050c920                            # 00500c13
    fld dword ptr [0x52db78]                     # 00500c18
    fld dword ptr [0x52db78]                     # 00500c1e
    fld dword ptr [0x52db78]                     # 00500c24
    mov eax, dword ptr [ebp + arg_8]             # 00500c2a
    {load} xor edx, edx                          # 00500c2d
    fld dword ptr [0x52db78]                     # 00500c2f
    fld dword ptr [0x52db78]                     # 00500c35
    test eax, eax                                # 00500c3b
    mov dword ptr [ebp - local_14], esp          # 00500c3d
    mov dword ptr [ebp - local_c], edx           # 00500c40
    jle.d32 L_00500d06                           # 00500c43
    # block 0x00500c49: entered by fall-through of jle at 0x00500c43, 18 instruction(s), falls into the block at 0x00500c75
    mov edx, dword ptr [ebp + arg_10]            # 00500c49
    {load} mov ecx, esi                          # 00500c4c
    {load} sub edx, esi                          # 00500c4e
    mov dword ptr [ebp - local_30], eax          # 00500c50
    mov dword ptr [ebp - local_2c], edx          # 00500c53
    {load} mov edx, edi                          # 00500c56
    {load} sub edx, esi                          # 00500c58
    mov dword ptr [ebp - local_28], edx          # 00500c5a
    {load} mov edx, ebx                          # 00500c5d
    {load} sub edx, esi                          # 00500c5f
    mov dword ptr [ebp - local_24], edx          # 00500c61
    mov edx, dword ptr [ebp - local_10]          # 00500c64
    {load} sub edx, esi                          # 00500c67
    mov dword ptr [ebp - local_20], edx          # 00500c69
    {load} mov edx, esp                          # 00500c6c
    {load} sub edx, esi                          # 00500c6e
    mov dword ptr [ebp - local_1c], edx          # 00500c70
    {load} mov edx, eax                          # 00500c73
L_00500c75:
    # block 0x00500c75: entered by jne at 0x00500d00, 7 instruction(s), ends with je to 0x00500c93 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 00500c75
    fld dword ptr [ebp + arg_18]                 # 00500c78
    fadd dword ptr [eax + ecx]                   # 00500c7b
    fcom dword ptr [0x52cbf4]                    # 00500c7e
    fnstsw ax                                    # 00500c84
    test ah, 0x1                                 # 00500c86
    je.d8 L_00500c93                             # 00500c89
    # block 0x00500c8b: entered by fall-through of je at 0x00500c89, 2 instruction(s), falls into the block at 0x00500c93
    fstp st(0)                                   # 00500c8b
    fld dword ptr [0x52cbf4]                     # 00500c8d
L_00500c93:
    # block 0x00500c93: entered by je at 0x00500c89, 41 instruction(s), ends with jne to 0x00500c75 (backward)
    fld st(0)                                    # 00500c93
    mov eax, dword ptr [ebp - local_28]          # 00500c95
    add ecx, 0x4                                 # 00500c98
    fmul st, st(1)                               # 00500c9b
    fld st(2)                                    # 00500c9d
    fstp dword ptr [ecx - field_minus_4]         # 00500c9f
    fld st(3)                                    # 00500ca2
    fstp dword ptr [eax + ecx - field_minus_4]   # 00500ca4
    mov eax, dword ptr [ebp - local_24]          # 00500ca8
    fld st(4)                                    # 00500cab
    fstp dword ptr [eax + ecx - field_minus_4]   # 00500cad
    mov eax, dword ptr [ebp - local_20]          # 00500cb1
    fld st(5)                                    # 00500cb4
    fstp dword ptr [eax + ecx - field_minus_4]   # 00500cb6
    mov eax, dword ptr [ebp - local_1c]          # 00500cba
    fld st(6)                                    # 00500cbd
    fstp dword ptr [eax + ecx - field_minus_4]   # 00500cbf
    mov eax, dword ptr [ebp - local_30]          # 00500cc3
    fld st(0)                                    # 00500cc6
    faddp st(3), st                              # 00500cc8
    dec eax                                      # 00500cca
    mov dword ptr [ebp - local_30], eax          # 00500ccb
    fld st(0)                                    # 00500cce
    fmul dword ptr [ebp - local_c]               # 00500cd0
    fst dword ptr [ebp + arg_10]                 # 00500cd3
    faddp st(4), st                              # 00500cd6
    fld dword ptr [ebp + arg_10]                 # 00500cd8
    fmul dword ptr [ebp - local_c]               # 00500cdb
    faddp st(5), st                              # 00500cde
    fmul st, st(1)                               # 00500ce0
    fstp dword ptr [ebp + arg_10]                # 00500ce2
    fstp st(0)                                   # 00500ce5
    fld dword ptr [ebp + arg_10]                 # 00500ce7
    faddp st(4), st                              # 00500cea
    fld dword ptr [ebp + arg_10]                 # 00500cec
    fmul dword ptr [ebp - local_c]               # 00500cef
    faddp st(5), st                              # 00500cf2
    fld dword ptr [ebp - local_c]                # 00500cf4
    fadd dword ptr [0x52cbf4]                    # 00500cf7
    fstp dword ptr [ebp - local_c]               # 00500cfd
    jne.d32 L_00500c75                           # 00500d00
L_00500d06:
    # block 0x00500d06: entered by jle at 0x00500c43; fall-through of jne at 0x00500d00, 14 instruction(s), ends with jns to 0x00500f7c (forward)
    fstp dword ptr [esi + 4*edx]                 # 00500d06
    mov ecx, dword ptr [ebp - local_10]          # 00500d09
    mov eax, dword ptr [ebp - local_14]          # 00500d0c
    fstp dword ptr [edi + 4*edx]                 # 00500d0f
    mov dword ptr [ebp + arg_10], 0x0            # 00500d12
    fstp dword ptr [ebx + 4*edx]                 # 00500d19
    fstp dword ptr [ecx + 4*edx]                 # 00500d1c
    fstp dword ptr [eax + 4*edx]                 # 00500d1f
    mov edx, dword ptr [ebp + arg_c]             # 00500d22
    fld dword ptr [0x52db78]                     # 00500d25
    mov ecx, dword ptr [edx]                     # 00500d2b
    {load} mov eax, ecx                          # 00500d2d
    sar eax, 0x10                                # 00500d2f
    jns.d32 L_00500f7c                           # 00500d32
    # block 0x00500d38: entered by fall-through of jns at 0x00500d32, 6 instruction(s), falls into the block at 0x00500d49
    mov dword ptr [ebp - local_2c], ecx          # 00500d38
    mov ecx, dword ptr [ebp + arg_14]            # 00500d3b
    {load} sub ecx, edx                          # 00500d3e
    mov dword ptr [ebp - local_30], edx          # 00500d40
    mov edx, dword ptr [ebp - local_2c]          # 00500d43
    mov dword ptr [ebp - local_18], ecx          # 00500d46
L_00500d49:
    # block 0x00500d49: entered by js at 0x00500de8, 42 instruction(s), ends with je to 0x00500dc1 (forward)
    neg eax                                      # 00500d49
    and edx, 0xffff                              # 00500d4b
    shl eax, 0x2                                 # 00500d51
    {load} mov ecx, edx                          # 00500d54
    mov edx, dword ptr [ebp - local_10]          # 00500d56
    fld dword ptr [eax + esi]                    # 00500d59
    fadd dword ptr [esi + 4*ecx]                 # 00500d5c
    fld dword ptr [edi + 4*ecx]                  # 00500d5f
    fsub dword ptr [eax + edi]                   # 00500d62
    fld dword ptr [eax + ebx]                    # 00500d65
    fadd dword ptr [ebx + 4*ecx]                 # 00500d68
    fld dword ptr [eax + edx]                    # 00500d6b
    fadd dword ptr [edx + 4*ecx]                 # 00500d6e
    mov edx, dword ptr [ebp - local_14]          # 00500d71
    fld dword ptr [edx + 4*ecx]                  # 00500d74
    fsub dword ptr [eax + edx]                   # 00500d77
    fld st(1)                                    # 00500d7a
    fmul st, st(3)                               # 00500d7c
    fld st(1)                                    # 00500d7e
    fmul st, st(5)                               # 00500d80
    fsubp st(1), st                              # 00500d82
    fstp dword ptr [ebp - local_8]               # 00500d84
    fmul st, st(4)                               # 00500d87
    fxch st(1)                                   # 00500d89
    fmul st, st(3)                               # 00500d8b
    fsubp st(1), st                              # 00500d8d
    fstp dword ptr [ebp - local_4]               # 00500d8f
    fmul st, st(2)                               # 00500d92
    fld st(1)                                    # 00500d94
    fmul st, st(2)                               # 00500d96
    fsubp st(1), st                              # 00500d98
    fstp dword ptr [ebp - local_c]               # 00500d9a
    fstp st(0)                                   # 00500d9d
    fstp st(0)                                   # 00500d9f
    fld dword ptr [ebp - local_4]                # 00500da1
    fmul st, st(1)                               # 00500da4
    fadd dword ptr [ebp - local_8]               # 00500da6
    fdiv dword ptr [ebp - local_c]               # 00500da9
    fcom dword ptr [0x52db78]                    # 00500dac
    fnstsw ax                                    # 00500db2
    test ah, 0x1                                 # 00500db4
    je.d8 L_00500dc1                             # 00500db7
    # block 0x00500db9: entered by fall-through of je at 0x00500db7, 2 instruction(s), falls into the block at 0x00500dc1
    fstp st(0)                                   # 00500db9
    fld dword ptr [0x52db78]                     # 00500dbb
L_00500dc1:
    # block 0x00500dc1: entered by je at 0x00500db7, 14 instruction(s), ends with js to 0x00500d49 (backward)
    fsub dword ptr [ebp + arg_18]                # 00500dc1
    mov edx, dword ptr [ebp - local_18]          # 00500dc4
    mov eax, dword ptr [ebp - local_30]          # 00500dc7
    add eax, 0x4                                 # 00500dca
    mov dword ptr [ebp - local_30], eax          # 00500dcd
    fstp dword ptr [edx + eax - field_minus_4]   # 00500dd0
    mov edx, dword ptr [ebp + arg_10]            # 00500dd4
    inc edx                                      # 00500dd7
    fadd dword ptr [0x52cbf4]                    # 00500dd8
    mov dword ptr [ebp + arg_10], edx            # 00500dde
    mov edx, dword ptr [eax]                     # 00500de1
    {load} mov eax, edx                          # 00500de3
    sar eax, 0x10                                # 00500de5
    js.d32 L_00500d49                            # 00500de8
    # block 0x00500dee: entered by fall-through of js at 0x00500de8, 1 instruction(s), falls into the block at 0x00500df1
    mov edx, dword ptr [ebp + arg_c]             # 00500dee
L_00500df1:
    # block 0x00500df1: entered by jmp at 0x00500f7f, 2 instruction(s), ends with jge to 0x00500eae (forward)
    cmp ecx, dword ptr [ebp + arg_8]             # 00500df1
    jge.d32 L_00500eae                           # 00500df4
    # block 0x00500dfa: entered by fall-through of jge at 0x00500df4, 6 instruction(s), falls into the block at 0x00500e0b
    mov eax, dword ptr [ebp + arg_10]            # 00500dfa
    mov ecx, dword ptr [ebp + arg_14]            # 00500dfd
    {load} sub ecx, edx                          # 00500e00
    lea eax, [edx + 4*eax]                       # 00500e02
    mov dword ptr [ebp - local_18], ecx          # 00500e05
    mov dword ptr [ebp + arg_c], eax             # 00500e08
L_00500e0b:
    # block 0x00500e0b: entered by jl at 0x00500ea8, 42 instruction(s), ends with je to 0x00500e83 (forward)
    mov ecx, dword ptr [eax]                     # 00500e0b
    mov edx, dword ptr [ebp - local_10]          # 00500e0d
    {load} mov eax, ecx                          # 00500e10
    and ecx, 0xffff                              # 00500e12
    sar eax, 0x10                                # 00500e18
    fld dword ptr [esi + 4*ecx]                  # 00500e1b
    fsub dword ptr [esi + 4*eax]                 # 00500e1e
    fld dword ptr [edi + 4*ecx]                  # 00500e21
    fsub dword ptr [edi + 4*eax]                 # 00500e24
    fld dword ptr [ebx + 4*ecx]                  # 00500e27
    fsub dword ptr [ebx + 4*eax]                 # 00500e2a
    fld dword ptr [edx + 4*ecx]                  # 00500e2d
    fsub dword ptr [edx + 4*eax]                 # 00500e30
    mov edx, dword ptr [ebp - local_14]          # 00500e33
    fld dword ptr [edx + 4*ecx]                  # 00500e36
    fsub dword ptr [edx + 4*eax]                 # 00500e39
    fld st(1)                                    # 00500e3c
    fmul st, st(3)                               # 00500e3e
    fld st(1)                                    # 00500e40
    fmul st, st(5)                               # 00500e42
    fsubp st(1), st                              # 00500e44
    fstp dword ptr [ebp - local_8]               # 00500e46
    fmul st, st(4)                               # 00500e49
    fxch st(1)                                   # 00500e4b
    fmul st, st(3)                               # 00500e4d
    fsubp st(1), st                              # 00500e4f
    fstp dword ptr [ebp - local_4]               # 00500e51
    fmul st, st(2)                               # 00500e54
    fld st(1)                                    # 00500e56
    fmul st, st(2)                               # 00500e58
    fsubp st(1), st                              # 00500e5a
    fstp dword ptr [ebp - local_c]               # 00500e5c
    fstp st(0)                                   # 00500e5f
    fstp st(0)                                   # 00500e61
    fld dword ptr [ebp - local_4]                # 00500e63
    fmul st, st(1)                               # 00500e66
    fadd dword ptr [ebp - local_8]               # 00500e68
    fdiv dword ptr [ebp - local_c]               # 00500e6b
    fcom dword ptr [0x52db78]                    # 00500e6e
    fnstsw ax                                    # 00500e74
    test ah, 0x1                                 # 00500e76
    je.d8 L_00500e83                             # 00500e79
    # block 0x00500e7b: entered by fall-through of je at 0x00500e79, 2 instruction(s), falls into the block at 0x00500e83
    fstp st(0)                                   # 00500e7b
    fld dword ptr [0x52db78]                     # 00500e7d
L_00500e83:
    # block 0x00500e83: entered by je at 0x00500e79, 13 instruction(s), ends with jl to 0x00500e0b (backward)
    fsub dword ptr [ebp + arg_18]                # 00500e83
    mov eax, dword ptr [ebp + arg_c]             # 00500e86
    mov edx, dword ptr [ebp - local_18]          # 00500e89
    add eax, 0x4                                 # 00500e8c
    mov dword ptr [ebp + arg_c], eax             # 00500e8f
    fstp dword ptr [eax + edx - field_minus_4]   # 00500e92
    mov edx, dword ptr [ebp + arg_10]            # 00500e96
    fadd dword ptr [0x52cbf4]                    # 00500e99
    inc edx                                      # 00500e9f
    mov dword ptr [ebp + arg_10], edx            # 00500ea0
    mov edx, dword ptr [ebp + arg_8]             # 00500ea3
    {load} cmp ecx, edx                          # 00500ea6
    jl.d32 L_00500e0b                            # 00500ea8
L_00500eae:
    # block 0x00500eae: entered by jge at 0x00500df4; fall-through of jl at 0x00500ea8, 4 instruction(s), ends with jge to 0x00500efe (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00500eae
    mov edx, dword ptr [ebp + arg_8]             # 00500eb1
    {load} cmp eax, edx                          # 00500eb4
    jge.d8 L_00500efe                            # 00500eb6
    # block 0x00500eb8: entered by fall-through of jge at 0x00500eb6, 5 instruction(s), falls into the block at 0x00500ec6
    mov edx, dword ptr [ebp + arg_14]            # 00500eb8
    lea edx, [edx + 4*eax]                       # 00500ebb
    mov dword ptr [ebp + arg_c], edx             # 00500ebe
    mov edx, dword ptr [ebp + arg_8]             # 00500ec1
    {load} sub edx, eax                          # 00500ec4
L_00500ec6:
    # block 0x00500ec6: entered by jne at 0x00500efc, 8 instruction(s), ends with je to 0x00500ee6 (forward)
    fld dword ptr [ebp - local_4]                # 00500ec6
    fmul st, st(1)                               # 00500ec9
    fadd dword ptr [ebp - local_8]               # 00500ecb
    fdiv dword ptr [ebp - local_c]               # 00500ece
    fcom dword ptr [0x52db78]                    # 00500ed1
    fnstsw ax                                    # 00500ed7
    test ah, 0x1                                 # 00500ed9
    je.d8 L_00500ee6                             # 00500edc
    # block 0x00500ede: entered by fall-through of je at 0x00500edc, 2 instruction(s), falls into the block at 0x00500ee6
    fstp st(0)                                   # 00500ede
    fld dword ptr [0x52db78]                     # 00500ee0
L_00500ee6:
    # block 0x00500ee6: entered by je at 0x00500edc, 8 instruction(s), ends with jne to 0x00500ec6 (backward)
    fsub dword ptr [ebp + arg_18]                # 00500ee6
    mov eax, dword ptr [ebp + arg_c]             # 00500ee9
    add eax, 0x4                                 # 00500eec
    dec edx                                      # 00500eef
    mov dword ptr [ebp + arg_c], eax             # 00500ef0
    fstp dword ptr [eax - field_minus_4]         # 00500ef3
    fadd dword ptr [0x52cbf4]                    # 00500ef6
    jne.d8 L_00500ec6                            # 00500efc
L_00500efe:
    # block 0x00500efe: entered by jge at 0x00500eb6; fall-through of jne at 0x00500efc, 4 instruction(s), ends with jle to 0x0050119e (forward)
    mov eax, dword ptr [ebp + arg_1c]            # 00500efe
    test eax, eax                                # 00500f01
    fstp st(0)                                   # 00500f03
    jle.d32 L_0050119e                           # 00500f05
    # block 0x00500f0b: entered by fall-through of jle at 0x00500f05, 9 instruction(s), ends with jle to 0x0050106f (forward)
    inc eax                                      # 00500f0b
    mov dword ptr [ebp + arg_10], 0x0            # 00500f0c
    fld dword ptr [0x52db78]                     # 00500f13
    cdq                                          # 00500f19
    {load} sub eax, edx                          # 00500f1a
    sar eax                                      # 00500f1c
    test eax, eax                                # 00500f1e
    mov dword ptr [ebp - local_38], eax          # 00500f20
    jle.d32 L_0050106f                           # 00500f23
    # block 0x00500f29: entered by fall-through of jle at 0x00500f23, 32 instruction(s), ends with forward jump to 0x00500f8a
    mov eax, dword ptr [ebp + arg_14]            # 00500f29
    mov dword ptr [ebp - local_2c], eax          # 00500f2c
    mov eax, dword ptr [ebp + arg_1c]            # 00500f2f
    {load} mov ecx, eax                          # 00500f32
    neg ecx                                      # 00500f34
    cdq                                          # 00500f36
    shl ecx, 0x2                                 # 00500f37
    {load} sub eax, edx                          # 00500f3a
    mov edx, dword ptr [ebp - local_14]          # 00500f3c
    mov dword ptr [ebp - local_34], ecx          # 00500f3f
    {load} mov ecx, eax                          # 00500f42
    sar ecx                                      # 00500f44
    mov dword ptr [ebp - local_30], ecx          # 00500f46
    lea eax, [edx + 4*ecx]                       # 00500f49
    mov edx, dword ptr [ebp - local_10]          # 00500f4c
    mov dword ptr [ebp - local_28], eax          # 00500f4f
    lea eax, [edx + 4*ecx]                       # 00500f52
    lea edx, [ebx + 4*ecx]                       # 00500f55
    mov dword ptr [ebp - local_24], eax          # 00500f58
    lea eax, [edi + 4*ecx]                       # 00500f5b
    mov dword ptr [ebp - local_20], edx          # 00500f5e
    mov dword ptr [ebp - local_1c], eax          # 00500f61
    mov eax, dword ptr [ebp + arg_1c]            # 00500f64
    lea edx, [esi + 4*ecx]                       # 00500f67
    mov dword ptr [ebp - local_18], edx          # 00500f6a
    cdq                                          # 00500f6d
    {load} sub eax, edx                          # 00500f6e
    sar eax                                      # 00500f70
    neg eax                                      # 00500f72
    shl eax, 0x2                                 # 00500f74
    mov dword ptr [ebp + arg_c], eax             # 00500f77
    jmp.d8 L_00500f8a                            # 00500f7a
L_00500f7c:
    # block 0x00500f7c: entered by jns at 0x00500d32, 2 instruction(s), ends with backward jump to 0x00500df1
    mov ecx, dword ptr [ebp + arg_c]             # 00500f7c
    jmp.d32 L_00500df1                           # 00500f7f
L_00500f84:
    # block 0x00500f84: entered by jl at 0x00501069, 2 instruction(s), falls into the block at 0x00500f8a
    mov eax, dword ptr [ebp + arg_c]             # 00500f84
    mov ecx, dword ptr [ebp - local_30]          # 00500f87
L_00500f8a:
    # block 0x00500f8a: entered by jmp at 0x00500f7a, 47 instruction(s), ends with jne to 0x00501016 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 00500f8a
    {load} add ecx, edx                          # 00500f8d
    mov edx, dword ptr [ebp - local_34]          # 00500f8f
    {load} sub eax, edx                          # 00500f92
    mov edx, dword ptr [ebp - local_18]          # 00500f94
    fld dword ptr [eax + esi]                    # 00500f97
    fadd dword ptr [edx]                         # 00500f9a
    mov edx, dword ptr [ebp - local_1c]          # 00500f9c
    fld dword ptr [edx]                          # 00500f9f
    fsub dword ptr [eax + edi]                   # 00500fa1
    mov edx, dword ptr [ebp - local_20]          # 00500fa4
    fld dword ptr [eax + ebx]                    # 00500fa7
    fadd dword ptr [edx]                         # 00500faa
    mov edx, dword ptr [ebp - local_10]          # 00500fac
    fld dword ptr [eax + edx]                    # 00500faf
    mov edx, dword ptr [ebp - local_24]          # 00500fb2
    fadd dword ptr [edx]                         # 00500fb5
    mov edx, dword ptr [ebp - local_28]          # 00500fb7
    fld dword ptr [edx]                          # 00500fba
    mov edx, dword ptr [ebp - local_14]          # 00500fbc
    fsub dword ptr [eax + edx]                   # 00500fbf
    fld st(1)                                    # 00500fc2
    fmul st, st(3)                               # 00500fc4
    fld st(1)                                    # 00500fc6
    fmul st, st(5)                               # 00500fc8
    fsubp st(1), st                              # 00500fca
    fstp dword ptr [ebp - local_8]               # 00500fcc
    fmul st, st(4)                               # 00500fcf
    fxch st(1)                                   # 00500fd1
    fmul st, st(3)                               # 00500fd3
    fsubp st(1), st                              # 00500fd5
    fstp dword ptr [ebp - local_4]               # 00500fd7
    fmul st, st(2)                               # 00500fda
    fld st(1)                                    # 00500fdc
    fmul st, st(2)                               # 00500fde
    fsubp st(1), st                              # 00500fe0
    fstp dword ptr [ebp - local_c]               # 00500fe2
    fstp st(0)                                   # 00500fe5
    fstp st(0)                                   # 00500fe7
    fld dword ptr [ebp - local_4]                # 00500fe9
    fmul st, st(1)                               # 00500fec
    fadd dword ptr [ebp - local_8]               # 00500fee
    fdiv dword ptr [ebp - local_c]               # 00500ff1
    fcom dword ptr [0x52db78]                    # 00500ff4
    fnstsw ax                                    # 00500ffa
    test ah, 0x41                                # 00500ffc
    jne.d8 L_00501016                            # 00500fff
    # block 0x00501001: entered by fall-through of jne at 0x00500fff, 7 instruction(s), ends with je to 0x00501016 (forward)
    fsub dword ptr [ebp + arg_18]                # 00501001
    mov edx, dword ptr [ebp - local_2c]          # 00501004
    fld st(0)                                    # 00501007
    fcomp dword ptr [edx]                        # 00501009
    fnstsw ax                                    # 0050100b
    test ah, 0x1                                 # 0050100d
    je.d8 L_00501016                             # 00501010
    # block 0x00501012: entered by fall-through of je at 0x00501010, 2 instruction(s), ends with forward jump to 0x00501018
    fstp dword ptr [edx]                         # 00501012
    jmp.d8 L_00501018                            # 00501014
L_00501016:
    # block 0x00501016: entered by jne at 0x00500fff; je at 0x00501010, 1 instruction(s), falls into the block at 0x00501018
    fstp st(0)                                   # 00501016
L_00501018:
    # block 0x00501018: entered by jmp at 0x00501014, 28 instruction(s), ends with jl to 0x00500f84 (backward)
    mov edx, dword ptr [ebp + arg_c]             # 00501018
    mov eax, dword ptr [ebp + arg_10]            # 0050101b
    sub edx, 0x4                                 # 0050101e
    inc eax                                      # 00501021
    mov dword ptr [ebp + arg_c], edx             # 00501022
    mov edx, dword ptr [ebp - local_18]          # 00501025
    add edx, 0x4                                 # 00501028
    mov dword ptr [ebp + arg_10], eax            # 0050102b
    mov dword ptr [ebp - local_18], edx          # 0050102e
    mov edx, dword ptr [ebp - local_1c]          # 00501031
    add edx, 0x4                                 # 00501034
    mov dword ptr [ebp - local_1c], edx          # 00501037
    mov edx, dword ptr [ebp - local_20]          # 0050103a
    add edx, 0x4                                 # 0050103d
    mov dword ptr [ebp - local_20], edx          # 00501040
    mov edx, dword ptr [ebp - local_24]          # 00501043
    add edx, 0x4                                 # 00501046
    mov dword ptr [ebp - local_24], edx          # 00501049
    mov edx, dword ptr [ebp - local_28]          # 0050104c
    add edx, 0x4                                 # 0050104f
    mov dword ptr [ebp - local_28], edx          # 00501052
    mov edx, dword ptr [ebp - local_2c]          # 00501055
    fadd dword ptr [0x52cbf4]                    # 00501058
    add edx, 0x4                                 # 0050105e
    mov dword ptr [ebp - local_2c], edx          # 00501061
    mov edx, dword ptr [ebp - local_38]          # 00501064
    {load} cmp eax, edx                          # 00501067
    jl.d32 L_00500f84                            # 00501069
L_0050106f:
    # block 0x0050106f: entered by jle at 0x00500f23; fall-through of jl at 0x00501069, 3 instruction(s), ends with jge to 0x00501155 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0050106f
    {load} cmp ecx, eax                          # 00501072
    jge.d32 L_00501155                           # 00501074
    # block 0x0050107a: entered by fall-through of jge at 0x00501074, 14 instruction(s), ends with forward jump to 0x005010a5
    mov eax, dword ptr [ebp + arg_1c]            # 0050107a
    mov edx, dword ptr [ebp + arg_14]            # 0050107d
    lea ecx, [4*eax]                             # 00501080
    mov dword ptr [ebp - local_38], ecx          # 00501087
    mov ecx, dword ptr [ebp + arg_10]            # 0050108a
    lea edx, [edx + 4*ecx]                       # 0050108d
    mov dword ptr [ebp + arg_1c], edx            # 00501090
    cdq                                          # 00501093
    {load} sub eax, edx                          # 00501094
    sar eax                                      # 00501096
    {load} add ecx, eax                          # 00501098
    mov dword ptr [ebp - local_30], eax          # 0050109a
    shl ecx, 0x2                                 # 0050109d
    jmp.d8 L_005010a5                            # 005010a0
L_005010a2:
    # block 0x005010a2: entered by jl at 0x0050114f, 1 instruction(s), falls into the block at 0x005010a5
    mov eax, dword ptr [ebp - local_30]          # 005010a2
L_005010a5:
    # block 0x005010a5: entered by jmp at 0x005010a0, 44 instruction(s), ends with jne to 0x0050112c (forward)
    mov edx, dword ptr [ebp + arg_10]            # 005010a5
    fld dword ptr [ecx + esi]                    # 005010a8
    {load} add eax, edx                          # 005010ab
    mov edx, dword ptr [ebp - local_38]          # 005010ad
    mov dword ptr [ebp + arg_c], eax             # 005010b0
    {load} mov eax, ecx                          # 005010b3
    {load} sub eax, edx                          # 005010b5
    mov edx, dword ptr [ebp - local_10]          # 005010b7
    fsub dword ptr [eax + esi]                   # 005010ba
    fld dword ptr [ecx + edi]                    # 005010bd
    fsub dword ptr [eax + edi]                   # 005010c0
    fld dword ptr [ecx + ebx]                    # 005010c3
    fsub dword ptr [eax + ebx]                   # 005010c6
    fld dword ptr [ecx + edx]                    # 005010c9
    fsub dword ptr [eax + edx]                   # 005010cc
    mov edx, dword ptr [ebp - local_14]          # 005010cf
    fld dword ptr [ecx + edx]                    # 005010d2
    fsub dword ptr [eax + edx]                   # 005010d5
    fld st(1)                                    # 005010d8
    fmul st, st(3)                               # 005010da
    fld st(1)                                    # 005010dc
    fmul st, st(5)                               # 005010de
    fsubp st(1), st                              # 005010e0
    fstp dword ptr [ebp - local_8]               # 005010e2
    fmul st, st(4)                               # 005010e5
    fxch st(1)                                   # 005010e7
    fmul st, st(3)                               # 005010e9
    fsubp st(1), st                              # 005010eb
    fstp dword ptr [ebp - local_4]               # 005010ed
    fmul st, st(2)                               # 005010f0
    fld st(1)                                    # 005010f2
    fmul st, st(2)                               # 005010f4
    fsubp st(1), st                              # 005010f6
    fstp dword ptr [ebp - local_c]               # 005010f8
    fstp st(0)                                   # 005010fb
    fstp st(0)                                   # 005010fd
    fld dword ptr [ebp - local_4]                # 005010ff
    fmul st, st(1)                               # 00501102
    fadd dword ptr [ebp - local_8]               # 00501104
    fdiv dword ptr [ebp - local_c]               # 00501107
    fcom dword ptr [0x52db78]                    # 0050110a
    fnstsw ax                                    # 00501110
    test ah, 0x41                                # 00501112
    jne.d8 L_0050112c                            # 00501115
    # block 0x00501117: entered by fall-through of jne at 0x00501115, 7 instruction(s), ends with je to 0x0050112c (forward)
    fsub dword ptr [ebp + arg_18]                # 00501117
    mov edx, dword ptr [ebp + arg_1c]            # 0050111a
    fld st(0)                                    # 0050111d
    fcomp dword ptr [edx]                        # 0050111f
    fnstsw ax                                    # 00501121
    test ah, 0x1                                 # 00501123
    je.d8 L_0050112c                             # 00501126
    # block 0x00501128: entered by fall-through of je at 0x00501126, 2 instruction(s), ends with forward jump to 0x0050112e
    fstp dword ptr [edx]                         # 00501128
    jmp.d8 L_0050112e                            # 0050112a
L_0050112c:
    # block 0x0050112c: entered by jne at 0x00501115; je at 0x00501126, 1 instruction(s), falls into the block at 0x0050112e
    fstp st(0)                                   # 0050112c
L_0050112e:
    # block 0x0050112e: entered by jmp at 0x0050112a, 12 instruction(s), ends with jl to 0x005010a2 (backward)
    mov eax, dword ptr [ebp + arg_10]            # 0050112e
    mov edx, dword ptr [ebp + arg_c]             # 00501131
    inc eax                                      # 00501134
    add ecx, 0x4                                 # 00501135
    mov dword ptr [ebp + arg_10], eax            # 00501138
    mov eax, dword ptr [ebp + arg_1c]            # 0050113b
    fadd dword ptr [0x52cbf4]                    # 0050113e
    add eax, 0x4                                 # 00501144
    mov dword ptr [ebp + arg_1c], eax            # 00501147
    mov eax, dword ptr [ebp + arg_8]             # 0050114a
    {load} cmp edx, eax                          # 0050114d
    jl.d32 L_005010a2                            # 0050114f
L_00501155:
    # block 0x00501155: entered by jge at 0x00501074; fall-through of jl at 0x0050114f, 3 instruction(s), ends with jge to 0x0050119c (forward)
    mov edx, dword ptr [ebp + arg_10]            # 00501155
    {load} cmp edx, eax                          # 00501158
    jge.d8 L_0050119c                            # 0050115a
    # block 0x0050115c: entered by fall-through of jge at 0x0050115a, 4 instruction(s), falls into the block at 0x00501166
    mov ecx, dword ptr [ebp + arg_14]            # 0050115c
    {load} sub eax, edx                          # 0050115f
    lea ecx, [ecx + 4*edx]                       # 00501161
    {load} mov edx, eax                          # 00501164
L_00501166:
    # block 0x00501166: entered by jne at 0x0050119a, 8 instruction(s), ends with jne to 0x0050118e (forward)
    fld dword ptr [ebp - local_4]                # 00501166
    fmul st, st(1)                               # 00501169
    fadd dword ptr [ebp - local_8]               # 0050116b
    fdiv dword ptr [ebp - local_c]               # 0050116e
    fcom dword ptr [0x52db78]                    # 00501171
    fnstsw ax                                    # 00501177
    test ah, 0x41                                # 00501179
    jne.d8 L_0050118e                            # 0050117c
    # block 0x0050117e: entered by fall-through of jne at 0x0050117c, 5 instruction(s), ends with je to 0x0050118e (forward)
    fsub dword ptr [ebp + arg_18]                # 0050117e
    fcom dword ptr [ecx]                         # 00501181
    fnstsw ax                                    # 00501183
    test ah, 0x1                                 # 00501185
    je.d8 L_0050118e                             # 00501188
    # block 0x0050118a: entered by fall-through of je at 0x00501188, 2 instruction(s), ends with forward jump to 0x00501190
    fstp dword ptr [ecx]                         # 0050118a
    jmp.d8 L_00501190                            # 0050118c
L_0050118e:
    # block 0x0050118e: entered by jne at 0x0050117c; je at 0x00501188, 1 instruction(s), falls into the block at 0x00501190
    fstp st(0)                                   # 0050118e
L_00501190:
    # block 0x00501190: entered by jmp at 0x0050118c, 4 instruction(s), ends with jne to 0x00501166 (backward)
    fadd dword ptr [0x52cbf4]                    # 00501190
    add ecx, 0x4                                 # 00501196
    dec edx                                      # 00501199
    jne.d8 L_00501166                            # 0050119a
L_0050119c:
    # block 0x0050119c: entered by jge at 0x0050115a; fall-through of jne at 0x0050119a, 1 instruction(s), falls into the block at 0x0050119e
    fstp st(0)                                   # 0050119c
L_0050119e:
    # block 0x0050119e: entered by jle at 0x00500f05, 7 instruction(s), ends with ret
    lea esp, [ebp - local_44]                    # 0050119e
    pop edi                                      # 005011a1
    pop esi                                      # 005011a2
    pop ebx                                      # 005011a3
    {load} mov esp, ebp                          # 005011a4
    pop ebp                                      # 005011a6
    ret                                          # 005011a7

# --- data items (not part of the function) -------------------------
.org 0x005011a8 - 0x401000
PAD_005011a8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

