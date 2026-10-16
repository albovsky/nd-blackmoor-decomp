# FUN_00471722
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00471722
# extent:       0x00471722-0x00472a38 (4886 code bytes)
# span:         0x00471722-0x00472a4c (code 4886, tables 20, padding 0)
# sha256:       a649c7f3f84e0a6a9d1636e17e8f54eaea1cf450d4f4b9bcab3fc0e027d10de7
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00471722
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_30, local_34 and 2 more
# fields:       [eax + n] field_1c, field_20, field_21, field_23, field_24, field_97, field_9b, field_a3, field_ad, field_d3, field_e3, field_e7 and 32 more; [ecx + n] field_20, field_21, field_24, field_28, field_99, field_9f, field_ab, field_ad, field_b0, field_d3, field_e5, field_eb and 40 more; [edx + n] field_97, field_9d, field_a7, field_af, field_e3, field_e9, field_f3, field_fb, field_10c, field_10e, field_11e, field_2d3 and 25 more; [esi + n] field_11a, field_11c, field_122, field_124
# callees:      calls FUN_0050e19e, FUN_0050ce04, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_00470ddc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1151 instruction(s), 87 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_97, 0x97  # offset +0x97
.equ field_99, 0x99  # offset +0x99
.equ field_9b, 0x9b  # offset +0x9b
.equ field_9d, 0x9d  # offset +0x9d
.equ field_9f, 0x9f  # offset +0x9f
.equ field_a3, 0xa3  # offset +0xa3
.equ field_a7, 0xa7  # offset +0xa7
.equ field_ab, 0xab  # offset +0xab
.equ field_ad, 0xad  # offset +0xad
.equ field_af, 0xaf  # offset +0xaf
.equ field_b0, 0xb0  # offset +0xb0
.equ field_d3, 0xd3  # offset +0xd3
.equ field_e3, 0xe3  # offset +0xe3
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e7, 0xe7  # offset +0xe7
.equ field_e9, 0xe9  # offset +0xe9
.equ field_eb, 0xeb  # offset +0xeb
.equ field_ef, 0xef  # offset +0xef
.equ field_f3, 0xf3  # offset +0xf3
.equ field_f7, 0xf7  # offset +0xf7
.equ field_f9, 0xf9  # offset +0xf9
.equ field_fb, 0xfb  # offset +0xfb
.equ field_10c, 0x10c  # offset +0x10c
.equ field_10e, 0x10e  # offset +0x10e
.equ field_110, 0x110  # offset +0x110
.equ field_112, 0x112  # offset +0x112
.equ field_114, 0x114  # offset +0x114
.equ field_116, 0x116  # offset +0x116
.equ field_118, 0x118  # offset +0x118
.equ field_11a, 0x11a  # offset +0x11a
.equ field_11c, 0x11c  # offset +0x11c
.equ field_11e, 0x11e  # offset +0x11e
.equ field_120, 0x120  # offset +0x120
.equ field_122, 0x122  # offset +0x122
.equ field_124, 0x124  # offset +0x124
.equ field_190, 0x190  # offset +0x190
.equ field_24e, 0x24e  # offset +0x24e
.equ field_24f, 0x24f  # offset +0x24f
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2ec, 0x2ec  # offset +0x2ec
.equ field_2ee, 0x2ee  # offset +0x2ee
.equ field_2f0, 0x2f0  # offset +0x2f0
.equ field_2f2, 0x2f2  # offset +0x2f2
.equ field_2f4, 0x2f4  # offset +0x2f4
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fc, 0x2fc  # offset +0x2fc
.equ field_300, 0x300  # offset +0x300
.equ field_302, 0x302  # offset +0x302
.equ field_304, 0x304  # offset +0x304
.equ field_65c, 0x65c  # offset +0x65c
.equ field_660, 0x660  # offset +0x660
.equ field_664, 0x664  # offset +0x664
.equ field_668, 0x668  # offset +0x668
.equ field_c9c, 0xc9c  # offset +0xc9c
.equ field_d00, 0xd00  # offset +0xd00
.equ field_d01, 0xd01  # offset +0xd01
.equ field_d03, 0xd03  # offset +0xd03
.equ field_d04, 0xd04  # offset +0xd04
.equ field_d22, 0xd22  # offset +0xd22
.equ field_d24, 0xd24  # offset +0xd24
.equ field_d28, 0xd28  # offset +0xd28
.equ field_d2a, 0xd2a  # offset +0xd2a
.equ field_d2c, 0xd2c  # offset +0xd2c
.equ field_d30, 0xd30  # offset +0xd30
.equ field_d32, 0xd32  # offset +0xd32
.equ field_d38, 0xd38  # offset +0xd38
.equ field_d3a, 0xd3a  # offset +0xd3a
.equ field_d3b, 0xd3b  # offset +0xd3b
.equ field_d3c, 0xd3c  # offset +0xd3c
.equ field_d3d, 0xd3d  # offset +0xd3d
.equ field_d3e, 0xd3e  # offset +0xd3e
.equ field_d3f, 0xd3f  # offset +0xd3f
.equ field_d40, 0xd40  # offset +0xd40
.equ field_d44, 0xd44  # offset +0xd44
.equ field_d4a, 0xd4a  # offset +0xd4a
.equ field_d86, 0xd86  # offset +0xd86
.equ field_dc2, 0xdc2  # offset +0xdc2
.equ field_dfe, 0xdfe  # offset +0xdfe
.equ field_dff, 0xdff  # offset +0xdff
.equ field_e00, 0xe00  # offset +0xe00
.equ field_e06, 0xe06  # offset +0xe06
.equ field_e08, 0xe08  # offset +0xe08

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00470ddc, .text + (0x00470ddc - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)

.org 0x00471722 - 0x401000
.globl FUN_00471722
FUN_00471722:
    # block 0x00471722: entry, 21 instruction(s), ends with je to 0x00471786 (forward)
    push ebp                                     # 00471722
    {load} mov ebp, esp                          # 00471723
    sub esp, 0x40                                # 00471725
    push ebx                                     # 00471728
    push esi                                     # 00471729
    push edi                                     # 0047172a
    mov dword ptr [ebp - local_20], ecx          # 0047172b
    movsx eax, word ptr [ebp + arg_8]            # 0047172e
    imul eax, eax, 0x8d                          # 00471732
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00471738
    mov dword ptr [ebp - local_8], ecx           # 0047173e
    movsx edx, word ptr [ebp + arg_8]            # 00471741
    imul edx, edx, 0x8d                          # 00471745
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0047174b
    mov dword ptr [ebp - local_14], eax          # 00471751
    movsx ecx, word ptr [ebp + arg_8]            # 00471754
    imul ecx, ecx, 0x8d                          # 00471758
    mov edx, dword ptr [ecx + 0x5bb632]          # 0047175e
    mov dword ptr [ebp - local_24], edx          # 00471764
    cmp dword ptr [ebp - local_24], 0x0          # 00471767
    je.d8 L_00471786                             # 0047176b
    # block 0x0047176d: entered by fall-through of je at 0x0047176b, 2 instruction(s), ends with je to 0x00471dbe (forward)
    cmp dword ptr [ebp - local_24], 0x1          # 0047176d
    je.d32 L_00471dbe                            # 00471771
    # block 0x00471777: entered by fall-through of je at 0x00471771, 2 instruction(s), ends with je to 0x004726a3 (forward)
    cmp dword ptr [ebp - local_24], 0x2          # 00471777
    je.d32 L_004726a3                            # 0047177b
    # block 0x00471781: entered by fall-through of je at 0x0047177b, 1 instruction(s), ends with forward jump to 0x00472a2f
    jmp.d32 L_00472a2f                           # 00471781
L_00471786:
    # block 0x00471786: entered by je at 0x0047176b, 27 instruction(s), ends with je to 0x00471a66 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00471786
    mov byte ptr [eax + field_d3e], 0x1          # 00471789
    mov ecx, dword ptr [ebp - local_20]          # 00471790
    mov dl, byte ptr [ebp + arg_c]               # 00471793
    mov byte ptr [ecx + field_d3d], dl           # 00471796
    mov eax, dword ptr [ebp - local_20]          # 0047179c
    mov byte ptr [eax + field_dfe], 0x0          # 0047179f
    mov ecx, dword ptr [ebp - local_20]          # 004717a6
    mov byte ptr [ecx + field_d3b], 0x0          # 004717a9
    mov dword ptr [0x5bb1ca], 0x1                # 004717b0
    mov edx, dword ptr [ebp - local_20]          # 004717ba
    mov ax, word ptr [ebp + arg_8]               # 004717bd
    mov word ptr [edx + field_d28], ax           # 004717c1
    mov ecx, dword ptr [ebp - local_20]          # 004717c8
    mov byte ptr [ecx + field_d3f], 0x0          # 004717cb
    mov ecx, 0x190                               # 004717d2
    {load} xor eax, eax                          # 004717d7
    mov edi, dword ptr [ebp - local_20]          # 004717d9
    add edi, 0x1c                                # 004717dc
    rep stosd dword ptr es:[edi], eax            # 004717df
    mov ecx, 0x190                               # 004717e1
    {load} xor eax, eax                          # 004717e6
    mov edi, dword ptr [ebp - local_20]          # 004717e8
    add edi, 0x65c                               # 004717eb
    rep stosd dword ptr es:[edi], eax            # 004717f1
    cmp dword ptr [ebp + arg_c], 0x0             # 004717f3
    je.d32 L_00471a66                            # 004717f7
    # block 0x004717fd: entered by fall-through of je at 0x004717f7, 9 instruction(s), ends with forward jump to 0x0047182f
    mov edx, dword ptr [ebp - local_14]          # 004717fd
    movsx eax, word ptr [edx + field_10e]        # 00471800
    mov ecx, dword ptr [ebp - local_14]          # 00471807
    movsx edx, word ptr [ecx + field_110]        # 0047180a
    imul eax, edx                                # 00471811
    mov ecx, dword ptr [ebp - local_14]          # 00471814
    mov word ptr [ecx + field_21], ax            # 00471817
    mov word ptr [ebp - local_10], 0x0           # 0047181b
    jmp.d8 L_0047182f                            # 00471821
L_00471823:
    # block 0x00471823: entered by jmp at 0x00471a27, 3 instruction(s), falls into the block at 0x0047182f
    mov dx, word ptr [ebp - local_10]            # 00471823
    add dx, 0x1                                  # 00471827
    mov word ptr [ebp - local_10], dx            # 0047182b
L_0047182f:
    # block 0x0047182f: entered by jmp at 0x00471821, 5 instruction(s), ends with jge to 0x00471a2c (forward)
    movsx eax, word ptr [ebp - local_10]         # 0047182f
    mov ecx, dword ptr [ebp - local_14]          # 00471833
    movsx edx, word ptr [ecx + field_21]         # 00471836
    {load} cmp eax, edx                          # 0047183a
    jge.d32 L_00471a2c                           # 0047183c
    # block 0x00471842: entered by fall-through of jge at 0x0047183c, 126 instruction(s), calls FUN_0050e19e, FUN_0050ce04, ends with backward jump to 0x00471823
    movsx eax, word ptr [ebp - local_10]         # 00471842
    mov dword ptr [ebp - local_28], eax          # 00471846
    fild dword ptr [ebp - local_28]              # 00471849
    fstp qword ptr [ebp - local_30]              # 0047184c
    mov ecx, dword ptr [ebp - local_14]          # 0047184f
    movsx edx, word ptr [ecx + field_10e]        # 00471852
    mov dword ptr [ebp - local_34], edx          # 00471859
    fild dword ptr [ebp - local_34]              # 0047185c
    fstp qword ptr [ebp - local_3c]              # 0047185f
    fld qword ptr [ebp - local_30]               # 00471862
    fdiv qword ptr [ebp - local_3c]              # 00471865
    sub esp, 0x8                                 # 00471868
    fstp qword ptr [esp]                         # 0047186b
    call FUN_0050e19e                            # 0047186e
    add esp, 0x8                                 # 00471873
    call FUN_0050ce04                            # 00471876
    mov word ptr [ebp - local_c], ax             # 0047187b
    mov eax, dword ptr [ebp - local_14]          # 0047187f
    movsx ecx, word ptr [eax + field_116]        # 00471882
    movsx eax, word ptr [ebp - local_10]         # 00471889
    mov edx, dword ptr [ebp - local_14]          # 0047188d
    movsx esi, word ptr [edx + field_10e]        # 00471890
    cdq                                          # 00471897
    idiv esi                                     # 00471898
    mov eax, dword ptr [ebp - local_14]          # 0047189a
    movsx eax, word ptr [eax + field_112]        # 0047189d
    mov esi, dword ptr [ebp - local_14]          # 004718a4
    movsx esi, word ptr [esi + field_11a]        # 004718a7
    {load} add eax, esi                          # 004718ae
    imul edx, eax                                # 004718b0
    {load} add ecx, edx                          # 004718b3
    movsx edx, word ptr [ebp - local_10]         # 004718b5
    shl edx, 0x4                                 # 004718b9
    mov eax, dword ptr [ebp - local_20]          # 004718bc
    mov dword ptr [eax + edx + field_1c], ecx    # 004718bf
    mov ecx, dword ptr [ebp - local_14]          # 004718c3
    movsx edx, word ptr [ecx + field_118]        # 004718c6
    movsx eax, word ptr [ebp - local_c]          # 004718cd
    mov ecx, dword ptr [ebp - local_14]          # 004718d1
    movsx ecx, word ptr [ecx + field_114]        # 004718d4
    mov esi, dword ptr [ebp - local_14]          # 004718db
    movsx esi, word ptr [esi + field_11c]        # 004718de
    {load} add ecx, esi                          # 004718e5
    imul eax, ecx                                # 004718e7
    {load} add edx, eax                          # 004718ea
    movsx eax, word ptr [ebp - local_10]         # 004718ec
    shl eax, 0x4                                 # 004718f0
    mov ecx, dword ptr [ebp - local_20]          # 004718f3
    mov dword ptr [ecx + eax + field_20], edx    # 004718f6
    movsx edx, word ptr [ebp - local_10]         # 004718fa
    shl edx, 0x4                                 # 004718fe
    mov eax, dword ptr [ebp - local_14]          # 00471901
    movsx ecx, word ptr [eax + field_112]        # 00471904
    mov eax, dword ptr [ebp - local_20]          # 0047190b
    mov edx, dword ptr [eax + edx + field_1c]    # 0047190e
    {load} add edx, ecx                          # 00471912
    movsx eax, word ptr [ebp - local_10]         # 00471914
    shl eax, 0x4                                 # 00471918
    mov ecx, dword ptr [ebp - local_20]          # 0047191b
    mov dword ptr [ecx + eax + field_24], edx    # 0047191e
    movsx edx, word ptr [ebp - local_10]         # 00471922
    shl edx, 0x4                                 # 00471926
    mov eax, dword ptr [ebp - local_14]          # 00471929
    movsx ecx, word ptr [eax + field_114]        # 0047192c
    mov eax, dword ptr [ebp - local_20]          # 00471933
    mov edx, dword ptr [eax + edx + field_20]    # 00471936
    {load} add edx, ecx                          # 0047193a
    movsx eax, word ptr [ebp - local_10]         # 0047193c
    shl eax, 0x4                                 # 00471940
    mov ecx, dword ptr [ebp - local_20]          # 00471943
    mov dword ptr [ecx + eax + field_28], edx    # 00471946
    mov edx, dword ptr [ebp - local_14]          # 0047194a
    movsx ecx, word ptr [edx + field_11e]        # 0047194d
    movsx eax, word ptr [ebp - local_10]         # 00471954
    mov edx, dword ptr [ebp - local_14]          # 00471958
    movsx esi, word ptr [edx + field_10e]        # 0047195b
    cdq                                          # 00471962
    idiv esi                                     # 00471963
    mov eax, dword ptr [ebp - local_14]          # 00471965
    movsx eax, word ptr [eax + field_112]        # 00471968
    mov esi, dword ptr [ebp - local_14]          # 0047196f
    movsx esi, word ptr [esi + field_122]        # 00471972
    {load} add eax, esi                          # 00471979
    imul edx, eax                                # 0047197b
    {load} add ecx, edx                          # 0047197e
    movsx edx, word ptr [ebp - local_10]         # 00471980
    shl edx, 0x4                                 # 00471984
    mov eax, dword ptr [ebp - local_20]          # 00471987
    mov dword ptr [eax + edx + field_65c], ecx   # 0047198a
    mov ecx, dword ptr [ebp - local_14]          # 00471991
    movsx edx, word ptr [ecx + field_120]        # 00471994
    movsx eax, word ptr [ebp - local_c]          # 0047199b
    mov ecx, dword ptr [ebp - local_14]          # 0047199f
    movsx ecx, word ptr [ecx + field_114]        # 004719a2
    mov esi, dword ptr [ebp - local_14]          # 004719a9
    movsx esi, word ptr [esi + field_124]        # 004719ac
    {load} add ecx, esi                          # 004719b3
    imul eax, ecx                                # 004719b5
    {load} add edx, eax                          # 004719b8
    movsx eax, word ptr [ebp - local_10]         # 004719ba
    shl eax, 0x4                                 # 004719be
    mov ecx, dword ptr [ebp - local_20]          # 004719c1
    mov dword ptr [ecx + eax + field_660], edx   # 004719c4
    movsx edx, word ptr [ebp - local_10]         # 004719cb
    shl edx, 0x4                                 # 004719cf
    mov eax, dword ptr [ebp - local_14]          # 004719d2
    movsx ecx, word ptr [eax + field_112]        # 004719d5
    mov eax, dword ptr [ebp - local_20]          # 004719dc
    mov edx, dword ptr [eax + edx + field_65c]   # 004719df
    {load} add edx, ecx                          # 004719e6
    movsx eax, word ptr [ebp - local_10]         # 004719e8
    shl eax, 0x4                                 # 004719ec
    mov ecx, dword ptr [ebp - local_20]          # 004719ef
    mov dword ptr [ecx + eax + field_664], edx   # 004719f2
    movsx edx, word ptr [ebp - local_10]         # 004719f9
    shl edx, 0x4                                 # 004719fd
    mov eax, dword ptr [ebp - local_14]          # 00471a00
    movsx ecx, word ptr [eax + field_114]        # 00471a03
    mov eax, dword ptr [ebp - local_20]          # 00471a0a
    mov edx, dword ptr [eax + edx + field_660]   # 00471a0d
    {load} add edx, ecx                          # 00471a14
    movsx eax, word ptr [ebp - local_10]         # 00471a16
    shl eax, 0x4                                 # 00471a1a
    mov ecx, dword ptr [ebp - local_20]          # 00471a1d
    mov dword ptr [ecx + eax + field_668], edx   # 00471a20
    jmp.d32 L_00471823                           # 00471a27
L_00471a2c:
    # block 0x00471a2c: entered by jge at 0x0047183c, 10 instruction(s), ends with forward jump to 0x00471b31
    mov edx, dword ptr [ebp - local_20]          # 00471a2c
    mov word ptr [edx + field_d22], 0x1          # 00471a2f
    mov word ptr [0x5957b7], 0x0                 # 00471a38
    mov eax, dword ptr [ebp - local_20]          # 00471a41
    mov word ptr [eax + field_e06], 0x0          # 00471a44
    mov ecx, dword ptr [ebp - local_20]          # 00471a4d
    mov edx, dword ptr [ebp - local_14]          # 00471a50
    mov ax, word ptr [edx + field_10c]           # 00471a53
    mov word ptr [ecx + field_e08], ax           # 00471a5a
    jmp.d32 L_00471b31                           # 00471a61
L_00471a66:
    # block 0x00471a66: entered by je at 0x004717f7, 20 instruction(s), ends with jle to 0x00471acb (forward)
    mov esi, dword ptr [ebp - local_8]           # 00471a66
    add esi, 0x305                               # 00471a69
    mov edi, dword ptr [ebp - local_20]          # 00471a6f
    add edi, 0x1c                                # 00471a72
    mov ecx, 0x78                                # 00471a75
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00471a7a
    mov esi, dword ptr [ebp - local_8]           # 00471a7c
    add esi, 0x4e5                               # 00471a7f
    mov edi, dword ptr [ebp - local_20]          # 00471a85
    add edi, 0x65c                               # 00471a88
    mov ecx, 0x78                                # 00471a8e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00471a93
    mov ecx, dword ptr [ebp - local_20]          # 00471a95
    mov edx, dword ptr [ebp - local_8]           # 00471a98
    mov ax, word ptr [edx + field_10c]           # 00471a9b
    mov word ptr [ecx + field_d22], ax           # 00471aa2
    mov ecx, dword ptr [ebp - local_20]          # 00471aa9
    movsx edx, word ptr [ecx + field_d22]        # 00471aac
    test edx, edx                                # 00471ab3
    jle.d8 L_00471acb                            # 00471ab5
    # block 0x00471ab7: entered by fall-through of jle at 0x00471ab5, 3 instruction(s), ends with jne to 0x00471acb (forward)
    movsx eax, word ptr [0x5957b7]               # 00471ab7
    test eax, eax                                # 00471abe
    jne.d8 L_00471acb                            # 00471ac0
    # block 0x00471ac2: entered by fall-through of jne at 0x00471ac0, 1 instruction(s), falls into the block at 0x00471acb
    mov word ptr [0x5957b7], 0x1                 # 00471ac2
L_00471acb:
    # block 0x00471acb: entered by jle at 0x00471ab5; jne at 0x00471ac0, 4 instruction(s), ends with forward jump to 0x00471aeb
    mov ecx, dword ptr [ebp - local_20]          # 00471acb
    mov word ptr [ecx + field_e06], 0x0          # 00471ace
    mov word ptr [ebp - local_10], 0x0           # 00471ad7
    jmp.d8 L_00471aeb                            # 00471add
L_00471adf:
    # block 0x00471adf: entered by jmp at 0x00471b23, 3 instruction(s), falls into the block at 0x00471aeb
    mov dx, word ptr [ebp - local_10]            # 00471adf
    add dx, 0x1                                  # 00471ae3
    mov word ptr [ebp - local_10], dx            # 00471ae7
L_00471aeb:
    # block 0x00471aeb: entered by jmp at 0x00471add, 3 instruction(s), ends with jge to 0x00471b25 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00471aeb
    cmp eax, 0x5                                 # 00471aef
    jge.d8 L_00471b25                            # 00471af2
    # block 0x00471af4: entered by fall-through of jge at 0x00471af2, 7 instruction(s), ends with je to 0x00471b23 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 00471af4
    imul ecx, ecx, 0x5                           # 00471af8
    mov edx, dword ptr [ebp - local_8]           # 00471afb
    {load} xor eax, eax                          # 00471afe
    mov al, byte ptr [edx + ecx + field_2d3]     # 00471b00
    test eax, eax                                # 00471b07
    je.d8 L_00471b23                             # 00471b09
    # block 0x00471b0b: entered by fall-through of je at 0x00471b09, 5 instruction(s), falls into the block at 0x00471b23
    mov ecx, dword ptr [ebp - local_20]          # 00471b0b
    mov dx, word ptr [ecx + field_e06]           # 00471b0e
    add dx, 0x1                                  # 00471b15
    mov eax, dword ptr [ebp - local_20]          # 00471b19
    mov word ptr [eax + field_e06], dx           # 00471b1c
L_00471b23:
    # block 0x00471b23: entered by je at 0x00471b09, 1 instruction(s), ends with backward jump to 0x00471adf
    jmp.d8 L_00471adf                            # 00471b23
L_00471b25:
    # block 0x00471b25: entered by jge at 0x00471af2, 2 instruction(s), falls into the block at 0x00471b31
    mov ecx, dword ptr [ebp - local_20]          # 00471b25
    mov word ptr [ecx + field_e08], 0x270f       # 00471b28
L_00471b31:
    # block 0x00471b31: entered by jmp at 0x00471a61, 3 instruction(s), ends with jg to 0x00471b56 (forward)
    movsx edx, word ptr [0x5957b7]               # 00471b31
    cmp edx, 0x1                                 # 00471b38
    jg.d8 L_00471b56                             # 00471b3b
    # block 0x00471b3d: entered by fall-through of jg at 0x00471b3b, 8 instruction(s), ends with forward jump to 0x00471b7e
    mov esi, dword ptr [ebp - local_8]           # 00471b3d
    add esi, 0x45                                # 00471b40
    mov edi, dword ptr [ebp - local_20]          # 00471b43
    add edi, 0xd01                               # 00471b46
    mov ecx, 0x8                                 # 00471b4c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00471b51
    movsb byte ptr es:[edi], byte ptr [esi]      # 00471b53
    jmp.d8 L_00471b7e                            # 00471b54
L_00471b56:
    # block 0x00471b56: entered by jg at 0x00471b3b, 10 instruction(s), falls into the block at 0x00471b7e
    movsx eax, word ptr [0x5957b7]               # 00471b56
    sub eax, 0x2                                 # 00471b5d
    imul eax, eax, 0x21                          # 00471b60
    mov ecx, dword ptr [ebp - local_8]           # 00471b63
    lea esi, [ecx + eax + field_24f]             # 00471b66
    mov edi, dword ptr [ebp - local_20]          # 00471b6d
    add edi, 0xd01                               # 00471b70
    mov ecx, 0x8                                 # 00471b76
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00471b7b
    movsb byte ptr es:[edi], byte ptr [esi]      # 00471b7d
L_00471b7e:
    # block 0x00471b7e: entered by jmp at 0x00471b54, 2 instruction(s), ends with forward jump to 0x00471b92
    mov word ptr [ebp - local_10], 0x0           # 00471b7e
    jmp.d8 L_00471b92                            # 00471b84
L_00471b86:
    # block 0x00471b86: entered by jmp at 0x00471bb0, 3 instruction(s), falls into the block at 0x00471b92
    mov dx, word ptr [ebp - local_10]            # 00471b86
    add dx, 0x1                                  # 00471b8a
    mov word ptr [ebp - local_10], dx            # 00471b8e
L_00471b92:
    # block 0x00471b92: entered by jmp at 0x00471b84, 5 instruction(s), ends with jge to 0x00471bb2 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00471b92
    mov ecx, dword ptr [ebp - local_14]          # 00471b96
    movsx edx, word ptr [ecx + field_21]         # 00471b99
    {load} cmp eax, edx                          # 00471b9d
    jge.d8 L_00471bb2                            # 00471b9f
    # block 0x00471ba1: entered by fall-through of jge at 0x00471b9f, 4 instruction(s), ends with backward jump to 0x00471b86
    movsx eax, word ptr [ebp - local_10]         # 00471ba1
    mov ecx, dword ptr [ebp - local_20]          # 00471ba5
    mov byte ptr [ecx + eax + field_c9c], 0x0    # 00471ba8
    jmp.d8 L_00471b86                            # 00471bb0
L_00471bb2:
    # block 0x00471bb2: entered by jge at 0x00471b9f, 2 instruction(s), ends with forward jump to 0x00471bc6
    mov word ptr [ebp - local_10], 0x0           # 00471bb2
    jmp.d8 L_00471bc6                            # 00471bb8
L_00471bba:
    # block 0x00471bba: entered by jmp at 0x00471bf1, 3 instruction(s), falls into the block at 0x00471bc6
    mov dx, word ptr [ebp - local_10]            # 00471bba
    add dx, 0x1                                  # 00471bbe
    mov word ptr [ebp - local_10], dx            # 00471bc2
L_00471bc6:
    # block 0x00471bc6: entered by jmp at 0x00471bb8, 3 instruction(s), ends with jge to 0x00471bf3 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00471bc6
    cmp eax, 0x1e                                # 00471bca
    jge.d8 L_00471bf3                            # 00471bcd
    # block 0x00471bcf: entered by fall-through of jge at 0x00471bcd, 7 instruction(s), ends with backward jump to 0x00471bba
    movsx ecx, word ptr [ebp - local_10]         # 00471bcf
    mov edx, dword ptr [ebp - local_20]          # 00471bd3
    mov word ptr [edx + 2*ecx + field_d4a], 0xffff # 00471bd6
    movsx eax, word ptr [ebp - local_10]         # 00471be0
    mov ecx, dword ptr [ebp - local_20]          # 00471be4
    mov word ptr [ecx + 2*eax + field_dc2], 0xffff # 00471be7
    jmp.d8 L_00471bba                            # 00471bf1
L_00471bf3:
    # block 0x00471bf3: entered by jge at 0x00471bcd, 67 instruction(s), calls FUN_004d39f9, ends with jne to 0x00471d4f (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471bf3
    mov word ptr [edx + field_d32], 0x0          # 00471bf6
    mov eax, dword ptr [ebp - local_20]          # 00471bff
    mov word ptr [eax + field_d30], 0x0          # 00471c02
    mov ecx, dword ptr [ebp - local_20]          # 00471c0b
    mov byte ptr [ecx + field_d00], 0x1          # 00471c0e
    mov edx, dword ptr [ebp - local_20]          # 00471c15
    mov byte ptr [edx + field_d3a], 0x0          # 00471c18
    call FUN_004d39f9                            # 00471c1f
    mov ecx, dword ptr [ebp - local_20]          # 00471c24
    mov word ptr [ecx + field_d38], ax           # 00471c27
    mov edx, dword ptr [ebp - local_20]          # 00471c2e
    movsx eax, word ptr [edx + field_d38]        # 00471c31
    imul eax, eax, 0x4a                          # 00471c38
    mov dword ptr [eax + 0x5d1591], 0xa          # 00471c3b
    mov ecx, dword ptr [ebp - local_20]          # 00471c45
    movsx edx, word ptr [ecx + field_d38]        # 00471c48
    imul edx, edx, 0x4a                          # 00471c4f
    mov dword ptr [edx + 0x5d1595], 0x472a5c     # 00471c52
    mov eax, dword ptr [ebp - local_20]          # 00471c5c
    movsx ecx, word ptr [eax + field_d38]        # 00471c5f
    imul ecx, ecx, 0x4a                          # 00471c66
    mov edx, dword ptr [ebp - local_20]          # 00471c69
    mov eax, dword ptr [edx + field_d24]         # 00471c6c
    mov dword ptr [ecx + 0x5d1599], eax          # 00471c72
    mov ecx, dword ptr [ebp - local_20]          # 00471c78
    movsx edx, word ptr [ecx + field_d38]        # 00471c7b
    imul edx, edx, 0x4a                          # 00471c82
    mov dword ptr [edx + 0x5d159d], 0x0          # 00471c85
    mov eax, dword ptr [ebp - local_20]          # 00471c8f
    movsx ecx, word ptr [eax + field_d38]        # 00471c92
    imul ecx, ecx, 0x4a                          # 00471c99
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 00471c9c
    mov edx, dword ptr [ebp - local_20]          # 00471ca6
    movsx eax, word ptr [edx + field_d38]        # 00471ca9
    imul eax, eax, 0x4a                          # 00471cb0
    mov dword ptr [eax + 0x5d15a5], 0x1          # 00471cb3
    mov ecx, dword ptr [ebp - local_20]          # 00471cbd
    movsx edx, word ptr [ecx + field_d38]        # 00471cc0
    imul edx, edx, 0x4a                          # 00471cc7
    mov dword ptr [edx + 0x5d15a9], 0x1          # 00471cca
    mov eax, dword ptr [ebp - local_20]          # 00471cd4
    movsx ecx, word ptr [eax + field_d38]        # 00471cd7
    imul ecx, ecx, 0x4a                          # 00471cde
    mov word ptr [ecx + 0x5d15ad], 0x0           # 00471ce1
    mov edi, 0x54c498                            # 00471cea
    mov edx, dword ptr [ebp - local_20]          # 00471cef
    movsx eax, word ptr [edx + field_d38]        # 00471cf2
    imul eax, eax, 0x4a                          # 00471cf9
    add eax, 0x5d15b3                            # 00471cfc
    {load} mov edx, eax                          # 00471d01
    or ecx, -0x1                                 # 00471d03
    {load} xor eax, eax                          # 00471d06
    repne scasb al, byte ptr es:[edi]            # 00471d08
    not ecx                                      # 00471d0a
    {load} sub edi, ecx                          # 00471d0c
    {load} mov esi, edi                          # 00471d0e
    {load} mov eax, ecx                          # 00471d10
    {load} mov edi, edx                          # 00471d12
    shr ecx, 0x2                                 # 00471d14
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00471d17
    {load} mov ecx, eax                          # 00471d19
    and ecx, 0x3                                 # 00471d1b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00471d1e
    mov ecx, dword ptr [ebp - local_20]          # 00471d20
    cmp dword ptr [ecx + field_d24], 0x0         # 00471d23
    jne.d8 L_00471d4f                            # 00471d2a
    # block 0x00471d2c: entered by fall-through of jne at 0x00471d2a, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00471d4f
    push 0x54c4b0                                # 00471d2c
    push 0x6                                     # 00471d31
    mov edx, dword ptr [ebp - local_8]           # 00471d33
    push edx                                     # 00471d36
    push 0x54c4c8                                # 00471d37
    mov ecx, 0x5cf659                            # 00471d3c
    call FUN_004c2790                            # 00471d41
    mov ecx, dword ptr [ebp - local_20]          # 00471d46
    mov dword ptr [ecx + field_d24], eax         # 00471d49
L_00471d4f:
    # block 0x00471d4f: entered by jne at 0x00471d2a, 13 instruction(s), ends with je to 0x00471d92 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471d4f
    movsx eax, word ptr [edx + field_d38]        # 00471d52
    imul eax, eax, 0x4a                          # 00471d59
    mov ecx, dword ptr [ebp - local_20]          # 00471d5c
    mov edx, dword ptr [ecx + field_d24]         # 00471d5f
    mov dword ptr [eax + 0x5d1599], edx          # 00471d65
    mov edi, 0x54c4d0                            # 00471d6b
    mov esi, dword ptr [ebp - local_8]           # 00471d70
    add esi, 0x66                                # 00471d73
    mov ecx, 0x9                                 # 00471d76
    {load} xor eax, eax                          # 00471d7b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00471d7d
    je.d8 L_00471d92                             # 00471d7f
    # block 0x00471d81: entered by fall-through of je at 0x00471d7f, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00471d92
    mov ecx, dword ptr [ebp - local_8]           # 00471d81
    add ecx, 0x66                                # 00471d84
    push ecx                                     # 00471d87
    mov ecx, 0x5c3a67                            # 00471d88
    call FUN_004fb77a                            # 00471d8d
L_00471d92:
    # block 0x00471d92: entered by je at 0x00471d7f, 7 instruction(s), ends with forward jump to 0x00472a2f
    mov edx, dword ptr [ebp - local_20]          # 00471d92
    mov dword ptr [edx + field_d2c], 0x0         # 00471d95
    mov eax, dword ptr [ebp - local_20]          # 00471d9f
    movsx ecx, word ptr [eax + field_d28]        # 00471da2
    imul ecx, ecx, 0x8d                          # 00471da9
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00471daf
    jmp.d32 L_00472a2f                           # 00471db9
L_00471dbe:
    # block 0x00471dbe: entered by je at 0x00471771, 5 instruction(s), ends with ja to 0x0047269e (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471dbe
    mov eax, dword ptr [edx + field_d2c]         # 00471dc1
    mov dword ptr [ebp - local_40], eax          # 00471dc7
    cmp dword ptr [ebp - local_40], 0x4          # 00471dca
    ja.d32 L_0047269e                            # 00471dce
    # block 0x00471dd4: entered by fall-through of ja at 0x00471dce, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x472a38]
    mov ecx, dword ptr [ebp - local_40]          # 00471dd4
    jmp dword ptr [4*ecx + SWTAB_00472a38_VA]    # 00471dd7
L_00471dde:
    # block 0x00471dde: entered by switch case, 5 instruction(s), ends with je to 0x00471e88 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471dde
    {load} xor eax, eax                          # 00471de1
    mov al, byte ptr [edx + field_dfe]           # 00471de3
    test eax, eax                                # 00471de9
    je.d32 L_00471e88                            # 00471deb
    # block 0x00471df1: entered by fall-through of je at 0x00471deb, 5 instruction(s), ends with jne to 0x00471e88 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00471df1
    {load} xor edx, edx                          # 00471df4
    mov dl, byte ptr [ecx + field_d3b]           # 00471df6
    test edx, edx                                # 00471dfc
    jne.d32 L_00471e88                           # 00471dfe
    # block 0x00471e04: entered by fall-through of jne at 0x00471dfe, 5 instruction(s), ends with jne to 0x00471e88 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00471e04
    {load} xor ecx, ecx                          # 00471e07
    mov cl, byte ptr [eax + field_24]            # 00471e09
    test ecx, ecx                                # 00471e0c
    jne.d8 L_00471e88                            # 00471e0e
    # block 0x00471e10: entered by fall-through of jne at 0x00471e0e, 3 instruction(s), ends with jle to 0x00471e76 (forward)
    movsx edx, word ptr [0x5957b7]               # 00471e10
    test edx, edx                                # 00471e17
    jle.d8 L_00471e76                            # 00471e19
    # block 0x00471e1b: entered by fall-through of jle at 0x00471e19, 5 instruction(s), ends with jge to 0x00471e76 (forward)
    movsx eax, word ptr [0x5957b7]               # 00471e1b
    mov ecx, dword ptr [ebp - local_8]           # 00471e22
    movsx edx, word ptr [ecx + field_10c]        # 00471e25
    {load} cmp eax, edx                          # 00471e2c
    jge.d8 L_00471e76                            # 00471e2e
    # block 0x00471e30: entered by fall-through of jge at 0x00471e2e, 6 instruction(s), ends with forward jump to 0x00471e5a
    mov eax, dword ptr [ebp - local_20]          # 00471e30
    mov byte ptr [eax + field_dfe], 0x0          # 00471e33
    mov ecx, dword ptr [ebp - local_20]          # 00471e3a
    mov word ptr [ecx + field_d32], 0x0          # 00471e3d
    mov word ptr [ebp - local_10], 0x0           # 00471e46
    jmp.d8 L_00471e5a                            # 00471e4c
L_00471e4e:
    # block 0x00471e4e: entered by jmp at 0x00471e74, 3 instruction(s), falls into the block at 0x00471e5a
    mov dx, word ptr [ebp - local_10]            # 00471e4e
    add dx, 0x1                                  # 00471e52
    mov word ptr [ebp - local_10], dx            # 00471e56
L_00471e5a:
    # block 0x00471e5a: entered by jmp at 0x00471e4c, 3 instruction(s), ends with jge to 0x00471e76 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00471e5a
    cmp eax, 0x1e                                # 00471e5e
    jge.d8 L_00471e76                            # 00471e61
    # block 0x00471e63: entered by fall-through of jge at 0x00471e61, 4 instruction(s), ends with backward jump to 0x00471e4e
    movsx ecx, word ptr [ebp - local_10]         # 00471e63
    mov edx, dword ptr [ebp - local_20]          # 00471e67
    mov word ptr [edx + 2*ecx + field_d4a], 0xffff # 00471e6a
    jmp.d8 L_00471e4e                            # 00471e74
L_00471e76:
    # block 0x00471e76: entered by jle at 0x00471e19; jge at 0x00471e2e; jge at 0x00471e61, 3 instruction(s), ends with forward jump to 0x0047269e
    mov eax, dword ptr [ebp - local_20]          # 00471e76
    mov dword ptr [eax + field_d2c], 0x1         # 00471e79
    jmp.d32 L_0047269e                           # 00471e83
L_00471e88:
    # block 0x00471e88: entered by je at 0x00471deb; jne at 0x00471dfe; jne at 0x00471e0e, 5 instruction(s), ends with je to 0x004721b4 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00471e88
    {load} xor edx, edx                          # 00471e8b
    mov dl, byte ptr [ecx + field_d3b]           # 00471e8d
    test edx, edx                                # 00471e93
    je.d32 L_004721b4                            # 00471e95
    # block 0x00471e9b: entered by fall-through of je at 0x00471e95, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004721af (forward)
    call dword ptr [0x52a23c]                    # 00471e9b
    mov ecx, dword ptr [ebp - local_20]          # 00471ea1
    cmp eax, dword ptr [ecx + field_e00]         # 00471ea4
    jbe.d32 L_004721af                           # 00471eaa
    # block 0x00471eb0: entered by fall-through of jbe at 0x00471eaa, 7 instruction(s), ends with je to 0x00472156 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471eb0
    mov byte ptr [edx + field_d3b], 0x0          # 00471eb3
    mov eax, dword ptr [ebp - local_20]          # 00471eba
    {load} xor ecx, ecx                          # 00471ebd
    mov cl, byte ptr [eax + field_d3a]           # 00471ebf
    test ecx, ecx                                # 00471ec5
    je.d32 L_00472156                            # 00471ec7
    # block 0x00471ecd: entered by fall-through of je at 0x00471ec7, 9 instruction(s), ends with je to 0x00471f2e (forward)
    mov edx, dword ptr [ebp - local_20]          # 00471ecd
    mov byte ptr [edx + field_d3a], 0x0          # 00471ed0
    mov eax, dword ptr [ebp - local_20]          # 00471ed7
    mov word ptr [eax + field_d30], 0x0          # 00471eda
    mov ecx, dword ptr [ebp - local_20]          # 00471ee3
    {load} xor edx, edx                          # 00471ee6
    mov dl, byte ptr [ecx + field_dfe]           # 00471ee8
    test edx, edx                                # 00471eee
    je.d8 L_00471f2e                             # 00471ef0
    # block 0x00471ef2: entered by fall-through of je at 0x00471ef0, 3 instruction(s), ends with jle to 0x00471f1c (forward)
    movsx eax, word ptr [0x5957b7]               # 00471ef2
    test eax, eax                                # 00471ef9
    jle.d8 L_00471f1c                            # 00471efb
    # block 0x00471efd: entered by fall-through of jle at 0x00471efb, 5 instruction(s), ends with jge to 0x00471f1c (forward)
    movsx ecx, word ptr [0x5957b7]               # 00471efd
    mov edx, dword ptr [ebp - local_8]           # 00471f04
    movsx eax, word ptr [edx + field_10c]        # 00471f07
    {load} cmp ecx, eax                          # 00471f0e
    jge.d8 L_00471f1c                            # 00471f10
    # block 0x00471f12: entered by fall-through of jge at 0x00471f10, 2 instruction(s), falls into the block at 0x00471f1c
    mov ecx, dword ptr [ebp - local_20]          # 00471f12
    mov byte ptr [ecx + field_dfe], 0x0          # 00471f15
L_00471f1c:
    # block 0x00471f1c: entered by jle at 0x00471efb; jge at 0x00471f10, 3 instruction(s), ends with forward jump to 0x00472118
    mov edx, dword ptr [ebp - local_20]          # 00471f1c
    mov dword ptr [edx + field_d2c], 0x1         # 00471f1f
    jmp.d32 L_00472118                           # 00471f29
L_00471f2e:
    # block 0x00471f2e: entered by je at 0x00471ef0, 4 instruction(s), ends with jle to 0x004720b0 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00471f2e
    movsx ecx, word ptr [eax + field_e06]        # 00471f31
    test ecx, ecx                                # 00471f38
    jle.d32 L_004720b0                           # 00471f3a
    # block 0x00471f40: entered by fall-through of jle at 0x00471f3a, 2 instruction(s), ends with forward jump to 0x00471f54
    mov word ptr [ebp - local_10], 0x0           # 00471f40
    jmp.d8 L_00471f54                            # 00471f46
L_00471f48:
    # block 0x00471f48: entered by jmp at 0x0047206d, 3 instruction(s), falls into the block at 0x00471f54
    mov dx, word ptr [ebp - local_10]            # 00471f48
    add dx, 0x1                                  # 00471f4c
    mov word ptr [ebp - local_10], dx            # 00471f50
L_00471f54:
    # block 0x00471f54: entered by jmp at 0x00471f46, 5 instruction(s), ends with jge to 0x00472072 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00471f54
    mov ecx, dword ptr [ebp - local_20]          # 00471f58
    movsx edx, word ptr [ecx + field_e06]        # 00471f5b
    {load} cmp eax, edx                          # 00471f62
    jge.d32 L_00472072                           # 00471f64
    # block 0x00471f6a: entered by fall-through of jge at 0x00471f64, 2 instruction(s), ends with forward jump to 0x00471f7e
    mov word ptr [ebp - local_c], 0x0            # 00471f6a
    jmp.d8 L_00471f7e                            # 00471f70
L_00471f72:
    # block 0x00471f72: entered by jmp at 0x00472038, 3 instruction(s), falls into the block at 0x00471f7e
    mov ax, word ptr [ebp - local_c]             # 00471f72
    .insn 0x66, 0x05, 0x0001{:u16}               # 00471f76
    mov word ptr [ebp - local_c], ax             # 00471f7a
L_00471f7e:
    # block 0x00471f7e: entered by jmp at 0x00471f70, 9 instruction(s), ends with je to 0x0047203d (forward)
    movsx ecx, word ptr [ebp - local_10]         # 00471f7e
    imul ecx, ecx, 0x5                           # 00471f82
    mov edx, dword ptr [ebp - local_8]           # 00471f85
    lea eax, [edx + ecx + field_2d3]             # 00471f88
    movsx ecx, word ptr [ebp - local_c]          # 00471f8f
    {load} xor edx, edx                          # 00471f93
    mov dl, byte ptr [eax + ecx]                 # 00471f95
    test edx, edx                                # 00471f98
    je.d32 L_0047203d                            # 00471f9a
    # block 0x00471fa0: entered by fall-through of je at 0x00471f9a, 3 instruction(s), ends with jge to 0x0047203d (forward)
    movsx eax, word ptr [ebp - local_c]          # 00471fa0
    cmp eax, 0x5                                 # 00471fa4
    jge.d32 L_0047203d                           # 00471fa7
    # block 0x00471fad: entered by fall-through of jge at 0x00471fa7, 3 instruction(s), ends with forward jump to 0x00471fc8
    mov dword ptr [ebp - local_4], 0x0           # 00471fad
    mov word ptr [ebp - local_18], 0x0           # 00471fb4
    jmp.d8 L_00471fc8                            # 00471fba
L_00471fbc:
    # block 0x00471fbc: entered by jmp at 0x0047202a, 3 instruction(s), falls into the block at 0x00471fc8
    mov cx, word ptr [ebp - local_18]            # 00471fbc
    add cx, 0x1                                  # 00471fc0
    mov word ptr [ebp - local_18], cx            # 00471fc4
L_00471fc8:
    # block 0x00471fc8: entered by jmp at 0x00471fba, 5 instruction(s), ends with jge to 0x0047202c (forward)
    movsx edx, word ptr [ebp - local_18]         # 00471fc8
    mov eax, dword ptr [ebp - local_14]          # 00471fcc
    movsx ecx, word ptr [eax + field_21]         # 00471fcf
    {load} cmp edx, ecx                          # 00471fd3
    jge.d8 L_0047202c                            # 00471fd5
    # block 0x00471fd7: entered by fall-through of jge at 0x00471fd5, 13 instruction(s), ends with jne to 0x0047202a (forward)
    movsx edx, word ptr [ebp - local_18]         # 00471fd7
    mov eax, dword ptr [ebp - local_20]          # 00471fdb
    movsx ecx, word ptr [eax + 2*edx + field_dc2] # 00471fde
    movsx edx, word ptr [ebp - local_10]         # 00471fe6
    imul edx, edx, 0x5                           # 00471fea
    mov eax, dword ptr [ebp - local_8]           # 00471fed
    lea edx, [eax + edx + field_2d3]             # 00471ff0
    movsx eax, word ptr [ebp - local_c]          # 00471ff7
    {load} xor ebx, ebx                          # 00471ffb
    mov bl, byte ptr [edx + eax]                 # 00471ffd
    sub ebx, 0x1                                 # 00472000
    {load} cmp ecx, ebx                          # 00472003
    jne.d8 L_0047202a                            # 00472005
    # block 0x00472007: entered by fall-through of jne at 0x00472005, 7 instruction(s), falls into the block at 0x0047202a
    mov dword ptr [ebp - local_4], 0x1           # 00472007
    mov ecx, dword ptr [ebp - local_14]          # 0047200e
    mov dx, word ptr [ecx + field_21]            # 00472011
    mov word ptr [ebp - local_18], dx            # 00472015
    movsx eax, word ptr [ebp - local_18]         # 00472019
    mov ecx, dword ptr [ebp - local_20]          # 0047201d
    mov word ptr [ecx + 2*eax + field_dc2], 0xffff # 00472020
L_0047202a:
    # block 0x0047202a: entered by jne at 0x00472005, 1 instruction(s), ends with backward jump to 0x00471fbc
    jmp.d8 L_00471fbc                            # 0047202a
L_0047202c:
    # block 0x0047202c: entered by jge at 0x00471fd5, 2 instruction(s), ends with jne to 0x00472038 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0047202c
    jne.d8 L_00472038                            # 00472030
    # block 0x00472032: entered by fall-through of jne at 0x00472030, 1 instruction(s), falls into the block at 0x00472038
    mov word ptr [ebp - local_c], 0x5            # 00472032
L_00472038:
    # block 0x00472038: entered by jne at 0x00472030, 1 instruction(s), ends with backward jump to 0x00471f72
    jmp.d32 L_00471f72                           # 00472038
L_0047203d:
    # block 0x0047203d: entered by je at 0x00471f9a; jge at 0x00471fa7, 2 instruction(s), ends with je to 0x0047206d (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0047203d
    je.d8 L_0047206d                             # 00472041
    # block 0x00472043: entered by fall-through of je at 0x00472041, 7 instruction(s), falls into the block at 0x0047206d
    mov edx, dword ptr [ebp - local_20]          # 00472043
    mov byte ptr [edx + field_dff], 0x1          # 00472046
    mov word ptr [ebp - local_c], 0x5            # 0047204d
    mov eax, dword ptr [ebp - local_20]          # 00472053
    movsx ecx, word ptr [eax + field_d28]        # 00472056
    imul ecx, ecx, 0x8d                          # 0047205d
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00472063
L_0047206d:
    # block 0x0047206d: entered by je at 0x00472041, 1 instruction(s), ends with backward jump to 0x00471f48
    jmp.d32 L_00471f48                           # 0047206d
L_00472072:
    # block 0x00472072: entered by jge at 0x00471f64, 2 instruction(s), ends with forward jump to 0x00472086
    mov word ptr [ebp - local_10], 0x0           # 00472072
    jmp.d8 L_00472086                            # 00472078
L_0047207a:
    # block 0x0047207a: entered by jmp at 0x004720a0, 3 instruction(s), falls into the block at 0x00472086
    mov dx, word ptr [ebp - local_10]            # 0047207a
    add dx, 0x1                                  # 0047207e
    mov word ptr [ebp - local_10], dx            # 00472082
L_00472086:
    # block 0x00472086: entered by jmp at 0x00472078, 3 instruction(s), ends with jge to 0x004720a2 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00472086
    cmp eax, 0x1e                                # 0047208a
    jge.d8 L_004720a2                            # 0047208d
    # block 0x0047208f: entered by fall-through of jge at 0x0047208d, 4 instruction(s), ends with backward jump to 0x0047207a
    movsx ecx, word ptr [ebp - local_10]         # 0047208f
    mov edx, dword ptr [ebp - local_20]          # 00472093
    mov word ptr [edx + 2*ecx + field_dc2], 0xffff # 00472096
    jmp.d8 L_0047207a                            # 004720a0
L_004720a2:
    # block 0x004720a2: entered by jge at 0x0047208d, 3 instruction(s), ends with forward jump to 0x00472118
    mov eax, dword ptr [ebp - local_20]          # 004720a2
    mov word ptr [eax + field_d30], 0x0          # 004720a5
    jmp.d8 L_00472118                            # 004720ae
L_004720b0:
    # block 0x004720b0: entered by jle at 0x00471f3a, 4 instruction(s), ends with je to 0x004720ca (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004720b0
    movsx edx, word ptr [ecx + field_d32]        # 004720b3
    test edx, edx                                # 004720ba
    je.d8 L_004720ca                             # 004720bc
    # block 0x004720be: entered by fall-through of je at 0x004720bc, 5 instruction(s), ends with jne to 0x004720ea (forward)
    mov eax, dword ptr [ebp - local_8]           # 004720be
    {load} xor ecx, ecx                          # 004720c1
    mov cl, byte ptr [eax + field_23]            # 004720c3
    test ecx, ecx                                # 004720c6
    jne.d8 L_004720ea                            # 004720c8
L_004720ca:
    # block 0x004720ca: entered by je at 0x004720bc; fall-through of jne at 0x004720c8, 4 instruction(s), ends with je to 0x004720ea (forward)
    mov edx, dword ptr [ebp - local_20]          # 004720ca
    movsx eax, word ptr [edx + field_e08]        # 004720cd
    cmp eax, 0x270f                              # 004720d4
    je.d8 L_004720ea                             # 004720d9
    # block 0x004720db: entered by fall-through of je at 0x004720d9, 3 instruction(s), ends with forward jump to 0x00472118
    mov ecx, dword ptr [ebp - local_20]          # 004720db
    mov dword ptr [ecx + field_d2c], 0x1         # 004720de
    jmp.d8 L_00472118                            # 004720e8
L_004720ea:
    # block 0x004720ea: entered by jne at 0x004720c8; je at 0x004720d9, 2 instruction(s), ends with forward jump to 0x004720fe
    mov word ptr [ebp - local_10], 0x0           # 004720ea
    jmp.d8 L_004720fe                            # 004720f0
L_004720f2:
    # block 0x004720f2: entered by jmp at 0x00472116, 3 instruction(s), falls into the block at 0x004720fe
    mov dx, word ptr [ebp - local_10]            # 004720f2
    add dx, 0x1                                  # 004720f6
    mov word ptr [ebp - local_10], dx            # 004720fa
L_004720fe:
    # block 0x004720fe: entered by jmp at 0x004720f0, 3 instruction(s), ends with jge to 0x00472118 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004720fe
    cmp eax, 0x64                                # 00472102
    jge.d8 L_00472118                            # 00472105
    # block 0x00472107: entered by fall-through of jge at 0x00472105, 4 instruction(s), ends with backward jump to 0x004720f2
    movsx ecx, word ptr [ebp - local_10]         # 00472107
    mov edx, dword ptr [ebp - local_20]          # 0047210b
    mov byte ptr [edx + ecx + field_c9c], 0x0    # 0047210e
    jmp.d8 L_004720f2                            # 00472116
L_00472118:
    # block 0x00472118: entered by jmp at 0x00471f29; jmp at 0x004720ae; jmp at 0x004720e8; jge at 0x00472105, 2 instruction(s), ends with forward jump to 0x0047212c
    mov word ptr [ebp - local_10], 0x0           # 00472118
    jmp.d8 L_0047212c                            # 0047211e
L_00472120:
    # block 0x00472120: entered by jmp at 0x00472146, 3 instruction(s), falls into the block at 0x0047212c
    mov ax, word ptr [ebp - local_10]            # 00472120
    .insn 0x66, 0x05, 0x0001{:u16}               # 00472124
    mov word ptr [ebp - local_10], ax            # 00472128
L_0047212c:
    # block 0x0047212c: entered by jmp at 0x0047211e, 3 instruction(s), ends with jge to 0x00472148 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0047212c
    cmp ecx, 0x1e                                # 00472130
    jge.d8 L_00472148                            # 00472133
    # block 0x00472135: entered by fall-through of jge at 0x00472133, 4 instruction(s), ends with backward jump to 0x00472120
    movsx edx, word ptr [ebp - local_10]         # 00472135
    mov eax, dword ptr [ebp - local_20]          # 00472139
    mov word ptr [eax + 2*edx + field_d4a], 0xffff # 0047213c
    jmp.d8 L_00472120                            # 00472146
L_00472148:
    # block 0x00472148: entered by jge at 0x00472133, 3 instruction(s), ends with forward jump to 0x004721ad
    mov ecx, dword ptr [ebp - local_20]          # 00472148
    mov word ptr [ecx + field_d32], 0x0          # 0047214b
    jmp.d8 L_004721ad                            # 00472154
L_00472156:
    # block 0x00472156: entered by je at 0x00471ec7, 4 instruction(s), ends with je to 0x004721ad (forward)
    mov edx, dword ptr [ebp - local_20]          # 00472156
    movsx eax, word ptr [edx + field_d2a]        # 00472159
    cmp eax, 0x28                                # 00472160
    je.d8 L_004721ad                             # 00472163
    # block 0x00472165: entered by fall-through of je at 0x00472163, 2 instruction(s), ends with forward jump to 0x00472179
    mov word ptr [ebp - local_10], 0x0           # 00472165
    jmp.d8 L_00472179                            # 0047216b
L_0047216d:
    # block 0x0047216d: entered by jmp at 0x004721ab, 3 instruction(s), falls into the block at 0x00472179
    mov cx, word ptr [ebp - local_10]            # 0047216d
    add cx, 0x1                                  # 00472171
    mov word ptr [ebp - local_10], cx            # 00472175
L_00472179:
    # block 0x00472179: entered by jmp at 0x0047216b, 5 instruction(s), ends with jge to 0x004721ad (forward)
    movsx edx, word ptr [ebp - local_10]         # 00472179
    mov eax, dword ptr [ebp - local_14]          # 0047217d
    movsx ecx, word ptr [eax + field_21]         # 00472180
    {load} cmp edx, ecx                          # 00472184
    jge.d8 L_004721ad                            # 00472186
    # block 0x00472188: entered by fall-through of jge at 0x00472186, 6 instruction(s), ends with je to 0x004721ab (forward)
    movsx edx, word ptr [ebp - local_10]         # 00472188
    mov eax, dword ptr [ebp - local_20]          # 0047218c
    {load} xor ecx, ecx                          # 0047218f
    mov cl, byte ptr [eax + edx + field_c9c]     # 00472191
    test ecx, ecx                                # 00472198
    je.d8 L_004721ab                             # 0047219a
    # block 0x0047219c: entered by fall-through of je at 0x0047219a, 3 instruction(s), falls into the block at 0x004721ab
    movsx edx, word ptr [ebp - local_10]         # 0047219c
    mov eax, dword ptr [ebp - local_20]          # 004721a0
    mov byte ptr [eax + edx + field_c9c], 0x0    # 004721a3
L_004721ab:
    # block 0x004721ab: entered by je at 0x0047219a, 1 instruction(s), ends with backward jump to 0x0047216d
    jmp.d8 L_0047216d                            # 004721ab
L_004721ad:
    # block 0x004721ad: entered by jmp at 0x00472154; je at 0x00472163; jge at 0x00472186, 1 instruction(s), ends with forward jump to 0x004721b4
    jmp.d8 L_004721b4                            # 004721ad
L_004721af:
    # block 0x004721af: entered by jbe at 0x00471eaa, 1 instruction(s), ends with forward jump to 0x0047269e
    jmp.d32 L_0047269e                           # 004721af
L_004721b4:
    # block 0x004721b4: entered by je at 0x00471e95; jmp at 0x004721ad, 4 instruction(s), ends with jle to 0x00472346 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004721b4
    movsx edx, word ptr [ecx + field_d01]        # 004721b7
    test edx, edx                                # 004721be
    jle.d32 L_00472346                           # 004721c0
    # block 0x004721c6: entered by fall-through of jle at 0x004721c0, 5 instruction(s), ends with jne to 0x00472346 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004721c6
    {load} xor ecx, ecx                          # 004721c9
    mov cl, byte ptr [eax + field_d3b]           # 004721cb
    test ecx, ecx                                # 004721d1
    jne.d32 L_00472346                           # 004721d3
    # block 0x004721d9: entered by fall-through of jne at 0x004721d3, 6 instruction(s), ends with jne to 0x00472346 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004721d9
    movsx eax, word ptr [edx + field_d32]        # 004721dc
    mov ecx, dword ptr [ebp - local_20]          # 004721e3
    movsx edx, word ptr [ecx + field_d01]        # 004721e6
    {load} cmp eax, edx                          # 004721ed
    jne.d32 L_00472346                           # 004721ef
    # block 0x004721f5: entered by fall-through of jne at 0x004721ef, 4 instruction(s), ends with forward jump to 0x00472213
    mov eax, dword ptr [ebp - local_20]          # 004721f5
    mov byte ptr [eax + field_dfe], 0x1          # 004721f8
    mov word ptr [ebp - local_10], 0x0           # 004721ff
    jmp.d8 L_00472213                            # 00472205
L_00472207:
    # block 0x00472207: entered by jmp at 0x00472341, 3 instruction(s), falls into the block at 0x00472213
    mov cx, word ptr [ebp - local_10]            # 00472207
    add cx, 0x1                                  # 0047220b
    mov word ptr [ebp - local_10], cx            # 0047220f
L_00472213:
    # block 0x00472213: entered by jmp at 0x00472205, 5 instruction(s), ends with jge to 0x00472346 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00472213
    mov eax, dword ptr [ebp - local_20]          # 00472217
    movsx ecx, word ptr [eax + field_d01]        # 0047221a
    {load} cmp edx, ecx                          # 00472221
    jge.d32 L_00472346                           # 00472223
    # block 0x00472229: entered by fall-through of jge at 0x00472223, 5 instruction(s), ends with je to 0x00472278 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00472229
    {load} xor eax, eax                          # 0047222c
    mov al, byte ptr [edx + field_d03]           # 0047222e
    test eax, eax                                # 00472234
    je.d8 L_00472278                             # 00472236
    # block 0x00472238: entered by fall-through of je at 0x00472236, 9 instruction(s), ends with je to 0x00472278 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 00472238
    mov edx, dword ptr [ebp - local_20]          # 0047223c
    movsx eax, word ptr [edx + 2*ecx + field_d4a] # 0047223f
    movsx ecx, word ptr [ebp - local_10]         # 00472247
    mov edx, dword ptr [ebp - local_20]          # 0047224b
    {load} xor ebx, ebx                          # 0047224e
    mov bl, byte ptr [edx + ecx + field_d04]     # 00472250
    {load} cmp eax, ebx                          # 00472257
    je.d8 L_00472278                             # 00472259
    # block 0x0047225b: entered by fall-through of je at 0x00472259, 6 instruction(s), ends with forward jump to 0x00472341
    mov eax, dword ptr [ebp - local_20]          # 0047225b
    mov byte ptr [eax + field_dfe], 0x0          # 0047225e
    mov ecx, dword ptr [ebp - local_20]          # 00472265
    mov dx, word ptr [ecx + field_d01]           # 00472268
    mov word ptr [ebp - local_10], dx            # 0047226f
    jmp.d32 L_00472341                           # 00472273
L_00472278:
    # block 0x00472278: entered by je at 0x00472236; je at 0x00472259, 5 instruction(s), ends with jne to 0x00472341 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00472278
    {load} xor ecx, ecx                          # 0047227b
    mov cl, byte ptr [eax + field_d03]           # 0047227d
    test ecx, ecx                                # 00472283
    jne.d32 L_00472341                           # 00472285
    # block 0x0047228b: entered by fall-through of jne at 0x00472285, 9 instruction(s), ends with forward jump to 0x004722bf
    mov esi, dword ptr [ebp - local_20]          # 0047228b
    add esi, 0xd4a                               # 0047228e
    mov edi, dword ptr [ebp - local_20]          # 00472294
    add edi, 0xd86                               # 00472297
    mov ecx, 0xf                                 # 0047229d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004722a2
    mov dword ptr [ebp - local_4], 0x1           # 004722a4
    mov word ptr [ebp - local_c], 0x0            # 004722ab
    jmp.d8 L_004722bf                            # 004722b1
L_004722b3:
    # block 0x004722b3: entered by jmp at 0x00472321, 3 instruction(s), falls into the block at 0x004722bf
    mov dx, word ptr [ebp - local_c]             # 004722b3
    add dx, 0x1                                  # 004722b7
    mov word ptr [ebp - local_c], dx             # 004722bb
L_004722bf:
    # block 0x004722bf: entered by jmp at 0x004722b1, 5 instruction(s), ends with jge to 0x00472323 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004722bf
    mov ecx, dword ptr [ebp - local_20]          # 004722c3
    movsx edx, word ptr [ecx + field_d01]        # 004722c6
    {load} cmp eax, edx                          # 004722cd
    jge.d8 L_00472323                            # 004722cf
    # block 0x004722d1: entered by fall-through of jge at 0x004722cf, 10 instruction(s), ends with jne to 0x00472321 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 004722d1
    movsx eax, word ptr [ebp - local_c]          # 004722d8
    mov ecx, dword ptr [ebp - local_20]          # 004722dc
    movsx edx, word ptr [ecx + 2*eax + field_d86] # 004722df
    movsx eax, word ptr [ebp - local_10]         # 004722e7
    mov ecx, dword ptr [ebp - local_20]          # 004722eb
    {load} xor ebx, ebx                          # 004722ee
    mov bl, byte ptr [ecx + eax + field_d04]     # 004722f0
    {load} cmp edx, ebx                          # 004722f7
    jne.d8 L_00472321                            # 004722f9
    # block 0x004722fb: entered by fall-through of jne at 0x004722f9, 7 instruction(s), falls into the block at 0x00472321
    mov dword ptr [ebp - local_4], 0x1           # 004722fb
    mov edx, dword ptr [ebp - local_20]          # 00472302
    mov ax, word ptr [edx + field_d01]           # 00472305
    mov word ptr [ebp - local_c], ax             # 0047230c
    movsx ecx, word ptr [ebp - local_c]          # 00472310
    mov edx, dword ptr [ebp - local_20]          # 00472314
    mov word ptr [edx + 2*ecx + field_d86], 0xffff # 00472317
L_00472321:
    # block 0x00472321: entered by jne at 0x004722f9, 1 instruction(s), ends with backward jump to 0x004722b3
    jmp.d8 L_004722b3                            # 00472321
L_00472323:
    # block 0x00472323: entered by jge at 0x004722cf, 2 instruction(s), ends with jne to 0x00472341 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00472323
    jne.d8 L_00472341                            # 00472327
    # block 0x00472329: entered by fall-through of jne at 0x00472327, 5 instruction(s), falls into the block at 0x00472341
    mov eax, dword ptr [ebp - local_20]          # 00472329
    mov byte ptr [eax + field_dfe], 0x0          # 0047232c
    mov ecx, dword ptr [ebp - local_20]          # 00472333
    mov dx, word ptr [ecx + field_d01]           # 00472336
    mov word ptr [ebp - local_10], dx            # 0047233d
L_00472341:
    # block 0x00472341: entered by jmp at 0x00472273; jne at 0x00472285; jne at 0x00472327, 1 instruction(s), ends with backward jump to 0x00472207
    jmp.d32 L_00472207                           # 00472341
L_00472346:
    # block 0x00472346: entered by jle at 0x004721c0; jne at 0x004721d3; jne at 0x004721ef; jge at 0x00472223, 5 instruction(s), ends with je to 0x004723d1 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00472346
    {load} xor ecx, ecx                          # 00472349
    mov cl, byte ptr [eax + field_23]            # 0047234b
    test ecx, ecx                                # 0047234e
    je.d8 L_004723d1                             # 00472350
    # block 0x00472352: entered by fall-through of je at 0x00472350, 6 instruction(s), ends with jl to 0x004723d1 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00472352
    movsx eax, word ptr [edx + field_d32]        # 00472355
    mov ecx, dword ptr [ebp - local_14]          # 0047235c
    movsx edx, word ptr [ecx + field_21]         # 0047235f
    {load} cmp eax, edx                          # 00472363
    jl.d8 L_004723d1                             # 00472365
    # block 0x00472367: entered by fall-through of jl at 0x00472365, 2 instruction(s), ends with forward jump to 0x0047237b
    mov word ptr [ebp - local_10], 0x0           # 00472367
    jmp.d8 L_0047237b                            # 0047236d
L_0047236f:
    # block 0x0047236f: entered by jmp at 0x00472393, 3 instruction(s), falls into the block at 0x0047237b
    mov ax, word ptr [ebp - local_10]            # 0047236f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00472373
    mov word ptr [ebp - local_10], ax            # 00472377
L_0047237b:
    # block 0x0047237b: entered by jmp at 0x0047236d, 3 instruction(s), ends with jge to 0x00472395 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0047237b
    cmp ecx, 0x64                                # 0047237f
    jge.d8 L_00472395                            # 00472382
    # block 0x00472384: entered by fall-through of jge at 0x00472382, 4 instruction(s), ends with backward jump to 0x0047236f
    movsx edx, word ptr [ebp - local_10]         # 00472384
    mov eax, dword ptr [ebp - local_20]          # 00472388
    mov byte ptr [eax + edx + field_c9c], 0x0    # 0047238b
    jmp.d8 L_0047236f                            # 00472393
L_00472395:
    # block 0x00472395: entered by jge at 0x00472382, 2 instruction(s), ends with forward jump to 0x004723a9
    mov word ptr [ebp - local_10], 0x0           # 00472395
    jmp.d8 L_004723a9                            # 0047239b
L_0047239d:
    # block 0x0047239d: entered by jmp at 0x004723c3, 3 instruction(s), falls into the block at 0x004723a9
    mov cx, word ptr [ebp - local_10]            # 0047239d
    add cx, 0x1                                  # 004723a1
    mov word ptr [ebp - local_10], cx            # 004723a5
L_004723a9:
    # block 0x004723a9: entered by jmp at 0x0047239b, 3 instruction(s), ends with jge to 0x004723c5 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004723a9
    cmp edx, 0x1e                                # 004723ad
    jge.d8 L_004723c5                            # 004723b0
    # block 0x004723b2: entered by fall-through of jge at 0x004723b0, 4 instruction(s), ends with backward jump to 0x0047239d
    movsx eax, word ptr [ebp - local_10]         # 004723b2
    mov ecx, dword ptr [ebp - local_20]          # 004723b6
    mov word ptr [ecx + 2*eax + field_d4a], 0xffff # 004723b9
    jmp.d8 L_0047239d                            # 004723c3
L_004723c5:
    # block 0x004723c5: entered by jge at 0x004723b0, 2 instruction(s), falls into the block at 0x004723d1
    mov edx, dword ptr [ebp - local_20]          # 004723c5
    mov word ptr [edx + field_d32], 0x0          # 004723c8
L_004723d1:
    # block 0x004723d1: entered by je at 0x00472350; jl at 0x00472365, 1 instruction(s), ends with forward jump to 0x0047269e
    jmp.d32 L_0047269e                           # 004723d1
L_004723d6:
    # block 0x004723d6: entered by switch case, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0047269e
    call dword ptr [0x52a23c]                    # 004723d6
    mov ecx, dword ptr [ebp - local_8]           # 004723dc
    movsx edx, word ptr [ecx + field_b0]         # 004723df
    imul edx, edx, 0x3e8                         # 004723e6
    lea eax, [eax + edx + field_190]             # 004723ec
    mov ecx, dword ptr [ebp - local_20]          # 004723f3
    mov dword ptr [ecx + field_d44], eax         # 004723f6
    call dword ptr [0x52a23c]                    # 004723fc
    add eax, 0x64                                # 00472402
    mov edx, dword ptr [ebp - local_20]          # 00472405
    mov dword ptr [edx + field_d40], eax         # 00472408
    mov eax, dword ptr [ebp - local_20]          # 0047240e
    mov dword ptr [eax + field_d2c], 0x3         # 00472411
    jmp.d32 L_0047269e                           # 0047241b
L_00472420:
    # block 0x00472420: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0047254f (forward)
    call dword ptr [0x52a23c]                    # 00472420
    mov ecx, dword ptr [ebp - local_20]          # 00472426
    cmp eax, dword ptr [ecx + field_d44]         # 00472429
    jb.d32 L_0047254f                            # 0047242f
    # block 0x00472435: entered by fall-through of jb at 0x0047242f, 4 instruction(s), ends with je to 0x00472481 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00472435
    movsx eax, word ptr [edx + field_e08]        # 00472438
    cmp eax, 0x270f                              # 0047243f
    je.d8 L_00472481                             # 00472444
    # block 0x00472446: entered by fall-through of je at 0x00472444, 4 instruction(s), ends with je to 0x00472481 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00472446
    movsx edx, word ptr [ecx + field_e08]        # 00472449
    test edx, edx                                # 00472450
    je.d8 L_00472481                             # 00472452
    # block 0x00472454: entered by fall-through of je at 0x00472452, 4 instruction(s), ends with jne to 0x00472481 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00472454
    movsx ecx, word ptr [eax + field_d32]        # 00472457
    test ecx, ecx                                # 0047245e
    jne.d8 L_00472481                            # 00472460
    # block 0x00472462: entered by fall-through of jne at 0x00472460, 5 instruction(s), ends with forward jump to 0x0047254d
    mov edx, dword ptr [ebp - local_20]          # 00472462
    movsx eax, word ptr [edx + field_d28]        # 00472465
    imul eax, eax, 0x8d                          # 0047246c
    mov dword ptr [eax + 0x5bb632], 0x2          # 00472472
    jmp.d32 L_0047254d                           # 0047247c
L_00472481:
    # block 0x00472481: entered by je at 0x00472444; je at 0x00472452; jne at 0x00472460, 7 instruction(s), ends with je to 0x004724d1 (forward)
    mov edi, 0x54c4dc                            # 00472481
    mov esi, dword ptr [ebp - local_8]           # 00472486
    add esi, 0xb2                                # 00472489
    mov ecx, 0x9                                 # 0047248f
    {load} xor edx, edx                          # 00472494
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00472496
    je.d8 L_004724d1                             # 00472498
    # block 0x0047249a: entered by fall-through of je at 0x00472498, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0047254d
    mov eax, dword ptr [ebp - local_8]           # 0047249a
    add eax, 0xb2                                # 0047249d
    push eax                                     # 004724a2
    mov ecx, 0x5c3a67                            # 004724a3
    call FUN_004fb77a                            # 004724a8
    mov ecx, dword ptr [ebp - local_8]           # 004724ad
    mov dx, word ptr [ecx + field_d3]            # 004724b0
    push edx                                     # 004724b7
    mov ecx, 0x5c3a67                            # 004724b8
    call FUN_004fb2e3                            # 004724bd
    mov eax, dword ptr [ebp - local_20]          # 004724c2
    mov dword ptr [eax + field_d2c], 0x4         # 004724c5
    jmp.d8 L_0047254d                            # 004724cf
L_004724d1:
    # block 0x004724d1: entered by je at 0x00472498, 5 instruction(s), ends with je to 0x004724fc (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004724d1
    {load} xor edx, edx                          # 004724d4
    mov dl, byte ptr [ecx + field_dfe]           # 004724d6
    test edx, edx                                # 004724dc
    je.d8 L_004724fc                             # 004724de
    # block 0x004724e0: entered by fall-through of je at 0x004724de, 5 instruction(s), ends with forward jump to 0x0047254d
    mov eax, dword ptr [ebp - local_20]          # 004724e0
    movsx ecx, word ptr [eax + field_d28]        # 004724e3
    imul ecx, ecx, 0x8d                          # 004724ea
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004724f0
    jmp.d8 L_0047254d                            # 004724fa
L_004724fc:
    # block 0x004724fc: entered by je at 0x004724de, 17 instruction(s), falls into the block at 0x0047254d
    movsx edx, word ptr [0x5957b7]               # 004724fc
    sub edx, 0x1                                 # 00472503
    imul edx, edx, 0x21                          # 00472506
    mov eax, dword ptr [ebp - local_8]           # 00472509
    lea esi, [eax + edx + field_24f]             # 0047250c
    mov edi, dword ptr [ebp - local_20]          # 00472513
    add edi, 0xd01                               # 00472516
    mov ecx, 0x8                                 # 0047251c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00472521
    movsb byte ptr es:[edi], byte ptr [esi]      # 00472523
    mov cx, word ptr [0x5957b7]                  # 00472524
    add cx, 0x1                                  # 0047252b
    mov word ptr [0x5957b7], cx                  # 0047252f
    mov edx, dword ptr [ebp - local_20]          # 00472536
    mov byte ptr [edx + field_d3c], 0x0          # 00472539
    mov eax, dword ptr [ebp - local_20]          # 00472540
    mov dword ptr [eax + field_d2c], 0x0         # 00472543
L_0047254d:
    # block 0x0047254d: entered by jmp at 0x0047247c; jmp at 0x004724cf; jmp at 0x004724fa, 1 instruction(s), ends with forward jump to 0x0047259a
    jmp.d8 L_0047259a                            # 0047254d
L_0047254f:
    # block 0x0047254f: entered by jb at 0x0047242f, 5 instruction(s), ends with je to 0x0047259a (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047254f
    {load} xor edx, edx                          # 00472552
    mov dl, byte ptr [ecx + field_24e]           # 00472554
    test edx, edx                                # 0047255a
    je.d8 L_0047259a                             # 0047255c
    # block 0x0047255e: entered by fall-through of je at 0x0047255c, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0047259a (forward)
    call dword ptr [0x52a23c]                    # 0047255e
    mov ecx, dword ptr [ebp - local_20]          # 00472564
    cmp eax, dword ptr [ecx + field_d40]         # 00472567
    jb.d8 L_0047259a                             # 0047256d
    # block 0x0047256f: entered by fall-through of jb at 0x0047256d, 12 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0047259a
    mov edx, dword ptr [ebp - local_20]          # 0047256f
    {load} xor eax, eax                          # 00472572
    mov al, byte ptr [edx + field_d3c]           # 00472574
    neg eax                                      # 0047257a
    {load} sbb eax, eax                          # 0047257c
    inc eax                                      # 0047257e
    mov ecx, dword ptr [ebp - local_20]          # 0047257f
    mov byte ptr [ecx + field_d3c], al           # 00472582
    call dword ptr [0x52a23c]                    # 00472588
    add eax, 0x64                                # 0047258e
    mov edx, dword ptr [ebp - local_20]          # 00472591
    mov dword ptr [edx + field_d40], eax         # 00472594
L_0047259a:
    # block 0x0047259a: entered by jmp at 0x0047254d; je at 0x0047255c; jb at 0x0047256d, 1 instruction(s), ends with forward jump to 0x0047269e
    jmp.d32 L_0047269e                           # 0047259a
L_0047259f:
    # block 0x0047259f: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00472653 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047259f
    movsx ecx, word ptr [eax + field_d3]         # 004725a2
    mov dword ptr [ebp - local_1c], ecx          # 004725a9
    mov edx, dword ptr [ebp - local_1c]          # 004725ac
    push edx                                     # 004725af
    mov ecx, 0x5cf1eb                            # 004725b0
    call FUN_004f6334                            # 004725b5
    test eax, eax                                # 004725ba
    jne.d32 L_00472653                           # 004725bc
    # block 0x004725c2: entered by fall-through of jne at 0x004725bc, 10 instruction(s), calls FUN_004fba69, ends with je to 0x00472600 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004725c2
    add eax, 0xb2                                # 004725c5
    push eax                                     # 004725ca
    mov ecx, 0x5c3a67                            # 004725cb
    call FUN_004fba69                            # 004725d0
    mov ecx, dword ptr [ebp - local_20]          # 004725d5
    {load} xor edx, edx                          # 004725d8
    mov dl, byte ptr [ecx + field_dfe]           # 004725da
    test edx, edx                                # 004725e0
    je.d8 L_00472600                             # 004725e2
    # block 0x004725e4: entered by fall-through of je at 0x004725e2, 5 instruction(s), ends with forward jump to 0x00472651
    mov eax, dword ptr [ebp - local_20]          # 004725e4
    movsx ecx, word ptr [eax + field_d28]        # 004725e7
    imul ecx, ecx, 0x8d                          # 004725ee
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004725f4
    jmp.d8 L_00472651                            # 004725fe
L_00472600:
    # block 0x00472600: entered by je at 0x004725e2, 17 instruction(s), falls into the block at 0x00472651
    movsx edx, word ptr [0x5957b7]               # 00472600
    sub edx, 0x1                                 # 00472607
    imul edx, edx, 0x21                          # 0047260a
    mov eax, dword ptr [ebp - local_8]           # 0047260d
    lea esi, [eax + edx + field_24f]             # 00472610
    mov edi, dword ptr [ebp - local_20]          # 00472617
    add edi, 0xd01                               # 0047261a
    mov ecx, 0x8                                 # 00472620
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00472625
    movsb byte ptr es:[edi], byte ptr [esi]      # 00472627
    mov cx, word ptr [0x5957b7]                  # 00472628
    add cx, 0x1                                  # 0047262f
    mov word ptr [0x5957b7], cx                  # 00472633
    mov edx, dword ptr [ebp - local_20]          # 0047263a
    mov byte ptr [edx + field_d3c], 0x0          # 0047263d
    mov eax, dword ptr [ebp - local_20]          # 00472644
    mov dword ptr [eax + field_d2c], 0x0         # 00472647
L_00472651:
    # block 0x00472651: entered by jmp at 0x004725fe, 1 instruction(s), ends with forward jump to 0x0047269e
    jmp.d8 L_0047269e                            # 00472651
L_00472653:
    # block 0x00472653: entered by jne at 0x004725bc, 5 instruction(s), ends with je to 0x0047269e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00472653
    {load} xor edx, edx                          # 00472656
    mov dl, byte ptr [ecx + field_24e]           # 00472658
    test edx, edx                                # 0047265e
    je.d8 L_0047269e                             # 00472660
    # block 0x00472662: entered by fall-through of je at 0x00472660, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0047269e (forward)
    call dword ptr [0x52a23c]                    # 00472662
    mov ecx, dword ptr [ebp - local_20]          # 00472668
    cmp eax, dword ptr [ecx + field_d40]         # 0047266b
    jb.d8 L_0047269e                             # 00472671
    # block 0x00472673: entered by fall-through of jb at 0x00472671, 12 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0047269e
    mov edx, dword ptr [ebp - local_20]          # 00472673
    {load} xor eax, eax                          # 00472676
    mov al, byte ptr [edx + field_d3c]           # 00472678
    neg eax                                      # 0047267e
    {load} sbb eax, eax                          # 00472680
    inc eax                                      # 00472682
    mov ecx, dword ptr [ebp - local_20]          # 00472683
    mov byte ptr [ecx + field_d3c], al           # 00472686
    call dword ptr [0x52a23c]                    # 0047268c
    add eax, 0x64                                # 00472692
    mov edx, dword ptr [ebp - local_20]          # 00472695
    mov dword ptr [edx + field_d40], eax         # 00472698
L_0047269e:
    # block 0x0047269e: entered by ja at 0x00471dce; jmp at 0x00471e83; jmp at 0x004721af; jmp at 0x004723d1; more, 1 instruction(s), ends with forward jump to 0x00472a2f
    jmp.d32 L_00472a2f                           # 0047269e
L_004726a3:
    # block 0x004726a3: entered by je at 0x0047177b, 13 instruction(s), ends with je to 0x004726f2 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004726a3
    mov eax, dword ptr [ebp - local_20]          # 004726ad
    mov byte ptr [eax + field_d3c], 0x0          # 004726b0
    mov ecx, dword ptr [ebp - local_20]          # 004726b7
    mov byte ptr [ecx + field_d3e], 0x0          # 004726ba
    mov dword ptr [0x5d1a8f], 0x0                # 004726c1
    mov edi, 0x54c4e8                            # 004726cb
    mov esi, dword ptr [ebp - local_8]           # 004726d0
    add esi, 0x66                                # 004726d3
    mov ecx, 0x9                                 # 004726d6
    {load} xor edx, edx                          # 004726db
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004726dd
    je.d8 L_004726f2                             # 004726df
    # block 0x004726e1: entered by fall-through of je at 0x004726df, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004726f2
    mov eax, dword ptr [ebp - local_8]           # 004726e1
    add eax, 0x66                                # 004726e4
    push eax                                     # 004726e7
    mov ecx, 0x5c3a67                            # 004726e8
    call FUN_004fba69                            # 004726ed
L_004726f2:
    # block 0x004726f2: entered by je at 0x004726df, 5 instruction(s), ends with je to 0x004727e7 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004726f2
    {load} xor edx, edx                          # 004726f5
    mov dl, byte ptr [ecx + field_d3f]           # 004726f7
    test edx, edx                                # 004726fd
    je.d32 L_004727e7                            # 004726ff
    # block 0x00472705: entered by fall-through of je at 0x004726ff, 4 instruction(s), ends with je to 0x004727b7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00472705
    movsx ecx, word ptr [eax + field_e3]         # 00472708
    cmp ecx, 0x270f                              # 0047270f
    je.d32 L_004727b7                            # 00472715
    # block 0x0047271b: entered by fall-through of je at 0x00472715, 25 instruction(s), ends with jne to 0x004727a3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047271b
    movsx eax, word ptr [edx + field_e3]         # 0047271e
    mov dword ptr [0x5bb57b], eax                # 00472725
    mov ecx, dword ptr [ebp - local_8]           # 0047272a
    mov dx, word ptr [ecx + field_e5]            # 0047272d
    mov word ptr [0x5bb599], dx                  # 00472734
    mov eax, dword ptr [ebp - local_8]           # 0047273b
    mov cx, word ptr [eax + field_e7]            # 0047273e
    mov word ptr [0x5bb595], cx                  # 00472745
    mov edx, dword ptr [ebp - local_8]           # 0047274c
    mov ax, word ptr [edx + field_e9]            # 0047274f
    mov word ptr [0x5c39ff], ax                  # 00472756
    mov ecx, dword ptr [ebp - local_8]           # 0047275c
    mov edx, dword ptr [ecx + field_eb]          # 0047275f
    mov dword ptr [0x5bb59b], edx                # 00472765
    mov eax, dword ptr [ebp - local_8]           # 0047276b
    mov ecx, dword ptr [eax + field_ef]          # 0047276e
    mov dword ptr [0x5bb59f], ecx                # 00472774
    mov edx, dword ptr [ebp - local_8]           # 0047277a
    mov eax, dword ptr [edx + field_f3]          # 0047277d
    mov dword ptr [0x5bb5a3], eax                # 00472783
    mov ecx, dword ptr [ebp - local_8]           # 00472788
    movsx edx, word ptr [ecx + field_f7]         # 0047278b
    cmp edx, 0x1                                 # 00472792
    jne.d8 L_004727a3                            # 00472795
    # block 0x00472797: entered by fall-through of jne at 0x00472795, 2 instruction(s), ends with forward jump to 0x004727ad
    mov dword ptr [0x5bb1ca], 0x0                # 00472797
    jmp.d8 L_004727ad                            # 004727a1
L_004727a3:
    # block 0x004727a3: entered by jne at 0x00472795, 1 instruction(s), falls into the block at 0x004727ad
    mov dword ptr [0x5bb1ca], 0x1                # 004727a3
L_004727ad:
    # block 0x004727ad: entered by jmp at 0x004727a1, 1 instruction(s), falls into the block at 0x004727b7
    mov dword ptr [0x583999], 0x4                # 004727ad
L_004727b7:
    # block 0x004727b7: entered by je at 0x00472715, 4 instruction(s), ends with je to 0x004727e2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004727b7
    movsx ecx, word ptr [eax + field_f9]         # 004727ba
    cmp ecx, -0x1                                # 004727c1
    je.d8 L_004727e2                             # 004727c4
    # block 0x004727c6: entered by fall-through of je at 0x004727c4, 6 instruction(s), falls into the block at 0x004727e2
    mov edx, dword ptr [ebp - local_8]           # 004727c6
    {load} xor eax, eax                          # 004727c9
    mov al, byte ptr [edx + field_fb]            # 004727cb
    mov ecx, dword ptr [ebp - local_8]           # 004727d1
    movsx edx, word ptr [ecx + field_f9]         # 004727d4
    mov dword ptr [4*edx + 0x585801], eax        # 004727db
L_004727e2:
    # block 0x004727e2: entered by je at 0x004727c4, 1 instruction(s), ends with forward jump to 0x00472a14
    jmp.d32 L_00472a14                           # 004727e2
L_004727e7:
    # block 0x004727e7: entered by je at 0x004726ff, 5 instruction(s), ends with je to 0x004728dc (forward)
    mov eax, dword ptr [ebp - local_20]          # 004727e7
    {load} xor ecx, ecx                          # 004727ea
    mov cl, byte ptr [eax + field_dff]           # 004727ec
    test ecx, ecx                                # 004727f2
    je.d32 L_004728dc                            # 004727f4
    # block 0x004727fa: entered by fall-through of je at 0x004727f4, 4 instruction(s), ends with je to 0x004728ac (forward)
    mov edx, dword ptr [ebp - local_8]           # 004727fa
    movsx eax, word ptr [edx + field_2ec]        # 004727fd
    cmp eax, 0x270f                              # 00472804
    je.d32 L_004728ac                            # 00472809
    # block 0x0047280f: entered by fall-through of je at 0x00472809, 25 instruction(s), ends with jne to 0x00472898 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047280f
    movsx edx, word ptr [ecx + field_2ec]        # 00472812
    mov dword ptr [0x5bb57b], edx                # 00472819
    mov eax, dword ptr [ebp - local_8]           # 0047281f
    mov cx, word ptr [eax + field_2ee]           # 00472822
    mov word ptr [0x5bb599], cx                  # 00472829
    mov edx, dword ptr [ebp - local_8]           # 00472830
    mov ax, word ptr [edx + field_2f0]           # 00472833
    mov word ptr [0x5bb595], ax                  # 0047283a
    mov ecx, dword ptr [ebp - local_8]           # 00472840
    mov dx, word ptr [ecx + field_2f2]           # 00472843
    mov word ptr [0x5c39ff], dx                  # 0047284a
    mov eax, dword ptr [ebp - local_8]           # 00472851
    mov ecx, dword ptr [eax + field_2f4]         # 00472854
    mov dword ptr [0x5bb59b], ecx                # 0047285a
    mov edx, dword ptr [ebp - local_8]           # 00472860
    mov eax, dword ptr [edx + field_2f8]         # 00472863
    mov dword ptr [0x5bb59f], eax                # 00472869
    mov ecx, dword ptr [ebp - local_8]           # 0047286e
    mov edx, dword ptr [ecx + field_2fc]         # 00472871
    mov dword ptr [0x5bb5a3], edx                # 00472877
    mov eax, dword ptr [ebp - local_8]           # 0047287d
    movsx ecx, word ptr [eax + field_300]        # 00472880
    cmp ecx, 0x1                                 # 00472887
    jne.d8 L_00472898                            # 0047288a
    # block 0x0047288c: entered by fall-through of jne at 0x0047288a, 2 instruction(s), ends with forward jump to 0x004728a2
    mov dword ptr [0x5bb1ca], 0x0                # 0047288c
    jmp.d8 L_004728a2                            # 00472896
L_00472898:
    # block 0x00472898: entered by jne at 0x0047288a, 1 instruction(s), falls into the block at 0x004728a2
    mov dword ptr [0x5bb1ca], 0x1                # 00472898
L_004728a2:
    # block 0x004728a2: entered by jmp at 0x00472896, 1 instruction(s), falls into the block at 0x004728ac
    mov dword ptr [0x583999], 0x4                # 004728a2
L_004728ac:
    # block 0x004728ac: entered by je at 0x00472809, 4 instruction(s), ends with je to 0x004728d7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004728ac
    movsx eax, word ptr [edx + field_302]        # 004728af
    cmp eax, -0x1                                # 004728b6
    je.d8 L_004728d7                             # 004728b9
    # block 0x004728bb: entered by fall-through of je at 0x004728b9, 6 instruction(s), falls into the block at 0x004728d7
    mov ecx, dword ptr [ebp - local_8]           # 004728bb
    {load} xor edx, edx                          # 004728be
    mov dl, byte ptr [ecx + field_304]           # 004728c0
    mov eax, dword ptr [ebp - local_8]           # 004728c6
    movsx ecx, word ptr [eax + field_302]        # 004728c9
    mov dword ptr [4*ecx + 0x585801], edx        # 004728d0
L_004728d7:
    # block 0x004728d7: entered by je at 0x004728b9, 1 instruction(s), ends with forward jump to 0x00472a14
    jmp.d32 L_00472a14                           # 004728d7
L_004728dc:
    # block 0x004728dc: entered by je at 0x004727f4, 5 instruction(s), ends with jne to 0x0047292b (forward)
    mov edx, dword ptr [ebp - local_20]          # 004728dc
    {load} xor eax, eax                          # 004728df
    mov al, byte ptr [edx + field_dfe]           # 004728e1
    test eax, eax                                # 004728e7
    jne.d8 L_0047292b                            # 004728e9
    # block 0x004728eb: entered by fall-through of jne at 0x004728e9, 4 instruction(s), ends with je to 0x0047292b (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004728eb
    movsx edx, word ptr [ecx + field_e08]        # 004728ee
    cmp edx, 0x270f                              # 004728f5
    je.d8 L_0047292b                             # 004728fb
    # block 0x004728fd: entered by fall-through of je at 0x004728fb, 4 instruction(s), ends with je to 0x0047292b (forward)
    mov eax, dword ptr [ebp - local_20]          # 004728fd
    movsx ecx, word ptr [eax + field_e08]        # 00472900
    test ecx, ecx                                # 00472907
    je.d8 L_0047292b                             # 00472909
    # block 0x0047290b: entered by fall-through of je at 0x00472909, 4 instruction(s), ends with jne to 0x0047292b (forward)
    mov edx, dword ptr [ebp - local_20]          # 0047290b
    movsx eax, word ptr [edx + field_d32]        # 0047290e
    test eax, eax                                # 00472915
    jne.d8 L_0047292b                            # 00472917
    # block 0x00472919: entered by fall-through of jne at 0x00472917, 4 instruction(s), ends with forward jump to 0x0047294c
    mov ecx, dword ptr [ebp - local_20]          # 00472919
    movsx edx, word ptr [ecx + field_e08]        # 0047291c
    mov dword ptr [0x5bb57b], edx                # 00472923
    jmp.d8 L_0047294c                            # 00472929
L_0047292b:
    # block 0x0047292b: entered by jne at 0x004728e9; je at 0x004728fb; je at 0x00472909; jne at 0x00472917, 4 instruction(s), ends with je to 0x0047294c (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047292b
    movsx ecx, word ptr [eax + field_97]         # 0047292e
    cmp ecx, 0x270f                              # 00472935
    je.d8 L_0047294c                             # 0047293b
    # block 0x0047293d: entered by fall-through of je at 0x0047293b, 3 instruction(s), falls into the block at 0x0047294c
    mov edx, dword ptr [ebp - local_8]           # 0047293d
    movsx eax, word ptr [edx + field_97]         # 00472940
    mov dword ptr [0x5bb57b], eax                # 00472947
L_0047294c:
    # block 0x0047294c: entered by jmp at 0x00472929; je at 0x0047293b, 2 instruction(s), ends with je to 0x004729e9 (forward)
    cmp dword ptr [0x5bb57b], 0x270f             # 0047294c
    je.d32 L_004729e9                            # 00472956
    # block 0x0047295c: entered by fall-through of je at 0x00472956, 22 instruction(s), ends with jne to 0x004729d5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047295c
    mov dx, word ptr [ecx + field_99]            # 0047295f
    mov word ptr [0x5bb599], dx                  # 00472966
    mov eax, dword ptr [ebp - local_8]           # 0047296d
    mov cx, word ptr [eax + field_9b]            # 00472970
    mov word ptr [0x5bb595], cx                  # 00472977
    mov edx, dword ptr [ebp - local_8]           # 0047297e
    mov ax, word ptr [edx + field_9d]            # 00472981
    mov word ptr [0x5c39ff], ax                  # 00472988
    mov ecx, dword ptr [ebp - local_8]           # 0047298e
    mov edx, dword ptr [ecx + field_9f]          # 00472991
    mov dword ptr [0x5bb59b], edx                # 00472997
    mov eax, dword ptr [ebp - local_8]           # 0047299d
    mov ecx, dword ptr [eax + field_a3]          # 004729a0
    mov dword ptr [0x5bb59f], ecx                # 004729a6
    mov edx, dword ptr [ebp - local_8]           # 004729ac
    mov eax, dword ptr [edx + field_a7]          # 004729af
    mov dword ptr [0x5bb5a3], eax                # 004729b5
    mov ecx, dword ptr [ebp - local_8]           # 004729ba
    movsx edx, word ptr [ecx + field_ab]         # 004729bd
    cmp edx, 0x1                                 # 004729c4
    jne.d8 L_004729d5                            # 004729c7
    # block 0x004729c9: entered by fall-through of jne at 0x004729c7, 2 instruction(s), ends with forward jump to 0x004729df
    mov dword ptr [0x5bb1ca], 0x0                # 004729c9
    jmp.d8 L_004729df                            # 004729d3
L_004729d5:
    # block 0x004729d5: entered by jne at 0x004729c7, 1 instruction(s), falls into the block at 0x004729df
    mov dword ptr [0x5bb1ca], 0x1                # 004729d5
L_004729df:
    # block 0x004729df: entered by jmp at 0x004729d3, 1 instruction(s), falls into the block at 0x004729e9
    mov dword ptr [0x583999], 0x4                # 004729df
L_004729e9:
    # block 0x004729e9: entered by je at 0x00472956, 4 instruction(s), ends with je to 0x00472a14 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004729e9
    movsx ecx, word ptr [eax + field_ad]         # 004729ec
    cmp ecx, -0x1                                # 004729f3
    je.d8 L_00472a14                             # 004729f6
    # block 0x004729f8: entered by fall-through of je at 0x004729f6, 6 instruction(s), falls into the block at 0x00472a14
    mov edx, dword ptr [ebp - local_8]           # 004729f8
    {load} xor eax, eax                          # 004729fb
    mov al, byte ptr [edx + field_af]            # 004729fd
    mov ecx, dword ptr [ebp - local_8]           # 00472a03
    movsx edx, word ptr [ecx + field_ad]         # 00472a06
    mov dword ptr [4*edx + 0x585801], eax        # 00472a0d
L_00472a14:
    # block 0x00472a14: entered by jmp at 0x004727e2; jmp at 0x004728d7; je at 0x004729f6, 7 instruction(s), calls FUN_0042ba3a, FUN_00470ddc, falls into the block at 0x00472a2f
    mov eax, dword ptr [ebp - local_20]          # 00472a14
    mov cx, word ptr [eax + field_d28]           # 00472a17
    push ecx                                     # 00472a1e
    call FUN_0042ba3a                            # 00472a1f
    add esp, 0x4                                 # 00472a24
    mov ecx, dword ptr [ebp - local_20]          # 00472a27
    call FUN_00470ddc                            # 00472a2a
L_00472a2f:
    # block 0x00472a2f: entered by jmp at 0x00471781; jmp at 0x00471db9; jmp at 0x0047269e, 6 instruction(s), ends with ret 0x8
    pop edi                                      # 00472a2f
    pop esi                                      # 00472a30
    pop ebx                                      # 00472a31
    {load} mov esp, ebp                          # 00472a32
    pop ebp                                      # 00472a34
    ret 0x8                                      # 00472a35

# --- data items (not part of the function) -------------------------
.org 0x00472a38 - 0x401000
SWTAB_00472a38:  # 5 case address(es)
    .long L_00471dde - .text + 0x401000
    .long L_004723d6 - .text + 0x401000
    .long L_0047269e - .text + 0x401000
    .long L_00472420 - .text + 0x401000
    .long L_0047259f - .text + 0x401000
.set SWTAB_00472a38_VA, SWTAB_00472a38 - .text + 0x401000

