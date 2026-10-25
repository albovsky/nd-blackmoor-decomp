# FUN_00450678
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00450678
# extent:       0x00450678-0x00450dbc (1860 code bytes)
# span:         0x00450678-0x00450dd5 (code 1860, tables 25, padding 0)
# sha256:       58177587362846a63da4ac59f72f0a2c84bfa9adf7aab963de938a777874f229
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00450678
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_3c, field_40, field_44, field_48, field_b0, field_c8, field_cc, field_d0, field_164 and 10 more; [ecx + n] field_4, field_8, field_c, field_40, field_44, field_48, field_b4, field_164, field_168, field_16c, field_170, field_184 and 4 more; [edx + n] field_4, field_8, field_c, field_3c, field_40, field_44, field_48, field_b0, field_c8, field_cc, field_d0, field_164 and 9 more
# callees:      calls FUN_00450dd5, FUN_004542f2, FUN_0045432f, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 520 instruction(s), 34 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b4, 0xb4  # offset +0xb4
.equ field_c8, 0xc8  # offset +0xc8
.equ field_cc, 0xcc  # offset +0xcc
.equ field_d0, 0xd0  # offset +0xd0
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_184, 0x184  # offset +0x184
.equ field_254, 0x254  # offset +0x254
.equ field_26c, 0x26c  # offset +0x26c
.equ field_294, 0x294  # offset +0x294
.equ field_29c, 0x29c  # offset +0x29c
.equ field_31c, 0x31c  # offset +0x31c
.equ field_320, 0x320  # offset +0x320
.equ field_324, 0x324  # offset +0x324
.equ field_328, 0x328  # offset +0x328
.equ field_548, 0x548  # offset +0x548
.equ field_54c, 0x54c  # offset +0x54c

# --- external targets -----------------------------------------------
.set FUN_00450dd5, .text + (0x00450dd5 - 0x401000)
.set FUN_004542f2, .text + (0x004542f2 - 0x401000)
.set FUN_0045432f, .text + (0x0045432f - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00450678 - 0x401000
.globl FUN_00450678
FUN_00450678:
    # block 0x00450678: entry, 12 instruction(s), ends with jle to 0x0045070f (forward)
    push ebp                                     # 00450678
    {load} mov ebp, esp                          # 00450679
    sub esp, 0x10                                # 0045067b
    push esi                                     # 0045067e
    mov dword ptr [ebp - local_4], ecx           # 0045067f
    mov eax, dword ptr [ebp - local_4]           # 00450682
    mov dword ptr [eax + field_184], 0xfffffffe  # 00450685
    mov ecx, dword ptr [ebp + arg_8]             # 0045068f
    mov edx, dword ptr [ebp - local_4]           # 00450692
    mov eax, dword ptr [ecx]                     # 00450695
    cmp eax, dword ptr [edx + field_c8]          # 00450697
    jle.d8 L_0045070f                            # 0045069d
    # block 0x0045069f: entered by fall-through of jle at 0x0045069d, 5 instruction(s), ends with jge to 0x0045070f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0045069f
    mov edx, dword ptr [ebp - local_4]           # 004506a2
    mov eax, dword ptr [ecx + field_8]           # 004506a5
    cmp eax, dword ptr [edx + field_d0]          # 004506a8
    jge.d8 L_0045070f                            # 004506ae
    # block 0x004506b0: entered by fall-through of jge at 0x004506ae, 5 instruction(s), ends with jle to 0x0045070f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004506b0
    mov edx, dword ptr [ebp - local_4]           # 004506b3
    mov eax, dword ptr [ecx + field_c]           # 004506b6
    cmp eax, dword ptr [edx + field_cc]          # 004506b9
    jle.d8 L_0045070f                            # 004506bf
    # block 0x004506c1: entered by fall-through of jle at 0x004506bf, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov ecx, dword ptr [ebp + arg_8]             # 004506c1
    mov edx, dword ptr [ebp - local_4]           # 004506c4
    mov eax, dword ptr [edx + field_cc]          # 004506c7
    mov dword ptr [ecx + field_c], eax           # 004506cd
    mov ecx, dword ptr [ebp + arg_8]             # 004506d0
    mov edx, dword ptr [ebp - local_4]           # 004506d3
    mov eax, dword ptr [ecx + field_c]           # 004506d6
    sub eax, dword ptr [edx + field_168]         # 004506d9
    add eax, 0x1                                 # 004506df
    mov ecx, dword ptr [ebp + arg_8]             # 004506e2
    mov dword ptr [ecx + field_4], eax           # 004506e5
    mov edx, dword ptr [ebp + arg_8]             # 004506e8
    mov eax, dword ptr [edx + field_4]           # 004506eb
    mov ecx, dword ptr [ebp - local_4]           # 004506ee
    add eax, dword ptr [ecx + field_170]         # 004506f1
    mov edx, dword ptr [ebp + arg_c]             # 004506f7
    mov dword ptr [edx + field_4], eax           # 004506fa
    mov eax, dword ptr [ebp - local_4]           # 004506fd
    mov dword ptr [eax + field_184], 0x0         # 00450700
    jmp.d32 L_00450c9b                           # 0045070a
L_0045070f:
    # block 0x0045070f: entered by jle at 0x0045069d; jge at 0x004506ae; jle at 0x004506bf, 5 instruction(s), ends with jge to 0x004507ce (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0045070f
    mov edx, dword ptr [ebp - local_4]           # 00450712
    mov eax, dword ptr [ecx]                     # 00450715
    cmp eax, dword ptr [edx + field_3c]          # 00450717
    jge.d32 L_004507ce                           # 0045071a
    # block 0x00450720: entered by fall-through of jge at 0x0045071a, 5 instruction(s), ends with jle to 0x004507ce (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450720
    mov edx, dword ptr [ebp - local_4]           # 00450723
    mov eax, dword ptr [ecx + field_c]           # 00450726
    cmp eax, dword ptr [edx + field_48]          # 00450729
    jle.d32 L_004507ce                           # 0045072c
    # block 0x00450732: entered by fall-through of jle at 0x0045072c, 37 instruction(s), ends with je to 0x004507bc (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450732
    mov edx, dword ptr [ebp - local_4]           # 00450735
    mov eax, dword ptr [edx + field_3c]          # 00450738
    mov dword ptr [ecx], eax                     # 0045073b
    mov ecx, dword ptr [ebp + arg_8]             # 0045073d
    mov edx, dword ptr [ecx]                     # 00450740
    mov eax, dword ptr [ebp - local_4]           # 00450742
    mov ecx, dword ptr [eax + field_164]         # 00450745
    lea edx, [edx + ecx - field_minus_1]         # 0045074b
    mov eax, dword ptr [ebp + arg_8]             # 0045074f
    mov dword ptr [eax + field_8], edx           # 00450752
    mov ecx, dword ptr [ebp + arg_8]             # 00450755
    mov edx, dword ptr [ebp - local_4]           # 00450758
    mov eax, dword ptr [edx + field_48]          # 0045075b
    mov dword ptr [ecx + field_c], eax           # 0045075e
    mov ecx, dword ptr [ebp + arg_8]             # 00450761
    mov edx, dword ptr [ebp - local_4]           # 00450764
    mov eax, dword ptr [ecx + field_c]           # 00450767
    sub eax, dword ptr [edx + field_168]         # 0045076a
    add eax, 0x1                                 # 00450770
    mov ecx, dword ptr [ebp + arg_8]             # 00450773
    mov dword ptr [ecx + field_4], eax           # 00450776
    mov edx, dword ptr [ebp + arg_8]             # 00450779
    mov eax, dword ptr [edx]                     # 0045077c
    mov ecx, dword ptr [ebp - local_4]           # 0045077e
    add eax, dword ptr [ecx + field_16c]         # 00450781
    mov edx, dword ptr [ebp + arg_c]             # 00450787
    mov dword ptr [edx], eax                     # 0045078a
    mov eax, dword ptr [ebp + arg_8]             # 0045078c
    mov ecx, dword ptr [eax + field_4]           # 0045078f
    mov edx, dword ptr [ebp - local_4]           # 00450792
    add ecx, dword ptr [edx + field_170]         # 00450795
    mov eax, dword ptr [ebp + arg_c]             # 0045079b
    mov dword ptr [eax + field_4], ecx           # 0045079e
    mov ecx, dword ptr [ebp - local_4]           # 004507a1
    cmp dword ptr [ecx + field_548], 0x0         # 004507a4
    je.d8 L_004507bc                             # 004507ab
    # block 0x004507ad: entered by fall-through of je at 0x004507ab, 3 instruction(s), ends with forward jump to 0x004507c9
    mov edx, dword ptr [ebp - local_4]           # 004507ad
    mov dword ptr [edx + field_184], 0xd         # 004507b0
    jmp.d8 L_004507c9                            # 004507ba
L_004507bc:
    # block 0x004507bc: entered by je at 0x004507ab, 2 instruction(s), falls into the block at 0x004507c9
    mov eax, dword ptr [ebp - local_4]           # 004507bc
    mov dword ptr [eax + field_184], 0xffffffff  # 004507bf
L_004507c9:
    # block 0x004507c9: entered by jmp at 0x004507ba, 1 instruction(s), ends with forward jump to 0x00450c9b
    jmp.d32 L_00450c9b                           # 004507c9
L_004507ce:
    # block 0x004507ce: entered by jge at 0x0045071a; jle at 0x0045072c, 5 instruction(s), ends with jle to 0x0045088e (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004507ce
    mov edx, dword ptr [ebp - local_4]           # 004507d1
    mov eax, dword ptr [ecx + field_8]           # 004507d4
    cmp eax, dword ptr [edx + field_44]          # 004507d7
    jle.d32 L_0045088e                           # 004507da
    # block 0x004507e0: entered by fall-through of jle at 0x004507da, 5 instruction(s), ends with jle to 0x0045088e (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004507e0
    mov edx, dword ptr [ebp - local_4]           # 004507e3
    mov eax, dword ptr [ecx + field_c]           # 004507e6
    cmp eax, dword ptr [edx + field_48]          # 004507e9
    jle.d32 L_0045088e                           # 004507ec
    # block 0x004507f2: entered by fall-through of jle at 0x004507ec, 37 instruction(s), ends with je to 0x0045087c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004507f2
    mov edx, dword ptr [ebp - local_4]           # 004507f5
    mov eax, dword ptr [edx + field_44]          # 004507f8
    mov dword ptr [ecx + field_8], eax           # 004507fb
    mov ecx, dword ptr [ebp + arg_8]             # 004507fe
    mov edx, dword ptr [ebp - local_4]           # 00450801
    mov eax, dword ptr [ecx + field_8]           # 00450804
    sub eax, dword ptr [edx + field_164]         # 00450807
    add eax, 0x1                                 # 0045080d
    mov ecx, dword ptr [ebp + arg_8]             # 00450810
    mov dword ptr [ecx], eax                     # 00450813
    mov edx, dword ptr [ebp + arg_8]             # 00450815
    mov eax, dword ptr [ebp - local_4]           # 00450818
    mov ecx, dword ptr [eax + field_48]          # 0045081b
    mov dword ptr [edx + field_c], ecx           # 0045081e
    mov edx, dword ptr [ebp + arg_8]             # 00450821
    mov eax, dword ptr [ebp - local_4]           # 00450824
    mov ecx, dword ptr [edx + field_c]           # 00450827
    sub ecx, dword ptr [eax + field_168]         # 0045082a
    add ecx, 0x1                                 # 00450830
    mov edx, dword ptr [ebp + arg_8]             # 00450833
    mov dword ptr [edx + field_4], ecx           # 00450836
    mov eax, dword ptr [ebp + arg_8]             # 00450839
    mov ecx, dword ptr [eax]                     # 0045083c
    mov edx, dword ptr [ebp - local_4]           # 0045083e
    add ecx, dword ptr [edx + field_16c]         # 00450841
    mov eax, dword ptr [ebp + arg_c]             # 00450847
    mov dword ptr [eax], ecx                     # 0045084a
    mov ecx, dword ptr [ebp + arg_8]             # 0045084c
    mov edx, dword ptr [ecx + field_4]           # 0045084f
    mov eax, dword ptr [ebp - local_4]           # 00450852
    add edx, dword ptr [eax + field_170]         # 00450855
    mov ecx, dword ptr [ebp + arg_c]             # 0045085b
    mov dword ptr [ecx + field_4], edx           # 0045085e
    mov edx, dword ptr [ebp - local_4]           # 00450861
    cmp dword ptr [edx + field_548], 0x0         # 00450864
    je.d8 L_0045087c                             # 0045086b
    # block 0x0045086d: entered by fall-through of je at 0x0045086b, 3 instruction(s), ends with forward jump to 0x00450889
    mov eax, dword ptr [ebp - local_4]           # 0045086d
    mov dword ptr [eax + field_184], 0xe         # 00450870
    jmp.d8 L_00450889                            # 0045087a
L_0045087c:
    # block 0x0045087c: entered by je at 0x0045086b, 2 instruction(s), falls into the block at 0x00450889
    mov ecx, dword ptr [ebp - local_4]           # 0045087c
    mov dword ptr [ecx + field_184], 0xffffffff  # 0045087f
L_00450889:
    # block 0x00450889: entered by jmp at 0x0045087a, 1 instruction(s), ends with forward jump to 0x00450c9b
    jmp.d32 L_00450c9b                           # 00450889
L_0045088e:
    # block 0x0045088e: entered by jle at 0x004507da; jle at 0x004507ec, 5 instruction(s), ends with jge to 0x00450933 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0045088e
    mov eax, dword ptr [ebp - local_4]           # 00450891
    mov ecx, dword ptr [edx]                     # 00450894
    cmp ecx, dword ptr [eax + field_3c]          # 00450896
    jge.d32 L_00450933                           # 00450899
    # block 0x0045089f: entered by fall-through of jge at 0x00450899, 5 instruction(s), ends with jge to 0x00450933 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0045089f
    mov eax, dword ptr [ebp - local_4]           # 004508a2
    mov ecx, dword ptr [edx + field_4]           # 004508a5
    cmp ecx, dword ptr [eax + field_40]          # 004508a8
    jge.d32 L_00450933                           # 004508ab
    # block 0x004508b1: entered by fall-through of jge at 0x004508ab, 37 instruction(s), ends with forward jump to 0x00450c9b
    mov edx, dword ptr [ebp + arg_8]             # 004508b1
    mov eax, dword ptr [ebp - local_4]           # 004508b4
    mov ecx, dword ptr [eax + field_3c]          # 004508b7
    mov dword ptr [edx], ecx                     # 004508ba
    mov edx, dword ptr [ebp + arg_8]             # 004508bc
    mov eax, dword ptr [edx]                     # 004508bf
    mov ecx, dword ptr [ebp - local_4]           # 004508c1
    mov edx, dword ptr [ecx + field_164]         # 004508c4
    lea eax, [eax + edx - field_minus_1]         # 004508ca
    mov ecx, dword ptr [ebp + arg_8]             # 004508ce
    mov dword ptr [ecx + field_8], eax           # 004508d1
    mov edx, dword ptr [ebp + arg_8]             # 004508d4
    mov eax, dword ptr [ebp - local_4]           # 004508d7
    mov ecx, dword ptr [eax + field_40]          # 004508da
    mov dword ptr [edx + field_4], ecx           # 004508dd
    mov edx, dword ptr [ebp + arg_8]             # 004508e0
    mov eax, dword ptr [edx + field_4]           # 004508e3
    mov ecx, dword ptr [ebp - local_4]           # 004508e6
    mov edx, dword ptr [ecx + field_168]         # 004508e9
    lea eax, [eax + edx - field_minus_1]         # 004508ef
    mov ecx, dword ptr [ebp + arg_8]             # 004508f3
    mov dword ptr [ecx + field_c], eax           # 004508f6
    mov edx, dword ptr [ebp + arg_8]             # 004508f9
    mov eax, dword ptr [edx]                     # 004508fc
    mov ecx, dword ptr [ebp - local_4]           # 004508fe
    add eax, dword ptr [ecx + field_16c]         # 00450901
    mov edx, dword ptr [ebp + arg_c]             # 00450907
    mov dword ptr [edx], eax                     # 0045090a
    mov eax, dword ptr [ebp + arg_8]             # 0045090c
    mov ecx, dword ptr [eax + field_4]           # 0045090f
    mov edx, dword ptr [ebp - local_4]           # 00450912
    add ecx, dword ptr [edx + field_170]         # 00450915
    mov eax, dword ptr [ebp + arg_c]             # 0045091b
    mov dword ptr [eax + field_4], ecx           # 0045091e
    mov ecx, dword ptr [ebp - local_4]           # 00450921
    mov dword ptr [ecx + field_184], 0xb         # 00450924
    jmp.d32 L_00450c9b                           # 0045092e
L_00450933:
    # block 0x00450933: entered by jge at 0x00450899; jge at 0x004508ab, 5 instruction(s), ends with jle to 0x004509d9 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450933
    mov eax, dword ptr [ebp - local_4]           # 00450936
    mov ecx, dword ptr [edx + field_8]           # 00450939
    cmp ecx, dword ptr [eax + field_44]          # 0045093c
    jle.d32 L_004509d9                           # 0045093f
    # block 0x00450945: entered by fall-through of jle at 0x0045093f, 5 instruction(s), ends with jge to 0x004509d9 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450945
    mov eax, dword ptr [ebp - local_4]           # 00450948
    mov ecx, dword ptr [edx + field_4]           # 0045094b
    cmp ecx, dword ptr [eax + field_40]          # 0045094e
    jge.d32 L_004509d9                           # 00450951
    # block 0x00450957: entered by fall-through of jge at 0x00450951, 37 instruction(s), ends with forward jump to 0x00450c9b
    mov edx, dword ptr [ebp + arg_8]             # 00450957
    mov eax, dword ptr [ebp - local_4]           # 0045095a
    mov ecx, dword ptr [eax + field_44]          # 0045095d
    mov dword ptr [edx + field_8], ecx           # 00450960
    mov edx, dword ptr [ebp + arg_8]             # 00450963
    mov eax, dword ptr [ebp - local_4]           # 00450966
    mov ecx, dword ptr [edx + field_8]           # 00450969
    sub ecx, dword ptr [eax + field_164]         # 0045096c
    add ecx, 0x1                                 # 00450972
    mov edx, dword ptr [ebp + arg_8]             # 00450975
    mov dword ptr [edx], ecx                     # 00450978
    mov eax, dword ptr [ebp + arg_8]             # 0045097a
    mov ecx, dword ptr [ebp - local_4]           # 0045097d
    mov edx, dword ptr [ecx + field_40]          # 00450980
    mov dword ptr [eax + field_4], edx           # 00450983
    mov eax, dword ptr [ebp + arg_8]             # 00450986
    mov ecx, dword ptr [eax + field_4]           # 00450989
    mov edx, dword ptr [ebp - local_4]           # 0045098c
    mov eax, dword ptr [edx + field_168]         # 0045098f
    lea ecx, [ecx + eax - field_minus_1]         # 00450995
    mov edx, dword ptr [ebp + arg_8]             # 00450999
    mov dword ptr [edx + field_c], ecx           # 0045099c
    mov eax, dword ptr [ebp + arg_8]             # 0045099f
    mov ecx, dword ptr [eax]                     # 004509a2
    mov edx, dword ptr [ebp - local_4]           # 004509a4
    add ecx, dword ptr [edx + field_16c]         # 004509a7
    mov eax, dword ptr [ebp + arg_c]             # 004509ad
    mov dword ptr [eax], ecx                     # 004509b0
    mov ecx, dword ptr [ebp + arg_8]             # 004509b2
    mov edx, dword ptr [ecx + field_4]           # 004509b5
    mov eax, dword ptr [ebp - local_4]           # 004509b8
    add edx, dword ptr [eax + field_170]         # 004509bb
    mov ecx, dword ptr [ebp + arg_c]             # 004509c1
    mov dword ptr [ecx + field_4], edx           # 004509c4
    mov edx, dword ptr [ebp - local_4]           # 004509c7
    mov dword ptr [edx + field_184], 0xc         # 004509ca
    jmp.d32 L_00450c9b                           # 004509d4
L_004509d9:
    # block 0x004509d9: entered by jle at 0x0045093f; jge at 0x00450951, 5 instruction(s), ends with jle to 0x00450a4d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004509d9
    mov ecx, dword ptr [ebp - local_4]           # 004509dc
    mov edx, dword ptr [eax + field_c]           # 004509df
    cmp edx, dword ptr [ecx + field_48]          # 004509e2
    jle.d8 L_00450a4d                            # 004509e5
    # block 0x004509e7: entered by fall-through of jle at 0x004509e5, 20 instruction(s), ends with je to 0x00450a3b (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004509e7
    mov ecx, dword ptr [ebp - local_4]           # 004509ea
    mov edx, dword ptr [ecx + field_48]          # 004509ed
    mov dword ptr [eax + field_c], edx           # 004509f0
    mov eax, dword ptr [ebp + arg_8]             # 004509f3
    mov ecx, dword ptr [ebp - local_4]           # 004509f6
    mov edx, dword ptr [eax + field_c]           # 004509f9
    sub edx, dword ptr [ecx + field_168]         # 004509fc
    add edx, 0x1                                 # 00450a02
    mov eax, dword ptr [ebp + arg_8]             # 00450a05
    mov dword ptr [eax + field_4], edx           # 00450a08
    mov ecx, dword ptr [ebp + arg_8]             # 00450a0b
    mov edx, dword ptr [ecx + field_4]           # 00450a0e
    mov eax, dword ptr [ebp - local_4]           # 00450a11
    add edx, dword ptr [eax + field_170]         # 00450a14
    mov ecx, dword ptr [ebp + arg_c]             # 00450a1a
    mov dword ptr [ecx + field_4], edx           # 00450a1d
    mov edx, dword ptr [ebp - local_4]           # 00450a20
    cmp dword ptr [edx + field_548], 0x0         # 00450a23
    je.d8 L_00450a3b                             # 00450a2a
    # block 0x00450a2c: entered by fall-through of je at 0x00450a2a, 3 instruction(s), ends with forward jump to 0x00450a48
    mov eax, dword ptr [ebp - local_4]           # 00450a2c
    mov dword ptr [eax + field_184], 0x6         # 00450a2f
    jmp.d8 L_00450a48                            # 00450a39
L_00450a3b:
    # block 0x00450a3b: entered by je at 0x00450a2a, 2 instruction(s), falls into the block at 0x00450a48
    mov ecx, dword ptr [ebp - local_4]           # 00450a3b
    mov dword ptr [ecx + field_184], 0xffffffff  # 00450a3e
L_00450a48:
    # block 0x00450a48: entered by jmp at 0x00450a39, 1 instruction(s), ends with forward jump to 0x00450c9b
    jmp.d32 L_00450c9b                           # 00450a48
L_00450a4d:
    # block 0x00450a4d: entered by jle at 0x004509e5, 5 instruction(s), ends with jge to 0x00450aca (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450a4d
    mov eax, dword ptr [ebp - local_4]           # 00450a50
    mov ecx, dword ptr [edx]                     # 00450a53
    cmp ecx, dword ptr [eax + field_c8]          # 00450a55
    jge.d8 L_00450aca                            # 00450a5b
    # block 0x00450a5d: entered by fall-through of jge at 0x00450a5b, 5 instruction(s), ends with jle to 0x00450aca (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450a5d
    mov eax, dword ptr [ebp - local_4]           # 00450a60
    mov ecx, dword ptr [edx + field_8]           # 00450a63
    cmp ecx, dword ptr [eax + field_c8]          # 00450a66
    jle.d8 L_00450aca                            # 00450a6c
    # block 0x00450a6e: entered by fall-through of jle at 0x00450a6c, 5 instruction(s), ends with jle to 0x00450aca (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450a6e
    mov eax, dword ptr [ebp - local_4]           # 00450a71
    mov ecx, dword ptr [edx + field_4]           # 00450a74
    cmp ecx, dword ptr [eax + field_cc]          # 00450a77
    jle.d8 L_00450aca                            # 00450a7d
    # block 0x00450a7f: entered by fall-through of jle at 0x00450a7d, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov edx, dword ptr [ebp + arg_8]             # 00450a7f
    mov eax, dword ptr [ebp - local_4]           # 00450a82
    mov ecx, dword ptr [eax + field_c8]          # 00450a85
    mov dword ptr [edx + field_8], ecx           # 00450a8b
    mov edx, dword ptr [ebp + arg_8]             # 00450a8e
    mov eax, dword ptr [ebp - local_4]           # 00450a91
    mov ecx, dword ptr [edx + field_8]           # 00450a94
    sub ecx, dword ptr [eax + field_164]         # 00450a97
    add ecx, 0x1                                 # 00450a9d
    mov edx, dword ptr [ebp + arg_8]             # 00450aa0
    mov dword ptr [edx], ecx                     # 00450aa3
    mov eax, dword ptr [ebp + arg_8]             # 00450aa5
    mov ecx, dword ptr [eax]                     # 00450aa8
    mov edx, dword ptr [ebp - local_4]           # 00450aaa
    add ecx, dword ptr [edx + field_16c]         # 00450aad
    mov eax, dword ptr [ebp + arg_c]             # 00450ab3
    mov dword ptr [eax], ecx                     # 00450ab6
    mov ecx, dword ptr [ebp - local_4]           # 00450ab8
    mov dword ptr [ecx + field_184], 0x1         # 00450abb
    jmp.d32 L_00450c9b                           # 00450ac5
L_00450aca:
    # block 0x00450aca: entered by jge at 0x00450a5b; jle at 0x00450a6c; jle at 0x00450a7d, 5 instruction(s), ends with jge to 0x00450b47 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450aca
    mov eax, dword ptr [ebp - local_4]           # 00450acd
    mov ecx, dword ptr [edx]                     # 00450ad0
    cmp ecx, dword ptr [eax + field_d0]          # 00450ad2
    jge.d8 L_00450b47                            # 00450ad8
    # block 0x00450ada: entered by fall-through of jge at 0x00450ad8, 5 instruction(s), ends with jle to 0x00450b47 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450ada
    mov eax, dword ptr [ebp - local_4]           # 00450add
    mov ecx, dword ptr [edx + field_8]           # 00450ae0
    cmp ecx, dword ptr [eax + field_d0]          # 00450ae3
    jle.d8 L_00450b47                            # 00450ae9
    # block 0x00450aeb: entered by fall-through of jle at 0x00450ae9, 5 instruction(s), ends with jle to 0x00450b47 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00450aeb
    mov eax, dword ptr [ebp - local_4]           # 00450aee
    mov ecx, dword ptr [edx + field_4]           # 00450af1
    cmp ecx, dword ptr [eax + field_cc]          # 00450af4
    jle.d8 L_00450b47                            # 00450afa
    # block 0x00450afc: entered by fall-through of jle at 0x00450afa, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov edx, dword ptr [ebp + arg_8]             # 00450afc
    mov eax, dword ptr [ebp - local_4]           # 00450aff
    mov ecx, dword ptr [eax + field_d0]          # 00450b02
    mov dword ptr [edx], ecx                     # 00450b08
    mov edx, dword ptr [ebp + arg_8]             # 00450b0a
    mov eax, dword ptr [edx]                     # 00450b0d
    mov ecx, dword ptr [ebp - local_4]           # 00450b0f
    mov edx, dword ptr [ecx + field_164]         # 00450b12
    lea eax, [eax + edx - field_minus_1]         # 00450b18
    mov ecx, dword ptr [ebp + arg_8]             # 00450b1c
    mov dword ptr [ecx + field_8], eax           # 00450b1f
    mov edx, dword ptr [ebp + arg_8]             # 00450b22
    mov eax, dword ptr [edx]                     # 00450b25
    mov ecx, dword ptr [ebp - local_4]           # 00450b27
    add eax, dword ptr [ecx + field_16c]         # 00450b2a
    mov edx, dword ptr [ebp + arg_c]             # 00450b30
    mov dword ptr [edx], eax                     # 00450b33
    mov eax, dword ptr [ebp - local_4]           # 00450b35
    mov dword ptr [eax + field_184], 0x2         # 00450b38
    jmp.d32 L_00450c9b                           # 00450b42
L_00450b47:
    # block 0x00450b47: entered by jge at 0x00450ad8; jle at 0x00450ae9; jle at 0x00450afa, 5 instruction(s), ends with jge to 0x00450b9c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450b47
    mov edx, dword ptr [ebp - local_4]           # 00450b4a
    mov eax, dword ptr [ecx]                     # 00450b4d
    cmp eax, dword ptr [edx + field_3c]          # 00450b4f
    jge.d8 L_00450b9c                            # 00450b52
    # block 0x00450b54: entered by fall-through of jge at 0x00450b52, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov ecx, dword ptr [ebp + arg_8]             # 00450b54
    mov edx, dword ptr [ebp - local_4]           # 00450b57
    mov eax, dword ptr [edx + field_3c]          # 00450b5a
    mov dword ptr [ecx], eax                     # 00450b5d
    mov ecx, dword ptr [ebp + arg_8]             # 00450b5f
    mov edx, dword ptr [ecx]                     # 00450b62
    mov eax, dword ptr [ebp - local_4]           # 00450b64
    mov ecx, dword ptr [eax + field_164]         # 00450b67
    lea edx, [edx + ecx - field_minus_1]         # 00450b6d
    mov eax, dword ptr [ebp + arg_8]             # 00450b71
    mov dword ptr [eax + field_8], edx           # 00450b74
    mov ecx, dword ptr [ebp + arg_8]             # 00450b77
    mov edx, dword ptr [ecx]                     # 00450b7a
    mov eax, dword ptr [ebp - local_4]           # 00450b7c
    add edx, dword ptr [eax + field_16c]         # 00450b7f
    mov ecx, dword ptr [ebp + arg_c]             # 00450b85
    mov dword ptr [ecx], edx                     # 00450b88
    mov edx, dword ptr [ebp - local_4]           # 00450b8a
    mov dword ptr [edx + field_184], 0x3         # 00450b8d
    jmp.d32 L_00450c9b                           # 00450b97
L_00450b9c:
    # block 0x00450b9c: entered by jge at 0x00450b52, 5 instruction(s), ends with jle to 0x00450bf2 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00450b9c
    mov ecx, dword ptr [ebp - local_4]           # 00450b9f
    mov edx, dword ptr [eax + field_8]           # 00450ba2
    cmp edx, dword ptr [ecx + field_44]          # 00450ba5
    jle.d8 L_00450bf2                            # 00450ba8
    # block 0x00450baa: entered by fall-through of jle at 0x00450ba8, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov eax, dword ptr [ebp + arg_8]             # 00450baa
    mov ecx, dword ptr [ebp - local_4]           # 00450bad
    mov edx, dword ptr [ecx + field_44]          # 00450bb0
    mov dword ptr [eax + field_8], edx           # 00450bb3
    mov eax, dword ptr [ebp + arg_8]             # 00450bb6
    mov ecx, dword ptr [ebp - local_4]           # 00450bb9
    mov edx, dword ptr [eax + field_8]           # 00450bbc
    sub edx, dword ptr [ecx + field_164]         # 00450bbf
    add edx, 0x1                                 # 00450bc5
    mov eax, dword ptr [ebp + arg_8]             # 00450bc8
    mov dword ptr [eax], edx                     # 00450bcb
    mov ecx, dword ptr [ebp + arg_8]             # 00450bcd
    mov edx, dword ptr [ecx]                     # 00450bd0
    mov eax, dword ptr [ebp - local_4]           # 00450bd2
    add edx, dword ptr [eax + field_16c]         # 00450bd5
    mov ecx, dword ptr [ebp + arg_c]             # 00450bdb
    mov dword ptr [ecx], edx                     # 00450bde
    mov edx, dword ptr [ebp - local_4]           # 00450be0
    mov dword ptr [edx + field_184], 0x5         # 00450be3
    jmp.d32 L_00450c9b                           # 00450bed
L_00450bf2:
    # block 0x00450bf2: entered by jle at 0x00450ba8, 5 instruction(s), ends with jge to 0x00450c49 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00450bf2
    mov ecx, dword ptr [ebp - local_4]           # 00450bf5
    mov edx, dword ptr [eax + field_4]           # 00450bf8
    cmp edx, dword ptr [ecx + field_40]          # 00450bfb
    jge.d8 L_00450c49                            # 00450bfe
    # block 0x00450c00: entered by fall-through of jge at 0x00450bfe, 20 instruction(s), ends with forward jump to 0x00450c9b
    mov eax, dword ptr [ebp + arg_8]             # 00450c00
    mov ecx, dword ptr [ebp - local_4]           # 00450c03
    mov edx, dword ptr [ecx + field_40]          # 00450c06
    mov dword ptr [eax + field_4], edx           # 00450c09
    mov eax, dword ptr [ebp + arg_8]             # 00450c0c
    mov ecx, dword ptr [eax + field_4]           # 00450c0f
    mov edx, dword ptr [ebp - local_4]           # 00450c12
    mov eax, dword ptr [edx + field_168]         # 00450c15
    lea ecx, [ecx + eax - field_minus_1]         # 00450c1b
    mov edx, dword ptr [ebp + arg_8]             # 00450c1f
    mov dword ptr [edx + field_c], ecx           # 00450c22
    mov eax, dword ptr [ebp + arg_8]             # 00450c25
    mov ecx, dword ptr [eax + field_4]           # 00450c28
    mov edx, dword ptr [ebp - local_4]           # 00450c2b
    add ecx, dword ptr [edx + field_170]         # 00450c2e
    mov eax, dword ptr [ebp + arg_c]             # 00450c34
    mov dword ptr [eax + field_4], ecx           # 00450c37
    mov ecx, dword ptr [ebp - local_4]           # 00450c3a
    mov dword ptr [ecx + field_184], 0x4         # 00450c3d
    jmp.d8 L_00450c9b                            # 00450c47
L_00450c49:
    # block 0x00450c49: entered by jge at 0x00450bfe, 5 instruction(s), ends with jl to 0x00450c9b (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00450c49
    mov eax, dword ptr [ebp - local_4]           # 00450c4c
    mov ecx, dword ptr [edx]                     # 00450c4f
    cmp ecx, dword ptr [eax + field_31c]         # 00450c51
    jl.d8 L_00450c9b                             # 00450c57
    # block 0x00450c59: entered by fall-through of jl at 0x00450c57, 5 instruction(s), ends with jg to 0x00450c9b (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00450c59
    mov eax, dword ptr [ebp - local_4]           # 00450c5c
    mov ecx, dword ptr [edx]                     # 00450c5f
    cmp ecx, dword ptr [eax + field_324]         # 00450c61
    jg.d8 L_00450c9b                             # 00450c67
    # block 0x00450c69: entered by fall-through of jg at 0x00450c67, 5 instruction(s), ends with jl to 0x00450c9b (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00450c69
    mov eax, dword ptr [ebp - local_4]           # 00450c6c
    mov ecx, dword ptr [edx + field_4]           # 00450c6f
    cmp ecx, dword ptr [eax + field_320]         # 00450c72
    jl.d8 L_00450c9b                             # 00450c78
    # block 0x00450c7a: entered by fall-through of jl at 0x00450c78, 5 instruction(s), ends with jg to 0x00450c9b (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00450c7a
    mov eax, dword ptr [ebp - local_4]           # 00450c7d
    mov ecx, dword ptr [edx + field_4]           # 00450c80
    cmp ecx, dword ptr [eax + field_328]         # 00450c83
    jg.d8 L_00450c9b                             # 00450c89
    # block 0x00450c8b: entered by fall-through of jg at 0x00450c89, 6 instruction(s), calls FUN_00450dd5, falls into the block at 0x00450c9b
    mov edx, dword ptr [ebp + arg_c]             # 00450c8b
    push edx                                     # 00450c8e
    mov eax, dword ptr [ebp + arg_8]             # 00450c8f
    push eax                                     # 00450c92
    mov ecx, dword ptr [ebp - local_4]           # 00450c93
    call FUN_00450dd5                            # 00450c96
L_00450c9b:
    # block 0x00450c9b: entered by jmp at 0x0045070a; jmp at 0x004507c9; jmp at 0x00450889; jmp at 0x0045092e; more, 5 instruction(s), ends with jl to 0x00450cd2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450c9b
    mov edx, dword ptr [ebp - local_4]           # 00450c9e
    mov eax, dword ptr [ecx + field_4]           # 00450ca1
    cmp eax, dword ptr [edx + field_40]          # 00450ca4
    jl.d8 L_00450cd2                             # 00450ca7
    # block 0x00450ca9: entered by fall-through of jl at 0x00450ca7, 5 instruction(s), ends with jg to 0x00450cd2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450ca9
    mov edx, dword ptr [ebp - local_4]           # 00450cac
    mov eax, dword ptr [ecx + field_c]           # 00450caf
    cmp eax, dword ptr [edx + field_48]          # 00450cb2
    jg.d8 L_00450cd2                             # 00450cb5
    # block 0x00450cb7: entered by fall-through of jg at 0x00450cb5, 5 instruction(s), ends with jl to 0x00450cd2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450cb7
    mov edx, dword ptr [ebp - local_4]           # 00450cba
    mov eax, dword ptr [ecx]                     # 00450cbd
    cmp eax, dword ptr [edx + field_3c]          # 00450cbf
    jl.d8 L_00450cd2                             # 00450cc2
    # block 0x00450cc4: entered by fall-through of jl at 0x00450cc2, 5 instruction(s), ends with jle to 0x00450cdf (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00450cc4
    mov edx, dword ptr [ebp - local_4]           # 00450cc7
    mov eax, dword ptr [ecx + field_8]           # 00450cca
    cmp eax, dword ptr [edx + field_44]          # 00450ccd
    jle.d8 L_00450cdf                            # 00450cd0
L_00450cd2:
    # block 0x00450cd2: entered by jl at 0x00450ca7; jg at 0x00450cb5; jl at 0x00450cc2; fall-through of jle at 0x00450cd0, 2 instruction(s), falls into the block at 0x00450cdf
    mov ecx, dword ptr [ebp - local_4]           # 00450cd2
    mov dword ptr [ecx + field_184], 0x10        # 00450cd5
L_00450cdf:
    # block 0x00450cdf: entered by jle at 0x00450cd0, 5 instruction(s), ends with ja to 0x00450d03 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00450cdf
    mov eax, dword ptr [edx + field_184]         # 00450ce2
    mov dword ptr [ebp - local_8], eax           # 00450ce8
    cmp dword ptr [ebp - local_8], 0x10          # 00450ceb
    ja.d8 L_00450d03                             # 00450cef
    # block 0x00450cf1: entered by fall-through of ja at 0x00450cef, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x450dbc]
    mov edx, dword ptr [ebp - local_8]           # 00450cf1
    {load} xor ecx, ecx                          # 00450cf4
    mov cl, byte ptr [edx + IDXTAB_00450dc4_VA]  # 00450cf6
    jmp dword ptr [4*ecx + SWTAB_00450dbc_VA]    # 00450cfc
L_00450d03:
    # block 0x00450d03: entered by ja at 0x00450cef, 1 instruction(s), ends with forward jump to 0x00450db5
    jmp.d32 L_00450db5                           # 00450d03
L_00450d08:
    # block 0x00450d08: entered by switch case, 3 instruction(s), calls FUN_004542f2, ends with forward jump to 0x00450db5
    mov ecx, dword ptr [ebp - local_4]           # 00450d08
    call FUN_004542f2                            # 00450d0b
    jmp.d32 L_00450db5                           # 00450d10
L_00450d15:
    # block 0x00450d15: entered by switch case, 22 instruction(s), calls FUN_0045432f, FUN_0050ce04, ends with je to 0x00450d99 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00450d15
    call FUN_0045432f                            # 00450d18
    mov eax, dword ptr [ebp - local_4]           # 00450d1d
    mov ecx, dword ptr [eax + field_b0]          # 00450d20
    mov edx, dword ptr [ebp - local_4]           # 00450d26
    fild dword ptr [edx + 4*ecx + field_254]     # 00450d29
    fstp dword ptr [ebp - local_c]               # 00450d30
    mov eax, dword ptr [ebp - local_4]           # 00450d33
    fild dword ptr [eax + field_294]             # 00450d36
    fstp dword ptr [ebp - local_10]              # 00450d3c
    mov ecx, dword ptr [ebp - local_4]           # 00450d3f
    fld dword ptr [ebp - local_10]               # 00450d42
    fmul dword ptr [ecx + field_29c]             # 00450d45
    fadd dword ptr [ebp - local_c]               # 00450d4b
    mov edx, dword ptr [ebp - local_4]           # 00450d4e
    mov esi, dword ptr [edx + field_b0]          # 00450d51
    call FUN_0050ce04                            # 00450d57
    mov ecx, dword ptr [ebp - local_4]           # 00450d5c
    mov dword ptr [ecx + 4*esi + field_254], eax # 00450d5f
    mov edx, dword ptr [ebp - local_4]           # 00450d66
    cmp dword ptr [edx + field_54c], 0x0         # 00450d69
    je.d8 L_00450d99                             # 00450d70
    # block 0x00450d72: entered by fall-through of je at 0x00450d70, 9 instruction(s), ends with forward jump to 0x00450db5
    mov eax, dword ptr [ebp - local_4]           # 00450d72
    mov ecx, dword ptr [eax + field_b0]          # 00450d75
    mov edx, dword ptr [ebp - local_4]           # 00450d7b
    mov eax, dword ptr [edx + field_26c]         # 00450d7e
    mov edx, dword ptr [ebp - local_4]           # 00450d84
    add eax, dword ptr [edx + 4*ecx + field_254] # 00450d87
    mov ecx, dword ptr [ebp - local_4]           # 00450d8e
    mov dword ptr [ecx + field_b4], eax          # 00450d91
    jmp.d8 L_00450db5                            # 00450d97
L_00450d99:
    # block 0x00450d99: entered by je at 0x00450d70, 6 instruction(s), falls into the block at 0x00450db5
    mov edx, dword ptr [ebp - local_4]           # 00450d99
    mov eax, dword ptr [edx + field_b0]          # 00450d9c
    mov ecx, dword ptr [ebp - local_4]           # 00450da2
    mov edx, dword ptr [ebp - local_4]           # 00450da5
    mov eax, dword ptr [edx + 4*eax + field_254] # 00450da8
    mov dword ptr [ecx + field_b4], eax          # 00450daf
L_00450db5:
    # block 0x00450db5: entered by jmp at 0x00450d03; jmp at 0x00450d10; jmp at 0x00450d97, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 00450db5
    {load} mov esp, ebp                          # 00450db6
    pop ebp                                      # 00450db8
    ret 0x8                                      # 00450db9

# --- data items (not part of the function) -------------------------
.org 0x00450dbc - 0x401000
SWTAB_00450dbc:  # 2 case address(es)
    .long L_00450d08 - .text + 0x401000
    .long L_00450d15 - .text + 0x401000
.org 0x00450dc4 - 0x401000
IDXTAB_00450dc4:  # index table of FUN_00450678 for the switch jump at 0x00450cfc (17 byte(s))
    .byte 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1
    .byte 0
.set SWTAB_00450dbc_VA, SWTAB_00450dbc - .text + 0x401000
.set IDXTAB_00450dc4_VA, IDXTAB_00450dc4 - .text + 0x401000

