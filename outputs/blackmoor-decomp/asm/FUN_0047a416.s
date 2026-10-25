# FUN_0047a416
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047a416
# extent:       0x0047a416-0x0047ac0b (2037 code bytes)
# span:         0x0047a416-0x0047ac23 (code 2037, tables 24, padding 0)
# sha256:       f76e64f72f5f1438398e9b624a36f1b81fd31de2effb577345d5cfb6f545452f
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047a416
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_1c, field_24, field_25, field_bc, field_226, field_22c, field_236, field_23e, field_262, field_272, field_276, field_27e and 7 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_24, field_c0, field_226, field_22a, field_232, field_23c and 12 more; [edx + n] field_4, field_8, field_c, field_1c, field_24, field_b8, field_c4, field_1e5, field_228, field_22e, field_23a, field_23c and 9 more
# callees:      calls FUN_004e8d96, FUN_00478f91, FUN_00478e7b, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_0047a3d9, FUN_004f6334, FUN_00478915, FUN_00478a2c, FUN_0047a1a9, FUN_00478684, FUN_004fb2e3, FUN_0047a28c, FUN_004fba69 and 2 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 484 instruction(s), 38 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c4, 0xc4  # offset +0xc4
.equ field_1e5, 0x1e5  # offset +0x1e5
.equ field_226, 0x226  # offset +0x226
.equ field_228, 0x228  # offset +0x228
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22c, 0x22c  # offset +0x22c
.equ field_22e, 0x22e  # offset +0x22e
.equ field_232, 0x232  # offset +0x232
.equ field_236, 0x236  # offset +0x236
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23c, 0x23c  # offset +0x23c
.equ field_23e, 0x23e  # offset +0x23e
.equ field_23f, 0x23f  # offset +0x23f
.equ field_262, 0x262  # offset +0x262
.equ field_272, 0x272  # offset +0x272
.equ field_274, 0x274  # offset +0x274
.equ field_276, 0x276  # offset +0x276
.equ field_278, 0x278  # offset +0x278
.equ field_27a, 0x27a  # offset +0x27a
.equ field_27e, 0x27e  # offset +0x27e
.equ field_282, 0x282  # offset +0x282
.equ field_286, 0x286  # offset +0x286
.equ field_288, 0x288  # offset +0x288
.equ field_28a, 0x28a  # offset +0x28a
.equ field_1528, 0x1528  # offset +0x1528
.equ field_152c, 0x152c  # offset +0x152c
.equ field_152e, 0x152e  # offset +0x152e
.equ field_1532, 0x1532  # offset +0x1532
.equ field_1576, 0x1576  # offset +0x1576
.equ field_157a, 0x157a  # offset +0x157a
.equ field_157e, 0x157e  # offset +0x157e
.equ field_1582, 0x1582  # offset +0x1582
.equ field_1586, 0x1586  # offset +0x1586
.equ field_158a, 0x158a  # offset +0x158a
.equ field_159a, 0x159a  # offset +0x159a
.equ field_159c, 0x159c  # offset +0x159c
.equ field_159e, 0x159e  # offset +0x159e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0047823e, .text + (0x0047823e - 0x401000)
.set FUN_00478684, .text + (0x00478684 - 0x401000)
.set FUN_00478915, .text + (0x00478915 - 0x401000)
.set FUN_00478a2c, .text + (0x00478a2c - 0x401000)
.set FUN_00478e7b, .text + (0x00478e7b - 0x401000)
.set FUN_00478f91, .text + (0x00478f91 - 0x401000)
.set FUN_0047a1a9, .text + (0x0047a1a9 - 0x401000)
.set FUN_0047a28c, .text + (0x0047a28c - 0x401000)
.set FUN_0047a3d9, .text + (0x0047a3d9 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0047a416 - 0x401000
.globl FUN_0047a416
FUN_0047a416:
    # block 0x0047a416: entry, 16 instruction(s), ends with je to 0x0047a466 (forward)
    push ebp                                     # 0047a416
    {load} mov ebp, esp                          # 0047a417
    sub esp, 0x20                                # 0047a419
    push esi                                     # 0047a41c
    push edi                                     # 0047a41d
    mov dword ptr [ebp - local_10], ecx          # 0047a41e
    movsx eax, word ptr [ebp + arg_8]            # 0047a421
    imul eax, eax, 0x8d                          # 0047a425
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0047a42b
    mov dword ptr [ebp - local_4], ecx           # 0047a431
    movsx edx, word ptr [ebp + arg_8]            # 0047a434
    imul edx, edx, 0x8d                          # 0047a438
    mov eax, dword ptr [edx + 0x5bb632]          # 0047a43e
    mov dword ptr [ebp - local_14], eax          # 0047a444
    cmp dword ptr [ebp - local_14], 0x0          # 0047a447
    je.d8 L_0047a466                             # 0047a44b
    # block 0x0047a44d: entered by fall-through of je at 0x0047a44b, 2 instruction(s), ends with je to 0x0047a6f8 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 0047a44d
    je.d32 L_0047a6f8                            # 0047a451
    # block 0x0047a457: entered by fall-through of je at 0x0047a451, 2 instruction(s), ends with je to 0x0047a993 (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 0047a457
    je.d32 L_0047a993                            # 0047a45b
    # block 0x0047a461: entered by fall-through of je at 0x0047a45b, 1 instruction(s), ends with forward jump to 0x0047ac03
    jmp.d32 L_0047ac03                           # 0047a461
L_0047a466:
    # block 0x0047a466: entered by je at 0x0047a44b, 23 instruction(s), calls FUN_004e8d96, ends with je to 0x0047a4ee (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047a466
    mov dx, word ptr [ebp + arg_8]               # 0047a469
    mov word ptr [ecx + field_1e], dx            # 0047a46d
    mov eax, dword ptr [ebp - local_10]          # 0047a471
    mov dword ptr [eax + field_157a], 0x1        # 0047a474
    mov dword ptr [0x5bb1ca], 0x1                # 0047a47e
    mov ecx, 0x571442                            # 0047a488
    call FUN_004e8d96                            # 0047a48d
    mov ecx, dword ptr [ebp - local_4]           # 0047a492
    mov edx, dword ptr [ebp - local_4]           # 0047a495
    mov eax, dword ptr [ecx + field_c0]          # 0047a498
    sub eax, dword ptr [edx + field_b8]          # 0047a49e
    mov ecx, dword ptr [ebp - local_10]          # 0047a4a4
    mov dword ptr [ecx + field_1586], eax        # 0047a4a7
    mov edx, dword ptr [ebp - local_4]           # 0047a4ad
    mov eax, dword ptr [ebp - local_4]           # 0047a4b0
    mov ecx, dword ptr [edx + field_c4]          # 0047a4b3
    sub ecx, dword ptr [eax + field_bc]          # 0047a4b9
    mov edx, dword ptr [ebp - local_10]          # 0047a4bf
    mov dword ptr [edx + field_158a], ecx        # 0047a4c2
    movsx eax, word ptr [0x5957bd]               # 0047a4c8
    cmp dword ptr [0x5bb57b], eax                # 0047a4cf
    je.d8 L_0047a4ee                             # 0047a4d5
    # block 0x0047a4d7: entered by fall-through of je at 0x0047a4d5, 3 instruction(s), falls into the block at 0x0047a4ee
    mov word ptr [0x5957bb], 0x0                 # 0047a4d7
    mov cx, word ptr [0x5bb57b]                  # 0047a4e0
    mov word ptr [0x5a0561], cx                  # 0047a4e7
L_0047a4ee:
    # block 0x0047a4ee: entered by je at 0x0047a4d5, 78 instruction(s), calls FUN_00478f91, FUN_00478e7b, FUN_004d39f9, ends with jne to 0x0047a649 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047a4ee
    call FUN_00478f91                            # 0047a4f1
    mov edx, dword ptr [ebp - local_10]          # 0047a4f6
    mov word ptr [edx + field_159a], 0x0         # 0047a4f9
    mov eax, dword ptr [ebp - local_10]          # 0047a502
    mov word ptr [eax + field_159c], 0x0         # 0047a505
    {load} xor ecx, ecx                          # 0047a50e
    mov edx, dword ptr [ebp - local_10]          # 0047a510
    add edx, 0x1566                              # 0047a513
    mov dword ptr [edx], ecx                     # 0047a519
    mov dword ptr [edx + field_4], ecx           # 0047a51b
    mov dword ptr [edx + field_8], ecx           # 0047a51e
    mov dword ptr [edx + field_c], ecx           # 0047a521
    {load} xor eax, eax                          # 0047a524
    mov ecx, dword ptr [ebp - local_10]          # 0047a526
    add ecx, 0x1528                              # 0047a529
    mov dword ptr [ecx], eax                     # 0047a52f
    mov dword ptr [ecx + field_4], eax           # 0047a531
    mov dword ptr [ecx + field_8], eax           # 0047a534
    mov word ptr [ecx + field_c], ax             # 0047a537
    mov ecx, dword ptr [ebp - local_10]          # 0047a53b
    call FUN_00478e7b                            # 0047a53e
    call FUN_004d39f9                            # 0047a543
    mov edx, dword ptr [ebp - local_10]          # 0047a548
    mov word ptr [edx + field_1c], ax            # 0047a54b
    mov eax, dword ptr [ebp - local_10]          # 0047a54f
    movsx ecx, word ptr [eax + field_1c]         # 0047a552
    imul ecx, ecx, 0x4a                          # 0047a556
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0047a559
    mov edx, dword ptr [ebp - local_10]          # 0047a563
    movsx eax, word ptr [edx + field_1c]         # 0047a566
    imul eax, eax, 0x4a                          # 0047a56a
    mov dword ptr [eax + 0x5d1595], 0x47ac33     # 0047a56d
    mov ecx, dword ptr [ebp - local_10]          # 0047a577
    movsx edx, word ptr [ecx + field_1c]         # 0047a57a
    imul edx, edx, 0x4a                          # 0047a57e
    mov dword ptr [edx + 0x5d1599], 0x0          # 0047a581
    mov eax, dword ptr [ebp - local_10]          # 0047a58b
    movsx ecx, word ptr [eax + field_1c]         # 0047a58e
    imul ecx, ecx, 0x4a                          # 0047a592
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0047a595
    mov edx, dword ptr [ebp - local_10]          # 0047a59f
    movsx eax, word ptr [edx + field_1c]         # 0047a5a2
    imul eax, eax, 0x4a                          # 0047a5a6
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0047a5a9
    mov ecx, dword ptr [ebp - local_10]          # 0047a5b3
    movsx edx, word ptr [ecx + field_1c]         # 0047a5b6
    imul edx, edx, 0x4a                          # 0047a5ba
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0047a5bd
    mov eax, dword ptr [ebp - local_10]          # 0047a5c7
    movsx ecx, word ptr [eax + field_1c]         # 0047a5ca
    imul ecx, ecx, 0x4a                          # 0047a5ce
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 0047a5d1
    mov edx, dword ptr [ebp - local_10]          # 0047a5db
    movsx eax, word ptr [edx + field_1c]         # 0047a5de
    imul eax, eax, 0x4a                          # 0047a5e2
    mov word ptr [eax + 0x5d15ad], 0x0           # 0047a5e5
    mov edi, 0x54cba4                            # 0047a5ee
    mov ecx, dword ptr [ebp - local_10]          # 0047a5f3
    movsx edx, word ptr [ecx + field_1c]         # 0047a5f6
    imul edx, edx, 0x4a                          # 0047a5fa
    add edx, 0x5d15b3                            # 0047a5fd
    or ecx, -0x1                                 # 0047a603
    {load} xor eax, eax                          # 0047a606
    repne scasb al, byte ptr es:[edi]            # 0047a608
    not ecx                                      # 0047a60a
    {load} sub edi, ecx                          # 0047a60c
    {load} mov esi, edi                          # 0047a60e
    {load} mov eax, ecx                          # 0047a610
    {load} mov edi, edx                          # 0047a612
    shr ecx, 0x2                                 # 0047a614
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047a617
    {load} mov ecx, eax                          # 0047a619
    and ecx, 0x3                                 # 0047a61b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047a61e
    mov ecx, dword ptr [ebp - local_10]          # 0047a620
    cmp dword ptr [ecx + field_20], 0x0          # 0047a623
    jne.d8 L_0047a649                            # 0047a627
    # block 0x0047a629: entered by fall-through of jne at 0x0047a627, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0047a649
    push 0x54cbc0                                # 0047a629
    push 0x6                                     # 0047a62e
    mov edx, dword ptr [ebp - local_4]           # 0047a630
    push edx                                     # 0047a633
    push 0x54cbdc                                # 0047a634
    mov ecx, 0x5cf659                            # 0047a639
    call FUN_004c2790                            # 0047a63e
    mov ecx, dword ptr [ebp - local_10]          # 0047a643
    mov dword ptr [ecx + field_20], eax          # 0047a646
L_0047a649:
    # block 0x0047a649: entered by jne at 0x0047a627, 13 instruction(s), ends with je to 0x0047a68c (forward)
    mov edx, dword ptr [ebp - local_10]          # 0047a649
    movsx eax, word ptr [edx + field_1c]         # 0047a64c
    imul eax, eax, 0x4a                          # 0047a650
    mov ecx, dword ptr [ebp - local_10]          # 0047a653
    mov edx, dword ptr [ecx + field_20]          # 0047a656
    mov dword ptr [eax + 0x5d1599], edx          # 0047a659
    mov edi, 0x54cbe4                            # 0047a65f
    mov esi, dword ptr [ebp - local_4]           # 0047a664
    add esi, 0x1c4                               # 0047a667
    mov ecx, 0x9                                 # 0047a66d
    {load} xor eax, eax                          # 0047a672
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a674
    je.d8 L_0047a68c                             # 0047a676
    # block 0x0047a678: entered by fall-through of je at 0x0047a676, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0047a68c
    mov ecx, dword ptr [ebp - local_4]           # 0047a678
    add ecx, 0x1c4                               # 0047a67b
    push ecx                                     # 0047a681
    mov ecx, 0x5c3a67                            # 0047a682
    call FUN_004fb77a                            # 0047a687
L_0047a68c:
    # block 0x0047a68c: entered by je at 0x0047a676, 7 instruction(s), ends with je to 0x0047a6b8 (forward)
    mov edi, 0x54cbf0                            # 0047a68c
    mov esi, dword ptr [ebp - local_4]           # 0047a691
    add esi, 0x1f5                               # 0047a694
    mov ecx, 0x9                                 # 0047a69a
    {load} xor edx, edx                          # 0047a69f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a6a1
    je.d8 L_0047a6b8                             # 0047a6a3
    # block 0x0047a6a5: entered by fall-through of je at 0x0047a6a3, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0047a6b8
    mov eax, dword ptr [ebp - local_4]           # 0047a6a5
    add eax, 0x1f5                               # 0047a6a8
    push eax                                     # 0047a6ad
    mov ecx, 0x5c3a67                            # 0047a6ae
    call FUN_004fb77a                            # 0047a6b3
L_0047a6b8:
    # block 0x0047a6b8: entered by je at 0x0047a6a3, 11 instruction(s), ends with forward jump to 0x0047ac03
    mov ecx, dword ptr [ebp - local_10]          # 0047a6b8
    mov dword ptr [ecx + field_1576], 0x0        # 0047a6bb
    mov edx, dword ptr [ebp - local_10]          # 0047a6c5
    mov dword ptr [edx + field_157e], 0x0        # 0047a6c8
    mov eax, dword ptr [ebp - local_10]          # 0047a6d2
    mov dword ptr [eax + field_24], 0x0          # 0047a6d5
    mov ecx, dword ptr [ebp - local_10]          # 0047a6dc
    movsx edx, word ptr [ecx + field_1e]         # 0047a6df
    imul edx, edx, 0x8d                          # 0047a6e3
    mov dword ptr [edx + 0x5bb632], 0x1          # 0047a6e9
    jmp.d32 L_0047ac03                           # 0047a6f3
L_0047a6f8:
    # block 0x0047a6f8: entered by je at 0x0047a451, 5 instruction(s), ends with ja to 0x0047a98e (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047a6f8
    mov ecx, dword ptr [eax + field_24]          # 0047a6fb
    mov dword ptr [ebp - local_18], ecx          # 0047a6fe
    cmp dword ptr [ebp - local_18], 0x5          # 0047a701
    ja.d32 L_0047a98e                            # 0047a705
    # block 0x0047a70b: entered by fall-through of ja at 0x0047a705, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x47ac0b]
    mov edx, dword ptr [ebp - local_18]          # 0047a70b
    jmp dword ptr [4*edx + SWTAB_0047ac0b_VA]    # 0047a70e
L_0047a715:
    # block 0x0047a715: entered by switch case, 3 instruction(s), ends with je to 0x0047a772 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047a715
    cmp dword ptr [eax + field_1528], 0x0        # 0047a718
    je.d8 L_0047a772                             # 0047a71f
    # block 0x0047a721: entered by fall-through of je at 0x0047a71f, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x0047a770 (forward)
    call dword ptr [0x52a23c]                    # 0047a721
    mov ecx, dword ptr [ebp - local_10]          # 0047a727
    cmp eax, dword ptr [ecx + field_152e]        # 0047a72a
    jbe.d8 L_0047a770                            # 0047a730
    # block 0x0047a732: entered by fall-through of jbe at 0x0047a730, 6 instruction(s), ends with jne to 0x0047a75a (forward)
    mov edx, dword ptr [ebp - local_10]          # 0047a732
    mov dword ptr [edx + field_1532], 0x0        # 0047a735
    mov eax, dword ptr [ebp - local_10]          # 0047a73f
    movsx ecx, word ptr [eax + field_152c]       # 0047a742
    cmp ecx, 0x5                                 # 0047a749
    jne.d8 L_0047a75a                            # 0047a74c
    # block 0x0047a74e: entered by fall-through of jne at 0x0047a74c, 3 instruction(s), ends with forward jump to 0x0047a770
    mov edx, dword ptr [ebp - local_10]          # 0047a74e
    mov dword ptr [edx + field_24], 0x3          # 0047a751
    jmp.d8 L_0047a770                            # 0047a758
L_0047a75a:
    # block 0x0047a75a: entered by jne at 0x0047a74c, 4 instruction(s), falls into the block at 0x0047a770
    mov eax, dword ptr [ebp - local_10]          # 0047a75a
    mov dword ptr [eax + field_24], 0x2          # 0047a75d
    mov ecx, dword ptr [ebp - local_10]          # 0047a764
    mov word ptr [ecx + field_159e], 0x3         # 0047a767
L_0047a770:
    # block 0x0047a770: entered by jbe at 0x0047a730; jmp at 0x0047a758, 1 instruction(s), ends with forward jump to 0x0047a77a
    jmp.d8 L_0047a77a                            # 0047a770
L_0047a772:
    # block 0x0047a772: entered by je at 0x0047a71f, 2 instruction(s), calls FUN_0047a3d9, falls into the block at 0x0047a77a
    mov ecx, dword ptr [ebp - local_10]          # 0047a772
    call FUN_0047a3d9                            # 0047a775
L_0047a77a:
    # block 0x0047a77a: entered by jmp at 0x0047a770, 1 instruction(s), ends with forward jump to 0x0047a98e
    jmp.d32 L_0047a98e                           # 0047a77a
L_0047a77f:
    # block 0x0047a77f: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0047a7b0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047a77f
    movsx eax, word ptr [edx + field_1e5]        # 0047a782
    mov dword ptr [ebp - local_8], eax           # 0047a789
    mov ecx, dword ptr [ebp - local_8]           # 0047a78c
    push ecx                                     # 0047a78f
    mov ecx, 0x5cf1eb                            # 0047a790
    call FUN_004f6334                            # 0047a795
    test eax, eax                                # 0047a79a
    jne.d8 L_0047a7b0                            # 0047a79c
    # block 0x0047a79e: entered by fall-through of jne at 0x0047a79c, 4 instruction(s), calls FUN_00478915, falls into the block at 0x0047a7b0
    mov ecx, dword ptr [ebp - local_10]          # 0047a79e
    call FUN_00478915                            # 0047a7a1
    mov edx, dword ptr [ebp - local_10]          # 0047a7a6
    mov dword ptr [edx + field_24], 0x0          # 0047a7a9
L_0047a7b0:
    # block 0x0047a7b0: entered by jne at 0x0047a79c, 1 instruction(s), ends with forward jump to 0x0047a98e
    jmp.d32 L_0047a98e                           # 0047a7b0
L_0047a7b5:
    # block 0x0047a7b5: entered by switch case, 7 instruction(s), calls FUN_00478a2c, ends with je to 0x0047a8ad (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047a7b5
    mov cx, word ptr [eax + field_159e]          # 0047a7b8
    push ecx                                     # 0047a7bf
    mov ecx, dword ptr [ebp - local_10]          # 0047a7c0
    call FUN_00478a2c                            # 0047a7c3
    test eax, eax                                # 0047a7c8
    je.d32 L_0047a8ad                            # 0047a7ca
    # block 0x0047a7d0: entered by fall-through of je at 0x0047a7ca, 4 instruction(s), calls FUN_0047a1a9, ends with je to 0x0047a7eb (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047a7d0
    call FUN_0047a1a9                            # 0047a7d3
    test eax, eax                                # 0047a7d8
    je.d8 L_0047a7eb                             # 0047a7da
    # block 0x0047a7dc: entered by fall-through of je at 0x0047a7da, 3 instruction(s), ends with forward jump to 0x0047a8ad
    mov edx, dword ptr [ebp - local_10]          # 0047a7dc
    mov dword ptr [edx + field_24], 0x3          # 0047a7df
    jmp.d32 L_0047a8ad                           # 0047a7e6
L_0047a7eb:
    # block 0x0047a7eb: entered by je at 0x0047a7da, 4 instruction(s), ends with jne to 0x0047a86c (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047a7eb
    movsx ecx, word ptr [eax + field_25]         # 0047a7ee
    cmp ecx, 0x2                                 # 0047a7f2
    jne.d8 L_0047a86c                            # 0047a7f5
    # block 0x0047a7f7: entered by fall-through of jne at 0x0047a7f5, 5 instruction(s), ends with je to 0x0047a844 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0047a7f7
    movsx eax, word ptr [edx + field_159e]       # 0047a7fa
    mov dword ptr [ebp - local_1c], eax          # 0047a801
    cmp dword ptr [ebp - local_1c], 0x1          # 0047a804
    je.d8 L_0047a844                             # 0047a808
    # block 0x0047a80a: entered by fall-through of je at 0x0047a808, 2 instruction(s), ends with je to 0x0047a860 (forward)
    cmp dword ptr [ebp - local_1c], 0x2          # 0047a80a
    je.d8 L_0047a860                             # 0047a80e
    # block 0x0047a810: entered by fall-through of je at 0x0047a80e, 2 instruction(s), ends with je to 0x0047a818 (forward)
    cmp dword ptr [ebp - local_1c], 0x3          # 0047a810
    je.d8 L_0047a818                             # 0047a814
    # block 0x0047a816: entered by fall-through of je at 0x0047a814, 1 instruction(s), ends with forward jump to 0x0047a86a
    jmp.d8 L_0047a86a                            # 0047a816
L_0047a818:
    # block 0x0047a818: entered by je at 0x0047a814, 6 instruction(s), calls FUN_00478684, ends with jne to 0x0047a842 (forward)
    push 0x2                                     # 0047a818
    push 0x1                                     # 0047a81a
    mov ecx, dword ptr [ebp - local_10]          # 0047a81c
    call FUN_00478684                            # 0047a81f
    test eax, eax                                # 0047a824
    jne.d8 L_0047a842                            # 0047a826
    # block 0x0047a828: entered by fall-through of jne at 0x0047a826, 6 instruction(s), calls FUN_00478684, ends with jne to 0x0047a842 (forward)
    push 0x1                                     # 0047a828
    push 0x2                                     # 0047a82a
    mov ecx, dword ptr [ebp - local_10]          # 0047a82c
    call FUN_00478684                            # 0047a82f
    test eax, eax                                # 0047a834
    jne.d8 L_0047a842                            # 0047a836
    # block 0x0047a838: entered by fall-through of jne at 0x0047a836, 2 instruction(s), falls into the block at 0x0047a842
    mov ecx, dword ptr [ebp - local_10]          # 0047a838
    mov dword ptr [ecx + field_24], 0x0          # 0047a83b
L_0047a842:
    # block 0x0047a842: entered by jne at 0x0047a826; jne at 0x0047a836, 1 instruction(s), ends with forward jump to 0x0047a86a
    jmp.d8 L_0047a86a                            # 0047a842
L_0047a844:
    # block 0x0047a844: entered by je at 0x0047a808, 6 instruction(s), calls FUN_00478684, ends with jne to 0x0047a85e (forward)
    push 0x1                                     # 0047a844
    push 0x2                                     # 0047a846
    mov ecx, dword ptr [ebp - local_10]          # 0047a848
    call FUN_00478684                            # 0047a84b
    test eax, eax                                # 0047a850
    jne.d8 L_0047a85e                            # 0047a852
    # block 0x0047a854: entered by fall-through of jne at 0x0047a852, 2 instruction(s), falls into the block at 0x0047a85e
    mov edx, dword ptr [ebp - local_10]          # 0047a854
    mov dword ptr [edx + field_24], 0x0          # 0047a857
L_0047a85e:
    # block 0x0047a85e: entered by jne at 0x0047a852, 1 instruction(s), ends with forward jump to 0x0047a86a
    jmp.d8 L_0047a86a                            # 0047a85e
L_0047a860:
    # block 0x0047a860: entered by je at 0x0047a80e, 2 instruction(s), falls into the block at 0x0047a86a
    mov eax, dword ptr [ebp - local_10]          # 0047a860
    mov dword ptr [eax + field_24], 0x0          # 0047a863
L_0047a86a:
    # block 0x0047a86a: entered by jmp at 0x0047a816; jmp at 0x0047a842; jmp at 0x0047a85e, 1 instruction(s), ends with forward jump to 0x0047a8ad
    jmp.d8 L_0047a8ad                            # 0047a86a
L_0047a86c:
    # block 0x0047a86c: entered by jne at 0x0047a7f5, 5 instruction(s), ends with je to 0x0047a8a3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047a86c
    movsx edx, word ptr [ecx + field_159e]       # 0047a86f
    mov dword ptr [ebp - local_20], edx          # 0047a876
    cmp dword ptr [ebp - local_20], 0x1          # 0047a879
    je.d8 L_0047a8a3                             # 0047a87d
    # block 0x0047a87f: entered by fall-through of je at 0x0047a87d, 2 instruction(s), ends with je to 0x0047a887 (forward)
    cmp dword ptr [ebp - local_20], 0x3          # 0047a87f
    je.d8 L_0047a887                             # 0047a883
    # block 0x0047a885: entered by fall-through of je at 0x0047a883, 1 instruction(s), ends with forward jump to 0x0047a8ad
    jmp.d8 L_0047a8ad                            # 0047a885
L_0047a887:
    # block 0x0047a887: entered by je at 0x0047a883, 6 instruction(s), calls FUN_00478684, ends with jne to 0x0047a8a1 (forward)
    push 0x0                                     # 0047a887
    push 0x1                                     # 0047a889
    mov ecx, dword ptr [ebp - local_10]          # 0047a88b
    call FUN_00478684                            # 0047a88e
    test eax, eax                                # 0047a893
    jne.d8 L_0047a8a1                            # 0047a895
    # block 0x0047a897: entered by fall-through of jne at 0x0047a895, 2 instruction(s), falls into the block at 0x0047a8a1
    mov eax, dword ptr [ebp - local_10]          # 0047a897
    mov dword ptr [eax + field_24], 0x0          # 0047a89a
L_0047a8a1:
    # block 0x0047a8a1: entered by jne at 0x0047a895, 1 instruction(s), ends with forward jump to 0x0047a8ad
    jmp.d8 L_0047a8ad                            # 0047a8a1
L_0047a8a3:
    # block 0x0047a8a3: entered by je at 0x0047a87d, 2 instruction(s), falls into the block at 0x0047a8ad
    mov ecx, dword ptr [ebp - local_10]          # 0047a8a3
    mov dword ptr [ecx + field_24], 0x0          # 0047a8a6
L_0047a8ad:
    # block 0x0047a8ad: entered by je at 0x0047a7ca; jmp at 0x0047a7e6; jmp at 0x0047a86a; jmp at 0x0047a885; more, 1 instruction(s), ends with forward jump to 0x0047a98e
    jmp.d32 L_0047a98e                           # 0047a8ad
L_0047a8b2:
    # block 0x0047a8b2: entered by switch case, 7 instruction(s), ends with je to 0x0047a8f3 (forward)
    mov edi, 0x54cbfc                            # 0047a8b2
    mov esi, dword ptr [ebp - local_4]           # 0047a8b7
    add esi, 0x241                               # 0047a8ba
    mov ecx, 0x9                                 # 0047a8c0
    {load} xor edx, edx                          # 0047a8c5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a8c7
    je.d8 L_0047a8f3                             # 0047a8c9
    # block 0x0047a8cb: entered by fall-through of je at 0x0047a8c9, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x0047a8f3
    mov eax, dword ptr [ebp - local_4]           # 0047a8cb
    add eax, 0x241                               # 0047a8ce
    push eax                                     # 0047a8d3
    mov ecx, 0x5c3a67                            # 0047a8d4
    call FUN_004fb77a                            # 0047a8d9
    mov ecx, dword ptr [ebp - local_4]           # 0047a8de
    mov dx, word ptr [ecx + field_262]           # 0047a8e1
    push edx                                     # 0047a8e8
    mov ecx, 0x5c3a67                            # 0047a8e9
    call FUN_004fb2e3                            # 0047a8ee
L_0047a8f3:
    # block 0x0047a8f3: entered by je at 0x0047a8c9, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0047a98e
    call dword ptr [0x52a23c]                    # 0047a8f3
    mov ecx, dword ptr [ebp - local_4]           # 0047a8f9
    movsx edx, word ptr [ecx + field_23f]        # 0047a8fc
    imul edx, edx, 0xbb8                         # 0047a903
    {load} add eax, edx                          # 0047a909
    mov ecx, dword ptr [ebp - local_10]          # 0047a90b
    mov dword ptr [ecx + field_1582], eax        # 0047a90e
    mov edx, dword ptr [ebp - local_10]          # 0047a914
    mov dword ptr [edx + field_24], 0x5          # 0047a917
    jmp.d8 L_0047a98e                            # 0047a91e
L_0047a920:
    # block 0x0047a920: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0047a93b (forward)
    call dword ptr [0x52a23c]                    # 0047a920
    mov ecx, dword ptr [ebp - local_10]          # 0047a926
    cmp eax, dword ptr [ecx + field_1582]        # 0047a929
    jb.d8 L_0047a93b                             # 0047a92f
    # block 0x0047a931: entered by fall-through of jb at 0x0047a92f, 2 instruction(s), falls into the block at 0x0047a93b
    mov edx, dword ptr [ebp - local_10]          # 0047a931
    mov dword ptr [edx + field_24], 0x4          # 0047a934
L_0047a93b:
    # block 0x0047a93b: entered by jb at 0x0047a92f, 3 instruction(s), calls FUN_0047a28c, ends with forward jump to 0x0047a98e
    mov ecx, dword ptr [ebp - local_10]          # 0047a93b
    call FUN_0047a28c                            # 0047a93e
    jmp.d8 L_0047a98e                            # 0047a943
L_0047a945:
    # block 0x0047a945: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0047a98e (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047a945
    movsx ecx, word ptr [eax + field_262]        # 0047a948
    mov dword ptr [ebp - local_c], ecx           # 0047a94f
    mov edx, dword ptr [ebp - local_c]           # 0047a952
    push edx                                     # 0047a955
    mov ecx, 0x5cf1eb                            # 0047a956
    call FUN_004f6334                            # 0047a95b
    test eax, eax                                # 0047a960
    jne.d8 L_0047a98e                            # 0047a962
    # block 0x0047a964: entered by fall-through of jne at 0x0047a962, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0047a98e
    mov eax, dword ptr [ebp - local_4]           # 0047a964
    add eax, 0x241                               # 0047a967
    push eax                                     # 0047a96c
    mov ecx, 0x5c3a67                            # 0047a96d
    call FUN_004fba69                            # 0047a972
    mov ecx, dword ptr [ebp - local_10]          # 0047a977
    movsx edx, word ptr [ecx + field_1e]         # 0047a97a
    imul edx, edx, 0x8d                          # 0047a97e
    mov dword ptr [edx + 0x5bb632], 0x2          # 0047a984
L_0047a98e:
    # block 0x0047a98e: entered by ja at 0x0047a705; jmp at 0x0047a77a; jmp at 0x0047a7b0; jmp at 0x0047a8ad; more, 1 instruction(s), ends with forward jump to 0x0047ac03
    jmp.d32 L_0047ac03                           # 0047a98e
L_0047a993:
    # block 0x0047a993: entered by je at 0x0047a45b, 8 instruction(s), ends with je to 0x0047a9ca (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0047a993
    mov edi, 0x54cc08                            # 0047a99d
    mov esi, dword ptr [ebp - local_4]           # 0047a9a2
    add esi, 0x1c4                               # 0047a9a5
    mov ecx, 0x9                                 # 0047a9ab
    {load} xor eax, eax                          # 0047a9b0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a9b2
    je.d8 L_0047a9ca                             # 0047a9b4
    # block 0x0047a9b6: entered by fall-through of je at 0x0047a9b4, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047a9ca
    mov ecx, dword ptr [ebp - local_4]           # 0047a9b6
    add ecx, 0x1c4                               # 0047a9b9
    push ecx                                     # 0047a9bf
    mov ecx, 0x5c3a67                            # 0047a9c0
    call FUN_004fba69                            # 0047a9c5
L_0047a9ca:
    # block 0x0047a9ca: entered by je at 0x0047a9b4, 7 instruction(s), ends with je to 0x0047a9f6 (forward)
    mov edi, 0x54cc14                            # 0047a9ca
    mov esi, dword ptr [ebp - local_4]           # 0047a9cf
    add esi, 0x1f5                               # 0047a9d2
    mov ecx, 0x9                                 # 0047a9d8
    {load} xor edx, edx                          # 0047a9dd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a9df
    je.d8 L_0047a9f6                             # 0047a9e1
    # block 0x0047a9e3: entered by fall-through of je at 0x0047a9e1, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047a9f6
    mov eax, dword ptr [ebp - local_4]           # 0047a9e3
    add eax, 0x1f5                               # 0047a9e6
    push eax                                     # 0047a9eb
    mov ecx, 0x5c3a67                            # 0047a9ec
    call FUN_004fba69                            # 0047a9f1
L_0047a9f6:
    # block 0x0047a9f6: entered by je at 0x0047a9e1, 3 instruction(s), ends with jne to 0x0047aa12 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047a9f6
    cmp dword ptr [ecx + field_157e], 0x0        # 0047a9f9
    jne.d8 L_0047aa12                            # 0047aa00
    # block 0x0047aa02: entered by fall-through of jne at 0x0047aa00, 3 instruction(s), ends with jne to 0x0047aaf4 (forward)
    movsx edx, word ptr [0x5957bb]               # 0047aa02
    cmp edx, 0x1                                 # 0047aa09
    jne.d32 L_0047aaf4                           # 0047aa0c
L_0047aa12:
    # block 0x0047aa12: entered by jne at 0x0047aa00; fall-through of jne at 0x0047aa0c, 4 instruction(s), ends with je to 0x0047aac4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047aa12
    movsx ecx, word ptr [eax + field_272]        # 0047aa15
    cmp ecx, 0x270f                              # 0047aa1c
    je.d32 L_0047aac4                            # 0047aa22
    # block 0x0047aa28: entered by fall-through of je at 0x0047aa22, 25 instruction(s), ends with jne to 0x0047aab0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047aa28
    movsx eax, word ptr [edx + field_272]        # 0047aa2b
    mov dword ptr [0x5bb57b], eax                # 0047aa32
    mov ecx, dword ptr [ebp - local_4]           # 0047aa37
    mov dx, word ptr [ecx + field_274]           # 0047aa3a
    mov word ptr [0x5bb599], dx                  # 0047aa41
    mov eax, dword ptr [ebp - local_4]           # 0047aa48
    mov cx, word ptr [eax + field_276]           # 0047aa4b
    mov word ptr [0x5bb595], cx                  # 0047aa52
    mov edx, dword ptr [ebp - local_4]           # 0047aa59
    mov ax, word ptr [edx + field_278]           # 0047aa5c
    mov word ptr [0x5c39ff], ax                  # 0047aa63
    mov ecx, dword ptr [ebp - local_4]           # 0047aa69
    mov edx, dword ptr [ecx + field_27a]         # 0047aa6c
    mov dword ptr [0x5bb59b], edx                # 0047aa72
    mov eax, dword ptr [ebp - local_4]           # 0047aa78
    mov ecx, dword ptr [eax + field_27e]         # 0047aa7b
    mov dword ptr [0x5bb59f], ecx                # 0047aa81
    mov edx, dword ptr [ebp - local_4]           # 0047aa87
    mov eax, dword ptr [edx + field_282]         # 0047aa8a
    mov dword ptr [0x5bb5a3], eax                # 0047aa90
    mov ecx, dword ptr [ebp - local_4]           # 0047aa95
    movsx edx, word ptr [ecx + field_286]        # 0047aa98
    cmp edx, 0x1                                 # 0047aa9f
    jne.d8 L_0047aab0                            # 0047aaa2
    # block 0x0047aaa4: entered by fall-through of jne at 0x0047aaa2, 2 instruction(s), ends with forward jump to 0x0047aaba
    mov dword ptr [0x5bb1ca], 0x0                # 0047aaa4
    jmp.d8 L_0047aaba                            # 0047aaae
L_0047aab0:
    # block 0x0047aab0: entered by jne at 0x0047aaa2, 1 instruction(s), falls into the block at 0x0047aaba
    mov dword ptr [0x5bb1ca], 0x1                # 0047aab0
L_0047aaba:
    # block 0x0047aaba: entered by jmp at 0x0047aaae, 1 instruction(s), falls into the block at 0x0047aac4
    mov dword ptr [0x583999], 0x4                # 0047aaba
L_0047aac4:
    # block 0x0047aac4: entered by je at 0x0047aa22, 4 instruction(s), ends with je to 0x0047aaef (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047aac4
    movsx ecx, word ptr [eax + field_288]        # 0047aac7
    cmp ecx, -0x1                                # 0047aace
    je.d8 L_0047aaef                             # 0047aad1
    # block 0x0047aad3: entered by fall-through of je at 0x0047aad1, 6 instruction(s), falls into the block at 0x0047aaef
    mov edx, dword ptr [ebp - local_4]           # 0047aad3
    {load} xor eax, eax                          # 0047aad6
    mov al, byte ptr [edx + field_28a]           # 0047aad8
    mov ecx, dword ptr [ebp - local_4]           # 0047aade
    movsx edx, word ptr [ecx + field_288]        # 0047aae1
    mov dword ptr [4*edx + 0x585801], eax        # 0047aae8
L_0047aaef:
    # block 0x0047aaef: entered by je at 0x0047aad1, 1 instruction(s), ends with forward jump to 0x0047abeb
    jmp.d32 L_0047abeb                           # 0047aaef
L_0047aaf4:
    # block 0x0047aaf4: entered by jne at 0x0047aa0c, 3 instruction(s), ends with je to 0x0047abeb (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047aaf4
    cmp dword ptr [eax + field_1576], 0x0        # 0047aaf7
    je.d32 L_0047abeb                            # 0047aafe
    # block 0x0047ab04: entered by fall-through of je at 0x0047aafe, 4 instruction(s), ends with je to 0x0047abb7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047ab04
    movsx edx, word ptr [ecx + field_226]        # 0047ab07
    cmp edx, 0x270f                              # 0047ab0e
    je.d32 L_0047abb7                            # 0047ab14
    # block 0x0047ab1a: entered by fall-through of je at 0x0047ab14, 25 instruction(s), ends with jne to 0x0047aba3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047ab1a
    movsx ecx, word ptr [eax + field_226]        # 0047ab1d
    mov dword ptr [0x5bb57b], ecx                # 0047ab24
    mov edx, dword ptr [ebp - local_4]           # 0047ab2a
    mov ax, word ptr [edx + field_228]           # 0047ab2d
    mov word ptr [0x5bb599], ax                  # 0047ab34
    mov ecx, dword ptr [ebp - local_4]           # 0047ab3a
    mov dx, word ptr [ecx + field_22a]           # 0047ab3d
    mov word ptr [0x5bb595], dx                  # 0047ab44
    mov eax, dword ptr [ebp - local_4]           # 0047ab4b
    mov cx, word ptr [eax + field_22c]           # 0047ab4e
    mov word ptr [0x5c39ff], cx                  # 0047ab55
    mov edx, dword ptr [ebp - local_4]           # 0047ab5c
    mov eax, dword ptr [edx + field_22e]         # 0047ab5f
    mov dword ptr [0x5bb59b], eax                # 0047ab65
    mov ecx, dword ptr [ebp - local_4]           # 0047ab6a
    mov edx, dword ptr [ecx + field_232]         # 0047ab6d
    mov dword ptr [0x5bb59f], edx                # 0047ab73
    mov eax, dword ptr [ebp - local_4]           # 0047ab79
    mov ecx, dword ptr [eax + field_236]         # 0047ab7c
    mov dword ptr [0x5bb5a3], ecx                # 0047ab82
    mov edx, dword ptr [ebp - local_4]           # 0047ab88
    movsx eax, word ptr [edx + field_23a]        # 0047ab8b
    cmp eax, 0x1                                 # 0047ab92
    jne.d8 L_0047aba3                            # 0047ab95
    # block 0x0047ab97: entered by fall-through of jne at 0x0047ab95, 2 instruction(s), ends with forward jump to 0x0047abad
    mov dword ptr [0x5bb1ca], 0x0                # 0047ab97
    jmp.d8 L_0047abad                            # 0047aba1
L_0047aba3:
    # block 0x0047aba3: entered by jne at 0x0047ab95, 1 instruction(s), falls into the block at 0x0047abad
    mov dword ptr [0x5bb1ca], 0x1                # 0047aba3
L_0047abad:
    # block 0x0047abad: entered by jmp at 0x0047aba1, 1 instruction(s), falls into the block at 0x0047abb7
    mov dword ptr [0x583999], 0x4                # 0047abad
L_0047abb7:
    # block 0x0047abb7: entered by je at 0x0047ab14, 5 instruction(s), ends with je to 0x0047abeb (forward)
    mov word ptr [0x5957bb], 0x1                 # 0047abb7
    mov ecx, dword ptr [ebp - local_4]           # 0047abc0
    movsx edx, word ptr [ecx + field_23c]        # 0047abc3
    cmp edx, -0x1                                # 0047abca
    je.d8 L_0047abeb                             # 0047abcd
    # block 0x0047abcf: entered by fall-through of je at 0x0047abcd, 6 instruction(s), falls into the block at 0x0047abeb
    mov eax, dword ptr [ebp - local_4]           # 0047abcf
    {load} xor ecx, ecx                          # 0047abd2
    mov cl, byte ptr [eax + field_23e]           # 0047abd4
    mov edx, dword ptr [ebp - local_4]           # 0047abda
    movsx eax, word ptr [edx + field_23c]        # 0047abdd
    mov dword ptr [4*eax + 0x585801], ecx        # 0047abe4
L_0047abeb:
    # block 0x0047abeb: entered by jmp at 0x0047aaef; je at 0x0047aafe; je at 0x0047abcd, 7 instruction(s), calls FUN_0042ba3a, FUN_0047823e, falls into the block at 0x0047ac03
    mov ecx, dword ptr [ebp - local_10]          # 0047abeb
    mov dx, word ptr [ecx + field_1e]            # 0047abee
    push edx                                     # 0047abf2
    call FUN_0042ba3a                            # 0047abf3
    add esp, 0x4                                 # 0047abf8
    mov ecx, dword ptr [ebp - local_10]          # 0047abfb
    call FUN_0047823e                            # 0047abfe
L_0047ac03:
    # block 0x0047ac03: entered by jmp at 0x0047a461; jmp at 0x0047a6f3; jmp at 0x0047a98e, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0047ac03
    pop esi                                      # 0047ac04
    {load} mov esp, ebp                          # 0047ac05
    pop ebp                                      # 0047ac07
    ret 0x4                                      # 0047ac08

# --- data items (not part of the function) -------------------------
.org 0x0047ac0b - 0x401000
SWTAB_0047ac0b:  # 6 case address(es)
    .long L_0047a715 - .text + 0x401000
    .long L_0047a8b2 - .text + 0x401000
    .long L_0047a7b5 - .text + 0x401000
    .long L_0047a77f - .text + 0x401000
    .long L_0047a945 - .text + 0x401000
    .long L_0047a920 - .text + 0x401000
.set SWTAB_0047ac0b_VA, SWTAB_0047ac0b - .text + 0x401000

