# FUN_004695f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004695f7
# extent:       0x004695f7-0x0046a976 (4991 code bytes)
# span:         0x004695f7-0x0046a98e (code 4991, tables 24, padding 0)
# sha256:       bc75d750fbc9dfa26ff04a75f941d81f9c2e6797d7816ca706996e1ed1cd0141
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004695f7
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       43 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 31 more
# fields:       [eax + n] field_4, field_31, field_45, field_4d, field_51, field_53, field_55, field_7c, field_7e, field_80, field_88, field_8c and 19 more; [ecx + n] field_4, field_8, field_c, field_3d, field_41, field_49, field_51, field_53, field_55, field_7c, field_7e, field_80 and 20 more; [edx + n] field_2, field_35, field_39, field_41, field_45, field_49, field_4d, field_53, field_55, field_7c, field_7e, field_84 and 25 more; [esi + n] field_1, field_560, field_584
# callees:      calls FUN_004e8d96, FUN_0050ce04, FUN_0046a98e, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_00469259, FUN_00469374, FUN_004fb2e3, FUN_004dadff, FUN_00469505, FUN_004fba69, FUN_004f6334, FUN_0042ba3a, FUN_00468f19
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1117 instruction(s), 43 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_7e, 0x7e  # offset -0x7e
.equ local_80, 0x80  # offset -0x80
.equ local_82, 0x82  # offset -0x82
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_55, 0x55  # offset +0x55
.equ field_7c, 0x7c  # offset +0x7c
.equ field_7e, 0x7e  # offset +0x7e
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_85, 0x85  # offset +0x85
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_e0, 0xe0  # offset +0xe0
.equ field_f8, 0xf8  # offset +0xf8
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c
.equ field_160, 0x160  # offset +0x160
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_445, 0x445  # offset +0x445
.equ field_469, 0x469  # offset +0x469
.equ field_48a, 0x48a  # offset +0x48a
.equ field_4fc, 0x4fc  # offset +0x4fc
.equ field_52c, 0x52c  # offset +0x52c
.equ field_530, 0x530  # offset +0x530
.equ field_548, 0x548  # offset +0x548
.equ field_54a, 0x54a  # offset +0x54a
.equ field_54e, 0x54e  # offset +0x54e
.equ field_554, 0x554  # offset +0x554
.equ field_556, 0x556  # offset +0x556
.equ field_558, 0x558  # offset +0x558
.equ field_55a, 0x55a  # offset +0x55a
.equ field_55c, 0x55c  # offset +0x55c
.equ field_560, 0x560  # offset +0x560
.equ field_564, 0x564  # offset +0x564
.equ field_568, 0x568  # offset +0x568
.equ field_56a, 0x56a  # offset +0x56a
.equ field_56c, 0x56c  # offset +0x56c
.equ field_584, 0x584  # offset +0x584
.equ field_588, 0x588  # offset +0x588
.equ field_58c, 0x58c  # offset +0x58c
.equ field_58e, 0x58e  # offset +0x58e
.equ field_590, 0x590  # offset +0x590
.equ field_592, 0x592  # offset +0x592
.equ field_594, 0x594  # offset +0x594
.equ field_596, 0x596  # offset +0x596
.equ field_59a, 0x59a  # offset +0x59a
.equ field_59e, 0x59e  # offset +0x59e
.equ field_5a2, 0x5a2  # offset +0x5a2
.equ field_5a8, 0x5a8  # offset +0x5a8
.equ field_5c5, 0x5c5  # offset +0x5c5

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00468f19, .text + (0x00468f19 - 0x401000)
.set FUN_00469259, .text + (0x00469259 - 0x401000)
.set FUN_00469374, .text + (0x00469374 - 0x401000)
.set FUN_00469505, .text + (0x00469505 - 0x401000)
.set FUN_0046a98e, .text + (0x0046a98e - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004695f7 - 0x401000
.globl FUN_004695f7
FUN_004695f7:
    # block 0x004695f7: entry, 12 instruction(s), ends with je to 0x00469637 (forward)
    push ebp                                     # 004695f7
    {load} mov ebp, esp                          # 004695f8
    sub esp, 0xa4                                # 004695fa
    push esi                                     # 00469600
    push edi                                     # 00469601
    mov dword ptr [ebp - local_14], ecx          # 00469602
    movsx eax, word ptr [ebp + arg_8]            # 00469605
    imul eax, eax, 0x8d                          # 00469609
    mov ecx, dword ptr [eax + 0x5bb632]          # 0046960f
    mov dword ptr [ebp - local_18], ecx          # 00469615
    cmp dword ptr [ebp - local_18], 0x0          # 00469618
    je.d8 L_00469637                             # 0046961c
    # block 0x0046961e: entered by fall-through of je at 0x0046961c, 2 instruction(s), ends with je to 0x0046a0f0 (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 0046961e
    je.d32 L_0046a0f0                            # 00469622
    # block 0x00469628: entered by fall-through of je at 0x00469622, 2 instruction(s), ends with je to 0x0046a7bf (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 00469628
    je.d32 L_0046a7bf                            # 0046962c
    # block 0x00469632: entered by fall-through of je at 0x0046962c, 1 instruction(s), ends with forward jump to 0x0046a96e
    jmp.d32 L_0046a96e                           # 00469632
L_00469637:
    # block 0x00469637: entered by je at 0x0046961c, 13 instruction(s), calls FUN_004e8d96, ends with jne to 0x00469704 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00469637
    mov dword ptr [edx + field_55c], 0x1         # 0046963a
    mov eax, dword ptr [ebp - local_14]          # 00469644
    mov dword ptr [eax + field_158], 0x1         # 00469647
    mov dword ptr [0x5bb1ca], 0x1                # 00469651
    mov ecx, dword ptr [ebp - local_14]          # 0046965b
    mov dx, word ptr [ebp + arg_8]               # 0046965e
    mov word ptr [ecx + field_7e], dx            # 00469662
    mov ecx, 0x571442                            # 00469666
    call FUN_004e8d96                            # 0046966b
    movsx eax, word ptr [0x5919da]               # 00469670
    test eax, eax                                # 00469677
    jne.d32 L_00469704                           # 00469679
    # block 0x0046967f: entered by fall-through of jne at 0x00469679, 2 instruction(s), ends with forward jump to 0x00469693
    mov word ptr [ebp - local_c], 0x0            # 0046967f
    jmp.d8 L_00469693                            # 00469685
L_00469687:
    # block 0x00469687: entered by jmp at 0x004696e5, 3 instruction(s), falls into the block at 0x00469693
    mov cx, word ptr [ebp - local_c]             # 00469687
    add cx, 0x1                                  # 0046968b
    mov word ptr [ebp - local_c], cx             # 0046968f
L_00469693:
    # block 0x00469693: entered by jmp at 0x00469685, 3 instruction(s), ends with jge to 0x004696e7 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00469693
    cmp edx, 0x6                                 # 00469697
    jge.d8 L_004696e7                            # 0046969a
    # block 0x0046969c: entered by fall-through of jge at 0x0046969a, 17 instruction(s), ends with backward jump to 0x00469687
    mov eax, dword ptr [ebp - local_14]          # 0046969c
    movsx ecx, word ptr [eax + field_7e]         # 0046969f
    imul ecx, ecx, 0x8d                          # 004696a3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004696a9
    movsx eax, word ptr [0x58c94f]               # 004696af
    imul eax, eax, 0xc                           # 004696b6
    lea ecx, [edx + eax + field_445]             # 004696b9
    movsx edx, word ptr [ebp - local_c]          # 004696c0
    movsx eax, word ptr [ecx + 2*edx]            # 004696c4
    mov dword ptr [ebp - local_1c], eax          # 004696c8
    fild dword ptr [ebp - local_1c]              # 004696cb
    fstp dword ptr [ebp - local_20]              # 004696ce
    fld dword ptr [ebp - local_20]               # 004696d1
    fdiv dword ptr [0x52cbec]                    # 004696d4
    movsx ecx, word ptr [ebp - local_c]          # 004696da
    fstp dword ptr [4*ecx + 0x5919dc]            # 004696de
    jmp.d8 L_00469687                            # 004696e5
L_004696e7:
    # block 0x004696e7: entered by jge at 0x0046969a, 3 instruction(s), falls into the block at 0x00469704
    mov dword ptr [0x5919f4], 0x0                # 004696e7
    mov dword ptr [0x5919f8], 0x0                # 004696f1
    mov word ptr [0x5919da], 0x1                 # 004696fb
L_00469704:
    # block 0x00469704: entered by jne at 0x00469679, 2 instruction(s), ends with forward jump to 0x00469718
    mov word ptr [ebp - local_c], 0x0            # 00469704
    jmp.d8 L_00469718                            # 0046970a
L_0046970c:
    # block 0x0046970c: entered by jmp at 0x00469775, 3 instruction(s), falls into the block at 0x00469718
    mov dx, word ptr [ebp - local_c]             # 0046970c
    add dx, 0x1                                  # 00469710
    mov word ptr [ebp - local_c], dx             # 00469714
L_00469718:
    # block 0x00469718: entered by jmp at 0x0046970a, 3 instruction(s), ends with jge to 0x00469777 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00469718
    cmp eax, 0x6                                 # 0046971c
    jge.d8 L_00469777                            # 0046971f
    # block 0x00469721: entered by fall-through of jge at 0x0046971f, 21 instruction(s), ends with backward jump to 0x0046970c
    mov ecx, dword ptr [ebp - local_14]          # 00469721
    movsx edx, word ptr [ecx + field_7e]         # 00469724
    imul edx, edx, 0x8d                          # 00469728
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046972e
    movsx ecx, word ptr [ebp - local_c]          # 00469734
    imul ecx, ecx, 0x6                           # 00469738
    movsx edx, word ptr [eax + ecx + field_53]   # 0046973b
    mov eax, dword ptr [ebp - local_14]          # 00469740
    movsx ecx, word ptr [eax + field_7e]         # 00469743
    imul ecx, ecx, 0x8d                          # 00469747
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0046974d
    movsx ecx, word ptr [ebp - local_c]          # 00469753
    imul ecx, ecx, 0x6                           # 00469757
    movsx eax, word ptr [eax + ecx + field_55]   # 0046975a
    {load} sub edx, eax                          # 0046975f
    mov dword ptr [ebp - local_24], edx          # 00469761
    fild dword ptr [ebp - local_24]              # 00469764
    movsx ecx, word ptr [ebp - local_c]          # 00469767
    mov edx, dword ptr [ebp - local_14]          # 0046976b
    fstp dword ptr [edx + 4*ecx + field_530]     # 0046976e
    jmp.d8 L_0046970c                            # 00469775
L_00469777:
    # block 0x00469777: entered by jge at 0x0046971f, 2 instruction(s), ends with forward jump to 0x0046978b
    mov word ptr [ebp - local_c], 0x0            # 00469777
    jmp.d8 L_0046978b                            # 0046977d
L_0046977f:
    # block 0x0046977f: entered by jmp at 0x00469a1a, 3 instruction(s), falls into the block at 0x0046978b
    mov ax, word ptr [ebp - local_c]             # 0046977f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00469783
    mov word ptr [ebp - local_c], ax             # 00469787
L_0046978b:
    # block 0x0046978b: entered by jmp at 0x0046977d, 3 instruction(s), ends with jge to 0x00469a1f (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0046978b
    cmp ecx, 0x6                                 # 0046978f
    jge.d32 L_00469a1f                           # 00469792
    # block 0x00469798: entered by fall-through of jge at 0x00469792, 153 instruction(s), calls FUN_0050ce04, ends with backward jump to 0x0046977f
    mov edx, dword ptr [ebp - local_14]          # 00469798
    movsx eax, word ptr [edx + field_7e]         # 0046979b
    imul eax, eax, 0x8d                          # 0046979f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004697a5
    movsx edx, word ptr [ebp - local_c]          # 004697ab
    imul edx, edx, 0x6                           # 004697af
    movsx esi, word ptr [ecx + edx + field_55]   # 004697b2
    mov eax, dword ptr [ebp - local_14]          # 004697b7
    movsx ecx, word ptr [eax + field_7e]         # 004697ba
    imul ecx, ecx, 0x8d                          # 004697be
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004697c4
    fild dword ptr [edx + field_4d]              # 004697ca
    fstp dword ptr [ebp - local_28]              # 004697cd
    mov eax, dword ptr [ebp - local_14]          # 004697d0
    movsx ecx, word ptr [eax + field_7e]         # 004697d3
    imul ecx, ecx, 0x8d                          # 004697d7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004697dd
    fild dword ptr [edx + field_45]              # 004697e3
    fstp dword ptr [ebp - local_2c]              # 004697e6
    fld dword ptr [ebp - local_28]               # 004697e9
    fsub dword ptr [ebp - local_2c]              # 004697ec
    fdiv qword ptr [0x52c678]                    # 004697ef
    call FUN_0050ce04                            # 004697f5
    movsx eax, ax                                # 004697fa
    {load} sub esi, eax                          # 004697fd
    movsx ecx, word ptr [ebp - local_c]          # 004697ff
    shl ecx, 0x4                                 # 00469803
    mov edx, dword ptr [ebp - local_14]          # 00469806
    mov dword ptr [edx + ecx + field_84], esi    # 00469809
    mov eax, dword ptr [ebp - local_14]          # 00469810
    movsx ecx, word ptr [eax + field_7e]         # 00469813
    imul ecx, ecx, 0x8d                          # 00469817
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046981d
    movsx eax, word ptr [ebp - local_c]          # 00469823
    imul eax, eax, 0x6                           # 00469827
    movsx esi, word ptr [edx + eax + field_53]   # 0046982a
    mov ecx, dword ptr [ebp - local_14]          # 0046982f
    movsx edx, word ptr [ecx + field_7e]         # 00469832
    imul edx, edx, 0x8d                          # 00469836
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046983c
    fild dword ptr [eax + field_4d]              # 00469842
    fstp dword ptr [ebp - local_30]              # 00469845
    mov ecx, dword ptr [ebp - local_14]          # 00469848
    movsx edx, word ptr [ecx + field_7e]         # 0046984b
    imul edx, edx, 0x8d                          # 0046984f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469855
    fild dword ptr [eax + field_45]              # 0046985b
    fstp dword ptr [ebp - local_34]              # 0046985e
    fld dword ptr [ebp - local_30]               # 00469861
    fsub dword ptr [ebp - local_34]              # 00469864
    fdiv qword ptr [0x52c678]                    # 00469867
    call FUN_0050ce04                            # 0046986d
    movsx ecx, ax                                # 00469872
    {load} add esi, ecx                          # 00469875
    movsx edx, word ptr [ebp - local_c]          # 00469877
    shl edx, 0x4                                 # 0046987b
    mov eax, dword ptr [ebp - local_14]          # 0046987e
    mov dword ptr [eax + edx + field_8c], esi    # 00469881
    mov ecx, dword ptr [ebp - local_14]          # 00469888
    movsx edx, word ptr [ecx + field_7e]         # 0046988b
    imul edx, edx, 0x8d                          # 0046988f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469895
    movsx ecx, word ptr [ebp - local_c]          # 0046989b
    imul ecx, ecx, 0x6                           # 0046989f
    movsx esi, word ptr [eax + ecx + field_51]   # 004698a2
    mov edx, dword ptr [ebp - local_14]          # 004698a7
    movsx eax, word ptr [edx + field_7e]         # 004698aa
    imul eax, eax, 0x8d                          # 004698ae
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004698b4
    fild dword ptr [ecx + field_49]              # 004698ba
    fstp dword ptr [ebp - local_38]              # 004698bd
    mov edx, dword ptr [ebp - local_14]          # 004698c0
    movsx eax, word ptr [edx + field_7e]         # 004698c3
    imul eax, eax, 0x8d                          # 004698c7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004698cd
    fild dword ptr [ecx + field_41]              # 004698d3
    fstp dword ptr [ebp - local_3c]              # 004698d6
    fld dword ptr [ebp - local_38]               # 004698d9
    fsub dword ptr [ebp - local_3c]              # 004698dc
    fdiv qword ptr [0x52c678]                    # 004698df
    call FUN_0050ce04                            # 004698e5
    movsx edx, ax                                # 004698ea
    {load} sub esi, edx                          # 004698ed
    movsx eax, word ptr [ebp - local_c]          # 004698ef
    shl eax, 0x4                                 # 004698f3
    mov ecx, dword ptr [ebp - local_14]          # 004698f6
    mov dword ptr [ecx + eax + field_80], esi    # 004698f9
    mov edx, dword ptr [ebp - local_14]          # 00469900
    movsx eax, word ptr [edx + field_7e]         # 00469903
    imul eax, eax, 0x8d                          # 00469907
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046990d
    movsx edx, word ptr [ebp - local_c]          # 00469913
    imul edx, edx, 0x6                           # 00469917
    movsx esi, word ptr [ecx + edx + field_51]   # 0046991a
    mov eax, dword ptr [ebp - local_14]          # 0046991f
    movsx ecx, word ptr [eax + field_7e]         # 00469922
    imul ecx, ecx, 0x8d                          # 00469926
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046992c
    fild dword ptr [edx + field_49]              # 00469932
    fstp dword ptr [ebp - local_40]              # 00469935
    mov eax, dword ptr [ebp - local_14]          # 00469938
    movsx ecx, word ptr [eax + field_7e]         # 0046993b
    imul ecx, ecx, 0x8d                          # 0046993f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469945
    fild dword ptr [edx + field_41]              # 0046994b
    fstp dword ptr [ebp - local_44]              # 0046994e
    fld dword ptr [ebp - local_40]               # 00469951
    fsub dword ptr [ebp - local_44]              # 00469954
    fdiv qword ptr [0x52c678]                    # 00469957
    call FUN_0050ce04                            # 0046995d
    movsx eax, ax                                # 00469962
    lea ecx, [esi + eax + field_1]               # 00469965
    movsx edx, word ptr [ebp - local_c]          # 00469969
    shl edx, 0x4                                 # 0046996d
    mov eax, dword ptr [ebp - local_14]          # 00469970
    mov dword ptr [eax + edx + field_88], ecx    # 00469973
    movsx ecx, word ptr [ebp - local_c]          # 0046997a
    shl ecx, 0x4                                 # 0046997e
    mov edx, dword ptr [ebp - local_14]          # 00469981
    mov eax, dword ptr [edx + ecx + field_84]    # 00469984
    add eax, dword ptr [0x58318a]                # 0046998b
    movsx ecx, word ptr [ebp - local_c]          # 00469991
    shl ecx, 0x4                                 # 00469995
    mov edx, dword ptr [ebp - local_14]          # 00469998
    mov dword ptr [edx + ecx + field_fc], eax    # 0046999b
    movsx eax, word ptr [ebp - local_c]          # 004699a2
    shl eax, 0x4                                 # 004699a6
    mov ecx, dword ptr [ebp - local_14]          # 004699a9
    mov edx, dword ptr [ecx + eax + field_8c]    # 004699ac
    add edx, dword ptr [0x58318a]                # 004699b3
    movsx eax, word ptr [ebp - local_c]          # 004699b9
    shl eax, 0x4                                 # 004699bd
    mov ecx, dword ptr [ebp - local_14]          # 004699c0
    mov dword ptr [ecx + eax + field_104], edx   # 004699c3
    movsx edx, word ptr [ebp - local_c]          # 004699ca
    shl edx, 0x4                                 # 004699ce
    mov eax, dword ptr [ebp - local_14]          # 004699d1
    mov ecx, dword ptr [eax + edx + field_80]    # 004699d4
    add ecx, dword ptr [0x583186]                # 004699db
    movsx edx, word ptr [ebp - local_c]          # 004699e1
    shl edx, 0x4                                 # 004699e5
    mov eax, dword ptr [ebp - local_14]          # 004699e8
    mov dword ptr [eax + edx + field_f8], ecx    # 004699eb
    movsx ecx, word ptr [ebp - local_c]          # 004699f2
    shl ecx, 0x4                                 # 004699f6
    mov edx, dword ptr [ebp - local_14]          # 004699f9
    mov eax, dword ptr [edx + ecx + field_88]    # 004699fc
    add eax, dword ptr [0x583186]                # 00469a03
    movsx ecx, word ptr [ebp - local_c]          # 00469a09
    shl ecx, 0x4                                 # 00469a0d
    mov edx, dword ptr [ebp - local_14]          # 00469a10
    mov dword ptr [edx + ecx + field_100], eax   # 00469a13
    jmp.d32 L_0046977f                           # 00469a1a
L_00469a1f:
    # block 0x00469a1f: entered by jge at 0x00469792, 34 instruction(s), ends with forward jump to 0x00469ac7
    mov eax, dword ptr [ebp - local_14]          # 00469a1f
    movsx ecx, word ptr [eax + field_7e]         # 00469a22
    imul ecx, ecx, 0x8d                          # 00469a26
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469a2c
    mov eax, dword ptr [edx + field_35]          # 00469a32
    add eax, dword ptr [0x58318a]                # 00469a35
    mov ecx, dword ptr [ebp - local_14]          # 00469a3b
    mov dword ptr [ecx + field_160], eax         # 00469a3e
    mov edx, dword ptr [ebp - local_14]          # 00469a44
    movsx eax, word ptr [edx + field_7e]         # 00469a47
    imul eax, eax, 0x8d                          # 00469a4b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00469a51
    mov edx, dword ptr [ecx + field_3d]          # 00469a57
    add edx, dword ptr [0x58318a]                # 00469a5a
    mov eax, dword ptr [ebp - local_14]          # 00469a60
    mov dword ptr [eax + field_168], edx         # 00469a63
    mov ecx, dword ptr [ebp - local_14]          # 00469a69
    movsx edx, word ptr [ecx + field_7e]         # 00469a6c
    imul edx, edx, 0x8d                          # 00469a70
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469a76
    mov ecx, dword ptr [eax + field_31]          # 00469a7c
    add ecx, dword ptr [0x583186]                # 00469a7f
    mov edx, dword ptr [ebp - local_14]          # 00469a85
    mov dword ptr [edx + field_15c], ecx         # 00469a88
    mov eax, dword ptr [ebp - local_14]          # 00469a8e
    movsx ecx, word ptr [eax + field_7e]         # 00469a91
    imul ecx, ecx, 0x8d                          # 00469a95
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469a9b
    mov eax, dword ptr [edx + field_39]          # 00469aa1
    add eax, dword ptr [0x583186]                # 00469aa4
    mov ecx, dword ptr [ebp - local_14]          # 00469aaa
    mov dword ptr [ecx + field_164], eax         # 00469aad
    mov word ptr [ebp - local_c], 0x0            # 00469ab3
    jmp.d8 L_00469ac7                            # 00469ab9
L_00469abb:
    # block 0x00469abb: entered by jmp at 0x00469c48, 3 instruction(s), falls into the block at 0x00469ac7
    mov dx, word ptr [ebp - local_c]             # 00469abb
    add dx, 0x1                                  # 00469abf
    mov word ptr [ebp - local_c], dx             # 00469ac3
L_00469ac7:
    # block 0x00469ac7: entered by jmp at 0x00469ab9, 3 instruction(s), ends with jge to 0x00469c4d (forward)
    movsx eax, word ptr [ebp - local_c]          # 00469ac7
    cmp eax, 0x6                                 # 00469acb
    jge.d32 L_00469c4d                           # 00469ace
    # block 0x00469ad4: entered by fall-through of jge at 0x00469ace, 2 instruction(s), ends with forward jump to 0x00469ae8
    mov word ptr [ebp - local_8], 0x0            # 00469ad4
    jmp.d8 L_00469ae8                            # 00469ada
L_00469adc:
    # block 0x00469adc: entered by jmp at 0x00469c43, 3 instruction(s), falls into the block at 0x00469ae8
    mov cx, word ptr [ebp - local_8]             # 00469adc
    add cx, 0x1                                  # 00469ae0
    mov word ptr [ebp - local_8], cx             # 00469ae4
L_00469ae8:
    # block 0x00469ae8: entered by jmp at 0x00469ada, 3 instruction(s), ends with jge to 0x00469c48 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00469ae8
    cmp edx, 0xa                                 # 00469aec
    jge.d32 L_00469c48                           # 00469aef
    # block 0x00469af5: entered by fall-through of jge at 0x00469aef, 73 instruction(s), ends with backward jump to 0x00469adc
    mov eax, dword ptr [ebp - local_14]          # 00469af5
    movsx ecx, word ptr [eax + field_7e]         # 00469af8
    imul ecx, ecx, 0x8d                          # 00469afc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469b02
    movsx eax, word ptr [ebp - local_c]          # 00469b08
    imul eax, eax, 0xa0                          # 00469b0c
    lea ecx, [edx + eax + field_85]              # 00469b12
    movsx edx, word ptr [ebp - local_8]          # 00469b19
    shl edx, 0x4                                 # 00469b1d
    mov eax, dword ptr [ecx + edx + field_4]     # 00469b20
    add eax, dword ptr [0x58318a]                # 00469b24
    movsx ecx, word ptr [ebp - local_c]          # 00469b2a
    imul ecx, ecx, 0xa0                          # 00469b2e
    mov edx, dword ptr [ebp - local_14]          # 00469b34
    lea ecx, [edx + ecx + field_16c]             # 00469b37
    movsx edx, word ptr [ebp - local_8]          # 00469b3e
    shl edx, 0x4                                 # 00469b42
    mov dword ptr [ecx + edx + field_4], eax     # 00469b45
    mov eax, dword ptr [ebp - local_14]          # 00469b49
    movsx ecx, word ptr [eax + field_7e]         # 00469b4c
    imul ecx, ecx, 0x8d                          # 00469b50
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469b56
    movsx eax, word ptr [ebp - local_c]          # 00469b5c
    imul eax, eax, 0xa0                          # 00469b60
    lea ecx, [edx + eax + field_85]              # 00469b66
    movsx edx, word ptr [ebp - local_8]          # 00469b6d
    shl edx, 0x4                                 # 00469b71
    mov eax, dword ptr [ecx + edx + field_c]     # 00469b74
    add eax, dword ptr [0x58318a]                # 00469b78
    movsx ecx, word ptr [ebp - local_c]          # 00469b7e
    imul ecx, ecx, 0xa0                          # 00469b82
    mov edx, dword ptr [ebp - local_14]          # 00469b88
    lea ecx, [edx + ecx + field_16c]             # 00469b8b
    movsx edx, word ptr [ebp - local_8]          # 00469b92
    shl edx, 0x4                                 # 00469b96
    mov dword ptr [ecx + edx + field_c], eax     # 00469b99
    mov eax, dword ptr [ebp - local_14]          # 00469b9d
    movsx ecx, word ptr [eax + field_7e]         # 00469ba0
    imul ecx, ecx, 0x8d                          # 00469ba4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469baa
    movsx eax, word ptr [ebp - local_c]          # 00469bb0
    imul eax, eax, 0xa0                          # 00469bb4
    lea ecx, [edx + eax + field_85]              # 00469bba
    movsx edx, word ptr [ebp - local_8]          # 00469bc1
    shl edx, 0x4                                 # 00469bc5
    mov eax, dword ptr [ecx + edx]               # 00469bc8
    add eax, dword ptr [0x583186]                # 00469bcb
    movsx ecx, word ptr [ebp - local_c]          # 00469bd1
    imul ecx, ecx, 0xa0                          # 00469bd5
    mov edx, dword ptr [ebp - local_14]          # 00469bdb
    lea ecx, [edx + ecx + field_16c]             # 00469bde
    movsx edx, word ptr [ebp - local_8]          # 00469be5
    shl edx, 0x4                                 # 00469be9
    mov dword ptr [ecx + edx], eax               # 00469bec
    mov eax, dword ptr [ebp - local_14]          # 00469bef
    movsx ecx, word ptr [eax + field_7e]         # 00469bf2
    imul ecx, ecx, 0x8d                          # 00469bf6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469bfc
    movsx eax, word ptr [ebp - local_c]          # 00469c02
    imul eax, eax, 0xa0                          # 00469c06
    lea ecx, [edx + eax + field_85]              # 00469c0c
    movsx edx, word ptr [ebp - local_8]          # 00469c13
    shl edx, 0x4                                 # 00469c17
    mov eax, dword ptr [ecx + edx + field_8]     # 00469c1a
    add eax, dword ptr [0x583186]                # 00469c1e
    movsx ecx, word ptr [ebp - local_c]          # 00469c24
    imul ecx, ecx, 0xa0                          # 00469c28
    mov edx, dword ptr [ebp - local_14]          # 00469c2e
    lea ecx, [edx + ecx + field_16c]             # 00469c31
    movsx edx, word ptr [ebp - local_8]          # 00469c38
    shl edx, 0x4                                 # 00469c3c
    mov dword ptr [ecx + edx + field_8], eax     # 00469c3f
    jmp.d32 L_00469adc                           # 00469c43
L_00469c48:
    # block 0x00469c48: entered by jge at 0x00469aef, 1 instruction(s), ends with backward jump to 0x00469abb
    jmp.d32 L_00469abb                           # 00469c48
L_00469c4d:
    # block 0x00469c4d: entered by jge at 0x00469ace, 8 instruction(s), calls FUN_0046a98e, FUN_004d39f9, ends with jne to 0x00469ca0 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00469c4d
    call FUN_0046a98e                            # 00469c50
    call FUN_004d39f9                            # 00469c55
    mov ecx, dword ptr [ebp - local_14]          # 00469c5a
    mov word ptr [ecx + field_7c], ax            # 00469c5d
    mov edx, dword ptr [ebp - local_14]          # 00469c61
    cmp dword ptr [edx + field_52c], 0x0         # 00469c64
    jne.d8 L_00469ca0                            # 00469c6b
    # block 0x00469c6d: entered by fall-through of jne at 0x00469c6b, 12 instruction(s), calls FUN_004c2790, falls into the block at 0x00469ca0
    push 0x54b9f8                                # 00469c6d
    push 0x6                                     # 00469c72
    mov eax, dword ptr [ebp - local_14]          # 00469c74
    movsx ecx, word ptr [eax + field_7e]         # 00469c77
    imul ecx, ecx, 0x8d                          # 00469c7b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469c81
    push edx                                     # 00469c87
    push 0x54ba14                                # 00469c88
    mov ecx, 0x5cf659                            # 00469c8d
    call FUN_004c2790                            # 00469c92
    mov ecx, dword ptr [ebp - local_14]          # 00469c97
    mov dword ptr [ecx + field_52c], eax         # 00469c9a
L_00469ca0:
    # block 0x00469ca0: entered by jne at 0x00469c6b, 55 instruction(s), ends with forward jump to 0x00469d8b
    mov edx, dword ptr [ebp - local_14]          # 00469ca0
    movsx eax, word ptr [edx + field_7c]         # 00469ca3
    imul eax, eax, 0x4a                          # 00469ca7
    mov dword ptr [eax + 0x5d1591], 0xa          # 00469caa
    mov ecx, dword ptr [ebp - local_14]          # 00469cb4
    movsx edx, word ptr [ecx + field_7c]         # 00469cb7
    imul edx, edx, 0x4a                          # 00469cbb
    mov dword ptr [edx + 0x5d1595], 0x46ab7f     # 00469cbe
    mov eax, dword ptr [ebp - local_14]          # 00469cc8
    movsx ecx, word ptr [eax + field_7c]         # 00469ccb
    imul ecx, ecx, 0x4a                          # 00469ccf
    mov edx, dword ptr [ebp - local_14]          # 00469cd2
    mov eax, dword ptr [edx + field_52c]         # 00469cd5
    mov dword ptr [ecx + 0x5d1599], eax          # 00469cdb
    mov ecx, dword ptr [ebp - local_14]          # 00469ce1
    movsx edx, word ptr [ecx + field_7c]         # 00469ce4
    imul edx, edx, 0x4a                          # 00469ce8
    mov dword ptr [edx + 0x5d159d], 0x0          # 00469ceb
    mov eax, dword ptr [ebp - local_14]          # 00469cf5
    movsx ecx, word ptr [eax + field_7c]         # 00469cf8
    imul ecx, ecx, 0x4a                          # 00469cfc
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 00469cff
    mov edx, dword ptr [ebp - local_14]          # 00469d09
    movsx eax, word ptr [edx + field_7c]         # 00469d0c
    imul eax, eax, 0x4a                          # 00469d10
    mov dword ptr [eax + 0x5d15a5], 0x1          # 00469d13
    mov ecx, dword ptr [ebp - local_14]          # 00469d1d
    movsx edx, word ptr [ecx + field_7c]         # 00469d20
    imul edx, edx, 0x4a                          # 00469d24
    mov dword ptr [edx + 0x5d15a9], 0x1          # 00469d27
    mov eax, dword ptr [ebp - local_14]          # 00469d31
    movsx ecx, word ptr [eax + field_7c]         # 00469d34
    imul ecx, ecx, 0x4a                          # 00469d38
    mov word ptr [ecx + 0x5d15ad], 0x0           # 00469d3b
    mov edi, 0x54ba1c                            # 00469d44
    mov edx, dword ptr [ebp - local_14]          # 00469d49
    movsx eax, word ptr [edx + field_7c]         # 00469d4c
    imul eax, eax, 0x4a                          # 00469d50
    add eax, 0x5d15b3                            # 00469d53
    {load} mov edx, eax                          # 00469d58
    or ecx, -0x1                                 # 00469d5a
    {load} xor eax, eax                          # 00469d5d
    repne scasb al, byte ptr es:[edi]            # 00469d5f
    not ecx                                      # 00469d61
    {load} sub edi, ecx                          # 00469d63
    {load} mov esi, edi                          # 00469d65
    {load} mov eax, ecx                          # 00469d67
    {load} mov edi, edx                          # 00469d69
    shr ecx, 0x2                                 # 00469d6b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00469d6e
    {load} mov ecx, eax                          # 00469d70
    and ecx, 0x3                                 # 00469d72
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00469d75
    mov word ptr [ebp - local_c], 0x0            # 00469d77
    jmp.d8 L_00469d8b                            # 00469d7d
L_00469d7f:
    # block 0x00469d7f: entered by jmp at 0x00469da6, 3 instruction(s), falls into the block at 0x00469d8b
    mov cx, word ptr [ebp - local_c]             # 00469d7f
    add cx, 0x1                                  # 00469d83
    mov word ptr [ebp - local_c], cx             # 00469d87
L_00469d8b:
    # block 0x00469d8b: entered by jmp at 0x00469d7d, 3 instruction(s), ends with jge to 0x00469da8 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00469d8b
    cmp edx, 0x6                                 # 00469d8f
    jge.d8 L_00469da8                            # 00469d92
    # block 0x00469d94: entered by fall-through of jge at 0x00469d92, 4 instruction(s), ends with backward jump to 0x00469d7f
    movsx eax, word ptr [ebp - local_c]          # 00469d94
    mov ecx, dword ptr [ebp - local_14]          # 00469d98
    mov dword ptr [ecx + 4*eax + field_e0], 0x1  # 00469d9b
    jmp.d8 L_00469d7f                            # 00469da6
L_00469da8:
    # block 0x00469da8: entered by jge at 0x00469d92, 2 instruction(s), ends with forward jump to 0x00469dbc
    mov word ptr [ebp - local_c], 0x0            # 00469da8
    jmp.d8 L_00469dbc                            # 00469dae
L_00469db0:
    # block 0x00469db0: entered by jmp at 0x00469e92, 3 instruction(s), falls into the block at 0x00469dbc
    mov dx, word ptr [ebp - local_c]             # 00469db0
    add dx, 0x1                                  # 00469db4
    mov word ptr [ebp - local_c], dx             # 00469db8
L_00469dbc:
    # block 0x00469dbc: entered by jmp at 0x00469dae, 3 instruction(s), ends with jge to 0x00469e97 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00469dbc
    cmp eax, 0x3                                 # 00469dc0
    jge.d32 L_00469e97                           # 00469dc3
    # block 0x00469dc9: entered by fall-through of jge at 0x00469dc3, 49 instruction(s), ends with backward jump to 0x00469db0
    mov ecx, dword ptr [ebp - local_14]          # 00469dc9
    movsx edx, word ptr [ecx + field_7e]         # 00469dcc
    imul edx, edx, 0x8d                          # 00469dd0
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469dd6
    movsx ecx, word ptr [ebp - local_c]          # 00469ddc
    imul ecx, ecx, 0xc                           # 00469de0
    movsx edx, word ptr [eax + ecx + field_56a]  # 00469de3
    mov dword ptr [ebp - local_48], edx          # 00469deb
    fild dword ptr [ebp - local_48]              # 00469dee
    fstp dword ptr [ebp - local_4c]              # 00469df1
    fld dword ptr [ebp - local_4c]               # 00469df4
    fdiv qword ptr [0x52c680]                    # 00469df7
    fstp dword ptr [ebp - local_50]              # 00469dfd
    fld dword ptr [ebp - local_50]               # 00469e00
    movsx eax, word ptr [ebp - local_c]          # 00469e03
    imul eax, eax, 0xc                           # 00469e07
    mov ecx, dword ptr [ebp - local_14]          # 00469e0a
    fstp dword ptr [ecx + eax + field_584]       # 00469e0d
    mov edx, dword ptr [ebp - local_14]          # 00469e14
    movsx eax, word ptr [edx + field_7e]         # 00469e17
    imul eax, eax, 0x8d                          # 00469e1b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00469e21
    movsx edx, word ptr [ebp - local_c]          # 00469e27
    imul edx, edx, 0xc                           # 00469e2b
    movsx eax, word ptr [ecx + edx + field_56c]  # 00469e2e
    mov dword ptr [ebp - local_54], eax          # 00469e36
    fild dword ptr [ebp - local_54]              # 00469e39
    fstp dword ptr [ebp - local_58]              # 00469e3c
    fld dword ptr [ebp - local_58]               # 00469e3f
    fdiv qword ptr [0x52c680]                    # 00469e42
    fstp dword ptr [ebp - local_5c]              # 00469e48
    fld dword ptr [ebp - local_5c]               # 00469e4b
    movsx ecx, word ptr [ebp - local_c]          # 00469e4e
    imul ecx, ecx, 0xc                           # 00469e52
    mov edx, dword ptr [ebp - local_14]          # 00469e55
    fstp dword ptr [edx + ecx + field_588]       # 00469e58
    movsx eax, word ptr [ebp - local_c]          # 00469e5f
    imul eax, eax, 0xc                           # 00469e63
    movsx ecx, word ptr [ebp - local_c]          # 00469e66
    imul ecx, ecx, 0xc                           # 00469e6a
    mov edx, dword ptr [ebp - local_14]          # 00469e6d
    mov esi, dword ptr [ebp - local_14]          # 00469e70
    fld dword ptr [edx + eax + field_588]        # 00469e73
    fsub dword ptr [esi + ecx + field_584]       # 00469e7a
    movsx eax, word ptr [ebp - local_c]          # 00469e81
    imul eax, eax, 0xc                           # 00469e85
    mov ecx, dword ptr [ebp - local_14]          # 00469e88
    fstp dword ptr [ecx + eax + field_58c]       # 00469e8b
    jmp.d32 L_00469db0                           # 00469e92
L_00469e97:
    # block 0x00469e97: entered by jge at 0x00469dc3, 2 instruction(s), ends with forward jump to 0x00469eab
    mov word ptr [ebp - local_c], 0x0            # 00469e97
    jmp.d8 L_00469eab                            # 00469e9d
L_00469e9f:
    # block 0x00469e9f: entered by jmp at 0x0046a008, 3 instruction(s), falls into the block at 0x00469eab
    mov dx, word ptr [ebp - local_c]             # 00469e9f
    add dx, 0x1                                  # 00469ea3
    mov word ptr [ebp - local_c], dx             # 00469ea7
L_00469eab:
    # block 0x00469eab: entered by jmp at 0x00469e9d, 3 instruction(s), ends with jge to 0x0046a00d (forward)
    movsx eax, word ptr [ebp - local_c]          # 00469eab
    cmp eax, 0x3                                 # 00469eaf
    jge.d32 L_0046a00d                           # 00469eb2
    # block 0x00469eb8: entered by fall-through of jge at 0x00469eb2, 78 instruction(s), ends with backward jump to 0x00469e9f
    mov ecx, dword ptr [ebp - local_14]          # 00469eb8
    movsx edx, word ptr [ecx + field_7e]         # 00469ebb
    imul edx, edx, 0x8d                          # 00469ebf
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469ec5
    movsx ecx, word ptr [0x58c94f]               # 00469ecb
    imul ecx, ecx, 0x24                          # 00469ed2
    lea edx, [eax + ecx + field_4fc]             # 00469ed5
    movsx eax, word ptr [ebp - local_c]          # 00469edc
    imul eax, eax, 0xc                           # 00469ee0
    movsx ecx, word ptr [edx + eax]              # 00469ee3
    mov dword ptr [ebp - local_60], ecx          # 00469ee7
    fild dword ptr [ebp - local_60]              # 00469eea
    fstp dword ptr [ebp - local_64]              # 00469eed
    fld dword ptr [ebp - local_64]               # 00469ef0
    fdiv qword ptr [0x52c680]                    # 00469ef3
    fstp dword ptr [ebp - local_68]              # 00469ef9
    fld dword ptr [ebp - local_68]               # 00469efc
    movsx edx, word ptr [ebp - local_c]          # 00469eff
    imul edx, edx, 0xc                           # 00469f03
    mov eax, dword ptr [ebp - local_14]          # 00469f06
    fstp dword ptr [eax + edx + field_560]       # 00469f09
    mov ecx, dword ptr [ebp - local_14]          # 00469f10
    movsx edx, word ptr [ecx + field_7e]         # 00469f13
    imul edx, edx, 0x8d                          # 00469f17
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00469f1d
    movsx ecx, word ptr [0x58c94f]               # 00469f23
    imul ecx, ecx, 0x24                          # 00469f2a
    lea edx, [eax + ecx + field_4fc]             # 00469f2d
    movsx eax, word ptr [ebp - local_c]          # 00469f34
    imul eax, eax, 0xc                           # 00469f38
    movsx ecx, word ptr [edx + eax + field_2]    # 00469f3b
    mov dword ptr [ebp - local_6c], ecx          # 00469f40
    fild dword ptr [ebp - local_6c]              # 00469f43
    fstp dword ptr [ebp - local_70]              # 00469f46
    fld dword ptr [ebp - local_70]               # 00469f49
    fdiv qword ptr [0x52c680]                    # 00469f4c
    fstp dword ptr [ebp - local_74]              # 00469f52
    fld dword ptr [ebp - local_74]               # 00469f55
    movsx edx, word ptr [ebp - local_c]          # 00469f58
    imul edx, edx, 0xc                           # 00469f5c
    mov eax, dword ptr [ebp - local_14]          # 00469f5f
    fstp dword ptr [eax + edx + field_564]       # 00469f62
    movsx ecx, word ptr [ebp - local_c]          # 00469f69
    imul ecx, ecx, 0xc                           # 00469f6d
    movsx edx, word ptr [ebp - local_c]          # 00469f70
    imul edx, edx, 0xc                           # 00469f74
    mov eax, dword ptr [ebp - local_14]          # 00469f77
    mov esi, dword ptr [ebp - local_14]          # 00469f7a
    fld dword ptr [eax + ecx + field_564]        # 00469f7d
    fsub dword ptr [esi + edx + field_560]       # 00469f84
    movsx ecx, word ptr [ebp - local_c]          # 00469f8b
    imul ecx, ecx, 0xc                           # 00469f8f
    mov edx, dword ptr [ebp - local_14]          # 00469f92
    fstp dword ptr [edx + ecx + field_568]       # 00469f95
    mov eax, dword ptr [ebp - local_14]          # 00469f9c
    movsx ecx, word ptr [eax + field_7e]         # 00469f9f
    imul ecx, ecx, 0x8d                          # 00469fa3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469fa9
    movsx eax, word ptr [0x58c94f]               # 00469faf
    imul eax, eax, 0x24                          # 00469fb6
    lea ecx, [edx + eax + field_4fc]             # 00469fb9
    movsx edx, word ptr [ebp - local_c]          # 00469fc0
    imul edx, edx, 0xc                           # 00469fc4
    mov eax, dword ptr [ebp - local_14]          # 00469fc7
    movsx eax, word ptr [eax + field_7e]         # 00469fca
    imul eax, eax, 0x8d                          # 00469fce
    mov eax, dword ptr [eax + 0x5bb5e5]          # 00469fd4
    movsx esi, word ptr [0x58c94f]               # 00469fda
    imul esi, esi, 0x24                          # 00469fe1
    lea eax, [eax + esi + field_4fc]             # 00469fe4
    movsx esi, word ptr [ebp - local_c]          # 00469feb
    imul esi, esi, 0xc                           # 00469fef
    mov ecx, dword ptr [ecx + edx + field_8]     # 00469ff2
    sub ecx, dword ptr [eax + esi + field_4]     # 00469ff6
    movsx edx, word ptr [ebp - local_c]          # 00469ffa
    mov eax, dword ptr [ebp - local_14]          # 00469ffe
    mov dword ptr [eax + 4*edx + field_5a8], ecx # 0046a001
    jmp.d32 L_00469e9f                           # 0046a008
L_0046a00d:
    # block 0x0046a00d: entered by jge at 0x00469eb2, 2 instruction(s), ends with forward jump to 0x0046a021
    mov word ptr [ebp - local_c], 0x0            # 0046a00d
    jmp.d8 L_0046a021                            # 0046a013
L_0046a015:
    # block 0x0046a015: entered by jmp at 0x0046a09d, 3 instruction(s), falls into the block at 0x0046a021
    mov cx, word ptr [ebp - local_c]             # 0046a015
    add cx, 0x1                                  # 0046a019
    mov word ptr [ebp - local_c], cx             # 0046a01d
L_0046a021:
    # block 0x0046a021: entered by jmp at 0x0046a013, 3 instruction(s), ends with jge to 0x0046a0a2 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046a021
    cmp edx, 0x3                                 # 0046a025
    jge.d8 L_0046a0a2                            # 0046a028
    # block 0x0046a02a: entered by fall-through of jge at 0x0046a028, 29 instruction(s), calls FUN_004fb77a, FUN_00469259, FUN_00469374, FUN_004fb2e3, ends with backward jump to 0x0046a015
    mov eax, dword ptr [ebp - local_14]          # 0046a02a
    movsx ecx, word ptr [eax + field_7e]         # 0046a02d
    imul ecx, ecx, 0x8d                          # 0046a031
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a037
    movsx eax, word ptr [ebp - local_c]          # 0046a03d
    imul eax, eax, 0x31                          # 0046a041
    lea ecx, [edx + eax + field_469]             # 0046a044
    push ecx                                     # 0046a04b
    mov ecx, 0x5c3a67                            # 0046a04c
    call FUN_004fb77a                            # 0046a051
    mov dx, word ptr [ebp - local_c]             # 0046a056
    push edx                                     # 0046a05a
    mov ecx, dword ptr [ebp - local_14]          # 0046a05b
    call FUN_00469259                            # 0046a05e
    mov ax, word ptr [ebp - local_c]             # 0046a063
    push eax                                     # 0046a067
    mov ecx, dword ptr [ebp - local_14]          # 0046a068
    call FUN_00469374                            # 0046a06b
    mov ecx, dword ptr [ebp - local_14]          # 0046a070
    movsx edx, word ptr [ecx + field_7e]         # 0046a073
    imul edx, edx, 0x8d                          # 0046a077
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a07d
    movsx ecx, word ptr [ebp - local_c]          # 0046a083
    imul ecx, ecx, 0x31                          # 0046a087
    mov dx, word ptr [eax + ecx + field_48a]     # 0046a08a
    push edx                                     # 0046a092
    mov ecx, 0x5c3a67                            # 0046a093
    call FUN_004fb2e3                            # 0046a098
    jmp.d32 L_0046a015                           # 0046a09d
L_0046a0a2:
    # block 0x0046a0a2: entered by jge at 0x0046a028, 13 instruction(s), ends with forward jump to 0x0046a96e
    mov eax, dword ptr [ebp - local_14]          # 0046a0a2
    mov dword ptr [eax + field_54a], 0x0         # 0046a0a5
    mov ecx, dword ptr [ebp - local_14]          # 0046a0af
    mov dword ptr [ecx + field_54e], 0x0         # 0046a0b2
    mov edx, dword ptr [ebp - local_14]          # 0046a0bc
    movsx eax, word ptr [edx + field_7e]         # 0046a0bf
    imul eax, eax, 0x8d                          # 0046a0c3
    mov dword ptr [eax + 0x5bb632], 0x1          # 0046a0c9
    mov ecx, dword ptr [ebp - local_14]          # 0046a0d3
    mov word ptr [ecx + field_556], 0xffff       # 0046a0d6
    mov edx, dword ptr [ebp - local_14]          # 0046a0df
    mov word ptr [edx + field_55a], 0xffff       # 0046a0e2
    jmp.d32 L_0046a96e                           # 0046a0eb
L_0046a0f0:
    # block 0x0046a0f0: entered by je at 0x00469622, 5 instruction(s), ends with je to 0x0046a11b (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a0f0
    mov ecx, dword ptr [eax + field_54a]         # 0046a0f3
    mov dword ptr [ebp - local_78], ecx          # 0046a0f9
    cmp dword ptr [ebp - local_78], 0x0          # 0046a0fc
    je.d8 L_0046a11b                             # 0046a100
    # block 0x0046a102: entered by fall-through of je at 0x0046a100, 2 instruction(s), ends with je to 0x0046a636 (forward)
    cmp dword ptr [ebp - local_78], 0x1          # 0046a102
    je.d32 L_0046a636                            # 0046a106
    # block 0x0046a10c: entered by fall-through of je at 0x0046a106, 2 instruction(s), ends with je to 0x0046a750 (forward)
    cmp dword ptr [ebp - local_78], 0x2          # 0046a10c
    je.d32 L_0046a750                            # 0046a110
    # block 0x0046a116: entered by fall-through of je at 0x0046a110, 1 instruction(s), ends with forward jump to 0x0046a7ba
    jmp.d32 L_0046a7ba                           # 0046a116
L_0046a11b:
    # block 0x0046a11b: entered by je at 0x0046a100, 7 instruction(s), calls FUN_004dadff, ends with je to 0x0046a146 (forward)
    mov ecx, 0x5830a6                            # 0046a11b
    call FUN_004dadff                            # 0046a120
    mov edx, dword ptr [ebp - local_14]          # 0046a125
    mov eax, dword ptr [edx + field_54e]         # 0046a128
    mov dword ptr [ebp - local_7c], eax          # 0046a12e
    cmp dword ptr [ebp - local_7c], 0x0          # 0046a131
    je.d8 L_0046a146                             # 0046a135
    # block 0x0046a137: entered by fall-through of je at 0x0046a135, 2 instruction(s), ends with je to 0x0046a2cd (forward)
    cmp dword ptr [ebp - local_7c], 0x1          # 0046a137
    je.d32 L_0046a2cd                            # 0046a13b
    # block 0x0046a141: entered by fall-through of je at 0x0046a13b, 1 instruction(s), ends with forward jump to 0x0046a629
    jmp.d32 L_0046a629                           # 0046a141
L_0046a146:
    # block 0x0046a146: entered by je at 0x0046a135, 2 instruction(s), ends with jne to 0x0046a2c8 (forward)
    cmp dword ptr [0x5c39e5], 0x272e             # 0046a146
    jne.d32 L_0046a2c8                           # 0046a150
    # block 0x0046a156: entered by fall-through of jne at 0x0046a150, 4 instruction(s), ends with jl to 0x0046a2c8 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0046a156
    movsx edx, word ptr [ecx + field_548]        # 0046a159
    test edx, edx                                # 0046a160
    jl.d32 L_0046a2c8                            # 0046a162
    # block 0x0046a168: entered by fall-through of jl at 0x0046a162, 4 instruction(s), ends with jge to 0x0046a2c8 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a168
    movsx ecx, word ptr [eax + field_548]        # 0046a16b
    cmp ecx, 0x6                                 # 0046a172
    jge.d32 L_0046a2c8                           # 0046a175
    # block 0x0046a17b: entered by fall-through of jge at 0x0046a175, 4 instruction(s), ends with je to 0x0046a2c8 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a17b
    movsx eax, word ptr [edx + field_554]        # 0046a17e
    cmp eax, -0x1                                # 0046a185
    je.d32 L_0046a2c8                            # 0046a188
    # block 0x0046a18e: entered by fall-through of je at 0x0046a188, 4 instruction(s), ends with jne to 0x0046a2c8 (forward)
    {load} xor ecx, ecx                          # 0046a18e
    mov cl, byte ptr [0x58321d]                  # 0046a190
    cmp ecx, 0x1                                 # 0046a196
    jne.d32 L_0046a2c8                           # 0046a199
    # block 0x0046a19f: entered by fall-through of jne at 0x0046a199, 20 instruction(s), ends with jle to 0x0046a225 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a19f
    mov eax, dword ptr [ebp - local_14]          # 0046a1a2
    mov cx, word ptr [eax + field_548]           # 0046a1a5
    mov word ptr [edx + field_55a], cx           # 0046a1ac
    mov edx, dword ptr [ebp - local_14]          # 0046a1b3
    mov eax, dword ptr [ebp - local_14]          # 0046a1b6
    mov cx, word ptr [eax + field_554]           # 0046a1b9
    mov word ptr [edx + field_556], cx           # 0046a1c0
    mov edx, dword ptr [ebp - local_14]          # 0046a1c7
    movsx eax, word ptr [edx + field_7e]         # 0046a1ca
    imul eax, eax, 0x8d                          # 0046a1ce
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a1d4
    mov edx, dword ptr [ebp - local_14]          # 0046a1da
    movsx eax, word ptr [edx + field_55a]        # 0046a1dd
    imul eax, eax, 0x6                           # 0046a1e4
    movsx ecx, word ptr [ecx + eax + field_55]   # 0046a1e7
    mov edx, dword ptr [ebp - local_14]          # 0046a1ec
    movsx eax, word ptr [edx + field_556]        # 0046a1ef
    {load} cmp ecx, eax                          # 0046a1f6
    jle.d8 L_0046a225                            # 0046a1f8
    # block 0x0046a1fa: entered by fall-through of jle at 0x0046a1f8, 10 instruction(s), ends with forward jump to 0x0046a233
    mov ecx, dword ptr [ebp - local_14]          # 0046a1fa
    movsx edx, word ptr [ecx + field_7e]         # 0046a1fd
    imul edx, edx, 0x8d                          # 0046a201
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a207
    mov ecx, dword ptr [ebp - local_14]          # 0046a20d
    movsx edx, word ptr [ecx + field_55a]        # 0046a210
    imul edx, edx, 0x6                           # 0046a217
    mov ax, word ptr [eax + edx + field_55]      # 0046a21a
    mov word ptr [ebp - local_7e], ax            # 0046a21f
    jmp.d8 L_0046a233                            # 0046a223
L_0046a225:
    # block 0x0046a225: entered by jle at 0x0046a1f8, 3 instruction(s), falls into the block at 0x0046a233
    mov ecx, dword ptr [ebp - local_14]          # 0046a225
    mov dx, word ptr [ecx + field_556]           # 0046a228
    mov word ptr [ebp - local_7e], dx            # 0046a22f
L_0046a233:
    # block 0x0046a233: entered by jmp at 0x0046a223, 15 instruction(s), ends with jge to 0x0046a29f (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a233
    mov cx, word ptr [ebp - local_7e]            # 0046a236
    mov word ptr [eax + field_556], cx           # 0046a23a
    mov edx, dword ptr [ebp - local_14]          # 0046a241
    movsx eax, word ptr [edx + field_7e]         # 0046a244
    imul eax, eax, 0x8d                          # 0046a248
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a24e
    mov edx, dword ptr [ebp - local_14]          # 0046a254
    movsx eax, word ptr [edx + field_55a]        # 0046a257
    imul eax, eax, 0x6                           # 0046a25e
    movsx ecx, word ptr [ecx + eax + field_53]   # 0046a261
    mov edx, dword ptr [ebp - local_14]          # 0046a266
    movsx eax, word ptr [edx + field_556]        # 0046a269
    {load} cmp ecx, eax                          # 0046a270
    jge.d8 L_0046a29f                            # 0046a272
    # block 0x0046a274: entered by fall-through of jge at 0x0046a272, 10 instruction(s), ends with forward jump to 0x0046a2ad
    mov ecx, dword ptr [ebp - local_14]          # 0046a274
    movsx edx, word ptr [ecx + field_7e]         # 0046a277
    imul edx, edx, 0x8d                          # 0046a27b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a281
    mov ecx, dword ptr [ebp - local_14]          # 0046a287
    movsx edx, word ptr [ecx + field_55a]        # 0046a28a
    imul edx, edx, 0x6                           # 0046a291
    mov ax, word ptr [eax + edx + field_53]      # 0046a294
    mov word ptr [ebp - local_80], ax            # 0046a299
    jmp.d8 L_0046a2ad                            # 0046a29d
L_0046a29f:
    # block 0x0046a29f: entered by jge at 0x0046a272, 3 instruction(s), falls into the block at 0x0046a2ad
    mov ecx, dword ptr [ebp - local_14]          # 0046a29f
    mov dx, word ptr [ecx + field_556]           # 0046a2a2
    mov word ptr [ebp - local_80], dx            # 0046a2a9
L_0046a2ad:
    # block 0x0046a2ad: entered by jmp at 0x0046a29d, 5 instruction(s), falls into the block at 0x0046a2c8
    mov eax, dword ptr [ebp - local_14]          # 0046a2ad
    mov cx, word ptr [ebp - local_80]            # 0046a2b0
    mov word ptr [eax + field_556], cx           # 0046a2b4
    mov edx, dword ptr [ebp - local_14]          # 0046a2bb
    mov dword ptr [edx + field_54e], 0x1         # 0046a2be
L_0046a2c8:
    # block 0x0046a2c8: entered by jne at 0x0046a150; jl at 0x0046a162; jge at 0x0046a175; je at 0x0046a188; more, 1 instruction(s), ends with forward jump to 0x0046a629
    jmp.d32 L_0046a629                           # 0046a2c8
L_0046a2cd:
    # block 0x0046a2cd: entered by je at 0x0046a13b, 2 instruction(s), ends with jne to 0x0046a30b (forward)
    cmp dword ptr [0x5c39e5], 0x272e             # 0046a2cd
    jne.d8 L_0046a30b                            # 0046a2d7
    # block 0x0046a2d9: entered by fall-through of jne at 0x0046a2d7, 6 instruction(s), ends with jne to 0x0046a30b (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a2d9
    movsx ecx, word ptr [eax + field_55a]        # 0046a2dc
    mov edx, dword ptr [ebp - local_14]          # 0046a2e3
    movsx eax, word ptr [edx + field_548]        # 0046a2e6
    {load} cmp ecx, eax                          # 0046a2ed
    jne.d8 L_0046a30b                            # 0046a2ef
    # block 0x0046a2f1: entered by fall-through of jne at 0x0046a2ef, 4 instruction(s), ends with je to 0x0046a30b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0046a2f1
    movsx edx, word ptr [ecx + field_554]        # 0046a2f4
    cmp edx, -0x1                                # 0046a2fb
    je.d8 L_0046a30b                             # 0046a2fe
    # block 0x0046a300: entered by fall-through of je at 0x0046a2fe, 4 instruction(s), ends with jne to 0x0046a335 (forward)
    {load} xor eax, eax                          # 0046a300
    mov al, byte ptr [0x58321d]                  # 0046a302
    test eax, eax                                # 0046a307
    jne.d8 L_0046a335                            # 0046a309
L_0046a30b:
    # block 0x0046a30b: entered by jne at 0x0046a2d7; jne at 0x0046a2ef; je at 0x0046a2fe; fall-through of jne at 0x0046a309, 7 instruction(s), ends with forward jump to 0x0046a629
    mov ecx, dword ptr [ebp - local_14]          # 0046a30b
    mov word ptr [ecx + field_556], 0xffff       # 0046a30e
    mov edx, dword ptr [ebp - local_14]          # 0046a317
    mov word ptr [edx + field_55a], 0xffff       # 0046a31a
    mov eax, dword ptr [ebp - local_14]          # 0046a323
    mov dword ptr [eax + field_54e], 0x0         # 0046a326
    jmp.d32 L_0046a629                           # 0046a330
L_0046a335:
    # block 0x0046a335: entered by jne at 0x0046a309, 16 instruction(s), ends with jle to 0x0046a3aa (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0046a335
    mov edx, dword ptr [ebp - local_14]          # 0046a338
    mov ax, word ptr [edx + field_554]           # 0046a33b
    mov word ptr [ecx + field_558], ax           # 0046a342
    mov ecx, dword ptr [ebp - local_14]          # 0046a349
    movsx edx, word ptr [ecx + field_7e]         # 0046a34c
    imul edx, edx, 0x8d                          # 0046a350
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a356
    mov ecx, dword ptr [ebp - local_14]          # 0046a35c
    movsx edx, word ptr [ecx + field_55a]        # 0046a35f
    imul edx, edx, 0x6                           # 0046a366
    movsx eax, word ptr [eax + edx + field_55]   # 0046a369
    mov ecx, dword ptr [ebp - local_14]          # 0046a36e
    movsx edx, word ptr [ecx + field_558]        # 0046a371
    {load} cmp eax, edx                          # 0046a378
    jle.d8 L_0046a3aa                            # 0046a37a
    # block 0x0046a37c: entered by fall-through of jle at 0x0046a37a, 10 instruction(s), ends with forward jump to 0x0046a3bb
    mov eax, dword ptr [ebp - local_14]          # 0046a37c
    movsx ecx, word ptr [eax + field_7e]         # 0046a37f
    imul ecx, ecx, 0x8d                          # 0046a383
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a389
    mov eax, dword ptr [ebp - local_14]          # 0046a38f
    movsx ecx, word ptr [eax + field_55a]        # 0046a392
    imul ecx, ecx, 0x6                           # 0046a399
    mov dx, word ptr [edx + ecx + field_55]      # 0046a39c
    mov word ptr [ebp - local_82], dx            # 0046a3a1
    jmp.d8 L_0046a3bb                            # 0046a3a8
L_0046a3aa:
    # block 0x0046a3aa: entered by jle at 0x0046a37a, 3 instruction(s), falls into the block at 0x0046a3bb
    mov eax, dword ptr [ebp - local_14]          # 0046a3aa
    mov cx, word ptr [eax + field_558]           # 0046a3ad
    mov word ptr [ebp - local_82], cx            # 0046a3b4
L_0046a3bb:
    # block 0x0046a3bb: entered by jmp at 0x0046a3a8, 15 instruction(s), ends with jge to 0x0046a42d (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a3bb
    mov ax, word ptr [ebp - local_82]            # 0046a3be
    mov word ptr [edx + field_558], ax           # 0046a3c5
    mov ecx, dword ptr [ebp - local_14]          # 0046a3cc
    movsx edx, word ptr [ecx + field_7e]         # 0046a3cf
    imul edx, edx, 0x8d                          # 0046a3d3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a3d9
    mov ecx, dword ptr [ebp - local_14]          # 0046a3df
    movsx edx, word ptr [ecx + field_55a]        # 0046a3e2
    imul edx, edx, 0x6                           # 0046a3e9
    movsx eax, word ptr [eax + edx + field_53]   # 0046a3ec
    mov ecx, dword ptr [ebp - local_14]          # 0046a3f1
    movsx edx, word ptr [ecx + field_558]        # 0046a3f4
    {load} cmp eax, edx                          # 0046a3fb
    jge.d8 L_0046a42d                            # 0046a3fd
    # block 0x0046a3ff: entered by fall-through of jge at 0x0046a3fd, 10 instruction(s), ends with forward jump to 0x0046a43e
    mov eax, dword ptr [ebp - local_14]          # 0046a3ff
    movsx ecx, word ptr [eax + field_7e]         # 0046a402
    imul ecx, ecx, 0x8d                          # 0046a406
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a40c
    mov eax, dword ptr [ebp - local_14]          # 0046a412
    movsx ecx, word ptr [eax + field_55a]        # 0046a415
    imul ecx, ecx, 0x6                           # 0046a41c
    mov dx, word ptr [edx + ecx + field_53]      # 0046a41f
    mov word ptr [ebp - local_84], dx            # 0046a424
    jmp.d8 L_0046a43e                            # 0046a42b
L_0046a42d:
    # block 0x0046a42d: entered by jge at 0x0046a3fd, 3 instruction(s), falls into the block at 0x0046a43e
    mov eax, dword ptr [ebp - local_14]          # 0046a42d
    mov cx, word ptr [eax + field_558]           # 0046a430
    mov word ptr [ebp - local_84], cx            # 0046a437
L_0046a43e:
    # block 0x0046a43e: entered by jmp at 0x0046a42b, 16 instruction(s), ends with je to 0x0046a489 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a43e
    mov ax, word ptr [ebp - local_84]            # 0046a441
    mov word ptr [edx + field_558], ax           # 0046a448
    mov ecx, dword ptr [ebp - local_14]          # 0046a44f
    movsx edx, word ptr [ecx + field_556]        # 0046a452
    mov eax, dword ptr [ebp - local_14]          # 0046a459
    movsx ecx, word ptr [eax + field_558]        # 0046a45c
    {load} sub edx, ecx                          # 0046a463
    mov dword ptr [ebp - local_88], edx          # 0046a465
    fild dword ptr [ebp - local_88]              # 0046a46b
    fstp dword ptr [ebp - local_4]               # 0046a471
    fld dword ptr [ebp - local_4]                # 0046a474
    fcomp qword ptr [0x52c7b0]                   # 0046a477
    fnstsw ax                                    # 0046a47d
    test ah, 0x40                                # 0046a47f
    je.d8 L_0046a489                             # 0046a482
    # block 0x0046a484: entered by fall-through of je at 0x0046a482, 1 instruction(s), ends with forward jump to 0x0046a629
    jmp.d32 L_0046a629                           # 0046a484
L_0046a489:
    # block 0x0046a489: entered by je at 0x0046a482, 20 instruction(s), ends with jne to 0x0046a4fc (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a489
    movsx eax, word ptr [edx + field_55a]        # 0046a48c
    mov ecx, dword ptr [ebp - local_14]          # 0046a493
    fld dword ptr [ebp - local_4]                # 0046a496
    fdiv dword ptr [ecx + 4*eax + field_530]     # 0046a499
    fstp dword ptr [ebp - local_4]               # 0046a4a0
    mov edx, dword ptr [ebp - local_14]          # 0046a4a3
    movsx eax, word ptr [edx + field_55a]        # 0046a4a6
    fld dword ptr [ebp - local_4]                # 0046a4ad
    fadd dword ptr [4*eax + 0x5919dc]            # 0046a4b0
    mov ecx, dword ptr [ebp - local_14]          # 0046a4b7
    movsx edx, word ptr [ecx + field_55a]        # 0046a4ba
    fstp dword ptr [4*edx + 0x5919dc]            # 0046a4c1
    mov eax, dword ptr [ebp - local_14]          # 0046a4c8
    movsx ecx, word ptr [eax + field_55a]        # 0046a4cb
    fld dword ptr [4*ecx + 0x5919dc]             # 0046a4d2
    fcomp qword ptr [0x52c598]                   # 0046a4d9
    fnstsw ax                                    # 0046a4df
    test ah, 0x41                                # 0046a4e1
    jne.d8 L_0046a4fc                            # 0046a4e4
    # block 0x0046a4e6: entered by fall-through of jne at 0x0046a4e4, 3 instruction(s), ends with forward jump to 0x0046a513
    mov dword ptr [ebp - local_90], 0x0          # 0046a4e6
    mov dword ptr [ebp - local_8c], 0x3ff00000   # 0046a4f0
    jmp.d8 L_0046a513                            # 0046a4fa
L_0046a4fc:
    # block 0x0046a4fc: entered by jne at 0x0046a4e4, 4 instruction(s), falls into the block at 0x0046a513
    mov edx, dword ptr [ebp - local_14]          # 0046a4fc
    movsx eax, word ptr [edx + field_55a]        # 0046a4ff
    fld dword ptr [4*eax + 0x5919dc]             # 0046a506
    fstp qword ptr [ebp - local_90]              # 0046a50d
L_0046a513:
    # block 0x0046a513: entered by jmp at 0x0046a4fa, 13 instruction(s), ends with je to 0x0046a56a (forward)
    fld qword ptr [ebp - local_90]               # 0046a513
    fstp dword ptr [ebp - local_94]              # 0046a519
    fld dword ptr [ebp - local_94]               # 0046a51f
    mov ecx, dword ptr [ebp - local_14]          # 0046a525
    movsx edx, word ptr [ecx + field_55a]        # 0046a528
    fstp dword ptr [4*edx + 0x5919dc]            # 0046a52f
    mov eax, dword ptr [ebp - local_14]          # 0046a536
    movsx ecx, word ptr [eax + field_55a]        # 0046a539
    fld dword ptr [4*ecx + 0x5919dc]             # 0046a540
    fcomp qword ptr [0x52c7b0]                   # 0046a547
    fnstsw ax                                    # 0046a54d
    test ah, 0x1                                 # 0046a54f
    je.d8 L_0046a56a                             # 0046a552
    # block 0x0046a554: entered by fall-through of je at 0x0046a552, 3 instruction(s), ends with forward jump to 0x0046a581
    mov dword ptr [ebp - local_9c], 0x0          # 0046a554
    mov dword ptr [ebp - local_98], 0x0          # 0046a55e
    jmp.d8 L_0046a581                            # 0046a568
L_0046a56a:
    # block 0x0046a56a: entered by je at 0x0046a552, 4 instruction(s), falls into the block at 0x0046a581
    mov edx, dword ptr [ebp - local_14]          # 0046a56a
    movsx eax, word ptr [edx + field_55a]        # 0046a56d
    fld dword ptr [4*eax + 0x5919dc]             # 0046a574
    fstp qword ptr [ebp - local_9c]              # 0046a57b
L_0046a581:
    # block 0x0046a581: entered by jmp at 0x0046a568, 19 instruction(s), ends with ja to 0x0046a621 (forward)
    fld qword ptr [ebp - local_9c]               # 0046a581
    fstp dword ptr [ebp - local_a0]              # 0046a587
    fld dword ptr [ebp - local_a0]               # 0046a58d
    mov ecx, dword ptr [ebp - local_14]          # 0046a593
    movsx edx, word ptr [ecx + field_55a]        # 0046a596
    fstp dword ptr [4*edx + 0x5919dc]            # 0046a59d
    mov eax, dword ptr [ebp - local_14]          # 0046a5a4
    mov ecx, dword ptr [ebp - local_14]          # 0046a5a7
    mov dx, word ptr [ecx + field_558]           # 0046a5aa
    mov word ptr [eax + field_556], dx           # 0046a5b1
    mov eax, dword ptr [ebp - local_14]          # 0046a5b8
    movsx ecx, word ptr [eax + field_55a]        # 0046a5bb
    mov edx, dword ptr [ebp - local_14]          # 0046a5c2
    mov dword ptr [edx + 4*ecx + field_e0], 0x1  # 0046a5c5
    mov eax, dword ptr [ebp - local_14]          # 0046a5d0
    movsx ecx, word ptr [eax + field_55a]        # 0046a5d3
    mov dword ptr [ebp - local_a4], ecx          # 0046a5da
    cmp dword ptr [ebp - local_a4], 0x5          # 0046a5e0
    ja.d8 L_0046a621                             # 0046a5e7
    # block 0x0046a5e9: entered by fall-through of ja at 0x0046a5e7, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x46a976]
    mov edx, dword ptr [ebp - local_a4]          # 0046a5e9
    jmp dword ptr [4*edx + SWTAB_0046a976_VA]    # 0046a5ef
L_0046a5f6:
    # block 0x0046a5f6: entered by switch case, 6 instruction(s), calls FUN_00469374, ends with forward jump to 0x0046a621
    mov eax, dword ptr [ebp - local_14]          # 0046a5f6
    mov cx, word ptr [eax + field_55a]           # 0046a5f9
    push ecx                                     # 0046a600
    mov ecx, dword ptr [ebp - local_14]          # 0046a601
    call FUN_00469374                            # 0046a604
    jmp.d8 L_0046a621                            # 0046a609
L_0046a60b:
    # block 0x0046a60b: entered by switch case, 6 instruction(s), calls FUN_00469259, falls into the block at 0x0046a621
    mov edx, dword ptr [ebp - local_14]          # 0046a60b
    movsx eax, word ptr [edx + field_55a]        # 0046a60e
    sub eax, 0x3                                 # 0046a615
    push eax                                     # 0046a618
    mov ecx, dword ptr [ebp - local_14]          # 0046a619
    call FUN_00469259                            # 0046a61c
L_0046a621:
    # block 0x0046a621: entered by ja at 0x0046a5e7; jmp at 0x0046a609, 2 instruction(s), calls FUN_00469505, falls into the block at 0x0046a629
    mov ecx, dword ptr [ebp - local_14]          # 0046a621
    call FUN_00469505                            # 0046a624
L_0046a629:
    # block 0x0046a629: entered by jmp at 0x0046a141; jmp at 0x0046a2c8; jmp at 0x0046a330; jmp at 0x0046a484, 3 instruction(s), calls FUN_0046a98e, ends with forward jump to 0x0046a7ba
    mov ecx, dword ptr [ebp - local_14]          # 0046a629
    call FUN_0046a98e                            # 0046a62c
    jmp.d32 L_0046a7ba                           # 0046a631
L_0046a636:
    # block 0x0046a636: entered by je at 0x0046a106, 10 instruction(s), ends with je to 0x0046a737 (forward)
    mov edi, 0x54ba34                            # 0046a636
    mov ecx, dword ptr [ebp - local_14]          # 0046a63b
    movsx edx, word ptr [ecx + field_7e]         # 0046a63e
    imul edx, edx, 0x8d                          # 0046a642
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0046a648
    add esi, 0x5a4                               # 0046a64e
    mov ecx, 0x9                                 # 0046a654
    {load} xor eax, eax                          # 0046a659
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046a65b
    je.d32 L_0046a737                            # 0046a65d
    # block 0x0046a663: entered by fall-through of je at 0x0046a65d, 2 instruction(s), ends with forward jump to 0x0046a677
    mov word ptr [ebp - local_c], 0x0            # 0046a663
    jmp.d8 L_0046a677                            # 0046a669
L_0046a66b:
    # block 0x0046a66b: entered by jmp at 0x0046a6dd, 3 instruction(s), falls into the block at 0x0046a677
    mov cx, word ptr [ebp - local_c]             # 0046a66b
    add cx, 0x1                                  # 0046a66f
    mov word ptr [ebp - local_c], cx             # 0046a673
L_0046a677:
    # block 0x0046a677: entered by jmp at 0x0046a669, 3 instruction(s), ends with jge to 0x0046a6df (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046a677
    cmp edx, 0x3                                 # 0046a67b
    jge.d8 L_0046a6df                            # 0046a67e
    # block 0x0046a680: entered by fall-through of jge at 0x0046a67e, 12 instruction(s), ends with je to 0x0046a6dd (forward)
    mov edi, 0x54ba40                            # 0046a680
    mov eax, dword ptr [ebp - local_14]          # 0046a685
    movsx ecx, word ptr [eax + field_7e]         # 0046a688
    imul ecx, ecx, 0x8d                          # 0046a68c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a692
    movsx eax, word ptr [ebp - local_c]          # 0046a698
    imul eax, eax, 0x31                          # 0046a69c
    lea esi, [edx + eax + field_469]             # 0046a69f
    mov ecx, 0x9                                 # 0046a6a6
    {load} xor edx, edx                          # 0046a6ab
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046a6ad
    je.d8 L_0046a6dd                             # 0046a6af
    # block 0x0046a6b1: entered by fall-through of je at 0x0046a6af, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x0046a6dd
    mov eax, dword ptr [ebp - local_14]          # 0046a6b1
    movsx ecx, word ptr [eax + field_7e]         # 0046a6b4
    imul ecx, ecx, 0x8d                          # 0046a6b8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a6be
    movsx eax, word ptr [ebp - local_c]          # 0046a6c4
    imul eax, eax, 0x31                          # 0046a6c8
    lea ecx, [edx + eax + field_469]             # 0046a6cb
    push ecx                                     # 0046a6d2
    mov ecx, 0x5c3a67                            # 0046a6d3
    call FUN_004fba69                            # 0046a6d8
L_0046a6dd:
    # block 0x0046a6dd: entered by je at 0x0046a6af, 1 instruction(s), ends with backward jump to 0x0046a66b
    jmp.d8 L_0046a66b                            # 0046a6dd
L_0046a6df:
    # block 0x0046a6df: entered by jge at 0x0046a67e, 19 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0046a74e
    mov edx, dword ptr [ebp - local_14]          # 0046a6df
    movsx eax, word ptr [edx + field_7e]         # 0046a6e2
    imul eax, eax, 0x8d                          # 0046a6e6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a6ec
    add ecx, 0x5a4                               # 0046a6f2
    push ecx                                     # 0046a6f8
    mov ecx, 0x5c3a67                            # 0046a6f9
    call FUN_004fb77a                            # 0046a6fe
    mov edx, dword ptr [ebp - local_14]          # 0046a703
    movsx eax, word ptr [edx + field_7e]         # 0046a706
    imul eax, eax, 0x8d                          # 0046a70a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a710
    mov dx, word ptr [ecx + field_5c5]           # 0046a716
    push edx                                     # 0046a71d
    mov ecx, 0x5c3a67                            # 0046a71e
    call FUN_004fb2e3                            # 0046a723
    mov eax, dword ptr [ebp - local_14]          # 0046a728
    mov dword ptr [eax + field_54a], 0x2         # 0046a72b
    jmp.d8 L_0046a74e                            # 0046a735
L_0046a737:
    # block 0x0046a737: entered by je at 0x0046a65d, 4 instruction(s), falls into the block at 0x0046a74e
    mov ecx, dword ptr [ebp - local_14]          # 0046a737
    movsx edx, word ptr [ecx + field_7e]         # 0046a73a
    imul edx, edx, 0x8d                          # 0046a73e
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046a744
L_0046a74e:
    # block 0x0046a74e: entered by jmp at 0x0046a735, 1 instruction(s), ends with forward jump to 0x0046a7ba
    jmp.d8 L_0046a7ba                            # 0046a74e
L_0046a750:
    # block 0x0046a750: entered by je at 0x0046a110, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x0046a7ba (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a750
    movsx ecx, word ptr [eax + field_7e]         # 0046a753
    imul ecx, ecx, 0x8d                          # 0046a757
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a75d
    movsx eax, word ptr [edx + field_5c5]        # 0046a763
    mov dword ptr [ebp - local_10], eax          # 0046a76a
    mov ecx, dword ptr [ebp - local_10]          # 0046a76d
    push ecx                                     # 0046a770
    mov ecx, 0x5cf1eb                            # 0046a771
    call FUN_004f6334                            # 0046a776
    test eax, eax                                # 0046a77b
    jne.d8 L_0046a7ba                            # 0046a77d
    # block 0x0046a77f: entered by fall-through of jne at 0x0046a77d, 12 instruction(s), calls FUN_004fba69, falls into the block at 0x0046a7ba
    mov edx, dword ptr [ebp - local_14]          # 0046a77f
    movsx eax, word ptr [edx + field_7e]         # 0046a782
    imul eax, eax, 0x8d                          # 0046a786
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a78c
    add ecx, 0x5a4                               # 0046a792
    push ecx                                     # 0046a798
    mov ecx, 0x5c3a67                            # 0046a799
    call FUN_004fba69                            # 0046a79e
    mov edx, dword ptr [ebp - local_14]          # 0046a7a3
    movsx eax, word ptr [edx + field_7e]         # 0046a7a6
    imul eax, eax, 0x8d                          # 0046a7aa
    mov dword ptr [eax + 0x5bb632], 0x2          # 0046a7b0
L_0046a7ba:
    # block 0x0046a7ba: entered by jmp at 0x0046a116; jmp at 0x0046a631; jmp at 0x0046a74e; jne at 0x0046a77d, 1 instruction(s), ends with forward jump to 0x0046a96e
    jmp.d32 L_0046a96e                           # 0046a7ba
L_0046a7bf:
    # block 0x0046a7bf: entered by je at 0x0046962c, 3 instruction(s), ends with forward jump to 0x0046a7dd
    mov dword ptr [0x5bb1ca], 0x1                # 0046a7bf
    mov word ptr [ebp - local_c], 0x0            # 0046a7c9
    jmp.d8 L_0046a7dd                            # 0046a7cf
L_0046a7d1:
    # block 0x0046a7d1: entered by jmp at 0x0046a812, 3 instruction(s), falls into the block at 0x0046a7dd
    mov cx, word ptr [ebp - local_c]             # 0046a7d1
    add cx, 0x1                                  # 0046a7d5
    mov word ptr [ebp - local_c], cx             # 0046a7d9
L_0046a7dd:
    # block 0x0046a7dd: entered by jmp at 0x0046a7cf, 3 instruction(s), ends with jge to 0x0046a814 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046a7dd
    cmp edx, 0x3                                 # 0046a7e1
    jge.d8 L_0046a814                            # 0046a7e4
    # block 0x0046a7e6: entered by fall-through of jge at 0x0046a7e4, 11 instruction(s), calls FUN_004fba69, ends with backward jump to 0x0046a7d1
    mov eax, dword ptr [ebp - local_14]          # 0046a7e6
    movsx ecx, word ptr [eax + field_7e]         # 0046a7e9
    imul ecx, ecx, 0x8d                          # 0046a7ed
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a7f3
    movsx eax, word ptr [ebp - local_c]          # 0046a7f9
    imul eax, eax, 0x31                          # 0046a7fd
    lea ecx, [edx + eax + field_469]             # 0046a800
    push ecx                                     # 0046a807
    mov ecx, 0x5c3a67                            # 0046a808
    call FUN_004fba69                            # 0046a80d
    jmp.d8 L_0046a7d1                            # 0046a812
L_0046a814:
    # block 0x0046a814: entered by jge at 0x0046a7e4, 7 instruction(s), ends with je to 0x0046a956 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0046a814
    movsx eax, word ptr [edx + field_7e]         # 0046a817
    imul eax, eax, 0x8d                          # 0046a81b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a821
    movsx edx, word ptr [ecx + field_58e]        # 0046a827
    cmp edx, 0x270f                              # 0046a82e
    je.d32 L_0046a956                            # 0046a834
    # block 0x0046a83a: entered by fall-through of je at 0x0046a834, 49 instruction(s), ends with jne to 0x0046a942 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046a83a
    movsx ecx, word ptr [eax + field_7e]         # 0046a83d
    imul ecx, ecx, 0x8d                          # 0046a841
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a847
    movsx eax, word ptr [edx + field_58e]        # 0046a84d
    mov dword ptr [0x5bb57b], eax                # 0046a854
    mov ecx, dword ptr [ebp - local_14]          # 0046a859
    movsx edx, word ptr [ecx + field_7e]         # 0046a85c
    imul edx, edx, 0x8d                          # 0046a860
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a866
    mov cx, word ptr [eax + field_590]           # 0046a86c
    mov word ptr [0x5bb599], cx                  # 0046a873
    mov edx, dword ptr [ebp - local_14]          # 0046a87a
    movsx eax, word ptr [edx + field_7e]         # 0046a87d
    imul eax, eax, 0x8d                          # 0046a881
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a887
    mov dx, word ptr [ecx + field_592]           # 0046a88d
    mov word ptr [0x5bb595], dx                  # 0046a894
    mov eax, dword ptr [ebp - local_14]          # 0046a89b
    movsx ecx, word ptr [eax + field_7e]         # 0046a89e
    imul ecx, ecx, 0x8d                          # 0046a8a2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a8a8
    mov ax, word ptr [edx + field_594]           # 0046a8ae
    mov word ptr [0x5c39ff], ax                  # 0046a8b5
    mov ecx, dword ptr [ebp - local_14]          # 0046a8bb
    movsx edx, word ptr [ecx + field_7e]         # 0046a8be
    imul edx, edx, 0x8d                          # 0046a8c2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a8c8
    mov ecx, dword ptr [eax + field_596]         # 0046a8ce
    mov dword ptr [0x5bb59b], ecx                # 0046a8d4
    mov edx, dword ptr [ebp - local_14]          # 0046a8da
    movsx eax, word ptr [edx + field_7e]         # 0046a8dd
    imul eax, eax, 0x8d                          # 0046a8e1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046a8e7
    mov edx, dword ptr [ecx + field_59a]         # 0046a8ed
    mov dword ptr [0x5bb59f], edx                # 0046a8f3
    mov eax, dword ptr [ebp - local_14]          # 0046a8f9
    movsx ecx, word ptr [eax + field_7e]         # 0046a8fc
    imul ecx, ecx, 0x8d                          # 0046a900
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046a906
    mov eax, dword ptr [edx + field_59e]         # 0046a90c
    mov dword ptr [0x5bb5a3], eax                # 0046a912
    mov ecx, dword ptr [ebp - local_14]          # 0046a917
    movsx edx, word ptr [ecx + field_7e]         # 0046a91a
    imul edx, edx, 0x8d                          # 0046a91e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046a924
    movsx ecx, word ptr [eax + field_5a2]        # 0046a92a
    cmp ecx, 0x1                                 # 0046a931
    jne.d8 L_0046a942                            # 0046a934
    # block 0x0046a936: entered by fall-through of jne at 0x0046a934, 2 instruction(s), ends with forward jump to 0x0046a94c
    mov dword ptr [0x5bb1ca], 0x0                # 0046a936
    jmp.d8 L_0046a94c                            # 0046a940
L_0046a942:
    # block 0x0046a942: entered by jne at 0x0046a934, 1 instruction(s), falls into the block at 0x0046a94c
    mov dword ptr [0x5bb1ca], 0x1                # 0046a942
L_0046a94c:
    # block 0x0046a94c: entered by jmp at 0x0046a940, 1 instruction(s), falls into the block at 0x0046a956
    mov dword ptr [0x583999], 0x4                # 0046a94c
L_0046a956:
    # block 0x0046a956: entered by je at 0x0046a834, 7 instruction(s), calls FUN_0042ba3a, FUN_00468f19, falls into the block at 0x0046a96e
    mov edx, dword ptr [ebp - local_14]          # 0046a956
    mov ax, word ptr [edx + field_7e]            # 0046a959
    push eax                                     # 0046a95d
    call FUN_0042ba3a                            # 0046a95e
    add esp, 0x4                                 # 0046a963
    mov ecx, dword ptr [ebp - local_14]          # 0046a966
    call FUN_00468f19                            # 0046a969
L_0046a96e:
    # block 0x0046a96e: entered by jmp at 0x00469632; jmp at 0x0046a0eb; jmp at 0x0046a7ba, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0046a96e
    pop esi                                      # 0046a96f
    {load} mov esp, ebp                          # 0046a970
    pop ebp                                      # 0046a972
    ret 0x4                                      # 0046a973

# --- data items (not part of the function) -------------------------
.org 0x0046a976 - 0x401000
SWTAB_0046a976:  # 6 case address(es)
    .long L_0046a5f6 - .text + 0x401000
    .long L_0046a5f6 - .text + 0x401000
    .long L_0046a5f6 - .text + 0x401000
    .long L_0046a60b - .text + 0x401000
    .long L_0046a60b - .text + 0x401000
    .long L_0046a60b - .text + 0x401000
.set SWTAB_0046a976_VA, SWTAB_0046a976 - .text + 0x401000

