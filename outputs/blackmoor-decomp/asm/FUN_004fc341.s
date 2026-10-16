# FUN_004fc341
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc341
# extent:       0x004fc341-0x004fc62d (748 code bytes)
# span:         0x004fc341-0x004fc62d (code 748, tables 0, padding 0)
# sha256:       39b5ca7870470bfd18390b24b615f6e8d8c786f841caff90e630946e5e7c2094
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fc341
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_130, field_132, field_134, field_13c; [ecx + n] field_138, field_13c, field_16a; [edx + n] field_138
# callees:      calls FUN_004fc62d, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 175 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_130, 0x130  # offset +0x130
.equ field_132, 0x132  # offset +0x132
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x004fc341 - 0x401000
.globl FUN_004fc341
FUN_004fc341:
    # block 0x004fc341: entry, 12 instruction(s), ends with je to 0x004fc627 (forward)
    push ebp                                     # 004fc341
    {load} mov ebp, esp                          # 004fc342
    sub esp, 0x48                                # 004fc344
    push esi                                     # 004fc347
    push edi                                     # 004fc348
    mov dword ptr [ebp - local_8], ecx           # 004fc349
    mov edi, 0x560840                            # 004fc34c
    mov esi, 0x5bb285                            # 004fc351
    mov ecx, 0x9                                 # 004fc356
    {load} xor eax, eax                          # 004fc35b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004fc35d
    je.d32 L_004fc627                            # 004fc35f
    # block 0x004fc365: entered by fall-through of je at 0x004fc35f, 43 instruction(s), ends with je to 0x004fc449 (forward)
    mov cx, word ptr [0x5bb2aa]                  # 004fc365
    mov word ptr [ebp - local_4], cx             # 004fc36c
    mov edx, dword ptr [ebp - local_4]           # 004fc370
    and edx, 0xffff                              # 004fc373
    imul edx, edx, 0x5bb                         # 004fc379
    mov eax, dword ptr [ebp - local_8]           # 004fc37f
    mov ecx, dword ptr [0x5bb2ae]                # 004fc382
    mov dword ptr [eax + edx + field_134], ecx   # 004fc388
    movsx edx, word ptr [0x5bb2b2]               # 004fc38f
    mov dword ptr [ebp - local_c], edx           # 004fc396
    fild dword ptr [ebp - local_c]               # 004fc399
    fstp dword ptr [ebp - local_10]              # 004fc39c
    fld dword ptr [ebp - local_10]               # 004fc39f
    fdiv dword ptr [0x52cbec]                    # 004fc3a2
    mov eax, dword ptr [ebp - local_4]           # 004fc3a8
    and eax, 0xffff                              # 004fc3ab
    imul eax, eax, 0x5bb                         # 004fc3b0
    mov ecx, dword ptr [ebp - local_8]           # 004fc3b6
    fstp dword ptr [ecx + eax + field_138]       # 004fc3b9
    movsx edx, word ptr [0x5bb2b4]               # 004fc3c0
    mov dword ptr [ebp - local_14], edx          # 004fc3c7
    fild dword ptr [ebp - local_14]              # 004fc3ca
    fstp dword ptr [ebp - local_18]              # 004fc3cd
    fld dword ptr [ebp - local_18]               # 004fc3d0
    fdiv dword ptr [0x52cbec]                    # 004fc3d3
    mov eax, dword ptr [ebp - local_4]           # 004fc3d9
    and eax, 0xffff                              # 004fc3dc
    imul eax, eax, 0x5bb                         # 004fc3e1
    mov ecx, dword ptr [ebp - local_8]           # 004fc3e7
    fstp dword ptr [ecx + eax + field_13c]       # 004fc3ea
    mov edx, dword ptr [ebp - local_4]           # 004fc3f1
    and edx, 0xffff                              # 004fc3f4
    imul edx, edx, 0x5bb                         # 004fc3fa
    mov eax, dword ptr [ebp - local_8]           # 004fc400
    mov word ptr [eax + edx + field_130], 0x1    # 004fc403
    mov ecx, dword ptr [ebp - local_4]           # 004fc40d
    and ecx, 0xffff                              # 004fc410
    imul ecx, ecx, 0x5bb                         # 004fc416
    fld dword ptr [ecx + 0x5c3b9f]               # 004fc41c
    fcomp qword ptr [0x52c598]                   # 004fc422
    fnstsw ax                                    # 004fc428
    test ah, 0x1                                 # 004fc42a
    je.d8 L_004fc449                             # 004fc42d
    # block 0x004fc42f: entered by fall-through of je at 0x004fc42d, 6 instruction(s), ends with forward jump to 0x004fc457
    mov edx, dword ptr [ebp - local_4]           # 004fc42f
    and edx, 0xffff                              # 004fc432
    imul edx, edx, 0x5bb                         # 004fc438
    fld dword ptr [edx + 0x5c3b9f]               # 004fc43e
    fstp qword ptr [ebp - local_20]              # 004fc444
    jmp.d8 L_004fc457                            # 004fc447
L_004fc449:
    # block 0x004fc449: entered by je at 0x004fc42d, 2 instruction(s), falls into the block at 0x004fc457
    mov dword ptr [ebp - local_20], 0x0          # 004fc449
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004fc450
L_004fc457:
    # block 0x004fc457: entered by jmp at 0x004fc447, 16 instruction(s), ends with jne to 0x004fc4b3 (forward)
    fld qword ptr [ebp - local_20]               # 004fc457
    fstp dword ptr [ebp - local_24]              # 004fc45a
    fld dword ptr [ebp - local_24]               # 004fc45d
    mov eax, dword ptr [ebp - local_4]           # 004fc460
    and eax, 0xffff                              # 004fc463
    imul eax, eax, 0x5bb                         # 004fc468
    mov ecx, dword ptr [ebp - local_8]           # 004fc46e
    fstp dword ptr [ecx + eax + field_138]       # 004fc471
    mov edx, dword ptr [ebp - local_4]           # 004fc478
    and edx, 0xffff                              # 004fc47b
    imul edx, edx, 0x5bb                         # 004fc481
    fld dword ptr [edx + 0x5c3b9f]               # 004fc487
    fcomp qword ptr [0x52c7b0]                   # 004fc48d
    fnstsw ax                                    # 004fc493
    test ah, 0x41                                # 004fc495
    jne.d8 L_004fc4b3                            # 004fc498
    # block 0x004fc49a: entered by fall-through of jne at 0x004fc498, 6 instruction(s), ends with forward jump to 0x004fc4c1
    mov eax, dword ptr [ebp - local_4]           # 004fc49a
    and eax, 0xffff                              # 004fc49d
    imul eax, eax, 0x5bb                         # 004fc4a2
    fld dword ptr [eax + 0x5c3b9f]               # 004fc4a8
    fstp qword ptr [ebp - local_2c]              # 004fc4ae
    jmp.d8 L_004fc4c1                            # 004fc4b1
L_004fc4b3:
    # block 0x004fc4b3: entered by jne at 0x004fc498, 2 instruction(s), falls into the block at 0x004fc4c1
    mov dword ptr [ebp - local_2c], 0x0          # 004fc4b3
    mov dword ptr [ebp - local_28], 0x0          # 004fc4ba
L_004fc4c1:
    # block 0x004fc4c1: entered by jmp at 0x004fc4b1, 16 instruction(s), ends with je to 0x004fc51e (forward)
    fld qword ptr [ebp - local_2c]               # 004fc4c1
    fstp dword ptr [ebp - local_30]              # 004fc4c4
    fld dword ptr [ebp - local_30]               # 004fc4c7
    mov ecx, dword ptr [ebp - local_4]           # 004fc4ca
    and ecx, 0xffff                              # 004fc4cd
    imul ecx, ecx, 0x5bb                         # 004fc4d3
    mov edx, dword ptr [ebp - local_8]           # 004fc4d9
    fstp dword ptr [edx + ecx + field_138]       # 004fc4dc
    mov eax, dword ptr [ebp - local_4]           # 004fc4e3
    and eax, 0xffff                              # 004fc4e6
    imul eax, eax, 0x5bb                         # 004fc4eb
    fld dword ptr [eax + 0x5c3ba3]               # 004fc4f1
    fcomp qword ptr [0x52c598]                   # 004fc4f7
    fnstsw ax                                    # 004fc4fd
    test ah, 0x1                                 # 004fc4ff
    je.d8 L_004fc51e                             # 004fc502
    # block 0x004fc504: entered by fall-through of je at 0x004fc502, 6 instruction(s), ends with forward jump to 0x004fc52c
    mov ecx, dword ptr [ebp - local_4]           # 004fc504
    and ecx, 0xffff                              # 004fc507
    imul ecx, ecx, 0x5bb                         # 004fc50d
    fld dword ptr [ecx + 0x5c3ba3]               # 004fc513
    fstp qword ptr [ebp - local_38]              # 004fc519
    jmp.d8 L_004fc52c                            # 004fc51c
L_004fc51e:
    # block 0x004fc51e: entered by je at 0x004fc502, 2 instruction(s), falls into the block at 0x004fc52c
    mov dword ptr [ebp - local_38], 0x0          # 004fc51e
    mov dword ptr [ebp - local_34], 0x3ff00000   # 004fc525
L_004fc52c:
    # block 0x004fc52c: entered by jmp at 0x004fc51c, 16 instruction(s), ends with jne to 0x004fc58a (forward)
    fld qword ptr [ebp - local_38]               # 004fc52c
    fstp dword ptr [ebp - local_3c]              # 004fc52f
    fld dword ptr [ebp - local_3c]               # 004fc532
    mov edx, dword ptr [ebp - local_4]           # 004fc535
    and edx, 0xffff                              # 004fc538
    imul edx, edx, 0x5bb                         # 004fc53e
    mov eax, dword ptr [ebp - local_8]           # 004fc544
    fstp dword ptr [eax + edx + field_13c]       # 004fc547
    mov ecx, dword ptr [ebp - local_4]           # 004fc54e
    and ecx, 0xffff                              # 004fc551
    imul ecx, ecx, 0x5bb                         # 004fc557
    fld dword ptr [ecx + 0x5c3ba3]               # 004fc55d
    fcomp qword ptr [0x52c7b0]                   # 004fc563
    fnstsw ax                                    # 004fc569
    test ah, 0x41                                # 004fc56b
    jne.d8 L_004fc58a                            # 004fc56e
    # block 0x004fc570: entered by fall-through of jne at 0x004fc56e, 6 instruction(s), ends with forward jump to 0x004fc598
    mov edx, dword ptr [ebp - local_4]           # 004fc570
    and edx, 0xffff                              # 004fc573
    imul edx, edx, 0x5bb                         # 004fc579
    fld dword ptr [edx + 0x5c3ba3]               # 004fc57f
    fstp qword ptr [ebp - local_44]              # 004fc585
    jmp.d8 L_004fc598                            # 004fc588
L_004fc58a:
    # block 0x004fc58a: entered by jne at 0x004fc56e, 2 instruction(s), falls into the block at 0x004fc598
    mov dword ptr [ebp - local_44], 0x0          # 004fc58a
    mov dword ptr [ebp - local_40], 0x0          # 004fc591
L_004fc598:
    # block 0x004fc598: entered by jmp at 0x004fc588, 35 instruction(s), calls FUN_004fc62d, FUN_004fb2e3, falls into the block at 0x004fc627
    fld qword ptr [ebp - local_44]               # 004fc598
    fstp dword ptr [ebp - local_48]              # 004fc59b
    fld dword ptr [ebp - local_48]               # 004fc59e
    mov eax, dword ptr [ebp - local_4]           # 004fc5a1
    and eax, 0xffff                              # 004fc5a4
    imul eax, eax, 0x5bb                         # 004fc5a9
    mov ecx, dword ptr [ebp - local_8]           # 004fc5af
    fstp dword ptr [ecx + eax + field_13c]       # 004fc5b2
    mov edx, dword ptr [ebp - local_4]           # 004fc5b9
    and edx, 0xffff                              # 004fc5bc
    imul edx, edx, 0x5bb                         # 004fc5c2
    mov eax, dword ptr [ebp - local_8]           # 004fc5c8
    mov word ptr [eax + edx + field_132], 0x0    # 004fc5cb
    movsx ecx, word ptr [0x5bb2a8]               # 004fc5d5
    {load} xor edx, edx                          # 004fc5dc
    cmp ecx, 0x2                                 # 004fc5de
    sete dl                                      # 004fc5e1
    mov eax, dword ptr [ebp - local_4]           # 004fc5e4
    and eax, 0xffff                              # 004fc5e7
    imul eax, eax, 0x5bb                         # 004fc5ec
    mov ecx, dword ptr [ebp - local_8]           # 004fc5f2
    mov dword ptr [ecx + eax + field_16a], edx   # 004fc5f5
    push 0x1                                     # 004fc5fc
    push 0x0                                     # 004fc5fe
    movsx edx, word ptr [0x5bb2a6]               # 004fc600
    push edx                                     # 004fc607
    push 0x5bb285                                # 004fc608
    mov ax, word ptr [ebp - local_4]             # 004fc60d
    push eax                                     # 004fc611
    mov ecx, dword ptr [ebp - local_8]           # 004fc612
    call FUN_004fc62d                            # 004fc615
    mov cx, word ptr [ebp - local_4]             # 004fc61a
    push ecx                                     # 004fc61e
    mov ecx, dword ptr [ebp - local_8]           # 004fc61f
    call FUN_004fb2e3                            # 004fc622
L_004fc627:
    # block 0x004fc627: entered by je at 0x004fc35f, 5 instruction(s), ends with ret
    pop edi                                      # 004fc627
    pop esi                                      # 004fc628
    {load} mov esp, ebp                          # 004fc629
    pop ebp                                      # 004fc62b
    ret                                          # 004fc62c

