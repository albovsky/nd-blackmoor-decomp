# FUN_0044ffa3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044ffa3
# extent:       0x0044ffa3-0x00450634 (1681 code bytes)
# span:         0x0044ffa3-0x00450678 (code 1681, tables 68, padding 0)
# sha256:       5416aaa47e1f4826d45500c2c50f8da06fe464443de0bc10323bfc2afa7bef1b
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044ffa3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       17 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 5 more
# fields:       [eax + n] field_4, field_8, field_c, field_24, field_100, field_104, field_118, field_11c, field_120, field_124, field_138, field_148 and 14 more; [ecx + n] field_4, field_8, field_c, field_20, field_c8, field_e8, field_ec, field_100, field_104, field_118, field_11c, field_120 and 17 more; [edx + n] field_4, field_8, field_c, field_28, field_fc, field_100, field_104, field_118, field_11c, field_120, field_124, field_13c and 14 more
# callees:      calls KERNEL32.dll!GetTickCount, USER32.dll!GetAsyncKeyState, FUN_0050cd50, FUN_004542b5, FUN_0050ce04, FUN_00450678, FUN_004511d2, FUN_0045150e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 426 instruction(s), 27 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_c8, 0xc8  # offset +0xc8
.equ field_e8, 0xe8  # offset +0xe8
.equ field_ec, 0xec  # offset +0xec
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_118, 0x118  # offset +0x118
.equ field_11c, 0x11c  # offset +0x11c
.equ field_120, 0x120  # offset +0x120
.equ field_124, 0x124  # offset +0x124
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_140, 0x140  # offset +0x140
.equ field_144, 0x144  # offset +0x144
.equ field_148, 0x148  # offset +0x148
.equ field_14c, 0x14c  # offset +0x14c
.equ field_150, 0x150  # offset +0x150
.equ field_154, 0x154  # offset +0x154
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c
.equ field_160, 0x160  # offset +0x160
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_174, 0x174  # offset +0x174
.equ field_178, 0x178  # offset +0x178
.equ field_17c, 0x17c  # offset +0x17c
.equ field_180, 0x180  # offset +0x180
.equ field_184, 0x184  # offset +0x184
.equ field_4e4, 0x4e4  # offset +0x4e4
.equ field_4fc, 0x4fc  # offset +0x4fc
.equ field_51c, 0x51c  # offset +0x51c

# --- external targets -----------------------------------------------
.set FUN_00450678, .text + (0x00450678 - 0x401000)
.set FUN_004511d2, .text + (0x004511d2 - 0x401000)
.set FUN_0045150e, .text + (0x0045150e - 0x401000)
.set FUN_004542b5, .text + (0x004542b5 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x0044ffa3 - 0x401000
.globl FUN_0044ffa3
FUN_0044ffa3:
    # block 0x0044ffa3: entry, 7 instruction(s), ends with je to 0x0044ffc8 (forward)
    push ebp                                     # 0044ffa3
    {load} mov ebp, esp                          # 0044ffa4
    sub esp, 0x44                                # 0044ffa6
    mov dword ptr [ebp - local_24], ecx          # 0044ffa9
    mov eax, dword ptr [ebp - local_24]          # 0044ffac
    cmp dword ptr [eax + field_180], 0x1         # 0044ffaf
    je.d8 L_0044ffc8                             # 0044ffb6
    # block 0x0044ffb8: entered by fall-through of je at 0x0044ffb6, 3 instruction(s), ends with jne to 0x00450084 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0044ffb8
    cmp dword ptr [ecx + field_180], 0x2         # 0044ffbb
    jne.d32 L_00450084                           # 0044ffc2
L_0044ffc8:
    # block 0x0044ffc8: entered by je at 0x0044ffb6; fall-through of jne at 0x0044ffc2, 43 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00450084
    call dword ptr [0x52a23c]                    # 0044ffc8
    mov edx, dword ptr [ebp - local_24]          # 0044ffce
    mov dword ptr [edx + field_4e4], eax         # 0044ffd1
    mov eax, dword ptr [ebp - local_24]          # 0044ffd7
    mov ecx, dword ptr [ebp - local_24]          # 0044ffda
    mov edx, dword ptr [eax + field_4e4]         # 0044ffdd
    sub edx, dword ptr [ecx + field_178]         # 0044ffe3
    mov eax, dword ptr [ebp - local_24]          # 0044ffe9
    mov dword ptr [eax + field_17c], edx         # 0044ffec
    mov ecx, dword ptr [ebp - local_24]          # 0044fff2
    mov edx, dword ptr [ebp - local_24]          # 0044fff5
    mov eax, dword ptr [edx + field_4e4]         # 0044fff8
    mov dword ptr [ecx + field_178], eax         # 0044fffe
    mov ecx, dword ptr [ebp - local_24]          # 00450004
    mov edx, dword ptr [ebp - local_24]          # 00450007
    fld dword ptr [ecx + field_e8]               # 0045000a
    fmul dword ptr [edx + field_fc]              # 00450010
    mov eax, dword ptr [ebp - local_24]          # 00450016
    mov ecx, dword ptr [eax + field_17c]         # 00450019
    mov dword ptr [ebp - local_2c], ecx          # 0045001f
    mov dword ptr [ebp - local_28], 0x0          # 00450022
    fild qword ptr [ebp - local_2c]              # 00450029
    fstp dword ptr [ebp - local_30]              # 0045002c
    fmul dword ptr [ebp - local_30]              # 0045002f
    mov edx, dword ptr [ebp - local_24]          # 00450032
    fadd dword ptr [edx + field_100]             # 00450035
    mov eax, dword ptr [ebp - local_24]          # 0045003b
    fstp dword ptr [eax + field_100]             # 0045003e
    mov ecx, dword ptr [ebp - local_24]          # 00450044
    mov edx, dword ptr [ebp - local_24]          # 00450047
    fld dword ptr [ecx + field_ec]               # 0045004a
    fmul dword ptr [edx + field_fc]              # 00450050
    mov eax, dword ptr [ebp - local_24]          # 00450056
    mov ecx, dword ptr [eax + field_17c]         # 00450059
    mov dword ptr [ebp - local_38], ecx          # 0045005f
    mov dword ptr [ebp - local_34], 0x0          # 00450062
    fild qword ptr [ebp - local_38]              # 00450069
    fstp dword ptr [ebp - local_3c]              # 0045006c
    fmul dword ptr [ebp - local_3c]              # 0045006f
    mov edx, dword ptr [ebp - local_24]          # 00450072
    fsubr dword ptr [edx + field_104]            # 00450075
    mov eax, dword ptr [ebp - local_24]          # 0045007b
    fstp dword ptr [eax + field_104]             # 0045007e
L_00450084:
    # block 0x00450084: entered by jne at 0x0044ffc2, 5 instruction(s), ends with je to 0x004500af (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00450084
    mov edx, dword ptr [ecx + field_180]         # 00450087
    mov dword ptr [ebp - local_40], edx          # 0045008d
    cmp dword ptr [ebp - local_40], 0x0          # 00450090
    je.d8 L_004500af                             # 00450094
    # block 0x00450096: entered by fall-through of je at 0x00450094, 2 instruction(s), ends with je to 0x00450268 (forward)
    cmp dword ptr [ebp - local_40], 0x1          # 00450096
    je.d32 L_00450268                            # 0045009a
    # block 0x004500a0: entered by fall-through of je at 0x0045009a, 2 instruction(s), ends with je to 0x004504ed (forward)
    cmp dword ptr [ebp - local_40], 0x2          # 004500a0
    je.d32 L_004504ed                            # 004500a4
    # block 0x004500aa: entered by fall-through of je at 0x004500a4, 1 instruction(s), ends with forward jump to 0x00450630
    jmp.d32 L_00450630                           # 004500aa
L_004500af:
    # block 0x004500af: entered by je at 0x00450094, 50 instruction(s), ends with jne to 0x004501ba (forward)
    mov eax, dword ptr [ebp - local_24]          # 004500af
    add eax, 0x118                               # 004500b2
    mov ecx, dword ptr [ebp - local_24]          # 004500b7
    add ecx, 0x150                               # 004500ba
    mov edx, dword ptr [eax]                     # 004500c0
    mov dword ptr [ecx], edx                     # 004500c2
    mov edx, dword ptr [eax + field_4]           # 004500c4
    mov dword ptr [ecx + field_4], edx           # 004500c7
    mov edx, dword ptr [eax + field_8]           # 004500ca
    mov dword ptr [ecx + field_8], edx           # 004500cd
    mov eax, dword ptr [eax + field_c]           # 004500d0
    mov dword ptr [ecx + field_c], eax           # 004500d3
    mov ecx, dword ptr [ebp - local_24]          # 004500d6
    mov edx, dword ptr [ecx + field_c8]          # 004500d9
    mov eax, dword ptr [ebp - local_24]          # 004500df
    add edx, dword ptr [eax + field_174]         # 004500e2
    mov ecx, dword ptr [ebp - local_24]          # 004500e8
    mov dword ptr [ecx + field_118], edx         # 004500eb
    mov edx, dword ptr [ebp - local_24]          # 004500f1
    mov eax, dword ptr [edx + field_118]         # 004500f4
    mov ecx, dword ptr [ebp - local_24]          # 004500fa
    mov edx, dword ptr [ecx + field_164]         # 004500fd
    lea eax, [eax + edx - field_minus_1]         # 00450103
    mov ecx, dword ptr [ebp - local_24]          # 00450107
    mov dword ptr [ecx + field_120], eax         # 0045010a
    mov edx, dword ptr [ebp - local_24]          # 00450110
    mov eax, dword ptr [edx + field_118]         # 00450113
    mov ecx, dword ptr [ebp - local_24]          # 00450119
    add eax, dword ptr [ecx + field_16c]         # 0045011c
    mov edx, dword ptr [ebp - local_24]          # 00450122
    mov dword ptr [edx + field_148], eax         # 00450125
    mov eax, dword ptr [ebp - local_24]          # 0045012b
    mov ecx, dword ptr [eax + field_11c]         # 0045012e
    mov edx, dword ptr [ebp - local_24]          # 00450134
    add ecx, dword ptr [edx + field_170]         # 00450137
    mov eax, dword ptr [ebp - local_24]          # 0045013d
    mov dword ptr [eax + field_14c], ecx         # 00450140
    mov ecx, dword ptr [ebp - local_24]          # 00450146
    fild dword ptr [ecx + field_118]             # 00450149
    mov edx, dword ptr [ebp - local_24]          # 0045014f
    fstp dword ptr [edx + field_100]             # 00450152
    mov eax, dword ptr [ebp - local_24]          # 00450158
    fild dword ptr [eax + field_11c]             # 0045015b
    mov ecx, dword ptr [ebp - local_24]          # 00450161
    fstp dword ptr [ecx + field_104]             # 00450164
    mov edx, dword ptr [ebp - local_24]          # 0045016a
    mov eax, dword ptr [ebp - local_24]          # 0045016d
    mov ecx, dword ptr [edx + field_118]         # 00450170
    cmp ecx, dword ptr [eax + field_150]         # 00450176
    jne.d8 L_004501ba                            # 0045017c
    # block 0x0045017e: entered by fall-through of jne at 0x0045017c, 5 instruction(s), ends with jne to 0x004501ba (forward)
    mov edx, dword ptr [ebp - local_24]          # 0045017e
    mov eax, dword ptr [ebp - local_24]          # 00450181
    mov ecx, dword ptr [edx + field_120]         # 00450184
    cmp ecx, dword ptr [eax + field_158]         # 0045018a
    jne.d8 L_004501ba                            # 00450190
    # block 0x00450192: entered by fall-through of jne at 0x00450190, 5 instruction(s), ends with jne to 0x004501ba (forward)
    mov edx, dword ptr [ebp - local_24]          # 00450192
    mov eax, dword ptr [ebp - local_24]          # 00450195
    mov ecx, dword ptr [edx + field_11c]         # 00450198
    cmp ecx, dword ptr [eax + field_154]         # 0045019e
    jne.d8 L_004501ba                            # 004501a4
    # block 0x004501a6: entered by fall-through of jne at 0x004501a4, 5 instruction(s), ends with je to 0x004501c7 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004501a6
    mov eax, dword ptr [ebp - local_24]          # 004501a9
    mov ecx, dword ptr [edx + field_124]         # 004501ac
    cmp ecx, dword ptr [eax + field_15c]         # 004501b2
    je.d8 L_004501c7                             # 004501b8
L_004501ba:
    # block 0x004501ba: entered by jne at 0x0045017c; jne at 0x00450190; jne at 0x004501a4; fall-through of je at 0x004501b8, 2 instruction(s), falls into the block at 0x004501c7
    mov edx, dword ptr [ebp - local_24]          # 004501ba
    mov dword ptr [edx + field_160], 0x1         # 004501bd
L_004501c7:
    # block 0x004501c7: entered by je at 0x004501b8, 8 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x00450263 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004501c7
    mov ecx, dword ptr [eax + field_4fc]         # 004501ca
    push ecx                                     # 004501d0
    call dword ptr [0x52a4b4]                    # 004501d1
    movsx edx, ax                                # 004501d7
    and edx, 0x8000                              # 004501da
    test edx, edx                                # 004501e0
    je.d8 L_00450263                             # 004501e2
    # block 0x004501e4: entered by fall-through of je at 0x004501e2, 8 instruction(s), calls FUN_0050cd50, ends with jns to 0x0045020a (forward)
    mov eax, dword ptr [ebp - local_24]          # 004501e4
    mov ecx, dword ptr [eax + field_174]         # 004501e7
    mov edx, dword ptr [ebp - local_24]          # 004501ed
    add ecx, dword ptr [edx + field_16c]         # 004501f0
    mov dword ptr [ebp - local_8], ecx           # 004501f6
    call FUN_0050cd50                            # 004501f9
    and eax, 0x80000001                          # 004501fe
    jns.d8 L_0045020a                            # 00450203
    # block 0x00450205: entered by fall-through of jns at 0x00450203, 3 instruction(s), falls into the block at 0x0045020a
    dec eax                                      # 00450205
    or eax, -0x2                                 # 00450206
    inc eax                                      # 00450209
L_0045020a:
    # block 0x0045020a: entered by jns at 0x00450203, 24 instruction(s), calls FUN_004542b5, KERNEL32.dll!GetTickCount, falls into the block at 0x00450263
    mov dword ptr [ebp - local_4], eax           # 0045020a
    mov eax, dword ptr [ebp - local_8]           # 0045020d
    imul eax, eax, 0x18                          # 00450210
    mov ecx, dword ptr [ebp - local_24]          # 00450213
    mov edx, dword ptr [ecx + field_51c]         # 00450216
    {load} add edx, eax                          # 0045021c
    mov eax, dword ptr [ebp - local_4]           # 0045021e
    imul eax, eax, 0xc                           # 00450221
    {load} add edx, eax                          # 00450224
    mov ecx, dword ptr [ebp - local_24]          # 00450226
    add ecx, 0xe8                                # 00450229
    mov eax, dword ptr [edx]                     # 0045022f
    mov dword ptr [ecx], eax                     # 00450231
    mov eax, dword ptr [edx + field_4]           # 00450233
    mov dword ptr [ecx + field_4], eax           # 00450236
    mov edx, dword ptr [edx + field_8]           # 00450239
    mov dword ptr [ecx + field_8], edx           # 0045023c
    mov ecx, dword ptr [ebp - local_24]          # 0045023f
    call FUN_004542b5                            # 00450242
    mov eax, dword ptr [ebp - local_24]          # 00450247
    mov dword ptr [eax + field_180], 0x1         # 0045024a
    call dword ptr [0x52a23c]                    # 00450254
    mov ecx, dword ptr [ebp - local_24]          # 0045025a
    mov dword ptr [ecx + field_178], eax         # 0045025d
L_00450263:
    # block 0x00450263: entered by je at 0x004501e2, 1 instruction(s), ends with forward jump to 0x00450630
    jmp.d32 L_00450630                           # 00450263
L_00450268:
    # block 0x00450268: entered by je at 0x0045009a, 53 instruction(s), calls FUN_0050ce04, FUN_00450678, ends with ja to 0x00450391 (forward)
    mov edx, dword ptr [ebp - local_24]          # 00450268
    add edx, 0x118                               # 0045026b
    mov eax, dword ptr [ebp - local_24]          # 00450271
    add eax, 0x150                               # 00450274
    mov ecx, dword ptr [edx]                     # 00450279
    mov dword ptr [eax], ecx                     # 0045027b
    mov ecx, dword ptr [edx + field_4]           # 0045027d
    mov dword ptr [eax + field_4], ecx           # 00450280
    mov ecx, dword ptr [edx + field_8]           # 00450283
    mov dword ptr [eax + field_8], ecx           # 00450286
    mov edx, dword ptr [edx + field_c]           # 00450289
    mov dword ptr [eax + field_c], edx           # 0045028c
    mov eax, dword ptr [ebp - local_24]          # 0045028f
    fld dword ptr [eax + field_100]              # 00450292
    call FUN_0050ce04                            # 00450298
    mov dword ptr [ebp - local_18], eax          # 0045029d
    mov ecx, dword ptr [ebp - local_24]          # 004502a0
    fld dword ptr [ecx + field_104]              # 004502a3
    call FUN_0050ce04                            # 004502a9
    mov dword ptr [ebp - local_14], eax          # 004502ae
    mov edx, dword ptr [ebp - local_24]          # 004502b1
    mov eax, dword ptr [edx + field_164]         # 004502b4
    mov ecx, dword ptr [ebp - local_18]          # 004502ba
    lea edx, [ecx + eax - field_minus_1]         # 004502bd
    mov dword ptr [ebp - local_10], edx          # 004502c1
    mov eax, dword ptr [ebp - local_24]          # 004502c4
    mov ecx, dword ptr [eax + field_168]         # 004502c7
    mov edx, dword ptr [ebp - local_14]          # 004502cd
    lea eax, [edx + ecx - field_minus_1]         # 004502d0
    mov dword ptr [ebp - local_c], eax           # 004502d4
    mov ecx, dword ptr [ebp - local_24]          # 004502d7
    fld dword ptr [ecx + field_100]              # 004502da
    call FUN_0050ce04                            # 004502e0
    mov edx, dword ptr [ebp - local_24]          # 004502e5
    add eax, dword ptr [edx + field_16c]         # 004502e8
    mov dword ptr [ebp - local_20], eax          # 004502ee
    mov eax, dword ptr [ebp - local_24]          # 004502f1
    fld dword ptr [eax + field_104]              # 004502f4
    call FUN_0050ce04                            # 004502fa
    mov ecx, dword ptr [ebp - local_24]          # 004502ff
    add eax, dword ptr [ecx + field_170]         # 00450302
    mov dword ptr [ebp - local_1c], eax          # 00450308
    lea edx, [ebp - local_20]                    # 0045030b
    push edx                                     # 0045030e
    lea eax, [ebp - local_18]                    # 0045030f
    push eax                                     # 00450312
    mov ecx, dword ptr [ebp - local_24]          # 00450313
    call FUN_00450678                            # 00450316
    mov ecx, dword ptr [ebp - local_24]          # 0045031b
    mov edx, dword ptr [ecx + field_184]         # 0045031e
    mov dword ptr [ebp - local_44], edx          # 00450324
    cmp dword ptr [ebp - local_44], 0x10         # 00450327
    ja.d8 L_00450391                             # 0045032b
    # block 0x0045032d: entered by fall-through of ja at 0x0045032b, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x450634]
    mov eax, dword ptr [ebp - local_44]          # 0045032d
    jmp dword ptr [4*eax + SWTAB_00450634_VA]    # 00450330
L_00450337:
    # block 0x00450337: entered by switch case, 4 instruction(s), ends with forward jump to 0x00450391
    fild dword ptr [ebp - local_14]              # 00450337
    mov ecx, dword ptr [ebp - local_24]          # 0045033a
    fstp dword ptr [ecx + field_104]             # 0045033d
    jmp.d8 L_00450391                            # 00450343
L_00450345:
    # block 0x00450345: entered by switch case, 4 instruction(s), ends with forward jump to 0x00450391
    fild dword ptr [ebp - local_18]              # 00450345
    mov edx, dword ptr [ebp - local_24]          # 00450348
    fstp dword ptr [edx + field_100]             # 0045034b
    jmp.d8 L_00450391                            # 00450351
L_00450353:
    # block 0x00450353: entered by switch case, 7 instruction(s), ends with forward jump to 0x00450391
    fild dword ptr [ebp - local_18]              # 00450353
    mov eax, dword ptr [ebp - local_24]          # 00450356
    fstp dword ptr [eax + field_100]             # 00450359
    fild dword ptr [ebp - local_14]              # 0045035f
    mov ecx, dword ptr [ebp - local_24]          # 00450362
    fstp dword ptr [ecx + field_104]             # 00450365
    jmp.d8 L_00450391                            # 0045036b
L_0045036d:
    # block 0x0045036d: entered by switch case, 8 instruction(s), falls into the block at 0x00450391
    mov edx, dword ptr [ebp - local_24]          # 0045036d
    fild dword ptr [edx + field_118]             # 00450370
    mov eax, dword ptr [ebp - local_24]          # 00450376
    fstp dword ptr [eax + field_100]             # 00450379
    mov ecx, dword ptr [ebp - local_24]          # 0045037f
    fild dword ptr [ecx + field_11c]             # 00450382
    mov edx, dword ptr [ebp - local_24]          # 00450388
    fstp dword ptr [edx + field_104]             # 0045038b
L_00450391:
    # block 0x00450391: entered by ja at 0x0045032b; jmp at 0x00450343; jmp at 0x00450351; jmp at 0x0045036b; switch case, 3 instruction(s), ends with je to 0x004503e9 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00450391
    cmp dword ptr [eax + field_184], 0xf         # 00450394
    je.d8 L_004503e9                             # 0045039b
    # block 0x0045039d: entered by fall-through of je at 0x0045039b, 3 instruction(s), ends with je to 0x004503e9 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0045039d
    cmp dword ptr [ecx + field_184], -0x1        # 004503a0
    je.d8 L_004503e9                             # 004503a7
    # block 0x004503a9: entered by fall-through of je at 0x004503a7, 3 instruction(s), ends with je to 0x004503e9 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004503a9
    cmp dword ptr [edx + field_184], 0x10        # 004503ac
    je.d8 L_004503e9                             # 004503b3
    # block 0x004503b5: entered by fall-through of je at 0x004503b3, 15 instruction(s), falls into the block at 0x004503e9
    mov eax, dword ptr [ebp - local_24]          # 004503b5
    add eax, 0x118                               # 004503b8
    mov ecx, dword ptr [ebp - local_18]          # 004503bd
    mov dword ptr [eax], ecx                     # 004503c0
    mov edx, dword ptr [ebp - local_14]          # 004503c2
    mov dword ptr [eax + field_4], edx           # 004503c5
    mov ecx, dword ptr [ebp - local_10]          # 004503c8
    mov dword ptr [eax + field_8], ecx           # 004503cb
    mov edx, dword ptr [ebp - local_c]           # 004503ce
    mov dword ptr [eax + field_c], edx           # 004503d1
    mov eax, dword ptr [ebp - local_24]          # 004503d4
    mov ecx, dword ptr [ebp - local_20]          # 004503d7
    mov dword ptr [eax + field_148], ecx         # 004503da
    mov edx, dword ptr [ebp - local_1c]          # 004503e0
    mov dword ptr [eax + field_14c], edx         # 004503e3
L_004503e9:
    # block 0x004503e9: entered by je at 0x0045039b; je at 0x004503a7; je at 0x004503b3, 7 instruction(s), calls FUN_004511d2, ends with jne to 0x00450441 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004503e9
    call FUN_004511d2                            # 004503ec
    mov eax, dword ptr [ebp - local_24]          # 004503f1
    mov ecx, dword ptr [ebp - local_24]          # 004503f4
    mov edx, dword ptr [eax + field_118]         # 004503f7
    cmp edx, dword ptr [ecx + field_150]         # 004503fd
    jne.d8 L_00450441                            # 00450403
    # block 0x00450405: entered by fall-through of jne at 0x00450403, 5 instruction(s), ends with jne to 0x00450441 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00450405
    mov ecx, dword ptr [ebp - local_24]          # 00450408
    mov edx, dword ptr [eax + field_120]         # 0045040b
    cmp edx, dword ptr [ecx + field_158]         # 00450411
    jne.d8 L_00450441                            # 00450417
    # block 0x00450419: entered by fall-through of jne at 0x00450417, 5 instruction(s), ends with jne to 0x00450441 (forward)
    mov eax, dword ptr [ebp - local_24]          # 00450419
    mov ecx, dword ptr [ebp - local_24]          # 0045041c
    mov edx, dword ptr [eax + field_11c]         # 0045041f
    cmp edx, dword ptr [ecx + field_154]         # 00450425
    jne.d8 L_00450441                            # 0045042b
    # block 0x0045042d: entered by fall-through of jne at 0x0045042b, 5 instruction(s), ends with je to 0x0045044e (forward)
    mov eax, dword ptr [ebp - local_24]          # 0045042d
    mov ecx, dword ptr [ebp - local_24]          # 00450430
    mov edx, dword ptr [eax + field_124]         # 00450433
    cmp edx, dword ptr [ecx + field_15c]         # 00450439
    je.d8 L_0045044e                             # 0045043f
L_00450441:
    # block 0x00450441: entered by jne at 0x00450403; jne at 0x00450417; jne at 0x0045042b; fall-through of je at 0x0045043f, 2 instruction(s), falls into the block at 0x0045044e
    mov eax, dword ptr [ebp - local_24]          # 00450441
    mov dword ptr [eax + field_160], 0x1         # 00450444
L_0045044e:
    # block 0x0045044e: entered by je at 0x0045043f, 3 instruction(s), ends with jne to 0x004504e8 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0045044e
    cmp dword ptr [ecx + field_184], -0x1        # 00450451
    jne.d32 L_004504e8                           # 00450458
    # block 0x0045045e: entered by fall-through of jne at 0x00450458, 36 instruction(s), falls into the block at 0x004504e8
    mov edx, dword ptr [ebp - local_24]          # 0045045e
    mov dword ptr [edx + field_180], 0x2         # 00450461
    mov eax, dword ptr [ebp - local_24]          # 0045046b
    mov dword ptr [eax + field_24], 0x1          # 0045046e
    mov ecx, dword ptr [ebp - local_24]          # 00450475
    add ecx, 0x118                               # 00450478
    mov edx, dword ptr [ebp - local_24]          # 0045047e
    add edx, 0x138                               # 00450481
    mov eax, dword ptr [ecx]                     # 00450487
    mov dword ptr [edx], eax                     # 00450489
    mov eax, dword ptr [ecx + field_4]           # 0045048b
    mov dword ptr [edx + field_4], eax           # 0045048e
    mov eax, dword ptr [ecx + field_8]           # 00450491
    mov dword ptr [edx + field_8], eax           # 00450494
    mov ecx, dword ptr [ecx + field_c]           # 00450497
    mov dword ptr [edx + field_c], ecx           # 0045049a
    mov edx, dword ptr [ebp - local_24]          # 0045049d
    add edx, 0x108                               # 004504a0
    mov eax, dword ptr [ebp - local_24]          # 004504a6
    add eax, 0x128                               # 004504a9
    mov ecx, dword ptr [edx]                     # 004504ae
    mov dword ptr [eax], ecx                     # 004504b0
    mov ecx, dword ptr [edx + field_4]           # 004504b2
    mov dword ptr [eax + field_4], ecx           # 004504b5
    mov ecx, dword ptr [edx + field_8]           # 004504b8
    mov dword ptr [eax + field_8], ecx           # 004504bb
    mov edx, dword ptr [edx + field_c]           # 004504be
    mov dword ptr [eax + field_c], edx           # 004504c1
    mov eax, dword ptr [ebp - local_24]          # 004504c4
    fild dword ptr [eax + field_138]             # 004504c7
    mov ecx, dword ptr [ebp - local_24]          # 004504cd
    fstp dword ptr [ecx + field_100]             # 004504d0
    mov edx, dword ptr [ebp - local_24]          # 004504d6
    fild dword ptr [edx + field_13c]             # 004504d9
    mov eax, dword ptr [ebp - local_24]          # 004504df
    fstp dword ptr [eax + field_104]             # 004504e2
L_004504e8:
    # block 0x004504e8: entered by jne at 0x00450458, 1 instruction(s), ends with forward jump to 0x00450630
    jmp.d32 L_00450630                           # 004504e8
L_004504ed:
    # block 0x004504ed: entered by je at 0x004500a4, 36 instruction(s), calls FUN_0050ce04, FUN_0045150e, ends with je to 0x00450583 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004504ed
    add ecx, 0x138                               # 004504f0
    mov edx, dword ptr [ebp - local_24]          # 004504f6
    add edx, 0x150                               # 004504f9
    mov eax, dword ptr [ecx]                     # 004504ff
    mov dword ptr [edx], eax                     # 00450501
    mov eax, dword ptr [ecx + field_4]           # 00450503
    mov dword ptr [edx + field_4], eax           # 00450506
    mov eax, dword ptr [ecx + field_8]           # 00450509
    mov dword ptr [edx + field_8], eax           # 0045050c
    mov ecx, dword ptr [ecx + field_c]           # 0045050f
    mov dword ptr [edx + field_c], ecx           # 00450512
    mov edx, dword ptr [ebp - local_24]          # 00450515
    fld dword ptr [edx + field_100]              # 00450518
    call FUN_0050ce04                            # 0045051e
    mov dword ptr [ebp - local_18], eax          # 00450523
    mov eax, dword ptr [ebp - local_24]          # 00450526
    fld dword ptr [eax + field_104]              # 00450529
    call FUN_0050ce04                            # 0045052f
    mov dword ptr [ebp - local_14], eax          # 00450534
    mov ecx, dword ptr [ebp - local_24]          # 00450537
    mov edx, dword ptr [ecx + field_164]         # 0045053a
    mov eax, dword ptr [ebp - local_18]          # 00450540
    lea ecx, [eax + edx - field_minus_1]         # 00450543
    mov dword ptr [ebp - local_10], ecx          # 00450547
    mov edx, dword ptr [ebp - local_24]          # 0045054a
    mov eax, dword ptr [edx + field_168]         # 0045054d
    mov ecx, dword ptr [ebp - local_14]          # 00450553
    lea edx, [ecx + eax - field_minus_1]         # 00450556
    mov dword ptr [ebp - local_c], edx           # 0045055a
    lea eax, [ebp - local_18]                    # 0045055d
    push eax                                     # 00450560
    mov ecx, dword ptr [ebp - local_24]          # 00450561
    call FUN_0045150e                            # 00450564
    test eax, eax                                # 00450569
    je.d8 L_00450583                             # 0045056b
    # block 0x0045056d: entered by fall-through of je at 0x0045056b, 5 instruction(s), ends with forward jump to 0x004505a7
    mov ecx, dword ptr [ebp - local_24]          # 0045056d
    mov dword ptr [ecx + field_20], 0x1          # 00450570
    mov edx, dword ptr [ebp - local_24]          # 00450577
    mov dword ptr [edx + field_28], 0x1          # 0045057a
    jmp.d8 L_004505a7                            # 00450581
L_00450583:
    # block 0x00450583: entered by je at 0x0045056b, 8 instruction(s), falls into the block at 0x004505a7
    mov eax, dword ptr [ebp - local_24]          # 00450583
    fild dword ptr [eax + field_138]             # 00450586
    mov ecx, dword ptr [ebp - local_24]          # 0045058c
    fstp dword ptr [ecx + field_100]             # 0045058f
    mov edx, dword ptr [ebp - local_24]          # 00450595
    fild dword ptr [edx + field_13c]             # 00450598
    mov eax, dword ptr [ebp - local_24]          # 0045059e
    fstp dword ptr [eax + field_104]             # 004505a1
L_004505a7:
    # block 0x004505a7: entered by jmp at 0x00450581, 5 instruction(s), ends with jne to 0x004505f7 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004505a7
    mov edx, dword ptr [ebp - local_24]          # 004505aa
    mov eax, dword ptr [ecx + field_138]         # 004505ad
    cmp eax, dword ptr [edx + field_150]         # 004505b3
    jne.d8 L_004505f7                            # 004505b9
    # block 0x004505bb: entered by fall-through of jne at 0x004505b9, 5 instruction(s), ends with jne to 0x004505f7 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004505bb
    mov edx, dword ptr [ebp - local_24]          # 004505be
    mov eax, dword ptr [ecx + field_140]         # 004505c1
    cmp eax, dword ptr [edx + field_158]         # 004505c7
    jne.d8 L_004505f7                            # 004505cd
    # block 0x004505cf: entered by fall-through of jne at 0x004505cd, 5 instruction(s), ends with jne to 0x004505f7 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004505cf
    mov edx, dword ptr [ebp - local_24]          # 004505d2
    mov eax, dword ptr [ecx + field_13c]         # 004505d5
    cmp eax, dword ptr [edx + field_154]         # 004505db
    jne.d8 L_004505f7                            # 004505e1
    # block 0x004505e3: entered by fall-through of jne at 0x004505e1, 5 instruction(s), ends with je to 0x00450630 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004505e3
    mov edx, dword ptr [ebp - local_24]          # 004505e6
    mov eax, dword ptr [ecx + field_144]         # 004505e9
    cmp eax, dword ptr [edx + field_15c]         # 004505ef
    je.d8 L_00450630                             # 004505f5
L_004505f7:
    # block 0x004505f7: entered by jne at 0x004505b9; jne at 0x004505cd; jne at 0x004505e1; fall-through of je at 0x004505f5, 6 instruction(s), ends with jle to 0x00450630 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004505f7
    mov edx, dword ptr [ebp - local_24]          # 004505fa
    mov eax, dword ptr [ecx + field_158]         # 004505fd
    sub eax, dword ptr [edx + field_150]         # 00450603
    test eax, eax                                # 00450609
    jle.d8 L_00450630                            # 0045060b
    # block 0x0045060d: entered by fall-through of jle at 0x0045060b, 6 instruction(s), ends with jle to 0x00450630 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0045060d
    mov edx, dword ptr [ebp - local_24]          # 00450610
    mov eax, dword ptr [ecx + field_15c]         # 00450613
    sub eax, dword ptr [edx + field_154]         # 00450619
    test eax, eax                                # 0045061f
    jle.d8 L_00450630                            # 00450621
    # block 0x00450623: entered by fall-through of jle at 0x00450621, 2 instruction(s), falls into the block at 0x00450630
    mov ecx, dword ptr [ebp - local_24]          # 00450623
    mov dword ptr [ecx + field_160], 0x1         # 00450626
L_00450630:
    # block 0x00450630: entered by jmp at 0x004500aa; jmp at 0x00450263; jmp at 0x004504e8; je at 0x004505f5; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00450630
    pop ebp                                      # 00450632
    ret                                          # 00450633

# --- data items (not part of the function) -------------------------
.org 0x00450634 - 0x401000
SWTAB_00450634:  # 17 case address(es)
    .long L_00450337 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450337 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450337 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450337 - .text + 0x401000
    .long L_00450345 - .text + 0x401000
    .long L_00450337 - .text + 0x401000
    .long L_00450353 - .text + 0x401000
    .long L_00450353 - .text + 0x401000
    .long L_00450353 - .text + 0x401000
    .long L_00450353 - .text + 0x401000
    .long L_00450391 - .text + 0x401000
    .long L_0045036d - .text + 0x401000
.set SWTAB_00450634_VA, SWTAB_00450634 - .text + 0x401000

