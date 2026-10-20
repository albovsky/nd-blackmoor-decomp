# FUN_00455180
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455180
# extent:       0x00455180-0x004554bb (827 code bytes)
# span:         0x00455180-0x004554bb (code 827, tables 0, padding 0)
# sha256:       ea962ee2d7ed38494e315798b320e51df9babaa4a5b10b964ba7b55f4029927f
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m455180_hit_test
# naming:       native port src/original_methods_fl25b.c:m455180_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m455180_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25b-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_21, field_29, field_2d, field_35, field_36, field_40, field_45, field_80 and 4 more; [ecx + n] field_25, field_26, field_2a, field_41, field_4c, field_8c, field_7e0, field_cf5, field_cf9; [edx + n] field_2a, field_31, field_39, field_3d, field_44, field_45, field_48, field_84, field_88, field_90, field_92, field_94 and 5 more
# callees:      calls FUN_0045504b, FUN_004554bb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25b.c:m455180_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 229 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_29, 0x29  # offset +0x29
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_44, 0x44  # offset +0x44
.equ field_45, 0x45  # offset +0x45
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94
.equ field_150, 0x150  # offset +0x150
.equ field_15a, 0x15a  # offset +0x15a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_7e0, 0x7e0  # offset +0x7e0
.equ field_cf1, 0xcf1  # offset +0xcf1
.equ field_cf5, 0xcf5  # offset +0xcf5
.equ field_cf9, 0xcf9  # offset +0xcf9
.equ field_cfd, 0xcfd  # offset +0xcfd

# --- external targets -----------------------------------------------
.set FUN_0045504b, .text + (0x0045504b - 0x401000)
.set FUN_004554bb, .text + (0x004554bb - 0x401000)

.org 0x00455180 - 0x401000
.globl FUN_00455180
FUN_00455180:
    # block 0x00455180: entry, 12 instruction(s), ends with je to 0x004554b3 (forward)
    push ebp                                     # 00455180
    {load} mov ebp, esp                          # 00455181
    sub esp, 0x10                                # 00455183
    mov dword ptr [ebp - local_10], ecx          # 00455186
    mov eax, dword ptr [ebp - local_10]          # 00455189
    movsx ecx, word ptr [eax + field_1e]         # 0045518c
    imul ecx, ecx, 0x8d                          # 00455190
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455196
    mov dword ptr [ebp - local_4], edx           # 0045519c
    mov eax, dword ptr [ebp - local_10]          # 0045519f
    cmp dword ptr [eax + field_150], 0x0         # 004551a2
    je.d32 L_004554b3                            # 004551a9
    # block 0x004551af: entered by fall-through of je at 0x004551a9, 21 instruction(s), ends with je to 0x004552c0 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004551af
    mov dword ptr [ecx + field_26], 0x1          # 004551b2
    mov edx, dword ptr [ebp - local_10]          # 004551b9
    mov eax, dword ptr [ebp + arg_10]            # 004551bc
    mov ecx, dword ptr [eax + field_4]           # 004551bf
    mov dword ptr [edx + field_15e], ecx         # 004551c2
    mov edx, dword ptr [ebp - local_10]          # 004551c8
    mov eax, dword ptr [ebp + arg_10]            # 004551cb
    mov ecx, dword ptr [eax + field_c]           # 004551ce
    mov dword ptr [edx + field_166], ecx         # 004551d1
    mov edx, dword ptr [ebp - local_10]          # 004551d7
    mov eax, dword ptr [ebp + arg_10]            # 004551da
    mov ecx, dword ptr [eax]                     # 004551dd
    mov dword ptr [edx + field_15a], ecx         # 004551df
    mov edx, dword ptr [ebp - local_10]          # 004551e5
    mov eax, dword ptr [ebp + arg_10]            # 004551e8
    mov ecx, dword ptr [eax + field_8]           # 004551eb
    mov dword ptr [edx + field_162], ecx         # 004551ee
    mov edx, dword ptr [ebp - local_10]          # 004551f4
    cmp dword ptr [edx + field_2a], 0x0          # 004551f7
    je.d32 L_004552c0                            # 004551fb
    # block 0x00455201: entered by fall-through of je at 0x004551fb, 12 instruction(s), calls FUN_0045504b, ends with jne to 0x00455246 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00455201
    movsx ecx, word ptr [eax + field_36]         # 00455204
    imul ecx, ecx, 0x96                          # 00455208
    mov edx, dword ptr [ebp - local_4]           # 0045520e
    lea eax, [edx + ecx + field_45]              # 00455211
    mov dword ptr [ebp - local_c], eax           # 00455215
    mov ecx, dword ptr [ebp - local_10]          # 00455218
    call FUN_0045504b                            # 0045521b
    mov ecx, dword ptr [ebp - local_4]           # 00455220
    movsx edx, word ptr [ecx + field_7e0]        # 00455223
    test edx, edx                                # 0045522a
    jne.d8 L_00455246                            # 0045522c
    # block 0x0045522e: entered by fall-through of jne at 0x0045522c, 6 instruction(s), ends with je to 0x00455254 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045522e
    movsx ecx, word ptr [eax + field_8a]         # 00455231
    mov edx, dword ptr [ebp - local_c]           # 00455238
    movsx eax, word ptr [edx + field_90]         # 0045523b
    {load} cmp ecx, eax                          # 00455242
    je.d8 L_00455254                             # 00455244
L_00455246:
    # block 0x00455246: entered by jne at 0x0045522c; fall-through of je at 0x00455244, 4 instruction(s), ends with je to 0x004552bb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00455246
    movsx edx, word ptr [ecx + field_7e0]        # 00455249
    test edx, edx                                # 00455250
    je.d8 L_004552bb                             # 00455252
L_00455254:
    # block 0x00455254: entered by je at 0x00455244; fall-through of je at 0x00455252, 6 instruction(s), ends with jne to 0x004552bb (forward)
    mov eax, dword ptr [ebp - local_10]          # 00455254
    movsx ecx, word ptr [eax + field_8c]         # 00455257
    mov edx, dword ptr [ebp - local_c]           # 0045525e
    movsx eax, word ptr [edx + field_92]         # 00455261
    {load} cmp ecx, eax                          # 00455268
    jne.d8 L_004552bb                            # 0045526a
    # block 0x0045526c: entered by fall-through of jne at 0x0045526a, 4 instruction(s), ends with jl to 0x004552bb (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045526c
    mov edx, dword ptr [ebp - local_c]           # 00455270
    cmp ecx, dword ptr [edx + field_44]          # 00455273
    jl.d8 L_004552bb                             # 00455276
    # block 0x00455278: entered by fall-through of jl at 0x00455276, 4 instruction(s), ends with jg to 0x004552bb (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00455278
    mov ecx, dword ptr [ebp - local_c]           # 0045527c
    cmp eax, dword ptr [ecx + field_4c]          # 0045527f
    jg.d8 L_004552bb                             # 00455282
    # block 0x00455284: entered by fall-through of jg at 0x00455282, 4 instruction(s), ends with jl to 0x004552bb (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00455284
    mov eax, dword ptr [ebp - local_c]           # 00455288
    cmp edx, dword ptr [eax + field_40]          # 0045528b
    jl.d8 L_004552bb                             # 0045528e
    # block 0x00455290: entered by fall-through of jl at 0x0045528e, 4 instruction(s), ends with jg to 0x004552bb (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00455290
    mov edx, dword ptr [ebp - local_c]           # 00455294
    cmp ecx, dword ptr [edx + field_48]          # 00455297
    jg.d8 L_004552bb                             # 0045529a
    # block 0x0045529c: entered by fall-through of jg at 0x0045529a, 8 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    mov eax, dword ptr [ebp - local_10]          # 0045529c
    mov cx, word ptr [eax + field_36]            # 0045529f
    push ecx                                     # 004552a3
    push 0x27c8                                  # 004552a4
    mov ecx, dword ptr [ebp - local_10]          # 004552a9
    call FUN_004554bb                            # 004552ac
    mov eax, 0x1                                 # 004552b1
    jmp.d32 L_004554b5                           # 004552b6
L_004552bb:
    # block 0x004552bb: entered by je at 0x00455252; jne at 0x0045526a; jl at 0x00455276; jg at 0x00455282; more, 1 instruction(s), ends with forward jump to 0x004553a7
    jmp.d32 L_004553a7                           # 004552bb
L_004552c0:
    # block 0x004552c0: entered by je at 0x004551fb, 4 instruction(s), ends with jl to 0x00455309 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004552c0
    mov eax, dword ptr [ebp - local_4]           # 004552c4
    cmp edx, dword ptr [eax + field_29]          # 004552c7
    jl.d8 L_00455309                             # 004552ca
    # block 0x004552cc: entered by fall-through of jl at 0x004552ca, 4 instruction(s), ends with jg to 0x00455309 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004552cc
    mov edx, dword ptr [ebp - local_4]           # 004552d0
    cmp ecx, dword ptr [edx + field_31]          # 004552d3
    jg.d8 L_00455309                             # 004552d6
    # block 0x004552d8: entered by fall-through of jg at 0x004552d6, 4 instruction(s), ends with jl to 0x00455309 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004552d8
    mov ecx, dword ptr [ebp - local_4]           # 004552dc
    cmp eax, dword ptr [ecx + field_25]          # 004552df
    jl.d8 L_00455309                             # 004552e2
    # block 0x004552e4: entered by fall-through of jl at 0x004552e2, 4 instruction(s), ends with jg to 0x00455309 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004552e4
    mov eax, dword ptr [ebp - local_4]           # 004552e8
    cmp edx, dword ptr [eax + field_2d]          # 004552eb
    jg.d8 L_00455309                             # 004552ee
    # block 0x004552f0: entered by fall-through of jg at 0x004552ee, 6 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    push 0x0                                     # 004552f0
    push 0x27c5                                  # 004552f2
    mov ecx, dword ptr [ebp - local_10]          # 004552f7
    call FUN_004554bb                            # 004552fa
    mov eax, 0x1                                 # 004552ff
    jmp.d32 L_004554b5                           # 00455304
L_00455309:
    # block 0x00455309: entered by jl at 0x004552ca; jg at 0x004552d6; jl at 0x004552e2; jg at 0x004552ee, 4 instruction(s), ends with jl to 0x00455352 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00455309
    mov edx, dword ptr [ebp - local_4]           # 0045530d
    cmp ecx, dword ptr [edx + field_39]          # 00455310
    jl.d8 L_00455352                             # 00455313
    # block 0x00455315: entered by fall-through of jl at 0x00455313, 4 instruction(s), ends with jg to 0x00455352 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00455315
    mov ecx, dword ptr [ebp - local_4]           # 00455319
    cmp eax, dword ptr [ecx + field_41]          # 0045531c
    jg.d8 L_00455352                             # 0045531f
    # block 0x00455321: entered by fall-through of jg at 0x0045531f, 4 instruction(s), ends with jl to 0x00455352 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00455321
    mov eax, dword ptr [ebp - local_4]           # 00455325
    cmp edx, dword ptr [eax + field_35]          # 00455328
    jl.d8 L_00455352                             # 0045532b
    # block 0x0045532d: entered by fall-through of jl at 0x0045532b, 4 instruction(s), ends with jg to 0x00455352 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045532d
    mov edx, dword ptr [ebp - local_4]           # 00455331
    cmp ecx, dword ptr [edx + field_3d]          # 00455334
    jg.d8 L_00455352                             # 00455337
    # block 0x00455339: entered by fall-through of jg at 0x00455337, 6 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    push 0x0                                     # 00455339
    push 0x27c6                                  # 0045533b
    mov ecx, dword ptr [ebp - local_10]          # 00455340
    call FUN_004554bb                            # 00455343
    mov eax, 0x1                                 # 00455348
    jmp.d32 L_004554b5                           # 0045534d
L_00455352:
    # block 0x00455352: entered by jl at 0x00455313; jg at 0x0045531f; jl at 0x0045532b; jg at 0x00455337, 4 instruction(s), ends with jl to 0x004553a7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00455352
    mov ecx, dword ptr [ebp - local_4]           # 00455356
    cmp eax, dword ptr [ecx + field_cf5]         # 00455359
    jl.d8 L_004553a7                             # 0045535f
    # block 0x00455361: entered by fall-through of jl at 0x0045535f, 4 instruction(s), ends with jg to 0x004553a7 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00455361
    mov eax, dword ptr [ebp - local_4]           # 00455365
    cmp edx, dword ptr [eax + field_cfd]         # 00455368
    jg.d8 L_004553a7                             # 0045536e
    # block 0x00455370: entered by fall-through of jg at 0x0045536e, 4 instruction(s), ends with jl to 0x004553a7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00455370
    mov edx, dword ptr [ebp - local_4]           # 00455374
    cmp ecx, dword ptr [edx + field_cf1]         # 00455377
    jl.d8 L_004553a7                             # 0045537d
    # block 0x0045537f: entered by fall-through of jl at 0x0045537d, 4 instruction(s), ends with jg to 0x004553a7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045537f
    mov ecx, dword ptr [ebp - local_4]           # 00455383
    cmp eax, dword ptr [ecx + field_cf9]         # 00455386
    jg.d8 L_004553a7                             # 0045538c
    # block 0x0045538e: entered by fall-through of jg at 0x0045538c, 6 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    push 0x0                                     # 0045538e
    push 0x27c7                                  # 00455390
    mov ecx, dword ptr [ebp - local_10]          # 00455395
    call FUN_004554bb                            # 00455398
    mov eax, 0x1                                 # 0045539d
    jmp.d32 L_004554b5                           # 004553a2
L_004553a7:
    # block 0x004553a7: entered by jmp at 0x004552bb; jl at 0x0045535f; jg at 0x0045536e; jl at 0x0045537d; jg at 0x0045538c, 2 instruction(s), ends with forward jump to 0x004553b9
    mov dword ptr [ebp - local_8], 0x0           # 004553a7
    jmp.d8 L_004553b9                            # 004553ae
L_004553b0:
    # block 0x004553b0: entered by jmp at 0x004554ae, 3 instruction(s), falls into the block at 0x004553b9
    mov edx, dword ptr [ebp - local_8]           # 004553b0
    add edx, 0x1                                 # 004553b3
    mov dword ptr [ebp - local_8], edx           # 004553b6
L_004553b9:
    # block 0x004553b9: entered by jmp at 0x004553ae, 4 instruction(s), ends with jge to 0x004554b3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004553b9
    movsx ecx, word ptr [eax + field_21]         # 004553bc
    cmp dword ptr [ebp - local_8], ecx           # 004553c0
    jge.d32 L_004554b3                           # 004553c3
    # block 0x004553c9: entered by fall-through of jge at 0x004553c3, 9 instruction(s), ends with jne to 0x0045543f (forward)
    mov edx, dword ptr [ebp - local_8]           # 004553c9
    imul edx, edx, 0x96                          # 004553cc
    mov eax, dword ptr [ebp - local_4]           # 004553d2
    lea ecx, [eax + edx + field_45]              # 004553d5
    mov dword ptr [ebp - local_c], ecx           # 004553d9
    mov edx, dword ptr [ebp - local_c]           # 004553dc
    movsx eax, word ptr [edx + field_94]         # 004553df
    test eax, eax                                # 004553e6
    jne.d8 L_0045543f                            # 004553e8
    # block 0x004553ea: entered by fall-through of jne at 0x004553e8, 4 instruction(s), ends with jl to 0x0045543f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004553ea
    mov edx, dword ptr [ebp - local_c]           # 004553ee
    cmp ecx, dword ptr [edx + field_84]          # 004553f1
    jl.d8 L_0045543f                             # 004553f7
    # block 0x004553f9: entered by fall-through of jl at 0x004553f7, 4 instruction(s), ends with jg to 0x0045543f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004553f9
    mov ecx, dword ptr [ebp - local_c]           # 004553fd
    cmp eax, dword ptr [ecx + field_8c]          # 00455400
    jg.d8 L_0045543f                             # 00455406
    # block 0x00455408: entered by fall-through of jg at 0x00455406, 4 instruction(s), ends with jl to 0x0045543f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00455408
    mov eax, dword ptr [ebp - local_c]           # 0045540c
    cmp edx, dword ptr [eax + field_80]          # 0045540f
    jl.d8 L_0045543f                             # 00455415
    # block 0x00455417: entered by fall-through of jl at 0x00455415, 4 instruction(s), ends with jg to 0x0045543f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00455417
    mov edx, dword ptr [ebp - local_c]           # 0045541b
    cmp ecx, dword ptr [edx + field_88]          # 0045541e
    jg.d8 L_0045543f                             # 00455424
    # block 0x00455426: entered by fall-through of jg at 0x00455424, 7 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    mov ax, word ptr [ebp - local_8]             # 00455426
    push eax                                     # 0045542a
    push 0x27c4                                  # 0045542b
    mov ecx, dword ptr [ebp - local_10]          # 00455430
    call FUN_004554bb                            # 00455433
    mov eax, 0x1                                 # 00455438
    jmp.d8 L_004554b5                            # 0045543d
L_0045543f:
    # block 0x0045543f: entered by jne at 0x004553e8; jl at 0x004553f7; jg at 0x00455406; jl at 0x00455415; jg at 0x00455424, 3 instruction(s), ends with je to 0x004554ae (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045543f
    cmp dword ptr [ecx + field_2a], 0x0          # 00455442
    je.d8 L_004554ae                             # 00455446
    # block 0x00455448: entered by fall-through of je at 0x00455446, 4 instruction(s), ends with je to 0x004554ae (forward)
    mov edx, dword ptr [ebp - local_c]           # 00455448
    movsx eax, word ptr [edx + field_94]         # 0045544b
    test eax, eax                                # 00455452
    je.d8 L_004554ae                             # 00455454
    # block 0x00455456: entered by fall-through of je at 0x00455454, 4 instruction(s), ends with jl to 0x004554ae (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00455456
    mov edx, dword ptr [ebp - local_c]           # 0045545a
    cmp ecx, dword ptr [edx + field_84]          # 0045545d
    jl.d8 L_004554ae                             # 00455463
    # block 0x00455465: entered by fall-through of jl at 0x00455463, 4 instruction(s), ends with jg to 0x004554ae (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00455465
    mov ecx, dword ptr [ebp - local_c]           # 00455469
    cmp eax, dword ptr [ecx + field_8c]          # 0045546c
    jg.d8 L_004554ae                             # 00455472
    # block 0x00455474: entered by fall-through of jg at 0x00455472, 4 instruction(s), ends with jl to 0x004554ae (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00455474
    mov eax, dword ptr [ebp - local_c]           # 00455478
    cmp edx, dword ptr [eax + field_80]          # 0045547b
    jl.d8 L_004554ae                             # 00455481
    # block 0x00455483: entered by fall-through of jl at 0x00455481, 4 instruction(s), ends with jg to 0x004554ae (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00455483
    mov edx, dword ptr [ebp - local_c]           # 00455487
    cmp ecx, dword ptr [edx + field_88]          # 0045548a
    jg.d8 L_004554ae                             # 00455490
    # block 0x00455492: entered by fall-through of jg at 0x00455490, 8 instruction(s), calls FUN_004554bb, ends with forward jump to 0x004554b5
    mov eax, dword ptr [ebp - local_10]          # 00455492
    mov cx, word ptr [eax + field_36]            # 00455495
    push ecx                                     # 00455499
    push 0x27c4                                  # 0045549a
    mov ecx, dword ptr [ebp - local_10]          # 0045549f
    call FUN_004554bb                            # 004554a2
    mov eax, 0x1                                 # 004554a7
    jmp.d8 L_004554b5                            # 004554ac
L_004554ae:
    # block 0x004554ae: entered by je at 0x00455446; je at 0x00455454; jl at 0x00455463; jg at 0x00455472; more, 1 instruction(s), ends with backward jump to 0x004553b0
    jmp.d32 L_004553b0                           # 004554ae
L_004554b3:
    # block 0x004554b3: entered by je at 0x004551a9; jge at 0x004553c3, 1 instruction(s), falls into the block at 0x004554b5
    {load} xor eax, eax                          # 004554b3
L_004554b5:
    # block 0x004554b5: entered by jmp at 0x004552b6; jmp at 0x00455304; jmp at 0x0045534d; jmp at 0x004553a2; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004554b5
    pop ebp                                      # 004554b7
    ret 0xc                                      # 004554b8

