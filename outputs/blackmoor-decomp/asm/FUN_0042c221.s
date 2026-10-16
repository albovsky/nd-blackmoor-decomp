# FUN_0042c221
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042c221
# extent:       0x0042c221-0x0042ca22 (2049 code bytes)
# span:         0x0042c221-0x0042ca22 (code 2049, tables 0, padding 0)
# sha256:       c6914d608b70a9a0197c63e1086d625565068a277f248fe81268da48d38e672b
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042c221
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       19 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 7 more
# fields:       [eax + n] field_44, field_54, field_58, field_5e, field_68, field_6f, field_71; [ecx + n] field_42, field_4a, field_4c, field_5c, field_64, field_6c, field_6d, field_6f; [edx + n] field_46, field_48, field_5a, field_60, field_6d
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_0051dc6c, FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, FUN_0044c2e0, FUN_004c2c3a, FUN_0051dc43, FUN_004497a0, FUN_0042639d, FUN_00449bff and 7 more; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_start (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 470 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.set FUN_0042ca22, .text + (0x0042ca22 - 0x401000)
.set FUN_0042caa8, .text + (0x0042caa8 - 0x401000)
.set FUN_0042d215, .text + (0x0042d215 - 0x401000)
.set FUN_0042e560, .text + (0x0042e560 - 0x401000)
.set FUN_0042e72c, .text + (0x0042e72c - 0x401000)
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

.org 0x0042c221 - 0x401000
.globl FUN_0042c221
FUN_0042c221:
    # block 0x0042c221: entry, 18 instruction(s), ends with jle to 0x0042c27d (forward)
    push ebp                                     # 0042c221
    {load} mov ebp, esp                          # 0042c222
    push -0x1                                    # 0042c224
    push 0x527dfb                                # 0042c226
    mov eax, dword ptr fs:[0x0]                  # 0042c22b
    push eax                                     # 0042c231
    mov dword ptr fs:[0x0], esp                  # 0042c232
    sub esp, 0x44                                # 0042c239
    push esi                                     # 0042c23c
    push edi                                     # 0042c23d
    movsx eax, word ptr [ebp + arg_8]            # 0042c23e
    imul eax, eax, 0x8d                          # 0042c242
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c248
    mov dword ptr [0x5b4ead], ecx                # 0042c24e
    mov edx, dword ptr [0x5b4ead]                # 0042c254
    movsx eax, word ptr [edx + field_6d]         # 0042c25a
    test eax, eax                                # 0042c25e
    jle.d8 L_0042c27d                            # 0042c260
    # block 0x0042c262: entered by fall-through of jle at 0x0042c260, 6 instruction(s), ends with forward jump to 0x0042c287
    movsx ecx, word ptr [ebp + arg_8]            # 0042c262
    imul ecx, ecx, 0x8d                          # 0042c266
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042c26c
    add edx, 0x71                                # 0042c272
    mov dword ptr [0x5b4ea5], edx                # 0042c275
    jmp.d8 L_0042c287                            # 0042c27b
L_0042c27d:
    # block 0x0042c27d: entered by jle at 0x0042c260, 1 instruction(s), falls into the block at 0x0042c287
    mov dword ptr [0x5b4ea5], 0x0                # 0042c27d
L_0042c287:
    # block 0x0042c287: entered by jmp at 0x0042c27b, 4 instruction(s), ends with jle to 0x0042c2bc (forward)
    mov eax, dword ptr [0x5b4ead]                # 0042c287
    movsx ecx, word ptr [eax + field_6f]         # 0042c28c
    test ecx, ecx                                # 0042c290
    jle.d8 L_0042c2bc                            # 0042c292
    # block 0x0042c294: entered by fall-through of jle at 0x0042c292, 9 instruction(s), ends with forward jump to 0x0042c30b
    movsx edx, word ptr [ebp + arg_8]            # 0042c294
    imul edx, edx, 0x8d                          # 0042c298
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042c29e
    mov ecx, dword ptr [0x5b4ead]                # 0042c2a4
    movsx edx, word ptr [ecx + field_6d]         # 0042c2aa
    imul edx, edx, 0x6                           # 0042c2ae
    lea eax, [eax + edx + field_71]              # 0042c2b1
    mov dword ptr [0x5b4ea9], eax                # 0042c2b5
    jmp.d8 L_0042c30b                            # 0042c2ba
L_0042c2bc:
    # block 0x0042c2bc: entered by jle at 0x0042c292, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042ca12
    mov dword ptr [0x5b4ea9], 0x0                # 0042c2bc
    movsx ecx, word ptr [ebp + arg_8]            # 0042c2c6
    imul ecx, ecx, 0x8d                          # 0042c2ca
    add ecx, 0x5bb5b3                            # 0042c2d0
    push ecx                                     # 0042c2d6
    movsx edx, word ptr [ebp + arg_8]            # 0042c2d7
    push edx                                     # 0042c2db
    push 0x5457ac                                # 0042c2dc
    push 0x63888b                                # 0042c2e1
    call FUN_0050ca3e                            # 0042c2e6
    add esp, 0x10                                # 0042c2eb
    push 0x0                                     # 0042c2ee
    push 0x0                                     # 0042c2f0
    push 0x63888b                                # 0042c2f2
    call FUN_0052139c                            # 0042c2f7
    mov ecx, 0x5cf659                            # 0042c2fc
    call FUN_004c97b4                            # 0042c301
    jmp.d32 L_0042ca12                           # 0042c306
L_0042c30b:
    # block 0x0042c30b: entered by jmp at 0x0042c2ba, 6 instruction(s), ends with je to 0x0042c33d (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042c30b
    imul eax, eax, 0x8d                          # 0042c30f
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042c315
    mov dword ptr [ebp - local_40], ecx          # 0042c31b
    cmp dword ptr [ebp - local_40], 0x0          # 0042c31e
    je.d8 L_0042c33d                             # 0042c322
    # block 0x0042c324: entered by fall-through of je at 0x0042c322, 2 instruction(s), ends with je to 0x0042c724 (forward)
    cmp dword ptr [ebp - local_40], 0x1          # 0042c324
    je.d32 L_0042c724                            # 0042c328
    # block 0x0042c32e: entered by fall-through of je at 0x0042c328, 2 instruction(s), ends with je to 0x0042c941 (forward)
    cmp dword ptr [ebp - local_40], 0x2          # 0042c32e
    je.d32 L_0042c941                            # 0042c332
    # block 0x0042c338: entered by fall-through of je at 0x0042c332, 1 instruction(s), ends with forward jump to 0x0042ca12
    jmp.d32 L_0042ca12                           # 0042c338
L_0042c33d:
    # block 0x0042c33d: entered by je at 0x0042c322, 2 instruction(s), ends with je to 0x0042c38b (forward)
    cmp dword ptr [0x5c39f1], 0x0                # 0042c33d
    je.d8 L_0042c38b                             # 0042c344
    # block 0x0042c346: entered by fall-through of je at 0x0042c344, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0042ca12
    movsx edx, word ptr [ebp + arg_8]            # 0042c346
    imul edx, edx, 0x8d                          # 0042c34a
    add edx, 0x5bb5b3                            # 0042c350
    push edx                                     # 0042c356
    movsx eax, word ptr [ebp + arg_8]            # 0042c357
    push eax                                     # 0042c35b
    push 0x5457fc                                # 0042c35c
    push 0x63888b                                # 0042c361
    call FUN_0050ca3e                            # 0042c366
    add esp, 0x10                                # 0042c36b
    push 0x0                                     # 0042c36e
    push 0x0                                     # 0042c370
    push 0x63888b                                # 0042c372
    call FUN_0052139c                            # 0042c377
    mov ecx, 0x5cf659                            # 0042c37c
    call FUN_004c97b4                            # 0042c381
    jmp.d32 L_0042ca12                           # 0042c386
L_0042c38b:
    # block 0x0042c38b: entered by je at 0x0042c344, 17 instruction(s), ends with je to 0x0042c46a (forward)
    mov word ptr [0x5b4dc8], 0x0                 # 0042c38b
    mov cx, word ptr [ebp + arg_8]               # 0042c394
    mov word ptr [0x5b4e89], cx                  # 0042c398
    mov edx, dword ptr [0x5b4ead]                # 0042c39f
    mov ax, word ptr [edx + field_46]            # 0042c3a5
    mov word ptr [0x5b4e8b], ax                  # 0042c3a9
    mov ecx, dword ptr [0x5b4ead]                # 0042c3af
    mov dx, word ptr [ecx + field_4a]            # 0042c3b5
    mov word ptr [0x5b4ea3], dx                  # 0042c3b9
    mov dword ptr [0x5c39f1], 0x1                # 0042c3c0
    movsx eax, word ptr [ebp + arg_8]            # 0042c3ca
    imul eax, eax, 0x8d                          # 0042c3ce
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042c3d4
    mov dword ptr [0x5d1967], 0x0                # 0042c3de
    mov word ptr [0x5b4e8d], 0x0                 # 0042c3e8
    cmp dword ptr [0x5b4e0c], 0x0                # 0042c3f1
    je.d8 L_0042c46a                             # 0042c3f8
    # block 0x0042c3fa: entered by fall-through of je at 0x0042c3f8, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0042c442 (forward)
    push 0x5b4c3a                                # 0042c3fa
    call FUN_0044c479                            # 0042c3ff
    add esp, 0x4                                 # 0042c404
    mov dword ptr [0x5b4c3a], 0x2                # 0042c407
    mov ecx, dword ptr [0x5b4e0c]                # 0042c411
    call FUN_00449a94                            # 0042c417
    mov ecx, dword ptr [0x5b4e0c]                # 0042c41c
    mov dword ptr [ebp - local_2c], ecx          # 0042c422
    mov edx, dword ptr [ebp - local_2c]          # 0042c425
    mov dword ptr [ebp - local_28], edx          # 0042c428
    cmp dword ptr [ebp - local_28], 0x0          # 0042c42b
    je.d8 L_0042c442                             # 0042c42f
    # block 0x0042c431: entered by fall-through of je at 0x0042c42f, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x0042c449
    push 0x1                                     # 0042c431
    mov eax, dword ptr [ebp - local_28]          # 0042c433
    mov edx, dword ptr [eax]                     # 0042c436
    mov ecx, dword ptr [ebp - local_28]          # 0042c438
    call dword ptr [edx]                         # 0042c43b
    mov dword ptr [ebp - local_44], eax          # 0042c43d
    jmp.d8 L_0042c449                            # 0042c440
L_0042c442:
    # block 0x0042c442: entered by je at 0x0042c42f, 1 instruction(s), falls into the block at 0x0042c449
    mov dword ptr [ebp - local_44], 0x0          # 0042c442
L_0042c449:
    # block 0x0042c449: entered by jmp at 0x0042c440, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0042c46a
    mov dword ptr [0x5b4e0c], 0x0                # 0042c449
    push 0x5b4c3a                                # 0042c453
    call FUN_0044c4ab                            # 0042c458
    add esp, 0x4                                 # 0042c45d
    mov dword ptr [0x5b4c3a], 0x0                # 0042c460
L_0042c46a:
    # block 0x0042c46a: entered by je at 0x0042c3f8, 2 instruction(s), ends with je to 0x0042c4aa (forward)
    cmp dword ptr [0x5b4db8], 0x0                # 0042c46a
    je.d8 L_0042c4aa                             # 0042c471
    # block 0x0042c473: entered by fall-through of je at 0x0042c471, 5 instruction(s), ends with jne to 0x0042c497 (forward)
    {load} xor eax, eax                          # 0042c473
    mov ax, word ptr [0x5b4dc0]                  # 0042c475
    and eax, 0x8                                 # 0042c47b
    test eax, eax                                # 0042c47e
    jne.d8 L_0042c497                            # 0042c480
    # block 0x0042c482: entered by fall-through of jne at 0x0042c480, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0042c497
    mov ecx, dword ptr [0x5b4db8]                # 0042c482
    mov dword ptr [ebp - local_30], ecx          # 0042c488
    mov edx, dword ptr [ebp - local_30]          # 0042c48b
    push edx                                     # 0042c48e
    call FUN_0051dc6c                            # 0042c48f
    add esp, 0x4                                 # 0042c494
L_0042c497:
    # block 0x0042c497: entered by jne at 0x0042c480, 2 instruction(s), falls into the block at 0x0042c4aa
    mov word ptr [0x5b4dc0], 0x0                 # 0042c497
    mov dword ptr [0x5b4db8], 0x0                # 0042c4a0
L_0042c4aa:
    # block 0x0042c4aa: entered by je at 0x0042c471, 2 instruction(s), ends with je to 0x0042c4ea (forward)
    cmp dword ptr [0x5b4dbc], 0x0                # 0042c4aa
    je.d8 L_0042c4ea                             # 0042c4b1
    # block 0x0042c4b3: entered by fall-through of je at 0x0042c4b1, 5 instruction(s), ends with jne to 0x0042c4d7 (forward)
    {load} xor eax, eax                          # 0042c4b3
    mov ax, word ptr [0x5b4dc2]                  # 0042c4b5
    and eax, 0x8                                 # 0042c4bb
    test eax, eax                                # 0042c4be
    jne.d8 L_0042c4d7                            # 0042c4c0
    # block 0x0042c4c2: entered by fall-through of jne at 0x0042c4c0, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0042c4d7
    mov ecx, dword ptr [0x5b4dbc]                # 0042c4c2
    mov dword ptr [ebp - local_34], ecx          # 0042c4c8
    mov edx, dword ptr [ebp - local_34]          # 0042c4cb
    push edx                                     # 0042c4ce
    call FUN_0051dc6c                            # 0042c4cf
    add esp, 0x4                                 # 0042c4d4
L_0042c4d7:
    # block 0x0042c4d7: entered by jne at 0x0042c4c0, 2 instruction(s), falls into the block at 0x0042c4ea
    mov word ptr [0x5b4dc2], 0x0                 # 0042c4d7
    mov dword ptr [0x5b4dbc], 0x0                # 0042c4e0
L_0042c4ea:
    # block 0x0042c4ea: entered by je at 0x0042c4b1, 36 instruction(s), calls FUN_00415011, FUN_004c2dfb, FUN_0044c4c1, ends with jne to 0x0042c5af (forward)
    push 0x5b4c3e                                # 0042c4ea
    mov ecx, 0x5e2dbe                            # 0042c4ef
    call FUN_00415011                            # 0042c4f4
    push 0x5d03bf                                # 0042c4f9
    mov ecx, 0x5cf659                            # 0042c4fe
    call FUN_004c2dfb                            # 0042c503
    push 0x5d03c7                                # 0042c508
    mov ecx, 0x5cf659                            # 0042c50d
    call FUN_004c2dfb                            # 0042c512
    mov edi, dword ptr [0x5b4ead]                # 0042c517
    mov edx, 0x5b4d8f                            # 0042c51d
    or ecx, -0x1                                 # 0042c522
    {load} xor eax, eax                          # 0042c525
    repne scasb al, byte ptr es:[edi]            # 0042c527
    not ecx                                      # 0042c529
    {load} sub edi, ecx                          # 0042c52b
    {load} mov esi, edi                          # 0042c52d
    {load} mov eax, ecx                          # 0042c52f
    {load} mov edi, edx                          # 0042c531
    shr ecx, 0x2                                 # 0042c533
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042c536
    {load} mov ecx, eax                          # 0042c538
    and ecx, 0x3                                 # 0042c53a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042c53d
    mov ecx, dword ptr [0x5b4ead]                # 0042c53f
    mov dx, word ptr [ecx + field_42]            # 0042c545
    mov word ptr [0x5b4e02], dx                  # 0042c549
    mov eax, dword ptr [0x5b4ead]                # 0042c550
    mov cx, word ptr [eax + field_44]            # 0042c555
    mov word ptr [0x5b4e04], cx                  # 0042c559
    push 0x5b4c3e                                # 0042c560
    call FUN_0044c4c1                            # 0042c565
    add esp, 0x4                                 # 0042c56a
    movsx edx, word ptr [0x5b4e8b]               # 0042c56d
    cmp edx, 0x2                                 # 0042c574
    jne.d8 L_0042c5af                            # 0042c577
    # block 0x0042c579: entered by fall-through of jne at 0x0042c577, 20 instruction(s), calls FUN_0044c2e0, falls into the block at 0x0042c5af
    mov eax, dword ptr [0x5b4ead]                # 0042c579
    add eax, 0x21                                # 0042c57e
    {load} mov edi, eax                          # 0042c581
    mov edx, 0x5b4e68                            # 0042c583
    or ecx, -0x1                                 # 0042c588
    {load} xor eax, eax                          # 0042c58b
    repne scasb al, byte ptr es:[edi]            # 0042c58d
    not ecx                                      # 0042c58f
    {load} sub edi, ecx                          # 0042c591
    {load} mov esi, edi                          # 0042c593
    {load} mov eax, ecx                          # 0042c595
    {load} mov edi, edx                          # 0042c597
    shr ecx, 0x2                                 # 0042c599
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042c59c
    {load} mov ecx, eax                          # 0042c59e
    and ecx, 0x3                                 # 0042c5a0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042c5a3
    push 0x1                                     # 0042c5a5
    call FUN_0044c2e0                            # 0042c5a7
    add esp, 0x4                                 # 0042c5ac
L_0042c5af:
    # block 0x0042c5af: entered by jne at 0x0042c577, 18 instruction(s), calls FUN_004c2c3a, ends with jne to 0x0042c696 (forward)
    push 0x545864                                # 0042c5af
    push 0x1                                     # 0042c5b4
    push 0x8                                     # 0042c5b6
    mov ecx, dword ptr [0x5b4df4]                # 0042c5b8
    sub ecx, dword ptr [0x5b4dec]                # 0042c5be
    add ecx, 0x1                                 # 0042c5c4
    push ecx                                     # 0042c5c7
    mov edx, dword ptr [0x5b4df0]                # 0042c5c8
    sub edx, dword ptr [0x5b4de8]                # 0042c5ce
    add edx, 0x1                                 # 0042c5d4
    push edx                                     # 0042c5d7
    mov ecx, 0x5cf659                            # 0042c5d8
    call FUN_004c2c3a                            # 0042c5dd
    mov dword ptr [0x5d03bf], eax                # 0042c5e2
    mov eax, dword ptr [0x5d03bf]                # 0042c5e7
    mov dword ptr [0x5d195b], eax                # 0042c5ec
    cmp dword ptr [0x5b4e0c], 0x0                # 0042c5f1
    jne.d32 L_0042c696                           # 0042c5f8
    # block 0x0042c5fe: entered by fall-through of jne at 0x0042c5f8, 13 instruction(s), calls FUN_0050ca3e, FUN_0051dc43, ends with je to 0x0042c652 (forward)
    mov ecx, dword ptr [0x5bb57b]                # 0042c5fe
    push ecx                                     # 0042c604
    push 0x545874                                # 0042c605
    push 0x63888b                                # 0042c60a
    call FUN_0050ca3e                            # 0042c60f
    add esp, 0xc                                 # 0042c614
    push 0x46                                    # 0042c617
    call FUN_0051dc43                            # 0042c619
    add esp, 0x4                                 # 0042c61e
    mov dword ptr [ebp - local_3c], eax          # 0042c621
    mov dword ptr [ebp - local_4], 0x0           # 0042c624
    cmp dword ptr [ebp - local_3c], 0x0          # 0042c62b
    je.d8 L_0042c652                             # 0042c62f
    # block 0x0042c631: entered by fall-through of je at 0x0042c62f, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x0042c659
    push 0x4                                     # 0042c631
    movsx edx, word ptr [0x5b016f]               # 0042c633
    push edx                                     # 0042c63a
    push 0x63888b                                # 0042c63b
    push 0x44cde2                                # 0042c640
    mov ecx, dword ptr [ebp - local_3c]          # 0042c645
    call FUN_004497a0                            # 0042c648
    mov dword ptr [ebp - local_48], eax          # 0042c64d
    jmp.d8 L_0042c659                            # 0042c650
L_0042c652:
    # block 0x0042c652: entered by je at 0x0042c62f, 1 instruction(s), falls into the block at 0x0042c659
    mov dword ptr [ebp - local_48], 0x0          # 0042c652
L_0042c659:
    # block 0x0042c659: entered by jmp at 0x0042c650, 7 instruction(s), ends with jne to 0x0042c696 (forward)
    mov eax, dword ptr [ebp - local_48]          # 0042c659
    mov dword ptr [ebp - local_38], eax          # 0042c65c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0042c65f
    mov ecx, dword ptr [ebp - local_38]          # 0042c666
    mov dword ptr [0x5b4e0c], ecx                # 0042c669
    cmp dword ptr [0x5b4e0c], 0x0                # 0042c66f
    jne.d8 L_0042c696                            # 0042c676
    # block 0x0042c678: entered by fall-through of jne at 0x0042c676, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x0042c696
    push 0x63888b                                # 0042c678
    push 0x5458a0                                # 0042c67d
    mov ecx, 0x583979                            # 0042c682
    call FUN_0042639d                            # 0042c687
    mov ecx, 0x5cf659                            # 0042c68c
    call FUN_004c97b4                            # 0042c691
L_0042c696:
    # block 0x0042c696: entered by jne at 0x0042c5f8; jne at 0x0042c676, 5 instruction(s), ends with je to 0x0042c6b1 (forward)
    mov edx, dword ptr [0x5b4ead]                # 0042c696
    movsx eax, word ptr [edx + field_48]         # 0042c69c
    mov dword ptr [ebp - local_4c], eax          # 0042c6a0
    cmp dword ptr [ebp - local_4c], 0x1          # 0042c6a3
    je.d8 L_0042c6b1                             # 0042c6a7
    # block 0x0042c6a9: entered by fall-through of je at 0x0042c6a7, 2 instruction(s), ends with je to 0x0042c6d8 (forward)
    cmp dword ptr [ebp - local_4c], 0x2          # 0042c6a9
    je.d8 L_0042c6d8                             # 0042c6ad
    # block 0x0042c6af: entered by fall-through of je at 0x0042c6ad, 1 instruction(s), ends with forward jump to 0x0042c6fc
    jmp.d8 L_0042c6fc                            # 0042c6af
L_0042c6b1:
    # block 0x0042c6b1: entered by je at 0x0042c6a7, 6 instruction(s), ends with forward jump to 0x0042c6fc
    mov ecx, dword ptr [0x5b4ead]                # 0042c6b1
    mov dx, word ptr [ecx + field_4c]            # 0042c6b7
    mov word ptr [0x5b4e00], dx                  # 0042c6bb
    mov dword ptr [0x5b4e10], 0x0                # 0042c6c2
    mov dword ptr [0x5b4e14], 0x0                # 0042c6cc
    jmp.d8 L_0042c6fc                            # 0042c6d6
L_0042c6d8:
    # block 0x0042c6d8: entered by je at 0x0042c6ad, 5 instruction(s), falls into the block at 0x0042c6fc
    mov eax, dword ptr [0x5b4ead]                # 0042c6d8
    mov cx, word ptr [eax + field_54]            # 0042c6dd
    mov word ptr [0x5b4e00], cx                  # 0042c6e1
    mov dword ptr [0x5b4e10], 0x0                # 0042c6e8
    mov dword ptr [0x5b4e14], 0x3                # 0042c6f2
L_0042c6fc:
    # block 0x0042c6fc: entered by jmp at 0x0042c6af; jmp at 0x0042c6d6, 6 instruction(s), calls FUN_00449bff, falls into the block at 0x0042c724
    mov word ptr [0x5b4e0a], 0x0                 # 0042c6fc
    mov ecx, dword ptr [0x5b4e0c]                # 0042c705
    call FUN_00449bff                            # 0042c70b
    movsx edx, word ptr [ebp + arg_8]            # 0042c710
    imul edx, edx, 0x8d                          # 0042c714
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042c71a
L_0042c724:
    # block 0x0042c724: entered by je at 0x0042c328, 17 instruction(s), ends with je to 0x0042c78c (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042c724
    imul eax, eax, 0x8d                          # 0042c728
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042c72e
    mov dword ptr [0x5d1967], 0x0                # 0042c738
    mov word ptr [0x5b4e8d], 0x0                 # 0042c742
    mov ecx, dword ptr [0x5bb587]                # 0042c74b
    mov dword ptr [ebp - local_18], ecx          # 0042c751
    mov edx, dword ptr [0x5bb58f]                # 0042c754
    mov dword ptr [ebp - local_10], edx          # 0042c75a
    mov eax, dword ptr [0x5bb583]                # 0042c75d
    mov dword ptr [ebp - local_1c], eax          # 0042c762
    mov ecx, dword ptr [0x5bb58b]                # 0042c765
    mov dword ptr [ebp - local_14], ecx          # 0042c76b
    mov edx, dword ptr [0x5b4e10]                # 0042c76e
    mov dword ptr [ebp - local_50], edx          # 0042c774
    cmp dword ptr [ebp - local_50], 0x0          # 0042c777
    je.d8 L_0042c78c                             # 0042c77b
    # block 0x0042c77d: entered by fall-through of je at 0x0042c77b, 2 instruction(s), ends with je to 0x0042c832 (forward)
    cmp dword ptr [ebp - local_50], 0x4          # 0042c77d
    je.d32 L_0042c832                            # 0042c781
    # block 0x0042c787: entered by fall-through of je at 0x0042c781, 1 instruction(s), ends with forward jump to 0x0042c93c
    jmp.d32 L_0042c93c                           # 0042c787
L_0042c78c:
    # block 0x0042c78c: entered by je at 0x0042c77b, 3 instruction(s), ends with je to 0x0042c82d (forward)
    movsx eax, word ptr [0x5b4e0a]               # 0042c78c
    test eax, eax                                # 0042c793
    je.d32 L_0042c82d                            # 0042c795
    # block 0x0042c79b: entered by fall-through of je at 0x0042c795, 2 instruction(s), ends with forward jump to 0x0042c7af
    mov word ptr [ebp - local_20], 0x0           # 0042c79b
    jmp.d8 L_0042c7af                            # 0042c7a1
L_0042c7a3:
    # block 0x0042c7a3: entered by jmp at 0x0042c821, 3 instruction(s), falls into the block at 0x0042c7af
    mov cx, word ptr [ebp - local_20]            # 0042c7a3
    add cx, 0x1                                  # 0042c7a7
    mov word ptr [ebp - local_20], cx            # 0042c7ab
L_0042c7af:
    # block 0x0042c7af: entered by jmp at 0x0042c7a1, 5 instruction(s), ends with jge to 0x0042c823 (forward)
    movsx edx, word ptr [ebp - local_20]         # 0042c7af
    mov eax, dword ptr [0x5b4ead]                # 0042c7b3
    movsx ecx, word ptr [eax + field_6f]         # 0042c7b8
    {load} cmp edx, ecx                          # 0042c7bc
    jge.d8 L_0042c823                            # 0042c7be
    # block 0x0042c7c0: entered by fall-through of jge at 0x0042c7be, 7 instruction(s), ends with jne to 0x0042c821 (forward)
    movsx edx, word ptr [ebp - local_20]         # 0042c7c0
    imul edx, edx, 0x42                          # 0042c7c4
    mov eax, dword ptr [0x5b4ea9]                # 0042c7c7
    movsx ecx, word ptr [eax + edx]              # 0042c7cc
    movsx edx, word ptr [0x5bb50b]               # 0042c7d0
    {load} cmp ecx, edx                          # 0042c7d7
    jne.d8 L_0042c821                            # 0042c7d9
    # block 0x0042c7db: entered by fall-through of jne at 0x0042c7d9, 15 instruction(s), calls FUN_0042ca22, FUN_0042e72c, FUN_0042d215, FUN_0042caa8, KERNEL32.dll!GetTickCount, ends with forward jump to 0x0042c823
    mov dword ptr [0x5bb1ca], 0x1                # 0042c7db
    call FUN_0042ca22                            # 0042c7e5
    call FUN_0042e72c                            # 0042c7ea
    call FUN_0042d215                            # 0042c7ef
    lea eax, [ebp - local_1c]                    # 0042c7f4
    push eax                                     # 0042c7f7
    mov cx, word ptr [ebp - local_20]            # 0042c7f8
    push ecx                                     # 0042c7fc
    call FUN_0042caa8                            # 0042c7fd
    add esp, 0x8                                 # 0042c802
    mov word ptr [0x5b4e0a], 0x0                 # 0042c805
    call dword ptr [0x52a23c]                    # 0042c80e
    add eax, dword ptr [0x5b4c5a]                # 0042c814
    mov dword ptr [0x5b4dfc], eax                # 0042c81a
    jmp.d8 L_0042c823                            # 0042c81f
L_0042c821:
    # block 0x0042c821: entered by jne at 0x0042c7d9, 1 instruction(s), ends with backward jump to 0x0042c7a3
    jmp.d8 L_0042c7a3                            # 0042c821
L_0042c823:
    # block 0x0042c823: entered by jge at 0x0042c7be; jmp at 0x0042c81f, 1 instruction(s), falls into the block at 0x0042c82d
    mov dword ptr [0x5b4e10], 0x4                # 0042c823
L_0042c82d:
    # block 0x0042c82d: entered by je at 0x0042c795, 1 instruction(s), ends with forward jump to 0x0042c93c
    jmp.d32 L_0042c93c                           # 0042c82d
L_0042c832:
    # block 0x0042c832: entered by je at 0x0042c781, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0042c8e5 (forward)
    call dword ptr [0x52a23c]                    # 0042c832
    cmp eax, dword ptr [0x5b4dfc]                # 0042c838
    jb.d32 L_0042c8e5                            # 0042c83e
    # block 0x0042c844: entered by fall-through of jb at 0x0042c83e, 3 instruction(s), ends with forward jump to 0x0042c85e
    mov word ptr [ebp - local_24], 0x0           # 0042c844
    mov word ptr [ebp - local_20], 0x0           # 0042c84a
    jmp.d8 L_0042c85e                            # 0042c850
L_0042c852:
    # block 0x0042c852: entered by jmp at 0x0042c894, 3 instruction(s), falls into the block at 0x0042c85e
    mov dx, word ptr [ebp - local_20]            # 0042c852
    add dx, 0x1                                  # 0042c856
    mov word ptr [ebp - local_20], dx            # 0042c85a
L_0042c85e:
    # block 0x0042c85e: entered by jmp at 0x0042c850, 5 instruction(s), ends with jge to 0x0042c896 (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042c85e
    mov ecx, dword ptr [0x5b4ead]                # 0042c862
    movsx edx, word ptr [ecx + field_6f]         # 0042c868
    {load} cmp eax, edx                          # 0042c86c
    jge.d8 L_0042c896                            # 0042c86e
    # block 0x0042c870: entered by fall-through of jge at 0x0042c86e, 7 instruction(s), ends with jne to 0x0042c894 (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042c870
    imul eax, eax, 0x42                          # 0042c874
    mov ecx, dword ptr [0x5b4ea9]                # 0042c877
    movsx edx, word ptr [ecx + eax]              # 0042c87d
    movsx eax, word ptr [0x5bb50b]               # 0042c881
    {load} cmp edx, eax                          # 0042c888
    jne.d8 L_0042c894                            # 0042c88a
    # block 0x0042c88c: entered by fall-through of jne at 0x0042c88a, 2 instruction(s), ends with forward jump to 0x0042c896
    mov word ptr [ebp - local_24], 0x1           # 0042c88c
    jmp.d8 L_0042c896                            # 0042c892
L_0042c894:
    # block 0x0042c894: entered by jne at 0x0042c88a, 1 instruction(s), ends with backward jump to 0x0042c852
    jmp.d8 L_0042c852                            # 0042c894
L_0042c896:
    # block 0x0042c896: entered by jge at 0x0042c86e; jmp at 0x0042c892, 3 instruction(s), ends with je to 0x0042c8e3 (forward)
    movsx ecx, word ptr [ebp - local_24]         # 0042c896
    test ecx, ecx                                # 0042c89a
    je.d8 L_0042c8e3                             # 0042c89c
    # block 0x0042c89e: entered by fall-through of je at 0x0042c89c, 3 instruction(s), ends with je to 0x0042c8d2 (forward)
    movsx edx, word ptr [0x5b4e0a]               # 0042c89e
    test edx, edx                                # 0042c8a5
    je.d8 L_0042c8d2                             # 0042c8a7
    # block 0x0042c8a9: entered by fall-through of je at 0x0042c8a7, 7 instruction(s), calls FUN_0042e72c, FUN_0042ca22, FUN_0042d215, KERNEL32.dll!GetTickCount, falls into the block at 0x0042c8d2
    call FUN_0042e72c                            # 0042c8a9
    call FUN_0042ca22                            # 0042c8ae
    call FUN_0042d215                            # 0042c8b3
    call dword ptr [0x52a23c]                    # 0042c8b8
    add eax, dword ptr [0x5b4c5a]                # 0042c8be
    mov dword ptr [0x5b4dfc], eax                # 0042c8c4
    mov word ptr [0x5b4e0a], 0x0                 # 0042c8c9
L_0042c8d2:
    # block 0x0042c8d2: entered by je at 0x0042c8a7, 6 instruction(s), calls FUN_0042caa8, falls into the block at 0x0042c8e3
    lea eax, [ebp - local_1c]                    # 0042c8d2
    push eax                                     # 0042c8d5
    mov cx, word ptr [ebp - local_20]            # 0042c8d6
    push ecx                                     # 0042c8da
    call FUN_0042caa8                            # 0042c8db
    add esp, 0x8                                 # 0042c8e0
L_0042c8e3:
    # block 0x0042c8e3: entered by je at 0x0042c89c, 1 instruction(s), ends with forward jump to 0x0042c93c
    jmp.d8 L_0042c93c                            # 0042c8e3
L_0042c8e5:
    # block 0x0042c8e5: entered by jb at 0x0042c83e, 2 instruction(s), ends with forward jump to 0x0042c8f9
    mov word ptr [ebp - local_20], 0x0           # 0042c8e5
    jmp.d8 L_0042c8f9                            # 0042c8eb
L_0042c8ed:
    # block 0x0042c8ed: entered by jmp at 0x0042c93a, 3 instruction(s), falls into the block at 0x0042c8f9
    mov dx, word ptr [ebp - local_20]            # 0042c8ed
    add dx, 0x1                                  # 0042c8f1
    mov word ptr [ebp - local_20], dx            # 0042c8f5
L_0042c8f9:
    # block 0x0042c8f9: entered by jmp at 0x0042c8eb, 5 instruction(s), ends with jge to 0x0042c93c (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042c8f9
    mov ecx, dword ptr [0x5b4ead]                # 0042c8fd
    movsx edx, word ptr [ecx + field_6f]         # 0042c903
    {load} cmp eax, edx                          # 0042c907
    jge.d8 L_0042c93c                            # 0042c909
    # block 0x0042c90b: entered by fall-through of jge at 0x0042c909, 7 instruction(s), ends with jne to 0x0042c93a (forward)
    movsx eax, word ptr [ebp - local_20]         # 0042c90b
    imul eax, eax, 0x42                          # 0042c90f
    mov ecx, dword ptr [0x5b4ea9]                # 0042c912
    movsx edx, word ptr [ecx + eax]              # 0042c918
    movsx eax, word ptr [0x5bb50b]               # 0042c91c
    {load} cmp edx, eax                          # 0042c923
    jne.d8 L_0042c93a                            # 0042c925
    # block 0x0042c927: entered by fall-through of jne at 0x0042c925, 7 instruction(s), calls FUN_0042caa8, ends with forward jump to 0x0042c93c
    lea ecx, [ebp - local_1c]                    # 0042c927
    push ecx                                     # 0042c92a
    mov dx, word ptr [ebp - local_20]            # 0042c92b
    push edx                                     # 0042c92f
    call FUN_0042caa8                            # 0042c930
    add esp, 0x8                                 # 0042c935
    jmp.d8 L_0042c93c                            # 0042c938
L_0042c93a:
    # block 0x0042c93a: entered by jne at 0x0042c925, 1 instruction(s), ends with backward jump to 0x0042c8ed
    jmp.d8 L_0042c8ed                            # 0042c93a
L_0042c93c:
    # block 0x0042c93c: entered by jmp at 0x0042c787; jmp at 0x0042c82d; jmp at 0x0042c8e3; jge at 0x0042c909; more, 1 instruction(s), ends with forward jump to 0x0042ca12
    jmp.d32 L_0042ca12                           # 0042c93c
L_0042c941:
    # block 0x0042c941: entered by je at 0x0042c332, 3 instruction(s), ends with jne to 0x0042c951 (forward)
    movsx eax, word ptr [0x5b4e0a]               # 0042c941
    test eax, eax                                # 0042c948
    jne.d8 L_0042c951                            # 0042c94a
    # block 0x0042c94c: entered by fall-through of jne at 0x0042c94a, 1 instruction(s), ends with forward jump to 0x0042ca12
    jmp.d32 L_0042ca12                           # 0042c94c
L_0042c951:
    # block 0x0042c951: entered by jne at 0x0042c94a, 9 instruction(s), ends with jne to 0x0042c990 (forward)
    mov word ptr [0x5b4e89], 0xffff              # 0042c951
    mov word ptr [0x5b4e8b], 0x1                 # 0042c95a
    mov word ptr [0x5b4ea3], 0x1                 # 0042c963
    mov dword ptr [0x5c39f1], 0x0                # 0042c96c
    mov ecx, dword ptr [0x5b4ead]                # 0042c976
    {load} xor edx, edx                          # 0042c97c
    mov dl, byte ptr [ecx + field_6c]            # 0042c97e
    cmp edx, 0x1                                 # 0042c981
    jne.d8 L_0042c990                            # 0042c984
    # block 0x0042c986: entered by fall-through of jne at 0x0042c984, 3 instruction(s), calls FUN_0042e560, falls into the block at 0x0042c990
    push 0x2                                     # 0042c986
    call FUN_0042e560                            # 0042c988
    add esp, 0x4                                 # 0042c98d
L_0042c990:
    # block 0x0042c990: entered by jne at 0x0042c984, 26 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042ca12
    mov eax, dword ptr [0x5b4ead]                # 0042c990
    movsx ecx, word ptr [eax + field_58]         # 0042c995
    mov dword ptr [0x5bb57b], ecx                # 0042c999
    mov edx, dword ptr [0x5b4ead]                # 0042c99f
    mov ax, word ptr [edx + field_5a]            # 0042c9a5
    mov word ptr [0x5bb599], ax                  # 0042c9a9
    mov ecx, dword ptr [0x5b4ead]                # 0042c9af
    mov dx, word ptr [ecx + field_5c]            # 0042c9b5
    mov word ptr [0x5bb595], dx                  # 0042c9b9
    mov eax, dword ptr [0x5b4ead]                # 0042c9c0
    mov cx, word ptr [eax + field_5e]            # 0042c9c5
    mov word ptr [0x5c39ff], cx                  # 0042c9c9
    mov edx, dword ptr [0x5b4ead]                # 0042c9d0
    mov eax, dword ptr [edx + field_60]          # 0042c9d6
    mov dword ptr [0x5bb59b], eax                # 0042c9d9
    mov ecx, dword ptr [0x5b4ead]                # 0042c9de
    mov edx, dword ptr [ecx + field_64]          # 0042c9e4
    mov dword ptr [0x5bb59f], edx                # 0042c9e7
    mov eax, dword ptr [0x5b4ead]                # 0042c9ed
    mov ecx, dword ptr [eax + field_68]          # 0042c9f2
    mov dword ptr [0x5bb5a3], ecx                # 0042c9f5
    mov dword ptr [0x583999], 0x4                # 0042c9fb
    mov dx, word ptr [ebp + arg_8]               # 0042ca05
    push edx                                     # 0042ca09
    call FUN_0042ba3a                            # 0042ca0a
    add esp, 0x4                                 # 0042ca0f
L_0042ca12:
    # block 0x0042ca12: entered by jmp at 0x0042c306; jmp at 0x0042c338; jmp at 0x0042c386; jmp at 0x0042c93c; more, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0042ca12
    mov dword ptr fs:[0x0], ecx                  # 0042ca15
    pop edi                                      # 0042ca1c
    pop esi                                      # 0042ca1d
    {load} mov esp, ebp                          # 0042ca1e
    pop ebp                                      # 0042ca20
    ret                                          # 0042ca21

