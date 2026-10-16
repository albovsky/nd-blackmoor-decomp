# FUN_004cc3bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc3bd
# extent:       0x004cc3bd-0x004cc70f (850 code bytes)
# span:         0x004cc3bd-0x004cc70f (code 850, tables 0, padding 0)
# sha256:       fbcec2f94e2281dcefa720a1a8194cd29da5b4f8495514a61791d98029ab1f13
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cc3bd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2, field_9, field_1a, field_122, field_12a, field_12e; [ecx + n] field_1a, field_21, field_122, field_12a, field_12e; [edx + n] field_1a, field_25, field_122, field_12a, field_12e
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0050e493, FUN_0050cee4, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 248 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_9, 0x9  # offset +0x9
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_122, 0x122  # offset +0x122
.equ field_12a, 0x12a  # offset +0x12a
.equ field_12e, 0x12e  # offset +0x12e

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)

.org 0x004cc3bd - 0x401000
.globl FUN_004cc3bd
FUN_004cc3bd:
    # block 0x004cc3bd: entry, 7 instruction(s), ends with jne to 0x004cc3e4 (forward)
    push ebp                                     # 004cc3bd
    {load} mov ebp, esp                          # 004cc3be
    push ecx                                     # 004cc3c0
    mov dword ptr [ebp - local_4], ecx           # 004cc3c1
    mov eax, dword ptr [ebp - local_4]           # 004cc3c4
    cmp dword ptr [eax + field_1a], 0x0          # 004cc3c7
    jne.d8 L_004cc3e4                            # 004cc3cb
    # block 0x004cc3cd: entered by fall-through of jne at 0x004cc3cb, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cc709
    push 0x558e44                                # 004cc3cd
    push 0x63888b                                # 004cc3d2
    call FUN_0050ca3e                            # 004cc3d7
    add esp, 0x8                                 # 004cc3dc
    jmp.d32 L_004cc709                           # 004cc3df
L_004cc3e4:
    # block 0x004cc3e4: entered by jne at 0x004cc3cb, 2 instruction(s), ends with je to 0x004cc412 (forward)
    cmp dword ptr [0x5bb1fa], 0x0                # 004cc3e4
    je.d8 L_004cc412                             # 004cc3eb
    # block 0x004cc3ed: entered by fall-through of je at 0x004cc3eb, 10 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x004cc435
    push 0x558e90                                # 004cc3ed
    push 0x558e94                                # 004cc3f2
    push 0x639db1                                # 004cc3f7
    push 0x639da2                                # 004cc3fc
    mov ecx, dword ptr [ebp - local_4]           # 004cc401
    add ecx, 0x1e                                # 004cc404
    push ecx                                     # 004cc407
    call FUN_0050cd72                            # 004cc408
    add esp, 0x14                                # 004cc40d
    jmp.d8 L_004cc435                            # 004cc410
L_004cc412:
    # block 0x004cc412: entered by je at 0x004cc3eb, 9 instruction(s), calls FUN_0050cd72, falls into the block at 0x004cc435
    push 0x558e9c                                # 004cc412
    push 0x558ea0                                # 004cc417
    push 0x639db1                                # 004cc41c
    push 0x639dae                                # 004cc421
    mov edx, dword ptr [ebp - local_4]           # 004cc426
    add edx, 0x1e                                # 004cc429
    push edx                                     # 004cc42c
    call FUN_0050cd72                            # 004cc42d
    add esp, 0x14                                # 004cc432
L_004cc435:
    # block 0x004cc435: entered by jmp at 0x004cc410, 13 instruction(s), calls FUN_0050d0a9, ends with jne to 0x004cc489 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc435
    mov dword ptr [eax + field_12a], 0x0         # 004cc438
    push 0x558ea8                                # 004cc442
    mov ecx, dword ptr [ebp - local_4]           # 004cc447
    add ecx, 0x1e                                # 004cc44a
    push ecx                                     # 004cc44d
    call FUN_0050d0a9                            # 004cc44e
    add esp, 0x8                                 # 004cc453
    mov edx, dword ptr [ebp - local_4]           # 004cc456
    mov dword ptr [edx + field_12a], eax         # 004cc459
    mov eax, dword ptr [ebp - local_4]           # 004cc45f
    cmp dword ptr [eax + field_12a], 0x0         # 004cc462
    jne.d8 L_004cc489                            # 004cc469
    # block 0x004cc46b: entered by fall-through of jne at 0x004cc469, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cc707
    mov ecx, dword ptr [ebp - local_4]           # 004cc46b
    add ecx, 0x1e                                # 004cc46e
    push ecx                                     # 004cc471
    push 0x558eac                                # 004cc472
    push 0x63888b                                # 004cc477
    call FUN_0050ca3e                            # 004cc47c
    add esp, 0xc                                 # 004cc481
    jmp.d32 L_004cc707                           # 004cc484
L_004cc489:
    # block 0x004cc489: entered by jne at 0x004cc469, 12 instruction(s), calls FUN_0050e493, ends with jne to 0x004cc4d0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cc489
    mov eax, dword ptr [edx + field_12a]         # 004cc48c
    push eax                                     # 004cc492
    push 0x1                                     # 004cc493
    push 0x21                                    # 004cc495
    mov ecx, dword ptr [ebp - local_4]           # 004cc497
    mov edx, dword ptr [ecx + field_1a]          # 004cc49a
    push edx                                     # 004cc49d
    call FUN_0050e493                            # 004cc49e
    add esp, 0x10                                # 004cc4a3
    cmp eax, 0x1                                 # 004cc4a6
    jne.d8 L_004cc4d0                            # 004cc4a9
    # block 0x004cc4ab: entered by fall-through of jne at 0x004cc4a9, 13 instruction(s), calls FUN_0050e493, ends with je to 0x004cc4ee (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc4ab
    mov ecx, dword ptr [eax + field_12a]         # 004cc4ae
    push ecx                                     # 004cc4b4
    push 0x1                                     # 004cc4b5
    push 0x4                                     # 004cc4b7
    mov edx, dword ptr [ebp - local_4]           # 004cc4b9
    mov eax, dword ptr [edx + field_1a]          # 004cc4bc
    add eax, 0x21                                # 004cc4bf
    push eax                                     # 004cc4c2
    call FUN_0050e493                            # 004cc4c3
    add esp, 0x10                                # 004cc4c8
    cmp eax, 0x1                                 # 004cc4cb
    je.d8 L_004cc4ee                             # 004cc4ce
L_004cc4d0:
    # block 0x004cc4d0: entered by jne at 0x004cc4a9; fall-through of je at 0x004cc4ce, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cc705
    mov ecx, dword ptr [ebp - local_4]           # 004cc4d0
    add ecx, 0x1e                                # 004cc4d3
    push ecx                                     # 004cc4d6
    push 0x558efc                                # 004cc4d7
    push 0x63888b                                # 004cc4dc
    call FUN_0050ca3e                            # 004cc4e1
    add esp, 0xc                                 # 004cc4e6
    jmp.d32 L_004cc705                           # 004cc4e9
L_004cc4ee:
    # block 0x004cc4ee: entered by je at 0x004cc4ce, 3 instruction(s), ends with forward jump to 0x004cc512
    mov edx, dword ptr [ebp - local_4]           # 004cc4ee
    mov dword ptr [edx + field_12e], 0x0         # 004cc4f1
    jmp.d8 L_004cc512                            # 004cc4fb
L_004cc4fd:
    # block 0x004cc4fd: entered by jmp at 0x004cc697, 5 instruction(s), falls into the block at 0x004cc512
    mov eax, dword ptr [ebp - local_4]           # 004cc4fd
    mov ecx, dword ptr [eax + field_12e]         # 004cc500
    add ecx, 0x1                                 # 004cc506
    mov edx, dword ptr [ebp - local_4]           # 004cc509
    mov dword ptr [edx + field_12e], ecx         # 004cc50c
L_004cc512:
    # block 0x004cc512: entered by jmp at 0x004cc4fb, 6 instruction(s), ends with jge to 0x004cc69c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc512
    mov ecx, dword ptr [eax + field_1a]          # 004cc515
    mov edx, dword ptr [ebp - local_4]           # 004cc518
    mov eax, dword ptr [edx + field_12e]         # 004cc51b
    cmp eax, dword ptr [ecx + field_21]          # 004cc521
    jge.d32 L_004cc69c                           # 004cc524
    # block 0x004cc52a: entered by fall-through of jge at 0x004cc524, 21 instruction(s), calls FUN_0050e493, ends with jne to 0x004cc613 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cc52a
    mov edx, dword ptr [ecx + field_1a]          # 004cc52d
    mov eax, dword ptr [ebp - local_4]           # 004cc530
    mov ecx, dword ptr [eax + field_12e]         # 004cc533
    imul ecx, ecx, 0xd                           # 004cc539
    mov edx, dword ptr [edx + field_25]          # 004cc53c
    {load} add edx, ecx                          # 004cc53f
    mov eax, dword ptr [ebp - local_4]           # 004cc541
    mov dword ptr [eax + field_122], edx         # 004cc544
    mov ecx, dword ptr [ebp - local_4]           # 004cc54a
    mov edx, dword ptr [ecx + field_12a]         # 004cc54d
    push edx                                     # 004cc553
    push 0x1                                     # 004cc554
    push 0x2                                     # 004cc556
    mov eax, dword ptr [ebp - local_4]           # 004cc558
    mov ecx, dword ptr [eax + field_122]         # 004cc55b
    push ecx                                     # 004cc561
    call FUN_0050e493                            # 004cc562
    add esp, 0x10                                # 004cc567
    cmp eax, 0x1                                 # 004cc56a
    jne.d32 L_004cc613                           # 004cc56d
    # block 0x004cc573: entered by fall-through of jne at 0x004cc56d, 13 instruction(s), calls FUN_0050e493, ends with jne to 0x004cc613 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cc573
    mov eax, dword ptr [edx + field_12a]         # 004cc576
    push eax                                     # 004cc57c
    push 0x1                                     # 004cc57d
    push 0x2                                     # 004cc57f
    mov ecx, dword ptr [ebp - local_4]           # 004cc581
    mov edx, dword ptr [ecx + field_122]         # 004cc584
    add edx, 0x2                                 # 004cc58a
    push edx                                     # 004cc58d
    call FUN_0050e493                            # 004cc58e
    add esp, 0x10                                # 004cc593
    cmp eax, 0x1                                 # 004cc596
    jne.d8 L_004cc613                            # 004cc599
    # block 0x004cc59b: entered by fall-through of jne at 0x004cc599, 13 instruction(s), calls FUN_0050e493, ends with jne to 0x004cc613 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc59b
    mov ecx, dword ptr [eax + field_12a]         # 004cc59e
    push ecx                                     # 004cc5a4
    push 0x1                                     # 004cc5a5
    push 0x1                                     # 004cc5a7
    mov edx, dword ptr [ebp - local_4]           # 004cc5a9
    mov eax, dword ptr [edx + field_122]         # 004cc5ac
    add eax, 0x4                                 # 004cc5b2
    push eax                                     # 004cc5b5
    call FUN_0050e493                            # 004cc5b6
    add esp, 0x10                                # 004cc5bb
    cmp eax, 0x1                                 # 004cc5be
    jne.d8 L_004cc613                            # 004cc5c1
    # block 0x004cc5c3: entered by fall-through of jne at 0x004cc5c1, 13 instruction(s), calls FUN_0050e493, ends with jne to 0x004cc613 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cc5c3
    mov edx, dword ptr [ecx + field_12a]         # 004cc5c6
    push edx                                     # 004cc5cc
    push 0x1                                     # 004cc5cd
    push 0x2                                     # 004cc5cf
    mov eax, dword ptr [ebp - local_4]           # 004cc5d1
    mov ecx, dword ptr [eax + field_122]         # 004cc5d4
    add ecx, 0x5                                 # 004cc5da
    push ecx                                     # 004cc5dd
    call FUN_0050e493                            # 004cc5de
    add esp, 0x10                                # 004cc5e3
    cmp eax, 0x1                                 # 004cc5e6
    jne.d8 L_004cc613                            # 004cc5e9
    # block 0x004cc5eb: entered by fall-through of jne at 0x004cc5e9, 13 instruction(s), calls FUN_0050e493, ends with je to 0x004cc63b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cc5eb
    mov eax, dword ptr [edx + field_12a]         # 004cc5ee
    push eax                                     # 004cc5f4
    push 0x1                                     # 004cc5f5
    push 0x2                                     # 004cc5f7
    mov ecx, dword ptr [ebp - local_4]           # 004cc5f9
    mov edx, dword ptr [ecx + field_122]         # 004cc5fc
    add edx, 0x7                                 # 004cc602
    push edx                                     # 004cc605
    call FUN_0050e493                            # 004cc606
    add esp, 0x10                                # 004cc60b
    cmp eax, 0x1                                 # 004cc60e
    je.d8 L_004cc63b                             # 004cc611
L_004cc613:
    # block 0x004cc613: entered by jne at 0x004cc56d; jne at 0x004cc599; jne at 0x004cc5c1; jne at 0x004cc5e9; more, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cc703
    mov eax, dword ptr [ebp - local_4]           # 004cc613
    add eax, 0x1e                                # 004cc616
    push eax                                     # 004cc619
    mov ecx, dword ptr [ebp - local_4]           # 004cc61a
    mov edx, dword ptr [ecx + field_12e]         # 004cc61d
    push edx                                     # 004cc623
    push 0x558f6c                                # 004cc624
    push 0x63888b                                # 004cc629
    call FUN_0050ca3e                            # 004cc62e
    add esp, 0x10                                # 004cc633
    jmp.d32 L_004cc703                           # 004cc636
L_004cc63b:
    # block 0x004cc63b: entered by je at 0x004cc611, 17 instruction(s), calls FUN_0050e493, ends with je to 0x004cc697 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cc63b
    mov ecx, dword ptr [eax + field_12a]         # 004cc63e
    push ecx                                     # 004cc644
    push 0x1                                     # 004cc645
    mov edx, dword ptr [ebp - local_4]           # 004cc647
    mov eax, dword ptr [edx + field_122]         # 004cc64a
    movsx ecx, word ptr [eax + field_2]          # 004cc650
    imul ecx, ecx, 0x18                          # 004cc654
    push ecx                                     # 004cc657
    mov edx, dword ptr [ebp - local_4]           # 004cc658
    mov eax, dword ptr [edx + field_122]         # 004cc65b
    mov ecx, dword ptr [eax + field_9]           # 004cc661
    push ecx                                     # 004cc664
    call FUN_0050e493                            # 004cc665
    add esp, 0x10                                # 004cc66a
    cmp eax, 0x1                                 # 004cc66d
    je.d8 L_004cc697                             # 004cc670
    # block 0x004cc672: entered by fall-through of je at 0x004cc670, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004cc701
    mov edx, dword ptr [ebp - local_4]           # 004cc672
    add edx, 0x1e                                # 004cc675
    push edx                                     # 004cc678
    mov eax, dword ptr [ebp - local_4]           # 004cc679
    mov ecx, dword ptr [eax + field_12e]         # 004cc67c
    push ecx                                     # 004cc682
    push 0x558fd0                                # 004cc683
    push 0x63888b                                # 004cc688
    call FUN_0050ca3e                            # 004cc68d
    add esp, 0x10                                # 004cc692
    jmp.d8 L_004cc701                            # 004cc695
L_004cc697:
    # block 0x004cc697: entered by je at 0x004cc670, 1 instruction(s), ends with backward jump to 0x004cc4fd
    jmp.d32 L_004cc4fd                           # 004cc697
L_004cc69c:
    # block 0x004cc69c: entered by jge at 0x004cc524, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x004cc70b
    mov edx, dword ptr [ebp - local_4]           # 004cc69c
    mov eax, dword ptr [edx + field_12a]         # 004cc69f
    push eax                                     # 004cc6a5
    call FUN_0050cee4                            # 004cc6a6
    add esp, 0x4                                 # 004cc6ab
    jmp.d8 L_004cc70b                            # 004cc6ae
L_004cc6b0:
    # block 0x004cc6b0: entered by jmp at 0x004cc701; jmp at 0x004cc703; jmp at 0x004cc705; jmp at 0x004cc707; more, 6 instruction(s), calls FUN_004264e8, ends with je to 0x004cc6d7 (forward)
    push 0x63888b                                # 004cc6b0
    mov ecx, 0x583979                            # 004cc6b5
    call FUN_004264e8                            # 004cc6ba
    movsx ecx, word ptr [0x63a4cd]               # 004cc6bf
    test ecx, ecx                                # 004cc6c6
    je.d8 L_004cc6d7                             # 004cc6c8
    # block 0x004cc6ca: entered by fall-through of je at 0x004cc6c8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cc6d7
    push 0x63888b                                # 004cc6ca
    call FUN_0044a2b7                            # 004cc6cf
    add esp, 0x4                                 # 004cc6d4
L_004cc6d7:
    # block 0x004cc6d7: entered by je at 0x004cc6c8, 3 instruction(s), ends with je to 0x004cc6f5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cc6d7
    cmp dword ptr [edx + field_12a], 0x0         # 004cc6da
    je.d8 L_004cc6f5                             # 004cc6e1
    # block 0x004cc6e3: entered by fall-through of je at 0x004cc6e1, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x004cc6f5
    mov eax, dword ptr [ebp - local_4]           # 004cc6e3
    mov ecx, dword ptr [eax + field_12a]         # 004cc6e6
    push ecx                                     # 004cc6ec
    call FUN_0050cee4                            # 004cc6ed
    add esp, 0x4                                 # 004cc6f2
L_004cc6f5:
    # block 0x004cc6f5: entered by je at 0x004cc6e1, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cc70b
    mov ecx, 0x5cf659                            # 004cc6f5
    call FUN_004c97b4                            # 004cc6fa
    jmp.d8 L_004cc70b                            # 004cc6ff
L_004cc701:
    # block 0x004cc701: entered by jmp at 0x004cc695, 1 instruction(s), ends with backward jump to 0x004cc6b0
    jmp.d8 L_004cc6b0                            # 004cc701
L_004cc703:
    # block 0x004cc703: entered by jmp at 0x004cc636, 1 instruction(s), ends with backward jump to 0x004cc6b0
    jmp.d8 L_004cc6b0                            # 004cc703
L_004cc705:
    # block 0x004cc705: entered by jmp at 0x004cc4e9, 1 instruction(s), ends with backward jump to 0x004cc6b0
    jmp.d8 L_004cc6b0                            # 004cc705
L_004cc707:
    # block 0x004cc707: entered by jmp at 0x004cc484, 1 instruction(s), ends with backward jump to 0x004cc6b0
    jmp.d8 L_004cc6b0                            # 004cc707
L_004cc709:
    # block 0x004cc709: entered by jmp at 0x004cc3df, 1 instruction(s), ends with backward jump to 0x004cc6b0
    jmp.d8 L_004cc6b0                            # 004cc709
L_004cc70b:
    # block 0x004cc70b: entered by jmp at 0x004cc6ae; jmp at 0x004cc6ff, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cc70b
    pop ebp                                      # 004cc70d
    ret                                          # 004cc70e

