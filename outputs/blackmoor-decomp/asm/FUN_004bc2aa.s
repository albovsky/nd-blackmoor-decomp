# FUN_004bc2aa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bc2aa
# extent:       0x004bc2aa-0x004bca71 (1991 code bytes)
# span:         0x004bc2aa-0x004bca71 (code 1991, tables 0, padding 0)
# sha256:       7f276b69555a6d3bf52cdfad3a3546bdc9540e379ebf5a5fef4a96471f509d24
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bc2aa
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_28, local_2c, local_30, local_34 and 6 more
# fields:       [eax + n] field_4, field_8, field_c, field_18, field_50, field_54, field_68, field_6c, field_74, field_d8, field_128, field_130 and 14 more; [ecx + n] field_4, field_8, field_c, field_18, field_34, field_54, field_6c, field_b4, field_b8, field_114, field_130, field_134 and 20 more; [edx + n] field_4, field_8, field_c, field_18, field_30, field_38, field_50, field_54, field_68, field_6c, field_70, field_74 and 23 more; [esi + n] field_8d0, field_8dc
# callees:      calls FUN_0050cd50, FUN_004be18b, FUN_004be367, FUN_0050ca3e, FUN_004bb3de, FUN_0050ce04, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 553 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_d8, 0xd8  # offset +0xd8
.equ field_114, 0x114  # offset +0x114
.equ field_128, 0x128  # offset +0x128
.equ field_130, 0x130  # offset +0x130
.equ field_134, 0x134  # offset +0x134
.equ field_13c, 0x13c  # offset +0x13c
.equ field_140, 0x140  # offset +0x140
.equ field_144, 0x144  # offset +0x144
.equ field_148, 0x148  # offset +0x148
.equ field_168, 0x168  # offset +0x168
.equ field_174, 0x174  # offset +0x174
.equ field_17c, 0x17c  # offset +0x17c
.equ field_184, 0x184  # offset +0x184
.equ field_18c, 0x18c  # offset +0x18c
.equ field_190, 0x190  # offset +0x190
.equ field_1a4, 0x1a4  # offset +0x1a4
.equ field_1a8, 0x1a8  # offset +0x1a8
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1b4, 0x1b4  # offset +0x1b4
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_2f4, 0x2f4  # offset +0x2f4
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fc, 0x2fc  # offset +0x2fc
.equ field_300, 0x300  # offset +0x300
.equ field_304, 0x304  # offset +0x304
.equ field_308, 0x308  # offset +0x308
.equ field_318, 0x318  # offset +0x318
.equ field_354, 0x354  # offset +0x354
.equ field_8cc, 0x8cc  # offset +0x8cc
.equ field_8d0, 0x8d0  # offset +0x8d0
.equ field_8d4, 0x8d4  # offset +0x8d4
.equ field_8d8, 0x8d8  # offset +0x8d8
.equ field_8dc, 0x8dc  # offset +0x8dc
.equ field_8e0, 0x8e0  # offset +0x8e0
.equ field_8f0, 0x8f0  # offset +0x8f0
.equ field_8f4, 0x8f4  # offset +0x8f4
.equ field_8fc, 0x8fc  # offset +0x8fc

# --- external targets -----------------------------------------------
.set FUN_004bb3de, .text + (0x004bb3de - 0x401000)
.set FUN_004be18b, .text + (0x004be18b - 0x401000)
.set FUN_004be367, .text + (0x004be367 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004bc2aa - 0x401000
.globl FUN_004bc2aa
FUN_004bc2aa:
    # block 0x004bc2aa: entry, 11 instruction(s), ends with je to 0x004bc357 (forward)
    push ebp                                     # 004bc2aa
    {load} mov ebp, esp                          # 004bc2ab
    sub esp, 0x50                                # 004bc2ad
    push esi                                     # 004bc2b0
    push edi                                     # 004bc2b1
    mov dword ptr [ebp - local_18], ecx          # 004bc2b2
    mov eax, dword ptr [ebp - local_18]          # 004bc2b5
    mov ecx, dword ptr [eax + field_18]          # 004bc2b8
    movsx edx, byte ptr [ecx + field_8fc]        # 004bc2bb
    test edx, edx                                # 004bc2c2
    je.d32 L_004bc357                            # 004bc2c4
    # block 0x004bc2ca: entered by fall-through of je at 0x004bc2c4, 35 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004bc3d4
    mov eax, dword ptr [ebp - local_18]          # 004bc2ca
    mov ecx, dword ptr [ebp - local_18]          # 004bc2cd
    mov edx, dword ptr [eax + field_184]         # 004bc2d0
    sub edx, dword ptr [ecx + field_18c]         # 004bc2d6
    mov dword ptr [ebp - local_14], edx          # 004bc2dc
    call FUN_0050cd50                            # 004bc2df
    mov ecx, dword ptr [ebp - local_14]          # 004bc2e4
    sub ecx, 0x1                                 # 004bc2e7
    cdq                                          # 004bc2ea
    idiv ecx                                     # 004bc2eb
    mov dword ptr [ebp - local_14], edx          # 004bc2ed
    mov edx, dword ptr [ebp - local_18]          # 004bc2f0
    mov eax, dword ptr [edx + field_d8]          # 004bc2f3
    add eax, dword ptr [ebp - local_14]          # 004bc2f9
    mov ecx, dword ptr [ebp - local_18]          # 004bc2fc
    mov dword ptr [ecx + field_1bc], eax         # 004bc2ff
    mov edx, dword ptr [ebp - local_18]          # 004bc305
    mov eax, dword ptr [edx + field_1bc]         # 004bc308
    mov ecx, dword ptr [ebp - local_18]          # 004bc30e
    mov edx, dword ptr [ecx + field_18c]         # 004bc311
    lea eax, [eax + edx - field_minus_1]         # 004bc317
    mov ecx, dword ptr [ebp - local_18]          # 004bc31b
    mov dword ptr [ecx + field_1c4], eax         # 004bc31e
    mov edx, dword ptr [ebp - local_18]          # 004bc324
    mov eax, dword ptr [ebp - local_18]          # 004bc327
    mov ecx, dword ptr [eax + field_174]         # 004bc32a
    mov dword ptr [edx + field_1c0], ecx         # 004bc330
    mov edx, dword ptr [ebp - local_18]          # 004bc336
    mov eax, dword ptr [edx + field_1c0]         # 004bc339
    mov ecx, dword ptr [ebp - local_18]          # 004bc33f
    mov edx, dword ptr [ecx + field_190]         # 004bc342
    lea eax, [eax + edx - field_minus_1]         # 004bc348
    mov ecx, dword ptr [ebp - local_18]          # 004bc34c
    mov dword ptr [ecx + field_1c8], eax         # 004bc34f
    jmp.d8 L_004bc3d4                            # 004bc355
L_004bc357:
    # block 0x004bc357: entered by je at 0x004bc2c4, 31 instruction(s), falls into the block at 0x004bc3d4
    mov edx, dword ptr [ebp - local_18]          # 004bc357
    mov eax, dword ptr [ebp - local_18]          # 004bc35a
    mov ecx, dword ptr [edx + field_184]         # 004bc35d
    sub ecx, dword ptr [eax + field_18c]         # 004bc363
    {load} mov eax, ecx                          # 004bc369
    cdq                                          # 004bc36b
    {load} sub eax, edx                          # 004bc36c
    sar eax                                      # 004bc36e
    mov edx, dword ptr [ebp - local_18]          # 004bc370
    mov ecx, dword ptr [edx + field_d8]          # 004bc373
    {load} add ecx, eax                          # 004bc379
    mov edx, dword ptr [ebp - local_18]          # 004bc37b
    mov dword ptr [edx + field_1bc], ecx         # 004bc37e
    mov eax, dword ptr [ebp - local_18]          # 004bc384
    mov ecx, dword ptr [eax + field_1bc]         # 004bc387
    mov edx, dword ptr [ebp - local_18]          # 004bc38d
    mov eax, dword ptr [edx + field_18c]         # 004bc390
    lea ecx, [ecx + eax - field_minus_1]         # 004bc396
    mov edx, dword ptr [ebp - local_18]          # 004bc39a
    mov dword ptr [edx + field_1c4], ecx         # 004bc39d
    mov eax, dword ptr [ebp - local_18]          # 004bc3a3
    mov ecx, dword ptr [ebp - local_18]          # 004bc3a6
    mov edx, dword ptr [ecx + field_174]         # 004bc3a9
    mov dword ptr [eax + field_1c0], edx         # 004bc3af
    mov eax, dword ptr [ebp - local_18]          # 004bc3b5
    mov ecx, dword ptr [eax + field_1c0]         # 004bc3b8
    mov edx, dword ptr [ebp - local_18]          # 004bc3be
    mov eax, dword ptr [edx + field_190]         # 004bc3c1
    lea ecx, [ecx + eax - field_minus_1]         # 004bc3c7
    mov edx, dword ptr [ebp - local_18]          # 004bc3cb
    mov dword ptr [edx + field_1c8], ecx         # 004bc3ce
L_004bc3d4:
    # block 0x004bc3d4: entered by jmp at 0x004bc355, 38 instruction(s), calls FUN_004be18b, ends with forward jump to 0x004bc47b
    mov eax, dword ptr [ebp - local_18]          # 004bc3d4
    fild dword ptr [eax + field_1bc]             # 004bc3d7
    mov ecx, dword ptr [ebp - local_18]          # 004bc3dd
    fstp dword ptr [ecx + field_304]             # 004bc3e0
    mov edx, dword ptr [ebp - local_18]          # 004bc3e6
    fild dword ptr [edx + field_1c0]             # 004bc3e9
    mov eax, dword ptr [ebp - local_18]          # 004bc3ef
    fstp dword ptr [eax + field_308]             # 004bc3f2
    mov ecx, dword ptr [ebp - local_18]          # 004bc3f8
    add ecx, 0x1bc                               # 004bc3fb
    mov edx, dword ptr [ebp - local_18]          # 004bc401
    add edx, 0x1cc                               # 004bc404
    mov eax, dword ptr [ecx]                     # 004bc40a
    mov dword ptr [edx], eax                     # 004bc40c
    mov eax, dword ptr [ecx + field_4]           # 004bc40e
    mov dword ptr [edx + field_4], eax           # 004bc411
    mov eax, dword ptr [ecx + field_8]           # 004bc414
    mov dword ptr [edx + field_8], eax           # 004bc417
    mov ecx, dword ptr [ecx + field_c]           # 004bc41a
    mov dword ptr [edx + field_c], ecx           # 004bc41d
    mov edx, dword ptr [ebp - local_18]          # 004bc420
    mov dword ptr [edx + field_1b0], 0x0         # 004bc423
    mov eax, dword ptr [ebp - local_18]          # 004bc42d
    mov dword ptr [eax + field_54], 0x0          # 004bc430
    mov ecx, dword ptr [ebp - local_18]          # 004bc437
    call FUN_004be18b                            # 004bc43a
    mov ecx, dword ptr [ebp - local_18]          # 004bc43f
    mov edx, dword ptr [ecx + field_18]          # 004bc442
    mov eax, dword ptr [ebp - local_18]          # 004bc445
    mov ecx, dword ptr [edx + field_8f0]         # 004bc448
    mov dword ptr [eax + field_1a4], ecx         # 004bc44e
    mov edx, dword ptr [ebp - local_18]          # 004bc454
    mov eax, dword ptr [edx + field_18]          # 004bc457
    mov ecx, dword ptr [ebp - local_18]          # 004bc45a
    mov edx, dword ptr [eax + field_8f4]         # 004bc45d
    mov dword ptr [ecx + field_1a8], edx         # 004bc463
    mov dword ptr [ebp - local_4], 0x0           # 004bc469
    jmp.d8 L_004bc47b                            # 004bc470
L_004bc472:
    # block 0x004bc472: entered by jmp at 0x004bc761, 3 instruction(s), falls into the block at 0x004bc47b
    mov eax, dword ptr [ebp - local_4]           # 004bc472
    add eax, 0x1                                 # 004bc475
    mov dword ptr [ebp - local_4], eax           # 004bc478
L_004bc47b:
    # block 0x004bc47b: entered by jmp at 0x004bc470, 4 instruction(s), ends with jge to 0x004bc766 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004bc47b
    mov edx, dword ptr [ebp - local_4]           # 004bc47e
    cmp edx, dword ptr [ecx + field_1a4]         # 004bc481
    jge.d32 L_004bc766                           # 004bc487
    # block 0x004bc48d: entered by fall-through of jge at 0x004bc487, 209 instruction(s), calls FUN_004be367, FUN_0050ca3e, FUN_0050cd50, FUN_004bb3de, FUN_0050ce04, KERNEL32.dll!GetTickCount, ends with backward jump to 0x004bc472
    mov ecx, dword ptr [ebp - local_18]          # 004bc48d
    call FUN_004be367                            # 004bc490
    mov dword ptr [ebp - local_8], eax           # 004bc495
    mov eax, dword ptr [0x63a8cc]                # 004bc498
    push eax                                     # 004bc49d
    push 0x551f7c                                # 004bc49e
    mov ecx, dword ptr [ebp - local_8]           # 004bc4a3
    push ecx                                     # 004bc4a6
    call FUN_0050ca3e                            # 004bc4a7
    add esp, 0xc                                 # 004bc4ac
    mov edx, dword ptr [ebp - local_8]           # 004bc4af
    mov dword ptr [edx + field_38], 0x0          # 004bc4b2
    call FUN_0050cd50                            # 004bc4b9
    cdq                                          # 004bc4be
    mov ecx, 0x6                                 # 004bc4bf
    idiv ecx                                     # 004bc4c4
    mov dword ptr [ebp - local_c], edx           # 004bc4c6
    mov edx, dword ptr [ebp - local_8]           # 004bc4c9
    mov eax, dword ptr [ebp - local_c]           # 004bc4cc
    mov dword ptr [edx + field_30], eax          # 004bc4cf
    mov ecx, dword ptr [ebp - local_8]           # 004bc4d2
    mov edx, dword ptr [0x63a8cc]                # 004bc4d5
    mov dword ptr [ecx + field_34], edx          # 004bc4db
    mov eax, dword ptr [0x63a8cc]                # 004bc4de
    push eax                                     # 004bc4e3
    mov ecx, dword ptr [ebp - local_c]           # 004bc4e4
    push ecx                                     # 004bc4e7
    push 0x551f84                                # 004bc4e8
    mov edx, dword ptr [ebp - local_8]           # 004bc4ed
    push edx                                     # 004bc4f0
    call FUN_0050ca3e                            # 004bc4f1
    add esp, 0x10                                # 004bc4f6
    mov eax, dword ptr [0x63a8cc]                # 004bc4f9
    add eax, 0x1                                 # 004bc4fe
    mov dword ptr [0x63a8cc], eax                # 004bc501
    mov ecx, dword ptr [ebp - local_18]          # 004bc506
    mov edx, dword ptr [ecx + field_18]          # 004bc509
    mov eax, dword ptr [ebp - local_c]           # 004bc50c
    shl eax, 0x4                                 # 004bc50f
    mov ecx, dword ptr [ebp - local_18]          # 004bc512
    mov ecx, dword ptr [ecx + field_18]          # 004bc515
    mov esi, dword ptr [ebp - local_c]           # 004bc518
    shl esi, 0x4                                 # 004bc51b
    mov edx, dword ptr [edx + eax + field_c0]    # 004bc51e
    sub edx, dword ptr [ecx + esi + field_b8]    # 004bc525
    add edx, 0x1                                 # 004bc52c
    mov eax, dword ptr [ebp - local_8]           # 004bc52f
    mov dword ptr [eax + field_54], edx          # 004bc532
    mov ecx, dword ptr [ebp - local_18]          # 004bc535
    mov edx, dword ptr [ecx + field_18]          # 004bc538
    mov eax, dword ptr [ebp - local_c]           # 004bc53b
    shl eax, 0x4                                 # 004bc53e
    mov ecx, dword ptr [ebp - local_18]          # 004bc541
    mov ecx, dword ptr [ecx + field_18]          # 004bc544
    mov esi, dword ptr [ebp - local_c]           # 004bc547
    shl esi, 0x4                                 # 004bc54a
    mov edx, dword ptr [edx + eax + field_bc]    # 004bc54d
    sub edx, dword ptr [ecx + esi + field_b4]    # 004bc554
    add edx, 0x1                                 # 004bc55b
    mov eax, dword ptr [ebp - local_8]           # 004bc55e
    mov dword ptr [eax + field_50], edx          # 004bc561
    mov ecx, dword ptr [ebp - local_18]          # 004bc564
    mov edx, dword ptr [ecx + field_18]          # 004bc567
    mov eax, dword ptr [ebp - local_c]           # 004bc56a
    shl eax, 0x4                                 # 004bc56d
    lea ecx, [edx + eax + field_b4]              # 004bc570
    mov edx, dword ptr [ebp - local_8]           # 004bc577
    add edx, 0x40                                # 004bc57a
    mov eax, dword ptr [ecx]                     # 004bc57d
    mov dword ptr [edx], eax                     # 004bc57f
    mov eax, dword ptr [ecx + field_4]           # 004bc581
    mov dword ptr [edx + field_4], eax           # 004bc584
    mov eax, dword ptr [ecx + field_8]           # 004bc587
    mov dword ptr [edx + field_8], eax           # 004bc58a
    mov ecx, dword ptr [ecx + field_c]           # 004bc58d
    mov dword ptr [edx + field_c], ecx           # 004bc590
    mov edx, dword ptr [ebp - local_8]           # 004bc593
    add edx, 0x40                                # 004bc596
    mov eax, dword ptr [ebp - local_8]           # 004bc599
    add eax, 0x58                                # 004bc59c
    mov ecx, dword ptr [edx]                     # 004bc59f
    mov dword ptr [eax], ecx                     # 004bc5a1
    mov ecx, dword ptr [edx + field_4]           # 004bc5a3
    mov dword ptr [eax + field_4], ecx           # 004bc5a6
    mov ecx, dword ptr [edx + field_8]           # 004bc5a9
    mov dword ptr [eax + field_8], ecx           # 004bc5ac
    mov edx, dword ptr [edx + field_c]           # 004bc5af
    mov dword ptr [eax + field_c], edx           # 004bc5b2
    mov eax, dword ptr [ebp - local_18]          # 004bc5b5
    mov ecx, dword ptr [eax + field_18]          # 004bc5b8
    mov edx, dword ptr [ebp - local_c]           # 004bc5bb
    imul edx, edx, 0x50                          # 004bc5be
    lea esi, [ecx + edx + field_114]             # 004bc5c1
    mov edi, dword ptr [ebp - local_8]           # 004bc5c8
    add edi, 0x88                                # 004bc5cb
    mov ecx, 0x14                                # 004bc5d1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bc5d6
    call FUN_0050cd50                            # 004bc5d8
    mov ecx, dword ptr [ebp - local_18]          # 004bc5dd
    mov edx, dword ptr [ebp - local_8]           # 004bc5e0
    mov ecx, dword ptr [ecx + field_318]         # 004bc5e3
    sub ecx, dword ptr [edx + field_54]          # 004bc5e9
    cdq                                          # 004bc5ec
    idiv ecx                                     # 004bc5ed
    mov eax, dword ptr [ebp - local_18]          # 004bc5ef
    mov ecx, dword ptr [eax + field_17c]         # 004bc5f2
    {load} add ecx, edx                          # 004bc5f8
    mov edx, dword ptr [ebp - local_8]           # 004bc5fa
    mov dword ptr [edx + field_6c], ecx          # 004bc5fd
    mov eax, dword ptr [ebp - local_8]           # 004bc600
    mov ecx, dword ptr [eax + field_6c]          # 004bc603
    mov edx, dword ptr [ebp - local_8]           # 004bc606
    mov eax, dword ptr [edx + field_54]          # 004bc609
    lea ecx, [ecx + eax - field_minus_1]         # 004bc60c
    mov edx, dword ptr [ebp - local_8]           # 004bc610
    mov dword ptr [edx + field_74], ecx          # 004bc613
    call FUN_0050cd50                            # 004bc616
    mov ecx, dword ptr [ebp - local_18]          # 004bc61b
    mov edx, dword ptr [ebp - local_8]           # 004bc61e
    mov ecx, dword ptr [ecx + field_168]         # 004bc621
    sub ecx, dword ptr [edx + field_50]          # 004bc627
    cdq                                          # 004bc62a
    idiv ecx                                     # 004bc62b
    mov eax, dword ptr [ebp - local_18]          # 004bc62d
    mov ecx, dword ptr [eax + field_d8]          # 004bc630
    {load} add ecx, edx                          # 004bc636
    mov edx, dword ptr [ebp - local_8]           # 004bc638
    mov dword ptr [edx + field_68], ecx          # 004bc63b
    mov eax, dword ptr [ebp - local_8]           # 004bc63e
    mov ecx, dword ptr [eax + field_68]          # 004bc641
    mov edx, dword ptr [ebp - local_8]           # 004bc644
    mov eax, dword ptr [edx + field_50]          # 004bc647
    lea ecx, [ecx + eax - field_minus_1]         # 004bc64a
    mov edx, dword ptr [ebp - local_8]           # 004bc64e
    mov dword ptr [edx + field_70], ecx          # 004bc651
    mov eax, dword ptr [ebp - local_8]           # 004bc654
    fild dword ptr [eax + field_68]              # 004bc657
    mov ecx, dword ptr [ebp - local_8]           # 004bc65a
    fstp dword ptr [ecx + field_144]             # 004bc65d
    mov edx, dword ptr [ebp - local_8]           # 004bc663
    add edx, 0x68                                # 004bc666
    mov eax, dword ptr [ebp - local_8]           # 004bc669
    add eax, 0x78                                # 004bc66c
    mov ecx, dword ptr [edx]                     # 004bc66f
    mov dword ptr [eax], ecx                     # 004bc671
    mov ecx, dword ptr [edx + field_4]           # 004bc673
    mov dword ptr [eax + field_4], ecx           # 004bc676
    mov ecx, dword ptr [edx + field_8]           # 004bc679
    mov dword ptr [eax + field_8], ecx           # 004bc67c
    mov edx, dword ptr [edx + field_c]           # 004bc67f
    mov dword ptr [eax + field_c], edx           # 004bc682
    mov eax, dword ptr [ebp - local_8]           # 004bc685
    mov dword ptr [eax + field_128], 0x0         # 004bc688
    mov ecx, dword ptr [ebp - local_8]           # 004bc692
    push ecx                                     # 004bc695
    mov ecx, dword ptr [ebp - local_18]          # 004bc696
    call FUN_004bb3de                            # 004bc699
    mov edx, dword ptr [ebp - local_18]          # 004bc69e
    mov eax, dword ptr [edx + field_18]          # 004bc6a1
    mov ecx, dword ptr [ebp - local_8]           # 004bc6a4
    mov edx, dword ptr [eax + field_8cc]         # 004bc6a7
    mov dword ptr [ecx + field_130], edx         # 004bc6ad
    mov eax, dword ptr [ebp - local_18]          # 004bc6b3
    mov esi, dword ptr [eax + field_18]          # 004bc6b6
    call FUN_0050cd50                            # 004bc6b9
    {load} mov edi, eax                          # 004bc6be
    mov ecx, dword ptr [ebp - local_18]          # 004bc6c0
    mov edx, dword ptr [ecx + field_18]          # 004bc6c3
    mov eax, dword ptr [ebp - local_18]          # 004bc6c6
    mov ecx, dword ptr [eax + field_18]          # 004bc6c9
    fld dword ptr [edx + field_8d4]              # 004bc6cc
    fsub dword ptr [ecx + field_8d0]             # 004bc6d2
    call FUN_0050ce04                            # 004bc6d8
    {load} mov ecx, eax                          # 004bc6dd
    {load} mov eax, edi                          # 004bc6df
    cdq                                          # 004bc6e1
    idiv ecx                                     # 004bc6e2
    mov dword ptr [ebp - local_1c], edx          # 004bc6e4
    fild dword ptr [ebp - local_1c]              # 004bc6e7
    fstp dword ptr [ebp - local_20]              # 004bc6ea
    fld dword ptr [ebp - local_20]               # 004bc6ed
    fadd dword ptr [esi + field_8d0]             # 004bc6f0
    fstp qword ptr [ebp - local_28]              # 004bc6f6
    call FUN_0050cd50                            # 004bc6f9
    cdq                                          # 004bc6fe
    mov ecx, 0xa                                 # 004bc6ff
    idiv ecx                                     # 004bc704
    mov dword ptr [ebp - local_2c], edx          # 004bc706
    fild dword ptr [ebp - local_2c]              # 004bc709
    fstp dword ptr [ebp - local_30]              # 004bc70c
    fld dword ptr [ebp - local_30]               # 004bc70f
    fdiv qword ptr [0x52e208]                    # 004bc712
    fadd qword ptr [ebp - local_28]              # 004bc718
    mov edx, dword ptr [ebp - local_8]           # 004bc71b
    fstp dword ptr [edx + field_134]             # 004bc71e
    mov eax, dword ptr [ebp - local_8]           # 004bc724
    fild dword ptr [eax + field_130]             # 004bc727
    fstp dword ptr [ebp - local_34]              # 004bc72d
    mov ecx, dword ptr [ebp - local_8]           # 004bc730
    fld dword ptr [ecx + field_134]              # 004bc733
    fdiv dword ptr [ebp - local_34]              # 004bc739
    mov edx, dword ptr [ebp - local_8]           # 004bc73c
    fstp dword ptr [edx + field_148]             # 004bc73f
    mov eax, dword ptr [ebp - local_8]           # 004bc745
    mov dword ptr [eax + field_13c], 0x0         # 004bc748
    call dword ptr [0x52a23c]                    # 004bc752
    mov ecx, dword ptr [ebp - local_8]           # 004bc758
    mov dword ptr [ecx + field_140], eax         # 004bc75b
    jmp.d32 L_004bc472                           # 004bc761
L_004bc766:
    # block 0x004bc766: entered by jge at 0x004bc487, 2 instruction(s), ends with forward jump to 0x004bc778
    mov dword ptr [ebp - local_4], 0x0           # 004bc766
    jmp.d8 L_004bc778                            # 004bc76d
L_004bc76f:
    # block 0x004bc76f: entered by jmp at 0x004bca59, 3 instruction(s), falls into the block at 0x004bc778
    mov edx, dword ptr [ebp - local_4]           # 004bc76f
    add edx, 0x1                                 # 004bc772
    mov dword ptr [ebp - local_4], edx           # 004bc775
L_004bc778:
    # block 0x004bc778: entered by jmp at 0x004bc76d, 4 instruction(s), ends with jge to 0x004bca5e (forward)
    mov eax, dword ptr [ebp - local_18]          # 004bc778
    mov ecx, dword ptr [ebp - local_4]           # 004bc77b
    cmp ecx, dword ptr [eax + field_1a8]         # 004bc77e
    jge.d32 L_004bca5e                           # 004bc784
    # block 0x004bc78a: entered by fall-through of jge at 0x004bc784, 206 instruction(s), calls FUN_004be367, FUN_0050cd50, FUN_0050ca3e, FUN_004bb3de, FUN_0050ce04, KERNEL32.dll!GetTickCount, ends with backward jump to 0x004bc76f
    mov ecx, dword ptr [ebp - local_18]          # 004bc78a
    call FUN_004be367                            # 004bc78d
    mov dword ptr [ebp - local_8], eax           # 004bc792
    mov edx, dword ptr [ebp - local_8]           # 004bc795
    mov dword ptr [edx + field_38], 0x1          # 004bc798
    call FUN_0050cd50                            # 004bc79f
    cdq                                          # 004bc7a4
    mov ecx, 0x6                                 # 004bc7a5
    idiv ecx                                     # 004bc7aa
    mov dword ptr [ebp - local_10], edx          # 004bc7ac
    mov edx, dword ptr [ebp - local_8]           # 004bc7af
    mov eax, dword ptr [ebp - local_10]          # 004bc7b2
    mov dword ptr [edx + field_30], eax          # 004bc7b5
    mov ecx, dword ptr [ebp - local_8]           # 004bc7b8
    mov edx, dword ptr [0x63a8d0]                # 004bc7bb
    mov dword ptr [ecx + field_34], edx          # 004bc7c1
    mov eax, dword ptr [0x63a8d0]                # 004bc7c4
    push eax                                     # 004bc7c9
    mov ecx, dword ptr [ebp - local_10]          # 004bc7ca
    push ecx                                     # 004bc7cd
    push 0x551f90                                # 004bc7ce
    mov edx, dword ptr [ebp - local_8]           # 004bc7d3
    push edx                                     # 004bc7d6
    call FUN_0050ca3e                            # 004bc7d7
    add esp, 0x10                                # 004bc7dc
    mov eax, dword ptr [0x63a8d0]                # 004bc7df
    add eax, 0x1                                 # 004bc7e4
    mov dword ptr [0x63a8d0], eax                # 004bc7e7
    mov ecx, dword ptr [ebp - local_18]          # 004bc7ec
    mov edx, dword ptr [ecx + field_18]          # 004bc7ef
    mov eax, dword ptr [ebp - local_10]          # 004bc7f2
    shl eax, 0x4                                 # 004bc7f5
    mov ecx, dword ptr [ebp - local_18]          # 004bc7f8
    mov ecx, dword ptr [ecx + field_18]          # 004bc7fb
    mov esi, dword ptr [ebp - local_10]          # 004bc7fe
    shl esi, 0x4                                 # 004bc801
    mov edx, dword ptr [edx + eax + field_300]   # 004bc804
    sub edx, dword ptr [ecx + esi + field_2f8]   # 004bc80b
    add edx, 0x1                                 # 004bc812
    mov eax, dword ptr [ebp - local_8]           # 004bc815
    mov dword ptr [eax + field_54], edx          # 004bc818
    mov ecx, dword ptr [ebp - local_18]          # 004bc81b
    mov edx, dword ptr [ecx + field_18]          # 004bc81e
    mov eax, dword ptr [ebp - local_10]          # 004bc821
    shl eax, 0x4                                 # 004bc824
    mov ecx, dword ptr [ebp - local_18]          # 004bc827
    mov ecx, dword ptr [ecx + field_18]          # 004bc82a
    mov esi, dword ptr [ebp - local_10]          # 004bc82d
    shl esi, 0x4                                 # 004bc830
    mov edx, dword ptr [edx + eax + field_2fc]   # 004bc833
    sub edx, dword ptr [ecx + esi + field_2f4]   # 004bc83a
    add edx, 0x1                                 # 004bc841
    mov eax, dword ptr [ebp - local_8]           # 004bc844
    mov dword ptr [eax + field_50], edx          # 004bc847
    mov ecx, dword ptr [ebp - local_18]          # 004bc84a
    mov edx, dword ptr [ecx + field_18]          # 004bc84d
    mov eax, dword ptr [ebp - local_10]          # 004bc850
    shl eax, 0x4                                 # 004bc853
    lea ecx, [edx + eax + field_2f4]             # 004bc856
    mov edx, dword ptr [ebp - local_8]           # 004bc85d
    add edx, 0x40                                # 004bc860
    mov eax, dword ptr [ecx]                     # 004bc863
    mov dword ptr [edx], eax                     # 004bc865
    mov eax, dword ptr [ecx + field_4]           # 004bc867
    mov dword ptr [edx + field_4], eax           # 004bc86a
    mov eax, dword ptr [ecx + field_8]           # 004bc86d
    mov dword ptr [edx + field_8], eax           # 004bc870
    mov ecx, dword ptr [ecx + field_c]           # 004bc873
    mov dword ptr [edx + field_c], ecx           # 004bc876
    mov edx, dword ptr [ebp - local_8]           # 004bc879
    add edx, 0x40                                # 004bc87c
    mov eax, dword ptr [ebp - local_8]           # 004bc87f
    add eax, 0x58                                # 004bc882
    mov ecx, dword ptr [edx]                     # 004bc885
    mov dword ptr [eax], ecx                     # 004bc887
    mov ecx, dword ptr [edx + field_4]           # 004bc889
    mov dword ptr [eax + field_4], ecx           # 004bc88c
    mov ecx, dword ptr [edx + field_8]           # 004bc88f
    mov dword ptr [eax + field_8], ecx           # 004bc892
    mov edx, dword ptr [edx + field_c]           # 004bc895
    mov dword ptr [eax + field_c], edx           # 004bc898
    mov eax, dword ptr [ebp - local_18]          # 004bc89b
    mov ecx, dword ptr [eax + field_18]          # 004bc89e
    mov edx, dword ptr [ebp - local_10]          # 004bc8a1
    imul edx, edx, 0x50                          # 004bc8a4
    lea esi, [ecx + edx + field_354]             # 004bc8a7
    mov edi, dword ptr [ebp - local_8]           # 004bc8ae
    add edi, 0x88                                # 004bc8b1
    mov ecx, 0x14                                # 004bc8b7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bc8bc
    mov eax, dword ptr [ebp - local_18]          # 004bc8be
    mov esi, dword ptr [eax + field_17c]         # 004bc8c1
    mov ecx, dword ptr [ebp - local_18]          # 004bc8c7
    add esi, dword ptr [ecx + field_190]         # 004bc8ca
    call FUN_0050cd50                            # 004bc8d0
    mov edx, dword ptr [ebp - local_18]          # 004bc8d5
    mov ecx, dword ptr [ebp - local_8]           # 004bc8d8
    mov edi, dword ptr [edx + field_318]         # 004bc8db
    sub edi, dword ptr [ecx + field_54]          # 004bc8e1
    mov edx, dword ptr [ebp - local_18]          # 004bc8e4
    sub edi, dword ptr [edx + field_190]         # 004bc8e7
    cdq                                          # 004bc8ed
    idiv edi                                     # 004bc8ee
    {load} add esi, edx                          # 004bc8f0
    mov eax, dword ptr [ebp - local_8]           # 004bc8f2
    mov dword ptr [eax + field_6c], esi          # 004bc8f5
    mov ecx, dword ptr [ebp - local_8]           # 004bc8f8
    mov edx, dword ptr [ecx + field_6c]          # 004bc8fb
    mov eax, dword ptr [ebp - local_8]           # 004bc8fe
    mov ecx, dword ptr [eax + field_54]          # 004bc901
    lea edx, [edx + ecx - field_minus_1]         # 004bc904
    mov eax, dword ptr [ebp - local_8]           # 004bc908
    mov dword ptr [eax + field_74], edx          # 004bc90b
    call FUN_0050cd50                            # 004bc90e
    mov ecx, dword ptr [ebp - local_18]          # 004bc913
    mov edx, dword ptr [ebp - local_8]           # 004bc916
    mov ecx, dword ptr [ecx + field_168]         # 004bc919
    sub ecx, dword ptr [edx + field_50]          # 004bc91f
    cdq                                          # 004bc922
    idiv ecx                                     # 004bc923
    mov eax, dword ptr [ebp - local_18]          # 004bc925
    mov ecx, dword ptr [eax + field_d8]          # 004bc928
    {load} add ecx, edx                          # 004bc92e
    mov edx, dword ptr [ebp - local_8]           # 004bc930
    mov dword ptr [edx + field_68], ecx          # 004bc933
    mov eax, dword ptr [ebp - local_8]           # 004bc936
    mov ecx, dword ptr [eax + field_68]          # 004bc939
    mov edx, dword ptr [ebp - local_8]           # 004bc93c
    mov eax, dword ptr [edx + field_50]          # 004bc93f
    lea ecx, [ecx + eax - field_minus_1]         # 004bc942
    mov edx, dword ptr [ebp - local_8]           # 004bc946
    mov dword ptr [edx + field_70], ecx          # 004bc949
    mov eax, dword ptr [ebp - local_8]           # 004bc94c
    fild dword ptr [eax + field_68]              # 004bc94f
    mov ecx, dword ptr [ebp - local_8]           # 004bc952
    fstp dword ptr [ecx + field_144]             # 004bc955
    mov edx, dword ptr [ebp - local_8]           # 004bc95b
    add edx, 0x68                                # 004bc95e
    mov eax, dword ptr [ebp - local_8]           # 004bc961
    add eax, 0x78                                # 004bc964
    mov ecx, dword ptr [edx]                     # 004bc967
    mov dword ptr [eax], ecx                     # 004bc969
    mov ecx, dword ptr [edx + field_4]           # 004bc96b
    mov dword ptr [eax + field_4], ecx           # 004bc96e
    mov ecx, dword ptr [edx + field_8]           # 004bc971
    mov dword ptr [eax + field_8], ecx           # 004bc974
    mov edx, dword ptr [edx + field_c]           # 004bc977
    mov dword ptr [eax + field_c], edx           # 004bc97a
    mov eax, dword ptr [ebp - local_8]           # 004bc97d
    mov dword ptr [eax + field_128], 0x0         # 004bc980
    mov ecx, dword ptr [ebp - local_8]           # 004bc98a
    push ecx                                     # 004bc98d
    mov ecx, dword ptr [ebp - local_18]          # 004bc98e
    call FUN_004bb3de                            # 004bc991
    mov edx, dword ptr [ebp - local_18]          # 004bc996
    mov eax, dword ptr [edx + field_18]          # 004bc999
    mov ecx, dword ptr [ebp - local_8]           # 004bc99c
    mov edx, dword ptr [eax + field_8d8]         # 004bc99f
    mov dword ptr [ecx + field_130], edx         # 004bc9a5
    mov eax, dword ptr [ebp - local_18]          # 004bc9ab
    mov esi, dword ptr [eax + field_18]          # 004bc9ae
    call FUN_0050cd50                            # 004bc9b1
    {load} mov edi, eax                          # 004bc9b6
    mov ecx, dword ptr [ebp - local_18]          # 004bc9b8
    mov edx, dword ptr [ecx + field_18]          # 004bc9bb
    mov eax, dword ptr [ebp - local_18]          # 004bc9be
    mov ecx, dword ptr [eax + field_18]          # 004bc9c1
    fld dword ptr [edx + field_8e0]              # 004bc9c4
    fsub dword ptr [ecx + field_8dc]             # 004bc9ca
    call FUN_0050ce04                            # 004bc9d0
    {load} mov ecx, eax                          # 004bc9d5
    {load} mov eax, edi                          # 004bc9d7
    cdq                                          # 004bc9d9
    idiv ecx                                     # 004bc9da
    mov dword ptr [ebp - local_38], edx          # 004bc9dc
    fild dword ptr [ebp - local_38]              # 004bc9df
    fstp dword ptr [ebp - local_3c]              # 004bc9e2
    fld dword ptr [ebp - local_3c]               # 004bc9e5
    fadd dword ptr [esi + field_8dc]             # 004bc9e8
    fstp qword ptr [ebp - local_44]              # 004bc9ee
    call FUN_0050cd50                            # 004bc9f1
    cdq                                          # 004bc9f6
    mov ecx, 0xa                                 # 004bc9f7
    idiv ecx                                     # 004bc9fc
    mov dword ptr [ebp - local_48], edx          # 004bc9fe
    fild dword ptr [ebp - local_48]              # 004bca01
    fstp dword ptr [ebp - local_4c]              # 004bca04
    fld dword ptr [ebp - local_4c]               # 004bca07
    fdiv qword ptr [0x52e208]                    # 004bca0a
    fadd qword ptr [ebp - local_44]              # 004bca10
    mov edx, dword ptr [ebp - local_8]           # 004bca13
    fstp dword ptr [edx + field_134]             # 004bca16
    mov eax, dword ptr [ebp - local_8]           # 004bca1c
    fild dword ptr [eax + field_130]             # 004bca1f
    fstp dword ptr [ebp - local_50]              # 004bca25
    mov ecx, dword ptr [ebp - local_8]           # 004bca28
    fld dword ptr [ecx + field_134]              # 004bca2b
    fdiv dword ptr [ebp - local_50]              # 004bca31
    mov edx, dword ptr [ebp - local_8]           # 004bca34
    fstp dword ptr [edx + field_148]             # 004bca37
    mov eax, dword ptr [ebp - local_8]           # 004bca3d
    mov dword ptr [eax + field_13c], 0x0         # 004bca40
    call dword ptr [0x52a23c]                    # 004bca4a
    mov ecx, dword ptr [ebp - local_8]           # 004bca50
    mov dword ptr [ecx + field_140], eax         # 004bca53
    jmp.d32 L_004bc76f                           # 004bca59
L_004bca5e:
    # block 0x004bca5e: entered by jge at 0x004bc784, 7 instruction(s), ends with ret
    mov edx, dword ptr [ebp - local_18]          # 004bca5e
    mov dword ptr [edx + field_1b4], 0x1         # 004bca61
    pop edi                                      # 004bca6b
    pop esi                                      # 004bca6c
    {load} mov esp, ebp                          # 004bca6d
    pop ebp                                      # 004bca6f
    ret                                          # 004bca70

