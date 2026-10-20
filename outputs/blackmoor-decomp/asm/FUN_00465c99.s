# FUN_00465c99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465c99
# extent:       0x00465c99-0x00465f8e (757 code bytes)
# span:         0x00465c99-0x00465f8e (code 757, tables 0, padding 0)
# sha256:       73b39b4335e58aa195af51213735d01df79ca50cfad42215160ce134f261038c
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465c99_hit_test
# naming:       native port src/original_methods_fl24a.c:m465c99_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m465c99_hit_test (row split at (hi-lo)/2, three rectangles, last, calls 465f8e, ret 8). Differential and oracle: every instruction reached. See tasks/fl24a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_2a, field_49, field_5c, field_60, field_64, field_74, field_f8, field_fc, field_100, field_54f; [ecx + n] field_1e, field_2a, field_2c, field_58, field_5c, field_60, field_6c, field_70, field_100, field_104, field_55b; [edx + n] field_2a, field_2c, field_58, field_64, field_68, field_f8, field_fc, field_104, field_553, field_557; [esi + n] field_f8
# callees:      calls FUN_00465f8e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m465c99_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 222 instruction(s), 31 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_49, 0x49  # offset +0x49
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_f8, 0xf8  # offset +0xf8
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_54f, 0x54f  # offset +0x54f
.equ field_553, 0x553  # offset +0x553
.equ field_557, 0x557  # offset +0x557
.equ field_55b, 0x55b  # offset +0x55b

# --- external targets -----------------------------------------------
.set FUN_00465f8e, .text + (0x00465f8e - 0x401000)

.org 0x00465c99 - 0x401000
.globl FUN_00465c99
FUN_00465c99:
    # block 0x00465c99: entry, 8 instruction(s), ends with je to 0x00465f85 (forward)
    push ebp                                     # 00465c99
    {load} mov ebp, esp                          # 00465c9a
    sub esp, 0xc                                 # 00465c9c
    push esi                                     # 00465c9f
    mov dword ptr [ebp - local_c], ecx           # 00465ca0
    mov eax, dword ptr [ebp - local_c]           # 00465ca3
    cmp dword ptr [eax + field_49], 0x0          # 00465ca6
    je.d32 L_00465f85                            # 00465caa
    # block 0x00465cb0: entered by fall-through of je at 0x00465caa, 26 instruction(s), ends with jl to 0x00465d98 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00465cb0
    movsx edx, word ptr [ecx + field_1e]         # 00465cb3
    imul edx, edx, 0x8d                          # 00465cb7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00465cbd
    mov dword ptr [ebp - local_4], eax           # 00465cc3
    mov ecx, dword ptr [ebp - local_c]           # 00465cc6
    movsx edx, word ptr [ecx + field_2a]         # 00465cc9
    shl edx, 0x4                                 # 00465ccd
    mov eax, dword ptr [ebp - local_c]           # 00465cd0
    movsx ecx, word ptr [eax + field_2a]         # 00465cd3
    shl ecx, 0x4                                 # 00465cd7
    mov eax, dword ptr [ebp - local_4]           # 00465cda
    mov esi, dword ptr [ebp - local_4]           # 00465cdd
    mov eax, dword ptr [eax + edx + field_100]   # 00465ce0
    sub eax, dword ptr [esi + ecx + field_f8]    # 00465ce7
    cdq                                          # 00465cee
    {load} sub eax, edx                          # 00465cef
    sar eax                                      # 00465cf1
    mov dword ptr [ebp - local_8], eax           # 00465cf3
    movsx ecx, word ptr [ebp + arg_c]            # 00465cf6
    mov edx, dword ptr [ebp - local_c]           # 00465cfa
    movsx eax, word ptr [edx + field_2a]         # 00465cfd
    shl eax, 0x4                                 # 00465d01
    mov edx, dword ptr [ebp - local_4]           # 00465d04
    cmp ecx, dword ptr [edx + eax + field_fc]    # 00465d07
    jl.d32 L_00465d98                            # 00465d0e
    # block 0x00465d14: entered by fall-through of jl at 0x00465d0e, 7 instruction(s), ends with jg to 0x00465d98 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00465d14
    mov ecx, dword ptr [ebp - local_c]           # 00465d18
    movsx edx, word ptr [ecx + field_2a]         # 00465d1b
    shl edx, 0x4                                 # 00465d1f
    mov ecx, dword ptr [ebp - local_4]           # 00465d22
    cmp eax, dword ptr [ecx + edx + field_104]   # 00465d25
    jg.d8 L_00465d98                             # 00465d2c
    # block 0x00465d2e: entered by fall-through of jg at 0x00465d2c, 7 instruction(s), ends with jle to 0x00465d98 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00465d2e
    mov eax, dword ptr [ebp - local_c]           # 00465d32
    movsx ecx, word ptr [eax + field_2a]         # 00465d35
    shl ecx, 0x4                                 # 00465d39
    mov eax, dword ptr [ebp - local_4]           # 00465d3c
    cmp edx, dword ptr [eax + ecx + field_f8]    # 00465d3f
    jle.d8 L_00465d98                            # 00465d46
    # block 0x00465d48: entered by fall-through of jle at 0x00465d46, 9 instruction(s), ends with jg to 0x00465d98 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00465d48
    mov edx, dword ptr [ebp - local_c]           # 00465d4c
    movsx eax, word ptr [edx + field_2a]         # 00465d4f
    shl eax, 0x4                                 # 00465d53
    mov edx, dword ptr [ebp - local_4]           # 00465d56
    mov eax, dword ptr [edx + eax + field_f8]    # 00465d59
    add eax, dword ptr [ebp - local_8]           # 00465d60
    {load} cmp ecx, eax                          # 00465d63
    jg.d8 L_00465d98                             # 00465d65
    # block 0x00465d67: entered by fall-through of jg at 0x00465d65, 4 instruction(s), ends with jne to 0x00465d98 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00465d67
    movsx edx, word ptr [ecx + field_2c]         # 00465d6a
    test edx, edx                                # 00465d6e
    jne.d8 L_00465d98                            # 00465d70
    # block 0x00465d72: entered by fall-through of jne at 0x00465d70, 4 instruction(s), ends with jle to 0x00465d98 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00465d72
    movsx ecx, word ptr [eax + field_2a]         # 00465d75
    test ecx, ecx                                # 00465d79
    jle.d8 L_00465d98                            # 00465d7b
    # block 0x00465d7d: entered by fall-through of jle at 0x00465d7b, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x2                                     # 00465d7d
    push 0x19                                    # 00465d7f
    push 0x27d2                                  # 00465d81
    mov ecx, dword ptr [ebp - local_c]           # 00465d86
    call FUN_00465f8e                            # 00465d89
    mov eax, 0x1                                 # 00465d8e
    jmp.d32 L_00465f87                           # 00465d93
L_00465d98:
    # block 0x00465d98: entered by jl at 0x00465d0e; jg at 0x00465d2c; jle at 0x00465d46; jg at 0x00465d65; more, 7 instruction(s), ends with jl to 0x00465e3b (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00465d98
    mov eax, dword ptr [ebp - local_c]           # 00465d9c
    movsx ecx, word ptr [eax + field_2a]         # 00465d9f
    shl ecx, 0x4                                 # 00465da3
    mov eax, dword ptr [ebp - local_4]           # 00465da6
    cmp edx, dword ptr [eax + ecx + field_fc]    # 00465da9
    jl.d32 L_00465e3b                            # 00465db0
    # block 0x00465db6: entered by fall-through of jl at 0x00465db0, 7 instruction(s), ends with jg to 0x00465e3b (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00465db6
    mov edx, dword ptr [ebp - local_c]           # 00465dba
    movsx eax, word ptr [edx + field_2a]         # 00465dbd
    shl eax, 0x4                                 # 00465dc1
    mov edx, dword ptr [ebp - local_4]           # 00465dc4
    cmp ecx, dword ptr [edx + eax + field_104]   # 00465dc7
    jg.d8 L_00465e3b                             # 00465dce
    # block 0x00465dd0: entered by fall-through of jg at 0x00465dce, 7 instruction(s), ends with jge to 0x00465e3b (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00465dd0
    mov ecx, dword ptr [ebp - local_c]           # 00465dd4
    movsx edx, word ptr [ecx + field_2a]         # 00465dd7
    shl edx, 0x4                                 # 00465ddb
    mov ecx, dword ptr [ebp - local_4]           # 00465dde
    cmp eax, dword ptr [ecx + edx + field_100]   # 00465de1
    jge.d8 L_00465e3b                            # 00465de8
    # block 0x00465dea: entered by fall-through of jge at 0x00465de8, 9 instruction(s), ends with jle to 0x00465e3b (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00465dea
    mov eax, dword ptr [ebp - local_c]           # 00465dee
    movsx ecx, word ptr [eax + field_2a]         # 00465df1
    shl ecx, 0x4                                 # 00465df5
    mov eax, dword ptr [ebp - local_4]           # 00465df8
    mov ecx, dword ptr [eax + ecx + field_f8]    # 00465dfb
    add ecx, dword ptr [ebp - local_8]           # 00465e02
    {load} cmp edx, ecx                          # 00465e05
    jle.d8 L_00465e3b                            # 00465e07
    # block 0x00465e09: entered by fall-through of jle at 0x00465e07, 4 instruction(s), ends with jne to 0x00465e3b (forward)
    mov edx, dword ptr [ebp - local_c]           # 00465e09
    movsx eax, word ptr [edx + field_2c]         # 00465e0c
    test eax, eax                                # 00465e10
    jne.d8 L_00465e3b                            # 00465e12
    # block 0x00465e14: entered by fall-through of jne at 0x00465e12, 4 instruction(s), ends with jge to 0x00465e3b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00465e14
    movsx edx, word ptr [ecx + field_2a]         # 00465e17
    cmp edx, 0x7                                 # 00465e1b
    jge.d8 L_00465e3b                            # 00465e1e
    # block 0x00465e20: entered by fall-through of jge at 0x00465e1e, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x3                                     # 00465e20
    push 0x1a                                    # 00465e22
    push 0x27d2                                  # 00465e24
    mov ecx, dword ptr [ebp - local_c]           # 00465e29
    call FUN_00465f8e                            # 00465e2c
    mov eax, 0x1                                 # 00465e31
    jmp.d32 L_00465f87                           # 00465e36
L_00465e3b:
    # block 0x00465e3b: entered by jl at 0x00465db0; jg at 0x00465dce; jge at 0x00465de8; jle at 0x00465e07; more, 4 instruction(s), ends with jl to 0x00465e86 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00465e3b
    mov ecx, dword ptr [ebp - local_4]           # 00465e3f
    cmp eax, dword ptr [ecx + field_6c]          # 00465e42
    jl.d8 L_00465e86                             # 00465e45
    # block 0x00465e47: entered by fall-through of jl at 0x00465e45, 4 instruction(s), ends with jg to 0x00465e86 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00465e47
    mov eax, dword ptr [ebp - local_4]           # 00465e4b
    cmp edx, dword ptr [eax + field_74]          # 00465e4e
    jg.d8 L_00465e86                             # 00465e51
    # block 0x00465e53: entered by fall-through of jg at 0x00465e51, 4 instruction(s), ends with jl to 0x00465e86 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00465e53
    mov edx, dword ptr [ebp - local_4]           # 00465e57
    cmp ecx, dword ptr [edx + field_68]          # 00465e5a
    jl.d8 L_00465e86                             # 00465e5d
    # block 0x00465e5f: entered by fall-through of jl at 0x00465e5d, 4 instruction(s), ends with jg to 0x00465e86 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00465e5f
    mov ecx, dword ptr [ebp - local_4]           # 00465e63
    cmp eax, dword ptr [ecx + field_70]          # 00465e66
    jg.d8 L_00465e86                             # 00465e69
    # block 0x00465e6b: entered by fall-through of jg at 0x00465e69, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x1                                     # 00465e6b
    push 0x16                                    # 00465e6d
    push 0x27d2                                  # 00465e6f
    mov ecx, dword ptr [ebp - local_c]           # 00465e74
    call FUN_00465f8e                            # 00465e77
    mov eax, 0x1                                 # 00465e7c
    jmp.d32 L_00465f87                           # 00465e81
L_00465e86:
    # block 0x00465e86: entered by jl at 0x00465e45; jg at 0x00465e51; jl at 0x00465e5d; jg at 0x00465e69, 4 instruction(s), ends with jl to 0x00465edd (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00465e86
    mov eax, dword ptr [ebp - local_4]           # 00465e8a
    cmp edx, dword ptr [eax + field_5c]          # 00465e8d
    jl.d8 L_00465edd                             # 00465e90
    # block 0x00465e92: entered by fall-through of jl at 0x00465e90, 4 instruction(s), ends with jg to 0x00465edd (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00465e92
    mov edx, dword ptr [ebp - local_4]           # 00465e96
    cmp ecx, dword ptr [edx + field_64]          # 00465e99
    jg.d8 L_00465edd                             # 00465e9c
    # block 0x00465e9e: entered by fall-through of jg at 0x00465e9c, 4 instruction(s), ends with jl to 0x00465edd (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00465e9e
    mov ecx, dword ptr [ebp - local_4]           # 00465ea2
    cmp eax, dword ptr [ecx + field_58]          # 00465ea5
    jl.d8 L_00465edd                             # 00465ea8
    # block 0x00465eaa: entered by fall-through of jl at 0x00465ea8, 4 instruction(s), ends with jg to 0x00465edd (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00465eaa
    mov eax, dword ptr [ebp - local_4]           # 00465eae
    cmp edx, dword ptr [eax + field_60]          # 00465eb1
    jg.d8 L_00465edd                             # 00465eb4
    # block 0x00465eb6: entered by fall-through of jg at 0x00465eb4, 4 instruction(s), ends with jge to 0x00465edd (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00465eb6
    movsx edx, word ptr [ecx + field_2c]         # 00465eb9
    cmp edx, 0x3                                 # 00465ebd
    jge.d8 L_00465edd                            # 00465ec0
    # block 0x00465ec2: entered by fall-through of jge at 0x00465ec0, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x4                                     # 00465ec2
    push 0x14                                    # 00465ec4
    push 0x27d2                                  # 00465ec6
    mov ecx, dword ptr [ebp - local_c]           # 00465ecb
    call FUN_00465f8e                            # 00465ece
    mov eax, 0x1                                 # 00465ed3
    jmp.d32 L_00465f87                           # 00465ed8
L_00465edd:
    # block 0x00465edd: entered by jl at 0x00465e90; jg at 0x00465e9c; jl at 0x00465ea8; jg at 0x00465eb4; jge at 0x00465ec0, 4 instruction(s), ends with jl to 0x00465f31 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00465edd
    mov ecx, dword ptr [ebp - local_4]           # 00465ee1
    cmp eax, dword ptr [ecx + field_5c]          # 00465ee4
    jl.d8 L_00465f31                             # 00465ee7
    # block 0x00465ee9: entered by fall-through of jl at 0x00465ee7, 4 instruction(s), ends with jg to 0x00465f31 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00465ee9
    mov eax, dword ptr [ebp - local_4]           # 00465eed
    cmp edx, dword ptr [eax + field_64]          # 00465ef0
    jg.d8 L_00465f31                             # 00465ef3
    # block 0x00465ef5: entered by fall-through of jg at 0x00465ef3, 4 instruction(s), ends with jl to 0x00465f31 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00465ef5
    mov edx, dword ptr [ebp - local_4]           # 00465ef9
    cmp ecx, dword ptr [edx + field_58]          # 00465efc
    jl.d8 L_00465f31                             # 00465eff
    # block 0x00465f01: entered by fall-through of jl at 0x00465eff, 4 instruction(s), ends with jg to 0x00465f31 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00465f01
    mov ecx, dword ptr [ebp - local_4]           # 00465f05
    cmp eax, dword ptr [ecx + field_60]          # 00465f08
    jg.d8 L_00465f31                             # 00465f0b
    # block 0x00465f0d: entered by fall-through of jg at 0x00465f0b, 4 instruction(s), ends with jne to 0x00465f31 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00465f0d
    movsx eax, word ptr [edx + field_2c]         # 00465f10
    cmp eax, 0x3                                 # 00465f14
    jne.d8 L_00465f31                            # 00465f17
    # block 0x00465f19: entered by fall-through of jne at 0x00465f17, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x4                                     # 00465f19
    push 0x15                                    # 00465f1b
    push 0x27d2                                  # 00465f1d
    mov ecx, dword ptr [ebp - local_c]           # 00465f22
    call FUN_00465f8e                            # 00465f25
    mov eax, 0x1                                 # 00465f2a
    jmp.d8 L_00465f87                            # 00465f2f
L_00465f31:
    # block 0x00465f31: entered by jl at 0x00465ee7; jg at 0x00465ef3; jl at 0x00465eff; jg at 0x00465f0b; jne at 0x00465f17, 4 instruction(s), ends with jl to 0x00465f85 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00465f31
    mov edx, dword ptr [ebp - local_4]           # 00465f35
    cmp ecx, dword ptr [edx + field_553]         # 00465f38
    jl.d8 L_00465f85                             # 00465f3e
    # block 0x00465f40: entered by fall-through of jl at 0x00465f3e, 4 instruction(s), ends with jg to 0x00465f85 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00465f40
    mov ecx, dword ptr [ebp - local_4]           # 00465f44
    cmp eax, dword ptr [ecx + field_55b]         # 00465f47
    jg.d8 L_00465f85                             # 00465f4d
    # block 0x00465f4f: entered by fall-through of jg at 0x00465f4d, 4 instruction(s), ends with jl to 0x00465f85 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00465f4f
    mov eax, dword ptr [ebp - local_4]           # 00465f53
    cmp edx, dword ptr [eax + field_54f]         # 00465f56
    jl.d8 L_00465f85                             # 00465f5c
    # block 0x00465f5e: entered by fall-through of jl at 0x00465f5c, 4 instruction(s), ends with jg to 0x00465f85 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00465f5e
    mov edx, dword ptr [ebp - local_4]           # 00465f62
    cmp ecx, dword ptr [edx + field_557]         # 00465f65
    jg.d8 L_00465f85                             # 00465f6b
    # block 0x00465f6d: entered by fall-through of jg at 0x00465f6b, 7 instruction(s), calls FUN_00465f8e, ends with forward jump to 0x00465f87
    push 0x0                                     # 00465f6d
    push 0x0                                     # 00465f6f
    push 0x27d3                                  # 00465f71
    mov ecx, dword ptr [ebp - local_c]           # 00465f76
    call FUN_00465f8e                            # 00465f79
    mov eax, 0x1                                 # 00465f7e
    jmp.d8 L_00465f87                            # 00465f83
L_00465f85:
    # block 0x00465f85: entered by je at 0x00465caa; jl at 0x00465f3e; jg at 0x00465f4d; jl at 0x00465f5c; jg at 0x00465f6b, 1 instruction(s), falls into the block at 0x00465f87
    {load} xor eax, eax                          # 00465f85
L_00465f87:
    # block 0x00465f87: entered by jmp at 0x00465d93; jmp at 0x00465e36; jmp at 0x00465e81; jmp at 0x00465ed8; more, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 00465f87
    {load} mov esp, ebp                          # 00465f88
    pop ebp                                      # 00465f8a
    ret 0x8                                      # 00465f8b

