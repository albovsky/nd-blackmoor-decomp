# FUN_00469057
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00469057
# extent:       0x00469057-0x004691ee (407 code bytes)
# span:         0x00469057-0x004691ee (code 407, tables 0, padding 0)
# sha256:       bea0db641fce72b4d6062f2d15f78a339050de2a53d0ed797e01503a360879d1
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m469057_hit_test
# naming:       native port src/original_methods_fl26a.c:m469057_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m469057_hit_test. Oracle window runs all 111 instructions of the 407 bytes, 20/20 jcc directions, six rows, the record-object rectangle and the 32-bit wrap of the widened edges. See tasks/fl26a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_548, field_55c; [ecx + n] field_28, field_554; [edx + n] field_20, field_24, field_31, field_35, field_39, field_3d, field_7e, field_552
# callees:      calls FUN_004691ee
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl26a.c:m469057_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 111 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_7e, 0x7e  # offset +0x7e
.equ field_548, 0x548  # offset +0x548
.equ field_552, 0x552  # offset +0x552
.equ field_554, 0x554  # offset +0x554
.equ field_55c, 0x55c  # offset +0x55c

# --- external targets -----------------------------------------------
.set FUN_004691ee, .text + (0x004691ee - 0x401000)

.org 0x00469057 - 0x401000
.globl FUN_00469057
FUN_00469057:
    # block 0x00469057: entry, 7 instruction(s), ends with je to 0x004691e6 (forward)
    push ebp                                     # 00469057
    {load} mov ebp, esp                          # 00469058
    sub esp, 0x8                                 # 0046905a
    mov dword ptr [ebp - local_8], ecx           # 0046905d
    mov eax, dword ptr [ebp - local_8]           # 00469060
    cmp dword ptr [eax + field_55c], 0x0         # 00469063
    je.d32 L_004691e6                            # 0046906a
    # block 0x00469070: entered by fall-through of je at 0x0046906a, 8 instruction(s), ends with forward jump to 0x004690a8
    mov ecx, dword ptr [ebp - local_8]           # 00469070
    mov word ptr [ecx + field_554], 0xffff       # 00469073
    mov edx, dword ptr [ebp - local_8]           # 0046907c
    mov word ptr [edx + field_552], 0xffff       # 0046907f
    mov eax, dword ptr [ebp - local_8]           # 00469088
    mov word ptr [eax + field_548], 0xffff       # 0046908b
    mov word ptr [ebp - local_4], 0x0            # 00469094
    jmp.d8 L_004690a8                            # 0046909a
L_0046909c:
    # block 0x0046909c: entered by jmp at 0x0046914c, 3 instruction(s), falls into the block at 0x004690a8
    mov cx, word ptr [ebp - local_4]             # 0046909c
    add cx, 0x1                                  # 004690a0
    mov word ptr [ebp - local_4], cx             # 004690a4
L_004690a8:
    # block 0x004690a8: entered by jmp at 0x0046909a, 3 instruction(s), ends with jge to 0x00469151 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004690a8
    cmp edx, 0x6                                 # 004690ac
    jge.d32 L_00469151                           # 004690af
    # block 0x004690b5: entered by fall-through of jge at 0x004690af, 8 instruction(s), ends with jl to 0x0046914c (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004690b5
    movsx ecx, word ptr [ebp - local_4]          # 004690b9
    shl ecx, 0x4                                 # 004690bd
    mov edx, dword ptr [ebp - local_8]           # 004690c0
    mov ecx, dword ptr [edx + ecx + field_20]    # 004690c3
    sub ecx, 0x5                                 # 004690c7
    {load} cmp eax, ecx                          # 004690ca
    jl.d8 L_0046914c                             # 004690cc
    # block 0x004690ce: entered by fall-through of jl at 0x004690cc, 8 instruction(s), ends with jg to 0x0046914c (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004690ce
    movsx eax, word ptr [ebp - local_4]          # 004690d2
    shl eax, 0x4                                 # 004690d6
    mov ecx, dword ptr [ebp - local_8]           # 004690d9
    mov eax, dword ptr [ecx + eax + field_28]    # 004690dc
    add eax, 0x5                                 # 004690e0
    {load} cmp edx, eax                          # 004690e3
    jg.d8 L_0046914c                             # 004690e5
    # block 0x004690e7: entered by fall-through of jg at 0x004690e5, 8 instruction(s), ends with jl to 0x0046914c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004690e7
    movsx edx, word ptr [ebp - local_4]          # 004690eb
    shl edx, 0x4                                 # 004690ef
    mov eax, dword ptr [ebp - local_8]           # 004690f2
    mov edx, dword ptr [eax + edx + field_1c]    # 004690f5
    sub edx, 0x6                                 # 004690f9
    {load} cmp ecx, edx                          # 004690fc
    jl.d8 L_0046914c                             # 004690fe
    # block 0x00469100: entered by fall-through of jl at 0x004690fe, 8 instruction(s), ends with jg to 0x0046914c (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00469100
    movsx ecx, word ptr [ebp - local_4]          # 00469104
    shl ecx, 0x4                                 # 00469108
    mov edx, dword ptr [ebp - local_8]           # 0046910b
    mov ecx, dword ptr [edx + ecx + field_24]    # 0046910e
    add ecx, 0xa                                 # 00469112
    {load} cmp eax, ecx                          # 00469115
    jg.d8 L_0046914c                             # 00469117
    # block 0x00469119: entered by fall-through of jg at 0x00469117, 12 instruction(s), calls FUN_004691ee, ends with forward jump to 0x004691e8
    mov edx, dword ptr [ebp - local_8]           # 00469119
    mov ax, word ptr [ebp + arg_8]               # 0046911c
    mov word ptr [edx + field_552], ax           # 00469120
    mov ecx, dword ptr [ebp - local_8]           # 00469127
    mov dx, word ptr [ebp + arg_c]               # 0046912a
    mov word ptr [ecx + field_554], dx           # 0046912e
    mov ax, word ptr [ebp - local_4]             # 00469135
    push eax                                     # 00469139
    mov ecx, dword ptr [ebp - local_8]           # 0046913a
    call FUN_004691ee                            # 0046913d
    mov eax, 0x1                                 # 00469142
    jmp.d32 L_004691e8                           # 00469147
L_0046914c:
    # block 0x0046914c: entered by jl at 0x004690cc; jg at 0x004690e5; jl at 0x004690fe; jg at 0x00469117, 1 instruction(s), ends with backward jump to 0x0046909c
    jmp.d32 L_0046909c                           # 0046914c
L_00469151:
    # block 0x00469151: entered by jge at 0x004690af, 9 instruction(s), ends with jl to 0x004691e6 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00469151
    mov edx, dword ptr [ebp - local_8]           # 00469155
    movsx eax, word ptr [edx + field_7e]         # 00469158
    imul eax, eax, 0x8d                          # 0046915c
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00469162
    mov eax, dword ptr [edx + field_35]          # 00469168
    sub eax, 0x5                                 # 0046916b
    {load} cmp ecx, eax                          # 0046916e
    jl.d8 L_004691e6                             # 00469170
    # block 0x00469172: entered by fall-through of jl at 0x00469170, 9 instruction(s), ends with jg to 0x004691e6 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00469172
    mov edx, dword ptr [ebp - local_8]           # 00469176
    movsx eax, word ptr [edx + field_7e]         # 00469179
    imul eax, eax, 0x8d                          # 0046917d
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00469183
    mov eax, dword ptr [edx + field_3d]          # 00469189
    add eax, 0x5                                 # 0046918c
    {load} cmp ecx, eax                          # 0046918f
    jg.d8 L_004691e6                             # 00469191
    # block 0x00469193: entered by fall-through of jg at 0x00469191, 9 instruction(s), ends with jl to 0x004691e6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00469193
    mov edx, dword ptr [ebp - local_8]           # 00469197
    movsx eax, word ptr [edx + field_7e]         # 0046919a
    imul eax, eax, 0x8d                          # 0046919e
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004691a4
    mov eax, dword ptr [edx + field_31]          # 004691aa
    sub eax, 0x6                                 # 004691ad
    {load} cmp ecx, eax                          # 004691b0
    jl.d8 L_004691e6                             # 004691b2
    # block 0x004691b4: entered by fall-through of jl at 0x004691b2, 9 instruction(s), ends with jg to 0x004691e6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004691b4
    mov edx, dword ptr [ebp - local_8]           # 004691b8
    movsx eax, word ptr [edx + field_7e]         # 004691bb
    imul eax, eax, 0x8d                          # 004691bf
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004691c5
    mov eax, dword ptr [edx + field_39]          # 004691cb
    add eax, 0xa                                 # 004691ce
    {load} cmp ecx, eax                          # 004691d1
    jg.d8 L_004691e6                             # 004691d3
    # block 0x004691d5: entered by fall-through of jg at 0x004691d3, 5 instruction(s), calls FUN_004691ee, ends with forward jump to 0x004691e8
    push 0x64                                    # 004691d5
    mov ecx, dword ptr [ebp - local_8]           # 004691d7
    call FUN_004691ee                            # 004691da
    mov eax, 0x1                                 # 004691df
    jmp.d8 L_004691e8                            # 004691e4
L_004691e6:
    # block 0x004691e6: entered by je at 0x0046906a; jl at 0x00469170; jg at 0x00469191; jl at 0x004691b2; jg at 0x004691d3, 1 instruction(s), falls into the block at 0x004691e8
    {load} xor eax, eax                          # 004691e6
L_004691e8:
    # block 0x004691e8: entered by jmp at 0x00469147; jmp at 0x004691e4, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004691e8
    pop ebp                                      # 004691ea
    ret 0x8                                      # 004691eb

