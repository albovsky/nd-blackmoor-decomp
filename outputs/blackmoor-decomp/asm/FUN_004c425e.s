# FUN_004c425e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c425e
# extent:       0x004c425e-0x004c46d1 (1139 code bytes)
# span:         0x004c425e-0x004c46d1 (code 1139, tables 0, padding 0)
# sha256:       523716a55c44db9d73c56b2a628d3071eaa631e0583ef5d5c9a4985e8fd6942c
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c425e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_c, field_10, field_14, field_46, field_4c, field_cd6; [ecx + n] field_4, field_8, field_14, field_46, field_c4a, field_cd6; [edx + n] field_4, field_8, field_c, field_10, field_46, field_c52
# callees:      calls FUN_0044a2b7, FUN_004c88c7, FUN_0042639d, FUN_0050ca3e, FUN_0051dc6c, FUN_004c9428, FUN_004c2dfb, FUN_0044c384; plus 7 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 332 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_46, 0x46  # offset +0x46
.equ field_4c, 0x4c  # offset +0x4c
.equ field_c4a, 0xc4a  # offset +0xc4a
.equ field_c52, 0xc52  # offset +0xc52
.equ field_cd6, 0xcd6  # offset +0xcd6

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c384, .text + (0x0044c384 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c9428, .text + (0x004c9428 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c425e - 0x401000
.globl FUN_004c425e
FUN_004c425e:
    # block 0x004c425e: entry, 9 instruction(s), ends with je to 0x004c4281 (forward)
    push ebp                                     # 004c425e
    {load} mov ebp, esp                          # 004c425f
    sub esp, 0x1c                                # 004c4261
    push esi                                     # 004c4264
    push edi                                     # 004c4265
    mov dword ptr [ebp - local_1c], ecx          # 004c4266
    movsx eax, word ptr [0x63a4cd]               # 004c4269
    test eax, eax                                # 004c4270
    je.d8 L_004c4281                             # 004c4272
    # block 0x004c4274: entered by fall-through of je at 0x004c4272, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c4281
    push 0x554404                                # 004c4274
    call FUN_0044a2b7                            # 004c4279
    add esp, 0x4                                 # 004c427e
L_004c4281:
    # block 0x004c4281: entered by je at 0x004c4272, 3 instruction(s), ends with je to 0x004c4503 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c4281
    cmp dword ptr [ecx + field_4], 0x0           # 004c4284
    je.d32 L_004c4503                            # 004c4288
    # block 0x004c428e: entered by fall-through of je at 0x004c4288, 3 instruction(s), ends with je to 0x004c4364 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c428e
    cmp dword ptr [edx + field_c52], 0x0         # 004c4291
    je.d32 L_004c4364                            # 004c4298
    # block 0x004c429e: entered by fall-through of je at 0x004c4298, 3 instruction(s), ends with je to 0x004c4364 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c429e
    cmp dword ptr [eax + field_46], 0x0          # 004c42a1
    je.d32 L_004c4364                            # 004c42a5
    # block 0x004c42ab: entered by fall-through of je at 0x004c42a5, 9 instruction(s), ends with je to 0x004c42f0 (forward)
    mov esi, dword ptr [ebp - local_1c]          # 004c42ab
    add esi, 0x4a                                # 004c42ae
    mov edi, dword ptr [ebp - local_1c]          # 004c42b1
    add edi, 0x64a                               # 004c42b4
    mov ecx, 0x180                               # 004c42ba
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c42bf
    mov ecx, dword ptr [ebp - local_1c]          # 004c42c1
    cmp dword ptr [ecx + field_c4a], 0x0         # 004c42c4
    je.d8 L_004c42f0                             # 004c42cb
    # block 0x004c42cd: entered by fall-through of je at 0x004c42cb, 13 instruction(s), calls indirect dword ptr [edx + 0x10], ends with forward jump to 0x004c4310
    mov edx, dword ptr [ebp - local_1c]          # 004c42cd
    add edx, 0x64a                               # 004c42d0
    push edx                                     # 004c42d6
    push 0x1                                     # 004c42d7
    mov eax, dword ptr [ebp - local_1c]          # 004c42d9
    mov ecx, dword ptr [eax + field_46]          # 004c42dc
    mov edx, dword ptr [ebp - local_1c]          # 004c42df
    mov eax, dword ptr [edx + field_46]          # 004c42e2
    mov edx, dword ptr [eax]                     # 004c42e5
    push ecx                                     # 004c42e7
    call dword ptr [edx + field_10]              # 004c42e8
    mov dword ptr [ebp - local_4], eax           # 004c42eb
    jmp.d8 L_004c4310                            # 004c42ee
L_004c42f0:
    # block 0x004c42f0: entered by je at 0x004c42cb, 12 instruction(s), calls indirect dword ptr [eax + 0x10], falls into the block at 0x004c4310
    mov eax, dword ptr [ebp - local_1c]          # 004c42f0
    add eax, 0x64a                               # 004c42f3
    push eax                                     # 004c42f8
    push 0x0                                     # 004c42f9
    mov ecx, dword ptr [ebp - local_1c]          # 004c42fb
    mov edx, dword ptr [ecx + field_46]          # 004c42fe
    mov eax, dword ptr [ebp - local_1c]          # 004c4301
    mov ecx, dword ptr [eax + field_46]          # 004c4304
    mov eax, dword ptr [ecx]                     # 004c4307
    push edx                                     # 004c4309
    call dword ptr [eax + field_10]              # 004c430a
    mov dword ptr [ebp - local_4], eax           # 004c430d
L_004c4310:
    # block 0x004c4310: entered by jmp at 0x004c42ee, 2 instruction(s), ends with jge to 0x004c434c (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004c4310
    jge.d8 L_004c434c                            # 004c4314
    # block 0x004c4316: entered by fall-through of jge at 0x004c4314, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, ends with je to 0x004c434a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c4316
    push ecx                                     # 004c4319
    mov ecx, dword ptr [ebp - local_1c]          # 004c431a
    call FUN_004c88c7                            # 004c431d
    push eax                                     # 004c4322
    push 0x55441c                                # 004c4323
    mov ecx, 0x583979                            # 004c4328
    call FUN_0042639d                            # 004c432d
    movsx edx, word ptr [0x63a4cd]               # 004c4332
    test edx, edx                                # 004c4339
    je.d8 L_004c434a                             # 004c433b
    # block 0x004c433d: entered by fall-through of je at 0x004c433b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c434a
    push 0x554458                                # 004c433d
    call FUN_0044a2b7                            # 004c4342
    add esp, 0x4                                 # 004c4347
L_004c434a:
    # block 0x004c434a: entered by je at 0x004c433b, 1 instruction(s), ends with forward jump to 0x004c4364
    jmp.d8 L_004c4364                            # 004c434a
L_004c434c:
    # block 0x004c434c: entered by jge at 0x004c4314, 3 instruction(s), ends with je to 0x004c4364 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c434c
    test eax, eax                                # 004c4353
    je.d8 L_004c4364                             # 004c4355
    # block 0x004c4357: entered by fall-through of je at 0x004c4355, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c4364
    push 0x554494                                # 004c4357
    call FUN_0044a2b7                            # 004c435c
    add esp, 0x4                                 # 004c4361
L_004c4364:
    # block 0x004c4364: entered by je at 0x004c4298; je at 0x004c42a5; jmp at 0x004c434a; je at 0x004c4355, 10 instruction(s), calls indirect dword ptr [eax + 0x4c], ends with je to 0x004c43b5 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c4364
    mov edx, dword ptr [ecx + field_4]           # 004c4367
    mov eax, dword ptr [ebp - local_1c]          # 004c436a
    mov ecx, dword ptr [eax + field_4]           # 004c436d
    mov eax, dword ptr [ecx]                     # 004c4370
    push edx                                     # 004c4372
    call dword ptr [eax + field_4c]              # 004c4373
    mov dword ptr [ebp - local_4], eax           # 004c4376
    cmp dword ptr [ebp - local_4], 0x0           # 004c4379
    je.d8 L_004c43b5                             # 004c437d
    # block 0x004c437f: entered by fall-through of je at 0x004c437d, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, ends with je to 0x004c43b3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c437f
    push ecx                                     # 004c4382
    mov ecx, dword ptr [ebp - local_1c]          # 004c4383
    call FUN_004c88c7                            # 004c4386
    push eax                                     # 004c438b
    push 0x5544b4                                # 004c438c
    mov ecx, 0x583979                            # 004c4391
    call FUN_0042639d                            # 004c4396
    movsx edx, word ptr [0x63a4cd]               # 004c439b
    test edx, edx                                # 004c43a2
    je.d8 L_004c43b3                             # 004c43a4
    # block 0x004c43a6: entered by fall-through of je at 0x004c43a4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c43b3
    push 0x5544cc                                # 004c43a6
    call FUN_0044a2b7                            # 004c43ab
    add esp, 0x4                                 # 004c43b0
L_004c43b3:
    # block 0x004c43b3: entered by je at 0x004c43a4, 1 instruction(s), ends with forward jump to 0x004c43cd
    jmp.d8 L_004c43cd                            # 004c43b3
L_004c43b5:
    # block 0x004c43b5: entered by je at 0x004c437d, 3 instruction(s), ends with je to 0x004c43cd (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c43b5
    test eax, eax                                # 004c43bc
    je.d8 L_004c43cd                             # 004c43be
    # block 0x004c43c0: entered by fall-through of je at 0x004c43be, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c43cd
    push 0x5544f4                                # 004c43c0
    call FUN_0044a2b7                            # 004c43c5
    add esp, 0x4                                 # 004c43ca
L_004c43cd:
    # block 0x004c43cd: entered by jmp at 0x004c43b3; je at 0x004c43be, 3 instruction(s), ends with je to 0x004c440a (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c43cd
    cmp dword ptr [ecx + field_46], 0x0          # 004c43d0
    je.d8 L_004c440a                             # 004c43d4
    # block 0x004c43d6: entered by fall-through of je at 0x004c43d4, 12 instruction(s), calls indirect dword ptr [ecx + 0x8], ends with je to 0x004c440a (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c43d6
    mov eax, dword ptr [edx + field_46]          # 004c43d9
    mov ecx, dword ptr [ebp - local_1c]          # 004c43dc
    mov edx, dword ptr [ecx + field_46]          # 004c43df
    mov ecx, dword ptr [edx]                     # 004c43e2
    push eax                                     # 004c43e4
    call dword ptr [ecx + field_8]               # 004c43e5
    mov edx, dword ptr [ebp - local_1c]          # 004c43e8
    mov dword ptr [edx + field_46], 0x0          # 004c43eb
    movsx eax, word ptr [0x63a4cd]               # 004c43f2
    test eax, eax                                # 004c43f9
    je.d8 L_004c440a                             # 004c43fb
    # block 0x004c43fd: entered by fall-through of je at 0x004c43fb, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c440a
    push 0x554514                                # 004c43fd
    call FUN_0044a2b7                            # 004c4402
    add esp, 0x4                                 # 004c4407
L_004c440a:
    # block 0x004c440a: entered by je at 0x004c43d4; je at 0x004c43fb, 3 instruction(s), ends with je to 0x004c4460 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c440a
    cmp dword ptr [ecx + field_8], 0x0           # 004c440d
    je.d8 L_004c4460                             # 004c4411
    # block 0x004c4413: entered by fall-through of je at 0x004c4411, 13 instruction(s), calls indirect dword ptr [ecx + 0x8], ends with je to 0x004c4460 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c4413
    mov eax, dword ptr [edx + field_8]           # 004c4416
    mov ecx, dword ptr [ebp - local_1c]          # 004c4419
    mov edx, dword ptr [ecx + field_8]           # 004c441c
    mov ecx, dword ptr [edx]                     # 004c441f
    push eax                                     # 004c4421
    call dword ptr [ecx + field_8]               # 004c4422
    mov dword ptr [ebp - local_10], eax          # 004c4425
    mov edx, dword ptr [ebp - local_1c]          # 004c4428
    mov dword ptr [edx + field_8], 0x0           # 004c442b
    movsx eax, word ptr [0x63a4cd]               # 004c4432
    test eax, eax                                # 004c4439
    je.d8 L_004c4460                             # 004c443b
    # block 0x004c443d: entered by fall-through of je at 0x004c443b, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c4460
    mov ecx, dword ptr [ebp - local_10]          # 004c443d
    push ecx                                     # 004c4440
    push 0x55452c                                # 004c4441
    push 0x63888b                                # 004c4446
    call FUN_0050ca3e                            # 004c444b
    add esp, 0xc                                 # 004c4450
    push 0x63888b                                # 004c4453
    call FUN_0044a2b7                            # 004c4458
    add esp, 0x4                                 # 004c445d
L_004c4460:
    # block 0x004c4460: entered by je at 0x004c4411; je at 0x004c443b, 3 instruction(s), ends with je to 0x004c44b6 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c4460
    cmp dword ptr [edx + field_c], 0x0           # 004c4463
    je.d8 L_004c44b6                             # 004c4467
    # block 0x004c4469: entered by fall-through of je at 0x004c4467, 13 instruction(s), calls indirect dword ptr [edx + 0x8], ends with je to 0x004c44b6 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c4469
    mov ecx, dword ptr [eax + field_c]           # 004c446c
    mov edx, dword ptr [ebp - local_1c]          # 004c446f
    mov eax, dword ptr [edx + field_c]           # 004c4472
    mov edx, dword ptr [eax]                     # 004c4475
    push ecx                                     # 004c4477
    call dword ptr [edx + field_8]               # 004c4478
    mov dword ptr [ebp - local_14], eax          # 004c447b
    mov eax, dword ptr [ebp - local_1c]          # 004c447e
    mov dword ptr [eax + field_c], 0x0           # 004c4481
    movsx ecx, word ptr [0x63a4cd]               # 004c4488
    test ecx, ecx                                # 004c448f
    je.d8 L_004c44b6                             # 004c4491
    # block 0x004c4493: entered by fall-through of je at 0x004c4491, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c44b6
    mov edx, dword ptr [ebp - local_14]          # 004c4493
    push edx                                     # 004c4496
    push 0x554554                                # 004c4497
    push 0x63888b                                # 004c449c
    call FUN_0050ca3e                            # 004c44a1
    add esp, 0xc                                 # 004c44a6
    push 0x63888b                                # 004c44a9
    call FUN_0044a2b7                            # 004c44ae
    add esp, 0x4                                 # 004c44b3
L_004c44b6:
    # block 0x004c44b6: entered by je at 0x004c4467; je at 0x004c4491, 13 instruction(s), calls indirect dword ptr [edx + 0x8], ends with je to 0x004c4503 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c44b6
    mov ecx, dword ptr [eax + field_4]           # 004c44b9
    mov edx, dword ptr [ebp - local_1c]          # 004c44bc
    mov eax, dword ptr [edx + field_4]           # 004c44bf
    mov edx, dword ptr [eax]                     # 004c44c2
    push ecx                                     # 004c44c4
    call dword ptr [edx + field_8]               # 004c44c5
    mov dword ptr [ebp - local_c], eax           # 004c44c8
    mov eax, dword ptr [ebp - local_1c]          # 004c44cb
    mov dword ptr [eax + field_4], 0x0           # 004c44ce
    movsx ecx, word ptr [0x63a4cd]               # 004c44d5
    test ecx, ecx                                # 004c44dc
    je.d8 L_004c4503                             # 004c44de
    # block 0x004c44e0: entered by fall-through of je at 0x004c44de, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c4503
    mov edx, dword ptr [ebp - local_c]           # 004c44e0
    push edx                                     # 004c44e3
    push 0x554580                                # 004c44e4
    push 0x63888b                                # 004c44e9
    call FUN_0050ca3e                            # 004c44ee
    add esp, 0xc                                 # 004c44f3
    push 0x63888b                                # 004c44f6
    call FUN_0044a2b7                            # 004c44fb
    add esp, 0x4                                 # 004c4500
L_004c4503:
    # block 0x004c4503: entered by je at 0x004c4288; je at 0x004c44de, 3 instruction(s), ends with je to 0x004c4521 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c4503
    cmp dword ptr [eax + field_14], 0x0          # 004c4506
    je.d8 L_004c4521                             # 004c450a
    # block 0x004c450c: entered by fall-through of je at 0x004c450a, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c4521
    mov ecx, dword ptr [ebp - local_1c]          # 004c450c
    mov edx, dword ptr [ecx + field_14]          # 004c450f
    mov dword ptr [ebp - local_18], edx          # 004c4512
    mov eax, dword ptr [ebp - local_18]          # 004c4515
    push eax                                     # 004c4518
    call FUN_0051dc6c                            # 004c4519
    add esp, 0x4                                 # 004c451e
L_004c4521:
    # block 0x004c4521: entered by je at 0x004c450a, 95 instruction(s), calls FUN_004c9428, FUN_004c2dfb, FUN_0044c384, ends with forward jump to 0x004c4680
    mov ecx, dword ptr [ebp - local_1c]          # 004c4521
    call FUN_004c9428                            # 004c4524
    mov ecx, dword ptr [ebp - local_1c]          # 004c4529
    add ecx, 0xcd2                               # 004c452c
    push ecx                                     # 004c4532
    mov ecx, dword ptr [ebp - local_1c]          # 004c4533
    call FUN_004c2dfb                            # 004c4536
    mov edx, dword ptr [ebp - local_1c]          # 004c453b
    add edx, 0xd62                               # 004c453e
    push edx                                     # 004c4544
    mov ecx, dword ptr [ebp - local_1c]          # 004c4545
    call FUN_004c2dfb                            # 004c4548
    mov eax, dword ptr [ebp - local_1c]          # 004c454d
    add eax, 0xd1e                               # 004c4550
    push eax                                     # 004c4555
    mov ecx, dword ptr [ebp - local_1c]          # 004c4556
    call FUN_004c2dfb                            # 004c4559
    mov ecx, dword ptr [ebp - local_1c]          # 004c455e
    add ecx, 0xd22                               # 004c4561
    push ecx                                     # 004c4567
    mov ecx, dword ptr [ebp - local_1c]          # 004c4568
    call FUN_004c2dfb                            # 004c456b
    mov edx, dword ptr [ebp - local_1c]          # 004c4570
    add edx, 0xd5e                               # 004c4573
    push edx                                     # 004c4579
    mov ecx, dword ptr [ebp - local_1c]          # 004c457a
    call FUN_004c2dfb                            # 004c457d
    mov eax, dword ptr [ebp - local_1c]          # 004c4582
    add eax, 0xd26                               # 004c4585
    push eax                                     # 004c458a
    mov ecx, dword ptr [ebp - local_1c]          # 004c458b
    call FUN_004c2dfb                            # 004c458e
    mov ecx, dword ptr [ebp - local_1c]          # 004c4593
    add ecx, 0xd2a                               # 004c4596
    push ecx                                     # 004c459c
    mov ecx, dword ptr [ebp - local_1c]          # 004c459d
    call FUN_004c2dfb                            # 004c45a0
    mov edx, dword ptr [ebp - local_1c]          # 004c45a5
    add edx, 0xd36                               # 004c45a8
    push edx                                     # 004c45ae
    mov ecx, dword ptr [ebp - local_1c]          # 004c45af
    call FUN_004c2dfb                            # 004c45b2
    mov eax, dword ptr [ebp - local_1c]          # 004c45b7
    add eax, 0xd3a                               # 004c45ba
    push eax                                     # 004c45bf
    mov ecx, dword ptr [ebp - local_1c]          # 004c45c0
    call FUN_004c2dfb                            # 004c45c3
    mov ecx, dword ptr [ebp - local_1c]          # 004c45c8
    add ecx, 0xd56                               # 004c45cb
    push ecx                                     # 004c45d1
    mov ecx, dword ptr [ebp - local_1c]          # 004c45d2
    call FUN_004c2dfb                            # 004c45d5
    mov edx, dword ptr [ebp - local_1c]          # 004c45da
    add edx, 0xd5a                               # 004c45dd
    push edx                                     # 004c45e3
    mov ecx, dword ptr [ebp - local_1c]          # 004c45e4
    call FUN_004c2dfb                            # 004c45e7
    mov eax, dword ptr [ebp - local_1c]          # 004c45ec
    add eax, 0xd2e                               # 004c45ef
    push eax                                     # 004c45f4
    mov ecx, dword ptr [ebp - local_1c]          # 004c45f5
    call FUN_004c2dfb                            # 004c45f8
    mov ecx, dword ptr [ebp - local_1c]          # 004c45fd
    add ecx, 0xd32                               # 004c4600
    push ecx                                     # 004c4606
    mov ecx, dword ptr [ebp - local_1c]          # 004c4607
    call FUN_004c2dfb                            # 004c460a
    mov edx, dword ptr [ebp - local_1c]          # 004c460f
    add edx, 0xd76                               # 004c4612
    push edx                                     # 004c4618
    mov ecx, dword ptr [ebp - local_1c]          # 004c4619
    call FUN_004c2dfb                            # 004c461c
    mov eax, dword ptr [ebp - local_1c]          # 004c4621
    add eax, 0xd7a                               # 004c4624
    push eax                                     # 004c4629
    mov ecx, dword ptr [ebp - local_1c]          # 004c462a
    call FUN_004c2dfb                            # 004c462d
    mov ecx, dword ptr [ebp - local_1c]          # 004c4632
    add ecx, 0xd7e                               # 004c4635
    push ecx                                     # 004c463b
    mov ecx, dword ptr [ebp - local_1c]          # 004c463c
    call FUN_004c2dfb                            # 004c463f
    mov edx, dword ptr [ebp - local_1c]          # 004c4644
    add edx, 0xd82                               # 004c4647
    push edx                                     # 004c464d
    mov ecx, dword ptr [ebp - local_1c]          # 004c464e
    call FUN_004c2dfb                            # 004c4651
    mov eax, dword ptr [ebp - local_1c]          # 004c4656
    add eax, 0xd86                               # 004c4659
    push eax                                     # 004c465e
    mov ecx, dword ptr [ebp - local_1c]          # 004c465f
    call FUN_004c2dfb                            # 004c4662
    call FUN_0044c384                            # 004c4667
    mov word ptr [ebp - local_8], 0x0            # 004c466c
    jmp.d8 L_004c4680                            # 004c4672
L_004c4674:
    # block 0x004c4674: entered by jmp at 0x004c46b1, 3 instruction(s), falls into the block at 0x004c4680
    mov cx, word ptr [ebp - local_8]             # 004c4674
    add cx, 0x1                                  # 004c4678
    mov word ptr [ebp - local_8], cx             # 004c467c
L_004c4680:
    # block 0x004c4680: entered by jmp at 0x004c4672, 3 instruction(s), ends with jge to 0x004c46b3 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004c4680
    cmp edx, 0x12                                # 004c4684
    jge.d8 L_004c46b3                            # 004c4687
    # block 0x004c4689: entered by fall-through of jge at 0x004c4687, 4 instruction(s), ends with je to 0x004c46b1 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004c4689
    mov ecx, dword ptr [ebp - local_1c]          # 004c468d
    cmp dword ptr [ecx + 4*eax + field_cd6], 0x0 # 004c4690
    je.d8 L_004c46b1                             # 004c4698
    # block 0x004c469a: entered by fall-through of je at 0x004c4698, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004c46b1
    movsx edx, word ptr [ebp - local_8]          # 004c469a
    mov eax, dword ptr [ebp - local_1c]          # 004c469e
    lea ecx, [eax + 4*edx + field_cd6]           # 004c46a1
    push ecx                                     # 004c46a8
    mov ecx, dword ptr [ebp - local_1c]          # 004c46a9
    call FUN_004c2dfb                            # 004c46ac
L_004c46b1:
    # block 0x004c46b1: entered by je at 0x004c4698, 1 instruction(s), ends with backward jump to 0x004c4674
    jmp.d8 L_004c4674                            # 004c46b1
L_004c46b3:
    # block 0x004c46b3: entered by jge at 0x004c4687, 3 instruction(s), ends with je to 0x004c46cb (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c46b3
    test edx, edx                                # 004c46ba
    je.d8 L_004c46cb                             # 004c46bc
    # block 0x004c46be: entered by fall-through of je at 0x004c46bc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c46cb
    push 0x5545a4                                # 004c46be
    call FUN_0044a2b7                            # 004c46c3
    add esp, 0x4                                 # 004c46c8
L_004c46cb:
    # block 0x004c46cb: entered by je at 0x004c46bc, 5 instruction(s), ends with ret
    pop edi                                      # 004c46cb
    pop esi                                      # 004c46cc
    {load} mov esp, ebp                          # 004c46cd
    pop ebp                                      # 004c46cf
    ret                                          # 004c46d0

