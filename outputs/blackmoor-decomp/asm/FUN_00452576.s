# FUN_00452576
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00452576
# extent:       0x00452576-0x00453cc6 (5968 code bytes)
# span:         0x00452576-0x00453ce2 (code 5968, tables 28, padding 0)
# sha256:       b2c0d03a096e5c4ef9ea0ae53b2ee2b0326ae83aa736683632b3fd81c8a7340b
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00452576
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_10, field_18, field_1c, field_20, field_21, field_24, field_30, field_48 and 66 more; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_28, field_34, field_40, field_44, field_48 and 63 more; [edx + n] field_4, field_6, field_8, field_c, field_10, field_18, field_1c, field_20, field_2c, field_38, field_3c, field_40 and 68 more
# callees:      calls FUN_004e8d96, FUN_004db870, FUN_0050ca3e, FUN_004547bc, FUN_0044c1a3, FUN_0044c223, FUN_004d39f9, FUN_004c2790, FUN_004516c7, FUN_004fb77a, FUN_004462d3, FUN_00446598, FUN_00446548, FUN_004460d6, FUN_0044655e, FUN_00446532 and 17 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1466 instruction(s), 50 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
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
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a8, 0xa8  # offset +0xa8
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ad, 0xad  # offset +0xad
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b4, 0xb4  # offset +0xb4
.equ field_c4, 0xc4  # offset +0xc4
.equ field_f4, 0xf4  # offset +0xf4
.equ field_f8, 0xf8  # offset +0xf8
.equ field_fc, 0xfc  # offset +0xfc
.equ field_108, 0x108  # offset +0x108
.equ field_10c, 0x10c  # offset +0x10c
.equ field_110, 0x110  # offset +0x110
.equ field_114, 0x114  # offset +0x114
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_178, 0x178  # offset +0x178
.equ field_180, 0x180  # offset +0x180
.equ field_188, 0x188  # offset +0x188
.equ field_18c, 0x18c  # offset +0x18c
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_1a0, 0x1a0  # offset +0x1a0
.equ field_1a4, 0x1a4  # offset +0x1a4
.equ field_1ac, 0x1ac  # offset +0x1ac
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1d0, 0x1d0  # offset +0x1d0
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1dc, 0x1dc  # offset +0x1dc
.equ field_1e0, 0x1e0  # offset +0x1e0
.equ field_1e8, 0x1e8  # offset +0x1e8
.equ field_1ec, 0x1ec  # offset +0x1ec
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_200, 0x200  # offset +0x200
.equ field_204, 0x204  # offset +0x204
.equ field_20c, 0x20c  # offset +0x20c
.equ field_210, 0x210  # offset +0x210
.equ field_218, 0x218  # offset +0x218
.equ field_21c, 0x21c  # offset +0x21c
.equ field_224, 0x224  # offset +0x224
.equ field_228, 0x228  # offset +0x228
.equ field_230, 0x230  # offset +0x230
.equ field_234, 0x234  # offset +0x234
.equ field_23c, 0x23c  # offset +0x23c
.equ field_240, 0x240  # offset +0x240
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_254, 0x254  # offset +0x254
.equ field_26c, 0x26c  # offset +0x26c
.equ field_270, 0x270  # offset +0x270
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_294, 0x294  # offset +0x294
.equ field_2a5, 0x2a5  # offset +0x2a5
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_2a9, 0x2a9  # offset +0x2a9
.equ field_2ad, 0x2ad  # offset +0x2ad
.equ field_2b1, 0x2b1  # offset +0x2b1
.equ field_2b5, 0x2b5  # offset +0x2b5
.equ field_2b9, 0x2b9  # offset +0x2b9
.equ field_2bd, 0x2bd  # offset +0x2bd
.equ field_2c1, 0x2c1  # offset +0x2c1
.equ field_2c5, 0x2c5  # offset +0x2c5
.equ field_2c9, 0x2c9  # offset +0x2c9
.equ field_2cd, 0x2cd  # offset +0x2cd
.equ field_2d1, 0x2d1  # offset +0x2d1
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_2d9, 0x2d9  # offset +0x2d9
.equ field_2dd, 0x2dd  # offset +0x2dd
.equ field_2e1, 0x2e1  # offset +0x2e1
.equ field_2e5, 0x2e5  # offset +0x2e5
.equ field_2e9, 0x2e9  # offset +0x2e9
.equ field_2ed, 0x2ed  # offset +0x2ed
.equ field_2f1, 0x2f1  # offset +0x2f1
.equ field_2f5, 0x2f5  # offset +0x2f5
.equ field_2f9, 0x2f9  # offset +0x2f9
.equ field_2fd, 0x2fd  # offset +0x2fd
.equ field_302, 0x302  # offset +0x302
.equ field_303, 0x303  # offset +0x303
.equ field_304, 0x304  # offset +0x304
.equ field_305, 0x305  # offset +0x305
.equ field_309, 0x309  # offset +0x309
.equ field_30d, 0x30d  # offset +0x30d
.equ field_311, 0x311  # offset +0x311
.equ field_33c, 0x33c  # offset +0x33c
.equ field_340, 0x340  # offset +0x340
.equ field_34c, 0x34c  # offset +0x34c
.equ field_350, 0x350  # offset +0x350
.equ field_354, 0x354  # offset +0x354
.equ field_358, 0x358  # offset +0x358
.equ field_35c, 0x35c  # offset +0x35c
.equ field_360, 0x360  # offset +0x360
.equ field_404, 0x404  # offset +0x404
.equ field_408, 0x408  # offset +0x408
.equ field_40c, 0x40c  # offset +0x40c
.equ field_410, 0x410  # offset +0x410
.equ field_414, 0x414  # offset +0x414
.equ field_418, 0x418  # offset +0x418
.equ field_46c, 0x46c  # offset +0x46c
.equ field_46e, 0x46e  # offset +0x46e
.equ field_470, 0x470  # offset +0x470
.equ field_472, 0x472  # offset +0x472
.equ field_474, 0x474  # offset +0x474
.equ field_478, 0x478  # offset +0x478
.equ field_47c, 0x47c  # offset +0x47c
.equ field_480, 0x480  # offset +0x480
.equ field_482, 0x482  # offset +0x482
.equ field_484, 0x484  # offset +0x484
.equ field_4cc, 0x4cc  # offset +0x4cc
.equ field_4d0, 0x4d0  # offset +0x4d0
.equ field_4d4, 0x4d4  # offset +0x4d4
.equ field_4d8, 0x4d8  # offset +0x4d8
.equ field_4dc, 0x4dc  # offset +0x4dc
.equ field_4e0, 0x4e0  # offset +0x4e0
.equ field_4e8, 0x4e8  # offset +0x4e8
.equ field_4f0, 0x4f0  # offset +0x4f0
.equ field_4f4, 0x4f4  # offset +0x4f4
.equ field_4f8, 0x4f8  # offset +0x4f8
.equ field_4fc, 0x4fc  # offset +0x4fc
.equ field_500, 0x500  # offset +0x500
.equ field_504, 0x504  # offset +0x504
.equ field_508, 0x508  # offset +0x508
.equ field_510, 0x510  # offset +0x510
.equ field_514, 0x514  # offset +0x514
.equ field_518, 0x518  # offset +0x518
.equ field_51c, 0x51c  # offset +0x51c
.equ field_520, 0x520  # offset +0x520
.equ field_524, 0x524  # offset +0x524
.equ field_528, 0x528  # offset +0x528
.equ field_53c, 0x53c  # offset +0x53c
.equ field_540, 0x540  # offset +0x540
.equ field_548, 0x548  # offset +0x548
.equ field_54c, 0x54c  # offset +0x54c
.equ field_666, 0x666  # offset +0x666

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00445f53, .text + (0x00445f53 - 0x401000)
.set FUN_00445fc5, .text + (0x00445fc5 - 0x401000)
.set FUN_004460d6, .text + (0x004460d6 - 0x401000)
.set FUN_004462d3, .text + (0x004462d3 - 0x401000)
.set FUN_00446532, .text + (0x00446532 - 0x401000)
.set FUN_00446548, .text + (0x00446548 - 0x401000)
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_00446598, .text + (0x00446598 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c1a3, .text + (0x0044c1a3 - 0x401000)
.set FUN_0044c223, .text + (0x0044c223 - 0x401000)
.set FUN_0044f996, .text + (0x0044f996 - 0x401000)
.set FUN_0044fc9b, .text + (0x0044fc9b - 0x401000)
.set FUN_0044ffa3, .text + (0x0044ffa3 - 0x401000)
.set FUN_004516c7, .text + (0x004516c7 - 0x401000)
.set FUN_004524a8, .text + (0x004524a8 - 0x401000)
.set FUN_00453ce2, .text + (0x00453ce2 - 0x401000)
.set FUN_004545b0, .text + (0x004545b0 - 0x401000)
.set FUN_0045468e, .text + (0x0045468e - 0x401000)
.set FUN_004547bc, .text + (0x004547bc - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00452576 - 0x401000
.globl FUN_00452576
FUN_00452576:
    # block 0x00452576: entry, 17 instruction(s), ends with je to 0x004525c9 (forward)
    push ebp                                     # 00452576
    {load} mov ebp, esp                          # 00452577
    sub esp, 0x20                                # 00452579
    push esi                                     # 0045257c
    push edi                                     # 0045257d
    mov dword ptr [ebp - local_4], ecx           # 0045257e
    movsx eax, word ptr [ebp + arg_8]            # 00452581
    imul eax, eax, 0x8d                          # 00452585
    mov ecx, dword ptr [ebp - local_4]           # 0045258b
    mov edx, dword ptr [eax + 0x5bb5e5]          # 0045258e
    mov dword ptr [ecx + field_8], edx           # 00452594
    movsx eax, word ptr [ebp + arg_8]            # 00452597
    imul eax, eax, 0x8d                          # 0045259b
    mov ecx, dword ptr [eax + 0x5bb632]          # 004525a1
    mov dword ptr [ebp - local_8], ecx           # 004525a7
    cmp dword ptr [ebp - local_8], 0x0           # 004525aa
    je.d8 L_004525c9                             # 004525ae
    # block 0x004525b0: entered by fall-through of je at 0x004525ae, 2 instruction(s), ends with je to 0x0045360a (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004525b0
    je.d32 L_0045360a                            # 004525b4
    # block 0x004525ba: entered by fall-through of je at 0x004525b4, 2 instruction(s), ends with je to 0x00453a12 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004525ba
    je.d32 L_00453a12                            # 004525be
    # block 0x004525c4: entered by fall-through of je at 0x004525be, 1 instruction(s), ends with forward jump to 0x00453c6e
    jmp.d32 L_00453c6e                           # 004525c4
L_004525c9:
    # block 0x004525c9: entered by je at 0x004525ae, 13 instruction(s), calls FUN_004e8d96, ends with je to 0x0045260d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004525c9
    mov ax, word ptr [ebp + arg_8]               # 004525cc
    mov word ptr [edx + field_6], ax             # 004525d0
    mov ecx, dword ptr [ebp - local_4]           # 004525d4
    mov dword ptr [ecx + field_14], 0x1          # 004525d7
    mov dword ptr [0x5bb1ca], 0x1                # 004525de
    mov ecx, 0x571442                            # 004525e8
    call FUN_004e8d96                            # 004525ed
    mov edx, dword ptr [ebp - local_4]           # 004525f2
    mov eax, dword ptr [edx + field_8]           # 004525f5
    movsx ecx, byte ptr [eax + field_304]        # 004525f8
    test ecx, ecx                                # 004525ff
    je.d8 L_0045260d                             # 00452601
    # block 0x00452603: entered by fall-through of je at 0x00452601, 2 instruction(s), calls FUN_004db870, falls into the block at 0x0045260d
    mov ecx, 0x5830ce                            # 00452603
    call FUN_004db870                            # 00452608
L_0045260d:
    # block 0x0045260d: entered by je at 0x00452601, 47 instruction(s), ends with jg to 0x004526e3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045260d
    add edx, 0x34c                               # 00452610
    mov eax, dword ptr [0x583186]                # 00452616
    mov dword ptr [edx], eax                     # 0045261b
    mov ecx, dword ptr [0x58318a]                # 0045261d
    mov dword ptr [edx + field_4], ecx           # 00452623
    mov eax, dword ptr [0x58318e]                # 00452626
    mov dword ptr [edx + field_8], eax           # 0045262b
    mov ecx, dword ptr [0x583192]                # 0045262e
    mov dword ptr [edx + field_c], ecx           # 00452634
    mov edx, dword ptr [ebp - local_4]           # 00452637
    mov eax, dword ptr [ebp - local_4]           # 0045263a
    mov ecx, dword ptr [edx + field_354]         # 0045263d
    sub ecx, dword ptr [eax + field_34c]         # 00452643
    add ecx, 0x1                                 # 00452649
    mov edx, dword ptr [ebp - local_4]           # 0045264c
    mov dword ptr [edx + field_35c], ecx         # 0045264f
    mov eax, dword ptr [ebp - local_4]           # 00452655
    mov ecx, dword ptr [ebp - local_4]           # 00452658
    mov edx, dword ptr [eax + field_358]         # 0045265b
    sub edx, dword ptr [ecx + field_350]         # 00452661
    add edx, 0x1                                 # 00452667
    mov eax, dword ptr [ebp - local_4]           # 0045266a
    mov dword ptr [eax + field_360], edx         # 0045266d
    mov ecx, dword ptr [ebp - local_4]           # 00452673
    mov edx, dword ptr [ecx + field_8]           # 00452676
    mov eax, dword ptr [ebp - local_4]           # 00452679
    mov ecx, dword ptr [eax + field_8]           # 0045267c
    mov edx, dword ptr [edx + field_2b1]         # 0045267f
    sub edx, dword ptr [ecx + field_2a9]         # 00452685
    add edx, 0x1                                 # 0045268b
    mov eax, dword ptr [ebp - local_4]           # 0045268e
    mov dword ptr [eax + field_8c], edx          # 00452691
    mov ecx, dword ptr [ebp - local_4]           # 00452697
    mov edx, dword ptr [ecx + field_8]           # 0045269a
    mov eax, dword ptr [ebp - local_4]           # 0045269d
    mov ecx, dword ptr [eax + field_8]           # 004526a0
    mov edx, dword ptr [edx + field_2b5]         # 004526a3
    sub edx, dword ptr [ecx + field_2ad]         # 004526a9
    add edx, 0x1                                 # 004526af
    mov eax, dword ptr [ebp - local_4]           # 004526b2
    mov dword ptr [eax + field_90], edx          # 004526b5
    mov ecx, dword ptr [ebp - local_4]           # 004526bb
    mov edx, dword ptr [ebp - local_4]           # 004526be
    mov eax, dword ptr [ecx + field_8c]          # 004526c1
    cmp eax, dword ptr [edx + field_35c]         # 004526c7
    jg.d8 L_004526e3                             # 004526cd
    # block 0x004526cf: entered by fall-through of jg at 0x004526cd, 5 instruction(s), ends with jle to 0x0045270e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004526cf
    mov edx, dword ptr [ebp - local_4]           # 004526d2
    mov eax, dword ptr [ecx + field_90]          # 004526d5
    cmp eax, dword ptr [edx + field_360]         # 004526db
    jle.d8 L_0045270e                            # 004526e1
L_004526e3:
    # block 0x004526e3: entered by jg at 0x004526cd; fall-through of jle at 0x004526e1, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00453cbc
    mov ecx, dword ptr [ebp - local_4]           # 004526e3
    mov edx, dword ptr [ecx + field_90]          # 004526e6
    push edx                                     # 004526ec
    mov eax, dword ptr [ebp - local_4]           # 004526ed
    mov ecx, dword ptr [eax + field_8c]          # 004526f0
    push ecx                                     # 004526f6
    push 0x549b28                                # 004526f7
    push 0x63888b                                # 004526fc
    call FUN_0050ca3e                            # 00452701
    add esp, 0x10                                # 00452706
    jmp.d32 L_00453cbc                           # 00452709
L_0045270e:
    # block 0x0045270e: entered by jle at 0x004526e1, 5 instruction(s), ends with jne to 0x004527aa (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045270e
    mov eax, dword ptr [ebp - local_4]           # 00452711
    mov ecx, dword ptr [edx + field_8c]          # 00452714
    cmp ecx, dword ptr [eax + field_35c]         # 0045271a
    jne.d32 L_004527aa                           # 00452720
    # block 0x00452726: entered by fall-through of jne at 0x00452720, 5 instruction(s), ends with jne to 0x004527aa (forward)
    mov edx, dword ptr [ebp - local_4]           # 00452726
    mov eax, dword ptr [ebp - local_4]           # 00452729
    mov ecx, dword ptr [edx + field_90]          # 0045272c
    cmp ecx, dword ptr [eax + field_360]         # 00452732
    jne.d8 L_004527aa                            # 00452738
    # block 0x0045273a: entered by fall-through of jne at 0x00452738, 31 instruction(s), ends with forward jump to 0x004528d3
    mov edx, dword ptr [ebp - local_4]           # 0045273a
    add edx, 0x34c                               # 0045273d
    mov eax, dword ptr [ebp - local_4]           # 00452743
    add eax, 0x3c                                # 00452746
    mov ecx, dword ptr [edx]                     # 00452749
    mov dword ptr [eax], ecx                     # 0045274b
    mov ecx, dword ptr [edx + field_4]           # 0045274d
    mov dword ptr [eax + field_4], ecx           # 00452750
    mov ecx, dword ptr [edx + field_8]           # 00452753
    mov dword ptr [eax + field_8], ecx           # 00452756
    mov edx, dword ptr [edx + field_c]           # 00452759
    mov dword ptr [eax + field_c], edx           # 0045275c
    mov eax, dword ptr [ebp - local_4]           # 0045275f
    mov dword ptr [eax + field_50], 0x0          # 00452762
    mov ecx, dword ptr [ebp - local_4]           # 00452769
    mov dword ptr [ecx + field_4c], 0x0          # 0045276c
    mov edx, dword ptr [ebp - local_4]           # 00452773
    mov eax, dword ptr [edx + field_4c]          # 00452776
    mov ecx, dword ptr [ebp - local_4]           # 00452779
    mov edx, dword ptr [ecx + field_8c]          # 0045277c
    lea eax, [eax + edx - field_minus_1]         # 00452782
    mov ecx, dword ptr [ebp - local_4]           # 00452786
    mov dword ptr [ecx + field_54], eax          # 00452789
    mov edx, dword ptr [ebp - local_4]           # 0045278c
    mov eax, dword ptr [edx + field_50]          # 0045278f
    mov ecx, dword ptr [ebp - local_4]           # 00452792
    mov edx, dword ptr [ecx + field_90]          # 00452795
    lea eax, [eax + edx - field_minus_1]         # 0045279b
    mov ecx, dword ptr [ebp - local_4]           # 0045279f
    mov dword ptr [ecx + field_58], eax          # 004527a2
    jmp.d32 L_004528d3                           # 004527a5
L_004527aa:
    # block 0x004527aa: entered by jne at 0x00452720; jne at 0x00452738, 8 instruction(s), ends with jg to 0x004527ea (forward)
    mov edx, dword ptr [ebp - local_4]           # 004527aa
    mov eax, dword ptr [edx + field_8]           # 004527ad
    mov ecx, dword ptr [ebp - local_4]           # 004527b0
    mov edx, dword ptr [ecx + field_8c]          # 004527b3
    add edx, dword ptr [eax + field_2b9]         # 004527b9
    mov eax, dword ptr [ebp - local_4]           # 004527bf
    cmp edx, dword ptr [eax + field_35c]         # 004527c2
    jg.d8 L_004527ea                             # 004527c8
    # block 0x004527ca: entered by fall-through of jg at 0x004527c8, 8 instruction(s), ends with jle to 0x00452815 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004527ca
    mov edx, dword ptr [ecx + field_8]           # 004527cd
    mov eax, dword ptr [ebp - local_4]           # 004527d0
    mov ecx, dword ptr [eax + field_90]          # 004527d3
    add ecx, dword ptr [edx + field_2bd]         # 004527d9
    mov edx, dword ptr [ebp - local_4]           # 004527df
    cmp ecx, dword ptr [edx + field_360]         # 004527e2
    jle.d8 L_00452815                            # 004527e8
L_004527ea:
    # block 0x004527ea: entered by jg at 0x004527c8; fall-through of jle at 0x004527e8, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00453cba
    mov eax, dword ptr [ebp - local_4]           # 004527ea
    mov ecx, dword ptr [eax + field_90]          # 004527ed
    push ecx                                     # 004527f3
    mov edx, dword ptr [ebp - local_4]           # 004527f4
    mov eax, dword ptr [edx + field_8c]          # 004527f7
    push eax                                     # 004527fd
    push 0x549b8c                                # 004527fe
    push 0x63888b                                # 00452803
    call FUN_0050ca3e                            # 00452808
    add esp, 0x10                                # 0045280d
    jmp.d32 L_00453cba                           # 00452810
L_00452815:
    # block 0x00452815: entered by jle at 0x004527e8, 52 instruction(s), falls into the block at 0x004528d3
    mov ecx, dword ptr [ebp - local_4]           # 00452815
    mov edx, dword ptr [ecx + field_8]           # 00452818
    mov eax, dword ptr [ebp - local_4]           # 0045281b
    mov ecx, dword ptr [eax + field_34c]         # 0045281e
    add ecx, dword ptr [edx + field_2b9]         # 00452824
    mov edx, dword ptr [ebp - local_4]           # 0045282a
    mov dword ptr [edx + field_3c], ecx          # 0045282d
    mov eax, dword ptr [ebp - local_4]           # 00452830
    mov ecx, dword ptr [eax + field_8]           # 00452833
    mov edx, dword ptr [ebp - local_4]           # 00452836
    mov eax, dword ptr [edx + field_350]         # 00452839
    add eax, dword ptr [ecx + field_2bd]         # 0045283f
    mov ecx, dword ptr [ebp - local_4]           # 00452845
    mov dword ptr [ecx + field_40], eax          # 00452848
    mov edx, dword ptr [ebp - local_4]           # 0045284b
    mov eax, dword ptr [edx + field_3c]          # 0045284e
    mov ecx, dword ptr [ebp - local_4]           # 00452851
    mov edx, dword ptr [ecx + field_8c]          # 00452854
    lea eax, [eax + edx - field_minus_1]         # 0045285a
    mov ecx, dword ptr [ebp - local_4]           # 0045285e
    mov dword ptr [ecx + field_44], eax          # 00452861
    mov edx, dword ptr [ebp - local_4]           # 00452864
    mov eax, dword ptr [edx + field_40]          # 00452867
    mov ecx, dword ptr [ebp - local_4]           # 0045286a
    mov edx, dword ptr [ecx + field_90]          # 0045286d
    lea eax, [eax + edx - field_minus_1]         # 00452873
    mov ecx, dword ptr [ebp - local_4]           # 00452877
    mov dword ptr [ecx + field_48], eax          # 0045287a
    mov edx, dword ptr [ebp - local_4]           # 0045287d
    mov eax, dword ptr [edx + field_8]           # 00452880
    mov ecx, dword ptr [ebp - local_4]           # 00452883
    mov edx, dword ptr [eax + field_2b9]         # 00452886
    mov dword ptr [ecx + field_4c], edx          # 0045288c
    mov eax, dword ptr [ebp - local_4]           # 0045288f
    mov ecx, dword ptr [eax + field_8]           # 00452892
    mov edx, dword ptr [ebp - local_4]           # 00452895
    mov eax, dword ptr [ecx + field_2bd]         # 00452898
    mov dword ptr [edx + field_50], eax          # 0045289e
    mov ecx, dword ptr [ebp - local_4]           # 004528a1
    mov edx, dword ptr [ecx + field_4c]          # 004528a4
    mov eax, dword ptr [ebp - local_4]           # 004528a7
    mov ecx, dword ptr [eax + field_8c]          # 004528aa
    lea edx, [edx + ecx - field_minus_1]         # 004528b0
    mov eax, dword ptr [ebp - local_4]           # 004528b4
    mov dword ptr [eax + field_54], edx          # 004528b7
    mov ecx, dword ptr [ebp - local_4]           # 004528ba
    mov edx, dword ptr [ecx + field_50]          # 004528bd
    mov eax, dword ptr [ebp - local_4]           # 004528c0
    mov ecx, dword ptr [eax + field_90]          # 004528c3
    lea edx, [edx + ecx - field_minus_1]         # 004528c9
    mov eax, dword ptr [ebp - local_4]           # 004528cd
    mov dword ptr [eax + field_58], edx          # 004528d0
L_004528d3:
    # block 0x004528d3: entered by jmp at 0x004527a5, 12 instruction(s), ends with jge to 0x00452920 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004528d3
    mov edx, dword ptr [ecx + field_8]           # 004528d6
    mov eax, dword ptr [ebp - local_4]           # 004528d9
    mov ecx, dword ptr [eax + field_48]          # 004528dc
    sub ecx, dword ptr [edx + field_2d9]         # 004528df
    mov edx, dword ptr [ebp - local_4]           # 004528e5
    mov dword ptr [edx + field_a0], ecx          # 004528e8
    mov eax, dword ptr [ebp - local_4]           # 004528ee
    mov ecx, dword ptr [ebp - local_4]           # 004528f1
    mov edx, dword ptr [eax + field_a0]          # 004528f4
    cmp edx, dword ptr [ecx + field_40]          # 004528fa
    jge.d8 L_00452920                            # 004528fd
    # block 0x004528ff: entered by fall-through of jge at 0x004528fd, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00453cb8
    mov eax, dword ptr [ebp - local_4]           # 004528ff
    mov ecx, dword ptr [eax + field_a0]          # 00452902
    push ecx                                     # 00452908
    push 0x549bfc                                # 00452909
    push 0x63888b                                # 0045290e
    call FUN_0050ca3e                            # 00452913
    add esp, 0xc                                 # 00452918
    jmp.d32 L_00453cb8                           # 0045291b
L_00452920:
    # block 0x00452920: entered by jge at 0x004528fd, 136 instruction(s), calls FUN_004547bc, ends with forward jump to 0x00452b53
    mov edx, dword ptr [ebp - local_4]           # 00452920
    mov eax, dword ptr [edx + field_8]           # 00452923
    add eax, 0x95                                # 00452926
    mov ecx, dword ptr [ebp - local_4]           # 0045292b
    add ecx, 0x2c                                # 0045292e
    mov edx, dword ptr [eax]                     # 00452931
    mov dword ptr [ecx], edx                     # 00452933
    mov edx, dword ptr [eax + field_4]           # 00452935
    mov dword ptr [ecx + field_4], edx           # 00452938
    mov edx, dword ptr [eax + field_8]           # 0045293b
    mov dword ptr [ecx + field_8], edx           # 0045293e
    mov eax, dword ptr [eax + field_c]           # 00452941
    mov dword ptr [ecx + field_c], eax           # 00452944
    mov ecx, dword ptr [ebp - local_4]           # 00452947
    mov edx, dword ptr [ebp - local_4]           # 0045294a
    mov eax, dword ptr [ecx + field_34]          # 0045294d
    sub eax, dword ptr [edx + field_2c]          # 00452950
    add eax, 0x1                                 # 00452953
    mov ecx, dword ptr [ebp - local_4]           # 00452956
    mov dword ptr [ecx + field_94], eax          # 00452959
    mov edx, dword ptr [ebp - local_4]           # 0045295f
    mov eax, dword ptr [ebp - local_4]           # 00452962
    mov ecx, dword ptr [edx + field_38]          # 00452965
    sub ecx, dword ptr [eax + field_30]          # 00452968
    add ecx, 0x1                                 # 0045296b
    mov edx, dword ptr [ebp - local_4]           # 0045296e
    mov dword ptr [edx + field_98], ecx          # 00452971
    mov eax, dword ptr [ebp - local_4]           # 00452977
    mov eax, dword ptr [eax + field_94]          # 0045297a
    cdq                                          # 00452980
    {load} sub eax, edx                          # 00452981
    sar eax                                      # 00452983
    mov ecx, dword ptr [ebp - local_4]           # 00452985
    mov dword ptr [ecx + field_9c], eax          # 00452988
    mov edx, dword ptr [ebp - local_4]           # 0045298e
    mov eax, dword ptr [edx + field_8]           # 00452991
    add eax, 0x85                                # 00452994
    mov ecx, dword ptr [ebp - local_4]           # 00452999
    add ecx, 0x108                               # 0045299c
    mov edx, dword ptr [eax]                     # 004529a2
    mov dword ptr [ecx], edx                     # 004529a4
    mov edx, dword ptr [eax + field_4]           # 004529a6
    mov dword ptr [ecx + field_4], edx           # 004529a9
    mov edx, dword ptr [eax + field_8]           # 004529ac
    mov dword ptr [ecx + field_8], edx           # 004529af
    mov eax, dword ptr [eax + field_c]           # 004529b2
    mov dword ptr [ecx + field_c], eax           # 004529b5
    mov ecx, dword ptr [ebp - local_4]           # 004529b8
    mov edx, dword ptr [ebp - local_4]           # 004529bb
    mov eax, dword ptr [ecx + field_110]         # 004529be
    sub eax, dword ptr [edx + field_108]         # 004529c4
    add eax, 0x1                                 # 004529ca
    mov ecx, dword ptr [ebp - local_4]           # 004529cd
    mov dword ptr [ecx + field_164], eax         # 004529d0
    mov edx, dword ptr [ebp - local_4]           # 004529d6
    mov eax, dword ptr [ebp - local_4]           # 004529d9
    mov ecx, dword ptr [edx + field_114]         # 004529dc
    sub ecx, dword ptr [eax + field_10c]         # 004529e2
    add ecx, 0x1                                 # 004529e8
    mov edx, dword ptr [ebp - local_4]           # 004529eb
    mov dword ptr [edx + field_168], ecx         # 004529ee
    mov eax, dword ptr [ebp - local_4]           # 004529f4
    mov eax, dword ptr [eax + field_164]         # 004529f7
    cdq                                          # 004529fd
    {load} sub eax, edx                          # 004529fe
    sar eax                                      # 00452a00
    mov ecx, dword ptr [ebp - local_4]           # 00452a02
    mov dword ptr [ecx + field_16c], eax         # 00452a05
    mov edx, dword ptr [ebp - local_4]           # 00452a0b
    mov eax, dword ptr [edx + field_168]         # 00452a0e
    cdq                                          # 00452a14
    {load} sub eax, edx                          # 00452a15
    sar eax                                      # 00452a17
    mov ecx, dword ptr [ebp - local_4]           # 00452a19
    mov dword ptr [ecx + field_170], eax         # 00452a1c
    mov edx, dword ptr [ebp - local_4]           # 00452a22
    mov eax, dword ptr [edx + field_8]           # 00452a25
    mov ecx, dword ptr [ebp - local_4]           # 00452a28
    mov edx, dword ptr [eax + field_2dd]         # 00452a2b
    mov dword ptr [ecx + field_4f4], edx         # 00452a31
    mov eax, dword ptr [ebp - local_4]           # 00452a37
    mov ecx, dword ptr [eax + field_8]           # 00452a3a
    mov edx, dword ptr [ebp - local_4]           # 00452a3d
    mov eax, dword ptr [ecx + field_2e1]         # 00452a40
    mov dword ptr [edx + field_4f8], eax         # 00452a46
    mov ecx, dword ptr [ebp - local_4]           # 00452a4c
    mov edx, dword ptr [ecx + field_8]           # 00452a4f
    mov eax, dword ptr [ebp - local_4]           # 00452a52
    mov ecx, dword ptr [edx + field_2e5]         # 00452a55
    mov dword ptr [eax + field_4fc], ecx         # 00452a5b
    mov edx, dword ptr [ebp - local_4]           # 00452a61
    mov eax, dword ptr [edx + field_94]          # 00452a64
    imul eax, eax, 0x18                          # 00452a6a
    push eax                                     # 00452a6d
    mov ecx, dword ptr [ebp - local_4]           # 00452a6e
    add ecx, 0x51c                               # 00452a71
    push ecx                                     # 00452a77
    mov ecx, dword ptr [ebp - local_4]           # 00452a78
    call FUN_004547bc                            # 00452a7b
    mov edx, dword ptr [ebp - local_4]           # 00452a80
    mov eax, dword ptr [edx + field_8]           # 00452a83
    fild dword ptr [eax + field_2fd]             # 00452a86
    fstp dword ptr [ebp - local_c]               # 00452a8c
    mov ecx, dword ptr [ebp - local_4]           # 00452a8f
    mov edx, dword ptr [ecx + field_8]           # 00452a92
    fild dword ptr [edx + field_2f9]             # 00452a95
    fstp dword ptr [ebp - local_10]              # 00452a9b
    fld dword ptr [ebp - local_c]                # 00452a9e
    fsub dword ptr [ebp - local_10]              # 00452aa1
    mov eax, dword ptr [ebp - local_4]           # 00452aa4
    fild dword ptr [eax + field_9c]              # 00452aa7
    fstp dword ptr [ebp - local_14]              # 00452aad
    fdiv dword ptr [ebp - local_14]              # 00452ab0
    mov ecx, dword ptr [ebp - local_4]           # 00452ab3
    fstp dword ptr [ecx + field_520]             # 00452ab6
    mov edx, dword ptr [ebp - local_4]           # 00452abc
    mov dword ptr [edx + field_524], 0x3f800000  # 00452abf
    mov eax, dword ptr [ebp - local_4]           # 00452ac9
    mov dword ptr [eax + field_528], 0x0         # 00452acc
    mov ecx, dword ptr [ebp - local_4]           # 00452ad6
    mov dword ptr [ecx + field_53c], 0x0         # 00452ad9
    mov edx, dword ptr [ebp - local_4]           # 00452ae3
    mov dword ptr [edx + field_540], 0x3f800000  # 00452ae6
    mov eax, dword ptr [ebp - local_4]           # 00452af0
    mov ecx, dword ptr [eax + field_8]           # 00452af3
    fild dword ptr [ecx + field_2f9]             # 00452af6
    mov edx, dword ptr [ebp - local_4]           # 00452afc
    fstp dword ptr [edx + field_518]             # 00452aff
    mov eax, dword ptr [ebp - local_4]           # 00452b05
    mov dword ptr [eax + field_510], 0x0         # 00452b08
    mov ecx, dword ptr [ebp - local_4]           # 00452b12
    mov edx, dword ptr [ecx + field_94]          # 00452b15
    sub edx, 0x1                                 # 00452b1b
    mov eax, dword ptr [ebp - local_4]           # 00452b1e
    mov dword ptr [eax + field_514], edx         # 00452b21
    jmp.d8 L_00452b53                            # 00452b27
L_00452b29:
    # block 0x00452b29: entered by jmp at 0x00452cb0, 10 instruction(s), falls into the block at 0x00452b53
    mov ecx, dword ptr [ebp - local_4]           # 00452b29
    mov edx, dword ptr [ecx + field_510]         # 00452b2c
    add edx, 0x1                                 # 00452b32
    mov eax, dword ptr [ebp - local_4]           # 00452b35
    mov dword ptr [eax + field_510], edx         # 00452b38
    mov ecx, dword ptr [ebp - local_4]           # 00452b3e
    mov edx, dword ptr [ecx + field_514]         # 00452b41
    sub edx, 0x1                                 # 00452b47
    mov eax, dword ptr [ebp - local_4]           # 00452b4a
    mov dword ptr [eax + field_514], edx         # 00452b4d
L_00452b53:
    # block 0x00452b53: entered by jmp at 0x00452b27, 5 instruction(s), ends with jg to 0x00452cb5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00452b53
    mov edx, dword ptr [ebp - local_4]           # 00452b56
    mov eax, dword ptr [ecx + field_510]         # 00452b59
    cmp eax, dword ptr [edx + field_9c]          # 00452b5f
    jg.d32 L_00452cb5                            # 00452b65
    # block 0x00452b6b: entered by fall-through of jg at 0x00452b65, 83 instruction(s), calls FUN_0044c1a3, FUN_0044c223, ends with je to 0x00452cae (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00452b6b
    mov edx, dword ptr [ecx + field_518]         # 00452b6e
    push edx                                     # 00452b74
    mov eax, dword ptr [ebp - local_4]           # 00452b75
    mov ecx, dword ptr [eax + field_510]         # 00452b78
    imul ecx, ecx, 0x18                          # 00452b7e
    mov edx, dword ptr [ebp - local_4]           # 00452b81
    mov eax, dword ptr [edx + field_51c]         # 00452b84
    {load} add eax, ecx                          # 00452b8a
    push eax                                     # 00452b8c
    mov ecx, dword ptr [ebp - local_4]           # 00452b8d
    add ecx, 0x524                               # 00452b90
    push ecx                                     # 00452b96
    mov ecx, 0x61f860                            # 00452b97
    call FUN_0044c1a3                            # 00452b9c
    mov edx, dword ptr [ebp - local_4]           # 00452ba1
    mov eax, dword ptr [edx + field_510]         # 00452ba4
    imul eax, eax, 0x18                          # 00452baa
    mov ecx, dword ptr [ebp - local_4]           # 00452bad
    mov edx, dword ptr [ecx + field_51c]         # 00452bb0
    {load} add edx, eax                          # 00452bb6
    mov eax, dword ptr [ebp - local_4]           # 00452bb8
    mov ecx, dword ptr [eax + field_514]         # 00452bbb
    imul ecx, ecx, 0x18                          # 00452bc1
    mov eax, dword ptr [ebp - local_4]           # 00452bc4
    mov eax, dword ptr [eax + field_51c]         # 00452bc7
    {load} add eax, ecx                          # 00452bcd
    mov ecx, dword ptr [edx]                     # 00452bcf
    mov dword ptr [eax], ecx                     # 00452bd1
    mov ecx, dword ptr [edx + field_4]           # 00452bd3
    mov dword ptr [eax + field_4], ecx           # 00452bd6
    mov edx, dword ptr [edx + field_8]           # 00452bd9
    mov dword ptr [eax + field_8], edx           # 00452bdc
    push 0x0                                     # 00452bdf
    mov eax, dword ptr [ebp - local_4]           # 00452be1
    add eax, 0x53c                               # 00452be4
    push eax                                     # 00452be9
    mov ecx, dword ptr [ebp - local_4]           # 00452bea
    mov edx, dword ptr [ecx + field_510]         # 00452bed
    imul edx, edx, 0x18                          # 00452bf3
    mov eax, dword ptr [ebp - local_4]           # 00452bf6
    mov ecx, dword ptr [eax + field_51c]         # 00452bf9
    lea edx, [ecx + edx + field_c]               # 00452bff
    push edx                                     # 00452c03
    mov eax, dword ptr [ebp - local_4]           # 00452c04
    mov ecx, dword ptr [eax + field_510]         # 00452c07
    imul ecx, ecx, 0x18                          # 00452c0d
    mov edx, dword ptr [ebp - local_4]           # 00452c10
    mov eax, dword ptr [edx + field_51c]         # 00452c13
    {load} add eax, ecx                          # 00452c19
    push eax                                     # 00452c1b
    mov ecx, 0x61f860                            # 00452c1c
    call FUN_0044c223                            # 00452c21
    mov ecx, dword ptr [ebp - local_4]           # 00452c26
    mov edx, dword ptr [ecx + field_510]         # 00452c29
    imul edx, edx, 0x18                          # 00452c2f
    mov eax, dword ptr [ebp - local_4]           # 00452c32
    mov ecx, dword ptr [eax + field_51c]         # 00452c35
    lea edx, [ecx + edx + field_c]               # 00452c3b
    mov eax, dword ptr [ebp - local_4]           # 00452c3f
    mov ecx, dword ptr [eax + field_514]         # 00452c42
    imul ecx, ecx, 0x18                          # 00452c48
    mov eax, dword ptr [ebp - local_4]           # 00452c4b
    mov eax, dword ptr [eax + field_51c]         # 00452c4e
    lea ecx, [eax + ecx + field_c]               # 00452c54
    mov eax, dword ptr [edx]                     # 00452c58
    mov dword ptr [ecx], eax                     # 00452c5a
    mov eax, dword ptr [edx + field_4]           # 00452c5c
    mov dword ptr [ecx + field_4], eax           # 00452c5f
    mov edx, dword ptr [edx + field_8]           # 00452c62
    mov dword ptr [ecx + field_8], edx           # 00452c65
    mov eax, dword ptr [ebp - local_4]           # 00452c68
    mov ecx, dword ptr [ebp - local_4]           # 00452c6b
    fld dword ptr [eax + field_518]              # 00452c6e
    fadd dword ptr [ecx + field_520]             # 00452c74
    mov edx, dword ptr [ebp - local_4]           # 00452c7a
    fstp dword ptr [edx + field_518]             # 00452c7d
    mov eax, dword ptr [ebp - local_4]           # 00452c83
    mov ecx, dword ptr [eax + field_510]         # 00452c86
    add ecx, 0x1                                 # 00452c8c
    mov edx, dword ptr [ebp - local_4]           # 00452c8f
    cmp ecx, dword ptr [edx + field_514]         # 00452c92
    je.d8 L_00452cae                             # 00452c98
    # block 0x00452c9a: entered by fall-through of je at 0x00452c98, 5 instruction(s), ends with jl to 0x00452cb0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00452c9a
    mov ecx, dword ptr [ebp - local_4]           # 00452c9d
    mov edx, dword ptr [eax + field_510]         # 00452ca0
    cmp edx, dword ptr [ecx + field_514]         # 00452ca6
    jl.d8 L_00452cb0                             # 00452cac
L_00452cae:
    # block 0x00452cae: entered by je at 0x00452c98; fall-through of jl at 0x00452cac, 1 instruction(s), ends with forward jump to 0x00452cb5
    jmp.d8 L_00452cb5                            # 00452cae
L_00452cb0:
    # block 0x00452cb0: entered by jl at 0x00452cac, 1 instruction(s), ends with backward jump to 0x00452b29
    jmp.d32 L_00452b29                           # 00452cb0
L_00452cb5:
    # block 0x00452cb5: entered by jg at 0x00452b65; jmp at 0x00452cae, 125 instruction(s), calls FUN_004d39f9, ends with jne to 0x00452f7a (forward)
    mov eax, dword ptr [ebp - local_4]           # 00452cb5
    mov dword ptr [eax + field_188], 0x0         # 00452cb8
    mov ecx, dword ptr [ebp - local_4]           # 00452cc2
    mov dword ptr [ecx + field_18c], 0x3f800000  # 00452cc5
    mov edx, dword ptr [ebp - local_4]           # 00452ccf
    mov dword ptr [edx + field_194], 0xbf800000  # 00452cd2
    mov eax, dword ptr [ebp - local_4]           # 00452cdc
    mov dword ptr [eax + field_198], 0x0         # 00452cdf
    mov ecx, dword ptr [ebp - local_4]           # 00452ce9
    mov dword ptr [ecx + field_1a0], 0x3f800000  # 00452cec
    mov edx, dword ptr [ebp - local_4]           # 00452cf6
    mov dword ptr [edx + field_1a4], 0x0         # 00452cf9
    mov eax, dword ptr [ebp - local_4]           # 00452d03
    mov dword ptr [eax + field_1ac], 0x3f800000  # 00452d06
    mov ecx, dword ptr [ebp - local_4]           # 00452d10
    mov dword ptr [ecx + field_1b0], 0x0         # 00452d13
    mov edx, dword ptr [ebp - local_4]           # 00452d1d
    mov dword ptr [edx + field_1b8], 0x0         # 00452d20
    mov eax, dword ptr [ebp - local_4]           # 00452d2a
    mov dword ptr [eax + field_1bc], 0xbf800000  # 00452d2d
    mov ecx, dword ptr [ebp - local_4]           # 00452d37
    mov dword ptr [ecx + field_1c4], 0xbf800000  # 00452d3a
    mov edx, dword ptr [ebp - local_4]           # 00452d44
    mov dword ptr [edx + field_1c8], 0x0         # 00452d47
    mov eax, dword ptr [ebp - local_4]           # 00452d51
    mov dword ptr [eax + field_1d0], 0x0         # 00452d54
    mov ecx, dword ptr [ebp - local_4]           # 00452d5e
    mov dword ptr [ecx + field_1d4], 0x3f800000  # 00452d61
    mov edx, dword ptr [ebp - local_4]           # 00452d6b
    mov dword ptr [edx + field_1dc], 0xbf800000  # 00452d6e
    mov eax, dword ptr [ebp - local_4]           # 00452d78
    mov dword ptr [eax + field_1e0], 0x0         # 00452d7b
    mov ecx, dword ptr [ebp - local_4]           # 00452d85
    mov dword ptr [ecx + field_1e8], 0x0         # 00452d88
    mov edx, dword ptr [ebp - local_4]           # 00452d92
    mov dword ptr [edx + field_1ec], 0x3f800000  # 00452d95
    mov eax, dword ptr [ebp - local_4]           # 00452d9f
    mov dword ptr [eax + field_1f4], 0x3f800000  # 00452da2
    mov ecx, dword ptr [ebp - local_4]           # 00452dac
    mov dword ptr [ecx + field_1f8], 0x0         # 00452daf
    mov edx, dword ptr [ebp - local_4]           # 00452db9
    mov dword ptr [edx + field_200], 0x0         # 00452dbc
    mov eax, dword ptr [ebp - local_4]           # 00452dc6
    mov dword ptr [eax + field_204], 0xbf800000  # 00452dc9
    mov ecx, dword ptr [ebp - local_4]           # 00452dd3
    mov dword ptr [ecx + field_20c], 0x3f350481  # 00452dd6
    mov edx, dword ptr [ebp - local_4]           # 00452de0
    mov dword ptr [edx + field_210], 0xbf350481  # 00452de3
    mov eax, dword ptr [ebp - local_4]           # 00452ded
    mov dword ptr [eax + field_218], 0xbf350481  # 00452df0
    mov ecx, dword ptr [ebp - local_4]           # 00452dfa
    mov dword ptr [ecx + field_21c], 0xbf350481  # 00452dfd
    mov edx, dword ptr [ebp - local_4]           # 00452e07
    mov dword ptr [edx + field_224], 0x3f350481  # 00452e0a
    mov eax, dword ptr [ebp - local_4]           # 00452e14
    mov dword ptr [eax + field_228], 0x3f350481  # 00452e17
    mov ecx, dword ptr [ebp - local_4]           # 00452e21
    mov dword ptr [ecx + field_230], 0xbf350481  # 00452e24
    mov edx, dword ptr [ebp - local_4]           # 00452e2e
    mov dword ptr [edx + field_234], 0x3f350481  # 00452e31
    mov eax, dword ptr [ebp - local_4]           # 00452e3b
    mov dword ptr [eax + field_23c], 0x0         # 00452e3e
    mov ecx, dword ptr [ebp - local_4]           # 00452e48
    mov dword ptr [ecx + field_240], 0x3f800000  # 00452e4b
    mov edx, dword ptr [ebp - local_4]           # 00452e55
    mov dword ptr [edx + field_248], 0x0         # 00452e58
    mov eax, dword ptr [ebp - local_4]           # 00452e62
    mov dword ptr [eax + field_24c], 0x0         # 00452e65
    call FUN_004d39f9                            # 00452e6f
    mov ecx, dword ptr [ebp - local_4]           # 00452e74
    mov word ptr [ecx + field_4], ax             # 00452e77
    mov edx, dword ptr [ebp - local_4]           # 00452e7b
    movsx eax, word ptr [edx + field_4]          # 00452e7e
    imul eax, eax, 0x4a                          # 00452e82
    mov dword ptr [eax + 0x5d1591], 0xb          # 00452e85
    mov ecx, dword ptr [ebp - local_4]           # 00452e8f
    movsx edx, word ptr [ecx + field_4]          # 00452e92
    imul edx, edx, 0x4a                          # 00452e96
    mov dword ptr [edx + 0x5d1595], 0x454847     # 00452e99
    mov eax, dword ptr [ebp - local_4]           # 00452ea3
    movsx ecx, word ptr [eax + field_4]          # 00452ea6
    imul ecx, ecx, 0x4a                          # 00452eaa
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00452ead
    mov edx, dword ptr [ebp - local_4]           # 00452eb7
    movsx eax, word ptr [edx + field_4]          # 00452eba
    imul eax, eax, 0x4a                          # 00452ebe
    mov dword ptr [eax + 0x5d159d], 0x0          # 00452ec1
    mov ecx, dword ptr [ebp - local_4]           # 00452ecb
    movsx edx, word ptr [ecx + field_4]          # 00452ece
    imul edx, edx, 0x4a                          # 00452ed2
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00452ed5
    mov eax, dword ptr [ebp - local_4]           # 00452edf
    movsx ecx, word ptr [eax + field_4]          # 00452ee2
    imul ecx, ecx, 0x4a                          # 00452ee6
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00452ee9
    mov edx, dword ptr [ebp - local_4]           # 00452ef3
    movsx eax, word ptr [edx + field_4]          # 00452ef6
    imul eax, eax, 0x4a                          # 00452efa
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00452efd
    mov ecx, dword ptr [ebp - local_4]           # 00452f07
    movsx edx, word ptr [ecx + field_4]          # 00452f0a
    imul edx, edx, 0x4a                          # 00452f0e
    mov word ptr [edx + 0x5d15ad], 0x0           # 00452f11
    mov edi, 0x549c50                            # 00452f1a
    mov eax, dword ptr [ebp - local_4]           # 00452f1f
    movsx ecx, word ptr [eax + field_4]          # 00452f22
    imul ecx, ecx, 0x4a                          # 00452f26
    add ecx, 0x5d15b3                            # 00452f29
    {load} mov edx, ecx                          # 00452f2f
    or ecx, -0x1                                 # 00452f31
    {load} xor eax, eax                          # 00452f34
    repne scasb al, byte ptr es:[edi]            # 00452f36
    not ecx                                      # 00452f38
    {load} sub edi, ecx                          # 00452f3a
    {load} mov esi, edi                          # 00452f3c
    {load} mov eax, ecx                          # 00452f3e
    {load} mov edi, edx                          # 00452f40
    shr ecx, 0x2                                 # 00452f42
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00452f45
    {load} mov ecx, eax                          # 00452f47
    and ecx, 0x3                                 # 00452f49
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00452f4c
    mov ecx, dword ptr [ebp - local_4]           # 00452f4e
    cmp dword ptr [ecx + field_c], 0x0           # 00452f51
    jne.d8 L_00452f7a                            # 00452f55
    # block 0x00452f57: entered by fall-through of jne at 0x00452f55, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x00452f7a
    push 0x549c6c                                # 00452f57
    push 0x6                                     # 00452f5c
    mov edx, dword ptr [ebp - local_4]           # 00452f5e
    mov eax, dword ptr [edx + field_8]           # 00452f61
    push eax                                     # 00452f64
    push 0x549c8c                                # 00452f65
    mov ecx, 0x5cf659                            # 00452f6a
    call FUN_004c2790                            # 00452f6f
    mov ecx, dword ptr [ebp - local_4]           # 00452f74
    mov dword ptr [ecx + field_c], eax           # 00452f77
L_00452f7a:
    # block 0x00452f7a: entered by jne at 0x00452f55, 100 instruction(s), calls FUN_004516c7, ends with je to 0x004530ff (forward)
    mov edx, dword ptr [ebp - local_4]           # 00452f7a
    movsx eax, word ptr [edx + field_4]          # 00452f7d
    imul eax, eax, 0x4a                          # 00452f81
    mov ecx, dword ptr [ebp - local_4]           # 00452f84
    mov edx, dword ptr [ecx + field_c]           # 00452f87
    mov dword ptr [eax + 0x5d1599], edx          # 00452f8a
    mov eax, dword ptr [ebp - local_4]           # 00452f90
    mov esi, dword ptr [eax + field_8]           # 00452f93
    add esi, 0x55                                # 00452f96
    mov edi, dword ptr [ebp - local_4]           # 00452f99
    add edi, 0x2dc                               # 00452f9c
    mov ecx, 0xc                                 # 00452fa2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00452fa7
    mov ecx, dword ptr [ebp - local_4]           # 00452fa9
    mov esi, dword ptr [ecx + field_8]           # 00452fac
    add esi, 0x25                                # 00452faf
    mov edi, dword ptr [ebp - local_4]           # 00452fb2
    add edi, 0x2ac                               # 00452fb5
    mov ecx, 0xc                                 # 00452fbb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00452fc0
    mov edx, dword ptr [ebp - local_4]           # 00452fc2
    mov eax, dword ptr [edx + field_8]           # 00452fc5
    mov ecx, dword ptr [ebp - local_4]           # 00452fc8
    mov edx, dword ptr [eax + field_21]          # 00452fcb
    mov dword ptr [ecx + field_2a8], edx         # 00452fce
    mov eax, dword ptr [ebp - local_4]           # 00452fd4
    mov ecx, dword ptr [eax + field_8]           # 00452fd7
    mov edx, dword ptr [ebp - local_4]           # 00452fda
    mov eax, dword ptr [edx + field_8]           # 00452fdd
    mov ecx, dword ptr [ecx + field_ad]          # 00452fe0
    sub ecx, dword ptr [eax + field_a5]          # 00452fe6
    add ecx, 0x1                                 # 00452fec
    mov edx, dword ptr [ebp - local_4]           # 00452fef
    mov dword ptr [edx + field_a4], ecx          # 00452ff2
    mov eax, dword ptr [ebp - local_4]           # 00452ff8
    mov ecx, dword ptr [eax + field_8]           # 00452ffb
    mov edx, dword ptr [ebp - local_4]           # 00452ffe
    mov eax, dword ptr [edx + field_8]           # 00453001
    mov ecx, dword ptr [ecx + field_b1]          # 00453004
    sub ecx, dword ptr [eax + field_a9]          # 0045300a
    add ecx, 0x1                                 # 00453010
    mov edx, dword ptr [ebp - local_4]           # 00453013
    mov dword ptr [edx + field_a8], ecx          # 00453016
    mov ecx, dword ptr [ebp - local_4]           # 0045301c
    call FUN_004516c7                            # 0045301f
    mov eax, dword ptr [ebp - local_4]           # 00453024
    mov esi, dword ptr [eax + field_8]           # 00453027
    add esi, 0x315                               # 0045302a
    mov edi, dword ptr [ebp - local_4]           # 00453030
    add edi, 0x550                               # 00453033
    mov ecx, 0xc                                 # 00453039
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045303e
    movsb byte ptr es:[edi], byte ptr [esi]      # 00453040
    mov ecx, dword ptr [ebp - local_4]           # 00453041
    mov esi, dword ptr [ecx + field_8]           # 00453044
    add esi, 0x346                               # 00453047
    mov edi, dword ptr [ebp - local_4]           # 0045304d
    add edi, 0x581                               # 00453050
    mov ecx, 0xc                                 # 00453056
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045305b
    movsb byte ptr es:[edi], byte ptr [esi]      # 0045305d
    mov edx, dword ptr [ebp - local_4]           # 0045305e
    mov esi, dword ptr [edx + field_8]           # 00453061
    add esi, 0x377                               # 00453064
    mov edi, dword ptr [ebp - local_4]           # 0045306a
    add edi, 0x5b2                               # 0045306d
    mov ecx, 0xc                                 # 00453073
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00453078
    movsb byte ptr es:[edi], byte ptr [esi]      # 0045307a
    mov eax, dword ptr [ebp - local_4]           # 0045307b
    mov esi, dword ptr [eax + field_8]           # 0045307e
    add esi, 0x3a8                               # 00453081
    mov edi, dword ptr [ebp - local_4]           # 00453087
    add edi, 0x5e3                               # 0045308a
    mov ecx, 0xc                                 # 00453090
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00453095
    movsb byte ptr es:[edi], byte ptr [esi]      # 00453097
    mov ecx, dword ptr [ebp - local_4]           # 00453098
    mov esi, dword ptr [ecx + field_8]           # 0045309b
    add esi, 0x3d9                               # 0045309e
    mov edi, dword ptr [ebp - local_4]           # 004530a4
    add edi, 0x614                               # 004530a7
    mov ecx, 0xc                                 # 004530ad
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004530b2
    movsb byte ptr es:[edi], byte ptr [esi]      # 004530b4
    mov edx, dword ptr [ebp - local_4]           # 004530b5
    mov esi, dword ptr [edx + field_8]           # 004530b8
    add esi, 0x40a                               # 004530bb
    mov edi, dword ptr [ebp - local_4]           # 004530c1
    add edi, 0x676                               # 004530c4
    mov ecx, 0xc                                 # 004530ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004530cf
    movsb byte ptr es:[edi], byte ptr [esi]      # 004530d1
    mov edi, 0x549c94                            # 004530d2
    mov esi, dword ptr [ebp - local_4]           # 004530d7
    add esi, 0x550                               # 004530da
    mov ecx, 0x9                                 # 004530e0
    {load} xor eax, eax                          # 004530e5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004530e7
    je.d8 L_004530ff                             # 004530e9
    # block 0x004530eb: entered by fall-through of je at 0x004530e9, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004530ff
    mov ecx, dword ptr [ebp - local_4]           # 004530eb
    add ecx, 0x550                               # 004530ee
    push ecx                                     # 004530f4
    mov ecx, 0x5c3a67                            # 004530f5
    call FUN_004fb77a                            # 004530fa
L_004530ff:
    # block 0x004530ff: entered by je at 0x004530e9, 7 instruction(s), ends with je to 0x0045312b (forward)
    mov edi, 0x549ca0                            # 004530ff
    mov esi, dword ptr [ebp - local_4]           # 00453104
    add esi, 0x581                               # 00453107
    mov ecx, 0x9                                 # 0045310d
    {load} xor edx, edx                          # 00453112
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453114
    je.d8 L_0045312b                             # 00453116
    # block 0x00453118: entered by fall-through of je at 0x00453116, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045312b
    mov eax, dword ptr [ebp - local_4]           # 00453118
    add eax, 0x581                               # 0045311b
    push eax                                     # 00453120
    mov ecx, 0x5c3a67                            # 00453121
    call FUN_004fb77a                            # 00453126
L_0045312b:
    # block 0x0045312b: entered by je at 0x00453116, 7 instruction(s), ends with je to 0x00453157 (forward)
    mov edi, 0x549cac                            # 0045312b
    mov esi, dword ptr [ebp - local_4]           # 00453130
    add esi, 0x5b2                               # 00453133
    mov ecx, 0x9                                 # 00453139
    {load} xor edx, edx                          # 0045313e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453140
    je.d8 L_00453157                             # 00453142
    # block 0x00453144: entered by fall-through of je at 0x00453142, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00453157
    mov eax, dword ptr [ebp - local_4]           # 00453144
    add eax, 0x5b2                               # 00453147
    push eax                                     # 0045314c
    mov ecx, 0x5c3a67                            # 0045314d
    call FUN_004fb77a                            # 00453152
L_00453157:
    # block 0x00453157: entered by je at 0x00453142, 7 instruction(s), ends with je to 0x00453183 (forward)
    mov edi, 0x549cb8                            # 00453157
    mov esi, dword ptr [ebp - local_4]           # 0045315c
    add esi, 0x5e3                               # 0045315f
    mov ecx, 0x9                                 # 00453165
    {load} xor edx, edx                          # 0045316a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045316c
    je.d8 L_00453183                             # 0045316e
    # block 0x00453170: entered by fall-through of je at 0x0045316e, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00453183
    mov eax, dword ptr [ebp - local_4]           # 00453170
    add eax, 0x5e3                               # 00453173
    push eax                                     # 00453178
    mov ecx, 0x5c3a67                            # 00453179
    call FUN_004fb77a                            # 0045317e
L_00453183:
    # block 0x00453183: entered by je at 0x0045316e, 7 instruction(s), ends with je to 0x004531af (forward)
    mov edi, 0x549cc4                            # 00453183
    mov esi, dword ptr [ebp - local_4]           # 00453188
    add esi, 0x614                               # 0045318b
    mov ecx, 0x9                                 # 00453191
    {load} xor edx, edx                          # 00453196
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453198
    je.d8 L_004531af                             # 0045319a
    # block 0x0045319c: entered by fall-through of je at 0x0045319a, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004531af
    mov eax, dword ptr [ebp - local_4]           # 0045319c
    add eax, 0x614                               # 0045319f
    push eax                                     # 004531a4
    mov ecx, 0x5c3a67                            # 004531a5
    call FUN_004fb77a                            # 004531aa
L_004531af:
    # block 0x004531af: entered by je at 0x0045319a, 7 instruction(s), ends with je to 0x004531db (forward)
    mov edi, 0x549cd0                            # 004531af
    mov esi, dword ptr [ebp - local_4]           # 004531b4
    add esi, 0x676                               # 004531b7
    mov ecx, 0x9                                 # 004531bd
    {load} xor edx, edx                          # 004531c2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004531c4
    je.d8 L_004531db                             # 004531c6
    # block 0x004531c8: entered by fall-through of je at 0x004531c6, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004531db
    mov eax, dword ptr [ebp - local_4]           # 004531c8
    add eax, 0x676                               # 004531cb
    push eax                                     # 004531d0
    mov ecx, 0x5c3a67                            # 004531d1
    call FUN_004fb77a                            # 004531d6
L_004531db:
    # block 0x004531db: entered by je at 0x004531c6, 258 instruction(s), calls FUN_004d39f9, FUN_004462d3, FUN_00446598, FUN_00446548, FUN_004460d6, FUN_0044655e, FUN_00446532,..., ends with forward jump to 0x00453c6e
    mov ecx, dword ptr [ebp - local_4]           # 004531db
    mov esi, dword ptr [ecx + field_8]           # 004531de
    add esi, 0x1c5                               # 004531e1
    mov edi, dword ptr [ebp - local_4]           # 004531e7
    add edi, 0x41c                               # 004531ea
    mov ecx, 0x28                                # 004531f0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004531f5
    mov edx, dword ptr [ebp - local_4]           # 004531f7
    mov eax, dword ptr [edx + field_8]           # 004531fa
    add eax, 0x265                               # 004531fd
    mov ecx, dword ptr [ebp - local_4]           # 00453202
    add ecx, 0x4bc                               # 00453205
    mov edx, dword ptr [eax]                     # 0045320b
    mov dword ptr [ecx], edx                     # 0045320d
    mov edx, dword ptr [eax + field_4]           # 0045320f
    mov dword ptr [ecx + field_4], edx           # 00453212
    mov edx, dword ptr [eax + field_8]           # 00453215
    mov dword ptr [ecx + field_8], edx           # 00453218
    mov eax, dword ptr [eax + field_c]           # 0045321b
    mov dword ptr [ecx + field_c], eax           # 0045321e
    mov ecx, dword ptr [ebp - local_4]           # 00453221
    mov edx, dword ptr [ecx + field_8]           # 00453224
    mov eax, dword ptr [ebp - local_4]           # 00453227
    mov ecx, dword ptr [edx + field_2c9]         # 0045322a
    mov dword ptr [eax + field_4cc], ecx         # 00453230
    mov edx, dword ptr [edx + field_2cd]         # 00453236
    mov dword ptr [eax + field_4d0], edx         # 0045323c
    mov eax, dword ptr [ebp - local_4]           # 00453242
    mov ecx, dword ptr [eax + field_8]           # 00453245
    mov edx, dword ptr [ebp - local_4]           # 00453248
    mov eax, dword ptr [ecx + field_2d5]         # 0045324b
    mov dword ptr [edx + field_4d4], eax         # 00453251
    mov ecx, dword ptr [ebp - local_4]           # 00453257
    mov edx, dword ptr [ebp - local_4]           # 0045325a
    mov eax, dword ptr [edx + field_c]           # 0045325d
    mov dword ptr [ecx + field_4d8], eax         # 00453260
    call FUN_004d39f9                            # 00453266
    movsx ecx, ax                                # 0045326b
    mov edx, dword ptr [ebp - local_4]           # 0045326e
    mov dword ptr [edx + field_4dc], ecx         # 00453271
    mov eax, dword ptr [ebp - local_4]           # 00453277
    mov dword ptr [eax + field_4e0], 0xa         # 0045327a
    mov ecx, dword ptr [ebp - local_4]           # 00453284
    mov edx, dword ptr [ecx + field_4cc]         # 00453287
    mov eax, dword ptr [ebp - local_4]           # 0045328d
    add edx, dword ptr [eax + field_34c]         # 00453290
    mov ecx, dword ptr [ebp - local_4]           # 00453296
    mov dword ptr [ecx + field_4cc], edx         # 00453299
    mov edx, dword ptr [ebp - local_4]           # 0045329f
    mov eax, dword ptr [edx + field_4d0]         # 004532a2
    mov ecx, dword ptr [ebp - local_4]           # 004532a8
    add eax, dword ptr [ecx + field_350]         # 004532ab
    mov edx, dword ptr [ebp - local_4]           # 004532b1
    mov dword ptr [edx + field_4d0], eax         # 004532b4
    mov eax, dword ptr [ebp - local_4]           # 004532ba
    add eax, 0x41c                               # 004532bd
    push eax                                     # 004532c2
    mov ecx, 0x638603                            # 004532c3
    call FUN_004462d3                            # 004532c8
    mov ecx, dword ptr [ebp - local_4]           # 004532cd
    mov edx, dword ptr [ecx + field_340]         # 004532d0
    push edx                                     # 004532d6
    mov eax, dword ptr [ebp - local_4]           # 004532d7
    mov ecx, dword ptr [eax + field_33c]         # 004532da
    push ecx                                     # 004532e0
    mov ecx, 0x638603                            # 004532e1
    call FUN_00446598                            # 004532e6
    push 0x1                                     # 004532eb
    mov ecx, 0x638603                            # 004532ed
    call FUN_00446548                            # 004532f2
    mov edx, dword ptr [ebp - local_4]           # 004532f7
    mov dword ptr [edx + field_b4], 0x0          # 004532fa
    mov eax, dword ptr [ebp - local_4]           # 00453304
    mov ecx, dword ptr [eax + field_8]           # 00453307
    mov edx, dword ptr [ebp - local_4]           # 0045330a
    mov eax, dword ptr [ecx + field_305]         # 0045330d
    mov dword ptr [edx + field_288], eax         # 00453313
    mov ecx, dword ptr [ebp - local_4]           # 00453319
    mov edx, dword ptr [ecx + field_8]           # 0045331c
    mov eax, dword ptr [ebp - local_4]           # 0045331f
    mov ecx, dword ptr [edx + field_309]         # 00453322
    mov dword ptr [eax + field_28c], ecx         # 00453328
    mov edx, dword ptr [ebp - local_4]           # 0045332e
    mov eax, dword ptr [edx + field_8]           # 00453331
    mov ecx, dword ptr [ebp - local_4]           # 00453334
    mov edx, dword ptr [eax + field_30d]         # 00453337
    mov dword ptr [ecx + field_290], edx         # 0045333d
    mov eax, dword ptr [ebp - local_4]           # 00453343
    mov ecx, dword ptr [eax + field_8]           # 00453346
    mov edx, dword ptr [ebp - local_4]           # 00453349
    mov eax, dword ptr [ecx + field_311]         # 0045334c
    mov dword ptr [edx + field_294], eax         # 00453352
    mov ecx, dword ptr [ebp - local_4]           # 00453358
    mov edx, dword ptr [ecx + field_8]           # 0045335b
    mov eax, dword ptr [ebp - local_4]           # 0045335e
    mov ecx, dword ptr [edx + field_2d1]         # 00453361
    mov dword ptr [eax + field_40c], ecx         # 00453367
    mov edx, dword ptr [ebp - local_4]           # 0045336d
    mov eax, dword ptr [ebp - local_4]           # 00453370
    mov ecx, dword ptr [eax + field_c]           # 00453373
    mov dword ptr [edx + field_410], ecx         # 00453376
    call FUN_004d39f9                            # 0045337c
    movsx edx, ax                                # 00453381
    mov eax, dword ptr [ebp - local_4]           # 00453384
    mov dword ptr [eax + field_414], edx         # 00453387
    mov ecx, dword ptr [ebp - local_4]           # 0045338d
    mov dword ptr [ecx + field_418], 0xa         # 00453390
    mov edx, dword ptr [ebp - local_4]           # 0045339a
    mov esi, dword ptr [edx + field_8]           # 0045339d
    add esi, 0x125                               # 004533a0
    mov edi, dword ptr [ebp - local_4]           # 004533a6
    add edi, 0x364                               # 004533a9
    mov ecx, 0x28                                # 004533af
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004533b4
    mov eax, dword ptr [ebp - local_4]           # 004533b6
    mov ecx, dword ptr [eax + field_8]           # 004533b9
    mov edx, dword ptr [ebp - local_4]           # 004533bc
    mov eax, dword ptr [ecx + field_2c1]         # 004533bf
    mov dword ptr [edx + field_404], eax         # 004533c5
    mov ecx, dword ptr [ecx + field_2c5]         # 004533cb
    mov dword ptr [edx + field_408], ecx         # 004533d1
    mov edx, dword ptr [ebp - local_4]           # 004533d7
    mov eax, dword ptr [edx + field_404]         # 004533da
    mov ecx, dword ptr [ebp - local_4]           # 004533e0
    add eax, dword ptr [ecx + field_34c]         # 004533e3
    mov edx, dword ptr [ebp - local_4]           # 004533e9
    mov dword ptr [edx + field_404], eax         # 004533ec
    mov eax, dword ptr [ebp - local_4]           # 004533f2
    mov ecx, dword ptr [eax + field_408]         # 004533f5
    mov edx, dword ptr [ebp - local_4]           # 004533fb
    add ecx, dword ptr [edx + field_350]         # 004533fe
    mov eax, dword ptr [ebp - local_4]           # 00453404
    mov dword ptr [eax + field_408], ecx         # 00453407
    mov ecx, dword ptr [ebp - local_4]           # 0045340d
    add ecx, 0x364                               # 00453410
    push ecx                                     # 00453416
    mov ecx, 0x638603                            # 00453417
    call FUN_004460d6                            # 0045341c
    mov edx, dword ptr [ebp - local_4]           # 00453421
    mov eax, dword ptr [edx + field_b4]          # 00453424
    push eax                                     # 0045342a
    mov ecx, 0x638603                            # 0045342b
    call FUN_0044655e                            # 00453430
    push 0x1                                     # 00453435
    mov ecx, 0x638603                            # 00453437
    call FUN_00446532                            # 0045343c
    mov ecx, dword ptr [ebp - local_4]           # 00453441
    mov edx, dword ptr [ecx + field_8]           # 00453444
    add edx, 0x275                               # 00453447
    mov eax, dword ptr [ebp - local_4]           # 0045344d
    add eax, 0x5c                                # 00453450
    mov ecx, dword ptr [edx]                     # 00453453
    mov dword ptr [eax], ecx                     # 00453455
    mov ecx, dword ptr [edx + field_4]           # 00453457
    mov dword ptr [eax + field_4], ecx           # 0045345a
    mov ecx, dword ptr [edx + field_8]           # 0045345d
    mov dword ptr [eax + field_8], ecx           # 00453460
    mov edx, dword ptr [edx + field_c]           # 00453463
    mov dword ptr [eax + field_c], edx           # 00453466
    mov eax, dword ptr [ebp - local_4]           # 00453469
    mov ecx, dword ptr [eax + field_8]           # 0045346c
    add ecx, 0x285                               # 0045346f
    mov edx, dword ptr [ebp - local_4]           # 00453475
    add edx, 0x6c                                # 00453478
    mov eax, dword ptr [ecx]                     # 0045347b
    mov dword ptr [edx], eax                     # 0045347d
    mov eax, dword ptr [ecx + field_4]           # 0045347f
    mov dword ptr [edx + field_4], eax           # 00453482
    mov eax, dword ptr [ecx + field_8]           # 00453485
    mov dword ptr [edx + field_8], eax           # 00453488
    mov ecx, dword ptr [ecx + field_c]           # 0045348b
    mov dword ptr [edx + field_c], ecx           # 0045348e
    mov edx, dword ptr [ebp - local_4]           # 00453491
    mov eax, dword ptr [edx + field_8]           # 00453494
    add eax, 0x295                               # 00453497
    mov ecx, dword ptr [ebp - local_4]           # 0045349c
    add ecx, 0x7c                                # 0045349f
    mov edx, dword ptr [eax]                     # 004534a2
    mov dword ptr [ecx], edx                     # 004534a4
    mov edx, dword ptr [eax + field_4]           # 004534a6
    mov dword ptr [ecx + field_4], edx           # 004534a9
    mov edx, dword ptr [eax + field_8]           # 004534ac
    mov dword ptr [ecx + field_8], edx           # 004534af
    mov eax, dword ptr [eax + field_c]           # 004534b2
    mov dword ptr [ecx + field_c], eax           # 004534b5
    mov ecx, dword ptr [ebp - local_4]           # 004534b8
    mov edx, dword ptr [ecx + field_8]           # 004534bb
    movsx eax, byte ptr [edx + field_302]        # 004534be
    mov ecx, dword ptr [ebp - local_4]           # 004534c5
    mov dword ptr [ecx + field_548], eax         # 004534c8
    mov edx, dword ptr [ebp - local_4]           # 004534ce
    mov eax, dword ptr [edx + field_8]           # 004534d1
    movsx ecx, byte ptr [eax + field_303]        # 004534d4
    mov edx, dword ptr [ebp - local_4]           # 004534db
    mov dword ptr [edx + field_54c], ecx         # 004534de
    mov eax, dword ptr [ebp - local_4]           # 004534e4
    mov dword ptr [eax + field_18], 0x0          # 004534e7
    mov ecx, dword ptr [ebp - local_4]           # 004534ee
    mov dword ptr [ecx + field_1c], 0x0          # 004534f1
    mov edx, dword ptr [ebp - local_4]           # 004534f8
    mov dword ptr [edx + field_20], 0x0          # 004534fb
    mov eax, dword ptr [ebp - local_4]           # 00453502
    mov dword ptr [eax + field_24], 0x0          # 00453505
    mov ecx, dword ptr [ebp - local_4]           # 0045350c
    mov dword ptr [ecx + field_28], 0x0          # 0045350f
    mov edx, dword ptr [ebp - local_4]           # 00453516
    mov eax, dword ptr [edx + field_8]           # 00453519
    mov ecx, dword ptr [ebp - local_4]           # 0045351c
    mov edx, dword ptr [eax + field_2e9]         # 0045351f
    mov dword ptr [ecx + field_500], edx         # 00453525
    mov eax, dword ptr [ebp - local_4]           # 0045352b
    mov ecx, dword ptr [eax + field_8]           # 0045352e
    mov edx, dword ptr [ebp - local_4]           # 00453531
    mov eax, dword ptr [ecx + field_2f1]         # 00453534
    mov dword ptr [edx + field_504], eax         # 0045353a
    mov ecx, dword ptr [ebp - local_4]           # 00453540
    fild dword ptr [ecx + field_500]             # 00453543
    fstp dword ptr [ebp - local_18]              # 00453549
    mov edx, dword ptr [ebp - local_4]           # 0045354c
    fld dword ptr [edx + field_504]              # 0045354f
    fdiv dword ptr [ebp - local_18]              # 00453555
    mov eax, dword ptr [ebp - local_4]           # 00453558
    fstp dword ptr [eax + field_508]             # 0045355b
    call dword ptr [0x52a23c]                    # 00453561
    mov ecx, dword ptr [ebp - local_4]           # 00453567
    mov dword ptr [ecx + field_4e8], eax         # 0045356a
    mov edx, dword ptr [ebp - local_4]           # 00453570
    mov eax, dword ptr [edx + field_8]           # 00453573
    mov ecx, dword ptr [ebp - local_4]           # 00453576
    mov edx, dword ptr [eax + field_2ed]         # 00453579
    mov dword ptr [ecx + field_f4], edx          # 0045357f
    mov eax, dword ptr [ebp - local_4]           # 00453585
    mov ecx, dword ptr [eax + field_8]           # 00453588
    mov edx, dword ptr [ebp - local_4]           # 0045358b
    mov eax, dword ptr [ecx + field_2f5]         # 0045358e
    mov dword ptr [edx + field_f8], eax          # 00453594
    mov ecx, dword ptr [ebp - local_4]           # 0045359a
    fild dword ptr [ecx + field_f4]              # 0045359d
    fstp dword ptr [ebp - local_1c]              # 004535a3
    mov edx, dword ptr [ebp - local_4]           # 004535a6
    fld dword ptr [edx + field_f8]               # 004535a9
    fdiv dword ptr [ebp - local_1c]              # 004535af
    mov eax, dword ptr [ebp - local_4]           # 004535b2
    fstp dword ptr [eax + field_fc]              # 004535b5
    call dword ptr [0x52a23c]                    # 004535bb
    mov ecx, dword ptr [ebp - local_4]           # 004535c1
    mov dword ptr [ecx + field_178], eax         # 004535c4
    mov edx, dword ptr [ebp - local_4]           # 004535ca
    mov dword ptr [edx + field_c4], 0x0          # 004535cd
    mov eax, dword ptr [ebp - local_4]           # 004535d7
    mov dword ptr [eax + field_10], 0x0          # 004535da
    mov ecx, dword ptr [ebp - local_4]           # 004535e1
    mov dword ptr [ecx + field_180], 0x0         # 004535e4
    mov edx, dword ptr [ebp - local_4]           # 004535ee
    movsx eax, word ptr [edx + field_6]          # 004535f1
    imul eax, eax, 0x8d                          # 004535f5
    mov dword ptr [eax + 0x5bb632], 0x1          # 004535fb
    jmp.d32 L_00453c6e                           # 00453605
L_0045360a:
    # block 0x0045360a: entered by je at 0x004525b4, 5 instruction(s), ends with ja to 0x00453a0d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045360a
    mov edx, dword ptr [ecx + field_10]          # 0045360d
    mov dword ptr [ebp - local_20], edx          # 00453610
    cmp dword ptr [ebp - local_20], 0x6          # 00453613
    ja.d32 L_00453a0d                            # 00453617
    # block 0x0045361d: entered by fall-through of ja at 0x00453617, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x453cc6]
    mov eax, dword ptr [ebp - local_20]          # 0045361d
    jmp dword ptr [4*eax + SWTAB_00453cc6_VA]    # 00453620
L_00453627:
    # block 0x00453627: entered by switch case, 14 instruction(s), calls FUN_0044fc9b, FUN_0044ffa3, FUN_00453ce2, FUN_004545b0, FUN_0045468e, ends with je to 0x0045367a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00453627
    call FUN_0044fc9b                            # 0045362a
    mov ecx, dword ptr [ebp - local_4]           # 0045362f
    call FUN_0044ffa3                            # 00453632
    mov ecx, dword ptr [ebp - local_4]           # 00453637
    call FUN_00453ce2                            # 0045363a
    mov ecx, dword ptr [ebp - local_4]           # 0045363f
    call FUN_004545b0                            # 00453642
    mov ecx, dword ptr [ebp - local_4]           # 00453647
    call FUN_0045468e                            # 0045364a
    {load} xor ecx, ecx                          # 0045364f
    mov cl, byte ptr [0x58320c]                  # 00453651
    test ecx, ecx                                # 00453657
    je.d8 L_0045367a                             # 00453659
    # block 0x0045365b: entered by fall-through of je at 0x00453659, 6 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x0045367a (forward)
    push 0x57                                    # 0045365b
    call dword ptr [0x52a4b4]                    # 0045365d
    movsx edx, ax                                # 00453663
    and edx, 0x8000                              # 00453666
    test edx, edx                                # 0045366c
    je.d8 L_0045367a                             # 0045366e
    # block 0x00453670: entered by fall-through of je at 0x0045366e, 2 instruction(s), falls into the block at 0x0045367a
    mov eax, dword ptr [ebp - local_4]           # 00453670
    mov dword ptr [eax + field_1c], 0x1          # 00453673
L_0045367a:
    # block 0x0045367a: entered by je at 0x00453659; je at 0x0045366e, 4 instruction(s), ends with je to 0x004536a5 (forward)
    {load} xor ecx, ecx                          # 0045367a
    mov cl, byte ptr [0x58320c]                  # 0045367c
    test ecx, ecx                                # 00453682
    je.d8 L_004536a5                             # 00453684
    # block 0x00453686: entered by fall-through of je at 0x00453684, 6 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x004536a5 (forward)
    push 0x4c                                    # 00453686
    call dword ptr [0x52a4b4]                    # 00453688
    movsx edx, ax                                # 0045368e
    and edx, 0x8000                              # 00453691
    test edx, edx                                # 00453697
    je.d8 L_004536a5                             # 00453699
    # block 0x0045369b: entered by fall-through of je at 0x00453699, 2 instruction(s), falls into the block at 0x004536a5
    mov eax, dword ptr [ebp - local_4]           # 0045369b
    mov dword ptr [eax + field_20], 0x1          # 0045369e
L_004536a5:
    # block 0x004536a5: entered by je at 0x00453684; je at 0x00453699, 3 instruction(s), ends with je to 0x00453764 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004536a5
    cmp dword ptr [ecx + field_1c], 0x0          # 004536a8
    je.d32 L_00453764                            # 004536ac
    # block 0x004536b2: entered by fall-through of je at 0x004536ac, 9 instruction(s), ends with forward jump to 0x004536fa
    mov edx, dword ptr [ebp - local_4]           # 004536b2
    mov eax, dword ptr [edx + field_b0]          # 004536b5
    mov ecx, dword ptr [ebp - local_4]           # 004536bb
    mov dword ptr [ecx + 4*eax + field_270], 0x1 # 004536be
    mov edx, dword ptr [ebp - local_4]           # 004536c9
    mov dword ptr [edx + field_26c], 0x0         # 004536cc
    mov eax, dword ptr [ebp - local_4]           # 004536d6
    mov dword ptr [eax + field_510], 0x0         # 004536d9
    jmp.d8 L_004536fa                            # 004536e3
L_004536e5:
    # block 0x004536e5: entered by jmp at 0x0045372b, 5 instruction(s), falls into the block at 0x004536fa
    mov ecx, dword ptr [ebp - local_4]           # 004536e5
    mov edx, dword ptr [ecx + field_510]         # 004536e8
    add edx, 0x1                                 # 004536ee
    mov eax, dword ptr [ebp - local_4]           # 004536f1
    mov dword ptr [eax + field_510], edx         # 004536f4
L_004536fa:
    # block 0x004536fa: entered by jmp at 0x004536e3, 3 instruction(s), ends with jge to 0x0045372d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004536fa
    cmp dword ptr [ecx + field_510], 0x6         # 004536fd
    jge.d8 L_0045372d                            # 00453704
    # block 0x00453706: entered by fall-through of jge at 0x00453704, 9 instruction(s), ends with backward jump to 0x004536e5
    mov edx, dword ptr [ebp - local_4]           # 00453706
    mov eax, dword ptr [edx + field_510]         # 00453709
    mov ecx, dword ptr [ebp - local_4]           # 0045370f
    mov edx, dword ptr [ecx + field_26c]         # 00453712
    mov ecx, dword ptr [ebp - local_4]           # 00453718
    add edx, dword ptr [ecx + 4*eax + field_254] # 0045371b
    mov eax, dword ptr [ebp - local_4]           # 00453722
    mov dword ptr [eax + field_26c], edx         # 00453725
    jmp.d8 L_004536e5                            # 0045372b
L_0045372d:
    # block 0x0045372d: entered by jge at 0x00453704, 4 instruction(s), calls FUN_004524a8, ends with jne to 0x0045375a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045372d
    call FUN_004524a8                            # 00453730
    cmp eax, -0x1                                # 00453735
    jne.d8 L_0045375a                            # 00453738
    # block 0x0045373a: entered by fall-through of jne at 0x00453738, 7 instruction(s), ends with forward jump to 0x00453764
    mov ecx, dword ptr [ebp - local_4]           # 0045373a
    mov dword ptr [ecx + field_1c], 0x0          # 0045373d
    mov edx, dword ptr [ebp - local_4]           # 00453744
    mov dword ptr [edx + field_18], 0x1          # 00453747
    mov eax, dword ptr [ebp - local_4]           # 0045374e
    mov dword ptr [eax + field_10], 0x4          # 00453751
    jmp.d8 L_00453764                            # 00453758
L_0045375a:
    # block 0x0045375a: entered by jne at 0x00453738, 2 instruction(s), falls into the block at 0x00453764
    mov ecx, dword ptr [ebp - local_4]           # 0045375a
    mov dword ptr [ecx + field_10], 0x1          # 0045375d
L_00453764:
    # block 0x00453764: entered by je at 0x004536ac; jmp at 0x00453758, 3 instruction(s), ends with je to 0x004537a5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00453764
    cmp dword ptr [edx + field_20], 0x0          # 00453767
    je.d8 L_004537a5                             # 0045376b
    # block 0x0045376d: entered by fall-through of je at 0x0045376b, 10 instruction(s), falls into the block at 0x004537a5
    mov eax, dword ptr [ebp - local_4]           # 0045376d
    mov ecx, dword ptr [eax + field_b0]          # 00453770
    mov edx, dword ptr [ebp - local_4]           # 00453776
    mov dword ptr [edx + 4*ecx + field_270], 0x0 # 00453779
    mov eax, dword ptr [ebp - local_4]           # 00453784
    mov ecx, dword ptr [eax + field_b0]          # 00453787
    mov edx, dword ptr [ebp - local_4]           # 0045378d
    mov dword ptr [edx + 4*ecx + field_254], 0x0 # 00453790
    mov eax, dword ptr [ebp - local_4]           # 0045379b
    mov dword ptr [eax + field_10], 0x2          # 0045379e
L_004537a5:
    # block 0x004537a5: entered by je at 0x0045376b, 1 instruction(s), ends with forward jump to 0x00453a0d
    jmp.d32 L_00453a0d                           # 004537a5
L_004537aa:
    # block 0x004537aa: entered by switch case, 8 instruction(s), ends with je to 0x0045380c (forward)
    mov edi, 0x549cdc                            # 004537aa
    mov ecx, dword ptr [ebp - local_4]           # 004537af
    mov esi, dword ptr [ecx + field_8]           # 004537b2
    add esi, 0x486                               # 004537b5
    mov ecx, 0x9                                 # 004537bb
    {load} xor edx, edx                          # 004537c0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004537c2
    je.d8 L_0045380c                             # 004537c4
    # block 0x004537c6: entered by fall-through of je at 0x004537c4, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x0045380c
    mov eax, dword ptr [ebp - local_4]           # 004537c6
    mov esi, dword ptr [eax + field_8]           # 004537c9
    add esi, 0x486                               # 004537cc
    mov edi, dword ptr [ebp - local_4]           # 004537d2
    add edi, 0x645                               # 004537d5
    mov ecx, 0xc                                 # 004537db
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004537e0
    movsb byte ptr es:[edi], byte ptr [esi]      # 004537e2
    mov ecx, dword ptr [ebp - local_4]           # 004537e3
    add ecx, 0x645                               # 004537e6
    push ecx                                     # 004537ec
    mov ecx, 0x5c3a67                            # 004537ed
    call FUN_004fb77a                            # 004537f2
    mov edx, dword ptr [ebp - local_4]           # 004537f7
    mov ax, word ptr [edx + field_666]           # 004537fa
    push eax                                     # 00453801
    mov ecx, 0x5c3a67                            # 00453802
    call FUN_004fb2e3                            # 00453807
L_0045380c:
    # block 0x0045380c: entered by je at 0x004537c4, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00453a0d
    call dword ptr [0x52a23c]                    # 0045380c
    mov ecx, dword ptr [ebp - local_4]           # 00453812
    mov edx, dword ptr [ecx + field_8]           # 00453815
    add eax, dword ptr [edx + field_2a5]         # 00453818
    mov ecx, dword ptr [ebp - local_4]           # 0045381e
    mov dword ptr [ecx + field_4f0], eax         # 00453821
    mov edx, dword ptr [ebp - local_4]           # 00453827
    mov dword ptr [edx + field_10], 0x6          # 0045382a
    jmp.d32 L_00453a0d                           # 00453831
L_00453836:
    # block 0x00453836: entered by switch case, 8 instruction(s), ends with je to 0x00453898 (forward)
    mov edi, 0x549ce8                            # 00453836
    mov eax, dword ptr [ebp - local_4]           # 0045383b
    mov esi, dword ptr [eax + field_8]           # 0045383e
    add esi, 0x43b                               # 00453841
    mov ecx, 0x9                                 # 00453847
    {load} xor edx, edx                          # 0045384c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045384e
    je.d8 L_00453898                             # 00453850
    # block 0x00453852: entered by fall-through of je at 0x00453850, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00453898
    mov eax, dword ptr [ebp - local_4]           # 00453852
    mov esi, dword ptr [eax + field_8]           # 00453855
    add esi, 0x43b                               # 00453858
    mov edi, dword ptr [ebp - local_4]           # 0045385e
    add edi, 0x645                               # 00453861
    mov ecx, 0xc                                 # 00453867
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045386c
    movsb byte ptr es:[edi], byte ptr [esi]      # 0045386e
    mov ecx, dword ptr [ebp - local_4]           # 0045386f
    add ecx, 0x645                               # 00453872
    push ecx                                     # 00453878
    mov ecx, 0x5c3a67                            # 00453879
    call FUN_004fb77a                            # 0045387e
    mov edx, dword ptr [ebp - local_4]           # 00453883
    mov ax, word ptr [edx + field_666]           # 00453886
    push eax                                     # 0045388d
    mov ecx, 0x5c3a67                            # 0045388e
    call FUN_004fb2e3                            # 00453893
L_00453898:
    # block 0x00453898: entered by je at 0x00453850, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00453a0d
    call dword ptr [0x52a23c]                    # 00453898
    mov ecx, dword ptr [ebp - local_4]           # 0045389e
    mov edx, dword ptr [ecx + field_8]           # 004538a1
    add eax, dword ptr [edx + field_2a5]         # 004538a4
    mov ecx, dword ptr [ebp - local_4]           # 004538aa
    mov dword ptr [ecx + field_4f0], eax         # 004538ad
    mov edx, dword ptr [ebp - local_4]           # 004538b3
    mov dword ptr [edx + field_10], 0x6          # 004538b6
    jmp.d32 L_00453a0d                           # 004538bd
L_004538c2:
    # block 0x004538c2: entered by switch case, 8 instruction(s), ends with je to 0x00453924 (forward)
    mov edi, 0x549cf4                            # 004538c2
    mov eax, dword ptr [ebp - local_4]           # 004538c7
    mov esi, dword ptr [eax + field_8]           # 004538ca
    add esi, 0x4b7                               # 004538cd
    mov ecx, 0x9                                 # 004538d3
    {load} xor edx, edx                          # 004538d8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004538da
    je.d8 L_00453924                             # 004538dc
    # block 0x004538de: entered by fall-through of je at 0x004538dc, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00453924
    mov eax, dword ptr [ebp - local_4]           # 004538de
    mov esi, dword ptr [eax + field_8]           # 004538e1
    add esi, 0x4b7                               # 004538e4
    mov edi, dword ptr [ebp - local_4]           # 004538ea
    add edi, 0x645                               # 004538ed
    mov ecx, 0xc                                 # 004538f3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004538f8
    movsb byte ptr es:[edi], byte ptr [esi]      # 004538fa
    mov ecx, dword ptr [ebp - local_4]           # 004538fb
    add ecx, 0x645                               # 004538fe
    push ecx                                     # 00453904
    mov ecx, 0x5c3a67                            # 00453905
    call FUN_004fb77a                            # 0045390a
    mov edx, dword ptr [ebp - local_4]           # 0045390f
    mov ax, word ptr [edx + field_666]           # 00453912
    push eax                                     # 00453919
    mov ecx, 0x5c3a67                            # 0045391a
    call FUN_004fb2e3                            # 0045391f
L_00453924:
    # block 0x00453924: entered by je at 0x004538dc, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00453a0d
    call dword ptr [0x52a23c]                    # 00453924
    mov ecx, dword ptr [ebp - local_4]           # 0045392a
    mov edx, dword ptr [ecx + field_8]           # 0045392d
    add eax, dword ptr [edx + field_2a5]         # 00453930
    mov ecx, dword ptr [ebp - local_4]           # 00453936
    mov dword ptr [ecx + field_4f0], eax         # 00453939
    mov edx, dword ptr [ebp - local_4]           # 0045393f
    mov dword ptr [edx + field_10], 0x6          # 00453942
    jmp.d32 L_00453a0d                           # 00453949
L_0045394e:
    # block 0x0045394e: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00453990 (forward)
    call dword ptr [0x52a23c]                    # 0045394e
    mov ecx, dword ptr [ebp - local_4]           # 00453954
    cmp eax, dword ptr [ecx + field_4f0]         # 00453957
    jbe.d8 L_00453990                            # 0045395d
    # block 0x0045395f: entered by fall-through of jbe at 0x0045395d, 3 instruction(s), ends with jne to 0x00453971 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045395f
    cmp dword ptr [edx + field_1c], 0x0          # 00453962
    jne.d8 L_00453971                            # 00453966
    # block 0x00453968: entered by fall-through of jne at 0x00453966, 3 instruction(s), ends with je to 0x0045397d (forward)
    mov eax, dword ptr [ebp - local_4]           # 00453968
    cmp dword ptr [eax + field_20], 0x0          # 0045396b
    je.d8 L_0045397d                             # 0045396f
L_00453971:
    # block 0x00453971: entered by jne at 0x00453966; fall-through of je at 0x0045396f, 3 instruction(s), ends with forward jump to 0x00453990
    mov ecx, dword ptr [ebp - local_4]           # 00453971
    mov dword ptr [ecx + field_10], 0x3          # 00453974
    jmp.d8 L_00453990                            # 0045397b
L_0045397d:
    # block 0x0045397d: entered by je at 0x0045396f, 3 instruction(s), ends with je to 0x00453990 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045397d
    cmp dword ptr [edx + field_18], 0x0          # 00453980
    je.d8 L_00453990                             # 00453984
    # block 0x00453986: entered by fall-through of je at 0x00453984, 2 instruction(s), falls into the block at 0x00453990
    mov eax, dword ptr [ebp - local_4]           # 00453986
    mov dword ptr [eax + field_10], 0x5          # 00453989
L_00453990:
    # block 0x00453990: entered by jbe at 0x0045395d; jmp at 0x0045397b; je at 0x00453984, 1 instruction(s), ends with forward jump to 0x00453a0d
    jmp.d8 L_00453a0d                            # 00453990
L_00453992:
    # block 0x00453992: entered by switch case, 18 instruction(s), calls FUN_004516c7, FUN_0044655e, FUN_00446598, ends with forward jump to 0x00453a0d
    mov ecx, dword ptr [ebp - local_4]           # 00453992
    call FUN_004516c7                            # 00453995
    mov ecx, dword ptr [ebp - local_4]           # 0045399a
    mov edx, dword ptr [ecx + field_b4]          # 0045399d
    push edx                                     # 004539a3
    mov ecx, 0x638603                            # 004539a4
    call FUN_0044655e                            # 004539a9
    mov eax, dword ptr [ebp - local_4]           # 004539ae
    mov ecx, dword ptr [eax + field_340]         # 004539b1
    push ecx                                     # 004539b7
    mov edx, dword ptr [ebp - local_4]           # 004539b8
    mov eax, dword ptr [edx + field_33c]         # 004539bb
    push eax                                     # 004539c1
    mov ecx, 0x638603                            # 004539c2
    call FUN_00446598                            # 004539c7
    mov ecx, dword ptr [ebp - local_4]           # 004539cc
    mov dword ptr [ecx + field_10], 0x0          # 004539cf
    jmp.d8 L_00453a0d                            # 004539d6
L_004539d8:
    # block 0x004539d8: entered by switch case, 10 instruction(s), calls FUN_00445f53, FUN_00445fc5, falls into the block at 0x00453a0d
    mov edx, dword ptr [ebp - local_4]           # 004539d8
    movsx eax, word ptr [edx + field_6]          # 004539db
    imul eax, eax, 0x8d                          # 004539df
    mov dword ptr [eax + 0x5bb632], 0x2          # 004539e5
    mov ecx, 0x638603                            # 004539ef
    call FUN_00445f53                            # 004539f4
    mov ecx, 0x638603                            # 004539f9
    call FUN_00445fc5                            # 004539fe
    mov ecx, dword ptr [ebp - local_4]           # 00453a03
    mov dword ptr [ecx + field_14], 0x0          # 00453a06
L_00453a0d:
    # block 0x00453a0d: entered by ja at 0x00453617; jmp at 0x004537a5; jmp at 0x00453831; jmp at 0x004538bd; more, 1 instruction(s), ends with forward jump to 0x00453c6e
    jmp.d32 L_00453c6e                           # 00453a0d
L_00453a12:
    # block 0x00453a12: entered by je at 0x004525be, 7 instruction(s), ends with je to 0x00453a3e (forward)
    mov edi, 0x549d00                            # 00453a12
    mov esi, dword ptr [ebp - local_4]           # 00453a17
    add esi, 0x550                               # 00453a1a
    mov ecx, 0x9                                 # 00453a20
    {load} xor edx, edx                          # 00453a25
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453a27
    je.d8 L_00453a3e                             # 00453a29
    # block 0x00453a2b: entered by fall-through of je at 0x00453a29, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453a3e
    mov eax, dword ptr [ebp - local_4]           # 00453a2b
    add eax, 0x550                               # 00453a2e
    push eax                                     # 00453a33
    mov ecx, 0x5c3a67                            # 00453a34
    call FUN_004fba69                            # 00453a39
L_00453a3e:
    # block 0x00453a3e: entered by je at 0x00453a29, 7 instruction(s), ends with je to 0x00453a6a (forward)
    mov edi, 0x549d0c                            # 00453a3e
    mov esi, dword ptr [ebp - local_4]           # 00453a43
    add esi, 0x581                               # 00453a46
    mov ecx, 0x9                                 # 00453a4c
    {load} xor edx, edx                          # 00453a51
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453a53
    je.d8 L_00453a6a                             # 00453a55
    # block 0x00453a57: entered by fall-through of je at 0x00453a55, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453a6a
    mov eax, dword ptr [ebp - local_4]           # 00453a57
    add eax, 0x581                               # 00453a5a
    push eax                                     # 00453a5f
    mov ecx, 0x5c3a67                            # 00453a60
    call FUN_004fba69                            # 00453a65
L_00453a6a:
    # block 0x00453a6a: entered by je at 0x00453a55, 7 instruction(s), ends with je to 0x00453a96 (forward)
    mov edi, 0x549d18                            # 00453a6a
    mov esi, dword ptr [ebp - local_4]           # 00453a6f
    add esi, 0x5b2                               # 00453a72
    mov ecx, 0x9                                 # 00453a78
    {load} xor edx, edx                          # 00453a7d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453a7f
    je.d8 L_00453a96                             # 00453a81
    # block 0x00453a83: entered by fall-through of je at 0x00453a81, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453a96
    mov eax, dword ptr [ebp - local_4]           # 00453a83
    add eax, 0x5b2                               # 00453a86
    push eax                                     # 00453a8b
    mov ecx, 0x5c3a67                            # 00453a8c
    call FUN_004fba69                            # 00453a91
L_00453a96:
    # block 0x00453a96: entered by je at 0x00453a81, 7 instruction(s), ends with je to 0x00453ac2 (forward)
    mov edi, 0x549d24                            # 00453a96
    mov esi, dword ptr [ebp - local_4]           # 00453a9b
    add esi, 0x5e3                               # 00453a9e
    mov ecx, 0x9                                 # 00453aa4
    {load} xor edx, edx                          # 00453aa9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453aab
    je.d8 L_00453ac2                             # 00453aad
    # block 0x00453aaf: entered by fall-through of je at 0x00453aad, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453ac2
    mov eax, dword ptr [ebp - local_4]           # 00453aaf
    add eax, 0x5e3                               # 00453ab2
    push eax                                     # 00453ab7
    mov ecx, 0x5c3a67                            # 00453ab8
    call FUN_004fba69                            # 00453abd
L_00453ac2:
    # block 0x00453ac2: entered by je at 0x00453aad, 7 instruction(s), ends with je to 0x00453aee (forward)
    mov edi, 0x549d30                            # 00453ac2
    mov esi, dword ptr [ebp - local_4]           # 00453ac7
    add esi, 0x614                               # 00453aca
    mov ecx, 0x9                                 # 00453ad0
    {load} xor edx, edx                          # 00453ad5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453ad7
    je.d8 L_00453aee                             # 00453ad9
    # block 0x00453adb: entered by fall-through of je at 0x00453ad9, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453aee
    mov eax, dword ptr [ebp - local_4]           # 00453adb
    add eax, 0x614                               # 00453ade
    push eax                                     # 00453ae3
    mov ecx, 0x5c3a67                            # 00453ae4
    call FUN_004fba69                            # 00453ae9
L_00453aee:
    # block 0x00453aee: entered by je at 0x00453ad9, 7 instruction(s), ends with je to 0x00453b1a (forward)
    mov edi, 0x549d3c                            # 00453aee
    mov esi, dword ptr [ebp - local_4]           # 00453af3
    add esi, 0x676                               # 00453af6
    mov ecx, 0x9                                 # 00453afc
    {load} xor edx, edx                          # 00453b01
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453b03
    je.d8 L_00453b1a                             # 00453b05
    # block 0x00453b07: entered by fall-through of je at 0x00453b05, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453b1a
    mov eax, dword ptr [ebp - local_4]           # 00453b07
    add eax, 0x676                               # 00453b0a
    push eax                                     # 00453b0f
    mov ecx, 0x5c3a67                            # 00453b10
    call FUN_004fba69                            # 00453b15
L_00453b1a:
    # block 0x00453b1a: entered by je at 0x00453b05, 7 instruction(s), ends with je to 0x00453b46 (forward)
    mov edi, 0x549d48                            # 00453b1a
    mov esi, dword ptr [ebp - local_4]           # 00453b1f
    add esi, 0x645                               # 00453b22
    mov ecx, 0x9                                 # 00453b28
    {load} xor edx, edx                          # 00453b2d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00453b2f
    je.d8 L_00453b46                             # 00453b31
    # block 0x00453b33: entered by fall-through of je at 0x00453b31, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00453b46
    mov eax, dword ptr [ebp - local_4]           # 00453b33
    add eax, 0x645                               # 00453b36
    push eax                                     # 00453b3b
    mov ecx, 0x5c3a67                            # 00453b3c
    call FUN_004fba69                            # 00453b41
L_00453b46:
    # block 0x00453b46: entered by je at 0x00453b31, 3 instruction(s), ends with je to 0x00453c56 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00453b46
    cmp dword ptr [ecx + field_18], 0x0          # 00453b49
    je.d32 L_00453c56                            # 00453b4d
    # block 0x00453b53: entered by fall-through of je at 0x00453b4d, 5 instruction(s), ends with je to 0x00453c23 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00453b53
    mov eax, dword ptr [edx + field_8]           # 00453b56
    movsx ecx, word ptr [eax + field_46c]        # 00453b59
    cmp ecx, 0x270f                              # 00453b60
    je.d32 L_00453c23                            # 00453b66
    # block 0x00453b6c: entered by fall-through of je at 0x00453b66, 33 instruction(s), ends with jne to 0x00453c0f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00453b6c
    mov eax, dword ptr [edx + field_8]           # 00453b6f
    movsx ecx, word ptr [eax + field_46c]        # 00453b72
    mov dword ptr [0x5bb57b], ecx                # 00453b79
    mov edx, dword ptr [ebp - local_4]           # 00453b7f
    mov eax, dword ptr [edx + field_8]           # 00453b82
    mov cx, word ptr [eax + field_46e]           # 00453b85
    mov word ptr [0x5bb599], cx                  # 00453b8c
    mov edx, dword ptr [ebp - local_4]           # 00453b93
    mov eax, dword ptr [edx + field_8]           # 00453b96
    mov cx, word ptr [eax + field_470]           # 00453b99
    mov word ptr [0x5bb595], cx                  # 00453ba0
    mov edx, dword ptr [ebp - local_4]           # 00453ba7
    mov eax, dword ptr [edx + field_8]           # 00453baa
    mov cx, word ptr [eax + field_472]           # 00453bad
    mov word ptr [0x5c39ff], cx                  # 00453bb4
    mov edx, dword ptr [ebp - local_4]           # 00453bbb
    mov eax, dword ptr [edx + field_8]           # 00453bbe
    mov ecx, dword ptr [eax + field_474]         # 00453bc1
    mov dword ptr [0x5bb59b], ecx                # 00453bc7
    mov edx, dword ptr [ebp - local_4]           # 00453bcd
    mov eax, dword ptr [edx + field_8]           # 00453bd0
    mov ecx, dword ptr [eax + field_478]         # 00453bd3
    mov dword ptr [0x5bb59f], ecx                # 00453bd9
    mov edx, dword ptr [ebp - local_4]           # 00453bdf
    mov eax, dword ptr [edx + field_8]           # 00453be2
    mov ecx, dword ptr [eax + field_47c]         # 00453be5
    mov dword ptr [0x5bb5a3], ecx                # 00453beb
    mov edx, dword ptr [ebp - local_4]           # 00453bf1
    mov eax, dword ptr [edx + field_8]           # 00453bf4
    movsx ecx, word ptr [eax + field_480]        # 00453bf7
    cmp ecx, 0x1                                 # 00453bfe
    jne.d8 L_00453c0f                            # 00453c01
    # block 0x00453c03: entered by fall-through of jne at 0x00453c01, 2 instruction(s), ends with forward jump to 0x00453c19
    mov dword ptr [0x5bb1ca], 0x0                # 00453c03
    jmp.d8 L_00453c19                            # 00453c0d
L_00453c0f:
    # block 0x00453c0f: entered by jne at 0x00453c01, 1 instruction(s), falls into the block at 0x00453c19
    mov dword ptr [0x5bb1ca], 0x1                # 00453c0f
L_00453c19:
    # block 0x00453c19: entered by jmp at 0x00453c0d, 1 instruction(s), falls into the block at 0x00453c23
    mov dword ptr [0x583999], 0x4                # 00453c19
L_00453c23:
    # block 0x00453c23: entered by je at 0x00453b66, 5 instruction(s), ends with je to 0x00453c56 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00453c23
    mov eax, dword ptr [edx + field_8]           # 00453c26
    movsx ecx, word ptr [eax + field_482]        # 00453c29
    cmp ecx, -0x1                                # 00453c30
    je.d8 L_00453c56                             # 00453c33
    # block 0x00453c35: entered by fall-through of je at 0x00453c33, 7 instruction(s), falls into the block at 0x00453c56
    mov edx, dword ptr [ebp - local_4]           # 00453c35
    mov eax, dword ptr [edx + field_8]           # 00453c38
    movsx ecx, word ptr [eax + field_484]        # 00453c3b
    mov edx, dword ptr [ebp - local_4]           # 00453c42
    mov eax, dword ptr [edx + field_8]           # 00453c45
    movsx edx, word ptr [eax + field_482]        # 00453c48
    mov dword ptr [4*edx + 0x585801], ecx        # 00453c4f
L_00453c56:
    # block 0x00453c56: entered by je at 0x00453b4d; je at 0x00453c33, 7 instruction(s), calls FUN_0042ba3a, FUN_0044f996, falls into the block at 0x00453c6e
    mov eax, dword ptr [ebp - local_4]           # 00453c56
    mov cx, word ptr [eax + field_6]             # 00453c59
    push ecx                                     # 00453c5d
    call FUN_0042ba3a                            # 00453c5e
    add esp, 0x4                                 # 00453c63
    mov ecx, dword ptr [ebp - local_4]           # 00453c66
    call FUN_0044f996                            # 00453c69
L_00453c6e:
    # block 0x00453c6e: entered by jmp at 0x004525c4; jmp at 0x00453605; jmp at 0x00453a0d, 1 instruction(s), ends with forward jump to 0x00453cbe
    jmp.d8 L_00453cbe                            # 00453c6e
L_00453c70:
    # block 0x00453c70: entered by jmp at 0x00453cb8; jmp at 0x00453cba; jmp at 0x00453cbc, 8 instruction(s), ends with je to 0x00453cac (forward)
    mov edi, 0x63888b                            # 00453c70
    or ecx, -0x1                                 # 00453c75
    {load} xor eax, eax                          # 00453c78
    repne scasb al, byte ptr es:[edi]            # 00453c7a
    not ecx                                      # 00453c7c
    add ecx, -0x1                                # 00453c7e
    test ecx, ecx                                # 00453c81
    je.d8 L_00453cac                             # 00453c83
    # block 0x00453c85: entered by fall-through of je at 0x00453c83, 6 instruction(s), calls FUN_004264e8, ends with je to 0x00453cac (forward)
    push 0x63888b                                # 00453c85
    mov ecx, 0x583979                            # 00453c8a
    call FUN_004264e8                            # 00453c8f
    movsx edx, word ptr [0x63a4cd]               # 00453c94
    test edx, edx                                # 00453c9b
    je.d8 L_00453cac                             # 00453c9d
    # block 0x00453c9f: entered by fall-through of je at 0x00453c9d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00453cac
    push 0x63888b                                # 00453c9f
    call FUN_0044a2b7                            # 00453ca4
    add esp, 0x4                                 # 00453ca9
L_00453cac:
    # block 0x00453cac: entered by je at 0x00453c83; je at 0x00453c9d, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00453cbe
    mov ecx, 0x5cf659                            # 00453cac
    call FUN_004c97b4                            # 00453cb1
    jmp.d8 L_00453cbe                            # 00453cb6
L_00453cb8:
    # block 0x00453cb8: entered by jmp at 0x0045291b, 1 instruction(s), ends with backward jump to 0x00453c70
    jmp.d8 L_00453c70                            # 00453cb8
L_00453cba:
    # block 0x00453cba: entered by jmp at 0x00452810, 1 instruction(s), ends with backward jump to 0x00453c70
    jmp.d8 L_00453c70                            # 00453cba
L_00453cbc:
    # block 0x00453cbc: entered by jmp at 0x00452709, 1 instruction(s), ends with backward jump to 0x00453c70
    jmp.d8 L_00453c70                            # 00453cbc
L_00453cbe:
    # block 0x00453cbe: entered by jmp at 0x00453c6e; jmp at 0x00453cb6, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00453cbe
    pop esi                                      # 00453cbf
    {load} mov esp, ebp                          # 00453cc0
    pop ebp                                      # 00453cc2
    ret 0x4                                      # 00453cc3

# --- data items (not part of the function) -------------------------
.org 0x00453cc6 - 0x401000
SWTAB_00453cc6:  # 7 case address(es)
    .long L_00453627 - .text + 0x401000
    .long L_00453836 - .text + 0x401000
    .long L_004538c2 - .text + 0x401000
    .long L_00453992 - .text + 0x401000
    .long L_004537aa - .text + 0x401000
    .long L_004539d8 - .text + 0x401000
    .long L_0045394e - .text + 0x401000
.set SWTAB_00453cc6_VA, SWTAB_00453cc6 - .text + 0x401000

