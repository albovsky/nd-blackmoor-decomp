# FUN_0047428c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047428c
# extent:       0x0047428c-0x0047511a (3726 code bytes)
# span:         0x0047428c-0x0047512a (code 3726, tables 16, padding 0)
# sha256:       9d06bac5e459aec3d5d88203e3f01f2cd1646aa825e401a6cb73496110667c83
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047428c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_76, field_7e, field_86, field_8a, field_8e, field_92, field_96 and 17 more; [ecx + n] field_4, field_8, field_c, field_14, field_76, field_7a, field_82, field_a2, field_a6, field_aa, field_ae, field_b2 and 21 more; [edi + n] field_96, field_9a; [edx + n] field_c, field_10, field_14, field_16, field_1a, field_1e, field_22, field_76, field_7a, field_7e, field_82, field_86 and 34 more; [esi + n] field_9e, field_a2
# callees:      calls FUN_00472fb7, FUN_004d39f9, FUN_004c2790, FUN_004741eb, FUN_004fb77a, FUN_004e1db3, FUN_004e29ec, FUN_004e2913, FUN_004740e5, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004730a6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 946 instruction(s), 39 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_7e, 0x7e  # offset +0x7e
.equ field_82, 0x82  # offset +0x82
.equ field_86, 0x86  # offset +0x86
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8e, 0x8e  # offset +0x8e
.equ field_92, 0x92  # offset +0x92
.equ field_96, 0x96  # offset +0x96
.equ field_9a, 0x9a  # offset +0x9a
.equ field_9e, 0x9e  # offset +0x9e
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ae, 0xae  # offset +0xae
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_107, 0x107  # offset +0x107
.equ field_10b, 0x10b  # offset +0x10b
.equ field_10f, 0x10f  # offset +0x10f
.equ field_113, 0x113  # offset +0x113
.equ field_147, 0x147  # offset +0x147
.equ field_14b, 0x14b  # offset +0x14b
.equ field_14f, 0x14f  # offset +0x14f
.equ field_153, 0x153  # offset +0x153
.equ field_187, 0x187  # offset +0x187
.equ field_18b, 0x18b  # offset +0x18b
.equ field_18f, 0x18f  # offset +0x18f
.equ field_193, 0x193  # offset +0x193
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2b9, 0x2b9  # offset +0x2b9
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2bb, 0x2bb  # offset +0x2bb
.equ field_349, 0x349  # offset +0x349
.equ field_34d, 0x34d  # offset +0x34d
.equ field_351, 0x351  # offset +0x351
.equ field_355, 0x355  # offset +0x355
.equ field_359, 0x359  # offset +0x359
.equ field_35d, 0x35d  # offset +0x35d
.equ field_35f, 0x35f  # offset +0x35f
.equ field_48a, 0x48a  # offset +0x48a
.equ field_48c, 0x48c  # offset +0x48c
.equ field_48e, 0x48e  # offset +0x48e
.equ field_490, 0x490  # offset +0x490
.equ field_492, 0x492  # offset +0x492
.equ field_496, 0x496  # offset +0x496
.equ field_49a, 0x49a  # offset +0x49a
.equ field_49e, 0x49e  # offset +0x49e
.equ field_4a0, 0x4a0  # offset +0x4a0
.equ field_4a2, 0x4a2  # offset +0x4a2
.equ field_4a3, 0x4a3  # offset +0x4a3
.equ field_4c6, 0x4c6  # offset +0x4c6
.equ field_4d6, 0x4d6  # offset +0x4d6
.equ field_4d8, 0x4d8  # offset +0x4d8
.equ field_4da, 0x4da  # offset +0x4da
.equ field_4dc, 0x4dc  # offset +0x4dc
.equ field_4de, 0x4de  # offset +0x4de
.equ field_4e2, 0x4e2  # offset +0x4e2
.equ field_4e6, 0x4e6  # offset +0x4e6
.equ field_4ea, 0x4ea  # offset +0x4ea
.equ field_4ec, 0x4ec  # offset +0x4ec
.equ field_4ee, 0x4ee  # offset +0x4ee

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00472fb7, .text + (0x00472fb7 - 0x401000)
.set FUN_004730a6, .text + (0x004730a6 - 0x401000)
.set FUN_004740e5, .text + (0x004740e5 - 0x401000)
.set FUN_004741eb, .text + (0x004741eb - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0047428c - 0x401000
.globl FUN_0047428c
FUN_0047428c:
    # block 0x0047428c: entry, 17 instruction(s), ends with je to 0x004742df (forward)
    push ebp                                     # 0047428c
    {load} mov ebp, esp                          # 0047428d
    sub esp, 0x14                                # 0047428f
    push esi                                     # 00474292
    push edi                                     # 00474293
    mov dword ptr [ebp - local_c], ecx           # 00474294
    movsx eax, word ptr [ebp + arg_8]            # 00474297
    imul eax, eax, 0x8d                          # 0047429b
    mov ecx, dword ptr [ebp - local_c]           # 004742a1
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004742a4
    mov dword ptr [ecx + field_76], edx          # 004742aa
    movsx eax, word ptr [ebp + arg_8]            # 004742ad
    imul eax, eax, 0x8d                          # 004742b1
    mov ecx, dword ptr [eax + 0x5bb632]          # 004742b7
    mov dword ptr [ebp - local_10], ecx          # 004742bd
    cmp dword ptr [ebp - local_10], 0x0          # 004742c0
    je.d8 L_004742df                             # 004742c4
    # block 0x004742c6: entered by fall-through of je at 0x004742c4, 2 instruction(s), ends with je to 0x00474c44 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004742c6
    je.d32 L_00474c44                            # 004742ca
    # block 0x004742d0: entered by fall-through of je at 0x004742ca, 2 instruction(s), ends with je to 0x00474e68 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004742d0
    je.d32 L_00474e68                            # 004742d4
    # block 0x004742da: entered by fall-through of je at 0x004742d4, 1 instruction(s), ends with forward jump to 0x00475112
    jmp.d32 L_00475112                           # 004742da
L_004742df:
    # block 0x004742df: entered by je at 0x004742c4, 64 instruction(s), calls FUN_00472fb7, FUN_004d39f9, ends with jne to 0x00474412 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004742df
    call FUN_00472fb7                            # 004742e2
    mov edx, dword ptr [ebp - local_c]           # 004742e7
    mov ax, word ptr [ebp + arg_8]               # 004742ea
    mov word ptr [edx + field_c], ax             # 004742ee
    mov ecx, dword ptr [ebp - local_c]           # 004742f2
    mov dword ptr [ecx + field_7a], 0x1          # 004742f5
    mov edx, dword ptr [ebp - local_c]           # 004742fc
    mov dword ptr [edx + field_82], 0x0          # 004742ff
    mov eax, dword ptr [ebp - local_c]           # 00474309
    mov dword ptr [eax + field_7e], 0x0          # 0047430c
    mov dword ptr [0x5bb1ca], 0x1                # 00474313
    call FUN_004d39f9                            # 0047431d
    mov ecx, dword ptr [ebp - local_c]           # 00474322
    mov word ptr [ecx + field_14], ax            # 00474325
    mov edx, dword ptr [ebp - local_c]           # 00474329
    movsx eax, word ptr [edx + field_14]         # 0047432c
    imul eax, eax, 0x4a                          # 00474330
    mov dword ptr [eax + 0x5d1591], 0xa          # 00474333
    mov ecx, dword ptr [ebp - local_c]           # 0047433d
    movsx edx, word ptr [ecx + field_14]         # 00474340
    imul edx, edx, 0x4a                          # 00474344
    mov dword ptr [edx + 0x5d1595], 0x4754d2     # 00474347
    mov eax, dword ptr [ebp - local_c]           # 00474351
    movsx ecx, word ptr [eax + field_14]         # 00474354
    imul ecx, ecx, 0x4a                          # 00474358
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0047435b
    mov edx, dword ptr [ebp - local_c]           # 00474365
    movsx eax, word ptr [edx + field_14]         # 00474368
    imul eax, eax, 0x4a                          # 0047436c
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0047436f
    mov ecx, dword ptr [ebp - local_c]           # 00474379
    movsx edx, word ptr [ecx + field_14]         # 0047437c
    imul edx, edx, 0x4a                          # 00474380
    mov dword ptr [edx + 0x5d15a5], 0x1          # 00474383
    mov eax, dword ptr [ebp - local_c]           # 0047438d
    movsx ecx, word ptr [eax + field_14]         # 00474390
    imul ecx, ecx, 0x4a                          # 00474394
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 00474397
    mov edx, dword ptr [ebp - local_c]           # 004743a1
    movsx eax, word ptr [edx + field_14]         # 004743a4
    imul eax, eax, 0x4a                          # 004743a8
    mov word ptr [eax + 0x5d15ad], 0x0           # 004743ab
    mov edi, 0x54c61c                            # 004743b4
    mov ecx, dword ptr [ebp - local_c]           # 004743b9
    movsx edx, word ptr [ecx + field_14]         # 004743bc
    imul edx, edx, 0x4a                          # 004743c0
    add edx, 0x5d15b3                            # 004743c3
    or ecx, -0x1                                 # 004743c9
    {load} xor eax, eax                          # 004743cc
    repne scasb al, byte ptr es:[edi]            # 004743ce
    not ecx                                      # 004743d0
    {load} sub edi, ecx                          # 004743d2
    {load} mov esi, edi                          # 004743d4
    {load} mov eax, ecx                          # 004743d6
    {load} mov edi, edx                          # 004743d8
    shr ecx, 0x2                                 # 004743da
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004743dd
    {load} mov ecx, eax                          # 004743df
    and ecx, 0x3                                 # 004743e1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004743e4
    mov ecx, dword ptr [ebp - local_c]           # 004743e6
    cmp dword ptr [ecx + field_4], 0x0           # 004743e9
    jne.d8 L_00474412                            # 004743ed
    # block 0x004743ef: entered by fall-through of jne at 0x004743ed, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x00474412
    push 0x54c630                                # 004743ef
    push 0x6                                     # 004743f4
    mov edx, dword ptr [ebp - local_c]           # 004743f6
    mov eax, dword ptr [edx + field_76]          # 004743f9
    push eax                                     # 004743fc
    push 0x54c64c                                # 004743fd
    mov ecx, 0x5cf659                            # 00474402
    call FUN_004c2790                            # 00474407
    mov ecx, dword ptr [ebp - local_c]           # 0047440c
    mov dword ptr [ecx + field_4], eax           # 0047440f
L_00474412:
    # block 0x00474412: entered by jne at 0x004743ed, 9 instruction(s), ends with jne to 0x00474457 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474412
    movsx eax, word ptr [edx + field_14]         # 00474415
    imul eax, eax, 0x4a                          # 00474419
    mov ecx, dword ptr [ebp - local_c]           # 0047441c
    mov edx, dword ptr [ecx + field_4]           # 0047441f
    mov dword ptr [eax + 0x5d1599], edx          # 00474422
    mov eax, dword ptr [ebp - local_c]           # 00474428
    cmp dword ptr [eax + field_8], 0x0           # 0047442b
    jne.d8 L_00474457                            # 0047442f
    # block 0x00474431: entered by fall-through of jne at 0x0047442f, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x00474457
    push 0x54c654                                # 00474431
    push 0x6                                     # 00474436
    mov ecx, dword ptr [ebp - local_c]           # 00474438
    mov edx, dword ptr [ecx + field_76]          # 0047443b
    add edx, 0x21                                # 0047443e
    push edx                                     # 00474441
    push 0x54c674                                # 00474442
    mov ecx, 0x5cf659                            # 00474447
    call FUN_004c2790                            # 0047444c
    mov ecx, dword ptr [ebp - local_c]           # 00474451
    mov dword ptr [ecx + field_8], eax           # 00474454
L_00474457:
    # block 0x00474457: entered by jne at 0x0047442f, 2 instruction(s), ends with forward jump to 0x00474469
    mov dword ptr [ebp - local_4], 0x0           # 00474457
    jmp.d8 L_00474469                            # 0047445e
L_00474460:
    # block 0x00474460: entered by jmp at 0x0047450b, 3 instruction(s), falls into the block at 0x00474469
    mov edx, dword ptr [ebp - local_4]           # 00474460
    add edx, 0x1                                 # 00474463
    mov dword ptr [ebp - local_4], edx           # 00474466
L_00474469:
    # block 0x00474469: entered by jmp at 0x0047445e, 2 instruction(s), ends with jge to 0x00474510 (forward)
    cmp dword ptr [ebp - local_4], 0x6           # 00474469
    jge.d32 L_00474510                           # 0047446d
    # block 0x00474473: entered by fall-through of jge at 0x0047446d, 41 instruction(s), ends with backward jump to 0x00474460
    mov eax, dword ptr [ebp - local_c]           # 00474473
    mov ecx, dword ptr [eax + field_76]          # 00474476
    mov edx, dword ptr [ebp - local_4]           # 00474479
    shl edx, 0x4                                 # 0047447c
    mov eax, dword ptr [ecx + edx + field_a2]    # 0047447f
    add eax, dword ptr [0x583186]                # 00474486
    mov ecx, dword ptr [ebp - local_4]           # 0047448c
    shl ecx, 0x4                                 # 0047448f
    mov edx, dword ptr [ebp - local_c]           # 00474492
    mov dword ptr [edx + ecx + field_16], eax    # 00474495
    mov eax, dword ptr [ebp - local_c]           # 00474499
    mov ecx, dword ptr [eax + field_76]          # 0047449c
    mov edx, dword ptr [ebp - local_4]           # 0047449f
    shl edx, 0x4                                 # 004744a2
    mov eax, dword ptr [ecx + edx + field_aa]    # 004744a5
    add eax, dword ptr [0x583186]                # 004744ac
    mov ecx, dword ptr [ebp - local_4]           # 004744b2
    shl ecx, 0x4                                 # 004744b5
    mov edx, dword ptr [ebp - local_c]           # 004744b8
    mov dword ptr [edx + ecx + field_1e], eax    # 004744bb
    mov eax, dword ptr [ebp - local_c]           # 004744bf
    mov ecx, dword ptr [eax + field_76]          # 004744c2
    mov edx, dword ptr [ebp - local_4]           # 004744c5
    shl edx, 0x4                                 # 004744c8
    mov eax, dword ptr [ecx + edx + field_a6]    # 004744cb
    add eax, dword ptr [0x58318a]                # 004744d2
    mov ecx, dword ptr [ebp - local_4]           # 004744d8
    shl ecx, 0x4                                 # 004744db
    mov edx, dword ptr [ebp - local_c]           # 004744de
    mov dword ptr [edx + ecx + field_1a], eax    # 004744e1
    mov eax, dword ptr [ebp - local_c]           # 004744e5
    mov ecx, dword ptr [eax + field_76]          # 004744e8
    mov edx, dword ptr [ebp - local_4]           # 004744eb
    shl edx, 0x4                                 # 004744ee
    mov eax, dword ptr [ecx + edx + field_ae]    # 004744f1
    add eax, dword ptr [0x58318a]                # 004744f8
    mov ecx, dword ptr [ebp - local_4]           # 004744fe
    shl ecx, 0x4                                 # 00474501
    mov edx, dword ptr [ebp - local_c]           # 00474504
    mov dword ptr [edx + ecx + field_22], eax    # 00474507
    jmp.d32 L_00474460                           # 0047450b
L_00474510:
    # block 0x00474510: entered by jge at 0x0047446d, 2 instruction(s), ends with forward jump to 0x00474522
    mov dword ptr [ebp - local_4], 0x0           # 00474510
    jmp.d8 L_00474522                            # 00474517
L_00474519:
    # block 0x00474519: entered by jmp at 0x00474814, 3 instruction(s), falls into the block at 0x00474522
    mov eax, dword ptr [ebp - local_4]           # 00474519
    add eax, 0x1                                 # 0047451c
    mov dword ptr [ebp - local_4], eax           # 0047451f
L_00474522:
    # block 0x00474522: entered by jmp at 0x00474517, 2 instruction(s), ends with jge to 0x00474819 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00474522
    jge.d32 L_00474819                           # 00474526
    # block 0x0047452c: entered by fall-through of jge at 0x00474526, 197 instruction(s), ends with backward jump to 0x00474519
    mov ecx, dword ptr [ebp - local_c]           # 0047452c
    mov edx, dword ptr [ecx + field_76]          # 0047452f
    mov eax, dword ptr [ebp - local_4]           # 00474532
    shl eax, 0x4                                 # 00474535
    mov ecx, dword ptr [edx + eax + field_147]   # 00474538
    add ecx, dword ptr [0x583186]                # 0047453f
    mov edx, dword ptr [ebp - local_4]           # 00474545
    imul edx, edx, 0x38                          # 00474548
    mov eax, dword ptr [ebp - local_c]           # 0047454b
    mov dword ptr [eax + edx + field_86], ecx    # 0047454e
    mov ecx, dword ptr [ebp - local_c]           # 00474555
    mov edx, dword ptr [ecx + field_76]          # 00474558
    mov eax, dword ptr [ebp - local_4]           # 0047455b
    shl eax, 0x4                                 # 0047455e
    mov ecx, dword ptr [edx + eax + field_14f]   # 00474561
    add ecx, dword ptr [0x583186]                # 00474568
    mov edx, dword ptr [ebp - local_4]           # 0047456e
    imul edx, edx, 0x38                          # 00474571
    mov eax, dword ptr [ebp - local_c]           # 00474574
    mov dword ptr [eax + edx + field_8e], ecx    # 00474577
    mov ecx, dword ptr [ebp - local_c]           # 0047457e
    mov edx, dword ptr [ecx + field_76]          # 00474581
    mov eax, dword ptr [ebp - local_4]           # 00474584
    shl eax, 0x4                                 # 00474587
    mov ecx, dword ptr [edx + eax + field_14b]   # 0047458a
    add ecx, dword ptr [0x58318a]                # 00474591
    mov edx, dword ptr [ebp - local_4]           # 00474597
    imul edx, edx, 0x38                          # 0047459a
    mov eax, dword ptr [ebp - local_c]           # 0047459d
    mov dword ptr [eax + edx + field_8a], ecx    # 004745a0
    mov ecx, dword ptr [ebp - local_c]           # 004745a7
    mov edx, dword ptr [ecx + field_76]          # 004745aa
    mov eax, dword ptr [ebp - local_4]           # 004745ad
    shl eax, 0x4                                 # 004745b0
    mov ecx, dword ptr [edx + eax + field_153]   # 004745b3
    add ecx, dword ptr [0x58318a]                # 004745ba
    mov edx, dword ptr [ebp - local_4]           # 004745c0
    imul edx, edx, 0x38                          # 004745c3
    mov eax, dword ptr [ebp - local_c]           # 004745c6
    mov dword ptr [eax + edx + field_92], ecx    # 004745c9
    mov ecx, dword ptr [ebp - local_c]           # 004745d0
    mov edx, dword ptr [ecx + field_76]          # 004745d3
    mov eax, dword ptr [ebp - local_4]           # 004745d6
    shl eax, 0x4                                 # 004745d9
    mov ecx, dword ptr [edx + eax + field_187]   # 004745dc
    add ecx, dword ptr [0x583186]                # 004745e3
    mov edx, dword ptr [ebp - local_4]           # 004745e9
    imul edx, edx, 0x38                          # 004745ec
    mov eax, dword ptr [ebp - local_c]           # 004745ef
    mov dword ptr [eax + edx + field_96], ecx    # 004745f2
    mov ecx, dword ptr [ebp - local_c]           # 004745f9
    mov edx, dword ptr [ecx + field_76]          # 004745fc
    mov eax, dword ptr [ebp - local_4]           # 004745ff
    shl eax, 0x4                                 # 00474602
    mov ecx, dword ptr [edx + eax + field_18f]   # 00474605
    add ecx, dword ptr [0x583186]                # 0047460c
    mov edx, dword ptr [ebp - local_4]           # 00474612
    imul edx, edx, 0x38                          # 00474615
    mov eax, dword ptr [ebp - local_c]           # 00474618
    mov dword ptr [eax + edx + field_9e], ecx    # 0047461b
    mov ecx, dword ptr [ebp - local_c]           # 00474622
    mov edx, dword ptr [ecx + field_76]          # 00474625
    mov eax, dword ptr [ebp - local_4]           # 00474628
    shl eax, 0x4                                 # 0047462b
    mov ecx, dword ptr [edx + eax + field_18b]   # 0047462e
    add ecx, dword ptr [0x58318a]                # 00474635
    mov edx, dword ptr [ebp - local_4]           # 0047463b
    imul edx, edx, 0x38                          # 0047463e
    mov eax, dword ptr [ebp - local_c]           # 00474641
    mov dword ptr [eax + edx + field_9a], ecx    # 00474644
    mov ecx, dword ptr [ebp - local_c]           # 0047464b
    mov edx, dword ptr [ecx + field_76]          # 0047464e
    mov eax, dword ptr [ebp - local_4]           # 00474651
    shl eax, 0x4                                 # 00474654
    mov ecx, dword ptr [edx + eax + field_193]   # 00474657
    add ecx, dword ptr [0x58318a]                # 0047465e
    mov edx, dword ptr [ebp - local_4]           # 00474664
    imul edx, edx, 0x38                          # 00474667
    mov eax, dword ptr [ebp - local_c]           # 0047466a
    mov dword ptr [eax + edx + field_a2], ecx    # 0047466d
    mov ecx, dword ptr [ebp - local_c]           # 00474674
    mov edx, dword ptr [ecx + field_76]          # 00474677
    mov eax, dword ptr [ebp - local_4]           # 0047467a
    shl eax, 0x4                                 # 0047467d
    mov ecx, dword ptr [ebp - local_c]           # 00474680
    mov ecx, dword ptr [ecx + field_76]          # 00474683
    mov esi, dword ptr [ebp - local_4]           # 00474686
    shl esi, 0x4                                 # 00474689
    mov edx, dword ptr [edx + eax + field_10f]   # 0047468c
    sub edx, dword ptr [ecx + esi + field_107]   # 00474693
    add edx, 0x1                                 # 0047469a
    mov eax, dword ptr [ebp - local_4]           # 0047469d
    imul eax, eax, 0x38                          # 004746a0
    mov ecx, dword ptr [ebp - local_c]           # 004746a3
    mov dword ptr [ecx + eax + field_b6], edx    # 004746a6
    mov edx, dword ptr [ebp - local_c]           # 004746ad
    mov eax, dword ptr [edx + field_76]          # 004746b0
    mov ecx, dword ptr [ebp - local_4]           # 004746b3
    shl ecx, 0x4                                 # 004746b6
    mov edx, dword ptr [ebp - local_c]           # 004746b9
    mov edx, dword ptr [edx + field_76]          # 004746bc
    mov esi, dword ptr [ebp - local_4]           # 004746bf
    shl esi, 0x4                                 # 004746c2
    mov eax, dword ptr [eax + ecx + field_113]   # 004746c5
    sub eax, dword ptr [edx + esi + field_10b]   # 004746cc
    add eax, 0x1                                 # 004746d3
    mov ecx, dword ptr [ebp - local_4]           # 004746d6
    imul ecx, ecx, 0x38                          # 004746d9
    mov edx, dword ptr [ebp - local_c]           # 004746dc
    mov dword ptr [edx + ecx + field_ba], eax    # 004746df
    mov ecx, dword ptr [ebp - local_4]           # 004746e6
    imul ecx, ecx, 0x38                          # 004746e9
    mov edx, dword ptr [ebp - local_4]           # 004746ec
    imul edx, edx, 0x38                          # 004746ef
    mov eax, dword ptr [ebp - local_4]           # 004746f2
    imul eax, eax, 0x38                          # 004746f5
    mov esi, dword ptr [ebp - local_c]           # 004746f8
    mov edi, dword ptr [ebp - local_c]           # 004746fb
    mov edx, dword ptr [esi + edx + field_9e]    # 004746fe
    sub edx, dword ptr [edi + eax + field_96]    # 00474705
    add edx, 0x1                                 # 0047470c
    {load} mov eax, edx                          # 0047470f
    cdq                                          # 00474711
    {load} sub eax, edx                          # 00474712
    sar eax                                      # 00474714
    mov edx, dword ptr [ebp - local_c]           # 00474716
    mov ecx, dword ptr [edx + ecx + field_96]    # 00474719
    {load} add ecx, eax                          # 00474720
    mov edx, dword ptr [ebp - local_4]           # 00474722
    imul edx, edx, 0x38                          # 00474725
    mov eax, dword ptr [ebp - local_c]           # 00474728
    mov eax, dword ptr [eax + edx + field_b6]    # 0047472b
    cdq                                          # 00474732
    {load} sub eax, edx                          # 00474733
    sar eax                                      # 00474735
    {load} sub ecx, eax                          # 00474737
    mov edx, dword ptr [ebp - local_4]           # 00474739
    imul edx, edx, 0x38                          # 0047473c
    mov eax, dword ptr [ebp - local_c]           # 0047473f
    mov dword ptr [eax + edx + field_a6], ecx    # 00474742
    mov ecx, dword ptr [ebp - local_4]           # 00474749
    imul ecx, ecx, 0x38                          # 0047474c
    mov edx, dword ptr [ebp - local_4]           # 0047474f
    imul edx, edx, 0x38                          # 00474752
    mov eax, dword ptr [ebp - local_4]           # 00474755
    imul eax, eax, 0x38                          # 00474758
    mov esi, dword ptr [ebp - local_c]           # 0047475b
    mov edi, dword ptr [ebp - local_c]           # 0047475e
    mov edx, dword ptr [esi + edx + field_a2]    # 00474761
    sub edx, dword ptr [edi + eax + field_9a]    # 00474768
    add edx, 0x1                                 # 0047476f
    {load} mov eax, edx                          # 00474772
    cdq                                          # 00474774
    {load} sub eax, edx                          # 00474775
    sar eax                                      # 00474777
    mov edx, dword ptr [ebp - local_c]           # 00474779
    mov ecx, dword ptr [edx + ecx + field_9a]    # 0047477c
    {load} add ecx, eax                          # 00474783
    mov edx, dword ptr [ebp - local_4]           # 00474785
    imul edx, edx, 0x38                          # 00474788
    mov eax, dword ptr [ebp - local_c]           # 0047478b
    mov eax, dword ptr [eax + edx + field_ba]    # 0047478e
    cdq                                          # 00474795
    {load} sub eax, edx                          # 00474796
    sar eax                                      # 00474798
    {load} sub ecx, eax                          # 0047479a
    mov edx, dword ptr [ebp - local_4]           # 0047479c
    imul edx, edx, 0x38                          # 0047479f
    mov eax, dword ptr [ebp - local_c]           # 004747a2
    mov dword ptr [eax + edx + field_aa], ecx    # 004747a5
    mov ecx, dword ptr [ebp - local_4]           # 004747ac
    imul ecx, ecx, 0x38                          # 004747af
    mov edx, dword ptr [ebp - local_4]           # 004747b2
    imul edx, edx, 0x38                          # 004747b5
    mov eax, dword ptr [ebp - local_c]           # 004747b8
    mov ecx, dword ptr [eax + ecx + field_a6]    # 004747bb
    mov eax, dword ptr [ebp - local_c]           # 004747c2
    mov edx, dword ptr [eax + edx + field_b6]    # 004747c5
    lea eax, [ecx + edx - field_minus_1]         # 004747cc
    mov ecx, dword ptr [ebp - local_4]           # 004747d0
    imul ecx, ecx, 0x38                          # 004747d3
    mov edx, dword ptr [ebp - local_c]           # 004747d6
    mov dword ptr [edx + ecx + field_ae], eax    # 004747d9
    mov eax, dword ptr [ebp - local_4]           # 004747e0
    imul eax, eax, 0x38                          # 004747e3
    mov ecx, dword ptr [ebp - local_4]           # 004747e6
    imul ecx, ecx, 0x38                          # 004747e9
    mov edx, dword ptr [ebp - local_c]           # 004747ec
    mov eax, dword ptr [edx + eax + field_aa]    # 004747ef
    mov edx, dword ptr [ebp - local_c]           # 004747f6
    mov ecx, dword ptr [edx + ecx + field_ba]    # 004747f9
    lea edx, [eax + ecx - field_minus_1]         # 00474800
    mov eax, dword ptr [ebp - local_4]           # 00474804
    imul eax, eax, 0x38                          # 00474807
    mov ecx, dword ptr [ebp - local_c]           # 0047480a
    mov dword ptr [ecx + eax + field_b2], edx    # 0047480d
    jmp.d32 L_00474519                           # 00474814
L_00474819:
    # block 0x00474819: entered by jge at 0x00474526, 2 instruction(s), ends with forward jump to 0x0047482b
    mov dword ptr [ebp - local_4], 0x0           # 00474819
    jmp.d8 L_0047482b                            # 00474820
L_00474822:
    # block 0x00474822: entered by jmp at 0x004748a4, 3 instruction(s), falls into the block at 0x0047482b
    mov edx, dword ptr [ebp - local_4]           # 00474822
    add edx, 0x1                                 # 00474825
    mov dword ptr [ebp - local_4], edx           # 00474828
L_0047482b:
    # block 0x0047482b: entered by jmp at 0x00474820, 2 instruction(s), ends with jge to 0x004748a9 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 0047482b
    jge.d8 L_004748a9                            # 0047482f
    # block 0x00474831: entered by fall-through of jge at 0x0047482f, 3 instruction(s), ends with je to 0x00474872 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00474831
    cmp dword ptr [4*eax + 0x5a4b4e], 0x0        # 00474834
    je.d8 L_00474872                             # 0047483c
    # block 0x0047483e: entered by fall-through of je at 0x0047483c, 16 instruction(s), ends with forward jump to 0x004748a4
    mov ecx, dword ptr [ebp - local_4]           # 0047483e
    imul ecx, ecx, 0x38                          # 00474841
    mov edx, dword ptr [ebp - local_c]           # 00474844
    lea eax, [edx + ecx + field_a6]              # 00474847
    mov ecx, dword ptr [ebp - local_4]           # 0047484e
    shl ecx, 0x4                                 # 00474851
    add ecx, 0x5a4b5e                            # 00474854
    mov edx, dword ptr [eax]                     # 0047485a
    mov dword ptr [ecx], edx                     # 0047485c
    mov edx, dword ptr [eax + field_4]           # 0047485e
    mov dword ptr [ecx + field_4], edx           # 00474861
    mov edx, dword ptr [eax + field_8]           # 00474864
    mov dword ptr [ecx + field_8], edx           # 00474867
    mov eax, dword ptr [eax + field_c]           # 0047486a
    mov dword ptr [ecx + field_c], eax           # 0047486d
    jmp.d8 L_004748a4                            # 00474870
L_00474872:
    # block 0x00474872: entered by je at 0x0047483c, 15 instruction(s), falls into the block at 0x004748a4
    mov ecx, dword ptr [ebp - local_4]           # 00474872
    imul ecx, ecx, 0x38                          # 00474875
    mov edx, dword ptr [ebp - local_c]           # 00474878
    lea eax, [edx + ecx + field_86]              # 0047487b
    mov ecx, dword ptr [ebp - local_4]           # 00474882
    shl ecx, 0x4                                 # 00474885
    add ecx, 0x5a4b5e                            # 00474888
    mov edx, dword ptr [eax]                     # 0047488e
    mov dword ptr [ecx], edx                     # 00474890
    mov edx, dword ptr [eax + field_4]           # 00474892
    mov dword ptr [ecx + field_4], edx           # 00474895
    mov edx, dword ptr [eax + field_8]           # 00474898
    mov dword ptr [ecx + field_8], edx           # 0047489b
    mov eax, dword ptr [eax + field_c]           # 0047489e
    mov dword ptr [ecx + field_c], eax           # 004748a1
L_004748a4:
    # block 0x004748a4: entered by jmp at 0x00474870, 1 instruction(s), ends with backward jump to 0x00474822
    jmp.d32 L_00474822                           # 004748a4
L_004748a9:
    # block 0x004748a9: entered by jge at 0x0047482f, 27 instruction(s), calls FUN_004741eb, ends with je to 0x00474932 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004748a9
    call FUN_004741eb                            # 004748ac
    mov ecx, dword ptr [ebp - local_c]           # 004748b1
    mov edx, dword ptr [ecx + field_76]          # 004748b4
    mov al, byte ptr [edx + field_2b6]           # 004748b7
    and al, byte ptr [0x5d2f1f]                  # 004748bd
    mov ecx, dword ptr [ebp - local_c]           # 004748c3
    mov edx, dword ptr [ecx + field_76]          # 004748c6
    mov byte ptr [edx + field_2b6], al           # 004748c9
    mov eax, dword ptr [ebp - local_c]           # 004748cf
    mov ecx, dword ptr [eax + field_76]          # 004748d2
    mov dl, byte ptr [ecx + field_2b7]           # 004748d5
    and dl, byte ptr [0x5d2f1e]                  # 004748db
    mov eax, dword ptr [ebp - local_c]           # 004748e1
    mov ecx, dword ptr [eax + field_76]          # 004748e4
    mov byte ptr [ecx + field_2b7], dl           # 004748e7
    mov edx, dword ptr [ebp - local_c]           # 004748ed
    mov eax, dword ptr [edx + field_76]          # 004748f0
    mov cl, byte ptr [eax + field_2b8]           # 004748f3
    and cl, byte ptr [0x5d2f1d]                  # 004748f9
    mov edx, dword ptr [ebp - local_c]           # 004748ff
    mov eax, dword ptr [edx + field_76]          # 00474902
    mov byte ptr [eax + field_2b8], cl           # 00474905
    {load} xor ecx, ecx                          # 0047490b
    mov cl, byte ptr [0x5d2f23]                  # 0047490d
    cmp ecx, 0x5                                 # 00474913
    je.d8 L_00474932                             # 00474916
    # block 0x00474918: entered by fall-through of je at 0x00474916, 7 instruction(s), falls into the block at 0x00474932
    mov edx, dword ptr [ebp - local_c]           # 00474918
    mov eax, dword ptr [edx + field_76]          # 0047491b
    mov cl, byte ptr [eax + field_2b6]           # 0047491e
    shl cl                                       # 00474924
    mov edx, dword ptr [ebp - local_c]           # 00474926
    mov eax, dword ptr [edx + field_76]          # 00474929
    mov byte ptr [eax + field_2b6], cl           # 0047492c
L_00474932:
    # block 0x00474932: entered by je at 0x00474916, 4 instruction(s), ends with je to 0x00474959 (forward)
    {load} xor ecx, ecx                          # 00474932
    mov cl, byte ptr [0x5d2f22]                  # 00474934
    cmp ecx, 0x5                                 # 0047493a
    je.d8 L_00474959                             # 0047493d
    # block 0x0047493f: entered by fall-through of je at 0x0047493d, 7 instruction(s), falls into the block at 0x00474959
    mov edx, dword ptr [ebp - local_c]           # 0047493f
    mov eax, dword ptr [edx + field_76]          # 00474942
    mov cl, byte ptr [eax + field_2b7]           # 00474945
    shl cl                                       # 0047494b
    mov edx, dword ptr [ebp - local_c]           # 0047494d
    mov eax, dword ptr [edx + field_76]          # 00474950
    mov byte ptr [eax + field_2b7], cl           # 00474953
L_00474959:
    # block 0x00474959: entered by je at 0x0047493d, 4 instruction(s), ends with je to 0x00474980 (forward)
    {load} xor ecx, ecx                          # 00474959
    mov cl, byte ptr [0x5d2f21]                  # 0047495b
    cmp ecx, 0x5                                 # 00474961
    je.d8 L_00474980                             # 00474964
    # block 0x00474966: entered by fall-through of je at 0x00474964, 7 instruction(s), falls into the block at 0x00474980
    mov edx, dword ptr [ebp - local_c]           # 00474966
    mov eax, dword ptr [edx + field_76]          # 00474969
    mov cl, byte ptr [eax + field_2b8]           # 0047496c
    shl cl                                       # 00474972
    mov edx, dword ptr [ebp - local_c]           # 00474974
    mov eax, dword ptr [edx + field_76]          # 00474977
    mov byte ptr [eax + field_2b8], cl           # 0047497a
L_00474980:
    # block 0x00474980: entered by je at 0x00474964, 52 instruction(s), ends with je to 0x00474a5b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00474980
    mov edx, dword ptr [ecx + field_76]          # 00474983
    {load} xor eax, eax                          # 00474986
    mov al, byte ptr [edx + field_2b6]           # 00474988
    {load} xor ecx, ecx                          # 0047498e
    mov cl, byte ptr [0x5d2f1b]                  # 00474990
    shl eax, cl                                  # 00474996
    mov ecx, dword ptr [ebp - local_c]           # 00474998
    mov edx, dword ptr [ecx + field_76]          # 0047499b
    {load} xor ecx, ecx                          # 0047499e
    mov cl, byte ptr [edx + field_2b7]           # 004749a0
    {load} mov edx, ecx                          # 004749a6
    {load} xor ecx, ecx                          # 004749a8
    mov cl, byte ptr [0x5d2f1a]                  # 004749aa
    shl edx, cl                                  # 004749b0
    {load} or eax, edx                           # 004749b2
    mov ecx, dword ptr [ebp - local_c]           # 004749b4
    mov edx, dword ptr [ecx + field_76]          # 004749b7
    {load} xor ecx, ecx                          # 004749ba
    mov cl, byte ptr [edx + field_2b8]           # 004749bc
    {load} mov edx, ecx                          # 004749c2
    {load} xor ecx, ecx                          # 004749c4
    mov cl, byte ptr [0x5d2f19]                  # 004749c6
    shl edx, cl                                  # 004749cc
    {load} or eax, edx                           # 004749ce
    mov ecx, dword ptr [ebp - local_c]           # 004749d0
    mov word ptr [ecx + field_35d], ax           # 004749d3
    mov edx, dword ptr [ebp - local_c]           # 004749da
    mov eax, dword ptr [edx + field_76]          # 004749dd
    mov cl, byte ptr [eax + field_2b9]           # 004749e0
    and cl, byte ptr [0x5d2f1f]                  # 004749e6
    mov edx, dword ptr [ebp - local_c]           # 004749ec
    mov eax, dword ptr [edx + field_76]          # 004749ef
    mov byte ptr [eax + field_2b9], cl           # 004749f2
    mov ecx, dword ptr [ebp - local_c]           # 004749f8
    mov edx, dword ptr [ecx + field_76]          # 004749fb
    mov al, byte ptr [edx + field_2ba]           # 004749fe
    and al, byte ptr [0x5d2f1e]                  # 00474a04
    mov ecx, dword ptr [ebp - local_c]           # 00474a0a
    mov edx, dword ptr [ecx + field_76]          # 00474a0d
    mov byte ptr [edx + field_2ba], al           # 00474a10
    mov eax, dword ptr [ebp - local_c]           # 00474a16
    mov ecx, dword ptr [eax + field_76]          # 00474a19
    mov dl, byte ptr [ecx + field_2bb]           # 00474a1c
    and dl, byte ptr [0x5d2f1d]                  # 00474a22
    mov eax, dword ptr [ebp - local_c]           # 00474a28
    mov ecx, dword ptr [eax + field_76]          # 00474a2b
    mov byte ptr [ecx + field_2bb], dl           # 00474a2e
    {load} xor edx, edx                          # 00474a34
    mov dl, byte ptr [0x5d2f23]                  # 00474a36
    cmp edx, 0x5                                 # 00474a3c
    je.d8 L_00474a5b                             # 00474a3f
    # block 0x00474a41: entered by fall-through of je at 0x00474a3f, 7 instruction(s), falls into the block at 0x00474a5b
    mov eax, dword ptr [ebp - local_c]           # 00474a41
    mov ecx, dword ptr [eax + field_76]          # 00474a44
    mov dl, byte ptr [ecx + field_2b9]           # 00474a47
    shl dl                                       # 00474a4d
    mov eax, dword ptr [ebp - local_c]           # 00474a4f
    mov ecx, dword ptr [eax + field_76]          # 00474a52
    mov byte ptr [ecx + field_2b9], dl           # 00474a55
L_00474a5b:
    # block 0x00474a5b: entered by je at 0x00474a3f, 4 instruction(s), ends with je to 0x00474a82 (forward)
    {load} xor edx, edx                          # 00474a5b
    mov dl, byte ptr [0x5d2f22]                  # 00474a5d
    cmp edx, 0x5                                 # 00474a63
    je.d8 L_00474a82                             # 00474a66
    # block 0x00474a68: entered by fall-through of je at 0x00474a66, 7 instruction(s), falls into the block at 0x00474a82
    mov eax, dword ptr [ebp - local_c]           # 00474a68
    mov ecx, dword ptr [eax + field_76]          # 00474a6b
    mov dl, byte ptr [ecx + field_2ba]           # 00474a6e
    shl dl                                       # 00474a74
    mov eax, dword ptr [ebp - local_c]           # 00474a76
    mov ecx, dword ptr [eax + field_76]          # 00474a79
    mov byte ptr [ecx + field_2ba], dl           # 00474a7c
L_00474a82:
    # block 0x00474a82: entered by je at 0x00474a66, 4 instruction(s), ends with je to 0x00474aa9 (forward)
    {load} xor edx, edx                          # 00474a82
    mov dl, byte ptr [0x5d2f21]                  # 00474a84
    cmp edx, 0x5                                 # 00474a8a
    je.d8 L_00474aa9                             # 00474a8d
    # block 0x00474a8f: entered by fall-through of je at 0x00474a8d, 7 instruction(s), falls into the block at 0x00474aa9
    mov eax, dword ptr [ebp - local_c]           # 00474a8f
    mov ecx, dword ptr [eax + field_76]          # 00474a92
    mov dl, byte ptr [ecx + field_2bb]           # 00474a95
    shl dl                                       # 00474a9b
    mov eax, dword ptr [ebp - local_c]           # 00474a9d
    mov ecx, dword ptr [eax + field_76]          # 00474aa0
    mov byte ptr [ecx + field_2bb], dl           # 00474aa3
L_00474aa9:
    # block 0x00474aa9: entered by je at 0x00474a8d, 35 instruction(s), ends with je to 0x00474b43 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474aa9
    mov eax, dword ptr [edx + field_76]          # 00474aac
    {load} xor ecx, ecx                          # 00474aaf
    mov cl, byte ptr [eax + field_2b9]           # 00474ab1
    {load} mov edx, ecx                          # 00474ab7
    {load} xor ecx, ecx                          # 00474ab9
    mov cl, byte ptr [0x5d2f1b]                  # 00474abb
    shl edx, cl                                  # 00474ac1
    mov eax, dword ptr [ebp - local_c]           # 00474ac3
    mov ecx, dword ptr [eax + field_76]          # 00474ac6
    {load} xor eax, eax                          # 00474ac9
    mov al, byte ptr [ecx + field_2ba]           # 00474acb
    {load} xor ecx, ecx                          # 00474ad1
    mov cl, byte ptr [0x5d2f1a]                  # 00474ad3
    shl eax, cl                                  # 00474ad9
    {load} or edx, eax                           # 00474adb
    mov ecx, dword ptr [ebp - local_c]           # 00474add
    mov eax, dword ptr [ecx + field_76]          # 00474ae0
    {load} xor ecx, ecx                          # 00474ae3
    mov cl, byte ptr [eax + field_2bb]           # 00474ae5
    {load} mov eax, ecx                          # 00474aeb
    {load} xor ecx, ecx                          # 00474aed
    mov cl, byte ptr [0x5d2f19]                  # 00474aef
    shl eax, cl                                  # 00474af5
    {load} or edx, eax                           # 00474af7
    mov ecx, dword ptr [ebp - local_c]           # 00474af9
    mov word ptr [ecx + field_35f], dx           # 00474afc
    mov edi, 0x54c67c                            # 00474b03
    mov edx, dword ptr [ebp - local_c]           # 00474b08
    mov esi, dword ptr [edx + field_76]          # 00474b0b
    add esi, 0x2bc                               # 00474b0e
    mov ecx, 0x9                                 # 00474b14
    {load} xor eax, eax                          # 00474b19
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00474b1b
    je.d8 L_00474b43                             # 00474b1d
    # block 0x00474b1f: entered by fall-through of je at 0x00474b1d, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00474b43
    mov ecx, dword ptr [ebp - local_c]           # 00474b1f
    mov edx, dword ptr [ecx + field_76]          # 00474b22
    add edx, 0x2bc                               # 00474b25
    push edx                                     # 00474b2b
    mov ecx, 0x5c3a67                            # 00474b2c
    call FUN_004fb77a                            # 00474b31
    mov eax, dword ptr [ebp - local_c]           # 00474b36
    mov dword ptr [eax + field_34d], 0x1         # 00474b39
L_00474b43:
    # block 0x00474b43: entered by je at 0x00474b1d, 8 instruction(s), ends with je to 0x00474b83 (forward)
    mov edi, 0x54c688                            # 00474b43
    mov ecx, dword ptr [ebp - local_c]           # 00474b48
    mov esi, dword ptr [ecx + field_76]          # 00474b4b
    add esi, 0x372                               # 00474b4e
    mov ecx, 0x9                                 # 00474b54
    {load} xor edx, edx                          # 00474b59
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00474b5b
    je.d8 L_00474b83                             # 00474b5d
    # block 0x00474b5f: entered by fall-through of je at 0x00474b5d, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00474b83
    mov eax, dword ptr [ebp - local_c]           # 00474b5f
    mov ecx, dword ptr [eax + field_76]          # 00474b62
    add ecx, 0x372                               # 00474b65
    push ecx                                     # 00474b6b
    mov ecx, 0x5c3a67                            # 00474b6c
    call FUN_004fb77a                            # 00474b71
    mov edx, dword ptr [ebp - local_c]           # 00474b76
    mov dword ptr [edx + field_351], 0x1         # 00474b79
L_00474b83:
    # block 0x00474b83: entered by je at 0x00474b5d, 8 instruction(s), ends with je to 0x00474bc3 (forward)
    mov edi, 0x54c694                            # 00474b83
    mov eax, dword ptr [ebp - local_c]           # 00474b88
    mov esi, dword ptr [eax + field_76]          # 00474b8b
    add esi, 0x428                               # 00474b8e
    mov ecx, 0x9                                 # 00474b94
    {load} xor edx, edx                          # 00474b99
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00474b9b
    je.d8 L_00474bc3                             # 00474b9d
    # block 0x00474b9f: entered by fall-through of je at 0x00474b9d, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00474bc3
    mov eax, dword ptr [ebp - local_c]           # 00474b9f
    mov ecx, dword ptr [eax + field_76]          # 00474ba2
    add ecx, 0x428                               # 00474ba5
    push ecx                                     # 00474bab
    mov ecx, 0x5c3a67                            # 00474bac
    call FUN_004fb77a                            # 00474bb1
    mov edx, dword ptr [ebp - local_c]           # 00474bb6
    mov dword ptr [edx + field_355], 0x1         # 00474bb9
L_00474bc3:
    # block 0x00474bc3: entered by je at 0x00474b9d, 8 instruction(s), ends with je to 0x00474c03 (forward)
    mov edi, 0x54c6a0                            # 00474bc3
    mov eax, dword ptr [ebp - local_c]           # 00474bc8
    mov esi, dword ptr [eax + field_76]          # 00474bcb
    add esi, 0x459                               # 00474bce
    mov ecx, 0x9                                 # 00474bd4
    {load} xor edx, edx                          # 00474bd9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00474bdb
    je.d8 L_00474c03                             # 00474bdd
    # block 0x00474bdf: entered by fall-through of je at 0x00474bdd, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00474c03
    mov eax, dword ptr [ebp - local_c]           # 00474bdf
    mov ecx, dword ptr [eax + field_76]          # 00474be2
    add ecx, 0x459                               # 00474be5
    push ecx                                     # 00474beb
    mov ecx, 0x5c3a67                            # 00474bec
    call FUN_004fb77a                            # 00474bf1
    mov edx, dword ptr [ebp - local_c]           # 00474bf6
    mov dword ptr [edx + field_359], 0x1         # 00474bf9
L_00474c03:
    # block 0x00474c03: entered by je at 0x00474bdd, 14 instruction(s), calls FUN_004e1db3, ends with forward jump to 0x00475112
    mov eax, dword ptr [ebp - local_c]           # 00474c03
    mov ecx, dword ptr [eax + field_76]          # 00474c06
    add ecx, 0x1c7                               # 00474c09
    push ecx                                     # 00474c0f
    mov ecx, dword ptr [ebp - local_c]           # 00474c10
    add ecx, 0x1a6                               # 00474c13
    call FUN_004e1db3                            # 00474c19
    mov edx, dword ptr [ebp - local_c]           # 00474c1e
    mov dword ptr [edx + field_10], 0x0          # 00474c21
    mov eax, dword ptr [ebp - local_c]           # 00474c28
    movsx ecx, word ptr [eax + field_c]          # 00474c2b
    imul ecx, ecx, 0x8d                          # 00474c2f
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00474c35
    jmp.d32 L_00475112                           # 00474c3f
L_00474c44:
    # block 0x00474c44: entered by je at 0x004742ca, 5 instruction(s), ends with ja to 0x00474e63 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474c44
    mov eax, dword ptr [edx + field_10]          # 00474c47
    mov dword ptr [ebp - local_14], eax          # 00474c4a
    cmp dword ptr [ebp - local_14], 0x3          # 00474c4d
    ja.d32 L_00474e63                            # 00474c51
    # block 0x00474c57: entered by fall-through of ja at 0x00474c51, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x47511a]
    mov ecx, dword ptr [ebp - local_14]          # 00474c57
    jmp dword ptr [4*ecx + SWTAB_0047511a_VA]    # 00474c5a
L_00474c61:
    # block 0x00474c61: entered by switch case, 8 instruction(s), calls FUN_004e29ec, FUN_004e2913, ends with je to 0x00474ceb (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00474c61
    add ecx, 0x1a6                               # 00474c64
    call FUN_004e29ec                            # 00474c6a
    mov ecx, dword ptr [ebp - local_c]           # 00474c6f
    add ecx, 0x1a6                               # 00474c72
    call FUN_004e2913                            # 00474c78
    test eax, eax                                # 00474c7d
    je.d8 L_00474ceb                             # 00474c7f
    # block 0x00474c81: entered by fall-through of je at 0x00474c7f, 2 instruction(s), ends with forward jump to 0x00474c93
    mov dword ptr [ebp - local_4], 0x0           # 00474c81
    jmp.d8 L_00474c93                            # 00474c88
L_00474c8a:
    # block 0x00474c8a: entered by jmp at 0x00474ce9, 3 instruction(s), falls into the block at 0x00474c93
    mov edx, dword ptr [ebp - local_4]           # 00474c8a
    add edx, 0x1                                 # 00474c8d
    mov dword ptr [ebp - local_4], edx           # 00474c90
L_00474c93:
    # block 0x00474c93: entered by jmp at 0x00474c88, 2 instruction(s), ends with jge to 0x00474ceb (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00474c93
    jge.d8 L_00474ceb                            # 00474c97
    # block 0x00474c99: entered by fall-through of jge at 0x00474c97, 3 instruction(s), ends with jne to 0x00474ce9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00474c99
    cmp dword ptr [4*eax + 0x5a4b4e], 0x0        # 00474c9c
    jne.d8 L_00474ce9                            # 00474ca4
    # block 0x00474ca6: entered by fall-through of jne at 0x00474ca4, 20 instruction(s), falls into the block at 0x00474ce9
    mov ecx, dword ptr [ebp - local_4]           # 00474ca6
    imul ecx, ecx, 0x38                          # 00474ca9
    mov edx, dword ptr [ebp - local_c]           # 00474cac
    lea eax, [edx + ecx + field_86]              # 00474caf
    mov ecx, dword ptr [ebp - local_4]           # 00474cb6
    shl ecx, 0x4                                 # 00474cb9
    add ecx, 0x5a4b5e                            # 00474cbc
    mov edx, dword ptr [eax]                     # 00474cc2
    mov dword ptr [ecx], edx                     # 00474cc4
    mov edx, dword ptr [eax + field_4]           # 00474cc6
    mov dword ptr [ecx + field_4], edx           # 00474cc9
    mov edx, dword ptr [eax + field_8]           # 00474ccc
    mov dword ptr [ecx + field_8], edx           # 00474ccf
    mov eax, dword ptr [eax + field_c]           # 00474cd2
    mov dword ptr [ecx + field_c], eax           # 00474cd5
    {load} xor ecx, ecx                          # 00474cd8
    mov edx, dword ptr [ebp - local_4]           # 00474cda
    lea eax, [8*edx + 0x5a4b9e]                  # 00474cdd
    mov dword ptr [eax], ecx                     # 00474ce4
    mov dword ptr [eax + field_4], ecx           # 00474ce6
L_00474ce9:
    # block 0x00474ce9: entered by jne at 0x00474ca4, 1 instruction(s), ends with backward jump to 0x00474c8a
    jmp.d8 L_00474c8a                            # 00474ce9
L_00474ceb:
    # block 0x00474ceb: entered by je at 0x00474c7f; jge at 0x00474c97, 7 instruction(s), calls FUN_004740e5, ends with je to 0x00474d12 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00474ceb
    call FUN_004740e5                            # 00474cee
    mov ecx, dword ptr [ebp - local_c]           # 00474cf3
    mov dword ptr [ecx + field_82], eax          # 00474cf6
    mov edx, dword ptr [ebp - local_c]           # 00474cfc
    cmp dword ptr [edx + field_82], 0x0          # 00474cff
    je.d8 L_00474d12                             # 00474d06
    # block 0x00474d08: entered by fall-through of je at 0x00474d06, 2 instruction(s), falls into the block at 0x00474d12
    mov eax, dword ptr [ebp - local_c]           # 00474d08
    mov dword ptr [eax + field_10], 0x1          # 00474d0b
L_00474d12:
    # block 0x00474d12: entered by je at 0x00474d06, 3 instruction(s), calls FUN_004741eb, ends with forward jump to 0x00474e63
    mov ecx, dword ptr [ebp - local_c]           # 00474d12
    call FUN_004741eb                            # 00474d15
    jmp.d32 L_00474e63                           # 00474d1a
L_00474d1f:
    # block 0x00474d1f: entered by switch case, 3 instruction(s), ends with je to 0x00474d5f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00474d1f
    cmp dword ptr [ecx + field_82], 0x0          # 00474d22
    je.d8 L_00474d5f                             # 00474d29
    # block 0x00474d2b: entered by fall-through of je at 0x00474d29, 5 instruction(s), ends with je to 0x00474d5f (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474d2b
    mov eax, dword ptr [edx + field_76]          # 00474d2e
    movsx ecx, word ptr [eax + field_4a0]        # 00474d31
    cmp ecx, -0x1                                # 00474d38
    je.d8 L_00474d5f                             # 00474d3b
    # block 0x00474d3d: entered by fall-through of je at 0x00474d3b, 8 instruction(s), falls into the block at 0x00474d5f
    mov edx, dword ptr [ebp - local_c]           # 00474d3d
    mov eax, dword ptr [edx + field_76]          # 00474d40
    {load} xor ecx, ecx                          # 00474d43
    mov cl, byte ptr [eax + field_4a2]           # 00474d45
    mov edx, dword ptr [ebp - local_c]           # 00474d4b
    mov eax, dword ptr [edx + field_76]          # 00474d4e
    movsx edx, word ptr [eax + field_4a0]        # 00474d51
    mov dword ptr [4*edx + 0x585801], ecx        # 00474d58
L_00474d5f:
    # block 0x00474d5f: entered by je at 0x00474d29; je at 0x00474d3b, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00474e63
    call dword ptr [0x52a23c]                    # 00474d5f
    mov ecx, dword ptr [ebp - local_c]           # 00474d65
    mov edx, dword ptr [ecx + field_76]          # 00474d68
    movsx ecx, word ptr [edx + field_4a3]        # 00474d6b
    imul ecx, ecx, 0x3e8                         # 00474d72
    {load} add eax, ecx                          # 00474d78
    mov edx, dword ptr [ebp - local_c]           # 00474d7a
    mov dword ptr [edx + field_349], eax         # 00474d7d
    mov eax, dword ptr [ebp - local_c]           # 00474d83
    mov dword ptr [eax + field_10], 0x2          # 00474d86
    jmp.d32 L_00474e63                           # 00474d8d
L_00474d92:
    # block 0x00474d92: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00474e11 (forward)
    call dword ptr [0x52a23c]                    # 00474d92
    mov ecx, dword ptr [ebp - local_c]           # 00474d98
    cmp eax, dword ptr [ecx + field_349]         # 00474d9b
    jb.d8 L_00474e11                             # 00474da1
    # block 0x00474da3: entered by fall-through of jb at 0x00474da1, 8 instruction(s), ends with je to 0x00474dfa (forward)
    mov edi, 0x54c6ac                            # 00474da3
    mov edx, dword ptr [ebp - local_c]           # 00474da8
    mov esi, dword ptr [edx + field_76]          # 00474dab
    add esi, 0x4a5                               # 00474dae
    mov ecx, 0x9                                 # 00474db4
    {load} xor eax, eax                          # 00474db9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00474dbb
    je.d8 L_00474dfa                             # 00474dbd
    # block 0x00474dbf: entered by fall-through of je at 0x00474dbd, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00474e11
    mov ecx, dword ptr [ebp - local_c]           # 00474dbf
    mov edx, dword ptr [ecx + field_76]          # 00474dc2
    add edx, 0x4a5                               # 00474dc5
    push edx                                     # 00474dcb
    mov ecx, 0x5c3a67                            # 00474dcc
    call FUN_004fb77a                            # 00474dd1
    mov eax, dword ptr [ebp - local_c]           # 00474dd6
    mov ecx, dword ptr [eax + field_76]          # 00474dd9
    mov dx, word ptr [ecx + field_4c6]           # 00474ddc
    push edx                                     # 00474de3
    mov ecx, 0x5c3a67                            # 00474de4
    call FUN_004fb2e3                            # 00474de9
    mov eax, dword ptr [ebp - local_c]           # 00474dee
    mov dword ptr [eax + field_10], 0x3          # 00474df1
    jmp.d8 L_00474e11                            # 00474df8
L_00474dfa:
    # block 0x00474dfa: entered by je at 0x00474dbd, 4 instruction(s), falls into the block at 0x00474e11
    mov ecx, dword ptr [ebp - local_c]           # 00474dfa
    movsx edx, word ptr [ecx + field_c]          # 00474dfd
    imul edx, edx, 0x8d                          # 00474e01
    mov dword ptr [edx + 0x5bb632], 0x2          # 00474e07
L_00474e11:
    # block 0x00474e11: entered by jb at 0x00474da1; jmp at 0x00474df8, 1 instruction(s), ends with forward jump to 0x00474e63
    jmp.d8 L_00474e63                            # 00474e11
L_00474e13:
    # block 0x00474e13: entered by switch case, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x00474e63 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00474e13
    mov ecx, dword ptr [eax + field_76]          # 00474e16
    movsx edx, word ptr [ecx + field_4c6]        # 00474e19
    mov dword ptr [ebp - local_8], edx           # 00474e20
    mov eax, dword ptr [ebp - local_8]           # 00474e23
    push eax                                     # 00474e26
    mov ecx, 0x5cf1eb                            # 00474e27
    call FUN_004f6334                            # 00474e2c
    test eax, eax                                # 00474e31
    jne.d8 L_00474e63                            # 00474e33
    # block 0x00474e35: entered by fall-through of jne at 0x00474e33, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x00474e63
    mov ecx, dword ptr [ebp - local_c]           # 00474e35
    mov edx, dword ptr [ecx + field_76]          # 00474e38
    add edx, 0x4a5                               # 00474e3b
    push edx                                     # 00474e41
    mov ecx, 0x5c3a67                            # 00474e42
    call FUN_004fba69                            # 00474e47
    mov eax, dword ptr [ebp - local_c]           # 00474e4c
    movsx ecx, word ptr [eax + field_c]          # 00474e4f
    imul ecx, ecx, 0x8d                          # 00474e53
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00474e59
L_00474e63:
    # block 0x00474e63: entered by ja at 0x00474c51; jmp at 0x00474d1a; jmp at 0x00474d8d; jmp at 0x00474e11; more, 1 instruction(s), ends with forward jump to 0x00475112
    jmp.d32 L_00475112                           # 00474e63
L_00474e68:
    # block 0x00474e68: entered by je at 0x004742d4, 10 instruction(s), ends with je to 0x00474eb3 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00474e68
    mov edx, dword ptr [ebp - local_c]           # 00474e72
    mov dword ptr [edx + field_7a], 0x0          # 00474e75
    mov eax, dword ptr [ebp - local_c]           # 00474e7c
    movsx ecx, word ptr [eax + field_14]         # 00474e7f
    imul ecx, ecx, 0x4a                          # 00474e83
    mov dword ptr [ecx + 0x5d15a5], 0x0          # 00474e86
    mov edx, dword ptr [ebp - local_c]           # 00474e90
    cmp dword ptr [edx + field_34d], 0x0         # 00474e93
    je.d8 L_00474eb3                             # 00474e9a
    # block 0x00474e9c: entered by fall-through of je at 0x00474e9a, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00474eb3
    mov eax, dword ptr [ebp - local_c]           # 00474e9c
    mov ecx, dword ptr [eax + field_76]          # 00474e9f
    add ecx, 0x2bc                               # 00474ea2
    push ecx                                     # 00474ea8
    mov ecx, 0x5c3a67                            # 00474ea9
    call FUN_004fba69                            # 00474eae
L_00474eb3:
    # block 0x00474eb3: entered by je at 0x00474e9a, 3 instruction(s), ends with je to 0x00474ed6 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474eb3
    cmp dword ptr [edx + field_351], 0x0         # 00474eb6
    je.d8 L_00474ed6                             # 00474ebd
    # block 0x00474ebf: entered by fall-through of je at 0x00474ebd, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00474ed6
    mov eax, dword ptr [ebp - local_c]           # 00474ebf
    mov ecx, dword ptr [eax + field_76]          # 00474ec2
    add ecx, 0x372                               # 00474ec5
    push ecx                                     # 00474ecb
    mov ecx, 0x5c3a67                            # 00474ecc
    call FUN_004fba69                            # 00474ed1
L_00474ed6:
    # block 0x00474ed6: entered by je at 0x00474ebd, 3 instruction(s), ends with je to 0x00474ef9 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474ed6
    cmp dword ptr [edx + field_355], 0x0         # 00474ed9
    je.d8 L_00474ef9                             # 00474ee0
    # block 0x00474ee2: entered by fall-through of je at 0x00474ee0, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00474ef9
    mov eax, dword ptr [ebp - local_c]           # 00474ee2
    mov ecx, dword ptr [eax + field_76]          # 00474ee5
    add ecx, 0x428                               # 00474ee8
    push ecx                                     # 00474eee
    mov ecx, 0x5c3a67                            # 00474eef
    call FUN_004fba69                            # 00474ef4
L_00474ef9:
    # block 0x00474ef9: entered by je at 0x00474ee0, 3 instruction(s), ends with je to 0x00474f1c (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474ef9
    cmp dword ptr [edx + field_359], 0x0         # 00474efc
    je.d8 L_00474f1c                             # 00474f03
    # block 0x00474f05: entered by fall-through of je at 0x00474f03, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00474f1c
    mov eax, dword ptr [ebp - local_c]           # 00474f05
    mov ecx, dword ptr [eax + field_76]          # 00474f08
    add ecx, 0x459                               # 00474f0b
    push ecx                                     # 00474f11
    mov ecx, 0x5c3a67                            # 00474f12
    call FUN_004fba69                            # 00474f17
L_00474f1c:
    # block 0x00474f1c: entered by je at 0x00474f03, 3 instruction(s), ends with je to 0x00475032 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00474f1c
    cmp dword ptr [edx + field_7e], 0x0          # 00474f1f
    je.d32 L_00475032                            # 00474f23
    # block 0x00474f29: entered by fall-through of je at 0x00474f23, 5 instruction(s), ends with je to 0x00474ff9 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00474f29
    mov ecx, dword ptr [eax + field_76]          # 00474f2c
    movsx edx, word ptr [ecx + field_4d6]        # 00474f2f
    cmp edx, 0x270f                              # 00474f36
    je.d32 L_00474ff9                            # 00474f3c
    # block 0x00474f42: entered by fall-through of je at 0x00474f3c, 33 instruction(s), ends with jne to 0x00474fe5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00474f42
    mov ecx, dword ptr [eax + field_76]          # 00474f45
    movsx edx, word ptr [ecx + field_4d6]        # 00474f48
    mov dword ptr [0x5bb57b], edx                # 00474f4f
    mov eax, dword ptr [ebp - local_c]           # 00474f55
    mov ecx, dword ptr [eax + field_76]          # 00474f58
    mov dx, word ptr [ecx + field_4d8]           # 00474f5b
    mov word ptr [0x5bb599], dx                  # 00474f62
    mov eax, dword ptr [ebp - local_c]           # 00474f69
    mov ecx, dword ptr [eax + field_76]          # 00474f6c
    mov dx, word ptr [ecx + field_4da]           # 00474f6f
    mov word ptr [0x5bb595], dx                  # 00474f76
    mov eax, dword ptr [ebp - local_c]           # 00474f7d
    mov ecx, dword ptr [eax + field_76]          # 00474f80
    mov dx, word ptr [ecx + field_4dc]           # 00474f83
    mov word ptr [0x5c39ff], dx                  # 00474f8a
    mov eax, dword ptr [ebp - local_c]           # 00474f91
    mov ecx, dword ptr [eax + field_76]          # 00474f94
    mov edx, dword ptr [ecx + field_4de]         # 00474f97
    mov dword ptr [0x5bb59b], edx                # 00474f9d
    mov eax, dword ptr [ebp - local_c]           # 00474fa3
    mov ecx, dword ptr [eax + field_76]          # 00474fa6
    mov edx, dword ptr [ecx + field_4e2]         # 00474fa9
    mov dword ptr [0x5bb59f], edx                # 00474faf
    mov eax, dword ptr [ebp - local_c]           # 00474fb5
    mov ecx, dword ptr [eax + field_76]          # 00474fb8
    mov edx, dword ptr [ecx + field_4e6]         # 00474fbb
    mov dword ptr [0x5bb5a3], edx                # 00474fc1
    mov eax, dword ptr [ebp - local_c]           # 00474fc7
    mov ecx, dword ptr [eax + field_76]          # 00474fca
    movsx edx, word ptr [ecx + field_4ea]        # 00474fcd
    cmp edx, 0x1                                 # 00474fd4
    jne.d8 L_00474fe5                            # 00474fd7
    # block 0x00474fd9: entered by fall-through of jne at 0x00474fd7, 2 instruction(s), ends with forward jump to 0x00474fef
    mov dword ptr [0x5bb1ca], 0x0                # 00474fd9
    jmp.d8 L_00474fef                            # 00474fe3
L_00474fe5:
    # block 0x00474fe5: entered by jne at 0x00474fd7, 1 instruction(s), falls into the block at 0x00474fef
    mov dword ptr [0x5bb1ca], 0x1                # 00474fe5
L_00474fef:
    # block 0x00474fef: entered by jmp at 0x00474fe3, 1 instruction(s), falls into the block at 0x00474ff9
    mov dword ptr [0x583999], 0x4                # 00474fef
L_00474ff9:
    # block 0x00474ff9: entered by je at 0x00474f3c, 5 instruction(s), ends with je to 0x0047502d (forward)
    mov eax, dword ptr [ebp - local_c]           # 00474ff9
    mov ecx, dword ptr [eax + field_76]          # 00474ffc
    movsx edx, word ptr [ecx + field_4ec]        # 00474fff
    cmp edx, -0x1                                # 00475006
    je.d8 L_0047502d                             # 00475009
    # block 0x0047500b: entered by fall-through of je at 0x00475009, 8 instruction(s), falls into the block at 0x0047502d
    mov eax, dword ptr [ebp - local_c]           # 0047500b
    mov ecx, dword ptr [eax + field_76]          # 0047500e
    {load} xor edx, edx                          # 00475011
    mov dl, byte ptr [ecx + field_4ee]           # 00475013
    mov eax, dword ptr [ebp - local_c]           # 00475019
    mov ecx, dword ptr [eax + field_76]          # 0047501c
    movsx eax, word ptr [ecx + field_4ec]        # 0047501f
    mov dword ptr [4*eax + 0x585801], edx        # 00475026
L_0047502d:
    # block 0x0047502d: entered by je at 0x00475009, 1 instruction(s), ends with forward jump to 0x004750fa
    jmp.d32 L_004750fa                           # 0047502d
L_00475032:
    # block 0x00475032: entered by je at 0x00474f23, 5 instruction(s), ends with je to 0x004750fa (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00475032
    mov edx, dword ptr [ecx + field_76]          # 00475035
    movsx eax, word ptr [edx + field_48a]        # 00475038
    cmp eax, 0x270f                              # 0047503f
    je.d32 L_004750fa                            # 00475044
    # block 0x0047504a: entered by fall-through of je at 0x00475044, 33 instruction(s), ends with jne to 0x004750e6 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047504a
    mov edx, dword ptr [ecx + field_76]          # 0047504d
    movsx eax, word ptr [edx + field_48a]        # 00475050
    mov dword ptr [0x5bb57b], eax                # 00475057
    mov ecx, dword ptr [ebp - local_c]           # 0047505c
    mov edx, dword ptr [ecx + field_76]          # 0047505f
    mov ax, word ptr [edx + field_48c]           # 00475062
    mov word ptr [0x5bb599], ax                  # 00475069
    mov ecx, dword ptr [ebp - local_c]           # 0047506f
    mov edx, dword ptr [ecx + field_76]          # 00475072
    mov ax, word ptr [edx + field_48e]           # 00475075
    mov word ptr [0x5bb595], ax                  # 0047507c
    mov ecx, dword ptr [ebp - local_c]           # 00475082
    mov edx, dword ptr [ecx + field_76]          # 00475085
    mov ax, word ptr [edx + field_490]           # 00475088
    mov word ptr [0x5c39ff], ax                  # 0047508f
    mov ecx, dword ptr [ebp - local_c]           # 00475095
    mov edx, dword ptr [ecx + field_76]          # 00475098
    mov eax, dword ptr [edx + field_492]         # 0047509b
    mov dword ptr [0x5bb59b], eax                # 004750a1
    mov ecx, dword ptr [ebp - local_c]           # 004750a6
    mov edx, dword ptr [ecx + field_76]          # 004750a9
    mov eax, dword ptr [edx + field_496]         # 004750ac
    mov dword ptr [0x5bb59f], eax                # 004750b2
    mov ecx, dword ptr [ebp - local_c]           # 004750b7
    mov edx, dword ptr [ecx + field_76]          # 004750ba
    mov eax, dword ptr [edx + field_49a]         # 004750bd
    mov dword ptr [0x5bb5a3], eax                # 004750c3
    mov ecx, dword ptr [ebp - local_c]           # 004750c8
    mov edx, dword ptr [ecx + field_76]          # 004750cb
    movsx eax, word ptr [edx + field_49e]        # 004750ce
    cmp eax, 0x1                                 # 004750d5
    jne.d8 L_004750e6                            # 004750d8
    # block 0x004750da: entered by fall-through of jne at 0x004750d8, 2 instruction(s), ends with forward jump to 0x004750f0
    mov dword ptr [0x5bb1ca], 0x0                # 004750da
    jmp.d8 L_004750f0                            # 004750e4
L_004750e6:
    # block 0x004750e6: entered by jne at 0x004750d8, 1 instruction(s), falls into the block at 0x004750f0
    mov dword ptr [0x5bb1ca], 0x1                # 004750e6
L_004750f0:
    # block 0x004750f0: entered by jmp at 0x004750e4, 1 instruction(s), falls into the block at 0x004750fa
    mov dword ptr [0x583999], 0x4                # 004750f0
L_004750fa:
    # block 0x004750fa: entered by jmp at 0x0047502d; je at 0x00475044, 7 instruction(s), calls FUN_0042ba3a, FUN_004730a6, falls into the block at 0x00475112
    mov ecx, dword ptr [ebp - local_c]           # 004750fa
    mov dx, word ptr [ecx + field_c]             # 004750fd
    push edx                                     # 00475101
    call FUN_0042ba3a                            # 00475102
    add esp, 0x4                                 # 00475107
    mov ecx, dword ptr [ebp - local_c]           # 0047510a
    call FUN_004730a6                            # 0047510d
L_00475112:
    # block 0x00475112: entered by jmp at 0x004742da; jmp at 0x00474c3f; jmp at 0x00474e63, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00475112
    pop esi                                      # 00475113
    {load} mov esp, ebp                          # 00475114
    pop ebp                                      # 00475116
    ret 0x4                                      # 00475117

# --- data items (not part of the function) -------------------------
.org 0x0047511a - 0x401000
SWTAB_0047511a:  # 4 case address(es)
    .long L_00474c61 - .text + 0x401000
    .long L_00474d1f - .text + 0x401000
    .long L_00474d92 - .text + 0x401000
    .long L_00474e13 - .text + 0x401000
.set SWTAB_0047511a_VA, SWTAB_0047511a - .text + 0x401000

