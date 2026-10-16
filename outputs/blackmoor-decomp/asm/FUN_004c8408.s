# FUN_004c8408
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c8408
# extent:       0x004c8408-0x004c8757 (847 code bytes)
# span:         0x004c8408-0x004c8757 (code 847, tables 0, padding 0)
# sha256:       c41d4f220f8cc708f4dbaa6f1a10c3494568d337b19436446cdc45565940237e
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c8408
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c87ba, FUN_004c8872
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 307 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004c87ba, .text + (0x004c87ba - 0x401000)
.set FUN_004c8872, .text + (0x004c8872 - 0x401000)

.org 0x004c8408 - 0x401000
.globl FUN_004c8408
FUN_004c8408:
    # block 0x004c8408: entry, 7 instruction(s), ends with jle to 0x004c843d (forward)
    push ebp                                     # 004c8408
    {load} mov ebp, esp                          # 004c8409
    sub esp, 0x38                                # 004c840b
    mov dword ptr [ebp - local_38], ecx          # 004c840e
    mov eax, dword ptr [ebp + arg_14]            # 004c8411
    cmp eax, dword ptr [ebp + arg_1c]            # 004c8414
    jle.d8 L_004c843d                            # 004c8417
    # block 0x004c8419: entered by fall-through of jle at 0x004c8417, 12 instruction(s), falls into the block at 0x004c843d
    mov ecx, dword ptr [ebp + arg_14]            # 004c8419
    mov dword ptr [ebp - local_14], ecx          # 004c841c
    mov edx, dword ptr [ebp + arg_1c]            # 004c841f
    mov dword ptr [ebp + arg_14], edx            # 004c8422
    mov eax, dword ptr [ebp - local_14]          # 004c8425
    mov dword ptr [ebp + arg_1c], eax            # 004c8428
    mov ecx, dword ptr [ebp + arg_10]            # 004c842b
    mov dword ptr [ebp - local_14], ecx          # 004c842e
    mov edx, dword ptr [ebp + arg_18]            # 004c8431
    mov dword ptr [ebp + arg_10], edx            # 004c8434
    mov eax, dword ptr [ebp - local_14]          # 004c8437
    mov dword ptr [ebp + arg_18], eax            # 004c843a
L_004c843d:
    # block 0x004c843d: entered by jle at 0x004c8417, 11 instruction(s), ends with jge to 0x004c846f (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 004c843d
    imul ecx, dword ptr [ebp + arg_c]            # 004c8440
    mov edx, dword ptr [ebp + arg_8]             # 004c8444
    {load} add edx, ecx                          # 004c8447
    add edx, dword ptr [ebp + arg_10]            # 004c8449
    mov dword ptr [ebp - local_30], edx          # 004c844c
    mov eax, dword ptr [ebp + arg_18]            # 004c844f
    sub eax, dword ptr [ebp + arg_10]            # 004c8452
    mov dword ptr [ebp - local_24], eax          # 004c8455
    cmp dword ptr [ebp - local_24], 0x0          # 004c8458
    jge.d8 L_004c846f                            # 004c845c
    # block 0x004c845e: entered by fall-through of jge at 0x004c845c, 5 instruction(s), ends with forward jump to 0x004c8476
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c845e
    mov ecx, dword ptr [ebp - local_24]          # 004c8465
    neg ecx                                      # 004c8468
    mov dword ptr [ebp - local_24], ecx          # 004c846a
    jmp.d8 L_004c8476                            # 004c846d
L_004c846f:
    # block 0x004c846f: entered by jge at 0x004c845c, 1 instruction(s), falls into the block at 0x004c8476
    mov dword ptr [ebp - local_4], 0x1           # 004c846f
L_004c8476:
    # block 0x004c8476: entered by jmp at 0x004c846d, 5 instruction(s), ends with jne to 0x004c84b7 (forward)
    mov edx, dword ptr [ebp + arg_1c]            # 004c8476
    sub edx, dword ptr [ebp + arg_14]            # 004c8479
    mov dword ptr [ebp - local_20], edx          # 004c847c
    cmp dword ptr [ebp - local_24], 0x0          # 004c847f
    jne.d8 L_004c84b7                            # 004c8483
    # block 0x004c8485: entered by fall-through of jne at 0x004c8483, 2 instruction(s), ends with forward jump to 0x004c8497
    mov dword ptr [ebp - local_1c], 0x0          # 004c8485
    jmp.d8 L_004c8497                            # 004c848c
L_004c848e:
    # block 0x004c848e: entered by jmp at 0x004c84b0, 3 instruction(s), falls into the block at 0x004c8497
    mov eax, dword ptr [ebp - local_1c]          # 004c848e
    add eax, 0x1                                 # 004c8491
    mov dword ptr [ebp - local_1c], eax          # 004c8494
L_004c8497:
    # block 0x004c8497: entered by jmp at 0x004c848c, 3 instruction(s), ends with jg to 0x004c84b2 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c8497
    cmp ecx, dword ptr [ebp - local_20]          # 004c849a
    jg.d8 L_004c84b2                             # 004c849d
    # block 0x004c849f: entered by fall-through of jg at 0x004c849d, 7 instruction(s), ends with backward jump to 0x004c848e
    mov edx, dword ptr [ebp - local_30]          # 004c849f
    mov al, byte ptr [ebp + arg_20]              # 004c84a2
    mov byte ptr [edx], al                       # 004c84a5
    mov ecx, dword ptr [ebp - local_30]          # 004c84a7
    add ecx, dword ptr [ebp + arg_c]             # 004c84aa
    mov dword ptr [ebp - local_30], ecx          # 004c84ad
    jmp.d8 L_004c848e                            # 004c84b0
L_004c84b2:
    # block 0x004c84b2: entered by jg at 0x004c849d, 1 instruction(s), ends with forward jump to 0x004c8751
    jmp.d32 L_004c8751                           # 004c84b2
L_004c84b7:
    # block 0x004c84b7: entered by jne at 0x004c8483, 2 instruction(s), ends with jne to 0x004c84ef (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004c84b7
    jne.d8 L_004c84ef                            # 004c84bb
    # block 0x004c84bd: entered by fall-through of jne at 0x004c84bb, 2 instruction(s), ends with forward jump to 0x004c84cf
    mov dword ptr [ebp - local_1c], 0x0          # 004c84bd
    jmp.d8 L_004c84cf                            # 004c84c4
L_004c84c6:
    # block 0x004c84c6: entered by jmp at 0x004c84e8, 3 instruction(s), falls into the block at 0x004c84cf
    mov edx, dword ptr [ebp - local_1c]          # 004c84c6
    add edx, 0x1                                 # 004c84c9
    mov dword ptr [ebp - local_1c], edx          # 004c84cc
L_004c84cf:
    # block 0x004c84cf: entered by jmp at 0x004c84c4, 3 instruction(s), ends with jg to 0x004c84ea (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c84cf
    cmp eax, dword ptr [ebp - local_24]          # 004c84d2
    jg.d8 L_004c84ea                             # 004c84d5
    # block 0x004c84d7: entered by fall-through of jg at 0x004c84d5, 7 instruction(s), ends with backward jump to 0x004c84c6
    mov ecx, dword ptr [ebp - local_30]          # 004c84d7
    mov dl, byte ptr [ebp + arg_20]              # 004c84da
    mov byte ptr [ecx], dl                       # 004c84dd
    mov eax, dword ptr [ebp - local_30]          # 004c84df
    add eax, dword ptr [ebp - local_4]           # 004c84e2
    mov dword ptr [ebp - local_30], eax          # 004c84e5
    jmp.d8 L_004c84c6                            # 004c84e8
L_004c84ea:
    # block 0x004c84ea: entered by jg at 0x004c84d5, 1 instruction(s), ends with forward jump to 0x004c8751
    jmp.d32 L_004c8751                           # 004c84ea
L_004c84ef:
    # block 0x004c84ef: entered by jne at 0x004c84bb, 3 instruction(s), ends with jne to 0x004c852e (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004c84ef
    cmp ecx, dword ptr [ebp - local_20]          # 004c84f2
    jne.d8 L_004c852e                            # 004c84f5
    # block 0x004c84f7: entered by fall-through of jne at 0x004c84f5, 2 instruction(s), ends with forward jump to 0x004c8509
    mov dword ptr [ebp - local_1c], 0x0          # 004c84f7
    jmp.d8 L_004c8509                            # 004c84fe
L_004c8500:
    # block 0x004c8500: entered by jmp at 0x004c8527, 3 instruction(s), falls into the block at 0x004c8509
    mov edx, dword ptr [ebp - local_1c]          # 004c8500
    add edx, 0x1                                 # 004c8503
    mov dword ptr [ebp - local_1c], edx          # 004c8506
L_004c8509:
    # block 0x004c8509: entered by jmp at 0x004c84fe, 3 instruction(s), ends with jg to 0x004c8529 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c8509
    cmp eax, dword ptr [ebp - local_24]          # 004c850c
    jg.d8 L_004c8529                             # 004c850f
    # block 0x004c8511: entered by fall-through of jg at 0x004c850f, 9 instruction(s), ends with backward jump to 0x004c8500
    mov ecx, dword ptr [ebp - local_30]          # 004c8511
    mov dl, byte ptr [ebp + arg_20]              # 004c8514
    mov byte ptr [ecx], dl                       # 004c8517
    mov eax, dword ptr [ebp + arg_c]             # 004c8519
    add eax, dword ptr [ebp - local_4]           # 004c851c
    mov ecx, dword ptr [ebp - local_30]          # 004c851f
    {load} add ecx, eax                          # 004c8522
    mov dword ptr [ebp - local_30], ecx          # 004c8524
    jmp.d8 L_004c8500                            # 004c8527
L_004c8529:
    # block 0x004c8529: entered by jg at 0x004c850f, 1 instruction(s), ends with forward jump to 0x004c8751
    jmp.d32 L_004c8751                           # 004c8529
L_004c852e:
    # block 0x004c852e: entered by jne at 0x004c84f5, 3 instruction(s), ends with jl to 0x004c8648 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c852e
    cmp edx, dword ptr [ebp - local_20]          # 004c8531
    jl.d32 L_004c8648                            # 004c8534
    # block 0x004c853a: entered by fall-through of jl at 0x004c8534, 29 instruction(s), ends with jne to 0x004c8596 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c853a
    cdq                                          # 004c853d
    idiv dword ptr [ebp - local_20]              # 004c853e
    mov dword ptr [ebp - local_8], eax           # 004c8541
    mov eax, dword ptr [ebp - local_24]          # 004c8544
    cdq                                          # 004c8547
    idiv dword ptr [ebp - local_20]              # 004c8548
    shl edx                                      # 004c854b
    mov dword ptr [ebp - local_10], edx          # 004c854d
    mov eax, dword ptr [ebp - local_20]          # 004c8550
    shl eax                                      # 004c8553
    mov dword ptr [ebp - local_34], eax          # 004c8555
    mov eax, dword ptr [ebp - local_24]          # 004c8558
    cdq                                          # 004c855b
    idiv dword ptr [ebp - local_20]              # 004c855c
    mov ecx, dword ptr [ebp - local_20]          # 004c855f
    shl ecx                                      # 004c8562
    {load} sub edx, ecx                          # 004c8564
    mov dword ptr [ebp - local_2c], edx          # 004c8566
    mov eax, dword ptr [ebp - local_8]           # 004c8569
    cdq                                          # 004c856c
    {load} sub eax, edx                          # 004c856d
    sar eax                                      # 004c856f
    add eax, 0x1                                 # 004c8571
    mov dword ptr [ebp - local_28], eax          # 004c8574
    mov edx, dword ptr [ebp - local_28]          # 004c8577
    mov dword ptr [ebp - local_18], edx          # 004c857a
    cmp dword ptr [ebp - local_10], 0x0          # 004c857d
    jne.d8 L_004c8596                            # 004c8581
    # block 0x004c8583: entered by fall-through of jne at 0x004c8581, 4 instruction(s), ends with jne to 0x004c8596 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c8583
    and eax, 0x1                                 # 004c8586
    test eax, eax                                # 004c8589
    jne.d8 L_004c8596                            # 004c858b
    # block 0x004c858d: entered by fall-through of jne at 0x004c858b, 3 instruction(s), falls into the block at 0x004c8596
    mov ecx, dword ptr [ebp - local_28]          # 004c858d
    sub ecx, 0x1                                 # 004c8590
    mov dword ptr [ebp - local_28], ecx          # 004c8593
L_004c8596:
    # block 0x004c8596: entered by jne at 0x004c8581; jne at 0x004c858b, 4 instruction(s), ends with je to 0x004c85a9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c8596
    and edx, 0x1                                 # 004c8599
    test edx, edx                                # 004c859c
    je.d8 L_004c85a9                             # 004c859e
    # block 0x004c85a0: entered by fall-through of je at 0x004c859e, 3 instruction(s), falls into the block at 0x004c85a9
    mov eax, dword ptr [ebp - local_2c]          # 004c85a0
    add eax, dword ptr [ebp - local_20]          # 004c85a3
    mov dword ptr [ebp - local_2c], eax          # 004c85a6
L_004c85a9:
    # block 0x004c85a9: entered by je at 0x004c859e, 14 instruction(s), calls FUN_004c87ba, ends with forward jump to 0x004c85d7
    mov cl, byte ptr [ebp + arg_20]              # 004c85a9
    push ecx                                     # 004c85ac
    mov edx, dword ptr [ebp - local_28]          # 004c85ad
    push edx                                     # 004c85b0
    mov eax, dword ptr [ebp - local_4]           # 004c85b1
    push eax                                     # 004c85b4
    mov ecx, dword ptr [ebp + arg_c]             # 004c85b5
    push ecx                                     # 004c85b8
    lea edx, [ebp - local_30]                    # 004c85b9
    push edx                                     # 004c85bc
    mov ecx, dword ptr [ebp - local_38]          # 004c85bd
    call FUN_004c87ba                            # 004c85c0
    mov dword ptr [ebp - local_1c], 0x0          # 004c85c5
    jmp.d8 L_004c85d7                            # 004c85cc
L_004c85ce:
    # block 0x004c85ce: entered by jmp at 0x004c8625, 3 instruction(s), falls into the block at 0x004c85d7
    mov eax, dword ptr [ebp - local_1c]          # 004c85ce
    add eax, 0x1                                 # 004c85d1
    mov dword ptr [ebp - local_1c], eax          # 004c85d4
L_004c85d7:
    # block 0x004c85d7: entered by jmp at 0x004c85cc, 4 instruction(s), ends with jge to 0x004c8627 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004c85d7
    sub ecx, 0x1                                 # 004c85da
    cmp dword ptr [ebp - local_1c], ecx          # 004c85dd
    jge.d8 L_004c8627                            # 004c85e0
    # block 0x004c85e2: entered by fall-through of jge at 0x004c85e0, 7 instruction(s), ends with jle to 0x004c8609 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c85e2
    mov dword ptr [ebp - local_c], edx           # 004c85e5
    mov eax, dword ptr [ebp - local_2c]          # 004c85e8
    add eax, dword ptr [ebp - local_10]          # 004c85eb
    mov dword ptr [ebp - local_2c], eax          # 004c85ee
    cmp dword ptr [ebp - local_2c], 0x0          # 004c85f1
    jle.d8 L_004c8609                            # 004c85f5
    # block 0x004c85f7: entered by fall-through of jle at 0x004c85f5, 6 instruction(s), falls into the block at 0x004c8609
    mov ecx, dword ptr [ebp - local_c]           # 004c85f7
    add ecx, 0x1                                 # 004c85fa
    mov dword ptr [ebp - local_c], ecx           # 004c85fd
    mov edx, dword ptr [ebp - local_2c]          # 004c8600
    sub edx, dword ptr [ebp - local_34]          # 004c8603
    mov dword ptr [ebp - local_2c], edx          # 004c8606
L_004c8609:
    # block 0x004c8609: entered by jle at 0x004c85f5, 13 instruction(s), calls FUN_004c87ba, ends with backward jump to 0x004c85ce
    mov al, byte ptr [ebp + arg_20]              # 004c8609
    push eax                                     # 004c860c
    mov ecx, dword ptr [ebp - local_c]           # 004c860d
    push ecx                                     # 004c8610
    mov edx, dword ptr [ebp - local_4]           # 004c8611
    push edx                                     # 004c8614
    mov eax, dword ptr [ebp + arg_c]             # 004c8615
    push eax                                     # 004c8618
    lea ecx, [ebp - local_30]                    # 004c8619
    push ecx                                     # 004c861c
    mov ecx, dword ptr [ebp - local_38]          # 004c861d
    call FUN_004c87ba                            # 004c8620
    jmp.d8 L_004c85ce                            # 004c8625
L_004c8627:
    # block 0x004c8627: entered by jge at 0x004c85e0, 13 instruction(s), calls FUN_004c87ba, ends with forward jump to 0x004c8751
    mov dl, byte ptr [ebp + arg_20]              # 004c8627
    push edx                                     # 004c862a
    mov eax, dword ptr [ebp - local_18]          # 004c862b
    push eax                                     # 004c862e
    mov ecx, dword ptr [ebp - local_4]           # 004c862f
    push ecx                                     # 004c8632
    mov edx, dword ptr [ebp + arg_c]             # 004c8633
    push edx                                     # 004c8636
    lea eax, [ebp - local_30]                    # 004c8637
    push eax                                     # 004c863a
    mov ecx, dword ptr [ebp - local_38]          # 004c863b
    call FUN_004c87ba                            # 004c863e
    jmp.d32 L_004c8751                           # 004c8643
L_004c8648:
    # block 0x004c8648: entered by jl at 0x004c8534, 29 instruction(s), ends with jne to 0x004c86a4 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004c8648
    cdq                                          # 004c864b
    idiv dword ptr [ebp - local_24]              # 004c864c
    mov dword ptr [ebp - local_8], eax           # 004c864f
    mov eax, dword ptr [ebp - local_20]          # 004c8652
    cdq                                          # 004c8655
    idiv dword ptr [ebp - local_24]              # 004c8656
    shl edx                                      # 004c8659
    mov dword ptr [ebp - local_10], edx          # 004c865b
    mov ecx, dword ptr [ebp - local_24]          # 004c865e
    shl ecx                                      # 004c8661
    mov dword ptr [ebp - local_34], ecx          # 004c8663
    mov eax, dword ptr [ebp - local_20]          # 004c8666
    cdq                                          # 004c8669
    idiv dword ptr [ebp - local_24]              # 004c866a
    mov eax, dword ptr [ebp - local_24]          # 004c866d
    shl eax                                      # 004c8670
    {load} sub edx, eax                          # 004c8672
    mov dword ptr [ebp - local_2c], edx          # 004c8674
    mov eax, dword ptr [ebp - local_8]           # 004c8677
    cdq                                          # 004c867a
    {load} sub eax, edx                          # 004c867b
    sar eax                                      # 004c867d
    add eax, 0x1                                 # 004c867f
    mov dword ptr [ebp - local_28], eax          # 004c8682
    mov ecx, dword ptr [ebp - local_28]          # 004c8685
    mov dword ptr [ebp - local_18], ecx          # 004c8688
    cmp dword ptr [ebp - local_10], 0x0          # 004c868b
    jne.d8 L_004c86a4                            # 004c868f
    # block 0x004c8691: entered by fall-through of jne at 0x004c868f, 4 instruction(s), ends with jne to 0x004c86a4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c8691
    and edx, 0x1                                 # 004c8694
    test edx, edx                                # 004c8697
    jne.d8 L_004c86a4                            # 004c8699
    # block 0x004c869b: entered by fall-through of jne at 0x004c8699, 3 instruction(s), falls into the block at 0x004c86a4
    mov eax, dword ptr [ebp - local_28]          # 004c869b
    sub eax, 0x1                                 # 004c869e
    mov dword ptr [ebp - local_28], eax          # 004c86a1
L_004c86a4:
    # block 0x004c86a4: entered by jne at 0x004c868f; jne at 0x004c8699, 4 instruction(s), ends with je to 0x004c86b7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c86a4
    and ecx, 0x1                                 # 004c86a7
    test ecx, ecx                                # 004c86aa
    je.d8 L_004c86b7                             # 004c86ac
    # block 0x004c86ae: entered by fall-through of je at 0x004c86ac, 3 instruction(s), falls into the block at 0x004c86b7
    mov edx, dword ptr [ebp - local_2c]          # 004c86ae
    add edx, dword ptr [ebp - local_24]          # 004c86b1
    mov dword ptr [ebp - local_2c], edx          # 004c86b4
L_004c86b7:
    # block 0x004c86b7: entered by je at 0x004c86ac, 14 instruction(s), calls FUN_004c8872, ends with forward jump to 0x004c86e5
    mov al, byte ptr [ebp + arg_20]              # 004c86b7
    push eax                                     # 004c86ba
    mov ecx, dword ptr [ebp - local_28]          # 004c86bb
    push ecx                                     # 004c86be
    mov edx, dword ptr [ebp - local_4]           # 004c86bf
    push edx                                     # 004c86c2
    mov eax, dword ptr [ebp + arg_c]             # 004c86c3
    push eax                                     # 004c86c6
    lea ecx, [ebp - local_30]                    # 004c86c7
    push ecx                                     # 004c86ca
    mov ecx, dword ptr [ebp - local_38]          # 004c86cb
    call FUN_004c8872                            # 004c86ce
    mov dword ptr [ebp - local_1c], 0x0          # 004c86d3
    jmp.d8 L_004c86e5                            # 004c86da
L_004c86dc:
    # block 0x004c86dc: entered by jmp at 0x004c8733, 3 instruction(s), falls into the block at 0x004c86e5
    mov edx, dword ptr [ebp - local_1c]          # 004c86dc
    add edx, 0x1                                 # 004c86df
    mov dword ptr [ebp - local_1c], edx          # 004c86e2
L_004c86e5:
    # block 0x004c86e5: entered by jmp at 0x004c86da, 4 instruction(s), ends with jge to 0x004c8735 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c86e5
    sub eax, 0x1                                 # 004c86e8
    cmp dword ptr [ebp - local_1c], eax          # 004c86eb
    jge.d8 L_004c8735                            # 004c86ee
    # block 0x004c86f0: entered by fall-through of jge at 0x004c86ee, 7 instruction(s), ends with jle to 0x004c8717 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c86f0
    mov dword ptr [ebp - local_c], ecx           # 004c86f3
    mov edx, dword ptr [ebp - local_2c]          # 004c86f6
    add edx, dword ptr [ebp - local_10]          # 004c86f9
    mov dword ptr [ebp - local_2c], edx          # 004c86fc
    cmp dword ptr [ebp - local_2c], 0x0          # 004c86ff
    jle.d8 L_004c8717                            # 004c8703
    # block 0x004c8705: entered by fall-through of jle at 0x004c8703, 6 instruction(s), falls into the block at 0x004c8717
    mov eax, dword ptr [ebp - local_c]           # 004c8705
    add eax, 0x1                                 # 004c8708
    mov dword ptr [ebp - local_c], eax           # 004c870b
    mov ecx, dword ptr [ebp - local_2c]          # 004c870e
    sub ecx, dword ptr [ebp - local_34]          # 004c8711
    mov dword ptr [ebp - local_2c], ecx          # 004c8714
L_004c8717:
    # block 0x004c8717: entered by jle at 0x004c8703, 13 instruction(s), calls FUN_004c8872, ends with backward jump to 0x004c86dc
    mov dl, byte ptr [ebp + arg_20]              # 004c8717
    push edx                                     # 004c871a
    mov eax, dword ptr [ebp - local_c]           # 004c871b
    push eax                                     # 004c871e
    mov ecx, dword ptr [ebp - local_4]           # 004c871f
    push ecx                                     # 004c8722
    mov edx, dword ptr [ebp + arg_c]             # 004c8723
    push edx                                     # 004c8726
    lea eax, [ebp - local_30]                    # 004c8727
    push eax                                     # 004c872a
    mov ecx, dword ptr [ebp - local_38]          # 004c872b
    call FUN_004c8872                            # 004c872e
    jmp.d8 L_004c86dc                            # 004c8733
L_004c8735:
    # block 0x004c8735: entered by jge at 0x004c86ee, 12 instruction(s), calls FUN_004c8872, falls into the block at 0x004c8751
    mov cl, byte ptr [ebp + arg_20]              # 004c8735
    push ecx                                     # 004c8738
    mov edx, dword ptr [ebp - local_18]          # 004c8739
    push edx                                     # 004c873c
    mov eax, dword ptr [ebp - local_4]           # 004c873d
    push eax                                     # 004c8740
    mov ecx, dword ptr [ebp + arg_c]             # 004c8741
    push ecx                                     # 004c8744
    lea edx, [ebp - local_30]                    # 004c8745
    push edx                                     # 004c8748
    mov ecx, dword ptr [ebp - local_38]          # 004c8749
    call FUN_004c8872                            # 004c874c
L_004c8751:
    # block 0x004c8751: entered by jmp at 0x004c84b2; jmp at 0x004c84ea; jmp at 0x004c8529; jmp at 0x004c8643, 3 instruction(s), ends with ret 0x1c
    {load} mov esp, ebp                          # 004c8751
    pop ebp                                      # 004c8753
    ret 0x1c                                     # 004c8754

