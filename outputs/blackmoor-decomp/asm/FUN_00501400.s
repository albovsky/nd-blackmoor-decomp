# FUN_00501400
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501400
# extent:       0x00501400-0x00501532 (306 code bytes)
# span:         0x00501400-0x00501540 (code 306, tables 0, padding 14)
# sha256:       839e1718e8afc7accf94d5d1d8eb0976754a4016730ef5e3bac88895089c7304
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501400
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_minus_4; [ebp + n] field_20; [ebx + n] field_4; [edi + n] field_4, field_14, field_1c, field_24, field_28; [edx + n] field_1; [esi + n] field_1; [esp + n] stk_c, stk_10, stk_14, stk_18, stk_1c
# callees:      calls FUN_00501540
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 116 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00501540, .text + (0x00501540 - 0x401000)

.org 0x00501400 - 0x401000
.globl FUN_00501400
FUN_00501400:
    # block 0x00501400: entry, 22 instruction(s), calls FUN_00501540, ends with jle to 0x005014f5 (forward)
    push ebx                                     # 00501400
    mov ecx, dword ptr [esp + stk_c]             # 00501401
    push esi                                     # 00501405
    push edi                                     # 00501406
    mov edi, dword ptr [esp + stk_10]            # 00501407
    {load} xor esi, esi                          # 0050140b
    mov eax, dword ptr [edi + field_28]          # 0050140d
    mov ebx, dword ptr [edi + field_24]          # 00501410
    push eax                                     # 00501413
    push ebx                                     # 00501414
    push ecx                                     # 00501415
    call FUN_00501540                            # 00501416
    mov edx, dword ptr [edi + field_14]          # 0050141b
    mov ecx, dword ptr [edi + field_1c]          # 0050141e
    mov eax, dword ptr [edi]                     # 00501421
    add esp, 0xc                                 # 00501423
    mov edx, dword ptr [edx]                     # 00501426
    sar ebx                                      # 00501428
    {load} sub edx, ebx                          # 0050142a
    {load} sub edx, ecx                          # 0050142c
    cmp eax, 0x1                                 # 0050142e
    jle.d32 L_005014f5                           # 00501431
    # block 0x00501437: entered by fall-through of jle at 0x00501431, 1 instruction(s), falls into the block at 0x00501438
    push ebp                                     # 00501437
L_00501438:
    # block 0x00501438: entered by jl at 0x005014ee, 16 instruction(s), ends with jne to 0x0050146f (forward)
    mov eax, dword ptr [esp + stk_18]            # 00501438
    mov ebp, dword ptr [edi + field_1c]          # 0050143c
    mov ecx, dword ptr [eax + 4*edx]             # 0050143f
    lea ebx, [eax + 4*edx]                       # 00501442
    mov eax, dword ptr [edi + field_14]          # 00501445
    mov dword ptr [esp + stk_14], ecx            # 00501448
    fld dword ptr [esp + stk_14]                 # 0050144c
    mov ecx, dword ptr [eax + 4*esi + field_4]   # 00501450
    add ecx, dword ptr [eax + 4*esi]             # 00501454
    sar ecx                                      # 00501457
    {load} sub ecx, ebp                          # 00501459
    mov ebp, dword ptr [edi + field_4]           # 0050145b
    fcomp dword ptr [ebp + field_20]             # 0050145e
    fnstsw ax                                    # 00501461
    test ah, 0x41                                # 00501463
    jne.d8 L_0050146f                            # 00501466
    # block 0x00501468: entered by fall-through of jne at 0x00501466, 2 instruction(s), falls into the block at 0x0050146f
    mov eax, dword ptr [ebp + field_20]          # 00501468
    mov dword ptr [esp + stk_14], eax            # 0050146b
L_0050146f:
    # block 0x0050146f: entered by jne at 0x00501466, 3 instruction(s), ends with jg to 0x005014b3 (forward)
    lea ebp, [edx + field_1]                     # 0050146f
    {load} cmp ebp, ecx                          # 00501472
    jg.d8 L_005014b3                             # 00501474
L_00501476:
    # block 0x00501476: entered by jle at 0x005014b1; fall-through of jg at 0x00501474, 8 instruction(s), ends with jne to 0x00501498 (forward)
    fld dword ptr [ebx + field_4]                # 00501476
    fcomp dword ptr [0x52e600]                   # 00501479
    add ebx, 0x4                                 # 0050147f
    inc edx                                      # 00501482
    inc ebp                                      # 00501483
    fnstsw ax                                    # 00501484
    test ah, 0x41                                # 00501486
    jne.d8 L_00501498                            # 00501489
    # block 0x0050148b: entered by fall-through of jne at 0x00501489, 5 instruction(s), ends with jne to 0x005014a9 (forward)
    fld dword ptr [ebx]                          # 0050148b
    fcomp dword ptr [esp + stk_14]               # 0050148d
    fnstsw ax                                    # 00501491
    test ah, 0x1                                 # 00501493
    jne.d8 L_005014a9                            # 00501496
L_00501498:
    # block 0x00501498: entered by jne at 0x00501489; fall-through of jne at 0x00501496, 5 instruction(s), ends with je to 0x005014af (forward)
    fld dword ptr [esp + stk_14]                 # 00501498
    fcomp dword ptr [0x52e600]                   # 0050149c
    fnstsw ax                                    # 005014a2
    test ah, 0x40                                # 005014a4
    je.d8 L_005014af                             # 005014a7
L_005014a9:
    # block 0x005014a9: entered by jne at 0x00501496; fall-through of je at 0x005014a7, 2 instruction(s), falls into the block at 0x005014af
    mov eax, dword ptr [ebx]                     # 005014a9
    mov dword ptr [esp + stk_14], eax            # 005014ab
L_005014af:
    # block 0x005014af: entered by je at 0x005014a7, 2 instruction(s), ends with jle to 0x00501476 (backward)
    {load} cmp ebp, ecx                          # 005014af
    jle.d8 L_00501476                            # 005014b1
L_005014b3:
    # block 0x005014b3: entered by jg at 0x00501474; fall-through of jle at 0x005014b1, 5 instruction(s), ends with jge to 0x005014e7 (forward)
    mov eax, dword ptr [edi + field_1c]          # 005014b3
    lea ebx, [eax + edx]                         # 005014b6
    mov eax, dword ptr [edi]                     # 005014b9
    {load} cmp esi, eax                          # 005014bb
    jge.d8 L_005014e7                            # 005014bd
L_005014bf:
    # block 0x005014bf: entered by jl at 0x005014e5; fall-through of jge at 0x005014bd, 3 instruction(s), ends with jg to 0x005014e7 (forward)
    mov ecx, dword ptr [edi + field_14]          # 005014bf
    cmp dword ptr [ecx + 4*esi], ebx             # 005014c2
    jg.d8 L_005014e7                             # 005014c5
    # block 0x005014c7: entered by fall-through of jg at 0x005014c5, 6 instruction(s), ends with je to 0x005014e0 (forward)
    mov ecx, dword ptr [esp + stk_1c]            # 005014c7
    fld dword ptr [ecx + 4*esi]                  # 005014cb
    fcomp dword ptr [esp + stk_14]               # 005014ce
    fnstsw ax                                    # 005014d2
    test ah, 0x1                                 # 005014d4
    je.d8 L_005014e0                             # 005014d7
    # block 0x005014d9: entered by fall-through of je at 0x005014d7, 2 instruction(s), falls into the block at 0x005014e0
    fld dword ptr [esp + stk_14]                 # 005014d9
    fstp dword ptr [ecx + 4*esi]                 # 005014dd
L_005014e0:
    # block 0x005014e0: entered by je at 0x005014d7, 4 instruction(s), ends with jl to 0x005014bf (backward)
    mov eax, dword ptr [edi]                     # 005014e0
    inc esi                                      # 005014e2
    {load} cmp esi, eax                          # 005014e3
    jl.d8 L_005014bf                             # 005014e5
L_005014e7:
    # block 0x005014e7: entered by jge at 0x005014bd; jg at 0x005014c5; fall-through of jl at 0x005014e5, 4 instruction(s), ends with jl to 0x00501438 (backward)
    mov eax, dword ptr [edi]                     # 005014e7
    lea ecx, [esi + field_1]                     # 005014e9
    {load} cmp ecx, eax                          # 005014ec
    jl.d32 L_00501438                            # 005014ee
    # block 0x005014f4: entered by fall-through of jl at 0x005014ee, 1 instruction(s), falls into the block at 0x005014f5
    pop ebp                                      # 005014f4
L_005014f5:
    # block 0x005014f5: entered by jle at 0x00501431, 7 instruction(s), ends with jge to 0x0050152e (forward)
    mov edx, dword ptr [edi + field_28]          # 005014f5
    mov eax, dword ptr [esp + stk_14]            # 005014f8
    fld dword ptr [eax + 4*edx - field_minus_4]  # 005014fc
    mov eax, dword ptr [edi]                     # 00501500
    fstp dword ptr [esp + stk_14]                # 00501502
    {load} cmp esi, eax                          # 00501506
    jge.d8 L_0050152e                            # 00501508
    # block 0x0050150a: entered by fall-through of jge at 0x00501508, 2 instruction(s), falls into the block at 0x00501511
    mov ecx, dword ptr [esp + stk_18]            # 0050150a
    lea ecx, [ecx + 4*esi]                       # 0050150e
L_00501511:
    # block 0x00501511: entered by jl at 0x0050152c, 5 instruction(s), ends with je to 0x00501524 (forward)
    fld dword ptr [ecx]                          # 00501511
    fcomp dword ptr [esp + stk_14]               # 00501513
    fnstsw ax                                    # 00501517
    test ah, 0x1                                 # 00501519
    je.d8 L_00501524                             # 0050151c
    # block 0x0050151e: entered by fall-through of je at 0x0050151c, 2 instruction(s), falls into the block at 0x00501524
    mov edx, dword ptr [esp + stk_14]            # 0050151e
    mov dword ptr [ecx], edx                     # 00501522
L_00501524:
    # block 0x00501524: entered by je at 0x0050151c, 5 instruction(s), ends with jl to 0x00501511 (backward)
    mov eax, dword ptr [edi]                     # 00501524
    inc esi                                      # 00501526
    add ecx, 0x4                                 # 00501527
    {load} cmp esi, eax                          # 0050152a
    jl.d8 L_00501511                             # 0050152c
L_0050152e:
    # block 0x0050152e: entered by jge at 0x00501508; fall-through of jl at 0x0050152c, 4 instruction(s), ends with ret
    pop edi                                      # 0050152e
    pop esi                                      # 0050152f
    pop ebx                                      # 00501530
    ret                                          # 00501531

# --- data items (not part of the function) -------------------------
.org 0x00501532 - 0x401000
PAD_00501532:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

