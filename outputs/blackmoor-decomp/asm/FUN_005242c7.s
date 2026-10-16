# FUN_005242c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005242c7
# extent:       0x005242c7-0x005244e2 (539 code bytes)
# span:         0x005242c7-0x005244e2 (code 539, tables 0, padding 0)
# sha256:       acfb08a5282f3cb9d7aea44b17ac1b22620de0ef204fb5bf938e8e7107141a9f
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005242c7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_5c, field_68, field_c0, field_c8, field_d0, field_minus_e800; [ebx + n] field_1c; [edi + n] field_4, field_8, field_10, field_14; [esi + n] field_1c, field_48, field_70, field_9c, field_b8; [esp + n] stk_10, stk_14, stk_18, stk_20, stk_24, stk_28
# callees:      calls USER32.dll!GetDlgCtrlID, FUN_005239bd, FUN_00522d82, USER32.dll!ShowWindow, USER32.dll!GetMenu, USER32.dll!InvalidateRect, USER32.dll!SetMenu, FUN_00522953, USER32.dll!SetWindowLongA; plus 11 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 177 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005244e2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_e800, 0xe800  # offset -0xe800
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_48, 0x48  # offset +0x48
.equ field_5c, 0x5c  # offset +0x5c
.equ field_68, 0x68  # offset +0x68
.equ field_70, 0x70  # offset +0x70
.equ field_9c, 0x9c  # offset +0x9c
.equ field_b8, 0xb8  # offset +0xb8
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c8, 0xc8  # offset +0xc8
.equ field_d0, 0xd0  # offset +0xd0

# --- external targets -----------------------------------------------
.set FUN_00522953, .text + (0x00522953 - 0x401000)
.set FUN_00522d82, .text + (0x00522d82 - 0x401000)
.set FUN_005239bd, .text + (0x005239bd - 0x401000)

.org 0x005242c7 - 0x401000
.globl FUN_005242c7
FUN_005242c7:
    # block 0x005242c7: entry, 12 instruction(s), calls indirect dword ptr [eax + 0xc0], ends with je to 0x005242f1 (forward)
    sub esp, 0xc                                 # 005242c7
    push ebx                                     # 005242ca
    push ebp                                     # 005242cb
    push esi                                     # 005242cc
    {load} mov esi, ecx                          # 005242cd
    push edi                                     # 005242cf
    mov eax, dword ptr [esi]                     # 005242d0
    call dword ptr [eax + field_c0]              # 005242d2
    {load} xor ebx, ebx                          # 005242d8
    mov dword ptr [esp + stk_18], eax            # 005242da
    cmp dword ptr [esp + stk_20], ebx            # 005242de
    je.d8 L_005242f1                             # 005242e2
    # block 0x005242e4: entered by fall-through of je at 0x005242e2, 3 instruction(s), ends with je to 0x005242f1 (forward)
    mov ecx, dword ptr [eax + field_68]          # 005242e4
    {load} cmp ecx, ebx                          # 005242e7
    je.d8 L_005242f1                             # 005242e9
    # block 0x005242eb: entered by fall-through of je at 0x005242e9, 3 instruction(s), calls indirect dword ptr [eax + 0x5c], falls into the block at 0x005242f1
    mov eax, dword ptr [ecx]                     # 005242eb
    push ebx                                     # 005242ed
    call dword ptr [eax + field_5c]              # 005242ee
L_005242f1:
    # block 0x005242f1: entered by je at 0x005242e2; je at 0x005242e9, 5 instruction(s), ends with je to 0x0052437b (forward)
    mov ebp, dword ptr [esi + field_70]          # 005242f1
    mov edi, dword ptr [esp + stk_24]            # 005242f4
    {load} cmp ebp, ebx                          # 005242f8
    mov dword ptr [esp + stk_10], ebx            # 005242fa
    je.d8 L_0052437b                             # 005242fe
L_00524300:
    # block 0x00524300: entered by jne at 0x00524377; fall-through of je at 0x005242fe, 9 instruction(s), calls USER32.dll!GetDlgCtrlID, ends with jb to 0x00524375 (forward)
    {load} mov eax, ebp                          # 00524300
    {disp8} mov ebp, dword ptr [ebp]             # 00524302
    mov ebx, dword ptr [eax + field_8]           # 00524305
    push dword ptr [ebx + field_1c]              # 00524308
    call dword ptr [0x52a40c]                    # 0052430b
    movzx eax, ax                                # 00524311
    cmp eax, 0xe800                              # 00524314
    mov dword ptr [esp + stk_14], eax            # 00524319
    jb.d8 L_00524375                             # 0052431d
    # block 0x0052431f: entered by fall-through of jb at 0x0052431d, 2 instruction(s), ends with ja to 0x00524375 (forward)
    cmp eax, 0xe81f                              # 0052431f
    ja.d8 L_00524375                             # 00524324
    # block 0x00524326: entered by fall-through of ja at 0x00524324, 10 instruction(s), calls indirect dword ptr [eax + 0xc8], ends with je to 0x0052434b (forward)
    push 0x1                                     # 00524326
    lea ecx, [eax - field_minus_e800]            # 00524328
    pop eax                                      # 0052432e
    shl eax, cl                                  # 0052432f
    {load} mov ecx, ebx                          # 00524331
    mov dword ptr [esp + stk_24], eax            # 00524333
    mov eax, dword ptr [ebx]                     # 00524337
    call dword ptr [eax + field_c8]              # 00524339
    test eax, eax                                # 0052433f
    je.d8 L_0052434b                             # 00524341
    # block 0x00524343: entered by fall-through of je at 0x00524341, 2 instruction(s), falls into the block at 0x0052434b
    mov eax, dword ptr [esp + stk_24]            # 00524343
    or dword ptr [esp + stk_10], eax             # 00524347
L_0052434b:
    # block 0x0052434b: entered by je at 0x00524341, 5 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with je to 0x00524363 (forward)
    mov eax, dword ptr [ebx]                     # 0052434b
    {load} mov ecx, ebx                          # 0052434d
    call dword ptr [eax + field_d0]              # 0052434f
    test eax, eax                                # 00524355
    je.d8 L_00524363                             # 00524357
    # block 0x00524359: entered by fall-through of je at 0x00524357, 2 instruction(s), ends with je to 0x00524375 (forward)
    cmp dword ptr [esp + stk_14], 0xe81f         # 00524359
    je.d8 L_00524375                             # 00524361
L_00524363:
    # block 0x00524363: entered by je at 0x00524357; fall-through of je at 0x00524361, 7 instruction(s), calls FUN_005239bd, falls into the block at 0x00524375
    mov eax, dword ptr [edi + field_8]           # 00524363
    push 0x1                                     # 00524366
    and eax, dword ptr [esp + stk_28]            # 00524368
    {load} mov ecx, esi                          # 0052436c
    push eax                                     # 0052436e
    push ebx                                     # 0052436f
    call FUN_005239bd                            # 00524370
L_00524375:
    # block 0x00524375: entered by jb at 0x0052431d; ja at 0x00524324; je at 0x00524361, 2 instruction(s), ends with jne to 0x00524300 (backward)
    test ebp, ebp                                # 00524375
    jne.d8 L_00524300                            # 00524377
    # block 0x00524379: entered by fall-through of jne at 0x00524377, 1 instruction(s), falls into the block at 0x0052437b
    {load} xor ebx, ebx                          # 00524379
L_0052437b:
    # block 0x0052437b: entered by je at 0x005242fe, 4 instruction(s), ends with je to 0x00524428 (forward)
    mov eax, dword ptr [esp + stk_10]            # 0052437b
    cmp dword ptr [esp + stk_20], ebx            # 0052437f
    mov dword ptr [edi + field_8], eax           # 00524383
    je.d32 L_00524428                            # 00524386
    # block 0x0052438c: entered by fall-through of je at 0x00524386, 18 instruction(s), calls FUN_00522d82, indirect ebp, USER32.dll!ShowWindow, USER32.dll!GetMenu, ends with je to 0x005243e3 (forward)
    mov eax, dword ptr [edi + field_10]          # 0052438c
    push ebx                                     # 0052438f
    {load} mov ecx, esi                          # 00524390
    mov dword ptr [esi + field_9c], eax          # 00524392
    call FUN_00522d82                            # 00524398
    push dword ptr [edi]                         # 0052439d
    mov ebp, dword ptr [0x52a404]                # 0052439f
    push dword ptr [esi + field_1c]              # 005243a5
    call ebp                                     # 005243a8
    push ebx                                     # 005243aa
    push eax                                     # 005243ab
    mov dword ptr [esp + stk_28], eax            # 005243ac
    call dword ptr [0x52a32c]                    # 005243b0
    push dword ptr [esi + field_1c]              # 005243b6
    call dword ptr [0x52a3f4]                    # 005243b9
    {load} cmp eax, ebx                          # 005243bf
    mov dword ptr [edi + field_4], eax           # 005243c1
    je.d8 L_005243e3                             # 005243c4
    # block 0x005243c6: entered by fall-through of je at 0x005243c4, 8 instruction(s), calls USER32.dll!InvalidateRect, USER32.dll!SetMenu, falls into the block at 0x005243e3
    push 0x1                                     # 005243c6
    push ebx                                     # 005243c8
    push dword ptr [esi + field_1c]              # 005243c9
    call dword ptr [0x52a39c]                    # 005243cc
    push ebx                                     # 005243d2
    push dword ptr [esi + field_1c]              # 005243d3
    call dword ptr [0x52a390]                    # 005243d6
    and dword ptr [esi + field_b8], -0x2         # 005243dc
L_005243e3:
    # block 0x005243e3: entered by je at 0x005243c4, 9 instruction(s), calls FUN_00522953, ends with je to 0x00524409 (forward)
    mov eax, dword ptr [esi + field_48]          # 005243e3
    push 0x7915                                  # 005243e6
    mov dword ptr [edi + field_14], eax          # 005243eb
    {load} mov ecx, esi                          # 005243ee
    mov dword ptr [esi + field_48], ebx          # 005243f0
    call FUN_00522953                            # 005243f3
    mov ebx, 0xe900                              # 005243f8
    cmp dword ptr [edi], ebx                     # 005243fd
    je.d8 L_00524409                             # 005243ff
    # block 0x00524401: entered by fall-through of je at 0x005243ff, 4 instruction(s), calls indirect ebp, ends with forward jump to 0x0052440d
    push ebx                                     # 00524401
    push dword ptr [esi + field_1c]              # 00524402
    call ebp                                     # 00524405
    jmp.d8 L_0052440d                            # 00524407
L_00524409:
    # block 0x00524409: entered by je at 0x005243ff, 1 instruction(s), falls into the block at 0x0052440d
    mov eax, dword ptr [esp + stk_20]            # 00524409
L_0052440d:
    # block 0x0052440d: entered by jmp at 0x00524407, 2 instruction(s), ends with je to 0x005244d8 (forward)
    test eax, eax                                # 0052440d
    je.d32 L_005244d8                            # 0052440f
    # block 0x00524415: entered by fall-through of je at 0x0052440f, 5 instruction(s), calls USER32.dll!SetWindowLongA, ends with forward jump to 0x005244d8
    push 0xea21                                  # 00524415
    push -0xc                                    # 0052441a
    push eax                                     # 0052441c
    call dword ptr [0x52a458]                    # 0052441d
    jmp.d32 L_005244d8                           # 00524423
L_00524428:
    # block 0x00524428: entered by je at 0x00524386, 9 instruction(s), calls indirect ebp, ends with je to 0x00524470 (forward)
    mov ebp, dword ptr [0x52a404]                # 00524428
    push 0xea21                                  # 0052442e
    push dword ptr [esi + field_1c]              # 00524433
    mov dword ptr [esi + field_9c], ebx          # 00524436
    call ebp                                     # 0052443c
    test eax, eax                                # 0052443e
    mov dword ptr [esp + stk_20], eax            # 00524440
    mov ebx, 0xe900                              # 00524444
    je.d8 L_00524470                             # 00524449
    # block 0x0052444b: entered by fall-through of je at 0x00524449, 5 instruction(s), calls indirect ebp, ends with je to 0x00524463 (forward)
    push ebx                                     # 0052444b
    push dword ptr [esi + field_1c]              # 0052444c
    call ebp                                     # 0052444f
    test eax, eax                                # 00524451
    je.d8 L_00524463                             # 00524453
    # block 0x00524455: entered by fall-through of je at 0x00524453, 4 instruction(s), calls USER32.dll!SetWindowLongA, falls into the block at 0x00524463
    push 0xea21                                  # 00524455
    push -0xc                                    # 0052445a
    push eax                                     # 0052445c
    call dword ptr [0x52a458]                    # 0052445d
L_00524463:
    # block 0x00524463: entered by je at 0x00524453, 4 instruction(s), calls USER32.dll!SetWindowLongA, falls into the block at 0x00524470
    push ebx                                     # 00524463
    push -0xc                                    # 00524464
    push dword ptr [esp + stk_28]                # 00524466
    call dword ptr [0x52a458]                    # 0052446a
L_00524470:
    # block 0x00524470: entered by je at 0x00524449, 2 instruction(s), ends with je to 0x0052448f (forward)
    cmp dword ptr [edi + field_4], 0x0           # 00524470
    je.d8 L_0052448f                             # 00524474
    # block 0x00524476: entered by fall-through of je at 0x00524474, 7 instruction(s), calls USER32.dll!InvalidateRect, USER32.dll!SetMenu, falls into the block at 0x0052448f
    push 0x1                                     # 00524476
    push 0x0                                     # 00524478
    push dword ptr [esi + field_1c]              # 0052447a
    call dword ptr [0x52a39c]                    # 0052447d
    push dword ptr [edi + field_4]               # 00524483
    push dword ptr [esi + field_1c]              # 00524486
    call dword ptr [0x52a390]                    # 00524489
L_0052448f:
    # block 0x0052448f: entered by je at 0x00524474, 4 instruction(s), ends with je to 0x005244a1 (forward)
    mov eax, dword ptr [esp + stk_18]            # 0052448f
    mov ecx, dword ptr [eax + field_68]          # 00524493
    test ecx, ecx                                # 00524496
    je.d8 L_005244a1                             # 00524498
    # block 0x0052449a: entered by fall-through of je at 0x00524498, 3 instruction(s), calls indirect dword ptr [eax + 0x5c], falls into the block at 0x005244a1
    mov eax, dword ptr [ecx]                     # 0052449a
    push 0x1                                     # 0052449c
    call dword ptr [eax + field_5c]              # 0052449e
L_005244a1:
    # block 0x005244a1: entered by je at 0x00524498, 7 instruction(s), calls indirect dword ptr [eax + 0xc8], ends with je to 0x005244bd (forward)
    mov eax, dword ptr [esi]                     # 005244a1
    push 0x1                                     # 005244a3
    {load} mov ecx, esi                          # 005244a5
    call dword ptr [eax + field_c8]              # 005244a7
    mov eax, dword ptr [edi]                     # 005244ad
    {load} cmp eax, ebx                          # 005244af
    je.d8 L_005244bd                             # 005244b1
    # block 0x005244b3: entered by fall-through of je at 0x005244b1, 4 instruction(s), calls indirect ebp, falls into the block at 0x005244bd
    push eax                                     # 005244b3
    push dword ptr [esi + field_1c]              # 005244b4
    call ebp                                     # 005244b7
    mov dword ptr [esp + stk_20], eax            # 005244b9
L_005244bd:
    # block 0x005244bd: entered by je at 0x005244b1, 8 instruction(s), calls USER32.dll!ShowWindow, FUN_00522d82, falls into the block at 0x005244d8
    push 0x5                                     # 005244bd
    push dword ptr [esp + stk_24]                # 005244bf
    call dword ptr [0x52a32c]                    # 005244c3
    mov eax, dword ptr [edi + field_14]          # 005244c9
    push 0x1                                     # 005244cc
    {load} mov ecx, esi                          # 005244ce
    mov dword ptr [esi + field_48], eax          # 005244d0
    call FUN_00522d82                            # 005244d3
L_005244d8:
    # block 0x005244d8: entered by je at 0x0052440f; jmp at 0x00524423, 6 instruction(s), ends with ret 0x8
    pop edi                                      # 005244d8
    pop esi                                      # 005244d9
    pop ebp                                      # 005244da
    pop ebx                                      # 005244db
    add esp, 0xc                                 # 005244dc
    ret 0x8                                      # 005244df

