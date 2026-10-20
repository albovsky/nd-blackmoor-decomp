# FUN_004b64a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b64a9
# extent:       0x004b64a9-0x004b7029 (2944 code bytes)
# span:         0x004b64a9-0x004b7041 (code 2944, tables 24, padding 0)
# sha256:       c7c3ebdbb56976ff66f4905b922162e59cae328c7000b2446306b5c78c0a4fe8
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b64a9_run_scene
# naming:       native port src/original_methods_fl22b.c:m4b64a9_run_scene (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b64a9_run_scene (thiscall state machine, six-arm table compared in the differential). Zero divisor rejected natively (direct only). Unicorn: 300 fixtures, 725/725 instructions. See tasks/fl22b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_1c, field_21, field_23, field_24, field_27, field_28, field_2c, field_30, field_53, field_130, field_225, field_22a and 18 more; [ecx + n] field_1c, field_1e, field_20, field_21, field_23, field_4b, field_4f, field_128, field_12c, field_229, field_22a, field_22b and 13 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_23, field_25, field_47, field_124, field_224, field_229, field_22b and 14 more; [esi + n] field_27
# callees:      calls FUN_004e8d96, FUN_004b6355, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004b642d, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004b5bc8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl22b.c:m4b64a9_run_scene (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 725 instruction(s), 42 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_47, 0x47  # offset +0x47
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_124, 0x124  # offset +0x124
.equ field_128, 0x128  # offset +0x128
.equ field_12c, 0x12c  # offset +0x12c
.equ field_130, 0x130  # offset +0x130
.equ field_224, 0x224  # offset +0x224
.equ field_225, 0x225  # offset +0x225
.equ field_229, 0x229  # offset +0x229
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22b, 0x22b  # offset +0x22b
.equ field_22c, 0x22c  # offset +0x22c
.equ field_22e, 0x22e  # offset +0x22e
.equ field_232, 0x232  # offset +0x232
.equ field_254, 0x254  # offset +0x254
.equ field_274, 0x274  # offset +0x274
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_2d6, 0x2d6  # offset +0x2d6
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2fa, 0x2fa  # offset +0x2fa
.equ field_32a, 0x32a  # offset +0x32a
.equ field_32c, 0x32c  # offset +0x32c
.equ field_32e, 0x32e  # offset +0x32e
.equ field_330, 0x330  # offset +0x330
.equ field_332, 0x332  # offset +0x332
.equ field_336, 0x336  # offset +0x336
.equ field_33a, 0x33a  # offset +0x33a
.equ field_33e, 0x33e  # offset +0x33e
.equ field_340, 0x340  # offset +0x340
.equ field_342, 0x342  # offset +0x342
.equ field_366, 0x366  # offset +0x366
.equ field_376, 0x376  # offset +0x376
.equ field_378, 0x378  # offset +0x378
.equ field_37a, 0x37a  # offset +0x37a
.equ field_37c, 0x37c  # offset +0x37c
.equ field_37e, 0x37e  # offset +0x37e
.equ field_382, 0x382  # offset +0x382
.equ field_386, 0x386  # offset +0x386
.equ field_38a, 0x38a  # offset +0x38a
.equ field_38c, 0x38c  # offset +0x38c
.equ field_38e, 0x38e  # offset +0x38e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004b5bc8, .text + (0x004b5bc8 - 0x401000)
.set FUN_004b6355, .text + (0x004b6355 - 0x401000)
.set FUN_004b642d, .text + (0x004b642d - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004b64a9 - 0x401000
.globl FUN_004b64a9
FUN_004b64a9:
    # block 0x004b64a9: entry, 16 instruction(s), ends with je to 0x004b64f9 (forward)
    push ebp                                     # 004b64a9
    {load} mov ebp, esp                          # 004b64aa
    sub esp, 0x38                                # 004b64ac
    push esi                                     # 004b64af
    push edi                                     # 004b64b0
    mov dword ptr [ebp - local_30], ecx          # 004b64b1
    movsx eax, word ptr [ebp + arg_8]            # 004b64b4
    imul eax, eax, 0x8d                          # 004b64b8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b64be
    mov dword ptr [ebp - local_20], ecx          # 004b64c4
    movsx edx, word ptr [ebp + arg_8]            # 004b64c7
    imul edx, edx, 0x8d                          # 004b64cb
    mov eax, dword ptr [edx + 0x5bb632]          # 004b64d1
    mov dword ptr [ebp - local_34], eax          # 004b64d7
    cmp dword ptr [ebp - local_34], 0x0          # 004b64da
    je.d8 L_004b64f9                             # 004b64de
    # block 0x004b64e0: entered by fall-through of je at 0x004b64de, 2 instruction(s), ends with je to 0x004b6838 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 004b64e0
    je.d32 L_004b6838                            # 004b64e4
    # block 0x004b64ea: entered by fall-through of je at 0x004b64e4, 2 instruction(s), ends with je to 0x004b6dee (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 004b64ea
    je.d32 L_004b6dee                            # 004b64ee
    # block 0x004b64f4: entered by fall-through of je at 0x004b64ee, 1 instruction(s), ends with forward jump to 0x004b7021
    jmp.d32 L_004b7021                           # 004b64f4
L_004b64f9:
    # block 0x004b64f9: entered by je at 0x004b64de, 17 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x004b654d
    mov ecx, dword ptr [ebp - local_30]          # 004b64f9
    mov dx, word ptr [ebp + arg_8]               # 004b64fc
    mov word ptr [ecx + field_1e], dx            # 004b6500
    mov eax, dword ptr [ebp - local_30]          # 004b6504
    mov dword ptr [eax + field_225], 0x1         # 004b6507
    mov dword ptr [0x5bb1ca], 0x1                # 004b6511
    mov ecx, 0x571442                            # 004b651b
    call FUN_004e8d96                            # 004b6520
    {load} xor ecx, ecx                          # 004b6525
    mov edx, dword ptr [ebp - local_30]          # 004b6527
    add edx, 0x254                               # 004b652a
    mov dword ptr [edx], ecx                     # 004b6530
    mov dword ptr [edx + field_4], ecx           # 004b6532
    mov dword ptr [edx + field_8], ecx           # 004b6535
    mov dword ptr [edx + field_c], ecx           # 004b6538
    mov dword ptr [ebp - local_c], 0x0           # 004b653b
    jmp.d8 L_004b654d                            # 004b6542
L_004b6544:
    # block 0x004b6544: entered by jmp at 0x004b6669, 3 instruction(s), falls into the block at 0x004b654d
    mov eax, dword ptr [ebp - local_c]           # 004b6544
    add eax, 0x1                                 # 004b6547
    mov dword ptr [ebp - local_c], eax           # 004b654a
L_004b654d:
    # block 0x004b654d: entered by jmp at 0x004b6542, 4 instruction(s), ends with jge to 0x004b666e (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b654d
    movsx edx, word ptr [ecx + field_21]         # 004b6550
    cmp dword ptr [ebp - local_c], edx           # 004b6554
    jge.d32 L_004b666e                           # 004b6557
    # block 0x004b655d: entered by fall-through of jge at 0x004b6557, 76 instruction(s), calls FUN_004b6355, ends with backward jump to 0x004b6544
    mov eax, dword ptr [ebp - local_c]           # 004b655d
    shl eax, 0x4                                 # 004b6560
    mov ecx, dword ptr [ebp - local_20]          # 004b6563
    mov edx, dword ptr [ecx + eax + field_4b]    # 004b6566
    add edx, dword ptr [0x58318a]                # 004b656a
    mov eax, dword ptr [ebp - local_c]           # 004b6570
    shl eax, 0x4                                 # 004b6573
    mov ecx, dword ptr [ebp - local_30]          # 004b6576
    mov dword ptr [ecx + eax + field_128], edx   # 004b6579
    mov edx, dword ptr [ebp - local_c]           # 004b6580
    shl edx, 0x4                                 # 004b6583
    mov eax, dword ptr [ebp - local_20]          # 004b6586
    mov ecx, dword ptr [eax + edx + field_53]    # 004b6589
    add ecx, dword ptr [0x58318a]                # 004b658d
    mov edx, dword ptr [ebp - local_c]           # 004b6593
    shl edx, 0x4                                 # 004b6596
    mov eax, dword ptr [ebp - local_30]          # 004b6599
    mov dword ptr [eax + edx + field_130], ecx   # 004b659c
    mov ecx, dword ptr [ebp - local_c]           # 004b65a3
    shl ecx, 0x4                                 # 004b65a6
    mov edx, dword ptr [ebp - local_20]          # 004b65a9
    mov eax, dword ptr [edx + ecx + field_47]    # 004b65ac
    add eax, dword ptr [0x583186]                # 004b65b0
    mov ecx, dword ptr [ebp - local_c]           # 004b65b6
    shl ecx, 0x4                                 # 004b65b9
    mov edx, dword ptr [ebp - local_30]          # 004b65bc
    mov dword ptr [edx + ecx + field_124], eax   # 004b65bf
    mov eax, dword ptr [ebp - local_c]           # 004b65c6
    shl eax, 0x4                                 # 004b65c9
    mov ecx, dword ptr [ebp - local_20]          # 004b65cc
    mov edx, dword ptr [ecx + eax + field_4f]    # 004b65cf
    add edx, dword ptr [0x583186]                # 004b65d3
    mov eax, dword ptr [ebp - local_c]           # 004b65d9
    shl eax, 0x4                                 # 004b65dc
    mov ecx, dword ptr [ebp - local_30]          # 004b65df
    mov dword ptr [ecx + eax + field_12c], edx   # 004b65e2
    mov edx, dword ptr [ebp - local_c]           # 004b65e9
    mov eax, dword ptr [ebp - local_20]          # 004b65ec
    mov cx, word ptr [eax + 2*edx + field_27]    # 004b65ef
    mov word ptr [ebp - local_8], cx             # 004b65f4
    mov edx, dword ptr [ebp - local_c]           # 004b65f8
    mov eax, dword ptr [ebp - local_30]          # 004b65fb
    mov ecx, dword ptr [ebp - local_c]           # 004b65fe
    mov esi, dword ptr [ebp - local_20]          # 004b6601
    mov cx, word ptr [esi + 2*ecx + field_27]    # 004b6604
    mov word ptr [eax + 2*edx + field_254], cx   # 004b6609
    lea edx, [ebp - local_1c]                    # 004b6611
    push edx                                     # 004b6614
    push 0x0                                     # 004b6615
    mov ax, word ptr [ebp - local_8]             # 004b6617
    push eax                                     # 004b661b
    mov cx, word ptr [ebp - local_c]             # 004b661c
    push ecx                                     # 004b6620
    mov ecx, dword ptr [ebp - local_30]          # 004b6621
    call FUN_004b6355                            # 004b6624
    mov edx, dword ptr [ebp - local_c]           # 004b6629
    shl edx, 0x4                                 # 004b662c
    mov eax, dword ptr [ebp - local_30]          # 004b662f
    mov ecx, dword ptr [ebp - local_18]          # 004b6632
    mov dword ptr [eax + edx + field_28], ecx    # 004b6635
    mov edx, dword ptr [ebp - local_c]           # 004b6639
    shl edx, 0x4                                 # 004b663c
    mov eax, dword ptr [ebp - local_30]          # 004b663f
    mov ecx, dword ptr [ebp - local_10]          # 004b6642
    mov dword ptr [eax + edx + field_30], ecx    # 004b6645
    mov edx, dword ptr [ebp - local_c]           # 004b6649
    shl edx, 0x4                                 # 004b664c
    mov eax, dword ptr [ebp - local_30]          # 004b664f
    mov ecx, dword ptr [ebp - local_1c]          # 004b6652
    mov dword ptr [eax + edx + field_24], ecx    # 004b6655
    mov edx, dword ptr [ebp - local_c]           # 004b6659
    shl edx, 0x4                                 # 004b665c
    mov eax, dword ptr [ebp - local_30]          # 004b665f
    mov ecx, dword ptr [ebp - local_14]          # 004b6662
    mov dword ptr [eax + edx + field_2c], ecx    # 004b6665
    jmp.d32 L_004b6544                           # 004b6669
L_004b666e:
    # block 0x004b666e: entered by jge at 0x004b6557, 59 instruction(s), calls FUN_004d39f9, ends with jne to 0x004b6780 (forward)
    mov edx, dword ptr [ebp - local_30]          # 004b666e
    mov byte ptr [edx + field_224], 0x1          # 004b6671
    call FUN_004d39f9                            # 004b6678
    mov ecx, dword ptr [ebp - local_30]          # 004b667d
    mov word ptr [ecx + field_1c], ax            # 004b6680
    mov edx, dword ptr [ebp - local_30]          # 004b6684
    movsx eax, word ptr [edx + field_1c]         # 004b6687
    imul eax, eax, 0x4a                          # 004b668b
    mov dword ptr [eax + 0x5d1591], 0xa          # 004b668e
    mov ecx, dword ptr [ebp - local_30]          # 004b6698
    movsx edx, word ptr [ecx + field_1c]         # 004b669b
    imul edx, edx, 0x4a                          # 004b669f
    mov dword ptr [edx + 0x5d1595], 0x4b7051     # 004b66a2
    mov eax, dword ptr [ebp - local_30]          # 004b66ac
    movsx ecx, word ptr [eax + field_1c]         # 004b66af
    imul ecx, ecx, 0x4a                          # 004b66b3
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004b66b6
    mov edx, dword ptr [ebp - local_30]          # 004b66c0
    movsx eax, word ptr [edx + field_1c]         # 004b66c3
    imul eax, eax, 0x4a                          # 004b66c7
    mov dword ptr [eax + 0x5d159d], 0x0          # 004b66ca
    mov ecx, dword ptr [ebp - local_30]          # 004b66d4
    movsx edx, word ptr [ecx + field_1c]         # 004b66d7
    imul edx, edx, 0x4a                          # 004b66db
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004b66de
    mov eax, dword ptr [ebp - local_30]          # 004b66e8
    movsx ecx, word ptr [eax + field_1c]         # 004b66eb
    imul ecx, ecx, 0x4a                          # 004b66ef
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004b66f2
    mov edx, dword ptr [ebp - local_30]          # 004b66fc
    movsx eax, word ptr [edx + field_1c]         # 004b66ff
    imul eax, eax, 0x4a                          # 004b6703
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004b6706
    mov ecx, dword ptr [ebp - local_30]          # 004b6710
    movsx edx, word ptr [ecx + field_1c]         # 004b6713
    imul edx, edx, 0x4a                          # 004b6717
    mov word ptr [edx + 0x5d15ad], 0x0           # 004b671a
    mov edi, 0x551b24                            # 004b6723
    mov eax, dword ptr [ebp - local_30]          # 004b6728
    movsx ecx, word ptr [eax + field_1c]         # 004b672b
    imul ecx, ecx, 0x4a                          # 004b672f
    add ecx, 0x5d15b3                            # 004b6732
    {load} mov edx, ecx                          # 004b6738
    or ecx, -0x1                                 # 004b673a
    {load} xor eax, eax                          # 004b673d
    repne scasb al, byte ptr es:[edi]            # 004b673f
    not ecx                                      # 004b6741
    {load} sub edi, ecx                          # 004b6743
    {load} mov esi, edi                          # 004b6745
    {load} mov eax, ecx                          # 004b6747
    {load} mov edi, edx                          # 004b6749
    shr ecx, 0x2                                 # 004b674b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b674e
    {load} mov ecx, eax                          # 004b6750
    and ecx, 0x3                                 # 004b6752
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004b6755
    mov ecx, dword ptr [ebp - local_30]          # 004b6757
    cmp dword ptr [ecx + field_20], 0x0          # 004b675a
    jne.d8 L_004b6780                            # 004b675e
    # block 0x004b6760: entered by fall-through of jne at 0x004b675e, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004b6780
    push 0x551b3c                                # 004b6760
    push 0x6                                     # 004b6765
    mov edx, dword ptr [ebp - local_20]          # 004b6767
    push edx                                     # 004b676a
    push 0x551b54                                # 004b676b
    mov ecx, 0x5cf659                            # 004b6770
    call FUN_004c2790                            # 004b6775
    mov ecx, dword ptr [ebp - local_30]          # 004b677a
    mov dword ptr [ecx + field_20], eax          # 004b677d
L_004b6780:
    # block 0x004b6780: entered by jne at 0x004b675e, 13 instruction(s), ends with je to 0x004b67c3 (forward)
    mov edx, dword ptr [ebp - local_30]          # 004b6780
    movsx eax, word ptr [edx + field_1c]         # 004b6783
    imul eax, eax, 0x4a                          # 004b6787
    mov ecx, dword ptr [ebp - local_30]          # 004b678a
    mov edx, dword ptr [ecx + field_20]          # 004b678d
    mov dword ptr [eax + 0x5d1599], edx          # 004b6790
    mov edi, 0x551b5c                            # 004b6796
    mov esi, dword ptr [ebp - local_20]          # 004b679b
    add esi, 0x2d9                               # 004b679e
    mov ecx, 0x9                                 # 004b67a4
    {load} xor eax, eax                          # 004b67a9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b67ab
    je.d8 L_004b67c3                             # 004b67ad
    # block 0x004b67af: entered by fall-through of je at 0x004b67ad, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b67c3
    mov ecx, dword ptr [ebp - local_20]          # 004b67af
    add ecx, 0x2d9                               # 004b67b2
    push ecx                                     # 004b67b8
    mov ecx, 0x5c3a67                            # 004b67b9
    call FUN_004fb77a                            # 004b67be
L_004b67c3:
    # block 0x004b67c3: entered by je at 0x004b67ad, 7 instruction(s), ends with je to 0x004b67ef (forward)
    mov edi, 0x551b68                            # 004b67c3
    mov esi, dword ptr [ebp - local_20]          # 004b67c8
    add esi, 0x345                               # 004b67cb
    mov ecx, 0x9                                 # 004b67d1
    {load} xor edx, edx                          # 004b67d6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b67d8
    je.d8 L_004b67ef                             # 004b67da
    # block 0x004b67dc: entered by fall-through of je at 0x004b67da, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b67ef
    mov eax, dword ptr [ebp - local_20]          # 004b67dc
    add eax, 0x345                               # 004b67df
    push eax                                     # 004b67e4
    mov ecx, 0x5c3a67                            # 004b67e5
    call FUN_004fb77a                            # 004b67ea
L_004b67ef:
    # block 0x004b67ef: entered by je at 0x004b67da, 13 instruction(s), ends with forward jump to 0x004b7021
    mov ecx, dword ptr [ebp - local_30]          # 004b67ef
    mov byte ptr [ecx + field_22a], 0x0          # 004b67f2
    mov edx, dword ptr [ebp - local_30]          # 004b67f9
    mov byte ptr [edx + field_229], 0x0          # 004b67fc
    mov eax, dword ptr [ebp - local_30]          # 004b6803
    mov word ptr [eax + field_22c], 0x1          # 004b6806
    mov ecx, dword ptr [ebp - local_30]          # 004b680f
    mov dword ptr [ecx + field_274], 0x0         # 004b6812
    mov edx, dword ptr [ebp - local_30]          # 004b681c
    movsx eax, word ptr [edx + field_1e]         # 004b681f
    imul eax, eax, 0x8d                          # 004b6823
    mov dword ptr [eax + 0x5bb632], 0x1          # 004b6829
    jmp.d32 L_004b7021                           # 004b6833
L_004b6838:
    # block 0x004b6838: entered by je at 0x004b64e4, 5 instruction(s), ends with ja to 0x004b6de9 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004b6838
    mov edx, dword ptr [ecx + field_274]         # 004b683b
    mov dword ptr [ebp - local_38], edx          # 004b6841
    cmp dword ptr [ebp - local_38], 0x5          # 004b6844
    ja.d32 L_004b6de9                            # 004b6848
    # block 0x004b684e: entered by fall-through of ja at 0x004b6848, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4b7029]
    mov eax, dword ptr [ebp - local_38]          # 004b684e
    jmp dword ptr [4*eax + SWTAB_004b7029_VA]    # 004b6851
L_004b6858:
    # block 0x004b6858: entered by switch case, 5 instruction(s), ends with je to 0x004b6876 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004b6858
    {load} xor edx, edx                          # 004b685b
    mov dl, byte ptr [ecx + field_22a]           # 004b685d
    test edx, edx                                # 004b6863
    je.d8 L_004b6876                             # 004b6865
    # block 0x004b6867: entered by fall-through of je at 0x004b6865, 3 instruction(s), ends with forward jump to 0x004b687e
    mov eax, dword ptr [ebp - local_30]          # 004b6867
    mov dword ptr [eax + field_274], 0x4         # 004b686a
    jmp.d8 L_004b687e                            # 004b6874
L_004b6876:
    # block 0x004b6876: entered by je at 0x004b6865, 2 instruction(s), calls FUN_004b642d, falls into the block at 0x004b687e
    mov ecx, dword ptr [ebp - local_30]          # 004b6876
    call FUN_004b642d                            # 004b6879
L_004b687e:
    # block 0x004b687e: entered by jmp at 0x004b6874, 1 instruction(s), ends with forward jump to 0x004b6de9
    jmp.d32 L_004b6de9                           # 004b687e
L_004b6883:
    # block 0x004b6883: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b68de (forward)
    call dword ptr [0x52a23c]                    # 004b6883
    mov ecx, dword ptr [ebp - local_30]          # 004b6889
    cmp eax, dword ptr [ecx + field_22e]         # 004b688c
    jb.d8 L_004b68de                             # 004b6892
    # block 0x004b6894: entered by fall-through of jb at 0x004b6892, 7 instruction(s), ends with je to 0x004b68de (forward)
    mov edx, dword ptr [ebp - local_30]          # 004b6894
    mov dword ptr [edx + field_274], 0x2         # 004b6897
    mov eax, dword ptr [ebp - local_30]          # 004b68a1
    {load} xor ecx, ecx                          # 004b68a4
    mov cl, byte ptr [eax + field_22a]           # 004b68a6
    test ecx, ecx                                # 004b68ac
    je.d8 L_004b68de                             # 004b68ae
    # block 0x004b68b0: entered by fall-through of je at 0x004b68ae, 7 instruction(s), ends with je to 0x004b68de (forward)
    mov edi, 0x551b74                            # 004b68b0
    mov esi, dword ptr [ebp - local_20]          # 004b68b5
    add esi, 0x2d9                               # 004b68b8
    mov ecx, 0x9                                 # 004b68be
    {load} xor edx, edx                          # 004b68c3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b68c5
    je.d8 L_004b68de                             # 004b68c7
    # block 0x004b68c9: entered by fall-through of je at 0x004b68c7, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b68de
    mov eax, dword ptr [ebp - local_20]          # 004b68c9
    mov cx, word ptr [eax + field_2fa]           # 004b68cc
    push ecx                                     # 004b68d3
    mov ecx, 0x5c3a67                            # 004b68d4
    call FUN_004fb2e3                            # 004b68d9
L_004b68de:
    # block 0x004b68de: entered by jb at 0x004b6892; je at 0x004b68ae; je at 0x004b68c7, 1 instruction(s), ends with forward jump to 0x004b6de9
    jmp.d32 L_004b6de9                           # 004b68de
L_004b68e3:
    # block 0x004b68e3: entered by switch case, 5 instruction(s), ends with forward jump to 0x004b6906
    mov dword ptr [ebp - local_4], 0x0           # 004b68e3
    mov edx, dword ptr [ebp - local_30]          # 004b68ea
    mov byte ptr [edx + field_224], 0x1          # 004b68ed
    mov dword ptr [ebp - local_c], 0x0           # 004b68f4
    jmp.d8 L_004b6906                            # 004b68fb
L_004b68fd:
    # block 0x004b68fd: entered by jmp at 0x004b6a47, 3 instruction(s), falls into the block at 0x004b6906
    mov eax, dword ptr [ebp - local_c]           # 004b68fd
    add eax, 0x1                                 # 004b6900
    mov dword ptr [ebp - local_c], eax           # 004b6903
L_004b6906:
    # block 0x004b6906: entered by jmp at 0x004b68fb, 4 instruction(s), ends with jge to 0x004b6a4c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b6906
    movsx edx, word ptr [ecx + field_21]         # 004b6909
    cmp dword ptr [ebp - local_c], edx           # 004b690d
    jge.d32 L_004b6a4c                           # 004b6910
    # block 0x004b6916: entered by fall-through of jge at 0x004b6910, 5 instruction(s), ends with je to 0x004b6a47 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b6916
    mov ecx, dword ptr [ebp - local_30]          # 004b6919
    movsx edx, word ptr [ecx + 2*eax + field_232] # 004b691c
    test edx, edx                                # 004b6924
    je.d32 L_004b6a47                            # 004b6926
    # block 0x004b692c: entered by fall-through of je at 0x004b6926, 6 instruction(s), ends with jne to 0x004b69dc (forward)
    mov eax, dword ptr [ebp - local_30]          # 004b692c
    movsx ecx, word ptr [eax + field_22c]        # 004b692f
    mov edx, dword ptr [ebp - local_20]          # 004b6936
    movsx eax, word ptr [edx + field_25]         # 004b6939
    {load} cmp ecx, eax                          # 004b693d
    jne.d32 L_004b69dc                           # 004b693f
    # block 0x004b6945: entered by fall-through of jne at 0x004b693f, 9 instruction(s), ends with jne to 0x004b698f (forward)
    mov dword ptr [ebp - local_4], 0x1           # 004b6945
    mov ecx, dword ptr [ebp - local_c]           # 004b694c
    mov edx, dword ptr [ebp - local_30]          # 004b694f
    movsx eax, word ptr [edx + 2*ecx + field_254] # 004b6952
    mov ecx, dword ptr [ebp - local_20]          # 004b695a
    movsx edx, word ptr [ecx + field_23]         # 004b695d
    sub edx, 0x1                                 # 004b6961
    {load} cmp eax, edx                          # 004b6964
    jne.d8 L_004b698f                            # 004b6966
    # block 0x004b6968: entered by fall-through of jne at 0x004b6966, 12 instruction(s), calls FUN_004b6355, ends with forward jump to 0x004b69da
    lea eax, [ebp - local_1c]                    # 004b6968
    push eax                                     # 004b696b
    push 0x0                                     # 004b696c
    push 0x0                                     # 004b696e
    mov cx, word ptr [ebp - local_c]             # 004b6970
    push ecx                                     # 004b6974
    mov ecx, dword ptr [ebp - local_30]          # 004b6975
    call FUN_004b6355                            # 004b6978
    mov edx, dword ptr [ebp - local_c]           # 004b697d
    mov eax, dword ptr [ebp - local_30]          # 004b6980
    mov word ptr [eax + 2*edx + field_254], 0x0  # 004b6983
    jmp.d8 L_004b69da                            # 004b698d
L_004b698f:
    # block 0x004b698f: entered by jne at 0x004b6966, 20 instruction(s), calls FUN_004b6355, falls into the block at 0x004b69da
    lea ecx, [ebp - local_1c]                    # 004b698f
    push ecx                                     # 004b6992
    mov edx, dword ptr [ebp - local_30]          # 004b6993
    mov ax, word ptr [edx + field_22c]           # 004b6996
    push eax                                     # 004b699d
    mov ecx, dword ptr [ebp - local_c]           # 004b699e
    mov edx, dword ptr [ebp - local_30]          # 004b69a1
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b69a4
    push eax                                     # 004b69ac
    mov cx, word ptr [ebp - local_c]             # 004b69ad
    push ecx                                     # 004b69b1
    mov ecx, dword ptr [ebp - local_30]          # 004b69b2
    call FUN_004b6355                            # 004b69b5
    mov edx, dword ptr [ebp - local_c]           # 004b69ba
    mov eax, dword ptr [ebp - local_30]          # 004b69bd
    mov cx, word ptr [eax + 2*edx + field_254]   # 004b69c0
    add cx, 0x1                                  # 004b69c8
    mov edx, dword ptr [ebp - local_c]           # 004b69cc
    mov eax, dword ptr [ebp - local_30]          # 004b69cf
    mov word ptr [eax + 2*edx + field_254], cx   # 004b69d2
L_004b69da:
    # block 0x004b69da: entered by jmp at 0x004b698d, 1 instruction(s), ends with forward jump to 0x004b6a07
    jmp.d8 L_004b6a07                            # 004b69da
L_004b69dc:
    # block 0x004b69dc: entered by jne at 0x004b693f, 13 instruction(s), calls FUN_004b6355, falls into the block at 0x004b6a07
    lea ecx, [ebp - local_1c]                    # 004b69dc
    push ecx                                     # 004b69df
    mov edx, dword ptr [ebp - local_30]          # 004b69e0
    mov ax, word ptr [edx + field_22c]           # 004b69e3
    push eax                                     # 004b69ea
    mov ecx, dword ptr [ebp - local_c]           # 004b69eb
    mov edx, dword ptr [ebp - local_30]          # 004b69ee
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b69f1
    push eax                                     # 004b69f9
    mov cx, word ptr [ebp - local_c]             # 004b69fa
    push ecx                                     # 004b69fe
    mov ecx, dword ptr [ebp - local_30]          # 004b69ff
    call FUN_004b6355                            # 004b6a02
L_004b6a07:
    # block 0x004b6a07: entered by jmp at 0x004b69da, 20 instruction(s), falls into the block at 0x004b6a47
    mov edx, dword ptr [ebp - local_c]           # 004b6a07
    shl edx, 0x4                                 # 004b6a0a
    mov eax, dword ptr [ebp - local_30]          # 004b6a0d
    mov ecx, dword ptr [ebp - local_18]          # 004b6a10
    mov dword ptr [eax + edx + field_28], ecx    # 004b6a13
    mov edx, dword ptr [ebp - local_c]           # 004b6a17
    shl edx, 0x4                                 # 004b6a1a
    mov eax, dword ptr [ebp - local_30]          # 004b6a1d
    mov ecx, dword ptr [ebp - local_10]          # 004b6a20
    mov dword ptr [eax + edx + field_30], ecx    # 004b6a23
    mov edx, dword ptr [ebp - local_c]           # 004b6a27
    shl edx, 0x4                                 # 004b6a2a
    mov eax, dword ptr [ebp - local_30]          # 004b6a2d
    mov ecx, dword ptr [ebp - local_1c]          # 004b6a30
    mov dword ptr [eax + edx + field_24], ecx    # 004b6a33
    mov edx, dword ptr [ebp - local_c]           # 004b6a37
    shl edx, 0x4                                 # 004b6a3a
    mov eax, dword ptr [ebp - local_30]          # 004b6a3d
    mov ecx, dword ptr [ebp - local_14]          # 004b6a40
    mov dword ptr [eax + edx + field_2c], ecx    # 004b6a43
L_004b6a47:
    # block 0x004b6a47: entered by je at 0x004b6926, 1 instruction(s), ends with backward jump to 0x004b68fd
    jmp.d32 L_004b68fd                           # 004b6a47
L_004b6a4c:
    # block 0x004b6a4c: entered by jge at 0x004b6910, 2 instruction(s), ends with je to 0x004b6aac (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004b6a4c
    je.d8 L_004b6aac                             # 004b6a50
    # block 0x004b6a52: entered by fall-through of je at 0x004b6a50, 9 instruction(s), ends with jne to 0x004b6aaa (forward)
    mov edx, dword ptr [ebp - local_30]          # 004b6a52
    mov dword ptr [edx + field_274], 0x0         # 004b6a55
    mov eax, dword ptr [ebp - local_30]          # 004b6a5f
    mov word ptr [eax + field_22c], 0x1          # 004b6a62
    mov ecx, dword ptr [ebp - local_30]          # 004b6a6b
    {load} xor edx, edx                          # 004b6a6e
    mov dl, byte ptr [ecx + field_22a]           # 004b6a70
    test edx, edx                                # 004b6a76
    jne.d8 L_004b6aaa                            # 004b6a78
    # block 0x004b6a7a: entered by fall-through of jne at 0x004b6a78, 2 instruction(s), ends with forward jump to 0x004b6a8c
    mov dword ptr [ebp - local_c], 0x0           # 004b6a7a
    jmp.d8 L_004b6a8c                            # 004b6a81
L_004b6a83:
    # block 0x004b6a83: entered by jmp at 0x004b6aa8, 3 instruction(s), falls into the block at 0x004b6a8c
    mov eax, dword ptr [ebp - local_c]           # 004b6a83
    add eax, 0x1                                 # 004b6a86
    mov dword ptr [ebp - local_c], eax           # 004b6a89
L_004b6a8c:
    # block 0x004b6a8c: entered by jmp at 0x004b6a81, 4 instruction(s), ends with jge to 0x004b6aaa (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b6a8c
    movsx edx, word ptr [ecx + field_21]         # 004b6a8f
    cmp dword ptr [ebp - local_c], edx           # 004b6a93
    jge.d8 L_004b6aaa                            # 004b6a96
    # block 0x004b6a98: entered by fall-through of jge at 0x004b6a96, 4 instruction(s), ends with backward jump to 0x004b6a83
    mov eax, dword ptr [ebp - local_c]           # 004b6a98
    mov ecx, dword ptr [ebp - local_30]          # 004b6a9b
    mov word ptr [ecx + 2*eax + field_232], 0x0  # 004b6a9e
    jmp.d8 L_004b6a83                            # 004b6aa8
L_004b6aaa:
    # block 0x004b6aaa: entered by jne at 0x004b6a78; jge at 0x004b6a96, 1 instruction(s), ends with forward jump to 0x004b6afe
    jmp.d8 L_004b6afe                            # 004b6aaa
L_004b6aac:
    # block 0x004b6aac: entered by je at 0x004b6a50, 19 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004b6afe
    call dword ptr [0x52a23c]                    # 004b6aac
    {load} mov ecx, eax                          # 004b6ab2
    mov edx, dword ptr [ebp - local_20]          # 004b6ab4
    movsx eax, word ptr [edx + field_2d4]        # 004b6ab7
    imul eax, eax, 0x3e8                         # 004b6abe
    mov edx, dword ptr [ebp - local_20]          # 004b6ac4
    movsx esi, word ptr [edx + field_25]         # 004b6ac7
    cdq                                          # 004b6acb
    idiv esi                                     # 004b6acc
    {load} add ecx, eax                          # 004b6ace
    mov eax, dword ptr [ebp - local_30]          # 004b6ad0
    mov dword ptr [eax + field_22e], ecx         # 004b6ad3
    mov ecx, dword ptr [ebp - local_30]          # 004b6ad9
    mov dword ptr [ecx + field_274], 0x3         # 004b6adc
    mov edx, dword ptr [ebp - local_30]          # 004b6ae6
    mov ax, word ptr [edx + field_22c]           # 004b6ae9
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b6af0
    mov ecx, dword ptr [ebp - local_30]          # 004b6af4
    mov word ptr [ecx + field_22c], ax           # 004b6af7
L_004b6afe:
    # block 0x004b6afe: entered by jmp at 0x004b6aaa, 1 instruction(s), ends with forward jump to 0x004b6de9
    jmp.d32 L_004b6de9                           # 004b6afe
L_004b6b03:
    # block 0x004b6b03: entered by switch case, 7 instruction(s), ends with je to 0x004b6b43 (forward)
    mov edi, 0x551b80                            # 004b6b03
    mov esi, dword ptr [ebp - local_20]          # 004b6b08
    add esi, 0x345                               # 004b6b0b
    mov ecx, 0x9                                 # 004b6b11
    {load} xor edx, edx                          # 004b6b16
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b6b18
    je.d8 L_004b6b43                             # 004b6b1a
    # block 0x004b6b1c: entered by fall-through of je at 0x004b6b1a, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004b6c22
    mov eax, dword ptr [ebp - local_20]          # 004b6b1c
    mov cx, word ptr [eax + field_366]           # 004b6b1f
    push ecx                                     # 004b6b26
    mov ecx, 0x5c3a67                            # 004b6b27
    call FUN_004fb2e3                            # 004b6b2c
    mov edx, dword ptr [ebp - local_30]          # 004b6b31
    mov dword ptr [edx + field_274], 0x5         # 004b6b34
    jmp.d32 L_004b6c22                           # 004b6b3e
L_004b6b43:
    # block 0x004b6b43: entered by je at 0x004b6b1a, 5 instruction(s), ends with je to 0x004b6bfc (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6b43
    {load} xor ecx, ecx                          # 004b6b46
    mov cl, byte ptr [eax + field_2d6]           # 004b6b48
    test ecx, ecx                                # 004b6b4e
    je.d32 L_004b6bfc                            # 004b6b50
    # block 0x004b6b56: entered by fall-through of je at 0x004b6b50, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b6bfc (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6b56
    movsx eax, word ptr [edx + field_2fa]        # 004b6b59
    mov dword ptr [ebp - local_24], eax          # 004b6b60
    mov ecx, dword ptr [ebp - local_24]          # 004b6b63
    push ecx                                     # 004b6b66
    mov ecx, 0x5cf1eb                            # 004b6b67
    call FUN_004f6334                            # 004b6b6c
    test eax, eax                                # 004b6b71
    jne.d32 L_004b6bfc                           # 004b6b73
    # block 0x004b6b79: entered by fall-through of jne at 0x004b6b73, 2 instruction(s), ends with forward jump to 0x004b6b8b
    mov dword ptr [ebp - local_c], 0x0           # 004b6b79
    jmp.d8 L_004b6b8b                            # 004b6b80
L_004b6b82:
    # block 0x004b6b82: entered by jmp at 0x004b6ba7, 3 instruction(s), falls into the block at 0x004b6b8b
    mov edx, dword ptr [ebp - local_c]           # 004b6b82
    add edx, 0x1                                 # 004b6b85
    mov dword ptr [ebp - local_c], edx           # 004b6b88
L_004b6b8b:
    # block 0x004b6b8b: entered by jmp at 0x004b6b80, 4 instruction(s), ends with jge to 0x004b6ba9 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6b8b
    movsx ecx, word ptr [eax + field_21]         # 004b6b8e
    cmp dword ptr [ebp - local_c], ecx           # 004b6b92
    jge.d8 L_004b6ba9                            # 004b6b95
    # block 0x004b6b97: entered by fall-through of jge at 0x004b6b95, 4 instruction(s), ends with backward jump to 0x004b6b82
    mov edx, dword ptr [ebp - local_c]           # 004b6b97
    mov eax, dword ptr [ebp - local_30]          # 004b6b9a
    mov word ptr [eax + 2*edx + field_232], 0x1  # 004b6b9d
    jmp.d8 L_004b6b82                            # 004b6ba7
L_004b6ba9:
    # block 0x004b6ba9: entered by jge at 0x004b6b95, 13 instruction(s), ends with je to 0x004b6bfa (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004b6ba9
    mov dword ptr [ecx + field_274], 0x2         # 004b6bac
    mov edx, dword ptr [ebp - local_30]          # 004b6bb6
    mov word ptr [edx + field_22c], 0x1          # 004b6bb9
    mov eax, dword ptr [ebp - local_30]          # 004b6bc2
    mov byte ptr [eax + field_22b], 0x0          # 004b6bc5
    mov edi, 0x551b8c                            # 004b6bcc
    mov esi, dword ptr [ebp - local_20]          # 004b6bd1
    add esi, 0x2d9                               # 004b6bd4
    mov ecx, 0x9                                 # 004b6bda
    {load} xor edx, edx                          # 004b6bdf
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b6be1
    je.d8 L_004b6bfa                             # 004b6be3
    # block 0x004b6be5: entered by fall-through of je at 0x004b6be3, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b6bfa
    mov eax, dword ptr [ebp - local_20]          # 004b6be5
    mov cx, word ptr [eax + field_2fa]           # 004b6be8
    push ecx                                     # 004b6bef
    mov ecx, 0x5c3a67                            # 004b6bf0
    call FUN_004fb2e3                            # 004b6bf5
L_004b6bfa:
    # block 0x004b6bfa: entered by je at 0x004b6be3, 1 instruction(s), ends with forward jump to 0x004b6c22
    jmp.d8 L_004b6c22                            # 004b6bfa
L_004b6bfc:
    # block 0x004b6bfc: entered by je at 0x004b6b50; jne at 0x004b6b73, 5 instruction(s), ends with jne to 0x004b6c22 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6bfc
    {load} xor eax, eax                          # 004b6bff
    mov al, byte ptr [edx + field_2d6]           # 004b6c01
    test eax, eax                                # 004b6c07
    jne.d8 L_004b6c22                            # 004b6c09
    # block 0x004b6c0b: entered by fall-through of jne at 0x004b6c09, 4 instruction(s), falls into the block at 0x004b6c22
    mov ecx, dword ptr [ebp - local_30]          # 004b6c0b
    movsx edx, word ptr [ecx + field_1e]         # 004b6c0e
    imul edx, edx, 0x8d                          # 004b6c12
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b6c18
L_004b6c22:
    # block 0x004b6c22: entered by jmp at 0x004b6b3e; jmp at 0x004b6bfa; jne at 0x004b6c09, 1 instruction(s), ends with forward jump to 0x004b6de9
    jmp.d32 L_004b6de9                           # 004b6c22
L_004b6c27:
    # block 0x004b6c27: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b6d3c (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6c27
    movsx ecx, word ptr [eax + field_366]        # 004b6c2a
    mov dword ptr [ebp - local_28], ecx          # 004b6c31
    mov edx, dword ptr [ebp - local_28]          # 004b6c34
    push edx                                     # 004b6c37
    mov ecx, 0x5cf1eb                            # 004b6c38
    call FUN_004f6334                            # 004b6c3d
    test eax, eax                                # 004b6c42
    jne.d32 L_004b6d3c                           # 004b6c44
    # block 0x004b6c4a: entered by fall-through of jne at 0x004b6c44, 10 instruction(s), calls FUN_004fba69, ends with je to 0x004b6d16 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6c4a
    add eax, 0x345                               # 004b6c4d
    push eax                                     # 004b6c52
    mov ecx, 0x5c3a67                            # 004b6c53
    call FUN_004fba69                            # 004b6c58
    mov ecx, dword ptr [ebp - local_20]          # 004b6c5d
    {load} xor edx, edx                          # 004b6c60
    mov dl, byte ptr [ecx + field_2d6]           # 004b6c62
    test edx, edx                                # 004b6c68
    je.d32 L_004b6d16                            # 004b6c6a
    # block 0x004b6c70: entered by fall-through of je at 0x004b6c6a, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b6d16 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6c70
    movsx ecx, word ptr [eax + field_2fa]        # 004b6c73
    mov dword ptr [ebp - local_2c], ecx          # 004b6c7a
    mov edx, dword ptr [ebp - local_2c]          # 004b6c7d
    push edx                                     # 004b6c80
    mov ecx, 0x5cf1eb                            # 004b6c81
    call FUN_004f6334                            # 004b6c86
    test eax, eax                                # 004b6c8b
    jne.d32 L_004b6d16                           # 004b6c8d
    # block 0x004b6c93: entered by fall-through of jne at 0x004b6c8d, 2 instruction(s), ends with forward jump to 0x004b6ca5
    mov dword ptr [ebp - local_c], 0x0           # 004b6c93
    jmp.d8 L_004b6ca5                            # 004b6c9a
L_004b6c9c:
    # block 0x004b6c9c: entered by jmp at 0x004b6cc1, 3 instruction(s), falls into the block at 0x004b6ca5
    mov eax, dword ptr [ebp - local_c]           # 004b6c9c
    add eax, 0x1                                 # 004b6c9f
    mov dword ptr [ebp - local_c], eax           # 004b6ca2
L_004b6ca5:
    # block 0x004b6ca5: entered by jmp at 0x004b6c9a, 4 instruction(s), ends with jge to 0x004b6cc3 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b6ca5
    movsx edx, word ptr [ecx + field_21]         # 004b6ca8
    cmp dword ptr [ebp - local_c], edx           # 004b6cac
    jge.d8 L_004b6cc3                            # 004b6caf
    # block 0x004b6cb1: entered by fall-through of jge at 0x004b6caf, 4 instruction(s), ends with backward jump to 0x004b6c9c
    mov eax, dword ptr [ebp - local_c]           # 004b6cb1
    mov ecx, dword ptr [ebp - local_30]          # 004b6cb4
    mov word ptr [ecx + 2*eax + field_232], 0x1  # 004b6cb7
    jmp.d8 L_004b6c9c                            # 004b6cc1
L_004b6cc3:
    # block 0x004b6cc3: entered by jge at 0x004b6caf, 13 instruction(s), ends with je to 0x004b6d14 (forward)
    mov edx, dword ptr [ebp - local_30]          # 004b6cc3
    mov dword ptr [edx + field_274], 0x2         # 004b6cc6
    mov eax, dword ptr [ebp - local_30]          # 004b6cd0
    mov word ptr [eax + field_22c], 0x1          # 004b6cd3
    mov ecx, dword ptr [ebp - local_30]          # 004b6cdc
    mov byte ptr [ecx + field_22b], 0x0          # 004b6cdf
    mov edi, 0x551b98                            # 004b6ce6
    mov esi, dword ptr [ebp - local_20]          # 004b6ceb
    add esi, 0x2d9                               # 004b6cee
    mov ecx, 0x9                                 # 004b6cf4
    {load} xor edx, edx                          # 004b6cf9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b6cfb
    je.d8 L_004b6d14                             # 004b6cfd
    # block 0x004b6cff: entered by fall-through of je at 0x004b6cfd, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b6d14
    mov eax, dword ptr [ebp - local_20]          # 004b6cff
    mov cx, word ptr [eax + field_2fa]           # 004b6d02
    push ecx                                     # 004b6d09
    mov ecx, 0x5c3a67                            # 004b6d0a
    call FUN_004fb2e3                            # 004b6d0f
L_004b6d14:
    # block 0x004b6d14: entered by je at 0x004b6cfd, 1 instruction(s), ends with forward jump to 0x004b6d3c
    jmp.d8 L_004b6d3c                            # 004b6d14
L_004b6d16:
    # block 0x004b6d16: entered by je at 0x004b6c6a; jne at 0x004b6c8d, 5 instruction(s), ends with jne to 0x004b6d3c (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6d16
    {load} xor eax, eax                          # 004b6d19
    mov al, byte ptr [edx + field_2d6]           # 004b6d1b
    test eax, eax                                # 004b6d21
    jne.d8 L_004b6d3c                            # 004b6d23
    # block 0x004b6d25: entered by fall-through of jne at 0x004b6d23, 4 instruction(s), falls into the block at 0x004b6d3c
    mov ecx, dword ptr [ebp - local_30]          # 004b6d25
    movsx edx, word ptr [ecx + field_1e]         # 004b6d28
    imul edx, edx, 0x8d                          # 004b6d2c
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b6d32
L_004b6d3c:
    # block 0x004b6d3c: entered by jne at 0x004b6c44; jmp at 0x004b6d14; jne at 0x004b6d23, 1 instruction(s), ends with forward jump to 0x004b6de9
    jmp.d32 L_004b6de9                           # 004b6d3c
L_004b6d41:
    # block 0x004b6d41: entered by switch case, 7 instruction(s), ends with jl to 0x004b6d82 (forward)
    mov eax, dword ptr [ebp - local_30]          # 004b6d41
    movsx ecx, word ptr [eax + field_254]        # 004b6d44
    mov edx, dword ptr [ebp - local_20]          # 004b6d4b
    movsx eax, word ptr [edx + field_23]         # 004b6d4e
    sub eax, 0x1                                 # 004b6d52
    {load} cmp ecx, eax                          # 004b6d55
    jl.d8 L_004b6d82                             # 004b6d57
    # block 0x004b6d59: entered by fall-through of jl at 0x004b6d57, 12 instruction(s), ends with jge to 0x004b6dd2 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004b6d59
    {load} xor edx, edx                          # 004b6d5c
    mov dl, byte ptr [ecx + field_22b]           # 004b6d5e
    mov eax, dword ptr [ebp - local_20]          # 004b6d64
    movsx ecx, word ptr [eax + field_2d7]        # 004b6d67
    mov eax, dword ptr [ebp - local_20]          # 004b6d6e
    movsx eax, word ptr [eax + field_23]         # 004b6d71
    sub eax, 0x1                                 # 004b6d75
    imul ecx, eax                                # 004b6d78
    sub ecx, 0x1                                 # 004b6d7b
    {load} cmp edx, ecx                          # 004b6d7e
    jge.d8 L_004b6dd2                            # 004b6d80
L_004b6d82:
    # block 0x004b6d82: entered by jl at 0x004b6d57; fall-through of jge at 0x004b6d80, 20 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b6de9
    call dword ptr [0x52a23c]                    # 004b6d82
    {load} mov ecx, eax                          # 004b6d88
    mov edx, dword ptr [ebp - local_20]          # 004b6d8a
    movsx eax, word ptr [edx + field_2d4]        # 004b6d8d
    imul eax, eax, 0x1f40                        # 004b6d94
    mov edx, dword ptr [ebp - local_20]          # 004b6d9a
    movsx esi, word ptr [edx + field_25]         # 004b6d9d
    cdq                                          # 004b6da1
    idiv esi                                     # 004b6da2
    {load} add ecx, eax                          # 004b6da4
    mov eax, dword ptr [ebp - local_30]          # 004b6da6
    mov dword ptr [eax + field_22e], ecx         # 004b6da9
    mov ecx, dword ptr [ebp - local_30]          # 004b6daf
    mov dword ptr [ecx + field_274], 0x3         # 004b6db2
    mov edx, dword ptr [ebp - local_30]          # 004b6dbc
    mov al, byte ptr [edx + field_22b]           # 004b6dbf
    add al, 0x1                                  # 004b6dc5
    mov ecx, dword ptr [ebp - local_30]          # 004b6dc7
    mov byte ptr [ecx + field_22b], al           # 004b6dca
    jmp.d8 L_004b6de9                            # 004b6dd0
L_004b6dd2:
    # block 0x004b6dd2: entered by jge at 0x004b6d80, 4 instruction(s), falls into the block at 0x004b6de9
    mov edx, dword ptr [ebp - local_30]          # 004b6dd2
    movsx eax, word ptr [edx + field_1e]         # 004b6dd5
    imul eax, eax, 0x8d                          # 004b6dd9
    mov dword ptr [eax + 0x5bb632], 0x2          # 004b6ddf
L_004b6de9:
    # block 0x004b6de9: entered by ja at 0x004b6848; jmp at 0x004b687e; jmp at 0x004b68de; jmp at 0x004b6afe; more, 1 instruction(s), ends with forward jump to 0x004b7021
    jmp.d32 L_004b7021                           # 004b6de9
L_004b6dee:
    # block 0x004b6dee: entered by je at 0x004b64ee, 8 instruction(s), ends with je to 0x004b6e24 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004b6dee
    mov edi, 0x551ba4                            # 004b6df8
    mov esi, dword ptr [ebp - local_20]          # 004b6dfd
    add esi, 0x2d9                               # 004b6e00
    mov ecx, 0x9                                 # 004b6e06
    {load} xor edx, edx                          # 004b6e0b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b6e0d
    je.d8 L_004b6e24                             # 004b6e0f
    # block 0x004b6e11: entered by fall-through of je at 0x004b6e0f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004b6e24
    mov eax, dword ptr [ebp - local_20]          # 004b6e11
    add eax, 0x2d9                               # 004b6e14
    push eax                                     # 004b6e19
    mov ecx, 0x5c3a67                            # 004b6e1a
    call FUN_004fba69                            # 004b6e1f
L_004b6e24:
    # block 0x004b6e24: entered by je at 0x004b6e0f, 5 instruction(s), ends with je to 0x004b6f19 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004b6e24
    {load} xor edx, edx                          # 004b6e27
    mov dl, byte ptr [ecx + field_229]           # 004b6e29
    test edx, edx                                # 004b6e2f
    je.d32 L_004b6f19                            # 004b6e31
    # block 0x004b6e37: entered by fall-through of je at 0x004b6e31, 4 instruction(s), ends with je to 0x004b6ee9 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6e37
    movsx ecx, word ptr [eax + field_376]        # 004b6e3a
    cmp ecx, 0x270f                              # 004b6e41
    je.d32 L_004b6ee9                            # 004b6e47
    # block 0x004b6e4d: entered by fall-through of je at 0x004b6e47, 25 instruction(s), ends with jne to 0x004b6ed5 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6e4d
    movsx eax, word ptr [edx + field_376]        # 004b6e50
    mov dword ptr [0x5bb57b], eax                # 004b6e57
    mov ecx, dword ptr [ebp - local_20]          # 004b6e5c
    mov dx, word ptr [ecx + field_378]           # 004b6e5f
    mov word ptr [0x5bb599], dx                  # 004b6e66
    mov eax, dword ptr [ebp - local_20]          # 004b6e6d
    mov cx, word ptr [eax + field_37a]           # 004b6e70
    mov word ptr [0x5bb595], cx                  # 004b6e77
    mov edx, dword ptr [ebp - local_20]          # 004b6e7e
    mov ax, word ptr [edx + field_37c]           # 004b6e81
    mov word ptr [0x5c39ff], ax                  # 004b6e88
    mov ecx, dword ptr [ebp - local_20]          # 004b6e8e
    mov edx, dword ptr [ecx + field_37e]         # 004b6e91
    mov dword ptr [0x5bb59b], edx                # 004b6e97
    mov eax, dword ptr [ebp - local_20]          # 004b6e9d
    mov ecx, dword ptr [eax + field_382]         # 004b6ea0
    mov dword ptr [0x5bb59f], ecx                # 004b6ea6
    mov edx, dword ptr [ebp - local_20]          # 004b6eac
    mov eax, dword ptr [edx + field_386]         # 004b6eaf
    mov dword ptr [0x5bb5a3], eax                # 004b6eb5
    mov ecx, dword ptr [ebp - local_20]          # 004b6eba
    movsx edx, word ptr [ecx + field_38a]        # 004b6ebd
    cmp edx, 0x1                                 # 004b6ec4
    jne.d8 L_004b6ed5                            # 004b6ec7
    # block 0x004b6ec9: entered by fall-through of jne at 0x004b6ec7, 2 instruction(s), ends with forward jump to 0x004b6edf
    mov dword ptr [0x5bb1ca], 0x0                # 004b6ec9
    jmp.d8 L_004b6edf                            # 004b6ed3
L_004b6ed5:
    # block 0x004b6ed5: entered by jne at 0x004b6ec7, 1 instruction(s), falls into the block at 0x004b6edf
    mov dword ptr [0x5bb1ca], 0x1                # 004b6ed5
L_004b6edf:
    # block 0x004b6edf: entered by jmp at 0x004b6ed3, 1 instruction(s), falls into the block at 0x004b6ee9
    mov dword ptr [0x583999], 0x4                # 004b6edf
L_004b6ee9:
    # block 0x004b6ee9: entered by je at 0x004b6e47, 4 instruction(s), ends with je to 0x004b6f14 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004b6ee9
    movsx ecx, word ptr [eax + field_38c]        # 004b6eec
    cmp ecx, -0x1                                # 004b6ef3
    je.d8 L_004b6f14                             # 004b6ef6
    # block 0x004b6ef8: entered by fall-through of je at 0x004b6ef6, 6 instruction(s), falls into the block at 0x004b6f14
    mov edx, dword ptr [ebp - local_20]          # 004b6ef8
    {load} xor eax, eax                          # 004b6efb
    mov al, byte ptr [edx + field_38e]           # 004b6efd
    mov ecx, dword ptr [ebp - local_20]          # 004b6f03
    movsx edx, word ptr [ecx + field_38c]        # 004b6f06
    mov dword ptr [4*edx + 0x585801], eax        # 004b6f0d
L_004b6f14:
    # block 0x004b6f14: entered by je at 0x004b6ef6, 1 instruction(s), ends with forward jump to 0x004b7009
    jmp.d32 L_004b7009                           # 004b6f14
L_004b6f19:
    # block 0x004b6f19: entered by je at 0x004b6e31, 5 instruction(s), ends with je to 0x004b7009 (forward)
    mov eax, dword ptr [ebp - local_30]          # 004b6f19
    {load} xor ecx, ecx                          # 004b6f1c
    mov cl, byte ptr [eax + field_22a]           # 004b6f1e
    test ecx, ecx                                # 004b6f24
    je.d32 L_004b7009                            # 004b6f26
    # block 0x004b6f2c: entered by fall-through of je at 0x004b6f26, 4 instruction(s), ends with je to 0x004b6fde (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6f2c
    movsx eax, word ptr [edx + field_32a]        # 004b6f2f
    cmp eax, 0x270f                              # 004b6f36
    je.d32 L_004b6fde                            # 004b6f3b
    # block 0x004b6f41: entered by fall-through of je at 0x004b6f3b, 25 instruction(s), ends with jne to 0x004b6fca (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004b6f41
    movsx edx, word ptr [ecx + field_32a]        # 004b6f44
    mov dword ptr [0x5bb57b], edx                # 004b6f4b
    mov eax, dword ptr [ebp - local_20]          # 004b6f51
    mov cx, word ptr [eax + field_32c]           # 004b6f54
    mov word ptr [0x5bb599], cx                  # 004b6f5b
    mov edx, dword ptr [ebp - local_20]          # 004b6f62
    mov ax, word ptr [edx + field_32e]           # 004b6f65
    mov word ptr [0x5bb595], ax                  # 004b6f6c
    mov ecx, dword ptr [ebp - local_20]          # 004b6f72
    mov dx, word ptr [ecx + field_330]           # 004b6f75
    mov word ptr [0x5c39ff], dx                  # 004b6f7c
    mov eax, dword ptr [ebp - local_20]          # 004b6f83
    mov ecx, dword ptr [eax + field_332]         # 004b6f86
    mov dword ptr [0x5bb59b], ecx                # 004b6f8c
    mov edx, dword ptr [ebp - local_20]          # 004b6f92
    mov eax, dword ptr [edx + field_336]         # 004b6f95
    mov dword ptr [0x5bb59f], eax                # 004b6f9b
    mov ecx, dword ptr [ebp - local_20]          # 004b6fa0
    mov edx, dword ptr [ecx + field_33a]         # 004b6fa3
    mov dword ptr [0x5bb5a3], edx                # 004b6fa9
    mov eax, dword ptr [ebp - local_20]          # 004b6faf
    movsx ecx, word ptr [eax + field_33e]        # 004b6fb2
    cmp ecx, 0x1                                 # 004b6fb9
    jne.d8 L_004b6fca                            # 004b6fbc
    # block 0x004b6fbe: entered by fall-through of jne at 0x004b6fbc, 2 instruction(s), ends with forward jump to 0x004b6fd4
    mov dword ptr [0x5bb1ca], 0x0                # 004b6fbe
    jmp.d8 L_004b6fd4                            # 004b6fc8
L_004b6fca:
    # block 0x004b6fca: entered by jne at 0x004b6fbc, 1 instruction(s), falls into the block at 0x004b6fd4
    mov dword ptr [0x5bb1ca], 0x1                # 004b6fca
L_004b6fd4:
    # block 0x004b6fd4: entered by jmp at 0x004b6fc8, 1 instruction(s), falls into the block at 0x004b6fde
    mov dword ptr [0x583999], 0x4                # 004b6fd4
L_004b6fde:
    # block 0x004b6fde: entered by je at 0x004b6f3b, 4 instruction(s), ends with je to 0x004b7009 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004b6fde
    movsx eax, word ptr [edx + field_340]        # 004b6fe1
    cmp eax, -0x1                                # 004b6fe8
    je.d8 L_004b7009                             # 004b6feb
    # block 0x004b6fed: entered by fall-through of je at 0x004b6feb, 6 instruction(s), falls into the block at 0x004b7009
    mov ecx, dword ptr [ebp - local_20]          # 004b6fed
    {load} xor edx, edx                          # 004b6ff0
    mov dl, byte ptr [ecx + field_342]           # 004b6ff2
    mov eax, dword ptr [ebp - local_20]          # 004b6ff8
    movsx ecx, word ptr [eax + field_340]        # 004b6ffb
    mov dword ptr [4*ecx + 0x585801], edx        # 004b7002
L_004b7009:
    # block 0x004b7009: entered by jmp at 0x004b6f14; je at 0x004b6f26; je at 0x004b6feb, 7 instruction(s), calls FUN_0042ba3a, FUN_004b5bc8, falls into the block at 0x004b7021
    mov edx, dword ptr [ebp - local_30]          # 004b7009
    mov ax, word ptr [edx + field_1e]            # 004b700c
    push eax                                     # 004b7010
    call FUN_0042ba3a                            # 004b7011
    add esp, 0x4                                 # 004b7016
    mov ecx, dword ptr [ebp - local_30]          # 004b7019
    call FUN_004b5bc8                            # 004b701c
L_004b7021:
    # block 0x004b7021: entered by jmp at 0x004b64f4; jmp at 0x004b6833; jmp at 0x004b6de9, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b7021
    pop esi                                      # 004b7022
    {load} mov esp, ebp                          # 004b7023
    pop ebp                                      # 004b7025
    ret 0x4                                      # 004b7026

# --- data items (not part of the function) -------------------------
.org 0x004b7029 - 0x401000
SWTAB_004b7029:  # 6 case address(es)
    .long L_004b6858 - .text + 0x401000
    .long L_004b6b03 - .text + 0x401000
    .long L_004b68e3 - .text + 0x401000
    .long L_004b6883 - .text + 0x401000
    .long L_004b6d41 - .text + 0x401000
    .long L_004b6c27 - .text + 0x401000
.set SWTAB_004b7029_VA, SWTAB_004b7029 - .text + 0x401000

