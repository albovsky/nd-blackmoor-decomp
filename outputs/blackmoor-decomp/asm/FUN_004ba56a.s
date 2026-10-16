# FUN_004ba56a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba56a
# extent:       0x004ba56a-0x004bb209 (3231 code bytes)
# span:         0x004ba56a-0x004bb219 (code 3231, tables 16, padding 0)
# sha256:       65805d17aa0b375599a0091bba9c4e7bc3befdd820609f2f9b2d39ed8328d940
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ba56a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       23 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 11 more
# fields:       [eax + n] field_4, field_8, field_c, field_18, field_20, field_3c, field_40, field_48, field_d8, field_e0, field_174, field_178 and 27 more; [ecx + n] field_4, field_8, field_c, field_18, field_20, field_38, field_48, field_174, field_18c, field_190, field_1ac, field_1b0 and 17 more; [edx + n] field_4, field_8, field_c, field_18, field_20, field_3c, field_d8, field_174, field_1a0, field_1b0, field_1b8, field_1bc and 24 more
# callees:      calls KERNEL32.dll!GetTickCount, USER32.dll!GetAsyncKeyState, FUN_0050ce04, FUN_0050cd50, FUN_004be44d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 761 instruction(s), 49 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_20, 0x20  # offset +0x20
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_48, 0x48  # offset +0x48
.equ field_d8, 0xd8  # offset +0xd8
.equ field_e0, 0xe0  # offset +0xe0
.equ field_174, 0x174  # offset +0x174
.equ field_178, 0x178  # offset +0x178
.equ field_18c, 0x18c  # offset +0x18c
.equ field_190, 0x190  # offset +0x190
.equ field_1a0, 0x1a0  # offset +0x1a0
.equ field_1ac, 0x1ac  # offset +0x1ac
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1b4, 0x1b4  # offset +0x1b4
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1d0, 0x1d0  # offset +0x1d0
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1d8, 0x1d8  # offset +0x1d8
.equ field_200, 0x200  # offset +0x200
.equ field_204, 0x204  # offset +0x204
.equ field_2c4, 0x2c4  # offset +0x2c4
.equ field_2c8, 0x2c8  # offset +0x2c8
.equ field_2cc, 0x2cc  # offset +0x2cc
.equ field_2d0, 0x2d0  # offset +0x2d0
.equ field_2d8, 0x2d8  # offset +0x2d8
.equ field_2dc, 0x2dc  # offset +0x2dc
.equ field_2e0, 0x2e0  # offset +0x2e0
.equ field_2e4, 0x2e4  # offset +0x2e4
.equ field_2e8, 0x2e8  # offset +0x2e8
.equ field_2ec, 0x2ec  # offset +0x2ec
.equ field_2f0, 0x2f0  # offset +0x2f0
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fc, 0x2fc  # offset +0x2fc
.equ field_300, 0x300  # offset +0x300
.equ field_304, 0x304  # offset +0x304
.equ field_308, 0x308  # offset +0x308
.equ field_89c, 0x89c  # offset +0x89c
.equ field_8a0, 0x8a0  # offset +0x8a0
.equ field_8a4, 0x8a4  # offset +0x8a4
.equ field_8a8, 0x8a8  # offset +0x8a8
.equ field_8ac, 0x8ac  # offset +0x8ac
.equ field_8e8, 0x8e8  # offset +0x8e8
.equ field_922, 0x922  # offset +0x922

# --- external targets -----------------------------------------------
.set FUN_004be44d, .text + (0x004be44d - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004ba56a - 0x401000
.globl FUN_004ba56a
FUN_004ba56a:
    # block 0x004ba56a: entry, 7 instruction(s), ends with jne to 0x004ba58e (forward)
    push ebp                                     # 004ba56a
    {load} mov ebp, esp                          # 004ba56b
    sub esp, 0x5c                                # 004ba56d
    mov dword ptr [ebp - local_8], ecx           # 004ba570
    mov eax, dword ptr [ebp - local_8]           # 004ba573
    cmp dword ptr [eax + field_40], 0x0          # 004ba576
    jne.d8 L_004ba58e                            # 004ba57a
    # block 0x004ba57c: entered by fall-through of jne at 0x004ba57a, 3 instruction(s), ends with jne to 0x004ba58e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba57c
    cmp dword ptr [ecx + field_38], 0x0          # 004ba57f
    jne.d8 L_004ba58e                            # 004ba583
    # block 0x004ba585: entered by fall-through of jne at 0x004ba583, 3 instruction(s), ends with je to 0x004ba593 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba585
    cmp dword ptr [edx + field_3c], 0x0          # 004ba588
    je.d8 L_004ba593                             # 004ba58c
L_004ba58e:
    # block 0x004ba58e: entered by jne at 0x004ba57a; jne at 0x004ba583; fall-through of je at 0x004ba58c, 1 instruction(s), ends with forward jump to 0x004bb205
    jmp.d32 L_004bb205                           # 004ba58e
L_004ba593:
    # block 0x004ba593: entered by je at 0x004ba58c, 38 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ja to 0x004bb205 (forward)
    call dword ptr [0x52a23c]                    # 004ba593
    mov ecx, dword ptr [ebp - local_8]           # 004ba599
    mov dword ptr [ecx + field_2d8], eax         # 004ba59c
    mov edx, dword ptr [ebp - local_8]           # 004ba5a2
    mov eax, dword ptr [ebp - local_8]           # 004ba5a5
    mov ecx, dword ptr [edx + field_2d8]         # 004ba5a8
    sub ecx, dword ptr [eax + field_2dc]         # 004ba5ae
    mov edx, dword ptr [ebp - local_8]           # 004ba5b4
    mov dword ptr [edx + field_2e8], ecx         # 004ba5b7
    mov eax, dword ptr [ebp - local_8]           # 004ba5bd
    mov ecx, dword ptr [ebp - local_8]           # 004ba5c0
    mov edx, dword ptr [eax + field_2d8]         # 004ba5c3
    sub edx, dword ptr [ecx + field_2e0]         # 004ba5c9
    mov eax, dword ptr [ebp - local_8]           # 004ba5cf
    mov dword ptr [eax + field_2ec], edx         # 004ba5d2
    mov ecx, dword ptr [ebp - local_8]           # 004ba5d8
    mov edx, dword ptr [ebp - local_8]           # 004ba5db
    mov eax, dword ptr [ecx + field_2d8]         # 004ba5de
    sub eax, dword ptr [edx + field_2e4]         # 004ba5e4
    mov ecx, dword ptr [ebp - local_8]           # 004ba5ea
    mov dword ptr [ecx + field_2f0], eax         # 004ba5ed
    mov edx, dword ptr [ebp - local_8]           # 004ba5f3
    mov eax, dword ptr [ebp - local_8]           # 004ba5f6
    mov ecx, dword ptr [eax + field_2d8]         # 004ba5f9
    mov dword ptr [edx + field_2dc], ecx         # 004ba5ff
    mov edx, dword ptr [ebp - local_8]           # 004ba605
    mov eax, dword ptr [ebp - local_8]           # 004ba608
    mov ecx, dword ptr [eax + field_2d8]         # 004ba60b
    mov dword ptr [edx + field_2e0], ecx         # 004ba611
    mov edx, dword ptr [ebp - local_8]           # 004ba617
    mov eax, dword ptr [ebp - local_8]           # 004ba61a
    mov ecx, dword ptr [eax + field_2d8]         # 004ba61d
    mov dword ptr [edx + field_2e4], ecx         # 004ba623
    mov edx, dword ptr [ebp - local_8]           # 004ba629
    mov eax, dword ptr [edx + field_20]          # 004ba62c
    mov dword ptr [ebp - local_c], eax           # 004ba62f
    cmp dword ptr [ebp - local_c], 0x3           # 004ba632
    ja.d32 L_004bb205                            # 004ba636
    # block 0x004ba63c: entered by fall-through of ja at 0x004ba636, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4bb209]
    mov ecx, dword ptr [ebp - local_c]           # 004ba63c
    jmp dword ptr [4*ecx + SWTAB_004bb209_VA]    # 004ba63f
L_004ba646:
    # block 0x004ba646: entered by switch case, 9 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x004ba7ae (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba646
    mov eax, dword ptr [edx + field_18]          # 004ba649
    mov ecx, dword ptr [eax + field_89c]         # 004ba64c
    push ecx                                     # 004ba652
    call dword ptr [0x52a4b4]                    # 004ba653
    movsx edx, ax                                # 004ba659
    and edx, 0x8000                              # 004ba65c
    test edx, edx                                # 004ba662
    je.d32 L_004ba7ae                            # 004ba664
    # block 0x004ba66a: entered by fall-through of je at 0x004ba664, 38 instruction(s), calls FUN_0050ce04, ends with jge to 0x004ba723 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ba66a
    add eax, 0x1bc                               # 004ba66d
    mov ecx, dword ptr [ebp - local_8]           # 004ba672
    add ecx, 0x1cc                               # 004ba675
    mov edx, dword ptr [eax]                     # 004ba67b
    mov dword ptr [ecx], edx                     # 004ba67d
    mov edx, dword ptr [eax + field_4]           # 004ba67f
    mov dword ptr [ecx + field_4], edx           # 004ba682
    mov edx, dword ptr [eax + field_8]           # 004ba685
    mov dword ptr [ecx + field_8], edx           # 004ba688
    mov eax, dword ptr [eax + field_c]           # 004ba68b
    mov dword ptr [ecx + field_c], eax           # 004ba68e
    mov ecx, dword ptr [ebp - local_8]           # 004ba691
    mov edx, dword ptr [ecx + field_304]         # 004ba694
    mov dword ptr [ebp - local_4], edx           # 004ba69a
    mov eax, dword ptr [ebp - local_8]           # 004ba69d
    mov ecx, dword ptr [eax + field_2e8]         # 004ba6a0
    mov dword ptr [ebp - local_14], ecx          # 004ba6a6
    mov dword ptr [ebp - local_10], 0x0          # 004ba6a9
    fild qword ptr [ebp - local_14]              # 004ba6b0
    fstp dword ptr [ebp - local_18]              # 004ba6b3
    mov edx, dword ptr [ebp - local_8]           # 004ba6b6
    fld dword ptr [ebp - local_18]               # 004ba6b9
    fmul dword ptr [edx + field_2f8]             # 004ba6bc
    mov eax, dword ptr [ebp - local_8]           # 004ba6c2
    fsubr dword ptr [eax + field_304]            # 004ba6c5
    mov ecx, dword ptr [ebp - local_8]           # 004ba6cb
    fstp dword ptr [ecx + field_304]             # 004ba6ce
    mov edx, dword ptr [ebp - local_8]           # 004ba6d4
    fld dword ptr [edx + field_304]              # 004ba6d7
    call FUN_0050ce04                            # 004ba6dd
    mov ecx, dword ptr [ebp - local_8]           # 004ba6e2
    mov dword ptr [ecx + field_1bc], eax         # 004ba6e5
    mov edx, dword ptr [ebp - local_8]           # 004ba6eb
    mov eax, dword ptr [ebp - local_8]           # 004ba6ee
    mov ecx, dword ptr [edx + field_1bc]         # 004ba6f1
    cmp ecx, dword ptr [eax + field_d8]          # 004ba6f7
    jge.d8 L_004ba723                            # 004ba6fd
    # block 0x004ba6ff: entered by fall-through of jge at 0x004ba6fd, 8 instruction(s), falls into the block at 0x004ba723
    mov edx, dword ptr [ebp - local_8]           # 004ba6ff
    mov eax, dword ptr [ebp - local_8]           # 004ba702
    mov ecx, dword ptr [eax + field_d8]          # 004ba705
    mov dword ptr [edx + field_1bc], ecx         # 004ba70b
    mov edx, dword ptr [ebp - local_8]           # 004ba711
    fild dword ptr [edx + field_d8]              # 004ba714
    mov eax, dword ptr [ebp - local_8]           # 004ba71a
    fstp dword ptr [eax + field_304]             # 004ba71d
L_004ba723:
    # block 0x004ba723: entered by jge at 0x004ba6fd, 12 instruction(s), ends with jne to 0x004ba792 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba723
    mov edx, dword ptr [ecx + field_1bc]         # 004ba726
    mov eax, dword ptr [ebp - local_8]           # 004ba72c
    mov ecx, dword ptr [eax + field_18c]         # 004ba72f
    lea edx, [edx + ecx - field_minus_1]         # 004ba735
    mov eax, dword ptr [ebp - local_8]           # 004ba739
    mov dword ptr [eax + field_1c4], edx         # 004ba73c
    mov ecx, dword ptr [ebp - local_8]           # 004ba742
    mov edx, dword ptr [ebp - local_8]           # 004ba745
    mov eax, dword ptr [ecx + field_1bc]         # 004ba748
    cmp eax, dword ptr [edx + field_1cc]         # 004ba74e
    jne.d8 L_004ba792                            # 004ba754
    # block 0x004ba756: entered by fall-through of jne at 0x004ba754, 5 instruction(s), ends with jne to 0x004ba792 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba756
    mov edx, dword ptr [ebp - local_8]           # 004ba759
    mov eax, dword ptr [ecx + field_1c4]         # 004ba75c
    cmp eax, dword ptr [edx + field_1d4]         # 004ba762
    jne.d8 L_004ba792                            # 004ba768
    # block 0x004ba76a: entered by fall-through of jne at 0x004ba768, 5 instruction(s), ends with jne to 0x004ba792 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba76a
    mov edx, dword ptr [ebp - local_8]           # 004ba76d
    mov eax, dword ptr [ecx + field_1c0]         # 004ba770
    cmp eax, dword ptr [edx + field_1d0]         # 004ba776
    jne.d8 L_004ba792                            # 004ba77c
    # block 0x004ba77e: entered by fall-through of jne at 0x004ba77c, 5 instruction(s), ends with je to 0x004ba79f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba77e
    mov edx, dword ptr [ebp - local_8]           # 004ba781
    mov eax, dword ptr [ecx + field_1c8]         # 004ba784
    cmp eax, dword ptr [edx + field_1d8]         # 004ba78a
    je.d8 L_004ba79f                             # 004ba790
L_004ba792:
    # block 0x004ba792: entered by jne at 0x004ba754; jne at 0x004ba768; jne at 0x004ba77c; fall-through of je at 0x004ba790, 2 instruction(s), falls into the block at 0x004ba79f
    mov ecx, dword ptr [ebp - local_8]           # 004ba792
    mov dword ptr [ecx + field_1b0], 0x1         # 004ba795
L_004ba79f:
    # block 0x004ba79f: entered by je at 0x004ba790, 3 instruction(s), ends with forward jump to 0x004baf32
    mov edx, dword ptr [ebp - local_8]           # 004ba79f
    mov dword ptr [edx + field_20], 0x0          # 004ba7a2
    jmp.d32 L_004baf32                           # 004ba7a9
L_004ba7ae:
    # block 0x004ba7ae: entered by je at 0x004ba664, 9 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x004ba934 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ba7ae
    mov ecx, dword ptr [eax + field_18]          # 004ba7b1
    mov edx, dword ptr [ecx + field_8a0]         # 004ba7b4
    push edx                                     # 004ba7ba
    call dword ptr [0x52a4b4]                    # 004ba7bb
    movsx eax, ax                                # 004ba7c1
    and eax, 0x8000                              # 004ba7c4
    test eax, eax                                # 004ba7c9
    je.d32 L_004ba934                            # 004ba7cb
    # block 0x004ba7d1: entered by fall-through of je at 0x004ba7cb, 45 instruction(s), calls FUN_0050ce04, ends with jle to 0x004ba8c8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba7d1
    add ecx, 0x1bc                               # 004ba7d4
    mov edx, dword ptr [ebp - local_8]           # 004ba7da
    add edx, 0x1cc                               # 004ba7dd
    mov eax, dword ptr [ecx]                     # 004ba7e3
    mov dword ptr [edx], eax                     # 004ba7e5
    mov eax, dword ptr [ecx + field_4]           # 004ba7e7
    mov dword ptr [edx + field_4], eax           # 004ba7ea
    mov eax, dword ptr [ecx + field_8]           # 004ba7ed
    mov dword ptr [edx + field_8], eax           # 004ba7f0
    mov ecx, dword ptr [ecx + field_c]           # 004ba7f3
    mov dword ptr [edx + field_c], ecx           # 004ba7f6
    mov edx, dword ptr [ebp - local_8]           # 004ba7f9
    mov eax, dword ptr [edx + field_304]         # 004ba7fc
    mov dword ptr [ebp - local_4], eax           # 004ba802
    mov ecx, dword ptr [ebp - local_8]           # 004ba805
    mov edx, dword ptr [ecx + field_2e8]         # 004ba808
    mov dword ptr [ebp - local_20], edx          # 004ba80e
    mov dword ptr [ebp - local_1c], 0x0          # 004ba811
    fild qword ptr [ebp - local_20]              # 004ba818
    fstp dword ptr [ebp - local_24]              # 004ba81b
    mov eax, dword ptr [ebp - local_8]           # 004ba81e
    fld dword ptr [ebp - local_24]               # 004ba821
    fmul dword ptr [eax + field_2f8]             # 004ba824
    mov ecx, dword ptr [ebp - local_8]           # 004ba82a
    fadd dword ptr [ecx + field_304]             # 004ba82d
    mov edx, dword ptr [ebp - local_8]           # 004ba833
    fstp dword ptr [edx + field_304]             # 004ba836
    mov eax, dword ptr [ebp - local_8]           # 004ba83c
    fld dword ptr [eax + field_304]              # 004ba83f
    call FUN_0050ce04                            # 004ba845
    mov ecx, dword ptr [ebp - local_8]           # 004ba84a
    mov dword ptr [ecx + field_1bc], eax         # 004ba84d
    mov edx, dword ptr [ebp - local_8]           # 004ba853
    mov eax, dword ptr [edx + field_1bc]         # 004ba856
    mov ecx, dword ptr [ebp - local_8]           # 004ba85c
    mov edx, dword ptr [ecx + field_18c]         # 004ba85f
    lea eax, [eax + edx - field_minus_1]         # 004ba865
    mov ecx, dword ptr [ebp - local_8]           # 004ba869
    mov dword ptr [ecx + field_1c4], eax         # 004ba86c
    mov edx, dword ptr [ebp - local_8]           # 004ba872
    mov eax, dword ptr [ebp - local_8]           # 004ba875
    mov ecx, dword ptr [edx + field_1c4]         # 004ba878
    cmp ecx, dword ptr [eax + field_e0]          # 004ba87e
    jle.d8 L_004ba8c8                            # 004ba884
    # block 0x004ba886: entered by fall-through of jle at 0x004ba884, 15 instruction(s), falls into the block at 0x004ba8c8
    mov edx, dword ptr [ebp - local_8]           # 004ba886
    mov eax, dword ptr [ebp - local_8]           # 004ba889
    mov ecx, dword ptr [eax + field_e0]          # 004ba88c
    mov dword ptr [edx + field_1c4], ecx         # 004ba892
    mov edx, dword ptr [ebp - local_8]           # 004ba898
    mov eax, dword ptr [ebp - local_8]           # 004ba89b
    mov ecx, dword ptr [edx + field_1c4]         # 004ba89e
    sub ecx, dword ptr [eax + field_18c]         # 004ba8a4
    add ecx, 0x1                                 # 004ba8aa
    mov edx, dword ptr [ebp - local_8]           # 004ba8ad
    mov dword ptr [edx + field_1bc], ecx         # 004ba8b0
    mov eax, dword ptr [ebp - local_8]           # 004ba8b6
    fild dword ptr [eax + field_1bc]             # 004ba8b9
    mov ecx, dword ptr [ebp - local_8]           # 004ba8bf
    fstp dword ptr [ecx + field_304]             # 004ba8c2
L_004ba8c8:
    # block 0x004ba8c8: entered by jle at 0x004ba884, 5 instruction(s), ends with jne to 0x004ba918 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba8c8
    mov eax, dword ptr [ebp - local_8]           # 004ba8cb
    mov ecx, dword ptr [edx + field_1bc]         # 004ba8ce
    cmp ecx, dword ptr [eax + field_1cc]         # 004ba8d4
    jne.d8 L_004ba918                            # 004ba8da
    # block 0x004ba8dc: entered by fall-through of jne at 0x004ba8da, 5 instruction(s), ends with jne to 0x004ba918 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba8dc
    mov eax, dword ptr [ebp - local_8]           # 004ba8df
    mov ecx, dword ptr [edx + field_1c4]         # 004ba8e2
    cmp ecx, dword ptr [eax + field_1d4]         # 004ba8e8
    jne.d8 L_004ba918                            # 004ba8ee
    # block 0x004ba8f0: entered by fall-through of jne at 0x004ba8ee, 5 instruction(s), ends with jne to 0x004ba918 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba8f0
    mov eax, dword ptr [ebp - local_8]           # 004ba8f3
    mov ecx, dword ptr [edx + field_1c0]         # 004ba8f6
    cmp ecx, dword ptr [eax + field_1d0]         # 004ba8fc
    jne.d8 L_004ba918                            # 004ba902
    # block 0x004ba904: entered by fall-through of jne at 0x004ba902, 5 instruction(s), ends with je to 0x004ba925 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba904
    mov eax, dword ptr [ebp - local_8]           # 004ba907
    mov ecx, dword ptr [edx + field_1c8]         # 004ba90a
    cmp ecx, dword ptr [eax + field_1d8]         # 004ba910
    je.d8 L_004ba925                             # 004ba916
L_004ba918:
    # block 0x004ba918: entered by jne at 0x004ba8da; jne at 0x004ba8ee; jne at 0x004ba902; fall-through of je at 0x004ba916, 2 instruction(s), falls into the block at 0x004ba925
    mov edx, dword ptr [ebp - local_8]           # 004ba918
    mov dword ptr [edx + field_1b0], 0x1         # 004ba91b
L_004ba925:
    # block 0x004ba925: entered by je at 0x004ba916, 3 instruction(s), ends with forward jump to 0x004baf32
    mov eax, dword ptr [ebp - local_8]           # 004ba925
    mov dword ptr [eax + field_20], 0x0          # 004ba928
    jmp.d32 L_004baf32                           # 004ba92f
L_004ba934:
    # block 0x004ba934: entered by je at 0x004ba7cb, 9 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x004bab25 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ba934
    mov edx, dword ptr [ecx + field_18]          # 004ba937
    mov eax, dword ptr [edx + field_8a8]         # 004ba93a
    push eax                                     # 004ba940
    call dword ptr [0x52a4b4]                    # 004ba941
    movsx ecx, ax                                # 004ba947
    and ecx, 0x8000                              # 004ba94a
    test ecx, ecx                                # 004ba950
    je.d32 L_004bab25                            # 004ba952
    # block 0x004ba958: entered by fall-through of je at 0x004ba952, 42 instruction(s), calls FUN_0050ce04, ends with jle to 0x004baa42 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ba958
    add edx, 0x1bc                               # 004ba95b
    mov eax, dword ptr [ebp - local_8]           # 004ba961
    add eax, 0x1cc                               # 004ba964
    mov ecx, dword ptr [edx]                     # 004ba969
    mov dword ptr [eax], ecx                     # 004ba96b
    mov ecx, dword ptr [edx + field_4]           # 004ba96d
    mov dword ptr [eax + field_4], ecx           # 004ba970
    mov ecx, dword ptr [edx + field_8]           # 004ba973
    mov dword ptr [eax + field_8], ecx           # 004ba976
    mov edx, dword ptr [edx + field_c]           # 004ba979
    mov dword ptr [eax + field_c], edx           # 004ba97c
    mov eax, dword ptr [ebp - local_8]           # 004ba97f
    mov ecx, dword ptr [eax + field_2ec]         # 004ba982
    mov dword ptr [ebp - local_2c], ecx          # 004ba988
    mov dword ptr [ebp - local_28], 0x0          # 004ba98b
    fild qword ptr [ebp - local_2c]              # 004ba992
    fstp dword ptr [ebp - local_30]              # 004ba995
    mov edx, dword ptr [ebp - local_8]           # 004ba998
    fld dword ptr [ebp - local_30]               # 004ba99b
    fmul dword ptr [edx + field_2fc]             # 004ba99e
    mov eax, dword ptr [ebp - local_8]           # 004ba9a4
    fadd dword ptr [eax + field_308]             # 004ba9a7
    mov ecx, dword ptr [ebp - local_8]           # 004ba9ad
    fstp dword ptr [ecx + field_308]             # 004ba9b0
    mov edx, dword ptr [ebp - local_8]           # 004ba9b6
    fld dword ptr [edx + field_308]              # 004ba9b9
    call FUN_0050ce04                            # 004ba9bf
    mov ecx, dword ptr [ebp - local_8]           # 004ba9c4
    mov dword ptr [ecx + field_1c0], eax         # 004ba9c7
    mov edx, dword ptr [ebp - local_8]           # 004ba9cd
    mov eax, dword ptr [edx + field_1c0]         # 004ba9d0
    mov ecx, dword ptr [ebp - local_8]           # 004ba9d6
    mov edx, dword ptr [ecx + field_190]         # 004ba9d9
    lea eax, [eax + edx - field_minus_1]         # 004ba9df
    mov ecx, dword ptr [ebp - local_8]           # 004ba9e3
    mov dword ptr [ecx + field_1c8], eax         # 004ba9e6
    mov edx, dword ptr [ebp - local_8]           # 004ba9ec
    mov eax, dword ptr [ebp - local_8]           # 004ba9ef
    mov ecx, dword ptr [edx + field_1c8]         # 004ba9f2
    cmp ecx, dword ptr [eax + field_178]         # 004ba9f8
    jle.d8 L_004baa42                            # 004ba9fe
    # block 0x004baa00: entered by fall-through of jle at 0x004ba9fe, 15 instruction(s), falls into the block at 0x004baa42
    mov edx, dword ptr [ebp - local_8]           # 004baa00
    mov eax, dword ptr [ebp - local_8]           # 004baa03
    mov ecx, dword ptr [eax + field_178]         # 004baa06
    mov dword ptr [edx + field_1c8], ecx         # 004baa0c
    mov edx, dword ptr [ebp - local_8]           # 004baa12
    mov eax, dword ptr [ebp - local_8]           # 004baa15
    mov ecx, dword ptr [edx + field_1c8]         # 004baa18
    sub ecx, dword ptr [eax + field_190]         # 004baa1e
    add ecx, 0x1                                 # 004baa24
    mov edx, dword ptr [ebp - local_8]           # 004baa27
    mov dword ptr [edx + field_1c0], ecx         # 004baa2a
    mov eax, dword ptr [ebp - local_8]           # 004baa30
    fild dword ptr [eax + field_1c0]             # 004baa33
    mov ecx, dword ptr [ebp - local_8]           # 004baa39
    fstp dword ptr [ecx + field_308]             # 004baa3c
L_004baa42:
    # block 0x004baa42: entered by jle at 0x004ba9fe, 5 instruction(s), ends with jne to 0x004baa92 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baa42
    mov eax, dword ptr [ebp - local_8]           # 004baa45
    mov ecx, dword ptr [edx + field_1bc]         # 004baa48
    cmp ecx, dword ptr [eax + field_1cc]         # 004baa4e
    jne.d8 L_004baa92                            # 004baa54
    # block 0x004baa56: entered by fall-through of jne at 0x004baa54, 5 instruction(s), ends with jne to 0x004baa92 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baa56
    mov eax, dword ptr [ebp - local_8]           # 004baa59
    mov ecx, dword ptr [edx + field_1c4]         # 004baa5c
    cmp ecx, dword ptr [eax + field_1d4]         # 004baa62
    jne.d8 L_004baa92                            # 004baa68
    # block 0x004baa6a: entered by fall-through of jne at 0x004baa68, 5 instruction(s), ends with jne to 0x004baa92 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baa6a
    mov eax, dword ptr [ebp - local_8]           # 004baa6d
    mov ecx, dword ptr [edx + field_1c0]         # 004baa70
    cmp ecx, dword ptr [eax + field_1d0]         # 004baa76
    jne.d8 L_004baa92                            # 004baa7c
    # block 0x004baa7e: entered by fall-through of jne at 0x004baa7c, 5 instruction(s), ends with je to 0x004baa9f (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baa7e
    mov eax, dword ptr [ebp - local_8]           # 004baa81
    mov ecx, dword ptr [edx + field_1c8]         # 004baa84
    cmp ecx, dword ptr [eax + field_1d8]         # 004baa8a
    je.d8 L_004baa9f                             # 004baa90
L_004baa92:
    # block 0x004baa92: entered by jne at 0x004baa54; jne at 0x004baa68; jne at 0x004baa7c; fall-through of je at 0x004baa90, 2 instruction(s), falls into the block at 0x004baa9f
    mov edx, dword ptr [ebp - local_8]           # 004baa92
    mov dword ptr [edx + field_1b0], 0x1         # 004baa95
L_004baa9f:
    # block 0x004baa9f: entered by je at 0x004baa90, 5 instruction(s), ends with jne to 0x004bab20 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004baa9f
    mov dword ptr [eax + field_20], 0x0          # 004baaa2
    mov ecx, dword ptr [ebp - local_8]           # 004baaa9
    cmp dword ptr [ecx + field_2cc], 0x0         # 004baaac
    jne.d8 L_004bab20                            # 004baab3
    # block 0x004baab5: entered by fall-through of jne at 0x004baab3, 5 instruction(s), ends with jle to 0x004bab20 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baab5
    mov eax, dword ptr [ebp - local_8]           # 004baab8
    mov ecx, dword ptr [edx + field_1c0]         # 004baabb
    cmp ecx, dword ptr [eax + field_174]         # 004baac1
    jle.d8 L_004bab20                            # 004baac7
    # block 0x004baac9: entered by fall-through of jle at 0x004baac7, 17 instruction(s), falls into the block at 0x004bab20
    mov edx, dword ptr [ebp - local_8]           # 004baac9
    mov dword ptr [edx + field_2cc], 0x1         # 004baacc
    mov eax, dword ptr [ebp - local_8]           # 004baad6
    mov dword ptr [eax + field_2c4], 0x0         # 004baad9
    mov ecx, dword ptr [ebp - local_8]           # 004baae3
    mov edx, dword ptr [ecx + field_18]          # 004baae6
    mov eax, dword ptr [ebp - local_8]           # 004baae9
    mov ecx, dword ptr [eax + field_2d8]         # 004baaec
    add ecx, dword ptr [edx + field_8e8]         # 004baaf2
    mov edx, dword ptr [ebp - local_8]           # 004baaf8
    mov dword ptr [edx + field_2c8], ecx         # 004baafb
    mov eax, dword ptr [ebp - local_8]           # 004bab01
    mov ecx, dword ptr [ebp - local_8]           # 004bab04
    mov edx, dword ptr [ecx + field_2d8]         # 004bab07
    mov dword ptr [eax + field_204], edx         # 004bab0d
    mov eax, dword ptr [ebp - local_8]           # 004bab13
    mov dword ptr [eax + field_200], 0x3f800000  # 004bab16
L_004bab20:
    # block 0x004bab20: entered by jne at 0x004baab3; jle at 0x004baac7, 1 instruction(s), ends with forward jump to 0x004baf32
    jmp.d32 L_004baf32                           # 004bab20
L_004bab25:
    # block 0x004bab25: entered by je at 0x004ba952, 9 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x004bacc7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bab25
    mov edx, dword ptr [ecx + field_18]          # 004bab28
    mov eax, dword ptr [edx + field_8a4]         # 004bab2b
    push eax                                     # 004bab31
    call dword ptr [0x52a4b4]                    # 004bab32
    movsx ecx, ax                                # 004bab38
    and ecx, 0x8000                              # 004bab3b
    test ecx, ecx                                # 004bab41
    je.d32 L_004bacc7                            # 004bab43
    # block 0x004bab49: entered by fall-through of je at 0x004bab43, 42 instruction(s), calls FUN_0050ce04, ends with jge to 0x004bac5b (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bab49
    add edx, 0x1bc                               # 004bab4c
    mov eax, dword ptr [ebp - local_8]           # 004bab52
    add eax, 0x1cc                               # 004bab55
    mov ecx, dword ptr [edx]                     # 004bab5a
    mov dword ptr [eax], ecx                     # 004bab5c
    mov ecx, dword ptr [edx + field_4]           # 004bab5e
    mov dword ptr [eax + field_4], ecx           # 004bab61
    mov ecx, dword ptr [edx + field_8]           # 004bab64
    mov dword ptr [eax + field_8], ecx           # 004bab67
    mov edx, dword ptr [edx + field_c]           # 004bab6a
    mov dword ptr [eax + field_c], edx           # 004bab6d
    mov eax, dword ptr [ebp - local_8]           # 004bab70
    mov ecx, dword ptr [eax + field_2ec]         # 004bab73
    mov dword ptr [ebp - local_38], ecx          # 004bab79
    mov dword ptr [ebp - local_34], 0x0          # 004bab7c
    fild qword ptr [ebp - local_38]              # 004bab83
    fstp dword ptr [ebp - local_3c]              # 004bab86
    mov edx, dword ptr [ebp - local_8]           # 004bab89
    fld dword ptr [ebp - local_3c]               # 004bab8c
    fmul dword ptr [edx + field_2fc]             # 004bab8f
    mov eax, dword ptr [ebp - local_8]           # 004bab95
    fsubr dword ptr [eax + field_308]            # 004bab98
    mov ecx, dword ptr [ebp - local_8]           # 004bab9e
    fstp dword ptr [ecx + field_308]             # 004baba1
    mov edx, dword ptr [ebp - local_8]           # 004baba7
    fld dword ptr [edx + field_308]              # 004babaa
    call FUN_0050ce04                            # 004babb0
    mov ecx, dword ptr [ebp - local_8]           # 004babb5
    mov dword ptr [ecx + field_1c0], eax         # 004babb8
    mov edx, dword ptr [ebp - local_8]           # 004babbe
    mov eax, dword ptr [edx + field_1c0]         # 004babc1
    mov ecx, dword ptr [ebp - local_8]           # 004babc7
    mov edx, dword ptr [ecx + field_190]         # 004babca
    lea eax, [eax + edx - field_minus_1]         # 004babd0
    mov ecx, dword ptr [ebp - local_8]           # 004babd4
    mov dword ptr [ecx + field_1c8], eax         # 004babd7
    mov edx, dword ptr [ebp - local_8]           # 004babdd
    mov eax, dword ptr [ebp - local_8]           # 004babe0
    mov ecx, dword ptr [edx + field_1c0]         # 004babe3
    cmp ecx, dword ptr [eax + field_174]         # 004babe9
    jge.d8 L_004bac5b                            # 004babef
    # block 0x004babf1: entered by fall-through of jge at 0x004babef, 21 instruction(s), falls into the block at 0x004bac5b
    mov edx, dword ptr [ebp - local_8]           # 004babf1
    mov eax, dword ptr [ebp - local_8]           # 004babf4
    mov ecx, dword ptr [eax + field_174]         # 004babf7
    mov dword ptr [edx + field_1c0], ecx         # 004babfd
    mov edx, dword ptr [ebp - local_8]           # 004bac03
    mov eax, dword ptr [edx + field_1c0]         # 004bac06
    mov ecx, dword ptr [ebp - local_8]           # 004bac0c
    mov edx, dword ptr [ecx + field_190]         # 004bac0f
    lea eax, [eax + edx - field_minus_1]         # 004bac15
    mov ecx, dword ptr [ebp - local_8]           # 004bac19
    mov dword ptr [ecx + field_1c8], eax         # 004bac1c
    mov edx, dword ptr [ebp - local_8]           # 004bac22
    fild dword ptr [edx + field_1c0]             # 004bac25
    mov eax, dword ptr [ebp - local_8]           # 004bac2b
    fstp dword ptr [eax + field_308]             # 004bac2e
    mov ecx, dword ptr [ebp - local_8]           # 004bac34
    mov dword ptr [ecx + field_2c4], 0x0         # 004bac37
    mov edx, dword ptr [ebp - local_8]           # 004bac41
    mov dword ptr [edx + field_2cc], 0x0         # 004bac44
    mov eax, dword ptr [ebp - local_8]           # 004bac4e
    mov dword ptr [eax + field_200], 0x3f800000  # 004bac51
L_004bac5b:
    # block 0x004bac5b: entered by jge at 0x004babef, 5 instruction(s), ends with jne to 0x004bacab (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bac5b
    mov edx, dword ptr [ebp - local_8]           # 004bac5e
    mov eax, dword ptr [ecx + field_1bc]         # 004bac61
    cmp eax, dword ptr [edx + field_1cc]         # 004bac67
    jne.d8 L_004bacab                            # 004bac6d
    # block 0x004bac6f: entered by fall-through of jne at 0x004bac6d, 5 instruction(s), ends with jne to 0x004bacab (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bac6f
    mov edx, dword ptr [ebp - local_8]           # 004bac72
    mov eax, dword ptr [ecx + field_1c4]         # 004bac75
    cmp eax, dword ptr [edx + field_1d4]         # 004bac7b
    jne.d8 L_004bacab                            # 004bac81
    # block 0x004bac83: entered by fall-through of jne at 0x004bac81, 5 instruction(s), ends with jne to 0x004bacab (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bac83
    mov edx, dword ptr [ebp - local_8]           # 004bac86
    mov eax, dword ptr [ecx + field_1c0]         # 004bac89
    cmp eax, dword ptr [edx + field_1d0]         # 004bac8f
    jne.d8 L_004bacab                            # 004bac95
    # block 0x004bac97: entered by fall-through of jne at 0x004bac95, 5 instruction(s), ends with je to 0x004bacb8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bac97
    mov edx, dword ptr [ebp - local_8]           # 004bac9a
    mov eax, dword ptr [ecx + field_1c8]         # 004bac9d
    cmp eax, dword ptr [edx + field_1d8]         # 004baca3
    je.d8 L_004bacb8                             # 004baca9
L_004bacab:
    # block 0x004bacab: entered by jne at 0x004bac6d; jne at 0x004bac81; jne at 0x004bac95; fall-through of je at 0x004baca9, 2 instruction(s), falls into the block at 0x004bacb8
    mov ecx, dword ptr [ebp - local_8]           # 004bacab
    mov dword ptr [ecx + field_1b0], 0x1         # 004bacae
L_004bacb8:
    # block 0x004bacb8: entered by je at 0x004baca9, 3 instruction(s), ends with forward jump to 0x004baf32
    mov edx, dword ptr [ebp - local_8]           # 004bacb8
    mov dword ptr [edx + field_20], 0x0          # 004bacbb
    jmp.d32 L_004baf32                           # 004bacc2
L_004bacc7:
    # block 0x004bacc7: entered by je at 0x004bab43, 3 instruction(s), ends with je to 0x004bad88 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bacc7
    cmp dword ptr [eax + field_1b8], 0x0         # 004bacca
    je.d32 L_004bad88                            # 004bacd1
    # block 0x004bacd7: entered by fall-through of je at 0x004bacd1, 9 instruction(s), ends with je to 0x004bad88 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bacd7
    fild dword ptr [ecx + field_174]             # 004bacda
    fstp dword ptr [ebp - local_40]              # 004bace0
    mov edx, dword ptr [ebp - local_8]           # 004bace3
    fld dword ptr [edx + field_308]              # 004bace6
    fcomp dword ptr [ebp - local_40]             # 004bacec
    fnstsw ax                                    # 004bacef
    test ah, 0x40                                # 004bacf1
    je.d32 L_004bad88                            # 004bacf4
    # block 0x004bacfa: entered by fall-through of je at 0x004bacf4, 11 instruction(s), calls FUN_0050cd50, ends with jne to 0x004bad88 (forward)
    call FUN_0050cd50                            # 004bacfa
    mov ecx, dword ptr [ebp - local_8]           # 004bacff
    mov ecx, dword ptr [ecx + field_18]          # 004bad02
    cdq                                          # 004bad05
    idiv dword ptr [ecx + field_922]             # 004bad06
    mov eax, dword ptr [ebp - local_8]           # 004bad0c
    mov ecx, dword ptr [eax + field_18]          # 004bad0f
    mov eax, dword ptr [ecx + field_922]         # 004bad12
    sub eax, 0x1                                 # 004bad18
    {load} cmp edx, eax                          # 004bad1b
    jne.d8 L_004bad88                            # 004bad1d
    # block 0x004bad1f: entered by fall-through of jne at 0x004bad1d, 20 instruction(s), calls FUN_004be44d, ends with forward jump to 0x004bb205
    mov ecx, dword ptr [ebp - local_8]           # 004bad1f
    mov dword ptr [ecx + field_20], 0x1          # 004bad22
    mov edx, dword ptr [ebp - local_8]           # 004bad29
    mov dword ptr [edx + field_1a0], 0x0         # 004bad2c
    mov eax, dword ptr [ebp - local_8]           # 004bad36
    mov ecx, dword ptr [eax + field_18]          # 004bad39
    mov edx, dword ptr [ebp - local_8]           # 004bad3c
    mov eax, dword ptr [edx + field_2d8]         # 004bad3f
    add eax, dword ptr [ecx + field_8ac]         # 004bad45
    mov ecx, dword ptr [ebp - local_8]           # 004bad4b
    mov dword ptr [ecx + field_1ac], eax         # 004bad4e
    mov edx, dword ptr [ebp - local_8]           # 004bad54
    mov dword ptr [edx + field_1b0], 0x1         # 004bad57
    mov eax, dword ptr [ebp - local_8]           # 004bad61
    mov dword ptr [eax + field_2c4], 0x0         # 004bad64
    mov ecx, dword ptr [ebp - local_8]           # 004bad6e
    mov dword ptr [ecx + field_2cc], 0x0         # 004bad71
    mov ecx, dword ptr [ebp - local_8]           # 004bad7b
    call FUN_004be44d                            # 004bad7e
    jmp.d32 L_004bb205                           # 004bad83
L_004bad88:
    # block 0x004bad88: entered by je at 0x004bacd1; je at 0x004bacf4; jne at 0x004bad1d, 9 instruction(s), ends with jne to 0x004badb6 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bad88
    fild dword ptr [edx + field_174]             # 004bad8b
    fstp dword ptr [ebp - local_44]              # 004bad91
    mov eax, dword ptr [ebp - local_8]           # 004bad94
    fld dword ptr [eax + field_308]              # 004bad97
    fcomp dword ptr [ebp - local_44]             # 004bad9d
    fnstsw ax                                    # 004bada0
    test ah, 0x41                                # 004bada2
    jne.d8 L_004badb6                            # 004bada5
    # block 0x004bada7: entered by fall-through of jne at 0x004bada5, 3 instruction(s), ends with forward jump to 0x004baddd
    mov ecx, dword ptr [ebp - local_8]           # 004bada7
    mov dword ptr [ecx + field_1b8], 0x1         # 004badaa
    jmp.d8 L_004baddd                            # 004badb4
L_004badb6:
    # block 0x004badb6: entered by jne at 0x004bada5, 6 instruction(s), falls into the block at 0x004baddd
    mov edx, dword ptr [ebp - local_8]           # 004badb6
    mov dword ptr [edx + field_1b8], 0x0         # 004badb9
    mov eax, dword ptr [ebp - local_8]           # 004badc3
    mov dword ptr [eax + field_2cc], 0x0         # 004badc6
    mov ecx, dword ptr [ebp - local_8]           # 004badd0
    mov dword ptr [ecx + field_2c4], 0x0         # 004badd3
L_004baddd:
    # block 0x004baddd: entered by jmp at 0x004badb4, 42 instruction(s), calls FUN_0050ce04, ends with jge to 0x004baed5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baddd
    add edx, 0x1bc                               # 004bade0
    mov eax, dword ptr [ebp - local_8]           # 004bade6
    add eax, 0x1cc                               # 004bade9
    mov ecx, dword ptr [edx]                     # 004badee
    mov dword ptr [eax], ecx                     # 004badf0
    mov ecx, dword ptr [edx + field_4]           # 004badf2
    mov dword ptr [eax + field_4], ecx           # 004badf5
    mov ecx, dword ptr [edx + field_8]           # 004badf8
    mov dword ptr [eax + field_8], ecx           # 004badfb
    mov edx, dword ptr [edx + field_c]           # 004badfe
    mov dword ptr [eax + field_c], edx           # 004bae01
    mov eax, dword ptr [ebp - local_8]           # 004bae04
    mov ecx, dword ptr [eax + field_2f0]         # 004bae07
    mov dword ptr [ebp - local_4c], ecx          # 004bae0d
    mov dword ptr [ebp - local_48], 0x0          # 004bae10
    fild qword ptr [ebp - local_4c]              # 004bae17
    fstp dword ptr [ebp - local_50]              # 004bae1a
    mov edx, dword ptr [ebp - local_8]           # 004bae1d
    fld dword ptr [ebp - local_50]               # 004bae20
    fmul dword ptr [edx + field_300]             # 004bae23
    mov eax, dword ptr [ebp - local_8]           # 004bae29
    fsubr dword ptr [eax + field_308]            # 004bae2c
    mov ecx, dword ptr [ebp - local_8]           # 004bae32
    fstp dword ptr [ecx + field_308]             # 004bae35
    mov edx, dword ptr [ebp - local_8]           # 004bae3b
    fld dword ptr [edx + field_308]              # 004bae3e
    call FUN_0050ce04                            # 004bae44
    mov ecx, dword ptr [ebp - local_8]           # 004bae49
    mov dword ptr [ecx + field_1c0], eax         # 004bae4c
    mov edx, dword ptr [ebp - local_8]           # 004bae52
    mov eax, dword ptr [edx + field_1c0]         # 004bae55
    mov ecx, dword ptr [ebp - local_8]           # 004bae5b
    mov edx, dword ptr [ecx + field_190]         # 004bae5e
    lea eax, [eax + edx - field_minus_1]         # 004bae64
    mov ecx, dword ptr [ebp - local_8]           # 004bae68
    mov dword ptr [ecx + field_1c8], eax         # 004bae6b
    mov edx, dword ptr [ebp - local_8]           # 004bae71
    mov eax, dword ptr [ebp - local_8]           # 004bae74
    mov ecx, dword ptr [edx + field_1c0]         # 004bae77
    cmp ecx, dword ptr [eax + field_174]         # 004bae7d
    jge.d8 L_004baed5                            # 004bae83
    # block 0x004bae85: entered by fall-through of jge at 0x004bae83, 17 instruction(s), falls into the block at 0x004baed5
    mov edx, dword ptr [ebp - local_8]           # 004bae85
    mov eax, dword ptr [ebp - local_8]           # 004bae88
    mov ecx, dword ptr [eax + field_174]         # 004bae8b
    mov dword ptr [edx + field_1c0], ecx         # 004bae91
    mov edx, dword ptr [ebp - local_8]           # 004bae97
    mov eax, dword ptr [edx + field_1c0]         # 004bae9a
    mov ecx, dword ptr [ebp - local_8]           # 004baea0
    mov edx, dword ptr [ecx + field_190]         # 004baea3
    lea eax, [eax + edx - field_minus_1]         # 004baea9
    mov ecx, dword ptr [ebp - local_8]           # 004baead
    mov dword ptr [ecx + field_1c8], eax         # 004baeb0
    mov edx, dword ptr [ebp - local_8]           # 004baeb6
    fild dword ptr [edx + field_1c0]             # 004baeb9
    mov eax, dword ptr [ebp - local_8]           # 004baebf
    fstp dword ptr [eax + field_308]             # 004baec2
    mov ecx, dword ptr [ebp - local_8]           # 004baec8
    mov dword ptr [ecx + field_2c4], 0x0         # 004baecb
L_004baed5:
    # block 0x004baed5: entered by jge at 0x004bae83, 5 instruction(s), ends with jne to 0x004baf25 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baed5
    mov eax, dword ptr [ebp - local_8]           # 004baed8
    mov ecx, dword ptr [edx + field_1bc]         # 004baedb
    cmp ecx, dword ptr [eax + field_1cc]         # 004baee1
    jne.d8 L_004baf25                            # 004baee7
    # block 0x004baee9: entered by fall-through of jne at 0x004baee7, 5 instruction(s), ends with jne to 0x004baf25 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baee9
    mov eax, dword ptr [ebp - local_8]           # 004baeec
    mov ecx, dword ptr [edx + field_1c4]         # 004baeef
    cmp ecx, dword ptr [eax + field_1d4]         # 004baef5
    jne.d8 L_004baf25                            # 004baefb
    # block 0x004baefd: entered by fall-through of jne at 0x004baefb, 5 instruction(s), ends with jne to 0x004baf25 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baefd
    mov eax, dword ptr [ebp - local_8]           # 004baf00
    mov ecx, dword ptr [edx + field_1c0]         # 004baf03
    cmp ecx, dword ptr [eax + field_1d0]         # 004baf09
    jne.d8 L_004baf25                            # 004baf0f
    # block 0x004baf11: entered by fall-through of jne at 0x004baf0f, 5 instruction(s), ends with je to 0x004baf32 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004baf11
    mov eax, dword ptr [ebp - local_8]           # 004baf14
    mov ecx, dword ptr [edx + field_1c8]         # 004baf17
    cmp ecx, dword ptr [eax + field_1d8]         # 004baf1d
    je.d8 L_004baf32                             # 004baf23
L_004baf25:
    # block 0x004baf25: entered by jne at 0x004baee7; jne at 0x004baefb; jne at 0x004baf0f; fall-through of je at 0x004baf23, 2 instruction(s), falls into the block at 0x004baf32
    mov edx, dword ptr [ebp - local_8]           # 004baf25
    mov dword ptr [edx + field_1b0], 0x1         # 004baf28
L_004baf32:
    # block 0x004baf32: entered by jmp at 0x004ba7a9; jmp at 0x004ba92f; jmp at 0x004bab20; jmp at 0x004bacc2; more, 1 instruction(s), ends with forward jump to 0x004bb205
    jmp.d32 L_004bb205                           # 004baf32
L_004baf37:
    # block 0x004baf37: entered by switch case, 5 instruction(s), ends with jbe to 0x004bafae (forward)
    mov eax, dword ptr [ebp - local_8]           # 004baf37
    mov ecx, dword ptr [ebp - local_8]           # 004baf3a
    mov edx, dword ptr [eax + field_2d8]         # 004baf3d
    cmp edx, dword ptr [ecx + field_1ac]         # 004baf43
    jbe.d8 L_004bafae                            # 004baf49
    # block 0x004baf4b: entered by fall-through of jbe at 0x004baf49, 8 instruction(s), ends with jl to 0x004baf83 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004baf4b
    mov ecx, dword ptr [eax + field_1a0]         # 004baf4e
    add ecx, 0x1                                 # 004baf54
    mov edx, dword ptr [ebp - local_8]           # 004baf57
    mov dword ptr [edx + field_1a0], ecx         # 004baf5a
    mov eax, dword ptr [ebp - local_8]           # 004baf60
    cmp dword ptr [eax + field_1a0], 0x8         # 004baf63
    jl.d8 L_004baf83                             # 004baf6a
    # block 0x004baf6c: entered by fall-through of jl at 0x004baf6a, 4 instruction(s), falls into the block at 0x004baf83
    mov ecx, dword ptr [ebp - local_8]           # 004baf6c
    mov dword ptr [ecx + field_20], 0x0          # 004baf6f
    mov edx, dword ptr [ebp - local_8]           # 004baf76
    mov dword ptr [edx + field_1b8], 0x0         # 004baf79
L_004baf83:
    # block 0x004baf83: entered by jl at 0x004baf6a, 9 instruction(s), falls into the block at 0x004bafae
    mov eax, dword ptr [ebp - local_8]           # 004baf83
    mov ecx, dword ptr [eax + field_18]          # 004baf86
    mov edx, dword ptr [ebp - local_8]           # 004baf89
    mov eax, dword ptr [edx + field_2d8]         # 004baf8c
    add eax, dword ptr [ecx + field_8ac]         # 004baf92
    mov ecx, dword ptr [ebp - local_8]           # 004baf98
    mov dword ptr [ecx + field_1ac], eax         # 004baf9b
    mov edx, dword ptr [ebp - local_8]           # 004bafa1
    mov dword ptr [edx + field_1b0], 0x1         # 004bafa4
L_004bafae:
    # block 0x004bafae: entered by jbe at 0x004baf49, 1 instruction(s), ends with forward jump to 0x004bb205
    jmp.d32 L_004bb205                           # 004bafae
L_004bafb3:
    # block 0x004bafb3: entered by switch case, 3 instruction(s), ends with je to 0x004bb051 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bafb3
    cmp dword ptr [eax + field_48], 0x0          # 004bafb6
    je.d32 L_004bb051                            # 004bafba
    # block 0x004bafc0: entered by fall-through of je at 0x004bafba, 18 instruction(s), ends with jge to 0x004bb045 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bafc0
    add ecx, 0x1bc                               # 004bafc3
    mov edx, dword ptr [ebp - local_8]           # 004bafc9
    add edx, 0x1cc                               # 004bafcc
    mov eax, dword ptr [ecx]                     # 004bafd2
    mov dword ptr [edx], eax                     # 004bafd4
    mov eax, dword ptr [ecx + field_4]           # 004bafd6
    mov dword ptr [edx + field_4], eax           # 004bafd9
    mov eax, dword ptr [ecx + field_8]           # 004bafdc
    mov dword ptr [edx + field_8], eax           # 004bafdf
    mov ecx, dword ptr [ecx + field_c]           # 004bafe2
    mov dword ptr [edx + field_c], ecx           # 004bafe5
    mov edx, dword ptr [ebp - local_8]           # 004bafe8
    mov eax, dword ptr [edx + field_174]         # 004bafeb
    add eax, 0xa                                 # 004baff1
    mov ecx, dword ptr [ebp - local_8]           # 004baff4
    cmp dword ptr [ecx + field_1c0], eax         # 004baff7
    jge.d8 L_004bb045                            # 004baffd
    # block 0x004bafff: entered by fall-through of jge at 0x004baffd, 16 instruction(s), falls into the block at 0x004bb045
    mov edx, dword ptr [ebp - local_8]           # 004bafff
    mov eax, dword ptr [edx + field_174]         # 004bb002
    add eax, 0xa                                 # 004bb008
    mov ecx, dword ptr [ebp - local_8]           # 004bb00b
    mov dword ptr [ecx + field_1c0], eax         # 004bb00e
    mov edx, dword ptr [ebp - local_8]           # 004bb014
    mov eax, dword ptr [edx + field_1c0]         # 004bb017
    mov ecx, dword ptr [ebp - local_8]           # 004bb01d
    mov edx, dword ptr [ecx + field_190]         # 004bb020
    lea eax, [eax + edx - field_minus_1]         # 004bb026
    mov ecx, dword ptr [ebp - local_8]           # 004bb02a
    mov dword ptr [ecx + field_1c8], eax         # 004bb02d
    mov edx, dword ptr [ebp - local_8]           # 004bb033
    fild dword ptr [edx + field_1c0]             # 004bb036
    mov eax, dword ptr [ebp - local_8]           # 004bb03c
    fstp dword ptr [eax + field_308]             # 004bb03f
L_004bb045:
    # block 0x004bb045: entered by jge at 0x004baffd, 3 instruction(s), ends with forward jump to 0x004bb078
    mov ecx, dword ptr [ebp - local_8]           # 004bb045
    mov dword ptr [ecx + field_48], 0x0          # 004bb048
    jmp.d8 L_004bb078                            # 004bb04f
L_004bb051:
    # block 0x004bb051: entered by je at 0x004bafba, 12 instruction(s), falls into the block at 0x004bb078
    mov edx, dword ptr [ebp - local_8]           # 004bb051
    add edx, 0x1bc                               # 004bb054
    mov eax, dword ptr [ebp - local_8]           # 004bb05a
    add eax, 0x1cc                               # 004bb05d
    mov ecx, dword ptr [edx]                     # 004bb062
    mov dword ptr [eax], ecx                     # 004bb064
    mov ecx, dword ptr [edx + field_4]           # 004bb066
    mov dword ptr [eax + field_4], ecx           # 004bb069
    mov ecx, dword ptr [edx + field_8]           # 004bb06c
    mov dword ptr [eax + field_8], ecx           # 004bb06f
    mov edx, dword ptr [edx + field_c]           # 004bb072
    mov dword ptr [eax + field_c], edx           # 004bb075
L_004bb078:
    # block 0x004bb078: entered by jmp at 0x004bb04f, 30 instruction(s), calls FUN_0050ce04, ends with jge to 0x004bb19c (forward)
    mov eax, dword ptr [ebp - local_8]           # 004bb078
    mov ecx, dword ptr [eax + field_2f0]         # 004bb07b
    mov dword ptr [ebp - local_58], ecx          # 004bb081
    mov dword ptr [ebp - local_54], 0x0          # 004bb084
    fild qword ptr [ebp - local_58]              # 004bb08b
    fstp dword ptr [ebp - local_5c]              # 004bb08e
    mov edx, dword ptr [ebp - local_8]           # 004bb091
    fld dword ptr [ebp - local_5c]               # 004bb094
    fmul dword ptr [edx + field_300]             # 004bb097
    mov eax, dword ptr [ebp - local_8]           # 004bb09d
    fsubr dword ptr [eax + field_308]            # 004bb0a0
    mov ecx, dword ptr [ebp - local_8]           # 004bb0a6
    fstp dword ptr [ecx + field_308]             # 004bb0a9
    mov edx, dword ptr [ebp - local_8]           # 004bb0af
    fld dword ptr [edx + field_308]              # 004bb0b2
    call FUN_0050ce04                            # 004bb0b8
    mov ecx, dword ptr [ebp - local_8]           # 004bb0bd
    mov dword ptr [ecx + field_1c0], eax         # 004bb0c0
    mov edx, dword ptr [ebp - local_8]           # 004bb0c6
    mov eax, dword ptr [edx + field_1c0]         # 004bb0c9
    mov ecx, dword ptr [ebp - local_8]           # 004bb0cf
    mov edx, dword ptr [ecx + field_190]         # 004bb0d2
    lea eax, [eax + edx - field_minus_1]         # 004bb0d8
    mov ecx, dword ptr [ebp - local_8]           # 004bb0dc
    mov dword ptr [ecx + field_1c8], eax         # 004bb0df
    mov edx, dword ptr [ebp - local_8]           # 004bb0e5
    mov eax, dword ptr [ebp - local_8]           # 004bb0e8
    mov ecx, dword ptr [edx + field_1c0]         # 004bb0eb
    cmp ecx, dword ptr [eax + field_174]         # 004bb0f1
    jge.d32 L_004bb19c                           # 004bb0f7
    # block 0x004bb0fd: entered by fall-through of jge at 0x004bb0f7, 29 instruction(s), ends with jg to 0x004bb19c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004bb0fd
    mov eax, dword ptr [ebp - local_8]           # 004bb100
    mov ecx, dword ptr [eax + field_174]         # 004bb103
    mov dword ptr [edx + field_1c0], ecx         # 004bb109
    mov edx, dword ptr [ebp - local_8]           # 004bb10f
    mov eax, dword ptr [edx + field_1c0]         # 004bb112
    mov ecx, dword ptr [ebp - local_8]           # 004bb118
    mov edx, dword ptr [ecx + field_190]         # 004bb11b
    lea eax, [eax + edx - field_minus_1]         # 004bb121
    mov ecx, dword ptr [ebp - local_8]           # 004bb125
    mov dword ptr [ecx + field_1c8], eax         # 004bb128
    mov edx, dword ptr [ebp - local_8]           # 004bb12e
    fild dword ptr [edx + field_1c0]             # 004bb131
    mov eax, dword ptr [ebp - local_8]           # 004bb137
    fstp dword ptr [eax + field_308]             # 004bb13a
    mov ecx, dword ptr [ebp - local_8]           # 004bb140
    mov dword ptr [ecx + field_2c4], 0x0         # 004bb143
    mov edx, dword ptr [ebp - local_8]           # 004bb14d
    mov dword ptr [edx + field_20], 0x0          # 004bb150
    mov eax, dword ptr [ebp - local_8]           # 004bb157
    mov dword ptr [eax + field_1b4], 0x1         # 004bb15a
    mov ecx, dword ptr [ebp - local_8]           # 004bb164
    mov edx, dword ptr [ecx + field_2d0]         # 004bb167
    sub edx, 0x1                                 # 004bb16d
    mov eax, dword ptr [ebp - local_8]           # 004bb170
    mov dword ptr [eax + field_2d0], edx         # 004bb173
    mov ecx, dword ptr [ebp - local_8]           # 004bb179
    cmp dword ptr [ecx + field_2d0], 0x0         # 004bb17c
    jg.d8 L_004bb19c                             # 004bb183
    # block 0x004bb185: entered by fall-through of jg at 0x004bb183, 4 instruction(s), falls into the block at 0x004bb19c
    mov edx, dword ptr [ebp - local_8]           # 004bb185
    mov dword ptr [edx + field_2d0], 0x0         # 004bb188
    mov eax, dword ptr [ebp - local_8]           # 004bb192
    mov dword ptr [eax + field_3c], 0x1          # 004bb195
L_004bb19c:
    # block 0x004bb19c: entered by jge at 0x004bb0f7; jg at 0x004bb183, 5 instruction(s), ends with jne to 0x004bb1ec (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bb19c
    mov edx, dword ptr [ebp - local_8]           # 004bb19f
    mov eax, dword ptr [ecx + field_1bc]         # 004bb1a2
    cmp eax, dword ptr [edx + field_1cc]         # 004bb1a8
    jne.d8 L_004bb1ec                            # 004bb1ae
    # block 0x004bb1b0: entered by fall-through of jne at 0x004bb1ae, 5 instruction(s), ends with jne to 0x004bb1ec (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bb1b0
    mov edx, dword ptr [ebp - local_8]           # 004bb1b3
    mov eax, dword ptr [ecx + field_1c4]         # 004bb1b6
    cmp eax, dword ptr [edx + field_1d4]         # 004bb1bc
    jne.d8 L_004bb1ec                            # 004bb1c2
    # block 0x004bb1c4: entered by fall-through of jne at 0x004bb1c2, 5 instruction(s), ends with jne to 0x004bb1ec (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bb1c4
    mov edx, dword ptr [ebp - local_8]           # 004bb1c7
    mov eax, dword ptr [ecx + field_1c0]         # 004bb1ca
    cmp eax, dword ptr [edx + field_1d0]         # 004bb1d0
    jne.d8 L_004bb1ec                            # 004bb1d6
    # block 0x004bb1d8: entered by fall-through of jne at 0x004bb1d6, 5 instruction(s), ends with je to 0x004bb1f9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bb1d8
    mov edx, dword ptr [ebp - local_8]           # 004bb1db
    mov eax, dword ptr [ecx + field_1c8]         # 004bb1de
    cmp eax, dword ptr [edx + field_1d8]         # 004bb1e4
    je.d8 L_004bb1f9                             # 004bb1ea
L_004bb1ec:
    # block 0x004bb1ec: entered by jne at 0x004bb1ae; jne at 0x004bb1c2; jne at 0x004bb1d6; fall-through of je at 0x004bb1ea, 2 instruction(s), falls into the block at 0x004bb1f9
    mov ecx, dword ptr [ebp - local_8]           # 004bb1ec
    mov dword ptr [ecx + field_1b0], 0x1         # 004bb1ef
L_004bb1f9:
    # block 0x004bb1f9: entered by je at 0x004bb1ea, 1 instruction(s), ends with forward jump to 0x004bb205
    jmp.d8 L_004bb205                            # 004bb1f9
L_004bb1fb:
    # block 0x004bb1fb: entered by switch case, 2 instruction(s), falls into the block at 0x004bb205
    mov edx, dword ptr [ebp - local_8]           # 004bb1fb
    mov dword ptr [edx + field_20], 0x0          # 004bb1fe
L_004bb205:
    # block 0x004bb205: entered by jmp at 0x004ba58e; ja at 0x004ba636; jmp at 0x004bad83; jmp at 0x004baf32; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bb205
    pop ebp                                      # 004bb207
    ret                                          # 004bb208

# --- data items (not part of the function) -------------------------
.org 0x004bb209 - 0x401000
SWTAB_004bb209:  # 4 case address(es)
    .long L_004ba646 - .text + 0x401000
    .long L_004baf37 - .text + 0x401000
    .long L_004bb1fb - .text + 0x401000
    .long L_004bafb3 - .text + 0x401000
.set SWTAB_004bb209_VA, SWTAB_004bb209 - .text + 0x401000

