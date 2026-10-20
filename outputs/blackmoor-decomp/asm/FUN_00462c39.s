# FUN_00462c39
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00462c39
# extent:       0x00462c39-0x004630a3 (1130 code bytes)
# span:         0x00462c39-0x004630a3 (code 1130, tables 0, padding 0)
# sha256:       f242443d2b87a491ff7710452b6ce103b86736cb167f4b658e55542a8d4040e1
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m462c39_pointer_move
# naming:       native port src/original_methods_fl21a.c:m462c39_pointer_move (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m462c39_pointer_move. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on 300 random fixtures, every instruction reached. Oracle window runs all 1130 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_22, field_3f, field_5d, field_353; [ecx + n] field_1e, field_24, field_5b, field_34b, field_34f; [edx + n] field_39, field_4f, field_53, field_57, field_347
# callees:      calls FUN_004619be, FUN_004630a3
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.h:cpz_pointer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 298 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_39, 0x39  # offset +0x39
.equ field_3f, 0x3f  # offset +0x3f
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_57, 0x57  # offset +0x57
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d
.equ field_347, 0x347  # offset +0x347
.equ field_34b, 0x34b  # offset +0x34b
.equ field_34f, 0x34f  # offset +0x34f
.equ field_353, 0x353  # offset +0x353

# --- external targets -----------------------------------------------
.set FUN_004619be, .text + (0x004619be - 0x401000)
.set FUN_004630a3, .text + (0x004630a3 - 0x401000)

.org 0x00462c39 - 0x401000
.globl FUN_00462c39
FUN_00462c39:
    # block 0x00462c39: entry, 9 instruction(s), ends with je to 0x00463099 (forward)
    push ebp                                     # 00462c39
    {load} mov ebp, esp                          # 00462c3a
    sub esp, 0x1c                                # 00462c3c
    push esi                                     # 00462c3f
    mov dword ptr [ebp - local_1c], ecx          # 00462c40
    mov dword ptr [ebp - local_4], 0x0           # 00462c43
    mov eax, dword ptr [ebp - local_1c]          # 00462c4a
    cmp dword ptr [eax + field_3f], 0x0          # 00462c4d
    je.d32 L_00463099                            # 00462c51
    # block 0x00462c57: entered by fall-through of je at 0x00462c51, 3 instruction(s), ends with je to 0x00463099 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00462c57
    cmp dword ptr [ecx + field_24], 0x2          # 00462c5a
    je.d32 L_00463099                            # 00462c5e
    # block 0x00462c64: entered by fall-through of je at 0x00462c5e, 13 instruction(s), ends with forward jump to 0x00462ca8
    movsx edx, word ptr [ebp + arg_8]            # 00462c64
    add edx, dword ptr [0x583186]                # 00462c68
    mov dword ptr [ebp - local_18], edx          # 00462c6e
    movsx eax, word ptr [ebp + arg_c]            # 00462c71
    add eax, dword ptr [0x58318a]                # 00462c75
    mov dword ptr [ebp - local_14], eax          # 00462c7b
    mov ecx, dword ptr [ebp - local_1c]          # 00462c7e
    movsx edx, word ptr [ecx + field_1e]         # 00462c81
    imul edx, edx, 0x8d                          # 00462c85
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00462c8b
    mov dword ptr [ebp - local_c], eax           # 00462c91
    mov word ptr [ebp - local_8], 0x0            # 00462c94
    jmp.d8 L_00462ca8                            # 00462c9a
L_00462c9c:
    # block 0x00462c9c: entered by jmp at 0x0046303b, 3 instruction(s), falls into the block at 0x00462ca8
    mov cx, word ptr [ebp - local_8]             # 00462c9c
    add cx, 0x1                                  # 00462ca0
    mov word ptr [ebp - local_8], cx             # 00462ca4
L_00462ca8:
    # block 0x00462ca8: entered by jmp at 0x00462c9a, 5 instruction(s), ends with jge to 0x00463040 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462ca8
    mov eax, dword ptr [ebp - local_c]           # 00462cac
    movsx ecx, word ptr [eax + field_22]         # 00462caf
    {load} cmp edx, ecx                          # 00462cb3
    jge.d32 L_00463040                           # 00462cb5
    # block 0x00462cbb: entered by fall-through of jge at 0x00462cb5, 2 instruction(s), ends with forward jump to 0x00462ccf
    mov word ptr [ebp - local_10], 0x0           # 00462cbb
    jmp.d8 L_00462ccf                            # 00462cc1
L_00462cc3:
    # block 0x00462cc3: entered by jmp at 0x00463036, 3 instruction(s), falls into the block at 0x00462ccf
    mov dx, word ptr [ebp - local_10]            # 00462cc3
    add dx, 0x1                                  # 00462cc7
    mov word ptr [ebp - local_10], dx            # 00462ccb
L_00462ccf:
    # block 0x00462ccf: entered by jmp at 0x00462cc1, 5 instruction(s), ends with jge to 0x0046303b (forward)
    movsx eax, word ptr [ebp - local_10]         # 00462ccf
    mov ecx, dword ptr [ebp - local_c]           # 00462cd3
    movsx edx, word ptr [ecx + field_24]         # 00462cd6
    {load} cmp eax, edx                          # 00462cda
    jge.d32 L_0046303b                           # 00462cdc
    # block 0x00462ce2: entered by fall-through of jge at 0x00462cdc, 7 instruction(s), ends with je to 0x00463036 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00462ce2
    imul eax, eax, 0x140                         # 00462ce6
    movsx ecx, word ptr [ebp - local_10]         # 00462cec
    imul ecx, ecx, 0x28                          # 00462cf0
    movsx edx, word ptr [eax + ecx + 0x594ddb]   # 00462cf3
    test edx, edx                                # 00462cfb
    je.d32 L_00463036                            # 00462cfd
    # block 0x00462d03: entered by fall-through of je at 0x00462cfd, 20 instruction(s), ends with jl to 0x00462e0a (forward)
    movsx eax, word ptr [ebp - local_8]          # 00462d03
    imul eax, eax, 0x140                         # 00462d07
    movsx ecx, word ptr [ebp - local_10]         # 00462d0d
    imul ecx, ecx, 0x28                          # 00462d11
    mov edx, dword ptr [ebp - local_1c]          # 00462d14
    mov ax, word ptr [eax + ecx + 0x594ddb]      # 00462d17
    mov word ptr [edx + field_39], ax            # 00462d1f
    mov ecx, dword ptr [ebp - local_1c]          # 00462d23
    mov dx, word ptr [ebp - local_8]             # 00462d26
    mov word ptr [ecx + field_5b], dx            # 00462d2a
    mov eax, dword ptr [ebp - local_1c]          # 00462d2e
    mov cx, word ptr [ebp - local_10]            # 00462d31
    mov word ptr [eax + field_5d], cx            # 00462d35
    movsx edx, word ptr [ebp - local_8]          # 00462d39
    imul edx, edx, 0x140                         # 00462d3d
    movsx eax, word ptr [ebp - local_10]         # 00462d43
    imul eax, eax, 0x28                          # 00462d47
    mov ecx, dword ptr [ebp - local_14]          # 00462d4a
    cmp ecx, dword ptr [edx + eax + 0x594dcd]    # 00462d4d
    jl.d32 L_00462e0a                            # 00462d54
    # block 0x00462d5a: entered by fall-through of jl at 0x00462d54, 13 instruction(s), ends with jge to 0x00462e0a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462d5a
    imul ecx, ecx, 0x140                         # 00462d5e
    movsx esi, word ptr [ebp - local_10]         # 00462d64
    imul esi, esi, 0x28                          # 00462d68
    mov edx, dword ptr [ebp - local_1c]          # 00462d6b
    mov eax, dword ptr [edx + field_53]          # 00462d6e
    cdq                                          # 00462d71
    {load} sub eax, edx                          # 00462d72
    sar eax                                      # 00462d74
    mov ecx, dword ptr [ecx + esi + 0x594dcd]    # 00462d76
    {load} add ecx, eax                          # 00462d7d
    cmp dword ptr [ebp - local_14], ecx          # 00462d7f
    jge.d32 L_00462e0a                           # 00462d82
    # block 0x00462d88: entered by fall-through of jge at 0x00462d82, 14 instruction(s), ends with jle to 0x00462e0a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462d88
    imul ecx, ecx, 0x140                         # 00462d8c
    movsx esi, word ptr [ebp - local_10]         # 00462d92
    imul esi, esi, 0x28                          # 00462d96
    mov edx, dword ptr [ebp - local_1c]          # 00462d99
    mov eax, dword ptr [edx + field_4f]          # 00462d9c
    cdq                                          # 00462d9f
    and edx, 0x3                                 # 00462da0
    {load} add eax, edx                          # 00462da3
    sar eax, 0x2                                 # 00462da5
    mov ecx, dword ptr [ecx + esi + 0x594dc9]    # 00462da8
    {load} add ecx, eax                          # 00462daf
    cmp dword ptr [ebp - local_18], ecx          # 00462db1
    jle.d8 L_00462e0a                            # 00462db4
    # block 0x00462db6: entered by fall-through of jle at 0x00462db4, 14 instruction(s), ends with jge to 0x00462e0a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462db6
    imul ecx, ecx, 0x140                         # 00462dba
    movsx esi, word ptr [ebp - local_10]         # 00462dc0
    imul esi, esi, 0x28                          # 00462dc4
    mov edx, dword ptr [ebp - local_1c]          # 00462dc7
    mov eax, dword ptr [edx + field_4f]          # 00462dca
    cdq                                          # 00462dcd
    and edx, 0x3                                 # 00462dce
    {load} add eax, edx                          # 00462dd1
    sar eax, 0x2                                 # 00462dd3
    mov ecx, dword ptr [ecx + esi + 0x594dd1]    # 00462dd6
    {load} sub ecx, eax                          # 00462ddd
    cmp dword ptr [ebp - local_18], ecx          # 00462ddf
    jge.d8 L_00462e0a                            # 00462de2
    # block 0x00462de4: entered by fall-through of jge at 0x00462de2, 5 instruction(s), calls FUN_004619be, ends with jne to 0x00462e0a (forward)
    push 0x11                                    # 00462de4
    mov ecx, dword ptr [ebp - local_1c]          # 00462de6
    call FUN_004619be                            # 00462de9
    cmp eax, 0x1                                 # 00462dee
    jne.d8 L_00462e0a                            # 00462df1
    # block 0x00462df3: entered by fall-through of jne at 0x00462df1, 5 instruction(s), calls FUN_004630a3, ends with forward jump to 0x0046309c
    push 0x2781                                  # 00462df3
    mov ecx, dword ptr [ebp - local_1c]          # 00462df8
    call FUN_004630a3                            # 00462dfb
    mov eax, 0x1                                 # 00462e00
    jmp.d32 L_0046309c                           # 00462e05
L_00462e0a:
    # block 0x00462e0a: entered by jl at 0x00462d54; jge at 0x00462d82; jle at 0x00462db4; jge at 0x00462de2; more, 7 instruction(s), ends with jl to 0x00462eb9 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462e0a
    imul edx, edx, 0x140                         # 00462e0e
    movsx eax, word ptr [ebp - local_10]         # 00462e14
    imul eax, eax, 0x28                          # 00462e18
    mov ecx, dword ptr [ebp - local_14]          # 00462e1b
    cmp ecx, dword ptr [edx + eax + 0x594dcd]    # 00462e1e
    jl.d32 L_00462eb9                            # 00462e25
    # block 0x00462e2b: entered by fall-through of jl at 0x00462e25, 7 instruction(s), ends with jg to 0x00462eb9 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462e2b
    imul edx, edx, 0x140                         # 00462e2f
    movsx eax, word ptr [ebp - local_10]         # 00462e35
    imul eax, eax, 0x28                          # 00462e39
    mov ecx, dword ptr [ebp - local_14]          # 00462e3c
    cmp ecx, dword ptr [edx + eax + 0x594dd5]    # 00462e3f
    jg.d8 L_00462eb9                             # 00462e46
    # block 0x00462e48: entered by fall-through of jg at 0x00462e46, 14 instruction(s), ends with jle to 0x00462eb9 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462e48
    imul ecx, ecx, 0x140                         # 00462e4c
    movsx esi, word ptr [ebp - local_10]         # 00462e52
    imul esi, esi, 0x28                          # 00462e56
    mov edx, dword ptr [ebp - local_1c]          # 00462e59
    mov eax, dword ptr [edx + field_4f]          # 00462e5c
    cdq                                          # 00462e5f
    and edx, 0x3                                 # 00462e60
    {load} add eax, edx                          # 00462e63
    sar eax, 0x2                                 # 00462e65
    mov ecx, dword ptr [ecx + esi + 0x594dd1]    # 00462e68
    {load} sub ecx, eax                          # 00462e6f
    cmp dword ptr [ebp - local_18], ecx          # 00462e71
    jle.d8 L_00462eb9                            # 00462e74
    # block 0x00462e76: entered by fall-through of jle at 0x00462e74, 7 instruction(s), ends with jg to 0x00462eb9 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462e76
    imul edx, edx, 0x140                         # 00462e7a
    movsx eax, word ptr [ebp - local_10]         # 00462e80
    imul eax, eax, 0x28                          # 00462e84
    mov ecx, dword ptr [ebp - local_18]          # 00462e87
    cmp ecx, dword ptr [edx + eax + 0x594dd1]    # 00462e8a
    jg.d8 L_00462eb9                             # 00462e91
    # block 0x00462e93: entered by fall-through of jg at 0x00462e91, 5 instruction(s), calls FUN_004619be, ends with jne to 0x00462eb9 (forward)
    push 0x13                                    # 00462e93
    mov ecx, dword ptr [ebp - local_1c]          # 00462e95
    call FUN_004619be                            # 00462e98
    cmp eax, 0x1                                 # 00462e9d
    jne.d8 L_00462eb9                            # 00462ea0
    # block 0x00462ea2: entered by fall-through of jne at 0x00462ea0, 5 instruction(s), calls FUN_004630a3, ends with forward jump to 0x0046309c
    push 0x2783                                  # 00462ea2
    mov ecx, dword ptr [ebp - local_1c]          # 00462ea7
    call FUN_004630a3                            # 00462eaa
    mov eax, 0x1                                 # 00462eaf
    jmp.d32 L_0046309c                           # 00462eb4
L_00462eb9:
    # block 0x00462eb9: entered by jl at 0x00462e25; jg at 0x00462e46; jle at 0x00462e74; jg at 0x00462e91; jne at 0x00462ea0, 13 instruction(s), ends with jl to 0x00462f8a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462eb9
    imul ecx, ecx, 0x140                         # 00462ebd
    movsx esi, word ptr [ebp - local_10]         # 00462ec3
    imul esi, esi, 0x28                          # 00462ec7
    mov edx, dword ptr [ebp - local_1c]          # 00462eca
    mov eax, dword ptr [edx + field_53]          # 00462ecd
    cdq                                          # 00462ed0
    {load} sub eax, edx                          # 00462ed1
    sar eax                                      # 00462ed3
    mov ecx, dword ptr [ecx + esi + 0x594dd5]    # 00462ed5
    {load} sub ecx, eax                          # 00462edc
    cmp dword ptr [ebp - local_14], ecx          # 00462ede
    jl.d32 L_00462f8a                            # 00462ee1
    # block 0x00462ee7: entered by fall-through of jl at 0x00462ee1, 7 instruction(s), ends with jg to 0x00462f8a (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462ee7
    imul edx, edx, 0x140                         # 00462eeb
    movsx eax, word ptr [ebp - local_10]         # 00462ef1
    imul eax, eax, 0x28                          # 00462ef5
    mov ecx, dword ptr [ebp - local_14]          # 00462ef8
    cmp ecx, dword ptr [edx + eax + 0x594dd5]    # 00462efb
    jg.d32 L_00462f8a                            # 00462f02
    # block 0x00462f08: entered by fall-through of jg at 0x00462f02, 14 instruction(s), ends with jle to 0x00462f8a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462f08
    imul ecx, ecx, 0x140                         # 00462f0c
    movsx esi, word ptr [ebp - local_10]         # 00462f12
    imul esi, esi, 0x28                          # 00462f16
    mov edx, dword ptr [ebp - local_1c]          # 00462f19
    mov eax, dword ptr [edx + field_4f]          # 00462f1c
    cdq                                          # 00462f1f
    and edx, 0x3                                 # 00462f20
    {load} add eax, edx                          # 00462f23
    sar eax, 0x2                                 # 00462f25
    mov ecx, dword ptr [ecx + esi + 0x594dc9]    # 00462f28
    {load} add ecx, eax                          # 00462f2f
    cmp dword ptr [ebp - local_18], ecx          # 00462f31
    jle.d8 L_00462f8a                            # 00462f34
    # block 0x00462f36: entered by fall-through of jle at 0x00462f34, 14 instruction(s), ends with jge to 0x00462f8a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462f36
    imul ecx, ecx, 0x140                         # 00462f3a
    movsx esi, word ptr [ebp - local_10]         # 00462f40
    imul esi, esi, 0x28                          # 00462f44
    mov edx, dword ptr [ebp - local_1c]          # 00462f47
    mov eax, dword ptr [edx + field_4f]          # 00462f4a
    cdq                                          # 00462f4d
    and edx, 0x3                                 # 00462f4e
    {load} add eax, edx                          # 00462f51
    sar eax, 0x2                                 # 00462f53
    mov ecx, dword ptr [ecx + esi + 0x594dd1]    # 00462f56
    {load} sub ecx, eax                          # 00462f5d
    cmp dword ptr [ebp - local_18], ecx          # 00462f5f
    jge.d8 L_00462f8a                            # 00462f62
    # block 0x00462f64: entered by fall-through of jge at 0x00462f62, 5 instruction(s), calls FUN_004619be, ends with jne to 0x00462f8a (forward)
    push 0x12                                    # 00462f64
    mov ecx, dword ptr [ebp - local_1c]          # 00462f66
    call FUN_004619be                            # 00462f69
    cmp eax, 0x1                                 # 00462f6e
    jne.d8 L_00462f8a                            # 00462f71
    # block 0x00462f73: entered by fall-through of jne at 0x00462f71, 5 instruction(s), calls FUN_004630a3, ends with forward jump to 0x0046309c
    push 0x2782                                  # 00462f73
    mov ecx, dword ptr [ebp - local_1c]          # 00462f78
    call FUN_004630a3                            # 00462f7b
    mov eax, 0x1                                 # 00462f80
    jmp.d32 L_0046309c                           # 00462f85
L_00462f8a:
    # block 0x00462f8a: entered by jl at 0x00462ee1; jg at 0x00462f02; jle at 0x00462f34; jge at 0x00462f62; more, 7 instruction(s), ends with jl to 0x00463036 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462f8a
    imul edx, edx, 0x140                         # 00462f8e
    movsx eax, word ptr [ebp - local_10]         # 00462f94
    imul eax, eax, 0x28                          # 00462f98
    mov ecx, dword ptr [ebp - local_14]          # 00462f9b
    cmp ecx, dword ptr [edx + eax + 0x594dcd]    # 00462f9e
    jl.d32 L_00463036                            # 00462fa5
    # block 0x00462fab: entered by fall-through of jl at 0x00462fa5, 7 instruction(s), ends with jg to 0x00463036 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462fab
    imul edx, edx, 0x140                         # 00462faf
    movsx eax, word ptr [ebp - local_10]         # 00462fb5
    imul eax, eax, 0x28                          # 00462fb9
    mov ecx, dword ptr [ebp - local_14]          # 00462fbc
    cmp ecx, dword ptr [edx + eax + 0x594dd5]    # 00462fbf
    jg.d8 L_00463036                             # 00462fc6
    # block 0x00462fc8: entered by fall-through of jg at 0x00462fc6, 7 instruction(s), ends with jl to 0x00463036 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00462fc8
    imul edx, edx, 0x140                         # 00462fcc
    movsx eax, word ptr [ebp - local_10]         # 00462fd2
    imul eax, eax, 0x28                          # 00462fd6
    mov ecx, dword ptr [ebp - local_18]          # 00462fd9
    cmp ecx, dword ptr [edx + eax + 0x594dc9]    # 00462fdc
    jl.d8 L_00463036                             # 00462fe3
    # block 0x00462fe5: entered by fall-through of jl at 0x00462fe3, 14 instruction(s), ends with jge to 0x00463036 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00462fe5
    imul ecx, ecx, 0x140                         # 00462fe9
    movsx esi, word ptr [ebp - local_10]         # 00462fef
    imul esi, esi, 0x28                          # 00462ff3
    mov edx, dword ptr [ebp - local_1c]          # 00462ff6
    mov eax, dword ptr [edx + field_4f]          # 00462ff9
    cdq                                          # 00462ffc
    and edx, 0x3                                 # 00462ffd
    {load} add eax, edx                          # 00463000
    sar eax, 0x2                                 # 00463002
    mov ecx, dword ptr [ecx + esi + 0x594dc9]    # 00463005
    {load} add ecx, eax                          # 0046300c
    cmp dword ptr [ebp - local_18], ecx          # 0046300e
    jge.d8 L_00463036                            # 00463011
    # block 0x00463013: entered by fall-through of jge at 0x00463011, 5 instruction(s), calls FUN_004619be, ends with jne to 0x00463036 (forward)
    push 0x10                                    # 00463013
    mov ecx, dword ptr [ebp - local_1c]          # 00463015
    call FUN_004619be                            # 00463018
    cmp eax, 0x1                                 # 0046301d
    jne.d8 L_00463036                            # 00463020
    # block 0x00463022: entered by fall-through of jne at 0x00463020, 5 instruction(s), calls FUN_004630a3, ends with forward jump to 0x0046309c
    push 0x2780                                  # 00463022
    mov ecx, dword ptr [ebp - local_1c]          # 00463027
    call FUN_004630a3                            # 0046302a
    mov eax, 0x1                                 # 0046302f
    jmp.d8 L_0046309c                            # 00463034
L_00463036:
    # block 0x00463036: entered by je at 0x00462cfd; jl at 0x00462fa5; jg at 0x00462fc6; jl at 0x00462fe3; more, 1 instruction(s), ends with backward jump to 0x00462cc3
    jmp.d32 L_00462cc3                           # 00463036
L_0046303b:
    # block 0x0046303b: entered by jge at 0x00462cdc, 1 instruction(s), ends with backward jump to 0x00462c9c
    jmp.d32 L_00462c9c                           # 0046303b
L_00463040:
    # block 0x00463040: entered by jge at 0x00462cb5, 6 instruction(s), ends with jl to 0x00463099 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00463040
    mov word ptr [edx + field_57], 0x0           # 00463043
    movsx eax, word ptr [ebp + arg_c]            # 00463049
    mov ecx, dword ptr [ebp - local_c]           # 0046304d
    cmp eax, dword ptr [ecx + field_34b]         # 00463050
    jl.d8 L_00463099                             # 00463056
    # block 0x00463058: entered by fall-through of jl at 0x00463056, 4 instruction(s), ends with jg to 0x00463099 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00463058
    mov eax, dword ptr [ebp - local_c]           # 0046305c
    cmp edx, dword ptr [eax + field_353]         # 0046305f
    jg.d8 L_00463099                             # 00463065
    # block 0x00463067: entered by fall-through of jg at 0x00463065, 4 instruction(s), ends with jl to 0x00463099 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00463067
    mov edx, dword ptr [ebp - local_c]           # 0046306b
    cmp ecx, dword ptr [edx + field_347]         # 0046306e
    jl.d8 L_00463099                             # 00463074
    # block 0x00463076: entered by fall-through of jl at 0x00463074, 4 instruction(s), ends with jg to 0x00463099 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00463076
    mov ecx, dword ptr [ebp - local_c]           # 0046307a
    cmp eax, dword ptr [ecx + field_34f]         # 0046307d
    jg.d8 L_00463099                             # 00463083
    # block 0x00463085: entered by fall-through of jg at 0x00463083, 4 instruction(s), calls FUN_004630a3, falls into the block at 0x00463099
    push 0x277f                                  # 00463085
    mov ecx, dword ptr [ebp - local_1c]          # 0046308a
    call FUN_004630a3                            # 0046308d
    mov dword ptr [ebp - local_4], 0x1           # 00463092
L_00463099:
    # block 0x00463099: entered by je at 0x00462c51; je at 0x00462c5e; jl at 0x00463056; jg at 0x00463065; more, 1 instruction(s), falls into the block at 0x0046309c
    mov eax, dword ptr [ebp - local_4]           # 00463099
L_0046309c:
    # block 0x0046309c: entered by jmp at 0x00462e05; jmp at 0x00462eb4; jmp at 0x00462f85; jmp at 0x00463034, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 0046309c
    {load} mov esp, ebp                          # 0046309d
    pop ebp                                      # 0046309f
    ret 0x8                                      # 004630a0

