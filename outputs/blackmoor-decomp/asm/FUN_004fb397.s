# FUN_004fb397
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb397
# extent:       0x004fb397-0x004fb737 (928 code bytes)
# span:         0x004fb397-0x004fb737 (code 928, tables 0, padding 0)
# sha256:       897ead32515ca48cb3ae4731fb4aafdef671fa2d78b66a57f7e8514348b3b85c
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb397
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 7 more
# fields:       [eax + n] field_132, field_138; [ecx + n] field_134, field_13c, field_16a; [edx + n] field_130, field_138, field_13c
# callees:      calls FUN_0044a2b7, FUN_004fc05d, FUN_004fc62d, FUN_0050ca3e, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 220 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ field_130, 0x130  # offset +0x130
.equ field_132, 0x132  # offset +0x132
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc05d, .text + (0x004fc05d - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fb397 - 0x401000
.globl FUN_004fb397
FUN_004fb397:
    # block 0x004fb397: entry, 7 instruction(s), ends with je to 0x004fb3b8 (forward)
    push ebp                                     # 004fb397
    {load} mov ebp, esp                          # 004fb398
    sub esp, 0x4c                                # 004fb39a
    mov dword ptr [ebp - local_c], ecx           # 004fb39d
    movsx eax, word ptr [0x63a4cd]               # 004fb3a0
    test eax, eax                                # 004fb3a7
    je.d8 L_004fb3b8                             # 004fb3a9
    # block 0x004fb3ab: entered by fall-through of je at 0x004fb3a9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fb3b8
    push 0x5607f0                                # 004fb3ab
    call FUN_0044a2b7                            # 004fb3b0
    add esp, 0x4                                 # 004fb3b5
L_004fb3b8:
    # block 0x004fb3b8: entered by je at 0x004fb3a9, 4 instruction(s), calls FUN_004fc05d, ends with forward jump to 0x004fb3d4
    mov ecx, dword ptr [ebp - local_c]           # 004fb3b8
    call FUN_004fc05d                            # 004fb3bb
    mov word ptr [ebp - local_4], 0x0            # 004fb3c0
    jmp.d8 L_004fb3d4                            # 004fb3c6
L_004fb3c8:
    # block 0x004fb3c8: entered by jmp at 0x004fb6c9, 3 instruction(s), falls into the block at 0x004fb3d4
    mov cx, word ptr [ebp - local_4]             # 004fb3c8
    add cx, 0x1                                  # 004fb3cc
    mov word ptr [ebp - local_4], cx             # 004fb3d0
L_004fb3d4:
    # block 0x004fb3d4: entered by jmp at 0x004fb3c6, 3 instruction(s), ends with jge to 0x004fb6ce (forward)
    movsx edx, word ptr [ebp - local_4]          # 004fb3d4
    cmp edx, 0x3                                 # 004fb3d8
    jge.d32 L_004fb6ce                           # 004fb3db
    # block 0x004fb3e1: entered by fall-through of jge at 0x004fb3db, 67 instruction(s), ends with je to 0x004fb52a (forward)
    movsx eax, word ptr [ebp - local_4]          # 004fb3e1
    imul eax, eax, 0x2f                          # 004fb3e5
    mov cx, word ptr [eax + 0x583381]            # 004fb3e8
    mov word ptr [ebp - local_8], cx             # 004fb3ef
    movsx edx, word ptr [ebp - local_4]          # 004fb3f3
    imul edx, edx, 0x2f                          # 004fb3f7
    mov eax, dword ptr [ebp - local_8]           # 004fb3fa
    and eax, 0xffff                              # 004fb3fd
    imul eax, eax, 0x5bb                         # 004fb402
    mov ecx, dword ptr [ebp - local_c]           # 004fb408
    mov edx, dword ptr [edx + 0x583387]          # 004fb40b
    mov dword ptr [ecx + eax + field_134], edx   # 004fb411
    movsx eax, word ptr [ebp - local_4]          # 004fb418
    imul eax, eax, 0x2f                          # 004fb41c
    movsx ecx, word ptr [eax + 0x58338b]         # 004fb41f
    mov dword ptr [ebp - local_10], ecx          # 004fb426
    fild dword ptr [ebp - local_10]              # 004fb429
    fstp dword ptr [ebp - local_14]              # 004fb42c
    fld dword ptr [ebp - local_14]               # 004fb42f
    fdiv dword ptr [0x52cbec]                    # 004fb432
    mov edx, dword ptr [ebp - local_8]           # 004fb438
    and edx, 0xffff                              # 004fb43b
    imul edx, edx, 0x5bb                         # 004fb441
    mov eax, dword ptr [ebp - local_c]           # 004fb447
    fstp dword ptr [eax + edx + field_138]       # 004fb44a
    movsx ecx, word ptr [ebp - local_4]          # 004fb451
    imul ecx, ecx, 0x2f                          # 004fb455
    movsx edx, word ptr [ecx + 0x58338d]         # 004fb458
    mov dword ptr [ebp - local_18], edx          # 004fb45f
    fild dword ptr [ebp - local_18]              # 004fb462
    fstp dword ptr [ebp - local_1c]              # 004fb465
    fld dword ptr [ebp - local_1c]               # 004fb468
    fdiv dword ptr [0x52cbec]                    # 004fb46b
    mov eax, dword ptr [ebp - local_8]           # 004fb471
    and eax, 0xffff                              # 004fb474
    imul eax, eax, 0x5bb                         # 004fb479
    mov ecx, dword ptr [ebp - local_c]           # 004fb47f
    fstp dword ptr [ecx + eax + field_13c]       # 004fb482
    mov edx, dword ptr [ebp - local_8]           # 004fb489
    and edx, 0xffff                              # 004fb48c
    imul edx, edx, 0x5bb                         # 004fb492
    mov eax, dword ptr [ebp - local_c]           # 004fb498
    mov word ptr [eax + edx + field_132], 0x0    # 004fb49b
    mov ecx, dword ptr [ebp - local_8]           # 004fb4a5
    and ecx, 0xffff                              # 004fb4a8
    imul ecx, ecx, 0x5bb                         # 004fb4ae
    mov edx, dword ptr [ebp - local_c]           # 004fb4b4
    mov word ptr [edx + ecx + field_130], 0x1    # 004fb4b7
    movsx eax, word ptr [ebp - local_4]          # 004fb4c1
    imul eax, eax, 0x2f                          # 004fb4c5
    movsx ecx, word ptr [eax + 0x583385]         # 004fb4c8
    {load} xor edx, edx                          # 004fb4cf
    cmp ecx, 0x2                                 # 004fb4d1
    sete dl                                      # 004fb4d4
    mov eax, dword ptr [ebp - local_8]           # 004fb4d7
    and eax, 0xffff                              # 004fb4da
    imul eax, eax, 0x5bb                         # 004fb4df
    mov ecx, dword ptr [ebp - local_c]           # 004fb4e5
    mov dword ptr [ecx + eax + field_16a], edx   # 004fb4e8
    mov edx, dword ptr [ebp - local_8]           # 004fb4ef
    and edx, 0xffff                              # 004fb4f2
    imul edx, edx, 0x5bb                         # 004fb4f8
    fld dword ptr [edx + 0x5c3b9f]               # 004fb4fe
    fcomp qword ptr [0x52c598]                   # 004fb504
    fnstsw ax                                    # 004fb50a
    test ah, 0x1                                 # 004fb50c
    je.d8 L_004fb52a                             # 004fb50f
    # block 0x004fb511: entered by fall-through of je at 0x004fb50f, 6 instruction(s), ends with forward jump to 0x004fb538
    mov eax, dword ptr [ebp - local_8]           # 004fb511
    and eax, 0xffff                              # 004fb514
    imul eax, eax, 0x5bb                         # 004fb519
    fld dword ptr [eax + 0x5c3b9f]               # 004fb51f
    fstp qword ptr [ebp - local_24]              # 004fb525
    jmp.d8 L_004fb538                            # 004fb528
L_004fb52a:
    # block 0x004fb52a: entered by je at 0x004fb50f, 2 instruction(s), falls into the block at 0x004fb538
    mov dword ptr [ebp - local_24], 0x0          # 004fb52a
    mov dword ptr [ebp - local_20], 0x3ff00000   # 004fb531
L_004fb538:
    # block 0x004fb538: entered by jmp at 0x004fb528, 16 instruction(s), ends with jne to 0x004fb595 (forward)
    fld qword ptr [ebp - local_24]               # 004fb538
    fstp dword ptr [ebp - local_28]              # 004fb53b
    fld dword ptr [ebp - local_28]               # 004fb53e
    mov ecx, dword ptr [ebp - local_8]           # 004fb541
    and ecx, 0xffff                              # 004fb544
    imul ecx, ecx, 0x5bb                         # 004fb54a
    mov edx, dword ptr [ebp - local_c]           # 004fb550
    fstp dword ptr [edx + ecx + field_138]       # 004fb553
    mov eax, dword ptr [ebp - local_8]           # 004fb55a
    and eax, 0xffff                              # 004fb55d
    imul eax, eax, 0x5bb                         # 004fb562
    fld dword ptr [eax + 0x5c3b9f]               # 004fb568
    fcomp qword ptr [0x52c7b0]                   # 004fb56e
    fnstsw ax                                    # 004fb574
    test ah, 0x41                                # 004fb576
    jne.d8 L_004fb595                            # 004fb579
    # block 0x004fb57b: entered by fall-through of jne at 0x004fb579, 6 instruction(s), ends with forward jump to 0x004fb5a3
    mov ecx, dword ptr [ebp - local_8]           # 004fb57b
    and ecx, 0xffff                              # 004fb57e
    imul ecx, ecx, 0x5bb                         # 004fb584
    fld dword ptr [ecx + 0x5c3b9f]               # 004fb58a
    fstp qword ptr [ebp - local_30]              # 004fb590
    jmp.d8 L_004fb5a3                            # 004fb593
L_004fb595:
    # block 0x004fb595: entered by jne at 0x004fb579, 2 instruction(s), falls into the block at 0x004fb5a3
    mov dword ptr [ebp - local_30], 0x0          # 004fb595
    mov dword ptr [ebp - local_2c], 0x0          # 004fb59c
L_004fb5a3:
    # block 0x004fb5a3: entered by jmp at 0x004fb593, 16 instruction(s), ends with je to 0x004fb601 (forward)
    fld qword ptr [ebp - local_30]               # 004fb5a3
    fstp dword ptr [ebp - local_34]              # 004fb5a6
    fld dword ptr [ebp - local_34]               # 004fb5a9
    mov edx, dword ptr [ebp - local_8]           # 004fb5ac
    and edx, 0xffff                              # 004fb5af
    imul edx, edx, 0x5bb                         # 004fb5b5
    mov eax, dword ptr [ebp - local_c]           # 004fb5bb
    fstp dword ptr [eax + edx + field_138]       # 004fb5be
    mov ecx, dword ptr [ebp - local_8]           # 004fb5c5
    and ecx, 0xffff                              # 004fb5c8
    imul ecx, ecx, 0x5bb                         # 004fb5ce
    fld dword ptr [ecx + 0x5c3ba3]               # 004fb5d4
    fcomp qword ptr [0x52c598]                   # 004fb5da
    fnstsw ax                                    # 004fb5e0
    test ah, 0x1                                 # 004fb5e2
    je.d8 L_004fb601                             # 004fb5e5
    # block 0x004fb5e7: entered by fall-through of je at 0x004fb5e5, 6 instruction(s), ends with forward jump to 0x004fb60f
    mov edx, dword ptr [ebp - local_8]           # 004fb5e7
    and edx, 0xffff                              # 004fb5ea
    imul edx, edx, 0x5bb                         # 004fb5f0
    fld dword ptr [edx + 0x5c3ba3]               # 004fb5f6
    fstp qword ptr [ebp - local_3c]              # 004fb5fc
    jmp.d8 L_004fb60f                            # 004fb5ff
L_004fb601:
    # block 0x004fb601: entered by je at 0x004fb5e5, 2 instruction(s), falls into the block at 0x004fb60f
    mov dword ptr [ebp - local_3c], 0x0          # 004fb601
    mov dword ptr [ebp - local_38], 0x3ff00000   # 004fb608
L_004fb60f:
    # block 0x004fb60f: entered by jmp at 0x004fb5ff, 16 instruction(s), ends with jne to 0x004fb66b (forward)
    fld qword ptr [ebp - local_3c]               # 004fb60f
    fstp dword ptr [ebp - local_40]              # 004fb612
    fld dword ptr [ebp - local_40]               # 004fb615
    mov eax, dword ptr [ebp - local_8]           # 004fb618
    and eax, 0xffff                              # 004fb61b
    imul eax, eax, 0x5bb                         # 004fb620
    mov ecx, dword ptr [ebp - local_c]           # 004fb626
    fstp dword ptr [ecx + eax + field_13c]       # 004fb629
    mov edx, dword ptr [ebp - local_8]           # 004fb630
    and edx, 0xffff                              # 004fb633
    imul edx, edx, 0x5bb                         # 004fb639
    fld dword ptr [edx + 0x5c3ba3]               # 004fb63f
    fcomp qword ptr [0x52c7b0]                   # 004fb645
    fnstsw ax                                    # 004fb64b
    test ah, 0x41                                # 004fb64d
    jne.d8 L_004fb66b                            # 004fb650
    # block 0x004fb652: entered by fall-through of jne at 0x004fb650, 6 instruction(s), ends with forward jump to 0x004fb679
    mov eax, dword ptr [ebp - local_8]           # 004fb652
    and eax, 0xffff                              # 004fb655
    imul eax, eax, 0x5bb                         # 004fb65a
    fld dword ptr [eax + 0x5c3ba3]               # 004fb660
    fstp qword ptr [ebp - local_48]              # 004fb666
    jmp.d8 L_004fb679                            # 004fb669
L_004fb66b:
    # block 0x004fb66b: entered by jne at 0x004fb650, 2 instruction(s), falls into the block at 0x004fb679
    mov dword ptr [ebp - local_48], 0x0          # 004fb66b
    mov dword ptr [ebp - local_44], 0x0          # 004fb672
L_004fb679:
    # block 0x004fb679: entered by jmp at 0x004fb669, 23 instruction(s), calls FUN_004fc62d, ends with backward jump to 0x004fb3c8
    fld qword ptr [ebp - local_48]               # 004fb679
    fstp dword ptr [ebp - local_4c]              # 004fb67c
    fld dword ptr [ebp - local_4c]               # 004fb67f
    mov ecx, dword ptr [ebp - local_8]           # 004fb682
    and ecx, 0xffff                              # 004fb685
    imul ecx, ecx, 0x5bb                         # 004fb68b
    mov edx, dword ptr [ebp - local_c]           # 004fb691
    fstp dword ptr [edx + ecx + field_13c]       # 004fb694
    push 0x1                                     # 004fb69b
    push 0x0                                     # 004fb69d
    movsx eax, word ptr [ebp - local_4]          # 004fb69f
    imul eax, eax, 0x2f                          # 004fb6a3
    movsx ecx, word ptr [eax + 0x583383]         # 004fb6a6
    push ecx                                     # 004fb6ad
    movsx edx, word ptr [ebp - local_4]          # 004fb6ae
    imul edx, edx, 0x2f                          # 004fb6b2
    add edx, 0x583360                            # 004fb6b5
    push edx                                     # 004fb6bb
    mov ax, word ptr [ebp - local_8]             # 004fb6bc
    push eax                                     # 004fb6c0
    mov ecx, dword ptr [ebp - local_c]           # 004fb6c1
    call FUN_004fc62d                            # 004fb6c4
    jmp.d32 L_004fb3c8                           # 004fb6c9
L_004fb6ce:
    # block 0x004fb6ce: entered by jge at 0x004fb3db, 2 instruction(s), ends with forward jump to 0x004fb6e2
    mov word ptr [ebp - local_4], 0x0            # 004fb6ce
    jmp.d8 L_004fb6e2                            # 004fb6d4
L_004fb6d6:
    # block 0x004fb6d6: entered by jmp at 0x004fb731, 3 instruction(s), falls into the block at 0x004fb6e2
    mov cx, word ptr [ebp - local_4]             # 004fb6d6
    add cx, 0x1                                  # 004fb6da
    mov word ptr [ebp - local_4], cx             # 004fb6de
L_004fb6e2:
    # block 0x004fb6e2: entered by jmp at 0x004fb6d4, 3 instruction(s), ends with jge to 0x004fb733 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004fb6e2
    cmp edx, 0x3                                 # 004fb6e6
    jge.d8 L_004fb733                            # 004fb6e9
    # block 0x004fb6eb: entered by fall-through of jge at 0x004fb6e9, 3 instruction(s), ends with je to 0x004fb71a (forward)
    movsx eax, word ptr [0x63a4cd]               # 004fb6eb
    test eax, eax                                # 004fb6f2
    je.d8 L_004fb71a                             # 004fb6f4
    # block 0x004fb6f6: entered by fall-through of je at 0x004fb6f4, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb71a
    movsx ecx, word ptr [ebp - local_4]          # 004fb6f6
    push ecx                                     # 004fb6fa
    push 0x560818                                # 004fb6fb
    push 0x63888b                                # 004fb700
    call FUN_0050ca3e                            # 004fb705
    add esp, 0xc                                 # 004fb70a
    push 0x63888b                                # 004fb70d
    call FUN_0044a2b7                            # 004fb712
    add esp, 0x4                                 # 004fb717
L_004fb71a:
    # block 0x004fb71a: entered by je at 0x004fb6f4, 7 instruction(s), calls FUN_004fb2e3, ends with backward jump to 0x004fb6d6
    movsx edx, word ptr [ebp - local_4]          # 004fb71a
    imul edx, edx, 0x2f                          # 004fb71e
    mov ax, word ptr [edx + 0x583381]            # 004fb721
    push eax                                     # 004fb728
    mov ecx, dword ptr [ebp - local_c]           # 004fb729
    call FUN_004fb2e3                            # 004fb72c
    jmp.d8 L_004fb6d6                            # 004fb731
L_004fb733:
    # block 0x004fb733: entered by jge at 0x004fb6e9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fb733
    pop ebp                                      # 004fb735
    ret                                          # 004fb736

