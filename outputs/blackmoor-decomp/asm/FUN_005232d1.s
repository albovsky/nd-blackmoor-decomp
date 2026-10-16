# FUN_005232d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005232d1
# extent:       0x005232d1-0x005233c8 (247 code bytes)
# span:         0x005232d1-0x005233c8 (code 247, tables 0, padding 0)
# sha256:       3632b2380294b1ef4e3218fc2b3596a80d316f8620a381f403236d3d3d8e3350
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005232d1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_14, field_58, field_60, field_64, field_7c, field_88, field_8c, field_94, field_bc; [ebx + n] field_9c; [edi + n] field_1c; [esi + n] field_48
# callees:      calls FUN_00525371, FUN_005214f0, FUN_005215bc, FUN_00524861, FUN_00524871, FUN_00526978, FUN_0051c0c9; plus 9 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 95 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_48, 0x48  # offset +0x48
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_7c, 0x7c  # offset +0x7c
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_94, 0x94  # offset +0x94
.equ field_9c, 0x9c  # offset +0x9c
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_0051c0c9, .text + (0x0051c0c9 - 0x401000)
.set FUN_005214f0, .text + (0x005214f0 - 0x401000)
.set FUN_005215bc, .text + (0x005215bc - 0x401000)
.set FUN_00524861, .text + (0x00524861 - 0x401000)
.set FUN_00524871, .text + (0x00524871 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00526978, .text + (0x00526978 - 0x401000)

.org 0x005232d1 - 0x401000
.globl FUN_005232d1
FUN_005232d1:
    # block 0x005232d1: entry, 10 instruction(s), ends with je to 0x005232ef (forward)
    push ebp                                     # 005232d1
    {load} mov ebp, esp                          # 005232d2
    push ecx                                     # 005232d4
    push ebx                                     # 005232d5
    {load} mov ebx, ecx                          # 005232d6
    push esi                                     # 005232d8
    push edi                                     # 005232d9
    mov eax, dword ptr [ebx + field_9c]          # 005232da
    test eax, eax                                # 005232e0
    je.d8 L_005232ef                             # 005232e2
    # block 0x005232e4: entered by fall-through of je at 0x005232e2, 4 instruction(s), calls indirect eax, ends with je to 0x005233c3 (forward)
    push ebx                                     # 005232e4
    call eax                                     # 005232e5
    test eax, eax                                # 005232e7
    je.d32 L_005233c3                            # 005232e9
L_005232ef:
    # block 0x005232ef: entered by je at 0x005232e2; fall-through of je at 0x005232e9, 6 instruction(s), calls indirect dword ptr [eax + 0xbc], ends with je to 0x00523312 (forward)
    mov eax, dword ptr [ebx]                     # 005232ef
    {load} mov ecx, ebx                          # 005232f1
    call dword ptr [eax + field_bc]              # 005232f3
    {load} mov esi, eax                          # 005232f9
    test esi, esi                                # 005232fb
    je.d8 L_00523312                             # 005232fd
    # block 0x005232ff: entered by fall-through of je at 0x005232fd, 6 instruction(s), calls indirect dword ptr [eax + 0x8c], ends with je to 0x005233c3 (forward)
    mov eax, dword ptr [esi]                     # 005232ff
    push ebx                                     # 00523301
    {load} mov ecx, esi                          # 00523302
    call dword ptr [eax + field_8c]              # 00523304
    test eax, eax                                # 0052330a
    je.d32 L_005233c3                            # 0052330c
L_00523312:
    # block 0x00523312: entered by je at 0x005232fd; fall-through of je at 0x0052330c, 4 instruction(s), calls FUN_00525371, ends with je to 0x00523374 (forward)
    call FUN_00525371                            # 00523312
    mov edi, dword ptr [eax + field_4]           # 00523317
    test edi, edi                                # 0052331a
    je.d8 L_00523374                             # 0052331c
    # block 0x0052331e: entered by fall-through of je at 0x0052331c, 2 instruction(s), ends with jne to 0x00523374 (forward)
    cmp dword ptr [edi + field_1c], ebx          # 0052331e
    jne.d8 L_00523374                            # 00523321
    # block 0x00523323: entered by fall-through of jne at 0x00523321, 2 instruction(s), ends with jne to 0x00523339 (forward)
    test esi, esi                                # 00523323
    jne.d8 L_00523339                            # 00523325
    # block 0x00523327: entered by fall-through of jne at 0x00523325, 5 instruction(s), calls indirect dword ptr [eax + 0x88], ends with je to 0x005233c3 (forward)
    mov eax, dword ptr [edi]                     # 00523327
    {load} mov ecx, edi                          # 00523329
    call dword ptr [eax + field_88]              # 0052332b
    test eax, eax                                # 00523331
    je.d32 L_005233c3                            # 00523333
L_00523339:
    # block 0x00523339: entered by jne at 0x00523325; fall-through of je at 0x00523333, 8 instruction(s), calls FUN_005214f0, FUN_005215bc, FUN_00524861, ends with jne to 0x0052335a (forward)
    {load} mov ecx, edi                          # 00523339
    call FUN_005214f0                            # 0052333b
    push 0x0                                     # 00523340
    {load} mov ecx, edi                          # 00523342
    call FUN_005215bc                            # 00523344
    call FUN_00524861                            # 00523349
    test eax, eax                                # 0052334e
    jne.d8 L_0052335a                            # 00523350
    # block 0x00523352: entered by fall-through of jne at 0x00523350, 3 instruction(s), calls FUN_00524871, ends with forward jump to 0x005233c3
    push eax                                     # 00523352
    call FUN_00524871                            # 00523353
    jmp.d8 L_005233c3                            # 00523358
L_0052335a:
    # block 0x0052335a: entered by jne at 0x00523350, 3 instruction(s), calls FUN_00525371, ends with jne to 0x00523374 (forward)
    call FUN_00525371                            # 0052335a
    cmp byte ptr [eax + field_14], 0x0           # 0052335f
    jne.d8 L_00523374                            # 00523363
    # block 0x00523365: entered by fall-through of jne at 0x00523363, 2 instruction(s), ends with jne to 0x00523374 (forward)
    cmp dword ptr [edi + field_1c], 0x0          # 00523365
    jne.d8 L_00523374                            # 00523369
    # block 0x0052336b: entered by fall-through of jne at 0x00523369, 3 instruction(s), calls FUN_00526978, ends with forward jump to 0x005233c3
    push 0x0                                     # 0052336b
    call FUN_00526978                            # 0052336d
    jmp.d8 L_005233c3                            # 00523372
L_00523374:
    # block 0x00523374: entered by je at 0x0052331c; jne at 0x00523321; jne at 0x00523363; jne at 0x00523369, 2 instruction(s), ends with je to 0x005233bc (forward)
    test esi, esi                                # 00523374
    je.d8 L_005233bc                             # 00523376
    # block 0x00523378: entered by fall-through of je at 0x00523376, 2 instruction(s), ends with je to 0x005233bc (forward)
    cmp dword ptr [esi + field_48], 0x0          # 00523378
    je.d8 L_005233bc                             # 0052337c
    # block 0x0052337e: entered by fall-through of je at 0x0052337c, 6 instruction(s), calls indirect dword ptr [eax + 0x60], ends with je to 0x005233a8 (forward)
    mov eax, dword ptr [esi]                     # 0052337e
    {load} mov ecx, esi                          # 00523380
    call dword ptr [eax + field_60]              # 00523382
    test eax, eax                                # 00523385
    mov dword ptr [ebp - local_4], eax           # 00523387
    je.d8 L_005233a8                             # 0052338a
L_0052338c:
    # block 0x0052338c: entered by jne at 0x005233a6; fall-through of je at 0x0052338a, 9 instruction(s), calls indirect dword ptr [eax + 0x64], FUN_0051c0c9, ends with jne to 0x005233b1 (forward)
    mov eax, dword ptr [esi]                     # 0052338c
    lea ecx, [ebp - local_4]                     # 0052338e
    push ecx                                     # 00523391
    {load} mov ecx, esi                          # 00523392
    call dword ptr [eax + field_64]              # 00523394
    {load} mov ecx, eax                          # 00523397
    call FUN_0051c0c9                            # 00523399
    {load} cmp eax, ebx                          # 0052339e
    jne.d8 L_005233b1                            # 005233a0
    # block 0x005233a2: entered by fall-through of jne at 0x005233a0, 2 instruction(s), ends with jne to 0x0052338c (backward)
    cmp dword ptr [ebp - local_4], 0x0           # 005233a2
    jne.d8 L_0052338c                            # 005233a6
L_005233a8:
    # block 0x005233a8: entered by je at 0x0052338a; fall-through of jne at 0x005233a6, 4 instruction(s), calls indirect dword ptr [eax + 0x7c], ends with forward jump to 0x005233c3
    mov eax, dword ptr [esi]                     # 005233a8
    {load} mov ecx, esi                          # 005233aa
    call dword ptr [eax + field_7c]              # 005233ac
    jmp.d8 L_005233c3                            # 005233af
L_005233b1:
    # block 0x005233b1: entered by jne at 0x005233a0, 4 instruction(s), calls indirect dword ptr [eax + 0x94], falls into the block at 0x005233bc
    mov eax, dword ptr [esi]                     # 005233b1
    push ebx                                     # 005233b3
    {load} mov ecx, esi                          # 005233b4
    call dword ptr [eax + field_94]              # 005233b6
L_005233bc:
    # block 0x005233bc: entered by je at 0x00523376; je at 0x0052337c, 3 instruction(s), calls indirect dword ptr [eax + 0x58], falls into the block at 0x005233c3
    mov eax, dword ptr [ebx]                     # 005233bc
    {load} mov ecx, ebx                          # 005233be
    call dword ptr [eax + field_58]              # 005233c0
L_005233c3:
    # block 0x005233c3: entered by je at 0x005232e9; je at 0x0052330c; je at 0x00523333; jmp at 0x00523358; more, 5 instruction(s), ends with ret
    pop edi                                      # 005233c3
    pop esi                                      # 005233c4
    pop ebx                                      # 005233c5
    leave                                        # 005233c6
    ret                                          # 005233c7

