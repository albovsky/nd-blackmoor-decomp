# FUN_004ff310
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff310
# extent:       0x004ff310-0x004ff555 (581 code bytes)
# span:         0x004ff310-0x004ff560 (code 581, tables 0, padding 11)
# sha256:       27447f7dc1f9149cd34071934fe0eb6bba50552301a838df9819ceb8a7370b9c
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ff310
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10; [ebp + n] field_10, field_14, field_1c, field_320, field_520; [ecx + n] field_4, field_10, field_1c; [edi + n] field_4, field_8, field_c, field_64; [esi + n] field_4, field_8, field_c, field_10, field_14, field_20, field_30, field_34, field_38, field_3c, field_40, field_44 and 2 more; [esp + n] stk_c, stk_10, stk_14, stk_1c
# callees:      calls FUN_0050e936, FUN_00503ba0, FUN_00505580, FUN_005009a0, FUN_004ffc10, FUN_00503aa0, FUN_005051b0; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 219 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_64, 0x64  # offset +0x64
.equ field_320, 0x320  # offset +0x320
.equ field_520, 0x520  # offset +0x520

# --- external targets -----------------------------------------------
.set FUN_004ffc10, .text + (0x004ffc10 - 0x401000)
.set FUN_005009a0, .text + (0x005009a0 - 0x401000)
.set FUN_00503aa0, .text + (0x00503aa0 - 0x401000)
.set FUN_00503ba0, .text + (0x00503ba0 - 0x401000)
.set FUN_005051b0, .text + (0x005051b0 - 0x401000)
.set FUN_00505580, .text + (0x00505580 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004ff310 - 0x401000
.globl FUN_004ff310
FUN_004ff310:
    # block 0x004ff310: entry, 5 instruction(s), ends with je to 0x004ff552 (forward)
    push ecx                                     # 004ff310
    push edi                                     # 004ff311
    mov edi, dword ptr [esp + stk_c]             # 004ff312
    test edi, edi                                # 004ff316
    je.d32 L_004ff552                            # 004ff318
    # block 0x004ff31e: entered by fall-through of je at 0x004ff318, 7 instruction(s), ends with je to 0x004ff331 (forward)
    mov ecx, dword ptr [edi + field_4]           # 004ff31e
    push ebx                                     # 004ff321
    push ebp                                     # 004ff322
    push esi                                     # 004ff323
    test ecx, ecx                                # 004ff324
    mov dword ptr [esp + stk_10], ecx            # 004ff326
    je.d8 L_004ff331                             # 004ff32a
    # block 0x004ff32c: entered by fall-through of je at 0x004ff32a, 2 instruction(s), ends with forward jump to 0x004ff333
    mov ebp, dword ptr [ecx + field_1c]          # 004ff32c
    jmp.d8 L_004ff333                            # 004ff32f
L_004ff331:
    # block 0x004ff331: entered by je at 0x004ff32a, 1 instruction(s), falls into the block at 0x004ff333
    {load} xor ebp, ebp                          # 004ff331
L_004ff333:
    # block 0x004ff333: entered by jmp at 0x004ff32f, 3 instruction(s), ends with je to 0x004ff4be (forward)
    mov esi, dword ptr [edi + field_64]          # 004ff333
    test esi, esi                                # 004ff336
    je.d32 L_004ff4be                            # 004ff338
    # block 0x004ff33e: entered by fall-through of je at 0x004ff338, 3 instruction(s), ends with je to 0x004ff34e (forward)
    mov eax, dword ptr [esi + field_4]           # 004ff33e
    test eax, eax                                # 004ff341
    je.d8 L_004ff34e                             # 004ff343
    # block 0x004ff345: entered by fall-through of je at 0x004ff343, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff34e
    push eax                                     # 004ff345
    call FUN_0050e936                            # 004ff346
    add esp, 0x4                                 # 004ff34b
L_004ff34e:
    # block 0x004ff34e: entered by je at 0x004ff343, 3 instruction(s), ends with je to 0x004ff35e (forward)
    mov eax, dword ptr [esi + field_8]           # 004ff34e
    test eax, eax                                # 004ff351
    je.d8 L_004ff35e                             # 004ff353
    # block 0x004ff355: entered by fall-through of je at 0x004ff353, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff35e
    push eax                                     # 004ff355
    call FUN_0050e936                            # 004ff356
    add esp, 0x4                                 # 004ff35b
L_004ff35e:
    # block 0x004ff35e: entered by je at 0x004ff353, 3 instruction(s), ends with je to 0x004ff375 (forward)
    mov eax, dword ptr [esi]                     # 004ff35e
    test eax, eax                                # 004ff360
    je.d8 L_004ff375                             # 004ff362
    # block 0x004ff364: entered by fall-through of je at 0x004ff362, 6 instruction(s), calls FUN_00503ba0, FUN_0050e936, falls into the block at 0x004ff375
    push eax                                     # 004ff364
    call FUN_00503ba0                            # 004ff365
    mov eax, dword ptr [esi]                     # 004ff36a
    push eax                                     # 004ff36c
    call FUN_0050e936                            # 004ff36d
    add esp, 0x8                                 # 004ff372
L_004ff375:
    # block 0x004ff375: entered by je at 0x004ff362, 3 instruction(s), ends with je to 0x004ff39b (forward)
    mov eax, dword ptr [esi + field_c]           # 004ff375
    test eax, eax                                # 004ff378
    je.d8 L_004ff39b                             # 004ff37a
    # block 0x004ff37c: entered by fall-through of je at 0x004ff37a, 11 instruction(s), calls FUN_00505580, FUN_0050e936, falls into the block at 0x004ff39b
    mov ecx, dword ptr [eax]                     # 004ff37c
    push ecx                                     # 004ff37e
    call FUN_00505580                            # 004ff37f
    mov edx, dword ptr [esi + field_c]           # 004ff384
    mov eax, dword ptr [edx]                     # 004ff387
    push eax                                     # 004ff389
    call FUN_0050e936                            # 004ff38a
    mov ecx, dword ptr [esi + field_c]           # 004ff38f
    push ecx                                     # 004ff392
    call FUN_0050e936                            # 004ff393
    add esp, 0xc                                 # 004ff398
L_004ff39b:
    # block 0x004ff39b: entered by je at 0x004ff37a, 3 instruction(s), ends with je to 0x004ff3c1 (forward)
    mov eax, dword ptr [esi + field_10]          # 004ff39b
    test eax, eax                                # 004ff39e
    je.d8 L_004ff3c1                             # 004ff3a0
    # block 0x004ff3a2: entered by fall-through of je at 0x004ff3a0, 11 instruction(s), calls FUN_00505580, FUN_0050e936, falls into the block at 0x004ff3c1
    mov edx, dword ptr [eax]                     # 004ff3a2
    push edx                                     # 004ff3a4
    call FUN_00505580                            # 004ff3a5
    mov eax, dword ptr [esi + field_10]          # 004ff3aa
    mov ecx, dword ptr [eax]                     # 004ff3ad
    push ecx                                     # 004ff3af
    call FUN_0050e936                            # 004ff3b0
    mov edx, dword ptr [esi + field_10]          # 004ff3b5
    push edx                                     # 004ff3b8
    call FUN_0050e936                            # 004ff3b9
    add esp, 0xc                                 # 004ff3be
L_004ff3c1:
    # block 0x004ff3c1: entered by je at 0x004ff3a0, 3 instruction(s), ends with je to 0x004ff408 (forward)
    mov eax, dword ptr [esi + field_30]          # 004ff3c1
    test eax, eax                                # 004ff3c4
    je.d8 L_004ff408                             # 004ff3c6
    # block 0x004ff3c8: entered by fall-through of je at 0x004ff3c6, 4 instruction(s), ends with jle to 0x004ff3f8 (forward)
    mov eax, dword ptr [ebp + field_10]          # 004ff3c8
    {load} xor ebx, ebx                          # 004ff3cb
    test eax, eax                                # 004ff3cd
    jle.d8 L_004ff3f8                            # 004ff3cf
    # block 0x004ff3d1: entered by fall-through of jle at 0x004ff3cf, 1 instruction(s), falls into the block at 0x004ff3d7
    lea edi, [ebp + field_320]                   # 004ff3d1
L_004ff3d7:
    # block 0x004ff3d7: entered by jl at 0x004ff3f6, 12 instruction(s), calls indirect dword ptr [ecx + 0x10], ends with jl to 0x004ff3d7 (backward)
    mov eax, dword ptr [edi]                     # 004ff3d7
    mov edx, dword ptr [esi + field_30]          # 004ff3d9
    mov ecx, dword ptr [4*eax + 0x5669e0]        # 004ff3dc
    mov eax, dword ptr [edx + 4*ebx]             # 004ff3e3
    push eax                                     # 004ff3e6
    call dword ptr [ecx + field_10]              # 004ff3e7
    mov eax, dword ptr [ebp + field_10]          # 004ff3ea
    add esp, 0x4                                 # 004ff3ed
    inc ebx                                      # 004ff3f0
    add edi, 0x4                                 # 004ff3f1
    {load} cmp ebx, eax                          # 004ff3f4
    jl.d8 L_004ff3d7                             # 004ff3f6
L_004ff3f8:
    # block 0x004ff3f8: entered by jle at 0x004ff3cf; fall-through of jl at 0x004ff3f6, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff408
    mov ecx, dword ptr [esi + field_30]          # 004ff3f8
    push ecx                                     # 004ff3fb
    call FUN_0050e936                            # 004ff3fc
    mov edi, dword ptr [esp + stk_1c]            # 004ff401
    add esp, 0x4                                 # 004ff405
L_004ff408:
    # block 0x004ff408: entered by je at 0x004ff3c6, 3 instruction(s), ends with je to 0x004ff44f (forward)
    mov eax, dword ptr [esi + field_34]          # 004ff408
    test eax, eax                                # 004ff40b
    je.d8 L_004ff44f                             # 004ff40d
    # block 0x004ff40f: entered by fall-through of je at 0x004ff40d, 4 instruction(s), ends with jle to 0x004ff43f (forward)
    mov eax, dword ptr [ebp + field_14]          # 004ff40f
    {load} xor ebx, ebx                          # 004ff412
    test eax, eax                                # 004ff414
    jle.d8 L_004ff43f                            # 004ff416
    # block 0x004ff418: entered by fall-through of jle at 0x004ff416, 1 instruction(s), falls into the block at 0x004ff41e
    lea edi, [ebp + field_520]                   # 004ff418
L_004ff41e:
    # block 0x004ff41e: entered by jl at 0x004ff43d, 12 instruction(s), calls indirect dword ptr [eax + 0x10], ends with jl to 0x004ff41e (backward)
    mov edx, dword ptr [edi]                     # 004ff41e
    mov ecx, dword ptr [esi + field_34]          # 004ff420
    mov eax, dword ptr [4*edx + 0x5669e8]        # 004ff423
    mov edx, dword ptr [ecx + 4*ebx]             # 004ff42a
    push edx                                     # 004ff42d
    call dword ptr [eax + field_10]              # 004ff42e
    mov eax, dword ptr [ebp + field_14]          # 004ff431
    add esp, 0x4                                 # 004ff434
    inc ebx                                      # 004ff437
    add edi, 0x4                                 # 004ff438
    {load} cmp ebx, eax                          # 004ff43b
    jl.d8 L_004ff41e                             # 004ff43d
L_004ff43f:
    # block 0x004ff43f: entered by jle at 0x004ff416; fall-through of jl at 0x004ff43d, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff44f
    mov eax, dword ptr [esi + field_34]          # 004ff43f
    push eax                                     # 004ff442
    call FUN_0050e936                            # 004ff443
    mov edi, dword ptr [esp + stk_1c]            # 004ff448
    add esp, 0x4                                 # 004ff44c
L_004ff44f:
    # block 0x004ff44f: entered by je at 0x004ff40d, 3 instruction(s), ends with je to 0x004ff48c (forward)
    mov eax, dword ptr [esi + field_38]          # 004ff44f
    test eax, eax                                # 004ff452
    je.d8 L_004ff48c                             # 004ff454
    # block 0x004ff456: entered by fall-through of je at 0x004ff454, 4 instruction(s), ends with jle to 0x004ff47c (forward)
    mov eax, dword ptr [ebp + field_1c]          # 004ff456
    {load} xor ebx, ebx                          # 004ff459
    test eax, eax                                # 004ff45b
    jle.d8 L_004ff47c                            # 004ff45d
    # block 0x004ff45f: entered by fall-through of jle at 0x004ff45d, 1 instruction(s), falls into the block at 0x004ff461
    {load} xor edi, edi                          # 004ff45f
L_004ff461:
    # block 0x004ff461: entered by jl at 0x004ff47a, 11 instruction(s), calls FUN_005009a0, ends with jl to 0x004ff461 (backward)
    mov eax, dword ptr [esi + field_38]          # 004ff461
    {load} mov ecx, edi                          # 004ff464
    {load} add ecx, eax                          # 004ff466
    push ecx                                     # 004ff468
    call FUN_005009a0                            # 004ff469
    mov eax, dword ptr [ebp + field_1c]          # 004ff46e
    add esp, 0x4                                 # 004ff471
    inc ebx                                      # 004ff474
    add edi, 0x30                                # 004ff475
    {load} cmp ebx, eax                          # 004ff478
    jl.d8 L_004ff461                             # 004ff47a
L_004ff47c:
    # block 0x004ff47c: entered by jle at 0x004ff45d; fall-through of jl at 0x004ff47a, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff48c
    mov edx, dword ptr [esi + field_38]          # 004ff47c
    push edx                                     # 004ff47f
    call FUN_0050e936                            # 004ff480
    mov edi, dword ptr [esp + stk_1c]            # 004ff485
    add esp, 0x4                                 # 004ff489
L_004ff48c:
    # block 0x004ff48c: entered by je at 0x004ff454, 3 instruction(s), ends with je to 0x004ff49c (forward)
    mov eax, dword ptr [esi + field_3c]          # 004ff48c
    test eax, eax                                # 004ff48f
    je.d8 L_004ff49c                             # 004ff491
    # block 0x004ff493: entered by fall-through of je at 0x004ff491, 3 instruction(s), calls FUN_004ffc10, falls into the block at 0x004ff49c
    push eax                                     # 004ff493
    call FUN_004ffc10                            # 004ff494
    add esp, 0x4                                 # 004ff499
L_004ff49c:
    # block 0x004ff49c: entered by je at 0x004ff491, 11 instruction(s), calls FUN_00503aa0, FUN_005051b0, falls into the block at 0x004ff4be
    lea eax, [esi + field_4c]                    # 004ff49c
    push eax                                     # 004ff49f
    call FUN_00503aa0                            # 004ff4a0
    lea ecx, [esi + field_14]                    # 004ff4a5
    push ecx                                     # 004ff4a8
    call FUN_005051b0                            # 004ff4a9
    lea edx, [esi + field_20]                    # 004ff4ae
    push edx                                     # 004ff4b1
    call FUN_005051b0                            # 004ff4b2
    mov ecx, dword ptr [esp + stk_1c]            # 004ff4b7
    add esp, 0xc                                 # 004ff4bb
L_004ff4be:
    # block 0x004ff4be: entered by je at 0x004ff338, 3 instruction(s), ends with je to 0x004ff509 (forward)
    mov eax, dword ptr [edi + field_8]           # 004ff4be
    test eax, eax                                # 004ff4c1
    je.d8 L_004ff509                             # 004ff4c3
    # block 0x004ff4c5: entered by fall-through of je at 0x004ff4c3, 4 instruction(s), ends with jle to 0x004ff4ed (forward)
    mov eax, dword ptr [ecx + field_4]           # 004ff4c5
    {load} xor ebx, ebx                          # 004ff4c8
    test eax, eax                                # 004ff4ca
    jle.d8 L_004ff4ed                            # 004ff4cc
L_004ff4ce:
    # block 0x004ff4ce: entered by jl at 0x004ff4eb; fall-through of jle at 0x004ff4cc, 4 instruction(s), ends with je to 0x004ff4e5 (forward)
    mov eax, dword ptr [edi + field_8]           # 004ff4ce
    mov eax, dword ptr [eax + 4*ebx]             # 004ff4d1
    test eax, eax                                # 004ff4d4
    je.d8 L_004ff4e5                             # 004ff4d6
    # block 0x004ff4d8: entered by fall-through of je at 0x004ff4d6, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff4e5
    push eax                                     # 004ff4d8
    call FUN_0050e936                            # 004ff4d9
    mov ecx, dword ptr [esp + stk_14]            # 004ff4de
    add esp, 0x4                                 # 004ff4e2
L_004ff4e5:
    # block 0x004ff4e5: entered by je at 0x004ff4d6, 4 instruction(s), ends with jl to 0x004ff4ce (backward)
    mov eax, dword ptr [ecx + field_4]           # 004ff4e5
    inc ebx                                      # 004ff4e8
    {load} cmp ebx, eax                          # 004ff4e9
    jl.d8 L_004ff4ce                             # 004ff4eb
L_004ff4ed:
    # block 0x004ff4ed: entered by jle at 0x004ff4cc; fall-through of jl at 0x004ff4eb, 7 instruction(s), calls FUN_0050e936, ends with je to 0x004ff509 (forward)
    mov ecx, dword ptr [edi + field_8]           # 004ff4ed
    push ecx                                     # 004ff4f0
    call FUN_0050e936                            # 004ff4f1
    mov eax, dword ptr [edi + field_c]           # 004ff4f6
    add esp, 0x4                                 # 004ff4f9
    test eax, eax                                # 004ff4fc
    je.d8 L_004ff509                             # 004ff4fe
    # block 0x004ff500: entered by fall-through of je at 0x004ff4fe, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff509
    push eax                                     # 004ff500
    call FUN_0050e936                            # 004ff501
    add esp, 0x4                                 # 004ff506
L_004ff509:
    # block 0x004ff509: entered by je at 0x004ff4c3; je at 0x004ff4fe, 2 instruction(s), ends with je to 0x004ff546 (forward)
    test esi, esi                                # 004ff509
    je.d8 L_004ff546                             # 004ff50b
    # block 0x004ff50d: entered by fall-through of je at 0x004ff50b, 3 instruction(s), ends with je to 0x004ff51d (forward)
    mov eax, dword ptr [esi + field_40]          # 004ff50d
    test eax, eax                                # 004ff510
    je.d8 L_004ff51d                             # 004ff512
    # block 0x004ff514: entered by fall-through of je at 0x004ff512, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff51d
    push eax                                     # 004ff514
    call FUN_0050e936                            # 004ff515
    add esp, 0x4                                 # 004ff51a
L_004ff51d:
    # block 0x004ff51d: entered by je at 0x004ff512, 3 instruction(s), ends with je to 0x004ff52d (forward)
    mov eax, dword ptr [esi + field_44]          # 004ff51d
    test eax, eax                                # 004ff520
    je.d8 L_004ff52d                             # 004ff522
    # block 0x004ff524: entered by fall-through of je at 0x004ff522, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff52d
    push eax                                     # 004ff524
    call FUN_0050e936                            # 004ff525
    add esp, 0x4                                 # 004ff52a
L_004ff52d:
    # block 0x004ff52d: entered by je at 0x004ff522, 3 instruction(s), ends with je to 0x004ff53d (forward)
    mov eax, dword ptr [esi + field_48]          # 004ff52d
    test eax, eax                                # 004ff530
    je.d8 L_004ff53d                             # 004ff532
    # block 0x004ff534: entered by fall-through of je at 0x004ff532, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff53d
    push eax                                     # 004ff534
    call FUN_0050e936                            # 004ff535
    add esp, 0x4                                 # 004ff53a
L_004ff53d:
    # block 0x004ff53d: entered by je at 0x004ff532, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004ff546
    push esi                                     # 004ff53d
    call FUN_0050e936                            # 004ff53e
    add esp, 0x4                                 # 004ff543
L_004ff546:
    # block 0x004ff546: entered by je at 0x004ff50b, 6 instruction(s), falls into the block at 0x004ff552
    mov ecx, 0x1a                                # 004ff546
    {load} xor eax, eax                          # 004ff54b
    pop esi                                      # 004ff54d
    pop ebp                                      # 004ff54e
    rep stosd dword ptr es:[edi], eax            # 004ff54f
    pop ebx                                      # 004ff551
L_004ff552:
    # block 0x004ff552: entered by je at 0x004ff318, 3 instruction(s), ends with ret
    pop edi                                      # 004ff552
    pop ecx                                      # 004ff553
    ret                                          # 004ff554

# --- data items (not part of the function) -------------------------
.org 0x004ff555 - 0x401000
PAD_004ff555:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

