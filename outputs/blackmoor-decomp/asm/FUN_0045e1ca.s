# FUN_0045e1ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e1ca
# extent:       0x0045e1ca-0x0045e4d4 (778 code bytes)
# span:         0x0045e1ca-0x0045e4d4 (code 778, tables 0, padding 0)
# sha256:       e5deb2d574791e94553f78d1bf472d3665447c9c1c228aeddc6b4711f591f0b5
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45e1ca_hit_test
# naming:       native port src/original_methods_fl25a.c:m45e1ca_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m45e1ca_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_214, field_31d, field_321, field_3ae, field_65f, field_723, field_1336, field_133a, field_133e, field_1342; [ecx + n] field_4, field_8, field_29a, field_31d, field_657, field_65b, field_723; [edx + n] field_25, field_144, field_214, field_29a, field_31d, field_39e, field_653, field_723
# callees:      calls FUN_0045e4d4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m45e1ca_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 186 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_25, 0x25  # offset +0x25
.equ field_144, 0x144  # offset +0x144
.equ field_214, 0x214  # offset +0x214
.equ field_29a, 0x29a  # offset +0x29a
.equ field_31d, 0x31d  # offset +0x31d
.equ field_321, 0x321  # offset +0x321
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3ae, 0x3ae  # offset +0x3ae
.equ field_653, 0x653  # offset +0x653
.equ field_657, 0x657  # offset +0x657
.equ field_65b, 0x65b  # offset +0x65b
.equ field_65f, 0x65f  # offset +0x65f
.equ field_723, 0x723  # offset +0x723
.equ field_1336, 0x1336  # offset +0x1336
.equ field_133a, 0x133a  # offset +0x133a
.equ field_133e, 0x133e  # offset +0x133e
.equ field_1342, 0x1342  # offset +0x1342

# --- external targets -----------------------------------------------
.set FUN_0045e4d4, .text + (0x0045e4d4 - 0x401000)

.org 0x0045e1ca - 0x401000
.globl FUN_0045e1ca
FUN_0045e1ca:
    # block 0x0045e1ca: entry, 9 instruction(s), ends with je to 0x0045e4cc (forward)
    push ebp                                     # 0045e1ca
    {load} mov ebp, esp                          # 0045e1cb
    sub esp, 0xc                                 # 0045e1cd
    mov dword ptr [ebp - local_c], ecx           # 0045e1d0
    mov eax, dword ptr [ebp - local_c]           # 0045e1d3
    {load} xor ecx, ecx                          # 0045e1d6
    mov cl, byte ptr [eax + field_321]           # 0045e1d8
    test ecx, ecx                                # 0045e1de
    je.d32 L_0045e4cc                            # 0045e1e0
    # block 0x0045e1e6: entered by fall-through of je at 0x0045e1e0, 3 instruction(s), ends with jne to 0x0045e464 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0045e1e6
    cmp dword ptr [edx + field_39e], 0x4         # 0045e1e9
    jne.d32 L_0045e464                           # 0045e1f0
    # block 0x0045e1f6: entered by fall-through of jne at 0x0045e1f0, 5 instruction(s), ends with je to 0x0045e308 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0045e1f6
    {load} xor ecx, ecx                          # 0045e1f9
    mov cl, byte ptr [eax + field_3ae]           # 0045e1fb
    test ecx, ecx                                # 0045e201
    je.d32 L_0045e308                            # 0045e203
    # block 0x0045e209: entered by fall-through of je at 0x0045e203, 2 instruction(s), ends with forward jump to 0x0045e21d
    mov word ptr [ebp - local_4], 0x0            # 0045e209
    jmp.d8 L_0045e21d                            # 0045e20f
L_0045e211:
    # block 0x0045e211: entered by jmp at 0x0045e2fe, 3 instruction(s), falls into the block at 0x0045e21d
    mov dx, word ptr [ebp - local_4]             # 0045e211
    add dx, 0x1                                  # 0045e215
    mov word ptr [ebp - local_4], dx             # 0045e219
L_0045e21d:
    # block 0x0045e21d: entered by jmp at 0x0045e20f, 6 instruction(s), ends with jge to 0x0045e303 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045e21d
    mov ecx, dword ptr [ebp - local_c]           # 0045e221
    mov edx, dword ptr [ecx + field_31d]         # 0045e224
    movsx ecx, word ptr [edx + field_25]         # 0045e22a
    {load} cmp eax, ecx                          # 0045e22e
    jge.d32 L_0045e303                           # 0045e230
    # block 0x0045e236: entered by fall-through of jge at 0x0045e230, 7 instruction(s), ends with jl to 0x0045e2fe (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045e236
    mov eax, dword ptr [ebp - local_c]           # 0045e23a
    mov ecx, dword ptr [eax + field_31d]         # 0045e23d
    movsx eax, word ptr [ebp - local_4]          # 0045e243
    shl eax, 0x4                                 # 0045e247
    cmp edx, dword ptr [ecx + eax + field_657]   # 0045e24a
    jl.d32 L_0045e2fe                            # 0045e251
    # block 0x0045e257: entered by fall-through of jl at 0x0045e251, 7 instruction(s), ends with jg to 0x0045e2fe (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045e257
    mov edx, dword ptr [ebp - local_c]           # 0045e25b
    mov eax, dword ptr [edx + field_31d]         # 0045e25e
    movsx edx, word ptr [ebp - local_4]          # 0045e264
    shl edx, 0x4                                 # 0045e268
    cmp ecx, dword ptr [eax + edx + field_65f]   # 0045e26b
    jg.d32 L_0045e2fe                            # 0045e272
    # block 0x0045e278: entered by fall-through of jg at 0x0045e272, 7 instruction(s), ends with jl to 0x0045e2fe (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045e278
    mov ecx, dword ptr [ebp - local_c]           # 0045e27c
    mov edx, dword ptr [ecx + field_31d]         # 0045e27f
    movsx ecx, word ptr [ebp - local_4]          # 0045e285
    shl ecx, 0x4                                 # 0045e289
    cmp eax, dword ptr [edx + ecx + field_653]   # 0045e28c
    jl.d8 L_0045e2fe                             # 0045e293
    # block 0x0045e295: entered by fall-through of jl at 0x0045e293, 7 instruction(s), ends with jg to 0x0045e2fe (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0045e295
    mov eax, dword ptr [ebp - local_c]           # 0045e299
    mov ecx, dword ptr [eax + field_31d]         # 0045e29c
    movsx eax, word ptr [ebp - local_4]          # 0045e2a2
    shl eax, 0x4                                 # 0045e2a6
    cmp edx, dword ptr [ecx + eax + field_65b]   # 0045e2a9
    jg.d8 L_0045e2fe                             # 0045e2b0
    # block 0x0045e2b2: entered by fall-through of jg at 0x0045e2b0, 5 instruction(s), ends with jle to 0x0045e2fe (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0045e2b2
    mov edx, dword ptr [ebp - local_c]           # 0045e2b6
    movsx eax, word ptr [edx + 2*ecx + field_214] # 0045e2b9
    test eax, eax                                # 0045e2c1
    jle.d8 L_0045e2fe                            # 0045e2c3
    # block 0x0045e2c5: entered by fall-through of jle at 0x0045e2c3, 5 instruction(s), ends with jge to 0x0045e2fe (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0045e2c5
    mov edx, dword ptr [ebp - local_c]           # 0045e2c9
    movsx eax, word ptr [edx + 2*ecx + field_214] # 0045e2cc
    cmp eax, 0x3                                 # 0045e2d4
    jge.d8 L_0045e2fe                            # 0045e2d7
    # block 0x0045e2d9: entered by fall-through of jge at 0x0045e2d7, 8 instruction(s), calls FUN_0045e4d4, ends with forward jump to 0x0045e4ce
    mov ecx, dword ptr [ebp - local_c]           # 0045e2d9
    mov dx, word ptr [ebp - local_4]             # 0045e2dc
    mov word ptr [ecx + field_29a], dx           # 0045e2e0
    push 0x27ed                                  # 0045e2e7
    mov ecx, dword ptr [ebp - local_c]           # 0045e2ec
    call FUN_0045e4d4                            # 0045e2ef
    mov eax, 0x1                                 # 0045e2f4
    jmp.d32 L_0045e4ce                           # 0045e2f9
L_0045e2fe:
    # block 0x0045e2fe: entered by jl at 0x0045e251; jg at 0x0045e272; jl at 0x0045e293; jg at 0x0045e2b0; more, 1 instruction(s), ends with backward jump to 0x0045e211
    jmp.d32 L_0045e211                           # 0045e2fe
L_0045e303:
    # block 0x0045e303: entered by jge at 0x0045e230, 1 instruction(s), ends with forward jump to 0x0045e464
    jmp.d32 L_0045e464                           # 0045e303
L_0045e308:
    # block 0x0045e308: entered by je at 0x0045e203, 2 instruction(s), ends with forward jump to 0x0045e31c
    mov word ptr [ebp - local_8], 0x0            # 0045e308
    jmp.d8 L_0045e31c                            # 0045e30e
L_0045e310:
    # block 0x0045e310: entered by jmp at 0x0045e45f, 3 instruction(s), falls into the block at 0x0045e31c
    mov ax, word ptr [ebp - local_8]             # 0045e310
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045e314
    mov word ptr [ebp - local_8], ax             # 0045e318
L_0045e31c:
    # block 0x0045e31c: entered by jmp at 0x0045e30e, 3 instruction(s), ends with jge to 0x0045e464 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0045e31c
    cmp ecx, 0x3                                 # 0045e320
    jge.d32 L_0045e464                           # 0045e323
    # block 0x0045e329: entered by fall-through of jge at 0x0045e323, 2 instruction(s), ends with forward jump to 0x0045e33d
    mov word ptr [ebp - local_4], 0x0            # 0045e329
    jmp.d8 L_0045e33d                            # 0045e32f
L_0045e331:
    # block 0x0045e331: entered by jmp at 0x0045e45a, 3 instruction(s), falls into the block at 0x0045e33d
    mov dx, word ptr [ebp - local_4]             # 0045e331
    add dx, 0x1                                  # 0045e335
    mov word ptr [ebp - local_4], dx             # 0045e339
L_0045e33d:
    # block 0x0045e33d: entered by jmp at 0x0045e32f, 6 instruction(s), ends with jge to 0x0045e45f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045e33d
    mov ecx, dword ptr [ebp - local_c]           # 0045e341
    mov edx, dword ptr [ecx + field_31d]         # 0045e344
    movsx ecx, word ptr [edx + field_25]         # 0045e34a
    {load} cmp eax, ecx                          # 0045e34e
    jge.d32 L_0045e45f                           # 0045e350
    # block 0x0045e356: entered by fall-through of jge at 0x0045e350, 10 instruction(s), ends with jl to 0x0045e45a (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045e356
    mov eax, dword ptr [ebp - local_c]           # 0045e35a
    mov ecx, dword ptr [eax + field_31d]         # 0045e35d
    movsx eax, word ptr [ebp - local_8]          # 0045e363
    imul eax, eax, 0xd0                          # 0045e367
    lea ecx, [ecx + eax + field_723]             # 0045e36d
    movsx eax, word ptr [ebp - local_4]          # 0045e374
    shl eax, 0x4                                 # 0045e378
    cmp edx, dword ptr [ecx + eax + field_4]     # 0045e37b
    jl.d32 L_0045e45a                            # 0045e37f
    # block 0x0045e385: entered by fall-through of jl at 0x0045e37f, 10 instruction(s), ends with jg to 0x0045e45a (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045e385
    mov edx, dword ptr [ebp - local_c]           # 0045e389
    mov eax, dword ptr [edx + field_31d]         # 0045e38c
    movsx edx, word ptr [ebp - local_8]          # 0045e392
    imul edx, edx, 0xd0                          # 0045e396
    lea eax, [eax + edx + field_723]             # 0045e39c
    movsx edx, word ptr [ebp - local_4]          # 0045e3a3
    shl edx, 0x4                                 # 0045e3a7
    cmp ecx, dword ptr [eax + edx + field_c]     # 0045e3aa
    jg.d32 L_0045e45a                            # 0045e3ae
    # block 0x0045e3b4: entered by fall-through of jg at 0x0045e3ae, 10 instruction(s), ends with jl to 0x0045e45a (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045e3b4
    mov ecx, dword ptr [ebp - local_c]           # 0045e3b8
    mov edx, dword ptr [ecx + field_31d]         # 0045e3bb
    movsx ecx, word ptr [ebp - local_8]          # 0045e3c1
    imul ecx, ecx, 0xd0                          # 0045e3c5
    lea edx, [edx + ecx + field_723]             # 0045e3cb
    movsx ecx, word ptr [ebp - local_4]          # 0045e3d2
    shl ecx, 0x4                                 # 0045e3d6
    cmp eax, dword ptr [edx + ecx]               # 0045e3d9
    jl.d8 L_0045e45a                             # 0045e3dc
    # block 0x0045e3de: entered by fall-through of jl at 0x0045e3dc, 10 instruction(s), ends with jg to 0x0045e45a (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0045e3de
    mov eax, dword ptr [ebp - local_c]           # 0045e3e2
    mov ecx, dword ptr [eax + field_31d]         # 0045e3e5
    movsx eax, word ptr [ebp - local_8]          # 0045e3eb
    imul eax, eax, 0xd0                          # 0045e3ef
    lea ecx, [ecx + eax + field_723]             # 0045e3f5
    movsx eax, word ptr [ebp - local_4]          # 0045e3fc
    shl eax, 0x4                                 # 0045e400
    cmp edx, dword ptr [ecx + eax + field_8]     # 0045e403
    jg.d8 L_0045e45a                             # 0045e407
    # block 0x0045e409: entered by fall-through of jg at 0x0045e407, 7 instruction(s), ends with jne to 0x0045e45a (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0045e409
    imul ecx, ecx, 0x34                          # 0045e40d
    mov edx, dword ptr [ebp - local_c]           # 0045e410
    lea eax, [edx + ecx + field_144]             # 0045e413
    movsx ecx, word ptr [ebp - local_4]          # 0045e41a
    cmp dword ptr [eax + 4*ecx], 0x1             # 0045e41e
    jne.d8 L_0045e45a                            # 0045e422
    # block 0x0045e424: entered by fall-through of jne at 0x0045e422, 5 instruction(s), ends with jge to 0x0045e45a (forward)
    movsx edx, word ptr [ebp - local_4]          # 0045e424
    mov eax, dword ptr [ebp - local_c]           # 0045e428
    movsx ecx, word ptr [eax + 2*edx + field_214] # 0045e42b
    cmp ecx, 0x3                                 # 0045e433
    jge.d8 L_0045e45a                            # 0045e436
    # block 0x0045e438: entered by fall-through of jge at 0x0045e436, 8 instruction(s), calls FUN_0045e4d4, ends with forward jump to 0x0045e4ce
    mov edx, dword ptr [ebp - local_c]           # 0045e438
    mov ax, word ptr [ebp - local_4]             # 0045e43b
    mov word ptr [edx + field_29a], ax           # 0045e43f
    push 0x27ec                                  # 0045e446
    mov ecx, dword ptr [ebp - local_c]           # 0045e44b
    call FUN_0045e4d4                            # 0045e44e
    mov eax, 0x1                                 # 0045e453
    jmp.d8 L_0045e4ce                            # 0045e458
L_0045e45a:
    # block 0x0045e45a: entered by jl at 0x0045e37f; jg at 0x0045e3ae; jl at 0x0045e3dc; jg at 0x0045e407; more, 1 instruction(s), ends with backward jump to 0x0045e331
    jmp.d32 L_0045e331                           # 0045e45a
L_0045e45f:
    # block 0x0045e45f: entered by jge at 0x0045e350, 1 instruction(s), ends with backward jump to 0x0045e310
    jmp.d32 L_0045e310                           # 0045e45f
L_0045e464:
    # block 0x0045e464: entered by jne at 0x0045e1f0; jmp at 0x0045e303; jge at 0x0045e323, 5 instruction(s), ends with jl to 0x0045e4cc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045e464
    mov edx, dword ptr [ebp - local_c]           # 0045e468
    mov eax, dword ptr [edx + field_31d]         # 0045e46b
    cmp ecx, dword ptr [eax + field_133a]        # 0045e471
    jl.d8 L_0045e4cc                             # 0045e477
    # block 0x0045e479: entered by fall-through of jl at 0x0045e477, 5 instruction(s), ends with jg to 0x0045e4cc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045e479
    mov edx, dword ptr [ebp - local_c]           # 0045e47d
    mov eax, dword ptr [edx + field_31d]         # 0045e480
    cmp ecx, dword ptr [eax + field_1342]        # 0045e486
    jg.d8 L_0045e4cc                             # 0045e48c
    # block 0x0045e48e: entered by fall-through of jg at 0x0045e48c, 5 instruction(s), ends with jl to 0x0045e4cc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045e48e
    mov edx, dword ptr [ebp - local_c]           # 0045e492
    mov eax, dword ptr [edx + field_31d]         # 0045e495
    cmp ecx, dword ptr [eax + field_1336]        # 0045e49b
    jl.d8 L_0045e4cc                             # 0045e4a1
    # block 0x0045e4a3: entered by fall-through of jl at 0x0045e4a1, 5 instruction(s), ends with jg to 0x0045e4cc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045e4a3
    mov edx, dword ptr [ebp - local_c]           # 0045e4a7
    mov eax, dword ptr [edx + field_31d]         # 0045e4aa
    cmp ecx, dword ptr [eax + field_133e]        # 0045e4b0
    jg.d8 L_0045e4cc                             # 0045e4b6
    # block 0x0045e4b8: entered by fall-through of jg at 0x0045e4b6, 5 instruction(s), calls FUN_0045e4d4, ends with forward jump to 0x0045e4ce
    push 0x27ef                                  # 0045e4b8
    mov ecx, dword ptr [ebp - local_c]           # 0045e4bd
    call FUN_0045e4d4                            # 0045e4c0
    mov eax, 0x1                                 # 0045e4c5
    jmp.d8 L_0045e4ce                            # 0045e4ca
L_0045e4cc:
    # block 0x0045e4cc: entered by je at 0x0045e1e0; jl at 0x0045e477; jg at 0x0045e48c; jl at 0x0045e4a1; jg at 0x0045e4b6, 1 instruction(s), falls into the block at 0x0045e4ce
    {load} xor eax, eax                          # 0045e4cc
L_0045e4ce:
    # block 0x0045e4ce: entered by jmp at 0x0045e2f9; jmp at 0x0045e458; jmp at 0x0045e4ca, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0045e4ce
    pop ebp                                      # 0045e4d0
    ret 0x8                                      # 0045e4d1

