# FUN_0045d2c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045d2c6
# extent:       0x0045d2c6-0x0045db6a (2212 code bytes)
# span:         0x0045d2c6-0x0045db70 (code 2212, tables 0, padding 6)
# sha256:       4a32ba406bd6b5f5eb2740449470026327660ada164c2e7ed16b1802c61c4825
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045d2c6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_1c
# fields:       [eax + n] field_2d, field_31d; [ecx + n] field_46d; [edx + n] field_23, field_6d, field_19d, field_1fd, field_25d, field_2bd, field_31d
# callees:      calls FUN_0045b568, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 590 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_1c, 0x1c  # offset -0x1c
.equ field_23, 0x23  # offset +0x23
.equ field_2d, 0x2d  # offset +0x2d
.equ field_6d, 0x6d  # offset +0x6d
.equ field_19d, 0x19d  # offset +0x19d
.equ field_1fd, 0x1fd  # offset +0x1fd
.equ field_25d, 0x25d  # offset +0x25d
.equ field_2bd, 0x2bd  # offset +0x2bd
.equ field_31d, 0x31d  # offset +0x31d
.equ field_46d, 0x46d  # offset +0x46d

# --- external targets -----------------------------------------------
.set FUN_0045b568, .text + (0x0045b568 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x0045d2c6 - 0x401000
.globl FUN_0045d2c6
FUN_0045d2c6:
    # block 0x0045d2c6: entry, 9 instruction(s), ends with forward jump to 0x0045d2f6
    push ebp                                     # 0045d2c6
    {load} mov ebp, esp                          # 0045d2c7
    sub esp, 0x1c                                # 0045d2c9
    movsx eax, word ptr [0x624752]               # 0045d2cc
    imul eax, eax, 0x8d                          # 0045d2d3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045d2d9
    mov dword ptr [ebp - local_4], ecx           # 0045d2df
    mov word ptr [ebp - local_c], 0x0            # 0045d2e2
    jmp.d8 L_0045d2f6                            # 0045d2e8
L_0045d2ea:
    # block 0x0045d2ea: entered by jmp at 0x0045d354, 3 instruction(s), falls into the block at 0x0045d2f6
    mov dx, word ptr [ebp - local_c]             # 0045d2ea
    add dx, 0x1                                  # 0045d2ee
    mov word ptr [ebp - local_c], dx             # 0045d2f2
L_0045d2f6:
    # block 0x0045d2f6: entered by jmp at 0x0045d2e8, 3 instruction(s), ends with jge to 0x0045d356 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0045d2f6
    cmp eax, 0x4                                 # 0045d2fa
    jge.d8 L_0045d356                            # 0045d2fd
    # block 0x0045d2ff: entered by fall-through of jge at 0x0045d2fd, 25 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d2ea
    lea ecx, [ebp - local_1c]                    # 0045d2ff
    push ecx                                     # 0045d302
    movsx edx, word ptr [ebp - local_c]          # 0045d303
    shl edx, 0x4                                 # 0045d307
    mov eax, dword ptr [ebp - local_4]           # 0045d30a
    lea ecx, [eax + edx + field_2d]              # 0045d30d
    push ecx                                     # 0045d311
    mov ecx, 0x624734                            # 0045d312
    call FUN_0045b568                            # 0045d317
    push 0x54ac14                                # 0045d31c
    lea edx, [ebp - local_1c]                    # 0045d321
    push edx                                     # 0045d324
    movsx eax, word ptr [ebp - local_c]          # 0045d325
    shl eax, 0x4                                 # 0045d329
    add eax, 0x62476a                            # 0045d32c
    push eax                                     # 0045d331
    mov ecx, dword ptr [0x5cf665]                # 0045d332
    push ecx                                     # 0045d338
    movsx edx, word ptr [0x624750]               # 0045d339
    imul edx, edx, 0x4a                          # 0045d340
    mov eax, dword ptr [edx + 0x5d1599]          # 0045d343
    push eax                                     # 0045d349
    mov ecx, 0x5cf659                            # 0045d34a
    call FUN_004c5377                            # 0045d34f
    jmp.d8 L_0045d2ea                            # 0045d354
L_0045d356:
    # block 0x0045d356: entered by jge at 0x0045d2fd, 2 instruction(s), ends with forward jump to 0x0045d36a
    mov word ptr [ebp - local_c], 0x0            # 0045d356
    jmp.d8 L_0045d36a                            # 0045d35c
L_0045d35e:
    # block 0x0045d35e: entered by jmp at 0x0045d3c8, 3 instruction(s), falls into the block at 0x0045d36a
    mov cx, word ptr [ebp - local_c]             # 0045d35e
    add cx, 0x1                                  # 0045d362
    mov word ptr [ebp - local_c], cx             # 0045d366
L_0045d36a:
    # block 0x0045d36a: entered by jmp at 0x0045d35c, 3 instruction(s), ends with jge to 0x0045d3ca (forward)
    movsx edx, word ptr [ebp - local_c]          # 0045d36a
    cmp edx, 0x4                                 # 0045d36e
    jge.d8 L_0045d3ca                            # 0045d371
    # block 0x0045d373: entered by fall-through of jge at 0x0045d371, 25 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d35e
    lea eax, [ebp - local_1c]                    # 0045d373
    push eax                                     # 0045d376
    movsx ecx, word ptr [ebp - local_c]          # 0045d377
    shl ecx, 0x4                                 # 0045d37b
    mov edx, dword ptr [ebp - local_4]           # 0045d37e
    lea eax, [edx + ecx + field_6d]              # 0045d381
    push eax                                     # 0045d385
    mov ecx, 0x624734                            # 0045d386
    call FUN_0045b568                            # 0045d38b
    push 0x54ac28                                # 0045d390
    lea ecx, [ebp - local_1c]                    # 0045d395
    push ecx                                     # 0045d398
    movsx edx, word ptr [ebp - local_c]          # 0045d399
    shl edx, 0x4                                 # 0045d39d
    add edx, 0x6247aa                            # 0045d3a0
    push edx                                     # 0045d3a6
    mov eax, dword ptr [0x5cf665]                # 0045d3a7
    push eax                                     # 0045d3ac
    movsx ecx, word ptr [0x624750]               # 0045d3ad
    imul ecx, ecx, 0x4a                          # 0045d3b4
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d3b7
    push edx                                     # 0045d3bd
    mov ecx, 0x5cf659                            # 0045d3be
    call FUN_004c5377                            # 0045d3c3
    jmp.d8 L_0045d35e                            # 0045d3c8
L_0045d3ca:
    # block 0x0045d3ca: entered by jge at 0x0045d371, 2 instruction(s), ends with forward jump to 0x0045d3de
    mov word ptr [ebp - local_c], 0x0            # 0045d3ca
    jmp.d8 L_0045d3de                            # 0045d3d0
L_0045d3d2:
    # block 0x0045d3d2: entered by jmp at 0x0045d44d, 3 instruction(s), falls into the block at 0x0045d3de
    mov ax, word ptr [ebp - local_c]             # 0045d3d2
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045d3d6
    mov word ptr [ebp - local_c], ax             # 0045d3da
L_0045d3de:
    # block 0x0045d3de: entered by jmp at 0x0045d3d0, 8 instruction(s), ends with jge to 0x0045d44f (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045d3de
    mov edx, dword ptr [ebp - local_4]           # 0045d3e2
    movsx eax, word ptr [edx + field_23]         # 0045d3e5
    movsx edx, word ptr [0x6247ec]               # 0045d3e9
    {load} sub eax, edx                          # 0045d3f0
    sub eax, 0x1                                 # 0045d3f2
    {load} cmp ecx, eax                          # 0045d3f5
    jge.d8 L_0045d44f                            # 0045d3f7
    # block 0x0045d3f9: entered by fall-through of jge at 0x0045d3f7, 24 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d3d2
    lea eax, [ebp - local_1c]                    # 0045d3f9
    push eax                                     # 0045d3fc
    movsx ecx, word ptr [ebp - local_c]          # 0045d3fd
    shl ecx, 0x4                                 # 0045d401
    mov edx, dword ptr [ebp - local_4]           # 0045d404
    lea eax, [edx + ecx + field_19d]             # 0045d407
    push eax                                     # 0045d40e
    mov ecx, 0x624734                            # 0045d40f
    call FUN_0045b568                            # 0045d414
    push 0x54ac3c                                # 0045d419
    lea ecx, [ebp - local_1c]                    # 0045d41e
    push ecx                                     # 0045d421
    mov edx, dword ptr [ebp - local_4]           # 0045d422
    add edx, 0x42d                               # 0045d425
    push edx                                     # 0045d42b
    mov eax, dword ptr [0x5cf665]                # 0045d42c
    push eax                                     # 0045d431
    movsx ecx, word ptr [0x624750]               # 0045d432
    imul ecx, ecx, 0x4a                          # 0045d439
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d43c
    push edx                                     # 0045d442
    mov ecx, 0x5cf659                            # 0045d443
    call FUN_004c5377                            # 0045d448
    jmp.d8 L_0045d3d2                            # 0045d44d
L_0045d44f:
    # block 0x0045d44f: entered by jge at 0x0045d3f7, 2 instruction(s), ends with forward jump to 0x0045d463
    mov word ptr [ebp - local_c], 0x0            # 0045d44f
    jmp.d8 L_0045d463                            # 0045d455
L_0045d457:
    # block 0x0045d457: entered by jmp at 0x0045d4c6, 3 instruction(s), falls into the block at 0x0045d463
    mov ax, word ptr [ebp - local_c]             # 0045d457
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045d45b
    mov word ptr [ebp - local_c], ax             # 0045d45f
L_0045d463:
    # block 0x0045d463: entered by jmp at 0x0045d455, 4 instruction(s), ends with jge to 0x0045d4c8 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045d463
    movsx edx, word ptr [0x6247ea]               # 0045d467
    {load} cmp ecx, edx                          # 0045d46e
    jge.d8 L_0045d4c8                            # 0045d470
    # block 0x0045d472: entered by fall-through of jge at 0x0045d470, 24 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d457
    lea eax, [ebp - local_1c]                    # 0045d472
    push eax                                     # 0045d475
    movsx ecx, word ptr [ebp - local_c]          # 0045d476
    shl ecx, 0x4                                 # 0045d47a
    mov edx, dword ptr [ebp - local_4]           # 0045d47d
    lea eax, [edx + ecx + field_1fd]             # 0045d480
    push eax                                     # 0045d487
    mov ecx, 0x624734                            # 0045d488
    call FUN_0045b568                            # 0045d48d
    push 0x54ac54                                # 0045d492
    lea ecx, [ebp - local_1c]                    # 0045d497
    push ecx                                     # 0045d49a
    mov edx, dword ptr [ebp - local_4]           # 0045d49b
    add edx, 0x45d                               # 0045d49e
    push edx                                     # 0045d4a4
    mov eax, dword ptr [0x5cf665]                # 0045d4a5
    push eax                                     # 0045d4aa
    movsx ecx, word ptr [0x624750]               # 0045d4ab
    imul ecx, ecx, 0x4a                          # 0045d4b2
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d4b5
    push edx                                     # 0045d4bb
    mov ecx, 0x5cf659                            # 0045d4bc
    call FUN_004c5377                            # 0045d4c1
    jmp.d8 L_0045d457                            # 0045d4c6
L_0045d4c8:
    # block 0x0045d4c8: entered by jge at 0x0045d470, 2 instruction(s), ends with forward jump to 0x0045d4dc
    mov word ptr [ebp - local_c], 0x0            # 0045d4c8
    jmp.d8 L_0045d4dc                            # 0045d4ce
L_0045d4d0:
    # block 0x0045d4d0: entered by jmp at 0x0045d54b, 3 instruction(s), falls into the block at 0x0045d4dc
    mov ax, word ptr [ebp - local_c]             # 0045d4d0
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045d4d4
    mov word ptr [ebp - local_c], ax             # 0045d4d8
L_0045d4dc:
    # block 0x0045d4dc: entered by jmp at 0x0045d4ce, 8 instruction(s), ends with jge to 0x0045d54d (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045d4dc
    mov edx, dword ptr [ebp - local_4]           # 0045d4e0
    movsx eax, word ptr [edx + field_23]         # 0045d4e3
    movsx edx, word ptr [0x6247ea]               # 0045d4e7
    {load} sub eax, edx                          # 0045d4ee
    sub eax, 0x1                                 # 0045d4f0
    {load} cmp ecx, eax                          # 0045d4f3
    jge.d8 L_0045d54d                            # 0045d4f5
    # block 0x0045d4f7: entered by fall-through of jge at 0x0045d4f5, 24 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d4d0
    lea eax, [ebp - local_1c]                    # 0045d4f7
    push eax                                     # 0045d4fa
    movsx ecx, word ptr [ebp - local_c]          # 0045d4fb
    shl ecx, 0x4                                 # 0045d4ff
    mov edx, dword ptr [ebp - local_4]           # 0045d502
    lea eax, [edx + ecx + field_25d]             # 0045d505
    push eax                                     # 0045d50c
    mov ecx, 0x624734                            # 0045d50d
    call FUN_0045b568                            # 0045d512
    push 0x54ac68                                # 0045d517
    lea ecx, [ebp - local_1c]                    # 0045d51c
    push ecx                                     # 0045d51f
    mov edx, dword ptr [ebp - local_4]           # 0045d520
    add edx, 0x43d                               # 0045d523
    push edx                                     # 0045d529
    mov eax, dword ptr [0x5cf665]                # 0045d52a
    push eax                                     # 0045d52f
    movsx ecx, word ptr [0x624750]               # 0045d530
    imul ecx, ecx, 0x4a                          # 0045d537
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d53a
    push edx                                     # 0045d540
    mov ecx, 0x5cf659                            # 0045d541
    call FUN_004c5377                            # 0045d546
    jmp.d8 L_0045d4d0                            # 0045d54b
L_0045d54d:
    # block 0x0045d54d: entered by jge at 0x0045d4f5, 2 instruction(s), ends with forward jump to 0x0045d561
    mov word ptr [ebp - local_c], 0x0            # 0045d54d
    jmp.d8 L_0045d561                            # 0045d553
L_0045d555:
    # block 0x0045d555: entered by jmp at 0x0045d5c4, 3 instruction(s), falls into the block at 0x0045d561
    mov ax, word ptr [ebp - local_c]             # 0045d555
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045d559
    mov word ptr [ebp - local_c], ax             # 0045d55d
L_0045d561:
    # block 0x0045d561: entered by jmp at 0x0045d553, 4 instruction(s), ends with jge to 0x0045d5c6 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045d561
    movsx edx, word ptr [0x6247ec]               # 0045d565
    {load} cmp ecx, edx                          # 0045d56c
    jge.d8 L_0045d5c6                            # 0045d56e
    # block 0x0045d570: entered by fall-through of jge at 0x0045d56e, 24 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d555
    lea eax, [ebp - local_1c]                    # 0045d570
    push eax                                     # 0045d573
    movsx ecx, word ptr [ebp - local_c]          # 0045d574
    shl ecx, 0x4                                 # 0045d578
    mov edx, dword ptr [ebp - local_4]           # 0045d57b
    lea eax, [edx + ecx + field_2bd]             # 0045d57e
    push eax                                     # 0045d585
    mov ecx, 0x624734                            # 0045d586
    call FUN_0045b568                            # 0045d58b
    push 0x54ac80                                # 0045d590
    lea ecx, [ebp - local_1c]                    # 0045d595
    push ecx                                     # 0045d598
    mov edx, dword ptr [ebp - local_4]           # 0045d599
    add edx, 0x44d                               # 0045d59c
    push edx                                     # 0045d5a2
    mov eax, dword ptr [0x5cf665]                # 0045d5a3
    push eax                                     # 0045d5a8
    movsx ecx, word ptr [0x624750]               # 0045d5a9
    imul ecx, ecx, 0x4a                          # 0045d5b0
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d5b3
    push edx                                     # 0045d5b9
    mov ecx, 0x5cf659                            # 0045d5ba
    call FUN_004c5377                            # 0045d5bf
    jmp.d8 L_0045d555                            # 0045d5c4
L_0045d5c6:
    # block 0x0045d5c6: entered by jge at 0x0045d56e, 2 instruction(s), ends with forward jump to 0x0045d5da
    mov word ptr [ebp - local_c], 0x0            # 0045d5c6
    jmp.d8 L_0045d5da                            # 0045d5cc
L_0045d5ce:
    # block 0x0045d5ce: entered by jmp at 0x0045d63d, 3 instruction(s), falls into the block at 0x0045d5da
    mov ax, word ptr [ebp - local_c]             # 0045d5ce
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045d5d2
    mov word ptr [ebp - local_c], ax             # 0045d5d6
L_0045d5da:
    # block 0x0045d5da: entered by jmp at 0x0045d5cc, 4 instruction(s), ends with jge to 0x0045d63f (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045d5da
    movsx edx, word ptr [0x6247ea]               # 0045d5de
    {load} cmp ecx, edx                          # 0045d5e5
    jge.d8 L_0045d63f                            # 0045d5e7
    # block 0x0045d5e9: entered by fall-through of jge at 0x0045d5e7, 24 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with backward jump to 0x0045d5ce
    lea eax, [ebp - local_1c]                    # 0045d5e9
    push eax                                     # 0045d5ec
    movsx ecx, word ptr [ebp - local_c]          # 0045d5ed
    shl ecx, 0x4                                 # 0045d5f1
    mov edx, dword ptr [ebp - local_4]           # 0045d5f4
    lea eax, [edx + ecx + field_1fd]             # 0045d5f7
    push eax                                     # 0045d5fe
    mov ecx, 0x624734                            # 0045d5ff
    call FUN_0045b568                            # 0045d604
    push 0x54ac98                                # 0045d609
    lea ecx, [ebp - local_1c]                    # 0045d60e
    push ecx                                     # 0045d611
    mov edx, dword ptr [ebp - local_4]           # 0045d612
    add edx, 0x45d                               # 0045d615
    push edx                                     # 0045d61b
    mov eax, dword ptr [0x5cf665]                # 0045d61c
    push eax                                     # 0045d621
    movsx ecx, word ptr [0x624750]               # 0045d622
    imul ecx, ecx, 0x4a                          # 0045d629
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d62c
    push edx                                     # 0045d632
    mov ecx, 0x5cf659                            # 0045d633
    call FUN_004c5377                            # 0045d638
    jmp.d8 L_0045d5ce                            # 0045d63d
L_0045d63f:
    # block 0x0045d63f: entered by jge at 0x0045d5e7, 2 instruction(s), ends with je to 0x0045d69a (forward)
    cmp dword ptr [0x624848], 0x0                # 0045d63f
    je.d8 L_0045d69a                             # 0045d646
    # block 0x0045d648: entered by fall-through of je at 0x0045d646, 20 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045d69a
    lea eax, [ebp - local_1c]                    # 0045d648
    push eax                                     # 0045d64b
    push 0x624840                                # 0045d64c
    mov ecx, 0x624734                            # 0045d651
    call FUN_0045b568                            # 0045d656
    push 0x54acac                                # 0045d65b
    lea ecx, [ebp - local_1c]                    # 0045d660
    push ecx                                     # 0045d663
    push 0x624840                                # 0045d664
    mov edx, dword ptr [0x5cf665]                # 0045d669
    push edx                                     # 0045d66f
    mov eax, dword ptr [0x5d15e3]                # 0045d670
    push eax                                     # 0045d675
    mov ecx, 0x5cf659                            # 0045d676
    call FUN_004c5377                            # 0045d67b
    {load} xor ecx, ecx                          # 0045d680
    mov dword ptr [0x624840], ecx                # 0045d682
    mov dword ptr [0x624844], ecx                # 0045d688
    mov dword ptr [0x624848], ecx                # 0045d68e
    mov dword ptr [0x62484c], ecx                # 0045d694
L_0045d69a:
    # block 0x0045d69a: entered by je at 0x0045d646, 3 instruction(s), ends with je to 0x0045d6c2 (forward)
    movsx edx, word ptr [0x6247ee]               # 0045d69a
    test edx, edx                                # 0045d6a1
    je.d8 L_0045d6c2                             # 0045d6a3
    # block 0x0045d6a5: entered by fall-through of je at 0x0045d6a3, 3 instruction(s), ends with jne to 0x0045d755 (forward)
    movsx eax, word ptr [0x6247ee]               # 0045d6a5
    cmp eax, 0x1                                 # 0045d6ac
    jne.d32 L_0045d755                           # 0045d6af
    # block 0x0045d6b5: entered by fall-through of jne at 0x0045d6af, 2 instruction(s), ends with je to 0x0045d755 (forward)
    cmp dword ptr [0x624892], 0x0                # 0045d6b5
    je.d32 L_0045d755                            # 0045d6bc
L_0045d6c2:
    # block 0x0045d6c2: entered by je at 0x0045d6a3; fall-through of je at 0x0045d6bc, 41 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with forward jump to 0x0045d7ef
    lea ecx, [ebp - local_1c]                    # 0045d6c2
    push ecx                                     # 0045d6c5
    mov edx, dword ptr [ebp - local_4]           # 0045d6c6
    add edx, 0x34d                               # 0045d6c9
    push edx                                     # 0045d6cf
    mov ecx, 0x624734                            # 0045d6d0
    call FUN_0045b568                            # 0045d6d5
    push 0x54accc                                # 0045d6da
    lea eax, [ebp - local_1c]                    # 0045d6df
    push eax                                     # 0045d6e2
    mov ecx, dword ptr [ebp - local_4]           # 0045d6e3
    add ecx, 0x49d                               # 0045d6e6
    push ecx                                     # 0045d6ec
    mov edx, dword ptr [0x5cf665]                # 0045d6ed
    push edx                                     # 0045d6f3
    movsx eax, word ptr [0x624750]               # 0045d6f4
    imul eax, eax, 0x4a                          # 0045d6fb
    mov ecx, dword ptr [eax + 0x5d1599]          # 0045d6fe
    push ecx                                     # 0045d704
    mov ecx, 0x5cf659                            # 0045d705
    call FUN_004c5377                            # 0045d70a
    lea edx, [ebp - local_1c]                    # 0045d70f
    push edx                                     # 0045d712
    mov eax, dword ptr [ebp - local_4]           # 0045d713
    add eax, 0x35d                               # 0045d716
    push eax                                     # 0045d71b
    mov ecx, 0x624734                            # 0045d71c
    call FUN_0045b568                            # 0045d721
    push 0x54ace0                                # 0045d726
    lea ecx, [ebp - local_1c]                    # 0045d72b
    push ecx                                     # 0045d72e
    mov edx, dword ptr [ebp - local_4]           # 0045d72f
    add edx, 0x35d                               # 0045d732
    push edx                                     # 0045d738
    mov eax, dword ptr [0x5cf665]                # 0045d739
    push eax                                     # 0045d73e
    mov ecx, dword ptr [0x5d15e3]                # 0045d73f
    push ecx                                     # 0045d745
    mov ecx, 0x5cf659                            # 0045d746
    call FUN_004c5377                            # 0045d74b
    jmp.d32 L_0045d7ef                           # 0045d750
L_0045d755:
    # block 0x0045d755: entered by jne at 0x0045d6af; je at 0x0045d6bc, 2 instruction(s), ends with je to 0x0045d7ef (forward)
    cmp dword ptr [0x624892], 0x0                # 0045d755
    je.d32 L_0045d7ef                            # 0045d75c
    # block 0x0045d762: entered by fall-through of je at 0x0045d75c, 40 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045d7ef
    lea edx, [ebp - local_1c]                    # 0045d762
    push edx                                     # 0045d765
    mov eax, dword ptr [ebp - local_4]           # 0045d766
    add eax, 0x35d                               # 0045d769
    push eax                                     # 0045d76e
    mov ecx, 0x624734                            # 0045d76f
    call FUN_0045b568                            # 0045d774
    push 0x54acfc                                # 0045d779
    lea ecx, [ebp - local_1c]                    # 0045d77e
    push ecx                                     # 0045d781
    mov edx, dword ptr [ebp - local_4]           # 0045d782
    add edx, 0x4ad                               # 0045d785
    push edx                                     # 0045d78b
    mov eax, dword ptr [0x5cf665]                # 0045d78c
    push eax                                     # 0045d791
    movsx ecx, word ptr [0x624750]               # 0045d792
    imul ecx, ecx, 0x4a                          # 0045d799
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d79c
    push edx                                     # 0045d7a2
    mov ecx, 0x5cf659                            # 0045d7a3
    call FUN_004c5377                            # 0045d7a8
    lea eax, [ebp - local_1c]                    # 0045d7ad
    push eax                                     # 0045d7b0
    mov ecx, dword ptr [ebp - local_4]           # 0045d7b1
    add ecx, 0x34d                               # 0045d7b4
    push ecx                                     # 0045d7ba
    mov ecx, 0x624734                            # 0045d7bb
    call FUN_0045b568                            # 0045d7c0
    push 0x54ad10                                # 0045d7c5
    lea edx, [ebp - local_1c]                    # 0045d7ca
    push edx                                     # 0045d7cd
    mov eax, dword ptr [ebp - local_4]           # 0045d7ce
    add eax, 0x34d                               # 0045d7d1
    push eax                                     # 0045d7d6
    mov ecx, dword ptr [0x5cf665]                # 0045d7d7
    push ecx                                     # 0045d7dd
    mov edx, dword ptr [0x5d15e3]                # 0045d7de
    push edx                                     # 0045d7e4
    mov ecx, 0x5cf659                            # 0045d7e5
    call FUN_004c5377                            # 0045d7ea
L_0045d7ef:
    # block 0x0045d7ef: entered by jmp at 0x0045d750; je at 0x0045d75c, 3 instruction(s), ends with je to 0x0045d806 (forward)
    movsx eax, word ptr [0x6247ee]               # 0045d7ef
    test eax, eax                                # 0045d7f6
    je.d8 L_0045d806                             # 0045d7f8
    # block 0x0045d7fa: entered by fall-through of je at 0x0045d7f8, 3 instruction(s), ends with jne to 0x0045d853 (forward)
    movsx ecx, word ptr [0x6247ee]               # 0045d7fa
    cmp ecx, 0x2                                 # 0045d801
    jne.d8 L_0045d853                            # 0045d804
L_0045d806:
    # block 0x0045d806: entered by je at 0x0045d7f8; fall-through of jne at 0x0045d804, 22 instruction(s), calls FUN_0045b568, FUN_004c5377, ends with forward jump to 0x0045d895
    lea edx, [ebp - local_1c]                    # 0045d806
    push edx                                     # 0045d809
    mov eax, dword ptr [ebp - local_4]           # 0045d80a
    add eax, 0x32d                               # 0045d80d
    push eax                                     # 0045d812
    mov ecx, 0x624734                            # 0045d813
    call FUN_0045b568                            # 0045d818
    push 0x54ad2c                                # 0045d81d
    lea ecx, [ebp - local_1c]                    # 0045d822
    push ecx                                     # 0045d825
    mov edx, dword ptr [ebp - local_4]           # 0045d826
    add edx, 0x4bd                               # 0045d829
    push edx                                     # 0045d82f
    mov eax, dword ptr [0x5cf665]                # 0045d830
    push eax                                     # 0045d835
    movsx ecx, word ptr [0x624750]               # 0045d836
    imul ecx, ecx, 0x4a                          # 0045d83d
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d840
    push edx                                     # 0045d846
    mov ecx, 0x5cf659                            # 0045d847
    call FUN_004c5377                            # 0045d84c
    jmp.d8 L_0045d895                            # 0045d851
L_0045d853:
    # block 0x0045d853: entered by jne at 0x0045d804, 19 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045d895
    lea eax, [ebp - local_1c]                    # 0045d853
    push eax                                     # 0045d856
    mov ecx, dword ptr [ebp - local_4]           # 0045d857
    add ecx, 0x32d                               # 0045d85a
    push ecx                                     # 0045d860
    mov ecx, 0x624734                            # 0045d861
    call FUN_0045b568                            # 0045d866
    push 0x54ad48                                # 0045d86b
    lea edx, [ebp - local_1c]                    # 0045d870
    push edx                                     # 0045d873
    mov eax, dword ptr [ebp - local_4]           # 0045d874
    add eax, 0x32d                               # 0045d877
    push eax                                     # 0045d87c
    mov ecx, dword ptr [0x5cf665]                # 0045d87d
    push ecx                                     # 0045d883
    mov edx, dword ptr [0x5d15e3]                # 0045d884
    push edx                                     # 0045d88a
    mov ecx, 0x5cf659                            # 0045d88b
    call FUN_004c5377                            # 0045d890
L_0045d895:
    # block 0x0045d895: entered by jmp at 0x0045d851, 2 instruction(s), ends with je to 0x0045d950 (forward)
    cmp dword ptr [0x62475c], 0x0                # 0045d895
    je.d32 L_0045d950                            # 0045d89c
    # block 0x0045d8a2: entered by fall-through of je at 0x0045d89c, 13 instruction(s), calls FUN_0045b568, ends with je to 0x0045d913 (forward)
    mov ax, word ptr [0x624760]                  # 0045d8a2
    mov word ptr [ebp - local_8], ax             # 0045d8a8
    lea ecx, [ebp - local_1c]                    # 0045d8ac
    push ecx                                     # 0045d8af
    movsx edx, word ptr [ebp - local_8]          # 0045d8b0
    shl edx, 0x4                                 # 0045d8b4
    mov eax, dword ptr [ebp - local_4]           # 0045d8b7
    lea ecx, [eax + edx + field_31d]             # 0045d8ba
    push ecx                                     # 0045d8c1
    mov ecx, 0x624734                            # 0045d8c2
    call FUN_0045b568                            # 0045d8c7
    cmp dword ptr [0x624766], 0x0                # 0045d8cc
    je.d8 L_0045d913                             # 0045d8d3
    # block 0x0045d8d5: entered by fall-through of je at 0x0045d8d3, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0045d950
    push 0x54ad5c                                # 0045d8d5
    lea edx, [ebp - local_1c]                    # 0045d8da
    push edx                                     # 0045d8dd
    movsx eax, word ptr [ebp - local_8]          # 0045d8de
    shl eax, 0x4                                 # 0045d8e2
    mov ecx, dword ptr [ebp - local_4]           # 0045d8e5
    lea edx, [ecx + eax + field_46d]             # 0045d8e8
    push edx                                     # 0045d8ef
    mov eax, dword ptr [0x5cf665]                # 0045d8f0
    push eax                                     # 0045d8f5
    movsx ecx, word ptr [0x624750]               # 0045d8f6
    imul ecx, ecx, 0x4a                          # 0045d8fd
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d900
    push edx                                     # 0045d906
    mov ecx, 0x5cf659                            # 0045d907
    call FUN_004c5d4b                            # 0045d90c
    jmp.d8 L_0045d950                            # 0045d911
L_0045d913:
    # block 0x0045d913: entered by je at 0x0045d8d3, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x0045d950
    push 0x54ad88                                # 0045d913
    lea eax, [ebp - local_1c]                    # 0045d918
    push eax                                     # 0045d91b
    movsx ecx, word ptr [ebp - local_8]          # 0045d91c
    shl ecx, 0x4                                 # 0045d920
    mov edx, dword ptr [ebp - local_4]           # 0045d923
    lea eax, [edx + ecx + field_31d]             # 0045d926
    push eax                                     # 0045d92d
    mov ecx, dword ptr [0x5cf665]                # 0045d92e
    push ecx                                     # 0045d934
    mov edx, dword ptr [0x5d15e3]                # 0045d935
    push edx                                     # 0045d93b
    mov ecx, 0x5cf659                            # 0045d93c
    call FUN_004c5377                            # 0045d941
    mov dword ptr [0x62475c], 0x0                # 0045d946
L_0045d950:
    # block 0x0045d950: entered by je at 0x0045d89c; jmp at 0x0045d911, 2 instruction(s), ends with jne to 0x0045da1c (forward)
    cmp dword ptr [0x624896], 0x0                # 0045d950
    jne.d32 L_0045da1c                           # 0045d957
    # block 0x0045d95d: entered by fall-through of jne at 0x0045d957, 2 instruction(s), ends with jne to 0x0045d97a (forward)
    cmp dword ptr [0x624758], 0x6                # 0045d95d
    jne.d8 L_0045d97a                            # 0045d964
    # block 0x0045d966: entered by fall-through of jne at 0x0045d964, 2 instruction(s), ends with jne to 0x0045d9bc (forward)
    cmp dword ptr [0x624758], 0x6                # 0045d966
    jne.d8 L_0045d9bc                            # 0045d96d
    # block 0x0045d96f: entered by fall-through of jne at 0x0045d96d, 3 instruction(s), ends with jne to 0x0045d9bc (forward)
    movsx eax, word ptr [0x624890]               # 0045d96f
    test eax, eax                                # 0045d976
    jne.d8 L_0045d9bc                            # 0045d978
L_0045d97a:
    # block 0x0045d97a: entered by jne at 0x0045d964; fall-through of jne at 0x0045d978, 17 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045d9bc
    lea ecx, [ebp - local_1c]                    # 0045d97a
    push ecx                                     # 0045d97d
    push 0x6247f0                                # 0045d97e
    mov ecx, 0x624734                            # 0045d983
    call FUN_0045b568                            # 0045d988
    push 0x54adac                                # 0045d98d
    lea edx, [ebp - local_1c]                    # 0045d992
    push edx                                     # 0045d995
    push 0x624820                                # 0045d996
    mov eax, dword ptr [0x5cf665]                # 0045d99b
    push eax                                     # 0045d9a0
    movsx ecx, word ptr [0x624750]               # 0045d9a1
    imul ecx, ecx, 0x4a                          # 0045d9a8
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045d9ab
    push edx                                     # 0045d9b1
    mov ecx, 0x5cf659                            # 0045d9b2
    call FUN_004c5377                            # 0045d9b7
L_0045d9bc:
    # block 0x0045d9bc: entered by jne at 0x0045d96d; jne at 0x0045d978, 2 instruction(s), ends with jne to 0x0045d9da (forward)
    cmp dword ptr [0x624758], 0x6                # 0045d9bc
    jne.d8 L_0045d9da                            # 0045d9c3
    # block 0x0045d9c5: entered by fall-through of jne at 0x0045d9c3, 2 instruction(s), ends with jne to 0x0045da1c (forward)
    cmp dword ptr [0x624758], 0x6                # 0045d9c5
    jne.d8 L_0045da1c                            # 0045d9cc
    # block 0x0045d9ce: entered by fall-through of jne at 0x0045d9cc, 3 instruction(s), ends with jne to 0x0045da1c (forward)
    movsx eax, word ptr [0x624890]               # 0045d9ce
    cmp eax, 0x1                                 # 0045d9d5
    jne.d8 L_0045da1c                            # 0045d9d8
L_0045d9da:
    # block 0x0045d9da: entered by jne at 0x0045d9c3; fall-through of jne at 0x0045d9d8, 17 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045da1c
    lea ecx, [ebp - local_1c]                    # 0045d9da
    push ecx                                     # 0045d9dd
    push 0x624800                                # 0045d9de
    mov ecx, 0x624734                            # 0045d9e3
    call FUN_0045b568                            # 0045d9e8
    push 0x54adc8                                # 0045d9ed
    lea edx, [ebp - local_1c]                    # 0045d9f2
    push edx                                     # 0045d9f5
    push 0x624830                                # 0045d9f6
    mov eax, dword ptr [0x5cf665]                # 0045d9fb
    push eax                                     # 0045da00
    movsx ecx, word ptr [0x624750]               # 0045da01
    imul ecx, ecx, 0x4a                          # 0045da08
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045da0b
    push edx                                     # 0045da11
    mov ecx, 0x5cf659                            # 0045da12
    call FUN_004c5377                            # 0045da17
L_0045da1c:
    # block 0x0045da1c: entered by jne at 0x0045d957; jne at 0x0045d9cc; jne at 0x0045d9d8, 2 instruction(s), ends with je to 0x0045da77 (forward)
    cmp dword ptr [0x624818], 0x0                # 0045da1c
    je.d8 L_0045da77                             # 0045da23
    # block 0x0045da25: entered by fall-through of je at 0x0045da23, 20 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045da77
    lea eax, [ebp - local_1c]                    # 0045da25
    push eax                                     # 0045da28
    push 0x624810                                # 0045da29
    mov ecx, 0x624734                            # 0045da2e
    call FUN_0045b568                            # 0045da33
    push 0x54ade8                                # 0045da38
    lea ecx, [ebp - local_1c]                    # 0045da3d
    push ecx                                     # 0045da40
    push 0x624810                                # 0045da41
    mov edx, dword ptr [0x5cf665]                # 0045da46
    push edx                                     # 0045da4c
    mov eax, dword ptr [0x5d15e3]                # 0045da4d
    push eax                                     # 0045da52
    mov ecx, 0x5cf659                            # 0045da53
    call FUN_004c5377                            # 0045da58
    {load} xor ecx, ecx                          # 0045da5d
    mov dword ptr [0x624810], ecx                # 0045da5f
    mov dword ptr [0x624814], ecx                # 0045da65
    mov dword ptr [0x624818], ecx                # 0045da6b
    mov dword ptr [0x62481c], ecx                # 0045da71
L_0045da77:
    # block 0x0045da77: entered by je at 0x0045da23, 2 instruction(s), ends with jne to 0x0045db66 (forward)
    cmp dword ptr [0x624758], 0x9                # 0045da77
    jne.d32 L_0045db66                           # 0045da7e
    # block 0x0045da84: entered by fall-through of jne at 0x0045da7e, 60 instruction(s), calls FUN_0045b568, FUN_004c5377, falls into the block at 0x0045db66
    lea edx, [ebp - local_1c]                    # 0045da84
    push edx                                     # 0045da87
    push 0x624850                                # 0045da88
    mov ecx, 0x624734                            # 0045da8d
    call FUN_0045b568                            # 0045da92
    push 0x54ae08                                # 0045da97
    lea eax, [ebp - local_1c]                    # 0045da9c
    push eax                                     # 0045da9f
    push 0x624850                                # 0045daa0
    mov ecx, dword ptr [0x5cf665]                # 0045daa5
    push ecx                                     # 0045daab
    mov edx, dword ptr [0x5d15e3]                # 0045daac
    push edx                                     # 0045dab2
    mov ecx, 0x5cf659                            # 0045dab3
    call FUN_004c5377                            # 0045dab8
    lea eax, [ebp - local_1c]                    # 0045dabd
    push eax                                     # 0045dac0
    push 0x624860                                # 0045dac1
    mov ecx, 0x624734                            # 0045dac6
    call FUN_0045b568                            # 0045dacb
    push 0x54ae34                                # 0045dad0
    lea ecx, [ebp - local_1c]                    # 0045dad5
    push ecx                                     # 0045dad8
    push 0x624860                                # 0045dad9
    mov edx, dword ptr [0x5cf665]                # 0045dade
    push edx                                     # 0045dae4
    mov eax, dword ptr [0x5d15e3]                # 0045dae5
    push eax                                     # 0045daea
    mov ecx, 0x5cf659                            # 0045daeb
    call FUN_004c5377                            # 0045daf0
    lea ecx, [ebp - local_1c]                    # 0045daf5
    push ecx                                     # 0045daf8
    push 0x624870                                # 0045daf9
    mov ecx, 0x624734                            # 0045dafe
    call FUN_0045b568                            # 0045db03
    push 0x54ae64                                # 0045db08
    lea edx, [ebp - local_1c]                    # 0045db0d
    push edx                                     # 0045db10
    push 0x624870                                # 0045db11
    mov eax, dword ptr [0x5cf665]                # 0045db16
    push eax                                     # 0045db1b
    mov ecx, dword ptr [0x5d15e3]                # 0045db1c
    push ecx                                     # 0045db22
    mov ecx, 0x5cf659                            # 0045db23
    call FUN_004c5377                            # 0045db28
    lea edx, [ebp - local_1c]                    # 0045db2d
    push edx                                     # 0045db30
    push 0x624880                                # 0045db31
    mov ecx, 0x624734                            # 0045db36
    call FUN_0045b568                            # 0045db3b
    push 0x54ae88                                # 0045db40
    lea eax, [ebp - local_1c]                    # 0045db45
    push eax                                     # 0045db48
    push 0x624880                                # 0045db49
    mov ecx, dword ptr [0x5cf665]                # 0045db4e
    push ecx                                     # 0045db54
    mov edx, dword ptr [0x5d15e3]                # 0045db55
    push edx                                     # 0045db5b
    mov ecx, 0x5cf659                            # 0045db5c
    call FUN_004c5377                            # 0045db61
L_0045db66:
    # block 0x0045db66: entered by jne at 0x0045da7e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045db66
    pop ebp                                      # 0045db68
    ret                                          # 0045db69

# --- data items (not part of the function) -------------------------
.org 0x0045db6a - 0x401000
PAD_0045db6a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

