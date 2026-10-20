# FUN_00412db8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00412db8
# extent:       0x00412db8-0x00413187 (975 code bytes)
# span:         0x00412db8-0x00413187 (code 975, tables 0, padding 0)
# sha256:       cbd6972b7166dd58cf6b240f8b5f7d61212c4e1f5c43cd70ff9beea343f1468b
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m412db8_wrap_text
# naming:       native port src/original_methods_fl20c.c:m412db8_wrap_text (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m412db8_wrap_text. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 975 bytes.
# arguments:    10 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c; ret 0x28 (callee pops 40 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_1394, local_1398
# fields:       [ecx + n] field_292e, field_2938, field_2942; [edx + n] field_293c, field_293e
# callees:      calls FUN_0050c920, FUN_0050ca3e, FUN_004264e8, FUN_004d3836, FUN_004d270b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20c.c:m412db8_wrap_text (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 258 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_1394, 0x1394  # offset -0x1394
.equ local_1398, 0x1398  # offset -0x1398
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c
.equ field_292e, 0x292e  # offset +0x292e
.equ field_2938, 0x2938  # offset +0x2938
.equ field_293c, 0x293c  # offset +0x293c
.equ field_293e, 0x293e  # offset +0x293e
.equ field_2942, 0x2942  # offset +0x2942

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004d270b, .text + (0x004d270b - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00412db8 - 0x401000
.globl FUN_00412db8
FUN_00412db8:
    # block 0x00412db8: entry, 14 instruction(s), calls FUN_0050c920, falls into the block at 0x00412def
    push ebp                                     # 00412db8
    {load} mov ebp, esp                          # 00412db9
    mov eax, 0x1398                              # 00412dbb
    call FUN_0050c920                            # 00412dc0
    push esi                                     # 00412dc5
    push edi                                     # 00412dc6
    mov dword ptr [ebp - local_1398], ecx        # 00412dc7
    mov dword ptr [ebp - local_4], 0x0           # 00412dcd
    mov ecx, 0x4e2                               # 00412dd4
    {load} xor eax, eax                          # 00412dd9
    lea edi, [ebp - local_1394]                  # 00412ddb
    rep stosd dword ptr es:[edi], eax            # 00412de1
    mov word ptr [ebp - local_c], 0x0            # 00412de3
    mov word ptr [ebp - local_8], 0x0            # 00412de9
L_00412def:
    # block 0x00412def: entered by jmp at 0x0041316e, 3 instruction(s), ends with je to 0x00413173 (forward)
    mov eax, 0x1                                 # 00412def
    test eax, eax                                # 00412df4
    je.d32 L_00413173                            # 00412df6
    # block 0x00412dfc: entered by fall-through of je at 0x00412df6, 3 instruction(s), ends with je to 0x00412f1d (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 00412dfc
    cmp dword ptr [ecx], 0x0                     # 00412dff
    je.d32 L_00412f1d                            # 00412e02
    # block 0x00412e08: entered by fall-through of je at 0x00412e02, 3 instruction(s), ends with je to 0x00412e39 (forward)
    mov edx, dword ptr [ebp - local_1398]        # 00412e08
    cmp dword ptr [edx + field_293e], 0x0        # 00412e0e
    je.d8 L_00412e39                             # 00412e15
    # block 0x00412e17: entered by fall-through of je at 0x00412e15, 8 instruction(s), ends with forward jump to 0x00412ed5
    movsx eax, word ptr [ebp + arg_c]            # 00412e17
    imul eax, eax, 0x1d0                         # 00412e1b
    mov ecx, dword ptr [ebp + arg_14]            # 00412e21
    mov dx, word ptr [ecx]                       # 00412e24
    add dx, word ptr [eax + 0x5adb3c]            # 00412e27
    mov eax, dword ptr [ebp + arg_14]            # 00412e2e
    mov word ptr [eax], dx                       # 00412e31
    jmp.d32 L_00412ed5                           # 00412e34
L_00412e39:
    # block 0x00412e39: entered by je at 0x00412e15, 3 instruction(s), ends with je to 0x00412e9a (forward)
    mov ecx, dword ptr [ebp - local_1398]        # 00412e39
    cmp dword ptr [ecx + field_2942], 0x0        # 00412e3f
    je.d8 L_00412e9a                             # 00412e46
    # block 0x00412e48: entered by fall-through of je at 0x00412e46, 21 instruction(s), ends with forward jump to 0x00412ed5
    movsx edx, word ptr [ebp + arg_c]            # 00412e48
    imul edx, edx, 0x1d0                         # 00412e4c
    movsx ecx, word ptr [edx + 0x5adb3c]         # 00412e52
    movsx edx, word ptr [ebp + arg_c]            # 00412e59
    imul edx, edx, 0x1d0                         # 00412e5d
    movsx eax, word ptr [edx + 0x5adb3c]         # 00412e63
    cdq                                          # 00412e6a
    mov esi, 0x9                                 # 00412e6b
    idiv esi                                     # 00412e70
    {load} add eax, ecx                          # 00412e72
    cdq                                          # 00412e74
    {load} sub eax, edx                          # 00412e75
    sar eax                                      # 00412e77
    mov ecx, dword ptr [ebp + arg_14]            # 00412e79
    mov dx, word ptr [ecx]                       # 00412e7c
    {load} add dx, ax                            # 00412e7f
    mov eax, dword ptr [ebp + arg_14]            # 00412e82
    mov word ptr [eax], dx                       # 00412e85
    mov ecx, dword ptr [ebp - local_1398]        # 00412e88
    mov dword ptr [ecx + field_2942], 0x0        # 00412e8e
    jmp.d8 L_00412ed5                            # 00412e98
L_00412e9a:
    # block 0x00412e9a: entered by je at 0x00412e46, 15 instruction(s), falls into the block at 0x00412ed5
    movsx edx, word ptr [ebp + arg_c]            # 00412e9a
    imul edx, edx, 0x1d0                         # 00412e9e
    movsx ecx, word ptr [edx + 0x5adb3c]         # 00412ea4
    movsx edx, word ptr [ebp + arg_c]            # 00412eab
    imul edx, edx, 0x1d0                         # 00412eaf
    movsx eax, word ptr [edx + 0x5adb3c]         # 00412eb5
    cdq                                          # 00412ebc
    mov esi, 0x9                                 # 00412ebd
    idiv esi                                     # 00412ec2
    {load} add ecx, eax                          # 00412ec4
    mov eax, dword ptr [ebp + arg_14]            # 00412ec6
    mov dx, word ptr [eax]                       # 00412ec9
    {load} add dx, cx                            # 00412ecc
    mov eax, dword ptr [ebp + arg_14]            # 00412ecf
    mov word ptr [eax], dx                       # 00412ed2
L_00412ed5:
    # block 0x00412ed5: entered by jmp at 0x00412e34; jmp at 0x00412e98, 5 instruction(s), ends with jl to 0x00412f14 (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 00412ed5
    movsx edx, word ptr [ecx]                    # 00412ed8
    movsx eax, word ptr [ebp + arg_18]           # 00412edb
    {load} cmp edx, eax                          # 00412edf
    jl.d8 L_00412f14                             # 00412ee1
    # block 0x00412ee3: entered by fall-through of jl at 0x00412ee1, 3 instruction(s), ends with je to 0x00412f0f (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00412ee3
    test ecx, ecx                                # 00412eea
    je.d8 L_00412f0f                             # 00412eec
    # block 0x00412eee: entered by fall-through of je at 0x00412eec, 7 instruction(s), calls FUN_0050ca3e, FUN_004264e8, falls into the block at 0x00412f0f
    push 0x54167c                                # 00412eee
    push 0x63888b                                # 00412ef3
    call FUN_0050ca3e                            # 00412ef8
    add esp, 0x8                                 # 00412efd
    push 0x63888b                                # 00412f00
    mov ecx, 0x583979                            # 00412f05
    call FUN_004264e8                            # 00412f0a
L_00412f0f:
    # block 0x00412f0f: entered by je at 0x00412eec, 1 instruction(s), ends with forward jump to 0x00413173
    jmp.d32 L_00413173                           # 00412f0f
L_00412f14:
    # block 0x00412f14: entered by jl at 0x00412ee1, 2 instruction(s), falls into the block at 0x00412f1d
    mov edx, dword ptr [ebp + arg_10]            # 00412f14
    mov dword ptr [edx], 0x0                     # 00412f17
L_00412f1d:
    # block 0x00412f1d: entered by je at 0x00412e02, 8 instruction(s), ends with jne to 0x00412f35 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 00412f1d
    or ecx, -0x1                                 # 00412f20
    {load} xor eax, eax                          # 00412f23
    repne scasb al, byte ptr es:[edi]            # 00412f25
    not ecx                                      # 00412f27
    add ecx, -0x1                                # 00412f29
    test ecx, ecx                                # 00412f2c
    jne.d8 L_00412f35                            # 00412f2e
    # block 0x00412f30: entered by fall-through of jne at 0x00412f2e, 1 instruction(s), ends with forward jump to 0x00413173
    jmp.d32 L_00413173                           # 00412f30
L_00412f35:
    # block 0x00412f35: entered by jne at 0x00412f2e; jmp at 0x00412fb5, 19 instruction(s), calls FUN_004d3836, ends with jge to 0x00412fba (forward)
    mov eax, dword ptr [ebp + arg_20]            # 00412f35
    movsx esi, word ptr [eax]                    # 00412f38
    movsx ecx, word ptr [ebp + arg_c]            # 00412f3b
    imul ecx, ecx, 0x1d0                         # 00412f3f
    add ecx, 0x5adb3a                            # 00412f45
    push ecx                                     # 00412f4b
    movsx edx, word ptr [ebp + arg_c]            # 00412f4c
    imul edx, edx, 0x7f3                         # 00412f50
    add edx, 0x5a4c24                            # 00412f56
    push edx                                     # 00412f5c
    lea eax, [ebp - local_1394]                  # 00412f5d
    push eax                                     # 00412f63
    call FUN_004d3836                            # 00412f64
    add esp, 0xc                                 # 00412f69
    movsx ecx, ax                                # 00412f6c
    {load} add esi, ecx                          # 00412f6f
    movsx edx, word ptr [ebp + arg_1c]           # 00412f71
    {load} cmp esi, edx                          # 00412f75
    jge.d8 L_00412fba                            # 00412f77
    # block 0x00412f79: entered by fall-through of jge at 0x00412f77, 5 instruction(s), ends with je to 0x00412fba (forward)
    movsx eax, word ptr [ebp - local_c]          # 00412f79
    mov ecx, dword ptr [ebp + arg_8]             # 00412f7d
    movsx edx, byte ptr [ecx + eax]              # 00412f80
    test edx, edx                                # 00412f84
    je.d8 L_00412fba                             # 00412f86
    # block 0x00412f88: entered by fall-through of je at 0x00412f86, 12 instruction(s), ends with backward jump to 0x00412f35
    movsx eax, word ptr [ebp - local_c]          # 00412f88
    movsx ecx, word ptr [ebp - local_8]          # 00412f8c
    mov edx, dword ptr [ebp + arg_8]             # 00412f90
    mov al, byte ptr [edx + eax]                 # 00412f93
    mov byte ptr [ebp + ecx - local_1394], al    # 00412f96
    mov cx, word ptr [ebp - local_8]             # 00412f9d
    add cx, 0x1                                  # 00412fa1
    mov word ptr [ebp - local_8], cx             # 00412fa5
    mov dx, word ptr [ebp - local_c]             # 00412fa9
    add dx, 0x1                                  # 00412fad
    mov word ptr [ebp - local_c], dx             # 00412fb1
    jmp.d32 L_00412f35                           # 00412fb5
L_00412fba:
    # block 0x00412fba: entered by jge at 0x00412f77; je at 0x00412f86, 5 instruction(s), ends with je to 0x0041304f (forward)
    movsx eax, word ptr [ebp - local_c]          # 00412fba
    mov ecx, dword ptr [ebp + arg_8]             # 00412fbe
    movsx edx, byte ptr [ecx + eax]              # 00412fc1
    test edx, edx                                # 00412fc5
    je.d32 L_0041304f                            # 00412fc7
    # block 0x00412fcd: entered by fall-through of je at 0x00412fc7, 8 instruction(s), falls into the block at 0x00412ff1
    mov ax, word ptr [ebp - local_8]             # 00412fcd
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00412fd1
    mov word ptr [ebp - local_8], ax             # 00412fd5
    mov cx, word ptr [ebp - local_c]             # 00412fd9
    sub cx, 0x1                                  # 00412fdd
    mov word ptr [ebp - local_c], cx             # 00412fe1
    movsx edx, word ptr [ebp - local_8]          # 00412fe5
    mov byte ptr [ebp + edx - local_1394], 0x0   # 00412fe9
L_00412ff1:
    # block 0x00412ff1: entered by jmp at 0x00413022, 4 instruction(s), ends with je to 0x00413024 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00412ff1
    movsx ecx, byte ptr [ebp + eax - local_1394] # 00412ff5
    cmp ecx, 0x20                                # 00412ffd
    je.d8 L_00413024                             # 00413000
    # block 0x00413002: entered by fall-through of je at 0x00413000, 3 instruction(s), ends with jl to 0x00413024 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00413002
    test edx, edx                                # 00413006
    jl.d8 L_00413024                             # 00413008
    # block 0x0041300a: entered by fall-through of jl at 0x00413008, 7 instruction(s), ends with backward jump to 0x00412ff1
    mov ax, word ptr [ebp - local_8]             # 0041300a
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0041300e
    mov word ptr [ebp - local_8], ax             # 00413012
    mov cx, word ptr [ebp - local_c]             # 00413016
    sub cx, 0x1                                  # 0041301a
    mov word ptr [ebp - local_c], cx             # 0041301e
    jmp.d8 L_00412ff1                            # 00413022
L_00413024:
    # block 0x00413024: entered by je at 0x00413000; jl at 0x00413008, 9 instruction(s), falls into the block at 0x0041304f
    mov dx, word ptr [ebp - local_8]             # 00413024
    add dx, 0x1                                  # 00413028
    mov word ptr [ebp - local_8], dx             # 0041302c
    mov ax, word ptr [ebp - local_c]             # 00413030
    .insn 0x66, 0x05, 0x0001{:u16}               # 00413034
    mov word ptr [ebp - local_c], ax             # 00413038
    movsx ecx, word ptr [ebp - local_8]          # 0041303c
    mov byte ptr [ebp + ecx - local_1394], 0x0   # 00413040
    mov dword ptr [ebp - local_4], 0x1           # 00413048
L_0041304f:
    # block 0x0041304f: entered by je at 0x00412fc7, 8 instruction(s), ends with jbe to 0x00413116 (forward)
    lea edi, [ebp - local_1394]                  # 0041304f
    or ecx, -0x1                                 # 00413055
    {load} xor eax, eax                          # 00413058
    repne scasb al, byte ptr es:[edi]            # 0041305a
    not ecx                                      # 0041305c
    add ecx, -0x1                                # 0041305e
    test ecx, ecx                                # 00413061
    jbe.d32 L_00413116                           # 00413063
    # block 0x00413069: entered by fall-through of jbe at 0x00413063, 48 instruction(s), calls FUN_004d270b, FUN_004d3836, falls into the block at 0x00413116
    mov edx, dword ptr [ebp - local_1398]        # 00413069
    mov ax, word ptr [edx + field_293c]          # 0041306f
    push eax                                     # 00413076
    mov ecx, dword ptr [ebp - local_1398]        # 00413077
    mov edx, dword ptr [ecx + field_2938]        # 0041307d
    push edx                                     # 00413083
    mov ax, word ptr [ebp + arg_28]              # 00413084
    push eax                                     # 00413088
    mov ecx, dword ptr [ebp + arg_2c]            # 00413089
    push ecx                                     # 0041308c
    movsx edx, word ptr [ebp + arg_c]            # 0041308d
    mov eax, dword ptr [4*edx + 0x5d032f]        # 00413091
    push eax                                     # 00413098
    mov ecx, dword ptr [ebp + arg_14]            # 00413099
    mov dx, word ptr [ecx]                       # 0041309c
    push edx                                     # 0041309f
    mov eax, dword ptr [ebp + arg_20]            # 004130a0
    mov cx, word ptr [eax]                       # 004130a3
    push ecx                                     # 004130a6
    movsx edx, word ptr [ebp + arg_c]            # 004130a7
    imul edx, edx, 0x1d0                         # 004130ab
    add edx, 0x5adb3a                            # 004130b1
    push edx                                     # 004130b7
    movsx eax, word ptr [ebp + arg_c]            # 004130b8
    imul eax, eax, 0x7f3                         # 004130bc
    add eax, 0x5a4c24                            # 004130c2
    push eax                                     # 004130c7
    lea ecx, [ebp - local_1394]                  # 004130c8
    push ecx                                     # 004130ce
    call FUN_004d270b                            # 004130cf
    add esp, 0x28                                # 004130d4
    movsx edx, word ptr [ebp + arg_c]            # 004130d7
    imul edx, edx, 0x1d0                         # 004130db
    add edx, 0x5adb3a                            # 004130e1
    push edx                                     # 004130e7
    movsx eax, word ptr [ebp + arg_c]            # 004130e8
    imul eax, eax, 0x7f3                         # 004130ec
    add eax, 0x5a4c24                            # 004130f2
    push eax                                     # 004130f7
    lea ecx, [ebp - local_1394]                  # 004130f8
    push ecx                                     # 004130fe
    call FUN_004d3836                            # 004130ff
    add esp, 0xc                                 # 00413104
    mov edx, dword ptr [ebp + arg_20]            # 00413107
    mov cx, word ptr [edx]                       # 0041310a
    {load} add cx, ax                            # 0041310d
    mov edx, dword ptr [ebp + arg_20]            # 00413110
    mov word ptr [edx], cx                       # 00413113
L_00413116:
    # block 0x00413116: entered by jbe at 0x00413063, 2 instruction(s), ends with je to 0x00413148 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00413116
    je.d8 L_00413148                             # 0041311a
    # block 0x0041311c: entered by fall-through of je at 0x0041311a, 10 instruction(s), falls into the block at 0x00413148
    mov dword ptr [ebp - local_4], 0x0           # 0041311c
    mov eax, dword ptr [ebp + arg_20]            # 00413123
    mov ecx, dword ptr [ebp - local_1398]        # 00413126
    mov dx, word ptr [ecx + field_292e]          # 0041312c
    mov word ptr [eax], dx                       # 00413133
    mov eax, dword ptr [ebp + arg_10]            # 00413136
    mov dword ptr [eax], 0x1                     # 00413139
    mov ecx, dword ptr [ebp + arg_24]            # 0041313f
    add ecx, 0x2                                 # 00413142
    mov dword ptr [ebp + arg_24], ecx            # 00413145
L_00413148:
    # block 0x00413148: entered by je at 0x0041311a, 10 instruction(s), ends with jne to 0x0041316e (forward)
    mov ecx, 0x4e2                               # 00413148
    {load} xor eax, eax                          # 0041314d
    lea edi, [ebp - local_1394]                  # 0041314f
    rep stosd dword ptr es:[edi], eax            # 00413155
    mov word ptr [ebp - local_8], 0x0            # 00413157
    movsx edx, word ptr [ebp - local_c]          # 0041315d
    mov eax, dword ptr [ebp + arg_8]             # 00413161
    movsx ecx, byte ptr [eax + edx]              # 00413164
    test ecx, ecx                                # 00413168
    jne.d8 L_0041316e                            # 0041316a
    # block 0x0041316c: entered by fall-through of jne at 0x0041316a, 1 instruction(s), ends with forward jump to 0x00413173
    jmp.d8 L_00413173                            # 0041316c
L_0041316e:
    # block 0x0041316e: entered by jne at 0x0041316a, 1 instruction(s), ends with backward jump to 0x00412def
    jmp.d32 L_00412def                           # 0041316e
L_00413173:
    # block 0x00413173: entered by je at 0x00412df6; jmp at 0x00412f0f; jmp at 0x00412f30; jmp at 0x0041316c, 9 instruction(s), ends with ret 0x28
    mov ecx, 0x2710                              # 00413173
    {load} xor eax, eax                          # 00413178
    mov edi, dword ptr [ebp + arg_8]             # 0041317a
    rep stosd dword ptr es:[edi], eax            # 0041317d
    pop edi                                      # 0041317f
    pop esi                                      # 00413180
    {load} mov esp, ebp                          # 00413181
    pop ebp                                      # 00413183
    ret 0x28                                     # 00413184

