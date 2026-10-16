# FUN_004a14c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a14c6
# extent:       0x004a14c6-0x004a1b02 (1596 code bytes)
# span:         0x004a14c6-0x004a1b12 (code 1596, tables 16, padding 0)
# sha256:       61307595f0bc0686d0ce5d6fa5a053424ac562c12d5ff5a25cb9b0a55e22ba60
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a14c6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_dd8, field_de0, field_dea, field_df4, field_df8, field_minus_2; [ecx + n] field_2, field_dd8, field_de0, field_dea, field_dfc, field_e10, field_e14, field_minus_2; [edx + n] field_2, field_dd8, field_ddc, field_de0, field_dea, field_dec, field_df0, field_df8
# callees:      calls FUN_0050cd50, FUN_004a1358, FUN_004a140b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 437 instruction(s), 23 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
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
.equ field_2, 0x2  # offset +0x2
.equ field_dd8, 0xdd8  # offset +0xdd8
.equ field_ddc, 0xddc  # offset +0xddc
.equ field_de0, 0xde0  # offset +0xde0
.equ field_dea, 0xdea  # offset +0xdea
.equ field_dec, 0xdec  # offset +0xdec
.equ field_df0, 0xdf0  # offset +0xdf0
.equ field_df4, 0xdf4  # offset +0xdf4
.equ field_df8, 0xdf8  # offset +0xdf8
.equ field_dfc, 0xdfc  # offset +0xdfc
.equ field_e10, 0xe10  # offset +0xe10
.equ field_e14, 0xe14  # offset +0xe14

# --- external targets -----------------------------------------------
.set FUN_004a1358, .text + (0x004a1358 - 0x401000)
.set FUN_004a140b, .text + (0x004a140b - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004a14c6 - 0x401000
.globl FUN_004a14c6
FUN_004a14c6:
    # block 0x004a14c6: entry, 43 instruction(s), falls into the block at 0x004a156e
    push ebp                                     # 004a14c6
    {load} mov ebp, esp                          # 004a14c7
    sub esp, 0x28                                # 004a14c9
    push edi                                     # 004a14cc
    mov dword ptr [ebp - local_24], ecx          # 004a14cd
    mov eax, dword ptr [ebp - local_24]          # 004a14d0
    mov ecx, dword ptr [eax + field_df4]         # 004a14d3
    shl ecx, 0x3                                 # 004a14d9
    or eax, -0x1                                 # 004a14dc
    mov edx, dword ptr [ebp - local_24]          # 004a14df
    mov edi, dword ptr [edx + field_dec]         # 004a14e2
    {load} mov edx, ecx                          # 004a14e8
    shr ecx, 0x2                                 # 004a14ea
    rep stosd dword ptr es:[edi], eax            # 004a14ed
    {load} mov ecx, edx                          # 004a14ef
    and ecx, 0x3                                 # 004a14f1
    rep stosb byte ptr es:[edi], al              # 004a14f4
    mov eax, dword ptr [ebp - local_24]          # 004a14f6
    mov ecx, dword ptr [eax + field_df4]         # 004a14f9
    sub ecx, 0x1                                 # 004a14ff
    mov edx, dword ptr [ebp - local_24]          # 004a1502
    mov dword ptr [edx + field_df0], ecx         # 004a1505
    mov eax, dword ptr [ebp - local_24]          # 004a150b
    mov dword ptr [eax + field_df8], 0x0         # 004a150e
    mov ecx, dword ptr [ebp - local_24]          # 004a1518
    mov dword ptr [ecx + field_dfc], 0x0         # 004a151b
    mov edx, dword ptr [ebp - local_24]          # 004a1525
    mov eax, dword ptr [edx + field_dd8]         # 004a1528
    sub eax, 0x1                                 # 004a152e
    mov ecx, dword ptr [ebp - local_24]          # 004a1531
    mov dword ptr [ecx + field_e10], eax         # 004a1534
    mov edx, dword ptr [ebp - local_24]          # 004a153a
    mov eax, dword ptr [edx + field_ddc]         # 004a153d
    sub eax, 0x1                                 # 004a1543
    mov ecx, dword ptr [ebp - local_24]          # 004a1546
    mov dword ptr [ecx + field_e14], eax         # 004a1549
    mov edx, dword ptr [ebp - local_24]          # 004a154f
    mov eax, dword ptr [edx + field_df8]         # 004a1552
    mov dword ptr [ebp - local_c], eax           # 004a1558
    mov ecx, dword ptr [ebp - local_24]          # 004a155b
    mov edx, dword ptr [ecx + field_dfc]         # 004a155e
    mov dword ptr [ebp - local_10], edx          # 004a1564
    mov dword ptr [ebp - local_4], 0x1           # 004a1567
L_004a156e:
    # block 0x004a156e: entered by jmp at 0x004a1af8, 4 instruction(s), ends with jge to 0x004a1afd (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a156e
    mov ecx, dword ptr [ebp - local_4]           # 004a1571
    cmp ecx, dword ptr [eax + field_df4]         # 004a1574
    jge.d32 L_004a1afd                           # 004a157a
    # block 0x004a1580: entered by fall-through of jge at 0x004a157a, 5 instruction(s), ends with jl to 0x004a161f (forward)
    mov dword ptr [ebp - local_1c], 0x0          # 004a1580
    mov edx, dword ptr [ebp - local_10]          # 004a1587
    sub edx, 0x1                                 # 004a158a
    test edx, edx                                # 004a158d
    jl.d32 L_004a161f                            # 004a158f
    # block 0x004a1595: entered by fall-through of jl at 0x004a158f, 17 instruction(s), ends with je to 0x004a161f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a1595
    sub eax, 0x1                                 # 004a1598
    mov ecx, dword ptr [ebp - local_24]          # 004a159b
    imul eax, dword ptr [ecx + field_dd8]        # 004a159e
    mov edx, dword ptr [ebp - local_24]          # 004a15a5
    mov ecx, dword ptr [edx + field_de0]         # 004a15a8
    lea edx, [ecx + 2*eax]                       # 004a15ae
    mov eax, dword ptr [ebp - local_24]          # 004a15b1
    mov ecx, dword ptr [ebp - local_c]           # 004a15b4
    mov dx, word ptr [edx + 2*ecx]               # 004a15b7
    mov word ptr [eax + field_dea], dx           # 004a15bb
    mov eax, dword ptr [ebp - local_24]          # 004a15c2
    {load} xor ecx, ecx                          # 004a15c5
    mov cx, word ptr [eax + field_dea]           # 004a15c7
    and ecx, 0x8                                 # 004a15ce
    test ecx, ecx                                # 004a15d1
    je.d8 L_004a161f                             # 004a15d3
    # block 0x004a15d5: entered by fall-through of je at 0x004a15d3, 6 instruction(s), ends with je to 0x004a161f (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a15d5
    {load} xor eax, eax                          # 004a15d8
    mov ax, word ptr [edx + field_dea]           # 004a15da
    and eax, 0x4                                 # 004a15e1
    test eax, eax                                # 004a15e4
    je.d8 L_004a161f                             # 004a15e6
    # block 0x004a15e8: entered by fall-through of je at 0x004a15e6, 6 instruction(s), ends with je to 0x004a161f (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004a15e8
    {load} xor edx, edx                          # 004a15eb
    mov dx, word ptr [ecx + field_dea]           # 004a15ed
    and edx, 0x2                                 # 004a15f4
    test edx, edx                                # 004a15f7
    je.d8 L_004a161f                             # 004a15f9
    # block 0x004a15fb: entered by fall-through of je at 0x004a15f9, 6 instruction(s), ends with je to 0x004a161f (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a15fb
    {load} xor ecx, ecx                          # 004a15fe
    mov cx, word ptr [eax + field_dea]           # 004a1600
    and ecx, 0x1                                 # 004a1607
    test ecx, ecx                                # 004a160a
    je.d8 L_004a161f                             # 004a160c
    # block 0x004a160e: entered by fall-through of je at 0x004a160c, 5 instruction(s), falls into the block at 0x004a161f
    mov edx, dword ptr [ebp - local_1c]          # 004a160e
    mov byte ptr [ebp + edx - local_8], 0x2      # 004a1611
    mov eax, dword ptr [ebp - local_1c]          # 004a1616
    add eax, 0x1                                 # 004a1619
    mov dword ptr [ebp - local_1c], eax          # 004a161c
L_004a161f:
    # block 0x004a161f: entered by jl at 0x004a158f; je at 0x004a15d3; je at 0x004a15e6; je at 0x004a15f9; je at 0x004a160c, 7 instruction(s), ends with jg to 0x004a16c3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a161f
    add ecx, 0x1                                 # 004a1622
    mov edx, dword ptr [ebp - local_24]          # 004a1625
    mov eax, dword ptr [edx + field_ddc]         # 004a1628
    sub eax, 0x1                                 # 004a162e
    {load} cmp ecx, eax                          # 004a1631
    jg.d32 L_004a16c3                            # 004a1633
    # block 0x004a1639: entered by fall-through of jg at 0x004a1633, 17 instruction(s), ends with je to 0x004a16c3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a1639
    add ecx, 0x1                                 # 004a163c
    mov edx, dword ptr [ebp - local_24]          # 004a163f
    imul ecx, dword ptr [edx + field_dd8]        # 004a1642
    mov eax, dword ptr [ebp - local_24]          # 004a1649
    mov edx, dword ptr [eax + field_de0]         # 004a164c
    lea eax, [edx + 2*ecx]                       # 004a1652
    mov ecx, dword ptr [ebp - local_24]          # 004a1655
    mov edx, dword ptr [ebp - local_c]           # 004a1658
    mov ax, word ptr [eax + 2*edx]               # 004a165b
    mov word ptr [ecx + field_dea], ax           # 004a165f
    mov ecx, dword ptr [ebp - local_24]          # 004a1666
    {load} xor edx, edx                          # 004a1669
    mov dx, word ptr [ecx + field_dea]           # 004a166b
    and edx, 0x8                                 # 004a1672
    test edx, edx                                # 004a1675
    je.d8 L_004a16c3                             # 004a1677
    # block 0x004a1679: entered by fall-through of je at 0x004a1677, 6 instruction(s), ends with je to 0x004a16c3 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a1679
    {load} xor ecx, ecx                          # 004a167c
    mov cx, word ptr [eax + field_dea]           # 004a167e
    and ecx, 0x4                                 # 004a1685
    test ecx, ecx                                # 004a1688
    je.d8 L_004a16c3                             # 004a168a
    # block 0x004a168c: entered by fall-through of je at 0x004a168a, 6 instruction(s), ends with je to 0x004a16c3 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a168c
    {load} xor eax, eax                          # 004a168f
    mov ax, word ptr [edx + field_dea]           # 004a1691
    and eax, 0x2                                 # 004a1698
    test eax, eax                                # 004a169b
    je.d8 L_004a16c3                             # 004a169d
    # block 0x004a169f: entered by fall-through of je at 0x004a169d, 6 instruction(s), ends with je to 0x004a16c3 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004a169f
    {load} xor edx, edx                          # 004a16a2
    mov dx, word ptr [ecx + field_dea]           # 004a16a4
    and edx, 0x1                                 # 004a16ab
    test edx, edx                                # 004a16ae
    je.d8 L_004a16c3                             # 004a16b0
    # block 0x004a16b2: entered by fall-through of je at 0x004a16b0, 5 instruction(s), falls into the block at 0x004a16c3
    mov eax, dword ptr [ebp - local_1c]          # 004a16b2
    mov byte ptr [ebp + eax - local_8], 0x3      # 004a16b5
    mov ecx, dword ptr [ebp - local_1c]          # 004a16ba
    add ecx, 0x1                                 # 004a16bd
    mov dword ptr [ebp - local_1c], ecx          # 004a16c0
L_004a16c3:
    # block 0x004a16c3: entered by jg at 0x004a1633; je at 0x004a1677; je at 0x004a168a; je at 0x004a169d; je at 0x004a16b0, 4 instruction(s), ends with jl to 0x004a1759 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004a16c3
    sub edx, 0x1                                 # 004a16c6
    test edx, edx                                # 004a16c9
    jl.d32 L_004a1759                            # 004a16cb
    # block 0x004a16d1: entered by fall-through of jl at 0x004a16cb, 16 instruction(s), ends with je to 0x004a1759 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a16d1
    mov ecx, dword ptr [ebp - local_10]          # 004a16d4
    imul ecx, dword ptr [eax + field_dd8]        # 004a16d7
    mov edx, dword ptr [ebp - local_24]          # 004a16de
    mov eax, dword ptr [edx + field_de0]         # 004a16e1
    lea ecx, [eax + 2*ecx]                       # 004a16e7
    mov edx, dword ptr [ebp - local_24]          # 004a16ea
    mov eax, dword ptr [ebp - local_c]           # 004a16ed
    mov cx, word ptr [ecx + 2*eax - field_minus_2] # 004a16f0
    mov word ptr [edx + field_dea], cx           # 004a16f5
    mov edx, dword ptr [ebp - local_24]          # 004a16fc
    {load} xor eax, eax                          # 004a16ff
    mov ax, word ptr [edx + field_dea]           # 004a1701
    and eax, 0x8                                 # 004a1708
    test eax, eax                                # 004a170b
    je.d8 L_004a1759                             # 004a170d
    # block 0x004a170f: entered by fall-through of je at 0x004a170d, 6 instruction(s), ends with je to 0x004a1759 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004a170f
    {load} xor edx, edx                          # 004a1712
    mov dx, word ptr [ecx + field_dea]           # 004a1714
    and edx, 0x4                                 # 004a171b
    test edx, edx                                # 004a171e
    je.d8 L_004a1759                             # 004a1720
    # block 0x004a1722: entered by fall-through of je at 0x004a1720, 6 instruction(s), ends with je to 0x004a1759 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a1722
    {load} xor ecx, ecx                          # 004a1725
    mov cx, word ptr [eax + field_dea]           # 004a1727
    and ecx, 0x2                                 # 004a172e
    test ecx, ecx                                # 004a1731
    je.d8 L_004a1759                             # 004a1733
    # block 0x004a1735: entered by fall-through of je at 0x004a1733, 6 instruction(s), ends with je to 0x004a1759 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a1735
    {load} xor eax, eax                          # 004a1738
    mov ax, word ptr [edx + field_dea]           # 004a173a
    and eax, 0x1                                 # 004a1741
    test eax, eax                                # 004a1744
    je.d8 L_004a1759                             # 004a1746
    # block 0x004a1748: entered by fall-through of je at 0x004a1746, 5 instruction(s), falls into the block at 0x004a1759
    mov ecx, dword ptr [ebp - local_1c]          # 004a1748
    mov byte ptr [ebp + ecx - local_8], 0x0      # 004a174b
    mov edx, dword ptr [ebp - local_1c]          # 004a1750
    add edx, 0x1                                 # 004a1753
    mov dword ptr [ebp - local_1c], edx          # 004a1756
L_004a1759:
    # block 0x004a1759: entered by jl at 0x004a16cb; je at 0x004a170d; je at 0x004a1720; je at 0x004a1733; je at 0x004a1746, 7 instruction(s), ends with jg to 0x004a17fb (forward)
    mov eax, dword ptr [ebp - local_c]           # 004a1759
    add eax, 0x1                                 # 004a175c
    mov ecx, dword ptr [ebp - local_24]          # 004a175f
    mov edx, dword ptr [ecx + field_dd8]         # 004a1762
    sub edx, 0x1                                 # 004a1768
    {load} cmp eax, edx                          # 004a176b
    jg.d32 L_004a17fb                            # 004a176d
    # block 0x004a1773: entered by fall-through of jg at 0x004a176d, 16 instruction(s), ends with je to 0x004a17fb (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a1773
    mov ecx, dword ptr [ebp - local_10]          # 004a1776
    imul ecx, dword ptr [eax + field_dd8]        # 004a1779
    mov edx, dword ptr [ebp - local_24]          # 004a1780
    mov eax, dword ptr [edx + field_de0]         # 004a1783
    lea ecx, [eax + 2*ecx]                       # 004a1789
    mov edx, dword ptr [ebp - local_24]          # 004a178c
    mov eax, dword ptr [ebp - local_c]           # 004a178f
    mov cx, word ptr [ecx + 2*eax + field_2]     # 004a1792
    mov word ptr [edx + field_dea], cx           # 004a1797
    mov edx, dword ptr [ebp - local_24]          # 004a179e
    {load} xor eax, eax                          # 004a17a1
    mov ax, word ptr [edx + field_dea]           # 004a17a3
    and eax, 0x8                                 # 004a17aa
    test eax, eax                                # 004a17ad
    je.d8 L_004a17fb                             # 004a17af
    # block 0x004a17b1: entered by fall-through of je at 0x004a17af, 6 instruction(s), ends with je to 0x004a17fb (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004a17b1
    {load} xor edx, edx                          # 004a17b4
    mov dx, word ptr [ecx + field_dea]           # 004a17b6
    and edx, 0x4                                 # 004a17bd
    test edx, edx                                # 004a17c0
    je.d8 L_004a17fb                             # 004a17c2
    # block 0x004a17c4: entered by fall-through of je at 0x004a17c2, 6 instruction(s), ends with je to 0x004a17fb (forward)
    mov eax, dword ptr [ebp - local_24]          # 004a17c4
    {load} xor ecx, ecx                          # 004a17c7
    mov cx, word ptr [eax + field_dea]           # 004a17c9
    and ecx, 0x2                                 # 004a17d0
    test ecx, ecx                                # 004a17d3
    je.d8 L_004a17fb                             # 004a17d5
    # block 0x004a17d7: entered by fall-through of je at 0x004a17d5, 6 instruction(s), ends with je to 0x004a17fb (forward)
    mov edx, dword ptr [ebp - local_24]          # 004a17d7
    {load} xor eax, eax                          # 004a17da
    mov ax, word ptr [edx + field_dea]           # 004a17dc
    and eax, 0x1                                 # 004a17e3
    test eax, eax                                # 004a17e6
    je.d8 L_004a17fb                             # 004a17e8
    # block 0x004a17ea: entered by fall-through of je at 0x004a17e8, 5 instruction(s), falls into the block at 0x004a17fb
    mov ecx, dword ptr [ebp - local_1c]          # 004a17ea
    mov byte ptr [ebp + ecx - local_8], 0x1      # 004a17ed
    mov edx, dword ptr [ebp - local_1c]          # 004a17f2
    add edx, 0x1                                 # 004a17f5
    mov dword ptr [ebp - local_1c], edx          # 004a17f8
L_004a17fb:
    # block 0x004a17fb: entered by jg at 0x004a176d; je at 0x004a17af; je at 0x004a17c2; je at 0x004a17d5; je at 0x004a17e8, 2 instruction(s), ends with jle to 0x004a1ae0 (forward)
    cmp dword ptr [ebp - local_1c], 0x0          # 004a17fb
    jle.d32 L_004a1ae0                           # 004a17ff
    # block 0x004a1805: entered by fall-through of jle at 0x004a17ff, 9 instruction(s), calls FUN_0050cd50, ends with ja to 0x004a1ad5 (forward)
    call FUN_0050cd50                            # 004a1805
    cdq                                          # 004a180a
    idiv dword ptr [ebp - local_1c]              # 004a180b
    mov dword ptr [ebp - local_20], edx          # 004a180e
    mov eax, dword ptr [ebp - local_20]          # 004a1811
    movsx ecx, byte ptr [ebp + eax - local_8]    # 004a1814
    mov dword ptr [ebp - local_28], ecx          # 004a1819
    cmp dword ptr [ebp - local_28], 0x3          # 004a181c
    ja.d32 L_004a1ad5                            # 004a1820
    # block 0x004a1826: entered by fall-through of ja at 0x004a1820, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4a1b02]
    mov edx, dword ptr [ebp - local_28]          # 004a1826
    jmp dword ptr [4*edx + SWTAB_004a1b02_VA]    # 004a1829
L_004a1830:
    # block 0x004a1830: entered by switch case, 46 instruction(s), calls FUN_004a1358, ends with forward jump to 0x004a1ad5
    mov eax, dword ptr [ebp - local_24]          # 004a1830
    mov ecx, dword ptr [ebp - local_10]          # 004a1833
    imul ecx, dword ptr [eax + field_dd8]        # 004a1836
    mov edx, dword ptr [ebp - local_24]          # 004a183d
    mov eax, dword ptr [edx + field_de0]         # 004a1840
    lea ecx, [eax + 2*ecx]                       # 004a1846
    mov edx, dword ptr [ebp - local_c]           # 004a1849
    mov ax, word ptr [ecx + 2*edx]               # 004a184c
    .insn 0x66, 0x25, 0xfffd{:u16}               # 004a1850
    mov ecx, dword ptr [ebp - local_24]          # 004a1854
    mov edx, dword ptr [ebp - local_10]          # 004a1857
    imul edx, dword ptr [ecx + field_dd8]        # 004a185a
    mov ecx, dword ptr [ebp - local_24]          # 004a1861
    mov ecx, dword ptr [ecx + field_de0]         # 004a1864
    lea edx, [ecx + 2*edx]                       # 004a186a
    mov ecx, dword ptr [ebp - local_c]           # 004a186d
    mov word ptr [edx + 2*ecx], ax               # 004a1870
    mov edx, dword ptr [ebp - local_10]          # 004a1874
    sub edx, 0x1                                 # 004a1877
    mov eax, dword ptr [ebp - local_24]          # 004a187a
    imul edx, dword ptr [eax + field_dd8]        # 004a187d
    mov ecx, dword ptr [ebp - local_24]          # 004a1884
    mov eax, dword ptr [ecx + field_de0]         # 004a1887
    lea ecx, [eax + 2*edx]                       # 004a188d
    mov edx, dword ptr [ebp - local_c]           # 004a1890
    mov ax, word ptr [ecx + 2*edx]               # 004a1893
    .insn 0x66, 0x25, 0xfffe{:u16}               # 004a1897
    mov ecx, dword ptr [ebp - local_10]          # 004a189b
    sub ecx, 0x1                                 # 004a189e
    mov edx, dword ptr [ebp - local_24]          # 004a18a1
    imul ecx, dword ptr [edx + field_dd8]        # 004a18a4
    mov edx, dword ptr [ebp - local_24]          # 004a18ab
    mov edx, dword ptr [edx + field_de0]         # 004a18ae
    lea ecx, [edx + 2*ecx]                       # 004a18b4
    mov edx, dword ptr [ebp - local_c]           # 004a18b7
    mov word ptr [ecx + 2*edx], ax               # 004a18ba
    mov eax, dword ptr [ebp - local_10]          # 004a18be
    push eax                                     # 004a18c1
    mov ecx, dword ptr [ebp - local_c]           # 004a18c2
    push ecx                                     # 004a18c5
    mov ecx, dword ptr [ebp - local_24]          # 004a18c6
    call FUN_004a1358                            # 004a18c9
    mov edx, dword ptr [ebp - local_10]          # 004a18ce
    sub edx, 0x1                                 # 004a18d1
    mov dword ptr [ebp - local_10], edx          # 004a18d4
    jmp.d32 L_004a1ad5                           # 004a18d7
L_004a18dc:
    # block 0x004a18dc: entered by switch case, 46 instruction(s), calls FUN_004a1358, ends with forward jump to 0x004a1ad5
    mov eax, dword ptr [ebp - local_24]          # 004a18dc
    mov ecx, dword ptr [ebp - local_10]          # 004a18df
    imul ecx, dword ptr [eax + field_dd8]        # 004a18e2
    mov edx, dword ptr [ebp - local_24]          # 004a18e9
    mov eax, dword ptr [edx + field_de0]         # 004a18ec
    lea ecx, [eax + 2*ecx]                       # 004a18f2
    mov edx, dword ptr [ebp - local_c]           # 004a18f5
    mov ax, word ptr [ecx + 2*edx]               # 004a18f8
    .insn 0x66, 0x25, 0xfffe{:u16}               # 004a18fc
    mov ecx, dword ptr [ebp - local_24]          # 004a1900
    mov edx, dword ptr [ebp - local_10]          # 004a1903
    imul edx, dword ptr [ecx + field_dd8]        # 004a1906
    mov ecx, dword ptr [ebp - local_24]          # 004a190d
    mov ecx, dword ptr [ecx + field_de0]         # 004a1910
    lea edx, [ecx + 2*edx]                       # 004a1916
    mov ecx, dword ptr [ebp - local_c]           # 004a1919
    mov word ptr [edx + 2*ecx], ax               # 004a191c
    mov edx, dword ptr [ebp - local_10]          # 004a1920
    add edx, 0x1                                 # 004a1923
    mov eax, dword ptr [ebp - local_24]          # 004a1926
    imul edx, dword ptr [eax + field_dd8]        # 004a1929
    mov ecx, dword ptr [ebp - local_24]          # 004a1930
    mov eax, dword ptr [ecx + field_de0]         # 004a1933
    lea ecx, [eax + 2*edx]                       # 004a1939
    mov edx, dword ptr [ebp - local_c]           # 004a193c
    mov ax, word ptr [ecx + 2*edx]               # 004a193f
    .insn 0x66, 0x25, 0xfffd{:u16}               # 004a1943
    mov ecx, dword ptr [ebp - local_10]          # 004a1947
    add ecx, 0x1                                 # 004a194a
    mov edx, dword ptr [ebp - local_24]          # 004a194d
    imul ecx, dword ptr [edx + field_dd8]        # 004a1950
    mov edx, dword ptr [ebp - local_24]          # 004a1957
    mov edx, dword ptr [edx + field_de0]         # 004a195a
    lea ecx, [edx + 2*ecx]                       # 004a1960
    mov edx, dword ptr [ebp - local_c]           # 004a1963
    mov word ptr [ecx + 2*edx], ax               # 004a1966
    mov eax, dword ptr [ebp - local_10]          # 004a196a
    push eax                                     # 004a196d
    mov ecx, dword ptr [ebp - local_c]           # 004a196e
    push ecx                                     # 004a1971
    mov ecx, dword ptr [ebp - local_24]          # 004a1972
    call FUN_004a1358                            # 004a1975
    mov edx, dword ptr [ebp - local_10]          # 004a197a
    add edx, 0x1                                 # 004a197d
    mov dword ptr [ebp - local_10], edx          # 004a1980
    jmp.d32 L_004a1ad5                           # 004a1983
L_004a1988:
    # block 0x004a1988: entered by switch case, 44 instruction(s), calls FUN_004a1358, ends with forward jump to 0x004a1ad5
    mov eax, dword ptr [ebp - local_24]          # 004a1988
    mov ecx, dword ptr [ebp - local_10]          # 004a198b
    imul ecx, dword ptr [eax + field_dd8]        # 004a198e
    mov edx, dword ptr [ebp - local_24]          # 004a1995
    mov eax, dword ptr [edx + field_de0]         # 004a1998
    lea ecx, [eax + 2*ecx]                       # 004a199e
    mov edx, dword ptr [ebp - local_c]           # 004a19a1
    mov ax, word ptr [ecx + 2*edx]               # 004a19a4
    .insn 0x66, 0x25, 0xfff7{:u16}               # 004a19a8
    mov ecx, dword ptr [ebp - local_24]          # 004a19ac
    mov edx, dword ptr [ebp - local_10]          # 004a19af
    imul edx, dword ptr [ecx + field_dd8]        # 004a19b2
    mov ecx, dword ptr [ebp - local_24]          # 004a19b9
    mov ecx, dword ptr [ecx + field_de0]         # 004a19bc
    lea edx, [ecx + 2*edx]                       # 004a19c2
    mov ecx, dword ptr [ebp - local_c]           # 004a19c5
    mov word ptr [edx + 2*ecx], ax               # 004a19c8
    mov edx, dword ptr [ebp - local_24]          # 004a19cc
    mov eax, dword ptr [ebp - local_10]          # 004a19cf
    imul eax, dword ptr [edx + field_dd8]        # 004a19d2
    mov ecx, dword ptr [ebp - local_24]          # 004a19d9
    mov edx, dword ptr [ecx + field_de0]         # 004a19dc
    lea eax, [edx + 2*eax]                       # 004a19e2
    mov ecx, dword ptr [ebp - local_c]           # 004a19e5
    mov dx, word ptr [eax + 2*ecx - field_minus_2] # 004a19e8
    .insn 0x6681/4, edx, -5{:s16}                # 004a19ed
    mov eax, dword ptr [ebp - local_24]          # 004a19f2
    mov ecx, dword ptr [ebp - local_10]          # 004a19f5
    imul ecx, dword ptr [eax + field_dd8]        # 004a19f8
    mov eax, dword ptr [ebp - local_24]          # 004a19ff
    mov eax, dword ptr [eax + field_de0]         # 004a1a02
    lea ecx, [eax + 2*ecx]                       # 004a1a08
    mov eax, dword ptr [ebp - local_c]           # 004a1a0b
    mov word ptr [ecx + 2*eax - field_minus_2], dx # 004a1a0e
    mov ecx, dword ptr [ebp - local_10]          # 004a1a13
    push ecx                                     # 004a1a16
    mov edx, dword ptr [ebp - local_c]           # 004a1a17
    push edx                                     # 004a1a1a
    mov ecx, dword ptr [ebp - local_24]          # 004a1a1b
    call FUN_004a1358                            # 004a1a1e
    mov eax, dword ptr [ebp - local_c]           # 004a1a23
    sub eax, 0x1                                 # 004a1a26
    mov dword ptr [ebp - local_c], eax           # 004a1a29
    jmp.d32 L_004a1ad5                           # 004a1a2c
L_004a1a31:
    # block 0x004a1a31: entered by switch case, 43 instruction(s), calls FUN_004a1358, falls into the block at 0x004a1ad5
    mov ecx, dword ptr [ebp - local_24]          # 004a1a31
    mov edx, dword ptr [ebp - local_10]          # 004a1a34
    imul edx, dword ptr [ecx + field_dd8]        # 004a1a37
    mov eax, dword ptr [ebp - local_24]          # 004a1a3e
    mov ecx, dword ptr [eax + field_de0]         # 004a1a41
    lea edx, [ecx + 2*edx]                       # 004a1a47
    mov eax, dword ptr [ebp - local_c]           # 004a1a4a
    mov cx, word ptr [edx + 2*eax]               # 004a1a4d
    .insn 0x6681/4, ecx, -5{:s16}                # 004a1a51
    mov edx, dword ptr [ebp - local_24]          # 004a1a56
    mov eax, dword ptr [ebp - local_10]          # 004a1a59
    imul eax, dword ptr [edx + field_dd8]        # 004a1a5c
    mov edx, dword ptr [ebp - local_24]          # 004a1a63
    mov edx, dword ptr [edx + field_de0]         # 004a1a66
    lea eax, [edx + 2*eax]                       # 004a1a6c
    mov edx, dword ptr [ebp - local_c]           # 004a1a6f
    mov word ptr [eax + 2*edx], cx               # 004a1a72
    mov eax, dword ptr [ebp - local_24]          # 004a1a76
    mov ecx, dword ptr [ebp - local_10]          # 004a1a79
    imul ecx, dword ptr [eax + field_dd8]        # 004a1a7c
    mov edx, dword ptr [ebp - local_24]          # 004a1a83
    mov eax, dword ptr [edx + field_de0]         # 004a1a86
    lea ecx, [eax + 2*ecx]                       # 004a1a8c
    mov edx, dword ptr [ebp - local_c]           # 004a1a8f
    mov ax, word ptr [ecx + 2*edx + field_2]     # 004a1a92
    .insn 0x66, 0x25, 0xfff7{:u16}               # 004a1a97
    mov ecx, dword ptr [ebp - local_24]          # 004a1a9b
    mov edx, dword ptr [ebp - local_10]          # 004a1a9e
    imul edx, dword ptr [ecx + field_dd8]        # 004a1aa1
    mov ecx, dword ptr [ebp - local_24]          # 004a1aa8
    mov ecx, dword ptr [ecx + field_de0]         # 004a1aab
    lea edx, [ecx + 2*edx]                       # 004a1ab1
    mov ecx, dword ptr [ebp - local_c]           # 004a1ab4
    mov word ptr [edx + 2*ecx + field_2], ax     # 004a1ab7
    mov edx, dword ptr [ebp - local_10]          # 004a1abc
    push edx                                     # 004a1abf
    mov eax, dword ptr [ebp - local_c]           # 004a1ac0
    push eax                                     # 004a1ac3
    mov ecx, dword ptr [ebp - local_24]          # 004a1ac4
    call FUN_004a1358                            # 004a1ac7
    mov ecx, dword ptr [ebp - local_c]           # 004a1acc
    add ecx, 0x1                                 # 004a1acf
    mov dword ptr [ebp - local_c], ecx           # 004a1ad2
L_004a1ad5:
    # block 0x004a1ad5: entered by ja at 0x004a1820; jmp at 0x004a18d7; jmp at 0x004a1983; jmp at 0x004a1a2c, 4 instruction(s), ends with forward jump to 0x004a1af8
    mov edx, dword ptr [ebp - local_4]           # 004a1ad5
    add edx, 0x1                                 # 004a1ad8
    mov dword ptr [ebp - local_4], edx           # 004a1adb
    jmp.d8 L_004a1af8                            # 004a1ade
L_004a1ae0:
    # block 0x004a1ae0: entered by jle at 0x004a17ff, 8 instruction(s), calls FUN_004a140b, falls into the block at 0x004a1af8
    lea eax, [ebp - local_18]                    # 004a1ae0
    push eax                                     # 004a1ae3
    mov ecx, dword ptr [ebp - local_24]          # 004a1ae4
    call FUN_004a140b                            # 004a1ae7
    mov ecx, dword ptr [ebp - local_18]          # 004a1aec
    mov dword ptr [ebp - local_c], ecx           # 004a1aef
    mov edx, dword ptr [ebp - local_14]          # 004a1af2
    mov dword ptr [ebp - local_10], edx          # 004a1af5
L_004a1af8:
    # block 0x004a1af8: entered by jmp at 0x004a1ade, 1 instruction(s), ends with backward jump to 0x004a156e
    jmp.d32 L_004a156e                           # 004a1af8
L_004a1afd:
    # block 0x004a1afd: entered by jge at 0x004a157a, 4 instruction(s), ends with ret
    pop edi                                      # 004a1afd
    {load} mov esp, ebp                          # 004a1afe
    pop ebp                                      # 004a1b00
    ret                                          # 004a1b01

# --- data items (not part of the function) -------------------------
.org 0x004a1b02 - 0x401000
SWTAB_004a1b02:  # 4 case address(es)
    .long L_004a1988 - .text + 0x401000
    .long L_004a1a31 - .text + 0x401000
    .long L_004a1830 - .text + 0x401000
    .long L_004a18dc - .text + 0x401000
.set SWTAB_004a1b02_VA, SWTAB_004a1b02 - .text + 0x401000

