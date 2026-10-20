# FUN_0045c18f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045c18f
# extent:       0x0045c18f-0x0045d286 (4343 code bytes)
# span:         0x0045c18f-0x0045d2b6 (code 4343, tables 48, padding 0)
# sha256:       ef5508c356127fcdb0566d39505764585ac5485ea1f3e88cd9a16c49c81a5ee2
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bul_puzzle_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_da_runtime.h:24 says "0x45c18f handler (dispatcher arm 0x42a424 after gate 0x423f57(deps, 0)"
# name-note:    Handler of the raw 0xda Bul puzzle: a switch on the row phase.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_21, field_23, field_24, field_27, field_2c, field_ad, field_b6, field_b8 and 24 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_21, field_23, field_24, field_27, field_28, field_2e and 29 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_24, field_28, field_2c, field_32, field_b6, field_b8, field_ba and 24 more
# callees:      calls FUN_004e8d96, FUN_0045ba0b, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_0045be7f, KERNEL32.dll!GetTickCount, FUN_0050cd50, FUN_004f6334, FUN_004fb2e3, FUN_0045bbd8, FUN_0045bcc1, FUN_0045bda7, FUN_004fba69, FUN_0042ba3a, FUN_0045b42e
# track-n:      outputs/blackmoor-decomp/src/action_family_da_runtime.c:phase0 (function ledger class candidate_port; also phase1, phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 1072 instruction(s), 77 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_ad, 0xad  # offset +0xad
.equ field_b6, 0xb6  # offset +0xb6
.equ field_b8, 0xb8  # offset +0xb8
.equ field_ba, 0xba  # offset +0xba
.equ field_bc, 0xbc  # offset +0xbc
.equ field_ec, 0xec  # offset +0xec
.equ field_124, 0x124  # offset +0x124
.equ field_128, 0x128  # offset +0x128
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_15c, 0x15c  # offset +0x15c
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16e, 0x16e  # offset +0x16e
.equ field_174, 0x174  # offset +0x174
.equ field_176, 0x176  # offset +0x176
.equ field_178, 0x178  # offset +0x178
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17c, 0x17c  # offset +0x17c
.equ field_180, 0x180  # offset +0x180
.equ field_19d, 0x19d  # offset +0x19d
.equ field_1a5, 0x1a5  # offset +0x1a5
.equ field_1b5, 0x1b5  # offset +0x1b5
.equ field_255, 0x255  # offset +0x255
.equ field_259, 0x259  # offset +0x259
.equ field_25d, 0x25d  # offset +0x25d
.equ field_315, 0x315  # offset +0x315
.equ field_319, 0x319  # offset +0x319
.equ field_34d, 0x34d  # offset +0x34d
.equ field_355, 0x355  # offset +0x355
.equ field_3ed, 0x3ed  # offset +0x3ed
.equ field_4ee, 0x4ee  # offset +0x4ee
.equ field_51f, 0x51f  # offset +0x51f
.equ field_581, 0x581  # offset +0x581
.equ field_b49, 0xb49  # offset +0xb49
.equ field_b4b, 0xb4b  # offset +0xb4b
.equ field_b4d, 0xb4d  # offset +0xb4d
.equ field_b4f, 0xb4f  # offset +0xb4f
.equ field_b51, 0xb51  # offset +0xb51
.equ field_b55, 0xb55  # offset +0xb55
.equ field_b59, 0xb59  # offset +0xb59
.equ field_b5d, 0xb5d  # offset +0xb5d
.equ field_b5f, 0xb5f  # offset +0xb5f
.equ field_b61, 0xb61  # offset +0xb61
.equ field_b62, 0xb62  # offset +0xb62
.equ field_b64, 0xb64  # offset +0xb64
.equ field_b65, 0xb65  # offset +0xb65
.equ field_b67, 0xb67  # offset +0xb67
.equ field_b69, 0xb69  # offset +0xb69
.equ field_b6b, 0xb6b  # offset +0xb6b
.equ field_b6d, 0xb6d  # offset +0xb6d
.equ field_b71, 0xb71  # offset +0xb71
.equ field_b75, 0xb75  # offset +0xb75
.equ field_b79, 0xb79  # offset +0xb79
.equ field_b7b, 0xb7b  # offset +0xb7b
.equ field_b7d, 0xb7d  # offset +0xb7d

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0045b42e, .text + (0x0045b42e - 0x401000)
.set FUN_0045ba0b, .text + (0x0045ba0b - 0x401000)
.set FUN_0045bbd8, .text + (0x0045bbd8 - 0x401000)
.set FUN_0045bcc1, .text + (0x0045bcc1 - 0x401000)
.set FUN_0045bda7, .text + (0x0045bda7 - 0x401000)
.set FUN_0045be7f, .text + (0x0045be7f - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045c18f - 0x401000
.globl FUN_0045c18f
FUN_0045c18f:
    # block 0x0045c18f: entry, 16 instruction(s), ends with je to 0x0045c1df (forward)
    push ebp                                     # 0045c18f
    {load} mov ebp, esp                          # 0045c190
    sub esp, 0x28                                # 0045c192
    push esi                                     # 0045c195
    push edi                                     # 0045c196
    mov dword ptr [ebp - local_20], ecx          # 0045c197
    movsx eax, word ptr [ebp + arg_8]            # 0045c19a
    imul eax, eax, 0x8d                          # 0045c19e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045c1a4
    mov dword ptr [ebp - local_4], ecx           # 0045c1aa
    movsx edx, word ptr [ebp + arg_8]            # 0045c1ad
    imul edx, edx, 0x8d                          # 0045c1b1
    mov eax, dword ptr [edx + 0x5bb632]          # 0045c1b7
    mov dword ptr [ebp - local_24], eax          # 0045c1bd
    cmp dword ptr [ebp - local_24], 0x0          # 0045c1c0
    je.d8 L_0045c1df                             # 0045c1c4
    # block 0x0045c1c6: entered by fall-through of je at 0x0045c1c4, 2 instruction(s), ends with je to 0x0045c52e (forward)
    cmp dword ptr [ebp - local_24], 0x1          # 0045c1c6
    je.d32 L_0045c52e                            # 0045c1ca
    # block 0x0045c1d0: entered by fall-through of je at 0x0045c1ca, 2 instruction(s), ends with je to 0x0045cfb6 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 0045c1d0
    je.d32 L_0045cfb6                            # 0045c1d4
    # block 0x0045c1da: entered by fall-through of je at 0x0045c1d4, 1 instruction(s), ends with forward jump to 0x0045d27e
    jmp.d32 L_0045d27e                           # 0045c1da
L_0045c1df:
    # block 0x0045c1df: entered by je at 0x0045c1c4, 138 instruction(s), calls FUN_004e8d96, FUN_0045ba0b, FUN_004d39f9, ends with jne to 0x0045c44c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045c1df
    mov dx, word ptr [ebp + arg_8]               # 0045c1e2
    mov word ptr [ecx + field_1e], dx            # 0045c1e6
    mov eax, dword ptr [ebp - local_20]          # 0045c1ea
    mov dword ptr [eax + field_166], 0x1         # 0045c1ed
    mov dword ptr [0x5bb1ca], 0x1                # 0045c1f7
    mov ecx, 0x571442                            # 0045c201
    call FUN_004e8d96                            # 0045c206
    mov ecx, dword ptr [ebp - local_20]          # 0045c20b
    call FUN_0045ba0b                            # 0045c20e
    {load} xor ecx, ecx                          # 0045c213
    mov dword ptr [0x624810], ecx                # 0045c215
    mov dword ptr [0x624814], ecx                # 0045c21b
    mov dword ptr [0x624818], ecx                # 0045c221
    mov dword ptr [0x62481c], ecx                # 0045c227
    {load} xor edx, edx                          # 0045c22d
    mov dword ptr [0x624840], edx                # 0045c22f
    mov dword ptr [0x624844], edx                # 0045c235
    mov dword ptr [0x624848], edx                # 0045c23b
    mov dword ptr [0x62484c], edx                # 0045c241
    mov eax, dword ptr [ebp - local_20]          # 0045c247
    mov word ptr [eax + field_b6], 0x0           # 0045c24a
    mov ecx, dword ptr [ebp - local_20]          # 0045c253
    mov word ptr [ecx + field_b8], 0x0           # 0045c256
    mov edx, dword ptr [ebp - local_4]           # 0045c25f
    add edx, 0x1fd                               # 0045c262
    mov eax, dword ptr [ebp - local_20]          # 0045c268
    add eax, 0x11c                               # 0045c26b
    mov ecx, dword ptr [edx]                     # 0045c270
    mov dword ptr [eax], ecx                     # 0045c272
    mov ecx, dword ptr [edx + field_4]           # 0045c274
    mov dword ptr [eax + field_4], ecx           # 0045c277
    mov ecx, dword ptr [edx + field_8]           # 0045c27a
    mov dword ptr [eax + field_8], ecx           # 0045c27d
    mov edx, dword ptr [edx + field_c]           # 0045c280
    mov dword ptr [eax + field_c], edx           # 0045c283
    mov eax, dword ptr [ebp - local_20]          # 0045c286
    mov ecx, dword ptr [ebp - local_4]           # 0045c289
    mov edx, dword ptr [ecx + field_255]         # 0045c28c
    mov dword ptr [eax + field_124], edx         # 0045c292
    mov eax, dword ptr [ebp - local_20]          # 0045c298
    mov ecx, dword ptr [ebp - local_4]           # 0045c29b
    mov edx, dword ptr [ecx + field_259]         # 0045c29e
    mov dword ptr [eax + field_128], edx         # 0045c2a4
    mov eax, dword ptr [ebp - local_4]           # 0045c2aa
    add eax, 0x2bd                               # 0045c2ad
    mov ecx, dword ptr [ebp - local_20]          # 0045c2b2
    add ecx, 0x12c                               # 0045c2b5
    mov edx, dword ptr [eax]                     # 0045c2bb
    mov dword ptr [ecx], edx                     # 0045c2bd
    mov edx, dword ptr [eax + field_4]           # 0045c2bf
    mov dword ptr [ecx + field_4], edx           # 0045c2c2
    mov edx, dword ptr [eax + field_8]           # 0045c2c5
    mov dword ptr [ecx + field_8], edx           # 0045c2c8
    mov eax, dword ptr [eax + field_c]           # 0045c2cb
    mov dword ptr [ecx + field_c], eax           # 0045c2ce
    mov ecx, dword ptr [ebp - local_20]          # 0045c2d1
    mov edx, dword ptr [ebp - local_4]           # 0045c2d4
    mov eax, dword ptr [edx + field_315]         # 0045c2d7
    mov dword ptr [ecx + field_134], eax         # 0045c2dd
    mov ecx, dword ptr [ebp - local_20]          # 0045c2e3
    mov edx, dword ptr [ebp - local_4]           # 0045c2e6
    mov eax, dword ptr [edx + field_319]         # 0045c2e9
    mov dword ptr [ecx + field_138], eax         # 0045c2ef
    mov ecx, dword ptr [ebp - local_4]           # 0045c2f5
    mov edx, dword ptr [ebp - local_4]           # 0045c2f8
    mov eax, dword ptr [ecx + field_355]         # 0045c2fb
    sub eax, dword ptr [edx + field_34d]         # 0045c301
    neg eax                                      # 0045c307
    {load} sbb eax, eax                          # 0045c309
    neg eax                                      # 0045c30b
    mov ecx, dword ptr [ebp - local_20]          # 0045c30d
    mov dword ptr [ecx + field_15e], eax         # 0045c310
    mov edx, dword ptr [ebp - local_20]          # 0045c316
    mov dword ptr [edx + field_24], 0x0          # 0045c319
    mov eax, dword ptr [ebp - local_20]          # 0045c320
    mov dword ptr [eax + field_1b5], 0x0         # 0045c323
    mov ecx, dword ptr [ebp - local_20]          # 0045c32d
    movsx edx, word ptr [ecx + field_1e]         # 0045c330
    imul edx, edx, 0x8d                          # 0045c334
    mov dword ptr [edx + 0x5bb632], 0x1          # 0045c33a
    call FUN_004d39f9                            # 0045c344
    mov ecx, dword ptr [ebp - local_20]          # 0045c349
    mov word ptr [ecx + field_1c], ax            # 0045c34c
    mov edx, dword ptr [ebp - local_20]          # 0045c350
    movsx eax, word ptr [edx + field_1c]         # 0045c353
    imul eax, eax, 0x4a                          # 0045c357
    mov dword ptr [eax + 0x5d1591], 0xa          # 0045c35a
    mov ecx, dword ptr [ebp - local_20]          # 0045c364
    movsx edx, word ptr [ecx + field_1c]         # 0045c367
    imul edx, edx, 0x4a                          # 0045c36b
    mov dword ptr [edx + 0x5d1595], 0x45d2c6     # 0045c36e
    mov eax, dword ptr [ebp - local_20]          # 0045c378
    movsx ecx, word ptr [eax + field_1c]         # 0045c37b
    imul ecx, ecx, 0x4a                          # 0045c37f
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0045c382
    mov edx, dword ptr [ebp - local_20]          # 0045c38c
    movsx eax, word ptr [edx + field_1c]         # 0045c38f
    imul eax, eax, 0x4a                          # 0045c393
    mov dword ptr [eax + 0x5d159d], 0x0          # 0045c396
    mov ecx, dword ptr [ebp - local_20]          # 0045c3a0
    movsx edx, word ptr [ecx + field_1c]         # 0045c3a3
    imul edx, edx, 0x4a                          # 0045c3a7
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0045c3aa
    mov eax, dword ptr [ebp - local_20]          # 0045c3b4
    movsx ecx, word ptr [eax + field_1c]         # 0045c3b7
    imul ecx, ecx, 0x4a                          # 0045c3bb
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0045c3be
    mov edx, dword ptr [ebp - local_20]          # 0045c3c8
    movsx eax, word ptr [edx + field_1c]         # 0045c3cb
    imul eax, eax, 0x4a                          # 0045c3cf
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0045c3d2
    mov ecx, dword ptr [ebp - local_20]          # 0045c3dc
    movsx edx, word ptr [ecx + field_1c]         # 0045c3df
    imul edx, edx, 0x4a                          # 0045c3e3
    mov word ptr [edx + 0x5d15ad], 0x0           # 0045c3e6
    mov edi, 0x54ab78                            # 0045c3ef
    mov eax, dword ptr [ebp - local_20]          # 0045c3f4
    movsx ecx, word ptr [eax + field_1c]         # 0045c3f7
    imul ecx, ecx, 0x4a                          # 0045c3fb
    add ecx, 0x5d15b3                            # 0045c3fe
    {load} mov edx, ecx                          # 0045c404
    or ecx, -0x1                                 # 0045c406
    {load} xor eax, eax                          # 0045c409
    repne scasb al, byte ptr es:[edi]            # 0045c40b
    not ecx                                      # 0045c40d
    {load} sub edi, ecx                          # 0045c40f
    {load} mov esi, edi                          # 0045c411
    {load} mov eax, ecx                          # 0045c413
    {load} mov edi, edx                          # 0045c415
    shr ecx, 0x2                                 # 0045c417
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045c41a
    {load} mov ecx, eax                          # 0045c41c
    and ecx, 0x3                                 # 0045c41e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045c421
    mov ecx, dword ptr [ebp - local_20]          # 0045c423
    cmp dword ptr [ecx + field_20], 0x0          # 0045c426
    jne.d8 L_0045c44c                            # 0045c42a
    # block 0x0045c42c: entered by fall-through of jne at 0x0045c42a, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0045c44c
    push 0x54ab8c                                # 0045c42c
    push 0x6                                     # 0045c431
    mov edx, dword ptr [ebp - local_4]           # 0045c433
    push edx                                     # 0045c436
    push 0x54aba0                                # 0045c437
    mov ecx, 0x5cf659                            # 0045c43c
    call FUN_004c2790                            # 0045c441
    mov ecx, dword ptr [ebp - local_20]          # 0045c446
    mov dword ptr [ecx + field_20], eax          # 0045c449
L_0045c44c:
    # block 0x0045c44c: entered by jne at 0x0045c42a, 13 instruction(s), ends with je to 0x0045c48f (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c44c
    movsx eax, word ptr [edx + field_1c]         # 0045c44f
    imul eax, eax, 0x4a                          # 0045c453
    mov ecx, dword ptr [ebp - local_20]          # 0045c456
    mov edx, dword ptr [ecx + field_20]          # 0045c459
    mov dword ptr [eax + 0x5d1599], edx          # 0045c45c
    mov edi, 0x54aba8                            # 0045c462
    mov esi, dword ptr [ebp - local_4]           # 0045c467
    add esi, 0x4cd                               # 0045c46a
    mov ecx, 0x9                                 # 0045c470
    {load} xor eax, eax                          # 0045c475
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045c477
    je.d8 L_0045c48f                             # 0045c479
    # block 0x0045c47b: entered by fall-through of je at 0x0045c479, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045c48f
    mov ecx, dword ptr [ebp - local_4]           # 0045c47b
    add ecx, 0x4cd                               # 0045c47e
    push ecx                                     # 0045c484
    mov ecx, 0x5c3a67                            # 0045c485
    call FUN_004fb77a                            # 0045c48a
L_0045c48f:
    # block 0x0045c48f: entered by je at 0x0045c479, 7 instruction(s), ends with je to 0x0045c4bb (forward)
    mov edi, 0x54abb4                            # 0045c48f
    mov esi, dword ptr [ebp - local_4]           # 0045c494
    add esi, 0x4fe                               # 0045c497
    mov ecx, 0x9                                 # 0045c49d
    {load} xor edx, edx                          # 0045c4a2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045c4a4
    je.d8 L_0045c4bb                             # 0045c4a6
    # block 0x0045c4a8: entered by fall-through of je at 0x0045c4a6, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045c4bb
    mov eax, dword ptr [ebp - local_4]           # 0045c4a8
    add eax, 0x4fe                               # 0045c4ab
    push eax                                     # 0045c4b0
    mov ecx, 0x5c3a67                            # 0045c4b1
    call FUN_004fb77a                            # 0045c4b6
L_0045c4bb:
    # block 0x0045c4bb: entered by je at 0x0045c4a6, 7 instruction(s), ends with je to 0x0045c4e7 (forward)
    mov edi, 0x54abc0                            # 0045c4bb
    mov esi, dword ptr [ebp - local_4]           # 0045c4c0
    add esi, 0x52f                               # 0045c4c3
    mov ecx, 0x9                                 # 0045c4c9
    {load} xor edx, edx                          # 0045c4ce
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045c4d0
    je.d8 L_0045c4e7                             # 0045c4d2
    # block 0x0045c4d4: entered by fall-through of je at 0x0045c4d2, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045c4e7
    mov eax, dword ptr [ebp - local_4]           # 0045c4d4
    add eax, 0x52f                               # 0045c4d7
    push eax                                     # 0045c4dc
    mov ecx, 0x5c3a67                            # 0045c4dd
    call FUN_004fb77a                            # 0045c4e2
L_0045c4e7:
    # block 0x0045c4e7: entered by je at 0x0045c4d2, 7 instruction(s), ends with je to 0x0045c513 (forward)
    mov edi, 0x54abcc                            # 0045c4e7
    mov esi, dword ptr [ebp - local_4]           # 0045c4ec
    add esi, 0x560                               # 0045c4ef
    mov ecx, 0x9                                 # 0045c4f5
    {load} xor edx, edx                          # 0045c4fa
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045c4fc
    je.d8 L_0045c513                             # 0045c4fe
    # block 0x0045c500: entered by fall-through of je at 0x0045c4fe, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045c513
    mov eax, dword ptr [ebp - local_4]           # 0045c500
    add eax, 0x560                               # 0045c503
    push eax                                     # 0045c508
    mov ecx, 0x5c3a67                            # 0045c509
    call FUN_004fb77a                            # 0045c50e
L_0045c513:
    # block 0x0045c513: entered by je at 0x0045c4fe, 8 instruction(s), calls FUN_0045be7f, ends with forward jump to 0x0045d27e
    push 0x1                                     # 0045c513
    push 0x1                                     # 0045c515
    mov ecx, dword ptr [ebp - local_4]           # 0045c517
    add ecx, 0x873                               # 0045c51a
    push ecx                                     # 0045c520
    mov ecx, dword ptr [ebp - local_20]          # 0045c521
    call FUN_0045be7f                            # 0045c524
    jmp.d32 L_0045d27e                           # 0045c529
L_0045c52e:
    # block 0x0045c52e: entered by je at 0x0045c1ca, 5 instruction(s), ends with ja to 0x0045cfb1 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c52e
    mov eax, dword ptr [edx + field_24]          # 0045c531
    mov dword ptr [ebp - local_28], eax          # 0045c534
    cmp dword ptr [ebp - local_28], 0xb          # 0045c537
    ja.d32 L_0045cfb1                            # 0045c53b
    # block 0x0045c541: entered by fall-through of ja at 0x0045c53b, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x45d286]
    mov ecx, dword ptr [ebp - local_28]          # 0045c541
    jmp dword ptr [4*ecx + SWTAB_0045d286_VA]    # 0045c544
L_0045c54b:
    # block 0x0045c54b: entered by switch case, 3 instruction(s), ends with je to 0x0045c6db (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c54b
    cmp dword ptr [edx + field_28], 0x0          # 0045c54e
    je.d32 L_0045c6db                            # 0045c552
    # block 0x0045c558: entered by fall-through of je at 0x0045c552, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0045c6d6 (forward)
    call dword ptr [0x52a23c]                    # 0045c558
    mov ecx, dword ptr [ebp - local_20]          # 0045c55e
    cmp eax, dword ptr [ecx + field_2e]          # 0045c561
    jbe.d32 L_0045c6d6                           # 0045c564
    # block 0x0045c56a: entered by fall-through of jbe at 0x0045c564, 6 instruction(s), ends with jne to 0x0045c5d0 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c56a
    mov dword ptr [edx + field_32], 0x0          # 0045c56d
    mov eax, dword ptr [ebp - local_20]          # 0045c574
    movsx ecx, word ptr [eax + field_2c]         # 0045c577
    test ecx, ecx                                # 0045c57b
    jne.d8 L_0045c5d0                            # 0045c57d
    # block 0x0045c57f: entered by fall-through of jne at 0x0045c57d, 7 instruction(s), ends with jne to 0x0045c5b7 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c57f
    mov dword ptr [edx + field_24], 0x2          # 0045c582
    mov eax, dword ptr [ebp - local_4]           # 0045c589
    {load} xor ecx, ecx                          # 0045c58c
    mov cl, byte ptr [eax + field_27]            # 0045c58e
    test ecx, ecx                                # 0045c591
    jne.d8 L_0045c5b7                            # 0045c593
    # block 0x0045c595: entered by fall-through of jne at 0x0045c593, 3 instruction(s), ends with jl to 0x0045c5b7 (forward)
    movsx edx, word ptr [0x6247ee]               # 0045c595
    cmp edx, 0x2                                 # 0045c59c
    jl.d8 L_0045c5b7                             # 0045c59f
    # block 0x0045c5a1: entered by fall-through of jl at 0x0045c59f, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045c5cb
    call dword ptr [0x52a23c]                    # 0045c5a1
    add eax, 0x3e8                               # 0045c5a7
    mov ecx, dword ptr [ebp - local_20]          # 0045c5ac
    mov dword ptr [ecx + field_16e], eax         # 0045c5af
    jmp.d8 L_0045c5cb                            # 0045c5b5
L_0045c5b7:
    # block 0x0045c5b7: entered by jne at 0x0045c593; jl at 0x0045c59f, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045c5cb
    call dword ptr [0x52a23c]                    # 0045c5b7
    add eax, 0x320                               # 0045c5bd
    mov edx, dword ptr [ebp - local_20]          # 0045c5c2
    mov dword ptr [edx + field_16e], eax         # 0045c5c5
L_0045c5cb:
    # block 0x0045c5cb: entered by jmp at 0x0045c5b5, 1 instruction(s), ends with forward jump to 0x0045c6d6
    jmp.d32 L_0045c6d6                           # 0045c5cb
L_0045c5d0:
    # block 0x0045c5d0: entered by jne at 0x0045c57d, 4 instruction(s), ends with jne to 0x0045c671 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c5d0
    movsx ecx, word ptr [eax + field_2c]         # 0045c5d3
    cmp ecx, 0x1                                 # 0045c5d7
    jne.d32 L_0045c671                           # 0045c5da
    # block 0x0045c5e0: entered by fall-through of jne at 0x0045c5da, 6 instruction(s), ends with jne to 0x0045c627 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c5e0
    mov dword ptr [edx + field_24], 0x1          # 0045c5e3
    mov eax, dword ptr [ebp - local_20]          # 0045c5ea
    movsx ecx, word ptr [eax + field_ba]         # 0045c5ed
    cmp ecx, 0x1                                 # 0045c5f4
    jne.d8 L_0045c627                            # 0045c5f7
    # block 0x0045c5f9: entered by fall-through of jne at 0x0045c5f7, 11 instruction(s), calls FUN_0045be7f, falls into the block at 0x0045c627
    mov edx, dword ptr [ebp - local_20]          # 0045c5f9
    mov word ptr [edx + field_ba], 0x2           # 0045c5fc
    push 0x0                                     # 0045c605
    push 0x1                                     # 0045c607
    mov eax, dword ptr [ebp - local_4]           # 0045c609
    add eax, 0x5b8                               # 0045c60c
    push eax                                     # 0045c611
    mov ecx, dword ptr [ebp - local_20]          # 0045c612
    call FUN_0045be7f                            # 0045c615
    mov ecx, dword ptr [ebp - local_20]          # 0045c61a
    mov dword ptr [ecx + field_1b5], 0x1         # 0045c61d
L_0045c627:
    # block 0x0045c627: entered by jne at 0x0045c5f7, 4 instruction(s), ends with jne to 0x0045c665 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c627
    movsx eax, word ptr [edx + field_ba]         # 0045c62a
    cmp eax, 0x3                                 # 0045c631
    jne.d8 L_0045c665                            # 0045c634
    # block 0x0045c636: entered by fall-through of jne at 0x0045c634, 11 instruction(s), calls FUN_0045be7f, falls into the block at 0x0045c665
    mov ecx, dword ptr [ebp - local_20]          # 0045c636
    mov word ptr [ecx + field_ba], 0x0           # 0045c639
    push 0x1                                     # 0045c642
    push 0x1                                     # 0045c644
    mov edx, dword ptr [ebp - local_4]           # 0045c646
    add edx, 0x894                               # 0045c649
    push edx                                     # 0045c64f
    mov ecx, dword ptr [ebp - local_20]          # 0045c650
    call FUN_0045be7f                            # 0045c653
    mov eax, dword ptr [ebp - local_20]          # 0045c658
    mov dword ptr [eax + field_1b5], 0x1         # 0045c65b
L_0045c665:
    # block 0x0045c665: entered by jne at 0x0045c634, 3 instruction(s), ends with forward jump to 0x0045c6d6
    mov ecx, dword ptr [ebp - local_20]          # 0045c665
    mov dword ptr [ecx + field_32], 0x0          # 0045c668
    jmp.d8 L_0045c6d6                            # 0045c66f
L_0045c671:
    # block 0x0045c671: entered by jne at 0x0045c5da, 4 instruction(s), ends with jne to 0x0045c6d6 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c671
    movsx eax, word ptr [edx + field_2c]         # 0045c674
    cmp eax, 0x2                                 # 0045c678
    jne.d8 L_0045c6d6                            # 0045c67b
    # block 0x0045c67d: entered by fall-through of jne at 0x0045c67b, 26 instruction(s), falls into the block at 0x0045c6d6
    mov ecx, dword ptr [ebp - local_20]          # 0045c67d
    add ecx, 0xbc                                # 0045c680
    mov edx, dword ptr [ebp - local_20]          # 0045c686
    add edx, 0x13c                               # 0045c689
    mov eax, dword ptr [ecx]                     # 0045c68f
    mov dword ptr [edx], eax                     # 0045c691
    mov eax, dword ptr [ecx + field_4]           # 0045c693
    mov dword ptr [edx + field_4], eax           # 0045c696
    mov eax, dword ptr [ecx + field_8]           # 0045c699
    mov dword ptr [edx + field_8], eax           # 0045c69c
    mov ecx, dword ptr [ecx + field_c]           # 0045c69f
    mov dword ptr [edx + field_c], ecx           # 0045c6a2
    mov edx, dword ptr [ebp - local_20]          # 0045c6a5
    add edx, 0xcc                                # 0045c6a8
    mov eax, dword ptr [ebp - local_20]          # 0045c6ae
    add eax, 0x14c                               # 0045c6b1
    mov ecx, dword ptr [edx]                     # 0045c6b6
    mov dword ptr [eax], ecx                     # 0045c6b8
    mov ecx, dword ptr [edx + field_4]           # 0045c6ba
    mov dword ptr [eax + field_4], ecx           # 0045c6bd
    mov ecx, dword ptr [edx + field_8]           # 0045c6c0
    mov dword ptr [eax + field_8], ecx           # 0045c6c3
    mov edx, dword ptr [edx + field_c]           # 0045c6c6
    mov dword ptr [eax + field_c], edx           # 0045c6c9
    mov eax, dword ptr [ebp - local_20]          # 0045c6cc
    mov dword ptr [eax + field_24], 0x9          # 0045c6cf
L_0045c6d6:
    # block 0x0045c6d6: entered by jbe at 0x0045c564; jmp at 0x0045c5cb; jmp at 0x0045c66f; jne at 0x0045c67b, 1 instruction(s), ends with forward jump to 0x0045c827
    jmp.d32 L_0045c827                           # 0045c6d6
L_0045c6db:
    # block 0x0045c6db: entered by je at 0x0045c552, 5 instruction(s), ends with jne to 0x0045c827 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045c6db
    {load} xor edx, edx                          # 0045c6de
    mov dl, byte ptr [ecx + field_27]            # 0045c6e0
    test edx, edx                                # 0045c6e3
    jne.d32 L_0045c827                           # 0045c6e5
    # block 0x0045c6eb: entered by fall-through of jne at 0x0045c6e5, 4 instruction(s), ends with jl to 0x0045c827 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c6eb
    movsx ecx, word ptr [eax + field_ba]         # 0045c6ee
    cmp ecx, 0x2                                 # 0045c6f5
    jl.d32 L_0045c827                            # 0045c6f8
    # block 0x0045c6fe: entered by fall-through of jl at 0x0045c6f8, 5 instruction(s), ends with jne to 0x0045c76f (forward)
    mov dword ptr [ebp - local_8], 0x0           # 0045c6fe
    mov edx, dword ptr [ebp - local_20]          # 0045c705
    movsx eax, word ptr [edx + field_ba]         # 0045c708
    cmp eax, 0x3                                 # 0045c70f
    jne.d8 L_0045c76f                            # 0045c712
    # block 0x0045c714: entered by fall-through of jne at 0x0045c712, 5 instruction(s), ends with je to 0x0045c76f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045c714
    {load} xor edx, edx                          # 0045c717
    mov dl, byte ptr [ecx + field_28]            # 0045c719
    test edx, edx                                # 0045c71c
    je.d8 L_0045c76f                             # 0045c71e
    # block 0x0045c720: entered by fall-through of je at 0x0045c71e, 9 instruction(s), ends with jle to 0x0045c74c (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c720
    movsx ecx, word ptr [eax + field_17a]        # 0045c723
    mov edx, dword ptr [ebp - local_20]          # 0045c72a
    movsx eax, word ptr [edx + field_178]        # 0045c72d
    {load} sub ecx, eax                          # 0045c734
    mov word ptr [ebp - local_c], cx             # 0045c736
    movsx ecx, word ptr [ebp - local_c]          # 0045c73a
    cmp ecx, 0x5                                 # 0045c73e
    jle.d8 L_0045c74c                            # 0045c741
    # block 0x0045c743: entered by fall-through of jle at 0x0045c741, 2 instruction(s), ends with forward jump to 0x0045c76d
    mov dword ptr [ebp - local_8], 0x1           # 0045c743
    jmp.d8 L_0045c76d                            # 0045c74a
L_0045c74c:
    # block 0x0045c74c: entered by jle at 0x0045c741, 3 instruction(s), ends with jge to 0x0045c76d (forward)
    movsx edx, word ptr [ebp - local_c]          # 0045c74c
    test edx, edx                                # 0045c750
    jge.d8 L_0045c76d                            # 0045c752
    # block 0x0045c754: entered by fall-through of jge at 0x0045c752, 6 instruction(s), ends with jle to 0x0045c76d (forward)
    movsx eax, word ptr [ebp - local_c]          # 0045c754
    mov ecx, dword ptr [ebp - local_4]           # 0045c758
    movsx edx, word ptr [ecx + field_21]         # 0045c75b
    {load} add eax, edx                          # 0045c75f
    cmp eax, 0x5                                 # 0045c761
    jle.d8 L_0045c76d                            # 0045c764
    # block 0x0045c766: entered by fall-through of jle at 0x0045c764, 1 instruction(s), falls into the block at 0x0045c76d
    mov dword ptr [ebp - local_8], 0x1           # 0045c766
L_0045c76d:
    # block 0x0045c76d: entered by jmp at 0x0045c74a; jge at 0x0045c752; jle at 0x0045c764, 1 instruction(s), ends with forward jump to 0x0045c792
    jmp.d8 L_0045c792                            # 0045c76d
L_0045c76f:
    # block 0x0045c76f: entered by jne at 0x0045c712; je at 0x0045c71e, 4 instruction(s), ends with jne to 0x0045c792 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c76f
    movsx ecx, word ptr [eax + field_ba]         # 0045c772
    cmp ecx, 0x3                                 # 0045c779
    jne.d8 L_0045c792                            # 0045c77c
    # block 0x0045c77e: entered by fall-through of jne at 0x0045c77c, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x0045c78f (forward)
    call FUN_0050cd50                            # 0045c77e
    and eax, 0x80000001                          # 0045c783
    jns.d8 L_0045c78f                            # 0045c788
    # block 0x0045c78a: entered by fall-through of jns at 0x0045c788, 3 instruction(s), falls into the block at 0x0045c78f
    dec eax                                      # 0045c78a
    or eax, -0x2                                 # 0045c78b
    inc eax                                      # 0045c78e
L_0045c78f:
    # block 0x0045c78f: entered by jns at 0x0045c788, 1 instruction(s), falls into the block at 0x0045c792
    mov dword ptr [ebp - local_8], eax           # 0045c78f
L_0045c792:
    # block 0x0045c792: entered by jmp at 0x0045c76d; jne at 0x0045c77c, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x0045c81e (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c792
    mov dword ptr [edx + field_28], 0x1          # 0045c795
    call dword ptr [0x52a23c]                    # 0045c79c
    add eax, 0x12c                               # 0045c7a2
    mov ecx, dword ptr [ebp - local_20]          # 0045c7a7
    mov dword ptr [ecx + field_2e], eax          # 0045c7aa
    mov edx, dword ptr [ebp - local_20]          # 0045c7ad
    mov dword ptr [edx + field_32], 0x1          # 0045c7b0
    cmp dword ptr [ebp - local_8], 0x0           # 0045c7b7
    jne.d8 L_0045c81e                            # 0045c7bb
    # block 0x0045c7bd: entered by fall-through of jne at 0x0045c7bb, 4 instruction(s), ends with je to 0x0045c81c (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c7bd
    mov word ptr [eax + field_2c], 0x0           # 0045c7c0
    cmp dword ptr [0x5bb1ca], 0x0                # 0045c7c6
    je.d8 L_0045c81c                             # 0045c7cd
    # block 0x0045c7cf: entered by fall-through of je at 0x0045c7cd, 7 instruction(s), ends with je to 0x0045c81c (forward)
    mov edi, 0x54abd8                            # 0045c7cf
    mov esi, dword ptr [ebp - local_4]           # 0045c7d4
    add esi, 0x4fe                               # 0045c7d7
    mov ecx, 0x9                                 # 0045c7dd
    {load} xor edx, edx                          # 0045c7e2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045c7e4
    je.d8 L_0045c81c                             # 0045c7e6
    # block 0x0045c7e8: entered by fall-through of je at 0x0045c7e6, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0045c81c (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045c7e8
    movsx ecx, word ptr [eax + field_51f]        # 0045c7eb
    mov dword ptr [ebp - local_10], ecx          # 0045c7f2
    mov edx, dword ptr [ebp - local_10]          # 0045c7f5
    push edx                                     # 0045c7f8
    mov ecx, 0x5cf1eb                            # 0045c7f9
    call FUN_004f6334                            # 0045c7fe
    test eax, eax                                # 0045c803
    jne.d8 L_0045c81c                            # 0045c805
    # block 0x0045c807: entered by fall-through of jne at 0x0045c805, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0045c81c
    mov eax, dword ptr [ebp - local_4]           # 0045c807
    mov cx, word ptr [eax + field_51f]           # 0045c80a
    push ecx                                     # 0045c811
    mov ecx, 0x5c3a67                            # 0045c812
    call FUN_004fb2e3                            # 0045c817
L_0045c81c:
    # block 0x0045c81c: entered by je at 0x0045c7cd; je at 0x0045c7e6; jne at 0x0045c805, 1 instruction(s), ends with forward jump to 0x0045c827
    jmp.d8 L_0045c827                            # 0045c81c
L_0045c81e:
    # block 0x0045c81e: entered by jne at 0x0045c7bb, 2 instruction(s), falls into the block at 0x0045c827
    mov edx, dword ptr [ebp - local_20]          # 0045c81e
    mov word ptr [edx + field_2c], 0x1           # 0045c821
L_0045c827:
    # block 0x0045c827: entered by jmp at 0x0045c6d6; jne at 0x0045c6e5; jl at 0x0045c6f8; jmp at 0x0045c81c, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045c827
L_0045c82c:
    # block 0x0045c82c: entered by switch case, 6 instruction(s), ends with jne to 0x0045c86c (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c82c
    mov dword ptr [eax + field_24], 0x0          # 0045c82f
    mov ecx, dword ptr [ebp - local_20]          # 0045c836
    movsx edx, word ptr [ecx + field_ba]         # 0045c839
    test edx, edx                                # 0045c840
    jne.d8 L_0045c86c                            # 0045c842
    # block 0x0045c844: entered by fall-through of jne at 0x0045c842, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045c86a (forward)
    push 0x0                                     # 0045c844
    push 0x4                                     # 0045c846
    mov eax, dword ptr [ebp - local_4]           # 0045c848
    add eax, 0x5d9                               # 0045c84b
    push eax                                     # 0045c850
    mov ecx, dword ptr [ebp - local_20]          # 0045c851
    call FUN_0045be7f                            # 0045c854
    test eax, eax                                # 0045c859
    je.d8 L_0045c86a                             # 0045c85b
    # block 0x0045c85d: entered by fall-through of je at 0x0045c85b, 2 instruction(s), falls into the block at 0x0045c86a
    mov ecx, dword ptr [ebp - local_20]          # 0045c85d
    mov dword ptr [ecx + field_1b5], 0x0         # 0045c860
L_0045c86a:
    # block 0x0045c86a: entered by je at 0x0045c85b, 1 instruction(s), ends with forward jump to 0x0045c8a2
    jmp.d8 L_0045c8a2                            # 0045c86a
L_0045c86c:
    # block 0x0045c86c: entered by jne at 0x0045c842, 4 instruction(s), ends with jne to 0x0045c8a2 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c86c
    movsx eax, word ptr [edx + field_ba]         # 0045c86f
    cmp eax, 0x2                                 # 0045c876
    jne.d8 L_0045c8a2                            # 0045c879
    # block 0x0045c87b: entered by fall-through of jne at 0x0045c879, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045c8a2 (forward)
    push 0x1                                     # 0045c87b
    push 0x4                                     # 0045c87d
    mov ecx, dword ptr [ebp - local_4]           # 0045c87f
    add ecx, 0x8b5                               # 0045c882
    push ecx                                     # 0045c888
    mov ecx, dword ptr [ebp - local_20]          # 0045c889
    call FUN_0045be7f                            # 0045c88c
    test eax, eax                                # 0045c891
    je.d8 L_0045c8a2                             # 0045c893
    # block 0x0045c895: entered by fall-through of je at 0x0045c893, 2 instruction(s), falls into the block at 0x0045c8a2
    mov edx, dword ptr [ebp - local_20]          # 0045c895
    mov dword ptr [edx + field_1b5], 0x0         # 0045c898
L_0045c8a2:
    # block 0x0045c8a2: entered by jmp at 0x0045c86a; jne at 0x0045c879; je at 0x0045c893, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045c8a2
L_0045c8a7:
    # block 0x0045c8a7: entered by switch case, 6 instruction(s), ends with je to 0x0045c8d0 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c8a7
    mov word ptr [eax + field_176], 0x0          # 0045c8aa
    mov ecx, dword ptr [ebp - local_20]          # 0045c8b3
    movsx edx, word ptr [ecx + field_ba]         # 0045c8b6
    test edx, edx                                # 0045c8bd
    je.d8 L_0045c8d0                             # 0045c8bf
    # block 0x0045c8c1: entered by fall-through of je at 0x0045c8bf, 4 instruction(s), ends with jne to 0x0045c8e6 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c8c1
    movsx ecx, word ptr [eax + field_ba]         # 0045c8c4
    cmp ecx, 0x1                                 # 0045c8cb
    jne.d8 L_0045c8e6                            # 0045c8ce
L_0045c8d0:
    # block 0x0045c8d0: entered by je at 0x0045c8bf; fall-through of jne at 0x0045c8ce, 6 instruction(s), calls FUN_0045bbd8, ends with forward jump to 0x0045c8fa
    push 0x0                                     # 0045c8d0
    mov ecx, dword ptr [ebp - local_20]          # 0045c8d2
    call FUN_0045bbd8                            # 0045c8d5
    mov edx, dword ptr [ebp - local_20]          # 0045c8da
    mov word ptr [edx + field_174], ax           # 0045c8dd
    jmp.d8 L_0045c8fa                            # 0045c8e4
L_0045c8e6:
    # block 0x0045c8e6: entered by jne at 0x0045c8ce, 5 instruction(s), calls FUN_0045bbd8, falls into the block at 0x0045c8fa
    push 0x1                                     # 0045c8e6
    mov ecx, dword ptr [ebp - local_20]          # 0045c8e8
    call FUN_0045bbd8                            # 0045c8eb
    mov ecx, dword ptr [ebp - local_20]          # 0045c8f0
    mov word ptr [ecx + field_174], ax           # 0045c8f3
L_0045c8fa:
    # block 0x0045c8fa: entered by jmp at 0x0045c8e4, 4 instruction(s), ends with forward jump to 0x0045cfb1
    mov dword ptr [0x62475c], 0x0                # 0045c8fa
    mov edx, dword ptr [ebp - local_20]          # 0045c904
    mov dword ptr [edx + field_24], 0x3          # 0045c907
    jmp.d32 L_0045cfb1                           # 0045c90e
L_0045c913:
    # block 0x0045c913: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0045c941 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c913
    movsx ecx, word ptr [eax + field_1a5]        # 0045c916
    mov dword ptr [ebp - local_14], ecx          # 0045c91d
    mov edx, dword ptr [ebp - local_14]          # 0045c920
    push edx                                     # 0045c923
    mov ecx, 0x5cf1eb                            # 0045c924
    call FUN_004f6334                            # 0045c929
    test eax, eax                                # 0045c92e
    jne.d8 L_0045c941                            # 0045c930
    # block 0x0045c932: entered by fall-through of jne at 0x0045c930, 4 instruction(s), falls into the block at 0x0045c941
    mov eax, dword ptr [ebp - local_20]          # 0045c932
    mov ecx, dword ptr [ebp - local_20]          # 0045c935
    mov edx, dword ptr [ecx + field_1b5]         # 0045c938
    mov dword ptr [eax + field_24], edx          # 0045c93e
L_0045c941:
    # block 0x0045c941: entered by jne at 0x0045c930, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045c941
L_0045c946:
    # block 0x0045c946: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045cd45 (forward)
    call dword ptr [0x52a23c]                    # 0045c946
    mov ecx, dword ptr [ebp - local_20]          # 0045c94c
    cmp eax, dword ptr [ecx + field_16e]         # 0045c94f
    jb.d32 L_0045cd45                            # 0045c955
    # block 0x0045c95b: entered by fall-through of jb at 0x0045c955, 4 instruction(s), ends with je to 0x0045c978 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c95b
    movsx eax, word ptr [edx + field_ba]         # 0045c95e
    test eax, eax                                # 0045c965
    je.d8 L_0045c978                             # 0045c967
    # block 0x0045c969: entered by fall-through of je at 0x0045c967, 4 instruction(s), ends with jne to 0x0045c986 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045c969
    movsx edx, word ptr [ecx + field_ba]         # 0045c96c
    cmp edx, 0x1                                 # 0045c973
    jne.d8 L_0045c986                            # 0045c976
L_0045c978:
    # block 0x0045c978: entered by je at 0x0045c967; fall-through of jne at 0x0045c976, 3 instruction(s), ends with forward jump to 0x0045c992
    mov eax, dword ptr [ebp - local_20]          # 0045c978
    mov word ptr [eax + field_15c], 0x0          # 0045c97b
    jmp.d8 L_0045c992                            # 0045c984
L_0045c986:
    # block 0x0045c986: entered by jne at 0x0045c976, 2 instruction(s), falls into the block at 0x0045c992
    mov ecx, dword ptr [ebp - local_20]          # 0045c986
    mov word ptr [ecx + field_15c], 0x1          # 0045c989
L_0045c992:
    # block 0x0045c992: entered by jmp at 0x0045c984, 6 instruction(s), ends with jge to 0x0045cc78 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045c992
    movsx eax, word ptr [edx + field_176]        # 0045c995
    mov ecx, dword ptr [ebp - local_20]          # 0045c99c
    movsx edx, word ptr [ecx + field_174]        # 0045c99f
    {load} cmp eax, edx                          # 0045c9a6
    jge.d32 L_0045cc78                           # 0045c9a8
    # block 0x0045c9ae: entered by fall-through of jge at 0x0045c9a8, 37 instruction(s), ends with je to 0x0045ca49 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045c9ae
    movsx ecx, word ptr [eax + field_15c]        # 0045c9b1
    shl ecx, 0x4                                 # 0045c9b8
    mov edx, dword ptr [ebp - local_20]          # 0045c9bb
    lea eax, [edx + ecx + field_bc]              # 0045c9be
    mov ecx, dword ptr [ebp - local_20]          # 0045c9c5
    add ecx, 0xdc                                # 0045c9c8
    mov edx, dword ptr [eax]                     # 0045c9ce
    mov dword ptr [ecx], edx                     # 0045c9d0
    mov edx, dword ptr [eax + field_4]           # 0045c9d2
    mov dword ptr [ecx + field_4], edx           # 0045c9d5
    mov edx, dword ptr [eax + field_8]           # 0045c9d8
    mov dword ptr [ecx + field_8], edx           # 0045c9db
    mov eax, dword ptr [eax + field_c]           # 0045c9de
    mov dword ptr [ecx + field_c], eax           # 0045c9e1
    mov ecx, dword ptr [ebp - local_20]          # 0045c9e4
    movsx edx, word ptr [ecx + field_15c]        # 0045c9e7
    shl edx, 0x4                                 # 0045c9ee
    mov eax, dword ptr [ebp - local_4]           # 0045c9f1
    lea ecx, [eax + edx + field_3ed]             # 0045c9f4
    mov edx, dword ptr [ebp - local_20]          # 0045c9fb
    movsx eax, word ptr [edx + field_15c]        # 0045c9fe
    shl eax, 0x4                                 # 0045ca05
    mov edx, dword ptr [ebp - local_20]          # 0045ca08
    lea eax, [edx + eax + field_ec]              # 0045ca0b
    mov edx, dword ptr [ecx]                     # 0045ca12
    mov dword ptr [eax], edx                     # 0045ca14
    mov edx, dword ptr [ecx + field_4]           # 0045ca16
    mov dword ptr [eax + field_4], edx           # 0045ca19
    mov edx, dword ptr [ecx + field_8]           # 0045ca1c
    mov dword ptr [eax + field_8], edx           # 0045ca1f
    mov ecx, dword ptr [ecx + field_c]           # 0045ca22
    mov dword ptr [eax + field_c], ecx           # 0045ca25
    mov edx, dword ptr [ebp - local_20]          # 0045ca28
    movsx eax, word ptr [edx + field_ba]         # 0045ca2b
    test eax, eax                                # 0045ca32
    je.d8 L_0045ca49                             # 0045ca34
    # block 0x0045ca36: entered by fall-through of je at 0x0045ca34, 4 instruction(s), ends with jne to 0x0045cb07 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045ca36
    movsx edx, word ptr [ecx + field_ba]         # 0045ca39
    cmp edx, 0x1                                 # 0045ca40
    jne.d32 L_0045cb07                           # 0045ca43
L_0045ca49:
    # block 0x0045ca49: entered by je at 0x0045ca34; fall-through of jne at 0x0045ca43, 8 instruction(s), ends with jne to 0x0045ca82 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045ca49
    movsx ecx, word ptr [eax + field_15c]        # 0045ca4c
    mov edx, dword ptr [ebp - local_20]          # 0045ca53
    movsx eax, word ptr [edx + 2*ecx + field_178] # 0045ca56
    mov ecx, dword ptr [ebp - local_4]           # 0045ca5e
    movsx edx, word ptr [ecx + field_21]         # 0045ca61
    {load} cmp eax, edx                          # 0045ca65
    jne.d8 L_0045ca82                            # 0045ca67
    # block 0x0045ca69: entered by fall-through of jne at 0x0045ca67, 5 instruction(s), ends with forward jump to 0x0045cab0
    mov eax, dword ptr [ebp - local_20]          # 0045ca69
    movsx ecx, word ptr [eax + field_15c]        # 0045ca6c
    mov edx, dword ptr [ebp - local_20]          # 0045ca73
    mov word ptr [edx + 2*ecx + field_178], 0x1  # 0045ca76
    jmp.d8 L_0045cab0                            # 0045ca80
L_0045ca82:
    # block 0x0045ca82: entered by jne at 0x0045ca67, 9 instruction(s), falls into the block at 0x0045cab0
    mov eax, dword ptr [ebp - local_20]          # 0045ca82
    movsx ecx, word ptr [eax + field_15c]        # 0045ca85
    mov edx, dword ptr [ebp - local_20]          # 0045ca8c
    mov ax, word ptr [edx + 2*ecx + field_178]   # 0045ca8f
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045ca97
    mov ecx, dword ptr [ebp - local_20]          # 0045ca9b
    movsx edx, word ptr [ecx + field_15c]        # 0045ca9e
    mov ecx, dword ptr [ebp - local_20]          # 0045caa5
    mov word ptr [ecx + 2*edx + field_178], ax   # 0045caa8
L_0045cab0:
    # block 0x0045cab0: entered by jmp at 0x0045ca80, 22 instruction(s), ends with forward jump to 0x0045cbbf
    mov edx, dword ptr [ebp - local_20]          # 0045cab0
    movsx eax, word ptr [edx + field_15c]        # 0045cab3
    mov ecx, dword ptr [ebp - local_20]          # 0045caba
    movsx edx, word ptr [ecx + 2*eax + field_178] # 0045cabd
    sub edx, 0x1                                 # 0045cac5
    shl edx, 0x4                                 # 0045cac8
    mov eax, dword ptr [ebp - local_4]           # 0045cacb
    lea ecx, [eax + edx + field_ad]              # 0045cace
    mov edx, dword ptr [ebp - local_20]          # 0045cad5
    movsx eax, word ptr [edx + field_15c]        # 0045cad8
    shl eax, 0x4                                 # 0045cadf
    mov edx, dword ptr [ebp - local_20]          # 0045cae2
    lea eax, [edx + eax + field_bc]              # 0045cae5
    mov edx, dword ptr [ecx]                     # 0045caec
    mov dword ptr [eax], edx                     # 0045caee
    mov edx, dword ptr [ecx + field_4]           # 0045caf0
    mov dword ptr [eax + field_4], edx           # 0045caf3
    mov edx, dword ptr [ecx + field_8]           # 0045caf6
    mov dword ptr [eax + field_8], edx           # 0045caf9
    mov ecx, dword ptr [ecx + field_c]           # 0045cafc
    mov dword ptr [eax + field_c], ecx           # 0045caff
    jmp.d32 L_0045cbbf                           # 0045cb02
L_0045cb07:
    # block 0x0045cb07: entered by jne at 0x0045ca43, 6 instruction(s), ends with jne to 0x0045cb3f (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045cb07
    movsx eax, word ptr [edx + field_15c]        # 0045cb0a
    mov ecx, dword ptr [ebp - local_20]          # 0045cb11
    movsx edx, word ptr [ecx + 2*eax + field_178] # 0045cb14
    cmp edx, 0x1                                 # 0045cb1c
    jne.d8 L_0045cb3f                            # 0045cb1f
    # block 0x0045cb21: entered by fall-through of jne at 0x0045cb1f, 7 instruction(s), ends with forward jump to 0x0045cb6d
    mov eax, dword ptr [ebp - local_20]          # 0045cb21
    movsx ecx, word ptr [eax + field_15c]        # 0045cb24
    mov edx, dword ptr [ebp - local_20]          # 0045cb2b
    mov eax, dword ptr [ebp - local_4]           # 0045cb2e
    mov ax, word ptr [eax + field_21]            # 0045cb31
    mov word ptr [edx + 2*ecx + field_178], ax   # 0045cb35
    jmp.d8 L_0045cb6d                            # 0045cb3d
L_0045cb3f:
    # block 0x0045cb3f: entered by jne at 0x0045cb1f, 9 instruction(s), falls into the block at 0x0045cb6d
    mov ecx, dword ptr [ebp - local_20]          # 0045cb3f
    movsx edx, word ptr [ecx + field_15c]        # 0045cb42
    mov eax, dword ptr [ebp - local_20]          # 0045cb49
    mov cx, word ptr [eax + 2*edx + field_178]   # 0045cb4c
    sub cx, 0x1                                  # 0045cb54
    mov edx, dword ptr [ebp - local_20]          # 0045cb58
    movsx eax, word ptr [edx + field_15c]        # 0045cb5b
    mov edx, dword ptr [ebp - local_20]          # 0045cb62
    mov word ptr [edx + 2*eax + field_178], cx   # 0045cb65
L_0045cb6d:
    # block 0x0045cb6d: entered by jmp at 0x0045cb3d, 21 instruction(s), falls into the block at 0x0045cbbf
    mov eax, dword ptr [ebp - local_20]          # 0045cb6d
    movsx ecx, word ptr [eax + field_15c]        # 0045cb70
    mov edx, dword ptr [ebp - local_20]          # 0045cb77
    movsx eax, word ptr [edx + 2*ecx + field_178] # 0045cb7a
    sub eax, 0x1                                 # 0045cb82
    shl eax, 0x4                                 # 0045cb85
    mov ecx, dword ptr [ebp - local_4]           # 0045cb88
    lea edx, [ecx + eax + field_ad]              # 0045cb8b
    mov eax, dword ptr [ebp - local_20]          # 0045cb92
    movsx ecx, word ptr [eax + field_15c]        # 0045cb95
    shl ecx, 0x4                                 # 0045cb9c
    mov eax, dword ptr [ebp - local_20]          # 0045cb9f
    lea ecx, [eax + ecx + field_bc]              # 0045cba2
    mov eax, dword ptr [edx]                     # 0045cba9
    mov dword ptr [ecx], eax                     # 0045cbab
    mov eax, dword ptr [edx + field_4]           # 0045cbad
    mov dword ptr [ecx + field_4], eax           # 0045cbb0
    mov eax, dword ptr [edx + field_8]           # 0045cbb3
    mov dword ptr [ecx + field_8], eax           # 0045cbb6
    mov edx, dword ptr [edx + field_c]           # 0045cbb9
    mov dword ptr [ecx + field_c], edx           # 0045cbbc
L_0045cbbf:
    # block 0x0045cbbf: entered by jmp at 0x0045cb02, 12 instruction(s), ends with je to 0x0045cc24 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045cbbf
    mov cx, word ptr [eax + field_176]           # 0045cbc2
    add cx, 0x1                                  # 0045cbc9
    mov edx, dword ptr [ebp - local_20]          # 0045cbcd
    mov word ptr [edx + field_176], cx           # 0045cbd0
    mov edi, 0x54abe4                            # 0045cbd7
    mov esi, dword ptr [ebp - local_4]           # 0045cbdc
    add esi, 0x4cd                               # 0045cbdf
    mov ecx, 0x9                                 # 0045cbe5
    {load} xor eax, eax                          # 0045cbea
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045cbec
    je.d8 L_0045cc24                             # 0045cbee
    # block 0x0045cbf0: entered by fall-through of je at 0x0045cbee, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0045cc24 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045cbf0
    movsx edx, word ptr [ecx + field_4ee]        # 0045cbf3
    mov dword ptr [ebp - local_18], edx          # 0045cbfa
    mov eax, dword ptr [ebp - local_18]          # 0045cbfd
    push eax                                     # 0045cc00
    mov ecx, 0x5cf1eb                            # 0045cc01
    call FUN_004f6334                            # 0045cc06
    test eax, eax                                # 0045cc0b
    jne.d8 L_0045cc24                            # 0045cc0d
    # block 0x0045cc0f: entered by fall-through of jne at 0x0045cc0d, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0045cc24
    mov ecx, dword ptr [ebp - local_4]           # 0045cc0f
    mov dx, word ptr [ecx + field_4ee]           # 0045cc12
    push edx                                     # 0045cc19
    mov ecx, 0x5c3a67                            # 0045cc1a
    call FUN_004fb2e3                            # 0045cc1f
L_0045cc24:
    # block 0x0045cc24: entered by je at 0x0045cbee; jne at 0x0045cc0d, 5 instruction(s), ends with jne to 0x0045cc55 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045cc24
    {load} xor ecx, ecx                          # 0045cc27
    mov cl, byte ptr [eax + field_27]            # 0045cc29
    test ecx, ecx                                # 0045cc2c
    jne.d8 L_0045cc55                            # 0045cc2e
    # block 0x0045cc30: entered by fall-through of jne at 0x0045cc2e, 4 instruction(s), ends with jne to 0x0045cc55 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045cc30
    movsx eax, word ptr [edx + field_15c]        # 0045cc33
    cmp eax, 0x1                                 # 0045cc3a
    jne.d8 L_0045cc55                            # 0045cc3d
    # block 0x0045cc3f: entered by fall-through of jne at 0x0045cc3d, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045cc69
    call dword ptr [0x52a23c]                    # 0045cc3f
    add eax, 0x190                               # 0045cc45
    mov ecx, dword ptr [ebp - local_20]          # 0045cc4a
    mov dword ptr [ecx + field_180], eax         # 0045cc4d
    jmp.d8 L_0045cc69                            # 0045cc53
L_0045cc55:
    # block 0x0045cc55: entered by jne at 0x0045cc2e; jne at 0x0045cc3d, 4 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045cc69
    call dword ptr [0x52a23c]                    # 0045cc55
    add eax, 0xc8                                # 0045cc5b
    mov edx, dword ptr [ebp - local_20]          # 0045cc60
    mov dword ptr [edx + field_180], eax         # 0045cc63
L_0045cc69:
    # block 0x0045cc69: entered by jmp at 0x0045cc53, 3 instruction(s), ends with forward jump to 0x0045cd45
    mov eax, dword ptr [ebp - local_20]          # 0045cc69
    mov dword ptr [eax + field_24], 0x4          # 0045cc6c
    jmp.d32 L_0045cd45                           # 0045cc73
L_0045cc78:
    # block 0x0045cc78: entered by jge at 0x0045c9a8, 7 instruction(s), calls FUN_0045bcc1, ends with jne to 0x0045cd45 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045cc78
    mov dx, word ptr [ecx + field_15c]           # 0045cc7b
    push edx                                     # 0045cc82
    mov ecx, dword ptr [ebp - local_20]          # 0045cc83
    call FUN_0045bcc1                            # 0045cc86
    test eax, eax                                # 0045cc8b
    jne.d32 L_0045cd45                           # 0045cc8d
    # block 0x0045cc93: entered by fall-through of jne at 0x0045cc8d, 6 instruction(s), ends with jne to 0x0045ccec (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045cc93
    mov dword ptr [eax + field_24], 0x0          # 0045cc96
    mov ecx, dword ptr [ebp - local_20]          # 0045cc9d
    movsx edx, word ptr [ecx + field_ba]         # 0045cca0
    cmp edx, 0x3                                 # 0045cca7
    jne.d8 L_0045ccec                            # 0045ccaa
    # block 0x0045ccac: entered by fall-through of jne at 0x0045ccaa, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045ccd4 (forward)
    push 0x1                                     # 0045ccac
    push 0x4                                     # 0045ccae
    mov eax, dword ptr [ebp - local_4]           # 0045ccb0
    add eax, 0x939                               # 0045ccb3
    push eax                                     # 0045ccb8
    mov ecx, dword ptr [ebp - local_20]          # 0045ccb9
    call FUN_0045be7f                            # 0045ccbc
    test eax, eax                                # 0045ccc1
    je.d8 L_0045ccd4                             # 0045ccc3
    # block 0x0045ccc5: entered by fall-through of je at 0x0045ccc3, 3 instruction(s), ends with forward jump to 0x0045ccde
    mov ecx, dword ptr [ebp - local_20]          # 0045ccc5
    mov dword ptr [ecx + field_1b5], 0x1         # 0045ccc8
    jmp.d8 L_0045ccde                            # 0045ccd2
L_0045ccd4:
    # block 0x0045ccd4: entered by je at 0x0045ccc3, 2 instruction(s), falls into the block at 0x0045ccde
    mov edx, dword ptr [ebp - local_20]          # 0045ccd4
    mov dword ptr [edx + field_24], 0x1          # 0045ccd7
L_0045ccde:
    # block 0x0045ccde: entered by jmp at 0x0045ccd2, 3 instruction(s), ends with forward jump to 0x0045cd45
    mov eax, dword ptr [ebp - local_20]          # 0045ccde
    mov word ptr [eax + field_ba], 0x0           # 0045cce1
    jmp.d8 L_0045cd45                            # 0045ccea
L_0045ccec:
    # block 0x0045ccec: entered by jne at 0x0045ccaa, 4 instruction(s), ends with jne to 0x0045cd2d (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045ccec
    movsx edx, word ptr [ecx + field_ba]         # 0045ccef
    cmp edx, 0x1                                 # 0045ccf6
    jne.d8 L_0045cd2d                            # 0045ccf9
    # block 0x0045ccfb: entered by fall-through of jne at 0x0045ccf9, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045cd23 (forward)
    push 0x0                                     # 0045ccfb
    push 0x4                                     # 0045ccfd
    mov eax, dword ptr [ebp - local_4]           # 0045ccff
    add eax, 0x65d                               # 0045cd02
    push eax                                     # 0045cd07
    mov ecx, dword ptr [ebp - local_20]          # 0045cd08
    call FUN_0045be7f                            # 0045cd0b
    test eax, eax                                # 0045cd10
    je.d8 L_0045cd23                             # 0045cd12
    # block 0x0045cd14: entered by fall-through of je at 0x0045cd12, 3 instruction(s), ends with forward jump to 0x0045cd2d
    mov ecx, dword ptr [ebp - local_20]          # 0045cd14
    mov dword ptr [ecx + field_1b5], 0x1         # 0045cd17
    jmp.d8 L_0045cd2d                            # 0045cd21
L_0045cd23:
    # block 0x0045cd23: entered by je at 0x0045cd12, 2 instruction(s), falls into the block at 0x0045cd2d
    mov edx, dword ptr [ebp - local_20]          # 0045cd23
    mov dword ptr [edx + field_24], 0x1          # 0045cd26
L_0045cd2d:
    # block 0x0045cd2d: entered by jne at 0x0045ccf9; jmp at 0x0045cd21, 5 instruction(s), falls into the block at 0x0045cd45
    mov eax, dword ptr [ebp - local_20]          # 0045cd2d
    mov cx, word ptr [eax + field_ba]            # 0045cd30
    add cx, 0x1                                  # 0045cd37
    mov edx, dword ptr [ebp - local_20]          # 0045cd3b
    mov word ptr [edx + field_ba], cx            # 0045cd3e
L_0045cd45:
    # block 0x0045cd45: entered by jb at 0x0045c955; jmp at 0x0045cc73; jne at 0x0045cc8d; jmp at 0x0045ccea, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045cd45
L_0045cd4a:
    # block 0x0045cd4a: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0045cd65 (forward)
    call dword ptr [0x52a23c]                    # 0045cd4a
    mov ecx, dword ptr [ebp - local_20]          # 0045cd50
    cmp eax, dword ptr [ecx + field_180]         # 0045cd53
    jbe.d8 L_0045cd65                            # 0045cd59
    # block 0x0045cd5b: entered by fall-through of jbe at 0x0045cd59, 2 instruction(s), falls into the block at 0x0045cd65
    mov edx, dword ptr [ebp - local_20]          # 0045cd5b
    mov dword ptr [edx + field_24], 0x3          # 0045cd5e
L_0045cd65:
    # block 0x0045cd65: entered by jbe at 0x0045cd59, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045cd65
L_0045cd6a:
    # block 0x0045cd6a: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0045ce8a (forward)
    call dword ptr [0x52a23c]                    # 0045cd6a
    mov ecx, dword ptr [ebp - local_20]          # 0045cd70
    cmp eax, dword ptr [ecx + field_17c]         # 0045cd73
    jbe.d32 L_0045ce8a                           # 0045cd79
    # block 0x0045cd7f: entered by fall-through of jbe at 0x0045cd79, 4 instruction(s), ends with je to 0x0045cd9c (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045cd7f
    movsx eax, word ptr [edx + field_ba]         # 0045cd82
    test eax, eax                                # 0045cd89
    je.d8 L_0045cd9c                             # 0045cd8b
    # block 0x0045cd8d: entered by fall-through of je at 0x0045cd8b, 4 instruction(s), ends with jne to 0x0045ce07 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045cd8d
    movsx edx, word ptr [ecx + field_ba]         # 0045cd90
    cmp edx, 0x1                                 # 0045cd97
    jne.d8 L_0045ce07                            # 0045cd9a
L_0045cd9c:
    # block 0x0045cd9c: entered by je at 0x0045cd8b; fall-through of jne at 0x0045cd9a, 32 instruction(s), ends with forward jump to 0x0045ce70
    mov eax, dword ptr [ebp - local_20]          # 0045cd9c
    add eax, 0xcc                                # 0045cd9f
    mov ecx, dword ptr [ebp - local_20]          # 0045cda4
    add ecx, 0xdc                                # 0045cda7
    mov edx, dword ptr [eax]                     # 0045cdad
    mov dword ptr [ecx], edx                     # 0045cdaf
    mov edx, dword ptr [eax + field_4]           # 0045cdb1
    mov dword ptr [ecx + field_4], edx           # 0045cdb4
    mov edx, dword ptr [eax + field_8]           # 0045cdb7
    mov dword ptr [ecx + field_8], edx           # 0045cdba
    mov eax, dword ptr [eax + field_c]           # 0045cdbd
    mov dword ptr [ecx + field_c], eax           # 0045cdc0
    mov ecx, dword ptr [ebp - local_4]           # 0045cdc3
    movsx edx, word ptr [ecx + field_23]         # 0045cdc6
    mov eax, dword ptr [ebp - local_20]          # 0045cdca
    movsx ecx, word ptr [eax + field_b6]         # 0045cdcd
    {load} sub edx, ecx                          # 0045cdd4
    sub edx, 0x1                                 # 0045cdd6
    shl edx, 0x4                                 # 0045cdd9
    mov eax, dword ptr [ebp - local_4]           # 0045cddc
    lea ecx, [eax + edx + field_25d]             # 0045cddf
    mov edx, dword ptr [ebp - local_20]          # 0045cde6
    add edx, 0x10c                               # 0045cde9
    mov eax, dword ptr [ecx]                     # 0045cdef
    mov dword ptr [edx], eax                     # 0045cdf1
    mov eax, dword ptr [ecx + field_4]           # 0045cdf3
    mov dword ptr [edx + field_4], eax           # 0045cdf6
    mov eax, dword ptr [ecx + field_8]           # 0045cdf9
    mov dword ptr [edx + field_8], eax           # 0045cdfc
    mov ecx, dword ptr [ecx + field_c]           # 0045cdff
    mov dword ptr [edx + field_c], ecx           # 0045ce02
    jmp.d8 L_0045ce70                            # 0045ce05
L_0045ce07:
    # block 0x0045ce07: entered by jne at 0x0045cd9a, 31 instruction(s), falls into the block at 0x0045ce70
    mov edx, dword ptr [ebp - local_20]          # 0045ce07
    add edx, 0xbc                                # 0045ce0a
    mov eax, dword ptr [ebp - local_20]          # 0045ce10
    add eax, 0xdc                                # 0045ce13
    mov ecx, dword ptr [edx]                     # 0045ce18
    mov dword ptr [eax], ecx                     # 0045ce1a
    mov ecx, dword ptr [edx + field_4]           # 0045ce1c
    mov dword ptr [eax + field_4], ecx           # 0045ce1f
    mov ecx, dword ptr [edx + field_8]           # 0045ce22
    mov dword ptr [eax + field_8], ecx           # 0045ce25
    mov edx, dword ptr [edx + field_c]           # 0045ce28
    mov dword ptr [eax + field_c], edx           # 0045ce2b
    mov eax, dword ptr [ebp - local_4]           # 0045ce2e
    movsx ecx, word ptr [eax + field_23]         # 0045ce31
    mov edx, dword ptr [ebp - local_20]          # 0045ce35
    movsx eax, word ptr [edx + field_b8]         # 0045ce38
    {load} sub ecx, eax                          # 0045ce3f
    sub ecx, 0x1                                 # 0045ce41
    shl ecx, 0x4                                 # 0045ce44
    mov edx, dword ptr [ebp - local_4]           # 0045ce47
    lea eax, [edx + ecx + field_19d]             # 0045ce4a
    mov ecx, dword ptr [ebp - local_20]          # 0045ce51
    add ecx, 0x10c                               # 0045ce54
    mov edx, dword ptr [eax]                     # 0045ce5a
    mov dword ptr [ecx], edx                     # 0045ce5c
    mov edx, dword ptr [eax + field_4]           # 0045ce5e
    mov dword ptr [ecx + field_4], edx           # 0045ce61
    mov edx, dword ptr [eax + field_8]           # 0045ce64
    mov dword ptr [ecx + field_8], edx           # 0045ce67
    mov eax, dword ptr [eax + field_c]           # 0045ce6a
    mov dword ptr [ecx + field_c], eax           # 0045ce6d
L_0045ce70:
    # block 0x0045ce70: entered by jmp at 0x0045ce05, 6 instruction(s), calls FUN_0045bda7, FUN_0045ba0b, falls into the block at 0x0045ce8a
    mov ecx, dword ptr [ebp - local_20]          # 0045ce70
    mov dword ptr [ecx + field_24], 0x0          # 0045ce73
    mov ecx, dword ptr [ebp - local_20]          # 0045ce7a
    call FUN_0045bda7                            # 0045ce7d
    mov ecx, dword ptr [ebp - local_20]          # 0045ce82
    call FUN_0045ba0b                            # 0045ce85
L_0045ce8a:
    # block 0x0045ce8a: entered by jbe at 0x0045cd79, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045ce8a
L_0045ce8f:
    # block 0x0045ce8f: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0045ced8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045ce8f
    movsx eax, word ptr [edx + field_581]        # 0045ce92
    mov dword ptr [ebp - local_1c], eax          # 0045ce99
    mov ecx, dword ptr [ebp - local_1c]          # 0045ce9c
    push ecx                                     # 0045ce9f
    mov ecx, 0x5cf1eb                            # 0045cea0
    call FUN_004f6334                            # 0045cea5
    test eax, eax                                # 0045ceaa
    jne.d8 L_0045ced8                            # 0045ceac
    # block 0x0045ceae: entered by fall-through of jne at 0x0045ceac, 8 instruction(s), calls FUN_0045ba0b, falls into the block at 0x0045ced8
    mov edx, dword ptr [ebp - local_20]          # 0045ceae
    mov word ptr [edx + field_b6], 0x0           # 0045ceb1
    mov eax, dword ptr [ebp - local_20]          # 0045ceba
    mov word ptr [eax + field_b8], 0x0           # 0045cebd
    mov ecx, dword ptr [ebp - local_20]          # 0045cec6
    call FUN_0045ba0b                            # 0045cec9
    mov ecx, dword ptr [ebp - local_20]          # 0045cece
    mov dword ptr [ecx + field_24], 0x0          # 0045ced1
L_0045ced8:
    # block 0x0045ced8: entered by jne at 0x0045ceac, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d32 L_0045cfb1                           # 0045ced8
L_0045cedd:
    # block 0x0045cedd: entered by switch case, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045cf1a (forward)
    push 0x0                                     # 0045cedd
    push 0x4                                     # 0045cedf
    mov edx, dword ptr [ebp - local_4]           # 0045cee1
    add edx, 0x765                               # 0045cee4
    push edx                                     # 0045ceea
    mov ecx, dword ptr [ebp - local_20]          # 0045ceeb
    call FUN_0045be7f                            # 0045ceee
    test eax, eax                                # 0045cef3
    je.d8 L_0045cf1a                             # 0045cef5
    # block 0x0045cef7: entered by fall-through of je at 0x0045cef5, 7 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045cf31
    mov eax, dword ptr [ebp - local_20]          # 0045cef7
    mov dword ptr [eax + field_1b5], 0xb         # 0045cefa
    call dword ptr [0x52a23c]                    # 0045cf04
    add eax, 0x1f4                               # 0045cf0a
    mov ecx, dword ptr [ebp - local_20]          # 0045cf0f
    mov dword ptr [ecx + field_16e], eax         # 0045cf12
    jmp.d8 L_0045cf31                            # 0045cf18
L_0045cf1a:
    # block 0x0045cf1a: entered by je at 0x0045cef5, 4 instruction(s), falls into the block at 0x0045cf31
    mov edx, dword ptr [ebp - local_20]          # 0045cf1a
    movsx eax, word ptr [edx + field_1e]         # 0045cf1d
    imul eax, eax, 0x8d                          # 0045cf21
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045cf27
L_0045cf31:
    # block 0x0045cf31: entered by jmp at 0x0045cf18, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d8 L_0045cfb1                            # 0045cf31
L_0045cf33:
    # block 0x0045cf33: entered by switch case, 9 instruction(s), calls FUN_0045be7f, ends with je to 0x0045cf70 (forward)
    push 0x1                                     # 0045cf33
    push 0x4                                     # 0045cf35
    mov ecx, dword ptr [ebp - local_4]           # 0045cf37
    add ecx, 0xa41                               # 0045cf3a
    push ecx                                     # 0045cf40
    mov ecx, dword ptr [ebp - local_20]          # 0045cf41
    call FUN_0045be7f                            # 0045cf44
    test eax, eax                                # 0045cf49
    je.d8 L_0045cf70                             # 0045cf4b
    # block 0x0045cf4d: entered by fall-through of je at 0x0045cf4b, 7 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045cf87
    mov edx, dword ptr [ebp - local_20]          # 0045cf4d
    mov dword ptr [edx + field_1b5], 0xb         # 0045cf50
    call dword ptr [0x52a23c]                    # 0045cf5a
    add eax, 0x1f4                               # 0045cf60
    mov ecx, dword ptr [ebp - local_20]          # 0045cf65
    mov dword ptr [ecx + field_16e], eax         # 0045cf68
    jmp.d8 L_0045cf87                            # 0045cf6e
L_0045cf70:
    # block 0x0045cf70: entered by je at 0x0045cf4b, 4 instruction(s), falls into the block at 0x0045cf87
    mov edx, dword ptr [ebp - local_20]          # 0045cf70
    movsx eax, word ptr [edx + field_1e]         # 0045cf73
    imul eax, eax, 0x8d                          # 0045cf77
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045cf7d
L_0045cf87:
    # block 0x0045cf87: entered by jmp at 0x0045cf6e, 1 instruction(s), ends with forward jump to 0x0045cfb1
    jmp.d8 L_0045cfb1                            # 0045cf87
L_0045cf89:
    # block 0x0045cf89: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0045cfb1 (forward)
    call dword ptr [0x52a23c]                    # 0045cf89
    mov ecx, dword ptr [ebp - local_20]          # 0045cf8f
    cmp eax, dword ptr [ecx + field_16e]         # 0045cf92
    jb.d8 L_0045cfb1                             # 0045cf98
    # block 0x0045cf9a: entered by fall-through of jb at 0x0045cf98, 4 instruction(s), falls into the block at 0x0045cfb1
    mov edx, dword ptr [ebp - local_20]          # 0045cf9a
    movsx eax, word ptr [edx + field_1e]         # 0045cf9d
    imul eax, eax, 0x8d                          # 0045cfa1
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045cfa7
L_0045cfb1:
    # block 0x0045cfb1: entered by ja at 0x0045c53b; jmp at 0x0045c827; jmp at 0x0045c8a2; jmp at 0x0045c90e; more, 1 instruction(s), ends with forward jump to 0x0045d27e
    jmp.d32 L_0045d27e                           # 0045cfb1
L_0045cfb6:
    # block 0x0045cfb6: entered by je at 0x0045c1d4, 8 instruction(s), ends with je to 0x0045cfec (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0045cfb6
    mov edi, 0x54abf0                            # 0045cfc0
    mov esi, dword ptr [ebp - local_4]           # 0045cfc5
    add esi, 0x4fe                               # 0045cfc8
    mov ecx, 0x9                                 # 0045cfce
    {load} xor edx, edx                          # 0045cfd3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045cfd5
    je.d8 L_0045cfec                             # 0045cfd7
    # block 0x0045cfd9: entered by fall-through of je at 0x0045cfd7, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0045cfec
    mov eax, dword ptr [ebp - local_4]           # 0045cfd9
    add eax, 0x4fe                               # 0045cfdc
    push eax                                     # 0045cfe1
    mov ecx, 0x5c3a67                            # 0045cfe2
    call FUN_004fba69                            # 0045cfe7
L_0045cfec:
    # block 0x0045cfec: entered by je at 0x0045cfd7, 7 instruction(s), ends with je to 0x0045d018 (forward)
    mov edi, 0x54abfc                            # 0045cfec
    mov esi, dword ptr [ebp - local_4]           # 0045cff1
    add esi, 0x52f                               # 0045cff4
    mov ecx, 0x9                                 # 0045cffa
    {load} xor edx, edx                          # 0045cfff
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045d001
    je.d8 L_0045d018                             # 0045d003
    # block 0x0045d005: entered by fall-through of je at 0x0045d003, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0045d018
    mov eax, dword ptr [ebp - local_4]           # 0045d005
    add eax, 0x52f                               # 0045d008
    push eax                                     # 0045d00d
    mov ecx, 0x5c3a67                            # 0045d00e
    call FUN_004fba69                            # 0045d013
L_0045d018:
    # block 0x0045d018: entered by je at 0x0045d003, 7 instruction(s), ends with je to 0x0045d044 (forward)
    mov edi, 0x54ac08                            # 0045d018
    mov esi, dword ptr [ebp - local_4]           # 0045d01d
    add esi, 0x560                               # 0045d020
    mov ecx, 0x9                                 # 0045d026
    {load} xor edx, edx                          # 0045d02b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045d02d
    je.d8 L_0045d044                             # 0045d02f
    # block 0x0045d031: entered by fall-through of je at 0x0045d02f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0045d044
    mov eax, dword ptr [ebp - local_4]           # 0045d031
    add eax, 0x560                               # 0045d034
    push eax                                     # 0045d039
    mov ecx, 0x5c3a67                            # 0045d03a
    call FUN_004fba69                            # 0045d03f
L_0045d044:
    # block 0x0045d044: entered by je at 0x0045d02f, 3 instruction(s), ends with jne to 0x0045d136 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045d044
    cmp dword ptr [ecx + field_162], 0x0         # 0045d047
    jne.d32 L_0045d136                           # 0045d04e
    # block 0x0045d054: entered by fall-through of jne at 0x0045d04e, 4 instruction(s), ends with je to 0x0045d106 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045d054
    movsx eax, word ptr [edx + field_b65]        # 0045d057
    cmp eax, 0x270f                              # 0045d05e
    je.d32 L_0045d106                            # 0045d063
    # block 0x0045d069: entered by fall-through of je at 0x0045d063, 25 instruction(s), ends with jne to 0x0045d0f2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045d069
    movsx edx, word ptr [ecx + field_b65]        # 0045d06c
    mov dword ptr [0x5bb57b], edx                # 0045d073
    mov eax, dword ptr [ebp - local_4]           # 0045d079
    mov cx, word ptr [eax + field_b67]           # 0045d07c
    mov word ptr [0x5bb599], cx                  # 0045d083
    mov edx, dword ptr [ebp - local_4]           # 0045d08a
    mov ax, word ptr [edx + field_b69]           # 0045d08d
    mov word ptr [0x5bb595], ax                  # 0045d094
    mov ecx, dword ptr [ebp - local_4]           # 0045d09a
    mov dx, word ptr [ecx + field_b6b]           # 0045d09d
    mov word ptr [0x5c39ff], dx                  # 0045d0a4
    mov eax, dword ptr [ebp - local_4]           # 0045d0ab
    mov ecx, dword ptr [eax + field_b6d]         # 0045d0ae
    mov dword ptr [0x5bb59b], ecx                # 0045d0b4
    mov edx, dword ptr [ebp - local_4]           # 0045d0ba
    mov eax, dword ptr [edx + field_b71]         # 0045d0bd
    mov dword ptr [0x5bb59f], eax                # 0045d0c3
    mov ecx, dword ptr [ebp - local_4]           # 0045d0c8
    mov edx, dword ptr [ecx + field_b75]         # 0045d0cb
    mov dword ptr [0x5bb5a3], edx                # 0045d0d1
    mov eax, dword ptr [ebp - local_4]           # 0045d0d7
    movsx ecx, word ptr [eax + field_b79]        # 0045d0da
    cmp ecx, 0x1                                 # 0045d0e1
    jne.d8 L_0045d0f2                            # 0045d0e4
    # block 0x0045d0e6: entered by fall-through of jne at 0x0045d0e4, 2 instruction(s), ends with forward jump to 0x0045d0fc
    mov dword ptr [0x5bb1ca], 0x0                # 0045d0e6
    jmp.d8 L_0045d0fc                            # 0045d0f0
L_0045d0f2:
    # block 0x0045d0f2: entered by jne at 0x0045d0e4, 1 instruction(s), falls into the block at 0x0045d0fc
    mov dword ptr [0x5bb1ca], 0x1                # 0045d0f2
L_0045d0fc:
    # block 0x0045d0fc: entered by jmp at 0x0045d0f0, 1 instruction(s), falls into the block at 0x0045d106
    mov dword ptr [0x583999], 0x4                # 0045d0fc
L_0045d106:
    # block 0x0045d106: entered by je at 0x0045d063, 4 instruction(s), ends with je to 0x0045d131 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045d106
    movsx eax, word ptr [edx + field_b7b]        # 0045d109
    cmp eax, -0x1                                # 0045d110
    je.d8 L_0045d131                             # 0045d113
    # block 0x0045d115: entered by fall-through of je at 0x0045d113, 6 instruction(s), falls into the block at 0x0045d131
    mov ecx, dword ptr [ebp - local_4]           # 0045d115
    {load} xor edx, edx                          # 0045d118
    mov dl, byte ptr [ecx + field_b7d]           # 0045d11a
    mov eax, dword ptr [ebp - local_4]           # 0045d120
    movsx ecx, word ptr [eax + field_b7b]        # 0045d123
    mov dword ptr [4*ecx + 0x585801], edx        # 0045d12a
L_0045d131:
    # block 0x0045d131: entered by je at 0x0045d113, 1 instruction(s), ends with forward jump to 0x0045d266
    jmp.d32 L_0045d266                           # 0045d131
L_0045d136:
    # block 0x0045d136: entered by jne at 0x0045d04e, 3 instruction(s), ends with je to 0x0045d266 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0045d136
    cmp dword ptr [edx + field_162], 0x0         # 0045d139
    je.d32 L_0045d266                            # 0045d140
    # block 0x0045d146: entered by fall-through of je at 0x0045d140, 4 instruction(s), ends with je to 0x0045d1f8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045d146
    movsx ecx, word ptr [eax + field_b49]        # 0045d149
    cmp ecx, 0x270f                              # 0045d150
    je.d32 L_0045d1f8                            # 0045d156
    # block 0x0045d15c: entered by fall-through of je at 0x0045d156, 25 instruction(s), ends with jne to 0x0045d1e4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045d15c
    movsx eax, word ptr [edx + field_b49]        # 0045d15f
    mov dword ptr [0x5bb57b], eax                # 0045d166
    mov ecx, dword ptr [ebp - local_4]           # 0045d16b
    mov dx, word ptr [ecx + field_b4b]           # 0045d16e
    mov word ptr [0x5bb599], dx                  # 0045d175
    mov eax, dword ptr [ebp - local_4]           # 0045d17c
    mov cx, word ptr [eax + field_b4d]           # 0045d17f
    mov word ptr [0x5bb595], cx                  # 0045d186
    mov edx, dword ptr [ebp - local_4]           # 0045d18d
    mov ax, word ptr [edx + field_b4f]           # 0045d190
    mov word ptr [0x5c39ff], ax                  # 0045d197
    mov ecx, dword ptr [ebp - local_4]           # 0045d19d
    mov edx, dword ptr [ecx + field_b51]         # 0045d1a0
    mov dword ptr [0x5bb59b], edx                # 0045d1a6
    mov eax, dword ptr [ebp - local_4]           # 0045d1ac
    mov ecx, dword ptr [eax + field_b55]         # 0045d1af
    mov dword ptr [0x5bb59f], ecx                # 0045d1b5
    mov edx, dword ptr [ebp - local_4]           # 0045d1bb
    mov eax, dword ptr [edx + field_b59]         # 0045d1be
    mov dword ptr [0x5bb5a3], eax                # 0045d1c4
    mov ecx, dword ptr [ebp - local_4]           # 0045d1c9
    movsx edx, word ptr [ecx + field_b5d]        # 0045d1cc
    cmp edx, 0x1                                 # 0045d1d3
    jne.d8 L_0045d1e4                            # 0045d1d6
    # block 0x0045d1d8: entered by fall-through of jne at 0x0045d1d6, 2 instruction(s), ends with forward jump to 0x0045d1ee
    mov dword ptr [0x5bb1ca], 0x0                # 0045d1d8
    jmp.d8 L_0045d1ee                            # 0045d1e2
L_0045d1e4:
    # block 0x0045d1e4: entered by jne at 0x0045d1d6, 1 instruction(s), falls into the block at 0x0045d1ee
    mov dword ptr [0x5bb1ca], 0x1                # 0045d1e4
L_0045d1ee:
    # block 0x0045d1ee: entered by jmp at 0x0045d1e2, 1 instruction(s), falls into the block at 0x0045d1f8
    mov dword ptr [0x583999], 0x4                # 0045d1ee
L_0045d1f8:
    # block 0x0045d1f8: entered by je at 0x0045d156, 3 instruction(s), ends with je to 0x0045d22f (forward)
    mov eax, dword ptr [ebp - local_20]          # 0045d1f8
    cmp dword ptr [eax + field_16a], 0x0         # 0045d1fb
    je.d8 L_0045d22f                             # 0045d202
    # block 0x0045d204: entered by fall-through of je at 0x0045d202, 4 instruction(s), ends with je to 0x0045d22f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045d204
    movsx edx, word ptr [ecx + field_b5f]        # 0045d207
    cmp edx, -0x1                                # 0045d20e
    je.d8 L_0045d22f                             # 0045d211
    # block 0x0045d213: entered by fall-through of je at 0x0045d211, 6 instruction(s), falls into the block at 0x0045d22f
    mov eax, dword ptr [ebp - local_4]           # 0045d213
    {load} xor ecx, ecx                          # 0045d216
    mov cl, byte ptr [eax + field_b61]           # 0045d218
    mov edx, dword ptr [ebp - local_4]           # 0045d21e
    movsx eax, word ptr [edx + field_b5f]        # 0045d221
    mov dword ptr [4*eax + 0x585801], ecx        # 0045d228
L_0045d22f:
    # block 0x0045d22f: entered by je at 0x0045d202; je at 0x0045d211, 3 instruction(s), ends with jne to 0x0045d266 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0045d22f
    cmp dword ptr [ecx + field_16a], 0x0         # 0045d232
    jne.d8 L_0045d266                            # 0045d239
    # block 0x0045d23b: entered by fall-through of jne at 0x0045d239, 4 instruction(s), ends with je to 0x0045d266 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045d23b
    movsx eax, word ptr [edx + field_b62]        # 0045d23e
    cmp eax, -0x1                                # 0045d245
    je.d8 L_0045d266                             # 0045d248
    # block 0x0045d24a: entered by fall-through of je at 0x0045d248, 6 instruction(s), falls into the block at 0x0045d266
    mov ecx, dword ptr [ebp - local_4]           # 0045d24a
    {load} xor edx, edx                          # 0045d24d
    mov dl, byte ptr [ecx + field_b64]           # 0045d24f
    mov eax, dword ptr [ebp - local_4]           # 0045d255
    movsx ecx, word ptr [eax + field_b62]        # 0045d258
    mov dword ptr [4*ecx + 0x585801], edx        # 0045d25f
L_0045d266:
    # block 0x0045d266: entered by jmp at 0x0045d131; je at 0x0045d140; jne at 0x0045d239; je at 0x0045d248, 7 instruction(s), calls FUN_0042ba3a, FUN_0045b42e, falls into the block at 0x0045d27e
    mov edx, dword ptr [ebp - local_20]          # 0045d266
    mov ax, word ptr [edx + field_1e]            # 0045d269
    push eax                                     # 0045d26d
    call FUN_0042ba3a                            # 0045d26e
    add esp, 0x4                                 # 0045d273
    mov ecx, dword ptr [ebp - local_20]          # 0045d276
    call FUN_0045b42e                            # 0045d279
L_0045d27e:
    # block 0x0045d27e: entered by jmp at 0x0045c1da; jmp at 0x0045c529; jmp at 0x0045cfb1, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0045d27e
    pop esi                                      # 0045d27f
    {load} mov esp, ebp                          # 0045d280
    pop ebp                                      # 0045d282
    ret 0x4                                      # 0045d283

# --- data items (not part of the function) -------------------------
.org 0x0045d286 - 0x401000
SWTAB_0045d286:  # 12 case address(es)
    .long L_0045c54b - .text + 0x401000
    .long L_0045c82c - .text + 0x401000
    .long L_0045c8a7 - .text + 0x401000
    .long L_0045c946 - .text + 0x401000
    .long L_0045cd4a - .text + 0x401000
    .long L_0045cfb1 - .text + 0x401000
    .long L_0045cd6a - .text + 0x401000
    .long L_0045cedd - .text + 0x401000
    .long L_0045cf33 - .text + 0x401000
    .long L_0045ce8f - .text + 0x401000
    .long L_0045c913 - .text + 0x401000
    .long L_0045cf89 - .text + 0x401000
.set SWTAB_0045d286_VA, SWTAB_0045d286 - .text + 0x401000

