# FUN_0042cecd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042cecd
# extent:       0x0042cecd-0x0042d215 (840 code bytes)
# span:         0x0042cecd-0x0042d215 (code 840, tables 0, padding 0)
# sha256:       9f48a16e9478f249ed705cf908ff3ae2f95d618649581cf8397be06cae4464dd
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         second_rects
# naming:       native port src/action_family_33_runtime.c:second_rects (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with second_rects (clip and relative rect). Native: takes the decoded hotspot, not the raw 0x42-byte record; oracle compares aggregate op log.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_c, field_22, field_26, field_2a, field_2e, field_36, field_3e; [ecx + n] field_4, field_c, field_22, field_2a, field_2e, field_36, field_3e; [edx + n] field_4, field_c, field_32, field_36, field_3a, field_3e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_33_runtime.c:second_rects (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 197 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_22, 0x22  # offset +0x22
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e

# --- external targets -----------------------------------------------

.org 0x0042cecd - 0x401000
.globl FUN_0042cecd
FUN_0042cecd:
    # block 0x0042cecd: entry, 10 instruction(s), ends with jg to 0x0042cfed (forward)
    push ebp                                     # 0042cecd
    {load} mov ebp, esp                          # 0042cece
    push esi                                     # 0042ced0
    movsx eax, word ptr [ebp + arg_8]            # 0042ced1
    imul eax, eax, 0x42                          # 0042ced5
    mov ecx, dword ptr [0x5b4ea9]                # 0042ced8
    mov edx, dword ptr [ebp + arg_c]             # 0042cede
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042cee1
    cmp eax, dword ptr [edx + field_c]           # 0042cee5
    jg.d32 L_0042cfed                            # 0042cee8
    # block 0x0042ceee: entered by fall-through of jg at 0x0042cee8, 7 instruction(s), ends with jl to 0x0042cfed (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042ceee
    imul ecx, ecx, 0x42                          # 0042cef2
    mov edx, dword ptr [0x5b4ea9]                # 0042cef5
    mov eax, dword ptr [ebp + arg_c]             # 0042cefb
    mov ecx, dword ptr [edx + ecx + field_36]    # 0042cefe
    cmp ecx, dword ptr [eax + field_4]           # 0042cf02
    jl.d32 L_0042cfed                            # 0042cf05
    # block 0x0042cf0b: entered by fall-through of jl at 0x0042cf05, 50 instruction(s), ends with forward jump to 0x0042d1cc
    movsx edx, word ptr [ebp + arg_8]            # 0042cf0b
    imul edx, edx, 0x42                          # 0042cf0f
    mov eax, dword ptr [0x5b4ea9]                # 0042cf12
    mov ecx, dword ptr [eax + edx + field_26]    # 0042cf17
    mov dword ptr [0x5b4e3c], ecx                # 0042cf1b
    movsx edx, word ptr [ebp + arg_8]            # 0042cf21
    imul edx, edx, 0x42                          # 0042cf25
    mov eax, dword ptr [0x5b4ea9]                # 0042cf28
    mov ecx, dword ptr [eax + edx + field_2e]    # 0042cf2d
    mov dword ptr [0x5b4e44], ecx                # 0042cf31
    movsx edx, word ptr [ebp + arg_8]            # 0042cf37
    imul edx, edx, 0x42                          # 0042cf3b
    mov eax, dword ptr [0x5b4ea9]                # 0042cf3e
    mov ecx, dword ptr [eax + edx + field_22]    # 0042cf43
    mov dword ptr [0x5b4e38], ecx                # 0042cf47
    movsx edx, word ptr [ebp + arg_8]            # 0042cf4d
    imul edx, edx, 0x42                          # 0042cf51
    mov eax, dword ptr [0x5b4ea9]                # 0042cf54
    mov ecx, dword ptr [eax + edx + field_2a]    # 0042cf59
    mov dword ptr [0x5b4e40], ecx                # 0042cf5d
    movsx edx, word ptr [ebp + arg_8]            # 0042cf63
    imul edx, edx, 0x42                          # 0042cf67
    mov eax, dword ptr [0x5b4ea9]                # 0042cf6a
    mov ecx, dword ptr [ebp + arg_c]             # 0042cf6f
    mov edx, dword ptr [eax + edx + field_36]    # 0042cf72
    sub edx, dword ptr [ecx + field_4]           # 0042cf76
    add edx, dword ptr [0x58318a]                # 0042cf79
    mov dword ptr [0x5b4e4c], edx                # 0042cf7f
    movsx eax, word ptr [ebp + arg_8]            # 0042cf85
    imul eax, eax, 0x42                          # 0042cf89
    mov ecx, dword ptr [0x5b4ea9]                # 0042cf8c
    mov edx, dword ptr [ebp + arg_c]             # 0042cf92
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042cf95
    sub eax, dword ptr [edx + field_4]           # 0042cf99
    add eax, dword ptr [0x58318a]                # 0042cf9c
    mov dword ptr [0x5b4e54], eax                # 0042cfa2
    movsx ecx, word ptr [ebp + arg_8]            # 0042cfa7
    imul ecx, ecx, 0x42                          # 0042cfab
    mov edx, dword ptr [0x5b4ea9]                # 0042cfae
    mov eax, dword ptr [edx + ecx + field_32]    # 0042cfb4
    add eax, dword ptr [0x583186]                # 0042cfb8
    mov dword ptr [0x5b4e48], eax                # 0042cfbe
    movsx ecx, word ptr [ebp + arg_8]            # 0042cfc3
    imul ecx, ecx, 0x42                          # 0042cfc7
    mov edx, dword ptr [0x5b4ea9]                # 0042cfca
    mov eax, dword ptr [edx + ecx + field_3a]    # 0042cfd0
    add eax, dword ptr [0x583186]                # 0042cfd4
    mov dword ptr [0x5b4e50], eax                # 0042cfda
    mov word ptr [0x5b4e8d], 0x1                 # 0042cfdf
    jmp.d32 L_0042d1cc                           # 0042cfe8
L_0042cfed:
    # block 0x0042cfed: entered by jg at 0x0042cee8; jl at 0x0042cf05, 7 instruction(s), ends with jg to 0x0042d01e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042cfed
    imul ecx, ecx, 0x42                          # 0042cff1
    mov edx, dword ptr [0x5b4ea9]                # 0042cff4
    mov eax, dword ptr [ebp + arg_c]             # 0042cffa
    mov ecx, dword ptr [edx + ecx + field_36]    # 0042cffd
    cmp ecx, dword ptr [eax + field_c]           # 0042d001
    jg.d8 L_0042d01e                             # 0042d004
    # block 0x0042d006: entered by fall-through of jg at 0x0042d004, 7 instruction(s), ends with jge to 0x0042d058 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042d006
    imul edx, edx, 0x42                          # 0042d00a
    mov eax, dword ptr [0x5b4ea9]                # 0042d00d
    mov ecx, dword ptr [ebp + arg_c]             # 0042d012
    mov edx, dword ptr [eax + edx + field_3e]    # 0042d015
    cmp edx, dword ptr [ecx + field_c]           # 0042d019
    jge.d8 L_0042d058                            # 0042d01c
L_0042d01e:
    # block 0x0042d01e: entered by jg at 0x0042d004; fall-through of jge at 0x0042d01c, 7 instruction(s), ends with jg to 0x0042d1cc (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042d01e
    imul eax, eax, 0x42                          # 0042d022
    mov ecx, dword ptr [0x5b4ea9]                # 0042d025
    mov edx, dword ptr [ebp + arg_c]             # 0042d02b
    mov eax, dword ptr [ecx + eax + field_36]    # 0042d02e
    cmp eax, dword ptr [edx + field_4]           # 0042d032
    jg.d32 L_0042d1cc                            # 0042d035
    # block 0x0042d03b: entered by fall-through of jg at 0x0042d035, 7 instruction(s), ends with jl to 0x0042d1cc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042d03b
    imul ecx, ecx, 0x42                          # 0042d03f
    mov edx, dword ptr [0x5b4ea9]                # 0042d042
    mov eax, dword ptr [ebp + arg_c]             # 0042d048
    mov ecx, dword ptr [edx + ecx + field_3e]    # 0042d04b
    cmp ecx, dword ptr [eax + field_4]           # 0042d04f
    jl.d32 L_0042d1cc                            # 0042d052
L_0042d058:
    # block 0x0042d058: entered by jge at 0x0042d01c; fall-through of jl at 0x0042d052, 7 instruction(s), ends with jge to 0x0042d07e (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042d058
    imul edx, edx, 0x42                          # 0042d05c
    mov eax, dword ptr [0x5b4ea9]                # 0042d05f
    mov ecx, dword ptr [ebp + arg_c]             # 0042d064
    mov edx, dword ptr [eax + edx + field_36]    # 0042d067
    cmp edx, dword ptr [ecx + field_4]           # 0042d06b
    jge.d8 L_0042d07e                            # 0042d06e
    # block 0x0042d070: entered by fall-through of jge at 0x0042d06e, 4 instruction(s), ends with forward jump to 0x0042d094
    mov eax, dword ptr [ebp + arg_c]             # 0042d070
    mov ecx, dword ptr [eax + field_4]           # 0042d073
    mov dword ptr [0x5b4e4c], ecx                # 0042d076
    jmp.d8 L_0042d094                            # 0042d07c
L_0042d07e:
    # block 0x0042d07e: entered by jge at 0x0042d06e, 5 instruction(s), falls into the block at 0x0042d094
    movsx edx, word ptr [ebp + arg_8]            # 0042d07e
    imul edx, edx, 0x42                          # 0042d082
    mov eax, dword ptr [0x5b4ea9]                # 0042d085
    mov ecx, dword ptr [eax + edx + field_36]    # 0042d08a
    mov dword ptr [0x5b4e4c], ecx                # 0042d08e
L_0042d094:
    # block 0x0042d094: entered by jmp at 0x0042d07c, 7 instruction(s), ends with jle to 0x0042d0ba (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042d094
    imul edx, edx, 0x42                          # 0042d098
    mov eax, dword ptr [0x5b4ea9]                # 0042d09b
    mov ecx, dword ptr [ebp + arg_c]             # 0042d0a0
    mov edx, dword ptr [eax + edx + field_3e]    # 0042d0a3
    cmp edx, dword ptr [ecx + field_c]           # 0042d0a7
    jle.d8 L_0042d0ba                            # 0042d0aa
    # block 0x0042d0ac: entered by fall-through of jle at 0x0042d0aa, 4 instruction(s), ends with forward jump to 0x0042d0d0
    mov eax, dword ptr [ebp + arg_c]             # 0042d0ac
    mov ecx, dword ptr [eax + field_c]           # 0042d0af
    mov dword ptr [0x5b4e54], ecx                # 0042d0b2
    jmp.d8 L_0042d0d0                            # 0042d0b8
L_0042d0ba:
    # block 0x0042d0ba: entered by jle at 0x0042d0aa, 5 instruction(s), falls into the block at 0x0042d0d0
    movsx edx, word ptr [ebp + arg_8]            # 0042d0ba
    imul edx, edx, 0x42                          # 0042d0be
    mov eax, dword ptr [0x5b4ea9]                # 0042d0c1
    mov ecx, dword ptr [eax + edx + field_3e]    # 0042d0c6
    mov dword ptr [0x5b4e54], ecx                # 0042d0ca
L_0042d0d0:
    # block 0x0042d0d0: entered by jmp at 0x0042d0b8, 55 instruction(s), falls into the block at 0x0042d1cc
    movsx edx, word ptr [ebp + arg_8]            # 0042d0d0
    imul edx, edx, 0x42                          # 0042d0d4
    movsx eax, word ptr [ebp + arg_8]            # 0042d0d7
    imul eax, eax, 0x42                          # 0042d0db
    mov ecx, dword ptr [0x5b4ea9]                # 0042d0de
    mov esi, dword ptr [0x5b4e4c]                # 0042d0e4
    sub esi, dword ptr [ecx + eax + field_36]    # 0042d0ea
    mov eax, dword ptr [0x5b4ea9]                # 0042d0ee
    mov ecx, dword ptr [eax + edx + field_26]    # 0042d0f3
    {load} add ecx, esi                          # 0042d0f7
    mov dword ptr [0x5b4e3c], ecx                # 0042d0f9
    movsx edx, word ptr [ebp + arg_8]            # 0042d0ff
    imul edx, edx, 0x42                          # 0042d103
    movsx eax, word ptr [ebp + arg_8]            # 0042d106
    imul eax, eax, 0x42                          # 0042d10a
    mov ecx, dword ptr [0x5b4ea9]                # 0042d10d
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042d113
    sub eax, dword ptr [0x5b4e54]                # 0042d117
    mov ecx, dword ptr [0x5b4ea9]                # 0042d11d
    mov edx, dword ptr [ecx + edx + field_2e]    # 0042d123
    {load} sub edx, eax                          # 0042d127
    mov dword ptr [0x5b4e44], edx                # 0042d129
    movsx eax, word ptr [ebp + arg_8]            # 0042d12f
    imul eax, eax, 0x42                          # 0042d133
    mov ecx, dword ptr [0x5b4ea9]                # 0042d136
    mov edx, dword ptr [ecx + eax + field_22]    # 0042d13c
    mov dword ptr [0x5b4e38], edx                # 0042d140
    movsx eax, word ptr [ebp + arg_8]            # 0042d146
    imul eax, eax, 0x42                          # 0042d14a
    mov ecx, dword ptr [0x5b4ea9]                # 0042d14d
    mov edx, dword ptr [ecx + eax + field_2a]    # 0042d153
    mov dword ptr [0x5b4e40], edx                # 0042d157
    mov eax, dword ptr [ebp + arg_c]             # 0042d15d
    mov ecx, dword ptr [0x5b4e4c]                # 0042d160
    sub ecx, dword ptr [eax + field_4]           # 0042d166
    add ecx, dword ptr [0x58318a]                # 0042d169
    mov dword ptr [0x5b4e4c], ecx                # 0042d16f
    mov edx, dword ptr [ebp + arg_c]             # 0042d175
    mov eax, dword ptr [0x5b4e54]                # 0042d178
    sub eax, dword ptr [edx + field_4]           # 0042d17d
    add eax, dword ptr [0x58318a]                # 0042d180
    mov dword ptr [0x5b4e54], eax                # 0042d186
    movsx ecx, word ptr [ebp + arg_8]            # 0042d18b
    imul ecx, ecx, 0x42                          # 0042d18f
    mov edx, dword ptr [0x5b4ea9]                # 0042d192
    mov eax, dword ptr [edx + ecx + field_32]    # 0042d198
    add eax, dword ptr [0x583186]                # 0042d19c
    mov dword ptr [0x5b4e48], eax                # 0042d1a2
    movsx ecx, word ptr [ebp + arg_8]            # 0042d1a7
    imul ecx, ecx, 0x42                          # 0042d1ab
    mov edx, dword ptr [0x5b4ea9]                # 0042d1ae
    mov eax, dword ptr [edx + ecx + field_3a]    # 0042d1b4
    add eax, dword ptr [0x583186]                # 0042d1b8
    mov dword ptr [0x5b4e50], eax                # 0042d1be
    mov word ptr [0x5b4e8d], 0x1                 # 0042d1c3
L_0042d1cc:
    # block 0x0042d1cc: entered by jmp at 0x0042cfe8; jg at 0x0042d035; jl at 0x0042d052, 15 instruction(s), ends with ret
    mov ecx, dword ptr [0x5b4e4c]                # 0042d1cc
    sub ecx, dword ptr [0x58318a]                # 0042d1d2
    mov dword ptr [0x5b4e97], ecx                # 0042d1d8
    mov edx, dword ptr [0x5b4e54]                # 0042d1de
    sub edx, dword ptr [0x58318a]                # 0042d1e4
    mov dword ptr [0x5b4e9f], edx                # 0042d1ea
    mov eax, dword ptr [0x5b4e48]                # 0042d1f0
    sub eax, dword ptr [0x583186]                # 0042d1f5
    mov dword ptr [0x5b4e93], eax                # 0042d1fb
    mov ecx, dword ptr [0x5b4e50]                # 0042d200
    sub ecx, dword ptr [0x583186]                # 0042d206
    mov dword ptr [0x5b4e9b], ecx                # 0042d20c
    pop esi                                      # 0042d212
    pop ebp                                      # 0042d213
    ret                                          # 0042d214

