# FUN_004d5316
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5316
# extent:       0x004d5316-0x004d5661 (843 code bytes)
# span:         0x004d5316-0x004d5661 (code 843, tables 0, padding 0)
# sha256:       c805aec53d29a22bc89e2c7dcbbaca79fa2f1ddaa75b9fae146a9c0e011ddd12
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5316
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_1c, field_20, field_30, field_34, field_38, field_40, field_50, field_54 and 11 more; [ecx + n] field_4, field_8, field_c, field_24, field_28, field_2c, field_44, field_4c, field_58, field_74, field_7c, field_84 and 3 more; [edx + n] field_4, field_c, field_14, field_18, field_3c, field_48, field_5c, field_64, field_78, field_8c, field_98, field_a8 and 2 more
# callees:      calls FUN_004d52b9, FUN_004d5661
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 231 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0

# --- external targets -----------------------------------------------
.set FUN_004d52b9, .text + (0x004d52b9 - 0x401000)
.set FUN_004d5661, .text + (0x004d5661 - 0x401000)

.org 0x004d5316 - 0x401000
.globl FUN_004d5316
FUN_004d5316:
    # block 0x004d5316: entry, 6 instruction(s), ends with je to 0x004d5329 (forward)
    push ebp                                     # 004d5316
    {load} mov ebp, esp                          # 004d5317
    push ecx                                     # 004d5319
    mov dword ptr [ebp - local_4], ecx           # 004d531a
    cmp dword ptr [ebp + arg_8], 0x0             # 004d531d
    je.d8 L_004d5329                             # 004d5321
    # block 0x004d5323: entered by fall-through of je at 0x004d5321, 2 instruction(s), ends with jne to 0x004d5330 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004d5323
    jne.d8 L_004d5330                            # 004d5327
L_004d5329:
    # block 0x004d5329: entered by je at 0x004d5321; fall-through of jne at 0x004d5327, 2 instruction(s), ends with forward jump to 0x004d565b
    {load} xor eax, eax                          # 004d5329
    jmp.d32 L_004d565b                           # 004d532b
L_004d5330:
    # block 0x004d5330: entered by jne at 0x004d5327, 5 instruction(s), ends with jl to 0x004d5366 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5330
    mov ecx, dword ptr [ebp + arg_c]             # 004d5333
    mov edx, dword ptr [eax + field_8]           # 004d5336
    cmp edx, dword ptr [ecx]                     # 004d5339
    jl.d8 L_004d5366                             # 004d533b
    # block 0x004d533d: entered by fall-through of jl at 0x004d533b, 5 instruction(s), ends with jg to 0x004d5366 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d533d
    mov ecx, dword ptr [ebp + arg_c]             # 004d5340
    mov edx, dword ptr [eax]                     # 004d5343
    cmp edx, dword ptr [ecx + field_8]           # 004d5345
    jg.d8 L_004d5366                             # 004d5348
    # block 0x004d534a: entered by fall-through of jg at 0x004d5348, 5 instruction(s), ends with jl to 0x004d5366 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d534a
    mov ecx, dword ptr [ebp + arg_c]             # 004d534d
    mov edx, dword ptr [eax + field_c]           # 004d5350
    cmp edx, dword ptr [ecx + field_4]           # 004d5353
    jl.d8 L_004d5366                             # 004d5356
    # block 0x004d5358: entered by fall-through of jl at 0x004d5356, 5 instruction(s), ends with jle to 0x004d536d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5358
    mov ecx, dword ptr [ebp + arg_c]             # 004d535b
    mov edx, dword ptr [eax + field_4]           # 004d535e
    cmp edx, dword ptr [ecx + field_c]           # 004d5361
    jle.d8 L_004d536d                            # 004d5364
L_004d5366:
    # block 0x004d5366: entered by jl at 0x004d533b; jg at 0x004d5348; jl at 0x004d5356; fall-through of jle at 0x004d5364, 2 instruction(s), ends with forward jump to 0x004d565b
    {load} xor eax, eax                          # 004d5366
    jmp.d32 L_004d565b                           # 004d5368
L_004d536d:
    # block 0x004d536d: entered by jle at 0x004d5364, 138 instruction(s), calls FUN_004d52b9, FUN_004d5661, ends with jne to 0x004d55c4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d536d
    call FUN_004d52b9                            # 004d5370
    mov eax, dword ptr [ebp - local_4]           # 004d5375
    mov dword ptr [eax + field_34], 0x0          # 004d5378
    mov ecx, dword ptr [ebp - local_4]           # 004d537f
    mov dword ptr [ecx + field_24], 0x0          # 004d5382
    mov edx, dword ptr [ebp - local_4]           # 004d5389
    mov dword ptr [edx + field_14], 0x0          # 004d538c
    mov eax, dword ptr [ebp - local_4]           # 004d5393
    mov dword ptr [eax + field_4], 0x0           # 004d5396
    mov ecx, dword ptr [ebp - local_4]           # 004d539d
    mov dword ptr [ecx + field_74], 0x1          # 004d53a0
    mov edx, dword ptr [ebp - local_4]           # 004d53a7
    mov dword ptr [edx + field_64], 0x1          # 004d53aa
    mov eax, dword ptr [ebp - local_4]           # 004d53b1
    mov dword ptr [eax + field_54], 0x1          # 004d53b4
    mov ecx, dword ptr [ebp - local_4]           # 004d53bb
    mov dword ptr [ecx + field_44], 0x1          # 004d53be
    mov edx, dword ptr [ebp - local_4]           # 004d53c5
    mov dword ptr [edx + field_18], 0x0          # 004d53c8
    mov eax, dword ptr [ebp - local_4]           # 004d53cf
    mov dword ptr [eax + field_8], 0x0           # 004d53d2
    mov ecx, dword ptr [ebp - local_4]           # 004d53d9
    mov dword ptr [ecx + field_58], 0x0          # 004d53dc
    mov edx, dword ptr [ebp - local_4]           # 004d53e3
    mov dword ptr [edx + field_48], 0x0          # 004d53e6
    mov eax, dword ptr [ebp - local_4]           # 004d53ed
    mov dword ptr [eax + field_38], 0x1          # 004d53f0
    mov ecx, dword ptr [ebp - local_4]           # 004d53f7
    mov dword ptr [ecx + field_28], 0x1          # 004d53fa
    mov edx, dword ptr [ebp - local_4]           # 004d5401
    mov dword ptr [edx + field_78], 0x1          # 004d5404
    mov eax, dword ptr [ebp - local_4]           # 004d540b
    mov dword ptr [eax + field_68], 0x1          # 004d540e
    mov ecx, dword ptr [ebp - local_4]           # 004d5415
    mov dword ptr [ecx + field_2c], 0x0          # 004d5418
    mov edx, dword ptr [ebp - local_4]           # 004d541f
    mov dword ptr [edx + field_c], 0x0           # 004d5422
    mov eax, dword ptr [ebp - local_4]           # 004d5429
    mov dword ptr [eax + field_6c], 0x0          # 004d542c
    mov ecx, dword ptr [ebp - local_4]           # 004d5433
    mov dword ptr [ecx + field_4c], 0x0          # 004d5436
    mov edx, dword ptr [ebp - local_4]           # 004d543d
    mov dword ptr [edx + field_3c], 0x1          # 004d5440
    mov eax, dword ptr [ebp - local_4]           # 004d5447
    mov dword ptr [eax + field_1c], 0x1          # 004d544a
    mov ecx, dword ptr [ebp - local_4]           # 004d5451
    mov dword ptr [ecx + field_7c], 0x1          # 004d5454
    mov edx, dword ptr [ebp - local_4]           # 004d545b
    mov dword ptr [edx + field_5c], 0x1          # 004d545e
    mov eax, dword ptr [ebp - local_4]           # 004d5465
    mov ecx, dword ptr [ebp + arg_8]             # 004d5468
    mov edx, dword ptr [ecx]                     # 004d546b
    mov dword ptr [eax + field_10], edx          # 004d546d
    mov eax, dword ptr [ebp - local_4]           # 004d5470
    mov ecx, dword ptr [ebp + arg_8]             # 004d5473
    mov edx, dword ptr [ecx + field_4]           # 004d5476
    mov dword ptr [eax + field_20], edx          # 004d5479
    mov eax, dword ptr [ebp - local_4]           # 004d547c
    mov ecx, dword ptr [ebp + arg_8]             # 004d547f
    mov edx, dword ptr [ecx + field_8]           # 004d5482
    mov dword ptr [eax + field_30], edx          # 004d5485
    mov eax, dword ptr [ebp - local_4]           # 004d5488
    mov ecx, dword ptr [ebp + arg_8]             # 004d548b
    mov edx, dword ptr [ecx + field_c]           # 004d548e
    mov dword ptr [eax + field_40], edx          # 004d5491
    mov eax, dword ptr [ebp - local_4]           # 004d5494
    mov ecx, dword ptr [ebp + arg_c]             # 004d5497
    mov edx, dword ptr [ecx]                     # 004d549a
    mov dword ptr [eax + field_50], edx          # 004d549c
    mov eax, dword ptr [ebp - local_4]           # 004d549f
    mov ecx, dword ptr [ebp + arg_c]             # 004d54a2
    mov edx, dword ptr [ecx + field_4]           # 004d54a5
    mov dword ptr [eax + field_60], edx          # 004d54a8
    mov eax, dword ptr [ebp - local_4]           # 004d54ab
    mov ecx, dword ptr [ebp + arg_c]             # 004d54ae
    mov edx, dword ptr [ecx + field_8]           # 004d54b1
    mov dword ptr [eax + field_70], edx          # 004d54b4
    mov eax, dword ptr [ebp - local_4]           # 004d54b7
    mov ecx, dword ptr [ebp + arg_c]             # 004d54ba
    mov edx, dword ptr [ecx + field_c]           # 004d54bd
    mov dword ptr [eax + field_80], edx          # 004d54c0
    mov eax, dword ptr [ebp - local_4]           # 004d54c6
    add eax, 0x4                                 # 004d54c9
    mov ecx, dword ptr [ebp - local_4]           # 004d54cc
    mov dword ptr [ecx + field_84], eax          # 004d54cf
    mov edx, dword ptr [ebp - local_4]           # 004d54d5
    add edx, 0x24                                # 004d54d8
    mov eax, dword ptr [ebp - local_4]           # 004d54db
    mov dword ptr [eax + field_88], edx          # 004d54de
    mov ecx, dword ptr [ebp - local_4]           # 004d54e4
    add ecx, 0x44                                # 004d54e7
    push ecx                                     # 004d54ea
    push 0x2                                     # 004d54eb
    mov edx, dword ptr [ebp - local_4]           # 004d54ed
    add edx, 0x84                                # 004d54f0
    push edx                                     # 004d54f6
    mov ecx, dword ptr [ebp - local_4]           # 004d54f7
    call FUN_004d5661                            # 004d54fa
    mov eax, dword ptr [ebp - local_4]           # 004d54ff
    add eax, 0x64                                # 004d5502
    push eax                                     # 004d5505
    push 0x3                                     # 004d5506
    mov ecx, dword ptr [ebp - local_4]           # 004d5508
    add ecx, 0x84                                # 004d550b
    push ecx                                     # 004d5511
    mov ecx, dword ptr [ebp - local_4]           # 004d5512
    call FUN_004d5661                            # 004d5515
    mov edx, dword ptr [ebp - local_4]           # 004d551a
    add edx, 0x14                                # 004d551d
    mov eax, dword ptr [ebp - local_4]           # 004d5520
    mov dword ptr [eax + field_94], edx          # 004d5523
    mov ecx, dword ptr [ebp - local_4]           # 004d5529
    add ecx, 0x34                                # 004d552c
    mov edx, dword ptr [ebp - local_4]           # 004d552f
    mov dword ptr [edx + field_98], ecx          # 004d5532
    mov eax, dword ptr [ebp - local_4]           # 004d5538
    add eax, 0x54                                # 004d553b
    push eax                                     # 004d553e
    push 0x2                                     # 004d553f
    mov ecx, dword ptr [ebp - local_4]           # 004d5541
    add ecx, 0x94                                # 004d5544
    push ecx                                     # 004d554a
    mov ecx, dword ptr [ebp - local_4]           # 004d554b
    call FUN_004d5661                            # 004d554e
    mov edx, dword ptr [ebp - local_4]           # 004d5553
    add edx, 0x74                                # 004d5556
    push edx                                     # 004d5559
    push 0x3                                     # 004d555a
    mov eax, dword ptr [ebp - local_4]           # 004d555c
    add eax, 0x94                                # 004d555f
    push eax                                     # 004d5564
    mov ecx, dword ptr [ebp - local_4]           # 004d5565
    call FUN_004d5661                            # 004d5568
    mov ecx, dword ptr [ebp - local_4]           # 004d556d
    mov edx, dword ptr [ecx + field_84]          # 004d5570
    cmp dword ptr [edx + field_4], 0x0           # 004d5576
    jne.d8 L_004d55c4                            # 004d557a
    # block 0x004d557c: entered by fall-through of jne at 0x004d557a, 4 instruction(s), ends with jne to 0x004d55c4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d557c
    mov ecx, dword ptr [eax + field_88]          # 004d557f
    cmp dword ptr [ecx + field_4], 0x0           # 004d5585
    jne.d8 L_004d55c4                            # 004d5589
    # block 0x004d558b: entered by fall-through of jne at 0x004d5589, 4 instruction(s), ends with jne to 0x004d55c4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d558b
    mov eax, dword ptr [edx + field_8c]          # 004d558e
    cmp dword ptr [eax + field_4], 0x1           # 004d5594
    jne.d8 L_004d55c4                            # 004d5598
    # block 0x004d559a: entered by fall-through of jne at 0x004d5598, 10 instruction(s), falls into the block at 0x004d55c4
    mov ecx, dword ptr [ebp - local_4]           # 004d559a
    mov edx, dword ptr [ecx + field_88]          # 004d559d
    mov eax, dword ptr [ebp - local_4]           # 004d55a3
    mov ecx, dword ptr [edx + field_c]           # 004d55a6
    mov dword ptr [eax + field_a4], ecx          # 004d55a9
    mov edx, dword ptr [ebp - local_4]           # 004d55af
    mov eax, dword ptr [edx + field_8c]          # 004d55b2
    mov ecx, dword ptr [ebp - local_4]           # 004d55b8
    mov edx, dword ptr [eax + field_c]           # 004d55bb
    mov dword ptr [ecx + field_ac], edx          # 004d55be
L_004d55c4:
    # block 0x004d55c4: entered by jne at 0x004d557a; jne at 0x004d5589; jne at 0x004d5598, 4 instruction(s), ends with jne to 0x004d561b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d55c4
    mov ecx, dword ptr [eax + field_94]          # 004d55c7
    cmp dword ptr [ecx + field_4], 0x0           # 004d55cd
    jne.d8 L_004d561b                            # 004d55d1
    # block 0x004d55d3: entered by fall-through of jne at 0x004d55d1, 4 instruction(s), ends with jne to 0x004d561b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d55d3
    mov eax, dword ptr [edx + field_98]          # 004d55d6
    cmp dword ptr [eax + field_4], 0x0           # 004d55dc
    jne.d8 L_004d561b                            # 004d55e0
    # block 0x004d55e2: entered by fall-through of jne at 0x004d55e0, 4 instruction(s), ends with jne to 0x004d561b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d55e2
    mov edx, dword ptr [ecx + field_9c]          # 004d55e5
    cmp dword ptr [edx + field_4], 0x1           # 004d55eb
    jne.d8 L_004d561b                            # 004d55ef
    # block 0x004d55f1: entered by fall-through of jne at 0x004d55ef, 10 instruction(s), falls into the block at 0x004d561b
    mov eax, dword ptr [ebp - local_4]           # 004d55f1
    mov ecx, dword ptr [eax + field_98]          # 004d55f4
    mov edx, dword ptr [ebp - local_4]           # 004d55fa
    mov eax, dword ptr [ecx + field_c]           # 004d55fd
    mov dword ptr [edx + field_a8], eax          # 004d5600
    mov ecx, dword ptr [ebp - local_4]           # 004d5606
    mov edx, dword ptr [ecx + field_9c]          # 004d5609
    mov eax, dword ptr [ebp - local_4]           # 004d560f
    mov ecx, dword ptr [edx + field_c]           # 004d5612
    mov dword ptr [eax + field_b0], ecx          # 004d5615
L_004d561b:
    # block 0x004d561b: entered by jne at 0x004d55d1; jne at 0x004d55e0; jne at 0x004d55ef, 7 instruction(s), ends with jl to 0x004d564f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d561b
    mov eax, dword ptr [ebp - local_4]           # 004d561e
    mov ecx, dword ptr [edx + field_b0]          # 004d5621
    sub ecx, dword ptr [eax + field_a8]          # 004d5627
    add ecx, 0x1                                 # 004d562d
    cmp ecx, 0x1                                 # 004d5630
    jl.d8 L_004d564f                             # 004d5633
    # block 0x004d5635: entered by fall-through of jl at 0x004d5633, 7 instruction(s), ends with jge to 0x004d5653 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d5635
    mov eax, dword ptr [ebp - local_4]           # 004d5638
    mov ecx, dword ptr [edx + field_ac]          # 004d563b
    sub ecx, dword ptr [eax + field_a4]          # 004d5641
    add ecx, 0x1                                 # 004d5647
    cmp ecx, 0x1                                 # 004d564a
    jge.d8 L_004d5653                            # 004d564d
L_004d564f:
    # block 0x004d564f: entered by jl at 0x004d5633; fall-through of jge at 0x004d564d, 2 instruction(s), ends with forward jump to 0x004d565b
    {load} xor eax, eax                          # 004d564f
    jmp.d8 L_004d565b                            # 004d5651
L_004d5653:
    # block 0x004d5653: entered by jge at 0x004d564d, 2 instruction(s), falls into the block at 0x004d565b
    mov eax, dword ptr [ebp - local_4]           # 004d5653
    add eax, 0xa4                                # 004d5656
L_004d565b:
    # block 0x004d565b: entered by jmp at 0x004d532b; jmp at 0x004d5368; jmp at 0x004d5651, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004d565b
    pop ebp                                      # 004d565d
    ret 0x8                                      # 004d565e

