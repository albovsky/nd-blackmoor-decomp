# FUN_0042d35a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042d35a
# extent:       0x0042d35a-0x0042db5b (2049 code bytes)
# span:         0x0042d35a-0x0042db5b (code 2049, tables 0, padding 0)
# sha256:       a9235d9d806e59a1b5362ff701ab7ab201440f915673c9017cad94dd9a48921e
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042d35a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       19 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 7 more
# fields:       [eax + n] field_44, field_54, field_58, field_5e, field_68, field_6f, field_71; [ecx + n] field_42, field_4a, field_4c, field_5c, field_64, field_6c, field_6d, field_6f; [edx + n] field_46, field_48, field_5a, field_60, field_6d
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_0051dc6c, FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, FUN_0044c2e0, FUN_004c2c3a, FUN_0051dc43, FUN_004497a0, FUN_0042639d, FUN_00449bff and 7 more; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 470 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
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
.equ local_50, 0x50  # offset -0x50
.equ arg_8, 0x8  # offset +0x8
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_46, 0x46  # offset +0x46
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4c, 0x4c  # offset +0x4c
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5c, 0x5c  # offset +0x5c
.equ field_5e, 0x5e  # offset +0x5e
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_6d, 0x6d  # offset +0x6d
.equ field_6f, 0x6f  # offset +0x6f
.equ field_71, 0x71  # offset +0x71

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0042db5b, .text + (0x0042db5b - 0x401000)
.set FUN_0042dbe1, .text + (0x0042dbe1 - 0x401000)
.set FUN_0042e34e, .text + (0x0042e34e - 0x401000)
.set FUN_0042e560, .text + (0x0042e560 - 0x401000)
.set FUN_0042e7b8, .text + (0x0042e7b8 - 0x401000)
.set FUN_004497a0, .text + (0x004497a0 - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_0044c2e0, .text + (0x0044c2e0 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0044c4c1, .text + (0x0044c4c1 - 0x401000)
.set FUN_004c2c3a, .text + (0x004c2c3a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042d35a - 0x401000
.globl FUN_0042d35a
FUN_0042d35a:
    # block 0x0042d35a: entry, 18 instruction(s), ends with jle to 0x0042d3b6 (forward)
    push ebp                                     # 0042d35a
    {load} mov ebp, esp                          # 0042d35b
    push -0x1                                    # 0042d35d
    push 0x527e10                                # 0042d35f
    mov eax, dword ptr fs:[0x0]                  # 0042d364
    push eax                                     # 0042d36a
    mov dword ptr fs:[0x0], esp                  # 0042d36b
    sub esp, 0x44                                # 0042d372
    push esi                                     # 0042d375
    push edi                                     # 0042d376
    movsx eax, word ptr [ebp + arg_8]            # 0042d377
    imul eax, eax, 0x8d                          # 0042d37b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042d381
    mov dword ptr [0x5b5124], ecx                # 0042d387
    mov edx, dword ptr [0x5b5124]                # 0042d38d
    movsx eax, word ptr [edx + field_6d]         # 0042d393
    test eax, eax                                # 0042d397
    jle.d8 L_0042d3b6                            # 0042d399
    # block 0x0042d39b: entered by fall-through of jle at 0x0042d399, 6 instruction(s), ends with forward jump to 0x0042d3c0
    movsx ecx, word ptr [ebp + arg_8]            # 0042d39b
    imul ecx, ecx, 0x8d                          # 0042d39f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042d3a5
    add edx, 0x71                                # 0042d3ab
    mov dword ptr [0x5b511c], edx                # 0042d3ae
    jmp.d8 L_0042d3c0                            # 0042d3b4
L_0042d3b6:
    # block 0x0042d3b6: entered by jle at 0x0042d399, 1 instruction(s), falls into the block at 0x0042d3c0
    mov dword ptr [0x5b511c], 0x0                # 0042d3b6
L_0042d3c0:
    # block 0x0042d3c0: entered by jmp at 0x0042d3b4, 4 instruction(s), ends with jle to 0x0042d3f5 (forward)
    mov eax, dword ptr [0x5b5124]                # 0042d3c0
    movsx ecx, word ptr [eax + field_6f]         # 0042d3c5
    test ecx, ecx                                # 0042d3c9
    jle.d8 L_0042d3f5                            # 0042d3cb
    # block 0x0042d3cd: entered by fall-through of jle at 0x0042d3cb, 9 instruction(s), ends with forward jump to 0x0042d444
    movsx edx, word ptr [ebp + arg_8]            # 0042d3cd
    imul edx, edx, 0x8d                          # 0042d3d1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042d3d7
    mov ecx, dword ptr [0x5b5124]                # 0042d3dd
    movsx edx, word ptr [ecx + field_6d]         # 0042d3e3
    imul edx, edx, 0x6                           # 0042d3e7
    lea eax, [eax + edx + field_71]              # 0042d3ea
    mov dword ptr [0x5b5120], eax                # 0042d3ee
    jmp.d8 L_0042d444                            # 0042d3f3
L_0042d3f5:
    # block 0x0042d3f5: entered by jle at 0x0042d3cb, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042db4b
    mov dword ptr [0x5b5120], 0x0                # 0042d3f5
    movsx ecx, word ptr [ebp + arg_8]            # 0042d3ff
    imul ecx, ecx, 0x8d                          # 0042d403
    add ecx, 0x5bb5b3                            # 0042d409
    push ecx                                     # 0042d40f
    movsx edx, word ptr [ebp + arg_8]            # 0042d410
    push edx                                     # 0042d414
    push 0x5458c4                                # 0042d415
    push 0x63888b                                # 0042d41a
    call FUN_0050ca3e                            # 0042d41f
    add esp, 0x10                                # 0042d424
    push 0x0                                     # 0042d427
    push 0x0                                     # 0042d429
    push 0x63888b                                # 0042d42b
    call FUN_0052139c                            # 0042d430
    mov ecx, 0x5cf659                            # 0042d435
    call FUN_004c97b4                            # 0042d43a
    jmp.d32 L_0042db4b                           # 0042d43f
L_0042d444:
    # block 0x0042d444: entered by jmp at 0x0042d3f3, 6 instruction(s), ends with je to 0x0042d476 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042d444
    imul eax, eax, 0x8d                          # 0042d448
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042d44e
    mov dword ptr [ebp - local_40], ecx          # 0042d454
    cmp dword ptr [ebp - local_40], 0x0          # 0042d457
    je.d8 L_0042d476                             # 0042d45b
    # block 0x0042d45d: entered by fall-through of je at 0x0042d45b, 2 instruction(s), ends with je to 0x0042d85d (forward)
    cmp dword ptr [ebp - local_40], 0x1          # 0042d45d
    je.d32 L_0042d85d                            # 0042d461
    # block 0x0042d467: entered by fall-through of je at 0x0042d461, 2 instruction(s), ends with je to 0x0042da7a (forward)
    cmp dword ptr [ebp - local_40], 0x2          # 0042d467
    je.d32 L_0042da7a                            # 0042d46b
    # block 0x0042d471: entered by fall-through of je at 0x0042d46b, 1 instruction(s), ends with forward jump to 0x0042db4b
    jmp.d32 L_0042db4b                           # 0042d471
L_0042d476:
    # block 0x0042d476: entered by je at 0x0042d45b, 2 instruction(s), ends with je to 0x0042d4c4 (forward)
    cmp dword ptr [0x5c39f5], 0x0                # 0042d476
    je.d8 L_0042d4c4                             # 0042d47d
    # block 0x0042d47f: entered by fall-through of je at 0x0042d47d, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042db4b
    movsx edx, word ptr [ebp + arg_8]            # 0042d47f
    imul edx, edx, 0x8d                          # 0042d483
    add edx, 0x5bb5b3                            # 0042d489
    push edx                                     # 0042d48f
    movsx eax, word ptr [ebp + arg_8]            # 0042d490
    push eax                                     # 0042d494
    push 0x545914                                # 0042d495
    push 0x63888b                                # 0042d49a
    call FUN_0050ca3e                            # 0042d49f
    add esp, 0x10                                # 0042d4a4
    push 0x0                                     # 0042d4a7
    push 0x0                                     # 0042d4a9
    push 0x63888b                                # 0042d4ab
    call FUN_0052139c                            # 0042d4b0
    mov ecx, 0x5cf659                            # 0042d4b5
    call FUN_004c97b4                            # 0042d4ba
    jmp.d32 L_0042db4b                           # 0042d4bf
L_0042d4c4:
    # block 0x0042d4c4: entered by je at 0x0042d47d, 17 instruction(s), ends with je to 0x0042d5a3 (forward)
    mov word ptr [0x5b503f], 0x0                 # 0042d4c4
    mov cx, word ptr [ebp + arg_8]               # 0042d4cd
    mov word ptr [0x5b5100], cx                  # 0042d4d1
    mov edx, dword ptr [0x5b5124]                # 0042d4d8
    mov ax, word ptr [edx + field_46]            # 0042d4de
    mov word ptr [0x5b5102], ax                  # 0042d4e2
    mov ecx, dword ptr [0x5b5124]                # 0042d4e8
    mov dx, word ptr [ecx + field_4a]            # 0042d4ee
    mov word ptr [0x5b511a], dx                  # 0042d4f2
    mov dword ptr [0x5c39f5], 0x1                # 0042d4f9
    movsx eax, word ptr [ebp + arg_8]            # 0042d503
    imul eax, eax, 0x8d                          # 0042d507
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042d50d
    mov dword ptr [0x5d19b1], 0x0                # 0042d517
    mov word ptr [0x5b5104], 0x0                 # 0042d521
    cmp dword ptr [0x5b5083], 0x0                # 0042d52a
    je.d8 L_0042d5a3                             # 0042d531
    # block 0x0042d533: entered by fall-through of je at 0x0042d531, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0042d57b (forward)
    push 0x5b4eb1                                # 0042d533
    call FUN_0044c479                            # 0042d538
    add esp, 0x4                                 # 0042d53d
    mov dword ptr [0x5b4eb1], 0x2                # 0042d540
    mov ecx, dword ptr [0x5b5083]                # 0042d54a
    call FUN_00449a94                            # 0042d550
    mov ecx, dword ptr [0x5b5083]                # 0042d555
    mov dword ptr [ebp - local_2c], ecx          # 0042d55b
    mov edx, dword ptr [ebp - local_2c]          # 0042d55e
    mov dword ptr [ebp - local_28], edx          # 0042d561
    cmp dword ptr [ebp - local_28], 0x0          # 0042d564
    je.d8 L_0042d57b                             # 0042d568
    # block 0x0042d56a: entered by fall-through of je at 0x0042d568, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x0042d582
    push 0x1                                     # 0042d56a
    mov eax, dword ptr [ebp - local_28]          # 0042d56c
    mov edx, dword ptr [eax]                     # 0042d56f
    mov ecx, dword ptr [ebp - local_28]          # 0042d571
    call dword ptr [edx]                         # 0042d574
    mov dword ptr [ebp - local_44], eax          # 0042d576
    jmp.d8 L_0042d582                            # 0042d579
L_0042d57b:
    # block 0x0042d57b: entered by je at 0x0042d568, 1 instruction(s), falls into the block at 0x0042d582
    mov dword ptr [ebp - local_44], 0x0          # 0042d57b
L_0042d582:
    # block 0x0042d582: entered by jmp at 0x0042d579, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0042d5a3
    mov dword ptr [0x5b5083], 0x0                # 0042d582
    push 0x5b4eb1                                # 0042d58c
    call FUN_0044c4ab                            # 0042d591
    add esp, 0x4                                 # 0042d596
    mov dword ptr [0x5b4eb1], 0x0                # 0042d599
L_0042d5a3:
    # block 0x0042d5a3: entered by je at 0x0042d531, 2 instruction(s), ends with je to 0x0042d5e3 (forward)
    cmp dword ptr [0x5b502f], 0x0                # 0042d5a3
    je.d8 L_0042d5e3                             # 0042d5aa
    # block 0x0042d5ac: entered by fall-through of je at 0x0042d5aa, 5 instruction(s), ends with jne to 0x0042d5d0 (forward)
    {load} xor eax, eax                          # 0042d5ac
    mov ax, word ptr [0x5b5037]                  # 0042d5ae
    and eax, 0x8                                 # 0042d5b4
    test eax, eax                                # 0042d5b7
    jne.d8 L_0042d5d0                            # 0042d5b9
    # block 0x0042d5bb: entered by fall-through of jne at 0x0042d5b9, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0042d5d0
    mov ecx, dword ptr [0x5b502f]                # 0042d5bb
    mov dword ptr [ebp - local_30], ecx          # 0042d5c1
    mov edx, dword ptr [ebp - local_30]          # 0042d5c4
    push edx                                     # 0042d5c7
    call FUN_0051dc6c                            # 0042d5c8
    add esp, 0x4                                 # 0042d5cd
L_0042d5d0:
    # block 0x0042d5d0: entered by jne at 0x0042d5b9, 2 instruction(s), falls into the block at 0x0042d5e3
    mov word ptr [0x5b5037], 0x0                 # 0042d5d0
    mov dword ptr [0x5b502f], 0x0                # 0042d5d9
L_0042d5e3:
    # block 0x0042d5e3: entered by je at 0x0042d5aa, 2 instruction(s), ends with je to 0x0042d623 (forward)
    cmp dword ptr [0x5b5033], 0x0                # 0042d5e3
    je.d8 L_0042d623                             # 0042d5ea
    # block 0x0042d5ec: entered by fall-through of je at 0x0042d5ea, 5 instruction(s), ends with jne to 0x0042d610 (forward)
    {load} xor eax, eax                          # 0042d5ec
    mov ax, word ptr [0x5b5039]                  # 0042d5ee
    and eax, 0x8                                 # 0042d5f4
    test eax, eax                                # 0042d5f7
    jne.d8 L_0042d610                            # 0042d5f9
    # block 0x0042d5fb: entered by fall-through of jne at 0x0042d5f9, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0042d610
    mov ecx, dword ptr [0x5b5033]                # 0042d5fb
    mov dword ptr [ebp - local_34], ecx          # 0042d601
    mov edx, dword ptr [ebp - local_34]          # 0042d604
    push edx                                     # 0042d607
    call FUN_0051dc6c                            # 0042d608
    add esp, 0x4                                 # 0042d60d
L_0042d610:
    # block 0x0042d610: entered by jne at 0x0042d5f9, 2 instruction(s), falls into the block at 0x0042d623
    mov word ptr [0x5b5039], 0x0                 # 0042d610
    mov dword ptr [0x5b5033], 0x0                # 0042d619
L_0042d623:
    # block 0x0042d623: entered by je at 0x0042d5ea, 36 instruction(s), calls FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, ends with jne to 0x0042d6e8 (forward)
    push 0x5b4eb5                                # 0042d623
    mov ecx, 0x5e2dbe                            # 0042d628
    call FUN_00415011                            # 0042d62d
    push 0x5d03c3                                # 0042d632
    mov ecx, 0x5cf659                            # 0042d637
    call FUN_004c2dfb                            # 0042d63c
    push 0x5d03cb                                # 0042d641
    mov ecx, 0x5cf659                            # 0042d646
    call FUN_004c2dfb                            # 0042d64b
    mov edi, dword ptr [0x5b5124]                # 0042d650
    mov edx, 0x5b5006                            # 0042d656
    or ecx, -0x1                                 # 0042d65b
    {load} xor eax, eax                          # 0042d65e
    repne scasb al, byte ptr es:[edi]            # 0042d660
    not ecx                                      # 0042d662
    {load} sub edi, ecx                          # 0042d664
    {load} mov esi, edi                          # 0042d666
    {load} mov eax, ecx                          # 0042d668
    {load} mov edi, edx                          # 0042d66a
    shr ecx, 0x2                                 # 0042d66c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042d66f
    {load} mov ecx, eax                          # 0042d671
    and ecx, 0x3                                 # 0042d673
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042d676
    mov ecx, dword ptr [0x5b5124]                # 0042d678
    mov dx, word ptr [ecx + field_42]            # 0042d67e
    mov word ptr [0x5b5079], dx                  # 0042d682
    mov eax, dword ptr [0x5b5124]                # 0042d689
    mov cx, word ptr [eax + field_44]            # 0042d68e
    mov word ptr [0x5b507b], cx                  # 0042d692
    push 0x5b4eb5                                # 0042d699
    call FUN_0044c4c1                            # 0042d69e
    add esp, 0x4                                 # 0042d6a3
    movsx edx, word ptr [0x5b5102]               # 0042d6a6
    cmp edx, 0x2                                 # 0042d6ad
    jne.d8 L_0042d6e8                            # 0042d6b0
    # block 0x0042d6b2: entered by fall-through of jne at 0x0042d6b0, 20 instruction(s), calls FUN_0044c2e0, falls into the block at 0x0042d6e8
    mov eax, dword ptr [0x5b5124]                # 0042d6b2
    add eax, 0x21                                # 0042d6b7
    {load} mov edi, eax                          # 0042d6ba
    mov edx, 0x5b50df                            # 0042d6bc
    or ecx, -0x1                                 # 0042d6c1
    {load} xor eax, eax                          # 0042d6c4
    repne scasb al, byte ptr es:[edi]            # 0042d6c6
    not ecx                                      # 0042d6c8
    {load} sub edi, ecx                          # 0042d6ca
    {load} mov esi, edi                          # 0042d6cc
    {load} mov eax, ecx                          # 0042d6ce
    {load} mov edi, edx                          # 0042d6d0
    shr ecx, 0x2                                 # 0042d6d2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042d6d5
    {load} mov ecx, eax                          # 0042d6d7
    and ecx, 0x3                                 # 0042d6d9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042d6dc
    push 0x1                                     # 0042d6de
    call FUN_0044c2e0                            # 0042d6e0
    add esp, 0x4                                 # 0042d6e5
L_0042d6e8:
    # block 0x0042d6e8: entered by jne at 0x0042d6b0, 18 instruction(s), calls FUN_004c2c3a, ends with jne to 0x0042d7cf (forward)
    push 0x54597c                                # 0042d6e8
    push 0x1                                     # 0042d6ed
    push 0x8                                     # 0042d6ef
    mov ecx, dword ptr [0x5b506b]                # 0042d6f1
    sub ecx, dword ptr [0x5b5063]                # 0042d6f7
    add ecx, 0x1                                 # 0042d6fd
    push ecx                                     # 0042d700
    mov edx, dword ptr [0x5b5067]                # 0042d701
    sub edx, dword ptr [0x5b505f]                # 0042d707
    add edx, 0x1                                 # 0042d70d
    push edx                                     # 0042d710
    mov ecx, 0x5cf659                            # 0042d711
    call FUN_004c2c3a                            # 0042d716
    mov dword ptr [0x5d03c3], eax                # 0042d71b
    mov eax, dword ptr [0x5d03c3]                # 0042d720
    mov dword ptr [0x5d19a5], eax                # 0042d725
    cmp dword ptr [0x5b5083], 0x0                # 0042d72a
    jne.d32 L_0042d7cf                           # 0042d731
    # block 0x0042d737: entered by fall-through of jne at 0x0042d731, 13 instruction(s), calls FUN_0050ca3e, FUN_0051dc43, ends with je to 0x0042d78b (forward)
    mov ecx, dword ptr [0x5bb57b]                # 0042d737
    push ecx                                     # 0042d73d
    push 0x54598c                                # 0042d73e
    push 0x63888b                                # 0042d743
    call FUN_0050ca3e                            # 0042d748
    add esp, 0xc                                 # 0042d74d
    push 0x46                                    # 0042d750
    call FUN_0051dc43                            # 0042d752
    add esp, 0x4                                 # 0042d757
    mov dword ptr [ebp - local_3c], eax          # 0042d75a
    mov dword ptr [ebp - local_4], 0x0           # 0042d75d
    cmp dword ptr [ebp - local_3c], 0x0          # 0042d764
    je.d8 L_0042d78b                             # 0042d768
    # block 0x0042d76a: entered by fall-through of je at 0x0042d768, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x0042d792
    push 0x4                                     # 0042d76a
    movsx edx, word ptr [0x5b016f]               # 0042d76c
    push edx                                     # 0042d773
    push 0x63888b                                # 0042d774
    push 0x44cf01                                # 0042d779
    mov ecx, dword ptr [ebp - local_3c]          # 0042d77e
    call FUN_004497a0                            # 0042d781
    mov dword ptr [ebp - local_48], eax          # 0042d786
    jmp.d8 L_0042d792                            # 0042d789
L_0042d78b:
    # block 0x0042d78b: entered by je at 0x0042d768, 1 instruction(s), falls into the block at 0x0042d792
    mov dword ptr [ebp - local_48], 0x0          # 0042d78b
L_0042d792:
    # block 0x0042d792: entered by jmp at 0x0042d789, 7 instruction(s), ends with jne to 0x0042d7cf (forward)
    mov eax, dword ptr [ebp - local_48]          # 0042d792
    mov dword ptr [ebp - local_38], eax          # 0042d795
    mov dword ptr [ebp - local_4], 0xffffffff    # 0042d798
    mov ecx, dword ptr [ebp - local_38]          # 0042d79f
    mov dword ptr [0x5b5083], ecx                # 0042d7a2
    cmp dword ptr [0x5b5083], 0x0                # 0042d7a8
    jne.d8 L_0042d7cf                            # 0042d7af
    # block 0x0042d7b1: entered by fall-through of jne at 0x0042d7af, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x0042d7cf
    push 0x63888b                                # 0042d7b1
    push 0x5459b8                                # 0042d7b6
    mov ecx, 0x583979                            # 0042d7bb
    call FUN_0042639d                            # 0042d7c0
    mov ecx, 0x5cf659                            # 0042d7c5
    call FUN_004c97b4                            # 0042d7ca
L_0042d7cf:
    # block 0x0042d7cf: entered by jne at 0x0042d731; jne at 0x0042d7af, 5 instruction(s), ends with je to 0x0042d7ea (forward)
    mov edx, dword ptr [0x5b5124]                # 0042d7cf
    movsx eax, word ptr [edx + field_48]         # 0042d7d5
    mov dword ptr [ebp - local_4c], eax          # 0042d7d9
    cmp dword ptr [ebp - local_4c], 0x1          # 0042d7dc
    je.d8 L_0042d7ea                             # 0042d7e0
    # block 0x0042d7e2: entered by fall-through of je at 0x0042d7e0, 2 instruction(s), ends with je to 0x0042d811 (forward)
    cmp dword ptr [ebp - local_4c], 0x2          # 0042d7e2
    je.d8 L_0042d811                             # 0042d7e6
    # block 0x0042d7e8: entered by fall-through of je at 0x0042d7e6, 1 instruction(s), ends with forward jump to 0x0042d835
    jmp.d8 L_0042d835                            # 0042d7e8
L_0042d7ea:
    # block 0x0042d7ea: entered by je at 0x0042d7e0, 6 instruction(s), ends with forward jump to 0x0042d835
    mov ecx, dword ptr [0x5b5124]                # 0042d7ea
    mov dx, word ptr [ecx + field_4c]            # 0042d7f0
    mov word ptr [0x5b5077], dx                  # 0042d7f4
    mov dword ptr [0x5b5087], 0x0                # 0042d7fb
    mov dword ptr [0x5b508b], 0x0                # 0042d805
    jmp.d8 L_0042d835                            # 0042d80f
L_0042d811:
    # block 0x0042d811: entered by je at 0x0042d7e6, 5 instruction(s), falls into the block at 0x0042d835
    mov eax, dword ptr [0x5b5124]                # 0042d811
    mov cx, word ptr [eax + field_54]            # 0042d816
    mov word ptr [0x5b5077], cx                  # 0042d81a
    mov dword ptr [0x5b5087], 0x0                # 0042d821
    mov dword ptr [0x5b508b], 0x3                # 0042d82b
L_0042d835:
    # block 0x0042d835: entered by jmp at 0x0042d7e8; jmp at 0x0042d80f, 6 instruction(s), calls FUN_00449bff, falls into the block at 0x0042d85d
    mov word ptr [0x5b5081], 0x0                 # 0042d835
    mov ecx, dword ptr [0x5b5083]                # 0042d83e
    call FUN_00449bff                            # 0042d844
    movsx edx, word ptr [ebp + arg_8]            # 0042d849
    imul edx, edx, 0x8d                          # 0042d84d
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042d853
L_0042d85d:
    # block 0x0042d85d: entered by je at 0x0042d461, 17 instruction(s), ends with je to 0x0042d8c5 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042d85d
    imul eax, eax, 0x8d                          # 0042d861
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042d867
    mov dword ptr [0x5d19b1], 0x0                # 0042d871
    mov word ptr [0x5b5104], 0x0                 # 0042d87b
    mov ecx, dword ptr [0x5bb587]                # 0042d884
    mov dword ptr [ebp - local_18], ecx          # 0042d88a
    mov edx, dword ptr [0x5bb58f]                # 0042d88d
    mov dword ptr [ebp - local_10], edx          # 0042d893
    mov eax, dword ptr [0x5bb583]                # 0042d896
    mov dword ptr [ebp - local_1c], eax          # 0042d89b
    mov ecx, dword ptr [0x5bb58b]                # 0042d89e
    mov dword ptr [ebp - local_14], ecx          # 0042d8a4
    mov edx, dword ptr [0x5b5087]                # 0042d8a7
    mov dword ptr [ebp - local_50], edx          # 0042d8ad
    cmp dword ptr [ebp - local_50], 0x0          # 0042d8b0
    je.d8 L_0042d8c5                             # 0042d8b4
    # block 0x0042d8b6: entered by fall-through of je at 0x0042d8b4, 2 instruction(s), ends with je to 0x0042d96b (forward)
    cmp dword ptr [ebp - local_50], 0x4          # 0042d8b6
    je.d32 L_0042d96b                            # 0042d8ba
    # block 0x0042d8c0: entered by fall-through of je at 0x0042d8ba, 1 instruction(s), ends with forward jump to 0x0042da75
    jmp.d32 L_0042da75                           # 0042d8c0
L_0042d8c5:
    # block 0x0042d8c5: entered by je at 0x0042d8b4, 3 instruction(s), ends with je to 0x0042d966 (forward)
    movsx eax, word ptr [0x5b5081]               # 0042d8c5
    test eax, eax                                # 0042d8cc
    je.d32 L_0042d966                            # 0042d8ce
    # block 0x0042d8d4: entered by fall-through of je at 0x0042d8ce, 2 instruction(s), ends with forward jump to 0x0042d8e8
    mov word ptr [ebp - local_20], 0x0           # 0042d8d4
    jmp.d8 L_0042d8e8                            # 0042d8da
L_0042d8dc:
    # block 0x0042d8dc: entered by jmp at 0x0042d95a, 3 instruction(s), falls into the block at 0x0042d8e8
    mov cx, word ptr [ebp - local_20]            # 0042d8dc
    add cx, 0x1                                  # 0042d8e0
    mov word ptr [ebp - local_20], cx            # 0042d8e4
L_0042d8e8:
    # block 0x0042d8e8: entered by jmp at 0x0042d8da, 5 instruction(s), ends with jge to 0x0042d95c (forward)
    movsx edx, word ptr [ebp - local_20]         # 0042d8e8
    mov eax, dword ptr [0x5b5124]                # 0042d8ec
    movsx ecx, word ptr [eax + field_6f]         # 0042d8f1
    {load} cmp edx, ecx                          # 0042d8f5
    jge.d8 L_0042d95c                            # 0042d8f7
    # block 0x0042d8f9: entered by fall-through of jge at 0x0042d8f7, 7 instruction(s), ends with jne to 0x0042d95a (forward)
    movsx edx, word ptr [ebp - local_20]         # 0042d8f9
    imul edx, edx, 0x42                          # 0042d8fd
    mov eax, dword ptr [0x5b5120]                # 0042d900
    movsx ecx, word ptr [eax + edx]              # 0042d905
    movsx edx, word ptr [0x5bb50b]               # 0042d909
    {load} cmp ecx, edx                          # 0042d910
    jne.d8 L_0042d95a                            # 0042d912
    # block 0x0042d914: entered by fall-through of jne at 0x0042d912, 15 instruction(s), calls FUN_0042db5b, FUN_0042e7b8, FUN_0042e34e, FUN_0042dbe1, KERNEL32.dll!GetTickCount, ends with forward jump to 0x0042d95c
    mov dword ptr [0x5bb1ca], 0x1                # 0042d914
    call FUN_0042db5b                            # 0042d91e
    call FUN_0042e7b8                            # 0042d923
    call FUN_0042e34e                            # 0042d928
    lea eax, [ebp - local_1c]                    # 0042d92d
    push eax                                     # 0042d930
    mov cx, word ptr [ebp - local_20]            # 0042d931
    push ecx                                     # 0042d935
    call FUN_0042dbe1                            # 0042d936
    add esp, 0x8                                 # 0042d93b
    mov word ptr [0x5b5081], 0x0                 # 0042d93e
    call dword ptr [0x52a23c]                    # 0042d947
    add eax, dword ptr [0x5b4ed1]                # 0042d94d
    mov dword ptr [0x5b5073], eax                # 0042d953
    jmp.d8 L_0042d95c                            # 0042d958
L_0042d95a:
    # block 0x0042d95a: entered by jne at 0x0042d912, 1 instruction(s), ends with backward jump to 0x0042d8dc
    jmp.d8 L_0042d8dc                            # 0042d95a
L_0042d95c:
    # block 0x0042d95c: entered by jge at 0x0042d8f7; jmp at 0x0042d958, 1 instruction(s), falls into the block at 0x0042d966
    mov dword ptr [0x5b5087], 0x4                # 0042d95c
L_0042d966:
    # block 0x0042d966: entered by je at 0x0042d8ce, 1 instruction(s), ends with forward jump to 0x0042da75
    jmp.d32 L_0042da75                           # 0042d966
L_0042d96b:
    # block 0x0042d96b: entered by je at 0x0042d8ba, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0042da1e (forward)
    call dword ptr [0x52a23c]                    # 0042d96b
    cmp eax, dword ptr [0x5b5073]                # 0042d971
    jb.d32 L_0042da1e                            # 0042d977
    # block 0x0042d97d: entered by fall-through of jb at 0x0042d977, 3 instruction(s), ends with forward jump to 0x0042d997
    mov word ptr [ebp - local_24], 0x0           # 0042d97d
    mov word ptr [ebp - local_20], 0x0           # 0042d983
    jmp.d8 L_0042d997                            # 0042d989
L_0042d98b:
    # block 0x0042d98b: entered by jmp at 0x0042d9cd, 3 instruction(s), falls into the block at 0x0042d997
    mov dx, word ptr [ebp - local_20]            # 0042d98b
    add dx, 0x1                                  # 0042d98f
    mov word ptr [ebp - local_20], dx            # 0042d993
L_0042d997:
    # block 0x0042d997: entered by jmp at 0x0042d989, 5 instruction(s), ends with jge to 0x0042d9cf (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042d997
    mov ecx, dword ptr [0x5b5124]                # 0042d99b
    movsx edx, word ptr [ecx + field_6f]         # 0042d9a1
    {load} cmp eax, edx                          # 0042d9a5
    jge.d8 L_0042d9cf                            # 0042d9a7
    # block 0x0042d9a9: entered by fall-through of jge at 0x0042d9a7, 7 instruction(s), ends with jne to 0x0042d9cd (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042d9a9
    imul eax, eax, 0x42                          # 0042d9ad
    mov ecx, dword ptr [0x5b5120]                # 0042d9b0
    movsx edx, word ptr [ecx + eax]              # 0042d9b6
    movsx eax, word ptr [0x5bb50b]               # 0042d9ba
    {load} cmp edx, eax                          # 0042d9c1
    jne.d8 L_0042d9cd                            # 0042d9c3
    # block 0x0042d9c5: entered by fall-through of jne at 0x0042d9c3, 2 instruction(s), ends with forward jump to 0x0042d9cf
    mov word ptr [ebp - local_24], 0x1           # 0042d9c5
    jmp.d8 L_0042d9cf                            # 0042d9cb
L_0042d9cd:
    # block 0x0042d9cd: entered by jne at 0x0042d9c3, 1 instruction(s), ends with backward jump to 0x0042d98b
    jmp.d8 L_0042d98b                            # 0042d9cd
L_0042d9cf:
    # block 0x0042d9cf: entered by jge at 0x0042d9a7; jmp at 0x0042d9cb, 3 instruction(s), ends with je to 0x0042da1c (forward)
    movsx ecx, word ptr [ebp - local_24]         # 0042d9cf
    test ecx, ecx                                # 0042d9d3
    je.d8 L_0042da1c                             # 0042d9d5
    # block 0x0042d9d7: entered by fall-through of je at 0x0042d9d5, 3 instruction(s), ends with je to 0x0042da0b (forward)
    movsx edx, word ptr [0x5b5081]               # 0042d9d7
    test edx, edx                                # 0042d9de
    je.d8 L_0042da0b                             # 0042d9e0
    # block 0x0042d9e2: entered by fall-through of je at 0x0042d9e0, 7 instruction(s), calls FUN_0042e7b8, FUN_0042db5b, FUN_0042e34e, KERNEL32.dll!GetTickCount, falls into the block at 0x0042da0b
    call FUN_0042e7b8                            # 0042d9e2
    call FUN_0042db5b                            # 0042d9e7
    call FUN_0042e34e                            # 0042d9ec
    call dword ptr [0x52a23c]                    # 0042d9f1
    add eax, dword ptr [0x5b4ed1]                # 0042d9f7
    mov dword ptr [0x5b5073], eax                # 0042d9fd
    mov word ptr [0x5b5081], 0x0                 # 0042da02
L_0042da0b:
    # block 0x0042da0b: entered by je at 0x0042d9e0, 6 instruction(s), calls FUN_0042dbe1, falls into the block at 0x0042da1c
    lea eax, [ebp - local_1c]                    # 0042da0b
    push eax                                     # 0042da0e
    mov cx, word ptr [ebp - local_20]            # 0042da0f
    push ecx                                     # 0042da13
    call FUN_0042dbe1                            # 0042da14
    add esp, 0x8                                 # 0042da19
L_0042da1c:
    # block 0x0042da1c: entered by je at 0x0042d9d5, 1 instruction(s), ends with forward jump to 0x0042da75
    jmp.d8 L_0042da75                            # 0042da1c
L_0042da1e:
    # block 0x0042da1e: entered by jb at 0x0042d977, 2 instruction(s), ends with forward jump to 0x0042da32
    mov word ptr [ebp - local_20], 0x0           # 0042da1e
    jmp.d8 L_0042da32                            # 0042da24
L_0042da26:
    # block 0x0042da26: entered by jmp at 0x0042da73, 3 instruction(s), falls into the block at 0x0042da32
    mov dx, word ptr [ebp - local_20]            # 0042da26
    add dx, 0x1                                  # 0042da2a
    mov word ptr [ebp - local_20], dx            # 0042da2e
L_0042da32:
    # block 0x0042da32: entered by jmp at 0x0042da24, 5 instruction(s), ends with jge to 0x0042da75 (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042da32
    mov ecx, dword ptr [0x5b5124]                # 0042da36
    movsx edx, word ptr [ecx + field_6f]         # 0042da3c
    {load} cmp eax, edx                          # 0042da40
    jge.d8 L_0042da75                            # 0042da42
    # block 0x0042da44: entered by fall-through of jge at 0x0042da42, 7 instruction(s), ends with jne to 0x0042da73 (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042da44
    imul eax, eax, 0x42                          # 0042da48
    mov ecx, dword ptr [0x5b5120]                # 0042da4b
    movsx edx, word ptr [ecx + eax]              # 0042da51
    movsx eax, word ptr [0x5bb50b]               # 0042da55
    {load} cmp edx, eax                          # 0042da5c
    jne.d8 L_0042da73                            # 0042da5e
    # block 0x0042da60: entered by fall-through of jne at 0x0042da5e, 7 instruction(s), calls FUN_0042dbe1, ends with forward jump to 0x0042da75
    lea ecx, [ebp - local_1c]                    # 0042da60
    push ecx                                     # 0042da63
    mov dx, word ptr [ebp - local_20]            # 0042da64
    push edx                                     # 0042da68
    call FUN_0042dbe1                            # 0042da69
    add esp, 0x8                                 # 0042da6e
    jmp.d8 L_0042da75                            # 0042da71
L_0042da73:
    # block 0x0042da73: entered by jne at 0x0042da5e, 1 instruction(s), ends with backward jump to 0x0042da26
    jmp.d8 L_0042da26                            # 0042da73
L_0042da75:
    # block 0x0042da75: entered by jmp at 0x0042d8c0; jmp at 0x0042d966; jmp at 0x0042da1c; jge at 0x0042da42; more, 1 instruction(s), ends with forward jump to 0x0042db4b
    jmp.d32 L_0042db4b                           # 0042da75
L_0042da7a:
    # block 0x0042da7a: entered by je at 0x0042d46b, 3 instruction(s), ends with jne to 0x0042da8a (forward)
    movsx eax, word ptr [0x5b5081]               # 0042da7a
    test eax, eax                                # 0042da81
    jne.d8 L_0042da8a                            # 0042da83
    # block 0x0042da85: entered by fall-through of jne at 0x0042da83, 1 instruction(s), ends with forward jump to 0x0042db4b
    jmp.d32 L_0042db4b                           # 0042da85
L_0042da8a:
    # block 0x0042da8a: entered by jne at 0x0042da83, 9 instruction(s), ends with jne to 0x0042dac9 (forward)
    mov word ptr [0x5b5100], 0xffff              # 0042da8a
    mov word ptr [0x5b5102], 0x1                 # 0042da93
    mov word ptr [0x5b511a], 0x1                 # 0042da9c
    mov dword ptr [0x5c39f5], 0x0                # 0042daa5
    mov ecx, dword ptr [0x5b5124]                # 0042daaf
    {load} xor edx, edx                          # 0042dab5
    mov dl, byte ptr [ecx + field_6c]            # 0042dab7
    cmp edx, 0x1                                 # 0042daba
    jne.d8 L_0042dac9                            # 0042dabd
    # block 0x0042dabf: entered by fall-through of jne at 0x0042dabd, 3 instruction(s), calls FUN_0042e560, falls into the block at 0x0042dac9
    push 0x2                                     # 0042dabf
    call FUN_0042e560                            # 0042dac1
    add esp, 0x4                                 # 0042dac6
L_0042dac9:
    # block 0x0042dac9: entered by jne at 0x0042dabd, 26 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042db4b
    mov eax, dword ptr [0x5b5124]                # 0042dac9
    movsx ecx, word ptr [eax + field_58]         # 0042dace
    mov dword ptr [0x5bb57b], ecx                # 0042dad2
    mov edx, dword ptr [0x5b5124]                # 0042dad8
    mov ax, word ptr [edx + field_5a]            # 0042dade
    mov word ptr [0x5bb599], ax                  # 0042dae2
    mov ecx, dword ptr [0x5b5124]                # 0042dae8
    mov dx, word ptr [ecx + field_5c]            # 0042daee
    mov word ptr [0x5bb595], dx                  # 0042daf2
    mov eax, dword ptr [0x5b5124]                # 0042daf9
    mov cx, word ptr [eax + field_5e]            # 0042dafe
    mov word ptr [0x5c39ff], cx                  # 0042db02
    mov edx, dword ptr [0x5b5124]                # 0042db09
    mov eax, dword ptr [edx + field_60]          # 0042db0f
    mov dword ptr [0x5bb59b], eax                # 0042db12
    mov ecx, dword ptr [0x5b5124]                # 0042db17
    mov edx, dword ptr [ecx + field_64]          # 0042db1d
    mov dword ptr [0x5bb59f], edx                # 0042db20
    mov eax, dword ptr [0x5b5124]                # 0042db26
    mov ecx, dword ptr [eax + field_68]          # 0042db2b
    mov dword ptr [0x5bb5a3], ecx                # 0042db2e
    mov dword ptr [0x583999], 0x4                # 0042db34
    mov dx, word ptr [ebp + arg_8]               # 0042db3e
    push edx                                     # 0042db42
    call FUN_0042ba3a                            # 0042db43
    add esp, 0x4                                 # 0042db48
L_0042db4b:
    # block 0x0042db4b: entered by jmp at 0x0042d43f; jmp at 0x0042d471; jmp at 0x0042d4bf; jmp at 0x0042da75; more, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0042db4b
    mov dword ptr fs:[0x0], ecx                  # 0042db4e
    pop edi                                      # 0042db55
    pop esi                                      # 0042db56
    {load} mov esp, ebp                          # 0042db57
    pop ebp                                      # 0042db59
    ret                                          # 0042db5a

