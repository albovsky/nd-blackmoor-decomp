# FUN_00522451
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522451
# extent:       0x00522451-0x0052262c (475 code bytes)
# span:         0x00522451-0x0052262c (code 475, tables 0, padding 0)
# sha256:       157341bda093f57a92a586179a1e70923dea1e71a56f02e816526b803945b6d5
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522451
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_4; [esi + n] field_1c, field_80, field_84
# callees:      calls USER32.dll!GetDlgItem, FUN_0051a87c, FUN_00521de7, FUN_00520ed5, USER32.dll!MapDialogRect, USER32.dll!SetWindowPos, FUN_0051d5e1, FUN_0051ab4b, USER32.dll!ShowWindow, USER32.dll!EnableWindow, FUN_0051d526, FUN_0051cb6b; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 168 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0052262c
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
.equ local_2c, 0x2c  # offset -0x2c
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0051a87c, .text + (0x0051a87c - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051cb6b, .text + (0x0051cb6b - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)
.set FUN_00520ed5, .text + (0x00520ed5 - 0x401000)
.set FUN_00521de7, .text + (0x00521de7 - 0x401000)

.org 0x00522451 - 0x401000
.globl FUN_00522451
FUN_00522451:
    # block 0x00522451: entry, 9 instruction(s), ends with jne to 0x00522484 (forward)
    push ebp                                     # 00522451
    {load} mov ebp, esp                          # 00522452
    sub esp, 0x2c                                # 00522454
    push ebx                                     # 00522457
    push esi                                     # 00522458
    {load} mov esi, ecx                          # 00522459
    {load} xor ebx, ebx                          # 0052245b
    cmp dword ptr [esi + field_80], ebx          # 0052245d
    jne.d8 L_00522484                            # 00522463
    # block 0x00522465: entered by fall-through of jne at 0x00522463, 5 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x00522484 (forward)
    push 0x3020                                  # 00522465
    push dword ptr [esi + field_1c]              # 0052246a
    call dword ptr [0x52a404]                    # 0052246d
    {load} cmp eax, ebx                          # 00522473
    je.d8 L_00522484                             # 00522475
    # block 0x00522477: entered by fall-through of je at 0x00522475, 5 instruction(s), calls FUN_0051a87c, falls into the block at 0x00522484
    push ebx                                     # 00522477
    push ebx                                     # 00522478
    push 0x200                                   # 00522479
    push eax                                     # 0052247e
    call FUN_0051a87c                            # 0052247f
L_00522484:
    # block 0x00522484: entered by jne at 0x00522463; je at 0x00522475, 6 instruction(s), calls FUN_00521de7, ends with jne to 0x00522584 (forward)
    push edi                                     # 00522484
    {load} mov ecx, esi                          # 00522485
    call FUN_00521de7                            # 00522487
    test word ptr [eax + field_4], 0x2020        # 0052248c
    mov edi, dword ptr [0x52a46c]                # 00522492
    jne.d32 L_00522584                           # 00522498
    # block 0x0052249e: entered by fall-through of jne at 0x00522498, 23 instruction(s), calls USER32.dll!GetDlgItem, indirect edi, FUN_00520ed5, USER32.dll!MapDialogRect, ends with jge to 0x00522584 (forward)
    push 0x3020                                  # 0052249e
    push dword ptr [esi + field_1c]              # 005224a3
    call dword ptr [0x52a404]                    # 005224a6
    lea ecx, [ebp - local_1c]                    # 005224ac
    mov dword ptr [ebp - local_8], eax           # 005224af
    push ecx                                     # 005224b2
    push eax                                     # 005224b3
    call edi                                     # 005224b4
    lea eax, [ebp - local_1c]                    # 005224b6
    {load} mov ecx, esi                          # 005224b9
    push eax                                     # 005224bb
    call FUN_00520ed5                            # 005224bc
    lea eax, [ebp - local_2c]                    # 005224c1
    mov dword ptr [ebp - local_2c], ebx          # 005224c4
    push eax                                     # 005224c7
    mov dword ptr [ebp - local_28], ebx          # 005224c8
    push dword ptr [esi + field_1c]              # 005224cb
    mov dword ptr [ebp - local_24], ebx          # 005224ce
    mov dword ptr [ebp - local_20], 0x20         # 005224d1
    call dword ptr [0x52a358]                    # 005224d8
    mov eax, dword ptr [ebp - local_10]          # 005224de
    cmp dword ptr [ebp - local_20], eax          # 005224e1
    jge.d32 L_00522584                           # 005224e4
    # block 0x005224ea: entered by fall-through of jge at 0x005224e4, 14 instruction(s), calls USER32.dll!SetWindowPos, falls into the block at 0x00522512
    sub eax, dword ptr [ebp - local_18]          # 005224ea
    push 0x16                                    # 005224ed
    push dword ptr [ebp - local_20]              # 005224ef
    sub eax, dword ptr [ebp - local_20]          # 005224f2
    mov dword ptr [ebp - local_c], eax           # 005224f5
    mov eax, dword ptr [ebp - local_14]          # 005224f8
    sub eax, dword ptr [ebp - local_1c]          # 005224fb
    push eax                                     # 005224fe
    push ebx                                     # 005224ff
    push ebx                                     # 00522500
    push ebx                                     # 00522501
    push dword ptr [ebp - local_8]               # 00522502
    call dword ptr [0x52a45c]                    # 00522505
    mov dword ptr [ebp - local_4], 0x567948      # 0052250b
L_00522512:
    # block 0x00522512: entered by jl at 0x0052255c, 7 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x00522551 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00522512
    push dword ptr [eax]                         # 00522515
    push dword ptr [esi + field_1c]              # 00522517
    call dword ptr [0x52a404]                    # 0052251a
    {load} cmp eax, ebx                          # 00522520
    mov dword ptr [ebp - local_8], eax           # 00522522
    je.d8 L_00522551                             # 00522525
    # block 0x00522527: entered by fall-through of je at 0x00522525, 18 instruction(s), calls indirect edi, FUN_00520ed5, USER32.dll!SetWindowPos, falls into the block at 0x00522551
    lea ecx, [ebp - local_1c]                    # 00522527
    push ecx                                     # 0052252a
    push eax                                     # 0052252b
    call edi                                     # 0052252c
    lea eax, [ebp - local_1c]                    # 0052252e
    {load} mov ecx, esi                          # 00522531
    push eax                                     # 00522533
    call FUN_00520ed5                            # 00522534
    mov eax, dword ptr [ebp - local_18]          # 00522539
    push 0x15                                    # 0052253c
    sub eax, dword ptr [ebp - local_c]           # 0052253e
    push ebx                                     # 00522541
    push ebx                                     # 00522542
    push eax                                     # 00522543
    push dword ptr [ebp - local_1c]              # 00522544
    push ebx                                     # 00522547
    push dword ptr [ebp - local_8]               # 00522548
    call dword ptr [0x52a45c]                    # 0052254b
L_00522551:
    # block 0x00522551: entered by je at 0x00522525, 3 instruction(s), ends with jl to 0x00522512 (backward)
    add dword ptr [ebp - local_4], 0x4           # 00522551
    cmp dword ptr [ebp - local_4], 0x567958      # 00522555
    jl.d8 L_00522512                             # 0052255c
    # block 0x0052255e: entered by fall-through of jl at 0x0052255c, 17 instruction(s), calls indirect edi, FUN_0051d5e1, falls into the block at 0x00522584
    lea eax, [ebp - local_1c]                    # 0052255e
    push eax                                     # 00522561
    push dword ptr [esi + field_1c]              # 00522562
    call edi                                     # 00522565
    mov eax, dword ptr [ebp - local_10]          # 00522567
    push 0x16                                    # 0052256a
    sub eax, dword ptr [ebp - local_18]          # 0052256c
    {load} mov ecx, esi                          # 0052256f
    sub eax, dword ptr [ebp - local_c]           # 00522571
    push eax                                     # 00522574
    mov eax, dword ptr [ebp - local_14]          # 00522575
    sub eax, dword ptr [ebp - local_1c]          # 00522578
    push eax                                     # 0052257b
    push ebx                                     # 0052257c
    push ebx                                     # 0052257d
    push ebx                                     # 0052257e
    call FUN_0051d5e1                            # 0052257f
L_00522584:
    # block 0x00522584: entered by jne at 0x00522498; jge at 0x005224e4, 5 instruction(s), calls FUN_0051ab4b, ends with je to 0x0052260e (forward)
    {load} mov ecx, esi                          # 00522584
    call FUN_0051ab4b                            # 00522586
    cmp dword ptr [esi + field_84], ebx          # 0052258b
    mov dword ptr [ebp - local_8], eax           # 00522591
    je.d8 L_0052260e                             # 00522594
    # block 0x00522596: entered by fall-through of je at 0x00522594, 4 instruction(s), calls FUN_00521de7, ends with jne to 0x0052260e (forward)
    {load} mov ecx, esi                          # 00522596
    call FUN_00521de7                            # 00522598
    test word ptr [eax + field_4], 0x2020        # 0052259d
    jne.d8 L_0052260e                            # 005225a3
    # block 0x005225a5: entered by fall-through of jne at 0x005225a3, 24 instruction(s), calls indirect edi, USER32.dll!GetDlgItem, FUN_0051d5e1, falls into the block at 0x005225df
    lea eax, [ebp - local_2c]                    # 005225a5
    push eax                                     # 005225a8
    push dword ptr [esi + field_1c]              # 005225a9
    call edi                                     # 005225ac
    push 0x1                                     # 005225ae
    push dword ptr [esi + field_1c]              # 005225b0
    call dword ptr [0x52a404]                    # 005225b3
    lea ecx, [ebp - local_1c]                    # 005225b9
    push ecx                                     # 005225bc
    push eax                                     # 005225bd
    call edi                                     # 005225be
    mov eax, dword ptr [ebp - local_18]          # 005225c0
    push 0x16                                    # 005225c3
    sub eax, dword ptr [ebp - local_28]          # 005225c5
    {load} mov ecx, esi                          # 005225c8
    push eax                                     # 005225ca
    mov eax, dword ptr [ebp - local_24]          # 005225cb
    sub eax, dword ptr [ebp - local_2c]          # 005225ce
    push eax                                     # 005225d1
    push ebx                                     # 005225d2
    push ebx                                     # 005225d3
    push ebx                                     # 005225d4
    call FUN_0051d5e1                            # 005225d5
    mov edi, 0x567948                            # 005225da
L_005225df:
    # block 0x005225df: entered by jl at 0x0052260c, 6 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x00522603 (forward)
    push dword ptr [edi]                         # 005225df
    push dword ptr [esi + field_1c]              # 005225e1
    call dword ptr [0x52a404]                    # 005225e4
    {load} cmp eax, ebx                          # 005225ea
    mov dword ptr [ebp - local_c], eax           # 005225ec
    je.d8 L_00522603                             # 005225ef
    # block 0x005225f1: entered by fall-through of je at 0x005225ef, 6 instruction(s), calls USER32.dll!ShowWindow, USER32.dll!EnableWindow, falls into the block at 0x00522603
    push ebx                                     # 005225f1
    push eax                                     # 005225f2
    call dword ptr [0x52a32c]                    # 005225f3
    push ebx                                     # 005225f9
    push dword ptr [ebp - local_c]               # 005225fa
    call dword ptr [0x52a4d0]                    # 005225fd
L_00522603:
    # block 0x00522603: entered by je at 0x005225ef, 3 instruction(s), ends with jl to 0x005225df (backward)
    add edi, 0x4                                 # 00522603
    cmp edi, 0x567958                            # 00522606
    jl.d8 L_005225df                             # 0052260c
L_0052260e:
    # block 0x0052260e: entered by je at 0x00522594; jne at 0x005225a3; fall-through of jl at 0x0052260c, 5 instruction(s), calls FUN_0051d526, ends with jne to 0x00522625 (forward)
    {load} mov ecx, esi                          # 0052260e
    call FUN_0051d526                            # 00522610
    test eax, 0x40000000                         # 00522615
    pop edi                                      # 0052261a
    jne.d8 L_00522625                            # 0052261b
    # block 0x0052261d: entered by fall-through of jne at 0x0052261b, 3 instruction(s), calls FUN_0051cb6b, falls into the block at 0x00522625
    push ebx                                     # 0052261d
    {load} mov ecx, esi                          # 0052261e
    call FUN_0051cb6b                            # 00522620
L_00522625:
    # block 0x00522625: entered by jne at 0x0052261b, 5 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 00522625
    pop esi                                      # 00522628
    pop ebx                                      # 00522629
    leave                                        # 0052262a
    ret                                          # 0052262b

