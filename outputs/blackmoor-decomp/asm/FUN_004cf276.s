# FUN_004cf276
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf276
# extent:       0x004cf276-0x004cf687 (1041 code bytes)
# span:         0x004cf276-0x004cf687 (code 1041, tables 0, padding 0)
# sha256:       4bf55340965d6a0a2472e56fc25123c7b79d2e289962dcd85caa974023f7034b
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf276
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_6, field_1a, field_25, field_2f, field_31, field_222, field_22a; [ecx + n] field_a, field_12, field_1e, field_21, field_23, field_2d, field_222, field_226; [edx + n] field_2, field_e, field_16, field_21, field_23, field_25, field_29, field_222
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 276 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004cf276 - 0x401000
.globl FUN_004cf276
FUN_004cf276:
    # block 0x004cf276: entry, 7 instruction(s), ends with jne to 0x004cf28f (forward)
    push ebp                                     # 004cf276
    {load} mov ebp, esp                          # 004cf277
    sub esp, 0x1c                                # 004cf279
    mov dword ptr [ebp - local_1c], ecx          # 004cf27c
    movsx eax, word ptr [0x63a4cd]               # 004cf27f
    test eax, eax                                # 004cf286
    jne.d8 L_004cf28f                            # 004cf288
    # block 0x004cf28a: entered by fall-through of jne at 0x004cf288, 1 instruction(s), ends with forward jump to 0x004cf683
    jmp.d32 L_004cf683                           # 004cf28a
L_004cf28f:
    # block 0x004cf28f: entered by jne at 0x004cf288, 3 instruction(s), ends with je to 0x004cf683 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004cf28f
    cmp dword ptr [ecx + field_222], 0x0         # 004cf292
    je.d32 L_004cf683                            # 004cf299
    # block 0x004cf29f: entered by fall-through of je at 0x004cf299, 46 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004cf573 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004cf29f
    mov eax, dword ptr [edx + field_222]         # 004cf2a2
    push eax                                     # 004cf2a8
    push 0x559bcc                                # 004cf2a9
    push 0x63888b                                # 004cf2ae
    call FUN_0050ca3e                            # 004cf2b3
    add esp, 0xc                                 # 004cf2b8
    push 0x63888b                                # 004cf2bb
    call FUN_0044a2b7                            # 004cf2c0
    add esp, 0x4                                 # 004cf2c5
    mov ecx, dword ptr [ebp - local_1c]          # 004cf2c8
    mov edx, dword ptr [ecx + field_222]         # 004cf2cb
    movsx eax, word ptr [edx + field_21]         # 004cf2d1
    push eax                                     # 004cf2d5
    push 0x559be8                                # 004cf2d6
    push 0x63888b                                # 004cf2db
    call FUN_0050ca3e                            # 004cf2e0
    add esp, 0xc                                 # 004cf2e5
    push 0x63888b                                # 004cf2e8
    call FUN_0044a2b7                            # 004cf2ed
    add esp, 0x4                                 # 004cf2f2
    mov ecx, dword ptr [ebp - local_1c]          # 004cf2f5
    mov edx, dword ptr [ecx + field_222]         # 004cf2f8
    movsx eax, word ptr [edx + field_23]         # 004cf2fe
    push eax                                     # 004cf302
    push 0x559c04                                # 004cf303
    push 0x63888b                                # 004cf308
    call FUN_0050ca3e                            # 004cf30d
    add esp, 0xc                                 # 004cf312
    push 0x63888b                                # 004cf315
    call FUN_0044a2b7                            # 004cf31a
    add esp, 0x4                                 # 004cf31f
    mov ecx, dword ptr [ebp - local_1c]          # 004cf322
    mov edx, dword ptr [ecx + field_222]         # 004cf325
    movsx eax, word ptr [edx + field_25]         # 004cf32b
    push eax                                     # 004cf32f
    push 0x559c1c                                # 004cf330
    push 0x63888b                                # 004cf335
    call FUN_0050ca3e                            # 004cf33a
    add esp, 0xc                                 # 004cf33f
    push 0x63888b                                # 004cf342
    call FUN_0044a2b7                            # 004cf347
    add esp, 0x4                                 # 004cf34c
    mov ecx, dword ptr [ebp - local_1c]          # 004cf34f
    cmp dword ptr [ecx + field_226], 0x0         # 004cf352
    je.d32 L_004cf573                            # 004cf359
    # block 0x004cf35f: entered by fall-through of je at 0x004cf359, 2 instruction(s), ends with forward jump to 0x004cf371
    mov dword ptr [ebp - local_10], 0x0          # 004cf35f
    jmp.d8 L_004cf371                            # 004cf366
L_004cf368:
    # block 0x004cf368: entered by jmp at 0x004cf56e, 3 instruction(s), falls into the block at 0x004cf371
    mov edx, dword ptr [ebp - local_10]          # 004cf368
    add edx, 0x1                                 # 004cf36b
    mov dword ptr [ebp - local_10], edx          # 004cf36e
L_004cf371:
    # block 0x004cf371: entered by jmp at 0x004cf366, 5 instruction(s), ends with jge to 0x004cf573 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004cf371
    mov ecx, dword ptr [eax + field_222]         # 004cf374
    movsx edx, word ptr [ecx + field_23]         # 004cf37a
    cmp dword ptr [ebp - local_10], edx          # 004cf37e
    jge.d32 L_004cf573                           # 004cf381
    # block 0x004cf387: entered by fall-through of jge at 0x004cf381, 86 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with forward jump to 0x004cf4db
    mov eax, dword ptr [ebp - local_10]          # 004cf387
    imul eax, eax, 0x35                          # 004cf38a
    mov ecx, dword ptr [ebp - local_1c]          # 004cf38d
    mov edx, dword ptr [ecx + field_226]         # 004cf390
    {load} add edx, eax                          # 004cf396
    mov dword ptr [ebp - local_4], edx           # 004cf398
    mov eax, dword ptr [ebp - local_10]          # 004cf39b
    push eax                                     # 004cf39e
    push 0x559c38                                # 004cf39f
    push 0x63888b                                # 004cf3a4
    call FUN_0050ca3e                            # 004cf3a9
    add esp, 0xc                                 # 004cf3ae
    push 0x63888b                                # 004cf3b1
    call FUN_0044a2b7                            # 004cf3b6
    add esp, 0x4                                 # 004cf3bb
    mov ecx, dword ptr [ebp - local_4]           # 004cf3be
    push ecx                                     # 004cf3c1
    push 0x559c48                                # 004cf3c2
    push 0x63888b                                # 004cf3c7
    call FUN_0050ca3e                            # 004cf3cc
    add esp, 0xc                                 # 004cf3d1
    push 0x63888b                                # 004cf3d4
    call FUN_0044a2b7                            # 004cf3d9
    add esp, 0x4                                 # 004cf3de
    mov edx, dword ptr [ebp - local_4]           # 004cf3e1
    movsx eax, word ptr [edx + field_21]         # 004cf3e4
    push eax                                     # 004cf3e8
    push 0x559c60                                # 004cf3e9
    push 0x63888b                                # 004cf3ee
    call FUN_0050ca3e                            # 004cf3f3
    add esp, 0xc                                 # 004cf3f8
    push 0x63888b                                # 004cf3fb
    call FUN_0044a2b7                            # 004cf400
    add esp, 0x4                                 # 004cf405
    mov ecx, dword ptr [ebp - local_4]           # 004cf408
    movsx edx, word ptr [ecx + field_23]         # 004cf40b
    push edx                                     # 004cf40f
    push 0x559c74                                # 004cf410
    push 0x63888b                                # 004cf415
    call FUN_0050ca3e                            # 004cf41a
    add esp, 0xc                                 # 004cf41f
    push 0x63888b                                # 004cf422
    call FUN_0044a2b7                            # 004cf427
    add esp, 0x4                                 # 004cf42c
    mov eax, dword ptr [ebp - local_4]           # 004cf42f
    mov ecx, dword ptr [eax + field_25]          # 004cf432
    push ecx                                     # 004cf435
    push 0x559c88                                # 004cf436
    push 0x63888b                                # 004cf43b
    call FUN_0050ca3e                            # 004cf440
    add esp, 0xc                                 # 004cf445
    push 0x63888b                                # 004cf448
    call FUN_0044a2b7                            # 004cf44d
    add esp, 0x4                                 # 004cf452
    mov edx, dword ptr [ebp - local_4]           # 004cf455
    mov eax, dword ptr [edx + field_29]          # 004cf458
    push eax                                     # 004cf45b
    push 0x559ca4                                # 004cf45c
    push 0x63888b                                # 004cf461
    call FUN_0050ca3e                            # 004cf466
    add esp, 0xc                                 # 004cf46b
    push 0x63888b                                # 004cf46e
    call FUN_0044a2b7                            # 004cf473
    add esp, 0x4                                 # 004cf478
    mov ecx, dword ptr [ebp - local_4]           # 004cf47b
    movsx edx, word ptr [ecx + field_2d]         # 004cf47e
    push edx                                     # 004cf482
    push 0x559cc0                                # 004cf483
    push 0x63888b                                # 004cf488
    call FUN_0050ca3e                            # 004cf48d
    add esp, 0xc                                 # 004cf492
    push 0x63888b                                # 004cf495
    call FUN_0044a2b7                            # 004cf49a
    add esp, 0x4                                 # 004cf49f
    mov eax, dword ptr [ebp - local_4]           # 004cf4a2
    movsx ecx, word ptr [eax + field_2f]         # 004cf4a5
    push ecx                                     # 004cf4a9
    push 0x559cdc                                # 004cf4aa
    push 0x63888b                                # 004cf4af
    call FUN_0050ca3e                            # 004cf4b4
    add esp, 0xc                                 # 004cf4b9
    push 0x63888b                                # 004cf4bc
    call FUN_0044a2b7                            # 004cf4c1
    add esp, 0x4                                 # 004cf4c6
    mov dword ptr [ebp - local_14], 0x0          # 004cf4c9
    jmp.d8 L_004cf4db                            # 004cf4d0
L_004cf4d2:
    # block 0x004cf4d2: entered by jmp at 0x004cf569, 3 instruction(s), falls into the block at 0x004cf4db
    mov edx, dword ptr [ebp - local_14]          # 004cf4d2
    add edx, 0x1                                 # 004cf4d5
    mov dword ptr [ebp - local_14], edx          # 004cf4d8
L_004cf4db:
    # block 0x004cf4db: entered by jmp at 0x004cf4d0, 4 instruction(s), ends with jge to 0x004cf56e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cf4db
    movsx ecx, word ptr [eax + field_2f]         # 004cf4de
    cmp dword ptr [ebp - local_14], ecx          # 004cf4e2
    jge.d32 L_004cf56e                           # 004cf4e5
    # block 0x004cf4eb: entered by fall-through of jge at 0x004cf4e5, 35 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with backward jump to 0x004cf4d2
    mov edx, dword ptr [ebp - local_14]          # 004cf4eb
    imul edx, edx, 0x23                          # 004cf4ee
    mov eax, dword ptr [ebp - local_4]           # 004cf4f1
    mov ecx, dword ptr [eax + field_31]          # 004cf4f4
    {load} add ecx, edx                          # 004cf4f7
    mov dword ptr [ebp - local_c], ecx           # 004cf4f9
    mov edx, dword ptr [ebp - local_14]          # 004cf4fc
    push edx                                     # 004cf4ff
    push 0x559cf8                                # 004cf500
    push 0x63888b                                # 004cf505
    call FUN_0050ca3e                            # 004cf50a
    add esp, 0xc                                 # 004cf50f
    push 0x63888b                                # 004cf512
    call FUN_0044a2b7                            # 004cf517
    add esp, 0x4                                 # 004cf51c
    mov eax, dword ptr [ebp - local_c]           # 004cf51f
    push eax                                     # 004cf522
    push 0x559d04                                # 004cf523
    push 0x63888b                                # 004cf528
    call FUN_0050ca3e                            # 004cf52d
    add esp, 0xc                                 # 004cf532
    push 0x63888b                                # 004cf535
    call FUN_0044a2b7                            # 004cf53a
    add esp, 0x4                                 # 004cf53f
    mov ecx, dword ptr [ebp - local_c]           # 004cf542
    movsx edx, word ptr [ecx + field_21]         # 004cf545
    push edx                                     # 004cf549
    push 0x559d1c                                # 004cf54a
    push 0x63888b                                # 004cf54f
    call FUN_0050ca3e                            # 004cf554
    add esp, 0xc                                 # 004cf559
    push 0x63888b                                # 004cf55c
    call FUN_0044a2b7                            # 004cf561
    add esp, 0x4                                 # 004cf566
    jmp.d32 L_004cf4d2                           # 004cf569
L_004cf56e:
    # block 0x004cf56e: entered by jge at 0x004cf4e5, 1 instruction(s), ends with backward jump to 0x004cf368
    jmp.d32 L_004cf368                           # 004cf56e
L_004cf573:
    # block 0x004cf573: entered by je at 0x004cf359; jge at 0x004cf381, 3 instruction(s), ends with je to 0x004cf683 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004cf573
    cmp dword ptr [eax + field_22a], 0x0         # 004cf576
    je.d32 L_004cf683                            # 004cf57d
    # block 0x004cf583: entered by fall-through of je at 0x004cf57d, 2 instruction(s), ends with forward jump to 0x004cf595
    mov dword ptr [ebp - local_18], 0x0          # 004cf583
    jmp.d8 L_004cf595                            # 004cf58a
L_004cf58c:
    # block 0x004cf58c: entered by jmp at 0x004cf67e, 3 instruction(s), falls into the block at 0x004cf595
    mov ecx, dword ptr [ebp - local_18]          # 004cf58c
    add ecx, 0x1                                 # 004cf58f
    mov dword ptr [ebp - local_18], ecx          # 004cf592
L_004cf595:
    # block 0x004cf595: entered by jmp at 0x004cf58a, 5 instruction(s), ends with jge to 0x004cf683 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004cf595
    mov eax, dword ptr [edx + field_222]         # 004cf598
    movsx ecx, word ptr [eax + field_25]         # 004cf59e
    cmp dword ptr [ebp - local_18], ecx          # 004cf5a2
    jge.d32 L_004cf683                           # 004cf5a5
    # block 0x004cf5ab: entered by fall-through of jge at 0x004cf5a5, 64 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with backward jump to 0x004cf58c
    mov edx, dword ptr [ebp - local_18]          # 004cf5ab
    imul edx, edx, 0x22                          # 004cf5ae
    mov eax, dword ptr [ebp - local_1c]          # 004cf5b1
    mov ecx, dword ptr [eax + field_22a]         # 004cf5b4
    {load} add ecx, edx                          # 004cf5ba
    mov dword ptr [ebp - local_8], ecx           # 004cf5bc
    mov edx, dword ptr [ebp - local_18]          # 004cf5bf
    push edx                                     # 004cf5c2
    push 0x559d34                                # 004cf5c3
    push 0x63888b                                # 004cf5c8
    call FUN_0050ca3e                            # 004cf5cd
    add esp, 0xc                                 # 004cf5d2
    push 0x63888b                                # 004cf5d5
    call FUN_0044a2b7                            # 004cf5da
    add esp, 0x4                                 # 004cf5df
    mov eax, dword ptr [ebp - local_8]           # 004cf5e2
    movsx ecx, word ptr [eax]                    # 004cf5e5
    push ecx                                     # 004cf5e8
    push 0x559d44                                # 004cf5e9
    push 0x63888b                                # 004cf5ee
    call FUN_0050ca3e                            # 004cf5f3
    add esp, 0xc                                 # 004cf5f8
    push 0x63888b                                # 004cf5fb
    call FUN_0044a2b7                            # 004cf600
    add esp, 0x4                                 # 004cf605
    mov edx, dword ptr [ebp - local_8]           # 004cf608
    mov eax, dword ptr [edx + field_e]           # 004cf60b
    push eax                                     # 004cf60e
    mov ecx, dword ptr [ebp - local_8]           # 004cf60f
    mov edx, dword ptr [ecx + field_a]           # 004cf612
    push edx                                     # 004cf615
    mov eax, dword ptr [ebp - local_8]           # 004cf616
    mov ecx, dword ptr [eax + field_6]           # 004cf619
    push ecx                                     # 004cf61c
    mov edx, dword ptr [ebp - local_8]           # 004cf61d
    mov eax, dword ptr [edx + field_2]           # 004cf620
    push eax                                     # 004cf623
    push 0x559d54                                # 004cf624
    push 0x63888b                                # 004cf629
    call FUN_0050ca3e                            # 004cf62e
    add esp, 0x18                                # 004cf633
    push 0x63888b                                # 004cf636
    call FUN_0044a2b7                            # 004cf63b
    add esp, 0x4                                 # 004cf640
    mov ecx, dword ptr [ebp - local_8]           # 004cf643
    mov edx, dword ptr [ecx + field_1e]          # 004cf646
    push edx                                     # 004cf649
    mov eax, dword ptr [ebp - local_8]           # 004cf64a
    mov ecx, dword ptr [eax + field_1a]          # 004cf64d
    push ecx                                     # 004cf650
    mov edx, dword ptr [ebp - local_8]           # 004cf651
    mov eax, dword ptr [edx + field_16]          # 004cf654
    push eax                                     # 004cf657
    mov ecx, dword ptr [ebp - local_8]           # 004cf658
    mov edx, dword ptr [ecx + field_12]          # 004cf65b
    push edx                                     # 004cf65e
    push 0x559d74                                # 004cf65f
    push 0x63888b                                # 004cf664
    call FUN_0050ca3e                            # 004cf669
    add esp, 0x18                                # 004cf66e
    push 0x63888b                                # 004cf671
    call FUN_0044a2b7                            # 004cf676
    add esp, 0x4                                 # 004cf67b
    jmp.d32 L_004cf58c                           # 004cf67e
L_004cf683:
    # block 0x004cf683: entered by jmp at 0x004cf28a; je at 0x004cf299; je at 0x004cf57d; jge at 0x004cf5a5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cf683
    pop ebp                                      # 004cf685
    ret                                          # 004cf686

