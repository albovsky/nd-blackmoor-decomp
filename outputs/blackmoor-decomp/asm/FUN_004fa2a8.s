# FUN_004fa2a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa2a8
# extent:       0x004fa2a8-0x004fa590 (744 code bytes)
# span:         0x004fa2a8-0x004fa658 (code 744, tables 200, padding 0)
# sha256:       9f51a1e6436b7a01ddc4d3841c0eb1f4c975516c127d1531204998f25861e87d
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fa2a8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_38, local_3c, local_40
# fields:       [eax + n] field_3c2; [ecx + n] field_3ca
# callees:      calls FUN_004fa658, FUN_0050ca3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------
.set FUN_004fa658, .text + (0x004fa658 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fa2a8 - 0x401000
.globl FUN_004fa2a8
FUN_004fa2a8:
    # block 0x004fa2a8: entry, 16 instruction(s), ends with ja to 0x004fa509 (forward)
    push ebp                                     # 004fa2a8
    {load} mov ebp, esp                          # 004fa2a9
    sub esp, 0x40                                # 004fa2ab
    push ebx                                     # 004fa2ae
    push esi                                     # 004fa2af
    push edi                                     # 004fa2b0
    mov dword ptr [ebp - local_3c], ecx          # 004fa2b1
    mov dword ptr [ebp - local_4], 0x0           # 004fa2b4
    mov eax, dword ptr [ebp - local_3c]          # 004fa2bb
    mov ecx, dword ptr [eax + field_3c2]         # 004fa2be
    mov dword ptr [ebp - local_40], ecx          # 004fa2c4
    mov edx, dword ptr [ebp - local_40]          # 004fa2c7
    sub edx, 0x3e8                               # 004fa2ca
    mov dword ptr [ebp - local_40], edx          # 004fa2d0
    cmp dword ptr [ebp - local_40], 0x31         # 004fa2d3
    ja.d32 L_004fa509                            # 004fa2d7
    # block 0x004fa2dd: entered by fall-through of ja at 0x004fa2d7, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4fa590]
    mov eax, dword ptr [ebp - local_40]          # 004fa2dd
    jmp dword ptr [4*eax + SWTAB_004fa590_VA]    # 004fa2e0
L_004fa2e7:
    # block 0x004fa2e7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f530      # 004fa2e7
    jmp.d32 L_004fa510                           # 004fa2ee
L_004fa2f3:
    # block 0x004fa2f3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f560      # 004fa2f3
    jmp.d32 L_004fa510                           # 004fa2fa
L_004fa2ff:
    # block 0x004fa2ff: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f594      # 004fa2ff
    jmp.d32 L_004fa510                           # 004fa306
L_004fa30b:
    # block 0x004fa30b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f5c4      # 004fa30b
    jmp.d32 L_004fa510                           # 004fa312
L_004fa317:
    # block 0x004fa317: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f60c      # 004fa317
    jmp.d32 L_004fa510                           # 004fa31e
L_004fa323:
    # block 0x004fa323: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f640      # 004fa323
    jmp.d32 L_004fa510                           # 004fa32a
L_004fa32f:
    # block 0x004fa32f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f670      # 004fa32f
    jmp.d32 L_004fa510                           # 004fa336
L_004fa33b:
    # block 0x004fa33b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f698      # 004fa33b
    jmp.d32 L_004fa510                           # 004fa342
L_004fa347:
    # block 0x004fa347: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f6c4      # 004fa347
    jmp.d32 L_004fa510                           # 004fa34e
L_004fa353:
    # block 0x004fa353: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f6e8      # 004fa353
    jmp.d32 L_004fa510                           # 004fa35a
L_004fa35f:
    # block 0x004fa35f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f720      # 004fa35f
    jmp.d32 L_004fa510                           # 004fa366
L_004fa36b:
    # block 0x004fa36b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f75c      # 004fa36b
    jmp.d32 L_004fa510                           # 004fa372
L_004fa377:
    # block 0x004fa377: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f790      # 004fa377
    jmp.d32 L_004fa510                           # 004fa37e
L_004fa383:
    # block 0x004fa383: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f7c8      # 004fa383
    jmp.d32 L_004fa510                           # 004fa38a
L_004fa38f:
    # block 0x004fa38f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f7f4      # 004fa38f
    jmp.d32 L_004fa510                           # 004fa396
L_004fa39b:
    # block 0x004fa39b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f820      # 004fa39b
    jmp.d32 L_004fa510                           # 004fa3a2
L_004fa3a7:
    # block 0x004fa3a7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f85c      # 004fa3a7
    jmp.d32 L_004fa510                           # 004fa3ae
L_004fa3b3:
    # block 0x004fa3b3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f8c4      # 004fa3b3
    jmp.d32 L_004fa510                           # 004fa3ba
L_004fa3bf:
    # block 0x004fa3bf: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f93c      # 004fa3bf
    jmp.d32 L_004fa510                           # 004fa3c6
L_004fa3cb:
    # block 0x004fa3cb: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f978      # 004fa3cb
    jmp.d32 L_004fa510                           # 004fa3d2
L_004fa3d7:
    # block 0x004fa3d7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55f9c8      # 004fa3d7
    jmp.d32 L_004fa510                           # 004fa3de
L_004fa3e3:
    # block 0x004fa3e3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fa10      # 004fa3e3
    jmp.d32 L_004fa510                           # 004fa3ea
L_004fa3ef:
    # block 0x004fa3ef: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fa4c      # 004fa3ef
    jmp.d32 L_004fa510                           # 004fa3f6
L_004fa3fb:
    # block 0x004fa3fb: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fa90      # 004fa3fb
    jmp.d32 L_004fa510                           # 004fa402
L_004fa407:
    # block 0x004fa407: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fad4      # 004fa407
    jmp.d32 L_004fa510                           # 004fa40e
L_004fa413:
    # block 0x004fa413: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fb20      # 004fa413
    jmp.d32 L_004fa510                           # 004fa41a
L_004fa41f:
    # block 0x004fa41f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fb70      # 004fa41f
    jmp.d32 L_004fa510                           # 004fa426
L_004fa42b:
    # block 0x004fa42b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fbb0      # 004fa42b
    jmp.d32 L_004fa510                           # 004fa432
L_004fa437:
    # block 0x004fa437: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fbf0      # 004fa437
    jmp.d32 L_004fa510                           # 004fa43e
L_004fa443:
    # block 0x004fa443: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fc30      # 004fa443
    jmp.d32 L_004fa510                           # 004fa44a
L_004fa44f:
    # block 0x004fa44f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fc80      # 004fa44f
    jmp.d32 L_004fa510                           # 004fa456
L_004fa45b:
    # block 0x004fa45b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fcc4      # 004fa45b
    jmp.d32 L_004fa510                           # 004fa462
L_004fa467:
    # block 0x004fa467: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fd10      # 004fa467
    jmp.d32 L_004fa510                           # 004fa46e
L_004fa473:
    # block 0x004fa473: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fd50      # 004fa473
    jmp.d32 L_004fa510                           # 004fa47a
L_004fa47f:
    # block 0x004fa47f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fd9c      # 004fa47f
    jmp.d32 L_004fa510                           # 004fa486
L_004fa48b:
    # block 0x004fa48b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fde8      # 004fa48b
    jmp.d8 L_004fa510                            # 004fa492
L_004fa494:
    # block 0x004fa494: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fe38      # 004fa494
    jmp.d8 L_004fa510                            # 004fa49b
L_004fa49d:
    # block 0x004fa49d: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fe88      # 004fa49d
    jmp.d8 L_004fa510                            # 004fa4a4
L_004fa4a6:
    # block 0x004fa4a6: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55fed8      # 004fa4a6
    jmp.d8 L_004fa510                            # 004fa4ad
L_004fa4af:
    # block 0x004fa4af: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55ff28      # 004fa4af
    jmp.d8 L_004fa510                            # 004fa4b6
L_004fa4b8:
    # block 0x004fa4b8: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55ff84      # 004fa4b8
    jmp.d8 L_004fa510                            # 004fa4bf
L_004fa4c1:
    # block 0x004fa4c1: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x55ffc0      # 004fa4c1
    jmp.d8 L_004fa510                            # 004fa4c8
L_004fa4ca:
    # block 0x004fa4ca: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x560024      # 004fa4ca
    jmp.d8 L_004fa510                            # 004fa4d1
L_004fa4d3:
    # block 0x004fa4d3: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x560058      # 004fa4d3
    jmp.d8 L_004fa510                            # 004fa4da
L_004fa4dc:
    # block 0x004fa4dc: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x5600c0      # 004fa4dc
    jmp.d8 L_004fa510                            # 004fa4e3
L_004fa4e5:
    # block 0x004fa4e5: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x560120      # 004fa4e5
    jmp.d8 L_004fa510                            # 004fa4ec
L_004fa4ee:
    # block 0x004fa4ee: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x56016c      # 004fa4ee
    jmp.d8 L_004fa510                            # 004fa4f5
L_004fa4f7:
    # block 0x004fa4f7: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x5601b0      # 004fa4f7
    jmp.d8 L_004fa510                            # 004fa4fe
L_004fa500:
    # block 0x004fa500: entered by switch case, 2 instruction(s), ends with forward jump to 0x004fa510
    mov dword ptr [ebp - local_4], 0x560204      # 004fa500
    jmp.d8 L_004fa510                            # 004fa507
L_004fa509:
    # block 0x004fa509: entered by ja at 0x004fa2d7; switch case, 1 instruction(s), falls into the block at 0x004fa510
    mov dword ptr [ebp - local_4], 0x56024c      # 004fa509
L_004fa510:
    # block 0x004fa510: entered by jmp at 0x004fa2ee; jmp at 0x004fa2fa; jmp at 0x004fa306; jmp at 0x004fa312; more, 53 instruction(s), calls FUN_004fa658, FUN_0050ca3e, ends with ret
    mov edi, dword ptr [ebp - local_4]           # 004fa510
    mov edx, dword ptr [ebp - local_3c]          # 004fa513
    or ecx, -0x1                                 # 004fa516
    {load} xor eax, eax                          # 004fa519
    repne scasb al, byte ptr es:[edi]            # 004fa51b
    not ecx                                      # 004fa51d
    {load} sub edi, ecx                          # 004fa51f
    {load} mov esi, edi                          # 004fa521
    {load} mov eax, ecx                          # 004fa523
    {load} mov edi, edx                          # 004fa525
    shr ecx, 0x2                                 # 004fa527
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fa52a
    {load} mov ecx, eax                          # 004fa52c
    and ecx, 0x3                                 # 004fa52e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fa531
    mov ecx, dword ptr [ebp - local_3c]          # 004fa533
    mov edx, dword ptr [ecx + field_3ca]         # 004fa536
    push edx                                     # 004fa53c
    mov ecx, dword ptr [ebp - local_3c]          # 004fa53d
    call FUN_004fa658                            # 004fa540
    push eax                                     # 004fa545
    push 0x56026c                                # 004fa546
    lea eax, [ebp - local_38]                    # 004fa54b
    push eax                                     # 004fa54e
    call FUN_0050ca3e                            # 004fa54f
    add esp, 0xc                                 # 004fa554
    lea edi, [ebp - local_38]                    # 004fa557
    mov edx, dword ptr [ebp - local_3c]          # 004fa55a
    or ecx, -0x1                                 # 004fa55d
    {load} xor eax, eax                          # 004fa560
    repne scasb al, byte ptr es:[edi]            # 004fa562
    not ecx                                      # 004fa564
    {load} sub edi, ecx                          # 004fa566
    {load} mov esi, edi                          # 004fa568
    {load} mov ebx, ecx                          # 004fa56a
    {load} mov edi, edx                          # 004fa56c
    or ecx, -0x1                                 # 004fa56e
    {load} xor eax, eax                          # 004fa571
    repne scasb al, byte ptr es:[edi]            # 004fa573
    add edi, -0x1                                # 004fa575
    {load} mov ecx, ebx                          # 004fa578
    shr ecx, 0x2                                 # 004fa57a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fa57d
    {load} mov ecx, ebx                          # 004fa57f
    and ecx, 0x3                                 # 004fa581
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fa584
    mov eax, dword ptr [ebp - local_3c]          # 004fa586
    pop edi                                      # 004fa589
    pop esi                                      # 004fa58a
    pop ebx                                      # 004fa58b
    {load} mov esp, ebp                          # 004fa58c
    pop ebp                                      # 004fa58e
    ret                                          # 004fa58f

# --- data items (not part of the function) -------------------------
.org 0x004fa590 - 0x401000
SWTAB_004fa590:  # 50 case address(es)
    .long L_004fa2e7 - .text + 0x401000
    .long L_004fa2f3 - .text + 0x401000
    .long L_004fa2ff - .text + 0x401000
    .long L_004fa30b - .text + 0x401000
    .long L_004fa323 - .text + 0x401000
    .long L_004fa32f - .text + 0x401000
    .long L_004fa33b - .text + 0x401000
    .long L_004fa347 - .text + 0x401000
    .long L_004fa317 - .text + 0x401000
    .long L_004fa353 - .text + 0x401000
    .long L_004fa35f - .text + 0x401000
    .long L_004fa36b - .text + 0x401000
    .long L_004fa377 - .text + 0x401000
    .long L_004fa383 - .text + 0x401000
    .long L_004fa38f - .text + 0x401000
    .long L_004fa509 - .text + 0x401000
    .long L_004fa39b - .text + 0x401000
    .long L_004fa3a7 - .text + 0x401000
    .long L_004fa3b3 - .text + 0x401000
    .long L_004fa3bf - .text + 0x401000
    .long L_004fa3cb - .text + 0x401000
    .long L_004fa3d7 - .text + 0x401000
    .long L_004fa3e3 - .text + 0x401000
    .long L_004fa3ef - .text + 0x401000
    .long L_004fa407 - .text + 0x401000
    .long L_004fa413 - .text + 0x401000
    .long L_004fa41f - .text + 0x401000
    .long L_004fa42b - .text + 0x401000
    .long L_004fa3fb - .text + 0x401000
    .long L_004fa437 - .text + 0x401000
    .long L_004fa443 - .text + 0x401000
    .long L_004fa44f - .text + 0x401000
    .long L_004fa45b - .text + 0x401000
    .long L_004fa467 - .text + 0x401000
    .long L_004fa473 - .text + 0x401000
    .long L_004fa47f - .text + 0x401000
    .long L_004fa48b - .text + 0x401000
    .long L_004fa494 - .text + 0x401000
    .long L_004fa49d - .text + 0x401000
    .long L_004fa4a6 - .text + 0x401000
    .long L_004fa4af - .text + 0x401000
    .long L_004fa4b8 - .text + 0x401000
    .long L_004fa4c1 - .text + 0x401000
    .long L_004fa4ca - .text + 0x401000
    .long L_004fa4d3 - .text + 0x401000
    .long L_004fa4dc - .text + 0x401000
    .long L_004fa4e5 - .text + 0x401000
    .long L_004fa4ee - .text + 0x401000
    .long L_004fa4f7 - .text + 0x401000
    .long L_004fa500 - .text + 0x401000
.set SWTAB_004fa590_VA, SWTAB_004fa590 - .text + 0x401000

