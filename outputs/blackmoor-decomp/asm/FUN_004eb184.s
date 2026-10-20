# FUN_004eb184
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb184
# extent:       0x004eb184-0x004eb5f2 (1134 code bytes)
# span:         0x004eb184-0x004eb5f2 (code 1134, tables 0, padding 0)
# sha256:       9697ef900ada7709606181748cb34899040fc5e8a7802c6cf8eb432318d20187
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eb184_use_feedback
# naming:       native port src/original_methods_fl26b.c:m4eb184_use_feedback (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4eb184_*: models the real frame (60-byte buffer to the live flag); strings of 0x7c+ or struct 0x38+ chars are rejected natively. Direct, differential 329/329, oracle. See tasks/fl26b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_9, local_b, local_f, local_11, local_13, local_15, local_17, local_38, local_3c, local_40, local_44 and 2 more
# fields:       [eax + n] field_56, field_77, field_74e; [ecx + n] field_56, field_74e, field_8256; [edi + n] field_minus_1; [edx + n] field_56, field_69d, field_74e, field_8286
# callees:      calls FUN_0050cd50, FUN_004f6334, FUN_004fb77a, FUN_00423259, FUN_00448d11, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl26b.c:m4eb184_use_feedback (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 329 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_b, 0xb  # offset -0xb
.equ local_f, 0xf  # offset -0xf
.equ local_11, 0x11  # offset -0x11
.equ local_13, 0x13  # offset -0x13
.equ local_15, 0x15  # offset -0x15
.equ local_17, 0x17  # offset -0x17
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ arg_8, 0x8  # offset +0x8
.equ field_56, 0x56  # offset +0x56
.equ field_77, 0x77  # offset +0x77
.equ field_69d, 0x69d  # offset +0x69d
.equ field_74e, 0x74e  # offset +0x74e
.equ field_8256, 0x8256  # offset +0x8256
.equ field_8286, 0x8286  # offset +0x8286

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004eb184 - 0x401000
.globl FUN_004eb184
FUN_004eb184:
    # block 0x004eb184: entry, 9 instruction(s), ends with jge to 0x004eb1a7 (forward)
    push ebp                                     # 004eb184
    {load} mov ebp, esp                          # 004eb185
    sub esp, 0x84                                # 004eb187
    push esi                                     # 004eb18d
    push edi                                     # 004eb18e
    mov dword ptr [ebp - local_84], ecx          # 004eb18f
    mov dword ptr [ebp - local_3c], 0x0          # 004eb195
    cmp dword ptr [ebp + arg_8], 0x0             # 004eb19c
    jge.d8 L_004eb1a7                            # 004eb1a0
    # block 0x004eb1a2: entered by fall-through of jge at 0x004eb1a0, 1 instruction(s), ends with forward jump to 0x004eb5ea
    jmp.d32 L_004eb5ea                           # 004eb1a2
L_004eb1a7:
    # block 0x004eb1a7: entered by jge at 0x004eb1a0, 6 instruction(s), ends with jne to 0x004eb24c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004eb1a7
    imul eax, eax, 0x6e                          # 004eb1aa
    {load} xor ecx, ecx                          # 004eb1ad
    mov cl, byte ptr [eax + 0x583f1f]            # 004eb1af
    test ecx, ecx                                # 004eb1b5
    jne.d32 L_004eb24c                           # 004eb1b7
    # block 0x004eb1bd: entered by fall-through of jne at 0x004eb1b7, 1 instruction(s), falls into the block at 0x004eb1c3
    mov word ptr [ebp - local_40], 0x1           # 004eb1bd
L_004eb1c3:
    # block 0x004eb1c3: entered by jmp at 0x004eb23a, 3 instruction(s), ends with jg to 0x004eb23c (forward)
    movsx edx, word ptr [ebp - local_40]         # 004eb1c3
    cmp edx, 0x2                                 # 004eb1c7
    jg.d8 L_004eb23c                             # 004eb1ca
    # block 0x004eb1cc: entered by fall-through of jg at 0x004eb1ca, 12 instruction(s), ends with je to 0x004eb23c (forward)
    mov edi, 0x55cba0                            # 004eb1cc
    mov eax, dword ptr [ebp + arg_8]             # 004eb1d1
    imul eax, eax, 0x16d                         # 004eb1d4
    mov ecx, dword ptr [ebp - local_84]          # 004eb1da
    lea edx, [ecx + eax + field_74e]             # 004eb1e0
    movsx eax, word ptr [ebp - local_40]         # 004eb1e7
    imul eax, eax, 0x5d                          # 004eb1eb
    lea esi, [edx + eax + field_56]              # 004eb1ee
    mov ecx, 0x9                                 # 004eb1f2
    {load} xor edx, edx                          # 004eb1f7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eb1f9
    je.d8 L_004eb23c                             # 004eb1fb
    # block 0x004eb1fd: entered by fall-through of je at 0x004eb1fb, 12 instruction(s), ends with je to 0x004eb23c (forward)
    mov edi, 0x63aa00                            # 004eb1fd
    mov eax, dword ptr [ebp + arg_8]             # 004eb202
    imul eax, eax, 0x16d                         # 004eb205
    mov ecx, dword ptr [ebp - local_84]          # 004eb20b
    lea edx, [ecx + eax + field_74e]             # 004eb211
    movsx eax, word ptr [ebp - local_40]         # 004eb218
    imul eax, eax, 0x5d                          # 004eb21c
    lea esi, [edx + eax + field_56]              # 004eb21f
    mov ecx, 0x1                                 # 004eb223
    {load} xor edx, edx                          # 004eb228
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eb22a
    je.d8 L_004eb23c                             # 004eb22c
    # block 0x004eb22e: entered by fall-through of je at 0x004eb22c, 4 instruction(s), ends with backward jump to 0x004eb1c3
    mov ax, word ptr [ebp - local_40]            # 004eb22e
    .insn 0x66, 0x05, 0x0001{:u16}               # 004eb232
    mov word ptr [ebp - local_40], ax            # 004eb236
    jmp.d8 L_004eb1c3                            # 004eb23a
L_004eb23c:
    # block 0x004eb23c: entered by jg at 0x004eb1ca; je at 0x004eb1fb; je at 0x004eb22c, 5 instruction(s), calls FUN_0050cd50, falls into the block at 0x004eb24c
    call FUN_0050cd50                            # 004eb23c
    movsx ecx, word ptr [ebp - local_40]         # 004eb241
    cdq                                          # 004eb245
    idiv ecx                                     # 004eb246
    mov word ptr [ebp - local_44], dx            # 004eb248
L_004eb24c:
    # block 0x004eb24c: entered by jne at 0x004eb1b7, 6 instruction(s), calls FUN_004f6334, ends with jne to 0x004eb5ea (forward)
    mov dword ptr [ebp - local_4], 0x0           # 004eb24c
    push 0x11                                    # 004eb253
    mov ecx, 0x5cf1eb                            # 004eb255
    call FUN_004f6334                            # 004eb25a
    test eax, eax                                # 004eb25f
    jne.d32 L_004eb5ea                           # 004eb261
    # block 0x004eb267: entered by fall-through of jne at 0x004eb261, 6 instruction(s), ends with je to 0x004eb383 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004eb267
    imul edx, edx, 0x6e                          # 004eb26a
    {load} xor eax, eax                          # 004eb26d
    mov al, byte ptr [edx + 0x583f1f]            # 004eb26f
    test eax, eax                                # 004eb275
    je.d32 L_004eb383                            # 004eb277
    # block 0x004eb27d: entered by fall-through of je at 0x004eb277, 8 instruction(s), ends with je to 0x004eb37e (forward)
    mov edi, 0x55cbac                            # 004eb27d
    mov esi, dword ptr [ebp + arg_8]             # 004eb282
    imul esi, esi, 0x6e                          # 004eb285
    add esi, 0x583f5c                            # 004eb288
    mov ecx, 0x9                                 # 004eb28e
    {load} xor edx, edx                          # 004eb293
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eb295
    je.d32 L_004eb37e                            # 004eb297
    # block 0x004eb29d: entered by fall-through of je at 0x004eb297, 9 instruction(s), calls FUN_004fb77a, ends with je to 0x004eb350 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004eb29d
    imul eax, eax, 0x6e                          # 004eb2a0
    add eax, 0x583f5c                            # 004eb2a3
    push eax                                     # 004eb2a8
    mov ecx, 0x5c3a67                            # 004eb2a9
    call FUN_004fb77a                            # 004eb2ae
    mov dword ptr [ebp - local_4], 0x1           # 004eb2b3
    cmp dword ptr [0x5bb202], 0x0                # 004eb2ba
    je.d32 L_004eb350                            # 004eb2c1
    # block 0x004eb2c7: entered by fall-through of je at 0x004eb2c1, 9 instruction(s), calls FUN_00423259, ends with je to 0x004eb350 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004eb2c7
    imul ecx, ecx, 0x6e                          # 004eb2ca
    add ecx, 0x583f5c                            # 004eb2cd
    push ecx                                     # 004eb2d3
    mov ecx, 0x619a6b                            # 004eb2d4
    call FUN_00423259                            # 004eb2d9
    mov dword ptr [ebp - local_3c], eax          # 004eb2de
    cmp dword ptr [ebp - local_3c], 0x0          # 004eb2e1
    je.d8 L_004eb350                             # 004eb2e5
    # block 0x004eb2e7: entered by fall-through of je at 0x004eb2e5, 8 instruction(s), ends with ja to 0x004eb320 (forward)
    mov edi, dword ptr [ebp - local_3c]          # 004eb2e7
    or ecx, -0x1                                 # 004eb2ea
    {load} xor eax, eax                          # 004eb2ed
    repne scasb al, byte ptr es:[edi]            # 004eb2ef
    not ecx                                      # 004eb2f1
    add ecx, -0x1                                # 004eb2f3
    cmp ecx, 0x3c                                # 004eb2f6
    ja.d8 L_004eb320                             # 004eb2f9
    # block 0x004eb2fb: entered by fall-through of ja at 0x004eb2f9, 16 instruction(s), ends with forward jump to 0x004eb34e
    mov edi, dword ptr [ebp - local_3c]          # 004eb2fb
    lea edx, [ebp - local_80]                    # 004eb2fe
    or ecx, -0x1                                 # 004eb301
    {load} xor eax, eax                          # 004eb304
    repne scasb al, byte ptr es:[edi]            # 004eb306
    not ecx                                      # 004eb308
    {load} sub edi, ecx                          # 004eb30a
    {load} mov esi, edi                          # 004eb30c
    {load} mov eax, ecx                          # 004eb30e
    {load} mov edi, edx                          # 004eb310
    shr ecx, 0x2                                 # 004eb312
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb315
    {load} mov ecx, eax                          # 004eb317
    and ecx, 0x3                                 # 004eb319
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb31c
    jmp.d8 L_004eb34e                            # 004eb31e
L_004eb320:
    # block 0x004eb320: entered by ja at 0x004eb2f9, 18 instruction(s), falls into the block at 0x004eb34e
    mov ecx, dword ptr [ebp + arg_8]             # 004eb320
    imul ecx, ecx, 0x6e                          # 004eb323
    add ecx, 0x583f5c                            # 004eb326
    {load} mov edi, ecx                          # 004eb32c
    lea edx, [ebp - local_80]                    # 004eb32e
    or ecx, -0x1                                 # 004eb331
    {load} xor eax, eax                          # 004eb334
    repne scasb al, byte ptr es:[edi]            # 004eb336
    not ecx                                      # 004eb338
    {load} sub edi, ecx                          # 004eb33a
    {load} mov esi, edi                          # 004eb33c
    {load} mov eax, ecx                          # 004eb33e
    {load} mov edi, edx                          # 004eb340
    shr ecx, 0x2                                 # 004eb342
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb345
    {load} mov ecx, eax                          # 004eb347
    and ecx, 0x3                                 # 004eb349
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb34c
L_004eb34e:
    # block 0x004eb34e: entered by jmp at 0x004eb31e, 1 instruction(s), ends with forward jump to 0x004eb37e
    jmp.d8 L_004eb37e                            # 004eb34e
L_004eb350:
    # block 0x004eb350: entered by je at 0x004eb2c1; je at 0x004eb2e5, 18 instruction(s), falls into the block at 0x004eb37e
    mov ecx, dword ptr [ebp + arg_8]             # 004eb350
    imul ecx, ecx, 0x6e                          # 004eb353
    add ecx, 0x583f5c                            # 004eb356
    {load} mov edi, ecx                          # 004eb35c
    lea edx, [ebp - local_80]                    # 004eb35e
    or ecx, -0x1                                 # 004eb361
    {load} xor eax, eax                          # 004eb364
    repne scasb al, byte ptr es:[edi]            # 004eb366
    not ecx                                      # 004eb368
    {load} sub edi, ecx                          # 004eb36a
    {load} mov esi, edi                          # 004eb36c
    {load} mov eax, ecx                          # 004eb36e
    {load} mov edi, edx                          # 004eb370
    shr ecx, 0x2                                 # 004eb372
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb375
    {load} mov ecx, eax                          # 004eb377
    and ecx, 0x3                                 # 004eb379
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb37c
L_004eb37e:
    # block 0x004eb37e: entered by je at 0x004eb297; jmp at 0x004eb34e, 1 instruction(s), ends with forward jump to 0x004eb573
    jmp.d32 L_004eb573                           # 004eb37e
L_004eb383:
    # block 0x004eb383: entered by je at 0x004eb277, 12 instruction(s), ends with je to 0x004eb573 (forward)
    mov edi, 0x55cbb8                            # 004eb383
    mov ecx, dword ptr [ebp + arg_8]             # 004eb388
    imul ecx, ecx, 0x16d                         # 004eb38b
    mov edx, dword ptr [ebp - local_84]          # 004eb391
    lea eax, [edx + ecx + field_74e]             # 004eb397
    movsx ecx, word ptr [ebp - local_44]         # 004eb39e
    imul ecx, ecx, 0x5d                          # 004eb3a2
    lea esi, [eax + ecx + field_56]              # 004eb3a5
    mov ecx, 0x9                                 # 004eb3a9
    {load} xor edx, edx                          # 004eb3ae
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eb3b0
    je.d32 L_004eb573                            # 004eb3b2
    # block 0x004eb3b8: entered by fall-through of je at 0x004eb3b2, 12 instruction(s), ends with je to 0x004eb573 (forward)
    mov edi, 0x63aa04                            # 004eb3b8
    mov eax, dword ptr [ebp + arg_8]             # 004eb3bd
    imul eax, eax, 0x16d                         # 004eb3c0
    mov ecx, dword ptr [ebp - local_84]          # 004eb3c6
    lea edx, [ecx + eax + field_74e]             # 004eb3cc
    movsx eax, word ptr [ebp - local_44]         # 004eb3d3
    imul eax, eax, 0x5d                          # 004eb3d7
    lea esi, [edx + eax + field_56]              # 004eb3da
    mov ecx, 0x1                                 # 004eb3de
    {load} xor edx, edx                          # 004eb3e3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004eb3e5
    je.d32 L_004eb573                            # 004eb3e7
    # block 0x004eb3ed: entered by fall-through of je at 0x004eb3e7, 36 instruction(s), calls FUN_004fb77a, ends with je to 0x004eb530 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004eb3ed
    imul eax, eax, 0x16d                         # 004eb3f0
    mov ecx, dword ptr [ebp - local_84]          # 004eb3f6
    lea edx, [ecx + eax + field_74e]             # 004eb3fc
    movsx eax, word ptr [ebp - local_44]         # 004eb403
    imul eax, eax, 0x5d                          # 004eb407
    lea ecx, [edx + eax + field_56]              # 004eb40a
    {load} mov edi, ecx                          # 004eb40e
    lea edx, [ebp - local_38]                    # 004eb410
    or ecx, -0x1                                 # 004eb413
    {load} xor eax, eax                          # 004eb416
    repne scasb al, byte ptr es:[edi]            # 004eb418
    not ecx                                      # 004eb41a
    {load} sub edi, ecx                          # 004eb41c
    {load} mov esi, edi                          # 004eb41e
    {load} mov eax, ecx                          # 004eb420
    {load} mov edi, edx                          # 004eb422
    shr ecx, 0x2                                 # 004eb424
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb427
    {load} mov ecx, eax                          # 004eb429
    and ecx, 0x3                                 # 004eb42b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb42e
    mov word ptr [ebp - local_17], 0x11          # 004eb430
    mov word ptr [ebp - local_15], 0x1           # 004eb436
    mov word ptr [ebp - local_13], 0x1           # 004eb43c
    mov word ptr [ebp - local_11], 0x1           # 004eb442
    mov dword ptr [ebp - local_f], 0x1           # 004eb448
    mov word ptr [ebp - local_b], 0x55           # 004eb44f
    mov word ptr [ebp - local_9], 0x55           # 004eb455
    lea ecx, [ebp - local_38]                    # 004eb45b
    push ecx                                     # 004eb45e
    mov ecx, 0x5c3a67                            # 004eb45f
    call FUN_004fb77a                            # 004eb464
    mov dword ptr [ebp - local_4], 0x1           # 004eb469
    cmp dword ptr [0x5bb202], 0x0                # 004eb470
    je.d32 L_004eb530                            # 004eb477
    # block 0x004eb47d: entered by fall-through of je at 0x004eb477, 13 instruction(s), calls FUN_00423259, ends with je to 0x004eb530 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004eb47d
    imul edx, edx, 0x16d                         # 004eb480
    mov eax, dword ptr [ebp - local_84]          # 004eb486
    lea ecx, [eax + edx + field_74e]             # 004eb48c
    movsx edx, word ptr [ebp - local_44]         # 004eb493
    imul edx, edx, 0x5d                          # 004eb497
    lea eax, [ecx + edx + field_56]              # 004eb49a
    push eax                                     # 004eb49e
    mov ecx, 0x619a6b                            # 004eb49f
    call FUN_00423259                            # 004eb4a4
    mov dword ptr [ebp - local_3c], eax          # 004eb4a9
    cmp dword ptr [ebp - local_3c], 0x0          # 004eb4ac
    je.d8 L_004eb530                             # 004eb4b0
    # block 0x004eb4b2: entered by fall-through of je at 0x004eb4b0, 8 instruction(s), ends with ja to 0x004eb4eb (forward)
    mov edi, dword ptr [ebp - local_3c]          # 004eb4b2
    or ecx, -0x1                                 # 004eb4b5
    {load} xor eax, eax                          # 004eb4b8
    repne scasb al, byte ptr es:[edi]            # 004eb4ba
    not ecx                                      # 004eb4bc
    add ecx, -0x1                                # 004eb4be
    cmp ecx, 0x3c                                # 004eb4c1
    ja.d8 L_004eb4eb                             # 004eb4c4
    # block 0x004eb4c6: entered by fall-through of ja at 0x004eb4c4, 16 instruction(s), ends with forward jump to 0x004eb52e
    mov edi, dword ptr [ebp - local_3c]          # 004eb4c6
    lea edx, [ebp - local_80]                    # 004eb4c9
    or ecx, -0x1                                 # 004eb4cc
    {load} xor eax, eax                          # 004eb4cf
    repne scasb al, byte ptr es:[edi]            # 004eb4d1
    not ecx                                      # 004eb4d3
    {load} sub edi, ecx                          # 004eb4d5
    {load} mov esi, edi                          # 004eb4d7
    {load} mov eax, ecx                          # 004eb4d9
    {load} mov edi, edx                          # 004eb4db
    shr ecx, 0x2                                 # 004eb4dd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb4e0
    {load} mov ecx, eax                          # 004eb4e2
    and ecx, 0x3                                 # 004eb4e4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb4e7
    jmp.d8 L_004eb52e                            # 004eb4e9
L_004eb4eb:
    # block 0x004eb4eb: entered by ja at 0x004eb4c4, 22 instruction(s), falls into the block at 0x004eb52e
    mov ecx, dword ptr [ebp + arg_8]             # 004eb4eb
    imul ecx, ecx, 0x16d                         # 004eb4ee
    mov edx, dword ptr [ebp - local_84]          # 004eb4f4
    lea eax, [edx + ecx + field_74e]             # 004eb4fa
    movsx ecx, word ptr [ebp - local_44]         # 004eb501
    imul ecx, ecx, 0x5d                          # 004eb505
    lea edx, [eax + ecx + field_77]              # 004eb508
    {load} mov edi, edx                          # 004eb50c
    lea edx, [ebp - local_80]                    # 004eb50e
    or ecx, -0x1                                 # 004eb511
    {load} xor eax, eax                          # 004eb514
    repne scasb al, byte ptr es:[edi]            # 004eb516
    not ecx                                      # 004eb518
    {load} sub edi, ecx                          # 004eb51a
    {load} mov esi, edi                          # 004eb51c
    {load} mov eax, ecx                          # 004eb51e
    {load} mov edi, edx                          # 004eb520
    shr ecx, 0x2                                 # 004eb522
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb525
    {load} mov ecx, eax                          # 004eb527
    and ecx, 0x3                                 # 004eb529
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb52c
L_004eb52e:
    # block 0x004eb52e: entered by jmp at 0x004eb4e9, 1 instruction(s), ends with forward jump to 0x004eb573
    jmp.d8 L_004eb573                            # 004eb52e
L_004eb530:
    # block 0x004eb530: entered by je at 0x004eb477; je at 0x004eb4b0, 22 instruction(s), falls into the block at 0x004eb573
    mov ecx, dword ptr [ebp + arg_8]             # 004eb530
    imul ecx, ecx, 0x16d                         # 004eb533
    mov edx, dword ptr [ebp - local_84]          # 004eb539
    lea eax, [edx + ecx + field_74e]             # 004eb53f
    movsx ecx, word ptr [ebp - local_44]         # 004eb546
    imul ecx, ecx, 0x5d                          # 004eb54a
    lea edx, [eax + ecx + field_77]              # 004eb54d
    {load} mov edi, edx                          # 004eb551
    lea edx, [ebp - local_80]                    # 004eb553
    or ecx, -0x1                                 # 004eb556
    {load} xor eax, eax                          # 004eb559
    repne scasb al, byte ptr es:[edi]            # 004eb55b
    not ecx                                      # 004eb55d
    {load} sub edi, ecx                          # 004eb55f
    {load} mov esi, edi                          # 004eb561
    {load} mov eax, ecx                          # 004eb563
    {load} mov edi, edx                          # 004eb565
    shr ecx, 0x2                                 # 004eb567
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb56a
    {load} mov ecx, eax                          # 004eb56c
    and ecx, 0x3                                 # 004eb56e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb571
L_004eb573:
    # block 0x004eb573: entered by jmp at 0x004eb37e; je at 0x004eb3b2; je at 0x004eb3e7; jmp at 0x004eb52e, 2 instruction(s), ends with je to 0x004eb5ea (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004eb573
    je.d8 L_004eb5ea                             # 004eb577
    # block 0x004eb579: entered by fall-through of je at 0x004eb577, 2 instruction(s), ends with je to 0x004eb5de (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004eb579
    je.d8 L_004eb5de                             # 004eb580
    # block 0x004eb582: entered by fall-through of je at 0x004eb580, 22 instruction(s), calls FUN_00448d11, falls into the block at 0x004eb5de
    lea edi, [ebp - local_80]                    # 004eb582
    or ecx, -0x1                                 # 004eb585
    {load} xor eax, eax                          # 004eb588
    repne scasb al, byte ptr es:[edi]            # 004eb58a
    mov ecx, dword ptr [0x55cbc4]                # 004eb58c
    mov dword ptr [edi - field_minus_1], ecx     # 004eb592
    push 0x0                                     # 004eb595
    push -0x1                                    # 004eb597
    lea edx, [ebp - local_80]                    # 004eb599
    push edx                                     # 004eb59c
    mov eax, dword ptr [0x5d03b3]                # 004eb59d
    push eax                                     # 004eb5a2
    mov ecx, 0x619a05                            # 004eb5a3
    call FUN_00448d11                            # 004eb5a8
    mov ecx, dword ptr [ebp - local_84]          # 004eb5ad
    mov dword ptr [ecx + field_8256], 0x1        # 004eb5b3
    mov edx, dword ptr [ebp - local_84]          # 004eb5bd
    movsx eax, word ptr [edx + field_69d]        # 004eb5c3
    mov ecx, dword ptr [0x585d37]                # 004eb5ca
    {load} add ecx, eax                          # 004eb5d0
    mov edx, dword ptr [ebp - local_84]          # 004eb5d2
    mov dword ptr [edx + field_8286], ecx        # 004eb5d8
L_004eb5de:
    # block 0x004eb5de: entered by je at 0x004eb580, 3 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004eb5ea
    push 0x11                                    # 004eb5de
    mov ecx, 0x5c3a67                            # 004eb5e0
    call FUN_004fb2e3                            # 004eb5e5
L_004eb5ea:
    # block 0x004eb5ea: entered by jmp at 0x004eb1a2; jne at 0x004eb261; je at 0x004eb577, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004eb5ea
    pop esi                                      # 004eb5eb
    {load} mov esp, ebp                          # 004eb5ec
    pop ebp                                      # 004eb5ee
    ret 0x4                                      # 004eb5ef

